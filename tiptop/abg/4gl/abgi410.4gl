# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi410.4gl
# Descriptions...: 分攤基礎設定作業
# Date & Author..: 02/10/11 By qazzaq
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin放寬aag02
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key 可更改
# Modify.........: NO.MOD-590329 05/10/03 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/18 By jamie 1.FUNCTION i410()_q 一開始應清空g_bhc01 g_bhc02的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 g_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/19 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/17 By johnray 會計科目加帳套,FETCH下一筆資料單身仍顯示上一筆值
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-860016 08/06/16 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie 過單
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.MOD-930200 09/03/19 By Sarah 單頭分攤類別名稱aca02未顯示
# Modify.........: No.TQC-970284 09/07/27 By Carrier 非負控制
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No:FUN-B40004 11/04/11 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bhc01         LIKE bhc_file.bhc01,   #部門
    g_bhc01_t       LIKE bhc_file.bhc01,   #部門(舊值)
    g_bhc02         LIKE bhc_file.bhc02,   #分攤類別編號
    g_bhc02_t       LIKE bhc_file.bhc02,   #分攤類別編號(舊值)
    g_bhc           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        bhc03       LIKE bhc_file.bhc03,   #項次
        bhc04       LIKE bhc_file.bhc04,   #科目編號
        aag02       LIKE aag_file.aag02,
        bhc05       LIKE bhc_file.bhc05,   #部門編號
        gem02_b     LIKE gem_file.gem02,
        bhc07       LIKE bhc_file.bhc07    #分攤基礎
                    END RECORD,
    g_bhc_t         RECORD                 #程式變數(舊值)
        bhc03       LIKE bhc_file.bhc03,   #項次
        bhc04       LIKE bhc_file.bhc04,   #科目編號
        aag02       LIKE aag_file.aag02,
        bhc05       LIKE bhc_file.bhc05,   #部門編號
        gem02_b     LIKE gem_file.gem02,
        bhc07       LIKE bhc_file.bhc07    #分攤基礎
                    END RECORD,
    g_wc,g_sql,g_wc2    STRING,            #TQC-630166
    g_ss            LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
    g_show          LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
    g_rec_b         LIKE type_file.num5,   #單身筆數 #No.FUN-680061 SMALLINT
    g_flag          LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
    g_ver           LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)   #版本參數
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE g_forupd_sql    STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp       STRING                      #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE   g_cnt          LIKE type_file.num10       #No.FUN-680061 INTEGER
DEFINE   g_i            LIKE type_file.num5        #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03          #No.FUN-680061 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10       #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10       #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10       #查詢指定的筆數     #No.FUN-680061 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5        #是否開啟指定筆視窗 #No.FUN-680061 SMALLINT   #No.FUN-6A0057 g_no_ask 
DEFINE   l_table      STRING     #FUN-860016 add
DEFINE   g_str        STRING     #FUN-860016 add
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABG")) THEN
       EXIT PROGRAM
    END IF
 
#---FUN-860016 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "l_gem02.gem_file.gem02,",
              "l_aca02.aca_file.aca02,",
              "bhc01.bhc_file.bhc01,",
              "bhc02.bhc_file.bhc02,",
              "bhc03.bhc_file.bhc03,",
              "bhc04.bhc_file.bhc04,",
              "aag02.aag_file.aag02,",
              "bhc05.bhc_file.bhc05,",
              "gem02_b.gem_file.gem02,",
              "bhc07.bhc_file.bhc07 "
                                          #10 items
  LET l_table = cl_prt_temptable('abgi410',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-860016 add ---end
    CALL cl_used(g_prog,g_time,1) RETURNING g_time                            #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
 
    OPEN WINDOW i410_w WITH FORM "abg/42f/abgi410"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                         #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL i410_menu()
 
    CLOSE WINDOW i410_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0056
 
END MAIN
 
#QBE 查詢資料
FUNCTION i410_cs()
    CLEAR FORM                         #清除畫面
    CALL g_bhc.clear()
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_bhc01 TO NULL    #No.FUN-750051
   INITIALIZE g_bhc02 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bhc01,bhc02,bhc03,bhc04,bhc05,bhc07
    FROM bhc01,bhc02,s_bhc[1].bhc03,s_bhc[1].bhc04,s_bhc[1].bhc05,
         s_bhc[1].bhc07
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(bhc01) #產品名稱
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gem"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bhc01
                       NEXT FIELD bhc01
                  WHEN INFIELD(bhc02) #產品名稱
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_aca"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bhc02
                       NEXT FIELD bhc02
                  WHEN INFIELD(bhc05) #產品名稱
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gem"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bhc05
                       NEXT FIELD bhc05
                  WHEN INFIELD(bhc04) #產品名稱
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_aag"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bhc04
                       NEXT FIELD bhc04
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
 
    LET g_sql= "SELECT UNIQUE bhc01,bhc02 FROM bhc_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bhc01"
    PREPARE i410_prepare FROM g_sql      #預備一下
    DECLARE i410_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i410_prepare
 
#   LET g_sql = "SELECT UNIQUE bhc01,bhc02 FROM bhc_file ",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE bhc01,bhc02 FROM bhc_file ",  #No.TQC-720019
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i410_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i410_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i410_precount_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i410_precnt FROM g_sql
    DECLARE i410_count CURSOR FOR i410_precnt
 
 
END FUNCTION
 
FUNCTION i410_menu()
   WHILE TRUE
      CALL i410_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i410_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i410_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i410_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i410_copy()
            END IF                                                                       WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i410_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i410_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bhc),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bhc01 IS NOT NULL THEN
                LET g_doc.column1 = "bhc01"
                LET g_doc.column2 = "bhc02"
                LET g_doc.value1 = g_bhc01
                LET g_doc.value2 = g_bhc02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i410_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    LET g_bhc01    = NULL
    LET g_bhc02    = NULL
    LET g_bhc01_t  = NULL
    LET g_bhc02_t  = NULL
    CALL g_bhc.clear()
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i410_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_bhc01=NULL
            LET g_bhc02=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b = 0                    #No.FUN-680064
        IF g_ss='N' THEN
            FOR g_cnt = 1 TO g_bhc.getLength()
                INITIALIZE g_bhc[g_cnt].* TO NULL
            END FOR
        ELSE
            CALL i410_b_fill(' 1=1')          #單身
        END IF
 
        CALL i410_b()                      #輸入單身
        LET g_bhc01_t = g_bhc01
        LET g_bhc02_t = g_bhc02
        LET g_wc=" bhc01='",g_bhc01,"' AND bhc01='",g_bhc01,"' "
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i410_i(p_cmd)
DEFINE
    p_cmd      LIKE type_file.chr1,   #a:輸入 u:更改  #No.FUN-680061 VARCHAR(01)
    l_n        LIKE type_file.num5    #No.FUN-680061 SMALLINT
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_bhc01,g_bhc02 WITHOUT DEFAULTS
         FROM bhc01,bhc02
 
    BEFORE INPUT
 #No.MOD-580078 --start
            LET g_before_input_done = FALSE
            CALL i410_set_entry(p_cmd)
            CALL i410_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
 
        AFTER FIELD bhc01                    #部門
            IF NOT cl_null(g_bhc01) THEN
               CALL i410_bhc01('a',g_bhc01)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bhc01,g_errno,0)
                  LET g_bhc01 = g_bhc01_t
                  DISPLAY BY NAME g_bhc01
                  NEXT FIELD bhc01
               END IF
               IF g_bhc01='ALL' THEN
                  SELECT COUNT(*) INTO g_cnt       #檢查是否有all 也許g_cnt會錯
                  FROM bhc_file
                 WHERE bhc01 != 'ALL'
                  IF g_cnt > 0 THEN
                     CALL cl_err(g_bhc02,'abg-016',0)
                     LET g_bhc01=NULL
                     DISPLAY g_bhc01 TO bhc01
                     NEXT FIELD bhc01
                  END IF
               END IF
             END IF
 
        AFTER FIELD bhc02                    #分攤類別
            IF NOT cl_null(g_bhc02) THEN
               SELECT COUNT(*) INTO l_n FROM bhc_file
               WHERE bhc01=g_bhc01
                 AND bhc02=g_bhc02
               IF l_n > 0 THEN
                  CALL cl_err(g_bhc02,-239,0)
                  NEXT FIELD bhc02
               END IF
               SELECT COUNT(*) INTO g_cnt       #檢查是否有all 也許g_cnt會錯
                 FROM bhc_file
                WHERE bhc01='ALL'
               IF g_cnt > 0 THEN
                  CALL cl_err(g_bhc02,'abg-014',0)
                  LET g_bhc01=NULL
                  LET g_bhc02=NULL
                  DISPLAY g_bhc01,g_bhc02 TO bhc01,bhc02
                  NEXT FIELD bhc01
               END IF
               CALL i410_bhc02('a',g_bhc02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bhc02,g_errno,0)
                  LET g_bhc02 = g_bhc02_t
                  DISPLAY BY NAME g_bhc02
                  NEXT FIELD bhc02
               END IF
            END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bhc01) #客戶編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem"
                   LET g_qryparam.default1 = g_bhc01
                   CALL cl_create_qry() RETURNING g_bhc01
                   NEXT FIELD bhc01
              WHEN INFIELD(bhc02) #客戶編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aca"
                   LET g_qryparam.default1 = g_bhc02
                   CALL cl_create_qry() RETURNING g_bhc02
                   NEXT FIELD bhc02                                                        END CASE
 
        ON ACTION CONTROLF                #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
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
 
FUNCTION i410_bhc01(p_cmd,p_key)  #部門
    DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(01)
           p_key     LIKE gem_file.gem01,
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT  gem02,gemacti
      INTO  l_gem02,l_gemacti
      FROM  gem_file
     WHERE  gem01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-011'
                                  LET l_gem02 = NULL LET l_gemacti = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_key = 'ALL' THEN
       LET g_errno = ' ' LET l_gem02 = 'ALL'
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
FUNCTION i410_bhc02(p_cmd,p_key)  #分攤類別
    DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(01)
           p_key     LIKE aca_file.aca01,
           l_aca02   LIKE aca_file.aca02,
           l_acaacti LIKE aca_file.acaacti
 
    LET g_errno = ' '
    SELECT  aca02,acaacti
      INTO  l_aca02,l_acaacti
      FROM  aca_file
     WHERE  aca01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                            LET l_aca02 = NULL LET l_acaacti = NULL
         WHEN l_acaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_aca02 TO aca02   #MOD-930200 add
END FUNCTION
 
 
#Query 查詢
FUNCTION i410_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bhc01 TO NULL         #No.FUN-6A0003
    INITIALIZE g_bhc02 TO NULL         #No.FUN-6A0003
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bhc.clear()
 
    CALL i410_cs()                      #取得查詢條件
    IF INT_FLAG THEN                    #使用者不玩了
       LET INT_FLAG = 0
       INITIALIZE g_bhc01 TO NULL
       INITIALIZE g_bhc02 TO NULL
       RETURN
    END IF
    OPEN i410_bcs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN               #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_bhc01 TO NULL
       INITIALIZE g_bhc02 TO NULL
    ELSE
          OPEN i410_count
          FETCH i410_count INTO g_row_count
          DISPLAY g_row_count TO FORMONLY.cnt
          CALL i410_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i410_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1     #處理方式  #No.FUN-680061 VARCHAR(01)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i410_bcs INTO g_bhc01,g_bhc02
        WHEN 'P' FETCH PREVIOUS i410_bcs INTO g_bhc01,g_bhc02
        WHEN 'F' FETCH FIRST    i410_bcs INTO g_bhc01,g_bhc02
        WHEN 'L' FETCH LAST     i410_bcs INTO g_bhc01,g_bhc02
        WHEN '/'
        IF (NOT g_no_ask) THEN      #No.FUN-6A0057 g_no_ask 
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
        FETCH ABSOLUTE g_jump i410_bcs INTO g_bhc01,g_bhc02
        LET g_no_ask = FALSE     #No.FUN-6A0057 g_no_ask 
    END CASE
    IF SQLCA.sqlcode THEN                  #有麻煩
        CALL cl_err(g_bhc01,SQLCA.sqlcode,0)
        INITIALIZE g_bhc01 TO NULL  #TQC-6B0105
        INITIALIZE g_bhc02 TO NULL  #TQC-6B0105
        RETURN	
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    END IF
        CALL i410_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i410_show()
    DISPLAY g_bhc01,g_bhc02 TO bhc01,bhc02  #單頭
    CALL i410_bhc01('d',g_bhc01)
    CALL i410_bhc02('d',g_bhc02)
    CALL i410_b_fill(g_wc)                      #單身
    CALL i410_bp("D")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i410_r()
 
  IF s_shut(0) THEN RETURN END IF
  IF cl_null(g_bhc01) THEN
     CALL cl_err('',-400,0) RETURN
  END IF
  DISPLAY g_bhc01 TO bhc01
  BEGIN WORK
  IF cl_delh(15,16) THEN
      INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "bhc01"      #No.FUN-9B0098 10/02/24
      LET g_doc.column2 = "bhc02"      #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_bhc01       #No.FUN-9B0098 10/02/24
      LET g_doc.value2 = g_bhc02       #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                                       #No.FUN-9B0098 10/02/24
     DELETE FROM bhc_file
      WHERE bhc01=g_bhc01
        AND bhc02=g_bhc02
     IF SQLCA.sqlcode THEN
#       CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #FUN-660105
        CALL cl_err3("del","bhc_file",g_bhc01,g_bhc02,SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105
     ELSE
      CLEAR FORM
      #MOD-5A0004 add
      DROP TABLE x
#     EXECUTE i410_precount_x                  #No.TQC-720019
      PREPARE i410_precount_x2 FROM g_sql_tmp  #No.TQC-720019
      EXECUTE i410_precount_x2                 #No.TQC-720019
      #MOD-5A0004 end
      CALL g_bhc.clear()
      OPEN i410_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i410_bcs
         CLOSE i410_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i410_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i410_bcs
         CLOSE i410_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i410_bcs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i410_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE       #No.FUN-6A0057 g_no_ask 
         CALL i410_fetch('/')
      END IF
     END IF
     LET g_msg=TIME
    #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
           #VALUES ('abgi410',g_user,g_today,g_msg,g_bhc01,'delete') #FUN-980001 mark
     INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
            VALUES ('abgi410',g_user,g_today,g_msg,g_bhc01,'delete',g_plant,g_legal) #FUN-980001 add
  END IF
  COMMIT WORK
END FUNCTION
 
 
#單身
FUNCTION i410_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680061 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否          #NO.FUN-680061 VARCHAR(1)
    l_allow_delete  LIKE type_file.num5     #可更改否 (含取消) #NO.FUN-680061 VARCHAR(1)
#    l_a             DEC(15,3),
#    l_b             DEC(15,3)
DEFINE l_aag05         LIKE aag_file.aag05     #No.FUN-B40004
 
    LET g_action_choice = ""
 
    IF cl_null(g_bhc01) THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
        "SELECT bhc03,bhc04,' ',bhc05,' ',bhc07 FROM bhc_file ",
        " WHERE bhc01 = ? AND bhc02 = ? AND bhc03 = ? AND bhc04 = ? ",
        "  AND bhc05 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i410_b_cl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bhc WITHOUT DEFAULTS FROM s_bhc.*
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
 
            IF g_rec_b >= l_ac THEN
 
            BEGIN WORK
            LET p_cmd = 'u'
            LET g_bhc_t.* = g_bhc[l_ac].*  #BACKUP
#NO.MOD-590329 MARK----------
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i410_set_entry_b(p_cmd)
#            CALL i410_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329 MARK----------
               OPEN i410_b_cl USING g_bhc01,g_bhc02,
                                    g_bhc_t.bhc03,
                                    g_bhc_t.bhc04,
                                    g_bhc_t.bhc05
 
               IF STATUS THEN
                  CALL cl_err("OPEN i410_b_cl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bhc01_t,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                  ELSE
                    LET g_bhc_t.*=g_bhc[l_ac].*
                  END IF
                  FETCH i410_b_cl INTO g_bhc[l_ac].*
               END IF
 
               CALL i410_bhc04('d')
              CALL i410_bhc05('d')
              CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bhc[l_ac].* TO NULL            #900423
            LET g_bhc_t.* = g_bhc[l_ac].*               #新輸入資料
#NO.MOD-590329 MARK
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i410_set_entry_b(p_cmd)
#            CALL i410_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329 MARK
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bhc03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO bhc_file(bhc01,bhc02,bhc03,bhc04,bhc05,bhc07)
                          VALUES(g_bhc01,g_bhc02,g_bhc[l_ac].bhc03,
                                 g_bhc[l_ac].bhc04,
                                 g_bhc[l_ac].bhc05,g_bhc[l_ac].bhc07)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bhc[l_ac].bhc03,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("ins","bhc_file",g_bhc01,g_bhc02,SQLCA.sqlcode,"","",1) #FUN-660105
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
            END IF
 
 
 
        BEFORE FIELD bhc03                    #check部門/分攤類別/序號是否重複
            IF cl_null(g_bhc[l_ac].bhc03) OR g_bhc[l_ac].bhc03=0 THEN
               SELECT MAX(bhc03)+1 INTO g_bhc[l_ac].bhc03
                 FROM bhc_file
                WHERE bhc01=g_bhc01
                  AND bhc02=g_bhc02
               IF cl_null(g_bhc[l_ac].bhc03) THEN
                  LET g_bhc[l_ac].bhc03=1
               END IF
            END IF
 
        AFTER FIELD bhc03
            IF g_bhc[l_ac].bhc03 != g_bhc_t.bhc03 OR
                  g_bhc_t.bhc03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM bhc_file
                WHERE bhc01=g_bhc01
                  AND bhc02=g_bhc02
                  AND bhc03=g_bhc[l_ac].bhc03
               IF l_n > 0 THEN
                  CALL cl_err(g_bhc[l_ac].bhc03,-239,0)
                  NEXT FIELD bhc03
               END IF
            END IF
 
        AFTER FIELD bhc04
            CALL i410_bhc04('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_bhc[l_ac].bhc04,g_errno,0)
               #FUN-B10049--begin
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_bhc[l_ac].bhc04  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_bhc[l_ac].bhc04 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_bhc[l_ac].bhc04
               DISPLAY BY NAME g_bhc[l_ac].bhc04                 
               #LET g_bhc[l_ac].bhc04 = g_bhc_t.bhc04
               #FUN-B10049--end   
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_bhc[l_ac].bhc04
               #------MOD-5A0095 END------------
               NEXT FIELD bhc04
            END IF
 
        AFTER FIELD bhc05
            CALL i410_bhc05('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_bhc[l_ac].bhc05,g_errno,0)
               LET g_bhc[l_ac].bhc05 = g_bhc_t.bhc05
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_bhc[l_ac].bhc05
               #------MOD-5A0095 END------------
               NEXT FIELD bhc05
            END IF
            IF g_bhc[l_ac].bhc05 != g_bhc_t.bhc05 OR
               g_bhc_t.bhc05 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM bhc_file
                WHERE bhc01=g_bhc01
                  AND bhc02=g_bhc02
                  AND bhc03=g_bhc[l_ac].bhc03
                  AND bhc04=g_bhc[l_ac].bhc04
                  AND bhc05=g_bhc[l_ac].bhc05
               IF l_n > 0 THEN
                  CALL cl_err(g_bhc[l_ac].bhc05,-239,0)
                  NEXT FIELD bhc05
               END IF
            END IF
            #No.FUN-B40004  --Begin
            LET l_aag05=''
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01 = g_bhc[l_ac].bhc04
               AND aag00 = g_aza.aza81
            IF l_aag05 = 'Y' THEN
               #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
               IF g_aaz.aaz90 !='Y' THEN
                  LET g_errno = ' '
                  CALL s_chkdept(g_aaz.aaz72,g_bhc[l_ac].bhc04,g_bhc[l_ac].bhc05,g_aza.aza81)
                       RETURNING g_errno
               END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_bhc[l_ac].bhc05,g_errno,0)
               LET g_bhc[l_ac].bhc05 = g_bhc_t.bhc05
               DISPLAY BY NAME g_bhc[l_ac].bhc05
               NEXT FIELD bhc05
            END IF
            #No.FUN-B40004  --End
 
        #No.TQC-970284  --Begin
        AFTER FIELD bhc07
            IF NOT cl_null(g_bhc[l_ac].bhc07) THEN
               IF g_bhc[l_ac].bhc07 < 0 THEN
                  CALL cl_err(g_bhc[l_ac].bhc07,'aim-223',0)
                  NEXT FIELD bhc07
               END IF
            END IF
        #No.TQC-970284  --End  
 
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bhc_t.bhc03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM bhc_file
                    WHERE bhc01 = g_bhc01
                      AND bhc02 = g_bhc02
                      AND bhc03 = g_bhc_t.bhc03
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_bhc_t.bhc03,SQLCA.sqlcode,0) #FUN-660105
                   CALL cl_err3("del","bhc_file",g_bhc01,g_bhc_t.bhc03,SQLCA.sqlcode,"","",1) #FUN-660105
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
            LET g_rec_b=g_rec_b-1
            COMMIT WORK
            END IF
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bhc[l_ac].* = g_bhc_t.*
               CLOSE i410_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bhc[l_ac].bhc03,-263,1)
               LET g_bhc[l_ac].* = g_bhc_t.*
            ELSE
               UPDATE bhc_file SET bhc03 = g_bhc[l_ac].bhc03,
                                   bhc04 = g_bhc[l_ac].bhc04,
                                   bhc05 = g_bhc[l_ac].bhc05,
                                   bhc07 = g_bhc[l_ac].bhc07
                             WHERE bhc01 = g_bhc01
                               AND bhc02 = g_bhc02
                               AND bhc03 = g_bhc_t.bhc03                                                       AND bhc04 = g_bhc_t.bhc04                                                       AND bhc05 = g_bhc_t.bhc05
 
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_bhc[l_ac].bhc03,SQLCA.sqlcode,0) #FUN-660105
                  CALL cl_err3("upd","bhc_file",g_bhc01,g_bhc_t.bhc03,SQLCA.sqlcode,"","",1) #FUN-660105
                  LET g_bhc[l_ac].* = g_bhc_t.*
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
                  LET g_bhc[l_ac].* = g_bhc_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bhc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i410_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE i410_b_cl
            COMMIT WORK
 
 
        ON ACTION CONTROLN
            CALL i410_b_askkey()
            EXIT INPUT
 
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bhc04) #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = g_bhc[l_ac].bhc04
                   LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                   CALL cl_create_qry() RETURNING g_bhc[l_ac].bhc04
                   DISPLAY BY NAME g_bhc[l_ac].bhc04  #No.FUN-730033
#                   CALL FGL_DIALOG_SETBUFFER( g_bhc[l_ac].bhc04 )
                   NEXT FIELD bhc04
              WHEN INFIELD(bhc05) #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem"
                   LET g_qryparam.default1 = g_bhc[l_ac].bhc05
                   CALL cl_create_qry() RETURNING g_bhc[l_ac].bhc05
#                   CALL FGL_DIALOG_SETBUFFER( g_bhc[l_ac].bhc05 )
                   NEXT FIELD bhc05
           END CASE
 
 
        ON ACTION CONTROLO                    #沿用所有欄位
            IF INFIELD(bhc03) AND l_ac > 1 THEN
                LET g_bhc[l_ac].* = g_bhc[l_ac-1].*
                LET g_bhc[l_ac].bhc03=l_ac
                NEXT FIELD bhc03
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
END FUNCTION
 
FUNCTION i410_bhc04(p_cmd)  #會計科目
    DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(01)
           l_aagacti LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT  aag02,aagacti
      INTO  g_bhc[l_ac].aag02,l_aagacti
      FROM  aag_file
     WHERE  aag01 = g_bhc[l_ac].bhc04
       AND  aag00 = g_aza.aza81  #No.FUN-730033
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-010'
                            LET g_bhc[l_ac].aag02 = NULL LET l_aagacti = NULL
         WHEN l_aagacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #------MOD-5A0095 START----------
    DISPLAY BY NAME g_bhc[l_ac].aag02
    #------MOD-5A0095 END------------
END FUNCTION
FUNCTION i410_bhc05(p_cmd)  #部門
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT  gem02,gemacti
      INTO  g_bhc[l_ac].gem02_b,l_gemacti
      FROM  gem_file
     WHERE  gem01 = g_bhc[l_ac].bhc05
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-011'
                            LET g_bhc[l_ac].gem02_b = NULL
                            LET l_gemacti = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #------MOD-5A0095 START----------
    DISPLAY BY NAME g_bhc[l_ac].gem02_b
    #------MOD-5A0095 END------------
END FUNCTION
 
 
FUNCTION i410_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680061  VARCHAR(200)
 
    CONSTRUCT l_wc ON bhc03,bhc04,bhc05,bhc07 #螢幕上取條件
       FROM s_bhc[1].bhc03,s_bhc[1].bhc04,s_bhc[1].bhc05,s_bhc[1].bhc07
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
    CALL i410_b_fill(l_wc)
END FUNCTION
 
FUNCTION i410_b_fill(p_wc)                     #BODY FILL UP
DEFINE
    p_wc    LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(200)
 
    LET g_sql =
       "SELECT bhc03,bhc04,'',bhc05,'',bhc07 ",
       "  FROM bhc_file ",
       " WHERE bhc01 = '",g_bhc01,"'",
       "   AND bhc02 = '",g_bhc02,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY bhc03"
    PREPARE i410_prepare2 FROM g_sql       #預備一下
    DECLARE bhc_cs CURSOR FOR i410_prepare2
 
    CALL g_bhc.clear()
    LET g_cnt = 1
 
#    LET g_rec_b = 0
    FOREACH bhc_cs INTO g_bhc[g_cnt].*     #單身 ARRAY 填充a
        SELECT aag02 INTO g_bhc[g_cnt].aag02
          FROM aag_file
         WHERE aag01=g_bhc[g_cnt].bhc04
           AND aag00 = g_aza.aza81  #No.FUN-730033
        SELECT gem02 INTO g_bhc[g_cnt].gem02_b
          FROM gem_file
         WHERE gem01=g_bhc[g_cnt].bhc05
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_bhc.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
FUNCTION i410_bp(p_ud)
DEFINE
    p_ud      LIKE type_file.chr1       #No.FUN-680061 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_bhc TO s_bhc.* ATTRIBUTE(COUNT=g_rec_b)     #No.TQC-740093
   DISPLAY ARRAY g_bhc TO s_bhc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.TQC-740093
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION first
         CALL i410_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i410_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i410_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i410_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i410_fetch('L')
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
 
 
 
 
FUNCTION i410_copy()
DEFINE
    new_dep     LIKE bhc_file.bhc01,
    new_class   LIKE bhc_file.bhc02,
    l_gem02     LIKE gem_file.gem02,
    l_gemacti   LIKE gem_file.gemacti,
    l_aca02     LIKE aca_file.aca02,
    l_acaacti   LIKE aca_file.acaacti,
    l_i         LIKE type_file.num10,   #NO.FUN-680061 INTEGER
    l_n         LIKE type_file.num5,    #No.FUN-680061 SMALLINT
    l_bhc       RECORD  LIKE bhc_file.*
 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_bhc01) OR cl_null(g_bhc02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#  DISPLAY "" AT 1,1
#  CALL cl_getmsg('copy',g_lang) RETURNING g_msg
#  DISPLAY g_msg AT 2,1 ATTRIBUTE(RED)
 
  CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
  WHILE TRUE
   INPUT new_dep,new_class FROM bhc01,bhc02
       AFTER FIELD bhc01
           IF NOT cl_null(new_dep) THEN
              CALL i410_bhc01('a',new_dep)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(new_dep,g_errno,0)
                 LET new_dep = g_bhc01     #g_bha_o.bha01
                 DISPLAY BY NAME new_dep
                 NEXT FIELD bhc01
              END IF
              IF g_bhc01='ALL' THEN
                 SELECT COUNT(*) INTO g_cnt       #檢查是否有all 也許g_cnt會錯
                 FROM bhc_file
                 WHERE bhc01!='ALL'
                 IF g_cnt > 0 THEN
                    CALL cl_err(new_dep,'abg-016',0)
                    LET new_dep = NULL
                    DISPLAY new_dep TO bhc01
                    NEXT FIELD bhc01
                 END IF
              END IF
           END IF
 
       AFTER FIELD bhc02
           IF NOT cl_null(new_class) THEN
              SELECT COUNT(*) INTO l_n FROM bhc_file
              WHERE bhc01=new_dep
              AND bhc02=new_class
              IF l_n > 0 THEN
                 CALL cl_err(g_bhc02,-239,0)
                 NEXT FIELD bhc02
              END IF
              SELECT COUNT(*) INTO g_cnt
              FROM bhc_file WHERE bhc01='ALL'
              IF g_cnt > 0 THEN
                 CALL cl_err(g_bhc02,'abg-014',0)
                 LET new_dep   = NULL
                 LET new_class = NULL
                 DISPLAY new_dep,new_class TO bhc01,bhc02
                 NEXT FIELD bhc01
              END IF
              CALL i410_bhc02('a',new_class)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(new_dep,g_errno,0)
                 LET new_dep = g_bhc02
                 DISPLAY BY NAME new_class
                 NEXT FIELD bhc02
              END IF
         END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bhc01) #客戶編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem"
                   LET g_qryparam.default1 = new_dep
                   CALL cl_create_qry() RETURNING new_dep
                   DISPLAY new_dep TO bhc01 #ATTRIBUTE(YELLOW)  #TQC-8C0076
                   NEXT FIELD bhc01
              WHEN INFIELD(bhc02) #客戶編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aca"
                   LET g_qryparam.default1 = new_class
                   CALL cl_create_qry() RETURNING new_class
                   DISPLAY new_class TO bhc02 #ATTRIBUTE(YELLOW)   #TQC-8C0076
                   NEXT FIELD bhc02
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
      DISPLAY g_bhc01 TO bhc01
      DISPLAY g_bhc02 TO bhc02
      RETURN
   END IF
   IF cl_null(new_dep) OR cl_null(new_class) THEN
      CONTINUE WHILE
   END IF
   EXIT WHILE
 END WHILE
 
    BEGIN WORK
    LET g_success='Y'
    DECLARE i410_c CURSOR FOR
        SELECT *
          FROM bhc_file
         WHERE bhc01 = g_bhc01
           AND bhc02 = g_bhc02
    LET l_i = 0
    FOREACH i410_c INTO l_bhc.*
        LET l_i = l_i+1
        LET l_bhc.bhc01 = new_dep
        LET l_bhc.bhc02 = new_class
        INSERT INTO bhc_file VALUES(l_bhc.*)
        IF STATUS THEN
#           CALL cl_err('ins bhc:',STATUS,1) #FUN-660105
            CALL cl_err3("ins","bhc_file",l_bhc.bhc01,l_bhc.bhc02,STATUS,"","ins bhc",1) #FUN-660105
            LET g_success='N'
        END IF
    END FOREACH
    IF g_success='Y' THEN
        COMMIT WORK
        #FUN-C30027---begin
        LET g_bhc01 = new_dep
        LET g_bhc02 = new_class
        LET g_wc = '1=1'
        CALL i410_show()          
        #FUN-C30027---end   
        MESSAGE l_i, ' rows copied!'
    ELSE
        ROLLBACK WORK 
        LET g_wc = '1=1'  #FUN-C30027
        CALL i410_show()  #FUN-C30027        
        MESSAGE 'rollback work!'
    END IF
 
END FUNCTION
 
FUNCTION i410_out()
    DEFINE
        l_i    LIKE type_file.num5,    #No.FUN-680061 SMALLINT
        l_name LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
        l_za05 LIKE type_file.chr1000, #NO.FUN-680061 VARCHAR(40)  
        sr RECORD
             bhc01      LIKE bhc_file.bhc01,
             bhc02      LIKE bhc_file.bhc02,
             bhc03      LIKE bhc_file.bhc03,
             bhc04      LIKE bhc_file.bhc04,
             aag02      LIKE aag_file.aag02,
             bhc05      LIKE bhc_file.bhc05,
             gem02      LIKE gem_file.gem02,
             bhc07      LIKE bhc_file.bhc07
        END RECORD
#FUN-860016 add---START
DEFINE l_sql      STRING,
       l_gem02    LIKE gem_file.gem02,
       l_aca02    LIKE aca_file.aca02,
       gem02_b    LIKE gem_file.gem02
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-860016 add---END
 
    IF cl_null(g_wc) AND ( cl_null(g_bhc01) OR cl_null(g_bhc02) ) THEN
       RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 LET g_sql="SELECT bhc01,bhc02,bhc03,bhc04,aag02,bhc05,gem02,bhc07 ",
              "  FROM bhc_file,aag_file,gem_file ",   # 組合出 SQL 指令
              " WHERE bhc04=aag01 AND bhc05=gem01 ",
              "   AND aag00='",g_aza.aza81,"'",    #No.FUN-730033
              "   AND ",g_wc CLIPPED ,
              " ORDER BY bhc01,bhc02,bhc04 "
    PREPARE i410_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i410_co CURSOR FOR i410_p1
 
    FOREACH i410_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
      #---FUN-860016 add---START
        LET l_gem02 = NULL
        SELECT gem02 INTO l_gem02 FROM gem_file
         WHERE gem01 = sr.bhc01
            IF SQLCA.sqlcode THEN
               LET l_gem02=''
           END IF
        LET l_aca02 = NULL
        SELECT aca02 INTO l_aca02 FROM aca_file
         WHERE aca01 = sr.bhc02
            IF SQLCA.sqlcode THEN
               LET l_aca02=''
           END IF
        EXECUTE insert_prep USING  l_gem02,  l_aca02, sr.bhc01, sr.bhc02,
                                  sr.bhc03, sr.bhc04, sr.aag02, sr.bhc05,
                                  sr.gem02, sr.bhc07
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
      #---FUN-860016 add---END
    END FOREACH
 
  #FUN-860016  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY bhc01,bhc02,bhc04,bhc05"
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'bhc01,bhc02,bhc03,bhc04,bhc05,bhc07')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
    LET g_str = g_str,";",g_azi04
    CALL cl_prt_cs3('abgi410','abgi410',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-860016  ----end---
 
    CLOSE i410_co
    ERROR ""
END FUNCTION
#NO.FUN-870144
 
#NO.MOD-580078
FUNCTION i410_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("bhc01,bhc02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i410_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("bhc01,bhc02",FALSE)
   END IF
 
END FUNCTION
 
#NO.MOD-590329 MARK------------------
#FUNCTION i410_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("bhc03,bhc04,bhc05",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION i410_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("bhc03,bhc04,bhc05",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580078 --end
#NO.MOD-590329 MARK
#Patch....NO.MOD-5A0095 <001,002,003,004> #
