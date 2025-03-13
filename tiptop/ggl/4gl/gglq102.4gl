# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: gglq102.4gl
# Descriptions...: 科目幣別每日餘額查詢
# Date & Author..: 02/02/28 By Danny
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740018 07/04/05 By Judy 匯出Excel出錯
# Modify.........: No.FUN-740033 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc  	LIKE type_file.chr1000,      #NO FUN-690009   VARCHAR(1000)   # Head Where condition
        	wc2 	LIKE type_file.chr1000       #NO FUN-690009   VARCHAR(1000)   # Body Where condition
        END RECORD,
    g_aag  RECORD
            aag01		LIKE aag_file.aag01,
            aag02		LIKE aag_file.aag02,
            tas00               LIKE tas_file.tas00,  #No.FUN-730070
            tas08		LIKE tas_file.tas08
        END RECORD,
    g_tas DYNAMIC ARRAY OF RECORD
            tas02   LIKE tas_file.tas02,
            tas09   LIKE tas_file.tas09,
            tas10   LIKE tas_file.tas10
        END RECORD,
    g_bookno     LIKE tas_file.tas00,      # INPUT ARGUMENT - 1
     g_wc,g_sql  string,                   #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b      LIKE type_file.num5       #NO FUN-690009   SMALLINT   #單身筆數
 
 
DEFINE   g_cnt           LIKE type_file.num10         #NO FUN-690009   INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #NO FUN-690009   VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #NO FUN-690009   INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #NO FUN-690009   INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8	     #No.FUN-6A0097
DEFINE   l_sl,p_row,p_col LIKE type_file.num5        #NO FUN-690009   SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
    LET g_bookno      = ARG_VAL(1)          #參數值(1) Part#
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
    CALL s_dsmark(g_bookno)
    LET p_row = 2 LET p_col = 2
   OPEN WINDOW q102_srn AT p_row,p_col  WITH FORM "ggl/42f/gglq102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
 
	CALL s_shwact(0,0,g_bookno)
#    IF cl_chk_act_auth() THEN
#       CALL q102_q()
#    END IF
    CALL q102_menu()
    CLOSE FORM q102_srn               #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
END MAIN
 
#QBE 查詢資料
FUNCTION q102_cs()
   DEFINE   l_cnt LIKE type_file.num5          #NO FUN-690009   SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_tas.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_aag.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON aag01,aag02,tas00,tas08  #No.FUN-740033
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   CONSTRUCT tm.wc2 ON tas02 FROM s_tas[1].tas02
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
   LET g_sql=" SELECT DISTINCT aag01,aag02,tas00,tas08 FROM aag_file,tas_file ",  #No.FUN-740033
             " WHERE aag03 matches '2' AND ",tm.wc CLIPPED,
             "   AND aag01 = tas01 ",
             "   AND aag00 = tas00 ",       #No.FUN-740033
             " ORDER BY tas00,aag01,tas08"  #No.FUN-740033
   PREPARE q102_prepare FROM g_sql
   DECLARE q102_cs SCROLL CURSOR FOR q102_prepare
 
   #====>取合乎條件筆數
   LET g_sql=" SELECT UNIQUE aag01,aag02,tas00,tas08 FROM tas_file,aag_file ",  #No.FUN-740033
             "  WHERE aag03 matches '2' AND ",tm.wc CLIPPED,
             "    AND tas01 = aag01 ",
             "    AND aag00 = tas00 ",       #No.FUN-740033
             "   INTO TEMP x "
   DROP TABLE x
   PREPARE q102_prepare_x FROM g_sql
   EXECUTE q102_prepare_x
 
       LET g_sql = "SELECT COUNT(*) FROM x "
 
   PREPARE q102_prepare_cnt FROM g_sql
   DECLARE q102_count CURSOR FOR q102_prepare_cnt
END FUNCTION
 
#中文的MENU
FUNCTION q102_menu()
 
   WHILE TRUE
      CALL q102_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q102_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
#             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','')  #TQC-740018 mark
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tas),'','')  #TQC-740018
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL q102_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    OPEN q102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
# genero mark g_query        IF g_query = 'Y' THEN
           OPEN q102_count
           FETCH q102_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt
# genero mark g_query        END IF
        CALL q102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q102_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)    #處理方式
    l_abso          LIKE type_file.num10       #NO FUN-690009   INTEGER    #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q102_cs INTO g_aag.aag01,g_aag.aag02,g_aag.tas00,g_aag.tas08  #No.FUN-740033
        WHEN 'P' FETCH PREVIOUS q102_cs INTO g_aag.aag01,g_aag.aag02,g_aag.tas00,g_aag.tas08  #No.FUN-740033
        WHEN 'F' FETCH FIRST    q102_cs INTO g_aag.aag01,g_aag.aag02,g_aag.tas00,g_aag.tas08  #No.FUN-740033
        WHEN 'L' FETCH LAST     q102_cs INTO g_aag.aag01,g_aag.aag02,g_aag.tas00,g_aag.tas08  #No.FUN-740033
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
            FETCH ABSOLUTE l_abso q102_cs INTO g_aag.aag01,g_aag.aag02,
                                               g_aag.tas00,g_aag.tas08  #No.FUN-740033
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aag.aag01,SQLCA.sqlcode,0)
        INITIALIZE g_aag.* TO NULL  #TQC-6B0105
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
 
    CALL q102_show()
END FUNCTION
 
FUNCTION q102_show()
   DISPLAY BY NAME g_aag.aag01,g_aag.aag02,g_aag.tas08,g_aag.tas00  #No.FUN-740033
 
   CALL q102_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q102_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000)
          l_n       LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_tot     LIKE tas_file.tas09
 
   LET l_sql =
        "SELECT tas02, tas09, tas10",
        "  FROM  tas_file",
        " WHERE tas00 = '",g_aag.tas00,"'",  #No.FUN-740033
        "   AND tas01 = '",g_aag.aag01,"'",
        "   AND tas08 = '",g_aag.tas08,"'",
        "   AND ",tm.wc2 CLIPPED
    PREPARE q102_pb FROM l_sql
    DECLARE q102_bcs CURSOR FOR q102_pb
 
    FOR g_cnt = 1 TO g_tas.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_tas[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
	FOREACH q102_bcs INTO g_tas[g_cnt].*
        IF STATUS THEN CALL cl_err('',SQLCA.sqlcode,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b = g_cnt - 1
END FUNCTION
 
FUNCTION q102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_tas TO s_tas.* ATTRIBUTES(COUNT=g_rec_b,UNBUFFERED)   # MOD-530355
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q102_fetch('L')
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
 
       ON ACTION cancel                          # MOD-530355
         LET g_action_choice = "exit"
         EXIT DISPLAY
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
       
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
