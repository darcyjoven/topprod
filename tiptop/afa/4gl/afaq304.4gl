# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: afaq304.4gl
# Descriptions...: 帳款餘額查詢
# Date & Author..: 97/06/27 By Star
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-680028 06/09/08 By Ray 新增"營運中心"和"帳別"欄位
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740026 07/04/11 By sherry  會計科目加帳套
# Modify.........: No.TQC-740093 07/04/11 By atsea  會計科目加帳套修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790086 07/09/13 By Judy 匯出Excel多一空白行
# Modify.........: No.MOD-970038 09/07/06 By mike FUNCTION q304_b_fill(),SQL需加上下列條件                                          
#                                                 "   AND foo07 = '",g_head_1.foo07,"'",                                            
#                                                 "   AND foo08 = '",g_head_1.foo08,"'"     
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
     wc  LIKE type_file.chr1000		# Head Where condition        #No.FUN-680070
         END RECORD,
    g_head_1  RECORD
            foo01		LIKE foo_file.foo01,
            foo02		LIKE foo_file.foo02,
            foo03		LIKE foo_file.foo03,
            foo07		LIKE foo_file.foo07,     #No.FUN-680028
            foo08		LIKE foo_file.foo08      #No.FUN-680028
        END RECORD,
    g_foo DYNAMIC ARRAY OF RECORD
            foo03b  LIKE foo_file.foo03,
            foo04   LIKE foo_file.foo04,
            foo05d  LIKE foo_file.foo05d,
            foo06c  LIKE foo_file.foo06c,
            bal     LIKE foo_file.foo06c,
            dc      LIKE type_file.chr1          #No.FUN-680070
        END RECORD,
     g_wc,g_sql string,     #WHERE CONDITION  #No.FUN-580092 HCN
    l_ac,l_sl   LIKE type_file.num5,          #No.FUN-680070
    g_rec_b LIKE type_file.num5   		  #單身筆數        #No.FUN-680070
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680070
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680070
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680070
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680070
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0069
DEFINE        l_sl	LIKE type_file.num5          #No.FUN-680070
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680070
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
    LET p_row = 2 LET p_col = 10
    OPEN WINDOW q111_w AT p_row,p_col
         WITH FORM "afa/42f/afaq304"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q304_q()
#    END IF
    CALL q304_menu()
    CLOSE FORM q304_srn               #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
END MAIN
 
#QBE 查詢資料
FUNCTION q304_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680070
 
   CLEAR FORM #清除畫面
   CALL g_foo.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL	         # Default condition
   CALL cl_set_head_visible("grid01","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_head_1.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON foo01,foo02,foo03,foo07,foo08     #No.FUN-680028
 
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
 
 
   LET g_sql=" SELECT UNIQUE foo01,foo02,foo03,foo07,foo08 ",     #No.FUN-680028
             "  FROM foo_file,aag_file",
             " WHERE ",tm.wc CLIPPED,
             "   AND foo01 = aag01 ",
#             "   AND aag00= '",g_head_1.foo08,"'",       #No.FUN-740026   #No.TQC-740093
             " ORDER BY 1,2,3,4,5"
   PREPARE q304_prepare FROM g_sql
   DECLARE q304_cs SCROLL CURSOR FOR q304_prepare
 
   DROP TABLE count_tmp
   LET g_sql=" SELECT foo01,foo02,foo03,foo07,foo08 ",     #No.FUN-680028
             "  FROM foo_file,aag_file",
             " WHERE ",tm.wc CLIPPED,
             "   AND foo01 = aag01 ",
#             "   AND aag00= '",g_head_1.foo08,"'",       #No.FUN-740026   #No.TQC-740093
             " GROUP BY foo01,foo02,foo03,foo07,foo08 ",     #No.FUN-680028
             " INTO TEMP count_tmp"
   PREPARE q304_cnt_tmp  FROM g_sql
   EXECUTE q304_cnt_tmp
   DECLARE q304_count CURSOR FOR SELECT COUNT(*) FROM count_tmp
 
 
END FUNCTION
 
FUNCTION q304_menu()
 
   WHILE TRUE
      CALL q304_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q304_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_foo),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q304_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q304_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q304_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q304_count
        FETCH q304_count INTO g_row_count #CKP
        DISPLAY g_row_count TO FORMONLY.cnt #CKP
        CALL q304_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q304_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680070
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680070
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q304_cs INTO g_head_1.*
        WHEN 'P' FETCH PREVIOUS q304_cs INTO g_head_1.*
        WHEN 'F' FETCH FIRST    q304_cs INTO g_head_1.*
        WHEN 'L' FETCH LAST     q304_cs INTO g_head_1.*
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
            FETCH ABSOLUTE l_abso q304_cs INTO g_head_1.*
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head_1.foo01,SQLCA.sqlcode,0)
        INITIALIZE g_head_1.* TO NULL  #TQC-6B0105
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
 
    CALL q304_show()
END FUNCTION
 
FUNCTION q304_show()
  DEFINE l_aag02 LIKE aag_file.aag02
 
   DISPLAY BY NAME g_head_1.* # 顯示單頭值
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_head_1.* # 顯示單頭值
   DISPLAY BY NAME g_head_1.foo01,g_head_1.foo02,g_head_1.foo03,g_head_1.foo07,g_head_1.foo08
   #No.FUN-9A0024--end 
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = g_head_1.foo01
                                             AND aag00 = g_head_1.foo08   #No.FUN-740026 
   IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF
   DISPLAY l_aag02 TO FORMONLY.aag02
   CALL q304_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q304_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680070
          l_n       LIKE type_file.num5,          #No.FUN-680070
          l_tot     LIKE foo_file.foo05d
 
   LET l_sql =
        "SELECT foo03, foo04, foo05d, foo06c, 0, '' FROM foo_file",
        " WHERE foo01 = '",g_head_1.foo01,"'",
        "   AND foo02 = '",g_head_1.foo02,"'",
        "   AND foo03 = '",g_head_1.foo03,"'", #MOD-970038      add ,                                                               
        "   AND foo07 = '",g_head_1.foo07,"'", #MOD-970038                                                                          
        "   AND foo08 = '",g_head_1.foo08,"'"  #MOD-970038            
    PREPARE q304_pb FROM l_sql
    DECLARE q304_bcs CURSOR FOR q304_pb
 
    FOR g_cnt = 1 TO g_foo.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_foo[g_cnt].* TO NULL
    END FOR
    LET l_tot = 0
    LET l_ac = 1
	FOREACH q304_bcs INTO g_foo[l_ac].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('q304(ckp#1):',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF g_foo[l_ac].foo04 = 0
           THEN LET l_tot =         g_foo[l_ac].foo05d - g_foo[l_ac].foo06c
           ELSE LET l_tot = l_tot + g_foo[l_ac].foo05d - g_foo[l_ac].foo06c
        END IF
        IF l_tot > 0
           THEN LET g_foo[l_ac].bal = l_tot    LET g_foo[l_ac].dc  = 'D'
           ELSE LET g_foo[l_ac].bal = l_tot*-1 LET g_foo[l_ac].dc  = 'C'
        END IF
        IF l_tot = 0 THEN LET g_foo[l_ac].dc  = '' END IF
#       IF l_ac >= g_foo_arrno THEN EXIT FOREACH END IF
        LET l_ac = l_ac + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_foo.deleteElement(l_ac)  #TQC-790086
    LET g_rec_b = l_ac - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q304_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680070
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_foo TO s_foo.*
     ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q304_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q304_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q304_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q304_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q304_fetch('L')
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
        #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
       #No.MOD-530853  --end
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("grid01","AUTO")                    
#No.FUN-6B0029--end
  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610035 <001,002,003,004,005,006,007> #
