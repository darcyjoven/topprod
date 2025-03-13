# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: artq511.4gl
# Descriptions...: 請購轉採購狀況查詢
# Date & Author..: FUN-870007 09/08/27 By Zhangyajun
# Memo...........: 由apmq511客制而來
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10056 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm_wc  LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(500)
    tm_wc1 LIKE type_file.chr1000,
    g_pml  RECORD
            pml01		LIKE pml_file.pml01, #請購單號
            pml02		LIKE pml_file.pml02, #項次
            pml011		LIKE pml_file.pml011,
            pml16		LIKE pml_file.pml16,
            pml04   	        LIKE pml_file.pml04, #料號
            pml041	        LIKE pml_file.pml041,#品名
            pmk04   	        LIKE pmk_file.pmk04, #
            pml07		LIKE pml_file.pml07, #單位
            pml20		LIKE pml_file.pml20, #請購數量
            pml21       LIKE pml_file.pml21, #已轉數量
            rest        LIKE pml_file.pml21, #未轉數量
            pml83       LIKE pml_file.pml83,
            pml85       LIKE pml_file.pml85,
            pml80       LIKE pml_file.pml80,
            pml82       LIKE pml_file.pml82,
            pmlplant    LIKE pml_file.pmlplant
        END RECORD,
    g_pmn DYNAMIC ARRAY OF RECORD
            pmm04       LIKE pmm_file.pmm04, #採購日期
            pmn01       LIKE pmn_file.pmn01,
            pmn02       LIKE pmn_file.pmn02,
            pmc03       LIKE pmc_file.pmc03,
            pmn04       LIKE pmn_file.pmn04,
            pmn20       LIKE pmn_file.pmn20,
            pmn07       LIKE pmn_file.pmn07,
            #FUN-570175  --begin
            pmn83       LIKE pmn_file.pmn83,
            pmn85       LIKE pmn_file.pmn85,
            pmn80       LIKE pmn_file.pmn80,
            pmn82       LIKE pmn_file.pmn82,
            #FUN-570175  --end
            pmn16       LIKE pmn_file.pmn16,
            pmn33       LIKE pmn_file.pmn33,
            pmn42       LIKE pmn_file.pmn42,
            pmn62       LIKE pmn_file.pmn62,
            pmn61       LIKE pmn_file.pmn61
        END RECORD,
    g_order         LIKE type_file.num5,          #No.FUN-680136 SMALLINT
    g_sum           LIKE pmn_file.pmn20,
    g_argv1         LIKE pml_file.pml01,          #INPUT ARGUMENT - 1
    g_argv2         LIKE pml_file.pml02,
    g_sql           string,                       #WHERE CONDITION  #No.FUN-580092 HCN
    g_sql1          string,                       #WHERE CONDITION  #bnl 
    g_sql2          string,                       #WHERE CONDITION  #bnl 
    g_sql3          string,                      
    g_rec_b         LIKE type_file.num5           #單身筆數 #No.FUN-680136 SMALLINT
DEFINE   g_cnt          LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000,   #No.FUN-680136
         l_ac           LIKE type_file.num5       #目前處理的ARRAY CNT #No.FUN-680136 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE   g_azp01        LIKE azp_file.azp01     
DEFINE   g_azp03        LIKE azp_file.azp03      
 
MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_argv1 = ARG_VAL(1)          #參數值(1) Part#
    LET g_argv2 = ARG_VAL(2)
 
    OPEN WINDOW q511_w WITH FORM "art/42f/artq511"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    CALL q511_def_form()
 
    IF NOT cl_null(g_argv1) THEN call q511_q() END IF
 
    CALL q511_menu()
 
    CLOSE WINDOW q511_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q511_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   IF NOT cl_null(g_argv1) THEN
      LET tm_wc = "pml01 = '",g_argv1,"' AND pml02 =",g_argv2
   ELSE
      CLEAR FORM #清除畫面
      CALL g_pmn.clear()
      CALL cl_opmsg('q')
      LET tm_wc = NULL
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pml.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm_wc ON pml01, pml02, pml04, pml041,
                                 pml011,pmk04, pml16, pmlplant,
                                 pml07, pml20, pml21,
                                 pml83, pml85, pml80, pml82  #FUN-570175
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pmlplant) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = 'c'
               LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmlplant
               NEXT FIELD pmlplant
         END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
      IF INT_FLAG THEN RETURN END IF
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #         LET tm_wc = tm_wc clipped," AND pmluser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #         LET tm_wc = tm_wc clipped," AND pmlgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #         LET tm_wc = tm_wc clipped," AND pmlgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET tm_wc = tm_wc CLIPPED,cl_get_extra_cond('pmluser', 'pmlgrup')
      #End:FUN-980030
 
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql1 = NULL
   LET g_sql2 = NULL
  #LET g_sql3 = "SELECT azp01,azp03 FROM azp_file,zxy_file ", #TQC-A10056 MARK
#   LET g_sql3 = "SELECT azp01 FROM azp_file,zxy_file ",        #TQC-A10056 add #TQC-B90175 mark
   LET g_sql3 = "SELECT azp01,azp03 FROM azp_file,zxy_file ",        #TQC-B90175 add
                " WHERE zxy01 = '",g_user,"' ",
                "   AND zxy03 = azp01  "
   PREPARE pre_sel_tqb FROM g_sql3
   DECLARE q511_DB_cs CURSOR FOR pre_sel_tqb
  #FOREACH q511_DB_cs INTO g_azp01,g_azp03 #TQC-A10056 MARK
#   FOREACH q511_DB_cs INTO g_azp01         #TQC-A10056 add #TQC-B90175 mark
   FOREACH q511_DB_cs INTO g_azp01,g_azp03         #TQC-B90175 add
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:q511_DB_cs',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
#TQC-B90175 add START------------------------------
   IF NOT cl_chk_schema_has_built(g_azp03) THEN
      CONTINUE FOREACH
   END IF
#TQC-B90175 add END--------------------------------
   #FUN-A50102 ---mark---str---
    #TQC-A10056 ADD--------
     #LET g_plant_new = g_azp01
     #CALL s_gettrandbs()
     #LET g_dbs=g_dbs_tra
    #TQC-A10056 END---------
   #FUN-A50102 ---mark---end---  
     LET g_sql=" SELECT pml01,pml02,pmlplant FROM ",
              #s_dbstring(g_azp03),"pml_file, ",s_dbstring(g_azp03),"pmk_file ",#TQC-A10056 MARK
               #s_dbstring(g_dbs),"pml_file, ",s_dbstring(g_dbs),"pmk_file ",    #TQC-A10056 add #FUN-A50102
               cl_get_target_table(g_azp01, 'pml_file'),",",cl_get_target_table(g_azp01, 'pmk_file'), #FUN-A50102
               " WHERE pml02 is not null AND ",tm_wc CLIPPED, 
               "   AND pml01=pmk01",
               "   AND pmkplant='",g_azp01,"'  "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #TQC-B90175 add
     CALL cl_parse_qry_sql(g_sql, g_azp01) RETURNING g_sql    #TQC-B90175 add   
     IF g_sql1 IS NULL  THEN
        LET g_sql1 = g_sql
     ELSE
        LET g_sql1 = g_sql1," UNION ALL ",g_sql
     END IF
   END FOREACH
   LET g_sql1 = g_sql1," ORDER BY pml01,pml02 " 
#   CALL cl_replace_sqldb(g_sql1) RETURNING g_sql1             #FUN-A50102   #TQC-B90175 mark
#   CALL cl_parse_qry_sql(g_sql1, g_azp01) RETURNING g_sql1    #FUN-A50102   #TQC-B90175 mark
   PREPARE q511_prepare FROM g_sql1
   DECLARE q511_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q511_prepare
   LET g_sql2 = "SELECT COUNT(*) FROM ","(",g_sql1,")" 
#   CALL cl_replace_sqldb(g_sql2) RETURNING g_sql2             #FUN-A50102   #TQC-B90175 mark
#   CALL cl_parse_qry_sql(g_sql2, g_azp01) RETURNING g_sql2    #FUN-A50102   #TQC-B90175 mark
   PREPARE q511_pp FROM g_sql2
   DECLARE q511_cnt   CURSOR FOR q511_pp
 
END FUNCTION
 
FUNCTION q511_menu()
 
   WHILE TRUE
      CALL q511_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q511_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "收貨明細查詢"
         WHEN "qry_receipts_details"
            CALL q511_detail()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q511_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q511_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q511_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q511_cnt
       FETCH q511_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt
       CALL q511_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
 
END FUNCTION
 
FUNCTION q511_fetch(p_flag)
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式     #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數   #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q511_cs INTO g_pml.pml01,g_pml.pml02,g_pml.pmlplant
        WHEN 'P' FETCH PREVIOUS q511_cs INTO g_pml.pml01,g_pml.pml02,g_pml.pmlplant
        WHEN 'F' FETCH FIRST    q511_cs INTO g_pml.pml01,g_pml.pml02,g_pml.pmlplant
        WHEN 'L' FETCH LAST     q511_cs INTO g_pml.pml01,g_pml.pml02,g_pml.pmlplant
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso q511_cs INTO g_pml.pml01,g_pml.pml02,g_pml.pmlplant
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pml.pml01,SQLCA.sqlcode,0)
        INITIALIZE g_pml.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF 
  #FUN-A50102 ---mark---str---  
  #TQC-A10056 MARK AND ADD START-------------------------------- 
  #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_pml.pmlplant
   #LET g_plant_new = g_pml.pmlplant
   #CALL s_gettrandbs()
   #LET l_dbs = g_dbs_tra
  #TQC-A10056 MARK AND ADD END--------------------------------
  #FUN-A50102 ---mark---str---
   LET g_sql =" SELECT pml01, pml02, pml011, pml16, pml04, pml041, pmk04, ",
              " pml07, pml20, pml21, pml20-pml21,pml83, pml85, pml80, pml82, " ,
              " pmlplant ",
             #" FROM ",s_dbstring(l_dbs),"pml_file, ",s_dbstring(l_dbs),"pmk_file  ", #FUN-A50102
              " FROM ",cl_get_target_table(g_pml.pmlplant, 'pml_file'),",",cl_get_target_table(g_pml.pmlplant, 'pmk_file'), #FUN-A50102
       	      "  WHERE pml01 = '",g_pml.pml01,"' ",
              "  AND pml02 = '",g_pml.pml02,"' ",
              " AND pml01=pmk01 AND pmkplant = '",g_pml.pmlplant,"' " 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                    #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_pml.pmlplant) RETURNING g_sql    #FUN-A50102
    PREPARE q511_db_prepare FROM g_sql
    EXECUTE q511_db_prepare INTO g_pml.*
    CALL q511_show()
 
END FUNCTION
 
FUNCTION q511_show()
DEFINE l_dbs     LIKE azp_file.azp03
 
   DISPLAY BY NAME g_pml.pml01,g_pml.pml02,g_pml.pml011,g_pml.pml16,
                   g_pml.pmk04,g_pml.pml04,
                   g_pml.pml041,g_pml.pml20,g_pml.pml21,g_pml.pml07 ,
                   g_pml.rest,g_pml.pml83,g_pml.pml85,g_pml.pml80,g_pml.pml82 #FUN-570175
  #FUN-A50102 ---mark---str---
  #TQC-A10056 MARK AND ADD START--------------------------------
  #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_pml.pmlplant
   #LET g_plant_new = g_pml.pmlplant
   #CALL s_gettrandbs()
   #LET l_dbs = g_dbs_tra
  #TQC-A10056 MARK AND ADD END--------------------------------
  #FUN-A50102 ---mark---end---
   # 顯示單頭值
   DISPLAY g_pml.pmlplant TO pmlplant
   #LET g_sql = "SELECT ima02 FROM ",s_dbstring(l_dbs),"ima_file WHERE ima01 = '",g_pml.pml04,"'" #FUN-A50102
   LET g_sql = "SELECT ima02 FROM ",cl_get_target_table(g_pml.pmlplant, 'ima_file')," WHERE ima01 = '",g_pml.pml04,"'" #FUN-A50102
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                    #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, g_pml.pmlplant) RETURNING g_sql    #FUN-A50102
   PREPARE pre_sel_ima02 FROM g_sql
   EXECUTE pre_sel_ima02 INTO g_pml.pml041
   DISPLAY BY NAME g_pml.pml041
   CALL q511_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q511_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING                        #bnl
   DEFINE l_dbs     LIKE azp_file.azp03
  
  #FUN-A50102 ---mark---str---
  #TQC-A10056 MARK AND ADD START--------------------------------
  # SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_pml.pmlplant
   #LET g_plant_new = g_pml.pmlplant
   #CALL s_gettrandbs()
   #LET l_dbs = g_dbs_tra
  #TQC-A10056 MARK AND ADD END-------------------------------- 
  #FUN-A50102 ---mark---end---
   LET l_sql =
        "SELECT pmm04, pmn01, pmn02, pmc03, pmn04,pmn20, pmn07, ",
        "       pmn83, pmn85, pmn80, pmn82, pmn16, pmn33,",
        "                            pmn42, pmn62, pmn61, ''",
        #" FROM  ",s_dbstring(l_dbs),"pmn_file, ",s_dbstring(l_dbs),"pmm_file",  #FUN-A50102
        #" LEFT JOIN ",s_dbstring(l_dbs),"pmc_file  ON pmc_file.pmc01 = pmm09",  #FUN-A50102
        " FROM  ",cl_get_target_table(g_pml.pmlplant, 'pmn_file'),",",cl_get_target_table(g_pml.pmlplant, 'pmm_file'),  #FUN-A50102 
        " LEFT JOIN ",cl_get_target_table(g_pml.pmlplant, 'pmc_file'),"  ON pmc_file.pmc01 = pmm09",   #FUN-A50102
        " WHERE pmn24 = '",g_pml.pml01,"'",
        " AND   pmn25 =  ",g_pml.pml02,
        " AND pmn01 = pmm01 ",
        "  AND pmm18 <> 'X'",
        " AND pmmplant = '",g_pml.pmlplant,"' ",
        " ORDER BY pmn01,pmn02"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql                    #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, g_pml.pmlplant) RETURNING l_sql    #FUN-A50102 
    PREPARE q511_pb FROM l_sql
    DECLARE q511_bcs                       #BODY CURSOR
        CURSOR FOR q511_pb
 
    CALL g_pmn.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    LET g_sum = 0
    FOREACH q511_bcs INTO g_pmn[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_sum = g_sum + g_pmn[g_cnt].pmn20
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_pmn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY g_sum TO sum
END FUNCTION
 
FUNCTION q511_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q511_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q511_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q511_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q511_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q511_fetch('L')
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
         CALL q511_def_form()   #FUN-610006
	 EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 收貨明細查詢
      ON ACTION qry_receipts_details
         LET g_action_choice="qry_receipts_details"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
        #No.MOD-530688  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
       #No.MOD-530688  --end
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
 
FUNCTION q511_detail()
DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
    IF cl_null (g_pmn[1].pmn01)  THEN
       CALL cl_err ('','apm-207',0)
       RETURN
    END IF
    LET l_ac  = ARR_CURR()
    LET l_sql = "artq512 '",g_pmn[l_ac].pmn01,"' '",g_pmn[l_ac].pmn02,"' '",g_pml.pmlplant,"'"   #bnl modfiy
 
    CALL cl_cmdrun(l_sql)
END FUNCTION
 
FUNCTION q511_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
       CALL cl_set_comp_visible("pml80,pml82,pml83,pml85",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pml83",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pml85",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pml80",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pml82",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pml83",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pml85",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
       CALL cl_getmsg('asm-359',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pml80",g_msg CLIPPED)
       CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
       CALL cl_getmsg('asm-360',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pml82",g_msg CLIPPED)
       CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
    END IF
END FUNCTION
#No.FUN-870007
