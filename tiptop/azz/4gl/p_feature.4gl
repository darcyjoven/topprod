# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: p_feature.4gl
# Descriptions...: 作業特色或特點表列維護作業
# Date & Author..: 04/04/04 alex
# Modify.........: No.FUN-4C0040 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.MOD-540140 05/04/20 By alex 修正 controlf 寫法
# Modify.........: NO.MOD-580056 05/08/04 By yiting key可更改
# Modify.........: NO.MOD-590329 05/10/03 By yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/22 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-6B0081 07/04/09 By pengu 隱藏"更改"action按鈕
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gbf01          LIKE gbf_file.gbf01,   # 類別代號 (假單頭)
         g_gbf01_t        LIKE gbf_file.gbf01,   # 類別代號 (假單頭)
         g_argv1          LIKE gbf_file.gbf01,   # 接收傳值
         g_gbf_lock RECORD LIKE gbf_file.*,      # FOR LOCK CURSOR TOUCH
         g_gbf    DYNAMIC ARRAY of RECORD        # 程式變數
            gbf02          LIKE gbf_file.gbf02,
            gbf03          LIKE gbf_file.gbf03,
            gbf04          LIKE gbf_file.gbf04,
            gbf05          LIKE gbf_file.gbf05
                      END RECORD,
         g_gbf_t           RECORD                 # 變數舊值
            gbf02          LIKE gbf_file.gbf02,
            gbf03          LIKE gbf_file.gbf03,
            gbf04          LIKE gbf_file.gbf04,
            gbf05          LIKE gbf_file.gbf05
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #FUN-680135 SMALLINT
         g_wc                  string,  #No.FUN-580092 HCN
         g_sql                 string,  #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,    #FUN-680135 VARCHAR(1) # 決定後續步驟
         g_rec_b               LIKE type_file.num5,    # 單身筆數  #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_chr                 LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5   #No.FUN-680135 SMALLINT
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680135 SMALLINT #No.FUN-6A0080
 
MAIN
   DEFINE   p_row,p_col    LIKE type_file.num5       #No.FUN-680135 SMALLINT 
#     DEFINE   l_time   LIKE type_file.chr8             #No.FUN-6A0096
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET g_argv1 = ARG_VAL(1)
   LET g_gbf01_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW p_feature_w AT p_row,p_col WITH FORM "azz/42f/p_feature"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gbf02")
 
   LET g_forupd_sql = "SELECT * from gbf_file  WHERE gbf01 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_feature_lock_u CURSOR FROM g_forupd_sql
 
   # 2004/04/28 增加接收傳值的窗口
   IF NOT cl_null(g_argv1) THEN
       CALL p_feature_q()
   END IF
 
   CALL p_feature_menu() 
 
   CLOSE WINDOW p_feature_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_feature_curs()                         # QBE 查詢資料
 
   CLEAR FORM                                     # 清除畫面
   CALL g_gbf.clear()
 
   # 2004/04/05 新增傳值修改
   IF cl_null(g_argv1) THEN
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
 
      CONSTRUCT g_wc ON gbf01,gbf02,gbf03,gbf04,gbf05
                   FROM gbf01, s_gbf[1].gbf02, s_gbf[1].gbf03, s_gbf[1].gbf04,
                               s_gbf[1].gbf05
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(gbf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.state = "c" 
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gbf01
                  NEXT FIELD gbf01
 
               OTHERWISE
                  EXIT CASE
            END CASE
       
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gbfuser', 'gbfgrup') #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = "gbf01 = '",g_argv1 CLIPPED,"' "
   END IF
 
   LET g_sql= "SELECT UNIQUE gbf01 FROM gbf_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY gbf01 "
                
   PREPARE p_feature_pre FROM g_sql          # 預備一下
   DECLARE p_feature_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_feature_pre
   DISPLAY g_sql
   LET g_sql = "SELECT COUNT(DISTINCT gbf01) FROM gbf_file ",
               " WHERE ",g_wc CLIPPED
 
   PREPARE p_feature_precount FROM g_sql
   DECLARE p_feature_count CURSOR FOR p_feature_precount
END FUNCTION
 
FUNCTION p_feature_menu()
 
   WHILE TRUE
      CALL p_feature_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_feature_a()
            END IF
 
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_feature_u()
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_feature_copy()
            END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_feature_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_feature_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "about"
            CALL cl_about()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_feature_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_gbf.clear()
 
   INITIALIZE g_gbf01 LIKE gbf_file.gbf01         # 預設值及將數值類變數清成零
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_feature_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_gbf01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_gbf.clear()
      ELSE
         CALL p_feature_b_fill('1=1')             # 單身
      END IF
 
      CALL p_feature_b()                          # 輸入單身
      LET g_gbf01_t=g_gbf01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_feature_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1      # a:輸入 u:更改   #No.FUN-680135 VARCHAR(1)
 
   LET g_ss = 'Y'
   DISPLAY g_gbf01 TO gbf01
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_gbf01 WITHOUT DEFAULTS FROM gbf01
 
    #NO.MOD-580056------
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_feature_set_entry(p_cmd)
         CALL p_feature_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   #--------END
 
 
      AFTER FIELD gbf01                         # 查詢程式代號
         IF NOT cl_null(g_gbf01) THEN
            IF g_gbf01 != g_gbf01_t OR cl_null(g_gbf01_t) THEN
               SELECT COUNT(UNIQUE gbf01) INTO g_cnt FROM gbf_file
                WHERE gbf01 = g_gbf01
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gbf01,-239,0)
                     LET g_gbf01 = g_gbf01_t
                     NEXT FIELD gbf01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_gbf01,g_errno,0)
                  NEXT FIELD gbf01
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gbf01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz"
               LET g_qryparam.default1= g_gbf01
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_gbf01
#               CALL FGL_DIALOG_SETBUFFER( g_gbf01 )
               DISPLAY g_gbf01 TO gbf01
               NEXT FIELD gbf01
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf   #欄位說明  MOD-540140
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #FUN-860033
 
      ON ACTION controlg      #FUN-860033
         CALL cl_cmdask()     #FUN-860033
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT
 
   END INPUT
END FUNCTION
 
 
FUNCTION p_feature_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gbf01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gbf01_t = g_gbf01
 
   BEGIN WORK
   OPEN p_feature_lock_u USING g_gbf01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_feature_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_feature_lock_u INTO g_gbf_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gbf01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_feature_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL p_feature_i("u")
      IF INT_FLAG THEN
         LET g_gbf01 = g_gbf01_t
         DISPLAY g_gbf01 TO gbf01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gbf_file SET gbf01 = g_gbf01
       WHERE gbf01 = g_gbf01_t
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_gbf01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","gbf_file",g_gbf01_t,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_feature_q()                            #Query 查詢
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   CALL g_gbf.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_feature_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_feature_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gbf01 TO NULL
   ELSE
      OPEN p_feature_count
      FETCH p_feature_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_feature_fetch('F')                 #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION p_feature_fetch(p_flag)              #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,     #處理方式    #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10     #絕對的筆數  #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_feature_b_curs INTO g_gbf01
      WHEN 'P' FETCH PREVIOUS p_feature_b_curs INTO g_gbf01
      WHEN 'F' FETCH FIRST    p_feature_b_curs INTO g_gbf01
      WHEN 'L' FETCH LAST     p_feature_b_curs INTO g_gbf01
      WHEN '/' 
 
         IF (NOT g_no_ask) THEN         #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            END PROMPT
 
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_feature_b_curs INTO g_gbf01
         LET g_no_ask = FALSE         #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gbf01,SQLCA.sqlcode,0)
      INITIALIZE g_gbf01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
   CALL p_feature_show()
END FUNCTION
 
FUNCTION p_feature_show()                         # 將資料顯示在畫面上
   DISPLAY g_gbf01 TO gbf01
   CALL p_feature_b_fill(g_wc)                    # 單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_feature_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_gbf   RECORD LIKE gbf_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gbf01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gbf_file WHERE gbf01 = g_gbf01
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","gbf_file",g_gbf01,"",SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_gbf.clear()
         OPEN p_feature_count
         FETCH p_feature_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_feature_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_feature_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL p_feature_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_feature_b()                              # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,    # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,    # 檢查重複用        #No.FUN-680135 SMALLINT
            l_gau01         LIKE type_file.num5,    # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,    # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,    # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,    #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5     #No.FUN-680135      SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gbf01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gbf02,gbf03,gbf04,gbf05 ",
                     "  FROM gbf_file",
                     "  WHERE gbf01 = ? AND gbf02 = ? ",
                       " AND gbf03 = ? AND gbf04 = ? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_feature_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gbf WITHOUT DEFAULTS FROM s_gbf.*
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
            LET g_gbf_t.* = g_gbf[l_ac].*    #BACKUP
#NO.MOD-590329 MARK---------------------------
    #NO.MOD-580056------
#            LET g_before_input_done = FALSE
#            CALL p_feature_set_entry_b(p_cmd)
#            CALL p_feature_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
   #--------END
#NO.MOD-590329 MARK-----------------------------
            OPEN p_feature_bcl USING g_gbf01,g_gbf_t.gbf02,g_gbf_t.gbf03,g_gbf_t.gbf04
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_feature_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_feature_bcl INTO g_gbf[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_feature_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gbf[l_ac].* TO NULL       #900423
         LET g_gbf_t.* = g_gbf[l_ac].*          #新輸入資料
#NO.MOD-590329 MARK---------------
    #NO.MOD-580056------
#         LET g_before_input_done = FALSE
#         CALL p_feature_set_entry_b(p_cmd)
#         CALL p_feature_set_no_entry_b(p_cmd)
#         LET g_before_input_done = TRUE
   #--------END
#NO.MOD-590329 MARK----------------
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gbf02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gbf_file(gbf01,gbf02,gbf03,gbf04,gbf05,gbforiu,gbforig)
                      VALUES (g_gbf01,g_gbf[l_ac].gbf02,g_gbf[l_ac].gbf03,
                                      g_gbf[l_ac].gbf04,g_gbf[l_ac].gbf05, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gbf01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gbf_file",g_gbf01,g_gbf[l_ac].gbf02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD gbf05
         CALL s_textedit(g_gbf[l_ac].gbf05) RETURNING g_gbf[l_ac].gbf05
         DISPLAY g_gbf[l_ac].gbf05 TO gbf05
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gbf_t.gbf02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err("Deleting One of Several Primary Keys!","!",1)
            END IF
            DELETE FROM gbf_file WHERE gbf01 = g_gbf01
                                   AND gbf02 = g_gbf[l_ac].gbf02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbf_t.gbf02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gbf_file",g_gbf01,g_gbf_t.gbf02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
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
            LET g_gbf[l_ac].* = g_gbf_t.*
            CLOSE p_feature_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("Primary Key CHANGING!","!",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gbf[l_ac].gbf02,-263,1)
            LET g_gbf[l_ac].* = g_gbf_t.*
         ELSE
            UPDATE gbf_file
               SET gbf02 = g_gbf[l_ac].gbf02,
                   gbf03 = g_gbf[l_ac].gbf03,
                   gbf04 = g_gbf[l_ac].gbf04,
                   gbf05 = g_gbf[l_ac].gbf05
             WHERE gbf01 = g_gbf01
               AND gbf02 = g_gbf_t.gbf02
               AND gbf03 = g_gbf_t.gbf03
               AND gbf04 = g_gbf_t.gbf04
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbf[l_ac].gbf02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gbf_file",g_gbf01,g_gbf_t.gbf02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gbf[l_ac].* = g_gbf_t.*
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
               LET g_gbf[l_ac].* = g_gbf_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gbf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_feature_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add
         CLOSE p_feature_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gbf02) AND l_ac > 1 THEN
            LET g_gbf[l_ac].* = g_gbf[l_ac-1].*
            NEXT FIELD gbf02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
     ON ACTION about         #FUN-860033
        CALL cl_about()      #FUN-860033
 
     ON ACTION help          #FUN-860033
        CALL cl_show_help()  #FUN-860033
 
     ON IDLE g_idle_seconds  #FUN-860033
         CALL cl_on_idle()
         CONTINUE INPUT 
 
   END INPUT
   CLOSE p_feature_bcl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION p_feature_b_fill(p_wc)               #BODY FILL UP
   DEFINE p_wc         LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(300)
   DEFINE p_ac         LIKE type_file.num5    #FUN-680135    SMALLINT
 
    LET g_sql = "SELECT gbf02,gbf03,gbf04,gbf05 ",
                 " FROM gbf_file ",
                " WHERE gbf01 = '",g_gbf01 CLIPPED,"' ",
                  " AND ",p_wc CLIPPED,
                " ORDER BY gbf02 "
 
    PREPARE p_feature_pre2 FROM g_sql           #預備一下
    DECLARE gbf_curs CURSOR FOR p_feature_pre2
 
    CALL g_gbf.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH gbf_curs INTO g_gbf[g_cnt].*       #單身 ARRAY 填充
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
    CALL g_gbf.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_feature_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
#  CALL cl_set_act_visible("about", TRUE)
   DISPLAY ARRAY g_gbf TO s_gbf.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         IF NOT cl_null(g_argv1) THEN
            CALL cl_navigator_setting(0,0)
         ELSE
            CALL cl_navigator_setting(g_curs_index, g_row_count)
         END IF
 
      BEFORE ROW
      CALL SET_COUNT(g_rec_b)
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
     #----------No.TQC-6B0081 mark
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
     #----------No.TQC-6B0081 end
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
#     ON ACTION delete                           # R.取消
#        LET g_action_choice="delete"
 
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_feature_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_feature_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_feature_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_feature_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_feature_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice='help'
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_lang("gbf02")
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
 
       ON ACTION about         #MOD-4C0121
         CALL cl_about()
         LET g_action_choice="about"
         EXIT DISPLAY
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_feature_copy()
   DEFINE   l_n       LIKE type_file.num5,      #No.FUN-680135 SMALLINT
            l_newno   LIKE gbf_file.gbf01,
            l_oldno   LIKE gbf_file.gbf01
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_gbf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_newno WITHOUT DEFAULTS FROM gbf01
 
      AFTER FIELD gbf01
         IF cl_null(l_newno) THEN
            NEXT FIELD gbf01
         END IF
         SELECT COUNT(*) INTO g_cnt FROM gbf_file
          WHERE gbf01 = l_newno
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD gbf01
         END IF
 
     ON ACTION about         #FUN-860033
        CALL cl_about()      #FUN-860033
 
     ON ACTION controlg      #FUN-860033
        CALL cl_cmdask()     #FUN-860033
 
     ON ACTION help          #FUN-860033
        CALL cl_show_help()  #FUN-860033
 
     ON IDLE g_idle_seconds  #FUN-860033
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_gbf01 TO gbf01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM gbf_file WHERE gbf01 = g_gbf01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_gbf01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_gbf01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET gbf01 = l_newno                         # 資料鍵值
 
   INSERT INTO gbf_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
#     CALL cl_err('gbf:',SQLCA.SQLCODE,0) #No.FUN-660081
      CALL cl_err3("ins","gbf_file",l_newno,"",SQLCA.sqlcode,"","gbf",0)   #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldno = g_gbf01
   LET g_gbf01 = l_newno
   CALL p_feature_b()
   #LET g_gbf01 = l_oldno  #FUN-C30027
   #CALL p_feature_show()  #FUN-C30027
END FUNCTION
 
 #No.MOD-580056 --start
FUNCTION p_feature_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gbf01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_feature_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gbf01",FALSE)
   END IF
 
END FUNCTION
 
#NO.MOD-590329 MARK-------------------
#FUNCTION p_feature_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("gbf02,gbf03,gbf04",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_feature_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("gbf02,gbf03,gbf04",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580056 --end
#NO.MOD-590329 MARK--------------------
