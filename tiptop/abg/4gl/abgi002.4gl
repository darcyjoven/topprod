# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi002.4gl
# Descriptions...: 材料預計漲幅維護作業
# Date & Author..: Julius 02/08/29
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0067 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-510025 05/01/14 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-560095 05/06/29 By ching   remove bp_refresh
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key 可更改
# Modify.........: NO.MOD-590329 05/09/30 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu _r()後筆數不正確
# Modify.........: No.TQC-630053 06/03/07 By Smapmin 複製功能視窗無法顯示中文
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/14 By jamie 1.FUNCTION i002()_q 一開始應清空g_bgb_hd.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0057 06/10/19 By hongmei 將g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/10 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-710054 07/02/05 By rainy 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770033 07/06/26 By destiny 報表改為使用crystal report
# Modify.........: No.TQC-7A0100 07/10/26 By xufeng 進入單身,把單身刪除干凈以后,點擊確定,再按上下筆資料查詢出現報錯信息
# Modify.........: No.TQC-7A0102 07/10/30 By xufeng 單頭切換,單身沒有隨之切換;單身中更改材料類型欄位的值,但是不能保存。
# Modify.........: No.TQC-860021 08/06/10 By Sarah DISPLAY ARRAY段漏了idle,about控制
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.MOD-920153 09/02/16 By Sarah 複製時,應可輸入新版本、年度、月份三個欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bgb_hd        RECORD                       #單頭變數
        bgb01       LIKE bgb_file.bgb01,
        bgb02       LIKE bgb_file.bgb02,
        bgb03       LIKE bgb_file.bgb03,
        bgbuser     LIKE bgb_file.bgbuser,
        bgbgrup     LIKE bgb_file.bgbgrup,
        bgbdate     LIKE bgb_file.bgbdate
        END RECORD,
    g_bgb_hd_t      RECORD                       #單頭變數
        bgb01       LIKE bgb_file.bgb01,
        bgb02       LIKE bgb_file.bgb02,
        bgb03       LIKE bgb_file.bgb03,
        bgbuser     LIKE bgb_file.bgbuser,
        bgbgrup     LIKE bgb_file.bgbgrup,
        bgbdate     LIKE bgb_file.bgbdate
        END RECORD,
    g_bgb_hd_o      RECORD                       #單頭變數
        bgb01       LIKE bgb_file.bgb01,
        bgb02       LIKE bgb_file.bgb02,
        bgb03       LIKE bgb_file.bgb03,
        bgbuser     LIKE bgb_file.bgbuser,
        bgbgrup     LIKE bgb_file.bgbgrup,
        bgbdate     LIKE bgb_file.bgbdate
        END RECORD,
    l_bgb_hd        RECORD                       #單頭變數
        bgb01       LIKE bgb_file.bgb01,
        bgb02       LIKE bgb_file.bgb02,
        bgb03       LIKE bgb_file.bgb03,
        bgbuser     LIKE bgb_file.bgbuser,
        bgbgrup     LIKE bgb_file.bgbgrup,
        bgbdate     LIKE bgb_file.bgbdate
        END RECORD,
    g_bgb           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
        bgb04       LIKE bgb_file.bgb04,
        bgb05       LIKE bgb_file.bgb05,
        bgbacti     LIKE bgb_file.bgbacti
        END RECORD,
    g_bgb_t         RECORD                       #程式變數(舊值)
        bgb04       LIKE bgb_file.bgb04,
        bgb05       LIKE bgb_file.bgb05,
        bgbacti     LIKE bgb_file.bgbacti
        END RECORD,
    g_wc            string,                      #WHERE CONDITION  #No.FUN-580092 HCN
    g_sql           string,                      #No.FUN-580092 HCN
    g_sql_tmp       STRING,                      #No.TQC-710054
    g_rec_b         LIKE type_file.num5,         #單身筆數 #No.FUN-680061 SMALLINT
    g_mody          LIKE type_file.chr1,         #單身的鍵值是否改變  #FUN-680061 VARCHAR(01)
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT  #No.FUN-680061 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680061 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680061 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5      #No.FUN-680061 SMALLINT #No.FUN-6A0057 g_no_ask 
DEFINE   g_str          STRING                    #No.FUN-770033
 
#主程式開始
MAIN
DEFINE
#       l_time    LIKE type_file.chr8     #No.FUN-6A0056
    p_row,p_col LIKE type_file.num5    #No.FUN-680061 smallint
 
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABG")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1)             #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
    INITIALIZE g_bgb_hd.* to NULL
    INITIALIZE g_bgb_hd_t.* to NULL
 
    LET p_row = 3 LET p_col = 29
    OPEN WINDOW i002_w AT p_row,p_col
        WITH FORM "abg/42f/abgi002" ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
    CALL i002_menu()
    CLOSE WINDOW i002_w                          #結束畫面
      CALL  cl_used(g_prog,g_time,2)             #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i002_curs()
    CLEAR FORM #清除畫面
    CALL g_bgb.clear()
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033 
   INITIALIZE g_bgb_hd.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bgb01, bgb02, bgb03, # 螢幕上取條件
                      bgb04, bgb05, bgbacti
         FROM bgb01, bgb02, bgb03,
              s_bgb[1].bgb04, s_bgb[1].bgb05, s_bgb[1].bgbacti
        ON ACTION CONTROLP
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            CASE
                WHEN INFIELD(bgb04)
                #   CALL q_azf(10, 3, g_bgb[l_ac].bgb04, '8')
                #       RETURNING g_bgb[l_ac].bgb04
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.arg1 = '8'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_bgb[1].bgb04
            END CASE
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN
        CALL i002_show()
        RETURN
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND bgbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND bgbgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND bgbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bgbuser', 'bgbgrup')
    #End:FUN-980030
 
 
    LET g_sql = "SELECT UNIQUE bgb01, bgb02, bgb03",
                "  FROM bgb_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY bgb01"
    PREPARE i002_prepare FROM g_sql
    DECLARE i002_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i002_prepare
  
   #LET g_sql = "SELECT UNIQUE bgb01, bgb02, bgb03",     #TQC-710054
   LET g_sql_tmp = "SELECT UNIQUE bgb01, bgb02, bgb03",  #TQC-710054
               "  FROM bgb_file ",
               " WHERE ", g_wc CLIPPED,
               " INTO TEMP x "
   DROP TABLE x
   #PREPARE i002_pre_x FROM g_sql      #TQC-710054
   PREPARE i002_pre_x FROM g_sql_tmp   #TQC-710054
   EXECUTE i002_pre_x
 
   LET g_sql = "SELECT COUNT(*) FROM x"
 
   PREPARE i002_precnt FROM g_sql
   DECLARE i002_count CURSOR FOR i002_precnt
 
END FUNCTION
 
#中文的MENU
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
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i002_copy()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i002_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i002_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgb),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bgb_hd.bgb01 IS NOT NULL THEN
                LET g_doc.column1 = "bgb01"
                LET g_doc.column2 = "bgb02"
                LET g_doc.column3 = "bgb03"
                LET g_doc.value1 = g_bgb_hd.bgb01
                LET g_doc.value2 = g_bgb_hd.bgb02
                LET g_doc.value3 = g_bgb_hd.bgb03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i002_a()
    IF s_shut(0) THEN  RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_bgb.clear()
    INITIALIZE g_bgb_hd TO NULL                  #單頭初始清空
    INITIALIZE g_bgb_hd_o TO NULL                #單頭舊值清空
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bgb_hd.bgbuser=g_user
        LET g_bgb_hd.bgbgrup=g_grup
        LET g_bgb_hd.bgbdate=g_today
        CALL i002_i("a")                         #輸入單頭
        IF INT_FLAG THEN                         #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
     IF cl_null(g_bgb_hd.bgb02)  OR
        cl_null(g_bgb_hd.bgb03)  THEN
        CONTINUE WHILE
     END IF
        CALL g_bgb.clear()
        LET g_rec_b=0
 
        CALL i002_b()                            #輸入單身
        LET g_bgb_hd_t.* = g_bgb_hd.*            #保留舊值
        LET g_bgb_hd_o.* = g_bgb_hd.*            #保留舊值
        LET g_wc="     bgb01='",g_bgb_hd.bgb01,"' ",
                 " AND bgb02='",g_bgb_hd.bgb02,"' ",
                 " AND bgb03='",g_bgb_hd.bgb03,"' "
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理單頭欄位(bgb01, bgb02, bgb03)INPUT
FUNCTION i002_i(p_cmd)
DEFINE
    p_cmd   LIKE type_file.chr1,     #a:輸入 u:更改 #No.FUN-680061 VARCHAR(1)
    l_n     LIKE type_file.num5      #No.FUN-680061 SMALLINT
 
    LET l_n = 0
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033  
 
    DISPLAY g_bgb_hd.bgb01, g_bgb_hd.bgb02, g_bgb_hd.bgb03
         TO bgb01, bgb02, bgb03
 
    INPUT g_bgb_hd.bgb01, g_bgb_hd.bgb02, g_bgb_hd.bgb03
     FROM bgb01, bgb02, bgb03
 
        AFTER FIELD bgb01
            IF NOT cl_null(g_bgb_hd.bgb01) AND g_bgz.bgz02 = 'N' THEN
               CALL cl_err('', 'abg-001', 0)
               LET g_bgb_hd.bgb01 = ' '
               DISPLAY BY NAME g_bgb_hd.bgb01
               NEXT FIELD bgb01
            END IF
            IF cl_null(g_bgb_hd.bgb01) AND g_bgz.bgz02 = 'Y' THEN
               NEXT FIELD bgb01
            END IF
            IF cl_null(g_bgb_hd.bgb01) THEN
               LET g_bgb_hd.bgb01 = ' '
               DISPLAY BY NAME g_bgb_hd.bgb01
            END IF
 
        AFTER FIELD bgb02
            IF cl_null(g_bgb_hd.bgb02)
            OR g_bgb_hd.bgb02 < 1 THEN
                CALL cl_err('', 'afa-370', 0)
                NEXT FIELD bgb02
            END IF
 
        AFTER FIELD bgb03
            IF cl_null(g_bgb_hd.bgb03)
            OR g_bgb_hd.bgb03 < 1
            OR g_bgb_hd.bgb03 > 12 THEN
                CALL cl_err('', 'afa-371', 0)
                NEXT FIELD bgb03
            END IF
 
            SELECT COUNT(*)
              INTO l_n
              FROM bgb_file
             WHERE bgb01 = g_bgb_hd.bgb01
               AND bgb02 = g_bgb_hd.bgb02
               AND bgb03 = g_bgb_hd.bgb03
            IF l_n > 0 THEN
                INITIALIZE g_bgb_hd TO NULL
                DISPLAY g_bgb_hd.bgb01, g_bgb_hd.bgb02, g_bgb_hd.bgb03
                     TO bgb01, bgb02, bgb03
                CALL cl_err( g_bgb_hd.bgb01, -239, 0)
                NEXT FIELD bgb01
            END IF
 
        ON ACTION CONTROLF                       #欄位說明
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
 
#Query 查詢
FUNCTION i002_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bgb_hd.* TO NULL             #No.FUN-6A0003
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bgb.clear()
    CALL i002_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i002_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bgb TO NULL
    ELSE
        OPEN i002_count
        FETCH i002_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i002_fetch('F')                     # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i002_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1     #處理方式 #No.FUN-680061 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i002_cs INTO g_bgb_hd.bgb01,
                                             g_bgb_hd.bgb02,
                                             g_bgb_hd.bgb03
        WHEN 'P' FETCH PREVIOUS i002_cs INTO g_bgb_hd.bgb01,
                                             g_bgb_hd.bgb02,
                                             g_bgb_hd.bgb03
        WHEN 'F' FETCH FIRST    i002_cs INTO g_bgb_hd.bgb01,
                                             g_bgb_hd.bgb02,
                                             g_bgb_hd.bgb03
        WHEN 'L' FETCH LAST     i002_cs INTO g_bgb_hd.bgb01,
                                             g_bgb_hd.bgb02,
                                             g_bgb_hd.bgb03
        WHEN '/'
         IF (NOT mi_no_ask) THEN            #No.FUN-6A0057 g_no_ask    
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
         FETCH ABSOLUTE g_jump i002_cs INTO g_bgb_hd.bgb01,
                                            g_bgb_hd.bgb02,
                                            g_bgb_hd.bgb03
         LET mi_no_ask = FALSE              #No.FUN-6A0057 g_no_ask  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgb_hd.bgb01, SQLCA.sqlcode, 0)
        INITIALIZE g_bgb_hd.* TO NULL  #TQC-6B0105
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
    SELECT UNIQUE bgb01, bgb02, bgb03
      FROM bgb_file
     WHERE bgb01 = g_bgb_hd.bgb01
       AND bgb02 = g_bgb_hd.bgb02
       AND bgb03 = g_bgb_hd.bgb03
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bgb_hd.bgb01, SQLCA.sqlcode, 0)  #FUN-660105
        CALL cl_err3("sel","bgb_file",g_bgb_hd.bgb01,g_bgb_hd.bgb02,SQLCA.sqlcode,"","",1) #FUN-660105 
        INITIALIZE g_bgb TO NULL
        RETURN
    END IF
    LET g_data_owner = g_bgb_hd.bgbuser   #FUN-4C0067
    LET g_data_group = g_bgb_hd.bgbgrup   #FUN-4C0067
    CALL i002_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i002_show()
    LET g_bgb_hd.* = g_bgb_hd.*                  #保存單頭舊值
    DISPLAY BY NAME g_bgb_hd.bgb01,              #顯示單頭值
                    g_bgb_hd.bgb02,
                    g_bgb_hd.bgb03
    CALL i002_b_fill(g_wc) #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i002_r()
DEFINE
    l_chr LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_bgb_hd.bgb01 IS NULL THEN
        CALL cl_err('', -400, 0)
        RETURN
    END IF
    BEGIN WORK
    CALL i002_show()
    IF cl_delh(0,0) THEN                         #詢問是否取消資料
        INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bgb01"            #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bgb02"            #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bgb03"            #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bgb_hd.bgb01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bgb_hd.bgb02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bgb_hd.bgb03      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                      #No.FUN-9B0098 10/02/24
        DELETE FROM bgb_file
         WHERE bgb01 = g_bgb_hd.bgb01
           AND bgb02 = g_bgb_hd.bgb02
           AND bgb03 = g_bgb_hd.bgb03
 
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_bgb_hd.bgb01,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("del","bgb_file",g_bgb_hd.bgb01,g_bgb_hd.bgb02,SQLCA.sqlcode,"","",1) #FUN-660105 
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
            #EXECUTE i002_pre_x                   #TQC-710054
            PREPARE i002_pre_x2 FROM g_sql_tmp    #TQC-710054 add
            EXECUTE i002_pre_x2                   #TQC-710054
            #MOD-5A0004 end
            CALL g_bgb.clear()
            OPEN i002_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i002_cs
               CLOSE i002_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i002_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i002_cs
               CLOSE i002_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i002_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i002_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE          #No.FUN-6A0057 g_no_ask 
               CALL i002_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#處理單身欄位(bgb04, bgb05, bgbacti)輸入
FUNCTION i002_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用   #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否   #No.FUN-680061 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態     #No.FUN-680061 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否     #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否     #No.FUN-680061 SMALLINT
 
    LET g_action_choice = ""
 
    IF g_bgb_hd.bgb01 IS NULL THEN
        RETURN
    END IF
 
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT bgb04, bgb05, bgbacti FROM bgb_file  WHERE bgb01 = ? ",
        "   AND bgb02 = ? AND bgb03 = ? AND bgb04 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_bcl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bgb WITHOUT DEFAULTS FROM s_bgb.*
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
            LET l_lock_sw = 'N'                  #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_bgb_t.* = g_bgb[l_ac].*    #BACKUP
 
#NO.MOD-590329 MARK
 #No.MOD-580078 --start
#                LET g_before_input_done = FALSE
#                CALL i002_set_entry_b(p_cmd)
#                CALL i002_set_no_entry_b(p_cmd)
#                LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329
                OPEN i002_bcl USING g_bgb_hd.bgb01,g_bgb_hd.bgb02,g_bgb_hd.bgb03,g_bgb_t.bgb04
                IF STATUS THEN
                   CALL cl_err("OPEN i002_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_bgb_t.bgb04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   FETCH i002_bcl INTO g_bgb[l_ac].*
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bgb[l_ac].* TO NULL
            LET g_bgb[l_ac].bgb05=0
            LET g_bgb[l_ac].bgbacti = 'Y'
            LET g_bgb_t.* = g_bgb[l_ac].*        #新輸入資料
#NO.MOD-590329 MARK
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i002_set_entry_b(p_cmd)
#            CALL i002_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_bgb[l_ac].bgb05) THEN
                LET g_bgb[l_ac].bgb05 = 0
            END IF
            IF cl_null(g_bgb[l_ac].bgbacti) THEN
                LET g_bgb[l_ac].bgbacti = 'Y'
            END IF
            IF g_bgz.bgz02 = 'N'      #材料預估不做版本控制時
            AND cl_null(g_bgb_hd.bgb01) THEN
                LET g_bgb_hd.bgb01 = " "
            END IF
             INSERT INTO bgb_file(bgb01,bgb02,bgb03,bgb04,bgb05,bgbacti, #No.MOD-470041
                                 bgbuser,bgbgrup,bgbmodu,bgbdate,bgboriu,bgborig)
                 VALUES(g_bgb_hd.bgb01,g_bgb_hd.bgb02,g_bgb_hd.bgb03,
                        g_bgb[l_ac].bgb04,g_bgb[l_ac].bgb05,
                        g_bgb[l_ac].bgbacti,g_user,g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bgb[l_ac].bgb04,SQLCA.sqlcode,0) #FUN-660105
                CALL cl_err3("ins","bgb_file",g_bgb_hd.bgb01,g_bgb[l_ac].bgb04,SQLCA.sqlcode,"","",1) #FUN-660105 
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                SELECT COUNT(*)
                  INTO g_rec_b
                  FROM bgb_file
                 WHERE bgb01 = g_bgb_hd.bgb01
                   AND bgb02 = g_bgb_hd.bgb02
                   AND bgb03 = g_bgb_hd.bgb03
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        AFTER FIELD bgb04
            IF NOT cl_null(g_bgb[l_ac].bgb04) THEN #unique index key 是否重複
                IF g_bgb[l_ac].bgb04 != g_bgb_t.bgb04
                OR cl_null(g_bgb_t.bgb04) THEN
 
                    SELECT COUNT(*)
                      INTO l_n
                      FROM bgb_file
                     WHERE bgb01 = g_bgb_hd.bgb01
                       AND bgb02 = g_bgb_hd.bgb02
                       AND bgb03 = g_bgb_hd.bgb03
                       AND bgb04=g_bgb[l_ac].bgb04
                    IF l_n>0 THEN
                        CALL cl_err(g_bgb[l_ac].bgb04, -239, 0)
                        NEXT FIELD bgb04
                    END IF
 
                    SELECT COUNT(*) INTO l_n
                      FROM azf_file
                     WHERE azf01 = g_bgb[l_ac].bgb04
                       AND azf02 = '8'
                    IF l_n <= 0 THEN
                        CALL cl_err('', 'abg-002', 0)
                        NEXT FIELD bgb04
                    END IF
                END IF
            END IF
 
     #---no.8487 可輸入正負數
     #   AFTER FIELD bgb05
     #       IF g_bgb[l_ac].bgb05 < 0 THEN
     #           NEXT FIELD bgb05
     #       END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bgb_t.bgb04) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bgb_file             #刪除該筆單身資料
                 WHERE bgb01 = g_bgb_hd.bgb01
                   AND bgb02 = g_bgb_hd.bgb02
                   AND bgb03 = g_bgb_hd.bgb03
                   AND bgb04 = g_bgb_t.bgb04
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bgb_t.bgb04,SQLCA.sqlcode,0) #FUN-660105
                    CALL cl_err3("del","bgb_file",g_bgb_hd.bgb01,g_bgb_t.bgb04,SQLCA.sqlcode,"","",1) #FUN-660105 
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bgb[l_ac].* = g_bgb_t.*
               CLOSE i002_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bgb[l_ac].bgb04,-263,1)
               LET g_bgb[l_ac].* = g_bgb_t.*
            ELSE
                        UPDATE bgb_file SET bgb04 = g_bgb[l_ac].bgb04,
                                            bgb05 = g_bgb[l_ac].bgb05,
                                            bgbacti = g_bgb[l_ac].bgbacti
                         WHERE CURRENT OF i002_bcl
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_bgb[l_ac].bgb05, SQLCA.sqlcode, 0) #FUN-660105
                    CALL cl_err3("upd","bgb_file",g_bgb_hd.bgb01,g_bgb[l_ac].bgb04,SQLCA.sqlcode,"","",1) #FUN-660105 
                   LET g_bgb[l_ac].* = g_bgb_t.*
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
                  LET g_bgb[l_ac].* = g_bgb_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i002_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE i002_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i002_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(bgb04) AND l_ac > 1 THEN
                LET g_bgb[l_ac].* = g_bgb[l_ac-1].*
                NEXT FIELD bgb04
            END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bgb04)
                #   CALL q_azf(10, 3, g_bgb[l_ac].bgb04, '8')
                #       RETURNING g_bgb[l_ac].bgb04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.default1 = g_bgb[l_ac].bgb04
                    LET g_qryparam.arg1 = '8'
                    CALL cl_create_qry() RETURNING g_bgb[l_ac].bgb04
#                    CALL FGL_DIALOG_SETBUFFER( g_bgb[l_ac].bgb04)
                    DISPLAY BY NAME g_bgb[l_ac].bgb04    #No.TQC-7A0102 add
                    NEXT FIELD bgb04
            END CASE
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
         CALL cl_set_head_visible("","AUTO")  #No.FUN-6B0033
#No.FUN-6B0033 --END 
 
    END INPUT
 
 
    CLOSE i002_bcl
    COMMIT WORK
    CALL i002_delall()
END FUNCTION
 
FUNCTION i002_delall()
    SELECT COUNT(*)
      INTO g_cnt
      FROM bgb_file
     WHERE bgb01 = g_bgb_hd.bgb01
       AND bgb02 = g_bgb_hd.bgb02
       ANd bgb03 = g_bgb_hd.bgb03
    IF g_cnt = 0 THEN                      # 未輸入單身資料, 是否取消單頭資料
        CALL cl_getmsg('9044',g_lang) RETURNING g_msg
        ERROR g_msg CLIPPED
        DELETE FROM bgb_file
         WHERE bgb01 = g_bgb_hd.bgb01
           AND bgb02 = g_bgb_hd.bgb02
           ANd bgb03 = g_bgb_hd.bgb03
       #No.TQC-7A0100   ----begin---------
        DROP TABLE x
        PREPARE i002_pre_x3 FROM g_sql_tmp   
        EXECUTE i002_pre_x3                 
        CALL g_bgb.clear()
        OPEN i002_count
        FETCH i002_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i002_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i002_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE        
           CALL i002_fetch('/')
        END IF
       #No.TQC-7A0100   -----end----------
    END IF
END FUNCTION
 
#單身重查
FUNCTION i002_b_askkey()
DEFINE
    l_wc2   LIKE type_file.chr1000 #No.FUN-680061 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON bgb04, bgb05, bgbacti
         FROM s_bgb[1].bgb04, s_bgb[1].bgb05, s_bgb[1].bgbacti
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
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i002_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i002_b_fill(p_wc2)                      #BODY FILL UP
DEFINE
    p_wc2    LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(200)
 
    LET g_sql =
        "SELECT bgb04, bgb05, bgbacti, '' ",
        "  FROM bgb_file",
        " WHERE bgb01 ='", g_bgb_hd.bgb01, "' ",
        "   AND bgb02 ='", g_bgb_hd.bgb02, "' ",
        "   AND bgb03 ='", g_bgb_hd.bgb03, "' ",
	"   AND ", p_wc2 CLIPPED,
        " ORDER BY bgb04"
    PREPARE i002_pb
       FROM g_sql
    DECLARE i002_bcs                             #SCROLL CURSOR
     CURSOR FOR i002_pb
 
    CALL g_bgb.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH i002_bcs INTO g_bgb[g_cnt].*         #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bgb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
#單身顯示
FUNCTION i002_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bgb TO s_bgb.* ATTRIBUTE(COUNT=g_rec_b)
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
         CALL i002_fetch('F')
         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DISPLAY  ######add for refresh bug
 
      ON ACTION previous
         CALL i002_fetch('P')
         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DISPLAY  ######add for refresh bug
 
      ON ACTION jump
         CALL i002_fetch('/')
         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DISPLAY  ######add for refresh bug
 
      ON ACTION next
         CALL i002_fetch('N')
         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DISPLAY  ######add for refresh bug
 
      ON ACTION last
         CALL i002_fetch('L')
         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DISPLAY  ######add for refresh bug
 
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds   #TQC-860021
         CALL cl_on_idle()     #TQC-860021
         CONTINUE DISPLAY      #TQC-860021
 
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
 
      ON ACTION help
         LET g_action_choice="help"
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
 
 
#整批複製
FUNCTION i002_copy()
DEFINE
    old_ver         LIKE bgb_file.bgb01,    #原版本 #FUN-680061 VARCHAR(10)
    oyy             LIKE bgb_file.bgb02,    #原年度 #FUN-680061 VARCHAR(04)
    om              LIKE bgb_file.bgb03,    #原月份 #FUN-680061 VARCHAR(02)
    new_ver         LIKE bgb_file.bgb01,    #新版本 #FUN-680061 VARCHAR(10)
    nyy             LIKE bgb_file.bgb02,    #新年度 #FUN-680061 VARCHAR(04)
    nm              LIKE bgb_file.bgb03,    #新月份 #MOD-920153 add
    l_i             LIKE type_file.num10,   #拷貝筆數 #FUN-680061 INTEGER
    l_bgb           RECORD LIKE bgb_file.*  #複製用buffer
 
    OPEN WINDOW i002_c_w AT 12,24 WITH FORM "abg/42f/abgi002_c"
        ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_locale("abgi002_c")   #TQC-630053
 
    IF STATUS THEN
        CALL cl_err('open window i002_c_w:',STATUS,0)
        RETURN
    END IF
 
  WHILE TRUE
    LET old_ver = g_bgb_hd.bgb01
    LET oyy = g_bgb_hd.bgb02
    LET om = g_bgb_hd.bgb03
    LET new_ver = NULL
    LET nyy = NULL
    LET nm = NULL   #MOD-920153 add
 
    INPUT BY NAME
        old_ver, oyy, om, new_ver, nyy, nm   #MOD-920153 add nm
        WITHOUT DEFAULTS
 
        AFTER FIELD old_ver
            IF old_ver IS NULL THEN
                LET old_ver = ' '
            END IF
        AFTER FIELD oyy
            IF cl_null(oyy) THEN
                NEXT FIELD oyy
            END IF
        AFTER FIELD om
            IF cl_null(om) THEN
                NEXT FIELD om
            END IF
            IF om > 12 OR om < 1 THEN
                NEXT FIELD om
            END IF
        AFTER FIELD new_ver
            IF NOT cl_null(new_ver) AND g_bgz.bgz02 = 'N' THEN
               CALL cl_err('', 'abg-001', 0)
               LET new_ver = ' '
               DISPLAY BY NAME new_ver
               NEXT FIELD new_ver
            END IF
            IF cl_null(new_ver) AND g_bgz.bgz02 = 'Y' THEN
               NEXT FIELD new_ver
            END IF
            IF cl_null(new_ver) THEN
               LET new_ver = ' '
               DISPLAY BY NAME new_ver
            END IF
        AFTER FIELD nyy
            IF cl_null(nyy) THEN
                NEXT FIELD nyy
            END IF
       #str MOD-920153 add
        AFTER FIELD nm
            IF cl_null(nm) THEN
                NEXT FIELD nm
            END IF
            IF nm > 12 OR nm < 1 THEN
                NEXT FIELD nm
            END IF
       #end MOD-920153 add
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
        CLOSE WINDOW i002_c_w
        RETURN
    END IF
    IF new_ver IS NULL OR nyy IS NULL THEN
       CONTINUE WHILE
    END IF
    EXIT WHILE
 END WHILE
 
    CLOSE WINDOW i002_c_w
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
 
    BEGIN WORK
    LET g_success='Y'
    DECLARE i002_c CURSOR FOR
        SELECT *
          FROM bgb_file
         WHERE bgb01 = old_ver
           AND bgb02 = oyy
           AND bgb03 = om
    LET l_i = 0
    FOREACH i002_c INTO l_bgb.*
        LET l_i = l_i+1
        LET l_bgb.bgb01 = new_ver
        LET l_bgb.bgb02 = nyy
        LET l_bgb.bgb03 = nm   #MOD-920153 add
        LET l_bgb.bgboriu = g_user      #No.FUN-980030 10/01/04
        LET l_bgb.bgborig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO bgb_file VALUES(l_bgb.*)
        IF STATUS THEN
#           CALL cl_err('ins bgb:',STATUS,1) #FUN-660105
             CALL cl_err3("ins","bgb_file",l_bgb.bgb01,l_bgb.bgb02,STATUS,"","ins bgb:",1) #FUN-660105 
            LET g_success='N'
        END IF
    END FOREACH
    IF g_success='Y' THEN
        COMMIT WORK
        #FUN-C30027---begin
        LET g_bgb_hd.bgb01 = new_ver
        LET g_bgb_hd.bgb02 = nyy
        LET g_bgb_hd.bgb03 = nm
        LET g_wc = '1=1'
        CALL i002_show()          
        #FUN-C30027---end   
        MESSAGE l_i, ' rows copied!'
    ELSE
        ROLLBACK WORK
        MESSAGE 'rollback work!'
    END IF
END FUNCTION
 
#製作簡表
FUNCTION i002_out()
DEFINE
    l_i LIKE type_file.num5,          #No.FUN-680061 SMALLINT
    sr RECORD
        bgb01       LIKE bgb_file.bgb01,
        bgb02       LIKE bgb_file.bgb02,
        bgb03       LIKE bgb_file.bgb03,
        bgb04       LIKE bgb_file.bgb04,
        bgb05       LIKE bgb_file.bgb05,
        bgbacti     LIKE bgb_file.bgbacti
        END RECORD,
    l_name LIKE type_file.chr20,  #FUN-680061 l_name VARCHAR(20)
    l_za05 LIKE type_file.chr1000 #FUN-680061 l_za05 VARCHAR(40)
 
    IF cl_null(g_wc) THEN
	CALL cl_err('', 9057, 0)
	RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('abgi002') RETURNING l_name
    SELECT zo02
      INTO g_company
      FROM zo_file
     WHERE zo01 = g_lang
    LET g_sql="SELECT bgb01, bgb02, bgb03, bgb04, bgb05, bgbacti",
              "  FROM bgb_file",
              " WHERE 1=1 AND ", g_wc CLIPPED
#No.FUN-770033--start--                                                                                                             
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-770033
    IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(g_wc,'bgb01,bgb02,bgb03,bgb04,bgb05,bgbacti')                                                                              
       RETURNING g_wc                                                                                                             
       LET g_str = g_wc                                                                                                           
    END IF
    LET g_str = g_str                                                                                                  
    CALL cl_prt_cs1('abgi002','abgi002',g_sql,g_str)    
   {PREPARE i002_p1 FROM g_sql                   # RUNTIME 編譯
    DECLARE i002_co CURSOR FOR i002_p1
 
    START REPORT i002_rep TO l_name
 
    FOREACH i002_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i002_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i002_rep
 
    CLOSE i002_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)}
#No.FUN-770033--end 
END FUNCTION
 
#FUN-770033--begin 
{REPORT i002_rep(sr)
DEFINE
    l_trailer_sw LIKE type_file.chr1,   #FUN-680061  VARCHAR(1)
    l_i LIKE type_file.num5,            #No.FUN-680061 SMALLINT
    sr RECORD
       bgb01      LIKE bgb_file.bgb01,
       bgb02      LIKE bgb_file.bgb02,
       bgb03      LIKE bgb_file.bgb03,
       bgb04      LIKE bgb_file.bgb04,
       bgb05      LIKE bgb_file.bgb05,
       bgbacti    LIKE bgb_file.bgbacti
       END RECORD
 
    OUTPUT
        TOP MARGIN g_top_margin
        LEFT MARGIN g_left_margin
        BOTTOM MARGIN g_bottom_margin
        PAGE LENGTH g_page_line
 
    ORDER BY sr.bgb01,sr.bgb02,sr.bgb03
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
 
        BEFORE GROUP OF sr.bgb03
            PRINT COLUMN g_c[31], sr.bgb01,
                  COLUMN g_c[32], sr.bgb02,
                  COLUMN g_c[33], sr.bgb03;
 
        ON EVERY ROW
            PRINT COLUMN g_c[34], sr.bgb04,
                  COLUMN g_c[35], sr.bgb05,
                  COLUMN g_c[36], sr.bgbacti
        AFTER GROUP OF sr.bgb03
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#FUN-770033--end
 
#NO.MOD-590329 MARK
 #NO.MOD-580078
#FUNCTION i002_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680061
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("bgb04",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION i002_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680061
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("bgb04",FALSE)
#   END IF
#
#END FUNCTION
 #No.MOD-580078 --end
#NO.MOD-590329
 
