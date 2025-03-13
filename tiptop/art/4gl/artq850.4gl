# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: artq850.4gl
# Descriptions...: 集團調撥申請查詢 
# Date & Author..: No: FUN-870007 09/03/06 By Zhangyajun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10050 10/01/07 By destiny DB取值请取实体DB 
# Modify.........: No.FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No.TQC-B10010 11/01/06 By lixia 隱藏tsk24需求營運中心字段
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_tsk   DYNAMIC ARRAY OF RECORD       
               tskplant       LIKE tsk_file.tskplant,
               tskplant_desc  LIKE azp_file.azp02,
               tsk01        LIKE tsk_file.tsk01,
               tsk02        LIKE tsk_file.tsk02,               
               tsk18        LIKE tsk_file.tsk18,
               tsk19        LIKE tsk_file.tsk19,
               tsk03        LIKE tsk_file.tsk03,
               tsk17        LIKE tsk_file.tsk17,
               tsk06        LIKE tsk_file.tsk06,
               tsk07        LIKE tsk_file.tsk07,
               tsk08        LIKE tsk_file.tsk08,
               tsk08_desc   LIKE gen_file.gen02,
               tsk09        LIKE tsk_file.tsk09,               
               tsk09_desc   LIKE gem_file.gem02,
               tsk10        LIKE tsk_file.tsk10,
               tsk24        LIKE tsk_file.tsk24,
               tsk23        LIKE tsk_file.tsk23,
               tsk25        LIKE tsk_file.tsk25,
               tsk26        LIKE tsk_file.tsk26,
               tsk05        LIKE tsk_file.tsk05,
               tskacti      LIKE tsk_file.tskacti,
               tskuser      LIKE tsk_file.tskuser,
               tskgrup      LIKE tsk_file.tskgrup,
               tskmodu      LIKE tsk_file.tskmodu,
               tskdate      LIKE tsk_file.tskdate
               END RECORD,
       g_tsl   DYNAMIC ARRAY OF RECORD       
               tsl02      LIKE tsl_file.tsl02,
               tsl13      LIKE tsl_file.tsl13,
               tsl03      LIKE tsl_file.tsl03,
               ima02      LIKE ima_file.ima02,
               tsl04      LIKE tsl_file.tsl04,
               tsl04_desc LIKE gfe_file.gfe02,
               tsl05      LIKE tsl_file.tsl05,
               tsl06      LIKE tsl_file.tsl06,
               tsl07      LIKE tsl_file.tsl07,
               tsl07_desc LIKE gfe_file.gfe02,
               tsl08      LIKE tsl_file.tsl08,
               tsl09      LIKE tsl_file.tsl09,
               tsl10      LIKE tsl_file.tsl10,
               tsl10_desc LIKE gfe_file.gfe02,
               tsl11      LIKE tsl_file.tsl11,
               tsl12      LIKE tsl_file.tsl12               
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
#DEFINE g_dbs  LIKE tqb_file.tqb05 #FUN-A50102
DEFINE g_sql2 STRING 
DEFINE g_chk_tskplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_argv1 LIKE tsk_file.tsk01
DEFINE g_argv2 LIKE tsk_file.tskplant
DEFINE l_cmd STRING
DEFINE g_flag STRING 
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10050
 
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
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q850_w AT p_row,p_col WITH FORM "art/42f/artq850"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL q850_visible()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL q850_q()
   END IF
   CALL q850_menu()
 
   CLOSE WINDOW q850_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q850_visible()
DEFINE ls_hide STRING
   
    LET ls_hide = "tsl07,tsl07_desc,tsl08,tsl09,tsl10,",
                  "tsl10_desc,tsl11,tsl12"
    CALL cl_set_comp_visible(ls_hide,g_sma.sma115='Y')
    CALL cl_set_comp_visible("tsk24",FALSE)   #TQC-B10010
END FUNCTION
 
FUNCTION q850_menu()
 
   WHILE TRUE
      CASE g_flag
         WHEN "page1" CALL q850_bp()
         WHEN "page2" CALL q850_bp2()
         OTHERWISE CALL q850_bp()
      END CASE
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q850_q()
            END IF
#         WHEN "qry_po"
#            LET l_cmd = "cpmq540 '",g_tsk[l_ac].tsk01,"' '",g_tsl[l_ac2].tsl02,"'"
#            CALL cl_cmdrun(l_cmd)
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
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tsk),base.TypeInfo.create(g_tsl),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q850_q()
 
   CALL q850_b_askkey()
 
END FUNCTION
 
FUNCTION q850_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add 
   CLEAR FORM
   CALL g_tsk.clear()
   CALL g_tsl.clear()
 
   LET g_chk_tskplant = TRUE 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " tsk01 = '",g_argv1,"' AND tskplant = '",g_argv2,"'"
      LET g_wc2 = " 1=1"
      LET g_chk_tskplant = FALSE
   ELSE 
   CONSTRUCT g_wc ON tskplant,tsk01,  tsk02,  tsk18,
                     tsk19, tsk03,  tsk17,  tsk06,
                     tsk07, tsk08,  tsk09,  tsk10,
                     tsk24, tsk23,  tsk25,  tsk26,
                     tsk05, tskacti,tskuser,tskgrup,
                     tskmodu,tskdate
                FROM s_tsk[1].tskplant, s_tsk[1].tsk01,  s_tsk[1].tsk02,  s_tsk[1].tsk18,
                     s_tsk[1].tsk19,  s_tsk[1].tsk03,  s_tsk[1].tsk17,  s_tsk[1].tsk06,
                     s_tsk[1].tsk07,  s_tsk[1].tsk08,  s_tsk[1].tsk09,  s_tsk[1].tsk10,
                     s_tsk[1].tsk24,  s_tsk[1].tsk23,  s_tsk[1].tsk25,  s_tsk[1].tsk26,
                     s_tsk[1].tsk05,  s_tsk[1].tskacti,s_tsk[1].tskuser,s_tsk[1].tskgrup,
                     s_tsk[1].tskmodu,s_tsk[1].tskdate
                     
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD tskplant
         IF get_fldbuf(tskplant) IS NOT NULL THEN
            LET g_chk_tskplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(tskplant)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tskplant
                   NEXT FIELD tskplant
                   
              WHEN INFIELD(tsk03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tsk03
                   NEXT FIELD tsk03
                   
              WHEN INFIELD(tsk17)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imd"     #FUN-AA0062 mark
                 LET g_qryparam.form = "q_imd003"   #FUN-AA0062 add 
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = 'SW'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsk17
                 NEXT FIELD tsk17
              
              WHEN INFIELD(tsk07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_poz"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tsk07
                   NEXT FIELD tsk07
                      
              WHEN INFIELD(tsk08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tsk08
                   NEXT FIELD tsk08
 
              WHEN INFIELD(tsk09)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem3"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tsk09
                   NEXT FIELD tsk09
              
              WHEN INFIELD(tsk24)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tsk24
                   NEXT FIELD tsk24
              
              WHEN INFIELD(tsk25)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tsk25
                   NEXT FIELD tsk25
              
              WHEN INFIELD(tskuser)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tskuser
                   NEXT FIELD tskuser
              
              WHEN INFIELD(tskmodu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tskmodu
                   NEXT FIELD tskmodu
                  
              WHEN INFIELD(tskgrup)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tskgrup
                   NEXT FIELD tskgrup
                   
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
   
   CONSTRUCT g_wc2 ON tsl02,tsl13,tsl03,tsl04,
                      tsl05,tsl06,tsl07,tsl08,
                      tsl09,tsl10,tsl11,tsl12
                 FROM s_tsl[1].tsl02,s_tsl[1].tsl13,s_tsl[1].tsl03,s_tsl[1].tsl04,
                      s_tsl[1].tsl05,s_tsl[1].tsl06,s_tsl[1].tsl07,s_tsl[1].tsl08,
                      s_tsl[1].tsl09,s_tsl[1].tsl10,s_tsl[1].tsl11,s_tsl[1].tsl12
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(tsl03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsl03
                 NEXT FIELD tsl03
                 
              WHEN INFIELD(tsl04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsl04
                 NEXT FIELD tsl04
                 
              WHEN INFIELD(tsl07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsl07
                 NEXT FIELD tsl07
                 
               WHEN INFIELD(tsl10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsl10
                 NEXT FIELD tsl10
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
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
    #      LET g_wc = g_wc CLIPPED," AND tskuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #      LET g_wc = g_wc CLIPPED," AND tskgrup MATCHES '",
    #                 g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN
    #       LET g_wc = g_wc CLIPPED," AND tskgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tskuser', 'tskgrup')
    #End:FUN-980030
    LET g_chk_auth = ''
    IF g_chk_tskplant THEN
      DECLARE q850_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q850_zxy_cs INTO l_zxy03
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
    CALL q850_b_fill(g_wc,g_wc2)
    CALL q850_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION q850_b_fill(p_wc,p_wc2)              
DEFINE p_wc,p_wc2 STRING        
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add 
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
    #            " WHERE zxy01 = '",g_user,"' ",
    #            "   AND zxy03 = azp01  "
     LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "
    IF NOT cl_null(g_argv2) THEN
#       LET g_sql = g_sql," AND azp01 = '",g_argv2,"'"
        LET g_sql = g_sql," AND zxy03 = '",g_argv2,"'"
    END IF
    PREPARE q850_pre FROM g_sql
    DECLARE q850_DB_cs CURSOR FOR q850_pre
    LET g_sql2 = ''
    #FOREACH q850_DB_cs INTO g_dbs
     FOREACH q850_DB_cs INTO g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q850_DB_cs',SQLCA.sqlcode,1)
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
       #LET g_dbs = s_dbstring(g_dbs CLIPPED)   
       #FUN-A50102 ---mark---end---
    #NO.TQC-A10050--end
       IF p_wc2 = " 1=1" THEN
           LET g_sql = "SELECT tskplant,'',tsk01,tsk02,tsk18,tsk19,tsk03,tsk17,tsk06,",
                       "       tsk07,tsk08,'',tsk09,'',tsk10,tsk24,tsk23,tsk25,tsk26,",
                       "       tsk05,tskacti,tskuser,tskgrup,tskmodu,tskdate",
                       #"  FROM ",g_dbs CLIPPED,".tsk_file,azp_file",
                       #"  FROM ",g_dbs CLIPPED,"tsk_file,azp_file", #FUN-A50102
                       "  FROM ",cl_get_target_table(g_zxy03, 'tsk_file'),",","azp_file", #FUN-A50102
                       #" WHERE tskplant = azp01 AND azp03 = '",g_dbs CLIPPED,"'",
                       " WHERE tskplant = azp01 AND azp01 = '",g_zxy03 CLIPPED,"'",
                       "   AND ",p_wc
       ELSE
           LET g_sql = "SELECT tskplant,'',tsk01,tsk02,tsk18,tsk19,tsk03,tsk17,tsk06,",
                       "       tsk07,tsk08,'',tsk09,'',tsk10,tsk24,tsk23,tsk25,tsk26,",
                       "       tsk05,tskacti,tskuser,tskgrup,tskmodu,tskdate",
                       #"  FROM ",g_dbs CLIPPED,".tsk_file,",g_dbs CLIPPED,".tsl_file,azp_file",
                       #"  FROM ",g_dbs CLIPPED,"tsk_file,",g_dbs CLIPPED,"tsl_file,azp_file", #FUN-A50102
                       "  FROM ",cl_get_target_table(g_zxy03, 'tsk_file'),",",cl_get_target_table(g_zxy03, 'tsl_file'),",","azp_file", #FUN-A50102
                       " WHERE tsk01 = tsl01 AND tskplant = tslplant",
                       #"   AND tskplant = azp01 AND azp03 = '",g_dbs CLIPPED,"'",
                       "   AND tskplant = azp01 AND azp01 = '",g_zxy03 CLIPPED,"'",
                       "   AND ",p_wc," AND ",p_wc2
       END IF 
       IF g_chk_tskplant THEN
          LET g_sql = "(",g_sql," AND tskplant IN ",g_chk_auth,")"
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
    
    PREPARE q850_pb FROM g_sql
    DECLARE q850_cs CURSOR FOR q850_pb
 
    CALL g_tsk.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q850_cs INTO g_tsk[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q850_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        SELECT azp02
          INTO g_tsk[g_cnt].tskplant_desc
          FROM azp_file
         WHERE azp01 = g_tsk[g_cnt].tskplant
        SELECT gen02 INTO g_tsk[g_cnt].tsk08_desc
          FROM gen_file
         WHERE gen01 = g_tsk[g_cnt].tsk08
        SELECT gem02 INTO g_tsk[g_cnt].tsk09_desc
          FROM gem_file
         WHERE gem01 = g_tsk[g_cnt].tsk09
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_tsk.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q850_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03
    #NO.TQC-A10050-- begin
    #SELECT azp03 INTO l_dbs
    #  FROM azp_file
    # WHERE azp01 = g_tsk[l_ac].tskplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_tsk[l_ac].tskplant
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra         
    #FUN-A50102 ---mark---end---
    #NO.TQC-A10050--end 
    LET g_sql = "SELECT tsl02,tsl13,tsl03,'',tsl04,'',tsl05,tsl06,",
                "       tsl07,'',tsl08,tsl09,tsl10,'',tsl11,tsl11",
                #"  FROM ",s_dbstring(l_dbs),"tsl_file", #FUN-A50102
                "  FROM ",cl_get_target_table(g_tsk[l_ac].tskplant, 'tsl_file'), #FUN-A50102
                " WHERE tsl01 = '",g_tsk[l_ac].tsk01,"'",
                "   AND tslplant = '",g_tsk[l_ac].tskplant,"'",
                "   AND ",p_wc2
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_tsk[l_ac].tskplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q850_pb2 FROM g_sql
    DECLARE q850_cs2 CURSOR FOR q850_pb2
    
    #LET g_sql = "SELECT ima02 FROM ",l_dbs CLIPPED,".ima_file",
    #LET g_sql = "SELECT ima02 FROM ",s_dbstring(l_dbs),"ima_file", #FUN-A50102
    LET g_sql = "SELECT ima02 FROM ",cl_get_target_table(g_tsk[l_ac].tskplant, 'ima_file'), #FUN-A50102
                " WHERE ima01 = ? AND imaacti = 'Y'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_tsk[l_ac].tskplant) RETURNING g_sql  #FUN-A50102
    PREPARE q850_ima02_cs FROM g_sql
    
    CALL g_tsl.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q850_cs2 INTO g_tsl[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q850_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF
        
        EXECUTE q850_ima02_cs USING g_tsl[g_cnt].tsl04
                              INTO g_tsl[g_cnt].ima02
        SELECT gfe02 INTO g_tsl[g_cnt].tsl04_desc
          FROM gfe_file
         WHERE gfe01 = g_tsl[g_cnt].tsl04  
           AND gfeacti = 'Y'        
        IF g_sma.sma115 = 'Y' THEN
        SELECT gfe02 INTO g_tsl[g_cnt].tsl07_desc
          FROM gfe_file
         WHERE gfe01 = g_tsl[g_cnt].tsl07   
           AND gfeacti = 'Y'
        SELECT gfe02 INTO g_tsl[g_cnt].tsl10_desc
          FROM gfe_file
         WHERE gfe01 = g_tsl[g_cnt].tsl10   
           AND gfeacti = 'Y'
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_tsl.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q850_bp2()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tsl TO s_tsl.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac2 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
 
      ON ACTION return
         LET g_action_choice = "return"
         LET g_flag = "page1"
         EXIT DISPLAY
 
#      ON ACTION qry_po
#         LET g_action_choice = "qry_po"
#         LET g_flag = "page2"
#         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice = "exit"
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
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION q850_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_tsk TO s_tsk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b != 0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q850_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_tsl TO s_tsl.* ATTRIBUTE(COUNT=g_rec_b2)
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
         LET g_flag = "page1"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION view1
         LET g_action_choice = "view1"
         LET g_flag = "page2"
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
