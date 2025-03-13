# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: anmi004.4gl
# Descriptions...: 銀行對帳單開帳作業
# Date & Author..: No.FUN-B50159 11/06/02 By lutingting
# Modify.........: NO.FUN-B60095 11/06/23 By lutingting 重新过单
# Modify.........: NO.TQC-C40092 12/04/12 By lujh  nai04"期別"增加控管，不可以輸入負數、大于12的數.
 
DATABASE ds                                           
 
GLOBALS "../../config/top.global"      
 
DEFINE g_nai                 RECORD LIKE nai_file.*
DEFINE g_nai_t               RECORD LIKE nai_file.*      #備份舊值
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗 
 
MAIN
    OPTIONS
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("ANM")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE g_nai.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM nai_file WHERE nai08 = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i004_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i004_w WITH FORM "anm/42f/anmi004"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊
 
   LET g_action_choice = ""
   CALL i004_menu()                                         #進入選單 Menu
 
   CLOSE WINDOW i004_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 


FUNCTION i004_curs()

    CLEAR FORM
    INITIALIZE g_nai.* TO NULL   
    CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
        nai01,nai02,nai03,nai04,nai05,nai06,nai07  

        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(nai02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_nai.nai02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nai02
                 NEXT FIELD nai02
 
              OTHERWISE
                 EXIT CASE
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
 

    LET g_sql = "SELECT nai08 FROM nai_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY nai08"
    PREPARE i004_prepare FROM g_sql
    DECLARE i004_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i004_prepare

    LET g_sql = "SELECT COUNT(*) FROM nai_file WHERE ",g_wc CLIPPED
    PREPARE i004_precount FROM g_sql
    DECLARE i004_count CURSOR FOR i004_precount
END FUNCTION
 

FUNCTION i004_menu()
    DEFINE l_cmd    STRING 

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i004_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i004_q()
            END IF

        ON ACTION next
            CALL i004_fetch('N')

        ON ACTION previous
            CALL i004_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i004_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i004_r()
            END IF

 
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i004_fetch('/')

        ON ACTION first
            CALL i004_fetch('F')

        ON ACTION last
            CALL i004_fetch('L')

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
    CLOSE i004_cs
END FUNCTION
 
 
FUNCTION i004_a()
DEFINE l_year     LIKE type_file.chr4
DEFINE l_month    LIKE type_file.chr4
DEFINE l_day      LIKE type_file.chr4
DEFINE l_dt       LIKE type_file.chr20
DEFINE l_time     LIKE type_file.chr20

    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_nai.* LIKE nai_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_nai.nai09 = 'N'
        LET g_nai.nai01 = '1'
        LET g_nai.nai05 = '1'
        CALL i004_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_nai.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        #流水號
        LET l_year = YEAR(g_today) USING '&&&&'
        LET l_month = MONTH(g_today) USING '&&'
        LET l_day = DAY(g_today) USING  '&&'
        LET l_time = TIME(CURRENT)
        LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                     l_time[1,2],l_time[4,5],l_time[7,8]
        SELECT MAX(nai08) + 1 INTO g_nai.nai08 FROM nai_file
         WHERE nai08[1,14] = l_dt
        IF cl_null(g_nai.nai08) THEN
           LET g_nai.nai08 = l_dt,'000001'
        END IF

        IF g_nai.nai08 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_nai.nailegal = g_legal
        INSERT INTO nai_file VALUES(g_nai.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","nai_file",g_nai.nai08,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT nai08 INTO g_nai.nai08 FROM nai_file WHERE nai01 = g_nai.nai08
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i004_i(p_cmd)
   DEFINE l_ze03        LIKE ze_file.ze03
   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_gen02       LIKE gen_file.gen02
   DEFINE l_gen03       LIKE gen_file.gen03
   DEFINE l_gen04       LIKE gen_file.gen04
   DEFINE l_gem02       LIKE gem_file.gem02
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME
      g_nai.nai01,g_nai.nai02,g_nai.nai03,g_nai.nai04,
      g_nai.nai05,g_nai.nai06,g_nai.nai07
 
   INPUT BY NAME
      g_nai.nai01,g_nai.nai02,g_nai.nai03,g_nai.nai04,
      g_nai.nai05,g_nai.nai06,g_nai.nai07
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
 

      AFTER FIELD nai02
         IF g_nai.nai02 IS NOT NULL THEN
            CALL i004_nai02()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('nai02:',g_errno,1)
               DISPLAY BY NAME g_nai.nai02
               NEXT FIELD nai02
            END IF
         END IF

      #TQC-C40092--add--str--
      AFTER FIELD nai04
         IF g_nai.nai04 IS NOT NULL THEN
            IF g_nai.nai04 <= 0 OR g_nai.nai04 >13 THEN 
               CALL cl_err('nai04:','agl-013',1)
               DISPLAY BY NAME g_nai.nai04
               NEXT FIELD nai04
            END IF 
         END IF 
      #TQC-C40092--add--end--      
 
      AFTER FIELD nai06 
         IF g_nai.nai06 IS NOT NULL THEN
            IF g_nai.nai06<0 THEN 
               CALL cl_err('nai06:','axr-029',1)
               DISPLAY BY NAME g_nai.nai06
               NEXT FIELD nai06 
            END IF 
         END IF 
    
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(nai01) THEN
            LET g_nai.* = g_nai_t.*
            CALL i004_show()
            NEXT FIELD nai01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(nai02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nma1"
              LET g_qryparam.default1 = g_nai.nai02
              CALL cl_create_qry() RETURNING g_nai.nai02
              DISPLAY BY NAME g_nai.nai02
              NEXT FIELD nai02
 
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 


FUNCTION i004_nai02()
   DEFINE l_nmaacti  LIKE nma_file.nmaacti
 
   LET g_errno=''
   SELECT nmaacti INTO l_nmaacti FROM nma_file WHERE nma01 = g_nai.nai02
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-013'
       WHEN l_nmaacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION
 


FUNCTION i004_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_nai.* TO NULL    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i004_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i004_count
    FETCH i004_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i004_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nai.nai01,SQLCA.sqlcode,0)
        INITIALIZE g_nai.* TO NULL
    ELSE
        CALL i004_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


 
FUNCTION i004_fetch(p_flnai)
    DEFINE p_flnai         LIKE type_file.chr1
 
    CASE p_flnai
        WHEN 'N' FETCH NEXT     i004_cs INTO g_nai.nai08
        WHEN 'P' FETCH PREVIOUS i004_cs INTO g_nai.nai08
        WHEN 'F' FETCH FIRST    i004_cs INTO g_nai.nai08
        WHEN 'L' FETCH LAST     i004_cs INTO g_nai.nai08
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i004_cs INTO g_nai.nai08
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nai.nai01,SQLCA.sqlcode,0)
        INITIALIZE g_nai.* TO NULL  
        LET g_nai.nai08 = NULL      
        RETURN
    ELSE
      CASE p_flnai
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_nai.* FROM nai_file    # 重讀DB,因TEMP有不被更新特性
       WHERE nai08 = g_nai.nai08
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","nai_file",g_nai.nai08,"",SQLCA.sqlcode,"","",0) 
    ELSE
        CALL i004_show()                   # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i004_show()
    LET g_nai_t.* = g_nai.*
    DISPLAY BY NAME g_nai.nai01,g_nai.nai02,g_nai.nai03,g_nai.nai04,
                    g_nai.nai05,g_nai.nai06,g_nai.nai07
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i004_u()
    IF g_nai.nai08 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_nai.* FROM nai_file WHERE nai08=g_nai.nai08
    IF g_nai.nai09 = 'Y' THEN
       CALL cl_err('','anm-543',0)
       RETURN
    END IF
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i004_cl USING g_nai.nai08
    IF STATUS THEN
       CALL cl_err("OPEN i004_cl:", STATUS, 1)
       CLOSE i004_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i004_cl INTO g_nai.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nai.nai01,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL i004_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i004_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_nai.*=g_nai_t.*
            CALL i004_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE nai_file SET nai_file.* = g_nai.*    # 更新DB
            WHERE nai08 = g_nai.nai08
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","nai_file",g_nai.nai08,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i004_cl
    COMMIT WORK
END FUNCTION

FUNCTION i004_r()
    IF g_nai.nai08 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    IF g_nai.nai09 = 'Y' THEN
       CALL cl_err('','anm-543',0)
       RETURN
    END IF 
    BEGIN WORK
 
    OPEN i004_cl USING g_nai.nai08
    IF STATUS THEN
       CALL cl_err("OPEN i004_cl:", STATUS, 0)
       CLOSE i004_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i004_cl INTO g_nai.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nai.nai01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i004_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "nai08"   
       LET g_doc.value1 = g_nai.nai08 

       CALL cl_del_doc()
       DELETE FROM nai_file WHERE nai08 = g_nai.nai08

       CLEAR FORM
       OPEN i004_count
       FETCH i004_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i004_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i004_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i004_fetch('/')
       END IF
    END IF
    CLOSE i004_cl
    COMMIT WORK
END FUNCTION
#FUN-B50159
#FUN-B60095
