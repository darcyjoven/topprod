# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axmi703.4gl
# Descriptions...: 潛在客戶競爭廠商維護作業
# Date & Author..: 02/11/08 BY Windy
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-830152 08/04/09 By baofei  報表打印改為CR輸出  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BA0107 11/10/19 By destiny oriu,orig不能查询
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_off   RECORD LIKE off_file.*,
    g_off_t RECORD LIKE off_file.*,
    g_off_o RECORD LIKE off_file.*,
    g_off01_t      LIKE off_file.off01,
    g_off02_t      LIKE off_file.off02,
    g_wc,g_sql     STRING,   #No.FUN-580092 HCN   
    l_cmd          LIKE gbc_file.gbc05      #No.FUN-680137 VARCHAR(100)
DEFINE p_row,p_col LIKE type_file.num5      #No.FUN-680137 SMALLINT
DEFINE g_cmd       LIKE gbc_file.gbc05      #No.FUN-680137 VARCHAR(100)
DEFINE g_buf       LIKE ima_file.ima01      #No.FUN-680137 VARCHAR(40)
DEFINE g_argv1     LIKE off_file.off01
 
DEFINE   g_forupd_sql STRING #SELECT ... FOR UPDATE SQL  
DEFINE   g_before_input_done  STRING 
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0094
 
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
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    INITIALIZE g_off.* TO NULL
    INITIALIZE g_off_t.* TO NULL
    INITIALIZE g_off_o.* TO NULL
 
 
    LET g_forupd_sql = "SELECT * FROM off_file WHERE off01 = ?  AND off02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i703_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
    LET p_row = 4 LET p_col = 4
 
    OPEN WINDOW i703_w AT p_row,p_col
         WITH FORM "axm/42f/axmi703"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_argv1 = ARG_VAL(1)
    IF NOT cl_null(g_argv1) THEN
       CALL i703_q()
    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i703_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i703_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i703_cs()
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " off01 ='",g_argv1,"'"
    ELSE
       CLEAR FORM
   INITIALIZE g_off.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           off01,off02,off03,off04,off05,off051,off052,off053,off054,
           off06,off061,off07,off071,
           offuser,offgrup,offmodu,offdate,offacti
           ,offoriu,offorig  #TQC-BA0107

              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON ACTION controlp
            CASE
                WHEN INFIELD(off01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form = "q_ofd"
                    LET g_qryparam.default1 =  g_off.off01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO off01
                    NEXT FIELD off01
                WHEN INFIELD(off03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form = "q_ofr"
                    LET g_qryparam.default1 = g_off.off03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO off03
                    NEXT FIELD off03
                OTHERWISE
                    EXIT CASE
            END CASE
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
       IF INT_FLAG THEN RETURN END IF
    END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND offuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                          #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND offgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND offgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('offuser', 'offgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT off01,off02 FROM off_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY off01,off02"
    PREPARE i703_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i703_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i703_prepare
    LET g_sql = "SELECT off01,off02 FROM off_file ",
                " WHERE ",g_wc CLIPPED," INTO TEMP x "
    DROP TABLE x
    PREPARE i703_precount_x  FROM g_sql
    EXECUTE i703_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i703_precount FROM g_sql
    DECLARE i703_count CURSOR FOR i703_precount
END FUNCTION
 
FUNCTION i703_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i703_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i703_q()
            END IF
 
        ON ACTION next
           CALL i703_fetch('N')
 
        ON ACTION previous
           CALL i703_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i703_u()
            END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i703_r()
            END IF
 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL i703_out()
            END IF
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i703_fetch('/')
 
        ON ACTION first
           CALL i703_fetch('F')
 
        ON ACTION last
           CALL i703_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0020-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_off.off01 IS NOT NULL THEN
                  LET g_doc.column1 = "off01"
                  LET g_doc.column2 = "off02"
                  LET g_doc.value1 = g_off.off01
                  LET g_doc.value2 = g_off.off02
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
    CLOSE i703_cs
END FUNCTION
 
FUNCTION i703_a()
    DEFINE l_cmd     LIKE gbc_file.gbc05        #No.FUN-680137  VARCHAR(100)
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_off.* LIKE off_file.*
    LET g_off01_t = NULL
    LET g_off02_t = NULL
    IF NOT cl_null(g_argv1) THEN
       LET g_off.off01 = g_argv1
    END IF
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_off.offacti = 'Y'
        LET g_off.offuser = g_user
        LET g_off.offoriu = g_user #FUN-980030
        LET g_off.offorig = g_grup #FUN-980030
        LET g_off.offgrup = g_grup
        LET g_off.offdate = g_today
        LET g_off_t.*=g_off.*
        CALL i703_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_off.off01 IS NULL OR g_off.off02 IS NULL THEN     # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO off_file VALUES(g_off.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_off.off01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","off_file",g_off.off01,g_off.off02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        ELSE
           SELECT off01,off02 INTO g_off.off01,g_off.off02 FROM off_file
              WHERE off01 = g_off.off01 AND off02 = g_off.off02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i703_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
	l_chr		LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
    INPUT BY NAME g_off.offoriu,g_off.offorig,
        g_off.off01,g_off.off02, g_off.off03, g_off.off04,
        g_off.off05,g_off.off051,g_off.off052,g_off.off053,g_off.off054,
        g_off.off06,g_off.off061,g_off.off07, g_off.off071,
        g_off.offuser,g_off.offgrup,g_off.offmodu,g_off.offdate,g_off.offacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i703_set_entry(p_cmd)
           CALL i703_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        BEFORE FIELD off01
            IF NOT cl_null(g_argv1) THEN
               SELECT ofd02 INTO g_buf FROM ofd_file WHERE ofd01=g_off.off01
               DISPLAY g_buf TO ofd02
            END IF
 
        AFTER FIELD off01
          IF g_off.off01 IS NOT NULL THEN
            LET g_buf = ''
            SELECT ofd02 INTO g_buf FROM ofd_file WHERE ofd01=g_off.off01
            IF STATUS THEN
#              CALL cl_err(g_off.off01,'mfg2732',0)   #No.FUN-660167
               CALL cl_err3("sel","ofd_file",g_off.off01,"","mfg2732","","",1)  #No.FUN-660167
               NEXT FIELD off01
            END IF
            DISPLAY g_buf TO ofd02
          END IF
 
        BEFORE FIELD off02
            IF cl_null(g_off.off02) OR g_off.off02 = 0 THEN
               SELECT MAX(off02)+1 INTO g_off.off02 FROM off_file
                WHERE off01 = g_off.off01
               IF cl_null(g_off.off02) THEN LET g_off.off02 = 1 END IF
               DISPLAY BY NAME g_off.off02
            END IF
 
        AFTER FIELD off02
            IF g_off.off02 = 0 THEN NEXT FIELD off02 END IF
 
        AFTER FIELD off03
            IF NOT cl_null(g_off.off03) THEN
               SELECT ofr02 INTO g_off.off04 FROM ofr_file
                WHERE ofr01 = g_off.off03
               IF STATUS THEN
#                 CALL cl_err(g_off.off03,'mfg3001',0)   #No.FUN-660167
                  CALL cl_err3("sel","ofr_file",g_off.off03,"","mfg3001","","",1)  #No.FUN-660167
                  NEXT FIELD off03
               END IF
               DISPLAY BY NAME g_off.off04
            END IF
 
        AFTER INPUT
           LET g_off.offuser = s_get_data_owner("off_file") #FUN-C10039
           LET g_off.offgrup = s_get_data_group("off_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
       ON ACTION controlp
            CASE
                WHEN INFIELD(off01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ofd"
                    LET g_qryparam.default1 =  g_off.off01
                    CALL cl_create_qry() RETURNING  g_off.off01
#                    CALL FGL_DIALOG_SETBUFFER( g_off.off01 )
                    DISPLAY BY NAME g_off.off01
                    NEXT FIELD off01
                WHEN INFIELD(off03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ofr"
                    LET g_qryparam.default1 = g_off.off03
                    CALL cl_create_qry() RETURNING g_off.off03
#                    CALL FGL_DIALOG_SETBUFFER( g_off.off03 )
                    DISPLAY BY NAME g_off.off03
                    NEXT FIELD off03
                OTHERWISE
                    EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i703_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_off.* TO NULL              #No.FUN-6A0020
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i703_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i703_count
    FETCH i703_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i703_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_off.off01,SQLCA.sqlcode,0)
       INITIALIZE g_off.* TO NULL
    ELSE
       CALL i703_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
FUNCTION i703_fetch(p_floff)
    DEFINE
        p_floff         LIKE type_file.chr1                    #No.FUN-680137  VARCHAR(1) 
 
    CASE p_floff
       WHEN 'N' FETCH NEXT     i703_cs INTO g_off.off01,g_off.off02
       WHEN 'P' FETCH PREVIOUS i703_cs INTO g_off.off01,g_off.off02
       WHEN 'F' FETCH FIRST    i703_cs INTO g_off.off01,g_off.off02
       WHEN 'L' FETCH LAST     i703_cs INTO g_off.off01,g_off.off02
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
            FETCH ABSOLUTE g_jump i703_cs INTO g_off.off01,
                                               g_off.off02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_off.off01,SQLCA.sqlcode,0)
        INITIALIZE g_off.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_floff
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_off.* FROM off_file            # 重讀DB,因TEMP有不被更新特性
       WHERE off01 = g_off.off01 AND off02=g_off.off02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_off.off01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","off_file",g_off.off01,g_off.off02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_off.* TO NULL            #FUN-4C0057 add
    ELSE
       LET g_data_owner = g_off.offuser      #FUN-4C0057 add
       LET g_data_group = g_off.offgrup      #FUN-4C0057 add
       CALL i703_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i703_show()
    LET g_off_t.* = g_off.*
    DISPLAY BY NAME g_off.offoriu,g_off.offorig,
        g_off.off01,g_off.off02,g_off.off03,g_off.off04,
        g_off.off05,g_off.off051,g_off.off052,g_off.off053,g_off.off054,
        g_off.off06,g_off.off061,g_off.off07,g_off.off071,
        g_off.offuser,g_off.offgrup,g_off.offmodu,g_off.offdate,g_off.offacti
    LET g_buf = ''
    SELECT ofd02  INTO g_buf FROM ofd_file WHERE ofd01=g_off.off01
    DISPLAY g_buf TO ofd02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i703_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_off.off01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_off.* FROM off_file
     WHERE off01 = g_off.off01 AND off02 = g_off.off02
    IF g_off.offacti ='N' THEN     #檢查資料是否為無效
        CALL cl_err(g_off.off01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_off01_t = g_off.off01
    LET g_off02_t = g_off.off02
    LET g_off_o.*=g_off.*
    BEGIN WORK
 
    OPEN i703_cl USING g_off.off01,g_off.off02
    IF STATUS THEN
       CALL cl_err("OPEN i703_cl:", STATUS, 1)
       CLOSE i703_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i703_cl INTO g_off.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_off.off01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_off.offmodu=g_user                     #修改者
    LET g_off.offdate = g_today                  #修改日期
    CALL i703_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_off_t.*=g_off.*
        CALL i703_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_off.*=g_off_t.*
            CALL i703_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE off_file SET off_file.* = g_off.*    # 更新DB
            WHERE off01 = g_off_t.off01 AND off02=g_off_t.off02           # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_off.off01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","off_file",g_off.off01,g_off.off02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    MESSAGE " "
    CLOSE i703_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i703_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
    IF s_shut(0) THEN RETURN END IF
    IF g_off.off01 IS NULL OR g_off.off02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i703_cl USING g_off.off01,g_off.off02
    IF STATUS THEN
       CALL cl_err("OPEN i703_cl:", STATUS, 1)
       CLOSE i703_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i703_cl INTO g_off.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_off.off01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i703_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "off01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "off02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_off.off01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_off.off02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM off_file WHERE off01 = g_off.off01 AND off02 = g_off.off02
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_off.off01,SQLCA.sqlcode,0)   #No.FUN-660167
          CALL cl_err3("del","off_file",g_off.off01,g_off.off02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
       #MOD-5A0004 add
       DROP TABLE x
       EXECUTE i703_precount_x
       #MOD-5A0004 end
       INITIALIZE g_off.* TO NULL
       OPEN i703_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i703_cs
          CLOSE i703_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i703_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i703_cs
          CLOSE i703_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i703_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i703_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i703_fetch('/')
       END IF
    END IF
    CLOSE i703_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i703_out()
    DEFINE
        l_off           RECORD LIKE off_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE ima_file.ima01           #No.FUN-680137 VARCHAR(40)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'axmi703'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-830152---Begin
     LET g_sql="SELECT off_file.*,ofd02 FROM off_file LEFT OUTER JOIN ofd_file ON off_file.off01 = ofd_file.ofd01 ",                                                                                           
               " WHERE ",g_wc CLIPPED 
#    LET g_sql="SELECT * FROM off_file ",
#              " WHERE ",g_wc CLIPPED
#    PREPARE i703_p1 FROM g_sql                # RUNTIME
#    DECLARE i703_co                           # CURSOR
#       CURSOR FOR i703_p1
 
#    CALL cl_outnam('axmi703') RETURNING l_name
#    START REPORT i703_rep TO l_name
#    FOREACH i703_co INTO l_off.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i703_rep(l_off.*)
     CALL cl_prt_cs1('axmi703','axmi703',g_sql,'')  
#    END FOREACH
 
#    FINISH REPORT i703_rep
 
#    CLOSE i703_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-830152---End
END FUNCTION
#No.FUN-830152---Begin
# REPORT i703_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680137 VARCHAR(1)  
#       sr              RECORD LIKE off_file.*,
#       l_ofd02         LIKE ofd_file.ofd02,
#       i               LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.off01,sr.off02
 
#   FORMAT
#       PAGE HEADER
#          SELECT ofd02 INTO l_ofd02 FROM ofd_file WHERE ofd01=sr.off01
#          PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#          PRINT ' '
#          PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#          PRINT ' '
#          PRINT g_x[11] CLIPPED,sr.off01 CLIPPED,' ',l_ofd02
#          PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#          PRINT g_dash[1,g_len]
#          LET l_trailer_sw = 'y'
#          LET i = 0
 
#       BEFORE GROUP OF sr.off01
#          SKIP TO TOP OF PAGE
#
#       ON EVERY ROW
#          IF i > 0 AND i < 5 THEN
#             PRINT '---------------------------------------------------------',
#                   '-----------------------'
#          END IF
#          LET i = i+1
 
#          PRINT g_x[12] CLIPPED,COLUMN 11,sr.off03 CLIPPED,' ',sr.off04
#          PRINT g_x[13] CLIPPED,
#                COLUMN 11,sr.off05
#          PRINT COLUMN 11,sr.off051
#          PRINT COLUMN 11,sr.off052
#          PRINT COLUMN 11,sr.off053
#          PRINT COLUMN 11,sr.off054
 
#          PRINT g_x[14] CLIPPED,
#                COLUMN 11,sr.off06
#          PRINT COLUMN 11,sr.off061
 
#          PRINT g_x[15] CLIPPED,
#                COLUMN 11,sr.off07
#          PRINT COLUMN 11,sr.off071
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],COLUMN 41,g_x[5] CLIPPED,
#                 COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],COLUMN 41,g_x[5] CLIPPED,
#                     COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-830152---End
FUNCTION i703_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("off01,off02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i703_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("off01,off02",FALSE)
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

