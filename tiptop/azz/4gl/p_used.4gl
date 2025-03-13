# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: p_used
# Descriptions...: 程試用量查詢作業
# Date & Author..: 03/07/27 yuna   
# Modify.........: No.MOD-530267 05/03/25 By alex 改 q_zz to q_gaz
# Modify.........: No.MOD-540140 05/04/20 By alex 改 controlf 寫法
# Modify.........: No.FUN-560039 05/06/10 By alex 改變時間排序方式為由大到小 (apple)
# Modify.........: NO.MOD-580056 05/08/05 By Yiting key可更改
# Modify.........: NO.MOD-590329 05/10/04 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.TQC-620037 06/02/16 alex 結合 aoor010
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成mi_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/22 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"                  
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zu01          LIKE zu_file.zu01,            # 類別代號 (假單頭)
         g_zu01_t        LIKE zu_file.zu01,            # 類別代號 (假單頭)
         g_zu_lock RECORD LIKE zu_file.*,              # FOR LOCK CURSOR TOUCH
         g_zu    DYNAMIC ARRAY of RECORD               # 程式變數
            zu02          LIKE zu_file.zu02,
            zu03          LIKE zu_file.zu03,
            zu04          LIKE zu_file.zu04,
            zu05          LIKE zu_file.zu05
                      END RECORD,
         g_zu_t           RECORD                       # 變數舊值
            zu02          LIKE zu_file.zu02,
            zu03          LIKE zu_file.zu03,
            zu04          LIKE zu_file.zu04,
            zu05          LIKE zu_file.zu05
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #No.FUN-680135 SMALLINT
         g_wc                  string,                 # 儲存查詢條件 #No.FUN-580092 HCN
         g_sql                 string,                 # 組sql條件    #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,    # 決定後續步驟 #No.FUN-680135 VARCHAR(1)
         g_rec_b               LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_chr                 LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE zu_file.zu01
DEFINE   g_row_count    LIKE type_file.num10           #No.FUN-680135 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10           #No.FUN-680135 INTEGER
DEFINE   g_jump         LIKE type_file.num10           #No.FUN-680135 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5            #No.FUN-680135 SMALLINT #No.FUN-6A0080
 
MAIN
DEFINE   p_row,p_col    LIKE type_file.num5            #No.FUN-680135   SMALLINT 
#     DEFINEl_time   LIKE type_file.chr8             #No.FUN-6A0096
 
   OPTIONS                                             # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                     # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET g_zu01_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW p_used_w AT p_row,p_col WITH FORM "azz/42f/p_used"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()                           # 開啟主畫面
 
   LET g_forupd_sql = "SELECT * from zu_file  WHERE zu01 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_used_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_used_q()
   END IF
 
   CALL p_used_menu() 
 
   CLOSE WINDOW p_used_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_used_curs()                        # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_zu.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "zu01 = '",g_argv1 CLIPPED,"' "
   ELSE
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      CONSTRUCT g_wc ON zu01,zu02,zu03,zu04,zu05
                   FROM zu01,s_zu[1].zu02,s_zu[1].zu03,s_zu[1].zu04,
                             s_zu[1].zu05
 
         ON ACTION CONTROLP            # 進行開窗查詢
            CASE
               WHEN INFIELD(zu01)
                  CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_zz"  # 指定組別
                   LET g_qryparam.form = "q_gaz"  #MOD-530267
                  LET g_qryparam.state = "c"    
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zu01
                  NEXT FIELD zu01
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
          ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE zu01 FROM zu_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zu01"
   PREPARE p_used_prepare FROM g_sql          # 預備一下
   DECLARE p_used_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_used_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT zu01) FROM zu_file ",
               " WHERE ",g_wc CLIPPED
 
   PREPARE p_used_precount FROM g_sql
   DECLARE p_used_count CURSOR FOR p_used_precount
END FUNCTION
 
FUNCTION p_used_menu()
 
   DEFINE ls_msg      STRING   #TQC-620037
 
   WHILE TRUE
      CALL p_used_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_used_a()
            END IF
 
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_used_u()
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_used_copy()
            END IF
 
#        WHEN "delete"                          # R.取消
#           IF cl_chk_act_auth() THEN
#              CALL p_used_r()
#           END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_used_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_used_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "output"                          #TQC-620037
            LET ls_msg = "aoor010 "
            CALL cl_cmdrun(ls_msg)
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_used_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_zu.clear()
 
   INITIALIZE g_zu01 LIKE zu_file.zu01         # 預設值及將數值類變數清成零
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_used_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_zu01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_zu.clear()
      ELSE
         CALL p_used_b_fill('1=1')             # 單身
      END IF
 
      CALL p_used_b()                          # 輸入單身
      LET g_zu01_t=g_zu01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_used_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd  LIKE type_file.chr1         # a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
 
   LET g_ss = 'Y'
   DISPLAY g_zu01 TO zu01
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_zu01 WITHOUT DEFAULTS FROM zu01
 
    #NO.MOD-580056------
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_used_set_entry(p_cmd)
         CALL p_used_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   #--------END
 
      AFTER FIELD zu01                         # 查詢程式代號
         IF NOT cl_null(g_zu01) THEN
            IF g_zu01 != g_zu01_t OR cl_null(g_zu01_t) THEN
               SELECT COUNT(UNIQUE zu01) INTO g_cnt FROM zu_file
                WHERE zu01 = g_zu01
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_zu01,-239,0)
                     LET g_zu01 = g_zu01_t
                     NEXT FIELD zu01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_zu01,g_errno,0)
                  NEXT FIELD zu01
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(zu01)
               CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zz"
                LET g_qryparam.form = "q_gaz"    #MOD-530267
               LET g_qryparam.default1= g_zu01
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_zu01
               NEXT FIELD zu01
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
       ON ACTION controlf         #欄位說明  #MOD-530267
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#TQC-860017 start
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
#TQC-860017 end
   END INPUT
END FUNCTION
 
 
FUNCTION p_used_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_zu01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zu01_t = g_zu01
 
   BEGIN WORK
   OPEN p_used_lock_u USING g_zu01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_used_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_used_lock_u INTO g_zu_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zu01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_used_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL p_used_i("u")
      IF INT_FLAG THEN
         LET g_zu01 = g_zu01_t
         DISPLAY g_zu01 TO zu01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE zu_file SET zu01 = g_zu01
       WHERE zu01 = g_zu01_t
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_zu01,SQLCA.sqlcode,0)  #No.FUN-610081
         CALL cl_err3("upd","zu_file",g_zu01_t,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_used_q()                            #Query 查詢
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
  #CLEAR FROM  #NO.TQC-740075
   CLEAR FORM  #NO.TQC-740075
   CALL g_zu.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_used_curs()                          #取得查詢條件
   IF INT_FLAG THEN                            #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_used_b_curs                          #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                       #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_zu01 TO NULL
   ELSE
      CALL p_used_fetch('F')                   #讀出TEMP第一筆並顯示
      OPEN p_used_count
      FETCH p_used_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
FUNCTION p_used_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,      #處理方式    #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10      #絕對的筆數  #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_used_b_curs INTO g_zu01
      WHEN 'P' FETCH PREVIOUS p_used_b_curs INTO g_zu01
      WHEN 'F' FETCH FIRST    p_used_b_curs INTO g_zu01
      WHEN 'L' FETCH LAST     p_used_b_curs INTO g_zu01
      WHEN '/' 
         IF (NOT mi_no_ask) THEN #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
              EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_used_b_curs INTO g_zu01
         LET mi_no_ask = FALSE            #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zu01,SQLCA.sqlcode,0)
      INITIALIZE g_zu01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL p_used_show()
   END IF
END FUNCTION
 
FUNCTION p_used_show()                       # 將資料顯示在畫面上
 
   DEFINE lc_gaz03   LIKE gaz_file.gaz03
 
   SELECT gaz03 INTO lc_gaz03 FROM gaz_file
    WHERE gaz01=g_zu01 AND gaz02=g_lang
 
   DISPLAY g_zu01,lc_gaz03 TO zu01,gaz03
   CALL p_used_b_fill(g_wc)                  # 單身
 
    CALL cl_show_fld_cont()                  #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_used_r()                          # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt  LIKE type_file.num5,      #No.FUN-680135 SMALLINT
            l_zu   RECORD LIKE zu_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zu01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM zu_file WHERE zu01 = g_zu01
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","zu_file",g_zu01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_zu.clear()
         OPEN p_used_count
         FETCH p_used_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_used_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_used_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE        #No.FUN-6A0080
            CALL p_used_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_used_b()                                # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT    #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,   # 檢查重複用           #No.FUN-680135 SMALLINT
            l_gau01         LIKE type_file.num5,   # 檢查重複用           #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否           #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,   # 處理狀態             #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135         SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135         SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_zu01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zu02,'',zu03,zu04,zu05",
                      " FROM zu_file ",
                     "  WHERE zu01 = ? AND zu02 = ? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_used_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET l_ac_t = 0
 
   INPUT ARRAY g_zu WITHOUT DEFAULTS FROM s_zu.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(l_ac)
#        END IF
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
            LET g_zu_t.* = g_zu[l_ac].*    #BACKUP
#NO.MOD-590329  MARK------------------
 #No.MOD-580056 --start
#            LET g_before_input_done = FALSE
#            CALL p_used_set_entry_b(p_cmd)
#            CALL p_used_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK------------------
            OPEN p_used_bcl USING g_zu01,g_zu_t.zu02
            IF SQLCA.sqlcode THEN 
               CALL cl_err("OPEN p_used_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_used_bcl INTO g_zu[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_used_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
#                 SELECT gae04 INTO g_zu[l_ac].gae04 FROM gae_file
#                  WHERE gae01=g_zu01 
#                    AND gae02=g_zu[l_ac].zu02 AND gae03=g_lang
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zu[l_ac].* TO NULL       #900423
         LET g_zu_t.* = g_zu[l_ac].*          #新輸入資料
#NO.MOD-590329 MARK--------------------
 #No.MOD-580056 --start
#         LET g_before_input_done = FALSE
#         CALL p_used_set_entry_b(p_cmd)
#         CALL p_used_set_no_entry_b(p_cmd)
#         LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK-------------------- 
        CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD zu02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO zu_file (zu01,zu02,zu03,zu04,zu5)
              VALUES (g_zu01,g_zu[l_ac].zu02,g_zu[l_ac].zu03,
                      g_zu[l_ac].zu04,g_zu[l_ac].zu05)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zu01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","zu_file",g_zu01,g_zu[l_ac].zu02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD zu02
         IF g_zu[l_ac].zu02 != g_zu_t.zu02 OR g_zu_t.zu02 IS NULL THEN
            # 檢視 zu_file 中同一 Program Name (zu01) 下是否有相同的
            # Filed Name (zu02)
            SELECT COUNT(*) INTO l_n FROM zu_file
             WHERE zu01 = g_zu01 AND zu02 = g_zu[l_ac].zu02
            IF l_n > 0 THEN
               CALL cl_err(g_zu[l_ac].zu02,-239,0)
               LET g_zu[l_ac].zu02 = g_zu_t.zu02
               NEXT FIELD zu02
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_zu_t.zu02) THEN
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
            DELETE FROM zu_file WHERE zu01 = g_zu01
                                   AND zu02 = g_zu[l_ac].zu02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zu_t.zu02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zu_file",g_zu01,g_zu_t.zu02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
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
            LET g_zu[l_ac].* = g_zu_t.*
            CLOSE p_used_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("Primary Key CHANGING!","!",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zu[l_ac].zu02,-263,1)
            LET g_zu[l_ac].* = g_zu_t.*
         ELSE
            UPDATE zu_file
               SET zu02 = g_zu[l_ac].zu02,
                   zu03 = g_zu[l_ac].zu03,
                   zu04 = g_zu[l_ac].zu04,
                   zu05 = g_zu[l_ac].zu05
             WHERE zu01 = g_zu01
               AND zu02 = g_zu_t.zu02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zu[l_ac].zu02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zu_file",g_zu01,g_zu_t.zu02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zu[l_ac].* = g_zu_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30034 Mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zu[l_ac].* = g_zu_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_zu.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end-- 
            END IF
            CLOSE p_used_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30034 Add
         CLOSE p_used_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(zu02) AND l_ac > 1 THEN
            LET g_zu[l_ac].* = g_zu[l_ac-1].*
            NEXT FIELD zu02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END INPUT
   CLOSE p_used_bcl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION p_used_b_fill(p_wc)                  #BODY FILL UP
   DEFINE p_wc         LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(300)
   DEFINE p_ac         LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
    LET g_sql = "SELECT zu02,zu03,zu04,zu05 ",
                " FROM zu_file ",
                " WHERE zu01= '",g_zu01 CLIPPED,"' ",
                " AND ",p_wc CLIPPED,
                " ORDER BY zu02 DESC, zu03 DESC"  #FUN-560039
    DISPLAY "g_sql=",g_sql
    PREPARE p_used_prepare2 FROM g_sql           #預備一下
    DECLARE zu_curs CURSOR FOR p_used_prepare2
 
    CALL g_zu.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH zu_curs INTO g_zu[g_cnt].*       #單身 ARRAY 填充
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
    CALL g_zu.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_used_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_zu TO s_zu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
 
#     ON ACTION insert                           # A.輸入
#        LET g_action_choice="insert"
#        EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
#     ON ACTION modify                           # Q.修改
#        LET g_action_choice="modify"
#        EXIT DISPLAY
 
#     ON ACTION reproduce                        # C.複製
#        LET g_action_choice="reproduce"
#        EXIT DISPLAY
 
#     ON ACTION delete                           # R.取消
#        LET g_action_choice="delete"
 
#     ON ACTION detail                           # B.單身
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
 
#     ON ACTION accept
#        LET g_action_choice="detail"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
 
#     ON ACTION modify_desc
#        LET g_action_choice="modify_desc"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
 
#     ON ACTION special_set
#        LET g_action_choice="special_set"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_used_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#          IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
#          END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_used_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#          IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
#          END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_used_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#          IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
#          END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next                             # N.下筆
         CALL p_used_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#          IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
#          END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_used_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#          IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
#          END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION output     #TQC-620037
         LET g_action_choice="output"
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
 
FUNCTION p_used_copy()
   DEFINE   l_n       LIKE type_file.num5,       #No.FUN-680135 SMALLINT
            l_newno   LIKE zu_file.zu01,
            l_oldno   LIKE zu_file.zu01
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_zu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newno WITHOUT DEFAULTS FROM zu01
 
      AFTER FIELD zu01
         IF cl_null(l_newno) THEN
            NEXT FIELD zu01
         END IF
         SELECT COUNT(*) INTO g_cnt FROM zu_file
          WHERE zu01 = l_newno
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD zu01
         END IF
#TQC-860017 start
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
#TQC-860017 end  
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_zu01 TO zu01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM zu_file WHERE zu01 = g_zu01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_zu01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_zu01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET zu01 = l_newno                         # 資料鍵值
 
   INSERT INTO zu_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('zu:',SQLCA.SQLCODE,0)
      CALL cl_err3("ins","zu_file",l_newno,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldno = g_zu01
   LET g_zu01 = l_newno
   CALL p_used_b()
   #LET g_zu01 = l_oldno #FUN-C30027
   #CALL p_used_show()   #FUN-C30027
END FUNCTION
 
 #No.MOD-580056 --start
FUNCTION p_used_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("zu01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_used_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("zu01",FALSE)
   END IF
END FUNCTION
 
#NO.MOD-590329 MARK-------------------------
#FUNCTION p_used_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("zu02",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_used_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("zu02",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580056 --end
#NO.MOD-590329 MARK
