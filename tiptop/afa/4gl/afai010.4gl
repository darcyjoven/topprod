# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Pattern name...: afai010.4gl
# Descriptions...: 固定資產主要類別維護作業
# Date & Author..: 96/04/19 By Sophia
# Modify.........: No:A099 2004/06/28 By Danny  新增大陸折舊方式
# Modify.........: No.MOD-470506 04/07/23 By Nicola 新增時會出現錯誤訊息
# Modify.........: No.MOD-470515 04/07/23 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4C0059 04/12/08 By Smapmin 加入權限控管
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-570148 05/08/03 By Smapmin 輸入時即判斷資產/折舊/累折科目都有輸入
# Modify.........: No.FUN-5A0204 05/11/04 By Sarah fab04<>'0'=>fab12,fab13 set_entry,fab04='0'=>fab12,fab13 set_no_entry
# Modify.........: No.FUN-5B0087 05/11/23 By Sarah fab17,fab18,fab19選項改成只有0,1
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/22 By zhuying 多套帳修改                                                                                                  
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i010_q() 一開始應清空g_fab.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-710112 07/03/26 By Judy 比率不可小于0或者大于100
# Modify.........: No.FUN-740026 07/04/10 By mike 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770005 07/07/03 By hongmei 報表格式修改為Crystal Report
# Modify.........: No.MOD-810044 08/01/07 By Smapmin 不提折舊時,折舊與累折科目不可輸入
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/13 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.MOD-860160 08/06/16 By Sarah 判斷fab03資產性質不為'5'時,才需要檢核afa-349
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.MOD-940367 09/04/28 By chenl   復制時，對科目欄位進行清空，以便重新對科目進行設置。
# Modify.........: No.TQC-950161 09/05/26 By xiaofeizhu 資料無效時，不可刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B30041 11/03/11 By zhangweib afa-349 限制取消
# Modify.........: No.FUN-AB0088 11/04/02 By lixiang 固定资料財簽二功能
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60043 11/06/10 By Dido 財簽二科目檢核有誤 
# Modify.........: No.MOD-B70220 11/07/22 By Polly 在新增fab_file前,增加判斷若fab042是null,則給予預設值=fab04
# Modify.........: No.MOD-BB0142 11/11/11 By Carrier 科目检查修改 
# Modify.........: No:FUN-BB0113 11/11/22 By xuxz      處理固資財簽二重測BUG
# Modify.........: No:TQC-C10113 12/01/30 By wujie 查询时增加oriu，orig栏位 
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C60071 12/06/08 By Elise fab08/fab082預設為 'N'
# Modify.........: No:CHI-C50026 12/07/05 By Elise 殘值率應在功能別選中國時才顯示，其餘應隱藏
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-D30223 13/03/26 By Polly 取消投資遞減率不能等於100的控卡

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fab               RECORD LIKE fab_file.*,
    g_fab_t             RECORD LIKE fab_file.*,
    g_fab_o             RECORD LIKE fab_file.*,
    g_fab01_t           LIKE fab_file.fab01,
    g_b1                LIKE type_file.chr20,           #No.FUN-680070 VARCHAR(15)
    g_d1                LIKE type_file.chr20,           #No.FUN-680070 VARCHAR(15)
    g_wc,g_sql          string  #No.FUN-580092 HCN
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_str          STRING                      #No.FUN-770005         
DEFINE g_argv1     LIKE fab_file.fab01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
    INITIALIZE g_fab.* TO NULL
    INITIALIZE g_fab_t.* TO NULL
    INITIALIZE g_fab_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM fab_file WHERE fab01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_cl CURSOR  FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i010_w WITH FORM "afa/42f/afai010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    
    IF g_aza.aza26 = '2' THEN
       CALL i010_set_comb()
       CALL i010_set_comments()
    END IF

   #CHI-C50026---S---
    IF g_faa.faa31 = 'Y' THEN
       IF g_aza.aza26 = '2' THEN
          CALL cl_set_comp_visible("fab232",TRUE)
       ELSE
          CALL cl_set_comp_visible("fab232",FALSE)
          CALL cl_set_comp_lab_text("text",' ')
       END IF
    END IF
    IF g_aza.aza26 = '2' THEN
       CALL cl_set_comp_visible("fab23",TRUE)
    ELSE
       CALL cl_set_comp_visible("fab23",FALSE)
       CALL cl_set_comp_lab_text("%",' ')
    END IF
   #CHI-C50026---E---
 
  # IF g_aza.aza63 = 'Y' THEN
    IF g_faa.faa31 = 'Y' THEN  #FUN-AB0088
       CALL cl_set_comp_visible("fab111,fab121,fab131,fab241,aag02_11,aag02_21,aag02_31,aag02_41",TRUE)
      #CALL cl_set_comp_visible("fab042,fab052,fab082,fab102,fab232",TRUE)  #FUN-AB0088  #CHI-C50026 mark
       CALL cl_set_comp_visible("fab042,fab052,fab082,fab102",TRUE)         #CHI-C50026
    ELSE
       CALL cl_set_comp_visible("fab111,fab121,fab131,fab241,aag02_11,aag02_21,aag02_31,aag02_41",FALSE)
      #CALL cl_set_comp_visible("fab042,fab052,fab082,fab102,fab232",FALSE)  #FUN-AB0088  #CHI-C50026 mark
       CALL cl_set_comp_visible("fab042,fab052,fab082,fab102",FALSE)         #CHI-C50026 
    END IF
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i010_a()
            END IF
         OTHERWISE        
            CALL i010_q() 
      END CASE
   END IF
 
    LET g_action_choice=""
    CALL i010_menu()
 
    CLOSE WINDOW i010_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
END MAIN
 
FUNCTION i010_cs()
    CLEAR FORM
   INITIALIZE g_fab.* TO NULL    #No.FUN-750051
 
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" fab01='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        fab01,fab02,fab03,fab04,fab23,fab05,fab08,fab06,fab07,fab10,
        fab042,fab232,fab052,fab082,fab102,   #FUN-AB0088
        fab14,fab15,fab16,fab17,fab18,
        fab19,fab20,fab21,fab22,fab11,fab12,fab13,fab24,    #No:A099
        fab111,fab121,fab131,fab241,                        #FUN-680028
        fabuser,fabgrup,faboriu,faborig,fabmodu,fabdate,fabacti   #No.TQC-C10113 add oriu,orig
       ,fabud01,fabud02,fabud03,fabud04,fabud05,
       fabud06,fabud07,fabud08,fabud09,fabud10,
       fabud11,fabud12,fabud13,fabud14,fabud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(fab11)   #資產科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fab11
                 NEXT FIELD fab11
              WHEN INFIELD(fab12)   #累折科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fab12
                 NEXT FIELD fab12
              WHEN INFIELD(fab13)   #折舊科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab13
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fab13
                 NEXT FIELD fab13
              WHEN INFIELD(fab24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab24
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fab24
                 NEXT FIELD fab24
              WHEN INFIElD(fab111)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab111
                 CALL cl_create_qry() RETURNING g_qryparam.multiret    
                 DISPLAY g_qryparam.multiret TO fab111
                 NEXT FIELD fab111
              WHEN INFIELD(fab121)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab121
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fab121
                 NEXT FIELD fab121
              WHEN INFIELD(fab131)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab131
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fab131
                 NEXT FIELD fab131
              WHEN INFIELD(fab241)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab241
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fab241
                 NEXT FIELD fab241
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
 
    IF INT_FLAG THEN RETURN END IF
   END IF  #FUN-7C0050

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fabuser', 'fabgrup')
 
    LET g_sql="SELECT fab01 FROM fab_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY fab01"
    PREPARE i010_prepare FROM g_sql           # RUNTIME 編譯
        IF STATUS THEN CALL cl_err('prepare:',STATUS,0) RETURN END IF
    DECLARE i010_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i010_prepare
 
    LET g_sql= "SELECT COUNT(*) FROM fab_file ",
               " WHERE ",g_wc CLIPPED
    PREPARE i010_count_pre   FROM g_sql
    DECLARE i010_count CURSOR FOR i010_count_pre #CKP
END FUNCTION
 
FUNCTION i010_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i010_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i010_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i010_fetch('N')
        ON ACTION previous
            CALL i010_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i010_u()
            END IF
            NEXT OPTION "next"
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i010_x()
            END IF
            NEXT OPTION "next"
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i010_r()
            END IF
            NEXT OPTION "next"
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i010_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i010_out()
            END IF
        ON ACTION related_document    #No.MOD-470515
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_fab.fab01 IS NOT NULL THEN
                LET g_doc.column1 = "fab01"
                LET g_doc.value1 = g_fab.fab01
                CALL cl_doc()
             END IF
          END IF
 
       ON ACTION help
           CALL cl_show_help()
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          IF g_aza.aza26 = '2' THEN
             CALL i010_set_comb()
             CALL i010_set_comments()
          END IF
       ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL i010_fetch('/')
        ON ACTION first
            CALL i010_fetch('F')
        ON ACTION last
            CALL i010_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i010_cs
END FUNCTION
 
 
FUNCTION i010_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_fab.* LIKE fab_file.*
    LET g_fab01_t        = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fab.fab20 = 20
        LET g_fab.fab21 = 10
        LET g_fab.fabacti ='Y'                   #有效的資料
        LET g_fab.fab14 ='Y'                     #有效的資料
         LET g_fab.fab08 ='N'                     #有效的資料  #No.MOD-470506
        LET g_fab.fab15 ='1'                     #有效的資料
        LET g_fab.fab16 ='1'                     #有效的資料
        LET g_fab.fab17 ='1'                     #有效的資料
        LET g_fab.fab18 ='1'                     #有效的資料
        LET g_fab.fab19 ='1'                     #有效的資料
        LET g_fab.fab05 =0                       #有效的資料no:5153
        LET g_fab.fab07 =0                       #有效的資料no:5153
        LET g_fab.fab10 =0                       #有效的資料no:5153
        LET g_fab.fab22 =0                       #有效的資料no:5153
        LET g_fab.fab082='N'   #No:FUN-AB0088
        LET g_fab.fab052=0     #No:FUN-AB0088
        LET g_fab.fab102=0     #No:FUN-AB0088
        LET g_fab.fabuser = g_user               #使用者
        LET g_fab.faboriu = g_user #FUN-980030
        LET g_fab.faborig = g_grup #FUN-980030
        LET g_fab.fabgrup = g_grup               #使用者所屬群
        LET g_fab.fabdate = g_today
        DISPLAY BY NAME g_fab.fab01, g_fab.fab14, g_fab.fab15,
                        g_fab.fab16, g_fab.fab17, g_fab.fab18,
                        g_fab.fab19, g_fab.fab20, g_fab.fab21
        CALL i010_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_fab.*  TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_fab.fab01) THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF cl_null(g_fab.fab042) THEN            #No.MOD-B70220 add
           LET g_fab.fab042=g_fab.fab04          #No.MOD-B70220 add
        END IF                                   #No.MOD-B70220 add
        INSERT INTO fab_file VALUES(g_fab.*)     #DISK WRITE
        DISPLAY SQLCA.SQLCODE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","fab_file",g_fab.fab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        ELSE
            LET g_fab_t.* = g_fab.*                # 保存上筆資料
            SELECT fab01 INTO g_fab.fab01 FROM fab_file
             WHERE fab01 = g_fab.fab01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i010_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        g_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
        l_modify_flag   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_lock_sw       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_exit_sw       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_n             LIKE type_file.num5         #No.FUN-680070 SMALLINT
    INPUT BY NAME g_fab.fab01,g_fab.fab02,g_fab.fab03,g_fab.fab04,g_fab.fab23, g_fab.faboriu,g_fab.faborig,
                  g_fab.fab05,g_fab.fab08,g_fab.fab06,g_fab.fab07,g_fab.fab10,
                  g_fab.fab042,g_fab.fab232,g_fab.fab052,g_fab.fab082,g_fab.fab102,   #FUN-AB0088
                  g_fab.fab14,g_fab.fab15,g_fab.fab16,g_fab.fab17,g_fab.fab18,
                  g_fab.fab19,g_fab.fab20,g_fab.fab21,g_fab.fab22,g_fab.fab11,
                  g_fab.fab12,g_fab.fab13,g_fab.fab24,
                  g_fab.fab111,g_fab.fab121,g_fab.fab131,g_fab.fab241,       #FUN-680028         
                  g_fab.fabuser,g_fab.fabgrup,
                  g_fab.fabmodu,g_fab.fabdate,g_fab.fabacti
                 ,g_fab.fabud01,g_fab.fabud02,g_fab.fabud03,g_fab.fabud04,
                  g_fab.fabud05,g_fab.fabud06,g_fab.fabud07,g_fab.fabud08,
                  g_fab.fabud09,g_fab.fabud10,g_fab.fabud11,g_fab.fabud12,
                  g_fab.fabud13,g_fab.fabud14,g_fab.fabud15 
        WITHOUT DEFAULTS

 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i010_set_entry(p_cmd)
            CALL i010_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
 
        AFTER FIELD fab01
            IF NOT cl_null(g_fab.fab01) THEN      #不可空白
               IF p_cmd = 'a' OR (p_cmd = 'u' AND
                  g_fab.fab01 != g_fab_t.fab01 ) THEN  #check 編號是否重複
                   SELECT count(*) INTO l_n FROM fab_file
                       WHERE fab01 = g_fab.fab01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_fab.fab01 = g_fab_t.fab01
                       DISPLAY BY NAME g_fab.fab01
                       NEXT FIELD fab01
                   END IF
               END IF
            END IF
 
        BEFORE FIELD fab02
            LET l_modify_flag = 'Y'
            IF (l_lock_sw = 'Y') THEN            #已鎖住
                LET l_modify_flag = 'N'
            END IF
            IF (l_modify_flag = 'N') THEN
                LET g_fab.fab01 = g_fab_t.fab01
                DISPLAY BY NAME g_fab.fab01
                NEXT FIELD fab01
            END IF
 
         BEFORE FIELD fab03
            CALL i010_set_entry(p_cmd)
 
        AFTER FIELD fab03
            IF NOT cl_null(g_fab.fab03) THEN
               IF g_fab.fab03 NOT MATCHES '[1-5]' THEN
                  LET g_fab.fab03 = g_fab_t.fab03
                  DISPLAY BY NAME g_fab.fab03
                  NEXT FIELD fab03
               END IF
               IF g_fab.fab03='3' THEN
                  LET g_fab.fab04='0'
                  LET g_fab.fab06='0'
                  LET g_fab.fab05='0'
                  LET g_fab.fab07='0'
                 #LET g_fab.fab08='0'   #MOD-C60071 mark
                  LET g_fab.fab08='N'   #MOD-C60071
                  LET g_fab.fab10='0'
                  #-----No:FUN-AB0088-----
                  LET g_fab.fab042='0'
                  LET g_fab.fab052='0'
                 #LET g_fab.fab082='0'  #MOD-C60071 mark
                  LET g_fab.fab082='N'  #MOD-C60071
                  LET g_fab.fab102='0'
                  #-----No:FUN-AB0088 END-----
                  DISPLAY BY NAME g_fab.fab04,g_fab.fab06
                  DISPLAY BY NAME g_fab.fab05,g_fab.fab07
                  DISPLAY BY NAME g_fab.fab08,g_fab.fab10
                  DISPLAY BY NAME g_fab.fab042,g_fab.fab052   #No:FUN-AB0088
                  DISPLAY BY NAME g_fab.fab082,g_fab.fab102   #No:FUN-AB0088
               END IF
            END IF
            CALL i010_set_no_entry(p_cmd)
 
        BEFORE FIELD fab04
            CALL i010_set_entry(p_cmd)
 
        AFTER FIELD fab04
            IF NOT cl_null(g_fab.fab04) THEN
               IF g_fab.fab04 NOT MATCHES '[0-5]' THEN
                  LET g_fab.fab04 = g_fab_t.fab04
                  DISPLAY BY NAME g_fab.fab04
                  NEXT FIELD fab04
               END IF
               IF g_fab.fab04='0' THEN
                  LET g_fab.fab05=0
                  LET g_fab.fab10=0
                  LET g_fab.fab08='N'
                  DISPLAY BY NAME g_fab.fab05,g_fab.fab07,g_fab.fab10,g_fab.fab08
               END IF
               IF g_fab.fab04 <> g_fab_o.fab04 OR g_fab_o.fab04 IS NULL THEN
                  IF p_cmd = 'a' THEN
                     LET g_fab.fab06 = g_fab.fab04
                     LET g_fab.fab042= g_fab.fab04   #No:FUN-AB0088
                     DISPLAY BY NAME g_fab.fab06,g_fab.fab042   #No:FUN-AB0088
                     DISPLAY BY NAME g_fab.fab06
                  END IF
               END IF
               LET g_fab_o.fab04 = g_fab.fab04
               CALL i010_set_no_entry(p_cmd)
            END IF
        
        #-----No:FUN-AB0088-----
        BEFORE FIELD fab042
            CALL i010_set_entry(p_cmd)

        AFTER FIELD fab042
            IF NOT cl_null(g_fab.fab042) THEN
               IF g_fab.fab042 NOT MATCHES '[0-5]' THEN
                  LET g_fab.fab042 = g_fab_t.fab042
                  DISPLAY BY NAME g_fab.fab042
                  NEXT FIELD fab042
               END IF
               IF g_fab.fab042='0' THEN
                  LET g_fab.fab052=0
                  LET g_fab.fab102=0
                  LET g_fab.fab082='N'
                  DISPLAY BY NAME g_fab.fab052,g_fab.fab102,g_fab.fab082
               END IF
               LET g_fab_o.fab042 = g_fab.fab042
               CALL i010_set_no_entry(p_cmd)
            END IF
        #-----No:FUN-AB0088 END-----
 
        AFTER FIELD fab05
            IF g_fab.fab05 <> g_fab_o.fab05 OR g_fab_o.fab05 IS NULL THEN
               IF p_cmd = 'a' THEN
                  LET g_fab.fab07 = g_fab.fab05
                  LET g_fab.fab052= g_fab.fab05   #No:FUN-AB0088
                  DISPLAY BY NAME g_fab.fab07,g_fab.fab052   #No:FUN-AB0088
                  DISPLAY BY NAME g_fab.fab07
               END IF
            END IF
            LET g_fab_o.fab05 = g_fab.fab05
 
        AFTER FIELD fab06
            IF NOT cl_null(g_fab.fab06) THEN
               IF g_fab.fab06 NOT MATCHES '[0-5]' THEN
                  LET g_fab.fab06 = g_fab_t.fab06
                  DISPLAY BY NAME g_fab.fab06
                  NEXT FIELD fab06
               END IF
               IF g_fab.fab06='0' THEN
                  LET  g_fab.fab07=0
                  DISPLAY BY NAME g_fab.fab07
               END IF
            END IF
 
        BEFORE FIELD fab08
            CALL i010_set_entry(p_cmd)

        #-----No:FUN-AB0088-----
        BEFORE FIELD fab082
            CALL i010_set_entry(p_cmd)

        AFTER FIELD fab082
            IF g_fab.fab082 MATCHES '[YN]' THEN
               IF g_fab.fab082 = 'N' THEN
                  LET g_fab.fab102 = 0
                  DISPLAY BY NAME g_fab.fab102
               END IF
               CALL i010_set_no_entry(p_cmd)
            END IF
        #-----No:FUN-AB0088 END-----
        
        AFTER FIELD fab08
            IF g_fab.fab08 MATCHES '[YN]' THEN
               IF g_fab.fab08 = 'N' THEN
                  LET g_fab.fab10 = 0
                  DISPLAY BY NAME g_fab.fab10
               END IF
               CALL i010_set_no_entry(p_cmd)
            END IF
 
        AFTER FIELD fab11
            LET g_errno = ' '
            IF NOT cl_null(g_fab.fab11) THEN
               #No.MOD-BB0142  --Begin
               #CALL i010_fab11('a')
               CALL i010_aag('a','1')
               #No.MOD-BB0142  --End  
            ELSE
                CALL cl_err('','aap-099',0)   #MOD-570148
                NEXT FIELD fab11    #MOD-570148
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fab.fab11,g_errno,0)
               #FUN-B10049--begin
               #LET g_fab.fab11 = g_fab_t.fab11
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_fab.fab11  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_fab.fab11 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_fab.fab11 
               #FUN-B10049--end                   
               DISPLAY BY NAME g_fab.fab11
               NEXT FIELD fab11
            END IF
#------------No.FUN-B30041 BEGIN Mark-------------------------------
#           IF p_cmd = 'a' OR (p_cmd ='u' AND (g_fab.fab10 !=g_fab_t.fab11 OR cl_null(g_fab_t.fab11))) THEN  #No.MOD-940367
#              IF g_fab.fab03!='5' THEN   #MOD-860160 add
#                 SELECT COUNT(*) INTO g_cnt FROM fab_file
#                 WHERE fab11 = g_fab.fab11
#                 IF g_cnt > 0 THEN
#                   CALL cl_err(g_fab.fab11,'afa-349',0)
#                   NEXT FIELD fab11
#                 END IF
#              END IF   #MOD-860160 add
#           END IF
#------------No.FUN-B30041 END Mark-------------------------------
        AFTER FIELD fab12
            LET g_errno = ' '
            IF NOT cl_null(g_fab.fab12) THEN
               #No.MOD-BB0142  --Begin
               #CALL i010_fab12('a')
               CALL i010_aag('a','2')
               #No.MOD-BB0142  --End  
            ELSE
                CALL cl_err('','aap-099',0)   #MOD-570148
                NEXT FIELD fab12    #MOD-570148
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fab.fab12,g_errno,0)
               #FUN-B10049--begin
               #LET g_fab.fab12 = g_fab_t.fab12
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_fab.fab12  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_fab.fab12 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_fab.fab12
               #FUN-B10049--end                  
               DISPLAY BY NAME g_fab.fab12
               NEXT FIELD fab12
            END IF
 
        AFTER FIELD fab13
            LET g_errno = ' '
            IF NOT cl_null(g_fab.fab13) THEN
               #No.MOD-BB0142  --Begin
               #CALL i010_fab13('a')
               CALL i010_aag('a','3')
               #No.MOD-BB0142  --End  
            ELSE
                CALL cl_err('','aap-099',0)   #MOD-570148
                NEXT FIELD fab13    #MOD-570148
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fab.fab13,g_errno,0)
               #FUN-B10049--begin
               #LET g_fab.fab13 = g_fab_t.fab13
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_fab.fab13  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_fab.fab13 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_fab.fab13
               #FUN-B10049--end                  
               DISPLAY BY NAME g_fab.fab13
               NEXT FIELD fab13
            END IF
        
        AFTER FIELD fab24
            LET g_errno = ' '
            IF NOT cl_null(g_fab.fab24) THEN
               #No.MOD-BB0142  --Begin
               #CALL i010_fab24('a')
               CALL i010_aag('a','4')
               #No.MOD-BB0142  --End  
            ELSE
               DISPLAY ' ' TO FORMONLY.aag02_4
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fab.fab24,g_errno,0)
               #FUN-B10049--begin
               #LET g_fab.fab24 = g_fab_t.fab24               
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_fab.fab24  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_fab.fab24 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_fab.fab24
               #FUN-B10049--end                            
               DISPLAY BY NAME g_fab.fab24
               NEXT FIELD fab24
            END IF
        AFTER FIELD fab111                                                                                                          
            LET g_errno = ' '                                                                                                       
            IF NOT cl_null(g_fab.fab111) THEN                                                                                       
               #No.MOD-BB0142  --Begin
               #CALL i010_fab111('a')                                                                                                
               CALL i010_aag('a','5')
               #No.MOD-BB0142  --End  
            ELSE                                                                                                                    
               CALL cl_err('','aap-099',0)                                                                                          
               NEXT FIELD fab111                                                                                                    
            END IF                                                                                                                  
            IF NOT cl_null(g_errno) THEN                                                                                            
               CALL cl_err(g_fab.fab111,g_errno,0)   
               #FUN-B10049--begin                                                                               
               #LET g_fab.fab111 = g_fab_t.fab111   
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_fab.fab111  
               LET g_qryparam.construct = 'N'                
               #LET g_qryparam.arg1 = g_aza.aza82   #FUN-BB0113 mark
               LET g_qryparam.arg1 = g_faa.faa02c #FUN-BB0113 add
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_fab.fab111 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_fab.fab111
               #FUN-B10049--end                                                                                                           
               DISPLAY BY NAME g_fab.fab111                                                                                         
               NEXT FIELD fab111                                                                                                    
            END IF                             
#------------No.FUN-B30041 BEGIN Mark-------------------------------                                                                                     
#           IF p_cmd = 'a' OR (p_cmd ='u' AND (g_fab.fab111 !=g_fab_t.fab111 OR cl_null(g_fab_t.fab111))) THEN  #No.MOD-940367
#              IF g_fab.fab03!='5' THEN   #MOD-860160 add
#                 SELECT COUNT(*) INTO g_cnt FROM fab_file                                                                             
#                  WHERE fab111= g_fab.fab111                                                                                          
#                 IF g_cnt > 0 THEN                                                                                                    
#                    CALL cl_err(g_fab.fab111,'afa-349',0)                                                                             
#                    NEXT FIELD fab111                                                                                                 
#                 END IF                                    
#              END IF   #MOD-860160 add                                                                           
#           END IF
#------------No.FUN-B30041 END Mark------------------------------- 

        AFTER FIELD fab121                                                                                                          
            LET g_errno = ' '                                                                                                       
            IF NOT cl_null(g_fab.fab121) THEN                                                                                       
               #No.MOD-BB0142  --Begin
               #CALL i010_fab121('a')                                                                                                
               CALL i010_aag('a','6')
               #No.MOD-BB0142  --End  
            ELSE                                                                                                                    
               CALL cl_err('','aap-099',0)                                                                                          
               NEXT FIELD fab121                                                                                                    
            END IF                                                                                                                  
            IF NOT cl_null(g_errno) THEN                                                                                            
               CALL cl_err(g_fab.fab121,g_errno,0) 
               #FUN-B10049--begin                                                                                 
               #LET g_fab.fab121 = g_fab_t.fab121    
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_fab.fab121  
               LET g_qryparam.construct = 'N'                
               #LET g_qryparam.arg1 = g_aza.aza82   #FUN-BB0113 mark
               LET g_qryparam.arg1 = g_faa.faa02c #FUN-BB0113 add
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_fab.fab121 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_fab.fab121
               #FUN-B10049--end                                                                                                           
               DISPLAY BY NAME g_fab.fab121                                                                                         
               NEXT FIELD fab121                                                                                                    
            END IF
 
        AFTER FIELD fab131                                                                                                          
            LET g_errno = ' '                                                                                                       
            IF NOT cl_null(g_fab.fab131) THEN                                                                                       
               #No.MOD-BB0142  --Begin
               #CALL i010_fab131('a')                                                                                                
               CALL i010_aag('a','7')
               #No.MOD-BB0142  --End  
            ELSE                                                                                                                    
               CALL cl_err('','aap-099',0)                                                                                          
               NEXT FIELD fab131                                                                                                    
            END IF                                                                                                                  
            IF NOT cl_null(g_errno) THEN                                                                                            
               CALL cl_err(g_fab.fab131,g_errno,0)      
               #FUN-B10049--begin                                                                            
               #LET g_fab.fab131 = g_fab_t.fab131   
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_fab.fab131  
               LET g_qryparam.construct = 'N'                
               #LET g_qryparam.arg1 = g_aza.aza82   #FUN-BB0113 mark
               LET g_qryparam.arg1 = g_faa.faa02c #FUN-BB0113 add
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_fab.fab131 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_fab.fab131
               #FUN-B10049--end                                                                                                     
               DISPLAY BY NAME g_fab.fab131                                                                                         
               NEXT FIELD fab131                                                                                                    
            END IF
      
        AFTER FIELD fab241
            LET g_errno = ' '
            IF NOT cl_null(g_fab.fab241) THEN
               #No.MOD-BB0142  --Begin
               #CALL i010_fab241('a')
               CALL i010_aag('a','8')
               #No.MOD-BB0142  --End  
            ELSE
               DISPLAY ' ' TO FORMONLY.aag02_41
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fab.fab241,g_errno,0)
               #FUN-B10049--begin      
               #LET g_fab.fab241 = g_fab_t.fab241
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_fab.fab241  
               LET g_qryparam.construct = 'N'                
               #LET g_qryparam.arg1 = g_aza.aza82   #FUN-BB0113 mark
               LET g_qryparam.arg1 = g_faa.faa02c #FUN-BB0113 add
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_fab.fab241 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_fab.fab241
               #FUN-B10049--end                       
               DISPLAY BY NAME g_fab.fab241
               NEXT FIELD fab241
             END IF
 
        AFTER FIELD fab15
            IF g_fab.fab15 NOT MATCHES '[0-1]' THEN
               LET g_fab.fab15 = g_fab_t.fab15
               DISPLAY BY NAME g_fab.fab15
               NEXT FIELD fab15
            END IF
 
        AFTER FIELD fab16
            IF g_fab.fab16 NOT MATCHES '[0-2]' THEN
               LET g_fab.fab16 = g_fab_t.fab16
               DISPLAY BY NAME g_fab.fab16
               NEXT FIELD fab16
            END IF
 
        AFTER FIELD fab17
            IF g_fab.fab17 NOT MATCHES '[0-1]' THEN   #FUN-5B0087
               LET g_fab.fab17 = g_fab_t.fab17
               DISPLAY BY NAME g_fab.fab17
               NEXT FIELD fab17
            END IF
 
        AFTER FIELD fab18
            IF g_fab.fab18 NOT MATCHES '[0-1]' THEN   #FUN-5B0087
               LET g_fab.fab18 = g_fab_t.fab18
               DISPLAY BY NAME g_fab.fab18
               NEXT FIELD fab18
            END IF
 
        AFTER FIELD fab19
            IF g_fab.fab19 NOT MATCHES '[0-1]' THEN   #FUN-5B0087
               LET g_fab.fab19 = g_fab_t.fab19
               DISPLAY BY NAME g_fab.fab19
               NEXT FIELD fab19
            END IF
        AFTER FIELD fab20                                                       
           IF NOT cl_null(g_fab.fab20) THEN                                     
             #IF g_fab.fab20 <0 OR g_fab.fab20 >=100 THEN       #MOD-D30223 mark
             #   CALL cl_err(g_fab.fab20,'afa-995',0)           #MOD-D30223 mark
              IF g_fab.fab20 <0 OR g_fab.fab20 >100 THEN        #MOD-D30223 add
                 CALL cl_err(g_fab.fab20,'axm-986',0)           #MOD-D30223 add
                 NEXT FIELD fab20                                               
              END IF                                                            
           END IF                                                               
                                                                                
        AFTER FIELD fab21                                                       
           IF NOT cl_null(g_fab.fab21) THEN                                     
             #IF g_fab.fab21 < 0 OR g_fab.fab21 >=100 THEN      #MOD-D30223 mark
             #   CALL cl_err(g_fab.fab21,'afa-995',0)           #MOD-D30223 mark
              IF g_fab.fab21 < 0 OR g_fab.fab21 >100 THEN       #MOD-D30223 add
                 CALL cl_err(g_fab.fab21,'axm-986',0)           #MOD-D30223 add
                 NEXT FIELD fab21                                               
              END IF                                                            
           END IF                                                               
                                                                                
        AFTER FIELD fab23                                                       
           IF NOT cl_null(g_fab.fab23) THEN                                     
              IF g_fab.fab23 < 0 OR g_fab.fab23 >=100 THEN                      
                 CALL cl_err(g_fab.fab23,'afa-995',0)                           
                 NEXT FIELD fab23                                               
              END IF
           END IF                                                               
 
       #-----No:FUN-A B0088-----
        AFTER FIELD fab232
           IF NOT cl_null(g_fab.fab232) THEN
              IF g_fab.fab232 < 0 OR g_fab.fab232 >=100 THEN
                 CALL cl_err(g_fab.fab232,'afa-995',0)
                 NEXT FIELD fab232
              END IF
           END IF
        #-----No:FUN-AB0088 END-----

        AFTER FIELD fabud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fabud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT
           LET g_fab.fabuser = s_get_data_owner("fab_file") #FUN-C10039
           LET g_fab.fabgrup = s_get_data_group("fab_file") #FUN-C10039
            IF cl_null(g_fab.fab05) THEN LET g_fab.fab05 =0 END IF
            IF cl_null(g_fab.fab07) THEN LET g_fab.fab07 =0 END IF
            IF cl_null(g_fab.fab10) THEN LET g_fab.fab10 =0 END IF
            IF cl_null(g_fab.fab22) THEN LET g_fab.fab22 =0 END IF
            IF cl_null(g_fab.fab23) THEN LET g_fab.fab23 =0 END IF   #N0.A032
            IF cl_null(g_fab.fab052) THEN LET g_fab.fab052 =0 END IF  #FUN-AB0088
            IF cl_null(g_fab.fab102) THEN LET g_fab.fab102 =0 END IF  #FUN-AB0088
            IF cl_null(g_fab.fab232) THEN LET g_fab.fab232 =0 END IF  #FUN-AB0088
            DISPLAY BY NAME g_fab.fab05,g_fab.fab07,g_fab.fab10,g_fab.fab22,g_fab.fab23
            DISPLAY BY NAME g_fab.fab052,g_fab.fab102,g_fab.fab232   #FUN-AB0088
            IF INT_FLAG THEN EXIT INPUT END IF

        ON ACTION controlp
           CASE
              WHEN INFIELD(fab11)   #資產科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab11
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-740026
                 CALL cl_create_qry() RETURNING g_fab.fab11
                 DISPLAY BY NAME g_fab.fab11
                 #No.MOD-BB0142  --Begin
                 #CALL i010_fab11('a')
                 CALL i010_aag('a','1')
                 #No.MOD-BB0142  --End  
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fab11
                 END IF
                 NEXT FIELD fab11
              WHEN INFIELD(fab12)   #累折科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab12
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-740026
                 CALL cl_create_qry() RETURNING g_fab.fab12
                 DISPLAY BY NAME g_fab.fab12
                 #No.MOD-BB0142  --Begin
                 #CALL i010_fab12('a')
                 CALL i010_aag('a','2')
                 #No.MOD-BB0142  --End  
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fab12
                 END IF
                 NEXT FIELD fab12
              WHEN INFIELD(fab13)   #折舊科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab13
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-740026
                 CALL cl_create_qry() RETURNING g_fab.fab13
                 DISPLAY BY NAME g_fab.fab13
                 #No.MOD-BB0142  --Begin
                 #CALL i010_fab13('a')
                 CALL i010_aag('a','3')
                 #No.MOD-BB0142  --End  
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fab13
                 END IF
                 NEXT FIELD fab13
              WHEN INFIELD(fab24)   #減值準備科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab24
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-740026
                 CALL cl_create_qry() RETURNING g_fab.fab24
                 DISPLAY BY NAME g_fab.fab24
                 #No.MOD-BB0142  --Begin
                 #CALL i010_fab24('a')
                 CALL i010_aag('a','4')
                 #No.MOD-BB0142  --End  
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fab24
                 END IF
                 NEXT FIELD fab24
              WHEN INFIELD(fab111)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab111
                 #LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-740026 #FUN-BB0113 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-BB0113 add
                 CALL cl_create_qry() RETURNING g_fab.fab111
                 DISPLAY BY NAME g_fab.fab111
                 #No.MOD-BB0142  --Begin
                 #CALL i010_fab111('a')
                 CALL i010_aag('a','5')
                 #No.MOD-BB0142  --End  
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fab111
                 END IF
                 NEXT FIELD fab111
              WHEN INFIELD(fab121)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab121
                 #LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-740026 #FUN-BB0113 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-BB0113 add
                 CALL cl_create_qry() RETURNING g_fab.fab121
                 DISPLAY BY NAME g_fab.fab121
                 #No.MOD-BB0142  --Begin
                 #CALL i010_fab121('a')
                 CALL i010_aag('a','6')
                 #No.MOD-BB0142  --End  
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fab121
                 END IF
                 NEXT FIELD fab121
              WHEN INFIELD(fab131)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab131
                 #LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-740026 #FUN-BB0113 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-BB0113 add
                 CALL cl_create_qry() RETURNING g_fab.fab131
                 DISPLAY BY NAME g_fab.fab131
                 #No.MOD-BB0142  --Begin
                 #CALL i010_fab131('a')
                 CALL i010_aag('a','7')
                 #No.MOD-BB0142  --End  
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fab131
                 END IF
                 NEXT FIELD fab131
              WHEN INFIELD(fab241)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fab.fab241
                 #LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-740026 #FUN-BB0113 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-BB0113 add
                 CALL cl_create_qry() RETURNING g_fab.fab241
                 DISPLAY BY NAME g_fab.fab241
                 #No.MOD-BB0142  --Begin
                 #CALL i010_fab241('a')
                 CALL i010_aag('a','8')
                 #No.MOD-BB0142  --End  
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fab241
                 END IF
                 NEXT FIELD fab241
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION multi_dept
           CASE
              WHEN INFIELD(fab11) #資產科目
                  CALL cl_cmdrun('afai030' CLIPPED)
              WHEN INFIELD(fab111)                       #FUN-680028
                  CALL cl_cmdrun('afai030' CLIPPED)      #FUN-680028    
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

 
#No.MOD-BB0142  --Begin
FUNCTION i010_aag(p_cmd,p_type)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE p_type     LIKE type_file.chr1
   DEFINE l_aag00    LIKE aag_file.aag00
   DEFINE l_aag01    LIKE aag_file.aag01
   DEFINE l_aag07    LIKE aag_file.aag07
   DEFINE l_aag03    LIKE aag_file.aag03
   DEFINE l_aagacti  LIKE aag_file.aagacti
   DEFINE l_aag02    LIKE aag_file.aag02

   IF p_type MATCHES '[1234]' THEN
      LET l_aag00 = g_aza.aza81
   ELSE
      #LET l_aag00 = g_aza.aza82#FUN-BB0113 mark
      LET l_aag00 = g_faa.faa02c #FUN-BB0113 add
   END IF

   CASE p_type
        WHEN '1'    LET l_aag01 = g_fab.fab11
        WHEN '2'    LET l_aag01 = g_fab.fab12
        WHEN '3'    LET l_aag01 = g_fab.fab13
        WHEN '4'    LET l_aag01 = g_fab.fab24
        WHEN '5'    LET l_aag01 = g_fab.fab111
        WHEN '6'    LET l_aag01 = g_fab.fab121
        WHEN '7'    LET l_aag01 = g_fab.fab131
        WHEN '8'    LET l_aag01 = g_fab.fab241
   END CASE

   LET g_errno = " "
   SELECT aag02,aagacti,aag07,aag03 INTO l_aag02,l_aagacti,l_aag07,l_aag03 
     FROM aag_file         
    WHERE aag01=l_aag01 AND aag00=l_aag00
   CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                 LET l_aag02 = NULL
        WHEN l_aagacti='N'       LET g_errno = '9028'
        WHEN l_aag07 = '1'       LET g_errno = 'agl-015'
        WHEN l_aag03 <>'2'       LET g_errno = 'agl-201'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE p_type
           WHEN '1'   DISPLAY l_aag02 TO FORMONLY.aag02_1
           WHEN '2'   DISPLAY l_aag02 TO FORMONLY.aag02_2
           WHEN '3'   DISPLAY l_aag02 TO FORMONLY.aag02_3
           WHEN '4'   DISPLAY l_aag02 TO FORMONLY.aag02_4
           WHEN '5'   DISPLAY l_aag02 TO FORMONLY.aag02_11
           WHEN '6'   DISPLAY l_aag02 TO FORMONLY.aag02_21
           WHEN '7'   DISPLAY l_aag02 TO FORMONLY.aag02_31
           WHEN '8'   DISPLAY l_aag02 TO FORMONLY.aag02_41
      END CASE
   END IF

END FUNCTION

#FUNCTION i010_fab11(p_cmd)
#DEFINE
#      l_aagacti  LIKE aag_file.aagacti,
#      l_aag02    LIKE aag_file.aag02,
#      p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
#DEFINE l_aag07   LIKE aag_file.aag07         #No.MOD-BB0142
#DEFINE l_aag03   LIKE aag_file.aag03         #No.MOD-BB0142
# 
#    LET g_errno = " "
#    SELECT aag02,aagacti,aag07,aag03 INTO l_aag02,l_aagacti,l_aag07,l_aag03         #No.MOD-BB0142
#      FROM aag_file         
#     WHERE aag01=g_fab.fab11
#      AND  aag00=g_aza.aza81                       #No.FUN-740026
#    CASE
#         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
#                                  LET l_aag02 = NULL
#                                  LET l_aagacti = NULL
#         WHEN l_aagacti='N'       LET g_errno = '9028'
#         #No.MOD-BB0142  --Begin
#         WHEN l_aag07 = '1'       LET g_errno = 'agl-015'
#         WHEN l_aag03 <>'2'       LET g_errno = 'agl-201'
#         #No.MOD-BB0142  --End  
#         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
#    IF cl_null(g_errno) OR p_cmd = 'd' THEN
#       DISPLAY l_aag02 TO FORMONLY.aag02_1
#    END IF
#END FUNCTION
# 
# 
#FUNCTION i010_fab12(p_cmd)
#DEFINE
#      l_aagacti  LIKE aag_file.aagacti,
#      l_aag02    LIKE aag_file.aag02,
#      p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
# 
#    LET g_errno = " "
#    SELECT aag02,aagacti INTO l_aag02,l_aagacti
#      FROM aag_file
#     WHERE aag01=g_fab.fab12
#      AND  aag00 = g_aza.aza81             #No.FUN-740026
#    CASE
#         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
#                                  LET l_aag02 = NULL
#                                  LET l_aagacti = NULL
#         WHEN l_aagacti='N'       LET g_errno = '9028'
#         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
#    IF cl_null(g_errno) OR p_cmd = 'd' THEN
#       DISPLAY l_aag02 TO FORMONLY.aag02_2
#    END IF
#END FUNCTION
# 
#FUNCTION i010_fab13(p_cmd)
#  DEFINE
#        l_aagacti  LIKE aag_file.aagacti,
#        l_aag02    LIKE aag_file.aag02,
#        p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
# 
#      LET g_errno = " "
#      SELECT aag02,aagacti INTO l_aag02,l_aagacti
#        FROM aag_file
#       WHERE aag01=g_fab.fab13
#        AND  aag00 = g_aza.aza81             #No.FUN-740026
#      CASE
#           WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
#                                    LET l_aag02 = NULL
#                                    LET l_aagacti = NULL
#           WHEN l_aagacti='N'       LET g_errno = '9028'
#           OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
#      END CASE
#      IF cl_null(g_errno) OR p_cmd = 'd' THEN
#         DISPLAY l_aag02 TO FORMONLY.aag02_3
#      END IF
#END FUNCTION
# 
#FUNCTION i010_fab24(p_cmd)
#  DEFINE
#        l_aagacti  LIKE aag_file.aagacti,
#        l_aag02    LIKE aag_file.aag02,
#        p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
# 
#      LET g_errno = " "
#      SELECT aag02,aagacti INTO l_aag02,l_aagacti
#        FROM aag_file
#       WHERE aag01=g_fab.fab24
#        AND  aag00 = g_aza.aza81             #No.FUN-740026
#      CASE
#           WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
#                                    LET l_aag02 = NULL
#                                    LET l_aagacti = NULL
#           WHEN l_aagacti='N'       LET g_errno = '9028'
#           OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
#      END CASE
#      IF cl_null(g_errno) OR p_cmd = 'd' THEN
#         DISPLAY l_aag02 TO FORMONLY.aag02_4
#      END IF
#END FUNCTION
#FUNCTION i010_fab111(p_cmd)
#DEFINE 
#      l_aagacti     LIKE aag_file.aagacti,
#      l_aag02       LIKE aag_file.aag02,
#      p_cmd         LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
# 
#   LET g_errno = " "
#   SELECT aag02,aagacti INTO l_aag02,l_aagacti
#     FROM aag_file
#    WHERE aag01 = g_fab.fab111
#    #AND  aag00 = g_aza.aza82             #No:FUN-740026 #TQC-B60043 mark
#     AND  aag00 = g_faa.faa02c            #TQC-B60043
#   CASE
#       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
#                                LET l_aag02 = NULL
#                                LET l_aagacti = NULL
#       WHEN l_aagacti = 'N'     LET g_errno = '9028'
#       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'                         
#   END CASE
#   IF cl_null(g_errno) OR p_cmd = 'd' THEN
#      DISPLAY  l_aag02 TO FORMONLY.aag02_11	
#   END IF
#END FUNCTION
# 
#FUNCTION i010_fab121(p_cmd)
#DEFINE
#      l_aagacti     LIKE aag_file.aagacti,
#      l_aag02       LIKE aag_file.aag02,
#      p_cmd         LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
# 
#    LET g_errno = " "
#    SELECT aag02,aagacti INTO l_aag02,l_aagacti
#      FROM aag_file
#     WHERE aag01 = g_fab.fab121
#     #AND  aag00 = g_aza.aza82             #No:FUN-740026 #TQC-B60043 mark
#      AND  aag00 = g_faa.faa02c            #TQC-B60043
#    CASE
#       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
#                                LET l_aag02 = NULL
#                                LET l_aagacti = NULL
#       WHEN l_aagacti = 'N'     LET g_errno = '9028'
#       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
#    IF cl_null(g_errno) OR p_cmd = 'd' THEN
#       DISPLAY l_aag02 TO FORMONLY.aag02_21
#    END IF
#END FUNCTION
# 
#FUNCTION i010_fab131(p_cmd)
#DEFINE
#      l_aagacti     LIKE aag_file.aagacti,
#      l_aag02       LIKE aag_file.aag02,
#      p_cmd         LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
# 
#     LET g_errno = " "
#     SELECT aag02,aagacti INTO l_aag02,l_aagacti
#       FROM aag_file
#      WHERE aag01 = g_fab.fab131
#       #AND  aag00 = g_aza.aza82             #No:FUN-740026 #TQC-B60043 mark
#        AND  aag00 = g_faa.faa02c            #TQC-B60043
#     CASE
#        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
#                                 LET l_aag02 = NULL
#                                 LET l_aagacti = NULL
#        WHEN l_aagacti = 'N'     LET g_errno = '9028'
#        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
#     END CASE
#     IF cl_null(g_errno) OR p_cmd = 'd' THEN 
#        DISPLAY l_aag02 TO FORMONLY.aag02_31
#     END IF 
#END FUNCTION
# 
#FUNCTION i010_fab241(p_cmd)
#DEFINE
#      l_aagacti      LIKE aag_file.aagacti,
#      l_aag02        LIKE aag_file.aag02,
#      p_cmd          LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
# 
#     LET g_errno = " "
#     SELECT aag02,aagacti INTO l_aag02,l_aagacti
#       FROM aag_file
#      WHERE aag01 = g_fab.fab241
#       #AND  aag00 = g_aza.aza82             #No:FUN-740026 #TQC-B60043 mark
#        AND  aag00 = g_faa.faa02c            #TQC-B60043
#     CASE
#        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
#                                 LET l_aag02 = NULL
#                                 LET l_aagacti = NULL
#        WHEN l_aagacti = 'N'     LET g_errno = '9028'
#        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
#     END CASE
#     IF cl_null(g_errno) OR p_cmd = 'd' THEN
#        DISPLAY l_aag02 TO FORMONLY.aag02_41
#     END IF
#END FUNCTION
#No.MOD-BB0142  --End  
 
FUNCTION i010_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fab.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i010_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i010_count
    FETCH i010_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i010_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fab.fab01,SQLCA.sqlcode,0)
        INITIALIZE g_fab.* TO NULL
    ELSE
        CALL i010_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i010_fetch(p_flfab)
    DEFINE
        p_flfab          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_abso          LIKE type_file.num10        #No.FUN-680070 INTEGER
 
    CASE p_flfab
        WHEN 'N' FETCH NEXT     i010_cs INTO g_fab.fab01
        WHEN 'P' FETCH PREVIOUS i010_cs INTO g_fab.fab01
        WHEN 'F' FETCH FIRST    i010_cs INTO g_fab.fab01
        WHEN 'L' FETCH LAST     i010_cs INTO g_fab.fab01
        WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         FETCH ABSOLUTE g_jump i010_cs INTO g_fab.fab01
         LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fab.fab01,SQLCA.sqlcode,0)
        INITIALIZE g_fab.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flfab
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_fab.* FROM fab_file        # 重讀DB,因TEMP有不被更新特性
       WHERE fab01 = g_fab.fab01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","fab_file",g_fab.fab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        LET g_data_owner = g_fab.fabuser  #FUN-4C0059
        LET g_data_group = g_fab.fabgrup  #FUN-4C0059
        CALL i010_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i010_show()
    LET g_fab_t.* = g_fab.*
    LET g_fab_o.*=g_fab.*
    DISPLAY BY NAME g_fab.fab01,g_fab.fab02,g_fab.fab03,g_fab.fab04,g_fab.fab05, g_fab.faboriu,g_fab.faborig,
                    g_fab.fab06,g_fab.fab07,g_fab.fab08,g_fab.fab10,g_fab.fab11,
                    g_fab.fab042,g_fab.fab232,g_fab.fab052,g_fab.fab082,g_fab.fab102,   #FUN-AB0088
                    g_fab.fab111,g_fab.fab12,g_fab.fab121,g_fab.fab13,g_fab.fab131,     #FUN-680028
                    g_fab.fab14,g_fab.fab23,g_fab.fab15,
                    g_fab.fab16,g_fab.fab17,g_fab.fab18,g_fab.fab19,g_fab.fab20,
                    g_fab.fab21,g_fab.fab22,g_fab.fab24,g_fab.fab241,    #No:A099        #FUN-680028
                    g_fab.fabuser,g_fab.fabgrup,g_fab.fabmodu,g_fab.fabdate,
                    g_fab.fabacti
                   ,g_fab.fabud01,g_fab.fabud02,g_fab.fabud03,g_fab.fabud04,
                    g_fab.fabud05,g_fab.fabud06,g_fab.fabud07,g_fab.fabud08,
                    g_fab.fabud09,g_fab.fabud10,g_fab.fabud11,g_fab.fabud12,
                    g_fab.fabud13,g_fab.fabud14,g_fab.fabud15 
 
    #No.MOD-BB0142  --Begin
    #CALL i010_fab11('d')
    #CALL i010_fab12('d')
    #CALL i010_fab13('d')
    #CALL i010_fab24('d')       #No:A099
    #CALL i010_fab111('d')
    #CALL i010_fab121('d')
    #CALL i010_fab131('d')
    #CALL i010_fab241('d')
    CALL i010_aag('d','1')
    CALL i010_aag('d','2')
    CALL i010_aag('d','3')
    CALL i010_aag('d','4')
    CALL i010_aag('d','5')
    CALL i010_aag('d','6')
    CALL i010_aag('d','7')
    CALL i010_aag('d','8')
    #No.MOD-BB0142  --End  
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i010_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fab.fab01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_fab.* FROM fab_file WHERE fab01 = g_fab.fab01
    IF g_fab.fabacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fab.fab01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fab01_t = g_fab.fab01
    BEGIN WORK
 
    OPEN i010_cl USING g_fab.fab01
 
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_fab.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fab.fab01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_fab.fabmodu=g_user                     #修改者
    LET g_fab.fabdate = g_today                  #修改日期
    CALL i010_show()                             # 顯示最新資料
    WHILE TRUE
        CALL i010_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fab.*=g_fab_t.*
            CALL i010_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE fab_file SET fab_file.* = g_fab.*    # 更新DB
            WHERE fab01 = g_fab01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","fab_file",g_fab01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_x()
    DEFINE
        l_chr LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fab.fab01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i010_cl USING g_fab.fab01
 
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_fab.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fab.fab01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i010_show()
    IF cl_exp(15,21,g_fab.fabacti) THEN
        LET g_chr=g_fab.fabacti
        IF g_fab.fabacti='Y' THEN
            LET g_fab.fabacti='N'
        ELSE
            LET g_fab.fabacti='Y'
        END IF
        UPDATE fab_file
            SET fabacti=g_fab.fabacti,
                fabmodu=g_user, fabdate=g_today
            WHERE fab01=g_fab.fab01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","fab_file",g_fab.fab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            LET g_fab.fabacti=g_chr
        END IF
        DISPLAY BY NAME g_fab.fabacti
    END IF
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_r()
    DEFINE
        l_chr LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fab.fab01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fab.fabacti = 'N' THEN                                                                                                     
        CALL cl_err('','abm-950',0)                                                                                                 
        RETURN                                                                                                                      
    END IF                                                                                                                          
    BEGIN WORK
 
    OPEN i010_cl USING g_fab.fab01
 
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_fab.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fab.fab01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i010_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fab01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fab.fab01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM fab_file WHERE fab01 = g_fab.fab01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","fab_file",g_fab.fab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
       ELSE CLEAR FORM
         OPEN i010_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i010_cs
             CLOSE i010_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i010_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i010_cs
             CLOSE i010_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i010_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i010_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i010_fetch('/')
         END IF
       END IF
    END IF
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_copy()
   DEFINE l_fab           RECORD LIKE fab_file.*,
          l_oldno,l_newno LIKE fab_file.fab01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fab.fab01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i010_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM fab01
 
        AFTER FIELD fab01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM fab_file
                   WHERE fab01 = l_newno
               IF g_cnt > 0 THEN
                  LET g_msg = l_newno CLIPPED
                  CALL cl_err(g_msg,-239,0)
                  NEXT FIELD fab01
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
        DISPLAY BY NAME g_fab.fab01
        RETURN
    END IF
    LET l_fab.* = g_fab.*
    LET l_fab.fab01  =l_newno  #資料鍵值
    LET l_fab.fabuser=g_user    #資料所有者
    LET l_fab.fabgrup=g_grup    #資料所有者所屬群
    LET l_fab.fabmodu=NULL      #資料修改日期
    LET l_fab.fabdate=g_today   #資料建立日期
    LET l_fab.fabacti='Y'       #有效資料
    LET l_fab.fab11 = NULL
    LET l_fab.faboriu = g_user      #No.FUN-980030 10/01/04
    LET l_fab.faborig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO fab_file VALUES (l_fab.*)
        LET g_msg = l_newno CLIPPED
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("ins","fab_file",l_fab.fab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        MESSAGE 'ROW(',g_msg,') O.K'
        SLEEP 2
        LET l_oldno = g_fab.fab01
        LET g_fab.fab01 = l_newno
        SELECT fab_file.* INTO g_fab.* FROM fab_file
                       WHERE fab01 = l_newno
        CALL i010_u()
        #SELECT fab_file.* INTO g_fab.* FROM fab_file  #FUN-C30027
        #               WHERE fab01 = l_oldno          #FUN-C30027
    END IF
    CALL i010_show()
END FUNCTION
 
FUNCTION i010_out()
    DEFINE
        l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_name          LIKE type_file.chr20,        # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
        l_za05          LIKE za_file.za05,           #No.FUN-680070 VARCHAR(40)
        l_chr           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        sr       RECORD LIKE fab_file.*
 
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('afai010') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM fab_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
 

    # 是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'fab01') 
            RETURNING g_wc
       LET g_str = g_wc
    END IF
    CALL cl_prt_cs1('afai010','afai010',g_sql,g_wc)
 
END FUNCTION

FUNCTION i010_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fab01",TRUE)
   END IF
   IF INFIELD(fab08) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fab10",TRUE)
   END IF
   #-----No:FUN-AB0088-----
   IF INFIELD(fab082) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fab102",TRUE)
   END IF
   #-----No:FUN-AB0088 END-----

   IF INFIELD(fab03) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fab04,fab05,fab06,fab07,fab08,fab09,fab10",TRUE)
      CALL cl_set_comp_entry("fab042,fab052,fab082,fab102",TRUE)   #No:FUN-AB0088
   END IF
   IF INFIELD(fab04) OR (NOT g_before_input_done) THEN
      IF NOT (g_aza.aza26 != '2') THEN
         CALL cl_set_comp_entry("fab23",TRUE)
      END IF
#     CALL cl_set_comp_entry("fab12,fab13,fab121,fab131",TRUE)   #FUN-5A0204 #FUN-AB0088
      CALL cl_set_comp_entry("fab12,fab13",TRUE)
   END IF
   #-----No:FUN-AB0088-----
   IF INFIELD(fab042) OR (NOT g_before_input_done) THEN
      IF NOT (g_aza.aza26 != '2') THEN
         CALL cl_set_comp_entry("fab232",TRUE)
      END IF
      CALL cl_set_comp_entry("fab121,fab131",TRUE)
   END IF
   #-----No:FUN-AB0088 END-----
END FUNCTION
 
FUNCTION i010_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fab01",FALSE)
   END IF
   IF INFIELD(fab08) OR (NOT g_before_input_done) THEN
      IF g_fab.fab08 <> 'Y' THEN
         CALL cl_set_comp_entry("fab10",FALSE)
      END IF
   END IF
   #-----No:FUN-AB0088-----
   IF INFIELD(fab082) OR (NOT g_before_input_done) THEN
      IF g_fab.fab082 <> 'Y' THEN
         CALL cl_set_comp_entry("fab102",FALSE)
      END IF
   END IF
   #-----No:FUN-AB0088 END-----
   IF INFIELD(fab03) OR (NOT g_before_input_done) THEN
      IF g_fab.fab03 = '3' THEN
         CALL cl_set_comp_entry("fab04,fab05,fab06,fab07,fab08,fab09,fab10",FALSE)
         CALL cl_set_comp_entry("fab042,fab052,fab082,fab102",FALSE)   #FUN-AB0088
      END IF
#FUN-AB0088 --Begin
#      IF g_fab.fab04 = '0' THEN
#         CALL cl_set_comp_entry("fab12,fab13,fab121,fab131",FALSE)
#         LET g_fab.fab12 = ''
#         LET g_fab.fab13 = ''
#         LET g_fab.fab121= ''
#         LET g_fab.fab131 = ''
#         DISPLAY BY NAME g_fab.fab12,g_fab.fab13,g_fab.fab121,g_fab.fab131
#      END IF
       IF g_fab.fab04 = '0' THEN
         CALL cl_set_comp_entry("fab12,fab13",FALSE)
         LET g_fab.fab12 = ''
         LET g_fab.fab13 = ''
         DISPLAY BY NAME g_fab.fab12,g_fab.fab13
      END IF
      IF g_fab.fab042 = '0' THEN
         CALL cl_set_comp_entry("fab121,fab131",FALSE)
         LET g_fab.fab121= ''
         LET g_fab.fab131 = ''
         DISPLAY BY NAME g_fab.fab121,g_fab.fab131
      END IF
#FUN-AB0088 --End
   END IF
   IF INFIELD(fab04) OR (NOT g_before_input_done) THEN
      IF g_aza.aza26 != '2' THEN
         CALL cl_set_comp_entry("fab23",FALSE)
      END IF
      IF g_fab.fab04 = '0' THEN
#        CALL cl_set_comp_entry("fab12,fab13,fab121,fab131",FALSE) #FUN-AB0088
         CALL cl_set_comp_entry("fab12,fab13",FALSE) #FUN-AB0088
         LET g_fab.fab12 = ''
         LET g_fab.fab13 = ''
#FUN-AB0088 --Begin mark
#        LET g_fab.fab121= ''
#        LET g_fab.fab131 = ''
#FUN-AB0088 --End mark
#        DISPLAY BY NAME g_fab.fab12,g_fab.fab13,g_fab.fab121,g_fab.fab131
         DISPLAY BY NAME g_fab.fab12,g_fab.fab13   #FUN-AB0088
      END IF
   END IF
   #-----No:FUN-AB0088-----
   IF INFIELD(fab042) OR (NOT g_before_input_done) THEN
      IF g_aza.aza26 != '2' THEN
         CALL cl_set_comp_entry("fab232",FALSE)
      END IF
      IF g_fab.fab042 = '0' THEN
         CALL cl_set_comp_entry("fab121,fab131",FALSE)
         LET g_fab.fab121= ''
         LET g_fab.fab131 = ''
         DISPLAY BY NAME g_fab.fab121,g_fab.fab131
      END IF
   END IF
   #-----No:FUN-AB0088 END-----
END FUNCTION
 
FUNCTION i010_set_comb()
  DEFINE comb_value STRING
  DEFINE comb_item  STRING
 
    LET comb_value = '0,1,2,3,4,5'
    CALL cl_getmsg('afa-392',g_lang) RETURNING comb_item
 
    CALL cl_set_combo_items('fab04',comb_value,comb_item)
    CALL cl_set_combo_items('fab042',comb_value,comb_item)   #No:FUN-AB0088
    CALL cl_set_combo_items('fab06',comb_value,comb_item)
END FUNCTION
 
FUNCTION i010_set_comments()
  DEFINE comm_value STRING
 
    CALL cl_getmsg('afa-391',g_lang) RETURNING comm_value
    CALL cl_set_comments('fab04',comm_value)
    CALL cl_set_comments('fab042',comm_value)   #No:FUN-AB0088
    CALL cl_set_comments('fab06',comm_value)
END FUNCTION
#No.FUN-9C0077 程式精簡 

