# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapi101.4gl
# Descriptions...: 應付帳款統計開帳作業
# Date & Author..: 99/09/20 By Kammy
# Modify.........: 01-04-16 BY ANN CHEN No.B371 自行輸入為開帳資料,apm10=0
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu _r() 後筆數不正確
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690024 06/09/12 By jamie 判斷pmcacti
# Modify.........: No.FUN-690080 06/9/30  By douzh 新增零用金(aapi111)應付帳款個期統計開帳作業 
# Modify.........: No.FUN-6A0055 06/10/25 By ice l_time轉g_time
# Modify.........: No.FUN-6A0016 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0171 07/02/06 By rainy 修正期別檢核方式
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730064 07/03/28 By arman   會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780040 07/08/08 By Smapmin 增加apm10的舊值備份
# Modify.........: No.CHI-780046 07/09/10 By sherry  新增時，請款人員帶不到資料，把cpf_file換成gen_file                             
# Modify.........: No.FUN-980001 09/08/03 By TSD.sar2436  GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B10050 11/01/20 By Carrier 科目查询自动过滤
# Modify.........: No:FUN-B40004 11/04/06 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_apm   RECORD LIKE apm_file.*,
    g_apm_t RECORD LIKE apm_file.*,
    g_apm08_t LIKE apm_file.apm08,
    g_apm09_t LIKE apm_file.apm09,
    g_apm10_t LIKE apm_file.apm10,
    #add 030522 NO.A074
    g_apm11_t LIKE apm_file.apm11,
    g_apm01_t LIKE apm_file.apm01,
    g_apm02_t LIKE apm_file.apm02,
    g_apm00_t LIKE apm_file.apm00,
    g_apm03_t LIKE apm_file.apm03,
    g_apm04_t LIKE apm_file.apm04,
    g_apm05_t LIKE apm_file.apm05,
    g_aag05   LIKE aag_file.aag05,
    g_wc,g_sql        string,                  #No.FUN-580092 HCN
    g_before_input_done LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_no_ask      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_argv1        LIKE type_file.chr1    #No.FUN-690080 
 
MAIN
   DEFINE p_row,p_col    LIKE type_file.num5     #No.FUN-690028 SMALLINT
 
   LET g_argv1 = ARG_VAL(1)
   IF g_argv1 = "2" THEN
      LET g_prog = 'aapi111'
   ELSE
      LET g_prog = 'aapi101'
   END IF
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   INITIALIZE g_apm.* TO NULL
   INITIALIZE g_apm_t.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM apm_file WHERE apm08=? AND apm09=? AND apm00=? AND apm10=? AND apm01=? AND apm02=? AND apm03=? AND apm11=? AND apm04=? AND apm05 =? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i101_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 4 LET p_col = 30
   IF g_argv1 = "2" THEN
      OPEN WINDOW i101_w AT p_row,p_col WITH FORM "aap/42f/aapi111"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   ELSE
      OPEN WINDOW i101_w AT p_row,p_col WITH FORM "aap/42f/aapi101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   END IF
 
   CALL cl_ui_init()
 
#   WHILE TRUE
      LET g_action_choice=""
      CALL i101_menu()
#     IF g_action_choice="exit" THEN EXIT WHILE END IF
#   END WHILE
 
   CLOSE WINDOW i101_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION i101_cs()
    CLEAR FORM
 
    #modify 030522 NO.A074
   INITIALIZE g_apm.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
       apm10,apm08,apm09,apm00,apm01,apm02,apm03,apm11,apm04,apm05, 
       apm06,apm06f,apm07,apm07f
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
    ON ACTION controlp
       CASE
          WHEN INFIELD(apm00) #會計科目
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aag"
             LET g_qryparam.default1 = g_apm.apm00
             #CALL cl_create_qry() RETURNING g_apm.apm00
             #DISPLAY BY NAME g_apm.apm00
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apm00
             NEXT FIELD apm00
          WHEN INFIELD(apm01) #客戶編號
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
#No.FUN-690080 --start--
             IF g_argv1 = "2" THEN
                #LET g_qryparam.form ="q_cpf"         #No.CHI-780046
                LET g_qryparam.form ="q_gen"          #No.CHI-780046 
             ELSE 
                LET g_qryparam.form ="q_pmc"
             END IF  
#No.FUN-690080 --end--
             LET g_qryparam.default1 = g_apm.apm01
             #CALL cl_create_qry() RETURNING g_apm.apm01
             #DISPLAY BY NAME g_apm.apm01
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apm01
             NEXT FIELD apm01
          WHEN INFIELD(apm03) #部門
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gem"
             LET g_qryparam.default1 =g_apm.apm03
             #CALL cl_create_qry() RETURNING g_apm.apm03
             #DISPLAY BY NAME g_apm.apm03
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apm03
             NEXT FIELD apm03
          #add 030522 NO.A074
          WHEN INFIELD(apm11) #幣別
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_azi"
             LET g_qryparam.default1 = g_apm.apm11
             #CALL cl_create_qry() RETURNING g_apm.apm11
             #DISPLAY BY NAME g_apm.apm11
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apm11
             NEXT FIELD apm11
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
 
    #modify 030522 NO.A074
#No.FUN-690080 --start--
    IF g_argv1 = "2" THEN
        LET g_sql="SELECT apm08,apm09,apm01,apm02,apm00,apm03,",                                                                  
                  "       apm04,apm05,apm10,apm11 ",   # 組合出 SQL 指令                                                                
                  #"  FROM apm_file,cpf_file",         #No.CHI-780046                                                                                            
                  "  FROM apm_file,gen_file",          #No.CHI-780046                                                                                         
                  " WHERE ",g_wc CLIPPED," ",
                  #"   AND apm01 = cpf01 ",            #No.CHI-780046
                  "   AND apm01 = gen01 ",             #No.CHI-780046    
                  " ORDER BY apm08,apm09,apm10,apm01" 
    ELSE
        LET g_sql="SELECT apm08,apm09,apm01,apm02,apm00,apm03,",
                  "       apm04,apm05,apm10,apm11 ",   # 組合出 SQL 指令
                  "  FROM apm_file ",
                  " WHERE ",g_wc CLIPPED," ",
                  " ORDER BY apm08,apm09,apm10,apm01"
    END IF
#No.FUN-690080 --end
    PREPARE i101_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i101_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i101_prepare
 
    #modify 030522 NO.A074
#No.FUN-690080 --start--
    IF g_argv1 = "2" THEN 
        LET g_sql="SELECT apm08,apm09,apm01,apm02,apm00,apm03,",                                                                    
                  "       apm04,apm05,apm10,apm11 ",                                                                                
                  #"  FROM apm_file,cpf_file ",       #No.CHI-780046                                                                                        
                  "  FROM apm_file,gen_file ",        #No.CHI-780046                                                                                       
                  " WHERE ",g_wc CLIPPED," ",
                  #"   AND apm01 = cpf01 ",           #No.CHI-780046 
                  "   AND apm01 = gen01 ",            #No.CHI-780046
                  " INTO TEMP x"
    ELSE
        LET g_sql="SELECT apm08,apm09,apm01,apm02,apm00,apm03,",
                  "       apm04,apm05,apm10,apm11 ",
                  "  FROM apm_file ",
                  " WHERE ",g_wc CLIPPED," ",
                  " INTO TEMP x"
    END IF                                           
#No.FUN-690080 --end--
    DROP TABLE x
    PREPARE i101_precount_x  FROM g_sql
    EXECUTE i101_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i101_precount FROM g_sql
    DECLARE i101_count CURSOR FOR i101_precount
END FUNCTION
 
FUNCTION i101_menu()
    MENU ""
 
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i101_a()
         END IF
 
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i101_q()
         END IF
 
      ON ACTION jump
         CALL i101_fetch('/')
 
      ON ACTION first
         CALL i101_fetch('F')
 
      ON ACTION last
         CALL i101_fetch('L')
 
      ON ACTION next
         CALL i101_fetch('N')
 
      ON ACTION previous
         CALL i101_fetch('P')
 
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i101_u()
         END IF
 
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i101_r()
         END IF
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        EXIT MENU
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT MENU
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
         LET g_action_choice="exit"
         CONTINUE MENU
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
 
    END MENU
    CLOSE i101_cs
END FUNCTION
 
 
FUNCTION i101_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_apm.* LIKE apm_file.*
    LET g_apm_t.* = g_apm.*
    LET g_apm10_t = NULL
    LET g_apm08_t = NULL
    LET g_apm09_t = NULL
    LET g_apm01_t = NULL
    LET g_apm02_t = NULL
    LET g_apm00_t = NULL
    LET g_apm03_t = NULL
    LET g_apm04_t = NULL
    LET g_apm05_t = NULL
    LET g_apm.apm10 = '0'
    #add 030522 NO.A074
    LET g_apm11_t = NULL
    LET g_apm.apm11 = g_aza.aza17
    LET g_apm.apm06f = 0
    LET g_apm.apm07f = 0
 
    LET g_apm.apm08 = g_plant
    LET g_apm.apm09 = g_apz.apz02b
    LET g_apm.apm06 = 0
    LET g_apm.apm07 = 0
 
    #FUN-980001 add --(S)
    LET g_apm.apmlegal = g_legal
    #FUN-980001 add --(E)
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i101_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_apm.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_apm.apm01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO apm_file VALUES(g_apm.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err('ins apm:',SQLCA.sqlcode,0)
            CONTINUE WHILE
        ELSE
            LET g_apm_t.* = g_apm.*                # 保存上筆資料
            SELECT apm08,apm09,apm00,apm10,apm01,apm02,apm03,apm11,apm04,apm05 INTO g_apm.apm08,g_apm.apm09,g_apm.apm00,g_apm.apm10,g_apm.apm01,g_apm.apm02,g_apm.apm03,g_apm.apm11,g_apm.apm04,g_apm.apm05 FROM apm_file
             WHERE apm08 = g_apm.apm08 AND apm09 = g_apm.apm09
               AND apm01 = g_apm.apm01 AND apm02 = g_apm.apm02
               AND apm00 = g_apm.apm00 AND apm03 = g_apm.apm03
               AND apm04 = g_apm.apm04 AND apm05 = g_apm.apm05
               AND apm10 = g_apm.apm10   #No.B372 010426 by plum
               AND apm11 = g_apm.apm11   #add 030522 NO.A074
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i101_i(p_cmd)
    DEFINE li_chk_bookno  LIKE type_file.num5        # No.FUN-690028 SMALLINT   #No.FUN-660141
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #判斷必要欄位之值是否有輸入  #No.FUN-690028 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_sql           STRING       #No.FUN-660141
    DEFINE l_aag05      LIKE aag_file.aag05     #No.FUN-B40004
    INPUT BY NAME
        #modify 030522 NO.A074
        g_apm.apm10,g_apm.apm08,g_apm.apm09,g_apm.apm00,g_apm.apm01,g_apm.apm02,    
        g_apm.apm03,g_apm.apm11,g_apm.apm04,g_apm.apm05,
        g_apm.apm06,g_apm.apm06f,g_apm.apm07,g_apm.apm07f
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i101_set_entry(p_cmd)
         CALL i101_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
#        BEFORE FIELD apm08    #判斷是否可更改KEY值
#            IF p_cmd='u' AND g_chkey='N' THEN NEXT FIELD apm06 END IF
 
        AFTER FIELD apm08
          IF NOT cl_null(g_apm.apm08) THEN
            SELECT * FROM azp_file WHERE azp01 = g_apm.apm08
            IF STATUS THEN
               CALL cl_err(g_apm.apm08,'aap-025',0) NEXT FIELD apm08
            END IF
          END IF
 
        AFTER FIELD apm09
          IF NOT cl_null(g_apm.apm09) THEN
            #No.FUN-660141--begin
            CALL s_check_bookno(g_apm.apm09,g_user,g_apm.apm08)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               LET g_apm.apm09 = g_apm09_t
               NEXT FIELD apm09
            END IF
           #LET g_plant_new= g_apm.apm08  # 工廠編號   #FUN-A50102
           #CALL s_getdbs()                            #FUN-A50102
        LET l_sql = "SELECT * ",
                #   "  FROM ",g_dbs_new CLIPPED,"aaa_file ",    #FUN-A50102
                    "  FROM ",cl_get_target_table(g_apm.apm08,'aaa_file'),    #FUN-A50102
                    " WHERE aaa01 = '",g_apm.apm09,"' ",
                    "   AND aaaacti = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,g_apm.apm08) RETURNING l_sql    #FUN-A50102
            PREPARE p101_pre2 FROM l_sql
            DECLARE p101_cur2 CURSOR FOR p101_pre2
            OPEN p101_cur2
            FETCH p101_cur2
 #         SELECT * FROM aaa_file WHERE aaa01 = g_apm.apm09 AND aaaacti='Y' 
           #No.FUN-660141--end  
          IF STATUS THEN
               CALL cl_err(g_apm.apm09,'aap-229',0) NEXT FIELD apm09
            END IF
          END IF
 
        BEFORE FIELD apm00
            CALL i101_set_entry(p_cmd)
 
        AFTER FIELD apm00
          IF NOT cl_null(g_apm.apm00) THEN
            CALL i101_apm00('a',g_apm.apm09)     #NO.FUN-730064
            IF NOT cl_null(g_errno) THEN
               #No.FUN-B10050  --Begin
               CALL cl_err(g_apm.apm00,g_errno,0)
               #LET g_apm.apm00 = g_apm00_t
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_apm.apm00
               LET g_qryparam.arg1 = g_apm.apm09 
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_apm.apm00 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_apm.apm00
               DISPLAY BY NAME g_apm.apm01
               NEXT FIELD apm00
               #No.FUN-B10050  --End  
            END IF
            LET g_apm.apm03 = ' '
            DISPLAY BY NAME g_apm.apm03
          END IF
            CALL i101_set_no_entry(p_cmd)
 
        AFTER FIELD apm01
          IF NOT cl_null(g_apm.apm01) THEN
            IF g_apm01_t IS NULL OR (g_apm.apm01 != g_apm01_t) THEN
               CALL i101_apm01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apm.apm01,g_errno,0)
                  LET g_apm.apm01 = g_apm01_t
                  DISPLAY BY NAME g_apm.apm01
                  NEXT FIELD apm01
               END IF
            END IF
          END IF
 
 
#        BEFORE FIELD apm03
    #-->科目為需有部門資料者才需建立此欄位
{
            IF g_aag05<>'Y' THEN
            IF cl_ku() THEN
                  NEXT FIELD PREVIOUS
               ELSE
                  LET g_apm.apm03 = ' '
                  DISPLAY BY NAME g_apm.apm03
                  NEXT FIELD NEXT
               END IF
            END IF
}
 
        AFTER FIELD apm03
            #科目為需有部門資料者才需建立此欄位
            IF g_aag05 ='Y' THEN
               IF cl_null(g_apm.apm03) THEN NEXT FIELD apm03 END IF
               CALL i101_apm03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apm.apm03,g_errno,0)
                  LET g_apm.apm03 = g_apm03_t
                  DISPLAY BY NAME g_apm.apm03
                  NEXT FIELD apm03
               END IF
               #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_apm.apm00
                  AND aag00 = g_apm.apm09
               IF l_aag05 = 'Y' THEN
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_apm.apm00,g_apm.apm03,g_apm.apm09)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apm.apm03,g_errno,0)
                  LET g_apm.apm03 = g_apm03_t
                  DISPLAY BY NAME g_apm.apm03
                  NEXT FIELD apm03
               END IF
               #No.FUN-B40004  --End
            END IF
            IF cl_null(g_apm.apm03) THEN LET g_apm.apm03 = ' ' END IF
        #NO.FUN-730064   --Begin
        AFTER FIELD apm04
           IF  NOT cl_null(g_apm.apm04)    THEN
#             CALL s_get_bookno(g_apm.apm04)
#                  RETURNING g_flag,g_bookno1,g_bookno2
#             IF g_flag= '1' THEN     #抓不到帳別
#                  CALL cl_err(g_apm.apm04,'aoo-081',1)
#                  NEXT FIELD apm04
#             END IF
           #NO.FUN-730064   --END 
           END IF 
{
        AFTER FIELD apm04
            IF cl_ku() THEN
               IF g_aag05='Y' THEN
                  NEXT FIELD apm03
               ELSE
                  NEXT FIELD apm02
               END IF
            END IF
            IF cl_null(g_apm.apm04) THEN NEXT FIELD apm04 END IF
}
 
        #modify 030522 NO.A074
        AFTER FIELD apm11
{
            IF cl_ku() THEN
               IF g_aag05='Y' THEN
                  NEXT FIELD apm03
               ELSE
                  NEXT FIELD apm02
               END IF
            END IF
}
            SELECT azi01 FROM azi_file WHERE azi01 = g_apm.apm11
            IF STATUS THEN
               CALL cl_err(g_apm.apm11,'aap-002',0) NEXT FIELD apm11
            END IF
 
        #modify 030522 NO.A074
{
        AFTER FIELD apm04
            IF cl_null(g_apm.apm04) THEN NEXT FIELD apm04 END IF
}
 
        AFTER FIELD apm05
          IF NOT cl_null(g_apm.apm05) THEN
         #==No.FUN-6A0171--begin
            #IF g_apm.apm05 > 12 OR g_apm.apm04 < 1 THEN
            #   NEXT FIELD apm05
            #END IF
 
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_apm.apm04
            IF g_azm.azm02 = '1' THEN
               IF g_apm.apm05 > 12 OR g_apm.apm05 < 1 THEN
                  NEXT FIELD apm05
               END IF
            ELSE
               IF g_apm.apm05 > 13 OR g_apm.apm05 < 1 THEN
                  NEXT FIELD apm05
               END IF
            END IF
          #==No.FUN-6A0171--end
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (g_apm.apm01 != g_apm01_t OR
                                g_apm.apm02 != g_apm02_t OR
                                g_apm.apm00 != g_apm00_t OR
                                g_apm.apm03 != g_apm03_t OR
                                g_apm.apm04 != g_apm04_t OR
                                #add 030522 NO.A074
                                g_apm.apm08 != g_apm08_t OR
                                g_apm.apm09 != g_apm09_t OR
                                g_apm.apm10 != g_apm10_t OR
                                g_apm.apm11 != g_apm11_t OR
                                g_apm.apm05 != g_apm05_t)) THEN
              SELECT count(*) INTO l_n FROM apm_file
               WHERE apm01 = g_apm.apm01 AND apm02 = g_apm.apm02
                 AND apm00 = g_apm.apm00 AND apm03 = g_apm.apm03
                 AND apm04 = g_apm.apm04 AND apm05 = g_apm.apm05
                 AND apm10 = g_apm.apm10  #No.B372 010426 by plum
                 AND apm11 = g_apm.apm11  #add 030522 NO.A074
              IF l_n > 0 THEN                  # Duplicated
                 CALL cl_err('',-239,0)
                 LET g_apm.apm08 = g_apm08_t LET g_apm.apm09 = g_apm09_t
                 LET g_apm.apm01 = g_apm01_t LET g_apm.apm02 = g_apm02_t
                 LET g_apm.apm00 = g_apm00_t LET g_apm.apm03 = g_apm03_t
                 LET g_apm.apm04 = g_apm04_t LET g_apm.apm05 = g_apm05_t
                 LET g_apm.apm10 = g_apm10_t
                 LET g_apm.apm11 = g_apm11_t   #add 030522 NO.A074
                 DISPLAY BY NAME g_apm.apm08
                 DISPLAY BY NAME g_apm.apm09
                 DISPLAY BY NAME g_apm.apm01
                 DISPLAY BY NAME g_apm.apm02
                 DISPLAY BY NAME g_apm.apm00
                 DISPLAY BY NAME g_apm.apm03
                 DISPLAY BY NAME g_apm.apm04
                 DISPLAY BY NAME g_apm.apm05,g_apm.apm10
                 DISPLAY BY NAME g_apm.apm11  #add 030522 NO.A074
                 NEXT FIELD apm05
              END IF
            END IF
          END IF
 
        #add 030522 NO.A074
        AFTER FIELD apm06f
            IF cl_null(g_apm.apm06f) THEN LET g_apm.apm06f=0 END IF
 
        AFTER FIELD apm06
            IF cl_null(g_apm.apm06) THEN LET g_apm.apm06=0 END IF
 
        #add 030522 NO.A074
        AFTER FIELD apm07f
            IF cl_null(g_apm.apm07f) THEN LET g_apm.apm07f=0 END IF
 
        AFTER FIELD apm07
            IF cl_null(g_apm.apm07) THEN LET g_apm.apm07=0 END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_apm.apm01) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apm.apm01
            END IF
            IF cl_null(g_apm.apm02) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apm.apm02
            END IF
            IF cl_null(g_apm.apm03) THEN LET g_apm.apm03 = ' ' END IF
            IF cl_null(g_apm.apm00) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apm.apm00
            END IF
           #IF cl_null(g_apm.apm03) THEN
           #   LET l_flag='Y'
           #   DISPLAY BY NAME g_apm.apm03
           #END IF
            IF cl_null(g_apm.apm05) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apm.apm05
            END IF
            IF cl_null(g_apm.apm08) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apm.apm08
            END IF
            IF cl_null(g_apm.apm09) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apm.apm09
            END IF
            #add 030522 NO.A074
            IF cl_null(g_apm.apm11) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apm.apm11
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0) NEXT FIELD apm08
            END IF
 
        #-----FUN-630081---------
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(apm01) THEN
        #        LET g_apm.* = g_apm_t.*
        #        DISPLAY BY NAME g_apm.*
        #        NEXT FIELD apm01
        #    END IF
        #-----END FUN-630081-----
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(apm00) #會計科目
#                CALL q_aag(10,3,g_apm.apm00,'','','') RETURNING g_apm.apm00
#                CALL FGL_DIALOG_SETBUFFER( g_apm.apm00 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_apm.apm00
                 LET g_qryparam.arg1 = g_apm.apm09            #No.FUN-730064
                 CALL cl_create_qry() RETURNING g_apm.apm00
#                 CALL FGL_DIALOG_SETBUFFER( g_apm.apm00 )
                 DISPLAY BY NAME g_apm.apm00
                 NEXT FIELD apm00
              WHEN INFIELD(apm01) #客戶編號
#                CALL q_pmc(0,0,g_apm.apm01) RETURNING g_apm.apm01
#                CALL FGL_DIALOG_SETBUFFER( g_apm.apm01 )
                 CALL cl_init_qry_var()
#No.FUN-690080 --start--                                                                                                               
                 IF g_argv1 = "2" THEN                                                                                                  
                     #LET g_qryparam.form ="q_cpf"        #No.CHI-780046                                                                                
                     LET g_qryparam.form ="q_gen"         #No.CHI-780046                                                                                  
                 ELSE                                                                                                                   
                     LET g_qryparam.form ="q_pmc"                                                                                        
                 END IF                                                                                                                 
#No.FUN-690080 --end-- 
                 LET g_qryparam.default1 = g_apm.apm01
                 CALL cl_create_qry() RETURNING g_apm.apm01
#                 CALL FGL_DIALOG_SETBUFFER( g_apm.apm01 )
                 DISPLAY BY NAME g_apm.apm01
                 NEXT FIELD apm01
              WHEN INFIELD(apm03) #部門
#                CALL q_gem(9,38,g_apm.apm03) RETURNING g_apm.apm03
#                CALL FGL_DIALOG_SETBUFFER( g_apm.apm03 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 =g_apm.apm03
                 CALL cl_create_qry() RETURNING g_apm.apm03
#                 CALL FGL_DIALOG_SETBUFFER( g_apm.apm03 )
                 DISPLAY BY NAME g_apm.apm03
                 NEXT FIELD apm03
              #add 030522 NO.A074
              WHEN INFIELD(apm11) #幣別
#                CALL q_azi(0,0,g_apm.apm11) RETURNING g_apm.apm11
#                CALL FGL_DIALOG_SETBUFFER( g_apm.apm11 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_apm.apm11
                 CALL cl_create_qry() RETURNING g_apm.apm11
#                 CALL FGL_DIALOG_SETBUFFER( g_apm.apm11 )
                 DISPLAY BY NAME g_apm.apm11
                 NEXT FIELD apm11
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
 
FUNCTION i101_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apm08",TRUE)
   END IF
 
   IF INFIELD(apm00) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apm03",TRUE)
   END IF
END FUNCTION
 
FUNCTION i101_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apm08",FALSE)
   END IF
 
   IF INFIELD(apm00) OR (NOT g_before_input_done) THEN
      IF g_aag05<>'Y' THEN
         CALL cl_set_comp_entry("apm03",FALSE)
      END IF
   END IF
END FUNCTION
 
FUNCTION i101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_apm.* TO NULL              #No.FUN-6A0016
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i101_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " Searching! "
    OPEN i101_count
    FETCH i101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_apm.* TO NULL
    ELSE
        CALL i101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i101_fetch(p_flapm)
    DEFINE
        p_flapm          LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
    CASE p_flapm
        WHEN 'N' FETCH NEXT     i101_cs INTO g_apm.apm08,
                                             g_apm.apm09,g_apm.apm01,
                                             g_apm.apm02,g_apm.apm00,
                                             g_apm.apm03,g_apm.apm04,
                                            #g_apm.apm05 #No.B372 010426 by plum
                                             g_apm.apm05,g_apm.apm10,
                                             #modify 030522 NO.A074
                                             g_apm.apm11
        WHEN 'P' FETCH PREVIOUS i101_cs INTO g_apm.apm08,
                                             g_apm.apm09,g_apm.apm01,
                                             g_apm.apm02,g_apm.apm00,
                                             g_apm.apm03,g_apm.apm04,
                                             g_apm.apm05,g_apm.apm10,
                                             #modify 030522 NO.A074
                                             g_apm.apm11
        WHEN 'F' FETCH FIRST    i101_cs INTO g_apm.apm08,
                                             g_apm.apm09,g_apm.apm01,
                                             g_apm.apm02,g_apm.apm00,
                                             g_apm.apm03,g_apm.apm04,
                                             g_apm.apm05,g_apm.apm10,
                                             #modify 030522 NO.A074
                                             g_apm.apm11
        WHEN 'L' FETCH LAST     i101_cs INTO g_apm.apm08,
                                             g_apm.apm09,g_apm.apm01,
                                             g_apm.apm02,g_apm.apm00,
                                             g_apm.apm03,g_apm.apm04,
                                             g_apm.apm05,g_apm.apm10,
                                             #modify 030522 NO.A074
                                             g_apm.apm11
        WHEN '/'
            IF NOT g_no_ask THEN
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
            FETCH ABSOLUTE g_jump i101_cs INTO g_apm.apm08,
                                                g_apm.apm09,g_apm.apm01,
                                                g_apm.apm02,g_apm.apm00,
                                                g_apm.apm03,g_apm.apm04,
                                                g_apm.apm05,g_apm.apm10,
                                                #modify 030522 NO.A074
                                                g_apm.apm11
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_apm.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flapm
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_apm.* FROM apm_file            # 重讀DB,因TEMP有不被更新特性
       WHERE apm08=g_apm.apm08 AND apm09=g_apm.apm09 AND apm00=g_apm.apm00 AND apm10=g_apm.apm10 AND apm01=g_apm.apm01 AND apm02=g_apm.apm02 AND apm03=g_apm.apm03 AND apm11=g_apm.apm11 AND apm04=g_apm.apm04 AND apm05=g_apm.apm05
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
      #NO.FUN-730064    --Begin
#      CALL s_get_bookno(g_apm.apm04) RETURNING  g_flag,g_bookno1,g_bookno2
#      IF g_flag = '1' THEN     #抓不到帳別
#         CALL cl_err(g_apm.apm04,'aoo-081',1)
#      END IF 
      #NO.FUN-730064    --END
        CALL i101_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i101_show()
    LET g_apm_t.* = g_apm.*
    DISPLAY BY NAME
        g_apm.apm08,g_apm.apm09,g_apm.apm00,g_apm.apm01,g_apm.apm02,
        g_apm.apm03,g_apm.apm04,g_apm.apm05,g_apm.apm06,g_apm.apm07,
        #add 030522 NO.A074
        g_apm.apm10,g_apm.apm11,g_apm.apm06f,g_apm.apm07f
 
    CALL i101_apm00('d',g_apm.apm09)     #NO.FUN-730064
    CALL i101_apm03('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i101_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_apm.apm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_apm08_t = g_apm.apm08
    LET g_apm09_t = g_apm.apm09
    LET g_apm01_t = g_apm.apm01
    LET g_apm02_t = g_apm.apm02
    LET g_apm00_t = g_apm.apm00
    LET g_apm03_t = g_apm.apm03
    LET g_apm04_t = g_apm.apm04
    LET g_apm05_t = g_apm.apm05
    #add 030522 NO.A074
    LET g_apm11_t = g_apm.apm11
    LET g_apm10_t = g_apm.apm10     #MOD-780040
    BEGIN WORK
 
    OPEN i101_cl USING g_apm.apm08,g_apm.apm09,g_apm.apm00,g_apm.apm10,g_apm.apm01,g_apm.apm02,g_apm.apm03,g_apm.apm11,g_apm.apm04,g_apm.apm05
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_apm.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i101_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i101_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_apm.*=g_apm_t.*
            CALL i101_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE apm_file SET apm_file.* = g_apm.*    # 更新DB
            WHERE apm08=g_apm08_t AND apm09=g_apm09_t AND apm00=g_apm00_t AND apm10=g_apm10_t AND apm01=g_apm01_t AND apm02=g_apm02_t AND apm03=g_apm03_t AND apm11=g_apm11_t AND apm04=g_apm04_t AND apm05=g_apm05_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err('',SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_apm.apm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i101_cl USING g_apm.apm08,g_apm.apm09,g_apm.apm00,g_apm.apm10,g_apm.apm01,g_apm.apm02,g_apm.apm03,g_apm.apm11,g_apm.apm04,g_apm.apm05
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_apm.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i101_show()
    IF cl_delete() THEN
        DELETE FROM apm_file
            WHERE apm08=g_apm.apm08 AND apm09=g_apm.apm09 AND apm00=g_apm.apm00 AND apm10=g_apm.apm10 AND apm01=g_apm.apm01 AND apm02=g_apm.apm02 AND apm03=g_apm.apm03 AND apm11=g_apm.apm11 AND apm04=g_apm.apm04 AND apm05=g_apm.apm05
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('',SQLCA.sqlcode,0)
        ELSE
           CLEAR FORM
           #MOD-5A0004 add
           DROP TABLE x
           EXECUTE i101_precount_x
           #MOD-5A0004 end
           OPEN i101_count
           FETCH i101_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i101_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i101_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET g_no_ask = TRUE
              CALL i101_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_apm00(p_cmd,p_bookno)            #NO.FUN-730064
    DEFINE p_cmd        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE p_bookno     LIKE aag_file.aag00    #NO.FUN-730064
    DEFINE p_aag01	LIKE aag_file.aag01      # No.FUN-690028 VARCHAR(24)
    DEFINE l_aag02      LIKE aag_file.aag02
    DEFINE l_aag03      LIKE aag_file.aag03
    DEFINE l_aag07      LIKE aag_file.aag07
    #DEFINE l_acti	LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)                 #FUN-660117 remark
    DEFINE l_acti       LIKE aag_file.aagacti	#FUN-660117
 
    LET g_errno = ' '
    SELECT aag02,aag03,aag05,aag07,aagacti
      INTO l_aag02,l_aag03,g_aag05,l_aag07,l_acti
      FROM aag_file WHERE aag01 = g_apm.apm00
                      AND aag00 = p_bookno       #NO.FUN-730064
 
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
 
FUNCTION i101_apm01()
    DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_pmc03      LIKE pmc_file.pmc03,
           l_pmcacti    LIKE pmc_file.pmcacti,  #No.FUN-690080 
           #No.CHI-780046---Begin
           #l_cpf02      LIKE cpf_file.cpf02,    #No.FUN-690080 
           #l_cpfacti    LIKE cpf_file.cpfacti   #No.FUN-690080 
           l_gen02       LIKE gen_file.gen02, 
           l_genacti     LIKE gen_file.genacti
           #No.CHI-780046---End
    
    LET g_errno = ' '
    IF g_argv1 != "2" THEN                      #No.FUN-690080
         SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
         FROM pmc_file WHERE pmc01=g_apm.apm01
 
         CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'aom-061'
                                           LET l_pmc03 = ' '
              WHEN l_pmcacti ='N'          LET g_errno = '9028'
 #FUN-690024------mod-------
              WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'
 #FUN-690024------mod-------
              OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
 
         IF cl_null(g_errno) THEN
            LET g_apm.apm02 = l_pmc03
            DISPLAY BY NAME g_apm.apm02
         END IF
#No.FUN-690080 --start--
    ELSE
         #No.CHI-780046---Begin
         #SELECT cpf02,cpfacti INTO l_cpf02,l_cpfacti                                                                                     
         #FROM cpf_file WHERE cpf01=g_apm.apm01                                                                                         
         SELECT gen02,genacti INTO l_gen02,l_genacti                                                                                     
         FROM gen_file WHERE gen01=g_apm.apm01        
         #No.CHI-780046---End                                                                                 
                                                                                                                                    
         CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'aap-038'                                                                       
                                      #LET l_cpf02 = ' '                                                                             
                                      LET l_gen02 = ' '             #No.CHI-780046                                                                 
              #WHEN l_cpfacti      ='N'     LET g_errno = '9028'    #No.CHI-780046                                                                      
              WHEN l_genacti      ='N'     LET g_errno = '9028'     #No.CHI-780046                                                                      
 #FUN-690024------mod-------                                                                                                        
              #WHEN l_cpfacti MATCHES '[PH]'  LET g_errno = '9038'  #No.CHI-780046                                                                      
              WHEN l_genacti MATCHES '[PH]'  LET g_errno = '9038'   #No.CHI-780046                                                                     
 #FUN-690024------mod-------                                                                                                        
              OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                             
         END CASE                                                                                                                        
                                                                                                                                    
         IF cl_null(g_errno) THEN                                                                                                        
            #LET g_apm.apm02 = l_cpf02           #No.CHI-780046                                                                                          
            LET g_apm.apm02 = l_gen02            #No.CHI-780046                                                                                        
            DISPLAY BY NAME g_apm.apm02                                                                                                  
         END IF 
    END IF
#No.FUN-690080 --end--
END FUNCTION
 
FUNCTION i101_apm03(p_cmd)
    DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_gem02      LIKE gem_file.gem02,
           l_gemacti    LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01=g_apm.apm03
 
    CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'aap-039'
                                      LET l_gem02 = ' '
         WHEN l_gemacti      ='N'     LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd='d' OR cl_null(g_errno) THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
 
END FUNCTION
#Patch....NO.TQC-610035 <001> #
