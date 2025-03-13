# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi140.4gl
# Descriptions...: 資本支出預算維護作業
# Date & Author..: 02/09/24 By nicola
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/14 By jamie 新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 g_no_ask 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 07/12/17 By lala   報表轉為使用p_query
# Modify.........: No.FUN-980001 09/08/05 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9B0161 09/11/24 By Dido 查詢欄位有誤 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
   g_bgo01         LIKE bgo_file.bgo01,   #版本
   g_bgo01_t       LIKE bgo_file.bgo01,   #版本(舊值)
   g_bgo02         LIKE bgo_file.bgo02,   #設備名稱
   g_bgo02_t       LIKE bgo_file.bgo02,   #設備名稱(舊值)
   g_bgo03         LIKE bgo_file.bgo03,   #資產類別
   g_bgo03_t       LIKE bgo_file.bgo03,   #資產類別(舊值)
   g_bgo032        LIKE bgo_file.bgo032,  #分攤部門
   g_bgo032_t      LIKE bgo_file.bgo032,  #分攤部門(舊值)
   g_bgo033        LIKE bgo_file.bgo033,  #部門編號/分攤類別
   g_bgo033_t      LIKE bgo_file.bgo033,  #部門編號/分攤類別(舊值)
   g_bgo06         LIKE bgo_file.bgo06,   #年度
   g_bgo06_t       LIKE bgo_file.bgo06,   #年度(舊值)
   g_bgo07         LIKE bgo_file.bgo07,   #月份                                                                                     
   g_bgo07_t       LIKE bgo_file.bgo07,   #月份(舊值)
   g_bgo           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
      bgo07        LIKE bgo_file.bgo07,   #月份
      bgo08        LIKE bgo_file.bgo08,   #單價
      bgo09        LIKE bgo_file.bgo09,   #數量
      bgo10        LIKE bgo_file.bgo10    #金額
                   END RECORD,
   g_bgo_t         RECORD                 #程式變數(舊值)
      bgo07        LIKE bgo_file.bgo07,   #月份
      bgo08        LIKE bgo_file.bgo08,   #單價
      bgo09        LIKE bgo_file.bgo09,   #數量
      bgo10        LIKE bgo_file.bgo10    #金額
                   END RECORD,
   g_wc,g_sql,g_wc2    string,            #No.FUN-580092 HCN
   g_rec_b         LIKE type_file.num5,   #單身筆數 #No.FUN-680061 SMALLINT
   l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680061 SMALLINT
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp      STRING   #No.TQC-720019
DEFINE   g_cnt          LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE   g_i            LIKE type_file.num5         #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03           #No.FUN-680061 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #查詢指定的筆數     #No.FUN-680061 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5         #是否開啟指定筆視窗 #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask 
 
#主程式開始
MAIN
   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0056
 
    OPEN WINDOW i140_w WITH FORM "abg/42f/abgi140"
       ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL i140_menu()
 
    CLOSE WINDOW i140_w                      #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i140_cs()
    CLEAR FORM                               #清除畫面
    CALL g_bgo.clear()
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_bgo01 TO NULL    #No.FUN-750051
   INITIALIZE g_bgo02 TO NULL    #No.FUN-750051
   INITIALIZE g_bgo03 TO NULL    #No.FUN-750051
   #CONSTRUCT g_wc ON bgo01,bgo06,bgo03,bgo02,bgo032,bgo33,bgo07,bgo08,bgo09,bgo10      #MOD-9B0161 mark
    CONSTRUCT g_wc ON bgo01,bgo06,bgo03,bgo02,bgo032,bgo033,bgo07,bgo08,bgo09,bgo10     #MOD-9B0161
    FROM bgo01,bgo06,bgo03,bgo02,bgo032,bgo033,s_bgo[1].bgo07,s_bgo[1].bgo08,s_bgo[1].bgo09,s_bgo[1].bgo10
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bgo03)
            #  CALL q_fab(05,11,g_bgo03) RETURNING g_bgo03
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_fab"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bgo03
               NEXT FIELD bgo03
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
 
    LET g_sql= "SELECT UNIQUE bgo01,bgo02,bgo03,bgo032,bgo033,bgo06 ",
               " FROM bgo_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bgo01"
    PREPARE i140_prepare FROM g_sql          #預備一下
    DECLARE i140_bcs                         #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i140_prepare
 
#   LET g_sql="SELECT UNIQUE bgo01,bgo02,bgo03,bgo032,bgo033,bgo06 ",      #No.TQC-720019
    LET g_sql_tmp="SELECT UNIQUE bgo01,bgo02,bgo03,bgo032,bgo033,bgo06 ",  #No.TQC-720019
              " FROM bgo_file ",
              " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i140_pre_x FROM g_sql      #No.TQC-720019
    PREPARE i140_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i140_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i140_precount FROM g_sql
    DECLARE i140_count CURSOR FOR i140_precount
 
    CALL i140_show()
END FUNCTION
 
#中文的MENU
FUNCTION i140_menu()
DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-820002
   WHILE TRUE
      CALL i140_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i140_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i140_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i140_u()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i140_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i140_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
         IF cl_chk_act_auth()                                                   
               THEN CALL i140_out() 
         END IF                                           
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgo),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bgo01 IS NOT NULL THEN
                LET g_doc.column1 = "bgo01"
                LET g_doc.column2 = "bgo02"
                LET g_doc.column3 = "bgo03"
                LET g_doc.column4 = "bgo06" 
                LET g_doc.value1 = g_bgo01
                LET g_doc.value2 = g_bgo02
                LET g_doc.value3 = g_bgo03
                LET g_doc.value4 = g_bgo06
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0003-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i140_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_bgo.clear()
   LET g_bgo01_t  = NULL
   LET g_bgo02_t  = NULL
   LET g_bgo03_t  = NULL
   LET g_bgo032_t = NULL
   LET g_bgo033_t = NULL
   CALL cl_opmsg('a')
   WHILE TRUE
      INITIALIZE g_bgo01  TO NULL
      INITIALIZE g_bgo02  TO NULL
      INITIALIZE g_bgo03  TO NULL
      INITIALIZE g_bgo032 TO NULL
      INITIALIZE g_bgo033 TO NULL
      INITIALIZE g_bgo06  TO NULL
      CALL i140_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_bgo01=NULL
         LET g_bgo02=NULL
         LET g_bgo03=NULL
         LET g_bgo032=NULL
         LET g_bgo033=NULL
         LET g_bgo06=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
     IF cl_null(g_bgo02)  OR
        cl_null(g_bgo03)  OR
        cl_null(g_bgo032)  OR
        cl_null(g_bgo033)  OR
        cl_null(g_bgo06)  THEN
        CONTINUE WHILE
     END IF
      CALL g_bgo.clear()
      LET g_rec_b = 0                    #No.FUN-680064
      CALL i140_b_fill('1=1')            #單身
      CALL i140_b()                      #輸入單身
      LET g_bgo01_t = g_bgo01
      LET g_bgo02_t = g_bgo02
      LET g_bgo03_t = g_bgo03
      LET g_bgo032_t= g_bgo032
      LET g_bgo033_t= g_bgo033
      LET g_bgo06_t = g_bgo06
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i140_u()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bgo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bgo01_t        = g_bgo01
    LET g_bgo02_t        = g_bgo02
    LET g_bgo03_t        = g_bgo03
    LET g_bgo032_t       = g_bgo032
    LET g_bgo033_t       = g_bgo033
    LET g_bgo06_t        = g_bgo06
    BEGIN WORK
    WHILE TRUE
        CALL i140_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bgo01          = g_bgo01_t
            LET g_bgo02          = g_bgo02_t
            LET g_bgo03          = g_bgo03_t
            LET g_bgo032         = g_bgo032_t
            LET g_bgo033         = g_bgo033_t
            LET g_bgo06          = g_bgo06_t
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE bgo_file
	   SET bgo01 = g_bgo01,
               bgo02 = g_bgo02,
               bgo03 = g_bgo03,
               bgo06 = g_bgo06,
               bgo032= g_bgo032,
               bgo033= g_bgo033
         WHERE bgo01 = g_bgo01_t
           AND bgo02 = g_bgo02_t
           AND bgo03 = g_bgo03_t
           AND bgo06 = g_bgo06_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("upd","bgo_file",g_bgo01_t,g_bgo02_t,SQLCA.sqlcode,"","",1) #FUN-660105
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i140_i(p_cmd)
   DEFINE
      p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
      l_n             LIKE type_file.num5,    #No.FUN-680061 SMALLINT
      l_str           LIKE type_file.chr50,   #No.FUN-680061 VARCHAR(40)
      l_fab11         LIKE fab_file.fab11
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INPUT g_bgo01,g_bgo06,g_bgo03,g_bgo02,g_bgo032,g_bgo033 WITHOUT DEFAULTS
         FROM bgo01,bgo06,bgo03,bgo02,bgo032,bgo033 HELP 1
 
#No.FUN-570108--begin
        BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i140_set_entry(p_cmd)
        CALL i140_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
#No.FUN-570108--end
      AFTER FIELD bgo01
         IF cl_null(g_bgo01) THEN LET g_bgo01 = ' ' END IF
 
      AFTER FIELD bgo06                    #年度
         IF NOT cl_null(g_bgo06) THEN
            IF g_bgo06 < 1 THEN
               NEXT FIELD bgo06
            END IF
         END IF
 
      AFTER FIELD bgo03                    #資產類別
         IF NOT cl_null(g_bgo03) THEN
            SELECT COUNT(*) INTO g_cnt FROM fab_file
              WHERE fab01=g_bgo03 AND fabacti = 'Y'
            IF g_cnt = 0 THEN
               CALL cl_err('','afa-041',0) NEXT FIELD bgo03
            END IF
         END IF
 
      AFTER FIELD bgo033
         IF NOT cl_null(g_bgo033) THEN
            IF g_bgo032 = '1' THEN
               SELECT COUNT(*) INTO g_cnt
                  FROM gem_file WHERE gem01=g_bgo033 AND gemacti = 'Y'
               IF g_cnt = 0 THEN
                  CALL cl_err('','aap-039',0) NEXT FIELD bgo033
               END IF
            END IF
            IF g_bgo032 = '2' THEN
               LET l_fab11 = NULL
               SELECT fab11 INTO l_fab11
                      FROM fab_file WHERE fab01 = g_bgo03
               SELECT COUNT(*) INTO g_cnt
                      FROM fad_file WHERE fad01 = g_bgo06
                                      AND fad03 = l_fab11
                                      AND fad04 = g_bgo033
               IF g_cnt = 0 THEN
                  CALL cl_err('','agl-118',0) NEXT FIELD bgo033
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bgo03)
            #  CALL q_fab(05,11,g_bgo03) RETURNING g_bgo03
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_fab"
               LET g_qryparam.default1 = g_bgo03
               CALL cl_create_qry() RETURNING g_bgo03
               DISPLAY g_bgo03 TO bgo03
               NEXT FIELD bgo03
            WHEN INFIELD(bgo033)
               IF g_bgo032='1' THEN
               #  CALL q_gem(05,11,g_bgo033) RETURNING g_bgo033
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_bgo033
                  CALL cl_create_qry() RETURNING g_bgo033
                  DISPLAY g_bgo033 TO bgo033
                  NEXT FIELD bgo033
               END IF
               IF g_bgo032='2' THEN
               #  CALL q_fad(05,11,g_bgo033) RETURNING g_bgo033,l_fab11
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fad"
                  LET g_qryparam.default1 = g_bgo033
                  LET g_qryparam.default2 = l_fab11
                  CALL cl_create_qry() RETURNING l_fab11,g_bgo033
                  DISPLAY g_bgo033 TO bgo033
                  NEXT FIELD bgo033
               END IF
         END CASE
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
END FUNCTION
 
 
#Query 查詢
FUNCTION i140_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   INITIALIZE g_bgo01  TO NULL
   INITIALIZE g_bgo02  TO NULL
   INITIALIZE g_bgo03  TO NULL
   INITIALIZE g_bgo032 TO NULL
   INITIALIZE g_bgo033 TO NULL
   INITIALIZE g_bgo06  TO NULL
   CALL g_bgo.clear()
   CALL i140_cs()                      #取得查詢條件
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_bgo01  TO NULL
      INITIALIZE g_bgo02  TO NULL
      INITIALIZE g_bgo03  TO NULL
      INITIALIZE g_bgo032 TO NULL
      INITIALIZE g_bgo033 TO NULL
      INITIALIZE g_bgo06  TO NULL
      RETURN
   END IF
   OPEN i140_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bgo01  TO NULL
      INITIALIZE g_bgo02  TO NULL
      INITIALIZE g_bgo03  TO NULL
      INITIALIZE g_bgo032 TO NULL
      INITIALIZE g_bgo033 TO NULL
      INITIALIZE g_bgo06  TO NULL
   ELSE
      OPEN i140_count
      FETCH i140_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i140_fetch('F')             #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i140_fetch(p_flag)
   DEFINE
      p_flag          LIKE type_file.chr1        #處理方式    #No.FUN-680061 VARCHAR(01)
#     g_jump          LIKE type_file.num10       #絕對的筆數  #No.FUN-680061 INTEGER  #No.TQC-720019
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i140_bcs INTO g_bgo01,g_bgo02,g_bgo03,  
                                            g_bgo032,g_bgo033,g_bgo06
      WHEN 'P' FETCH PREVIOUS i140_bcs INTO g_bgo01,g_bgo02,g_bgo03, 
                                            g_bgo032,g_bgo033,g_bgo06
      WHEN 'F' FETCH FIRST    i140_bcs INTO g_bgo01,g_bgo02,g_bgo03, 
                                            g_bgo032,g_bgo033,g_bgo06
      WHEN 'L' FETCH LAST     i140_bcs INTO g_bgo01,g_bgo02,g_bgo03, 
                                            g_bgo032,g_bgo033,g_bgo06
      WHEN '/'
      IF (NOT g_no_ask) THEN    #No.FUN-6A0057 g_no_ask 
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
         FETCH ABSOLUTE g_jump i140_bcs INTO g_bgo01,g_bgo02,g_bgo03, 
                                             g_bgo032,g_bgo033,g_bgo06
         LET g_no_ask = FALSE     #No.FUN-6A0057 g_no_ask 
   END CASE
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_bgo01,SQLCA.sqlcode,0)
      INITIALIZE g_bgo01  TO NULL  #TQC-6B0105
      INITIALIZE g_bgo02  TO NULL  #TQC-6B0105
      INITIALIZE g_bgo03  TO NULL  #TQC-6B0105
      INITIALIZE g_bgo032 TO NULL  #TQC-6B0105
      INITIALIZE g_bgo033 TO NULL  #TQC-6B0105
      INITIALIZE g_bgo06  TO NULL  #TQC-6B0105
   ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       CALL i140_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i140_show()
 
   DISPLAY g_bgo01  TO bgo01                 #單頭
   DISPLAY g_bgo02  TO bgo02                 #單頭
   DISPLAY g_bgo03  TO bgo03                 #單頭
   DISPLAY g_bgo032 TO bgo032                #單頭
   DISPLAY g_bgo033 TO bgo033                #單頭
   DISPLAY g_bgo06  TO bgo06                 #單頭
   CALL i140_b_fill(g_wc)                    #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i140_r()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_bgo01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF   #No.FUN-6A0003
   BEGIN WORK
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bgo01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "bgo02"      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "bgo03"      #No.FUN-9B0098 10/02/24
       LET g_doc.column4 = "bgo06"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bgo01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_bgo02       #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_bgo03       #No.FUN-9B0098 10/02/24
       LET g_doc.value4 = g_bgo06       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM bgo_file
      WHERE bgo01 = g_bgo01
        AND bgo02 = g_bgo02
        AND bgo03 = g_bgo03
        AND bgo032= g_bgo032
        AND bgo033= g_bgo033
        AND bgo06 = g_bgo06
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #FUN-660105
         CALL cl_err3("del","bgo_file",g_bgo01,g_bgo02,SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105
      ELSE
         CLEAR FORM
         #MOD-5A0004 add
         DROP TABLE x
#        EXECUTE i140_pre_x                  #No.TQC-720019
         PREPARE i140_pre_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i140_pre_x2                 #No.TQC-720019
         #MOD-5A0004 end
         CALL g_bgo.clear()
         OPEN i140_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i140_bcs
             CLOSE i140_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i140_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i140_bcs
             CLOSE i140_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i140_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i140_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE   #No.FUN-6A0057 g_no_ask 
            CALL i140_fetch('/')
         END IF
      END IF
      LET g_msg=TIME
     #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) ##FUN-980001 mark
            #VALUES ('abgi140',g_user,g_today,g_msg,g_bgo01,'delete') ##FUN-980001 mark
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
             VALUES ('abgi140',g_user,g_today,g_msg,g_bgo01,'delete',g_plant,g_legal) #FUN-980001 add
   END IF
   COMMIT WORK
END FUNCTION
 
 
#單身
FUNCTION i140_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-680061 SMALLINT
      l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-680061 SMALLINT
      l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680061 VARCHAR(01)
      p_cmd           LIKE type_file.chr1,     #處理狀態    #No.FUN-680061 VARCHAR(01)
      l_allow_insert  LIKE type_file.num5,     #可新增否    #No.FUN-680061 SMALLINT
      l_allow_delete  LIKE type_file.num5      #可刪除否    #No.FUN-680061 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
           "SELECT bgo07,bgo08,bgo09,bgo10 FROM bgo_file  WHERE bgo01  = ? ",
           "   AND bgo02  = ? AND bgo03  = ? AND bgo032 = ? AND bgo033 = ? ",
           "   AND bgo06  = ? AND bgo07  = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i140_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_bgo WITHOUT DEFAULTS FROM s_bgo.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_bgo_t.* = g_bgo[l_ac].*  #BACKUP
            OPEN i140_b_cl USING g_bgo01,g_bgo02,g_bgo03,g_bgo032,g_bgo033,g_bgo06,g_bgo_t.bgo07
            IF STATUS THEN
               CALL cl_err("OPEN i140_b_cl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_bgo01_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_bgo_t.*=g_bgo[l_ac].*
               END IF
               FETCH i140_b_cl INTO g_bgo[l_ac].*
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_bgo[l_ac].* TO NULL
         LET g_bgo_t.* = g_bgo[l_ac].*               #新輸入資料
         LET g_bgo[l_ac].bgo08 = 0
         LET g_bgo[l_ac].bgo09 = 0
         LET g_bgo[l_ac].bgo10 = 0
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bgo07
 
      AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO bgo_file(bgo01,bgo02,bgo03,bgo032,bgo033,
                               bgo06,bgo07,bgo08,bgo09,bgo10)
                 VALUES(g_bgo01,g_bgo02,g_bgo03,g_bgo032,g_bgo033,
                        g_bgo06,g_bgo[l_ac].bgo07,g_bgo[l_ac].bgo08,
                        g_bgo[l_ac].bgo09,g_bgo[l_ac].bgo10)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_bgo[l_ac].bgo07,SQLCA.sqlcode,0) #FUN-660105
             CALL cl_err3("ins","bgo_file",g_bgo01,g_bgo[l_ac].bgo07,SQLCA.sqlcode,"","",1) #FUN-660105
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
      BEFORE FIELD bgo07
         IF cl_null(g_bgo[l_ac].bgo07) THEN
            SELECT MAX(bgo07)+1 INTO g_bgo[l_ac].bgo07 FROM bgo_file
             WHERE bgo01 = g_bgo01
               AND bgo02 = g_bgo02
               AND bgo03 = g_bgo03
               AND bgo032= g_bgo032
               AND bgo033= g_bgo033
               AND bgo06 = g_bgo06
            IF cl_null(g_bgo[l_ac].bgo07) THEN LET g_bgo[l_ac].bgo07 = 1 END IF
         END IF
 
      AFTER FIELD bgo07                    #月份
         IF NOT cl_null(g_bgo[l_ac].bgo07) THEN
            IF g_bgo[l_ac].bgo07 != g_bgo_t.bgo07 THEN   
               SELECT COUNT(*) INTO g_cnt
                      FROM bgo_file
                      WHERE bgo01  = g_bgo01
                        AND bgo02  = g_bgo02
                        AND bgo03  = g_bgo03
                        AND bgo032 = g_bgo032
                        AND bgo033 = g_bgo033
                        AND bgo06  = g_bgo06
                        AND bgo07  = g_bgo[l_ac].bgo07
               IF g_cnt > 0 THEN
                  CALL cl_err(g_bgo[l_ac].bgo07,-239,0)
                  NEXT FIELD bgo07
               ELSE
                  IF g_bgo[l_ac].bgo07 <1 OR g_bgo[l_ac].bgo07 > 12 THEN
                      NEXT FIELD bgo07              #判斷是否在1~12月當中
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD bgo08
         IF NOT cl_null(g_bgo[l_ac].bgo08) THEN
            IF g_bgo[l_ac].bgo08 < 0 THEN
               NEXT FIELD bgo08
            ELSE
               LET g_bgo[l_ac].bgo10 = g_bgo[l_ac].bgo08 * g_bgo[l_ac].bgo09
            END IF
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_bgo[l_ac].bgo10
            #------MOD-5A0095 END------------
         END IF
 
      AFTER FIELD bgo09
         IF NOT cl_null(g_bgo[l_ac].bgo09) THEN
            IF g_bgo[l_ac].bgo09 < 0 THEN
               NEXT FIELD bgo09
            ELSE
               LET g_bgo[l_ac].bgo10 = g_bgo[l_ac].bgo08 * g_bgo[l_ac].bgo09
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_bgo[l_ac].bgo10
            #------MOD-5A0095 END------------
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_bgo_t.bgo07 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM bgo_file
                   WHERE bgo01  = g_bgo01
                     AND bgo02  = g_bgo02
                     AND bgo03  = g_bgo03
                     AND bgo032 = g_bgo032
                     AND bgo033 = g_bgo033
                     AND bgo06  = g_bgo06
                     AND bgo07  = g_bgo_t.bgo07
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgo_t.bgo07,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("del","bgo_file",g_bgo01,g_bgo_t.bgo07,SQLCA.sqlcode,"","",1) #FUN-660105
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bgo[l_ac].* = g_bgo_t.*
               CLOSE i140_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bgo[l_ac].bgo07,-263,1)
               LET g_bgo[l_ac].* = g_bgo_t.*
            ELSE
               UPDATE bgo_file SET bgo07=g_bgo[l_ac].bgo07,
                                   bgo08=g_bgo[l_ac].bgo08,
                                   bgo09=g_bgo[l_ac].bgo09,
                                   bgo10=g_bgo[l_ac].bgo10
                      WHERE CURRENT OF i140_b_cl  #要查一下
 
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_bgo[l_ac].bgo07,SQLCA.sqlcode,0) #FUN-660105
                  CALL cl_err3("upd","bgo_file",g_bgo01_t,g_bgo[l_ac].bgo07,SQLCA.sqlcode,"","",1) #FUN-660105
                  LET g_bgo[l_ac].* = g_bgo_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
      AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bgo[l_ac].* = g_bgo_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgo.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i140_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac        #FUN-D30032 add
            CLOSE i140_b_cl
            COMMIT WORK
 
      ON ACTION CONTROLN
        CALL i140_b_askkey()
        EXIT INPUT
 
      ON ACTION CONTROLO
         IF INFIELD(bgo07) AND l_ac > 1 THEN
            LET g_bgo[l_ac].* = g_bgo[l_ac-1].*
            LET g_bgo[l_ac].bgo07=l_ac
            NEXT FIELD bgo07
         END IF
 
      ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
      END INPUT
 
   CLOSE i140_b_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i140_b_askkey()
   DEFINE
      l_wc            LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(200)
 
   CONSTRUCT l_wc ON bgo07,bgo08,bgo09,bgo10          #螢幕上取條件
             FROM s_bgo[1].bgo07,s_bgo[1].bgo08,s_bgo[1].bgo09,s_bgo[1].bgo10
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
   CALL i140_b_fill(l_wc)
END FUNCTION
 
FUNCTION i140_b_fill(p_wc)                     #BODY FILL UP
   DEFINE
      p_wc            LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(200)
 
   LET g_sql =
       "SELECT bgo07,bgo08,bgo09,bgo10 ",
       "  FROM bgo_file ",
       " WHERE bgo01  = '",g_bgo01,"'",
       "   AND bgo02  = '",g_bgo02,"'",
       "   AND bgo03  = '",g_bgo03,"'",
       "   AND bgo032 = '",g_bgo032,"'",
       "   AND bgo033 = '",g_bgo033,"'",
       "   AND bgo06  = '",g_bgo06,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY bgo07"
   PREPARE i140_prepare2 FROM g_sql       #預備一下
   DECLARE bgo_cs CURSOR FOR i140_prepare2
 
   CALL g_bgo.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH bgo_cs INTO g_bgo[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1 #No.8563
   END FOREACH
   CALL g_bgo.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   IF g_rec_b > g_max_rec THEN
      LET g_msg = g_bgo01 CLIPPED
      CALL cl_err(g_msg,9036,0)
   END IF
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i140_bp(p_ud)
   DEFINE
      p_ud            LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bgo TO s_bgo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i140_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i140_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i140_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i140_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i140_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0003  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY     
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-820002--start-- 
FUNCTION i140_out()
DEFINE l_cmd  LIKE type_file.chr1000
#   DEFINE
#      l_i    LIKE type_file.num5,    #No.FUN-680061 SMALLINT
#      l_name LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
#      l_za05 LIKE type_file.chr1000, #NO.FUN-680061 VARCHAR(40)  
#      sr RECORD
#         bgo01      LIKE bgo_file.bgo01,
#         bgo02      LIKE bgo_file.bgo02,
#         bgo03      LIKE bgo_file.bgo03,
#         bgo032     LIKE bgo_file.bgo032,
#         bgo033     LIKE bgo_file.bgo033,
#         bgo06      LIKE bgo_file.bgo06,
#         bgo07      LIKE bgo_file.bgo07,
#         bgo08      LIKE bgo_file.bgo08,
#         bgo09      LIKE bgo_file.bgo09,
#         bgo10      LIKE bgo_file.bgo10
#      END RECORD
    IF cl_null(g_wc) AND NOT cl_null(g_bgo01)                                                                                       
       AND NOT cl_null(g_bgo02) AND NOT cl_null(g_bgo03)                                                                            
       AND NOT cl_null(g_bgo06) AND NOT cl_null(g_bgo07) THEN                                                                       
       LET g_wc = " bgo01 = '",g_bgo01,"' AND bgo02 = '",g_bgo02,                                                                   
                  "' AND bgo03 = '",g_bgo03,"' AND bgo06 = '",g_bgo06,"'"                                                           
    END IF                                                                                                                          
    IF g_wc IS NULL THEN CALL cl_err('','9057',0)  RETURN END IF                                                                    
    LET l_cmd = 'p_query "abgi140" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)
#   CALL cl_wait()
#   CALL cl_outnam('abgi140') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#LET g_sql="SELECT bgo01,bgo02,bgo03,bgo032,bgo033,bgo06,bgo07,bgo08,bgo09,bgo10 FROM bgo_file ",   # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED ,
#             " ORDER BY bgo01,bgo02,bgo03,bgo032,bgo033,bgo06 "
#   PREPARE i140_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i140_co CURSOR FOR i140_p1
 
#   START REPORT i140_rep TO l_name
 
#   FOREACH i140_co INTO sr.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
 
#      OUTPUT TO REPORT i140_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i140_rep
 
#   CLOSE i140_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i140_rep(sr)
#   DEFINE
#      l_trailer_sw    LIKE type_file.chr1,   #NO.FUN-680061 VARCHAR(1)
#      l_azi03         LIKE azi_file.azi03,   #NO.FUN-680061 SMALLINT
#      l_gem02         LIKE gem_file.gem02, 
#      sr RECORD
#         bgo01      LIKE bgo_file.bgo01,
#         bgo02      LIKE bgo_file.bgo02,
#         bgo03      LIKE bgo_file.bgo03,
#         bgo032     LIKE bgo_file.bgo032,
#         bgo033     LIKE bgo_file.bgo033,
#         bgo06      LIKE bgo_file.bgo06,
#         bgo07      LIKE bgo_file.bgo07,
#         bgo08      LIKE bgo_file.bgo08,
#         bgo09      LIKE bgo_file.bgo09,
#         bgo10      LIKE bgo_file.bgo10
#      END RECORD
 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.bgo01,sr.bgo03,sr.bgo02,sr.bgo033,sr.bgo06
 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED, pageno_total
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#               g_x[38],g_x[39],g_x[40]
#         PRINT g_dash1
#         LET l_trailer_sw = 'y'
 
#      BEFORE GROUP OF sr.bgo01
#         PRINT COLUMN g_c[31],sr.bgo01 CLIPPED;
 
#      BEFORE GROUP OF sr.bgo03
#         PRINT COLUMN g_c[32],sr.bgo03 CLIPPED;
 
#      BEFORE GROUP OF sr.bgo02
#         PRINT COLUMN g_c[33],sr.bgo02 CLIPPED;
 
#      BEFORE GROUP OF sr.bgo033
#         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.bgo033
#         PRINT COLUMN g_c[34],sr.bgo033 CLIPPED,
#               COLUMN g_c[35],l_gem02;
 
#      BEFORE GROUP OF sr.bgo06
#        PRINT COLUMN g_c[36],sr.bgo06;
 
#      ON EVERY ROW
 
#         PRINT COLUMN g_c[37],sr.bgo07 ,
#               COLUMN g_c[38],cl_numfor(sr.bgo08,38,g_azi03) ,
#               COLUMN g_c[39],cl_numfor(sr.bgo09,39,0) ,
#               COLUMN g_c[40],cl_numfor(sr.bgo10,40,g_azi04)
 
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#            PRINT g_dash[1,g_len]
#         END IF
#         PRINT g_dash[1,g_len]
#         LET l_trailer_sw = 'n'
#         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#      PAGE TRAILER
#         IF l_trailer_sw = 'y' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
#END REPORT
#No.FUN-820002--end--
 
#No.FUN-570108--begin
FUNCTION i140_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("bgo01,bgo02,bgo03,bgo06",TRUE)
   END IF
END FUNCTION
 
FUNCTION i140_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("bgo01,bgo02,bgo03,bgo06",FALSE)
   END IF
END FUNCTION
#No.FUN-570108--end
 
#Patch....NO.MOD-5A0095 <001,002> #
