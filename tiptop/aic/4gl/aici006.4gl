# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: aici006.4gl                                                  
# Descriptions...: ICD料件廠商價格維護作業                                   
# Date & Author..: No.FUN-7B0029 07/11/13 By hongmei
# Modify.........: No.FUN-830130 08/03/26 By hongmei 去掉icg14 icg15欄位  
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-920096 09/02/12 By jan icg04 可空白,給 ' '
# Modify.........: No.CHI-920075 09/02/23 By jan 在SOP上寫會自動算參考單價,實際上沒有算,且單價與參考單價的檢查是寫死的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds                                                                     
                                                                                
GLOBALS "../../config/top.global"                                               
                                                                                
DEFINE
    g_icg01          LIKE icg_file.icg01,
    g_icg01_t        LIKE icg_file.icg01,
    b_icg            RECORD LIKE icg_file.*,
    g_icg            DYNAMIC ARRAY OF RECORD
                     icg03   LIKE icg_file.icg03,   #廠商
                     pmc03   LIKE pmc_file.pmc03,   #簡稱
                     icg04   LIKE icg_file.icg04,   #Tester
                     icg02   LIKE icg_file.icg02,   #作業編號
                     ecd02   LIKE ecd_file.ecd02,   #作業名稱
                     icg28   LIKE icg_file.icg28,   #計算公式
                     icg16   LIKE icg_file.icg16,   #Default廠商否
                     icg17   LIKE icg_file.icg17,   #失效日期
                     icg18   LIKE icg_file.icg18,   #Tray盤規格
                     icg19   LIKE icg_file.icg19,   #切穿模式
                     icg20   LIKE icg_file.icg20,   #切割方式
                     icg06   LIKE icg_file.icg06,   #TEST TIME FOR WAFER
                     icg07   LIKE icg_file.icg07,   #INDEX TIME FOR WAFER
                     icg08   LIKE icg_file.icg08,   #TEST TIME FOR DIE
                     icg09   LIKE icg_file.icg09,   #INDEX TIME FOR DIE
                     icg10   LIKE icg_file.icg10,   #HOURLY RATE
                     icg11   LIKE icg_file.icg11,   #DUT
                     icg23   LIKE icg_file.icg23,   #系數
                     icg24   LIKE icg_file.icg24,   #參考單價
                     icg05   LIKE icg_file.icg05,   #單價
                     icg25   LIKE icg_file.icg25,   #UV price
                     icg26   LIKE icg_file.icg26,   #Baking price
                     icg27   LIKE icg_file.icg27,   #Lead Scan for FT
                     icg12   LIKE icg_file.icg12,   #Programming Time
                     icg13   LIKE icg_file.icg13    #幣別
#                    icg14   LIKE icg_file.icg14,   #自訂欄位
#                    icg15   LIKE icg_file.icg15    #自訂欄位
                     END RECORD,
    g_icg_t          RECORD                                    
                     icg03   LIKE icg_file.icg03,
                     pmc03   LIKE pmc_file.pmc03,
                     icg04   LIKE icg_file.icg04,
                     icg02   LIKE icg_file.icg02,
                     ecd02   LIKE ecd_file.ecd02,
                     icg28   LIKE icg_file.icg28,
                     icg16   LIKE icg_file.icg16,
                     icg17   LIKE icg_file.icg17,
                     icg18   LIKE icg_file.icg18,
                     icg19   LIKE icg_file.icg19,
                     icg20   LIKE icg_file.icg20,
                     icg06   LIKE icg_file.icg06,
                     icg07   LIKE icg_file.icg07,
                     icg08   LIKE icg_file.icg08,
                     icg09   LIKE icg_file.icg09,
                     icg10   LIKE icg_file.icg10,
                     icg11   LIKE icg_file.icg11,
                     icg23   LIKE icg_file.icg23,
                     icg24   LIKE icg_file.icg24,
                     icg05   LIKE icg_file.icg05,
                     icg25   LIKE icg_file.icg25,
                     icg26   LIKE icg_file.icg26,
                     icg27   LIKE icg_file.icg27,
                     icg12   LIKE icg_file.icg12,
                     icg13   LIKE icg_file.icg13
#                    icg14   LIKE icg_file.icg14,
#                    icg15   LIKE icg_file.icg15
                     END RECORD,                  
    g_wc                STRING,                                                 
    g_wc2               STRING,                                                 
    g_sql               STRING,                                                 
    g_rec_b             LIKE type_file.num5,         #單身筆數
    g_succ              LIKE type_file.chr1,
    l_ac                LIKE type_file.num5          #目前處理的ARRAY CNT
DEFINE   g_forupd_sql   STRING                       #SELECT ... FOR UPDATE NOWe
DEFINE   g_before_input_done  LIKE type_file.num5                               
DEFINE   g_cnt          LIKE type_file.num10                                    
DEFINE   g_i            LIKE type_file.num5
DEFINE   g_msg          LIKE type_file.chr1000                                  
DEFINE   g_curs_index   LIKE type_file.num10                                    
DEFINE   g_row_count    LIKE type_file.num10                                    
DEFINE   g_jump         LIKE type_file.num10                                    
DEFINE   mi_no_ask      LIKE type_file.num5 
DEFINE   l_cmd          LIKE type_file.chr1000
 
MAIN                                                                            
   DEFINE p_row,p_col   LIKE type_file.num5                                  
                                                                                
   OPTIONS                                           #改變一些系統預設值        
      INPUT NO WRAP
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理 
 
   IF (NOT cl_user()) THEN                                                      
      EXIT PROGRAM                                                              
   END IF                                                                       
                                                                                
   WHENEVER ERROR CALL cl_err_msg_log                                           
                                                                                
   IF (NOT cl_setup("aic")) THEN                                                
      EXIT PROGRAM                                                              
   END IF
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM                                                              
   END IF    
   
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)              
         RETURNING g_time                                                       
   LET g_icg01 = NULL                     #清除鍵值                             
   LET g_icg01_t = NULL
 
   LET p_row = 5 LET p_col = 25                                                 
   OPEN WINDOW i006_w AT p_row,p_col WITH FORM "aic/42f/aici006"                
   ATTRIBUTE (STYLE = g_win_style CLIPPED)                                      
                                                                                
   CALL cl_ui_init()
   
   CALL i006_menu()                                                             
     	                                                                             
   CLOSE WINDOW i006_w                    #結束畫面                             
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)              
         RETURNING g_time                                                       
END MAIN 
 
FUNCTION i006_cs()                                                              
                                                                                
   CLEAR FORM                             #清除畫面                             
   LET g_icg01=NULL
                                                                
   CALL g_icg.clear()                                                           
                                                                                
      CONSTRUCT g_wc ON icg01,icg03,pmc03,icg04,icg02,ecd02,
                        icg28,icg16,icg17,icg18,icg19,icg20,
                        icg06,icg07,icg08,icg09,icg10,icg11,
                        icg23,icg24,icg05,icg25,ich26,icg27,
                        icg12,icg13
                   #   ,icg14,icg15     No.FUN-830130
              FROM icg01,s_icg[1].icg03,s_icg[1].pmc03,s_icg[1].icg04,
                   s_icg[1].icg02,s_icg[1].ecd02,s_icg[1].icg28,s_icg[1].icg16,
                   s_icg[1].icg17,s_icg[1].icg18,s_icg[1].icg19,s_icg[1].icg20,
                   s_icg[1].icg06,s_icg[1].icg07,s_icg[1].icg08,s_icg[1].icg09,
                   s_icg[1].icg10,s_icg[1].icg11,s_icg[1].icg23,s_icg[1].icg24,
                   s_icg[1].icg05,s_icg[1].icg25,s_icg[1].icg26,s_icg[1].icg27,
                   s_icg[1].icg12,s_icg[1].icg13
                # ,s_icg[1].icg14,s_icg[1].icg15   No.FUN-830130
                
                                                                                
         ON ACTION controlp                                                     
            CASE                                                                
               WHEN INFIELD(icg01)                                              
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()                                        
               #   LET g_qryparam.form ="q_ima"                                  
               #   LET g_qryparam.state ="c"
               #   LET g_qryparam.default1 = g_icg01                             
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","",g_icg01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO icg01 
                  CALL i006_icg01('d')
                  NEXT FIELD icg01
               WHEN INFIELD(icg03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc"
                  LET g_qryparam.state ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO icg03 
                  CALL i006_icg03('d')
                  NEXT FIELD icg03
               WHEN INFIELD(icg02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ecd02_icd"
                  LET g_qryparam.state ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO icg02 
#                 CALL i006_icg02('d')
                  NEXT FIELD icg02
               WHEN INFIELD(icg28)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ich"
                  LET g_qryparam.state ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO icg28 
#                 CALL i006_icg28('d')
                  NEXT FIELD icg28
               WHEN INFIELD(icg13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.state ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO icg13 
                  CALL i006_icg13('d')
                  NEXT FIELD icg13           
            END CASE
   
         ON IDLE g_idle_seconds                                                 
            CALL cl_on_idle()                                                   
            CONTINUE CONSTRUCT                                                  
                                                                                
      ON ACTION about                                                           
         CALL cl_about()
 
      ON ACTION controlg                                                        
         CALL cl_cmdask()                                                       
                                                                                
     END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('icguser', 'icggrup') #FUN-980030
 
     IF INT_FLAG THEN RETURN END IF
                                                                                
   LET g_sql="SELECT UNIQUE icg01 FROM icg_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY icg01"
   PREPARE i006_prepare FROM g_sql      #預備一下
   DECLARE i006_cs                     #宣告成可捲動的
       SCROLL CURSOR  WITH HOLD FOR i006_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT icg01) FROM icg_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1" 
   PREPARE i006_precount FROM g_sql
   DECLARE i006_count CURSOR FOR i006_precount
 
END FUNCTION                                                                    
                                                                                
FUNCTION i006_menu()                                                            
   WHILE TRUE                                                                   
     CALL i006_bp("G")                                                          
     CASE g_action_choice                                                       
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i006_q()                                                    
            END IF
          
         WHEN "insert"                                                        
            IF cl_chk_act_auth() THEN                                           
                CALL i006_a()                                                   
            END IF
 
#        WHEN "modify"                                                        
#           IF cl_chk_act_auth() THEN                                           
#              CALL i006_u()                                                    
#           END IF
           
          WHEN "delete"                                                        
            IF cl_chk_act_auth() THEN                                           
                CALL i006_r()                                                   
            END IF                                                              
                                                                                
           WHEN "detail"                                                        
            IF cl_chk_act_auth() THEN                                           
                CALL i006_b()                                                   
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
 
           WHEN "exporttoexcel"                                                 
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_icg),'','')                                                             
            END IF
 
          WHEN "output"                                                        
            IF cl_chk_act_auth() THEN
               CALL i006_out()
            END IF
 
            WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i006_copy()
            END IF
                                                                                
           WHEN "help"                                                          
            CALL cl_show_help()                                                 
                                                                                
           WHEN "exit"                                                          
            EXIT WHILE                                                          
                                                                                
           WHEN "controlg"                                                      
            CALL cl_cmdask()
           WHEN "related_document"         
            IF cl_chk_act_auth() THEN
             IF g_icg01 IS NOT NULL THEN
                LET g_doc.column1 = "icg01"
 
                CALL cl_doc()
             END IF 
            END IF
            
                                                   
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION
       
FUNCTION i006_a()                                                               
                                                                                
   MESSAGE ""                                                                   
   CLEAR FORM                                                                   
   CALL g_icg.clear()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
 
   LET g_icg01 = NULL                                                           
   LET g_icg01_t = NULL
   
   CALL cl_opmsg('a')                                                           
                                                                                
    WHILE TRUE
       CALL i006_i("a")                   #輸入單頭                             
       IF INT_FLAG THEN                   #使用者不玩了                         
          LET INT_FLAG = 0                                                      
          CALL cl_err('',9001,0)                                                
          EXIT WHILE                                                            
       END IF                                                                   
       
       IF cl_null(g_icg01) THEN                                                 
          CONTINUE WHILE                                                        
       END IF                
       IF SQLCA.sqlcode THEN                                     
          CALL cl_err(g_icg01,SQLCA.sqlcode,1)  #FUN-B80083 ADD               
          ROLLBACK WORK                                                         
         # CALL cl_err(g_icg01,SQLCA.sqlcode,1)  #FUN-B80083 MARK                                
          CONTINUE WHILE                                                        
       ELSE                                                                     
          COMMIT WORK                                                           
       END IF
 
       CALL g_icg.clear()                                                       
       LET g_rec_b = 0                                                          
       DISPLAY g_rec_b TO FORMONLY.cn2
                                          
       IF g_succ='N' THEN                                                          
         CALL g_icg.clear()                                                     
       ELSE                                                                      
         CALL i006_b_fill('1=1')          #單身                                  
       END IF
                                                                                
       CALL i006_b()                      #輸入單身                             
                                                                                
       LET g_icg01_t = g_icg01            #保留舊值                             
       EXIT WHILE                                                               
    END WHILE                                                                   
    LET g_wc=' '                                                                
                                                                                
END FUNCTION
 
FUNCTION i006_u()
 
    IF cl_null(g_icg01) THEN                                                     
      CALL cl_err('',-400,0)                                                    
      RETURN                                                                    
   END IF                                                                       
                                                                                
   MESSAGE ""                                                                   
   CALL cl_opmsg('u')                                                           
   LET g_icg01_t = g_icg01
 
   WHILE TRUE
      CALL i006_i("u")                      #欄位更改                           
                                                                                
      IF INT_FLAG THEN                                                          
         LET g_icg01=g_icg01_t                                                  
         DISPLAY g_icg01 TO icg01           #單頭                               
         LET INT_FLAG = 0                                                       
         CALL cl_err('',9001,0)                                                 
         EXIT WHILE                                                             
      END IF 
 
       IF g_icg01 != g_icg01_t THEN                 #更改單頭值                 
         UPDATE icg_file SET icg01 = g_icg01        #更新DB                     
          WHERE icg01 = g_icg01_t                   #COLAUTH?                   
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("upd","icg_file",g_icg01_t,"",SQLCA.sqlcode,"","",1)   
            CONTINUE WHILE                                                      
         END IF                                                                 
      END IF                                                                    
      EXIT WHILE                                                                
   END WHILE                                                                    
                                                                                
END FUNCTION
 
FUNCTION i006_i(p_cmd)                                                          
DEFINE                                                                          
   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改                    
   l_n             LIKE type_file.num5,                                          
   l_m             LIKE type_file.num5 
                                                                               
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   INPUT  g_icg01 WITHOUT DEFAULTS  FROM icg01                    
      AFTER FIELD icg01                       #部門編號                         
         IF NOT cl_null(g_icg01) THEN
          #FUN-AA0059 ----------------add start--------------
          IF NOT s_chk_item_no(g_icg01,'') THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD icg01
          END IF 
          #FUN-AA0059 ----------------add end----------------
          IF g_icg01 != g_icg01_t OR cl_null(g_icg01_t) THEN                                             
            SELECT COUNT(distinct icg01) INTO l_n FROM ima_file                            
             WHERE ima01=g_icg01 
            IF l_n>0 then                                                       
               CALL cl_err(g_icg01,-239,0)                                      
               NEXT FIELD icg01                                                 
            END IF
            CALL i006_icg01('d')
           SELECT count(*) INTO l_m FROM ima_file
              WHERE ima01= g_icg01
            IF l_m=0 THEN
               CALL cl_err(g_icg01,'aic-004',0)
               NEXT FIELD icg01
            END IF
          END IF   
         END IF
   
       ON ACTION controlp                                                        
         CASE                                                                   
            WHEN INFIELD(icg01)                                                 
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()                                           
             #  LET g_qryparam.form ="q_ima" 
             #  LET g_qryparam.default1 = g_icg01                                
             #  CALL cl_create_qry() RETURNING g_icg01                           
               CALL q_sel_ima(FALSE, "q_ima", "", g_icg01, "", "", "", "" ,"",'' )  RETURNING g_icg01
#FUN-AA0059 --
               DISPLAY g_icg01 TO icg01                                         
         END CASE
 
      ON ACTION CONTROLR                                                        
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
 
END FUNCTION                                                                    
                                                                                
FUNCTION i006_q()
   CALL cl_opmsg('q')                                                           
                                                                                
   LET g_row_count = 0                                                          
   LET g_curs_index = 0                                                         
   CALL cl_navigator_setting(g_curs_index,g_row_count)                          
                                                                                
   CALL i006_cs()                     #取得查詢條件                             
                                                                                
   IF INT_FLAG THEN                   #使用者不玩了                             
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i006_count                                                            
   FETCH i006_count INTO g_row_count                                            
   DISPLAY g_row_count TO FORMONLY.cnt                                          
                                                                                
   OPEN i006_cs                        #從DB產生合乎條件TEMP(0-30秒)            
   IF SQLCA.sqlcode THEN               #有問題                                  
      CALL cl_err('',SQLCA.sqlcode,0)                                           
   ELSE                                                                         
      CALL i006_fetch('F')             #讀出TEMP第一筆并顯示                    
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i006_fetch(p_flag)                                                     
DEFINE                                                                          
   p_flag      LIKE type_file.chr1,    #處理方式                                
   l_abso      LIKE type_file.num10    #絕對的筆數                              
                                                                                
   MESSAGE ""                                                                   
   CASE p_flag                                                                  
      WHEN 'N' FETCH NEXT     i006_cs INTO g_icg01                      
      WHEN 'P' FETCH PREVIOUS i006_cs INTO g_icg01                      
      WHEN 'F' FETCH FIRST    i006_cs INTO g_icg01                      
      WHEN 'L' FETCH LAST     i006_cs INTO g_icg01                     
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF                  
         END IF                                                                 
         FETCH ABSOLUTE g_jump i006_cs INTO g_icg01                             
         LET mi_no_ask = FALSE                                                  
   END CASE 
 
   LET g_succ='Y'                                                               
   IF SQLCA.sqlcode THEN                         #有麻煩                        
      CALL cl_err(g_icg01,SQLCA.sqlcode,0)                                      
      INITIALIZE g_icg01 TO NULL                                                
      LET g_succ='N'                                                            
   ELSE                                                                         
      CASE p_flag                                                               
         WHEN 'F' LET g_curs_index = 1                                          
         WHEN 'P' LET g_curs_index = g_curs_index - 1                           
         WHEN 'N' LET g_curs_index = g_curs_index + 1                           
         WHEN 'L' LET g_curs_index = g_row_count                                
         WHEN '/' LET g_curs_index = g_jump                                     
      END CASE                                                                  
                                                                                
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL i006_show()                                                          
   END IF                                                                       
                                                                                
END FUNCTION 
 
FUNCTION i006_show()                                                            
   LET g_icg01_t = g_icg01
   DISPLAY g_icg01 TO icg01 
   CALL i006_icg01('d')
   CALL i006_b_fill(g_wc)                 #單身                                 
                                                                                
   CALL cl_show_fld_cont()                                                      
END FUNCTION 
 
FUNCTION i006_r()                                                               
                                                                                
   IF s_shut(0) THEN RETURN END IF        #檢查權限                             
                                                                                
   IF g_icg01 IS NULL THEN                                                      
      CALL cl_err("",-400,0)                                                    
      RETURN                                                                    
   END IF 
 
   BEGIN WORK
   
   IF cl_delh(0,0) THEN                   #確認一下                             
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "icg01"      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM icg_file WHERE icg01 = g_icg01                                
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("del","icg_file",g_icg01,"",SQLCA.sqlcode,"","BODY DELETE",0)                                                                             
      ELSE                                                                      
         CLEAR FORM                                                             
         CALL g_icg.clear()                                                     
         LET g_icg01 = NULL                                                     
                                                                                
         OPEN i006_count                                                        
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i006_cs
             CLOSE i006_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i006_count INTO g_row_count                                      
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i006_cs
             CLOSE i006_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt                                    
         OPEN i006_cs                                                           
         IF g_curs_index = g_row_count + 1 THEN                                 
            LET g_jump = g_row_count                                            
            CALL i006_fetch('L')                                                
         ELSE 
            LET g_jump = g_curs_index                                           
            LET mi_no_ask = TRUE                                                
            CALL i006_fetch('/')                                                
         END IF                                                                 
         LET g_cnt=SQLCA.SQLERRD[3]                                             
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
      END IF                                                                    
   END IF                                                                       
                                                                                
   COMMIT WORK                                                                  
                                                                                
END FUNCTION
 
FUNCTION i006_b()                                                               
DEFINE                                                                          
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT                 
   l_n             LIKE type_file.num5,      #檢查重復用  
   l_n1            LIKE type_file.num5,                      
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否                        
   p_cmd           LIKE type_file.chr1,      #處理狀態                          
   l_allow_insert  LIKE type_file.num5,      #可新增否                          
   l_allow_delete  LIKE type_file.num5,      #可刪除否                          
   l_m             LIKE type_file.num5,
   l_ecd02         LIKE ecd_file.ecd02,
   l_str           string
                                                                   
   LET g_action_choice = ""                                                     
   IF s_shut(0) THEN RETURN END IF           #檢查權限                          
   IF g_icg01 IS NULL THEN                                                      
      RETURN                                                                    
   END IF 
 
   CALL cl_opmsg('b')                                                           
                                                                                
   LET g_forupd_sql = "SELECT icg03,'',icg04,icg02,'',",
                      "       icg28,icg16,icg17,icg18,icg19,icg20,",
                      "       icg06,icg07,icg08,icg09,icg10,icg11,",
                      "       icg23,icg24,icg05,icg25,icg26,icg27,",
                      "       icg12,icg13",
              #               icg14,icg15
                      "  FROM icg_file ",
                      "  WHERE icg01=? AND icg02=? ",
                      "   AND icg03=? AND icg04=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i006_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR                  
                                                                                
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")                          
                                                                                
   INPUT ARRAY g_icg WITHOUT DEFAULTS FROM s_icg.*                              
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,                 
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,         
                   APPEND ROW=l_allow_insert)                                   
                                                                                
      BEFORE INPUT                                                              
         IF g_rec_b != 0 THEN                                                   
            CALL fgl_set_arr_curr(l_ac)                                         
         END IF                                                                 
                                                                                
      BEFORE ROW                                                                
         LET p_cmd = ''                                                         
         LET l_ac = ARR_CURR()                                                  
         LET l_lock_sw = 'N'            #DEFAULT                                
         LET l_n  = ARR_COUNT()                                               
         IF g_rec_b >= l_ac THEN                                                
            BEGIN WORK                                                          
            LET g_icg_t.* = g_icg[l_ac].*      #BACKUP                          
            LET p_cmd='u'                                                       
            OPEN i006_cl USING g_icg01,g_icg[l_ac].icg02,
                               g_icg[l_ac].icg03,g_icg[l_ac].icg04 
            IF STATUS THEN
               CALL cl_err("OPEN i006_cl:", STATUS, 1)
               LET l_lock_sw = "Y"                                              
            ELSE                                                                
               FETCH i006_cl INTO g_icg[l_ac].*                                 
               IF SQLCA.sqlcode THEN                                            
                  CALL cl_err(g_icg_t.icg02,SQLCA.sqlcode,1)                    
                  LET l_lock_sw = "Y"
         #     ELSE 
         #     	  CALL i006_move_to()                                              
               END IF
               CALL i006_set_entry_b()
               CALL i006_set_no_entry_b()
               SELECT pmc03 INTO g_icg[l_ac].pmc03 FROM pmc_file WHERE pmc01 = g_icg[l_ac].icg03
               SELECT ecd02 INTO g_icg[l_ac].ecd02 FROM ecd_file WHERE ecd01 = g_icg[l_ac].icg02                                                            
            END IF                                                              
            CALL cl_show_fld_cont()                                             
         END IF                                                                 
                                                                                
      BEFORE INSERT                                                             
         LET l_n = ARR_COUNT()                                                  
         LET p_cmd='a'                                                          
         INITIALIZE g_icg[l_ac].* TO NULL 
         LET g_icg_t.* = g_icg[l_ac].*         #新輸入資料
         LET g_icg[l_ac].icg02=' '
         LET g_icg[l_ac].icg16='N'
         LET g_icg[l_ac].icg06='0'
         LET g_icg[l_ac].icg07='0'
         LET g_icg[l_ac].icg08='0'
         LET g_icg[l_ac].icg09='0'
         LET g_icg[l_ac].icg10='0'
         LET g_icg[l_ac].icg11='0'
         LET g_icg[l_ac].icg23='0'
         LET g_icg[l_ac].icg25='0'
         LET g_icg[l_ac].icg26='0'
         LET g_icg[l_ac].icg27='0'
         CALL i006_set_entry_b()
         CALL i006_set_no_entry_b()
         NEXT FIELD icg03                                                       
                                                                                
      AFTER INSERT                                                              
         IF INT_FLAG THEN                                                       
            CALL cl_err('',9001,0)                                              
            LET INT_FLAG = 0                                                    
            CANCEL INSERT                                                       
         END IF 
          IF cl_null(g_icg[l_ac].icg04) THEN LET g_icg[l_ac].icg04 = ' ' END IF  #FUN-920096
          INSERT INTO icg_file(icg01,icg03,icg04,icg02,icg28,icg16,icg17,icg18,icg19,icg20,
                               icg06,icg07,icg08,icg09,icg10,icg11,icg23,icg24,icg05,icg25,
                               icg26,icg27,icg12,icg13,          #icg14,icg15,
                               icguser,icggrup,icgmodu,icgdate,icgacti,icgoriu,icgorig)     
              VALUES(g_icg01,g_icg[l_ac].icg03,g_icg[l_ac].icg04,g_icg[l_ac].icg02,
                     g_icg[l_ac].icg28,g_icg[l_ac].icg16,g_icg[l_ac].icg17,g_icg[l_ac].icg18,
                     g_icg[l_ac].icg19,g_icg[l_ac].icg20,g_icg[l_ac].icg06,g_icg[l_ac].icg07,
                     g_icg[l_ac].icg08,g_icg[l_ac].icg09,g_icg[l_ac].icg10,g_icg[l_ac].icg11,
                     g_icg[l_ac].icg23,g_icg[l_ac].icg24,g_icg[l_ac].icg05,g_icg[l_ac].icg25,
                     g_icg[l_ac].icg26,g_icg[l_ac].icg27,g_icg[l_ac].icg12,g_icg[l_ac].icg13,
              #      g_icg[l_ac].icg14,g_icg[l_ac].icg15,
                     g_user,g_grup,'',g_today,'Y', g_user, g_grup)       #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("ins","icg_file",g_icg01,g_icg[l_ac].icg03,SQLCA.sqlcode,"","",0)
            CANCEL INSERT
         ELSE                                                                   
            MESSAGE 'INSERT O.K'                                                
            LET g_rec_b=g_rec_b+1                                               
            DISPLAY g_rec_b TO FORMONLY.cn2                                     
            COMMIT WORK                                                         
         END IF
         
      AFTER FIELD icg03
         IF NOT cl_null(g_icg[l_ac].icg03) THEN
          IF g_icg[l_ac].icg03 != g_icg_t.icg03 
             OR cl_null(g_icg_t.icg03) THEN                                             
           SELECT count(*) INTO l_m FROM pmc_file
              WHERE pmc01= g_icg[l_ac].icg03
                AND pmcacti='Y'
            IF l_m=0 THEN
               CALL cl_err(g_icg[l_ac].icg03,'aic-004',0)
               NEXT FIELD icg03
            END IF
           CALL i006_icg03('d')
          END IF   
         END IF
      #FUN-920096--BEGIN--
      AFTER FIELD icg04
        IF cl_null(g_icg[l_ac].icg04) THEN
           LET g_icg[l_ac].icg04 = ' '
        END IF
      #FUN-920096--END--
        
      AFTER FIELD icg02
         IF NOT cl_null(g_icg[l_ac].icg02) THEN
            IF p_cmd='a' OR (p_cmd='u' AND g_icg[l_ac].icg02 !=g_icg_t.icg02) THEN
               LET l_n=0
               LET l_n1=0
               SELECT COUNT(*) INTO l_n
                 FROM icg_file
                WHERE icg01=g_icg01
                  AND icg02=g_icg[l_ac].icg02
                  AND icg03=g_icg[l_ac].icg03
                  AND icg04=g_icg[l_ac].icg04
               IF l_n>0 THEN
                  LET g_icg[l_ac].icg02 = g_icg_t.icg02
                  CALL cl_err(g_icg[l_ac].icg02,-239,1)
                  NEXT FIELD icg02
               END IF
                SELECT COUNT(*) INTO l_n1 FROM ecd_file                                                                     
                        WHERE ecd01=g_icg[l_ac].icg02                                                                               
                       IF l_n1<=0 THEN                                                                                              
                          CALL cl_err('sel ecd_file',100,0)                                                                         
                          NEXT FIELD icg02                                                                                          
                       END IF                  
             CALL i006_icg02('d')
            END IF
         END IF
        
      AFTER FIELD icg28
        IF NOT cl_null(g_icg[l_ac].icg28) THEN 
           SELECT COUNT(*) INTO l_n FROM ich_file
            WHERE ich01 = g_icg[l_ac].icg28 
              AND ichacti ='Y'
           IF l_n=0 THEN 
              CALL cl_err(g_icg[l_ac].icg28,'aic-004',0) 
              NEXT FIELD icg28
           END IF 
        END IF 
      
      BEFORE FIELD icg16
         CALL i006_set_entry_b()
         
      AFTER FIELD icg16
         IF NOT cl_null(g_icg[l_ac].icg16) THEN
            IF g_icg[l_ac].icg16 NOT MATCHES '[YN]' THEN
               NEXT FIELD icg16
            END IF
            IF g_icg[l_ac].icg16='Y' THEN
               LET g_icg[l_ac].icg17 =''
               DISPLAY BY NAME g_icg[l_ac].icg17 
            END IF
         END IF 
         CALL i006_set_no_entry_b()
         
      AFTER FIELD icg06
         IF NOT cl_null(g_icg[l_ac].icg06) THEN
            IF g_icg[l_ac].icg06 < 0 THEN
               CALL cl_err(g_icg[l_ac].icg06,'aic-005',1)
               LET g_icg[l_ac].icg06 = g_icg_t.icg06
               DISPLAY BY NAME g_icg[l_ac].icg06
               NEXT FIELD icg06
            END IF
            CALL i006_icg24()
	          DISPLAY BY NAME g_icg[l_ac].icg24
         END IF 
      
      AFTER FIELD icg07
         IF NOT cl_null(g_icg[l_ac].icg07) THEN
            IF g_icg[l_ac].icg07 < 0 THEN
               CALL cl_err(g_icg[l_ac].icg07,'aic-005',1)
               LET g_icg[l_ac].icg07 = g_icg_t.icg07
               DISPLAY BY NAME g_icg[l_ac].icg07
               NEXT FIELD icg07
            END IF
            CALL i006_icg24()
	          DISPLAY BY NAME g_icg[l_ac].icg24
         END IF
         
      AFTER FIELD icg08
         IF NOT cl_null(g_icg[l_ac].icg08) THEN
            IF g_icg[l_ac].icg08 < 0 THEN
               CALL cl_err(g_icg[l_ac].icg08,'aic-005',1)
               LET g_icg[l_ac].icg08 = g_icg_t.icg08
               DISPLAY BY NAME g_icg[l_ac].icg08
               NEXT FIELD icg08
            END IF
            CALL i006_icg24()
	          DISPLAY BY NAME g_icg[l_ac].icg24
         END IF
      
      AFTER FIELD icg09
         IF NOT cl_null(g_icg[l_ac].icg09) THEN
            IF g_icg[l_ac].icg09 < 0 THEN
               CALL cl_err(g_icg[l_ac].icg09,'aic-005',1)
               LET g_icg[l_ac].icg09 = g_icg_t.icg09
               DISPLAY BY NAME g_icg[l_ac].icg09
               NEXT FIELD icg09
            END IF
            CALL i006_icg24()
	          DISPLAY BY NAME g_icg[l_ac].icg24
         END IF                    
      
      AFTER FIELD icg10
         IF NOT cl_null(g_icg[l_ac].icg10) THEN
            IF g_icg[l_ac].icg10 < 0 THEN
               CALL cl_err(g_icg[l_ac].icg10,'aic-005',1)
               LET g_icg[l_ac].icg10 = g_icg_t.icg10
               DISPLAY BY NAME g_icg[l_ac].icg10
               NEXT FIELD icg10
            END IF
            CALL i006_icg24()
	          DISPLAY BY NAME g_icg[l_ac].icg24
         END IF
      
      AFTER FIELD icg11
         IF NOT cl_null(g_icg[l_ac].icg11) THEN
            IF g_icg[l_ac].icg11 <= 0 THEN
               CALL cl_err(g_icg[l_ac].icg11,'aic-005',1)
               LET g_icg[l_ac].icg11 = g_icg_t.icg11
               DISPLAY BY NAME g_icg[l_ac].icg11
               NEXT FIELD icg11
            END IF
            CALL i006_icg24()
	          DISPLAY BY NAME g_icg[l_ac].icg24
         END IF
      
      AFTER FIELD icg23
         IF NOT cl_null(g_icg[l_ac].icg23) THEN
            IF g_icg[l_ac].icg23 < 0 THEN
               CALL cl_err(g_icg[l_ac].icg23,'aic-005',1)
               LET g_icg[l_ac].icg23 = g_icg_t.icg23
               DISPLAY BY NAME g_icg[l_ac].icg23
               NEXT FIELD icg23
            END IF
            CALL i006_icg24()
	          DISPLAY BY NAME g_icg[l_ac].icg24
         END IF
      
      BEFORE FIELD icg24
#        CALL i006_move_back()
#        INSERT INTO icg_file VALUES (b_icg.*)
#          LET g_rec_b = g_rec_b + 1
         CALL i006_icg24()
         DISPLAY BY NAME g_icg[l_ac].icg24
	       
      AFTER FIELD icg24
         IF NOT cl_null(g_icg[l_ac].icg24) THEN
            IF g_icg[l_ac].icg24 <= 0 THEN
               CALL cl_err(g_icg[l_ac].icg24,'aic-005',1)
               LET g_icg[l_ac].icg24 = g_icg_t.icg24
               DISPLAY BY NAME g_icg[l_ac].icg24
               NEXT FIELD icg24
            END IF
         END IF
      
      AFTER FIELD icg05
         IF NOT cl_null(g_icg[l_ac].icg05) THEN
            CALL i006_icg05()
            IF NOT cl_null(g_errno) THEN
               LET g_icg[l_ac].icg05 = g_icg_t.icg05
               NEXT FIELD icg05
            END IF
         END IF
            
      AFTER FIELD icg25
         IF NOT cl_null(g_icg[l_ac].icg25) THEN
            IF g_icg[l_ac].icg25 < 0 THEN
               CALL cl_err(g_icg[l_ac].icg25,'aic-005',1)
               LET g_icg[l_ac].icg25 = g_icg_t.icg25
               DISPLAY BY NAME g_icg[l_ac].icg25
               NEXT FIELD icg25
            END IF
         END IF
         
      AFTER FIELD icg26
         IF NOT cl_null(g_icg[l_ac].icg26) THEN
            IF g_icg[l_ac].icg26 < 0 THEN
               CALL cl_err(g_icg[l_ac].icg26,'aic-005',1)
               LET g_icg[l_ac].icg26 = g_icg_t.icg26
               DISPLAY BY NAME g_icg[l_ac].icg26
               NEXT FIELD icg26
            END IF
         END IF
         
      AFTER FIELD icg27
         IF NOT cl_null(g_icg[l_ac].icg27) THEN
            IF g_icg[l_ac].icg27 < 0 THEN
               CALL cl_err(g_icg[l_ac].icg27,'aic-005',1)
               LET g_icg[l_ac].icg27 = g_icg_t.icg27
               DISPLAY BY NAME g_icg[l_ac].icg27
               NEXT FIELD icg27
            END IF
         END IF
         
      AFTER FIELD icg13
         IF NOT cl_null(g_icg[l_ac].icg13) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM azi_file
             WHERE azi01 = g_icg[l_ac].icg13
               AND aziacti = 'Y'
            IF l_n = 0 THEN
               CALL cl_err(g_icg[l_ac].icg13,'aic-006',1)
               LET g_icg[l_ac].icg13 = g_icg_t.icg13
               NEXT FIELD icg13
            END IF
         END IF
    
      BEFORE DELETE
         DISPLAY 'BEFORE DELETE!'
         IF NOT cl_null(g_icg_t.icg03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            
            DELETE FROM icg_file WHERE icg01 = g_icg01
                                   AND icg02 = g_icg_t.icg02
                                   AND icg03 = g_icg_t.icg03
                                   AND icg04 = g_icg_t.icg04
 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err(g_icg_t.icg03,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK                                                                  
                                                                                
      ON ROW CHANGE                                                             
         IF INT_FLAG THEN                                                       
            CALL cl_err('',9001,0)                                              
            LET INT_FLAG = 0                                                    
            LET g_icg[l_ac].* = g_icg_t.*                                       
            CLOSE i006_cl             
         ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF                                                                 
         IF l_lock_sw = 'Y' THEN                                                
            CALL cl_err(g_icg[l_ac].icg03,-263,1)                               
            LET g_icg[l_ac].* = g_icg_t.*
                                                   
         ELSE
            IF cl_null(g_icg[l_ac].icg04) THEN LET g_icg[l_ac].icg04 = ' ' END IF  #FUN-920096
            UPDATE icg_file SET icg03 = g_icg[l_ac].icg03,
                                icg04 = g_icg[l_ac].icg04,
                                icg02 = g_icg[l_ac].icg02,
                                icg28 = g_icg[l_ac].icg28,
                                icg16 = g_icg[l_ac].icg16,
                                icg17 = g_icg[l_ac].icg17,
                                icg18 = g_icg[l_ac].icg18,
                                icg19 = g_icg[l_ac].icg19,
                                icg20 = g_icg[l_ac].icg20,
                                icg06 = g_icg[l_ac].icg06,
                                icg07 = g_icg[l_ac].icg07,
                                icg08 = g_icg[l_ac].icg08,
                                icg09 = g_icg[l_ac].icg09,
                                icg10 = g_icg[l_ac].icg10,
                                icg11 = g_icg[l_ac].icg11,
                                icg23 = g_icg[l_ac].icg23,
                                icg24 = g_icg[l_ac].icg24,
                                icg05 = g_icg[l_ac].icg05,
                                icg25 = g_icg[l_ac].icg25,
                                icg26 = g_icg[l_ac].icg26,
                                icg27 = g_icg[l_ac].icg27,
                                icg12 = g_icg[l_ac].icg12,
                                icg13 = g_icg[l_ac].icg13,
                           #    icg14 = g_icg[l_ac].icg14,
                           #    icg15 = g_icg[l_ac].icg15,
                                icgmodu = g_user,
                                icgdate = g_today 
                          WHERE icg01 = g_icg01
                            AND icg02 = g_icg_t.icg02
                            AND icg03 = g_icg_t.icg03
                            AND icg04 = g_icg_t.icg04
         IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","icg_file",g_icg01,g_icg[l_ac].icg03,SQLCA.sqlcode,"","",0)
               LET g_icg[l_ac].* = g_icg_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
         AFTER ROW 
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac #FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_icg[l_ac].* = g_icg_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_icg.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE i006_cl                                                       
            ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF    
         LET l_ac_t = l_ac #FUN-D40030  add
         CLOSE i006_cl                                                          
         COMMIT WORK                                                            
      
      ON ACTION CONTROLO                                                             
         IF INFIELD(icg03) AND l_ac > 1 THEN                                                                                      
            LET g_icg[l_ac].* = g_icg[l_ac-1].*                                                                                     
            NEXT FIELD icg03                                                                                                      
         END IF
         
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(icg03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc"
               LET g_qryparam.default1 = g_icg[l_ac].icg03
               CALL cl_create_qry() RETURNING g_icg[l_ac].icg03
               DISPLAY g_icg[l_ac].icg03 TO s_icg[l_ac].icg03
               CALL i006_icg03('d')
               NEXT FIELD icg03
            WHEN INFIELD(icg02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ecd02_icd"
               LET g_qryparam.default1 = g_icg[l_ac].icg02
               CALL cl_create_qry() RETURNING g_icg[l_ac].icg02
               DISPLAY g_icg[l_ac].icg02 TO s_icg[l_ac].icg02
               CALL i006_icg02('d')
               NEXT FIELD icg02
            WHEN INFIELD(icg28)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ich"
               LET g_qryparam.default1 = g_icg[l_ac].icg28
               CALL cl_create_qry() RETURNING g_icg[l_ac].icg28
               DISPLAY g_icg[l_ac].icg28 TO s_icg[l_ac].icg28
               NEXT FIELD icg28
            WHEN INFIELD(icg13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_icg[l_ac].icg13
               CALL cl_create_qry() RETURNING g_icg[l_ac].icg13
               DISPLAY g_icg[l_ac].icg13 TO s_icg[l_ac].icg13
               CALL i006_icg13('d')
               NEXT FIELD icg13                                                                                
         END CASE
      ON ACTION CONTROLR                                                        
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
                                                                                
   CLOSE i006_cl                                                                
   COMMIT WORK                                                                  
   CALL i006_delall()
                                                                                
END FUNCTION 
FUNCTION i006_delall()
    SELECT COUNT(*) INTO g_cnt  FROM icg_file
          WHERE icg01=g_icg01
    
    IF g_cnt=0 THEN
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
   END IF
 
END FUNCTION
 
FUNCTION i006_b_fill(p_wc)              #BODY FILL UP                           
                                                                                
   DEFINE 
       #p_wc  LIKE type_file.chr1000  
       p_wc   STRING     #NO.FUN-910082         
                                                                                
   LET g_sql = "SELECT icg03,'',icg04,icg02,'',",
               "       icg28,icg16,icg17,icg18,icg19,icg20,",
               "       icg06,icg07,icg08,icg09,icg10,icg11,",
               "       icg23,icg24,icg05,icg25,icg26,icg27,",
               "       icg12,icg13 ",
               #icg14,icg15 
               "  FROM icg_file ",
               " WHERE icg01 = '",g_icg01 CLIPPED,"' ", 
               " ORDER BY icg03"                                   
   PREPARE i006_prepare2 FROM g_sql      #預備一下                              
   DECLARE icg_cs CURSOR FOR i006_prepare2                                      
                                                                                
   CALL g_icg.clear()                                                           
   LET g_cnt = 1                                                                
   LET g_rec_b=0                                                                
                                                                                
   FOREACH icg_cs INTO g_icg[g_cnt].*   #單身 ARRAY 填充                        
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                                
         EXIT FOREACH                                                           
      END IF
      SELECT pmc03 INTO g_icg[g_cnt].pmc03 FROM pmc_file WHERE pmc01 = g_icg[g_cnt].icg03
      SELECT ecd02 INTO g_icg[g_cnt].ecd02 FROM ecd_file WHERE ecd01 = g_icg[g_cnt].icg02                                                                 
      LET g_cnt = g_cnt + 1                                                     
      IF g_cnt > g_max_rec THEN 
         CALL cl_err('',9035,0)                                                 
         EXIT FOREACH                                                           
      END IF                                                                    
   END FOREACH                                                                  
   CALL g_icg.deleteElement(g_cnt)                                              
                                                                                
   LET g_rec_b = g_cnt - 1                                                      
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0                                                                
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i006_bp(p_ud)                                                          
    DEFINE p_ud            LIKE type_file.chr1
  
    IF p_ud <> "G" OR g_action_choice = "detail" THEN                           
        RETURN                                                                  
    END IF                                                                      
                                                                                
    LET g_action_choice = " "                                                   
   DISPLAY g_icg01 TO icg01               #單頭                                 
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                             
   DISPLAY ARRAY g_icg TO s_icg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)          
                                                                                
        BEFORE DISPLAY                                                          
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
                                                                                
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
 
#        ON ACTION modify                                                        
#           LET g_action_choice="modify"                                         
#           EXIT DISPLAY                                                         
        
        ON ACTION output                                                          
           LET g_action_choice="output"                                           
           EXIT DISPLAY
                                                                                 
        ON ACTION detail                                                        
           LET g_action_choice="detail"                                         
           LET l_ac = 1                                                         
           EXIT DISPLAY                                                         
        
        ON ACTION reproduce                                                         
         LET g_action_choice="reproduce"                                          
         EXIT DISPLAY 
                                                                                 
        ON ACTION help                                                          
           LET g_action_choice="help"                                           
           EXIT DISPLAY                                                         
                                                                                
        ON ACTION locale                                                        
           CALL cl_dynamic_locale()                                             
           CALL cl_show_fld_cont()                                               
           EXIT DISPLAY
#       ON ACTION invalid
#        LET g_action_choice="invalid"
#        EXIT DISPLAY
 
#        ON ACTION output                                                        
#          LET g_action_choice="output"                                         
#          EXIT DISPLAY                                                         
                                                                                
        ON ACTION exporttoexcel                                                 
         LET g_action_choice = 'exporttoexcel'                                  
         EXIT DISPLAY                                                           
                                                                                
        ON ACTION exit                                                          
           LET g_action_choice="exit"                                           
           EXIT DISPLAY                                                         
                                                                                
        ON ACTION accept                                                        
           LET g_action_choice="detail"                                         
           LET l_ac = ARR_CURR()                                                
           EXIT DISPLAY                                                         
                                                                                
        ON ACTION cancel                                                        
           LET INT_FLAG=FALSE                                                 
           LET g_action_choice="exit"                                           
           EXIT DISPLAY
 
        ON ACTION first                                                         
           CALL i006_fetch('F')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
           ACCEPT DISPLAY                                                       
                                                                                
        ON ACTION previous                                                      
           CALL i006_fetch('P')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
        ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION jump                                                          
           CALL i006_fetch('/')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF 
           ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION next                                                          
           CALL i006_fetch('N')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
        ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION last                                                          
           CALL i006_fetch('L')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
        ACCEPT DISPLAY                                                          
                                                                                
        ON IDLE g_idle_seconds                                                  
           CALL cl_on_idle()                                                    
           CONTINUE DISPLAY                                                     
                                                                                
      ON ACTION about
          CALL cl_about()                                                        
                                                                                
      ON ACTION controlg                                                        
         CALL cl_cmdask()                                                       
     
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY                                                                          
      AFTER DISPLAY                                                             
         CONTINUE DISPLAY                                                       
                                                                                
    END DISPLAY                                                                 
    CALL cl_set_act_visible("accept,cancel", TRUE)                              
                                                                                
END FUNCTION  
 
FUNCTION i006_icg01(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_ima02   LIKE ima_file.ima02,                                       
           l_imaacti LIKE ima_file.imaacti                                      
   LET g_errno=' '                                                              
   SELECT ima02,imaacti INTO l_ima02,l_imaacti  FROM ima_file                   
         WHERE ima01=g_icg01                                                
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                         
        WHEN l_imaacti='N'        LET g_errno='9028'                            
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       DISPLAY l_ima02 TO FORMONLY.ima02
   END IF                                                                       
END FUNCTION
 
FUNCTION i006_icg03(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_pmc03   LIKE pmc_file.pmc01,                                       
           l_pmcacti LIKE pmc_file.pmcacti                                      
   LET g_errno=' '                                                              
   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti  FROM pmc_file                   
         WHERE pmc01=g_icg[l_ac].icg03                                                
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                         
        WHEN l_pmcacti='N'        LET g_errno='9028'                            
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
      LET g_icg[l_ac].pmc03=l_pmc03
   END IF                                                                       
END FUNCTION
 
FUNCTION i006_icg02(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_ecd02   LIKE ecd_file.ecd02,                                       
           l_ecdacti LIKE ecd_file.ecdacti                                      
   LET g_errno=' '                                                              
   SELECT ecd02,ecdacti INTO l_ecd02,l_ecdacti  FROM ecd_file                   
         WHERE ecd01=g_icg[l_ac].icg02                                          
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                         
        WHEN l_ecdacti='N'        LET g_errno='9028'                            
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       LET g_icg[l_ac].ecd02=l_ecd02                                         
   END IF                                                                       
END FUNCTION
 
FUNCTION i006_icg13(p_cmd)  #幣別
   DEFINE   p_cmd       LIKE type_file.chr1, 
            l_azi02     LIKE azi_file.azi02,
            l_aziacti   LIKE azi_file.aziacti
 
   LET g_errno = ' '
   SELECT aziacti,azi02
     INTO l_aziacti,l_azi02
     FROM azi_file WHERE azi01=g_icg[l_ac].icg13
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_aziacti = NULL
                                  LET l_azi02 = NULL
                                  DISPLAY l_azi02 TO azi02
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_azi02 TO azi02
   END IF
 
END FUNCTION
 
FUNCTION i006_copy()
   DEFINE   l_n       LIKE type_file.num5,                                                                                                     
            l_newno   LIKE icg_file.icg01,                                                                                   
            l_oldno   LIKE icg_file.icg01                                                                                    
                                                                                                                                    
   IF s_shut(0) THEN                                                               
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   IF cl_null(g_icg01) THEN                                                                                                     
      CALL cl_err('',-400,0)                                                                                                        
      RETURN                                                                                                                        
   END IF                                                                                                                           
    
   LET g_before_input_done = FALSE
   DISPLAY ' ' TO FORMONLY.ima02  
                                                                                                                                  
   INPUT l_newno WITHOUT DEFAULTS FROM icg01                                                                                    
                                                                                                                                    
   AFTER INPUT                                                                                                                   
     IF INT_FLAG THEN                                                                                                           
        EXIT INPUT                                                                                                              
     END IF
     
   IF cl_null(l_newno) THEN                                                                                                   
      NEXT FIELD icg01                                                                                                    
   END IF                                                                                                                     
   LET l_n =0                                                                                                                 
   SELECT COUNT(*) INTO l_n FROM ima_file                                                                                     
    WHERE ima01 = l_newno                                                                                                     
      AND imaacti= 'Y'                                                                                                        
                                                                                                                              
   IF l_n = 0 THEN                                                                                                            
      CALL cl_err(l_newno,'mfg3403',1)                                                                                        
      NEXT FIELD icg01                                                                                                    
   END IF                                                                                                                     
                                                                                                                              
   LET l_n =0                                                                                                                 
   SELECT COUNT(*) INTO l_n FROM icg_file                                                                                  
    WHERE icg01 = l_newno                                                                                                 
                                                                                                                              
   IF l_n > 0 THEN                                                                                                            
      CALL cl_err(l_newno,-239,0)                                                                                             
      NEXT FIELD icg01                                                                                                    
   END IF 
   
   ON ACTION controlp                                                                                                            
      CASE                                                                                                                       
         WHEN INFIELD(icg01)                                                                                                 
#FUN-AA0059 --Begin--
          #  CALL cl_init_qry_var()                                                                                               
          #  LET g_qryparam.form = "q_ima"                                                                                        
          #  LET g_qryparam.default1= l_newno                                                                                     
          #  CALL cl_create_qry() RETURNING l_newno                                                                               
            CALL q_sel_ima(FALSE, "q_ima", "", l_newno, "", "", "", "" ,"",'' )  RETURNING l_newno
#FUN-AA0059 --End--
            NEXT FIELD icg01                                                                                                 
         OTHERWISE                                                                                                               
            EXIT CASE                                                                                                            
      END CASE                                                                                                                   
                                                                                                                                 
   ON IDLE g_idle_seconds                                                                                                        
      CALL cl_on_idle()                                                                                                          
      CONTINUE INPUT                                                                                                             
                                                                                                                                 
   ON ACTION help                                                                                                                
      CALL cl_show_help()                                                                                                        
                                                                                                                                 
   ON ACTION controlg                                                                                                            
      CALL cl_cmdask()                                                                                                           
                                                                                                                                 
   ON ACTION about
      CALL cl_about()                                                                                                            
                                                                                                                                    
   END INPUT                                                                                                                        
                                                                                                                                    
   IF INT_FLAG THEN                                                                                                                 
      LET INT_FLAG = 0                                                                                                              
      DISPLAY g_icg01 TO icg01                                                                                              
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   DROP TABLE x                                                                                                                     
                                                                                                                                    
   SELECT * FROM icg_file                                                                                                        
    WHERE icg01=g_icg01                                                                                                     
     INTO TEMP x                                                                                                                    
                                                                                                                                    
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                                                                                      
      CALL cl_err(g_icg01,SQLCA.sqlcode,0)                                                                                      
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   UPDATE x                                                                                                                         
      SET icg01 = l_newno, 
          icguser = g_user,
          icggrup = g_grup,
          icgmodu = '', 
          icgdate = g_today,                                                            
          icgacti = 'Y'                                                                  
                                                                                                                                    
   INSERT INTO icg_file SELECT * FROM x                                                                                          
                                                                                                                                    
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN                                                                                      
      CALL cl_err('icg:',SQLCA.SQLCODE,0)                                                                                        
      RETURN                                                                                                                        
   END IF                                                                                                                           
   LET g_cnt = SQLCA.SQLERRD[3]                                                                                                     
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'                                                                       
                                                                                                                                    
   LET l_oldno = g_icg01                                                                                                        
   LET g_icg01 = l_newno                                                                                                        
   CALL i006_b()                                                                                                                    
   #LET g_icg01 = l_oldno  #FUN-C30027                                                                                                      
   #CALL i006_show()       #FUN-C30027
END FUNCTION	
 
FUNCTION i006_out()
  DEFINE l_cmd  LIKE type_file.chr1000   
 
     IF cl_null(g_wc) AND NOT cl_null(g_icg01) THEN                         
        LET g_wc = " icg01 = '",g_icg01,"'"                                 
     END IF                                                                     
     IF g_wc IS NULL THEN                                                       
        CALL cl_err('','9057',0)                                                
        RETURN                                                                  
     END IF                                                                     
     LET l_cmd = 'p_query "aici006" "',g_wc CLIPPED,'"'                         
     CALL cl_cmdrun(l_cmd)      
END FUNCTION
 
FUNCTION i006_icg24()
  DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
  DEFINE l_icg24    LIKE icg_file.icg24
 
 
   SELECT ecdicd01 INTO l_ecdicd01 
     FROM ecd_file
    WHERE ecd01 = g_icg[l_ac].icg02
 
   IF l_ecdicd01 = '2' OR l_ecdicd01 = '5' THEN
   
 
      UPDATE icg_file SET icg04 = ' '
             WHERE icg01 = g_icg01 
               AND icg02 = g_icg[l_ac].icg02
               AND icg03 = g_icg[l_ac].icg03 
   	          AND icg04 IS NULL
   
      UPDATE icg_file 
         SET icg28 = g_icg[l_ac].icg28,
             icg06 = g_icg[l_ac].icg06,
             icg07 = g_icg[l_ac].icg07,
   			    icg11 = g_icg[l_ac].icg11,
   			    icg23 = g_icg[l_ac].icg23,
   			    icg10 = g_icg[l_ac].icg10,
   			    icg08 = g_icg[l_ac].icg08,
   			    icg09 = g_icg[l_ac].icg09
       WHERE icg01 = g_icg01 
         AND icg02 = g_icg[l_ac].icg02
         AND icg03 = g_icg[l_ac].icg03
         AND icg04 = g_icg[l_ac].icg04
   
    
      #CHI-920075--BEGIN--
      IF cl_null(g_icg[l_ac].icg04) THEN LET g_icg[l_ac].icg04=' ' END IF
      LET g_icg[l_ac].icg24 = s_defprice_icd1(g_icg01,g_icg[l_ac].icg02,g_icg[l_ac].icg03,g_icg[l_ac].icg04)
      #CHI-920075--END--
      IF l_ecdicd01 = '2' THEN
         LET l_icg24 =  cl_digcut (g_icg[l_ac].icg24,0)
         LET g_icg[l_ac].icg24 = l_icg24
         DISPLAY BY NAME g_icg[l_ac].icg24
      END IF
   
      IF l_ecdicd01 = '5' THEN
         LET g_icg[l_ac].icg24 =  cl_digcut (g_icg[l_ac].icg24,2)
         DISPLAY BY NAME g_icg[l_ac].icg24
      END IF
   END IF
END FUNCTION
 
FUNCTION i006_icg05()
    DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
 
    SELECT ecdicd01 INTO l_ecdicd01 
      FROM ecd_file
     WHERE ecd01 = g_icg[l_ac].icg02
 
   LET g_errno = ''
   IF cl_null(g_icg[l_ac].icg05) OR 
      g_icg[l_ac].icg05 < 0 THEN
      LET g_errno = 'aic-208'
      CALL cl_err('',g_errno,1)
      RETURN
   END IF
   LET g_errno = ''
   IF l_ecdicd01 = '2' THEN 
      IF g_icg[l_ac].icg05 > g_icg[l_ac].icg24 + 40 THEN
         LET g_errno = 'aic-209'
         CALL cl_err('',g_errno,1)
         RETURN
      END IF
   ELSE
      IF l_ecdicd01 = '5' THEN 
         IF g_icg[l_ac].icg05 > g_icg[l_ac].icg24 + 0.4 THEN
            LET g_errno = 'aic-209'
            CALL cl_err('',g_errno,1)
            RETURN
         END IF
      ELSE
         IF g_icg[l_ac].icg05 > g_icg[l_ac].icg24  THEN
            LET g_errno = 'aic-209'
            CALL cl_err('',g_errno,1)
            RETURN
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION i006_move_to()
    LET b_icg.icg03 = g_icg[l_ac].icg03
    LET b_icg.icg04 = g_icg[l_ac].icg04
    LET b_icg.icg02 = g_icg[l_ac].icg02
    LET b_icg.icg28 = g_icg[l_ac].icg28
    LET b_icg.icg16 = g_icg[l_ac].icg16
    LET b_icg.icg17 = g_icg[l_ac].icg17
    LET b_icg.icg18 = g_icg[l_ac].icg18
    LET b_icg.icg19 = g_icg[l_ac].icg19
    LET b_icg.icg20 = g_icg[l_ac].icg20
    LET b_icg.icg06 = g_icg[l_ac].icg06
    LET b_icg.icg07 = g_icg[l_ac].icg07
    LET b_icg.icg08 = g_icg[l_ac].icg08
    LET b_icg.icg09 = g_icg[l_ac].icg09
    LET b_icg.icg10 = g_icg[l_ac].icg10
    LET b_icg.icg11 = g_icg[l_ac].icg11
    LET b_icg.icg23 = g_icg[l_ac].icg23
    LET b_icg.icg24 = g_icg[l_ac].icg24
    LET b_icg.icg05 = g_icg[l_ac].icg05
    LET b_icg.icg25 = g_icg[l_ac].icg25
    LET b_icg.icg26 = g_icg[l_ac].icg26
    LET b_icg.icg27 = g_icg[l_ac].icg27
    LET b_icg.icg12 = g_icg[l_ac].icg12
    LET b_icg.icg13 = g_icg[l_ac].icg13
#   LET b_icg.icg14 = g_icg[l_ac].icg14
#   LET b_icg.icg15 = g_icg[l_ac].icg15
END FUNCTION
 
FUNCTION i006_move_back()
    LET b_icg.icg03 = g_icg[l_ac].icg03
    LET b_icg.icg04 = g_icg[l_ac].icg04
    LET b_icg.icg02 = g_icg[l_ac].icg02
    LET b_icg.icg28 = g_icg[l_ac].icg28
    LET b_icg.icg16 = g_icg[l_ac].icg16
    LET b_icg.icg17 = g_icg[l_ac].icg17
    LET b_icg.icg18 = g_icg[l_ac].icg18
    LET b_icg.icg19 = g_icg[l_ac].icg19
    LET b_icg.icg20 = g_icg[l_ac].icg20
    LET b_icg.icg06 = g_icg[l_ac].icg06
    LET b_icg.icg07 = g_icg[l_ac].icg07
    LET b_icg.icg08 = g_icg[l_ac].icg08
    LET b_icg.icg09 = g_icg[l_ac].icg09
    LET b_icg.icg10 = g_icg[l_ac].icg10
    LET b_icg.icg11 = g_icg[l_ac].icg11
    LET b_icg.icg23 = g_icg[l_ac].icg23
    LET b_icg.icg24 = g_icg[l_ac].icg24
    LET b_icg.icg05 = g_icg[l_ac].icg05
    LET b_icg.icg25 = g_icg[l_ac].icg25
    LET b_icg.icg26 = g_icg[l_ac].icg26
    LET b_icg.icg27 = g_icg[l_ac].icg27
    LET b_icg.icg12 = g_icg[l_ac].icg12
    LET b_icg.icg13 = g_icg[l_ac].icg13
#   LET b_icg.icg14 = g_icg[l_ac].icg14
#   LET b_icg.icg15 = g_icg[l_ac].icg15
END FUNCTION
 
FUNCTION i006_set_entry_b()
   CALL cl_set_comp_entry("icg17",TRUE)
END FUNCTION
 
FUNCTION i006_set_no_entry_b()
   IF g_icg[l_ac].icg16 = 'Y' THEN
      CALL cl_set_comp_entry("icg17",FALSE)
   END IF
END FUNCTION   
#No.FUN-7B0029
