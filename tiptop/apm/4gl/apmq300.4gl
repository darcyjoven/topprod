# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: apmq300.4gl
# Descriptions...: 已入庫采購單價變更查詢作業
# Date & Author..: 05/06/16 By jackie
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-840027 08/04/10 By Dido rvx_file 新增紀錄時間欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
   g_rvx01       LIKE rvx_file.rvx01,  
   g_rvx01_t     LIKE rvx_file.rvx01, 
   g_rvx DYNAMIC ARRAY OF RECORD          #程式變數(Program Variables)
         rvx02   LIKE rvx_file.rvx02,
         rvx03   LIKE rvx_file.rvx03,
         rvx031  LIKE rvx_file.rvx031,    #FUN-840027
         rvx04   LIKE rvx_file.rvx04,
         rvx04t  LIKE rvx_file.rvx04t,
         rvx05   LIKE rvx_file.rvx05,
         rvx06   LIKE rvx_file.rvx06,
         rvx05t  LIKE rvx_file.rvx05t,
         rvx06t  LIKE rvx_file.rvx06t,
         rvxuser LIKE rvx_file.rvxuser
             END RECORD,
   g_rvx_t       RECORD                   #程式變數 (舊值)
         rvx02   LIKE rvx_file.rvx02,
         rvx03   LIKE rvx_file.rvx03,
         rvx031  LIKE rvx_file.rvx031,    #FUN-840027
         rvx04   LIKE rvx_file.rvx04,
         rvx04t  LIKE rvx_file.rvx04t,
         rvx05   LIKE rvx_file.rvx05,
         rvx06   LIKE rvx_file.rvx06,
         rvx05t  LIKE rvx_file.rvx05t,
         rvx06t  LIKE rvx_file.rvx06t,
         rvxuser LIKE rvx_file.rvxuser
             END RECORD,
   g_argv1       LIKE rvx_file.rvx01,
   g_wc,g_sql    LIKE type_file.chr1000,     #No.FUN-680136 VARCHAR(300)
   g_rec_b       LIKE type_file.num5,        #單身筆數 #No.FUN-680136 SMALLINT
   l_ac          LIKE type_file.num5         #目前處理的ARRAY CNT        #No.FUN-680136 SMALLINT
DEFINE   g_forupd_sql    STRING                       #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 # CALL cl_used('apmq300',g_time,1) RETURNING g_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   LET g_argv1    = ARG_VAL(1)            #入庫單號
   LET g_rvx01   = NULL                  #清除鍵值
   LET g_rvx01_t = NULL
   LET g_rvx01   = g_argv1
   
   OPEN WINDOW q300_w WITH FORM "apm/42f/apmq300"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN
      CALL q300_q()
   END IF
   CALL q300_menu()
   CLOSE WINDOW q300_w                    #結束畫面

 # CALL cl_used('apmq300',g_time,2) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211

END MAIN
 
FUNCTION q300_curs()
   CLEAR FORM                             #清除畫面
   CALL g_rvx.clear()
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_rvx01 TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON rvx01
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(rvx01)     #入庫單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_rvv5"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                       
                  DISPLAY g_qryparam.multiret TO rvx01
                  NEXT FIELD rvx01
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION controlg      
            CALL cl_cmdask()     
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvxuser', 'rvxgrup') #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = " rvx01 = '",g_argv1,"'"
   END IF
   LET g_sql = "SELECT UNIQUE rvx01 FROM rvx_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY rvx01"
   PREPARE q300_prepare FROM g_sql        #預備一下
   DECLARE q300_b_curs                    #宣告成可卷動的
      SCROLL CURSOR WITH HOLD FOR q300_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT rvx01) FROM rvx_file WHERE  ",g_wc CLIPPED
   PREPARE q300_precount FROM g_sql
   DECLARE q300_count CURSOR FOR q300_precount
 
END FUNCTION
 
FUNCTION q300_menu()
   WHILE TRUE
      CALL q300_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q300_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvx),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q300_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q300_curs()                       #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_rvx01 TO NULL
      RETURN
   END IF
 
   OPEN q300_b_curs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rvx01 TO NULL
   ELSE
      OPEN q300_count
      FETCH q300_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL q300_fetch('F')                #讀出TEMP第一筆并顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION q300_fetch(p_flag)
DEFINE   p_flag     LIKE type_file.chr1                #處理方式        #No.FUN-680136 VARCHAR(1)
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     q300_b_curs INTO g_rvx01
      WHEN 'P' FETCH PREVIOUS q300_b_curs INTO g_rvx01
      WHEN 'F' FETCH FIRST    q300_b_curs INTO g_rvx01
      WHEN 'L' FETCH LAST     q300_b_curs INTO g_rvx01
      WHEN '/' 
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
         FETCH ABSOLUTE g_jump q300_b_curs INTO g_rvx01
         LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_rvx01,SQLCA.sqlcode,0)
      INITIALIZE g_rvx01 TO NULL
   ELSE
      CALL q300_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
  
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION q300_show()
   DISPLAY g_rvx01 TO rvx01             #單頭
   CALL q300_b_fill(g_wc)                 #單身
 
END FUNCTION
 
FUNCTION q300_b_fill(p_wc)                #BODY FILL UP
DEFINE   p_wc        LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
   LET g_sql = " SELECT rvx02,rvx03,rvx031,rvx04,rvx04t,rvx05,rvx06,rvx05t,rvx06t,rvxuser",  #FUN-840027
               "  FROM rvx_file",
               " WHERE rvx01 = '",g_rvx01,"'",
               "   AND  ",p_wc CLIPPED,
               " ORDER BY rvx02,rvx03"
   PREPARE q300_prepare2 FROM g_sql       #預備一下
   DECLARE rvx_curs CURSOR FOR q300_prepare2
   CALL g_rvx.clear()
   LET g_cnt = 1
 
   FOREACH rvx_curs INTO g_rvx[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rvx.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q300_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvx TO s_rvx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
                              
      ON ACTION previous
         CALL q300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
 
      ON ACTION jump
         CALL q300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
 
      ON ACTION next
         CALL q300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION last
         CALL q300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about      
         CALL cl_about()  
   
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
