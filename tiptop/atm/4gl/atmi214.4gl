# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmi214.4gl
# Descriptions...: 廣告扣款單維護作業
# Date & Author..: 05/10/24 By yoyo
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.Fun-660104 06/06/15 By cl  Error Message 調整
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0043 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-710043 07/01/11 By Rayven “作廢”后，不能恢復到“開立”狀態
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790082 07/09/13 By lumxa 打印時程序名稱不應在“制表日期”下面
# Modify.........: No.FUN-7C0043 07/12/19 By Sunyanchun    老報表改成p_query 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/18 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-940020 09/05/07 By mike 無效資料應該可以復制,無效資料刪除時報錯有誤 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AC0363 10/12/27 By houlia 查詢時添加touoriu，touorig
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BC0125 11/12/21 By suncx 合約編號欄位沒有進行資料有效性檢查，應付憑單日期賦值有誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_tou       RECORD LIKE tou_file.*,
       g_tou_t     RECORD LIKE tou_file.*,  #備份舊值
       g_tou01_t   LIKE tou_file.tou01,     #Key值備份
       g_wc        string,                  #儲存 user 的查詢條件
       g_sql       STRING                  #組 sql 用
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令        #No.FUN-680120 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_chr1                LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_chr2                LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose            #No.FUN-680120 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數              #No.FUN-680120 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數      #No.FUN-680120 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5         #是否開啟指定筆視窗   #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5            #No.FUN-680120 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6B0014
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   INITIALIZE g_tou.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM tou_file WHERE tou01 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i214_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i214_w AT p_row,p_col WITH FORM "atm/42f/atmi214"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i214_menu()
 
   CLOSE WINDOW i214_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i214_curs()
DEFINE ls STRING
 
    CLEAR FORM
    INITIALIZE g_tou.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        tou01,tou02,tou03,tou04,tou05,tou06,tou07,tou08,tou09,
        touuser,tougrup,toumodu,toudate,touacti,touorig,touoriu,     #TQC-AC0363 add touorig,touoriu
        #FUN-840068   ---start---
        touud01,touud02,touud03,touud04,touud05,
        touud06,touud07,touud08,touud09,touud10,
        touud11,touud12,touud13,touud14,touud15
        #FUN-840068    ----end----
 
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tou03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_tol"
                 LET g_qryparam.where = "(tol13 = 'Y')"   #TQC-BC0125
                 LET g_qryparam.default1 = g_tou.tou03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tou03
                 NEXT FIELD tou03
               WHEN INFIELD(tou05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_apa"
                 LET g_qryparam.default1 = g_tou.tou05
                 LET g_qryparam.arg1 = '12'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tou05
                 NEXT FIELD tou05
              OTHERWISE
                 EXIT CASE
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
    #        LET g_wc = g_wc clipped," AND touuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND tougrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND tougrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('touuser', 'tougrup')
    #End:FUN-980030
 
    LET g_sql="SELECT tou01 FROM tou_file ",
        " WHERE ",g_wc CLIPPED, " ORDER BY tou01"
    PREPARE i214_prepare FROM g_sql
    DECLARE i214_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i214_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM tou_file WHERE ",g_wc CLIPPED
    PREPARE i214_precount FROM g_sql
    DECLARE i214_count CURSOR FOR i214_precount
END FUNCTION
 
FUNCTION i214_menu()
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i214_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i214_q()
            END IF
        ON ACTION void
            LET g_action_choice="void"
            IF cl_chk_act_auth() THEN
               CALL i214_t(1)
               IF g_tou.tou08='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               CALL cl_set_field_pic(g_tou.tou08,"","","",g_chr,g_tou.touacti)
            END IF
        #FUN-D20039 ------------sta
        ON ACTION undo_void
            LET g_action_choice="undo_void"
            IF cl_chk_act_auth() THEN
               CALL i214_t(2)
               IF g_tou.tou08='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               CALL cl_set_field_pic(g_tou.tou08,"","","",g_chr,g_tou.touacti)
            END IF
        #FUN-D20039 ------------end
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL i214_y()
               IF g_tou.tou08='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               CALL cl_set_field_pic(g_tou.tou08,"","","",g_chr,g_tou.touacti)
            END IF
        ON ACTION un_confirm
            LET g_action_choice="un_confirm"
            IF cl_chk_act_auth() THEN
               CALL i214_n()
               IF g_tou.tou08='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               CALL cl_set_field_pic(g_tou.tou08,"","","",g_chr,g_tou.touacti)
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                 CALL i214_out()
            END IF
        ON ACTION next
            CALL i214_fetch('N')
        ON ACTION previous
            CALL i214_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i214_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i214_x()
                 IF g_tou.tou08='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
                 CALL cl_set_field_pic(g_tou.tou08,"","","",g_chr,g_tou.touacti)
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i214_r()
            END IF
        ON ACTION reproduce
             LET g_action_choice="reproduce"
             IF cl_chk_act_auth() THEN
                  CALL i214_copy()
             END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i214_fetch('/')
        ON ACTION first
            CALL i214_fetch('F')
        ON ACTION last
            CALL i214_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
        ON ACTION related_document
           IF cl_chk_act_auth()  THEN
              IF g_tou.tou01 IS NOT NULL THEN
                 LET g_doc.column1 = "tou01"
                 LET g_doc.value1 = g_tou.tou01
                 CALL cl_doc()
              END IF
           END IF
        ON ACTION about
           CALL cl_about()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i214_cs
END FUNCTION
 
 
FUNCTION i214_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_tou.* LIKE tou_file.*
    LET g_tou01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tou.tou02 = g_today
        LET g_tou.touuser = g_user
        LET g_tou.touoriu = g_user #FUN-980030
        LET g_tou.touorig = g_grup #FUN-980030
        LET g_tou.tougrup = g_grup               #使用者所屬群
        LET g_tou.toudate = g_today
        LET g_tou.touacti = 'Y'
        LET g_tou.tou08 = 'N'
        LET g_tou.tou09 = '0'
       #LET g_tou.tou06 = 0     #TQC-BC0125 mark
        CALL i214_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_tou.* TO NULL
            LET INT_FLAG = 0
            CLEAR FORM
            EXIT WHILE
        END IF
        IF (g_tou.tou01 IS NULL) THEN
            CONTINUE WHILE
        END IF
        INSERT INTO tou_file VALUES(g_tou.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("ins","tou_file",g_tou.tou01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        ELSE
            SELECT tou01 INTO g_tou.tou01 FROM tou_file
                     WHERE tou01 = g_tou.tou01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i214_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
            l_flag    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
            l_input   LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
            l_n       LIKE type_file.num5,          #No.FUN-680120 SMALLINT
            l_edate   LIKE type_file.dat,           #No.FUN-680120 DATE
            l_bdate   LIKE type_file.dat,           #No.FUN-680120 DATE
            g_n       LIKE type_file.num5,          #No.FUN-680120 SMALLINT
            l_n1      LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
   DISPLAY BY NAME
        g_tou.tou01,g_tou.tou02,g_tou.tou03,g_tou.tou04,
        g_tou.tou05,g_tou.tou06,g_tou.tou07,g_tou.tou08,
        g_tou.tou09,g_tou.touuser,g_tou.tougrup,
        g_tou.toumodu,g_tou.toudate,g_tou.touacti
 
   INPUT BY NAME g_tou.touoriu,g_tou.touorig,
        g_tou.tou01,g_tou.tou02,g_tou.tou03,g_tou.tou04,g_tou.tou05,
        g_tou.tou07,
        #FUN-840068     ---start---
        g_tou.touud01,g_tou.touud02,g_tou.touud03,g_tou.touud04,
        g_tou.touud05,g_tou.touud06,g_tou.touud07,g_tou.touud08,
        g_tou.touud09,g_tou.touud10,g_tou.touud11,g_tou.touud12,
        g_tou.touud13,g_tou.touud14,g_tou.touud15 
        #FUN-840068     ----end----
 
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i214_set_entry(p_cmd)
          CALL i214_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD tou01
         IF NOT cl_null(g_tou.tou01) THEN
            IF p_cmd='a' OR (p_cmd='u' AND g_tou.tou01 != g_tou01_t) THEN
               SELECT count(*) INTO l_n1 FROM tou_file
                WHERE tou01 = g_tou.tou01
               IF l_n > 0 THEN
                  CALL cl_err(g_tou.tou01,-239,1)
                  LET g_tou.tou01 = g_tou01_t
                  DISPLAY BY NAME g_tou.tou01
                  NEXT FIELD tou01
               END IF
            END IF
         END IF
 
      AFTER FIELD tou03
         IF NOT cl_null(g_tou.tou03) THEN
            SELECT count(*) INTO l_n1 FROM tol_file
             WHERE tol01 = g_tou.tou03
               AND tolacti = 'Y'
               AND tol13 = 'Y'      #TQC-BC0125
            IF l_n1 <= 0 THEN
              CALL cl_err(g_tou.tou03,'atm-123',1)
              LET g_tou.tou03 = NULL
              NEXT FIELD tou03
            END IF
         END IF
 
      AFTER FIELD tou05
         IF NOT cl_null(g_tou.tou05) THEN
            SELECT count(*) INTO l_n1 FROM apa_file
             WHERE apa01 = g_tou.tou05
               AND apa00 = '12'
            IF l_n1 <= 0 THEN
               CALL cl_err(g_tou.tou05,'atm-124',1)
               LET g_tou.tou05=NULL
               NEXT FIELD tou05
            END IF
            CALL i214_tou05('d')
         END IF
 
        #FUN-840068     ---start---
        AFTER FIELD touud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD touud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
      AFTER INPUT
         LET g_tou.touuser = s_get_data_owner("tou_file") #FUN-C10039
         LET g_tou.tougrup = s_get_data_group("tou_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF (g_tou.tou01 IS NULL) THEN
               NEXT FIELD tou01
               LET l_input = 'Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD tou01
            END IF
 
       #MOD-650015 --start 
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #   IF INFIELD(tou01) THEN
       #      LET g_tou.* = g_tou_t.*
       #      CALL i214_show()
       #      NEXT FIELD tou01
       #   END IF
       #MOD-650015 --end
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(tou03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tol"
              LET g_qryparam.where = "(tol13 = 'Y')"   #TQC-BC0125
              LET g_qryparam.default1 = g_tou.tou03
              CALL cl_create_qry() RETURNING g_tou.tou03
              DISPLAY BY NAME g_tou.tou03
              NEXT FIELD tou03
            WHEN INFIELD(tou05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_apa"
              LET g_qryparam.default1 = g_tou.tou05
              LET g_qryparam.arg1 = '12'
              CALL cl_create_qry() RETURNING g_tou.tou05
              DISPLAY BY NAME g_tou.tou05
              NEXT FIELD tou05
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
   END INPUT
END FUNCTION
 
FUNCTION i214_tou05(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_apa02    LIKE apa_file.apa02,
   l_apaacti  LIKE apa_file.apaacti
 
   LET g_errno=''
   SELECT apa02,apaacti
     INTO l_apa02,l_apaacti
     FROM apa_file
    WHERE apa01=g_tou.tou05
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='atm-125'
                                LET l_apa02=NULL
       WHEN l_apaacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
      LET g_tou.tou06=l_apa02
      DISPLAY BY NAME g_tou.tou06
   END IF
END FUNCTION
 
FUNCTION i214_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tou.* TO NULL            #No.FUN-6B0043
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i214_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_tou.tou01 = NULL   #MOD-660086 add
        CLEAR FORM
        RETURN
    END IF
    OPEN i214_count
    FETCH i214_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i214_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)
        INITIALIZE g_tou.* TO NULL
    ELSE
        CALL i214_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i214_fetch(p_fltou)
    DEFINE
        p_fltou          LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
    CASE p_fltou
        WHEN 'N' FETCH NEXT     i214_cs INTO g_tou.tou01
        WHEN 'P' FETCH PREVIOUS i214_cs INTO g_tou.tou01
        WHEN 'F' FETCH FIRST    i214_cs INTO g_tou.tou01
        WHEN 'L' FETCH LAST     i214_cs INTO g_tou.tou01
        WHEN '/'
            IF (NOT mi_no_ask) THEN     #No.FUN-6A0072
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
            FETCH ABSOLUTE g_jump i214_cs INTO g_tou.tou01
            LET mi_no_ask = FALSE   #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)
        INITIALIZE g_tou.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_fltou
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_tou.* FROM tou_file    # 重讀DB,因TEMP有不被更新特性
       WHERE tou01 = g_tou.tou01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0) #No.FUN-660104
        CALL cl_err3("sel","tou_file",g_tou.tou01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
    ELSE
        LET g_data_owner=g_tou.touuser
        LET g_data_group=g_tou.tougrup
        CALL i214_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i214_show()
    LET g_tou_t.* = g_tou.*
    DISPLAY BY NAME g_tou.tou01,g_tou.tou02,g_tou.tou03,g_tou.tou04, g_tou.touoriu,g_tou.touorig,
                    g_tou.tou05,g_tou.tou06,g_tou.tou07,g_tou.tou08,
                    g_tou.tou09,g_tou.touuser,
                    g_tou.tougrup,g_tou.toumodu,g_tou.toudate,
                    g_tou.touacti,
                    #FUN-840068     ---start---
                    g_tou.touud01,g_tou.touud02,g_tou.touud03,g_tou.touud04,
                    g_tou.touud05,g_tou.touud06,g_tou.touud07,g_tou.touud08,
                    g_tou.touud09,g_tou.touud10,g_tou.touud11,g_tou.touud12,
                    g_tou.touud13,g_tou.touud14,g_tou.touud15 
                    #FUN-840068     ----end----
 
    CALL i214_tou05('d')
    IF g_tou.tou08='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_tou.tou08,"","","",g_chr,g_tou.touacti)
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i214_u()
    IF (g_tou.tou01 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_tou.touacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_tou.tou08='Y'  THEN
       CALL cl_err(g_tou.tou08,'atm-126',0)
       RETURN
    END IF
    IF g_tou.tou08='X' THEN
       CALL cl_err(g_tou.tou08,'atm-127',0)
       RETURN
    END IF
 
    SELECT * INTO g_tou.* FROM tou_file
     WHERE tou01 = g_tou.tou01
    IF g_tou.touacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tou01_t = g_tou.tou01
    BEGIN WORK
 
    OPEN i214_cl USING g_tou.tou01
    IF STATUS THEN
       CALL cl_err("OPEN i214_cl:", STATUS, 1)
       CLOSE i214_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i214_cl INTO g_tou.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tou.tou01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_tou.toumodu=g_user                  #修改者
    LET g_tou.toudate=g_today                 #修改日期
    CALL i214_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i214_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tou.*=g_tou_t.*
            CALL i214_show()
            EXIT WHILE
        END IF
        UPDATE tou_file SET tou_file.* = g_tou.*    # 更新DB
            WHERE tou01 = g_tou01_t
        IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("upd","tou_file",g_tou.tou01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i214_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i214_x()
    IF (g_tou.tou01 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_tou.tou08='Y' THEN
       CALL cl_err(g_tou.tou08,'atm-126',0)
       RETURN
    END IF
    IF g_tou.tou08='X' THEN
       CALL cl_err(g_tou.tou08,'atm-127',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i214_cl USING g_tou.tou01
    IF STATUS THEN
       CALL cl_err("OPEN i214_cl:", STATUS, 1)
       CLOSE i214_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i214_cl INTO g_tou.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tou.tou01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i214_show()
    IF cl_exp(0,0,g_tou.touacti) THEN
        LET g_chr=g_tou.touacti
        IF g_tou.touacti='Y' THEN
            LET g_tou.touacti='N'
        ELSE
            LET g_tou.touacti='Y'
        END IF
        UPDATE tou_file
            SET touacti=g_tou.touacti
            WHERE tou01 = g_tou.tou01
        IF SQLCA.SQLERRD[3]=0 THEN
        #   CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("upd","tou_file",g_tou.tou01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            LET g_tou.touacti=g_chr
        END IF
        DISPLAY BY NAME g_tou.touacti
        IF g_tou.tou08='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        CALL cl_set_field_pic(g_tou.tou08,"","","",g_chr,g_tou.touacti)
    END IF
    CLOSE i214_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i214_r()
    IF (g_tou.tou01 IS NULL) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_tou.touacti = 'N' THEN
       #CALL cl_err('',9027,0) #TQC-940020                                                                                     
        CALL cl_err('','abm-950',0) #TQC-940020  
        RETURN
    END IF
    IF g_tou.tou08='Y' THEN
       CALL cl_err(g_tou.tou08,'atm-126',0)
       RETURN
    END IF
    IF g_tou.tou08='X' THEN
       CALL cl_err(g_tou.tou08,'atm-127',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i214_cl USING g_tou.tou01
    IF STATUS THEN
       CALL cl_err("OPEN i214_cl:", STATUS, 0)
       CLOSE i214_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i214_cl INTO g_tou.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i214_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tou01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tou.tou01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM tou_file
        WHERE tou01 = g_tou.tou01
       CLEAR FORM
       OPEN i214_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i214_cs
          CLOSE i214_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i214_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i214_cs
          CLOSE i214_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i214_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i214_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE   #No.FUN-6A0072
          CALL i214_fetch('/')
       END IF
    END IF
    CLOSE i214_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i214_y()
DEFINE   l_tol11       LIKE tol_file.tol11
DEFINE   l_n           LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF (g_tou.tou01 IS NULL) THEN
       RETURN
    END IF
    SELECT * INTO g_tou.* FROM tou_file
     WHERE tou01 = g_tou.tou01
    IF g_tou.touacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_tou.tou08='Y' THEN
       CALL cl_err(g_tou.tou08,'atm-126',0)
       RETURN
    END IF
    IF g_tou.tou08='X' THEN
       CALL cl_err(g_tou.tou08,'atm-128',0)
       RETURN
    END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
 
    BEGIN WORK
 
    OPEN i214_cl USING g_tou.tou01
    IF STATUS THEN
       CALL cl_err("OPEN i214_cl:", STATUS, 1)
       CLOSE i214_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i214_cl INTO g_tou.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
 
    LET g_chr1 = g_tou.tou08
    LET g_chr2 = g_tou.tou09
    IF g_tou.tou08 = 'N' THEN
       LET g_tou.tou08 = 'Y'
       LET g_tou.tou09 = '1'
    END IF
    UPDATE tou_file
       SET tou08=g_tou.tou08,
           tou09=g_tou.tou09
     WHERE tou01 = g_tou.tou01
    IF SQLCA.SQLERRD[3]=0 THEN
    #  CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("upd","tou_file",g_tou.tou01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       LET g_tou.tou08=g_chr1
       LET g_tou.tou09=g_chr2
       RETURN
    END IF
    DISPLAY BY NAME g_tou.tou08
    DISPLAY BY NAME g_tou.tou09
    IF g_tou.tou08='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_tou.tou08,"","","",g_chr,g_tou.touacti)
    SELECT tol11 INTO l_tol11 from tol_file
     WHERE tol01=g_tou.tou03
    IF cl_null(l_tol11) THEN
       LET l_tol11=0
    END IF
    UPDATE tol_file
       SET tol11=l_tol11+g_tou.tou04
     WHERE tol01=g_tou.tou03
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
    #  CALL cl_err(l_tol11,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("upd","tol_file",g_tou.tou03,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
       RETURN
    END IF
    CLOSE i214_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i214_n()
DEFINE   l_tol11       LIKE tol_file.tol11
DEFINE   l_n           LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF (g_tou.tou01 IS NULL) THEN
       RETURN
    END IF
    SELECT * INTO g_tou.* FROM tou_file
     WHERE tou01 = g_tou.tou01
    IF g_tou.touacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_tou.tou08='N' THEN
       CALL cl_err(g_tou.tou08,'atm-129',0)
       RETURN
    END IF
    IF g_tou.tou08='X' THEN
       CALL cl_err(g_tou.tou08,'atm-128',0)
       RETURN
    END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
    BEGIN WORK
 
    OPEN i214_cl USING g_tou.tou01
    IF STATUS THEN
       CALL cl_err("OPEN i214_cl:", STATUS, 1)
       CLOSE i214_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i214_cl INTO g_tou.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
 
    LET g_chr1 = g_tou.tou08
    LET g_chr2 = g_tou.tou09
    IF g_tou.tou08 = 'Y' THEN
       LET g_tou.tou08 = 'N'
       LET g_tou.tou09 = '0'
    END IF
    UPDATE tou_file
       SET tou08=g_tou.tou08,
           tou09=g_tou.tou09
     WHERE tou01 = g_tou.tou01
    IF SQLCA.SQLERRD[3]=0 THEN
    #  CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("upd","tou_file",g_tou.tou01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       LET g_tou.tou08=g_chr1
       LET g_tou.tou09=g_chr2
       RETURN
    END IF
    DISPLAY BY NAME g_tou.tou08
    DISPLAY BY NAME g_tou.tou09
    IF g_tou.tou08='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_tou.tou08,"","","",g_chr,g_tou.touacti)
    SELECT tol11 INTO l_tol11 from tol_file
     WHERE tol01=g_tou.tou03
    IF cl_null(l_tol11) THEN
       LET l_tol11=0
    END IF
    UPDATE tol_file
       SET tol11=l_tol11-g_tou.tou04
     WHERE tol01=g_tou.tou03
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
    #  CALL cl_err(l_tol11,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("upd","tol_file",g_tou.tou03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    END IF
    CLOSE i214_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i214_t(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE   l_n           LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF (g_tou.tou01 IS NULL) THEN
       RETURN
    END IF
    SELECT * INTO g_tou.* FROM tou_file
     WHERE tou01 = g_tou.tou01
    IF g_tou.touacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_tou.tou08='X' THEN RETURN END IF
    ELSE
       IF g_tou.tou08<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
    IF g_tou.tou08='Y' THEN
       CALL cl_err(g_tou.tou08,'atm-126',0)
       RETURN
    END IF
#No.TQC-710043 --start-- mark 
#   IF g_tou.tou08='X' THEN
#      CALL cl_err(g_tou.tou08,'atm-128',0)
#      RETURN
#   END IF
#No.TQC-710043 --end--
    BEGIN WORK
 
    OPEN i214_cl USING g_tou.tou01
    IF STATUS THEN
       CALL cl_err("OPEN i214_cl:", STATUS, 1)
       CLOSE i214_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i214_cl INTO g_tou.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
 
    LET g_chr1 = g_tou.tou08
    LET g_chr2 = g_tou.tou09
    IF g_tou.tou08 = 'N' THEN
       LET g_tou.tou08 = 'X'
       LET g_tou.tou09 = '9'
    #No.TQC-710043 --start--
#   END IF
    ELSE
       IF g_tou.tou08 = 'X' THEN
          LET g_tou.tou08 = 'N'
          LET g_tou.tou09 = '0'
       END IF
    END IF
    #No.TQC-710043 --end--
    UPDATE tou_file
       SET tou08=g_tou.tou08,
           tou09=g_tou.tou09
     WHERE tou01 = g_tou.tou01
    IF SQLCA.SQLERRD[3]=0 THEN
    #  CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)  #No.FUN-660104
       CALL cl_err3("upd","tou_file",g_tou.tou01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       LET g_tou.tou08=g_chr1
       LET g_tou.tou09=g_chr2
    END IF
    DISPLAY BY NAME g_tou.tou08
    DISPLAY BY NAME g_tou.tou09
    IF g_tou.tou08='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_tou.tou08,"","","",g_chr,g_tou.touacti)
    CLOSE i214_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i214_copy()
    DEFINE l_cnt         LIKE type_file.num10            #No.FUN-680120 INTEGER   
    DEFINE
        l_newno1         LIKE tou_file.tou01,
        l_oldno1         LIKE tou_file.tou01,
        p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_flag    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_bdate   LIKE type_file.dat,           #No.FUN-680120 DATE
        l_edate   LIKE type_file.dat,           #No.FUN-680120 DATE
        g_n       LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_input   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF (g_tou.tou01 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
#TQC-940020  -----start                                                                                                             
   #IF g_tou.touacti = 'N' THEN                                                                                                     
   #    CALL cl_err('',9028,0)                                                                                                      
   #    RETURN                                                                                                                      
   #END IF                                                                                                                          
#TQC-940020  -----end  
 
    LET g_before_input_done = FALSE
    CALL i214_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno1
     FROM tou01
 
        AFTER FIELD tou01
          IF l_newno1 IS NOT NULL THEN
             SELECT count(*) INTO g_cnt FROM tou_file
              WHERE tou01=l_newno1
             IF g_cnt > 0 THEN
                CALL cl_err(l_newno1,-239,0)
                NEXT FIELD tou01
             END IF
          END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_tou.tou01
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM tou_file
        WHERE tou01 = g_tou.tou01
        INTO TEMP y
    UPDATE y
        SET tou01=l_newno1,   #資料鍵值
            touacti='Y',      #資料有效碼
            tou08='N',
            tou09='0',
            touuser=g_user,   #資料所有者
            tougrup=g_grup,   #資料所有者所屬群
            toumodu=NULL,     #資料修改日期
            toudate=g_today   #資料建立日期
    INSERT INTO tou_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tou.tou01,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("ins","tou_file",g_tou.tou01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_tou.tou01
        LET g_tou.tou01 = l_newno1
        SELECT tou_file.* INTO g_tou.* FROM tou_file
               WHERE tou01=l_newno1
        CALL i214_u()
        #SELECT tou_file.* INTO g_tou.* FROM tou_file #FUN-C80046
        #       WHERE tou01=l_oldno1                  #FUN-C80046
    END IF
    #LET g_tou.tou01 = l_oldno1  #FUN-C80046
    CALL i214_show()
END FUNCTION
#NO.FUN-7C0043---Begin
FUNCTION i214_out()
#   DEFINE
#       l_tou           RECORD LIKE tou_file.*,
#       l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
#       l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)               # External(Disk) file name
#       l_za05          LIKE za_file.za05,
#       sr              RECORD
#                       tou        RECORD LIKE tou_file.*
#                       END RECORD
    DEFINE l_cmd  LIKE type_file.chr1000
 
    IF cl_null(g_wc) AND NOT cl_null(g_tou.tou01) THEN                                                                              
       LET g_wc=" tou01='",g_tou.tou01,"'"                                                                                          
    END IF                                                                                                                          
    IF g_wc IS NULL THEN CALL cl_err('','9057',0)  RETURN END IF                                                                    
    LET l_cmd = 'p_query "atmi214" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)
 
#   IF cl_null(g_wc) THEN
#      LET g_wc=" tou01='",g_tou.tou01,"'"
#   END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#   LET g_sql="SELECT tou_file.* ",
#             "  FROM tou_file ",
#             " WHERE ",g_wc CLIPPED
 
#   PREPARE i214_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i214_co                         # CURSOR
#       CURSOR FOR i214_p1
 
#   CALL cl_outnam('atmi214') RETURNING l_name
#   START REPORT i214_rep TO l_name
 
#   FOREACH i214_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i214_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i214_rep
 
#   CLOSE i214_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i214_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#       sr              RECORD
#                       tou        RECORD LIKE tou_file.*
#                       END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.tou.tou01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#           PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #TQC-790082
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #TQC-790082
#           PRINT ' '
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#                 g_x[35],g_x[36],g_x[37],g_x[38],
#                 g_x[39]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.tou.tou01 CLIPPED,
#                 COLUMN g_c[32],sr.tou.tou02 CLIPPED,
#                 COLUMN g_c[33],sr.tou.tou03 CLIPPED,
#                 COLUMN g_c[34],cl_numfor(sr.tou.tou04,34,g_azi04),
#                 COLUMN g_c[35],sr.tou.tou05 CLIPPED,
#                 COLUMN g_c[36],sr.tou.tou06 CLIPPED,
#                 COLUMN g_c[37],sr.tou.tou07 CLIPPED,
#                 COLUMN g_c[38],sr.tou.tou08 CLIPPED,
#                 COLUMN g_c[39],sr.tou.tou09
#
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043----End
FUNCTION i214_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("tou01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i214_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("tou01",FALSE)
    END IF
 
END FUNCTION

