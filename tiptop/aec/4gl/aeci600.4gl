# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aeci600.4gl
# Descriptions...: 工作站資料維護作業
# Date & Author..: 91/10/22 Carol
# Modify.........: 99/06/28 By Kammy
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510032 05/01/17 By pengu 報表轉XML
# Modify.........: No.MOD-5A0420 05/12/12 By Pengu 1.工作曆欄位可以key任何值,如XXX應控管
                                             #     2. 再CONSTRUCT時工作曆欄位開窗查詢錯誤
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3                                             
# Modify.........: No.FUN-660193 65/07/01 By Joe 移除APS相關資料Action                                             
# Modify.........: NO.FUN-680010 06/08/11 By Joe SPC整合專案-基本資料傳遞
# Modify.........: No.FUN-680073 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0039 06/10/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740145 07/04/24 By hongmei 修改eca16,eca18,eca20,eca201,eca22欄位不可為負數
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760047 07/06/06 By xufeng  效率調整欄位輸入不能超過100
# Modify.........: No.MOD-770011 07/07/09 By pengu 程式在call 'mfg4017' message的地方,未傳語言別變數
# Modify.........: No.FUN-760085 07/07/12 By sherry  報表改由Crystal Report輸出 
# Modify.........: NO.FUN-7C0002 08/01/08 By Yiting 增加串apsi321.4gl  
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-850115 08/05/21 BY duke
# Modify.........: No.FUN-890085 08/09/18 BY DUKE 刪除時需同步刪除 vmj_file
# Modify.........: No.TQC-950144 09/05/31 By chenyu 無效的資料不可以刪除
# Modify.........: No.TQC-980102 09/08/14 By lilingyu "效率調整"欄位輸入負數不控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0055 09/10/13 By lilingyu "成本比率"未控管負數
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.TQC-A10107 10/01/12 By lilingyu INSERT INTO ecc_file表時,插入個數和字段個數不一致
# Modify.........: No.TQC-A50064 10/05/19 By destiny 当eca04=1时会关闭工作成本维护页签，但当eca04=0时,却不开发
# Modify.........: No:FUN-9A0056 11/03/31 By abby MES整合
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B30216 11/04/19 By Lilan 圖片資料功能
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_eca   RECORD LIKE eca_file.*,
    g_eca_t RECORD LIKE eca_file.*,
    g_eca_o RECORD LIKE eca_file.*,
    g_eca01_t LIKE eca_file.eca01,
    g_wc,g_sql          STRING,                             #TQC-630166
    l_cmd               LIKE type_file.chr1000
 
DEFINE g_forupd_sql          STRING                         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1                #No.FUN-680073 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10               #No.FUN-680073 INTEGER
DEFINE   g_i             LIKE type_file.num5                #No.FUN-680073 SMALLINT #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000             #No.FUN-680073 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10               #No.FUN-680073 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10               #No.FUN-680073 INTEGER
DEFINE   g_jump          LIKE type_file.num10               #No.FUN-680073 INTEGER
DEFINE   g_no_ask       LIKE type_file.num10               #No.FUN-680073 INTEGER
DEFINE l_table        STRING,                                                   
       g_str          STRING,                                                   
       l_sql          STRING                                                    
DEFINE g_argv1     LIKE eca_file.eca01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
   LET g_sql = "eca01.eca_file.eca01,",
               "eca02.eca_file.eca02,",
               "eca03.eca_file.eca03,",
               "gem02.gem_file.gem02,",
               "eca04.eca_file.eca04,",
               "eca06.eca_file.eca06,",
               "eca14.eca_file.eca14,",
               "ecaacti.eca_file.ecaacti,"     
   LET l_table = cl_prt_temptable('aeci600',g_sql) CLIPPED                      
   IF l_table = -1 THEN
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?) "                                        
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM                         
   END IF                    

 #  CALL cl_used(g_prog,g_time,1) RETURNING g_time

    INITIALIZE g_eca.* TO NULL
    INITIALIZE g_eca_t.* TO NULL
    INITIALIZE g_eca_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM eca_file WHERE eca01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i600_w WITH FORM "aec/42f/aeci600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i600_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i600_a()
            END IF
         OTHERWISE        
            CALL i600_q() 
      END CASE
   END IF
 
      LET g_action_choice=""
      CALL i600_menu()
 
    CLOSE WINDOW i600_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i600_cs()
DEFINE  p_cmd          LIKE type_file.chr1        #No.FUN-680073 VARCHAR(1)
    CLEAR FORM
   INITIALIZE g_eca.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" eca01='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        eca01,eca02,eca03,eca04,eca06,
        eca55,eca12,eca50,eca52,
        ecauser,ecagrup,ecamodu,ecadate,ecaacti,
        #正常工作站成本維護
        eca14, eca15, eca16, eca17,
        eca26, eca27, eca18, eca19,
        eca28, eca29,
        eca20, eca21, eca30, eca31,
        eca201,eca211,eca301,eca311,
        eca22, eca23, eca32, eca33,
        eca24, eca25,
        eca34, eca35,
        #廠外/廠內加工成本維護
        eca36,eca37,eca42,eca43,
        eca38,eca39,eca44,eca45,
        eca40,eca41,eca46,eca47
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(eca03) #部門代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO eca03
                  NEXT FIELD eca03
               WHEN INFIELD(eca55)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecn"       #  No.MOD-5A0420 add
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO eca55
                  NEXT FIELD eca55
		WHEN INFIELD(eca37)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca37
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca37
                     NEXT FIELD eca37
		WHEN INFIELD(eca43)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca43
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca43
                     NEXT FIELD eca43
		WHEN INFIELD(eca39)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca39
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca39
                     NEXT FIELD eca39
		WHEN INFIELD(eca45)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca45
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca45
                     NEXT FIELD eca45
		WHEN INFIELD(eca41)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca41
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca41
                     NEXT FIELD eca41
		WHEN INFIELD(eca47)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca47
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca47
                     NEXT FIELD eca47
		WHEN INFIELD(eca17)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca17
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca17
                     NEXT FIELD eca17
		WHEN INFIELD(eca27)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca27
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca27
                     NEXT FIELD eca27
		WHEN INFIELD(eca19)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca19
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca19
                     NEXT FIELD eca19
		WHEN INFIELD(eca29)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca29
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca29
                     NEXT FIELD eca29
		WHEN INFIELD(eca21)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca21
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca21
                     NEXT FIELD eca21
		WHEN INFIELD(eca31)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca31
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca31
                     NEXT FIELD eca31
		WHEN INFIELD(eca211)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca211
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca211
                     NEXT FIELD eca211
		WHEN INFIELD(eca311)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca311
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca311
                     NEXT FIELD eca311
		WHEN INFIELD(eca23)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca23
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca23
                     NEXT FIELD eca23
		WHEN INFIELD(eca33)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca33
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca33
                     NEXT FIELD eca33
		WHEN INFIELD(eca25)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca25
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca25
                     NEXT FIELD eca25
		WHEN INFIELD(eca35)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca35
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca35
                     NEXT FIELD eca35
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
   END IF  #FUN-7C0050
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecauser', 'ecagrup')
 
    LET g_sql="SELECT eca01 FROM eca_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY eca01"
    PREPARE i600_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i600_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i600_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM eca_file WHERE ",g_wc CLIPPED
    PREPARE i600_precount FROM g_sql
    DECLARE i600_count CURSOR FOR i600_precount
END FUNCTION
 
FUNCTION i600_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF cl_null(g_sma.sma901) OR g_sma.sma901='N' THEN
                CALL cl_set_act_visible("aps_related_data",FALSE)
            END IF
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i600_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i600_q()
            END IF
        ON ACTION next
            CALL i600_fetch('N')
        ON ACTION previous
            CALL i600_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i600_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i600_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i600_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i600_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i600_out()
            END IF

       ON ACTION station_cost_actg
            LET g_action_choice="station_cost_actg"
            IF cl_chk_act_auth() THEN
	        LET l_cmd = "aeci603 ","'", g_eca.eca01,"' '",g_eca.eca02,"'"
                CALL cl_cmdrun(l_cmd)
            END IF

       ON ACTION aps_related_data
                SELECT vmj01 FROM vmj_file WHERE vmj01 =g_eca.eca01
                IF SQLCA.SQLCODE=100 THEN
                    INSERT INTO vmj_file(vmj01,vmj02,vmj03,vmj04,vmj07)
                                  VALUES(g_eca.eca01,'','',0,0)
                    IF STATUS THEN
                       CALL cl_err3("ins","vmj_file",g_eca.eca01,"",SQLCA.sqlcode,"","",1) 
                    END IF
                END IF
                LET l_cmd = "apsi321 ","'", g_eca.eca01,"'"
                CALL cl_cmdrun(l_cmd)
 
       ON ACTION help
            CALL cl_show_help()
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU
 
       ON ACTION jump
           CALL i600_fetch('/')
       ON ACTION first
           CALL i600_fetch('F')
       ON ACTION last
           CALL i600_fetch('L')
 
       ON ACTION CONTROLG
           CALL cl_cmdask()
 
      #FUN-B30216 add str --------
       ON ACTION update
          IF NOT cl_null(g_eca.eca01) THEN
             LET g_doc.column1 = "eca01"
             LET g_doc.value1 = g_eca.eca01
             CALL cl_fld_doc("ima04")               #ima04:4fd上的元件名稱
          END IF
      #FUN-B30216 add end --------

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_eca.eca01 IS NOT NULL THEN
                 LET g_doc.column1 = "eca01"
                 LET g_doc.value1 = g_eca.eca01
                 CALL cl_doc()
              END IF
          END IF
          LET g_action_choice = "exit"
          CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i600_cs
END FUNCTION
 
 
FUNCTION i600_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_eca.* LIKE eca_file.*
    LET g_eca01_t = NULL
    LET g_eca_t.* = g_eca.*
    LET g_eca_o.* = g_eca.*
    LET g_eca.eca08 = 8
    LET g_eca_o.eca08 = 8
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_eca.ecaacti ='Y'                   #有效的資料
        LET g_eca.ecauser = g_user
        LET g_eca.ecaoriu = g_user #FUN-980030
        LET g_eca.ecaorig = g_grup #FUN-980030
        LET g_eca.ecagrup = g_grup               #使用者所屬群
        LET g_eca.ecadate = g_today
        CALL i600_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_eca.eca01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF

        LET g_success = 'Y'                      #FUN-9A0056 add 
        BEGIN WORK     #NO.FUN-680010
 
        INSERT INTO eca_file VALUES(g_eca.*)       # DISK WRITE

        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","eca_file",g_eca.eca01,"",SQLCA.sqlcode,"","",1) #FUN-660091
           ROLLBACK WORK 
           CONTINUE WHILE
        ELSE
 	   INSERT INTO ecc_file(ecc01,ecc02,ecc03,ecc04,ecc05,eccacti,eccuser,  #No.MOD-470041
                                eccgrup,eccmodu,eccdate,eccoriu,eccorig)  #TQC-A10107 add eccoriu eccorig
                VALUES(g_eca.eca01,'','','','',g_eca.ecaacti,g_eca.ecauser,
                       g_eca.ecagrup,g_eca.ecamodu, g_eca.ecadate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ecc_file",g_eca.eca01,"",SQLCA.sqlcode,"","",1) #FUN-660091
              ROLLBACK WORK 
              CONTINUE WHILE
           END IF
           LET g_eca_t.* = g_eca.*                # 保存上筆資料
           LET g_eca_o.* = g_eca.*                # 保存上筆資料
 
           # CALL aws_spccli_base()
           # 傳入參數: (1)TABLE名稱, (2)新增資料,
           #           (3)功能選項：insert(新增),update(修改),delete(刪除)
           CASE aws_spccli_base('eca_file',base.TypeInfo.create(g_eca),'insert')
              WHEN 0  #無與 SPC 整合
                   MESSAGE 'INSERT O.K'
                  #COMMIT WORK                           #FUN-9A0056 mark
              WHEN 1  #呼叫 SPC 成功
                   MESSAGE 'INSERT O.K, INSERT SPC O.K'
                  #COMMIT WORK                           #FUN-9A0056 mark
              WHEN 2  #呼叫 SPC 失敗
                   LET g_success = 'N'                   #FUN-9A0056 add
                  #ROLLBACK WORK                         #FUN-9A0056 mark
                  #CONTINUE WHILE                        #FUN-9A0056 mark
           END CASE

          #FUN-9A0056 add begin------------
           IF g_success = 'Y' THEN
              IF g_aza.aza90 MATCHES "[Yy]" THEN
                  CALL i600_mes('insert',g_eca.eca01)
              END IF
           END IF
          #FUN-9A0056 add end -------------

         IF g_success= 'Y' THEN                        #FUN-9A0056 add
           SELECT eca01 INTO g_eca.eca01 FROM eca_file
            WHERE eca01 = g_eca.eca01
         END IF                                        #FUN-9A0056 add
        END IF

       #FUN-9A0056 -- add begin ----
        IF g_success = 'N' THEN
          ROLLBACK WORK
          CONTINUE WHILE
        ELSE
          COMMIT WORK
        END IF
       #FUN-9A0056 -- add end ------
 
	CALL cl_getmsg('mfg4017',g_lang) RETURNING g_msg #是否執行成本資料維護   #No.MOD-770011 modify
	IF cl_prompt(0,0,g_msg) THEN
	   LET l_cmd = "aeci603 ","'", g_eca.eca01,"' '",g_eca.eca02,"'"
           CALL cl_cmdrun(l_cmd)
	END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i600_i(p_cmd)
    DEFINE
        l_imd10         LIKE  imd_file.imd10,   #倉庫類別
        l_imd11         LIKE  imd_file.imd11,   #可用否
        l_ime04         LIKE  ime_file.ime04,   #倉庫類別
        l_ime05         LIKE  ime_file.ime05,   #可用否
        l_n1,l_n2       LIKE type_file.num5,    #是否須將數值欄位清為0 #No.FUN-680073 SMALLINT
        l_dir1          LIKE type_file.chr1,    #Direction Flag #No.FUN-680073 VARCHAR(1)  
        p_cmd           LIKE type_file.chr1,    #No.FUN-680073 VARCHAR(1)
	l_sw            LIKE type_file.chr1,    #No.FUN-680073 VARCHAR(1)
        l_n             LIKE type_file.num5     #No.FUN-680073 SMALLINT
 
    DISPLAY BY NAME g_eca.ecauser, g_eca.ecagrup, g_eca.ecamodu,
                    g_eca.ecadate, g_eca.ecaacti
    #廠外/廠內加工成本維護
    IF g_eca.eca04 = '2' THEN #廠內加工才需輸入'製造'類成本
       DISPLAY BY NAME g_eca.eca38, g_eca.eca39, g_eca.eca40, g_eca.eca41,
                       g_eca.eca44, g_eca.eca45, g_eca.eca46, g_eca.eca47
    ELSE
       LET g_eca.eca38 = 0 LET g_eca.eca39 = NULL
       LET g_eca.eca40 = 0 LET g_eca.eca41 = NULL
       LET g_eca.eca44 = 0 LET g_eca.eca45 = NULL
       LET g_eca.eca46 = 0 LET g_eca.eca47 = NULL
    END IF
 
    LET l_n1 = 1
    LET l_n2 = 1
 
    INPUT BY NAME g_eca.ecaoriu,g_eca.ecaorig,
        g_eca.eca01,g_eca.eca02,g_eca.eca03,g_eca.eca04,g_eca.eca06,
        g_eca.eca55,g_eca.eca12,g_eca.eca50,g_eca.eca52,
        #正常工作站成本維護
                  g_eca.eca14, g_eca.eca15, g_eca.eca16, g_eca.eca17,
                  g_eca.eca26, g_eca.eca27, g_eca.eca18, g_eca.eca19,
                  g_eca.eca28, g_eca.eca29,
                  g_eca.eca20, g_eca.eca21, g_eca.eca30, g_eca.eca31,
                  g_eca.eca201,g_eca.eca211,g_eca.eca301,g_eca.eca311,
                  g_eca.eca22, g_eca.eca23, g_eca.eca32, g_eca.eca33,
                  g_eca.eca24, g_eca.eca25,
                  g_eca.eca34, g_eca.eca35,
        #廠外/廠內加工成本維護
                  g_eca.eca36, g_eca.eca37, g_eca.eca42, g_eca.eca43,
                  g_eca.eca38, g_eca.eca39, g_eca.eca44, g_eca.eca45,#eca04='2'時
                  g_eca.eca40, g_eca.eca41, g_eca.eca46, g_eca.eca47 #eca04='2'
                  WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i600_set_entry(p_cmd)
           CALL i600_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD eca01
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_eca.eca01 != g_eca01_t) THEN
                SELECT count(*) INTO l_n FROM eca_file
                    WHERE eca01 = g_eca.eca01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_eca.eca01,'mfg4000',0)
                    LET g_eca.eca01 = g_eca01_t
                    DISPLAY BY NAME g_eca.eca01
                    NEXT FIELD eca01
                END IF
            END IF
 
        BEFORE FIELD eca02
            IF g_eca.eca01 IS NULL THEN
		LET g_eca.eca01 = g_eca_t.eca01
		DISPLAY BY NAME g_eca.eca01
                NEXT FIELD eca01
            END IF
 
        AFTER FIELD eca03
            IF not cl_null(g_eca.eca03) THEN
               CALL i600_eca03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_eca.eca03,g_errno,0)
                  LET g_eca.eca03 = g_eca_t.eca03
                  DISPLAY BY NAME g_eca.eca03
                  NEXT FIELD eca03
               END IF
            END IF
            LET g_eca_o.eca03 = g_eca.eca03
 
        BEFORE FIELD eca04
          CALL i600_set_entry(p_cmd)
 
        AFTER FIELD eca04  #工作區型態必需為 '0' '1' '2'
          IF g_eca.eca04 IS NOT NULL THEN
		CASE
		  WHEN g_eca.eca04 = '0'
		       LET g_eca.eca36 = 0 LET g_eca.eca42 = 0
		       LET g_eca.eca37 = NULL LET g_eca.eca39 = NULL
		       LET g_eca.eca38 = 0 LET g_eca.eca44 = 0
		       LET g_eca.eca41 = NULL LET g_eca.eca43 = NULL
		       LET g_eca.eca40 = 0 LET g_eca.eca46 = 0
		       IF p_cmd = 'a' AND l_n1 = 1 THEN  #新增時設定初值
                          LET l_n1 = l_n1 + 1
                          LET l_n2 = 1
		          LET g_eca.eca16  = 0 LET g_eca.eca26  = 0
		          LET g_eca.eca18  = 0 LET g_eca.eca28  = 0
		          LET g_eca.eca20  = 0 LET g_eca.eca30  = 0
		          LET g_eca.eca201 = 0 LET g_eca.eca301 = 0
		          LET g_eca.eca22  = 0 LET g_eca.eca32  = 0
		          LET g_eca.eca24  = 0 LET g_eca.eca34  = 0
		       END IF
		  WHEN g_eca.eca04 = '1' or g_eca.eca04 = '2'
               LET g_eca.eca16 = 0   LET g_eca.eca18 = 0
               LET g_eca.eca20 = 0   LET g_eca.eca201 = 0
               LET g_eca.eca22 = 0   LET g_eca.eca24 = 0
               LET g_eca.eca26 = 0   LET g_eca.eca28 = 0
               LET g_eca.eca30 = 0   LET g_eca.eca301 = 0
               LET g_eca.eca32 = 0   LET g_eca.eca34 = 0
		       IF p_cmd = 'a' AND l_n2 = 1 THEN  #新增時設定初值
                          LET l_n2 = l_n2 + 1
                          LET l_n1 = 1
		          LET g_eca.eca36 = 0 LET g_eca.eca42 = 0
		          LET g_eca.eca37 = NULL LET g_eca.eca39 = NULL
		          LET g_eca.eca38 = 0 LET g_eca.eca44 = 0
		          LET g_eca.eca41 = NULL LET g_eca.eca43 = NULL
		          LET g_eca.eca40 = 0 LET g_eca.eca46 = 0
		          LET g_eca.eca45 = NULL LET g_eca.eca47 = NULL
		       END IF
		END CASE
		IF INT_FLAG THEN EXIT INPUT END IF
            LET g_eca_o.eca04 = g_eca.eca04
          END IF
          CALL i600_set_no_entry(p_cmd)
		#No.TQC-A50064--begin
		ON CHANGE eca04  
		CASE
		  WHEN g_eca.eca04 = '0'
		       LET g_eca.eca36 = 0 LET g_eca.eca42 = 0
		       LET g_eca.eca37 = NULL LET g_eca.eca39 = NULL
		       LET g_eca.eca38 = 0 LET g_eca.eca44 = 0
		       LET g_eca.eca41 = NULL LET g_eca.eca43 = NULL
		       LET g_eca.eca40 = 0 LET g_eca.eca46 = 0
		       IF p_cmd = 'a' AND l_n1 = 1 THEN  #新增時設定初值
                          LET l_n1 = l_n1 + 1
                          LET l_n2 = 1
		          LET g_eca.eca16  = 0 LET g_eca.eca26  = 0
		          LET g_eca.eca18  = 0 LET g_eca.eca28  = 0
		          LET g_eca.eca20  = 0 LET g_eca.eca30  = 0
		          LET g_eca.eca201 = 0 LET g_eca.eca301 = 0
		          LET g_eca.eca22  = 0 LET g_eca.eca32  = 0
		          LET g_eca.eca24  = 0 LET g_eca.eca34  = 0
		       END IF
		  WHEN g_eca.eca04 = '1' or g_eca.eca04 = '2'
               LET g_eca.eca16 = 0   LET g_eca.eca18 = 0
               LET g_eca.eca20 = 0   LET g_eca.eca201 = 0
               LET g_eca.eca22 = 0   LET g_eca.eca24 = 0
               LET g_eca.eca26 = 0   LET g_eca.eca28 = 0
               LET g_eca.eca30 = 0   LET g_eca.eca301 = 0
               LET g_eca.eca32 = 0   LET g_eca.eca34 = 0
		       IF p_cmd = 'a' AND l_n2 = 1 THEN  #新增時設定初值
                          LET l_n2 = l_n2 + 1
                          LET l_n1 = 1
		          LET g_eca.eca36 = 0 LET g_eca.eca42 = 0
		          LET g_eca.eca37 = NULL LET g_eca.eca39 = NULL
		          LET g_eca.eca38 = 0 LET g_eca.eca44 = 0
		          LET g_eca.eca41 = NULL LET g_eca.eca43 = NULL
		          LET g_eca.eca40 = 0 LET g_eca.eca46 = 0
		          LET g_eca.eca45 = NULL LET g_eca.eca47 = NULL
		       END IF
		END CASE		
		CALL i600_set_no_entry(p_cmd)
		#No.TQC-A50064--end
		 
        AFTER FIELD eca06  #產能型態必需為 '1' '2' 且務必輸入
            IF g_eca.eca06 IS NULL OR g_eca.eca06 NOT MATCHES '[12]' THEN
	           LET g_eca.eca06 = g_eca_o.eca06
	           DISPLAY BY NAME g_eca.eca06
	           NEXT FIELD eca06
            END IF
            IF g_eca.eca06 = '2' THEN LET g_eca.eca10 = 0 END IF
            LET g_eca_o.eca06 = g_eca.eca06
 
        AFTER FIELD eca55
            IF g_eca.eca55 IS NULL THEN
               LET g_eca.eca55 = '0'
               DISPLAY BY NAME g_eca.eca55
            ELSE
               IF g_eca.eca55 != '0'  AND      # No.MOD-5A0420 add
                  (g_eca_o.eca55 IS NULL OR
                   g_eca_o.eca55 != g_eca.eca55) THEN
                  SELECT UNIQUE ecn01 FROM ecn_file
                         WHERE ecn01 = g_eca.eca55                     # No.MOD-5A0420 add
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","ecn_file",g_eca.eca55,"","mfg4121","","",1) #FUN-660091
                     LET g_eca.eca55 = g_eca_o.eca55
                     DISPLAY BY NAME g_eca.eca55
                     NEXT FIELD eca55
                  END IF
               END IF
            END IF
            LET g_eca_o.eca55 = g_eca.eca55
 
        AFTER FIELD eca12
            IF g_eca_o.eca12 IS NULL OR
               g_eca_o.eca12 != g_eca.eca12 THEN
               CALL i600_cap('3')  #重新計算人工及機器之每天及每星期總產能
            END IF
            IF NOT cl_null(g_eca.eca12) THEN
               IF g_eca.eca12 >100 THEN
                  CALL cl_err('','aec-995',0)
                  NEXT FIELD eca12
               END IF
               IF g_eca.eca12 < 0 THEN
                  CALL cl_err('','axm-179',0)
                  NEXT FIELD eca12
               END IF 
            END IF
            LET g_eca_o.eca12 = g_eca.eca12
        
 
        AFTER FIELD eca50
           IF g_eca.eca50 < 0 THEN NEXT FIELD eca50 END IF
 
        AFTER FIELD eca52
           IF g_eca.eca52 < 0 THEN NEXT FIELD eca52 END IF
 
 
        #正常工作站成本維護作業
	AFTER FIELD eca14
	    IF g_eca.eca14 NOT MATCHES'[12]' THEN
		LET g_eca.eca14 = g_eca_o.eca14
		DISPLAY BY NAME g_eca.eca14
		NEXT FIELD eca14
	    END IF
            LET g_eca_o.eca14 = g_eca.eca14
 
	AFTER FIELD eca15
          IF g_eca.eca15 IS NOT NULL THEN
            IF (g_eca.eca06 = '1' AND g_eca.eca15 NOT MATCHES'[3-6]') OR
               (g_eca.eca06 = '2' AND g_eca.eca15 NOT MATCHES'[1256]') THEN
                CALL cl_err(g_eca.eca15,'mfg4122',0)
		LET g_eca.eca15 = g_eca_o.eca15
		DISPLAY BY NAME g_eca.eca15
		NEXT FIELD eca15
	    END IF
            LET g_eca_o.eca15 = g_eca.eca15
	  END IF
 
   	AFTER FIELD eca16
	    IF g_eca.eca16 IS NULL THEN
               IF g_eca_o.eca16 IS NULL THEN
                  LET g_eca.eca16 = 0
               ELSE
		  LET g_eca.eca16 = g_eca_o.eca16
               END IF
		DISPLAY BY NAME g_eca.eca16
		NEXT FIELD eca16
	    END IF
            IF g_eca.eca16<0 THEN NEXT FIELD eca16 END IF      #No.TQC-740145
            LET g_eca_o.eca16 = g_eca.eca16
 
   	AFTER FIELD eca17
	    IF g_eca.eca17 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca17
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca17,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca17 = g_eca_o.eca17
                    DISPLAY BY NAME g_eca.eca17
		    NEXT FIELD eca17
		END IF
                LET g_eca_o.eca17 = g_eca.eca17
	    END IF
 
	BEFORE FIELD eca26
	    IF g_eca.eca26 IS NULL OR g_eca.eca26 =0 THEN
               LET g_eca.eca26 = g_eca.eca16
            END IF
	    IF g_eca.eca27 IS NULL OR g_eca.eca27 =0 THEN
               LET g_eca.eca27 = g_eca.eca17
            END IF
	    IF g_eca.eca28 IS NULL OR g_eca.eca28 =0 THEN
               LET g_eca.eca28 = g_eca.eca18
            END IF
	    IF g_eca.eca29 IS NULL OR g_eca.eca29 =0 THEN
               LET g_eca.eca29 = g_eca.eca19
            END IF
	    IF g_eca.eca30 IS NULL OR g_eca.eca30 =0 THEN
               LET g_eca.eca30 = g_eca.eca20
            END IF
	    IF g_eca.eca31 IS NULL OR g_eca.eca31 =0 THEN
                LET g_eca.eca31 = g_eca.eca21
            END IF
	    IF g_eca.eca301 IS NULL OR g_eca.eca301 =0 THEN
                LET g_eca.eca301 = g_eca.eca201
            END IF
	    IF g_eca.eca32 IS NULL OR g_eca.eca32 =0 THEN
                LET g_eca.eca32 = g_eca.eca22
            END IF
	    IF g_eca.eca33 IS NULL OR g_eca.eca33 =0 THEN
                LET g_eca.eca33 = g_eca.eca23
            END IF
	    IF g_eca.eca34 IS NULL OR g_eca.eca34 =0 THEN
                LET g_eca.eca34 = g_eca.eca24
            END IF
	    IF g_eca.eca35 IS NULL OR g_eca.eca35 =0 THEN
                LET g_eca.eca35 = g_eca.eca25
            END IF
	    DISPLAY BY NAME g_eca.eca26, g_eca.eca27, g_eca.eca28,
			    g_eca.eca29, g_eca.eca30, g_eca.eca31, g_eca.eca301,
                            g_eca.eca32, g_eca.eca33, g_eca.eca34, g_eca.eca35
 
   	AFTER FIELD eca27
	    IF g_eca.eca27 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca27
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca27,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca27 = g_eca_o.eca27
                    DISPLAY BY NAME g_eca.eca27
		    NEXT FIELD eca27
		END IF
                LET g_eca_o.eca27 = g_eca.eca27
	    END IF
 
   	AFTER FIELD eca18
	    IF g_eca.eca18 IS NULL THEN
               IF g_eca_o.eca18 IS NULL THEN
                  LET g_eca.eca18 = 0
               ELSE
		  LET g_eca.eca18 = g_eca_o.eca18
               END IF
		DISPLAY BY NAME g_eca.eca18
		NEXT FIELD eca18
	    END IF
            IF g_eca.eca18<0 THEN NEXT FIELD eca18 END IF      #No.TQC-740145
            LET g_eca_o.eca18 = g_eca.eca18
 
   	AFTER FIELD eca19
	    IF g_eca.eca19 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca19
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca19,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca19 = g_eca_o.eca19
                    DISPLAY BY NAME g_eca.eca19
		    NEXT FIELD eca19
		END IF
                LET g_eca_o.eca19 = g_eca.eca19
	    END IF
 
   	AFTER FIELD eca29
	    IF g_eca.eca29 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca29
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca29,"","mfg4003","","",11) #FUN-660091
		    LET g_eca.eca29 = g_eca_o.eca29
                    DISPLAY BY NAME g_eca.eca29
		    NEXT FIELD eca29
		END IF
                LET g_eca_o.eca29 = g_eca.eca29
	    END IF
 
   	AFTER FIELD eca20
	    IF g_eca.eca20 IS NULL THEN
               IF g_eca_o.eca20 IS NULL THEN
                  LET g_eca.eca20 = 0
               ELSE
		  LET g_eca.eca20 = g_eca_o.eca20
               END IF
		DISPLAY BY NAME g_eca.eca20
		NEXT FIELD eca20
                LET g_eca_o.eca20 = g_eca.eca20
	    END IF
            IF g_eca.eca20<0 THEN NEXT FIELD eca20 END IF      #No.TQC-740145
 
   	AFTER FIELD eca21
	    IF g_eca.eca21 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca21
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca21,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca21 = g_eca_o.eca21
                    DISPLAY BY NAME g_eca.eca21
		    NEXT FIELD eca21
		END IF
                LET g_eca_o.eca21 = g_eca.eca21
	    END IF
 
   	AFTER FIELD eca31
	    IF g_eca.eca31 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca31
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca31,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca31 = g_eca_o.eca31
                    DISPLAY BY NAME g_eca.eca31
		    NEXT FIELD eca31
		END IF
                LET g_eca_o.eca31 = g_eca.eca31
	    END IF
 
   	AFTER FIELD eca201
	    IF g_eca.eca201 IS NULL THEN
               IF g_eca_o.eca201 IS NULL THEN
                  LET g_eca.eca201 = 0
               ELSE
		  LET g_eca.eca201 = g_eca_o.eca201
               END IF
		DISPLAY BY NAME g_eca.eca201
		NEXT FIELD eca201
	    END IF
            IF g_eca.eca201<0 THEN NEXT FIELD eca201 END IF      #No.TQC-740145
            LET g_eca_o.eca201 = g_eca.eca201
 
   	AFTER FIELD eca211
	    IF g_eca.eca211 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca211
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca211,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca211 = g_eca_o.eca211
                    DISPLAY BY NAME g_eca.eca211
		    NEXT FIELD eca211
		END IF
                LET g_eca_o.eca211 = g_eca.eca211
	    END IF
 
   	AFTER FIELD eca311
	    IF g_eca.eca311 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca311
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca311,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca311 = g_eca_o.eca311
                    DISPLAY BY NAME g_eca.eca311
		    NEXT FIELD eca311
		END IF
                LET g_eca_o.eca311 = g_eca.eca311
	    END IF
 
   	AFTER FIELD eca22
	    IF g_eca.eca22 IS NULL THEN
               IF g_eca_o.eca22 IS NULL THEN
                  LET g_eca.eca22 = 0
               ELSE
		  LET g_eca.eca22 = g_eca_o.eca22
               END IF
		DISPLAY BY NAME g_eca.eca22
		NEXT FIELD eca22
	    END IF
            IF g_eca.eca22<0 THEN NEXT FIELD eca22 END IF      #No.TQC-740145
            LET g_eca_o.eca22 = g_eca.eca22
 
   	AFTER FIELD eca23
	    IF g_eca.eca23 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca23
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca23,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca23 = g_eca_o.eca23
                    DISPLAY BY NAME g_eca.eca23
		    NEXT FIELD eca23
		END IF
                LET g_eca_o.eca23 = g_eca.eca23
	    END IF
 
   	AFTER FIELD eca33
	    IF g_eca.eca33 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca33
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca33,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca33 = g_eca_o.eca33
                    DISPLAY BY NAME g_eca.eca33
		    NEXT FIELD eca33
		END IF
                LET g_eca_o.eca33 = g_eca.eca33
	    END IF
 
   	AFTER FIELD eca25
	    IF g_eca.eca25 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca25
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca25,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca25 = g_eca_o.eca25
                    DISPLAY BY NAME g_eca.eca25
		    NEXT FIELD eca25
		END IF
                LET g_eca_o.eca25 = g_eca.eca25
	    END IF
 
   	AFTER FIELD eca35
	    IF g_eca.eca35 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca35
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca35,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca35 = g_eca_o.eca35
                    DISPLAY BY NAME g_eca.eca35
		    NEXT FIELD eca35
		END IF
                LET g_eca_o.eca35 = g_eca.eca35
	    END IF
 
 
        #廠外/廠內加工成本維護作業(aeci602)
   	AFTER FIELD eca36
	    IF g_eca.eca36 IS NULL THEN
               IF g_eca_o.eca36 IS NULL THEN
                  LET g_eca.eca36 = 0
               ELSE
		  LET g_eca.eca36 = g_eca_o.eca36
               END IF
		DISPLAY BY NAME g_eca.eca36
		NEXT FIELD eca36
            ELSE
               IF g_eca.eca36 < 0 THEN 
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD eca36
               END IF 
	    END IF
            LET g_eca_o.eca36 = g_eca.eca36
 
   	AFTER FIELD eca37
	    IF g_eca.eca37 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca37
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca37,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca37 = g_eca_o.eca37
                    DISPLAY BY NAME g_eca.eca37
		    NEXT FIELD eca37
		END IF
	    END IF
            LET g_eca_o.eca37 = g_eca.eca37
 
	BEFORE FIELD  eca42
	    IF g_eca.eca42 IS NULL OR g_eca.eca42 = 0 THEN
               LET g_eca.eca42 = g_eca.eca36
	    END IF
	    IF g_eca.eca43 IS NULL OR g_eca.eca43 = 0 THEN
               LET g_eca.eca43 = g_eca.eca37
	    END IF
	    DISPLAY BY NAME g_eca.eca42, g_eca.eca43
 
   	AFTER FIELD eca42
	   IF g_eca.eca42 IS NULL THEN
              IF g_eca_o.eca42 IS NULL THEN
                 LET g_eca.eca42 = 0
              ELSE
	         LET g_eca.eca42 = g_eca_o.eca42
              END IF
	      DISPLAY BY NAME g_eca.eca42
	      NEXT FIELD eca42
            ELSE
               IF g_eca.eca42 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD eca42
               END IF
	   END IF
           LET g_eca_o.eca42 = g_eca.eca42
 
   	AFTER FIELD eca43
	    IF g_eca.eca43 IS NOT NULL THEN
	       SELECT * FROM smg_file WHERE smg01 = g_eca.eca43
	       IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","smg_file",g_eca.eca43,"","mfg4003","","",1) #FUN-660091
		  LET g_eca.eca43 = g_eca_o.eca43
                  DISPLAY BY NAME g_eca.eca43
	          NEXT FIELD eca43
	       END IF
	    END IF
        #原i602_eca38()內容
   	AFTER FIELD eca38
	    IF g_eca.eca38 IS NULL THEN
               IF g_eca_o.eca38 IS NULL THEN
                  LET g_eca.eca38 = 0
               ELSE
		  LET g_eca.eca38 = g_eca_o.eca38
               END IF
		DISPLAY BY NAME g_eca.eca38
		NEXT FIELD eca38
            ELSE
               IF g_eca.eca38 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD eca38
               END IF
	    END IF
            LET g_eca_o.eca38 = g_eca.eca38
 
   	AFTER FIELD eca39
	    IF g_eca.eca39 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca39
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca39,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca39 = g_eca_o.eca39
                    DISPLAY BY NAME g_eca.eca39
		    NEXT FIELD eca39
		END IF
	    END IF
            LET g_eca_o.eca39 = g_eca.eca39
 
    BEFORE FIELD eca44
	       IF g_eca.eca44 IS NULL OR g_eca.eca44 = 0 THEN
              LET g_eca.eca44 = g_eca.eca38
	       END IF
	       IF g_eca.eca45 IS NULL OR g_eca.eca45 = 0 THEN
              LET g_eca.eca45 = g_eca.eca39
	   	   END IF
	       DISPLAY BY NAME g_eca.eca44,g_eca.eca45
 
   	AFTER FIELD eca44
	    IF g_eca.eca44 IS NULL THEN
               IF g_eca_o.eca44 IS NULL THEN
                  LET g_eca.eca44 = 0
               ELSE
		  LET g_eca.eca44 = g_eca_o.eca44
               END IF
		DISPLAY BY NAME g_eca.eca44
		NEXT FIELD eca44
            ELSE
               IF g_eca.eca44 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD eca44
               END IF
	    END IF
            LET g_eca_o.eca44 = g_eca.eca44
 
   	AFTER FIELD eca45
	    IF g_eca.eca45 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca45
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca45,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca45 = g_eca_o.eca45
                    DISPLAY BY NAME g_eca.eca45
		    NEXT FIELD eca45
		END IF
	    END IF
            LET g_eca_o.eca45 = g_eca.eca45
 
        #原i602_eca40()內容
   	AFTER FIELD eca40
	    IF g_eca.eca40 IS NULL THEN
               IF g_eca_o.eca40 IS NULL THEN
                  LET g_eca.eca40 = 0
               ELSE
		  LET g_eca.eca40 = g_eca_o.eca40
               END IF
		DISPLAY BY NAME g_eca.eca40
		NEXT FIELD eca40
            ELSE
               IF g_eca.eca40 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD eca40
               END IF
	    END IF
            LET g_eca_o.eca40 = g_eca.eca40
 
   	AFTER FIELD eca41
	    IF g_eca.eca41 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca41
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca41,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca41 = g_eca_o.eca41
                    DISPLAY BY NAME g_eca.eca39
		    NEXT FIELD eca41
		END IF
	    END IF
            LET g_eca_o.eca41 = g_eca.eca41
 
    BEFORE FIELD eca46
	       IF g_eca.eca46 IS NULL OR g_eca.eca46 = 0 THEN
              LET g_eca.eca46 = g_eca.eca40
	       END IF
	       IF g_eca.eca47 IS NULL OR g_eca.eca47 = 0 THEN
               LET g_eca.eca47 = g_eca.eca41
	       END IF
	       DISPLAY BY NAME g_eca.eca47, g_eca.eca46
 
   	AFTER FIELD eca46
	    IF g_eca.eca46 IS NULL THEN
               IF g_eca_o.eca46 IS NULL THEN
                  LET g_eca.eca46 = 0
               ELSE
		  LET g_eca.eca46 = g_eca_o.eca46
               END IF
		DISPLAY BY NAME g_eca.eca46
		NEXT FIELD eca46
            ELSE
               IF g_eca.eca46 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD eca46
               END IF
	    END IF
            LET g_eca_o.eca46 = g_eca.eca46
 
   	AFTER FIELD eca47
	    IF g_eca.eca47 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca47
		IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","smg_file",g_eca.eca47,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca47 = g_eca_o.eca47
                    DISPLAY BY NAME g_eca.eca47
		    NEXT FIELD eca47
		END IF
	    END IF
            LET g_eca_o.eca47 = g_eca.eca47
 
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(eca03) #部門代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_eca.eca03
                  CALL cl_create_qry() RETURNING g_eca.eca03
                  DISPLAY BY NAME g_eca.eca03
                  NEXT FIELD eca03
               WHEN INFIELD(eca55)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecn"
                  LET g_qryparam.default1 = g_eca.eca55
                  CALL cl_create_qry() RETURNING g_eca.eca55
                  DISPLAY BY NAME g_eca.eca55
                  NEXT FIELD eca55
                #正常工作站成本維護作業
		WHEN INFIELD(eca17)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca17
                     CALL cl_create_qry() RETURNING g_eca.eca17
                     DISPLAY BY NAME g_eca.eca17
                     NEXT FIELD eca17
		WHEN INFIELD(eca19)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca19
                     CALL cl_create_qry() RETURNING g_eca.eca19
                     DISPLAY BY NAME g_eca.eca19
                     NEXT FIELD eca19
		WHEN INFIELD(eca21)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca21
                     CALL cl_create_qry() RETURNING g_eca.eca21
                     DISPLAY BY NAME g_eca.eca21
                     NEXT FIELD eca21
		WHEN INFIELD(eca211)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca211
                     CALL cl_create_qry() RETURNING g_eca.eca211
                     DISPLAY BY NAME g_eca.eca211
                     NEXT FIELD eca211
		WHEN INFIELD(eca23)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca23
                     CALL cl_create_qry() RETURNING g_eca.eca23
                     DISPLAY BY NAME g_eca.eca23
                     NEXT FIELD eca23
		WHEN INFIELD(eca25)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca25
                     CALL cl_create_qry() RETURNING g_eca.eca25
                     DISPLAY BY NAME g_eca.eca25
                     NEXT FIELD eca25
		WHEN INFIELD(eca27)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca27
                     CALL cl_create_qry() RETURNING g_eca.eca27
                     DISPLAY BY NAME g_eca.eca27
                     NEXT FIELD eca27
		WHEN INFIELD(eca29)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca29
                     CALL cl_create_qry() RETURNING g_eca.eca29
                     DISPLAY BY NAME g_eca.eca29
                     NEXT FIELD eca29
		WHEN INFIELD(eca31)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca31
                     CALL cl_create_qry() RETURNING g_eca.eca31
                     DISPLAY BY NAME g_eca.eca31
                     NEXT FIELD eca31
		WHEN INFIELD(eca311)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca311
                     CALL cl_create_qry() RETURNING g_eca.eca311
                     DISPLAY BY NAME g_eca.eca311
                     NEXT FIELD eca311
		WHEN INFIELD(eca33)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca33
                     CALL cl_create_qry() RETURNING g_eca.eca33
                     DISPLAY BY NAME g_eca.eca33
                     NEXT FIELD eca33
		WHEN INFIELD(eca35)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca35
                     CALL cl_create_qry() RETURNING g_eca.eca35
                     DISPLAY BY NAME g_eca.eca35
                     NEXT FIELD eca35
		WHEN INFIELD(eca37)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca37
                     CALL cl_create_qry() RETURNING g_eca.eca37
                     DISPLAY BY NAME g_eca.eca37
                     NEXT FIELD eca37
		WHEN INFIELD(eca43)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca43
                     CALL cl_create_qry() RETURNING g_eca.eca43
                     DISPLAY BY NAME g_eca.eca43
                     NEXT FIELD eca43
		WHEN INFIELD(eca39)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca39
                     CALL cl_create_qry() RETURNING g_eca.eca39
                     DISPLAY BY NAME g_eca.eca39
                     NEXT FIELD eca39
		WHEN INFIELD(eca45)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca45
                     CALL cl_create_qry() RETURNING g_eca.eca45
                     DISPLAY BY NAME g_eca.eca45
                     NEXT FIELD eca45
		WHEN INFIELD(eca39)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca39
                     CALL cl_create_qry() RETURNING g_eca.eca39
                     DISPLAY BY NAME g_eca.eca39
                     NEXT FIELD eca39
		WHEN INFIELD(eca45)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca45
                     CALL cl_create_qry() RETURNING g_eca.eca45
                     DISPLAY BY NAME g_eca.eca45
                     NEXT FIELD eca45
		WHEN INFIELD(eca41)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca41
                     CALL cl_create_qry() RETURNING g_eca.eca41
                     DISPLAY BY NAME g_eca.eca41
                     NEXT FIELD eca41
		WHEN INFIELD(eca47)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca47
                     CALL cl_create_qry() RETURNING g_eca.eca47
                     DISPLAY BY NAME g_eca.eca47
                     NEXT FIELD eca47
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION maintain_department_data
            CALL cl_cmdrun("aooi030")
 
         ON ACTION maintaini_work_center_calendar
            CALL cl_cmdrun("aeci800")
 
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
 
FUNCTION i600_cap(p_cmd) #計算每天總產能及每星期總產能
    DEFINE p_cmd  LIKE type_file.chr1                #No.FUN-680073 VARCHAR(01)
    CASE p_cmd
       WHEN '1' LET g_eca.eca50 = (g_eca.eca08 * g_eca.eca10 * g_eca.eca12)/100
                LET g_eca.eca51 = g_eca.eca13 * g_eca.eca50
                DISPLAY BY NAME g_eca.eca50,g_eca.eca51
       WHEN '2' LET g_eca.eca52 = (g_eca.eca08 * g_eca.eca11 * g_eca.eca12)/100
                LET g_eca.eca53 = g_eca.eca13 * g_eca.eca52
                DISPLAY BY NAME g_eca.eca52,g_eca.eca53
       WHEN '3' LET g_eca.eca50 = (g_eca.eca08 * g_eca.eca10 * g_eca.eca12)/100
                LET g_eca.eca51 = g_eca.eca13 * g_eca.eca50
                LET g_eca.eca52 = (g_eca.eca08 * g_eca.eca11 * g_eca.eca12)/100
                LET g_eca.eca53 = g_eca.eca13 * g_eca.eca52
                DISPLAY BY NAME g_eca.eca50,g_eca.eca52
       OTHERWISE EXIT CASE
   END CASE
END FUNCTION
 
FUNCTION i600_eca03(p_cmd)     #部門
  DEFINE p_cmd       LIKE type_file.chr1,            #No.FUN-680073 VARCHAR(01)
         l_gem02     LIKE gem_file.gem02,
         l_gemacti   LIKE gem_file.gemacti
 
     LET g_errno = ' '
     SELECT gem02,gemacti INTO l_gem02,l_gemacti
       FROM gem_file WHERE gem01 = g_eca.eca03
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                        LET l_gem02 = NULL
              WHEN l_gemacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN DISPLAY l_gem02 TO FORMONLY.gem02
     END IF
END FUNCTION
 
FUNCTION i600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_eca.* TO NULL              #No.FUN-6A0039
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i600_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i600_count
    FETCH i600_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0)
        INITIALIZE g_eca.* TO NULL
    ELSE
        CALL i600_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i600_fetch(p_fleca)
    DEFINE
        p_fleca         LIKE type_file.chr1,               #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10               #No.FUN-680073 INTEGER
 
    CASE p_fleca
        WHEN 'N' FETCH NEXT     i600_cs INTO g_eca.eca01
        WHEN 'P' FETCH PREVIOUS i600_cs INTO g_eca.eca01
        WHEN 'F' FETCH FIRST    i600_cs INTO g_eca.eca01
        WHEN 'L' FETCH LAST     i600_cs INTO g_eca.eca01
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
            FETCH ABSOLUTE g_jump i600_cs INTO g_eca.eca01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0)
        INITIALIZE g_eca.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_fleca
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_eca.* FROM eca_file            # 重讀DB,因TEMP有不被更新特性
       WHERE eca01 = g_eca.eca01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","eca_file",g_eca.eca01,"",SQLCA.sqlcode,"","",1) #FUN-660091
    ELSE
        LET g_data_owner = g_eca.ecauser      #FUN-4C0034
        LET g_data_group = g_eca.ecagrup      #FUN-4C0034
        CALL i600_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i600_show()
 
    MESSAGE ''
    LET g_eca_t.* = g_eca.*
    LET g_eca_o.* = g_eca.*
    DISPLAY BY NAME  g_eca.eca01, g_eca.eca02, g_eca.eca03, g_eca.ecaoriu,g_eca.ecaorig,
	g_eca.eca04, g_eca.eca06, g_eca.eca55, g_eca.eca12,
        g_eca.eca50, g_eca.eca52,
        g_eca.ecauser, g_eca.ecagrup, g_eca.ecamodu,
        g_eca.ecadate, g_eca.ecaacti
    CALL i600_eca03('d')
    #正常工作站成本維護
        DISPLAY BY NAME
                      g_eca.eca14, g_eca.eca15, g_eca.eca16, g_eca.eca17,
                      g_eca.eca26, g_eca.eca27, g_eca.eca18, g_eca.eca19,
                      g_eca.eca28, g_eca.eca29,
                      g_eca.eca20, g_eca.eca21, g_eca.eca30, g_eca.eca31,
                      g_eca.eca201,g_eca.eca211,g_eca.eca301,g_eca.eca311,
                      g_eca.eca22, g_eca.eca23, g_eca.eca32, g_eca.eca33,
                      g_eca.eca24, g_eca.eca25,
                      g_eca.eca34, g_eca.eca35
    #廠外/廠內加工成本維護
        DISPLAY BY NAME
                  g_eca.eca36, g_eca.eca37, g_eca.eca38, g_eca.eca39,
                  g_eca.eca40, g_eca.eca41, g_eca.eca42, g_eca.eca43,
                  g_eca.eca44,g_eca.eca45,
                  g_eca.eca46, g_eca.eca47

   #FUN-B30216 add str -------- 
    LET g_doc.column1 = "eca01"
    LET g_doc.value1 = g_eca.eca01 
    CALL cl_get_fld_doc("ima04")
   #FUN-B30216 add end -------- 

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i600_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_eca.eca01 IS NULL THEN
        CALL cl_err(g_eca.eca01,-400,0)
        RETURN
    END IF
    IF g_eca.ecaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_eca.eca01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_eca01_t = g_eca.eca01
 
    IF g_action_choice <> "reproduce" THEN    #FUN-680010
       LET g_success = 'Y'                    #FUN-9A0056 add
       BEGIN WORK
    END IF
 
    OPEN i600_cl USING g_eca.eca01
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_eca.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0)
       ROLLBACK WORK     #FUN-680010
       RETURN
    END IF
    LET g_eca.ecamodu = g_user                     #修改者
    LET g_eca.ecadate = g_today                  #修改日期
    CALL i600_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i600_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_eca.* = g_eca_t.*
           CALL i600_show()
           CALL cl_err('',9001,0)
           ROLLBACK WORK     #FUN-680010
           EXIT WHILE
        END IF
        UPDATE eca_file SET eca_file.* = g_eca.*    # 更新DB
            WHERE eca01 = g_eca.eca01             # COLAUTH?
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","eca_file",g_eca01_t,"",SQLCA.sqlcode,"","",1) #FUN-660091
           ROLLBACK WORK     #FUN-680010
           BEGIN WORK        #FUN-680010
           CONTINUE WHILE
	ELSE
	   IF g_eca.eca01 != g_eca_t.eca01 THEN
              UPDATE ecc_file SET ecc01 = g_eca.eca01
	        WHERE ecc01= g_eca_t.eca01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ecc_file","","",SQLCA.sqlcode,"","",1) #FUN-660091
                 ROLLBACK WORK    
                 BEGIN WORK      
                 CONTINUE WHILE
              END IF
	   END IF
 
           IF g_action_choice <> "reproduce" THEN
              # CALL aws_spccli_base()
              # 傳入參數: (1)TABLE名稱, (2)修改資料,
              #           (3)功能選項：insert(新增),update(修改),delete(刪除)
              CASE aws_spccli_base('eca_file',base.TypeInfo.create(g_eca),'update')
                 WHEN 0  #無與 SPC 整合
                      MESSAGE 'UPDATE O.K'
                      LET g_success = 'Y'        #FUN-9A0056 add
                     #COMMIT WORK                #FUN-9A0056 mark
                 WHEN 1  #呼叫 SPC 成功
                      LET g_success = 'Y'        #FUN-9A0056 add
                      MESSAGE 'UPDATE O.K. UPDATE SPC O.K'
                     #COMMIT WORK                #FUN-9A0056 mark
                 WHEN 2  #呼叫 SPC 失敗
                      LET g_success = 'N'        #FUN-9A0056 add
                     #ROLLBACK WORK              #FUN-9A0056 mark
                     #BEGIN WORK                 #FUN-9A0056 mark
                     #CONTINUE WHILE             #FUN-9A0056 mark
              END CASE
              
             #FUN-9A0056 add begin ------------
              IF g_success = 'Y' THEN
                 IF g_aza.aza90 MATCHES "[Yy]" THEN
                   CALL i600_mes('update',g_eca.eca01)
                 END IF
              END IF
             #FUN-9A0056 add end --------------
           END IF
 
        END IF

       #FUN-9A0056 -- add begin ----
        IF g_success = 'N' THEN
          ROLLBACK WORK
          BEGIN WORK
          CONTINUE WHILE
        ELSE
          COMMIT WORK
        END IF
       #FUN-9A0056 -- add end ------
        EXIT WHILE
    END WHILE
    CLOSE i600_cl
END FUNCTION
 
FUNCTION i600_x()
    DEFINE
        l_chr        LIKE type_file.chr1        #No.FUN-680073 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_eca.eca01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_success = 'Y'                         #FUN-9A0056 add
    BEGIN WORK
 
    OPEN i600_cl USING g_eca.eca01
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_eca.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i600_show()
    IF cl_exp(15,22,g_eca.ecaacti) THEN
        LET g_chr=g_eca.ecaacti
        IF g_eca.ecaacti='Y' THEN
            LET g_eca.ecaacti='N'
        ELSE
            LET g_eca.ecaacti='Y'
        END IF
        UPDATE eca_file
            SET ecaacti=g_eca.ecaacti,
               ecamodu=g_user, ecadate=g_today
            WHERE eca01=g_eca.eca01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","eca_file",g_eca.eca01,"",SQLCA.sqlcode,"","",1) #FUN-660091
            LET g_eca.ecaacti=g_chr
	ELSE
  	    UPDATE ecc_file
	       SET eccacti = g_eca.ecaacti,
	           eccmodu=g_user, eccdate=g_today
             WHERE ecc01=g_eca.eca01
        END IF

       #FUN-9A0056 add begin ------------------------
       #當資料為有效變無效,傳送刪除給MES;反之,則傳送新增給MES
        IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
          IF g_eca.ecaacti='N' THEN
             CALL i600_mes('delete',g_eca.eca01)
          ELSE
             CALL i600_mes('insert',g_eca.eca01)
          END IF
        END IF
       #FUN-9A0056 add end --------------------------
       
        DISPLAY BY NAME g_eca.ecaacti
    END IF
    CLOSE i600_cl

   #FUN-9A0056 add begin ----
    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
   #FUN-9A0056 add end ------

   #COMMIT WORK   #FUN-9A0056 mark

END FUNCTION
 
FUNCTION i600_r()
    DEFINE
        l_chr         LIKE type_file.chr1         #No.FUN-680073 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_eca.eca01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    LET g_success = 'Y'                           #FUN-9A0056 add
    BEGIN WORK
 
    OPEN i600_cl USING g_eca.eca01
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_eca.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0)
       ROLLBACK WORK      #FUN-680010
       RETURN
    END IF
    IF g_eca.ecaacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_eca.eca01,'mfg1000',0)
       RETURN
    END IF
    CALL i600_show()
    IF cl_delete() THEN
       # 加上SQL判別
       DELETE FROM eca_file WHERE eca01 = g_eca.eca01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","eca_file",g_eca.eca01,"",SQLCA.sqlcode,"","",1)  
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM vmj_file where vmj01 = g_eca.eca01  #FUN-890085
       DELETE FROM ecc_file WHERE ecc01 = g_eca.eca01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","ecc_file",g_eca.eca01,"",SQLCA.sqlcode,"","",1)  
          ROLLBACK WORK
          RETURN
       END IF
 
       #刪除資料時，相關圖片資料也跟著一起刪除
       CALL cl_del_pic("eca01",g_eca.eca01,"ima04")   #FUN-B30216 add 

       # CALL aws_spccli_base()
       # 傳入參數: (1)TABLE名稱, (2)刪除資料,
       #           (3)功能選項：insert(新增),update(修改),delete(刪除)
       CASE aws_spccli_base('eca_file',base.TypeInfo.create(g_eca),'delete')
          WHEN 0  #無與 SPC 整合
               MESSAGE 'DELETE O.K'
               LET g_success = 'Y'                    #FUN-9A0056 add
          WHEN 1  #呼叫 SPC 成功
               MESSAGE 'DELETE O.K, DELETE SPC O.K'
               LET g_success = 'Y'                    #FUN-9A0056 add
          WHEN 2  #呼叫 SPC 失敗
               LET g_success = 'N'                    #FUN-9A0056 add
              #ROLLBACK WORK                          #FUN-9A0056 mark
              #RETURN                                 #FUN-9A0056 mark
       END CASE

      #FUN-9A0056 add begin ------------------------
       IF g_success = 'Y' THEN
         IF g_aza.aza90 MATCHES "[Yy]" THEN
           CALL i600_mes('delete',g_eca.eca01)
         END IF
       END IF

       IF g_success = 'N' THEN
          ROLLBACK WORK
       ELSE
          COMMIT WORK
       END IF
      #FUN-9A0056 -- add end ------
 
       CLEAR FORM
       OPEN i600_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i600_cs
          CLOSE i600_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i600_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i600_cs
          CLOSE i600_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i600_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i600_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i600_fetch('/')
       END IF
    END IF
    CLOSE i600_cl
   #COMMIT WORK         #FUN-9A0056 mark
END FUNCTION
 
FUNCTION i600_copy()
DEFINE  l_n             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
        l_eca           RECORD LIKE eca_file.*,
        l_oldno         LIKE eca_file.eca01,
        l_newno         LIKE eca_file.eca01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_eca.eca01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i600_set_entry('a')
    CALL i600_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM eca01
       AFTER FIELD eca01
          IF l_newno IS NULL THEN
              NEXT FIELD eca01
          END IF
          SELECT count(*) INTO g_cnt FROM eca_file
              WHERE eca01 = l_newno
          IF g_cnt > 0 THEN
              CALL cl_err(l_newno,-239,0)
              NEXT FIELD eca01
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
        DISPLAY BY NAME g_eca.eca01
        RETURN
    END IF
    LET l_eca.* = g_eca.*
    LET l_eca.eca01  =l_newno
    LET l_eca.ecauser=g_user    #資料所有者
    LET l_eca.ecagrup=g_grup    #資料所有者所屬群
    LET l_eca.ecamodu=NULL      #資料修改日期
    LET l_eca.ecadate=g_today   #資料建立日期
    LET l_eca.ecaacti='Y'       #有效資料
    LET g_success = 'Y'         #FUN-9A0056 add
 
    BEGIN WORK    #FUN-680010
 
    LET l_eca.ecaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_eca.ecaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO eca_file VALUES(l_eca.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","eca_file",l_eca.eca01,"",SQLCA.sqlcode,"","",1) #FUN-660091
       ROLLBACK WORK  #FUN-680010
    ELSE
       INSERT INTO ecc_file(ecc01,ecc02,ecc03,ecc04,ecc05,eccacti,eccuser,  #No.MOD-470041
                           eccgrup,eccmodu,eccdate,eccoriu,eccorig)
           VALUES(l_eca.eca01,'','','',' ',l_eca.ecaacti,l_eca.ecauser,
                  l_eca.ecagrup,l_eca.ecamodu, l_eca.ecadate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
      
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","eca_file",l_eca.eca01,"",SQLCA.sqlcode,"","",1) #FUN-660091
          ROLLBACK WORK  #FUN-680010
          RETURN         #FUN-680010
       END IF
      
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_eca.eca01
       SELECT eca_file.* INTO g_eca.*
         FROM eca_file WHERE eca01 = l_newno
       CALL i600_u()
 
       # CALL aws_spccli_base()
       # 傳入參數: (1)TABLE名稱, (2)新增資料,
       #           (3)功能選項：insert(新增),update(修改),delete(刪除)
       CASE aws_spccli_base('eca_file',base.TypeInfo.create(g_eca),'insert')
          WHEN 0  #無與 SPC 整合
               MESSAGE 'INSERT O.K'
               LET g_success = 'Y'                  #FUN-9A0056 add
              #COMMIT WORK                          #FUN-9A0056 mark
          WHEN 1  #呼叫 SPC 成功
               MESSAGE 'INSERT O.K, INSERT SPC O.K'
               LET g_success = 'Y'                  #FUN-9A0056 add
              #COMMIT WORK                          #FUN-9A0056 mark
          WHEN 2  #呼叫 SPC 失敗
               LET g_success = 'N'                  #FUN-9A0056 add
              #ROLLBACK WORK                        #FUN-9A0056 mark
       END CASE

      #FUN-9A0056 add begin ---
       IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
         CALL i600_mes('insert',g_eca.eca01)
       END IF

       IF g_success = 'N' THEN
         ROLLBACK WORK
       ELSE
         COMMIT WORK
       END IF
      #FUN-9A0056 add end ------
       #FUN-C30027---begin
       #SELECT eca_file.* INTO g_eca.*
       #  FROM eca_file WHERE eca01 = l_oldno
       #FUN-C30027---end
       CALL i600_show()
       
    END IF
    DISPLAY BY NAME g_eca.eca01
END FUNCTION
 
FUNCTION i600_out()
    DEFINE
        l_i             LIKE type_file.num5,       #No.FUN-680073 SMALLINT
        l_name          LIKE type_file.chr20,      # External(Disk) file name #No.FUN-680073 VARCHAR(20) 
        l_eca   RECORD  LIKE eca_file.*,
	l_gem02         LIKE gem_file.gem02,
        l_za05          LIKE za_file.za05,         #No.FUN-680073 VARCHAR(40)
        l_chr           LIKE type_file.chr1        #No.FUN-680073 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
       LET g_wc=" eca01='",g_eca.eca01,"'"
    END IF
 
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    CALL cl_del_data(l_table)                      #No.FUN-760085   
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aeci600'  #No.FUN-760085
    LET g_sql="SELECT * FROM eca_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE aeci600_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE aeci600_curo                         # SCROLL CURSOR
        CURSOR FOR aeci600_p1
 
 
    FOREACH aeci600_curo INTO l_eca.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
	SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_eca.eca03
	IF SQLCA.sqlcode THEN LET l_gem02 ='' END IF
        EXECUTE insert_prep USING l_eca.eca01,l_eca.eca02,l_eca.eca03,l_gem02,
                                  l_eca.eca04,l_eca.eca06,l_eca.eca14,
                                  l_eca.ecaacti
    END FOREACH
 
 
    CLOSE aeci600_curo
    ERROR ""
    IF g_zz05 = 'Y' THEN     
       CALL  cl_wcchp(g_wc,'eca01,eca02,eca03,eca04,eca06,eca14,ecaacti')
             RETURNING g_wc    
       LET g_str = g_str CLIPPED,";", g_wc   
    END IF 
    LET g_str = g_wc  
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED  
    CALL cl_prt_cs3('aeci600','aeci600',l_sql,g_str)  
END FUNCTION

 
FUNCTION i600_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1                #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("eca01",TRUE)
   END IF
 
   IF (NOT g_before_input_done) THEN
       #正常工作站成本維護
       CALL cl_set_comp_entry("eca14,eca15,eca16,eca17,eca26,eca27,eca18,eca19",TRUE)
       CALL cl_set_comp_entry("eca28,eca29,eca20,eca21,eca30,eca31,eca201,eca211,eca301,eca311",TRUE)
       CALL cl_set_comp_entry("eca22,eca23,eca32,eca33,eca24,eca25,eca34,eca35",TRUE)
       #廠內�廠外加工成本維護
       CALL cl_set_comp_entry("eca36,eca37,eca42,eca43",TRUE)
       #廠內加工成本維護
       CALL cl_set_comp_entry("eca38,eca39,eca44,eca45,eca40,eca41,eca46,eca47",TRUE)
   END IF
END FUNCTION
 
FUNCTION i600_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1                #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("eca01",FALSE)
   END IF
 
   #正常工作站成本維護
   IF g_eca.eca04 <> '0' THEN
       CALL cl_set_comp_entry("eca14,eca15,eca16,eca17,eca26,eca27,eca18,eca19",FALSE)
       CALL cl_set_comp_entry("eca28,eca29,eca20,eca21,eca30,eca31,eca201,eca211,eca301,eca311",FALSE)
       CALL cl_set_comp_entry("eca22,eca23,eca32,eca33,eca24,eca25,eca34,eca35",FALSE)
       CALL cl_set_comp_entry("eca36,eca37,eca42,eca43",TRUE)                                           #No.TQC-A50063
   END IF
   #廠內�廠外加工成本維護
   IF g_eca.eca04 ='0' THEN
       CALL cl_set_comp_entry("eca36,eca37,eca42,eca43",FALSE)
       CALL cl_set_comp_entry("eca14,eca15,eca16,eca17,eca26,eca27,eca18,eca19",TRUE)                    #No.TQC-A50063
       CALL cl_set_comp_entry("eca28,eca29,eca20,eca21,eca30,eca31,eca201,eca211,eca301,eca311",TRUE)    #No.TQC-A50063
       CALL cl_set_comp_entry("eca22,eca23,eca32,eca33,eca24,eca25,eca34,eca35",TRUE)                    #No.TQC-A50063
   END IF
   #廠內加工成本維護
   IF g_eca.eca04 <> '2' THEN
       CALL cl_set_comp_entry("eca38,eca39,eca44,eca45,eca40,eca41,eca46,eca47",FALSE)
   ELSE                                                                                                  #No.TQC-A50063
   	  CALL cl_set_comp_entry("eca38,eca39,eca44,eca45,eca40,eca41,eca46,eca47",TRUE)                     #No.TQC-A50063
   END IF
 
END FUNCTION

#No.FUN-9C0077 程式精簡

#FUN-9A0056 add --------------------
FUNCTION i600_mes(p_key1,p_key2)
 DEFINE p_key1   VARCHAR(6)
 DEFINE p_key2   VARCHAR(500)
 DEFINE l_mesg01 VARCHAR(30)

 CASE p_key1
    WHEN 'insert'  #新增
         LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
    WHEN 'update'  #修改
         LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
    WHEN 'delete'  #刪除
         LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
    OTHERWISE
 END CASE

# CALL aws_mescli
# 傳入參數: (1)程式代號
#           (2)功能選項：insert(新增),update(修改),delete(刪除)
#           (3)Key
 CASE aws_mescli('aeci600',p_key1,p_key2)
    WHEN 1  #呼叫 MES 成功
         MESSAGE l_mesg01
         LET g_success = 'Y'
    WHEN 2  #呼叫 MES 失敗
         LET g_success = 'N'
    OTHERWISE  #其他異常
         LET g_success = 'N'
 END CASE

END FUNCTION
#FUN-9A0056 add end ----------------
#FUN-B80046
