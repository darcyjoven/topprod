# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: aooi010.4gl
# Descriptions...: 簽核人員
# Date & Author..: 91/04/11 By Lee
# Modify.........: No:MOD-470400 04/07/22 By Nicola 刪除放棄的button
# Note           : 本程式為教育訓練使用單檔標準程式

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_azb                 RECORD LIKE azb_file.*,
       g_azb_t               RECORD LIKE azb_file.*, #備份舊值
       g_azb01_t             LIKE azb_file.azb01,    #Key值備份
       g_wc                  STRING,                 #儲存 user 的查詢條件
       g_sql                 STRING,                 #組 sql 用
       g_azb_rowid           LIKE type_file.chr18    #ROWID使用

DEFINE g_forupd_sql          STRING                  #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done   LIKE type_file.num5     #判斷是否已執行 Before Input指令
DEFINE g_chr                 LIKE type_file.chr1
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10    #總筆數
DEFINE g_jump                LIKE type_file.num10    #查詢指定的筆數
DEFINE mi_no_ask             LIKE type_file.num5     #是否開啟指定筆視窗

MAIN
   DEFINE   p_row,p_col      LIKE type_file.num5

   OPTIONS
       FORM LINE     FIRST + 2,               #畫面開始的位置
       MESSAGE LINE  LAST,                    #訊息顯示的位置
       PROMPT LINE   LAST,                    #提示訊息的位置
       INPUT NO WRAP                          #輸入的方式: 不打轉
   DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                    #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                            #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log         #記錄log檔

   IF (NOT cl_setup("AOO")) THEN              #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                            #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE g_azb.* TO NULL

   LET g_forupd_sql = "SELECT * FROM azb_file WHERE ROWID = ? FOR UPDATE NOWAIT"
   DECLARE i010_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   LET p_row = 5 LET p_col = 10

   OPEN WINDOW i010_w AT p_row,p_col WITH FORM "aoo/42f/aooi010"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)               #介面風格透過p_zz設定

   CALL cl_ui_init()               #轉換介面語言別、匯入ToolBar、Action...等資訊

   LET g_action_choice = ""
   CALL i010_menu()

   CLOSE WINDOW i010_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN

FUNCTION i010_curs()

   CLEAR FORM
   CONSTRUCT BY NAME g_wc ON                                # 螢幕上取條件
      azb01,azb02,azb06,
      azbuser,azbgrup,azbmodu,azbdate,azbacti

      BEFORE CONSTRUCT                                      #預設查詢條件
         CALL cl_qbe_init()

      ON ACTION controlp                                    #欄位開窗
         CASE
            WHEN INFIELD(azb01)
               CALL cl_init_qry_var()                       #動態開窗方式，透過p_qry設定使用
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_azb.azb01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azb01
               NEXT FIELD azb01

            OTHERWISE
               EXIT CASE
         END CASE

      ON IDLE g_idle_seconds                                #Idle控管
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about                                       #程式資訊
         CALL cl_about()

      ON ACTION help                                        #程式說明
         CALL cl_show_help()

      ON ACTION controlg                                    #開啟其他作業
         CALL cl_cmdask()

      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
   END CONSTRUCT

   #資料權限的檢查
   IF g_priv2='4' THEN                                      #只能使用自己的資料
       LET g_wc = g_wc clipped," AND azbuser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                                      #只能使用相同群的資料
       LET g_wc = g_wc clipped," AND azbgrup MATCHES '",
                  g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN                         #相關部門群組維護(p_tgrup)
       LET g_wc = g_wc clipped," AND azbgrup IN ",cl_chk_tgrup_list()
   END IF

   LET g_sql="SELECT ROWID,azb01 FROM azb_file ",           #組合出 SQL 指令
             " WHERE ",g_wc CLIPPED, " ORDER BY azb01"
   PREPARE i010_prepare FROM g_sql
   DECLARE i010_cs                                          #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i010_prepare
   LET g_sql="SELECT COUNT(*) FROM azb_file WHERE ",g_wc CLIPPED
   PREPARE i010_precount FROM g_sql
   DECLARE i010_count CURSOR FOR i010_precount
END FUNCTION

FUNCTION i010_menu()
   DEFINE l_cmd  LIKE type_file.chr1000

   MENU ""
      BEFORE MENU       #預設第一筆、上筆、指定筆、下筆、末一筆五個功能關閉
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i010_a()
         END IF
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i010_q()
         END IF
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i010_u()
         END IF
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i010_x()
         END IF
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i010_r()
         END IF
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         IF cl_chk_act_auth() THEN
            CALL i010_copy()
         END IF
      ON ACTION output
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
            CALL i010_out()
         END IF
      ON ACTION first
         CALL i010_fetch('F')
      ON ACTION previous
         CALL i010_fetch('P')
      ON ACTION jump
         CALL i010_fetch('/')
      ON ACTION next
         CALL i010_fetch('N')
      ON ACTION last
         CALL i010_fetch('L')
      ON ACTION help
         CALL cl_show_help()
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION locale                              #切換語言別
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
      ON ACTION about
         CALL cl_about()
      COMMAND KEY(INTERRUPT)                        #設定視窗右上角"X"功能為關閉
         LET INT_FLAG=FALSE
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION related_document                    #相關文件
        LET g_action_choice="related_document"
        IF cl_chk_act_auth() THEN
           IF g_azb.azb01 IS NOT NULL THEN
              LET g_doc.column1 = "azb01"
              LET g_doc.value1 = g_azb.azb01
              CALL cl_doc()
           END IF
        END IF

   END MENU
   CLOSE i010_cs
END FUNCTION

FUNCTION i010_a()
   MESSAGE ""
   CLEAR FORM                                  # 清螢幕欄位內容
   INITIALIZE g_azb.* LIKE azb_file.*
   LET g_azb01_t = NULL
   LET g_wc = NULL
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_azb.azbuser = g_user
      LET g_azb.azbgrup = g_grup               #使用者所屬群
      LET g_azb.azbdate = g_today
      LET g_azb.azbacti = 'Y'
      CALL i010_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_azb.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
      IF g_azb.azb01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO azb_file VALUES(g_azb.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","azb_file",g_azb.azb01,"",SQLCA.sqlcode,"","",0)
         CONTINUE WHILE
      ELSE
         SELECT ROWID INTO g_azb_rowid FROM azb_file
          WHERE azb01 = g_azb.azb01
      END IF
      EXIT WHILE
   END WHILE
   LET g_wc=' '
END FUNCTION

FUNCTION i010_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   LIKE type_file.chr1,
            l_n       LIKE type_file.num5


   DISPLAY BY NAME
      g_azb.azb01,g_azb.azb02,g_azb.azb06,
      g_azb.azbuser,g_azb.azbgrup,g_azb.azbmodu,
      g_azb.azbdate,g_azb.azbacti

   INPUT BY NAME
      g_azb.azb01,g_azb.azb02,g_azb.azb06,
      g_azb.azbuser,g_azb.azbgrup,g_azb.azbmodu,
      g_azb.azbdate,g_azb.azbacti
      WITHOUT DEFAULTS

      BEFORE INPUT                               #新增時，將Key值(azb01)開放輸入
         LET l_input='N'                         #修改時、視p_zz設定決定是否不可輸入
         LET g_before_input_done = FALSE
         CALL i010_set_entry(p_cmd)
         CALL i010_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD azb01
         DISPLAY "AFTER FIELD azb01"
         IF g_azb.azb01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_azb.azb01 != g_azb01_t) THEN
               SELECT count(*) INTO l_n FROM azb_file WHERE azb01 = g_azb.azb01
               IF l_n > 0 THEN                   # Duplicated
                  CALL cl_err(g_azb.azb01,-239,1)
                  LET g_azb.azb01 = g_azb01_t
                  DISPLAY BY NAME g_azb.azb01
                  NEXT FIELD azb01
               END IF
               CALL i010_azb01('a')              #是否存在基本資料檔檢查
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('azb01:',g_errno,1)
                  LET g_azb.azb01 = g_azb01_t
                  DISPLAY BY NAME g_azb.azb01
                  NEXT FIELD azb01
               END IF
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_azb.azb01 IS NULL THEN
            DISPLAY BY NAME g_azb.azb01
            LET l_input='Y'
         END IF
         IF l_input='Y' THEN
            NEXT FIELD azb01
         END IF

      ON ACTION CONTROLO                         #沿用所有欄位
         IF INFIELD(azb01) THEN
            LET g_azb.* = g_azb_t.*
            CALL i010_show()
            NEXT FIELD azb01
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(azb01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = g_azb.azb01
               CALL cl_create_qry() RETURNING g_azb.azb01
               DISPLAY BY NAME g_azb.azb01
               NEXT FIELD azb01

            OTHERWISE
               EXIT CASE
            END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                         #欄位說明
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

FUNCTION i010_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("azb01",TRUE)
   END IF
END FUNCTION

FUNCTION i010_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("azb01",FALSE)
   END IF
END FUNCTION

FUNCTION i010_azb01(p_cmd)
   DEFINE   p_cmd      LIKE type_file.chr1,
            l_gen02    LIKE gen_file.gen02,
            l_gen03    LIKE gen_file.gen03,
            l_gen04    LIKE gen_file.gen04,
            l_genacti  LIKE gen_file.genacti,
            l_gem02    LIKE gem_file.gem02

   LET g_errno=''
   SELECT gen02,gen03,gen04,genacti
     INTO l_gen02,l_gen03,l_gen04,l_genacti
     FROM gen_file
    WHERE gen01=g_azb.azb01
   CASE
      WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                               LET l_gen02=NULL
                               LET l_gen03=NULL
                               LET l_gen04=NULL
      WHEN l_genacti='N'       LET g_errno='9028'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
      DISPLAY l_gen03 TO FORMONLY.gen03
      DISPLAY l_gen04 TO FORMONLY.gen04
      SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE gem01=l_gen03
      IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
      DISPLAY l_gem02 TO gem02
   END IF
END FUNCTION

FUNCTION i010_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   INITIALIZE g_azb.* TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i010_curs()                      # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN i010_count
   FETCH i010_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN i010_cs                          # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_azb.azb01,SQLCA.sqlcode,0)
      INITIALIZE g_azb.* TO NULL
   ELSE
      CALL i010_fetch('F')               # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION i010_fetch(p_flazb)
   DEFINE   p_flazb   LIKE type_file.chr1

   CASE p_flazb
      WHEN 'N' FETCH NEXT     i010_cs INTO g_azb_rowid,g_azb.azb01
      WHEN 'P' FETCH PREVIOUS i010_cs INTO g_azb_rowid,g_azb.azb01
      WHEN 'F' FETCH FIRST    i010_cs INTO g_azb_rowid,g_azb.azb01
      WHEN 'L' FETCH LAST     i010_cs INTO g_azb_rowid,g_azb.azb01
      WHEN '/'
         IF (NOT mi_no_ask) THEN           #指定筆開窗選擇
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
         FETCH ABSOLUTE g_jump i010_cs INTO g_azb_rowid,g_azb.azb01
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_azb.azb01,SQLCA.sqlcode,0)
      INITIALIZE g_azb.* TO NULL
      LET g_azb_rowid = NULL
      RETURN
   ELSE
      CASE p_flazb                        # 指定目前筆數指標
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
                                          # 重新設定上下筆五個功能鍵的開關
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF

   SELECT * INTO g_azb.* FROM azb_file    # 重讀DB,因TEMP有不被更新特性
    WHERE ROWID = g_azb_rowid
   IF SQLCA.sqlcode THEN                  # 有關SQL的錯誤訊息用cl_err3呈現
      CALL cl_err3("sel","azb_file",g_azb.azb01,"",SQLCA.sqlcode,"","",0)
   ELSE
      LET g_data_owner=g_azb.azbuser      # 權限控管
      LET g_data_group=g_azb.azbgrup
      CALL i010_show()                    # 重新顯示
   END IF
END FUNCTION

FUNCTION i010_show()
   LET g_azb_t.* = g_azb.*
   DISPLAY BY NAME g_azb.*
   CALL i010_azb01('d')
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i010_u()
   IF g_azb.azb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_azb.* FROM azb_file WHERE azb01=g_azb.azb01
   IF g_azb.azbacti = 'N' THEN
      CALL cl_err('',9027,0) 
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_azb01_t = g_azb.azb01

   BEGIN WORK

   OPEN i010_cl USING g_azb_rowid
   IF STATUS THEN
      CALL cl_err("OPEN i010_cl:", STATUS, 1)
      CLOSE i010_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i010_cl INTO g_azb.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_azb.azb01,SQLCA.sqlcode,1)
      CLOSE i010_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_azb.azbmodu=g_user                 # 修改者
   LET g_azb.azbdate = g_today              # 修改日期
   CALL i010_show()                         # 顯示最新資料
   WHILE TRUE
      CALL i010_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_azb.*=g_azb_t.*
         CALL i010_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE azb_file SET azb_file.* = g_azb.*    # 更新DB
       WHERE ROWID = g_azb_rowid
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","azb_file",g_azb.azb01,"",SQLCA.sqlcode,"","",0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i010_cl
   COMMIT WORK
END FUNCTION

FUNCTION i010_x()
   IF g_azb.azb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   BEGIN WORK

   OPEN i010_cl USING g_azb_rowid
   IF STATUS THEN
      CALL cl_err("OPEN i010_cl:", STATUS, 1)
      CLOSE i010_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i010_cl INTO g_azb.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_azb.azb01,SQLCA.sqlcode,1)
      CLOSE i010_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i010_show()
   IF cl_exp(0,0,g_azb.azbacti) THEN
      LET g_chr=g_azb.azbacti
      IF g_azb.azbacti='Y' THEN
          LET g_azb.azbacti='N'
      ELSE
          LET g_azb.azbacti='Y'
      END IF
      UPDATE azb_file SET azbacti=g_azb.azbacti
       WHERE ROWID=g_azb_rowid
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(g_azb.azb01,SQLCA.sqlcode,0)
         LET g_azb.azbacti=g_chr
         DISPLAY BY NAME g_azb.azbacti
         CLOSE i010_cl
         ROLLBACK WORK
         RETURN
      END IF
      DISPLAY BY NAME g_azb.azbacti
   END IF
   CLOSE i010_cl
   COMMIT WORK
END FUNCTION

FUNCTION i010_r()
   IF g_azb.azb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   BEGIN WORK

   OPEN i010_cl USING g_azb_rowid
   IF STATUS THEN
      CALL cl_err("OPEN i010_cl:", STATUS, 0)
      CLOSE i010_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i010_cl INTO g_azb.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_azb.azb01,SQLCA.sqlcode,0)
      CLOSE i010_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i010_show()
   IF cl_delete() THEN
      DELETE FROM azb_file WHERE azb01 = g_azb.azb01
      CLEAR FORM
      OPEN i010_count
      FETCH i010_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i010_cs                              # refresh查詢出來的資料
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i010_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i010_fetch('/')
      END IF
   END IF
   CLOSE i010_cl
   COMMIT WORK
END FUNCTION

FUNCTION i010_copy()
   DEFINE   l_newno   LIKE azb_file.azb01,
            l_oldno   LIKE azb_file.azb01,
            p_cmd     LIKE type_file.chr1,
            l_input   LIKE type_file.chr1

   IF g_azb.azb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET l_input='N'
   LET g_before_input_done = FALSE
   CALL i010_set_entry('a')           #程式內若有可能動態關閉key值輸入的話
   LET g_before_input_done = TRUE     #複製功能要預設key值欄位可輸入
   INPUT l_newno FROM azb01

      AFTER FIELD azb01
         IF l_newno IS NOT NULL THEN
            SELECT count(*) INTO g_cnt FROM azb_file
             WHERE azb01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD azb01
            END IF
            SELECT gen01 FROM gen_file WHERE gen01= l_newno
            IF SQLCA.sqlcode THEN
               DISPLAY BY NAME g_azb.azb01
               LET l_newno = NULL
               NEXT FIELD azb01
            END IF
         END IF

      ON ACTION controlp
         IF INFIELD(azb01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.default1 = g_azb.azb01
            CALL cl_create_qry() RETURNING l_newno
            DISPLAY l_newno TO azb01
            SELECT gen01 FROM gen_file WHERE gen01= l_newno
            IF SQLCA.sqlcode THEN
               DISPLAY BY NAME g_azb.azb01
               LET l_newno = NULL
               NEXT FIELD azb01
            END IF
            NEXT FIELD azb01
         END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_azb.azb01
      RETURN
   END IF
   DROP TABLE x
   SELECT * FROM azb_file
    WHERE ROWID=g_azb_rowid
     INTO TEMP x
   UPDATE x
      SET azb01=l_newno,    #資料鍵值
          azbacti='Y',      #資料有效碼
          azbuser=g_user,   #資料所有者
          azbgrup=g_grup,   #資料所有者所屬群
          azbmodu=NULL,     #資料修改日期
          azbdate=g_today   #資料建立日期
   INSERT INTO azb_file
      SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","azb_file",g_azb.azb01,"",SQLCA.sqlcode,"","",0)
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K'
      LET l_oldno = g_azb.azb01
      LET g_azb.azb01 = l_newno
      SELECT ROWID,azb_file.* INTO g_azb_rowid,g_azb.* FROM azb_file
       WHERE azb01 = l_newno
      CALL i010_u()
      SELECT ROWID,azb_file.* INTO g_azb_rowid,g_azb.* FROM azb_file
       WHERE azb01 = l_oldno
   END IF
   LET g_azb.azb01 = l_oldno
   CALL i010_show()
END FUNCTION

FUNCTION i010_out()     #使用p_zaa列印方式
   DEFINE   l_i         LIKE type_file.num5,
            l_azb       RECORD LIKE azb_file.*,
            l_gen       RECORD LIKE gen_file.*,
            l_name      LIKE type_file.chr20,    # External(Disk) file name
            sr          RECORD
               azb01    LIKE azb_file.azb01,
               azb02    LIKE azb_file.azb02,
               azb06    LIKE azb_file.azb06,
               gen02    LIKE gen_file.gen02,
               gen03    LIKE gen_file.gen03,
               gen04    LIKE gen_file.gen04,
               gem02    LIKE gem_file.gem02
                        END RECORD,
            l_za05      LIKE za_file.za05

   IF g_wc IS NULL THEN LET g_wc=" azb01='",g_azb.azb01,"'" END IF

   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql="SELECT azb01,azb02,azb06,gen02,gen03,gen04,gem02 ",
             " FROM azb_file, OUTER(gen_file, OUTER(gem_file)) ",
             " WHERE gen_file.gen01= azb01 AND gem_file.gem01 = gen_file.gen03 ",
             "   AND ",g_wc CLIPPED
   PREPARE i010_p1 FROM g_sql
   DECLARE i010_curo CURSOR FOR i010_p1

   CALL cl_outnam('aooi010') RETURNING l_name
   START REPORT i010_rep TO l_name

   FOREACH i010_curo INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT i010_rep(sr.*)
   END FOREACH

   FINISH REPORT i010_rep

   CLOSE i010_curo
   ERROR ""
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION

REPORT i010_rep(sr)
   DEFINE   l_trailer_sw   LIKE type_file.chr1,
            sr             RECORD
               azb01       LIKE azb_file.azb01,
               azb02       LIKE azb_file.azb02,
               azb06       LIKE azb_file.azb06,
               gen02       LIKE gen_file.gen02,
               gen03       LIKE gen_file.gen03,
               gen04       LIKE gen_file.gen04,
               gem02       LIKE gem_file.gem02
                           END RECORD
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line

   ORDER BY sr.azb01

   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno=g_pageno+1
         LET pageno_total=PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT g_dash[1,g_len]
         PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
               g_x[35] CLIPPED
         PRINT g_dash1
         LET l_trailer_sw = 'y'

      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.azb01,
               COLUMN g_c[32],sr.gen02,
               COLUMN g_c[33],sr.gen03,
               COLUMN g_c[34],sr.gen04,
               COLUMN g_c[35],cl_numfor(sr.azb06,35,g_azi04)

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
