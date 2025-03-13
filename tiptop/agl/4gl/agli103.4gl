# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli103.4gl
# Descriptions...: 科目額外說明維護作業
# Input parameter:
# Date & Author..: 90/02/22 By Nora
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.MOD-560150 05/06/29 By Nicola 傳入參數自動查詢出資料
# Modify.........: No.FUN-590124 05/10/05 By Dido aag02科目名稱放寬
# Modify.........: NO.FUN-570250 05/12/22 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time   
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740015 07/04/04 By Judy 無法預設上筆
# Modify.........: No.TQC-750041 07/05/16 By sherry 插入資料時,報錯:(-255)XX不在交易中
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/07/30 By sherry 報表改由Crystal Report輸出
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-C80147 12/08/23 By lujh 在agli102中點額外說明維護按鈕打開agli103畫面時，直接進入錄入狀態
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_aak00         LIKE aak_file.aak00,   #No.FUN-730020
    g_aak00_t       LIKE aak_file.aak00,   #No.FUN-730020
    g_aak01         LIKE aak_file.aak01,   #科目編號 (假單頭)
    g_aak01_t       LIKE aak_file.aak01,   #科目編號 (舊值)
    g_aak02         LIKE aak_file.aak02,   #說明類別
    g_aak02_t       LIKE aak_file.aak02,   #
    g_aak03         LIKE aak_file.aak03,   #行序
    g_aak03_t       LIKE aak_file.aak03,   #行序(舊值)
    g_aak           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aak03       LIKE aak_file.aak03,   #行序
        aak04       LIKE aak_file.aak04    #說明
                    END RECORD,
    g_aak_t         RECORD                 #程式變數 (舊值)
        aak03       LIKE aak_file.aak03,   #行序
        aak04       LIKE aak_file.aak04    #說明
                    END RECORD,
    g_argv0         LIKE aag_file.aag00,   #No.FUN-730020
    g_argv1         LIKE aag_file.aag01,
    g_aaguser       LIKE aag_file.aaguser,
    g_aaggrup       LIKE aag_file.aaggrup,
    g_aagmodu       LIKE aag_file.aagmodu,
    g_aagdate       LIKE aag_file.aagdate,
    g_aagacti       LIKE aag_file.aagacti,
    g_ss            LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
#   g_wc,g_sql      VARCHAR(300),
    g_wc,g_sql      STRING,        #TQC-630166      
    g_rec_b         LIKE type_file.num5,       #單身筆數             #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT  #No.FUN-680098 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680098 SMALLINT
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE   g_str           STRING                       #No.FUN-760085
MAIN
# DEFINE l_time          LIKE type_file.chr8          #No.FUN-680098 VARCHAR(8)  #No.FUN-6A0073 
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
    LET g_aak02 =   NULL                   #清除鍵值
    LET g_aak01_t = NULL
    LET g_aak00_t = NULL   #No.FUN-730020
    LET g_aak02_t = NULL
     LET g_argv0 = ARG_VAL(1)     #No.FUN-730020
     LET g_argv1 = ARG_VAL(2)     #No.MOD-4C0171
 
    LET p_row = 4 LET p_col = 30
 
    OPEN WINDOW i103_w AT p_row,p_col
      WITH FORM "agl/42f/agli103"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #-----No.MOD-560150-----
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv0) THEN  #No.FUN-730020
      #CALL i103_q()   #TQC-C80147  mark
      CALL i103_a()    #TQC-C80147  add
   END IF
    #-----No.MOD-560150 END-----
 
    CALL i103_menu()
 
    CLOSE WINDOW i103_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i103_curs()
    CLEAR FORM                             #清除畫面
   CALL g_aak.clear()
 
    CALL g_aak.clear()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '  AND  #No.FUN-730020
       g_argv0 IS NOT NULL AND g_argv0 != ' ' THEN  #No.FUN-730020
       LET g_aak01 =  g_argv1
       LET g_aak00 =  g_argv0    #No.FUN-730020
       DISPLAY g_aak01 TO aak01
       DISPLAY g_aak00 TO aak00  #No.FUN-730020
       CALL i103_aak00('d')      #No.FUN-730020
       CALL i103_aak01('d')
       CALL cl_set_head_visible("","YES")     #No.FUN-6B0029
 
   INITIALIZE g_aak00 TO NULL    #No.FUN-750051
   INITIALIZE g_aak01 TO NULL    #No.FUN-750051
   INITIALIZE g_aak02 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON aak02,aak03,aak04    #螢幕上取條件
         FROM aak02,s_aak[1].aak03,s_aak[1].aak04
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       LET g_wc = g_wc CLIPPED," AND aak01 ='",g_argv1,"'",
                               " AND aak00 ='",g_argv0,"'"  #No.FUN-730020
       IF INT_FLAG THEN RETURN END IF
    ELSE
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0029
       CONSTRUCT g_wc ON aak00,aak01,aak02,aak03,aak04    #螢幕上取條件  #No.FUN-730020
            FROM aak00,aak01,aak02,s_aak[1].aak03,s_aak[1].aak04  #No.FUN-730020
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON ACTION controlp
               CASE
                  #No.FUN-730020  --Begin
                  WHEN INFIELD(aak00) #帳別
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_aaa"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aak00
                     NEXT FIELD aak00
                  #No.FUN-730020  --End  
                  WHEN INFIELD(aak01) #科目編號
#                    CALL q_aag( FALSE, TRUE, g_aak01,'','','') RETURNING g_aak01
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_aag"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aak01
                     CALL i103_aak01('d')
                     NEXT FIELD aak01
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
    END IF
    LET g_sql= "SELECT UNIQUE aak00,aak01,aak02 FROM aak_file ",  #No.FUN-730020
               " WHERE ", g_wc CLIPPED,
               " ORDER BY aak00,aak01,aak02"  #No.FUN-730020
    PREPARE i103_prepare FROM g_sql      #預備一下
    DECLARE i103_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i103_prepare
 
    #No.FUN-730020  --Begin
#   LET g_sql="SELECT COUNT(DISTINCT aak01)  ",
#             " FROM aak_file WHERE ", g_wc CLIPPED
    LET g_sql_tmp = "SELECT UNIQUE aak00,aak01,aak02 FROM aak_file",
                    " WHERE ",g_wc CLIPPED,
                    "  INTO TEMP x" 
    DROP TABLE x
    PREPARE i103_pre_x FROM g_sql_tmp
    EXECUTE i103_pre_x
    LET g_sql = "SELECT COUNT(*) FROM x"
    #No.FUN-730020  --End  
    PREPARE i103_precount FROM g_sql
    DECLARE i103_count CURSOR FOR i103_precount
END FUNCTION
 
FUNCTION i103_menu()
 
   WHILE TRUE
      CALL i103_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i103_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i103_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i103_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               IF g_aagacti matches'[Yy]' THEN
                  CALL i103_u()
               ELSE
                  CALL cl_err(g_aak01,'9027',0)
               END IF
            END IF
         WHEN "reproduce"
             IF cl_chk_act_auth() THEN
                CALL i103_copy()
             END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i103_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i103_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_aak01 IS NOT NULL THEN
                  #No.FUN-730020  --Begin
                  LET g_doc.column1 = "aak00"
                  LET g_doc.value1 = g_aak00
                  LET g_doc.column2 = "aak01"
                  LET g_doc.value2 = g_aak01
                  LET g_doc.column3 = "aak02"
                  LET g_doc.value3 = g_aak02
                  #No.FUN-730020  --End  
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aak),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i103_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_aak.clear()
    INITIALIZE g_aak00 LIKE aak_file.aak00   #No.FUN-730020
    INITIALIZE g_aak01 LIKE aak_file.aak01
    INITIALIZE g_aak02 LIKE aak_file.aak02
    LET g_aak00_t = NULL   #No.FUN-730020
    LET g_aak01_t = NULL
    LET g_aak02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i103_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_aak01=NULL
            LET g_aak00=NULL   #No.FUN-730020
            LET g_aak02=NULL   #No.FUN-730020
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b = 0                    #No.FUN-680064 
        IF g_ss='N' THEN
           CALL g_aak.clear()
#           LET g_rec_b = 0              No.FUN-680064
        ELSE
           CALL i103_b_fill('1=1')          #單身
        END IF
        CALL i103_b()                        #輸入單身
      #No.TQC-750041---Begin 
      # IF SQLCA.sqlcode THEN
      #    CALL cl_err(g_aak01,SQLCA.sqlcode,0)
      # END IF
      #No.TQC-750041---End
        LET g_aak01_t = g_aak01                 #保留舊值
        LET g_aak02_t = g_aak02                 #保留舊值
        LET g_aak00_t = g_aak00    #No.FUN-730020
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i103_u()
  DEFINE  l_buf      LIKE type_file.chr50        #No.FUN-680098  VARCHAR(30)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_chkey = 'N' THEN
       CALL cl_err(g_aak01,'aoo-085',0)
       RETURN
    END IF
    IF cl_null(g_aak01)  OR cl_null(g_aak00) THEN  #No.FUN-730020
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_aak01_t = g_aak01
    LET g_aak02_t = g_aak02
    LET g_aak00_t = g_aak00   #No.FUN-730020
    BEGIN WORK
    WHILE TRUE
        CALL i103_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_aak01=g_aak01_t
            LET g_aak02=g_aak02_t
            LET g_aak00=g_aak00_t      #No.FUN-730020
            DISPLAY g_aak01 TO aak01               #單頭
            DISPLAY g_aak02 TO aak02               #單頭
            DISPLAY g_aak00 TO aak00   #No.FUN-730020
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_aak01 != g_aak01_t OR g_aak02 != g_aak02_t 
        OR g_aak00 != g_aak00_t THEN  #No.FUN-730020
           UPDATE aak_file SET aak01 = g_aak01,  #更新DB
                               aak00 = g_aak00,  #No.FUN-730020
                               aak02 = g_aak02
            WHERE aak01 = g_aak01_t AND aak02 = g_aak02_t
              AND aak00 = g_aak00_t   #No.FUN-730020
            IF SQLCA.sqlcode THEN
                LET l_buf = g_aak00 CLIPPED,'+',g_aak01 clipped,'+',g_aak02 clipped  #No.FUN-730020
#               CALL cl_err(l_buf,SQLCA.sqlcode,0)   #No.FUN-660123
                CALL cl_err3("upd","aak_file",g_aak01_t,g_aak02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i103_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
    l_buf           LIKE type_file.chr1000,      #No.FUN-680098        VARCHAR(60)
    l_n             LIKE type_file.num5          #No.FUN-680098        SMALLINT
 
    LET g_ss = 'Y'
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 
 
    INPUT g_aak00,g_aak01,g_aak02  WITHOUT DEFAULTS  #No.FUN-730020
        FROM aak00,aak01,aak02  #No.FUN-730020
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i103_set_entry(p_cmd)
            CALL i103_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
       #No.FUN-730020  --Begin
       BEFORE FIELD aak00
          IF NOT cl_null(g_argv0) THEN
             LET g_aak00 = g_argv0
             DISPLAY g_aak00 TO aak00
             NEXT FIELD aak01
          END IF
 
       AFTER FIELD aak00
          IF NOT cl_null(g_aak00) THEN
             CALL i103_aak00('a')
             IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_aak00,g_errno,0)
               LET g_aak00 = g_aak00_t
               DISPLAY g_aak00 TO aak00
               NEXT FIELD aak00
             END IF
          END IF
 
       BEFORE FIELD aak01
          IF cl_null(g_aak00) THEN NEXT FIELD aak00 END IF
          IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
             LET g_aak01 = g_argv1
             DISPLAY g_aak01 TO aak01
             CALL i103_aak01('d')
             NEXT FIELD aak02
          END IF
       #No.FUN-730020  --End  
 
       AFTER FIELD aak01
          IF NOT cl_null(g_aak01) THEN
             IF (g_aak01_t IS NULL) OR (g_aak01_t != g_aak01) THEN
                 CALL i103_aak01('a')
                 IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_aak01,g_errno,0)
                  #Mod No.No.FUN-B10048
                  #LET g_aak01 = g_aak01_t
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.construct = 'N'
                   LET g_qryparam.default1 = g_aak01
                   LET g_qryparam.arg1 = g_aak00
                   LET g_qryparam.where = " aag01 LIKE '",g_aak01 CLIPPED,"%'"
                   CALL cl_create_qry() RETURNING g_aak01
                  #End Mod No.No.FUN-B10048
                   DISPLAY g_aak01 TO aak01
                   NEXT FIELD aak01
                 END IF
             END IF
           END IF
 
       AFTER FIELD aak02
           IF NOT cl_null(g_aak02) THEN
              IF g_aak01 != g_aak01_t OR     #輸入後更改不同時值
                 g_aak01_t IS NULL OR g_aak02 != g_aak02_t OR
                 g_aak02_t IS NULL OR
                 g_aak00 != g_aak00_t OR g_aak00_t IS NULL THEN  #No.FUN-730020
                 SELECT UNIQUE aak01,aak02 FROM aak_file
                        WHERE aak01=g_aak01 AND aak02=g_aak02
                          AND aak00=g_aak00   #No.FUN-730020
                 IF SQLCA.sqlcode THEN             #不存在, 新來的
                    IF p_cmd='a' THEN
                       LET g_ss='N'
                    END IF
                 ELSE
                    IF p_cmd='u' THEN
                       LET l_buf = g_aak00 CLIPPED,'+',g_aak01 clipped,'+',g_aak02 clipped  #No.FUN-730020
                       CALL cl_err(l_buf,-239,0)
                       LET g_aak01=g_aak01_t
                       LET g_aak02=g_aak02_t
                       NEXT FIELD aak00  #No.FUN-730020
                    END IF
                 END IF
               END IF
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION controlp
           CASE
              #No.FUN-730020  --Begin
              WHEN INFIELD(aak00) #帳別  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = g_aak00
                 CALL cl_create_qry() RETURNING g_aak00
                 DISPLAY g_aak00 TO aak00
                 CALL i103_aak00('d')
                 NEXT FIELD aak00
              #No.FUN-730020  --End  
              WHEN INFIELD(aak01) #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_aak01
                 LET g_qryparam.arg1 = g_aak00   #No.FUN-730020
                 CALL cl_create_qry() RETURNING g_aak01
                 DISPLAY g_aak01 TO aak01
                 CALL i103_aak01('d')
                 NEXT FIELD aak01
           END CASE
           #-----TQC-860018---------
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
           
           ON ACTION about         
              CALL cl_about()      
           
           ON ACTION help          
              CALL cl_show_help()  
           
           ON ACTION controlg      
              CALL cl_cmdask()     
           #-----END TQC-860018-----
    END INPUT
END FUNCTION
 
FUNCTION i103_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aak00,aak01,aak02",TRUE)  #No.FUN-730020
    END IF
 
END FUNCTION
 
FUNCTION i103_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aak00,aak01,aak02",FALSE)  #No.FUN-730020
    END IF
 
END FUNCTION
FUNCTION i103_aak01(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
           l_aag02 LIKE aag_file.aag02,
           l_aagacti LIKE aag_file.aagacti
 
    LET g_errno = ' '
    IF g_aak01 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aaguser,aaggrup,
               aagmodu,aagdate,aagacti
           INTO l_aag02,g_aaguser,g_aaggrup,
               g_aagmodu,g_aagdate,g_aagacti
           FROM aag_file WHERE aag01 = g_aak01
                           AND aag00 = g_aak00  #No.FUN-730020
	CASE
            WHEN g_aagacti = 'N' LET g_errno = '9028'
            WHEN STATUS=100      LET g_errno = 'agl-001' #No.7926
            OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_aag02 TO  aag02
    END IF
END FUNCTION
 
#No.FUN-730020  --Begin
FUNCTION i103_aak00(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
           l_aaaacti LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=g_aak00
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-730020  --End  
 
#Query 查詢
FUNCTION i103_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aak00 TO NULL                #No.FUN-730020
    INITIALIZE g_aak01 TO NULL                #No.FUN-6B0040 
    INITIALIZE g_aak02 TO NULL                #No.FUN-6B0040
    INITIALIZE g_aak03 TO NULL                #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_aak.clear()
    CALL i103_curs()                          #取得查詢條件
    IF INT_FLAG THEN                          #使用者不玩了
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i103_b_curs                          #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                     #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_aak00 TO NULL  #No.FUN-730020
       INITIALIZE g_aak01 TO NULL
       INITIALIZE g_aak02 TO NULL
       INITIALIZE g_aak03 TO NULL
    ELSE
       CALL i103_fetch('F')            #讀出TEMP第一筆並顯示
       OPEN i103_count
       FETCH i103_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i103_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i103_b_curs INTO g_aak00,g_aak01,g_aak02  #No.FUN-730020
        WHEN 'P' FETCH PREVIOUS i103_b_curs INTO g_aak00,g_aak01,g_aak02  #No.FUN-730020
        WHEN 'F' FETCH FIRST    i103_b_curs INTO g_aak00,g_aak01,g_aak02  #No.FUN-730020
        WHEN 'L' FETCH LAST     i103_b_curs INTO g_aak00,g_aak01,g_aak02  #No.FUN-730020
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i103_b_curs INTO g_aak00,g_aak01,g_aak02  #No.FUN-730020
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_aak01,SQLCA.sqlcode,0)
        INITIALIZE g_aak00 TO NULL  #No.FUN-730020
        INITIALIZE g_aak01 TO NULL  #TQC-6B0105
        INITIALIZE g_aak02 TO NULL  #TQC-6B0105
    ELSE
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
 
        CALL cl_navigator_setting( g_curs_index, g_row_count )
        SELECT aak00,aak01,aak02 INTO g_aak00,g_aak01,g_aak02 FROM aak_file  #No.FUN-730020
         WHERE aak00=g_aak00 AND aak01=g_aak01 AND aak02=g_aak02  #No.FUN-730020
        IF STATUS=100 THEN
           LET g_aak01=' ' LET g_aak02=' ' LET g_aak00=' '  #No.FUN-730020
        END IF
        CALL i103_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i103_show()
    DISPLAY g_aak00 TO aak00               #No.FUN-730020
    DISPLAY g_aak01 TO aak01               #單頭
    DISPLAY g_aak02 TO aak02               #單頭
    CALL i103_aak00('d')                   #No.FUN-730020
    CALL i103_aak01('d')                   #單身
    CALL i103_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i103_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_aak01 IS NULL OR g_aak00 IS NULL THEN  #No.FUN-730020
       CALL cl_err("",-400,0)                 #No.FUN-6B0040
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "aak00"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_aak00       #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "aak01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_aak01       #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "aak02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_aak02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM aak_file WHERE aak01 = g_aak01 AND aak02 = g_aak02
                               AND aak00 = g_aak00   #No.FUN-730020
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("del","aak_file",g_aak01,g_aak02,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123
        ELSE
            CLEAR FORM
            CALL g_aak.clear()
            CALL g_aak.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            #No.FUN-730020  --Begin
            DROP TABLE x
            PREPARE i103_pre_x2 FROM g_sql_tmp
            EXECUTE i103_pre_x2
            #No.FUN-730020  --End  
            OPEN i103_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i103_b_curs
               CLOSE i103_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i103_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i103_b_curs
               CLOSE i103_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i103_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i103_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i103_fetch('/')
            END IF
 
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i103_b()
DEFINE
    l_ac_t          LIKE type_file.num5,           #未取消的ARRAY CNT #No.FUN-680098 SMALLINT
    l_n             LIKE type_file.num5,           #檢查重複用        #No.FUN-680098 SMALLINT
    l_lock_sw       LIKE type_file.chr1,           #單身鎖住否        #No.FUN-680098 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,           #處理狀態          #No.FUN-680098 VARCHAR(1)   
    l_allow_insert  LIKE type_file.num5,           #可新增否          #No.FUN-680098 SMALLINT
    l_allow_delete  LIKE type_file.num5            #可刪除否          #No.FUN-680098 SMALLINT
 
    LET g_action_choice = ""
    IF g_aak01 IS NULL  AND g_aak00 IS NULL THEN  #No.FUN-730020
        RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT aak03,aak04 FROM aak_file ",
                       " WHERE aak00=? AND aak01= ? AND aak02 = ? AND aak03= ? FOR UPDATE"  #No.FUN-730020
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_aak WITHOUT DEFAULTS FROM s_aak.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
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
               LET g_aak_t.* = g_aak[l_ac].*  #BACKUP
               OPEN i103_bcl USING g_aak00,g_aak01,g_aak02,g_aak_t.aak03  #No.FUN-730020
               IF STATUS THEN
                  CALL cl_err("OPEN i103_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i103_bcl INTO g_aak[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_aak_t.aak04,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_aak[l_ac].* TO NULL      #900423
            LET g_aak_t.* = g_aak[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD aak03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO aak_file(aak00,aak01,aak02,aak03,aak04)  #No.FUN-730020
                          VALUES(g_aak00,g_aak01,g_aak02,g_aak[l_ac].aak03,  #No.FUN-730020
                                 g_aak[l_ac].aak04)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_aak[l_ac].aak03,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("ins","aak_file",g_aak01,g_aak02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD aak03                        # dgeeault 序號
#            IF g_aak[l_ac].aak03 IS NULL OR g_aak[l_ac].aak03 = 0 THEN
             IF cl_null(g_aak[l_ac].aak03) THEN
                SELECT MAX(aak03)+1 INTO g_aak[l_ac].aak03 FROM aak_file
                 WHERE aak01 = g_aak01 AND aak02 = g_aak02
                   AND aak00 = g_aak00   #No.FUN-730020
                IF cl_null(g_aak[l_ac].aak03) THEN
                   LET g_aak[l_ac].aak03 = 1
                END IF
             END IF
 
        AFTER FIELD aak03                        #check 序號是否重複
             IF NOT cl_null(g_aak[l_ac].aak03) THEN
               IF g_aak[l_ac].aak03 != g_aak_t.aak03 OR
                  g_aak_t.aak03 IS NULL THEN
                  SELECT count(*) INTO l_n FROM aak_file
                   WHERE aak01 = g_aak01 AND aak02 = g_aak02
                     AND aak03 = g_aak[l_ac].aak03
                     AND aak00 = g_aak00   #No.FUN-730020
                  IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_aak[l_ac].aak03 = g_aak_t.aak03
                      NEXT FIELD aak03
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_aak_t.aak03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
               DELETE FROM aak_file
                   WHERE aak01 = g_aak01 AND aak02 = g_aak02
                     AND aak00 = g_aak00  #No.FUN-730020
                     AND aak03 = g_aak_t.aak03
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_aak_t.aak03,SQLCA.sqlcode,0)   #No.FUN-660123
                   CALL cl_err3("del","aak_file",g_aak01,g_aak02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               LET g_rec_b = g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aak[l_ac].* = g_aak_t.*
               CLOSE i103_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aak[l_ac].aak03,-263,1)
               LET g_aak[l_ac].* = g_aak_t.*
            ELSE
               UPDATE aak_file SET aak03 = g_aak[l_ac].aak03,
                                   aak04 = g_aak[l_ac].aak04
                WHERE aak01= g_aak01 AND aak02 = g_aak02
                  AND aak00= g_aak00   #No.FUN-730020
                  AND aak03=g_aak_t.aak03
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                  CALL cl_err(g_aak[l_ac].aak03,SQLCA.sqlcode,0)   #No.FUN-660123
                   CALL cl_err3("upd","aak_file",g_aak01,g_aak02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                   LET g_aak[l_ac].* = g_aak_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_aak[l_ac].* = g_aak_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_aak.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE i103_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032
            CLOSE i103_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i103_b_askkey()
#           EXIT INPUT
 
#TQC-740015.....begin
#        ON ACTION CONTROLO                        #沿用所有欄位
#           IF INFIELD(aak03) AND l_ac > 1 THEN
#               LET g_aak[l_ac].* = g_aak[l_ac-1].*
#               LET g_aak[l_ac].aak03 = NULL   #TQC-620018                       
#               NEXT FIELD aak03
#           END IF
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(aak04) AND l_ac > 1 THEN
               LET g_aak[l_ac].* = g_aak[l_ac-1].*
               LET g_aak[l_ac].aak03 = g_rec_b + 1
               NEXT FIELD aak04
           END IF
#TQC-740015.....end
 
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
    CLOSE i103_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i103_b_askkey()
DEFINE
#   l_wc            VARCHAR(200)   
    l_wc            STRING        #TQC-630166    
 
    CONSTRUCT l_wc ON aak03,aak04    #螢幕上取條件
       FROM s_aak[1].aak03,s_aak[1].aak04
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
    CALL i103_b_fill(l_wc)
END FUNCTION
 
FUNCTION i103_b_fill(p_wc)              #BODY FILL UP
DEFINE
#   p_wc           VARCHAR(200)
    p_wc            STRING        #TQC-630166  
 
    LET g_sql =
       "SELECT aak03,aak04 FROM aak_file ",
       " WHERE aak01 = '",g_aak01,"' AND ",
       " aak00 = '",g_aak00,"' AND ",
       " aak02 = '",g_aak02,"' AND ",p_wc CLIPPED ,
       " ORDER BY aak03"
    PREPARE i103_p2 FROM g_sql      #預備一下
    DECLARE aak_curs CURSOR FOR i103_p2
 
    CALL g_aak.clear()
 
    LET g_cnt = 1
    FOREACH aak_curs INTO g_aak[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
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
    CALL g_aak.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aak TO s_aak.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL i103_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i103_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i103_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i103_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i103_fetch('L')
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i103_copy()
DEFINE
    l_aak01,l_oldno1 LIKE aak_file.aak01,
    l_aak02,l_oldno2 LIKE aak_file.aak02,
    l_aak00,l_oldno0 LIKE aak_file.aak00,
    l_aak03          LIKE aak_file.aak03,
    l_aag02          LIKE aag_file.aag02,
    l_aaaacti        LIKE aaa_file.aaaacti,   #No.FUN-730020
    l_n              LIKE type_file.num5,     #No.FUN-730020
    l_buf            LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(40)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aak01 IS NULL OR g_aak00 IS NULL THEN  #No.FUN-730020
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
 
    LET g_before_input_done = FALSE
    CALL i103_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")        #No.FUN-6B0029 
 
    #No.FUN-730020  --Begin
    INPUT l_aak00,l_aak01,l_aak02  WITHOUT DEFAULTS  FROM aak00,aak01,aak02  #No.FUN-730020
 
        AFTER FIELD aak00
           IF cl_null(l_aak00) THEN NEXT FIELD aak00 END IF
           IF NOT cl_null(l_aak00) THEN                                      
               SELECT aaaacti INTO l_aaaacti FROM aaa_file                          
                WHERE aaa01=l_aak00
               IF SQLCA.SQLCODE=100 THEN                                            
                  CALL cl_err3("sel","aaa_file",l_aak00,"",100,"","",1)            
                  NEXT FIELD aak00                                                 
               END IF                                                               
               IF l_aaaacti='N' THEN                                                
                  CALL cl_err(l_aak00,"9028",1)                                    
                  NEXT FIELD aak00                                                 
               END IF                                                               
            END IF
        AFTER FIELD aak01
            IF NOT cl_null(l_aak01) THEN
               SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = l_aak01
                             AND aagacti IN ('Y','y')
                             AND aag00 = l_aak00  #No.FUN-730020
               IF SQLCA.sqlcode != 0 THEN
#                 CALL cl_err(l_aak01,'agl-001',0)   #No.FUN-660123
                  CALL cl_err3("sel","aag_file",l_aak00,l_aak01,SQLCA.sqlcode,"","agl-001",0)  #No.FUN-660123  #No.FUN-730020  #No.FUN-B10048 1->0
                  #Add No.No.FUN-B10048
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = l_aak01
                  LET g_qryparam.arg1 = l_aak00
                  LET g_qryparam.where = " aag01 LIKE '",l_aak01 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING l_aak01
                  #End Add No.No.FUN-B10048
                  NEXT FIELD aak01
               ELSE
                  DISPLAY l_aag02 TO  aag02
               END IF
            END IF
 
        AFTER INPUT
            SELECT COUNT(*) INTO l_n FROM aak_file
             WHERE aak00 = l_aak00 AND aak01 = l_aak01 AND aak02 = l_aak02
            IF l_n > 0 THEN
               CALL cl_err("",-239,1)
               NEXT FIELD aak00
            END IF
            
    #No.FUN-730020  --End   
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aak01)
#                CALL q_aag( FALSE, TRUE, l_aak01,'','','') RETURNING l_aak01
#                CALL FGL_DIALOG_SETBUFFER( l_aak01 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = l_aak01
                 LET g_qryparam.arg1 = l_aak00  #No.FUN-730020
                 CALL cl_create_qry() RETURNING l_aak01
#                 CALL FGL_DIALOG_SETBUFFER( l_aak01 )
                 DISPLAY l_aak01 TO aak01
             #No.FUN-730020  --Begin
              WHEN INFIELD(aak00)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = l_aak00
                 CALL cl_create_qry() RETURNING l_aak00
                 DISPLAY l_aak00 TO aak00
             #No.FUN-730020  --End  
            
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
 
    IF INT_FLAG OR l_aak01 IS NULL OR l_aak00 IS NULL THEN  #No.FUN-730020
       LET INT_FLAG = 0
       RETURN
    END IF
 
    SELECT count(*) INTO g_cnt FROM aak_file
     WHERE aak01 = l_aak01 and aak02 = l_aak02
       AND aak00 = l_aak00   #No.FUN-730020
    IF g_cnt > 0 THEN
        CALL cl_err(l_aak01,-239,0)
        RETURN
    END IF
 
    LET l_buf = l_aak00 CLIPPED,'+',l_aak01 clipped,'+',l_aak02 clipped
    DROP TABLE x   #No.FUN-730020
    SELECT * FROM aak_file
        WHERE aak01 = g_aak01 AND aak02 = g_aak02
          AND aak00 = g_aak00   #No.FUN-730020
        INTO TEMP x
    UPDATE x
        SET aak01=l_aak01,    #資料鍵值
            aak00=l_aak00,    #No.FUN-730020
            aak02=l_aak02
    INSERT INTO aak_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_buf,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","aak_file",l_aak01,l_aak02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
    ELSE
        MESSAGE 'ROW(',l_buf,') O.K'
        LET l_oldno1= g_aak01
        LET l_oldno2= g_aak02
        LET l_oldno0= g_aak00  #No.FUN-730020
       
        LET g_aak00 = l_aak00  #No.FUN-730020
        LET g_aak01 = l_aak01
        LET g_aak02 = l_aak02
      # CALL i103_u()
        CALL i103_b()
        #FUN-C30027---begin
        #LET g_aak00 = l_oldno0  #No.FUN-730020
        #LET g_aak01 = l_oldno1
        #LET g_aak02 = l_oldno2
        #CALL i103_show()
        #FUN-C30027---end
    END IF
END FUNCTION
 
FUNCTION i103_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680098 SMALLINT
    sr              RECORD
        aak00       LIKE aak_file.aak00,   #No.FUN-730020
        aak01       LIKE aak_file.aak01,   #會計科目
        aag02       LIKE aag_file.aag02,   #科目名稱
        aagacti     LIKE aag_file.aagacti, #有效碼
        aak02       LIKE aak_file.aak02,   #類別
        aak03       LIKE aak_file.aak03,   #行序
        aak04       LIKE aak_file.aak04    #額外說明
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name        #No.FUN-680098 VARCHAR(20)
    l_za05          LIKE za_file.za05      #No.FUN-680098   VARCHAR(40)
 
    #No.FUN-730020  --Begin
    IF not cl_null(g_argv0) THEN
       LET g_wc = " aak00 ='",g_argv0,"'" CLIPPED
    END IF
    #No.FUN-730020  --End  
    IF not cl_null(g_argv1) THEN
       LET g_wc = " aak01 ='",g_argv1,"'" CLIPPED
    END IF
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('agli103') RETURNING l_name                #No.FUN-760085
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'agli103'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT aak00,aak01,aag02,aagacti,aak02,aak03,aak04",  #No.FUN-730020
              " FROM aag_file,aak_file",
              " WHERE aag01=aak01 AND ",g_wc CLIPPED,
              "   AND aag00=aak00"   #No.FUN-730020
    #No.FUN-760085---Begin
    #PREPARE i103_p1 FROM g_sql                # RUNTIME 編譯
    #IF SQLCA.sqlcode THEN
    #   CALL cl_err('prepare:',SQLCA.sqlcode,0) 
    #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
    #   EXIT PROGRAM
          
    #END IF
    #DECLARE i103_co CURSOR FOR i103_p1
 
    #START REPORT i103_rep TO l_name
 
    #FOREACH i103_co INTO sr.*
    #   IF SQLCA.sqlcode THEN
    #       CALL cl_err('foreach:',SQLCA.sqlcode,1)
    #       EXIT FOREACH
    #   END IF
    #   OUTPUT TO REPORT i103_rep(sr.*)
    #END FOREACH
 
    #FINISH REPORT i103_rep
 
    #CLOSE i103_co
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'aak00,aak02,aak03,aak04')         
            RETURNING g_str                                                     
    END IF
    CALL cl_prt_cs1('agli103','agli103',g_sql,g_str)
    #MESSAGE ""
    #No.FUN-760085---End
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i103_rep(sr)
DEFINE
    l_trailer_sw   LIKE type_file.chr1,        #No.FUN-680098    VARCHAR(1)
    l_sw           LIKE type_file.chr1,        #No.FUN-680098    VARCHAR(1)
    l_sw1          LIKE type_file.chr1,        #No.FUN-680098    VARCHAR(1) 
    l_i            LIKE type_file.num5,        #No.FUN-680098   SMALLINT
    sr              RECORD
        aak00       LIKE aak_file.aak00,   #No.FUN-730020
        aak01       LIKE aak_file.aak01,   #會計科目
        aag02       LIKE aag_file.aag02,   #科目名稱
        aagacti     LIKE aag_file.aagacti, #有效碼
        aak02       LIKE aak_file.aak02,   #類別
        aak03       LIKE aak_file.aak03,   #行序
        aak04       LIKE aak_file.aak04    #額外說明
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.aak00,sr.aak01,sr.aak02,sr.aak03  #No.FUN-730020
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            #PRINT g_x[2] CLIPPED,g_today USING 'yy/mm/dd',' ',TIME, #FUN-570250 mark
            PRINT g_x[2] CLIPPED,g_today,' ',TIME, #FUN-570250 add
                COLUMN g_len-10,g_x[3] CLIPPED,5 SPACES,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
 
        #No.FUN-730020  --Begin
        BEFORE GROUP OF sr.aak00
            PRINT COLUMN 5,g_x[13];
          
        BEFORE GROUP OF sr.aak01
            PRINT COLUMN 13,g_x[11]
            PRINT COLUMN 5,"------- ------------------------ ",
#FUN-590124
                           "-------------------------------------------------- "
            IF sr.aagacti = 'N' THEN PRINT '*'; END IF
            PRINT COLUMN 5,sr.aak00,COLUMN 13,sr.aak01,COLUMN 38,sr.aag02
#FUN-590124 End
        #No.FUN-730020  --End  
            PRINT ' '
 
        BEFORE GROUP OF sr.aak02
            PRINT COLUMN 36,g_x[12] CLIPPED
            PRINT COLUMN 36,"----  ---- ------------------------------"
            PRINT COLUMN 36,sr.aak02;
 
        ON EVERY ROW
            PRINT COLUMN 42,sr.aak03 using '###&','  ',sr.aak04 clipped
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,103
               #TQC-630166
               #IF g_wc[001,080] > ' ' THEN
 	       #		  PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
               #IF g_wc[071,140] > ' ' THEN
 	       #       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
               #IF g_wc[141,210] > ' ' THEN
 	       #		  PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
               CALL cl_prt_pos_wc(g_wc)
               PRINT g_dash[1,g_len]
            END IF
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-760085---End
#Patch....NO.TQC-610035 <001> #
