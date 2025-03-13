# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmq580.4gl
# Descriptions...: 無交期採購狀況查詢
# Date & Author..: 01/04/02 By Mandy
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-530065 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-570175 05/07/19 By Elva  新增雙單位內容
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-BC0158 12/01/06 By destiny tm_wc长度不够
# Modify.........: No.TQC-C80099 12/08/15 By zhuhao 將最後一行空白刪除
# Modify.........: No.CHI-CC0003 13/02/18 By Elise 單身在哪一筆就直接串到apmq520

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   #tm_wc  LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(500) #TQC-BC0158
    tm_wc  STRING,                  #TQC-BC0158
    g_pon  RECORD
            pon01		LIKE pon_file.pon01, #採購單號
            pon02		LIKE pon_file.pon02, #項次
            pon16		LIKE pon_file.pon16, #狀況
            pom04         	LIKE pom_file.pom04, #採購日期
            pon04   	        LIKE pon_file.pon04, #採購料號
            pon041	        LIKE pon_file.pon041,#品名
            pon20		LIKE pon_file.pon20, #申請數量
            pon21               LIKE pon_file.pon21, #已轉數量
            pon07               LIKE pon_file.pon07, #單位
            rest                LIKE pon_file.pon21, #未轉數量
            #FUN-570175  --begin
            pon83               LIKE pon_file.pon83,
            pon85               LIKE pon_file.pon85,
            pon80               LIKE pon_file.pon80,
            pon82               LIKE pon_file.pon82
            #FUN-570175  --end
        END RECORD,
    g_pmn DYNAMIC ARRAY OF RECORD
            pmm04       LIKE pmm_file.pmm04, #採購日期
            pmn01       LIKE pmn_file.pmn01, #項次
            pmn02       LIKE pmn_file.pmn02,
            pmn04       LIKE pmn_file.pmn04,
            pmn041      LIKE pmn_file.pmn041,
            pmc03       LIKE pmc_file.pmc03,
            pmn20       LIKE pmn_file.pmn20,
            pmn07       LIKE pmn_file.pmn07,
            #FUN-570175  --begin
            pmn83       LIKE pmn_file.pmn83,
            pmn85       LIKE pmn_file.pmn85,
            pmn80       LIKE pmn_file.pmn80,
            pmn82       LIKE pmn_file.pmn82,
            #FUN-570175  --end
            pmn16       LIKE pmn_file.pmn16,
            pmn33       LIKE pmn_file.pmn33
        END RECORD,
    g_order             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
    g_sum               LIKE pmn_file.pmn20,
    g_argv1             LIKE pon_file.pon01,          #INPUT ARGUMENT - 1
    g_sql               string,                       #WHERE CONDITION      #No.FUN-580092 HCN
    g_rec_b             LIKE type_file.num5   	      #單身筆數             #No.FUN-680136 SMALLINT
DEFINE p_row,p_col      LIKE type_file.num5           #No.FUN-680136 SMALLINT
DEFINE   g_cnt          LIKE type_file.num10          #No.FUN-680136 INTEGER
DEFINE   g_msg          LIKE ze_file.ze03,            #No.FUN-680136 VARCHAR(72)
         l_ac           LIKE type_file.num5           #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680136 INTEGER


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

    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q580_w AT p_row,p_col
        WITH FORM "apm/42f/apmq580"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #-----FUN-610006---------
   CALL q580_def_form()
#  #FUN-570175  --begin
#  IF g_sma.sma115 ='N' THEN
#     CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
#     CALL cl_set_comp_visible("pon80,pon82,pon83,pon85",FALSE)
#  END IF
#  IF g_sma.sma122 ='1' THEN
#     CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
#     CALL cl_set_comp_att_text("pon83",g_msg CLIPPED)
#     CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
#     CALL cl_set_comp_att_text("pon85",g_msg CLIPPED)
#     CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
#     CALL cl_set_comp_att_text("pon80",g_msg CLIPPED)
#     CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
#     CALL cl_set_comp_att_text("pon82",g_msg CLIPPED)
#  END IF
#  IF g_sma.sma122 ='2' THEN
#     CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
#     CALL cl_set_comp_att_text("pon83",g_msg CLIPPED)
#     CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
#     CALL cl_set_comp_att_text("pon85",g_msg CLIPPED)
#     CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
#     CALL cl_set_comp_att_text("pon80",g_msg CLIPPED)
#     CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
#     CALL cl_set_comp_att_text("pon82",g_msg CLIPPED)
#  END IF
#  #FUN-570175  --end
   #-----END FUN-610006-----
    IF not cl_null(g_argv1) THEN call q580_q() END IF
    #IF cl_chk_act_auth() THEN
    #   CALL q580_q()
    #END IF
    CALL q580_menu()
    CLOSE WINDOW q580_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q580_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm_wc = "pon01 = '",g_argv1,"'"
      ELSE CLEAR FORM #清除畫面
   CALL g_pmn.clear()
       CALL cl_opmsg('q')
       LET tm_wc = NULL
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pon.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME tm_wc ON pon01, pon02 ,pon04 ,pon041,
                                  pon07, pon20 ,pon21 ,
                                  pon83, pon85 ,pon80 ,pon82  #FUN-570175
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
     #FUN-530065
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(pon04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_pon.pon04
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pon04
            NEXT FIELD pon04
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
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET tm_wc = tm_wc clipped," AND pmmuser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET tm_wc = tm_wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET tm_wc = tm_wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET tm_wc = tm_wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
       #End:FUN-980030
 
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE pon01,pon02 ",
             "     FROM pmm_file,pmn_file,pon_file ",
             "     WHERE ",tm_wc CLIPPED,
             "       AND pon02 IS NOT NULL ",
             "       AND pmm01 = pmn01",
             "       AND pmn68 = pon01",
             "     ORDER BY pon01,pon02"
   PREPARE q580_prepare FROM g_sql
   DECLARE q580_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q580_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql = "SELECT UNIQUE pon01,pon02 ",
               "     FROM pmm_file,pmn_file,pon_file ",
               "     WHERE ",tm_wc CLIPPED,
               "       AND pon02 IS NOT NULL ",
               "       AND pmm01 = pmn01",
               "       AND pmn68 = pon01",
               "     INTO TEMP x "
 
    DROP TABLE x
    PREPARE q580_precount_x FROM g_sql
    EXECUTE q580_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE q580_precount FROM g_sql
    DECLARE q580_cnt CURSOR FOR q580_precount
 
END FUNCTION
 
FUNCTION q580_menu()
 
   WHILE TRUE
      CALL q580_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q580_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "收貨明細查詢"
         WHEN "qry_receipts_details"
            CALL q580_detail()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF
 
      END CASE
   END WHILE
   CLOSE q580_cs
END FUNCTION
 
FUNCTION q580_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q580_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q580_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q580_cnt
        FETCH q580_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q580_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q580_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q580_cs INTO g_pon.pon01,g_pon.pon02
        WHEN 'P' FETCH PREVIOUS q580_cs INTO g_pon.pon01,g_pon.pon02
        WHEN 'F' FETCH FIRST    q580_cs INTO g_pon.pon01,g_pon.pon02
        WHEN 'L' FETCH LAST     q580_cs INTO g_pon.pon01,g_pon.pon02
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
             FETCH ABSOLUTE l_abso q580_cs INTO g_pon.pon01,g_pon.pon02
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pon.pon01,SQLCA.sqlcode,0)
        INITIALIZE g_pon.* TO NULL  #TQC-6B0105
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
#
    SELECT pon01, pon02, pon16,pom04,pon04,pon041,
           pon20, pon21, pon07, pon20-pon21,
           pon83, pon85, pon80, pon82 #FUN-570175
	INTO g_pon.*
        FROM pon_file,pom_file
	WHERE pon01=g_pon.pon01 AND pon02=g_pon.pon02
          AND pom01 = pon01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_pon.pon01,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","pon_file,pom_file",g_pon.pon01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
        RETURN
    END IF
    IF cl_null(g_pon.pon041) THEN
       SELECT ima02
         INTO g_pon.pon041
         FROM ima_file
         WHERE  ima01 = g_pon.pon04
    END IF
#
    CALL q580_show()
END FUNCTION
 
FUNCTION q580_show()
   DISPLAY BY NAME g_pon.pon01,g_pon.pon02,g_pon.pon16,
                   g_pon.pom04,g_pon.pon04,g_pon.pon041,
                   g_pon.pon20,g_pon.pon21,g_pon.pon07 ,
                   #FUN-570175  --begin
                   g_pon.rest,g_pon.pon83,g_pon.pon85,
                   g_pon.pon80,g_pon.pon82
                   #FUN-570175  --end
                     # 顯示單頭值
   CALL q580_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q580_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET l_sql =
        "SELECT pmm04,pmn01,pmn02,pmn04,pmn041,pmc03,pmn20,pmn07,",
        "       pmn83, pmn85, pmn80, pmn82, pmn16,pmn33", #FUN-570175
        " FROM  pmn_file, pmm_file,",
        " OUTER pmc_file ",
        " WHERE pmn68 = '",g_pon.pon01,"'",
        "   AND pmn69 =  ",g_pon.pon02,
        "   AND pmn01 = pmm01 ",
        "   AND pmc_file.pmc01 = pmm_file.pmm09 ",
        " ORDER BY 2,3"
    PREPARE q580_pb FROM l_sql
    DECLARE q580_bcs                       #BODY CURSOR
        CURSOR FOR q580_pb
 
    CALL g_pmn.clear()
 
    LET g_rec_b=0
    LET g_cnt = 1
    LET g_sum = 0
    FOREACH q580_bcs INTO g_pmn[g_cnt].*
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
    CALL g_pmn.deleteElement(g_cnt)      #TQC-C80099 add
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q580_bp(p_ud)
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
         CALL q580_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q580_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q580_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q580_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q580_fetch('L')
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
         CALL q580_def_form()   #FUN-610006
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
 
 
      #No.FUN-530065  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.FUN-530065  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
 
FUNCTION q580_detail()
DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
    IF cl_null (g_pmn[1].pmn01)  THEN
       CALL cl_err ('','apm-207',0)
       RETURN
    END IF
   #CHI-CC0003---mark---S
   #WHILE TRUE
#  #   OPEN WINDOW q580_ww AT 7,40
#  #        WITH 2 ROWS, 30 COLUMNS
   #   CALL cl_getmsg('apm-208',g_lang) RETURNING g_msg
   #        LET INT_FLAG = 0  ######add for prompt bug
   #   PROMPT g_msg CLIPPED,':' FOR g_order
   #      ON IDLE g_idle_seconds
   #         CALL cl_on_idle()
#  #          CONTINUE PROMPT
 
   #  ON ACTION about         #MOD-4C0121
   #     CALL cl_about()      #MOD-4C0121
 
   #  ON ACTION help          #MOD-4C0121
   #     CALL cl_show_help()  #MOD-4C0121
 
   #  ON ACTION controlg      #MOD-4C0121
   #     CALL cl_cmdask()     #MOD-4C0121
 
 
   #   END PROMPT
   #   IF INT_FLAG THEN
   #      LET INT_FLAG = 0
#  #      CLOSE WINDOW q580_ww
   #      RETURN
   #   END IF
   #   IF g_order >= 1 AND g_order <= 100  THEN
   #      IF NOT cl_null(g_pmn[g_order].pmn01)  THEN
   #         EXIT WHILE
   #      END IF
   #   END IF
   #   IF INT_FLAG THEN
   #      LET INT_FLAG = 0
#  #      CLOSE WINDOW q580_ww
   #      RETURN
   #   END IF
   #END WHILE
   #CHI-CC0003---mark---E

    LET g_order = ARR_CURR()   #CHI-CC0003 add
    LET l_sql = "apmq520 '",g_pmn[g_order].pmn01,"' '",g_pmn[g_order].pmn02,"'"
    CALL cl_cmdrun(l_sql)
#   CLOSE WINDOW q580_ww
END FUNCTION
 
#-----FUN-610006---------
FUNCTION q580_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
      CALL cl_set_comp_visible("pon80,pon82,pon83,pon85",FALSE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_set_comp_att_text("pon83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_set_comp_att_text("pon85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_set_comp_att_text("pon80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
      CALL cl_set_comp_att_text("pon82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_set_comp_att_text("pon83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_set_comp_att_text("pon85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_set_comp_att_text("pon80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
      CALL cl_set_comp_att_text("pon82",g_msg CLIPPED)
   END IF
END FUNCTION
#-----END FUN-610006-----
