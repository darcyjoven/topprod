# Prog. Version..: '5.30.06-13.04.02(00006)'     #
#
# Pattern name...: artq630.4gl
# Descriptions...: 訂金退回明細查詢
# Date & Author..: No: FUN-870007 09/02/26 By Zhangyajun
# Modify.........: No: FUN-870100 09/09/02 By Cockroach 流通別超市移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10031 10/01/07 By destiny DB取值请取实体DB 
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-AB0025 10/12/20 By 點右側款別明細功能鈕，程序DOWN出
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤
# Modify.........: No:FUN-D30097 13/04/01 By Sakura 訂金退回單據優化

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rxa   DYNAMIC ARRAY OF RECORD        
               rxaplant       LIKE rxa_file.rxaplant,
               rxaplant_desc  LIKE azp_file.azp02,
               rxa01        LIKE rxa_file.rxa01,
               rxa09        LIKE rxa_file.rxa09, #FUN-D30097 add
               rxa02        LIKE rxa_file.rxa02,
               rxa03        LIKE rxa_file.rxa03,   
               rxa03_desc   LIKE occ_file.occ03,
               occ930       LIKE occ_file.occ930,
               occ930_type  LIKE type_file.chr1,
               occ71        LIKE occ_file.occ71,
               rxa04        LIKE rxa_file.rxa04,
               rxa05        LIKE rxa_file.rxa05,
               rxa06        LIKE rxa_file.rxa06,
               rxa07        LIKE rxa_file.rxa07,
               rxaconf      LIKE rxa_file.rxaconf,
               rxacond      LIKE rxa_file.rxacond,
               rxacont      LIKE rxa_file.rxacont,
               rxaconu      LIKE rxa_file.rxaconu,
               rxaconu_desc LIKE gen_file.gen02,
               rxaacti      LIKE rxa_file.rxaacti
               END RECORD,
       g_rxb   DYNAMIC ARRAY OF RECORD        
               rxb02      LIKE rxb_file.rxb02,
               rxb03      LIKE rxb_file.rxb03,
               rxb04      LIKE rxb_file.rxb04,
               rxb05      LIKE rxb_file.rxb05,
               rxb05_desc LIKE gen_file.gen02,
               rxb06      LIKE rxb_file.rxb06
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
DEFINE g_dbs  LIKE azp_file.azp03
DEFINE g_sql2 STRING 
DEFINE g_chk_rxaplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_argv1 LIKE rxa_file.rxa01
DEFINE g_argv2 LIKE rxa_file.rxaplant
DEFINE g_flag STRING
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10031 
 
MAIN
 
   OPTIONS                     
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q630_w AT p_row,p_col WITH FORM "art/42f/artq630"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL q630_q()
   END IF
   CALL q630_menu()
 
   CLOSE WINDOW q630_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q630_menu()
 
   WHILE TRUE
     CASE g_flag
        WHEN "page1" CALL q630_bp()
        WHEN "page2" CALL q630_bp2()
        OTHERWISE    CALL q630_bp()
     END CASE 
     CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q630_q()
            END IF
         WHEN "money_detail"
            LET l_ac = ARR_CURR()    #TQC-AB0025 add
            IF NOT cl_null(l_ac) AND  l_ac != 0 THEN  #TQC-AB0025 add
               CALL s_pay_detail('04',g_rxa[l_ac].rxa01,g_rxa[l_ac].rxaplant,g_rxa[l_ac].rxaconf)
            END IF   #TQC-AB0025 add 
         WHEN "view1"
            LET g_flag = "page2"
 
         WHEN "return"
            LET g_flag = "page1"
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-B90091 add START
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxa),base.TypeInfo.create(g_rxb),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q630_q()
 
   CALL q630_b_askkey()
 
END FUNCTION
 
FUNCTION q630_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add 
   CLEAR FORM
   CALL g_rxa.clear()
   CALL g_rxb.clear()
 
   LET g_chk_rxaplant = TRUE 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " rxa01 = '",g_argv1,"' AND rxaplant = '",g_argv2,"'"
      LET g_wc2 = " 1=1"
      LET g_chk_rxaplant = FALSE
   ELSE   
   CONSTRUCT g_wc ON rxaplant, rxa01, rxa09,  rxa02,  rxa03, #FUN-D30097 add rxa09
                     rxa04,  rxa05,  rxa06,  rxa07,
                     rxaconf,rxacond,rxacont,rxaconu,
                     rxaacti
                FROM s_rxa[1].rxaplant, s_rxa[1].rxa01, s_rxa[1].rxa09,  s_rxa[1].rxa02,  s_rxa[1].rxa03, #FUN-D30097 add rxa09
                     s_rxa[1].rxa04,  s_rxa[1].rxa05,  s_rxa[1].rxa06,  s_rxa[1].rxa07,
                     s_rxa[1].rxaconf,s_rxa[1].rxacond,s_rxa[1].rxacont,s_rxa[1].rxaconu,        
                     s_rxa[1].rxaacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD rxaplant
         IF get_fldbuf(rxaplant) IS NOT NULL THEN
            LET g_chk_rxaplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(rxaplant)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxaplant
                   NEXT FIELD rxaplant
 
              WHEN INFIELD(rxa03)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ02"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxa03
                   NEXT FIELD rxa03
                   
              WHEN INFIELD(rxaconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rxaconu
                   NEXT FIELD rxaconu
                   
              OTHERWISE EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
         
      ON ACTION qbe_select                         	  
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   
   CONSTRUCT g_wc2 ON rxb02,rxb03,rxb04,rxb05,
                      rxb06
                 FROM s_rxb[1].rxb02,s_rxb[1].rxb03,s_rxb[1].rxb04,s_rxb[1].rxb05,
                      s_rxb[1].rxb06
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)           
        ON ACTION controlp
           CASE
           WHEN INFIELD(rxb05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen5"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rxb05
                NEXT FIELD rxb05
           END CASE
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
        ON ACTION about         
          CALL cl_about()      
 
        ON ACTION help         
          CALL cl_show_help()
 
        ON ACTION controlg   
          CALL cl_cmdask() 
 
        ON ACTION qbe_save                        
          CALL cl_qbe_save()
		
    END CONSTRUCT
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
    #       LET g_wc = g_wc CLIPPED," AND rxauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #       LET g_wc = g_wc CLIPPED," AND rxagrup MATCHES '",
    #                 g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN
    #       LET g_wc = g_wc CLIPPED," AND rxagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rxauser', 'rxagrup')
    #End:FUN-980030
    LET g_chk_auth = ''
    IF g_chk_rxaplant THEN
      DECLARE q630_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q630_zxy_cs INTO l_zxy03
#TQC-B90175 add START------------------------------
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
      IF NOT cl_chk_schema_has_built(l_azp03) THEN
         CONTINUE FOREACH
      END IF
#TQC-B90175 add END--------------------------------
        IF g_chk_auth IS NULL THEN
           LET g_chk_auth = "'",l_zxy03,"'"
        ELSE
           LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
        END IF
      END FOREACH
      IF g_chk_auth IS NOT NULL THEN
         LET g_chk_auth = "(",g_chk_auth,")"
      END IF
    END IF
  
    LET l_ac = 1 
    CALL q630_b_fill(g_wc,g_wc2)
    CALL q630_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION q630_b_fill(p_wc,p_wc2)              
DEFINE p_wc,p_wc2 STRING        
DEFINE l_dbs  LIKE azp_file.azp03 
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
    #NO.TQC-A10031-- begin
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
    #            " WHERE zxy01 = '",g_user,"' ",
    #            "   AND zxy03 = azp01  "
    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "
    IF NOT cl_null(g_argv2) THEN
#       LET g_sql = g_sql," AND azp01 = '",g_argv2,"'"
        LET g_sql = g_sql," AND zxy03 = '",g_argv2,"'" 
    END IF 
    PREPARE q630_pre FROM g_sql
    DECLARE q630_DB_cs CURSOR FOR q630_pre
    LET g_sql2 = ''
#    FOREACH q630_DB_cs INTO g_dbs
    FOREACH q630_DB_cs INTO g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q630_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
#TQC-B90175 add START------------------------------
       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = g_zxy03
       IF NOT cl_chk_schema_has_built(l_azp03) THEN
          CONTINUE FOREACH
       END IF
#TQC-B90175 add END--------------------------------
       #FUN-A50102 ---mark---str---
       #LET g_plant_new = g_zxy03
       #CALL s_gettrandbs()
       #LET g_dbs=g_dbs_tra CLIPPED   
       #LET g_dbs = s_dbstring(g_dbs CLIPPED) 
       #FUN-A50102 ---mark---end---
    #NO.TQC-A10031--end
       IF p_wc2 = " 1=1" THEN
          LET g_sql = "SELECT DISTINCT rxaplant,'',rxa01,rxa09,rxa02,rxa03,'','','','',", #FUN-D30097 add rxa09
                      "       rxa04,rxa05,rxa06,rxa07,rxaconf,rxacond,",
                      "       rxacont,rxaconu,'',rxaacti",
#                     "  FROM ",g_dbs CLIPPED,".rxa_file,azp_file",
                     #"  FROM ",g_dbs,"rxa_file,azp_file", #FUN-A50102
                      "  FROM ",cl_get_target_table(g_zxy03, 'rxa_file'),",","azp_file", #FUN-A50102
#                     " WHERE rxaplant = azp01 AND azp03 = '",g_dbs CLIPPED,"'",
                      " WHERE rxaplant = azp01 AND azp01 = '",g_zxy03 CLIPPED,"'",
                      "   AND ",p_wc
       ELSE
          LET g_sql = "SELECT DISTINCT rxaplant,'',rxa01,rxa09,rxa02,rxa03,'','','','',", #FUN-D30097 add rxa09
                      "       rxa04,rxa05,rxa06,rxa07,rxaconf,rxacond,",
                      "       rxacont,rxaconu,'',rxaacti",
                     #"  FROM ",g_dbs CLIPPED,".rxa_file,",g_dbs CLIPPED,".rxb_file,azp_file",
                     #"  FROM ",g_dbs,"rxa_file,",g_dbs,"rxb_file,azp_file", #FUN-A50102
                      "  FROM ",cl_get_target_table(g_zxy03, 'rxa_file'),",",cl_get_target_table(g_zxy03, 'rxb_file'),",","azp_file", #FUN-A50102 
                      " WHERE rxa01 = rxb01 AND rxaplant = rxbplant",
                     #"   AND rxaplant = azp01 AND azp03 = '",g_dbs CLIPPED,"'",
                      "   AND rxaplant = azp01 AND azp01 = '",g_zxy03 CLIPPED,"'",
                      "   AND ",p_wc
       END IF
       IF g_chk_rxaplant THEN
          LET g_sql = "(",g_sql," AND rxaplant IN ",g_chk_auth,")"
       ELSE
          LET g_sql = "(",g_sql,")"
       END IF
       IF g_sql2 IS NULL THEN
          LET g_sql2 = g_sql
       ELSE
          LET g_sql = g_sql2," UNION ALL ",g_sql
          LET g_sql2 = g_sql
       END IF
    END FOREACH
    
    PREPARE q630_pb FROM g_sql
    DECLARE q630_cs CURSOR FOR q630_pb
 
    CALL g_rxa.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q630_cs INTO g_rxa[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q630_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        #NO.TQC-A10050-- begin
        #SELECT azp02,azp03
        #  INTO g_rxa[g_cnt].rxaplant_desc,l_dbs
        #  FROM azp_file
        # WHERE azp01 = g_rxa[g_cnt].rxaplant
        SELECT azp02 INTO g_rxa[g_cnt].rxaplant_desc     
         FROM azp_file WHERE azp01 = g_rxa[g_cnt].rxaplant
        LET g_plant_new = g_rxa[g_cnt].rxaplant
        CALL s_gettrandbs()
        LET l_dbs=g_dbs_tra 
        LET l_dbs = s_dbstring(l_dbs CLIPPED)
        
        SELECT gen02 INTO g_rxa[g_cnt].rxaconu_desc
          FROM gen_file
         WHERE gen01 = g_rxa[g_cnt].rxaconu
           AND genacti = 'Y'
        #LET g_sql = "SELECT occ02,occ71,occ930 FROM ",l_dbs CLIPPED,".occ_file",
        #LET g_sql = "SELECT occ02,occ71,occ930 FROM ",l_dbs CLIPPED,"occ_file", #FUN-A50102
         LET g_sql = "SELECT occ02,occ71,occ930 FROM ",cl_get_target_table(g_rxa[g_cnt].rxaplant, 'occ_file'), #FUN-A50102
        #NO.TQC-A10041-- end
                " WHERE occ01 = ? AND occacti = 'Y'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_rxa[g_cnt].rxaplant) RETURNING g_sql    #FUN-A50102        
        PREPARE q630_occ_cs FROM g_sql
        EXECUTE q630_occ_cs USING g_rxa[g_cnt].rxa03
                             INTO g_rxa[g_cnt].rxa03_desc,g_rxa[g_cnt].occ71,
                                  g_rxa[g_cnt].occ930
        IF g_rxa[g_cnt].occ930 IS NULL THEN
           LET g_rxa[g_cnt].occ930_type = '1'
        ELSE
           LET g_rxa[g_cnt].occ930_type = '2'
        END IF           
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rxa.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q630_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03  
    #NO.TQC-A10031-- begin
    #SELECT azp03 INTO l_dbs
    #  FROM azp_file
    # WHERE azp01 = g_rxa[l_ac].rxaplant
    #FUN-A50102 ---mark---str---
     #LET g_plant_new = g_rxa[l_ac].rxaplant
     #CALL s_gettrandbs()
     #LET l_dbs=g_dbs_tra 
     #LET l_dbs = s_dbstring(l_dbs CLIPPED)
     #FUN-A50102 ---mark---end---        
    #NO.TQC-A10031--end      
    LET g_sql = "SELECT DISTINCT rxb02,rxb03,rxb04,rxb05,'',rxb06",
               #"  FROM ",l_dbs CLIPPED,".rxb_file",
               #"  FROM ",l_dbs CLIPPED,"rxb_file", #FUN-A50102
                "  FROM ",cl_get_target_table(g_rxa[l_ac].rxaplant, 'rxb_file'), #FUN-A50102
                " WHERE rxb01 = '",g_rxa[l_ac].rxa01,"'",
                "   AND rxbplant = '",g_rxa[l_ac].rxaplant,"'",
                "   AND ",p_wc2
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rxa[l_ac].rxaplant) RETURNING g_sql    #FUN-A50102            
    PREPARE q630_pb2 FROM g_sql
    DECLARE q630_cs2 CURSOR FOR q630_pb2
    
    CALL g_rxb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q630_cs2 INTO g_rxb[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q630_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF       
        SELECT gen02 INTO g_rxb[g_cnt].rxb05_desc
          FROM gen_file
         WHERE gen01 = g_rxb[g_cnt].rxb05
           AND genacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rxb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q630_bp2()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rxb TO s_rxb.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac2 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
 
      ON ACTION return
         LET g_action_choice = "return"
         EXIT DISPLAY
      
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="return"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()

#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION q630_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_rxa TO s_rxa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b!=0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q630_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_rxb TO s_rxb.* ATTRIBUTE(COUNT=g_rec_b2)
              BEFORE DISPLAY
                EXIT DISPLAY
            END DISPLAY
         END IF
         CALL cl_show_fld_cont()
   
      ON ACTION money_detail
         LET g_action_choice = "money_detail"
         EXIT DISPLAY
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION view1
         LET g_action_choice = "view1"
         EXIT DISPLAY

#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END 

   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
#FUN-870100
