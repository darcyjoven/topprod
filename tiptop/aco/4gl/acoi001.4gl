# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acoi001.4gl
# Descriptions...: 商品編號期初資料開帳作業
# Date & Author..: 05/03/07 By Day
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# MOdify.........: No.TQC-660045 06/06/09 By hellen  cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0059 23/10/16 By xumin g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0084 11/12/28 By lixh1 增加數量欄位小數取位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds 
 
GLOBALS "../../config/top.global"
 
DEFINE g_cnd       RECORD LIKE cnd_file.*,
       g_cnd_t     RECORD LIKE cnd_file.*,  #備份舊值
       g_cnd01_t   LIKE cnd_file.cnd01,     #Key值備份
       g_cnd02_t   LIKE cnd_file.cnd02,     #Key值備份
       g_cnd03_t   LIKE cnd_file.cnd03,     #Key值備份
       g_cnd04_t   LIKE cnd_file.cnd04,     #Key值備份
       g_cnd05_t   LIKE cnd_file.cnd05,     #Key值備份
       g_cnd06_t   LIKE cnd_file.cnd06,     #Key值備份
       g_cnd07_t   LIKE cnd_file.cnd07,     #Key值備份
        g_wc        STRING,              #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680069
       g_sql       STRING                   #組 sql 用        #No.FUN-680069
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令        #No.FUN-680069 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680069 VARCHAR(01)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680069 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680069 INTEGER
DEFINE mi_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗        #No.FUN-680069 SMALLINT    #No.FUN-6A0059
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0063
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   INITIALIZE g_cnd.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM cnd_file WHERE cnd01 = ? AND cnd02 = ? AND cnd03 = ? AND cnd04 = ? AND cnd05 = ? AND cnd06 = ? AND cnd07 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i001_w AT p_row,p_col WITH FORM "aco/42f/acoi001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i001_menu()
 
   CLOSE WINDOW i001_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION i001_curs()
DEFINE ls    STRING
 
    CLEAR FORM
    INITIALIZE g_cnd.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        cnd01,cnd02,cnd03,cnd04,cnd05,cnd08,cndconf,cnd09,
        cnd06,cnd07,cnd10,cnd11,cnd12,cnd13,cnduser,
        cndgrup,cndmodu,cnddate,cndacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(cnd01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_cob"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_cnd.cnd01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cnd01
                 NEXT FIELD cnd01
               WHEN INFIELD(cnd02)         #手冊編號
                 CALL q_coc2(TRUE,TRUE,g_cnd.cnd02,'','','','','')
                      RETURNING g_cnd.cnd02
                 DISPLAY BY NAME g_cnd.cnd02
                 NEXT FIELD cnd02
              WHEN INFIELD(cnd07)
                 IF g_cnd.cnd06='2' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc2"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_cnd.cnd07
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cnd07
                    NEXT FIELD cnd07
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_cnd.cnd07
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cnd07
                    NEXT FIELD cnd07
                 END IF
              WHEN INFIELD(cnd08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cnd08
                 NEXT FIELD cnd08
              OTHERWISE
                 EXIT CASE
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
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND cnduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cndgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cndgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnduser', 'cndgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT cnd01,cnd02,cnd03,cnd04,cnd05,cnd06,cnd07 FROM cnd_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY cnd01"
    PREPARE i001_prepare FROM g_sql
    DECLARE i001_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i001_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cnd_file WHERE ",g_wc CLIPPED
    PREPARE i001_precount FROM g_sql
    DECLARE i001_count CURSOR FOR i001_precount
END FUNCTION
 
FUNCTION i001_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(100)
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i001_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i001_q()
            END IF
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL i001_y()
               CALL cl_set_field_pic(g_cnd.cndconf,"","","","",g_cnd.cndacti)
            END IF
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i001_z()
               CALL cl_set_field_pic(g_cnd.cndconf,"","","","",g_cnd.cndacti)
            END IF
        ON ACTION next
            CALL i001_fetch('N')
        ON ACTION previous
            CALL i001_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i001_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i001_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i001_r()
            END IF
#       ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            IF cl_chk_act_auth() THEN
#                 CALL i001_copy()
#            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i001_fetch('/')
        ON ACTION first
            CALL i001_fetch('F')
        ON ACTION last
            CALL i001_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document    #No.MOD-470515
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_cnd.cnd01 IS NOT NULL THEN
                 LET g_doc.column1 = "cnd01"
                 LET g_doc.value1 = g_cnd.cnd01
                 CALL cl_doc()
              END IF
           END IF
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i001_cs
END FUNCTION
 
 
FUNCTION i001_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cnd.* LIKE cnd_file.*
    LET g_cnd01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cnd.cnduser = g_user
        LET g_cnd.cndoriu = g_user #FUN-980030
        LET g_cnd.cndorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_cnd.cndgrup = g_grup               #使用者所屬群
        LET g_cnd.cnddate = g_today
        LET g_cnd.cndacti = 'Y'
        LET g_cnd.cndconf = 'N'
        LET g_cnd.cnd03 = YEAR(g_today)
        LET g_cnd.cnd04 = MONTH(g_today)
        LET g_cnd.cnd05 = '1'
        LET g_cnd.cnd06 = ' '
        LET g_cnd.cnd07 = ' '
        LET g_cnd.cnd09 = 0
        LET g_cnd.cnd10 = 0
        LET g_cnd.cnd11 = 0
        LET g_cnd.cnd12 = 0
        LET g_cnd.cnd13 = 0
        LET g_cnd.cndplant = g_plant   ##FUN-980002
        LET g_cnd.cndlegal = g_legal   ##FUN-980002
        CALL i001_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_cnd.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF (g_cnd.cnd01 IS NULL OR g_cnd.cnd02 IS NULL
           OR g_cnd.cnd03 IS NULL OR g_cnd.cnd04 IS NULL
           OR g_cnd.cnd05 IS NULL OR g_cnd.cnd06 IS NULL
           OR g_cnd.cnd07 IS NULL) THEN
            CONTINUE WHILE
        END IF
        INSERT INTO cnd_file VALUES(g_cnd.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
 #         CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,0) #No.TQC-660045
           CALL cl_err3("ins","cnd_file",g_cnd.cnd01,g_cnd.cnd02,SQLCA.sqlcode,"","",1)     #TQC-660045   
           CONTINUE WHILE
        ELSE
            SELECT cnd01,cnd02,cnd03,cnd04,cnd05,cnd06,cnd07 INTO g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 FROM cnd_file
                     WHERE cnd01 = g_cnd.cnd01
                       AND cnd02 = g_cnd.cnd02
                       AND cnd03 = g_cnd.cnd03
                       AND cnd04 = g_cnd.cnd04
                       AND cnd05 = g_cnd.cnd05
                       AND cnd06 = g_cnd.cnd06
                       AND cnd07 = g_cnd.cnd07
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i001_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
            l_cob02   LIKE cob_file.cob02,
            l_cob021  LIKE cob_file.cob021,
            l_coc04   LIKE coc_file.coc04,
            l_input   LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
            l_n1      LIKE type_file.num5,          #No.FUN-680069 SMALLINT
            l_n       LIKE type_file.num5           #No.FUN-680069 SMALLINT
 
   DISPLAY BY NAME
        g_cnd.cnd01,g_cnd.cnd02,g_cnd.cnd03,g_cnd.cnd04,g_cnd.cnd05,
        g_cnd.cnd08,g_cnd.cnd09,g_cnd.cnd06,g_cnd.cnd07,g_cnd.cnd10,
        g_cnd.cnd11,g_cnd.cnd12,g_cnd.cnd13,g_cnd.cndconf,
        g_cnd.cnduser,g_cnd.cndgrup,g_cnd.cndmodu,g_cnd.cnddate,g_cnd.cndacti
 
   INPUT BY NAME
        g_cnd.cnd01,g_cnd.cnd02,g_cnd.cnd03,g_cnd.cnd04,g_cnd.cnd05,
        g_cnd.cnd08,g_cnd.cnd09,g_cnd.cnd06,g_cnd.cnd07,g_cnd.cnd10,
        g_cnd.cnd11,g_cnd.cnd12,g_cnd.cnd13
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i001_set_entry(p_cmd)
          CALL i001_set_no_entry(p_cmd)
          CALL i001_set_no_required()
          CALL i001_set_required()
          LET g_before_input_done = TRUE
 
      AFTER FIELD cnd01
         IF NOT cl_null(g_cnd.cnd01) THEN
            CALL i001_cnd01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('cnd01:',g_errno,1)
               LET g_cnd.cnd01 = g_cnd01_t
               DISPLAY BY NAME g_cnd.cnd01
               NEXT FIELD cnd01
            END IF
         END IF
 
      AFTER FIELD cnd02
         IF NOT cl_null(g_cnd.cnd02) THEN
            SELECT count(*) INTO l_n1 FROM coc_file
             WHERE coc03 = g_cnd.cnd02
            IF l_n1 <= 0 THEN
              CALL cl_err(g_cnd.cnd02,'aco-062',0)
              LET g_cnd.cnd02 = NULL
              NEXT FIELD cnd02
            END IF
         END IF
 
      AFTER FIELD cnd03
         IF NOT cl_null(g_cnd.cnd03) THEN
            IF g_cnd.cnd03<=0 THEN
               NEXT FIELD cnd03
            END IF
         END IF
 
      AFTER FIELD cnd04
         IF NOT cl_null(g_cnd.cnd04) THEN
            IF g_cnd.cnd04 > 12 OR g_cnd.cnd04 < 1 THEN
               NEXT FIELD cnd04
            END IF
         END IF
 
      BEFORE FIELD cnd05
         CALL i001_set_entry(p_cmd)
         CALL i001_set_no_required()
 
      AFTER FIELD cnd05
         IF g_cnd.cnd05='4' THEN
            IF cl_null(g_cnd.cnd06) THEN
               LET g_cnd.cnd06 = '1'
               DISPLAY BY NAME g_cnd.cnd06
               NEXT FIELD cnd06
            END IF
         END IF
         CALL i001_ins_check('0')
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_cnd.cnd01,g_errno,0)
            NEXT FIELD cnd01
         END IF
         CALL i001_set_no_entry(p_cmd)
         CALL i001_set_required()
 
      BEFORE FIELD cnd06
         CALL i001_set_entry(p_cmd)
 
      AFTER FIELD cnd06
         CALL i001_set_no_entry(p_cmd)
 
      AFTER FIELD cnd07
         IF NOT cl_null(g_cnd.cnd07) THEN
            IF g_cnd.cnd01 != g_cnd_t.cnd01 OR g_cnd_t.cnd01 IS NULL
               OR g_cnd.cnd02 != g_cnd_t.cnd02 OR g_cnd_t.cnd02 IS NULL
               OR g_cnd.cnd03 != g_cnd_t.cnd03 OR g_cnd_t.cnd03 IS NULL
               OR g_cnd.cnd04 != g_cnd_t.cnd04 OR g_cnd_t.cnd04 IS NULL
               OR g_cnd.cnd05 != g_cnd_t.cnd05 OR g_cnd_t.cnd05 IS NULL
               OR g_cnd.cnd06 != g_cnd_t.cnd06 OR g_cnd_t.cnd06 IS NULL
               OR g_cnd.cnd07 != g_cnd_t.cnd07 OR g_cnd_t.cnd07 IS NULL THEN
               CALL i001_ins_check('1')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cnd.cnd01,g_errno,0)
                  NEXT FIELD cnd01
               END IF
            END IF
            IF g_cnd.cnd06 = '1' THEN #客戶
               SELECT * FROM occ_file WHERE occ01=g_cnd.cnd07 AND occacti='Y'
               IF SQLCA.sqlcode THEN
 #                CALL cl_err(g_cnd.cnd07,SQLCA.sqlcode,0) #No.TQC-660045
                  CALL cl_err3("sel","occ_file",g_cnd.cnd07,"",SQLCA.sqlcode,"","",1) #TQC-660045    
                  NEXT FIELD cnd07
               END IF
            ELSE                      #供應商
               SELECT * FROM pmc_file WHERE pmc01=g_cnd.cnd07 AND pmcacti='Y'
               IF SQLCA.sqlcode THEN
 #                CALL cl_err(g_cnd.cnd07,SQLCA.sqlcode,0) #No.TQC-660045
                  CALL cl_err3("sel","pmc_file",g_cnd.cnd07,"",SQLCA.sqlcode,"","",1)   #TQC-660045   
                  NEXT FIELD cnd07
               END IF
            END IF
         END IF
 
      AFTER FIELD cnd09
         IF NOT cl_null(g_cnd.cnd09) THEN
            IF g_cnd.cnd09<0 THEN
               NEXT FIELD cnd09
            END IF
            LET g_cnd.cnd09 = s_digqty(g_cnd.cnd09,g_cnd.cnd08)  #FUN-BB0084
            DISPLAY g_cnd.cnd09 TO cnd09                         #FUN-BB0084
         END IF
 
      AFTER FIELD cnd10
         IF NOT cl_null(g_cnd.cnd10) THEN
            IF g_cnd.cnd10<0 THEN
               NEXT FIELD cnd10
            END IF
            IF NOT cl_null(g_cnd.cnd11) THEN
               IF g_cnd.cnd10 > 0 AND g_cnd.cnd11 > 0 THEN
                  CALL cl_err(g_cnd.cnd10,'aco-217',0)
                  NEXT FIELD cnd10
               END IF
            END IF
            LET g_cnd.cnd10 = s_digqty(g_cnd.cnd10,g_cnd.cnd08)  #FUN-BB0084
            DISPLAY g_cnd.cnd10 TO cnd10                         #FUN-BB0084 
         END IF
 
      AFTER FIELD cnd11
         IF NOT cl_null(g_cnd.cnd11) THEN
            LET g_cnd.cnd11 = s_digqty(g_cnd.cnd11,g_cnd.cnd08)  #FUN-BB0084
            DISPLAY g_cnd.cnd11 TO cnd11                         #FUN-BB0084
            IF g_cnd.cnd11<0 THEN
               NEXT FIELD cnd11
            END IF
            IF NOT cl_null(g_cnd.cnd10) THEN
               IF g_cnd.cnd10 > 0 AND g_cnd.cnd11 > 0 THEN
                  CALL cl_err(g_cnd.cnd11,'aco-217',0)
                  NEXT FIELD cnd10
               END IF
            END IF
         END IF
 
      AFTER FIELD cnd12
         IF NOT cl_null(g_cnd.cnd12) THEN
            IF g_cnd.cnd12<0 THEN
               NEXT FIELD cnd12
            END IF
            IF NOT cl_null(g_cnd.cnd13) THEN
               IF g_cnd.cnd12 > 0 AND g_cnd.cnd13 > 0 THEN
                  CALL cl_err(g_cnd.cnd12,'aco-217',0)
                  NEXT FIELD cnd12
               END IF
            END IF
            LET g_cnd.cnd12 = s_digqty(g_cnd.cnd12,g_cnd.cnd08)  #FUN-BB0084
            DISPLAY g_cnd.cnd12 TO cnd12                         #FUN-BB0084
         END IF
 
      AFTER FIELD cnd13
         IF NOT cl_null(g_cnd.cnd13) THEN
            LET g_cnd.cnd13 = s_digqty(g_cnd.cnd13,g_cnd.cnd08)  #FUN-BB0084
            DISPLAY g_cnd.cnd13 TO cnd13                         #FUN-BB0084 
            IF g_cnd.cnd13<0 THEN
               NEXT FIELD cnd13
            END IF
            IF NOT cl_null(g_cnd.cnd12) THEN
               IF g_cnd.cnd12 > 0 AND g_cnd.cnd13 > 0 THEN
                  CALL cl_err(g_cnd.cnd13,'aco-217',0)
                  NEXT FIELD cnd12
               END IF
            END IF
         END IF
 
      AFTER INPUT
         LET g_cnd.cnduser = s_get_data_owner("cnd_file") #FUN-C10039
         LET g_cnd.cndgrup = s_get_data_group("cnd_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF (g_cnd.cnd01 IS NULL OR g_cnd.cnd02 IS NULL
               OR g_cnd.cnd03 IS NULL OR g_cnd.cnd04 IS NULL
               OR g_cnd.cnd05 IS NULL OR g_cnd.cnd06 IS NULL
               OR g_cnd.cnd07 IS NULL) THEN
               NEXT FIELD cnd01
            END IF
            IF g_cnd.cnd01 != g_cnd_t.cnd01 OR g_cnd_t.cnd01 IS NULL
               OR g_cnd.cnd02 != g_cnd_t.cnd02 OR g_cnd_t.cnd02 IS NULL
               OR g_cnd.cnd03 != g_cnd_t.cnd03 OR g_cnd_t.cnd03 IS NULL
               OR g_cnd.cnd04 != g_cnd_t.cnd04 OR g_cnd_t.cnd04 IS NULL
               OR g_cnd.cnd05 != g_cnd_t.cnd05 OR g_cnd_t.cnd05 IS NULL
               OR g_cnd.cnd06 != g_cnd_t.cnd06 OR g_cnd_t.cnd06 IS NULL
               OR g_cnd.cnd07 != g_cnd_t.cnd07 OR g_cnd_t.cnd07 IS NULL THEN
               CALL i001_ins_check('1')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cnd.cnd01,g_errno,0)
                  NEXT FIELD cnd01
               END IF
            END IF
       
      #MOD-650015 --start  
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(cnd01) THEN
      #      LET g_cnd.* = g_cnd_t.*
      #      CALL i001_show()
      #      NEXT FIELD cnd01
      #   END IF
      #MOD-650015 --end
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(cnd01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_cob"
              LET g_qryparam.default1 = g_cnd.cnd01
              CALL cl_create_qry() RETURNING g_cnd.cnd01
              DISPLAY BY NAME g_cnd.cnd01
              NEXT FIELD cnd01
            WHEN INFIELD(cnd02)         #手冊編號
              CALL q_coc2(FALSE,TRUE,g_cnd.cnd02,'','','','','')
                   RETURNING g_cnd.cnd02,l_coc04
              DISPLAY BY NAME g_cnd.cnd02
              NEXT FIELD cnd02
           WHEN INFIELD(cnd07)
              IF g_cnd.cnd06='2' THEN
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc2"
                 LET g_qryparam.default1 = g_cnd.cnd07
                 CALL cl_create_qry() RETURNING g_cnd.cnd07
                 DISPLAY BY NAME g_cnd.cnd07
                 NEXT FIELD cnd07
              ELSE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_cnd.cnd07
                 CALL cl_create_qry() RETURNING g_cnd.cnd07
                 DISPLAY BY NAME g_cnd.cnd07
                 NEXT FIELD cnd07
              END IF
           WHEN INFIELD(cnd08)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gfe"
              LET g_qryparam.default1 = g_cnd.cnd08
              CALL cl_create_qry() RETURNING g_cnd.cnd08
              DISPLAY BY NAME g_cnd.cnd08
              NEXT FIELD cnd08
           OTHERWISE
              EXIT CASE
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
 
FUNCTION i001_cnd01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(01)
   l_cob02    LIKE cob_file.cob02,
   l_cob021   LIKE cob_file.cob021,
   l_cob04    LIKE cob_file.cob04,
   l_cobacti  LIKE cob_file.cobacti
 
   LET g_errno=''
   SELECT cob02,cob021,cob04,cobacti
     INTO l_cob02,l_cob021,l_cob04,l_cobacti
     FROM cob_file
    WHERE cob01=g_cnd.cnd01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aco-001'
                                LET l_cob02=NULL
                                LET l_cob021=NULL
                                LET l_cob04=NULL
       WHEN l_cobacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_cob02 TO FORMONLY.cob02
      DISPLAY l_cob021 TO FORMONLY.cob021
      LET g_cnd.cnd08=l_cob04
      DISPLAY BY NAME g_cnd.cnd08
#FUN-BB0084 -------------Begin---------------
      LET g_cnd.cnd09 = s_digqty(g_cnd.cnd09,g_cnd.cnd08)
      LET g_cnd.cnd10 = s_digqty(g_cnd.cnd10,g_cnd.cnd08)
      LET g_cnd.cnd11 = s_digqty(g_cnd.cnd11,g_cnd.cnd08)
      LET g_cnd.cnd12 = s_digqty(g_cnd.cnd12,g_cnd.cnd08)
      LET g_cnd.cnd13 = s_digqty(g_cnd.cnd13,g_cnd.cnd08)
      DISPLAY BY NAME g_cnd.cnd09,g_cnd.cnd10,g_cnd.cnd11,g_cnd.cnd12,g_cnd.cnd13
#FUN-BB0084 -------------End-----------------
   END IF
END FUNCTION
 
FUNCTION i001_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_cnd.* TO NULL            #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i001_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i001_count
    FETCH i001_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i001_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,0)
        INITIALIZE g_cnd.* TO NULL
    ELSE
        CALL i001_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i001_fetch(p_flcnd)
    DEFINE
        p_flcnd   LIKE type_file.chr1           #No.FUN-680069 VARCHAR(01)
 
    CASE p_flcnd
        WHEN 'N' FETCH NEXT     i001_cs INTO g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 
        WHEN 'P' FETCH PREVIOUS i001_cs INTO g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 
        WHEN 'F' FETCH FIRST    i001_cs INTO g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 
        WHEN 'L' FETCH LAST     i001_cs INTO g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 
        WHEN '/'
            IF (NOT mi_no_ask) THEN              #No.FUN-6A0059
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
            FETCH ABSOLUTE g_jump i001_cs INTO g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 
            LET mi_no_ask = FALSE   #No.FUN-6A0059
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,0)
        INITIALIZE g_cnd.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flcnd
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_cnd.* FROM cnd_file    # 重讀DB,因TEMP有不被更新特性
       WHERE cnd01 = g_cnd.cnd01 AND cnd02 = g_cnd.cnd02 AND cnd03 = g_cnd.cnd03 AND cnd04 = g_cnd.cnd04 AND cnd05 = g_cnd.cnd05 AND cnd06 = g_cnd.cnd06 AND cnd07 = g_cnd.cnd07 
    IF SQLCA.sqlcode THEN
 #     CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,0) #No.TQC-660045
       CALL cl_err3("sel","cnd_file",g_cnd.cnd01,g_cnd.cnd02,SQLCA.sqlcode,"","",1) #TQC-660045   
    ELSE
        LET g_data_owner=g_cnd.cnduser           #FUN-4C0044權限控管
        LET g_data_group=g_cnd.cndgrup
        LET g_data_plant = g_cnd.cndplant #FUN-980030
        CALL i001_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i001_show()
    LET g_cnd_t.* = g_cnd.*
    #No.FUN-9A0024--begin
    #DISPLAY BY NAME g_cnd.*
    DISPLAY BY NAME g_cnd.cnd01,g_cnd.cnd02,g_cnd.cnd03,g_cnd.cnd04,g_cnd.cnd05,
                    g_cnd.cnd08,g_cnd.cnd09,g_cnd.cnd06,g_cnd.cnd07,g_cnd.cnd10,
                    g_cnd.cnd11,g_cnd.cnd12,g_cnd.cnd13,g_cnd.cndconf,g_cnd.cnduser,
                    g_cnd.cndgrup,g_cnd.cndmodu,g_cnd.cnddate,g_cnd.cndacti,g_cnd.cndoriu,
                    g_cnd.cndorig
    #No.FUN-9A0024--end
    CALL i001_cnd01('d')
    CALL cl_set_field_pic(g_cnd.cndconf,"","","","",g_cnd.cndacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i001_u()
    IF (g_cnd.cnd01 IS NULL AND g_cnd.cnd02 IS NULL
       AND g_cnd.cnd03 IS NULL AND g_cnd.cnd04 IS NULL
       AND g_cnd.cnd05 IS NULL AND g_cnd.cnd06 IS NULL
       AND g_cnd.cnd07 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_cnd.cndacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnd.cndconf='Y' THEN
       CALL cl_err(g_cnd.cndconf,'9003',0)
       RETURN
    END IF
 
    SELECT * INTO g_cnd.* FROM cnd_file
     WHERE cnd01 = g_cnd.cnd01
       AND cnd02 = g_cnd.cnd02
       AND cnd03 = g_cnd.cnd03
       AND cnd04 = g_cnd.cnd04
       AND cnd05 = g_cnd.cnd05
       AND cnd06 = g_cnd.cnd06
       AND cnd07 = g_cnd.cnd07
    IF g_cnd.cndacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cnd01_t = g_cnd.cnd01
    LET g_cnd02_t = g_cnd.cnd02
    LET g_cnd03_t = g_cnd.cnd03
    LET g_cnd04_t = g_cnd.cnd04
    LET g_cnd05_t = g_cnd.cnd05
    LET g_cnd06_t = g_cnd.cnd06
    LET g_cnd07_t = g_cnd.cnd07
    BEGIN WORK
 
    OPEN i001_cl USING g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_cnd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,1)
       RETURN
    END IF
    LET g_cnd.cndmodu=g_user                  #修改者
    LET g_cnd.cnddate = g_today               #修改日期
    CALL i001_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i001_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cnd.*=g_cnd_t.*
            CALL i001_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cnd_file SET cnd_file.* = g_cnd.*    # 更新DB
            WHERE cnd01 = g_cnd.cnd01 AND cnd02 = g_cnd.cnd02 AND cnd03 = g_cnd.cnd03 AND cnd04 = g_cnd.cnd04 AND cnd05 = g_cnd.cnd05 AND cnd06 = g_cnd.cnd06 AND cnd07 = g_cnd.cnd07 
        IF SQLCA.sqlcode THEN
 #         CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,0) #No.TQC-660045
           CALL cl_err3("upd","cnd_file",g_cnd01_t,g_cnd02_t,SQLCA.sqlcode,"","",1) #TQC-660045
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_x()
    IF (g_cnd.cnd01 IS NULL AND g_cnd.cnd02 IS NULL
       AND g_cnd.cnd03 IS NULL AND g_cnd.cnd04 IS NULL
       AND g_cnd.cnd05 IS NULL AND g_cnd.cnd06 IS NULL
       AND g_cnd.cnd07 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_cnd.cndconf='Y' THEN
       CALL cl_err(g_cnd.cndconf,'9003',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i001_cl USING g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_cnd.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i001_show()
    IF cl_exp(0,0,g_cnd.cndacti) THEN
        LET g_chr=g_cnd.cndacti
        IF g_cnd.cndacti='Y' THEN
            LET g_cnd.cndacti='N'
        ELSE
            LET g_cnd.cndacti='Y'
        END IF
        UPDATE cnd_file
            SET cndacti=g_cnd.cndacti
            WHERE cnd01 = g_cnd.cnd01 AND cnd02 = g_cnd.cnd02 AND cnd03 = g_cnd.cnd03 AND cnd04 = g_cnd.cnd04 AND cnd05 = g_cnd.cnd05 AND cnd06 = g_cnd.cnd06 AND cnd07 = g_cnd.cnd07 
        IF SQLCA.SQLERRD[3]=0 THEN
 #          CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cnd_file",g_cnd.cnd01,g_cnd.cnd02,SQLCA.sqlcode,"","",1) #TQC-660045
            LET g_cnd.cndacti=g_chr
        END IF
        DISPLAY BY NAME g_cnd.cndacti
    END IF
    CALL cl_set_field_pic(g_cnd.cndconf,"","","","",g_cnd.cndacti)
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_r()
    IF (g_cnd.cnd01 IS NULL AND g_cnd.cnd02 IS NULL
       AND g_cnd.cnd03 IS NULL AND g_cnd.cnd04 IS NULL
       AND g_cnd.cnd05 IS NULL AND g_cnd.cnd06 IS NULL
       AND g_cnd.cnd07 IS NULL) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cnd.cndacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnd.cndconf='Y' THEN
       CALL cl_err(g_cnd.cndconf,'9003',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i001_cl USING g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 0)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_cnd.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i001_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cnd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cnd.cnd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM cnd_file
        WHERE cnd01 = g_cnd.cnd01
          AND cnd02 = g_cnd.cnd02
          AND cnd03 = g_cnd.cnd03
          AND cnd04 = g_cnd.cnd04
          AND cnd05 = g_cnd.cnd05
          AND cnd06 = g_cnd.cnd06
          AND cnd07 = g_cnd.cnd07
       CLEAR FORM
       OPEN i001_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i001_cs
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i001_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i001_cs
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i001_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i001_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE  #No.FUN-6A0059
          CALL i001_fetch('/')
       END IF
    END IF
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_y()
    IF (g_cnd.cnd01 IS NULL AND g_cnd.cnd02 IS NULL
       AND g_cnd.cnd03 IS NULL AND g_cnd.cnd04 IS NULL
       AND g_cnd.cnd05 IS NULL AND g_cnd.cnd06 IS NULL
       AND g_cnd.cnd07 IS NULL) THEN
       RETURN
    END IF
    SELECT * INTO g_cnd.* FROM cnd_file
     WHERE cnd01 = g_cnd.cnd01
       AND cnd02 = g_cnd.cnd02
       AND cnd03 = g_cnd.cnd03
       AND cnd04 = g_cnd.cnd04
       AND cnd05 = g_cnd.cnd05
       AND cnd06 = g_cnd.cnd06
       AND cnd07 = g_cnd.cnd07
    IF g_cnd.cndacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnd.cndconf='Y' THEN CALL cl_err(g_cnd.cndconf,'9003',0) RETURN END IF
 
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
    BEGIN WORK
    OPEN i001_cl USING g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_cnd.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    LET g_success = 'Y'
    UPDATE cnd_file SET cndconf='Y'
     WHERE cnd01 = g_cnd.cnd01
       AND cnd02 = g_cnd.cnd02
       AND cnd03 = g_cnd.cnd03
       AND cnd04 = g_cnd.cnd04
       AND cnd05 = g_cnd.cnd05
       AND cnd06 = g_cnd.cnd06
       AND cnd07 = g_cnd.cnd07
    COMMIT WORK
    SELECT cndconf INTO g_cnd.cndconf FROM cnd_file
    WHERE cnd01 = g_cnd.cnd01
      AND cnd02 = g_cnd.cnd02
      AND cnd03 = g_cnd.cnd03
      AND cnd04 = g_cnd.cnd04
      AND cnd05 = g_cnd.cnd05
      AND cnd06 = g_cnd.cnd06
      AND cnd07 = g_cnd.cnd07
    DISPLAY BY NAME g_cnd.cndconf
    CALL cl_set_field_pic(g_cnd.cndconf,"","","","",g_cnd.cndacti)
END FUNCTION
 
FUNCTION i001_z()
    IF (g_cnd.cnd01 IS NULL AND g_cnd.cnd02 IS NULL
       AND g_cnd.cnd03 IS NULL AND g_cnd.cnd04 IS NULL
       AND g_cnd.cnd05 IS NULL AND g_cnd.cnd06 IS NULL
       AND g_cnd.cnd07 IS NULL) THEN
       RETURN
    END IF
    SELECT * INTO g_cnd.* FROM cnd_file
     WHERE cnd01 = g_cnd.cnd01
       AND cnd02 = g_cnd.cnd02
       AND cnd03 = g_cnd.cnd03
       AND cnd04 = g_cnd.cnd04
       AND cnd05 = g_cnd.cnd05
       AND cnd06 = g_cnd.cnd06
       AND cnd07 = g_cnd.cnd07
    IF g_cnd.cndacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnd.cndconf='N' THEN RETURN END IF
 
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
    BEGIN WORK
    OPEN i001_cl USING g_cnd.cnd01, g_cnd.cnd02, g_cnd.cnd03, g_cnd.cnd04, g_cnd.cnd05, g_cnd.cnd06, g_cnd.cnd07 
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_cnd.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    LET g_success = 'Y'
    UPDATE cnd_file SET cndconf='N'
     WHERE cnd01 = g_cnd.cnd01
       AND cnd02 = g_cnd.cnd02
       AND cnd03 = g_cnd.cnd03
       AND cnd04 = g_cnd.cnd04
       AND cnd05 = g_cnd.cnd05
       AND cnd06 = g_cnd.cnd06
       AND cnd07 = g_cnd.cnd07
    COMMIT WORK
    SELECT cndconf INTO g_cnd.cndconf FROM cnd_file
    WHERE cnd01 = g_cnd.cnd01
      AND cnd02 = g_cnd.cnd02
      AND cnd03 = g_cnd.cnd03
      AND cnd04 = g_cnd.cnd04
      AND cnd05 = g_cnd.cnd05
      AND cnd06 = g_cnd.cnd06
      AND cnd07 = g_cnd.cnd07
    DISPLAY BY NAME g_cnd.cndconf
    CALL cl_set_field_pic(g_cnd.cndconf,"","","","",g_cnd.cndacti)
END FUNCTION
{
FUNCTION i001_copy()
    DEFINE l_cnt         LIKE type_file.num10          #No.FUN-680069 INTEGER
    DEFINE
        l_newno1         LIKE cnd_file.cnd01,
        l_newno2         LIKE cnd_file.cnd02,
        l_newno3         LIKE cnd_file.cnd03,
        l_newno4         LIKE cnd_file.cnd04,
        l_newno5         LIKE cnd_file.cnd05,
        l_newno6         LIKE cnd_file.cnd06,
        l_newno7         LIKE cnd_file.cnd07,
        l_oldno1         LIKE cnd_file.cnd01,
        l_oldno2         LIKE cnd_file.cnd02,
        l_oldno3         LIKE cnd_file.cnd03,
        l_oldno4         LIKE cnd_file.cnd04,
        l_oldno5         LIKE cnd_file.cnd05,
        l_oldno6         LIKE cnd_file.cnd06,
        l_oldno7         LIKE cnd_file.cnd07,
        l_coc04          LIKE coc_file.coc04,
        p_cmd            LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_input          LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
 
    IF (g_cnd.cnd01 IS NULL AND g_cnd.cnd02 IS NULL
       AND g_cnd.cnd03 IS NULL AND g_cnd.cnd04 IS NULL
       AND g_cnd.cnd05 IS NULL AND g_cnd.cnd06 IS NULL
       AND g_cnd.cnd07 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_cnd.cndacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnd.cndconf='Y' THEN
       CALL cl_err(g_cnd.cndconf,'9003',0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i001_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno1,l_newno2,l_newno3,l_newno4,
          l_newno5,l_newno6,l_newno7
     FROM cnd01,cnd02,cnd03,cnd04,cnd05,cnd06,cnd07
 
        AFTER FIELD cnd07
              SELECT count(*) INTO l_cnt FROM cnd_file
                  WHERE cnd01 = l_newno1
                    AND cnd02 = l_newno2
                    AND cnd03 = l_newno3
                    AND cnd04 = l_newno4
                    AND cnd05 = l_newno5
                    AND cnd06 = l_newno6
                    AND cnd07 = l_newno7
              IF l_cnt > 0 THEN
                  CALL cl_err(l_newno1,-239,0)
                  NEXT FIELD cnd01
              END IF
                  SELECT cob02,cob021
                  FROM cob_file
                  WHERE cob01= l_newno1
                  IF SQLCA.sqlcode THEN
                      DISPLAY BY NAME g_cnd.cnd01
                      LET l_newno1 = NULL
                      NEXT FIELD cnd01
                  END IF
 
 
 
        ON ACTION controlp                        # 沿用所有欄位
           CASE
             WHEN INFIELD(cnd01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cob"
                LET g_qryparam.default1 = g_cnd.cnd01
                CALL cl_create_qry() RETURNING l_newno1
                DISPLAY BY NAME l_newno1
                SELECT cob02,cob021
                FROM cob_file
                WHERE cob01= l_newno1
                IF SQLCA.sqlcode THEN
                   DISPLAY BY NAME g_cnd.cnd01
                   LET l_newno1 = NULL
                   NEXT FIELD cnd01
                END IF
                NEXT FIELD cnd01
              WHEN INFIELD(cnd02)         #手冊編號
                CALL q_coc2(FALSE,TRUE,g_cnd.cnd02,'','','','','')
                     RETURNING l_newno2,l_coc04
                DISPLAY BY NAME l_newno2
                NEXT FIELD cnd02
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
        DISPLAY BY NAME g_cnd.cnd01,g_cnd.cnd02,g_cnd.cnd03,g_cnd.cnd04,
                        g_cnd.cnd05,g_cnd.cnd06,g_cnd.cnd07
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM cnd_file
        WHERE cnd01 = g_cnd.cnd01 AND cnd02 = g_cnd.cnd02 AND cnd03 = g_cnd.cnd03 AND cnd04 = g_cnd.cnd04 AND cnd05 = g_cnd.cnd05 AND cnd06 = g_cnd.cnd06 AND cnd07 = g_cnd.cnd07 
        INTO TEMP x
    UPDATE x
        SET cnd01=l_newno1,    #資料鍵值
            cnd02=l_newno2,
            cnd03=l_newno3,
            cnd04=l_newno4,
            cnd05=l_newno5,
            cnd06=l_newno6,
            cnd07=l_newno7,
            cndacti='Y',      #資料有效碼
            cnduser=g_user,   #資料所有者
            cndgrup=g_grup,   #資料所有者所屬群
            cndmodu=NULL,     #資料修改日期
            cnddate=g_today   #資料建立日期
    INSERT INTO cnd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cnd.cnd01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("ins","cnd_file",g_cnd.cnd01,"",SQLCA.sqlcode,"","",1) #TQC-660045
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_cnd.cnd01
        LET g_cnd.cnd01 = l_newno1
        LET g_cnd.cnd02 = l_newno2
        LET g_cnd.cnd03 = l_newno3
        LET g_cnd.cnd04 = l_newno4
        LET g_cnd.cnd05 = l_newno5
        LET g_cnd.cnd06 = l_newno6
        LET g_cnd.cnd07 = l_newno7
        SELECT cnd_file.* INTO g_cnd.* FROM cnd_file
               WHERE cnd01=l_newno1
                 AND cnd02=l_newno2
                 AND cnd03=l_newno3
                 AND cnd04=l_newno4
                 AND cnd05=l_newno5
                 AND cnd06=l_newno6
                 AND cnd07=l_newno7
        CALL i001_u()
        SELECT cnd_file.* INTO g_cnd.* FROM cnd_file
               WHERE cnd01=l_oldno1
                 AND cnd02=l_oldno2
                 AND cnd03=l_oldno3
                 AND cnd04=l_oldno4
                 AND cnd05=l_oldno5
                 AND cnd06=l_oldno6
                 AND cnd07=l_oldno7
    END IF
    LET g_cnd.cnd01 = l_oldno1
    LET g_cnd.cnd02=l_oldno2
    LET g_cnd.cnd03=l_oldno3
    LET g_cnd.cnd04=l_oldno4
    LET g_cnd.cnd05=l_oldno5
    LET g_cnd.cnd06=l_oldno6
    LET g_cnd.cnd07=l_oldno7
    CALL i001_show()
END FUNCTION
}
FUNCTION i001_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("cnd01,cnd02,cnd03,cnd04,cnd05,cnd06,cnd07",TRUE)
     END IF
 
     IF INFIELD(cnd05) THEN
        CALL cl_set_comp_entry("cnd06,cnd07,cnd09,cnd10,cnd11,cnd12,cnd13",TRUE)
     END IF
 
     IF INFIELD(cnd07) THEN
        CALL cl_set_comp_entry("cnd10,cnd11,cnd12,cnd13",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i001_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("cnd01,cnd02,cnd03,cnd04,cnd05,cnd06,cnd07",FALSE)
    END IF
 
    IF INFIELD(cnd05) OR (NOT g_before_input_done) THEN
       IF g_cnd.cnd05 MATCHES '[123]' THEN
          LET g_cnd.cnd06 = ' '
          LET g_cnd.cnd07 = ' '
          LET g_cnd.cnd10 = 0
          LET g_cnd.cnd11 = 0
          LET g_cnd.cnd12 = 0
          LET g_cnd.cnd13 = 0
          DISPLAY BY NAME g_cnd.cnd06,g_cnd.cnd07,g_cnd.cnd10,
                          g_cnd.cnd11,g_cnd.cnd12,g_cnd.cnd13
          CALL cl_set_comp_entry("cnd06,cnd07,cnd10,cnd11,cnd12,cnd13",FALSE)
       END IF
       IF g_cnd.cnd05 = '4' THEN
          LET g_cnd.cnd09 = 0
          DISPLAY BY NAME g_cnd.cnd09
          CALL cl_set_comp_entry("cnd09",FALSE)
       END IF
    END IF
 
    IF INFIELD(cnd06) OR (NOT g_before_input_done) THEN
       IF g_cnd.cnd06 = '1' THEN
          LET g_cnd.cnd12 = 0
          LET g_cnd.cnd13 = 0
          DISPLAY BY NAME g_cnd.cnd12,g_cnd.cnd13
          CALL cl_set_comp_entry("cnd12,cnd13",FALSE)
       END IF
       IF g_cnd.cnd06 = '2' THEN
          LET g_cnd.cnd10 = 0
          LET g_cnd.cnd11 = 0
          DISPLAY BY NAME g_cnd.cnd10,g_cnd.cnd11
          CALL cl_set_comp_entry("cnd10,cnd11",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i001_ins_check(p_pos)
  DEFINE p_pos   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) #0.cnd05  1.cnd07/after input
 
    LET g_errno=''
    IF g_cnd.cnd05 MATCHES '[123]' THEN
       IF g_cnd.cnd06 IS NULL THEN LET g_cnd.cnd06 = ' ' END IF
       IF g_cnd.cnd07 IS NULL THEN LET g_cnd.cnd07 = ' ' END IF
    END IF
 
    #cnd05='1/2/3' 時cnd07不能key.所以在cnd05時檢查錯誤 cnd05='4'時cnd07處檢查
    IF p_pos = '0' AND g_cnd.cnd05 MATCHES '[123]' OR p_pos = '1' THEN
       SELECT COUNT(*) INTO g_cnt FROM cnd_file
        WHERE cnd01 = g_cnd.cnd01
          AND cnd02 = g_cnd.cnd02
          AND cnd03 = g_cnd.cnd03
          AND cnd04 = g_cnd.cnd04
          AND cnd05 = g_cnd.cnd05
          AND cnd06 = g_cnd.cnd06
          AND cnd07 = g_cnd.cnd07
       IF g_cnt > 0 THEN   #資料重復
          LET g_errno='-239'
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i001_set_required()
 
  IF g_cnd.cnd05 = '4' THEN
     CALL cl_set_comp_required("cnd06,cnd07",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION i001_set_no_required()
 
  CALL cl_set_comp_required("cnd06,cnd07",FALSE)
 
END FUNCTION

