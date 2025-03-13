# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsq500.4gl
# Descriptions...: APS規劃結果彙總查詢
# Date & Author..: 08/04/24 By rainy   #FUN-840156
# Modify.........: No.FUN-840209  BY DUKE  change g_dbs to g_plant
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B50050 11/05/11 By Mandy APS GP5.25 追版---str---
# Modify.........: No.FUN-940012 09/04/29 By Duke 調整APS版本開窗模式
# Modify.........: No:FUN-B50050 11/05/11 By Mandy ------------------end---
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-840156
 
DEFINE
    g_argv1	LIKE voj_file.voj01,        # 版本  
    g_argv2	LIKE voj_file.voj02,        # 儲存版本 
    g_argv3	LIKE voj_file.voj04,	    # 料號  
    g_voj01	LIKE voj_file.voj01,        # 版本  
    g_voj02	LIKE voj_file.voj02,        # 儲存版本 
    g_voj04	LIKE voj_file.voj04,	    # 料號  
    g_wc,g_wc2      STRING,  
    g_sql           STRING,    
    g_voj           DYNAMIC ARRAY OF RECORD            #程式變數(Program Variables)
			voj03  	LIKE voj_file.voj03,  
			voj06   LIKE voj_file.voj06,  
			voj07   LIKE voj_file.voj07, 
			voj08   LIKE voj_file.voj08, 
			voj09   LIKE voj_file.voj09, 
			voj10   LIKE voj_file.voj10, 
			voj11   LIKE voj_file.voj11, 
			voj12   LIKE voj_file.voj12, 
			voj13   LIKE voj_file.voj13, 
			voj14   LIKE voj_file.voj14, 
			voj15   LIKE voj_file.voj15, 
			voj16   LIKE voj_file.voj16, 
			voj17   LIKE voj_file.voj17, 
			voj18   LIKE voj_file.voj18, 
			voj19   LIKE voj_file.voj19,  
			voj20   LIKE voj_file.voj20,  
			voj21   LIKE voj_file.voj21,  
			voj22   LIKE voj_file.voj22,  
			voj23   LIKE voj_file.voj23,  
			voj24   LIKE voj_file.voj24,  
			voj25   LIKE voj_file.voj25,  
			voj26   LIKE voj_file.voj26,  
			voj27   LIKE voj_file.voj27,  
			voj28   LIKE voj_file.voj28,  
			voj29   LIKE voj_file.voj29,  
			voj30   LIKE voj_file.voj30,  
			voj31   LIKE voj_file.voj31,  
			voj32   LIKE voj_file.voj32,  
			voj33   LIKE voj_file.voj33,  
			voj34   LIKE voj_file.voj34,  
			voj35   LIKE voj_file.voj35,  
			voj36   LIKE voj_file.voj36,  
			voj37   LIKE voj_file.voj37,  
			voj38   LIKE voj_file.voj38,  
			voj39   LIKE voj_file.voj39  
                    END RECORD,
    g_rec_b         LIKE type_file.num5,    #單身筆數              
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT   
 
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_msg           LIKE type_file.chr1000 
DEFINE   g_row_count     LIKE type_file.num10   
DEFINE   g_curs_index    LIKE type_file.num10   
DEFINE   g_jump          LIKE type_file.num10   
DEFINE   mi_no_ask       LIKE type_file.num5    
 
MAIN
    DEFINE p_row,p_col  LIKE type_file.num5     
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1= ARG_VAL(1)
   LET g_argv2= ARG_VAL(2)
   LET g_argv3= ARG_VAL(3)
   INITIALIZE g_voj01 TO NULL
   INITIALIZE g_voj02 TO NULL
   INITIALIZE g_voj04 TO NULL
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET p_row = 2 LET p_col = 2 
   OPEN WINDOW q500_w AT p_row,p_col
        WITH FORM "aps/42f/apsq500" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN CALL q500_q() END IF
   CALL q500()
   CLOSE WINDOW q500_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q500()
    CALL q500_menu()
END FUNCTION
 
FUNCTION q500_cs()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF cl_null(g_argv1) THEN
       CLEAR FORM
       CALL g_voj.clear()
       INITIALIZE g_voj01 TO NULL    
       INITIALIZE g_voj02 TO NULL    
       INITIALIZE g_voj04 TO NULL    
        
       CONSTRUCT BY NAME g_wc ON voj01,voj02,voj04 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
            ON ACTION CONTROLP
              CASE
                WHEN INFIELD(voj01) 
                   CALL cl_init_qry_var()
                  #FUN-940012 MOD --STR-------------------------------
                  #LET g_qryparam.form = "q_voj01"
                  #LET g_qryparam.state = "c"
                  #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  #DISPLAY g_qryparam.multiret TO voj01
                   LET g_qryparam.form = "q_voj02"
                   LET g_qryparam.default1 = g_voj01
                   LET g_qryparam.arg1 = g_plant CLIPPED
                   CALL cl_create_qry() RETURNING g_voj01,g_voj02
                   DISPLAY g_voj01 TO voj01
                   DISPLAY g_voj02 TO voj02
                  #FUN-940012 MOD --END---------------------------
                   NEXT FIELD voj01
                WHEN INFIELD(voj04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO voj04
                   NEXT FIELD voj04
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
    ELSE
       LET g_wc="voj01='",g_argv1,"' AND voj02='",g_argv2,"' AND voj04='",g_argv3,"'"
    END IF
    LET g_sql="SELECT UNIQUE voj01,voj02,voj04 FROM voj_file ",
              " WHERE ",g_wc CLIPPED," ORDER BY voj01,voj02"
    PREPARE q500_prepare FROM g_sql              
    DECLARE q500_cs SCROLL CURSOR WITH HOLD FOR q500_prepare
 
    DROP TABLE count_tmp                                                        
    LET g_sql = "SELECT UNIQUE voj01,voj02,voj04 FROM voj_file WHERE ",g_wc CLIPPED,   
                "  INTO TEMP count_tmp"                                                 
    PREPARE q500_precount1 FROM g_sql                                           
    EXECUTE q500_precount1                                                  
    DECLARE q500_count CURSOR FOR select count(*) FROM count_tmp
END FUNCTION
 
 
FUNCTION q500_menu()
   WHILE TRUE
      CALL q500_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q500_q() 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
       #@WHEN "明細"
         WHEN "contents"
            IF l_ac > 0 THEN
              LET g_msg="apsq510 '",g_voj01,"' '",g_voj02,"' '",g_voj[l_ac].voj03,"' '",g_voj04,"' "
              CALL cl_cmdrun(g_msg)
            END IF
      END CASE
   END WHILE
   CLOSE q500_cs
END FUNCTION
 
 
FUNCTION q500_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q500_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
   CALL g_voj.clear()
   MESSAGE " SEARCHING ! " 
   OPEN q500_count
   FETCH q500_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_voj01,SQLCA.sqlcode,0)
       
       INITIALIZE g_voj01 TO NULL
       INITIALIZE g_voj02 TO NULL
       INITIALIZE g_voj04 TO NULL
   ELSE
       CALL q500_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
 
FUNCTION q500_fetch(p_flg)
    DEFINE
        p_flg         LIKE type_file.chr1    
 
    CASE p_flg
        WHEN 'N' FETCH NEXT     q500_cs INTO g_voj01,g_voj02,g_voj04 
        WHEN 'P' FETCH PREVIOUS q500_cs INTO g_voj01,g_voj02,g_voj04 
        WHEN 'F' FETCH FIRST    q500_cs INTO g_voj01,g_voj02,g_voj04 
        WHEN 'L' FETCH LAST     q500_cs INTO g_voj01,g_voj02,g_voj04 
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump q500_cs INTO g_voj01,g_voj02,g_voj04
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_voj01,SQLCA.sqlcode,0)
        INITIALIZE g_voj01 TO NULL
        INITIALIZE g_voj02 TO NULL
        INITIALIZE g_voj04 TO NULL
        CALL g_voj.clear() 
        RETURN
    ELSE
       CASE p_flg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL q500_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q500_show()
  DEFINE l_ima02  LIKE ima_file.ima02     
 
  DISPLAY g_voj01 TO voj01
  DISPLAY g_voj02 TO voj02
  DISPLAY g_voj04 TO voj04
 
  SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = g_voj04
  DISPLAY l_ima02 TO FORMONLY.ima02
 
  CALL g_voj.clear()
 
  CALL q500_b_fill(' 1=1') 
  CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION q500_b_fill(p_wc2)              #BODY FILL UP
#DEFINE p_wc2            LIKE type_file.chr1000 
 DEFINE p_wc2            STRING      #NO.FUN-910082   
    LET g_sql =
        "SELECT voj03,voj06,voj07,voj08,voj09,",
        "       voj10,voj11,voj12,voj13,voj14,",
        "       voj15,voj16,voj17,voj18,voj19,",
        "       voj20,voj21,voj22,voj23,voj24,",
        "       voj25,voj26,voj27,voj28,voj29,",
        "       voj30,voj31,voj32,voj33,voj34,",
        "       voj35,voj36,voj37,voj38,voj39 ",
        " FROM voj_file",
        " WHERE voj00 ='",g_plant,"'",   #FUN-840209
        "   AND voj01 ='",g_voj01,"'",
        "   AND voj02 ='",g_voj02,"'",
        "   AND voj04 ='",g_voj04,"'",
        " ORDER BY voj03"
    PREPARE q500_pb FROM g_sql
    DECLARE voj_curs CURSOR FOR q500_pb
 
    CALL g_voj.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH voj_curs INTO g_voj[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    CALL g_voj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_voj TO s_voj.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()   
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DISPLAY        
      ON ACTION previous
         CALL q500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY           
                              
      ON ACTION jump 
         CALL q500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY            
                              
      ON ACTION next
         CALL q500_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
                              
 
      ON ACTION last 
         CALL q500_fetch('L')
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
      EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
   ON ACTION cancel
             LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
   
      ON ACTION contents #明細單身
         LET g_action_choice="contents"
         EXIT DISPLAY
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-B50050
