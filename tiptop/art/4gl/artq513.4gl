# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: apmq513.4gl
# Descriptions...: 驗收單處理狀況查詢
# Date & Author..: No.FUN-870007 09/02/18 By Zhangyajun
# Memo ..........: 由apmq513客制而來
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10062 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-B30181 11/03/28 By lilingyu 增加顯示當前筆數欄位
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1  LIKE   rva_file.rva01,       
    g_argv2  LIKE   rva_file.rvaplant,
    g_rva    RECORD LIKE rva_file.*,
    g_rvb    RECORD LIKE rvb_file.*,
    g_rest   LIKE   rvb_file.rvb07,
    g_rva01  LIKE   rva_file.rva01,
    g_rvb02  LIKE   rvb_file.rvb02,
    g_rvaplant LIKE   rva_file.rvaplant,
    g_ima02  LIKE   ima_file.ima02,
    g_pmc03  LIKE   pmc_file.pmc03,
    g_pmn041 LIKE   pmn_file.pmn041,
    g_ima021 LIKE   ima_file.ima021,
    g_pmn07  LIKE   pmn_file.pmn07,
    g_rvv17_s LIKE  rvv_file.rvv17,
    g_cond    LIKE  ze_file.ze03,          # No.FUN-680136 VARCHAR(10) 
    g_wc,g_wc2      string,                #No.FUN-580092 HCN
    g_sql    string,                       #No.FUN-580092 HCN
    g_rvv DYNAMIC ARRAY OF RECORD
            rvu03   LIKE rvu_file.rvu03,
            rvu01   LIKE rvu_file.rvu01,
            rvv02   LIKE rvv_file.rvv02,
            str     LIKE ze_file.ze03,     # No.FUN-680136 VARCHAR(4) 
            rvv17   LIKE rvv_file.rvv17,
            rvv32   LIKE rvv_file.rvv32,
            rvv33   LIKE rvv_file.rvv33,
            rvv34   LIKE rvv_file.rvv34,
            rvv25   LIKE rvv_file.rvv25
        END RECORD,
    g_rec_b         LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE ze_file.ze03,     #No.FUN-680136 VARCHAR(72)
       l_ac         LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680136 SMALLINT
 
DEFINE g_row_count  LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_dbs LIKE azp_file.azp03
 
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
 
 
    LET g_argv1= ARG_VAL(1)
    LET g_argv2 = ARG_VAL(1) 
  
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
    INITIALIZE g_rva.* TO NULL
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q513_w AT p_row,p_col
         WITH FORM "art/42f/artq513"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    IF g_argv1 <> ' ' THEN CALL q513_q() END IF
    CALL q513_menu()
    CLOSE WINDOW q513_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q513_cs()
DEFINE l_dbs LIKE azp_file.azp03
DEFINE g_sql2 STRING 
DEFINE g_chk_rvaplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add 
   LET g_chk_rvaplant = TRUE 
   CLEAR FORM
   CALL g_rvv.clear()
    IF g_argv1 <> ' ' THEN
       LET g_wc =" rva01='",g_argv1,"'"
       IF g_argv2 IS NOT NULL THEN
          LET g_wc = g_wc," AND rvaplant = '",g_argv2,"'"
          LET g_chk_rvaplant = FALSE
       END IF
       LET g_wc2=" 1=1"
     ELSE
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
       INITIALIZE g_rva01 TO NULL    #No.FUN-750051
       INITIALIZE g_rvb02 TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           rva01, rvb02, rvb04, rvb03, rvb05,
           rva05, rva06, rvb19, rvb18, rvaplant,      #FUN-870007-add-rvaplant
           rvb08, rvb07, rvb30,
           rvb29, rvb06
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
     AFTER FIELD rvaplant
       IF get_fldbuf(rvaplant) IS NOT NULL THEN
          LET g_chk_rvaplant = FALSE
       END IF
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(rvb05)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_rvb.rvb05
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvb05
            NEXT FIELD rvb05
          WHEN INFIELD(rvaplant)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azp"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_rva.rvaplant
            LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvaplant
            NEXT FIELD rvaplant
         OTHERWISE
            EXIT CASE
       END CASE
     #--
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET g_wc = g_wc clipped," AND rvauser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET g_wc = g_wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET g_wc = g_wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
       #End:FUN-980030
 
       CALL q513_b_askkey()
    END IF
    LET g_chk_auth = ''
    LET g_sql2 = ''
    IF g_chk_rvaplant THEN
      DECLARE q513_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q513_zxy_cs INTO l_zxy03
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
#TQC-A10062 MARK AND ADD START--------------------------------
 # LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
 #              " WHERE zxy01 = '",g_user,"' ",
 #              "   AND zxy03 = azp01  "
 # IF g_argv2 IS NOT NULL THEN
 #    LET g_sql = g_sql," AND azp01 = '",g_argv2,"'"
 # END IF
   LET g_sql = "SELECT DISTINCT zxy03 FROM zxy_file ",
                " WHERE zxy01 = '",g_user,"' "
   IF g_argv2 IS NOT NULL THEN
      LET g_sql = g_sql," AND zxy03 = '",g_argv2,"'"
   END IF
#TQC-A10062 MARK AND ADD END----------------------------------
   PREPARE q513_pre FROM g_sql
   DECLARE q513_DB_cs CURSOR FOR q513_pre
  #FOREACH q513_DB_cs INTO l_dbs        #TQC-A10062 MARK
   FOREACH q513_DB_cs INTO l_zxy03      #TQC-A10062 ADD
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:q513_DB_cs',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
#TQC-B90175 add START------------------------------
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
     IF NOT cl_chk_schema_has_built(l_azp03) THEN
        CONTINUE FOREACH
     END IF
#TQC-B90175 add END--------------------------------
  #FUN-A50102 ---mark---str---
  #TQC-A10062 ADD--------------------------
   #LET g_plant_new = l_zxy03
   #CALL s_gettrandbs()
   #LET l_dbs = g_dbs_tra
  #TQC-A10062 end-------------------------- 
  #FUN-A50102 ---mark---end---
     IF g_wc2 = ' 1=1' THEN
	    LET g_sql="SELECT rva01,rvb02,rvaplant ",
                      #"  FROM ",s_dbstring(l_dbs),"rva_file,",s_dbstring(l_dbs),"rvb_file ",  #FUN-A50102
                       "  FROM ",cl_get_target_table(l_zxy03, 'rva_file'),",",cl_get_target_table(l_zxy03, 'rvb_file'),  #FUN-A50102
                      " WHERE rva01 = rvb01 ",
                      "   AND rvaplant = rvbplant ",
                      "   AND rvaconf !='X' AND ",
                      g_wc CLIPPED
      ELSE
	    LET g_sql="SELECT rva01,rvb02,rvaplant ",
                      #"  FROM ",s_dbstring(l_dbs),"rva_file,",s_dbstring(l_dbs),"rvb_file, ",  #FUN-A50102
                      #          s_dbstring(l_dbs),"rvu_file,",s_dbstring(l_dbs),"rvv_file ",   #FUN-A50102
                      "  FROM ",cl_get_target_table(l_zxy03, 'rva_file'),",",cl_get_target_table(l_zxy03, 'rvb_file'),",",  #FUN-A50102
                                cl_get_target_table(l_zxy03, 'rvu_file'),",",cl_get_target_table(l_zxy03, 'rvv_file'),  #FUN-A50102
                      " WHERE rva01 = rvb01 ",
                      "   AND rvaplant = rvbplant ",
                      "   AND ",g_wc CLIPPED,
                            " AND rvv04 = rvb01 ",
                            " AND rvv05 = rvb02 ",
                            " AND rvvplant = rvbplant ",
                            " AND rvv01 = rvu01 ",
                            " AND rvvplant = rvuplant ",
                            " AND rvaconf !='X' AND ",g_wc2 CLIPPED
      END IF
    IF g_chk_rvaplant THEN
        LET g_sql = "(",g_sql," AND rvaplant IN ",g_chk_auth,")"
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
    PREPARE q513_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE q513_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q513_prepare
    LET g_sql = "SELECT COUNT(*) FROM (",g_sql,")"
    PREPARE q513_precount FROM g_sql
    DECLARE q513_count CURSOR FOR q513_precount
END FUNCTION
 
FUNCTION q513_menu()
 
   WHILE TRUE
      CALL q513_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q513_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "料件庫存資料"
         WHEN "item_inventory"
            CALL q513_1()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvv),'','')
            END IF
 
      END CASE
   END WHILE
      CLOSE q513_cs
END FUNCTION
 
FUNCTION q513_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q513_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
   CALL g_rvv.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
        OPEN q513_count
        FETCH q513_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q513_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)
        INITIALIZE g_rva.* TO NULL
    ELSE
        CALL q513_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q513_fetch(p_flrva)
    DEFINE
        p_flrva         LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1) 
        l_abso          LIKE type_file.num10         #No.FUN-680136 INTEGER
    
    CASE p_flrva
        WHEN 'N' FETCH NEXT     q513_cs INTO g_rva01,g_rvb02,g_rvaplant
        WHEN 'P' FETCH PREVIOUS q513_cs INTO g_rva01,g_rvb02,g_rvaplant
        WHEN 'F' FETCH FIRST    q513_cs INTO g_rva01,g_rvb02,g_rvaplant
        WHEN 'L' FETCH LAST     q513_cs INTO g_rva01,g_rvb02,g_rvaplant
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
            FETCH ABSOLUTE l_abso q513_cs INTO g_rva01,g_rvb02,g_rvaplant
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)
       INITIALIZE g_rvb.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flrva
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       DISPLAY g_curs_index TO FORMONLY.cnt1                       #TQC-B30181    
    END IF
 
    LET g_rest = 0
   #TQC-A10062 MARK AND ADD STARTING----------------------
   #SELECT azp03 INTO g_dbs FROM azp_file 
   # WHERE azp01 = g_rvaplant
   #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_rvaplant
    #CALL s_gettrandbs()
    #LET g_dbs=g_dbs_tra      
   #FUN-A50102 ---mark---end---
   #TQC-A10062 MARK AND ADD END--------------------------
    #LET g_sql = "SELECT * FROM ",s_dbstring(g_dbs),"rva_file ",        # 先讀 rva_file #FUN-A50102
     LET g_sql = "SELECT * FROM ",cl_get_target_table(g_rvaplant, 'rva_file'),   #FUN-A50102
                " WHERE rva01 = ? AND rvaplant = ?" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvaplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q513_rva_cs FROM g_sql
    EXECUTE q513_rva_cs USING g_rva01,g_rvaplant
                         INTO g_rva.*
    IF SQLCA.sqlcode THEN INITIALIZE g_rva.* TO NULL END IF
 
    LET g_sql = "SELECT rvb_file.*,ima02 ",
                #"  FROM ",s_dbstring(g_dbs),"rvb_file LEFT JOIN ", #FUN-A50102
                #          s_dbstring(g_dbs),"ima_file ON rvb05=ima01", #FUN-A50102
                "  FROM ",cl_get_target_table(g_rvaplant, 'rvb_file')," LEFT JOIN ",     #FUN-A50102
                          cl_get_target_table(g_rvaplant, 'ima_file')," ON rvb05=ima01", #FUN-A50102          
                " WHERE rvb01 = ? AND rvb02 = ? ",
                "   AND rvbplant = ?" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvaplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q513_rvb_cs FROM g_sql
    EXECUTE q513_rvb_cs USING g_rva01,g_rvb02,g_rvaplant
                         INTO g_rvb.*,g_ima02
    IF SQLCA.sqlcode THEN INITIALIZE g_rvb.* TO NULL END IF
 
    #LET g_sql = "SELECT pmc03 FROM ",s_dbstring(g_dbs),"pmc_file ", #FUN-A50102 
     LET g_sql = "SELECT pmc03 FROM ",cl_get_target_table(g_rvaplant, 'pmc_file'), #FUN-A50102
                " WHERE pmc01 = ?" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvaplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q513_pmc_cs FROM g_sql
    EXECUTE q513_pmc_cs USING g_rva.rva05
                         INTO g_pmc03
    IF SQLCA.sqlcode THEN LET g_pmc03 = NULL END IF
 
    #LET g_sql = "SELECT pmn041,pmn07 FROM ",s_dbstring(g_dbs),"pmn_file", #FUN-A50102 
     LET g_sql = "SELECT pmn041,pmn07 FROM ",cl_get_target_table(g_rvaplant, 'pmn_file'), #FUN-A50102
                " WHERE pmn01 = ? AND pmn02 = ?" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvaplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q513_pmn_cs FROM g_sql
    EXECUTE q513_pmn_cs USING g_rvb.rvb04,g_rvb.rvb03
                         INTO g_pmn041,g_pmn07
 
    #LET g_sql = "SELECT ima021 FROM ",s_dbstring(g_dbs),"ima_file", #FUN-A50102
     LET g_sql = "SELECT ima021 FROM ",cl_get_target_table(g_rvaplant, 'ima_file'), #FUN-A50102                                             
                " WHERE ima01 = ?" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvaplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q513_ima_cs FROM g_sql
    EXECUTE q513_ima_cs USING g_rvb.rvb05
                         INTO g_ima021
    IF SQLCA.sqlcode THEN LET g_pmn041 = NULL LET g_pmn07 = NULL END IF
 
    CALL q513_show()                           # 顯示資料
END FUNCTION
 
FUNCTION q513_b_askkey()
   CONSTRUCT g_wc2 ON rvu03,rvu01,rvv02,str,rvv17,rvv32,rvv33,rvv34,rvv25
        FROM s_rvv[1].rvu03,s_rvv[1].rvu01,s_rvv[1].rvv02,s_rvv[1].str,
             s_rvv[1].rvv17,s_rvv[1].rvv32,s_rvv[1].rvv33,s_rvv[1].rvv34,
             s_rvv[1].rvv25
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
END FUNCTION
 
FUNCTION q513_show()
 DEFINE l_str            LIKE ze_file.ze03                 # No.FUN-680136 VARCHAR(4) 
 
     DISPLAY BY NAME g_rva.rva01, g_rvb.rvb02, g_rva.rva05, g_rvb.rvb04,
       g_rvb.rvb03, g_rva.rva06, g_rvb.rvb05, g_rvb.rvb19, g_rvb.rvb08,
       g_rvb.rvb18, g_rvb.rvb07, g_rvb.rvb29, g_rvb.rvb30,g_rva.rvaplant
 
     #LET g_sql="SELECT sum(rvv23) FROM ",s_dbstring(g_dbs),"rvv_file", #FUN-A50102 
      LET g_sql="SELECT sum(rvv23) FROM ",cl_get_target_table(g_rvaplant, 'rvv_file'), #FUN-A50102
               " WHERE rvv04 = '",g_rva.rva01,"'",
               "   AND rvv05 = '",g_rvb.rvb02,"'",
               "   AND rvv03 = '1'" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvaplant) RETURNING g_sql  #FUN-A50102           
    PREPARE sum_rvv23 FROM g_sql
    EXECUTE sum_rvv23 INTO g_rvb.rvb06
    IF SQLCA.sqlcode THEN LET g_rvb.rvb06 = 0  END IF
     DISPLAY BY NAME g_rvb.rvb06
    IF g_rvb.rvb19 ='2' THEN LET g_pmn041 = g_ima02 END IF
    CALL s_iqctype (g_rvb.rvb18) RETURNING g_cond
    CALL s_subdes  (g_rvb.rvb19) RETURNING l_str
    #LET g_sql="SELECT sum(rvv17) FROM ,s_dbstring(g_dbs),"rvv_file,",s_dbstring(g_dbs),"rvu_file", #FUN-A50102 
     LET g_sql="SELECT sum(rvv17) FROM ",cl_get_target_table(g_rvaplant, 'rvv_file'),",",cl_get_target_table(g_rvaplant, 'rvu_file'), #FUN-A50102
              " WHERE rvu01=rvv01 AND rvu00='3' AND rvuconf='Y'",
              "   AND rvv04 = '",g_rva.rva01,"'",
              "   AND rvv05 = '",g_rvb.rvb02,"'" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvaplant) RETURNING g_sql  #FUN-A50102          
    PREPARE sum_rvv17 FROM g_sql
    EXECUTE sum_rvv17 INTO g_rvv17_s 
    LET g_rest=g_rvb.rvb07-g_rvb.rvb30-g_rvb.rvb29
    DISPLAY g_rest, g_pmc03, g_pmn041, g_pmn07, g_cond,l_str, g_ima021,g_rvv17_s
            TO rest, pmc03, pmn041, pmn07, explan,desc,ima021 ,rvv17_s
	CALL q513_b_fill()
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION q513_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(1000)
          l_sta     LIKE ade_file.ade04,          # No.FUN-680136 VARCHAR(4)
          l_rvu00   LIKE rvu_file.rvu00
 
   LET l_sql = "SELECT rvu03,rvu01,rvv02,' ',rvv17,rvv32,rvv33,rvv34,rvv25,",
               "       rvu00 ",
               #" FROM ",s_dbstring(g_dbs),"rvu_file,",s_dbstring(g_dbs),"rvv_file", #FUN-A50102 
               " FROM ",cl_get_target_table(g_rvaplant, 'rvu_file'),",",cl_get_target_table(g_rvaplant, 'rvv_file'), #FUN-A50102
               " WHERE rvv04 = '",g_rva01,"'",
	         " AND rvv05 = '",g_rvb02,"'",
                 " AND rvu01=rvv01 AND rvuconf='Y' ",
		 " AND ",g_wc2 CLIPPED,
               " ORDER BY rvu03,rvu01,rvu02" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_rvaplant) RETURNING g_sql  #FUN-A50102           
    PREPARE q513_pb FROM l_sql
    DECLARE q513_bcs                       #BODY CURSOR
        CURSOR FOR q513_pb
 
    FOR g_cnt = 1 TO g_rvv.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_rvv[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q513_bcs INTO g_rvv[g_cnt].*,l_rvu00
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF l_rvu00!='1' THEN
           LET g_rvv[g_cnt].rvv17=g_rvv[g_cnt].rvv17*(-1)
        END IF
        CASE
          WHEN l_rvu00='1'
               CALL cl_getmsg('apm-243',g_lang) RETURNING g_rvv[g_cnt].str
          WHEN l_rvu00='2'
               CALL cl_getmsg('apm-244',g_lang) RETURNING g_rvv[g_cnt].str
          WHEN l_rvu00='3'
               CALL cl_getmsg('apm-245',g_lang) RETURNING g_rvv[g_cnt].str
        END CASE
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_rvv.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q513_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q513_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q513_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q513_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q513_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q513_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 料件庫存資料
      ON ACTION item_inventory
         LET g_action_choice="item_inventory"
         EXIT DISPLAY
 
   ON ACTION accept
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
   ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q513_1()
   DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(80)
 
   IF g_rva01 IS NULL THEN RETURN END IF
   LET l_cmd = "aimq102 '1' ",g_rvb.rvb05  # 料件編號
   CALL cl_cmdrun(l_cmd)
END FUNCTION
#No.FUN-870007
