# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: agli9411.4gl
# Descriptions...: 現金流量表活動科目設定(合併)
# Date & Author..: 12/01/11 By Lori(FUN-BC0123)
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BC0123
#模組變數(Module Variables)
DEFINE
    g_giww00         LIKE giww_file.giww00,
    g_giww01         LIKE giww_file.giww01,   #活動類別(假單頭)
    g_giww00_t       LIKE giww_file.giww00,   #活動類別(舊值)
    g_giww01_t       LIKE giww_file.giww01,   #活動類別(舊值)
    g_giww05         LIKE giww_file.giww05,   
    g_giww05_t       LIKE giww_file.giww05,   
    g_giww06         LIKE giww_file.giww06,   
    g_giww06_t       LIKE giww_file.giww06,   
    g_axz05          LIKE axz_file.axz05,   
    g_giww_lock      RECORD LIKE giww_file.*,   
    g_giww           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        giww02       LIKE giww_file.giww02,   #科目編號
        aag02        LIKE aag_file.aag02,     #科目名稱
        giww03       LIKE giww_file.giww03,   #加減項
        giww04       LIKE giww_file.giww04    #異動別
                     END RECORD,
    g_giww_t         RECORD                   #程式變數 (舊值)
        giww02       LIKE giww_file.giww02,   #科目編號
        aag02        LIKE aag_file.aag02,     #科目名稱
        giww03       LIKE giww_file.giww03,   #加減項
        giww04       LIKE giww_file.giww04    #異動別
                     END RECORD,
    g_wc,g_wc2,g_sql STRING,
    g_sql_tmp        STRING,
    g_rec_b          LIKE type_file.num5,    #單身筆數               
    l_ac             LIKE type_file.num5     #目前處理的ARRAY CNT    
DEFINE g_str         STRING 
DEFINE g_dbs_axz03   LIKE type_file.chr21,
       g_aaz641       LIKE aaz_file.aaz641,  
       g_plant_axz03  LIKE type_file.chr10    
DEFINE l_sql         STRING                                                 
DEFINE l_table       STRING     

#主程式開始

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL       
DEFINE g_before_input_done  LIKE type_file.num5       
DEFINE   g_cnt           LIKE type_file.num10 
DEFINE   g_i             LIKE type_file.num5  
DEFINE   g_msg           LIKE ze_file.ze03    
DEFINE   g_row_count     LIKE type_file.num10 
DEFINE   g_curs_index    LIKE type_file.num10 
DEFINE   g_jump          LIKE type_file.num10 
DEFINE   mi_no_ask       LIKE type_file.num5  

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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   LET g_sql = "giww00.giww_file.giww00,",
               "giww01.giww_file.giww01,",
               "giww02.giww_file.giww02,",
               "giww05.giww_file.giww05,",
               "giww06.giww_file.giww06,",
               "axz02.axz_file.axz02,",
               "axz03.axz_file.axz03,",
               "aag02.aag_file.aag02,",
               "giww03.giww_file.giww03,", 
               "giww04.giww_file.giww04,",
               "giqq02.giqq_file.giqq02,"
   LET l_table = cl_prt_temptable('agli9411',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?) "                                    
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                 
   LET p_row = ARG_VAL(2)               #取得螢幕位置
   LET p_col = ARG_VAL(3)
   LET g_giww01   = NULL                #清除鍵值
   LET g_giww01_t = NULL
   LET g_giww00   = NULL                #清除鍵值
   LET g_giww00_t = NULL
   LET g_giww05   = NULL                  
   LET g_giww05_t = NULL                  
   LET g_giww06   = NULL                  
   LET g_giww06_t = NULL                  
   LET g_giww00   = NULL                  
   LET g_giww00_t = NULL                  
   LET p_row = 3 LET p_col = 14
       
   OPEN WINDOW i9411_w AT p_row,p_col      #顯示畫面
     WITH FORM "agl/42f/agli9411"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()

   LET g_forupd_sql = " SELECT * FROM giww_file ",
                      " WHERE giww00 = ? AND giww01 = ? AND giww05 = ? AND giww06= ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i9411_cl CURSOR FROM g_forupd_sql
   CALL i9411_menu()
   CLOSE WINDOW i9411_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#QBE 查詢資料
FUNCTION i9411_cs()
   CLEAR FORM                                   #清除畫面
      CALL g_giww.clear()
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 

   INITIALIZE g_giww00 TO NULL    
   INITIALIZE g_giww01 TO NULL    

   INITIALIZE g_giww05 TO NULL
   INITIALIZE g_giww06 TO NULL
  
   CONSTRUCT g_wc ON giww05,giww06,giww00,giww01,giww02,giww03,giww04                    #螢幕上取條件                  
                FROM giww05,giww06,giww00,giww01,s_giww[1].giww02,
                     s_giww[1].giww03,s_giww[1].giww04                 
  
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
  
      ON ACTION controlp                 # 沿用所有欄位
         CASE
            WHEN INFIELD(giww00)                                                                                                       
               CALL cl_init_qry_var()                                                                                                 
               LET g_qryparam.state = "c"                                                                                             
               LET g_qryparam.form ="q_aaa"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
               DISPLAY g_qryparam.multiret TO giww00                                                                                   
               NEXT FIELD giww00                                                                                                       

            WHEN INFIELD(giww01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_giqq"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giww01
               NEXT FIELD giww01 
            WHEN INFIELD(giww02)
               CALL q_m_aag2(TRUE,TRUE,g_dbs_axz03,g_giww[1].giww02,'23',g_giww00)
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giww02
               NEXT FIELD giww02

              WHEN INFIELD(giww05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_axa1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO giww05
                 NEXT FIELD giww05
              WHEN INFIELD(giww06)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axz"      
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO giww06  
                 NEXT FIELD giww06

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
   LET g_sql="SELECT UNIQUE giww00,giww01,giww05,giww06 FROM giww_file ", # 組合出SQL 指令,看giww01有幾種就run幾次
             " WHERE ", g_wc CLIPPED,
             " ORDER BY 1"
   PREPARE i9411_prepare FROM g_sql              #預備一下
   DECLARE i9411_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i9411_prepare
                                                #計算本次查詢單頭的筆數
   DROP TABLE x
   LET g_sql_tmp= "SELECT UNIQUE giww00,giww01,giww05,giww06 FROM giww_file ",
                  " WHERE ",g_wc CLIPPED,                                                                                           
                  "   INTO TEMP x"                                                                                                  

   PREPARE i9411_pre_x FROM g_sql_tmp                                                                                   
   EXECUTE i9411_pre_x                                                                                                               
   LET g_sql = "SELECT COUNT(*) FROM x"                                                                                             

   PREPARE i9411_precount FROM g_sql
   DECLARE i9411_count CURSOR FOR i9411_precount
END FUNCTION

FUNCTION i9411_menu()

   WHILE TRUE
      CALL i9411_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i9411_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i9411_q()
            END IF
        WHEN "delete" 
           IF cl_chk_act_auth() THEN
              CALL i9411_r()
           END IF
        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i9411_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i9411_b()
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
               IF g_giww00 IS NULL OR g_giww01 IS NOT NULL THEN
                  LET g_doc.column1 = "giww01"
                  LET g_doc.value1 = g_giww01
                  LET g_doc.column2 = "giww05"
                  LET g_doc.value2 = g_giww05
                  LET g_doc.column3 = "giww06"
                  LET g_doc.value3 = g_giww06
                  LET g_doc.column4 = "giww00"
                  LET g_doc.value4 = g_giww00
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_giww),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION i9411_a()
DEFINE   l_n    LIKE type_file.num5          
   
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_giww.clear()

   INITIALIZE g_giww01 LIKE giww_file.giww01
   LET g_giww01_t = NULL
   INITIALIZE g_giww00 LIKE giww_file.giww00
   LET g_giww00_t = NULL

   INITIALIZE g_giww05 LIKE giww_file.giww05      #DEFAULT 設定  
   INITIALIZE g_giww06 LIKE giww_file.giww06      #DEFAULT 設定  
   LET g_giww05_t = NULL
   LET g_giww06_t = NULL

  #預設值及將數值類變數清成零

   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i9411_i("a")                           #輸入單頭
      IF INT_FLAG THEN                            #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_giww.clear()
      SELECT COUNT(*) INTO l_n FROM giww_file WHERE giww01=g_giww01
                                                AND giww00=g_giww00
                                                AND giww05=g_giww05
                                                AND giww06=g_giww06
      LET g_rec_b = 0 
      IF l_n > 0 THEN
         CALL i9411_b_fill('1=1')
      END IF
      CALL i9411_b()                             #輸入單身
      LET g_giww00_t = g_giww00                   #保留舊值 #No.FUN-740020
      LET g_giww01_t = g_giww01                   #保留舊值
      LET g_giww05_t = g_giww05                   #保留舊值 #FUN-920121 add
      LET g_giww06_t = g_giww06                   #保留舊值 #FUN-920121 add
      EXIT WHILE
   END WHILE
END FUNCTION

#處理INPUT
FUNCTION i9411_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改
   l_cnt           LIKE type_file.num5,
   l_n1,l_n        LIKE type_file.num5      

   CALL cl_set_head_visible("","YES")

   INPUT g_giww05,g_giww06,g_giww00,g_giww01 WITHOUT DEFAULTS FROM giww05,giww06,giww00,giww01
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i9411_set_entry(p_cmd)
         CALL i9411_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD giww00 
         LET l_cnt = 0

         CALL s_aaz641_dbs(g_giww05,g_giww06) RETURNING g_plant_axz03
         CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641

         LET g_sql = "SELECT COUNT(*) ",
                    #"  FROM ",g_dbs_axz03,"aaa_file",  #優化,跨GP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實現
                     "  FROM ",cl_get_target_table(g_plant_axz03,'aaa_file'),
                     " WHERE aaa01 = '",g_giww00,"'",
                     "   AND aaaacti = 'Y' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_dbs_axz03) RETURNING g_sql
         PREPARE i9411_pre_2 FROM g_sql
         DECLARE i9411_cur_2 CURSOR FOR i9411_pre_2
         OPEN i9411_cur_2
         FETCH i9411_cur_2 INTO l_cnt
         IF l_cnt = 0 THEN
            CALL cl_err('','agl-095',0)   
            NEXT FIELD giww00
         END IF

      AFTER FIELD giww01                  #設定活動類別
         IF NOT cl_null(g_giww01) THEN
            CALL i9411_giww01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD giww01
            END IF
         END IF

      AFTER FIELD giww05   #族群代號
         IF cl_null(g_giww05) THEN
            CALL cl_err(g_giww05,'mfg0037',0)
            NEXT FIELD giww05
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=g_giww05
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_giww05,'agl-223',0)
               NEXT FIELD giww05
            END IF
         END IF

      AFTER FIELD giww06   #上層公司 
         IF NOT cl_null(g_giww06) THEN 
            SELECT count(*) INTO l_cnt FROM axa_file
             WHERE axa01 = g_giww05 AND axa02 = g_giww06
            IF l_cnt = 0  THEN
               CALL cl_err(g_giww06,'agl-118',1)
               NEXT FIELD giww06
            END IF
            CALL i9411_giww06('a',g_giww06,g_giww05)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_giww06,g_errno,0)
               NEXT FIELD giww06
            END IF
            IF g_giww05 IS NOT NULL AND g_giww06 IS NOT NULL AND
               g_giww00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_giww05 AND axa02=g_giww06
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_giww05 AND axb04=g_giww06
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_giww06,'agl-223',0)
                  LET g_giww05 = g_giww05_t
                  LET g_giww06 = g_giww06_t
                  LET g_giww00 = g_giww00_t
                  DISPLAY BY NAME g_giww05,g_giww06,g_giww00
                  NEXT FIELD giww06
               END IF
            END IF
         END IF 

     AFTER INPUT
        IF g_giww05 IS NOT NULL AND g_giww06 IS NOT NULL AND
               g_giww00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_giww05 AND axa02=g_giww06
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_giww05 AND axb04=g_giww06
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_giww06,'agl-223',0)
                  LET g_giww05 = g_giww05_t
                  LET g_giww06 = g_giww06_t
                  LET g_giww00 = g_giww00_t
                  DISPLAY BY NAME g_giww05,g_giww06,g_giww00
                  NEXT FIELD giww05
               END IF
            END IF

      ON ACTION controlp                 # 沿用所有欄位
         CASE
            WHEN INFIELD(giww00)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_giww00
               CALL cl_create_qry() RETURNING g_giww00
               DISPLAY BY NAME g_giww00
               NEXT FIELD giww00 
            WHEN INFIELD(giww01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_giqq"
               LET g_qryparam.default1 = g_giww01
               CALL cl_create_qry() RETURNING g_giww01
               DISPLAY BY NAME g_giww01
               NEXT FIELD giww01 
            WHEN INFIELD(giww05) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_giww05
               CALL cl_create_qry() RETURNING g_giww05
               DISPLAY g_giww05 TO giww05
               NEXT FIELD giww05
            WHEN INFIELD(giww06)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"    
               LET g_qryparam.default1 = g_giww06
               CALL cl_create_qry() RETURNING g_giww06
               DISPLAY g_giww06 TO giww06 
               NEXT FIELD giww06
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

FUNCTION i9411_giww01(p_cmd)
DEFINE
   p_cmd       LIKE type_file.chr1,
   l_giqq02    LIKE giqq_file.giqq02

   LET g_errno=''
   SELECT giqq02 INTO l_giqq02
     FROM giqq_file
     WHERE giqq01=g_giww01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917'
                                LET l_giqq02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
     DISPLAY l_giqq02 TO FORMONLY.giqq02 
   END IF
END FUNCTION

#Query 查詢
FUNCTION i9411_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_giww00,g_giww01 TO NULL
    INITIALIZE g_giww05 TO NULL                              
    INITIALIZE g_giww06 TO NULL                              

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i9411_cs()                         #取得查詢條件
   IF INT_FLAG THEN                        #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i9411_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                   #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_giww00,g_giww01 TO NULL
      INITIALIZE g_giww05 TO NULL                              
      INITIALIZE g_giww06 TO NULL                              
   ELSE
      CALL i9411_fetch('F')                #讀出TEMP第一筆並顯示
      OPEN i9411_count
      FETCH i9411_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
END FUNCTION

#處理資料的讀取
FUNCTION i9411_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式
   l_abso          LIKE type_file.num10                 #絕對的筆數

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i9411_b_cs INTO g_giww00,g_giww01,g_giww05,g_giww06
       WHEN 'P' FETCH PREVIOUS i9411_b_cs INTO g_giww00,g_giww01,g_giww05,g_giww06
       WHEN 'F' FETCH FIRST    i9411_b_cs INTO g_giww00,g_giww01,g_giww05,g_giww06
       WHEN 'L' FETCH LAST     i9411_b_cs INTO g_giww00,g_giww01,g_giww05,g_giww06
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
      FETCH ABSOLUTE g_jump i9411_b_cs INTO g_giww00,g_giww01,g_giww05,g_giww06
      LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_giww01,SQLCA.sqlcode,0)
      INITIALIZE g_giww01 TO NULL  #TQC-6B0105
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

   CALL i9411_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i9411_show()
   
   DISPLAY g_giww00 TO giww00               #單頭 #No.FUN-740020
   DISPLAY g_giww01 TO giww01               #單頭
   DISPLAY g_giww05 TO giww05           
   DISPLAY g_giww06 TO giww06           

   CALL i9411_giww06('d',g_giww06,g_giww05)
   CALL i9411_giww01('d')
   CALL i9411_b_fill(g_wc)                 #單身

   CALL cl_show_fld_cont()                 
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i9411_r()
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_giww01 IS NULL THEN
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       
       LET g_doc.column1 = "giww01"      
       LET g_doc.value1 = g_giww01       
       LET g_doc.column2 = "giww05"      
       LET g_doc.value2 = g_giww05       
       LET g_doc.column3 = "giww06"      
       LET g_doc.value3 = g_giww06       
       LET g_doc.column4 = "giww00"      
       LET g_doc.value4 = g_giww00       
       CALL cl_del_doc()                
      DELETE FROM giww_file WHERE giww00 = g_giww00
                              AND giww01 = g_giww01
                              AND giww05 = g_giww05 
                              AND giww06 = g_giww06 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","giww_file",g_giww01,"",SQLCA.sqlcode,"","BODY DELETE:",1)
      ELSE
         CLEAR FORM
         CALL g_giww.clear()
         LET g_giww00 = NULL
         LET g_giww01 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i9411_count
         FETCH i9411_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i9411_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i9411_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i9411_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

#單身
FUNCTION i9411_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,     #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,     #單身鎖住否
   p_cmd           LIKE type_file.chr1,     #處理狀態
   l_giww_delyn     LIKE type_file.chr1,    #判斷是否可以刪除單身資料ROW
   l_chr           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,     #可新增否         
   l_allow_delete  LIKE type_file.num5      #可刪除否         

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF g_giww00 IS NULL OR g_giww01 IS NULL THEN
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示

   LET g_forupd_sql = "SELECT giww02,'',giww03,giww04 FROM giww_file",
                      " WHERE giww00 = ? AND giww01=? AND giww02=? AND giww05=? AND giww06=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i9411_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_giww WITHOUT DEFAULTS FROM s_giww.*
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
            LET g_giww_t.* = g_giww[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i9411_bcl USING g_giww00,g_giww01,g_giww_t.giww02,g_giww05,g_giww06
            IF STATUS THEN
               CALL cl_err("OPEN i9411_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i9411_bcl INTO g_giww_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock giww',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()
         END IF
   
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_giww[l_ac].* TO NULL
         INITIALIZE g_giww_t.* TO NULL  
         IF l_ac > 1 THEN
            LET g_giww[l_ac].giww03 = g_giww[l_ac-1].giww03
            LET g_giww[l_ac].giww04 = g_giww[l_ac-1].giww04
         END IF
         CALL cl_show_fld_cont()
         NEXT FIELD giww02
   
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO giww_file (giww00,giww01,giww02,giww03,giww04,giww05,giww06)  
                         VALUES(g_giww00,g_giww01,g_giww[l_ac].giww02,g_giww[l_ac].giww03,  
                                g_giww[l_ac].giww04,g_giww05,g_giww06)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","giww_file",g_giww01,g_giww[l_ac].giww02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      AFTER FIELD giww02
         IF NOT cl_null(g_giww[l_ac].giww02) THEN
            CALL i9411_giww()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD giww02
            END IF
         END IF
         IF g_giww[l_ac].giww02 != g_giww_t.giww02 OR
            cl_null(g_giww_t.giww02) THEN
            SELECT COUNT(*) INTO l_n FROM giww_file
             WHERE giww02 = g_giww[l_ac].giww02 
            IF l_n > 0 THEN    #科目已存在其他群組中
               IF NOT cl_confirm('agl-919') THEN
                  NEXT FIELD giww02
               END IF
            END IF
            SELECT count(*) INTO l_n FROM giww_file 
             WHERE giww01 = g_giww01 AND giww02 = g_giww[l_ac].giww02
               AND giww00 = g_giww00
               AND giww05 = g_giww05
               AND giww06 = g_giww06
            IF l_n <> 0 THEN
               LET g_giww[l_ac].giww02 = g_giww_t.giww02
               CALL cl_err('','-239',0) 
               NEXT FIELD giww02
            END IF
         END IF
   
      AFTER FIELD giww03
         IF NOT cl_null(g_giww[l_ac].giww03) THEN
            IF g_giww[l_ac].giww03 NOT MATCHES '[-+]' THEN 
               NEXT FIELD giww03 
            END IF
         END IF
   
      AFTER FIELD giww04
         IF NOT cl_null(g_giww[l_ac].giww04) THEN
            IF g_giww[l_ac].giww04 NOT MATCHES '[123456]' THEN
               NEXT FIELD giww04
            END IF 
         END IF
   
      BEFORE DELETE                                    #modify:Mandy
         #判斷是否可以刪除此ROW,因為此ROW可能和其它file有key值的關聯性,
         #所以不能隨便亂刪掉
         CALL i9411_giww_delyn() RETURNING l_giww_delyn 
         IF g_giww_t.giww02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN   #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_giww_delyn = 'N ' THEN   #為不可刪除此ROW的狀態下
               #人工輸入金額設定作業中此ROW已被使用,不可刪除!!
               CALL cl_err(g_giww_t.giww02,'agl-918',0) 
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM giww_file WHERE giww00 = g_giww00
                                    AND giww01 = g_giww01
                                    AND giww02 = g_giww_t.giww02 
                                    AND giww05 = g_giww05
                                    AND giww06 = g_giww06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","giww_file",g_giww01,g_giww_t.giww02,SQLCA.sqlcode,"","",1)
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_giww[l_ac].* = g_giww_t.*
            CLOSE i9411_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_giww[l_ac].giww02,-263,1)
            LET g_giww[l_ac].* = g_giww_t.*
         ELSE
            UPDATE giww_file SET giww02 = g_giww[l_ac].giww02,
                                giww03 = g_giww[l_ac].giww03,
                                giww04 = g_giww[l_ac].giww04 
             WHERE giww00=g_giww00
               AND giww01=g_giww01
               AND giww02=g_giww_t.giww02
               AND giww05=g_giww05
               AND giww06=g_giww06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","giww_file",g_giww01,g_giww_t.giww02,SQLCA.sqlcode,"","",1)
               LET g_giww[l_ac].* = g_giww_t.*
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
            IF p_cmd='u' THEN
               LET g_giww[l_ac].* = g_giww_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_giww.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i9411_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032 add
         CLOSE i9411_bcl
         COMMIT WORK
   
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(giww02) AND l_ac > 1 THEN
            LET g_giww[l_ac].* = g_giww[l_ac-1].*
            NEXT FIELD giww02
         END IF
   
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
   
      ON ACTION CONTROLG
         CALL cl_cmdask()
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(giww02)
               CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_giww[l_ac].giww02,'23',g_giww00)
                    RETURNING g_giww[l_ac].giww02
               DISPLAY g_qryparam.multiret TO giww02 
               NEXT FIELD giww02
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

   CLOSE i9411_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i9411_giww()
DEFINE 
   l_giwwacti    LIKE aag_file.aagacti

   LET g_errno = ' '

   CALL s_aaz641_dbs(g_giww05,g_giww06) RETURNING g_plant_axz03
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641 
  
   LET g_sql = "SELECT aag02,aagacti  ",
              #"  FROM ",g_dbs_axz03,"aag_file",  #優化,跨GP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實現
               "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),
               " WHERE aag01 = '",g_giww[l_ac].giww02,"'",
               "   AND aag00 = '",g_giww00,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_dbs_axz03) RETURNING g_sql
   PREPARE i9411_pre FROM g_sql
   DECLARE i9411_cur CURSOR FOR i9411_pre
   OPEN i9411_cur
   FETCH i9411_cur INTO g_giww[l_ac].aag02,l_giwwacti

   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-001'
        WHEN l_giwwacti = 'N'     LEt g_errno = '9028'
        OTHERWISE
   END CASE
END FUNCTION

FUNCTION i9411_giww_delyn()
DEFINE 
   l_delyn       LIKE type_file.chr1,      #存放可否刪除的變數  #No.FUN-680098   VARCHAR(1)   
   l_n           LIKE type_file.num5          
   
   LET l_delyn = 'Y'

   SELECT COUNT(*)  INTO l_n FROM gixx_file 
    WHERE gixx01 = g_giww01
      AND gixx02 = g_giww[l_ac].giww02 
      AND giww00 = g_giww00
      AND gixx08 = g_giww05
      AND gixx09 = g_giww06

   IF l_n > 0 THEN 
      LET l_delyn = 'N'
   END IF
   RETURN l_delyn
END FUNCTION

FUNCTION i9411_b_askkey()
   CLEAR FORM
   CALL g_giww.clear()

   CONSTRUCT g_wc2 ON giww05,giww06,giww00,giww01,giww02,giww03,giww04   #螢幕上取條件 
                 FROM giww05,giww06,giww00,giww01,s_giww[1].giww02,s_giww[1].giww03,s_giww[1].giww04 

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
   CALL i9411_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i9411_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            STRING,
   l_flag          LIKE type_file.chr1,  #有無單身筆數
   l_sql           STRING
 
   LET l_sql = "SELECT giww02,aag02,giww03,giww04 ",
               "  FROM giww_file,OUTER aag_file",
               " WHERE giww01 = '",g_giww01,"'",
               "   AND giww00 = '",g_giww00,"'", 
               "   AND giww05 = '",g_giww05,"'", 
               "   AND giww06 = '",g_giww06,"'", 
               "   AND giww00 = aag_file.aag00 ",
               "   AND giww02 = aag_file.aag01 AND ",p_wc CLIPPED,
               " ORDER BY giww02"

   PREPARE giww_pre FROM l_sql
   DECLARE giww_cs CURSOR FOR giww_pre

   CALL g_giww.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH giww_cs INTO g_giww[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_giww[g_cnt].aag02=i9411_set_giww02(g_giww[g_cnt].giww02)

      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_giww.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION

FUNCTION i9411_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_giww TO s_giww.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
         CALL i9411_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL i9411_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL i9411_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
                              

      ON ACTION next
         CALL i9411_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION last
         CALL i9411_fetch('L')
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

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i9411_set_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("giww00,giww01",TRUE)
   END IF 

END FUNCTION

FUNCTION i9411_set_no_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("giww00,giww01,giww02,giww05,giww06",FALSE)
   END IF 
   CALL cl_set_comp_entry("giww00",FALSE)

END FUNCTION

FUNCTION i9411_u()

   DEFINE l_giww_lock    RECORD LIKE giww_file.*
   IF g_chkey = 'N' THEN
      CALL cl_err('','agl-266',1)
      RETURN
   END IF

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_giww01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_giww00_t = g_giww00
   LET g_giww01_t = g_giww01
   LET g_giww05_t = g_giww05
   LET g_giww06_t = g_giww06
   BEGIN WORK
   
   OPEN i9411_cl USING g_giww00,g_giww01,g_giww05,g_giww06
   IF STATUS THEN
      CALL cl_err("OPEN i9411_cl:", STATUS, 1)
      CLOSE i9411_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i9411_cl INTO g_giww_lock.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_giww01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i9411_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL i9411_show()
   WHILE TRUE
      LET g_giww00_t = g_giww00
      LET g_giww01_t = g_giww01
      LET g_giww05_t = g_giww05
      LET g_giww06_t = g_giww06               
      CALL i9411_i("u")                      #欄位更改

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_giww00 = g_giww00_t
         LET g_giww01 = g_giww01_t
         LET g_giww05 = g_giww05_t
         LET g_giww06 = g_giww06_t
         DISPLAY g_giww00,g_giww01,g_giww05,g_giww06 TO giww00,giww01,giww05,giww06 
         LET INT_FLAG = 0
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      UPDATE giww_file SET giww00 = g_giww00,giww01 = g_giww01,giww05 = g_giww05,giww06 = g_giww06
       WHERE giww00 = g_giww00_t
         AND giww01 = g_giww01_t
         AND giww05 = g_giww05_t
         AND giww06 = g_giww06_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","giww_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE i9411_cl
   COMMIT WORK
   CALL i9411_show()
   CALL i9411_b_fill("1=1")
END FUNCTION

FUNCTION  i9411_giww06(p_cmd,p_giww06,p_giww05)
DEFINE p_cmd           LIKE type_file.chr1,         
       p_giww05        LIKE giww_file.giww05,
       p_giww06        LIKE giww_file.giww06,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05,
       l_aaz641        LIKE aaz_file.aaz641,    
       l_axa09         LIKE axa_file.axa09

   LET g_errno = ' '
   SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05 
     FROM axz_file
    WHERE axz01 = p_giww06
   CALL s_aaz641_dbs(p_giww05,p_giww06) RETURNING g_dbs_axz03
   CALL s_get_aaz641(g_dbs_axz03) RETURNING l_aaz641

   SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01 = p_giww06 
   LET g_giww00 = l_aaz641 
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
      DISPLAY l_axz02 TO FORMONLY.axz02 
      DISPLAY l_axz03 TO FORMONLY.axz03                                          
      DISPLAY g_giww00 TO FORMONLY.giww00 
   END IF

END FUNCTION

FUNCTION i9411_set_giww02(p_giww02)
   DEFINE l_aag02 LIKE aag_file.aag02
   DEFINE p_giww02 LIKE giww_file.giww02
   IF cl_null(p_giww02) THEN RETURN NULL END IF
   LET l_aag02=''

   CALL s_aaz641_dbs(g_giww05,g_giww06) RETURNING g_plant_axz03
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641

   LET g_sql = "SELECT aag02 ",
              #"  FROM ",g_dbs_axz03,"aag_file",  #優化,跨GP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實現
               "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),
               " WHERE aag01 = '",p_giww02,"'",
               "   AND aag00 = '",g_giww00,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_dbs_axz03) RETURNING g_sql
   PREPARE i9411_pre_3 FROM g_sql
   DECLARE i9411_cur_3 CURSOR FOR i9411_pre_3
   OPEN i9411_cur_3
   FETCH i9411_cur_3 INTO l_aag02

   RETURN l_aag02
END FUNCTION
