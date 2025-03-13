# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: apss304.4gl
# Descriptions...: APS資料庫參數設定(APS)
# Date & Author..: 97/05/21 #FUN-840079 By jamie 
# Modify.........: FUN-910070 09/01/15 by duke  add tiptop soap url
# Modify.........: NO.TQC-940088 09/04/16 BY destiny "WHERE vly07=vzt01" 此處vly07的值應等于g_vzt.vzt01
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: FUN-B50003 11/05/05 By Abby---GP5.25 追版---str------------------------------
# Modify.........: NO.TQC-940114 09/04/20 BY Mandy FUN-930161 加了保留欄位,INSERT INTO 不成功
# Modify.........: NO.FUN-A10142 10/01/28 By Mandy TIPTOP/APS資料庫IP位址異動時,需同步通知APS
# Modify.........: FUN-B50003 11/05/05 By Abby---GP5.25 追版---end------------------------------
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90037 11/09/05 By Abby SOAP網址欄位隱藏 
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-CC0150 13/01/09 By Mandy 傳給APS時增加傳<code9> 此碼傳legal code(法人)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUN-840079
DEFINE g_vzt       RECORD LIKE vzt_file.*,
       g_vzt_t     RECORD LIKE vzt_file.*,  #備份舊值
       g_vzt01_t   LIKE vzt_file.vzt01,     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件  
       g_sql       STRING                   #組 sql 用   
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL        #No.FUN-680102
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        #No.FUN-680102 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000      
DEFINE g_curs_index          LIKE type_file.num10     
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680102 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680102 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗        #No.FUN-680102 SMALLINT  #No.FUN-6A0066
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5       
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_vzt.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM vzt_file WHERE vzt01=? FOR UPDATE "       #TQC-780042 mod
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s304_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW s304_w AT p_row,p_col WITH FORM "aps/42f/apss304"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("vzt05",FALSE)
   CALL cl_set_comp_visible("vzt07",FALSE)  #FUN-B90037 add
 
   LET g_action_choice = ""
   CALL s304_menu()
 
   CLOSE WINDOW s304_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION s304_curs()
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_vzt.* TO NULL   
    CONSTRUCT BY NAME g_wc ON        # 螢幕上取條件
        vzt01,vzt02,vzt03,vzt04,
        vzt07                        #FUN-910070 ADD
 
      #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(vzt01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_vzt.vzt01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vzt01
                 NEXT FIELD vzt01
 
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
 
     #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
     #No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   ##資料權限的檢查
   #IF g_priv2='4' THEN                           #只能使用自己的資料
   #    LET g_wc = g_wc clipped," AND vztuser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                           #只能使用相同群的資料
   #    LET g_wc = g_wc clipped," AND vztgrup MATCHES '",
   #               g_grup CLIPPED,"*'"
   #END IF
 
   #IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #    LET g_wc = g_wc clipped," AND vztgrup IN ",cl_chk_tgrup_list()
   #END IF
 
    LET g_sql="SELECT vzt01 FROM vzt_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, 
              "   AND vzt06='1'",
              " ORDER BY vzt01"
    PREPARE s304_prepare FROM g_sql
    DECLARE s304_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR s304_prepare
    LET g_sql=
              "SELECT COUNT(*) FROM vzt_file ",
              " WHERE ",g_wc CLIPPED,
              "   AND vzt06='1'"
    PREPARE s304_precount FROM g_sql
    DECLARE s304_count CURSOR FOR s304_precount
END FUNCTION
 
FUNCTION s304_menu()
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-780056   
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL s304_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL s304_q()
            END IF
        ON ACTION next
            CALL s304_fetch('N')
        ON ACTION previous
            CALL s304_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL s304_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL s304_r()
            END IF
        #FUN-A10142--add---str---
        ON ACTION update_aps
            LET g_action_choice="update_aps"
            IF cl_chk_act_auth() THEN
                 CALL s304_update_aps()
            END IF
        #FUN-A10142--add---end---
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL s304_fetch('/')
        ON ACTION first
            CALL s304_fetch('F')
        ON ACTION last
            CALL s304_fetch('L')
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
           LET INT_FLAG=FALSE 
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document   
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_vzt.vzt01 IS NOT NULL THEN
                 LET g_doc.column1 = "vzt01"
                 LET g_doc.value1 = g_vzt.vzt01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE s304_cs
END FUNCTION
 
 
FUNCTION s304_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vzt.* LIKE vzt_file.*
    LET g_vzt01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL s304_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_vzt.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_vzt.vzt01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF

        #FUN-910070 MOD --STR--
        #INSERT INTO vzt_file VALUES(g_vzt.vzt01,g_vzt.vzt02,g_vzt.vzt03,g_vzt.vzt04,'N','1')     # DISK WRITE
        #TQC-940114 mod---str-
        #INSERT INTO vzt_file VALUES(g_vzt.vzt01,g_vzt.vzt02,g_vzt.vzt03,g_vzt.vzt04,'N','1',g_vzt.vzt07)
         INSERT INTO vzt_file (vzt01,vzt02,vzt03,vzt04,vzt05,vzt06,vzt07) VALUES(g_vzt.vzt01,g_vzt.vzt02,g_vzt.vzt03,g_vzt.vzt04,'N','1',g_vzt.vzt07)
        #TQC-940114 mod---end-

        #FUN-910070 MOD --END--

        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vzt_file",g_vzt.vzt01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT vzt01 INTO g_vzt.vzt01 FROM vzt_file
                     WHERE vzt01 = g_vzt.vzt01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION s304_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,                                   
            l_azp02   LIKE azp_file.azp02,
            l_input   LIKE type_file.chr1,                                    
            l_n       LIKE type_file.num5                                  
 
 
   DISPLAY BY NAME
      g_vzt.vzt01,g_vzt.vzt02,g_vzt.vzt03,g_vzt.vzt04,
      g_vzt.vzt07   #FUN-910070 ADD
 
   INPUT BY NAME
      g_vzt.vzt01,g_vzt.vzt02,g_vzt.vzt03,g_vzt.vzt04,
      g_vzt.vzt07    #FUN-910070 ADD
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL s304_set_entry(p_cmd)
          CALL s304_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD vzt01
         DISPLAY "AFTER FIELD vzt01"
         IF g_vzt.vzt01 IS NOT NULL THEN
            IF p_cmd = "a" THEN                   # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n 
                 FROM azp_file 
                WHERE azp01 = g_vzt.vzt01
               IF l_n <> 1 THEN                  # Duplicated
                  CALL cl_err(g_vzt.vzt01,'aap-025',1)
                  LET g_vzt.vzt01 = g_vzt01_t
                  DISPLAY BY NAME g_vzt.vzt01
                  NEXT FIELD vzt01
               END IF
               CALL s304_vzt01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('vzt01:',g_errno,1)
                  LET g_vzt.vzt01 = g_vzt01_t
                  DISPLAY BY NAME g_vzt.vzt01
                  NEXT FIELD vzt01
               END IF
            END IF
         END IF
 
      AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT
        END IF
        IF g_vzt.vzt01 IS NULL THEN
           DISPLAY BY NAME g_vzt.vzt01
           LET l_input='Y'
        END IF
        IF l_input='Y' THEN
           NEXT FIELD vzt01
        END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(vzt01) THEN
            LET g_vzt.* = g_vzt_t.*
            CALL s304_show()
            NEXT FIELD vzt01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(vzt01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp2"
              LET g_qryparam.default1 = g_vzt.vzt01
              CALL cl_create_qry() RETURNING g_vzt.vzt01,l_azp02
              DISPLAY g_vzt.vzt01,l_azp02 TO vzt01,azp02 
              NEXT FIELD vzt01
 
           OTHERWISE
              EXIT CASE
           END CASE
 
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
 
      ON ACTION about                    
         CALL cl_about()                 
 
      ON ACTION help                     
         CALL cl_show_help()             
 
   END INPUT
END FUNCTION
 
FUNCTION s304_vzt01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,
   l_azp02    LIKE azp_file.azp02
 
   LET g_errno=''
   SELECT azp02 
     INTO l_azp02
     FROM azp_file
    WHERE azp01=g_vzt.vzt01
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_azp02 TO FORMONLY.azp02
   END IF
END FUNCTION
 
FUNCTION s304_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_vzt.* TO NULL                          
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL s304_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN s304_count
    FETCH s304_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN s304_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vzt.vzt01,SQLCA.sqlcode,0)
        INITIALIZE g_vzt.* TO NULL
    ELSE
        CALL s304_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION s304_fetch(p_flvzt)
    DEFINE
        p_flvzt         LIKE type_file.chr1                                      
 
    CASE p_flvzt
        WHEN 'N' FETCH NEXT     s304_cs INTO g_vzt.vzt01
        WHEN 'P' FETCH PREVIOUS s304_cs INTO g_vzt.vzt01
        WHEN 'F' FETCH FIRST    s304_cs INTO g_vzt.vzt01
        WHEN 'L' FETCH LAST     s304_cs INTO g_vzt.vzt01
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
            FETCH ABSOLUTE g_jump s304_cs INTO g_vzt.vzt01
            LET mi_no_ask = FALSE  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vzt.vzt01,SQLCA.sqlcode,0)
        INITIALIZE g_vzt.* TO NULL             
        RETURN
    ELSE
      CASE p_flvzt
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_vzt.* FROM vzt_file  # 重讀DB,因TEMP有不被更新特性
       WHERE vzt01=g_vzt.vzt01
         AND vzt06 = '1'
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vzt_file",g_vzt.vzt01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        CALL s304_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION s304_show()
    LET g_vzt_t.* = g_vzt.*
    DISPLAY BY NAME g_vzt.vzt01,g_vzt.vzt02,g_vzt.vzt03,g_vzt.vzt04,
                    g_vzt.vzt07   #FUN-910070 ADD
    CALL s304_vzt01('d')
    CALL cl_show_fld_cont()        
END FUNCTION
 
FUNCTION s304_u()
    IF g_vzt.vzt01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_vzt.* FROM vzt_file WHERE vzt01=g_vzt.vzt01
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vzt01_t = g_vzt.vzt01
    BEGIN WORK
 
    OPEN s304_cl USING g_vzt.vzt01
    IF STATUS THEN
       CALL cl_err("OPEN s304_cl:", STATUS, 1)
       CLOSE s304_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s304_cl INTO g_vzt.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vzt.vzt01,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL s304_show()                          # 顯示最新資料
    WHILE TRUE
        CALL s304_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vzt.*=g_vzt_t.*
            CALL s304_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vzt_file SET vzt_file.* = g_vzt.*    # 更新DB
            WHERE vzt01=g_vzt01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vzt_file",g_vzt.vzt01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE s304_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s304_x()
    IF g_vzt.vzt01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN s304_cl USING g_vzt.vzt01
    IF STATUS THEN
       CALL cl_err("OPEN s304_cl:", STATUS, 1)
       CLOSE s304_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s304_cl INTO g_vzt.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vzt.vzt01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL s304_show()
    CLOSE s304_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s304_r()
DEFINE l_i LIKE type_file.num5
 
    IF g_vzt.vzt01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
   #若多廠區設定已有資料庫設定資料,則不允許刪除
   #SELECT COUNT(*) INTO l_i FROM vly_file WHERE vly07=vzt01              #No.TQC-940088
    SELECT COUNT(*) INTO l_i FROM vly_file WHERE vly07=g_vzt.vzt01              #No.TQC-940088
    IF l_i != 0 THEN 
       CALL cl_err(g_vzt.vzt01,'aps-010',0)
       RETURN
    END IF 
    BEGIN WORK 
 
    OPEN s304_cl USING g_vzt.vzt01
    IF STATUS THEN
       CALL cl_err("OPEN s304_cl:", STATUS, 0)
       CLOSE s304_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s304_cl INTO g_vzt.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vzt.vzt01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL s304_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vzt01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vzt.vzt01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM vzt_file WHERE vzt01 = g_vzt.vzt01
       CLEAR FORM
       OPEN s304_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE s304_cs
          CLOSE s304_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH s304_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE s304_cs
          CLOSE s304_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN s304_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL s304_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                 #No.FUN-6A0066
          CALL s304_fetch('/')
       END IF
    END IF
    CLOSE s304_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s304_copy()
    DEFINE
        l_newno         LIKE vzt_file.vzt01,
        l_oldno         LIKE vzt_file.vzt01,
        p_cmd     LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
        l_input   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)  
 
    IF g_vzt.vzt01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL s304_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM vzt01
 
        ON ACTION controlp                        # 沿用所有欄位
           IF INFIELD(vzt01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_vzt.vzt01
              CALL cl_create_qry() RETURNING l_newno
              DISPLAY l_newno TO vzt01                 #TQC-640187
              SELECT gen01
              FROM gen_file
              WHERE gen01= l_newno
              IF SQLCA.sqlcode THEN
                 DISPLAY BY NAME g_vzt.vzt01
                 LET l_newno = NULL
                 NEXT FIELD vzt01
              END IF
              NEXT FIELD vzt01
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
       DISPLAY BY NAME g_vzt.vzt01
       RETURN
    END IF
    DROP TABLE x
    SELECT * FROM vzt_file
        WHERE vzt01=g_vzt.vzt01
        INTO TEMP x
    UPDATE x
        SET vzt01=l_newno     #資料鍵值
    INSERT INTO vzt_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","vzt_file",g_vzt.vzt01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_vzt.vzt01
        LET g_vzt.vzt01 = l_newno
        SELECT vzt_file.* INTO g_vzt.* FROM vzt_file
               WHERE vzt01 = l_newno
        CALL s304_u()
        #SELECT vzt_file.* INTO g_vzt.* FROM vzt_file  #FUN-C80046
        #       WHERE vzt01 = l_oldno                  #FUN-C80046
    END IF
    #LET g_vzt.vzt01 = l_oldno                         #FUN-C80046
    CALL s304_show()
END FUNCTION
 
FUNCTION s304_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1     
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("vzt01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION s304_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1      
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("vzt01",FALSE)
    END IF
 
END FUNCTION

#FUN-A10142---add---str---
FUNCTION s304_update_aps()
 DEFINE l_ze03   LIKE ze_file.ze03
 DEFINE l_vzv03  DATETIME YEAR TO SECOND
 DEFINE l_dbs    STRING
 DEFINE l_legal  LIKE azw_file.azw02  #FUN-CC0150 add

    IF g_vzt.vzt01 IS NULL THEN
        CALL cl_err('',-400,1)
        RETURN
    END IF
    LET l_vzv03 = CURRENT YEAR TO SECOND
    CALL cl_getmsg('aps-041',g_lang) RETURNING l_ze03 #IP位址調整
    IF cl_confirm('aps-040') THEN #確定將異動後資料更新至APS?
        LET g_plant_new=g_vzt.vzt01
        CALL s_getdbs()
        LET l_dbs=g_dbs_new
        LET g_sql = "INSERT INTO ",l_dbs CLIPPED,"vzv_file",
                    "(vzv00,vzv01,vzv02,vzv03,vzv04,",
                    " vzv05,vzv06,vzv07,vzv08,vzvplant,vzvlegal)",
                    "VALUES(?,?,?,?,?,",
                    "       ?,?,?,?,?,?) "
        PREPARE s304_ins_vzv_p FROM g_sql
        EXECUTE s304_ins_vzv_p USING g_vzt.vzt01,'sync','0',l_vzv03,'00',
                                     l_ze03,'R','Y',g_user,g_plant,g_legal
        IF STATUS THEN
            CALL cl_err3("ins","vzv_file",g_vzt.vzt01,'sync',STATUS,"","",1)
            RETURN
        END IF
        
        #FUN-CC0150--add----str--
        #(抓出該營運中心所屬法人)
        LET l_legal=''
        SELECT azw02 INTO l_legal 
          FROM azw_file
         WHERE azw01 = g_vzt.vzt01 
        #FUN-CC0150--add----end--
        LET g_msg = "apsp600 'erp_sync' ",
                     "'",g_vzt.vzt01 CLIPPED,"' ",
                                            "'' ",
                     "'",g_vzt.vzt02 CLIPPED,"' ",
                     "'",g_vzt.vzt02 CLIPPED,"' ",
                     "'",g_vzt.vzt03 CLIPPED,"' ",
                     "'",g_vzt.vzt04 CLIPPED,"' ",
                                      "'ssissync'",
                                      " '' ",       #FUN-CC0150 add
                     "'",l_legal,"'"                #FUN-CC0150 add
                                      
        CALL cl_cmdrun_wait(g_msg CLIPPED)
    END IF
END FUNCTION
#FUN-A10142---add---end---
#FUN-B50003
