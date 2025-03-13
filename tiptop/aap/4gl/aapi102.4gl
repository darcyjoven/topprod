# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapi102.4gl
# Descriptions...: 應付帳款統計開帳作業
# Date & Author..: 99/09/20 By Kammy
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-620021 06/07/04 By Smapmin 修正期別檢核方式
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690024 06/09/12 By jamie 判斷pmcacti
# Modify.........: No.FUN-680046 06/09/29 By jamie 1.FUNCTION i102_q() 一開始應清空g_apn.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-690080 06/10/10 By douzh 新增零用金(aapi112)零用金應付帳款(依單號)各期統計開帳作業
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730064 07/03/29 By arman  會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-780046 07/09/10 By sherry  新增時，請款人員帶不到資料，把cpf_file換成gen_file                             
# Modify.........: No.FUN-890125 08/10/08 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤    
# Modify.........: No.FUN-980001 09/08/03 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-AC0018 10/12/01 by Dido 部門欄位應依據科目是否有部門管理才需控制 
# Modify.........: No.FUN-B10050 11/01/20 By Carrier 科目查询自动过滤
# Modify.........: No.TQC-B40001 11/04/01 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控部門輸入值的正確性
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_apn   RECORD LIKE apn_file.*,
    g_apn_t RECORD LIKE apn_file.*,
    g_before_input_done LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    g_apn08_t LIKE apn_file.apn08,
    g_apn09_t LIKE apn_file.apn09,
    g_apn10_t LIKE apn_file.apn10,
    g_apn01_t LIKE apn_file.apn01,
    g_apn02_t LIKE apn_file.apn02,
    g_apn00_t LIKE apn_file.apn00,
    g_apn03_t LIKE apn_file.apn03,
    g_apn04_t LIKE apn_file.apn04,
    g_apn05_t LIKE apn_file.apn05,
    g_wc,g_sql         string  #No.FUN-580092 HCN
 
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   g_argv1         LIKE type_file.chr1    #No.FUN-690080 
DEFINE   g_aag05         LIKE aag_file.aag05    #MOD-AC0018
 
MAIN
   LET g_argv1 = ARG_VAL(1)                                                                                                         
   IF g_argv1 = "2" THEN
      LET g_prog = 'aapi112'
   ELSE
      LET g_prog = 'aapi102'
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818
   INITIALIZE g_apn.* TO NULL
   INITIALIZE g_apn_t.* TO NULL
 
   LET g_forupd_sql = " SELECT * FROM apn_file WHERE apn08 = ? AND apn09 = ? AND apn00 = ? AND apn01 = ? AND apn02 = ? AND apn04 = ? AND apn05 = ? AND apn10 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i102_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   IF g_argv1 = "2" THEN
      OPEN WINDOW i102_w WITH FORM "aap/42f/aapi112"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   ELSE
      OPEN WINDOW i102_w WITH FORM "aap/42f/aapi102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   END IF
 
   CALL cl_ui_init()
 
   LET g_action_choice=""
   CALL i102_menu()
 
   CLOSE WINDOW i102_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i102_cs()
    CLEAR FORM
 
   INITIALIZE g_apn.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
       apn08,apn09,apn10,apn00,apn01,apn02,apn03,apn04,apn05,apn06,apn07    
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
    ON ACTION controlp
       CASE
          WHEN INFIELD(apn00) #會計科目
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aag"
             LET g_qryparam.default1 = g_apn.apn00
             #CALL cl_create_qry() RETURNING g_apn.apn00
             #DISPLAY BY NAME g_apn.apn00
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apn00
             NEXT FIELD apn00
          WHEN INFIELD(apn01) #客戶編號
#            CALL q_pmc(9,25,g_apn.apn01) RETURNING g_apn.apn01
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
#No.FUN-690080 --start--                                                                                                            
             IF g_argv1 = "2" THEN                                                                                                  
                #LET g_qryparam.form ="q_cpf4"     #No.CHI-780046                                                                                       
                LET g_qryparam.form ="q_gen"       #No.CHI-780046                                                                                 
             ELSE                                                                                                                   
                LET g_qryparam.form ="q_pmc"                                                                                        
             END IF                                                                                                                 
#No.FUN-690080 --end--
             LET g_qryparam.default1 =g_apn.apn01
             #CALL cl_create_qry() RETURNING g_apn.apn01
             #DISPLAY BY NAME g_apn.apn01
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apn01
             NEXT FIELD apn01
          WHEN INFIELD(apn03) #部門
#            CALL q_gem(9,38,g_apn.apn03) RETURNING g_apn.apn03
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gem"
             LET g_qryparam.default1 =g_apn.apn03
             #CALL cl_create_qry() RETURNING g_apn.apn03
             #DISPLAY BY NAME g_apn.apn03
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apn03
             NEXT FIELD apn03
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
 
    #No.FUN-690080 --Begin
    IF g_argv1 = '2' THEN
       LET g_sql="SELECT apn08,apn09,apn10,apn01,apn02,apn00,apn03,",
                 #"             apn04,apn05 FROM apn_file,cpf_file ", # 組合出 SQL 指令  #No.CHI-780046
                #"             apn04,apn05 FROM apn_file,gen_file ", #No.CHI-780046 
                 "             apn04,apn05 FROM apn_file,gen_file ", #FUN-890125              
                 " WHERE ",g_wc CLIPPED," ",
                 #"   AND apn01 = cpf01 ",        #No.CHI-780046 
                 "   AND apn01 = gen01 ",         #No.CHI-780046  
                 " ORDER BY apn08,apn09,apn01"
    ELSE
       LET g_sql="SELECT apn08,apn09,apn10,apn01,apn02,apn00,apn03,",
                #"             apn04,apn05 FROM apn_file ", # 組合出 SQL 指令
                 "             apn04,apn05 FROM apn_file ",#FUN-890125                     
                 " WHERE ",g_wc CLIPPED, "  ORDER BY apn08,apn09,apn01"
    END IF
    #No.FUN-690080 --End
 
    PREPARE i102_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i102_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i102_prepare
    #No.FUN-690080 --Begin
    IF g_argv1 = '2' THEN
       LET g_sql=
           #"SELECT COUNT(*) FROM apn_file,cpf_file ",    #No.CHI-780046 
           "SELECT COUNT(*) FROM apn_file,gen_file ",     #No.CHI-780046 
           " WHERE ",g_wc CLIPPED," ",
           #"   AND apn01 = cpf01 "                       #No.CHI-780046 
           "   AND apn01 = gen01 "                        #No.CHI-780046                 
    ELSE
       LET g_sql=
           "SELECT COUNT(*) FROM apn_file WHERE ",g_wc CLIPPED
    END IF
    #No.FUN-690080 --End
    PREPARE i102_recount FROM g_sql
    DECLARE i102_count CURSOR FOR i102_recount
END FUNCTION
 
FUNCTION i102_menu()
    MENU ""
 
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i102_a()
         END IF
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i102_q()
         END IF
      ON ACTION next
         CALL i102_fetch('N')
      ON ACTION previous
         CALL i102_fetch('P')
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i102_u()
         END IF
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i102_r()
         END IF
      ON ACTION help
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT MENU
      ON ACTION jump
         CALL i102_fetch('/')
      ON ACTION first
         CALL i102_fetch('F')
      ON ACTION last
         CALL i102_fetch('L')
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #No.FUN-680046-------add--------str----
      ON ACTION related_document             #相關文件"                        
       LET g_action_choice="related_document"           
          IF cl_chk_act_auth() THEN                     
             IF g_apn.apn08 IS NOT NULL THEN            
                LET g_doc.column1 = "apn08"               
                LET g_doc.column2 = "apn09" 
                LET g_doc.column3 = "apn10"
                LET g_doc.column4 = "apn00"              
                LET g_doc.value1 = g_apn.apn08            
                LET g_doc.value2 = g_apn.apn09
                LET g_doc.value3 = g_apn.apn10
                LET g_doc.value4 = g_apn.apn00            
                CALL cl_doc()                             
             END IF                                        
          END IF                                           
       #No.FUN-680046-------add--------end----   
         LET g_action_choice="exit"
         CONTINUE MENU
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
 
    END MENU
    CLOSE i102_cs
END FUNCTION
 
FUNCTION i102_a()
      
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_apn.* LIKE apn_file.*
    LET g_apn_t.* = g_apn.*
    LET g_apn08_t = NULL
    LET g_apn09_t = NULL
    LET g_apn10_t = NULL
    LET g_apn01_t = NULL
    LET g_apn02_t = NULL
    LET g_apn00_t = NULL
    LET g_apn03_t = NULL
    LET g_apn04_t = NULL
    LET g_apn05_t = NULL
    LET g_apn.apn08 = g_plant
    LET g_apn.apn09 = g_apz.apz02b
    LET g_apn.apn06 = 0
    LET g_apn.apn07 = 0
 
   #FUN-980001 add --(S)
    LET g_apn.apnlegal = g_legal
   #FUN-980001 add --(E)
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i102_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_apn.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_apn.apn01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO apn_file VALUES(g_apn.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err('ins apn:',SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("ins","apn_file",g_apn.apn08,g_apn.apn09,SQLCA.sqlcode,"","ins apn",1)  #No.FUN-660122
            CONTINUE WHILE
        ELSE
            LET g_apn_t.* = g_apn.*                # 保存上筆資料
            SELECT apn08,apn09,apn00,apn01,apn02,apn04,apn05,apn10 INTO g_apn.apn08,g_apn.apn09,g_apn.apn00,g_apn.apn01,g_apn.apn02,g_apn.apn04,g_apn.apn05,g_apn.apn10 FROM apn_file
             WHERE apn08 = g_apn.apn08 AND apn09 = g_apn.apn09
               AND apn01 = g_apn.apn01 AND apn02 = g_apn.apn02
               AND apn10 = g_apn.apn10
               AND apn00 = g_apn.apn00 AND apn03 = g_apn.apn03
               AND apn04 = g_apn.apn04 AND apn05 = g_apn.apn05
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i102_i(p_cmd)
    DEFINE
        li_chk_bookno   LIKE type_file.num5,     # No.FUN-690028  SMALLINT   #No.FUN-660141
        p_cmd           LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #判斷必要欄位之值是否有輸入  #No.FUN-690028 VARCHAR(1)
        l_n             LIKE type_file.num5,     #No.FUN-690028 SMALLINT
        l_sql           STRING      #No.FUN-660141
    DEFINE l_aag05      LIKE aag_file.aag05      #No.TQC-B40001
 
    INPUT BY NAME
        g_apn.apn08,g_apn.apn09,g_apn.apn10,g_apn.apn00,      
        g_apn.apn01,g_apn.apn02,
        g_apn.apn03,g_apn.apn04,g_apn.apn05,
        g_apn.apn06,g_apn.apn07
        WITHOUT DEFAULTS
 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i102_set_entry(p_cmd)
         CALL i102_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
 
        AFTER FIELD apn08
            IF NOT cl_null(g_apn.apn08) THEN
               SELECT * FROM azp_file WHERE azp01 = g_apn.apn08
               IF STATUS THEN
#                 CALL cl_err(g_apn.apn08,'aap-025',0)  #No.FUN-660122
                  CALL cl_err3("sel","azp_file",g_apn.apn08,"","aap-025","","",1)  #No.FUN-660122
                  NEXT FIELD apn08  
               END IF
            END IF
 
        AFTER FIELD apn09
          #No.FUN-660141--begin
           CALL s_check_bookno(g_apn.apn09,g_user,g_apn.apn08)
                RETURNING li_chk_bookno
           IF (NOT li_chk_bookno) THEN
              LET g_apn.apn09 = g_apn09_t
              NEXT FIELD apn09
           END IF
          #LET g_plant_new= g_apn.apn08  # 工廠編號    #FUN-A50102
          #CALL s_getdbs()                             #FUN-A50102
       LET l_sql = "SELECT * ",
                  #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",   #FUN-A50102
                   "  FROM ",cl_get_target_table(g_apn.apn08,'aaa_file'),    #FUN-A50102
                   " WHERE aaa01 = '",g_apn.apn09,"' ",
                   "   AND aaaacti = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,g_apn.apn08) RETURNING l_sql    #FUN-A50102
           PREPARE p102_pre2 FROM l_sql
           DECLARE p102_cur2 CURSOR FOR p102_pre2
           OPEN p102_cur2
           FETCH p102_cur2
 #         SELECT * FROM aaa_file WHERE aaa01 = g_apn.apn09 AND aaaacti='Y'
           #No.FUN-660141--end 
           IF STATUS THEN
#              CALL cl_err(g_apn.apn09,'aap-229',0)  #No.FUN-660122
               CALL cl_err3("sel","aaa_file",g_apn.apn09,"","aap-229","","",1)  #No.FUN-660122
               NEXT FIELD apn09   
            END IF
 
        AFTER FIELD apn00
            CALL i102_apn00('a',g_apn.apn09)           #NO.FUN-730064
            IF NOT cl_null(g_errno) THEN
               #No.FUN-B10050  --Begin
               CALL cl_err(g_apn.apn00,g_errno,0)
               #LET g_apn.apn00 = g_apn00_t
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_apn.apn00
               LET g_qryparam.arg1 = g_apn.apn09
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_apn.apn00 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_apn.apn00
               #No.FUN-B10050  --End  
               DISPLAY BY NAME g_apn.apn01
               NEXT FIELD apn00
            END IF
 
        AFTER FIELD apn01
            IF g_apn01_t IS NULL OR (g_apn.apn01 != g_apn01_t) THEN
               CALL i102_apn01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apn.apn01,g_errno,0)
                  LET g_apn.apn01 = g_apn01_t
                  DISPLAY BY NAME g_apn.apn01
                  NEXT FIELD apn01
               END IF
            END IF
 
        AFTER FIELD apn03
          IF NOT cl_null(g_apn.apn03) THEN  #TQC-B40001 add
            CALL i102_apn03('a')
            #No.TQC-B40001  --Begin
            LET l_aag05=''
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01 = g_apn.apn00
               AND aag00 = g_apn.apn09
            IF l_aag05 = 'Y' THEN
            #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
               IF g_aaz.aaz90 !='Y' THEN
                  CALL s_chkdept(g_aaz.aaz72,g_apn.apn00,g_apn.apn03,g_apn.apn09)          
                       RETURNING g_errno
               END IF
            END IF
            #No.TQC-B40001  --End
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_apn.apn03,g_errno,0)
               LET g_apn.apn03 = g_apn03_t
               DISPLAY BY NAME g_apn.apn03
               NEXT FIELD apn03
            END IF
          END IF  #TQC-B40001 add
 
 
        AFTER FIELD apn05
            #-----TQC-620021---------
            #IF g_apn.apn05 > 12 OR g_apn.apn04 < 1 THEN
            #   NEXT FIELD apn05
            #END IF
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_apn.apn04
            IF g_azm.azm02 = '1' THEN
               IF g_apn.apn05 > 12 OR g_apn.apn05 < 1 THEN
                  NEXT FIELD apn05
               END IF
            ELSE
               IF g_apn.apn05 > 13 OR g_apn.apn05 < 1 THEN
                  NEXT FIELD apn05
               END IF
            END IF
            #-----END TQC-620021-----
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (g_apn.apn01 != g_apn01_t OR
                                g_apn.apn02 != g_apn02_t OR
                                g_apn.apn00 != g_apn00_t OR
                                g_apn.apn03 != g_apn03_t OR
                                g_apn.apn04 != g_apn04_t OR
                                g_apn.apn05 != g_apn05_t)) THEN
              SELECT count(*) INTO l_n FROM apn_file
               WHERE apn01 = g_apn.apn01 AND apn02 = g_apn.apn02
                 AND apn00 = g_apn.apn00 AND apn03 = g_apn.apn03
                 AND apn04 = g_apn.apn04 AND apn05 = g_apn.apn05
              IF l_n > 0 THEN                  # Duplicated
                 CALL cl_err('',-239,0)
 
                 LET g_apn.apn08 = g_apn08_t LET g_apn.apn09 = g_apn09_t
                 LET g_apn.apn10 = g_apn10_t
                 LET g_apn.apn01 = g_apn01_t LET g_apn.apn02 = g_apn02_t
                 LET g_apn.apn00 = g_apn00_t LET g_apn.apn03 = g_apn03_t
                 LET g_apn.apn04 = g_apn04_t LET g_apn.apn05 = g_apn05_t
                 DISPLAY BY NAME g_apn.apn10
                 DISPLAY BY NAME g_apn.apn08
                 DISPLAY BY NAME g_apn.apn09
                 DISPLAY BY NAME g_apn.apn01
                 DISPLAY BY NAME g_apn.apn02
                 DISPLAY BY NAME g_apn.apn00
                 DISPLAY BY NAME g_apn.apn03
                 DISPLAY BY NAME g_apn.apn04
                 DISPLAY BY NAME g_apn.apn05
                 NEXT FIELD apn05
              END IF
            END IF
 
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_apn.apn01) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apn.apn01
            END IF
            IF cl_null(g_apn.apn02) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apn.apn02
            END IF
            IF cl_null(g_apn.apn00) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apn.apn00
            END IF
           #IF cl_null(g_apn.apn03) THEN                     #MOD-AC0018 mark
            IF cl_null(g_apn.apn03) AND g_aag05 = 'Y' THEN   #MOD-AC0018
               LET l_flag='Y'
               DISPLAY BY NAME g_apn.apn03
            END IF
            IF cl_null(g_apn.apn05) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apn.apn05
            END IF
            IF cl_null(g_apn.apn08) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apn.apn08
            END IF
            IF cl_null(g_apn.apn09) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apn.apn09
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0) NEXT FIELD apn08
            END IF
 
        #-----FUN-630081---------
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(apn01) THEN
        #        LET g_apn.* = g_apn_t.*
        #        DISPLAY BY NAME g_apn.*
        #        NEXT FIELD apn01
        #    END IF
        #-----END FUN-630081-----
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(apn00) #會計科目
#                CALL q_aag(10,3,g_apn.apn00,'','','') RETURNING g_apn.apn00
#                CALL FGL_DIALOG_SETBUFFER( g_apn.apn00 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_apn.apn00
                 LET g_qryparam.arg1 = g_apn.apn09       #NO.FUN-730064
                 CALL cl_create_qry() RETURNING g_apn.apn00
#                 CALL FGL_DIALOG_SETBUFFER( g_apn.apn00 )
                 DISPLAY BY NAME g_apn.apn00
                 NEXT FIELD apn00
              WHEN INFIELD(apn01) #客戶編號
#                CALL q_pmc(9,25,g_apn.apn01) RETURNING g_apn.apn01
#                CALL FGL_DIALOG_SETBUFFER( g_apn.apn01 )
                 CALL cl_init_qry_var()
#No.FUN-690080 --start--                                                                                                            
             IF g_argv1 = "2" THEN                                                                                                  
                #LET g_qryparam.form ="q_cpf4"     #No.CHI-780046                                                                                   
                LET g_qryparam.form ="q_gen"       #No.CHI-780046                                                                                            
             ELSE                                                                                                                   
                LET g_qryparam.form ="q_pmc"                                                                                        
             END IF                                                                                                                 
#No.FUN-690080 --end--
                 LET g_qryparam.default1 =g_apn.apn01
                 CALL cl_create_qry() RETURNING g_apn.apn01
#                 CALL FGL_DIALOG_SETBUFFER( g_apn.apn01 )
                 DISPLAY BY NAME g_apn.apn01
                 NEXT FIELD apn01
              WHEN INFIELD(apn03) #部門
#                CALL q_gem(9,38,g_apn.apn03) RETURNING g_apn.apn03
#                CALL FGL_DIALOG_SETBUFFER( g_apn.apn03 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 =g_apn.apn03
                 CALL cl_create_qry() RETURNING g_apn.apn03
#                 CALL FGL_DIALOG_SETBUFFER( g_apn.apn03 )
                 DISPLAY BY NAME g_apn.apn03
                 NEXT FIELD apn03
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
 
FUNCTION i102_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apn08",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i102_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apn08",FALSE)
   END IF
 
END FUNCTION
 
 
FUNCTION i102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_apn.* TO NULL             #No.FUN-680046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i102_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " Searching! "
    OPEN i102_count
    FETCH i102_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_apn.* TO NULL
    ELSE
        CALL i102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i102_fetch(p_flapn)
    DEFINE
        p_flapn          LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
    CASE p_flapn
        WHEN 'N' FETCH NEXT     i102_cs INTO g_apn.apn08,
                                             g_apn.apn09,g_apn.apn10,
                                             g_apn.apn01,
                                             g_apn.apn02,g_apn.apn00,
                                             g_apn.apn03,g_apn.apn04,
                                           # g_apn.apn05
                                             g_apn.apn05 #FUN-890125  
        WHEN 'P' FETCH PREVIOUS i102_cs INTO g_apn.apn08,
                                             g_apn.apn09,g_apn.apn10,
                                             g_apn.apn01,
                                             g_apn.apn02,g_apn.apn00,
                                             g_apn.apn03,g_apn.apn04,
                                           # g_apn.apn05
                                             g_apn.apn05 #FUN-890125
        WHEN 'F' FETCH FIRST    i102_cs INTO g_apn.apn08,
                                             g_apn.apn09,g_apn.apn10,
                                             g_apn.apn01,
                                             g_apn.apn02,g_apn.apn00,
                                             g_apn.apn03,g_apn.apn04,
                                           # g_apn.apn05
                                             g_apn.apn05 #FUN-890125
        WHEN 'L' FETCH LAST     i102_cs INTO g_apn.apn08,
                                             g_apn.apn09,g_apn.apn10,
                                             g_apn.apn01,
                                             g_apn.apn02,g_apn.apn00,
                                             g_apn.apn03,g_apn.apn04,
                                           # g_apn.apn05
                                             g_apn.apn05 #FUN-890125
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
            FETCH ABSOLUTE g_jump i102_cs INTO g_apn.apn08,
                                                g_apn.apn09,g_apn.apn10,
                                                g_apn.apn01,
                                                g_apn.apn02,g_apn.apn00,
                                                g_apn.apn03,g_apn.apn04,
                                              # g_apn.apn05
                                                g_apn.apn05  #FUN-890125
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_apn.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flapn
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_apn.* FROM apn_file            # 重讀DB,因TEMP有不被更新特性
       WHERE apn08 = g_apn.apn08 AND apn09 = g_apn.apn09 AND apn00 = g_apn.apn00 AND apn01 = g_apn.apn01 AND apn02 = g_apn.apn02 AND apn04 = g_apn.apn04 AND apn05 = g_apn.apn05 AND apn10 = g_apn.apn10
    IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("sel","apn_file",g_apn.apn08,g_apn.apn09,SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
      #NO.FUN-730064    --Begin
#        CALL s_get_bookno(g_apn.apn04) RETURNING  g_flag,g_bookno1,g_bookno2
#        IF g_flag = '1' THEN    #抓不到帳別
#            CALL cl_err(g_apn.apn04,'aoo-081',1)
#        END IF 
      #NO.FUN-730064    --END 
        CALL i102_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i102_show()
    LET g_apn_t.* = g_apn.*
    DISPLAY BY NAME
        g_apn.apn08,g_apn.apn09,g_apn.apn10,g_apn.apn00,g_apn.apn01,g_apn.apn02,
        g_apn.apn03,g_apn.apn04,g_apn.apn05,g_apn.apn06,g_apn.apn07
 
    CALL i102_apn00('d',g_apn.apn09)     #NO.FUN-730064
    CALL i102_apn03('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i102_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_apn.apn01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_apn08_t = g_apn.apn08
    LET g_apn09_t = g_apn.apn09
    LET g_apn10_t = g_apn.apn10
    LET g_apn01_t = g_apn.apn01
    LET g_apn02_t = g_apn.apn02
    LET g_apn00_t = g_apn.apn00
    LET g_apn03_t = g_apn.apn03
    LET g_apn04_t = g_apn.apn04
    LET g_apn05_t = g_apn.apn05
    BEGIN WORK
 
    OPEN i102_cl USING g_apn.apn08,g_apn.apn09,g_apn.apn00,g_apn.apn01,g_apn.apn02,g_apn.apn04,g_apn.apn05,g_apn.apn10
 
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_apn.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i102_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i102_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_apn.*=g_apn_t.*
            CALL i102_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE apn_file SET apn_file.* = g_apn.*    # 更新DB
            WHERE apn08 = g_apn08_t AND apn09 = g_apn09_t AND apn00 = g_apn00_t AND apn01 = g_apn01_t AND apn02 = g_apn02_t AND apn04 = g_apn04_t AND apn05 = g_apn05_t AND apn10 = g_apn10_t            # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("upd","apn_file",g_apn08_t,g_apn09_t,SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i102_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i102_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_apn.apn01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i102_cl USING g_apn.apn08,g_apn.apn09,g_apn.apn00,g_apn.apn01,g_apn.apn02,g_apn.apn04,g_apn.apn05,g_apn.apn10
 
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_apn.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i102_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "apn08"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "apn09"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "apn10"         #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "apn00"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_apn.apn08      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_apn.apn09      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_apn.apn10      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_apn.apn00      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM apn_file
            WHERE apn08 = g_apn.apn08 AND apn09 = g_apn.apn09 AND apn00 = g_apn.apn00 AND apn01 = g_apn.apn01 AND apn02 = g_apn.apn02 AND apn04 = g_apn.apn04 AND apn05 = g_apn.apn05 AND apn10 = g_apn.apn10
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("del","apn_file",g_apn.apn08,g_apn.apn09,SQLCA.sqlcode,"","",1)  #No.FUN-660122
        ELSE
           CLEAR FORM
           OPEN i102_count
           FETCH i102_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i102_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i102_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET g_no_ask = TRUE
              CALL i102_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i102_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i102_apn00(p_cmd,p_bookno)            #NO.FUN-730064
    DEFINE p_cmd        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE p_bookno     LIKE aag_file.aag00    #NO.FUN-730064
    DEFINE l_aag02      LIKE aag_file.aag02
    DEFINE l_aag03      LIKE aag_file.aag03
    DEFINE l_aag07      LIKE aag_file.aag07
    #DEFINE l_acti VARCHAR(1)                #FUN-660117 remark
    DEFINE l_acti	LIKE aag_file.aagacti  #FUN-660117
 
    LET g_errno = ' '
    SELECT aag02,aag03,aag07,aagacti INTO l_aag02,l_aag03,l_aag07,l_acti
      FROM aag_file WHERE aag01 = g_apn.apn00
                      AND aag00 = p_bookno          #NO.FUN-730064
 
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
 
FUNCTION i102_apn01()
    DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_pmc03      LIKE pmc_file.pmc03,
           l_pmcacti    LIKE pmc_file.pmcacti,
           #No.CHI-780046---Begin 
           #l_cpf02      LIKE cpf_file.cpf02,    #No.FUN-690080
           #l_cpfacti    LIKE cpf_file.cpfacti   #No.FUN-690080
           l_gen02      LIKE gen_file.gen02,    #No.FUN-690080
           l_genacti    LIKE gen_file.genacti   #No.FUN-690080
           #No.CHI-780046---End    
    LET g_errno = ' '
   IF g_argv1 != "2" THEN                    #No.FUN-690080
    SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
      FROM pmc_file WHERE pmc01=g_apn.apn01
 
    CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'aom-061'
                                      LET l_pmc03 = ' '
         WHEN l_pmcacti      ='N'     LET g_errno = '9028'
         
 #FUN-690024------mod-------
         WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'
 #FUN-690024------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) THEN
       LET g_apn.apn02 = l_pmc03
       DISPLAY BY NAME g_apn.apn02
    END IF
#No.FUN-690080 --start--                                                                                                            
    ELSE
         #No.CHI-780046---Begin 
         #SELECT cpf02,cpfacti INTO l_cpf02,l_cpfacti                                                                                
         #FROM cpf_file WHERE cpf01=g_apn.apn01                                                                                      
         SELECT gen02,genacti INTO l_gen02,l_genacti                                                                                
         FROM gen_file WHERE gen01=g_apn.apn01                                                                                      
         #No.CHI-780046---End                                                                                                                           
         CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'aap-038'                                                                  
                                           #LET l_cpf02 = ' '          #No.CHI-780046                                                               
                                           LET l_gen02 = ' '           #No.CHI-780046                                                             
              #WHEN l_cpfacti      ='N'     LET g_errno = '9028'       #No.CHI-780046                                                              
              WHEN l_genacti       ='N'     LET g_errno = '9028'       #No.CHI-780046                                                                
 #FUN-690024------mod-------                                                                                                        
              #WHEN l_cpfacti MATCHES '[PH]'  LET g_errno = '9038'     #No.CHI-780046                                                              
              WHEN l_genacti MATCHES '[PH]'  LET g_errno = '9038'      #No.CHI-780046                                                             
 #FUN-690024------mod-------                                                                                                        
              OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                        
         END CASE                                                                                                                   
                                                                                                                                    
         IF cl_null(g_errno) THEN                                                                                                   
            #LET g_apn.apn02 = l_cpf02            #No.CHI-780046                                                                                   
            LET g_apn.apn02 = l_gen02             #No.CHI-780046                                                                                     
            DISPLAY BY NAME g_apn.apn02                                                                                             
         END IF                                                                                                                     
    END IF
#No.FUN-690080 --end-- 
END FUNCTION
 
FUNCTION i102_apn03(p_cmd)
    DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_gem02      LIKE gem_file.gem02,
           l_gemacti    LIKE gem_file.gemacti
 
    LET g_errno = ' '
   #-MOD-AC0018-add-
    SELECT aag05 INTO g_aag05
      FROM aag_file
     WHERE aag00 = g_apn.apn09
       AND aag01 = g_apn.apn00  
   #-MOD-AC0018-end-
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01=g_apn.apn03
 
    CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'aap-039'
                                      LET l_gem02 = ' '
         WHEN l_gemacti      ='N'     LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
   #-MOD-AC0018-add-
    IF g_aag05 = 'N' AND g_errno <> ' ' THEN       
       LET g_errno = ' '
    END IF
   #-MOD-AC0018-end-
 
    IF p_cmd='d' OR cl_null(g_errno) THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
 
END FUNCTION
#Patch....NO.TQC-610035 <> #
