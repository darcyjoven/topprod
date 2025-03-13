# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi001.4gl
# Descriptions...: 預估匯率維護作業
# Date & Author..: 02/08/29 By qazzaq
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4B0074 04/11/26 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0067 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-4C0072 04/12/13 By pengu  匯率幣別欄位修改，與aoos010的azi17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-510025 05/01/14 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550037 05/05/13 By saki    欄位comment顯示
# Modify.........: NO.MOD-580192 05/08/23 By Smapmin 修改權限控管
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu _r()後總筆數不正確
# Modify.........: No.TQC-630053 06/03/07 By Smapmin 複製功能視窗無法顯示中文
# Modify.........: No.TQC-630104 06/03/14 By Smapmin DISPLAY ARRAY 無控制單身筆數
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-5A0107 06/06/21 By rainy   上下筆移動時單身資料沒變
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0003 06/10/14 By jamie 1.FUNCTION i001()_q 一開始應清空g_bga.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/10 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770033 07/06/25 BY destiny 報表改為使用crystal report
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-970222 09/07/22 By sherry 單身“匯率”欄位對負數未進行控管。
# Modify.........: No.FUN-980001 09/08/05 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0062 09/11/11 By Sarah 新增時需寫入bgauser,bgagrup,bgadate,修改時需更新bgamodu,bgadate
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bga01         LIKE bga_file.bga01,   #版本
    g_bga01_t       LIKE bga_file.bga01,   #版本(舊值)
    g_bga04         LIKE bga_file.bga04,   #幣別
    g_bga04_t       LIKE bga_file.bga04,   #幣別(舊值)
    g_bga02         LIKE bga_file.bga02,   #年度
    g_bga02_t       LIKE bga_file.bga02,   #年度(舊值)
    g_bga           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
        bga03       LIKE bga_file.bga03,   #月份
        bga05       LIKE bga_file.bga05,   #匯率
        bgaacti     LIKE bga_file.bgaacti  #有效否
                    END RECORD,
    g_bga_t         RECORD                 #程式變數(舊值)
        bga03       LIKE bga_file.bga03,   #月份
        bga05       LIKE bga_file.bga05,   #匯率
        bgaacti     LIKE bga_file.bgaacti  #有效否
                    END RECORD,
    g_wc,g_sql,g_wc2    string,            #No.FUN-580092 HCN
    g_show          LIKE type_file.chr1,   #No.FUN-680061  VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數 #No.FUN-680061 SMALLINT
    g_flag          LIKE type_file.chr1,   #No.FUN-680061  VARCHAR(1)
    g_ver           LIKE aba_file.aba18,   #版本參數
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
    g_bgauser       LIKE bga_file.bgauser, #MOD-580192
    g_bgagrup       LIKE bga_file.bgagrup  #MOD-580192
 
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680061  SMALLINT
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING                 #No.TQC-720019
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680061  INTEGER
DEFINE g_i          LIKE type_file.num5    #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03      #No.FUN-680061  VARCHAR(72)
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10      #No.FUN-680061 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5       #No.FUN-680061 SMALLINT #No.FUN-6A0057 g_no_ask 
DEFINE   g_str          STRING                    #No.FUN-770033
#主程式開始
MAIN
#  DEFINE    l_time   LIKE type_file.chr8            #No.FUN-6A0056
 
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
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
 
   LET p_row = 3 LET p_col = 26
 
   OPEN WINDOW i001_w AT p_row,p_col
     WITH FORM "abg/42f/abgi001" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL i001_menu()    #中文
 
   CLOSE WINDOW i001_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
FUNCTION i001_cs()
 
   CLEAR FORM                         #清除畫面
   CALL g_bga.clear()
   CALL cl_set_head_visible("","YES") #FUN-6B0033   
 
   INITIALIZE g_bga01 TO NULL    #No.FUN-750051
   INITIALIZE g_bga04 TO NULL    #No.FUN-750051
   INITIALIZE g_bga02 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON bga01,bga04,bga02,bga03,bga05,bgaacti
        FROM bga01,bga04,bga02,s_bga[1].bga03,s_bga[1].bga05,s_bga[1].bgaacti
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bga04)        #呼叫幣別
             # CALL q_azi(05,11,g_bga04) RETURNING g_bga04
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_bga04
               CALL cl_create_qry() RETURNING g_bga04
#              CALL FGL_DIALOG_SETBUFFER( g_bga04 )
             # DISPLAY BY NAME g_bga04
               NEXT FIELD bga04
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
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND bgbuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND bgbgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND bgbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bgbuser', 'bgbgrup')
   #End:FUN-980030
 
 
   LET g_sql= "SELECT UNIQUE bga01,bga04,bga02 FROM bga_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY bga01"
   PREPARE i001_prepare FROM g_sql      #預備一下
   DECLARE i001_bcs                     #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i001_prepare
 
#  LET g_sql = "SELECT UNIQUE bga01,bga04,bga02 FROM bga_file ",      #No.TQC-720019
   LET g_sql_tmp = "SELECT UNIQUE bga01,bga04,bga02 FROM bga_file ",  #No.TQC-720019
               " WHERE ", g_wc CLIPPED,
               " INTO TEMP x "
   DROP TABLE x
#  PREPARE i001_precount_x FROM g_sql      #No.TQC-720019
   PREPARE i001_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i001_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i001_precount FROM g_sql
   DECLARE i001_count CURSOR FOR i001_precount
 
END FUNCTION
 
FUNCTION i001_menu()
 
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i001_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i001_copy()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i001_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i001_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bga),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bga01 IS NOT NULL THEN
                LET g_doc.column1 = "bga01"
                LET g_doc.column2 = "bga04"
                LET g_doc.column3 = "bga02"
                LET g_doc.value1 = g_bga01
                LET g_doc.value2 = g_bga04
                LET g_doc.value3 = g_bga02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i001_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_bga.clear()
   LET g_bga01    = NULL
   LET g_bga02    = NULL
   LET g_bga04    = NULL
   LET g_bga01_t  = NULL
   LET g_bga02_t  = NULL
   LET g_bga04_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i001_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_bga01=NULL
         LET g_bga02=NULL
         LET g_bga04=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_bga02) OR cl_null(g_bga04) THEN
         CONTINUE WHILE
      END IF
 
      CALL g_bga.clear()
      LET g_rec_b = 0                    #No.FUN-680064
 
      CALL i001_b_fill('1=1')            #單身
 
      CALL i001_b()                      #輸入單身
 
      LET g_bga01_t = g_bga01
      LET g_bga02_t = g_bga02
      LET g_bga04_t = g_bga04
 
      LET g_wc="     bga01='",g_bga01,"' ",
               " AND bga02='",g_bga02,"' ",
               " AND bga04='",g_bga04,"' "
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i001_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改  #No.FUN-680061 VARCHAR(1) 
   l_n             LIKE type_file.num5,   #No.FUN-680061  SMALLINT
   l_str           LIKE type_file.chr50   #No.FUN-680061  VARCHAR(40)
   
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   INPUT g_bga01,g_bga04,g_bga02 WITHOUT DEFAULTS FROM bga01,bga04,bga02
 
      AFTER FIELD bga01                    #版本控管
         CASE
            WHEN g_bgz.bgz01='Y'
               IF cl_null(g_bga01) THEN
                  NEXT FIELD bga01
               END IF
               DISPLAY g_bga01 TO bga01
            WHEN g_bgz.bgz01='N'
               IF cl_null(g_bga01) THEN
                  LET g_bga01=' '
               END IF
               DISPLAY g_bga01 TO bga01
         END CASE
 
      AFTER FIELD bga04                    #幣別
         IF NOT cl_null(g_bga04) THEN
            SELECT COUNT(*) INTO g_cnt
              FROM azi_file
             WHERE azi01=g_bga04
            IF g_cnt = 0 THEN
               CALL cl_err('select azi',STATUS,0)
               NEXT FIELD bga04
            END IF
         END IF
 
      AFTER FIELD bga02
         IF NOT cl_null(g_bga02) THEN
            SELECT COUNT(*) INTO l_n FROM bga_file
             WHERE bga01=g_bga01
               AND bga04=g_bga04
               AND bga02=g_bga02
            IF l_n > 0 THEN
               CALL cl_err(g_bga02,-239,0)
               NEXT FIELD bga02
            END IF
         END IF
 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bga04)        #呼叫幣別
             # CALL q_azi(05,11,g_bga04) RETURNING g_bga04
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_bga04
               CALL cl_create_qry() RETURNING g_bga04
#              CALL FGL_DIALOG_SETBUFFER( g_bga04 )
             # DISPLAY BY NAME g_bga04
               NEXT FIELD bga04
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF                 #欄位說明
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
 
FUNCTION i001_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
      INITIALIZE g_bga01 TO NULL       #No.FUN-6A0003
      INITIALIZE g_bga04 TO NULL       #No.FUN-6A0003
      INITIALIZE g_bga02 TO NULL       #No.FUN-6A0003
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_bga.clear()
 
   CALL i001_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_bga01 TO NULL
      INITIALIZE g_bga04 TO NULL
      INITIALIZE g_bga02 TO NULL
      RETURN
   END IF
 
   OPEN i001_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bga01 TO NULL
      INITIALIZE g_bga04 TO NULL
      INITIALIZE g_bga02 TO NULL
   ELSE
      OPEN i001_count
      FETCH i001_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i001_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i001_fetch(p_flag)
DEFINE
   p_flag  LIKE type_file.chr1    #處理方式 #No.FUN-680061 VARCHAR(1)
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i001_bcs INTO g_bga01,g_bga04,g_bga02
      WHEN 'P' FETCH PREVIOUS i001_bcs INTO g_bga01,g_bga04,g_bga02
      WHEN 'F' FETCH FIRST    i001_bcs INTO g_bga01,g_bga04,g_bga02
      WHEN 'L' FETCH LAST     i001_bcs INTO g_bga01,g_bga04,g_bga02
      WHEN '/'
         IF (NOT mi_no_ask) THEN                    #No.FUN-6A0057 g_no_ask 
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
         FETCH ABSOLUTE g_jump i001_bcs INTO g_bga01,g_bga04,g_bga02
         LET mi_no_ask = FALSE                 #No.FUN-6A0057 g_no_ask 
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_bga01,SQLCA.sqlcode,0)
      INITIALIZE g_bga01 TO NULL  #TQC-6B0105
      INITIALIZE g_bga02 TO NULL  #TQC-6B0105
      INITIALIZE g_bga04 TO NULL  #TQC-6B0105
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
 
 #   SELECT UNIQUE bga01,bga04,bga02 INTO g_bga01,g_bga04,g_bga02   #MOD-580192
    SELECT UNIQUE bga01,bga04,bga02,bgauser,bgagrup    #MOD-580192
           INTO g_bga01,g_bga04,g_bga02,g_bgauser,g_bgagrup   #MOD-580192
     FROM bga_file
    WHERE bga01=g_bga01
      AND bga02=g_bga02
      AND bga04=g_bga04
 
   IF SQLCA.sqlcode THEN                  #有麻煩
#     CALL cl_err(g_bga01,SQLCA.sqlcode,0) #FUN-660105
      CALL cl_err3("sel","bga_file",g_bga01,g_bga02,SQLCA.sqlcode,"","",1) #FUN-660105 
   ELSE
      LET g_data_owner = g_bgauser   #FUN-4C0067
      LET g_data_group = g_bgagrup   #FUN-4C0067
      CALL i001_show()
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i001_show()
 
   DISPLAY g_bga01 TO bga01                #單頭
   DISPLAY g_bga04 TO bga04                #單頭
   DISPLAY g_bga02 TO bga02                #單頭
 
   CALL i001_b_fill(g_wc)                  #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i001_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_bga01) THEN
      CALL cl_err('',-400,0)                  #No.FUN-6A0003
      RETURN
   END IF
 
   CASE
      WHEN g_bgz.bgz01 = "Y"
         IF cl_null(g_bga01) THEN
            CALL cl_err('',-400,0)
            RETURN
         END IF
         DISPLAY g_bga01 TO bga01
      WHEN g_bgz.bgz01 = "N"
         IF cl_null(g_bga01) THEN
            LET g_bga01=' '
         END IF
         IF cl_null(g_bga04) OR cl_null(g_bga02) THEN
            CALL cl_err('',-400,0)
            RETURN
         END IF
   END CASE
 
   BEGIN WORK
 
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bga01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "bga04"      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "bga02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bga01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_bga04       #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_bga02       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM bga_file
       WHERE bga01=g_bga01
         AND bga04=g_bga04
         AND bga02=g_bga02
 
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #FUN-660105
         CALL cl_err3("del","bga_file",g_bga01,g_bga02,SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105 
      ELSE
         CLEAR FORM
         #MOD-5A0004 add
         DROP TABLE x
#        EXECUTE i001_precount_x                  #No.TQC-720019
         PREPARE i001_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i001_precount_x2                 #No.TQC-720019
         #MOD-5A0004 end
         CALL g_bga.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
 
         OPEN i001_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i001_bcs
            CLOSE i001_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i001_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i001_bcs
            CLOSE i001_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
 
         OPEN i001_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i001_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE        #No.FUN-6A0057 g_no_ask 
            CALL i001_fetch('/')
         END IF
      END IF
 
      LET g_msg=TIME
 
     #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
          #VALUES ('agli001',g_user,g_today,g_msg,g_bga01,'delete') #FUN-980001 mark
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
           VALUES ('abgi001',g_user,g_today,g_msg,g_bga01,'delete',g_plant,g_legal) #FUN-980001 add
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i001_b()
DEFINE
   l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
   l_n             LIKE type_file.num5,   #檢查重複用 #No.FUN-680061  SMALLINT
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否 #No.FUN-680061  VARCHAR(1)
   p_cmd           LIKE type_file.chr1,   #處理狀態   #No.FUN-680061  VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,   #可新增否   #No.FUN-680061  SMALLINT
   l_allow_delete  LIKE type_file.num5    #可刪除否   #No.FUN-680061  SMALLINT
 
   LET g_action_choice = ""
 
   IF g_bgz.bgz01 = "Y" THEN
      IF cl_null(g_bga01) THEN
         RETURN
      END IF
   ELSE
      IF cl_null(g_bga04) OR cl_null(g_bga02) THEN
         RETURN
      END IF
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT bga03,bga05,bgaacti FROM bga_file ",
                      "  WHERE bga01 = ? AND bga04 = ? AND bga02 = ? ",
                      "   AND bga03 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_bga WITHOUT DEFAULTS FROM s_bga.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
            LET g_bga_t.* = g_bga[l_ac].*  #BACKUP
            OPEN i001_b_cl USING g_bga01,g_bga04,g_bga02,g_bga_t.bga03
            IF STATUS THEN
               CALL cl_err("OPEN i001_b_cl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_bga01_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_bga_t.*=g_bga[l_ac].*
               END IF
               FETCH i001_b_cl INTO g_bga[l_ac].*
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_bga[l_ac].* TO NULL            #900423
         LET g_bga_t.* = g_bga[l_ac].*               #新輸入資料
         LET g_bga[l_ac].bga05 = 1
         LET g_bga[l_ac].bgaacti = 'Y'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bga03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO bga_file(bga01,bga02,bga03,bga04,bga05,bgaacti,
                              bgauser,bgagrup,bgadate,bgaoriu,bgaorig)   #MOD-9B0062 add
         VALUES(g_bga01,g_bga02,g_bga[l_ac].bga03,g_bga04,
                g_bga[l_ac].bga05,g_bga[l_ac].bgaacti,
                g_user,g_grup,g_today, g_user, g_grup)   #MOD-9B0062 add      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bga[l_ac].bga03,SQLCA.sqlcode,0)  #FUN-660105
            CALL cl_err3("ins","bga_file",g_bga01,g_bga02,SQLCA.sqlcode,"","",1) #FUN-660105 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD bga03             #check版本/幣別/年/月是否重複
         IF NOT cl_null(g_bga[l_ac].bga03) THEN
            IF g_bga[l_ac].bga03 <=0 OR g_bga[l_ac].bga03 > 12 THEN
               NEXT FIELD bga03              #判斷是否在1~12月當中
            END IF
            IF g_bga[l_ac].bga03 != g_bga_t.bga03 OR cl_null(g_bga_t.bga03) THEN
               SELECT COUNT(*) INTO l_n FROM bga_file
                WHERE bga01=g_bga01
                  AND bga04=g_bga04
                  AND bga02=g_bga02
                  AND bga03=g_bga[l_ac].bga03
               IF l_n > 0 THEN
                  CALL cl_err(g_bga[l_ac].bga03,-239,0)
                  NEXT FIELD bga03
               END IF
            END IF
         END IF
 
       AFTER FIELD bga05                    #FUN-4C0072
             #TQC-970222---Begin                                                                                                    
             IF g_bga[l_ac].bga05 <= 0 THEN                                                                                         
                CALL cl_err(g_bga[l_ac].bga05,'axm-987',0)                                                                          
                NEXT FIELD bga05                                                                                                    
             END IF                                                                                                                 
             #TQC-970222---End  
             IF g_bga04 =g_aza.aza17 THEN
                LET g_bga[l_ac].bga05 =1
                DISPLAY g_bga[l_ac].bga05   TO bga05
             END IF
 
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_bga_t.bga03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
 
            DELETE FROM bga_file
             WHERE bga01 = g_bga01
               AND bga04 = g_bga04
               AND bga02 = g_bga02
               AND bga03 = g_bga_t.bga03
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bga_t.bga03,SQLCA.sqlcode,0)  #FUN-660105
               CALL cl_err3("del","bga_file",g_bga01,g_bga_t.bga03,SQLCA.sqlcode,"","",1) #FUN-660105 
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
            LET g_bga[l_ac].* = g_bga_t.*
            CLOSE i001_b_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_bga[l_ac].bga03,-263,1)
            LET g_bga[l_ac].* = g_bga_t.*
         ELSE
            UPDATE bga_file SET bga03=g_bga[l_ac].bga03,
                                bga05=g_bga[l_ac].bga05,
                                bgaacti=g_bga[l_ac].bgaacti,  #MOD-9B0062 mod
                                bgamodu=g_user,               #MOD-9B0062 add
                                bgadate=g_today               #MOD-9B0062 add
                         WHERE CURRENT OF i001_b_cl  #
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bga[l_ac].bga03,SQLCA.sqlcode,0)  #FUN-660105
               CALL cl_err3("upd","bga_file",g_bga01,g_bga[l_ac].bga03,SQLCA.sqlcode,"","",1) #FUN-660105 
               LET g_bga[l_ac].* = g_bga_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_bga[l_ac].* = g_bga_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_bga.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i001_b_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac #FUN-D30032 add
         CLOSE i001_b_cl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(bga03) AND l_ac > 1 THEN
            LET g_bga[l_ac].* = g_bga[l_ac-1].*
            LET g_bga[l_ac].bga03=l_ac
            NEXT FIELD bga03
         END IF
 
      #-----No.FUN-4B0074-----
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bga05)
                 CALL s_rate(g_bga04,g_bga[l_ac].bga05) RETURNING g_bga[l_ac].bga05
                 DISPLAY BY NAME g_bga[l_ac].bga05
                 NEXT FIELD bga05
         END CASE
      #-----No.FUN-4B0074 END-----
 
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
 
      ON ACTION controls                        #FUN-6B0033
         CALL cl_set_head_visible("","AUTO")    #FUN-6B0033
 
   END INPUT
 
   CLOSE i001_b_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i001_b_askkey()
DEFINE
    l_wc   LIKE type_file.chr1000#No.FUN-680061  VARCHAR(200)
 
   CONSTRUCT l_wc ON bga03,bga05,bgaacti #螢幕上取條件
        FROM s_bga[1].bga03,s_bga[1].bga05,s_bga[1].bgaacti
 
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
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CALL i001_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i001_b_fill(p_wc)                     #BODY FILL UP
DEFINE
    p_wc  LIKE type_file.chr1000 #No.FUN-680061  VARCHAR(200)
 
   LET g_sql = "SELECT bga03,bga05,bgaacti,'' ",
               "  FROM bga_file ",
               " WHERE bga01 = '",g_bga01,"'",
               "   AND bga04 = '",g_bga04,"'",
               "   AND bga02 = '",g_bga02,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY bga03"
   PREPARE i001_prepare2 FROM g_sql       #預備一下
   DECLARE bga_cs CURSOR FOR i001_prepare2
 
   CALL g_bga.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH bga_cs INTO g_bga[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      #-----TQC-630104---------
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
      #-----END TQC-630104----- 
   END FOREACH
 
   CALL g_bga.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i001_bp(p_ud)
DEFINE
    p_ud    LIKE type_file.chr1    #No.FUN-680061  VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   #DISPLAY ARRAY g_bga TO s_bga.* ATTRIBUTE(COUNT=g_rec_b)           #FUN-5A0107 remark
   DISPLAY ARRAY g_bga TO s_bga.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #FUN-5A0107
 
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
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i001_fetch('L')
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
      
      ON ACTION controls                        #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")    #No.FUN-6B0033
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i001_copy()
DEFINE
    old_ver   LIKE bga_file.bga01,     #原版本 #FUN-680061 VARCHAR(10)
    oyy       LIKE bga_file.bga02,     #原年度 #FUN-680061 VARCHAR(04)
    ocur      LIKE bga_file.bga04,     #原月份 #FUN-680061 VARCHAR(04)
    new_ver   LIKE bga_file.bga01,     #新版本 #FUN-680061 VARCHAR(10)
    nyy       LIKE bga_file.bga02,     #新年度 #FUN-680061 VARCHAR(04)
    l_i       LIKE type_file.num10,    #拷貝筆數 #FUN-680061 INTEGER
    l_bga     RECORD  LIKE bga_file.*  #複製用buffer 
 
 
   OPEN WINDOW i001_c_w AT 8,36 WITH FORM "abg/42f/abgi001_c"
          ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_locale("abgi001_c")   #TQC-630053
 
   IF STATUS THEN
      CALL cl_err('open window i001_c_w:',STATUS,0)
      RETURN
   END IF
  
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033   
 
   WHILE TRUE
      LET old_ver = g_bga01
      LET oyy     = g_bga02
      LET ocur    = g_bga04
      LET new_ver = NULL
      LET nyy = NULL
 
      INPUT BY NAME old_ver,oyy,ocur,new_ver,nyy WITHOUT DEFAULTS
 
         AFTER FIELD old_ver
            CASE
               WHEN g_bgz.bgz01 MATCHES "[Y]"
                  IF cl_null(old_ver) THEN
                     NEXT FIELD old_ver
                  END IF
                  DISPLAY old_ver TO old_ver
               WHEN g_bgz.bgz01 MATCHES "[N]"
                  IF cl_null(old_ver) THEN
                     LET old_ver=' '
                  END IF
            END CASE
 
         AFTER FIELD oyy
            IF cl_null(oyy) THEN
               NEXT FIELD oyy
            END IF
 
         AFTER FIELD ocur
            IF cl_null(ocur) THEN
               NEXT FIELD ocur
            END IF
            SELECT COUNT(*) INTO g_cnt
              FROM azi_file
             WHERE azi01=ocur
            IF g_cnt = 0 THEN
               CALL cl_err('select azi',STATUS,0)
               NEXT FIELD ocur
            END IF
 
         AFTER FIELD new_ver
            IF cl_null(new_ver) THEN
               IF g_bgz.bgz01 = 'N' THEN
                  LET new_ver = ' '
               ELSE
                  CALL cl_err('', 'abg-001', 0)
                  NEXT FIELD new_ver
               END IF
            END IF
 
         AFTER FIELD nyy
            IF cl_null(nyy) THEN
               NEXT FIELD nyy
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
         CLOSE WINDOW i001_c_w
         LET INT_FLAG=0
         RETURN
      END IF
 
      IF new_ver IS NULL OR nyy IS NULL THEN
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE WINDOW i001_c_w
 
   BEGIN WORK
   LET g_success='Y'
   DECLARE i001_c CURSOR FOR SELECT * FROM bga_file
                              WHERE bga01 = old_ver
                                AND bga04 = ocur
                                AND bga02 = oyy
   LET l_i = 0
 
   FOREACH i001_c INTO l_bga.*
      LET l_i = l_i+1
      LET l_bga.bga01 = new_ver
      LET l_bga.bga02 = nyy
 
      LET l_bga.bgaoriu = g_user      #No.FUN-980030 10/01/04
      LET l_bga.bgaorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO bga_file VALUES(l_bga.*)
      IF STATUS THEN
#        CALL cl_err('ins bga:',STATUS,1)  #FUN-660105
         CALL cl_err3("ins","bga_file",l_bga.bga01,l_bga.bga02,STATUS,"","ins bga:",1) #FUN-660105 
         LET g_success='N'
      END IF
   END FOREACH
 
   IF g_success='Y' THEN
      COMMIT WORK
      #FUN-C30027---begin
      LET g_bga01 = new_ver
      LET g_bga02 = nyy
      LET g_bga04 = ocur
      LET g_wc = '1=1'
      CALL i001_show()          
      #FUN-C30027---end   
      MESSAGE l_i, ' rows copied!'
   ELSE
      ROLLBACK WORK
      MESSAGE 'rollback work!'
   END IF
 
END FUNCTION
 
FUNCTION i001_out()
    DEFINE
        l_i             LIKE type_file.num5,     #No.FUN-680061 SMALLINT
        l_name          LIKE type_file.chr20,    # External(Disk) file name #No.FUN-680061 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,  #FUN-680061  VARCHAR(40)
        sr RECORD
             bga01      LIKE bga_file.bga01,
             bga02      LIKE bga_file.bga02,
             bga03      LIKE bga_file.bga03,
             bga04      LIKE bga_file.bga04,
             bga05      LIKE bga_file.bga05,
             bgaacti    LIKE bga_file.bgaacti
        END RECORD
 
   IF g_bga01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_wait()
#  CALL cl_outnam('abgi001') RETURNING l_name                  #No.FUN-770033
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-770033
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
 
   IF g_len = 0 OR g_len IS NULL THEN
      LET g_len = 80
   END IF
 
   FOR g_i = 1 TO g_len
      LET g_dash[g_i,g_i] = '='
   END FOR
 
   #No.FUN-870151---Begin
   #LET g_sql="SELECT bga01,bga02,bga03,bga04,bga05,bgaacti FROM bga_file ",   # 組合出 SQL 指令
   #          " WHERE ",g_wc CLIPPED ,
   #          " ORDER BY bga01,bga02,bga03 "
   LET g_sql="SELECT bga01,bga02,bga03,bga04,bga05,bgaacti,azi07 FROM bga_file,azi_file ",   # 組合出 SQL 指令
             " WHERE azi01 = bga04 AND ",g_wc CLIPPED ,
             " ORDER BY bga01,bga02,bga03 "
   #No.FUN-870151---End             
#No.FUN-770033--start--                                                                                                             
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(g_wc,'bga01,bga04,bga02,bga03,bga05')                                                                              
        RETURNING g_wc                                                                                                             
        LET g_str = g_wc                                                                                                           
     END IF
   LET g_str =g_str,";",g_azi07                                                                                    
   CALL cl_prt_cs1('abgi001','abgi001',g_sql,g_str)      
 
  {PREPARE i001_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i001_co CURSOR FOR i001_p1
 
   START REPORT i001_rep TO l_name
 
   FOREACH i001_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT i001_rep(sr.*)
   END FOREACH
 
   FINISH REPORT i001_rep
 
   CLOSE i001_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)}
#FUN-770033--end 
END FUNCTION
 
#FUN-770033--begin 
{REPORT i001_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #FUN-680061  VARCHAR(1)
        sr RECORD
           bga01   LIKE bga_file.bga01,
           bga02   LIKE bga_file.bga02,
           bga03   LIKE bga_file.bga03,
           bga04   LIKE bga_file.bga04,
           bga05   LIKE bga_file.bga05,
           bgaacti LIKE bga_file.bgaacti
        END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.bga01,sr.bga02,sr.bga04,sr.bga03
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED, pageno_total
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      BEFORE GROUP OF sr.bga04
         PRINT COLUMN g_c[31],sr.bga01 CLIPPED,
               COLUMN g_c[32],sr.bga04 CLIPPED,
               COLUMN g_c[33],sr.bga02 CLIPPED;
 
      ON EVERY ROW
         PRINT COLUMN g_c[34],sr.bga03 CLIPPED,
               COLUMN g_c[35],cl_numfor(sr.bga05,35,g_azi07) CLIPPED,
               COLUMN g_c[36],sr.bgaacti
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         LET l_trailer_sw = 'n'
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#FUN-770033--end
