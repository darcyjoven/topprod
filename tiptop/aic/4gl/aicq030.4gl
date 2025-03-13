# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aicq030.4gl
# Descriptions...: 料件儲位各期異動統計量查詢
# Date & Author..: 12/11/01 By Bart #FUN-CA0151

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm               RECORD
                      wc    LIKE type_file.chr1000, 
                      wc1   LIKE type_file.chr1000 
                    #  wc2   LIKE type_file.chr1000 
                     END RECORD,
    g_idx_h          RECORD
                      idx01   LIKE idx_file.idx01, # 料件編號
                      idx02   LIKE idx_file.idx02, # 倉庫編號
                      idx03   LIKE idx_file.idx03, # 存放位置
                      idx04   LIKE idx_file.idx04  # 批號
                     END RECORD,
    g_idx            DYNAMIC ARRAY OF RECORD
                      idx05   LIKE idx_file.idx05,  #年度
                      idx06   LIKE idx_file.idx06,  #期別
                      idx10   LIKE idx_file.idx10,  #刻號
                      idx11   LIKE idx_file.idx11,  #BIN
                      idx081  LIKE idx_file.idx081, #入庫
                      idx082  LIKE idx_file.idx082, #出
                      idx083  LIKE idx_file.idx083, #銷貨
                      idx084  LIKE idx_file.idx084, #轉
                      idx085  LIKE idx_file.idx085, #調整
                      idx09   LIKE idx_file.idx09   #期未結存
                     END RECORD,
    g_ima02          LIKE ima_file.ima02,  # 品名
    g_ima021         LIKE ima_file.ima021, # 品名
 #   g_ima25          LIKE ima_file.ima25,  # 單位
 #   g_query_flag     LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next 
    g_sql            string,                
    g_rec_b          LIKE type_file.num5     #單身筆數  
 
DEFINE p_row,p_col    LIKE type_file.num5   
DEFINE g_cnt          LIKE type_file.num10   
DEFINE g_msg          STRING 
DEFINE g_row_count    LIKE type_file.num10  
DEFINE g_curs_index   LIKE type_file.num10  
DEFINE g_jump         LIKE type_file.num10   
DEFINE mi_no_ask      LIKE type_file.num5    
DEFINE g_ac           LIKE type_file.num5   
 
MAIN
   DEFINE      l_sl   LIKE type_file.num5     
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)    
         RETURNING g_time   
    #LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q030_w AT p_row,p_col
         WITH FORM "aic/42f/aicq030"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL q030_menu()
    CLOSE WINDOW q030_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
         RETURNING g_time    
END MAIN
 
#QBE 查詢資料
FUNCTION q030_cs()
   DEFINE   l_cnt LIKE type_file.num5  
 
   CLEAR FORM
   CALL g_idx.clear()
   CALL cl_opmsg('q')
   INITIALIZE g_idx_h.* TO NULL    
   INITIALIZE tm.* TO NULL		
   CALL cl_set_head_visible("","YES")  
   CONSTRUCT BY NAME tm.wc ON idx01,ima02,ima021,idx02,idx03,idx04
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(img01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO img01
              NEXT FIELD img01
         END CASE
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
   CONSTRUCT tm.wc1 ON idx05,idx06 FROM yy, mm
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
 
    MESSAGE ' WAIT '
    LET g_sql= " SELECT DISTINCT idx01,idx02,idx03,idx04,",  
               "        ima02,ima021 ",       
               " FROM idx_file,ima_file",
               " WHERE ima01 = idx01 ",
               " AND (idx081 <> 0 OR idx082 <> 0 OR idx083 <> 0 OR idx084 <> 0 OR idx085 <> 0 OR idx09 <> 0) ",
               " AND ",tm.wc CLIPPED,
               " AND ",tm.wc1 CLIPPED
 
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
 
   LET g_sql = g_sql clipped," ORDER BY idx01"
    PREPARE q030_prepare FROM g_sql
    DECLARE q030_cs                   
            SCROLL CURSOR FOR q030_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql=" SELECT COUNT(*) ",
              " FROM (SELECT DISTINCT idx01,idx02,idx03,idx04 FROM idx_file ",
              " WHERE ",tm.wc CLIPPED,
              "   AND (idx081 <> 0 OR idx082 <> 0 OR idx083 <> 0 OR idx084 <> 0 OR idx085 <> 0 OR idx09 <> 0) ",
              " AND ",tm.wc1 CLIPPED, " )"
    PREPARE q030_pp  FROM g_sql
    DECLARE q030_count   CURSOR FOR q030_pp
END FUNCTION
 
FUNCTION q030_menu()
 
   WHILE TRUE
      CALL q030_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q030_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_idx),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q030_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q030_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN q030_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q030_count
       FETCH q030_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q030_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q030_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式   
    l_abso          LIKE type_file.num10     #絕對的筆數  
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q030_cs INTO g_idx_h.idx01,
                                             g_idx_h.idx02,g_idx_h.idx03,g_idx_h.idx04,   
                                             g_ima02,g_ima021
        WHEN 'P' FETCH PREVIOUS q030_cs INTO g_idx_h.idx01,
                                             g_idx_h.idx02,g_idx_h.idx03,g_idx_h.idx04,   
                                             g_ima02,g_ima021
        WHEN 'F' FETCH FIRST    q030_cs INTO g_idx_h.idx01,
                                             g_idx_h.idx02,g_idx_h.idx03,g_idx_h.idx04,   
                                             g_ima02,g_ima021
        WHEN 'L' FETCH LAST     q030_cs INTO g_idx_h.idx01,
                                             g_idx_h.idx02,g_idx_h.idx03,g_idx_h.idx04,   
                                             g_ima02,g_ima021
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about         
                     CALL cl_about()     
 
                  ON ACTION HELP         
                     CALL cl_show_help()  
 
                  ON ACTION controlg    
                     CALL cl_cmdask()    
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q030_cs INTO g_idx_h.idx01,
                                               g_idx_h.idx02,g_idx_h.idx03,g_idx_h.idx04,  
                                               g_ima02,g_ima021
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_idx_h.idx01,SQLCA.sqlcode,0)
        INITIALIZE g_idx_h.* TO NULL  
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
    #SELECT idx01,idx02,dx03,idx04 INTO g_idx_h.*
    #  FROM idx_file
    # WHERE idx01 = g_idx_h.idx01 AND idx02 = g_idx_h.idx02 AND idx03 = g_idx_h.idx03 AND idx04 = g_idx_h.idx04
    #IF SQLCA.sqlcode THEN
    #   CALL cl_err3("sel","idx_file",g_idx_h.idx01,"",SQLCA.sqlcode,"","",0)  
    #   RETURN
    #END IF
 
    CALL q030_show()
END FUNCTION
 
FUNCTION q030_show()
   DISPLAY BY NAME g_idx_h.*   # 顯示單頭值
   DISPLAY g_ima02,g_ima021 TO ima02,ima021
   CALL q030_b_fill() #單身
   CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION q030_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING   
 
      LET l_sql =
           "SELECT idx05,idx06,idx10,idx11,idx081,idx082,idx083,idx084,idx085,idx09",
           " FROM  idx_file",
           " WHERE idx01 = '",g_idx_h.idx01,"'",
           "   AND idx02 = '",g_idx_h.idx02,"'",
           "   AND idx03 = '",g_idx_h.idx03,"'",
           "   AND idx04 = '",g_idx_h.idx04,"'",
           "   AND (idx081 <> 0 OR idx082 <> 0 OR idx083 <> 0 OR idx084 <> 0 OR idx085 <> 0 OR idx09 <> 0) ",
           "   AND ",tm.wc1 CLIPPED,
           " ORDER BY idx05,idx06,idx10,idx11 "
   PREPARE q030_pb FROM l_sql
   DECLARE q030_bcs                       #BODY CURSOR
       CURSOR FOR q030_pb
 
   FOR g_cnt = 1 TO g_idx.getLength()           #單身 ARRAY 乾洗
      INITIALIZE g_idx[g_cnt].* TO NULL
   END FOR
   LET g_rec_b=0
   LET g_cnt = 1
   FOREACH q030_bcs INTO g_idx[g_cnt].*
       IF g_cnt=1 THEN
          LET g_rec_b=SQLCA.SQLERRD[3]
       END IF
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(g_idx[g_cnt].idx081) THEN LET g_idx[g_cnt].idx081 = 0 END IF
       IF cl_null(g_idx[g_cnt].idx082) THEN LET g_idx[g_cnt].idx082 = 0 END IF
       IF cl_null(g_idx[g_cnt].idx083) THEN LET g_idx[g_cnt].idx083 = 0 END IF
       IF cl_null(g_idx[g_cnt].idx084) THEN LET g_idx[g_cnt].idx084 = 0 END IF
       IF cl_null(g_idx[g_cnt].idx085) THEN LET g_idx[g_cnt].idx085 = 0 END IF
       IF cl_null(g_idx[g_cnt].idx09) THEN LET g_idx[g_cnt].idx09 = 0 END IF
       LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
   END FOREACH
   CALL g_idx.deleteElement(g_cnt)  
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q030_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_idx TO s_idx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()               
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION first
         CALL q030_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
 
      ON ACTION previous
         CALL q030_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                   
 
      ON ACTION jump
         CALL q030_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL q030_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL q030_fetch('L')
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
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                                                                                          
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                            
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-CA0151
