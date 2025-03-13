# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acoq500.4gl
# Descriptions...: 合同出口成品數量查詢作業
# Date & Author..: 00/09/20 By Apple
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/12/01 By day   add coc10
# Modify.......... No.MOD-490398 05/02/24 By Carrier 單身欄位調整
# Modify.........: No.TQC-660045 06/06/12 By hellen cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790066 07/09/11 By Judy 匯出Excel多一空白行 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)  # Head Where condition
        	wc2  	LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(600)  # Body Where condition
        END RECORD,
    g_coc   RECORD
                coc01 LIKE coc_file.coc01,
                coc02 LIKE coc_file.coc02,
                coc10 LIKE coc_file.coc10,      #MOD-490398
                coc03 LIKE coc_file.coc03,
                coc04 LIKE coc_file.coc04,
                coc05 LIKE coc_file.coc05,
                coc07 LIKE coc_file.coc07
        END RECORD,
    g_cod DYNAMIC ARRAY OF RECORD
                cod02  LIKE cod_file.cod02,
                cod03  LIKE cod_file.cod03,
                cob02  LIKE cob_file.cob02,
                tot    LIKE cod_file.cod05,
                cod05  LIKE cod_file.cod05,
                cod10  LIKE cod_file.cod10,
                 #No.MOD-490398  --begin
                cod09  LIKE cod_file.cod09,
                cod091 LIKE cod_file.cod091,
                cod101 LIKE cod_file.cod101,
                cod102 LIKE cod_file.cod102,
                cod106 LIKE cod_file.cod106,      #No.MOD-490398
                cod104 LIKE cod_file.cod104
                 #No.MOD-490398  --end
        END RECORD,
    g_argv1         LIKE coc_file.coc01,
    g_sql           STRING, #WHERE CONDITION      #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num10          #No.FUN-680069 INTEGER  #單身筆數
DEFINE   g_cnt          LIKE type_file.num10      #No.FUN-680069 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000,   #No.FUN-680069 VARCHAR(72)
         l_ac           LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
 
 
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680069 INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0063
   DEFINE   l_sl        LIKE type_file.num5          #No.FUN-680069 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
    LET g_argv1      = ARG_VAL(1)         #申請編號
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW q500_w AT p_row,p_col
        WITH FORM "aco/42f/acoq500"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF not cl_null(g_argv1) THEN CALL q500_q() END IF
    CALL q500_menu()
    CLOSE WINDOW q500_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION q500_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "coc01 = '",g_argv1,"'"
           LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_cod.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL	       # Default condition
            CALL cl_set_head_visible("","YES") #No.FUN-6B0033
   INITIALIZE g_coc.* TO NULL    #No.FUN-750051
            CONSTRUCT BY NAME tm.wc ON coc01,coc02,coc10,coc03,coc04,coc05,coc07  #MOD-490398
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
           CALL q500_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
   LET g_sql=" SELECT UNIQUE coc01 FROM coc_file,cod_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2 CLIPPED,
             "   AND coc01 = cod01 ",
             "   AND cocacti != 'N' "  #010806增
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND cocuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND cocgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY coc01"
   PREPARE q500_prepare FROM g_sql
   DECLARE q500_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q500_prepare
 
   LET g_sql=" SELECT COUNT(DISTINCT coc01) FROM coc_file,cod_file ",
              " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2 CLIPPED,
             "   AND coc01 = cod01 ",
             "   AND cocacti !='N' " #010806增
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND cocuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND cocgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q500_pp  FROM g_sql
   DECLARE q500_cnt   CURSOR FOR q500_pp
END FUNCTION
 
FUNCTION q500_b_askkey()
    #No.MOD-490398  --begin
   CONSTRUCT tm.wc2 ON cod02,cod03,cod05,cod10,cod09,cod091,cod101,
                        cod102,cod106,cod104  #No.MOD-490398
                  FROM s_cod[1].cod02, s_cod[1].cod03, s_cod[1].cod05,
                       s_cod[1].cod10, s_cod[1].cod09, s_cod[1].cod091,
                        s_cod[1].cod101,s_cod[1].cod102,s_cod[1].cod106, #No.MOD-490398
                       s_cod[1].cod104
    #No.MOD-490398  --end
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION
 
FUNCTION q500_menu()
 
   WHILE TRUE
      CALL q500_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q500_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cod),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q500_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q500_cs                            #從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q500_cnt
        FETCH q500_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q500_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q500_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q500_cs INTO g_coc.coc01
        WHEN 'P' FETCH PREVIOUS q500_cs INTO g_coc.coc01
        WHEN 'F' FETCH FIRST    q500_cs INTO g_coc.coc01
        WHEN 'L' FETCH LAST     q500_cs INTO g_coc.coc01
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso q500_cs INTO g_coc.coc01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)
        INITIALIZE g_coc.* TO NULL  #TQC-6B0105
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
 #MOD-490398--begin
    SELECT coc01,coc02,coc10,coc03,coc04,coc05,coc07 INTO g_coc.*
      FROM coc_file WHERE coc01 = g_coc.coc01
 #MOD-490398--end
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0) #No.TQC-660045
       CALL cl_err3("sel","coc_file",g_coc.coc01,"",SQLCA.sqlcode,"","",0) #TQC-660045
       RETURN
    END IF
 
    CALL q500_show()
END FUNCTION
 
FUNCTION q500_show()
    DISPLAY BY NAME g_coc.coc01,g_coc.coc02,g_coc.coc10,g_coc.coc03,g_coc.coc04,  #MOD-490398
                   g_coc.coc05,g_coc.coc07
             # 顯示單頭值
   CALL q500_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q500_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680069 VARCHAR(400)
	  I,J 	    LIKE type_file.num10          #No.FUN-680069 INTEGER
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
    #No.MOD-490398  --begin
   LET l_sql=" SELECT cod02,cod03,cob02,0,cod05,cod10,cod09,cod091,",
              "        cod101,cod102,cod106,cod104",  #No.MOD-490398
             "  FROM cod_file, cob_file",
             " WHERE cod01 ='",g_coc.coc01,"'",
             "   AND cod03 = cob01 ",
             "   AND ",tm.wc2 CLIPPED,
	     " ORDER BY cod02"
    #No.MOD-490398  --end
 
    PREPARE q500_pb1 FROM l_sql
    DECLARE q500_bcs1 CURSOR FOR q500_pb1
 
    FOR g_cnt = 1 TO g_cod.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_cod[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q500_bcs1 INTO g_cod[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach1:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #-->剩餘數量(tot)
         #No.MOD-490398  --begin
        IF cl_null(g_cod[g_cnt].cod05 ) THEN LET g_cod[g_cnt].cod05 = 0 END IF
        IF cl_null(g_cod[g_cnt].cod10 ) THEN LET g_cod[g_cnt].cod10 = 0 END IF
        IF cl_null(g_cod[g_cnt].cod09 ) THEN LET g_cod[g_cnt].cod09 = 0 END IF
        IF cl_null(g_cod[g_cnt].cod091) THEN LET g_cod[g_cnt].cod091= 0 END IF
        IF cl_null(g_cod[g_cnt].cod101) THEN LET g_cod[g_cnt].cod101= 0 END IF
        IF cl_null(g_cod[g_cnt].cod102) THEN LET g_cod[g_cnt].cod102= 0 END IF
        IF cl_null(g_cod[g_cnt].cod106) THEN LET g_cod[g_cnt].cod106= 0 END IF
        IF cl_null(g_cod[g_cnt].cod104) THEN LET g_cod[g_cnt].cod104= 0 END IF
        LET g_cod[g_cnt].tot = (g_cod[g_cnt].cod05 + g_cod[g_cnt].cod10)
                              -(g_cod[g_cnt].cod09 + g_cod[g_cnt].cod101 +
                                g_cod[g_cnt].cod106)
                              + g_cod[g_cnt].cod091+ g_cod[g_cnt].cod102 +
                                g_cod[g_cnt].cod104
         #No.MOD-490398  --end
 
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_cod.deleteElement(g_cnt)   #TQC-790066
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cod TO s_cod.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q500_fetch('L')
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
 
 
      #FUN-4B0023
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
