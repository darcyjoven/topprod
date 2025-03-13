# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: artq715.4gl
# Descriptions...: 請購明細查詢作業 
# Date & Author..: No: FUN-870100 09/02/26 By lala
# Modify.........: No.FUN-870007 09/09/02 By Zhangyajun 程序移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10044 10/01/07 By destiny DB取值请取实体DB 
# Modify.........: No.FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ruu   DYNAMIC ARRAY OF RECORD        
               ruuplant       LIKE ruu_file.ruuplant,
               ruuplant_desc  LIKE azp_file.azp02,
               ruu01        LIKE ruu_file.ruu01,
               ruu02        LIKE ruu_file.ruu02,
               ruu03        LIKE ruu_file.ruu03,
               ruu04        LIKE ruu_file.ruu04,
               ruu04_desc   LIKE imd_file.imd02,
               jce02        LIKE jce_file.jce02,
               ruu05        LIKE ruu_file.ruu05,               
               ruu05_desc   LIKE gen_file.gen02,
               ruu06        LIKE ruu_file.ruu06,
               ruu900       LIKE ruu_file.ruu900,
               ruuconf      LIKE ruu_file.ruuconf,
               ruucond      LIKE ruu_file.ruucond,
               ruucont      LIKE ruu_file.ruucont,
               ruuconu      LIKE ruu_file.ruuconu,
               ruuconu_desc LIKE gen_file.gen02,
               ruucrat      LIKE ruu_file.ruucrat, 
               ruudate      LIKE ruu_file.ruudate,
               ruugrup      LIKE ruu_file.ruugrup,
               ruumodu      LIKE ruu_file.ruumodu,
               ruuuser      LIKE ruu_file.ruuuser,
               ruuacti      LIKE ruu_file.ruuacti
               END RECORD,
       g_ruv   DYNAMIC ARRAY OF RECORD        # 明細
               ruv02      LIKE ruv_file.ruv02,
               ruv03      LIKE ruv_file.ruv03,
               ruv04      LIKE ruv_file.ruv04,
               ruv04_desc LIKE ima_file.ima02,
               ruv05      LIKE ruv_file.ruv05,
               ruv05_desc LIKE gfe_file.gfe02,
               ruv06      LIKE ruv_file.ruv06,
               ruv10      LIKE ruv_file.ruv10
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5,
       g_argv1        LIKE ruu_file.ruu02,
       g_argv2        LIKE ruu_file.ruuplant 
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
#DEFINE g_dbs  LIKE azp_file.azp03 #FUN-A50102
DEFINE g_sql2 STRING 
DEFINE g_chk_ruuplant LIKE type_file.chr1
DEFINE g_chk_auth STRING  
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10044
 
 
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
 
   OPEN WINDOW q715_w AT p_row,p_col WITH FORM "art/42f/artq715"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL q715_q()
   END IF
 
   CALL q715_menu()
 
   CLOSE WINDOW q715_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q715_menu()
 
   WHILE TRUE
      CALL q715_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q715_q()
            END IF
 
         WHEN "view"
              CALL q715_bp2()
 
         WHEN "return"
              CALL q715_bp()
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

#FUN-B90091 add START
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ruu),base.TypeInfo.create(g_ruv),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q715_q()
 
   CALL q715_b_askkey()
 
END FUNCTION
 
FUNCTION q715_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
 
   CLEAR FORM
   CALL g_ruu.clear()
   CALL g_ruv.clear()
 
   LET g_chk_ruuplant = TRUE 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " ruu02 = '",g_argv1,"' AND ruuplant = '",g_argv2,"'"
      LET g_wc2 =" 1=1"
   ELSE
      
   CONSTRUCT g_wc ON ruuplant,ruu01,ruu02,ruu03,ruu04,ruu05,ruu06,ruu900,
                     ruuconf,ruucond,ruucont,ruuconu,
                     ruucrat,ruudate,ruugrup,ruumodu,ruuuser,ruuacti
                FROM s_ruu[1].ruuplant,s_ruu[1].ruu01,s_ruu[1].ruu02,s_ruu[1].ruu03,
                     s_ruu[1].ruu04,s_ruu[1].ruu05,s_ruu[1].ruu06,s_ruu[1].ruu900,
                     s_ruu[1].ruuconf,s_ruu[1].ruucond,s_ruu[1].ruucont,s_ruu[1].ruuconu,
                     s_ruu[1].ruucrat,s_ruu[1].ruudate,s_ruu[1].ruugrup,s_ruu[1].ruumodu,s_ruu[1].ruuuser,s_ruu[1].ruuacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD ruuplant
         IF get_fldbuf(ruuplant) IS NOT NULL THEN
            LET g_chk_ruuplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ruuplant)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruuplant
                   NEXT FIELD ruuplant
 
              WHEN INFIELD(ruu04)
                   CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_imd02"   #FUN-AA0062 mark
                   LET g_qryparam.form = "q_imd003"   #FUN-AA0062 add 
                   LET g_qryparam.arg1 = "SW"         #FUN-AA0062 add 
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruu04
                   NEXT FIELD ruu04
 
              WHEN INFIELD(ruu05)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruu05
                   NEXT FIELD ruu05
 
              WHEN INFIELD(ruuconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruuconu
                   NEXT FIELD ruuconu
                   
              WHEN INFIELD(ruumodu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruumodu
                   NEXT FIELD ruumodu
                   
              WHEN INFIELD(ruuuser)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruuuser
                   NEXT FIELD ruuuser
 
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
   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           
   #      LET g_wc = g_wc CLIPPED," AND ruuuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           
   #      LET g_wc = g_wc CLIPPED," AND ruugrup MATCHES '",
   #                 g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              
   #      LET g_wc = g_wc CLIPPED," AND ruugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruuuser', 'ruugrup')
   #End:FUN-980030
   
   CONSTRUCT g_wc2 ON ruv02,ruv03,ruv04,ruv05,ruv06,ruv10
                 FROM s_ruv[1].ruv02,s_ruv[1].ruv03,s_ruv[1].ruv04,
                      s_ruv[1].ruv05,s_ruv[1].ruv06,s_ruv[1].ruv10
                      
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(ruv04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruv04
                 NEXT FIELD ruv04
              WHEN INFIELD(ruv05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruv05
                 NEXT FIELD ruv05
              OTHERWISE
                 EXIT CASE
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
    END IF
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    LET g_chk_auth = ''
    IF g_chk_ruuplant THEN
      DECLARE q715_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q715_zxy_cs INTO l_zxy03
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
    CALL q715_b_fill(g_wc,g_wc2)
    CALL q715_b2_fill(g_wc2)
 
END FUNCTION
 
FUNCTION q715_b_fill(p_wc,p_wc2)              
DEFINE p_wc STRING        
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_n   LIKE type_file.num5
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add

    #NO.TQC-A10044--begin
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
    #            " WHERE zxy01 = '",g_user,"' ",
    #            "   AND zxy03 = azp01  "
    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "
    
    PREPARE q715_pre FROM g_sql
    DECLARE q715_DB_cs CURSOR FOR q715_pre
    LET g_sql2 = ''
    #FOREACH q715_DB_cs INTO g_dbs
    FOREACH q715_DB_cs INTO g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q715_DB_cs',SQLCA.sqlcode,1)
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
       #LET g_dbs=g_dbs_tra         
       #FUN-A50102 ---mark---end---
    #NO.TQC-A10043--end       
    IF p_wc2 =" 1=1" THEN
       LET g_sql = "SELECT DISTINCT ruuplant,azp02,ruu01,ruu02,ruu03,ruu04,'','',ruu05,'',ruu06,ruu900,",
                   "       ruuconf,ruucond,ruucont,ruuconu,'', ",
                   "       ruucrat,ruudate,ruugrup,ruumodu,ruuuser,ruuacti ",
                   #"  FROM ",s_dbstring(g_dbs CLIPPED),"ruu_file,azp_file", #FUN-A50102
                   "  FROM ",cl_get_target_table(g_zxy03, 'ruu_file'),",","azp_file", #FUN-A50102
                   #" WHERE ruuplant = azp01 AND azp03 = '",g_dbs CLIPPED,"'",
                    " WHERE ruuplant = azp01 AND azp01 = '",g_zxy03 CLIPPED,"'",
                   "   AND ",p_wc
    ELSE
       LET g_sql = "SELECT DISTINCT ruuplant,azp02,ruu01,ruu02,ruu03,ruu04,'','',ruu05,'',ruu06,ruu900,",
                   "       ruuconf,ruucond,ruucont,ruuconu,'', ",
                   "       ruucrat,ruudate,ruugrup,ruumodu,ruuuser,ruuacti ",
                  #"  FROM ",s_dbstring(g_dbs CLIPPED),"ruu_file,",s_dbstring(g_dbs CLIPPED),"ruv_file,azp_file", #FUN-A50102
                   "  FROM ",cl_get_target_table(g_zxy03, 'ruu_file'),",",cl_get_target_table(g_zxy03, 'ruv_file'),",","azp_file", #FUN-A50102
                   " WHERE ruu01 = ruv01 AND ruuplant = ruvplant ",
                  #"   AND ruuplant = azp01 AND azp03 = '",g_dbs CLIPPED,"'",
                   "   AND ruuplant = azp01 AND azp01 = '",g_zxy03 CLIPPED,"'",
                   "   AND ",p_wc," AND ",p_wc2
    END IF
       IF g_chk_ruuplant THEN
          LET g_sql = "(",g_sql," AND ruuplant IN ",g_chk_auth,")"
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
    
    PREPARE q715_pb FROM g_sql
    DECLARE q715_cs CURSOR FOR q715_pb
 
    CALL g_ruu.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q715_cs INTO g_ruu[g_cnt].*
        IF STATUS THEN 
           CALL cl_err('foreach q715_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        SELECT imd02 INTO g_ruu[g_cnt].ruu04_desc
          FROM imd_file
         WHERE imd01 = g_ruu[g_cnt].ruu04
        SELECT COUNT(*) INTO l_n
          FROM jce_file
         WHERE jce02 = g_ruu[g_cnt].ruu04
        IF l_n>0 THEN LET g_ruu[g_cnt].jce02 = 'Y' ELSE LET g_ruu[g_cnt].jce02 = 'N' END IF
        SELECT gen02 INTO g_ruu[g_cnt].ruu05_desc
          FROM gen_file
         WHERE gen01 = g_ruu[g_cnt].ruu05
        SELECT gen02 INTO g_ruu[g_cnt].ruuconu_desc
          FROM gen_file
         WHERE gen01 = g_ruu[g_cnt].ruuconu
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ruu.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q715_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_ruu01 LIKE ruu_file.ruu01
    #NO.TQC-A10043-- begin
    #SELECT azp03 INTO l_dbs
    #  FROM azp_file
    # WHERE azp01 = g_ruu[l_ac].ruuplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_ruu[l_ac].ruuplant
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra         
    #FUN-A50102 ---mark---end---
    #NO.TQC-A10043--end       
    LET g_sql = "SELECT ruv02,ruv03,ruv04,'',ruv05,'',ruv06,ruv10",
                #"  FROM ",s_dbstring(l_dbs CLIPPED),"ruv_file", #FUN-A50102
                "  FROM ",cl_get_target_table(g_ruu[l_ac].ruuplant, 'ruv_file'), #FUn-A50102
                " WHERE ruv01 = '",g_ruu[l_ac].ruu01,"'",
                "   AND ruvplant = '",g_ruu[l_ac].ruuplant,"'",
                "   AND ",p_wc2
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_ruu[l_ac].ruuplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q715_pb2 FROM g_sql
    DECLARE q715_cs2 CURSOR FOR q715_pb2
    
    #LET g_sql = "SELECT ima02 FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A50102
    LET g_sql = "SELECT ima02 FROM ",cl_get_target_table(g_ruu[l_ac].ruuplant, 'ima_file'), #FUN-A50102
                " WHERE ima01 = ? AND imaacti = 'Y'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_ruu[l_ac].ruuplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q715_ima02_cs FROM g_sql
    
    #LET g_sql = "SELECT gfe02 FROM ",s_dbstring(l_dbs CLIPPED),"gfe_file", #FUN-A50102
    LET g_sql = "SELECT gfe02 FROM ",cl_get_target_table(g_ruu[l_ac].ruuplant, 'gfe_file'), #FUN-A50102
                " WHERE gfe01 = ? AND gfeacti = 'Y'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_ruu[l_ac].ruuplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q715_gfe02_cs2 FROM g_sql
    
    CALL g_ruv.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q715_cs2 INTO g_ruv[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q715_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF
 
        EXECUTE q715_ima02_cs USING g_ruv[g_cnt].ruv04
                              INTO g_ruv[g_cnt].ruv04_desc
 
        EXECUTE q715_gfe02_cs2 USING g_ruv[g_cnt].ruv05
                               INTO g_ruv[g_cnt].ruv05_desc
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ruv.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q715_bp2()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ruv TO s_ruv.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac2 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
 
      ON ACTION return
         LET g_action_choice = "return"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION q715_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_ruu TO s_ruu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b != 0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q715_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_ruv TO s_ruv.* ATTRIBUTE(COUNT=g_rec_b2)
              BEFORE DISPLAY
                EXIT DISPLAY
            END DISPLAY
         END IF
         CALL cl_show_fld_cont()
         
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
 
      ON ACTION VIEW
         LET g_action_choice = "view"
         EXIT DISPLAY

#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
#No.FUN-870007
