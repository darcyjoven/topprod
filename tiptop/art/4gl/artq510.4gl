# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: artq510.4gl
# Descriptions...: 請購明細查詢 
# Date & Author..: No: FUN-870007 09/02/20 By Zhangyajun
# Modify.........: No: FUN-870100 09/08/27 By Cockroach 超市移植 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10046 10/01/07 By cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.TQC-A90070 10/10/09 By lilingyu 點擊"瀏覽明細"旁的"查詢採購單"時,程式當出
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pmk   DYNAMIC ARRAY OF RECORD        #
               pmkplant       LIKE pmk_file.pmkplant,
               pmkplant_desc  LIKE azp_file.azp02,
               pmk46        LIKE pmk_file.pmk46,
               pmk01        LIKE pmk_file.pmk01,
               pmk04        LIKE pmk_file.pmk04,
               pmk48        LIKE pmk_file.pmk48,
               pmk12        LIKE pmk_file.pmk12,
               pmk12_desc   LIKE gen_file.gen02,
               pmk13        LIKE pmk_file.pmk13,               
               pmk13_desc   LIKE gem_file.gem02,
               pmk02        LIKE pmk_file.pmk02,
               pmk09        LIKE pmk_file.pmk09,
               pmk09_desc   LIKE pmc_file.pmc03,
               pmk18        LIKE pmk_file.pmk18,
               pmkcond      LIKE pmk_file.pmkcond,
               pmkcont      LIKE pmk_file.pmkcont,
               pmkconu      LIKE pmk_file.pmkconu,
               pmkconu_desc LIKE gen_file.gen02
               END RECORD,
       g_pml   DYNAMIC ARRAY OF RECORD        # 明細
               pml02      LIKE pml_file.pml02,
               pml47      LIKE pml_file.pml47,
               pml04      LIKE pml_file.pml04,
               pml041     LIKE pml_file.pml041,
               ima021     LIKE ima_file.ima021,
               pml07      LIKE pml_file.pml07,
               pml07_desc LIKE gfe_file.gfe02,
               pml20      LIKE pml_file.pml20,
               pml21      LIKE pml_file.pml21,
               pml33      LIKE pml_file.pml33,
               pml55      LIKE pml_file.pml55,
               pml48      LIKE pml_file.pml48,
               pml48_desc LIKE pmc_file.pmc03,
               rty04      LIKE rty_file.rty04,
               rty04_desc LIKE gem_file.gem02,
               pml49      LIKE pml_file.pml49,
               pml50      LIKE pml_file.pml50,
               pml56      LIKE pml_file.pml56,
               pml06      LIKE pml_file.pml06,
               pml24      LIKE pml_file.pml24,
               pml25      LIKE pml_file.pml25
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
DEFINE g_dbs  LIKE azp_file.azp03
DEFINE g_sql2 STRING 
DEFINE g_chk_pmkplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_argv1 LIKE pmk_file.pmk01
DEFINE g_argv2 LIKE pmk_file.pmkplant
DEFINE l_cmd STRING
DEFINE g_flag STRING 
 
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
 
   OPEN WINDOW q510_w AT p_row,p_col WITH FORM "art/42f/artq510"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL q510_q()
   END IF
   CALL q510_menu()
 
   CLOSE WINDOW q510_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q510_menu()
 
   WHILE TRUE
      CASE g_flag
         WHEN "page1" CALL q510_bp()
         WHEN "page2" CALL q510_bp2()
         OTHERWISE CALL q510_bp()
      END CASE
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q510_q()
            END IF
         WHEN "qry_po"
            IF l_ac > 0 THEN        #TQC-A90070
                LET l_cmd = "artq511 '",g_pmk[l_ac].pmk01,"' '",g_pml[l_ac2].pml02,"'"
                CALL cl_cmdrun(l_cmd)
            END IF                  #TQC-A90070
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
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmk),base.TypeInfo.create(g_pml),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q510_q()
 
   CALL q510_b_askkey()
 
END FUNCTION
 
FUNCTION q510_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
 
   CLEAR FORM
   CALL g_pmk.clear()
   CALL g_pml.clear()
 
   LET g_chk_pmkplant = TRUE 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " pmk01 = '",g_argv1,"' AND pmkplant = '",g_argv2,"'"
      LET g_wc2 = " 1=1"
      LET g_chk_pmkplant = FALSE
   ELSE 
   CONSTRUCT g_wc ON pmkplant,pmk46,pmk01,pmk04,pmk48,pmk12,pmk13,
                     pmk02,pmk09,pmk18,pmkcond,pmkcont,pmkconu
                FROM s_pmk[1].pmkplant,s_pmk[1].pmk46,s_pmk[1].pmk01,
                     s_pmk[1].pmk04,s_pmk[1].pmk48,s_pmk[1].pmk12,
                     s_pmk[1].pmk13,s_pmk[1].pmk02,s_pmk[1].pmk09,
                     s_pmk[1].pmk18,s_pmk[1].pmkcond,s_pmk[1].pmkcont,
                     s_pmk[1].pmkconu
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD pmkplant
         IF get_fldbuf(pmkplant) IS NOT NULL THEN
            LET g_chk_pmkplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pmkplant)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmkplant
                   NEXT FIELD pmkplant
 
              WHEN INFIELD(pmk12)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmk12
                   NEXT FIELD pmk12
 
              WHEN INFIELD(pmk13)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem3"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmk13
                   NEXT FIELD pmk13
 
              WHEN INFIELD(pmk09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc9"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmk09
                   NEXT FIELD pmk09
                   
              WHEN INFIELD(pmkconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmkconu
                   NEXT FIELD pmkconu
                   
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
   
   CONSTRUCT g_wc2 ON pml02,pml47,pml04,pml041,pml07,pml20,pml21,
                      pml33,pml35,pml48,pml49,pml50,pml56,
                      pml06,pml24,pml25
                 FROM s_pml[1].pml02,s_pml[1].pml47,s_pml[1].pml04,
                      s_pml[1].pml041,s_pml[1].pml07,s_pml[1].pml20,
                      s_pml[1].pml21,s_pml[1].pml33,s_pml[1].pml35,
                      s_pml[1].pml48,s_pml[1].pml49,
                      s_pml[1].pml50,s_pml[1].pml56,s_pml[1].pml06,
                      s_pml[1].pml24,s_pml[1].pml25
                      
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(pml04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml04
                 NEXT FIELD pml04
              WHEN INFIELD(pml07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml07
                 NEXT FIELD pml07
              WHEN INFIELD(pml48)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc9"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml48
                 NEXT FIELD pml48
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
    #      LET g_wc = g_wc CLIPPED," AND pmkuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #      LET g_wc = g_wc CLIPPED," AND pmkgrup MATCHES '",
    #                 g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN
    #       LET g_wc = g_wc CLIPPED," AND pmkgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
    #End:FUN-980030
    LET g_chk_auth = ''
    IF g_chk_pmkplant THEN
      DECLARE q510_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q510_zxy_cs INTO l_zxy03
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
    CALL q510_b_fill(g_wc,g_wc2)
    CALL q510_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION q510_b_fill(p_wc,p_wc2)              
DEFINE p_wc,p_wc2 STRING        
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_zxy03 LIKE zxy_file.zxy03  #TQC-A10046 ADD
DEFINE l_azp03 LIKE azp_file.azp03      #TQC-B90175 add
 
#TQC-A10046 mark and add start---------------------------------------- 
    LET g_sql = "SELECT DISTINCT zxy03 FROM zxy_file ",
                " WHERE zxy01 = '",g_user,"' " 
    IF NOT cl_null(g_argv2) THEN
       LET g_sql = g_sql," AND zxy03 = '",g_argv2,"'"
    END IF
    PREPARE q510_pre FROM g_sql
    DECLARE q510_DB_cs CURSOR FOR q510_pre
    LET g_sql2 = ''
  #  FOREACH q510_DB_cs INTO g_dbs
    FOREACH q510_DB_cs INTO l_zxy03 
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q510_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF 
#TQC-B90175 add START------------------------------
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
     IF NOT cl_chk_schema_has_built(l_azp03) THEN
        CONTINUE FOREACH
     END IF
#TQC-B90175 add END--------------------------------
       #FUN-A50102 ---mark---str---
       #LET g_plant_new =l_zxy03
       #CALL s_gettrandbs()
       #LET g_dbs=g_dbs_tra
       #LET g_dbs = s_dbstring( g_dbs CLIPPED) 
       #FUN-A50102 ---mark---end---
#TQC-A10046 mark and add end----------------------------------------     
  IF p_wc2 = " 1=1" THEN
           LET g_sql = "SELECT pmkplant,'',pmk46,pmk01,pmk04,pmk48,pmk12,'',",
                       "       pmk13,'',pmk02,pmk09,'',pmk18,pmkcond,pmkcont,pmkconu,''",
                       #"  FROM ",g_dbs CLIPPED,"pmk_file,azp_file", #FUN-A50102
                       "  FROM ",cl_get_target_table(l_zxy03, 'pmk_file'),",","azp_file", #FUN-A50102
                       " WHERE pmkplant = azp01 AND azp01 = '",l_zxy03 CLIPPED,"'",
                       "   AND ",p_wc
       ELSE
           LET g_sql = "SELECT pmkplant,'',pmk46,pmk01,pmk04,pmk48,pmk12,'',",
                       "       pmk13,'',pmk02,pmk09,'',pmk18,pmkcond,pmkcont,pmkconu,''",
                       #"  FROM ",g_dbs CLIPPED,"pmk_file,",g_dbs CLIPPED,"pml_file,azp_file", #FUN-A50102
                        "  FROM ",cl_get_target_table(l_zxy03, 'pmk_file'),",",cl_get_target_table(l_zxy03, 'pml_file'),",","azp_file", #FUN-A50102
                       " WHERE pmk01 = pml01 AND pmkplant = pmlplant",
                       "   AND pmkplant = azp01 AND azp01 = '",l_zxy03 CLIPPED,"'",
                       "   AND ",p_wc," AND ",p_wc2
       END IF 
       IF g_chk_pmkplant THEN
          LET g_sql = "(",g_sql," AND pmkplant IN ",g_chk_auth,")"
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
    #CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    #CALL cl_parse_qry_sql(g_sql, l_zxy03) RETURNING g_sql  #FUN-A50102
    PREPARE q510_pb FROM g_sql
    DECLARE q510_cs CURSOR FOR q510_pb
 
    CALL g_pmk.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q510_cs INTO g_pmk[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q510_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
#TQC-A10046 mark and add start---------------------
      # SELECT tqb02,tqb05
      #   INTO g_pmk[g_cnt].pmkplant_desc,l_dbs
      #   FROM tqb_file
      #  WHERE tqb01 = g_pmk[g_cnt].pmkplant
        SELECT azp02
          INTO g_pmk[g_cnt].pmkplant_desc
          FROM azp_file
         WHERE azp01 = g_pmk[g_cnt].pmkplant 
        LET g_plant_new = g_pmk[g_cnt].pmkplant
        CALL s_gettrandbs()
        LET l_dbs=g_dbs_tra
        LET l_dbs=s_dbstring(l_dbs CLIPPED)
#TQC-A10046 mark and add end-----------------------
        SELECT gen02 INTO g_pmk[g_cnt].pmk12_desc
          FROM gen_file
         WHERE gen01 = g_pmk[g_cnt].pmk12
        SELECT gen02 INTO g_pmk[g_cnt].pmkconu_desc
          FROM gen_file
         WHERE gen01 = g_pmk[g_cnt].pmkconu
        SELECT gem02 INTO g_pmk[g_cnt].pmk13_desc
          FROM gem_file
         WHERE gem01 = g_pmk[g_cnt].pmk13
        #LET g_sql = "SELECT pmc03 FROM ",l_dbs CLIPPED,"pmc_file", #FUN-A50102
        LET g_sql = "SELECT pmc03 FROM ",cl_get_target_table(g_pmk[g_cnt].pmkplant, 'pmc_file'), #FUN-A50102
                " WHERE pmc01 = ? AND pmcacti = 'Y'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_pmk[g_cnt].pmkplant) RETURNING g_sql  #FUN-A50102        
        PREPARE q510_pmc03_cs FROM g_sql
        EXECUTE q510_pmc03_cs USING g_pmk[g_cnt].pmk09
                              INTO g_pmk[g_cnt].pmk09_desc
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_pmk.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q510_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03
    
#TQC-A10046 mark and add start----------------------
   #SELECT tqb05 INTO l_dbs
   #  FROM tqb_file
   # WHERE tqb01 = g_pmk[l_ac].pmkplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_pmk[l_ac].pmkplant
    #CALL s_gettrandbs()
    #LET l_dbs = g_dbs_tra
    #LET l_dbs = s_dbstring(l_dbs CLIPPED)
    #FUN-A50102 ---mark---end---
#TQC-A10046 mark and add start----------------------
    
    LET g_sql = "SELECT pml02,pml47,pml04,pml041,'',pml07,'',",
                "       pml20,pml21,pml33,pml55,pml48,'',",
                "       '','',pml49,pml50,pml56,pml06,pml24,pml25",
               #"  FROM ",l_dbs CLIPPED,"pml_file", #FUN-A50102
                "  FROM ",cl_get_target_table(g_pmk[l_ac].pmkplant, 'pml_file'), #FUN-A50102
                " WHERE pml01 = '",g_pmk[l_ac].pmk01,"'",
                "   AND pmlplant = '",g_pmk[l_ac].pmkplant,"'",
                "   AND ",p_wc2 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_pmk[l_ac].pmkplant) RETURNING g_sql  #FUN-A50102
    PREPARE q510_pb2 FROM g_sql
    DECLARE q510_cs2 CURSOR FOR q510_pb2
    
    #LET g_sql = "SELECT ima021 FROM ",l_dbs CLIPPED,"ima_file", #FUN-A50102
     LET g_sql = "SELECT ima021 FROM ",cl_get_target_table(g_pmk[l_ac].pmkplant, 'ima_file'), #FUN-A50102
                " WHERE ima01 = ? AND imaacti = 'Y'" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_pmk[l_ac].pmkplant) RETURNING g_sql  #FUN-A50102
    PREPARE q510_ima021_cs FROM g_sql
    
    #LET g_sql = "SELECT pmc03 FROM ",l_dbs CLIPPED,"pmc_file", #FUN-A50102
     LET g_sql = "SELECT pmc03 FROM ",cl_get_target_table(g_pmk[l_ac].pmkplant, 'pmc_file'), #FUN-A50102
                " WHERE pmc01 = ? AND pmcacti = 'Y'" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_pmk[l_ac].pmkplant) RETURNING g_sql  #FUN-A50102
    PREPARE q510_pmc03_cs2 FROM g_sql
    
    CALL g_pml.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q510_cs2 INTO g_pml[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q510_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF
        
        EXECUTE q510_ima021_cs USING g_pml[g_cnt].pml04
                              INTO g_pml[g_cnt].ima021
        SELECT gfe02 INTO g_pml[g_cnt].pml07_desc
          FROM gfe_file
         WHERE gfe01 = g_pml[g_cnt].pml07   
           AND gfeacti = 'Y'        
        SELECT rty04 INTO g_pml[g_cnt].rty04
          FROM rty_file
         WHERE rty01 = g_pmk[l_ac].pmkplant
           AND rty02 = g_pml[g_cnt].pml04
           AND rtyacti = 'Y'
        SELECT gem02 INTO g_pml[g_cnt].rty04_desc
          FROM gem_file
         WHERE gem01 = g_pml[g_cnt].rty04
           AND gemacti = 'Y'
        EXECUTE q510_pmc03_cs2 USING g_pml[g_cnt].pml48
                               INTO g_pml[g_cnt].pml48_desc
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_pml.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q510_bp2()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
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
 
      ON ACTION qry_po
         LET g_action_choice = "qry_po"
         LET g_flag = "page2"
         EXIT DISPLAY
 
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

#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END

   END DISPLAY
 
END FUNCTION
 
FUNCTION q510_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_pmk TO s_pmk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b!=0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q510_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_rec_b2)
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
#FUN-870100
