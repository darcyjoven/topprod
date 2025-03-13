# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: apmq540.4gl
# Descriptions...: 請購轉採購狀況查詢
# Date & Author..: 93/06/15 By Felicity  Tseng
#        David   : 為何未轉出量未顯示
# Modify.........: MOD-480533 04/09/14 Melody 改成用l_ac指定單號+項次,原窗詢問序號作法取消
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-570175 05/07/19 By Elva  新增雙單位內容
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0159 06/11/29 By Ray “匯出EXCEL”輸出的值多出一空白行
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-940013 09/04/21 By jan pml01 欄位增加開窗功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80150 10/09/14 By sabrina GP5.2號機管理
# Modify.........: No.MOD-BB0083 12/01/17 By Vampire 採購數量合計都沒有數量 
# Modify.........: No.MOD-C90010 12/09/03 By Vampire 修正資料權限檢查,資料所有者pmkuser,資料所有部門pmkgrup
# Modify.........: No.TQC-CB0024 12/11/12 By yuhuabao 單頭添加規格欄位,單身添加料號對應的品名規格欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm_wc  LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(500)
    g_pml  RECORD
            pml01		LIKE pml_file.pml01, #請購單號
            pml02		LIKE pml_file.pml02, #項次
            pml011		LIKE pml_file.pml011,
            pml16		LIKE pml_file.pml16,
            pml04   	        LIKE pml_file.pml04, #料號
            pml041	        LIKE pml_file.pml041,#品名   
            ima021              LIKE ima_file.ima021,#規格   #TQC-CB0024 add
            pmk04   	        LIKE pmk_file.pmk04, #
            pml07		LIKE pml_file.pml07, #單位
            pml20		LIKE pml_file.pml20, #請購數量
            pml21       LIKE pml_file.pml21, #已轉數量
            rest        LIKE pml_file.pml21, #未轉數量
            #FUN-570175  --begin
            pml83       LIKE pml_file.pml83,
            pml85       LIKE pml_file.pml85,
            pml80       LIKE pml_file.pml80,
            pml82       LIKE pml_file.pml82
            #FUN-570175  --end
        END RECORD,
    g_pmn DYNAMIC ARRAY OF RECORD
            pmm04       LIKE pmm_file.pmm04, #採購日期
            pmn01       LIKE pmn_file.pmn01,
            pmn02       LIKE pmn_file.pmn02,
            pmc03       LIKE pmc_file.pmc03,
            pmn04       LIKE pmn_file.pmn04,
            pmn041      LIKE pmn_file.pmn041,#品名    #TQC-CB0024 add
            ima021_p    LIKE ima_file.ima021,#規格    #TQC-CB0024 add
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
            pmn919      LIKE pmn_file.pmn919,   #FUN-A80150 add
            pmn42       LIKE pmn_file.pmn42,
            pmn62       LIKE pmn_file.pmn62,
            pmn61       LIKE pmn_file.pmn61,
            ima02_s     LIKE ima_file.ima02, #替代料號品名    #TQC-CB0024 add
            ima021_s    LIKE ima_file.ima021 #替代料號規格    #TQC-CB0024 add
        END RECORD,
    g_order         LIKE type_file.num5,          #No.FUN-680136 SMALLINT
    g_sum           LIKE pmn_file.pmn20,
    g_argv1         LIKE pml_file.pml01,          #INPUT ARGUMENT - 1
    g_sql           string,                       #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5           #單身筆數 #No.FUN-680136 SMALLINT
DEFINE   p_row,p_col    LIKE type_file.num5       #No.FUN-680136 SMALLINT
DEFINE   g_cnt          LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000,   #No.FUN-680136
         l_ac           LIKE type_file.num5       #目前處理的ARRAY CNT #No.FUN-680136 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680136 INTEGER

MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_argv1 = ARG_VAL(1)          #參數值(1) Part#
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q540_w AT p_row,p_col WITH FORM "apm/42f/apmq540"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #-----FUN-610006---------
    CALL q540_def_form()
#   #FUN-570175  --begin
#   IF g_sma.sma115 ='N' THEN
#      CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
#      CALL cl_set_comp_visible("pml80,pml82,pml83,pml85",FALSE)
#   END IF
#   IF g_sma.sma122 ='1' THEN
#      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pml83",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
#      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pml85",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
#      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pml80",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
#      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pml82",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
#   END IF
#   IF g_sma.sma122 ='2' THEN
#      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pml83",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
#      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pml85",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
#      CALL cl_getmsg('asm-359',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pml80",g_msg CLIPPED)
#      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
#      CALL cl_getmsg('asm-360',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pml82",g_msg CLIPPED)
#      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
#   END IF
#   #FUN-570175  --end
    #-----END FUN-610006-----
 
    IF NOT cl_null(g_argv1) THEN call q540_q() END IF
 
    CALL q540_menu()
 
    CLOSE WINDOW q540_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q540_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   IF NOT cl_null(g_argv1) THEN
      LET tm_wc = "pml01 = '",g_argv1,"'"
   ELSE
      CLEAR FORM #清除畫面
      CALL g_pmn.clear()
      CALL cl_opmsg('q')
      LET tm_wc = NULL
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pml.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm_wc ON pml01, pml02, pml04, pml041,
                                 pml011,pmk04, pml16,
                                 pml07, pml20, pml21,
                                 pml83, pml85, pml80, pml82  #FUN-570175
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         
          #FUN-940013--begin--add-- 
       ON ACTION controlp 
           CASE
              WHEN INFIELD(pml01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c" 
                   LET g_qryparam.form = "q_pmk3" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pml01
                   NEXT FIELD pml01
              OTHERWISE EXIT CASE 
           END CASE
       #FUN-940013--end--add--
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
      #LET tm_wc = tm_wc CLIPPED,cl_get_extra_cond('pmluser', 'pmlgrup') #MOD-C90010 mark
      LET tm_wc = tm_wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')  #MOD-C90010 add
      #End:FUN-980030
 
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT pml01,pml02 FROM pml_file, pmk_file ",
             " WHERE pml02 is not null AND ",tm_wc CLIPPED, #96-08-26
             "   AND pml01=pmk01",
             " ORDER BY pml01,pml02"
   PREPARE q540_prepare FROM g_sql
   DECLARE q540_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q540_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql="SELECT COUNT(*) FROM pml_file, pmk_file ",
             " WHERE pml02 is not null AND ",tm_wc CLIPPED,    #96-08-26
             "   AND pml01=pmk01"
   PREPARE q540_pp FROM g_sql
   DECLARE q540_cnt   CURSOR FOR q540_pp
 
END FUNCTION
 
FUNCTION q540_menu()
 
   WHILE TRUE
      CALL q540_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q540_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "收貨明細查詢"
         WHEN "qry_receipts_details"
            CALL q540_detail()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q540_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q540_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q540_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q540_cnt
       FETCH q540_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt
       CALL q540_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
 
END FUNCTION
 
FUNCTION q540_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式     #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數   #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q540_cs INTO g_pml.pml01,g_pml.pml02
        WHEN 'P' FETCH PREVIOUS q540_cs INTO g_pml.pml01,g_pml.pml02
        WHEN 'F' FETCH FIRST    q540_cs INTO g_pml.pml01,g_pml.pml02
        WHEN 'L' FETCH LAST     q540_cs INTO g_pml.pml01,g_pml.pml02
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
            FETCH ABSOLUTE l_abso q540_cs INTO g_pml.pml01,g_pml.pml02
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
 
	SELECT pml01, pml02, pml011, pml16, pml04, pml041,'',pmk04,    #TQC-CB0024 add ''
           pml07, pml20, pml21, pml20-pml21,pml83, pml85, pml80, pml82 #FUN-570175
	  INTO g_pml.*
      FROM pml_file, pmk_file
	  WHERE pml01=g_pml.pml01 AND pml02=g_pml.pml02 AND pml01=pmk01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_pml.pml01,SQLCA.sqlcode,0)  #No.FUN-660129
        CALL cl_err3("sel","pml_file,pmk_file",g_pml.pml01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
        RETURN
    END IF
    IF cl_null(g_pml.pml041) THEN
       SELECT ima02
         INTO g_pml.pml041
         FROM ima_file
         WHERE  ima01 = g_pml.pml04
    END IF
    SELECT ima021 INTO g_pml.ima021 FROM ima_file WHERE ima01 = g_pml.pml04  #TQC-CB0024 add
    CALL q540_show()
 
END FUNCTION
 
FUNCTION q540_show()
   DISPLAY BY NAME g_pml.pml01,g_pml.pml02,g_pml.pml011,g_pml.pml16,
                   g_pml.pmk04,g_pml.pml04,
                   g_pml.pml041,g_pml.ima021,g_pml.pml20,g_pml.pml21,g_pml.pml07 ,   #TQC-CB0024 add ima021
                   g_pml.rest,g_pml.pml83,g_pml.pml85,g_pml.pml80,g_pml.pml82 #FUN-570175
                       # 顯示單頭值
   CALL q540_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q540_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET l_sql =
        "SELECT pmm04, pmn01, pmn02, pmc03, pmn04,pmn041,'',pmn20, pmn07, ",    #TQC-CB0024 add pmn041,''
        "       pmn83, pmn85, pmn80, pmn82, pmn16, pmn33, pmn919,", #FUN-570175 #FUN-A80150 add pmn919
        "                            pmn42, pmn62, pmn61,'','' ",               #TQC-CB0024 add ''
        " FROM  pmn_file, pmm_file,",
        " OUTER pmc_file ",
        " WHERE pmn24 = '",g_pml.pml01,"'",
        " AND   pmn25 =  ",g_pml.pml02,
        " AND pmn01 = pmm01 ",
        " AND pmc_file.pmc01 = pmm_file.pmm09 AND pmm18 <> 'X'",
        " ORDER BY 2,3"
    PREPARE q540_pb FROM l_sql
    DECLARE q540_bcs                       #BODY CURSOR
        CURSOR FOR q540_pb
 
    CALL g_pmn.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    LET g_sum = 0
    FOREACH q540_bcs INTO g_pmn[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
#TQC-CB0024 ------------- add -------------- begin
      SELECT ima021 INTO g_pmn[g_cnt].ima021_p
        FROM ima_file
       WHERE ima01 = g_pmn[g_cnt].pmn04
      SELECT ima02,ima021 INTO g_pmn[g_cnt].ima02_s
                              ,g_pmn[g_cnt].ima021_s
        FROM ima_file
       WHERE ima01 = g_pmn[g_cnt].pmn61
#TQC-CB0024 ------------- add -------------- end
      LET g_sum = g_sum + g_pmn[g_cnt].pmn20
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    #No.TQC-6B0159 --begin
    CALL g_pmn.deleteElement(g_cnt)
    MESSAGE ""
    #No.TQC-6B0159 --end
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY g_sum TO FORMONLY.sum     #MOD-BB0083 add
END FUNCTION
 
FUNCTION q540_bp(p_ud)
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
         CALL q540_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q540_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q540_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q540_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q540_fetch('L')
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
         CALL q540_def_form()   #FUN-610006
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
 
 
 
FUNCTION q540_detail()
DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
    IF cl_null (g_pmn[1].pmn01)  THEN
       CALL cl_err ('','apm-207',0)
       RETURN
    END IF
 #No.MOD-480533
{
    WHILE TRUE
#      OPEN WINDOW q540_ww AT 7,40
#           WITH 2 ROWS, 30 COLUMNS
       CALL cl_getmsg('apm-208',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
       PROMPT g_msg CLIPPED,':' FOR g_order
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
#             CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       END PROMPT
       IF INT_FLAG THEN
          LET INT_FLAG = 0
#         CLOSE WINDOW q540_ww
          RETURN
       END IF
       IF g_order >= 1 AND g_order <= 100  THEN
          IF NOT cl_null(g_pmn[g_order].pmn01)  THEN
             EXIT WHILE
          END IF
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
#         CLOSE WINDOW q540_ww
          RETURN
       END IF
    END WHILE
#   LET l_sql = "apmq520 '",g_pmn[g_order].pmn01,"' '",g_pmn[g_order].pmn02,"'"
}
    LET l_ac  = ARR_CURR()
    LET l_sql = "apmq520 '",g_pmn[l_ac].pmn01,"' '",g_pmn[l_ac].pmn02,"'"
 #No.MOD-480533
 
    CALL cl_cmdrun(l_sql)
#   CLOSE WINDOW q540_ww
END FUNCTION
 
#-----FUN-610006---------
FUNCTION q540_def_form()
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
    CALL cl_set_comp_visible("pmn919",g_sma.sma1421='Y')   #FUN-A80150 add
END FUNCTION
#-----END FUN-610006-----
