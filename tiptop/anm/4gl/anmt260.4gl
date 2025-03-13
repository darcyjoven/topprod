# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmt260.4gl
# Descriptions...: 銷帳明細資料維護作業 
# Date & Author..: FUN-880073 08/08/20 By Sabrina 
#--FUN-880073 begin--
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nsg            RECORD   LIKE nsg_file.*,   
    g_nsg_t          RECORD   LIKE nsg_file.*   
DEFINE   g_wc                STRING                   #儲存user的查詢資料
DEFINE   g_sql               STRING                   #組sql用
DEFINE   g_forupd_sql         STRING                    #SELECT ... FOR UPDATE SQL 
DEFINE   g_before_input_done  LIKE type_file.num5       #判斷是否已執行 Before Input指令
DEFINE   g_cnt                LIKE type_file.num10          
DEFINE   g_chr                LIKE type_file.chr1     
DEFINE   g_i                  LIKE type_file.num5    
DEFINE   g_msg                LIKE ze_file.ze03     
DEFINE   g_row_count          LIKE type_file.num10      #總筆數
DEFINE   g_curs_index         LIKE type_file.num10      
DEFINE   g_jump               LIKE type_file.num10      #查詢指定的筆數
DEFINE   mi_no_ask            LIKE type_file.num5       #是否開啟指定筆視窗   
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5      
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time          #程式進入時間
    INITIALIZE g_nsg.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM nsg_file WHERE nsg01 = ? AND nsg02 = ? AND nsg03 = ? AND nsg04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t260_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
    LET p_row = 6 LET p_col = 25
 
    OPEN WINDOW anmt260_w AT p_row,p_col
        WITH FORM "anm/42f/anmt260" ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()                                    #轉換介面語言別
 
  
    LET g_action_choice = ""
    CALL t260_menu()
 
    CLOSE WINDOW anmt260_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time         #程式結束時間
END MAIN
 
 
FUNCTION t260_curs()
    CLEAR FORM
 
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           nsg01,nsg02,nsg03,nsg04,nsg05,nsg06,nsg07,nsg08,
           nsg09,nsg10,nsg11
 
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
           ON ACTION about      
              CALL cl_about()     
 
           ON ACTION controlg    
              CALL cl_cmdask()   
 
           ON ACTION qbe_select
              CALL cl_qbe_select()
      
           ON ACTION qbe_save
	      CALL cl_qbe_save()
		
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       
       LET g_sql="SELECT nsg01,nsg02,nsg03,nsg04 FROM nsg_file ", # 組合出 SQL 指令
                 " WHERE ",g_wc CLIPPED,
                 " ORDER BY nsg01,nsg02,nsg03,nsg04"
                 
    PREPARE t260_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t260_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t260_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM nsg_file WHERE ",g_wc CLIPPED
    PREPARE t260_precount FROM g_sql
    DECLARE t260_count CURSOR FOR t260_precount
END FUNCTION
 
 
FUNCTION t260_menu()
   DEFINE l_cmd  LIKE type_file.chr1000   
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
        
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t260_q()
            END IF
 
        ON ACTION next
            CALL t260_fetch('N')
        ON ACTION previous
            CALL t260_fetch('P')
        ON ACTION help
            CALL cl_show_help()
        ON ACTION jump
            CALL t260_fetch('/')
        ON ACTION first
            CALL t260_fetch('F')
        ON ACTION last                         
            CALL t260_fetch('L')
        ON ACTION controlg                     #執行
            CALL cl_cmdask()
        ON ACTION locale                       #切換語言別
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION about                        #程式資訊
           CALL cl_about()      
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145                  #設定視窗右上角〝X〞功能為關閉
           LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU
           
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_nsg.nsg01 IS NOT NULL THEN
                  LET g_doc.column1 = "nsg01"
                  LET g_doc.column2 = "nsg02"
                  LET g_doc.column2 = "nsg03"
                  LET g_doc.column2 = "nsg04"
                  LET g_doc.value1 = g_nsg.nsg01
                  LET g_doc.value2 = g_nsg.nsg02
                  LET g_doc.value1 = g_nsg.nsg03
                  LET g_doc.value2 = g_nsg.nsg04
              CALL cl_doc()                            
              END IF                                        
            END IF                                           
    END MENU
    CLOSE t260_cs
END FUNCTION
 
FUNCTION t260_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t260_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t260_cs                              # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN 
        CALL cl_err(g_nsg.nsg01,SQLCA.sqlcode,0)
        INITIALIZE g_nsg.* TO NULL
    ELSE
        OPEN t260_count
        FETCH t260_COUNT INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t260_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t260_fetch(p_flzx)
    DEFINE
         p_flzx          LIKE type_file.chr1    
 
    CASE p_flzx
        WHEN 'N' FETCH NEXT     t260_cs INTO g_nsg.nsg01,g_nsg.nsg02,g_nsg.nsg03,g_nsg.nsg04
        WHEN 'P' FETCH PREVIOUS t260_cs INTO g_nsg.nsg01,g_nsg.nsg02,g_nsg.nsg03,g_nsg.nsg04
        WHEN 'F' FETCH FIRST    t260_cs INTO g_nsg.nsg01,g_nsg.nsg02,g_nsg.nsg03,g_nsg.nsg04
        WHEN 'L' FETCH LAST     t260_cs INTO g_nsg.nsg01,g_nsg.nsg02,g_nsg.nsg03,g_nsg.nsg04
        WHEN '/'
         IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   
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
         FETCH ABSOLUTE g_jump t260_cs INTO g_nsg.nsg01,g_nsg.nsg02,g_nsg.nsg03,g_nsg.nsg04
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nsg.nsg01,SQLCA.sqlcode,0)
        INITIALIZE g_nsg.* TO NULL                
        RETURN
    ELSE
       CASE p_flzx
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_nsg.* FROM nsg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE nsg01 = g_nsg.nsg01 AND nsg02 = g_nsg.nsg02 AND nsg03 = g_nsg.nsg03 AND nsg04 = g_nsg.nsg04
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","nsg_file",g_nsg.nsg01,g_nsg.nsg02,SQLCA.sqlcode,"","",1)
        INITIALIZE g_nsg.* TO NULL              
    ELSE
        CALL t260_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t260_show()
    LET g_nsg_t.* = g_nsg.*
    DISPLAY BY NAME g_nsg.nsg01,g_nsg.nsg02,g_nsg.nsg03,g_nsg.nsg04,
                    g_nsg.nsg05,g_nsg.nsg06,g_nsg.nsg07,g_nsg.nsg08,
                    g_nsg.nsg09,g_nsg.nsg10,g_nsg.nsg11
    CALL cl_show_fld_cont()                   
END FUNCTION
 
#FUN-880073--end---
#FUN
#FUN
