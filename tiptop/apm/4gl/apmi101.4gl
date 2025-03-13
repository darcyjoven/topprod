# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi101.4gl
# Descriptions...: 收款多帳期設置作業
# Date & Author..: 06/08/10 by Xufeng
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-6A0067 06/10/24 By atsea 將g_no_ask修改為g_no_ask
# Modify.........: No.FUN-6A0162 06/11/07 By jamie 1.FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6C0019 06/12/08 By xufeng 依比率時，單身比率之和必須等于100%
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740205 07/04/22 By bnlent 單身子付款條件代號應檢查不可與單頭母付款條件代號相同
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770068 07/07/12 By wujie   報表表頭格式不規範
#                                                    未控管無效的付款條件可以使用
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.FUN-820002 08/02/25 By lutingting   報表轉為使用p_query
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990167 09/09/17 By mike apmi101 右鍵 [說明],網址開出來的模組有誤,造成user無法開啟說明文件.                
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AA0103 10/11/02 By lilingyu 1.資料建立者,資料建立部門在新增時未賦值,查詢時無法下條件
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_pmb01           LIKE pmb_file.pmb01,  #母付款條件 
  g_pmb01_t         LIKE pmb_file.pmb01,  #母付款條件舊值 
  g_pmb02           LIKE pmb_file.pmb02, 
  g_pmb02_t         LIKE pmb_file.pmb02, 
  g_pmbacti         LIKE pmb_file.pmbacti, #資料有效碼
  g_pmbuser         LIKE pmb_file.pmbuser, #資料所有者
  g_pmbgrup         LIKE pmb_file.pmbgrup, #資料所有部門
  g_pmbmodu         LIKE pmb_file.pmbmodu, #資料修改者
  g_pmbdate         LIKE pmb_file.pmbdate, #最后修改日期
  g_pmboriu         LIKE pmb_file.pmboriu,   #TQC-AA0103
  g_pmborig         LIKE pmb_file.pmborig,   #TQC-AA0103
  l_cnt             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
  g_pmb             DYNAMIC ARRAY OF RECORD   #單身數組
           pmb03    LIKE pmb_file.pmb03,
           pmb04    LIKE pmb_file.pmb04,
           pmb04_pma02  LIKE pma_file.pma02,
           pmb05    LIKE pmb_file.pmb05
                    END RECORD,
  g_pmb_t           RECORD   #單身數組舊值
           pmb03    LIKE pmb_file.pmb03,
           pmb04    LIKE pmb_file.pmb04,
           pmb04_pma02  LIKE pma_file.pma02,
           pmb05    LIKE pmb_file.pmb05
                    END RECORD,
  g_wc,g_wc2,g_sql  STRING,
  g_delete          LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
  g_rec_b           LIKE type_file.num5,          #No.FUN-680136 SMALLINT 
  l_ac              LIKE type_file.num5           #No.FUN-680136 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680136 SMALLINT 
DEFINE g_forupd_sql        STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10         #No.FUN-680136  INTEGER
DEFINE g_i                 LIKE type_file.num5          #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE g_msg               LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_curs_index        LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_jump              LIKE type_file.num10         #No.FUN-680136 INTEGER                                                  #No.FUN-680136
DEFINE g_no_ask           LIKE type_file.num5          #No.FUN-680136 INTEGER   #No.FUN-6A0067
 
MAIN
    OPTIONS                                #改變一些系統預設值 
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理  
 
    IF (NOT cl_user()) THEN 
       EXIT PROGRAM 
    END IF 
 
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("APM")) THEN #MOD-990167 AXM-->APM     
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    INITIALIZE g_pmb TO NULL                                                
    INITIALIZE g_pmb_t.* TO NULL                                                
 
    LET g_forupd_sql = "SELECT * FROM pmb_file WHERE pmb01 = ? FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_crl CURSOR FROM g_forupd_sql             # LOCK CURSOR                      
 
    OPEN WINDOW i101_w WITH FORM "apm/42f/apmi101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    CALL g_x.clear()
    LET g_delete='N'
    CALL i101_menu()   
    CLOSE WINDOW i101_w     
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION i101_cs()
    CLEAR FORM
    CALL g_pmb.clear()
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmb01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON pmb01,pmb02,pmbuser,pmbgrup,
                      pmboriu,pmborig,             #TQC-AA0103 
                      pmbmodu,pmbdate,pmbacti,pmb03,pmb04,pmb05
                 FROM pmb01,pmb02,pmbuser,pmbgrup,
                      pmboriu,pmborig,             #TQC-AA0103 
                      pmbmodu,pmbdate,pmbacti,s_pmb[1].pmb03,s_pmb[1].pmb04,s_pmb[1].pmb05
              
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(pmb01)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_pma"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmb01
              NEXT FIELD pmb01        
           WHEN INFIELD(pmb04)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_pmb"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmb04
              NEXT FIELD pmb04         
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmbuser', 'pmbgrup') #FUN-980030
  
    IF INT_FLAG THEN RETURN END IF
  
    LET g_sql=" SELECT DISTINCT pmb01 FROM pmb_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY pmb01 "
    PREPARE i101_prepare FROM g_sql
    DECLARE i101_bcs SCROLL CURSOR WITH HOLD FOR i101_prepare
    LET g_sql=" SELECT COUNT(UNIQUE pmb01) ",
              "   FROM pmb_file WHERE ",g_wc CLIPPED
    PREPARE i101_precount FROM g_sql
    DECLARE i101_count CURSOR FOR i101_precount
  
END FUNCTION
 
FUNCTION i101_menu()
    WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i101_a()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i101_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i101_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i101_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i101_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i101_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()        
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               call cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_pmb),'','')
            END IF 
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pmb01 IS NOT NULL THEN
                 LET g_doc.column1 = "pmb01"
                 LET g_doc.value1 = g_pmb01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
    END WHILE
END FUNCTION 
 
FUNCTION i101_a() 
    IF s_shut(0) THEN RETURN END IF 
    MESSAGE ""
    CLEAR FORM
    CALL g_pmb.clear()
    INITIALIZE g_pmb01 LIKE pmb_file.pmb01
    LET g_pmb01_t = NULL
#   CLOSE i101_bcs
    CALL cl_opmsg('a')
    LET g_pmbuser=g_user
    LET g_pmbgrup=g_grup
    LET g_pmbacti='Y'
    LET g_pmbdate=g_today
    LET g_pmboriu = g_user   #TQC-AA0103
    LET g_pmborig = g_grup   #TQC-AA0103
    DISPLAY g_pmboriu TO pmboriu   #TQC-AA0103
    DISPLAY g_pmborig TO pmborig   #TQC-AA0103
    DISPLAY g_pmbuser TO pmbuser
    DISPLAY g_pmbgrup TO pmbgrup
    DISPLAY g_pmbacti TO pmbacti
    DISPLAY g_pmbdate TO pmbdate
    WHILE TRUE
        CALL i101_i("a")     #輸入單頭
        IF INT_FLAG THEN     #使用者不玩了 
           LET g_pmb01 = NULL
           CLEAR FORM
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        LET g_rec_b=0
        CALL i101_b()                    
        LET g_pmb01_t = g_pmb01         
        EXIT WHILE
    END WHILE        
END FUNCTION
 
FUNCTION i101_u()
    IF g_pmb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_opmsg('u')
    LET g_pmb01_t = g_pmb01
    LET g_pmb02_t = g_pmb02
    WHILE TRUE
        LET g_pmbmodu = g_user
        LET g_pmbdate = today
        CALL i101_i("u")                      #
        IF INT_FLAG THEN
            LET g_pmb01=g_pmb01_t
            DISPLAY g_pmb01 TO pmb01          #ATTRIBUTE(YELLOW) #蟲 Y
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_pmb01 != g_pmb01_t OR g_pmb02 != g_pmb02_t THEN #欄位更改         
            UPDATE pmb_file SET pmb01  = g_pmb01,
                                pmb02  = g_pmb02,
                                pmbmodu= g_pmbmodu,
                                pmbdate= g_pmbdate  
                WHERE pmb01 = g_pmb01_t       
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","pmb_file",g_pmb01,"",
                              SQLCA.sqlcode,"","",1) 
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    CALL i101_pmb02()
END FUNCTION 
 
FUNCTION i101_i(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1,            #No.FUN-680136 VARCHAR(1)
         l_n             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
         l_pma02         LIKE pma_file.pma02
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
 
    INPUT g_pmb01,g_pmb02 WITHOUT DEFAULTS FROM pmb01,pmb02
 
        BEFORE INPUT
            LET g_before_input_done = FALSE 
            CALL i101_set_entry(p_cmd) 
            CALL i101_set_no_entry(p_cmd) 
            LET g_before_input_done = TRUE
 
        AFTER FIELD pmb01
            IF g_pmb01 IS NULL OR g_pmb01=' ' THEN
               CALL cl_err("","apm-317",0)
#              NEXT FIELD pmb01
            END IF
            IF g_pmb01 IS NOT NULL AND (p_cmd='a' OR (g_pmb01!=g_pmb01_t)) THEN
               #判斷資料重復否
               SELECT COUNT(pmb01) INTO l_n FROM pmb_file
                  WHERE pmb01=g_pmb01
                  IF l_n >=1 THEN
                     CALL cl_err(g_pmb01,"atm-310",0)
                     NEXT FIELD pmb01
                  END IF
               #判斷是否有此付款條件
               SELECT COUNT(pma01) INTO l_n FROM pma_file 
                WHERE pma01=g_pmb01
                  AND pmaacti ='Y'    #No.TQC-770068
               IF l_n !=1 THEN
                  CALL cl_err("","axm-317",0)
                  NEXT FIELD pmb01
               END IF 
               SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01=g_pmb01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","pma_file",g_pmb01,"",SQLCA.sqlcode,"","",1)
                  NEXT FIELD pmb01
               ELSE          
                  DISPLAY l_pma02 TO pmb01_pma02
               END IF        
             END IF
        BEFORE FIELD pmb02
            IF g_pmb02 IS NULL THEN
               LET g_pmb02='1'
            END IF
 
#        ON ACTION CONTROLN
#            CALL i101_b_askkey()
#            EXIT INPUT
 
        ON ACTION CONTROLP                 
            CASE
                WHEN INFIELD(pmb01)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pma"
                   LET g_qryparam.default1 = g_pmb01
                   CALL cl_create_qry() RETURNING g_pmb01 
                   DISPLAY g_pmb01 TO pmb01
                   NEXT FIELD pmb01        
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
FUNCTION i101_q()
  DEFINE l_pmb01  LIKE pmb_file.pmb01,
         l_cnt    LIKE type_file.num10               #No.FUN-680136 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pmb01 TO NULL     #No.FUN-6A0162
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_pmb.clear()
 
    CALL i101_cs()                 #去得查詢條件 
    IF INT_FLAG THEN               #使用者不玩了  
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i101_bcs                  #從DB產生合乎條件的TEMP(0-30秒)  
    IF SQLCA.sqlcode THEN           
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_pmb01 TO NULL
    ELSE
        OPEN i101_count                                                     
        FETCH i101_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i101_fetch('F')        #讀取TEMP的第一筆并顯示  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1         #處理方式        #No.FUN-680136 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i101_bcs INTO g_pmb01
        WHEN 'P' FETCH PREVIOUS i101_bcs INTO g_pmb01
        WHEN 'F' FETCH FIRST    i101_bcs INTO g_pmb01
        WHEN 'L' FETCH LAST     i101_bcs INTO g_pmb01
        WHEN '/' 
         IF (NOT g_no_ask) THEN   #No.FUN-6A0067
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
         FETCH ABSOLUTE g_jump i101_bcs INTO g_pmb01,g_pmb02,g_pmbacti,g_pmbuser,g_pmbmodu,g_pmbgrup,g_pmbdate
         LET g_no_ask = FALSE             #No.FUN-6A0067
    END CASE
 
    IF SQLCA.sqlcode THEN                        
        CALL cl_err(g_pmb01,SQLCA.sqlcode,0)
        INITIALIZE g_pmb01 TO NULL  #TQC-6B0105
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
    OPEN i101_count
    FETCH i101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    CALL i101_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i101_show()
DEFINE l_pma02         LIKE pma_file.pma02

    SELECT DISTINCT(pmb02),pmbacti,pmbuser,pmbgrup,pmbmodu,pmbdate
                          ,pmborig,pmboriu          #TQC-AA0103
      INTO g_pmb02,g_pmbacti,g_pmbuser,g_pmbgrup,g_pmbmodu,g_pmbdate
          ,g_pmborig,g_pmboriu                      #TQC-AA0103
      FROM pmb_file 
    WHERE pmb01=g_pmb01  
 
    DISPLAY g_pmb01 TO pmb01  #ATTRIBUTE(YELLOW)    #單頭
    DISPLAY g_pmb02 TO pmb02 
    DISPLAY g_pmbacti TO pmbacti
    DISPLAY g_pmbuser TO pmbuser
    DISPLAY g_pmbgrup TO pmbgrup
    DISPLAY g_pmbmodu TO pmbmodu
    DISPLAY g_pmbdate TO pmbdate
    DISPLAY g_pmborig TO pmborig   #TQC-AA0103	
    DISPLAY g_pmboriu TO pmboriu   #TQC-AA0103
    
    LET l_pma02=null
    SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01 = g_pmb01
    DISPLAY l_pma02 TO pmb01_pma02
    CALL i101_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#刪除整筆資料(所有合乎單頭的資料)
FUNCTION i101_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pmb01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6A0162
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下 
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pmb01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pmb01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM pmb_file WHERE pmb01 = g_pmb01 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","pmb_file",g_pmb01,"",SQLCA.sqlcode,"",
                         "BODY DELETE",1)  #No.FUN-660104
        ELSE
            CLEAR FORM
            CALL g_pmb.clear()
            LET g_delete='Y'
            LET g_pmb01 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i101_count                                                     
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i101_bcs
               CLOSE i101_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH i101_count INTO g_row_count                 
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i101_bcs
               CLOSE i101_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt               
            OPEN i101_bcs                                      
            IF g_curs_index = g_row_count + 1 THEN            
               LET g_jump = g_row_count                       
               CALL i101_fetch('L')                           
            ELSE                                              
               LET g_jump = g_curs_index                      
               LET g_no_ask = TRUE         #No.FUN-6A0067                   
               CALL i101_fetch('/')                           
            END IF
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION i101_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用         #No.FUN-680136 SMALLINT
    l_ac_o          LIKE type_file.num5,                #No.FUN-680136 SMALLINT
    l_rows          LIKE type_file.num5,                #No.FUN-680136 SMALLINT
    l_success       LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680136 VARCHAR(1)
    l_pmb04         LIKE pmb_file.pmb04,   
    l_pmb03         LIKE pmb_file.pmb03,   #序號
    l_pmb03_t       LIKE pmb_file.pmb03,   #序號舊值
    l_pmb05         LIKE pmb_file.pmb05,   #比率
    l_pmb05_t       LIKE pmb_file.pmb05,   #比率舊值
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                  #可刪除否        #No.FUN-680136 SMALLINT
 
DEFINE l_pmbuser    LIKE pmb_file.pmbuser,  #判斷修改者和資料所有者是否為同一人
       l_pmbgrup    LIKE pmb_file.pmbgrup
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_pmb01) THEN RETURN END IF
 
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT pmb03,pmb04,'',pmb05 ",
                       "   FROM pmb_file  ",
                       "   WHERE pmb01=?   ",
                       "    AND pmb03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_bcl CURSOR FROM g_forupd_sql 
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_pmb WITHOUT DEFAULTS FROM s_pmb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL i101_set_entry_b()
            CALL i101_set_no_entry_b()
 
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_pmb_t.* = g_pmb[l_ac].*      #BACKUP
                OPEN i101_bcl USING g_pmb01,g_pmb_t.pmb03
                IF STATUS THEN
                   CALL cl_err("OPEN i101_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i101_bcl INTO g_pmb[l_ac].* 
                   IF STATUS THEN
                      CALL cl_err(g_pmb_t.pmb03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      SELECT pma02 INTO g_pmb[l_ac].pmb04_pma02 FROM pma_file
                       WHERE pma01 = g_pmb[l_ac].pmb04
                      LET g_pmb_t.*=g_pmb[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pmb[l_ac].* TO NULL      #900423
            LET g_pmb_t.* = g_pmb[l_ac].*         #輸入新資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pmb03
 
    AFTER INSERT
        SELECT DISTINCT(pmbuser) INTO l_pmbuser FROM pmb_file
         WHERE pmb01=g_pmb01
        SELECT DISTINCT(pmbgrup) INTO l_pmbgrup FROM pmb_file
         WHERE pmb01=g_pmb01
        IF l_pmbuser != g_user AND l_pmbuser IS NOT NULL THEN
           LET g_pmbuser= l_pmbuser
           LET g_pmbmodu= g_user
        ELSE
           LET g_pmbuser = g_user 
           LET g_pmbmodu = g_user
        END IF
        IF l_pmbgrup != g_grup AND l_pmbgrup IS NOT NULL THEN
           LET g_pmbgrup = l_pmbgrup
        ELSE
           LET g_pmbgrup = g_grup
        END IF
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO pmb_file(pmb01,pmb02,pmb03,pmb04,pmb05,
                                 pmbacti,pmbuser,pmbgrup,pmbdate,pmboriu,pmborig)
                          VALUES(g_pmb01,g_pmb02,g_pmb[l_ac].pmb03,
                                 g_pmb[l_ac].pmb04,g_pmb[l_ac].pmb05,
                                 'Y',g_pmbuser,g_pmbgrup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","pmb_file",g_pmb01,g_pmb[l_ac].pmb03,
                             SQLCA.sqlcode,"","",1)  #No.FUN-660104
               CANCEL INSERT
            ELSE
               UPDATE pmb_file SET pmbmodu = g_pmbmodu
                WHERE pmb01=g_pmb01
               MESSAGE 'INSERT O.K'
               COMMIT WORK 
               LET g_rec_b=g_rec_b+1
            END IF
 
        BEFORE FIELD pmb03
            IF g_pmb[l_ac].pmb03 IS NULL THEN
               SELECT MAX(pmb03)+1 INTO g_pmb[l_ac].pmb03 
                 FROM pmb_file WHERE pmb01=g_pmb01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","pmb_file",g_pmb01,"",SQLCA.sqlcode,"","",1)
                  NEXT FIELD pmb03
               END IF 
               IF g_pmb[l_ac].pmb03 IS NULL THEN
                  LET g_pmb[l_ac].pmb03=1
               END IF
            END IF 
 
        AFTER FIELD pmb03
            IF g_pmb[l_ac].pmb03 != g_pmb_t.pmb03 OR g_pmb_t.pmb03 IS NULL THEN
               SELECT COUNT(pmb01) INTO l_n FROM pmb_file 
                WHERE pmb01=g_pmb01 AND pmb03=g_pmb[l_ac].pmb03
               IF l_n>=1 THEN
                  CALL cl_err(g_pmb[l_ac].pmb03,"asf-406",1)
                  LET g_pmb[l_ac].pmb03=g_pmb_t.pmb03
                  NEXT FIELD pmb03
               END IF
            END IF
 
        AFTER FIELD pmb04
            IF g_pmb[l_ac].pmb04 IS NOT NULL THEN
               #No.TQC-740205  --Begin
               IF g_pmb[l_ac].pmb04 = g_pmb01 THEN 
                  CALL cl_err(g_pmb[l_ac].pmb04,"apm1009",1)
                  NEXT FIELD pmb04
               END IF
               #No.TQC-740205  --End
               IF p_cmd='a' OR (p_cmd='u' AND g_pmb_t.pmb04 != g_pmb[l_ac].pmb04) THEN
                  #資料是否重復
                  SELECT COUNT(pmb04) INTO l_n FROM pmb_file
                   WHERE pmb04=g_pmb[l_ac].pmb04 AND pmb01=g_pmb01
                  IF l_n >=1 THEN
                     CALL cl_err(g_pmb[l_ac].pmb04,"atm-310",1)
                     NEXT FIELD pmb04
                  END IF
               END IF
               #是否存在此收款條件
               SELECT COUNT(pma01) INTO l_n FROM pma_file 
                WHERE pma01=g_pmb[l_ac].pmb04
               IF l_n !=1 THEN
                  CALL cl_err("","axm-317",1)
                  NEXT FIELD pmb04
               END IF 
               SELECT pma02 INTO g_pmb[l_ac].pmb04_pma02 FROM pma_file
                WHERE pma01=g_pmb[l_ac].pmb04
               DISPLAY g_pmb[l_ac].pmb04_pma02 TO pmb04_pma02
            END IF
 
        BEFORE FIELD pmb05
            IF g_pmb02 ='1' THEN
                IF g_pmb[l_ac].pmb05 IS NULL THEN
                   LET l_pmb05_t=0
                   LET g_pmb[l_ac].pmb05 = 0   #No.TQC-6C0019
                ELSE
                   LET l_pmb05_t=g_pmb[l_ac].pmb05
                END IF
                #No.TQC-6C0019  --begin
                IF l_ac>g_rec_b OR g_pmb[l_ac].pmb05 IS NULL THEN
                   SELECT SUM(pmb05) INTO l_pmb05 FROM pmb_file 
                    WHERE pmb01=g_pmb01 AND pmb03 != g_pmb[l_ac].pmb03
                    IF l_pmb05 IS NULL THEN
                       LET g_pmb[l_ac].pmb05=100
                    ELSE
                       LET g_pmb[l_ac].pmb05 = 100-l_pmb05
                    END IF
                    LET l_pmb05_t=g_pmb[l_ac].pmb05
                    DISPLAY BY NAME g_pmb[l_ac].pmb05
                    DISPLAY BY NAME g_pmb[l_ac].*
                END IF
                #No.TQC-6B0019  --end
            END IF
            
        AFTER FIELD pmb05
            IF g_pmb02 = '1' THEN
               IF g_pmb[l_ac].pmb05 IS NULL THEN
                  CALL cl_err("","axm-471",1)
                  NEXT FIELD pmb05
               END IF
               IF g_pmb[l_ac].pmb05 IS NOT NULL  OR g_pmb[l_ac].pmb03!=l_pmb03_t THEN 
                  DISPLAY BY NAME g_pmb[l_ac].pmb05
                  SELECT SUM(pmb05) INTO l_pmb05 FROM pmb_file
                   WHERE pmb01=g_pmb01 AND pmb03 != g_pmb[l_ac].pmb03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","pmb_file",g_pmb01,"",SQLCA.sqlcode,"","SEL SUM",1)
                     NEXT FIELD pmb05
                  END IF
                  IF l_pmb05 IS NULL THEN
                     LET l_pmb05=0
                  END IF
                  IF (l_pmb05+g_pmb[l_ac].pmb05) > 100 THEN
                     CALL cl_err(' ','agl-106',0)
                     LET g_pmb[l_ac].pmb05=l_pmb05_t
                     NEXT FIELD pmb05
                  END IF 
                  #No.TQC-6C0019  --begin
                  IF g_pmb[l_ac].pmb05 <= 0 THEN
                     CALL cl_err(' ','agl-105',0)
                     NEXT FIELD pmb05 
                  END IF
                  #No.TQC-6C0019  --end
               END IF
            END IF
 
        BEFORE DELETE                            #刪除單身
            IF g_pmb_t.pmb03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM pmb_file
                 WHERE pmb01 = g_pmb01 
                   AND pmb03 = g_pmb_t.pmb03 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","pmb_file",g_pmb_t.pmb03,"",
                                  SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
            LET g_rec_b=g_rec_b-1
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pmb[l_ac].* = g_pmb_t.*
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pmb[l_ac].pmb03,-263,1)
               LET g_pmb[l_ac].* = g_pmb_t.*
            ELSE
               UPDATE pmb_file SET pmb01  =g_pmb01,
                                   pmb02  =g_pmb02,
                                   pmbmodu=g_user,
                                   pmbdate=g_today,
                                   pmb03=g_pmb[l_ac].pmb03,
                                   pmb04=g_pmb[l_ac].pmb04,
                                   pmb05=g_pmb[l_ac].pmb05
                WHERE pmb01 = g_pmb01 
                  AND pmb03 = g_pmb_t.pmb03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pmb_file",g_pmb[l_ac].pmb03,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_pmb[l_ac].* = g_pmb_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
 
    AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac           #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pmb[l_ac].* = g_pmb_t.*
               #FUN-D30034---add---str---
               ELSE
                  CALL g_pmb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034---add---end---
               END IF
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac           #FUN-D30034 add
            CLOSE i101_bcl
            COMMIT WORK
#No.TQC-6C0019  --begin
    AFTER INPUT 
        SELECT SUM(pmb05) INTO l_pmb05 FROM pmb_file WHERE pmb01=g_pmb01
        IF l_pmb05 <>100 THEN
           CALL cl_err(' ','agl-107',0)
           NEXT FIELD pmb05
        END IF
#No.TQC-6C0019  --end  
          
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pmb04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pma"
                   LET g_qryparam.default1 = g_pmb[l_ac].pmb04
                   CALL cl_create_qry() RETURNING g_pmb[l_ac].pmb04
                   NEXT FIELD pmb04
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
#        ON ACTION CONTROLO                        #沿用所有欄位                                                                     
#           IF INFIELD(pmb03) AND l_ac > 1 THEN                                                                                      
#               LET g_pmb[l_ac].* = g_pmb[l_ac-1].* 
#               LET g_pmb[l_ac].pmb03 = g_rec_b+1
#               NEXT FIELD pmb03                                                                                                     
#           END IF      
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
    END INPUT
    CLOSE i101_bcl
    COMMIT WORK
    #No.TQC-6C0019  --begin
    #FUN-D30034---add---str---
    IF g_action_choice = "detail" THEN
       RETURN
    END IF
    #FUN-D30034---add---end---
    FOR l_ac=1 TO g_rec_b 
        IF g_pmb[l_ac].pmb05 <=0 THEN
           CALL cl_err(' ','agl-105',0)
           CALL i101_b()
        END IF
    END FOR
 
    SELECT SUM(pmb05) INTO l_pmb05 FROM pmb_file WHERE  pmb01=g_pmb01
       IF l_pmb05 <>100 THEN
          CALL cl_err(' ','agl-107',0)
          CALL i101_b() 
       END IF
    #No.TQC-6C0019  --end
    SELECT COUNT(pmb03) INTO l_n FROM pmb_file WHERE pmb01=g_pmb01
    IF l_n = 0 THEN
       CALL i101_delall() 
    END IF
 
END FUNCTION
 
FUNCTION i101_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000             #No.FUN-680136 VARCHAR(200)
 
 CONSTRUCT l_wc ON pmb03,pmb04,pmb05  #屏幕上取條件
       FROM s_pmb[1].pmb03,s_pmb[1].pmb04,s_pmb[1].pmb05
 
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
    CALL i101_b_fill(l_wc)
END FUNCTION
 
FUNCTION i101_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql = "SELECT pmb03,pmb04,pma02,pmb05 ",
                "  FROM pmb_file LEFT OUTER JOIN pma_file ON pma01 = pmb04",
                " WHERE pmb01 = '",g_pmb01,"'",
    #           "   AND ",p_wc CLIPPED ,    #No.TQC-6C0019
                " ORDER BY pmb03"
    PREPARE i101_prepare2 FROM g_sql      
    DECLARE pmb_cs CURSOR FOR i101_prepare2
    CALL g_pmb.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH pmb_cs INTO g_pmb[g_cnt].*   #單身ARRAY填充
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
        CALL g_pmb.deleteElement(g_cnt)
        LET g_rec_b = g_cnt - 1     
       #LET g_cnt = 0
END FUNCTION
 
FUNCTION i101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmb TO s_pmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY            
 
      ON ACTION previous
         CALL i101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
 
      ON ACTION jump 
         CALL i101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
 
      ON ACTION next
         CALL i101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
 
      ON ACTION last 
         CALL i101_fetch('L')
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
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i101_copy()
DEFINE l_newno1,l_oldno1  LIKE pmb_file.pmb01,
       l_pma02_1          LIKE pma_file.pma02,
       p_cmd              LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
       l_n                LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_pmb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE                                             
    CALL i101_set_entry('a')                                                  
    LET g_before_input_done = TRUE  
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT l_newno1 FROM pmb01
 
       AFTER FIELD pmb01 
            SELECT COUNT(*) INTO l_n FROM pmb_file WHERE pmb01=l_newno1 
            IF l_n > 0 THEN 
               CALL cl_err(l_newno1,-239,0) NEXT FIELD pmb01
            END IF
            SELECT pma02 INTO l_pma02_1 FROM pma_file WHERE pma01=l_newno1 
            IF STATUS THEN 
               CALL cl_err3("sel","pma_file",l_newno1,"",STATUS,"","",1) NEXT FIELD pmb01 
            END IF
            DISPLAY l_pma02_1 TO pmb01_pma02
  
       ON ACTION CONTROLP
           CASE
               WHEN INFIELD(pmb01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_pma"
                 LET g_qryparam.default1=l_newno1
                 CALL cl_create_qry() RETURNING l_newno1
                 DISPLAY l_newno1 to pmb01
                 NEXT FIELD pmb01         
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
        LET INT_FLAG = 0 DISPLAY g_pmb01 TO pmb01 #ATTRIBUTE(YELLOW)   #TQC-8C0076
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM pmb_file         #單身復制
        WHERE g_pmb01=pmb01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x",g_pmb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    END IF
    UPDATE x SET pmb01 = l_newno1 
    INSERT INTO pmb_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","pmb_file",l_newno1,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    ELSE
       UPDATE pmb_file SET pmbuser=g_user,
                           pmbgrup=g_grup,
                           pmbdate=g_today
        WHERE pmb01=l_newno1
    END IF
    LET l_oldno1= g_pmb01
    LET g_pmb01=l_newno1
    CALL i101_b()
    #LET g_pmb01=l_oldno1  #FUN-C80046
    #CALL i101_show()      #FUN-C80046
END FUNCTION
 
FUNCTION i101_out()
    DEFINE
       l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
       l_pmb           RECORD LIKE pmb_file.*,
       l_gen           RECORD LIKE gen_file.*,
       l_name          LIKE type_file.chr20,         #No.FUN-680136 VARCHAR(20)
       sr              RECORD 
                       pmb01   LIKE pmb_file.pmb01,
                       pmb01_pma02 LIKE pma_file.pma02,
                       pmb02   LIKE pmb_file.pmb02,
                       pmb03   LIKE pmb_file.pmb03,
                       pmb04   LIKE pmb_file.pmb04,
                       pmb04_pma02 LIKE pma_file.pma02,
                      pmb05   LIKE pmb_file.pmb05
                       END RECORD,
       l_pma02_1       LIKE pma_file.pma02,
       l_pmb04_pma02       LIKE pma_file.pma02
  DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-820002
 
  #IF cl_null(g_wc) AND NOT cl_null(g_pmb01) AND NOT cl_null(g_pmb[l_ac].pmb03) THEN
  #   LET g_wc = " pmb01 = '",g_pmb01,"' AND pmb03 = '",g_pmb[l_ac].pmb03,"'"                                   
  #END IF  
#No.FUN-820002--start-- 
 #IF cl_null(g_pmb01) THEN CALL cl_err('','9057',0) RETURN END IF
   IF cl_null(g_wc) AND NOT cl_null(g_pmb01)  THEN                                                                                  
      LET g_wc = " pmb01 = '",g_pmb01,"' "                                                                                          
   END IF                                                                                                                           
   IF g_wc IS NULL THEN                                                                                                             
      CALL cl_err('','9057',0)                                                                                                      
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   #報表轉為使用 p_query                                                                                                            
   LET l_cmd = 'p_query "apmi101" "',g_pmb01,'" "',g_wc CLIPPED,'"'                                                                 
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN 
#   CALL cl_wait()
#   CALL cl_outnam('apmi101') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT pmb01,'',pmb02,pmb03,pmb04,'',pmb05",
#             "  FROM pmb_file ",
#             " WHERE pmb01='",g_pmb01 CLIPPED,"'",
#             " ORDER BY pmb03 "  
#   PREPARE i101_p1 FROM g_sql
#   DECLARE i101_curo CURSOR FOR i101_p1
 
#   START REPORT i101_rep TO l_name
 
#   FOREACH i101_curo INTO sr.*   
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#       END IF
#       SELECT pma02 INTO sr.pmb01_pma02 FROM pma_file WHERE  pma01 = sr.pmb01
#       SELECT pma02 INTO sr.pmb04_pma02 FROM pma_file WHERE  pma01 = sr.pmb04
#       OUTPUT TO REPORT i101_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i101_rep
 
#   CLOSE i101_curo
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i101_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)
#       l_cnt           LIKE type_file.num10,               #No.FUN-680136 INTEGER
#       sr              RECORD 
#                       pmb01   LIKE pmb_file.pmb01,
#                       pmb01_pma02 LIKE pma_file.pma02,
#                       pmb02   LIKE pmb_file.pmb02,
#                       pmb03   LIKE pmb_file.pmb03,
#                       pmb04   LIKE pmb_file.pmb04,
#                       pmb04_pma02 LIKE pma_file.pma02,
#                       pmb05   LIKE pmb_file.pmb05
#                       END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
#   ORDER BY sr.pmb01,sr.pmb03
#   FORMAT
#     PAGE HEADER
##No.TQC-770068--begin
##     PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED 
##           LET g_pageno = g_pageno + 1  
##           LET pageno_total = PAGENO USING '<<<',"/pageno"                     
##           PRINT g_head CLIPPED,pageno_total                                   
##     PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                           
##     PRINT ' '                                                                 
#     PRINT COLUMN (g_len-FGL_WIDTH(g_company CLIPPED))/2+1,g_company CLIPPED                                                       
#     PRINT ' '                                                                                                                     
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED #No.FU                                                    
#     LET g_pageno = g_pageno + 1                                                                                                   
#     LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                               
#     PRINT g_head CLIPPED,pageno_total 
##No.TQC-770068--end
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#     PRINT g_dash1
#     LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.pmb01 CLIPPED,
#                 COLUMN g_c[32],sr.pmb01_pma02 CLIPPED;
#           IF sr.pmb02='1' THEN
#              PRINT COLUMN g_c[33],g_x[9] CLIPPED;
#           ELSE 
#              PRINT COLUMN g_c[33],g_x[10] CLIPPED;
#           END IF
#           PRINT COLUMN g_c[34],sr.pmb03 USING '<<<<<',
#                 COLUMN g_c[35],sr.pmb04 CLIPPED,
#                 COLUMN g_c[36],sr.pmb04_pma02 CLIPPED,
#                 COLUMN g_c[37],sr.pmb05 USING '##&.&&' 
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
#No.FUN-820002 --end--
 
FUNCTION i101_set_entry(p_cmd)                                                  
DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-680136 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("pmb01",TRUE)                               
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i101_set_no_entry(p_cmd)                                               
DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-680136 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       IF p_cmd = 'u' AND g_chkey = 'N' THEN                                    
           CALL cl_set_comp_entry("pmb01",FALSE)                          
       END IF                                                                   
   END IF                                                                       
END FUNCTION
 
FUNCTION i101_set_entry_b()
    IF g_pmb02='1' THEN
       CALL cl_set_comp_entry("pmb05",TRUE)
    END IF
END FUNCTION
 
FUNCTION i101_set_no_entry_b()
    IF g_pmb02='2' THEN
       CALL cl_set_comp_entry("pmb05",FALSE)
    END IF
END FUNCTION
 
FUNCTION i101_delall()                                                                                                              
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料                                                            
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED                       
      #IF cl_delb(0,0) THEN                       
          DELETE FROM pmb_file WHERE pmb01 = g_pmb01
          CLEAR FORM 
          CALL g_pmb.clear() 
      #END IF                                                                                                                       
    END IF                                                                                                                          
END FUNCTION       
 
FUNCTION i101_pmb02()
    IF g_pmb02 != g_pmb02_t AND g_pmb02 = '1' THEN
       UPDATE pmb_file SET pmb05=0 WHERE pmb01=g_pmb01
       CALL i101_show()
       CALL cl_err("","axm-472",1)
       CALL i101_b()
    END IF
    IF g_pmb02 != g_pmb02_t AND g_pmb02 = '2' THEN
       UPDATE pmb_file SET pmb05 = NULL
        WHERE pmb01=g_pmb01
       CALL i101_show()
    END IF
END FUNCTION
#TQC-790177
