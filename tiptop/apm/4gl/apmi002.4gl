# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi002.4gl
# Descriptions...: 三角貿易轉撥單價維護作業
# Date & Author..: 03/08/25 By Kammy (No.7915)
# Modify.........: No.9315 04/05/12 by Ching 做複製的動作時會出現-958
# Modify.........: 04/07/21 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: NO.MOD-470518 BY wiky add cl_doc()功能
# Modify.........: No.MOD-4A0248 04/10/19 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0095 05/02/02 By Mandy 報表轉XML
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.MOD-570096 05/08/02 By Mandy 查詢q_poy內的設定應是LET g_qryparam.default1 = g_pow03 才對,否則開窗按放棄會帶回流程代碼
# Modify.........: No.FUN-5A0157 05/10/24 By Sarah i002_b_fill()的FOREACH前增加CALL g_pow.clear()
# Modify.........: No.TQC-5B0076 05/11/09 By Claire execl匯出失效
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0090 06/11/06 By baogui 表頭未對齊
# Modify.........: No.FUN-6A0162 06/11/11 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7B0099 07/12/03 By Clinton 報表格式修改為crystal reports
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.MOD-860291 08/06/25 By claire 修改語法
# Modify.........: No.MOD-920320 08/06/25 By claire 加入權限控管
# Modify.........: No.TQC-960008 09/06/03 By lilingyu 單頭不可以修改,將修改函數MARK
# Modify.........: No.TQC-950170 09/06/08 By destiny i002_pow05這個函數里面，加上判斷msv資料庫
# Modify.........: No.FUN-980006 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-990006 09/09/01 By Dido 單身修改人員與修改日期調整更新時機
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0106 09/10/23 By lilingyu 單價未控管負數
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30035 10/03/09 By Carrier 单身料件加QBE开窗
# Modify.........: No.FUN-A70145 10/07/30 By alex 調整ASE程式語法
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_pow01         LIKE pow_file.pow01,      #流程代碼 (假單頭)
    g_pow02         LIKE pow_file.pow02,      #生效日期 (假單頭)
    g_pow03         LIKE pow_file.pow03,      #工廠編號 (假單頭)
    g_curr          LIKE poy_file.poy05,      #幣別     (假單頭)
    g_pow01_t       LIKE pow_file.pow01,      #流程代碼   (舊值)
    g_pow02_t       LIKE pow_file.pow02,      #生效日期   (舊值)
    g_pow03_t       LIKE pow_file.pow03,      #工廠編號   (舊值)
    g_curr_t        LIKE poy_file.poy05,      #幣別       (舊值)
    l_cnt           LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_cnt1          LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_cmd           LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(100)
    g_pow           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        pow05       LIKE pow_file.pow05,      #料號條件規範
        pow06       LIKE pow_file.pow06,      #單價
        powuser     LIKE pow_file.powuser,
        powgrup     LIKE pow_file.powgrup,
        powmodu     LIKE pow_file.powmodu,
        powdate     LIKE pow_file.powdate
                    END RECORD,
    g_pow_t         RECORD                    #程式變數 (舊值)
        pow05       LIKE pow_file.pow05,      #料號條件規範
        pow06       LIKE pow_file.pow06,      #單價
        powuser     LIKE pow_file.powuser,
        powgrup     LIKE pow_file.powgrup,
        powmodu     LIKE pow_file.powmodu,
        powdate     LIKE pow_file.powdate
                    END RECORD,
    g_pow05_o       LIKE pow_file.pow05,
    g_poz02         LIKE poz_file.poz02,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數  #No.FUN-680136
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680136 SMALLINT
    l_za05          LIKE type_file.chr1000,#No.FUN-680136 VARCHAR(40)
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-680136 SMALLINT #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE   g_cnt            LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i              LIKE type_file.num5          #count/index for any purpose    #No.FUN-680136 SMALLINT
DEFINE   g_msg            LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count      LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_curs_index     LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_jump           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_no_ask        LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE   g_str            STRING   #FUN-7B0099

MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_pow01   = NULL                   #清除鍵值
   LET g_pow02   = NULL                   #清除鍵值
   LET g_pow03   = NULL                   #清除鍵值
   LET g_curr    = NULL                   #清除鍵值
   LET g_pow01_t = NULL
   LET g_pow02_t = NULL
   LET g_pow03_t = NULL
   LET g_curr_t  = NULL

   OPEN WINDOW i002_w WITH FORM "apm/42f/apmi002"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()

   LET g_delete='N'
   CALL i002_menu()
   CLOSE WINDOW i002_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i002_cs()

   CLEAR FORM                             #清除畫面
   CALL g_pow.clear()

   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pow01 TO NULL    #No.FUN-750051
   INITIALIZE g_pow02 TO NULL    #No.FUN-750051
   INITIALIZE g_pow03 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON pow01,pow02,pow03,pow05,pow06,    #螢幕上取條件
                     powuser,powgrup,powmodu,powdate
           FROM pow01,pow02,pow03,s_pow[1].pow05,s_pow[1].pow06,
                s_pow[1].powuser,s_pow[1].powgrup,s_pow[1].powmodu,
                s_pow[1].powdate
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE WHEN INFIELD(pow01)      #流程代碼
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_poz"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pow01
                   NEXT FIELD pow01
               WHEN INFIELD(pow03)      #工廠編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_poy"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pow03
                   NEXT FIELD pow03
         OTHERWISE EXIT CASE
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


		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('powuser', 'powgrup')

   LET g_sql="SELECT UNIQUE pow01,pow02,pow03 ",
              " FROM pow_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY pow01,pow02,pow03"
   PREPARE i002_prepare FROM g_sql      #預備一下
   DECLARE i002_bcs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i002_prepare

   LET g_sql_tmp="SELECT UNIQUE pow01,pow02,pow03",  #No.TQC-720019
             "  FROM pow_file WHERE ", g_wc CLIPPED,
             " GROUP BY pow01,pow02,pow03 ",
             " INTO TEMP x"
   DROP TABLE x
   PREPARE i002_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i002_precount_x

   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i002_precount FROM g_sql
   DECLARE i002_count CURSOR FOR i002_precount

END FUNCTION

FUNCTION i002_menu()
   WHILE TRUE
      CALL i002_bp("G")
      CASE g_action_choice
           WHEN "insert"
            IF cl_chk_act_auth() THEN
                CALL i002_a()
            END IF
           WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL i002_q()
            END IF

           WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL i002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
           WHEN "next"
            CALL i002_fetch('N')
           WHEN "previous"
            CALL i002_fetch('P')
           WHEN "delete"
            IF cl_chk_act_auth() THEN
                CALL i002_r()
            END IF
          WHEN "reproduce"
             IF cl_chk_act_auth() THEN
                CALL i002_copy()
             END IF
          WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i002_out()
            END IF
           WHEN "help"
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "jump"
            CALL i002_fetch('/')
           WHEN "controlg"
            CALL cl_cmdask()
            WHEN "related_document"  #No.MOD-470518
            IF cl_chk_act_auth() THEN
               IF g_pow01 IS NOT NULL THEN
                  LET g_doc.column1 = "pow01"
                  LET g_doc.column2 = "pow02"
                  LET g_doc.column3 = "pow03"
                  LET g_doc.value1 = g_pow01
                  LET g_doc.value2 = g_pow02
                  LET g_doc.value3 = g_pow03
                  CALL cl_doc()
               END IF
            END IF
           WHEN "exporttoexcel"   #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pow),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i002_a()

   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_pow.clear()
   INITIALIZE g_pow01 LIKE pow_file.pow01
   INITIALIZE g_pow02 LIKE pow_file.pow02
   INITIALIZE g_pow03 LIKE pow_file.pow03
   INITIALIZE g_curr  TO NULL
   LET g_wc=NULL
   LET g_wc2=NULL
   LET g_pow01_t = NULL
   LET g_pow02_t = NULL
   LET g_pow03_t = NULL
   LET g_curr_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i002_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
      CALL i002_b()                      #輸入單身
      LET g_pow01_t = g_pow01            #保留舊值
      LET g_pow02_t = g_pow02            #保留舊值
      LET g_pow03_t = g_pow03            #保留舊值
      LET g_curr_t = g_curr              #保留舊值
      EXIT WHILE
   END WHILE

END FUNCTION

#處理INPUT
FUNCTION i002_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680136 VARCHAR(1)
    l_pow05         LIKE pow_file.pow05

    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT g_pow01, g_pow02,g_pow03  WITHOUT DEFAULTS
          FROM pow01,pow02,pow03

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i002_set_entry(p_cmd)
         CALL i002_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

        AFTER FIELD pow01                # 流程代號
           IF NOT cl_null(g_pow01) THEN
              IF g_pow01 != g_pow01_t OR g_pow01_t IS NULL THEN
                 CALL i002_poz('a',g_pow01)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pow01,g_errno,0)
                    LET g_pow01 = g_pow01_t
                    DISPLAY g_pow01 TO pow01
                    NEXT FIELD pow01
                 END IF
              END IF
           END IF

        AFTER FIELD pow02                #生效日期
           IF NOT cl_null(g_pow02) THEN
              IF g_pow02 IS NOT NULL AND   # 若輸入或更改且改KEY
                 (g_pow01!=g_pow01_t OR g_pow02!=g_pow02_t
                  OR g_pow02_t IS NULL) THEN
                 CALL i002_pox(g_pow01,g_pow02)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pow02,g_errno,0)
                    LET g_pow02 = g_pow02_t
                    DISPLAY g_pow02 TO pow02
                    NEXT FIELD pow02
                 END IF
              END IF
           END IF

        AFTER FIELD pow03                #工廠編號
           IF NOT cl_null(g_pow03) THEN
              IF g_pow03 IS NOT NULL AND   # 若輸入或更改且改KEY
                 (g_pow01!=g_pow01_t OR g_pow02!=g_pow02_t OR
                  g_pow03!=g_pow03_t OR g_pow03_t IS NULL)   THEN
                 CALL i002_poy(g_pow01,g_pow03) RETURNING g_curr
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pow03,g_errno,0)
                    LET g_pow03 = g_pow03_t
                    DISPLAY g_pow03 TO pow03
                    NEXT FIELD pow03
                 END IF
                 DISPLAY g_curr TO FORMONLY.curr
              END IF
              IF p_cmd="a" OR (p_cmd="u" AND
                 (g_pow01!=g_pow01_t OR g_pow02!=g_pow02_t OR
                  g_pow03!=g_pow03_t) )   THEN
                 LET g_cnt=0
                 SELECT count(*) INTO g_cnt FROM pow_file
                  WHERE pow01 = g_pow01 AND pow02 = g_pow02
                    AND pow03 = g_pow03
                 IF g_cnt > 0 THEN        #資料重複
                    LET g_msg = g_pow01 CLIPPED,' + ', g_pow02 CLIPPED
                    CALL cl_err(g_msg,-239,0)
                    LET g_pow01 = g_pow01_t
                    LET g_pow02 = g_pow02_t
                    LET g_pow03 = g_pow03_t
                    DISPLAY g_pow01 TO pow01
                    DISPLAY g_pow02 TO pow02
                    DISPLAY g_pow03 TO pow03
                    NEXT FIELD pow01
                 END IF
              END IF
           END IF

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pow01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_poz"
                 LET g_qryparam.default1 = g_pow01
                 CALL cl_create_qry() RETURNING g_pow01
                 DISPLAY BY NAME g_pow01
                 NEXT FIELD pow01
              WHEN INFIELD(pow03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_poy"
                 LET g_qryparam.arg1 = g_pow01
                  LET g_qryparam.default1 = g_pow03  #MOD-570096
                 CALL cl_create_qry() RETURNING g_pow03
                 DISPLAY BY NAME g_pow03
                 NEXT FIELD pow03
              OTHERWISE
           END CASE

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

    END INPUT
END FUNCTION

FUNCTION i002_q()

  DEFINE l_pow01  LIKE pow_file.pow01,
         l_pow02  LIKE pow_file.pow02,
         l_pow03  LIKE pow_file.pow03,
         l_curr   LIKE pow_file.pow02,
         l_cnt    LIKE type_file.num10           #No.FUN-680136 INTEGER

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pow01 TO NULL               #No.FUN-6A0162
    INITIALIZE g_pow02 TO NULL               #No.FUN-6A0162
    INITIALIZE g_pow03 TO NULL               #No.FUN-6A0162
    INITIALIZE g_curr TO NULL                #No.FUN-6A0162
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL i002_cs()                            #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_pow01 TO NULL
      INITIALIZE g_pow02 TO NULL
      INITIALIZE g_pow03 TO NULL
      INITIALIZE g_curr TO NULL
      RETURN
   END IF
   OPEN i002_bcs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pow01 TO NULL
      INITIALIZE g_pow02 TO NULL
      INITIALIZE g_pow03 TO NULL
      INITIALIZE g_curr TO NULL
   ELSE
      OPEN i002_count
      FETCH i002_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i002_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION i002_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680136 VARCHAR(1)

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i002_bcs INTO g_pow01,g_pow02,g_pow03
        WHEN 'P' FETCH PREVIOUS i002_bcs INTO g_pow01,g_pow02,g_pow03
        WHEN 'F' FETCH FIRST    i002_bcs INTO g_pow01,g_pow02,g_pow03
        WHEN 'L' FETCH LAST     i002_bcs INTO g_pow01,g_pow02,g_pow03
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
            FETCH ABSOLUTE g_jump i002_bcs INTO g_pow01,g_pow02,g_pow03
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_pow01,SQLCA.sqlcode,0)
       INITIALIZE g_pow01 TO NULL  #TQC-6B0105
       INITIALIZE g_pow02 TO NULL  #TQC-6B0105
       INITIALIZE g_pow03 TO NULL  #TQC-6B0105
    ELSE
       OPEN i002_count
       FETCH i002_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i002_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION

FUNCTION i002_show()

    CALL i002_poy(g_pow01,g_pow03) RETURNING g_curr
    DISPLAY g_pow01 TO pow01
    DISPLAY g_pow02 TO pow02
    DISPLAY g_pow03 TO pow03
    DISPLAY g_curr TO curr
    CALL i002_poz('d',g_pow01)
    CALL i002_b_fill(g_wc)                 #單身

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION i002_poz(p_cmd,p_pow01)
  DEFINE l_pozacti LIKE poz_file.pozacti
  DEFINE p_pow01   LIKE pow_file.pow01
  DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)

  SELECT poz02,pozacti INTO g_poz02,l_pozacti
    FROM poz_file WHERE poz01=p_pow01
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'tri-006'
                                 LET g_poz02 = NULL
       WHEN l_pozacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF p_cmd != 'c' THEN
     IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY g_poz02 TO FORMONLY.poz02
     END IF
  END IF
END FUNCTION

#計價方式
FUNCTION i002_pox(p_pow01,p_pow02)
  DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
  DEFINE p_pow01   LIKE pow_file.pow01
  DEFINE p_pow02   LIKE pow_file.pow02

  SELECT COUNT(*) INTO g_cnt
    FROM pox_file WHERE pox01=p_pow01 AND pox02 = p_pow02
  CASE WHEN g_cnt = 0     LET g_errno = 'tri-007'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION

FUNCTION i002_poy(p_pow01,p_pow03)
   DEFINE p_curr  LIKE poy_file.poy05,
          p_pow01 LIKE pow_file.pow01,
          p_pow03 LIKE pow_file.pow03

  SELECT poy05 INTO p_curr FROM poy_file
    WHERE poy01=p_pow01 AND poy04 = p_pow03
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apm-277'
                                 LET g_curr  = NULL
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  RETURN p_curr
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i002_r()

   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_pow01 IS NULL OR g_pow02 IS NULL OR g_pow03 IS NULL  THEN
      CALL cl_err("",-400,0)                 #No.FUN-6A0162
      RETURN
   END IF
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pow01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "pow02"      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "pow03"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pow01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_pow02       #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_pow03       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM pow_file
       WHERE pow01 = g_pow01
         AND pow02 = g_pow02
         AND pow03 = g_pow03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","pow_file",g_pow01,g_pow02,SQLCA.sqlcode,
                      "","BODY DELETE",1)  #No.FUN-660129
      ELSE
         CLEAR FORM
         CALL g_pow.clear()
         LET g_delete='Y'
         LET g_pow01 = NULL
         LET g_pow02 = NULL
         LET g_pow03 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
         PREPARE i002_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i002_precount_x2                 #No.TQC-720019
         OPEN i002_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i002_bcs
            CLOSE i002_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i002_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i002_bcs
            CLOSE i002_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i002_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i002_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i002_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION

#單身
FUNCTION i002_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680136 SMALLINT
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680136 SMALLINT

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pow01 IS NULL OR g_pow02 IS NULL OR g_pow03 IS NULL  THEN
       RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT pow05,pow06,powuser,powgrup,powmodu,powdate",
                       "  FROM pow_file",
                       "  WHERE pow01=? AND pow02=? AND pow03=?",
                       "   AND pow05=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_bcl CURSOR FROM g_forupd_sql

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_pow WITHOUT DEFAULTS FROM s_pow.*
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
              LET p_cmd='u'
              LET g_pow_t.* = g_pow[l_ac].*      #BACKUP
              LET g_pow05_o = g_pow[l_ac].pow05  #BACKUP
              OPEN i002_bcl USING g_pow01,g_pow02,g_pow03,g_pow_t.pow05
              FETCH i002_bcl INTO g_pow[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_pow_t.pow05,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              LET g_pow_t.* = g_pow[l_ac].*      #BACKUP
              LET g_pow05_o = g_pow[l_ac].pow05  #BACKUP
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF

        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_pow[l_ac].* TO NULL      #900423
           LET g_pow[l_ac].powuser = g_user
           LET g_pow[l_ac].powgrup = g_grup
           LET g_pow_t.* = g_pow[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD pow05

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           INSERT INTO pow_file(pow01,pow02,pow03,pow04,pow05,
                                pow06,pow07,pow08,powuser,powgrup,
                                 powmodu,powdate,poworiu,poworig)  #No.MOD-470041
           VALUES(g_pow01,g_pow02,g_pow03,'',g_pow[l_ac].pow05,
                  g_pow[l_ac].pow06,'','',g_user,g_grup,'','', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","pow_file",g_pow[l_ac].pow05,"",
                            SQLCA.sqlcode,"","",1)  #No.FUN-660129
              LET g_pow[l_ac].* = g_pow_t.*
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
           END IF
           LET g_msg=TIME
           LET l_str=g_pow[l_ac].pow06 USING "#######&.&&&&", "(ins)"
           INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980006 add azoplant,azolegal
             VALUES ('apmi002',g_user,g_today,g_msg,g_pow[l_ac].pow05,l_str,g_plant,g_legal) #FUN-980006 add g_plant,g_legal

        AFTER FIELD pow05                        #check 序號是否重複
           IF NOT cl_null(g_pow[l_ac].pow05) THEN
              IF g_pow[l_ac].pow05 != g_pow_t.pow05 OR g_pow_t.pow05 IS NULL THEN
                 SELECT count(*) INTO l_n FROM pow_file
                  WHERE pow01 = g_pow01
                    AND pow02 = g_pow02
                    AND pow03 = g_pow03
                    AND pow05 = g_pow[l_ac].pow05
                 IF l_n > 0 THEN
                    CALL cl_err(g_pow[l_ac].pow05,-239,0)
                    LET g_pow[l_ac].pow05 = g_pow_t.pow05
                    NEXT FIELD pow05
                 END IF
              END IF
           END IF

        AFTER FIELD pow06                        #check 序號是否重複
           IF NOT cl_null(g_pow[l_ac].pow06) THEN
              IF g_pow[l_ac].pow06 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD pow06
              END IF
           END IF
            IF NOT cl_null(g_pow[l_ac].pow05) AND g_pow[l_ac].pow06 IS NULL THEN
                NEXT FIELD pow06
            END IF

        BEFORE DELETE                            #是否取消單身
           IF g_pow[l_ac].pow05 IS NOT NULL AND g_pow_t.pow05 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM pow_file
               WHERE pow01 = g_pow01
                 AND pow02 = g_pow02
                 AND pow03 = g_pow03
                 AND pow05 = g_pow_t.pow05
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pow_file",g_pow_t.pow05,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b-1
              LET g_msg=TIME
              LET l_str=g_pow_t.pow06 USING "#######&.&&&&", "(del)"
              INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980006 add azoplant,azolegal
                        VALUES ('apmi002',g_user,g_today,g_msg,
                                g_pow[l_ac].pow05,l_str,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
           END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pow[l_ac].* = g_pow_t.*
              CLOSE i002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pow[l_ac].pow05,-263,1)
              LET g_pow[l_ac].* = g_pow_t.*
           ELSE
              LET g_pow[l_ac].powmodu = g_user			#MOD-990006
              LET g_pow[l_ac].powdate = g_today			#MOD-990006
              UPDATE pow_file SET pow05=g_pow[l_ac].pow05,
                                  pow06=g_pow[l_ac].pow06,
                                  powmodu=g_pow[l_ac].powmodu,
                                  powdate=g_pow[l_ac].powdate
               WHERE pow01=g_pow01
                 AND pow02=g_pow02
                 AND pow03 = g_pow03
                 AND pow05=g_pow_t.pow05
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pow_file",g_pow[l_ac].pow05,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_pow[l_ac].* = g_pow_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
              LET g_msg=TIME
              LET l_str=g_pow_t.pow06 USING "#######&.&&&&", "(o_upd)"
              INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980006 add azoplant,azolegal
                VALUES ('apmi002',g_user,g_today,g_msg,g_pow[l_ac].pow05,l_str,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac                 #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_pow[l_ac].* = g_pow_t.* 
              #FUN-D30034---add---str---
              ELSE
                 CALL g_pow.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end--- 
              END IF
              CLOSE i002_bcl
              ROLLBACK WORK
              EXIT INPUT
         ELSE
           IF NOT cl_null(g_pow[l_ac].pow06) THEN
              IF g_pow[l_ac].pow06 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD pow06
              END IF
           END IF
           END IF
           LET l_ac_t = l_ac      #FUN-D30034 add
           CLOSE i002_bcl
           COMMIT WORK

        #No.TQC-A30035  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pow05)
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form ="q_ima"
              #   LET g_qryparam.default1 = g_pow[l_ac].pow05
              #   CALL cl_create_qry() RETURNING g_pow[l_ac].pow05
                 CALL q_sel_ima(FALSE, "q_ima", "", g_pow[l_ac].pow05, "", "", "", "" ,"",'' )  RETURNING g_pow[l_ac].pow05
#FUN-AA0059 --End--
                 NEXT FIELD pow05
              OTHERWISE EXIT CASE
           END CASE
        #No.TQC-A30035  --End

        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(pow05) AND l_ac > 1 THEN
              LET g_pow[l_ac].* = g_pow[l_ac-1].*
              NEXT FIELD pow05
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


        ON ACTION test_qbe
                 CALL i002_pow05(g_pow[l_ac].pow05)

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

    END INPUT

    CLOSE i002_bcl
        COMMIT WORK

END FUNCTION

FUNCTION i002_pow05(p_pow05)
  DEFINE l_cnt LIKE type_file.num10,        #No.FUN-680136 INTEGER
         l_chr LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
         p_pow05  LIKE pow_file.pow05,
         l_db_type  LIKE type_file.chr3,    #MOD-860291
         l_msg LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(60)
   LET l_cnt = 0

   LET l_db_type=cl_db_get_database_type()
   IF l_db_type='ORA' OR l_db_type='MSV' OR l_db_type='ASE' THEN              #NO.TQC-950170 FUN-A70145
      LET p_pow05=cl_replace_str(p_pow05, "*", "%")
      LET g_sql = "SELECT COUNT(*) FROM ima_file ",
                  " WHERE ima01 LIKE '",p_pow05,"' "
   ELSE
      LET p_pow05=cl_replace_str(p_pow05, "%", "*")
      LET g_sql = "SELECT COUNT(*) FROM ima_file ",
                  " WHERE ima01 MATCHES '",p_pow05,"' "
   END IF

   PREPARE i002_pow05_pre FROM g_sql
   DECLARE i002_pow05_count CURSOR FOR i002_pow05_pre
   OPEN i002_pow05_count
   FETCH i002_pow05_count INTO l_cnt
   IF SQLCA.SQLCODE <> 0 THEN
      LET l_cnt=0
   END IF
   CASE g_lang
     WHEN '0'
        LET l_msg="● 合乎條件之料件筆數共計 :",l_cnt,"筆"
     WHEN '2'
        LET l_msg="● 合乎條件之料件筆數共計 :",l_cnt,"筆"
     OTHERWISE
        LET l_msg="● Matches data records : ",l_cnt
   END CASE
   OPEN WINDOW i002_w2 AT 20,10 WITH 3 ROWS, 50 COLUMNS

   WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
      PROMPT l_msg CLIPPED FOR CHAR l_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


      END PROMPT
      IF INT_FLAG THEN LET INT_FLAG = 0 END IF
      CLOSE WINDOW i002_w2
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i002_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000                 #No.FUN-680136 VARCHAR(200)

    CONSTRUCT l_wc ON pow05,pow06             #螢幕上取條件
       FROM s_pow[1].pow05,s_pow[1].pow06
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i002_b_fill(l_wc)
END FUNCTION

FUNCTION i002_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000        #No.FUN-680136 VARCHAR(200) #TQC-840066

    LET g_sql = "SELECT pow05,pow06,powuser,powgrup,powmodu,powdate ",
                "  FROM pow_file ",
                " WHERE pow01 = '",g_pow01,"' AND pow02 = '",g_pow02,"'",
                "   AND pow03 ='",g_pow03,"' ",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY 1"
    PREPARE i002_prepare2 FROM g_sql      #預備一下
    DECLARE pow_cs CURSOR FOR i002_prepare2

    CALL g_pow.clear()   #FUN-5A0157
    LET g_cnt = 1
    LET g_rec_b=0

    FOREACH pow_cs INTO g_pow[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pow.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1               #no.6277
    LET g_cnt = 0

END FUNCTION

FUNCTION i002_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF

    LET g_action_choice = " "

    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_pow TO s_pow.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION first
         CALL i002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION previous
         CALL i002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION jump
         CALL i002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION next
         CALL i002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION last
         CALL i002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

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

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

       ON ACTION related_document  #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel    #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY   #TQC-5B0076

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
      &include "qry_string.4gl"
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION



FUNCTION i002_copy()
  DEFINE  tm RECORD
           pow01    LIKE pow_file.pow01,
           pow02    LIKE pow_file.pow02,
           pow03    LIKE pow_file.pow03,
           pow01_e  LIKE pow_file.pow01,
           pow02_e  LIKE pow_file.pow02,
           pow03_e  LIKE pow_file.pow03,
           diff_price LIKE pow_file.pow06
          END RECORD
  DEFINE l_pow   RECORD LIKE pow_file.*
    OPEN WINDOW i002_cw AT 11,13 WITH FORM "apm/42f/apmi002c"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_locale("apmi002c")


    LET tm.pow01 = g_pow01
    LET tm.pow02 = g_pow02
    LET tm.pow03 = g_pow03
    LET tm.pow01_e=null
    LET tm.pow02_e=null
    LET tm.pow03_e=null
    LET tm.diff_price = 0
    DISPLAY BY NAME tm.*
    BEGIN WORK

    INPUT BY NAME tm.* WITHOUT DEFAULTS
        AFTER FIELD pow01_e               # 流程代號
            IF cl_null(tm.pow01_e) THEN NEXT FIELD pow01_e END IF
            CALL i002_poz('c',tm.pow01_e)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.pow01_e,g_errno,0)
               NEXT FIELD pow01_e
            END IF

        AFTER FIELD pow02_e                #生效日期
            IF cl_null(tm.pow02_e) THEN NEXT FIELD pow02_e END IF
               CALL i002_pox(tm.pow01_e,tm.pow02_e)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.pow02_e,g_errno,0)
                  NEXT FIELD pow02_e
               END IF

        AFTER FIELD pow03_e                #工廠編號
            IF cl_null(tm.pow03_e) THEN NEXT FIELD pow03_e END IF
               CALL i002_poy(tm.pow01_e,tm.pow03_e) RETURNING g_curr
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.pow03_e,g_errno,0)
                  NEXT FIELD pow03_e
               END IF
               SELECT count(*) INTO g_cnt FROM pow_file
                   WHERE pow01 = tm.pow01_e AND pow02 = tm.pow02_e
                     AND pow03 = tm.pow03_e
               IF g_cnt > 0 THEN        #資料重複
                   LET g_msg = g_pow01 CLIPPED,' + ', g_pow02 CLIPPED
                   CALL cl_err(g_msg,-239,0)
                   NEXT FIELD pow01_e
               END IF

          AFTER INPUT
              IF INT_FLAG THEN EXIT INPUT END IF
            IF cl_null(tm.pow01_e) THEN NEXT FIELD pow01_e END IF
            IF cl_null(tm.pow02_e) THEN NEXT FIELD pow02_e END IF
            IF cl_null(tm.pow03_e) THEN NEXT FIELD pow03_e END IF

        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(pow01_e)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_poz"
                  LET g_qryparam.default1 = tm.pow01_e
                  CALL cl_create_qry() RETURNING tm.pow01_e
                  DISPLAY BY NAME tm.pow01_e
                  NEXT FIELD pow01_e
                WHEN INFIELD(pow03_e)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_poy"
                  LET g_qryparam.default1 = tm.pow01_e
                  LET g_qryparam.arg1     = tm.pow01_e
                  CALL cl_create_qry() RETURNING tm.pow03_e
                  DISPLAY BY NAME tm.pow03_e
                  NEXT FIELD pow03_e
                OTHERWISE
            END CASE
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
       LET INT_FLAG=0
       ROLLBACK WORK
       CLOSE WINDOW i002_cw
       RETURN
    END IF
    IF tm.diff_price IS NULL THEN LET tm.diff_price = 0 END IF
    IF NOT cl_sure(0,0) THEN ROLLBACK WORK CLOSE WINDOW i002_cw RETURN END IF
    CLOSE WINDOW i002_cw
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032

    DROP TABLE x   #No.9315
    SELECT * FROM pow_file
       WHERE pow01=tm.pow01
         AND pow02=tm.pow02
         AND pow03=tm.pow03
        INTO TEMP x

    IF STATUS THEN
       CALL cl_err3("ins","pow_file",tm.pow01,tm.pow02,STATUS,"","pow- x:",1)  #No.FUN-660129
       ROLLBACK WORK
       RETURN
    END IF

    UPDATE x SET pow01=tm.pow01_e,
                 pow02=tm.pow02_e,
                 pow03=tm.pow03_e ,
                 pow06=pow06+tm.diff_price,
                 powuser=g_user,
                 powgrup=g_grup

    INSERT INTO pow_file SELECT * FROM x

    IF STATUS THEN
       CALL cl_err3("ins","pow_file","","",STATUS,"","ins pow",1)  #No.FUN-660129
       ROLLBACK WORK
       RETURN
    END IF

    DROP TABLE x

    COMMIT WORK
    MESSAGE "Copy Ok!"
    LET g_pow01=tm.pow01_e
    LET g_pow02=tm.pow02_e
    LET g_pow03=tm.pow03_e
    CALL i002_show()
END FUNCTION

FUNCTION i002_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("pow01,pow02,pow03",TRUE)
    END IF

END FUNCTION

FUNCTION i002_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1)

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("pow01,pow02,pow03",FALSE)
    END IF

END FUNCTION

FUNCTION i002_out()
    DEFINE
        sr              RECORD LIKE pow_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
        l_pow           RECORD LIKE pow_file.*,
        l_gen           RECORD LIKE gen_file.*,
        l_name          LIKE type_file.chr20,         #No.FUN-680136 VARCHAR(20)
        l_curr          LIKE poy_file.poy05,
        l_za05          LIKE type_file.chr1000        #No.FUN-680136 VARCHAR(40)

    IF cl_null(g_wc) THEN
        LET g_wc="     pow01='",g_pow01,"'",
                 " AND pow02='",g_pow02,"'",
                 " AND pow03='",g_pow03,"'"
    END IF
    CALL cl_wait()

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     LET g_sql="SELECT pow03,pow01,poz02,pow02,poy05,pow05,pow06 ",
               "  FROM pow_file, poy_file, poz_file ",
               " WHERE pow01=poy_file.poy01 AND pow03=poy_file.poy04 AND pow01=poz_file.poz01 AND ",
               g_wc CLIPPED

    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
    IF g_zz05='Y' THEN
        CALL cl_wcchp(g_wc,'pow03,pow01,pow02,pow05,pow06')
        RETURNING g_wc2
    END IF
    LET g_str=g_wc2
    CALL cl_prt_cs1("apmi002","apmi002",g_sql,g_str)

END FUNCTION
#No:FUN-9C0071--------精簡程式-----
