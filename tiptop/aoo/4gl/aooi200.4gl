# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aooi200.4gl
# Descriptions...: 專案名稱資料維護作業
# Date & Author..: 91/07/12 By LANLY
# Release 4.0....: 92/07/24 By Jones
# Modify.........: 2000/01/06 By Carol:add gja05,gja06,gja07,gja08
# Modify.........: 2000/02/09 By Carol: form 去除 gja05,gja06,gja07,gja08
#                                     : gja05,gja06,gja07,gja08 --> no use
# Modify.........: No.MOD-480241 04/08/10 By Nicola 更改資料後，複製有問題
#                                                   開始日期不可大於結束日期
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4C0044 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510027 05/01/14 By pengu 報表轉XML
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0015 06/10/25 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6C0163 06/12/26 By day 資料無效后再修改，報錯信息有誤
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_gja   RECORD LIKE gja_file.*,
    g_gja_t RECORD LIKE gja_file.*,
    g_gja_o RECORD LIKE gja_file.*,
    g_gja01_t LIKE gja_file.gja01,
    g_wc,g_sql          STRING      #NO.TQC-630166        
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL      
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680102 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680102CHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680102 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680102 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680102 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680102 SMALLINT

MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680102 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0081
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
    INITIALIZE g_gja.* TO NULL
    INITIALIZE g_gja_t.* TO NULL
    INITIALIZE g_gja_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM gja_file WHERE gja01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 6 LET p_col = 10
    OPEN WINDOW i200_w AT p_row,p_col
        WITH FORM "aoo/42f/aooi200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i200_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i200_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION i200_curs()
    CLEAR FORM
   INITIALIZE g_gja.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        gja01,gja02,gja03,gja04,gjauser,gjagrup,gjamodu,gjadate,gjaacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND gjauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND gjagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND gjagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gjauser', 'gjagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT gja01 FROM gja_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY gja01"
    PREPARE i200_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i200_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i200_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM gja_file WHERE ",g_wc CLIPPED
    PREPARE i200_precount FROM g_sql
    DECLARE i200_count CURSOR FOR i200_precount
END FUNCTION
 
FUNCTION i200_menu()
    MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i200_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i200_q()
            END IF
        ON ACTION next
            CALL i200_fetch('N')
        ON ACTION previous
            CALL i200_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i200_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i200_x()
            END IF
            CALL cl_set_field_pic("","","","","",g_gja.gjaacti)
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i200_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i200_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL i200_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_gja.gjaacti)
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i200_fetch('/')
        ON ACTION first
            CALL i200_fetch('F')
        ON ACTION last
            CALL i200_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION related_document    #No.MOD-470515
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_gja.gja01 IS NOT NULL THEN
                 LET g_doc.column1 = "gja01"
                 LET g_doc.value1 = g_gja.gja01
                 CALL cl_doc()
              END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i200_cs
END FUNCTION
 
 
FUNCTION i200_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_gja.* LIKE gja_file.*
    LET g_gja01_t = NULL
    LET g_gja_t.*=g_gja.*
    LET g_gja_o.*=g_gja.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_gja.gjaacti ='Y'                   #有效的資料
        LET g_gja.gjauser = g_user
        LET g_gja.gjaoriu = g_user #FUN-980030
        LET g_gja.gjaorig = g_grup #FUN-980030
        LET g_gja.gjagrup = g_grup               #使用者所屬群
        LET g_gja.gjadate = today
        CALL i200_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_gja.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_gja.gja01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO gja_file VALUES(g_gja.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("ins","gja_file",g_gja.gja01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        ELSE
            LET g_gja_t.* = g_gja.*                # 保存上筆資料
            LET g_gja_o.* = g_gja.*                # 保存上筆資料
            SELECT gja01 INTO g_gja.gja01 FROM gja_file
                WHERE gja01 = g_gja.gja01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i200_i(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
            l_n     LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
 
   DISPLAY BY NAME g_gja.gjauser,g_gja.gjagrup, g_gja.gjadate, g_gja.gjaacti
   INPUT BY NAME g_gja.gjaoriu,g_gja.gjaorig,g_gja.gja01,g_gja.gja02,g_gja.gja03,g_gja.gja04 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i200_set_entry(p_cmd)
         CALL i200_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD gja01
       IF g_gja.gja01 IS NOT NULL THEN
         IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
            (p_cmd = "u" AND g_gja.gja01 != g_gja01_t) THEN
            SELECT count(*) INTO l_n FROM gja_file WHERE gja01 = g_gja.gja01
            IF l_n > 0 THEN                  # Duplicated
               CALL cl_err(g_gja.gja01,-239,0)
               LET g_gja.gja01 = g_gja01_t
               DISPLAY BY NAME g_gja.gja01
               NEXT FIELD gja01
            END IF
         END IF
       END IF
 
       AFTER FIELD gja03     #No.MOD-480241
         IF NOT cl_null(g_gja.gja04) THEN
            IF g_gja.gja04 < g_gja.gja03 THEN
               CALL cl_err(g_gja.gja03,'apj-018',0)
               LET g_gja.gja03 = g_gja_o.gja03
               DISPLAY BY NAME g_gja.gja03
               NEXT FIELD gja03
            END IF
         END IF
 
      AFTER FIELD gja04
         IF g_gja.gja04 < g_gja.gja03 THEN
            CALL cl_err(g_gja.gja04,'apj-018',0)
            LET g_gja.gja04 = g_gja_o.gja04
            DISPLAY BY NAME g_gja.gja04
            NEXT FIELD gja04
         END IF
 
        #MOD-650015 --start 
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(gja01) THEN
      #      LET g_gja.* = g_gja_t.*
      #      DISPLAY BY NAME g_gja.*
      #      NEXT FIELD gja01
      #   END IF
        #MOD-650015 --start 
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
 
 
FUNCTION i200_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gja.* TO NULL               #No.FUN-6A0015  
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i200_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i200_count
    FETCH i200_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0)
        INITIALIZE g_gja.* TO NULL
    ELSE
        CALL i200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i200_fetch(p_flgja)
    DEFINE
        p_flgja         LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
        l_abso          LIKE type_file.num10         #No.FUN-680102 INTEGER
 
    CASE p_flgja
        WHEN 'N' FETCH NEXT     i200_cs INTO g_gja.gja01
        WHEN 'P' FETCH PREVIOUS i200_cs INTO g_gja.gja01
        WHEN 'F' FETCH FIRST    i200_cs INTO g_gja.gja01
        WHEN 'L' FETCH LAST     i200_cs INTO g_gja.gja01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i200_cs INTO g_gja.gja01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0)
        INITIALIZE g_gja.* TO NULL  #TQC-6B0105
        LET g_gja.gja01 = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flgja
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_gja.* FROM gja_file            # 重讀DB,因TEMP有不被更新特性
       WHERE gja01 = g_gja.gja01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("sel","gja_file",g_gja.gja01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
    ELSE                                      #FUN-4C0044權限控管
       LET g_data_owner = g_gja.gjauser
       LET g_data_group = g_gja.gjagrup
        CALL i200_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i200_show()
    LET g_gja_t.* = g_gja.*
    LET g_gja_o.* = g_gja.*
    DISPLAY BY NAME g_gja.gja01,g_gja.gja02,g_gja.gja03,g_gja.gja04, g_gja.gjaoriu,g_gja.gjaorig,
                    g_gja.gjauser,g_gja.gjagrup,g_gja.gjamodu,g_gja.gjadate,
                    g_gja.gjaacti
   CALL cl_set_field_pic("","","","","",g_gja.gjaacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i200_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_gja.gja01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_gja.* FROM gja_file WHERE gja01=g_gja.gja01
    IF g_gja.gjaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_gja.gja01,'9027',0)   #No.TQC-6C0163
#       CALL cl_err(g_gja.gja01,'aoo-000',0)   #No.TQC-6C0163
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gja01_t = g_gja.gja01
    BEGIN WORK
 
    OPEN i200_cl USING g_gja.gja01
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_gja.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_gja.gjamodu=g_user                     #修改者
    LET g_gja.gjadate = today                  #修改日期
    CALL i200_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i200_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gja.*=g_gja_t.*
            CALL i200_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE gja_file SET gja_file.* = g_gja.*    # 更新DB
            WHERE gja01 = g_gja.gja01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","gja_file",g_gja.gja01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i200_x()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gja.gja01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i200_cl USING g_gja.gja01
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_gja.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0) RETURN END IF
    CALL i200_show()
    IF cl_exp(0,0,g_gja.gjaacti) THEN
        LET g_chr=g_gja.gjaacti
        IF g_gja.gjaacti='Y'
           THEN LET g_gja.gjaacti='N'
           ELSE LET g_gja.gjaacti='Y'
        END IF
        UPDATE gja_file
            SET gjaacti=g_gja.gjaacti,
               gjamodu=g_user, gjadate=g_today
            WHERE gja01=g_gja.gja01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","gja_file",g_gja.gja01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            LET g_gja.gjaacti=g_chr
        END IF
        DISPLAY BY NAME g_gja.gjaacti
    END IF
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i200_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gja.gja01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i200_cl USING g_gja.gja01
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_gja.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0) RETURN END IF
    CALL i200_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gja01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gja.gja01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM gja_file WHERE gja01=g_gja.gja01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0)   #No.FUN-660131
           CALL cl_err3("del","gja_file",g_gja.gja01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        ELSE
           CLEAR FORM
           OPEN i200_count
           #FUN-B50063-add-start--
           IF STATUS THEN
              CLOSE i200_cs
              CLOSE i200_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end-- 
           FETCH i200_count INTO g_row_count
           #FUN-B50063-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i200_cs
              CLOSE i200_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i200_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i200_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET g_no_ask = TRUE
              CALL i200_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i200_copy()
    DEFINE
        l_n             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_newno         LIKE gja_file.gja01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gja.gja01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
     #-----No.MOD-480241-----
    LET g_before_input_done = FALSE
    CALL i200_set_entry("a")
    LET g_before_input_done = TRUE
    #-----END---------------
 
    INPUT l_newno FROM gja01
        AFTER FIELD gja01
          IF l_newno IS NOT NULL THEN
            SELECT count(*) INTO g_cnt FROM gja_file
                WHERE gja01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD gja01
            END IF
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
        DISPLAY BY NAME g_gja.gja01
        RETURN
    END IF
    SELECT * FROM gja_file
        WHERE gja01=g_gja.gja01
        INTO TEMP x
    UPDATE x
        SET gja01=l_newno,    #資料鍵值
            gjauser=g_user,   #資料所有者
            gjagrup=g_grup,   #資料所有者所屬群
            gjamodu=NULL,     #資料修改日期
            gjadate=today,  #資料建立日期
            gjaacti='Y'       #有效資料
    INSERT INTO gja_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_gja.gja01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","gja_file",g_gja.gja01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET g_gja.gja01 = l_newno  #FUN-C80046
    END IF
    DROP TABLE x
    DISPLAY BY NAME g_gja.gja01
END FUNCTION
 
FUNCTION i200_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("gja01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("gja01",FALSE)
    END IF
 
END FUNCTION
 
#No.FUN-7C0043--start--
 FUNCTION i200_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE za_file.za05,            #No.FUN-680102 VARCHAR(40)
        l_chr           LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
    DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                 
    IF cl_null(g_wc) AND NOT cl_null(g_gja.gja01)                                                                                   
       THEN LET g_wc=" gja01='",g_gja.gja01,"'"                                                                                     
    END IF                                                                                                                          
    IF g_wc IS NULL THEN                                                                                                            
        CALL cl_err('','9057',0)                                                                                                    
        RETURN                                                                                                                      
    END IF                                                                                                                          
    LET l_cmd = 'p_query "aooi200" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN 
#   IF cl_null(g_wc) THEN LET g_wc=" gja01='",g_gja.gja01,"'" END IF
 
#   IF g_wc IS NULL THEN
#       CALL cl_err('','9057',0)
#       RETURN
#   END IF
#   CALL cl_wait()
#   CALL cl_outnam('aooi200') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM gja_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED
#   PREPARE i200_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i200_curo                         # SCROLL CURSOR
#        CURSOR FOR i200_p1
 
#   START REPORT i200_rep TO l_name
 
#   FOREACH i200_curo INTO g_gja.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)    
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i200_rep(g_gja.*)
#   END FOREACH
 
#   FINISH REPORT i200_rep
 
#   CLOSE i200_curo
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i200_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
#       sr RECORD LIKE gja_file.*,
#       l_chr           LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.gja01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                 g_x[35] CLIPPED
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#
#       ON EVERY ROW
#           IF sr.gjaacti = 'N' THEN PRINT COLUMN g_c[31],'* '; END IF
 
#           PRINT COLUMN g_c[32],sr.gja01,
#                 COLUMN g_c[33],sr.gja02,
#                 COLUMN g_c[34],sr.gja03,
#                 COLUMN g_c[35],sr.gja04
 
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash[1,g_len]
#NO.TQC-630166 start--
#                    IF g_wc[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                    IF g_wc[071,140] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                    IF g_wc[141,210] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                    CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end--
#           END IF
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end-- 
