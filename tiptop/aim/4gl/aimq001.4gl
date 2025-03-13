# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aimq001
# Descriptions...: 標准成本每月資料查詢
# Date & Author..: 09/06/22 By jan
# Modify.........: No.FUN-960056 09/06/22 By jan
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970118 09/11/13 By jan 拿掉版本栏位
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
       g_wc         STRING,  
       g_stx01  LIKE stx_file.stx01, 
       g_stx    DYNAMIC ARRAY OF RECORD
                 stx02  LIKE stx_file.stx02,
                 stx03  LIKE stx_file.stx03,
                #stx04  LIKE stx_file.stx04,   #TQC-970118
                 stx05  LIKE stx_file.stx05,
                 stx06  LIKE stx_file.stx06,
                 stx07  LIKE stx_file.stx07,
                 stx08  LIKE stx_file.stx08,
                 stx09  LIKE stx_file.stx09,
                 stx10  LIKE stx_file.stx10,
                 stx11  LIKE stx_file.stx11,
                 stx12  LIKE stx_file.stx12,
                 stx13  LIKE stx_file.stx13            
                END RECORD,
       g_query_flag    LIKE type_file.num5,        #第一次進入程式時即進入Query之後進入N.下筆
       g_sql           STRING,                     #WHERE CONDITION 
       g_rec_b         LIKE type_file.num5         #單身筆數
DEFINE p_row,p_col     LIKE type_file.num5       
DEFINE g_cnt           LIKE type_file.num10     
DEFINE g_msg           LIKE type_file.chr1000  
DEFINE g_row_count     LIKE type_file.num10   
DEFINE g_curs_index    LIKE type_file.num10     
DEFINE g_jump          LIKE type_file.num10    
DEFINE g_no_ask        LIKE type_file.num5      
DEFINE l_ac            LIKE type_file.num5      
DEFINE g_str           STRING
 
 
 
MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time   #計算使用時間 (開始時間) 
 
    LET g_query_flag = 1
 
    LET p_row = 3 LET p_col = 15
 
    OPEN WINDOW q001_w AT p_row,p_col WITH FORM "aim/42f/aimq001"
         ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
 
    LET g_action_choice = ""
    CALL q001_menu()
    CLOSE WINDOW q001_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) 
END MAIN
 
#QBE 查詢資料
FUNCTION q001_cs()
   DEFINE   l_cnt   LIKE type_file.num5     
 
   LET g_wc = ''
 
      CLEAR FORM #清除畫面
      CALL g_stx.clear() 
      CALL cl_opmsg('q')
      CALL cl_set_head_visible("","YES")  
 
      INITIALIZE g_stx01 TO NULL    
 
      CONSTRUCT g_wc ON stx01,stx02,stx03,stx05,stx06,stx07,stx08,stx09,stx10,stx11,stx12,stx13   # 螢幕上取單頭條件 #TQC-970118
           FROM stx01,s_stx[1].stx02,s_stx[1].stx03,  #TQC-970118
                s_stx[1].stx05,s_stx[1].stx06,s_stx[1].stx07,s_stx[1].stx08,
                s_stx[1].stx09,s_stx[1].stx10,s_stx[1].stx11,s_stx[1].stx12,s_stx[1].stx13
         
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP                                                         
            CASE                                                                    
               WHEN INFIELD(stx01)                                                 
                  CALL cl_init_qry_var()                                              
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form ="q_ima"  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO stx01
                  NEXT FIELD stx01
               OTHERWISE                                                              
                  EXIT CASE                                                           
            END CASE                                                                 
 
         ON ACTION qbe_select
            CALL cl_qbe_select() 
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT        
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   LET g_sql="SELECT UNIQUE stx01 FROM stx_file ",   
             " WHERE ",g_wc CLIPPED ,
             " ORDER BY stx01"                     
   PREPARE q001_prepare FROM g_sql
   DECLARE q001_cs SCROLL CURSOR FOR q001_prepare   #SCROLL CURSOR
 
   #取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql="SELECT UNIQUE stx01 FROM stx_file ",    
             " WHERE ",g_wc CLIPPED ,
             "  INTO TEMP x"
   DROP TABLE x
   PREPARE q001_precount_x FROM g_sql
   EXECUTE q001_precount_x
   
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE q001_pp FROM g_sql
   DECLARE q001_cnt CURSOR FOR q001_pp
END FUNCTION
 
FUNCTION q001_menu()
   WHILE TRUE
      CALL q001_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q001_q()
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL q001_out()
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
 
FUNCTION q001_q()
   LET g_row_count = 0                                                        
   LET g_curs_index = 0                                                       
   CALL cl_navigator_setting( g_curs_index, g_row_count )                    
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt 
   CALL q001_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q001_cs                              # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q001_cnt
      FETCH q001_cnt INTO g_row_count
      DISPLAY g_row_count TO cnt  
      CALL q001_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION q001_fetch(p_flag)
DEFINE p_flag   LIKE type_file.chr1      #處理方式
DEFINE l_abso   LIKE type_file.num5      #絕對的筆數
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q001_cs INTO g_stx01
      WHEN 'P' FETCH PREVIOUS q001_cs INTO g_stx01
      WHEN 'F' FETCH FIRST    q001_cs INTO g_stx01
      WHEN 'L' FETCH LAST     q001_cs INTO g_stx01
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about        
                  CALL cl_about()    
 
               ON ACTION help         
                  CALL cl_show_help() 
 
               ON ACTION controlg     
                  CALL cl_cmdask()    
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump q001_cs INTO g_stx01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_stx01,SQLCA.sqlcode,0)
      INITIALIZE g_stx01 TO NULL  
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
   CALL q001_show()
END FUNCTION
 
FUNCTION q001_show()
   DISPLAY g_stx01 TO stx01 
   CALL q001_stx01()
   CALL q001_b_fill() #單身
   CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION q001_stx01()
DEFINE l_ima02  LIKE ima_file.ima02
DEFINE l_ima021 LIKE ima_file.ima021
 
   SELECT ima02,ima021                                                                                                
     INTO l_ima02,l_ima021                                                                                         
     FROM ima_file                                                                                                                  
    WHERE ima01=g_stx01                                                                                                         
   IF SQLCA.sqlcode THEN 
      LET l_ima02=' ' 
      LET l_ima021=' ' 
   END IF                                                                                  
   DISPLAY l_ima02 TO FORMONLY.ima02                                                                                             
   DISPLAY l_ima021 TO FORMONLY.ima021                                                                                             
END FUNCTION
 
FUNCTION q001_b_fill()                  #BODY FILL UP
   DEFINE l_sql     STRING 
#  DEFINE l_tot     LIKE ima_file.ima26    #FUN-A20044
   DEFINE l_tot     LIKE type_file.num15_3 #FUN-A20044 
 
   LET l_sql="SELECT stx02,stx03,stx05,stx06,stx07,stx08,stx09,stx10,stx11,stx12,stx13 ", #TQC-970118
             "  FROM stx_file ",
             " WHERE stx01 ='",g_stx01,"'",
             "   AND ",g_wc CLIPPED,
             " ORDER BY stx01"
   PREPARE q001_pb FROM l_sql
   DECLARE q001_bcs CURSOR FOR q001_pb     #BODY CURSOR
 
   CALL g_stx.clear() 
   LET g_rec_b= 0
   LET g_cnt  = 1
   FOREACH q001_bcs INTO g_stx[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_stx.deleteElement(g_cnt)
   LET g_rec_b=(g_cnt-1)
   DISPLAY g_rec_b TO FORMONLY.cn2 
 
 
END FUNCTION
 
FUNCTION q001_bp(p_ud)
DEFINE p_ud     LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_stx TO s_stx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()          
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION output                                                          
         LET g_action_choice="output"                                           
         EXIT DISPLAY
      ON ACTION first 
         CALL q001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           
      ON ACTION previous
         CALL q001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY             
      ON ACTION jump 
         CALL q001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
      ON ACTION next
         CALL q001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY 
      ON ACTION last
         CALL q001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()  
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
             LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about        
         CALL cl_about()    
      ON ACTION controls   
         CALL cl_set_head_visible("","AUTO")     
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q001_out()
   DEFINE  l_sql    STRING
   DEFINE  l_wc     STRING
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   LET l_sql="SELECT stx01,stx02,stx03,stx04,stx05,stx06,stx07,stx08,",
             "       stx09,stx10,stx11,stx12,stx13,ima02,ima021",
             "  FROM stx_file,ima_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND stx01=ima01"
 
  #列印選擇條件
  IF g_zz05 = 'Y' THEN
     CALL cl_wcchp(g_wc,'stx01,stx02,stx03,stx04,stx05,stx06,stx07,stx08,stx09,stx10,stx11,stx12,stx13')
          RETURNING g_wc
  ELSE
     LET g_wc = ''
  END IF
  LET g_str=''
  LET g_str=g_wc
  CALL cl_prt_cs1('aimq001','aimq001',l_sql,g_str)
  
  ERROR "" 
  RETURN 
END FUNCTION
#FUN-960056
