# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: p_develop.4gl
# Descriptions...: 客戶開發記錄維護程式  #No.FUN-7A0060
# Date & Author..: 07/09/12 by saki
# Modify.........: No.FUN-840067 08/04/17 by saki 增加記錄共用帳號的實際執行者及客製單位, 上傳自動編譯步驟
# Modify.........: No.FUN-8B0037 08/11/17 by saki 更新訊息
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10050 10/01/11 By Hiko 更正編譯不過的問題:移除rowid
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........; No.FUN-B30176 11/03/25 By xianghui 使用iconv須區分為FOR UNIX& FOR Windows,批量去除$TOP
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60058 11/06/09 By tsai_yen 1.修改清單或資料同步不能進入單身時要顯示訊息 2.修改清單要鎖定時檢查檔案是否被已別人鎖定
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_forupd_sql   STRING
DEFINE   g_gfb          RECORD LIKE gfb_file.*       #開發記錄基本資料
DEFINE   g_gfb_t        RECORD LIKE gfb_file.*
DEFINE   g_gfb01_t      LIKE gfb_file.gfb01
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE
         #g_wc,g_sql     LIKE type_file.chr1000
         g_wc,g_sql      STRING       #NO.FUN-910082
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_gfc          DYNAMIC ARRAY OF RECORD      #開發記錄程式清單
            check       LIKE type_file.chr1,
            gfc02       LIKE gfc_file.gfc02,
            gfc03       LIKE gfc_file.gfc03,
            gfc04       LIKE gfc_file.gfc04,
            gfc05       LIKE gfc_file.gfc05,
            gfc07       LIKE gfc_file.gfc07,
            gfc08       LIKE gfc_file.gfc08,
            gfc09       LIKE gfc_file.gfc09,
            gfc10       LIKE gfc_file.gfc10,
            gfc11       LIKE gfc_file.gfc11,
            gfc12       LIKE gfc_file.gfc12,
            gfc06       LIKE gfc_file.gfc06
                        END RECORD,
         g_gfc_t        RECORD
            check       LIKE type_file.chr1,
            gfc02       LIKE gfc_file.gfc02,
            gfc03       LIKE gfc_file.gfc03,
            gfc04       LIKE gfc_file.gfc04,
            gfc05       LIKE gfc_file.gfc05,
            gfc07       LIKE gfc_file.gfc07,
            gfc08       LIKE gfc_file.gfc08,
            gfc09       LIKE gfc_file.gfc09,
            gfc10       LIKE gfc_file.gfc10,
            gfc11       LIKE gfc_file.gfc11,
            gfc12       LIKE gfc_file.gfc12,
            gfc06       LIKE gfc_file.gfc06
                        END RECORD
DEFINE   g_gfd          DYNAMIC ARRAY OF RECORD      #開發記錄資料清單
            gfd02       LIKE gfd_file.gfd02,
            gfd04       LIKE gfd_file.gfd04,
            gfd06       LIKE gfd_file.gfd06,
            gfd07       LIKE gfd_file.gfd07
                        END RECORD,
         g_gfd_t        RECORD
            gfd02       LIKE gfd_file.gfd02,
            gfd04       LIKE gfd_file.gfd04,
            gfd06       LIKE gfd_file.gfd06,
            gfd07       LIKE gfd_file.gfd07
                        END RECORD
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_rec_b_k      LIKE type_file.num10
DEFINE   l_ac_k         LIKE type_file.num10
DEFINE   g_rec_b_s      LIKE type_file.num10
DEFINE   l_ac_s         LIKE type_file.num10
DEFINE   g_before_input_done   LIKE type_file.num5     #判斷是否已執行 Before Input指令
DEFINE   g_db_type      STRING                         #資料庫類型
DEFINE   g_topcust      STRING                         #客製目錄
DEFINE   gs_action      STRING     #FUN-D30034 add
DEFINE   gk_action      STRING     #FUN-D30034 add

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   #FUN-A10050:移除rowid本來是shell處理,這裡是補處理.

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   LET g_forupd_sql = "  SELECT * FROM gfb_file WHERE gfb01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_develop_cl CURSOR FROM g_forupd_sql
   OPEN WINDOW p_develop_w WITH FORM "azz/42f/p_develop"
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()

   CALL p_develop_set_combobox()     #No.FUN-840067

   LET g_db_type = cl_db_get_database_type()
   LET g_topcust = FGL_GETENV("CUST")

   CALL p_develop_menu()
   CLOSE WINDOW p_develop_w
END MAIN

FUNCTION p_develop_menu()
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
              CALL p_develop_a()
         END IF

      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
              CALL p_develop_q()
         END IF

      ON ACTION next
         CALL p_develop_fetch('N')

      ON ACTION previous
         CALL p_develop_fetch('P')

      ON ACTION jump
         CALL p_develop_fetch('/')

      ON ACTION first
         CALL p_develop_fetch('F')

      ON ACTION last
         CALL p_develop_fetch('L')

      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL p_develop_u()
         END IF

      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL p_develop_r()
         END IF

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL p_develop_set_combobox()   #No.FUN-840067

      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         LET g_action_choice = "exit"
         CONTINUE MENU

      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145
          LET INT_FLAG=FALSE
         LET g_action_choice = "exit"
         EXIT MENU

      ON ACTION developing              #開發中
         LET g_action_choice = "developing"
         IF cl_chk_act_auth() THEN
            CALL p_develop_developing()
         END IF

      ON ACTION mntn_modi_list          #修改清單
         CALL p_develop_k()

      ON ACTION mntn_data_sync          #資料清單
         CALL p_develop_s()

      ON ACTION mntn_tab_modi           #檔案修改
         CALL p_develop_w()

      ON ACTION mntn_tab_zs             #檔案修改記錄
         CALL p_develop_zs()

      ON ACTION complete                #開發完成
         LET g_action_choice = "complete"
         IF cl_chk_act_auth() THEN
            CALL p_develop_complete()
         END IF

      ON ACTION confirm                 #驗收完成
         LET g_action_choice = "confirm"
         IF cl_chk_act_auth() THEN
            CALL p_develop_confirm()
         END IF

      ON ACTION pack
         CALL p_develop_pack()

      ON ACTION mntn_tab_pack_zs
         CALL p_develop_pack_zs()

      ON ACTION db_patch
         CALL p_develop_patch('1')

      ON ACTION patch
         CALL p_develop_patch('2')

      #No.FUN-840067 --start--
      ON ACTION related_document
         IF cl_chk_act_auth() THEN
            IF g_gfb.gfb01 IS NOT NULL THEN
               LET g_doc.column1 = "gfb01"
               LET g_doc.value1 = g_gfb.gfb01
               CALL cl_doc()
            END IF
         END IF
      #No.FUN-840067 ---end---
   END MENU

END FUNCTION

FUNCTION p_develop_cs()
   CLEAR FORM

   CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
      gfb01,gfb02,gfb05,gfb06,gfb04,gfb03,gfb14,gfb16,gfb07,gfb08,gfb11,gfb09,gfb15,gfb10   #No.FUN-840067 add column

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030

   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_sql="SELECT gfb01 FROM gfb_file ", # 組合出 SQL 指令
             " WHERE ",g_wc CLIPPED," ORDER BY gfb01"

   PREPARE p_develop_prepare FROM g_sql
   DECLARE p_develop_cs                           # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR p_develop_prepare
   LET g_sql=
       "SELECT COUNT(*) FROM gfb_file WHERE ",g_wc CLIPPED
   PREPARE p_develop_precount FROM g_sql
   DECLARE p_develop_count CURSOR FOR p_develop_precount
END FUNCTION

FUNCTION p_develop_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )

   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL p_develop_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN p_develop_count
   FETCH p_develop_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN p_develop_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gfb.gfb01,SQLCA.sqlcode,0)
      INITIALIZE g_gfb.* TO NULL
   ELSE
       CALL p_develop_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION p_develop_fetch(p_flzl)
   DEFINE   p_flzl   LIKE type_file.chr1

   CASE p_flzl
      WHEN 'N' FETCH NEXT     p_develop_cs INTO g_gfb.gfb01
      WHEN 'P' FETCH PREVIOUS p_develop_cs INTO g_gfb.gfb01
      WHEN 'F' FETCH FIRST    p_develop_cs INTO g_gfb.gfb01
      WHEN 'L' FETCH LAST     p_develop_cs INTO g_gfb.gfb01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
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
         FETCH ABSOLUTE g_jump p_develop_cs INTO g_gfb.gfb01
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gfb.gfb01,SQLCA.sqlcode,0)
      INITIALIZE g_gfb.* TO NULL
      RETURN
   ELSE
      CASE p_flzl
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF

   SELECT * INTO g_gfb.* FROM gfb_file            # 重讀DB,因TEMP有不被更新特性
      WHERE gfb01 = g_gfb.gfb01

   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfb_file",g_gfb.gfb01,"",SQLCA.sqlcode,"","",0)
   ELSE
      CALL p_develop_show()                       # 重新顯示
   END IF
END FUNCTION

FUNCTION p_develop_show()
   LET g_gfb_t.* = g_gfb.*

   DISPLAY BY NAME
      g_gfb.gfb01,g_gfb.gfb02,g_gfb.gfb03,g_gfb.gfb04,g_gfb.gfb05,
      g_gfb.gfb06,g_gfb.gfb07,g_gfb.gfb08,g_gfb.gfb09,g_gfb.gfb10,
      g_gfb.gfb11,g_gfb.gfb12,g_gfb.gfb13,g_gfb.gfb14,g_gfb.gfb15,
      g_gfb.gfb16             #No.FUN-840067 add column

   CALL p_develop_gfb04()
   CALL p_develop_zx01(g_gfb.gfb03 CLIPPED,'1')
   CALL p_develop_zx01(g_gfb.gfb09 CLIPPED,'2')
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION p_develop_a()
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   INITIALIZE g_gfb.* TO NULL
   LET g_gfb01_t = NULL
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_gfb.gfb02 = "1"
      LET g_gfb.gfb03 = g_user
      LET g_gfb.gfb16 = "1"                     #No.FUN-840067

      CALL p_develop_i("a")                     # 各欄位輸入
      IF INT_FLAG THEN                          # 若按了DEL鍵
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          CLEAR FORM
          EXIT WHILE
      END IF

      IF cl_null(g_gfb.gfb01) THEN
         CALL cl_err(g_gfb.gfb01,STATUS,1)
         EXIT WHILE
      END IF
      DISPLAY BY NAME g_gfb.gfb01

      IF (g_gfb.gfb01 IS NULL) THEN             # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO gfb_file VALUES(g_gfb.*)      # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","gfb_file",g_gfb.gfb01,"",SQLCA.sqlcode,"","",0)
         CONTINUE WHILE
      ELSE
         LET g_gfb_t.* = g_gfb.*                # 保存上筆資料
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p_develop_i(p_cmd)
   DEFINE   p_cmd           LIKE type_file.chr1,
            l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入
            l_n             LIKE type_file.num5,
            l_sql           STRING


   INPUT BY NAME
      g_gfb.gfb01,g_gfb.gfb02,g_gfb.gfb05,g_gfb.gfb06,g_gfb.gfb04,g_gfb.gfb03,
      g_gfb.gfb14,g_gfb.gfb16,g_gfb.gfb07,g_gfb.gfb08,g_gfb.gfb11,
      g_gfb.gfb09,g_gfb.gfb15,g_gfb.gfb10             #No.FUN-840067 add column
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL p_develop_set_entry(p_cmd)
          CALL p_develop_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

      AFTER FIELD gfb01
         IF (g_gfb.gfb01 IS NOT NULL) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_gfb.gfb01 != g_gfb01_t) THEN
               SELECT count(*) INTO l_n FROM gfb_file
                WHERE gfb01 = g_gfb.gfb01
               IF l_n > 0 THEN
                  CALL cl_err(g_gfb.gfb01,-239,1)
                  LET g_gfb.gfb01 = g_gfb01_t
                  DISPLAY BY NAME g_gfb.gfb01
                  NEXT FIELD gfb01
               END IF
            END IF
         END IF

      AFTER FIELD gfb02
         IF (g_gfb.gfb02 IS NOT NULL) THEN
            CASE g_action_choice
               WHEN "developing"
                  IF g_gfb.gfb02 > 2 THEN
                     LET g_gfb.gfb02 = "2"
                     NEXT FIELD gfb02
                  END IF
               WHEN "complete"
                  IF g_gfb.gfb02 > 3 THEN
                     LET g_gfb.gfb02 = "3"
                     NEXT FIELD gfb02
                  END IF
            END CASE
         END IF

      AFTER FIELD gfb04
         IF (g_gfb.gfb04 IS NOT NULL) THEN
            LET l_sql = "SELECT COUNT(*) FROM zz_file",
                        " WHERE zz01 = '",g_gfb.gfb04,"'"
            PREPARE cnt_pre FROM l_sql
            EXECUTE cnt_pre INTO l_n
            IF l_n > 0 THEN
               CALL p_develop_gfb04()
            ELSE
               DISPLAY NULL TO FORMONLY.zz02
            END IF
         END IF

      BEFORE FIELD gfb03
         DISPLAY g_user TO gfb03

      AFTER FIELD gfb03
         IF (g_gfb.gfb03 IS NOT NULL) THEN
            CALL p_develop_zx01(g_gfb.gfb03,'1')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gfb.gfb03,g_errno,0)
               NEXT FIELD gfb03
            END IF
         END IF

      AFTER FIELD gfb09
         IF (g_gfb.gfb09 IS NOT NULL) THEN
            CALL p_develop_zx01(g_gfb.gfb09,'2')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gfb.gfb09,g_errno,0)
               NEXT FIELD gfb09
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN                         # 若按了DEL鍵
            RETURN
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gfb04) #程式代號
               CALL cl_qzz(FALSE,TRUE,g_gfb.gfb04) RETURNING g_gfb.gfb04
               DISPLAY BY NAME g_gfb.gfb04
               CALL p_develop_gfb04()
               NEXT FIELD gfb04

            WHEN INFIELD(gfb03) #程式人員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zx"
               LET g_qryparam.default1 = g_gfb.gfb03
               CALL cl_create_qry() RETURNING g_gfb.gfb03
               CALL p_develop_zx01(g_gfb.gfb03,'1')
               NEXT FIELD gfb03

            WHEN INFIELD(gfb09) #驗收人員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zx"
               LET g_qryparam.default1 = g_gfb.gfb09
               CALL cl_create_qry() RETURNING g_gfb.gfb09
               CALL p_develop_zx01(g_gfb.gfb09,'1')
               NEXT FIELD gfb09

            OTHERWISE EXIT CASE
         END CASE

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
END FUNCTION

FUNCTION p_develop_u()
   IF (g_gfb.gfb01 IS NULL) THEN
      CALL cl_err('Serial No. Null','!',1)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gfb01_t = g_gfb.gfb01
   BEGIN WORK

   OPEN p_develop_cl USING g_gfb.gfb01
   IF STATUS THEN
      CALL cl_err("OPEN gfb_cl:", STATUS, 1)
      CLOSE p_develop_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH p_develop_cl INTO g_gfb.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gfb.gfb01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL p_develop_show()                           # 顯示最新資料
   WHILE TRUE
      CALL p_develop_i("u")                        # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_gfb.*=g_gfb_t.*
         CALL p_develop_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gfb_file SET gfb_file.* = g_gfb.*    # 更新DB
         WHERE gfb01 = g_gfb.gfb01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gfb_file",g_gfb01_t,"",SQLCA.sqlcode,"","",0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE p_develop_cl
   COMMIT WORK
END FUNCTION

FUNCTION p_develop_r()
   DEFINE   l_chr   LIKE type_file.chr1

   IF (g_gfb.gfb01 IS NULL) THEN
      CALL cl_err('Serial No. Null','!',1)
      RETURN
   END IF

   IF (g_gfb.gfb02 != "1") THEN
      CALL cl_err(g_gfb.gfb02,'9003',1)
      RETURN
   END IF

   BEGIN WORK
   OPEN p_develop_cl USING g_gfb.gfb01
   IF STATUS THEN
      CALL cl_err("OPEN gfb_cl:", STATUS, 1)
      CLOSE p_develop_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH p_develop_cl INTO g_gfb.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gfb.gfb01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL p_develop_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "gfb01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_gfb.gfb01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
      DELETE FROM gfb_file
       WHERE gfb01 = g_gfb.gfb01
      IF SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("del","gfb_file",g_gfb.gfb01,"",SQLCA.sqlcode,"","",0)
      ELSE
         DELETE FROM gfc_file
          WHERE gfc01 = g_gfb.gfb01
         DELETE FROM gfd_file
          WHERE gfd01 = g_gfb.gfb01
      END IF
      CLEAR FORM

      OPEN p_develop_count
      #FUN-B50065-add-start--
      IF STATUS THEN
         CLOSE p_develop_cl
         CLOSE p_develop_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50065-add-end--
      FETCH p_develop_count INTO g_row_count
      #FUN-B50065-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE p_develop_cl
         CLOSE p_develop_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50065-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN p_develop_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL p_develop_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL p_develop_fetch('/')
      END IF
   END IF
   CLOSE p_develop_cl
   COMMIT WORK
END FUNCTION

FUNCTION p_develop_k()
   DEFINE   ls_sql     STRING
   DEFINE   lc_gao01   LIKE gao_file.gao01
   DEFINE   ls_str     STRING
   DEFINE   ls_action  STRING

   IF (g_gfb.gfb01 IS NULL) THEN
      CALL cl_err('Mod No. Null','!',1)
      RETURN
   END IF

   IF g_gfb.gfb02 = "1" THEN
      RETURN
   END IF

   OPEN WINDOW p_gfc_w WITH FORM "azz/42f/p_dev_filelist"
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_locale("p_dev_filelist")
   CALL p_gfc_b_fill()

   #製作gfc03 客製目錄選項
   CASE g_db_type
      WHEN "ORA"
         LET ls_sql = "SELECT gao01 FROM gao_file WHERE gao01 LIKE 'C%' ORDER BY gao01"
      WHEN "IFX"
         LET ls_sql = "SELECT gao01 FROM gao_file WHERE gao01 MATCHES 'C*' ORDER BY gao01"
   END CASE
   PREPARE gao_pre FROM ls_sql
   DECLARE gao_curs CURSOR FOR gao_pre
   FOREACH gao_curs INTO lc_gao01
      IF NOT cl_null(lc_gao01) THEN
         LET ls_str = ls_str,DOWNSHIFT(lc_gao01 CLIPPED),","
      END IF
   END FOREACH
   LET ls_str = ls_str.subString(1,ls_str.getLength()-1)
   CALL cl_set_combo_items("gfc03",ls_str.trim(),ls_str.trim())

   WHILE TRUE
     #LET ls_action = ""   #FUN-D30034 mark
      IF gk_action = "detail" THEN #FUN-D30034 add
      ELSE    #FUN-D30034 add
         LET gk_action = ""   #FUN-D30034 add
         CALL cl_set_act_visible("accept,cancel",FALSE)
         DISPLAY g_gfb.gfb01 TO gfc01
         DISPLAY ARRAY g_gfc TO s_gfc.* ATTRIBUTE(COUNT=g_rec_b_k,UNBUFFERED)

            ON ACTION detail
               LET l_ac_k = 1
              #LET ls_action = "detail"  #FUN-D30034 mark
               LET gk_action = "detail"  #FUN-D30034 add
               EXIT DISPLAY

            ON ACTION accept
               LET l_ac_k = ARR_CURR()
              #LET ls_action = "detail"  #FUN-D30034 mark
               LET gk_action = "detail"  #FUN-D30034 add
               EXIT DISPLAY

            ON ACTION download_file
              #LET ls_action = "download_file"  #FUN-D30034 mark 
               LET gk_action = "download_file"  #FUN-D30034 add
               EXIT DISPLAY

            ON ACTION upload_file
              #LET ls_action = "upload_file"   #FUN-D30034 mark
               LET gk_action = "upload_file"   #FUN-D30034 add
               EXIT DISPLAY

            #No.FUN-840067 --start--
            ON ACTION auto_compile
               LET l_ac_k = ARR_CURR()
              #LET ls_action = "auto_compile"  #FUN-D30034 mark
               LET gk_action = "auto_compile"  #FUN-D30034 add
               EXIT DISPLAY
            #No.FUN-840067 ---end---

            ON ACTION exit
               LET INT_FLAG = 1
               EXIT DISPLAY

            ON ACTION exporttoexcel
               CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_gfc),'','')

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()

            ON ACTION controlg
               CALL cl_cmdask()

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DISPLAY
         END DISPLAY
         CALL cl_set_act_visible("accept,cancel",TRUE)
      END IF   #FUN-D30034 add
     #CASE ls_action  #FUN-D30034 mark
      CASE gk_action  #FUN-D30034 add
         WHEN "detail"
            IF (g_gfb.gfb02 = '2') AND (g_gfb.gfb03 = g_user) THEN
               CALL p_gfc_b()
            ELSE                                #FUN-B60058
               CALL cl_err( '', 'azz1085', 1 )  #FUN-B60058
            END IF
         WHEN "download_file"
            CALL p_develop_file_download()
         WHEN "upload_file"
            CALL p_develop_file_upload()
         #No.FUN-840067 --start--
         WHEN "auto_compile"
            IF l_ac_k > 0 THEN
               CALL p_develop_file_compile_step(g_gfc[l_ac_k].gfc03 CLIPPED,g_gfc[l_ac_k].gfc04 CLIPPED,g_gfc[l_ac_k].gfc05 CLIPPED)
            END IF
         #No.FUN-840067 ---end---
      END CASE
      IF INT_FLAG THEN
         EXIT WHILE
      END IF
   END WHILE
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p_gfc_w
   END IF
END FUNCTION

FUNCTION p_gfc_b_fill()
   LET g_sql =
      "SELECT 'N',gfc02,gfc03,gfc04,gfc05,gfc07,gfc08,gfc09,gfc10,gfc11,gfc12,gfc06 FROM gfc_file ",
      " WHERE gfc01 = '",g_gfb.gfb01 CLIPPED,"'",
      " ORDER BY gfc02,gfc03,gfc04,gfc05"
   PREPARE p_gfc_prepare FROM g_sql      #預備一下
   DECLARE p_gfc_curs CURSOR FOR p_gfc_prepare
   CALL g_gfc.clear()
   LET g_cnt = 1
   FOREACH p_gfc_curs INTO g_gfc[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_gfc.deleteElement(g_cnt)
   LET g_rec_b_k = g_cnt - 1
   DISPLAY g_rec_b_k TO FORMONLY.cn2
END FUNCTION

FUNCTION p_gfc_b()
   DEFINE   l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT
            l_n             LIKE type_file.num5,   #檢查重複用
            l_lock_sw       LIKE type_file.chr1,   #單身鎖住否
            p_cmd           LIKE type_file.chr1    #處理狀態
   DEFINE   l_allow_insert  LIKE type_file.num5    #可新增否
   DEFINE   l_allow_delete  LIKE type_file.num5    #可刪除否
   DEFINE   lc_sys          STRING                 #系統別
   DEFINE   ls_file         STRING                 #檔案路徑
   DEFINE   li_booking      LIKE type_file.num10   #FUN-B60058
   DEFINE   ls_sql          STRING                 #FUN-B60058
   DEFINE   lc_gfc01        LIKE gfc_file.gfc01    #開發單號    #FUN-B60058
   DEFINE   lc_gfc08        LIKE gfc_file.gfc08    #開發者     #FUN-B60058
   DEFINE   ls_prog         STRING                 #FUN-B60058
   DEFINE   ls_msg          STRING                 #FUN-B60058

   MESSAGE ""
   CALL cl_opmsg('b')

   LET g_forupd_sql =
        "SELECT 'N',gfc02,gfc03,gfc04,gfc05,gfc07,gfc08,gfc09,gfc10,gfc11,gfc12,gfc06 FROM gfc_file",
        " WHERE gfc01 = ? AND gfc02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gfc_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_action_choice = ""
   LET gk_action = ""    #FUN-D30034 add
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   IF g_rec_b_k = 0 THEN
      CALL g_gfc.clear()
      #沒有資料按下B單身時，自動加4gl跟4fd檔的資料
      IF (g_gfb.gfb02 = "2") THEN
         CASE
            WHEN g_gfb.gfb04[1,2] = "p_" OR g_gfb.gfb04[1,3] = "cp_"
               LET lc_sys = "zz"
            WHEN g_gfb.gfb04[1,2] = "s_" OR g_gfb.gfb04[1,3] = "cs_"
               LET lc_sys = "sub"
            WHEN g_gfb.gfb04[1,2] = "q_" OR g_gfb.gfb04[1,3] = "cq_"
               LET lc_sys = "qry"
            WHEN g_gfb.gfb04[1,3] = "cl_" OR g_gfb.gfb04[1,4] = "ccl_"
               LET lc_sys = "lib"
            OTHERWISE
               LET lc_sys = g_gfb.gfb04[2,3]
         END CASE
         LET g_gfc[1].gfc02 = 1
         LET g_gfc[1].gfc03 = "c",lc_sys
         LET g_gfc[1].gfc04 = "4gl"
         LET g_gfc[1].gfc05 = g_gfb.gfb04 CLIPPED,".4gl"
         LET g_gfc[1].gfc07 = "1"
         INSERT INTO gfc_file(gfc01,gfc02,gfc03,gfc04,gfc05,gfc07)
                        VALUES(g_gfb.gfb01,g_gfc[1].gfc02,
                               g_gfc[1].gfc03,g_gfc[1].gfc04,
                               g_gfc[1].gfc05,g_gfc[1].gfc07)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gfc_file",g_gfb.gfb01,g_gfc[1].gfc02,SQLCA.sqlcode,"","",0)
         ELSE
            LET g_rec_b_k = g_rec_b_k + 1
         END IF
         LET g_gfc[2].gfc02 = 2
         LET g_gfc[2].gfc03 = "c",lc_sys
         LET g_gfc[2].gfc04 = "4fd"
         LET g_gfc[2].gfc05 = g_gfb.gfb04 CLIPPED,".4fd"
         LET g_gfc[2].gfc07 = "1"
         INSERT INTO gfc_file(gfc01,gfc02,gfc03,gfc04,gfc05,gfc07)
                        VALUES(g_gfb.gfb01,g_gfc[2].gfc02,
                               g_gfc[2].gfc03,g_gfc[2].gfc04,
                               g_gfc[2].gfc05,g_gfc[2].gfc07)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gfc_file",g_gfb.gfb01,g_gfc[2].gfc02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
         ELSE
            LET g_rec_b_k = g_rec_b_k + 1
         END IF
      END IF
   END IF

   LET l_ac_t = 0
   CALL cl_set_comp_entry("check",FALSE)
   INPUT ARRAY g_gfc WITHOUT DEFAULTS FROM s_gfc.*
      ATTRIBUTE (COUNT=g_rec_b_k,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,
                 APPEND ROW = l_allow_insert)

      BEFORE INPUT
         IF g_rec_b_k != 0 THEN
            CALL fgl_set_arr_curr(l_ac_k)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac_k = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b_k >= l_ac_k  THEN
            LET p_cmd='u'
            LET g_gfc_t.* = g_gfc[l_ac_k].*  #BACKUP
            OPEN p_gfc_bcl USING g_gfb.gfb01,g_gfc_t.gfc02
            IF STATUS THEN
               CALL cl_err("OPEN p_gfc_bcl", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_gfc_bcl INTO g_gfc[l_ac_k].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gfc_t.gfc02,SQLCA.sqlcode,1)
                  LET l_lock_sw = 'Y'
               ELSE
                  LET g_gfc_t.*=g_gfc[l_ac_k].*
               END IF
            END IF
         END IF

      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_gfc[l_ac_k].* TO NULL
         LET g_gfc_t.* = g_gfc[l_ac_k].*
         NEXT FIELD gfc02


      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF g_gfc[l_ac_k].gfc02 IS NULL OR    #重要欄位空白,無效
            g_gfc[l_ac_k].gfc03 IS NULL OR    #
            g_gfc[l_ac_k].gfc04 IS NULL OR    #
            g_gfc[l_ac_k].gfc05 IS NULL THEN  #
            INITIALIZE g_gfc[l_ac_k].* TO NULL
            CANCEL INSERT
         END IF
         #檢查有沒有重復
         IF (g_gfc[l_ac_k].gfc03 != g_gfc_t.gfc03) OR
            (g_gfc[l_ac_k].gfc04 != g_gfc_t.gfc04) OR
            (g_gfc[l_ac_k].gfc05 != g_gfc_t.gfc05) OR
            cl_null(g_gfc_t.gfc03) OR
            cl_null(g_gfc_t.gfc04) OR
            cl_null(g_gfc_t.gfc05) THEN

            IF NOT cl_null(g_gfc[l_ac_k].gfc05) AND NOT cl_null(g_gfc[l_ac_k].gfc04) AND
               NOT cl_null(g_gfc[l_ac_k].gfc03) THEN
               SELECT COUNT(*) INTO l_n FROM gfc_file
                WHERE gfc01 = g_gfb.gfb01
                  AND gfc03 = g_gfc[l_ac_k].gfc03 AND gfc04 = g_gfc[l_ac_k].gfc04
                  AND gfc05 = g_gfc[l_ac_k].gfc05
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD gfc05
               END IF
            END IF
         END IF

         #檢查輸入的檔案有沒有存在，只能存在客製區
         LET ls_file = g_topcust,os.Path.separator(),g_gfc[l_ac_k].gfc03 CLIPPED,
                       os.Path.separator(),g_gfc[l_ac_k].gfc04 CLIPPED,
                       os.Path.separator(),g_gfc[l_ac_k].gfc05 CLIPPED
         IF NOT os.Path.exists(ls_file) THEN
            CALL cl_err(ls_file||" ","azz-772",1)   #No.FUN-8B0037
            NEXT FIELD gfc05
         END IF

         INSERT INTO gfc_file(gfc01,gfc02,gfc03,gfc04,gfc05,gfc06,gfc07,gfc08,gfc09,gfc10,gfc11)
                       VALUES(g_gfb.gfb01,g_gfc[l_ac_k].gfc02,
                              g_gfc[l_ac_k].gfc03,g_gfc[l_ac_k].gfc04,
                              g_gfc[l_ac_k].gfc05,g_gfc[l_ac_k].gfc06,
                              g_gfc[l_ac_k].gfc07,g_gfc[l_ac_k].gfc08,
                              g_gfc[l_ac_k].gfc09,g_gfc[l_ac_k].gfc10,
                              g_gfc[l_ac_k].gfc11)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gfc_file",g_gfb.gfb01,g_gfc[l_ac_k].gfc02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            ROLLBACK WORK
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b_k = g_rec_b_k + 1
            DISPLAY g_rec_b_k TO FORMONLY.cn2

            #Booking檔案
            IF g_gfc[l_ac_k].gfc07 = "0" THEN
               CALL p_develop_lock_file()
            END IF
         END IF

      BEFORE FIELD gfc02
         IF cl_null(g_gfc[l_ac_k].gfc02) OR g_gfc[l_ac_k].gfc02 = 0 THEN
            SELECT MAX(gfc02)+1 INTO g_gfc[l_ac_k].gfc02 FROM gfc_file
             WHERE gfc01 = g_gfb.gfb01
            IF cl_null(g_gfc[l_ac_k].gfc02) THEN
               LET g_gfc[l_ac_k].gfc02 = 1
            END IF
         END IF

      AFTER FIELD gfc02
         IF g_gfc[l_ac_k].gfc02 IS NOT NULL AND
            (g_gfc[l_ac_k].gfc02 != g_gfc_t.gfc02 OR
             g_gfc_t.gfc02 IS NULL) THEN
            SELECT COUNT(*) INTO l_n FROM gfc_file
             WHERE gfc01 = g_gfb.gfb01 AND gfc02 = g_gfc[l_ac_k].gfc02
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_gfc[l_ac_k].gfc02 = g_gfc_t.gfc02
               NEXT FIELD gfc02
            END IF
         END IF

      AFTER FIELD gfc05
         #檢查有沒有重復
         IF (g_gfc[l_ac_k].gfc03 != g_gfc_t.gfc03) OR
            (g_gfc[l_ac_k].gfc04 != g_gfc_t.gfc04) OR
            (g_gfc[l_ac_k].gfc05 != g_gfc_t.gfc05) OR
            cl_null(g_gfc_t.gfc03) OR
            cl_null(g_gfc_t.gfc04) OR
            cl_null(g_gfc_t.gfc05) THEN

            IF NOT cl_null(g_gfc[l_ac_k].gfc05) AND NOT cl_null(g_gfc[l_ac_k].gfc04) AND
               NOT cl_null(g_gfc[l_ac_k].gfc03) THEN
               SELECT COUNT(*) INTO l_n FROM gfc_file
                WHERE gfc01 = g_gfb.gfb01
                  AND gfc03 = g_gfc[l_ac_k].gfc03 AND gfc04 = g_gfc[l_ac_k].gfc04
                  AND gfc05 = g_gfc[l_ac_k].gfc05
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD gfc05
               END IF
            END IF
         END IF

         #檢查輸入的檔案有沒有存在，以ORA測試區為主
         LET ls_file = g_topcust,os.Path.separator(),g_gfc[l_ac_k].gfc03 CLIPPED,
                       os.Path.separator(),g_gfc[l_ac_k].gfc04 CLIPPED,
                       os.Path.separator(),g_gfc[l_ac_k].gfc05 CLIPPED
         IF NOT os.Path.exists(ls_file) THEN
            CALL cl_err(ls_file||" ","azz-772",1)   #No.FUN-8B0037
            NEXT FIELD gfc05
         END IF

      AFTER FIELD gfc07   #FUN-B60058
        IF g_gfc[l_ac_k].gfc07 = "0" THEN
           LET li_booking = FALSE
           LET ls_msg = NULL
           LET ls_sql = "SELECT gfc01,gfc08 FROM gfc_file",
                        " WHERE gfc01 <> ?",
                         " AND gfc03 = ?",
                         " AND gfc04 = ?",
                         " AND gfc05 = ?",
                         " AND gfc07 = '0'"
           PREPARE p_gfc_b_pre FROM ls_sql
           DECLARE p_gfc_b_curs CURSOR FOR p_gfc_b_pre
           FOREACH p_gfc_b_curs USING g_gfb.gfb01,g_gfc[l_ac_k].gfc03,g_gfc[l_ac_k].gfc04,g_gfc[l_ac_k].gfc05 INTO lc_gfc01,lc_gfc08
              IF SQLCA.sqlcode THEN
                 MESSAGE "check ",g_gfc[l_ac_k].gfc05 CLIPPED," booking error"
                 LET li_booking = TRUE
                 EXIT FOREACH
              END IF
              LET li_booking = TRUE
              LET ls_msg = ls_msg CLIPPED,'\n',lc_gfc01 CLIPPED," (",lc_gfc08 CLIPPED,")"
           END FOREACH
           IF (li_booking) THEN
              #顯示檔案被lock的訊息
              LET ls_prog=g_gfc[l_ac_k].gfc03 CLIPPED,'/',
                          g_gfc[l_ac_k].gfc04 CLIPPED,'/',
                          g_gfc[l_ac_k].gfc05 CLIPPED,' '
              LET ls_msg = ls_prog,"|",ls_msg
              CALL cl_err_msg("","azz1086",ls_msg,1)
              LET g_gfc[l_ac_k].gfc07 = g_gfc_t.gfc07
              DISPLAY BY NAME g_gfc[l_ac_k].gfc07
              NEXT FIELD gfc07
           END IF
        END IF

      BEFORE DELETE                            #是否取消單身
         IF g_gfc_t.gfc02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = 'Y' THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM gfc_file
             WHERE gfc01 = g_gfb.gfb01
               AND gfc02 = g_gfc_t.gfc02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gfc_file",g_gfb.gfb01,g_gfc_t.gfc02,SQLCA.sqlcode,"","",0)
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               LET g_rec_b_k = g_rec_b_k - 1
               DISPLAY g_rec_b_k TO FORMONLY.cn2
               MESSAGE 'Delete ok!'
               COMMIT WORK
            END IF
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gfc[l_ac_k].* = g_gfc_t.*
            CLOSE p_gfc_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         #檢查輸入的檔案有沒有存在，以ORA測試區為主
         LET ls_file = g_topcust,os.Path.separator(),g_gfc[l_ac_k].gfc03 CLIPPED,
                       os.Path.separator(),g_gfc[l_ac_k].gfc04 CLIPPED,
                       os.Path.separator(),g_gfc[l_ac_k].gfc05 CLIPPED
         IF NOT os.Path.exists(ls_file) THEN
            CALL cl_err(ls_file||" ","azz-772",1)   #No.FUN-8B0037
            NEXT FIELD gfc05
         END IF

         IF l_lock_sw = 'Y' THEN
            CALL cl_err('lock err',-263,1)
            LET g_gfc[l_ac_k].* = g_gfc_t.*
         ELSE
            UPDATE gfc_file
               SET gfc02=g_gfc[l_ac_k].gfc02,
                   gfc03=g_gfc[l_ac_k].gfc03,
                   gfc04=g_gfc[l_ac_k].gfc04,
                   gfc05=g_gfc[l_ac_k].gfc05,
                   gfc06=g_gfc[l_ac_k].gfc06,
                   gfc07=g_gfc[l_ac_k].gfc07
             WHERE gfc01 = g_gfb.gfb01 AND gfc02 = g_gfc_t.gfc02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","gfc_file",g_gfb.gfb01,g_gfc_t.gfc02,SQLCA.sqlcode,"","",0)
                LET g_gfc[l_ac_k].* = g_gfc_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
                IF g_gfc[l_ac_k].gfc07 != g_gfc_t.gfc07 THEN
                   CALL p_develop_lock_file()
                END IF
             END IF
         END IF

      AFTER ROW
         LET l_ac_k = ARR_CURR()
        #LET l_ac_t = l_ac_k  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gfc[l_ac_k].* = g_gfc_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gfc.deleteElement(l_ac_k)
               IF g_rec_b_k != 0 THEN
                  LET gk_action = "detail"
                  LET l_ac_k = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_gfc_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac_k  #FUN-D30034 add
         CLOSE p_gfc_bcl
         COMMIT WORK

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gfc02) AND l_ac_k > 1 THEN
            LET g_gfc[l_ac_k].* = g_gfc[l_ac_k - 1].*
            DISPLAY BY NAME g_gfc[l_ac_k].*
            NEXT FIELD gfc02
         END IF

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

   END INPUT
   CALL cl_set_comp_entry("check",TRUE)

   CLOSE p_gfc_bcl
   COMMIT WORK
END FUNCTION

FUNCTION p_develop_file_download()
   DEFINE   ls_source  STRING
   DEFINE   ls_purpose STRING
   DEFINE   ls_path    STRING
   DEFINE   li_i       LIKE type_file.num5
   DEFINE   li_result  LIKE type_file.num5
   DEFINE   li_result2 LIKE type_file.num5
   DEFINE   lc_gfc02   LIKE gfc_file.gfc02
   DEFINE   lc_gfc12   LIKE gfc_file.gfc12
   DEFINE   ls_msg     STRING


   FOR li_i = 1 TO g_gfc.getLength()
       LET g_gfc[li_i].check = "N"
   END FOR

   CALL cl_set_comp_entry("gfc02,gfc03,gfc04,gfc05,gfc06,gfc07",FALSE)
   INPUT ARRAY g_gfc WITHOUT DEFAULTS FROM s_gfc.*
      ATTRIBUTE (COUNT=g_rec_b_k,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW = FALSE,
                 APPEND ROW = FALSE)
      BEFORE ROW
         LET li_i = ARR_CURR()

      ON CHANGE check
         IF g_gfc[li_i].gfc07 != "0" AND g_gfc[li_i].check = "Y" THEN
            LET g_gfc[li_i].check = "N"
            CALL cl_err(g_gfc[li_i].gfc07,"azz-756",0)
         END IF
   END INPUT
   CALL cl_set_comp_entry("gfc02,gfc03,gfc04,gfc05,gfc06,gfc07",TRUE)
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      RETURN
   END IF

   LET ls_path = p_develop_browse("download","dir")
   IF cl_null(ls_path) THEN
      RETURN
   END IF

   LET li_result2 = TRUE
   LET ls_msg = NULL
   FOR li_i = 1 TO g_gfc.getLength()
       IF g_gfc[li_i].check != "Y" THEN
          CONTINUE FOR
       END IF
       LET ls_source = g_topcust,"/",g_gfc[li_i].gfc03 CLIPPED,"/",g_gfc[li_i].gfc04 CLIPPED,"/",g_gfc[li_i].gfc05 CLIPPED
       LET ls_purpose = ls_path,"/",g_gfc[li_i].gfc05 CLIPPED
       CALL cl_download_file(ls_source,ls_purpose) RETURNING li_result
       IF NOT li_result THEN
          LET ls_msg = ls_msg,ls_source,"\n"
          LET li_result2 = FALSE
       ELSE
          LET lc_gfc02 = g_gfc[li_i].gfc02 CLIPPED
          LET lc_gfc12 = ls_purpose
          UPDATE gfc_file SET gfc10=TODAY, gfc12 = lc_gfc12
           WHERE gfc01=g_gfb.gfb01 AND gfc02=lc_gfc02
       END IF
   END FOR
   IF li_result2 THEN
      CALL cl_err_msg("","azz-763",ls_path,1)
   ELSE
      CALL cl_err(ls_msg,"azz-764",1)
   END IF

   FOR li_i = 1 TO g_gfc.getLength()
       LET g_gfc[li_i].check = "N"
   END FOR
   CALL p_gfc_b_fill()
END FUNCTION

FUNCTION p_develop_file_upload()
   DEFINE   ls_source  STRING
   DEFINE   ls_purpose STRING
   DEFINE   ls_file    STRING
   DEFINE   li_i       LIKE type_file.num5
   DEFINE   li_item    LIKE type_file.num5
   DEFINE   li_result  LIKE type_file.num5
   DEFINE   li_result2 LIKE type_file.num5
   DEFINE   lc_gfc02   LIKE gfc_file.gfc02

   LET li_result2 = TRUE
   LET ls_source = p_develop_browse("upload","file")
   IF cl_null(ls_source) THEN
      RETURN
   END IF

   LET ls_file = ls_source
   WHILE ls_file.getIndexOf("/",1)
      LET ls_file = ls_file.subString(ls_file.getIndexOf("/",1)+1,ls_file.getLength())
   END WHILE
   FOR li_i = 1 TO g_gfc.getLength()
       IF g_gfc[li_i].gfc05 = ls_file THEN
          LET li_item = li_i
          EXIT FOR
       END IF
   END FOR
   IF li_item <= 0 THEN
      CALL cl_err("You aren't booking this file","!",1)
      RETURN
   END IF

   #上傳權限必須為本人及有booking才可以做
   IF g_gfc[li_item].gfc07 =0 AND g_gfc[li_item].gfc08 = g_user AND
      g_gfc[li_item].gfc05 = ls_file THEN
      LET ls_purpose = g_topcust,os.Path.separator(),g_gfc[li_item].gfc03 CLIPPED,os.Path.separator(),g_gfc[li_item].gfc04 CLIPPED,os.Path.separator(),g_gfc[li_item].gfc05 CLIPPED
      CALL cl_upload_file(ls_source,ls_purpose||".bak") RETURNING li_result
      IF NOT li_result THEN
         CALL cl_err("","azz-761",1)
         RETURN                              #No.FUN-840067
      ELSE
         LET lc_gfc02 = g_gfc[li_item].gfc02
         IF os.Path.exists(ls_purpose||".bak") THEN
            # 之後要做比對上傳的檔案(.bak)跟原本檔案的大小後,詢問是否要刪除client端的檔案 (還未決議要作)
            IF os.Path.copy(ls_purpose||".bak",ls_purpose) THEN
               CALL os.Path.delete(ls_purpose||".bak") RETURNING li_result
               UPDATE gfc_file SET gfc11=TODAY,gfc12=""
                WHERE gfc01=g_gfb.gfb01 AND gfc02=lc_gfc02
               CALL cl_err("","azz-762",2)
            ELSE
               CALL cl_err("","azz-761",1)
               RETURN                        #No.FUN-840067
            END IF
         ELSE
            CALL cl_err("","azz-761",1)
            RETURN                           #No.FUN-840067
         END IF
      END IF
   ELSE
      CALL cl_err("","azz-761",1)
      RETURN                                 #No.FUN-840067
   END IF
   CALL p_gfc_b_fill()

   CALL p_develop_file_compile_step(g_gfc[li_item].gfc03 CLIPPED,g_gfc[li_item].gfc04,ls_file)    #No.FUN-840067
END FUNCTION

FUNCTION p_develop_s()
   DEFINE   ls_action   STRING

   IF (g_gfb.gfb01 IS NULL) THEN
      CALL cl_err('No. is Null','!',1)
      RETURN
   END IF

   IF g_gfb.gfb02 = "1" THEN
      RETURN
   END IF

   OPEN WINDOW p_gfd_w WITH FORM "azz/42f/p_dev_datalist"
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_locale("p_dev_datalist")
   CALL p_gfd_b_fill()

   WHILE TRUE
      IF gs_action = "detail" THEN   #FUN-D30034 add
      ELSE   #FUN-D30034 add
         LET gs_action = ""   #FUN-D30034 add
         CALL cl_set_act_visible("accept,cancel",FALSE)
         DISPLAY g_gfb.gfb01 TO gfd01
         DISPLAY ARRAY g_gfd TO s_gfd.* ATTRIBUTE(COUNT=g_rec_b_s,UNBUFFERED)

            ON ACTION detail
               LET l_ac_s = 1
              #LET ls_action = "detail"   #FUN-D30034 mark
               LET gs_action = "detail"   #FUN-D30034 add
               EXIT DISPLAY

            ON ACTION accept
               LET l_ac_s = ARR_CURR()
              #LET ls_action = "detail"  #FUN-D30034 mark
               LET gs_action = "detail"  #FUN-D30034 add
               EXIT DISPLAY

            ON ACTION exporttoexcel
               CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_gfd),'','')

            ON ACTION exit
               LET INT_FLAG = 1
               EXIT DISPLAY

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()

            ON ACTION controlg
               CALL cl_cmdask()

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DISPLAY

         END DISPLAY
         CALL cl_set_act_visible("accept,cancel",TRUE)
      END IF   #FUN-D30034 add
     #IF ls_action = "detail" THEN  #FUN-D30034 mark
      IF gs_action = "detail" THEN  #FUN-D30034 add 
        #LET ls_action = ""  #FUN-D30034 mark
         LET gs_action = ""  #FUN-D30034 add
         #IF (g_gfb.gfb02 = '2') THEN                           #FUN-B60058 mark
         IF (g_gfb.gfb02 = '2') AND (g_gfb.gfb03 = g_user) THEN #FUN-B60058
            CALL p_gfd_b()
         ELSE                                #FUN-B60058
            CALL cl_err( '', 'azz1085', 1 )  #FUN-B60058
         END IF
      END IF
      IF INT_FLAG THEN
         EXIT WHILE
      END IF
   END WHILE
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p_gfd_w
   END IF
END FUNCTION

FUNCTION p_gfd_b_fill()
   LET g_sql =
      "SELECT gfd02,gfd04,gfd06,gfd07 FROM gfd_file ",
      " WHERE gfd01 = '",g_gfb.gfb01 CLIPPED,"' ORDER BY gfd02,gfd04"

   PREPARE p_gfd_prepare FROM g_sql      #預備一下
   DECLARE p_gfd_curs CURSOR FOR p_gfd_prepare
   CALL g_gfd.clear()
   LET g_cnt = 1
   FOREACH p_gfd_curs INTO g_gfd[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gfd.deleteElement(g_cnt)

   MESSAGE ""
   LET g_rec_b_s = g_cnt-1
   DISPLAY g_rec_b_s TO FORMONLY.cn2
END FUNCTION

FUNCTION p_gfd_b()
   DEFINE   l_allow_insert  LIKE type_file.num5      #可新增否
   DEFINE   l_allow_delete  LIKE type_file.num5      #可刪除否
   DEFINE   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT
            l_n             LIKE type_file.num5,     #檢查重複用
            l_lock_sw       LIKE type_file.chr1,     #單身鎖住否
            p_cmd           LIKE type_file.chr1,     #處理狀態
            l_sql           STRING,
            l_gfd05         LIKE gfd_file.gfd05
   DEFINE   li_cnt          LIKE type_file.num5
   DEFINE   li_dlist_cnt    LIKE type_file.num5
   DEFINE   ls_str          STRING
   DEFINE   l_key1          LIKE type_file.chr6      #存放各表的KEY值1
   DEFINE   l_key2          LIKE type_file.chr6      #存放各表的KEY值2

   MESSAGE ""
   CALL cl_opmsg('b')

   LET g_forupd_sql =
        "SELECT gfd02,gfd04,gfd06,gfd07 FROM gfd_file",
        " WHERE gfd01 = ? AND gfd02 = ? FOR UPDATE"

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gfd_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_action_choice = ""
   LET gs_action = ""    #FUN-D30034 add
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   IF g_rec_b_s = 0 THEN
      CALL g_gfd.clear()
      #沒有資料按下B單身時，自動加程式清單的1,3選項資料
      IF (g_gfb.gfb02 = "2") THEN
         FOR l_n = 1 TO g_gfc.getLength()
             IF g_gfc[l_n].gfc04 = "4gl" THEN
                # 程式的p_zz
                LET ls_str = g_gfc[l_n].gfc05 CLIPPED
                LET ls_str = ls_str.subString(1,ls_str.getIndexOf(".4gl",1)-1)
                LET g_gfd[li_dlist_cnt+1].gfd02 = li_dlist_cnt + 1
                LET g_gfd[li_dlist_cnt+1].gfd04 = "1"
                LET l_gfd05 = "zz_file"
                LET g_gfd[li_dlist_cnt+1].gfd06 = ls_str
                INSERT INTO gfd_file(gfd01,gfd02,gfd04,gfd05,gfd06)
                               VALUES(g_gfb.gfb01,g_gfd[li_dlist_cnt+1].gfd02,
                                      g_gfd[li_dlist_cnt+1].gfd04,l_gfd05,
                                      g_gfd[li_dlist_cnt+1].gfd06)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","gfd_file",g_gfb.gfb01,g_gfd[li_dlist_cnt+1].gfd02,SQLCA.sqlcode,"","",0)
                ELSE
                   LET g_rec_b_s = g_rec_b_s + 1
                   LET li_dlist_cnt = li_dlist_cnt + 1
                END IF
             END IF

             IF g_gfc[l_n].gfc04 = "4fd" THEN
                # 程式的p_perlang
                LET ls_str = g_gfc[l_n].gfc05 CLIPPED
                LET ls_str = ls_str.subString(1,ls_str.getIndexOf(".4fd",1)-1)
                LET g_gfd[li_dlist_cnt+1].gfd02 = li_dlist_cnt + 1
                LET g_gfd[li_dlist_cnt+1].gfd04 = "4"
                LET l_gfd05 = "gae_file"
                LET g_gfd[li_dlist_cnt+1].gfd06 = ls_str
                INSERT INTO gfd_file(gfd01,gfd02,gfd04,gfd05,gfd06)
                               VALUES(g_gfb.gfb01,g_gfd[li_dlist_cnt+1].gfd02,
                                      g_gfd[li_dlist_cnt+1].gfd04,l_gfd05,
                                      g_gfd[li_dlist_cnt+1].gfd06)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","gfd_file",g_gfb.gfb01,g_gfd[li_dlist_cnt+1].gfd02,SQLCA.sqlcode,"","",0)
                ELSE
                   LET g_rec_b_s = g_rec_b_s + 1
                   LET li_dlist_cnt = li_dlist_cnt + 1
                END IF
             END IF
         END FOR
      END IF
   END IF

   LET l_ac_t = 0
   INPUT ARRAY g_gfd WITHOUT DEFAULTS FROM s_gfd.*
      ATTRIBUTE (COUNT=g_rec_b_s,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,
                 APPEND ROW = l_allow_insert)

      BEFORE INPUT
         IF g_rec_b_s != 0 THEN
            CALL fgl_set_arr_curr(l_ac_s)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac_s = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b_s >= l_ac_s THEN
            LET p_cmd='u'
            LET g_gfd_t.* = g_gfd[l_ac_s].*  #BACKUP
            OPEN p_gfd_bcl USING g_gfb.gfb01,g_gfd_t.gfd02
            IF STATUS THEN
               CALL cl_err("OPEN p_gfd_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_gfd_bcl INTO g_gfd[l_ac_s].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gfd_t.gfd02,SQLCA.sqlcode,1)
                  LET l_lock_sw = 'Y'
               ELSE
                  LET g_gfd_t.*=g_gfd[l_ac_s].*
               END IF
            END IF
         END IF

      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_gfd[l_ac_s].* TO NULL      #900423
         LET g_gfd_t.* = g_gfd[l_ac_s].*         #新輸入資料
         NEXT FIELD gfd02

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         CASE g_gfd[l_ac_s].gfd04
              WHEN '1' LET l_gfd05='zz_file'
              WHEN '2' LET l_gfd05='ze_file'
              WHEN '3' LET l_gfd05='gao_file'
              WHEN '4' LET l_gfd05='gae_file'
              WHEN '5' LET l_gfd05='gab_file'
              WHEN '6' LET l_gfd05='gat_file'
              WHEN '7' LET l_gfd05='gaq_file'
              WHEN '8' LET l_gfd05='zaa_file'
              WHEN '9' LET l_gfd05='zai_file'
              WHEN 'A' LET l_gfd05='zaw_file'
              OTHERWISE CANCEL INSERT
         END CASE
         INSERT INTO gfd_file(gfd01,gfd02,gfd04,gfd05,gfd06,gfd07)
                        VALUES(g_gfb.gfb01,g_gfd[l_ac_s].gfd02,
                               g_gfd[l_ac_s].gfd04,l_gfd05,
                               g_gfd[l_ac_s].gfd06,g_gfd[l_ac_s].gfd07)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gfd_file",g_gfb.gfb01,g_gfd[l_ac_s].gfd02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            ROLLBACK WORK
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b_s = g_rec_b_s + 1
            DISPLAY g_rec_b_s TO FORMONLY.cn2
         END IF

         BEFORE FIELD gfd02
            IF cl_null(g_gfd[l_ac_s].gfd02) OR g_gfd[l_ac_s].gfd02 = 0 THEN
               SELECT MAX(gfd02)+1 INTO g_gfd[l_ac_s].gfd02 FROM gfd_file
                WHERE gfd01 = g_gfb.gfb01
                IF cl_null(g_gfd[l_ac_s].gfd02) THEN
                   LET g_gfd[l_ac_s].gfd02 = 1
                END IF
            END IF

         AFTER FIELD gfd02
            IF g_gfd[l_ac_s].gfd02 IS NOT NULL AND
               (g_gfd[l_ac_s].gfd02 != g_gfd_t.gfd02 OR g_gfd_t.gfd02 IS NULL) THEN
               SELECT COUNT(*) INTO l_n FROM gfd_file
                WHERE gfd01 = g_gfb.gfb01 AND gfd02 = g_gfd[l_ac_s].gfd02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gfd[l_ac_s].gfd02 = g_gfd_t.gfd02
                  NEXT FIELD gfd02
               END IF
            END IF

         AFTER FIELD gfd04
            IF g_gfd[l_ac_s].gfd04 IS NOT NULL THEN
               CASE g_gfd[l_ac_s].gfd04
                    WHEN '1' LET l_gfd05='zz_file'
                             LET l_key1 = 'zz01'
                    WHEN '2' LET l_gfd05='ze_file'
                             LET l_key1 = 'ze01'
                    WHEN '3' LET l_gfd05='gao_file'
                             LET l_key1 = 'gao01'
                    WHEN '4' LET l_gfd05='gae_file'
                             LET l_key1 = 'gae01'
                    WHEN '5' LET l_gfd05='gab_file'
                             LET l_key1 = 'gab01'
                    WHEN '6' LET l_gfd05='gat_file'
                             LET l_key1 = 'gat01'
                    WHEN '7' LET l_gfd05='gaq_file'
                             LET l_key1 = 'gaq01'
                    WHEN '8' LET l_gfd05='zaa_file'
                             LET l_key1 = 'zaa01'
                    WHEN '9' LET l_gfd05='zai_file'
                             LET l_key1 = 'zai01'
                    WHEN 'A' LET l_gfd05='zaw_file'
                              LET l_key1 = 'zaw01'
                    OTHERWISE NEXT FIELD gfd04
               END CASE
            END IF

         AFTER FIELD gfd06
            IF g_gfd[l_ac_s].gfd06 IS NOT NULL THEN
               IF g_gfd[l_ac_s].gfd04 = "3"  THEN
                  LET g_gfd[l_ac_s].gfd06  = UPSHIFT(g_gfd[l_ac_s].gfd06 CLIPPED)
               END IF
               LET l_sql = " SELECT COUNT(*) FROM ", l_gfd05 CLIPPED,
                           " WHERE ",l_key1 CLIPPED ," = '", g_gfd[l_ac_s].gfd06 CLIPPED,"'"
               PREPARE l_select0 FROM l_sql
               EXECUTE l_select0 INTO l_n
                IF l_n = 0 THEN
                   CALL cl_err('','gzl-001',1)
                   ROLLBACK WORK
                   LET g_gfd[l_ac_s].gfd06 = g_gfd_t.gfd06
                   NEXT FIELD gfd06
                END IF
            END IF

         BEFORE DELETE                            #是否取消單身
            IF g_gfd_t.gfd02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF

               IF l_lock_sw = 'Y' THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF

               DELETE FROM gfd_file
                   WHERE gfd01 = g_gfb.gfb01
                     AND gfd02 = g_gfd_t.gfd02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","gfd_file",g_gfb.gfb01,g_gfd_t.gfd02,SQLCA.sqlcode,"","",0)
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE
                  LET g_rec_b_s = g_rec_b_s-1
                  DISPLAY g_rec_b_s TO FORMONLY.cn2
                  MESSAGE 'Delete ok!'
                  COMMIT WORK
               END IF
            END IF

         ON ROW CHANGE
            CASE g_gfd[l_ac_s].gfd04
               WHEN '1' LET l_gfd05='zz_file'
                        LET l_key1 = 'zz01'
               WHEN '2' LET l_gfd05='ze_file'
                        LET l_key1 = 'ze01'
               WHEN '3' LET l_gfd05='gao_file'
                        LET l_key1 = 'gao01'
               WHEN '4' LET l_gfd05='gae_file'
                        LET l_key1 = 'gae01'
               WHEN '5' LET l_gfd05='gab_file'
                        LET l_key1 = 'gab01'
               WHEN '6' LET l_gfd05='gat_file'
                        LET l_key1 = 'gat01'
               WHEN '7' LET l_gfd05='gaq_file'
                        LET l_key1 = 'gaq01'
               WHEN '8' LET l_gfd05='zaa_file'
                        LET l_key1 = 'zaa01'
               WHEN '9' LET l_gfd05='zai_file'
                        LET l_key1 = 'zai01'
               WHEN 'A' LET l_gfd05='zaw_file'
                         LET l_key1 = 'zaw01'
               OTHERWISE NEXT FIELD gfd04
            END CASE
            IF g_gfd[l_ac_s].gfd04 = "3"  THEN
               LET g_gfd[l_ac_s].gfd06  = UPSHIFT(g_gfd[l_ac_s].gfd06 CLIPPED)
            END IF
            LET l_sql = " SELECT COUNT(*) FROM ", l_gfd05 CLIPPED,
                        " WHERE ",l_key1 CLIPPED ," = '", g_gfd[l_ac_s].gfd06 CLIPPED,"'"
            PREPARE l_select5 FROM l_sql
            EXECUTE l_select5 INTO l_n
            IF l_n = 0 THEN
               CALL cl_err('','gzl-001',1)
               ROLLBACK WORK
               LET g_gfd[l_ac_s].gfd06 = g_gfd_t.gfd06
               NEXT FIELD gfd06
            END IF

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gfd[l_ac_s].* = g_gfd_t.*
               CLOSE p_gfd_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err('lock err',-263,1)
               LET g_gfd[l_ac_s].* = g_gfd_t.*
            ELSE
               IF cl_null(g_gfd[l_ac_s].gfd06) THEN
                  CALL cl_err('first key value column required','!',1)
                  ROLLBACK WORK
                  LET g_gfd[l_ac_s].* = g_gfd_t.*
                  CONTINUE INPUT
               END IF
            END IF

            UPDATE gfd_file
               SET gfd02= g_gfd[l_ac_s].gfd02,
                   gfd04= g_gfd[l_ac_s].gfd04,
                   gfd05= l_gfd05,
                   gfd06= g_gfd[l_ac_s].gfd06,
                   gfd07= g_gfd[l_ac_s].gfd07
             WHERE gfd01 = g_gfb.gfb01 AND gfd02 = g_gfd_t.gfd02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gfd_file",g_gfb.gfb01,g_gfd_t.gfd02,SQLCA.sqlcode,"","",0)
               LET g_gfd[l_ac_s].* = g_gfd_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF

         AFTER ROW
            LET l_ac_s = ARR_CURR()
           #LET l_ac_t = l_ac_s  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_gfd[l_ac_s].* = g_gfd_t.*
                #FUN-D30034--add--begin--
                ELSE
                   CALL g_gfd.deleteElement(l_ac_s)
                   IF g_rec_b_s != 0 THEN
                      LET gs_action = "detail"
                      LET l_ac_s = l_ac_t
                   END IF
                #FUN-D30034--add--end----
                END IF
               CLOSE p_gfd_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac_s  #FUN-D30034 add
            CLOSE p_gfd_bcl
            COMMIT WORK

         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(gfd02) AND l_ac_s > 1 THEN
                LET g_gfd[l_ac_s].* = g_gfd[l_ac_s-1].*
                DISPLAY g_gfd[l_ac_s].* TO s_gfd[l_ac_s].*
                NEXT FIELD gfd02
            END IF

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

   END INPUT

   CLOSE p_gfd_bcl
   COMMIT WORK
END FUNCTION

FUNCTION p_develop_pack()
   DEFINE   l_cmd          STRING
   DEFINE   l_result       LIKE type_file.num5
   DEFINE   l_result2      LIKE type_file.num5
   DEFINE   ls_tempdir     STRING
   DEFINE   li_cnt         LIKE type_file.num5
   DEFINE   ls_patch_name  STRING
   DEFINE   ls_file        STRING
   DEFINE   ls_client_dir  STRING
   DEFINE   lc_gfb12       LIKE gfb_file.gfb12
   DEFINE   ls_str         STRING

   SELECT COUNT(*) INTO li_cnt FROM gfb_file
    WHERE gfb01=g_gfb.gfb01 AND gfb02='4'
   IF li_cnt <= 0 THEN
      LET l_cmd = cl_getmsg("azz-714",g_lang) CLIPPED," / ",cl_getmsg("azz-718",g_lang) CLIPPED
      CALL cl_err(l_cmd,"!",1)
      RETURN
   END IF

   # 傳入要打包的名稱，因為pack回來的check只能依照擋案有無產生判斷成不成功
   # 又因為打包方式要用日期加時間，所以必須先傳好檔名
   LET ls_patch_name = g_gfb.gfb01 CLIPPED,"_",TODAY USING "yymmdd",cl_replace_str(TIME,":","")

   LET l_cmd = '$FGLRUN $DS4GL/bin/pack_cust_c.42r "',g_topcust,'" "',g_gfb.gfb01 CLIPPED,'" "',ls_patch_name,'" "N"'
display 'l_cmd=',l_cmd
   RUN l_cmd
   LET ls_file = FGL_GETENV("TEMPDIR"),os.Path.separator(),ls_patch_name,".tar"
   IF NOT os.Path.exists(ls_file) THEN
      CALL cl_err(ls_file,"azz-725",1)
      RETURN
   END IF

   LET ls_client_dir = p_develop_browse("download","dir")
   LET ls_tempdir = FGL_GETENV("TEMPDIR")
   #下載.sh的檔案
   CALL cl_download_file(ls_tempdir || "/" || ls_patch_name || ".sh",ls_client_dir || "/" || ls_patch_name || ".sh") RETURNING l_result
   #下載.tar的檔案
   CALL cl_download_file(ls_tempdir || "/" || ls_patch_name || ".tar",ls_client_dir || "/" || ls_patch_name || ".tar") RETURNING l_result2
   IF l_result AND l_result2 THEN
      LET ls_str = ls_patch_name, "|" ,ls_patch_name, "|" ,ls_client_dir
      CALL cl_err_msg("Download Success","azz-709",ls_str,1)
      LET lc_gfb12 = ls_client_dir || "/" || ls_patch_name || ".sh(tar)"
      UPDATE gfb_file SET gfb12 = lc_gfb12 WHERE gfb01 = g_gfb.gfb01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      ELSE
         DISPLAY lc_gfb12 TO gfb12
      END IF
   ELSE
      IF ls_client_dir IS NULL THEN
         LET ls_client_dir = "NULL"
      END IF
      LET ls_str = ls_patch_name, "|" ,ls_patch_name, "|" ,ls_client_dir
      CALL cl_err_msg("Download Failed","azz-708",ls_str,1)
      LET lc_gfb12 = ""
      UPDATE gfb_file SET gfb12 = lc_gfb12 WHERE gfb01 = g_gfb.gfb01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      ELSE
         DISPLAY lc_gfb12 TO gfb12
      END IF
   END IF
END FUNCTION

FUNCTION p_develop_pack_zs()
   DEFINE   l_cmd          STRING
   DEFINE   l_result       LIKE type_file.num5
   DEFINE   l_result2      LIKE type_file.num5
   DEFINE   ls_tempdir     STRING
   DEFINE   li_cnt         LIKE type_file.num5
   DEFINE   ls_patch_name  STRING
   DEFINE   ls_file        STRING
   DEFINE   ls_client_dir  STRING
   DEFINE   lc_gfb13       LIKE gfb_file.gfb13
   DEFINE   ls_str         STRING

   SELECT COUNT(*) INTO li_cnt FROM gfb_file
    WHERE gfb01=g_gfb.gfb01 AND gfb02='4'
   IF li_cnt <= 0 THEN
      LET l_cmd = cl_getmsg("azz-714",g_lang) CLIPPED," / ",cl_getmsg("azz-718",g_lang) CLIPPED
      CALL cl_err(l_cmd,"!",1)
      RETURN
   END IF

   LET ls_patch_name = g_gfb.gfb01 CLIPPED,"_",TODAY USING "yymmdd",cl_replace_str(TIME,":","")

   LET l_cmd = '$FGLRUN $DS4GL/bin/pack_cust_c.42r "',g_topcust,'" "',g_gfb.gfb01 CLIPPED,'" "',ls_patch_name,'" "Y"'
display 'l_cmd=',l_cmd
   RUN l_cmd
   LET ls_file = FGL_GETENV("TEMPDIR"),os.Path.separator(),ls_patch_name,"_tab.tar"
   IF NOT os.Path.exists(ls_file) THEN
      CALL cl_err(ls_file,"azz-725",1)
      RETURN
   END IF

   LET ls_client_dir = p_develop_browse("download","dir")
   LET ls_tempdir = FGL_GETENV("TEMPDIR")
   #下載.sh的檔案
   CALL cl_download_file(ls_tempdir || "/" || ls_patch_name || "_tab.sh",ls_client_dir || "/" || ls_patch_name || "_tab.sh") RETURNING l_result
   #下載.tar的檔案
   CALL cl_download_file(ls_tempdir || "/" || ls_patch_name || "_tab.tar",ls_client_dir || "/" || ls_patch_name || "_tab.tar") RETURNING l_result2
   IF l_result AND l_result2 THEN
      LET ls_str = ls_patch_name, "_tab|" ,ls_patch_name, "_tab|" ,ls_client_dir
      CALL cl_err_msg("Download Success","azz-709",ls_str,1)
      LET lc_gfb13 = ls_client_dir || "/" || ls_patch_name || "_tab.sh(tar)"
      UPDATE gfb_file SET gfb13 = lc_gfb13 WHERE gfb01 = g_gfb.gfb01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      ELSE
         DISPLAY lc_gfb13 TO gfb13
      END IF
   ELSE
      LET ls_str = ls_patch_name, "_tab|" ,ls_patch_name, "_tab|" ,ls_client_dir
      CALL cl_err_msg("Download Failed","azz-708",ls_str,1)
      LET lc_gfb13 = ""
      UPDATE gfb_file SET gfb13 = lc_gfb13 WHERE gfb01 = g_gfb.gfb01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      ELSE
         DISPLAY lc_gfb13 TO gfb13
      END IF
   END IF
END FUNCTION

FUNCTION p_develop_zs()
   DEFINE l_cmd STRING,
          l_num STRING,
          l_ver STRING

   IF (g_gfb.gfb01 IS NULL) THEN
      CALL cl_err('No. is Null','!',1)
      RETURN
   END IF
   LET l_cmd = "p_zs '' '' '",g_gfb.gfb01 CLIPPED,"'"
   CALL cl_cmdrun(l_cmd)
END FUNCTION

FUNCTION p_develop_w()
   DEFINE l_cmd STRING,
          l_num STRING,
          l_ver STRING

   IF (g_gfb.gfb01 IS NULL) THEN
      CALL cl_err('No. is Null','!',1)
      RETURN
   END IF
   IF g_gfb.gfb02 = "1" THEN
      RETURN
   END IF
   LET l_cmd = 'cd $AZZ/4gl;r.r2 p_zta ',"'",g_gfb.gfb01 CLIPPED,"'"
   RUN l_cmd
END FUNCTION

FUNCTION p_develop_developing()
   IF (g_gfb.gfb01 IS NULL) THEN
      CALL cl_err('No. is Null','!',1)
      RETURN
   END IF

   LET g_gfb.gfb02 = "2"

   CALL p_develop_i("u")
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
   ELSE
      UPDATE gfb_file SET gfb02=g_gfb.gfb02, gfb03=g_gfb.gfb03,
                          gfb04=g_gfb.gfb04, gfb11=g_gfb.gfb11
       WHERE gfb01=g_gfb.gfb01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","gfb_file",g_gfb.gfb01,"","9050","","",0)
       END IF
   END IF
   SELECT * INTO g_gfb.* FROM gfb_file WHERE gfb01=g_gfb.gfb01
   CALL p_develop_show()
END FUNCTION

FUNCTION p_develop_complete()
   IF (g_gfb.gfb01 IS NULL) THEN
      CALL cl_err('No. is Null','!',1)
      RETURN
   END IF

   SELECT COUNT(*) INTO g_cnt FROM gfc_file
    WHERE gfc01=g_gfb.gfb01 AND gfc07="0"
   IF g_cnt > 0 THEN
      CALL cl_err("","azz-760",1)
      RETURN
   END IF

   LET g_gfb.gfb02 = "3"
   LET g_gfb.gfb07 = TODAY

   CALL p_develop_i("u")
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
   ELSE
      UPDATE gfb_file SET gfb02=g_gfb.gfb02, gfb07=g_gfb.gfb07,
                          gfb08=g_gfb.gfb08, gfb11=g_gfb.gfb11
       WHERE gfb01=g_gfb.gfb01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gfb_file",g_gfb.gfb01,"","9050","","",0)
      END IF
   END IF
   SELECT * INTO g_gfb.* FROM gfb_file WHERE gfb01=g_gfb.gfb01
   CALL p_develop_show()
END FUNCTION

FUNCTION p_develop_confirm()
   IF (g_gfb.gfb01 IS NULL) THEN
      CALL cl_err('No. is Null','!',1)
      RETURN
   END IF

   SELECT COUNT(*) INTO g_cnt FROM gfc_file
    WHERE gfc01=g_gfb.gfb01 AND gfc07="0"
   IF g_cnt > 0 THEN
      CALL cl_err("","azz-760",1)
      RETURN
   END IF

   LET g_gfb.gfb02 = "4"
   LET g_gfb.gfb09 = g_user
   LET g_gfb.gfb10 = TODAY

   CALL cl_set_comp_required("gfb09",TRUE)
   CALL p_develop_i("u")
   CALL cl_set_comp_required("gfb09",FALSE)
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
   ELSE
      UPDATE gfb_file SET gfb02=g_gfb.gfb02, gfb09=g_gfb.gfb09,
                          gfb10=g_gfb.gfb10, gfb11=g_gfb.gfb11
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gfb_file",g_gfb.gfb01,"","9050","","",0)
      END IF
   END IF
   SELECT * INTO g_gfb.* FROM gfb_file WHERE gfb01=g_gfb.gfb01
   CALL p_develop_show()
END FUNCTION

FUNCTION p_develop_gfb04()                # 程式名稱直接抓客製
   DEFINE   l_gaz03      LIKE gaz_file.gaz03

   SELECT gaz03 INTO l_gaz03 FROM gaz_file
    WHERE gaz01 = g_gfb.gfb04 AND gaz02 = g_lang AND gaz05 = "Y"

   IF l_gaz03 IS NULL THEN
      SELECT gaz03 INTO l_gaz03 FROM gaz_file
       WHERE gaz01 = g_gfb.gfb04 AND gaz02 = g_lang AND gaz05 = "N"
   END IF

   IF SQLCA.sqlcode THEN
      LET l_gaz03 = ''
      RETURN
   END IF

   DISPLAY l_gaz03 TO FORMONLY.zz02
END FUNCTION

FUNCTION p_develop_zx01(p_code,p_seq)
   DEFINE p_code       LIKE zx_file.zx01,
          p_seq        LIKE type_file.chr1,
          l_zx02       LIKE zx_file.zx02

   LET g_errno = ' '
   SELECT zx02 INTO l_zx02 FROM zx_file
    WHERE zx01 = p_code
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                  LET l_zx02  = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      CASE
         WHEN p_seq = '1'   DISPLAY l_zx02 TO FORMONLY.zx02
         WHEN p_seq = '2'   DISPLAY l_zx02 TO FORMONLY.zx02_2
      END CASE
   ELSE
      CASE
         WHEN p_seq = '1'   DISPLAY NULL TO FORMONLY.zx02
         WHEN p_seq = '2'   DISPLAY NULL TO FORMONLY.zx02_2
      END CASE
   END IF
END FUNCTION

FUNCTION p_develop_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1

   CALL cl_set_comp_entry("gfb01,gfb02,gfb03,gfb04,gfb05,gfb06,gfb07,gfb08,gfb09,gfb10,gfb14,gfb15,gfb16",TRUE)   #No.FUN-840067
END FUNCTION

FUNCTION p_develop_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1

   IF p_cmd = "a" AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gfb07,gfb08,gfb09,gfb10,gfb15",FALSE)   #No.FUN-840067
   END IF
   IF p_cmd = "u"  AND (NOT g_before_input_done) THEN
      CASE g_gfb.gfb02
         WHEN "1"
            CALL cl_set_comp_entry("gfb01",FALSE)
         WHEN "2"
            CALL cl_set_comp_entry("gfb01,gfb05,gfb06,gfb07,gfb08,gfb09,gfb10,gfb15",FALSE)               #No.FUN-840067
         WHEN "3"
            CALL cl_set_comp_entry("gfb01,gfb03,gfb04,gfb05,gfb06,gfb09,gfb10,gfb14,gfb15,gfb16",FALSE)   #No.FUN-840067
         WHEN "4"
            CALL cl_set_comp_entry("gfb01,gfb03,gfb04,gfb05,gfb06,gfb07,gfb08,gfb14,gfb16",FALSE)         #No.FUN-840067
      END CASE
   END IF
END FUNCTION

FUNCTION p_develop_lock_file()
   DEFINE   ls_cm_tool      STRING
   DEFINE   ls_cmd          STRING
   DEFINE   ls_file         STRING

   LET ls_cm_tool = FGL_GETENV("TOP"),"/bin/sbin/ch_file_mode_gp"
   IF g_gfc[l_ac_k].gfc07 = "0" THEN
      CASE g_gfc[l_ac_k].gfc04
         WHEN "4gl"
            LET ls_cmd = ls_cm_tool," ",g_topcust,os.Path.separator(),
                         g_gfc[l_ac_k].gfc03 CLIPPED,os.Path.separator(),
                         g_gfc[l_ac_k].gfc04 CLIPPED,os.Path.separator(),
                         g_gfc[l_ac_k].gfc05 CLIPPED," to_user"
            RUN ls_cmd
         WHEN "4fd"
            LET ls_file = g_gfc[l_ac_k].gfc05 CLIPPED
            LET ls_file = ls_file.subString(1,ls_file.getIndexOf(".4fd",1)-1)
            LET ls_cmd = ls_cm_tool," ",g_topcust,os.Path.separator(),
                         g_gfc[l_ac_k].gfc03 CLIPPED,os.Path.separator(),
                         g_gfc[l_ac_k].gfc04 CLIPPED,os.Path.separator(),
                         g_gfc[l_ac_k].gfc05 CLIPPED," to_user"
            RUN ls_cmd
            LET ls_cmd = ls_cm_tool," ",g_topcust,os.Path.separator(),
                         g_gfc[l_ac_k].gfc03 CLIPPED,os.Path.separator(),
                         "per",os.Path.separator(),ls_file,".per to_user"
            RUN ls_cmd
            LET ls_cmd = ls_cm_tool," ",g_topcust,os.Path.separator(),
                         g_gfc[l_ac_k].gfc03 CLIPPED,os.Path.separator(),
                         "sdd",os.Path.separator(),ls_file,".sdd to_user"
            RUN ls_cmd
      END CASE
      LET g_gfc[l_ac_k].gfc08 = g_user
      LET g_gfc[l_ac_k].gfc09 = TODAY
      UPDATE gfc_file SET gfc08=g_gfc[l_ac_k].gfc08,gfc09=g_gfc[l_ac_k].gfc09
       WHERE gfc01=g_gfb.gfb01 AND gfc02=g_gfc[l_ac_k].gfc02
      IF SQLCA.sqlcode THEN
         LET g_gfc[l_ac_k].gfc08 = g_gfc_t.gfc08
         LET g_gfc[l_ac_k].gfc09 = g_gfc_t.gfc09
      ELSE
         DISPLAY BY NAME g_gfc[l_ac_k].gfc08
         DISPLAY BY NAME g_gfc[l_ac_k].gfc09
      END IF
   ELSE
      CASE g_gfc[l_ac_k].gfc04
         WHEN "4gl"
            LET ls_cmd = ls_cm_tool," ",g_topcust,os.Path.separator(),
                         g_gfc[l_ac_k].gfc03 CLIPPED,os.Path.separator(),
                         g_gfc[l_ac_k].gfc04 CLIPPED,os.Path.separator(),
                         g_gfc[l_ac_k].gfc05 CLIPPED," to_tiptop"
            RUN ls_cmd
         WHEN "4fd"
            LET ls_file = g_gfc[l_ac_k].gfc05
            LET ls_file = ls_file.subString(1,ls_file.getIndexOf(".4fd",1)-1)
            LET ls_cmd = ls_cm_tool," ",g_topcust,os.Path.separator(),
                         g_gfc[l_ac_k].gfc03 CLIPPED,os.Path.separator(),
                         g_gfc[l_ac_k].gfc04 CLIPPED,os.Path.separator(),
                         g_gfc[l_ac_k].gfc05 CLIPPED," to_tiptop"
            RUN ls_cmd
            LET ls_cmd = ls_cm_tool," ",g_topcust,os.Path.separator(),
                         g_gfc[l_ac_k].gfc03 CLIPPED,os.Path.separator(),
                         "per",os.Path.separator(),ls_file,".per to_tiptop"
            RUN ls_cmd
            LET ls_cmd = ls_cm_tool," ",g_topcust,os.Path.separator(),
                         g_gfc[l_ac_k].gfc03 CLIPPED,os.Path.separator(),
                         "sdd",os.Path.separator(),ls_file,".sdd to_tiptop"
            RUN ls_cmd
      END CASE
      LET g_gfc[l_ac_k].gfc08 = NULL
      LET g_gfc[l_ac_k].gfc09 = NULL
      UPDATE gfc_file SET gfc08=g_gfc[l_ac_k].gfc08,gfc09=g_gfc[l_ac_k].gfc09
       WHERE gfc01=g_gfb.gfb01 AND gfc02=g_gfc[l_ac_k].gfc02
      IF SQLCA.sqlcode THEN
         LET g_gfc[l_ac_k].gfc08 = g_gfc_t.gfc08
         LET g_gfc[l_ac_k].gfc09 = g_gfc_t.gfc09
      ELSE
         DISPLAY BY NAME g_gfc[l_ac_k].gfc08
         DISPLAY BY NAME g_gfc[l_ac_k].gfc09
      END IF
   END IF
END FUNCTION

FUNCTION p_develop_patch(ps_step)
   DEFINE ps_step         STRING
   DEFINE ls_patch_name   STRING
   DEFINE ls_tablespace   STRING
   DEFINE lc_cmd          STRING
   DEFINE ls_area         STRING
   DEFINE ls_client_dir   STRING
   DEFINE li_result       LIKE type_file.num5
   DEFINE li_result2      LIKE type_file.num5
   DEFINE lc_channel      base.Channel
   DEFINE ls_msg          STRING


   #檢查目前區域是否為正式區
   LET ls_area = FGL_GETENV("TOP")
   LET ls_area = os.Path.dirname(ls_area)
   LET ls_area = os.Path.basename(ls_area)
   IF ls_area != "topprod" THEN
      LET ls_msg = ls_area,"; ",cl_getmsg("azz-759",g_lang) CLIPPED
      IF NOT cl_confirm(ls_msg) THEN
         RETURN
      END IF
   END IF

   LET ls_client_dir = p_develop_browse("upload","dir")
   IF cl_null(ls_client_dir) THEN
      RETURN
   END IF

   WHILE TRUE
      LET ls_msg = cl_getmsg("azz-755",g_lang)
      PROMPT ls_msg.trim(),":" FOR ls_patch_name
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
         LET INT_FLAG = FALSE
         RETURN
      END IF
      CASE
         WHEN ps_step = "1" AND NOT ls_patch_name.getIndexOf("_tab",1)
            CALL cl_err("","azz-757",0)
         WHEN ps_step = "2" AND ls_patch_name.getIndexOf("_tab",1)
            CALL cl_err("","azz-758",0)
         OTHERWISE
            EXIT WHILE
      END CASE
   END WHILE

   CALL cl_upload_file(ls_client_dir||"/"||ls_patch_name||".sh",g_topcust||"/"||ls_patch_name||".sh") RETURNING li_result
   CALL cl_upload_file(ls_client_dir||"/"||ls_patch_name||".tar",g_topcust||"/"||ls_patch_name||".tar") RETURNING li_result2
   IF li_result AND li_result2 THEN
      LET lc_cmd = "cd ",g_topcust,";sh ",ls_patch_name,".sh"
      RUN lc_cmd
   END IF
END FUNCTION

FUNCTION p_develop_browse(ps_work,ps_type)
   DEFINE   ps_work   STRING
   DEFINE   ps_type   STRING
   DEFINE   ls_path   STRING
   DEFINE   ls_msg    STRING

   OPEN WINDOW browse_w WITH FORM "azz/42f/p_develop_browse"
      ATTRIBUTE(STYLE="popup")
   CALL cl_ui_locale("p_develop_browse")

   CASE
      WHEN ps_work = "download" AND ps_type = "file"
         LET ls_msg = cl_getmsg("azz-750",g_lang) CLIPPED,cl_getmsg("azz-752",g_lang) CLIPPED,cl_getmsg("azz-753",g_lang) CLIPPED
      WHEN ps_work = "download" AND ps_type = "dir"
         LET ls_msg = cl_getmsg("azz-750",g_lang) CLIPPED,cl_getmsg("azz-752",g_lang) CLIPPED,cl_getmsg("azz-754",g_lang) CLIPPED
      WHEN ps_work = "upload" AND ps_type = "file"
         LET ls_msg = cl_getmsg("azz-750",g_lang) CLIPPED,cl_getmsg("azz-751",g_lang) CLIPPED,cl_getmsg("azz-753",g_lang) CLIPPED
      WHEN ps_work = "upload" AND ps_type = "dir"
         LET ls_msg = cl_getmsg("azz-750",g_lang) CLIPPED,cl_getmsg("azz-751",g_lang) CLIPPED,cl_getmsg("azz-754",g_lang) CLIPPED
   END CASE
   DISPLAY ls_msg TO FORMONLY.str
   INPUT ls_path WITHOUT DEFAULTS FROM formonly.browse
      ON ACTION controlp
         CASE ps_type
            WHEN "file"
               LET ls_path = cl_browse_file()
            WHEN "dir"
               LET ls_path = cl_browse_dir()
         END CASE
         DISPLAY ls_path TO FORMONLY.browse

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      LET ls_path = ""
   END IF

   CLOSE WINDOW browse_w
   RETURN ls_path
END FUNCTION
#No.FUN-7A0060

#No.FUN-840067 --start--
FUNCTION p_develop_set_combobox()
   DEFINE   ls_str   STRING
   DEFINE   lc_ze03  LIKE ze_file.ze03
   DEFINE   li_cnt   LIKE type_file.num5

   SELECT zo07 INTO lc_ze03 FROM zo_file WHERE zo01=g_lang
   LET ls_str = "1. ",lc_ze03 CLIPPED
   SELECT ze03 INTO lc_ze03 FROM ze_file WHERE ze01='azz-766' AND ze02=g_lang
   LET ls_str = ls_str,",2. ",lc_ze03 CLIPPED

   CALL cl_set_combo_items("gfb16","1,2",ls_str)
END FUNCTION
#No.FUN-840067 ---end---

#No.FUN-840067 --start-- 自動compile,link,exe2,r.d2+
FUNCTION p_develop_file_compile_step(ps_module,ps_menu,ps_file)
   DEFINE   ps_module   STRING
   DEFINE   ps_menu     STRING
   DEFINE   ps_file     STRING
   DEFINE   ls_cmd      STRING
   DEFINE   li_cnt      LIKE type_file.num5
   DEFINE   ls_temp     STRING
   DEFINE   lc_zz01     LIKE zz_file.zz01
   DEFINE   lc_channel  base.Channel
   DEFINE   ls_result   STRING
   DEFINE   ls_msg      STRING
   DEFINE   li_err_line LIKE type_file.num5

   CASE
      WHEN ps_file.getIndexOf(".4gl",1) AND ps_menu = "4gl"
         #先刪除舊42m,42r
         IF os.Path.exists(g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42m"||os.Path.separator()||ps_module||"_"||ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)||".42m") THEN
            IF os.Path.delete(g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42m"||os.Path.separator()||ps_module||"_"||ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)||".42m") THEN END IF
         END IF
         IF os.Path.exists(g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42r"||os.Path.separator()||ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)||".42r") THEN
            IF os.Path.delete(g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42r"||os.Path.separator()||ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)||".42r") THEN END IF
         END IF
         #1 Compile
         IF NOT cl_confirm("azz-767") THEN
            EXIT CASE
         END IF
         LET ls_cmd = "cd ",g_topcust,os.Path.separator(),ps_module,os.Path.separator(),ps_menu,";r.c2 ",ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)," 2> $TEMPDIR/p_develop_compile_",ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1),".log"
         RUN ls_cmd
         IF os.Path.exists(g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42m"||os.Path.separator()||ps_module||"_"||ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)||".err") OR
            NOT os.Path.exists(g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42m"||os.Path.separator()||ps_module||"_"||ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)||".42m") THEN
            LET lc_channel = base.Channel.create()
            CALL lc_channel.openFile(FGL_GETENV("TEMPDIR")||os.Path.separator()||"p_develop_compile_"||ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)||".log","r")
            LET li_err_line = 1
            LET ls_msg = ""
            WHILE lc_channel.read(ls_result)
               IF li_err_line > 8 THEN
                  LET ls_msg = ls_msg,"..........\n"
                  EXIT WHILE
               END IF
               LET ls_msg = ls_msg,ls_result.trim(),"\n"
               LET li_err_line = li_err_line + 1
            END WHILE
            CALL lc_channel.close()
            LET ls_msg = ls_msg,ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)," ",cl_getmsg("azz-768",g_lang) CLIPPED,g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42m"||os.Path.separator()||ps_module||"_"||ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)||".err"
            IF cl_confirm(ls_msg) THEN
             # LET ls_cmd = FGL_GETENV("FGLRUN")," $TOP/azz/42r/p_view ",g_topcust,os.Path.separator(),ps_module,os.Path.separator(),"42m",os.Path.separator(),ps_module,"_",ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1),".err 66"   #FUN-B30176 mark
             #FUN-B30176-add-start--
               LET ls_cmd = FGL_GETENV("FGLRUN"),FGL_GETENV("TOP"),os.Path.separator(),"azz",
                            os.Path.separator(),"42r",os.Path.separator(),"p_view",g_topcust,
                            os.Path.separator(),ps_module,os.Path.separator(),"42m",os.Path.separator(),ps_module,"_",
                            ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1),".err 66"
             #FUN-B30176-add-end--
               RUN ls_cmd
            END IF
            RETURN
         END IF
         #2 Check p_zz
         IF NOT cl_confirm("azz-769") THEN
            EXIT CASE
         END IF
         LET ls_temp = ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)
         LET lc_zz01 = ls_temp
         SELECT COUNT(*) INTO li_cnt FROM zz_file WHERE zz01 = lc_zz01
         IF li_cnt <= 0 THEN
            IF cl_confirm("azz-705") THEN
               CALL cl_cmdrun_wait("p_zz")
            ELSE
               RETURN
            END IF
         END IF
         #3 Check p_link
         SELECT COUNT(*) INTO li_cnt FROM gak_file WHERE gak01 = lc_zz01
         IF li_cnt <= 0 THEN
            IF cl_confirm("azz-062") THEN
               CALL cl_cmdrun_wait("p_link "||lc_zz01 CLIPPED)
            ELSE
               RETURN
            END IF
         END IF
         #4 Link program
         LET ls_cmd = "cd ",g_topcust,os.Path.separator(),ps_module,os.Path.separator(),ps_menu,";r.l2 ",ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)," > $TEMPDIR/p_develop_compile_",lc_zz01 CLIPPED,".log"
         RUN ls_cmd
         IF NOT os.Path.exists(g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42r"||os.Path.separator()||ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)||".42r") THEN
            LET ls_msg = ""
            LET ls_msg = lc_zz01 CLIPPED," ",cl_getmsg("azz-770",g_lang),"\n"
            LET lc_channel = base.Channel.create()
            CALL lc_channel.openFile(FGL_GETENV("TEMPDIR")||os.Path.separator()||"p_develop_compile_"||lc_zz01 CLIPPED||".log","r")
            LET li_err_line = 1
            WHILE lc_channel.read(ls_result)
               IF li_err_line > 8 THEN
                  LET ls_msg = ls_msg,"..........\n"
                  EXIT WHILE
               END IF
               LET ls_msg = ls_msg,ls_result,"\n"
               LET li_err_line = li_err_line + 1
            END WHILE
            CALL lc_channel.close()
            LET ls_cmd = "cd ",g_topcust,os.Path.separator(),ps_module,os.Path.separator(),ps_menu,";r.l2 ",ps_file.subString(1,ps_file.getIndexOf(".4gl",1)-1)," 2> $TEMPDIR/p_develop_compile_",lc_zz01 CLIPPED,".log"
            RUN ls_cmd
            LET lc_channel = base.Channel.create()
            CALL lc_channel.openFile(FGL_GETENV("TEMPDIR")||os.Path.separator()||"p_develop_compile_"||lc_zz01 CLIPPED||".log","r")
            LET li_err_line = 1
            WHILE lc_channel.read(ls_result)
               IF li_err_line > 8 THEN
                  LET ls_msg = ls_msg,"..........\n"
                  EXIT WHILE
               END IF
               LET ls_msg = ls_msg,ls_result,"\n"
               LET li_err_line = li_err_line + 1
            END WHILE
            CALL lc_channel.close()
            LET ls_msg = ls_msg.subString(1,ls_msg.getLength()-2)
            CALL cl_err(ls_msg,"!",1)
            RETURN
         END IF
         #5 execute
         CALL cl_cmdrun_wait(lc_zz01 CLIPPED)
         IF cl_confirm("azz-771") THEN
            LET ls_cmd = "cd ",g_topcust,os.Path.separator(),ps_module,os.Path.separator(),ps_menu,";r.d2+ ",lc_zz01 CLIPPED
            RUN ls_cmd
         END IF
      WHEN ps_file.getIndexOf(".4fd",1)
         #先刪除舊42f
         IF os.Path.exists(g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42f"||os.Path.separator()||ps_file.subString(1,ps_file.getIndexOf(".4fd",1)-1)||".42f") THEN
            IF os.Path.delete(g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42f"||os.Path.separator()||ps_file.subString(1,ps_file.getIndexOf(".4fd",1)-1)||".42f") THEN END IF
         END IF
         #1 Compile
         IF NOT cl_confirm("azz-767") THEN
            EXIT CASE
         END IF
         LET ls_cmd = "cd ",g_topcust,os.Path.separator(),ps_module,os.Path.separator(),ps_menu,";r.f2 ",ps_file.subString(1,ps_file.getIndexOf(".4fd",1)-1)," 2> $TEMPDIR/p_develop_compile_",ps_file.subString(1,ps_file.getIndexOf(".4fd",1)-1),".log"
         RUN ls_cmd
         IF NOT os.Path.exists(g_topcust||os.Path.separator()||ps_module||os.Path.separator()||"42f"||os.Path.separator()||ps_file.subString(1,ps_file.getIndexOf(".4fd",1)-1)||".42f") THEN
            LET lc_channel = base.Channel.create()
            CALL lc_channel.openFile(FGL_GETENV("TEMPDIR")||os.Path.separator()||"p_develop_compile_"||ps_file.subString(1,ps_file.getIndexOf(".4fd",1)-1)||".log","r")
            LET li_err_line = 1
            LET ls_msg = ""
            WHILE lc_channel.read(ls_result)
               IF li_err_line > 8 THEN
                  LET ls_msg = ls_msg,"..........\n"
                  EXIT WHILE
               END IF
               LET ls_msg = ls_msg,ls_result,"\n"
               LET li_err_line = li_err_line + 1
            END WHILE
            CALL lc_channel.close()
            LET ls_msg = ls_msg,ps_file.subString(1,ps_file.getIndexOf(".4fd",1)-1)," ",cl_getmsg("azz-768",g_lang),FGL_GETENV("TEMPDIR")||os.Path.separator()||"p_develop_compile_"||ps_file.subString(1,ps_file.getIndexOf(".4fd",1)-1)||".log"
            IF cl_confirm(ls_msg) THEN
              #LET ls_cmd = FGL_GETENV("FGLRUN")," $TOP/azz/42r/p_view ",FGL_GETENV("TEMPDIR")||os.Path.separator()||"p_develop_compile_"||ps_file.subString(1,ps_file.getIndexOf(".4fd",1)-1)||".log 66"    #FUN-B30176 mark
              #FUN-B30176-add-start--
               LET ls_cmd = FGL_GETENV("FGLRUN"),FGL_GETENV("TOP"),os.Path.separator(),
                            "azz",os.Path.separator(),"42r",os.Path.separator(),"p_view",
                            FGL_GETENV("TEMPDIR")||os.Path.separator()||"p_develop_compile_"||ps_file.subString(1,ps_file.getIndexOf(".4fd",1)-1)||".log 66"
              #FUN-B30176-add-end--
               RUN ls_cmd
            END IF
            RETURN
         END IF
   END CASE
END FUNCTION
#No.FUN-840067 ---end---
