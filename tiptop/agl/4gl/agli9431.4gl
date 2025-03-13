# Prog. Version..: '5.30.06-13.04.22(00004)'     #
# Pattern name...: agli9431.4gl
# Descriptions...: 現金流量表期初開帳金額設定(合併)
# Date & Author..: 12/01/11 By Lori(FUN-BC0123)
# Modify.........: No:FUN-C30098 12/03/15 By belle 畫面修改為假雙檔,增加gizz06,gizz07
# Modify.........: No:CHI-C40004 12/04/06 By Belle 畫面增加Action
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#模組變數(Module Variables)
DEFINE
    g_gizz00         LIKE gizz_file.gizz00,
    g_gizz01         LIKE gizz_file.gizz01,
    g_gizz02         LIKE gizz_file.gizz02,
    g_gizz03         LIKE gizz_file.gizz03,
    g_gizz04         LIKE gizz_file.gizz04,
    g_gizz07         LIKE gizz_file.gizz07,
    g_gizz00_t       LIKE gizz_file.gizz00,
    g_gizz01_t       LIKE gizz_file.gizz01,
    g_gizz02_t       LIKE gizz_file.gizz02,
    g_gizz03_t       LIKE gizz_file.gizz03,
    g_gizz04_t       LIKE gizz_file.gizz04,
    g_gizz07_t       LIKE gizz_file.gizz07,
    g_axz05          LIKE axz_file.axz05,   
    g_gizz_lock      RECORD LIKE gizz_file.*,   
    g_gizz           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        gizz06       LIKE gizz_file.gizz06,   #科目編號
        aag02        LIKE aag_file.aag02,     #科目名稱
        gizz05       LIKE gizz_file.gizz05    #期初金額
                     END RECORD,
    g_gizz_t         RECORD                   #程式變數 (舊值)
        gizz06       LIKE gizz_file.gizz06,   #科目編號
        aag02        LIKE aag_file.aag02,     #科目名稱
        gizz05       LIKE gizz_file.gizz05    #期初金額
                     END RECORD,
    g_wc,g_wc2,g_sql STRING,
    g_sql_tmp        STRING,
    g_rec_b          LIKE type_file.num5,    #單身筆數               
    l_ac             LIKE type_file.num5     #目前處理的ARRAY CNT    
DEFINE g_str         STRING 
DEFINE g_dbs_axz03   LIKE type_file.chr21  
DEFINE l_sql         STRING                                                 
DEFINE l_table       STRING     

#主程式開始

DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL       
DEFINE   g_before_input_done  LIKE type_file.num5       
DEFINE   g_cnt                LIKE type_file.num10 
DEFINE   g_i                  LIKE type_file.num5  
DEFINE   g_msg                LIKE ze_file.ze03    
DEFINE   g_row_count          LIKE type_file.num10 
DEFINE   g_curs_index         LIKE type_file.num10 
DEFINE   g_jump               LIKE type_file.num10 
DEFINE   mi_no_ask            LIKE type_file.num5  

MAIN
DEFINE
   p_row,p_col     LIKE type_file.num5   #開窗的位置        

   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET p_row = ARG_VAL(2)               #取得螢幕位置
   LET p_col = ARG_VAL(3)
   LET g_gizz00   = NULL
   LET g_gizz01   = NULL
   LET g_gizz02   = NULL
   LET g_gizz03   = NULL
   LET g_gizz04   = NULL
   LET g_gizz07   = NULL
   LET g_gizz00_t = NULL
   LET g_gizz01_t = NULL
   LET g_gizz02_t = NULL
   LET g_gizz03_t = NULL
   LET g_gizz04_t = NULL
   LET g_gizz07_t = NULL
   LET p_row = 3
   LET p_col = 14
       
   OPEN WINDOW i9431_w AT p_row,p_col      #顯示畫面
     WITH FORM "agl/42f/agli9431"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()

   LET g_forupd_sql = " SELECT * FROM gizz_file "
                     ,"  WHERE gizz00 = ? AND gizz01 = ? AND gizz02 = ? "
                     ,"    AND gizz03 = ? AND gizz04 = ? AND gizz07 = ? "
                     ," FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i9431_cl CURSOR FROM g_forupd_sql
   CALL i9431_menu()
   CLOSE WINDOW i9431_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#QBE 查詢資料
FUNCTION i9431_cs()
   CLEAR FORM                                   #清除畫面
   CALL g_gizz.clear()
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_gizz00 TO NULL
   INITIALIZE g_gizz01 TO NULL
   INITIALIZE g_gizz02 TO NULL
   INITIALIZE g_gizz03 TO NULL
   INITIALIZE g_gizz04 TO NULL
   INITIALIZE g_gizz07 TO NULL
  
   CONSTRUCT g_wc ON gizz01,gizz02,gizz00,gizz03,gizz04,gizz07,gizz06
                FROM gizz01,gizz02,gizz00,gizz03,gizz04,gizz07
                    ,s_gizz[1].gizz06                 
  
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
  
      ON ACTION controlp                 #沿用所有欄位
         CASE
            WHEN INFIELD(gizz01)         #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_axa1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gizz01
                 NEXT FIELD gizz01
            WHEN INFIELD(gizz02)         #上層公司  
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axz"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gizz02  
                 NEXT FIELD gizz02
            WHEN INFIELD(gizz00)          #帳別                                                                                                     
               CALL cl_init_qry_var()                                                                                                 
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aaa"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
               DISPLAY g_qryparam.multiret TO gizz00
               NEXT FIELD gizz00                                                                                                       
            WHEN INFIELD(gizz06)           #會計科目
               CALL q_m_aag2(TRUE,TRUE,g_dbs_axz03,g_gizz[1].gizz06,'23',g_gizz00)
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gizz06
               NEXT FIELD gizz06
            WHEN INFIELD(gizz07)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_giqq"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gizz07
               NEXT FIELD gizz07
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
   LET g_sql="SELECT UNIQUE gizz00,gizz01,gizz02,gizz03,gizz04,gizz07 FROM gizz_file ", # 組合出SQL 指令
             " WHERE ", g_wc CLIPPED,
             " ORDER BY 1"
   PREPARE i9431_prepare FROM g_sql              #預備一下
   DECLARE i9431_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i9431_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql = " SELECT count(*) FROM (" 
              ,"    SELECT UNIQUE gizz00,gizz01,gizz02,gizz03,gizz04,gizz07 FROM gizz_file "
              ,"     WHERE ",g_wc CLIPPED
              ,")"

   PREPARE i9431_precount FROM g_sql
   DECLARE i9431_count CURSOR FOR i9431_precount
END FUNCTION

FUNCTION i9431_menu()

   WHILE TRUE
      CALL i9431_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i9431_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i9431_q()
            END IF
        WHEN "delete" 
           IF cl_chk_act_auth() THEN
              CALL i9431_r()
           END IF
        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i9431_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i9431_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_gizz00 IS NULL OR g_gizz01 IS NOT NULL THEN
                  LET g_doc.column1 = "gizz00"
                  LET g_doc.value1 = g_gizz00
                  LET g_doc.column2 = "gizz01"
                  LET g_doc.value2 = g_gizz01
                  LET g_doc.column3 = "gizz02"
                  LET g_doc.value3 = g_gizz02
                  LET g_doc.column4 = "gizz03"
                  LET g_doc.value4 = g_gizz03
                  LET g_doc.column4 = "gizz04"
                  LET g_doc.value4 = g_gizz04
                  LET g_doc.column5 = "gizz07"
                  LET g_doc.value5 = g_gizz07
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gizz),'','')
            END IF
        #CHI-C40004--
         WHEN "agli943"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun("agli943")
            END IF
        #CHI-C40004--
      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION i9431_a()
DEFINE   l_n    LIKE type_file.num5          
   
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_gizz.clear()
   INITIALIZE g_gizz00 LIKE gizz_file.gizz00
   INITIALIZE g_gizz01 LIKE gizz_file.gizz01
   INITIALIZE g_gizz02 LIKE gizz_file.gizz02
   INITIALIZE g_gizz03 LIKE gizz_file.gizz03
   INITIALIZE g_gizz04 LIKE gizz_file.gizz04
   INITIALIZE g_gizz07 LIKE gizz_file.gizz07
   LET g_gizz00_t = NULL
   LET g_gizz01_t = NULL
   LET g_gizz02_t = NULL
   LET g_gizz03_t = NULL
   LET g_gizz04_t = NULL
   LET g_gizz07_t = NULL

  #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i9431_i("a")                           #輸入單頭
      IF INT_FLAG THEN                            #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_gizz.clear()
      SELECT COUNT(*) INTO l_n
        FROM gizz_file
       WHERE gizz00 = g_gizz00 AND gizz01 = g_gizz01
         AND gizz02 = g_gizz02 AND gizz03 = g_gizz03
         AND gizz04 = g_gizz04 AND gizz07 = g_gizz07
      LET g_rec_b = 0 
      IF l_n > 0 THEN
         CALL i9431_b_fill('1=1')
      END IF
      CALL i9431_b()                             #輸入單身
      LET g_gizz00_t = g_gizz00                  #保留舊值
      LET g_gizz01_t = g_gizz01                  #保留舊值
      LET g_gizz02_t = g_gizz02                  #保留舊值
      LET g_gizz03_t = g_gizz03                  #保留舊值
      LET g_gizz04_t = g_gizz04                  #保留舊值
      LET g_gizz07_t = g_gizz07                  #保留舊值
      EXIT WHILE
   END WHILE
END FUNCTION

#處理INPUT
FUNCTION i9431_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改
   l_cnt           LIKE type_file.num5,
   l_n1,l_n        LIKE type_file.num5      

   CALL cl_set_head_visible("","YES")

   INPUT g_gizz01,g_gizz02,g_gizz00,g_gizz03,g_gizz04,g_gizz07 WITHOUT DEFAULTS
    FROM gizz01,gizz02,gizz00,gizz03,gizz04,gizz07
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i9431_set_entry(p_cmd)
         CALL i9431_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD gizz00 
         LET l_cnt = 0
         LET g_sql = "SELECT COUNT(*) ",
                     "  FROM aaa_file",
                     " WHERE aaa01 = '",g_gizz00,"'",
                     "   AND aaaacti = 'Y' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         PREPARE i9431_pre_2 FROM g_sql
         DECLARE i9431_cur_2 CURSOR FOR i9431_pre_2
         OPEN i9431_cur_2
         FETCH i9431_cur_2 INTO l_cnt
         IF l_cnt = 0 THEN
            CALL cl_err('','agl-095',0)   
            NEXT FIELD gizz00
         END IF
      AFTER FIELD gizz01   #族群代號
         IF cl_null(g_gizz01) THEN
            CALL cl_err(g_gizz01,'mfg0037',0)
            NEXT FIELD gizz01
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=g_gizz01
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_gizz01,'agl-223',0)
               NEXT FIELD gizz01
            END IF
         END IF

      AFTER FIELD gizz02   #上層公司 
         IF NOT cl_null(g_gizz02) THEN 
            SELECT count(*) INTO l_cnt FROM axa_file
             WHERE axa01 = g_gizz01 AND axa02 = g_gizz02
            IF l_cnt = 0  THEN
               CALL cl_err(g_gizz02,'agl-118',1)
               NEXT FIELD gizz02
            END IF
            CALL i9431_gizz02('a',g_gizz02,g_gizz01)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gizz02,g_errno,0)
               NEXT FIELD gizz02
            END IF
            IF g_gizz01 IS NOT NULL AND g_gizz02 IS NOT NULL AND
               g_gizz00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_gizz01 AND axa02=g_gizz02
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_gizz01 AND axb04=g_gizz02
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_gizz02,'agl-223',0)
                  LET g_gizz01 = g_gizz01_t
                  LET g_gizz02 = g_gizz02_t
                  LET g_gizz00 = g_gizz00_t
                  DISPLAY BY NAME g_gizz01,g_gizz02,g_gizz00
                  NEXT FIELD gizz02
               END IF
            END IF
         END IF 

      AFTER FIELD gizz07
         IF NOT cl_null(g_gizz07) THEN
            CALL i9431_gizz07('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD gizz07
            END IF
         END IF

     AFTER INPUT
        IF g_gizz01 IS NOT NULL AND g_gizz02 IS NOT NULL AND
           g_gizz00 IS NOT NULL THEN
           LET l_n = 0
           LET l_n1 = 0
           SELECT COUNT(*) INTO l_n FROM axa_file
            WHERE axa01=g_gizz01 AND axa02=g_gizz02
              AND axa03=g_axz05
           SELECT COUNT(*) INTO l_n1 FROM axb_file
            WHERE axb01=g_gizz01 AND axb04=g_gizz02
              AND axb05=g_axz05
           IF l_n+l_n1 = 0 THEN
              CALL cl_err(g_gizz02,'agl-223',0)
              LET g_gizz01 = g_gizz01_t
              LET g_gizz02 = g_gizz02_t
              LET g_gizz00 = g_gizz00_t
              DISPLAY BY NAME g_gizz01,g_gizz02,g_gizz00
              NEXT FIELD gizz01
           END IF
        END IF

      ON ACTION controlp                 # 沿用所有欄位
         CASE
            WHEN INFIELD(gizz00)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_gizz00
               CALL cl_create_qry() RETURNING g_gizz00
               DISPLAY BY NAME g_gizz00
               NEXT FIELD gizz00 
            WHEN INFIELD(gizz01) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_gizz01
               CALL cl_create_qry() RETURNING g_gizz01
               DISPLAY g_gizz01 TO gizz01
               NEXT FIELD gizz01
            WHEN INFIELD(gizz02)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"    
               LET g_qryparam.default1 = g_gizz02
               CALL cl_create_qry() RETURNING g_gizz02
               DISPLAY g_gizz02 TO gizz02 
               NEXT FIELD gizz02
            WHEN INFIELD(gizz07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_giqq"
               CALL cl_create_qry() RETURNING g_gizz07
               DISPLAY BY NAME g_gizz07
               NEXT FIELD gizz07
            OTHERWISE
               EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
   END INPUT
END FUNCTION

FUNCTION i9431_gizz07(p_cmd)
DEFINE
   p_cmd       LIKE type_file.chr1,
   l_giqq02    LIKE giqq_file.giqq02

   LET g_errno=''
   SELECT giqq02 INTO l_giqq02
     FROM giqq_file
     WHERE giqq01=g_gizz07
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917'
                                LET l_giqq02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
     DISPLAY l_giqq02 TO giqq02 
   END IF
END FUNCTION

#Query 查詢
FUNCTION i9431_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gizz00 TO NULL
    INITIALIZE g_gizz01 TO NULL                              
    INITIALIZE g_gizz02 TO NULL                              

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i9431_cs()                         #取得查詢條件
   IF INT_FLAG THEN                        #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i9431_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                   #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_gizz00 TO NULL
      INITIALIZE g_gizz01 TO NULL                              
      INITIALIZE g_gizz02 TO NULL                              
   ELSE
      CALL i9431_fetch('F')                #讀出TEMP第一筆並顯示
      OPEN i9431_count
      FETCH i9431_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
END FUNCTION

#處理資料的讀取
FUNCTION i9431_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式
   l_abso          LIKE type_file.num10                 #絕對的筆數

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i9431_b_cs INTO g_gizz00,g_gizz01,g_gizz02,g_gizz03,g_gizz04,g_gizz07
       WHEN 'P' FETCH PREVIOUS i9431_b_cs INTO g_gizz00,g_gizz01,g_gizz02,g_gizz03,g_gizz04,g_gizz07
       WHEN 'F' FETCH FIRST    i9431_b_cs INTO g_gizz00,g_gizz01,g_gizz02,g_gizz03,g_gizz04,g_gizz07
       WHEN 'L' FETCH LAST     i9431_b_cs INTO g_gizz00,g_gizz01,g_gizz02,g_gizz03,g_gizz04,g_gizz07
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
      FETCH ABSOLUTE g_jump i9431_b_cs INTO g_gizz00,g_gizz01,g_gizz02,g_gizz03,g_gizz04,g_gizz07
      LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_gizz01,SQLCA.sqlcode,0)
      INITIALIZE g_gizz01 TO NULL  #TQC-6B0105
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

   CALL i9431_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i9431_show()
   
   DISPLAY g_gizz00 TO gizz00
   DISPLAY g_gizz01 TO gizz01
   DISPLAY g_gizz02 TO gizz02
   DISPLAY g_gizz03 TO gizz03
   DISPLAY g_gizz04 TO gizz04
   DISPLAY g_gizz07 TO gizz07

   CALL i9431_gizz02('d',g_gizz02,g_gizz01)
   CALL i9431_gizz07('d')
   CALL i9431_b_fill(g_wc)                 #單身

   CALL cl_show_fld_cont()                 
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i9431_r()
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_gizz01 IS NULL THEN
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "gizz00"
       LET g_doc.value1  =  g_gizz00
       LET g_doc.column2 = "gizz01"
       LET g_doc.value2  =  g_gizz01
       LET g_doc.column3 = "gizz02"
       LET g_doc.value3  =  g_gizz02
       LET g_doc.column4 = "gizz03"
       LET g_doc.value4  =  g_gizz03
       LET g_doc.column5 = "gizz04"
       LET g_doc.value5  =  g_gizz04
       CALL cl_del_doc()                
      DELETE FROM gizz_file
       WHERE gizz00 = g_gizz00 AND gizz01 = g_gizz01
         AND gizz02 = g_gizz02 AND gizz03 = g_gizz03
         AND gizz04 = g_gizz04 AND gizz07 = g_gizz07 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gizz_file",g_gizz01,"",SQLCA.sqlcode,"","BODY DELETE:",1)
      ELSE
         CLEAR FORM
         CALL g_gizz.clear()
         LET g_gizz00 = NULL
         LET g_gizz01 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i9431_count
         FETCH i9431_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i9431_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i9431_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i9431_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

#單身
FUNCTION i9431_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,     #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,     #單身鎖住否
   p_cmd           LIKE type_file.chr1,     #處理狀態
   l_chr           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,     #可新增否         
   l_allow_delete  LIKE type_file.num5      #可刪除否         

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF g_gizz00 IS NULL OR g_gizz01 IS NULL THEN
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示

   LET g_forupd_sql = "SELECT gizz06,'',gizz05 FROM gizz_file"
                     ," WHERE gizz00 = ? AND gizz01 = ? AND gizz02 = ? "
                     ,"   AND gizz03 = ? AND gizz04 = ? AND gizz06 = ? AND gizz07 = ? "
                     ,"   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i9431_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_gizz WITHOUT DEFAULTS FROM s_gizz.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
   
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'                   
            LET g_gizz_t.* = g_gizz[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i9431_bcl USING g_gizz00,g_gizz01,g_gizz02,g_gizz03,g_gizz04,g_gizz_t.gizz06,g_gizz07
            IF STATUS THEN
               CALL cl_err("OPEN i9431_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i9431_bcl INTO g_gizz_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock gizz',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()
         END IF
   
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gizz[l_ac].* TO NULL
         INITIALIZE g_gizz_t.* TO NULL  
         CALL cl_show_fld_cont()
         NEXT FIELD gizz06
   
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         {#######判斷是否有重複#######}
         INSERT INTO gizz_file (gizz00,gizz01,gizz02,gizz03,gizz04,gizz05,gizz06,gizz07)
                         VALUES(g_gizz00,g_gizz01,g_gizz02,g_gizz03,g_gizz04
                               ,g_gizz[l_ac].gizz05,g_gizz[l_ac].gizz06,g_gizz07)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gizz_file",g_gizz00,g_gizz[l_ac].gizz06,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      BEFORE DELETE
         IF cl_delete() THEN
            DELETE FROM gizz_file
             WHERE gizz00 = g_gizz00 AND gizz01 = g_gizz01
               AND gizz02 = g_gizz02 AND gizz03 = g_gizz03
               AND gizz04 = g_gizz04 AND gizz06 = g_gizz_t.gizz06
               AND gizz07 = g_gizz07
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gizz_file",g_gizz01,g_gizz_t.gizz06,SQLCA.sqlcode,"","",1)
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
   
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gizz[l_ac].* = g_gizz_t.*
            CLOSE i9431_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gizz[l_ac].gizz06,-263,1)
            LET g_gizz[l_ac].* = g_gizz_t.*
            LET g_gizz[l_ac].aag02 = i9431_set_gizz06(g_gizz[l_ac].gizz06)
         ELSE
            UPDATE gizz_file SET gizz05 = g_gizz[l_ac].gizz05
                                ,gizz06 = g_gizz[l_ac].gizz06 
             WHERE gizz00 = g_gizz00 AND gizz01 = g_gizz01
               AND gizz02 = g_gizz02 AND gizz03 = g_gizz03
               AND gizz04 = g_gizz04 AND gizz06 = g_gizz_t.gizz06
               AND gizz07 = g_gizz07
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gizz_file",g_gizz00,g_gizz_t.gizz06,SQLCA.sqlcode,"","",1)
               LET g_gizz[l_ac].* = g_gizz_t.*
               LET g_gizz[l_ac].aag02 = i9431_set_gizz06(g_gizz[l_ac].gizz06)
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
               LET g_gizz[l_ac].* = g_gizz_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_gizz.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i9431_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i9431_bcl
         COMMIT WORK

      AFTER FIELD gizz06   #會計科目
         IF NOT cl_null(g_gizz[l_ac].gizz06) THEN
            CALL i9431_gizz()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD gizz06
            END IF
           LET g_gizz[l_ac].aag02 = i9431_set_gizz06(g_gizz[l_ac].gizz06)
         END IF
   
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gizz06) AND l_ac > 1 THEN
            LET g_gizz[l_ac].* = g_gizz[l_ac-1].*
            NEXT FIELD gizz06
         END IF
   
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
   
      ON ACTION CONTROLG
         CALL cl_cmdask()
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(gizz06)
               CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_gizz[l_ac].gizz06,'23',g_gizz00)
                    RETURNING g_gizz[l_ac].gizz06
               DISPLAY g_qryparam.multiret TO gizz06 
               NEXT FIELD gizz06
            OTHERWISE
               EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")                    
   
   END INPUT

   CLOSE i9431_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i9431_gizz()
DEFINE 
   l_gizzacti    LIKE aag_file.aagacti

   LET g_errno = ' '
   
   LET g_sql = "SELECT aag02,aagacti "
              ,"  FROM aag_file"
              ," WHERE aag01 = '",g_gizz[l_ac].gizz06,"'"
              ,"   AND aag00 = '",g_gizz00,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   PREPARE i9431_pre FROM g_sql
   DECLARE i9431_cur CURSOR FOR i9431_pre
   OPEN i9431_cur
   FETCH i9431_cur INTO g_gizz[l_ac].aag02,l_gizzacti

   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-001'
        WHEN l_gizzacti = 'N'    LEt g_errno = '9028'
        OTHERWISE
   END CASE
END FUNCTION

FUNCTION i9431_b_askkey()
   CLEAR FORM
   CALL g_gizz.clear()

   CONSTRUCT g_wc2 ON gizz01,gizz02,gizz00,gizz03,gizz06   #螢幕上取條件 
                 FROM gizz01,gizz02,gizz00,gizz03,s_gizz[1].gizz06
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
   CALL i9431_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i9431_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            STRING,
   l_flag          LIKE type_file.chr1,  #有無單身筆數
   l_sql           STRING
 
   LET l_sql = "SELECT gizz06,aag02,gizz05 "
              ,"  FROM gizz_file,aag_file"
              ," WHERE gizz00 = '",g_gizz00,"'"
              ,"   AND gizz01 = '",g_gizz01,"'" 
              ,"   AND gizz02 = '",g_gizz02,"'" 
              ,"   AND gizz03 = '",g_gizz03,"'" 
              ,"   AND gizz04 = '",g_gizz04,"'" 
              ,"   AND gizz07 = '",g_gizz07,"'" 
              ,"   AND gizz00 = aag_file.aag00 "
              ,"   AND gizz06 = aag_file.aag01 AND ",p_wc CLIPPED
              ," ORDER BY gizz06"

   PREPARE gizz_pre FROM l_sql
   DECLARE gizz_cs CURSOR FOR gizz_pre
   CALL g_gizz.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH gizz_cs INTO g_gizz[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_gizz[g_cnt].aag02=i9431_set_gizz06(g_gizz[g_cnt].gizz06)

      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gizz.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION

FUNCTION i9431_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gizz TO s_gizz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
     ON ACTION delete
        LET g_action_choice="delete"
        EXIT DISPLAY
     ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i9431_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL i9431_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL i9431_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
                              

      ON ACTION next
         CALL i9431_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION last
         CALL i9431_fetch('L')
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

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

#@    ON ACTION 相關文件  
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
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
     #CHI-C40004--
      ON ACTION agli943
         LET g_action_choice="agli943"
         EXIT DISPLAY
     #CHI-C40004--

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i9431_set_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("gizz00",TRUE)
   END IF 

END FUNCTION

FUNCTION i9431_set_no_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("gizz00,gizz01,gizz02,gizz03,gizz04,gizz07",FALSE)
   END IF 
   CALL cl_set_comp_entry("gizz00",FALSE)

END FUNCTION

FUNCTION i9431_u()

   DEFINE l_gizz_lock    RECORD LIKE gizz_file.*
   IF g_chkey = 'N' THEN
      CALL cl_err('','agl-266',1)
      RETURN
   END IF

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_gizz01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gizz00_t = g_gizz00
   LET g_gizz01_t = g_gizz01  
   LET g_gizz02_t = g_gizz02
   LET g_gizz03_t = g_gizz03
   LET g_gizz04_t = g_gizz04
   LET g_gizz07_t = g_gizz07
   BEGIN WORK
   
   OPEN i9431_cl USING g_gizz00,g_gizz01,g_gizz02,g_gizz03,g_gizz04,g_gizz07
   IF STATUS THEN
      CALL cl_err("OPEN i9431_cl:", STATUS, 1)
      CLOSE i9431_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i9431_cl INTO g_gizz_lock.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_gizz01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i9431_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL i9431_show()
   WHILE TRUE
      LET g_gizz00_t = g_gizz00
      LET g_gizz01_t = g_gizz01
      LET g_gizz02_t = g_gizz02
      LET g_gizz03_t = g_gizz03
      LET g_gizz04_t = g_gizz04 
      LET g_gizz07_t = g_gizz07 
      CALL i9431_i("u")                      #欄位更改

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_gizz00 = g_gizz00_t
         LET g_gizz01 = g_gizz01_t
         LET g_gizz02 = g_gizz02_t
         LET g_gizz03 = g_gizz03_t
         LET g_gizz04 = g_gizz04_t
         LET g_gizz07 = g_gizz07_t
         DISPLAY g_gizz00,g_gizz01,g_gizz02,g_gizz03,g_gizz04,g_gizz07
              TO gizz00,gizz01,gizz02,gizz03,gizz04,gizz07
         LET INT_FLAG = 0
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      UPDATE gizz_file SET gizz00 = g_gizz00,gizz01 = g_gizz01,gizz02 = g_gizz02
                          ,gizz03 = g_gizz03,gizz04 = g_gizz04,gizz07 = g_gizz07
       WHERE gizz00 = g_gizz00_t AND gizz01 = g_gizz01_t AND gizz02 = g_gizz02_t
         AND gizz03 = g_gizz03_t AND gizz04 = g_gizz04_t AND gizz07 = g_gizz07_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","gizz_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE i9431_cl
   COMMIT WORK
   CALL i9431_show()
   CALL i9431_b_fill("1=1")
END FUNCTION

FUNCTION  i9431_gizz02(p_cmd,p_gizz02,p_gizz01)
DEFINE p_cmd           LIKE type_file.chr1,         
       p_gizz01        LIKE gizz_file.gizz01,
       p_gizz02        LIKE gizz_file.gizz02,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05,
       l_aaz641        LIKE aaz_file.aaz641,    
       l_axa09         LIKE axa_file.axa09

   LET g_errno = ' '
   SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05 
     FROM axz_file
    WHERE axz01 = p_gizz02
   CALL s_aaz641_dbs(p_gizz01,p_gizz02) RETURNING g_dbs_axz03
   CALL s_get_aaz641(g_dbs_axz03) RETURNING l_aaz641

   SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01 = p_gizz02 
   LET g_gizz00 = l_aaz641 
   LET g_axz05 = l_axz05

   CASE
      WHEN SQLCA.SQLCODE=100 
         LET g_errno = 'agl-988'
         LET l_axz02 = NULL
         LET l_axz03 = NULL 
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_axz02 TO FORMONLY.axz1
      DISPLAY g_gizz00 TO gizz00 
   END IF

END FUNCTION

FUNCTION i9431_set_gizz06(p_gizz06)
   DEFINE l_aag02 LIKE aag_file.aag02
   DEFINE p_gizz06 LIKE gizz_file.gizz06
   IF cl_null(p_gizz06) THEN RETURN NULL END IF
   LET l_aag02=''

   LET g_sql = "SELECT aag02 FROM aag_file",
               " WHERE aag01 = '",p_gizz06,"'",
               "   AND aag00 = '",g_gizz00,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   PREPARE i9431_pre_3 FROM g_sql
   DECLARE i9431_cur_3 CURSOR FOR i9431_pre_3
   OPEN i9431_cur_3
   FETCH i9431_cur_3 INTO l_aag02
   RETURN l_aag02
END FUNCTION

FUNCTION i9411_gizz()
DEFINE
   l_gizzacti    LIKE aag_file.aagacti

   LET g_errno = ' '

   LET g_sql = "SELECT aag02,aagacti  ",
               "  FROM aag_file",
               " WHERE aag01 = '",g_gizz[l_ac].gizz06,"'",
               "   AND aag00 = '",g_gizz00,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   PREPARE i9431_pre1 FROM g_sql
   DECLARE i9431_cur1 CURSOR FOR i9431_pre1
   OPEN i9431_cur1
   FETCH i9431_cur1 INTO g_gizz[l_ac].aag02,l_gizzacti

   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-001'
        WHEN l_gizzacti = 'N'     LEt g_errno = '9028'
        OTHERWISE
   END CASE
END FUNCTION
