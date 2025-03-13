# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: admi202.4gl
# Descriptions...: 財務指標設定作業
# Date & Author..: 02/02/02 By Apple
#
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660090 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-6A0150 06/10/26 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770008 07/07/05 By arman 報表改為使用crystal report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_dmc   RECORD LIKE dmc_file.*,
    g_dmc_t RECORD LIKE dmc_file.*,
    g_dmc01_t LIKE dmc_file.dmc01,
    g_dmc02_t LIKE dmc_file.dmc02,
     g_wc,g_sql          STRING  #No.FUN-580092 HCN  
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE g_before_input_done   STRING
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680097 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680097 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680097 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680097 INTEGER
DEFINE   g_str          STRING        #NO.FUN-770008
DEFINE   l_table        STRING        #NO.FUN-770008
DEFINE   l_sql          STRING        #NO.FUN-770008
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680097 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0100
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
    #NO.FUN-770008  ---------------begin-----------
    LET g_sql = " dmc01.dmc_file.dmc01,",
                " dmc02.dmc_file.dmc02,",
                " dmc03.dmc_file.dmc03,",
                " dmc12.dmc_file.dmc12,",
                " dmc21.dmc_file.dmc21,",
                " dmc04.dmc_file.dmc04,",
                " dmc13.dmc_file.dmc13,",
                " dmc05.dmc_file.dmc05,",
                " dmc14.dmc_file.dmc14,",
                " dmc06.dmc_file.dmc06,",
                " dmc15.dmc_file.dmc15,",
                " dmc07.dmc_file.dmc07,",
                " dmc16.dmc_file.dmc16,",
                " dmc08.dmc_file.dmc08,",
                " dmc17.dmc_file.dmc17,",
                " dmc09.dmc_file.dmc09,",
                " dmc18.dmc_file.dmc18,",
                " dmc10.dmc_file.dmc10,",
                " dmc19.dmc_file.dmc19,",
                " dmc11.dmc_file.dmc11,",
                " dmc20.dmc_file.dmc20,",
                " l_dma02.dma_file.dma02,",
                " l_dmb02.dmb_file.dmb02"
    LET l_table = cl_prt_temptable('admi202',g_sql) CLIPPED
    IF  l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
           CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
    #NO.FUN_770008  ---------------end ------------
    INITIALIZE g_dmc.* TO NULL
    INITIALIZE g_dmc_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM dmc_file WHERE dmc01 = ? AND dmc02 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i202_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW i202_w AT p_row,p_col WITH FORM "adm/42f/admi202"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i202_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i202_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
FUNCTION i202_cs()
    CLEAR FORM
   INITIALIZE g_dmc.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        dmc01, dmc02,
        dmc03, dmc04, dmc05, dmc06, dmc07, dmc08, dmc09, dmc10,
        dmc11, dmc12, dmc13, dmc14, dmc15, dmc16, dmc17, dmc18,
        dmc19, dmc20,
        dmc21
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(dmc01) #類別
#                 CALL q_dma(0,0,g_dmc.dmc01) RETURNING g_dmc.dmc01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_dma"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_dmc.dmc01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO dmc01
                  NEXT FIELD dmc01
               WHEN INFIELD(dmc02) #版本
#                 CALL q_dmb(0,0,g_dmc.dmc02) RETURNING g_dmc.dmc02
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_dmb"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_dmc.dmc02
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO dmc02
                  NEXT FIELD dmc02
               OTHERWISE EXIT CASE
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('dmcuser', 'dmcgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT dmc01,dmc02 FROM dmc_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY dmc01,dmc02"
    PREPARE i202_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i202_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i202_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM dmc_file WHERE ",g_wc CLIPPED
    PREPARE i202_recount FROM g_sql
    DECLARE i202_count CURSOR FOR i202_recount
END FUNCTION
 
FUNCTION i202_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i202_a()
         END IF
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i202_q()
         END IF
      ON ACTION next
         CALL i202_fetch('N')
      ON ACTION previous
         CALL i202_fetch('P')
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i202_u()
         END IF
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i202_r()
         END IF
      ON ACTION output
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
            CALL i202_out()
         END IF
      ON ACTION help
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        EXIT MENU
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
#     ON ACTION jump
#        CALL i202_fetch('/')
#     ON ACTION first
#        CALL i202_fetch('F')
#     ON ACTION last
#        CALL i202_fetch('L')
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #No.FUN-6A0150-------add--------str----
      ON ACTION related_document             #相關文件"                        
       LET g_action_choice="related_document"           
          IF cl_chk_act_auth() THEN                     
             IF g_dmc.dmc01 IS NOT NULL THEN            
                LET g_doc.column1 = "dmc01"               
                LET g_doc.column2 = "dmc02"               
                LET g_doc.value1 = g_dmc.dmc01            
                LET g_doc.value2 = g_dmc.dmc02           
                CALL cl_doc()                             
             END IF                                        
          END IF                                           
       #No.FUN-6A0150-------add--------end----
 
         LET g_action_choice = "exit"
         CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i202_cs
END FUNCTION
 
 
 
FUNCTION i202_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_dmc.* LIKE dmc_file.*
    LET g_dmc_t.* = g_dmc.*
    LET g_dmc01_t = NULL
    LET g_dmc02_t = NULL
    LET g_dmc.dmc03=0 LET g_dmc.dmc04=0 LET g_dmc.dmc05=0 LET g_dmc.dmc06=0
    LET g_dmc.dmc07=0 LET g_dmc.dmc08=0 LET g_dmc.dmc09=0 LET g_dmc.dmc10=0
    LET g_dmc.dmc11=0 LET g_dmc.dmc12=0 LET g_dmc.dmc13=0 LET g_dmc.dmc14=0
    LET g_dmc.dmc15=0 LET g_dmc.dmc16=0 LET g_dmc.dmc17=0 LET g_dmc.dmc18=0
    LET g_dmc.dmc19=0 LET g_dmc.dmc20=0 LET g_dmc.dmc21=0
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i202_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_dmc.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_dmc.dmc01)  THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF cl_null(g_dmc.dmc02)  THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_dmc.dmcoriu = g_user      #No.FUN-980030 10/01/04
        LET g_dmc.dmcorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO dmc_file VALUES(g_dmc.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            LET g_msg=g_dmc.dmc01 CLIPPED,'+',g_dmc.dmc02
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660090
            CALL cl_err3("ins","dmc_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660090
            CONTINUE WHILE
        ELSE
            LET g_dmc_t.* = g_dmc.*                # 保存上筆資料
            SELECT dmc01,dmc02 INTO g_dmc.dmc01,g_dmc.dmc02 FROM dmc_file
             WHERE dmc01 = g_dmc.dmc01 AND dmc02 = g_dmc.dmc02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i202_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680097 VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #判斷必要欄位之值是否有輸入        #No.FUN-680097 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680097 SMALLINT
 
    INPUT BY NAME
        g_dmc.dmc01,g_dmc.dmc02,
        g_dmc.dmc03,g_dmc.dmc04,g_dmc.dmc05,g_dmc.dmc06,g_dmc.dmc07,
        g_dmc.dmc08,g_dmc.dmc09,g_dmc.dmc10,g_dmc.dmc11,g_dmc.dmc12,
        g_dmc.dmc13,g_dmc.dmc14,g_dmc.dmc15,g_dmc.dmc16,g_dmc.dmc17,
        g_dmc.dmc18,g_dmc.dmc19,g_dmc.dmc20,g_dmc.dmc21
       WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i202_set_entry(p_cmd)
           CALL i202_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        BEFORE FIELD dmc02
            IF g_dmc01_t IS NULL OR (g_dmc.dmc01 != g_dmc01_t ) THEN
               CALL i202_dmc01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_dmc.dmc01,g_errno,0)
                  LET g_dmc.dmc01 = g_dmc01_t
                  DISPLAY BY NAME g_dmc.dmc01
                  NEXT FIELD dmc01
               END IF
            END IF
        AFTER FIELD dmc02
          IF g_dmc.dmc02 IS NOT NULL THEN
             CALL i202_dmc02('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_dmc.dmc01,g_errno,0)
                LET g_dmc.dmc01 = g_dmc01_t
                DISPLAY BY NAME g_dmc.dmc01
                NEXT FIELD dmc01
             END IF
             IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (g_dmc.dmc01 != g_dmc01_t OR
                                g_dmc.dmc02 != g_dmc02_t)) THEN
              SELECT count(*) INTO l_n FROM dmc_file
               WHERE dmc01 = g_dmc.dmc01 AND dmc02 = g_dmc.dmc02
               IF l_n > 0 THEN                  # Duplicated
                 LET g_msg=g_dmc.dmc01 CLIPPED,'+',g_dmc.dmc02
                 CALL cl_err(g_msg,-239,0)
                 LET g_dmc.dmc01 = g_dmc01_t
                 LET g_dmc.dmc02 = g_dmc02_t
                 DISPLAY BY NAME g_dmc.dmc01
                 DISPLAY BY NAME g_dmc.dmc02
                 NEXT FIELD dmc02
               END IF
             END IF
          END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_dmc.dmc01) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_dmc.dmc01
            END IF
            IF cl_null(g_dmc.dmc02) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_dmc.dmc02
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0) NEXT FIELD dmc01
            END IF
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(dmc01) THEN
        #        LET g_dmc.* = g_dmc_t.*
        #        DISPLAY BY NAME g_dmc.*
        #        NEXT FIELD dmc01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(dmc01) #類別
#                 CALL q_dma(0,0,g_dmc.dmc01) RETURNING g_dmc.dmc01
#                 CALL FGL_DIALOG_SETBUFFER( g_dmc.dmc01 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_dma"
                  LET g_qryparam.default1 = g_dmc.dmc01
                  CALL cl_create_qry() RETURNING g_dmc.dmc01
#                  CALL FGL_DIALOG_SETBUFFER( g_dmc.dmc01 )
                  DISPLAY BY NAME g_dmc.dmc01
                  NEXT FIELD dmc01
               WHEN INFIELD(dmc02) #版本
#                 CALL q_dmb(0,0,g_dmc.dmc02) RETURNING g_dmc.dmc02
#                 CALL FGL_DIALOG_SETBUFFER( g_dmc.dmc02 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_dmb"
                  LET g_qryparam.default1 = g_dmc.dmc02
                  CALL cl_create_qry() RETURNING g_dmc.dmc02
#                  CALL FGL_DIALOG_SETBUFFER( g_dmc.dmc02 )
                  DISPLAY BY NAME g_dmc.dmc02
                  NEXT FIELD dmc02
               OTHERWISE EXIT CASE
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i202_dmc01(p_cmd)
DEFINE
    p_cmd        LIKE type_file.chr1,          #No.FUN-680097 VARCHAR(1)
    l_dma02      LIKE dma_file.dma02,
    l_dmaacti    LIKE dma_file.dmaacti
 
    LET g_errno = ' '
    SELECT dma02,dmaacti
      INTO l_dma02,l_dmaacti
      FROM dma_file WHERE dma01 = g_dmc.dmc01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'adm-001'
                                   LET l_dma02 = NULL
         WHEN l_dmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd ='d' OR cl_null(g_errno) THEN
       DISPLAY l_dma02 TO FORMONLY.dma02
    END IF
END FUNCTION
 
FUNCTION i202_dmc02(p_cmd)
DEFINE
    p_cmd        LIKE type_file.chr1,          #No.FUN-680097 VARCHAR(1)
    l_dmb02      LIKE dmb_file.dmb02,
    l_dmbacti    LIKE dmb_file.dmbacti
 
    LET g_errno = ' '
    SELECT dmb02,dmbacti
      INTO l_dmb02,l_dmbacti
      FROM dmb_file WHERE dmb01 = g_dmc.dmc02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'adm-002'
                                   LET l_dmb02 = NULL
         WHEN l_dmbacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd ='d' OR cl_null(g_errno) THEN
       DISPLAY l_dmb02 TO FORMONLY.dmb02
    END IF
END FUNCTION
 
FUNCTION i202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_dmc.* TO NULL              #No.FUN-6A0150
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i202_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " Searching! "
# genero mark g_query    IF g_query='Y' THEN                         #顯示合乎條件筆數
        OPEN i202_count
        FETCH i202_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
# genero mark g_query    END IF
    OPEN i202_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_dmc.dmc01 CLIPPED,'+',g_dmc.dmc02
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_dmc.* TO NULL
    ELSE
        CALL i202_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i202_fetch(p_fldmc)
    DEFINE
        p_fldmc         LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(1)
        l_abso          LIKE type_file.num10             #No.FUN-680097 INTEGER
 
    CASE p_fldmc
        WHEN 'N' FETCH NEXT     i202_cs INTO g_dmc.dmc01,
                                             g_dmc.dmc02
        WHEN 'P' FETCH PREVIOUS i202_cs INTO g_dmc.dmc01,
                                             g_dmc.dmc02
        WHEN 'F' FETCH FIRST    i202_cs INTO g_dmc.dmc01,
                                             g_dmc.dmc02
        WHEN 'L' FETCH LAST     i202_cs INTO g_dmc.dmc01,
                                             g_dmc.dmc02
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso i202_cs INTO g_dmc.dmc01,
                                               g_dmc.dmc02
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_dmc.dmc01 CLIPPED,'+',g_dmc.dmc02
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_dmc.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_fldmc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_dmc.* FROM dmc_file            # 重讀DB,因TEMP有不被更新特性
       WHERE dmc01 = g_dmc.dmc01 AND dmc02 = g_dmc.dmc02
    IF SQLCA.sqlcode THEN
        LET g_msg=g_dmc.dmc01 CLIPPED,'+',g_dmc.dmc02
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660090
        CALL cl_err3("sel","dmc_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660090
    ELSE
 
        CALL i202_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i202_show()
    LET g_dmc_t.* = g_dmc.*
    DISPLAY BY NAME g_dmc.dmc01,g_dmc.dmc02,
    g_dmc.dmc03,g_dmc.dmc04,g_dmc.dmc05,g_dmc.dmc06,g_dmc.dmc07,g_dmc.dmc08,
    g_dmc.dmc09,g_dmc.dmc10,g_dmc.dmc11,g_dmc.dmc12,g_dmc.dmc13,g_dmc.dmc14,
    g_dmc.dmc15,g_dmc.dmc16,g_dmc.dmc17,g_dmc.dmc18,g_dmc.dmc19,g_dmc.dmc20,
    g_dmc.dmc21
 
    CALL i202_dmc01('d')
    CALL i202_dmc02('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i202_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_dmc.dmc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_dmc01_t = g_dmc.dmc01
    LET g_dmc02_t = g_dmc.dmc02
    BEGIN WORK
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN i202_cl USING g_dmc.dmc01,g_dmc.dmc02
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN i202_cl:", STATUS, 1)
       CLOSE i202_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i202_cl INTO g_dmc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        LET g_msg=g_dmc.dmc01 CLIPPED,'+',g_dmc.dmc02
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i202_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i202_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_dmc.*=g_dmc_t.*
            CALL i202_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE dmc_file SET dmc_file.* = g_dmc.*    # 更新DB
            WHERE dmc01 = g_dmc.dmc01 AND dmc02 = g_dmc.dmc02             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_msg=g_dmc.dmc01 CLIPPED,'+',g_dmc.dmc02
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660090
            CALL cl_err3("upd","dmc_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660090
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i202_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i202_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680097 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_dmc.dmc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN i202_cl USING g_dmc.dmc01,g_dmc.dmc02
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN i202_cl:", STATUS, 1)
       CLOSE i202_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i202_cl INTO g_dmc.*
    IF SQLCA.sqlcode THEN
        LET g_msg=g_dmc.dmc01 CLIPPED,'+',g_dmc.dmc02
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i202_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "dmc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "dmc02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_dmc.dmc01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_dmc.dmc02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM dmc_file WHERE dmc01 = g_dmc.dmc01 AND dmc02 = g_dmc.dmc02
        IF SQLCA.SQLERRD[3]=0 THEN
            LET g_msg=g_dmc.dmc01 CLIPPED,'+',g_dmc.dmc02
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660090
            CALL cl_err3("del","dmc_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660090
        ELSE
           CLEAR FORM
        END IF
    END IF
    CLOSE i202_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i202_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680097 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680097 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,       #        #No.FUN-680097 VARCHAR(40)
        l_chr           LIKE type_file.chr1,          #No.FUN-680097 VARCHAR(1)
        sr              RECORD LIKE dmc_file.*
    DEFINE  l_dma02     LIKE dma_file.dma02
    DEFINE  l_dmb02     LIKE dmb_file.dmb02
    #改成印當下的那一筆資料內容
    IF g_wc IS NULL THEN
#       CALL cl_err('','9057',0) RETURN
       IF cl_null(g_dmc.dmc01) THEN
          CALL cl_err('','9057',0) RETURN
       ELSE
          LET g_wc=" dmc01='",g_dmc.dmc01,"'"
       END IF
       IF NOT cl_null(g_dmc.dmc02) THEN
          LET g_wc=g_wc," and dmc02='",g_dmc.dmc02,"'"
       END IF
    END IF
    CALL cl_wait()
#   CALL cl_outnam('admi202') RETURNING l_name           #NO.FUN-770008
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'admi202'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM dmc_file WHERE ",g_wc CLIPPED
    PREPARE i202_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i202_co CURSOR FOR i202_p1
 
#   START REPORT i202_rep TO l_name         #NO.FUN-770008
    CALL cl_del_data(l_table)               #NO.FUN-770008
    FOREACH i202_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#NO.FUN-=770008  -----------begin-------------       
            SELECT dma02 INTO l_dma02 FROM dma_file WHERE dma01 = sr.dmc01
            IF SQLCA.sqlcode THEN LET l_dma02 = ' ' END IF
            SELECT dmb02 INTO l_dmb02 FROM dmb_file WHERE dmb01 = sr.dmc01
            IF SQLCA.sqlcode THEN LET l_dmb02 = ' ' END IF
            EXECUTE insert_prep USING sr.dmc01,sr.dmc02,
                                      sr.dmc03,sr.dmc12,
                                      sr.dmc21,sr.dmc04,
                                      sr.dmc13,sr.dmc05,
                                      sr.dmc14,sr.dmc06,
                                      sr.dmc15,sr.dmc07,
                                      sr.dmc16,sr.dmc08,
                                      sr.dmc17,sr.dmc09,
                                      sr.dmc18,sr.dmc10,
                                      sr.dmc19,sr.dmc11,
                                      sr.dmc20,l_dma02,
                                      l_dmb02
#NO.FUN-770008   ----------end----------------------
#       OUTPUT TO REPORT i202_rep(sr.*)   #NO.FUN-770008
    END FOREACH
#No.FUN-770008---Begin   
#   FINISH REPORT i202_rep               
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'dmc01, dmc02,                                                           
        dmc03, dmc04, dmc05, dmc06, dmc07, dmc08, dmc09, dmc10,                 
        dmc11, dmc12, dmc13, dmc14, dmc15, dmc16, dmc17, dmc18,                 
        dmc19, dmc20,                                                           
        dmc21       ')                                  
       RETURNING g_str                                                     
    END IF   
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
    CALL cl_prt_cs3('admi202','admi202',l_sql,g_str)      
#No.FUN-770008---End
    CLOSE i202_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)     #NO.FUN-770008
 
END FUNCTION
 
#NO.FUN-770008  -------begin-----
{REPORT i202_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680097 VARCHAR(1)
        l_chr           LIKE type_file.chr1,          #No.FUN-680097 VARCHAR(1)
        l_dma02         LIKE dma_file.dma02,
        l_dmb02         LIKE dmb_file.dmb02,
        sr              RECORD LIKE dmc_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.dmc01,sr.dmc02
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today ,' ',TIME,
                COLUMN g_len-8,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            SELECT dma02 INTO l_dma02 FROM dma_file WHERE dma01 = sr.dmc01
            IF SQLCA.sqlcode THEN LET l_dma02 = ' ' END IF
            SELECT dmb02 INTO l_dmb02 FROM dmb_file WHERE dmb01 = sr.dmc01
            IF SQLCA.sqlcode THEN LET l_dmb02 = ' ' END IF
            PRINT COLUMN 05,g_x[11] CLIPPED,sr.dmc01,l_dma02
            PRINT COLUMN 05,g_x[12] CLIPPED,sr.dmc02,l_dmb02
            PRINT ' '
            PRINT COLUMN 01,g_x[13] CLIPPED,COLUMN 22,sr.dmc03 USING'##&.&&&',
                  COLUMN 31,g_x[14] CLIPPED,COLUMN 47,sr.dmc12 USING'##&.&&&',
                  COLUMN 56,g_x[15] CLIPPED,COLUMN 71,sr.dmc21 USING'##&.&&&'
            PRINT COLUMN 01,g_x[16] CLIPPED,COLUMN 22,sr.dmc04 USING'##&.&&&',
                  COLUMN 31,g_x[17] CLIPPED,COLUMN 47,sr.dmc13 USING'##&.&&&'
            PRINT COLUMN 01,g_x[18] CLIPPED,COLUMN 22,sr.dmc05 USING'##&.&&&',
                  COLUMN 31,g_x[19] CLIPPED,COLUMN 47,sr.dmc14 USING'##&.&&&'
            PRINT COLUMN 01,g_x[20] CLIPPED,COLUMN 22,sr.dmc06 USING'##&.&&&',
                  COLUMN 31,g_x[21] CLIPPED,COLUMN 47,sr.dmc15 USING'##&.&&&'
            PRINT COLUMN 01,g_x[22] CLIPPED,COLUMN 22,sr.dmc07 USING'##&.&&&',
                  COLUMN 31,g_x[23] CLIPPED,COLUMN 47,sr.dmc16 USING'##&.&&&'
            PRINT COLUMN 01,g_x[24] CLIPPED,COLUMN 22,sr.dmc08 USING'##&.&&&',
                  COLUMN 31,g_x[25] CLIPPED,COLUMN 47,sr.dmc17 USING'##&.&&&'
            PRINT COLUMN 01,g_x[26] CLIPPED,COLUMN 22,sr.dmc09 USING'##&.&&&',
                  COLUMN 31,g_x[27] CLIPPED,COLUMN 47,sr.dmc18 USING'##&.&&&'
            PRINT COLUMN 01,g_x[28] CLIPPED,COLUMN 22,sr.dmc10 USING'##&.&&&',
                  COLUMN 31,g_x[29] CLIPPED,COLUMN 47,sr.dmc19 USING'##&.&&&'
            PRINT COLUMN 01,g_x[30] CLIPPED,COLUMN 22,sr.dmc11 USING'##&.&&&',
                  COLUMN 31,g_x[31] CLIPPED,COLUMN 47,sr.dmc20 USING'##&.&&&'
            PRINT ""
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
#NO.FUN-770008 -----------end--------------
 
FUNCTION i202_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680097 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("dmc01,dmc02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i202_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680097 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("dmc01,dmc02",FALSE)
   END IF
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
