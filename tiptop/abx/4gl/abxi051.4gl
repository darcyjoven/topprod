# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abxi051.4gl
# Descriptions...: 受託加工原料餘量月檔維護作業 
# Date & Author..: 2006/10/20 By kim
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-780042 07/08/15 By jamie 修改時出現-201的錯誤，將FOR UPDATE ->FOR UPDATE
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bxd       RECORD LIKE bxd_file.*,
    g_bxd_t     RECORD LIKE bxd_file.*,
    g_bxd_o     RECORD LIKE bxd_file.*,
    g_bxd01_t   LIKE bxd_file.bxd01,
    g_bxd03_t   LIKE bxd_file.bxd03,
    g_bxd04_t   LIKE bxd_file.bxd04,
    g_bxd05_t   LIKE bxd_file.bxd05,
    g_bxd06_t   LIKE bxd_file.bxd06,
    g_wc,g_sql  STRING 
 
DEFINE g_forupd_sql          STRING       #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.chr1 
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask             LIKE type_file.num5
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABX")) THEN 
       EXIT PROGRAM
    END IF
    
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_bxd.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM bxd_file WHERE bxd01 = ? AND bxd03 = ? AND bxd04 = ? AND bxd05 = ? AND bxd06 = ? FOR UPDATE "       #TQC-780042 mod
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i051_cl CURSOR FROM g_forupd_sql         # LOCK CURSOR
 
    OPEN WINDOW i051_w WITH FORM "abx/42f/abxi051" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    LET g_action_choice=""
    CALL i051_menu()
 
    CLOSE WINDOW i051_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i051_curs()
   IF g_action_choice = "query" THEN
      CLEAR FORM
      INITIALIZE g_bxd.* TO NULL      #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          bxd01,bxd03,bxd04,bxd05,bxd06,
          bxd07,bxd11,bxd12,bxd13,bxd16,bxd17,
          bxd08,bxd09,bxd10,bxd14,bxd15,bxd18
 
             BEFORE CONSTRUCT
                CALL cl_qbe_init()
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(bxd01)
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.state = 'c' 
            #   LET g_qryparam.form = "q_ima20"
            #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_ima20","","","","","","","",'')  RETURNING  g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bxd01
               NEXT FIELD bxd01
  
             WHEN INFIELD(bxd05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = "q_oea05"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bxd05
               NEXT FIELD bxd05
 
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
 
        ON ACTION CONTROLG 
           CALL cl_cmdask() 
 
                ON ACTION qbe_select
                  CALL cl_qbe_select()
                ON ACTION qbe_save
                  CALL cl_qbe_save()
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    ELSE
       OPEN WINDOW i051_query_w AT 5,20 WITH FORM "abx/42f/abxi051_x" 
            ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
       CALL cl_ui_locale("abxi051_x")
       CLEAR FORM
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           bxe01,bxe02,bxe03
 
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(bxe01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c' 
                LET g_qryparam.form = "q_bxe01"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO bxe01
                NEXT FIELD bxe01
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
 
         ON ACTION CONTROLG 
            CALL cl_cmdask() 
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CONTINUE CONSTRUCT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
       END CONSTRUCT
       CLOSE WINDOW i051_query_w
    END IF
    IF g_action_choice = "query" THEN
       LET g_sql = 
             "SELECT bxd01,bxd03,bxd04,bxd05,bxd06 ",
             "  FROM bxd_file ", 
             " WHERE ",g_wc CLIPPED,
             " ORDER BY bxd01,bxd03,bxd04,bxd05,bxd06 "
    ELSE
       LET g_sql = 
             "SELECT bxd_file.bxd01,bxd03,bxd04,",
             "       bxd05,bxd06 ",
             "  FROM bxe_file,ima_file,bxd_file ", 
             " WHERE bxe01 = ima1916 ",
             "   AND ima01 = bxd01 ",
             "   AND ",g_wc CLIPPED,
             " ORDER BY bxd01,bxd03,bxd04,bxd05,bxd06 "
    END IF
    PREPARE i051_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i051_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i051_prepare
 
    IF g_action_choice = "query" THEN
       LET g_sql=
           "SELECT COUNT(*) FROM bxd_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql=
           "SELECT COUNT(*) FROM bxe_file,ima_file,bxd_file ",
           " WHERE bxe01 = ima1916 ",
           "   AND ima01 = bxd01 ",
           "   AND ",g_wc CLIPPED
    END IF
    PREPARE i051_cntpre FROM g_sql
    DECLARE i051_count CURSOR FOR i051_cntpre
END FUNCTION
 
FUNCTION i051_menu()
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting(g_curs_index,g_row_count)
 
        ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL i051_a()
           END IF
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL i051_q()
           END IF
 
        ON ACTION first
           CALL i051_fetch('F')
 
        ON ACTION previous
           CALL i051_fetch('P')
 
        ON ACTION jump
           CALL i051_fetch('/')
 
        ON ACTION next
           CALL i051_fetch('N')
 
        ON ACTION last
           CALL i051_fetch('L')
 
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i051_u()
           END IF
 
        ON ACTION delete
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
              CALL i051_r()
           END IF
 
        ON ACTION group_query
           LET g_action_choice="group_query"
           IF cl_chk_act_auth() THEN
              CALL i051_q()
           END IF
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont() 
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about 
           CALL cl_about() 
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_bxd.bxd01 IS NOT NULL AND g_bxd.bxd03 IS NOT NULL AND g_bxd.bxd04 IS NOT NULL AND g_bxd.bxd05 IS NOT NULL AND g_bxd.bxd06 IS NOT NULL  THEN
                LET g_doc.column1 = "bxd01"
                LET g_doc.value1 = g_bxd.bxd01
                LET g_doc.column2 = "bxd03"
                LET g_doc.value2 = g_bxd.bxd03
                LET g_doc.column3 = "bxd04"
                LET g_doc.value3 = g_bxd.bxd04
                LET g_doc.column4 = "bxd05"
                LET g_doc.value4 = g_bxd.bxd05
                LET g_doc.column5 = "bxd06"
                LET g_doc.value5 = g_bxd.bxd06
                CALL cl_doc()
             END IF
          END IF
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i051_cs
END FUNCTION
 
FUNCTION i051_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_bxd.* LIKE bxd_file.*
    LET g_bxd01_t = NULL
    LET g_bxd03_t = NULL
    LET g_bxd04_t = NULL
    LET g_bxd05_t = NULL
    LET g_bxd06_t = NULL
    LET g_bxd.bxd07 = 0
    LET g_bxd.bxd08 = 0
    LET g_bxd.bxd09 = 0
    LET g_bxd.bxd10 = 0
    LET g_bxd.bxd11 = 0
    LET g_bxd.bxd12 = 0
    LET g_bxd.bxd13 = 0 
    LET g_bxd.bxd14 = 0
    LET g_bxd.bxd15 = 0
    LET g_bxd.bxd16 = 0
    LET g_bxd.bxd17 = 0
    LET g_bxd.bxd18 = 0
 
    LET g_bxd.bxdplant = g_plant #FUN-980001 add
    LET g_bxd.bxdlegal = g_legal #FUN-980001 add
 
    LET g_bxd_t.* = g_bxd.*
    LET g_bxd_o.* = g_bxd.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i051_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                      # 若按了DEL鍵
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           INITIALIZE g_bxd.* LIKE bxd_file.*
           LET g_bxd01_t = NULL
           LET g_bxd03_t = NULL
           LET g_bxd04_t = NULL
           LET g_bxd05_t = NULL
           LET g_bxd06_t = NULL
           EXIT WHILE
        END IF
        IF cl_null(g_bxd.bxd01) OR 
           cl_null(g_bxd.bxd03) OR 
           cl_null(g_bxd.bxd04) OR 
           cl_null(g_bxd.bxd05) OR 
           cl_null(g_bxd.bxd06) THEN 
           CONTINUE WHILE
        END IF
        INSERT INTO bxd_file VALUES(g_bxd.*)       # DISK WRITE
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err('',SQLCA.SQLCODE,0)
           CONTINUE WHILE
        ELSE
           LET g_bxd_t.* = g_bxd.*                # 保存上筆資料
           SELECT bxd01,bxd03,bxd04,bxd05,bxd06 INTO g_bxd.bxd01,g_bxd.bxd03,g_bxd.bxd04,g_bxd.bxd05,g_bxd.bxd06 FROM bxd_file
            WHERE bxd01 = g_bxd.bxd01
              AND bxd03 = g_bxd.bxd03
              AND bxd04 = g_bxd.bxd04
              AND bxd05 = g_bxd.bxd05
              AND bxd06 = g_bxd.bxd06
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i051_i(p_cmd)
  DEFINE  p_cmd           LIKE type_file.chr1
  DEFINE  l_cnt           LIKE type_file.num5
 
  INPUT BY NAME g_bxd.bxd01,g_bxd.bxd03,g_bxd.bxd04,
                g_bxd.bxd05,g_bxd.bxd06,g_bxd.bxd07,
                g_bxd.bxd11,g_bxd.bxd12,g_bxd.bxd13,
                g_bxd.bxd16,g_bxd.bxd17,g_bxd.bxd08,
                g_bxd.bxd09,g_bxd.bxd10,g_bxd.bxd14,
                g_bxd.bxd15,g_bxd.bxd18
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i051_set_entry(p_cmd)
           CALL i051_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD bxd01
           IF NOT cl_null(g_bxd.bxd01) THEN
              #FUN-AA0059 --------------------------add start-------------------
              IF NOT s_chk_item_no(g_bxd.bxd01,'') THEN
                 CALL cl_err('',g_errno,1)
                 LET g_bxd.bxd01 = g_bxd_o.bxd01
                 DISPLAY BY NAME g_bxd.bxd01
                 NEXT FIELD bxd01
              END IF 
              #FUN-AA0059 -------------------------add end----------------------` 
              CALL i051_bxd01('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_bxd.bxd01,g_errno,0)
                 LET g_bxd.bxd01 = g_bxd_o.bxd01
                 DISPLAY BY NAME g_bxd.bxd01
                 NEXT FIELD bxd01
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd01) OR
                 g_bxd.bxd01 != g_bxd_o.bxd01) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              DISPLAY ' ' TO FORMONLY.ima02
              DISPLAY ' ' TO FORMONLY.ima021
              DISPLAY ' ' TO FORMONLY.ima1916
              DISPLAY ' ' TO FORMONLY.bxe02
              DISPLAY ' ' TO FORMONLY.bxe03
           END IF
           LET g_bxd_o.bxd01 = g_bxd.bxd01
 
        AFTER FIELD bxd03
           IF NOT cl_null(g_bxd.bxd03) THEN
              IF g_bxd.bxd03 < 0 THEN
                 CALL cl_err(g_bxd.bxd03,'aom-103',0)
                 LET g_bxd.bxd03 = g_bxd_o.bxd03
                 DISPLAY BY NAME g_bxd.bxd03
                 NEXT FIELD bxd03
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd03) OR
                 g_bxd.bxd03 != g_bxd_o.bxd03) THEN 
                 CALL i051_bxd18('1')
              END IF
           END IF
           LET g_bxd_o.bxd03 = g_bxd.bxd03
 
        AFTER FIELD bxd04
           IF NOT cl_null(g_bxd.bxd04) THEN
              IF g_bxd.bxd04 < 1 OR g_bxd.bxd04 > 12 THEN
                 CALL cl_err(g_bxd.bxd04,'aom-580',0)
                 LET g_bxd.bxd04 = g_bxd_o.bxd04
                 DISPLAY BY NAME g_bxd.bxd04
                 NEXT FIELD bxd04
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd04) OR
                 g_bxd.bxd04 != g_bxd_o.bxd04) THEN 
                 CALL i051_bxd18('1')
              END IF
           END IF
           LET g_bxd_o.bxd04 = g_bxd.bxd04
 
        AFTER FIELD bxd05
           IF NOT cl_null(g_bxd.bxd05) THEN
              CALL i051_bxd05('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_bxd.bxd05,g_errno,0)
                 LET g_bxd.bxd05 = g_bxd_o.bxd05
                 DISPLAY BY NAME g_bxd.bxd05
                 NEXT FIELD bxd05
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd05) OR
                 g_bxd.bxd05 != g_bxd_o.bxd05) THEN 
                 CALL i051_bxd18('1')
              END IF
           END IF
           LET g_bxd_o.bxd05 = g_bxd.bxd05
 
        AFTER FIELD bxd06
           IF NOT cl_null(g_bxd.bxd06) THEN
              IF NOT cl_null(g_bxd.bxd05) THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt
                   FROM oeb_file
                  WHERE oeb01 = g_bxd.bxd05
                    AND oeb03 = g_bxd.bxd06
                 IF l_cnt = 0 THEN
                    CALL cl_err(g_bxd.bxd06,'axm-141',0)
                    LET g_bxd.bxd06 = g_bxd_o.bxd06
                    DISPLAY BY NAME g_bxd.bxd06
                    NEXT FIELD bxd06
                 END IF
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd06) OR
                 g_bxd.bxd06 != g_bxd_o.bxd06) THEN 
                 CALL i051_bxd18('1')
              END IF
              IF NOT cl_null(g_bxd.bxd01) AND
                 NOT cl_null(g_bxd.bxd03) AND
                 NOT cl_null(g_bxd.bxd04) AND
                 NOT cl_null(g_bxd.bxd05) THEN
                 IF p_cmd = 'a' OR
                   (p_cmd = 'u' AND ((g_bxd.bxd01 != g_bxd_t.bxd01) OR
                                     (g_bxd.bxd03 != g_bxd_t.bxd03) OR
                                     (g_bxd.bxd04 != g_bxd_t.bxd04) OR
                                     (g_bxd.bxd05 != g_bxd_t.bxd05) OR
                                     (g_bxd.bxd06 != g_bxd_t.bxd06))) THEN
                    LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt
                      FROM bxd_file
                     WHERE bxd01 = g_bxd.bxd01
                       AND bxd03 = g_bxd.bxd03
                       AND bxd04 = g_bxd.bxd04
                       AND bxd05 = g_bxd.bxd05
                       AND bxd06 = g_bxd.bxd06
                    IF l_cnt > 0 THEN
                       CALL cl_err('',-239,0)
                       NEXT FIELD bxd01
                    END IF
                 END IF
              END IF
           END IF
           LET g_bxd_o.bxd06 = g_bxd.bxd06
 
        AFTER FIELD bxd07
           IF NOT cl_null(g_bxd.bxd07) THEN
              IF g_bxd.bxd07 < 0 THEN
                 CALL cl_err(g_bxd.bxd07,'aom-103',0)
                 LET g_bxd.bxd07 = g_bxd_o.bxd07
                 DISPLAY BY NAME g_bxd.bxd07
                 NEXT FIELD bxd07
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd07) OR
                 g_bxd.bxd07 != g_bxd_o.bxd07) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF 
           LET g_bxd_o.bxd07 = g_bxd.bxd07
 
        AFTER FIELD bxd08
           IF NOT cl_null(g_bxd.bxd08) THEN
              IF g_bxd.bxd08 < 0 THEN
                 CALL cl_err(g_bxd.bxd08,'aom-103',0)
                 LET g_bxd.bxd08 = g_bxd_o.bxd08
                 DISPLAY BY NAME g_bxd.bxd08
                 NEXT FIELD bxd08
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd08) OR
                 g_bxd.bxd08 != g_bxd_o.bxd08) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF 
           LET g_bxd_o.bxd08 = g_bxd.bxd08
 
        AFTER FIELD bxd09
           IF NOT cl_null(g_bxd.bxd09) THEN
              IF g_bxd.bxd09 < 0 THEN
                 CALL cl_err(g_bxd.bxd09,'aom-103',0)
                 LET g_bxd.bxd09 = g_bxd_o.bxd09
                 DISPLAY BY NAME g_bxd.bxd09
                 NEXT FIELD bxd09
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd09) OR
                 g_bxd.bxd09 != g_bxd_o.bxd09) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF
           LET g_bxd_o.bxd09 = g_bxd.bxd09
 
        AFTER FIELD bxd10
           IF NOT cl_null(g_bxd.bxd10) THEN
              IF g_bxd.bxd10 < 0 THEN
                 CALL cl_err(g_bxd.bxd10,'aom-103',0)
                 LET g_bxd.bxd10 = g_bxd_o.bxd10
                 DISPLAY BY NAME g_bxd.bxd10
                 NEXT FIELD bxd10
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd10) OR
                 g_bxd.bxd10 != g_bxd_o.bxd10) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN 
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF 
           LET g_bxd_o.bxd10 = g_bxd.bxd10
 
        AFTER FIELD bxd11
           IF NOT cl_null(g_bxd.bxd11) THEN
              IF g_bxd.bxd11 < 0 THEN
                 CALL cl_err(g_bxd.bxd11,'aom-103',0)
                 LET g_bxd.bxd11 = g_bxd_o.bxd11
                 DISPLAY BY NAME g_bxd.bxd11
                 NEXT FIELD bxd11
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd11) OR
                 g_bxd.bxd11 != g_bxd_o.bxd11) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN 
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF 
           LET g_bxd_o.bxd11 = g_bxd.bxd11
 
        AFTER FIELD bxd12
           IF NOT cl_null(g_bxd.bxd12) THEN
              IF g_bxd.bxd12 < 0 THEN
                 CALL cl_err(g_bxd.bxd12,'aom-103',0)
                 LET g_bxd.bxd12 = g_bxd_o.bxd12
                 DISPLAY BY NAME g_bxd.bxd12
                 NEXT FIELD bxd12
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd12) OR
                 g_bxd.bxd12 != g_bxd_o.bxd12) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF 
           LET g_bxd_o.bxd12 = g_bxd.bxd12
 
        AFTER FIELD bxd13
           IF NOT cl_null(g_bxd.bxd13) THEN
              IF g_bxd.bxd13 < 0 THEN
                 CALL cl_err(g_bxd.bxd13,'aom-103',0)
                 LET g_bxd.bxd13 = g_bxd_o.bxd13
                 DISPLAY BY NAME g_bxd.bxd13
                 NEXT FIELD bxd13
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd13) OR
                 g_bxd.bxd13 != g_bxd_o.bxd13) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF 
           LET g_bxd_o.bxd13 = g_bxd.bxd13
 
        AFTER FIELD bxd14
           IF NOT cl_null(g_bxd.bxd14) THEN
              IF g_bxd.bxd14 < 0 THEN
                 CALL cl_err(g_bxd.bxd14,'aom-103',0)
                 LET g_bxd.bxd14 = g_bxd_o.bxd14
                 DISPLAY BY NAME g_bxd.bxd14
                 NEXT FIELD bxd14
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd14) OR
                 g_bxd.bxd14 != g_bxd_o.bxd14) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF 
           LET g_bxd_o.bxd14 = g_bxd.bxd14
 
        AFTER FIELD bxd15
           IF NOT cl_null(g_bxd.bxd15) THEN
              IF g_bxd.bxd15 < 0 THEN
                 CALL cl_err(g_bxd.bxd15,'aom-103',0)
                 LET g_bxd.bxd15 = g_bxd_o.bxd15
                 DISPLAY BY NAME g_bxd.bxd15
                 NEXT FIELD bxd15
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd15) OR
                 g_bxd.bxd15 != g_bxd_o.bxd15) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF 
           LET g_bxd_o.bxd15 = g_bxd.bxd15
 
        AFTER FIELD bxd16
           IF NOT cl_null(g_bxd.bxd16) THEN
              IF g_bxd.bxd16 < 0 THEN
                 CALL cl_err(g_bxd.bxd16,'aom-103',0)
                 LET g_bxd.bxd16 = g_bxd_o.bxd16
                 DISPLAY BY NAME g_bxd.bxd16
                 NEXT FIELD bxd16
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd16) OR
                 g_bxd.bxd16 != g_bxd_o.bxd16) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF 
           LET g_bxd_o.bxd16 = g_bxd.bxd16
 
        AFTER FIELD bxd17
           IF NOT cl_null(g_bxd.bxd17) THEN
              IF g_bxd.bxd17 < 0 THEN
                 CALL cl_err(g_bxd.bxd17,'aom-103',0)
                 LET g_bxd.bxd17 = g_bxd_o.bxd17
                 DISPLAY BY NAME g_bxd.bxd17
                 NEXT FIELD bxd17
              END IF
              IF p_cmd = 'a' AND 
                (cl_null(g_bxd_o.bxd17) OR
                 g_bxd.bxd17 != g_bxd_o.bxd17) THEN 
                 CALL i051_bxd18('1')
              END IF
           ELSE
              IF p_cmd = 'a' THEN
                 LET g_bxd.bxd18 = 0
                 DISPLAY BY NAME g_bxd.bxd18
              END IF
           END IF 
           LET g_bxd_o.bxd17 = g_bxd.bxd17
 
        AFTER FIELD bxd18
           IF NOT cl_null(g_bxd.bxd18) THEN
              CALL i051_bxd18('2')
           END IF 
 
     AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT
        END IF
        # 再做一次訂單單號及項次合理性判斷  
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt
          FROM oeb_file
         WHERE oeb01 = g_bxd.bxd05
           AND oeb03 = g_bxd.bxd06
        IF l_cnt = 0 THEN
           CALL cl_err(g_bxd.bxd06,'axm-141',0)
           NEXT FIELD bxd06
        END IF
 
        # 再做一次key值重覆的判斷
        IF p_cmd = 'a' OR
          (p_cmd = 'u' AND ((g_bxd.bxd01 != g_bxd_t.bxd01) OR
                            (g_bxd.bxd03 != g_bxd_t.bxd03) OR
                            (g_bxd.bxd04 != g_bxd_t.bxd04) OR
                            (g_bxd.bxd05 != g_bxd_t.bxd05) OR
                            (g_bxd.bxd06 != g_bxd_t.bxd06))) THEN
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM bxd_file
            WHERE bxd01 = g_bxd.bxd01
              AND bxd03 = g_bxd.bxd03
              AND bxd04 = g_bxd.bxd04
              AND bxd05 = g_bxd.bxd05
              AND bxd06 = g_bxd.bxd06
           IF l_cnt > 0 THEN
              CALL cl_err('',-239,0)
              NEXT FIELD bxd01
           END IF
        END IF
        ON ACTION CONTROLP                        # 沿用所有欄位
            CASE
              WHEN INFIELD(bxd01)
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form = "q_ima20"
              #  LET g_qryparam.default1 = g_bxd.bxd01
              #  CALL cl_create_qry() RETURNING g_bxd.bxd01
                CALL q_sel_ima(FALSE, "q_ima20", "", g_bxd.bxd01, "", "", "", "" ,"",'' )  RETURNING g_bxd.bxd01
#FUN-AA0059 --End--
                DISPLAY BY NAME g_bxd.bxd01
                NEXT FIELD bxd01
 
              WHEN INFIELD(bxd05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oea06"
                LET g_qryparam.default1 = g_bxd.bxd05
                LET g_qryparam.default2 = g_bxd.bxd06
                CALL cl_create_qry() RETURNING g_bxd.bxd05,
                                               g_bxd.bxd06
                DISPLAY BY NAME g_bxd.bxd05,g_bxd.bxd06
                NEXT FIELD bxd05                
              OTHERWISE
                EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
 
FUNCTION i051_bxd01(p_cmd)
  DEFINE   p_cmd        LIKE type_file.chr1
  DEFINE   l_ima02      LIKE ima_file.ima02
  DEFINE   l_ima021     LIKE ima_file.ima021
  DEFINE   l_ima1916  LIKE ima_file.ima1916
  DEFINE   l_imaacti    LIKE ima_file.imaacti
  DEFINE   l_bxe02  LIKE bxe_file.bxe02
  DEFINE   l_bxe03  LIKE bxe_file.bxe03
 
  LET g_errno = ''
 
  SELECT ima02,ima021,ima1916,imaacti
    INTO l_ima02,l_ima021,l_ima1916,l_imaacti
    FROM ima_file
   WHERE ima01 = g_bxd.bxd01
 
  IF p_cmd = 'a' THEN
     CASE
       WHEN SQLCA.SQLCODE = 100     LET g_errno = 'ams-003'
       WHEN l_imaacti = 'N'         LET g_errno = '9028'
       OTHERWISE
            LET g_errno = SQLCA.SQLCODE USING '------'
     END CASE
  END IF
 
  IF p_cmd = 'd' OR cl_null(g_errno) THEN
     SELECT bxe02,bxe03
       INTO l_bxe02,l_bxe03
       FROM bxe_file
      WHERE bxe01 = l_ima1916
 
     DISPLAY l_ima02 TO FORMONLY.ima02
     DISPLAY l_ima021 TO FORMONLY.ima021
     DISPLAY l_ima1916 TO FORMONLY.ima1916
     DISPLAY l_bxe02 TO FORMONLY.bxe02
     DISPLAY l_bxe03 TO FORMONLY.bxe03
  END IF 
END FUNCTION
 
FUNCTION i051_bxd05(p_cmd)
  DEFINE  p_cmd     LIKE type_file.chr1
  DEFINE  l_oea00   LIKE oea_file.oea00
  DEFINE  l_oeaconf LIKE oea_file.oeaconf
 
  LET g_errno = ''
 
  SELECT oea00,oeaconf 
    INTO l_oea00,l_oeaconf
    FROM oea_file
   WHERE oea01 = g_bxd.bxd05
 
  IF p_cmd = 'a' THEN
     CASE
       WHEN SQLCA.SQLCODE = 100    LET g_errno = 'asf-959'
       WHEN l_oea00 != '1'         LET g_errno = 'abx-045'
       WHEN l_oeaconf != 'Y'       LET g_errno = 'anm-960'
       OTHERWISE
            LET g_errno = SQLCA.SQLCODE USING '------'
     END CASE
  END IF
 
END FUNCTION
 
FUNCTION i051_bxd18(p_cmd)
DEFINE  p_cmd           LIKE type_file.chr1  # 1.def bxd18值
                                    # 2.chk bxd18值
DEFINE  l_bxd18     LIKE bxd_file.bxd18
DEFINE  l_bxd18_b   LIKE bxd_file.bxd18
DEFINE  l_bxd03_b   LIKE bxd_file.bxd03
DEFINE  l_bxd04_b   LIKE bxd_file.bxd04
 
  IF cl_null(g_bxd.bxd01) OR
     cl_null(g_bxd.bxd03) OR
     cl_null(g_bxd.bxd04) OR
     cl_null(g_bxd.bxd05) OR
     cl_null(g_bxd.bxd06) OR
     cl_null(g_bxd.bxd07) OR
     cl_null(g_bxd.bxd08) OR
     cl_null(g_bxd.bxd09) OR
     cl_null(g_bxd.bxd10) OR
     cl_null(g_bxd.bxd11) OR
     cl_null(g_bxd.bxd12) OR
     cl_null(g_bxd.bxd13) OR
     cl_null(g_bxd.bxd14) OR
     cl_null(g_bxd.bxd15) OR
     cl_null(g_bxd.bxd16) OR
     cl_null(g_bxd.bxd17) THEN
     RETURN
  END IF
 
  # 計算上期的年度與期別
  IF g_bxd.bxd04 = 1 THEN
     LET l_bxd03_b = g_bxd.bxd03 - 1
     LET l_bxd04_b = 12
  ELSE
     LET l_bxd03_b = g_bxd.bxd03
     LET l_bxd04_b = g_bxd.bxd04 - 1
  END IF
 
  LET l_bxd18_b = 0
  SELECT bxd18
    INTO l_bxd18_b
    FROM bxd_file
   WHERE bxd01 = g_bxd.bxd01
     AND bxd03 = l_bxd03_b
     AND bxd04 = l_bxd04_b
     AND bxd05 = g_bxd.bxd05
     AND bxd06 = g_bxd.bxd06
  IF SQLCA.SQLCODE OR cl_null(l_bxd18_b) THEN
     LET l_bxd18_b = 0
  END IF
 
  LET l_bxd18 = l_bxd18_b + (g_bxd.bxd07 + g_bxd.bxd11 +
                                     g_bxd.bxd12 + g_bxd.bxd13 +
                                     g_bxd.bxd16 + g_bxd.bxd17)
                                  - (g_bxd.bxd08 + g_bxd.bxd09 +
                                     g_bxd.bxd10 + g_bxd.bxd14 +
                                     g_bxd.bxd15)
  IF p_cmd = '1' THEN
     LET g_bxd.bxd18 = l_bxd18
     DISPLAY BY NAME g_bxd.bxd18
  ELSE
     IF g_bxd.bxd18 != l_bxd18 THEN
        CALL cl_err(l_bxd18,'abx-046',1)
     END IF
  END IF
END FUNCTION
 
FUNCTION i051_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index, g_row_count)
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_bxd.* TO NULL
    LET g_bxd01_t = NULL
    LET g_bxd03_t = NULL
    LET g_bxd04_t = NULL
    LET g_bxd05_t = NULL
    LET g_bxd06_t = NULL
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_opmsg('q')
 
    CALL i051_curs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_bxd.* TO NULL
       LET g_bxd01_t = NULL
       LET g_bxd03_t = NULL
       LET g_bxd04_t = NULL
       LET g_bxd05_t = NULL
       LET g_bxd06_t = NULL
       RETURN
    END IF
    OPEN i051_count
    FETCH i051_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i051_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_bxd.* TO NULL
       LET g_bxd01_t = NULL
       LET g_bxd03_t = NULL
       LET g_bxd04_t = NULL
       LET g_bxd05_t = NULL
       LET g_bxd06_t = NULL
    ELSE
       CALL i051_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i051_fetch(p_flag)
  DEFINE  p_flag          LIKE type_file.chr1,
          l_abso          LIKE type_file.num10
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i051_cs INTO 
                                             g_bxd.bxd01,
                                             g_bxd.bxd03,
                                             g_bxd.bxd04,
                                             g_bxd.bxd05,
                                             g_bxd.bxd06
        WHEN 'P' FETCH PREVIOUS i051_cs INTO 
                                             g_bxd.bxd01,
                                             g_bxd.bxd03,
                                             g_bxd.bxd04,
                                             g_bxd.bxd05,
                                             g_bxd.bxd06
        WHEN 'F' FETCH FIRST    i051_cs INTO 
                                             g_bxd.bxd01,
                                             g_bxd.bxd03,
                                             g_bxd.bxd04,
                                             g_bxd.bxd05,
                                             g_bxd.bxd06
        WHEN 'L' FETCH LAST     i051_cs INTO 
                                             g_bxd.bxd01,
                                             g_bxd.bxd03,
                                             g_bxd.bxd04,
                                             g_bxd.bxd05,
                                             g_bxd.bxd06
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump i051_cs INTO 
                                               g_bxd.bxd01,
                                               g_bxd.bxd03,
                                               g_bxd.bxd04,
                                               g_bxd.bxd05,
                                               g_bxd.bxd06
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_bxd.* TO NULL
       LET g_bxd01_t = NULL
       LET g_bxd03_t = NULL
       LET g_bxd04_t = NULL
       LET g_bxd05_t = NULL
       LET g_bxd06_t = NULL
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bxd.* FROM bxd_file
     WHERE bxd01 = g_bxd.bxd01 AND bxd03 = g_bxd.bxd03 AND bxd04 = g_bxd.bxd04 AND bxd05 = g_bxd.bxd05 AND bxd06 = g_bxd.bxd06
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       CALL i051_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i051_show()
    LET g_bxd_t.* = g_bxd.*
    LET g_bxd_o.* = g_bxd.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_bxd.*
    DISPLAY BY NAME g_bxd.bxd01,g_bxd.bxd03,g_bxd.bxd04,g_bxd.bxd05,g_bxd.bxd06,g_bxd.bxd07,
                    g_bxd.bxd11,g_bxd.bxd12,g_bxd.bxd13,g_bxd.bxd16,g_bxd.bxd17,g_bxd.bxd08,
                    g_bxd.bxd09,g_bxd.bxd10,g_bxd.bxd14,g_bxd.bxd15,g_bxd.bxd18
    #No.FUN-9A0024--end 
    CALL i051_bxd01('d')
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION i051_u()
  DEFINE l_cnt   LIKE type_file.num5
  DEFINE l_bxd03_a  LIKE bxd_file.bxd03
  DEFINE l_bxd04_a  LIKE bxd_file.bxd04
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bxd.bxd01) OR
       cl_null(g_bxd.bxd03) OR
       cl_null(g_bxd.bxd04) OR
       cl_null(g_bxd.bxd05) OR
       cl_null(g_bxd.bxd06) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    # 計算下一期的年度及月份
    IF g_bxd.bxd04 = 12 THEN
       LET l_bxd03_a = g_bxd.bxd03 + 1
       LET l_bxd04_a = 1
    ELSE
       LET l_bxd03_a = g_bxd.bxd03
       LET l_bxd04_a = g_bxd.bxd04 + 1
    END IF
 
    # 有下期資料時，不可修改
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM bxd_file
     WHERE bxd01 = g_bxd.bxd01
       AND bxd03 = l_bxd03_a
       AND bxd04 = l_bxd04_a
       AND bxd05 = g_bxd.bxd05
       AND bxd06 = g_bxd.bxd06
    IF l_cnt > 0 THEN
       CALL cl_err('','abx-047',0)
       RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
 
    BEGIN WORK
 
    OPEN i051_cl USING g_bxd.bxd01,g_bxd.bxd03,g_bxd.bxd04,g_bxd.bxd05,g_bxd.bxd06
    IF STATUS THEN
       CALL cl_err("OPEN i051_cl:",STATUS,1)
       CLOSE i051_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i051_cl INTO g_bxd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       CLOSE i051_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i051_show()                          # 顯示最新資料
    LET g_bxd01_t = g_bxd.bxd01
    LET g_bxd03_t = g_bxd.bxd03
    LET g_bxd04_t = g_bxd.bxd04
    LET g_bxd05_t = g_bxd.bxd05
    LET g_bxd06_t = g_bxd.bxd06
    WHILE TRUE
        CALL i051_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_bxd.* = g_bxd_t.*
           CALL i051_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE bxd_file SET bxd_file.* = g_bxd.*    # 更新DB
         WHERE bxd01 = g_bxd01_t
           AND bxd03 = g_bxd03_t
           AND bxd04 = g_bxd04_t
           AND bxd05 = g_bxd05_t
           AND bxd06 = g_bxd06_t 
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err('',SQLCA.SQLCODE,0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i051_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i051_r()
  DEFINE l_cnt   LIKE type_file.num5
  DEFINE l_bxd03_a  LIKE bxd_file.bxd03
  DEFINE l_bxd04_a  LIKE bxd_file.bxd04
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bxd.bxd01) OR
       cl_null(g_bxd.bxd03) OR
       cl_null(g_bxd.bxd04) OR
       cl_null(g_bxd.bxd05) OR
       cl_null(g_bxd.bxd06) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    # 計算下一期的年度及月份
    IF g_bxd.bxd04 = 12 THEN
       LET l_bxd03_a = g_bxd.bxd03 + 1
       LET l_bxd04_a = 1
    ELSE
       LET l_bxd03_a = g_bxd.bxd03
       LET l_bxd04_a = g_bxd.bxd04 + 1
    END IF
 
    # 有下期資料時，不可修改
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM bxd_file
     WHERE bxd01 = g_bxd.bxd01
       AND bxd03 = l_bxd03_a
       AND bxd04 = l_bxd04_a
       AND bxd05 = g_bxd.bxd05
       AND bxd06 = g_bxd.bxd06
    IF l_cnt > 0 THEN
       CALL cl_err('','abx-048',0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i051_cl USING g_bxd.bxd01,g_bxd.bxd03,g_bxd.bxd04,g_bxd.bxd05,g_bxd.bxd06
    IF STATUS THEN
       CALL cl_err("OPEN i051_cl:",STATUS,1)
       CLOSE i051_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i051_cl INTO g_bxd.*
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       CLOSE i051_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i051_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bxd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bxd.bxd01      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bxd03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bxd.bxd03      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bxd04"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bxd.bxd04      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "bxd05"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_bxd.bxd05      #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "bxd06"         #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_bxd.bxd06      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM bxd_file WHERE bxd01 = g_bxd.bxd01
                                 AND bxd03 = g_bxd.bxd03
                                 AND bxd04 = g_bxd.bxd04
                                 AND bxd05 = g_bxd.bxd05
                                 AND bxd06 = g_bxd.bxd06
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('',SQLCA.SQLCODE,0)
          CLOSE i051_cl
          ROLLBACK WORK
          RETURN
       END IF
       CLEAR FORM
       OPEN i051_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i051_cs
          CLOSE i051_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--

       FETCH i051_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i051_cs
          CLOSE i051_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i051_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i051_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i051_fetch('/')
       END IF
    END IF
    CLOSE i051_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i051_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bxd01,bxd03,bxd04,bxd05,bxd06",TRUE)
   END IF
END FUNCTION
 
FUNCTION i051_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bxd01,bxd03,bxd04,bxd05,bxd06",FALSE)
   END IF
END FUNCTION
