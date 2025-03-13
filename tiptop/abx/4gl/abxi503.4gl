# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abxi503.4gl
# Descriptions...: 年度機器設備維護作業
# Date & Author..: 2006/10/13 By kim
# Modify.........: No.FUN-6A0058 06/10/19 By hongmei 將g_no_ask改為g_no_ask
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-740062 07/04/12 By wujie  去除預設上一筆功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860021 08/06/11 By Sarah PROMPT漏了controlg,help,about功能
# Modify.........: No.FUN-8C0090 08/12/17 By alex 調整unique key=bzg01,bzg02
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  將cl_used()改成標準，使用g_prog
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_bzg       RECORD LIKE bzg_file.*,  
       g_bzg_t     RECORD LIKE bzg_file.*,  #備份舊值
       g_bzg_o     RECORD LIKE bzg_file.*,  #備份舊值
       g_bzg01_t   LIKE bzg_file.bzg01,  #Key值份備
       g_bzg02_t   LIKE bzg_file.bzg02,  #Key值備份
       g_wc        STRING,              #儲存 user 的查詢條件
       g_sql       STRING                     #組 sql 用
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5       #判斷是否已執行 Before Input指令
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數 
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數
DEFINE g_no_ask             LIKE type_file.num5       #是否開啟指定筆視窗 #NO.FUN-6A0058 g_no_ask
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used('abxi503',g_time,1) RETURNING g_time   #FUN-B30211
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   INITIALIZE g_bzg.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM bzg_file WHERE bzg01 =? AND bzg02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i503_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i503_w WITH FORM "abx/42f/abxi503" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i503_menu()
 
   CLOSE WINDOW i503_w
   #CALL cl_used('abxi503',g_time,2) RETURNING g_time #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION i503_curs()
   DEFINE ls STRING
 
   CLEAR FORM
   INITIALIZE g_bzg.* TO NULL      #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        bzg01,bzg02,bzg03,bzg04,bzg05,bzg06,
        bzg07,bzg08,bzg09,bzg10,bzgacti,
        bzguser,bzggrup,bzgmodu,bzgdate
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION controlp
         CASE
            WHEN INFIELD(bzg02) #機器設備編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_bza1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bzg02
                 NEXT FIELD bzg02
            OTHERWISE EXIT CASE
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bzguser', 'bzggrup') #FUN-980030
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND bzguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND bzggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   LET g_sql = "SELECT bzg01,bzg02 FROM bzg_file ", #FUN-8C0090
               " WHERE ",g_wc CLIPPED, " ORDER BY bzg01,bzg02"
   PREPARE i503_prepare FROM g_sql
   DECLARE i503_cs                                # SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR i503_prepare
   LET g_sql = "SELECT COUNT(*) FROM bzg_file WHERE ",g_wc CLIPPED
   PREPARE i503_precount FROM g_sql
   DECLARE i503_count CURSOR FOR i503_precount
END FUNCTION
 
FUNCTION i503_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert 
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL i503_a()
           END IF
        ON ACTION query 
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL i503_q()
           END IF
        ON ACTION next 
           CALL i503_fetch('N')
        ON ACTION previous 
           CALL i503_fetch('P')
        ON ACTION modify 
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i503_u()
           END IF
        ON ACTION delete 
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
              CALL i503_r()
           END IF
        ON ACTION help 
           CALL cl_show_help()
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL i503_fetch('/')
        ON ACTION first
           CALL i503_fetch('F')
        ON ACTION last
           CALL i503_fetch('L')
        ON ACTION controlg
           CALL cl_cmdask()
        ON ACTION locale
           CALL cl_dynamic_locale()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
        ON ACTION about
           CALL cl_about()
        ON ACTION related_document
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_bzg.bzg01 IS NOT NULL AND g_bzg.bzg02 IS NOT NULL THEN
                LET g_doc.column1 = "bzg01"
                LET g_doc.column2 = "bzg02"
                LET g_doc.value1 = g_bzg.bzg01
                LET g_doc.value2 = g_bzg.bzg02
                CALL cl_doc()
             END IF
          END IF
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET g_action_choice = "exit"
           EXIT MENU
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i503_cs
END FUNCTION
 
FUNCTION i503_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_bzg.* LIKE bzg_file.*
    LET g_bzg01_t = NULL
    LET g_bzg02_t = NULL
    LET g_wc = NULL 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bzg.bzgacti="Y"        
        LET g_bzg.bzguser = g_user
        LET g_bzg.bzggrup = g_grup               #使用者所屬群
        LET g_bzg.bzgdate = g_today
        LET g_bzg.bzg01 =YEAR(g_today)  #年度
        LET g_bzg.bzg03 = 0             #期初數量 
        LET g_bzg.bzg04 = 0             #入庫數量
        LET g_bzg.bzg05 = 0             #外運數量
        LET g_bzg.bzg06 = 0             #報廢數量
        LET g_bzg.bzg07 = 0             #除帳數量
 
        LET g_bzg.bzgplant = g_plant    #FUN-980001 add
        LET g_bzg.bzglegal = g_legal    #FUN-980001 add
 
        CALL i503_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_bzg.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF cl_null(g_bzg.bzg01) OR cl_null(g_bzg.bzg02) THEN    # KEY 不可空白
           CONTINUE WHILE
        END IF
        LET g_bzg.bzgoriu = g_user      #No.FUN-980030 10/01/04
        LET g_bzg.bzgorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO bzg_file VALUES(g_bzg.*)     # DISK WRITE
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err(g_bzg.bzg01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        ELSE
           SELECT bzg01,bzg02 INTO g_bzg.bzg01,g_bzg.bzg02 FROM bzg_file
            WHERE bzg01 = g_bzg.bzg01
              AND bzg02 = g_bzg.bzg02
           LET g_bzg01_t=g_bzg.bzg01
           LET g_bzg02_t=g_bzg.bzg02
           LET g_bzg_t.*=g_bzg.*
           LET g_bzg_o.*=g_bzg.*
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i503_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_input   LIKE type_file.chr1,
            l_a       LIKE type_file.num20_6,
            l_n       LIKE type_file.num5
 
   INPUT BY NAME
      g_bzg.bzg01,g_bzg.bzg02,g_bzg.bzg03,
      g_bzg.bzg04,g_bzg.bzg05,g_bzg.bzg06,
      g_bzg.bzg07,g_bzg.bzg08,g_bzg.bzg09,
      g_bzg.bzg10,g_bzg.bzgacti,
      g_bzg.bzguser,g_bzg.bzggrup,
      g_bzg.bzgmodu,g_bzg.bzgdate
 
      WITHOUT DEFAULTS 
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i503_set_entry(p_cmd)
          CALL i503_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD bzg02
         DISPLAY "AFTER FIELD bzg02"
         IF NOT cl_null(g_bzg.bzg02) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND
               ( g_bzg.bzg01 != g_bzg01_t) OR
               ( g_bzg.bzg02 != g_bzg02_t)) THEN
               SELECT count(*) INTO l_n FROM bzg_file 
                WHERE bzg01 = g_bzg.bzg01
                  AND bzg02 = g_bzg.bzg02
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_bzg.bzg01,-239,1)
                  LET g_bzg.bzg02 = g_bzg02_t
                  DISPLAY BY NAME g_bzg.bzg02
                  NEXT FIELD bzg02
               ELSE
                  CALL i503_bzg02('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('bzg02:',g_errno,0)
                     LET g_bzg.bzg02 = g_bzg02_t
                     DISPLAY BY NAME g_bzg.bzg02 #ATTRIBUTE(YELLOW)   #TQC-8C0076
                     NEXT FIELD bzg02
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD bzg03
         IF NOT cl_null(g_bzg.bzg03) THEN
            IF g_bzg.bzg03 < 0 THEN
               CALL cl_err(g_bzg.bzg03,'aom-103',0)
               LET g_bzg.bzg03=g_bzg_o.bzg03
               DISPLAY BY NAME g_bzg.bzg03
               NEXT FIELD bzg03
            ELSE
               CALL i503_bzg08()
            END IF
            LET g_bzg_o.bzg03=g_bzg.bzg03
         END IF
 
      AFTER FIELD bzg04
         IF NOT cl_null(g_bzg.bzg04) THEN
            IF g_bzg.bzg04 < 0 THEN
               CALL cl_err(g_bzg.bzg04,'asf-745',0)
               LET g_bzg.bzg04=g_bzg_o.bzg04
               DISPLAY BY NAME g_bzg.bzg04
               NEXT FIELD bzg04
            ELSE
               CALL i503_bzg08()
            END IF
            LET g_bzg_o.bzg04=g_bzg.bzg04
         END IF
 
      AFTER FIELD bzg05
         IF NOT cl_null(g_bzg.bzg05) THEN
            IF g_bzg.bzg05 < 0 THEN
               CALL cl_err(g_bzg.bzg05,'asf-745',0)
               LET g_bzg.bzg05=g_bzg_o.bzg05
               DISPLAY BY NAME g_bzg.bzg05
               NEXT FIELD bzg05
            ELSE
               CALL i503_bzg08()
            END IF
            LET g_bzg_o.bzg05=g_bzg.bzg05
         END IF
 
      AFTER FIELD bzg06
         IF NOT cl_null(g_bzg.bzg06) THEN
            IF g_bzg.bzg06 < 0 THEN
               CALL cl_err(g_bzg.bzg06,'asf-745',0)
               LET g_bzg.bzg06=g_bzg_o.bzg06
               DISPLAY BY NAME g_bzg.bzg06
               NEXT FIELD bzg06
            ELSE
               CALL i503_bzg08()
            END IF
            LET g_bzg_o.bzg06=g_bzg.bzg06
         END IF
 
      AFTER FIELD bzg07
         IF NOT cl_null(g_bzg.bzg07) THEN
            IF g_bzg.bzg07 < 0 THEN
               CALL cl_err(g_bzg.bzg07,'asf-745',0)
               LET g_bzg.bzg07=g_bzg_o.bzg07
               DISPLAY BY NAME g_bzg.bzg07
               NEXT FIELD bzg07
            ELSE
               CALL i503_bzg08()
            END IF
            LET g_bzg_o.bzg07=g_bzg.bzg07
         END IF
 
      AFTER FIELD bzg09
         IF NOT cl_null(g_bzg.bzg09) THEN
            IF g_bzg.bzg09 < 0 THEN
               CALL cl_err(g_bzg.bzg09,'aom-103',0)
               LET g_bzg.bzg09=g_bzg_o.bzg09
               DISPLAY BY NAME g_bzg.bzg09
               NEXT FIELD bzg09
            ELSE
               LET l_a=(g_bzg.bzg09)-(g_bzg.bzg08)
               LET g_bzg.bzg10=g_bzg.bzg09
               DISPLAY BY NAME g_bzg.bzg10
               DISPLAY l_a TO FORMONLY.a 
            END IF
            LET g_bzg_o.bzg09=g_bzg.bzg09
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF cl_null(g_bzg.bzg01) OR cl_null(g_bzg.bzg02) THEN
            DISPLAY BY NAME g_bzg.bzg01,g_bzg.bzg02 
            LET l_input='Y'
         END IF
         IF l_input='Y' THEN
            NEXT FIELD bzg01
         END IF
         IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
            (p_cmd = "u" AND
            (g_bzg.bzg01 != g_bzg01_t) OR
            (g_bzg.bzg02 != g_bzg02_t)) THEN
            SELECT count(*) INTO l_n FROM bzg_file 
             WHERE bzg01 = g_bzg.bzg01
               AND bzg02 = g_bzg.bzg02
            IF l_n > 0 THEN                  # Duplicated
               CALL cl_err(g_bzg.bzg01,-239,1)
               LET g_bzg.bzg01 = g_bzg01_t
               LET g_bzg.bzg02 = g_bzg02_t
               DISPLAY BY NAME g_bzg.bzg01, g_bzg.bzg02
               NEXT FIELD bzg01
            END IF   
         END IF   
 
#No.TQC-740062--begin
#      ON ACTION CONTROLO                        # 沿用所有欄位
#         IF INFIELD(bzg01) THEN
#            LET g_bzg.* = g_bzg_t.*
#            CALL i503_show()
#            NEXT FIELD bzg01
#         END IF
#No.TQC-740062--end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
      ON ACTION controlp
         CASE
            WHEN INFIELD(bzg02) #機器設備編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_bza1"
                 LET g_qryparam.default1 = g_bzg.bzg02
                 CALL cl_create_qry() RETURNING g_bzg.bzg02
                 DISPLAY BY NAME g_bzg.bzg02
                 NEXT FIELD bzg02
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
   END INPUT
END FUNCTION
 
FUNCTION i503_bzg08()
   LET g_bzg.bzg08=
       g_bzg.bzg03+g_bzg.bzg04-g_bzg.bzg05-g_bzg.bzg06-g_bzg.bzg07
   DISPLAY BY NAME g_bzg.bzg08
END FUNCTION
 
FUNCTION i503_bzg02(p_cmd)
   DEFINE l_bza02   LIKE bza_file.bza02,
          l_bza03   LIKE bza_file.bza03,
          l_bza04   LIKE bza_file.bza04,
          l_bzaacti LIKE bza_file.bzaacti,
          p_cmd        LIKE type_file.chr1
 
   LET g_errno = " "
 
   SELECT bza02,bza03,bza04,bzaacti
     INTO l_bza02,l_bza03,l_bza04,l_bzaacti
     FROM bza_file WHERE bza01 = g_bzg.bzg02
 
   CASE WHEN SQLCA.SQLCODE = 100
             LET g_errno = 'abx-019'
             LET l_bza02 = NULL
             LET l_bza03 = NULL
             LET l_bza04 = NULL
        WHEN l_bzaacti='N'
             LET g_errno = '9028'
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_bza02 TO FORMONLY.bza02 
      DISPLAY l_bza03 TO FORMONLY.bza03
      DISPLAY l_bza04 TO FORMONLY.bza04
   END IF
END FUNCTION
 
FUNCTION i503_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   INITIALIZE g_bzg.* TO NULL
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i503_curs()                      # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_bzg.* TO NULL
      CLEAR FORM
      RETURN
   END IF
   OPEN i503_count
   FETCH i503_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt  
   OPEN i503_cs                          # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzg.bzg01,SQLCA.sqlcode,0)
      INITIALIZE g_bzg.* TO NULL
   ELSE
      CALL i503_fetch('F')              # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION i503_fetch(p_flbzg)
   DEFINE
        p_flbzg          LIKE type_file.chr1
 
   CASE p_flbzg                              #FUN-8C0090
        WHEN 'N' FETCH NEXT     i503_cs INTO g_bzg.bzg01,g_bzg.bzg02
        WHEN 'P' FETCH PREVIOUS i503_cs INTO g_bzg.bzg01,g_bzg.bzg02
        WHEN 'F' FETCH FIRST    i503_cs INTO g_bzg.bzg01,g_bzg.bzg02
        WHEN 'L' FETCH LAST     i503_cs INTO g_bzg.bzg01,g_bzg.bzg02
        WHEN '/'
            IF (NOT g_no_ask) THEN    #NO.FUN-6A0058 g_no_ask 
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON ACTION controlg       #TQC-860021
                     CALL cl_cmdask()      #TQC-860021
 
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about          #TQC-860021
                     CALL cl_about()       #TQC-860021
 
                  ON ACTION help           #TQC-860021
                     CALL cl_show_help()   #TQC-860021
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i503_cs INTO g_bzg.bzg01,g_bzg.bzg02
            LET g_no_ask = FALSE           #NO.FUN-6A0058 g_no_ask
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzg.bzg01,SQLCA.sqlcode,0)
      INITIALIZE g_bzg.* TO NULL
      RETURN
   ELSE
      CASE p_flbzg
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
 
   SELECT * INTO g_bzg.* FROM bzg_file    # 重讀DB,因TEMP有不被更新特性
    WHERE bzg01 = g_bzg.bzg01 AND bzg02 = g_bzg.bzg02
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzg.bzg01,SQLCA.sqlcode,0)
   ELSE
      CALL i503_show()                   # 重新顯示
   END IF
END FUNCTION
 
FUNCTION i503_show()
DEFINE  l_a       LIKE type_file.num20_6
 
   LET g_bzg_t.* = g_bzg.*
   LET g_bzg_o.* = g_bzg.*
   LET l_a=(g_bzg.bzg09)-(g_bzg.bzg08)
   #No.FUN-9A0024--begin
   #DISPLAY BY NAME g_bzg.*
   DISPLAY BY NAME g_bzg.bzg01,g_bzg.bzg02,g_bzg.bzg03,g_bzg.bzg04,g_bzg.bzg05,g_bzg.bzg06,
                   g_bzg.bzg07,g_bzg.bzg08,g_bzg.bzg09,g_bzg.bzg10,g_bzg.bzgacti,g_bzg.bzguser,
                   g_bzg.bzggrup,g_bzg.bzgmodu,g_bzg.bzgdate,g_bzg.bzgoriu,g_bzg.bzgorig 
   #No.FUN-9A0024--end
   DISPLAY l_a TO FORMONLY.a
   CALL i503_bzg02('d')
END FUNCTION
 
FUNCTION i503_u()
   IF cl_null(g_bzg.bzg01) OR cl_null(g_bzg.bzg02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_bzg.* FROM bzg_file WHERE bzg01=g_bzg.bzg01
                                         AND bzg02=g_bzg.bzg02
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_bzg01_t = g_bzg.bzg01
   LET g_bzg02_t = g_bzg.bzg02
   LET g_bzg_o.* = g_bzg.*
   BEGIN WORK
 
   OPEN i503_cl USING g_bzg.bzg01,g_bzg.bzg02
   IF STATUS THEN
      CALL cl_err("OPEN i503_cl:", STATUS, 1)
      CLOSE i503_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i503_cl INTO g_bzg.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzg.bzg01,SQLCA.sqlcode,1)
      RETURN
   END IF
   LET g_bzg.bzgmodu=g_user                  #修改者
   LET g_bzg.bzgdate = g_today               #修改日期
   CALL i503_show()                          # 顯示最新資料
   WHILE TRUE
        CALL i503_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_bzg.*=g_bzg_t.*
           LET g_bzg.*=g_bzg_o.*
           CALL i503_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE bzg_file SET bzg_file.* = g_bzg.*    # 更新DB
         WHERE bzg01 = g_bzg01_t AND bzg02 = g_bzg02_t 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err(g_bzg.bzg01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
   END WHILE
   CLOSE i503_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i503_r()
   IF cl_null(g_bzg.bzg01) OR cl_null(g_bzg.bzg02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i503_cl USING g_bzg.bzg01,g_bzg.bzg02
   IF STATUS THEN
      CALL cl_err("OPEN i503_cl:", STATUS, 0)
      CLOSE i503_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i503_cl INTO g_bzg.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzg.bzg01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL i503_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bzg01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "bzg02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bzg.bzg01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_bzg.bzg02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM bzg_file WHERE bzg01 = g_bzg.bzg01
                             AND bzg02 = g_bzg.bzg02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err('DELETE:',SQLCA.sqlcode,0)
         RETURN
      END IF
      CLEAR FORM
      OPEN i503_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i503_cs
         CLOSE i503_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i503_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i503_cs
         CLOSE i503_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i503_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i503_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE        #NO.FUN-6A0058 g_no_ask
         CALL i503_fetch('/')
      END IF
   END IF
   CLOSE i503_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i503_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bzg01,bzg02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i503_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("bzg01,bzg02",FALSE)
   END IF
END FUNCTION
