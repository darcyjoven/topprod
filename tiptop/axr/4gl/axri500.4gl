# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axri500.4gl
# Descriptions...: 應收帳款統計開帳作業
# Date & Author..: 99/09/17 By Kammy
# Modify.........: No.+212 010618 add ooo12 資料來源
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳套權限修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0042 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740009 07/04/03 By Elva   會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B10053 11/01/20 By yinhy 科目查询自动过滤
# Modify.........: No.TQC-B40003 11/04/01 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控部門
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ooo   RECORD LIKE ooo_file.*,
    g_ooo_t RECORD LIKE ooo_file.*,
    g_ooo10_t LIKE ooo_file.ooo10,
    g_ooo11_t LIKE ooo_file.ooo11,
    g_ooo01_t LIKE ooo_file.ooo01,
    g_ooo02_t LIKE ooo_file.ooo02,
    g_ooo03_t LIKE ooo_file.ooo03,
    g_ooo04_t LIKE ooo_file.ooo04,
    g_ooo05_t LIKE ooo_file.ooo05,
    g_ooo06_t LIKE ooo_file.ooo06,
    g_ooo07_t LIKE ooo_file.ooo07,
    g_aag05   LIKE aag_file.aag05,
    g_wc,g_sql     string                 #No.FUN-580092 HCN 
 
DEFINE g_forupd_sql          STRING       #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt                 LIKE type_file.num10     #No.FUN-680123 INTEGER
DEFINE g_msg                 LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10     #No.FUN-680123 INTEGER
DEFINE g_curs_index          LIKE type_file.num10     #No.FUN-680123 INTEGER
DEFINE g_jump                LIKE type_file.num10     #No.FUN-680123 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5      #No.FUN-680123 SMALLINT
 
MAIN
 
#     DEFINEl_time LIKE type_file.chr8             #No.FUN-6A0095
DEFINE p_row,p_col    LIKE type_file.num5             #No.FUN-680123 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AXR")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
    INITIALIZE g_ooo.* TO NULL
    INITIALIZE g_ooo_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ooo_file WHERE ooo10=? AND ooo11=? AND ooo01=? AND ooo02=? AND ooo03=? AND ooo04=? AND ooo05=? AND ooo06=? AND ooo07=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i500_w AT p_row,p_col WITH FORM "axr/42f/axri500"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #WHILE TRUE      ####040512
       LET g_action_choice=""
       CALL i500_menu()
       #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i500_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
END MAIN
 
 
FUNCTION i500_cs()
    CLEAR FORM
 
   INITIALIZE g_ooo.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
     # ooo10,ooo11,ooo03,ooo01,ooo02,ooo04,ooo05,ooo06,ooo07,ooo09d,
       ooo12,ooo10,ooo11,ooo03,ooo01,ooo02,ooo04,ooo05,ooo06,ooo07,ooo09d,
       ooo08d,ooo09c,ooo08c
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(ooo03) #會計科目
#                CALL q_aag(10,3,g_ooo.ooo03,'','','') RETURNING g_ooo.ooo03
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ooo.ooo03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo03
                 NEXT FIELD ooo03
              WHEN INFIELD(ooo01) #客戶編號
#                CALL q_occ(9,42,g_ooo.ooo01) RETURNING g_ooo.ooo01
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ooo.ooo01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo01
                 NEXT FIELD ooo01
              WHEN INFIELD(ooo04) #部門
#                CALL q_gem(9,42,g_ooo.ooo04) RETURNING g_ooo.ooo04
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ooo.ooo04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo04
                 NEXT FIELD ooo04
              WHEN INFIELD(ooo05)
#                CALL q_azi(05,11,g_ooo.ooo05) RETURNING g_ooo.ooo05
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ooo.ooo05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo05
                 NEXT FIELD ooo05
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT ooo10,ooo11,ooo01,ooo02,ooo03,ooo04,ooo05,",
              "             ooo06,ooo07 FROM ooo_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY ooo10,ooo11,ooo01"
 
    PREPARE i500_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i500_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i500_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ooo_file WHERE ",g_wc CLIPPED
    PREPARE i500_recount FROM g_sql
    DECLARE i500_count CURSOR FOR i500_recount
END FUNCTION
 
FUNCTION i500_menu()
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i500_a()
         END IF
 
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i500_q()
         END IF
 
      ON ACTION next
         CALL i500_fetch('N')
 
      ON ACTION previous
         CALL i500_fetch('P')
 
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i500_u()
         END IF
 
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i500_r()
         END IF
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #EXIT MENU
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT MENU
 
     ON ACTION jump
        CALL i500_fetch('/')
 
     ON ACTION first
        CALL i500_fetch('F')
 
     ON ACTION last
        CALL i500_fetch('L')
 
      ON ACTION controlg
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
 
    END MENU
    CLOSE i500_cs
END FUNCTION
 
 
FUNCTION i500_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ooo.* LIKE ooo_file.*
    SELECT * INTO g_apz.* FROM apz_file WHERE apz00='0'
    LET g_ooo_t.* = g_ooo.*
    LET g_ooo10_t = NULL
    LET g_ooo11_t = NULL
    LET g_ooo01_t = NULL
    LET g_ooo02_t = NULL
    LET g_ooo03_t = NULL
    LET g_ooo04_t = NULL
    LET g_ooo05_t = NULL
    LET g_ooo06_t = NULL
    LET g_ooo07_t = NULL
    LET g_ooo.ooo10 = g_plant
    LET g_ooo.ooo11 = g_apz.apz02b
    LET g_ooo.ooo12='0'    #No.+212
    LET g_ooo.ooo09d= 0
    LET g_ooo.ooo08d= 0
    LET g_ooo.ooo09c= 0
    LET g_ooo.ooo08c= 0
    LET g_ooo.ooolegal = g_legal #FUN-980011 add
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i500_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_ooo.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ooo.ooo01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ooo_file VALUES(g_ooo.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err('ins ooo:',SQLCA.sqlcode,0)   #No.FUN-660116
            CALL cl_err3("ins","ooo_file",g_ooo.ooo01,g_ooo.ooo03,SQLCA.sqlcode,"","ins ooo:",1)  #No.FUN-660116
            CONTINUE WHILE
        ELSE
            LET g_ooo_t.* = g_ooo.*                # 保存上筆資料
            SELECT ooo10,ooo11,ooo01,ooo02,ooo03,ooo04,ooo05,ooo06,ooo07 INTO g_ooo.ooo10,g_ooo.ooo11,g_ooo.ooo01,g_ooo.ooo02,g_ooo.ooo03,g_ooo.ooo04,g_ooo.ooo05,g_ooo.ooo06,g_ooo.ooo07 FROM ooo_file
             WHERE ooo10 = g_ooo.ooo10 AND ooo11 = g_ooo.ooo11
               AND ooo01 = g_ooo.ooo01 AND ooo02 = g_ooo.ooo02
               AND ooo03 = g_ooo.ooo03 AND ooo04 = g_ooo.ooo04
               AND ooo05 = g_ooo.ooo05 AND ooo06 = g_ooo.ooo06
               AND ooo07 = g_ooo.ooo07
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i500_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #判斷必要欄位之值是否有輸入 #No.FUN-680123 VARCHAR(1)
        l_n             LIKE type_file.num5,     #No.FUN-680123 SMALLINT
        l_sql           STRING                   #No.FUN-670006  -add  
 
    DEFINE li_chk_bookno     LIKE type_file.num5    #No.FUN-670006  #No.FUN-680123 SMALLINT  
    DEFINE l_aag05           LIKE aag_file.aag05    #No.TQC-B40003  
 
    DISPLAY BY NAME g_ooo.ooo12    #No.+212 add
    INPUT BY NAME g_ooo.ooo12,g_ooo.ooo10,g_ooo.ooo11,g_ooo.ooo03,g_ooo.ooo01,
                  g_ooo.ooo04,g_ooo.ooo05,g_ooo.ooo06,g_ooo.ooo07,
                  g_ooo.ooo09d,g_ooo.ooo08d,g_ooo.ooo09c,g_ooo.ooo08c
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i500_set_entry(p_cmd)
            CALL i500_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD ooo10
            IF NOT cl_null(g_ooo.ooo10) THEN
               SELECT * FROM azp_file WHERE azp01 = g_ooo.ooo10
               IF STATUS THEN
#                 CALL cl_err(g_ooo.ooo10,'aap-025',0)   #No.FUN-660116
                  CALL cl_err3("sel","azp_file","g_ooo.ooo10","","aap-025","","",1)  #No.FUN-660116
                  NEXT FIELD ooo10 
               END IF
            END IF
 
        AFTER FIELD ooo11
            IF NOT cl_null(g_ooo.ooo11) THEN
               #No.FUN-670006--begin
             CALL s_check_bookno(g_ooo.ooo11,g_user,g_ooo.ooo10) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD ooo11
             END IF 
             LET g_plant_new= g_ooo.ooo10  #工廠編號
                 CALL s_getdbs()
                 LET l_sql = "SELECT *",
                             #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                             "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                             " WHERE aaa01 = '",g_ooo.ooo11,"' ",
                             "   AND aaaacti IN ('Y','y') "
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                 PREPARE i500_pre2 FROM l_sql
                 DECLARE i500_cur2 CURSOR FOR i500_pre2
                 OPEN i500_cur2
                 FETCH i500_cur2 
#              SELECT * FROM aaa_file WHERE aaa01 = g_ooo.ooo11 AND aaaacti='Y'
               #No.FUN-670006--end
               IF STATUS THEN
#                 CALL cl_err(g_ooo.ooo11,'aap-229',0)  #No.FUN-660116
                  CALL cl_err3("sel","aaa_file",g_ooo.ooo11,"","aap-229","","",1)  #No.FUN-660116
                  NEXT FIELD ooo11  
               END IF
            END IF
 
        BEFORE FIELD ooo03
            CALL i500_set_entry(p_cmd)
 
        AFTER FIELD ooo03
            IF NOT cl_null(g_ooo.ooo03) THEN
               CALL i500_ooo03('a')
               IF NOT cl_null(g_errno) THEN
                  #No.FUN-B10053  --Begin
                  CALL cl_err(g_ooo.ooo03,g_errno,0)
                  #LET g_ooo.ooo03 = g_ooo03_t
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_ooo.ooo03
                  LET g_qryparam.arg1 = g_ooo.ooo11
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_ooo.ooo03 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_ooo.ooo03
                  DISPLAY BY NAME g_ooo.ooo01
                  NEXT FIELD ooo03
                  #No.FUN-B10053 --End
               END IF
            END IF
            IF g_aag05<>'Y' THEN
               LET g_ooo.ooo04 = ' '
               DISPLAY BY NAME g_ooo.ooo04
            END IF
            CALL i500_set_no_entry(p_cmd)
 
        AFTER FIELD ooo01
            IF NOT cl_null(g_ooo.ooo01) THEN
               IF g_ooo01_t IS NULL OR (g_ooo.ooo01 != g_ooo01_t) THEN
                  CALL i500_ooo01()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_ooo.ooo01,g_errno,0)
                     LET g_ooo.ooo01 = g_ooo01_t
                     DISPLAY BY NAME g_ooo.ooo01
                     NEXT FIELD ooo01
                  END IF
               END IF
            END IF
 
        AFTER FIELD ooo04
            #科目為需有部門資料者才需建立此欄位
            IF g_aag05 ='Y' THEN
               IF cl_null(g_ooo.ooo02) THEN NEXT FIELD ooo04 END IF
               CALL i500_ooo04('a')
               #No.TQC-B40003  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_ooo.ooo03
                  AND aag00 = g_ooo.ooo11
               IF l_aag05 = 'Y' THEN
               #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     CALL s_chkdept(g_aaz.aaz72,g_ooo.ooo03,g_ooo.ooo04,g_ooo.ooo11)
                          RETURNING g_errno
                  END IF
               END IF
               #No.TQC-B40003  --End
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ooo.ooo04,g_errno,0)
                  LET g_ooo.ooo04 = g_ooo04_t
                  DISPLAY BY NAME g_ooo.ooo04
                  NEXT FIELD ooo04
               END IF
            END IF
 
        AFTER FIELD ooo05
          IF NOT cl_null(g_ooo.ooo05) THEN
             SELECT COUNT(*) INTO g_cnt
               FROM azi_file WHERE azi01=g_ooo.ooo05
             IF g_cnt = 0 THEN
                CALL cl_err('select azi',STATUS,0) NEXT FIELD ooo05
             END IF
          END IF
 
        AFTER FIELD ooo07
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_ooo.ooo07) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_ooo.ooo06
            IF g_azm.azm02 = 1 THEN
               IF g_ooo.ooo07 > 12 OR g_ooo.ooo07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD ooo07
               END IF
            ELSE
               IF g_ooo.ooo07 > 13 OR g_ooo.ooo07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD ooo07
               END IF
            END IF
         END IF
            IF NOT cl_null(g_ooo.ooo07) THEN
#No.TQC-720032 -- begin --
#               IF g_ooo.ooo07 > 12 OR g_ooo.ooo06 < 1 THEN
#                  NEXT FIELD ooo07
#               END IF
#No.TQC-720032 -- end --
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND (g_ooo.ooo01 != g_ooo01_t OR
                                   g_ooo.ooo02 != g_ooo02_t OR
                                   g_ooo.ooo03 != g_ooo03_t OR
                                   g_ooo.ooo04 != g_ooo04_t OR
                                   g_ooo.ooo05 != g_ooo05_t OR
                                   g_ooo.ooo06 != g_ooo06_t OR
                                   g_ooo.ooo07 != g_ooo07_t)) THEN
                 SELECT COUNT(*) INTO l_n FROM ooo_file
                  WHERE ooo10 = g_ooo.ooo10 AND ooo11 = g_ooo.ooo11
                    AND ooo01 = g_ooo.ooo01 AND ooo02 = g_ooo.ooo02
                    AND ooo03 = g_ooo.ooo03 AND ooo04 = g_ooo.ooo04
                    AND ooo05 = g_ooo.ooo05 AND ooo06 = g_ooo.ooo06
                    AND ooo07 = g_ooo.ooo07
                 IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('',-239,0)
                    NEXT FIELD ooo07
                 END IF
               END IF
            END IF
 
        AFTER FIELD ooo09d
            IF cl_null(g_ooo.ooo09d) THEN LET g_ooo.ooo09d=0 END IF
 
        AFTER FIELD ooo08d
            IF cl_null(g_ooo.ooo08d) THEN LET g_ooo.ooo08d=0 END IF
 
        AFTER FIELD ooo09c
            IF cl_null(g_ooo.ooo09c) THEN LET g_ooo.ooo09c=0 END IF
 
        AFTER FIELD ooo08c
            IF cl_null(g_ooo.ooo08c) THEN LET g_ooo.ooo08c=0 END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_ooo.ooo01) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ooo.ooo01
            END IF
            IF cl_null(g_ooo.ooo02) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ooo.ooo02
            END IF
            IF cl_null(g_ooo.ooo03) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ooo.ooo03
            END IF
          # IF cl_null(g_ooo.ooo04) THEN
            IF cl_null(g_ooo.ooo04) AND g_aag05='Y'  THEN  #No.+212
               LET l_flag='Y'
               DISPLAY BY NAME g_ooo.ooo04
            END IF
            IF cl_null(g_ooo.ooo05) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ooo.ooo05
            END IF
            IF cl_null(g_ooo.ooo07) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ooo.ooo07
            END IF
            IF cl_null(g_ooo.ooo10) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ooo.ooo10
            END IF
            IF cl_null(g_ooo.ooo11) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ooo.ooo11
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0) NEXT FIELD ooo10
            END IF
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(ooo01) THEN
      #          LET g_ooo.* = g_ooo_t.*
      #          DISPLAY BY NAME g_ooo.*
      #          NEXT FIELD ooo01
      #      END IF
      #MOD-650015 --end
        ON ACTION controlp
           CASE
              WHEN INFIELD(ooo03) #會計科目
#                CALL q_aag(10,3,g_ooo.ooo03,'','','') RETURNING g_ooo.ooo03
#                CALL FGL_DIALOG_SETBUFFER( g_ooo.ooo03 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_ooo.ooo03
                 LET g_qryparam.arg1 = g_ooo.ooo11            #No.FUN-740009
                 CALL cl_create_qry() RETURNING g_ooo.ooo03
#                 CALL FGL_DIALOG_SETBUFFER( g_ooo.ooo03 )
                 DISPLAY BY NAME g_ooo.ooo03
                 NEXT FIELD ooo03
               WHEN INFIELD(ooo01) #客戶編號
#                CALL q_occ(9,42,g_ooo.ooo01) RETURNING g_ooo.ooo01
#                CALL FGL_DIALOG_SETBUFFER( g_ooo.ooo01 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_ooo.ooo01
                 CALL cl_create_qry() RETURNING g_ooo.ooo01
#                 CALL FGL_DIALOG_SETBUFFER( g_ooo.ooo01 )
                 DISPLAY BY NAME g_ooo.ooo01
                 NEXT FIELD ooo01
              WHEN INFIELD(ooo04) #部門
#                CALL q_gem(9,42,g_ooo.ooo04) RETURNING g_ooo.ooo04
#                CALL FGL_DIALOG_SETBUFFER( g_ooo.ooo04 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_ooo.ooo04
                 CALL cl_create_qry() RETURNING g_ooo.ooo04
#                 CALL FGL_DIALOG_SETBUFFER( g_ooo.ooo04 )
                 DISPLAY BY NAME g_ooo.ooo04
                 NEXT FIELD ooo04
              WHEN INFIELD(ooo05)
#                CALL q_azi(05,11,g_ooo.ooo05) RETURNING g_ooo.ooo05
#                CALL FGL_DIALOG_SETBUFFER( g_ooo.ooo05 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_ooo.ooo05
                 CALL cl_create_qry() RETURNING g_ooo.ooo05
#                 CALL FGL_DIALOG_SETBUFFER( g_ooo.ooo05 )
                 DISPLAY BY NAME g_ooo.ooo05
                 NEXT FIELD ooo05
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
 
FUNCTION i500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ooo.* TO NULL              #No.FUN-6B0042
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i500_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " Searching! "
    OPEN i500_count
    FETCH i500_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ooo.ooo01 CLIPPED,'+',g_ooo.ooo02,'+',g_ooo.ooo03
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_ooo.* TO NULL
    ELSE
        CALL i500_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i500_fetch(p_flooo)
    DEFINE
        p_flooo         LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680123 INTEGER
 
    CASE p_flooo
        WHEN 'N' FETCH NEXT     i500_cs INTO g_ooo.ooo10,
                                             g_ooo.ooo11,g_ooo.ooo01,
                                             g_ooo.ooo02,g_ooo.ooo03,
                                             g_ooo.ooo04,g_ooo.ooo05,
                                             g_ooo.ooo06,g_ooo.ooo07
        WHEN 'P' FETCH PREVIOUS i500_cs INTO g_ooo.ooo10,
                                             g_ooo.ooo11,g_ooo.ooo01,
                                             g_ooo.ooo02,g_ooo.ooo03,
                                             g_ooo.ooo04,g_ooo.ooo05,
                                             g_ooo.ooo06,g_ooo.ooo07
        WHEN 'F' FETCH FIRST    i500_cs INTO g_ooo.ooo10,
                                             g_ooo.ooo11,g_ooo.ooo01,
                                             g_ooo.ooo02,g_ooo.ooo03,
                                             g_ooo.ooo04,g_ooo.ooo05,
                                             g_ooo.ooo06,g_ooo.ooo07
        WHEN 'L' FETCH LAST     i500_cs INTO g_ooo.ooo10,
                                             g_ooo.ooo11,g_ooo.ooo01,
                                             g_ooo.ooo02,g_ooo.ooo03,
                                             g_ooo.ooo04,g_ooo.ooo05,
                                             g_ooo.ooo06,g_ooo.ooo07
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
            FETCH ABSOLUTE  g_jump i500_cs INTO g_ooo.ooo10,
                                               g_ooo.ooo11,g_ooo.ooo01,
                                               g_ooo.ooo02,g_ooo.ooo03,
                                               g_ooo.ooo04,g_ooo.ooo05,
                                               g_ooo.ooo06,g_ooo.ooo07
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ooo.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flooo
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ooo.* FROM ooo_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ooo10=g_ooo.ooo10 AND ooo11=g_ooo.ooo11 AND ooo01=g_ooo.ooo01 AND ooo02=g_ooo.ooo02 AND ooo03=g_ooo.ooo03 AND ooo04=g_ooo.ooo04 AND ooo05=g_ooo.ooo05 AND ooo06=g_ooo.ooo06 AND ooo07=g_ooo.ooo07
    IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660116
        CALL cl_err3("sel","ooo_file",g_ooo.ooo01,g_ooo.ooo03,SQLCA.sqlcode,"","",1)  #No.FUN-660116
    ELSE
 
        CALL i500_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i500_show()
    LET g_ooo_t.* = g_ooo.*
    DISPLAY BY NAME
        g_ooo.ooo10,g_ooo.ooo11,g_ooo.ooo03,g_ooo.ooo01,g_ooo.ooo02,
        g_ooo.ooo04,g_ooo.ooo05,g_ooo.ooo06,g_ooo.ooo07,
        g_ooo.ooo09d,g_ooo.ooo08d,g_ooo.ooo09c,g_ooo.ooo08c,
        g_ooo.ooo12    #No.+212 add
 
    CALL i500_ooo03('d')
    CALL i500_ooo04('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i500_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ooo.ooo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ooo10_t = g_ooo.ooo10
    LET g_ooo11_t = g_ooo.ooo11
    LET g_ooo01_t = g_ooo.ooo01
    LET g_ooo02_t = g_ooo.ooo02
    LET g_ooo03_t = g_ooo.ooo03
    LET g_ooo04_t = g_ooo.ooo04
    LET g_ooo05_t = g_ooo.ooo05
    LET g_ooo06_t = g_ooo.ooo06
    LET g_ooo07_t = g_ooo.ooo07
    BEGIN WORK
 
    OPEN i500_cl USING  g_ooo.ooo10,g_ooo.ooo11,g_ooo.ooo01,g_ooo.ooo02,g_ooo.ooo03,g_ooo.ooo04,g_ooo.ooo05,g_ooo.ooo06,g_ooo.ooo07
 
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_ooo.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i500_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i500_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ooo.*=g_ooo_t.*
            CALL i500_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ooo_file SET ooo_file.* = g_ooo.*    # 更新DB
           WHERE ooo10=g_ooo10_t AND ooo11=g_ooo11_t AND ooo01=g_ooo01_t AND ooo02=g_ooo02_t AND ooo03=g_ooo03_t AND ooo04=g_ooo04_t AND ooo05=g_ooo05_t AND ooo06=g_ooo06_t AND ooo07=g_ooo07_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660116
            CALL cl_err3("upd","ooo_file",g_ooo01_t,g_ooo03_t,SQLCA.sqlcode,"","",1)  #No.FUN-660116
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i500_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i500_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ooo.ooo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i500_cl USING  g_ooo.ooo10,g_ooo.ooo11,g_ooo.ooo01,g_ooo.ooo02,g_ooo.ooo03,g_ooo.ooo04,g_ooo.ooo05,g_ooo.ooo06,g_ooo.ooo07
 
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_ooo.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i500_show()
    IF cl_delete() THEN
        DELETE FROM ooo_file
            WHERE ooo10=g_ooo.ooo10 AND ooo11=g_ooo.ooo11 AND ooo01=g_ooo.ooo01 AND ooo02=g_ooo.ooo02 AND ooo03=g_ooo.ooo03 AND ooo04=g_ooo.ooo04 AND ooo05=g_ooo.ooo05 AND ooo06=g_ooo.ooo06 AND ooo07=g_ooo.ooo07
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660116
            CALL cl_err3("del","ooo_file",g_ooo.ooo01,g_ooo.ooo03,SQLCA.sqlcode,"","",1)  #No.FUN-660116
        ELSE
           CLEAR FORM
           OPEN i500_count
           FETCH i500_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i500_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i500_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i500_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i500_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i500_ooo03(p_cmd)
    DEFINE p_cmd        LIKE type_file.chr1        #No.FUN-680123 VARCHAR(01)
    DEFINE p_aag01      LIKE aag_file.aag01        #No.FUN-680123 VARCHAR(24)   
    DEFINE l_aag02      LIKE aag_file.aag02
    DEFINE l_aag03      LIKE aag_file.aag03
    DEFINE l_aag07      LIKE aag_file.aag07
    DEFINE l_acti       LIKE aag_file.aagacti      #No.FUN-680123 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT aag02,aag03,aag05,aag07,aagacti
      INTO l_aag02,l_aag03,g_aag05,l_aag07,l_acti
      FROM aag_file WHERE aag01 = g_ooo.ooo03
       AND aag00 = g_ooo.ooo11  #No.FUN-740009
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-027'
         WHEN l_acti  ='N'         LET g_errno = '9028'
         WHEN l_aag07  = '1'       LET g_errno = 'agl-015'
         WHEN l_aag03 != '2'       LET g_errno = 'agl-201'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_aag02 TO FORMONLY.aag02
    END IF
 
END FUNCTION
 
FUNCTION i500_ooo01()
    DEFINE p_cmd        LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
           l_occ02      LIKE occ_file.occ02,
           l_occacti    LIKE occ_file.occacti
 
    LET g_errno = ' '
    SELECT occ02,occacti INTO l_occ02,l_occacti
      FROM occ_file WHERE occ01=g_ooo.ooo01
 
    CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'anm-145'
                                      LET l_occ02 = ' '
         WHEN l_occacti      ='N'     LET g_errno = '9028'
#FUN-690023------mod-------
         WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
#FUN-690023------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) THEN
       LET g_ooo.ooo02 = l_occ02
       DISPLAY BY NAME g_ooo.ooo02
    END IF
 
END FUNCTION
 
FUNCTION i500_ooo04(p_cmd)
    DEFINE p_cmd        LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
           l_gem02      LIKE gem_file.gem02,
           l_gemacti    LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01=g_ooo.ooo04
 
    CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'aap-039'
                                      LET l_gem02 = ' '
         WHEN l_gemacti      ='N'     LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd='d' OR cl_null(g_errno) THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
 
END FUNCTION
 
FUNCTION i500_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ooo10,ooo11,ooo03,ooo01,ooo04,ooo05,ooo06,ooo07",TRUE)
   END IF
 
   IF INFIELD(ooo03) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ooo04",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i500_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ooo10,ooo11,ooo03,ooo01,ooo04,ooo05,ooo06,ooo07",FALSE)
   END IF
 
   IF INFIELD(ooo03) OR (NOT g_before_input_done) THEN  #g_aag05的值是由ooo03影響
      IF g_aag05 <> 'Y' THEN
         CALL cl_set_comp_entry("ooo04",FALSE)
      END IF
   END IF
 
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
