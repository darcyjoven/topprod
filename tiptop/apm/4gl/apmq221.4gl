# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: apmq221.4gl
# Descriptions...: 料件採購單價查詢
# Date & Author..: 93/05/19 By Roger
# Modify.........: No.MOD-480485 04/09/14 By Smapmin 調整為可以顯示上下筆之功能
# Modify.........: No.FUN-4A0075 04/10/11 By Carol 料件編號要開窗
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-570175 05/07/18 By Elva  新增雙單位內容
# Modify.........: No.FUN-610018 06/01/10 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-C30079 12/04/10 By Sakura 於採購單號後增加顯示項次
# Modify.........: No.TQC-CC0055 12/12/11 By yuhuabao 單身多出一行無資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE g_argv1	LIKE ima_file.ima01    # 所要查詢的key
  DEFINE g_wc,g_wc2	string                 # WHERE CONDICTION  #No.FUN-580092 HCN
  DEFINE g_sql          string                 #No.FUN-580092 HCN
  DEFINE g_ima RECORD
		ima01	LIKE ima_file.ima01,
		ima02	LIKE ima_file.ima02,
		ima021  LIKE ima_file.ima021,
		ima08	LIKE ima_file.ima08
       		END RECORD
  DEFINE g_sr DYNAMIC ARRAY OF RECORD
       		pmn01   LIKE pmn_file.pmn01,
            #darcy:2024/07/05 add s---
            pmm12   like pmm_file.pmm12,
            gen02   like gen_file.gen02,
            #darcy:2024/07/05 add e---
            pmn02   LIKE pmn_file.pmn02,   #FUN-C30079 add
       		pmm25   LIKE pmm_file.pmm25,
       		pmm09   LIKE pmm_file.pmm09,
       		pmc03   LIKE pmc_file.pmc03,
       		pmn33   LIKE pmn_file.pmn33,
       		pmn20   LIKE pmn_file.pmn20,   #No.FUN-680136 INTEGER
       		pmm22   LIKE pmm_file.pmm22,
       		pmm21   LIKE pmm_file.pmm21,
       		pmm43   LIKE pmm_file.pmm43,
       		pmn31   LIKE pmn_file.pmn31,
       		pmn31t  LIKE pmn_file.pmn31t,
       		pmn07   LIKE pmn_file.pmn07,
           #FUN-570175  --begin
       		pmn86   LIKE pmn_file.pmn86,
       		pmn87   LIKE pmn_file.pmn87
           #FUN-570175  --end
       	      END RECORD
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_msg          LIKE ze_file.ze03,     #No.FUN-680136 VARCHAR(72)
         g_rec_b        LIKE type_file.num5,   #No.FUN-680136 SMALLINT  #單身筆數
         l_ac           LIKE type_file.num5    #No.FUN-680136 SMALLINT  #目前處理的ARRAY CNT
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01    #No.FUN-580031  HCN


MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW q221_w WITH FORM "apm/42f/apmq221"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    #FUN-570175  --begin
    IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       CALL cl_set_comp_visible("pmn86,pmn87",FALSE)
    END IF
    IF NOT cl_null(g_argv1) THEN CALL q221_q() END IF
    CALL q221_menu()
    CLOSE WINDOW q221_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q221_cs()
   DEFINE   l_cnt LIKE type_file.num5   #No.FUN-680136 SMALLINT 
 
   IF NOT cl_null(g_argv1)
      THEN LET g_wc = "ima01 = '",g_argv1,"'"
		   LET g_wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_sr.clear()
         CALL cl_opmsg('q')
         CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_ima.* TO NULL    #No.FUN-750051
         CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021 # 螢幕上取單頭條件
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
 
#FUN-4A0075
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(ima01) #料件編號
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_ima"
                       LET g_qryparam.state = 'c'
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO ima01
                       NEXT FIELD ima01
               END CASE
##
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
         END CONSTRUCT
         IF INT_FLAG THEN RETURN END IF
	 LET g_wc2=" 1=1 "
         #資料權限的檢查
         #Begin:FUN-980030
         #         IF g_priv2='4' THEN                           #只能使用自己的資料
         #            LET g_wc = g_wc clipped," AND imauser = '",g_user,"'"
         #         END IF
         #         IF g_priv3='4' THEN                           #只能使用相同群的資料
         #            LET g_wc = g_wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
         #         END IF
 
         #         IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         #            LET g_wc = g_wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
         #         END IF
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
         #End:FUN-980030
 
#          CALL q221_b_askkey()
#          IF INT_FLAG THEN RETURN END IF
   END IF
 
	MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE ima_file.ima01",
             "  FROM ima_file,pmm_file,pmn_file ",
             " WHERE ima01=pmn04 AND pmn01=pmm01 AND ",g_wc CLIPPED,
             "   AND pmm25 NOT IN ('X','0','9')",
             " ORDER BY ima01"
   PREPARE q221_prepare FROM g_sql
   DECLARE q221_cs SCROLL CURSOR FOR q221_prepare
   LET g_sql=" SELECT COUNT(UNIQUE ima01)",
             "  FROM ima_file,pmm_file,pmn_file ",
             " WHERE ima01=pmn04 AND pmn01=pmm01 AND ",g_wc CLIPPED,
             "   AND pmm25 NOT IN ('X','0','9')"
   PREPARE q221_pp  FROM g_sql
   DECLARE q221_cnt   CURSOR FOR q221_pp
END FUNCTION
 
FUNCTION q221_b_askkey()
   CONSTRUCT g_wc2 ON pmn01 FROM s_sr[1].pmn01
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
 
FUNCTION q221_menu()
 
   WHILE TRUE
      CALL q221_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q221_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sr),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q221_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q221_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q221_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q221_cnt
         FETCH q221_cnt INTO g_row_count #MOD-480485
         DISPLAY g_row_count TO FORMONLY.cnt #MOD-480485
        CALL q221_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q221_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1) #處理方式
    l_abso          LIKE type_file.num10   #No.FUN-680136 INTEGER #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q221_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q221_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q221_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q221_cs INTO g_ima.ima01
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
          FETCH ABSOLUTE l_abso q221_cs INTO g_ima.ima01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
	SELECT ima01,ima02,ima021,ima08 INTO g_ima.* FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660129
        INITIALIZE g_ima.* TO NULL
        RETURN
    END IF
 
    CALL q221_show()
END FUNCTION
 
FUNCTION q221_show()
   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima08
   CALL q221_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q221_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1000)
   DEFINE l_tot     LIKE type_file.num10   #No.FUN-680136 INTEGER
 
   LET l_sql =
        "SELECT pmn01,pmm12,gen02,pmn02,pmm25,pmm09,pmc03,pmn33,pmn20,pmm22,pmm21,pmm43,pmn31,pmn31t,pmn07,", #FUN-C30079 add pmn02
        #darcy:2024/07/05 add pmm12
        "       pmn86,pmn87 ",   #FUN-570175
        "  FROM pmn_file, gen_file, pmm_file, OUTER pmc_file", #darcy:2024/07/05 add
        " WHERE pmn04 = '",g_ima.ima01,"' AND ", g_wc2 CLIPPED,
        "   and gen01 = pmm12 ", #darcy:2024/07/05 add
        "   AND pmn01 = pmm01 AND pmm_file.pmm09 = pmc_file.pmc01",
        "   AND pmm25 NOT IN ('X','0','9')",
        " ORDER BY pmn33 DESC "
    PREPARE q221_pb FROM l_sql
    DECLARE q221_bcs CURSOR FOR q221_pb
 
    FOR g_cnt = 1 TO g_sr.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sr[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET l_tot = 0
    FOREACH q221_bcs INTO g_sr[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_sr.deleteElement(g_cnt)#TQC-CC0055 add
    LET g_rec_b=(g_cnt-1)
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q221_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   #No.FUN-680136 VARCHAR(1) 
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q221_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q221_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q221_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q221_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q221_fetch('L')
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
 
