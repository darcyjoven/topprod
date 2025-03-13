# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmq302
# Descriptions...: 商品客戶明細數量查詢
# Date & Author..: 2006/03/24 By Sarah
# Modify.........: No.FUN-630027 06/03/24 By Sarah 新增"商品客戶明細數量查詢"
# Modify.........: No.FUN-660104 06/06/15 By Rayven cl_err改成cl_err3
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790073 07/09/12 By lumxa 指定筆對話框沒有"確定","程序信息"按鈕i
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE tm                RECORD
                          wc  	  STRING 	       # Head Where condition
                         END RECORD,
       g_tup11           LIKE tup_file.tup11,          #庫存類型
       g_tup02           LIKE tup_file.tup02,          #倉庫編號             
       g_ima02           LIKE ima_file.ima02,          #品名
       g_tup03           LIKE tup_file.tup03,          #存放位置
       g_tup             DYNAMIC ARRAY OF RECORD
                          tup01   LIKE tup_file.tup01, #客戶編號
                          occ02   LIKE occ_file.occ02, #客戶名稱
                          tup12   LIKE tup_file.tup12, #送貨客戶
                          occ02b  LIKE occ_file.occ02, #送貨客戶名稱
                          tup04   LIKE tup_file.tup04, #存放批號
                          tup05   LIKE tup_file.tup05, #是否為可用倉庫
                          tup06   LIKE tup_file.tup06, #庫存單位
                          tup07   LIKE tup_file.tup07  #Expire date
                         END RECORD,
       g_argv1           LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)                     #INPUT ARGUMENT - 1
       g_argv2           LIKE tup_file.tup02,          #INPUT ARGUMENT - 2
       g_query_flag      LIKE type_file.num5,          #No.FUN-680120 SMALLINT  #第一次進入程式時即進入Query之後進入N.下筆
       g_sql             STRING, #WHERE CONDITION      #No.FUN-580092 HCN
       g_rec_b           LIKE type_file.num5   	       #單身筆數        #No.FUN-680120 SMALLINT
DEFINE p_row,p_col       LIKE type_file.num5           #No.FUN-680120 SMALLINT
DEFINE g_cnt             LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE g_msg             LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(72)
DEFINE l_ac              LIKE type_file.num5           #No.FUN-680120 SMALLINT
DEFINE g_row_count       LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE g_curs_index      LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE g_jump            LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE mi_no_ask         LIKE type_file.num5           #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6B0014
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
   DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理
 
   LET g_argv1  = ARG_VAL(1)               #參數值(1) Part#
   LET g_argv2  = ARG_VAL(2)               #參數值(2) Part#
 
   CASE g_argv1
      WHEN "1" LET g_prog = 'atmq302'
      WHEN "2" LET g_prog = 'atmq312'
      OTHERWISE 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
 
   LET g_query_flag=1
 
   LET p_row = 3 LET p_col = 4  
   OPEN WINDOW q302_w AT p_row,p_col
        WITH FORM "atm/42f/atmq302"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
   CALL q302_menu()         
   CLOSE WINDOW q302_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION q302_cs()
   DEFINE l_cnt   LIKE type_file.num5           #No.FUN-680120 SMALLINT
   DEFINE l_sql   STRING
 
   CASE g_argv1
      WHEN "1" LET l_sql = " AND tup11 ='1' "
      WHEN "2" LET l_sql = " AND tup11 ='2' "
   END CASE
 
   IF g_argv2 != ' ' THEN
      LET tm.wc = "tup02 = '",g_argv2,"'"
   ELSE 
      CLEAR FORM #清除畫面
      CALL g_tup.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
 
      #螢幕上取單頭條件
      CALL cl_set_head_visible("","YES")  #No.FUN-6B0031
   INITIALIZE g_tup02 TO NULL    #No.FUN-750051
   INITIALIZE g_tup03 TO NULL    #No.FUN-750051
   INITIALIZE g_tup11 TO NULL    #No.FUN-750051
      CONSTRUCT tm.wc ON tup02,tup03,tup01,tup12,tup04,tup05,tup06,tup07 
           FROM tup02,tup03,s_tup[1].tup01,s_tup[1].tup12,s_tup[1].tup04,
                s_tup[1].tup05,s_tup[1].tup06,s_tup[1].tup07
 
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
 
         ON IDLE g_idle_seconds                                            
            CALL cl_on_idle()                                              
            CONTINUE CONSTRUCT                                             
 
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_select() 
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
   
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
   
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
                                                                             
      END CONSTRUCT 
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF
   MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
 
   LET g_sql="SELECT UNIQUE tup02,tup03,tup11 FROM tup_file ",
             " WHERE ",tm.wc CLIPPED,l_sql,
             " ORDER BY tup02 "
   PREPARE q302_prepare FROM g_sql
   DECLARE q302_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q302_prepare
 
   #取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql="SELECT COUNT(UNIQUE tup02) FROM tup_file ",
             " WHERE ",tm.wc CLIPPED,l_sql 
   PREPARE q302_pp FROM g_sql
   DECLARE q302_cnt CURSOR FOR q302_pp
   OPEN q302_cnt                                                            
   FETCH q302_cnt INTO g_row_count                                           
   CLOSE q302_cnt
END FUNCTION
 
FUNCTION q302_menu()
 
   WHILE TRUE
      CALL q302_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q302_q()
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
 
FUNCTION q302_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    MESSAGE ""    
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL q302_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q302_cnt
    FETCH q302_cnt INTO g_row_count
    DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
    OPEN q302_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       CALL q302_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
MESSAGE ''
END FUNCTION
 
FUNCTION q302_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q302_cs INTO g_tup02,g_tup03,g_tup11
        WHEN 'P' FETCH PREVIOUS q302_cs INTO g_tup02,g_tup03,g_tup11
        WHEN 'F' FETCH FIRST    q302_cs INTO g_tup02,g_tup03,g_tup11
        WHEN 'L' FETCH LAST     q302_cs INTO g_tup02,g_tup03,g_tup11
        WHEN '/'
          CALL cl_set_act_visible("accept,cancel", TRUE)  #TQC-790073 
          IF (NOT mi_no_ask) THEN   #No.FUN-6A0072
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON ACTION about         #TQC-790073
                    CALL cl_about()      #TQC-790073 
 
                 ON ACTION help          #TQC-790073 
                    CALL cl_show_help()  #TQC-790073
 
                 ON ACTION controlg      #TQC-790073                                                                              
                    CALL cl_cmdask()     #TQC-790073  
 
                #MOD-860081------add-----str---
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
                #MOD-860081------add-----end---
 
            END PROMPT  
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
          CALL cl_set_act_visible("accept,cancel", FALSE)  #TQC-790073 
          END IF
          FETCH ABSOLUTE g_jump q302_cs INTO g_tup02,g_tup03,g_tup11
          LET mi_no_ask = FALSE    #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tup02,SQLCA.sqlcode,0)
        INITIALIZE g_tup02 TO NULL  #TQC-6B0105
        INITIALIZE g_tup03 TO NULL  #TQC-6B0105
        INITIALIZE g_tup11 TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag                                                              
          WHEN 'F' LET g_curs_index = 1                                        
          WHEN 'P' LET g_curs_index = g_curs_index - 1                        
          WHEN 'N' LET g_curs_index = g_curs_index + 1                        
          WHEN 'L' LET g_curs_index = g_row_count                             
          WHEN '/' LET g_curs_index = g_jump                                   
       END CASE                                                                 
       CALL cl_navigator_setting( g_curs_index, g_row_count ) 
    END IF
    CALL q302_show()
END FUNCTION
 
FUNCTION q302_show()
   DISPLAY g_tup11,g_tup02,g_tup03 TO tup11,tup02,tup03
   SELECT ima02 INTO g_ima02 FROM ima_file WHERE ima01 = g_tup02 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_tup02,SQLCA.sqlcode,0)  #No.FUN-660104 MARK
      CALL cl_err3("sel","ima_file",g_tup02,"",SQLCA.sqlcode,"","",0)  #No.FUN-660104
      RETURN
   END IF
   DISPLAY g_ima02 TO ima02
   CALL q302_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q302_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(1000)
 
   LET l_sql =
        "SELECT tup01,a.occ02,tup12,b.occ02,tup04,tup05,tup06,tup07 ",
        "  FROM tup_file, OUTER occ_file a , OUTER occ_file b ",
        " WHERE tup02 = '",g_tup02,"'",
        "   AND tup03 = '",g_tup03,"'",
        "   AND tup11 = '",g_tup11,"'",
        "   AND tup_file.tup01 = a.occ01 ",
        "   AND tup_file.tup12 = b.occ01 ",
        "   AND ", tm.wc CLIPPED,
        " ORDER BY tup01,tup12"
    PREPARE q302_pb FROM l_sql
    DECLARE q302_bcs CURSOR FOR q302_pb             #BODY CURSOR
 
    CALL g_tup.clear()  
    LET g_rec_b= 0
    LET g_cnt  = 1
    FOREACH q302_bcs INTO g_tup[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(g_tup[g_cnt].tup05) THEN LET g_tup[g_cnt].tup05 = 0 END IF
       DISPLAY g_tup[g_cnt].occ02,g_tup[g_cnt].occ02b TO occ02,occ02b
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	  EXIT FOREACH
       END IF 
    END FOREACH
    CALL g_tup.deleteElement(g_cnt)  
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
END FUNCTION
 
FUNCTION q302_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tup TO s_tup.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count ) 
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q302_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL q302_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump 
         CALL q302_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL q302_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL q302_fetch('L')
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
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
