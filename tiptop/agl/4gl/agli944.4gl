# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: agli944.4gl
# Descriptions...: 現金流量表揭露事項維護作業(總帳)
# Date & Author..: 12/03/07 By Lori(FUN-BC0123)
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BC0123
DEFINE
   g_giy            DYNAMIC ARRAY OF RECORD   #程式變數(program variables)
      giy01         LIKE giy_file.giy01,
      giy02         LIKE giy_file.giy02,
      giy03         LIKE giy_file.giy03
                    END RECORD,
   g_giy_t          RECORD                   #程式變數 (舊值)
       giy01        LIKE giy_file.giy01,
       giy02        LIKE giy_file.giy02,
       giy03        LIKE giy_file.giy03
                    END RECORD,
   g_wc2,g_wc       STRING,
   g_sql            STRING,
   g_rec_b          LIKE type_file.num5,     #單身筆數
   l_ac             LIKE type_file.num5      #目前處理的array cnt
DEFINE g_giy04      LIKE giy_file.giy04
DEFINE g_giy05      LIKE giy_file.giy05
DEFINE g_giy04_t    LIKE giy_file.giy04
DEFINE g_giy05_t    LIKE giy_file.giy05
DEFINE g_forupd_sql STRING
DEFINE g_msg        LIKE ze_file.ze03
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose
DEFINE l_cmd        LIKE type_file.chr1000
DEFINE g_curs_index LIKE type_file.num10
DEFINE g_row_count  LIKE type_file.num10
DEFINE g_jump       LIKE type_file.num10
DEFINE g_no_ask     LIKE type_file.num5
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE l_tmp        LIKE type_file.num5
DEFINE l_aza02      LIKE aza_file.aza02

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
     WITH FORM "agl/42f/agli944"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_forupd_sql = " SELECT * FROM giy_file ",
                      " WHERE giy04 = ? ",
                      "   AND giy05 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i944_cl CURSOR FROM g_forupd_sql

   SELECT aza02 INTO l_aza02 FROM aza_file
   IF l_aza02 = '1' THEN LET l_tmp = 12 ELSE LET l_tmp = 13 END IF

   CALL i944_menu()

   CLOSE WINDOW i944_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i944_cs()

   CLEAR FORM
   CALL g_giy.clear()

   CONSTRUCT g_wc ON giy04,giy05,giy01,giy02,giy03
        FROM giy04,giy05,s_giy[1].giy01,s_giy[1].giy02,s_giy[1].giy03

      BEFORE CONSTRUCT
        CALL cl_qbe_init()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

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

   LET g_sql = "SELECT DISTINCT giy04,giy05 ",
               "  FROM giy_file ",
               " WHERE ",g_wc CLIPPED,
               " ORDER BY giy04"

   PREPARE i944_prepare FROM g_sql
   DECLARE i944_cs                         #scroll cursor
       SCROLL CURSOR WITH HOLD FOR i944_prepare

END FUNCTION

FUNCTION i944_menu()

   WHILE TRUE
      CALL i944_bp("g")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i944_q()
            END IF
         WHEN "insert"                          # a.輸入
            IF cl_chk_act_auth() THEN
               CALL i944_a()
            END IF
         WHEN "modify"                          # u.更新
            IF cl_chk_act_auth() THEN
               CALL i944_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL i944_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i944_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "delete"                          # r.取消
            IF cl_chk_act_auth() THEN
               CALL i944_r()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET l_cmd = 'p_query "agli944" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_giy[l_ac].giy01 IS NOT NULL THEN
                  LET g_doc.column1 = "giy01"
                  LET g_doc.value1 = g_giy[l_ac].giy01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_giy),'','')
            END IF
      END CASE
   END WHILE

END FUNCTION

FUNCTION i944_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_giy.clear()
   LET g_giy04 = NULL
   LET g_giy05 = NULL

   WHILE TRUE
      CALL i944_i("a")                       #輸入單頭

      IF INT_FLAG THEN                       #使用者不玩了
         LET g_giy04 = NULL
         LET g_giy05 = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0

      CALL i944_b()                          # 輸入單身
      LET g_giy04_t = g_giy04
      LET g_giy05_t = g_giy05
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i944_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_count      LIKE type_file.num5
   INPUT g_giy04,g_giy05
      WITHOUT DEFAULTS FROM giy04,giy05

      AFTER FIELD giy04
         IF NOT cl_null(g_giy04) AND NOT cl_null(g_giy05)  THEN
            IF (g_giy04_t IS NULL OR (g_giy04 != g_giy04_t)) OR
               (g_giy05_t IS NULL OR (g_giy05 != g_giy05_t)) THEN
               CALL i944_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET g_giy04 = g_giy04_t
                  LET g_errno = ' '
                  NEXT FIELD giy04
               END IF
            END IF
         END IF

      AFTER FIELD giy05
         IF NOT cl_null(g_giy05) THEN
            IF g_giy05 < 1 OR g_giy05 > l_tmp  THEN
               CALL cl_err('','agl-020',1)
               NEXT FIELD giy05
            END IF
            IF NOT cl_null(g_giy04) AND NOT cl_null(g_giy05) THEN
               IF (g_giy04_t IS NULL OR (g_giy04 != g_giy04_t)) OR 
                  (g_giy05_t IS NULL OR (g_giy05 != g_giy05_t)) THEN
                  CALL i944_chk()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,1)
                     LET g_giy05 = g_giy05_t
                     LET g_errno = ' '
                     NEXT FIELD giy05
                  END IF
               END IF
            END IF
         END IF

    END INPUT
END FUNCTION

FUNCTION i944_u()
   DEFINE l_giy_lock    RECORD LIKE giy_file.*
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_chkey = 'N' THEN
      CALL cl_err('','agl-266',1)
      RETURN
   END IF
   IF cl_null(g_giy04) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   LET g_giy04_t = g_giy04
   LET g_giy05_t = g_giy05

   BEGIN WORK
   OPEN i944_cl USING g_giy04,g_giy05
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i944_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i944_cl INTO l_giy_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("giy04 LOCK:",SQLCA.sqlcode,1)
      CLOSE i944_cl
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
      CALL i944_i("u")
      IF INT_FLAG THEN
         LET g_giy04 = g_giy04_t
         LET g_giy05 = g_giy05_t
         DISPLAY g_giy04,g_giy05 TO giy04,giy05
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE giy_file SET giy04 = g_giy04, giy05 = g_giy05
       WHERE giy04 = g_giy04_t
         AND giy05 = g_giy05_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","giy_file",g_giy04_t,g_giy05_t,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION

FUNCTION i944_count()
   DEFINE l_giy     DYNAMIC ARRAY of RECORD
            giy04   LIKE giy_file.giy04,
            giy05   LIKE giy_file.giy05
                    END RECORD
   DEFINE li_cnt   LIKE type_file.num10 
   DEFINE li_rec_b LIKE type_file.num10

   LET g_sql = "SELECT DISTINCT giy04,giy05 FROM giy_file WHERE ",g_wc CLIPPED,
               " ORDER BY giy05"
   PREPARE i944_precount FROM g_sql
   DECLARE i944_count CURSOR FOR i944_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i944_count INTO l_giy[li_cnt].*
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

FUNCTION i944_q()
   DEFINE li_rec_b LIKE type_file.num10
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM
   CALL g_giy.clear()
   DISPLAY '' TO formonly.cnt
   CALL i944_cs()
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i944_cs                       #從db產生合乎條件temp(0-30秒)
   IF sqlca.sqlcode THEN                         #有問題
      CALL cl_err('',sqlca.sqlcode,0)
      INITIALIZE g_giy04 TO NULL
      INITIALIZE g_giy05 TO NULL
   ELSE
      CALL i944_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i944_fetch('F')                 #讀取temp第一筆資料并顯示
    END IF
END FUNCTION

FUNCTION i944_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式
            l_abso   LIKE type_file.num10         #絕對的筆數

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i944_cs INTO g_giy04,g_giy05
      WHEN 'P' FETCH PREVIOUS i944_cs INTO g_giy04,g_giy05
      WHEN 'F' FETCH FIRST    i944_cs INTO g_giy04,g_giy05
      WHEN 'L' FETCH LAST     i944_cs INTO g_giy04,g_giy05
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
         FETCH ABSOLUTE g_jump i944_cs INTO g_giy04,g_giy05
         LET g_no_ask = FALSE
   END CASE

   IF sqlca.sqlcode THEN
      CALL cl_err(g_giy04,sqlca.sqlcode,0)
      INITIALIZE g_giy04 TO NULL
      INITIALIZE g_giy05 TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)

      CALL i944_show()
   END IF
END FUNCTION

FUNCTION i944_show()                         # 將資料顯示在畫面上
   DISPLAY g_giy04,g_giy05 TO giy04,giy05
   CALL i944_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i944_b()
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

   LET g_forupd_sql = "SELECT giy01,giy02,giy03,giy04,giy05 FROM giy_file",
                      " WHERE giy01 = ? AND giy04 = ? AND giy05 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i944_bcl CURSOR FROM g_forupd_sql      # lock cursor

   INPUT ARRAY g_giy WITHOUT DEFAULTS FROM s_giy.*
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
            CALL i944_set_entry(p_cmd)
            CALL i944_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            BEGIN WORK
            LET p_cmd='u'
            LET g_giy_t.* = g_giy[l_ac].*  #backup
            OPEN i944_bcl USING g_giy_t.giy01,g_giy04,g_giy05
            IF STATUS THEN
               CALL cl_err("open i944_bcl:", STATUS, 1)
               LET l_lock_sw = "y"
            ELSE
               FETCH i944_bcl INTO g_giy[l_ac].*
               IF sqlca.sqlcode THEN
                  CALL cl_err(g_giy_t.giy01,sqlca.sqlcode,1)
                  LET l_lock_sw = "y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = arr_count()
         LET p_cmd='a'
         LET  g_before_input_done = FALSE
         CALL i944_set_entry(p_cmd)
         CALL i944_set_no_entry(p_cmd)
         LET  g_before_input_done = TRUE
         INITIALIZE g_giy[l_ac].* TO NULL
         LET g_giy_t.* = g_giy[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD giy01

      BEFORE FIELD giy01                        #default 序號
        IF g_giy[l_ac].giy01 IS NULL OR g_giy[l_ac].giy01 = 0 THEN
           SELECT max(giy01)+1
             INTO g_giy[l_ac].giy01
             FROM giy_file
            WHERE giy04 = g_giy04
              AND giy05 = g_giy05
           IF g_giy[l_ac].giy01 IS NULL THEN
              LET g_giy[l_ac].giy01 = 1
           END IF
        END IF

      AFTER FIELD giy01                        #check 編號是否重複
         IF NOT cl_null(g_giy[l_ac].giy01) THEN
            IF g_giy[l_ac].giy01 != g_giy_t.giy01 OR
               (g_giy[l_ac].giy01 IS NOT NULL AND g_giy_t.giy01 IS NULL) THEN
               SELECT COUNT(*) INTO l_n FROM giy_file
                WHERE giy01 = g_giy[l_ac].giy01
                  AND giy04 = g_giy04
                  AND giy05 = g_giy05
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_giy[l_ac].giy01 = g_giy_t.giy01
                  NEXT FIELD giy01
               END IF
            END IF
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_giy_t.giy01 IS NOT NULL AND g_giy_t.giy01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL
            LET g_doc.column1 = "giy01"
            LET g_doc.value1 = g_giy[l_ac].giy01
            CALL cl_del_doc()
            IF l_lock_sw = "y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM giy_file
             WHERE giy01 = g_giy_t.giy01
               AND giy04 = g_giy04
               AND giy05 = g_giy05
            IF sqlca.sqlcode THEN
               CALL cl_err3("del","giy_file",g_giy_t.giy01,"",sqlca.sqlcode,"","",1)
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
            LET g_giy[l_ac].* = g_giy_t.*
            CLOSE i944_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'y' THEN
            CALL cl_err(g_giy[l_ac].giy01,-263,1)
            LET g_giy[l_ac].* = g_giy_t.*
         ELSE
            UPDATE giy_file SET giy01 = g_giy[l_ac].giy01,
                                giy02 = g_giy[l_ac].giy02,
                                giy03 = g_giy[l_ac].giy03
             WHERE giy01 = g_giy_t.giy01
               AND giy04 = g_giy04
               AND giy05 = g_giy05
            IF sqlca.sqlcode THEN
               CALL cl_err3("upd","giy_file",g_giy_t.giy01,"",sqlca.sqlcode,"","",1)
               LET g_giy[l_ac].* = g_giy_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'update o.k'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = arr_curr()
         #LET l_ac_t = l_ac  #FUN-D30032

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_giy[l_ac].* = g_giy_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_giy.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i944_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032

         CLOSE i944_bcl
         COMMIT WORK

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i944_bcl
            CALL g_giy.deleteelement(l_ac)
            IF g_rec_b != 0 THEN
               LET g_action_choice = "detail"
               LET l_ac = l_ac_t
            END IF
            EXIT INPUT
         END IF

         INSERT INTO giy_file(giy01,giy02,giy03,giy04,giy05)
                       VALUES(g_giy[l_ac].giy01,g_giy[l_ac].giy02,
                              g_giy[l_ac].giy03,g_giy04,g_giy05)
          IF sqlca.sqlcode THEN
             CALL cl_err3("ins","giy_file",g_giy[l_ac].giy01,"",sqlca.sqlcode,"","",1)
             LET g_giy[l_ac].* = g_giy_t.*
          ELSE
             MESSAGE 'insert o.k'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO formonly.cn2
          END IF

      ON ACTION controlo                        #沿用所有欄位
         IF l_ac > 1 THEN
            LET g_giy[l_ac].* = g_giy[l_ac-1].*
            NEXT FIELD giy00
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

   CLOSE i944_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i944_b_fill(p_wc2)              #body fill up
DEFINE p_wc2     LIKE type_file.chr1000

   LET g_sql = "SELECT giy01,giy02,giy03",
               "  FROM giy_file",
               " WHERE giy04 = '",g_giy04,"'",
               "   AND giy05 = '",g_giy05,"'",
               " ORDER BY 2"
   PREPARE i944_pb FROM g_sql
   DECLARE giy_curs CURSOR FOR i944_pb

   CALL g_giy.clear()
   LET g_cnt = 1
   MESSAGE "searching!"

   FOREACH giy_curs INTO g_giy[g_cnt].*   #單身array
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

   CALL g_giy.deleteelement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO formonly.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i944_copy()
   DEFINE   l_n       LIKE type_file.num5,
            l_giy04   LIKE giy_file.giy04,
            l_giy05   LIKE giy_file.giy05,
            l_old04   LIKE giy_file.giy04,
            l_old05   LIKE giy_file.giy05

   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF

   IF g_giy04 IS NULL OR g_giy05 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET l_giy04 = NULL
   LET l_giy05 = NULL

   CALL cl_set_head_visible("","yes")
   INPUT l_giy04,l_giy05 WITHOUT DEFAULTS FROM giy04,giy05

      AFTER FIELD giy04
         IF NOT cl_null(l_giy04) AND NOT cl_null(l_giy05) THEN
            SELECT COUNT(giy04) INTO l_n FROM giy_file
             WHERE giy04 = l_giy04
               AND giy05 = l_giy05
            IF l_n > 0 THEN
               LET g_errno = '-239'
            ELSE
               LET g_errno = ' '
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               LET l_giy04 = NULL
               LET g_errno = ' '
               NEXT FIELD giy04
            END IF
         END IF

      AFTER FIELD giy05
         IF NOT cl_null(l_giy05) THEN
            IF l_giy05 < 1 OR l_giy05 > l_tmp  THEN
               CALL cl_err('','agl-020',1)
               NEXT FIELD giy05
            END IF
            IF NOT cl_null(l_giy04) AND NOT cl_null(l_giy05) THEN
               SELECT COUNT(giy04) INTO l_n FROM giy_file
                WHERE giy04 = l_giy04
                  AND giy05 = l_giy05
               IF l_n > 0 THEN
                  LET g_errno = '-239'
               ELSE
                  LET g_errno = ' '
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET l_giy05 = NULL
                  LET g_errno = ' '
                  NEXT FIELD giy05
               END IF
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
          SELECT COUNT(*) INTO g_cnt FROM giy_file
           WHERE gae01 = l_giy04 AND gae11 = l_giy05
          IF g_cnt > 0 THEN
             CALL cl_err_msg(NULL,"azz-110",l_giy04||"|"||l_giy05,10)
          END IF

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
      DISPLAY g_giy04,g_giy05 TO giy04,giy05
      RETURN
   END IF

   DROP TABLE x
   SELECT * FROM giy_file WHERE giy04 = g_giy04 AND giy05 = g_giy05
     INTO TEMP x

   IF sqlca.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",0)
      RETURN
   END IF

   UPDATE x
      SET giy04 = l_giy04,                        #資料鍵值 
          giy05 = l_giy05                         #資料鍵值

   INSERT INTO giy_file SELECT * FROM x

   IF sqlca.sqlcode THEN
      CALL cl_err3("ins","gae_file","","",sqlca.sqlcode,"","",0)
      RETURN
   END IF


   LET l_old04 = g_giy04
   LET l_old05 = g_giy05
   LET g_giy04 = l_giy04
   LET g_giy05 = l_giy05
   CALL i944_b()
   #LET g_giy04 = l_old04  #FUN-C30027
   #LET g_giy05 = l_old05  #FUN-C30027
   #CALL i944_show()       #FUN-C30027
END FUNCTION

FUNCTION i944_r()        #取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,
            l_gae   RECORD LIKE giy_file.*

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_giy04) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM giy_file
       WHERE giy04 = g_giy04 AND giy05 = g_giy05
      CLEAR FORM
      CALL g_giy.CLEAR()
      LET g_giy04 = NULL
      LET g_giy05 = NULL
      CALL i944_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i944_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i944_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i944_fetch('/')
      END IF
   END IF

   CLOSE i944_cs
   COMMIT WORK
END FUNCTION

FUNCTION i944_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "g" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_giy TO s_giy.* ATTRIBUTE(COUNT=g_rec_b)

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

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION FIRST                            # 第一筆
         CALL i944_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION PREVIOUS                         # p.上筆
         CALL i944_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
        ACCEPT DISPLAY
        
      ON ACTION jump                             #指定筆
         CALL i944_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
         
      ON ACTION NEXT                             # n.下筆
         CALL i944_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
         
      ON ACTION LAST                             # 末一筆
         CALL i944_fetch('L')
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

FUNCTION i944_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("giy04,giy05",TRUE)
   END IF
END FUNCTION

FUNCTION i944_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("giy04,giy05",FALSE)
   END IF
END FUNCTION

FUNCTION i944_chk()
   DEFINE l_n      LIKE type_file.num5
   SELECT COUNT(giy04) INTO l_n FROM giy_file
    WHERE giy04 = g_giy04
      AND giy05 = g_giy05
   IF l_n > 0 THEN
      LET g_errno = '-239'
   ELSE 
      LET g_errno = ' ' 
   END IF
END FUNCTION


