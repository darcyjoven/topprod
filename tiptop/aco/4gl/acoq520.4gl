# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acoq520.4gl
# Descriptions...: 材料進出口各期異動統計量查詢
# Date & Author..: 05/01/14 By ice
# Modify.........: No.TQC-660045 06/06/12 BY cheunl  cl_err --->cl_err3
# MOdify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7A0034 07/10/08 By Pengu INTO g_coe_rowid,g_coe.coc03應該是 coe03
# Modify.........: No.TQC-860021 08/06/11 By Sarah INPUT,CONSTRUCT,PROMPT漏了ON IDLE控制
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
   tm  RECORD
        	wc    LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(600) # Head Where condition
       END RECORD,
   g_coe   RECORD
                coe03 LIKE coe_file.coe03,
                cob02 LIKE cob_file.cob02,
                cob09 LIKE cob_file.cob09,
                coc03 LIKE coc_file.coc03,
                coc10 LIKE coc_file.coc10,
                coe05 LIKE coe_file.coe05,
                coe10 LIKE coe_file.coe10,
                coe06 LIKE coe_file.coe06
       END RECORD,
    g_cnl DYNAMIC ARRAY OF RECORD
                cnl03  LIKE cnl_file.cnl03,
                cnl04  LIKE cnl_file.cnl04,
                cnl05  LIKE cnl_file.cnl05,
                cnl06  LIKE cnl_file.cnl06,
                cnl07  LIKE cnl_file.cnl07,
                cnl08  LIKE cnl_file.cnl08,
                cnl09  LIKE cnl_file.cnl09,
                cnl10  LIKE cnl_file.cnl10,
                cnl11  LIKE cnl_file.cnl11,
                cnl12  LIKE cnl_file.cnl12,
                cnl13  LIKE cnl_file.cnl13,
                cnl14  LIKE cnl_file.cnl14,
                cnl15  LIKE cnl_file.cnl15,
                cnl16  LIKE cnl_file.cnl16,
                cnl17  LIKE cnl_file.cnl17
       END RECORD,
    g_argv1            LIKE coe_file.coe03, g_coe01  LIKE coe_file.coe01, g_coe02  LIKE coe_file.coe02,
    g_sql              STRING,           #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b            LIKE type_file.num10            #No.FUN-680069 INTEGER     #單身筆數
DEFINE   tm2_1   RECORD
                  yy       LIKE cnl_file.cnl03,        #No.FUN-680069 VARCHAR(5)
                  mm       LIKE cnl_file.cnl04         #No.FUN-680069 VARCHAR(5)
               END RECORD
DEFINE   g_cnt         LIKE type_file.num10            #No.FUN-680069 INTEGER
DEFINE   g_msg         LIKE type_file.chr1000,         #No.FUN-680069 VARCHAR(72)
         l_ac          LIKE type_file.num5             #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
DEFINE   g_row_count   LIKE type_file.num10            #No.FUN-680069 INTEGER
DEFINE   g_curs_index  LIKE type_file.num10            #No.FUN-680069 INTEGER
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6A0063
   DEFINE       l_sl   LIKE type_file.num5             #No.FUN-680069 SMALLINT
   DEFINE p_row,p_col  LIKE type_file.num5             #No.FUN-680069 SMALLINT
 
   OPTIONS                                      #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
   LET g_argv1 = ARG_VAL(1)                     #申請編號
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW q520_w AT p_row,p_col
      WITH FORM "aco/42f/acoq520"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF not cl_null(g_argv1) THEN
      CALL q520_q()
   END IF
 
   CALL q520_menu()
   CLOSE WINDOW q520_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION q520_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "coe03 = '",g_argv1,"'"
         # LET tm.wc3=" 1=1 "                   # 年份期別查詢條件
   ELSE CLEAR FORM                              # 清除畫面
      CALL g_cnl.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL	                # Default condition
      INITIALIZE tm2_1.* TO NULL	                # Default condition
   INITIALIZE g_coe.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON coe03,cob09,coc03,coc10
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION controlg       #TQC-860021
            CALL cl_cmdask()      #TQC-860021
         ON ACTION about          #TQC-860021
            CALL cl_about()       #TQC-860021
         ON ACTION help           #TQC-860021
            CALL cl_show_help()   #TQC-860021
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_select()
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
      END CONSTRUCT
      INPUT BY NAME tm2_1.yy,tm2_1.mm WITHOUT DEFAULTS
         AFTER FIELD mm
            IF cl_null(tm2_1.yy) AND NOT cl_null(tm2_1.mm) THEN
               NEXT FIELD yy
            END IF
         ON ACTION controlg       #TQC-860021
            CALL cl_cmdask()      #TQC-860021
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE INPUT        #TQC-860021
         ON ACTION about          #TQC-860021
            CALL cl_about()       #TQC-860021
         ON ACTION help           #TQC-860021
            CALL cl_show_help()   #TQC-860021
      END INPUT
      IF INT_FLAG THEN RETURN END IF
      IF INT_FLAG THEN RETURN END IF
   END IF
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                          #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND cocuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                          #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND cocgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup')
   #End:FUN-980030
 
   LET g_sql=" SELECT UNIQUE coe01,coe02,coe03 FROM coe_file,cob_file, ",
             "        coc_file",
             "  WHERE ",tm.wc  CLIPPED,
             "   AND coe03 = cob01 ",
             "   AND coe01 = coc01 "
                                                #資料權限的檢查
   LET g_sql = g_sql clipped," ORDER BY coe03"
   PREPARE q520_prepare FROM g_sql
   DECLARE q520_cs                              #SCROLL CURSOR
           SCROLL CURSOR FOR q520_prepare
   LET g_sql=" SELECT COUNT(*) FROM coe_file,cob_file,coc_file ",
             "  WHERE ",tm.wc  CLIPPED,
             "   AND coe03 = cob01 ",
             "   AND coe01 = coc01 "
   PREPARE q520_pp  FROM g_sql
   DECLARE q520_cnt   CURSOR FOR q520_pp
END FUNCTION
 
FUNCTION q520_menu()
   WHILE TRUE
      CALL q520_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q520_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q520_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q520_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q520_cs                                 #從DB生成合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q520_cnt
      FETCH q520_cnt INTO g_row_count
      DISPLAY g_row_count TO cnt
      CALL q520_fetch('F')
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION q520_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                   #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                      #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     q520_cs INTO g_coe01,g_coe02,g_coe.coe03
       WHEN 'P' FETCH PREVIOUS q520_cs INTO g_coe01,g_coe02,g_coe.coe03
       WHEN 'F' FETCH FIRST    q520_cs INTO g_coe01,g_coe02,g_coe.coe03
       WHEN 'L' FETCH LAST     q520_cs INTO g_coe01,g_coe02,g_coe.coe03
       WHEN '/'
          CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
          LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED,': ' FOR l_abso
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
 
             ON ACTION controlg       #TQC-860021
                CALL cl_cmdask()      #TQC-860021
 
             ON ACTION about          #TQC-860021
                CALL cl_about()       #TQC-860021
 
             ON ACTION help           #TQC-860021
                CALL cl_show_help()   #TQC-860021
          END PROMPT
          IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          FETCH ABSOLUTE l_abso q520_cs INTO g_coe01,g_coe02,g_coe.coe03   #No.MOD-7A0034 modify
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_coe.coe03,SQLCA.sqlcode,0)
      INITIALIZE g_coe.* TO NULL  #TQC-6B0105
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
   SELECT coe03,cob02,cob09,coc03,coc10,coe05,coe10,coe06
      INTO g_coe.*
      FROM coe_file,cob_file,coc_file
      WHERE coe01=g_coe01 AND coe02=g_coe02
         AND coe03 = cob01
         AND coe01 = coc01
   IF SQLCA.sqlcode THEN
 #    CALL cl_err(g_coe.coe03,SQLCA.sqlcode,0) #No.TQC-660045
      CALL cl_err3("sel","coe_file,cob_file,coc_file",g_coe.coe03,"",SQLCA.sqlcode,"","",0) #No.TQC-660045
      RETURN
   END IF
   CALL q520_show()
END FUNCTION
 
FUNCTION q520_show()
                                                # 顯示單頭值
   DISPLAY BY NAME g_coe.coe03,g_coe.cob02,g_coe.cob09,g_coe.coc03,
                   g_coe.coc10,g_coe.coe05,g_coe.coe10,g_coe.coe06
                                                # 顯示單頭值
   CALL q520_b_fill()                           #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q520_b_fill()                          #BODY FILL UP
   DEFINE   l_sql          LIKE type_file.chr1000,     #No.FUN-680069 VARCHAR(400)
	    I,J 	   LIKE type_file.num10        #No.FUN-680069 INTEGER
   IF cl_null(tm2_1.yy) THEN
      LET l_sql=" SELECT cnl03,cnl04,cnl05,cnl06,cnl07,cnl08,",
                "        cnl09,cnl10,cnl11,cnl12,cnl13,cnl14,",
                "        cnl15,cnl16,cnl17",
                "  FROM cnl_file WHERE cnl01 ='",g_coe.coc03,"'",
                "   AND cnl02 ='",g_coe.coe03,"'",
	        " ORDER BY cnl03"
   ELSE
      IF cl_null(tm2_1.mm) OR tm2_1.mm = '0' THEN LET tm2_1.mm = '0'  END IF
      LET l_sql=" SELECT cnl03,cnl04,cnl05,cnl06,cnl07,cnl08,",
                "        cnl09,cnl10,cnl11,cnl12,cnl13,cnl14,",
                "        cnl15,cnl16,cnl17",
                "  FROM cnl_file WHERE cnl01 ='",g_coe.coc03,"'",
                "   AND cnl02 ='",g_coe.coe03,"'",
                "   AND cnl03 >= ",tm2_1.yy," ",
                "   AND cnl04 >= ",tm2_1.mm," ",
	        " ORDER BY cnl03"
    END IF
    PREPARE q520_pb1 FROM l_sql
    DECLARE q520_bcs1 CURSOR FOR q520_pb1
 
    FOR g_cnt = 1 TO g_cnl.getLength()          #單身 ARRAY 乾洗
       INITIALIZE g_cnl[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q520_bcs1 INTO g_cnl[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach1:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	  EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)                     #告訴I.單身筆數
END FUNCTION
 
FUNCTION q520_bp(p_ud)
   DEFINE   p_ud          LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cnl TO s_coe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-560228
 
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
         CALL q520_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q520_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q520_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q520_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q520_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#Patch....NO.TQC-610035 <001,002,003,004,005> #
