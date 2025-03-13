# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsq821_3.4gl
# Descriptions...: APS鎖定製程時間
# Date & Author..: FUN-840209 08/05/02 BY Duke  
# Modify.........: No.FUN-860060 08/06/19 by duke
# Modify.........: NO.TQC-940098 09/05/08 BY destiny 畫面上沒有cnt這個欄位故在程序中去掉
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vom           RECORD LIKE vom_file.*, #FUN-840209
    g_vom_t         RECORD LIKE vom_file.*, #FUN-840209
    g_vom01         LIKE vom_file.vom01,      
    g_flag          LIKE type_file.chr1,    
    g_wc,g_sql      string  
 
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_msg          LIKE ze_file.ze03  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10   


MAIN
    OPTIONS					#改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
    LET g_vom.vom01  = ARG_VAL(1)
    LET g_vom.vom02  = ARG_VAL(2)
    LET g_vom.vom03  = ARG_VAL(3)
    LET g_vom.vom04  = ARG_VAL(4)
    LET g_vom.vom05  = ARG_VAL(5)
    LET g_vom.vom06  = ARG_VAL(6)
    LET g_vom.vom07  = ARG_VAL(7)

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
    INITIALIZE g_vom.* TO NULL
    INITIALIZE g_vom_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM vom_file WHERE vom01=? AND vom02=? AND vom03=? AND vom04=? AND vom05=? AND vom06=? AND vom07=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i821_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    OPEN WINDOW i821_w WITH FORM "aps/42f/apsq821_3"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    IF g_vom.vom01 IS NOT NULL AND  g_vom.vom01 != ' '
       THEN LET g_flag = 'Y'
            CALL i821_q()
       ELSE LET g_flag = 'N'
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
      CALL i821_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW i821_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i821_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = " vom01='",g_vom.vom01,"' and vom02='",g_vom.vom02,
                 "' and vom03='",g_vom.vom03,"' and vom04='",g_vom.vom04,
                 "' and vom05='",g_vom.vom05,"' and vom06='",g_vom.vom06,
                 "' and vom07='",g_vom.vom07,"'"
    ELSE
    INITIALIZE g_vom.* TO NULL    
    #FUN-860060  add vom01,vom02
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
          vom01,vom02,vom03,vom04,vom05,vom06,vom07,vom08,vom09,vom10,
          vom11,vom12
 
          #No.FUN-840209 --start--     duke
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          #No.FUN-840209 --end--       duke
          #FUN-860060 --start--
           ON ACTION CONTROLP
              CASE
                WHEN INFIELD(vom01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_vod"
                   CALL cl_create_qry() RETURNING g_vom.vom01,g_vom.vom02
                   DISPLAY BY NAME g_vom.vom01,g_vom.vom02
                   NEXT FIELD vom01
              END CASE
          #FUN-860060 --end--          
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
          
          ON ACTION about         
             CALL cl_about()      
          
          ON ACTION help          
             CALL cl_show_help()  
          
          ON ACTION controlg      
             CALL cl_cmdask()     
 
          #No.FUN-840209 --start--     duke
          ON ACTION qbe_select
             CALL cl_qbe_select()
          ON ACTION qbe_save
             CALL cl_qbe_save()
          #No.FUN-840209 --end--       duke
 
       END CONSTRUCT
    END IF
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                                 #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND pmeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                                 #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND pmegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND pmegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmeuser', 'pmegrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT vom01,vom02,vom03,vom04,vom05,vom06,vom07 FROM vom_file ",   # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY vom01,vom02,vom03,vom04,vom05,vom06,vom07"
    PREPARE i821_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i821_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i821_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vom_file WHERE ",g_wc CLIPPED
    PREPARE i821_precount FROM g_sql
    DECLARE i821_count CURSOR FOR i821_precount
END FUNCTION
 
FUNCTION i821_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i821_q()
           END IF
        ON ACTION next
           CALL i821_fetch('N')
        ON ACTION previous
           CALL i821_fetch('P')
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   
#          EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i821_cs
END FUNCTION
 
 
FUNCTION i821_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    #FUN-860060  add vom01,vom02
    DISPLAY BY NAME 
          g_vom.vom01,g_vom.vom02,g_vom.vom03,g_vom.vom04,g_vom.vom05,g_vom.vom06,g_vom.vom07,
          g_vom.vom08,g_vom.vom09,g_vom.vom10,g_vom.vom11,
          g_vom.vom12
 
    INPUT BY NAME   
          g_vom.vom01,g_vom.vom02, g_vom.vom03,g_vom.vom04,g_vom.vom05,g_vom.vom06,g_vom.vom07,
          g_vom.vom08,g_vom.vom09,g_vom.vom10,g_vom.vom11,
          g_vom.vom12
        WITHOUT DEFAULTS
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD vom03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
        
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
    END INPUT
END FUNCTION
 
FUNCTION i821_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
#    DISPLAY '   ' TO FORMONLY.cnt          #No.TQC-940098
    CALL i821_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vom.* TO NULL
        RETURN
    END IF
    OPEN i821_count
    FETCH i821_count INTO g_row_count
#    DISPLAY g_row_count TO FORMONLY.cnt    #No.TQC-940098
    OPEN i821_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vom.vom01,SQLCA.sqlcode,0)
        INITIALIZE g_vom.* TO NULL
    ELSE
        CALL i821_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i821_fetch(p_flpme)
    DEFINE
        p_flpme         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flpme
        WHEN 'N' FETCH NEXT     i821_cs INTO g_vom.vom01,g_vom.vom02,g_vom.vom03,g_vom.vom04,g_vom.vom05,g_vom.vom06,g_vom.vom07
        WHEN 'P' FETCH PREVIOUS i821_cs INTO g_vom.vom01,g_vom.vom02,g_vom.vom03,g_vom.vom04,g_vom.vom05,g_vom.vom06,g_vom.vom07
        WHEN 'F' FETCH FIRST    i821_cs INTO g_vom.vom01,g_vom.vom02,g_vom.vom03,g_vom.vom04,g_vom.vom05,g_vom.vom06,g_vom.vom07
        WHEN 'L' FETCH LAST     i821_cs INTO g_vom.vom01,g_vom.vom02,g_vom.vom03,g_vom.vom04,g_vom.vom05,g_vom.vom06,g_vom.vom07
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
               
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
               
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
            FETCH ABSOLUTE l_abso i821_cs INTO g_vom.vom01,g_vom.vom02,g_vom.vom03,g_vom.vom04,g_vom.vom05,g_vom.vom06,g_vom.vom07
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vom.vom01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_vom.* TO NULL          #No.FUN-6A0163
        RETURN
    ELSE
       CASE p_flpme
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_vom.* FROM vom_file            # 重讀DB,因TEMP有不被更新特性
       WHERE vom01=g_vom.vom01 AND vom02=g_vom.vom02 AND vom03=g_vom.vom03 AND vom04=g_vom.vom04 AND vom05=g_vom.vom05 AND vom06=g_vom.vom06 AND vom07=g_vom.vom07
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vom.vom01 CLIPPED
         CALL cl_err3("sel","vom_file",g_vom.vom01,"",SQLCA.sqlcode,"","",1) 
         INITIALIZE g_vom.* TO NULL       
    ELSE
 
        CALL i821_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i821_show()
    LET g_vom_t.* = g_vom.*
    #FUN-860060  add vom01,vom02
    DISPLAY BY NAME 
          g_vom.vom01,g_vom.vom02, g_vom.vom03,g_vom.vom04,g_vom.vom05,g_vom.vom06,
          g_vom.vom07,g_vom.vom08,g_vom.vom09,g_vom.vom10,
          g_vom.vom11,g_vom.vom12
    CALL cl_show_fld_cont()                   
END FUNCTION
 
 
#Patch....NO.TQC-610036 <> #
