# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_zr.4gl
# Descriptions...: 程式檔案關連建立
# Date & Author..: 93/06/31 Roger
# Modify.........: No.FUN-570088 05/07/11 alex 修改為單檔多欄顯示模式
# Modify.........: No.FUN-570274 05/07/30 alex 增加重抓取功能
# Modify.........: No.MOD-580237 05/08/26 alex modi zta03,09 to gat06,07
# Modify.........: No.TQC-590025 05/09/23 alex 拉回列印功能
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6C0011 06/12/08 By Carrier 報表對齊調整
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740075 07/04/13 By Xufeng  "CLEAR FROM"應改為"CLEAR FORM"                   
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.MOD-860248 08/07/10 By alex 修正 串接作業代碼
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zr01                LIKE zr_file.zr01,   # 程式代碼 
         g_zr01_t              LIKE zr_file.zr01,   # 程式代碼
         g_gaz03               LIKE gaz_file.gaz03, # 程式名稱
         g_zr_lock             RECORD LIKE zr_file.*,
         g_zr                  DYNAMIC ARRAY of RECORD        
            zr02               LIKE zr_file.zr02,
            zr03               LIKE zr_file.zr03,
            gat03              LIKE gat_file.gat03,
            gat06              LIKE gat_file.gat06,  #MOD-580237
            gat07              LIKE gat_file.gat07   #MOD-580237
                               END RECORD,
         g_zr_t                RECORD                # 變數舊值
            zr02               LIKE zr_file.zr02,
            zr03               LIKE zr_file.zr03,
            gat03              LIKE gat_file.gat03,
            gat06              LIKE gat_file.gat06,  #MOD-580237
            gat07              LIKE gat_file.gat07   #MOD-580237
                               END RECORD 
DEFINE   g_cnt                 LIKE type_file.num10, #No.FUN-680135 INTEGER
         g_wc                  STRING,
         g_sql                 STRING,
         g_ss                  LIKE type_file.chr1,  # 決定後續步驟 #No.FUN-680135 VARCHAR(1)
         g_rec_b               LIKE type_file.num5,  # 單身筆數     #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5   # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_msg                 LIKE type_file.chr1000#No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5   #No.FUN-680135 SMALLINT
DEFINE   g_row_count           LIKE type_file.num10, #No.FUN-680135 INTEGER
         g_curs_index          LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10, #No.FUN-680135 INTEGER
         g_no_ask              LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   g_zz011               STRING
DEFINE   g_choice              LIKE type_file.chr1   #No.FUN-680135 VARCHAR(1) #TQC-590025
DEFINE   g_i                   LIKE type_file.num5   #TQC-590025    #No.FUN-680135 SMALLINT
 
MAIN
   DEFINE   l_gao01            LIKE gao_file.gao01
 
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
 
   CALL cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
        RETURNING g_time    #No.FUN-6A0096
 
   LET g_zr01_t = NULL
 
   OPEN WINDOW p_zr_w WITH FORM "azz/42f/p_zr"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from zr_file  WHERE zr01 = ?",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zr_cl CURSOR FROM g_forupd_sql
 
#   #-----指定combo zz011的值-------------#
#   LET g_zz011=""
#   DECLARE p_zz011_cur CURSOR FOR SELECT gao01 FROM gao_file ORDER BY gao01
#   FOREACH p_zz011_cur INTO l_gao01
#      IF cl_null(g_zz011) THEN
#         LET g_zz011=l_gao01
#      ELSE
#         LET g_zz011=g_zz011 CLIPPED,",",l_gao01 CLIPPED
#      END IF
#   END FOREACH
#
#   LET g_zz011 = g_zz011 CLIPPED,",MENU"
#
#   CALL cl_set_combo_items("gat03",g_zz011,g_zz011)
#   #-------------------------------------#
   
   CALL p_zr_menu() 
 
   CLOSE WINDOW p_zr_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
        RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_zr_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_zr.clear()
 
   CONSTRUCT g_wc ON zr01,zr02,zr03
                FROM zr01,s_zr[1].zr02,s_zr[1].zr03
 
      ON IDLE g_idle_seconds  #FUN-860033
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql= "SELECT UNIQUE zr01 FROM zr_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zr01"
 
   PREPARE p_zr_prepare FROM g_sql          # 預備一下
   DECLARE p_zr_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_zr_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT zr01) FROM zr_file ",
               " WHERE ",g_wc CLIPPED
 
   PREPARE p_zr_precount FROM g_sql
   DECLARE p_zr_count CURSOR FOR p_zr_precount
END FUNCTION
 
FUNCTION p_zr_menu()
 
   DEFINE lc_cmd  STRING
 
   WHILE TRUE
      CALL p_zr_bp("G")
      CASE g_action_choice
 
#         WHEN "insert"                          # A.輸入
#            IF cl_chk_act_auth() THEN
#               CALL p_zr_a()
#            END IF
 
#         WHEN "delete"                          # R.取消
#            IF cl_chk_act_auth() THEN
#               CALL p_zr_r()
#            END IF
 
          WHEN "output"                          #TQC-590025
             IF cl_chk_act_auth() THEN
                LET g_choice = 0
                MENU "" ATTRIBUTE(STYLE="popup")
                   ON ACTION zr_prog_tab
                      LET g_choice = 1
                   ON ACTION zr_tab_prog
                      LET g_choice = 2
                END MENU
                IF g_choice MATCHES '[12]' THEN
                   CALL p_zr_out()
                END IF
             END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_zr_q()
            ELSE
               LET g_curs_index = 0
            END IF
 
#         WHEN "detail"
#            IF cl_chk_act_auth() THEN
#               CALL p_zr_b()
#            ELSE
#               LET g_action_choice = NULL
#            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zr),'','')
            END IF
 
         WHEN "redo_getzr"        #FUN-570274
            IF cl_chk_act_auth() AND NOT cl_null(g_zr01) THEN
               CALL cl_wait()
               LET lc_cmd = 'p_get_zr "' || g_zr01 CLIPPED || '" '
               CALL cl_cmdrun_unset_lang_wait(lc_cmd)
               MESSAGE ""
               CALL cl_end(20,30)
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_zr_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_zr.clear()
 
   INITIALIZE g_zr01 LIKE zr_file.zr01         # 預設值及將數值類變數清成零
   INITIALIZE g_gaz03 TO NULL
   LET g_zr01_t = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_zr_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_zr.clear()
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_zr.clear()
      ELSE
         CALL p_zr_b_fill('1=1')             # 單身
      END IF
 
      CALL p_zr_b()                          # 輸入單身
      LET g_zr01_t=g_zr01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_zr_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd   LIKE type_file.chr1      # a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
 
   LET g_ss = 'N'
   DISPLAY g_zr01 TO zr01
   INPUT g_zr01 WITHOUT DEFAULTS FROM zr01
 
      AFTER FIELD zr01                         
         IF NOT cl_null(g_zr01) THEN
            IF g_zr01 != g_zr01_t OR cl_null(g_zr01_t) THEN
               LET g_cnt = 0
               SELECT COUNT(UNIQUE zr01) INTO g_cnt FROM zr_file
                WHERE zr01 = g_zr01
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                     CALL p_zr_desc()
                  ELSE
                     NEXT FIELD zr01
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_zr01,-239,0)
                     LET g_zr01 = g_zr01_t
                     NEXT FIELD zr01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_zr01,g_errno,0)
                  NEXT FIELD zr01
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
   END INPUT
END FUNCTION
 
FUNCTION p_zr_q()                            #Query 查詢
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   CALL g_zr.clear()
   DISPLAY '    ' TO FORMONLY.cnt
   CALL p_zr_curs()                          #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_zr_b_curs                          #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                     #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_zr01,g_gaz03 TO NULL
   ELSE
      CALL p_zr_fetch('F')                   #讀出TEMP第一筆並顯示
      OPEN p_zr_count
      FETCH p_zr_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
FUNCTION p_zr_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1     #處理方式    #No.FUN-680135 VARCHAR(1) 
   
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_zr_b_curs INTO g_zr01 
      WHEN 'P' FETCH PREVIOUS p_zr_b_curs INTO g_zr01
      WHEN 'F' FETCH FIRST    p_zr_b_curs INTO g_zr01
      WHEN 'L' FETCH LAST     p_zr_b_curs INTO g_zr01
      WHEN '/' 
         IF (NOT g_no_ask) THEN              #No.FUN-6A0080
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
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_zr_b_curs INTO g_zr01
         LET g_no_ask = FALSE               #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zr01,SQLCA.sqlcode,0)
      INITIALIZE g_zr01 TO NULL  #TQC-6B0105
      LET g_zr01 = NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL p_zr_show()
   END IF
END FUNCTION
 
FUNCTION p_zr_show()                         # 將資料顯示在畫面上
   DISPLAY g_zr01 TO zr01                    # 假單頭
   CALL p_zr_desc()
   CALL p_zr_b_fill(g_wc)                    # 單身
END FUNCTION
 
FUNCTION p_zr_r()                            # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,     #No.FUN-680135 SMALLINT
            l_zr    RECORD LIKE zr_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zr01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   
   OPEN p_zr_cl USING g_zr01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_zr_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_zr_cl INTO g_zr_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zr01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_zr_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM zr_file WHERE zr01 = g_zr01
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","zr_file",g_zr01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      ELSE
         OPEN p_zr_count
         IF STATUS THEN
            CLOSE p_zr_count
         ELSE
            FETCH p_zr_count INTO g_row_count
            IF SQLCA.sqlcode THEN
               CLOSE p_zr_count
            ELSE
               DISPLAY g_row_count TO FORMONLY.cnt
               OPEN p_zr_b_curs
               IF g_curs_index = g_row_count + 1 THEN
                  LET g_jump = g_row_count
                  CALL p_zr_fetch('L')
               ELSE
                  LET g_jump = g_curs_index
                  LET g_no_ask = TRUE          #No.FUN-6A0080
                  CALL p_zr_fetch('/')
               END IF
            END IF
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zr_b()                                    # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,     # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,     # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,     # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,     # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,     #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5      #No.FUN-680135      SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zr01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= " SELECT zr02,zr03,'','','' ",
                       " FROM zr_file",
                      "  WHERE zr01 = ? AND zr02 = ? AND zr03 = ? ",
                        " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zr_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_zr WITHOUT DEFAULTS FROM s_zr.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
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
            LET g_zr_t.* = g_zr[l_ac].*    #BACKUP
            OPEN p_zr_bcl USING g_zr01,g_zr_t.zr02,g_zr_t.zr03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_zr_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_zr_bcl INTO g_zr[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zr_t.zr02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
#                 #MOD-580237
                  SELECT gat03,gat06,gat07
                    INTO g_zr[l_ac].gat03,g_zr[l_ac].gat06,g_zr[l_ac].gat07
                    FROM gat_file
                   WHERE gat01=g_zr[l_ac].zr02 AND gat02=g_lang
                  LET g_zr[l_ac].gat06 = UPSHIFT(g_zr[l_ac].gat06)
                
#                 SELECT zta03,zta09 INTO g_zr[l_ac].zta03,g_zr[l_ac].zta09
#                   FROM zta_file
#                  WHERE zta01=g_zr[l_ac].zr02 AND zta02='ds'
#                 LET g_zr[l_ac].zta03 = UPSHIFT(g_zr[l_ac].zta03)
               END IF
            END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zr[l_ac].* TO NULL       #900423
         LET g_zr_t.* = g_zr[l_ac].*          #新輸入資料
         NEXT FIELD zr02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO zr_file(zr01,zr02,zr03)
              VALUES (g_zr01,g_zr[l_ac].zr02,g_zr[l_ac].zr03)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zr01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","zr_file",g_zr01,g_zr[l_ac].zr02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD zr02
         IF NOT cl_null(g_zr[l_ac].zr02) THEN
 
            SELECT gat03,gat06,gat07   #MOD-580237
              INTO g_zr[l_ac].gat03,g_zr[l_ac].gat06,g_zr[l_ac].gat07
              FROM gat_file
             WHERE gat01=g_zr[l_ac].zr02 AND gat02=g_lang
            LET g_zr[l_ac].gat06 = UPSHIFT(g_zr[l_ac].gat06)
 
#           SELECT zta03,zta09 INTO g_zr[l_ac].zta03,g_zr[l_ac].zta09
#             FROM zta_file
#            WHERE zta01=g_zr[l_ac].zr02 AND zta02='ds'
#           LET g_zr[l_ac].zta03 = UPSHIFT(g_zr[l_ac].zta03)
 
            IF g_zr[l_ac].zr02 != g_zr_t.zr02 OR g_zr_t.zr02 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM zr_file
                WHERE zr01 = g_zr01 AND zr02 = g_zr[l_ac].zr02
                  AND zr03 = g_zr[l_ac].zr03
               IF l_n > 0 THEN
                  CALL cl_err(g_zr[l_ac].zr02,-239,0)
                  LET g_zr[l_ac].zr02 = g_zr_t.zr02
                  NEXT FIELD zr02
               END IF
            END IF
         END IF
 
      AFTER FIELD zr03
         IF NOT cl_null(g_zr[l_ac].zr02) THEN
            IF g_zr[l_ac].zr03 != g_zr_t.zr03 OR g_zr_t.zr03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM zr_file
                WHERE zr01 = g_zr01 AND zr02 = g_zr[l_ac].zr02
                  AND zr03 = g_zr[l_ac].zr03
               IF l_n > 0 THEN
                  CALL cl_err(g_zr[l_ac].zr03,-239,0)
                  LET g_zr[l_ac].zr03 = g_zr_t.zr03
                  NEXT FIELD zr03
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zr_t.zr02)) AND (NOT cl_null(g_zr_t.zr03)) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM zr_file WHERE zr01 = g_zr01 AND zr02 = g_zr[l_ac].zr02
                                  AND zr03 = g_zr[l_ac].zr03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zr[l_ac].zr02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zr_file",g_zr01,g_zr_t.zr02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
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
            LET g_zr[l_ac].* = g_zr_t.*
            CLOSE p_zr_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zr[l_ac].zr02,-263,1)
            LET g_zr[l_ac].* = g_zr_t.*
         ELSE
            UPDATE zr_file
               SET zr02 = g_zr[l_ac].zr02,
                   zr03 = g_zr[l_ac].zr03
             WHERE zr01 = g_zr01 AND zr02 = g_zr_t.zr02
               AND zr03 = g_zr_t.zr03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zr[l_ac].zr02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zr_file",g_zr01,g_zr_t.zr02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zr[l_ac].* = g_zr_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zr[l_ac].* = g_zr_t.*
            END IF
            CLOSE p_zr_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE p_zr_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(zr02) AND l_ac > 1 THEN
            LET g_zr[l_ac].* = g_zr[l_ac-1].*
            NEXT FIELD zr02
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
   CLOSE p_zr_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zr_b_fill(p_wc)              #BODY FILL UP
   DEFINE   p_wc   STRING   
 
    LET g_sql = "SELECT zr02,zr03,'','','' FROM zr_file ",
                " WHERE zr01 = '",g_zr01 CLIPPED,"' ",
                  " AND ",p_wc CLIPPED,
                " ORDER BY zr02 ASC,zr03 DESC"
 
    PREPARE p_zr_prepare2 FROM g_sql           #預備一下
    DECLARE za_curs CURSOR FOR p_zr_prepare2
 
    CALL g_zr.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH za_curs INTO g_zr[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
#         #MOD-580237
          SELECT gat03,gat06,gat07
            INTO g_zr[g_cnt].gat03,g_zr[g_cnt].gat06,g_zr[g_cnt].gat07
            FROM gat_file
           WHERE gat01=g_zr[g_cnt].zr02 AND gat02=g_lang
          LET g_zr[g_cnt].gat06 = UPSHIFT(g_zr[g_cnt].gat06)
 
#         SELECT zta03,zta09 INTO g_zr[g_cnt].zta03,g_zr[g_cnt].zta09
#           FROM zta_file
#          WHERE zta01=g_zr[g_cnt].zr02 AND zta02='ds'
#         LET g_zr[g_cnt].zta03 = UPSHIFT(g_zr[g_cnt].zta03)
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zr.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_zr_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_zr TO s_zr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         INITIALIZE g_gaz03 TO NULL
         CALL p_zr_desc()
         EXIT DISPLAY
 
#      ON ACTION insert                           # A.輸入
#         LET g_action_choice="insert"
#         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
#      ON ACTION delete                           # R.取消
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#
#      ON ACTION detail                           # B.單身
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_zr_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION previous                         # P.上筆
         CALL p_zr_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION jump                             # 指定筆
         CALL p_zr_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION next                             # N.下筆
         CALL p_zr_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION last                             # 最終筆
         CALL p_zr_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION output                           #TQC-590025
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION redo_getzr    #FUN-570274
         LET g_action_choice = "redo_getzr"
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_zr_desc()
  
   CALL cl_get_progname(g_zr01,g_lang) RETURNING g_gaz03
 
   DISPLAY g_gaz03 TO FORMONLY.gaz03
 
END FUNCTION
 
 
FUNCTION p_zr_out()   #TQC-590025
 
DEFINE l_i             LIKE type_file.num5,    #No.FUN-680135 SMALLINT
       l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680135 VARCHAR(20)
       l_za05          LIKE za_file.za05,      
       l_order1,l_order2 LIKE zr_file.zr01,    #No.FUN-680135 VARCHAR(10)
       sr RECORD
          zr01         LIKE zr_file.zr01,
          gaz03        LIKE gaz_file.gaz03,
          zr02         LIKE zr_file.zr02,
          gat03        LIKE gat_file.gat03,
          zr03         LIKE zr_file.zr03
          END RECORD,
       l_chr           LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
 
    CALL cl_wait()
    CALL cl_outnam('p_zr') RETURNING l_name
 
    SELECT zr02 INTO g_company FROM zr_file WHERE zr01 = g_lang
    DECLARE p_zr_za_cur CURSOR FOR
            SELECT za02,za05 FROM za_file
             WHERE za01 = "p_zr" AND za03 = g_lang
    FOREACH p_zr_za_cur INTO g_i,l_za05
       LET g_x[g_i] = l_za05
    END FOREACH
 
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'p_zr'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
    LET g_sql="SELECT zr01,gaz03,zr02,gat03,zr03",
               " FROM zr_file, gat_file, gaz_file",
              " WHERE zr02=gat01 AND zr01=gaz01 ",
                " AND gat02='",g_lang CLIPPED,"' ",
                " AND gaz02='",g_lang CLIPPED,"' ",
                " AND ",g_wc CLIPPED
 
    PREPARE p_zr_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_zr_curo                         # SCROLL CURSOR
         CURSOR FOR p_zr_p1
 
    START REPORT p_zr_rep TO l_name
 
    FOREACH p_zr_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        IF g_choice=1 THEN LET l_order1=sr.zr01 LET l_order2=sr.zr02 END IF
        IF g_choice=2 THEN LET l_order1=sr.zr02 LET l_order2=sr.zr01 END IF
        OUTPUT TO REPORT p_zr_rep(l_order1,l_order2,sr.*)
    END FOREACH
 
    FINISH REPORT p_zr_rep
 
    CLOSE p_zr_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_zr_rep(l_order1,l_order2,sr)
    DEFINE
        l_trailer_sw      LIKE type_file.chr1,   #No.FUN-680135 VARCHAR(1)
        l_order1,l_order2 LIKE zr_file.zr01,     #No.FUN-680135 VARCHAR(10)       
        sr RECORD
           zr01           LIKE zr_file.zr01,     #No.FUN-680135 VARCHAR(10)
           zz02           LIKE zz_file.zz02,     #No.FUN-680135 VARCHAR(36)
           zr02           LIKE zr_file.zr02,     #No.FUN-680135 VARCHAR(10)
           gat03          LIKE gat_file.gat03,   #No.FUN-680135 VARCHAR(36)
           zr03           LIKE zr_file.zr03      #No.FUN-680135 VARCHAR(1)
                          END RECORD,
        l_buf             LIKE type_file.chr50,  #No.FUN-680135 VARCHAR(40)
        S,I,U,D           LIKE type_file.chr20,  #No.FUN-680135 VARCHAR(7)
        j                 LIKE type_file.num5,   #No.FUN-680135 SMALLINT
        l_chr             LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH 66
 
    ORDER BY l_order1,l_order2,sr.zr03
 
    FORMAT
     PAGE HEADER
      LET l_buf=''
      IF PAGENO = 1 THEN
         CASE
         WHEN g_lang = '0'
              IF g_choice = 1 THEN LET l_buf = '5.1 程式檔案關聯表' END IF
              IF g_choice = 2 THEN LET l_buf = '4.1 檔案程式關聯表' END IF
         WHEN g_lang = '2'
              IF g_choice = 1 THEN LET l_buf = '5.1 程式檔案關聯表' END IF
              IF g_choice = 2 THEN LET l_buf = '4.1 檔案程式關聯表' END IF
         OTHERWISE
         IF g_choice = 1 THEN LET l_buf = '5.1 PROGRAM/FILE CROSS LIST'END IF
         IF g_choice = 2 THEN LET l_buf = '4.1 FILE/PROGRAM CROSS LIST' END IF
         END CASE
      END IF
      PRINT l_buf
      PRINT
            IF g_lang = '1' THEN
      PRINT '+------------------------------------------------------------------------------+'
      IF g_choice = 1 THEN LET l_buf= 'PRG / FILE     FILE NAME'; END IF
      IF g_choice = 2 THEN LET l_buf= 'FILE/ PRG       PRG NAME'; END IF
      PRINT '| ',l_buf CLIPPED, COLUMN 55,'Select Insert Update Del |'
      PRINT '+------------------------------------------------------------------------------+'
            ELSE
                    IF g_lang = '2' THEN
      PRINT '┌──────────────────────────────────────┐'
      IF g_choice = 1 THEN LET l_buf= '程式/ 檔案編號  檔案名稱'; END IF
      IF g_choice = 2 THEN LET l_buf= '檔案/ 程式編號  程式名稱'; END IF
      PRINT '│',l_buf CLIPPED, COLUMN 55,'Select Insert Update Del│'
      PRINT '├──────────────────────────────────────┤'
                    ELSE
      PRINT '┌──────────────────────────────────────┐'
      IF g_choice = 1 THEN LET l_buf= '程式/ 檔案編號  檔案名稱'; END IF
      IF g_choice = 2 THEN LET l_buf= '檔案/ 程式編號  程式名稱'; END IF
      PRINT '│',l_buf CLIPPED, COLUMN 55,'Select Insert Update Del│'
      PRINT '├──────────────────────────────────────┤'
                    END IF
            END IF
      LET l_trailer_sw = 'y'
 
     BEFORE GROUP OF l_order1
             IF g_lang = '1' THEN
      IF g_choice = '1' THEN PRINT '| ',sr.zr01 CLIPPED,COLUMN 19,sr.zz02 CLIPPED,COLUMN 79,' |' END IF  #No.FUN-6C0011
      IF g_choice = '2' THEN PRINT '| ',sr.zr02 CLIPPED,COLUMN 19,sr.gat03 CLIPPED,COLUMN 79,' |' END IF  #No.FUN-6C0011
         PRINT '| ',COLUMN 79,' |'
             ELSE
      IF g_choice = '1' THEN PRINT '│',sr.zr01 CLIPPED,COLUMN 19,sr.zz02 CLIPPED,COLUMN 79,'│' END IF  #No.FUN-6C0011
      IF g_choice = '2' THEN PRINT '│',sr.zr02 CLIPPED,COLUMN 19,sr.gat03 CLIPPED,COLUMN 79,'│' END IF  #No.FUN-6C0011
         PRINT '│',COLUMN 79,'│'
             END IF
 
     BEFORE GROUP OF l_order2
             IF g_lang = '1' THEN
      IF g_choice = '1' THEN PRINT '| ',COLUMN 9, sr.zr02 CLIPPED,COLUMN 19,sr.gat03 CLIPPED; END IF  #No.FUN-6C0011
      IF g_choice = '2' THEN PRINT '| ',COLUMN 9, sr.zr01 CLIPPED,COLUMN 19,sr.zz02 CLIPPED; END IF  #No.FUN-6C0011
             ELSE
      IF g_choice = '1' THEN PRINT '│',COLUMN 9, sr.zr02 CLIPPED,COLUMN 19,sr.gat03 CLIPPED; END IF  #No.FUN-6C0011
      IF g_choice = '2' THEN PRINT '│',COLUMN 9, sr.zr01 CLIPPED,COLUMN 19,sr.zz02 CLIPPED; END IF  #No.FUN-6C0011
             END IF
      LET S='' LET I='' LET U='' LET D=''
     ON EVERY ROW
      CASE sr.zr03
         WHEN "S" LET S="Select"
         WHEN "I" LET I="Insert"
         WHEN "U" LET U="Update"
         WHEN "D" LET D="Del"
      END CASE
     AFTER GROUP OF l_order2
                IF g_lang = '1' THEN
      PRINT COLUMN 55,S CLIPPED, COLUMN 62,I CLIPPED,COLUMN 69,U CLIPPED,COLUMN 76,D CLIPPED,COLUMN 79,' |'  #No.FUN-6C0011
                ELSE
      PRINT COLUMN 55,S CLIPPED,COLUMN 62,I CLIPPED,COLUMN 69,U CLIPPED,COLUMN 76,D CLIPPED,COLUMN 79,'│'   #No.FUN-6C0011
                END IF
     AFTER GROUP OF l_order1
                IF g_lang ='1' THEN
      IF LINENO <= 6 OR LINENO >= 55
         THEN PRINT '| ',COLUMN 79,' |'
         ELSE PRINT '+------------------------------------------------------------------------------+'
      END IF
                ELSE
      IF LINENO <= 6 OR LINENO >= 55
         THEN PRINT '│',COLUMN 79,'│'
         ELSE PRINT '├──────────────────────────────────────┤'
      END IF
                END IF
     ON LAST ROW
      FOR j = LINENO TO 55
                IF g_lang = '1' THEN
         PRINT '| ',COLUMN 79,' |'
                ELSE
         PRINT '│',COLUMN 79,'│'
                END IF
      END FOR
     PAGE TRAILER
                IF g_lang = '1' THEN
      PRINT '+------------------------------------------------------------------------------+'
                ELSE
      PRINT '└──────────────────────────────────────┘'
                END IF
      IF g_choice = '1' THEN LET l_buf = '5-1-',PAGENO USING '<<<<' END IF
      IF g_choice = '2' THEN LET l_buf = '4-1-',PAGENO USING '<<<<' END IF
END REPORT
 
