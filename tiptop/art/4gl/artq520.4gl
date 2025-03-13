# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: artq520.4gl
# Descriptions...: 退明查作
# Date & Author..: No: FUN-870007 09/02/24 By Zhangyajun
# Modify.........: No.FUN-870100  09/08/28 By cockroach 超市移植
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10065 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫開窗控管
# Modify.........: No:FUN-B50042 11/05/03 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rvu   DYNAMIC ARRAY OF RECORD        #入
               rvuplant       LIKE rvu_file.rvuplant,
               rvuplant_desc  LIKE azp_file.azp02,
               rvu00        LIKE rvu_file.rvu00,
               rvu01        LIKE rvu_file.rvu01,
               rvu03        LIKE rvu_file.rvu03,
               rvu02        LIKE rvu_file.rvu02,
               rvu04        LIKE rvu_file.rvu04,
               rvu04_desc   LIKE gen_file.gen02,
               style        LIKE type_file.chr1,
               rvu08        LIKE rvu_file.rvu08,    
               rvu07        LIKE rvu_file.rvu07,
               rvu07_desc   LIKE gen_file.gen02,
               rvu06        LIKE rvu_file.rvu06,           
               rvu06_desc   LIKE gem_file.gem02,
               rvu20        LIKE rvu_file.rvu20,
               rvu99        LIKE rvu_file.rvu99,
               rvu21        LIKE rvu_file.rvu21,
               rvupos       LIKE rvu_file.rvupos,
               rvuconf      LIKE rvu_file.rvuconf,
               rvucond      LIKE rvu_file.rvucond,
               rvucont      LIKE rvu_file.rvucont,
               rvuconu      LIKE rvu_file.rvuconu,
               rvuconu_desc LIKE gen_file.gen02
               END RECORD,
       g_rvv   DYNAMIC ARRAY OF RECORD        # 入/退明細
               rvv02      LIKE rvv_file.rvv02,
               rvv04      LIKE rvv_file.rvv04,
               rvv05      LIKE rvv_file.rvv05,
               rvv31      LIKE rvv_file.rvv31,
               rvv031     LIKE rvv_file.rvv031,
               ima021     LIKE ima_file.ima021,
               rvv35      LIKE rvv_file.rvv35,
               rvv35_desc LIKE gfe_file.gfe02,
               rvv35_fac  LIKE rvv_file.rvv35_fac,
               rvv17      LIKE rvv_file.rvv17,
               rvv32      LIKE rvv_file.rvv32,
               rvv32_desc LIKE imd_file.imd02,
               rvv38      LIKE rvv_file.rvv38,
               rvv38t     LIKE rvv_file.rvv38t,
               rvv39      LIKE rvv_file.rvv39,
               rvv39t     LIKE rvv_file.rvv39t,
               pmm21      LIKE pmm_file.pmm21,
               pmm43      LIKE pmm_file.pmm43,
               pmm909     LIKE pmm_file.pmm909,
               rvv36      LIKE rvv_file.rvv36,
               rvv37      LIKE rvv_file.rvv37,
               pmn24      LIKE pmn_file.pmn24,
               pmn25      LIKE pmn_file.pmn25,            
               rvv12      LIKE rvv_file.rvv12,
               rvv13      LIKE rvv_file.rvv13
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
DEFINE g_dbs  LIKE azp_file.azp03
DEFINE g_sql2 STRING 
DEFINE g_chk_rvuplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_argv1 LIKE rvu_file.rvu01
DEFINE g_argv2 LIKE rvu_file.rvuplant 
 
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
 
   OPEN WINDOW q520_w AT p_row,p_col WITH FORM "art/42f/artq520"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL q520_q()
   END IF

   CALL cl_set_comp_visible("rvupos",FALSE) # No:FUN-B50042
   
   CALL q520_menu()
 
   CLOSE WINDOW q520_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q520_menu()
 
   WHILE TRUE
      CALL q520_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q520_q()
            END IF
 
         WHEN "view1"
              CALL q520_bp2()
 
         WHEN "return"
              CALL q520_bp()
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-B90091 add START
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvu),base.TypeInfo.create(g_rvv),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q520_q()
 
   CALL q520_b_askkey()
 
END FUNCTION
 
FUNCTION q520_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
 
   CLEAR FORM
   CALL g_rvu.clear()
   CALL g_rvv.clear()
 
   LET g_chk_rvuplant = TRUE 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " rvu01 = '",g_argv1,"' AND rvuplant = '",g_argv2,"'"
      LET g_wc2 = " 1=1"
      LET g_chk_rvuplant = FALSE
   ELSE   
   CONSTRUCT g_wc ON rvuplant,rvu00,rvu01,rvu03,
                     rvu02, rvu04,rvu08,rvu07,
                     rvu06, rvu20,rvu99,rvu21,
                     rvuconf,rvucond,rvucont,
                     rvuconu
                FROM s_rvu[1].rvuplant,s_rvu[1].rvu00,s_rvu[1].rvu01,s_rvu[1].rvu03,
                     s_rvu[1].rvu02, s_rvu[1].rvu04,s_rvu[1].rvu08,s_rvu[1].rvu07,
                     s_rvu[1].rvu06, s_rvu[1].rvu20,s_rvu[1].rvu99,s_rvu[1].rvu21,                     
                     s_rvu[1].rvuconf,s_rvu[1].rvucond,s_rvu[1].rvucont,
                     s_rvu[1].rvuconu                                                 #FUN-B50042 remove POS
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD rvuplant
         IF get_fldbuf(rvuplant) IS NOT NULL THEN
            LET g_chk_rvuplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(rvuplant)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvuplant
                   NEXT FIELD rvuplant
 
              WHEN INFIELD(rvu04)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc9"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu04
                   NEXT FIELD rvu04
 
              WHEN INFIELD(rvu07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu07
                   NEXT FIELD rvu07
                   
              WHEN INFIELD(rvu06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem3"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu06
                   NEXT FIELD rvu06   
                    
              WHEN INFIELD(rvuconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvuconu
                   NEXT FIELD rvuconu
                   
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
   
   CONSTRUCT g_wc2 ON rvv02, rvv04,rvv05,    rvv31,
                      rvv031,rvv35,rvv35_fac,rvv17,
                      rvv32, rvv38,rvv38t,   rvv39,
                      rvv39t,rvv36,rvv37,    rvv12,
                      rvv13
                 FROM s_rvv[1].rvv02, s_rvv[1].rvv04,s_rvv[1].rvv05,    s_rvv[1].rvv31,
                      s_rvv[1].rvv031,s_rvv[1].rvv35,s_rvv[1].rvv35_fac,s_rvv[1].rvv17,
                      s_rvv[1].rvv32, s_rvv[1].rvv38,s_rvv[1].rvv38t,   s_rvv[1].rvv39, 
                      s_rvv[1].rvv39t,s_rvv[1].rvv36,s_rvv[1].rvv37,    s_rvv[1].rvv12,                      
                      s_rvv[1].rvv13
                      
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rvv31)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvv31
                 NEXT FIELD rvv31
                 
              WHEN INFIELD(rvv35)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvv35
                 NEXT FIELD rvv35
                 
              WHEN INFIELD(rvv32)
                 CALL cl_init_qry_var()
#No.FUN-AA0062  --Begin
#                 LET g_qryparam.form = "q_imd02"
                 LET g_qryparam.form = "q_imd003"
                 LET g_qryparam.arg1 = "SW"
#No.FUN-AA0062  --End
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvv32
                 NEXT FIELD rvv32
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
    #      LET g_wc = g_wc CLIPPED," AND rvuuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #      LET g_wc = g_wc CLIPPED," AND rvugrup MATCHES '",
    #                 g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN
    #      LET g_wc = g_wc CLIPPED," AND rvugrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
    #End:FUN-980030
    LET g_chk_auth = ''
    IF g_chk_rvuplant THEN
      DECLARE q520_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q520_zxy_cs INTO l_zxy03
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
    CALL q520_b_fill(g_wc,g_wc2)
    CALL q520_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION q520_b_fill(p_wc,p_wc2)              
DEFINE p_wc,p_wc2 STRING        
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_pmc930 LIKE pmc_file.pmc930
DEFINE l_zxy03  LIKE zxy_file.zxy03   #TQC-A10062 ADD
DEFINE l_azp03  LIKE azp_file.azp03      #TQC-B90175 add
#TQC-A10065 MARK AND ADD STARTING------------------------------- 
   #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
   #            " WHERE zxy01 = '",g_user,"' ",
   #            "   AND zxy03 = azp01  "
   #IF NOT cl_null(g_argv2) THEN
   #   LET g_sql = g_sql," AND azp01 = '",g_argv2,"'"
   #END IF
    LET g_sql = "SELECT DISTINCT zxy03 FROM zxy_file",
                " WHERE zxy01 = '",g_user,"' "
    IF NOT cl_null(g_argv2) THEN
       LET g_sql = g_sql," AND zxy03 = '",g_argv2,"'"
    END IF
#TQC-A10065 MARK AND ADD ENDING--------------------------------
    PREPARE q520_pre FROM g_sql
    DECLARE q520_DB_cs CURSOR FOR q520_pre
    LET g_sql2 = ''
   #FOREACH q520_DB_cs INTO g_dbs    #TQC-A10062 MARK
    FOREACH q520_DB_cs INTO l_zxy03  #TQC-A10062 ADD
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q520_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
#TQC-B90175 add START------------------------------
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
     IF NOT cl_chk_schema_has_built(l_azp03) THEN
        CONTINUE FOREACH
     END IF
#TQC-B90175 add END--------------------------------
   #FUN-A50102 ---mark---str---   
   #TQC-A10062 ADD----------------------------
    #LET g_plant_new = l_zxy03
    #CALL s_gettrandbs()
    #LET g_dbs = g_dbs_tra
    #LET g_dbs = s_dbstring(g_dbs CLIPPED)
   #TQC-A10062 end---------------------------- 
   #FUN-A50102 ---mark---end---
       IF p_wc2 = " 1=1" THEN
           LET g_sql = "SELECT rvuplant,'',rvu00,rvu01,rvu03,rvu02,rvu04,'','',",
                       "       rvu08,rvu07,'',rvu06,'',rvu20,rvu99,rvu21,rvupos,",
                       "       rvuconf,rvucond,rvucont,rvuconu,''",
                       #"  FROM ",g_dbs CLIPPED,"rvu_file,azp_file", #FUN-A50102
                        "  FROM ",cl_get_target_table(l_zxy03, 'rvu_file'),","," azp_file", #FUN-A50102
                       " WHERE rvuplant = azp01 AND azp01 = '",l_zxy03 CLIPPED,"'",
                       "   AND ",p_wc
       ELSE
           LET g_sql = "SELECT rvuplant,'',rvu00,rvu01,rvu03,rvu02,rvu04,'','',",
                       "       rvu08,rvu07,'',rvu06,'',rvu20,rvu99,rvu21,rvupos,",
                       "       rvuconf,rvucond,rvucont,rvuconu,''",
                       #"  FROM ",g_dbs CLIPPED,"rvu_file,",g_dbs CLIPPED,"rvv_file,azp_file", #FUN-A50102 
                        "  FROM ",cl_get_target_table(l_zxy03, 'rvu_file'),",",cl_get_target_table(l_zxy03, 'rvv_file'),",","azp_file", #FUN-A50102
                       " WHERE rvu01 = rvv01 AND rvuplant = rvvplant",
                       "   AND rvuplant = azp01 AND azp01 = '",l_zxy03 CLIPPED,"'",
                       "   AND ",p_wc," AND ",p_wc2
       END IF
       IF g_chk_rvuplant THEN
          LET g_sql = "(",g_sql," AND rvuplant IN ",g_chk_auth,")"
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
    
    PREPARE q520_pb FROM g_sql
    DECLARE q520_cs CURSOR FOR q520_pb
 
    CALL g_rvu.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q520_cs INTO g_rvu[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q520_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        SELECT azp02
          INTO g_rvu[g_cnt].rvuplant_desc
          FROM azp_file
         WHERE azp01 = g_rvu[g_cnt].rvuplant
    #FUN-A50102 ---mark---str---
    #TQC-A10065 ADD------------------------
        #LET g_plant_new = g_rvu[g_cnt].rvuplant
        #CALL s_gettrandbs()
        #LET l_dbs = g_dbs_tra
        #LET l_dbs = s_dbstring(l_dbs CLIPPED)
    #TQC-A10065 END--------------------------
    #FUN-A50102 ---mark---end---
        SELECT gen02 INTO g_rvu[g_cnt].rvu07_desc
          FROM gen_file
         WHERE gen01 = g_rvu[g_cnt].rvu07
           AND genacti = 'Y'
        SELECT gen02 INTO g_rvu[g_cnt].rvuconu_desc
          FROM gen_file
         WHERE gen01 = g_rvu[g_cnt].rvuconu
           AND genacti = 'Y'
        SELECT gem02 INTO g_rvu[g_cnt].rvu06_desc
          FROM gem_file
         WHERE gem01 = g_rvu[g_cnt].rvu06
           AND gemacti = 'Y'
        #LET g_sql = "SELECT pmc03,pmc930 FROM ",l_dbs CLIPPED,"pmc_file", #FUN-A50102 
         LET g_sql = "SELECT pmc03,pmc930 FROM ",cl_get_target_table(g_rvu[g_cnt].rvuplant, 'pmc_file'), #FUN-A50102
                " WHERE pmc01 = ? AND pmcacti = 'Y'" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_rvu[g_cnt].rvuplant) RETURNING g_sql  #FUN-A50102        
        PREPARE q520_pmc03_cs FROM g_sql
        EXECUTE q520_pmc03_cs USING g_rvu[g_cnt].rvu04
                              INTO g_rvu[g_cnt].rvu04_desc,l_pmc930
        IF l_pmc930 IS NULL THEN
           LET g_rvu[g_cnt].style = '1'
        ELSE
           LET g_rvu[g_cnt].style = '2'
        END IF           
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rvu.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q520_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03  
    
#TQC-A10065 MARK AND ADD-------------------
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01 = g_rvu[l_ac].rvuplant
   #FUN-A50102 ---mark---str---
   #LET g_plant_new = g_rvu[l_ac].rvuplant
   #CALL s_gettrandbs()
   #LET l_dbs = g_dbs_tra
   #LET l_dbs = s_dbstring(l_dbs CLIPPED)
   #FUN-A50102 ---mark---end---
#TQC-A10065 MARK AND ADD------------------- 

    LET g_sql = "SELECT rvv02,rvv04,rvv05,rvv31,rvv031,'',rvv35,'',rvv35_fac,",
                "       rvv17,rvv32,'',rvv38,rvv38t,rvv39,rvv39t,'','','',",
                "       rvv36,rvv37,'','',rvv12,rvv13",
                #"  FROM ",l_dbs CLIPPED,"rvv_file", #FUN-A50102
                 "  FROM ",cl_get_target_table(g_rvu[l_ac].rvuplant, 'rvv_file'), #FUN-A50102
                " WHERE rvv01 = '",g_rvu[l_ac].rvu01,"'",
                "   AND rvvplant = '",g_rvu[l_ac].rvuplant,"'",
                "   AND ",p_wc2 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvu[l_ac].rvuplant) RETURNING g_sql  #FUN-A50102
    PREPARE q520_pb2 FROM g_sql
    DECLARE q520_cs2 CURSOR FOR q520_pb2
    
    #LET g_sql = "SELECT ima021 FROM ",l_dbs CLIPPED,"ima_file", #FUN-A50102
     LET g_sql = "SELECT ima021 FROM ",cl_get_target_table(g_rvu[l_ac].rvuplant, 'ima_file'), #FUN-A50102
                " WHERE ima01 = ? AND imaacti = 'Y'" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvu[l_ac].rvuplant) RETURNING g_sql  #FUN-A50102
    PREPARE q520_ima021_cs FROM g_sql
    
    LET g_sql = "SELECT pmm21,pmm43,pmm909,pmn24,pmn25 ",
                #"  FROM ",l_dbs CLIPPED,"pmm_file,", #FUN-A50102
                #          l_dbs CLIPPED,"pmn_file",   #FUN-A50102
                 "  FROM ",cl_get_target_table(g_rvu[l_ac].rvuplant, 'pmm_file'),   #FUN-A50102
                           cl_get_target_table(g_rvu[l_ac].rvuplant, 'pmn_file'),   #FUN-A50102
                " WHERE pmm01 = pmn01 AND pmm01 = ? " 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvu[l_ac].rvuplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q520_pmm_cs FROM g_sql
    CALL g_rvv.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q520_cs2 INTO g_rvv[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q520_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF       
        EXECUTE q520_ima021_cs USING g_rvv[g_cnt].rvv04
                                INTO g_rvv[g_cnt].ima021
        EXECUTE q520_pmm_cs USING g_rvv[g_cnt].rvv36
                             INTO g_rvv[g_cnt].pmm21,g_rvv[g_cnt].pmm43,
                                  g_rvv[g_cnt].pmm909,g_rvv[g_cnt].pmn24,
                                  g_rvv[g_cnt].pmn25
        SELECT gfe02 INTO g_rvv[g_cnt].rvv35_desc
          FROM gfe_file
         WHERE gfe01 = g_rvv[g_cnt].rvv35   
           AND gfeacti = 'Y'        
        SELECT imd02 INTO g_rvv[g_cnt].rvv32_desc
          FROM imd_file
         WHERE imd01 = g_rvv[g_cnt].rvv32
           AND imdacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rvv.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q520_bp2()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
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
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION q520_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_rvu TO s_rvu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b!=0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q520_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b2)
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
