# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_zxy.4gl
# Descriptions...: 使用者資料庫權限設定作業
# Date & Author..: 93/01/11 By Lee
# Modify.........: No.MOD-470041 04/07/20 By Wiky 修改INSERT INTO...
# Modify.........: No.MOD-490468 04/09/29 By Wiky 加開窗查詢功能
# Modify.........: No.FUN-4B0033 04/11/09 By alex 將 zxy02取消並referance zx02
# Modify.........: No.MOD-4B0110 04/11/12 By alex 取消作廢功能,帶出的預設資料存檔
# Modify.........: No.FUN-510050 05/02/21 By pengu 報表轉XML
# Modify.........: No.MOD-530094 05/03/14 By alex 先取消工廠名稱准輸入 ALL 的功能
# Modify.........: NO.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.MOD-590329 05/10/04 By yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.MOD-670105 06/07/26 By Pengu p_zx之"為多營運中心使用者"勾除(N),不可加入其他資料庫
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-7C0041 07/12/12 By alextsar 新增複製功能
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: NO.FUN-970073 09/07/21 By Kevin 把老報表改成p_query
# Modify.........: No.FUN-980025 09/08/05 By dxfwo   集團架構改善
# Modify.........: No.MOD-A30025 10/03/04 By Dido 抓取前應先清空變數
# Modify.........: No.FUN-A50080 10/05/21 By Hiko 移除關於azwa_file的設定
# Modify.........: No.TQC-B30219 11/04/11 By huangtao 營運中心開窗可以多選
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90147 11/10/26 By Hiko 整批複製使用者權限
# Modify.........: No.FUN-C10004 12/01/02 By tsai_yen GP5.3 GWC&GDC開發區合併
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.......... No.CHI-D20031 13/02/27 By madey 修正批次複製功能在新增一個不存在的帳號再按放棄,之後再點選"批次複製"會造成所有帳號的zxy_file被刪除
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_zxy01         LIKE zxy_file.zxy01,             #user-id    (假單頭)
    g_zxy01_t       LIKE zxy_file.zxy01,             #user-id    (舊值)
    g_zx02          LIKE zx_file.zx02,
    g_zx07          LIKE zx_file.zx07,               #No.MOD-670105 add
    g_zxy           DYNAMIC ARRAY OF RECORD          #程式變數(Program Variables)
        zxy03       LIKE zxy_file.zxy03,             #plant-no
        azp02       LIKE azp_file.azp02              #plant-name
                    END RECORD,
    g_zxy_t         RECORD                           #程式變數 (舊值)
        zxy03       LIKE zxy_file.zxy03,             #plant-no
        azp02       LIKE azp_file.azp02              #plant-name
                    END RECORD,
    g_wc                STRING,                      #TQC-630166
    g_wc2               STRING,                      #TQC-630166
    g_sql               STRING,                      #TQC-630166
    g_rec_b             LIKE type_file.num5,         #單身筆數 #No.FUN-680135 SMALLINT
    g_succ              LIKE type_file.chr1,         #No.FUN-680135 VARCHAR(1)
    l_ac                LIKE type_file.num5          #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
DEFINE   g_forupd_sql   STRING                       #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done  LIKE type_file.num5   #NO.MOD-580056 #No.FUN-680135 SMALLINT
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose  #No.FUN-680135 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(72)
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680135 SMALLINT #FUN-6A0080
DEFINE   g_argv1        LIKE zxy_file.zxy01

MAIN
   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理

   LET g_argv1 = ARG_VAL(1)                          # user id

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096

   LET g_zxy01 = NULL                     #清除鍵值
   LET g_zxy01_t = NULL

   OPEN WINDOW p_zxy_w WITH FORM "azz/42f/p_zxy"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   ###FUN-C10004 START ###
   LET g_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzy_file(wzy01,wzy02,wzy03)",
                    " VALUES(?,'2',?)"
   PREPARE p_zxy_wzy_ins_pre01 FROM g_sql

   LET g_sql = "DELETE FROM ",s_dbstring("wds") CLIPPED,"wzy_file WHERE wzy01=? AND wzy02='2'"
   PREPARE p_wzy_wzy_del_pre01 FROM g_sql

   LET g_sql = "DELETE FROM ",s_dbstring("wds") CLIPPED,"wzy_file WHERE wzy01=? AND wzy02='2' AND wzy03=?"
   PREPARE p_wzy_wzy_del_pre02 FROM g_sql
   ###FUN-C10004 END ###

   IF NOT cl_null(g_argv1) THEN
      CALL p_zxy_q()
   END IF

   CALL p_zxy_menu()

   CLOSE WINDOW p_zxy_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0096
END MAIN

FUNCTION p_zxy_cs()

   CLEAR FORM                             #清除畫面
   LET g_zxy01=NULL
   LET g_zx02=NULL
   CALL g_zxy.clear()

   IF NOT cl_null(g_argv1)  THEN

      LET g_wc = "zxy01 ='",g_argv1 CLIPPED,"'" CLIPPED

   ELSE
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      CONSTRUCT g_wc ON zxy01,zxy03,azp02
           FROM zxy01,s_zxy[1].zxy03,s_zxy[1].azp02

         ON ACTION controlp
            CASE
               WHEN INFIELD(zxy01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_zx"
                  LET g_qryparam.state ="c"
                  LET g_qryparam.default1 = g_zxy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zxy01

               WHEN INFIELD(zxy03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azp"
                  LET g_qryparam.state ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zxy03
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

     END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030

     IF INT_FLAG THEN RETURN END IF
   END IF

   LET g_sql="SELECT UNIQUE zxy01 FROM zxy_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zxy01"
   PREPARE p_zxy_prepare FROM g_sql      #預備一下
   DECLARE p_zxy_bcs                     #宣告成可捲動的
       SCROLL CURSOR  WITH HOLD FOR p_zxy_prepare

   LET g_sql = "SELECT COUNT(DISTINCT zxy01) FROM zxy_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
   PREPARE p_zxy_precount FROM g_sql
   DECLARE p_zxy_count CURSOR FOR p_zxy_precount

END FUNCTION

FUNCTION p_zxy_menu()
   WHILE TRUE
      CALL p_zxy_bp("G")
      CASE g_action_choice

           WHEN "insert"
            IF cl_chk_act_auth() THEN
                CALL p_zxy_a()
            END IF

           WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL p_zxy_q()
            END IF

           WHEN "delete"
            IF cl_chk_act_auth() THEN
                CALL p_zxy_r()
            END IF

           WHEN "reproduce"             #FUN-7C0041
            IF cl_chk_act_auth() THEN
                CALL p_zxy_copy()
            END IF

           WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL p_zxy_b()
            ELSE
               LET g_action_choice = NULL
            END IF

           #Begin:FUN-B90147
           WHEN "batch_copy"
            IF cl_chk_act_auth() THEN
               CALL p_zxy_batch_copy()
            END IF
           #End:FUN-B90147

          WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL p_zxy_out()
            END IF

           WHEN "help"
            CALL cl_show_help()

           WHEN "exit"
            EXIT WHILE

           WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION p_zxy_a()

   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_zxy.clear()

   LET g_zxy01 = NULL
   LET g_zxy01_t = NULL

   DISPLAY g_zxy01 TO zxy01
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')

    WHILE TRUE
       CALL p_zxy_i("a")                   #輸入單頭
       IF INT_FLAG THEN                   #使用者不玩了
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          LET g_row_count = 0            #CHI-D20031 避免殘留
          EXIT WHILE
       END IF
       CALL g_zxy.clear()
       LET g_rec_b = 0
       DISPLAY g_rec_b TO FORMONLY.cn2

       CALL p_zxy_b()                   #輸入單身

       LET g_zxy01_t = g_zxy01            #保留舊值
       EXIT WHILE
    END WHILE
    LET g_wc=' '

END FUNCTION

FUNCTION p_zxy_u()

   IF s_shut(0) THEN RETURN END IF                #檢查權限

   IF cl_null(g_zxy01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zxy01_t = g_zxy01

   ###FUN-C10004 START ###
   LET g_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzy_file SET wzy01 = ?",
                 " WHERE wzy01 = ? AND wzy02 = '2'"
   PREPARE p_zxy_wzy01_upd_pre FROM g_sql
   ###FUN-C10004 END ###

   WHILE TRUE
      CALL p_zxy_i("u")                      #欄位更改

      IF INT_FLAG THEN
         LET g_zxy01=g_zxy01_t
         DISPLAY g_zxy01 TO zxy01     #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF g_zxy01 != g_zxy01_t THEN #更改單頭值
         BEGIN WORK   #FUN-C10004
         UPDATE zxy_file SET zxy01 = g_zxy01        #更新DB
          WHERE zxy01 = g_zxy01_t                   #COLAUTH?
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zxy01 CLIPPED,SQLCA.sqlcode,1)  #No.FUN-660081
            CALL cl_err3("upd","zxy_file",g_zxy01_t,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
            CONTINUE WHILE
         END IF
         ###FUN-C10004 START ###
         EXECUTE p_zxy_wzy01_upd_pre USING g_zxy01,g_zxy01_t
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("upd","wzy_file",g_zxy01_t,"",SQLCA.SQLCODE,"","",1)
            ROLLBACK WORK
            CONTINUE WHILE
         ELSE
            COMMIT WORK
         END IF
         ###FUN-C10004 END ###
      END IF
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION p_zxy_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
   l_n             LIKE type_file.num5        #No.FUN-680135 SMALLINT
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_zxy01 WITHOUT DEFAULTS FROM zxy01

   #NO.MOD-590329 MARK----------------------
    #NO.MOD-580056------
#   BEFORE INPUT
#         LET g_before_input_done = FALSE
#         CALL p_zxy_set_entry(p_cmd)
#         CALL p_zxy_set_no_entry(p_cmd)
#         LET g_before_input_done = TRUE
   #--------END
#NO.MOD-590329 MARK-------------------------


      AFTER FIELD zxy01            #規格主件編號
         IF NOT cl_null(g_zxy01) THEN
            SELECT COUNT(*) INTO l_n FROM zxy_file
             WHERE zxy01=g_zxy01
            IF l_n>0 then
               CALL cl_err(g_zxy01,-239,0)
               NEXT FIELD zxy01
            END IF
            SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01 = g_zxy01
            IF sqlca.sqlcode THEN
               #CALL cl_err("Select p_zx,",SQLCA.SQLCODE,1)   #No.FUN-660081
               CALL cl_err3("sel","zx_file",g_zxy01,"",SQLCA.sqlcode,"","Select p_zx",1)   #No.FUN-660081
               NEXT FIELD zxy01
            ELSE
               DISPLAY g_zx02 TO zx02
            END IF
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(zxy01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_zx"
               LET g_qryparam.default1 = g_zxy01
               CALL cl_create_qry() RETURNING g_zxy01
               DISPLAY g_zxy01 TO zxy01
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

   END INPUT

END FUNCTION

FUNCTION p_zxy_q()
  DEFINE l_zxy01  LIKE zxy_file.zxy01,
         l_zx02   LIKE zx_file.zx02,
         l_cnt    LIKE type_file.num10   #No.FUN-680135 INTEGER

   CALL cl_opmsg('q')

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)

   CALL p_zxy_cs()                    #取得查詢條件

   IF INT_FLAG THEN                   #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_zxy01 TO NULL
      INITIALIZE g_zx02 TO NULL
      RETURN
   END IF

   OPEN p_zxy_count
   FETCH p_zxy_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt

   OPEN p_zxy_bcs                      #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_zxy01 TO NULL
      INITIALIZE g_zx02 TO NULL
   ELSE
      CALL p_zxy_fetch('F')            #讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION p_zxy_fetch(p_flag)
DEFINE
   p_flag      LIKE type_file.chr1,    #處理方式   #No.FUN-680135 VARCHAR(1)
   l_abso      LIKE type_file.num10    #絕對的筆數 #No.FUN-680135 INTEGER

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_zxy_bcs INTO g_zxy01
      WHEN 'P' FETCH PREVIOUS p_zxy_bcs INTO g_zxy01
      WHEN 'F' FETCH FIRST    p_zxy_bcs INTO g_zxy01
      WHEN 'L' FETCH LAST     p_zxy_bcs INTO g_zxy01
      WHEN '/'
         IF (NOT g_no_ask) THEN        #FUN-6A0080
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
         FETCH ABSOLUTE g_jump p_zxy_bcs INTO g_zxy01
         LET g_no_ask = FALSE        #FUN-6A0080
   END CASE

   LET g_succ='Y'
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_zxy01,SQLCA.sqlcode,0)
      INITIALIZE g_zxy01 TO NULL  #TQC-6B0105
      LET g_succ='N'
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL p_zxy_show()
   END IF

END FUNCTION

FUNCTION p_zxy_show()

   DISPLAY g_zxy01 TO zxy01        #單頭

   LET g_zx02 = NULL        #MOD-A30025
   LET g_zx07 = NULL        #MOD-A30025
   SELECT zx02,zx07 INTO g_zx02,g_zx07 FROM zx_file WHERE zx01=g_zxy01   #No.MOD-670105 modify
   DISPLAY g_zx02 TO zx02        #單頭

   CALL p_zxy_b_fill()             #單身

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION p_zxy_r()

   IF s_shut(0) THEN RETURN END IF                #檢查權限

   IF g_zxy01 IS NULL THEN
      RETURN
   END IF

    #MOD-4B0310 檢查若 zx_file 中有該user資料,就不可以砍整筆
   SELECT zx01 FROM zx_file WHERE zx01=g_zxy01
   IF NOT STATUS THEN
      CALL cl_err_msg(NULL, "azz-074",g_zxy01 CLIPPED,10)
      RETURN
   END IF

   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM zxy_file WHERE zxy01 = g_zxy01
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","zxy_file",g_zxy01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      ELSE
         ###FUN-C10004 START ###
         EXECUTE p_wzy_wzy_del_pre01 USING g_zxy01
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("del","wzy_file",g_zxy01,"",SQLCA.SQLCODE,"","",0)
            ROLLBACK WORK
            RETURN
         END IF
         ###FUN-C10004 END ###
         CLEAR FORM
         CALL g_zxy.clear()
         LET g_zxy01 = NULL
         LET g_zx02 = NULL

         OPEN p_zxy_count
#FUN-B50065------begin---
         IF STATUS THEN
            CLOSE p_zxy_count
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         FETCH p_zxy_count INTO g_row_count
#FUN-B50065------begin---
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE p_zxy_count
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_zxy_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_zxy_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE       #FUN-6A0080
            CALL p_zxy_fetch('/')
         END IF
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
      END IF
   END IF

   COMMIT WORK

END FUNCTION

FUNCTION p_zxy_b()
DEFINE
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680135 SMALLINT
   l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680135 SMALLINT
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680135 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,      #處理狀態          #No.FUN-680135 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,      #可新增否          #No.FUN-680135 SMALLINT
   l_allow_delete  LIKE type_file.num5       #可刪除否          #No.FUN-680135 SMALLINT
#TQC-B30219 --------------STA
DEFINE tok         base.StringTokenizer
DEFINE l_plant     LIKE azp_file.azp01
DEFINE l_flag      LIKE type_file.chr1

   LET l_flag = 'N'
#TQC-B30219 --------------END

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF           #檢查權限
   IF g_zxy01 IS NULL THEN
      RETURN
   END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT zxy03,'' FROM zxy_file",
                      " WHERE zxy01=? AND zxy03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zxy_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   ###FUN-C10004 START ###
   LET g_forupd_sql = "SELECT wzy03 FROM ",s_dbstring("wds") CLIPPED,"wzy_file",
                      " WHERE wzy01=? AND wzy02='2' AND wzy03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_wzy_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzy_file SET wzy03 = ?",
                 " WHERE wzy01 = ? AND wzy02 = '2' AND wzy03 = ?"
   PREPARE p_zxy_wzy03_upd_pre FROM g_sql
   ###FUN-C10004 END ###

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_zxy WITHOUT DEFAULTS FROM s_zxy.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

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
            LET g_zxy_t.* = g_zxy[l_ac].*      #BACKUP
            LET p_cmd='u'
           #NO.MOD-590329 MARK-------------------
            #No.MOD-580056 --start
           #LET g_before_input_done = FALSE
           #CALL p_zxy_set_entry_b(p_cmd)
           #CALL p_zxy_set_no_entry_b(p_cmd)
           #LET g_before_input_done = TRUE
            #No.MOD-580056 --end
           #NO.MOD-590329 MARK-------------------
            ###FUN-C10004 START ###
            OPEN p_wzy_bcl USING g_zxy01,g_zxy_t.zxy03
            IF STATUS THEN
               CALL cl_err("OPEN p_wzy_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_wzy_bcl INTO g_zxy[l_ac].zxy03
               IF SQLCA.SQLCODE THEN
                  CALL cl_err(g_zxy_t.zxy03,SQLCA.SQLCODE,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            ###FUN-C10004 END ###

            OPEN p_zxy_bcl USING g_zxy01,g_zxy_t.zxy03
            IF STATUS THEN
               CALL cl_err("OPEN p_zxy_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_zxy_bcl INTO g_zxy[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zxy_t.zxy03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT azp02 INTO g_zxy[l_ac].azp02
                       FROM azp_file
                      WHERE azp01 = g_zxy[l_ac].zxy03
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO zxy_file(zxy01,zxy03)   #No.MOD-470041
                       VALUES(g_zxy01,g_zxy[l_ac].zxy03)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zxy[l_ac].zxy03,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","zxy_file",g_zxy01,g_zxy[l_ac].zxy03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            ###FUN-C10004 START ###
            EXECUTE p_zxy_wzy_ins_pre01 USING g_zxy01,g_zxy[l_ac].zxy03
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","wzy_file",g_zxy01,g_zxy[l_ac].zxy03,SQLCA.SQLCODE,"","",0)
               ROLLBACK WORK
               CANCEL INSERT
            END IF
            ###FUN-C10004 END ###
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zxy[l_ac].* TO NULL      #900423
         LET g_zxy_t.* = g_zxy[l_ac].*         #新輸入資料
         IF g_rec_b=0 THEN
            SELECT zx08,azp02 INTO g_zxy[l_ac].zxy03,g_zxy[l_ac].azp02
              FROM zx_file,azp_file
             WHERE zx01 = g_zxy01
               AND azp01 = zx08
         END IF
#NO.MOD-590329 MARK----------------------
 #No.MOD-580056 --start
#         LET g_before_input_done = FALSE
#         CALL p_zxy_set_entry_b(p_cmd)
#         CALL p_zxy_set_no_entry_b(p_cmd)
#         LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK---------------------
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD zxy03

      BEFORE FIELD zxy03                        #default 序號
         IF cl_null(g_zxy[l_ac].zxy03) THEN
            LET g_zxy[l_ac].zxy03=""
         ELSE
            IF g_rec_b < 2 THEN
               DISPLAY g_zxy[l_ac].zxy03 TO zxy03
            END IF
         END IF

      AFTER FIELD zxy03                        #check 序號是否重複
 #        MOD-530094
#        IF NOT cl_null(g_zxy[l_ac].zxy03) AND g_zxy[l_ac].zxy03 <> 'ALL' THEN
         IF NOT cl_null(g_zxy[l_ac].zxy03) THEN
          #---------No.MOD-670105 add
            IF p_cmd='a' AND g_zx07 ='N' THEN
               CALL cl_err(g_zxy01,'azz-136',1)
               NEXT FIELD zxy03
            END IF
          #---------No.MOD-670105 end
            SELECT azp02 INTO g_zxy[l_ac].azp02 FROM azp_file
             WHERE azp01 = g_zxy[l_ac].zxy03
#           IF sqlca.sqlcode = 100 THEN
            IF SQLCA.SQLCODE THEN
#              ERROR "no such plant-no"
               #CALL cl_err("Plant No.:",SQLCA.sqlcode,1)  #No.FUN-660081
               CALL cl_err3("sel","azp_file",g_zxy[l_ac].zxy03,"",SQLCA.sqlcode,"","Plant No.",1)    #No.FUN-660081
               NEXT FIELD zxy03
            END IF
         END IF

 #        MOD-530094
#        IF g_zxy[l_ac].zxy03 = 'ALL' THEN
#           LET g_zxy[l_ac].azp02=' '
#        END IF

         IF g_zxy[l_ac].zxy03 != g_zxy_t.zxy03 OR g_zxy_t.zxy03 IS NULL THEN
            SELECT count(*) INTO l_n FROM zxy_file
             WHERE zxy01 = g_zxy01
               AND zxy03 = g_zxy[l_ac].zxy03
            IF l_n > 0 THEN
               CALL cl_err(g_zxy[l_ac].zxy03,-239,0)
               LET g_zxy[l_ac].zxy03 = g_zxy_t.zxy03
               NEXT FIELD zxy03
            END IF
         END IF

      BEFORE DELETE
         IF g_zxy_t.zxy03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
             #MOD-4B0103 檢查如果 zx08 的值是現在這一筆, 則不准砍
            SELECT zx08 FROM zx_file WHERE zx01=g_zxy01 AND zx08=g_zxy_t.zxy03
            IF NOT STATUS THEN
               CALL cl_err_msg(NULL, "azz-075",g_zxy_t.zxy03 CLIPPED ||"|"|| g_zxy01 CLIPPED,10)
               CANCEL DELETE
            END IF

            DELETE FROM zxy_file
             WHERE zxy01 = g_zxy01
               AND zxy03 = g_zxy_t.zxy03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zxy_t.zxy03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zxy_file",g_zxy01,g_zxy_t.zxy03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF

            ###FUN-C10004 START ###
            EXECUTE p_wzy_wzy_del_pre02 USING g_zxy01,g_zxy_t.zxy03
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("del","wzy_file",g_zxy01,g_zxy_t.zxy03,SQLCA.SQLCODE,"","",0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            ###FUN-C10004 END ###
            COMMIT WORK
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zxy[l_ac].* = g_zxy_t.*
            CLOSE p_wzy_bcl   #FUN-C10004
            CLOSE p_zxy_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zxy[l_ac].zxy03,-263,1)
            LET g_zxy[l_ac].* = g_zxy_t.*
         ELSE
            UPDATE zxy_file SET zxy03 = g_zxy[l_ac].zxy03
             WHERE zxy01=g_zxy01
               AND zxy03=g_zxy_t.zxy03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zxy[l_ac].zxy03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zxy_file",g_zxy01,g_zxy_t.zxy03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zxy[l_ac].* = g_zxy_t.*
            ELSE
               ###FUN-C10004 START ###
               EXECUTE p_zxy_wzy03_upd_pre USING g_zxy[l_ac].zxy03,g_zxy01,g_zxy_t.zxy03
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","wzy_file",g_zxy01,g_zxy_t.zxy03,SQLCA.SQLCODE,"","",0)
                  LET g_zxy[l_ac].* = g_zxy_t.*
                  ROLLBACK WORK
               END IF
               ###FUN-C10004 END ###
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac           #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_zxy[l_ac].* = g_zxy_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_zxy.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_wzy_bcl   #FUN-C10004
            CLOSE p_zxy_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac           #FUN-D30034 add
         CLOSE p_wzy_bcl   #FUN-C10004
         CLOSE p_zxy_bcl
         COMMIT WORK

      ON ACTION controlp
         CASE
            WHEN INFIELD(zxy03)
#TQC-B30219 ------------------STA
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               IF p_cmd = 'u' THEN
                  LET g_qryparam.default1 = g_zxy[l_ac].zxy03
                  CALL cl_create_qry() RETURNING g_zxy[l_ac].zxy03
                  DISPLAY g_zxy[l_ac].zxy03 TO zxy03
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_plant = tok.nextToken()
                       IF cl_null(l_plant) THEN
                          CONTINUE WHILE
                       ELSE
                         SELECT COUNT(*) INTO l_n  FROM zxy_file
                          WHERE zxy01 = g_zxy01 AND zxy03 = l_plant
                         IF l_n > 0 THEN
                            CONTINUE WHILE
                         END IF
                       END IF
                       INSERT INTO zxy_file VALUES (g_zxy01,'',l_plant)
                       EXECUTE p_zxy_wzy_ins_pre01 USING g_zxy01,l_plant   #FUN-C10004
                    END WHILE
                   LET l_flag = 'Y'
                   EXIT INPUT
               END IF
#TQC-B30219 ------------------END
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
   END INPUT
#TQC-B30219 ---------------STA
   IF l_flag = 'Y' THEN
       CALL p_zxy_b_fill()
       CALL p_zxy_b()
   END IF
#TQC-B30219 ---------------END
   #CALL s_ins_auth_plant(g_zxy01)    #No.FUN-980025  #FUN-A50080
   CLOSE p_wzy_bcl   #FUN-C10004
   CLOSE p_zxy_bcl
   COMMIT WORK

END FUNCTION

#Begin:FUN-B90147:整批複製使用者權限
FUNCTION p_zxy_batch_copy()
   DEFINE l_zx DYNAMIC ARRAY OF RECORD
               select LIKE type_file.chr1,
               zx01   LIKE zx_file.zx01,
               zx02   LIKE zx_file.zx02
               END RECORD
   DEFINE l_cnt SMALLINT,
          l_err STRING
   DEFINE l_rec_b SMALLINT,
          l_ac    SMALLINT,
          l_idx   SMALLINT

   OPEN WINDOW p_zxy_bc_w WITH FORM "azz/42f/p_zxy_bc" ATTRIBUTE(STYLE=g_win_style CLIPPED)

   CALL cl_ui_locale("p_zxy_bc_w")

   #取得所有使用者清單(扣除目前畫面的使用者)
   DECLARE zx_curs CURSOR FOR
      SELECT 'Y',zx01,zx02 FROM zx_file WHERE zx01<>g_zxy01 ORDER BY zx01

   LET l_cnt = 1
   FOREACH zx_curs INTO l_zx[l_cnt].*
      IF SQLCA.SQLCODE THEN
         LET l_err="foreach zx_file data error"
         CALL cl_err(l_err, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      IF l_cnt > g_max_rec THEN
         CALL cl_err("", 9035, 0)
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_zx.deleteElement(l_cnt)

   #改成INPUT
   LET l_rec_b = l_zx.getLength()
   LET l_ac = 0

   INPUT ARRAY l_zx WITHOUT DEFAULTS FROM s_zx.*
      ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         IF l_rec_b != 0 THEN
            CALL FGL_SET_ARR_CURR(l_ac)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()

      AFTER INPUT
         IF NOT INT_FLAG THEN
            FOR l_idx=1 TO l_rec_b
               IF l_zx[l_idx].select = "Y" THEN
                  CALL p_zxy_copy_one(l_zx[l_idx].zx01,l_zx[l_idx].zx02)
               END IF
            END FOR
         END IF

         LET INT_FLAG = FALSE

      ON ACTION select_all
         FOR l_idx=1 TO l_rec_b
             LET l_zx[l_idx].select = "Y"
         END FOR

      ON ACTION cancel_all
         FOR l_idx=1 TO l_rec_b
             LET l_zx[l_idx].select = "N"
         END FOR

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT

   CLOSE WINDOW p_zxy_bc_w
END FUNCTION
#End:FUN-B90147

#Begin:FUN-B90147:逐一複製
FUNCTION p_zxy_copy_one(p_zx01,p_zx02)
   DEFINE p_zx01 LIKE zx_file.zx01,
          p_zx02 LIKE zx_file.zx02
   DEFINE l_idx SMALLINT
   DEFINE l_cnt SMALLINT

   #先判斷要複製權限的目標使用者是否已經存在zxy_file內.
   SELECT count(zxy01) INTO l_cnt FROM zxy_file WHERE zxy01=p_zx01
   IF l_cnt>0 THEN #有資料
      #新增資料前要先刪除原本的資料.
      DELETE FROM zxy_file WHERE zxy01=p_zx01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","zxy_file",p_zx01,"",SQLCA.SQLCODE,"","BATCH COPY DELETE",0)
      ELSE #FUN-C10004
         ###FUN-C10004 START ###
         EXECUTE p_wzy_wzy_del_pre01 USING p_zx01
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("del","wzy_file",p_zx01,"",SQLCA.SQLCODE,"","BATCH COPY DELETE",0)
         END IF
         ###FUN-C10004 END ###
      END IF
   END IF

   FOR l_idx=1 TO g_zxy.getLength()
      INSERT INTO zxy_file(zxy01,zxy02,zxy03) VALUES(p_zx01,p_zx02,g_zxy[l_idx].zxy03)
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","zxy_file",p_zx01,g_zxy[l_idx].zxy03,SQLCA.SQLCODE,"","",0)
      ELSE #FUN-C10004
         ###FUN-C10004 START ###
         EXECUTE p_zxy_wzy_ins_pre01 USING p_zx01,g_zxy[l_idx].zxy03
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","wzy_file",p_zx01,g_zxy[l_idx].zxy03,SQLCA.SQLCODE,"","",0)
         END IF
         ###FUN-C10004 END ###
      END IF
   END FOR
END FUNCTION
#End:FUN-B90147

FUNCTION p_zxy_b_fill()              #BODY FILL UP

   LET g_sql = "SELECT zxy03,azp02,'' ",
                " FROM zxy_file LEFT OUTER JOIN azp_file ",
                                " ON zxy_file.zxy03 = azp_file.azp01 ",
               " WHERE zxy_file.zxy01 = '",g_zxy01 CLIPPED,"' ",
               " ORDER BY zxy03 "
   PREPARE p_zxy_prepare2 FROM g_sql      #預備一下
   DECLARE zxy_cs CURSOR FOR p_zxy_prepare2

   CALL g_zxy.clear()
   LET g_cnt = 1
   LET g_rec_b=0

   FOREACH zxy_cs INTO g_zxy[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_zxy.deleteElement(g_cnt)

   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION


FUNCTION p_zxy_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 CHAR(1)

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF

    LET g_action_choice = " "

   #CALL cl_set_act_visible("accept,cancel", FALSE) marked by CHI-D20031
   #CHI-D20031 --start--  batch_copy預設不顯示,當單頭帳號存在時才顯示
    CALL cl_set_act_visible("accept,cancel,batch_copy", FALSE) #CHI-D20031
    IF g_row_count != 0 THEN
       CALL cl_set_act_visible("batch_copy", TRUE)
    END IF
   #CHI-D20031 --end-- 

    DISPLAY ARRAY g_zxy TO s_zxy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

        BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

        ON ACTION insert
           LET g_action_choice="insert"
           EXIT DISPLAY

        ON ACTION query
           LET g_action_choice="query"
           EXIT DISPLAY

        ON ACTION delete
           LET g_action_choice="delete"
           EXIT DISPLAY

        ON ACTION detail
           LET g_action_choice="detail"
           LET l_ac = 1
           EXIT DISPLAY

        #Begin:FUN-B90147:批次複製使用者權限
        ON ACTION batch_copy
           LET g_action_choice="batch_copy"
           EXIT DISPLAY
        #End:FUN-B90147

        ON ACTION help
           LET g_action_choice="help"
           EXIT DISPLAY

        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
           EXIT DISPLAY

        ON ACTION output
           LET g_action_choice="output"
           EXIT DISPLAY

        ON ACTION exit
           LET g_action_choice="exit"
           EXIT DISPLAY

        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY

        ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice="exit"
           EXIT DISPLAY

        ON ACTION first
           CALL p_zxy_fetch('F')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

        ON ACTION previous
           CALL p_zxy_fetch('P')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

        ON ACTION jump
           CALL p_zxy_fetch('/')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

        ON ACTION next
           CALL p_zxy_fetch('N')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

        ON ACTION last
           CALL p_zxy_fetch('L')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

        ON ACTION reproduce  #FUN-7C0041
           LET g_action_choice="reproduce"
           EXIT DISPLAY

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      AFTER DISPLAY
         CONTINUE DISPLAY

     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION p_zxy_copy()    #FUN-7C0041

   DEFINE l_newno      LIKE zxy_file.zxy01,
          l_oldno      LIKE zxy_file.zxy01
   DEFINE lc_zx01      LIKE zx_file.zx01

   IF s_shut(0) THEN RETURN END IF                #檢查權限

   IF cl_null(g_zxy01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_newno FROM zxy01

      AFTER FIELD zxy01
         IF cl_null(l_newno) THEN
            NEXT FIELD zxy01
         END IF
         SELECT count(*) INTO g_cnt FROM zxy_file
          WHERE zxy01 = l_newno
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD zxy01
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

   IF INT_FLAG OR l_newno IS NULL THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   BEGIN WORK   #FUN-C10004
   DROP TABLE x

   SELECT * FROM zxy_file WHERE zxy01=g_zxy01 INTO TEMP x

   UPDATE x SET zxy01=l_newno     #資料鍵值

   INSERT INTO zxy_file SELECT * FROM x

   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","zxy_file",l_newno,"",SQLCA.sqlcode,"","",0)
      ROLLBACK WORK    #FUN-C10004
      RETURN
   ELSE #FUN-C10004
      ###FUN-C10004 START ###
      LET g_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzy_file(wzy01,wzy02,wzy03)",
                       " SELECT zxy01,'2',zxy03 FROM x"
      PREPARE p_zxy_wzy_ins_pre02 FROM g_sql
      EXECUTE p_zxy_wzy_ins_pre02
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","wzy_file",l_newno,"",SQLCA.SQLCODE,"","",0)
         ROLLBACK WORK
         RETURN
      END IF
      COMMIT WORK
      ###FUN-C10004 END ###
   END IF

   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE 'COPY(',g_cnt USING '<<<<',') Rows O.K'
   LET g_zxy01 = l_newno  #FUN-C30027
   CALL p_zxy_show()      #FUN-C30027
END FUNCTION


FUNCTION p_zxy_out()

DEFINE l_cmd        LIKE type_file.chr1000
    IF cl_null(g_wc) THEN
       LET g_wc=" zxy01='",g_zxy01,"'"
    END IF
    IF g_wc IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    LET l_cmd = 'p_query "p_zxy" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
END FUNCTION


