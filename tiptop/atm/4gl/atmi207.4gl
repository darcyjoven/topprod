# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmi207.4gl
# Descriptions...: 廣告素材維護作業
# Date & Author..: 05/10/19 By day
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660104 06/06/15 By cl   Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0043 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/20 By mike  報表格式修改為crystal reports
# Modify.........: No.TQC-940020 09/05/07 By mike 無效資料不可以刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_toc       RECORD LIKE toc_file.*,
       g_toc_t     RECORD LIKE toc_file.*,  #備份舊值
       g_toc01_t   LIKE toc_file.toc01,     #Key值備份
       g_wc        string,                  #儲存 user 的查詢條件
       g_sql       STRING                  #組 sql 用
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令  #No.FUN-680120 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose      #No.FUN-680120 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數                          #No.FUN-680120 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數                  #No.FUN-680120 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5         #是否開啟指定筆視窗               #No.FUN-680120 SMALLINT   #No.FUN-6A0072
DEFINE g_str                 STRING                      #No.FUN-760083
DEFINE l_table               STRING                      #No.FUN-760083 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5             #No.FUN-680120 SMALLINT
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
 
   INITIALIZE g_toc.* TO NULL
 
#No.FUN-760083  --BEGIN--
   LET g_sql = "toc01.toc_file.toc01,",
               "toc02.toc_file.toc02,",
               "toc03.toc_file.toc03,",
               "toc04.toc_file.toc04,",
               "toc05.toc_file.toc05,",
               "toc06.toc_file.toc06,",
               "toc07.toc_file.toc07,",
               "toc08.toc_file.toc08,",
               "toa02.toa_file.toa02,",
               "toa02a.toa_file.toa02,",
               "tqa02.tqa_file.tqa02,",
               "ima02.ima_file.ima02"
   LET l_table=cl_prt_temptable("atmi207",g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
       CALL cl_err("insert_prep:",status,1)
   END IF
#No.FUN-760083  --end--
   LET g_forupd_sql = "SELECT * FROM toc_file WHERE toc01 = ? FOR UPDATE"                                                           
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i207_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i207_w AT p_row,p_col WITH FORM "atm/42f/atmi207"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i207_menu()
 
   CLOSE WINDOW i207_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i207_curs()
DEFINE ls STRING
 
    CLEAR FORM
    INITIALIZE g_toc.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        toc01,toc02,toc03,toc04,toc05,
        toc06,toc07,toc08,
        tocuser,tocgrup,tocmodu,tocdate,tocacti
 
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(toc03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_toa"
                 LET g_qryparam.arg1='5'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO toc03
                 NEXT FIELD toc03
               WHEN INFIELD(toc05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_toa"
                 LET g_qryparam.arg1='6'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO toc05
                 NEXT FIELD toc05
               WHEN INFIELD(toc06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_tqa"
                 LET g_qryparam.arg1='2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO toc06
                 NEXT FIELD toc06
               WHEN INFIELD(toc07)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state = "c"
#                LET g_qryparam.form = "q_ima14"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima14","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO toc07
                 NEXT FIELD toc07
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
    #        LET g_wc = g_wc clipped," AND tocuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND tocgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND tocgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tocuser', 'tocgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT toc01 FROM toc_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY toc01"
    PREPARE i207_prepare FROM g_sql
    DECLARE i207_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i207_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM toc_file WHERE ",g_wc CLIPPED
    PREPARE i207_precount FROM g_sql
    DECLARE i207_count CURSOR FOR i207_precount
END FUNCTION
 
FUNCTION i207_menu()
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(100)
 
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i207_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i207_q()
            END IF
        ON ACTION next
            CALL i207_fetch('N')
        ON ACTION previous
            CALL i207_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i207_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i207_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i207_r()
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                 CALL i207_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i207_fetch('/')
        ON ACTION first
            CALL i207_fetch('F')
        ON ACTION last
            CALL i207_fetch('L')
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
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 	
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_toc.toc01 IS NOT NULL THEN
                 LET g_doc.column1 = "toc01"
                 LET g_doc.value1 = g_toc.toc01
                 CALL cl_doc()
              END IF
           END IF
    END MENU
    CLOSE i207_cs
END FUNCTION
 
 
FUNCTION i207_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_toc.* LIKE toc_file.*
    LET g_toc01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_toc.tocuser = g_user
        LET g_toc.tocoriu = g_user #FUN-980030
        LET g_toc.tocorig = g_grup #FUN-980030
        LET g_toc.tocgrup = g_grup               #使用者所屬群
        LET g_toc.tocdate = g_today
        LET g_toc.tocacti = 'Y'
        LET g_toc.toc09 = ' '
        LET g_toc.toc10 = ' '
        LET g_toc.toc11 = ' '
        CALL i207_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_toc.* TO NULL
            LET INT_FLAG = 0
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_toc.toc01 IS NULL THEN
           CONTINUE WHILE
        END IF
        INSERT INTO toc_file VALUES(g_toc.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_toc.toc01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("ins","toc_file",g_toc.toc01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
            CONTINUE WHILE
        ELSE
            SELECT toc01 INTO g_toc.toc01 FROM toc_file
             WHERE toc01 = g_toc.toc01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i207_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
            l_flag    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
            l_tqa02   LIKE tqa_file.tqa02,
            l_ima02   LIKE ima_file.ima02,
            l_input   LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
            l_n       LIKE type_file.num5,             #No.FUN-680120 SMALLINT
            l_edate   LIKE type_file.dat,              #No.FUN-680120 DATE
            l_bdate   LIKE type_file.dat,              #No.FUN-680120 DATE
            g_n       LIKE type_file.num5,             #No.FUN-680120 SMALLINT
            l_n1      LIKE type_file.num5              #No.FUN-680120 SMALLINT
 
   DISPLAY BY NAME
        g_toc.toc01,g_toc.toc02,g_toc.toc03,g_toc.toc04,g_toc.toc05,
        g_toc.toc06,g_toc.toc07,g_toc.toc08,
        g_toc.tocuser,g_toc.tocgrup,
        g_toc.tocmodu,g_toc.tocdate,g_toc.tocacti
 
   INPUT BY NAME g_toc.tocoriu,g_toc.tocorig,
        g_toc.toc01,g_toc.toc02,g_toc.toc03,g_toc.toc04,g_toc.toc05,
        g_toc.toc06,g_toc.toc07,g_toc.toc08
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i207_set_entry(p_cmd)
          CALL i207_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD toc01
         IF NOT cl_null(g_toc.toc01) THEN
            IF g_toc.toc01 != g_toc01_t OR g_toc01_t IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM toc_file
                WHERE toc01 = g_toc.toc01
               IF l_n > 0 THEN                     #資料重復
                  LET g_errno='-239'
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD toc01
               END IF
            END IF
         END IF
 
      AFTER FIELD toc03
         IF NOT cl_null(g_toc.toc03) THEN
            SELECT * FROM toa_file
             WHERE toa01 = g_toc.toc03
               AND toa03 = '5'
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_toc.toc03,100,0)   #No.FUN-660104
               CALL cl_err3("sel","toa_file",g_toc.toc03,"",100,"","",1) #No.FUN-660104
               NEXT FIELD toc03
   	    ELSE
               CALL i207_toc03('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_toc.toc03 = g_toc_t.toc03
                  NEXT FIELD toc03
               END IF
    	    END IF
         END IF
 
      AFTER FIELD toc05
         IF NOT cl_null(g_toc.toc05) THEN
            SELECT * FROM toa_file
             WHERE toa01 = g_toc.toc05
               AND toa03 = '6'
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_toc.toc05,100,0)  #No.FUN-660104
               CALL cl_err3("sel","toa_file",g_toc.toc05,"",100,"","",1)  #No.FUN-660104
               NEXT FIELD toc05
   	    ELSE
               CALL i207_toc05('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_toc.toc05 = g_toc_t.toc05
                  NEXT FIELD toc05
               END IF
    	    END IF
         END IF
 
      AFTER FIELD toc06
         IF NOT cl_null(g_toc.toc06) THEN
            SELECT * FROM tqa_file
             WHERE tqa01 = g_toc.toc06
               AND tqa03 = '2'
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_toc.toc06,100,0)  #No.FUN-660104
               CALL cl_err3("sel","tqa_file",g_toc.toc06,"",100,"","",1)  #No.FUN-660104
               NEXT FIELD toc06
            END IF
               CALL i207_toc06('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_toc.toc06 = g_toc_t.toc06
                  NEXT FIELD toc06
	       END IF
         ELSE
           LET l_tqa02=''
           DISPLAY l_tqa02 TO FORMONLY.tqa02
         END IF
 
      AFTER FIELD toc07
         IF NOT cl_null(g_toc.toc07) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_toc.toc07,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_toc.toc07 = g_toc_t.toc07
               NEXT FIELD toc07
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            SELECT * FROM ima_file
             WHERE ima01 = g_toc.toc07
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_toc.toc07,100,0)  #No.FUN-660104
               CALL cl_err3("sel","ima_file",g_toc.toc07,"",100,"","",1)   #No.FUN-660104
               NEXT FIELD toc07
   	    ELSE
               CALL i207_toc07('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_toc.toc07 = g_toc_t.toc07
                  NEXT FIELD toc07
               END IF
    	    END IF
         ELSE
           LET l_ima02=''
           DISPLAY l_ima02 TO FORMONLY.ima02
         END IF
 
      AFTER INPUT
         LET g_toc.tocuser = s_get_data_owner("toc_file") #FUN-C10039
         LET g_toc.tocgrup = s_get_data_group("toc_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_toc.toc01 IS NULL THEN
               DISPLAY BY NAME g_toc.toc01
               NEXT FIELD toc01
            END IF
 
       #MOD-650015 --start 
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(toc01) THEN
      #      LET g_toc.* = g_toc_t.*
      #      CALL i207_show()
      #      NEXT FIELD toc01
      #   END IF
       #MOD-650015 --end
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(toc03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_toa"
              LET g_qryparam.arg1='5'
              LET g_qryparam.default1 = g_toc.toc03
              CALL cl_create_qry() RETURNING g_toc.toc03
              CALL i207_toc03('a')
              DISPLAY BY NAME g_toc.toc03
              NEXT FIELD toc03
           WHEN INFIELD(toc05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_toa"
              LET g_qryparam.arg1='6'
              LET g_qryparam.default1 = g_toc.toc05
              CALL cl_create_qry() RETURNING g_toc.toc05
              CALL i207_toc05('a')
              DISPLAY BY NAME g_toc.toc05
              NEXT FIELD toc05
           WHEN INFIELD(toc06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tqa"
              LET g_qryparam.arg1='2'
              LET g_qryparam.default1 = g_toc.toc06
              CALL cl_create_qry() RETURNING g_toc.toc06
              CALL i207_toc06('a')
              DISPLAY BY NAME g_toc.toc06
              NEXT FIELD toc06
           WHEN INFIELD(toc07)
#FUN-AA0059---------mod------------str-----------------
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_ima14"
#             LET g_qryparam.arg1 = g_toc.toc06
#             LET g_qryparam.default1 = g_toc.toc07
#             CALL cl_create_qry() RETURNING g_toc.toc07
              CALL q_sel_ima(FALSE, "q_ima14","",g_toc.toc07,g_toc.toc06,"","","","",'' ) 
               RETURNING  g_toc.toc07 
#FUN-AA0059---------mod------------end-----------------
              CALL i207_toc07('a')
              DISPLAY BY NAME g_toc.toc07
              NEXT FIELD toc07
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
 
FUNCTION i207_toc03(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_toa02    LIKE toa_file.toa02,
   l_toaacti  LIKE toa_file.toaacti
 
   LET g_errno=''
   SELECT toa02,toaacti
     INTO l_toa02,l_toaacti
     FROM toa_file
    WHERE toa01=g_toc.toc03
      AND toa03 = '5'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                LET l_toa02=NULL
       WHEN l_toaacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_toa02 TO FORMONLY.toa02
   END IF
END FUNCTION
 
FUNCTION i207_toc05(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_toa02a   LIKE toa_file.toa02,
   l_toaacti  LIKE toa_file.toaacti
 
   LET g_errno=''
   SELECT toa02,toaacti
     INTO l_toa02a,l_toaacti
     FROM toa_file
    WHERE toa01=g_toc.toc05
      AND toa03 = '6'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                LET l_toa02a=NULL
       WHEN l_toaacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_toa02a TO FORMONLY.toa02a
   END IF
END FUNCTION
 
FUNCTION i207_toc06(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_tqa02    LIKE tqa_file.tqa02,
   l_tqaacti  LIKE tqa_file.tqaacti
 
   LET g_errno=''
   SELECT tqa02,tqaacti
     INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01=g_toc.toc06
      AND tqa03 = '2'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                LET l_tqa02=NULL
       WHEN l_tqaacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_tqa02 TO FORMONLY.tqa02
   END IF
END FUNCTION
 
FUNCTION i207_toc07(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_ima02    LIKE ima_file.ima02,
   l_imaacti  LIKE ima_file.imaacti
 
   LET g_errno=''
   SELECT ima02,imaacti INTO l_ima02,l_imaacti
     FROM ima_file
    WHERE ima01=g_toc.toc07
 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                LET l_ima02=NULL
       WHEN l_imaacti='N'       LET g_errno='9028'
   #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
   #FUN-690022------mod-------       
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_ima02  TO FORMONLY.ima02
   END IF
END FUNCTION
 
FUNCTION i207_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_toc.* TO NULL            #No.FUN-6B0043
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i207_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i207_count
    FETCH i207_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i207_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_toc.toc01,SQLCA.sqlcode,0)
        INITIALIZE g_toc.* TO NULL
    ELSE
        CALL i207_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i207_fetch(p_fltoc)
    DEFINE
        p_fltoc          LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
    CASE p_fltoc
        WHEN 'N' FETCH NEXT     i207_cs INTO g_toc.toc01
        WHEN 'P' FETCH PREVIOUS i207_cs INTO g_toc.toc01
        WHEN 'F' FETCH FIRST    i207_cs INTO g_toc.toc01
        WHEN 'L' FETCH LAST     i207_cs INTO g_toc.toc01
        WHEN '/'
            IF (NOT mi_no_ask) THEN    #No.FUN-6A0072
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
            FETCH ABSOLUTE g_jump i207_cs INTO g_toc.toc01
            LET mi_no_ask = FALSE   #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_toc.toc01,SQLCA.sqlcode,0)
        INITIALIZE g_toc.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_fltoc
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_toc.* FROM toc_file    # 重讀DB,因TEMP有不被更新特性
       WHERE toc01 = g_toc.toc01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_toc.toc01,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("sel","toc_file",g_toc.toc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
    ELSE
        LET g_data_owner=g_toc.tocuser
        LET g_data_group=g_toc.tocgrup
        CALL i207_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i207_show()
    LET g_toc_t.* = g_toc.*
    DISPLAY BY NAME g_toc.toc01,g_toc.toc02,g_toc.toc03,g_toc.toc04, g_toc.tocoriu,g_toc.tocorig,
                    g_toc.toc05,g_toc.toc06,g_toc.toc07,g_toc.toc08,
                    g_toc.tocuser,
                    g_toc.tocgrup,g_toc.tocmodu,g_toc.tocdate,
                    g_toc.tocacti
    CALL i207_toc03('d')
    CALL i207_toc05('d')
    CALL i207_toc07('d')
    CALL i207_toc06('d')
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i207_u()
    IF g_toc.toc01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_toc.tocacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
 
    SELECT * INTO g_toc.* FROM toc_file
     WHERE toc01 = g_toc.toc01
    IF g_toc.tocacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_toc01_t = g_toc.toc01
    BEGIN WORK
 
    OPEN i207_cl USING g_toc.toc01
    IF STATUS THEN
       CALL cl_err("OPEN i207_cl:", STATUS, 1)
       CLOSE i207_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i207_cl INTO g_toc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_toc.toc01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_toc.tocmodu=g_user                  #修改者
    LET g_toc.tocdate=g_today                 #修改日期
    CALL i207_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i207_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_toc.*=g_toc_t.*
            CALL i207_show()
            EXIT WHILE
        END IF
        UPDATE toc_file SET toc_file.* = g_toc.*    # 更新DB
            WHERE toc01 = g_toc01_t
        IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_toc.toc01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("upd","toc_file",g_toc.toc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i207_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i207_x()
    IF g_toc.toc01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i207_cl USING g_toc.toc01
    IF STATUS THEN
       CALL cl_err("OPEN i207_cl:", STATUS, 1)
       CLOSE i207_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i207_cl INTO g_toc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_toc.toc01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i207_show()
    IF cl_exp(0,0,g_toc.tocacti) THEN
        LET g_chr=g_toc.tocacti
        IF g_toc.tocacti='Y' THEN
            LET g_toc.tocacti='N'
        ELSE
            LET g_toc.tocacti='Y'
        END IF
        UPDATE toc_file
            SET tocacti=g_toc.tocacti
            WHERE toc01=g_toc.toc01
        IF SQLCA.SQLERRD[3]=0 THEN
        #   CALL cl_err(g_toc.toc01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("upd","toc_file",g_toc.toc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            LET g_toc.tocacti=g_chr
        END IF
        DISPLAY BY NAME g_toc.tocacti
    END IF
    CLOSE i207_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i207_r()
    IF g_toc.toc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
#TQC-940020 ---START                                                                                                                
    IF g_toc.tocacti='N' THEN                                                                                                       
       CALL cl_err('','abm-950',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
#TQC-940020 ---END    
    BEGIN WORK
 
    OPEN i207_cl USING g_toc.toc01
    IF STATUS THEN
       CALL cl_err("OPEN i207_cl:", STATUS, 0)
       CLOSE i207_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i207_cl INTO g_toc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_toc.toc01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i207_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "toc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_toc.toc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM toc_file
        WHERE toc01 = g_toc.toc01
       CLEAR FORM
       OPEN i207_count
       FETCH i207_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i207_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i207_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE   #No.FUN-6A0072
          CALL i207_fetch('/')
       END IF
    END IF
    CLOSE i207_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i207_out()
    DEFINE
        l_toc           RECORD LIKE toc_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)               # External(Disk) file name
        l_za05          LIKE za_file.za05,
        sr              RECORD
                        toc        RECORD LIKE toc_file.*,
                        toa02      LIKE toa_file.toa02,
                        toa02a     LIKE toa_file.toa02,
                        tqa02      LIKE tqa_file.tqa02,
                        ima02      LIKE ima_file.ima02
                        END RECORD
 
    IF cl_null(g_wc) THEN
       LET g_wc=" toc01='",g_toc.toc01,"'"
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT toc_file.*,'','','','' ",
              "  FROM toc_file ",
              " WHERE ",g_wc CLIPPED
 
    PREPARE i207_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i207_co                         # CURSOR
        CURSOR FOR i207_p1
 
    #CALL cl_outnam('atmi207') RETURNING l_name     #No.FUN-760083
    #START REPORT i207_rep TO l_name                #No.FUN-760083
    LET g_str=''                                    #No.FUN-760083
    CALL cl_del_data(l_table)                       #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-760083
    FOREACH i207_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        SELECT toa02 INTO sr.toa02 FROM toa_file
         WHERE toa01 = sr.toc.toc03
        SELECT toa02 INTO sr.toa02a FROM toa_file
         WHERE toa01 = sr.toc.toc05
        SELECT tqa02 INTO sr.tqa02 FROM tqa_file
         WHERE tqa01 = sr.toc.toc06
           AND tqa03 = '2'
        SELECT ima02 INTO sr.ima02 FROM ima_file
         WHERE ima01 = sr.toc.toc07
        EXECUTE insert_prep USING sr.toc.toc01,sr.toc.toc02,sr.toc.toc03,   #No.FUN-760083 
                                  sr.toc.toc04,sr.toc.toc05,sr.toc.toc06,   #No.FUN-760083 
                                  sr.toc.toc07,sr.toc.toc08,sr.toa02,       #No.FUN-760083 
                                  sr.toa02a,sr.tqa02,sr.ima02               #No.FUN-760083 
        #OUTPUT TO REPORT i207_rep(sr.*)          #No.FUN-760083
    END FOREACH
 
    #FINISH REPORT i207_rep             #No.FUN-760083 
 
    CLOSE i207_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)   #No.FUN-760083
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED      #No.FUN-760083 
    IF g_zz05='Y' THEN                                                        #No.FUN-760083  
       CALL cl_wcchp(g_wc,'toc01,toc02,toc03,toc04,toc05,toc06,toc07,toc08,   #No.FUN-760083 
                           tocuser,tocgrup,tocmodu,tocdate,tocacti')      #No.FUN-760083     
       RETURNING  g_wc                                                    #No.FUN-760083 
    END IF                                                                #No.FUN-760083 
    LET g_str=g_wc                                                        #No.FUN-760083 
    CALL cl_prt_cs3("atmi207","atmi207",g_sql,g_str)                      #No.FUN-760083                                                         
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT i207_rep(sr)
 
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        sr              RECORD
                        toc        RECORD LIKE toc_file.*,
                        toa02      LIKE toa_file.toa02,
                        toa02a     LIKE toa_file.toa02,
                        tqa02      LIKE tqa_file.tqa02,
                        ima02      LIKE ima_file.ima02
                        END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.toc.toc01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],
                  g_x[35],g_x[36],g_x[37],g_x[38],
                  g_x[39],g_x[40],g_x[41],g_x[42]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.toc.toc01 CLIPPED,
                  COLUMN g_c[32],sr.toc.toc02 CLIPPED,
                  COLUMN g_c[33],sr.toc.toc03 CLIPPED,
                  COLUMN g_c[34],sr.toa02 CLIPPED,
                  COLUMN g_c[35],sr.toc.toc04 CLIPPED,
                  COLUMN g_c[36],sr.toc.toc05 CLIPPED,
                  COLUMN g_c[37],sr.toa02a CLIPPED,
                  COLUMN g_c[38],sr.toc.toc06 CLIPPED,
                  COLUMN g_c[39],sr.tqa02 CLIPPED,
                  COLUMN g_c[40],sr.toc.toc07 CLIPPED,
                  COLUMN g_c[41],sr.ima02 CLIPPED,
                  COLUMN g_c[42],sr.toc.toc08
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-760083 --end--
 
FUNCTION i207_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("toc01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i207_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("toc01",FALSE)
    END IF
 
END FUNCTION

