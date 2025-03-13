# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsq510.4gl
# Descriptions...: APS 規劃結果明細查詢
# Date & Author..: 08/04/23 By rainy #FUN-840156
# Modify.........: FUN-840209 BY DUKE  change g_dbs to g_plant
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-840156
 
DEFINE
     g_argv1		LIKE voj_file.voj01,     #APS版本
     g_argv2		LIKE voj_file.voj02,	 #儲存版本
     g_argv3		LIKE voj_file.voj03,     #序號
     g_argv4		LIKE voj_file.voj04,     #料號
     g_voj		RECORD LIKE voj_file.*,
     g_wc               STRING,   
     g_sql              STRING,   
     g_vok              DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
			vok06  	 LIKE vok_file.vok06,
			vok07  	 LIKE vok_file.vok07,
			vok08  	 LIKE vok_file.vok08,
			vok09  	 LIKE vok_file.vok09,
			vok10  	 LIKE vok_file.vok10,
			vok11  	 LIKE vok_file.vok11,
			vok12  	 LIKE vok_file.vok12
                    END RECORD,
    g_rec_b                LIKE type_file.num5,    #單身筆數              
    l_ac                   LIKE type_file.num5     #目前處理的ARRAY CNT   
 
DEFINE   g_cnt             LIKE type_file.num10     
DEFINE   g_msg             LIKE type_file.chr1000   
DEFINE   g_row_count       LIKE type_file.num10     
DEFINE   g_curs_index      LIKE type_file.num10     
DEFINE   g_jump            LIKE type_file.num10     
DEFINE   mi_no_ask         LIKE type_file.num5      
 
MAIN
    DEFINE p_row,p_col     LIKE type_file.num5    
 
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
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)              #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
      RETURNING g_time         
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4)
 
   INITIALIZE g_voj.* TO NULL
   LET p_row = 2 LET p_col = 2 
 
   OPEN WINDOW q510_w AT p_row,p_col
        WITH FORM "aps/42f/apsq510"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN CALL q510_q() END IF
   CALL q510_menu()
   CLOSE WINDOW q510_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
 
FUNCTION q510_cs()
   CLEAR FORM
   CALL g_vok.clear()
   CALL cl_set_head_visible("","YES") 
   IF cl_null(g_argv1) THEN
       INITIALIZE g_voj.* TO NULL   
       CONSTRUCT BY NAME g_wc ON voj01,voj02,voj04
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          ON ACTION CONTROLP
            CASE
              WHEN INFIELD(voj01) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_voj01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO voj01
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
     ELSE
       LET g_wc="voj00 = '",g_plant,"' AND voj01='",g_argv1,"'" #FUN-840209
       IF NOT cl_null(g_argv2) THEN
          LET g_wc=g_wc CLIPPED, " AND voj02='",g_argv2,"'"
       END IF
       IF NOT cl_null(g_argv3) THEN
          LET g_wc=g_wc CLIPPED, " AND voj03=",g_argv3
       END IF
       IF NOT cl_null(g_argv4) THEN
          LET g_wc=g_wc CLIPPED, " AND voj04='",g_argv4,"'"
       END IF
    END IF
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT voj_file.* FROM voj_file ",
              " WHERE ",g_wc CLIPPED," ORDER BY voj01,voj02,voj04"
    PREPARE q510_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q510_cs SCROLL CURSOR WITH HOLD FOR q510_prepare
    LET g_sql= "SELECT COUNT(*) FROM voj_file WHERE ",g_wc CLIPPED
    PREPARE q510_precount FROM g_sql
    DECLARE q510_count CURSOR FOR q510_precount
END FUNCTION
 
 
FUNCTION q510_menu()
 
   WHILE TRUE
      CALL q510_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q510_q() 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_vok),'','')
             END IF
      END CASE
   END WHILE
   CLOSE q510_cs
END FUNCTION
 
 
FUNCTION q510_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q510_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
   CALL g_vok.clear()
   MESSAGE " SEARCHING ! " 
   OPEN q510_count
   FETCH q510_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q510_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_voj.voj01,SQLCA.sqlcode,0)
       INITIALIZE g_voj.* TO NULL
   ELSE
       CALL q510_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION q510_fetch(p_flag)
    DEFINE
        p_flag         LIKE type_file.chr1
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q510_cs INTO g_voj.*
        WHEN 'P' FETCH PREVIOUS q510_cs INTO g_voj.*
        WHEN 'F' FETCH FIRST    q510_cs INTO g_voj.*
        WHEN 'L' FETCH LAST     q510_cs INTO g_voj.*
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
            FETCH ABSOLUTE g_jump q510_cs INTO g_voj.*
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_voj.* TO NULL  
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
    CALL q510_show()                      # 重新顯示
END FUNCTION
 
 
FUNCTION q510_show()
    DEFINE l_ima02     LIKE ima_file.ima02
    DISPLAY BY NAME
              g_voj.voj01, g_voj.voj02, g_voj.voj03, g_voj.voj04, 
              g_voj.voj06, g_voj.voj07, g_voj.voj08, g_voj.voj09,
              g_voj.voj10, g_voj.voj11, g_voj.voj12, g_voj.voj13,
              g_voj.voj14, g_voj.voj15, g_voj.voj16, g_voj.voj17,
              g_voj.voj18, g_voj.voj19, g_voj.voj20, g_voj.voj21,
              g_voj.voj22, g_voj.voj23, g_voj.voj24, g_voj.voj25,
              g_voj.voj26, g_voj.voj27, g_voj.voj28, g_voj.voj29,
              g_voj.voj30, g_voj.voj31, g_voj.voj32, g_voj.voj33,
              g_voj.voj34, g_voj.voj35, g_voj.voj36, g_voj.voj37,
              g_voj.voj38, g_voj.voj39
    INITIALIZE l_ima02 TO NULL
    SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=g_voj.voj04
    DISPLAY l_ima02 TO FORMONLY.ima02
    CALL q510_b_fill(' 1=1')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION q510_b_fill(p_wc2)              #BODY FILL UP
#DEFINE p_wc2       LIKE type_file.chr1000
DEFINE p_wc2            STRING      #NO.FUN-910082    
 
    LET g_sql =
        "SELECT vok06, vok07, vok08, vok09, vok10, vok11, vok12",
        " FROM vok_file",
        " WHERE vok00 ='",g_plant,"'",  #FUN-840209
        "   AND vok01 ='",g_voj.voj01,"'",
        "   AND vok02 ='",g_voj.voj02,"'",
        "   AND vok03 ='",g_voj.voj04,"'",
        "   AND vok05 ='",g_voj.voj06,"'",
        " ORDER BY vok06" 
    PREPARE q510_pb FROM g_sql
    DECLARE vok_curs CURSOR FOR q510_pb
 
    CALL g_vok.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH vok_curs INTO g_vok[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_vok.deleteElement(g_cnt)  
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q510_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #NO.FUN-680082 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_vok TO s_vok.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) 
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      CALL cl_show_fld_cont()                 
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q510_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                  
          EXIT DISPLAY  
 
      ON ACTION previous
         CALL q510_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                 
          EXIT DISPLAY  
 
      ON ACTION jump 
         CALL q510_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
        EXIT DISPLAY  
                              
 
      ON ACTION next
         CALL q510_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
          EXIT DISPLAY  
                              
 
      ON ACTION last 
         CALL q510_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                  
          EXIT DISPLAY  
                              
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
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
 
