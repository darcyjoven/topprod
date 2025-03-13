# Prog. Version..: '5.10.00-08.01.04(00000)'     #
# Pattern name...: axdq101
# Descriptions...: 客戶商品明細數量查詢
# Date & Author..: 2003/12/05 By Leagh
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE 
    tm  RECORD
        	wc   LIKE type_file.chr1000	# Head Where condition     #No.FUN-680108 VARCHAR(500)
        END RECORD,
    g_adp01 LIKE adp_file.adp01,
    g_occ02 LIKE occ_file.occ02,
    g_adp DYNAMIC ARRAY OF RECORD
            adp02   LIKE adp_file.adp02, #倉庫編號             
            ima02   LIKE ima_file.ima02,
            adp03   LIKE adp_file.adp03, #存放位置
            adp04   LIKE adp_file.adp04, #存放批號
            adp05   LIKE adp_file.adp05, #是否為可用倉庫
            adp06   LIKE adp_file.adp06, #庫存單位
            adp07   LIKE adp_file.adp07  # Expire date
        END RECORD,
    g_argv1         LIKE adp_file.adp01, # INPUT ARGUMENT - 1
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入N.下筆  #No.FUN-680108 SMALLINT
     g_sql          string, #WHERE CONDITION  #No:FUN-580092 HCN
    g_rec_b LIKE type_file.num5   	 #單身筆數 #No.FUN-680108 SMALLINT
DEFINE p_row,p_col      LIKE type_file.num5        #No.FUN-680108 SMALLINT
DEFINE   g_cnt          LIKE type_file.num10       #No.FUN-680108 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000,    #No.FUN-680108 VARCHAR(72)
         l_ac           LIKE type_file.num5        #No.FUN-680108 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10       #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10       #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10       #No.FUN-680108 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5        #No.FUN-680108 SMALLINT   #No.FUN-6A0078

MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0091

   OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,        #畫面開始的位置
        MESSAGE LINE    LAST,             #訊息顯示的位置
        PROMPT LINE     LAST,             #提示訊息的位置
        INPUT NO WRAP                     #輸入的方式: 不打轉
    DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
      CALL  cl_used(g_prog,g_time,1)      #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
       LET p_row = 3 LET p_col = 4  
 OPEN WINDOW q101_w AT p_row,p_col
        WITH FORM "axd/42f/axdq101"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()
#    IF cl_chk_act_auth() THEN
#       CALL q101_q()
#    END IF
    CALL q101_menu()         
    CLOSE WINDOW q101_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION q101_cs()
   DEFINE   l_cnt LIKE type_file.num5     #No.FUN-680108 SMALLINT

   IF g_argv1 != ' '
      THEN LET tm.wc = "adp01 = '",g_argv1,"'"
      ELSE CLEAR FORM #清除畫面
      CALL g_adp.clear()
           CALL cl_opmsg('q')
        INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_adp01 TO NULL    #No.FUN-750051
           CONSTRUCT tm.wc ON adp01,adp02,adp03,adp04,adp05,adp06,adp07 # 螢幕上取單頭條件
                FROM adp01,s_adp[1].adp02,s_adp[1].adp03,s_adp[1].adp04,
                     s_adp[1].adp05,s_adp[1].adp06,s_adp[1].adp07

            #No:FUN-580031 --start--     HCN
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
            #No:FUN-580031 --end--       HCN

            ON IDLE g_idle_seconds                                            
                CALL cl_on_idle()                                              
                CONTINUE CONSTRUCT                                             

            #No:FUN-580031 --start--     HCN
            ON ACTION qbe_select
                CALL cl_qbe_select() 
            ON ACTION qbe_save
                CALL cl_qbe_save()
            #No:FUN-580031 --end--       HCN
 
            ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121
   
            ON ACTION help          #MOD-4C0121
               CALL cl_show_help()  #MOD-4C0121
   
            ON ACTION controlg      #MOD-4C0121
               CALL cl_cmdask()     #MOD-4C0121
                                                                                
           END CONSTRUCT 
           IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF
   MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
   LET g_sql=" SELECT UNIQUE adp01 FROM adp_file ",
             "  WHERE ",tm.wc CLIPPED ,
             "  ORDER BY adp01 " 
   PREPARE q101_prepare FROM g_sql
   DECLARE q101_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q101_prepare

   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql=" SELECT COUNT(UNIQUE adp01) FROM adp_file ",
              "  WHERE ",tm.wc CLIPPED 
   PREPARE q101_pp  FROM g_sql
   DECLARE q101_cnt   CURSOR FOR q101_pp
   OPEN q101_cnt                                                            
   FETCH q101_cnt INTO g_row_count                                           
   CLOSE q101_cnt
END FUNCTION

FUNCTION q101_menu()

   WHILE TRUE
      CALL q101_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q101_q()
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

FUNCTION q101_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    MESSAGE ""    
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL q101_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q101_cnt
    FETCH q101_cnt INTO g_row_count
    DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
    OPEN q101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION

FUNCTION q101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1      #處理方式      #No.FUN-680108 VARCHAR(1)

    CASE p_flag
        WHEN 'N' FETCH NEXT     q101_cs INTO g_adp01
        WHEN 'P' FETCH PREVIOUS q101_cs INTO g_adp01
        WHEN 'F' FETCH FIRST    q101_cs INTO g_adp01
        WHEN 'L' FETCH LAST     q101_cs INTO g_adp01
        WHEN '/'
          IF (NOT mi_no_ask) THEN  #No.FUN-6A0078
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             PROMPT g_msg CLIPPED,': ' FOR g_jump
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
          END IF
          FETCH ABSOLUTE g_jump q101_cs INTO g_adp01
          LET mi_no_ask = FALSE   #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adp01,SQLCA.sqlcode,0)
        INITIALIZE g_adp01 TO NULL  #TQC-6B0105
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
    CALL q101_show()
END FUNCTION

FUNCTION q101_show()
   DISPLAY g_adp01 TO adp01 #ATTRIBUTE(YELLOW)  # 顯示單頭值
   SELECT occ02 INTO g_occ02 FROM occ_file WHERE occ01 = g_adp01 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_adp01,SQLCA.sqlcode,0)
      RETURN
   END IF
   DISPLAY g_occ02 TO occ02
   CALL q101_b_fill() #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION q101_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000        #No.FUN-680108 VARCHAR(1000)

   LET l_sql =
        "SELECT adp02,ima02,adp03,adp04,adp05,adp06,adp07 ",
        "  FROM  adp_file, OUTER ima_file",
        " WHERE adp01 = '",g_adp01,"'",
        "   AND adp02 = ima_file.ima01 AND ", tm.wc CLIPPED,
        " ORDER BY adp02,adp03"
    PREPARE q101_pb FROM l_sql
    DECLARE q101_bcs                       #BODY CURSOR
        CURSOR FOR q101_pb

    CALL g_adp.clear()  
    LET g_rec_b= 0
    LET g_cnt  = 1
    FOREACH q101_bcs INTO g_adp[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF cl_null(g_adp[g_cnt].adp05) THEN LET g_adp[g_cnt].adp05 = 0 END IF
        DISPLAY g_adp[g_cnt].ima02 TO ima02
        LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
       END IF 
    END FOREACH
    CALL g_adp.deleteElement(g_cnt)  
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
END FUNCTION

FUNCTION q101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)


   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adp TO s_adp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
                                                                                
         CALL cl_navigator_setting( g_curs_index, g_row_count ) 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION previous
         CALL q101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION jump 
         CALL q101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION next
         CALL q101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION last
         CALL q101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
