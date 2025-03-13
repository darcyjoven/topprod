# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: axmi132.4gl
# Descriptions...: 末維屬性維護作業
# Date & Author..: 08/08/07 By ve007  No.FUN-870117
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_ocq01          LIKE ocq_file.ocq01,   # 組別代碼 (假單頭)
         g_ocq01_t        LIKE ocq_file.ocq01,   # 組別代號 (假單頭)
         g_ocq02          LIKE ocq_file.ocq02,   # 組別名稱 (假單頭)
         g_ocq02_t        LIKE ocq_file.ocq02,   # 組別名稱 (假單頭)
         g_ocq03          LIKE ocq_file.ocq03,   # 屬性代碼 (假單頭)
         g_ocq03_t        LIKE ocq_file.ocq03,   # 屬性代碼 (假單頭)
         g_ocq06          LIKE ocq_file.ocq06,    
         g_ocq06_t        LIKE ocq_file.ocq06,
         g_ocqacti        LIKE ocq_file.ocqacti,
         g_ocquser        LIKE ocq_file.ocquser,
         g_ocqgrup        LIKE ocq_file.ocqgrup,
         g_ocqmodu        LIKE ocq_file.ocqmodu,
         g_ocqdate        LIKE ocq_file.ocqdate,
         g_ocq_lock RECORD LIKE ocq_file.*,      # FOR LOCK CURSOR TOUCH
         g_ocq    DYNAMIC ARRAY of RECORD        # 程式變數
            ocq04          LIKE ocq_file.ocq04,
            ocq05          LIKE ocq_file.ocq05
                      END RECORD,
         g_ocq_t           RECORD                 # 變數舊值
            ocq04          LIKE ocq_file.ocq04,
            ocq05          LIKE ocq_file.ocq05
                      END RECORD,
         g_cnt2                LIKE type_file.num5,
         g_wc                  STRING,
         g_sql                 STRING,
         g_ss                  LIKE type_file.chr1,    # 決定後續步驟
         g_rec_b               LIKE type_file.num5,    # 單身筆數
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT
DEFINE   g_chr                 LIKE type_file.chr1
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg                 LIKE type_file.chr1000
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_argv1               LIKE ocq_file.ocq01
DEFINE   g_curs_index          LIKE type_file.num10
DEFINE   g_row_count           LIKE type_file.num10
DEFINE   g_jump                LIKE type_file.num10
DEFINE   g_no_ask              LIKE type_file.num5
DEFINE   g_std_id              LIKE smb_file.smb01
DEFINE   g_db_type             LIKE type_file.chr3
 
MAIN
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   IF g_sma.sma120 != 'Y' THEN  #不使用多屬性，則不可執行
      CALL cl_err('','axm-555',1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_ocq01_t = NULL
   LET g_ocq02_t = NULL
   LET g_ocq03_t = NULL
 
   OPEN WINDOW i132_w WITH FORM "axm/42f/axmi132"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
  { IF g_sma.sma124 = 'slk' THEN    
      CALL cl_set_comp_visible("ocq06",TRUE) 
   ELSE
      CALL cl_set_comp_visible("ocq06",FALSE) 
   END IF}
 
   LET g_forupd_sql =" SELECT * FROM ocq_file WHERE ocq01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i132_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL i132_q()
   END IF
 
   CALL i132_menu() 
 
   CLOSE WINDOW i132_w                     # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) 
         RETURNING g_time
END MAIN
 
FUNCTION i132_curs()                       # QBE 查詢資料
   CLEAR FORM                                   # 清除畫面
   CALL g_ocq.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "ocq01 = '",g_argv1 CLIPPED,"' "
   ELSE
      CALL cl_set_head_visible("","YES")
 
      CONSTRUCT g_wc ON ocq01,ocq02,ocq03,ocq06,ocq04,ocq05,   
                        ocquser,ocqgrup,ocqmodu,ocqdate,ocqacti
                   FROM ocq01,ocq02,ocq03,ocq06,s_ocq[1].ocq04,s_ocq[1].ocq05,
                        ocquser,ocqgrup,ocqmodu,ocqdate,ocqacti
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ocq03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ocq03"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ocq03
                  NEXT FIELD ocq03
 
               WHEN INFIELD(ocq04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ocq04"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ocq04
                  NEXT FIELD ocq04
 
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
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ocquser', 'ocqgrup') #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE ocq01 FROM ocq_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY ocq01" 
 
   PREPARE i132_prepare FROM g_sql          # 預備一下
   DECLARE i132_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR i132_prepare
 
END FUNCTION
 
FUNCTION i132_count()
 
   DEFINE la_ocq   DYNAMIC ARRAY of RECORD        # 程式變數
            ocq01          LIKE ocq_file.ocq01
                   END RECORD
   DEFINE li_cnt   LIKE type_file.num10
   DEFINE li_rec_b LIKE type_file.num10
 
   LET g_sql= "SELECT UNIQUE ocq01 FROM ocq_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY ocq01"
 
   PREPARE i132_precount FROM g_sql
   DECLARE i132_count CURSOR FOR i132_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i132_count INTO la_ocq[li_cnt].*  
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
 
FUNCTION i132_menu()
 
   WHILE TRUE
      CALL i132_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL i132_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL i132_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL i132_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL i132_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i132_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i132_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ocq),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i132_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_ocq.clear()
 
   INITIALIZE g_ocq01 LIKE ocq_file.ocq01         # 預設值及將數值類變數清成零
   INITIALIZE g_ocq02 LIKE ocq_file.ocq02
   INITIALIZE g_ocq03 LIKE ocq_file.ocq03
   INITIALIZE g_ocq06 LIKE ocq_file.ocq06
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_ocquser = g_user
      LET g_ocqgrup = g_grup
      LET g_ocqdate = g_today
      LET g_ocqacti = 'Y' 
      CALL i132_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_ocq01=NULL
         LET g_ocq02=NULL
         LET g_ocq03=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_ocq.clear()
      ELSE
         CALL i132_b_fill('1=1')             # 單身
      END IF
 
      CALL i132_b()                          # 輸入單身
      LET g_ocq01_t=g_ocq01
      LET g_ocq02_t=g_ocq02
      LET g_ocq03_t=g_ocq03
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i132_i(p_cmd)                       # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改
   DEFINE   l_count      LIKE type_file.num5
   DEFINE   l_n          LIKE type_file.num5
   DEFINE   l_input      LIKE type_file.chr1
   DEFINE   l_agc02      LIKE agc_file.agc02
 
   LET g_ss = 'Y'
 
   DISPLAY g_ocq01,g_ocq02,g_ocq03,g_ocq06,g_ocquser,g_ocqgrup,g_ocqdate,g_ocqacti  #add ocq06
     TO ocq01,ocq02,ocq03,ocq06,ocquser,ocqgrup,ocqdate,ocqacti
   CALL cl_set_head_visible("","YES")
   INPUT g_ocq01,g_ocq02,g_ocq03,g_ocq06 WITHOUT DEFAULTS 
     FROM ocq01,ocq02,ocq03,ocq06
      
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i132_set_entry(p_cmd)
          CALL i132_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD ocq01
         DISPLAY "AFTER FIELD ocq01"
         IF g_ocq01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_ocq01 != g_ocq01_t) THEN
               SELECT COUNT(*) INTO l_n FROM ocq_file 
                WHERE ocq01 = g_ocq01
               IF l_n > 0 THEN
                  CALL cl_err(g_ocq01,-239,1)
                  LET g_ocq01 = g_ocq01_t
                  DISPLAY BY NAME g_ocq01
                  NEXT FIELD ocq01
               END IF
            END IF
         END IF
 
      AFTER FIELD ocq03
         DISPLAY "AFTER FIELD ocq03"
         IF g_ocq03 IS NOT NULL THEN
            IF g_ocq03_t IS NULL OR g_ocq03 != g_ocq03_t THEN
               SELECT COUNT(*) INTO l_n FROM agc_file
                WHERE agc01 = g_ocq03
               IF l_n = 0 THEN
                  CALL cl_err(g_ocq03,'axm-552',0)
                  LET g_ocq03 = g_ocq03_t
                  DISPLAY BY NAME g_ocq03
                  NEXT FIELD ocq03
               END IF
               SELECT agc02 INTO l_agc02 FROM agc_file
                WHERE agc01 = g_ocq03
               DISPLAY l_agc02 TO FORMONLY.agc02
            END IF
         END IF
 
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_ocq01 IS NULL THEN
               DISPLAY BY NAME g_ocq01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD ocq01
            END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ocq03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_agc"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1= g_ocq03
               CALL cl_create_qry() RETURNING g_ocq03
               NEXT FIELD ocq03
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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
END FUNCTION
 
FUNCTION i132_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_ocq01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ocq01_t = g_ocq01
   LET g_ocq02_t = g_ocq02
   LET g_ocq03_t = g_ocq03
 
   BEGIN WORK
   OPEN i132_lock_u USING g_ocq01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i132_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i132_lock_u INTO g_ocq_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("ocq01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i132_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i132_show()
 
   WHILE TRUE
      LET g_ocqmodu = g_user
      LET g_ocqdate = g_today
      CALL i132_i("u")
      IF INT_FLAG THEN
         LET g_ocq01 = g_ocq01_t
         LET g_ocq02 = g_ocq02_t
         LET g_ocq03 = g_ocq03_t
         DISPLAY g_ocq01,g_ocq02,g_ocq03 TO ocq01,ocq02,ocq03
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ocq01 != g_ocq01_t THEN      # 改變組別代碼
         UPDATE ocq_file SET ocq01 = g_ocq01
          WHERE ocq01 = g_ocq01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ocq_file",g_ocq01_t,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE ocq_file SET ocq02 = g_ocq02,ocq03 = g_ocq03,ocq06 = g_ocq06
       WHERE ocq01 = g_ocq01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ocq_file",g_ocq01_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION i132_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM 
   CALL g_ocq.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i132_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i132_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_ocq01 TO NULL
      INITIALIZE g_ocq02 TO NULL
      INITIALIZE g_ocq03 TO NULL
   ELSE
      CALL i132_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i132_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i132_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式
            l_abso   LIKE type_file.num10         #絕對的筆數
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i132_b_curs INTO g_ocq01
      WHEN 'P' FETCH PREVIOUS i132_b_curs INTO g_ocq01
      WHEN 'F' FETCH FIRST    i132_b_curs INTO g_ocq01
      WHEN 'L' FETCH LAST     i132_b_curs INTO g_ocq01
      WHEN '/' 
         IF (NOT g_no_ask) THEN
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
         FETCH ABSOLUTE g_jump i132_b_curs INTO g_ocq01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ocq01,SQLCA.sqlcode,0)
      INITIALIZE g_ocq01 TO NULL
      INITIALIZE g_ocq02 TO NULL
      INITIALIZE g_ocq03 TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
   END IF
   
   CALL i132_show()
END FUNCTION
 
FUNCTION i132_show()                         # 將資料顯示在畫面上
   DEFINE  l_agc02   LIKE agc_file.agc02
 
   SELECT DISTINCT ocq02,ocq03,ocq06,ocquser,ocqgrup,ocqmodu,ocqdate,ocqacti
     INTO g_ocq02,g_ocq03,g_ocq06,
          g_ocquser,g_ocqgrup,g_ocqmodu,g_ocqdate,g_ocqacti
     FROM ocq_file
    WHERE ocq01 =g_ocq01
   DISPLAY g_ocq01,g_ocq02,g_ocq03,g_ocq06,
           g_ocquser,g_ocqgrup,g_ocqmodu,g_ocqdate,g_ocqacti
     TO ocq01,ocq02,ocq03,ocq06,ocquser,ocqgrup,ocqmodu,ocqdate,ocqacti
 
   SELECT agc02 INTO l_agc02 FROM agc_file
    WHERE agc01 = g_ocq03
   DISPLAY l_agc02 TO FORMONLY.agc02
   
   CALL i132_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i132_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,
            l_ocq   RECORD LIKE ocq_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ocq01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM ocq_file WHERE ocq01 = g_ocq01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ocq_file",g_ocq01,"",SQLCA.sqlcode,"","BODY DELETE",0)
      ELSE
         CALL i132_count()
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i132_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i132_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i132_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION i132_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,               # 檢查重複用
            l_cnt           LIKE type_file.num5,
            l_gau01         LIKE type_file.num5,               # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否
            p_cmd           LIKE type_file.chr1,               # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   l_count         LIKE type_file.num5
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   l_agc04         LIKE agc_file.agc04
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_ocq01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   SELECT agc04 INTO l_agc04 FROM agc_file
    WHERE agc01 = g_ocq03
   IF l_agc04 = '2' THEN
      CALL cl_set_comp_entry("ocq05",FALSE)
   ELSE
      CALL cl_set_comp_entry("ocq05",TRUE)
   END IF
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT ocq04,ocq05",
                     "  FROM ocq_file ",
                     "  WHERE ocq01 = ? AND ocq04 = ? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i132_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_ocq WITHOUT DEFAULTS FROM s_ocq.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_ocq_t.* = g_ocq[l_ac].*    #BACKUP
            OPEN i132_bcl USING g_ocq01,g_ocq_t.ocq04
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i132_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i132_bcl INTO g_ocq[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i132_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ocq[l_ac].* TO NULL
         LET g_ocq_t.* = g_ocq[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD ocq04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO ocq_file(ocq01,ocq02,ocq03,ocq06,ocq04,ocq05,      #No.FUN-870117  add ocq06
                              ocquser,ocqgrup,ocqmodu,ocqdate,ocqacti,ocqoriu,ocqorig)
                      VALUES (g_ocq01,g_ocq02,g_ocq03,g_ocq06,          #No.FUN-870117 add ocq06
                              g_ocq[l_ac].ocq04,g_ocq[l_ac].ocq05,
                              g_ocquser,g_ocqgrup,g_ocqmodu,g_ocqdate,g_ocqacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ocq_file",g_ocq01,g_ocq[l_ac].ocq04,SQLCA.sqlcode,"","",0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD ocq04
         IF NOT cl_null(g_ocq[l_ac].ocq04) THEN
           IF g_ocq_t.ocq04 IS NULL OR g_ocq[l_ac].ocq04 != g_ocq_t.ocq04 THEN
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM ocq_file 
             WHERE ocq01 = g_ocq01
               AND ocq04 = g_ocq[l_ac].ocq04
            IF l_count > 0 THEN
               CALL cl_err(g_ocq[l_ac].ocq04,"axm-553",0)
               NEXT FIELD ocq04
            END IF
            SELECT COUNT(*) INTO l_count FROM agc_file,agd_file
             WHERE (agd01=g_ocq03 AND agc01=agd01 AND agd02=g_ocq[l_ac].ocq04 AND agc04='2')
                OR (agc01=g_ocq03 AND agc04='3' AND agc05<=g_ocq[l_ac].ocq04 AND agc06>=g_ocq[l_ac].ocq04)
                OR (agc01=g_ocq03 AND agc04='1')
            IF l_count = 0 THEN
               CALL cl_err(g_ocq[l_ac].ocq04,"axm-554",0)
               NEXT FIELD ocq04
            END IF
            SELECT agd03 INTO g_ocq[l_ac].ocq05 FROM agd_file
             WHERE agd01 = g_ocq03
               AND agd02 = g_ocq[l_ac].ocq04
           END IF 
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_ocq_t.ocq04) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM ocq_file WHERE ocq01 = g_ocq01
                                   AND ocq04 = g_ocq[l_ac].ocq04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ocq_file",g_ocq01,g_ocq_t.ocq04,SQLCA.sqlcode,"","",0)
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
            LET g_ocq[l_ac].* = g_ocq_t.*
            CLOSE i132_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ocq[l_ac].ocq04,-263,1)
            LET g_ocq[l_ac].* = g_ocq_t.*
         ELSE
            UPDATE ocq_file
               SET ocq04 = g_ocq[l_ac].ocq04,
                   ocq05 = g_ocq[l_ac].ocq05
             WHERE ocq01 = g_ocq01
               AND ocq04 = g_ocq_t.ocq04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ocq_file",g_ocq01,g_ocq_t.ocq04,SQLCA.sqlcode,"","",0)
               LET g_ocq[l_ac].* = g_ocq_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ocq[l_ac].* = g_ocq_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_ocq.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i132_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add
         CLOSE i132_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(ocq04) AND l_ac > 1 THEN
            LET g_ocq[l_ac].* = g_ocq[l_ac-1].*
            NEXT FIELD ocq04
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ocq04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_agd"
               LET g_qryparam.arg1 = g_ocq03
               LET g_qryparam.default1 = g_ocq[l_ac].ocq04
               CALL cl_create_qry() RETURNING g_ocq[l_ac].ocq04
               DISPLAY BY NAME g_ocq[l_ac].ocq04
               NEXT FIELD ocq04
 
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
 
   CLOSE i132_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i132_b_fill(p_wc)               #BODY FILL UP
 
   DEFINE p_wc         STRING 
 
    LET g_sql = "SELECT ocq04,ocq05 ",
                 " FROM ocq_file ",
                " WHERE ocq01 = '",g_ocq01 CLIPPED,"' ",
                  " AND ",p_wc CLIPPED,
                " ORDER BY ocq04"
 
    PREPARE i132_prepare2 FROM g_sql           #預備一下
    DECLARE ocq_curs CURSOR FOR i132_prepare2
 
    CALL g_ocq.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH ocq_curs INTO g_ocq[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ocq.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i132_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_ocq TO s_ocq.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice='reproduce'
         EXIT DISPLAY
 
      ON ACTION delete                           # R.取消
         LET g_action_choice='delete'
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
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
         CALL i132_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY 
 
      ON ACTION previous                         # P.上筆
         CALL i132_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY
 
      ON ACTION jump                             # 指定筆
         CALL i132_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY 
 
      ON ACTION next                             # N.下筆
         CALL i132_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY 
 
      ON ACTION last                             # 最終筆
         CALL i132_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY 
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
{      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
         END IF 
}
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i132_copy()
   DEFINE   l_n       LIKE type_file.num5,
            l_new01   LIKE ocq_file.ocq01,
            l_old01   LIKE ocq_file.ocq01
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_ocq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")
   CALL cl_set_comp_entry("ocq01",TRUE)   #No.FUN-870117 add
 
   INPUT l_new01 WITHOUT DEFAULTS FROM ocq01
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         IF cl_null(l_new01) THEN
            NEXT FIELD ocq01
         END IF
 
          SELECT COUNT(*) INTO g_cnt FROM ocq_file
           WHERE ocq01 = l_new01 
          IF g_cnt > 0 THEN
             CALL cl_err(l_new01,-239,0)
             NEXT FIELD ocq01
          END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_ocq01,g_ocq02,g_ocq03 TO ocq01,ocq02,ocq03
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM ocq_file WHERE ocq01 = g_ocq01
     INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_ocq01,"",SQLCA.sqlcode,"","",0)
      RETURN
   END IF
 
   UPDATE x SET ocq01 = l_new01                        # 資料鍵值
 
   INSERT INTO ocq_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","ocq_file",l_new01,"",SQLCA.sqlcode,"","",0)
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_ocq01
   LET g_ocq01 = l_new01
   CALL i132_b()
   LET g_ocq01 = l_old01
   CALL i132_show()
END FUNCTION
 
FUNCTION i132_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("ocq01,ocq03",TRUE)   #No.FUN-870117 add ocq03
     END IF
 
END FUNCTION
 
FUNCTION i132_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("ocq01,ocq03",FALSE)
    END IF
 
END FUNCTION
#No.FUN-870117--end
