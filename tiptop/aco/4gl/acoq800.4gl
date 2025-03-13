# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: acoq800.4gl
# Descriptions...: 征免稅額度使用查詢作業
# Date & Author..: 00/08/01 By Carol
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/12/01 By DAY   add cot03
# MOdify.........: No.TQC-660045 06/06/13 By hellen  cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790066 07/09/11 By Judy 匯出Excel多一空白行 
# Modify.........: No.TQC-930033 09/03/10 By mike 在_cs()段里呼叫b_askkey()做單身查詢后的tm.wc2未組入單頭sql條件，
#                                                 只在b_fill()里當where條件, 應判斷若非 " 1=1"時加入單頭條件
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0067 09/11/10 By lilingyu 去掉ATTRIBUTE
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
       	wc  	LIKE type_file.chr1000,     #No.FUN-680069 VARCHAR(600)    # Head Where condition
       	wc2  	LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(600)    # Body Where condition
        END RECORD,
    g_cnb   RECORD
        cnb01	LIKE cnb_file.cnb01,
        cnb04	LIKE cnb_file.cnb04,
        cnb12	LIKE cnb_file.cnb12
        END RECORD,
    g_cot DYNAMIC ARRAY OF RECORD
            seq     LIKE type_file.num5,    #No.FUN-680069 SMALLINT
            cot01   LIKE cot_file.cot01,
            cot03   LIKE cot_file.cot03,    #MOD-490398
            cot04   LIKE cot_file.cot04,
            cot02   LIKE cot_file.cot02,
            cou08   LIKE cou_file.cou08,
            cot19   LIKE cot_file.cot19,
            cot21   LIKE cot_file.cot21,
            cov08   LIKE cov_file.cov08,
            desc    LIKE ze_file.ze03           #No.FUN-680069 VARCHAR(06)
    END RECORD,
    g_argv1         LIKE cnb_file.cnb01,
    g_query_flag    LIKE type_file.num5,          #No.FUN-680069 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_diff          LIKE cnb_file.cnb12,          #No.FUN-680069 DEC(20,6)
    g_wc,g_wc2,g_sql STRING, #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num10          #No.FUN-680069 INTEGER  #單身筆數
DEFINE   g_cnt          LIKE type_file.num10      #No.FUN-680069 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000,   #No.FUN-680069 VARCHAR(72)
         l_ac           LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680069 INTEGER
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
    LET g_query_flag =1
 
    OPEN WINDOW q800_w WITH FORM "aco/42f/acoq800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL q800_q() END IF
    CALL q800_menu()
    CLOSE WINDOW q800_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION q800_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "cnb01 = '",g_argv1,"'"
           LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM                 #清除畫面
   CALL g_cot.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL    # Default condition
   INITIALIZE g_cnb.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON cnb01,cnb04,cnb12
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
           CALL q800_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT '
 
   IF tm.wc2 =" 1=1" THEN #TQC-930033
      LET g_sql=" SELECT cnb01 FROM cnb_file ",
                " WHERE ",tm.wc CLIPPED
  #TQC-930033 ----START
   ELSE
      LET g_sql=" SELECT DISTINCT cnb01 ", 
                "   FROM cnb_file,cot_file,cos_file ",                                                                                                
                "  WHERE cos02=cnb01  ",                                                                              
                "    AND cot01=cos01  ",  
                "    AND ",tm.wc CLIPPED,
                "    AND ",tm.wc2 CLIPPED  
   END IF
  #TQC-930033 ---END
  
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND cnbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND cnbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND cnbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('cnbuser', 'cnbgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY cnb01"
   PREPARE q800_prepare FROM g_sql
   DECLARE q800_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q800_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF tm.wc2=" 1=1" THEN #TQC-930033
      LET g_sql=" SELECT COUNT(*) FROM cnb_file ",
                "  WHERE ",tm.wc CLIPPED
  #TQC-930033 --start
   ELSE  
      LET g_sql=" SELECT COUNT(DISTINCT(cnb01))  ",
                "   FROM cnb_file,cot_file,cos_file ",                                                                              
                "  WHERE cos02=cnb01  ",                                                                                            
                "    AND cot01=cos01  ",                                                                                            
                "    AND ",tm.wc CLIPPED,                                                                                           
                "    AND ",tm.wc2 CLIPPED   
   END IF
  #TQC-930033 --END
 
  #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND cnbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND cnbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND cnbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q800_pp  FROM g_sql
   DECLARE q800_cnt   CURSOR FOR q800_pp
END FUNCTION
 
FUNCTION q800_b_askkey()
 #MOD-490398--begin
  #CONSTRUCT tm.wc2 ON seq,cot01,cot03,cot04,cot02,cou08,cot19,cot21,cov08,desc #TQC-930033
   CONSTRUCT tm.wc2 ON cot01,cot03,cot04,cot02,cot19,cot21 #TQC-930033    
                 #FROM s_cot[1].seq,s_cot[1].cot01,s_cot[1].cot03,s_cot[1].cot04, #TQC-930033
                  FROM s_cot[1].cot01,s_cot[1].cot03,s_cot[1].cot04, #TQC-930033 
                      #s_cot[1].cot02,s_cot[1].cou08,s_cot[1].cot19, #TQC-930033  
                       s_cot[1].cot02,s_cot[1].cot19, #TQC-930033   
                      #s_cot[1].cot21,s_cot[1].cov08,s_cot[1].desc #TQC-930033
                       s_cot[1].cot21 #TQC-930033  
 #MOD-490398--end
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
 
FUNCTION q800_menu()
 
   WHILE TRUE
      CALL q800_bp("G")
      CASE g_action_choice
         WHEN "query"
          IF cl_chk_act_auth() THEN
              CALL q800_q()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cot),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q800_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q800_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q800_cnt
        FETCH q800_cnt INTO g_row_count #CKP
        DISPLAY g_row_count TO cnt #CKP
        CALL q800_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q800_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q800_cs INTO g_cnb.cnb01
        WHEN 'P' FETCH PREVIOUS q800_cs INTO g_cnb.cnb01
        WHEN 'F' FETCH FIRST    q800_cs INTO g_cnb.cnb01
        WHEN 'L' FETCH LAST     q800_cs INTO g_cnb.cnb01
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
            FETCH ABSOLUTE l_abso q800_cs INTO g_cnb.cnb01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnb.cnb01,SQLCA.sqlcode,0)
        INITIALIZE g_cnb.* TO NULL  #TQC-6B0105
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
	SELECT cnb01,cnb04,cnb12
	  INTO g_cnb.cnb01,g_cnb.cnb04,g_cnb.cnb12
	  FROM cnb_file
	 WHERE cnb01 = g_cnb.cnb01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cnb.cnb01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cnb_file",g_cnb.cnb01,"",SQLCA.sqlcode,"","",0) #TQC-660045
        RETURN
    END IF
 
    CALL q800_show()
END FUNCTION
 
FUNCTION q800_show()
   #No.FUN-9A0024--begin 
   #DISPLAY BY NAME g_cnb.*   # 顯示單頭值
   DISPLAY BY NAME g_cnb.cnb01,g_cnb.cnb04,g_cnb.cnb12
    #No.FUN-9A0024--end 
   CALL q800_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q800_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000     #No.FUN-680069 VARCHAR(400)
   DEFINE l_desc    LIKE ze_file.ze03          #No.FUN-680069 VARCHAR(06)
   DEFINE l_cos08   LIKE cos_file.cos08
   DEFINE l_cos10   LIKE cos_file.cos10
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
         "SELECT '',cot01,cot03,cot04,cot02,'',cot19,cot21,'','',cos10,cos08", #MOD-490398
        "  FROM cot_file,cos_file ",
        " WHERE cos02='",g_cnb.cnb01 CLIPPED,"' AND ",
              " cot01=cos01 AND ",tm.wc2 CLIPPED,
        " ORDER BY cot01,cot02"
    PREPARE q800_pb FROM l_sql
    DECLARE q800_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q800_pb
 
    FOR g_cnt = 1 TO g_cot.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_cot[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_diff=0
    FOREACH q800_bcs INTO g_cot[g_cnt].*,l_cos10,l_cos08
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT cou08 INTO g_cot[g_cnt].cou08 FROM cou_file
         WHERE cou03=l_cos08
        SELECT SUM(cov08) INTO g_cot[g_cnt].cov08 FROM cov_file,cou_file
         WHERE cou03=l_cos08 AND cov01=cou01 AND cov03=g_cot[g_cnt].cot02
        CASE l_cos10
         WHEN '1'  CALL cl_getmsg('aco-017',g_lang) RETURNING l_desc
         WHEN '2'  CALL cl_getmsg('aco-018',g_lang) RETURNING l_desc
         WHEN '3'  CALL cl_getmsg('aco-019',g_lang) RETURNING l_desc
         WHEN '4'  CALL cl_getmsg('aco-020',g_lang) RETURNING l_desc
         WHEN '5'  CALL cl_getmsg('aco-021',g_lang) RETURNING l_desc
         WHEN '6'  CALL cl_getmsg('aco-022',g_lang) RETURNING l_desc
         WHEN '7'  CALL cl_getmsg('aco-023',g_lang) RETURNING l_desc
        END CASE
        LET g_cot[g_cnt].seq=g_cnt
        LET g_cot[g_cnt].desc=l_desc
        IF NOT cl_null(g_cot[g_cnt].cov08) THEN
           LET g_diff=g_diff+g_cot[g_cnt].cov08
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_cot.deleteElement(g_cnt)  #TQC-790066
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_diff=g_cnb.cnb12 - g_diff
    DISPLAY g_diff TO FORMONLY.diff    #ATTRIBUTES(YELLOW)   #FUN-9B0067
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cot TO s_cot.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#NO.FUN-6B0033--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0033--END   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q800_fetch('L')
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
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
