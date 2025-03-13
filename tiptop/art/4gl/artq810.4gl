# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: artq810.4gl
# Descriptions...: 機構調撥明顯查詢 
# Date & Author..: No: FUN-870008 09/03/09 By Mike
# Modify.........: No.FUN-870007 09/08/25 By Zhangyajun 程序移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10048 10/01/07 By destiny DB取值请取实体DB 
# Modify.........: No.FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No:FUN-B50042 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ruo   DYNAMIC ARRAY OF RECORD        #机构調撥單
               ruoplant     LIKE ruo_file.ruoplant,
               ruoplant_desc  LIKE azp_file.azp02,
               ruo07        LIKE ruo_file.ruo07,
               ruo01        LIKE ruo_file.ruo01,
               ruo02        LIKE ruo_file.ruo02,
               ruo03        LIKE ruo_file.ruo03,
               ruo04        LIKE ruo_file.ruo04,
               ruo05        LIKE ruo_file.ruo05,
               ruo06        LIKE ruo_file.ruo06,
               ruo08        LIKE ruo_file.ruo08,
               gen02        LIKE gen_file.gen02,
               ruo09        LIKE ruo_file.ruo09,              
               ruopos       LIKE ruo_file.ruopos,    
               ruoconf      LIKE ruo_file.ruoconf,
               ruo10        LIKE ruo_file.ruo10,
               ruo11        LIKE ruo_file.ruo11,
               ruo12        LIKE ruo_file.ruo12,
               ruo13        LIKE ruo_file.ruo13,
               ruoacti      LIKE ruo_file.ruoacti,
               ruocrat      LIKE ruo_file.ruocrat,
               ruouser      LIKE ruo_file.ruouser,
               ruogrup      LIKE ruo_file.ruogrup,
               ruodate      LIKE ruo_file.ruodate,
               ruomodu      LIKE ruo_file.ruomodu
               END RECORD,
       g_rup   DYNAMIC ARRAY OF RECORD        
               rup02      LIKE rup_file.rup02,
               rup03      LIKE rup_file.rup03,
               ima02      LIKE ima_file.ima02,
               rup04      LIKE rup_file.rup04,
               rup06      LIKE rup_file.rup06,
               rup07      LIKE rup_file.rup07,
               rup08      LIKE rup_file.rup08,
               rup09      LIKE rup_file.rup09,
               rup10      LIKE rup_file.rup10,
               rup11      LIKE rup_file.rup11,
               rup12      LIKE rup_file.rup12,
               rup13      LIKE rup_file.rup13,
               rup14      LIKE rup_file.rup14,
               rup15      LIKE rup_file.rup15,
               rup16      LIKE rup_file.rup16,
               rup05      LIKE rup_file.rup05
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
#DEFINE g_dbs  LIKE tqb_file.tqb05 #FUN-A50102
DEFINE g_sql2 STRING 
DEFINE g_chk_ruoplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_argv1 LIKE ruo_file.ruoplant
DEFINE g_argv2 LIKE ruo_file.ruo01
DEFINE g_zxy03 LIKE zxy_file.zxy03    #No.TQC-A10048
 
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
 
   OPEN WINDOW q810_w AT p_row,p_col WITH FORM "art/42f/artq810"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL q810_q()
   END IF   

   CALL cl_set_comp_visible("ruopos",FALSE) # No:FUN-B50042
   
   CALL q810_menu()
 
   CLOSE WINDOW q810_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q810_menu()
 
   WHILE TRUE
      CALL q810_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q810_q()
            END IF
 
         WHEN "view"
              CALL q810_bp2()
 
         WHEN "return"
              CALL q810_bp()
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

#FUN-B90091 add START
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ruo),base.TypeInfo.create(g_rup),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q810_q()
 
   CALL q810_b_askkey()
 
END FUNCTION
 
FUNCTION q810_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
  IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
     LET g_wc = "ruo01 = '",g_argv2,"' AND ruoplant = '",g_argv1,"'"
     LET g_chk_ruoplant=FALSE
  ELSE  
   CLEAR FORM
   CALL g_ruo.clear()
   CALL g_rup.clear()
 
   LET g_chk_ruoplant = TRUE 
   
   CONSTRUCT g_wc ON ruoplant, ruo07,  ruo01,  ruo02,
                     ruo03,  ruo04,  ruo05,  ruo06,
                     ruo08,  ruo09,  ruoconf,
                     ruo10,  ruo11,  ruo12,  ruo13,
                     ruoacti,ruocrat,ruouser,ruogrup,
                     ruodate,ruomodu 
                FROM s_ruo[1].ruoplant, s_ruo[1].ruo07,  s_ruo[1].ruo01,  s_ruo[1].ruo02,
                     s_ruo[1].ruo03,  s_ruo[1].ruo04,  s_ruo[1].ruo05,  s_ruo[1].ruo06,
                     s_ruo[1].ruo08,  s_ruo[1].ruo09,  s_ruo[1].ruoconf,                  #FUN-B50042 remove POS        
                     s_ruo[1].ruo10,  s_ruo[1].ruo11,  s_ruo[1].ruo12,  s_ruo[1].ruo13,
                     s_ruo[1].ruoacti,s_ruo[1].ruocrat,s_ruo[1].ruouser,s_ruo[1].ruogrup,
                     s_ruo[1].ruodate,s_ruo[1].ruomodu 
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD ruoplant
         IF get_fldbuf(ruoplant) IS NOT NULL THEN
            LET g_chk_ruoplant = FALSE
         ELSE
            CALL q810_chk_auth()
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ruoplant)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruoplant
                   NEXT FIELD ruoplant
              WHEN INFIELD(ruo04)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo04
                   NEXT FIELD ruo04
 
              WHEN INFIELD(ruo05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo05
                   NEXT FIELD ruo05
                   
              WHEN INFIELD(ruo06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo06
                   NEXT FIELD ruo06
                   
              WHEN INFIELD(ruo08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo08
                   NEXT FIELD ruo08
                   
              WHEN INFIELD(ruo11)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo11                
                   NEXT FIELD ruo11  
                   
              WHEN INFIELD(ruo13)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo13
                   NEXT FIELD ruo13  
                    
              WHEN INFIELD(ruouser)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruouser
                   NEXT FIELD ruouser 
                       
              WHEN INFIELD(ruogrup)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruogrup
                   NEXT FIELD ruogrup
              
              WHEN INFIELD(ruomodu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruomodu
                   NEXT FIELD ruomodu
     
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
   #      LET g_wc = g_wc CLIPPED," AND ruouser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           
   #      LET g_wc = g_wc CLIPPED," AND ruogrup MATCHES '",
   #                 g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              
   #      LET g_wc = g_wc CLIPPED," AND ruogrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruouser', 'ruogrup')
   #End:FUN-980030
   
   CONSTRUCT g_wc2 ON rup02,    rup03,  rup04,  rup06,
                      rup07,    rup08,  rup09,  rup10,
                      rup11,    rup12,  rup13,  rup14,
                      rup15,    rup16,  rup05  
                 FROM s_rup[1].rup02,   s_rup[1].rup03,  s_rup[1].rup04,  s_rup[1].rup06,
                      s_rup[1].rup07,   s_rup[1].rup08,  s_rup[1].rup09,  s_rup[1].rup10,
                      s_rup[1].rup11,   s_rup[1].rup12,  s_rup[1].rup13,  s_rup[1].rup14, 
                      s_rup[1].rup15,   s_rup[1].rup16,  s_rup[1].rup05                     
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rup03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rup03
                 NEXT FIELD rup03
              WHEN INFIELD(rup04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rup04
                 NEXT FIELD rup04
              WHEN INFIELD(rup07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rup07
                 NEXT FIELD rup07
              WHEN INFIELD(rup09)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imd01"  #FUN-AA0062 mark
                 LET g_qryparam.form = "q_imd003"  #FUN-AA0062 add
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = 'SW'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rup09
                 NEXT FIELD rup09
              WHEN INFIELD(rup13)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imd01"  #FUN-AA0062 mark
                 LET g_qryparam.form = "q_imd003"  #FUN-AA0062 add
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = 'SW'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rup13
                 NEXT FIELD rup13
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
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
  END IF
 
    LET l_ac = 1 
    IF cl_null(g_wc2) THEN LET g_wc2="1=1" END IF
    LET g_wc = g_wc CLIPPED," AND ",g_wc2 CLIPPED
    CALL q810_b_fill(g_wc)
    CALL q810_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION q810_chk_auth()
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add 
    LET g_chk_auth = ''
    DECLARE q810_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
    FOREACH q810_zxy_cs INTO l_zxy03
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
END FUNCTION
 
FUNCTION q810_b_fill(p_wc)              
DEFINE p_wc STRING        
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
     #NO.TQC-A10048-- begin
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
    #            " WHERE zxy01 = '",g_user,"' ",
    #            "   AND zxy03 = azp01  "
    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "
    PREPARE q810_pre FROM g_sql
    DECLARE q810_DB_cs CURSOR FOR q810_pre
    LET g_sql2 = ''
    #FOREACH q810_DB_cs INTO g_dbs
    FOREACH q810_DB_cs INTO  g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q810_DB_cs',SQLCA.sqlcode,1)
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
    #NO.TQC-A10048--end   
       LET g_sql = "SELECT DISTINCT ruoplant,'',ruo07,ruo01,ruo02,ruo03,ruo04,ruo05,ruo06,ruo08,'',ruo09,ruopos,",
                   "       ruoconf,ruo10,ruo11,ruo12,ruo13,ruoacti,ruocrat,ruouser,ruogrup,ruodate,ruomodu        ",  
                   #"  FROM ",s_dbstring(g_dbs),"ruo_file,",s_dbstring(g_dbs),"rup_file",    #FUN-A50102
                   "  FROM ",cl_get_target_table(g_zxy03, 'ruo_file'),",",cl_get_target_table(g_zxy03, 'rup_file'),    #FUN-A50102
                   " WHERE ruo01=rup01 AND ruoplant=rupplant "," AND ruoplant='",g_zxy03 CLIPPED,"'", 
                   "   AND  ",p_wc   
       IF g_chk_ruoplant THEN
          LET g_sql = "(",g_sql," AND ruoplant IN ",g_chk_auth,")"
       ELSE
          LET g_sql = "(",g_sql,")"
       END IF
       IF g_sql2 IS NULL THEN
          LET g_sql2 = g_sql
       ELSE
          LET g_sql2 = g_sql2," UNION ALL ",g_sql
          #LET g_sql2 = g_sql
       END IF
    END FOREACH
    
    PREPARE q810_pb FROM g_sql2
    DECLARE q810_cs CURSOR FOR q810_pb
 
    CALL g_ruo.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q810_cs INTO g_ruo[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q810_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        SELECT azp02 INTO g_ruo[g_cnt].ruoplant_desc
          FROM azp_file
         WHERE azp01= g_ruo[g_cnt].ruoplant
        SELECT gen02 INTO g_ruo[g_cnt].gen02
          FROM gen_file
         WHERE gen01 = g_ruo[g_cnt].ruo08
           AND genacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ruo.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q810_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03
    #NO.TQC-A10048-- begin
    #SELECT azp03 INTO l_dbs
    #  FROM azp_file
    # WHERE azp01 = g_ruo[l_ac].ruoplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_ruo[l_ac].ruoplant
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra
    #FUN-A50102 ---mark---end---
    #NO.TQC-A10048-- end
    LET g_sql = "SELECT DISTINCT rup02, rup03, '',    rup04, rup06, rup07, rup08, rup09,   rup10, rup11, ",
                "       rup12, rup13, rup14, rup15, rup16, rup05   ",
               #"  FROM ",s_dbstring(l_dbs),"rup_file", #FUN-A50102
                "  FROM ",cl_get_target_table(g_ruo[l_ac].ruoplant, 'rup_file'), #FUN-A50102
                " WHERE rup01 = '",g_ruo[l_ac].ruo01,"'",
                "   AND rupplant = '",g_ruo[l_ac].ruoplant,"'",
                "   AND ",p_wc2
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_ruo[l_ac].ruoplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q810_pb2 FROM g_sql
    DECLARE q810_cs2 CURSOR FOR q810_pb2
    
    #LET g_sql = "SELECT ima02 FROM ",s_dbstring(l_dbs),"ima_file", #FUN-A50102
    LET g_sql = "SELECT ima02 FROM ",cl_get_target_table(g_ruo[l_ac].ruoplant, 'ima_file'), #FUN-A50102
                " WHERE ima01 = ? AND imaacti = 'Y'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_ruo[l_ac].ruoplant) RETURNING g_sql  #FUN-A50102
    PREPARE q810_ima021_cs FROM g_sql
    
    CALL g_rup.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q810_cs2 INTO g_rup[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q810_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF       
        EXECUTE q810_ima021_cs USING g_rup[g_cnt].rup03
                                INTO g_rup[g_cnt].ima02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rup.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q810_bp2()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rup TO s_rup.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
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
 
#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit 
         LET g_action_choice="exit"
         EXIT DISPLAY
   END DISPLAY
 
END FUNCTION
 
FUNCTION q810_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_ruo TO s_ruo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b != 0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q810_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_rup TO s_rup.* ATTRIBUTE(COUNT=g_rec_b2)
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
 
      ON ACTION view
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
