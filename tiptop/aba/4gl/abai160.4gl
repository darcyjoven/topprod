# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abai160.4gl
# Descriptions...: 銷售單別條碼相關資料維護作業
# Date & Author..: No:DEV-CB0006 2012/11/12 By TSD.JIE
# Modify.........: No.DEV-D30025 2013/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---

IMPORT os                                                #模組匯入 匯入os package
DATABASE ds                                              #建立與資料庫的連線
 
GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義
 
DEFINE g_oayb                RECORD LIKE oayb_file.*
DEFINE g_oayb_t              RECORD LIKE oayb_file.*     #備份舊值
DEFINE g_oaybslip_t          LIKE oayb_file.oaybslip     #Key值備份
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
DEFINE g_argv1               LIKE oayb_file.oaybslip     #單別

MAIN

    OPTIONS
#       FIELD ORDER FORM,                      #依照FORM上面的順序定義做欄位跳動 (預設為依指令順序)
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("ABA")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   LET g_argv1 = ARG_VAL(1)                    #傳入的值,不存在:新增，存在:SHOW

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE g_oayb.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM oayb_file ",
                      " WHERE oaybslip = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i160_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i160_w WITH FORM "aba/42f/abai160"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊


   LET g_action_choice = ""
   CALL i160_menu()                                         #進入選單 Menu

   CLOSE WINDOW i160_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 


FUNCTION i160_curs()

    CLEAR FORM
    INITIALIZE g_oayb.* TO NULL   
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "oaybslip = '",g_argv1,"'"
    ELSE
       CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
           oaybslip,oayb01
   
           BEFORE CONSTRUCT                                    #預設查詢條件
              CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
    
           ON ACTION controlp
              CASE
                 WHEN INFIELD(oaybslip)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oay7"
                    LET g_qryparam.arg1 = "axm"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oaybslip
                    NEXT FIELD oaybslip
                 WHEN INFIELD(oayb01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oay3"
                    LET g_qryparam.arg1 = "50"
                    LET g_qryparam.arg2 = "axm"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oayb01
                    NEXT FIELD oayb01
    
                 OTHERWISE
                    EXIT CASE
              END CASE
    
         ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
            CALL cl_about()  
    
         ON ACTION help                                        #程式說明（每一交談指令皆要加入）
            CALL cl_show_help()  
    
         ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
            CALL cl_cmdask()  
    
         ON ACTION qbe_select                                  #選擇儲存的查詢條件
            CALL cl_qbe_select()
   
         ON ACTION qbe_save                                    #儲存畫面上欄位條件
            CALL cl_qbe_save()
       END CONSTRUCT
    END IF
 
    LET g_sql = "SELECT oaybslip FROM oayb_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED,
                " ORDER BY oaybslip"
    PREPARE i160_prepare FROM g_sql
    DECLARE i160_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i160_prepare

    LET g_sql = "SELECT COUNT(*) FROM oayb_file WHERE ",g_wc CLIPPED
    PREPARE i160_precount FROM g_sql
    DECLARE i160_count CURSOR FOR i160_precount
END FUNCTION
 

FUNCTION i160_menu()
    DEFINE l_cmd    STRING 

    IF NOT cl_null(g_argv1) THEN
       LET g_oayb.oaybslip = g_argv1
       DISPLAY BY NAME g_oayb.oaybslip

       #看需要顯示該筆、還是新增
       LET g_cnt = 0
       SELECT COUNT(*) INTO g_cnt
         FROM oayb_file
        WHERE oaybslip = g_argv1
       IF g_cnt > 0 THEN
          CALL i160_q()
       ELSE
          CALL i160_oaybslip('d')
          IF cl_null(g_errno) THEN
             CALL i160_a()
          ELSE
             CALL cl_err('oaybslip:',g_errno,1)
          END IF
       END IF
    
       #控制"修改"ACTION
       LET g_cnt = 0
       SELECT COUNT(*) INTO g_cnt
         FROM oayb_file
        WHERE oaybslip = g_argv1
       IF g_cnt > 0 THEN
          CALL cl_set_act_visible("modify",TRUE)
       ELSE
          CALL cl_set_act_visible("modify",FALSE)
       END IF
    
       #隱藏ACTION
       CALL cl_set_act_visible("insert,query,delete",FALSE)
    END IF

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i160_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i160_q()
            END IF

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i160_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i160_r()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION next
            CALL i160_fetch('N')

        ON ACTION previous
            CALL i160_fetch('P')

        ON ACTION jump
            CALL i160_fetch('/')

        ON ACTION first
            CALL i160_fetch('F')

        ON ACTION last
            CALL i160_fetch('L')

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
 
        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_oayb.oaybslip IS NOT NULL THEN
                 LET g_doc.column1 = "oaybslip"
                 LET g_doc.value1 = g_oayb.oaybslip
                 CALL cl_doc()
              END IF
           END IF
    END MENU
    CLOSE i160_cs
END FUNCTION
 
 
FUNCTION i160_a()

    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_oayb.* LIKE oayb_file.*
    LET g_oaybslip_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        IF NOT cl_null(g_argv1) THEN
           LET g_oayb.oaybslip = g_argv1
           CALL i160_oaybslip('d')
        END IF
        CALL i160_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_oayb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_oayb.oaybslip IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO oayb_file VALUES(g_oayb.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","oayb_file",g_oayb.oaybslip,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        ELSE
            SELECT oaybslip INTO g_oayb.oaybslip
              FROM oayb_file
             WHERE oaybslip = g_oayb.oaybslip
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i160_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME
      g_oayb.oaybslip,g_oayb.oayb01
 
   INPUT BY NAME
      g_oayb.oaybslip,g_oayb.oayb01
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL i160_set_entry(p_cmd)
         CALL i160_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      BEFORE FIELD oaybslip
         CALL i160_set_entry(p_cmd)

      AFTER FIELD oaybslip
         IF g_oayb.oaybslip IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_oayb.oaybslip != g_oaybslip_t) THEN # 若輸入或更改且改KEY
               SELECT COUNT(*) INTO l_n
                 FROM oayb_file
                WHERE oaybslip = g_oayb.oaybslip
               IF l_n > 0 THEN
                  CALL cl_err(g_oayb.oaybslip,-239,1)
                  LET g_oayb.oaybslip = g_oaybslip_t
                  DISPLAY BY NAME g_oayb.oaybslip
                  NEXT FIELD CURRENT
               END IF
               CALL i160_oaybslip(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('oaybslip:',g_errno,1)
                  LET g_oayb.oaybslip = g_oaybslip_t
                  DISPLAY BY NAME g_oayb.oaybslip
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF
         CALL i160_set_no_entry(p_cmd)

      AFTER FIELD oayb01
         IF NOT cl_null(g_oayb.oayb01) THEN
            CALL i160_oayb01(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('oayb01:',g_errno,1)
               NEXT FIELD CURRENT
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_oayb.oaybslip IS NULL THEN
            DISPLAY BY NAME g_oayb.oaybslip
            LET l_input='Y'
         END IF
         IF l_input='Y' THEN
            NEXT FIELD oaybslip
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(oaybslip)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oay7"
              LET g_qryparam.arg1 = "axm"
              LET g_qryparam.default1 = g_oayb.oaybslip
              CALL cl_create_qry() RETURNING g_oayb.oaybslip
              DISPLAY BY NAME g_oayb.oaybslip
              NEXT FIELD oaybslip
           WHEN INFIELD(oayb01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oay3"
              LET g_qryparam.arg1 = "50"
              LET g_qryparam.arg2 = "axm"
              LET g_qryparam.default1 = g_oayb.oayb01
              CALL cl_create_qry() RETURNING g_oayb.oayb01
              DISPLAY BY NAME g_oayb.oayb01
              NEXT FIELD oayb01
 
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 

FUNCTION i160_oaybslip(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_oay      RECORD LIKE oay_file.*
 
   LET g_errno=''
   INITIALIZE l_oay.* TO NULL

   SELECT * INTO l_oay.*
     FROM oay_file
    WHERE oayslip = g_oayb.oaybslip
   CASE
       WHEN SQLCA.sqlcode=100    LET g_errno='mfg0014'
                                 INITIALIZE l_oay.* TO NULL    
       WHEN l_oay.oayacti='N'    LET g_errno='9028'
       WHEN l_oay.oaysys<>'axm'  LET g_errno='aba-097'
       OTHERWISE                 LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_oay.oaydesc TO oaydesc
   END IF
END FUNCTION
 
FUNCTION i160_oayb01(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_oay      RECORD LIKE oay_file.*
 
   LET g_errno=''
   INITIALIZE l_oay.* TO NULL    

   SELECT * INTO l_oay.*
     FROM oay_file
    WHERE oayslip = g_oayb.oayb01

   CASE
       WHEN SQLCA.sqlcode=100     LET g_errno='aoo-070'
                                  INITIALIZE l_oay.* TO NULL    
       WHEN l_oay.oayacti='N'     LET g_errno='9028'
       WHEN l_oay.oaysys <>'axm'  LET g_errno='aba-097'
       WHEN l_oay.oaytype<>'50'   LET g_errno='aba-098'
       OTHERWISE                  LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_oay.oaydesc TO oaydesc2
   END IF
END FUNCTION


FUNCTION i160_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_oayb.* TO NULL    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i160_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i160_count
    FETCH i160_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i160_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oayb.oaybslip,SQLCA.sqlcode,0)
        INITIALIZE g_oayb.* TO NULL
    ELSE
        CALL i160_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


 
FUNCTION i160_fetch(p_floayb)
    DEFINE p_floayb         LIKE type_file.chr1
 
    CASE p_floayb
        WHEN 'N' FETCH NEXT     i160_cs INTO g_oayb.oaybslip
        WHEN 'P' FETCH PREVIOUS i160_cs INTO g_oayb.oaybslip
        WHEN 'F' FETCH FIRST    i160_cs INTO g_oayb.oaybslip
        WHEN 'L' FETCH LAST     i160_cs INTO g_oayb.oaybslip
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
            FETCH ABSOLUTE g_jump i160_cs INTO g_oayb.oaybslip
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oayb.oaybslip,SQLCA.sqlcode,0)
        INITIALIZE g_oayb.* TO NULL  
        LET g_oayb.oaybslip = NULL      
        RETURN
    ELSE
      CASE p_floayb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_oayb.* FROM oayb_file    # 重讀DB,因TEMP有不被更新特性
       WHERE oaybslip = g_oayb.oaybslip
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","oayb_file",g_oayb.oaybslip,"",SQLCA.sqlcode,"","",0) 
    ELSE
       CALL i160_show()                      # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i160_show()
    LET g_oayb_t.* = g_oayb.*
    DISPLAY BY NAME g_oayb.oaybslip,g_oayb.oayb01
    CALL i160_oaybslip('d')
    CALL i160_oayb01('d')
    CALL cl_show_fld_cont()
END FUNCTION
 


FUNCTION i160_u()
    IF g_oayb.oaybslip IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_oayb.* FROM oayb_file
     WHERE oaybslip=g_oayb.oaybslip

    CALL cl_opmsg('u')
    LET g_oaybslip_t = g_oayb.oaybslip
    BEGIN WORK
 
    OPEN i160_cl USING g_oayb.oaybslip
    IF STATUS THEN
       CALL cl_err("OPEN i160_cl:", STATUS, 1)
       CLOSE i160_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i160_cl INTO g_oayb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oayb.oaybslip,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL i160_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i160_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_oayb.*=g_oayb_t.*
            CALL i160_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE oayb_file SET oayb_file.* = g_oayb.*    # 更新DB
            WHERE oaybslip = g_oayb_t.oaybslip
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","oayb_file",g_oayb.oaybslip,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i160_cl
    COMMIT WORK
END FUNCTION


 
FUNCTION i160_r()
    IF g_oayb.oaybslip IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    BEGIN WORK
 
    OPEN i160_cl USING g_oayb.oaybslip
    IF STATUS THEN
       CALL cl_err("OPEN i160_cl:", STATUS, 0)
       CLOSE i160_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i160_cl INTO g_oayb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oayb.oaybslip,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i160_show()

    IF cl_delete() THEN
       LET g_doc.column1 = "oaybslip"   
       LET g_doc.value1 = g_oayb.oaybslip 

       CALL cl_del_doc()
       DELETE FROM oayb_file WHERE oaybslip = g_oayb.oaybslip

       CLEAR FORM

       OPEN i160_count
       IF STATUS THEN
          CLOSE i160_cl
          CLOSE i160_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i160_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i160_cl
          CLOSE i160_count
          COMMIT WORK
          RETURN
       END IF

       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i160_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i160_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i160_fetch('/')
       END IF
    END IF
    CLOSE i160_cl
    COMMIT WORK
END FUNCTION
 


FUNCTION i160_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("oaybslip",TRUE)
   END IF

   CALL cl_set_comp_entry("oayb01",TRUE)
END FUNCTION

 
FUNCTION i160_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("oaybslip",FALSE)
   END IF

   IF NOT cl_null(g_argv1) THEN
      CALL cl_set_comp_entry("oaybslip",FALSE)
   END IF
END FUNCTION
#DEV-CB0006--add
#DEV-D30025--add
