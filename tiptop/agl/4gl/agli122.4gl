# Prog. Version..: '5.30.07-13.05.31(00001)'     #
#
# Pattern name...: agli122.4gl
# Descriptions...: 控制科目核算作業設置
# Date & Author..: 2013/05/29 By zhangweib   FUN-D40118

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_ahk01           LIKE ahk_file.ahk01,   # 科目代號 (假單頭)   #FUN-D40118
         g_ahk00           LIKE ahk_file.ahk00,   #
         g_ahk00_t         LIKE ahk_file.ahk00,   #帳別
         g_ahk01_t         LIKE ahk_file.ahk01,   # 科目代號 (假單頭)
         g_aag02           LIKE aag_file.aag02,   # 科目名稱
         g_ahk        DYNAMIC ARRAY  OF RECORD    # 程式變數
            ahk02          LIKE ahk_file.ahk02,   #科目代號
            gaz03          LIKE gaz_file.gaz03    #交易作業代號
                      END RECORD,
         g_ahk_t           RECORD                 # 變數舊值
            ahk02          LIKE ahk_file.ahk02,   #交易作業代號
            gaz03          LIKE gaz_file.gaz03    #交易作業名稱
                      END RECORD,
         g_ahk_o           RECORD                 # 變數舊值
            ahk02          LIKE ahk_file.ahk02,   #交易作業代號
            gaz03          LIKE gaz_file.gaz03    #交易作業名稱
                      END RECORD,
         g_wc                  STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,     # 單身筆數
         l_ac                  LIKE type_file.num5,     # 目前處理的ARRAY CNT
         g_xxx                 LIKE oay_file.oayslip
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg                 LIKE type_file.chr1000
DEFINE   g_forupd_sql          STRING
DEFINE   g_curs_index          LIKE type_file.num10
DEFINE   g_row_count           LIKE type_file.num10
DEFINE   g_jump                LIKE type_file.num10
DEFINE   mi_no_ask             LIKE type_file.num5
DEFINE   g_str                 STRING
DEFINE   l_sql                 STRING
DEFINE   l_table               STRING
DEFINE   g_argv1               LIKE ahk_file.ahk00
DEFINE   g_argv2               LIKE ahk_file.ahk01
DEFINE   g_argv3               STRING

MAIN
   DEFINE   p_row,p_col    LIKE type_file.num5

   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1 = ARG_VAL(1)   
   LET g_argv2 = ARG_VAL(2)   
   LET g_argv3 = ARG_VAL(3)   
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   END IF
   LET g_sql = "ahk00.ahk_file.ahk00,",
               "ahk01.ahk_file.ahk01,",
               "aag02.aag_file.aag02,",
               "ahk02.ahk_file.ahk02,",
               "gaz03.gaz_file.gaz03"

   LET l_table = cl_prt_temptable('agli122',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   LET g_ahk01_t = NULL
   LET p_row = 5 LET p_col = 1

   OPEN WINDOW i122_w AT p_row,p_col WITH FORM "agl/42f/agli122"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_forupd_sql = "SELECT * from ahk_file ",
                      "  WHERE ahk01 = ? ",
                      "   AND ahk00 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i122_lock_u CURSOR FROM g_forupd_sql

   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv1) THEN
      LET g_wc = "ahk00 = '",g_argv1,"' AND ahk01 = '",g_argv2,"'"
      LET g_ahk00 = g_argv1
      LET g_ahk01 = g_argv2
      CALL i122_show()
      CALL i122_b() 
   END IF
   
   CALL i122_menu()

   CLOSE WINDOW i122_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i122_curs()                         # QBE 查詢資料
   CLEAR FORM                                # 清除畫面
   CALL g_ahk.clear()
   CALL cl_set_head_visible("","YES")

   IF cl_null(g_argv3) THEN

   INITIALIZE g_ahk01 TO NULL
   CONSTRUCT g_wc ON ahk00,ahk01,ahk02
                FROM ahk00,ahk01,s_ahk[1].ahk02

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(ahk01)        #科目代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ahk01
               NEXT FIELD ahk01
            WHEN INFIELD(ahk00)        #科目代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ahk00
               NEXT FIELD ahk00
            WHEN INFIELD(ahk02)        #交易作業(程式代號)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ahk02
               NEXT FIELD ahk02
            OTHERWISE
               EXIT CASE
         END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION help
          CALL cl_show_help()

       ON ACTION controlg
          CALL cl_cmdask()

       ON ACTION about
          CALL cl_about()

                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)

   IF INT_FLAG THEN
      RETURN
   END IF
   END IF

   LET g_sql= "SELECT UNIQUE ahk00,ahk01 FROM ahk_file ",
              " WHERE ", g_wc CLIPPED,
              " GROUP BY ahk00,ahk01 ORDER BY ahk00,ahk01"

   PREPARE i122_prepare FROM g_sql          # 預備一下
   DECLARE i122_b_curs                      # 宣告成可捲動的
   SCROLL CURSOR WITH HOLD FOR i122_prepare

END FUNCTION

#選出筆數直接寫入 g_row_count
FUNCTION i122_count()
   DEFINE la_ahk     DYNAMIC ARRAY of RECORD        # 程式變數
           ahk00     LIKE ahk_file.ahk00,
           ahk01     LIKE ahk_file.ahk01
                     END RECORD,
          li_cnt     LIKE type_file.num10,
          li_rec_b   LIKE type_file.num10

      LET g_sql= "SELECT UNIQUE ahk00,ahk01 FROM ahk_file ",
                 " WHERE ", g_wc CLIPPED,
                 " GROUP BY ahk00,ahk01 ORDER BY ahk00,ahk01"

   PREPARE i122_precount FROM g_sql
   DECLARE i122_count CURSOR FOR i122_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i122_count INTO g_ahk[li_cnt].*
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

FUNCTION i122_menu()

   WHILE TRUE
      CALL i122_bp("G")

      CASE g_action_choice
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i122_q()
            END IF
         WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i122_out()
           END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i122_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_ahk),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ahk01 IS NOT NULL THEN
                 LET g_doc.column1 = "ahk00"
                 LET g_doc.value1 = g_ahk00
                 LET g_doc.column2 = "ahk01"
                 LET g_doc.value2 = g_ahk01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i122_q()                            #Query 查詢

   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ahk01 TO NULL
   INITIALIZE g_ahk00 TO NULL
   CLEAR FROM
   CALL g_ahk.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i122_curs()                         #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i122_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                    #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_ahk01 TO NULL
      INITIALIZE g_ahk00 TO NULL
   ELSE
      CALL i122_count()
      IF g_row_count > 0 THEN
         DISPLAY g_row_count TO FORMONLY.cnt
         CALL i122_fetch('F')                 #讀出TEMP第一筆並顯示
      END IF
    END IF
END FUNCTION

FUNCTION i122_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,    #處理方式
            l_abso   LIKE type_file.num10    #絕對的筆數

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i122_b_curs INTO g_ahk00,g_ahk01
      WHEN 'P' FETCH PREVIOUS i122_b_curs INTO g_ahk00,g_ahk01
      WHEN 'F' FETCH FIRST    i122_b_curs INTO g_ahk00,g_ahk01
      WHEN 'L' FETCH LAST     i122_b_curs INTO g_ahk00,g_ahk01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION controlp
                   CALL cl_cmdask()

                ON ACTION help
                   CALL cl_show_help()

                ON ACTION about
                   CALL cl_about()

            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i122_b_curs INTO g_ahk00,g_ahk01
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ahk01,SQLCA.sqlcode,0)
      INITIALIZE g_ahk01 TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)

      CALL i122_show()
   END IF
END FUNCTION

FUNCTION i122_show()                         # 將資料顯示在畫面上

   LET g_aag02 = NULL
   SELECT aag02 INTO g_aag02 FROM aag_file
    WHERE aag01 = g_ahk01
      AND aag00 = g_ahk00
      AND aagacti ='Y'
   DISPLAY g_aag02 TO aag02
   DISPLAY g_ahk01 TO ahk01
   DISPLAY g_ahk00 TO ahk00
   CALL i122_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i122_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,          # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,          # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,          # 單身鎖住否
            p_cmd           LIKE type_file.chr1,          # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   l_count         LIKE type_file.num5
   DEFINE   l_gaq01      LIKE gaq_file.gaq01

   LET g_action_choice = " "
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_ahk01) OR cl_null(g_ahk00) THEN
      CALL cl_err('',-400,0)
      LET g_action_choice = " "
      RETURN
   ELSE
      SELECT aag02 INTO g_aag02 FROM aag_file
       WHERE aag00 = g_ahk00
         AND aag01 = g_ahk01
      DISPLAY g_ahk00,g_aag02,g_ahk01 TO ahk00,aag02,ahk01
   END IF

   CALL cl_opmsg('b')
   
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   LET g_forupd_sql= "SELECT ahk02,'' ",
                     "  FROM ahk_file",
                     " WHERE ahk00 = ? AND ahk01 = ? AND ahk02 = ? ",
                     "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i122_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0

   INPUT ARRAY g_ahk WITHOUT DEFAULTS FROM s_ahk.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()

         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_ahk_t.* = g_ahk[l_ac].*    #BACKUP
            LET g_ahk_o.* = g_ahk[l_ac].*    #BACKUP
            OPEN i122_bcl USING g_ahk00,g_ahk01,g_ahk_t.ahk02
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i122_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i122_bcl INTO g_ahk[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i122_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i122_gaz03(g_ahk[l_ac].ahk02) RETURNING g_ahk[l_ac].gaz03
               DISPLAY BY NAME g_ahk[l_ac].gaz03
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ahk[l_ac].* TO NULL
         LET g_ahk_t.* = g_ahk[l_ac].*          #新輸入資料
         LET g_ahk_o.* = g_ahk[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD ahk02

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         INSERT INTO ahk_file(ahk00,ahk01,ahk02)
                      VALUES (g_ahk00,g_ahk01,g_ahk[l_ac].ahk02)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ahk_file",g_ahk01,g_ahk[l_ac].ahk02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      AFTER FIELD ahk02  #交易作業(程式代號)
        IF NOT cl_null(g_ahk[l_ac].ahk02) THEN
           IF p_cmd = 'a' OR (p_cmd='u' AND
                              g_ahk[l_ac].ahk02!=g_ahk_t.ahk02) THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM ahk_file
               WHERE ahk00 = g_ahk00
                 AND ahk01 = g_ahk01
                 AND ahk02 = g_ahk[l_ac].ahk02
              IF l_n > 0 THEN
                 CALL cl_err(g_ahk[l_ac].ahk02,-239,1)
                 LET g_ahk[l_ac].ahk02 = g_ahk_o.ahk02
                 NEXT FIELD ahk02
              END IF
              LET g_ahk_o.ahk02 = g_ahk[l_ac].ahk02
           END IF
           IF p_cmd = 'a' OR (p_cmd='u' AND
                              g_ahk[l_ac].ahk02!=g_ahk_o.ahk02) THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM gaz_file
               WHERE gaz01 = g_ahk[l_ac].ahk02
                 AND gaz02 = g_lang
              IF l_n = 0 THEN
                 CALL cl_err(g_ahk[l_ac].ahk02,'lib-021',1)
                 LET g_ahk[l_ac].ahk02 = g_ahk_o.ahk02
                 NEXT FIELD ahk02
              END IF
              LET g_ahk_o.ahk02 = g_ahk[l_ac].ahk02
           END IF
        END IF
        CALL i122_gaz03(g_ahk[l_ac].ahk02) RETURNING g_ahk[l_ac].gaz03
        DISPLAY BY NAME g_ahk[l_ac].gaz03
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_ahk_t.ahk02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM ahk_file WHERE ahk01 = g_ahk01
                                   AND ahk00 =g_ahk00
                                   AND ahk02 = g_ahk_t.ahk02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ahk_file",g_ahk01,g_ahk_t.ahk02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ahk[l_ac].* = g_ahk_t.*
            CLOSE i122_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ahk[l_ac].ahk02,-263,1)
            LET g_ahk[l_ac].* = g_ahk_t.*
         ELSE

            UPDATE ahk_file
               SET ahk02 = g_ahk[l_ac].ahk02
             WHERE ahk01 = g_ahk01
               AND ahk00 = g_ahk00
               AND ahk02 = g_ahk_t.ahk02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ahk_file",g_ahk01,g_ahk_t.ahk02,SQLCA.sqlcode,"","",1)
               LET g_ahk[l_ac].* = g_ahk_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ahk[l_ac].* = g_ahk_t.*
            ELSE
               CALL g_ahk.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE i122_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE i122_bcl
         COMMIT WORK

      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(ahk02) AND l_ac > 1 THEN
            LET g_ahk[l_ac].* = g_ahk[l_ac-1].*
            DISPLAY BY NAME g_ahk[l_ac].*
            NEXT FIELD ahk02
         END IF

      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ahk02) #交易作業
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaz"
                 LET g_qryparam.arg1 = g_lang
                 LET g_qryparam.default1 = g_ahk[l_ac].ahk02
                 CALL cl_create_qry() RETURNING g_ahk[l_ac].ahk02
                 DISPLAY BY NAME g_ahk[l_ac].ahk02
                 NEXT FIELD ahk02
            OTHERWISE
               EXIT CASE
         END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION help
         CALL cl_show_help()

      ON ACTION about
         CALL cl_about()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END INPUT

   CLOSE i122_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i122_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc         STRING
   DEFINE p_ac         LIKE type_file.num5

      LET g_sql = "SELECT ahk02,'' ",
                  "  FROM ahk_file ",
                  " WHERE ahk01 = '",g_ahk01 CLIPPED,"' ",
                  "   AND ahk00 = '",g_ahk00 CLIPPED,"' ",
                  "   AND ",p_wc CLIPPED,
                  " ORDER BY ahk02"

    PREPARE i122_prepare2 FROM g_sql           #預備一下
    DECLARE ahk_curs CURSOR FOR i122_prepare2

    CALL g_ahk.clear()

    LET g_cnt = 1
    LET g_rec_b = 0

    FOREACH ahk_curs INTO g_ahk[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL i122_gaz03(g_ahk[g_cnt].ahk02) RETURNING g_ahk[g_cnt].gaz03
       DISPLAY BY NAME g_ahk[g_cnt].gaz03
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ahk.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i122_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_ahk TO s_ahk.* ATTRIBUTE(UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY

      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION output                           # O.列印
         LET g_action_choice='output'
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION first                            # 第一筆
         CALL i122_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous                         # P.上筆
         CALL i122_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
	      ACCEPT DISPLAY

      ON ACTION jump                             # 指定筆
         CALL i122_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
         END IF
	      ACCEPT DISPLAY

      ON ACTION next                             # N.下筆
         CALL i122_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	      ACCEPT DISPLAY

      ON ACTION last                             # 最終筆
         CALL i122_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	      ACCEPT DISPLAY

       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DISPLAY

      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i122_gaz03(p_ahk02)
   DEFINE   l_gaz03         LIKE gaz_file.gaz03,
            p_ahk02         LIKE ahk_file.ahk02

   LET l_gaz03 = NULL
   SELECT gaz03 INTO l_gaz03 FROM gaz_file
    WHERE gaz01 = p_ahk02
      AND gaz02 = g_lang
      AND gaz05 = 'Y'
   IF cl_null(l_gaz03) THEN
      SELECT gaz03 INTO l_gaz03 FROM gaz_file
       WHERE gaz01=p_ahk02
         AND gaz02 = g_lang
         AND gaz05='N'
   END IF

   RETURN l_gaz03

END FUNCTION

FUNCTION i122_ahk01(p_code,p_bookno)
   DEFINE p_code     LIKE aag_file.aag01
   DEFINE p_bookno   LIKE aag_file.aag00
   DEFINE l_aagacti  LIKE aag_file.aagacti
   DEFINE l_aag07    LIKE aag_file.aag07

   LET g_aag02 = NULL
   LET g_errno = NULL
   SELECT aag02,aag07,aagacti INTO g_aag02,l_aag07,l_aagacti
     FROM aag_file
    WHERE aag01=p_code
      AND aag00=p_bookno

    CASE WHEN STATUS=100         LET g_errno='agl-001'
         WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'     LET g_errno = 'agl-015'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
END FUNCTION

FUNCTION i122_out()
    DEFINE
        l_ahk         RECORD
            ahk00          LIKE ahk_file.ahk00,
            ahk01          LIKE ahk_file.ahk01,
            aag02          LIKE aag_file.aag02,
            ahk02          LIKE ahk_file.ahk02,
            gaz03          LIKE gaz_file.gaz03
                      END RECORD,
        l_i           LIKE type_file.num5,
        l_name        LIKE type_file.chr20,
        l_za05        LIKE za_file.za05

    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog
    LET g_sql="SELECT ahk00,ahk01,'',ahk02,'' ",
              " FROM ahk_file ",                # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY ahk00,ahk01 "

    PREPARE i122_p FROM g_sql                   # RUNTIME 編譯
    DECLARE i122_co CURSOR FOR i122_p           # SCROLL CURSOR

    CALL cl_del_data(l_table)

    FOREACH i122_co INTO l_ahk.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT aag02 INTO l_ahk.aag02 FROM aag_file
         WHERE aag01 = l_ahk.ahk01
           AND aag00 =l_ahk.ahk00
           AND aagacti ='Y'
        CALL i122_gaz03(l_ahk.ahk02) RETURNING l_ahk.gaz03
        EXECUTE insert_prep USING l_ahk.ahk00,l_ahk.ahk01,l_ahk.aag02,
                                  l_ahk.ahk02,l_ahk.gaz03
    END FOREACH

    CLOSE i122_co
    ERROR ""
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'ahk00,ahk01,ahk02')
            RETURNING g_str
    END IF
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('agli122','agli122',l_sql,g_str)

END FUNCTION
