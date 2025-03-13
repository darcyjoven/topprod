# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi998.4gl
# Descriptions...: Javamail 預設收件人維護作業
# Date & Author..: 92/11/10 By A-Hai
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0206 04/10/13 By Echo 調整客製、gaz_file程式
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510006 05/02/17 By saki 將收件者開窗查詢改變為gen_file
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: No.MOD-630056 06/03/14 By Claire 程式代碼check是否存在於客製程式再checkpackage
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0015 06/10/25 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-870102 08/08/07 By tsai_yen 報表背景作業指定mail出報表的格式設定
# Modify.........: No.TQC-920070 09/02/23 By zhaijie 修改b_fill() DISPLAY筆數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-9C0019 11/02/17 By tsai_yen 非CR報表時,隱藏"報表mail檔案格式"的欄位
# Modify.........: No:FUN-A80035 11/05/23 By jacklai 新增匯出Excel(Data Only)權限
# Modify.........: No:MOD-B80069 11/08/18 By Vampire 新增 mlk01 開窗查詢段
# Modify.........: No:TQC-B90251 11/09/30 By wujie   copy时没有中文提示
# Modify.........: No:FUN-B80097 11/09/23 By jacklai GR背景作業(規格變更)
# Modify.........: No:FUN-C20037 12/06/07 By jacklai CR新增N選項:無任何匯出權限
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/09 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_mlk01         LIKE mlk_file.mlk01,   #目錄代號 (假單頭)
    g_mlk01_t       LIKE mlk_file.mlk01,   #目錄代號 (舊值)
    g_mlk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        mlk02       LIKE mlk_file.mlk02,   #
        mlk03       LIKE mlk_file.mlk03,   #
        mlk05       LIKE mlk_file.mlk05,   #
        mlk04       LIKE mlk_file.mlk04,   #
        mlk07       LIKE mlk_file.mlk07,   #報表mail檔案格式 No.FUN-870102
        mlk06       LIKE mlk_file.mlk06    #
                    END RECORD,
    g_mlk_t         RECORD                 #程式變數 (舊值)
        mlk02       LIKE mlk_file.mlk02,   #目錄序號
        mlk03       LIKE mlk_file.mlk03,   #目錄序號
        mlk05       LIKE mlk_file.mlk05,   #程式代號
        mlk04       LIKE mlk_file.mlk04,   #程式代號
        mlk07       LIKE mlk_file.mlk07,   #報表mail檔案格式 No.FUN-870102
        mlk06       LIKE mlk_file.mlk06    #
                    END RECORD,
    g_name          LIKE type_file.chr20,   #No.FUN-680102CHAR(10),
     g_wc,g_sql          STRING,  #No.FUN-580092 HCN      
    g_ss            LIKE type_file.chr1,           #No.FUN-680102  VARCHAR(01),            #決定後續步驟
    l_ac            LIKE type_file.num5,           #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
    g_argv1         LIKE mlk_file.mlk01,           #No.FUN-680102CHAR(10),
    g_rec_b         LIKE type_file.num5,           #單身筆數        #No.FUN-680102 SMALLINT
    g_cn2           LIKE type_file.num5            #No.FUN-680102SMALLINT 
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL      
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110        #No.FUN-680102 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680102 INTEGER
 
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680102CHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0081
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680102 SMALLINT
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)              #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET g_argv1 = ARG_VAL(1)                   #
    LET g_mlk01 = NULL                         #清除鍵值
    LET g_mlk01_t = NULL
 
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW i998_w AT p_row,p_col WITH FORM "aoo/42f/aooi998"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_argv1) THEN CALL i998_q() END IF
 
    CALL i998_menu()
 
    CLOSE WINDOW i998_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
END MAIN
 
FUNCTION i998_curs()                          # QBE 查詢資料
 
   IF cl_null(g_argv1) THEN
      CLEAR FORM                             # 清除畫面
   CALL g_mlk.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_mlk01 TO NULL    #No.FUN-750051
   CALL i998_iscr()              #CHI-9C0019
      #CONSTRUCT g_wc ON mlk01,mlk03,mlk04    # 螢幕上取條件 #FUN-870102 mark
      #     FROM mlk01,s_mlk[1].mlk03,s_mlk[1].mlk04         #FUN-870102 mark
      CONSTRUCT g_wc ON mlk01,mlk03,mlk04,mlk07    # 螢幕上取條件   #FUN-870102
           FROM mlk01,s_mlk[1].mlk03,s_mlk[1].mlk04,s_mlk[1].mlk07  #FUN-870102
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         #MOD-B80069 --- modify --- start ---
         ON ACTION controlp
            CASE
               WHEN INFIELD(mlk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1= g_mlk01
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO mlk01
                  NEXT FIELD mlk01
             OTHERWISE
                EXIT CASE
            END CASE
         #MOD-B80069 --- modify ---  end  ---

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
   ELSE
      LET g_wc=" mlk01='",g_argv1,"'"
   END IF
 
   LET g_sql= "SELECT UNIQUE mlk01 FROM mlk_file ",
              " WHERE ", g_wc CLIPPED
 
   PREPARE i998_prepare FROM g_sql      #預備一下
   DECLARE i998_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i998_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT mlk01) FROM mlk_file ",
               " WHERE ",g_wc CLIPPED
 
   PREPARE i998_precount FROM g_sql
   DECLARE i998_count CURSOR FOR i998_precount
 
END FUNCTION
 
FUNCTION i998_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(100)  
 
 
   WHILE TRUE
      CALL i998_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i998_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i998_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i998_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i998_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i998_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i998_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_mlk01 IS NOT NULL THEN
                  LET g_doc.column1 = "mlk01"
                  LET g_doc.value1 = g_mlk01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mlk),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i998_a()
    MESSAGE ""
    CLEAR FORM
   CALL g_mlk.clear()
    INITIALIZE g_mlk01 LIKE mlk_file.mlk01
    LET g_mlk01_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i998_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b=0
        CALL g_mlk.clear()
        IF g_ss='Y' THEN
            CALL i998_b_fill(0)         #單身
            DISPLAY ARRAY g_mlk TO s_mlk.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
        END IF
      {
        IF g_ss='N' THEN
            FOR g_cnt = 1 TO g_mlk.getLength()
                INITIALIZE g_mlk[g_cnt].* TO NULL
            END FOR
        ELSE
            CALL i998_b_fill(0)         #單身
        END IF
      }
        CALL i998_b()                   #輸入單身
        LET g_mlk01_t = g_mlk01            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i998_u()
    IF g_mlk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_mlk01_t = g_mlk01
    WHILE TRUE
        CALL i998_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_mlk01=g_mlk01_t
            DISPLAY g_mlk01 TO mlk01               #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_mlk01 != g_mlk01_t THEN             #更改單頭值
            UPDATE mlk_file SET mlk01 = g_mlk01  #更新DB
                WHERE mlk01 = g_mlk01_t          #COLAUTH?
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_mlk01,SQLCA.sqlcode,0)   #No.FUN-660131
                CALL cl_err3("upd","mlk_file",g_mlk01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i998_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1       #a:輸入 u:更改 #No.FUN-680102 VARCHAR(1)
 
    LET g_ss='Y'
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT g_mlk01
        WITHOUT DEFAULTS
        FROM mlk01
 
#No.FUN-570110 --start
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i998_set_entry(p_cmd)
        CALL i998_set_no_entry(p_cmd)
        CALL i998_iscr()                   #CHI-9C0019
        LET g_before_input_done = TRUE
#No.FUN-570110 --end
 
        AFTER FIELD mlk01                  #目錄代號
            IF g_mlk01 IS NOT NULL THEN
            IF g_mlk01 != g_mlk01_t OR     #輸入後更改不同時值
               g_mlk01_t IS NULL THEN
                SELECT UNIQUE mlk01 INTO g_chr
                    FROM mlk_file
                    WHERE mlk01=g_mlk01
                IF SQLCA.sqlcode THEN             #不存在, 新來的
                    IF p_cmd='a' THEN
                        LET g_ss='N'
                    END IF
                ELSE
                    IF p_cmd='u' THEN
                        CALL cl_err(g_mlk01,-239,0)
                        LET g_mlk01=g_mlk01_t
                        NEXT FIELD mlk01
                    END IF
                END IF
            END IF
 
            CALL i998_mlk01(p_cmd)
            IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_mlk01,g_errno,0)
                NEXT FIELD mlk01
            END IF
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(mlk01)
#                   CALL q_zz(g_mlk01) RETURNING g_mlk01
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_zz"               #MOD-B80069 mark
                    LET g_qryparam.form = "q_gaz"              #MOD-B80069 add
                    LET g_qryparam.arg1 = g_lang CLIPPED       #MOD-B80069 add
                    LET g_qryparam.default1 = g_mlk01
                    CALL cl_create_qry() RETURNING g_mlk01
                    DISPLAY BY NAME g_mlk01
                    NEXT FIELD mlk01
                OTHERWISE
                    EXIT CASE
            END CASE
       #TQC-860019-add
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
       #TQC-860019-add

       AFTER INPUT          #CHI-9C0019
          CALL i998_iscr()  #CHI-9C0019
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i998_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_mlk01 TO NULL             #No.FUN-6A0015
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i998_curs()                       #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i998_b_curs                        #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                   #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_mlk01 TO NULL
    ELSE
        CALL i998_fetch('F')                 #讀出TEMP第一筆並顯示
            OPEN i998_count
            FETCH i998_count INTO g_row_count
            DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i998_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #處理方式        #No.FUN-680102 VARCHAR(1)
    l_abso          LIKE type_file.num10    #絕對的筆數      #No.FUN-680102 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i998_b_curs INTO g_mlk01
        WHEN 'P' FETCH PREVIOUS i998_b_curs INTO g_mlk01
        WHEN 'F' FETCH FIRST    i998_b_curs INTO g_mlk01
        WHEN 'L' FETCH LAST     i998_b_curs INTO g_mlk01
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso i998_b_curs INTO g_mlk01
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_mlk01,SQLCA.sqlcode,0)
#       INITIALIZE g_mlk01 TO NULL
    ELSE
 
        CALL i998_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i998_show()
    DISPLAY g_mlk01 TO mlk01               #單頭
    CALL i998_iscr()                       #CHI-9C0019
    CALL i998_mlk01('a')                   #單身
    CALL i998_b_fill(0)                    #單身
    CALL cl_show_fld_cont()                #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i998_r()
    IF g_mlk01 IS NULL THEN
       CALL cl_err("",-400,0)              #No.FUN-6A0015
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "mlk01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_mlk01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM mlk_file WHERE mlk01 = g_mlk01
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("del","mlk_file",g_mlk01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660131
        ELSE
            CLEAR FORM
   CALL g_mlk.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION i998_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_tot           LIKE type_file.num5,           #No.FUN-680102SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680102 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680102 SMALLINT
    
   DEFINE l_zy06        LIKE zy_file.zy06       #FUN-C20037
   DEFINE l_iscr        LIKE type_file.num5     #FUN-C20037
   DEFINE l_str_zy06    STRING                  #FUN-C20037
   DEFINE l_zy06_auth   LIKE type_file.num5     #FUN-C20037
   DEFINE l_trans_m07   STRING                  #FUN-C20037
   
    LET g_action_choice = ""
    IF g_mlk01 IS NULL THEN
        RETURN
    END IF
#   IF NOT cl_chk_act_auth() THEN
#       OPTIONS INSERT KEY F13
#   END IF
#   IF NOT cl_chk_act_auth() THEN
#       OPTIONS DELETE KEY F13
#   END IF
 
    CALL cl_opmsg('b')
 
    #LET g_forupd_sql = "SELECT mlk02,mlk03,mlk05,mlk04,mlk06 FROM mlk_file WHERE mlk01=? AND mlk02=? FOR UPDATE"   #FUN-870102 mark
    LET g_forupd_sql = "SELECT mlk02,mlk03,mlk05,mlk04,mlk07,mlk06 FROM mlk_file WHERE mlk01=? AND mlk02=? FOR UPDATE"    #FUN-870102
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i998_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    CALL i998_iscr()                                  #CHI-9C0019
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    #判斷程式是否為CR報表
    LET l_iscr = (cl_prt_reptype(g_mlk01) == 1) #FUN-C20037
 
    INPUT ARRAY g_mlk WITHOUT DEFAULTS FROM s_mlk.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        AFTER FIELD mlk05
           IF NOT cl_null(g_mlk[l_ac].mlk05) THEN      # FUN-510006
              SELECT gen06 INTO g_mlk[l_ac].mlk04 FROM gen_file
               WHERE gen02 = g_mlk[l_ac].mlk05 ORDER BY gen01
              DISPLAY g_mlk[l_ac].mlk04 TO mlk04
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac  TO FORMONLY.cn2
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_mlk_t.* = g_mlk[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN i998_b_curl USING g_mlk01,g_mlk_t.mlk02
                IF STATUS THEN
                   CALL cl_err("OPEN i998_b_curl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i998_b_curl INTO g_mlk[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_mlk_t.mlk03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_mlk[l_ac].* TO NULL      #900423
            LET g_mlk_t.* = g_mlk[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD mlk02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #INSERT INTO mlk_file(mlk01,mlk02,mlk03,mlk04,mlk05,mlk06)          #FUN-870102 mark
            #     VALUES(g_mlk01,g_mlk[l_ac].mlk02,g_mlk[l_ac].mlk03,           #FUN-870102 mark
            #            g_mlk[l_ac].mlk04,g_mlk[l_ac].mlk05,g_mlk[l_ac].mlk06) #FUN-870102 mark
     
            # FUN-870102 START # 
            INSERT INTO mlk_file(mlk01,mlk02,mlk03,mlk04,mlk07,mlk05,mlk06)
                 VALUES(g_mlk01,g_mlk[l_ac].mlk02,g_mlk[l_ac].mlk03,
                        g_mlk[l_ac].mlk04,g_mlk[l_ac].mlk07,g_mlk[l_ac].mlk05,g_mlk[l_ac].mlk06)
            #FUN-870102 END #
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_mlk[l_ac].mlk02,SQLCA.sqlcode,0)   #No.FUN-660131
               CALL cl_err3("ins","mlk_file",g_mlk[l_ac].mlk02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
            END IF
 
        BEFORE FIELD mlk02                       #default 序號
            IF cl_null(g_mlk[l_ac].mlk02) OR g_mlk[l_ac].mlk02 = 0 THEN
                SELECT max(mlk02)+1
                   INTO g_mlk[l_ac].mlk02
                   FROM mlk_file
                   WHERE mlk01 = g_mlk01
                IF g_mlk[l_ac].mlk02 IS NULL THEN
                    LET g_mlk[l_ac].mlk02 = 1
                END IF
            END IF
 
        AFTER FIELD mlk02                        #check 序號是否重複
            IF g_mlk[l_ac].mlk02 IS NOT NULL THEN
            IF g_mlk[l_ac].mlk02 != g_mlk_t.mlk02 OR
               g_mlk_t.mlk02 IS NULL THEN
                SELECT count(*)
                    INTO l_n
                    FROM mlk_file
                    WHERE mlk01 = g_mlk01 AND
                          mlk02 = g_mlk[l_ac].mlk02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_mlk[l_ac].mlk02 = g_mlk_t.mlk02
                    NEXT FIELD mlk02
                END IF
            END IF
            END IF
 
        AFTER FIELD mlk03                        # check寄件型態
            IF g_mlk[l_ac].mlk03 NOT MATCHES '[123]' THEN
                NEXT FIELD mlk03
            END IF
 
        AFTER FIELD mlk04                        # check E-mail 是否只有一個 @
            IF NOT cl_null(g_mlk[l_ac].mlk04) THEN
                CALL i998_check_at(g_mlk[l_ac].mlk04)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_mlk[l_ac].mlk04,g_errno,0)
                   NEXT FIELD mlk04
                END IF
            END IF
 
        #  No.FUN-870102  START #   
        AFTER FIELD mlk07                        # check報表mail檔案格式
            #FUN-C20037 --start--
            #IF g_mlk[l_ac].mlk07 NOT MATCHES '[123456]' THEN    #No:FUN-A80035 add 6
            #    NEXT FIELD mlk07
            #END IF
            IF l_iscr THEN
               #轉換對應的格式
               CASE g_mlk[l_ac].mlk07
                  WHEN "1" LET l_trans_m07 = "P"
                  WHEN "2" LET l_trans_m07 = "R"
                  WHEN "3" LET l_trans_m07 = "D"
                  WHEN "4" LET l_trans_m07 = "X"
                  WHEN "5" LET l_trans_m07 = "E"
                  WHEN "6" LET l_trans_m07 = "A"
                  OTHERWISE LET l_trans_m07 = NULL
               END CASE
               LET l_zy06_auth = FALSE
               #檢查目前使用者的權限類別與p_cron的程式代號的報表匯出格式的權限
               SELECT zy06 INTO l_zy06 FROM zy_file WHERE zy01 = g_clas AND zy02 = g_mlk01
               IF SQLCA.SQLCODE THEN
                  LET l_zy06 = NULL
               ELSE
                  LET l_str_zy06 = l_zy06
                  IF l_str_zy06.getIndexOf(l_trans_m07,1) >= 1 OR l_str_zy06 IS NULL THEN
                     LET l_zy06_auth = TRUE
                  END IF
               END IF

               IF NOT l_zy06_auth THEN
                  CALL cl_msgany(1,1,"rpt-052")
                  NEXT FIELD mlk07
               END IF
            END IF
            #FUN-C20037 --end--
        #  No.FUN-870102  END #
 
        BEFORE DELETE                            #是否取消單身
            IF g_mlk_t.mlk02 > 0 AND
               g_mlk_t.mlk02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                DELETE FROM mlk_file
                    WHERE mlk01 = g_mlk01 AND
                          mlk02 = g_mlk_t.mlk02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_mlk_t.mlk02,SQLCA.sqlcode,0)   #No.FUN-660131
                    CALL cl_err3("del","mlk_file",g_mlk_t.mlk02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                    LET l_ac_t = l_ac
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i998_b_curl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_mlk[l_ac].* = g_mlk_t.*
               CLOSE i998_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_mlk[l_ac].mlk02,-263,1)
               LET g_mlk[l_ac].* = g_mlk_t.*
            ELSE
               # FUN-870102 mark START #
               #UPDATE mlk_file SET mlk02 = g_mlk[l_ac].mlk02,
               #                    mlk03 = g_mlk[l_ac].mlk03,
               #                    mlk04 = g_mlk[l_ac].mlk04,
               #                    mlk05 = g_mlk[l_ac].mlk05,
               #                    mlk06 = g_mlk[l_ac].mlk06
               # FUN-870102 mark END #
 
               # FUN-870102 START #
               UPDATE mlk_file SET mlk02 = g_mlk[l_ac].mlk02,
                                   mlk03 = g_mlk[l_ac].mlk03,
                                   mlk04 = g_mlk[l_ac].mlk04,
                                   mlk07 = g_mlk[l_ac].mlk07,
                                   mlk05 = g_mlk[l_ac].mlk05,
                                   mlk06 = g_mlk[l_ac].mlk06
               # FUN-870102 END #
                WHERE mlk01=g_mlk01
                  AND mlk02=g_mlk_t.mlk02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_mlk[l_ac].mlk02,SQLCA.sqlcode,0)   #No.FUN-660131
                   CALL cl_err3("upd","mlk_file",g_mlk01,g_mlk_t.mlk02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                   LET g_mlk[l_ac].* = g_mlk_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   #COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_mlk[l_ac].* = g_mlk_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_mlk.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i998_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i998_b_curl
            COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(mlk05)              # FUN-510006
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen_m"
                 LET g_qryparam.default1 = g_mlk[l_ac].mlk05
                 CALL cl_create_qry() RETURNING g_mlk[l_ac].mlk05,g_mlk[l_ac].mlk04
                 DISPLAY g_mlk[l_ac].mlk05 TO mlk05
                 DISPLAY g_mlk[l_ac].mlk04 TO mlk04
                 NEXT FIELD mlk05
           END CASE
 
        ON ACTION CONTROLN
            CALL i998_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(mlk03) AND l_ac > 1 THEN
                LET g_mlk[l_ac].* = g_mlk[l_ac-1].*
                DISPLAY g_mlk[l_ac].* TO s_mlk[l_ac].*
                NEXT FIELD mlk03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION resort_sn
                    CALL i998_b_y()
                    CALL i998_b_fill(0)
                    EXIT INPUT
 
        ON ACTION mntn_zz
 
        ON ACTION add_sn
            CALL i998_b_u()
 
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
 
    CLOSE i998_b_curl
    #COMMIT WORK
END FUNCTION
 
FUNCTION i998_b_y()
   DEFINE r,i,j LIKE type_file.num10          #No.FUN-680102 INTEGER 
   DECLARE i998_b_y_c CURSOR FOR
       SELECT mlk02 FROM mlk_file WHERE mlk01=g_mlk01 ORDER BY mlk03
   BEGIN WORK LET g_success = 'Y'
   LET i=0
   FOREACH i998_b_y_c INTO j
       IF STATUS THEN
       CALL cl_err('foreach',STATUS,1)    
        LET g_success = 'N' EXIT FOREACH
     END IF
     LET i=i+1
     UPDATE mlk_file SET mlk02 = i WHERE mlk01=g_mlk01 AND mlk02=j
     IF STATUS THEN
#       CALL cl_err('upd mlk02',STATUS,1)    #No.FUN-660131
        CALL cl_err3("upd","mlk_file","","",SQLCA.sqlcode,"","upd mlk_file",1)  #No.FUN-660131
        LET g_success = 'N' EXIT FOREACH
     END IF
   END FOREACH
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF
END FUNCTION
 
FUNCTION i998_b_u()
### FUN-870102 mark START ###
#   DEFINE r,i,j LIKE type_file.num10          #No.FUN-680102 INTEGER 
#   DECLARE i998_b_u_c CURSOR FOR
#       SELECT mlk03 FROM mlk_file
#              WHERE mlk01 = g_mlk01 AND mlk03 >= g_mlk[l_ac].mlk03
#              ORDER BY mlk03 DESC
#   BEGIN WORK LET g_success = 'Y'
#   FOREACH i998_b_u_c INTO j
#       IF STATUS THEN CALL cl_err('foreach',STATUS,1)    
#        LET g_success = 'N' EXIT FOREACH
#     END IF
#     UPDATE mlk_file SET mlk03 = mlk03 + 1 WHERE mlk01=g_mlk01 AND mlk02=j
#     IF STATUS THEN
##       CALL cl_err('upd mlk03',STATUS,1)   #No.FUN-660131
#        CALL cl_err3("upd","mlk_file",g_mlk_t.mlk02,"",SQLCA.sqlcode,"","upd mik03",1)  #No.FUN-660131
#        LET g_success = 'N' EXIT FOREACH
#     END IF
#   END FOREACH
#   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF
#   FOR i = l_ac TO g_mlk.getLength()
#      IF g_mlk[i].mlk03 IS NOT NULL THEN
#         LET g_mlk[i].mlk03 = g_mlk[i].mlk03 + 1
#         DISPLAY g_mlk[i].mlk03 TO s_mlk[j].mlk03
#         LET j = j + 1
#      END IF
#   END FOR
#   LET g_mlk_t.mlk03 = g_mlk[l_ac].mlk03
### FUN-870102 mark END ###
 
### FUN-870102 START ###
   #序號加一:mlk02 
   DEFINE r,i,j LIKE type_file.num10          #No.FUN-680102 INTEGER 
   DECLARE i998_b_u_c CURSOR FOR
       SELECT mlk02 FROM mlk_file
              WHERE mlk01 = g_mlk01 AND mlk02 >= g_mlk[l_ac].mlk02
              ORDER BY mlk02 DESC
   BEGIN WORK LET g_success = 'Y'
   FOREACH i998_b_u_c INTO j
       IF STATUS THEN CALL cl_err('foreach',STATUS,1)    
        LET g_success = 'N' EXIT FOREACH
     END IF
     UPDATE mlk_file SET mlk02 = mlk02 + 1 WHERE mlk01=g_mlk01 AND mlk02=j
     IF STATUS THEN
#       CALL cl_err('upd mlk03',STATUS,1)   #No.FUN-660131
        CALL cl_err3("upd","mlk_file",g_mlk_t.mlk02,"",SQLCA.sqlcode,"","upd mik03",1)  #No.FUN-660131
        LET g_success = 'N' EXIT FOREACH
     END IF
   END FOREACH
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF
   FOR i = l_ac TO g_mlk.getLength()
      IF g_mlk[i].mlk02 IS NOT NULL THEN
         LET g_mlk[i].mlk02 = g_mlk[i].mlk02 + 1
         DISPLAY g_mlk[i].mlk02 TO s_mlk[j].mlk02
         LET j = j + 1
      END IF
   END FOR
   LET g_mlk_t.mlk02 = g_mlk[l_ac].mlk02
### FUN-870102 END ###
END FUNCTION
 
 
FUNCTION i998_name(p_name)
    DEFINE p_name		LIKE type_file.chr20             #No.FUN-680102CHAR(10)
    DEFINE l_name		LIKE type_file.chr20             #No.FUN-680102CHAR(10)
    DEFINE i			LIKE type_file.num5              #No.FUN-680102 SMALLINT
 
#   FOR i = 1 TO 10
#      IF p_name[i,i] = ' ' OR p_name[i,i] IS NULL THEN EXIT FOR END IF
#      LET l_name[i,i]=p_name[i,i]
#   END FOR
    LET l_name=p_name
    RETURN l_name
END FUNCTION
 
FUNCTION i998_b_askkey()
DEFINE
    l_begin_key     LIKE mlk_file.mlk03
 
    CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
    PROMPT g_msg CLIPPED,': ' FOR l_begin_key
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
#          CONTINUE PROMPT
 
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
    CALL i998_b_fill(l_begin_key)
END FUNCTION
 
FUNCTION i998_b_fill(p_key)              #BODY FILL UP
 
    DEFINE p_key           LIKE mlk_file.mlk03
 
    DECLARE mlk_curs CURSOR FOR
        SELECT mlk02,mlk03,
               mlk05,mlk04,
               mlk07,mlk06     #FUN-870102
        #       mlk06          #FUN-870102 mark
        FROM mlk_file
        WHERE mlk01 = g_mlk01 AND
              mlk02 >= p_key
        ORDER BY mlk03
 
    CALL g_mlk.clear()
 
    LET g_cnt = 1
    FOREACH mlk_curs INTO g_mlk[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
       #TQC-630106-begin
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
       #TQC-630106-end
    END FOREACH
    CALL g_mlk.deleteElement(g_cnt)
    #LET g_cnt = g_cnt - 1   #TQC-920070 MARK
    #LET g_rec_b= g_cnt      #TQC-920070 MARK
    LET g_rec_b = g_cnt - 1  #TQC-920070
    LET g_cnt = 0
    #DISPLAY g_cnt TO FORMONLY.cn2
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION i998_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mlk TO s_mlk.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i998_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i998_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i998_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i998_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i998_fetch('L')
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
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
 
 
FUNCTION i998_copy()
DEFINE
    l_newno         LIKE mlk_file.mlk01
 
    IF g_mlk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
#   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    CALL cl_getmsg('mfg-065',g_lang) RETURNING g_msg  #No.TQC-B90251 
            LET INT_FLAG = 0  ######add for prompt bug
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    PROMPT g_msg CLIPPED,': ' FOR l_newno
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
#          CONTINUE PROMPT
 
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
    SELECT count(*) INTO g_cnt FROM mlk_file
        WHERE mlk01 = l_newno
    IF g_cnt > 0 THEN
        CALL cl_err(g_mlk01,-239,0)
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM mlk_file
        WHERE mlk01=g_mlk01
        INTO TEMP x
    UPDATE x
        SET mlk01=l_newno     #資料鍵值
    INSERT INTO mlk_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_mlk01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","mlk_file",g_mlk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET g_mlk01 = l_newno  #FUN-C80046
    END IF
    CALL i998_show()  #FUN-C80046
END FUNCTION
 
 
FUNCTION i998_mlk01(p_cmd)
 
DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
       l_gaz03     LIKE gaz_file.gaz03
DEFINE l_cnt       LIKE type_file.num10          #No.FUN-680102INTEGER
 
   LET g_errno = " "
   #MOD-630056-begin
    SELECT gaz03 INTO l_gaz03 FROM gaz_file
     WHERE gaz01 = g_mlk01 AND gaz02 = g_lang AND gaz05='Y'
    IF STATUS THEN 
       SELECT gaz03 INTO l_gaz03 FROM gaz_file          
        WHERE gaz01 = g_mlk01 AND gaz02 = g_lang AND gaz05='N'
       IF SQLCA.sqlcode THEN
          IF SQLCA.SQLCODE = 100 THEN 
             LET g_errno = "aoo-997"
          ELSE 
             LET g_errno = SQLCA.sqlcode USING "-------"
             LET g_chr = 'E'
             LET l_gaz03 = NULL
          END IF
       END IF
    END IF
 ### No.MOD-4A0206
   #SELECT COUNT(gaz03) INTO l_cnt FROM gaz_file
   # WHERE gaz01 = g_mlk01 AND gaz02 = g_lang
   #IF l_cnt > 1 THEN
   #   SELECT gaz03 INTO l_gaz03 FROM gaz_file
   #     WHERE gaz01 = g_mlk01 AND gaz02 = g_lang AND gaz05='Y'
   #ELSE
   #   SELECT gaz03 INTO l_gaz03 FROM gaz_file
   #     WHERE gaz01 = g_mlk01 AND gaz02 = g_lang AND gaz05='N'
   #END IF
 ### END No.MOD-4A0206 ##
   #IF SQLCA.sqlcode THEN
   #    IF SQLCA.SQLCODE = 100 THEN LET g_errno = "aoo-997"
   #    ELSE LET g_errno = SQLCA.sqlcode USING "-------"
   #    END IF
   #    LET g_chr = 'E'
   #    LET l_gaz03 = NULL
   #    RETURN
   #END IF
   #MOD-630056-begin
 
   LET g_chr = ' '
 
   IF p_cmd = 'a' THEN
       DISPLAY l_gaz03 TO gaz03
   END IF
 
END FUNCTION
 
FUNCTION i998_check_at(l_buf)  # Check mlk04 是否只含有一個 @ 符號
 
  DEFINE l_i      LIKE type_file.num5,          #No.FUN-680102 SMALLINT
         l_j      LIKE type_file.num5,          #No.FUN-680102 SMALLINT
         l_count  LIKE type_file.num5,           #No.FUN-680102SMALLINT
         l_buf    LIKE mlk_file.mlk04
 
    LET l_j     = length(l_buf)
    LET g_errno = ""
    LET l_count = 0
 
    FOR l_i=1 TO l_j
        IF l_buf[l_i,l_i]='@' THEN
           LET l_count=l_count + 1
        END IF
    END FOR
 
    IF l_count != 1 THEN
        LET g_errno = "aoo-994"
    END IF
 
END FUNCTION
 
#No.FUN-570110 --start
FUNCTION i998_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("mlk01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i998_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("mlk01",FALSE)
   END IF
 
END FUNCTION
 
#No.FUN-570110 --end
#Patch....NO.TQC-610036 <001> #

#在p_zaw有資料表示為CR報表
FUNCTION i998_iscr()   #CHI-9C0019
   #DEFINE   l_cnt  LIKE type_file.num5  #No.FUN-B80097 mark
   DEFINE   l_vis  LIKE type_file.num5   #是否顯示

   LET l_vis = 0
   IF cl_null(g_mlk01) THEN
      LET l_vis = 1
   ELSE
      #No.FUN-B80097 --start--
      ##FUN-B80097 mark start
      #SELECT COUNT(zaw01) INTO l_cnt FROM zaw_file WHERE zaw01 = g_mlk01
      #IF l_cnt > 0 THEN
      #   LET l_vis = 1
      #END IF
      ##FUN-B80097 mark end
      LET l_vis = cl_prt_reptype(g_mlk01)
      #No.FUN-B80097 --end--
   END IF

   IF l_vis >= 1 THEN #No.FUN-B80097
      CALL cl_set_comp_visible("mlk07", TRUE)
      CALL cl_prt_set_repexp_combo(l_vis,"mlk07") #No.FUN-B80097
   ELSE
      CALL cl_set_comp_visible("mlk07", FALSE)
   END IF
END FUNCTION
