# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmi177.4gl
# Descriptions...: 車輛保養項目維護作業
# Date & Author..: 03/12/1 By HAWK
# Modify.........: No.MOD-4B0067 04/11/18 By DAY  將變數用Like方式定義
# Modify.........: No.FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No.FUN-580028 05/08/22 By Sarah 在複製裡增加set_entry段
# Modify.........: No.FUN-650065 06/05/31 By Tracy axd模塊轉atm模塊   
# Modify.........: NO.FUN-660104 06/06/15 By Tracy cl_err -> cl_err3
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換 
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改g_no_ask    
# Modify.........: No.FUN-6A0090 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740039 07/04/10 By Ray 語言轉換錯誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/17 By mike 報表格式修改為crystal reports
# Modify.........: No.TQC-8C0078 08/12/29 By clover 複製按下放棄段修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-B30059 11/03/07 By yinhy 錄入或更改時，狀態PAGE中，最近更改日應不可進入異動
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_obu          RECORD LIKE obu_file.*
DEFINE g_obu_t        RECORD LIKE obu_file.*
DEFINE g_obu01_t      LIKE obu_file.obu01
DEFINE g_wc,g_sql     STRING
DEFINE g_before_input_done LIKE type_file.num5     #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt          LIKE type_file.num10        #No.FUN-680120 INTEGER
DEFINE g_chr          LIKE type_file.chr1         #No.FUN-680120 VARCHAR(1)
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000      #No.FUN-680120 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_no_ask       LIKE type_file.num5          #No.FUN-680120 SMALLINT   #No.FUN-6A0072
DEFINE l_table        STRING                       #No.FUN-760083
DEFINE g_str          STRING                       #No.FUN-760083
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    INITIALIZE g_obu.* TO NULL
    INITIALIZE g_obu_t.* TO NULL
#No.FUN-760083  --BEGIN--
    LET g_sql="obu01.obu_file.obu01,",
              "obu02.obu_file.obu02,",
              "obu03.obu_file.obu03,",
              "obu04.obu_file.obu04,",
              "obu05.obu_file.obu05,",
              "obu06.obu_file.obu06,",
              "obu07.obu_file.obu07,",
              "l_desc1.apo_file.apo02"
    LET l_table=cl_prt_temptable("atmi177",g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",status,1)
    END IF 
#No.FUN-760083  --END--
 
    LET g_forupd_sql = " SELECT * FROM obu_file WHERE obu01 = ? FOR UPDATE "                                                        
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i177_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR      
 
    OPEN WINDOW atmi177_w WITH FORM "atm/42f/atmi177"
       ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL g_x.clear()
 
    # 2004/02/23 hjwang: 單檔要做locale的範例
#   WHILE TRUE
       LET g_action_choice = ""
       CALL i177_menu()
#      IF g_action_choice="exit" THEN EXIT WHILE END IF
#   END WHILE
    CLOSE WINDOW atmi177_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
 
END MAIN
 
FUNCTION i177_curs()
    CLEAR FORM
   INITIALIZE g_obu.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        obu01,obu02,obu03,obu04,obu05,obu06,obu07,
        obuuser,obugrup,obumodu,obudate,obuacti,
        obuoriu,obuorig                             #TQC-B30059
 
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
    #        LET g_wc = g_wc clipped," AND obuuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND obugrup = '",g_grup,"'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND obugrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('obuuser', 'obugrup')
    #End:FUN-980030
 
    LET g_sql="SELECT obu01 FROM obu_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY obu01"
    PREPARE i177_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i177_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i177_prepare
 
    LET g_sql=
        "SELECT COUNT(*) FROM obu_file WHERE ",g_wc CLIPPED
    PREPARE i177_precount FROM g_sql
    DECLARE i177_count CURSOR FOR i177_precount
 
END FUNCTION
 
 
FUNCTION i177_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i177_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i177_q()
            END IF
        ON ACTION next
            CALL i177_fetch('N')
        ON ACTION previous
            CALL i177_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i177_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i177_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i177_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i177_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU      #No.TQC-740039
            CONTINUE MENU      #No.TQC-740039
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i177_fetch('/')
        ON ACTION first
            CALL i177_fetch('F')
        ON ACTION last
            CALL i177_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No.FUN-6B0043-------add--------str----
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_obu.obu01 IS NOT NULL THEN
               LET g_doc.column1 = "obu01"
               LET g_doc.value1 = g_obu.obu01
               CALL cl_doc()
             END IF
          END IF
       #No.FUN-6B0043-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i177_cs
END FUNCTION
 
FUNCTION i177_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_obu.* LIKE obu_file.*
    LET g_obu01_t = NULL
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_obu.obuuser = g_user
        LET g_obu.obuoriu = g_user #FUN-980030
        LET g_obu.obuorig = g_grup #FUN-980030
        LET g_obu.obugrup = g_grup               #使用者所屬群
        LET g_obu.obudate = g_today
        LET g_obu.obuacti = 'Y'
        
        CALL i177_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_obu.obu01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO obu_file VALUES(g_obu.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("ins","obu_file",g_obu.obu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        ELSE
            LET g_obu_t.* = g_obu.*                # 保存上筆資料
            SELECT obu01 INTO g_obu.obu01 FROM obu_file
             WHERE obu01 = g_obu.obu01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i177_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    INPUT BY NAME g_obu.obuoriu,g_obu.obuorig,
        g_obu.obu01,g_obu.obu02,g_obu.obu03,g_obu.obu04,g_obu.obu05,
        g_obu.obu06,g_obu.obu07,g_obu.obuuser,g_obu.obugrup,
        g_obu.obudate,g_obu.obuacti,g_obu.obumodu WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i177_set_entry(p_cmd)
           CALL i177_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD obu01
          IF g_obu.obu01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_obu.obu01 != g_obu01_t) THEN
               SELECT COUNT(*) INTO l_n FROM obu_file
                WHERE obu01 = g_obu.obu01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_obu.obu01,-239,0)
                  LET g_obu.obu01 = g_obu01_t
                  DISPLAY BY NAME g_obu.obu01 
                  NEXT FIELD obu01
               END IF
            END IF
          END IF
 
        AFTER FIELD obu03
          IF g_obu.obu03 IS NOT NULL THEN
            CALL i177_obu03()
          END IF
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
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
END FUNCTION
 
FUNCTION i177_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obu.* TO NULL               #No.FUN-6B0043
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i177_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i177_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
        INITIALIZE g_obu.* TO NULL
    ELSE
        OPEN i177_count
        FETCH i177_COUNT INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i177_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i177_fetch(p_flzx)
    DEFINE
        p_flzx          LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
    CASE p_flzx
        WHEN 'N' FETCH NEXT     i177_cs INTO g_obu.obu01
        WHEN 'P' FETCH PREVIOUS i177_cs INTO g_obu.obu01
        WHEN 'F' FETCH FIRST    i177_cs INTO g_obu.obu01
        WHEN 'L' FETCH LAST     i177_cs INTO g_obu.obu01
        WHEN '/'
         IF (NOT g_no_ask) THEN   #No.FUN-6A0072
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
         FETCH ABSOLUTE g_jump i177_cs INTO g_obu.obu01
         LET g_no_ask = FALSE  #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
        INITIALIZE g_obu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flzx
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_obu.* FROM obu_file            # 重讀DB,因TEMP有不被更新特性
       WHERE obu01 = g_obu.obu01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("sel","obu_file",g_obu.obu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
    ELSE
         LET g_data_owner=g_obu.obuuser           #FUN-4C0052權限控管
         LET g_data_group=g_obu.obugrup
        CALL i177_show()                           # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i177_obu03()                                #顯示desc
    DEFINE l_desc    LIKE type_file.chr10             #No.FUN-680120 VARCHAR(10) # TQC-6A0079
 
    CASE
      WHEN g_obu.obu03 = '1'
           CALL cl_getmsg('axd-051',g_lang) RETURNING l_desc
      WHEN g_obu.obu03 = '2'
           CALL cl_getmsg('axd-052',g_lang) RETURNING l_desc
      OTHERWISE
           LET l_desc = NULL
    END CASE
    DISPLAY l_desc TO FORMONLY.desc 
END FUNCTION
 
FUNCTION i177_show()
    LET g_obu_t.* = g_obu.*
    DISPLAY BY NAME g_obu.obuoriu,g_obu.obuorig,
        g_obu.obu01,g_obu.obu02,g_obu.obu03,g_obu.obu04,g_obu.obu05,
        g_obu.obu06,g_obu.obu07,g_obu.obuuser,g_obu.obugrup,
        g_obu.obudate,g_obu.obumodu,g_obu.obuacti,
        g_obu.obuoriu,g_obu.obuorig           #No.TQC-B30059
    CALL i177_obu03()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
 
FUNCTION i177_u()
 
    DEFINE l_n      LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
#   IF g_obu.obu01 IS NULL THEN   #TQC-8C0078
    IF cl_null(g_obu.obu01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_obu01_t = g_obu.obu01
    LET g_obu_t.*=g_obu.*
    BEGIN WORK
    OPEN i177_cl USING g_obu.obu01
    IF STATUS THEN
       CALL cl_err("OPEN i177_cl:", STATUS, 1)
       CLOSE i177_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i177_cl INTO g_obu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_obu.obumodu = g_user                   #修改者
    LET g_obu.obudate = g_today                  #修改日期
    CALL i177_show()                             #顯示最新資料
    WHILE TRUE
        CALL i177_i("u")                         #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_obu.*=g_obu_t.*
            CALL i177_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
UPDATE obu_file SET obu_file.* = g_obu.*    # 更新DB
    WHERE obu01 = g_obu01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("upd","obu_file",g_obu.obu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i177_cl
    COMMIT WORK
END FUNCTION
 
 
 
FUNCTION i177_r()
 
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
#   IF g_obu.obu01 IS NULL THEN    #TQC-8C0078
    IF cl_null(g_obu.obu01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    BEGIN WORK
    OPEN i177_cl USING g_obu.obu01
    IF STATUS THEN
       CALL cl_err("OPEN i177_cl:", STATUS, 1)
       CLOSE i177_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i177_cl INTO g_obu.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i177_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "obu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_obu.obu01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM obu_file WHERE obu01 = g_obu.obu01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("del","obu_file",g_obu.obu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        ELSE
            CLEAR FORM
            INITIALIZE g_obu.* LIKE obu_file.*
            OPEN i177_count
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE i177_cs
               CLOSE i177_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            FETCH i177_count INTO g_row_count
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i177_cs
               CLOSE i177_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i177_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i177_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE   #No.FUN-6A0072
               CALL i177_fetch('/')
            END IF
        END IF
    END IF
    CLOSE i177_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i177_copy()
    DEFINE
        l_n                     LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_newno,l_oldno         LIKE obu_file.obu01
 
#   IF g_obu.obu01 IS NULL THEN    #TQC-8C0078
    IF cl_null(g_obu.obu01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
#   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
#   DISPLAY g_msg AT 2,1 
    LET g_before_input_done = FALSE   #FUN-580028
    CALL i177_set_entry('a')          #FUN-580028
    LET g_before_input_done = TRUE    #FUN-580028
    INPUT l_newno FROM obu01
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i177_set_entry("a")
           LET g_before_input_done = TRUE
 
         AFTER FIELD obu01
            SELECT COUNT(*) INTO l_n FROM obu_file WHERE obu01 = l_newno
            IF l_n > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD obu01
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
    #TQC-8C0078-- add start
    #IF INT_FLAG OR l_newno IS NULL THEN LET INT_FLAG = 0 RETURN END IF
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_obu.obu01
        RETURN
    END IF
    #TQC-8C0078 -- add --end
 
    DROP TABLE x
    SELECT * FROM obu_file
        WHERE obu01=g_obu.obu01
        INTO TEMP x
    UPDATE x
        SET obu01=l_newno,    #資料鍵值
            obuuser=g_user,   #資料所有者
            obugrup=g_grup,   #資料所有者所屬群
            obumodu=NULL,     #資料修改日期
            obudate=g_today   #資料建立日期
    INSERT INTO obu_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("ins","obu_file",g_obu.obu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
    END IF
 
    LET l_oldno = g_obu.obu01
    SELECT obu_file.* INTO g_obu.* FROM obu_file
              WHERE obu01 =  l_newno
    LET g_obu.obu01 = l_newno
    CALL i177_u()
    CALL i177_show()
    #SELECT obu_file.* INTO g_obu.* FROM obu_file  #FUN-C80046
    # WHERE obu01 = g_obu.obu01                    #FUN-C80046
    #CALL i177_show()                              #FUN-C80046
END FUNCTION
 
FUNCTION i177_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)               # External(Disk) file name
         l_za05          LIKE za_file.za05,       #MOD-4B0067
         l_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 DEFINE l_desc1          LIKE apo_file.apo02          #No.FUN-760083        
    IF cl_null(g_wc) AND NOT cl_null(g_obu.obu01) THEN
       LET g_wc = " obu01 = '",g_obu.obu01,"'"
    END IF
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    #CALL cl_outnam('atmi177') RETURNING l_name              #No.FUN-760083
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM obu_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i177_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i177_curo                         # SCROLL CURSOR
         CURSOR FOR i177_p1
 
    #START REPORT i177_rep TO l_name          #No.FUN-760083
    CALL cl_del_data(l_table)                 #No.FUN-760083
    LET g_str =''                             #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-760083
    FOREACH i177_curo INTO g_obu.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
          #OUTPUT TO REPORT i177_rep(g_obu.*)   #No.FUN-760083
          CASE g_obu.obu03                                                       #No.FUN-760083                                                                       
                 WHEN '1' CALL cl_getmsg('axd-051',g_lang) RETURNING l_desc1     #No.FUN-760083                                                   
                 WHEN '2' CALL cl_getmsg('axd-052',g_lang) RETURNING l_desc1     #No.FUN-760083                                                   
          END CASE                                                               #No.FUN-760083
          EXECUTE insert_prep USING  g_obu.obu01,g_obu.obu02,g_obu.obu03,        #No.FUN-760083
                                     g_obu.obu04,g_obu.obu05,g_obu.obu06,        #No.FUN-760083
                                     g_obu.obu07,l_desc1                         #No.FUN-760083     
    END FOREACH
 
    #FINISH REPORT i177_rep                        #No.FUN-760083
 
    CLOSE i177_curo
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)             #No.FUN-760083
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #No.FUN-760083
    IF g_zz05='Y' THEN                                               #No.FUN-760083
        CALL cl_wcchp(g_wc,'obu01,obu02,obu03,obu04,obu05,obu06,obu07,  #No.FUN-760083                                                                                  
                            obuuser,obugrup,obumodu,obudate,obuacti')   #No.FUN-760083
        RETURNING    g_wc                                               #No.FUN-760083
    END IF                                                              #No.FUN-760083
    LET g_str=g_wc                                                      #No.FUN-760083
    CALL cl_prt_cs3("atmi177","atmi177",g_sql,g_str)                    #No.FUN-760083
END FUNCTION
 
#No.FUN-760083  --BEGIN--
 
#REPORT i177_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
#        sr RECORD LIKE obu_file.*,
#        l_chr           LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
#        l_desc1         LIKE apo_file.apo02           #No.FUN-680120 VARCHAR(20)
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.obu01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED, pageno_total
# 
#            PRINT COLUMN (((g_len-FGL_WIDTH(g_x[1])))/2)+1 ,g_x[1]
#            PRINT
#            PRINT g_dash[1,g_len]
#
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#            CASE sr.obu03
#                 WHEN '1' CALL cl_getmsg('axd-051',g_lang) RETURNING l_desc1
#                 WHEN '2' CALL cl_getmsg('axd-052',g_lang) RETURNING l_desc1
#            END CASE
#
#   BEFORE GROUP OF sr.obu01
#         SKIP TO TOP OF PAGE
#
#            PRINTX name=D1 COLUMN g_c[31],sr.obu01,
#                           COLUMN g_c[32],sr.obu02,
#                           COLUMN g_c[33],sr.obu03,
#                           COLUMN g_c[34],l_desc1,
#                           COLUMN g_c[35],sr.obu04
#
#            PRINTX name=D2 COLUMN g_c[35],sr.obu05
#            PRINTX name=D3 COLUMN g_c[35],sr.obu06
#            PRINTX name=D4 COLUMN g_c[35],sr.obu07
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
 
#No.FUN-760083  --END--
 
FUNCTION i177_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("obu01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i177_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("obu01",FALSE)
  END IF
END FUNCTION
 
