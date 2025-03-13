# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_tgrup.4gl
# Descriptions...: 同權限部門 資料維護作業
# Date & Author..: 05/08/08 Sarah
# Modify.........: No.MOD-5A0401 05/10/26 By alex 修正部份錯誤
# Modify.........: No.TQC-5C0116 05/12/26 By alex 修正名稱為 p_tgrup及相關錯誤
# Modify.........: No.TQC-5C0125 05/12/28 By alex 限制一個部門只能歸屬一個群組
# Modify.........: No.TQC-5C0134 06/02/13 By alex 新增manager功能
# Modify.........: No.TQC-640030 06/04/07 By pengu 在insert部門群組類別時應default zyw05='0'，否則會照成新增後Q不出資料
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/22 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"                         
# Modify.........: No.MOD-7A0138 07/10/25 By Pengu 因為zyw04資料庫設為not null，所以會造成無法新增
# Modify.........: No.MOD-880238 08/08/28 By alexstar 單頭可開窗選擇
# Modify.........: No.MOD-8C0054 08/12/10 By Sarah p_tgrup_b_fill()組SQL時應增加過濾zyw05='0'
# Modify.........: No.FUN-920138 09/08/18 By tsai_yen 和"部門與部門群組上線控管"(p_onlinepp)同步：1.單頭刪除資料時 2.單頭修改key時
# Modify.........: No:MOD-A80044 10/08/05 By Dido 單身刪除完畢後若有對應群組管理員應一併刪除 
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zyw01      LIKE zyw_file.zyw01,          # 類別代號 (假單頭)
         g_zyw01_t    LIKE zyw_file.zyw01,
         g_zyw02      LIKE zyw_file.zyw02,
         g_zyw02_t    LIKE zyw_file.zyw02,
         g_zyw_lock   RECORD LIKE zyw_file.*,       # FOR LOCK CURSOR TOUCH
         g_zyw        DYNAMIC ARRAY of RECORD       # 單身
                      zyw03 LIKE zyw_file.zyw03,
                      gem02 LIKE gem_file.gem02                  
                      END RECORD,
         g_zyw_t      RECORD                        # 單身舊值
                      zyw03 LIKE zyw_file.zyw03,
                      gem02 LIKE gem_file.gem02                    
                      END RECORD,
         g_gem02      LIKE gem_file.gem02,
         g_wc         STRING,
         g_sql        STRING,
         g_rec_b      LIKE type_file.num5,          # 單身筆數            #No.FUN-680135 SMALLINT
         l_ac         LIKE type_file.num5           # 目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
DEFINE   g_cnt        LIKE type_file.num10          #No.FUN-680135 INTEGER
DEFINE   g_msg        LIKE type_file.chr1000        #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql STRING
DEFINE   g_forupd_gbo_sql  STRING                   #FOR UPDATE SQL   #FUN-920138
DEFINE   g_before_input_done  LIKE type_file.num5   #No.FUN-680135 SMALLINT
DEFINE   g_row_count  LIKE type_file.num10          #No.FUN-680135 INTEGER
DEFINE   g_curs_index LIKE type_file.num10          #No.FUN-680135 INTEGER
DEFINE   g_jump       LIKE type_file.num10          #No.FUN-680135 INTEGER
DEFINE   g_no_ask    LIKE type_file.num5           #No.FUN-680135 SMALLINT  #No.FUN-6A0080
 
MAIN
   OPTIONS                                          # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                  # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET g_forupd_sql = "SELECT * FROM zyw_file  WHERE zyw01=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE p_tgrup_lock_u CURSOR FROM g_forupd_sql
 
   LET g_forupd_gbo_sql = "SELECT * FROM gbo_file",
                           " WHERE gbo01 = ? AND gbo04 = '2' FOR UPDATE"
   LET g_forupd_gbo_sql = cl_forupd_sql(g_forupd_gbo_sql)

   DECLARE gbo_bcl CURSOR FROM g_forupd_gbo_sql    
   
   LET g_zyw01_t = NULL

   OPEN WINDOW p_tgrup_w WITH FORM "azz/42f/p_tgrup"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)    #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL p_tgrup_menu() 
 
   CLOSE WINDOW p_tgrup_w                              # 結束畫面

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p_tgrup_cs()                        # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_zyw.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   CONSTRUCT g_wc ON zyw01,zyw02,zyw03
                FROM zyw01,zyw02,s_zyw[1].zyw03
      ON ACTION controlp
         CASE
            WHEN INFIELD(zyw01) #MOD-880238
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zyw"
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zyw01
               NEXT FIELD zyw01 
            WHEN INFIELD(zyw03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zyw03
               NEXT FIELD zyw03 
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
   
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('zywuser', 'zywgrup') #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
   LET g_sql= "SELECT UNIQUE zyw01 FROM zyw_file ",
              " WHERE ", g_wc CLIPPED,
                " AND zyw05='0' ",
              " ORDER BY zyw01"
   PREPARE p_tgrup_prepare FROM g_sql          # 預備一下
   DECLARE p_tgrup_bcs                         # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_tgrup_prepare
 
   LET g_sql= "SELECT COUNT(DISTINCT zyw01) ",
              "  FROM zyw_file ",
              " WHERE ", g_wc CLIPPED,
                " AND zyw05='0' "
   PREPARE p_tgrup_precount FROM g_sql
   DECLARE p_tgrup_count CURSOR FOR p_tgrup_precount
END FUNCTION
 
FUNCTION p_tgrup_menu()
 
   WHILE TRUE
      CALL p_tgrup_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_tgrup_a()
            END IF
 
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_tgrup_u()
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_tgrup_copy()
            END IF
 
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_tgrup_r()
            END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_tgrup_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_tgrup_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL p_tgrup_out()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"                   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zyw),'','')
            END IF
 
         WHEN "tgrupmgr"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_zyw01) THEN
                  CALL cl_err('','-400',1)
               ELSE
                  CALL p_tgrupmgr(g_zyw01,g_zyw02)
               END IF
            END IF
            
         ###FUN-920138 START ###
         #部門與部門群組上限控管
         WHEN "online_count"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun("p_onlinepp")
            END IF
         ###FUN-920138 END ###
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_tgrup_a()                            # Add  輸入
 
   MESSAGE ""
   CLEAR FORM
   CALL g_zyw.clear()
 
   INITIALIZE g_zyw01 LIKE zyw_file.zyw01     #DEFAULT 設定 
   INITIALIZE g_zyw02 LIKE zyw_file.zyw02 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_tgrup_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                        # 使用者不玩了
         LET g_zyw01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_zyw01 IS NULL THEN                   # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      CALL g_zyw.clear()
      LET g_rec_b = 0
 
      CALL p_tgrup_b()                          # 輸入單身
 
      SELECT zyw01 INTO g_zyw01 FROM zyw_file
       WHERE zyw01 = g_zyw01
      LET g_zyw01_t = g_zyw01                   #保留舊值
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_tgrup_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
   DEFINE   l_n          LIKE type_file.num5    #No.FUN-680135  SMALLINT
 
   DISPLAY g_zyw01,g_zyw02 TO zyw01,zyw02
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_zyw01,g_zyw02 WITHOUT DEFAULTS FROM zyw01,zyw02
      AFTER FIELD zyw01
         IF g_zyw01 != g_zyw01_t OR g_zyw01_t IS NULL THEN
            DISPLAY BY NAME g_zyw01
            SELECT COUNT(UNIQUE zyw01) INTO l_n 
              FROM zyw_file
             WHERE zyw01=g_zyw01
            IF l_n > 0 THEN
               CALL cl_err(g_zyw01,-239,0)
               LET g_zyw01 = g_zyw01_t
               DISPLAY BY NAME g_zyw01
               NEXT FIELD zyw01
            END IF
         END IF
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
   END INPUT
END FUNCTION
 
FUNCTION p_tgrup_u()
 
   IF cl_null(g_zyw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zyw01_t = g_zyw01
   BEGIN WORK
 
   OPEN p_tgrup_lock_u USING g_zyw01
   IF STATUS THEN
      CALL cl_err("OPEN p_tgrup_lock_u:",STATUS,1)
      CLOSE p_tgrup_lock_u
      ROLLBACK WORK
      RETURN
   ###FUN-920138 START ###
   ELSE      
      OPEN gbo_bcl USING g_zyw01
      IF STATUS THEN
         CALL cl_err("OPEN gbo_bcl:", STATUS, 1)
         CLOSE gbo_bcl
         ROLLBACK WORK
         RETURN
      END IF
   ###FUN-920138 END ###
   END IF
 
   FETCH p_tgrup_lock_u INTO g_zyw_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("g_zyw01:",SQLCA.sqlcode,1)   #資料被其他人LOCK
      CLOSE p_tgrup_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL p_tgrup_show()
 
   WHILE TRUE
      CALL p_tgrup_i("u")
 
      IF INT_FLAG THEN
         LET g_zyw01 = g_zyw01_t
         DISPLAY g_zyw01 TO zyw01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE zyw_file 
         SET zyw01 = g_zyw01,zyw02 = g_zyw02
       WHERE zyw01 = g_zyw01_t
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_zyw01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","zyw_file",g_zyw01_t,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
         CONTINUE WHILE
      ###FUN-920138 START ###
      ELSE         
         #單頭修改key與"部門與部門群組上線控管"同步
         UPDATE gbo_file 
            SET gbo01 = g_zyw01
            WHERE gbo01 = g_zyw01_t AND gbo04 = '2'
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gbo_file",g_zyw01_t,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
         END IF
      ###FUN-920138 END ###
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
   CLOSE gbo_bcl   #FUN-920138
END FUNCTION
 
FUNCTION p_tgrup_q()                            #Query 查詢
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   CALL g_zyw.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL p_tgrup_cs()                        #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN p_tgrup_bcs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                    #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_zyw01 TO NULL
   ELSE
      CALL p_tgrup_fetch('F')               #讀出TEMP第一筆並顯示
      OPEN p_tgrup_count
      FETCH p_tgrup_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
FUNCTION p_tgrup_fetch(p_flag)              #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,   #處理方式    #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10   #絕對的筆數  #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_tgrup_bcs INTO g_zyw01
      WHEN 'P' FETCH PREVIOUS p_tgrup_bcs INTO g_zyw01
      WHEN 'F' FETCH FIRST    p_tgrup_bcs INTO g_zyw01
      WHEN 'L' FETCH LAST     p_tgrup_bcs INTO g_zyw01
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
         FETCH ABSOLUTE g_jump p_tgrup_bcs INTO g_zyw01
         LET g_no_ask = FALSE           #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zyw01,SQLCA.sqlcode,0)
      INITIALIZE g_zyw01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL p_tgrup_show()
   END IF
END FUNCTION
 
FUNCTION p_tgrup_show()                    # 將資料顯示在畫面上
   DISPLAY g_zyw01 TO zyw01
   SELECT UNIQUE zyw02 INTO g_zyw02 FROM zyw_file WHERE zyw01 = g_zyw01
   IF STATUS=100 THEN LET g_zyw02='' END IF
   DISPLAY g_zyw02 TO zyw02
   CALL p_tgrup_b_fill(g_wc)               # 單身
END FUNCTION
 
FUNCTION p_tgrup_r()                       # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,   #No.FUN-680135 SMALLINT
            l_zyw   RECORD LIKE zyw_file.*
 
   IF cl_null(g_zyw01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM zyw_file WHERE zyw01 = g_zyw01 
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","zyw_file",g_zyw01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      ELSE
         ###FUN-920138 START ###
         #刪除與"部門與部門群組上線控管"同步
         DELETE FROM gbo_file 
            WHERE gbo01 = g_zyw01 AND gbo04 = '2'
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","gbo_file",g_zyw01,"",SQLCA.sqlcode,"","BODY DELETE",0)
         END IF
         ###FUN-920138 END ###
         CLEAR FORM
         CALL g_zyw.clear()
         OPEN p_tgrup_count
#FUN-B50065------begin---
         IF STATUS THEN
            CLOSE p_tgrup_count
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         FETCH p_tgrup_count INTO g_row_count
#FUN-B50065------begin---
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE p_tgrup_count
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_tgrup_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_tgrup_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE              #No.FUN-6A0080
            CALL p_tgrup_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_tgrup_b()                                 # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,     # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,     # 檢查重複用        #No.FUN-680135 SMALLINT
            l_gau01         LIKE type_file.num5,     # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,     # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,     # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,     #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5      #No.FUN-680135      SMALLINT
   ###FUN-920138 START ###
   DEFINE l_gbo03_chk       LIKE gbo_file.gbo03      #檢查部門上線人數總和
   DEFINE l_gbo03           LIKE gbo_file.gbo03      #上線人數總和
   DEFINE l_i               LIKE type_file.num5   
   DEFINE l_str             STRING
   DEFINE l_str1            STRING  
   ###FUN-920138 END ###
   DEFINE l_cnt             LIKE type_file.num5      #MOD-A80044 
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   IF cl_null(g_zyw01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   LET g_forupd_sql= " SELECT zyw03,'' FROM zyw_file ",
                      " WHERE zyw01=? AND zyw03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_tgrup_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_zyw WITHOUT DEFAULTS FROM s_zyw.*
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
            LET g_zyw_t.* = g_zyw[l_ac].*    #BACKUP
            OPEN p_tgrup_bcl USING g_zyw01,g_zyw_t.zyw03
            IF STATUS THEN 
               CALL cl_err("OPEN p_tgrup_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_tgrup_bcl INTO g_zyw[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zyw_t.zyw03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
         IF l_ac <= l_n THEN
            SELECT gem02 INTO g_zyw[l_ac].gem02 FROM gem_file
             WHERE gem01 = g_zyw[l_ac].zyw03
            IF SQLCA.sqlcode THEN LET g_zyw[l_ac].gem02 = ' ' END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zyw[l_ac].* TO NULL       #900423
         LET g_zyw_t.* = g_zyw[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()                #FUN-550037(smin)
         NEXT FIELD zyw03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO zyw_file (zyw01,zyw02,zyw03,zyw04,zyw05,zywuser,zywgrup,zywmodu,zywdate,zyworiu,zyworig)    #No.TQC-640030 add zyw05   #No.MOD-7A0138 add zyw04
              VALUES (g_zyw01,g_zyw02,g_zyw[l_ac].zyw03,' ','0',       #No.TQC-640030 add zyw05  #No.MOD-7A0138 modify
                      g_user,g_grup,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zyw[l_ac].zyw03,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","zyw_file",g_zyw01,g_zyw[l_ac].zyw03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD zyw03
         IF NOT cl_null(g_zyw[l_ac].zyw03) THEN
            IF g_zyw[l_ac].zyw03 != g_zyw_t.zyw03 OR
              (g_zyw[l_ac].zyw03 IS NOT NULL AND g_zyw_t.zyw03 IS NULL) THEN
               SELECT COUNT(*) INTO l_n FROM zyw_file
                WHERE (zyw01 = g_zyw01 AND zyw03 = g_zyw[l_ac].zyw03) OR
                      (zyw01 = g_zyw01 AND zyw03 = g_zyw[l_ac].zyw03)
               IF l_n > 0 THEN
                  CALL cl_err(g_zyw[l_ac].zyw03,-239,0)
                  LET g_zyw[l_ac].zyw03 = g_zyw_t.zyw03
                  LET g_zyw[l_ac].gem02 = g_zyw_t.gem02
                  NEXT FIELD zyw03
               ELSE
                  SELECT gem02 INTO g_zyw[l_ac].gem02 FROM gem_file
                   WHERE gem01 = g_zyw[l_ac].zyw03 AND gemacti='Y'
                  IF STATUS=100 THEN   #資料不存在
                     #CALL cl_err(g_zyw[l_ac].zyw03,100,0)  #No.FUN-660081
                     CALL cl_err3("sel","gem_file",g_zyw[l_ac].zyw03,"",100,"","",0)    #No.FUN-660081
                     LET g_zyw[l_ac].zyw03 = g_zyw_t.zyw03
                     NEXT FIELD zyw03
                  END IF
               END IF
 
#              #TQC-5C0125
               SELECT count(*) INTO l_n FROM zyw_file
                WHERE zyw03=g_zyw[l_ac].zyw03
               IF l_n > 0 THEN
                  CALL cl_err_msg(NULL,"azz-230",g_zyw[l_ac].zyw03,10)
                  NEXT FIELD zyw03
               END IF
            END IF
            
            ###FUN-920138 START ###
            #檢查:部門群組上線人數 >= 各部門上線人數
            LET l_gbo03_chk = 0 
            #部門上線人數
            SELECT MAX(gbo03) INTO l_gbo03_chk
               FROM gbo_file
               WHERE gbo04='1' AND gbo02='Y'
                 AND gbo01 IN (select zyw03 from zyw_file where zyw01=g_zyw01)                           
                           
            LET l_gbo03 = 0
            SELECT gbo03 INTO l_gbo03 FROM gbo_file 
               WHERE gbo01 = g_zyw[l_ac].zyw03 AND gbo02 = "Y" AND gbo04 = '1'
            IF cl_null(l_gbo03) THEN 
               LET l_gbo03 = 0
            END IF               
            
            IF l_gbo03 > l_gbo03_chk THEN  #目前此筆資料的上線人數比較大,還沒新增也要算在內
               LET l_gbo03_chk = l_gbo03
            END IF            
            
            #部門群組上線人數
            LET l_gbo03 = 0
            SELECT gbo03 INTO l_gbo03 FROM gbo_file 
                  WHERE gbo01 = g_zyw01 AND gbo02 = "Y" AND gbo04 = '2'
            IF cl_null(l_gbo03) THEN 
               LET l_gbo03 = 0
            END IF
            
            IF l_gbo03_chk > 0 THEN
               IF l_gbo03 < l_gbo03_chk THEN
                  LET l_str = l_gbo03
                  LET l_str1 = l_gbo03_chk
                  LET l_str = l_str CLIPPED,"|",l_str1 CLIPPED
                  CALL cl_err_msg("","azz1006",l_str,1)
                  NEXT FIELD zyw03
               END IF 
            END IF
            ###FUN-920138 END ###
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_zyw_t.zyw03) THEN
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
            DELETE FROM zyw_file WHERE zyw01 = g_zyw01
                                   AND zyw03 = g_zyw[l_ac].zyw03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zyw_t.zyw03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zyw_file",g_zyw01,g_zyw_t.zyw03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
           #-MOD-A80044-add-
            SELECT count(*) INTO l_cnt
              FROM zyw_file
             WHERE zyw01 = g_zyw01 AND zyw05 = '0'
            IF l_cnt = 0 THEN
               DELETE FROM zyw_file WHERE zyw01 = g_zyw01
            END IF    
           #-MOD-A80044-add
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zyw[l_ac].* = g_zyw_t.*
            CLOSE p_tgrup_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("Primary Key CHANGING!","!",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zyw[l_ac].zyw03,-263,1)
            LET g_zyw[l_ac].* = g_zyw_t.*
         ELSE
            UPDATE zyw_file
               SET zyw03 = g_zyw[l_ac].zyw03
             WHERE zyw01 = g_zyw01
               AND zyw03 = g_zyw_t.zyw03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zyw[l_ac].zyw03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zyw_file",g_zyw01,g_zyw_t.zyw03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zyw[l_ac].* = g_zyw_t.*
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
               LET g_zyw[l_ac].* = g_zyw_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_zyw.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE p_tgrup_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034
         CLOSE p_tgrup_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(zyw03) AND l_ac > 1 THEN
            LET g_zyw[l_ac].* = g_zyw[l_ac-1].*
            NEXT FIELD zyw03
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(zyw03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_zyw[l_ac].zyw03
               CALL cl_create_qry() RETURNING g_zyw[l_ac].zyw03
               DISPLAY g_zyw[l_ac].zyw03 TO zyw03
               NEXT FIELD zyw03
         END CASE
 
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
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END INPUT
   CLOSE p_tgrup_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_tgrup_b_fill(p_wc)           #BODY FILL UP
   DEFINE p_wc   STRING
   DEFINE p_ac   LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
   LET g_sql = " SELECT zyw03,'' FROM zyw_file ",
               "  WHERE zyw01= '",g_zyw01 CLIPPED,"' ",
               "    AND ",p_wc CLIPPED,
               "    AND zyw05='0'",   #MOD-8C0054 add
               "  ORDER BY zyw03"
   PREPARE p_tgrup_prepare2 FROM g_sql           #預備一下
   DECLARE zyw_curs CURSOR FOR p_tgrup_prepare2
 
   CALL g_zyw.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH zyw_curs INTO g_zyw[g_cnt].*       #單身 ARRAY 填充
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      ELSE
         SELECT gem02 INTO g_zyw[g_cnt].gem02 FROM gem_file
          WHERE gem01=g_zyw[g_cnt].zyw03
         IF SQLCA.sqlcode THEN 
            LET g_zyw[g_cnt].gem02='' 
         END IF
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_zyw.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p_tgrup_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_zyw TO s_zyw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice="modify"
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
 
      ON ACTION output                           # O.列印
         LET g_action_choice="output"
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
 
      ON ACTION tgrupmgr                #TQC-5C0134
         LET g_action_choice="tgrupmgr"
         EXIT DISPLAY
      
      ###FUN-920138 START ###
      #部門與部門群組上限控管
      ON ACTION online_count
         LET g_action_choice = 'online_count'
         EXIT DISPLAY
      ###FUN-920138 END ###
 
      ON ACTION first                            # 第一筆
         CALL p_tgrup_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_tgrup_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_tgrup_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_tgrup_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_tgrup_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
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
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
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
 
FUNCTION p_tgrup_copy()
   DEFINE   l_n       LIKE type_file.num5,      #No.FUN-680135 SMALLINT
            l_newno   LIKE zyw_file.zyw01,
            l_oldno   LIKE zyw_file.zyw01
 
   IF g_zyw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_newno WITHOUT DEFAULTS FROM zyw01
      AFTER INPUT
         IF cl_null(l_newno) THEN
            NEXT FIELD zyw01
            LET INT_FLAG = 1
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_zyw01 TO zyw01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM zyw_file
    WHERE zyw01=g_zyw01 
      AND zyw03 NOT IN (SELECT zyw03 FROM zyw_file WHERE zyw01=l_newno)
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_zyw01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_zyw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET zyw01 = l_newno                         # 資料鍵值
 
   INSERT INTO zyw_file SELECT * FROM x 
 
   IF SQLCA.SQLCODE THEN
      #CALL cl_err('zyw:',SQLCA.SQLCODE,0)  #No.FUN-660081
      CALL cl_err3("ins","zyw_file",l_newno,"",SQLCA.sqlcode,"","zyw",0)    #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldno = g_zyw01
   LET g_zyw01 = l_newno
 
   CALL p_tgrup_b()
   #LET g_zyw01 = l_oldno #FUN-C30027
   #CALL p_tgrup_show()   #FUN-C30027
END FUNCTION
 
FUNCTION p_tgrup_out()
  DEFINE
     l_i    LIKE type_file.num5,          #No.FUN-680135 SMALLINT
     l_name LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680135 VARCHAR(20)
     l_za05 LIKE type_file.chr1000,       #No.FUN-680135 VARCHAR(40)
     l_chr  LIKE type_file.chr1,          #No.FUN-680135 VARCHAR(1)
     l_zyw  RECORD LIKE zyw_file.*
 
  IF g_wc IS NULL THEN
     CALL cl_err('','9057',0)
     RETURN
  END IF
 
  CALL cl_wait()
  CALL cl_outnam('p_tgrup') RETURNING l_name
 
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'p_tgrup'
  IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
  LET g_sql="SELECT * FROM zyw_file ",          # 組合出 SQL 指令
            " WHERE ",g_wc CLIPPED
  PREPARE p_tgrup_p1 FROM g_sql                # RUNTIME 編譯
  DECLARE p_tgrup_co CURSOR FOR p_tgrup_p1
 
  START REPORT p_tgrup_rep TO l_name
 
  FOREACH p_tgrup_co INTO l_zyw.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('Foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
 
     OUTPUT TO REPORT p_tgrup_rep(l_zyw.*)
  END FOREACH
 
  FINISH REPORT p_tgrup_rep
 
  CLOSE p_tgrup_co
  ERROR ""
  CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_tgrup_rep(sr)
  DEFINE
     sr              RECORD LIKE zyw_file.*,
     l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
     l_chr           LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
  OUTPUT
     TOP MARGIN g_top_margin
     LEFT MARGIN g_left_margin
     BOTTOM MARGIN g_bottom_margin
     PAGE LENGTH g_page_line
 
  ORDER BY sr.zyw01,sr.zyw03
 
  FORMAT
     PAGE HEADER
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
        LET g_pageno = g_pageno + 1
        PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
        PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
        PRINT ' '
        PRINT g_x[2] CLIPPED,g_today,' ',TIME,
              COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
        PRINT g_dash
        PRINT g_x[31],g_x[32],g_x[33],g_x[34]
        PRINT g_dash1
        LET l_trailer_sw = 'y'
 
     BEFORE GROUP OF sr.zyw01
        PRINT COLUMN g_c[31],sr.zyw01 CLIPPED,
              COLUMN g_c[32],sr.zyw02 CLIPPED
 
     ON EVERY ROW
        SELECT gem02 INTO g_gem02 FROM gem_file
         WHERE gem01=sr.zyw03 AND gem05='Y' AND gemacti='Y'
        IF STATUS=100 THEN LET g_gem02=' ' END IF
        PRINT COLUMN g_c[33],sr.zyw03 CLIPPED,
              COLUMN g_c[34],g_gem02 CLIPPED
 
     ON LAST ROW
        LET l_trailer_sw = 'n'
 
     PAGE TRAILER
        PRINT g_dash
        IF l_trailer_sw = 'n' THEN
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE 
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
        END IF
END REPORT
 
FUNCTION p_tgrup_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("zyw03",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION p_tgrup_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("zyw03",FALSE)
  END IF
 
END FUNCTION
