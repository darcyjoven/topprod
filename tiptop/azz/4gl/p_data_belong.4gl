# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: p_data_belong.4gl
# Descriptions...: 資料歸屬設定作業
# Date & Author..: No.FUN-970095 09/07/29 By tsai_yen
# Modify.........: 
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70082 10/07/15 by jay 調整使用gat_file來判斷table是否存在，需要改成用zta_file來判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-970095
 
DEFINE g_gfk       RECORD LIKE gfk_file.* 
DEFINE g_gfk_t     RECORD LIKE gfk_file.*   #備份舊值
DEFINE g_gfk01_t   LIKE gfk_file.gfk01      #Key值備份
DEFINE g_wc        STRING                   #儲存 user 的查詢條件 
DEFINE g_sql       STRING                   #組 sql 用
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL 
DEFINE g_before_input_done   LIKE type_file.num5      #判斷是否已執行 Before Input指令
DEFINE g_cnt                 LIKE type_file.num10     
DEFINE g_i                   LIKE type_file.num5      #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr1000   
DEFINE g_curs_index          LIKE type_file.num10     
DEFINE g_row_count           LIKE type_file.num10     #總筆數
DEFINE g_jump                LIKE type_file.num10     #查詢指定的筆數
DEFINE mi_no_ask             LIKE type_file.num5      #是否開啟指定筆視窗
DEFINE g_gfk02_name          STRING                   #人員代號
DEFINE g_gfk03_name          STRING                   #部門代號
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5 
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                         #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_gfk.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM gfk_file WHERE gfk01 = ? FOR UPDATE " 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_data_belong_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW p_data_belong_w AT p_row,p_col WITH FORM "azz/42f/p_data_belong"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL p_data_belong_menu()
 
   CLOSE WINDOW p_data_belong_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p_data_belong_curs()
   DEFINE ls         STRING
   DEFINE l_gat03    LIKE gat_file.gat03       #對應主Table名稱
 
   CLEAR FORM
   INITIALIZE g_gfk.* TO NULL     
   CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
      gfk01,gfk02,gfk03
      
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
     ON ACTION CONTROLP
        CASE
           #開窗查詢 - 對應主Table                     
           WHEN INFIELD(gfk01)   
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gat"
              LET g_qryparam.default1= l_gat03 CLIPPED
              LET g_qryparam.arg1= g_lang CLIPPED   #語言別
              CALL cl_create_qry() RETURNING g_gfk.gfk01
              DISPLAY g_gfk.gfk01 TO gfk01
              CALL p_data_belong_gfk01()            #顯示主Table名稱
              CALL p_data_belong_ug()               #找出資料所有者和資料所有部門
              
            #開窗查詢 - 人員代號：開窗取得[對應主Table]的所有欄位
            WHEN INFIELD(gfk02)
               IF cl_null(g_gfk.gfk01) THEN
                  CALL cl_err(g_gfk.gfk01,'azz-053',1)
                  NEXT FIELD gfk01
               ELSE
                  CALL q_gaq1(FALSE,TRUE,g_gfk.gfk02,g_gfk.gfk01) RETURNING g_gfk.gfk02  #資料欄位查詢                  
                  DISPLAY g_gfk.gfk02 TO gfk02
               END IF
               
            #開窗查詢 - 部門代號：開窗取得[對應主Table]的所有欄位
            WHEN INFIELD(gfk03)
               IF cl_null(g_gfk.gfk01) THEN
                  CALL cl_err(g_gfk.gfk01,'azz-053',1)
                  NEXT FIELD gfk01
               ELSE
                  CALL q_gaq1(FALSE,TRUE,g_gfk.gfk03,g_gfk.gfk01) RETURNING g_gfk.gfk03  #資料欄位查詢                  
                  DISPLAY g_gfk.gfk03 TO gfk03
               END IF
               
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   LET g_sql = "SELECT gfk01 FROM gfk_file ", # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED, " ORDER BY gfk01"
   PREPARE p_data_belong_prepare FROM g_sql
   DECLARE p_data_belong_cs                       # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR p_data_belong_prepare
       
   LET g_sql = "SELECT COUNT(*) FROM gfk_file WHERE ",g_wc CLIPPED
   PREPARE p_data_belong_precount FROM g_sql
   DECLARE p_data_belong_count CURSOR FOR p_data_belong_precount
END FUNCTION
 
FUNCTION p_data_belong_menu()
   DEFINE l_cmd  LIKE type_file.chr1000    
   MENU ""
       BEFORE MENU
          CALL cl_navigator_setting(g_curs_index, g_row_count)
 
       ON ACTION insert
          LET g_action_choice="insert"
          IF cl_chk_act_auth() THEN
             CALL p_data_belong_a()
          END IF
       ON ACTION query
          LET g_action_choice="query"
          IF cl_chk_act_auth() THEN
             CALL p_data_belong_q()
          END IF
       ON ACTION next
          CALL p_data_belong_fetch('N')
       ON ACTION previous
          CALL p_data_belong_fetch('P')
       ON ACTION modify
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
               CALL p_data_belong_u()
          END IF
       ON ACTION delete
          LET g_action_choice="delete"
          IF cl_chk_act_auth() THEN
             CALL p_data_belong_r()
          END IF
       ON ACTION output
          LET g_action_choice="output"
          IF cl_chk_act_auth() THEN 
             IF cl_null(g_wc) THEN LET g_wc='1=1' END IF  
             LET l_cmd = 'p_query "p_data_belong" "',g_wc CLIPPED,'"'
             CALL cl_cmdrun(l_cmd)  
          END IF
 
       ON ACTION help
          CALL cl_show_help()
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU
       ON ACTION jump
          CALL p_data_belong_fetch('/')
       ON ACTION first
          CALL p_data_belong_fetch('F')
       ON ACTION last
          CALL p_data_belong_fetch('L')
       ON ACTION controlg
          CALL cl_cmdask()
          
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
          
       ON ACTION about   
          CALL cl_about()  
 
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET INT_FLAG=FALSE
          LET g_action_choice = "exit"
          EXIT MENU
 
       ON ACTION related_document
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
            IF g_gfk.gfk01 IS NOT NULL THEN
               LET g_doc.column1 = "gfk01"
               LET g_doc.value1 = g_gfk.gfk01
               CALL cl_doc()
            END IF
         END IF
 
    END MENU
    CLOSE p_data_belong_cs
END FUNCTION
 
 
FUNCTION p_data_belong_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_gfk.* LIKE gfk_file.*
    LET g_gfk01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL p_data_belong_i("a")                # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_gfk.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        ELSE
           #資料有所者和資料所有部門必須一起填，或一起不填
           IF ((NOT cl_null(g_gfk.gfk02)) AND (cl_null(g_gfk.gfk03))) OR
              ((cl_null(g_gfk.gfk02)) AND (NOT cl_null(g_gfk.gfk03))) THEN
              CONTINUE WHILE
           END IF
        END IF
        
        IF cl_null(g_gfk.gfk01) THEN             # KEY 不可空白
           CONTINUE WHILE
        END IF
        
        INSERT INTO gfk_file VALUES(g_gfk.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","gfk_file",g_gfk.gfk01,"",SQLCA.sqlcode,"","",0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION p_data_belong_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   DEFINE   l_gen02   LIKE gen_file.gen02
   DEFINE   l_gen03   LIKE gen_file.gen03
   DEFINE   l_gen04   LIKE gen_file.gen04
   DEFINE   l_gem02   LIKE gem_file.gem02
   DEFINE   l_input   LIKE type_file.chr1  
   DEFINE   l_n       LIKE type_file.num5 
   DEFINE   l_gat03   LIKE gat_file.gat03   #對應主Table名稱
   
   DISPLAY BY NAME
      g_gfk.gfk01,g_gfk.gfk02,g_gfk.gfk03
 
   INPUT BY NAME
      g_gfk.gfk01,g_gfk.gfk02,g_gfk.gfk03
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL p_data_belong_set_entry(p_cmd)
         CALL p_data_belong_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
         
      #對應主Table  
      ON CHANGE gfk01
         LET g_gfk.gfk02 = NULL
         LET g_gfk.gfk03 = NULL
         CALL p_data_belong_ug() #找出資料所有者和資料所有部門
 
            
      AFTER FIELD gfk01 
         IF NOT cl_null(g_gfk.gfk01) THEN
            IF g_gfk.gfk01 != g_gfk_t.gfk01 OR     #輸入後更改不同時值
               cl_null(g_gfk_t.gfk01) THEN     
               #檢查Key值是否重複
               SELECT COUNT(DISTINCT gfk01) INTO l_n   
                  FROM gfk_file
                  WHERE gfk01=g_gfk.gfk01                  
                  
               IF l_n <= 0 THEN                    # Duplicated
                  #FUN-A70082-----start----
                  #SELECT COUNT(DISTINCT gat01) INTO l_n  #table代碼是否存在gat_file檔案名稱多語言對照檔
                  #   FROM gat_file
                  #   WHERE gat01 = g_gfk.gfk01
                  #      AND gat02= g_lang
                  SELECT COUNT(DISTINCT zta01) INTO l_n  #檢查Table代碼是否存在zta_file
                    FROM zta_file
                    WHERE zta01 = g_gfk.gfk01 AND zta02 = 'ds' 
                  #FUN-A70082-----end-----
                  IF l_n =0 THEN
                     CALL cl_err(g_gfk.gfk01,"azz-053",1)
                     CALL p_data_belong_gfk01()    #顯示主Table名稱
                     CALL p_data_belong_ug()       #找出資料所有者和資料所有部門
                     NEXT FIELD gfk01
                  END IF
               ELSE
                  CALL cl_err(g_gfk.gfk01,-239,1)
                  LET g_gfk.gfk01 = g_gfk01_t
                  LET g_gfk.gfk02 = g_gfk_t.gfk02
                  LET g_gfk.gfk03 = g_gfk_t.gfk03
                  DISPLAY BY NAME g_gfk.gfk01,g_gfk.gfk02,g_gfk.gfk03
                  CALL p_data_belong_gfk01()       #顯示主Table名稱
                  CALL p_data_belong_ug()          #找出資料所有者和資料所有部門
                  NEXT FIELD gfk01
               END IF
            END IF
            
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gfk.gfk01,g_errno,0)
               CALL p_data_belong_gfk01()          #顯示主Table名稱
               CALL p_data_belong_ug()             #找出資料所有者和資料所有部門
               NEXT FIELD gfk01
            END IF
         END IF
         CALL p_data_belong_gfk01()                #顯示主Table名稱
         CALL p_data_belong_ug()                   #找出資料所有者和資料所有部門
 
               
      AFTER FIELD gfk02
         IF NOT cl_null(g_gfk.gfk02) THEN
            IF g_gfk.gfk02 != g_gfk_t.gfk02 OR     #輸入後更改不同時值
               cl_null(g_gfk_t.gfk02) THEN 
                  SELECT COUNT(DISTINCT gaq01) INTO l_n  #檢查資料是否存在[對應主Table]的欄位內
                     FROM gaq_file
                     WHERE gaq01 = g_gfk.gfk02 AND gaq02 = g_lang 
                  IF l_n = 0 THEN
                     CALL cl_err(g_gfk.gfk02,"azz-116",1)
                     NEXT FIELD gfk02
                  END IF
            END IF
    
            CALL p_data_belong_gaq03("gfk02") RETURNING g_gfk02_name
            IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gfk.gfk02,g_errno,0)
                NEXT FIELD gfk02
            END IF
         ELSE
            LET g_gfk02_name = NULL
         END IF
         
         DISPLAY g_gfk02_name TO gfk02_name
         #CALL p_data_belong_usergrup() #資料有所者和資料所有部門必須一起填，或一起不填
        
         
      AFTER FIELD gfk03
         IF NOT cl_null(g_gfk.gfk03) THEN
            IF g_gfk.gfk03 != g_gfk_t.gfk03 OR     #輸入後更改不同時值
               cl_null(g_gfk_t.gfk03) THEN 
                  SELECT COUNT(DISTINCT gaq01) INTO l_n  #檢查資料是否存在[對應主Table]的欄位內
                     FROM gaq_file
                     WHERE gaq01 = g_gfk.gfk03 AND gaq02 = g_lang 
                  IF l_n = 0 THEN
                     CALL cl_err(g_gfk.gfk03,"azz-116",1)
                     NEXT FIELD gfk03
                  END IF
            END IF
    
            CALL p_data_belong_gaq03("gfk03") RETURNING g_gfk03_name
            IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gfk.gfk03,g_errno,0)
                NEXT FIELD gfk03
            END IF
         ELSE
            LET g_gfk03_name = NULL
         END IF
         
         DISPLAY g_gfk03_name TO gfk03_name
         #CALL p_data_belong_usergrup() #資料有所者和資料所有部門必須一起填，或一起不填
         
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_gfk.gfk01 IS NULL THEN
            DISPLAY BY NAME g_gfk.gfk01
            LET l_input='Y'
         END IF
         IF l_input='Y' THEN
            NEXT FIELD gfk01
         END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(gfk01) THEN
            LET g_gfk.* = g_gfk_t.*
            CALL p_data_belong_show()
            NEXT FIELD gfk01
         END IF
 
      ON ACTION CONTROLP
         CASE
            #開窗查詢 - 對應主Table                     
            WHEN INFIELD(gfk01)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gat"
               LET g_qryparam.default1= l_gat03 CLIPPED
               LET g_qryparam.arg1= g_lang CLIPPED   #語言別
               CALL cl_create_qry() RETURNING g_gfk.gfk01
               DISPLAY g_gfk.gfk01 TO gfk01
               CALL p_data_belong_gfk01()            #顯示主Table名稱
               CALL p_data_belong_ug()               #找出資料所有者和資料所有部門
               
            #開窗查詢 - 人員代號：開窗取得[對應主Table]的所有欄位
            WHEN INFIELD(gfk02)
               IF cl_null(g_gfk.gfk01) THEN
                  CALL cl_err(g_gfk.gfk01,'azz-053',1)
                  NEXT FIELD gfk01
               ELSE
                  CALL q_gaq1(FALSE,TRUE,g_gfk.gfk02,g_gfk.gfk01) RETURNING g_gfk.gfk02  #資料欄位查詢                  
                  DISPLAY g_gfk.gfk02 TO gfk02
               END IF
               
            #開窗查詢 - 部門代號：開窗取得[對應主Table]的所有欄位
            WHEN INFIELD(gfk03)
               IF cl_null(g_gfk.gfk01) THEN
                  CALL cl_err(g_gfk.gfk01,'azz-053',1)
                  NEXT FIELD gfk01
               ELSE
                  CALL q_gaq1(FALSE,TRUE,g_gfk.gfk03,g_gfk.gfk01) RETURNING g_gfk.gfk03  #資料欄位查詢                  
                  DISPLAY g_gfk.gfk03 TO gfk03
               END IF
               
            OTHERWISE
               EXIT CASE
            END CASE
      
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      
      ON ACTION CONTROLG
         CALL cl_cmdask()
      
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
      
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about        
         CALL cl_about()
      
      ON ACTION help   
         CALL cl_show_help()
 
   END INPUT
END FUNCTION
 
#依"對應主Table"，顯示"對應主Table名稱"
FUNCTION p_data_belong_gfk01()
   DEFINE l_gat03     LIKE gat_file.gat03 
   
   LET l_gat03 = ""
   LET g_errno = " "
   
   SELECT gat03 INTO l_gat03 FROM gat_file
      WHERE gat01 = g_gfk.gfk01 AND gat02 = g_lang 
      
   IF SQLCA.sqlcode THEN
      IF SQLCA.SQLCODE = 100 THEN 
         LET g_errno = "aoo-997"
      ELSE 
         LET g_errno = SQLCA.sqlcode USING "-------"
         LET l_gat03 = NULL
      END IF
   END IF
 
   DISPLAY l_gat03 TO gat03
END FUNCTION
 
 
FUNCTION p_data_belong_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_gfk.* TO NULL 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL p_data_belong_curs()                     # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN p_data_belong_count
    FETCH p_data_belong_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN p_data_belong_cs                         # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_gfk.gfk01,SQLCA.sqlcode,0)
       INITIALIZE g_gfk.* TO NULL
    ELSE
       CALL p_data_belong_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
 
FUNCTION p_data_belong_fetch(p_flag)
   DEFINE p_flag      LIKE type_file.chr1     #處理方式  
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     p_data_belong_cs INTO g_gfk.gfk01
       WHEN 'P' FETCH PREVIOUS p_data_belong_cs INTO g_gfk.gfk01
       WHEN 'F' FETCH FIRST    p_data_belong_cs INTO g_gfk.gfk01
       WHEN 'L' FETCH LAST     p_data_belong_cs INTO g_gfk.gfk01
       WHEN '/'
           IF (NOT mi_no_ask) THEN      
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0
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
           FETCH ABSOLUTE g_jump p_data_belong_cs INTO g_gfk.gfk01
           LET mi_no_ask = FALSE 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gfk.gfk01,SQLCA.sqlcode,0)
        INITIALIZE g_gfk.* TO NULL   
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx  
    END IF
 
    SELECT * INTO g_gfk.* FROM gfk_file    # 重讀DB,因TEMP有不被更新特性
       WHERE gfk01 = g_gfk.gfk01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gfk_file",g_gfk.gfk01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL p_data_belong_show()                #重新顯示
    END IF
END FUNCTION
 
 
FUNCTION p_data_belong_show()
   LET g_gfk_t.* = g_gfk.*
   #No.FUN-9A0024--begin
   #DISPLAY BY NAME g_gfk.*
   DISPLAY BY NAME g_gfk.gfk01,g_gfk.gfk02,g_gfk.gfk03
   #No.FUN-9A0024--end 
   
   CALL p_data_belong_gfk01()             #顯示主Table名稱
   CALL p_data_belong_gaq03("gfk02") RETURNING g_gfk02_name
   CALL p_data_belong_gaq03("gfk03") RETURNING g_gfk03_name
   DISPLAY g_gfk02_name,g_gfk03_name TO gfk02_name,gfk03_name
   
   CALL p_data_belong_gfk01()
   CALL cl_show_fld_cont()                 
END FUNCTION
 
 
FUNCTION p_data_belong_u()
   IF cl_null(g_gfk.gfk01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_gfk.* FROM gfk_file WHERE gfk01=g_gfk.gfk01
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gfk01_t = g_gfk.gfk01
   BEGIN WORK
 
   OPEN p_data_belong_cl USING g_gfk01_t
   IF STATUS THEN
      CALL cl_err("OPEN p_data_belong_cl:", STATUS, 1)
      CLOSE p_data_belong_cl
      ROLLBACK WORK
      RETURN       
   END IF
   FETCH p_data_belong_cl INTO g_gfk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gfk01_t,SQLCA.sqlcode,1)
      RETURN
   END IF
 
   CALL p_data_belong_show()                          # 顯示最新資料
   WHILE TRUE
       CALL p_data_belong_i("u")                      # 欄位更改
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_gfk.*=g_gfk_t.*
          CALL p_data_belong_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
       ELSE
          #資料有所者和資料所有部門必須一起填，或一起不填
          IF ((NOT cl_null(g_gfk.gfk02)) AND (cl_null(g_gfk.gfk03))) OR
             ((cl_null(g_gfk.gfk02)) AND (NOT cl_null(g_gfk.gfk03))) THEN
             CONTINUE WHILE
          END IF
       END IF
       UPDATE gfk_file SET gfk_file.* = g_gfk.*    # 更新DB
           WHERE gfk01 = g_gfk01_t
       IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","gfk_file",g_gfk01_t,"",SQLCA.sqlcode,"","",0)
           CONTINUE WHILE
       END IF
       EXIT WHILE
   END WHILE
   CLOSE p_data_belong_cl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION p_data_belong_r()  #刪除
    IF cl_null(g_gfk.gfk01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN p_data_belong_cl USING g_gfk.gfk01
    IF STATUS THEN
       CALL cl_err("OPEN p_data_belong_cl:", STATUS, 0)
       CLOSE p_data_belong_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_data_belong_cl INTO g_gfk.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_gfk.gfk01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL p_data_belong_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gfk01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gfk.gfk01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM gfk_file WHERE gfk01 = g_gfk.gfk01
       CLEAR FORM
       OPEN p_data_belong_count
       FETCH p_data_belong_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN p_data_belong_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL p_data_belong_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE 
          CALL p_data_belong_fetch('/')
       END IF
    END IF
    CLOSE p_data_belong_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION p_data_belong_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("gfk01",TRUE)
   END IF
   CALL cl_set_comp_entry("gfk02,gfk03",TRUE)
END FUNCTION
 
FUNCTION p_data_belong_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("gfk01",FALSE)
   END IF
   CALL cl_set_comp_entry("gfk02,gfk03",TRUE)
END FUNCTION
 
 
FUNCTION p_data_belong_gaq03(p_feld)
   DEFINE p_feld      STRING          #gfk02或gfk03
   DEFINE l_gaq03     LIKE gaq_file.gaq03    
   
   LET g_errno = " "
   LET l_gaq03 = NULL
   
   IF p_feld = "gfk02" AND (NOT cl_null(g_gfk.gfk02)) THEN
      SELECT gaq03 INTO l_gaq03 FROM gaq_file
         WHERE gaq01 = g_gfk.gfk02 AND gaq02 = g_lang          
      IF SQLCA.sqlcode THEN
         IF SQLCA.SQLCODE = 100 THEN 
            LET g_errno = "azz-116"
         ELSE 
            LET g_errno = SQLCA.sqlcode USING "-------"
            LET l_gaq03 = NULL
         END IF
      END IF
   END IF
   
   IF p_feld = "gfk03" AND (NOT cl_null(g_gfk.gfk03)) THEN
      SELECT gaq03 INTO l_gaq03 FROM gaq_file
         WHERE gaq01 = g_gfk.gfk03 AND gaq02 = g_lang 
      IF SQLCA.sqlcode THEN
         IF SQLCA.SQLCODE = 100 THEN 
            LET g_errno = "azz-116"
         ELSE 
            LET g_errno = SQLCA.sqlcode USING "-------"
            LET l_gaq03 = NULL
         END IF
      END IF
   END IF
 
   RETURN l_gaq03
END FUNCTION
 
 
#資料有所者和資料所有部門必須一起填，或一起不填
FUNCTION p_data_belong_usergrup()
   IF (NOT cl_null(g_gfk.gfk02)) OR (NOT cl_null(g_gfk.gfk03)) THEN
      CALL cl_set_comp_required("gfk02,gfk03", TRUE) #動態設定欄位是否必須輸入值
   ELSE
      CALL cl_set_comp_required("gfk02,gfk03", FALSE) #動態設定欄位是否必須輸入值
   END IF
END FUNCTION
 
#找出資料所有者和資料所有部門
FUNCTION p_data_belong_ug()
   DEFINE   l_gfk02   LIKE gfk_file.gfk02   #資料所有者
   DEFINE   l_gfk03   LIKE gfk_file.gfk03   #資料所有部門
   
   LET g_gfk02_name = NULL
   LET g_gfk03_name = NULL
   
   IF NOT cl_null(g_gfk.gfk01) THEN            
      LET l_gfk03 = cl_replace_str(g_gfk.gfk01, "_file", "")
      LET l_gfk02 = l_gfk03 CLIPPED,"user"
      LET l_gfk03 = l_gfk03 CLIPPED,"grup"
   
      SELECT DISTINCT gaq01 INTO g_gfk.gfk02
         FROM gaq_file
         WHERE gaq01 = l_gfk02
         
      SELECT DISTINCT gaq01 INTO g_gfk.gfk03
         FROM gaq_file
         WHERE gaq01 = l_gfk03
         
      CALL p_data_belong_gaq03("gfk02") RETURNING g_gfk02_name
      IF NOT cl_null(g_errno) THEN
          CALL cl_err(g_gfk.gfk02,g_errno,0)
      END IF                           
      
      CALL p_data_belong_gaq03("gfk03") RETURNING g_gfk03_name
      IF NOT cl_null(g_errno) THEN
          CALL cl_err(g_gfk.gfk03,g_errno,0)
      END IF               
      
      #CALL p_data_belong_usergrup() #資料有所者和資料所有部門必須一起填，或一起不填           
   END IF
   
   DISPLAY g_gfk.gfk02,g_gfk.gfk03 TO gfk02,gfk03
   DISPLAY g_gfk02_name TO gfk02_name
   DISPLAY g_gfk03_name TO gfk03_name 
END FUNCTION
