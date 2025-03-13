# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: amsi610.4gl
# Descriptions...: 每日資源維護作業
# Date & Author..: 00/05/21 By Kammy
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0014 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-510036 05/01/18 By pengu 報表轉XML
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-5C0005 06/01/02 By kevin 結束位置調整
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-690009 06/08/31 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0150 06/10/27 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/17 By sherry 單身起始日期開窗為耗用明細查詢
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770012 07/07/06 By johnray 修改報表功能，使用CR打印報表
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0461 10/02/23 By sabrina 將rpf05做隱藏
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_rqa01         LIKE rqa_file.rqa01,   #資源代號  (假單頭)
    g_rqa02         LIKE rqa_file.rqa02,   #版本      (假單頭)
    g_rqa01_t       LIKE rqa_file.rqa01,   #資源代號  (舊值)
    g_rqa02_t       LIKE rqa_file.rqa02,   #版本      (舊值)
    g_rqa           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        rqa03       LIKE rqa_file.rqa03,   #
        rqa04       LIKE rqa_file.rqa04,   #
        rqa05       LIKE rqa_file.rqa05,   #
        rqa06       LIKE rqa_file.rqa06,   #
        rqa07       LIKE rqa_file.rqa07    #
                    END RECORD,
    g_rqa_t         RECORD                 #程式變數 (舊值)
        rqa03       LIKE rqa_file.rqa03,   #
        rqa04       LIKE rqa_file.rqa04,   #
        rqa05       LIKE rqa_file.rqa05,   #
        rqa06       LIKE rqa_file.rqa06,   #
        rqa07       LIKE rqa_file.rqa07    #
                    END RECORD,
    l_cmd           LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(400)
    g_wc,g_wc2,g_sql     STRING, #TQC-630166
    g_rec_b          LIKE type_file.num5,   #單身筆數              #NO.FUN-680101 SMALLINT
    l_ac             LIKE type_file.num5,   #目前處理的ARRAY CNT   #NO.FUN-680101 SMALLINT
    l_sl             LIKE type_file.num5,   #目前處理的SCREEN LINE #NO.FUN-680101 SMALLINT
    l_nn,l_nn3,l_nn2 LIKE type_file.num5    #NO.FUN-680101 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING     #No.TQC-720019
DEFINE g_cnt        LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose #NO.FUN-680101 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE g_curs_index LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE g_jump       LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5     #NO.FUN-680101 SMALLINT
#No.FUN-770012 -- begin --
DEFINE g_sql1     STRING
DEFINE l_table    STRING
DEFINE g_str      STRING
#No.FUN-770012 -- end --
 
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5    #開窗的位置     #NO.FUN-680101 SMALLINT
#       l_time    LIKE type_file.chr8              #No.FUN-6A0081
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
#No.FUN-770012 -- begin --
   LET g_sql1 = "rqa01.rqa_file.rqa01,",
               "rqa02.rqa_file.rqa02,",
               "rqa03.rqa_file.rqa03,",
               "rqa04.rqa_file.rqa04,",
               "rqa05.rqa_file.rqa05,",
               "rqa06.rqa_file.rqa06,",
               "rqa07.rqa_file.rqa07"
   LET l_table = cl_prt_temptable('amsi610',g_sql1) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql1
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-770012 -- end --
    LET p_row = ARG_VAL(1)                 #取得螢幕位置
    LET p_col = ARG_VAL(2)
    LET g_rqa01 = NULL                     #清除鍵值
    LET g_rqa01_t = NULL
    LET g_rqa02 = NULL                     #清除鍵值
    LET g_rqa02_t = NULL
    LET p_row = 2 LET p_col = 20
    OPEN WINDOW i610_w AT p_row,p_col      #顯示畫面
        WITH FORM "ams/42f/amsi610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("rpf05",FALSE)   #MOD-9C0461 add
 
    CALL i610_menu()
    CLOSE WINDOW i610_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
#QBE 查詢資料
FUNCTION i610_cs()
    CLEAR FORM                             #清除畫面
    CALL g_rqa.clear()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_rqa01 TO NULL    #No.FUN-750051
   INITIALIZE g_rqa02 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON rqa01,rqa02,rqa03,rqa04,rqa05,rqa06,rqa07    #螢幕上取條件
         FROM rqa01,rqa02,s_rqa[1].rqa03,s_rqa[1].rqa04,s_rqa[1].rqa05,
              s_rqa[1].rqa06,s_rqa[1].rqa07
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         IF INFIELD(rqa01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_rpf"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rqa01
         END IF
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
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rqauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rqagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rqagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rqauser', 'rqagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT UNIQUE rqa01,rqa02 FROM rqa_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY rqa01"
    PREPARE i610_prepare FROM g_sql      #預備一下
    DECLARE i610_b_cs                    #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i610_prepare
 
    DROP TABLE x
#   LET g_sql="SELECT UNIQUE rqa01,rqa02 FROM rqa_file WHERE ",g_wc CLIPPED,      #No.TQC-720019
    LET g_sql_tmp="SELECT UNIQUE rqa01,rqa02 FROM rqa_file WHERE ",g_wc CLIPPED,  #No.TQC-720019
              " INTO TEMP x"
#   PREPARE i610_precount_0 FROM g_sql      #No.TQC-720019
    PREPARE i610_precount_0 FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i610_precount_0
    LET g_sql="SELECT COUNT(*) FROM x" CLIPPED
    PREPARE i610_precount FROM g_sql
    DECLARE i610_count CURSOR FOR i610_precount
END FUNCTION
 
FUNCTION i610_menu()
 
   WHILE TRUE
      CALL i610_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i610_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i610_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i610_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i610_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i610_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i610_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i610_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "query_consumption_detail"
            IF not cl_null(g_rqa01) THEN
               LET l_cmd = "amsq610 '",g_rqa01,"'"," '",g_rqa02,"'" clipped
               CALL cl_cmdrun(l_cmd)
            END IF
#FUN-4B0014
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rqa),'','')
            END IF
##
        #No.FUN-6A0150-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_rqa01 IS NOT NULL THEN
                LET g_doc.column1 = "rqa01"
                LET g_doc.column2 = "rqa02"
                LET g_doc.value1 = g_rqa01
                LET g_doc.value2 = g_rqa02
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0150-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i610_a()
    DEFINE  l_n   LIKE type_file.num5      #NO.FUN-680101 SMALLINT
    IF s_shut(0) THEN RETURN END IF        #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_rqa.clear()
    INITIALIZE g_rqa01 LIKE rqa_file.rqa01
    INITIALIZE g_rqa02 LIKE rqa_file.rqa02
    LET g_rqa01_t = NULL
    LET g_rqa02_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i610_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        SELECT COUNT(*) INTO l_n FROM rqa_file
         WHERE rqa01=g_rqa01 AND rqa02=g_rqa02
        IF l_n > 0 THEN
           CALL i610_b_fill(' 1=1')        #單身
        ELSE
           #單身 ARRAY 乾洗
           LET g_rec_b=0
           CALL i610_b()                   #輸入單身
        END IF
        LET g_rqa01_t = g_rqa01            #保留舊值
        LET g_rqa02_t = g_rqa02            #保留舊值
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i610_u()
    IF s_shut(0) THEN RETURN END IF        #檢查權限
    IF g_chkey = 'N' THEN RETURN END IF
    IF cl_null(g_rqa01) THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rqa01_t = g_rqa01
    LET g_rqa02_t = g_rqa02
    BEGIN WORK
    WHILE TRUE
        CALL i610_i("u")                   #欄位更改
        IF INT_FLAG THEN
            LET g_rqa01=g_rqa01_t
            LET g_rqa02=g_rqa02_t
            DISPLAY g_rqa01,g_rqa02 TO rqa01,rqa02
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            EXIT WHILE
        END IF
       #更改單頭值
        IF g_rqa01 != g_rqa01_t OR  g_rqa02 != g_rqa02_t THEN
           UPDATE rqa_file SET rqa01=g_rqa01,
                               rqa02=g_rqa02  #更新DB
                WHERE rqa01 = g_rqa01_t AND rqa02=g_rqa02_t
            IF SQLCA.sqlcode THEN
      #         CALL cl_err(g_rqa01,SQLCA.sqlcode,0) #No.FUN-660108
                CALL cl_err3("upd","rqa_file",g_rqa01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
                ROLLBACK WORK
                CONTINUE WHILE
            ELSE
                COMMIT WORK
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i610_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1    #NO.FUN-680101 VARCHAR(1)    #a:輸入 u:更改
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
     INPUT g_rqa01,g_rqa02 WITHOUT DEFAULTS FROM rqa01,rqa02
 
     AFTER FIELD rqa01                     #資源代號
            IF NOT cl_null(g_rqa01) THEN
               IF p_cmd = "a" OR              #若輸入或更改且改KEY
                 (p_cmd = "u" AND g_rqa01 != g_rqa01_t) THEN
                  CALL i610_rqa01('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rqa01,g_errno,0)
                     LET g_rqa01 = g_rqa01_t
                     DISPLAY g_rqa01 TO rqa01
                     DISPLAY ''      TO FORMONLY.rpf02
                     NEXT FIELD rqa01
                  END IF
               END IF
            END IF
 
      AFTER FIELD rqa02
            IF cl_null(g_rqa02) THEN LET g_rqa02=' ' END IF
            IF p_cmd = "a" OR      # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_rqa02 != g_rqa02_t) THEN
               SELECT COUNT(*) INTO g_cnt FROM rqa_file
                WHERE rqa01 = g_rqa01 AND rqa02 = g_rqa02
                IF g_cnt > 0 THEN   #資料重複
                   CALL cl_err(g_rqa02,-239,0)
                   LET g_rqa02 = g_rqa02_t
                   DISPLAY  g_rqa02 TO rqa02
                   NEXT FIELD rqa02
                END IF
            END IF
 
      AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF cl_null(g_rqa02) THEN LET g_rqa02=' ' END IF
 
      ON ACTION controlp
         IF INFIELD(rqa01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_rpf"
            LET g_qryparam.default1 = g_rqa01
            CALL cl_create_qry() RETURNING g_rqa01
#            CALL FGL_DIALOG_SETBUFFER( g_rqa01 )
            DISPLAY g_rqa01 TO rqa01
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
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
 
FUNCTION i610_rqa01(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1) 
           l_rpf02   LIKE rpf_file.rpf02,
           l_rpf03   LIKE rpf_file.rpf03,
           l_rpf04   LIKE rpf_file.rpf04,
           l_rpf05   LIKE rpf_file.rpf05,
           l_rpf07   LIKE rpf_file.rpf07,
           l_rpfacti LIKE rpf_file.rpfacti
 
    LET g_errno = ' '
    SELECT rpf02,rpf03,rpf04,rpf05,rpf07,rpfacti
      INTO l_rpf02,l_rpf03,l_rpf04,l_rpf05,l_rpf07,l_rpfacti
      FROM rpf_file
     WHERE rpf01 = g_rqa01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ams-506'
                                   LET l_rpfacti = NULL
         WHEN l_rpfacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY l_rpf02 TO FORMONLY.rpf02
       DISPLAY l_rpf03 TO FORMONLY.rpf03
       DISPLAY l_rpf04 TO FORMONLY.rpf04
       DISPLAY l_rpf05 TO FORMONLY.rpf05
       DISPLAY l_rpf07 TO FORMONLY.rpf07
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i610_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rqa01 TO NULL             #No.FUN-6A0150 
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i610_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i610_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rqa01 TO NULL
    ELSE
        OPEN i610_count
        FETCH i610_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i610_fetch('F')               #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i610_fetch(p_flag)
DEFINE
    p_flag         LIKE type_file.chr1,    #NO.FUN-680101  VARCHAR(1)       #處理方式
    l_abso         LIKE type_file.num10    #NO.FUN-680101  INTEGER       #絕對的筆數
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i610_b_cs INTO g_rqa01,g_rqa02
        WHEN 'P' FETCH PREVIOUS i610_b_cs INTO g_rqa01,g_rqa02
        WHEN 'F' FETCH FIRST    i610_b_cs INTO g_rqa01,g_rqa02
        WHEN 'L' FETCH LAST     i610_b_cs INTO g_rqa01,g_rqa02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i610_b_cs INTO g_rqa01,g_rqa02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                 #有麻煩
        CALL cl_err(g_rqa01,SQLCA.sqlcode,0)
        INITIALIZE g_rqa01 TO NULL  #TQC-6B0105
        INITIALIZE g_rqa02 TO NULL  #TQC-6B0105
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
    CALL i610_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i610_show()
    DISPLAY g_rqa01,g_rqa02 TO rqa01,rqa02
    CALL i610_rqa01('d')
    CALL i610_b_fill(' 1=1')  #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i610_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_rqa01) THEN
       CALL cl_err("",-400,0)                      #No.FUN-6A0150
       RETURN 
    END IF
    IF cl_delh(0,0) THEN                           #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "rqa01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "rqa02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_rqa01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_rqa02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                        #No.FUN-9B0098 10/02/24
        DELETE FROM rqa_file WHERE rqa01 = g_rqa01
                               AND rqa02 = g_rqa02
        IF SQLCA.sqlcode THEN
   #        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.FUN-660108
            CALL cl_err3("del","rqa_file",g_rqa01,g_rqa02,SQLCA.sqlcode,"","BODY DELETE:",1)   #No.FUN-660108
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i610_precount_0                  #No.TQC-720019
            PREPARE i610_precount_02 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i610_precount_02                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_rqa.clear()
            LET g_rqa01 = NULL
            OPEN i610_count
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i610_b_cs
               CLOSE i610_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH i610_count INTO g_row_count
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i610_b_cs
               CLOSE i610_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i610_b_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i610_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i610_fetch('/')
            END IF
 
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION i610_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #NO.FUN-680101  SMALLINT              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,    #NO.FUN-680101  SMALLINT              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,    #NO.FUN-680101  VARCHAR(1)               #單身鎖住否
    p_cmd           LIKE type_file.chr1,    #NO.FUN-680101  VARCHAR(1)               #處理狀態
    l_allow_insert  LIKE type_file.num5,    #NO.FUN-680101  SMALLINT              #可新增否
    l_allow_delete  LIKE type_file.num5     #NO.FUN-680101  SMALLINT              #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_rqa01) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT rqa03,rqa04,rqa05,rqa06,rqa07 FROM rqa_file ",
                       "  WHERE rqa01=? ",
                       "    AND rqa02=? ",
                       "    AND rqa03=? ",
                       "    AND rqa04=? ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i610_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_rqa WITHOUT DEFAULTS FROM s_rqa.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac  TO FORMONLY.cn3
          # LET g_rqa_t.* = g_rqa[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
          BEGIN WORK
          IF g_rec_b>=l_ac THEN
           # IF g_rqa_t.rqa03 IS NOT NULL AND
           #    g_rqa_t.rqa04 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_rqa_t.* = g_rqa[l_ac].*  #BACKUP
                OPEN i610_bcl USING g_rqa01,g_rqa02,g_rqa_t.rqa03,g_rqa_t.rqa04
                IF STATUS THEN
                   CALL cl_err("OPEN i610_bcl:", STATUS, 1)
                   CLOSE i610_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i610_bcl INTO g_rqa[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_rqa_t.rqa03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_rqa.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
            IF g_rqa[l_ac].rqa03 IS NULL OR
               g_rqa[l_ac].rqa04 IS NULL THEN  #重要欄位空白,無效
                INITIALIZE g_rqa[l_ac].* TO NULL
            END IF
             INSERT INTO rqa_file (rqa01,rqa02,rqa03,rqa04,rqa05,rqa06,rqa07,rqa08)  #No.MOD-470041
                 VALUES(g_rqa01,g_rqa02,g_rqa[l_ac].rqa03,g_rqa[l_ac].rqa04,
                        g_rqa[l_ac].rqa05,g_rqa[l_ac].rqa06,g_rqa[l_ac].rqa07,'')
            IF SQLCA.sqlcode THEN
     #          CALL cl_err(g_rqa[l_ac].rqa03,SQLCA.sqlcode,0) #No.FUN-660108
                CALL cl_err3("ins","rqa_file",g_rqa01,g_rqa02,SQLCA.sqlcode,"","",1)   #No.FUN-660108
                CANCEL INSERT
                ROLLBACK WORK
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rqa[l_ac].* TO NULL      #900423
            LET g_rqa_t.* = g_rqa[l_ac].*         #新輸入資料
            LET g_rqa[l_ac].rqa06 = 0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rqa03
 
        AFTER FIELD rqa04  #截止日期
            IF NOT cl_null(g_rqa[l_ac].rqa04) THEN
               IF p_cmd = 'a' OR ( p_cmd = 'u' AND
                    (g_rqa[l_ac].rqa03 != g_rqa_t.rqa03 OR
	             g_rqa[l_ac].rqa04 != g_rqa_t.rqa04)) THEN
                  IF g_rqa[l_ac].rqa04 < g_rqa[l_ac].rqa03 THEN
                     CALL cl_err('','aap-100',0)
                     NEXT FIELD rqa04
                  END IF
                  SELECT COUNT(*) INTO l_n FROM rqa_file
                   WHERE rqa01 = g_rqa01
                     AND rqa02 = g_rqa02
                     AND rqa03 = g_rqa[l_ac].rqa03
                     AND rqa04 = g_rqa[l_ac].rqa04
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_rqa[l_ac].rqa03 = g_rqa_t.rqa03
                     LET g_rqa[l_ac].rqa04 = g_rqa_t.rqa04
                     DISPLAY g_rqa[l_ac].rqa03 TO s_rqa[l_sl].rqa03
                     DISPLAY g_rqa[l_ac].rqa04 TO s_rqa[l_sl].rqa04
                     NEXT FIELD rqa04
                  END IF
               END IF
            END IF
 
        AFTER FIELD rqa05
            IF cl_null(g_rqa[l_ac].rqa05) THEN
               IF g_rqa[l_ac].rqa05 < 0 THEN
                  LET g_rqa[l_ac].rqa05 = g_rqa_t.rqa05
                  NEXT FIELD rqa05
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_rqa_t.rqa03 IS NOT NULL AND
               g_rqa_t.rqa04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rqa_file
                    WHERE rqa01 = g_rqa01 AND
                          rqa02 = g_rqa02 AND
                          rqa03 = g_rqa_t.rqa03 AND
                          rqa04 = g_rqa_t.rqa04
                IF SQLCA.sqlcode THEN
      #             CALL cl_err(g_rqa_t.rqa03,SQLCA.sqlcode,0) #No.FUN-660108
                    CALL cl_err3("del","rqa_file",g_rqa01,g_rqa02,SQLCA.sqlcode,"","",1)   #No.FUN-660108
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rqa[l_ac].* = g_rqa_t.*
               CLOSE i610_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rqa[l_ac].rqa03,-263,1)
               LET g_rqa[l_ac].* = g_rqa_t.*
            ELSE
               IF g_rqa[l_ac].rqa03 IS NULL OR
                  g_rqa[l_ac].rqa04 IS NULL THEN  #重要欄位空白,無效
                   INITIALIZE g_rqa[l_ac].* TO NULL
               END IF
               UPDATE rqa_file SET
                      rqa03=g_rqa[l_ac].rqa03,
                      rqa04=g_rqa[l_ac].rqa04,
                      rqa05=g_rqa[l_ac].rqa05,
                      rqa06=g_rqa[l_ac].rqa06,
                      rqa07=g_rqa[l_ac].rqa07
               WHERE rqa01=g_rqa01
                 AND rqa02=g_rqa02
                 AND rqa03=g_rqa_t.rqa03
                 AND rqa04=g_rqa_t.rqa04
               IF SQLCA.sqlcode THEN
         #         CALL cl_err(g_rqa[l_ac].rqa03,SQLCA.sqlcode,0) #No.FUN-660108
                   CALL cl_err3("upd","rqa_file",g_rqa01_t,g_rqa02_t,SQLCA.sqlcode,"","",1)   #No.FUN-660108
                   LET g_rqa[l_ac].* = g_rqa_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_rqa[l_ac].* = g_rqa_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_rqa.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i610_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE i610_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rqa03) AND l_ac > 1 THEN
                LET g_rqa[l_ac].* = g_rqa[l_ac-1].*
                NEXT FIELD rqa03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
#No.TQC-750041---Begin
#       ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(rqa03)
#                   LET l_cmd = "amsq610 '",g_rqa01,"'",
#                                      " '",g_rqa02,"'",
#                                      " '",g_rqa[l_ac].rqa03,"'",
#                                      " '",g_rqa[l_ac].rqa04,"'" clipped
#                   CALL cl_cmdrun(l_cmd)
#                   NEXT FIELD rqa03
#              OTHERWISE EXIT CASE
#            END CASE
#No.TQC-750041---End
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------      
 
        END INPUT
 
    CLOSE i610_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i610_b_askkey()
DEFINE l_wc   LIKE type_file.chr1000    #NO.FUN-680101 VARCHAR(600)  
    CLEAR FORM
   CALL g_rqa.clear()
#螢幕上取條件
    CONSTRUCT l_wc ON rqa01,rqa02,rqa03,rqa04,rqa05,rqa06,rqa07
      FROM rqa01,rqa02,s_rqa[1].rqa03,s_rqa[1].rqa04,s_rqa[1].rqa05,
           s_rqa[1].rqa06,s_rqa[1].rqa07
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
    CALL i610_b_fill(l_wc)
END FUNCTION
 
FUNCTION i610_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc,l_sql     LIKE type_file.chr1000, #NO.FUN-680101  VARCHAR(600)
    l_flag         LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
 
    LET l_sql="SELECT rqa03,rqa04,rqa05,rqa06,rqa07 FROM rqa_file",
              " WHERE rqa01='",g_rqa01 CLIPPED,"' AND rqa02='",g_rqa02 CLIPPED,
              "' AND ",p_wc CLIPPED," ORDER BY 1,2 " CLIPPED
    PREPARE i610_rqa_pre FROM l_sql                            #預備一下
    DECLARE i610_rqa_cs CURSOR FOR i610_rqa_pre      #宣告成可捲動的
 
   #單身 ARRAY 乾洗
    CALL g_rqa.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH i610_rqa_cs INTO g_rqa[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('b_fill foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_rqa.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #NO.FUN-680101 VARCHAR(1) 
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rqa TO s_rqa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i610_fetch('L')
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 耗用明細查詢
      ON ACTION query_consumption_detail
         LET g_action_choice="query_consumption_detail"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#FUN-4B0014
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      ON ACTION related_document                #No.FUN-6A0150  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i610_copy()
DEFINE
    l_key1_o,l_key1       LIKE rqa_file.rqa01,
    l_key2_o,l_key2       LIKE rqa_file.rqa02
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_rqa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_key1,l_key2  FROM rqa01,rqa02
        AFTER FIELD rqa01
            IF l_key1  IS NULL THEN NEXT FIELD rqa01 END IF
        AFTER FIELD rqa02
            IF l_key2  IS NULL THEN NEXT FIELD rqa02 END IF
            SELECT count(*) INTO g_cnt FROM rqa_file
             WHERE rqa01 = l_key1 AND rqa02=l_key2
            IF g_cnt > 0 THEN
                CALL cl_err(l_key1,-239,0)
                NEXT FIELD rqa02
            END IF
      ON ACTION controlp
         IF INFIELD(rqa01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_rpf"
            LET g_qryparam.default1 = l_key1
            CALL cl_create_qry() RETURNING l_key1
#            CALL FGL_DIALOG_SETBUFFER( l_key1 )
            DISPLAY l_key1 TO rqa01
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
    IF INT_FLAG OR cl_null(l_key1) OR cl_null(l_key2) THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM rqa_file
     WHERE rqa01=g_rqa01 AND rqa02=g_rqa02 INTO TEMP x
    UPDATE x SET rqa01=l_key1,
                 rqa02=l_key2  #資料鍵值
    INSERT INTO rqa_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
 #      CALL cl_err(g_rqa01,SQLCA.sqlcode,0) #No.FUN-660108
        CALL cl_err3("ins","rqa_file",g_rqa01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
    ELSE
        MESSAGE 'ROW(',l_key1,') O.K'
        LET l_key1_o = g_rqa01
        LET l_key2_o = g_rqa02
        LET g_rqa01  = l_key1
        LET g_rqa02  = l_key2
        CALL i610_u()
        CALL i610_b()
        #LET g_rqa01 = l_key1_o  #FUN-C80046
        #LET g_rqa02 = l_key2_o  #FUN-C80046
        #CALL i610_show()        #FUN-C80046
    END IF
END FUNCTION
 
FUNCTION i610_out()
DEFINE
    l_i             LIKE type_file.num5,    #NO.FUN-680101  SMALLINT
    g_dash1         LIKE type_file.chr1000, #NO.FUN-680101  VARCHAR(80)
    sr              RECORD
       rqa01        LIKE rqa_file.rqa01,
       rqa02        LIKE rqa_file.rqa02,
       rqa03        LIKE rqa_file.rqa03,
       rqa04        LIKE rqa_file.rqa04,
       rqa05        LIKE rqa_file.rqa05,
       rqa06        LIKE rqa_file.rqa06,
       rqa07        LIKE rqa_file.rqa07
                    END RECORD,
    l_name          LIKE type_file.chr20,   #NO.FUN-680101  VARCHAR(20)   #External(Disk) file name
    l_za05          LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(40)  
 
    IF cl_null(g_wc) THEN
       LET g_wc=" rqa01='",g_rqa01,"' AND"," rqa02='",g_rqa02,"'"
    END IF
 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
 
    CALL cl_wait()
    CALL cl_del_data(l_table)     #No.FUN-770012
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   #組合出 SQL 指令
    LET g_sql="SELECT rqa01,rqa02,rqa03,rqa04,rqa05,rqa06,rqa07 ",
              " FROM rqa_file WHERE ",g_wc CLIPPED
    PREPARE i610_p1 FROM g_sql                  # RUNTIME 編譯
    DECLARE i610_co CURSOR FOR i610_p1   # SCROLL CURSOR
 
#No.FUN-770012 -- begin --
#    CALL cl_outnam('amsi610') RETURNING l_name
#    START REPORT i610_rep TO l_name
#No.FUN-770012 -- end --
 
    FOREACH i610_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#No.FUN-770012 -- begin --
#        OUTPUT TO REPORT i610_rep(sr.*)
          EXECUTE insert_prep USING sr.rqa01,sr.rqa02,sr.rqa03,sr.rqa04,
                                    sr.rqa05,sr.rqa06,sr.rqa07
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
             EXIT FOREACH
          END IF
#No.FUN-770012 -- end --
    END FOREACH
 
#No.FUN-770012 -- begin --
#    FINISH REPORT i610_rep
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'rqa01,rqa02,rqa03,rqa04,rqa05,rqa06,rqa07')
          RETURNING g_wc
     LET g_str = g_wc,";",g_zz05
     LET g_sql1 = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('amsi610','amsi610',g_sql1,g_str)
#No.FUN-770012 -- end --
END FUNCTION
 
REPORT i610_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,    #NO.FUN-680101  VARCHAR(1)
    sr              RECORD
       rqa01        LIKE rqa_file.rqa01,
       rqa02        LIKE rqa_file.rqa02,
       rqa03        LIKE rqa_file.rqa03,
       rqa04        LIKE rqa_file.rqa04,
       rqa05        LIKE rqa_file.rqa05,
       rqa06        LIKE rqa_file.rqa06,
       rqa07        LIKE rqa_file.rqa07
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.rqa01,sr.rqa02,sr.rqa03,sr.rqa04
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.rqa02
            PRINT COLUMN g_c[31],sr.rqa01,
                  COLUMN g_c[32],sr.rqa02;
 
        ON EVERY ROW
            #PRINT COLUMN g_c[33],sr.rqa03 USING 'YY/MM/DD',#FUN-570250 mark
            #      COLUMN g_c[34],sr.rqa04 USING 'YY/MM/DD',#FUN-570250 mark
            PRINT COLUMN g_c[33],sr.rqa03, #FUN-570250 add
                  COLUMN g_c[34],sr.rqa04, #FUN-570250 add
                  COLUMN g_c[35],sr.rqa05 USING '#########.##', #No.TQC-5C0005
                  COLUMN g_c[36],sr.rqa06 USING '#########.##', #No.TQC-5C0005
                  COLUMN g_c[37],sr.rqa07
        ON LAST ROW
            IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
               PRINT g_dash[1,g_len]
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
            END IF
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
