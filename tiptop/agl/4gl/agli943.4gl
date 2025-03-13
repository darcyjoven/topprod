# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: agli943.4gl
# Descriptions...: 現金流量表本期損益期初開帳金額設定(合併)
# Date & Author..: 12/01/09 By Belle(CHI-C40004)

DATABASE ds
#CHI-C40004
GLOBALS "../../config/top.global"  

DEFINE g_giz       RECORD LIKE giz_file.*,
       g_giz_t     RECORD LIKE giz_file.*,  #備份舊值
       g_giz00_t   LIKE giz_file.giz00,     #Key值備份
       g_giz01_t   LIKE giz_file.giz01,     #Key值備份
       g_giz02_t   LIKE giz_file.giz02,     #Key值備份
       g_giz04_t   LIKE giz_file.giz04,     #Key值備份
       g_giz05_t   LIKE giz_file.giz05,     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件
       g_sql       STRING,                  #組 sql 用
       g_axz05     LIKE axz_file.axz05 

DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5 
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10  
DEFINE g_row_count           LIKE type_file.num10         #總筆數      
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數
DEFINE mi_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗 
DEFINE g_delete              LIKE type_file.chr1          #若刪除資料,則要重新顯示筆數
DEFINE g_plant_axz03         LIKE type_file.chr10

MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5

    OPTIONS
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_giz.* TO NULL

   LET g_forupd_sql = "SELECT * FROM giz_file WHERE giz00 = ? AND giz01 = ? AND giz02 = ?"
					 ,"                   AND giz04 = ? AND giz05 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i943_cl CURSOR FROM g_forupd_sql

   LET p_row = 5 LET p_col = 10

   OPEN WINDOW i943_w AT p_row,p_col WITH FORM "agl/42f/agli943"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_delete = 'N'
   LET g_action_choice = ""
   CALL i943_menu()

   CLOSE WINDOW i943_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i943_curs()
DEFINE ls      STRING
   CLEAR FORM
   INITIALIZE g_giz.* TO NULL
   CONSTRUCT g_wc ON giz04,giz05,giz00,giz01,giz02,giz03
      FROM giz04,giz05,giz00,giz01,giz02,giz03
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE
            WHEN INFIELD(giz01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giz00
               NEXT FIELD giz00
            WHEN INFIELD(giz04) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_axa1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giz04
               NEXT FIELD giz04
            WHEN INFIELD(giz05) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_axz"      
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giz05
               NEXT FIELD giz05
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
    IF cl_null(g_wc) THEN
       LET g_wc = " 1=1"
    END IF

    #資料權限的檢查
    IF g_priv2='4' THEN                           #只能使用自己的資料
        LET g_wc = g_wc clipped," AND gizuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET g_wc = g_wc clipped," AND gizgrup MATCHES '",
                   g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND gizgrup IN ",cl_chk_tgrup_list()
    END IF

    LET g_sql="SELECT giz00,giz01,giz02,giz04,giz05 FROM giz_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY giz01"
    PREPARE i943_prepare FROM g_sql
    DECLARE i943_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i943_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM giz_file WHERE ",g_wc CLIPPED
    PREPARE i943_precount FROM g_sql
    DECLARE i943_count CURSOR FOR i943_precount
END FUNCTION

FUNCTION i943_menu()
   DEFINE l_cmd  LIKE type_file.chr1000 
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
                CALL i943_a()
           END IF
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL i943_q()
           END IF
        ON ACTION modify 
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i943_u()
           END IF
        ON ACTION next
            CALL i943_fetch('N')
        ON ACTION previous
            CALL i943_fetch('P')
        ON ACTION delete
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
              CALL i943_r()
           END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i943_fetch('/')
        ON ACTION first
            CALL i943_fetch('F')
        ON ACTION last
            CALL i943_fetch('L')
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

        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU

         ON ACTION related_document    
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_giz.giz01 IS NOT NULL THEN
                 LET g_doc.column1 = "giz01"
                 LET g_doc.value1 = g_giz.giz01
                 CALL cl_doc()
              END IF
           END IF

    END MENU
    CLOSE i943_cs
END FUNCTION


FUNCTION i943_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_giz.* LIKE giz_file.*
    LET g_giz01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i943_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_giz.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_giz.giz01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO giz_file VALUES(g_giz.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","giz_file",g_giz.giz01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        ELSE
            SELECT giz00,giz01,giz02,giz04,giz05
              INTO g_giz.giz00,g_giz.giz01,g_giz.giz02,g_giz.giz04,g_giz.giz05
              FROM giz_file
                     WHERE giz00 = g_giz.giz00 AND giz01 = g_giz.giz01
                       AND giz02 = g_giz.giz02 AND giz04 = g_giz.giz04
                       AND giz05 = g_giz.giz05
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i943_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_input   LIKE type_file.chr1,
            l_n       LIKE type_file.num5,
            l_cnt     LIKE type_file.num5,
            l_n1      LIKE type_file.num5

   DISPLAY BY NAME
      g_giz.giz04,g_giz.giz05,g_giz.giz01,g_giz.giz02,g_giz.giz03,g_giz.giz00
 
   INPUT BY NAME
      g_giz.giz04,g_giz.giz05,g_giz.giz01,g_giz.giz02,g_giz.giz03,g_giz.giz00
      WITHOUT DEFAULTS

      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL i943_set_entry(p_cmd)
         CALL i943_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD giz00
         IF NOT cl_null(g_giz.giz00) THEN
            CALL i943_giz00(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_giz.giz00,g_errno,0)
               NEXT FIELD giz00
            END IF
         END IF

      AFTER FIELD giz02
         IF NOT cl_null(g_giz.giz02) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
             WHERE azm01 = g_giz.giz01
            IF g_azm.azm02 = 1 THEN
               IF g_giz.giz02 > 12 OR g_giz.giz02 < 0 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD giz02
               END IF
            ELSE
               IF g_giz.giz02 > 13 OR g_giz.giz02 < 0 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD giz02
               END IF
            END IF
         END IF

      AFTER FIELD giz04   #族群代號
         IF cl_null(g_giz.giz04) THEN
            CALL cl_err(g_giz.giz04,'mfg0037',0)
            NEXT FIELD giz04
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=g_giz.giz04
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_giz.giz04,'agl-223',0)
               NEXT FIELD giz04
            END IF
         END IF

      AFTER FIELD giz05   #上層公司
         IF NOT cl_null(g_giz.giz05) THEN
            SELECT count(*) INTO l_cnt FROM axa_file
             WHERE axa01 = g_giz.giz04 AND axa02 = g_giz.giz05
            IF l_cnt = 0  THEN
               CALL cl_err(g_giz.giz05,'agl-118',1)
               NEXT FIELD giz05
            END IF
            CALL i943_giz05('a',g_giz.giz05,g_giz.giz04)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_giz.giz05,g_errno,0)
               NEXT FIELD giz05
            END IF
            IF g_giz.giz05 IS NOT NULL AND g_giz.giz04 IS NOT NULL AND
               g_giz.giz00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_giz.giz04 AND axa02=g_giz.giz05
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_giz.giz04 AND axb04=g_giz.giz05
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_giz.giz05,'agl-223',0)
                  LET g_giz.giz04 = g_giz04_t
                  LET g_giz.giz05 = g_giz05_t
                  LET g_giz.giz00 = g_giz00_t
                  DISPLAY BY NAME g_giz.giz04,g_giz.giz05,g_giz.giz00
                  NEXT FIELD giz05
               END IF
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_giz.giz01 IS NULL THEN
            DISPLAY BY NAME g_giz.giz01
            LET l_input='Y'
         END IF
         IF l_input='Y' THEN
            NEXT FIELD aiz01
         END IF
 
     ON ACTION CONTROLO                        # 沿用所有欄位
        IF INFIELD(giz01) THEN
           LET g_giz.* = g_giz_t.*
           CALL i943_show()
           NEXT FIELD giz01
        END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(giz00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               CALL cl_create_qry() RETURNING g_giz.giz00
               DISPLAY g_giz.giz00 TO giz00 
               NEXT FIELD giz00
           WHEN INFIELD(giz04) #族群編號
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_axa1"
              LET g_qryparam.default1 = g_giz.giz04
              CALL cl_create_qry() RETURNING g_giz.giz04
              DISPLAY g_giz.giz04 TO giz04
              NEXT FIELD giz04
           WHEN INFIELD(giz05)  
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_axz"    
              LET g_qryparam.default1 = g_giz.giz05
              CALL cl_create_qry() RETURNING g_giz.giz05
              DISPLAY g_giz.giz05 TO giz05
              NEXT FIELD giz05
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

FUNCTION i943_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_giz.* TO NULL    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i943_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i943_count
    FETCH i943_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i943_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_giz.giz01,SQLCA.sqlcode,0)
        INITIALIZE g_giz.* TO NULL
    ELSE
        CALL i943_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i943_fetch(p_flgiz)
    DEFINE
        p_flgiz         LIKE type_file.chr1

    CASE p_flgiz
        WHEN 'N' FETCH NEXT     i943_cs INTO g_giz.giz00,g_giz.giz01,g_giz.giz02,g_giz.giz04,g_giz.giz05
        WHEN 'P' FETCH PREVIOUS i943_cs INTO g_giz.giz00,g_giz.giz01,g_giz.giz02,g_giz.giz04,g_giz.giz05
        WHEN 'F' FETCH FIRST    i943_cs INTO g_giz.giz00,g_giz.giz01,g_giz.giz02,g_giz.giz04,g_giz.giz05
        WHEN 'L' FETCH LAST     i943_cs INTO g_giz.giz00,g_giz.giz01,g_giz.giz02,g_giz.giz04,g_giz.giz05
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
            FETCH ABSOLUTE g_jump i943_cs INTO g_giz.giz00,g_giz.giz01,g_giz.giz02,g_giz.giz04,g_giz.giz05
            LET mi_no_ask = FALSE   
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_giz.giz01,SQLCA.sqlcode,0)
        INITIALIZE g_giz.* TO NULL  
        RETURN
    ELSE
      CASE p_flgiz
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_giz.* FROM giz_file    # 重讀DB,因TEMP有不被更新特性
       WHERE giz00 = g_giz.giz00 AND giz01 = g_giz.giz01 AND giz02 = g_giz.giz02
         AND giz04 = g_giz.giz04 AND giz05 = g_giz.giz05
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","giz_file",g_giz.giz01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        CALL i943_show()                   # 重新顯示
    END IF
END FUNCTION

FUNCTION i943_show()
    LET g_giz_t.* = g_giz.*
    CALL i943_giz05('d',g_giz.giz05,g_giz.giz04)
    DISPLAY BY NAME g_giz.*
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i943_u()
   IF g_giz.giz01 IS NULL AND g_giz.giz00 IS NULL AND g_giz.giz02 IS NULL
                          AND g_giz.giz04 IS NULL AND g_giz.giz05 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF
   SELECT * INTO g_giz.* FROM giz_file WHERE giz01=g_giz.giz01 AND giz00=g_giz.giz00 AND giz02=g_giz.giz02
                                         AND giz04=g_giz.giz04 AND giz05=g_giz.giz05
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_giz00_t = g_giz.giz00
   LET g_giz01_t = g_giz.giz01
   LET g_giz02_t = g_giz.giz02
   LET g_giz04_t = g_giz.giz04
   LET g_giz05_t = g_giz.giz05
   BEGIN WORK

   OPEN i943_cl USING g_giz00_t,g_giz01_t,g_giz02_t,g_giz04_t,g_giz05_t 
   IF STATUS THEN
      CALL cl_err("OPEN i943_cl:", STATUS, 1)
      CLOSE i943_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i943_cl INTO g_giz.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_giz.giz01,SQLCA.sqlcode,1)
       RETURN
   END IF
   CALL i943_show()                          # 顯示最新資料
   WHILE TRUE
       CALL i943_i("u")                      # 欄位更改
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_giz.*=g_giz_t.*
          CALL i943_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
       UPDATE giz_file SET giz_file.* = g_giz.*    # 更新DB
           WHERE giz00 = g_giz00_t AND giz01 = g_giz01_t AND giz02 = g_giz02_t
             AND giz04 = g_giz04_t AND giz05 = g_giz05_t
       IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","giz_file",g_giz.giz01,"",SQLCA.sqlcode,"","",0)
           CONTINUE WHILE
       END IF
       EXIT WHILE
   END WHILE
   CLOSE i943_cl
   COMMIT WORK
END FUNCTION

FUNCTION i943_r()
    IF g_giz.giz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i943_cl USING g_giz.giz00,g_giz.giz01,g_giz.giz02,g_giz.giz04,g_giz.giz05
    IF STATUS THEN
       CALL cl_err("OPEN i943_cl:", STATUS, 0)
       CLOSE i943_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i943_cl INTO g_giz.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_giz.giz01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i943_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          
        LET g_doc.column1 = "giz01"         
        LET g_doc.value1 = g_giz.giz01      
        CALL cl_del_doc()                                         
       DELETE FROM giz_file WHERE giz00 = g_giz.giz00 AND giz01 = g_giz.giz01 AND giz02 = g_giz.giz02
                              AND giz04 = g_giz.giz04 AND giz05 = g_giz.giz05
       CLEAR FORM
       OPEN i943_count
       FETCH i943_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i943_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i943_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i943_fetch('/')
       END IF
    END IF
    CLOSE i943_cl
    COMMIT WORK
END FUNCTION

FUNCTION i943_giz00(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1
DEFINE   l_aaaacti   LIKE aaa_file.aaaacti
   LET g_errno = ' '
   SELECT aaaacti INTO l_aaaacti FROM aaa_file
    WHERE aaa01 = g_giz.giz00 AND aaaacti = 'Y'

   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-062'
        WHEN l_aaaacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION

FUNCTION i943_set_entry(p_cmd)
  DEFINE   p_cmd     LIKE type_file.chr1
    IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
        CALL cl_set_comp_entry("giz01,giz02,giz04,giz05",TRUE)
    END IF
END FUNCTION

FUNCTION i943_set_no_entry(p_cmd)
  DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("giz01,giz02,giz04,giz05",FALSE)
   END IF
END FUNCTION
FUNCTION  i943_giz05(p_cmd,p_giz05,p_giz04)
DEFINE p_cmd           LIKE type_file.chr1,
       p_giz04         LIKE giz_file.giz04,
       p_giz05         LIKE giz_file.giz05,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05,
       l_aaz641        LIKE aaz_file.aaz641,
       l_axa09         LIKE axa_file.axa09

   LET g_errno = ' '
   SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05
     FROM axz_file
    WHERE axz01 = p_giz05
   CALL s_aaz641_dbs(p_giz04,p_giz05) RETURNING g_plant_axz03
   CALL s_get_aaz641(g_plant_axz03) RETURNING l_aaz641

   SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01 = p_giz05
   LET g_giz.giz00 = l_aaz641
   LET g_axz05 = l_axz05

   CASE
      WHEN SQLCA.SQLCODE=100
         LET g_errno = 'agl-988'
         LET l_axz02 = NULL
         LET l_axz03 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_axz02 TO axz02
      DISPLAY g_giz.giz00 TO giz00
   END IF
END FUNCTION
