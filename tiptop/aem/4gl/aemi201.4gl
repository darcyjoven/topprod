# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aemi201.4gl
# Descriptions...: 設備保修工作日報維護作業
# Date & Author..: 04/07/19 By Elva
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.MOD-540141 05/04/20 By vivien  刪除HELP FILE
# Modify.........: No.FUN-550024 05/05/20 By Trisy 單據編號加大
# Modify.........: No.FUN-580002 05/08/01 By Carrier 程序compile有問題
# Modify.........: NO.TQC-630269 06/03/31 BY yiting 傳入單據性質錯誤
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.MOD-670140 06/07/31 By day 新增工單號后不顯示設備編號及說明
# Modify.........: No.FUN-680072 06/08/25 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0050 06/11/14 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/25 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.FUN-980002 09/08/20 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:TQC-C40252 修改新增狀態sub-144的錯
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-BB0235 13/01/28 By Alberti 修改串aemi201時，按新增會出現sub-144的錯


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fin           RECORD LIKE fin_file.*,
    g_fin01_t       LIKE fin_file.fin01,
    g_fin02_t       LIKE fin_file.fin02,
    g_fin03_t       LIKE fin_file.fin03,
    g_fin04_t       LIKE fin_file.fin04,
    g_fin_t         RECORD LIKE fin_file.*,
    #g_wc,g_sql     VARCHAR(1000),           #TQC-630166 
    g_wc,g_sql      STRING,           #TQC-630166     
    g_argv1         LIKE fin_file.fin01,
    g_argv2         LIKE fin_file.fin02
DEFINE   g_forupd_sql STRING           #SELECT ... FOR UPDATE SQL 
DEFINE   g_before_input_done  LIKE type_file.num5     #No.FUN-680072 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03        #No.FUN-680072CHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680072 SMALLINT
#        l_time        LIKE type_file.chr8              #No.FUN-6A0068
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
    INITIALIZE g_fin.* TO NULL
    INITIALIZE g_fin_t.* TO NULL
    LET g_forupd_sql = "SELECT * FROM fin_file WHERE fin01= ? AND fin02=? AND fin03=? AND fin04=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i201_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
 
    LET p_row = 6 LET p_col = 25
    OPEN WINDOW aemi201_w AT p_row,p_col
        WITH FORM "aem/42f/aemi201" ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_argv1) THEN
       CALL i201_q()
    END IF
 
    LET g_action_choice = ""
    CALL i201_menu()
 
    CLOSE WINDOW aemi201_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
END MAIN
 
 
FUNCTION i201_curs()
    CLEAR FORM
 
    IF NOT cl_null(g_argv1)  THEN
       LET g_wc =" fin01 = '",g_argv1, "' AND fin02 = '",g_argv2,"'"
       LET g_sql="SELECT fin01,fin02,fin03,fin04 FROM fin_file ", # 組合出 SQL 指令
                 " WHERE ",g_wc CLIPPED,
                 " ORDER BY fin01,fin02,fin03,fin04 "
    ELSE
   INITIALIZE g_fin.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           fin01,fin02,fin03,fin04,fin05,fin06,fin07,fin08,
           fin09,fin10,fin11,
           #FUN-840068   ---start---
           finud01,finud02,finud03,finud04,finud05,
           finud06,finud07,finud08,finud09,finud10,
           finud11,finud12,finud13,finud14,finud15
           #FUN-840068    ----end----
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(fin01)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_fil"
                      LET g_qryparam.default1 = g_fin.fin01
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO fin01
                      NEXT FIELD fin01
                 WHEN INFIELD(fin02)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_fim"
                      LET g_qryparam.default1 = g_fin.fin02
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO fin02
                      NEXT FIELD fin02
                 WHEN INFIELD(fin03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_fix"
                      LET g_qryparam.default1 = g_fin.fin03
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO fin03
                      NEXT FIELD fin03
                 WHEN INFIELD(fin04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_trx"
                      LET g_qryparam.default1 = g_fin.fin04
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO fin04
                      NEXT FIELD fin04
                 WHEN INFIELD(fin05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gem"
                      LET g_qryparam.state = "c"
                      LET g_qryparam.default1 = g_fin.fin05
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO fin05
                      NEXT FIELD fin05
                 #-----TQC-B90211---------
                 #WHEN INFIELD(fin06)
                 #     CALL cl_init_qry_var()
                 #     LET g_qryparam.form ="q_cpe"
                 #     LET g_qryparam.state = "c"
                 #     LET g_qryparam.default1 = g_fin.fin06
                 #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                 #     DISPLAY g_qryparam.multiret TO fin06
                 #     NEXT FIELD fin06
                 #-----END TQC-B90211-----
                 OTHERWISE
                    EXIT CASE
              END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('finuser', 'fingrup') #FUN-980030
       IF INT_FLAG THEN RETURN END IF
       LET g_sql="SELECT fin01,fin02,fin03,fin04 FROM fin_file ", # 組合出 SQL 指令
                 " WHERE ",g_wc CLIPPED,
                 " ORDER BY fin01,fin02,fin03,fin04"
    END IF
    PREPARE i201_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i201_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i201_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM fin_file WHERE ",g_wc CLIPPED
    PREPARE i201_precount FROM g_sql
    DECLARE i201_count CURSOR FOR i201_precount
END FUNCTION
 
 
FUNCTION i201_menu()
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-680072 VARCHAR(100) 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i201_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i201_q()
            END IF
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i201_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i201_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i201_copy()
            END IF
#        ON ACTION output
#            LET g_action_choice="output"
#            IF cl_chk_act_auth() THEN
#                 CALL i201_out()
#            END IF
        ON ACTION next
            CALL i201_fetch('N')
        ON ACTION previous
            CALL i201_fetch('P')
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i201_fetch('/')
        ON ACTION first
            CALL i201_fetch('F')
        ON ACTION last
            CALL i201_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            EXIT MENU
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6B0050-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_fin.fin01 IS NOT NULL THEN
                  LET g_doc.column1 = "fin01"
                  LET g_doc.column2 = "fin02"
                  LET g_doc.value1 = g_fin.fin01
                  LET g_doc.value2 = g_fin.fin02
              CALL cl_doc()                            
               END IF                                        
            END IF                                           
         #No.FUN-6B0050-------add--------end----
          CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i201_cs
END FUNCTION
 
FUNCTION i201_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i201_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i201_cs                              # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN 
        CALL cl_err(g_fin.fin01,SQLCA.sqlcode,0)
        INITIALIZE g_fin.* TO NULL
    ELSE
        OPEN i201_count
        FETCH i201_COUNT INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i201_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i201_a()
     DEFINE  l_time LIKE type_file.chr8    
 
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
 
    INITIALIZE g_fin.* LIKE fin_file.*
    LET g_fin01_t = NULL
    IF NOT cl_null(g_argv1) THEN
       LET g_fin.fin01=g_argv1
       LET g_fin.fin02=g_argv2
       CALL i201_fin01('a')
       CALL i201_fin02('a')
    END IF
    CALL cl_opmsg('a')
 
    LET l_time =TIME
    LET g_fin.fin07=g_today
    LET g_fin.fin08=l_time[1,2],l_time[4,5]
    LET g_fin.fin09=g_today
    LET g_fin.fin10=l_time[1,2],l_time[4,5]
    LET g_fin.fin11=0
    WHILE TRUE
        CALL i201_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_fin.fin01 IS NULL OR g_fin.fin02 IS NULL        # KEY 不可空白
        OR g_fin.fin03 IS NULL OR g_fin.fin04 IS NULL THEN
            CONTINUE WHILE
        END IF
        LET g_fin.finplant = g_plant #FUN-980002
        LET g_fin.finlegal = g_legal #FUN-980002
        LET g_fin.finoriu = g_user      #No.FUN-980030 10/01/04
        LET g_fin.finorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO fin_file VALUES(g_fin.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fin.fin01,SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("ins","fin_file",g_fin.fin01,g_fin.fin02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
            CONTINUE WHILE
        ELSE
            LET g_fin_t.* = g_fin.*                # 保存上筆資料
            SELECT fin01,fin02,fin03,fin04 INTO g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04 FROM fin_file
             WHERE fin01 = g_fin.fin01 AND fin02 = g_fin.fin02
               AND fin03 = g_fin.fin03 AND fin04 = g_fin.fin04
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i201_i(p_cmd)
    DEFINE   li_result   LIKE type_file.num5          #No.FUN-550024        #No.FUN-680072 SMALLINT
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
        l_input         LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680072 SMALLINT
 
    INPUT BY NAME   g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04,
                    g_fin.fin05,g_fin.fin06,g_fin.fin07,g_fin.fin08,
                    g_fin.fin09,g_fin.fin10,g_fin.fin11,
                    #FUN-840068     ---start---
                    g_fin.finud01,g_fin.finud02,g_fin.finud03,g_fin.finud04,
                    g_fin.finud05,g_fin.finud06,g_fin.finud07,g_fin.finud08,
                    g_fin.finud09,g_fin.finud10,g_fin.finud11,g_fin.finud12,
                    g_fin.finud13,g_fin.finud14,g_fin.finud15 
                    #FUN-840068     ----end----
                    WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i201_set_entry(p_cmd)
            CALL i201_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         #No.FUN-550024 --start--
         CALL cl_set_docno_format("fin01")
         #No.FUN-550024 ---end---
 
        AFTER FIELD fin01
         #No.FUN-550024 --start--
         #IF NOT cl_null(g_fin.fin01) THEN                        #MOD-BB0235 mark
         IF NOT cl_null(g_fin.fin01) AND cl_null(g_argv1) THEN   #MOD-BB0235 add
            #CALL s_check_no("aem",g_fin.fin01,g_fin01_t,"*","fin_file","fin01","")
        #TQC-C40252--mark--start--
        #   CALL s_check_no("aem",g_fin.fin01,g_fin01_t,"1","fin_file","fin01","")  #NO.TQC-630269
        #   RETURNING li_result,g_fin.fin01
        #   DISPLAY BY NAME g_fin.fin01
        #   IF (NOT li_result) THEN
        #      LET g_fin.fin01=g_fin_t.fin01
        #      NEXT FIELD fin01
        #   END IF
        #TQC-C40252--mark--end--
            #No.MOD-670140--begin
            CALL i201_fin01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fin.fin01,g_errno,0)
               LET g_fin.fin01 = g_fin01_t
               DISPLAY BY NAME g_fin.fin01
               NEXT FIELD fin01
            END IF
            #No.MOD-670140--end
         END IF
 
         #No.FUN-550024 ---end---
 
        AFTER FIELD fin02
            IF NOT cl_null(g_fin.fin02) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_fin.fin02 != g_fin_t.fin02) THEN
                  CALL i201_fin02('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fin.fin02,g_errno,0)
                     LET g_fin.fin02 = g_fin_t.fin02
                     DISPLAY BY NAME g_fin.fin02
                     NEXT FIELD fin01
                  END IF
               END IF
            END IF
 
       AFTER FIELD fin03
           IF NOT cl_null(g_fin.fin03) THEN
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND g_fin.fin03 != g_fin_t.fin03) THEN
                 CALL i201_fin03('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fin.fin03,g_errno,0)
                    NEXT FIELD fin03
                 END IF
               END IF
           END IF
 
       AFTER FIELD fin04
           IF NOT cl_null(g_fin.fin04) THEN
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND g_fin.fin04 != g_fin_t.fin04) THEN
                 CALL i201_fin04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fin.fin04,g_errno,0)
                    NEXT FIELD fin04
                 END IF
              END IF
              IF g_fin.fin01 != g_fin_t.fin01 OR g_fin_t.fin01 IS NULL
              OR g_fin.fin02 != g_fin_t.fin02 OR g_fin_t.fin02 IS NULL
              OR g_fin.fin03 != g_fin_t.fin03 OR g_fin_t.fin03 IS NULL
              OR g_fin.fin04 != g_fin_t.fin04 OR g_fin_t.fin04 IS NULL THEN
                 SELECT COUNT(*) INTO g_cnt FROM fin_file
                  WHERE fin01 = g_fin.fin01
                    AND fin02 = g_fin.fin02
                    AND fin03 = g_fin.fin03
                    AND fin04 = g_fin.fin04
                 IF g_cnt > 0 THEN   #資料重復
                    CALL cl_err(g_fin.fin01,-239,0)
                    LET g_fin.fin01 = g_fin_t.fin01
                    LET g_fin.fin02 = g_fin_t.fin02
                    LET g_fin.fin03 = g_fin_t.fin03
                    LET g_fin.fin04 = g_fin_t.fin04
                    DISPLAY BY NAME g_fin.fin01
                    DISPLAY BY NAME g_fin.fin02
                    DISPLAY BY NAME g_fin.fin03
                    DISPLAY BY NAME g_fin.fin04
                    NEXT FIELD fin01
                 END IF
              END IF
           END IF
 
       AFTER FIELD fin05
           IF NOT cl_null(g_fin.fin05) THEN
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND g_fin.fin05 != g_fin_t.fin05) THEN
                 CALL i201_fin05('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fin.fin05,g_errno,0)
                    NEXT FIELD fin05
                 END IF
              END IF
           END IF
 
       AFTER FIELD fin06
           IF NOT cl_null(g_fin.fin06) THEN
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND g_fin.fin06 != g_fin_t.fin06) THEN
                 CALL i201_fin06('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fin.fin06,g_errno,0)
                    NEXT FIELD fin06
                 END IF
              END IF
           END IF
 
        AFTER FIELD fin08
            IF NOT cl_null(g_fin.fin08) THEN
               LET g_i=LENGTH(g_fin.fin08)
               IF g_i <> 4 THEN
                  CALL cl_err(g_fin.fin08,'aem-006',0)
                  NEXT FIELD fin08
               END IF
               IF g_fin.fin08 NOT MATCHES '[0-9][0-9][0-9][0-9]'
               OR g_fin.fin08[1,2] <'00' OR g_fin.fin08[1,2]>'23'
               OR g_fin.fin08[3,4] NOT MATCHES '[0-5][0-9]' THEN
                  CALL cl_err(g_fin.fin08,'aem-006',0)
                  NEXT FIELD fin08
               END IF
           END IF
 
        AFTER FIELD fin10
            IF NOT cl_null(g_fin.fin10) THEN
               LET g_i=LENGTH(g_fin.fin10)
               IF g_i <> 4 THEN
                  CALL cl_err(g_fin.fin10,'aem-006',0)
                  NEXT FIELD fin10
               END IF
               IF g_fin.fin10 NOT MATCHES '[0-9][0-9][0-9][0-9]'
               OR g_fin.fin10[1,2] <'00' OR g_fin.fin10[1,2]>'23'
               OR g_fin.fin10[3,4] NOT MATCHES '[0-5][0-9]' THEN
                  CALL cl_err(g_fin.fin10,'aem-006',0)
                  NEXT FIELD fin10
               END IF
           END IF
 
        #FUN-840068     ---start---
        AFTER FIELD finud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD finud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
       ON ACTION CONTROLP
            CASE
               WHEN INFIELD(fin01)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_fil"
                      LET g_qryparam.default1 = g_fin.fin01
                      CALL cl_create_qry() RETURNING g_fin.fin01
                      DISPLAY BY NAME g_fin.fin01
                      NEXT FIELD fin01
               WHEN INFIELD(fin02)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_fim"
                      LET g_qryparam.arg1 = g_fin.fin01
                      LET g_qryparam.default1 = g_fin.fin02
                      CALL cl_create_qry() RETURNING g_fin.fin02
                      DISPLAY BY NAME g_fin.fin02
                      NEXT FIELD fin02
               WHEN INFIELD(fin03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_fix"
                      LET g_qryparam.arg1 = g_fin.fin02
                      LET g_qryparam.default1 = g_fin.fin03
                      CALL cl_create_qry() RETURNING g_fin.fin03
                      DISPLAY BY NAME g_fin.fin03
                      NEXT FIELD fin03
               WHEN INFIELD(fin04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_trx"
                      LET g_qryparam.arg1 = g_fin.fin03
                      LET g_qryparam.default1 = g_fin.fin04
                      CALL cl_create_qry() RETURNING g_fin.fin04
                      DISPLAY BY NAME g_fin.fin04
                      NEXT FIELD fin04
                WHEN INFIELD(fin05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gem"
                      LET g_qryparam.default1 = g_fin.fin05
                      CALL cl_create_qry() RETURNING g_fin.fin05
                      DISPLAY BY NAME g_fin.fin05
                      NEXT FIELD fin05
                #-----TQC-B90211---------
                #WHEN INFIELD(fin06)
                #      CALL cl_init_qry_var()
                #      LET g_qryparam.form ="q_cpe"
                #      LET g_qryparam.default1 = g_fin.fin06
                #      CALL cl_create_qry() RETURNING g_fin.fin06
                #      DISPLAY BY NAME g_fin.fin06
                #      NEXT FIELD fin06
                #-----END TQC-B90211-----
               OTHERWISE
                 EXIT CASE
            END CASE
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg 
            CALL cl_cmdask()
        #-----END TQC-860018-----
 
    END INPUT
END FUNCTION
 
FUNCTION i201_u()
DEFINE l_n      LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
    IF cl_null(g_fin.fin01) OR cl_null(g_fin.fin02)
    OR cl_null(g_fin.fin03) OR cl_null(g_fin.fin04) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fin01_t = g_fin.fin01
    LET g_fin02_t = g_fin.fin02
    LET g_fin03_t = g_fin.fin03
    LET g_fin04_t = g_fin.fin04
 
    LET g_fin_t.*=g_fin.*
    BEGIN WORK
    OPEN i201_cl USING g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04
    IF STATUS THEN
       CALL cl_err("OPEN i201_cl:", STATUS, 1)
       CLOSE i201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i201_cl INTO g_fin.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fin.fin01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i201_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i201_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE fin_file SET fin_file.* = g_fin.*    # 更新DB
         WHERE fin01 = g_fin01_t AND fin02 = g_fin02_t AND fin03 = g_fin03_t AND fin04 = g_fin04_t              # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_fin.fin01,SQLCA.sqlcode,0)   #No.FUN-660092
           CALL cl_err3("upd","fin_file",g_fin.fin01,g_fin.fin02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i201_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i201_fetch(p_flzx)
    DEFINE
         p_flzx          LIKE type_file.chr1    #No.FUN-680072CHAR(1)
 
    CASE p_flzx
        WHEN 'N' FETCH NEXT     i201_cs INTO g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04
        WHEN 'P' FETCH PREVIOUS i201_cs INTO g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04
        WHEN 'F' FETCH FIRST    i201_cs INTO g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04
        WHEN 'L' FETCH LAST     i201_cs INTO g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04
        WHEN '/'
         IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
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
         FETCH ABSOLUTE g_jump i201_cs INTO g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fin.fin01,SQLCA.sqlcode,0)
        INITIALIZE g_fin.* TO NULL                #No.FUN-6B0050
        RETURN
    ELSE
       CASE p_flzx
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_fin.* FROM fin_file            # 重讀DB,因TEMP有不被更新特性
       WHERE fin01=g_fin.fin01 AND fin02=g_fin.fin02 AND fin03=g_fin.fin03 
         AND fin04 = g_fin.fin04         #TQC-C40252--add--
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fin.fin01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("sel","fin_file",g_fin.fin01,g_fin.fin02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
        INITIALIZE g_fin.* TO NULL                #No.FUN-6B0050
    ELSE
        LET g_data_owner = g_fin.finuser   #FUN-4C0069
        LET g_data_group = g_fin.fingrup   #FUN-4C0069
        LET g_data_plant = g_fin.finplant #FUN-980030
        CALL i201_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i201_show()
    LET g_fin_t.* = g_fin.*
    DISPLAY BY NAME g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04,
                    g_fin.fin05,g_fin.fin06,g_fin.fin07,g_fin.fin08,
                    g_fin.fin09,g_fin.fin10,g_fin.fin11,
                    #FUN-840068     ---start---
                    g_fin.finud01,g_fin.finud02,g_fin.finud03,g_fin.finud04,
                    g_fin.finud05,g_fin.finud06,g_fin.finud07,g_fin.finud08,
                    g_fin.finud09,g_fin.finud10,g_fin.finud11,g_fin.finud12,
                    g_fin.finud13,g_fin.finud14,g_fin.finud15 
                    #FUN-840068     ----end----
    CALL i201_fin01('d')
    CALL i201_fin02('d')
    CALL i201_fin03('d')
    CALL i201_fin04('d')
    CALL i201_fin05('d')
    CALL i201_fin06('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i201_fin01(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fil03   LIKE fil_file.fil03
   DEFINE l_filacti LIKE fil_file.filacti
   DEFINE l_fia02   LIKE fia_file.fia02
   DEFINE l_fiaacti LIKE fia_file.fiaacti
 
   SELECT fil03,filacti,fia02 INTO l_fil03,l_filacti,l_fia02
     FROM fil_file,fia_file
    WHERE fil01 = g_fin.fin01
      AND fia01 = fil03
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aem-028'
        WHEN l_filacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_fil03 TO FORMONLY.fil03
      DISPLAY l_fia02 TO FORMONLY.fia02
   END IF
END FUNCTION
 
FUNCTION i201_fin02(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
         l_fio02   LIKE fio_file.fio02,
         l_fioacti LIKE fio_file.fioacti
 
     LET g_errno = ' '
     SELECT fio02,fioacti INTO l_fio02,l_fioacti
       FROM fio_file,fim_file
      WHERE fio01=fim03
        AND fim01=g_fin.fin01
        AND fio01=g_fin.fin02
     CASE
         WHEN SQLCA.sqlcode =100 LET g_errno='aem-031'
                                 LET l_fio02=NULL
         WHEN l_fioacti = 'N'    LET g_errno = '9028'
         OTHERWISE               LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
 
     IF p_cmd='d' OR g_errno=' ' THEN
        DISPLAY l_fio02 TO FORMONLY.fio02
     END IF
END FUNCTION
 
FUNCTION i201_fin03(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
         l_trw02   LIKE trw_file.trw02,
         l_trwacti LIKE trw_file.trwacti
 
     LET g_errno = ' '
     SELECT trw02,trwacti INTO l_trw02,l_trwacti
       FROM fix_file,trw_file
      WHERE fix03=trw01
        AND fix01=g_fin.fin02
        AND trw01=g_fin.fin03
     CASE
         WHEN SQLCA.sqlcode =100 LET g_errno='aem-032'
                                 LET l_trw02=NULL
         WHEN l_trwacti = 'N'    LET g_errno = '9028'
         OTHERWISE               LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
 
     IF p_cmd='d' OR g_errno=' ' THEN
        DISPLAY l_trw02 TO FORMONLY.trw02
     END IF
END FUNCTION
 
FUNCTION i201_fin04(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
         l_gen02   LIKE gen_file.gen02,
         l_gen03   LIKE gen_file.gen03,
         l_genacti LIKE gen_file.genacti
 
     LET g_errno = ' '
     SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
       FROM trx_file,gen_file
      WHERE trx02=gen01
        AND trx01=g_fin.fin03
        AND gen01=g_fin.fin04
     CASE
         WHEN SQLCA.sqlcode =100 LET g_errno='aap-038'
                                 LET l_gen02=NULL
         WHEN l_genacti = 'N'    LET g_errno = '9028'
         OTHERWISE               LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
 
     IF p_cmd='d' OR g_errno=' ' THEN
        DISPLAY l_gen02 TO FORMONLY.gen02
        IF cl_null(g_fin.fin05) THEN
           LET g_fin.fin05 = l_gen03
           DISPLAY BY NAME g_fin.fin05
        END IF
     END IF
END FUNCTION
 
FUNCTION i201_fin05(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
         l_gem02   LIKE gem_file.gem02,
         l_gemacti LIKE gem_file.gemacti
 
     LET g_errno = ' '
     SELECT gem02,gemacti INTO l_gem02,l_gemacti
       FROM gem_file
      WHERE gem01=g_fin.fin05
     CASE
         WHEN SQLCA.sqlcode =100 LET g_errno='aap-039'
                                 LET l_gem02=NULL
         WHEN l_gemacti = 'N'    LET g_errno = '9028'
         OTHERWISE               LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
 
     IF p_cmd='d' OR g_errno=' ' THEN
        DISPLAY l_gem02 TO FORMONLY.gem02
     END IF
END FUNCTION
 
FUNCTION i201_fin06(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
  #-----TQC-B90211---------
  #      l_cpe02   LIKE cpe_file.cpe02,
  #      l_cpeacti LIKE cpe_file.cpeacti
 
  #  LET g_errno = ' '
  #  SELECT cpe02,cpeacti INTO l_cpe02,l_cpeacti
  #    FROM cpe_file
  #   WHERE cpe01=g_fin.fin06
  #  CASE
  #      WHEN SQLCA.sqlcode =100 #LET g_errno='apy-014' #CHI-B40058
  #                              LET g_errno='aem-052'  #CHI-B40058
  #                              LET l_cpe02=NULL
  #      WHEN l_cpeacti = 'N'    LET g_errno = '9028'
  #      OTHERWISE               LET g_errno=SQLCA.sqlcode USING '------'
  #  END CASE
 
  #  IF p_cmd='d' OR g_errno=' ' THEN
  #     DISPLAY l_cpe02 TO FORMONLY.cpe02
  #  END IF
  #-----END TQC-B90211-----
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i201_r()
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_fin.fin01) OR cl_null(g_fin.fin02)
   OR cl_null(g_fin.fin03) OR cl_null(g_fin.fin04) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_fin.* FROM fin_file
    WHERE fin01=g_fin.fin01 AND fin02=g_fin.fin02
      AND fin03=g_fin.fin03 AND fin04=g_fin.fin04
 
   BEGIN WORK
   OPEN i201_cl USING g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04
   IF STATUS THEN
      CALL cl_err("OPEN i201_cl:", STATUS, 1)   
      CLOSE i201_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i201_cl INTO g_fin.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fin.fin01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL i201_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "fin01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "fin02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_fin.fin01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_fin.fin02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM fin_file
       WHERE fin01=g_fin.fin01 AND fin02=g_fin.fin02
         AND fin03=g_fin.fin03 AND fin04=g_fin.fin04
      IF STATUS THEN
#        CALL cl_err('del fin:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fin_file",g_fin.fin01,g_fin.fin02,STATUS,"","del fin:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_fin.* TO NULL
      CLEAR FORM
      OPEN i201_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i201_cs
             CLOSE i201_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
      FETCH i201_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i201_cs
             CLOSE i201_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i201_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i201_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i201_fetch('/')
      END IF
   END IF
   CLOSE i201_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i201_copy()
    DEFINE l_n                LIKE type_file.num5,          #No.FUN-680072 SMALLINT
           l_newno1,l_oldno1  LIKE fin_file.fin01,
           l_newno2,l_oldno2  LIKE fin_file.fin02,
           l_newno3,l_oldno3  LIKE fin_file.fin03,
           l_newno4,l_oldno4  LIKE fin_file.fin04,
           p_cmd     LIKE type_file.chr1,                   #No.FUN-680072 VARCHAR(1)
           l_input   LIKE type_file.chr1                    #No.FUN-680072 VARCHAR(1)
 
    IF cl_null(g_fin.fin01) OR cl_null(g_fin.fin02)
    OR cl_null(g_fin.fin03) OR cl_null(g_fin.fin04) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    DISPLAY g_msg AT 2,1 #ATTRIBUTE(RED)    #No.FUN-940135
    LET l_oldno1 = g_fin.fin01
    LET l_oldno2 = g_fin.fin02
    LET l_oldno3 = g_fin.fin03
    LET l_oldno4 = g_fin.fin04
 
    LET g_before_input_done = FALSE
    CALL i201_set_entry(p_cmd)
    LET g_before_input_done = TRUE
 
    INPUT g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04
       FROM fin01,fin02,fin03,fin04
        #No.FUN-550024 --start--
        BEFORE INPUT
           CALL cl_set_docno_format("fin01")
        #No.FUN-550024 ---end---
          AFTER FIELD fin01
              IF g_fin.fin01 IS NOT NULL THEN
                 CALL i201_fin01('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fin.fin01,g_errno,0)
                    NEXT FIELD fin01
                 END IF
              END IF
 
          AFTER FIELD fin02
              IF g_fin.fin02 IS NOT NULL THEN
                 CALL i201_fin02('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fin.fin02,g_errno,0)
                    NEXT FIELD fin02
                 END IF
              END IF
 
          AFTER FIELD fin03
              IF g_fin.fin03 IS NOT NULL THEN
                 CALL i201_fin03('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fin.fin03,g_errno,0)
                    NEXT FIELD fin03
                 END IF
              END IF
 
          AFTER FIELD fin04
              IF g_fin.fin04 IS NOT NULL THEN
                 CALL i201_fin04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fin.fin04,g_errno,0)
                    NEXT FIELD fin04
                 END IF
              END IF
 
          ON ACTION CONTROLP
              CASE
               WHEN INFIELD(fin01)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_fil"
                      LET g_qryparam.default1 = g_fin.fin01
                      CALL cl_create_qry() RETURNING g_fin.fin01
                      DISPLAY BY NAME g_fin.fin01
                      NEXT FIELD fin01
               WHEN INFIELD(fin02)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_fim"
                      LET g_qryparam.default1 = g_fin.fin02
                      LET g_qryparam.arg1 = g_fin.fin01
                      CALL cl_create_qry() RETURNING g_fin.fin02
                      DISPLAY BY NAME g_fin.fin02
                      NEXT FIELD fin02
               WHEN INFIELD(fin03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_fix"
                      LET g_qryparam.default1 = g_fin.fin03
                      LET g_qryparam.arg1 = g_fin.fin02
                      CALL cl_create_qry() RETURNING g_fin.fin03
                      DISPLAY BY NAME g_fin.fin03
                      NEXT FIELD fin03
               WHEN INFIELD(fin04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_trx"
                      LET g_qryparam.default1 = g_fin.fin04
                      LET g_qryparam.arg1 = g_fin.fin03
                      CALL cl_create_qry() RETURNING g_fin.fin04
                      DISPLAY BY NAME g_fin.fin04
                      NEXT FIELD fin04
                 OTHERWISE
                    EXIT CASE
              END CASE
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg 
            CALL cl_cmdask()
        #-----END TQC-860018-----
 
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG = 0
       #No.FUN-550024 --start--
       ROLLBACK WORK
       #No.FUN-550024 ---end---
    RETURN END IF
 
    DROP TABLE x
    LET l_newno1 = g_fin.fin01
    LET l_newno2 = g_fin.fin02
    LET l_newno3 = g_fin.fin03
    LET l_newno4 = g_fin.fin04
    SELECT * FROM fin_file WHERE fin01=l_oldno1 AND fin02=l_oldno2 AND fin03=l_oldno3 AND fin04=l_oldno4 INTO TEMP x
    UPDATE x SET fin01=l_newno1,fin02=l_newno2,fin03=l_newno3,fin04=l_newno4    #資料鍵值
    INSERT INTO fin_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fin.fin01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","fin_file",g_fin.fin02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
    ELSE
        MESSAGE 'ROW(',g_fin.fin01,g_fin.fin02,g_fin.fin03,g_fin.fin04,') O.K' ATTRIBUTE(REVERSE)
    END IF
    SELECT fin_file.* INTO g_fin.* FROM fin_file
     WHERE fin01 = l_newno1 AND fin02 = l_newno2
       AND fin03 = l_newno3 AND fin04 = l_newno4
    CALL i201_u()
    CALL i201_show()
    #FUN-C30027---begin
    #SELECT fin_file.* INTO g_fin.* FROM fin_file
    # WHERE fin01 = l_oldno1
    #   AND fin02 = l_oldno2
    #   AND fin03 = l_oldno3
    #   AND fin04 = l_oldno4
    #CALL i201_show()
    #FUN-C30027---end
END FUNCTION
 
FUNCTION i201_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("fin01,fin02,fin03,fin04",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i201_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fin01,fin02,fin03,fin04",FALSE)
    END IF
 
    IF NOT cl_null(g_argv1) THEN
       CALL cl_set_comp_entry("fin01,fin02",FALSE)
    END IF
 
END FUNCTION
{
FUNCTION i201_out()
    DEFINE
        l_i             LIKE type_file.num5,     #No.FUN-680072 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680072 VARCHAR(20)
        l_fin           RECORD LIKE fin_file.*,
        l_za05          LIKE type_file.chr1000,  #No.FUN-680072 VARCHAR(40)
        l_chr           LIKE type_file.chr1      #No.FUN-680072 VARCHAR(1)
 
    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('aemi201') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    DECLARE i201_za_cur CURSOR FOR
            SELECT za02,za05 FROM za_file
            WHERE  za01 = "aemi201" AND za03 = g_lang
    FOREACH i201_za_cur INTO g_i,l_za05
       LET g_x[g_i] = l_za05
    END FOREACH
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aemi201'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM fin_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i201_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i201_co CURSOR FOR i201_p1
 
    START REPORT i201_rep TO l_name
 
    FOREACH i201_co INTO l_fin.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
           END IF
        OUTPUT TO REPORT i201_rep(l_fin.*)
    END FOREACH
 
    FINISH REPORT i201_rep
 
    CLOSE i201_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i201_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680072 VARCHAR(1)
        sr              RECORD LIKE fin_file.*,
        l_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fin01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT COLUMN 2,g_x[11],g_x[12] CLIPPED
            PRINT ' -------------------- ',
            '---------------------------------------- ----'
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            IF sr.fin03 = 'N' THEN PRINT '*'; END IF
            PRINT COLUMN 2,sr.fin01,
                  COLUMN 23, sr.fin02,
                  COLUMN 64, sr.fin03
 
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc2,'fin01,fin02,fin03')
                    RETURNING g_sql
               PRINT g_dash[1,g_len]
               #TQC-630166
               #IF g_sql[001,080] > ' ' THEN
	       #	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               #IF g_sql[071,140] > ' ' THEN
	       #	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               #IF g_sql[141,210] > ' ' THEN
	       #	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
               CALL cl_prt_pos_wc(g_sql)
               #END TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
#No.FUN-580002  --begin
END REPORT
}
#No.FUN-580002  --end
#Patch....NO.TQC-610035 <001> #
