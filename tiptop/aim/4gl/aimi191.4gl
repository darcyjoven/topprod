# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimi191.4gl
# Descriptions...: 品名種類資料維護作業
# Date & Author..: 92/02/11 By Lin
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-590040 05/10/17 By Rosayu 第二次複製有錯.
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"#
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6C0023 06/12/06 By Judy  六段位報錯信息修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: NO.FUN-840020 08/04/07 By zhaijie 報表輸出格式改為CR
# Modify.........: NO.FUN-930083 09/08/12 By arman   品名種類欄位改為開窗查詢功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-B20119 11/02/21 by destiny 没有显示modu    
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询  
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_imu               RECORD LIKE imu_file.*,
    g_imu_t             RECORD LIKE imu_file.*,
    g_imu_o             RECORD LIKE imu_file.*,
    g_imu01_t           LIKE imu_file.imu01,
    g_wc,g_sql          STRING,                 #TQC-630166
    g_rec_b             LIKE type_file.num5     #單身筆數  #No.FUN-690026 SMALLINT
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
#NO.FUN-840020---start---
DEFINE l_table        STRING
DEFINE g_str          STRING
#NO.FUN-840020---end----
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
    IF g_sma.sma64='N' THEN
       CALL cl_err(g_sma.sma64,'mfg0061',3)
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
#NO.FUN-840020---start----
    LET g_sql = "imu01.imu_file.imu01,",
                "imu02.imu_file.imu02,",
                "imu11.imu_file.imu11,",
                "imu12.imu_file.imu12,",
                "imu21.imu_file.imu11,",
                "imu22.imu_file.imu12,",
                "imu31.imu_file.imu11,",
                "imu32.imu_file.imu12,",
                "imu41.imu_file.imu11,",
                "imu42.imu_file.imu12,",
                "imu51.imu_file.imu11,",
                "imu52.imu_file.imu12,",
                "imu61.imu_file.imu11,",
                "imu62.imu_file.imu12,",
                "imuacti.imu_file.imuacti"
   LET l_table = cl_prt_temptable('aimi191',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM
   END IF         
#NO.FUN-840020---end----
    INITIALIZE g_imu.* TO NULL
    INITIALIZE g_imu_t.* TO NULL
    INITIALIZE g_imu_o.* TO NULL
 
 
    LET g_forupd_sql = "SELECT * FROM imu_file WHERE imu01 = ? FOR UPDATE"
 
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i301_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
       LET p_row = 5 LET p_col = 4
 
    OPEN WINDOW i301_w AT p_row,p_col
        WITH FORM "aim/42f/aimi191"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    WHILE TRUE
      LET g_action_choice=""
    CALL i301_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW i301_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION i301_cs()
    CLEAR FORM
    INITIALIZE g_imu.* TO NULL     #FUN-640213 add
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        imu01,imu02,imu11,imu12,imu21,imu22,imu31,imu32,
        imu41,imu42,imu51,imu52,imu61,imu62,
        imuuser,imugrup,imumodu,imudate,imuacti
        ,imuoriu,imuorig  #TQC-B90177
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        #No.FUN-930083  --begin-- 
        ON ACTION controlp
            CASE
               WHEN INFIELD(imu01) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_imu"
                  LET g_qryparam.default1 = g_imu.imu01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imu01
                  NEXT FIELD imu01
        #No.FUN-930083  --end-- 
               WHEN INFIELD(imu12) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu12
#                 CALL cl_create_qry() RETURNING g_imu.imu12
#                 DISPLAY BY NAME g_imu.imu12
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imu12
                  NEXT FIELD imu12
               WHEN INFIELD(imu22) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu22
#                 CALL cl_create_qry() RETURNING g_imu.imu22
#                 DISPLAY BY NAME g_imu.imu22
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imu22
                  NEXT FIELD imu22
               WHEN INFIELD(imu32) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu32
#                 CALL cl_create_qry() RETURNING g_imu.imu32
#                 DISPLAY BY NAME g_imu.imu32
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imu32
                  NEXT FIELD imu32
               WHEN INFIELD(imu42) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu42
#                 CALL cl_create_qry() RETURNING g_imu.imu42
#                 DISPLAY BY NAME g_imu.imu42
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imu42
                  NEXT FIELD imu42
               WHEN INFIELD(imu52) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu52
#                 CALL cl_create_qry() RETURNING g_imu.imu52
#                 DISPLAY BY NAME g_imu.imu52
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imu52
                  NEXT FIELD imu52
               WHEN INFIELD(imu62) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu62
#                 CALL cl_create_qry() RETURNING g_imu.imu62
#                 DISPLAY BY NAME g_imu.imu62
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imu26
                  NEXT FIELD imu62
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
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imuuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imugrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND imugrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imuuser', 'imugrup')
    #End:FUN-980030
 
    LET g_sql="SELECT imu01 FROM imu_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY imu01"
    PREPARE i301_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i301_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i301_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM imu_file WHERE ",g_wc CLIPPED
    PREPARE i301_precount FROM g_sql
    DECLARE i301_count CURSOR FOR i301_precount
END FUNCTION
 
FUNCTION i301_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i301_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i301_q()
            END IF
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i301_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                CALL i301_x()
                CALL cl_set_field_pic("","","","","",g_imu.imuacti)
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i301_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i301_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i301_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_imu.imuacti)
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
      ON ACTION first
         CALL i301_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION previous
         CALL i301_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION jump
         CALL i301_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION next
         CALL i301_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION last
         CALL i301_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #相關文件"
      ON ACTION related_document       #No.FUN-680046
          LET g_action_choice="related_document"
              IF cl_chk_act_auth() THEN
                 IF g_imu.imu01 IS NOT NULL THEN
                  LET g_doc.column1 = "imu01"
                  LET g_doc.value1 = g_imu.imu01
                  CALL cl_doc()
              END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i301_cs
END FUNCTION
 
 
FUNCTION i301_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_imu.* LIKE imu_file.*
    LET g_imu01_t = NULL
#%  LET g_imu.xxxx = 0				# DEFAULT
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_imu.imuacti ='Y'                   #有效的資料
        LET g_imu.imuuser = g_user
        LET g_imu.imuoriu = g_user #FUN-980030
        LET g_imu.imuorig = g_grup #FUN-980030
        LET g_imu.imugrup = g_grup               #使用者所屬群
        LET g_imu.imudate = g_today
        CALL i301_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_imu.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_imu.imu01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO imu_file VALUES(g_imu.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_imu.imu01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("ins","imu_file",g_imu.imu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        ELSE
            LET g_imu_t.* = g_imu.*                # 保存上筆資料
            SELECT imu01 INTO g_imu.imu01 FROM imu_file
                WHERE imu01 = g_imu.imu01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i301_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
        l_num           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_n             LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
    DISPLAY BY NAME g_imu.imuoriu,g_imu.imuorig,g_imu.imuuser,g_imu.imugrup,
        g_imu.imudate, g_imu.imuacti
    INPUT BY NAME 
        g_imu.imu01,g_imu.imu02, g_imu.imu11,g_imu.imu12,
        g_imu.imu21,g_imu.imu22, g_imu.imu31,g_imu.imu32,
        g_imu.imu41,g_imu.imu42, g_imu.imu51,g_imu.imu52,
        g_imu.imu61,g_imu.imu62
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i191_set_entry(p_cmd)
         CALL i191_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#genero
{
        BEFORE FIELD imu01
            IF p_cmd='u' AND g_chkey = 'N' THEN NEXT FIELD imu02 END IF
}
        AFTER FIELD imu01
          IF g_imu.imu01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_imu.imu01 != g_imu01_t) THEN
                SELECT count(*) INTO l_n FROM imu_file
                    WHERE imu01 = g_imu.imu01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_imu.imu01,-239,0)
                    LET g_imu.imu01 = g_imu01_t
                    DISPLAY BY NAME g_imu.imu01
                    NEXT FIELD imu01
                END IF
            END IF
          END IF
 
        AFTER FIELD imu11  #第一段位數
            IF g_imu.imu11 IS NOT NULL THEN
               IF g_imu.imu11 <= 0 OR g_imu.imu11 > 30 THEN
                  CALL cl_err(g_imu.imu11,'aim-931',0)   #TQC-6C0023
                  LET g_imu.imu11 = g_imu_o.imu11
                  DISPLAY BY NAME g_imu.imu11
                  NEXT FIELD imu11
               END IF
            END IF
            LET g_imu_o.imu11=g_imu.imu11
 
        AFTER FIELD imu12  #細部品名碼
            IF g_imu.imu12 IS NOT NULL THEN
              IF (g_imu_o.imu12 IS NULL) OR (g_imu.imu12 != g_imu_o.imu12)
                  OR (g_imu.imu11 != g_imu_t.imu11) #因更改位數,亦要判斷
                 THEN
                    CALL i301_imu('a',g_imu.imu12,g_imu.imu11)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_imu.imu12,g_errno,0)
                        LET g_imu.imu12 = g_imu_o.imu12
                        DISPLAY BY NAME g_imu.imu12
                        NEXT FIELD imu12
                    END IF
                END IF
            END IF
            LET g_imu_o.imu12 = g_imu.imu12
 
        AFTER FIELD imu21  #第二段位數
            IF g_imu.imu21 IS NOT NULL THEN
               IF g_imu.imu21 <= 0 OR g_imu.imu21 > 30 THEN
                  CALL cl_err(g_imu.imu21,'aim-931',0)  #TQC-6C0023
                  LET g_imu.imu21 = g_imu_o.imu21
                  DISPLAY BY NAME g_imu.imu21
                  NEXT FIELD imu21
               END IF
            END IF
            LET g_imu_o.imu21=g_imu.imu21
 
        AFTER FIELD imu22  #細部品名碼
            IF g_imu.imu22 IS NOT NULL THEN
              IF (g_imu_o.imu22 IS NULL) OR (g_imu.imu22 != g_imu_o.imu22)
                  OR (g_imu.imu21 != g_imu_t.imu21) #因更改位數,亦要判斷
                 THEN
                    CALL i301_imu('a',g_imu.imu22,g_imu.imu21)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_imu.imu22,g_errno,0)
                        LET g_imu.imu22 = g_imu_o.imu22
                        DISPLAY BY NAME g_imu.imu22
                        NEXT FIELD imu22
                    END IF
                END IF
            END IF
            LET g_imu_o.imu22 = g_imu.imu22
 
        AFTER FIELD imu31  #第三段位數
            IF g_imu.imu31 IS NOT NULL THEN
               IF g_imu.imu31 <= 0 OR g_imu.imu31 > 30 THEN
                  CALL cl_err(g_imu.imu31,'aim-931',0)    #TQC-6C0023
                  LET g_imu.imu31 = g_imu_o.imu31
                  DISPLAY BY NAME g_imu.imu31
                  NEXT FIELD imu31
               END IF
            END IF
            LET g_imu_o.imu31=g_imu.imu31
 
        AFTER FIELD imu32  #細部品名碼
            IF g_imu.imu32 IS NOT NULL THEN
              IF (g_imu_o.imu32 IS NULL) OR (g_imu.imu32 != g_imu_o.imu32)
                  OR (g_imu.imu31 != g_imu_t.imu31) #因更改位數,亦要判斷
                 THEN
                    CALL i301_imu('a',g_imu.imu32,g_imu.imu31)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_imu.imu32,g_errno,0)
                        LET g_imu.imu32 = g_imu_o.imu32
                        DISPLAY BY NAME g_imu.imu32
                        NEXT FIELD imu32
                    END IF
                END IF
            END IF
            LET g_imu_o.imu32 = g_imu.imu32
 
        AFTER FIELD imu41  #第四段位數
            IF g_imu.imu41 IS NOT NULL THEN
               IF g_imu.imu41 <= 0 OR g_imu.imu41 > 30 THEN
                  CALL cl_err(g_imu.imu41,'aim-931',0)   #TQC-6C0023
                  LET g_imu.imu41 = g_imu_o.imu41
                  DISPLAY BY NAME g_imu.imu41
                  NEXT FIELD imu41
               END IF
            END IF
            LET g_imu_o.imu41=g_imu.imu41
 
        AFTER FIELD imu42  #細部品名碼
            IF g_imu.imu42 IS NOT NULL THEN
              IF (g_imu_o.imu42 IS NULL) OR (g_imu.imu42 != g_imu_o.imu42)
                  OR (g_imu.imu41 != g_imu_t.imu41) #因更改位數,亦要判斷
                 THEN
                    CALL i301_imu('a',g_imu.imu42,g_imu.imu41)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_imu.imu42,g_errno,0)
                        LET g_imu.imu42 = g_imu_o.imu42
                        DISPLAY BY NAME g_imu.imu42
                        NEXT FIELD imu42
                    END IF
                END IF
            END IF
            LET g_imu_o.imu42 = g_imu.imu42
 
        AFTER FIELD imu51  #第五段位數
            IF g_imu.imu51 IS NOT NULL THEN
               IF g_imu.imu51 <= 0 OR g_imu.imu51 > 30 THEN
                  CALL cl_err(g_imu.imu51,'aim-931',0)   #TQC-6C0023
                  LET g_imu.imu51 = g_imu_o.imu51
                  DISPLAY BY NAME g_imu.imu51
                  NEXT FIELD imu51
               END IF
            END IF
            LET g_imu_o.imu51=g_imu.imu51
 
        AFTER FIELD imu52  #細部品名碼
            IF g_imu.imu52 IS NOT NULL THEN
              IF (g_imu_o.imu52 IS NULL) OR (g_imu.imu52 != g_imu_o.imu52)
                  OR (g_imu.imu51 != g_imu_t.imu51) #因更改位數,亦要判斷
                 THEN
                    CALL i301_imu('a',g_imu.imu52,g_imu.imu51)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_imu.imu52,g_errno,0)
                        LET g_imu.imu52 = g_imu_o.imu52
                        DISPLAY BY NAME g_imu.imu52
                        NEXT FIELD imu52
                    END IF
                END IF
            END IF
            LET g_imu_o.imu52 = g_imu.imu52
 
        AFTER FIELD imu61  #第六段位數
            IF g_imu.imu61 IS NOT NULL THEN
               IF g_imu.imu61 <= 0 OR g_imu.imu61 > 30 THEN
                  CALL cl_err(g_imu.imu61,'aim-931',0)    #TQC-6C0023
                  LET g_imu.imu61 = g_imu_o.imu61
                  DISPLAY BY NAME g_imu.imu61
                  NEXT FIELD imu61
               END IF
            END IF
            LET g_imu_o.imu61=g_imu.imu61
 
        AFTER FIELD imu62  #細部品名碼
            IF g_imu.imu62 IS NOT NULL THEN
              IF (g_imu_o.imu62 IS NULL) OR (g_imu.imu62 != g_imu_o.imu62)
                  OR (g_imu.imu61 != g_imu_t.imu61) #因更改位數,亦要判斷
                 THEN
                    CALL i301_imu('a',g_imu.imu62,g_imu.imu61)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_imu.imu62,g_errno,0)
                        LET g_imu.imu62 = g_imu_o.imu62
                        DISPLAY BY NAME g_imu.imu62
                        NEXT FIELD imu62
                    END IF
                END IF
            END IF
            LET g_imu_o.imu62 = g_imu.imu62
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_imu.imuuser = s_get_data_owner("imu_file") #FUN-C10039
           LET g_imu.imugrup = s_get_data_group("imu_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF  g_imu.imu11 IS NULL AND g_imu.imu21 IS NULL AND
                g_imu.imu31 IS NULL AND g_imu.imu41 IS NULL AND
                g_imu.imu51 IS NULL AND g_imu.imu61 IS NULL THEN
                LET l_flag='Y'
                DISPLAY BY NAME g_imu.imu11
            END IF
            LET l_num=0
            IF g_imu.imu11 IS NOT NULL THEN
               LET l_num=l_num+g_imu.imu11 END IF
            IF g_imu.imu21 IS NOT NULL THEN
               LET l_num=l_num+g_imu.imu21 END IF
            IF g_imu.imu31 IS NOT NULL THEN
               LET l_num=l_num+g_imu.imu31 END IF
            IF g_imu.imu41 IS NOT NULL THEN
               LET l_num=l_num+g_imu.imu41 END IF
            IF g_imu.imu51 IS NOT NULL THEN
               LET l_num=l_num+g_imu.imu51 END IF
            IF g_imu.imu61 IS NOT NULL THEN
               LET l_num=l_num+g_imu.imu61 END IF
            IF l_num > 30 THEN    #各段輸入之和不可大於30
               CALL cl_err(l_num,'aim-932',0)   #TQC-6C0023
               NEXT FIELD imu11
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD imu11
            END IF
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(imu01) THEN
        #        LET g_imu.* = g_imu_t.*
        #        DISPLAY BY NAME g_imu.*
        #        NEXT FIELD imu01
        #    END IF
        #MOD-650015 --end 
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(imu12) #
                 #CALL q_imv(7,36,g_imu.imu12) RETURNING g_imu.imu12
                 #CALL FGL_DIALOG_SETBUFFER( g_imu.imu12 )
                 ###############################################################
################
                 #START genero shell script ADD
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu12
                  CALL cl_create_qry() RETURNING g_imu.imu12
#                  CALL FGL_DIALOG_SETBUFFER( g_imu.imu12 )
                 #END genero shell script ADD
                 ###############################################################
################
                  DISPLAY BY NAME g_imu.imu12
                  NEXT FIELD imu12
               WHEN INFIELD(imu22) #
                 #CALL q_imv(7,36,g_imu.imu22) RETURNING g_imu.imu22
                 #CALL FGL_DIALOG_SETBUFFER( g_imu.imu22 )
                 ###############################################################
################
                 #START genero shell script ADD
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu22
                  CALL cl_create_qry() RETURNING g_imu.imu22
#                  CALL FGL_DIALOG_SETBUFFER( g_imu.imu22 )
                 #END genero shell script ADD
                 ###############################################################
################
                  DISPLAY BY NAME g_imu.imu22
                  NEXT FIELD imu22
               WHEN INFIELD(imu32) #
                 #CALL q_imv(7,36,g_imu.imu32) RETURNING g_imu.imu32
                 #CALL FGL_DIALOG_SETBUFFER( g_imu.imu32 )
                 ###############################################################
################
                 #START genero shell script ADD
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu32
                  CALL cl_create_qry() RETURNING g_imu.imu32
#                  CALL FGL_DIALOG_SETBUFFER( g_imu.imu32 )
                 #END genero shell script ADD
                 ###############################################################
################
                  DISPLAY BY NAME g_imu.imu32
                  NEXT FIELD imu32
               WHEN INFIELD(imu42) #
                 #CALL q_imv(7,36,g_imu.imu42) RETURNING g_imu.imu42
                 #CALL FGL_DIALOG_SETBUFFER( g_imu.imu42 )
                 ###############################################################
################
                 #START genero shell script ADD
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu42
                  CALL cl_create_qry() RETURNING g_imu.imu42
#                  CALL FGL_DIALOG_SETBUFFER( g_imu.imu42 )
                 #END genero shell script ADD
                 ###############################################################
################
                  DISPLAY BY NAME g_imu.imu42
                  NEXT FIELD imu42
               WHEN INFIELD(imu52) #
                 #CALL q_imv(7,36,g_imu.imu52) RETURNING g_imu.imu52
                 #CALL FGL_DIALOG_SETBUFFER( g_imu.imu52 )
                 ###############################################################
################
                 #START genero shell script ADD
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu52
                  CALL cl_create_qry() RETURNING g_imu.imu52
#                  CALL FGL_DIALOG_SETBUFFER( g_imu.imu52 )
                 #END genero shell script ADD
                 ###############################################################
################
                  DISPLAY BY NAME g_imu.imu52
                  NEXT FIELD imu52
               WHEN INFIELD(imu62) #
                 #CALL q_imv(7,36,g_imu.imu62) RETURNING g_imu.imu62
                 #CALL FGL_DIALOG_SETBUFFER( g_imu.imu62 )
                 ###############################################################
################
                 #START genero shell script ADD
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imv"
                  LET g_qryparam.default1 = g_imu.imu62
                  CALL cl_create_qry() RETURNING g_imu.imu62
#                  CALL FGL_DIALOG_SETBUFFER( g_imu.imu62 )
                 #END genero shell script ADD
                 ###############################################################
################
                  DISPLAY BY NAME g_imu.imu62
                  NEXT FIELD imu62
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION mntn_detail_part_name #建立細部品名碼
            CALL cl_cmdrun("aimi190")
 
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
 
FUNCTION i301_imu(p_cmd,p_key,p_len)  #細部品名碼
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           p_key     LIKE imv_file.imv01,
           p_len     LIKE imv_file.imv03,
           l_imv02   LIKE imv_file.imv02,
           l_imv03   LIKE imv_file.imv03,
           l_imvacti LIKE imv_file.imvacti
 
    LET g_errno = ' '
    IF p_key IS NULL THEN
        LET l_imv02=NULL
    ELSE
        SELECT imv02,imv03,imvacti
           INTO l_imv02,l_imv03,l_imvacti
           FROM imv_file WHERE imv01 = p_key
        IF SQLCA.sqlcode THEN
            LET g_errno = 'mfg6031'
            LET l_imv02 = NULL
        END IF
        IF l_imvacti='N' THEN
           LET g_errno = '9028'
        END IF
        IF p_len < l_imv03 THEN
           LET g_errno = 'mfg6034'
        END IF
    END IF
  # IF cl_null(g_errno) OR p_cmd = 'd' THEN
  #    DISPLAY l_imv02 TO FORMONLY.imv02
  # END IF
END FUNCTION
 
FUNCTION i301_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i301_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i301_count
    FETCH i301_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i301_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imu.imu01,SQLCA.sqlcode,0)
        INITIALIZE g_imu.* TO NULL
    ELSE
        CALL i301_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i301_fetch(p_flimu)
    DEFINE
        p_flimu         LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-690026 INTEGER
 
    CASE p_flimu
        WHEN 'N' FETCH NEXT     i301_cs INTO g_imu.imu01
        WHEN 'P' FETCH PREVIOUS i301_cs INTO g_imu.imu01
        WHEN 'F' FETCH FIRST    i301_cs INTO g_imu.imu01
        WHEN 'L' FETCH LAST     i301_cs INTO g_imu.imu01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
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
            FETCH ABSOLUTE g_jump i301_cs INTO g_imu.imu01 --改g_jump
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imu.imu01,SQLCA.sqlcode,0)
        INITIALIZE g_imu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flimu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_imu.* FROM imu_file            # 重讀DB,因TEMP有不被更新特性
       WHERE imu01 = g_imu.imu01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imu.imu01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","imu_file",g_imu.imu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_imu.imuuser #FUN-4C0053
        LET g_data_group = g_imu.imugrup #FUN-4C0053
        CALL i301_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i301_show()
    LET g_imu_t.* = g_imu.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_imu.* 
    DISPLAY BY NAME g_imu.imu01,g_imu.imu02,g_imu.imu11,g_imu.imu12,
                    g_imu.imu21,g_imu.imu22,g_imu.imu31,g_imu.imu32,
                    g_imu.imu41,g_imu.imu42,g_imu.imu51,g_imu.imu52,
                    g_imu.imu61,g_imu.imu62,g_imu.imuoriu,g_imu.imuorig,
                    g_imu.imuuser,g_imu.imugrup,g_imu.imudate, g_imu.imuacti,
                    g_imu.imumodu  #TQC-B20119
    #No.FUN-9A0024--end  
    CALL cl_set_field_pic("","","","","",g_imu.imuacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i301_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_imu.imu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_imu.* FROM imu_file WHERE imu01=g_imu.imu01
    IF g_imu.imuacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_imu.imu01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imu01_t = g_imu.imu01
    LET g_imu_o.*=g_imu.*
    BEGIN WORK
 
 
    OPEN i301_cl USING g_imu.imu01
    IF STATUS THEN
       CALL cl_err("OPEN i301_cl:", STATUS, 1)
       CLOSE i301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i301_cl INTO g_imu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imu.imu01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imu.imumodu=g_user                     #修改者
    LET g_imu.imudate = g_today                  #修改日期
    CALL i301_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i301_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imu.*=g_imu_t.*
            CALL i301_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE imu_file SET imu_file.* = g_imu.*    # 更新DB
            WHERE imu01 = g_imu01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_imu.imu01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","imu_file",g_imu_t.imu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i301_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i301_x()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imu.imu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
 
    OPEN i301_cl USING g_imu.imu01
 
    IF STATUS THEN
       CALL cl_err("OPEN i301_cl:", STATUS, 1)
       CLOSE i301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i301_cl INTO g_imu.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imu.imu01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i301_show()
    IF cl_exp(0,0,g_imu.imuacti) THEN
        LET g_chr=g_imu.imuacti
        IF g_imu.imuacti='Y' THEN
            LET g_imu.imuacti='N'
        ELSE
            LET g_imu.imuacti='Y'
        END IF
        UPDATE imu_file
            SET imuacti=g_imu.imuacti,
               imumodu=g_user, imudate=g_today
            WHERE imu01=g_imu.imu01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_imu.imu01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","imu_file",g_imu.imu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           LET g_imu.imuacti=g_chr
        END IF
        DISPLAY BY NAME g_imu.imuacti
    END IF
    CLOSE i301_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i301_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imu.imu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
 
    OPEN i301_cl USING g_imu.imu01
    IF STATUS THEN
       CALL cl_err("OPEN i301_cl:", STATUS, 1)
       CLOSE i301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i301_cl INTO g_imu.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_imu.imu01,SQLCA.sqlcode,0) RETURN END IF
    CALL i301_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imu.imu01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM imu_file WHERE imu01 = g_imu.imu01
        IF SQLCA.SQLERRD[3]=0
           THEN # CALL cl_err(g_imu.imu01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("del","imu_file",g_imu.imu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           ELSE CLEAR FORM
        END IF
         OPEN i301_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i301_cs
             CLOSE i301_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i301_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i301_cs
             CLOSE i301_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i301_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i301_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i301_fetch('/')
         END IF
    END IF
    CLOSE i301_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i301_copy()
   DEFINE l_imu           RECORD LIKE imu_file.*,
          l_oldno,l_newno LIKE imu_file.imu01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imu.imu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_comp_entry("imu01",TRUE) #MOD-590040
    INPUT l_newno FROM imu01
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i191_set_entry('a')
           CALL i191_set_no_entry('a')
           LET g_before_input_done = TRUE
 
        AFTER FIELD imu01
          IF l_newno IS NOT NULL THEN
            SELECT count(*) INTO g_cnt FROM imu_file
                WHERE imu01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD imu01
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
        DISPLAY BY NAME g_imu.imu01
        RETURN
    END IF
    LET l_imu.* = g_imu.*
    LET l_imu.imu01  =l_newno   #資料鍵值
    LET l_imu.imuuser=g_user    #資料所有者
    LET l_imu.imugrup=g_grup    #資料所有者所屬群
    LET l_imu.imumodu=NULL      #資料修改日期
    LET l_imu.imudate=g_today   #資料建立日期
    LET l_imu.imuacti='Y'       #有效資料
    LET l_imu.imuoriu = g_user      #No.FUN-980030 10/01/04
    LET l_imu.imuorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO imu_file VALUES (l_imu.*)
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_newno,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("ins","imu_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_imu.imu01
        SELECT imu_file.* INTO g_imu.* FROM imu_file
                       WHERE imu01 = l_newno
        CALL i301_u()
        #SELECT imu_file.* INTO g_imu.* FROM imu_file  #FUN-C30027
        #               WHERE imu01 = l_oldno          #FUN-C30027
    END IF
    CALL i301_show()
END FUNCTION
 
FUNCTION i301_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_imu           RECORD LIKE imu_file.*,
        l_za05          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(40)
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
   CALL cl_del_data(l_table)                    #NO.FUN-840020
    IF g_wc IS NULL THEN
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#   LET l_name = 'aimi191.out'
#    CALL cl_outnam('aimi191') RETURNING l_name             #NO.FUN-840020
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimi191'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM imu_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i301_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i301_co                         # CURSOR
        CURSOR FOR i301_p1
 
#    START REPORT i301_rep TO l_name                         #NO.FUN-840020
 
    FOREACH i301_co INTO l_imu.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
#        OUTPUT TO REPORT i301_rep(l_imu.*)                 #NO.FUN-840020
#NO.FUN-840020---start----
    EXECUTE insert_prep USING 
      l_imu.imu01,l_imu.imu02,l_imu.imu11,l_imu.imu12,l_imu.imu21,
      l_imu.imu22,l_imu.imu31,l_imu.imu32,l_imu.imu41,l_imu.imu42,
      l_imu.imu51,l_imu.imu52,l_imu.imu61,l_imu.imu62,l_imu.imuacti
#NO.FUN-840020---end----
    END FOREACH
 
#    FINISH REPORT i301_rep                                 #NO.FUN-840020
#NO.FUN-840020---start----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'imu01,imu02,imu11,imu12,imu21,imu22,imu31,imu32,
                            imu41,imu42,imu51,imu52,imu61,imu62,
                            imuuser,imugrup,imumodu,imudate,imuacti')
           RETURNING g_wc
     END IF
     LET g_str = g_wc
     CALL cl_prt_cs3('aimi191','aimi191',g_sql,g_str) 
#NO.FUN-840020---end----
    CLOSE i301_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)                      #NO.FUN-840020
END FUNCTION
#NO.FUN-840020---start----
#REPORT i301_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#        sr              RECORD LIKE imu_file.*,
#        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.imu01
#
#    FORMAT
#        PAGE HEADER
#            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#            PRINT ' '
#            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#          # PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            PRINT g_dash[1,g_len]
#            IF sr.imuacti = 'N' THEN PRINT '*'; END IF
#            PRINT COLUMN 3,g_x[11] CLIPPED,sr.imu01,
#                  COLUMN 25,g_x[12] CLIPPED,sr.imu02
#            SKIP 1 LINE
#            PRINT COLUMN 16,g_x[13] CLIPPED,g_x[14] CLIPPED
#            PRINT COLUMN 16,g_x[17] CLIPPED,g_x[18] CLIPPED
#            PRINT COLUMN 3,g_x[15] CLIPPED,
#                  COLUMN 16,sr.imu11 USING "#&",
#                  COLUMN 25,sr.imu21 USING "#&",
#                  COLUMN 34,sr.imu31 USING "#&",
#                  COLUMN 43,sr.imu41 USING "#&",
#                 COLUMN 52,sr.imu51 USING "#&",
#                  COLUMN 61,sr.imu61 USING "#&"
#            PRINT COLUMN 3,g_x[16] CLIPPED,
#                  COLUMN 16,sr.imu12 , COLUMN 25,sr.imu22 ,
#                  COLUMN 34,sr.imu32 , COLUMN 43,sr.imu42 ,
#                  COLUMN 52,sr.imu52 , COLUMN 61,sr.imu62
#            SKIP 1 LINE
#        ON LAST ROW
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN PRINT g_dash[1,g_len]
                    #TQC-630166
                    #IF g_wc[001,080] > ' ' THEN
		    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                    #IF g_wc[071,140] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                    #IF g_wc[141,210] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                    CALL cl_prt_pos_wc(g_wc)
#                    #END TQC-630166
#            END IF
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#NO.FUN-840020---end------
#genero
FUNCTION i191_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("imu01",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i191_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("imu01",TRUE)
   END IF
 
END FUNCTION
#Patch....NO.TQC-610036 <001,002,003,004> #
#TQC-790177

