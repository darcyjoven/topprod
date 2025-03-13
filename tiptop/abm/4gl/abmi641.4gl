# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmi641.4gl
# Descriptions...:FAS編碼原則資料維護作業
# Date & Author..: 99/11/19 By raymon
# Modify.........: No.MOD-470051 04/07/21 By Mandy 加入相關文件功能
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-6B0149 06/11/24 By Ray 第九段位數開始應改為不可以輸入負數和零，也不可以大于二十
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740145 07/04/22 By johnray 更改時會報資料重復
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760009 07/06/04 By Carol i641_i()中重取g_sba值的SQL-key有問題
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.TQC-890003 08/09/02 By claire 新增後條件值誤寫
# Modify.........: No.TQC-980035 09/08/05 By lilingyu 無效資料不可刪除
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.TQC-AB0351 10/11/30 By chenying 規格主件開窗資料與字段檢查不符，開窗應只開出規格組件
# Modify.........: No.TQC-AC0055 10/12/10 by destiny 料號檢查與開窗條件不一致
# Modify.........: No.TQC-AB0041 10/12/15 By lixh1   將cbacon查詢時的開窗修改為q_cba
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cba       RECORD LIKE cba_file.*,
    g_cba_t     RECORD LIKE cba_file.*,
    g_cba_o     RECORD LIKE cba_file.*,
#    g_cbacon_t  LIKE cba_file.cbacon,         #No.TQC-740145
    g_wc,g_sql,g_cmd   string                  #No.FUN-580092 HCN
DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  STRING
DEFINE g_chr         LIKE type_file.chr1     #No.FUN-680096  VARCHAR(1)
DEFINE g_cnt         LIKE type_file.num10    #No.FUN-680096  INTEGER
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096  SMALLINT
DEFINE g_msg         LIKE ze_file.ze03       #No.FUN-680096  VARCHAR(72)
DEFINE g_row_count   LIKE type_file.num10    #No.FUN-680096  INTEGER
DEFINE g_curs_index  LIKE type_file.num10    #No.FUN-680096  INTEGER
DEFINE g_jump        LIKE type_file.num10    #No.FUN-680096  INTEGER
DEFINE mi_no_ask     LIKE type_file.num5     #No.FUN-680096  SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8        #No.FUN-6A0060
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
    INITIALIZE g_cba.* TO NULL
    INITIALIZE g_cba_t.* TO NULL
    INITIALIZE g_cba_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM cba_file WHERE cbacon = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i641_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW i641_w AT p_row,p_col WITH FORM "abm/42f/abmi641"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i641_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i641_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION i641_cs()
    CLEAR FORM
   INITIALIZE g_cba.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        cbacon,cbades,cba01,cba02,cba03,cba04,cba05,cba06,
        cba07,cba08,cba09,cba10,cba11,cba12,cba13,cba14,cba15,cba16,
        cba17,cba18,cba19,cba20,
        cbauser,cbagrup,cbamodu,cbadate,cbaacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(cbacon)
#                CALL q_ima1(3,2,'C',g_cba.cbacon) RETURNING g_cba.cbacon
                 CALL cl_init_qry_var()
 #               LET g_qryparam.form = "q_ima1"
                #LET g_qryparam.form = "q_bma"    #TQC-AB0041
                 LET g_qryparam.form = "q_cba"    #TQC-AB0041
                 LET g_qryparam.state = "c"
                #LET g_qryparam.where = " ima08 MATCHES '[C]'"   #TQC-AB0351 add    #TQC-AB0041 mark
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cbacon
                 NEXT FIELD cbacon
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
    #        LET g_wc = g_wc clipped," AND cbauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cbagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cbagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cbauser', 'cbagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT cbacon FROM cba_file ", # 組合出 SQL 指令 #TQC-870018
        " WHERE ",g_wc CLIPPED, " ORDER BY cbacon"
    PREPARE i641_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i641_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i641_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cba_file WHERE ",g_wc CLIPPED
    PREPARE i641_precount FROM g_sql
    DECLARE i641_count CURSOR FOR i641_precount
END FUNCTION
 
FUNCTION i641_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i641_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i641_q()
            END IF
        ON ACTION next
            CALL i641_fetch('N')
        ON ACTION previous
            CALL i641_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i641_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                CALL i641_x()
                CALL cl_set_field_pic("","","","","",g_cba.cbaacti)
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i641_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i641_copy()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_cba.cbaacti)
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL i641_fetch('/')
        ON ACTION first
           CALL i641_fetch('F')
        ON ACTION last
           CALL i641_fetch('L')
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
          ON ACTION related_document               #MOD-470051
            LET g_action_choice = "related_document"
            IF cl_chk_act_auth() THEN
               IF g_cba.cbacon IS NOT NULL THEN
                  LET g_doc.column1 = "cbacon"
                  LET g_doc.value1  = g_cba.cbacon
                  CALL cl_doc()
               END IF
            END IF
    END MENU
    CLOSE i641_cs
END FUNCTION
 
 
FUNCTION i641_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cba.* LIKE cba_file.*
#    LET g_cbacon_t = NULL        #No.TQC-740145
    INITIALIZE g_cba_t.* LIKE cba_file.*         #No.TQC-740145
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cba.cbaacti ='Y'                   #有效的資料
        LET g_cba.cbauser = g_user
        LET g_cba.cbaoriu = g_user #FUN-980030
        LET g_cba.cbaorig = g_grup #FUN-980030
        LET g_cba.cbagrup = g_grup               #使用者所屬群
        LET g_cba.cbadate = g_today
        CALL i641_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cba.cba01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO cba_file VALUES(g_cba.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
 #           CALL cl_err(g_cba.cba01,SQLCA.sqlcode,0) #No.TQC-660046
            CALL cl_err3("ins","cba_file",g_cba.cbacon,"",SQLCA.sqlcode,"","",1) #TQC-660046
            CONTINUE WHILE
        ELSE
            LET g_cba_t.* = g_cba.*                # 保存上筆資料
            SELECT cbacon INTO g_cba.cbacon FROM cba_file
               #WHERE cba01 = g_cba.cba01          #TQC-890003 mark
                WHERE cbacon = g_cba.cbacon        #TQC-890003
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i641_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,     #No.FUN-680096  VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入   #No.FUN-680096 VARCHAR(1)
        l_num           LIKE type_file.num5,     #No.FUN-680096  SMALLINT
        l_n             LIKE type_file.num5      #No.FUN-680096  SMALLINT
 
    DISPLAY BY NAME g_cba.cbauser,g_cba.cbagrup,
        g_cba.cbadate, g_cba.cbaacti
    INPUT BY NAME g_cba.cbaoriu,g_cba.cbaorig,
        g_cba.cbacon,g_cba.cbades,
        g_cba.cba01, g_cba.cba02, g_cba.cba03,g_cba.cba04,
        g_cba.cba05, g_cba.cba06, g_cba.cba07,g_cba.cba08,
        g_cba.cba09, g_cba.cba10, g_cba.cba11,g_cba.cba12,
        g_cba.cba13, g_cba.cba14, g_cba.cba15, g_cba.cba16,
        g_cba.cba17, g_cba.cba18, g_cba.cba19, g_cba.cba20
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i641_set_entry(p_cmd)
            CALL i641_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD cbacon
            IF g_cba.cbacon IS NOT NULL THEN
               #FUN-AA0059 ----------------------------add start-----------------------------------
               IF NOT s_chk_item_no(g_cba.cbacon,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_cba.cbacon = g_cba_t.cbacon
                  DISPLAY BY NAME g_cba.cbacon
                  NEXT FIELD cbacon
               END IF 
               #FUN-AA0059 ----------------------------add end------------------------------------    
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
#                 (p_cmd = "u" AND g_cba.cbacon != g_cbacon_t) THEN           #No.TQC-740145
                 (p_cmd = "u" AND g_cba.cbacon != g_cba_t.cbacon) THEN           #No.TQC-740145
                   SELECT count(*) INTO l_n FROM cba_file
                       WHERE cbacon = g_cba.cbacon
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_cba.cbacon,-239,0)
#                       LET g_cba.cbacon = g_cbacon_t                      #No.TQC-740145
                       LET g_cba.cbacon = g_cba_t.cbacon                      #No.TQC-740145
                       DISPLAY BY NAME g_cba.cbacon
                       NEXT FIELD cbacon
                   END IF
                  IF i641_cbacon() THEN NEXT FIELD cbacon END IF
               END IF
            END IF
 
        AFTER FIELD cba01  #第一段位數
            IF g_cba.cba01 IS NOT NULL THEN
#No.TQC-6B0149 --begin
               CALL i641_chk_cba(g_cba.cba01)
               IF g_success = 'N' THEN
                  LET g_cba.cba01 = g_cba_o.cba01
                  DISPLAY BY NAME g_cba.cba01
                  NEXT FIELD cba01
               END IF
#No.TQC-6B0149 --end
            END IF
            LET g_cba_o.cba01=g_cba.cba01
 
        AFTER FIELD cba02  #第二段位數
            IF g_cba.cba02 IS NOT NULL THEN
#No.TQC-6B0149 --begin
               CALL i641_chk_cba(g_cba.cba02)
               IF g_success = 'N' THEN
                  LET g_cba.cba02 = g_cba_o.cba02
                  DISPLAY BY NAME g_cba.cba02
                  NEXT FIELD cba02
               END IF
#No.TQC-6B0149 --end
            END IF
            LET g_cba_o.cba02=g_cba.cba02
 
        AFTER FIELD cba03  #第二段位數
            IF g_cba.cba03 IS NOT NULL THEN
#No.TQC-6B0149 --begin
               CALL i641_chk_cba(g_cba.cba03)
               IF g_success = 'N' THEN
                  LET g_cba.cba03 = g_cba_o.cba03
                  DISPLAY BY NAME g_cba.cba03
                  NEXT FIELD cba03
               END IF
#No.TQC-6B0149 --end
            END IF
            LET g_cba_o.cba03=g_cba.cba03
 
        AFTER FIELD cba04  #第二段位數
            IF g_cba.cba04 IS NOT NULL THEN
#No.TQC-6B0149 --begin
               CALL i641_chk_cba(g_cba.cba04)
               IF g_success = 'N' THEN
                  LET g_cba.cba04 = g_cba_o.cba04
                  DISPLAY BY NAME g_cba.cba04
                  NEXT FIELD cba04
               END IF
#No.TQC-6B0149 --end
            END IF
            LET g_cba_o.cba04=g_cba.cba04
 
        AFTER FIELD cba05  #第二段位數
            IF g_cba.cba05 IS NOT NULL THEN
#No.TQC-6B0149 --begin
               CALL i641_chk_cba(g_cba.cba05)
               IF g_success = 'N' THEN
                  LET g_cba.cba05 = g_cba_o.cba05
                  DISPLAY BY NAME g_cba.cba05
                  NEXT FIELD cba05
               END IF
#No.TQC-6B0149 --end
            END IF
            LET g_cba_o.cba05=g_cba.cba05
 
        AFTER FIELD cba06  #第二段位數
            IF g_cba.cba06 IS NOT NULL THEN
#No.TQC-6B0149 --begin
               CALL i641_chk_cba(g_cba.cba06)
               IF g_success = 'N' THEN
                  LET g_cba.cba06 = g_cba_o.cba06
                  DISPLAY BY NAME g_cba.cba06
                  NEXT FIELD cba06
               END IF
#No.TQC-6B0149 --end
            END IF
            LET g_cba_o.cba06=g_cba.cba06
 
        AFTER FIELD cba07  #第二段位數
            IF g_cba.cba07 IS NOT NULL THEN
#No.TQC-6B0149 --begin
               CALL i641_chk_cba(g_cba.cba07)
               IF g_success = 'N' THEN
                  LET g_cba.cba07 = g_cba_o.cba07
                  DISPLAY BY NAME g_cba.cba07
                  NEXT FIELD cba07
               END IF
#No.TQC-6B0149 --end
            END IF
            LET g_cba_o.cba07=g_cba.cba07
 
        AFTER FIELD cba08  #第二段位數
            IF g_cba.cba08 IS NOT NULL THEN
#No.TQC-6B0149 --begin
               CALL i641_chk_cba(g_cba.cba08)
               IF g_success = 'N' THEN
                  LET g_cba.cba08 = g_cba_o.cba08
                  DISPLAY BY NAME g_cba.cba08
                  NEXT FIELD cba08
               END IF
#No.TQC-6B0149 --end
            END IF
            LET g_cba_o.cba08=g_cba.cba08
 
        #No.TQC-6B0149 --begin
        AFTER FIELD cba09  #第二段位數
            IF g_cba.cba09 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba09)
               IF g_success = 'N' THEN
                  LET g_cba.cba09 = g_cba_o.cba09
                  DISPLAY BY NAME g_cba.cba09
                  NEXT FIELD cba09
               END IF
            END IF
            LET g_cba_o.cba09=g_cba.cba09
 
        AFTER FIELD cba10  #第二段位數
            IF g_cba.cba10 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba10)
               IF g_success = 'N' THEN
                  LET g_cba.cba10 = g_cba_o.cba10
                  DISPLAY BY NAME g_cba.cba10
                  NEXT FIELD cba10
               END IF
            END IF
            LET g_cba_o.cba10=g_cba.cba10
 
        AFTER FIELD cba11  #第二段位數
            IF g_cba.cba11 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba11)
               IF g_success = 'N' THEN
                  LET g_cba.cba11 = g_cba_o.cba11
                  DISPLAY BY NAME g_cba.cba11
                  NEXT FIELD cba11
               END IF
            END IF
            LET g_cba_o.cba11=g_cba.cba11
 
        AFTER FIELD cba12  #第二段位數
            IF g_cba.cba12 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba12)
               IF g_success = 'N' THEN
                  LET g_cba.cba12 = g_cba_o.cba12
                  DISPLAY BY NAME g_cba.cba12
                  NEXT FIELD cba12
               END IF
            END IF
            LET g_cba_o.cba12=g_cba.cba12
 
        AFTER FIELD cba13  #第二段位數
            IF g_cba.cba13 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba13)
               IF g_success = 'N' THEN
                  LET g_cba.cba13 = g_cba_o.cba13
                  DISPLAY BY NAME g_cba.cba13
                  NEXT FIELD cba13
               END IF
            END IF
            LET g_cba_o.cba13=g_cba.cba13
 
        AFTER FIELD cba14  #第二段位數
            IF g_cba.cba14 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba14)
               IF g_success = 'N' THEN
                  LET g_cba.cba14 = g_cba_o.cba14
                  DISPLAY BY NAME g_cba.cba14
                  NEXT FIELD cba14
               END IF
            END IF
            LET g_cba_o.cba14=g_cba.cba14
 
        AFTER FIELD cba15  #第二段位數
            IF g_cba.cba15 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba15)
               IF g_success = 'N' THEN
                  LET g_cba.cba15 = g_cba_o.cba15
                  DISPLAY BY NAME g_cba.cba15
                  NEXT FIELD cba15
               END IF
            END IF
            LET g_cba_o.cba15=g_cba.cba15
 
        AFTER FIELD cba16  #第二段位數
            IF g_cba.cba16 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba16)
               IF g_success = 'N' THEN
                  LET g_cba.cba16 = g_cba_o.cba16
                  DISPLAY BY NAME g_cba.cba16
                  NEXT FIELD cba16
               END IF
            END IF
            LET g_cba_o.cba16=g_cba.cba16
 
        AFTER FIELD cba17  #第二段位數
            IF g_cba.cba17 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba17)
               IF g_success = 'N' THEN
                  LET g_cba.cba17 = g_cba_o.cba17
                  DISPLAY BY NAME g_cba.cba17
                  NEXT FIELD cba17
               END IF
            END IF
            LET g_cba_o.cba17=g_cba.cba17
 
        AFTER FIELD cba18  #第二段位數
            IF g_cba.cba18 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba18)
               IF g_success = 'N' THEN
                  LET g_cba.cba18 = g_cba_o.cba18
                  DISPLAY BY NAME g_cba.cba18
                  NEXT FIELD cba18
               END IF
            END IF
            LET g_cba_o.cba18=g_cba.cba18
 
        AFTER FIELD cba19  #第二段位數
            IF g_cba.cba19 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba19)
               IF g_success = 'N' THEN
                  LET g_cba.cba19 = g_cba_o.cba19
                  DISPLAY BY NAME g_cba.cba19
                  NEXT FIELD cba19
               END IF
            END IF
            LET g_cba_o.cba19=g_cba.cba19
 
        AFTER FIELD cba20  #第二段位數
            IF g_cba.cba20 IS NOT NULL THEN
               CALL i641_chk_cba(g_cba.cba20)
               IF g_success = 'N' THEN
                  LET g_cba.cba20 = g_cba_o.cba20
                  DISPLAY BY NAME g_cba.cba20
                  NEXT FIELD cba20
               END IF
            END IF
            LET g_cba_o.cba20=g_cba.cba20
        #No.TQC-6B0149 --end
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_cba.cbauser = s_get_data_owner("cba_file") #FUN-C10039
           LET g_cba.cbagrup = s_get_data_group("cba_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF  g_cba.cba01 IS NULL AND g_cba.cba02 IS NULL AND
                g_cba.cba03 IS NULL AND g_cba.cba04 IS NULL AND
                g_cba.cba05 IS NULL AND g_cba.cba06 IS NULL AND
                g_cba.cba07 IS NULL AND g_cba.cba08 IS NULL AND
                g_cba.cba09 IS NULL AND g_cba.cba10 IS NULL AND
                g_cba.cba11 IS NULL AND g_cba.cba12 IS NULL AND
                g_cba.cba13 IS NULL AND g_cba.cba14 IS NULL AND
                g_cba.cba15 IS NULL AND g_cba.cba16 IS NULL AND
                g_cba.cba17 IS NULL AND g_cba.cba18 IS NULL AND
                g_cba.cba19 IS NULL AND g_cba.cba20 IS NULL
            THEN LET l_flag='Y'
                 DISPLAY BY NAME g_cba.cba01
            END IF
            LET l_num=0
            IF g_cba.cba01 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba01 END IF
            IF g_cba.cba02 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba02 END IF
            IF g_cba.cba03 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba03 END IF
            IF g_cba.cba04 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba04 END IF
            IF g_cba.cba05 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba05 END IF
            IF g_cba.cba06 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba06 END IF
            IF g_cba.cba07 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba07 END IF
            IF g_cba.cba08 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba08 END IF
            IF g_cba.cba09 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba09 END IF
            IF g_cba.cba10 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba10 END IF
            IF g_cba.cba11 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba11 END IF
            IF g_cba.cba12 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba12 END IF
            IF g_cba.cba13 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba13 END IF
            IF g_cba.cba14 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba14 END IF
            IF g_cba.cba15 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba15 END IF
            IF g_cba.cba16 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba16 END IF
            IF g_cba.cba17 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba17 END IF
            IF g_cba.cba18 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba18 END IF
            IF g_cba.cba19 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba19 END IF
            IF g_cba.cba20 IS NOT NULL THEN
               LET l_num=l_num+g_cba.cba20 END IF
#No.TQC-6B0149 --begin
            IF g_sma.sma119 = '0' THEN
               IF l_num > 20 THEN    #各段輸入之和不可大於20 
                  CALL cl_err(l_num,'mfg6033',0) 
                  NEXT FIELD cba01
               END IF
            END IF
            IF g_sma.sma119 = '1' THEN
               IF l_num > 30 THEN    #各段輸入之和不可大於30 
                  CALL cl_err(l_num,'mfg6038',0) 
                  NEXT FIELD cba01
               END IF
            END IF
            IF g_sma.sma119 = '2' THEN
               IF l_num > 40 THEN    #各段輸入之和不可大於40 
                  CALL cl_err(l_num,'mfg6036',0) 
                  NEXT FIELD cba01
               END IF
            END IF
#No.TQC-6B0149 --end
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD cba01
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(cbacon)
#                CALL q_ima1(3,2,'C',g_cba.cbacon) RETURNING g_cba.cbacon
#                CALL FGL_DIALOG_SETBUFFER( g_cba.cbacon )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bma"
#                LET g_qryparam.form = "q_ima1"
                 LET g_qryparam.default1 = g_cba.cbacon
#                LET g_qryparam.where = " ima08 MATCHES '[C]'"
                 LET g_qryparam.where = " ima08 MATCHES '[C]'"   #TQC-AB0351 add
                 CALL cl_create_qry() RETURNING g_cba.cbacon
#                CALL FGL_DIALOG_SETBUFFER( g_cba.cbacon )
                 DISPLAY BY NAME g_cba.cbacon
                 NEXT FIELD cbacon
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION mntn_fas_code
            CASE
               WHEN INFIELD(cba01)
                  LET g_cmd = 'abmi640 ',"'",g_cba.cbacon clipped,"'",' 1 ',
                                         "'",g_cba.cba01 clipped,"'"
                  CALL cl_cmdrun(g_cmd)
               WHEN INFIELD(cba02)
                  LET g_cmd = 'abmi640 ',"'",g_cba.cbacon clipped,"'",' 2 ',
                                         "'",g_cba.cba01 clipped,"'"
                  CALL cl_cmdrun(g_cmd)
               WHEN INFIELD(cba03)
                  LET g_cmd = 'abmi640 ',"'",g_cba.cbacon clipped,"'",' 3 ',
                                         "'",g_cba.cba01 clipped,"'"
                  CALL cl_cmdrun(g_cmd)
               WHEN INFIELD(cba04)
                  LET g_cmd = 'abmi640 ',"'",g_cba.cbacon clipped,"'",' 4 ',
                                         "'",g_cba.cba01 clipped,"'"
                  CALL cl_cmdrun(g_cmd)
               WHEN INFIELD(cba05)
                  LET g_cmd = 'abmi640 ',"'",g_cba.cbacon clipped,"'",' 5 ',
                                         "'",g_cba.cba01 clipped,"'"
                  CALL cl_cmdrun(g_cmd)
               WHEN INFIELD(cba06)
                  LET g_cmd = 'abmi640 ',"'",g_cba.cbacon clipped,"'",' 6 ',
                                         "'",g_cba.cba01 clipped,"'"
                  CALL cl_cmdrun(g_cmd)
               WHEN INFIELD(cba07)
                  LET g_cmd = 'abmi640 ',"'",g_cba.cbacon clipped,"'",' 7 ',
                                         "'",g_cba.cba01 clipped,"'"
                  CALL cl_cmdrun(g_cmd)
               WHEN INFIELD(cba08)
                  LET g_cmd = 'abmi640 ',"'",g_cba.cbacon clipped,"'",' 8 ',
                                         "'",g_cba.cba01 clipped,"'"
                  CALL cl_cmdrun(g_cmd)
               WHEN INFIELD(cba09)
                  LET g_cmd = 'abmi640 ',"'",g_cba.cbacon clipped,"'",' 9 ',
                                         "'",g_cba.cba01 clipped,"'"
                  CALL cl_cmdrun(g_cmd)
               WHEN INFIELD(cba10)
                  LET g_cmd = 'abmi640 ',"'",g_cba.cbacon clipped,"'",' 10 ',
                                         "'",g_cba.cba01 clipped,"'"
                  CALL cl_cmdrun(g_cmd)
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
 
FUNCTION i641_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cba.* TO NULL              #No.FUN-6A0002
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i641_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i641_count
    FETCH i641_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i641_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cba.cba01,SQLCA.sqlcode,0)
        INITIALIZE g_cba.* TO NULL
    ELSE
        CALL i641_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i641_fetch(p_flcba)
    DEFINE
        p_flcba    LIKE type_file.chr1    #No.FUN-680096  VARCHAR(1)
 
    CASE p_flcba
        WHEN 'N' FETCH NEXT     i641_cs INTO g_cba.cbacon #TQC-870018
        WHEN 'P' FETCH PREVIOUS i641_cs INTO g_cba.cbacon #TQC-870018
        WHEN 'F' FETCH FIRST    i641_cs INTO g_cba.cbacon #TQC-870018
        WHEN 'L' FETCH LAST     i641_cs INTO g_cba.cbacon #TQC-870018
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i641_cs INTO g_cba.cbacon #TQC-870018
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cba.cbacon,SQLCA.sqlcode,0)
        INITIALIZE g_cba.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcba
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_cba.* FROM cba_file   # 重讀DB,因TEMP有不被更新特性
       WHERE cbacon = g_cba.cbacon
    IF SQLCA.sqlcode THEN
   #     CALL cl_err(g_cba.cbacon,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","cba_file",g_cba.cbacon,"",SQLCA.sqlcode,"","",1) #TQC-660046
    ELSE
        LET g_data_owner = g_cba.cbauser #FUN-4C0054
        LET g_data_group = g_cba.cbagrup #FUN-4C0054
        CALL i641_show()                 # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i641_show()
    LET g_cba_t.* = g_cba.*
    DISPLAY BY NAME g_cba.cbaoriu,g_cba.cbaorig,
    g_cba.cbacon,g_cba.cbades,g_cba.cba01,g_cba.cba02,g_cba.cba03,
    g_cba.cba04, g_cba.cba05, g_cba.cba06,g_cba.cba07,g_cba.cba08,
    g_cba.cba09, g_cba.cba10, g_cba.cba11,g_cba.cba12,g_cba.cba13,
    g_cba.cba14, g_cba.cba15, g_cba.cba16,g_cba.cba17,g_cba.cba18,
    g_cba.cba19, g_cba.cba20,
    g_cba.cbauser,g_cba.cbagrup,g_cba.cbamodu,g_cba.cbadate,g_cba.cbaacti
    CALL i641_cbacon() RETURNING g_i
    CALL cl_set_field_pic("","","","","",g_cba.cbaacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i641_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cba.cba01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
#   SELECT * INTO g_cba.* FROM cba_file WHERE cba01=g_cba.cba01     #TQC-760009 mark
    SELECT * INTO g_cba.* FROM cba_file WHERE cbacon=g_cba.cbacon   #TQC-760009 modify
    IF g_cba.cbaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_cba.cba01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
#    LET g_cbacon_t = g_cba.cbacon
    LET g_cba_t.cbacon = g_cba.cbacon
    LET g_cba_o.*=g_cba.*
    BEGIN WORK
 
    OPEN i641_cl USING g_cba.cbacon
 
    IF STATUS THEN
       CALL cl_err("OPEN i641_cl:", STATUS, 1)
       CLOSE i641_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i641_cl INTO g_cba.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cba.cba01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_cba.cbamodu=g_user                     #修改者
    LET g_cba.cbadate = g_today                  #修改日期
    CALL i641_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i641_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cba.*=g_cba_t.*
            CALL i641_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
UPDATE cba_file SET cba_file.* = g_cba.*    # 更新DB
WHERE cbacon=g_cba_t.cbacon        # 更新DB
        IF SQLCA.sqlcode THEN
 #           CALL cl_err(g_cba.cba01,SQLCA.sqlcode,0) #No.TQC-660046
#            CALL cl_err3("upd","cba_file",g_cbacon_t,"",SQLCA.sqlcode,"","",1) #TQC-660046   #No.TQC-740145
            CALL cl_err3("upd","cba_file",g_cba_t.cbacon,"",SQLCA.sqlcode,"","",1) #TQC-660046   #No.TQC-740145
            CONTINUE WHILE
        END IF
            LET g_cba_t.* = g_cba.*                # 保存上筆資料   #No.TQC-740145
        EXIT WHILE
    END WHILE
    CLOSE i641_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i641_x()
    DEFINE
        l_chr LIKE type_file.chr1      #No.FUN-680096  CAHR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cba.cba01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i641_cl USING g_cba.cbacon
 
    IF STATUS THEN
       CALL cl_err("OPEN i641_cl:", STATUS, 1)
       CLOSE i641_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i641_cl INTO g_cba.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cba.cbacon,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i641_show()
    IF cl_exp(0,0,g_cba.cbaacti) THEN
        LET g_chr=g_cba.cbaacti
        IF g_cba.cbaacti='Y' THEN
            LET g_cba.cbaacti='N'
        ELSE
            LET g_cba.cbaacti='Y'
        END IF
        UPDATE cba_file
            SET cbaacti=g_cba.cbaacti,
               cbamodu=g_user, cbadate=g_today
            WHERE cbacon=g_cba.cbacon
        IF SQLCA.SQLERRD[3]=0 THEN
 #           CALL cl_err(g_cba.cbacon,SQLCA.sqlcode,0) #No.TQC-660046
            CALL cl_err3("upd","cba_file",g_cba.cbacon,"",SQLCA.sqlcode,"","",1) #TQC-660046
            LET g_cba.cbaacti=g_chr
        END IF
        DISPLAY BY NAME g_cba.cbaacti
    END IF
    CLOSE i641_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i641_r()
    DEFINE l_chr LIKE type_file.chr1     #No.FUN-680096  VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cba.cbacon IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
#TQC-980035 --BEGIN--
    IF g_cba.cbaacti = 'N' THEN
      CALL cl_err('','abm-033',0)
      RETURN
    END IF 
#TQC-980035 --END--    
    BEGIN WORK
 
    OPEN i641_cl USING g_cba.cbacon
 
    IF STATUS THEN
       CALL cl_err("OPEN i641_cl:", STATUS, 1)
       CLOSE i641_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i641_cl INTO g_cba.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cba.cbacon,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i641_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL            #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cbacon"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_cba.cbacon      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
        DELETE FROM cba_file WHERE cbacon = g_cba.cbacon
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_cba.cbacon,SQLCA.sqlcode,0) #No.TQC-660046
           CALL cl_err3("del","cba_file",g_cba.cbacon,"",SQLCA.sqlcode,"","",1) #TQC-660046
        ELSE
           CLEAR FORM
           INITIALIZE g_cba.* TO NULL
           OPEN i641_count
           #FUN-B50062-add-start--
           IF STATUS THEN
              CLOSE i641_cs
              CLOSE i641_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--
           FETCH i641_count INTO g_row_count
           #FUN-B50062-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i641_cs
              CLOSE i641_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i641_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i641_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i641_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i641_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i641_copy()
   DEFINE l_cba           RECORD LIKE cba_file.*,
          l_ima02         LIKE ima_file.ima02,
          l_ima021        LIKE ima_file.ima021,
          l_oldno,l_newno LIKE cba_file.cbacon
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cba.cbacon IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i641_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM cbacon
        AFTER FIELD cbacon
            IF l_newno IS NOT NULL THEN
               #FUN-AA0059 ----------------------------add start---------------------
               IF NOT s_chk_item_no(l_newno,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD cbacon
               END IF 
               #FUN-AA0059 ---------------------------add end------------------------ 
               SELECT count(*) INTO g_cnt FROM cba_file
                WHERE cbacon = l_newno
               IF g_cnt > 0 THEN
                  CALL cl_err(l_newno,-239,0)
                  NEXT FIELD cbacon
               END IF
               SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
                WHERE ima01=l_newno AND ima08='C'
               IF SQLCA.sqlcode THEN
  #                CALL cl_err(l_newno,'abm-734',0) #No.TQC-660046
                  CALL cl_err3("sel","ima_file",l_newno,"","abm-734","","",1) #TQC-660046
                  NEXT FIELD cbacon
               ELSE
                  DISPLAY l_ima02 TO FORMONLY.ima02
                  DISPLAY l_ima021 TO FORMONLY.ima021
               END IF
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(cbacon)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bma"
                 LET g_qryparam.default1 = l_newno
                 LET g_qryparam.where = " ima08 MATCHES '[C]'"   #TQC-AB0351 add
                 CALL cl_create_qry() RETURNING l_newno
#                 CALL FGL_DIALOG_SETBUFFER(l_newno)
                 DISPLAY l_newno TO cbacon
                 NEXT FIELD cbacon
              OTHERWISE EXIT CASE
           END CASE
 
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
        DISPLAY BY NAME g_cba.cbacon
        RETURN
    END IF
    LET l_cba.* = g_cba.*
    LET l_cba.cbacon =l_newno   #資料鍵值
    LET l_cba.cbauser=g_user    #資料所有者
    LET l_cba.cbagrup=g_grup    #資料所有者所屬群
    LET l_cba.cbamodu=NULL      #資料修改日期
    LET l_cba.cbadate=g_today   #資料建立日期
    LET l_cba.cbaacti='Y'       #有效資料
    LET l_cba.cbaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_cba.cbaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO cba_file VALUES (l_cba.*)
    IF SQLCA.sqlcode THEN
 #       CALL cl_err(l_newno,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("ins","cba_file",g_cba.cbacon,"",SQLCA.sqlcode,"","",1) #TQC-660046
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_cba.cbacon
        SELECT cba_file.* INTO g_cba.* FROM cba_file
                       WHERE cbacon = l_newno
        CALL i641_u()
        #SELECT cba_file.* INTO g_cba.* FROM cba_file #FUN-C30027
        #               WHERE cbacon = l_oldno        #FUN-C30027
    END IF
    CALL i641_show()
END FUNCTION
 
FUNCTION i641_cbacon()
DEFINE l_ima02  LIKE ima_file.ima02
DEFINE l_ima021 LIKE ima_file.ima021
DEFINE l_n      LIKE type_file.num5 #TQC-AC0055
 
  SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
   WHERE ima01=g_cba.cbacon
     AND ima08='C'
  IF STATUS
     THEN
 #    CALL cl_err(g_cba.cbacon,'abm-734',0) #No.TQC-660046
     CALL cl_err3("sel","ima_file",g_cba.cbacon,"","abm-734","","",1) #TQC-660046
     RETURN -1
  ELSE
  	 #TQC-AC0055--begin
     SELECT COUNT(*) INTO l_n FROM bma_file WHERE bma01=g_cba.cbacon  
     IF l_n=0 THEN 
        CALL cl_err('','abm-702',1)
        RETURN -1
     ELSE 	
     #TQC-AC0055--end  	
        DISPLAY l_ima02 TO FORMONLY.ima02
        DISPLAY l_ima021 TO FORMONLY.ima021
     END IF 
  END IF
  RETURN 0
END FUNCTION
 
#No.TQC-6B0149 --begin
FUNCTION i641_chk_cba(p_num)
  DEFINE p_num   LIKE cba_file.cba01
 
  LET g_success = 'Y'
  IF g_sma.sma119 = '0' THEN
     IF p_num <= 0 OR p_num > 20 THEN
        CALL cl_err(p_num,'mfg6032',0)
        LET g_success = 'N'
     END IF
  END IF
  IF g_sma.sma119 = '1' THEN
     IF p_num <= 0 OR p_num > 30 THEN
        CALL cl_err(p_num,'mfg6037',0)
        LET g_success = 'N'
     END IF
  END IF
  IF g_sma.sma119 = '2' THEN
     IF p_num <= 0 OR p_num > 40 THEN
        CALL cl_err(p_num,'mfg6035',0)
        LET g_success = 'N'
     END IF
  END IF
 
END FUNCTION
#No.TQC-6B0149 --end
FUNCTION i641_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("cbacon",TRUE)
   END IF
END FUNCTION
 
FUNCTION i641_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("cbacon",FALSE)
   END IF
END FUNCTION
 
 
#Patch....NO.TQC-610035 <> #

