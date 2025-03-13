# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_sql.4gl
# Descriptions...: 報表連查SQL設定作業
# Date & Author..: 06/01/11 By qazzaq
# Modify.........: No.TQC-640152 06/04/18 By Alexstar Informix的SQL語法中Order by 段不可以用select段中沒有篩選出來的欄位作排序
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成mi_no_ask 
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/22 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"            
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A90024 10/11/15 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zae01          LIKE zae_file.zae01,   # 類別代號 (假單頭)
         g_zae01_t        LIKE zae_file.zae01,   # 類別代號 (假單頭)
         g_zae02          LIKE zae_file.zae02,   # 類別代號 (假單頭)
         g_zae02_t        LIKE zae_file.zae02,   # 類別代號 (假單頭)
         g_zae03          LIKE zae_file.zae03,   # 類別代號 (假單頭)
         g_zae03_t        LIKE zae_file.zae03,   # 類別代號 (假單頭)
         g_zae_lock RECORD LIKE zae_file.*,      # FOR LOCK CURSOR TOUCH
         g_zae    DYNAMIC ARRAY of RECORD        # 程式變數
            zae04          LIKE zae_file.zae04,
            zae05          LIKE zae_file.zae05,
            zae06          LIKE zae_file.zae06,
            zae07          LIKE zae_file.zae07,
            zae08          LIKE zae_file.zae08,
            zae09          LIKE zae_file.zae09,
            zae10          LIKE zae_file.zae10,
            text           LIKE gaz_file.gaz03  #程式名稱的欄位,因為較zae02大,故採用之
                      END RECORD,
         g_zae_t           RECORD               # 變數舊值
            zae04          LIKE zae_file.zae04,
            zae05          LIKE zae_file.zae05,
            zae06          LIKE zae_file.zae06,
            zae07          LIKE zae_file.zae07,
            zae08          LIKE zae_file.zae08,
            zae09          LIKE zae_file.zae09,
            zae10          LIKE zae_file.zae10,
            text           LIKE gaz_file.gaz03
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #No.FUN-680135 SMALLINT
         g_wc                  string, 
         g_sql                 string,
#        g_ss                  VARCHAR(01),               # 決定後續步驟
         g_rec_b               LIKE type_file.num5,    # 單身筆數             #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_chr                 LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE zae_file.zae01
DEFINE   g_argv2               LIKE zae_file.zae02
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_row_count           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   mi_no_ask             LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   g_db_type             LIKE type_file.chr3     #No.FUN-680135 VARCHAR(3)
 
 
MAIN
DEFINE   p_row,p_col   LIKE type_file.num5        #No.FUN-680135   SMALLINT 
#     DEFINEl_time   LIKE type_file.chr8            #No.FUN-6A0096
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間)   #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET g_zae01_t = NULL
   LET g_zae02_t = NULL
   LET g_zae03_t = NULL
   LET g_db_type=cl_db_get_database_type()
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW p_sql_w AT p_row,p_col WITH FORM "azz/42f/p_sql"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("zae05")
 
   LET g_forupd_sql = "SELECT * from zae_file ",
                      " WHERE zae01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_sql_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_sql_q()
   END IF
 
   CALL p_sql_menu() 
 
   CLOSE WINDOW p_sql_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間)   #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_sql_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_zae.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "zae01 = '",g_argv1 CLIPPED,"' "
   ELSE
      CALL cl_set_head_visible("grid01,grid02","YES")   #No.FUN-6A0092
      CONSTRUCT g_wc ON zae01,zae02
                   FROM zae01,zae02
 
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE zae01,zae02,zae03 FROM zae_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zae01"
   PREPARE p_sql_prepare FROM g_sql          # 預備一下
   DECLARE p_sql_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_sql_prepare
 
END FUNCTION
 
FUNCTION p_sql_count()
 
   DEFINE la_zae   DYNAMIC ARRAY of RECORD        # 程式變數
            zae01          LIKE zae_file.zae01,
            zae02          LIKE zae_file.zae02,
            zae03          LIKE zae_file.zae03
                   END RECORD
 
   LET g_sql= "SELECT COUNT(UNIQUE zae01) FROM zae_file ",
              " WHERE ", g_wc CLIPPED
#             " ORDER BY zae01"    #TQC-640152
 
   PREPARE p_sql_precount FROM g_sql
   EXECUTE p_sql_precount INTO g_row_count
#   DECLARE p_sql_count CURSOR FOR p_sql_precount
#   LET g_row_count=li_rec_b
 
END FUNCTION
 
FUNCTION p_sql_menu()
 
   WHILE TRUE
      CALL p_sql_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_sql_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_sql_u()
            END IF
#         WHEN "reproduce"                       # C.複製
#            IF cl_chk_act_auth() THEN
#               CALL p_sql_copy()
#            END IF
        WHEN "delete"                          # R.取消
           IF cl_chk_act_auth() THEN
              CALL p_sql_r()
           END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_sql_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_sql_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zae),'','')
            END IF
 
          WHEN "showlog"         
            IF cl_chk_act_auth() THEN
               CALL cl_show_log("p_sql")
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_sql_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_zae.clear()
 
   INITIALIZE g_zae01 LIKE zae_file.zae01         # 預設值及將數值類變數清成零
   INITIALIZE g_zae02 LIKE zae_file.zae02
   INITIALIZE g_zae03 LIKE zae_file.zae03         # 預設值及將數值類變數清成零
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_sql_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_zae01=NULL
         LET g_zae02=NULL
         LET g_zae03=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
#      IF g_ss='N' THEN
#         CALL g_zae.clear()
#      ELSE
#      END IF
 
      CALL p_sql_parse_sql()
--      CALL p_sql_show()
      CALL p_sql_b_fill('1=1')                  # 單身
      CALL cl_show_fld_cont()  
      CALL p_sql_b()                            # 輸入單身
      LET g_zae01_t=g_zae01
      LET g_zae02_t=g_zae02
      LET g_zae03_t=g_zae03
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_sql_i(p_cmd)                         # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
   DEFINE   l_count      LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
 
   DISPLAY g_zae01,g_zae02,g_zae03 TO zae01,zae02,zae03
   CALL cl_set_head_visible("grid01,grid02","YES")   #No.FUN-6A0092
   INPUT g_zae01,g_zae02,g_zae03 WITHOUT DEFAULTS FROM zae01,zae02,zae03
 
      AFTER FIELD zae01
          IF p_cmd='a' OR (p_cmd='u' AND g_zae01!=g_zae01_t) THEN
             SELECT count(zae01) INTO l_count
               FROM zae_file
              WHERE zae01=g_zae01
             IF l_count>0 THEN
                CALL cl_err(g_zae01,'-239',0)
                NEXT FIELD zae01
             END IF
          END IF
 
{      AFTER INPUT
         IF NOT cl_null(g_zae01) THEN
            IF g_zae01 != g_zae01_t OR cl_null(g_zae01_t) THEN
               SELECT COUNT(UNIQUE zae01) INTO g_cnt FROM zae_file
                WHERE zae01 = g_zae01 
               IF g_cnt <= 0 THEN
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_zae01,-239,0)
                     LET g_zae01 = g_zae01_t
                     NEXT FIELD zae01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_zae01,g_errno,0)
                  NEXT FIELD zae01
               END IF
            END IF
         END IF
}
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
 
 
FUNCTION p_sql_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_zae01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zae01_t = g_zae01
   LET g_zae02_t = g_zae02
   LET g_zae03_t = g_zae03
 
   BEGIN WORK
   OPEN p_sql_lock_u USING g_zae01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_sql_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_sql_lock_u INTO g_zae_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zae01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_sql_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL p_sql_i("u")
      IF INT_FLAG THEN
         LET g_zae01 = g_zae01_t
         LET g_zae02 = g_zae02_t
         LET g_zae03 = g_zae03_t
         DISPLAY g_zae01,g_zae02,g_zae03 TO zae01,zae02,zae03
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE zae_file SET zae01=g_zae01,
                          zae02=g_zae02,
                          zae03=g_zae03
       WHERE zae01 = g_zae01_t
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_zae01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","zae_file",g_zae01_t,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_sql_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   CALL g_zae.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_sql_curs()                          #取得查詢條件
   IF INT_FLAG THEN                           #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_sql_b_curs                          #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                      #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_zae01 TO NULL
      INITIALIZE g_zae02 TO NULL
      INITIALIZE g_zae03 TO NULL
   ELSE
#     OPEN p_sql_count
#     FETCH p_sql_count INTO g_row_count
      CALL p_sql_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_sql_fetch('F')                   #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p_sql_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,     #處理方式       #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10     #絕對的筆數     #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_sql_b_curs INTO g_zae01,g_zae02,g_zae03
      WHEN 'P' FETCH PREVIOUS p_sql_b_curs INTO g_zae01,g_zae02,g_zae03
      WHEN 'F' FETCH FIRST    p_sql_b_curs INTO g_zae01,g_zae02,g_zae03
      WHEN 'L' FETCH LAST     p_sql_b_curs INTO g_zae01,g_zae02,g_zae03
      WHEN '/' 
         IF (NOT mi_no_ask) THEN        #No.FUN-6A0080
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
         FETCH ABSOLUTE g_jump p_sql_b_curs INTO g_zae01,g_zae02,g_zae03
         LET mi_no_ask = FALSE   #No.FUN-6A0080 
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zae01,SQLCA.sqlcode,0)
      INITIALIZE g_zae01 TO NULL  #TQC-6B0105
      INITIALIZE g_zae02 TO NULL  #TQC-6B0105
      INITIALIZE g_zae03 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL p_sql_show()
   END IF
END FUNCTION
 
#FUN-4A0088
FUNCTION p_sql_show()                         # 將資料顯示在畫面上
   DISPLAY g_zae01,g_zae02,g_zae03 TO zae01,zae02,zae03
   CALL p_sql_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()                  
END FUNCTION
 
 
FUNCTION p_sql_r()                            # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,      #No.FUN-680135 SMALLINT
            l_zae   RECORD LIKE zae_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zae01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM zae_file
       WHERE zae01 = g_zae01 
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","zae_file",g_zae01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_zae.clear()
#        OPEN p_sql_count
#        FETCH p_sql_count INTO g_row_count
         CALL p_sql_count()
#FUN-B50065------begin---
         IF cl_null(g_row_count) OR g_row_count=0 THEN
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_sql_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_sql_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE        #No.FUN-6A0080
            CALL p_sql_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_sql_b()                                 # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,   # 檢查重複用        #No.FUN-680135 SMALLINT
            l_cnt           LIKE type_file.num5,   #No.FUN-680135      SMALLINT
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,   # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
   DEFINE   l_count         LIKE type_file.num5    #No.FUN-680135      SMALLINT
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_zae01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zae04,zae05,zae06,zae07,zae08,zae09,zae10 ",
                     "  FROM zae_file",
                     " WHERE zae01 = ? AND zae04 = ? AND zae05 = ? ",
                     "   AND zae08 = ? ",
                     "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_sql_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_zae WITHOUT DEFAULTS FROM s_zae.*
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
            LET g_zae_t.* = g_zae[l_ac].*    #BACKUP
            OPEN p_sql_bcl USING g_zae01,g_zae_t.zae04,
                                 g_zae_t.zae05,g_zae_t.zae08
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_sql_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_sql_bcl INTO g_zae[l_ac].zae04,g_zae[l_ac].zae05,
                                    g_zae[l_ac].zae06,g_zae[l_ac].zae07,
                                    g_zae[l_ac].zae08,g_zae[l_ac].zae09,
                                    g_zae[l_ac].zae10
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_sql_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()  
         END IF
 
   BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zae[l_ac].* TO NULL
         LET g_zae[l_ac].zae04=g_zae_t.zae04
         LET g_zae[l_ac].zae05=g_zae_t.zae05
         LET g_zae[l_ac].zae06=g_zae_t.zae06
         LET g_zae[l_ac].zae07=g_zae_t.zae07
         SELECT MAX(zae08)+1 INTO g_zae[l_ac].zae08
           FROM zae_file
          WHERE zae01=g_zae01
            AND zae04=g_zae[l_ac].zae04
            AND zae05=g_zae[l_ac].zae05
 
         LET g_zae_t.* = g_zae[l_ac].*          #新輸入資料
 
      AFTER FIELD zae08
         IF g_zae_t.zae08='1' AND g_zae[l_ac].zae08 !='1' THEN
            CALL cl_err('','azz-128',0)
            LET g_zae[l_ac].zae08=g_zae_t.zae08
            DISPLAY g_zae[l_ac].zae08 TO zae08
            NEXT FIELD zae08
         ELSE
            IF p_cmd='a' THEN
               SELECT COUNT(*) INTO l_count
                 FROM zae_file 
                WHERE zae01=g_zae01
                  AND zae04=g_zae[l_ac].zae04
                  AND zae05=g_zae[l_ac].zae05
                  AND zae08=g_zae[l_ac].zae08
               IF l_count>0 THEN
                  CALL cl_err('','axm-298',0)
                  LET g_zae[l_ac].zae08=g_zae_t.zae08
                  DISPLAY g_zae[l_ac].zae08 TO zae08
                  NEXT FIELD zae08
               END IF
            END IF
         END IF
 
      BEFORE FIELD zae10
         IF g_zae[l_ac].zae09 IS NULL THEN
            NEXT FIELD zae09
         END IF
 
      AFTER FIELD zae10
         SELECT COUNT(*) INTO l_count
           FROM zae_file
          WHERE zae01=g_zae01
            AND zae04=g_zae[l_ac].zae04
            AND zae05=g_zae[l_ac].zae05
            AND zae10=g_zae[l_ac].zae10
         IF l_count>1 THEN
            CALL cl_err('','axm-298',0)
            LET g_zae[l_ac].zae10=g_zae_t.zae10
            DISPLAY g_zae[l_ac].zae10 TO zae10
            NEXT FIELD zae10
         END IF
         IF (p_cmd='u' AND g_zae_t.zae10!=g_zae[l_ac].zae10 ) OR
             p_cmd='a' THEN
            IF l_count >0 THEN
               CALL cl_err('','axm-298',0)
               LET g_zae[l_ac].zae10=g_zae_t.zae10
               DISPLAY g_zae[l_ac].zae10 TO zae10
               NEXT FIELD zae10
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         ELSE
            CASE 
               WHEN g_zae[l_ac].zae09 is null
                    LET g_zae[l_ac].zae10=''
                    LET g_zae[l_ac].text=''
                    DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text TO zae10,text
               WHEN g_zae[l_ac].zae09='1'
                    SELECT COUNT(zz01) INTO l_count
                      FROM zz_file 
                     WHERE zz01=g_zae[l_ac].zae10
                    IF l_count=0 THEN
                       CALL cl_err('','azz-127',0)
                       NEXT FIELD zae10
                    ELSE
                       CALL p_sql_text(g_zae[l_ac].zae05,g_zae[l_ac].zae09,
                                       g_zae[l_ac].zae10) RETURNING g_zae[l_ac].text
                       DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text 
                            TO zae10,formonly.text
                    END IF
               WHEN g_zae[l_ac].zae09='2'
                    SELECT COUNT(zae01) INTO l_count
                      FROM zae_file 
                     WHERE zae01=g_zae[l_ac].zae10
                    IF l_count=0 THEN
                       CALL cl_err('','azz-800',0)
                       NEXT FIELD zae10
                    ELSE
                       CALL p_sql_text(g_zae[l_ac].zae05,g_zae[l_ac].zae09,
                                       g_zae[l_ac].zae10) RETURNING g_zae[l_ac].text
                       DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text 
                            TO zae10,formonly.text
                    END IF
            END CASE
         END IF
 
         INSERT INTO zae_file(zae01,zae02,zae03,zae04,zae05,zae06,zae07,zae08,
                              zae09,zae10)
                      VALUES (g_zae01,g_zae02,g_zae03,
                              g_zae[l_ac].zae04,g_zae[l_ac].zae05,
                              g_zae[l_ac].zae06,g_zae[l_ac].zae07,
                              g_zae[l_ac].zae08,g_zae[l_ac].zae09,
                              g_zae[l_ac].zae10)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zae01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","zae_file",g_zae01,g_zae[l_ac].zae04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_zae_t.zae04) THEN
            SELECT COUNT(*) INTO l_count
              FROM zae_file
             WHERE zae01=g_zae01
               AND zae04=g_zae[l_ac].zae04
               AND zae05=g_zae[l_ac].zae05
            IF l_count=1 THEN  #無法刪除sql所select出來的基本資料
               CALL cl_err('',"azz-126",1)
               CANCEL DELETE
            END IF
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM zae_file WHERE zae01 = g_zae01
                                   AND zae04 = g_zae[l_ac].zae04
                                   AND zae05 = g_zae[l_ac].zae05
                                   AND zae08 = g_zae[l_ac].zae08
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zae_t.zae04,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zae_file",g_zae01,g_zae_t.zae04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
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
            LET g_zae[l_ac].* = g_zae_t.*
            CLOSE p_sql_bcl
            ROLLBACK WORK
            EXIT INPUT
         ELSE
            CASE 
               WHEN g_zae[l_ac].zae09 is null
                    LET g_zae[l_ac].zae10=''
                    LET g_zae[l_ac].text=''
                    DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text TO zae10,text
               WHEN g_zae[l_ac].zae09='1'
                    SELECT COUNT(zz01) INTO l_count
                      FROM zz_file 
                     WHERE zz01=g_zae[l_ac].zae10
                    IF l_count=0 THEN
                       CALL cl_err('','azz-127',0)
                       NEXT FIELD zae10
                    ELSE
                       CALL p_sql_text(g_zae[l_ac].zae05,g_zae[l_ac].zae09,
                                       g_zae[l_ac].zae10) RETURNING g_zae[l_ac].text
                       DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text 
                            TO zae10,formonly.text
                    END IF
               WHEN g_zae[l_ac].zae09='2'
                    SELECT COUNT(zae01) INTO l_count
                      FROM zae_file 
                     WHERE zae01=g_zae[l_ac].zae10
                    IF l_count=0 THEN
                       CALL cl_err('','azz-800',0)
                       NEXT FIELD zae10
                    ELSE
                       CALL p_sql_text(g_zae[l_ac].zae05,g_zae[l_ac].zae09,
                                       g_zae[l_ac].zae10) RETURNING g_zae[l_ac].text
                       DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text 
                            TO zae10,formonly.text
                    END IF
            END CASE
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zae[l_ac].zae04,-263,1)
            LET g_zae[l_ac].* = g_zae_t.*
         ELSE
            UPDATE zae_file
               SET zae04 = g_zae[l_ac].zae04,
                   zae05 = g_zae[l_ac].zae05,
                   zae06 = g_zae[l_ac].zae06,
                   zae07 = g_zae[l_ac].zae07,
                   zae08 = g_zae[l_ac].zae08,
                   zae09 = g_zae[l_ac].zae09,
                   zae10 = g_zae[l_ac].zae10
             WHERE zae01 = g_zae01
               AND zae04 = g_zae_t.zae04
               AND zae05 = g_zae_t.zae05
               AND zae08 = g_zae_t.zae08
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zae[l_ac].zae04,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zae_file",g_zae01,g_zae_t.zae04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zae[l_ac].* = g_zae_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30034
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zae[l_ac].* = g_zae_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_zae.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
#            ELSE
#               CANCEL INSERT
            END IF
            CLOSE p_sql_bcl
            ROLLBACK WORK
            EXIT INPUT
         ELSE
            CASE 
               WHEN g_zae[l_ac].zae09 is null
                    LET g_zae[l_ac].zae10=''
                    LET g_zae[l_ac].text=''
                    DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text TO zae10,text
               WHEN g_zae[l_ac].zae09='1'
                    SELECT COUNT(zz01) INTO l_count
                      FROM zz_file 
                     WHERE zz01=g_zae[l_ac].zae10
                    IF l_count=0 THEN
                       CALL cl_err('','azz-127',0)
                       NEXT FIELD zae10
                    ELSE
                       CALL p_sql_text(g_zae[l_ac].zae05,g_zae[l_ac].zae09,
                                       g_zae[l_ac].zae10) RETURNING g_zae[l_ac].text
                       DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text 
                            TO zae10,formonly.text
                    END IF
               WHEN g_zae[l_ac].zae09='2'
                    SELECT COUNT(zae01) INTO l_count
                      FROM zae_file 
                     WHERE zae01=g_zae[l_ac].zae10
                    IF l_count=0 THEN
                       CALL cl_err('','azz-800',0)
                       NEXT FIELD zae10
                    ELSE
                       CALL p_sql_text(g_zae[l_ac].zae05,g_zae[l_ac].zae09,
                                       g_zae[l_ac].zae10) RETURNING g_zae[l_ac].text
                       DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text 
                            TO zae10,formonly.text
                    END IF
            END CASE
         END IF
         LET l_ac_t = l_ac  #FUN-D30034
         CLOSE p_sql_bcl
         COMMIT WORK
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(zae10)
               IF g_zae[l_ac].zae09=1 THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zz2"
                  LET g_qryparam.arg1 =  g_zae[l_ac].zae05
#                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1= g_zae[l_ac].zae10
                  CALL cl_create_qry() RETURNING g_zae[l_ac].zae10,
                                                 g_zae[l_ac].text
                  DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text 
                       TO zae10,formonly.text
                  NEXT FIELD zae10
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zae1"
                  LET g_qryparam.arg1 =  g_lang
#                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1= g_zae[l_ac].zae10
                  CALL cl_create_qry() RETURNING g_zae[l_ac].zae10,
                                                 g_zae[l_ac].text 
                  DISPLAY g_zae[l_ac].zae10,g_zae[l_ac].text 
                       TO zae10,formonly.text
                  NEXT FIELD zae10
               END IF
 
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("grid01,grid02","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END INPUT
 
   CLOSE p_sql_bcl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION p_sql_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc         LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(300)
   DEFINE p_ac         LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
    LET g_sql = "SELECT zae04,zae05,zae06,zae07,zae08,zae09,zae10 ",
                 " FROM zae_file ",
                " WHERE zae01 = '",g_zae01 CLIPPED,"' ",
                  " AND ",p_wc CLIPPED,
                " ORDER BY zae04,zae05"
 
    PREPARE p_sql_prepare2 FROM g_sql           #預備一下
    DECLARE zae_curs CURSOR FOR p_sql_prepare2
 
    CALL g_zae.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH zae_curs INTO g_zae[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_zae[g_cnt].zae09='1' THEN
          CALL p_sql_text(g_zae[g_cnt].zae05,g_zae[g_cnt].zae09,
                          g_zae[g_cnt].zae10) RETURNING g_zae[g_cnt].text
       ELSE
          CALL p_sql_text(g_zae[g_cnt].zae05,g_zae[g_cnt].zae09,
                          g_zae[g_cnt].zae10) RETURNING g_zae[g_cnt].text
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zae.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_sql_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_zae TO s_zae.* ATTRIBUTE(UNBUFFERED)
 
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
 
#      ON ACTION reproduce                        # C.複製
#         LET g_action_choice='reproduce'
#         EXIT DISPLAY
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_sql_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                 
 
      ON ACTION previous                         # P.上筆
         CALL p_sql_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                 
 
      ON ACTION jump                             # 指定筆
         CALL p_sql_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                
 
      ON ACTION next                             # N.下筆
         CALL p_sql_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                 
 
      ON ACTION last                             # 最終筆
         CALL p_sql_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                 
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                 
 
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_lang("zae03")
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("grid01,grid02","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_sql_parse_sql()
    DEFINE l_text      STRING
    DEFINE l_str       STRING
    DEFINE l_sql       STRING
    DEFINE l_tmp       STRING
    DEFINE l_execmd    STRING
    DEFINE l_tok       base.StringTokenizer 
    DEFINE l_start     LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_end       LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_feld_tmp  LIKE type_file.chr1000    #No.FUN-680135 VARCHAR(55)
    DEFINE l_feld      DYNAMIC ARRAY OF STRING
    DEFINE l_length    DYNAMIC ARRAY OF LIKE type_file.num5    #No.FUN-680135 DYNAMIC ARRAY OF SMALLINT
    DEFINE l_feld_t    DYNAMIC ARRAY OF STRING
    DEFINE l_tab       DYNAMIC ARRAY OF STRING
    DEFINE l_tab_alias DYNAMIC ARRAY OF STRING
    DEFINE l_i         LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_j         LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_k         LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_gaq03     LIKE zae_file.zae07
    DEFINE l_lang_arr  DYNAMIC ARRAY OF LIKE type_file.chr1      #No.FUN-680135 DYNAMIC ARRAY OF VARCHAR(1)
    DEFINE l_feld_cnt  LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_tab_cnt   LIKE type_file.num5       #No.FUN-680135 SMALLINT
    DEFINE l_colname   LIKE gaq_file.gaq01,      #No.FUN-680135 VARCHAR(20)
           l_colnamec  LIKE gaq_file.gaq03,      #No.FUN-680135 VARCHAR(50)
           l_collen    LIKE type_file.num5,      #No.FUN-680135 SMALLINT
           l_coltype   LIKE zta_file.zta03,      #No.FUN-680135 VARCHAR(3)
           l_sel       LIKE type_file.chr1       #No.FUN-680135 VARCHAR(1)
 
--  抓取所有的語言別
    DECLARE lang_arr CURSOR FOR
     SELECT UNIQUE gay01 FROM gay_file ORDER BY gay01
    LET l_i=1
    FOREACH lang_arr INTO l_lang_arr[l_i]
       IF sqlca.sqlcode THEN
          CONTINUE FOREACH
       END IF
       LET l_i=l_i+1
    END FOREACH
    FREE lang_arr
    CALL l_lang_arr.deleteElement(l_i)
 
    LET l_sel='I'
 
               LET l_str=p_sql_cut_spaces(g_zae03)
               LET l_end = l_str.getIndexOf(';',1)
               IF l_end != 0 THEN
                  LET l_str=l_str.subString(1,l_end-1)
               END IF
               LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,"\n","",TRUE)
               WHILE l_tok.hasMoreTokens()
                     LET l_tmp=l_tok.nextToken()
                     IF l_text is null THEN
                        LET l_text = l_tmp.trim()
                     ELSE
                        LET l_text = l_text CLIPPED,' ',l_tmp.trim()
                     END IF
                     display "dbquery_sql:",l_text
               END WHILE
               LET l_tmp=l_text
               LET l_execmd=l_tmp
               LET l_str=l_tmp
#               LET l_tmp=l_text
               LET l_start = l_tmp.getIndexOf('select',1)
               IF l_start=0 THEN
                  CALL cl_err('can not execute this command!','!',0)
               LET INT_FLAG=1
               END IF
               LET l_end   = l_tmp.getIndexOf('from',1)
               display "l_start:",l_start
               display "l_end:",l_end
               LET l_str=l_str.subString(l_start+7,l_end-2)
               LET l_str=l_str.trim()
               LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
               LET l_i=1
               WHILE l_tok.hasMoreTokens()
                     LET l_feld[l_i]=l_tok.nextToken()
                     LET l_feld[l_i]=l_feld[l_i].trim()
                     LET l_i=l_i+1
                     display "feld",l_i-1,":",l_feld[l_i-1]
               END WHILE
               LET l_feld_cnt=l_i-1
               
               LET l_str=l_tmp
               LET l_start = l_str.getIndexOf('from',1)
               LET l_end   = l_str.getIndexOf('where',1)
               IF l_end=0 THEN
                  LET l_end   = l_str.getIndexOf('group',1)
                  IF l_end=0 THEN
                     LET l_end   = l_str.getIndexOf('order',1)
                     IF l_end=0 THEN
                        LET l_end=l_str.getLength()
                        LET l_str=l_str.subString(l_start+5,l_end)
                     ELSE
                        LET l_str=l_str.subString(l_start+5,l_end-2)
                     END IF
                  ELSE
                     LET l_str=l_str.subString(l_start+5,l_end-2)
                  END IF
               ELSE
                  LET l_str=l_str.subString(l_start+5,l_end-2)
               END IF
               LET l_str=l_str.trim()
               LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
               LET l_j=1
               WHILE l_tok.hasMoreTokens()
                     LET l_tab[l_j]=l_tok.nextToken()
                     LET l_tab[l_j]=l_tab[l_j].trim()
                     IF l_tab[l_j].getIndexOf(' ',1) THEN
                        DISPLAY 'qazzaq:',l_tab[l_j].getIndexOf(' ',1)
                        LET l_tab_alias[l_j]=l_tab[l_j].subString(l_tab[l_j].getIndexOf(' ',1)+1,l_tab[l_j].getLength())
                        LET l_tab[l_j]=l_tab[l_j].subString(1,l_tab[l_j].getIndexOf(' ',1)-1)
                     END IF
                     LET l_j=l_j+1
                     display "tab",l_j-1,":",l_tab[l_j-1],":",l_tab_alias[l_j-1]
               END WHILE
               LET l_tab_cnt=l_j-1
 
               CALL cl_query_prt_temptable()   #FUN-A90024 為了改call cl_query_prt_getlength(),需先在這裡create temptable
               
               FOR l_i=1 TO l_feld_cnt
                   IF l_feld[l_i]='*' THEN
                      LET l_str=l_tmp
                      LET l_start = l_str.getIndexOf('from',1)
                      LET l_end   = l_str.getIndexOf('where',1)
                      IF l_end=0 THEN
                         LET l_end   = l_str.getIndexOf('group',1)
                         IF l_end=0 THEN
                            LET l_end   = l_str.getIndexOf('order',1)
                            IF l_end=0 THEN
                               LET l_end=l_str.getLength()
                               LET l_str=l_str.subString(l_start+5,l_end)
                            ELSE
                               LET l_str=l_str.subString(l_start+5,l_end-2)
                            END IF
                         ELSE
                            LET l_str=l_str.subString(l_start+5,l_end-2)
                         END IF
                      ELSE
                         LET l_str=l_str.subString(l_start+5,l_end-2)
                      END IF
                      LET l_str=l_str.trim()
                      LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
                      FOR l_j=1 TO l_tab_cnt 
                          #CALL p_sql_getlength(l_tab[l_j],l_sel,'m')              #FUN-A90024 mark
                          CALL cl_query_prt_getlength(l_tab[l_j], l_sel, 'm', 0)   #FUN-A90024
                          DECLARE p_sql_insert_d_ifx CURSOR FOR
                          #        SELECT xabc02,xabc03 FROM xabc ORDER BY xabc01  #FUN-A90024 mark
                                  SELECT xabc03, xabc04 FROM xabc ORDER BY xabc01   #FUN-A90024
                                  
                          FOREACH p_sql_insert_d_ifx INTO l_feld_tmp,l_length[l_i]
                             LET l_feld[l_i]=l_feld_tmp
                             LET l_i=l_i+1
                          END FOREACH
                          LET l_feld_cnt=l_i-1
                      END FOR
                      EXIT FOR   #確保避免因人為的sql錯誤產生多除的顯示欄位
                   ELSE
                      IF l_feld[l_i].getIndexOf('.',1) THEN
                         IF l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())='*' THEN
                            FOR l_j=1 TO l_tab_cnt
                                IF l_tab_alias[l_j] is null THEN
                                   IF l_tab[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                                      LET l_k=l_i   #備份l_i的值
                                      CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                                      CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                                      CALL l_feld.insertElement(l_i)
                                      CALL l_length.insertElement(l_i)
                                      #CALL p_sql_getlength(l_tab[l_j],l_sel,'m')   #FUN-A90024 mark
                                      CALL cl_query_prt_getlength(l_tab[l_j], l_sel, 'm', 0)   #FUN-A90024
                                      DECLARE p_sql_insert_d1_ifx CURSOR FOR 
                                      #        SELECT xabc02,xabc03 FROM xabc ORDER BY xabc01 DESC  #FUN-A90024 mark
                                              SELECT xabc03, xabc04 FROM xabc ORDER BY xabc01 DESC  #FUN-A90024
                                              
                                      FOREACH p_sql_insert_d1_ifx INTO l_feld_tmp,l_length[l_i]
                                         LET l_feld[l_i]=l_feld_tmp
                                         CALL l_feld.insertElement(l_i)
                                         CALL l_length.insertElement(l_i)
                                         LET l_k=l_k+1
                                         LET l_feld_cnt=l_feld_cnt+1
                                      END FOREACH
                                      CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                                      CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                                      LET l_feld_cnt=l_feld_cnt-1
                                      LET l_i=l_k-1
                                   END IF
                                ELSE
                                   IF l_tab_alias[l_j]=l_feld[l_i].subString(1,l_feld[l_i].getIndexOf('.',1)-1) THEN
                                      LET l_k=l_i   #備份l_i的值
                                      CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                                      CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                                      CALL l_feld.insertElement(l_i)
                                      CALL l_length.insertElement(l_i)
                                      #CALL p_sql_getlength(l_tab[l_j],l_sel,'m')              #FUN-A90024 mark
                                      CALL cl_query_prt_getlength(l_tab[l_j], l_sel, 'm', 0)   #FUN-A90024
                                      DECLARE p_sql_insert_d2_ifx CURSOR FOR 
                                      #        SELECT xabc02,xabc03 FROM xabc ORDER BY xabc01 DESC  #FUN-A90024 mark
                                              SELECT xabc03, xabc04 FROM xabc ORDER BY xabc01 DESC  #FUN-A90024
                                              
                                      FOREACH p_sql_insert_d2_ifx INTO l_feld_tmp,l_length[l_i]
                                         LET l_feld[l_i]=l_feld_tmp
                                         CALL l_feld.insertElement(l_i)
                                         CALL l_length.insertElement(l_i)
                                         LET l_k=l_k+1
                                         LET l_feld_cnt=l_feld_cnt+1
                                      END FOREACH
                                      CALL l_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                                      CALL l_length.deleteElement(l_i) #刪除xxx.*那筆資料
                                      LET l_feld_cnt=l_feld_cnt-1
                                      LET l_i=l_k-1
                                   END IF
                                END IF 
                            END FOR
                         ELSE
                            LET l_feld[l_i]=l_feld[l_i].subString(l_feld[l_i].getIndexOf('.',1)+1,l_feld[l_i].getLength())
                            LET l_length[l_i]=''
                            #CALL p_sql_getlength(l_feld[l_i],l_sel,'s')              #FUN-A90024 mark
                            CALL cl_query_prt_getlength(l_feld[l_i], l_sel, 's', 0)   #FUN-A90024
                            DECLARE p_sql_d_ifx CURSOR FOR 
                            #        SELECT xabc02,xabc03 FROM xabc ORDER BY xabc01 DESC  #FUN-A90024 mark
                                    SELECT xabc03, xabc04 FROM xabc ORDER BY xabc01 DESC  #FUN-A90024
                                    
                            FOREACH p_sql_d_ifx INTO l_feld_tmp,l_length[l_i]
                               LET l_feld[l_i]=l_feld_tmp
                            END FOREACH
                         END IF
                      ELSE
                         LET l_length[l_i]=''
                            #CALL p_sql_getlength(l_feld[l_i],l_sel,'s')              #FUN-A90024 mark
                            CALL cl_query_prt_getlength(l_feld[l_i], l_sel, 's', 0)   #FUN-A90024
                            DECLARE p_sql_d1_ifx CURSOR FOR 
                            #        SELECT xabc02,xabc03 FROM xabc ORDER BY xabc01 DESC  #FUN-A90024 mark
                                    SELECT xabc03, xabc04 FROM xabc ORDER BY xabc01 DESC  #FUN-A90024
                                    
                            FOREACH p_sql_d1_ifx INTO l_feld_tmp,l_length[l_i]
                               LET l_feld[l_i]=l_feld_tmp
                            END FOREACH
                      END IF
                   END IF
               END FOR
               
               
               LET l_j = 1
               LET l_colname=''
               FOR l_i = 1 TO l_feld_cnt
                   LET l_colname=l_feld[l_i]
                   FOR l_k=1 TO l_lang_arr.getLength()
                       LET l_gaq03=''
                       SELECT gaq03 INTO l_gaq03 FROM gaq_file
                        WHERE gaq01=l_colname
                          AND gaq02=l_lang_arr[l_k]
                       INSERT INTO zae_file(zae01,zae02,zae03,zae04,zae05,
                                            zae06,zae07,zae08,zae09,zae10)
                       VALUES(g_zae01,g_zae02,g_zae03,l_j,l_lang_arr[l_k],
                              l_colname,l_gaq03,'1','','')
                       LET l_j=l_j+1
                   END FOR
#                   CALL ln_table_column.setAttribute("text", l_feld[l_i])
               END FOR
               
{               PREPARE table_pre FROM l_execmd
               IF SQLCA.SQLCODE THEN
                  CALL cl_err('','zta-028',1)
               END IF
               DECLARE table_cur CURSOR FOR table_pre
               IF SQLCA.SQLCODE THEN
                  CALL cl_err('','zta-028',1)
               END IF
               
               LET l_i = 1
               CALL ga_table_data.clear()
               FOREACH table_cur INTO ga_table_data[l_i].* 
                   IF SQLCA.SQLCODE THEN
                      CALL cl_err('','zta-028',1)
                   END IF
                   LET l_i=l_i+1
               END FOREACH
               IF SQLCA.SQLCODE THEN
                  CALL cl_err('',sqlca.sqlcode,1)
               END IF
               LET g_dbqry_rec_b = l_i - 1
               
               DISPLAY ARRAY ga_table_data TO s_table_data.* ATTRIBUTE ( COUNT = g_dbqry_rec_b)
           
 
               BEFORE DISPLAY
                      EXIT DISPLAY 
               END DISPLAY
}
            IF INT_FLAG=1 THEN
               END IF
END FUNCTION
 
#---FUN-A90024---start-----
#此p_sql_getlength()已捨棄不用,改用cl_query_prt_getlength()即可
#所以將此Function直接mark
##p_flag = s 表single只查field
##p_flag = m 表multi查table所有的field
#FUNCTION p_sql_getlength(p_tab,p_sel,p_flag)
#DEFINE p_tab        STRING
#DEFINE l_sql        STRING
#DEFINE l_sn         LIKE type_file.num5    #No.FUN-680135 SMALLINT
#DEFINE p_flag       LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1) 
#DEFINE l_feldname   LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(55)
#DEFINE l_colname    LIKE gaq_file.gaq01,   #No.FUN-680135 VARCHAR(20)
#       l_colnamec   LIKE gaq_file.gaq03,   #No.FUN-680135 VARCHAR(50)
#       l_collen     LIKE type_file.num5,   #No.FUN-680135 SMALLINT
#       l_coltype    LIKE zta_file.zta03,   #No.FUN-680135 VARCHAR(3)
#       p_sel        LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
# 
#    DROP TABLE xabc
##FUN-680135 --start
##   CREATE TEMP TABLE xabc
##   (
##     xabc01 SMALLINT,
##     xabc02 VARCHAR(55),
##     xabc03 SMALLINT
##   )
#    
#    CREATE TEMP TABLE xabc(
#      xabc01 LIKE type_file.num5,  
#      xabc02 LIKE type_file.chr1000,
#      xabc03 LIKE type_file.num5)
##FUN-680135 --end      
#    LET l_sn=1
#    IF p_flag='m' THEN
#       IF g_db_type="IFX" THEN
#          LET l_sql="SELECT c.colname,c.coltype,c.collength FROM syscolumns c,systables t",
#                    " WHERE c.tabid=t.tabid AND t.tabname='",p_tab CLIPPED,"'",
#                    " ORDER BY c.colno "
#          DECLARE p_sql_getlength_d_ifx CURSOR FROM l_sql
#          FOREACH p_sql_getlength_d_ifx INTO l_colname,l_coltype,l_collen
#             CASE WHEN l_coltype='1' or l_coltype='257'
#                       LET l_collen=5
#                  WHEN l_coltype='2' or l_coltype='258'
#                       LET l_collen=10
#                  WHEN l_coltype='5' or l_coltype='261'
#                       LET l_collen=20
#                  WHEN l_coltype='7' or l_coltype='263'
#                       LET l_collen=10
#             END CASE
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                     LET l_sn=l_sn+1
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                     LET l_sn=l_sn+1
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  LET l_sn=l_sn+1
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  LET l_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,l_collen)
#                  LET l_sn=l_sn+1
#             END CASE
#          END FOREACH
#       ELSE
#          LET l_sql="SELECT lower(column_name),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION) FROM user_tab_columns",
#                    " WHERE lower(table_name)='",p_tab CLIPPED,"'",
#                    " ORDER BY column_id "
#          DECLARE p_sql_getlength_d CURSOR FROM l_sql
#          FOREACH p_sql_getlength_d INTO l_colname,l_collen
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                     LET l_sn=l_sn+1
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                     LET l_sn=l_sn+1
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  LET l_sn=l_sn+1
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname||'('||l_colnamec||')',l_collen)
#                  LET l_sn=l_sn+1
#             END CASE
#          END FOREACH
#       END IF
#    ELSE
#       IF g_db_type="IFX" THEN
#          LET l_sql="SELECT c.colname,c.coltype,c.collength FROM syscolumns c",
#                    " WHERE c.colname='",p_tab CLIPPED,"'",
#                    " ORDER BY c.colno desc"
#          DECLARE p_sql_getlength_d1_ifx CURSOR FROM l_sql
#          FOREACH p_sql_getlength_d1_ifx INTO l_colname,l_coltype,l_collen
#             CASE WHEN l_coltype='1' or l_coltype='257'
#                       LET l_collen=5
#                  WHEN l_coltype='2' or l_coltype='258'
#                       LET l_collen=10
#                  WHEN l_coltype='5' or l_coltype='261'
#                       LET l_collen=20
#                  WHEN l_coltype='7' or l_coltype='263'
#                       LET l_collen=10
#             END CASE
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  LET l_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,l_collen)
#             END CASE
#          END FOREACH
#          IF cl_null(l_colname) AND (l_collen=0) THEN
#             LET l_feldname=p_tab
#             INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,10)
#          END IF
#       ELSE
#          LET l_sql="SELECT lower(column_name),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION) FROM user_tab_columns",
#                    " WHERE lower(column_name)='",p_tab CLIPPED,"'",
#                    " ORDER BY column_id desc"
#          DECLARE p_sql_getlength_d1 CURSOR FROM l_sql
#          FOREACH p_sql_getlength_d1 INTO l_colname,l_collen
#             CASE
#               WHEN p_sel='N'
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  IF cl_null(l_colnamec) THEN
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#                  ELSE
#                     INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colnamec,l_collen)
#                  END IF
#               WHEN p_sel='I'
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname,l_collen)
#               OTHERWISE
#                  SELECT gaq03 INTO l_colnamec
#                    FROM gaq_file
#                   WHERE gaq01=l_colname
#                     AND gaq02=g_i
#                  INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_colname||'('||l_colnamec||')',l_collen)
#             END CASE
#          END FOREACH
#          IF cl_null(l_colname) AND (l_collen=0) THEN  #for count(*)之類的用途
#             LET l_feldname=p_tab
#             INSERT INTO xabc(xabc01,xabc02,xabc03) VALUES(l_sn,l_feldname,10)
#          END IF
#       END IF
#    END IF
#END FUNCTION
#---FUN-A90024---end-------
 
FUNCTION p_sql_cut_spaces(p_str)
DEFINE p_str         STRING,
       l_i           LIKE type_file.num5,   #No.FUN-680135 SMALLINT
       l_flag        LIKE type_file.chr1,   #No.FUN-680135 VARCHAR(1) 
       l_cmd         STRING,
       l_desc_stop   LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
LET l_flag='N'
LET l_desc_stop=-1
LET p_str=p_str.trim()
FOR l_i=1 TO p_str.getLength()
    IF l_i<=l_desc_stop+1 THEN
       CONTINUE FOR
    ELSE
       IF g_db_type="IFX" THEN
          IF l_i=p_str.getIndexOf('{',l_i) THEN
             LET l_desc_stop=p_str.getIndexOf('}',l_i)
             LET l_cmd=l_cmd,p_str.subString(l_i,l_desc_stop+1)
          ELSE
             IF p_str.subString(l_i,l_i) != ' ' THEN
                IF l_cmd.getLength()=0 THEN
                   LET l_cmd=p_str.subString(l_i,l_i)
                ELSE
                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
                END IF
                LET l_flag='N'
             ELSE
                IF l_flag='N' THEN
                   LET l_flag='Y'
                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
                END IF
             END IF
          END IF
       ELSE
          IF l_i=p_str.getIndexOf('/*',l_i) THEN
             LET l_desc_stop=p_str.getIndexOf('*/',l_i)
             LET l_cmd=l_cmd,p_str.subString(l_i,l_desc_stop+1)
          ELSE
             IF p_str.subString(l_i,l_i) != ' ' THEN
                IF l_cmd.getLength()=0 THEN
                   LET l_cmd=p_str.subString(l_i,l_i)
                ELSE
                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
                END IF
                LET l_flag='N'
             ELSE
                IF l_flag='N' THEN
                   LET l_flag='Y'
                   LET l_cmd=l_cmd,p_str.subString(l_i,l_i)
                END IF
             END IF
          END IF
       END IF
    END IF
END FOR
RETURN l_cmd
END FUNCTION
 
 
 
FUNCTION p_sql_text(p_sql05,p_sql09,p_sql10)
DEFINE p_sql05  LIKE zae_file.zae05
DEFINE p_sql09  LIKE zae_file.zae09
DEFINE p_sql10  LIKE zae_file.zae10
DEFINE l_result LIKE gaz_file.gaz03
 
    IF p_sql09='1' THEN
       SELECT gaz03 INTO l_result
         FROM gaz_file
        WHERE gaz01=p_sql10
          AND gaz02=p_sql05
    ELSE
       SELECT zae02 INTO l_result
         FROM zae_file
        WHERE zae01=p_sql10
    END IF
    RETURN l_result
 
END FUNCTION
