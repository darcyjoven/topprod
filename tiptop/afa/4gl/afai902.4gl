# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: afai902.4gl
# Descriptions...: 資產折舊費用開帳作業--財簽二
# Date & Author..: No:FUN-AB0088 11/04/12 By lixiang  固定資產財簽二功能
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60363 11/06/29 By yinhy 錯誤代碼'aoo-801'應改為'aoo-081'
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-BB0113 11/11/22 By xuxz      處理固資財簽二重測BUG
# Modify.........: No:FUN-BB0122 12/01/13 By Sakura 匯入財一資料Action移除
# Modify.........: No.MOD-BC0131 12/01/13 By Sakura 新增fbn20處理
# Modify.........: No.MOD-C20034 12/02/09 By Sakura 新增時fbn041不能修改

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_fbn       RECORD LIKE fbn_file.*,
       g_fbn_t     RECORD LIKE fbn_file.*,  #備份舊值
       g_fbn01_t   LIKE fbn_file.fbn01,     #Key備份
       g_fbn02_t   LIKE fbn_file.fbn02,
       g_fbn03_t   LIKE fbn_file.fbn03,
       g_fbn04_t   LIKE fbn_file.fbn04,
       g_fbn041_t  LIKE fbn_file.fbn041,
       g_fbn05_t   LIKE fbn_file.fbn05,
       g_fbn06_t   LIKE fbn_file.fbn06,
       g_wc        STRING,                  
       g_sql       STRING

DEFINE g_faj       RECORD   
                     faj1082 LIKE faj_file.faj1082                                                                                    
                   END RECORD                                                                                                       
DEFINE g_faj_t     RECORD  
                     faj1082 LIKE faj_file.faj1082                                                                                    
                   END RECORD                                                                                                       
DEFINE g_faj1082_t  LIKE faj_file.faj1082
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5         
DEFINE g_chr                 LIKE type_file.chr1 
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5 
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10 
DEFINE g_row_count           LIKE type_file.num10          
DEFINE g_jump                LIKE type_file.num10         
DEFINE mi_no_ask             LIKE type_file.num5         
DEFINE g_bookno1             LIKE aza_file.aza81    
DEFINE g_bookno2             LIKE aza_file.aza82    
DEFINE g_flag                LIKE type_file.chr1    

MAIN
   DEFINE p_row,p_col     LIKE type_file.num5

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

   IF g_faa.faa31='N' THEN CALL cl_err('','afa-260',1) EXIT PROGRAM END IF  #FUN-BB0113 add
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   INITIALIZE g_fbn.* TO NULL

   LET g_forupd_sql = "SELECT * FROM fbn_file WHERE fbn01 = ? AND fbn02 = ? AND fbn03 = ? AND fbn04 = ? AND fbn041 = ?",
                      " AND fbn05 = ? AND fbn06 = ? ",
                     " FOR UPDATE"
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE i902_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   LET p_row = 5 LET p_col = 10

   OPEN WINDOW i902_w AT p_row,p_col
     WITH FORM "afa/42f/afai902"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_init()

   LET g_action_choice = ""

   CALL i902_menu()

   CLOSE WINDOW i902_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 

END MAIN

FUNCTION i902_curs()
   DEFINE ls STRING

   CLEAR FORM

   INITIALIZE g_fbn.* TO NULL 

   CONSTRUCT BY NAME g_wc ON fbn041,fbn01,fbn02,fbn03,fbn04,fbn05,
                              fbn06,fbn09,fbn10,fbn13,fbn07,fbn08,
                              fbn14,fbn15,fbn17,fbn16,fbn11,fbn12,fbn20 #MOD-BC0131 add

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE
            WHEN INFIELD(fbn01)   #財產編號附號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_faj"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_fbn.fbn01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fbn01
               NEXT FIELD fbn01
            WHEN INFIELD(fbn06)  #部門編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_fbn.fbn06
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fbn06
               NEXT FIELD fbn06
            WHEN INFIELD(fbn09)  #被分攤部門
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_fbn.fbn09
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fbn09
               NEXT FIELD fbn09
            WHEN INFIELD(fbn11) # 資產會計科目查詢
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]'"
               LET g_qryparam.default1 = g_fbn.fbn11
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fbn11
               NEXT FIELD fbn11
            WHEN INFIELD(fbn12) # 折舊會計科目查詢
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]'"
               LET g_qryparam.default1 = g_fbn.fbn12
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fbn12
               NEXT FIELD fbn12
            WHEN INFIELD(fbn13) # 分攤類別查詢
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_fad1" 
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_fbn.fbn13
               LET g_qryparam.multiret_index = '2'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fbn13
               NEXT FIELD fbn13
            #MOD-BC0131---begin add
             WHEN INFIELD(fbn20) # 累折會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fbn.fbn20
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fbn20
                 NEXT FIELD fbn20            
            #MOD-BC0131---end add
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
     
   END CONSTRUCT

   LET g_sql = "SELECT * FROM fbn_file ",  #組合出 SQL 指令
               " WHERE ",g_wc CLIPPED, " ORDER BY fbn01"
   PREPARE i902_prepare FROM g_sql                   # RUNTIME 編譯
   DECLARE i902_cs                                 # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i902_prepare

   LET g_sql="SELECT COUNT(*) FROM fbn_file WHERE ",g_wc CLIPPED
   PREPARE i902_cntpre FROM g_sql
   DECLARE i902_count CURSOR FOR i902_cntpre

END FUNCTION

FUNCTION i902_menu()
   DEFINE l_cmd  LIKE type_file.chr1000 

   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i902_a()
         END IF

      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i902_q()
         END IF

      ON ACTION next
         CALL i902_fetch('N')

      ON ACTION previous
         CALL i902_fetch('P')

      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i902_u()
         END IF

      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
              CALL i902_r()
         END IF

      ON ACTION related_document    #No:MOD-470515
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
            IF g_fbn.fbn01 IS NOT NULL THEN
               LET g_doc.column1 = "fbn01|fbn05"
               LET g_doc.value1 = g_fbn.fbn01 CLIPPED, "|", g_fbn.fbn05
               LET g_doc.column2 = "fbn02|fbn06"
               LET g_doc.value2 = g_fbn.fbn02 CLIPPED, "|", g_fbn.fbn06
               LET g_doc.column3 = "fbn03"
               LET g_doc.value3 = g_fbn.fbn03
               LET g_doc.column4 = "fbn04"
               LET g_doc.value4 = g_fbn.fbn04
               LET g_doc.column5 = "fbn041"
               LET g_doc.value5 = g_fbn.fbn041
               CALL cl_doc()
            END IF
         END IF

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU

      ON ACTION jump
         CALL i902_fetch('/')

      ON ACTION first
         CALL i902_fetch('F')

      ON ACTION last
         CALL i902_fetch('L')
##FUN-BB0122--being mark
##FUN-B60140   ---start   Add
#      ON ACTION import_fin1
#         LET g_action_choice="import_fin1"
#         IF cl_chk_act_auth() THEN
#              CALL i902_import_fin1()
#         END IF
##FUN-B60140   ---start   Add
##FUN-BB0122--end mark
      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION about       
         CALL cl_about()   

      COMMAND KEY(INTERRUPT)
         LET INT_FLAG=FALSE 
         LET g_action_choice = "exit"
         EXIT MENU

      &include "qry_string.4gl"

   END MENU

   CLOSE i902_cs

END FUNCTION

FUNCTION i902_a()

   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位
   INITIALIZE g_fbn.* LIKE fbn_file.*
   LET g_fbn01_t = NULL
   LET g_wc = NULL
   LET g_fbn.fbn041 = '0'
   LET g_fbn.fbn03  = YEAR(g_today)
   LET g_fbn.fbn04  = MONTH(g_today)
   LET g_fbn.fbn05 = '1'
   LET g_fbn.fbn10 = '2'
   LET g_fbn.fbn07 = 0
   LET g_fbn.fbn08 = 0
   LET g_fbn.fbn14 = 0
   LET g_fbn.fbn15 = 0
   LET g_fbn.fbn16 = 100 
   LET g_fbn.fbn17 = 0   
   LET g_fbn.fbnlegal = g_legal
   LET g_fbn_t.* = g_fbn.*
   LET g_fbn01_t = NULL
   LET g_fbn02_t = NULL
   LET g_fbn03_t = NULL
   LET g_fbn04_t = NULL
   LET g_fbn041_t = NULL
   LET g_fbn05_t = NULL
   LET g_fbn06_t = NULL

   CALL cl_opmsg('a')

   CALL s_get_bookno(g_fbn.fbn03) RETURNING g_flag,g_bookno1,g_bookno2    

   IF g_flag= '1' THEN 
      #CALL cl_err(g_fbn.fbn03,'aoo-801',1) #No.TQC-B60363
      CALL cl_err(g_fbn.fbn03,'aoo-081',1)  #No.TQC-B60363
   END IF 

   WHILE TRUE
      CALL i902_i("a")                         
      IF INT_FLAG THEN                         
         INITIALIZE g_fbn.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF

      IF cl_null(g_fbn.fbn01) OR cl_null(g_fbn.fbn03) OR
         cl_null(g_fbn.fbn04) OR cl_null(g_fbn.fbn05) OR
         cl_null(g_fbn.fbn06) THEN              
         CONTINUE WHILE
      END IF

      INSERT INTO fbn_file VALUES(g_fbn.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","fbn_file",g_fbn.fbn01,g_fbn.fbn02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
          CONTINUE WHILE
      ELSE
         LET g_fbn_t.* = g_fbn.*              
         LET g_fbn01_t = g_fbn.fbn01
         LET g_fbn02_t = g_fbn.fbn02
         LET g_fbn03_t = g_fbn.fbn03
         LET g_fbn04_t = g_fbn.fbn04
         LET g_fbn041_t = g_fbn.fbn041
         LET g_fbn05_t = g_fbn.fbn05
         LET g_fbn06_t = g_fbn.fbn06
      END IF
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION i902_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,         #No.FUN-680070 CHAR(1)
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_fbn12       LIKE fad_file.fad03,
            l_n       LIKE type_file.num5         #No.FUN-680070 SMALLINT


   INPUT BY NAME  g_fbn.fbn041,g_fbn.fbn01,g_fbn.fbn02,g_fbn.fbn03,g_fbn.fbn04,g_fbn.fbn05, 
                  g_fbn.fbn06,g_fbn.fbn09,g_fbn.fbn10,g_fbn.fbn13,g_fbn.fbn07,
                  g_fbn.fbn08,g_fbn.fbn14,g_fbn.fbn15,
                  g_fbn.fbn17,g_faj.faj1082,g_fbn.fbn16,g_fbn.fbn11, 
                  g_fbn.fbn12,g_fbn.fbn20 WITHOUT DEFAULTS #MOD-BC0131 add fbn20
                  

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i902_set_entry(p_cmd)
          CALL i902_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

       AFTER FIELD fbn01
          IF NOT cl_null(g_fbn.fbn01) THEN
             SELECT COUNT(*) INTO g_cnt FROM faj_file
              WHERE faj02 = g_fbn.fbn01
             IF g_cnt = 0 THEN
                CALL cl_err(g_fbn.fbn01,'afa-902',0)
                NEXT FIELD fbn01
             END IF
          END IF

       AFTER FIELD fbn02
          IF cl_null(g_fbn.fbn02) THEN
             LET g_fbn.fbn02 = ' '
          END IF
          CALL i902_chkfaj(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,0)
             NEXT FIELD fbn02
          END IF

       AFTER FIELD fbn04  
         IF NOT cl_null(g_fbn.fbn04) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_fbn.fbn03
            IF g_azm.azm02 = 1 THEN
               IF g_fbn.fbn04 > 12 OR g_fbn.fbn04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD fbn04
               END IF
            ELSE
               IF g_fbn.fbn04 > 13 OR g_fbn.fbn04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD fbn04
               END IF
            END IF
         END IF

       AFTER FIELD fbn05
          IF NOT cl_null(g_fbn.fbn04) THEN
             IF g_fbn.fbn05 NOT MATCHES "[123]" THEN
                NEXT FIELD fbn05
             END IF
          END IF

       AFTER FIELD fbn06
          IF NOT cl_null(g_fbn.fbn06) THEN
             IF p_cmd = "a" OR                   
               (p_cmd = "u" AND (g_fbn.fbn01  != g_fbn01_t  OR
                                 g_fbn.fbn02  != g_fbn02_t  OR
                                 g_fbn.fbn03  != g_fbn03_t  OR
                                 g_fbn.fbn04  != g_fbn04_t  OR
                                 g_fbn.fbn041 != g_fbn041_t OR
                                 g_fbn.fbn05  != g_fbn05_t  OR
                                 g_fbn.fbn06  != g_fbn06_t )) THEN
                SELECT COUNT(*) INTO l_n FROM fbn_file
                 WHERE fbn01  = g_fbn.fbn01
                   AND fbn02  = g_fbn.fbn02
                   AND fbn03  = g_fbn.fbn03
                   AND fbn04  = g_fbn.fbn04
                   AND fbn041 = g_fbn.fbn041
                   AND fbn05  = g_fbn.fbn05
                   AND fbn06  = g_fbn.fbn06
                IF l_n > 0 THEN                  # Duplicated
                   CALL cl_err(g_fbn.fbn01,-239,0)
                   NEXT FIELD fbn01
                END IF
             END IF
             CALL i902_chkgem(p_cmd,g_fbn.fbn06,'1')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fbn.fbn06,g_errno,0)
                NEXT FIELD fbn06
             END IF
          END IF

       AFTER FIELD fbn10
          IF NOT cl_null(g_fbn.fbn09) THEN
             IF g_fbn.fbn10 NOT MATCHES "[XC01234789]" THEN
                NEXT FIELD fbn10
             END IF
          END IF
 
       AFTER FIELD fbn09
          IF NOT cl_null(g_fbn.fbn09) THEN
             CALL i902_chkgem(p_cmd,g_fbn.fbn09,'2')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fbn.fbn09,g_errno,0)
                NEXT FIELD fbn09
             END IF
          END IF

       AFTER FIELD fbn13
          IF NOT cl_null(g_fbn.fbn13) THEN
             SELECT COUNT(*) INTO l_n FROM fad_file
              WHERE fad04 = g_fbn.fbn13
                AND fadacti = 'Y'
                AND fad07='2'
             IF l_n = 0 THEN
                CALL cl_err(g_fbn.fbn13,'afa-342',0)
                NEXT FIELD fbn13
             END IF
          END IF
          IF g_fbn.fbn05 ='1' THEN
             LET g_fbn.fbn13 = ' '
             DISPLAY BY NAME g_fbn.fbn13
          ELSE
             IF cl_null(g_fbn.fbn13) THEN NEXT FIELD fbn13 END IF
          END IF

       AFTER FIELD fbn07
          IF NOT cl_null(g_fbn.fbn07) THEN
             IF g_fbn.fbn07 < 0 THEN   #No:8547
                CALL cl_err(g_fbn.fbn07,'afa-037',0)
                NEXT FIELD fbn07
             END IF
          END IF

       AFTER FIELD fbn08
          IF NOT cl_null(g_fbn.fbn08) THEN
             IF g_fbn.fbn08 <= 0 THEN
                CALL cl_err(g_fbn.fbn08,'afa-037',0)
                NEXT FIELD fbn08
             END IF
          END IF

       AFTER FIELD fbn14
          IF NOT cl_null(g_fbn.fbn14) THEN
             IF g_fbn.fbn14 <= 0 THEN
                CALL cl_err(g_fbn.fbn14,'afa-037',0)
                NEXT FIELD fbn14
             END IF
          END IF

       AFTER FIELD fbn15
          IF NOT cl_null(g_fbn.fbn15) THEN
             IF g_fbn.fbn15 <= 0 THEN              #No:A099
                CALL cl_err(g_fbn.fbn15,'afa-037',0)
                NEXT FIELD fbn15
             END IF
          END IF

       AFTER FIELD fbn17
          IF NOT cl_null(g_fbn.fbn17) THEN
             #IF g_fbn.fbn17 <= 0 THEN   #MOD-7C0175
             IF g_fbn.fbn17 < 0 THEN   #MOD-7C0175
                #CALL cl_err(g_fbn.fbn17,'afa-037',0)   #MOD-7C0175
                CALL cl_err(g_fbn.fbn17,'mfg5034',0)   #MOD-7C0175
                NEXT FIELD fbn17
             END IF
          END IF
          CALL i902_set_no_entry(p_cmd)

       AFTER FIELD faj1082                                                                                                           
          IF NOT cl_null(g_faj.faj1082) THEN                                                                                         
             IF g_faj.faj1082 < 0 THEN                                                                                               
                CALL cl_err(g_faj.faj1082,'afa-037',0)                                                                               
                NEXT FIELD faj1082                                                                                                   
             END IF                                                                                                                 
             IF g_faj.faj1082 > g_fbn.fbn15 THEN                                                                                     
                CALL cl_err(g_faj.faj1082,'afa-925',0)                                                                               
                NEXT FIELD faj1082                                                                                                   
             END IF                                                                                                                 
          END IF                                                                                                                    

       AFTER FIELD fbn16
           IF g_fbn.fbn16 <0  OR g_fbn.fbn16> 100 THEN      #No:8547
              NEXT FIELD fbn16
           END IF
           IF g_fbn.fbn05 = '1' THEN
              LET g_fbn.fbn16 = 100          #No:8547
              DISPLAY BY NAME g_fbn.fbn16
           END IF

       AFTER FIELD fbn11
           IF NOT cl_null(g_fbn.fbn11) THEN
              CALL i902_chkaag(p_cmd,g_fbn.fbn11,'1',g_faa.faa02c)    #No.FUN-740026
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) NEXT FIELD fbn11
              END IF
           END IF

       AFTER FIELD fbn12
           IF NOT cl_null(g_fbn.fbn12) THEN
              CALL i902_chkaag(p_cmd,g_fbn.fbn12,'2',g_faa.faa02c) 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) NEXT FIELD fbn12
              END IF
           END IF

       #MOD-BC0131---begin add
       AFTER FIELD fbn20
            IF NOT cl_null(g_fbn.fbn20) THEN
               CALL i902_chkaag(p_cmd,g_fbn.fbn20,'5',g_bookno1)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_fbn.fbn20
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_bookno1
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2')  AND aagacti='Y' AND aag01 LIKE '",g_fbn.fbn12 CLIPPED,"%' "
                  CALL cl_create_qry() RETURNING g_fbn.fbn20
                  DISPLAY BY NAME g_fbn.fbn20
                  NEXT FIELD fbn20
               END IF
            END IF       
       #MOD-BC0131---end add

      AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
          IF g_fbn.fbn02 IS NULL THEN
             LET g_fbn.fbn02 = ' '
          END IF
          IF g_fbn.fbn05 ='1' THEN
             LET g_fbn.fbn13 = ' '
             LET g_fbn.fbn16 = 100     #No:8547
             DISPLAY BY NAME g_fbn.fbn13,g_fbn.fbn16
          END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(fbn01)   #財產編號附號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_faj"
               LET g_qryparam.default1 = g_fbn.fbn01
               CALL cl_create_qry() RETURNING g_fbn.fbn01,g_fbn.fbn02
               DISPLAY BY NAME g_fbn.fbn01,g_fbn.fbn02
               NEXT FIELD fbn01
            WHEN INFIELD(fbn06)  #部門編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_fbn.fbn06
               CALL cl_create_qry() RETURNING g_fbn.fbn06
               DISPLAY BY NAME g_fbn.fbn06
               NEXT FIELD fbn06
            WHEN INFIELD(fbn09)  #被分攤部門
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_fbn.fbn09
               CALL cl_create_qry() RETURNING g_fbn.fbn09
               DISPLAY BY NAME g_fbn.fbn09
               NEXT FIELD fbn09
            WHEN INFIELD(fbn11) # 資產會計科目查詢
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]'"
               LET g_qryparam.default1 = g_fbn.fbn11
               LET g_qryparam.arg1 = g_faa.faa02c               #No.FUN-740026
               CALL cl_create_qry() RETURNING g_fbn.fbn11
               DISPLAY BY NAME g_fbn.fbn11
               NEXT FIELD fbn11
            WHEN INFIELD(fbn12) # 折舊會計科目查詢
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]'"
               LET g_qryparam.default1 = g_fbn.fbn12
               LET g_qryparam.arg1 = g_faa.faa02c               #No.FUN-740026
               CALL cl_create_qry() RETURNING g_fbn.fbn12
               DISPLAY BY NAME g_fbn.fbn12
               NEXT FIELD fbn12
            WHEN INFIELD(fbn13) # 分攤類別查詢
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_fad1"  #No.TQC-6C0009
               LET g_qryparam.default1 = g_fbn.fbn13
               CALL cl_create_qry() RETURNING g_fbn.fbn13  #No.TQC-6C0009
               DISPLAY BY NAME g_fbn.fbn13
               NEXT FIELD fbn13
            #MOD-BC0131---begin add
            WHEN INFIELD(fbn20) # 累折會計科目查詢
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
               LET g_qryparam.default1 = g_fbn.fbn20
               LET g_qryparam.arg1 = g_bookno1
               CALL cl_create_qry() RETURNING g_fbn.fbn20
               DISPLAY BY NAME g_fbn.fbn20
               NEXT FIELD fbn20            
            #MOD-BC0131---end add            
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()    
 
      ON ACTION help        
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION

FUNCTION i902_chkfaj(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,
       l_faj06    LIKE faj_file.faj06,
       l_faj061   LIKE faj_file.faj061,
       l_faj432   LIKE faj_file.faj432

     LET g_errno = ' '
     SELECT faj06,faj061,faj432 INTO l_faj06,l_faj061,l_faj432
       FROM faj_file
      WHERE faj02 = g_fbn.fbn01 AND faj022 = g_fbn.fbn02
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9329'
                                LET l_faj06 = NULL
                                LET l_faj061= NULL
       WHEN l_faj432 MATCHES '[056]'  LET g_errno = 'afa-137'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_faj06  TO FORMONLY.faj06
        DISPLAY l_faj061 TO FORMONLY.faj061
     END IF
END FUNCTION

FUNCTION i902_chkgem(p_cmd,p_gem,p_type)
DEFINE
      p_gem      LIKE gem_file.gem01,
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 CHAR(01)
      p_type     LIKE type_file.chr1,         #No.FUN-680070 CHAR(01)
      l_gem01    LIKE gem_file.gem01,
      l_gem02    LIKE gem_file.gem02,
      l_gemacti  LIKE gem_file.gemacti

     LET g_errno = ' '
     SELECT gem01,gem02,gemacti INTO l_gem01,l_gem02,l_gemacti
       FROM gem_file
      WHERE gem01 = p_gem
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gem02 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N' LET g_errno = '9028'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
        IF p_type = '1' THEN
           DISPLAY l_gem02 TO FORMONLY.gem02_1
        ELSE
           DISPLAY l_gem02 TO FORMONLY.gem02_2
        END IF
     END IF
END FUNCTION

FUNCTION i902_chkaag(p_cmd,p_key,p_type,p_bookno)
DEFINE  l_aagacti  LIKE aag_file.aagacti,
        l_aag02    LIKE aag_file.aag02,
        l_aag03    LIKE aag_file.aag03,
        l_aag07    LIKE aag_file.aag07,
        p_cmd      LIKE type_file.chr1,         #No.FUN-680070 CHAR(01)
        p_type     LIKE type_file.chr1,         #No.FUN-680070 CHAR(01)
        p_key      LIKE aag_file.aag01
DEFINE  p_bookno   LIKE aag_file.aag00          #No.FUN-640026

    LET g_errno = " "
    SELECT aag02,aag03,aag07,aagacti
      INTO l_aag02,l_aag03,l_aag07,l_aagacti
      FROM aag_file
     WHERE aag01 = p_key
     AND aag00 = p_bookno           #No.FUN-740026

    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                  LET l_aag02 = NULL
                                  LET l_aagacti = NULL
         WHEN l_aagacti='N'       LET g_errno = '9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         WHEN l_aag03 != '2'      LET g_errno = 'agl-201'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       IF p_type = '1' THEN
          DISPLAY l_aag02 TO FORMONLY.aag02_1
       ELSE
          DISPLAY l_aag02 TO FORMONLY.aag02_2
       END IF
    END IF
END FUNCTION

FUNCTION i902_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_fbn.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i902_curs()                     
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i902_count
    FETCH i902_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i902_cs                          
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fbn.fbn01,SQLCA.sqlcode,0)
       INITIALIZE g_fbn.* TO NULL
    ELSE
       CALL i902_fetch('F')             
    END IF

END FUNCTION

FUNCTION i902_fetch(p_flfbn)
    DEFINE p_flfbn    LIKE type_file.chr1  

    CASE p_flfbn
        WHEN 'N' FETCH NEXT     i902_cs INTO g_fbn.*
        WHEN 'P' FETCH PREVIOUS i902_cs INTO g_fbn.*
        WHEN 'F' FETCH FIRST    i902_cs INTO g_fbn.*
        WHEN 'L' FETCH LAST     i902_cs INTO g_fbn.*
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about        
                     CALL cl_about()     
                 
                  ON ACTION help         
                     CALL cl_show_help() 
                 
                  ON ACTION controlg     
                     CALL cl_cmdask()    
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i902_cs INTO g_fbn.*
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbn.fbn01,SQLCA.sqlcode,0)
        INITIALIZE g_fbn.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flfbn
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF

    SELECT * INTO g_fbn.* FROM fbn_file    
          WHERE fbn01  = g_fbn.fbn01
            AND fbn02  = g_fbn.fbn02
            AND fbn03  = g_fbn.fbn03
            AND fbn04  = g_fbn.fbn04
            AND fbn041 = g_fbn.fbn041
            AND fbn05  = g_fbn.fbn05
            AND fbn06  = g_fbn.fbn06
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fbn_file",g_fbn.fbn01,g_fbn.fbn02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        CALL i902_show()                   
    END IF

END FUNCTION

FUNCTION i902_show()

   SELECT faj1082 INTO g_faj.faj1082                                                                                                  
     FROM faj_file                                                                                                                  
    WHERE faj02  = g_fbn.fbn01                                                                                                      
      AND faj022 = g_fbn.fbn02                                                                                                      

   LET g_faj_t.faj1082 = g_faj.faj1082                                                                                                
                                
   LET g_fbn_t.* = g_fbn.*

   DISPLAY BY NAME g_fbn.fbn01,g_fbn.fbn02,g_fbn.fbn03,g_fbn.fbn04,g_fbn.fbn041,
                   g_fbn.fbn05,g_fbn.fbn06,g_fbn.fbn09,g_fbn.fbn10,g_fbn.fbn13,
                   g_fbn.fbn07,g_fbn.fbn08,g_fbn.fbn14,g_fbn.fbn15,g_fbn.fbn16,
                   g_fbn.fbn11,g_fbn.fbn12,g_fbn.fbn17,g_faj.faj1082,g_fbn.fbn20 #MOD-BC0131 add fbn20 

   CALL s_get_bookno(g_fbn.fbn03) RETURNING g_flag,g_bookno1,g_bookno2    

   IF g_flag= '1' THEN  #
      #CALL cl_err(g_fbn.fbn03,'aoo-801',1)  #No.TQC-B60363
      CALL cl_err(g_fbn.fbn03,'aoo-081',1)   #No.TQC-B60363
   END IF 

   CALL i902_chkaag('d',g_fbn.fbn11,'1',g_faa.faa02c)  
   CALL i902_chkaag('d',g_fbn.fbn12,'2',g_faa.faa02c) 
   CALL i902_chkgem('d',g_fbn.fbn06,'1')
   CALL i902_chkgem('d',g_fbn.fbn09,'2')
   CALL i902_chkfaj('d')

   CALL cl_show_fld_cont()  

END FUNCTION

FUNCTION i902_u()

   IF g_fbn.fbn01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_fbn.fbn041 <> '0' THEN
      CALL cl_err(g_fbn.fbn01,'afa-136',0)
      RETURN
   END IF

   MESSAGE ""

   CALL cl_opmsg('u')
   LET g_fbn01_t = g_fbn.fbn01
   LET g_success = 'Y'
   BEGIN WORK

   OPEN i902_cl USING g_fbn.fbn01,g_fbn.fbn02,g_fbn.fbn03,g_fbn.fbn04,g_fbn.fbn041,g_fbn.fbn05,g_fbn.fbn06
   IF STATUS THEN
      CALL cl_err("OPEN i902_cl:", STATUS, 1)
      CLOSE i902_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i902_cl INTO g_fbn.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbn.fbn01,SQLCA.sqlcode,1)
      RETURN
   END IF

   CALL i902_show()                          

   LET g_fbn_t.* = g_fbn.*
   LET g_faj_t.faj1082 = g_faj.faj1082        #No.TQC-690099       
   LET g_fbn01_t = g_fbn.fbn01
   LET g_fbn02_t = g_fbn.fbn02
   LET g_fbn03_t = g_fbn.fbn03
   LET g_fbn04_t = g_fbn.fbn04
   LET g_fbn041_t= g_fbn.fbn041
   LET g_fbn05_t = g_fbn.fbn05
   LET g_fbn06_t = g_fbn.fbn06
   LET g_faj1082_t= g_faj.faj1082             #No.TQC-690099       

   WHILE TRUE
      CALL i902_i("u")                     
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_fbn.*=g_fbn_t.*
         LET g_faj.faj1082=g_faj_t.faj1082   #No.TQC-690099        
         CALL i902_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_fbn.fbn01) THEN
         CONTINUE WHILE
      END IF

      UPDATE fbn_file SET fbn_file.* = g_fbn.*    
          WHERE fbn01  = g_fbn.fbn01
            AND fbn02  = g_fbn.fbn02
            AND fbn03  = g_fbn.fbn03
            AND fbn04  = g_fbn.fbn04
            AND fbn041 = g_fbn.fbn041
            AND fbn05  = g_fbn.fbn05
            AND fbn06  = g_fbn.fbn06
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","fbn_file",g_fbn01_t,g_fbn02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660136
         CONTINUE WHILE
      END IF

      UPDATE faj_file SET faj1082 = g_faj.faj1082                                                                                    
       WHERE faj02  = g_fbn.fbn01                                                                                                  
         AND faj022 = g_fbn.fbn02                                                                                                  

      EXIT WHILE                                                                                                                   
      IF SQLCA.sqlerrd[3]=0 THEN                                                                                                   
         CALL cl_err3("upd","faj_file",g_fbn01_t,g_fbn02_t,SQLCA.sqlcode,"","",1)                                                    
         CONTINUE WHILE                                                                                                            
      END IF                                                                                                                       

      EXIT WHILE
   END WHILE

   CLOSE i902_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

END FUNCTION

FUNCTION i902_r()

   IF g_fbn.fbn01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_fbn.fbn041 <> '0' THEN
      CALL cl_err(g_fbn.fbn01,'afa-136',0)
      RETURN
   END IF

   LET g_success = 'Y'
   BEGIN WORK

   OPEN i902_cl USING g_fbn.fbn01,g_fbn.fbn02,g_fbn.fbn03,g_fbn.fbn04,g_fbn.fbn041,g_fbn.fbn05,g_fbn.fbn06
   IF STATUS THEN
      CALL cl_err("OPEN i902_cl:", STATUS, 0)
      CLOSE i902_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i902_cl INTO g_fbn.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbn.fbn01,SQLCA.sqlcode,0)
      RETURN
   END IF

   CALL i902_show()

   IF cl_delete() THEN
      INITIALIZE g_doc.* TO NULL                               
      LET g_doc.column1 = "fbn01|fbn05"                        
      LET g_doc.value1 = g_fbn.fbn01 CLIPPED, "|", g_fbn.fbn05 
      LET g_doc.column2 = "fbn02|fbn06"                        
      LET g_doc.value2 = g_fbn.fbn02 CLIPPED, "|", g_fbn.fbn06 
      LET g_doc.column3 = "fbn03"                              
      LET g_doc.value3 = g_fbn.fbn03                           
      LET g_doc.column4 = "fbn04"                              
      LET g_doc.value4 = g_fbn.fbn04                           
      LET g_doc.column5 = "fbn041"                             
      LET g_doc.value5 = g_fbn.fbn041                          
      CALL cl_del_doc()                                        

      DELETE FROM fbn_file WHERE fbn01  = g_fbn.fbn01
                             AND fbn02  = g_fbn.fbn02
                             AND fbn03  = g_fbn.fbn03
                             AND fbn04  = g_fbn.fbn04
                             AND fbn041 = g_fbn.fbn041
                             AND fbn05  = g_fbn.fbn05
                             AND fbn06  = g_fbn.fbn06
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","fbn_file",g_fbn.fbn01,g_fbn.fbn02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
      ELSE
         CLEAR FORM
         OPEN i902_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i902_cs
             CLOSE i902_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i902_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i902_cs
             CLOSE i902_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i902_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i902_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i902_fetch('/')
         END IF
      END IF
   END IF

   CLOSE i902_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

END FUNCTION

FUNCTION i902_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1  

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fbn01,fbn02,fbn03,fbn04,fbn05,fbn06",TRUE) #No.MOD-C20034 fbn041 delete
   END IF

   IF INFIELD(fbn17) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fbn17",TRUE)
   END IF

END FUNCTION

FUNCTION i902_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("fbn01,fbn02,fbn03,fbn04,fbn05,fbn06",FALSE) #No.MOD-C20034 fbn041 delete
   END IF

END FUNCTION
#No:FUN-AB0088

##-----No:FUN-BB0122-----being mark
##-----No:FUN-B60140-----
#FUNCTION i902_import_fin1()
#  DEFINE l_fan  RECORD LIKE fan_file.*
#  DEFINE l_sql    STRING
#  DEFINE l_cnt    LIKE type_file.num5
#  DEFINE tm RECORD
#         wc       STRING,
#         fan03    LIKE fan_file.fan03,
#         fan04    LIKE fan_file.fan04
#         END RECORD
#  DEFINE l_i      LIKE type_file.num5
#  DEFINE p_row,p_col LIKE type_file.num5

#  LET p_row = 5 LET p_col = 11

#  OPEN WINDOW i902_g AT p_row,p_col WITH FORM "afa/42f/afai902g"
#    ATTRIBUTE (STYLE = g_win_style CLIPPED)

#  CALL cl_ui_locale("afai902g")

#  WHILE TRUE
#     CONSTRUCT BY NAME tm.wc ON fan01,fan02

#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT

#        ON ACTION about
#           CALL cl_about()

#        ON ACTION help
#           CALL cl_show_help()

#        ON ACTION controlg
#           CALL cl_cmdask()

#     END CONSTRUCT

#     IF tm.wc = " 1=1" THEN
#        CALL cl_err("","abm-997",1)
#        CONTINUE WHILE
#     END IF

#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW i902_g
#        RETURN
#     END IF

#    INPUT BY NAME tm.fan03,tm.fan04

#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT

#       ON ACTION about
#          CALL cl_about()

#       ON ACTION help
#          CALL cl_show_help()

#       ON ACTION controlg
#          CALL cl_cmdask()
#    END INPUT

#    IF INT_FLAG THEN
#       LET INT_FLAG = 0
#       CLOSE WINDOW i902_g
#       RETURN
#    END IF

#    CLOSE WINDOW i902_g

#    EXIT WHILE

#  END WHILE

#  LET g_success = 'Y'

#  BEGIN WORK

#  LET l_sql = "SELECT * FROM fan_file ",
#              " WHERE fan03 = ",tm.fan03,
#              "   AND fan04 = ",tm.fan04,
#              "   AND ",tm.wc
#  PREPARE fan_pre  FROM l_sql
#  DECLARE fan_cur CURSOR FOR fan_pre

#  CALL s_showmsg_init()

#  LET l_i = 0

#  FOREACH fan_cur INTO l_fan.*
#    IF g_success = "N" THEN
#       LET g_totsuccess = "N"
#       LET g_success = "Y"
#    END IF

#    LET l_cnt = 0

#    SELECT COUNT(*) INTO l_cnt
#      FROM fbn_file
#     WHERE fbn01 = l_fan.fan01
#       AND fbn02 = l_fan.fan02

#    IF l_cnt <> 0 THEN
#       LET g_showmsg=l_fan.fan01,"/",l_fan.fan02
#       CALL s_errmsg("fan01,fan02",g_showmsg,"SEL fbn_file","mfg-240",1)
#       CONTINUE FOREACH
#    ELSE
#       CALL i902_ins_fbn(l_fan.*)
#       LET l_i = l_i + 1
#    END IF

#  END FOREACH

#  IF g_totsuccess="N" THEN
#     LET g_success="N"
#  END IF

#  CALL s_showmsg()

#  IF g_success = 'Y' THEN
#     COMMIT WORK
#     CALL cl_err(l_i,'anm-905',1)
#  ELSE
#     ROLLBACK WORK
#  END IF

#END FUNCTION

#FUNCTION i902_ins_fbn(l_fan)
#  DEFINE l_fan    RECORD LIKE fan_file.*
#  DEFINE l_fbn    RECORD LIKE fbn_file.*

#  WHENEVER ERROR CONTINUE

#  INITIALIZE l_fbn.* TO NULL

#  LET l_fbn.fbn01 = l_fan.fan01
#  LET l_fbn.fbn02 = l_fan.fan02
#  LET l_fbn.fbn03 = l_fan.fan03
#  LET l_fbn.fbn04 = l_fan.fan04
#  LET l_fbn.fbn041= '0'
#  LET l_fbn.fbn05 = l_fan.fan05
#  LET l_fbn.fbn06 = l_fan.fan06
#  LET l_fbn.fbn07 = l_fan.fan07
#  LET l_fbn.fbn08 = l_fan.fan08
#  LET l_fbn.fbn09 = l_fan.fan09
#  LET l_fbn.fbn10 = l_fan.fan10
#  LET l_fbn.fbn11 = l_fan.fan11
#  LET l_fbn.fbn12 = l_fan.fan12
#  LET l_fbn.fbn13 = l_fan.fan13
#  LET l_fbn.fbn14 = l_fan.fan14
#  LET l_fbn.fbn15 = l_fan.fan15
#  LET l_fbn.fbn16 = l_fan.fan16
#  LET l_fbn.fbn17 = l_fan.fan17
#  LET l_fbn.fbn19 = ''

#  INSERT INTO fbn_file VALUES(l_fbn.*)
#  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     LET g_showmsg=l_fbn.fbn01,"/",l_fbn.fbn02
#     CALL s_errmsg("fbn01,fbn02",g_showmsg,"INS fbn_file",SQLCA.sqlcode,1)
#     LET g_success = 'N'
#  END IF

#END FUNCTION
##-----No:FUN-B60140 END-----
##-----No:FUN-BB0122-----end mark                                                            
