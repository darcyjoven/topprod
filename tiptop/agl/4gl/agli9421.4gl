# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: agli9421.4gl
# Descriptions...: 人工輸入金額設定
# Date & Author..: 12/01/12  Lori(FUN-BC0123)
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
#FUN-BC0123
DEFINE 
    g_bookno        LIKE aaa_file.aaa01,
    g_aaa           RECORD LIKE aaa_file.*,
    g_gixx00         LIKE gixx_file.gixx00,   #帳套代碼(假單頭)     #No.FUN-740020
    g_gixx01         LIKE gixx_file.gixx01,   #群組代號(假單頭)
    g_gixx02         LIKE gixx_file.gixx02,   #科目編號(假單頭)
    g_gixx06         LIKE gixx_file.gixx06,   #科目編號(假單頭)
    g_gixx07         LIKE gixx_file.gixx07,   #科目編號(假單頭)
    g_gixx08         LIKE gixx_file.gixx08,                  
    g_gixx09         LIKE gixx_file.gixx09,                  
    g_gixx00_t       LIKE gixx_file.gixx00,   #帳套代號(舊值)      #No.FUN-740020
    g_gixx01_t       LIKE gixx_file.gixx01,   #群組代號(舊值)
    g_gixx02_t       LIKE gixx_file.gixx02,   #科目編號(舊值)
    g_gixx06_t       LIKE gixx_file.gixx06,   #科目編號(舊值)
    g_gixx07_t       LIKE gixx_file.gixx07,   #科目編號(舊值)
    g_gixx08_t       LIKE gixx_file.gixx08,                  
    g_gixx09_t       LIKE gixx_file.gixx09,                  
    g_gixx           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        gixx03       LIKE gixx_file.gixx03,   #編號
        gixx04       LIKE gixx_file.gixx04,   #說明
        gixx05       LIKE gixx_file.gixx05    #金額
                    END RECORD,
    g_gixx_t         RECORD                 #程式變數 (舊值)
        gixx03       LIKE gixx_file.gixx03,   #編號
        gixx04       LIKE gixx_file.gixx04,   #說明
        gixx05       LIKE gixx_file.gixx05    #金額
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166  
    g_delete        LIKE type_file.chr1,      #若刪除資料,則要重新顯示筆數  #No.FUN-680098    VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,      #單身筆數        #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5       #目前處理的ARRAY CNT        #No.FUN-680098 SMALLINT

#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL  
DEFINE   g_before_input_done  LIKE type_file.num5          #No.FUN-680098  SMALLINT
DEFINE   g_cnt                LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_i                  LIKE type_file.num5          #cont/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg                LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count          LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_curs_index         LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_jump               LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   mi_no_ask            LIKE type_file.num5          #No.FUN-680098  SMALLINT
DEFINE   g_sql_tmp            STRING                       #No.MOD-740268
DEFINE   g_dbs_axz03          LIKE type_file.chr21,
         g_aaz641             LIKE aaz_file.aaz641,
         g_plant_axz03        LIKE type_file.chr10  
DEFINE   g_axz05              LIKE axz_file.axz05   
DEFINE   l_sql                 STRING                                                 
DEFINE   l_table               STRING
DEFINE   g_str                 STRING     

MAIN
DEFINE
   p_row,p_col     LIKE type_file.num5             #開窗的位置       #No.FUN-680098 SMALLINT

   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP                       #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   IF g_bookno = ' ' OR g_bookno IS NULL THEN LET g_bookno = g_aaz.aaz64 END IF

   SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW i9421_w AT p_row,p_col      #顯示畫面
     WITH FORM "agl/42f/agli9421"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
   
   CALL cl_ui_init()
   LET g_forupd_sql = " SELECT * FROM gixx_file ",
                      " WHERE gixx00 = ? AND gixx01 = ? AND gixx02 = ?",
                      "   AND gixx06 = ? AND gixx07 = ?",
                      "   AND gixx08 = ? AND gixx09 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i9421_cl CURSOR FROM g_forupd_sql

   LET g_delete = 'N'
   CALL i9421_menu()
   CLOSE WINDOW i9421_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#QBE 查詢資料
FUNCTION i9421_cs()
    CLEAR FORM                              #清除畫面
    CALL g_gixx.clear()
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0029

    INITIALIZE g_gixx00 TO NULL    
    INITIALIZE g_gixx01 TO NULL    
    INITIALIZE g_gixx02 TO NULL    
    INITIALIZE g_gixx06 TO NULL    
    INITIALIZE g_gixx07 TO NULL    
    INITIALIZE g_gixx08 TO NULL    
    INITIALIZE g_gixx09 TO NULL    

    CONSTRUCT g_wc ON gixx08,gixx09,gixx00,gixx06,gixx07,gixx01,gixx02,
                      gixx03,gixx04,gixx05                             #螢幕上取條件     #No.FUN-740020
                 FROM gixx08,gixx09,gixx00,gixx06,gixx07,gixx01,gixx02,
                      s_gixx[1].gixx03,s_gixx[1].gixx04,s_gixx[1].gixx05

    BEFORE CONSTRUCT
       CALL cl_qbe_init()

    ON ACTION controlp                 # 沿用所有欄位
       CASE
          WHEN INFIELD(gixx00)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aaa"    #No.MOD-740268
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO gixx00
             NEXT FIELD gixx00 
          WHEN INFIELD(gixx01)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_giqq"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO gixx01
             NEXT FIELD gixx01 
          WHEN INFIELD(gixx02)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_giww"
             LET g_qryparam.multiret_index = "2"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO gixx02
             NEXT FIELD gixx02 
          WHEN INFIELD(gixx08) #族群編號
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form = "q_axa1"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO gixx08
             NEXT FIELD gixx08
          WHEN INFIELD(gixx09)  
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_axz"      
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO gixx09  
             NEXT FIELD gixx09
          OTHERWISE
             EXIT CASE
       END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about  
          CALL cl_about()    
       
       ON ACTION help   
          CALL cl_show_help()
       
       ON ACTION controlg    
          CALL cl_cmdask()   

       ON ACTION qbe_select
         CALL cl_qbe_select() 

       ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT

    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT UNIQUE gixx00,gixx01,gixx02,gixx06,gixx07,gixx08,gixx09 FROM gixx_file ",
              "    WHERE ", g_wc CLIPPED,
              "    ORDER BY gixx00,gixx01 "
    PREPARE i9421_prepare FROM g_sql              #預備一下
    DECLARE i9421_b_cs                            #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i9421_prepare
                                                 #計算本次查詢單頭的筆數
    LET g_sql_tmp ="SELECT UNIQUE gixx00,gixx01,gixx02,gixx06,gixx07,gixx08,gixx09 FROM gixx_file ",
              "    WHERE ", g_wc CLIPPED,
              " INTO TEMP x "
    DROP TABLE x
    PREPARE i9421_precount_x FROM g_sql_tmp  
    EXECUTE i9421_precount_x
    LET g_sql="SELECT COUNT(*) FROM x"
    PREPARE i9421_precount FROM g_sql
    DECLARE i9421_count CURSOR FOR i9421_precount
END FUNCTION

FUNCTION i9421_menu()
   DEFINE l_cmd    LIKE  type_file.chr1000   #NO.FUN-7C0043
   WHILE TRUE
      CALL i9421_bp("G")
      CASE g_action_choice
           WHEN "insert" 
                IF cl_chk_act_auth() THEN 
                   CALL i9421_a()
                END IF
           WHEN "query" 
                IF cl_chk_act_auth() THEN
                   CALL i9421_q()
                END IF
           WHEN "modify"                          # u.更新
                IF cl_chk_act_auth() THEN
                   CALL i9421_u()
                END IF
           WHEN "next" 
                CALL i9421_fetch('N')
           WHEN "previous" 
                CALL i9421_fetch('P')
           WHEN "delete" 
                 IF cl_chk_act_auth() THEN
                     CALL i9421_r()
                 END IF
           WHEN "detail" 
                IF cl_chk_act_auth() THEN
                   CALL i9421_b()
                ELSE
                   LET g_action_choice = NULL
                END IF
           WHEN "help" 
                CALL cl_show_help()
           WHEN "exit"
                 EXIT WHILE
           WHEN "jump"
                CALL i9421_fetch('/')
           WHEN "controlg"
                CALL cl_cmdask()
           WHEN "related_document"
                IF cl_chk_act_auth() THEN
                   IF g_gixx01 IS NOT NULL THEN
                      LET g_doc.column1 = "gixx01"
                      LET g_doc.value1 = g_gixx01
                      LET g_doc.column2 = "gixx02"
                      LET g_doc.value2 = g_gixx02
                      LET g_doc.column3 = "gixx06" 
                      LET g_doc.value3 = g_gixx06  
                      LET g_doc.column4 = "gixx07" 
                      LET g_doc.value4 = g_gixx07  
                      LET g_doc.column5 = "gixx08" 
                      LET g_doc.value5 = g_gixx08  
                      CALL cl_doc()
                   END IF
                END IF
           WHEN "exporttoexcel"   #No:FUN-4B0010
                IF cl_chk_act_auth() THEN
                   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gixx),'','')
                END IF
      END CASE
   END WHILE
END FUNCTION


#Add  輸入
FUNCTION i9421_a()
DEFINE   l_n    LIKE type_file.num5          #No.FUN-680098  SMALLINT
   
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_gixx.clear()

    INITIALIZE g_gixx00 LIKE gixx_file.gixx00
    INITIALIZE g_gixx01 LIKE gixx_file.gixx01
    INITIALIZE g_gixx02 LIKE gixx_file.gixx02
    INITIALIZE g_gixx06 LIKE gixx_file.gixx06
    INITIALIZE g_gixx07 LIKE gixx_file.gixx07
    INITIALIZE g_gixx08 LIKE gixx_file.gixx08
    INITIALIZE g_gixx09 LIKE gixx_file.gixx09

    LET g_gixx00_t = NULL
    LET g_gixx01_t = NULL
    LET g_gixx02_t = NULL
    LET g_gixx06_t = NULL
    LET g_gixx07_t = NULL
    LET g_gixx08_t = NULL
    LET g_gixx09_t = NULL

    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i9421_i("a")                           #輸入單頭
        IF INT_FLAG THEN                            #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        CALL g_gixx.clear()
        SELECT COUNT(*) INTO l_n FROM gixx_file 
         WHERE gixx01 = g_gixx01
           AND gixx00 = g_gixx00
           AND gixx02 = g_gixx02
           AND gixx06 = g_gixx06
           AND gixx07 = g_gixx07
           AND gixx08 = g_gixx08
           AND gixx09 = g_gixx09       

        LET g_rec_b = 0
        IF l_n > 0 THEN
           CALL i9421_b_fill('1=1')
         END IF
        CALL i9421_b()                             #輸入單身
        LET g_gixx01_t = g_gixx01                  #保留舊值
        LET g_gixx00_t = g_gixx00
        LET g_gixx02_t = g_gixx02
        LET g_gixx06_t = g_gixx06
        LET g_gixx07_t = g_gixx07
        LET g_gixx08_t = g_gixx08
        LET g_gixx09_t = g_gixx09
        EXIT WHILE
    END WHILE
END FUNCTION

#處理INPUT
FUNCTION i9421_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                  #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
    l_gixx01        LIKE gixx_file.gixx01,
    l_gixx00        LIKE gixx_file.gixx00,
    l_n1,l_n        LIKE type_file.num5   

    DISPLAY g_gixx08,g_gixx09,g_gixx00,g_gixx06,g_gixx07,g_gixx01,g_gixx02
         TO gixx08,gixx09,gixx00,gixx06,gixx07,gixx01,gixx02

    LET g_before_input_done = FALSE
    CALL i9421_set_entry(p_cmd)
    CALL i9421_set_no_entry(p_cmd)
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")

    INPUT g_gixx08,g_gixx09,g_gixx00,g_gixx06,g_gixx07,g_gixx01,g_gixx02      
        WITHOUT DEFAULTS
        FROM gixx08,gixx09,gixx00,gixx06,gixx07,gixx01,gixx02     
 
        AFTER FIELD gixx07
         IF NOT cl_null(g_gixx07) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_gixx06
            IF g_azm.azm02 = 1 THEN
               IF g_gixx07 > 12 OR g_gixx07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD gixx07
               END IF
            ELSE
               IF g_gixx07 > 13 OR g_gixx07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD gixx07
               END IF
            END IF
         END IF

        AFTER FIELD gixx01  #群組代號                
           IF NOT cl_null(g_gixx01) THEN
              CALL i9421_gixx01('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gixx01,g_errno,0)
                 LET g_gixx01 = g_gixx01_t
                 DISPLAY g_gixx01 TO gixx01
                 NEXT FIELD gixx01
              END IF
           END IF

        AFTER FIELD gixx02  #科目編號
           IF NOT cl_null(g_gixx02) THEN
              CALL i9421_gixx02('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gixx02,g_errno,0)
                 LET g_gixx02 = g_gixx02_t
                 DISPLAY g_gixx02 TO gixx02
                 NEXT FIELD gixx02
              END IF
           END IF

      AFTER FIELD gixx08   #族群代號
         IF cl_null(g_gixx08) THEN
            CALL cl_err(g_gixx08,'mfg0037',0)
            NEXT FIELD gixx08
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=g_gixx08
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_gixx08,'agl-223',0)
               NEXT FIELD gixx08
            END IF
         END IF

      AFTER FIELD gixx09 
         IF NOT cl_null(g_gixx09) THEN 
            SELECT count(*) INTO l_n FROM axa_file
             WHERE axa01 = g_gixx08 AND axa02 = g_gixx09
            IF l_n = 0  THEN
               CALL cl_err(g_gixx09,'agl-118',1)
               NEXT FIELD gixx09
            END IF
            CALL i9421_gixx09('a',g_gixx09,g_gixx08)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gixx09,g_errno,0)
               NEXT FIELD gixx09
            END IF
            IF g_gixx08 IS NOT NULL AND g_gixx09 IS NOT NULL AND
               g_gixx00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_gixx08 AND axa02=g_gixx09
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_gixx08 AND axb04=g_gixx09
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_gixx09,'agl-223',0)
                  LET g_gixx08 = g_gixx08_t
                  LET g_gixx09 = g_gixx09_t
                  LET g_gixx00 = g_gixx00_t
                  DISPLAY BY NAME g_gixx08,g_gixx09,g_gixx00
                  NEXT FIELD gixx09
               END IF
            END IF
         END IF 

        ON ACTION CONTROLP                 # 沿用所有欄位
           CASE
              WHEN INFIELD(gixx00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"    
                  LET g_qryparam.default1 = g_gixx00
                  CALL cl_create_qry() RETURNING g_gixx00 
                  DISPLAY g_gixx00 TO gixx00
                  NEXT FIELD gixx00 
              WHEN INFIELD(gixx01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_giqq"
                 LET g_qryparam.default1 = g_gixx01
                 CALL cl_create_qry() RETURNING g_gixx01
                 DISPLAY g_gixx01 TO gixx01
                 NEXT FIELD gixx01 
              WHEN INFIELD(gixx02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_giww"
                 LET g_qryparam.arg1 = g_gixx01
                 LET g_qryparam.default1 = g_gixx01
                 LET g_qryparam.default2 = g_gixx02
                 CALL cl_create_qry() RETURNING l_gixx01,g_gixx02
                 DISPLAY g_gixx02 TO gixx02
                 NEXT FIELD gixx02 
              WHEN INFIELD(gixx08) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axa1"
                 LET g_qryparam.default1 = g_gixx08
                 CALL cl_create_qry() RETURNING g_gixx08
                 DISPLAY g_gixx08 TO gixx08
                 NEXT FIELD gixx08
              WHEN INFIELD(gixx09)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"    
                 LET g_qryparam.default1 = g_gixx09
                 CALL cl_create_qry() RETURNING g_gixx09
                 DISPLAY g_gixx09 TO gixx09 
                 NEXT FIELD gixx09
              OTHERWISE
                 EXIT CASE
          END CASE
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  

        ON ACTION CONTROLG
            CALL cl_cmdask()
    END INPUT
END FUNCTION

FUNCTION i9421_gixx01(p_cmd) #群組代碼
DEFINE
    p_cmd      LIKE type_file.chr1,
    l_giqq02    LIKE giqq_file.giqq02

   LET g_errno=''
   SELECT giqq02 INTO l_giqq02
       FROM giqq_file
       WHERE giqq01 = g_gixx01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917' #無此群組代碼!!
                                LET l_giqq02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
       DISPLAY l_giqq02 TO FORMONLY.giqq02 
   END IF
END FUNCTION

FUNCTION i9421_gixx02(p_cmd) #科目編號
DEFINE
    p_cmd      LIKE type_file.chr1,
    l_giww04   LIKE giww_file.giww04,
    l_aag02    LIKE aag_file.aag02

   LET g_errno=''
   SELECT giww04 INTO l_giww04 
       FROM giww_file
       WHERE giww01 = g_gixx01
         AND giww00 = g_gixx00
         AND giww02 = g_gixx02
         AND giww05 = g_gixx08
         AND giww06 = g_gixx09
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' #無此科目編號!!
                                RETURN
       WHEN l_giww04 <> '4'     LET g_errno='agl1029'
                                RETURN
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE

   CALL s_aaz641_dbs(g_gixx08,g_gixx09) RETURNING g_plant_axz03
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641

   LET g_sql = "SELECT aag02",
              #"  FROM ",g_dbs_axz03,"aag_file",
               "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),
               " WHERE aag01 = '",g_gixx02,"'",
               "   AND aag00 = '",g_gixx00,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_dbs_axz03) RETURNING g_sql
   PREPARE i9421_pre_1 FROM g_sql
   DECLARE i9421_cur_1 CURSOR FOR i9421_pre_1
   OPEN i9421_cur_1
   FETCH i9421_cur_1 INTO l_aag02

   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' #無此科目編號!!
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) THEN 
       DISPLAY l_aag02 TO FORMONLY.aag02
   END IF
END FUNCTION

#Query 查詢
FUNCTION i9421_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i9421_cs()                         #取得查詢條件
    IF INT_FLAG THEN                        #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i9421_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                   #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_gixx01 TO NULL
    ELSE
        CALL i9421_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i9421_count
        FETCH i9421_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i9421_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式          #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 INTEGER

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i9421_b_cs INTO g_gixx00,g_gixx01,g_gixx02,g_gixx06,g_gixx07,g_gixx08,g_gixx09
        WHEN 'P' FETCH PREVIOUS i9421_b_cs INTO g_gixx00,g_gixx01,g_gixx02,g_gixx06,g_gixx07,g_gixx08,g_gixx09
        WHEN 'F' FETCH FIRST    i9421_b_cs INTO g_gixx00,g_gixx01,g_gixx02,g_gixx06,g_gixx07,g_gixx08,g_gixx09
        WHEN 'L' FETCH LAST     i9421_b_cs INTO g_gixx00,g_gixx01,g_gixx02,g_gixx06,g_gixx07,g_gixx08,g_gixx09
        WHEN '/' 
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about  
                     CALL cl_about()    
 
                  ON ACTION help   
                     CALL cl_show_help()
 
                  ON ACTION controlg    
                     CALL cl_cmdask()   
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i9421_b_cs INTO g_gixx00,g_gixx01,g_gixx02,g_gixx06,g_gixx07,g_gixx08,g_gixx09     #No.TQC-960360
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_gixx01,SQLCA.sqlcode,0)
       INITIALIZE g_gixx01 TO NULL
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

    CALL i9421_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i9421_show()
    DISPLAY g_gixx08,g_gixx09,g_gixx00,g_gixx06,g_gixx07,g_gixx01,g_gixx02
         TO gixx08,gixx09,gixx00,gixx06,gixx07,gixx01,gixx02        #單頭

    CALL i9421_gixx01('d')
    CALL i9421_gixx02('d')
    CALL i9421_gixx09('d',g_gixx09,g_gixx08)
    CALL i9421_b_fill(g_wc)                    #單身
    CALL cl_show_fld_cont()

END FUNCTION


#取消整筆 (所有合乎單頭的資料)
FUNCTION i9421_r()
    IF s_shut(0) THEN RETURN END IF           #檢查權限
    IF g_gixx01 IS NULL THEN
       CALL cl_err("",-400,0) 
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                      #確認一下
        INITIALIZE g_doc.* TO NULL 
        LET g_doc.column1 = "gixx01"
        LET g_doc.value1 = g_gixx01 
        LET g_doc.column2 = "gixx02"
        LET g_doc.value2 = g_gixx02 
        LET g_doc.column3 = "gixx06"
        LET g_doc.value3 = g_gixx06 
        LET g_doc.column4 = "gixx07"
        LET g_doc.value4 = g_gixx07 
        LET g_doc.column5 = "gixx08"
        LET g_doc.value5 = g_gixx08 
        CALL cl_del_doc()         
        DELETE FROM gixx_file WHERE gixx01 = g_gixx01
                                AND gixx00 = g_gixx00
                                AND gixx02 = g_gixx02
                                AND gixx06 = g_gixx06
                                AND gixx07 = g_gixx07
                                AND gixx08 = g_gixx08      
                                AND gixx09 = g_gixx09      
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","gixx_file",g_gixx01,g_gixx02,SQLCA.sqlcode,"","BODY DELETE:",1)
        ELSE
            CLEAR FORM
            DROP TABLE x
            PREPARE i9421_precount_x2 FROM g_sql_tmp  
            EXECUTE i9421_precount_x2                 
            CALL g_gixx.clear()
            LET g_delete='Y'
            LET g_gixx00 = NULL
            LET g_gixx01 = NULL
            LET g_gixx02 = NULL
            LET g_gixx06 = NULL
            LET g_gixx07 = NULL
            LET g_gixx08 = NULL   
            LET g_gixx09 = NULL   
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i9421_count
            FETCH i9421_count INTO g_row_count
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i9421_b_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i9421_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i9421_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION

#單身
FUNCTION i9421_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,                #檢查重複用
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
   p_cmd           LIKE type_file.chr1,                #處理狀態
   l_allow_insert  LIKE type_file.num5,                #可新增否
   l_allow_delete  LIKE type_file.num5                 #可刪除否

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF g_gixx01 IS NULL OR g_gixx02 IS NULL THEN
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示
   SELECT azi04 INTO g_azi04         #幣別檔小數位數讀取
     FROM azi_file
    WHERE azi01=g_aaa.aaa03

   LET g_forupd_sql = "SELECT gixx03,gixx04,gixx05 FROM gixx_file",
                      " WHERE gixx00 = ? AND gixx01 =? AND gixx02 =? AND gixx06 =?",
                      "   AND gixx07 =? AND gixx03 =? AND gixx08 =? AND gixx09 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i9421_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_gixx WITHOUT DEFAULTS FROM s_gixx.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                 #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'                   
            LET g_gixx_t.* = g_gixx[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i9421_bcl USING g_gixx00,g_gixx01,g_gixx02,g_gixx06,g_gixx07,g_gixx_t.gixx03,g_gixx08,g_gixx09   #FUN-920122 mod
            IF STATUS THEN
               CALL cl_err("OPEN i9421_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i9421_bcl INTO g_gixx_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock gixx',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()
         END IF

      AFTER FIELD gixx03
         IF NOT cl_null(g_gixx[l_ac].gixx03) THEN
            IF g_gixx[l_ac].gixx03 != g_gixx_t.gixx03 OR g_gixx_t.gixx03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM gixx_file 
                WHERE gixx01 = g_gixx01 
                  AND gixx00 = g_gixx00
                  AND gixx02 = g_gixx02
                  AND gixx06 = g_gixx06
                  AND gixx07 = g_gixx07
                  AND gixx08 = g_gixx08      
                  AND gixx09 = g_gixx09      
                  AND gixx03 = g_gixx[l_ac].gixx03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gixx[l_ac].gixx03 = g_gixx_t.gixx03
                  NEXT FIELD gixx03
               END IF
            END IF
         END IF

      AFTER FIELD gixx05
         IF g_gixx[l_ac].gixx05 < 0 THEN
            LET g_gixx[l_ac].gixx05 = NULL
            NEXT FIELD gixx05
         END IF 
         IF NOT cl_null(g_gixx[l_ac].gixx05) THEN
            LET g_gixx[l_ac].gixx05 = cl_numfor(g_gixx[l_ac].gixx05,15,g_azi04)
         END IF
     
      BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_gixx[l_ac].* TO NULL         #900423
          LET g_gixx_t.* = g_gixx[l_ac].*            #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD gixx03

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO gixx_file (gixx00,gixx01,gixx02,gixx03,gixx06,gixx07,gixx04,gixx05,gixx08,gixx09)
              VALUES(g_gixx00,g_gixx01,g_gixx02,g_gixx[l_ac].gixx03,g_gixx06,g_gixx07,
                     g_gixx[l_ac].gixx04,g_gixx[l_ac].gixx05,g_gixx08,g_gixx09)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gixx_file",g_gixx01,g_gixx02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      BEFORE DELETE                                #是否取消單身
         IF g_gixx_t.gixx03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN               #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gixx_file
             WHERE gixx01 = g_gixx01
               AND gixx00 = g_gixx00
               AND gixx02 = g_gixx02
               AND gixx06 = g_gixx06
               AND gixx07 = g_gixx07
               AND gixx08 = g_gixx08      
               AND gixx09 = g_gixx09      
               AND gixx03 = g_gixx_t.gixx03 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gixx_file",g_gixx01,g_gixx02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gixx[l_ac].* = g_gixx_t.*
             CLOSE i9421_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gixx[l_ac].gixx03,-263,1)
             LET g_gixx[l_ac].* = g_gixx_t.*
          ELSE
             UPDATE gixx_file SET gixx03 = g_gixx[l_ac].gixx03,
                                  gixx04 = g_gixx[l_ac].gixx04,
                                  gixx05 = g_gixx[l_ac].gixx05 
              WHERE gixx01 = g_gixx01
                AND gixx00 = g_gixx00
                AND gixx02 = g_gixx02
                AND gixx06 = g_gixx06
                AND gixx07 = g_gixx07
                AND gixx03 = g_gixx_t.gixx03
                AND gixx08 = g_gixx08    
                AND gixx09 = g_gixx09    
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","gixx_file",g_gixx01,g_gixx02,SQLCA.sqlcode,"","",1)
                LET g_gixx[l_ac].* = g_gixx_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF

      AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac   #FUN-D30032 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
            #LET g_gixx[l_ac].* = g_gixx_t.*  #FUN-D30032 mark
            #FUN-D30032--add--begin--
             IF p_cmd = 'u' THEN
                LET g_gixx[l_ac].* = g_gixx_t.*
             ELSE
                CALL g_gixx.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             END IF
            #FUN-D30032--add--end----
             CLOSE i9421_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac   #FUN-D30032 add
          LET g_gixx_t.* = g_gixx[l_ac].*
          CLOSE i9421_bcl
          COMMIT WORK

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gixx03) AND l_ac > 1 THEN
            LET g_gixx[l_ac].* = g_gixx[l_ac-1].*
            NEXT FIELD gixx03
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about  
         CALL cl_about()    
 
      ON ACTION help   
         CALL cl_show_help()
   
   END INPUT

   CLOSE i9421_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i9421_b_askkey()
   CLEAR FORM
   CALL g_gixx.clear()
   CONSTRUCT g_wc2 ON gixx03,gixx04,gixx05                #螢幕上取條件
      FROM s_gixx[1].gixx03,s_gixx[1].gixx04,s_gixx[1].gixx05
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about  
         CALL cl_about()    
 
      ON ACTION help   
         CALL cl_show_help()
 
      ON ACTION controlg    
         CALL cl_cmdask()   
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
	 CALL cl_qbe_save()
   END CONSTRUCT

   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL i9421_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i9421_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            STRING,
    l_flag          LIKE type_file.chr1,              #有無單身筆數
    l_sql           STRING    
 
    LET l_sql = "SELECT gixx03,gixx04,gixx05 FROM gixx_file",
                " WHERE gixx01 = '",g_gixx01,"'",
                "   AND gixx00 = '",g_gixx00,"'",      #No.FUN-740020
                "   AND gixx02 = '",g_gixx02,"'",
                "   AND gixx06 = '",g_gixx06,"'",
                "   AND gixx07 = '",g_gixx07,"'",
                "   AND gixx08 = '",g_gixx08,"'",      
                "   AND gixx09 = '",g_gixx09,"'",      
                "   AND ",p_wc CLIPPED,
                " ORDER BY gixx03"

    PREPARE gixx_pre FROM l_sql
    DECLARE gixx_cs CURSOR FOR gixx_pre

    CALL g_gixx.clear()
    LET g_cnt = 1
    LET l_flag='N'
    LET g_rec_b=0
    FOREACH gixx_cs INTO g_gixx[g_cnt].*     #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt=g_cnt+1
       LET l_flag='Y'
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gixx.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION

FUNCTION i9421_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gixx TO s_gixx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first 
         CALL i9421_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL i9421_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION jump
         CALL i9421_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
                              

      ON ACTION next
         CALL i9421_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION last
         CALL i9421_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
                              

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

       ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
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
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about  
         CALL cl_about()    

      AFTER DISPLAY
         CONTINUE DISPLAY
                                   
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION



FUNCTION i9421_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("gixx00,gixx01,gixx02,gixx06,gixx07,gixx08,gixx09",TRUE)
    END IF 

END FUNCTION

FUNCTION i9421_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("gixx00,gixx01,gixx02,gixx06,gixx07,gixx08,gixx09",FALSE) 
    END IF 

    CALL cl_set_comp_entry("gixx00",FALSE) 

END FUNCTION

FUNCTION  i9421_gixx09(p_cmd,p_gixx09,p_gixx08) 
DEFINE p_cmd           LIKE type_file.chr1,         
       p_gixx09         LIKE gixx_file.gixx09,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05,
       l_aaz641        LIKE aaz_file.aaz641,
       p_gixx08         LIKE gixx_file.gixx08,
       l_axa09         LIKE axa_file.axa09

    LET g_errno = ' '
    
       SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05 
         FROM axz_file
        WHERE axz01 = p_gixx09
    LET g_axz05 = l_axz05

    CALL s_aaz641_dbs(p_gixx08,p_gixx09) RETURNING g_dbs_axz03
    CALL s_get_aaz641(g_dbs_axz03) RETURNING l_aaz641
    LET g_gixx00 = l_aaz641 

    CASE
       WHEN SQLCA.SQLCODE=100 
          LET g_errno = 'mfg9142'
          LET l_axz02 = NULL
          LET l_axz03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_axz02 TO FORMONLY.axz02 
       DISPLAY l_axz03 TO FORMONLY.axz03                                          
       DISPLAY g_gixx00 TO FORMONLY.gixx00 
    END IF

END FUNCTION
FUNCTION i9421_u()
   DEFINE l_gixx_lock    RECORD LIKE gixx_file.*
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_chkey = 'N' THEN
      CALL cl_err('','agl-266',1)
      RETURN
   END IF
   MESSAGE ""
   LET g_gixx00_t = g_gixx00
   LET g_gixx01_t = g_gixx01
   LET g_gixx02_t = g_gixx02
   LET g_gixx06_t = g_gixx06
   LET g_gixx07_t = g_gixx07
   LET g_gixx08_t = g_gixx08
   LET g_gixx09_t = g_gixx09

   BEGIN WORK
   OPEN i9421_cl USING g_gixx00,g_gixx01,g_gixx02,g_gixx06,g_gixx07,g_gixx08,g_gixx09
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i9421_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i9421_cl INTO l_gixx_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gixx00 LOCK:",SQLCA.sqlcode,1)
      CLOSE i9421_cl
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
      CALL i9421_i("u")
      IF INT_FLAG THEN
         LET g_gixx00 = g_gixx00_t
         LET g_gixx01 = g_gixx01_t
         LET g_gixx02 = g_gixx02_t
         LET g_gixx06 = g_gixx06_t
         LET g_gixx07 = g_gixx07_t
         LET g_gixx08 = g_gixx08_t
         LET g_gixx09 = g_gixx09_t
         DISPLAY g_gixx00,g_gixx01,g_gixx02,g_gixx06,g_gixx07,g_gixx08,g_gixx09
              TO gixx00,gixx01,gixx02,gixx06,gixx07,gixx08,gixx09
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gixx_file SET gixx00 = g_gixx00, gixx01 = g_gixx01
                          ,gixx02 = g_gixx02, gixx06 = g_gixx06
                          ,gixx07 = g_gixx07 ,gixx08 = g_gixx08
                          , gixx09 = g_gixx09
       WHERE gixx00 = g_gixx00_t
         AND gixx01 = g_gixx01_t
         AND gixx02 = g_gixx02_t
         AND gixx06 = g_gixx06_t
         AND gixx07 = g_gixx07_t
         AND gixx08 = g_gixx08_t
         AND gixx09 = g_gixx09_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gixx_file",g_gixx00_t,g_gixx01_t,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
