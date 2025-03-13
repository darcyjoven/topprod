# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acoi900.4gl
# Descriptions...: 擷取條件設定維護作業
# Input parameter:
# Date & Author..: 03/08/29 By Carrier
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 05/02/25 By Carrier 新增cnz02='3'的類型
# Modify.........: NO.FUN-570129 05/08/05 BY yiting 單身只有行序時只能放棄才能離
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: NO.FUN-570250 05/12/22 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-650044 06/05/15 By Echo 憑證類的報表因報表寬度(p_zz)為0或NULL,導致報表當掉
# MOdify.........: No.TQC-660045 06/06/09 BY hellen  cl_err --> cl_err3
# Modify.........: No.FUN-670066 06/07/18 By xumin voucher型報表轉template1
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0"
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770006 07/07/06 By zhoufeng 報表輸出改為Crystal Reports
# Modify.........: No.TQC-860021 08/06/11 By Sarah INPUT漏了ON IDLE控制
 
# Modify.........: No.FUN-980014 09/09/04 By rainy cnz01 always default g_plant，且畫面隱藏不讓user輸入
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cnz01         LIKE cnz_file.cnz01,   #科目編號 (假單頭)
    g_cnz01_t       LIKE cnz_file.cnz01,   #科目編號 (舊值)
    g_cnz02         LIKE cnz_file.cnz02,   #說明類別
    g_cnz02_t       LIKE cnz_file.cnz02,   #
    g_cnz03         LIKE cnz_file.cnz03,   #行序
    g_cnz03_t       LIKE cnz_file.cnz03,   #行序(舊值)
    g_cnz           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cnz03       LIKE cnz_file.cnz03,   #行序
        cnz04       LIKE cnz_file.cnz04,   #說明
        cnz05       LIKE cnz_file.cnz05    #說明
                    END RECORD,
    g_cnz_t         RECORD                 #程式變數 (舊值)
        cnz03       LIKE cnz_file.cnz03,   #行序
        cnz04       LIKE cnz_file.cnz04,   #說明
        cnz05       LIKE cnz_file.cnz05    #說明
                    END RECORD,
    g_argv1         LIKE cnz_file.cnz01,
    g_cnzuser       LIKE cnz_file.cnzuser,
    g_cnzgrup       LIKE cnz_file.cnzgrup,
    g_cnzmodu       LIKE cnz_file.cnzmodu,
    g_cnzdate       LIKE cnz_file.cnzdate,
    g_cnzacti       LIKE cnz_file.cnzacti,
    g_ss            LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(01)
   #g_wc,g_sql      STRING, #TQC-630166        #No.FUN-680069
    g_wc,g_sql      STRING,    #TQC-630166        #No.FUN-680069
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_sl            LIKE type_file.num5         #No.FUN-680069 SMALLINT #目前處理的SCREEN LINE
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
 
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680069 INTEGER
#CKP3
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_str           STRING                       #No.FUN-770006
DEFINE   l_table         STRING                       #No.FUN-770006
 
MAIN
#     DEFINEl_time LIKE type_file.chr8                #No.FUN-6A0063
DEFINE p_row,p_col       LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
#No.FUN-770006 --start--
   LET g_sql="cnz01.cnz_file.cnz01,ze03.ze_file.ze03,cnz03.cnz_file.cnz03,",
             "cnz04.cnz_file.cnz04,cnz05.cnz_file.cnz05,cnz02.cnz_file.cnz02,",
             "cnz01_1.cnz_file.cnz01"
   LET l_table = cl_prt_temptable('acoi900',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-770006 --end--
 
    LET g_cnz02 =   NULL                   #清除鍵值
    LET g_cnz01_t = NULL
    LET g_cnz02_t = NULL
    LET g_argv1 = ARG_VAL(1)
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW i900_w AT p_row,p_col WITH FORM "aco/42f/acoi900"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("cnz01",FALSE)  #FUN-980014 add
 
    CALL i900_menu()
    CLOSE WINDOW i900_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION i900_curs()
    CLEAR FORM                             #清除畫面
    CALL g_cnz.clear()
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       LET g_cnz01 =  g_argv1
       DISPLAY g_cnz01 TO cnz01
       CALL i900_cnz01('d')
       CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
   INITIALIZE g_cnz01 TO NULL    #No.FUN-750051
   INITIALIZE g_cnz02 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON cnz02,cnz03,cnz04,cnz05,   #螢幕上取條件
                 cnzuser,cnzgrup,cnzmodu,cnzdate,cnzacti
         FROM cnz02,s_cnz[1].cnz03,s_cnz[1].cnz04,s_cnz[1].cnz05,
              cnzuser,cnzgrup,cnzmodu,cnzdate,cnzacti
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnzuser', 'cnzgrup') #FUN-980030
       LET g_wc = g_wc CLIPPED," AND cnz01 ='",g_argv1,"'"
       IF INT_FLAG THEN
          RETURN
       END IF
    ELSE
       CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
       CONSTRUCT g_wc ON cnz01,cnz02,cnz03,cnz04,cnz05,   #螢幕上取條件
                      cnzuser,cnzgrup,cnzmodu,cnzdate,cnzacti
            FROM cnz01,cnz02,s_cnz[1].cnz03,s_cnz[1].cnz04,s_cnz[1].cnz05,
                 cnzuser,cnzgrup,cnzmodu,cnzdate,cnzacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON ACTION CONTROLP
              CASE
                   WHEN INFIELD(cnz01) #科目編號
                        CALL cl_init_qry_var()
                        LET g_qryparam.state ="c"
                        LET g_qryparam.form ="q_azp"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO cnz01
                        NEXT FIELD cnz01
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
    END IF
    LET g_sql= "SELECT UNIQUE cnz01,cnz02 FROM cnz_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i900_prepare FROM g_sql      #預備一下
    DECLARE i900_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i900_prepare
 
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
#   LET g_sql="SELECT DISTINCT cnz01,cnz02 ",      #No.TQC-720019
    LET g_sql_tmp="SELECT DISTINCT cnz01,cnz02 ",  #No.TQC-720019
              " FROM cnz_file WHERE ", g_wc CLIPPED," INTO TEMP x"
#   PREPARE i900_precount_x  FROM g_sql      #No.TQC-720019
    PREPARE i900_precount_x  FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i900_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i900_precount FROM g_sql
    DECLARE i900_count CURSOR FOR  i900_precount
 
END FUNCTION
 
FUNCTION i900_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100)
 
   WHILE TRUE
      CALL i900_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i900_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i900_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i900_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i900_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i900_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i900_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"                      #TQC-650044
            CALL i900_out()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cnz),'','')
             END IF
         #--
        #No.FUN-6A0168-------add--------str----
          WHEN "related_document"           #相關文件
           IF cl_chk_act_auth() THEN
              IF g_cnz01 IS NOT NULL THEN
                 LET g_doc.column1 = "cnz01"
                 LET g_doc.column2 = "cnz02"
                 LET g_doc.value1 = g_cnz01
                 LET g_doc.value2 = g_cnz02
                 CALL cl_doc()
              END IF 
           END IF
        #No.FUN-6A0168-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i900_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_cnz.clear()
    INITIALIZE g_cnz01 LIKE cnz_file.cnz01
    INITIALIZE g_cnz02 LIKE cnz_file.cnz02
    LET g_cnz01_t = NULL
    LET g_cnz02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cnzuser = g_user
        LET g_cnzgrup = g_grup
        LET g_cnzmodu = ''
        LET g_cnzdate = g_today
        LET g_cnzacti = "Y"
        LET g_cnz02 = '1'
        LET g_cnz01 = ' '  #FUN-980014 add
 
        CALL i900_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            LET g_cnz01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            FOR g_cnt = 1 TO g_cnz.getLength()
                INITIALIZE g_cnz[g_cnt].* TO NULL
            END FOR
            LET g_rec_b=0
        ELSE
            CALL i900_b_fill('1=1')          #單身
        END IF
        CALL i900_b()                        #輸入單身
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_cnz01,SQLCA.sqlcode,0)
        END IF
        LET g_cnz01_t = g_cnz01                 #保留舊值
        LET g_cnz02_t = g_cnz02                 #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i900_u()
  DEFINE  l_buf      LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(30)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_chkey = 'N' THEN
       CALL cl_err(g_cnz01,'aoo-085',0)
       RETURN
    END IF
    IF cl_null(g_cnz01)  THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cnz01_t = g_cnz01
    LET g_cnz02_t = g_cnz02
    BEGIN WORK
    WHILE TRUE
        LET g_cnzmodu = g_user
        LET g_cnzdate = g_today
        CALL i900_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_cnz01=g_cnz01_t
            LET g_cnz02=g_cnz02_t
            DISPLAY g_cnz01 TO cnz01               #單頭
            DISPLAY g_cnz02 TO cnz02               #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cnz01 != g_cnz01_t OR g_cnz02 != g_cnz02_t
           THEN   UPDATE cnz_file SET cnz01 = g_cnz01,  #更新DB
                                      cnz02 = g_cnz02,
                                      cnzmodu = g_cnzmodu,
                                      cnzdate = g_cnzdate
                WHERE cnz01 = g_cnz01_t AND cnz02 = g_cnz02_t
            IF SQLCA.sqlcode THEN
                LET l_buf = g_cnz01 clipped,'+',g_cnz02 clipped
#               CALL cl_err(l_buf,SQLCA.sqlcode,0) #No.TQC-660045
                CALL cl_err3("upd","cnz_file",g_cnz01_t,g_cnz02_t,SQLCA.sqlcode,"","",1) #TQC-660045
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i900_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
    l_buf           LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(60)
    l_n             LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    LET g_ss = 'Y'
    #No:8392
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
    DISPLAY g_cnz01,g_cnz02,g_cnzuser,g_cnzgrup,g_cnzmodu,g_cnzdate,g_cnzacti
    TO      cnz01,cnz02,cnzuser,cnzgrup,cnzmodu,cnzdate,cnzacti
    INPUT g_cnz01,g_cnz02 WITHOUT DEFAULTS FROM cnz01,cnz02
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i900_set_entry(p_cmd)
           CALL i900_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
{
       BEFORE FIELD cnz01    #本系統不允許更改key
          IF p_cmd = 'u' AND g_chkey = 'N' THEN
             EXIT INPUT
          END IF
}
       AFTER FIELD cnz01
           IF NOT cl_null(g_cnz01) THEN
              IF (g_cnz01_t IS NULL) OR (g_cnz01_t != g_cnz01) THEN
                   CALL i900_cnz01('a')
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cnz01,g_errno,0)
                     LET g_cnz01 = g_cnz01_t
                     DISPLAY g_cnz01 TO cnz01
                     NEXT FIELD cnz01
                   END IF
               END IF
           END IF
 
       AFTER FIELD cnz02
            IF NOT cl_null(g_cnz02) THEN
                #No.MOD-490398  --begin
               #IF g_cnz02 NOT MATCHES '[12]' THEN
               #   NEXT FIELD cnz02
               #END IF
                #No.MOD-490398  --end
               IF g_cnz01 != g_cnz01_t OR     #輸入後更改不同時值
                  g_cnz01_t IS NULL OR g_cnz02 != g_cnz02_t OR
                  g_cnz02_t IS NULL THEN
                  SELECT UNIQUE cnz01,cnz02 FROM cnz_file
                         WHERE cnz01=g_cnz01 AND cnz02=g_cnz02
                  IF SQLCA.sqlcode THEN             #不存在, 新來的
                     IF p_cmd='a' THEN
                        LET g_ss='N'
                     END IF
                  ELSE
                     IF p_cmd='u' THEN
                        LET l_buf = g_cnz01 clipped,'+',g_cnz02 clipped
                        CALL cl_err(l_buf,-239,0)
                        LET g_cnz01=g_cnz01_t
                        LET g_cnz02=g_cnz02_t
                        NEXT FIELD cnz01
                     END IF
                  END IF
               END IF
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
          CASE
               WHEN INFIELD(cnz01) #科目編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azp"
                    LET g_qryparam.default1 = g_cnz01
                    CALL cl_create_qry() RETURNING g_cnz01
#                    CALL FGL_DIALOG_SETBUFFER( g_cnz01 )
                    DISPLAY g_cnz01 TO cnz01
		    CALL i900_cnz01('d')
                    NEXT FIELD cnz01
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
END FUNCTION
 
FUNCTION i900_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cnz01",TRUE)
    END IF
 
END FUNCTION
FUNCTION i900_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cnz01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i900_cnz01(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT * FROM azp_file
     WHERE azp01 = g_cnz01
    #No:8392 031001
    CASE    WHEN SQLCA.sqlcode=100 LET g_errno = '100'
            OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
END FUNCTION
 
#Query 查詢
FUNCTION i900_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cnz01 TO NULL           #No.FUN-6A0168
    INITIALIZE g_cnz02 TO NULL           #No.FUN-6A0168
    INITIALIZE g_cnz03 TO NULL           #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cnz.clear()
    CALL i900_curs()                    #取得查詢條件
    IF INT_FLAG THEN                       #用戶不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i900_cs                    #從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cnz01 TO NULL
        INITIALIZE g_cnz02 TO NULL
        INITIALIZE g_cnz03 TO NULL
    ELSE
        CALL i900_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN i900_count
        FETCH i900_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i900_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i900_cs INTO g_cnz01,g_cnz02
        WHEN 'P' FETCH PREVIOUS i900_cs INTO g_cnz01,g_cnz02
        WHEN 'F' FETCH FIRST    i900_cs INTO g_cnz01,g_cnz02
        WHEN 'L' FETCH LAST     i900_cs INTO g_cnz01,g_cnz02
        WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i900_cs INTO g_cnz01,g_cnz02
         LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_cnz01,SQLCA.sqlcode,0)
        INITIALIZE g_cnz01 TO NULL  #TQC-6B0105
        INITIALIZE g_cnz02 TO NULL  #TQC-6B0105
    ELSE
        SELECT UNIQUE cnzuser,cnzgrup,cnzmodu,cnzdate,cnzacti
          INTO g_cnzuser,g_cnzgrup,g_cnzmodu,g_cnzdate,g_cnzacti
          FROM cnz_file
         WHERE cnz01 = g_cnz01 AND cnz02 = g_cnz02
         OPEN i900_count
         FETCH i900_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
 
        CALL i900_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i900_show()
    DISPLAY g_cnz01 TO cnz01               #單頭
    DISPLAY g_cnz02 TO cnz02               #單頭
    DISPLAY g_cnzuser,g_cnzgrup,g_cnzmodu,g_cnzdate,g_cnzacti
    TO      cnzuser,cnzgrup,cnzmodu,cnzdate,cnzacti
    CALL i900_cnz01('d')
    CALL i900_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION i900_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cnz01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6A0168
       RETURN
    END IF
    IF g_cnzacti = 'N' THEN
       CALL cl_err(g_cnz01,'mfg1000',0)
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cnz01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "cnz02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cnz01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_cnz02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM cnz_file WHERE cnz01 = g_cnz01 AND cnz02 = g_cnz02
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("del","cnz_file",g_cnz01,g_cnz02,SQLCA.sqlcode,"","BODY DELETE",1) #TQC-660045
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i900_precount_x                  #No.TQC-720019
            PREPARE i900_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i900_precount_x2                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_cnz.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            #CKP3
            DROP TABLE x
            EXECUTE i900_precount_x
            OPEN i900_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i900_cs
               CLOSE i900_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i900_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i900_cs
               CLOSE i900_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i900_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i900_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i900_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i900_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF g_cnz01 IS NULL  THEN
        RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT cnz03,cnz04,cnz05 ",
                       " FROM cnz_file  ",
                       " WHERE cnz01= ? AND cnz02 =?  ",
                       "   AND cnz03= ? ",
                       " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        #CKP2
        IF g_rec_b=0 THEN CALL g_cnz.clear() END IF
 
        INPUT ARRAY g_cnz WITHOUT DEFAULTS FROM s_cnz.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cnz_t.* = g_cnz[l_ac].*  #BACKUP
                OPEN i900_bcl USING g_cnz01,g_cnz02,g_cnz_t.cnz03
                IF STATUS THEN
                   CALL cl_err("OPEN i900_bcl:", STATUS, 1)
                   CLOSE i900_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i900_bcl INTO g_cnz[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cnz_t.cnz04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_cnz_t.*=g_cnz[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD cnz03
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_cnz[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_cnz[l_ac].* TO s_cnz.*
              CALL g_cnz.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO cnz_file(cnz01,cnz02,cnz03,cnz04,cnz05,
                   cnzuser,cnzgrup,cnzmodu,cnzdate,cnzacti,cnzoriu,cnzorig)
            VALUES(g_cnz01,g_cnz02,g_cnz[l_ac].cnz03,
                   g_cnz[l_ac].cnz04,g_cnz[l_ac].cnz05,g_cnzuser,
                   g_cnzgrup,g_cnzmodu,g_cnzdate,g_cnzacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cnz[l_ac].cnz03,SQLCA.sqlcode,0) #No.TQC-660045
               CALL cl_err3("ins","cnz_file",g_cnz01,g_cnz02,SQLCA.sqlcode,"","",1) #TQC-660045
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_cnz[l_ac].* TO NULL      #900423
            LET g_cnz_t.* = g_cnz[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnz03
 
        BEFORE FIELD cnz03                        # dgeeault 序號
            IF g_cnz[l_ac].cnz03 IS NULL OR g_cnz[l_ac].cnz03 = 0 THEN
                SELECT max(cnz03)+1 INTO g_cnz[l_ac].cnz03 FROM cnz_file
                    WHERE cnz01 = g_cnz01 AND cnz02 = g_cnz02
                IF g_cnz[l_ac].cnz03 IS NULL THEN
                    LET g_cnz[l_ac].cnz03 = 1
                END IF
                 #NO.MOD-570129 MARK
                #DISPLAY g_cnz[l_ac].cnz03 TO cnz03
            END IF
 
        AFTER FIELD cnz03                        #check 序號是否重複
            IF g_cnz[l_ac].cnz03 IS NOT NULL AND
               (g_cnz[l_ac].cnz03 != g_cnz_t.cnz03 OR
                g_cnz_t.cnz03 IS NULL) THEN
                SELECT count(*) INTO l_n FROM cnz_file
                    WHERE cnz01 = g_cnz01 AND cnz02 = g_cnz02
                       AND cnz03 = g_cnz[l_ac].cnz03
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_cnz[l_ac].cnz03 = g_cnz_t.cnz03
                    DISPLAY g_cnz[l_ac].cnz03 TO cnz03
                    NEXT FIELD cnz03
                END IF
            END IF
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_cnz_t.cnz03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cnz_file
                    WHERE cnz01 = g_cnz01 AND cnz02 = g_cnz02
                      AND cnz03 = g_cnz_t.cnz03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cnz_t.cnz03,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","cnz_file",g_cnz01,g_cnz02,SQLCA.sqlcode,"","",1) #TQC-660045
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
               LET g_cnz[l_ac].* = g_cnz_t.*
               CLOSE i900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cnz[l_ac].cnz03,-263,1)
               LET g_cnz[l_ac].* = g_cnz_t.*
            ELSE
               UPDATE cnz_file SET
                      cnz03=g_cnz[l_ac].cnz03,cnz04=g_cnz[l_ac].cnz04,
                      cnz05=g_cnz[l_ac].cnz05,cnzuser=g_cnzuser,
                      cnzgrup=g_cnzgrup,cnzmodu=g_cnzmodu,
                      cnzdate=g_cnzdate,cnzacti=g_cnzacti
               WHERE cnz01= g_cnz01 AND cnz02 = g_cnz02
                 AND cnz03=g_cnz_t.cnz03
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_cnz[l_ac].cnz03,SQLCA.sqlcode,0) #No.TQC-660045
                   CALL cl_err3("upd","cnz_file",g_cnz01,g_cnz02,SQLCA.sqlcode,"","",1) #TQC-660045
                   LET g_cnz[l_ac].* = g_cnz_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_cnz[l_ac].* = g_cnz_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cnz.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE i900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #CKP
           #LET g_cnz_t.* = g_cnz[l_ac].*          # 900423
            LET l_ac_t = l_ac     #FUN-D30034 Add
           CLOSE i900_bcl
           COMMIT WORK
           #CKP2
          #CALL g_cnz.deleteElement(g_rec_b+1)     #FUN-D30034 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cnz03) AND l_ac > 1 THEN
                LET g_cnz[l_ac].* = g_cnz[l_ac-1].*
                NEXT FIELD cnz03
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
        #FUN-5B0043-begin
         UPDATE cnz_file SET cnzmodu = g_user,cnzdate = g_today
         WHERE cnz01 = g_cnz01
         DISPLAY g_user,g_today TO cnzmodu,cnzdate
        #FUN-5B0043-end
 
        CLOSE i900_bcl
END FUNCTION
 
FUNCTION i900_b_askkey()
DEFINE
   #l_wc            STRING #TQC-630166        #No.FUN-680069
    l_wc            STRING    #TQC-630166        #No.FUN-680069
 
    CONSTRUCT l_wc ON cnz03,cnz04,cnz05    #螢幕上取條件
       FROM s_cnz[1].cnz03,s_cnz[1].cnz04,s_cnz[1].cnz05
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
    CALL i900_b_fill(l_wc)
END FUNCTION
 
FUNCTION i900_b_fill(p_wc)              #BODY FILL UP
DEFINE
   #p_wc            STRING #TQC-630166        #No.FUN-680069
    p_wc            STRING    #TQC-630166        #No.FUN-680069
 
    LET g_sql =
       " SELECT cnz03,cnz04,cnz05 ",
       " FROM cnz_file ",
       " WHERE cnz01 = '",g_cnz01,"' AND ",
       " cnz02 = '",g_cnz02,"' AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i900_p2 FROM g_sql      #預備一下
    DECLARE cnz_curs CURSOR FOR i900_p2
    CALL g_cnz.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cnz_curs INTO g_cnz[g_cnt].*   #單身 ARRAY 填充
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
    #CKP
    CALL g_cnz.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cnz TO s_cnz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i900_fetch('L')
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
 
      ON ACTION output                             #TQC-650044
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0023
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0168  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY   
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i900_copy()
DEFINE
    l_cnz01,l_oldno1 LIKE cnz_file.cnz01,
    l_cnz02,l_oldno2 LIKE cnz_file.cnz02,
    l_cnz03          LIKE cnz_file.cnz03,
    l_azp02          LIKE azp_file.azp02,
    l_buf            LIKE type_file.chr1000     #No.FUN-680069 VARCHAR(40)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cnz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    LET g_before_input_done = FALSE
    CALL i900_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
    LET l_cnz01 = ' '   #FUN-980014 add
 
    INPUT l_cnz01,l_cnz02  WITHOUT DEFAULTS
        FROM cnz01,cnz02
 
       AFTER FIELD cnz01
          IF NOT cl_null(l_cnz01) THEN
             SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = l_cnz01
             IF SQLCA.sqlcode != 0 THEN
#               CALL cl_err(l_cnz01,SQLCA.sqlcode,0) #No.TQC-660045
                CALL cl_err3("sel","azp_file",l_cnz01,"",SQLCA.sqlcode,"","",1) #TQC-660045
                NEXT FIELD cnz01
             END IF
          END IF
 
       ON ACTION CONTROLP
          CASE WHEN INFIELD(cnz01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 =l_cnz01
               CALL cl_create_qry() RETURNING l_cnz01
               DISPLAY l_cnz01 TO cnz01
          END CASE
 
       ON ACTION controlg       #TQC-860021
          CALL cl_cmdask()      #TQC-860021
 
       ON IDLE g_idle_seconds   #TQC-860021
          CALL cl_on_idle()     #TQC-860021
          CONTINUE INPUT        #TQC-860021
 
       ON ACTION about          #TQC-860021
          CALL cl_about()       #TQC-860021
 
       ON ACTION help           #TQC-860021
          CALL cl_show_help()   #TQC-860021
    END INPUT
    IF INT_FLAG OR l_cnz01 IS NULL THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    SELECT count(*) INTO g_cnt FROM cnz_file
        WHERE cnz01 = l_cnz01 and cnz02 = l_cnz02
    IF g_cnt > 0 THEN
        CALL cl_err(l_cnz01,-239,0)
        RETURN
    END IF
    LET l_buf = l_cnz01 clipped,'+',l_cnz02 clipped
    DROP TABLE x
    IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) RETURN END IF
    SELECT * FROM cnz_file
        WHERE cnz01 = g_cnz01 AND cnz02 = g_cnz02
        INTO TEMP x
    UPDATE x
        SET cnz01=l_cnz01,    #資料鍵值
            cnz02=l_cnz02
    INSERT INTO cnz_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_buf,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("ins","cnz_file",l_cnz01,l_cnz02,SQLCA.sqlcode,"","",1) #TQC-660045
    ELSE
        MESSAGE 'ROW(',l_buf,') O.K'
        sleep 1
        LET l_oldno1= g_cnz01
        LET l_oldno2= g_cnz02
        LET g_cnz01 = l_cnz01
        LET g_cnz02 = l_cnz02
        CALL i900_b()
        #LET g_cnz01 = l_oldno1  #FUN-C30027
        #LET g_cnz02 = l_oldno2  #FUN-C30027
        #CALL i900_show()        #FUN-C30027
    END IF
END FUNCTION
 
FUNCTION i900_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    sr              RECORD
        cnz01       LIKE cnz_file.cnz01,   #會計科目
        cnz02       LIKE cnz_file.cnz02,   #類別
        cnz03       LIKE cnz_file.cnz03,   #行序
        cnz04       LIKE cnz_file.cnz04,   #額外說明
        cnz05       LIKE cnz_file.cnz05    #額外說明
                    END RECORD,
    l_name          LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20)   #External(Disk) file name
    l_za05          LIKE cob_file.cob01          #No.FUN-680069 VARCHAR(40)
DEFINE
    l_chrs          LIKE ze_file.ze03,           #No.FUN-770006
    l_cnz01         LIKE cnz_file.cnz01,         #No.FUN-770006
    l_sql           LIKE type_file.chr1000       #No.FUN-770006
 
    CALL cl_del_data(l_table)                    #No.FUN-770006
    LET l_cnz01 = ' '                            #No.FUN-770006
 
    IF not cl_null(g_argv1) THEN
       LET g_wc = " cnz01 ='",g_argv1,"'" CLIPPED
    END IF
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#   CALL cl_outnam('acoi900') RETURNING l_name   #No.FUN-770006
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
  
# No.FUN-670066-begin
#    DECLARE i900_za_cur CURSOR FOR
#            SELECT za02,za05 FROM za_file
#             WHERE za01 = "acoi900" AND za03 = g_lang
#    FOREACH i900_za_cur INTO g_i,l_za05
#       LET g_x[g_i] = l_za05
#    END FOREACH}
# No.FUN-670066-end
 
#No.FUN-670066-Begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'acoi900'   
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 102 END IF #TQC-650044    
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR   
#No.FUN-670066-End
    LET g_sql="SELECT cnz01,cnz02,cnz03,cnz04,cnz05",
              " FROM cnz_file",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY cnz01"               #No.FUN-770006
    PREPARE i900_p1 FROM g_sql                # RUNTIME 編譯
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,0) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
          
    END IF
    DECLARE i900_co CURSOR FOR i900_p1
 
#   START REPORT i900_rep TO l_name           #No.FUN-770006
 
    FOREACH i900_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#       OUTPUT TO REPORT i900_rep(sr.*)       #No.FUN-770006
#No.FUN-770006 --start--
        CASE sr.cnz02
             WHEN '1' LET l_chrs= cl_getmsg('aco-214',g_lang)
             WHEN '2' LET l_chrs= cl_getmsg('aco-215',g_lang)
             WHEN '3' LET l_chrs= cl_getmsg('aco-216',g_lang)
        END CASE
        EXECUTE insert_prep USING sr.cnz01,l_chrs,sr.cnz03,sr.cnz04,
                                  sr.cnz05,sr.cnz02,l_cnz01
        LET l_cnz01 = sr.cnz01
#No.FUN-770006 --end--
    END FOREACH
 
#   FINISH REPORT i900_rep                    #No.FUN-770006
 
    CLOSE i900_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)         #No.FUN-770006
#No.FUN-770006 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    LET g_str = g_wc
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('acoi900','acoi900',l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT i900_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
    l_sw            LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
    l_sw1           LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
    l_first         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
    l_chrs          LIKE ze_file.ze03,           #No.FUN-680069 VARCHAR(40)  #MOD-490398
    sr              RECORD
        cnz01       LIKE cnz_file.cnz01,   #會計科目
        cnz02       LIKE cnz_file.cnz02,   #類別
        cnz03       LIKE cnz_file.cnz03,   #行序
        cnz04       LIKE cnz_file.cnz04,   #額外說明
        cnz05       LIKE cnz_file.cnz05    #額外說明
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.cnz01,sr.cnz02,sr.cnz03
 
    FORMAT
        PAGE HEADER
        #No.FUN-670066-begin
          #  PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
          #  PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
          #  PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
          #  PRINT ' '
          #  #PRINT g_x[2] CLIPPED,g_today USING 'yy/mm/dd',' ',TIME,#FUN-570250 mark
          #  PRINT g_x[2] CLIPPED,g_today,' ',TIME, #FUN-570250 add
          #      COLUMN g_len-10,g_x[3] CLIPPED,5 SPACES,PAGENO USING '<<<'
          #  PRINT g_dash[1,g_len]
          #  PRINT COLUMN  1,g_x[11] CLIPPED,COLUMN 13,g_x[12] CLIPPED,
          #        COLUMN 38,g_x[13] CLIPPED,COLUMN 44,g_x[14] CLIPPED
          #  PRINT '----------  -----------------------  ----  ',
          #        '-----------------------------------------------------------'
          #  LET l_trailer_sw = 'y'
       
           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED                                                  
            LET g_pageno = g_pageno + 1                                                                                                     
            LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                                 
            PRINT g_head CLIPPED,pageno_total 
                                                      
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]                                                                         
            PRINT ' '                                                                                                               
            PRINT g_dash[1,g_len]                                                                                                   
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35] 
            PRINT  g_dash1                                                   
                                                        
            LET l_trailer_sw = 'y'
       #No.FUN-670066-end 
        BEFORE GROUP OF sr.cnz01
        #    PRINT COLUMN 1,sr.cnz01 CLIPPED; #No.FUN-670066
            PRINT COLUMN g_c[31],sr.cnz01 CLIPPED;  #No.FUN-670066
 
        BEFORE GROUP OF sr.cnz02
             #No.MOD-490398  --begin
            #修改的時候請注意一下。。目前cnz02有三種取值。。不要忘了3
            CASE sr.cnz02
                 WHEN '1' LET l_chrs= cl_getmsg('aco-214',g_lang)
                    #      PRINT COLUMN 13,l_chrs CLIPPED;        #No.FUN-670066 
                          PRINT COLUMN g_c[32],l_chrs CLIPPED;    #No.FUN-670066
                 WHEN '2' LET l_chrs= cl_getmsg('aco-215',g_lang)
                    #     PRINT COLUMN 13,l_chrs CLIPPED;         #No.FUN-670066 
                          PRINT COLUMN g_c[32],l_chrs CLIPPED;    #No.FUN-670066
                 WHEN '3' LET l_chrs= cl_getmsg('aco-216',g_lang)
                   #       PRINT COLUMN 13,l_chrs CLIPPED;        #No.FUN-670066
                          PRINT COLUMN g_c[32],l_chrs CLIPPED;    #No.FUN-670066
            END CASE
             #No.MOD-490398  --end
 
        ON EVERY ROW
      #No.FUN-670066-Begin
      #      PRINT COLUMN 38,sr.cnz03 USING '###&',     
      #            COLUMN 44,sr.cnz04 CLIPPED           
            PRINT COLUMN g_c[33],sr.cnz03 USING '###&',
                  COLUMN g_c[34],sr.cnz04 CLIPPED;      
      #     IF NOT cl_null(sr.cnz05) THEN
      #         PRINT COLUMN 44,sr.cnz05             
               PRINT COLUMN g_c[35],sr.cnz05          
      #      END IF
      #No.FUN-670066-End
 
 
        AFTER GROUP OF sr.cnz01
            PRINT
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,103
              #IF g_wc[001,080] > ' ' THEN
 	      #		  PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
              #IF g_wc[071,140] > ' ' THEN
 	      #       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
              #IF g_wc[141,210] > ' ' THEN
 	      #		  PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
               CALL cl_prt_pos_wc(g_wc) #TQC-630166
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
#No.FUN-770006 --end--
#Patch....NO.TQC-610035 <001,002> #
