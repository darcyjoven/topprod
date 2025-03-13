# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: awsi006.4gl
# Date & Author..: 07/03/08 By Shine
# Modify.........: 新建立 FUN-8A0122 binbin
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

IMPORT com
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wag       RECORD LIKE wag_file.*,
       g_wag_t     RECORD LIKE wag_file.*,
       g_wag01_t   LIKE wag_file.wag01, 
       g_wc        STRING,            
       g_sql       STRING          
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5       #判斷是否已執行 Before Input指令
DEFINE g_chr                 LIKE type_file.chr1
DEFINE g_cnt                 LIKE type_file.num5
DEFINE g_i                   LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr100
DEFINE g_curs_index          LIKE type_file.num5
DEFINE g_row_count           LIKE type_file.num5        #總筆數
DEFINE g_jump                LIKE type_file.num5        #查詢指定的筆數
DEFINE g_no_ask             LIKE type_file.num5       #是否開啟指定筆視窗   #No.FUN-6A0066
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   INITIALIZE g_wag.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM wag_file WHERE wag01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i006_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i006_w WITH FORM "aws/42f/awsi006"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i006_menu()
 
   CLOSE WINDOW i006_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i006_curs()
DEFINE ls STRING
 
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        wag01,wag02,wag08,wag04,wag17,wag06,wag18,wag09,wag10,
        wag11,wag12,wag07,wag13,wag14,wag15,wag16
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    #資料權限的檢查
#    IF g_priv2='4' THEN                           #只能使用自己的資料
#        LET g_wc = g_wc clipped," AND waguser = '",g_user,"'"
#    END IF
#    IF g_priv3='4' THEN                           #只能使用相同群的資料
#        LET g_wc = g_wc clipped," AND waggrup MATCHES '",
#                   g_grup CLIPPED,"*'"
#    END IF
 
    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND waggrup IN ",cl_chk_tgrup_list()
    END IF
 
    LET g_sql="SELECT wag01 FROM wag_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY wag01"
    PREPARE i006_prepare FROM g_sql
    DECLARE i006_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i006_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM wag_file WHERE ",g_wc CLIPPED
    PREPARE i006_precount FROM g_sql
    DECLARE i006_count CURSOR FOR i006_precount
END FUNCTION
 
FUNCTION i006_menu()
 
   DEFINE l_cmd  LIKE type_file.chr100
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i006_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i006_q()
            END IF
        ON ACTION connection_test
           CALL i006_test()
        ON ACTION next
            CALL i006_fetch('N')
        ON ACTION previous
            CALL i006_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i006_u()
            END IF
#        ON ACTION invalid
#            LET g_action_choice="invalid"
#            IF cl_chk_act_auth() THEN
#                 CALL i006_x()
#            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i006_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i006_copy()
            END IF
#       ON ACTION output
#            LET g_action_choice="output"
#            IF cl_chk_act_auth()
#               THEN CALL i006_out()
#            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
#------------FUN-650190 modify
#        ON ACTION cancel   #No.MOD-470400
#           LET g_action_choice = "exit"
#           EXIT MENU
#------------FUN-650190 end
        ON ACTION jump
            CALL i006_fetch('/')
        ON ACTION first
            CALL i006_fetch('F')
        ON ACTION last
            CALL i006_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document    #No.MOD-470515
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_wag.wag01 IS NOT NULL THEN
                 LET g_doc.column1 = "wag01"
                 LET g_doc.value1 = g_wag.wag01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE i006_cs
END FUNCTION
 
 
FUNCTION i006_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_wag.* LIKE wag_file.*
    LET g_wag01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i006_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_wag.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_wag.wag01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO wag_file VALUES(g_wag.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wag.wag01,SQLCA.sqlcode,0)    #No.FUN-660131
            CALL cl_err3("ins","wag_file",g_wag.wag01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT wag01 INTO g_wag.wag01 FROM wag_file
                     WHERE wag01 = g_wag.wag01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i006_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   LIKE type_file.chr1,
            l_n       LIKE type_file.num5
 
   IF p_cmd ='a' THEN   
      MESSAGE ""
      CLEAR FORM
#      CALL g_wag.clear()
   END IF
 
   DISPLAY BY NAME
      g_wag.wag01,g_wag.wag02,g_wag.wag08,g_wag.wag04,
      g_wag.wag17,g_wag.wag06,g_wag.wag18,g_wag.wag09,
      g_wag.wag10,g_wag.wag11,g_wag.wag12,g_wag.wag07,
      g_wag.wag13,g_wag.wag14,g_wag.wag15,g_wag.wag16
 
   INPUT BY NAME
      g_wag.wag01,g_wag.wag02,g_wag.wag08,g_wag.wag04,
      g_wag.wag17,g_wag.wag06,g_wag.wag18,g_wag.wag09,
      g_wag.wag10,g_wag.wag11,g_wag.wag12,g_wag.wag07,
      g_wag.wag13,g_wag.wag14,g_wag.wag15,g_wag.wag16
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i006_set_entry(p_cmd)
          CALL i006_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
#      AFTER FIELD wag01
#         DISPLAY "AFTER FIELD wag01"
#         IF g_wag.wag01 IS NOT NULL THEN
#            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
#               (p_cmd = "u" AND g_wag.wag01 != g_wag01_t) THEN
#               SELECT count(*) INTO l_n FROM wag_file WHERE wag01 = g_wag.wag01
#               IF l_n > 0 THEN                  # Duplicated
#                  CALL cl_err(g_wag.wag01,-239,1)
#                  LET g_wag.wag01 = g_wag01_t
#                  DISPLAY BY NAME g_wag.wag01
#                  NEXT FIELD wag01
#               END IF
#               CALL i006_wag01('a')
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err('wag01:',g_errno,1)
#                  LET g_wag.wag01 = g_wag01_t
#                  DISPLAY BY NAME g_wag.wag01
#                  NEXT FIELD wag01
#               END IF
#            END IF
#         END IF
 
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_wag.wag01 IS NULL THEN
               DISPLAY BY NAME g_wag.wag01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD wag01
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(wag01) THEN
            LET g_wag.* = g_wag_t.*
            CALL i006_show()
            NEXT FIELD wag01
         END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
END FUNCTION
 
FUNCTION i006_wag01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,
   l_gen02    LIKE gen_file.gen02,
   l_gen03    LIKE gen_file.gen03,
   l_gen04    LIKE gen_file.gen04,
   l_genacti  LIKE gen_file.genacti,
   l_gem02    LIKE gem_file.gem02
 
   LET g_errno=''
   SELECT gen02,gen03,gen04,genacti
     INTO l_gen02,l_gen03,l_gen04,l_genacti
     FROM gen_file
    WHERE gen01=g_wag.wag01
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
 
FUNCTION i006_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i006_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i006_count
    FETCH i006_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i006_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_wag.wag01,SQLCA.sqlcode,0)
        INITIALIZE g_wag.* TO NULL
    ELSE
        CALL i006_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i006_fetch(p_flwag)
    DEFINE
        p_flwag          LIKE type_file.chr1
 
    CASE p_flwag
        WHEN 'N' FETCH NEXT     i006_cs INTO g_wag.wag01
        WHEN 'P' FETCH PREVIOUS i006_cs INTO g_wag.wag01
        WHEN 'F' FETCH FIRST    i006_cs INTO g_wag.wag01
        WHEN 'L' FETCH LAST     i006_cs INTO g_wag.wag01
        WHEN '/'
            IF (NOT g_no_ask) THEN          #No.FUN-6A0066
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
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
            END IF
            FETCH ABSOLUTE g_jump i006_cs INTO g_wag.wag01
            LET g_no_ask = FALSE       #No.FUN-6A0066
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    ELSE
      CASE p_flwag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 #No.FUN-4A0089
    END IF
      
    SELECT * INTO g_wag.* FROM wag_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wag01 = g_wag.wag01
    CALL i006_show()
END FUNCTION
 
FUNCTION i006_show()
    LET g_wag_t.* = g_wag.*
    DISPLAY BY NAME
      g_wag.wag01,g_wag.wag02,g_wag.wag08,g_wag.wag04,
      g_wag.wag17,g_wag.wag06,g_wag.wag18,g_wag.wag09,
      g_wag.wag10,g_wag.wag11,g_wag.wag12,g_wag.wag07,
      g_wag.wag13,g_wag.wag14,g_wag.wag15,g_wag.wag16
    CALL i006_wag01('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i006_u()
    IF g_wag.wag01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_wag.* FROM wag_file WHERE wag01=g_wag.wag01
#    IF g_wag.wagacti = 'N' THEN
#        CALL cl_err('',9027,0) 
#        RETURN
#    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
#    LET g_wag01_t = g_wag.wag01
    BEGIN WORK
 
    OPEN i006_cl USING g_wag.wag01
    IF STATUS THEN
       CALL cl_err("OPEN i006_cl:", STATUS, 1)
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i006_cl INTO g_wag.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_wag.wag01,SQLCA.sqlcode,1)
        RETURN
    END IF
#    LET g_wag.wagmodu=g_user                  #修改者
#    LET g_wag.wagdate = g_today               #修改日期
    CALL i006_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i006_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_wag.*=g_wag_t.*
            CALL i006_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE wag_file SET wag_file.* = g_wag.*    # 更新DB
            WHERE wag01 = g_wag.wag01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wag.wag01,SQLCA.sqlcode,0)  #No.FUN-660131
            CALL cl_err3("upd","wag_file",g_wag.wag01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i006_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i006_x()
    IF g_wag.wag01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i006_cl USING g_wag.wag01
    IF STATUS THEN
       CALL cl_err("OPEN i006_cl:", STATUS, 1)
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i006_cl INTO g_wag.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_wag.wag01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i006_show()
#    IF cl_exp(0,0,g_wag.wagacti) THEN
#        LET g_chr=g_wag.wagacti
#        IF g_wag.wagacti='Y' THEN
#            LET g_wag.wagacti='N'
#        ELSE
#            LET g_wag.wagacti='Y'
#        END IF
#        UPDATE wag_file
#            SET wagacti=g_wag.wagacti
#            WHERE wag01=g_wag.wag01
#        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_wag.wag01,SQLCA.sqlcode,0)
#            LET g_wag.wagacti=g_chr
#        END IF
#        DISPLAY BY NAME g_wag.wagacti
#    END IF
    CLOSE i006_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i006_r()
    IF g_wag.wag01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i006_cl USING g_wag.wag01
    IF STATUS THEN
       CALL cl_err("OPEN i006_cl:", STATUS, 0)
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i006_cl INTO g_wag.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_wag.wag01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i006_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "wag01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_wag.wag01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM wag_file WHERE wag01 = g_wag.wag01
       CLEAR FORM
       OPEN i006_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i006_cs
          CLOSE i006_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i006_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i006_cs
          CLOSE i006_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i006_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i006_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE        #No.FUN-6A0066
          CALL i006_fetch('/')
       END IF
    END IF
    CLOSE i006_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i006_copy()
    DEFINE
        l_newno         LIKE wag_file.wag01,
        l_oldno         LIKE wag_file.wag01,
        p_cmd     LIKE type_file.chr1,
        l_input   LIKE type_file.chr1
 
    IF g_wag.wag01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i006_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM wag01
 
        AFTER FIELD wag01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM wag_file
                  WHERE wag01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD wag01
              END IF
#                  SELECT gen01
#                      FROM gen_file
#                      WHERE gen01= l_newno
#                  IF SQLCA.sqlcode THEN
#                      DISPLAY BY NAME g_wag.wag01
#                      LET l_newno = NULL
#                      NEXT FIELD wag01
#                  END IF
           END IF
 
        ON ACTION controlp                        # 沿用所有欄位
           IF INFIELD(wag01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_wag.wag01
              CALL cl_create_qry() RETURNING l_newno
#              CALL FGL_DIALOG_SETBUFFER( l_newno )
             #DISPLAY BY NAME l_newno                  #TQC-640187 mark
              IF NOT cl_null(l_newno) THEN
              DISPLAY l_newno TO wag01                 #TQC-640187
              END IF
              SELECT gen01
              FROM gen_file
              WHERE gen01= l_newno
              IF SQLCA.sqlcode THEN
                 DISPLAY BY NAME g_wag.wag01
                 LET l_newno = NULL
                 NEXT FIELD wag01
              END IF
              NEXT FIELD wag01
           END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_wag.wag01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM wag_file
        WHERE wag01=g_wag.wag01
        INTO TEMP x
    UPDATE x
        SET wag01=l_newno    #資料鍵值
    INSERT INTO wag_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_wag.wag01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","wag_file",g_wag.wag01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_wag.wag01
        LET g_wag.wag01 = l_newno
        SELECT wag_file.* INTO g_wag.* FROM wag_file
               WHERE wag01 = l_newno
        CALL i006_u()
        #SELECT wag_file.* INTO g_wag.* FROM wag_file  #FUN-C80046
        #       WHERE wag01 = l_oldno                  #FUN-C80046
    END IF
    #LET g_wag.wag01 = l_oldno  #FUN-C80046
    CALL i006_show()
END FUNCTION
 
FUNCTION i006_test()  
 DEFINE l_soapStatus  LIKE type_file.num5,
        l_output      STRING,
        li_cnt1       LIKE ze_file.ze03,
        li_bnt        LIKE ze_file.ze03,
        l_i           LIKE type_file.chr1,
        li_cnt        STRING,
        l_status      LIKE type_file.num5  
 
  IF g_wag.wag01 IS NULL THEN
     CALL cl_err('',-400,0)                                                                                                      
        RETURN                                                                                                                      
  END IF 
 
#  CALL GateWay_g(g_wag.wag01)  RETURNING l_status
 
#  IF l_status = 0 THEN
#  CALL aws_GetObjectList(g_wag.wag01) RETURNING l_status,l_output  
 
   IF l_status =FALSE THEN
     CALL cl_getmsg('aws-097',g_lang) RETURNING li_cnt1                                                                          
         LET l_i = FALSE       
         LET li_cnt = li_cnt1,l_output                                                                                              
         MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")                                          
         ON ACTION  accept
            RETURN                                                                                                                  
            EXIT MENU                                                                                                                  
         END MENU  
   ELSE 
     CALL cl_getmsg('aws-098',g_lang) RETURNING li_cnt
         LET l_i = FALSE
         MENU li_bnt ATTRIBUTE (STYLE='dialog',COMMENT=li_cnt CLIPPED,IMAGE="information") 
         ON ACTION accept
            RETURN
            EXIT MENU
         END MENU
   END IF   
# END IF                                                                                                                                   
END FUNCTION 
 
FUNCTION i006_out()
    DEFINE
        l_i             LIKE type_file.num5,
        l_wag           RECORD LIKE wag_file.*,
        l_gen           RECORD LIKE gen_file.*,
        l_name          LIKE type_file.chr20,           # External(Disk) file name
        sr RECORD
           wag01 LIKE wag_file.wag01,
           wag02 LIKE wag_file.wag02,
           wag06 LIKE wag_file.wag06,
           gen02 LIKE gen_file.gen02,
           gen03 LIKE gen_file.gen03,
           gen04 LIKE gen_file.gen04,
           gem02 LIKE gem_file.gem02
           END RECORD,
        l_za05          LIKE type_file.chr50
 
    #BugNO:4137
    IF g_wc IS NULL THEN LET g_wc=" wag01='",g_wag.wag01,"'" END IF
    #改成印當下的那一筆資料內容
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT wag01,wag02,wag06,gen02,gen03,gen04,gem02 ",
              " FROM wag_file, OUTER(gen_file, OUTER(gem_file)) ",
              " WHERE gen_file.gen01= wag_file.wag01 AND gem_file.gem01 = gen_file.gen03 ",
              "   AND ",g_wc CLIPPED
    {
    IF cl_null(g_wc) THEN
        LET g_sql = g_sql CLIPPED," wag01='",g_wag.wag01,"'"
    ELSE
        LET g_sql = g_sql CLIPPED, " AND ",g_wc CLIPPED
    END IF
    }
 
    PREPARE i006_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i006_curo                         # SCROLL CURSOR
         CURSOR FOR i006_p1
 
    CALL cl_outnam('awsi006') RETURNING l_name
    START REPORT i006_rep TO l_name
 
    FOREACH i006_curo INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT i006_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i006_rep
 
    CLOSE i006_curo
    ERROR ""
     #------------ MOD-530117---------------------------
    #CALL cl_prt(l_name,'g_prtway','g_copies',g_len)
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #-------END----------------------------------
END FUNCTION
 
REPORT i006_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,
        sr RECORD
           wag01 LIKE wag_file.wag01,
           wag02 LIKE wag_file.wag02,
           wag06 LIKE wag_file.wag06,
           gen02 LIKE gen_file.gen02,
           gen03 LIKE gen_file.gen03,
           gen04 LIKE gen_file.gen04,
           gem02 LIKE gem_file.gem02
           END RECORD
   OUTPUT
       TOP MARGIN 0
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN 6
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.wag01
 
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
            PRINT COLUMN g_c[31],sr.wag01,
                  COLUMN g_c[32],sr.gen02,
                  COLUMN g_c[33],sr.gen03,
                  COLUMN g_c[34],sr.gen04,
                  COLUMN g_c[35],cl_numfor(sr.wag06,35,g_azi04)
 
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
 
FUNCTION i006_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("wag01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i006_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
#    IF p_cmd = 'u' AND g_chkey = 'N' THEN
#       CALL cl_set_comp_entry("wag01",FALSE)
#    END IF
END FUNCTION
 
#No.FUN-8A0122
#FUN-B80064
