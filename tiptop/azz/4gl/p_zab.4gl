# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: p_zab
# Descriptions...: 報表備註維護程式
# Date & Author..: 04/12/02 echo  
# Modify.........: No.MOD-560086 05/06/14 By echo 修改controlf欄位說明
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0097 06/11/30 By Smapmin 筆數顯示有誤
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zab01                LIKE zab_file.zab01,   # 程式代碼 
         g_zab01_t              LIKE zab_file.zab01,   # 程式代碼
         g_zab02                LIKE zab_file.zab02,   # 程式名稱
         g_zab02_t              LIKE zab_file.zab02,   # 程式名稱
         g_zab_lock             RECORD LIKE zab_file.*,
         g_zab                  DYNAMIC ARRAY of RECORD        
            zab03               LIKE zab_file.zab03,
            zab04               LIKE zab_file.zab04,
            zab05               LIKE zab_file.zab05
                                END RECORD,
         g_zab_t                RECORD                 # 變數舊值
            zab03               LIKE zab_file.zab03,
            zab04               LIKE zab_file.zab04,
            zab05               LIKE zab_file.zab05
                                END RECORD 
DEFINE   g_cnt                 LIKE type_file.num10,   #No.FUN-680135 INTEGER
         g_cnt2                LIKE type_file.num10,   #No.FUN-680135 INTEGER
         g_wc                  string,                 #No.FUN-580092 HCN
         g_sql                 string,                 #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,    # 決定後續步驟 #No.FUN-680135 VARCHAR(1)
         g_rec_b               LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_row_count           LIKE type_file.num10,   #No.FUN-580092 HCN      #No.FUN-680135 INTEGER
         mi_curs_index         LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   mi_jump               LIKE type_file.num10,   #No.FUN-680135 INTEGER
         mi_no_ask             LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_n                   LIKE type_file.num10    #No.FUN-680135 INTEGER 
 
 
MAIN
   DEFINE   p_row,p_col        LIKE type_file.num5     #No.FUN-680135 SMALLINT 
#     DEFINE   l_time   LIKE type_file.chr8                 #No.FUN-6A0096
 
   OPTIONS                                             # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                                  # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET g_zab01_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW p_zab_w AT p_row,p_col WITH FORM "azz/42f/p_zab"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   CALL cl_set_combo_lang("zab04")
 
   LET g_forupd_sql = "SELECT * from zab_file  WHERE zab01 = ? ",
##coco 2005/02/17
                      " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zab_cl CURSOR FROM g_forupd_sql
   
   CALL p_zab_menu() 
 
   CLOSE WINDOW p_zab_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_zab_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_zab.clear()
 
   CONSTRUCT g_wc ON zab01,zab02,zab03,zab04,zab05
        FROM zab01,zab02,s_zab[1].zab03,s_zab[1].zab04,s_zab[1].zab05
#TQC-860017 start
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
   END CONSTRUCT 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#TQC-860017 end  
 
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql= "SELECT UNIQUE zab01,zab02 FROM zab_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zab01"
 
   PREPARE p_zab_prepare FROM g_sql          # 預備一下
   DECLARE p_zab_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_zab_prepare
 
END FUNCTION
 
FUNCTION p_zab_count()
 
   LET g_sql= "SELECT UNIQUE zab01 FROM zab_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zab01"
 
   PREPARE p_zab_precount FROM g_sql
   DECLARE p_zab_count CURSOR FOR p_zab_precount
   LET g_cnt=1
   LET g_rec_b=0
   FOREACH p_zab_count
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET g_rec_b = g_rec_b - 1
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
    END FOREACH
     LET g_row_count=g_rec_b #No.FUN-580092 HCN
END FUNCTION
 
FUNCTION p_zab_menu()
 
   WHILE TRUE
      CALL p_zab_bp("G")
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_zab_a()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_zab_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_zab_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_zab_q()
            ELSE
               LET mi_curs_index = 0
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_zab_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL p_zab_u()
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_zab_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_zab.clear()
 
   INITIALIZE g_zab01 LIKE zab_file.zab01         # 預設值及將數值類變數清成零
   INITIALIZE g_zab02 LIKE zab_file.zab02         # 預設值及將數值類變數清成零
   LET g_zab01_t = NULL
   LET g_zab02_t = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_zab_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_zab01=NULL
         LET g_zab02=NULL
         DISPLAY g_zab01 TO zab01
         DISPLAY g_zab02 TO zab02
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_zab.clear()
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_zab.clear()
      ELSE
         CALL p_zab_b_fill('1=1')             # 單身
      END IF
 
      CALL p_zab_b()                          # 輸入單身
      LET g_zab01_t=g_zab01
      LET g_zab02_t=g_zab02
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION p_zab_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_zab01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zab01_t = g_zab01
   LET g_zab02_t = g_zab02
 
   BEGIN WORK
   OPEN p_zab_cl USING g_zab01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_zab_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_zab_cl INTO g_zab_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zab01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_zab_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL p_zab_i("u")
      IF INT_FLAG THEN
         LET g_zab01 = g_zab01_t
         LET g_zab02 = g_zab02_t
         DISPLAY g_zab01,g_zab02 
              TO zab01,zab02 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE zab_file SET zab01 = g_zab01, zab02 = g_zab02
       WHERE zab01 = g_zab01_t 
 
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_zab01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","zab_file",g_zab01_t,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
         CONTINUE WHILE
      END IF
      OPEN p_zab_b_curs                       #從DB產生合乎條件TEMP(0-30秒)
      LET mi_jump = mi_curs_index
      LET mi_no_ask = TRUE
      CALL p_zab_fetch('/')
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zab_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd   LIKE type_file.chr1       # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
 
   LET g_ss = 'N'
   DISPLAY g_zab01 TO zab01
   DISPLAY g_zab02 TO zab02
   INPUT g_zab01,g_zab02 WITHOUT DEFAULTS FROM zab01,zab02
      
 
      AFTER FIELD zab01                         
         IF NOT cl_null(g_zab01) THEN
            IF g_zab01 != g_zab01_t OR cl_null(g_zab01_t) THEN
               SELECT COUNT(UNIQUE zab01) INTO g_cnt FROM zab_file
                WHERE zab01 = g_zab01
               IF g_cnt > 0  THEN
                   CALL cl_err(g_zab01,'-239',1)
                   LET g_zab01 = g_zab01_t
                   NEXT FIELD zab01
               END IF
            END IF
         END IF
 
      AFTER INPUT
           IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
           END IF
 
       ON ACTION CONTROLF                       #MOD-560086
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
 
FUNCTION p_zab_q()                            #Query 查詢
    LET g_row_count = 0 #No.FUN-580092 HCN
   LET mi_curs_index = 0
    CALL cl_navigator_setting(mi_curs_index,g_row_count) #No.FUN-580092 HCN
   MESSAGE ""
  #CLEAR FROM   #NO.TQC-740075
   CLEAR FORM   #NO.TQC-740075
   CALL g_zab.clear()
   DISPLAY '    ' TO FORMONLY.cnt
   CALL p_zab_curs()                         #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_zab_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                     #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_zab01,g_zab02 TO NULL
   ELSE
      CALL p_zab_count()
      DISPLAY g_row_count TO FORMONLY.cnt   #FUN-6B0097
      CALL p_zab_fetch('F')                  #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p_zab_fetch(p_flag)                 #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1     #處理方式  #No.FUN-680135 VARCHAR(1) 
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_zab_b_curs INTO g_zab01,g_zab02
      WHEN 'P' FETCH PREVIOUS p_zab_b_curs INTO g_zab01,g_zab02
      WHEN 'F' FETCH FIRST    p_zab_b_curs INTO g_zab01,g_zab02
      WHEN 'L' FETCH LAST     p_zab_b_curs INTO g_zab01,g_zab02
      WHEN '/' 
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR mi_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE mi_jump p_zab_b_curs INTO g_zab01,g_zab02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zab01,SQLCA.sqlcode,0)
      LET g_zab01 = NULL
      LET g_zab02 = NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
          WHEN 'L' LET mi_curs_index = g_row_count #No.FUN-580092 HCN
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE
 
       CALL cl_navigator_setting(mi_curs_index, g_row_count) #No.FUN-580092 HCN
      CALL p_zab_show()
   END IF
END FUNCTION
 
FUNCTION p_zab_show()                         # 將資料顯示在畫面上
   LET g_zab01_t = g_zab01
   LET g_zab02_t = g_zab02
   DISPLAY g_zab01 TO zab01                    # 假單頭
   DISPLAY g_zab02 TO zab02                    # 假單頭
   CALL p_zab_b_fill(g_wc)                    # 單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_zab_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE  l_zab    RECORD LIKE zab_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zab01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
  
   OPEN p_zab_cl USING g_zab01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_zab_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_zab_cl INTO g_zab_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zab01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_zab_cl
      ROLLBACK WORK
      RETURN
   END IF
 
      IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM zab_file WHERE zab01 = g_zab01  
         IF SQLCA.sqlcode THEN
            #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("del","zab_file",g_zab01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         ELSE
            CLEAR FORM
            CALL g_zab.clear()
            CALL p_zab_count()
#FUN-B50065------begin---
            IF cl_null(g_row_count) OR g_row_count=0 THEN
               CLOSE p_zab_cl
               COMMIT WORK
               RETURN
            END IF
#FUN-B50065------end----
             DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
            OPEN p_zab_b_curs
             IF mi_curs_index = g_row_count + 1 THEN #No.FUN-580092 HCN
                LET mi_jump = g_row_count #No.FUN-580092 HCN
               CALL p_zab_fetch('L')
            ELSE
               LET mi_jump = mi_curs_index
               LET mi_no_ask = TRUE
               CALL p_zab_fetch('/')
            END IF
         END IF
      END IF
#   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zab_b()                                  # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,    # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,    # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,    # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,    # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,    #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5     #No.FUN-680135      SMALLINT
   DEFINE   k,i             LIKE type_file.num10    #No.FUN-680135      INTEGER
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zab01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zab03,zab04,zab05 FROM zab_file",
                     "  WHERE zab01 = ? AND zab03 = ? AND zab04 = ? ",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zab_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_zab WITHOUT DEFAULTS FROM s_zab.*
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
            LET g_zab_t.* = g_zab[l_ac].*    #BACKUP
            OPEN p_zab_bcl USING g_zab01,g_zab[l_ac].zab03,g_zab[l_ac].zab04
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_zab_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_zab_bcl INTO g_zab[l_ac].zab03,g_zab[l_ac].zab04,g_zab[l_ac].zab05
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zab01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zab[l_ac].* TO NULL       #900423
         LET g_zab_t.* = g_zab[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD zab03
 
      AFTER FIELD zab03
         IF NOT cl_null(g_zab[l_ac].zab03) THEN
          IF g_zab[l_ac].zab03 != g_zab_t.zab03 OR g_zab_t.zab03 IS NULL THEN
             IF NOT cl_null(g_zab[l_ac].zab04) THEN
                 SELECT COUNT(*) INTO g_cnt FROM zab_file 
                     where zab01=g_zab01 AND zab03 = g_zab[l_ac].zab03 
                       AND zab04=g_zab[l_ac].zab04
                 IF g_cnt > 0 THEN
                         CALL cl_err(g_zab[l_ac].zab03,-239,1)
                         LET g_zab[l_ac].zab03 = g_zab_t.zab03
                         NEXT FIELD zab03
                 END IF 
             END IF
           END IF
          END IF
 
      AFTER FIELD zab04 
         IF NOT cl_null(g_zab[l_ac].zab04) THEN
           IF g_zab[l_ac].zab04 != g_zab_t.zab04 OR g_zab_t.zab04 IS NULL THEN
             SELECT COUNT(*) INTO g_cnt FROM zab_file 
                 where zab01=g_zab01 AND zab03 = g_zab[l_ac].zab03 
                   AND zab04=g_zab[l_ac].zab04
             IF g_cnt > 0 THEN
                     CALL cl_err(g_zab[l_ac].zab04,-239,1)
                     LET g_zab[l_ac].zab04 = g_zab_t.zab04
                     NEXT FIELD zab04
             END IF 
           END IF
          ELSE
             NEXT FIELD zab04
          END IF
       
      ON ROW CHANGE
        IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zab[l_ac].* = g_zab_t.*
            CLOSE p_zab_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF g_zab_t.zab03 != g_zab[l_ac].zab03 OR 
            g_zab_t.zab04 != g_zab[l_ac].zab04 THEN
            SELECT COUNT(*) INTO g_cnt FROM zab_file 
               where zab01=g_zab01 AND zab03 = g_zab[l_ac].zab03 
               AND zab04=g_zab[l_ac].zab04
            IF g_cnt > 0 THEN
                 CALL cl_err(g_zab01,-239,1)
                 LET g_zab[l_ac].* = g_zab_t.*
                 NEXT FIELD zab03
            END IF 
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zab[l_ac].zab03,-263,1)
            LET g_zab[l_ac].* = g_zab_t.*
         ELSE
            UPDATE zab_file
               SET zab03 = g_zab[l_ac].zab03,
                   zab04 = g_zab[l_ac].zab04,
                   zab05 = g_zab[l_ac].zab05
             WHERE zab01 = g_zab01 AND zab03 = g_zab_t.zab03
               AND zab04 = g_zab_t.zab04
 
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zab[l_ac].zab03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zab_file",g_zab01,g_zab_t.zab03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zab[l_ac].* = g_zab_t.*
               NEXT FIELD zaa03
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      BEFORE DELETE#是否取消單身
         IF (NOT cl_null(g_zab_t.zab03)) AND (NOT cl_null(g_zab_t.zab04)) THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
           END IF
           DELETE FROM zab_file WHERE zab01 = g_zab01 
              AND zab03 = g_zab[l_ac].zab03 AND zab04 = g_zab[l_ac].zab04
           IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zab[l_ac].zab03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zab_file",g_zab01,g_zab_t.zab03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            COMMIT WORK
          END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO zab_file(zab01,zab02,zab03,zab04,zab05)
             VALUES (g_zab01,g_zab02,g_zab[l_ac].zab03,g_zab[l_ac].zab04,g_zab[l_ac].zab05)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zab01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","zab_file",g_zab01,g_zab[l_ac].zab03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zab[l_ac].* = g_zab_t.*
            END IF
            CLOSE p_zab_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE p_zab_bcl
         COMMIT WORK
 
     AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30034 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zab[l_ac].* = g_zab_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_zab.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end-- 
            END IF
            CLOSE p_zab_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30034 Add
         CLOSE p_zab_bcl
         COMMIT WORK
 
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
       ON ACTION CONTROLF                       #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   CLOSE p_zab_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zab_b_fill(p_wc)              #BODY FILL UP
   DEFINE   p_wc   LIKE type_file.chr1000#No.FUN-680135 VARCHAR(300)
  #  IF g_zab04='default' THEN
  #     LET g_sql = "SELECT zab09,zab02,zab03,zab14,zab05,zab06,zab15,zab07,zab08 ",
  #                 "  FROM zab_file ",
  #                 " WHERE zab01 = '",g_zab01 CLIPPED,"' ",
  #                 "   AND zab04 = '",g_zab04 CLIPPED,"' ",
  #                 "   AND ",p_wc CLIPPED,
  #                 " ORDER BY zab02,zab03"
  #  ELSE
     LET g_sql = "SELECT zab03,zab04,zab05",
                   "  FROM zab_file ",
                   " WHERE zab01 = '",g_zab01 CLIPPED,"' ",
                   "   AND ",p_wc CLIPPED,
                   " ORDER BY zab03"
  #  ENd IF
 
    PREPARE p_zab_prepare3 FROM g_sql           #預備一下
    DECLARE zab_curs3 CURSOR FOR p_zab_prepare3
 
    CALL g_zab.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH zab_curs3 INTO g_zab[g_cnt].zab03,g_zab[g_cnt].zab04,g_zab[g_cnt].zab05
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
    CALL g_zab.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_zab_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_zab TO s_zab.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
          CALL cl_navigator_setting(mi_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_combo_lang("zab04")
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
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
         CALL p_zab_fetch('F')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous                         # P.上筆
         CALL p_zab_fetch('P')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump                             # 指定筆
         CALL p_zab_fetch('/')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next                             # N.下筆
         CALL p_zab_fetch('N')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last                             # 最終筆
         CALL p_zab_fetch('L')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_zab_copy()
   DEFINE   l_n        LIKE type_file.num5,      #No.FUN-680135 SMALLINT
            l_newfe    LIKE zab_file.zab01,
            l_oldfe    LIKE zab_file.zab01,
            l_newfe2   LIKE zab_file.zab02,
            l_oldfe2   LIKE zab_file.zab02
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_zab01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newfe,l_newfe2
     WITHOUT DEFAULTS FROM zab01,zab02
 
      AFTER INPUT
         IF INT_FLAG THEN                            # 使用者不玩了
             EXIT INPUT
         END IF
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM zab_file
          WHERE zab01 = l_newfe
         IF g_cnt > 0  THEN
             CALL cl_err(l_newfe,-239,1)
             NEXT FIELD zab01
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
      DISPLAY g_zab01 TO zab01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM zab_file WHERE zab01 = g_zab01  
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_zab01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_zab01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET zab01 = l_newfe ,                     # 資料鍵值 
          zab02 = l_newfe2                             
   INSERT INTO zab_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      #CALL cl_err('zab:',SQLCA.SQLCODE,0)  #No.FUN-660081
      CALL cl_err3("ins","zab_file",l_newfe,l_newfe2,SQLCA.sqlcode,"","zab",0)    #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldfe = g_zab01
   LET g_zab01 = l_newfe
   CALL p_zab_b()
   #LET g_zab01 = l_oldfe  #FUN-C30027 
   #CALL p_zab_show()      #FUN-C30027 
END FUNCTION
 
