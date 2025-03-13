# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axmq622.4gl
# Descriptions...: 竄貨舉報查詢處理
# Date & Author..: 10/01/28 By huangrh
# Modify         : 
# Modify.........: No.FUN-A50102 10/06/17 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現

#FUN-9B0160
DATABASE ds
 
GLOBALS "../../config/top.global"  
 
DEFINE g_xsg       RECORD LIKE xsg_file.*,
       g_wc        STRING,                  #儲存 user 的查詢條件          
       g_sql       STRING                  #組 sql 用    
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL        
DEFINE g_argv1               LIKE oea_file.oea01
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_i                   LIKE type_file.num5                  
DEFINE g_msg                 LIKE type_file.chr1000         
DEFINE g_curs_index          LIKE type_file.num10         
DEFINE g_row_count           LIKE type_file.num10         #總筆數        
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        
DEFINE mi_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗        
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-686222 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   LET g_argv1 = ARG_VAL(1)          #參數值(1) Part#
   LET p_row = 4 LET p_col = 2
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_xsg.* TO NULL
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW q622_w AT p_row,p_col WITH FORM "axm/42f/axmq622"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN 
      CALL q622_q()
   END IF
 
   LET g_action_choice = ""
   CALL q622_menu()
 
   CLOSE WINDOW q622_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q622_curs()
DEFINE   l_azw01  LIKE azw_file.azw01
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_xsg.* TO NULL      
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        xsg01,xsg02,xsg03,xsg04,
        xsg05,xsg06,xsg07,xsg08  
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
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
 
    LET g_wc = g_wc CLIPPED
    SELECT azw01 INTO l_azw01 FROM azw_file WHERE azw07=g_plant
    LET g_plant_new = l_azw01
    #CALL s_gettrandbs()              #FUN-A50102
    #LET g_dbs=g_dbs_tra              #FUN-A50102
    #LET g_dbs = s_dbstring(g_dbs)    #FUN-A50102

    #LET g_sql="SELECT xsg01 FROM ",g_dbs CLIPPED,"xsg_file ", # 組合出 SQL 指令
    LET g_sql="SELECT xsg01 FROM ",cl_get_target_table(g_plant_new,'xsg_file'), #FUN-A50102
        " WHERE ",g_wc CLIPPED, " AND xsg03='",g_plant,"'",
        " AND xsg09='1' ORDER BY xsg01"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102		    
    PREPARE q622_prepare FROM g_sql
    DECLARE q622_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q622_prepare
    LET g_sql=
        #"SELECT COUNT(*) FROM ",g_dbs CLIPPED,"xsg_file WHERE ",g_wc CLIPPED,
        "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'xsg_file'), #FUN-A50102
        " WHERE ",g_wc CLIPPED,
        "   AND xsg03='",g_plant,"'"," AND xsg09='1'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102	
    PREPARE q622_precount FROM g_sql
    DECLARE q622_count CURSOR FOR q622_precount
END FUNCTION
 
FUNCTION q622_menu()
   DEFINE l_cmd  LIKE type_file.chr1000         
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL q622_q()
            END IF
        ON ACTION close_case
            LET g_action_choice="close_case"
#            IF cl_chk_act_auth() THEN
                 CALL q622_close()
#            END IF
            
        ON ACTION next
            CALL q622_fetch('N')
        ON ACTION previous
            CALL q622_fetch('P')
        ON ACTION jump
            CALL q622_fetch('/')
        ON ACTION first
            CALL q622_fetch('F')
        ON ACTION last
            CALL q622_fetch('L') 
            
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION close    
            LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU
 
    END MENU
    CLOSE q622_cs
    CLOSE q622_count
END FUNCTION
 
FUNCTION q622_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_xsg.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q622_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN q622_count
    FETCH q622_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q622_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_xsg.xsg01,SQLCA.sqlcode,0)
        INITIALIZE g_xsg.* TO NULL
    ELSE
        CALL q622_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q622_fetch(p_flazb)
    DEFINE
        p_flazb         LIKE type_file.chr1             
 
    CASE p_flazb
        WHEN 'N' FETCH NEXT     q622_cs INTO g_xsg.xsg01
        WHEN 'P' FETCH PREVIOUS q622_cs INTO g_xsg.xsg01
        WHEN 'F' FETCH FIRST    q622_cs INTO g_xsg.xsg01
        WHEN 'L' FETCH LAST     q622_cs INTO g_xsg.xsg01
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
            FETCH ABSOLUTE g_jump q622_cs INTO g_xsg.xsg01
            LET mi_no_ask = FALSE         
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_xsg.xsg01,SQLCA.sqlcode,0)
        INITIALIZE g_xsg.* TO NULL  
        LET g_xsg.xsg01 = NULL      
        RETURN
    ELSE
      CASE p_flazb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
     
    #LET g_sql=" SELECT * FROM ",g_dbs CLIPPED,"xsg_file WHERE xsg01='",g_xsg.xsg01,"' "
    LET g_sql=" SELECT * FROM ",cl_get_target_table(g_plant_new,'xsg_file'), #FUN-A50102
               " WHERE xsg01='",g_xsg.xsg01,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102	   
    PREPARE q622_p1 FROM g_sql
    EXECUTE q622_p1 INTO g_xsg.*

    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","xsg_file",g_xsg.xsg01,"",SQLCA.sqlcode,"","",0)  
    END IF
    CALL q622_show()                   # 重新顯示
END FUNCTION

FUNCTION q622_show()

    DISPLAY BY NAME g_xsg.xsg01,g_xsg.xsg02,g_xsg.xsg03,g_xsg.xsg04,g_xsg.xsg05,
                    g_xsg.xsg06,g_xsg.xsg07,g_xsg.xsg08,g_xsg.xsg09,g_xsg.xsg10
                    
    CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q622_close()
    IF cl_null(g_xsg.xsg01) THEN 
       CALL cl_err("","axm_605",1)
       RETURN   
    END IF
    IF g_xsg.xsg09='2' THEN
       CALL cl_err("","axm_606",1)
       RETURN
    END IF

    INPUT BY NAME g_xsg.xsg10

    #LET g_sql="UPDATE ",g_dbs CLIPPED,"xsg_file SET xsg09='2',xsg10='",g_xsg.xsg10,"'",
    LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'xsg_file'), #FUN-A50102
                " SET xsg09='2',xsg10='",g_xsg.xsg10,"'",
              " WHERE xsg01='",g_xsg.xsg01,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102	          
    PREPARE q622_p2 FROM g_sql
    EXECUTE q622_p2 

    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","xsg_file",g_xsg.xsg10,"",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    LET g_xsg.xsg09='2'
    CALL q622_show()
    CALL cl_show_fld_cont()
END FUNCTION
#FUN-9B0160-----------------END------
