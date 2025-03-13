# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aooq011.4gl
# Descriptions...: 帳套週期期間查詢 
# Date & Author..: 2006/07/12 By Tracy
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-790009 07/09/04 By Carrier 1.去掉"不使用多帳套"時,run aooq010的內容
# Modify.........: No.MOD-810099 08/03/24 By Pengu 當起始日期不是星期天時則或多一筆截止日期為99/12/31 的異常資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-C30036 12/03/07 By Summer 查詢條件有下週次時,呈現的資料異常 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_aznn00    LIKE aznn_file.aznn00,
    g_aznn00_t  LIKE aznn_file.aznn00,
    g_aznn_t    RECORD
                  aznn05 LIKE aznn_file.aznn05,
                  aznn01 LIKE aznn_file.aznn01,
    	          aznn02 LIKE aznn_file.aznn02,
    	          aznn03 LIKE aznn_file.aznn03,
                  aznn04 LIKE aznn_file.aznn04
    	        END RECORD,
    g_aznn_o    RECORD
                  aznn05 LIKE aznn_file.aznn05,
    	          aznn01 LIKE aznn_file.aznn01,
    	          aznn02 LIKE aznn_file.aznn02,
    	          aznn03 LIKE aznn_file.aznn03,
                  aznn04 LIKE aznn_file.aznn04
    	        END RECORD,
    g_aznn      DYNAMIC ARRAY OF RECORD
                  aznn05   LIKE aznn_file.aznn05,
    	          aznn01_b LIKE aznn_file.aznn01,
       	          aznn01_e LIKE aznn_file.aznn01,
    	      	  aznn02   LIKE aznn_file.aznn02,
	    	  aznn03   LIKE aznn_file.aznn03,
                  aznn04   LIKE aznn_file.aznn04
                END RECORD,
    g_argv1       LIKE aznn_file.aznn00,
    g_wc,g_sql    STRING,       
    g_rec_b       LIKE type_file.num10          #No.FUN-680102 #單身筆數
DEFINE   p_row,p_col     LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03,           #No.FUN-680102CHAR(72),
         l_ac            LIKE type_file.num5                  #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0081
   DEFINE l_aza63       LIKE aza_file.aza63
 
   OPTIONS                                       #改變一些系統預設值
        INPUT NO WRAP
   DEFER INTERRUPT                               #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)                 #計算使用時間 (進入時間)   #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
   #No.FUN-790009  --Begin
   #SELECT aza63 INTO l_aza63 from aza_file
   #IF l_aza63 ='N' THEN
   #   CALL cl_cmdrun('aooq010')
   #   EXIT PROGRAM    
   #END IF
   #No.FUN-790009  --End  
 
   LET g_argv1      = ARG_VAL(1)                 #參數值(1) Part#
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW q011_w AT p_row,p_col
        WITH FORM "aoo/42f/aooq011"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN CALL q011_q() END IF
   CALL q011_menu()
   CLOSE WINDOW q011_w
   CALL  cl_used(g_prog,g_time,2)                 #計算使用時間 (退出使間)   #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
#QBE 查詢資料
FUNCTION q011_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF NOT cl_null(g_argv1) THEN                                                                                                         
      LET g_wc = "pmc01 = '",g_argv1,"'"                                                                                      
   ELSE 
      CLEAR FORM                                 #清除畫面
      CALL g_aznn.clear()
      CALL cl_opmsg('q')
   INITIALIZE g_aznn00 TO NULL    #No.FUN-750051
      CONSTRUCT g_wc ON  aznn00,aznn05,aznn01,aznn02,aznn03,aznn04 FROM
                         aznn00,s_aznn[1].aznn05,s_aznn[1].aznn01_b,
                         s_aznn[1].aznn02,s_aznn[1].aznn03,s_aznn[1].aznn04 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
            ON ACTION CONTROLP
               CASE WHEN INFIELD(aznn00)         #帳套
                         CALL cl_init_qry_var()
                         LET g_qryparam.state= "c"
                         LET g_qryparam.form = "q_aaa"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO aznn00
                         NEXT FIELD aznn00
               OTHERWISE EXIT CASE
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
 
            ON ACTION qbe_select
               CALL cl_qbe_select()
 
            ON ACTION qbe_save
                 CALL cl_qbe_save()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE aznn00 FROM aznn_file ",
             " WHERE ",g_wc CLIPPED,
             " ORDER BY aznn00"
   PREPARE q011_prepare FROM g_sql
   DECLARE q011_cs                               #SCROLL CURSOR
           SCROLL CURSOR FOR q011_prepare
 
   #取合乎條件筆數
   LET g_sql=" SELECT COUNT(DISTINCT aznn00) FROM aznn_file ",
              " WHERE ",g_wc CLIPPED
   PREPARE q011_pp  FROM g_sql
   DECLARE q011_cnt   CURSOR FOR q011_pp
END FUNCTION
 
FUNCTION q011_menu()
 
   WHILE TRUE
      CALL q011_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q011_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aznn),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q011_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q011_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q011_cs                                  #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q011_cnt
      FETCH q011_cnt INTO g_row_count 
      DISPLAY g_row_count TO cnt  
      CALL q011_fetch('F')                       #讀出TEMP第一筆並顯示
   END IF
   MESSAGE ''
 
END FUNCTION
 
FUNCTION q011_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                       #處理方式        #No.FUN-680102 VARCHAR(1)
    l_abso          LIKE type_file.num10                       #絕對的筆數        #No.FUN-680102 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q011_cs INTO g_aznn00
        WHEN 'P' FETCH PREVIOUS q011_cs INTO g_aznn00
        WHEN 'F' FETCH FIRST    q011_cs INTO g_aznn00
        WHEN 'L' FETCH LAST     q011_cs INTO g_aznn00
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  
             PROMPT g_msg CLIPPED,': ' FOR l_abso
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
             FETCH ABSOLUTE l_abso q011_cs INTO g_aznn00
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_aznn00,SQLCA.sqlcode,0)
       INITIALIZE g_aznn00 TO NULL  #TQC-6B0105
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
 
    CALL q011_show()
END FUNCTION
 
FUNCTION q011_show()
   DISPLAY g_aznn00 TO aznn00                    #顯示單頭值
   CALL q011_b_fill()                            #單身
   CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION q011_b_fill()                           #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680102CHAR(1000)
 
   LET l_sql = "SELECT aznn05,aznn01,aznn02,aznn03,aznn04 FROM aznn_file",
               " WHERE aznn00 = '",g_aznn00,"'", 
               "   AND ",g_wc CLIPPED,
               " ORDER BY aznn01,aznn05"
   PREPARE q011_pb FROM l_sql
   DECLARE q011_bcs                              #BODY CURSOR
      CURSOR WITH HOLD FOR q011_pb
 
   CALL g_aznn.clear()     
   LET g_cnt = 1
   LET g_rec_b = 0
   LET l_ac = 1
   FOREACH q011_bcs INTO g_aznn_t.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF WEEKDAY(g_aznn_t.aznn01) = 0 OR                 #星期日
         cl_null(g_aznn[l_ac].aznn01_b) THEN
         LET g_aznn[l_ac].aznn05 = g_aznn_t.aznn05       #週次
         LET g_aznn[l_ac].aznn01_b = g_aznn_t.aznn01     #起始日期
      END IF
         
      IF g_aznn_o.aznn02<>g_aznn_t.aznn02                #跨年度時
         AND g_aznn_o.aznn05<>g_aznn_t.aznn05            #週次 #MOD-C30036 add
         AND NOT cl_null(g_aznn_o.aznn02) THEN
         LET g_aznn[l_ac].aznn01_e = g_aznn_o.aznn01     #截止日期
         LET g_aznn[l_ac].aznn02 = g_aznn_o.aznn02       #年度
         LET g_aznn[l_ac].aznn03 = g_aznn_o.aznn03       #季別
         LET g_aznn[l_ac].aznn04 = g_aznn_o.aznn04       #期別
 
         IF WEEKDAY(g_aznn_t.aznn01) >0 THEN 
            IF l_ac > 1 THEN     #No.MOD-810099 add
               LET l_ac = l_ac + 1
            END IF               #No.MOD-810099 add
            LET g_aznn[l_ac].aznn05 = g_aznn_t.aznn05    #週次
            LET g_aznn[l_ac].aznn01_b = g_aznn_t.aznn01  #起始日期
         END IF 
      END IF
      IF WEEKDAY(g_aznn_t.aznn01) = 6 THEN               # 星期六
         LET g_aznn[l_ac].aznn01_e = g_aznn_t.aznn01
         LET g_aznn[l_ac].aznn02 = g_aznn_t.aznn02
         LET g_aznn[l_ac].aznn03 = g_aznn_t.aznn03
         LET g_aznn[l_ac].aznn04 = g_aznn_t.aznn04
         LET l_ac = l_ac + 1
      END IF 
      LET g_aznn_o.*=g_aznn_t.*
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   IF cl_null(g_aznn[l_ac].aznn01_e) AND NOT cl_null(g_aznn[l_ac].aznn01_b) THEN
      LET g_aznn[l_ac].aznn01_e = g_aznn_t.aznn01
      LET g_aznn[l_ac].aznn02   = g_aznn_t.aznn02
      LET g_aznn[l_ac].aznn03   = g_aznn_t.aznn03
      LET g_aznn[l_ac].aznn04   = g_aznn_t.aznn04
      LET l_ac = l_ac + 1
   END IF
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0 
END FUNCTION
 
FUNCTION q011_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
   DEFINE   l_sl   LIKE type_file.num5          #No.FUN-680102SMALLINT
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aznn TO s_aznn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()         
 
#No.FUN-6B0030------Begin--------------                                                                                             
         ON ACTION controls                                                                                                             
            CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DISPLAY
 
         ON ACTION first
            CALL q011_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  
            END IF
            ACCEPT DISPLAY         
 
 
         ON ACTION previous
            CALL q011_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  
            END IF
            ACCEPT DISPLAY               
 
 
         ON ACTION jump
            CALL q011_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1) 
            END IF
            ACCEPT DISPLAY      
 
 
         ON ACTION next
            CALL q011_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count) 
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  
            END IF
            ACCEPT DISPLAY             
 
 
         ON ACTION last
            CALL q011_fetch('L')
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
 
 
         ON ACTION exporttoexcel      
            LET g_action_choice = 'exporttoexcel'
            EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
