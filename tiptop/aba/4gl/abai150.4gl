# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: abai150.4gl
# Descriptions...: 製造條碼單別相關資料維護作業
# Date & Author..: No:DEV-CB0005 2012/11/09 By TSD.JIE
# Modify.........: No.DEV-CC0001 2012/12/01 By Mandy 當為雜發單時,要能維護條碼控管方式欄位(smyb01)
# Modify.........: No.DEV-D30025 2013/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No.DEV-D30037 2013/03/21 By TSD.JIE
# 1.條碼控管方式(smyb01)欄位隱藏
# 2.新增欄位:直接調撥是否要做上、下架流程(smyb03)
# 3.asmi300 當系統別"aim",單據性質"4"時,串至abai150 欄位直接調撥是否要做上、下架流程(smyb03)才可異動,否則不可異動僅可顯示,且為"N"
# Modify.........: No.DEV-D40016 2013/04/16 By Mandy 無法更改完工入庫單別欄位


IMPORT os                                                #模組匯入 匯入os package
DATABASE ds                                              #建立與資料庫的連線
 
GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義
GLOBALS "../4gl/barcode.global"
 
DEFINE g_smyb_t              RECORD LIKE smyb_file.*     #備份舊值
DEFINE g_smybslip_t          LIKE smyb_file.smybslip     #Key值備份
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
DEFINE g_argv1               LIKE smyb_file.smybslip     #單別

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
   INITIALIZE g_smyb.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM smyb_file ",
                      " WHERE smybslip = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i150_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i150_w WITH FORM "aba/42f/abai150"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊

   CALL cl_set_comp_visible("smyb01", FALSE)   #DEV-D30037  隱藏smyb01


   LET g_action_choice = ""
   CALL i150_menu()                                         #進入選單 Menu

   CLOSE WINDOW i150_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 


FUNCTION i150_curs()

    CLEAR FORM
    INITIALIZE g_smyb.* TO NULL   
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "smybslip = '",g_argv1,"'"
    ELSE
       CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
           smybslip,smyb01,smyb02
          ,smyb03    #DEV-D30037
   
           BEFORE CONSTRUCT                                    #預設查詢條件
              CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
    
           ON ACTION controlp
              CASE
                 WHEN INFIELD(smybslip)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_smyb01"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO smybslip
                    NEXT FIELD smybslip
                 WHEN INFIELD(smyb02)
                    LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"
                    CALL smy_qry_set_par_where(g_sql)
                    CALL q_smy( TRUE, FALSE,g_smyb.smyb02,'ASF','A')
                       RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO smyb02
                    NEXT FIELD smyb02
    
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
 
    LET g_sql = "SELECT smybslip FROM smyb_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED,
                " ORDER BY smybslip"
    PREPARE i150_prepare FROM g_sql
    DECLARE i150_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i150_prepare

    LET g_sql = "SELECT COUNT(*) FROM smyb_file WHERE ",g_wc CLIPPED
    PREPARE i150_precount FROM g_sql
    DECLARE i150_count CURSOR FOR i150_precount
END FUNCTION
 

FUNCTION i150_menu()
    DEFINE l_cmd    STRING 

    IF NOT cl_null(g_argv1) THEN
       LET g_smyb.smybslip = g_argv1
       DISPLAY BY NAME g_smyb.smybslip

       #看需要顯示該筆、還是新增
       LET g_cnt = 0
       SELECT COUNT(*) INTO g_cnt
         FROM smyb_file
        WHERE smybslip = g_argv1
       IF g_cnt > 0 THEN
          CALL i150_q()
       ELSE
          CALL i150_smybslip('d')
          IF cl_null(g_errno) THEN
             CALL i150_a()
          ELSE
             CALL cl_err('smybslip:',g_errno,1)
          END IF
       END IF
    
       #控制"修改"ACTION
       LET g_cnt = 0
       SELECT COUNT(*) INTO g_cnt
         FROM smyb_file
        WHERE smybslip = g_argv1
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
                 CALL i150_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i150_q()
            END IF

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i150_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i150_r()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION next
            CALL i150_fetch('N')

        ON ACTION previous
            CALL i150_fetch('P')

        ON ACTION jump
            CALL i150_fetch('/')

        ON ACTION first
            CALL i150_fetch('F')

        ON ACTION last
            CALL i150_fetch('L')

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
              IF g_smyb.smybslip IS NOT NULL THEN
                 LET g_doc.column1 = "smybslip"
                 LET g_doc.value1 = g_smyb.smybslip
                 CALL cl_doc()
              END IF
           END IF
    END MENU
    CLOSE i150_cs
END FUNCTION
 
 
FUNCTION i150_a()

    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_smyb.* LIKE smyb_file.*
    LET g_smybslip_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        IF NOT cl_null(g_argv1) THEN
           LET g_smyb.smybslip = g_argv1
           CALL i150_smybslip('d')
        END IF
        LET g_smyb.smyb01 = '1'
        LET g_smyb.smyb03 = 'N'    #DEV-D30037
        CALL i150_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_smyb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_smyb.smybslip IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO smyb_file VALUES(g_smyb.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","smyb_file",g_smyb.smybslip,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        ELSE
            SELECT smybslip INTO g_smyb.smybslip
              FROM smyb_file
             WHERE smybslip = g_smyb.smybslip
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i150_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME
      g_smyb.smybslip,g_smyb.smyb01,g_smyb.smyb02
 
   #畫面全開,以防止畫面被全關而無法進入INPUT
   LET g_before_input_done = FALSE
   CALL i150_set_entry(p_cmd)
   LET g_before_input_done = TRUE

   INPUT BY NAME
      g_smyb.smybslip,g_smyb.smyb01,g_smyb.smyb02
     ,g_smyb.smyb03   #DEV-D30037
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL i150_set_entry(p_cmd)
         CALL i150_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      BEFORE FIELD smybslip
         CALL i150_set_entry(p_cmd)

      AFTER FIELD smybslip
         IF g_smyb.smybslip IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_smyb.smybslip != g_smybslip_t) THEN # 若輸入或更改且改KEY
               SELECT COUNT(*) INTO l_n
                 FROM smyb_file
                WHERE smybslip = g_smyb.smybslip
               IF l_n > 0 THEN
                  CALL cl_err(g_smyb.smybslip,-239,1)
                  LET g_smyb.smybslip = g_smybslip_t
                  DISPLAY BY NAME g_smyb.smybslip
                  NEXT FIELD CURRENT
               END IF
               CALL i150_smybslip(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('smybslip:',g_errno,1)
                  LET g_smyb.smybslip = g_smybslip_t
                  DISPLAY BY NAME g_smyb.smybslip
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF
         CALL i150_set_no_entry(p_cmd)

      BEFORE FIELD smyb01
         CALL i150_set_entry(p_cmd)

      AFTER FIELD smyb01
         CALL i150_set_no_entry(p_cmd)

      BEFORE FIELD smyb02
         CALL i150_set_entry(p_cmd)

      AFTER FIELD smyb02
         IF NOT cl_null(g_smyb.smyb02) THEN
            CALL i150_smyb02()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('smyb02:',g_errno,1)
               NEXT FIELD CURRENT
            END IF
         END IF
         CALL i150_set_no_entry(p_cmd)
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_smyb.smybslip IS NULL THEN
            DISPLAY BY NAME g_smyb.smybslip
            LET l_input='Y'
         END IF
         IF l_input='Y' THEN
            NEXT FIELD smybslip
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(smybslip)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_smy1"
              LET g_qryparam.default1 = g_smyb.smybslip
              CALL cl_create_qry() RETURNING g_smyb.smybslip
              DISPLAY BY NAME g_smyb.smybslip
              NEXT FIELD smybslip
           WHEN INFIELD(smyb02)
              CALL cl_init_qry_var()
              LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"
              CALL smy_qry_set_par_where(g_sql)
              CALL q_smy( FALSE, TRUE,g_smyb.smyb02,'ASF','A')
                 RETURNING g_smyb.smyb02
              DISPLAY BY NAME g_smyb.smyb02
              NEXT FIELD smyb02
 
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
 


#預設g_smy.*
FUNCTION i150_smybslip(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_smydesc  LIKE smy_file.smydesc
 
   LET g_errno=''
   INITIALIZE g_smy.* TO NULL

   SELECT * INTO g_smy.*
     FROM smy_file
    WHERE smyslip = g_smyb.smybslip
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='mfg0014'
                                INITIALIZE g_smy.* TO NULL    
       WHEN g_smy.smyacti='N'   LET g_errno='9028'
       OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY g_smy.smydesc TO smydesc
   END IF
END FUNCTION
 
FUNCTION i150_smyb02()
   DEFINE l_smy      RECORD LIKE smy_file.*
 
   LET g_errno=''
   INITIALIZE l_smy.* TO NULL    

   SELECT * INTO l_smy.*
     FROM smy_file
    WHERE smyslip = g_smyb.smyb02

   CASE
       WHEN SQLCA.sqlcode=100     LET g_errno='aoo-070'
                                  INITIALIZE l_smy.* TO NULL    
       WHEN l_smy.smyacti='N'     LET g_errno='9028'
       WHEN l_smy.smysys <> 'asf' AND l_smy.smykind <> 'A'
                                  LET g_errno='aba-094' #非完工入庫之單別
       OTHERWISE                  LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION


FUNCTION i150_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_smyb.* TO NULL    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i150_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i150_count
    FETCH i150_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i150_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smyb.smybslip,SQLCA.sqlcode,0)
        INITIALIZE g_smyb.* TO NULL
    ELSE
        CALL i150_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


 
FUNCTION i150_fetch(p_flsmyb)
    DEFINE p_flsmyb         LIKE type_file.chr1
 
    CASE p_flsmyb
        WHEN 'N' FETCH NEXT     i150_cs INTO g_smyb.smybslip
        WHEN 'P' FETCH PREVIOUS i150_cs INTO g_smyb.smybslip
        WHEN 'F' FETCH FIRST    i150_cs INTO g_smyb.smybslip
        WHEN 'L' FETCH LAST     i150_cs INTO g_smyb.smybslip
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
            FETCH ABSOLUTE g_jump i150_cs INTO g_smyb.smybslip
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smyb.smybslip,SQLCA.sqlcode,0)
        INITIALIZE g_smyb.* TO NULL  
        LET g_smyb.smybslip = NULL      
        RETURN
    ELSE
      CASE p_flsmyb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_smyb.* FROM smyb_file    # 重讀DB,因TEMP有不被更新特性
       WHERE smybslip = g_smyb.smybslip
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","smyb_file",g_smyb.smybslip,"",SQLCA.sqlcode,"","",0) 
    ELSE
       CALL i150_show()                      # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i150_show()
    LET g_smyb_t.* = g_smyb.*
    DISPLAY BY NAME g_smyb.smybslip,g_smyb.smyb01,g_smyb.smyb02
                   ,g_smyb.smyb03   #DEV-D30037
    CALL i150_smybslip('d')
    CALL cl_show_fld_cont()
END FUNCTION
 


FUNCTION i150_u()
    IF g_smyb.smybslip IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_smyb.* FROM smyb_file
     WHERE smybslip=g_smyb.smybslip

    CALL cl_opmsg('u')
    LET g_smybslip_t = g_smyb.smybslip
    BEGIN WORK
 
    OPEN i150_cl USING g_smyb.smybslip
    IF STATUS THEN
       CALL cl_err("OPEN i150_cl:", STATUS, 1)
       CLOSE i150_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i150_cl INTO g_smyb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_smyb.smybslip,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL i150_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i150_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_smyb.*=g_smyb_t.*
            CALL i150_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE smyb_file SET smyb_file.* = g_smyb.*    # 更新DB
            WHERE smybslip = g_smyb_t.smybslip
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","smyb_file",g_smyb.smybslip,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i150_cl
    COMMIT WORK
END FUNCTION


 
FUNCTION i150_r()
    IF g_smyb.smybslip IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    BEGIN WORK
 
    OPEN i150_cl USING g_smyb.smybslip
    IF STATUS THEN
       CALL cl_err("OPEN i150_cl:", STATUS, 0)
       CLOSE i150_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i150_cl INTO g_smyb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_smyb.smybslip,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i150_show()

    IF cl_delete() THEN
       LET g_doc.column1 = "smybslip"   
       LET g_doc.value1 = g_smyb.smybslip 

       CALL cl_del_doc()
       DELETE FROM smyb_file WHERE smybslip = g_smyb.smybslip

       CLEAR FORM

       OPEN i150_count
       IF STATUS THEN
          CLOSE i150_cl
          CLOSE i150_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i150_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i150_cl
          CLOSE i150_count
          COMMIT WORK
          RETURN
       END IF

       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i150_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i150_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i150_fetch('/')
       END IF
    END IF
    CLOSE i150_cl
    COMMIT WORK
END FUNCTION
 


FUNCTION i150_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("smybslip",TRUE)
   END IF

   CALL cl_set_comp_entry("smyb01",TRUE)
   CALL cl_set_comp_entry("smyb02",TRUE)
   CALL cl_set_comp_entry("smyb03",TRUE) #DEV-D30037
END FUNCTION

 
FUNCTION i150_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("smybslip",FALSE)
   END IF

   IF NOT cl_null(g_argv1) THEN
      CALL cl_set_comp_entry("smybslip",FALSE)
   END IF

   INITIALIZE g_smy.* TO NULL

   SELECT * INTO g_smy.*
     FROM smy_file
    WHERE smyslip = g_smyb.smybslip

   IF NOT cl_null(g_smy.smyslip) AND
      NOT ((g_smy.smysys = 'asf' AND g_smy.smykind = '1') OR     #雜收單aimt302
           (g_smy.smysys = 'aim' AND g_smy.smykind = '2') OR     #工單  asfi301
           (g_smy.smysys = 'aim' AND g_smy.smykind = '4') OR     #調撥單aimt324
           (g_smy.smysys = 'aim' AND g_smy.smykind = '1')) THEN  #雜發單aimt301 #DEV-CC0001 add
      LET g_smyb.smyb01 = '1'
      DISPLAY BY NAME g_smyb.smyb01
      CALL cl_set_comp_entry("smyb01",FALSE)
   END IF

   IF cl_null(g_smy.smyslip) OR
     #(NOT(g_smy.smysys = 'asf' AND g_smy.smykind = '1' AND    #雜收單(aimt302) #DEV-D40016 mark
     #g_smyb.smyb01 MATCHES '[23]')) THEN
      (NOT(g_smy.smysys = 'asf' AND g_smy.smykind = '1')) THEN #雜收單(aimt302) #DEV-D40016 add
      LET g_smyb.smyb02 = ''
      DISPLAY BY NAME g_smyb.smyb02
      CALL cl_set_comp_entry("smyb02",FALSE)
   END IF

   #DEV-D30037--add--begin
   IF cl_null(g_smy.smyslip) OR
      NOT(g_smy.smysys = 'aim' AND g_smy.smykind = '4' )     #調撥單aimt324
      THEN
      CALL cl_set_comp_entry("smyb03",FALSE)
   END IF
   #DEV-D30037--add--end
END FUNCTION
#DEV-CB0005--add
#DEV-D30025--add
