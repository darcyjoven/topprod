# Prog. Version..: '5.30.06-13.04.16(00008)'     #
#
# Pattern name...: axrq500.4gl
# Descriptions...: 客戶應收各期餘額查詢
# Date & Author..: 94/02/13 By Roger
# Modify.........: 97/08/28 By Sophia 新增工廠別(ooo10),帳別(ooo11)
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-530516 05/03/26 By saki 原幣餘額計算修改
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740377 07/04/23 By hongmei 修改單身每一個期別的資料均顯示兩次，導致余額變成Double
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770016 07/07/02 By judy 匯出EXCEL的值多一空白行
# Modify.........: No.MOD-8C0286 08/12/31 By Sarah 科目名稱沒帶出
# Modify.........: No.MOD-980133 09/08/17 By liuxqa 原幣余額和本幣余額的值為空值。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整g_rec_b為integer
# Modify.........: No:MOD-CC0196 12/12/21 By Polly 抓取單身時增加串帳別條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE h_ooo   RECORD
                ooo10   LIKE ooo_file.ooo10,
                ooo11   LIKE ooo_file.ooo11,
                ooo01   LIKE ooo_file.ooo01,
                ooo02   LIKE ooo_file.ooo02,
                ooo06   LIKE ooo_file.ooo06,
                ooo03   LIKE ooo_file.ooo03,
                aag02   LIKE aag_file.aag02,
                ooo04   LIKE ooo_file.ooo04,
                ooo05   LIKE ooo_file.ooo05
               END RECORD,
       g_ooo   DYNAMIC ARRAY OF RECORD
                ooo07   LIKE ooo_file.ooo07,
                ooo08d  LIKE ooo_file.ooo08d,
                ooo08c  LIKE ooo_file.ooo08c,
                bal8    LIKE ooo_file.ooo08d,
                ooo09d  LIKE ooo_file.ooo09d,
                ooo09c  LIKE ooo_file.ooo09c,
                bal9    LIKE ooo_file.ooo09d
               END RECORD
DEFINE g_wc,g_wc2,g_sql STRING                   #WHERE CONDITION  #No.FUN-580092 HCN  
DEFINE g_rec_b          LIKE type_file.num10     #單身筆數  #No.FUN-A70120
DEFINE g_cnt            LIKE type_file.num10     #No.FUN-680123 INTEGER
DEFINE g_msg            LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10     #No.FUN-680123 INTEGER
DEFINE g_curs_index     LIKE type_file.num10     #No.FUN-680123 INTEGER
DEFINE g_jump           LIKE type_file.num10     #No.FUN-680123 INTEGER
DEFINE g_no_ask         LIKE type_file.num5
 
MAIN
   OPTIONS                                             #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                    #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0095

   OPEN WINDOW q500_w WITH FORM "axr/42f/axrq500"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL q500_menu()
    CLOSE WINDOW q500_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0095
END MAIN
 
#QBE 查詢資料
FUNCTION q500_cs()
   CLEAR FORM #清除畫面
   CALL g_ooo.clear()
   CALL cl_opmsg('q')
   WHILE TRUE
     CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
     INITIALIZE h_ooo.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON
        ooo10,ooo11,ooo01,ooo02,ooo06,ooo03,ooo04,ooo05
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
     IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
     IF g_wc=" 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET g_wc = g_wc clipped," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET g_wc = g_wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
     #        LET g_wc = g_wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
     EXIT WHILE
   END WHILE
 
   MESSAGE ' WAIT '
   LET g_sql="SELECT DISTINCT ooo10,ooo11,ooo01,ooo02,ooo06,ooo03,aag02,",
             "                ooo04,ooo05",
             "  FROM ooo_file LEFT OUTER JOIN aag_file ON aag01=ooo03 AND aag00=ooo11 ",
            #"   AND aag_file.aag00='",h_ooo.ooo11,"'",  #No.MOD-740377  #MOD-8C0286 mark
             "   WHERE ",g_wc CLIPPED,
             " ORDER BY ooo01"
   PREPARE q500_prepare FROM g_sql
   DECLARE q500_cs SCROLL CURSOR FOR q500_prepare
   DISPLAY "G_SQL=",g_sql
 
   LET g_sql="SELECT DISTINCT ooo10,ooo11,ooo01,ooo02,ooo06,ooo03,aag02,",
             "                ooo04,ooo05",
             "  FROM ooo_file LEFT OUTER JOIN aag_file ON aag01=ooo03 AND aag00=ooo11 ",
            #"   AND aag_file.aag00='",h_ooo.ooo11,"'",  #No.MOD-740377  #MOD-8C0286 mark
             "   WHERE ",g_wc CLIPPED,                     
             " INTO TEMP x "
   DROP TABLE x
   PREPARE q500_precount_x FROM g_sql
   EXECUTE q500_precount_x
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE q500_precount FROM g_sql
   DECLARE q500_count SCROLL CURSOR FOR q500_precount
END FUNCTION
 
FUNCTION q500_menu()
 
   WHILE TRUE
      CALL q500_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q500_q()
            END IF
#           NEXT OPTION "next資料"
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #FUN-4B0017
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ooo),'','')
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
    CALL q500_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q500_count
       FETCH q500_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q500_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q500_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #處理方式   #No.FUN-680123 VARCHAR(1)
    l_abso          LIKE type_file.num10       #絕對的筆數 #No.FUN-680123 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q500_cs INTO h_ooo.*
        WHEN 'P' FETCH PREVIOUS q500_cs INTO h_ooo.*
        WHEN 'F' FETCH FIRST    q500_cs INTO h_ooo.*
        WHEN 'L' FETCH LAST     q500_cs INTO h_ooo.*
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
                   ON ACTION about         #MOD-4C0121
                      CALL cl_about()      #MOD-4C0121
              
                   ON ACTION help          #MOD-4C0121
                      CALL cl_show_help()  #MOD-4C0121
              
                   ON ACTION controlg      #MOD-4C0121
                      CALL cl_cmdask()     #MOD-4C0121
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump q500_cs INTO h_ooo.*
            LET g_no_ask = FALSE
    END CASE
    IF STATUS THEN
       INITIALIZE h_ooo.* TO NULL    #No.TQC-6B0105
       CALL cl_err(h_ooo.ooo01,STATUS,0) RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    CALL q500_show()
END FUNCTION
 
FUNCTION q500_show()
   DISPLAY BY NAME h_ooo.*   # 顯示單頭值
   CALL q500_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q500_b_fill()              #BODY FILL UP
   DEFINE g_tot8,g_tot9 LIKE ooo_file.ooo08c   #add 030526 NO.A076
   DEFINE l_aag06       LIKE aag_file.aag06    # No.MOD-530516 add
   DEFINE l_tot8_o      LIKE ooo_file.ooo08c
   DEFINE l_tot9_o      LIKE ooo_file.ooo08c
 
    #modify 030526 NO.A076
    DECLARE q500_bcs CURSOR WITH HOLD FOR
     SELECT ooo07,ooo08d,ooo08c,0,ooo09d,ooo09c,0,aag06
       FROM ooo_file,aag_file
      WHERE ooo01=h_ooo.ooo01 AND ooo02=h_ooo.ooo02
        AND ooo03=h_ooo.ooo03 AND ooo04=h_ooo.ooo04
        AND ooo05=h_ooo.ooo05 AND ooo06=h_ooo.ooo06
        AND aag01=ooo03       AND aag00=h_ooo.ooo11          #No.MOD-740377 
        AND aag00 = ooo11                                        #MOD-CC0196 add
      ORDER BY ooo07
 
    FOR g_cnt = 1 TO g_ooo.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_ooo[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    #modify 030526 NO.A076
    FOREACH q500_bcs INTO g_ooo[g_cnt].*,l_aag06
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
       IF g_cnt=1 THEN
          LET g_tot8 = 0
          LET g_tot9 = 0
       ELSE                      #No.MOD-980133 將MARK還原
#         LET g_tot8 = g_ooo[g_cnt-1].bal8
#         LET g_tot9 = g_ooo[g_cnt-1].bal9
        # No.MOD-530516 --start--
          LET g_tot8 = l_tot8_o
          LET g_tot9 = l_tot9_o
        # No.MOD-530516 ---end---
       END IF
       LET g_ooo[g_cnt].bal8 = g_tot8+g_ooo[g_cnt].ooo08d-g_ooo[g_cnt].ooo08c
       LET g_ooo[g_cnt].bal9 = g_tot9+g_ooo[g_cnt].ooo09d-g_ooo[g_cnt].ooo09c
       # No.MOD-530516 --start--
       LET l_tot8_o = g_ooo[g_cnt].bal8
       LET l_tot9_o = g_ooo[g_cnt].bal9
       # No.MOD-530516 ---end---
       #add 030526 NO.A076
       IF l_aag06 = '2' AND g_ooo[g_cnt].bal8 < 0 THEN  #貸方科目
          LET g_ooo[g_cnt].bal8 = g_ooo[g_cnt].bal8 * -1
          LET g_ooo[g_cnt].bal9 = g_ooo[g_cnt].bal9 * -1
       END IF
       LET g_cnt = g_cnt + 1
       # genero shell add g_max_rec check START
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
       # genero shell add g_max_rec check END
    END FOREACH
    CALL g_ooo.deleteElement(g_cnt)   #TQC-770016 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   IF p_ud <> "G"  OR g_action_choice = "detail"THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ooo TO s_ooo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      #No.MOD-530853  --begin
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.MOD-530853  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
