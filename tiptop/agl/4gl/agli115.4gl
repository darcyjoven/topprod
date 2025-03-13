# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: agli115.4gl
# Descriptions...: 損益類科目與權益類科目關係對應維護作業
# Date & Author..: 12/01/16 By Lori(FUN-BB0030)
# Modify.........: 12/01/16 By Lori FUN-BC0085 增加科目名稱欄位 
# Modify.........: 12/02/24 By Polly MOD-C20185 調整錯誤訊息agl1015的條件
# Modify.........: No:TQC-C30143 12/03/08 By Dido 調整 tat05 開窗參數3應為 '2' 
# Modify.........: No:TQC-C50122 12/05/15 By xuxz 添加複製功能
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C70091 13/01/30 By Lori 增加匯出Excel功能
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
#FUN-BB0030

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE  g_tat01         LIKE tat_file.tat01,
        g_tat01_t       LIKE tat_file.tat01,
        g_tat02         LIKE tat_file.tat02,
        g_tat02_t       LIKE tat_file.tat02,
        g_tat       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
          tat03         LIKE tat_file.tat03,
          aag021        LIKE aag_file.aag02,  #FUN-BC0085
          tat04         LIKE tat_file.tat04,
          aag022        LIKE aag_file.aag02,  #FUN-BC0085
          tat05         LIKE tat_file.tat05,
          aag023        LIKE aag_file.aag02   #FUN-BC0085
                    END RECORD,
        g_tat_t         RECORD                #程式變數 (舊值)
          tat03         LIKE tat_file.tat03,
          aag021        LIKE aag_file.aag02,  #FUN-BC0085
          tat04         LIKE tat_file.tat04,
          aag022        LIKE aag_file.aag02,  #FUN-BC0085
          tat05         LIKE tat_file.tat05,
          aag023        LIKE aag_file.aag02   #FUN-BC0085
                    END RECORD
                    
DEFINE g_forupd_sql     STRING,
       g_wc             STRING,
       g_sql            STRING,
       i,j              LIKE type_file.num5,
       g_row_count      LIKE type_file.num10,     #單頭總筆數
       g_curs_index     LIKE type_file.num10,     #單頭目前指標
       g_rec_b          LIKE type_file.num5,      #單身總筆數
       l_ac             LIKE type_file.num5,      #單身目前指標
       g_jump           LIKE type_file.num10,     #查詢指定筆數
       mi_no_ask        LIKE type_file.num5,      #是否開啟指定筆視窗
       g_dbs_gl         LIKE aag_file.aag01,
       g_cnt            LIKE type_file.num5
DEFINE g_i              LIKE type_file.num5
DEFINE g_msg            LIKE type_file.chr1000
DEFINE g_str            STRING
DEFINE l_aaa01          LIKE aaa_file.aaa01

MAIN

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET i=0
   OPEN WINDOW i115_w WITH FORM "agl/42f/agli115"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_wc = '1=1'  

   CALL i115_menu()
   CLOSE FORM i115_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION i115_cs()
   CLEAR FORM                             #清除畫面
   CALL g_tat.clear()
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_tat01 TO NULL
   INITIALIZE g_tat02 TO NULL
   CONSTRUCT g_wc ON tat01,tat02,tat03
                FROM tat01,tat02,s_tat[1].tat03
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tat01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_aaa"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tat01
               NEXT FIELD tat01
            WHEN INFIELD(tat03)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aag14"
               LET g_qryparam.arg2 = '2'
               LET g_qryparam.arg3 = '2'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tat03
               NEXT FIELD tat03
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

   IF INT_FLAG THEN RETURN END IF
   LET g_sql = "SELECT UNIQUE tat01,tat02"
              ," FROM tat_file"
              ," WHERE ", g_wc CLIPPED
              ," ORDER BY tat01,tat02"
   PREPARE i115_prepare FROM g_sql        #預備一下
   DECLARE i115_bcs SCROLL CURSOR WITH HOLD FOR i115_prepare  #宣告成可捲動的

   LET g_sql = "SELECT COUNT(*) FROM ",
               " (SELECT UNIQUE tat01,tat02  ",
               "  FROM tat_file WHERE ", g_wc CLIPPED,")"
   PREPARE i115_precount FROM g_sql
   DECLARE i115_count CURSOR FOR i115_precount

END FUNCTION

FUNCTION i115_menu()

   WHILE TRUE
      CALL i115_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i115_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i115_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i115_r()
            END IF
         #TQC-C50122--add--str
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i115_copy()
            END IF
         #TQC-C50122--add--end
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i115_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_tat01 IS NOT NULL THEN
                  LET g_doc.column1 = "tat01"
                  LET g_doc.value1 = g_tat01
                  CALL cl_doc()
               END IF
            END IF
         #FUN-C70091 add begin---
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tat),'','')
            END IF
         #FUN-C70091 add end-----
      END CASE
   END WHILE
END FUNCTION

FUNCTION i115_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_tat.clear()
   LET g_wc = NULL
   IF s_shut(0) THEN RETURN END IF              #判斷目前系統是否可用
   LET g_tat01_t = NULL
   LET g_tat02_t = NULL
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i115_i("a")                          #輸入單頭
      IF INT_FLAG THEN                          #使用者不玩了
         LET g_tat01=NULL
         LET g_tat02=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_tat01 IS NULL AND g_tat02 IS NULL THEN                   # KEY 不可空白
         CONTINUE WHILE
      END IF
      LET g_rec_b = 0
      CALL i115_b()                             #輸入單身
      SELECT tat01,tat02                        #保留舊值
       INTO g_tat01_t,g_tat02_t
       FROM tat_file
      WHERE tat01 = g_tat01 AND tat02 = g_tat02
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i115_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入
   l_n1,l_n        LIKE type_file.num5,          #SMALLINT
   p_cmd           LIKE type_file.chr1           #a:輸入 u:更改

   DISPLAY g_tat01 TO tat01
   DISPLAY g_tat02 TO tat02
   CALL cl_set_head_visible("","YES")

   INPUT g_tat01,g_tat02 FROM tat01,tat02
      AFTER FIELD tat01
         IF NOT cl_null(g_tat01) THEN
            IF g_tat01 != g_tat01_t OR cl_null(g_tat01_t) THEN
               SELECT aaa01 INTO l_aaa01 FROM aaa_file
                WHERE aaa01 = g_tat01 AND aaaacti='Y'
               IF STATUS=100 THEN               #資料不存在
                  CALL cl_err3("sel","aaa_file",g_tat01,"",100,"","",1)
                  LET g_tat01 = g_tat01_t
                  DISPLAY g_tat01 TO tat01
                  NEXT FIELD tat01
               END IF
            END IF
            LET g_tat01_t = g_tat01
         END IF

      AFTER FIELD tat02
         IF NOT cl_null(g_tat02) THEN
            IF length(g_tat02) <>'4' THEN
               CALL cl_err('','ask-003',0)
               DISPLAY g_tat02 TO tat02
               NEXT FIELD tat02
            END IF
            LET g_tat02_t = g_tat02
         END IF

      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tat01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_tat01
               CALL cl_create_qry() RETURNING g_tat01
               DISPLAY g_tat01 TO tat01
               NEXT FIELD tat01
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

#Query 查詢
FUNCTION i115_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tat01 TO NULL
    INITIALIZE g_tat02 TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_tat.clear()
    CALL i115_cs()                             #取得查詢條件
    IF INT_FLAG THEN                           #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i115_bcs                              #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                      #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tat01 TO NULL
        INITIALIZE g_tat02 TO NULL
    ELSE
        CALL i115_fetch('F')                   #讀出TEMP第一筆並顯示
        OPEN i115_count
        FETCH i115_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i115_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,    #處理方式
   l_abso          LIKE type_file.num10    #絕對的筆數

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i115_bcs INTO g_tat01,g_tat02
      WHEN 'P' FETCH PREVIOUS i115_bcs INTO g_tat01,g_tat02
      WHEN 'F' FETCH FIRST    i115_bcs INTO g_tat01,g_tat02
      WHEN 'L' FETCH LAST     i115_bcs INTO g_tat01,g_tat02
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
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump i115_bcs INTO g_tat01,g_tat02
         LET mi_no_ask = FALSE
    END CASE
    SELECT UNIQUE tat01,tat02 FROM tat_file
     WHERE tat01 = g_tat01 AND tat02 = g_tat02
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err3("sel","tat_file",g_tat01,"",SQLCA.sqlcode,"","",1)
       INITIALIZE g_tat01 TO NULL
       INITIALIZE g_tat02 TO NULL
    ELSE
        CALL i115_show()
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE

        CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION i115_show()
    DISPLAY g_tat01 TO tat01           #單頭
    DISPLAY g_tat02 TO tat02           #單頭
    SELECT aaa01 INTO l_aaa01 FROM aaa_file WHERE aaa01=g_tat01
    IF STATUS=100 THEN LET l_aaa01='' END IF
    CALL i115_b_fill(g_wc)             #單身

    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i115_r()
    DEFINE l_chr    LIKE type_file.chr1

    IF s_shut(0) THEN RETURN END IF
    IF g_tat01 AND g_tat02 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    BEGIN WORK
    IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "tat01"
       LET g_doc.value1 = g_tat01
       CALL cl_del_doc()
       DELETE FROM tat_file
        WHERE tat01=g_tat01 AND tat02 = g_tat02
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","tat_file",g_tat01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
       ELSE
          CLEAR FORM
          CALL g_tat.clear()
          OPEN i115_count
          FETCH i115_count INTO g_row_count
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i115_bcs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i115_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i115_fetch('/')
          END IF
       END IF
    END IF
    COMMIT WORK
END FUNCTION

#單身
FUNCTION i115_b()
DEFINE
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,      #檢查重複用
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否
   p_cmd           LIKE type_file.chr1,      #處理狀態
   l_allow_insert  LIKE type_file.num5,      #可新增否
   l_allow_delete  LIKE type_file.num5,      #可刪除否
   l_aag03         LIKE aag_file.aag03,
   l_aag04         LIKE aag_file.aag04,
   l_aag07         LIKE aag_file.aag07,
   l_aagacti       LIKE aag_file.aagacti

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')

   LET g_forupd_sql =
       #"SELECT tat03,tat04,tat05 FROM tat_file",          #FUN-BC0085
       "SELECT tat03,'',tat04,'',tat05,'' FROM tat_file",  #FUN-BC0085
       " WHERE tat01= ? AND tat02 = ? AND tat03 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i115_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_tat WITHOUT DEFAULTS FROM s_tat.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'               #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
         BEGIN WORK
            LET p_cmd='u'
            LET g_tat_t.* = g_tat[l_ac].*  #BACKUP
            OPEN i115_bcl USING g_tat01,g_tat02,g_tat_t.tat03
            IF STATUS THEN
                CALL cl_err("OPEN i115_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i115_bcl INTO g_tat[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_tat02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF

                  #FUN-BC0085--Begin--
                  CALL get_account_nm(g_tat01,g_tat[l_ac].tat03) RETURNING g_tat[l_ac].aag021
                  CALL get_account_nm(g_tat01,g_tat[l_ac].tat04) RETURNING g_tat[l_ac].aag022
                  CALL get_account_nm(g_tat01,g_tat[l_ac].tat05) RETURNING g_tat[l_ac].aag023
                  #FUN-BC0085--End--
               END IF
               CALL cl_show_fld_cont()
            END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_tat[l_ac].* TO NULL
         LET g_tat_t.* = g_tat[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD tat03

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         BEGIN WORK
         IF NOT cl_null (g_tat[l_ac].tat03) THEN
            SELECT count(*) INTO l_n FROM tat_file
             WHERE tat01 = g_tat01 AND tat02 = g_tat02
               AND tat03 = g_tat[l_ac].tat03
            IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                NEXT FIELD tat03
            END IF
         END IF
         INSERT INTO tat_file(tat01,tat02,tat03,tat04,tat05)
              VALUES (g_tat01,g_tat02,g_tat[l_ac].tat03,g_tat[l_ac].tat04,g_tat[l_ac].tat05)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tat_file",g_tat01,g_tat02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            MESSAGE 'INSERT O.K'
         END IF

      AFTER FIELD tat03
         LET g_errno = ' '
         IF NOT cl_null(g_tat[l_ac].tat03) THEN
            LET g_sql = " SELECT aag03,aag04,aag07,aagacti FROM aag_file",
                        "  WHERE aag01 = '",g_tat[l_ac].tat03,"'",
                        "    AND aag00 = '",g_tat01,"'"
            PREPARE i115_pre_01 FROM g_sql
            DECLARE iii5_cur_01 CURSOR FOR i115_pre_01
            OPEN iii5_cur_01
            FETCH iii5_cur_01 INTO l_aag03,l_aag04,l_aag07,l_aagacti

            CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'afa-025'
                 WHEN l_aag03 <> '2'      LET g_errno = 'agl1016'
                 WHEN l_aag04 <> '2'      LET g_errno = 'agl1015'
                 WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                 WHEN l_aagacti = 'N'     LET g_errno = '9028'
                 OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------' 
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tat[l_ac].tat03,g_errno,0)
               NEXT FIELD tat03 
            END IF

            CALL get_account_nm(g_tat01,g_tat[l_ac].tat03) RETURNING g_tat[l_ac].aag021  #FUN-BC0085
         END IF

      AFTER FIELD tat04
         LET g_errno = ' '
         IF NOT cl_null(g_tat[l_ac].tat04) THEN
            LET g_sql = " SELECT aag03,aag04,aag07,aagacti FROM aag_file",
                        "  WHERE aag01 = '",g_tat[l_ac].tat04,"'",
                        "    AND aag00 = '",g_tat01,"'"
            PREPARE i115_pre_02 FROM g_sql
            DECLARE iii5_cur_02 CURSOR FOR i115_pre_02
            OPEN iii5_cur_02
            FETCH iii5_cur_02 INTO l_aag03,l_aag04,l_aag07,l_aagacti

            CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'afa-025'
                 WHEN l_aag03 <> '4'      LET g_errno = 'agl-213'
                 WHEN l_aag04 <> '1'      LET g_errno = 'agl1014'
                 WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                 WHEN l_aagacti = 'N'     LET g_errno = '9028'
                 OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------' 
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tat[l_ac].tat04,g_errno,0)
               NEXT FIELD tat04 
            END IF

            CALL get_account_nm(g_tat01,g_tat[l_ac].tat04) RETURNING g_tat[l_ac].aag022  #FUN-BC0085
         END IF

      AFTER FIELD tat05
         LET g_errno = ' '
         IF NOT cl_null(g_tat[l_ac].tat05) THEN
            LET g_sql = " SELECT aag03,aag04,aag07,aagacti FROM aag_file",
                        "  WHERE aag01 = '",g_tat[l_ac].tat05,"'",
                        "    AND aag00 = '",g_tat01,"'"
            PREPARE i115_pre_03 FROM g_sql
            DECLARE iii5_cur_03 CURSOR FOR i115_pre_03
            OPEN iii5_cur_03
            FETCH iii5_cur_03 INTO l_aag03,l_aag04,l_aag07,l_aagacti

            CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'afa-025'
                 WHEN l_aag03 <> '4'      LET g_errno = 'agl-213'
                #WHEN l_aag04 <> '1'      LET g_errno = 'agl1014'    #MOD-C20185 mark
                 WHEN l_aag04 <> '2'      LET g_errno = 'agl1015'    #MOD-C20185 add
                 WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                 WHEN l_aagacti = 'N'     LET g_errno = '9028'
                 OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------' 
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tat[l_ac].tat05,g_errno,0)
               NEXT FIELD tat05 
            END IF

            CALL get_account_nm(g_tat01,g_tat[l_ac].tat05) RETURNING g_tat[l_ac].aag023  #FUN-BC0085
         END IF

      BEFORE DELETE
         IF g_tat_t.tat03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM tat_file
             WHERE tat01 = g_tat01 AND tat02 = g_tat02
               AND tat03 = g_tat_t.tat03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tat_file",g_tat01,g_tat02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tat[l_ac].* = g_tat_t.*
            CLOSE i115_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tat[l_ac].tat03,-263,1)
            LET g_tat[l_ac].* = g_tat_t.*
         ELSE
            UPDATE tat_file SET tat03 = g_tat[l_ac].tat03
                               ,tat04 = g_tat[l_ac].tat04
                               ,tat05 = g_tat[l_ac].tat05
             WHERE tat01=g_tat01 AND tat02=g_tat02 AND tat03 = g_tat_t.tat03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tat_file",g_tat01,g_tat02,SQLCA.sqlcode,"","",1)
               LET g_tat[l_ac].* = g_tat_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #LET g_tat[l_ac].* = g_tat_t.*  #FUN-D30032 mark
            #FUN-D30032--add--str--
            IF p_cmd='u' THEN
               LET g_tat[l_ac].* = g_tat_t.*
            ELSE
               CALL g_tat.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            #FUN-D30032--add--end--
            CLOSE i115_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i115_bcl
         COMMIT WORK

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tat02) AND l_ac > 1 THEN
            LET g_tat[l_ac].* = g_tat[l_ac-1].*
            NEXT FIELD tat02
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tat03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag14"
               LET g_qryparam.default1 = g_tat[l_ac].tat03
               LET g_qryparam.arg1 = g_tat01
               LET g_qryparam.arg2 = '2'
               LET g_qryparam.arg3 = '2'
               CALL cl_create_qry() RETURNING g_tat[l_ac].tat03
               DISPLAY BY NAME g_tat[l_ac].tat03
               CALL get_account_nm(g_tat01,g_tat[l_ac].tat03) RETURNING g_tat[l_ac].aag021  #FUN-BC0085
               NEXT FIELD tat03
            WHEN INFIELD(tat04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag14"
               LET g_qryparam.default1 = g_tat[l_ac].tat04
               LET g_qryparam.arg1 = g_tat01
               LET g_qryparam.arg2 = '4'
               LET g_qryparam.arg3 = '1'
               CALL cl_create_qry() RETURNING g_tat[l_ac].tat04
               DISPLAY BY NAME g_tat[l_ac].tat04
               CALL get_account_nm(g_tat01,g_tat[l_ac].tat04) RETURNING g_tat[l_ac].aag022  #FUN-BC0085
               NEXT FIELD tat04
            WHEN INFIELD(tat05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag14"
               LET g_qryparam.default1 = g_tat[l_ac].tat05
               LET g_qryparam.arg1 = g_tat01
               LET g_qryparam.arg2 = '4'
               LET g_qryparam.arg3 = '2'      #TQC-C30143 mod '1' -> '2'
               CALL cl_create_qry() RETURNING g_tat[l_ac].tat05
               DISPLAY BY NAME g_tat[l_ac].tat05
               CALL get_account_nm(g_tat01,g_tat[l_ac].tat05) RETURNING g_tat[l_ac].aag023  #FUN-BC0085
               NEXT FIELD tat05
            OTHERWISE EXIT CASE
         END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
    END INPUT

    CLOSE i115_bcl
    COMMIT WORK

END FUNCTION

FUNCTION i115_b_askkey()
   DEFINE l_wc     LIKE type_file.chr1000

   CLEAR FORM
   CALL g_tat.clear()

   CONSTRUCT l_wc ON tat03  #螢幕上取條件
        FROM s_tat[1].tat03

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

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
   IF INT_FLAG THEN RETURN END IF
   CALL i115_b_fill(l_wc)
END FUNCTION

FUNCTION i115_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc      LIKE type_file.chr1000   
   
   #FUN-BC0085--Mark--
   #LET g_sql = "SELECT tat03,tat04,tat05 FROM tat_file ",          
   #            " WHERE tat01 = '",g_tat01,"' AND tat02 = '",g_tat02,"' AND ",
   #             p_wc CLIPPED , " ORDER BY tat03"
   #FUN-BC0085--Mark End--

   #FUN-BC0085--Begin--
   IF cl_null(p_wc) THEN
      LET p_wc = '1=1'
   END IF

   LET g_sql = "SELECT tat03,'',tat04,'',tat05,'' FROM tat_file ",         
               " WHERE tat01 = '",g_tat01,"' AND tat02 = '",g_tat02,"' AND ",
                p_wc CLIPPED , " ORDER BY tat03"
   #FUN-BC0085--End--

   PREPARE i115_prepare2 FROM g_sql      #預備一下
   DECLARE tat_cs CURSOR FOR i115_prepare2

   CALL g_tat.clear()

   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH tat_cs INTO g_tat[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      #FUN-BC0085--Begin--
      CALL get_account_nm(g_tat01,g_tat[g_cnt].tat03) RETURNING g_tat[g_cnt].aag021  #FUN-BC0085
      CALL get_account_nm(g_tat01,g_tat[g_cnt].tat04) RETURNING g_tat[g_cnt].aag022  #FUN-BC0085
      CALL get_account_nm(g_tat01,g_tat[g_cnt].tat05) RETURNING g_tat[g_cnt].aag023  #FUN-BC0085
      #FUN-BC0085--End--

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_tat.deleteElement(g_cnt)
    LET g_rec_b=g_cnt -1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i115_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_tat TO s_tat.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION first
         CALL i115_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL i115_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL i115_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL i115_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL i115_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
      
      #TQC-C50122--add--str
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #TQC-C50122--add--end

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      #FUN-C70091 add begin---
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #FUN-C70091 add end-----

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-BC0085--Begin--
#取得會計科目名稱
FUNCTION get_account_nm(p_book_no,p_acc_no)
   DEFINE p_book_no  LIKE aag_file.aag00,
          p_acc_no   LIKE aag_file.aag01
   DEFINE l_acc_nm   LIKE aag_file.aag02

   SELECT aag02
     INTO l_acc_nm
     FROM aag_file
    WHERE aag00 = p_book_no
      AND aag01 = p_acc_no

   IF SQLCA.sqlcode THEN
      CALL cl_err("","aap-021",1)
   END IF

   RETURN l_acc_nm
END FUNCTION
#FUN-BC0085--End--
#TQC-C50122--add--str
FUNCTION i115_copy()
   DEFINE l_tat    RECORD LIKE tat_file.*
   DEFINE l_sql    STRING
   DEFINE l_oldno1 LIKE tat_file.tat01,
          l_oldno2 LIKE tat_file.tat02,
          l_newno1 LIKE tat_file.tat01,
          l_newno2 LIKE tat_file.tat02
   DEFINE l_aaa01 LIKE aaa_file.aaa01
   DEFINE l_n      LIKE type_file.num10
   IF s_aglshut(0) THEN RETURN END IF

   IF cl_null(g_tat01) OR cl_null(g_tat02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   CALL cl_set_head_visible("","YES")

   INPUT l_newno1,l_newno2 FROM tat01,tat02
      AFTER FIELD tat01
         IF NOT cl_null(l_newno1) THEN   
            SELECT aaa01 INTO l_aaa01 FROM aaa_file
             WHERE aaa01 = l_newno1 AND aaaacti='Y'
            IF STATUS=100 THEN               #資料不存在
               CALL cl_err3("sel","aaa_file",l_newno1,"",100,"","",1)
               NEXT FIELD tat01
            END IF
         END IF 
         IF NOT cl_null(l_newno1) AND NOT cl_null(l_newno2) THEN
            LET l_n = 0 
            SELECT count(*) INTO l_n FROM tat_file
             WHERE tat01 = l_newno1
               AND tat02 = l_newno2
            IF l_n > 0 THEN
               CALL cl_err('','agl-447',1) 
               NEXT FIELD tat01
            END IF 
         END IF 
      AFTER FIELD tat02
         IF NOT cl_null(l_newno2) THEN
            IF length(l_newno2) <>'4' THEN
               CALL cl_err('','ask-003',0)
               NEXT FIELD tat02
            END IF
         END IF
         IF NOT cl_null(l_newno1) AND NOT cl_null(l_newno2) THEN
            LET l_n = 0 
            SELECT count(*) INTO l_n FROM tat_file
             WHERE tat01 = l_newno1
               AND tat02 = l_newno2
            IF l_n > 0 THEN
               CALL cl_err('','agl-447',1) 
               NEXT FIELD tat02
            END IF 
         END IF
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()


      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tat01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO tat01
               NEXT FIELD tat01
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
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_tat01 TO tat01 
      DISPLAY g_tat02 TO tat02
      RETURN
    END IF

    DROP TABLE x

    SELECT * FROM tat_file
     WHERE tat01 = g_tat01
       AND tat02 = g_tat02
      INTO TEMP x

    IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tat_file",g_tat01,g_tat02,SQLCA.sqlcode,"","",1)  
      RETURN
   END IF

   UPDATE x SET tat01 = l_newno1,tat02 = l_newno2

   INSERT INTO tat_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tat_file",l_newno1,l_newno2,SQLCA.sqlcode,"","tat:",1)  
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
 
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'

   LET l_oldno1 = g_tat01
   LET l_oldno2 = g_tat02
   LET g_tat01 = l_newno1
   LET g_tat02 = l_newno2

   CALL i115_b()
   #FUN-C30027---begin
   #LET g_tat01 = l_oldno1
   #LET g_tat02 = l_oldno2
   #
   #CALL i115_show()
   #FUN-C30027---end
END FUNCTION
#TQC-C50122--add--end
