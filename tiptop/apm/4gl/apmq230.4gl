# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: apmq230.4gl
# Descriptions...: 廠商最近採購查詢
# Date & Author..: 97/08/28 By Kitty
# Modify.........: No.MOD-480484 04/09/14 By Smapmin調整為可顯示上一筆與下一筆之功能
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-570175 05/07/18 By Elva  新增雙單位內容
# Modify.........: No.FUN-610018 06/01/10 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-960354 09/06/30 By Smapmin 單身出現多行空白行
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
      	wc  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500) 
      	wc2  	LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(500) 
        END RECORD,
    g_pmc   RECORD
        pmc01	LIKE pmc_file.pmc01,
        pmc03	LIKE pmc_file.pmc03
        END RECORD,
    g_pmn DYNAMIC ARRAY OF RECORD
            pmn01   LIKE pmn_file.pmn01,
            pmn04   LIKE pmn_file.pmn04,
            pmn07   LIKE pmn_file.pmn07,
            pmn20   LIKE pmn_file.pmn20,
            #FUN-570175  --begin
            pmn86   LIKE pmn_file.pmn86,
            pmn87   LIKE pmn_file.pmn87,
            #FUN-570175  --end
            pmn31   LIKE pmn_file.pmn31,
            pmn31t  LIKE pmn_file.pmn31t,  #No.FUN-610018
            tot     LIKE pmn_file.pmn31,
            tott    LIKE pmn_file.pmn31t,  #No.FUN-610018
            pmn33   LIKE pmn_file.pmn33
    END RECORD,
    g_argv1         LIKE pmc_file.pmc01,
    g_query_flag    LIKE type_file.num5,   #No.FUN-680136 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_sql           string,                #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num10   #No.FUN-680136 INTEGER #單身筆數
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE ze_file.ze03,     #No.FUN-680136 VARCHAR(72) 
       l_ac         LIKE type_file.num5    #目前處理的ARRAY CNT #No.FUN-680136 SMALLINT
 
DEFINE g_row_count  LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01    #No.FUN-580031  HCN
MAIN
   DEFINE l_time    LIKE type_file.chr8,   #計算被使用時間     #No.FUN-680136 VARCHAR(8)
          l_sl	    LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
        RETURNING l_time
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag =1
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q230_w AT p_row,p_col
        WITH FORM "apm/42f/apmq230"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-570175  --begin
    IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       CALL cl_set_comp_visible("pmn86,pmn87",FALSE)
    END IF
    #FUN-570175  --end
    IF NOT cl_null(g_argv1) THEN CALL q230_q() END IF
    CALL q230_menu()
    CLOSE WINDOW q230_w
 
    CALL cl_used(g_prog,l_time,2) RETURNING l_time
END MAIN
 
#QBE 查詢資料
FUNCTION q230_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "pmc01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_pmn.clear()
         CALL cl_opmsg('q')
         INITIALIZE tm.* TO NULL			# Default condition
         CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmc.* TO NULL    #No.FUN-750051
         CONSTRUCT BY NAME tm.wc ON pmc01,pmc03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
         END CONSTRUCT
         IF INT_FLAG THEN RETURN END IF
         #資料權限的檢查
         #Begin:FUN-980030
         #         IF g_priv2='4' THEN                           #只能使用自己的資料
         #            LET tm.wc = tm.wc clipped," AND pmcuser = '",g_user,"'"
         #         END IF
         #         IF g_priv3='4' THEN                           #只能使用相同群的資料
         #            LET tm.wc = tm.wc clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
         #         END IF
 
         #         IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         #            LET tm.wc = tm.wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
         #         END IF
         LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
         #End:FUN-980030
 
           CALL q230_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT '
   IF tm.wc2=" 1=1" THEN
      LET g_sql=" SELECT pmc01 FROM pmc_file ",
                " WHERE ",tm.wc CLIPPED,
                " ORDER BY pmc01"
    ELSE
      LET g_sql=" SELECT UNIQUE pmc_file.pmc01",
                "  FROM pmc_file,pmm_file,pmn_file ",
                " WHERE pmc01=pmm09 AND pmm01=pmn01",
                "   AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND pmm25 NOT IN ('X','0','9')",
                " ORDER BY pmc01"
   END IF
   PREPARE q230_prepare FROM g_sql
   DECLARE q230_cs SCROLL CURSOR FOR q230_prepare
 
   # 取合乎條件筆數
   IF tm.wc2=" 1=1" THEN
      LET g_sql=" SELECT COUNT(*) FROM pmc_file ",
                " WHERE ",tm.wc CLIPPED
    ELSE
      LET g_sql=" SELECT COUNT(UNIQUE pmc01)",
                "  FROM pmc_file,pmm_file,pmn_file ",
                " WHERE pmc01=pmm09 AND pmm01=pmn01",
                "   AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND pmm25 NOT IN ('X','0','9')"
   END IF
   PREPARE q230_pp  FROM g_sql
   DECLARE q230_cnt   CURSOR FOR q230_pp
END FUNCTION
 
FUNCTION q230_b_askkey()
   #FUN-570175  --begin
   CONSTRUCT tm.wc2 ON pmn01,pmn04,pmn07,pmn20,pmn86,pmn87,pmn31,pmn31t,pmn33   #No.FUN-610018
                  FROM s_pmn[1].pmn01,s_pmn[1].pmn04,s_pmn[1].pmn07,
                       s_pmn[1].pmn20,s_pmn[1].pmn86,s_pmn[1].pmn87,
                       s_pmn[1].pmn31,s_pmn[1].pmn31t,s_pmn[1].pmn33
   #FUN-570175  --end
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION
 
FUNCTION q230_menu()
 
   WHILE TRUE
      CALL q230_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q230_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q230_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL  g_pmn.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q230_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN q230_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
           OPEN q230_cnt
            FETCH q230_cnt INTO g_row_count #MOD-480484
            DISPLAY g_row_count TO cnt #MOD-480484
        CALL q230_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
FUNCTION q230_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1) 
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q230_cs INTO g_pmc.pmc01
        WHEN 'P' FETCH PREVIOUS q230_cs INTO g_pmc.pmc01
        WHEN 'F' FETCH FIRST    q230_cs INTO g_pmc.pmc01
        WHEN 'L' FETCH LAST     q230_cs INTO g_pmc.pmc01
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
            FETCH ABSOLUTE l_abso q230_cs INTO g_pmc.pmc01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
        INITIALIZE g_pmc.* TO NULL  #TQC-6B0105
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
	SELECT pmc01,pmc03
	  INTO g_pmc.pmc01,g_pmc.pmc03
	  FROM pmc_file
	 WHERE pmc01 = g_pmc.pmc01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","pmc_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660129
        RETURN
    END IF
 
    CALL q230_show()
END FUNCTION
 
FUNCTION q230_show()
   DISPLAY BY NAME g_pmc.*   # 顯示單頭值
   CALL q230_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 FUNCTION q230_b_fill() #MOD-480484補上漏打的FUNCTION名稱
 
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000) 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT pmn01,pmn04,pmn07,pmn20,pmn86,pmn87,pmn31,pmn31t, ",
        "       pmn20*pmn31,pmn20*pmn31t,pmn33 ",#FUN-570175  FUN-610018
        "  FROM pmm_file,pmn_file ",
        " WHERE pmm01=pmn01 AND pmm25 NOT IN ('X','0','9') AND ",
        "       pmm09= '",g_pmc.pmc01,"' AND  ",tm.wc2 CLIPPED,
        " ORDER BY pmn33 DESC"
    PREPARE q230_pb FROM l_sql
    DECLARE q230_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q230_pb
    #-----MOD-960354---------
    #FOR g_cnt = 1 TO g_pmn.getLength()           #單身 ARRAY 乾洗
    #   INITIALIZE g_pmn[g_cnt].* TO NULL
    #END FOR
    CALL g_pmn.clear()
    #-----END MOD-960354-----
    LET g_cnt = 1
    FOREACH q230_bcs INTO g_pmn[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_pmn[g_cnt].pmn20 IS NULL THEN
  	       LET g_pmn[g_cnt].pmn20 = 0
        END IF
        #FUN-570175 --begin
        IF NOT cl_null(g_pmn[g_cnt].pmn87) AND cl_null(g_pmn[g_cnt].pmn87) THEN
  	       LET g_pmn[g_cnt].pmn87 = 0
        END IF
        #FUN-570175 --end
        IF g_pmn[g_cnt].pmn31 IS NULL THEN
           LET g_pmn[g_cnt].pmn31 = 0
        END IF
        #No.FUN-610018
        IF g_pmn[g_cnt].pmn31t IS NULL THEN
           LET g_pmn[g_cnt].pmn31t= 0
        END IF
        IF g_pmn[g_cnt].tot   IS NULL THEN
           LET g_pmn[g_cnt].tot   = 0
        END IF
        IF g_pmn[g_cnt].tott  IS NULL THEN
           LET g_pmn[g_cnt].tott  = 0
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_pmn.deleteElement(g_cnt)   #MOD-960354
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
  #     DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q230_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q230_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q230_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q230_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q230_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q230_fetch('L')
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
 
