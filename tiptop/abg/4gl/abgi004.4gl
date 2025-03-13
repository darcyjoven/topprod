# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi004.4gl
# Descriptions...: 職等職級底薪資料維護作業
# Date & Author..: 02/10/01 By qazzaq
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0067 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-510025 05/01/14 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530246 05/03/28 By ice  單身異常顯示(超過一筆時，并翻上下頁)
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key 可更改
# Modify.........: NO.MOD-590329 05/09/30 by Yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: NO MOD-5A0004 05/10/07 By Rosayu _r()後筆數不正確
# Modify.........: No.TQC-5C0037 05/12/08 By kevin 加入語言別設定
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/14 By jamie 1.FUNCTION i004()_q 一開始應清空g_bgd的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/10 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
## Modify.........: No.FUN-770033 07/06/27 By destiny 報表改為使用crystal report
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-970280 09/07/27 By Carrier 非負控制
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bgd01         LIKE bgd_file.bgd01,    #版本
    g_bgd01_t       LIKE bgd_file.bgd01,    #版本(舊值)
    g_bgduser       LIKE bgd_file.bgduser,
    g_bgdgrup       LIKE bgd_file.bgdgrup,
    g_bgd           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        bgd02       LIKE bgd_file.bgd02,    #職等
        bgd03       LIKE bgd_file.bgd03,    #職級
        bgd04       LIKE bgd_file.bgd04,    #標準底薪
        bgd05       LIKE bgd_file.bgd05,    #投保薪資
        bgdacti     LIKE bgd_file.bgdacti   #有效否
                    END RECORD,
    g_bgd_t         RECORD                  #程式變數(舊值)
        bgd02       LIKE bgd_file.bgd02,    #職等
        bgd03       LIKE bgd_file.bgd03,    #職級
        bgd04       LIKE bgd_file.bgd04,    #標準底薪
        bgd05       LIKE bgd_file.bgd05,    #投保薪資
        bgdacti     LIKE bgd_file.bgdacti   #有效否
                    END RECORD, 
    g_wc,g_sql,g_wc2    string,             #No.FUN-580092 HCN
    g_show          LIKE type_file.chr1,    #FUN-680061 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,    #單身筆數  #No.FUN-680061 SMALLINT
    g_flag          LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(1)
    g_ver           LIKE type_file.chr1,    #版本參數 #No.FUN-680061 VARCHAR(1)
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680061 SMALLINT  
DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE   g_forupd_sql    STRING                #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp       STRING                #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03     #No.FUN-680061 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5         #No.FUN-680061 SMALLINT #No.FUN-6A0057 g_no_ask 
DEFINE   g_str          STRING                      #No.FUN-770033
#主程式開始
MAIN
#   DEFINE      l_time    LIKE type_file.chr8       #No.FUN-6A0056
 
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
    LET g_bgd01 = NULL
    LET p_row = 5 LET p_col = 26
 
 OPEN WINDOW i004_w AT p_row,p_col
        WITH FORM "abg/42f/abgi004" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL i004_menu()
 
    CLOSE WINDOW i004_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i004_cs()
    CLEAR FORM                         #清除畫面
    CALL g_bgd.clear()
   INITIALIZE g_bgd01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bgd01,bgd02,bgd03,bgd04,bgd05,bgdacti
    FROM bgd01,s_bgd[1].bgd02,s_bgd[1].bgd03,s_bgd[1].bgd04,s_bgd[1].bgd05,
         s_bgd[1].bgdacti
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND bgduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND bgdgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND bgdgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bgduser', 'bgdgrup')
    #End:FUN-980030
 
 
    LET g_sql= "SELECT UNIQUE bgd01  FROM bgd_file ",  #注意
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bgd01"
    PREPARE i004_prepare FROM g_sql      #預備一下
    DECLARE i004_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i004_prepare
 
# LET g_sql = "SELECT UNIQUE bgd01",      #No.TQC-720019
  LET g_sql_tmp = "SELECT UNIQUE bgd01",  #No.TQC-720019
              "  FROM bgd_file ",
              " WHERE ", g_wc CLIPPED,
              " INTO TEMP x "
  DROP TABLE x
 
# PREPARE i004_pre_x FROM g_sql      #No.TQC-720019
  PREPARE i004_pre_x FROM g_sql_tmp  #No.TQC-720019
  EXECUTE i004_pre_x
 
  LET g_sql = "SELECT COUNT(*) FROM x"
  PREPARE i004_precnt FROM g_sql
  DECLARE i004_count CURSOR FOR i004_precnt
 
 
END FUNCTION
 
#中文的MENU
FUNCTION i004_menu()
   WHILE TRUE
      CALL i004_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               LET g_bgd01 = NULL
               CALL i004_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_bgd01 = NULL
               CALL i004_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i004_copy()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i004_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i004_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i004_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgd),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_bgd01 IS NOT NULL THEN
                 LET g_doc.column1 = "bgd01"
                 LET g_doc.value1 = g_bgd01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i004_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_bgd.clear()
    LET g_bgd01    = NULL
    LET g_bgd01_t  = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i004_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
           LET g_bgd01 = NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        CALL g_bgd.clear()
        LET g_rec_b = 0                    #No.FUN-680064
        CALL i004_bf('1=1')            #單身
        CALL i004_b()                      #輸入單身
        LET g_bgd01_t = g_bgd01
        LET g_wc=" bgd01='",g_bgd01,"' "
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i004_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680061 VARCHAR(1)
    l_n             LIKE type_file.num5,    #No.FUN-680061 SMALLINT
    l_str           LIKE type_file.chr50    #FUN-680061    VARCHAR(40)
 
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0033    
 
    INPUT g_bgd01 WITHOUT DEFAULTS
         FROM bgd01 HELP 1
 
        AFTER FIELD bgd01                    #版本控管
            IF cl_null(g_bgd01) THEN
               LET g_bgd01=' '
            END IF
            SELECT COUNT(*) INTO l_n FROM bgd_file
             WHERE bgd01=g_bgd01
            IF l_n > 0 THEN
               CALL cl_err(g_bgd01,-239,0)
               NEXT FIELD bgd01
            END IF
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
 
 
#Query 查詢
FUNCTION i004_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bgd01 TO NULL             #No.FUN-6A0003
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_bgd.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i004_cs()                      #取得查詢條件
    IF INT_FLAG THEN                    #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i004_bcs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN               #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_bgd01 TO NULL
    ELSE
       OPEN i004_count
       FETCH i004_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i004_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i004_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1   #處理方式  #No.FUN-680061 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i004_bcs INTO g_bgd01
        WHEN 'P' FETCH PREVIOUS i004_bcs INTO g_bgd01
        WHEN 'F' FETCH FIRST    i004_bcs INTO g_bgd01
        WHEN 'L' FETCH LAST     i004_bcs INTO g_bgd01
        WHEN '/'
         IF (NOT mi_no_ask) THEN      #No.FUN-6A0057 g_no_ask 
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
         FETCH ABSOLUTE g_jump i004_bcs INTO g_bgd01
         LET mi_no_ask = FALSE     #No.FUN-6A0057 g_no_ask 
    END CASE
    IF SQLCA.sqlcode THEN                  #有麻煩
       CALL cl_err(g_bgd01,SQLCA.sqlcode,0)
       INITIALIZE g_bgd01 TO NULL  #TQC-6B0105
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
    SELECT UNIQUE bgd01 INTO g_bgd01
      FROM bgd_file
     WHERE bgd01=g_bgd01
    IF SQLCA.sqlcode THEN                  #有麻煩
#       CALL cl_err(g_bgd01,SQLCA.sqlcode,0) #FUN-660105
        CALL cl_err3("sel","bgd_file",g_bgd01,"",SQLCA.sqlcode,"","",1) #FUN-660105
    ELSE
        LET g_data_owner = g_bgduser   #FUN-4C0067
        LET g_data_group = g_bgdgrup   #FUN-4C0067
        CALL i004_show()
    END IF
 
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i004_show()
    DISPLAY g_bgd01 TO bgd01                #單頭
    CALL i004_bf(g_wc)                      #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i004_r()
 
  IF s_shut(0) THEN RETURN END IF
 
# IF cl_null(g_wc) AND g_bgd01 IS NULL THEN       #No.FUN-6A0003
  IF g_bgd01 IS NULL THEN                         #No.FUN-6A0003
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  BEGIN WORK
  IF cl_delh(15,16) THEN
      INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "bgd01"      #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_bgd01       #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                                       #No.FUN-9B0098 10/02/24
     DELETE FROM bgd_file
      WHERE bgd01=g_bgd01
     IF SQLCA.sqlcode THEN
#       CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #FUN-660105
        CALL cl_err3("del","bgd_file",g_bgd01,"",SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105
     ELSE
        CLEAR FORM
        #MOD-5A0004 add
        DROP TABLE x
#       EXECUTE i004_pre_x                  #No.TQC-720019
        PREPARE i004_pre_x2 FROM g_sql_tmp  #No.TQC-720019
        EXECUTE i004_pre_x2                 #No.TQC-720019
        #MOD-5A0004 end
        CALL g_bgd.clear()
        LET g_cnt=SQLCA.SQLERRD[3]
        MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        OPEN i004_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE i004_bcs
           CLOSE i004_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--

        FETCH i004_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i004_bcs
           CLOSE i004_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i004_bcs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i004_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE       #No.FUN-6A0057 g_no_ask 
           CALL i004_fetch('/')
        END IF
     END IF
     LET g_msg=TIME
  END IF
  COMMIT WORK
END FUNCTION
 
 
#單身
FUNCTION i004_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用   #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否   #No.FUN-680061 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態     #No.FUN-680061 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,   #可新增否     #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否     #No.FUN-680061 SMALLINT
 
    LET g_action_choice = ""
 
    IF cl_null(g_wc) AND g_bgd01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT bgd02,bgd03,bgd04,bgd05,bgdacti FROM bgd_file ",
       "WHERE bgd01 = ? AND bgd02 = ? AND bgd03 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i004_b_cl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bgd WITHOUT DEFAULTS FROM s_bgd.*
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
                LET g_bgd_t.* = g_bgd[l_ac].*  #BACKUP
# NO.MOD-590329 MARK
 #No.MOD-580078 --start
#                LET g_before_input_done = FALSE
#                CALL i004_set_entry_b(p_cmd)
#                CALL i004_set_no_entry_b(p_cmd)
#                LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329
                OPEN i004_b_cl USING g_bgd01,g_bgd_t.bgd02,g_bgd_t.bgd03
                IF STATUS THEN
                   CALL cl_err("OPEN i004_b_cl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_bgd01_t,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_bgd_t.*=g_bgd[l_ac].*
                   END IF
                   FETCH i004_b_cl INTO g_bgd[l_ac].*
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD bgd02
 
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bgd[l_ac].* TO NULL            #900423
            LET g_bgd_t.* = g_bgd[l_ac].*               #新輸入資料
            LET g_bgd[l_ac].bgd04 = 0
            LET g_bgd[l_ac].bgd05 = 0
            LET g_bgd[l_ac].bgdacti = 'Y'
#NO.MOD-590329 MARK
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i004_set_entry_b(p_cmd)
#            CALL i004_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bgd02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO bgd_file(bgd01,bgd02,bgd03,bgd04,bgd05,bgdacti,bgdoriu,bgdorig)
              VALUES(g_bgd01,g_bgd[l_ac].bgd02,g_bgd[l_ac].bgd03,
                 g_bgd[l_ac].bgd04,g_bgd[l_ac].bgd05,g_bgd[l_ac].bgdacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bgd[l_ac].bgd02,SQLCA.sqlcode,0) #FUN-660105
                CALL cl_err3("ins","bgd_file",g_bgd01,g_bgd[l_ac].bgd02,SQLCA.sqlcode,"","",1) #FUN-660105
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD bgd03
            IF NOT cl_null(g_bgd[l_ac].bgd03) THEN
               IF g_bgd[l_ac].bgd03 != g_bgd_t.bgd03 OR
                  cl_null(g_bgd_t.bgd03) THEN
                  IF g_bgd[l_ac].bgd02 != g_bgd_t.bgd02 OR
                     cl_null(g_bgd_t.bgd02) THEN
                     SELECT COUNT(*) INTO l_n FROM bgd_file
                     WHERE bgd01=g_bgd01
                     AND bgd02=g_bgd[l_ac].bgd02
                     AND bgd03=g_bgd[l_ac].bgd03
                  END IF
                  IF l_n > 0 THEN
                     CALL cl_err(g_bgd[l_ac].bgd03,-239,0)
                     NEXT FIELD bgd03
                  END IF
               END IF
            END IF
 
        #No.TQC-970280  --Begin
        AFTER FIELD bgd04
            IF NOT cl_null(g_bgd[l_ac].bgd04) THEN
               IF g_bgd[l_ac].bgd04 < 0 THEN
                  CALL cl_err(g_bgd[l_ac].bgd04,'aim-223',0)
                  NEXT FIELD bgd04
               END IF
            END IF
 
        AFTER FIELD bgd05
            IF NOT cl_null(g_bgd[l_ac].bgd05) THEN
               IF g_bgd[l_ac].bgd05 < 0 THEN
                  CALL cl_err(g_bgd[l_ac].bgd05,'aim-223',0)
                  NEXT FIELD bgd05
               END IF
            END IF
        #No.TQC-970280  --End  
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bgd_t.bgd02) AND
               NOT cl_null(g_bgd_t.bgd03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bgd_file
                    WHERE bgd01 = g_bgd01
                      AND bgd02 = g_bgd_t.bgd02
                      AND bgd03 = g_bgd_t.bgd03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bgd_t.bgd02,SQLCA.sqlcode,0) #FUN-660105
                    CALL cl_err3("del","bgd_file",g_bgd01,g_bgd_t.bgd02,SQLCA.sqlcode,"","",1) #FUN-660105
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
               LET g_bgd[l_ac].* = g_bgd_t.*
               CLOSE i004_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bgd[l_ac].bgd02,-263,1)
               LET g_bgd[l_ac].* = g_bgd_t.*
            ELSE
               UPDATE bgd_file SET bgd02=g_bgd[l_ac].bgd02,
                                   bgd03=g_bgd[l_ac].bgd03,
                                   bgd04=g_bgd[l_ac].bgd04,
                                   bgd05=g_bgd[l_ac].bgd05,
                                   bgdacti=g_bgd[l_ac].bgdacti
                WHERE CURRENT OF i004_b_cl  #要查一下
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_bgd[l_ac].bgd02,SQLCA.sqlcode,0)  #FUN-660105
                  CALL cl_err3("upd","bgd_file",g_bgd01,g_bgd_t.bgd02,SQLCA.sqlcode,"","",1) #FUN-660105
                  LET g_bgd[l_ac].* = g_bgd_t.*
                  ROLLBACK WORK
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
                  LET g_bgd[l_ac].* = g_bgd_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i004_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE i004_b_cl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i004_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(bgd02) AND l_ac > 1 THEN
                LET g_bgd[l_ac].* = g_bgd[l_ac-1].*
                LET g_bgd[l_ac].bgd02=l_ac
                NEXT FIELD bgd02
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
 
#No.FUN-6B0033 --START
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0033 --END
 
        END INPUT
 
    CLOSE i004_b_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i004_b_askkey()
DEFINE
    l_wc    LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(200)
 
    CONSTRUCT l_wc ON bgd02,bgd03,bgd04,bgd05,bgdacti #螢幕上取條件
       FROM s_bgd[1].bgd02,s_bgd[1].bgd03,s_bgd[1].bgd04,s_bgd[1].bgd05,
            s_bgd[1].bgdacti
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
    CALL i004_bf(l_wc)
END FUNCTION
 
FUNCTION i004_bf(p_wc)                     #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000 #No.FUN-680061 VARCHAR(200)
    LET g_sql =
       "SELECT bgd02,bgd03,bgd04,bgd05,bgdacti,'' ",
       "  FROM bgd_file ",
       " WHERE bgd01 = '",g_bgd01,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY bgd02"
    PREPARE i004_prepare2 FROM g_sql       #預備一下
    DECLARE bgd_cs CURSOR FOR i004_prepare2
    CALL g_bgd.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH bgd_cs INTO g_bgd[g_cnt].*     #單身 ARRAY 填充
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
    CALL g_bgd.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i004_bp(p_ud)
DEFINE
    p_ud  LIKE type_file.chr1   #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_bgd TO s_bgd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-530246
 
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
         CALL i004_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No.MOD-530246
 
      ON ACTION previous
         CALL i004_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No.MOD-530246
 
      ON ACTION jump
         CALL i004_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No.MOD-530246
 
      ON ACTION next
         CALL i004_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No.MOD-530246
 
      ON ACTION last
         CALL i004_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No.MOD-530246
 
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
 
#No.FUN-6B0033 --START
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0033 --END
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i004_copy()
DEFINE
    old_ver   LIKE aba_file.aba18,     #原版本
    new_ver   LIKE aba_file.aba18,     #新版本
    l_i       LIKE type_file.num10,    #拷貝筆數 #FUN-680061 INTEGER
    l_bgd     RECORD  LIKE bgd_file.*  #複製用buffer
 
    OPEN WINDOW i004_c_w AT 10,40 WITH FORM "abg/42f/abgi004_c"
           ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale('abgi004_c') #No.TQC-5C0037
    IF STATUS THEN
       CALL cl_err('open window i004_c_w:',STATUS,0)
       RETURN
    END IF
 
  WHILE TRUE
    LET old_ver = g_bgd01
    LET new_ver = NULL
 
    INPUT BY NAME old_ver, new_ver WITHOUT DEFAULTS
 
    AFTER FIELD old_ver
        IF cl_null(old_ver) THEN LET old_ver = ' ' END IF
        SELECT COUNT(*) INTO g_cnt FROM bgd_file
         WHERE bgd01 = old_ver
        IF g_cnt = 0 THEN
           CALL cl_err('','mfg9089',0)
           NEXT FIELD old_ver
        END IF
 
    AFTER FIELD new_ver
       IF cl_null(new_ver) THEN LET new_ver = ' ' END IF
       IF old_ver = new_ver THEN
          NEXT FIELD old_ver
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
       LET INT_FLAG=0
       CLOSE WINDOW i004_c_w
       RETURN
    END IF
    IF new_ver IS NULL THEN
       CONTINUE WHILE
    END IF
    EXIT WHILE
  END WHILE
 
    CLOSE WINDOW i004_c_w
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
    BEGIN WORK
    LET g_success='Y'
    DECLARE i004_c CURSOR FOR
        SELECT *
          FROM bgd_file
         WHERE bgd01 = old_ver
    LET l_i = 0
    FOREACH i004_c INTO l_bgd.*
        LET l_i = l_i+1
        LET l_bgd.bgd01 = new_ver
        LET l_bgd.bgdoriu = g_user      #No.FUN-980030 10/01/04
        LET l_bgd.bgdorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO bgd_file VALUES(l_bgd.*)
        IF STATUS THEN
#           CALL cl_err('ins bgd:',STATUS,1)  #FUN-660105
            CALL cl_err3("ins","bgd_file",l_bgd.bgd01,"",STATUS,"","ins bgd:",1) #FUN-660105
            LET g_success='N'
        END IF
    END FOREACH
    IF g_success='Y' THEN
        COMMIT WORK
        #FUN-C30027---begin
        LET g_bgd01 = new_ver
        LET g_wc = '1=1'
        CALL i004_show()          
        #FUN-C30027---end  
        MESSAGE l_i, ' rows copied!'
    ELSE
        ROLLBACK WORK
        MESSAGE 'rollback work!'
    END IF
END FUNCTION
 
FUNCTION i004_out()
    DEFINE
        l_i             LIKE type_file.num5,     #No.FUN-680061 SMALLINT
        l_name          LIKE type_file.chr20,    # External(Disk) file name #FUN-680061 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,  #FUN-680061 VARCHAR(40)
        sr RECORD
             bgd01      LIKE bgd_file.bgd01,
             bgd02      LIKE bgd_file.bgd02,
             bgd03      LIKE bgd_file.bgd03,
             bgd04      LIKE bgd_file.bgd04,
             bgd05      LIKE bgd_file.bgd05,
             bgdacti    LIKE bgd_file.bgdacti
        END RECORD
 
    IF cl_null(g_wc) AND g_bgd01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('abgi004') RETURNING l_name                               #No.FUN-770033                       
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 LET g_sql="SELECT bgd01,bgd02,bgd03,bgd04,bgd05,bgdacti FROM bgd_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY bgd01,bgd02,bgd03 "
#No.FUN-770033--start-- 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
    IF g_zz05 = 'Y' THEN                                                                                   
       CALL cl_wcchp(g_wc,'bgd01,bgd02,bgd03,bgd04,bgd05,bgdacti')                                                            
       RETURNING g_wc                                                                                     
       LET g_str = g_wc                                                                                     
    END IF 
    LET g_str =g_str,";",g_azi04                               
    CALL cl_prt_cs1('abgi004','abgi004',g_sql,g_str)           
#No.FUN-770033--end--
#No.FNU-770033--start--
   {PREPARE i004_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i004_co CURSOR FOR i004_p1
 
    START REPORT i004_rep TO l_name
 
    FOREACH i004_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i004_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i004_rep
 
    CLOSE i004_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)}
#No.FUN-770033--end--
END FUNCTION
#No.FUN-770033--start--
{REPORT i004_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,   #FUN-680061 VARCHAR(1)
        sr RECORD
           bgd01   LIKE bgd_file.bgd01,
           bgd02   LIKE bgd_file.bgd02,
           bgd03   LIKE bgd_file.bgd03,
           bgd04   LIKE bgd_file.bgd04,
           bgd05   LIKE bgd_file.bgd05,
           bgdacti LIKE bgd_file.bgdacti
        END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bgd01,sr.bgd02,sr.bgd03
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.bgd01
           PRINT COLUMN g_c[31],sr.bgd01 CLIPPED;
 
        ON EVERY ROW
           PRINT COLUMN g_c[32],sr.bgd02 CLIPPED,
                 COLUMN g_c[33],sr.bgd03 CLIPPED,
                 COLUMN g_c[34],cl_numfor(sr.bgd04,34,g_azi04),
                 COLUMN g_c[35],cl_numfor(sr.bgd05,35,g_azi04)
 
        ON LAST ROW
          IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
             PRINT g_dash[1,g_len]
            END IF
          PRINT g_dash[1,g_len]
          LET l_trailer_sw = 'n'
          PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-770033--end--
 
#NO.MOD-590329 MARK
 #NO.MOD-580078
#FUNCTION i004_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680061 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("bgd02,bgd03",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION i004_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680061 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("bgd02,bgd03",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580078 --end
#NO.MOD-590329
