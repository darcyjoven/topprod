# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_zm.4gl
# Descriptions...: 系統目錄資料建立作業
# Date & Author..: 91/06/09 By LYS
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-4B0214 04/12/13 By saki 修改開窗
# Modify.........: No.MOD-530267 05/03/25 By alex 修正開窗部份 gaz+constriants
# Modify.........: No.MOD-540150 05/04/20 By alex 調整 cl_create_4sm 的 menu
# Modify.........: No.MOD-540163 05/04/29 By alex 刪除錯誤的 ORDER by 用法
# Modify.........: No.MOD-550123 05/05/18 By alex 刪除錯誤的 ORDER by 用法
# Modify.........: No.MOD-560063 05/06/14 By pengu  ls_sql 字串變數不夠大，導致組SQL字串異常。
# Modify.........: No.FUN-560181 05/07/03 By pengu p_zz未維護menu的名稱到p_zm新增時,會error此menu不存在
#                                調整p_zm的error message,讓user知道原來是名稱未維護
# Modify.........: NO.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: NO.MOD-590329 05/10/04 By yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.TQC-660058 06/06/28 By Pengu ls_sql LIKE type_file.chr1000,ls_where VARCHAR(700) 應改為用string        #No.FUN-680135
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740059 07/04/12 By chenl   修正點擊更改后再點擊新增錯誤的問題。
# Modify.........: No.MOD-8C0028 08/12/03 By Sarah 將zm01放大成20碼
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-C40086 12/04/11 By Elise 修改UPDATE zm_file SET zm03 = zm03 + 1 WHERE zm03 = j AND zm01 = g_zm01
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zm01              LIKE zm_file.zm01,      #目錄代號 (假單頭)   #MOD-8C0028
         g_zm01_t            LIKE zm_file.zm01,      #目錄代號 (舊值)
         g_zm                DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
            zm03             LIKE zm_file.zm03,      #目錄序號
            zm04             LIKE zm_file.zm04,      #程式代號
            gaz03            LIKE gaz_file.gaz03     #程式名稱
                             END RECORD,
         g_zm_t              RECORD                  #程式變數 (舊值)
            zm03             LIKE zm_file.zm03,      #目錄序號
            zm04             LIKE zm_file.zm04,      #程式代號
            gaz03            LIKE gaz_file.gaz03     #程式名稱
                             END RECORD,
         g_name              LIKE zm_file.zm04,      #No.FUN-680135 VARCHAR(10)
         g_wc,g_sql          string,                 #No.FUN-580092 HCN
         g_rec_b             LIKE type_file.num10,   #單身筆數      #No.FUN-680135 INTEGER
         g_ss                LIKE type_file.chr1,    #決定後續步驟  #No.FUN-680135 VARCHAR(1)
         l_ac                LIKE type_file.num5,    #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
         g_argv1             LIKE zm_file.zm01       #No.FUN-680135 VARCHAR(10)
DEFINE   g_zx                DYNAMIC ARRAY OF RECORD
            zx05             LIKE zx_file.zx05,
            m_do             LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
                             END RECORD
DEFINE   g_zx05_check        LIKE type_file.num5,    #檢查zx05有的menu     #No.FUN-680135 SMALLINT
         g_zm01_check        LIKE type_file.num5,    #檢查對下child的關係  #No.FUN-680135 SMALLINT
         g_zm04_check        LIKE type_file.num5,    #檢查對上parent的關係 #No.FUN-680135 SMALLINT
         redo_m_check        LIKE type_file.num5     #程式離開時是否要產生有更改的menu #No.FUN-680135 SMALLINT
DEFINE   g_change_menu       DYNAMIC ARRAY OF RECORD
            menu_name        LIKE zm_file.zm01       #將執行程式中有修改的menu(對應zx05)名稱放在此處
                             END RECORD
DEFINE   g_change_menu_cnt   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5     #NO.MOD-580056 #No.FUN-680135 SMALLINT
DEFINE   g_chr              LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt              LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE   g_i                LIKE type_file.num5      #count/index for any purpose  #No.FUN-680135 SMALLINT
DEFINE   g_msg              LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql       STRING                   #SELECT ... FOR UPDATE SQL
DEFINE   g_curs_index      LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE   g_row_count        LIKE type_file.num10     #No.FUN-580092 HCN   #No.FUN-680135 INTEGER
DEFINE   g_jump            LIKE type_file.num10,    #No.FUN-680135 INTEGER
         g_no_ask          LIKE type_file.num5      #No.FUN-680135 SMALLINT
 
MAIN
   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1) 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
 
   LET g_zm01 = NULL                     #清除鍵值
   LET g_zm01_t = NULL
 
   OPEN WINDOW p_zm_w WITH FORM "azz/42f/p_zm"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN CALL p_zm_q() END IF
 
   CALL p_zm_zx05_prepare()                 #zx05有的menu才需要建立4sm檔案
   LET g_change_menu_cnt = 1
   LET g_change_menu[g_change_menu_cnt].menu_name = " "
 
   CALL p_zm_menu()
   CLOSE WINDOW p_zm_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p_zm_curs()
 
   IF cl_null(g_argv1) THEN
      CLEAR FORM                             #清除畫面
      CALL g_zm.clear()
      CALL cl_set_head_visible("grid01","YES")   #No.FUN-6A0092
      CONSTRUCT g_wc ON zm01,zm03,zm04 FROM zm01,s_zm[1].zm03,s_zm[1].zm04
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(zm01)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_menu"             #MOD-4B0214
                  LET g_qryparam.arg1 = g_lang
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zm01
 
               WHEN INFIELD(zm04)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaz"             #MOD-4B0214
                  LET g_qryparam.arg1 = g_lang
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zm04
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc=" zm01='",g_argv1,"'"
   END IF
 
   LET g_sql= "SELECT UNIQUE zm01 FROM zm_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY 1"
   DISPLAY g_sql
   PREPARE p_zm_prepare FROM g_sql      #預備一下
   DECLARE p_zm_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR p_zm_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT zm01) FROM zm_file ",
              " WHERE ", g_wc CLIPPED
   PREPARE p_zm_precount FROM g_sql
   DECLARE p_zm_count CURSOR FOR p_zm_precount
 
END FUNCTION
 
FUNCTION p_zm_menu()
 
   WHILE TRUE
      CALL p_zm_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL p_zm_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_zm_q()
            END IF
         WHEN "next"
            CALL p_zm_fetch('N')
         WHEN "previous"
            CALL p_zm_fetch('P')
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               IF g_chkey='Y' THEN   #No.TQC-740059
                  CALL p_zm_u()
               END IF                #No.TQC-740059
            END IF
         WHEN "execute"
            LET g_msg="udm ",g_zm01 RUN g_msg
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL p_zm_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                 CALL p_zm_copy()
            END IF
#genero
#         WHEN "output" OR "列印'系統結構表'及'程式總覽'"
#            IF cl_chk_act_auth() THEN
#                     WHEN "1.系統結構表" CALL p_zm_o1()
#                     WHEN "2.程式總覽"   CALL p_zm_o2()
#                     WHEN "exit"     EXIT WHILE
#            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               MENU "Popup Menu" ATTRIBUTE(STYLE="popup")
                  ON ACTION system_structure
                     CALL p_zm_o1()
                  ON ACTION program_view
                     CALL p_zm_o2()
               END MENU
            END IF
         WHEN  "help"
            CALL cl_show_help()
         WHEN  "exit"
            IF g_change_menu.getLength() > 0 AND NOT cl_null(g_change_menu[1].menu_name) THEN
               CALL p_zm_redo_menu(TRUE)
            END IF
            EXIT WHILE
         WHEN  "redomenu"
            IF cl_chk_act_auth() THEN
               CALL p_zm_redo_menu(FALSE)
            END IF
         WHEN  "jump"
            CALL p_zm_fetch('/')
         WHEN  "first"
            CALL p_zm_fetch('F')
         WHEN  "last"
            CALL p_zm_fetch('L')
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zm),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_zm_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_zm.clear()
   INITIALIZE g_zm01 LIKE zm_file.zm01
   LET g_zm01_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_zm_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_zm.clear()
         LET g_rec_b = 0
      ELSE
         CALL p_zm_b_fill(0)         #單身
      END IF
 
      CALL p_zm_b()                   #輸入單身
 
      LET g_zm01_t = g_zm01            #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION p_zm_u()
 
   IF g_zm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zm01_t = g_zm01
 
   WHILE TRUE
      CALL p_zm_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET g_zm01=g_zm01_t
         DISPLAY g_zm01 TO zm01               #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_zm01 != g_zm01_t THEN             #更改單頭值
         UPDATE zm_file SET zm01 = g_zm01  #更新DB
          WHERE zm01 = g_zm01_t          #COLAUTH?
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zm01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("upd","zm_file",g_zm01_t,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CONTINUE WHILE
         END IF
         UPDATE zm_file SET zm04 = g_zm01
          WHERE zm04 = g_zm01_t
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zm01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("upd","zm_file",g_zm01_t,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CONTINUE WHILE
         END IF
         CALL p_zm_changed_menu(g_zm01)
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_zm_i(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1    #a:輸入 u:更改        #No.FUN-680135 VARCHAR(1)
 
 
   LET g_ss='Y'
   CALL cl_set_head_visible("grid01","YES")   #No.FUN-6A0092
   INPUT g_zm01 WITHOUT DEFAULTS FROM zm01
 
    #NO.MOD-580056------
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_zm_set_entry(p_cmd)
         CALL p_zm_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   #--------END
 
 
      AFTER FIELD zm01                  #目錄代號
         IF NOT cl_null(g_zm01) THEN
            IF g_zm01 != g_zm01_t OR g_zm01_t IS NULL THEN
               SELECT UNIQUE zm01 INTO g_chr
                 FROM zm_file
                WHERE zm01=g_zm01
               IF SQLCA.sqlcode THEN             #不存在, 新來的
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_zm01,-239,0)
                     LET g_zm01=g_zm01_t
                     NEXT FIELD zm01
                  END IF
               END IF
            END IF
            CALL p_zm_zm01(p_cmd)
            IF g_chr = 'E' THEN
               CALL cl_err('','azz-705',1)   #No.FUN-560181 modify
               NEXT FIELD zm01
            END IF
            IF p_cmd = 'u' THEN
#----genero----檢查修改後的新值對child的遞迴---add
               CALL p_zm_child_check(g_zm01,g_zm01_t)
               IF NOT g_zm01_check THEN
                  CALL cl_err_msg("","azz-700",g_zm01,-1)
                  NEXT FIELD zm01
               END IF
#------------------------------------------------
#----genero----檢查修改後的新值對parent的遞迴---add
               CALL p_zm_parent_check(g_zm01,g_zm01_t)
               IF NOT g_zm04_check THEN
                  CALL cl_err_msg("","azz-701",g_zm01,-1)
                  NEXT FIELD zm01
               END IF
#-------------------------------------------------
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(zm01)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_menu"             #MOD-4B0214
               LET g_qryparam.default1 = g_zm01
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_zm01
               DISPLAY g_zm01 TO zm01
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION  p_zm_zm01(p_cmd)
 
   # 2004/04/22 多語言架構調整 zz02 -> gaz03
   DEFINE   p_cmd     LIKE type_file.chr1,       #No.FUN-680135 VARCHAR(1)
#           l_zz02    VARCHAR(30),
#           l_zz02e   VARCHAR(30),
#           l_zz02c   VARCHAR(30),
            l_gaz03   LIKE gaz_file.gaz03
 
#  SELECT zz02,zz02e,zz02c INTO l_zz02,l_zz02e,l_zz02c
#    FROM zz_file
#   WHERE zz01 = g_zm01
 
 #  #MOD-540163
#  SELECT gaz03 INTO l_gaz03 FROM gaz_file
#   WHERE gaz01=g_zm01 AND gaz02=g_lang ORDER by gaz05
   CALL cl_get_progname(g_zm01,g_lang) RETURNING l_gaz03
 
   IF SQLCA.sqlcode THEN
      LET g_chr = 'E'
      LET l_gaz03 = NULL
      RETURN
   END IF
 
   LET g_chr = ' '
 
#  CASE
#     WHEN g_lang = '1'  LET l_zz02=l_zz02e
#     WHEN g_lang = '2'  LET l_zz02=l_zz02c
#     OTHERWISE EXIT CASE
#  END CASE
 
   IF p_cmd = 'a' THEN
      DISPLAY l_gaz03 TO gaz03h
   END IF
END FUNCTION
 
FUNCTION p_zm_child_check(ls_check_zm01,ls_zm01)
   DEFINE   ls_sql          LIKE type_file.chr1000,#No.FUN-680135 VARCHAR(500)
            l_ac            LIKE type_file.num5,   #No.FUN-680135 SMALLINT
            ls_zm04_cnt     LIKE type_file.num5,   #No.FUN-680135 SMALLINT
            ls_not_start    LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_zm01         LIKE zm_file.zm01,
            ls_check_zm01   LIKE zm_file.zm01
   DEFINE   la_zm04         DYNAMIC ARRAY OF RECORD
               zm04         LIKE zm_file.zm04
                            END RECORD
   DEFINE   lr_zm04         RECORD
               zm04         LIKE zm_file.zm04
                            END RECORD
   DEFINE   lc_zm03         LIKE zm_file.zm03
 
 
   LET g_zm01_check = TRUE
   DECLARE lcurs_zm04 CURSOR FOR
    SELECT zm04,zm03 FROM zm_file WHERE zm01 = ls_zm01 ORDER BY zm03
 #   SELECT zm04 FROM zm_file WHERE zm01 = ls_zm01 ORDER BY zm03  #MOD-550123
 
   LET l_ac = 1
    FOREACH lcurs_zm04 INTO lr_zm04.zm04,lc_zm03                  #MOD-550123
      IF SQLCA.sqlcode THEN
         CALL cl_err("OPEN lcurs_zm04:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET la_zm04[l_ac].* = lr_zm04.*
      LET l_ac = l_ac + 1
   END FOREACH
 
   FOR l_ac = 1 TO la_zm04.getLength()
      IF la_zm04[l_ac].zm04 = ls_check_zm01 THEN
         LET g_zm01_check = FALSE
         EXIT FOR
      END IF
      SELECT COUNT(*) INTO ls_zm04_cnt FROM zm_file
       WHERE zm01 = la_zm04[l_ac].zm04
      IF ls_zm04_cnt > 0 THEN
         CALL p_zm_child_check(ls_check_zm01,la_zm04[l_ac].zm04)
      END IF
   END FOR
   IF NOT g_zm01_check THEN
      RETURN
   END IF
END FUNCTION
 
FUNCTION p_zm_q()
 
     LET g_row_count = 0 #No.FUN-580092 HCN
    LET g_curs_index = 0
     CALL cl_navigator_setting(g_curs_index,g_row_count) #No.FUN-580092 HCN
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL p_zm_curs()                           #取得查詢條件
 
   IF INT_FLAG THEN                           #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_zm_count
    FETCH p_zm_count INTO g_row_count         #No.FUN-580092 HCN
    DISPLAY g_row_count TO FORMONLY.cnt       #No.FUN-580092 HCN
 
   OPEN p_zm_b_curs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                      #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_zm01 TO NULL
   ELSE
      CALL p_zm_fetch('F')                    #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION p_zm_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,     #處理方式   #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10     #絕對的筆數 #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_zm_b_curs INTO g_zm01
      WHEN 'P' FETCH PREVIOUS p_zm_b_curs INTO g_zm01
      WHEN 'F' FETCH FIRST    p_zm_b_curs INTO g_zm01
      WHEN 'L' FETCH LAST     p_zm_b_curs INTO g_zm01
      WHEN '/'
            IF (NOT g_no_ask) THEN
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
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump p_zm_b_curs INTO g_zm01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_zm01,SQLCA.sqlcode,0)
      INITIALIZE g_zm01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count #No.FUN-580092 HCN
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
       CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
      CALL p_zm_show()
   END IF
 
END FUNCTION
 
FUNCTION p_zm_show()
 
   DISPLAY g_zm01 TO zm01              #單頭
 
   CALL p_zm_zm01('a')                 #單身
 
   CALL p_zm_b_fill(0)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_zm_r()
 
   IF g_zm01 IS NULL THEN
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM zm_file WHERE zm01 = g_zm01
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","zm_file",g_zm01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_zm.clear()
         OPEN p_zm_count
#FUN-B50065------begin---
         IF STATUS THEN
            CLOSE p_zm_count
            RETURN
         END IF
#FUN-B50065------end------
          FETCH p_zm_count INTO g_row_count #No.FUN-580092 HCN
#FUN-B50065------begin---
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE p_zm_count
             RETURN
          END IF
#FUN-B50065------end------

          DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
         OPEN p_zm_b_curs
          IF g_curs_index = g_row_count + 1 THEN #No.FUN-580092 HCN
             LET g_jump = g_row_count #No.FUN-580092 HCN
            CALL p_zm_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL p_zm_fetch('/')
         END IF
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p_zm_b()
   DEFINE   l_ac_t           LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680135 SMALLINT 
            l_n              LIKE type_file.num5,                #檢查重複用         #No.FUN-680135 SMALLINT
            l_lock_sw        LIKE type_file.chr1,                #單身鎖住否         #No.FUN-680135 VARCHAR(1)
            p_cmd            LIKE type_file.chr1,                #處理狀態           #No.FUN-680135 VARCHAR(1)
            l_allow_insert   LIKE type_file.num5,                #可新增否           #No.FUN-680135 SMALLINT
            l_allow_delete   LIKE type_file.num5,                #可刪除否           #No.FUN-680135 SMALLINT
            ls_cnt           LIKE type_file.num5                 #No.FUN-680135      SMALLINT
 
#  DEFINE   l_zz02    LIKE zz_file.zz02,
#           l_zz02e   LIKE zz_file.zz02e,
#           l_zz02c   LIKE zz_file.zz02c
   DEFINE   l_gaz03   LIKE gaz_file.gaz03
 
   LET g_action_choice = ""
 
   IF g_zm01 IS NULL THEN
      RETURN
   END IF
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
       "SELECT zm03,zm04 FROM zm_file WHERE zm01=? AND zm03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zm_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
   INPUT ARRAY g_zm WITHOUT DEFAULTS FROM s_zm.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET g_zm_t.* = g_zm[l_ac].*  #BACKUP
            LET p_cmd='u'
#NO.MOD-590329 MARK------------------
 #No.MOD-580056 --start
#            LET g_before_input_done = FALSE
#            CALL p_zm_set_entry_b(p_cmd)
#            CALL p_zm_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK-----------------
            OPEN p_zm_b_curl USING g_zm01,g_zm_t.zm03
            IF STATUS THEN
               CALL cl_err("OPEN p_zm_b_cur1:",STATUS,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_zm_b_curl INTO g_zm[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zm_t.zm03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL p_zm_zm04(p_cmd)
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zm[l_ac].* TO NULL      #900423
         LET g_zm_t.* = g_zm[l_ac].*         #新輸入資料
#NO.MOD-590329 MARK-----------------------
 #No.MOD-580056 --start
#         LET g_before_input_done = FALSE
#         CALL p_zm_set_entry_b(p_cmd)
#         CALL p_zm_set_no_entry_b(p_cmd)
#         LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK-----------------------
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD zm03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO zm_file(zm01,zm03,zm04)
              VALUES(g_zm01,g_zm[l_ac].zm03,g_zm[l_ac].zm04)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zm[l_ac].zm03,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","zm_file",g_zm01,g_zm[l_ac].zm03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            COMMIT WORK
            CALL p_zm_changed_menu(g_zm01)
         END IF
 
      BEFORE FIELD zm03                        #default 序號
         # 2004/06/28 by saki : 只有update才需要作下面此段，否則會造成array size錯誤
         IF p_cmd = 'u' THEN
            IF (g_zm[l_ac].zm03 IS NULL OR g_zm[l_ac].zm03=0) AND l_ac>1 THEN
               IF g_zm[l_ac+1].zm03>g_zm[l_ac-1].zm03+1 THEN
                  LET g_zm[l_ac].zm03=g_zm[l_ac-1].zm03+1
               END IF
            END IF
         END IF
         IF g_zm[l_ac].zm03 IS NULL OR g_zm[l_ac].zm03 = 0 THEN
            SELECT max(zm03)+1
              INTO g_zm[l_ac].zm03
              FROM zm_file
             WHERE zm01 = g_zm01
            IF g_zm[l_ac].zm03 IS NULL THEN
               LET g_zm[l_ac].zm03 = 1
            END IF
         END IF
 
      AFTER FIELD zm03                        #check 序號是否重複
         IF NOT cl_null(g_zm[l_ac].zm03) THEN
            IF g_zm[l_ac].zm03 != g_zm_t.zm03 OR g_zm_t.zm03 IS NULL THEN
               SELECT count(*)
                 INTO l_n
                 FROM zm_file
                WHERE zm01 = g_zm01
                  AND zm03 = g_zm[l_ac].zm03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_zm[l_ac].zm03 = g_zm_t.zm03
                  NEXT FIELD zm03
               END IF
            END IF
         END IF
 
      AFTER FIELD zm04
         IF NOT cl_null(g_zm[l_ac].zm04) THEN
            CALL p_zm_zm04(p_cmd)
             IF g_chr = 'E' THEN                     # MOD-4B0006
               CALL cl_err('',"azz-705",1)
               NEXT FIELD zm04
            END IF
#----genero----檢查修改後的新值對parent的遞迴---add
            IF g_zm01 = g_zm[l_ac].zm04 THEN
               LET g_zm04_check = FALSE
            ELSE
               CALL p_zm_parent_check(g_zm[l_ac].zm04,g_zm01)
            END IF
            IF NOT g_zm04_check THEN
               CALL cl_err_msg("","azz-702",g_zm[l_ac].zm04,-1)
               NEXT FIELD zm04
            END IF
#--------------------------------------------------
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_zm_t.zm03 > 0 AND g_zm_t.zm03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM zm_file
             WHERE zm01 = g_zm01
               AND zm03 = g_zm_t.zm03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zm_t.zm03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zm_file",g_zm01,g_zm_t.zm03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            CALL p_zm_changed_menu(g_zm01)
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zm[l_ac].* = g_zm_t.*
            CLOSE p_zm_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zm[l_ac].zm03,-263,1)
            LET g_zm[l_ac].* = g_zm_t.*
         ELSE
            UPDATE zm_file SET zm03=g_zm[l_ac].zm03,
                               zm04=g_zm[l_ac].zm04
             WHERE zm01=g_zm01
               AND zm03=g_zm_t.zm03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zm[l_ac].zm03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zm_file",g_zm01,g_zm_t.zm03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zm[l_ac].* = g_zm_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
               CALL p_zm_changed_menu(g_zm01)
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30034 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_zm[l_ac].* = g_zm_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_zm.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE p_zm_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30034 Add
         CLOSE p_zm_b_curl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(zm04)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gaz"               # MOD-4B0214
               LET g_qryparam.default1 = g_zm[l_ac].zm04
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_zm[l_ac].zm04
#               CALL FGL_DIALOG_SETBUFFER( g_zm[l_ac].zm04 )
               DISPLAY g_zm[l_ac].zm04 TO zm04
            OTHERWISE
               EXIT CASE
         END CASE
 
#     ON ACTION CONTROLN
#        CALL p_zm_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(zm03) AND l_ac > 1 THEN
            LET g_zm[l_ac].* = g_zm[l_ac-1].*
            NEXT FIELD zm03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION re_sort
         CASE WHEN INFIELD(zm03) CALL p_zm_b_y()
                                 CALL p_zm_b_fill(0)
                                 EXIT INPUT
              WHEN INFIELD(zm04) CALL cl_cmdrun('p_zz')
         END CASE
 
      ON ACTION below_all
         CALL p_zm_b_u()
 
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
         CALL cl_set_head_visible("grid01","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END INPUT
 
   CLOSE p_zm_b_curl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p_zm_b_y()
   DEFINE r,i,j LIKE type_file.num10   #No.FUN-680135 INTEGER
 
   DECLARE p_zm_b_y_c CURSOR FOR
    SELECT zm03 FROM zm_file WHERE zm01=g_zm01 ORDER BY zm03
 
 
   BEGIN WORK
   LET g_success = 'Y'
   LET i=0
 
   FOREACH p_zm_b_y_c INTO j
      IF STATUS THEN
         CALL cl_err('foreach',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET i=i+1
      UPDATE zm_file SET zm03 = i WHERE zm03 = j
      IF STATUS THEN
         #CALL cl_err('upd zm03',STATUS,1)  #No.FUN-660081
         CALL cl_err3("upd","zm_file",g_zm01,j,SQLCA.sqlcode,"","upd zm03",1)    #No.FUN-660081
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
 
 
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF
 
END FUNCTION
 
FUNCTION p_zm_b_u()
   DEFINE r,i,j LIKE type_file.num10   #No.FUN-680135 INTEGER
 
   DECLARE p_zm_b_u_c CURSOR FOR
    SELECT zm03 FROM zm_file
     WHERE zm01 = g_zm01 AND zm03 >= g_zm[l_ac].zm03
     ORDER BY zm03 DESC
 
 
   BEGIN WORK
   LET g_success = 'Y'
 
   FOREACH p_zm_b_u_c INTO j
      IF STATUS THEN
         CALL cl_err('foreach',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
     #UPDATE zm_file SET zm03 = zm03 + 1 WHERE zm03 = j  #MOD-C40086 mark
      UPDATE zm_file SET zm03 = zm03 + 1                 #MOD-C40086
       WHERE zm03 = j
         AND zm01 = g_zm01

      IF STATUS THEN
         #CALL cl_err('upd zm03',STATUS,1)  #No.FUN-660081
         CALL cl_err3("upd","zm_file",g_zm01,j,SQLCA.sqlcode,"","upd zm03",1)    #No.FUN-660081
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
 
 
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF
 
   FOR i = l_ac TO g_zm.getLength()
      IF g_zm[i].zm03 IS NOT NULL THEN
         LET g_zm[i].zm03 = g_zm[i].zm03 + 1
         LET j = j + 1
      END IF
   END FOR
 
   LET g_zm_t.zm03 = g_zm[l_ac].zm03
 
END FUNCTION
 
FUNCTION p_zm_zm04(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,      #No.FUN-680135 VARCHAR(1)
#           l_zz02e   LIKE zz_file.zz02e,
#           l_zz02c   LIKE zz_file.zz02c
            l_cnt     LIKE type_file.num10      #No.FUN-680135 INTEGER
 
#  CALL p_zm_name(g_zm[l_ac].zm04) RETURNING g_name
 
#  SELECT zz02,zz02e,zz02c
#    INTO g_zm[l_ac].zz02,l_zz02e,l_zz02c
#    FROM zz_file
#   WHERE zz01 = g_zm[l_ac].zm04
 
 #  #MOD-540163
#  SELECT COUNT(gaz03) INTO l_cnt FROM gaz_file
#   WHERE gaz01=g_zm[l_ac].zm04 AND gaz02=g_lang AND gaz05 = 'Y'
 
 #  IF l_cnt > 0 THEN                                   # MOD-4B0165
#     SELECT gaz03 INTO g_zm[l_ac].gaz03 FROM gaz_file
#      WHERE gaz01=g_zm[l_ac].zm04 AND gaz02=g_lang AND gaz05='Y'
#  ELSE
#     SELECT gaz03 INTO g_zm[l_ac].gaz03 FROM gaz_file
#      WHERE gaz01=g_zm[l_ac].zm04 AND gaz02=g_lang AND gaz05='N'
#  END IF
   CALL cl_get_progname(g_zm[l_ac].zm04,g_lang) RETURNING g_zm[l_ac].gaz03
 
   IF SQLCA.sqlcode THEN
      LET g_chr = 'E'
      LET g_zm[l_ac].gaz03 = NULL
      RETURN
   END IF
 
#  CASE
#     WHEN g_lang = '1' LET g_zm[l_ac].zz02=l_zz02e
#     WHEN g_lang = '2' LET g_zm[l_ac].zz02=l_zz02c
#     OTHERWISE EXIT CASE
#  END CASE
   LET g_chr = ' '
   DISPLAY g_zm[l_ac].gaz03 TO gaz03
#  DISPLAY g_zm[l_ac].zz02 TO zz02
 
END FUNCTION
 
FUNCTION p_zm_name(p_name)
   DEFINE   p_name   LIKE zm_file.zm04      #No.FUN-680135 VARCHAR(10)
   DEFINE   l_name   LIKE zm_file.zm04      #No.FUN-680135 VARCHAR(10)
   DEFINE   i	     LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
#  FOR i = 1 TO 10
#     IF p_name[i,i] = ' ' OR p_name[i,i] IS NULL THEN EXIT FOR END IF
#     LET l_name[i,i]=p_name[i,i]
#  END FOR
   LET l_name=p_name
   RETURN l_name
 
END FUNCTION
 
FUNCTION p_zm_b_askkey()
DEFINE
   l_begin_key     LIKE zm_file.zm03
 
   CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
   PROMPT g_msg CLIPPED,': ' FOR l_begin_key
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
      RETURN
   END IF
 
   IF l_begin_key IS NULL THEN
      LET l_begin_key = 0
   END IF
 
   CALL p_zm_b_fill(l_begin_key)
 
END FUNCTION
 
FUNCTION p_zm_b_fill(p_key)              #BODY FILL UP
 
   DEFINE p_key  LIKE zm_file.zm03
 
   DECLARE zm_curs CURSOR FOR
       SELECT zm03,zm04 FROM zm_file
        WHERE zm01 = g_zm01 AND zm03 >= p_key
        ORDER BY zm03
 
   CALL g_zm.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH zm_curs INTO g_zm[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_rec_b = g_rec_b + 1
 
      CALL p_zm_name(g_zm[g_cnt].zm04) RETURNING g_name
 
 #     #MOD-5401163
#     SELECT gaz03 INTO g_zm[g_cnt].gaz03 FROM gaz_file
#      WHERE gaz01 = g_name AND gaz02 = g_lang ORDER by gaz05
      CALL cl_get_progname(g_name,g_lang) RETURNING g_zm[g_cnt].gaz03
 
#     CASE
#        WHEN g_lang = '0'
#           SELECT zz02 INTO g_zm[g_cnt].zz02 FROM zz_file WHERE zz01 = g_name
#        WHEN g_lang = '2'
#           SELECT zz02c INTO g_zm[g_cnt].zz02 FROM zz_file WHERE zz01 = g_name
#        OTHERWISE
#           SELECT zz02e INTO g_zm[g_cnt].zz02 FROM zz_file WHERE zz01 = g_name
#     END CASE
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_zm.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_zm_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_zm TO s_zm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index,g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION redomenu
         LET g_action_choice="redomenu"
         EXIT DISPLAY
 
      ON ACTION first
         CALL p_zm_fetch('F')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL p_zm_fetch('P')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL p_zm_fetch('/')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL p_zm_fetch('L')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL p_zm_fetch('N')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
#      ON ACTION X.執行
#         LET g_action_choice="X.執行"
#         EXIT DISPLAY
#      ON ACTION 1.系統結構表
#         LET g_action_choice=.系統結構表"
#         EXIT DISPLAY
#      ON ACTION 2.程式總覽
#         LET g_action_choice=.程式總覽"
#         EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("grid01","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_zm_copy()
DEFINE
   l_newno         LIKE zm_file.zm01
 
   IF g_zm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("grid01","YES")   #No.FUN-6A0092
   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
   PROMPT g_msg CLIPPED,': ' FOR l_newno
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
 
   IF INT_FLAG OR l_newno IS NULL THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   SELECT count(*) INTO g_cnt FROM zm_file
    WHERE zm01 = l_newno
 
   IF g_cnt > 0 THEN
      CALL cl_err(g_zm01,-239,0)
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM zm_file WHERE zm01=g_zm01 INTO TEMP x
 
   UPDATE x SET zm01=l_newno     #資料鍵值
 
   INSERT INTO zm_file SELECT * FROM x
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_zm01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","zm_file",l_newno,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K'
      LET g_zm01 = l_newno  #FUN-C30027
      CALL p_zm_show()      #FUN-C30027
   END IF
 
END FUNCTION
 
FUNCTION p_zm_parent_check(ls_check_zm04,ls_zm04)
   DEFINE   ls_sql          LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(500)
            l_ac            LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            ls_zm01_cnt     LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            ls_not_start    LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            ls_zm01_check   LIKE type_file.num5     #No.FUN-680135 SMALLINT 
   DEFINE   ls_zm04         LIKE zm_file.zm04,
            ls_check_zm04   LIKE zm_file.zm04
   DEFINE   p_cmd           LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
   DEFINE   la_zm01         DYNAMIC ARRAY OF RECORD
               zm01         LIKE zm_file.zm01
                            END RECORD
   DEFINE   lr_zm01         RECORD
               zm01         LIKE zm_file.zm01
                            END RECORD
    DEFINE   lc_zm03        LIKE zm_file.zm03       #MOD-550123
 
 
   LET g_zm04_check = TRUE
   DECLARE lcurs_zm01 CURSOR FOR
    SELECT zm01,zm03 FROM zm_file WHERE zm04 = ls_zm04 ORDER BY zm03
 #   SELECT zm01 FROM zm_file WHERE zm04 = ls_zm04 ORDER BY zm03  #MOD-550123
 
   LET l_ac = 1
 #  FOREACH lcurs_zm01 INTO lr_zm01.zm01                          #MOD-550123
    FOREACH lcurs_zm01 INTO lr_zm01.zm01,lc_zm03                  #MOD-550123
      IF SQLCA.sqlcode THEN
         CALL cl_err("OPEN lcurs_zm01:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET la_zm01[l_ac].* = lr_zm01.*
      LET l_ac = l_ac + 1
   END FOREACH
 
   FOR l_ac = 1 TO la_zm01.getLength()
      IF la_zm01[l_ac].zm01 = ls_check_zm04 THEN
         LET g_zm04_check = FALSE
         EXIT FOR
      END IF
      SELECT COUNT(*) INTO ls_zm01_cnt FROM zm_file
       WHERE zm04 = la_zm01[l_ac].zm01
      IF ls_zm01_cnt > 0 THEN
         CALL p_zm_parent_check(ls_check_zm04,la_zm01[l_ac].zm01)
      END IF
   END FOR
   IF NOT g_zm04_check THEN
      RETURN
   END IF
END FUNCTION
 
FUNCTION p_zm_zx05_prepare()
   DEFINE   ls_sql    LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(500)
   DEFINE   lr_zx     RECORD
               zx05   LIKE zx_file.zx05,
               m_do   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
                      END RECORD
 
 
   LET ls_sql = "SELECT UNIQUE(zx05),'N' FROM zx_file"
   DECLARE zx05_curs CURSOR FROM ls_sql
 
   LET l_ac = 1
   FOREACH zx05_curs INTO lr_zx.*
      IF SQLCA.sqlcode THEN
         CALL cl_err("zx05-FOREACH:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_zx[l_ac].* = lr_zx.*
      LET l_ac = l_ac + 1
   END FOREACH
END FUNCTION
 
FUNCTION p_zm_zx05_check(ls_zm01)
   DEFINE   l_ac       LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_zm01    LIKE zm_file.zm01
 
   LET g_zx05_check = FALSE
   FOR l_ac = 1 TO g_zx.getLength()
       IF ls_zm01 = g_zx[l_ac].zx05 AND g_zx[l_ac].m_do = 'N' THEN
          LET g_zx05_check = TRUE
          LET g_zx[l_ac].m_do = 'Y'
       END IF
   END FOR
 
END FUNCTION
 
FUNCTION p_zm_changed_menu(zm01start)
   DEFINE   zm01start  LIKE zm_file.zm01
   DEFINE   ls_check   LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            ls_start   LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            ls_not_in  LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            li_i       LIKE type_file.num10,   #No.FUN-680135 INTEGER
            li_i2      LIKE type_file.num10    #No.FUN-680135 INTEGER
    DEFINE  ls_sql     STRING,                 #No.MOD-560063 #No.TQC-660058 modify 
            ls_where   STRING                  #No.TQC-660058 modify
   DEFINE   la_zm01    DYNAMIC ARRAY OF RECORD
            zm01       LIKE zm_file.zm01
                       END RECORD
   DEFINE   lr_zm01    RECORD
            zm01       LIKE zm_file.zm01
                       END RECORD
 
 
   FOR li_i2 = 1 TO g_zx.getLength()
      LET g_zx[li_i2].m_do = 'N'
   END FOR
 
   LET ls_check = TRUE
   LET la_zm01[1].zm01 = zm01start
   WHILE ls_check
      LET ls_where = NULL
      FOR li_i = 1 TO la_zm01.getLength()
         CALL redo_menu_check(la_zm01[li_i].zm01)
         LET ls_where = ls_where CLIPPED," zm04 = '",la_zm01[li_i].zm01 CLIPPED,"'"
         IF li_i < la_zm01.getLength() THEN
            LET ls_where = ls_where CLIPPED," OR "
         END IF
      END FOR
 
      CALL la_zm01.clear()
 
      LET ls_sql = "SELECT UNIQUE(zm01) FROM zm_file",
                   " WHERE ",ls_where CLIPPED
      DECLARE g_zm01_cur CURSOR FROM ls_sql
 
      LET l_ac = 1
      LET ls_not_in = TRUE
      FOREACH g_zm01_cur INTO lr_zm01.*
         LET ls_not_in = FALSE
         IF SQLCA.sqlcode THEN
            CALL cl_err("redomenu-FOREACH:",SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET la_zm01[l_ac].* = lr_zm01.*
         LET l_ac = l_ac + 1
      END FOREACH
      IF ls_not_in THEN
         LET ls_check = FALSE
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
FUNCTION redo_menu_check(ls_zm01)
   DEFINE   ls_zm01         LIKE zm_file.zm01,
            li_i            LIKE type_file.num10,   #No.FUN-680135 INTEGER
            ls_cnt          LIKE type_file.num10,   #No.FUN-680135 INTEGER
            no_redo_flag    LIKE type_file.num5     #No.FUN-680135 SMALLINT
 
   FOR li_i = 1 TO g_change_menu.getLength()
      IF ls_zm01 = g_change_menu[li_i].menu_name THEN
         LET no_redo_flag = TRUE
      END IF
   END FOR
   IF NOT no_redo_flag THEN
      LET g_change_menu[g_change_menu_cnt].menu_name = ls_zm01
      LET g_change_menu_cnt = g_change_menu.getLength() + 1
   END IF
END FUNCTION
 
FUNCTION p_zm_redo_menu(ls_flag)
   DEFINE  ls_flag       LIKE type_file.num5,    #No.FUN-680135 SMALLINT
           li_i          LIKE type_file.num5,    #No.FUN-680135 SMALLINT
           ls_run        LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE  ls_msg        LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(300)
   DEFINE  ls_msg2       LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(300)
   DEFINE  ls_title      LIKE type_file.chr50    #No.FUN-680135 VARCHAR(50)
   DEFINE  ls_zx05       LIKE zx_file.zx05
   DEFINE  lr_redomenu   DYNAMIC ARRAY OF RECORD
             menu_name   LIKE zx_file.zx05
                         END RECORD
   DEFINE  li_cnt        LIKE type_file.num5     #No.FUN-680135 SMALLINT
 
 
   LET ls_run = FALSE
   SELECT ze03 INTO ls_title FROM ze_file WHERE ze01 = 'azz-049' AND ze02 = g_lang
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'azz-047' AND ze02 = g_lang
   MENU ls_title ATTRIBUTE(STYLE="dialog", COMMENT=ls_msg CLIPPED)
      ON ACTION accept
         LET li_cnt = 1
         IF ls_flag THEN
            FOR li_i = 1 TO g_change_menu.getLength()
               CALL p_zm_zx05_check(g_change_menu[li_i].menu_name)
               IF (g_zx05_check) THEN
                  LET lr_redomenu[li_cnt].menu_name = g_change_menu[li_i].menu_name
                  LET li_cnt = li_cnt + 1
#                 LET ls_run = TRUE
               END IF
            END FOR
         ELSE
            SELECT ze03 INTO ls_msg2 FROM ze_file WHERE ze01 = 'azz-048' AND ze02 = g_lang
            MESSAGE ls_msg2 CLIPPED
            DECLARE zx05_all_curs CURSOR FOR
                                  SELECT UNIQUE(zx05) FROM zx_file
            FOREACH zx05_all_curs INTO ls_zx05
               IF SQLCA.sqlcode THEN
                  CALL cl_err('OPEN zx05_all_curs:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               LET lr_redomenu[li_cnt].menu_name = ls_zx05
               LET li_cnt = li_cnt + 1
#              LET ls_run = TRUE
            END FOREACH
         END IF
          CALL g_change_menu.clear()                         # MOD-4C0167
         LET g_change_menu_cnt = 1
      ON ACTION cancel
         EXIT MENU
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET g_action_choice = "exit"
           EXIT MENU
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
 #     #MOD-540150 特別刪除
 #     ON ACTION about         #MOD-4C0121
 #        CALL cl_about()      #MOD-4C0121
#
 #     ON ACTION help          #MOD-4C0121
 #        CALL cl_show_help()  #MOD-4C0121
#
 #     ON ACTION controlg      #MOD-4C0121
 #        CALL cl_cmdask()     #MOD-4C0121
 
 
   END MENU
   MESSAGE ls_msg CLIPPED
   FOR li_i = 1 TO lr_redomenu.getLength()
       IF NOT cl_null(lr_redomenu[li_i].menu_name) THEN
          MESSAGE 'Redo start menu file -- ',lr_redomenu[li_i].menu_name
          CALL cl_create_4sm(lr_redomenu[li_i].menu_name,TRUE)
       END IF
   END FOR
#  IF ls_run THEN
#     IF ls_flag THEN
#        CALL cl_create_4sm(g_change_menu[li_i].menu_name, TRUE)
#     ELSE
#        CALL cl_create_4sm(ls_zx05, TRUE)
#     END IF
#  END IF
 
   RETURN
END FUNCTION
 
FUNCTION p_zm_out()
DEFINE
    l_i            LIKE type_file.num5,    #No.FUN-680135 SMALLINT
    sr             RECORD
        zm01       LIKE zm_file.zm01,      #目錄代號
        zm03       LIKE zm_file.zm03,      #目錄序號
        zm04       LIKE zm_file.zm04,      #程式代號
        gaz03      LIKE gaz_file.gaz03     #程式名稱
                   END RECORD,
    l_name         LIKE type_file.chr20,   #External(Disk) file name        #No.FUN-680135 VARCHAR(20)
    l_za05         LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(40)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    LET l_name = 'p_zm.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    DECLARE p_zm_za_cur CURSOR FOR
            SELECT za02,za05 FROM za_file
             WHERE za01 = "p_zm" AND za03 = g_lang
    FOREACH p_zm_za_cur INTO g_i,l_za05
       LET g_x[g_i] = l_za05
    END FOREACH
 
    SELECT zz17 INTO g_len FROM zz_file
     WHERE zz01 = 'p_zm'
 
    IF g_len = 0 OR g_len IS NULL THEN
       LET g_len = 80
    END IF
 
    FOR g_i = 1 TO g_len
       LET g_dash[g_i,g_i] = '='
    END FOR
 
#   LET g_sql="SELECT zm01,zm03,zm04,gaz03 ",             #MOD-550123
#              " FROM zm_file, OUTER gaz_file ",          #組合出 SQL 指令
#             " WHERE gaz01=zm04 AND gaz02='1' AND ",g_wc CLIPPED," ORDER by gaz05"
 
    LET g_sql=" SELECT zm01,zm03,zm04 FROM zm_file ",
               " WHERE gaz02='1' AND ",g_wc CLIPPED
 
    PREPARE p_zm_p1 FROM g_sql
    DECLARE p_zm_curo CURSOR FOR p_zm_p1
 
    START REPORT p_zm_rep TO l_name
 
 #   FOREACH p_zm_curo INTO sr.*                           #MOD-550123
    FOREACH p_zm_curo INTO sr.zm01,sr.zm03,sr.zm04
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
         CALL cl_get_progname(g_zm01,g_lang) RETURNING sr.gaz03   #MOD-550123
        OUTPUT TO REPORT p_zm_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p_zm_rep
 
    CLOSE p_zm_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_zm_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
    sr              RECORD
        zm01        LIKE zm_file.zm01,      #目錄代號
        zm03        LIKE zm_file.zm03,      #目錄序號
        zm04        LIKE zm_file.zm04,      #程式代號
        gaz03       LIKE gaz_file.gaz03     #程式代號
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.zm01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT ' '
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT g_x[11],g_x[12]
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.zm01  #目錄代號
            PRINT sr.zm01;
        ON EVERY ROW
            PRINT COLUMN 6,sr.zm03 USING '####& ', sr.zm04,' ',sr.gaz03
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
 
 #No.MOD-580056 --start
FUNCTION p_zm_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("zm01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_zm_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("zm01",FALSE)
   END IF
END FUNCTION
 
#NO.MOD-590329 MARK------------------
#FUNCTION p_zm_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("zm03",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_zm_set_no_entry_b(p_cmd)
# DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("zm03",FALSE)
#   END IF
 
#END FUNCTION
#-END
#NO.MOD-590329 MARK
#Patch....NO.TQC-610037 <001,002> #
