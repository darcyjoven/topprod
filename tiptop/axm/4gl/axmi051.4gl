# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#                                                                                                                                   
# Pattern name...: axmi051.4gl                                                                                                      
# Descriptions...: 收款多帳期設置作業
# Date & Author..: 06/08/08 by cl
# Modify.........: No.FUN-680137 06/09/06 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0079 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6C0018 06/12/05 By chenl 依比率時，各子付款條件的比率之和必須為100
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740408 07/04/23 By elva 改善寫法
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790067 07/09/11 By lumxa 打印出的報表中，表名在制表日期下面
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.MOD-890144 08/09/16 By Smapmin 單身子收款條件無法開窗
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.TQC-970033 09/07/02 by hongmei UPDATE時,如為數值欄位,資料不能給''(空字串)需給0
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_oas01           LIKE oas_file.oas01,  #母收款條件 
  g_oas01_t         LIKE oas_file.oas01,  #母收款條件舊值 
  g_oas02           LIKE oas_file.oas02, 
  g_oas02_t         LIKE oas_file.oas02, 
  g_oasacti         LIKE oas_file.oasacti, #資料有效碼
  g_oasuser         LIKE oas_file.oasuser, #資料所有者
  g_oasgrup         LIKE oas_file.oasgrup, #資料所有部門
  g_oasmodu         LIKE oas_file.oasmodu, #資料修改者
  g_oasdate         LIKE oas_file.oasdate, #最后修改日期
  l_cnt             LIKE type_file.num5,   #No.FUN-680137 SMALLINT
  g_oas             DYNAMIC ARRAY OF RECORD   #單身數組
           oas03    LIKE oas_file.oas03,
           oas04    LIKE oas_file.oas04,
           oag02_2  LIKE oag_file.oag02,
           oas05    LIKE oas_file.oas05
                    END RECORD,
  g_oas_t           RECORD   #單身數組舊值
           oas03    LIKE oas_file.oas03,
           oas04    LIKE oas_file.oas04,
           oag02_2  LIKE oag_file.oag02,
           oas05    LIKE oas_file.oas05
                    END RECORD,
  g_wc,g_wc2,g_sql  LIKE type_file.chr1000,             #No.FUN-680137 STRING
  g_delete          LIKE type_file.chr1,                #No.FUN-680137 VARCHAR(01)
  g_rec_b           LIKE type_file.num5,                #No.FUN-680137 SMALLINT
  l_ac              LIKE type_file.num5                 #No.FUN-680137 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql        LIKE type_file.chr1000       #No.FUN-680137 STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_i                 LIKE type_file.num5          #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_curs_index        LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_jump              LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_no_ask            LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值 
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理  
 
    IF (NOT cl_user()) THEN 
       EXIT PROGRAM 
    END IF 
 
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time                       #NO.FUN-6A0094     
 
    INITIALIZE g_oas TO NULL                                                
    INITIALIZE g_oas_t.* TO NULL                                                
 
    LET g_forupd_sql = "SELECT * FROM oas_file WHERE oas01 = ? FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i051_crl CURSOR FROM g_forupd_sql             # LOCK CURSOR                      
 
    OPEN WINDOW i051_w WITH FORM "axm/42f/axmi051"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    CALL g_x.clear()
    LET g_delete='N'
    CALL i051_menu()   
    CLOSE WINDOW i051_w     
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time       #NO.FUN-6A0094
END MAIN
 
 
FUNCTION i051_cs()
    CLEAR FORM
    CALL g_oas.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_oas01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON oas01,oas02,oasuser,oasgrup,oasmodu,oasdate,oasacti,oas03,oas04,oas05
         FROM oas01,oas02,oasuser,oasgrup,oasmodu,oasdate,oasacti,s_oas[1].oas03,s_oas[1].oas04,s_oas[1].oas05
              
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(oas01)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_oag"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oas01
              NEXT FIELD oas01        
           WHEN INFIELD(oas04)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_oag"   #MOD-890144 q_oas-->q_oag
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oas04
              NEXT FIELD oas04         
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oasuser', 'oasgrup') #FUN-980030
  
    IF INT_FLAG THEN RETURN END IF
  
    LET g_sql=" SELECT DISTINCT oas01 FROM oas_file ",  
              " WHERE ",g_wc CLIPPED,
              " ORDER BY oas01 "
    PREPARE i051_prepare FROM g_sql
    DECLARE i051_bcs SCROLL CURSOR WITH HOLD FOR i051_prepare
    LET g_sql=" SELECT COUNT(UNIQUE oas01) ",
              "   FROM oas_file WHERE ",g_wc CLIPPED
    PREPARE i051_precount FROM g_sql
    DECLARE i051_count CURSOR FOR i051_precount
  
END FUNCTION
 
FUNCTION i051_menu()
    WHILE TRUE
      CALL i051_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i051_a()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i051_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i051_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i051_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i051_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i051_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i051_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()        
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oas),'','')
            END IF 
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_oas01 IS NOT NULL THEN
                 LET g_doc.column1 = "oas01"
                 LET g_doc.value1 = g_oas01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0079-------add--------end----
      END CASE
    END WHILE
END FUNCTION 
 
FUNCTION i051_a() 
    IF s_shut(0) THEN RETURN END IF 
    MESSAGE ""
    CLEAR FORM
    CALL g_oas.clear()
    INITIALIZE g_oas01 LIKE oas_file.oas01
    LET g_oas01_t = NULL
  # CLOSE i051_bcs
    CALL cl_opmsg('a')
    LET g_oasuser=g_user
    LET g_oasgrup=g_grup
    LET g_oasacti='Y'
    LET g_oasdate=g_today
    DISPLAY g_oasuser TO oasuser
    DISPLAY g_oasgrup TO oasgrup
    DISPLAY g_oasacti TO oasacti
    DISPLAY g_oasdate TO oasdate
    WHILE TRUE
        CALL i051_i("a")     #輸入單頭
        IF INT_FLAG THEN     #使用者不玩了 
           LET g_oas01 = NULL
           CLEAR FORM
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        LET g_rec_b=0
        CALL i051_b()                    
        LET g_oas01_t = g_oas01         
        EXIT WHILE
    END WHILE        
END FUNCTION
 
FUNCTION i051_u()
    IF g_oas01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_opmsg('u')
    LET g_oas01_t = g_oas01
    LET g_oas02_t = g_oas02
    WHILE TRUE
        LET g_oasmodu = g_user
        LET g_oasdate = today
        CALL i051_i("u")                      #逆    �
        IF INT_FLAG THEN
            LET g_oas01=g_oas01_t
            DISPLAY g_oas01 TO oas01          #ATTRIBUTE(YELLOW) #蟲 Y
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_oas01 != g_oas01_t OR g_oas02 != g_oas02_t THEN #欄位更改         
            UPDATE oas_file SET oas01  = g_oas01,
                                oas02  = g_oas02,
                                oasmodu= g_oasmodu,
                                oasdate= g_today
                WHERE oas01 = g_oas01_t       
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","oas_file",g_oas01,"",
                              SQLCA.sqlcode,"","",1) 
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    CALL i051_oas02()
END FUNCTION 
 
FUNCTION i051_i(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1,            #No.FUN-680137 VARCHAR(1)
         l_n             LIKE type_file.num5,            #No.FUN-680137 SMALLINT
         l_oag02         LIKE oag_file.oag02
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT g_oas01,g_oas02 WITHOUT DEFAULTS FROM oas01,oas02
 
        BEFORE INPUT
            LET g_before_input_done = FALSE 
            CALL i051_set_entry(p_cmd) 
            CALL i051_set_no_entry(p_cmd) 
            LET g_before_input_done = TRUE
 
        AFTER FIELD oas01
            IF g_oas01 IS NULL OR g_oas01=' ' THEN
               CALL cl_err("","axm-317",1)
               NEXT FIELD oas01
            END IF
            IF g_oas01 IS NOT NULL AND (p_cmd='a' OR (g_oas01!=g_oas01_t)) THEN
               #判斷資料重復否
               SELECT COUNT(oas01) INTO l_n FROM oas_file
                WHERE oas01=g_oas01
               IF l_n >=1 THEN
                  CALL cl_err(g_oas01,"atm-310",1)
                  NEXT FIELD oas01
               END IF
            END IF
               #判斷是否有此收款條件
               SELECT COUNT(oag01) INTO l_n FROM oag_file 
                WHERE oag01=g_oas01
               IF l_n !=1 THEN
                  CALL cl_err("","axm-317",1)
                  NEXT FIELD oas01
               END IF 
               SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01=g_oas01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","oag_file",g_oas01,"",SQLCA.sqlcode,"","",1)
                  NEXT FIELD oas01
               ELSE
                  DISPLAY l_oag02 TO oag02_1
               END IF
 
        BEFORE FIELD oas02
            IF g_oas02 IS NULL THEN
               LET g_oas02='1'
            END IF
           
 
      # ON ACTION CONTROLN
      #     CALL i051_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLP                 
            CASE
                WHEN INFIELD(oas01)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oag"
                   LET g_qryparam.default1 = g_oas01
                   CALL cl_create_qry() RETURNING g_oas01 
                   DISPLAY g_oas01 TO oas01
                   NEXT FIELD oas01        
            END CASE
   
        ON ACTION CONTROLF  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
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
 
#Query 查詢
FUNCTION i051_q()
  DEFINE l_oas01  LIKE oas_file.oas01,
         l_cnt    LIKE type_file.num10         #No.FUN-680137 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_oas01 TO NULL     #NO.FUN-6B0079  add
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_oas.clear()
 
    CALL i051_cs()                 #取得查詢條件 
    IF INT_FLAG THEN               #使用者不玩了  
       LET INT_FLAG = 0
       CLEAR FORM                  #No.TQC-6C0018
       RETURN
    END IF
    OPEN i051_bcs                  #從DB產生合乎條件的TEMP(0-30秒)  
    IF SQLCA.sqlcode THEN           
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_oas01 TO NULL
    ELSE
        OPEN i051_count                                                     
        FETCH i051_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i051_fetch('F')        #讀取TEMP的第一筆并顯示  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i051_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1         #處理方式        #No.FUN-680137 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i051_bcs INTO g_oas01 
        WHEN 'P' FETCH PREVIOUS i051_bcs INTO g_oas01 
        WHEN 'F' FETCH FIRST    i051_bcs INTO g_oas01 
        WHEN 'L' FETCH LAST     i051_bcs INTO g_oas01 
        WHEN '/' 
         IF (NOT g_no_ask) THEN 
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
#        FETCH ABSOLUTE g_jump i051_bcs INTO g_oas01,g_oas02,g_oasacti,g_oasuser,g_oasmodu,g_oasgrup,g_oasdate  #No.TQC-6B0105
         FETCH ABSOLUTE g_jump i051_bcs INTO g_oas01  #No.TQC-6B0105
         LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                        
        CALL cl_err(g_oas01,SQLCA.sqlcode,0)
        INITIALIZE g_oas01 TO NULL  #TQC-6B0105
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
    OPEN i051_count
    FETCH i051_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    CALL i051_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i051_show()
DEFINE l_oag02         LIKE oag_file.oag02
 
    SELECT DISTINCT(oas02),oasacti,oasuser,oasgrup,oasmodu,oasdate 
      INTO g_oas02,g_oasacti,g_oasuser,g_oasgrup,g_oasmodu,g_oasdate
      FROM oas_file
     WHERE oas01= g_oas01
    DISPLAY g_oas01 TO oas01  #ATTRIBUTE(YELLOW)    #單頭
    DISPLAY g_oas02 TO oas02 
    DISPLAY g_oasacti TO oasacti
    DISPLAY g_oasuser TO oasuser
    DISPLAY g_oasgrup TO oasgrup
    DISPLAY g_oasmodu TO oasmodu
    DISPLAY g_oasdate TO oasdate
    LET l_oag02=null
    SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01 = g_oas01
    DISPLAY l_oag02 TO oag02_1
    CALL i051_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#刪除整筆資料(所有合乎單頭的資料)
FUNCTION i051_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_oas01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6B0079   
       RETURN 
    END IF
    IF cl_delh(0,0) THEN                   #確認一下 
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "oas01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_oas01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM oas_file WHERE oas01 = g_oas01 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","oas_file",g_oas01,"",SQLCA.sqlcode,"",
                         "BODY DELETE",1)  #No.FUN-660104
        ELSE
            CLEAR FORM
            CALL g_oas.clear()
            LET g_delete='Y'
            LET g_oas01 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i051_count                                                     
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE i051_bcs
               CLOSE i051_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            FETCH i051_count INTO g_row_count                 
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i051_bcs
               CLOSE i051_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            DISPLAY g_row_count TO FORMONLY.cnt               
            OPEN i051_bcs                                      
            IF g_curs_index = g_row_count + 1 THEN            
               LET g_jump = g_row_count                       
               CALL i051_fetch('L')                           
            ELSE                                              
               LET g_jump = g_curs_index                      
               LET g_no_ask = TRUE                           
               CALL i051_fetch('/')                           
            END IF
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION i051_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680137 SMALLINT
    l_ac_o          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_rows          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_success       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)   
    l_str           LIKE type_file.chr20,         #No.FUN-680137 VARCHAR(20)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_oas04         LIKE oas_file.oas04,   
    l_oas03         LIKE oas_file.oas03,   #序號
    l_oas03_t       LIKE oas_file.oas03,   #序號舊值
    l_oas05         LIKE oas_file.oas05,   #比率
    l_oas05_t       LIKE oas_file.oas05,   #比率舊值
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
DEFINE l_oasuser    LIKE oas_file.oasuser,  #判斷修改者和資料所有者是否為同一人
       l_oasgrup    LIKE oas_file.oasgrup
DEFINE l_pre        LIKE oas_file.oas05     #No.TQC-6C0018
DEFINE l_pass       LIKE type_file.chr1     #No.TQC-6C0018
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_oas01) THEN RETURN END IF
 
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT oas03,oas04,'',oas05 ",
                       "   FROM oas_file  ",
                       "  WHERE oas01=?   ",
                       "    AND oas03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i051_bcl CURSOR FROM g_forupd_sql 
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_oas WITHOUT DEFAULTS FROM s_oas.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL i051_set_entry_b()
            CALL i051_set_no_entry_b()
 
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            BEGIN WORK
            IF g_rec_b >=l_ac THEN  
                LET p_cmd='u'
                LET g_oas_t.* = g_oas[l_ac].*      #BACKUP
                OPEN i051_bcl USING g_oas01,g_oas_t.oas03
                IF STATUS THEN
                   CALL cl_err("OPEN i051_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i051_bcl INTO g_oas[l_ac].* 
                   IF STATUS THEN
                      CALL cl_err(g_oas_t.oas03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      SELECT oag02 INTO g_oas[l_ac].oag02_2 FROM oag_file
                       WHERE oag01 = g_oas[l_ac].oas04
                  #   LET g_oas_t.*=g_oas[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_oas[l_ac].* TO NULL      #900423
            LET g_oas_t.* = g_oas[l_ac].*         #輸入新資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oas03
 
    AFTER INSERT
        IF g_oas02='1' AND g_oas[l_ac].oas05 IS NULL THEN
           NEXT FIELD oas05
        END IF
        SELECT DISTINCT(oasuser) INTO l_oasuser FROM oas_file
         WHERE oas01=g_oas01
        SELECT DISTINCT(oasgrup) INTO l_oasgrup FROM oas_file
         WHERE oas01=g_oas01
        IF l_oasuser != g_user AND l_oasuser IS NOT NULL THEN
           LET g_oasuser= l_oasuser
           LET g_oasmodu= g_user
        ELSE
           LET g_oasuser = g_user 
           LET g_oasmodu = g_user
        END IF
        IF l_oasgrup != g_grup AND l_oasgrup IS NOT NULL THEN
           LET g_oasgrup = l_oasgrup
        ELSE
           LET g_oasgrup = g_grup
        END IF
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO oas_file(oas01,oas02,oas03,oas04,oas05,
                                 oasacti,oasuser,oasgrup,oasdate,oasoriu,oasorig)
                          VALUES(g_oas01,g_oas02,g_oas[l_ac].oas03,
                                 g_oas[l_ac].oas04,g_oas[l_ac].oas05,
                                 'Y',g_oasuser,g_oasgrup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","oas_file",g_oas01,g_oas[l_ac].oas03,
                             SQLCA.sqlcode,"","",1)  #No.FUN-660104
               CANCEL INSERT
            ELSE
               UPDATE oas_file SET oasmodu = g_oasmodu
                WHERE oas01=g_oas01
               MESSAGE 'INSERT O.K'
               COMMIT WORK 
               LET g_rec_b = g_rec_b+1
            END IF
 
        BEFORE FIELD oas03
            IF g_oas[l_ac].oas03 IS NULL OR g_oas[l_ac].oas03=0 THEN
               SELECT MAX(oas03)+1 INTO g_oas[l_ac].oas03 
                 FROM oas_file WHERE oas01=g_oas01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","oas_file",g_oas01,"",SQLCA.sqlcode,"","",1)
                  NEXT FIELD oas03
               END IF 
               IF g_oas[l_ac].oas03 IS NULL THEN
                  LET g_oas[l_ac].oas03=1
               END IF
            END IF
 
        AFTER FIELD oas03
           #IF g_oas[l_ac].oas03 IS NULL THEN
           #   LET g_oas[l_ac].oas03=l_oas03
           #END IF
           #IF (g_oas[l_ac].oas03 != g_oas_t.oas03 AND p_cmd='u') OR g_oas_t.oas03 IS NULL THEN   #No.TQC-6C0018 --mark
            IF g_oas[l_ac].oas03 != g_oas_t.oas03 OR g_oas_t.oas03 IS NULL THEN 
               SELECT COUNT(oas01) INTO l_n FROM oas_file 
                WHERE oas01=g_oas01 AND oas03=g_oas[l_ac].oas03
               IF l_n>=1 THEN
                  CALL cl_err(g_oas[l_ac].oas03,"asf-406",1)
                  LET g_oas[l_ac].oas03=g_oas_t.oas03
                  NEXT FIELD oas03
               END IF
            END IF
 
        AFTER FIELD oas04
            IF g_oas[l_ac].oas04 IS NOT NULL THEN
               #資料是否可以重復
               IF p_cmd='a' OR g_oas_t.oas04 != g_oas[l_ac].oas04 THEN
                  SELECT COUNT(oas04) INTO l_n FROM oas_file
                   WHERE oas01=g_oas01 AND oas04=g_oas[l_ac].oas04
                  IF l_n >=1 THEN
                     CALL cl_err(g_oas[l_ac].oas04,"atm-310",1)
                     NEXT FIELD oas04
                  END IF
               END IF
               #是否存在此收款條件
               SELECT COUNT(oag01) INTO l_n FROM oag_file 
                WHERE oag01=g_oas[l_ac].oas04
               IF l_n !=1 THEN
                  CALL cl_err("","axm-317",1)
                  NEXT FIELD oas04
               END IF 
               SELECT oag02 INTO g_oas[l_ac].oag02_2 FROM oag_file
                WHERE oag01=g_oas[l_ac].oas04
               DISPLAY g_oas[l_ac].oag02_2 TO oag02_2
            END IF
 
        BEFORE FIELD oas05
            IF g_oas02 ='1' THEN
               #No.TQC-6C0018--begin-- add  
                IF p_cmd='a' OR g_oas_t.oas05 IS NULL  THEN              
                   SELECT SUM(oas05) INTO l_pre FROM oas_file 
                    WHERE oas01=g_oas01 AND oas02='1' AND oas03!=g_oas[l_ac].oas03
                   IF SQLCA.sqlcode = 100 THEN
                      LET l_pre=NULL 
                   END IF
                   IF cl_null(l_pre) OR l_pre=0 THEN
                      LET g_oas[l_ac].oas05=100
                   ELSE
              	      LET g_oas[l_ac].oas05=100-l_pre
              	      LET l_oas05_t=g_oas[l_ac].oas05
                   END IF
                   DISPLAY BY NAME g_oas[l_ac].oas05
                   DISPLAY BY NAME g_oas[l_ac].*
                END IF 
               #No.TQC-6C0018--end-- add
               #No.TQC-6C0018--begin-- mark 
               #IF g_oas[l_ac].oas05 IS NULL THEN
               #   LET l_oas05_t=0
               #ELSE
               #   LET l_oas05_t=g_oas[l_ac].oas05
               #END IF
               #No.TQC-6C0018--begin-- mark
            END IF
            
        AFTER FIELD oas05
            IF g_oas02 = '1' THEN
               IF g_oas[l_ac].oas05 IS NULL THEN
                  CALL cl_err("","axm-471",1)
                  NEXT FIELD oas05
               END IF
               IF g_oas[l_ac].oas05<=0 THEN
                  CALL cl_err("","axm-473",0)
                  NEXT FIELD oas05
               END IF
              # IF g_oas[l_ac].oas05 IS NOT NULL  OR g_oas[l_ac].oas03!=l_oas03_t  THEN    #No.TQC-6C0018 mark
               IF g_oas[l_ac].oas05 IS NOT NULL OR g_oas[l_ac].oas05!=g_oas_t.oas05 THEN   #No.TQC-6C0018
                  DISPLAY BY NAME g_oas[l_ac].oas05
                  #No.MOD-740408  --begin
                  IF cl_null(g_oas_t.oas03) THEN 
                     SELECT SUM(oas05) INTO l_oas05 FROM oas_file
                      WHERE oas01=g_oas01 AND oas03 != g_oas[l_ac].oas03 
                  ELSE
                     SELECT SUM(oas05) INTO l_oas05 FROM oas_file
                     #WHERE oas01=g_oas01 AND oas03 != g_oas[l_ac].oas03 #No.MOD-740408
                      WHERE oas01=g_oas01 AND oas03 != g_oas_t.oas03  #No.MOD-740408
                  END IF
                  #No.MOD-740408  --end
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","oas_file",g_oas01,"",SQLCA.sqlcode,"","SEL SUM",1)
                     NEXT FIELD oas05
                  END IF
                  IF l_oas05 IS NULL THEN
                     LET l_oas05=0
                  END IF
                  IF (l_oas05+g_oas[l_ac].oas05) > 100 THEN
                     CALL cl_err("","agl-106",0) #MOD-740408
                     LET g_oas[l_ac].oas05=g_oas_t.oas05
                     NEXT FIELD oas05
                  END IF 
               END IF
            END IF
 
        BEFORE DELETE                            #刪除單身
           # IF g_oas[l_ac].oas03 IS NOT NULL THEN    #No.TQC-6C0018 mark
            IF g_oas_t.oas03>0 AND NOT cl_null(g_oas_t.oas03) THEN  #No.TQC-6C0018
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM oas_file
                 WHERE oas01 = g_oas01 
                #  AND oas03 = g_oas[l_ac].oas03 #No.MOD-740408
                   AND oas03 = g_oas_t.oas03 #No.MOD-740408
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","oas_file",g_oas_t.oas03,"",
                                  SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1    #No.TQC-6C0018
            END IF
            COMMIT WORK
 
       #No.TQC-6C0018--begin-- mark
       # AFTER DELETE 
       #     IF l_ac-1 != 0 THEN
       #        LET l_ac = l_ac-1
       #        LET g_rec_b=g_rec_b-1
       #        CALL FGL_SET_ARR_CURR(l_ac)
       #     ELSE
       #     	 LET g_rec_b = 0
       #        EXIT INPUT 
       #     END IF
       #No.TQC-6C0018--end-- mark
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oas[l_ac].* = g_oas_t.*
               CLOSE i051_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oas[l_ac].oas03,-263,1)
               LET g_oas[l_ac].* = g_oas_t.*
            ELSE
               UPDATE oas_file SET oas03=g_oas[l_ac].oas03,
                                   oas04=g_oas[l_ac].oas04,
                                   oas05=g_oas[l_ac].oas05
                WHERE oas01 = g_oas01 
                  AND oas03 = g_oas_t.oas03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","oas_file",g_oas[l_ac].oas03,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_oas[l_ac].* = g_oas_t.*
                 ROLLBACK WORK
              ELSE
                 UPDATE oas_file SET oasmodu=g_user,oasdate=g_today
                  WHERE oas01=g_oas01
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
    AFTER INPUT
      #No.MOD-740408  --begin 在input后會用i051_check()判斷，此段不用加
      # IF g_oas[l_ac].oas05=0 THEN
      #    NEXT FIELD oas05
      # END IF
      # SELECT SUM(oas05) INTO l_pre FROM oas_file
      #  WHERE oas01=g_oas01 AND oas02='1' AND oas03!=g_oas[l_ac].oas03
      # IF cl_null(l_pre) THEN
      #    LET l_pre=0
      # END IF
      # IF (l_pre+g_oas[l_ac].oas05)<100 THEN
      #    CALL cl_err('','axm-049',1)
      #    NEXT FIELD oas05 
      # END IF   
      #No.MOD-740408  --end
 
    AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oas[l_ac].* = g_oas_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_oas.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i051_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i051_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oas04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oag"
                   LET g_qryparam.default1 = g_oas[l_ac].oas04
                   CALL cl_create_qry() RETURNING g_oas[l_ac].oas04
                   NEXT FIELD oas04
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION controls                             #No.FUN-6A0092
           CALL cl_set_head_visible("","AUTO")         #No.FUN-6A0092
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
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
    CLOSE i051_bcl
    COMMIT WORK
  #當子付款條件比率不為100時，再次進入單身進行調整。
  #No.TQC-6C0018--begin--
   CALL i051_check() RETURNING l_pass
   IF l_pass='N' THEN
      CALL i051_b()
   END IF 
  #No.TQC-6C0018--end--
    SELECT COUNT(oas03) INTO l_n FROM oas_file WHERE oas01=g_oas01
    IF l_n = 0 THEN
       CALL i051_delall()  
    END IF
 
END FUNCTION
 
{
FUNCTION i051_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000                 #No.FUN-680137  VARCHAR(200)
 
    CONSTRUCT l_wc ON oas03,oas04,oas05  #屏幕上取條件
       FROM s_oas[1].oas03,s_oas[1].oas04,s_oas[1].oas05
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE CONSTRUCT                                                    
 
       ON ACTION qbe_select
           CALL cl_qbe_select() 
       ON ACTION qbe_save
           CALL cl_qbe_save()
 
       ON ACTION about         
          CALL cl_about()      
  
       ON ACTION help          
          CALL cl_show_help()  
  
       ON ACTION controlg      
          CALL cl_cmdask()     
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i051_b_fill(l_wc)
END FUNCTION
}
 
FUNCTION i051_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql = "SELECT oas03,oas04,oag02,oas05 ",
                "  FROM oas_file LEFT OUTER JOIN oag_file ON oas_file.oas04=oag_file.oag01 ",  #No.MOD-740408
                " WHERE oas01 = '",g_oas01,"'",
             #  "   AND ",p_wc CLIPPED ,
                " ORDER BY oas03"
    PREPARE i051_prepare2 FROM g_sql      
    DECLARE oas_cs CURSOR FOR i051_prepare2
    CALL g_oas.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH oas_cs INTO g_oas[g_cnt].*   #單身ARRAY填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
        CALL g_oas.deleteElement(g_cnt)
        LET g_rec_b = g_cnt - 1     
       #LET g_cnt = 0
END FUNCTION
 
FUNCTION i051_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oas TO s_oas.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()   
 
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i051_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY            
 
      ON ACTION previous
         CALL i051_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
 
      ON ACTION jump 
         CALL i051_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
 
      ON ACTION next
         CALL i051_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
 
      ON ACTION last 
         CALL i051_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY               
 
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
      ON ACTION controls                                         #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")                    #No.FUN-6A0092
  
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i051_copy()
DEFINE l_newno1,l_oldno1  LIKE oas_file.oas01,
       l_oag02_1          LIKE oag_file.oag02,
       p_cmd              LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
       l_n                LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_oas01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE                                             
    CALL i051_set_entry('a')                                                  
    LET g_before_input_done = TRUE  
 
    INPUT l_newno1 FROM oas01
 
       AFTER FIELD oas01 
            SELECT COUNT(*) INTO l_n FROM oas_file WHERE oas01=l_newno1 
            IF l_n > 0 THEN 
               CALL cl_err(l_newno1,-239,0) NEXT FIELD oas01
            END IF
            SELECT oag02 INTO l_oag02_1 FROM oag_file WHERE oag01=l_newno1 
            IF STATUS THEN 
               CALL cl_err3("sel","oag_file",l_newno1,"",STATUS,"","",1) NEXT FIELD oas01 
            END IF
            DISPLAY l_oag02_1 TO oag02 
  
       ON ACTION CONTROLP
           CASE
               WHEN INFIELD(oas01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_oag"
                 LET g_qryparam.default1=l_newno1
                 CALL cl_create_qry() RETURNING l_newno1
                 DISPLAY l_newno1 to oas01
                 NEXT FIELD oas01         
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
    IF INT_FLAG THEN 
        LET INT_FLAG = 0 DISPLAY g_oas01 TO oas01 #ATTRIBUTE(YELLOW)  #TQC-8C0076
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM oas_file         #單身復制
        WHERE g_oas01=oas01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x",g_oas01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    END IF
    UPDATE x SET oas01 = l_newno1 
    INSERT INTO oas_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","oas_file",l_newno1,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    ELSE
       UPDATE oas_file SET oasuser=g_user,
                           oasgrup=g_grup,
                           oasdate=g_today
        WHERE oas01=l_newno1
    END IF
    LET l_oldno1= g_oas01
    LET g_oas01=l_newno1
    CALL i051_b()
    #LET g_oas01=l_oldno1 #FUN-C80046
    #CALL i051_show()     #FUN-C80046
END FUNCTION
#No.FUN-7C0043--start--
 FUNCTION i051_out()
    DEFINE
        l_i             LIKE type_file.num5,              #No.FUN-680137 SMALLINT
        l_oas           RECORD LIKE oas_file.*,
        l_gen           RECORD LIKE gen_file.*,
        l_name          LIKE type_file.chr20,             #No.FUN-680137 VARCHAR(20)
        sr              RECORD 
                        oas01   LIKE oas_file.oas01,
                        oag02_1 LIKE oag_file.oag02,
                        oas02   LIKE oas_file.oas02,
                        oas03   LIKE oas_file.oas03,
                        oas04   LIKE oas_file.oas04,
                        oag02_2 LIKE oag_file.oag02,
                        oas05   LIKE oas_file.oas05
                        END RECORD,
        l_oag02_1       LIKE oag_file.oag02,
        l_oag02_2       LIKE oag_file.oag02
   DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043
   IF cl_null(g_wc) AND NOT cl_null(g_oas01) THEN                                                                                   
      LET g_wc = " oas01 = '",g_oas01,"'"                                                                                           
   END IF                                                                                                                           
   IF cl_null(g_wc) THEN                                                                                                            
      CALL cl_err('','9057',0)                                                                                                      
      RETURN                                                                                                                        
   END IF                                                                                                                           
   LET l_cmd = 'p_query "axmi051" "',g_wc CLIPPED,'"'                                                                               
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN 
#  #IF cl_null(g_wc) AND NOT cl_null(g_oas01) AND NOT cl_null(g_oas[l_ac].oas03) THEN
#  #   LET g_wc = " oas01 = '",g_oas01,"' AND oas03 = '",g_oas[l_ac].oas03,"'"                                   
#  #END IF  
#   IF cl_null(g_oas01) THEN CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   CALL cl_outnam('axmi051') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT oas01,'',oas02,oas03,oas04,'',oas05",
#             "  FROM oas_file ",
#             " WHERE ",g_wc CLIPPED,
#             " ORDER BY oas01,oas03 "  
#   PREPARE i051_p1 FROM g_sql
#   DECLARE i051_curo CURSOR FOR i051_p1
 
#   START REPORT i051_rep TO l_name
 
#   FOREACH i051_curo INTO sr.*   
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#       END IF
#       SELECT oag02 INTO sr.oag02_1 FROM oag_file WHERE  oag01 = sr.oas01
#       SELECT oag02 INTO sr.oag02_2 FROM oag_file WHERE  oag01 = sr.oas04
#       OUTPUT TO REPORT i051_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i051_rep
 
#   CLOSE i051_curo
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i051_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#       l_cnt           LIKE type_file.num10,         #No.FUN-680137 INTEGER
#       sr              RECORD 
#                       oas01   LIKE oas_file.oas01,
#                       oag02_1 LIKE oag_file.oag02,
#                       oas02   LIKE oas_file.oas02,
#                       oas03   LIKE oas_file.oas03,
#                       oas04   LIKE oas_file.oas04,
#                       oag02_2 LIKE oag_file.oag02,
#                       oas05   LIKE oas_file.oas05
#                       END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
#   ORDER BY sr.oas01,sr.oas03
#   FORMAT
#     PAGE HEADER
#     PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED 
#     PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #TQC-790067                           
#           LET g_pageno = g_pageno + 1  
#           LET pageno_total = PAGENO USING '<<<',"/pageno"                     
#           PRINT g_head CLIPPED,pageno_total                                   
#     PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #TQC-790067                           
#     PRINT ' '                                                                 
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#     PRINT g_dash1
#     LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.oas01
#           PRINT COLUMN g_c[31],sr.oas01 CLIPPED,
#                 COLUMN g_c[32],sr.oag02_1 CLIPPED;
#           IF sr.oas02='1' THEN
#              PRINT COLUMN g_c[33],g_x[9] CLIPPED;
#           ELSE 
#              PRINT COLUMN g_c[33],g_x[10] CLIPPED;
#           END IF
 
#
#       ON EVERY ROW
#          PRINT COLUMN g_c[34],sr.oas03 USING '<<<<<',
#                COLUMN g_c[35],sr.oas04 CLIPPED,
#                COLUMN g_c[36],sr.oag02_2 CLIPPED,
#                COLUMN g_c[37],sr.oas05 USING '#####&.&&' 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#          SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end--
 
FUNCTION i051_set_entry(p_cmd)                                                  
 DEFINE   p_cmd     LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1)
                                                                               
   IF (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("oas01",TRUE)                               
   END IF                                                                       
                                                                               
END FUNCTION                                                                    
                                                                                
FUNCTION i051_set_no_entry(p_cmd)                                               
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       IF p_cmd = 'u' AND g_chkey = 'N' THEN                                    
           CALL cl_set_comp_entry("oas01",FALSE)                          
       END IF                                                                   
   END IF                                                                       
END FUNCTION
 
FUNCTION i051_set_entry_b()
    IF g_oas02='1' THEN
       CALL cl_set_comp_entry("oas03,oas04,oas05",TRUE)
    END IF
END FUNCTION
 
FUNCTION i051_set_no_entry_b()
    IF g_oas02='2' THEN
       CALL cl_set_comp_entry("oas05",FALSE)
    END IF
END FUNCTION
 
FUNCTION i051_delall() 
                       
    SELECT COUNT(*) INTO g_cnt FROM oas_file WHERE oas01=g_oas01                                                                                                             
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料                                                            
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED                                            
          DELETE FROM oas_file WHERE oas01 = g_oas01
          CLEAR FORM 
          CALL g_oas.clear()
          LET g_oas01=NULL                                                                                                            
    END IF                                                                                                                          
END FUNCTION       
 
FUNCTION i051_oas02()
    IF g_oas02 != g_oas02_t AND g_oas02 = '1' THEN
       CALL cl_err("","axm-472",1)
       CALL i051_b_1()
       CALL i051_show()
    END IF
    IF g_oas02 != g_oas02_t AND g_oas02 = '2' THEN
       UPDATE oas_file SET oas05 = NULL
        WHERE oas01=g_oas01
       CALL i051_show()
    END IF
END FUNCTION
 
FUNCTION i051_b_1()
DEFINE  p_cmd             LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE  l_rowscnt         LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE  l_ac              LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE  l_ac_t            LIKE type_file.num5,         #No.FUN-680137 SMALLINT
        l_lock_sw         LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE  l_oas05           LIKE oas_file.oas05
DEFINE  l_oas05_t         LIKE oas_file.oas05
DEFINE  l_pre             LIKE oas_file.oas05          #No.TQC-6C0018 
DEFINE  l_pass            LIKE type_file.chr1          #No.TQC-6C0018
 
    IF s_shut(0) THEN RETURN END IF     #檢查權限
    IF cl_null(g_oas01) THEN RETURN END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT oas03,oas04,'',oas05 ",
                       "   FROM oas_file  ",
                       "  WHERE oas01=?   ",
                       "    AND oas03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i051_bc2 CURSOR FROM g_forupd_sql 
 
    LET l_ac_t = 0
 
    INPUT ARRAY g_oas WITHOUT DEFAULTS FROM s_oas.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = FALSE, DELETE ROW = FALSE, APPEND ROW=FALSE)
 
    BEFORE INPUT
      DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_comp_entry("oas03,oas04,",FALSE)
            CALL cl_set_comp_entry("oas05",TRUE)
 
    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            BEGIN WORK
            IF g_rec_b >=l_ac THEN
                LET p_cmd='u'
                LET g_oas_t.* = g_oas[l_ac].*      #BACKUP
                OPEN i051_bc2 USING g_oas01,g_oas_t.oas03
                IF STATUS THEN
                   CALL cl_err("OPEN i051_bc2:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i051_bc2 INTO g_oas[l_ac].* 
                   IF STATUS THEN
                      CALL cl_err(g_oas_t.oas03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      SELECT oag02 INTO g_oas[l_ac].oag02_2 FROM oag_file
                       WHERE oag01 = g_oas[l_ac].oas04
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE FIELD oas05
            IF g_oas02 ='1' THEN
               #No.TQC-6C0018--begin-- add
                SELECT SUM(oas05) INTO l_pre FROM oas_file 
                 WHERE oas01=g_oas01 AND oas02='1' AND oas03!=g_oas[l_ac].oas03
                IF SQLCA.sqlcode = 100 THEN
                   LET l_pre=NULL 
                END IF
                IF cl_null(l_pre) OR l_pre=0 THEN
                   LET g_oas[l_ac].oas05=100
                ELSE
              	   LET g_oas[l_ac].oas05=100-l_pre
              	   LET l_oas05_t=g_oas[l_ac].oas05
                END IF 
                DISPLAY BY NAME g_oas[l_ac].oas05
                DISPLAY BY NAME g_oas[l_ac].*
               #No.TQC-6C0018--begin-- mark
               #IF g_oas[l_ac].oas05 IS NULL THEN
               #   LET l_oas05_t=0
               #ELSE
               #   LET l_oas05_t=g_oas[l_ac].oas05
               #END IF
               #No.TQC-6C00180--end-- mark
            END IF
 
        AFTER FIELD oas05
            IF g_oas02 = '1' THEN
               IF g_oas[l_ac].oas05 IS NULL THEN
                  CALL cl_err("","axm-471",1)
                  NEXT FIELD oas05
               END IF
               IF g_oas[l_ac].oas05<=0 THEN
                  CALL cl_err("","axm-473",0)
                  NEXT FIELD oas05
               END IF
               IF g_oas[l_ac].oas05 IS NOT NULL THEN 
                  SELECT SUM(oas05) INTO l_oas05 FROM oas_file
                   WHERE oas01=g_oas01 AND oas03 != g_oas[l_ac].oas03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","oas_file",g_oas01,"",SQLCA.sqlcode,"","SEL SUM",1)
                     NEXT FIELD oas05
                  END IF
                  IF l_oas05 IS NULL THEN
                     LET l_oas05=0
                  END IF
                  IF (l_oas05+g_oas[l_ac].oas05) > 100 THEN
                     CALL cl_err("","agl-106",1)
                     LET g_oas[l_ac].oas05=l_oas05_t
                     NEXT FIELD oas05
                  END IF 
               END IF
            END IF
 
    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oas[l_ac].* = g_oas_t.*
               CLOSE i051_bc2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oas[l_ac].oas03,-263,1)
               LET g_oas[l_ac].* = g_oas_t.*
            ELSE
               UPDATE oas_file SET oas05=g_oas[l_ac].oas05
                WHERE oas01 = g_oas01 
                  AND oas03 = g_oas_t.oas03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","oas_file",g_oas[l_ac].oas03,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_oas[l_ac].* = g_oas_t.*
                 ROLLBACK WORK
              ELSE
              #  UPDATE oas_file SET oasmodu = g_user,oasdate=g_today
              #   WHERE oas01 = g_oas01
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
    AFTER ROW
        DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oas02=g_oas02_t
               LET g_oas[l_ac].* = g_oas_t.*
               CLOSE i051_bc2
               ROLLBACK WORK
             # UPDATE oas_file SET oas02=g_oas02,oas05=''  #TQC-970033 mark
               UPDATE oas_file SET oas02=g_oas02,oas05=0   #TQC-970033 add 
                WHERE oas01=g_oas01
               EXIT INPUT
            END IF
            CLOSE i051_bc2
    
    AFTER INPUT
      DISPLAY "AFTER INPUT"
        DECLARE i051_c2 CURSOR FOR 
          SELECT oas05 FROM oas_file WHERE oas01=g_oas01
        FOREACH i051_c2 INTO l_oas05
          IF l_oas05=0 OR cl_null(l_oas05) THEN
             CALL cl_err("","axm-706",1)
             NEXT FIELD oas05
          END IF
        END FOREACH
        SELECT SUM(oas05) INTO l_pre FROM oas_file
         WHERE oas01=g_oas01 AND oas02='1' AND oas03!=g_oas[l_ac].oas05 
        IF cl_null(l_pre) THEN
           LET l_pre=0
        END IF
        IF (l_pre+g_oas[l_ac].oas05)<100 THEN
           CALL cl_err('','axm-049',1)
           NEXT FIELD oas05 
        END IF         
 
        #--NO.MOD-860078--
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
   
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        #--NO.MOD-860078---
 
    END INPUT
 
    CLOSE i051_bc2
    
    #No.TQC-6C0018--begin-- add
    CALL i051_check() RETURNING l_pass
    IF l_pass='N' THEN 
       CALL i051_b_1()
    END IF 
    #No.TQC-6C0018--end-- add
END FUNCTION
 
#用于檢查子付款條件是否滿100
#No.TQC-6C0018--begin-- add1
FUNCTION i051_check()
DEFINE l_oas05       LIKE oas_file.oas05
#DEFINE p_cmd         LIKE type_file.chr1
DEFINE l_pass        LIKE type_file.chr1
    
    LET l_pass = 'Y'
    IF g_oas02='1' THEN 
       SELECT SUM(oas05) INTO l_oas05 FROM oas_file WHERE oas01=g_oas01 
       IF cl_null(l_oas05) OR l_oas05 != 100 THEN 
          IF g_rec_b>0 THEN
             MESSAGE "" 
             CALL cl_err('','axm-049',1)
             LET l_pass='N'
          END IF 
       END IF 
    END IF 
    
    RETURN l_pass
END FUNCTION 
#No.TQC-6C0018--end-- add
