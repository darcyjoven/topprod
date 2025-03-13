# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmi360.4gl
# Descriptions...: 使用者其他相關資料維護(報價單用)
# Date & Author..: 00/03/29 By Carol
# Modify.........: 04/08/04 By Wiky Bugno.MOD-480096 不能copy,沒加controlp
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530339 05/03/28 By Mandy 執行複製時, 開窗選取後無法將選取的員工編號帶入使用者.
# Modify.........: No.MOD-550127 05/06/10 By kim 列印會當
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.TQC-650043 06/05/12 By CoCo cl_outnam需在assign g_len之前
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0127 06/11/22 By day 輸入用戶要check gen_file
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-840054 08/04/17 By mike 報表輸出方式轉為Crystal Reports  
# Modify.........: No.TQC-930105 09/03/13 By chenyu 無效的資料不可以刪除
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990186 09/10/09 By Smapmin 修正FUN-980030
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AC0049 10/12/07 By houlia add oqsoriu/oqsorig顯示
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B80188 11/08/26 By lixia 查詢欄位
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_oqs   RECORD LIKE oqs_file.*,
    g_oqs_t RECORD LIKE oqs_file.*,
    g_oqs01_t LIKE oqs_file.oqs01,
     g_wc,g_sql   STRING  #No.FUN-580092 HCN 
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   
DEFINE   g_before_input_done   STRING
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_str          STRING                       #No.FUN-840054   
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680137 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0094
 
    OPTIONS
 
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    INITIALIZE g_oqs.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM oqs_file WHERE oqs01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i360_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 2 LET p_col = 2
 
    OPEN WINDOW i360_w AT p_row,p_col
        WITH FORM "axm/42f/axmi360"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i360_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i360_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i360_cs()
    CLEAR FORM
   INITIALIZE g_oqs.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON        # 螢幕上取條件
        oqs01,oqs13,oqs141,oqs142,oqs143,oqs151,oqs152,
        oqs161,oqs162,
        oqs171,oqs172,oqs173,oqs181,oqs191,oqs192,oqs20,
        oqsuser,oqsgrup,oqsmodu,oqsdate,oqsacti
        ,oqsoriu,oqsorig  #TQC-B80188
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
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(oqs01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oqs01
                NEXT FIELD oqs01
           END CASE
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND oqsuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND oqsgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND oqsgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oqsuser', 'oqsgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT oqs01 FROM oqs_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED," ORDER BY oqs01"
    PREPARE i360_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i360_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i360_prepare
    LET g_sql="SELECT COUNT(*) FROM oqs_file WHERE ",g_wc CLIPPED
    PREPARE i360_precount FROM g_sql
    DECLARE i360_count CURSOR FOR i360_precount
END FUNCTION
 
FUNCTION i360_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i360_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i360_q()
            END IF
        ON ACTION next
            CALL i360_fetch('N')
        ON ACTION previous
            CALL i360_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i360_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i360_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i360_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i360_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i360_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i360_fetch('/')
        ON ACTION first
            CALL i360_fetch('F')
        ON ACTION last
            CALL i360_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0020-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
             IF cl_chk_act_auth() THEN
                IF g_oqs.oqs01 IS NOT NULL THEN
                LET g_doc.column1 = "oqs01"
                LET g_doc.value1 = g_oqs.oqs01
                CALL cl_doc()
              END IF
           END IF
        #No.FUN-6A0020-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i360_cs
END FUNCTION
 
 
FUNCTION i360_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_oqs.* LIKE oqs_file.*
    LET g_oqs01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_oqs.oqsuser = g_user
        LET g_oqs.oqsoriu = g_user #FUN-980030
        LET g_oqs.oqsorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_oqs.oqsgrup = g_grup               #使用者所屬群
        LET g_oqs.oqsdate = g_today
        LET g_oqs.oqsacti = 'Y'
        #FUN-980010 add plant & legal 
        LET g_oqs.oqsplant = g_plant 
        LET g_oqs.oqslegal = g_legal 
        #FUN-980010 end plant & legal 
        CALL i360_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_oqs.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_oqs.oqs01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO oqs_file VALUES(g_oqs.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_oqs.oqs01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","oqs_file",g_oqs.oqs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        ELSE
            SELECT oqs01 INTO g_oqs.oqs01 FROM oqs_file
             WHERE oqs01 = g_oqs.oqs01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i360_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680137 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
    DISPLAY BY NAME
        g_oqs.oqs01,
        g_oqs.oqs13,g_oqs.oqs141,g_oqs.oqs142,g_oqs.oqs143,
        g_oqs.oqs151,g_oqs.oqs152,
        g_oqs.oqs161,g_oqs.oqs162,
        g_oqs.oqs171,g_oqs.oqs172,g_oqs.oqs173,
        g_oqs.oqs181,g_oqs.oqs191,g_oqs.oqs192,
        g_oqs.oqs20,
        g_oqs.oqsuser,g_oqs.oqsgrup,g_oqs.oqsmodu,g_oqs.oqsdate,g_oqs.oqsacti,
        g_oqs.oqsoriu,g_oqs.oqsorig                    #TQC-AC0049 add oriu/orig
 
    INPUT BY NAME
        g_oqs.oqs01,
        g_oqs.oqs13, g_oqs.oqs141,g_oqs.oqs142,g_oqs.oqs143,
        g_oqs.oqs151,g_oqs.oqs152,
        g_oqs.oqs161,g_oqs.oqs162,
        g_oqs.oqs171,g_oqs.oqs172,g_oqs.oqs173,
        g_oqs.oqs181,g_oqs.oqs182,g_oqs.oqs191,g_oqs.oqs192,
        g_oqs.oqs20 WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i360_set_entry(p_cmd)
           CALL i360_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD oqs01
          IF g_oqs.oqs01 IS NOT NULL THEN
            IF p_cmd = "a" OR      # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_oqs.oqs01 != g_oqs01_t) THEN
                SELECT count(*) INTO l_n FROM oqs_file
                 WHERE oqs01=g_oqs.oqs01
                IF l_n > 0 THEN    # Duplicated
                    CALL cl_err(g_oqs.oqs01,-239,0)
                    LET g_oqs.oqs01 = g_oqs01_t
                    DISPLAY BY NAME g_oqs.oqs01
                    NEXT FIELD oqs01
                #No.TQC-6B0127--begin
                ELSE
                   SELECT count(*) INTO l_n FROM gen_file
                    WHERE gen01=g_oqs.oqs01 AND genacti = 'Y'
                   IF l_n = 0 THEN  
                       CALL cl_err(g_oqs.oqs01,'aoo-001',0)
                       LET g_oqs.oqs01 = g_oqs01_t
                       DISPLAY BY NAME g_oqs.oqs01
                       NEXT FIELD oqs01
                   END IF
                #No.TQC-6B0127--end  
                END IF
            END IF
          END IF
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(oqs01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.default1 = g_oqs.oqs01
                CALL cl_create_qry() RETURNING g_oqs.oqs01
                DISPLAY BY NAME g_oqs.oqs01
                NEXT FIELD oqs01
            END CASE
 
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #     IF INFIELD(oqs01) THEN
      #        LET g_oqs.* = g_oqs_t.*
      #        CALL i360_show()
      #        NEXT FIELD oqs01
      #     END IF
      #MOD-650015 --end
 
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
 
FUNCTION i360_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_oqs.* TO NULL                  #No.FUN-6A0020
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i360_cs()                              # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
 
    OPEN i360_count
    FETCH i360_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i360_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oqs.oqs01,SQLCA.sqlcode,0)
        INITIALIZE g_oqs.* TO NULL
    ELSE
        CALL i360_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i360_fetch(p_floqs)
    DEFINE
        p_floqs         LIKE type_file.chr1      #No.FUN-680137 VARCHAR(1) 
 
    CASE p_floqs
        WHEN 'N' FETCH NEXT     i360_cs INTO g_oqs.oqs01
        WHEN 'P' FETCH PREVIOUS i360_cs INTO g_oqs.oqs01
        WHEN 'F' FETCH FIRST    i360_cs INTO g_oqs.oqs01
        WHEN 'L' FETCH LAST     i360_cs INTO g_oqs.oqs01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i360_cs INTO g_oqs.oqs01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oqs.oqs01,SQLCA.sqlcode,0)
        INITIALIZE g_oqs.* TO NULL  #TQC-6B0105
        LET g_oqs.oqs01 = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_floqs
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_oqs.* FROM oqs_file            # 重讀DB,因TEMP有不被更新特性
       WHERE oqs01 = g_oqs.oqs01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_oqs.oqs01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","oqs_file",g_oqs.oqs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_oqs.* TO NULL            #FUN-4C0057 add
    ELSE
       LET g_data_owner = g_oqs.oqsuser      #FUN-4C0057 add
       LET g_data_group = g_oqs.oqsgrup      #FUN-4C0057 add
       LET g_data_plant = g_oqs.oqsplant #FUN-980030
       CALL i360_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i360_show()
    LET g_oqs_t.* = g_oqs.*
    #-----MOD-990186---------
    #DISPLAY BY NAME g_oqs.*
    DISPLAY BY NAME
        g_oqs.oqs01,g_oqs.oqs13,
        g_oqs.oqs141,g_oqs.oqs142,g_oqs.oqs143,
        g_oqs.oqs151,g_oqs.oqs152,
        g_oqs.oqs161,g_oqs.oqs162,
        g_oqs.oqs171,g_oqs.oqs172,g_oqs.oqs173,
        g_oqs.oqs181,g_oqs.oqs182,
        g_oqs.oqs191,g_oqs.oqs192,
        g_oqs.oqs20,
        g_oqs.oqsuser,g_oqs.oqsgrup,g_oqs.oqsmodu,g_oqs.oqsdate,g_oqs.oqsacti,
        g_oqs.oqsoriu,g_oqs.oqsorig
    #-----END MOD-990186-----
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i360_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_oqs.oqs01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_oqs.* FROM oqs_file WHERE oqs01=g_oqs.oqs01
    IF g_oqs.oqsacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_oqs01_t = g_oqs.oqs01
    BEGIN WORK
    OPEN i360_cl USING g_oqs.oqs01
    IF STATUS THEN
       CALL cl_err("OPEN i360_cl:", STATUS, 1)
       CLOSE i360_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i360_cl INTO g_oqs.*                   #對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oqs.oqs01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_oqs.oqsmodu=g_user                     #修改者
    LET g_oqs.oqsdate = g_today                  #修改日期
    CALL i360_show()                             #顯示最新資料
    WHILE TRUE
        CALL i360_i("u")                         #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_oqs.*=g_oqs_t.*
            CALL i360_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE oqs_file SET oqs_file.* = g_oqs.*  # 更新DB
            WHERE oqs01 = g_oqs.oqs01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_oqs.oqs01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","oqs_file",g_oqs01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i360_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i360_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_oqs.oqs01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i360_cl USING g_oqs.oqs01
    IF STATUS THEN
       CALL cl_err("OPEN i360_cl:", STATUS, 1)
       CLOSE i360_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i360_cl INTO g_oqs.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oqs.oqs01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i360_show()
    IF cl_exp(0,0,g_oqs.oqsacti) THEN
        LET g_chr=g_oqs.oqsacti
        IF g_oqs.oqsacti='Y' THEN
            LET g_oqs.oqsacti='N'
        ELSE
            LET g_oqs.oqsacti='Y'
        END IF
        UPDATE oqs_file
            SET oqsacti=g_oqs.oqsacti
            WHERE oqs01=g_oqs.oqs01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_oqs.oqs01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","oqs_file",g_oqs.oqs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_oqs.oqsacti=g_chr
        END IF
        DISPLAY BY NAME g_oqs.oqsacti
    END IF
    CLOSE i360_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i360_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_oqs.oqs01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i360_cl USING g_oqs.oqs01
    IF STATUS THEN
       CALL cl_err("OPEN i360_cl:", STATUS, 1)
       CLOSE i360_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i360_cl INTO g_oqs.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oqs.oqs01,SQLCA.sqlcode,0)
       RETURN
    END IF
    #No.TQC-930105 add --begin
    IF g_oqs.oqsacti = 'N' THEN
       CALL cl_err('','abm-950',0)
       RETURN
    END IF
    #No.TQC-930105 add --end
    CALL i360_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "oqs01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_oqs.oqs01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM oqs_file WHERE oqs01 = g_oqs.oqs01
       CLEAR FORM
       INITIALIZE g_oqs.* TO NULL
       OPEN i360_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i360_cs
          CLOSE i360_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i360_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i360_cs
          CLOSE i360_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i360_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i360_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i360_fetch('/')
       END IF
    END IF
 
    CLOSE i360_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i360_copy()
    DEFINE
        l_newno         LIKE oqs_file.oqs01,
        l_oldno         LIKE oqs_file.oqs01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_oqs.oqs01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
     LET g_before_input_done = FALSE   #No.MOD-480096
     CALL i360_set_entry("a")          #No.MOD-480096
     LET g_before_input_done = TRUE    #No.MOD-480096
 
    INPUT l_newno FROM oqs01
        AFTER FIELD oqs01
          IF l_newno IS NOT NULL THEN
            SELECT count(*) INTO g_cnt FROM oqs_file
                WHERE oqs01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD oqs01
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
 
 
        ON ACTION CONTROLP     #No.MOD-480096
           CASE WHEN INFIELD(oqs01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.default1 =l_newno
                CALL cl_create_qry() RETURNING l_newno
                 DISPLAY l_newno TO oqs01  #MOD-530339
            END CASE
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_oqs.oqs01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM oqs_file
        WHERE oqs01=g_oqs.oqs01
        INTO TEMP x
    UPDATE x
        SET oqs01=l_newno,    #資料鍵值
            oqsacti='Y',      #資料有效碼
            oqsuser=g_user,   #資料所有者
            oqsgrup=g_grup,   #資料所有者所屬群
            oqsmodu=NULL,     #資料修改日期
            oqsdate=g_today   #資料建立日期
    INSERT INTO oqs_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_oqs.oqs01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("ins","oqs_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_oqs.oqs01
        LET g_oqs.oqs01 = l_newno
        SELECT oqs_file.* INTO g_oqs.* FROM oqs_file
               WHERE oqs01 = l_newno
        CALL i360_u()
        #SELECT oqs_file.* INTO g_oqs.* FROM oqs_file  #FUN-C80046
        #       WHERE oqs01 = l_oldno                  #FUN-C80046
    END IF
    #LET g_oqs.oqs01 = l_oldno                         #FUN-C80046
    CALL i360_show()
END FUNCTION
 
FUNCTION i360_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_oqs           RECORD LIKE oqs_file.*,
        l_gen           RECORD LIKE gen_file.*,
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        sr              RECORD LIKE oqs_file.*,
        l_za05          LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(40)
 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
##TQC-650043##
    #SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'axmi360'
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
##TQC-650043##
    LET g_sql="SELECT * FROM oqs_file WHERE ",g_wc CLIPPED
#No.FUN-840054  --BEGIN                                                                                                             
{                       
    PREPARE i360_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i360_curo                         # CURSOR
        CURSOR FOR i360_p1
 
    LET g_rlang = g_lang                               #FUN-4C0096 add
   #CALL cl_outnam('axmr100') RETURNING l_name         #FUN-4C0096 add
     CALL cl_outnam('axmi360') RETURNING l_name         #MOD-550127
##TQC-650043##
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'axmi360'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
##TQC-650043##
    START REPORT i360_rep TO l_name
 
    FOREACH i360_curo INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT i360_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i360_rep
 
    CLOSE i360_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
}                                                                                                                                   
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog                                                                          
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'oqs01,oqs13,oqs141,oqs142,oqs143,oqs151,oqs152,                                                          
                           oqs161,oqs162,                                                                                           
                           oqs171,oqs172,oqs173,oqs181,oqs191,oqs192,oqs20,                                                         
                           oqsuser,oqsgrup,oqsmodu,oqsdate,oqsacti   ')                                                             
       RETURNING g_wc                                                                                                               
       LET g_str = g_wc                                                                                                             
    END IF                                                                                                                          
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'axmi360'                                                                      
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF                                                                        
    LET g_str = g_str,';',g_len                                                                                                     
    CALL cl_prt_cs1('axmi360','axmi360',g_sql,g_str)                                                                                
#No.FUN-840054  --END                              
END FUNCTION
 
#No.FUN-840054  --BEGIN                                                                                                             
{                        
REPORT i360_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
        sr              RECORD LIKE oqs_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.oqs01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT ' '
            PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED   #No.TQC-6A0091
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT g_x[11] CLIPPED,sr.oqs01
            PRINT g_x[12] CLIPPED,sr.oqs13
            PRINT g_x[13] CLIPPED,sr.oqs141[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT COLUMN 11,sr.oqs142[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT COLUMN 11,sr.oqs143[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT g_x[14] CLIPPED,sr.oqs151[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT COLUMN 11,sr.oqs152[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT g_x[15] CLIPPED,sr.oqs161[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT COLUMN 11,sr.oqs162[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT g_x[16] CLIPPED,sr.oqs171[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT COLUMN 11,sr.oqs172[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT COLUMN 11,sr.oqs173[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT g_x[17] CLIPPED,sr.oqs181[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT COLUMN 11,sr.oqs182[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT g_x[18] CLIPPED,sr.oqs191[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT COLUMN 11,sr.oqs192[1,g_len-10] CLIPPED  #No.TQC-6A0091
            PRINT g_x[19] CLIPPED,sr.oqs20
            PRINT
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-840054  --END  
 
FUNCTION i360_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("oqs01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i360_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("oqs01",FALSE)
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
