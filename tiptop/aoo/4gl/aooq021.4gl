# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aooq021.4gl
# Descriptions...:歷年帳套維護作業
# Date & Author..: 07/05/14 By ve007
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
#No.FUN-750055-----------start----------------
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_tna       RECORD LIKE tna_file.*, 
       g_tna_t     RECORD LIKE tna_file.*, #值   份
       g_wc        STRING,                 
       g_sql       STRING                 
DEFINE g_curs_index          LIKE type_file.num10        
DEFINE g_row_count           LIKE type_file.num10         
DEFINE g_jump                LIKE type_file.num10            
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_i                   LIKE type_file.num5          
DEFINE g_msg                 LIKE type_file.chr1000 
DEFINE mi_no_ask             LIKE type_file.num5
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5,        
        l_time          VARCHAR(8)              
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT 
    
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF 
    
    WHENEVER ERROR CALL cl_err_msg_log 
    
    IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
    END IF
    
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    INITIALIZE g_tna.* TO NULL
    
    LET p_row = 5 LET p_col = 10 
    
    OPEN WINDOW q021_w AT p_row,p_col WITH FORM "aoo/42f/aooq021"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
    CALL cl_ui_init() 
    
    LET g_action_choice = ""
    CALL q021_menu()
    
    CLOSE WINDOW q021_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
    END MAIN
    
FUNCTION q021_curs()
DEFINE ls         STRING
  
    CLEAR FORM
    INITIALIZE g_tna.* TO NULL     #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON
            tna00,tna01,tna02
    ON ACTION controlp
         CASE
           WHEN INFIELD(tna02)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_aaa"
           LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tna.tna02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tna02
                 NEXT FIELD tna02
                 
         OTHERWISE 
         EXIT CASE
         END CASE
 
         
   
    ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
    END CONSTRUCT      
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
          
 
         
      LET g_sql="SELECT tna00,tna01 FROM tna_file ",#指令
                " WHERE ",g_wc CLIPPED," ORDER BY tna00 " 
      PREPARE q021_prepare FROM g_sql
      DECLARE q021_cs SCROLL CURSOR WITH HOLD FOR q021_prepare              
      LET g_sql=
        "SELECT COUNT(*) FROM tna_file WHERE ",g_wc CLIPPED
      PREPARE q021_precount FROM g_sql
      DECLARE q021_count CURSOR FOR q021_precount
END FUNCTION
 
FUNCTION q021_menu() 
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count) 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL q021_q()
            END IF 
        ON ACTION next
            CALL q021_fetch('N')
        ON ACTION previous
            CALL q021_fetch('P') 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL q021_out()
            END IF 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL q021_fetch('/')
        ON ACTION first
            CALL q021_fetch('F')
        ON ACTION last
            CALL q021_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()       
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU   
        
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 	
           LET g_action_choice = "exit"
           EXIT MENU
           
    END MENU
    CLOSE q021_cs
END FUNCTION           
 
FUNCTION q021_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tna.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.ed16  
    CALL q021_curs()                      
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
    END IF 
    OPEN q021_count
    FETCH q021_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.ed17
 
    OPEN q021_cs 
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_tna.tna00,SQLCA.sqlcode,0)
      INITIALIZE g_tna.* TO NULL 
    ELSE
      CALL q021_fetch('F')     
    END IF
END FUNCTION 
 
FUNCTION q021_fetch(p_fltna)
    DEFINE
        p_fltna         LIKE type_file.chr1  
        
    CASE p_fltna
        WHEN 'N' FETCH NEXT     q021_cs INTO g_tna.tna00,g_tna.tna01
        WHEN 'P' FETCH PREVIOUS q021_cs INTO g_tna.tna00,g_tna.tna01
        WHEN 'F' FETCH FIRST    q021_cs INTO g_tna.tna00,g_tna.tna01
        WHEN 'L' FETCH LAST     q021_cs INTO g_tna.tna00,g_tna.tna01
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
             FETCH ABSOLUTE g_jump q021_cs INTO g_tna.tna00,g_tna.tna01
             LET mi_no_ask = FALSE 
    END CASE
    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tna.tna01,SQLCA.sqlcode,0)
        INITIALIZE g_tna.* TO NULL  
        RETURN
    ELSE 
      CASE p_fltna
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE 
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.ed16           
    END IF 
    
    SELECT * INTO g_tna.* FROM tna_file    
       WHERE tna00 = g_tna.tna00 AND tna01 = g_tna.tna01
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_tna.tna00,SQLCA.sqlcode,0)     
    ELSE
       CALL q021_show()                  
    END IF
END FUNCTION
 
FUNCTION q021_show()
    LET g_tna_t.* = g_tna.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_tna.*
    DISPLAY BY NAME g_tna.tna00,g_tna.tna01,g_tna.tna02
    #No.FUN-9A0024--end
END FUNCTION
 
FUNCTION q021_out()
    DEFINE
        l_i             LIKE type_file.num5,          
        l_tna           RECORD LIKE tna_file.*,
        l_name          LIKE type_file.chr20,
        sr RECORD
           tna00 LIKE tna_file.tna00,
           tna01 LIKE tna_file.tna01,
           tna02 LIKE tna_file.tna02
           END RECORD,
        l_za05          LIKE za_file.za05  
    CALL cl_wait()                         
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    DECLARE q021_za_cur CURSOR FOR
        SELECT za02,za05 FROM za_file
        WHERE za01="aooq021" AND za03=g_lang
    FOREACH q021_za_cur INTO g_i,l_za05
        LET g_x[g_i]=l_za05
    END FOREACH
    FOR g_i=1 TO g_len LET g_dash[g_i,g_i]='='
    END FOR
    LET g_sql="SELECT tna00,tna01,tna02 ",
              " FROM tna_file, OUTER(aaa_file)",
              " WHERE aaa_file.aaa01= tna_file.tna02 ",
              "  AND ",g_wc CLIPPED  
    PREPARE q021_p1 FROM g_sql                
    DECLARE q021_curo                         
         CURSOR FOR q021_p1
 
    CALL cl_outnam('aooq021') RETURNING l_name
    START REPORT q021_rep TO l_name
    
    FOREACH q021_curo INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT q021_rep(sr.*)
    END FOREACH    
 
    FINISH REPORT q021_rep
 
    CLOSE q021_curo         
    ERROR "" 
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)         
END FUNCTION  
 
REPORT q021_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,           
        sr RECORD
           tna00 LIKE tna_file.tna00,
           tna01 LIKE tna_file.tna01,
           tna02 LIKE tna_file.tna02
           END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line  
 
    ORDER BY sr.tna00 
    
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            IF sr.tna00 MATCHES 0  THEN
              PRINT COLUMN g_c[31],g_x[34],
                    COLUMN g_c[32],sr.tna01,
                    COLUMN g_c[33],sr.tna02
            ELSE 
              PRINT COLUMN g_c[31],g_x[35],                                                                                                 
                    COLUMN g_c[32],sr.tna01,                                                                                        
                    COLUMN g_c[33],sr.tna02
            END IF 
                       
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
                  g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
                      g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
#No.FUN-750055-----------end------------------
                                                                                                                            
