# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: agli9441.4gl
# Descriptions...: 現金流量表揭露事項維護作業(合併)
# Date & Author..: 12/01/12 By Lori(FUN-BC0123)
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BC0123

DEFINE
   g_giyy            DYNAMIC ARRAY OF RECORD   #程式變數(program variables)
      giyy01         LIKE giyy_file.giyy01,
      giyy02         LIKE giyy_file.giyy02,
      giyy03         LIKE giyy_file.giyy03
                     END RECORD,
   g_giyy_t          RECORD                   #程式變數 (舊值)
       giyy01        LIKE giyy_file.giyy01,
       giyy02        LIKE giyy_file.giyy02,
       giyy03        LIKE giyy_file.giyy03
                     END RECORD,
   g_wc2,g_wc        STRING,
   g_sql             STRING,
   g_rec_b           LIKE type_file.num5,     #單身筆數
   l_ac              LIKE type_file.num5      #目前處理的array cnt
DEFINE g_giyy04      LIKE giyy_file.giyy04
DEFINE g_giyy05      LIKE giyy_file.giyy05
DEFINE g_giyy06      LIKE giyy_file.giyy06
DEFINE g_giyy07      LIKE giyy_file.giyy07
DEFINE g_giyy04_t    LIKE giyy_file.giyy04
DEFINE g_giyy05_t    LIKE giyy_file.giyy05
DEFINE g_giyy06_t    LIKE giyy_file.giyy06
DEFINE g_giyy07_t    LIKE giyy_file.giyy07
DEFINE g_forupd_sql  STRING
DEFINE g_msg         LIKE ze_file.ze03
DEFINE g_cnt         LIKE type_file.num10
DEFINE g_i           LIKE type_file.num5      #count/index for any purpose
DEFINE l_cmd         LIKE type_file.chr1000
DEFINE g_curs_index  LIKE type_file.num10
DEFINE g_row_count   LIKE type_file.num10
DEFINE g_jump        LIKE type_file.num10
DEFINE g_no_ask      LIKE type_file.num5
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE l_tmp         LIKE type_file.num5
DEFINE l_aza02       LIKE aza_file.aza02
DEFINE g_dbs_axz03   LIKE type_file.chr21  
DEFINE g_axz05       LIKE axz_file.axz05

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5

   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("agl")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 3
   LET p_col = 18

   OPEN WINDOW i944_w AT p_row,p_col
     WITH FORM "agl/42f/agli9441"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_forupd_sql = " SELECT * FROM giyy_file ",
                      " WHERE giyy04 = ? ",
                      "   AND giyy05 = ? ",
                      "   AND giyy06 = ? ",
                      "   AND giyy07 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i9441_cl CURSOR FROM g_forupd_sql

   SELECT aza02 INTO l_aza02 FROM aza_file
   IF l_aza02 = '1' THEN LET l_tmp = 12 ELSE LET l_tmp = 13 END IF

   CALL i9441_menu()

   CLOSE WINDOW i9441_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i9441_cs()

   CLEAR FORM
   CALL g_giyy.clear()

   CONSTRUCT g_wc ON giyy06,giyy07,giyy04,giyy05,giyy01,giyy02,giyy03
        FROM giyy06,giyy07,giyy04,giyy05,s_giyy[1].giyy01,s_giyy[1].giyy02,s_giyy[1].giyy03

      BEFORE CONSTRUCT
        CALL cl_qbe_init()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION controlp
         CASE
            WHEN INFIELD(giyy06)              #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_axa1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giyy06
               NEXT FIELD giyy06
            WHEN INFIELD(giyy07)              #上層公司
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_axz"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giyy07
            OTHERWISE
               EXIT CASE
         END CASE

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF

   LET g_sql = "SELECT DISTINCT giyy04,giyy05,giyy06,giyy07 ",
               "  FROM giyy_file ",
               " WHERE ",g_wc CLIPPED,
               " ORDER BY giyy04"

   PREPARE i9441_prepare FROM g_sql
   DECLARE i9441_cs                         #scroll cursor
       SCROLL CURSOR WITH HOLD FOR i9441_prepare

END FUNCTION

FUNCTION i9441_menu()

   WHILE TRUE
      CALL i9441_bp("g")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i9441_q()
            END IF
         WHEN "insert"                          # a.輸入
            IF cl_chk_act_auth() THEN
               CALL i9441_a()
            END IF
         WHEN "modify"                          # u.更新
            IF cl_chk_act_auth() THEN
               CALL i9441_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL i9441_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i9441_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "delete"                          # r.取消
            IF cl_chk_act_auth() THEN
               CALL i9441_r()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_giyy[l_ac].giyy01 IS NOT NULL THEN
                  LET g_doc.column1 = "giyy01"
                  LET g_doc.value1 = g_giyy[l_ac].giyy01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_giyy),'','')
            END IF
      END CASE
   END WHILE

END FUNCTION

FUNCTION i9441_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_giyy.clear()
   LET g_giyy04 = NULL
   LET g_giyy05 = NULL
   LET g_giyy06 = NULL
   LET g_giyy07 = NULL

   WHILE TRUE
      CALL i9441_i("a")                       #輸入單頭

      IF INT_FLAG THEN                        #使用者不玩了
         LET g_giyy04 = NULL
         LET g_giyy05 = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0

      CALL i9441_b()                          # 輸入單身
      LET g_giyy04_t = g_giyy04
      LET g_giyy05_t = g_giyy05
      LET g_giyy06_t = g_giyy06
      LET g_giyy07_t = g_giyy07
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i9441_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_count      LIKE type_file.num5
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_n1         LIKE type_file.num5

   INPUT g_giyy06,g_giyy07,g_giyy04,g_giyy05
      WITHOUT DEFAULTS FROM giyy06,giyy07,giyy04,giyy05

      AFTER FIELD giyy04
         IF NOT cl_null(g_giyy04) AND NOT cl_null(g_giyy05) AND
            NOT cl_null(g_giyy06) AND NOT cl_null(g_giyy07) THEN
            IF (g_giyy04_t IS NULL OR (g_giyy04 != g_giyy04_t)) OR
               (g_giyy05_t IS NULL OR (g_giyy05 != g_giyy05_t)) OR
               (g_giyy06_t IS NULL OR (g_giyy06 != g_giyy06_t)) OR
               (g_giyy07_t IS NULL OR (g_giyy07 != g_giyy07_t)) THEN
               CALL i9441_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET g_giyy04 = g_giyy04_t
                  LET g_errno = ' '
                  NEXT FIELD giyy04
               END IF
            END IF
         END IF

      AFTER FIELD giyy05
         IF NOT cl_null(g_giyy05) THEN
            IF g_giyy05 < 1 OR g_giyy05 > l_tmp  THEN
               CALL cl_err('','agl-020',1)
               NEXT FIELD giyy05
            END IF
            IF NOT cl_null(g_giyy04) AND NOT cl_null(g_giyy05) THEN
               IF (g_giyy04_t IS NULL OR (g_giyy04 != g_giyy04_t)) OR 
                  (g_giyy05_t IS NULL OR (g_giyy05 != g_giyy05_t)) OR
                  (g_giyy06_t IS NULL OR (g_giyy06 != g_giyy06_t)) OR
                  (g_giyy07_t IS NULL OR (g_giyy07 != g_giyy07_t)) THEN
                  CALL i9441_chk()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,1)
                     LET g_giyy05 = g_giyy05_t
                     LET g_errno = ' '
                     NEXT FIELD giyy05
                  END IF
               END IF
            END IF
         END IF

      AFTER FIELD giyy06   #族群代號
         IF cl_null(g_giyy06) THEN
            CALL cl_err(g_giyy06,'mfg0037',0)
            NEXT FIELD giyy06
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=g_giyy06
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_giyy06,'agl-223',0)
               NEXT FIELD giyy06
            END IF
         END IF

      AFTER FIELD giyy07 
         IF NOT cl_null(g_giyy07) THEN 
            SELECT count(*) INTO l_n FROM axa_file
             WHERE axa01 = g_giyy06 AND axa02 = g_giyy07
            IF l_n = 0  THEN
               CALL cl_err(g_giyy07,'agl-118',1)
               NEXT FIELD giyy07
            END IF
            CALL i9441_giyy07('a',g_giyy07,g_giyy06)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_giyy07,g_errno,0)
               NEXT FIELD giyy07
            END IF
            IF g_giyy06 IS NOT NULL AND g_giyy07 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_giyy06 AND axa02=g_giyy07
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_giyy06 AND axb04=g_giyy07
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_giyy07,'agl-223',0)
                  LET g_giyy06 = g_giyy06_t
                  LET g_giyy07 = g_giyy07_t
                  DISPLAY BY NAME g_giyy06,g_giyy07
                  NEXT FIELD giyy07
               END IF
            END IF
         END IF 
      ON ACTION controlp                 # 沿用所有欄位
         CASE
            WHEN INFIELD(giyy06) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_giyy06
               CALL cl_create_qry() RETURNING g_giyy06
               DISPLAY g_giyy06 TO giyy06
               NEXT FIELD giyy06
            WHEN INFIELD(giyy07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"
               LET g_qryparam.default1 = g_giyy07
               CALL cl_create_qry() RETURNING g_giyy07
               DISPLAY g_giyy07 TO giyy07
               NEXT FIELD giyy07
            OTHERWISE
               EXIT CASE
          END CASE

    END INPUT
END FUNCTION

FUNCTION i9441_u()
   DEFINE l_giyy_lock    RECORD LIKE giyy_file.*
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_chkey = 'N' THEN
      CALL cl_err('','agl-266',1)
      RETURN
   END IF
   IF cl_null(g_giyy04) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   LET g_giyy04_t = g_giyy04
   LET g_giyy05_t = g_giyy05
   LET g_giyy06_t = g_giyy06
   LET g_giyy07_t = g_giyy07
   
   BEGIN WORK
   OPEN i9441_cl USING g_giyy04,g_giyy05,g_giyy06,g_giyy07
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i9441_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i9441_cl INTO l_giyy_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("giyy04 LOCK:",SQLCA.sqlcode,1)
      CLOSE i9441_cl
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
      CALL i9441_i("u")
      IF INT_FLAG THEN
         LET g_giyy04 = g_giyy04_t
         LET g_giyy05 = g_giyy05_t
         LET g_giyy06 = g_giyy06_t
         LET g_giyy07 = g_giyy07_t
         DISPLAY g_giyy04,g_giyy05,g_giyy06,g_giyy07 TO giyy04,giyy05,giyy06,giyy07
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE giyy_file SET giyy04 = g_giyy04, giyy05 = g_giyy05,
                           giyy06 = g_giyy06, giyy07 = g_giyy07
       WHERE giyy04 = g_giyy04_t
         AND giyy05 = g_giyy05_t
         AND giyy06 = g_giyy06_t
         AND giyy07 = g_giyy07_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","giyy_file",g_giyy04_t,g_giyy05_t,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION

FUNCTION i9441_count()
   DEFINE l_giyy     DYNAMIC ARRAY of RECORD
            giyy04   LIKE giyy_file.giyy04,
            giyy05   LIKE giyy_file.giyy05,
            giyy06   LIKE giyy_file.giyy06,
            giyy07   LIKE giyy_file.giyy07
                    END RECORD
   DEFINE li_cnt   LIKE type_file.num10 
   DEFINE li_rec_b LIKE type_file.num10

   LET g_sql = "SELECT DISTINCT giyy04,giyy05,giyy06,giyy07 FROM giyy_file WHERE ",g_wc CLIPPED,
               " ORDER BY giyy05"
   PREPARE i9441_precount FROM g_sql
   DECLARE i9441_count CURSOR FOR i9441_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i9441_count INTO l_giyy[li_cnt].*
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b

END FUNCTION

FUNCTION i9441_q()
   DEFINE li_rec_b LIKE type_file.num10
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM
   CALL g_giyy.clear()
   DISPLAY '' TO formonly.cnt
   CALL i9441_cs()
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i9441_cs                                 #從db產生合乎條件temp(0-30秒)
   IF sqlca.sqlcode THEN                         #有問題
      CALL cl_err('',sqlca.sqlcode,0)
      INITIALIZE g_giyy04 TO NULL
      INITIALIZE g_giyy05 TO NULL
   ELSE
      CALL i9441_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i9441_fetch('F')                      #讀取temp第一筆資料并顯示
    END IF
END FUNCTION

FUNCTION i9441_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式
            l_abso   LIKE type_file.num10         #絕對的筆數

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i9441_cs INTO g_giyy04,g_giyy05,g_giyy06,g_giyy07
      WHEN 'P' FETCH PREVIOUS i9441_cs INTO g_giyy04,g_giyy05,g_giyy06,g_giyy07
      WHEN 'F' FETCH FIRST    i9441_cs INTO g_giyy04,g_giyy05,g_giyy06,g_giyy07
      WHEN 'L' FETCH LAST     i9441_cs INTO g_giyy04,g_giyy05,g_giyy06,g_giyy07
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION controlp
                   CALL cl_cmdask()

                ON ACTION HELP
                   CALL cl_show_help()

                ON ACTION about
                   CALL cl_about()

            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i9441_cs INTO g_giyy04,g_giyy05,g_giyy06,g_giyy07
         LET g_no_ask = FALSE
   END CASE

   IF sqlca.sqlcode THEN
      CALL cl_err(g_giyy04,sqlca.sqlcode,0)
      INITIALIZE g_giyy04 TO NULL
      INITIALIZE g_giyy05 TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)

      CALL i9441_show()
   END IF
END FUNCTION

FUNCTION i9441_show()                         # 將資料顯示在畫面上
   DISPLAY g_giyy04,g_giyy05,g_giyy06,g_giyy07 TO giyy04,giyy05,giyy06,giyy07
   CALL i9441_giyy07('d',g_giyy07,g_giyy06)
   CALL i9441_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i9441_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的array cnt
       l_n             LIKE type_file.num5,                #檢查重複用
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
       p_cmd           LIKE type_file.chr1,                #處理狀態
       l_possible      LIKE type_file.num5,                #用來設定判斷重複的可能性
       l_allow_insert  LIKE type_file.chr1,                #可新增否
       l_allow_delete  LIKE type_file.chr1                 #可刪除否

   IF s_shut(0) THEN RETURN END IF

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   CALL cl_opmsg('b')

   LET g_forupd_sql = " select giyy01,giyy02,giyy03,giyy04,giyy05,giyy06,giyy07 ",
                      "   from giyy_file  ",
                      "  where giyy01 = ? ",
                      "    and giyy04 = ? ",
                      "    and giyy05 = ? ",
                      "    and giyy06 = ? ",
                      "    and giyy07 = ? ",
                      "    for update "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i9441_bcl CURSOR FROM g_forupd_sql      # lock cursor

   INPUT ARRAY g_giyy WITHOUT DEFAULTS FROM s_giyy.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = arr_curr()
         LET l_lock_sw = 'n'            #default
         LET l_n  = arr_count()

         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET  g_before_input_done = FALSE
            CALL i9441_set_entry(p_cmd)
            CALL i9441_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            BEGIN WORK
            LET p_cmd='u'
            LET g_giyy_t.* = g_giyy[l_ac].*  #backup
            OPEN i9441_bcl USING g_giyy_t.giyy01,g_giyy04,g_giyy05,g_giyy06,g_giyy07
            IF STATUS THEN
               CALL cl_err("open i9441_bcl:", STATUS, 1)
               LET l_lock_sw = "y"
            ELSE
               FETCH i9441_bcl INTO g_giyy[l_ac].*
               IF sqlca.sqlcode THEN
                  CALL cl_err(g_giyy_t.giyy01,sqlca.sqlcode,1)
                  LET l_lock_sw = "y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = arr_count()
         LET p_cmd='a'
         LET  g_before_input_done = FALSE
         CALL i9441_set_entry(p_cmd)
         CALL i9441_set_no_entry(p_cmd)
         LET  g_before_input_done = TRUE
         INITIALIZE g_giyy[l_ac].* TO NULL
         LET g_giyy_t.* = g_giyy[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD giyy01

      BEFORE FIELD giyy01                        #default 序號
        IF g_giyy[l_ac].giyy01 IS NULL OR g_giyy[l_ac].giyy01 = 0 THEN
           SELECT max(giyy01)+1
             INTO g_giyy[l_ac].giyy01
             FROM giyy_file
            WHERE giyy04 = g_giyy04
              AND giyy05 = g_giyy05
              AND giyy06 = g_giyy06
              AND giyy07 = g_giyy07
           IF g_giyy[l_ac].giyy01 IS NULL THEN
              LET g_giyy[l_ac].giyy01 = 1
           END IF
        END IF

      AFTER FIELD giyy01                        #check 編號是否重複
         IF NOT cl_null(g_giyy[l_ac].giyy01) THEN
            IF g_giyy[l_ac].giyy01 != g_giyy_t.giyy01 OR
               (g_giyy[l_ac].giyy01 IS NOT NULL AND g_giyy_t.giyy01 IS NULL) THEN
               SELECT COUNT(*) INTO l_n FROM giyy_file
                WHERE giyy01 = g_giyy[l_ac].giyy01
                  AND giyy04 = g_giyy04
                  AND giyy05 = g_giyy05
                  AND giyy06 = g_giyy06
                  AND giyy07 = g_giyy07
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_giyy[l_ac].giyy01 = g_giyy_t.giyy01
                  NEXT FIELD giyy01
               END IF
            END IF
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_giyy_t.giyy01 IS NOT NULL AND g_giyy_t.giyy01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL
            LET g_doc.column1 = "giyy01"
            LET g_doc.value1 = g_giyy[l_ac].giyy01
            CALL cl_del_doc()
            IF l_lock_sw = "y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM giyy_file
             WHERE giyy01 = g_giyy_t.giyy01
               AND giyy04 = g_giyy04
               AND giyy05 = g_giyy05
               AND giyy06 = g_giyy06
               AND giyy07 = g_giyy07
            IF sqlca.sqlcode THEN
               CALL cl_err3("del","giyy_file",g_giyy_t.giyy01,"",sqlca.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO formonly.cn2
            COMMIT WORK
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_giyy[l_ac].* = g_giyy_t.*
            CLOSE i9441_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'y' THEN
            CALL cl_err(g_giyy[l_ac].giyy01,-263,1)
            LET g_giyy[l_ac].* = g_giyy_t.*
         ELSE
            UPDATE giyy_file SET giyy01 = g_giyy[l_ac].giyy01,
                                 giyy02 = g_giyy[l_ac].giyy02,
                                 giyy03 = g_giyy[l_ac].giyy03
             WHERE giyy01 = g_giyy_t.giyy01
               AND giyy04 = g_giyy04
               AND giyy05 = g_giyy05
               AND giyy06 = g_giyy06
               AND giyy07 = g_giyy07
            IF sqlca.sqlcode THEN
               CALL cl_err3("upd","giyy_file",g_giyy_t.giyy01,"",sqlca.sqlcode,"","",1)
               LET g_giyy[l_ac].* = g_giyy_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'update o.k'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = arr_curr()
        #LET l_ac_t = l_ac   #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_giyy[l_ac].* = g_giyy_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_giyy.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i9441_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30032 add
         CLOSE i9441_bcl
         COMMIT WORK

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i9441_bcl
            CALL g_giyy.deleteelement(l_ac)
            IF g_rec_b != 0 THEN
               LET g_action_choice = "detail"
               LET l_ac = l_ac_t
            END IF
            EXIT INPUT
         END IF

         INSERT INTO giyy_file(giyy01,giyy02,giyy03,giyy04,giyy05,giyy06,giyy07)
                       VALUES(g_giyy[l_ac].giyy01,g_giyy[l_ac].giyy02,
                              g_giyy[l_ac].giyy03,g_giyy04,g_giyy05,g_giyy06,g_giyy07)
          IF sqlca.sqlcode THEN
             CALL cl_err3("ins","giyy_file",g_giyy[l_ac].giyy01,"",sqlca.sqlcode,"","",1)
             LET g_giyy[l_ac].* = g_giyy_t.*
          ELSE
             MESSAGE 'insert o.k'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO formonly.cn2
          END IF

      ON ACTION controlo                        #沿用所有欄位
         IF l_ac > 1 THEN
            LET g_giyy[l_ac].* = g_giyy[l_ac-1].*
            NEXT FIELD giyy01
         END IF

      ON ACTION controlz
         CALL cl_show_req_fields()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION controlf
         CALL cl_set_focus_form(ui.interface.getrootnode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

   END INPUT

   CLOSE i9441_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i9441_b_fill(p_wc2)              #body fill up
DEFINE p_wc2     LIKE type_file.chr1000

   LET g_sql = "SELECT giyy01,giyy02,giyy03",
               "  FROM giyy_file",
               " WHERE giyy04 = '",g_giyy04,"'",
               "   AND giyy05 = '",g_giyy05,"'",
               "   AND giyy06 = '",g_giyy06,"'",
               "   AND giyy07 = '",g_giyy07,"'",
               " ORDER BY 2"
   PREPARE i9441_pb FROM g_sql
   DECLARE giyy_curs CURSOR FOR i9441_pb

   CALL g_giyy.clear()
   LET g_cnt = 1
   MESSAGE "searching!"

   FOREACH giyy_curs INTO g_giyy[g_cnt].*   #單身array
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH

   CALL g_giyy.deleteelement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO formonly.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i9441_copy()
   DEFINE   l_n       LIKE type_file.num5,
            l_n1      LIKE type_file.num5,
            l_giyy04   LIKE giyy_file.giyy04,
            l_giyy05   LIKE giyy_file.giyy05,
            l_giyy06   LIKE giyy_file.giyy06,
            l_giyy07   LIKE giyy_file.giyy07,
            l_old04    LIKE giyy_file.giyy04,
            l_old05    LIKE giyy_file.giyy05,
            l_old06    LIKE giyy_file.giyy06,
            l_old07    LIKE giyy_file.giyy07

   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF

   IF g_giyy04 IS NULL OR g_giyy05 IS NULL OR
      g_giyy06 IS NULL OR g_giyy07 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET l_giyy04 = NULL
   LET l_giyy05 = NULL
   LET l_giyy06 = NULL
   LET l_giyy07 = NULL

   CALL cl_set_head_visible("","yes")
   INPUT l_giyy06,l_giyy07,l_giyy04,l_giyy05 WITHOUT DEFAULTS FROM giyy06,giyy07,giyy04,giyy05

      AFTER FIELD giyy06   #族群代號
         IF cl_null(l_giyy06) THEN
            CALL cl_err(l_giyy06,'mfg0037',0)
            NEXT FIELD giyy06
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=l_giyy06
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(l_giyy06,'agl-223',0)
               NEXT FIELD giyy06
            END IF
         END IF
      AFTER FIELD giyy07
         IF NOT cl_null(l_giyy07) THEN
            SELECT count(*) INTO l_n FROM axa_file
             WHERE axa01 = l_giyy06 AND axa02 = l_giyy07
            IF l_n = 0  THEN
               CALL cl_err(l_giyy07,'agl-118',1)
               NEXT FIELD giyy07
            END IF
            CALL i9441_giyy07('a',l_giyy07,l_giyy06)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_giyy07,g_errno,0)
               NEXT FIELD giyy07
            END IF
            IF l_giyy06 IS NOT NULL AND l_giyy07 IS NOT NULL THEN
               LET l_n = 0   
               LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=l_giyy06 AND axa02=l_giyy07
                  AND axa03=l_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=l_giyy06 AND axb04=l_giyy07
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(l_giyy07,'agl-223',0)
                  NEXT FIELD giyy07
               END IF
            END IF
         END IF

      AFTER FIELD giyy04
         IF NOT cl_null(l_giyy04) AND NOT cl_null(l_giyy05) THEN
            SELECT COUNT(giyy04) INTO l_n FROM giyy_file
             WHERE giyy04 = l_giyy04
               AND giyy05 = l_giyy05
            IF l_n > 0 THEN
               LET g_errno = '-239'
            ELSE
               LET g_errno = ' '
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               LET l_giyy04 = NULL
               LET g_errno = ' '
               NEXT FIELD giyy04
            END IF
         END IF

      AFTER FIELD giyy05
         IF NOT cl_null(l_giyy05) THEN
            IF l_giyy05 < 1 OR l_giyy05 > l_tmp  THEN
               CALL cl_err('','agl-020',1)
               NEXT FIELD giyy05
            END IF
            IF NOT cl_null(l_giyy04) AND NOT cl_null(l_giyy05) THEN
               SELECT COUNT(giyy04) INTO l_n FROM giyy_file
                WHERE giyy04 = l_giyy04
                  AND giyy05 = l_giyy05
               IF l_n > 0 THEN
                  LET g_errno = '-239'
               ELSE
                  LET g_errno = ' '
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET l_giyy05 = NULL
                  LET g_errno = ' '
                  NEXT FIELD giyy05
               END IF
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
          SELECT COUNT(*) INTO g_cnt FROM giyy_file
           WHERE gae01 = l_giyy04 AND gae11 = l_giyy05
          IF g_cnt > 0 THEN
             CALL cl_err_msg(NULL,"azz-110",l_giyy04||"|"||l_giyy05,10)
          END IF

      ON ACTION controlp                 # 沿用所有欄位
         CASE
            WHEN INFIELD(giyy06) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = l_giyy06
               CALL cl_create_qry() RETURNING l_giyy06
               DISPLAY l_giyy06 TO giyy06
               NEXT FIELD giyy06
            WHEN INFIELD(giyy07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"
               LET g_qryparam.default1 = l_giyy07
               CALL cl_create_qry() RETURNING l_giyy07
               DISPLAY l_giyy07 TO giyy07
               NEXT FIELD giyy07
            OTHERWISE
               EXIT CASE
          END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION HELP
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_giyy04,g_giyy05,g_giyy06,g_giyy07 TO giyy04,giyy05,giyy06,giyy07
      RETURN
   END IF

   DROP TABLE x
   SELECT * FROM giyy_file WHERE giyy04 = g_giyy04 AND giyy05 = g_giyy05
                             AND giyy06 = g_giyy06 AND giyy07 = g_giyy07
     INTO TEMP x

   IF sqlca.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",0)
      RETURN
   END IF

   UPDATE x
      SET giyy04 = l_giyy04,                        #資料鍵值 
          giyy05 = l_giyy05,                        #資料鍵值
          giyy06 = l_giyy06,                        #資料鍵值 
          giyy07 = l_giyy07                         #資料鍵值

   INSERT INTO giyy_file SELECT * FROM x

   IF sqlca.sqlcode THEN
      CALL cl_err3("ins","gae_file","","",sqlca.sqlcode,"","",0)
      RETURN
   END IF


   LET l_old04 = g_giyy04
   LET l_old05 = g_giyy05
   LET l_old06 = g_giyy06
   LET l_old07 = g_giyy07
   LET g_giyy04 = l_giyy04
   LET g_giyy05 = l_giyy05
   LET g_giyy06 = l_giyy06
   LET g_giyy07 = l_giyy07
   CALL i9441_b()
   #FUN-C30027---begin
   #LET g_giyy04 = l_old04
   #LET g_giyy05 = l_old05
   #LET g_giyy06 = l_old06
   #LET g_giyy07 = l_old07
   #CALL i9441_show()
   #FUN-C30027---end
END FUNCTION

FUNCTION i9441_r()        #取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,
            l_gae   RECORD LIKE giyy_file.*

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_giyy04) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM giyy_file
       WHERE giyy04 = g_giyy04 AND giyy05 = g_giyy05
         AND giyy06 = g_giyy06 AND giyy07 = g_giyy07
      CLEAR FORM
      CALL g_giyy.CLEAR()
      LET g_giyy04 = NULL
      LET g_giyy05 = NULL
      LET g_giyy06 = NULL
      LET g_giyy07 = NULL
      CALL i9441_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i9441_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i9441_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i9441_fetch('/')
      END IF
   END IF

   CLOSE i9441_cs
   COMMIT WORK
END FUNCTION

FUNCTION i9441_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "g" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_giyy TO s_giyy.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = arr_curr()
         CALL cl_show_fld_cont()
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice='reproduce'
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice='delete'
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION FIRST                            # 第一筆
         CALL i9441_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION PREVIOUS                         # p.上筆
         CALL i9441_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
        ACCEPT DISPLAY
        
      ON ACTION jump                             #指定筆
         CALL i9441_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
         
      ON ACTION NEXT                             # n.下筆
         CALL i9441_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
         
      ON ACTION LAST                             # 末一筆
         CALL i9441_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY
         
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
          
      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
         
      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = arr_curr()
         EXIT DISPLAY
         
      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
      ON ACTION about
         CALL cl_about()

#@    on action 相關文件
       ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION i9441_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("giyy04,giyy05,giyy06,giyy07",TRUE)
   END IF
END FUNCTION

FUNCTION i9441_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("giyy04,giyy05,giyy06,giyy07",FALSE)
   END IF
END FUNCTION

FUNCTION i9441_chk()
   DEFINE l_n      LIKE type_file.num5
   SELECT COUNT(giyy04) INTO l_n FROM giyy_file
    WHERE giyy04 = g_giyy04
      AND giyy05 = g_giyy05
      AND giyy06 = g_giyy06
      AND giyy07 = g_giyy07
   IF l_n > 0 THEN
      LET g_errno = '-239'
   ELSE 
      LET g_errno = ' ' 
   END IF
END FUNCTION

FUNCTION  i9441_giyy07(p_cmd,p_giyy07,p_giyy06)
DEFINE p_cmd           LIKE type_file.chr1,         
       p_giyy07         LIKE giyy_file.giyy07,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05,
       l_aaz641        LIKE aaz_file.aaz641,
       p_giyy06        LIKE giyy_file.giyy06,
       l_axa07         LIKE axa_file.axa07

    LET g_errno = ' '
    
       SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05 
         FROM axz_file
        WHERE axz01 = p_giyy07
    LET g_axz05 = l_axz05

    CALL s_aaz641_dbs(p_giyy06,p_giyy07) RETURNING g_dbs_axz03
    CALL s_get_aaz641(g_dbs_axz03) RETURNING l_aaz641

    CASE
       WHEN SQLCA.SQLCODE=100 
          LET g_errno = 'mfg9142'
          LET l_axz02 = NULL
          LET l_axz03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_axz02 TO FORMONLY.axz02 
       DISPLAY l_axz03 TO FORMONLY.axz03
       DISPLAY l_axz05 TO FORMONLY.axz05
    END IF

END FUNCTION
