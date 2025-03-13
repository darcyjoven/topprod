# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: apmi302.4gl                                                  
# Descriptions...: 多屬性料收貨替代原則維護作業                                
# Date & Author..: No.FUN-810016 08/01/14 By ve007
# Modify.........: No.FUN-830121 08/03/31 By ve007 debug 810016
# Modify.........: No.FUN-840178 08/04/23 By ve007 pmv04(屬性值)的值可為空
# Modify.........: No.FUN-870124  by jan
# Modify.........: No.FUN-870117  by ve007  修改供應廠商錄入的問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0139 09/12/17 By Carrier lock时,拿掉outer的table
# Modify.........: No.TQC-960303 10/03/09 By huangrh 有打印按钮，无打印功能
# Modify.........: No.FUN-AA0059 10/10/25 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80088 11/08/09 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds                                                                     
                                                                                
GLOBALS "../../config/top.global"                                               
                                                                                
DEFINE
    g_pmv01          LIKE pmv_file.pmv01,
    g_pmv01_t        LIKE pmv_file.pmv01,
    g_pmv02          LIKE pmv_file.pmv02,
    g_pmv02_t        LIKE pmv_file.pmv02,
    g_pmv06          LIKE pmv_file.pmv06,
    g_pmv06_t        LIKE pmv_file.pmv06,
    g_pmv            DYNAMIC ARRAY OF RECORD
                     pmv03        LIKE pmv_file.pmv03,
                     agc02        LIKE agc_file.agc02,
                     pmv04        LIKE pmv_file.pmv04,
                     pmv07        LIKE pmv_file.pmv07,
                     pmv05        LIKE pmv_file.pmv05,
                     pmv08        LIKE pmv_file.pmv08,
                     pmv09        LIKE pmv_file.pmv09,
                     pmv10        LIKE pmv_file.pmv10
                     END RECORD,
    g_pmv_t          RECORD
                     pmv03        LIKE pmv_file.pmv03,
                     agc02        LIKE agc_file.agc02,
                     pmv04        LIKE pmv_file.pmv04,
                     pmv07        LIKE pmv_file.pmv07,
                     pmv05        LIKE pmv_file.pmv05,
                     pmv08        LIKE pmv_file.pmv08,
                     pmv09        LIKE pmv_file.pmv09,
                     pmv10        LIKE pmv_file.pmv10
                     END RECORD,                  
    g_wc                STRING,                                                 
    g_wc2               STRING,                                                 
    g_sql               STRING,                                                 
    g_rec_b             LIKE type_file.num5,         #蟲  撣計                  
    g_succ              LIKE type_file.chr1,                                    
    l_ac                LIKE type_file.num5          #л e B z﹕ARRAY CNT
DEFINE   g_forupd_sql   STRING                       #SELECT ... FOR UPDATE NOWe
DEFINE   g_before_input_done  LIKE type_file.num5                               
DEFINE   g_cnt          LIKE type_file.num10                                    
DEFINE   g_i            LIKE type_file.num5
DEFINE   g_msg          LIKE type_file.chr1000                                  
DEFINE   g_curs_index   LIKE type_file.num10                                    
DEFINE   g_row_count    LIKE type_file.num10                                    
DEFINE   g_jump         LIKE type_file.num10                                    
DEFINE   mi_no_ask      LIKE type_file.num5 
 
MAIN                                                                            
   DEFINE p_row,p_col   LIKE type_file.num5    
   DEFINE l_sma124      LIKE sma_file.sma124                                 
                                                                                
   OPTIONS                                           #�跑 @ㄇ t參 w ]          
      INPUT NO WRAP
   DEFER INTERRUPT                                   # ^  ゆ _齡, е {Α B z 
 
   IF (NOT cl_user()) THEN                                                      
      EXIT PROGRAM                                                              
   END IF                                                                       
                                                                                
   WHENEVER ERROR CALL cl_err_msg_log                                           
                                                                                
   IF (NOT cl_setup("apm")) THEN                                                
      EXIT PROGRAM                                                              
   END IF
   
   CALL  cl_used(g_prog,g_time,1)       # p衡ㄏв  丁 ( i J  丁)              
         RETURNING g_time                                                       
   LET g_pmv01 = NULL                     # M埃齡                               
   LET g_pmv01_t = NULL
 
   LET p_row = 5 LET p_col = 25                                                 
   OPEN WINDOW i302_w AT p_row,p_col WITH FORM "apm/42f/apmi302"                
   ATTRIBUTE (STYLE = g_win_style CLIPPED)                                      
                                                                                
   CALL cl_ui_init()
 
    CALL i302_menu()                                                             
                                                                                
   CLOSE WINDOW i302_w                    #擋   e                               
     CALL  cl_used(g_prog,g_time,2)       # p衡ㄏв  丁 ( h Xㄏ丁)              
         RETURNING g_time                                                       
END MAIN 
 
FUNCTION i302_cs()                                                              
                                                                                
   CLEAR FORM                             # M埃 e                               
   LET g_pmv01=NULL                                                             
   CALL g_pmv.clear()                                                           
                                                                                
      CONSTRUCT  g_wc ON pmv01,pmv02,pmv06,pmv09,pmv10
                    FROM pmv01,pmv02,pmv06,s_pmv[1].pmv09,s_pmv[1].pmv10                                     
                                                                                
         ON ACTION controlp                                                     
            CASE                                                                
               WHEN INFIELD(pmv01)                                              
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()                                        
                #  LET g_qryparam.form ="q_pmv01"                                  
                #  LET g_qryparam.state ="c"                                     
                #  LET g_qryparam.default1 = g_pmv01                             
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_pmv01","",g_pmv01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO pmv01 
                  NEXT FIELD pmv01                                                                
               WHEN INFIELD(pmv02)                                              
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form ="q_pmv02"                                  
                  LET g_qryparam.state ="c"                                     
                  LET g_qryparam.default1 = g_pmv02                             
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmv02 
                  NEXT FIELD pmv02                               
            END CASE
   
         ON IDLE g_idle_seconds                                                 
            CALL cl_on_idle()                                                   
            CONTINUE CONSTRUCT                                                  
                                                                                
      ON ACTION about                                                           
         CALL cl_about()
 
      ON ACTION controlg                                                        
         CALL cl_cmdask()                                                       
                                                                                
     END CONSTRUCT                                                              
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
                                                                                
     IF INT_FLAG THEN RETURN END IF                                             
  
  MESSAGE ' WAIT '                                                              
                                                                                
  IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF                                 
                                                                                                                                       
      LET g_sql=" SELECT UNIQUE pmv01,pmv02,pmv06 FROM pmv_file",               
                " WHERE ",g_wc CLIPPED
  
  PREPARE i302_prepare FROM g_sql                                               
  DECLARE i302_cs                                                               
          SCROLL CURSOR WITH HOLD FOR i302_prepare
 
  #    X G兵⑦撣計
    LET g_sql=" SELECT COUNT(*) ",                              
              " FROM (select unique pmv01,pmv02,pmv06 from pmv_file) pmv_file ",
              " WHERE ",g_wc CLIPPED 
  
  PREPARE i302_pp FROM g_sql                                                    
  DECLARE i302_count   CURSOR FOR i302_pp
 
END FUNCTION                                                                    
                                                                                
FUNCTION i302_menu()                                                            
   WHILE TRUE                                                                   
     CALL i302_bp("G")                                                          
     CASE g_action_choice                                                       
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i302_q()                                                    
            END IF
 
         WHEN "insert"                                                        
            IF cl_chk_act_auth() THEN                                           
                CALL i302_a()                                                   
            END IF
 
         WHEN "modify"                                                        
            IF cl_chk_act_auth() THEN                                           
               CALL i302_u()                                                    
            END IF
           
          WHEN "delete"                                                        
            IF cl_chk_act_auth() THEN                                           
                CALL i302_r()                                                   
            END IF                                                              
                                                                                
         WHEN "detail"                                                        
            IF cl_chk_act_auth() THEN                                           
                CALL i302_b()                                                   
            ELSE 
               LET g_action_choice = NULL                                       
            END IF                                                               
                                                                                 
         WHEN "exporttoexcel"                                                 
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmv),'','')                                                             
            END IF
 
          {WHEN "output"                                                        
            IF cl_chk_act_auth()                                                
               THEN CALL i302_out()                                             
            END IF}                                                              
                                                                                
           WHEN "help"                                                          
            CALL cl_show_help()                                                 
                                                                                
           WHEN "exit"                                                          
            EXIT WHILE                                                          
                                                                                
           WHEN "controlg"                                                      
            CALL cl_cmdask()                                                    
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION
       
FUNCTION i302_a()                                                               
                                                                                
   MESSAGE ""                                                                   
   CLEAR FORM                                                                   
   CALL g_pmv.clear()
 
   IF s_shut(0) THEN RETURN END IF                #浪 d v  
 
   LET g_pmv01 = NULL                                                           
   LET g_pmv01_t = NULL
   LET g_pmv02 = NULL
   LET g_pmv06 = 'N'
   
   CALL cl_opmsg('a')                                                           
                                                                                
    WHILE TRUE                                                            
       CALL i302_i("a")                   #塊 J蟲 Y                             
       IF INT_FLAG THEN                   #ㄏв  ゅ   F                         
          LET INT_FLAG = 0                                                      
          CALL cl_err('',9001,0)                                                
          EXIT WHILE                                                            
       END IF                                                                   
       IF cl_null(g_pmv01) THEN                                                 
          CONTINUE WHILE                                                        
       END IF
       #No.FUN-870124--BEGIN--
       IF g_pmv06 = 'Y' THEN  
         INSERT INTO pmv_file(pmv01,pmv02,pmv06)
                     VALUES(g_pmv01,g_pmv02,g_pmv06)
          IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pmv_file",g_pmv01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
          END IF
       END IF
       #No.FUN-870124--END--               
       IF SQLCA.sqlcode THEN                                                    
          CALL cl_err(g_pmv01,SQLCA.sqlcode,1)   #No.FUN-B80088---上移一行調整至回滾事務前---                               
          ROLLBACK WORK                                                         
          CONTINUE WHILE                                                        
       ELSE                                                                     
          COMMIT WORK                                                           
       END IF
 
       CALL g_pmv.clear()                                                       
       LET g_rec_b = 0                                                          
       DISPLAY g_rec_b TO FORMONLY.cn2                                          
       IF g_pmv06 = 'N' THEN                 #No.FUN-870124                                                       
          CALL i302_b()                      #塊 J蟲
       END IF                                #No.FUN-870124
                                                                                
       LET g_pmv01_t = g_pmv01            # O d侶                               
       EXIT WHILE                                                               
    END WHILE                                                                   
    LET g_wc=' '                                                                
                                                                                
END FUNCTION
 
FUNCTION i302_u()
 
    IF cl_null(g_pmv01) THEN                                                     
      CALL cl_err('',-400,0)                                                    
      RETURN                                                                    
   END IF                                                                       
                                                                                
   MESSAGE ""                                                                   
   CALL cl_opmsg('u')                                                           
   LET g_pmv01_t = g_pmv01
   LET g_pmv02_t = g_pmv02
   LET g_pmv06_t = g_pmv06
 
   WHILE TRUE                                                                   
      CALL i302_i("u")                      #逆    �                           
                                                                                
      IF INT_FLAG THEN                                                          
         LET g_pmv01=g_pmv01_t
         LET g_pmv02=g_pmv02_t
         LET g_pmv06=g_pmv06_t                                                  
         DISPLAY g_pmv01 TO pmv01           #蟲 Y                               
         LET INT_FLAG = 0                                                       
         CALL cl_err('',9001,0)                                                 
         EXIT WHILE                                                             
      END IF 
                
         UPDATE pmv_file SET pmv01 = g_pmv01,
                             pmv02 = g_pmv02,
                             pmv06 = g_pmv06        #   sDB                     
          WHERE pmv01 = g_pmv01_t
            AND pmv02 = g_pmv02_t
            AND pmv06 = g_pmv06_t                   #COLAUTH?                   
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("upd","pmv_file",g_pmv01_t,"",SQLCA.sqlcode,"","",1)   
            CONTINUE WHILE                                                      
         END IF                                                                                                                                   
      EXIT WHILE                                                                
   END WHILE                                                                    
                                                                                
END FUNCTION
 
FUNCTION i302_i(p_cmd)                                                          
DEFINE                                                                          
   p_cmd           LIKE type_file.chr1,       #a:塊 J u:  �                    
   l_n             LIKE type_file.num5,                                          
   l_m             LIKE type_file.num5,
   l_pmc03         LIKE pmc_file.pmc03
                                                                               
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   DISPLAY  g_pmv01,g_pmv02,g_pmv06  TO pmv01,pmv02,pmv06
                                        
   INPUT  g_pmv01,g_pmv02,g_pmv06 WITHOUT DEFAULTS  FROM pmv01,pmv02,pmv06 
                      
      AFTER FIELD pmv01                       #場   s腹                         
         IF NOT cl_null(g_pmv01) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_pmv01,"") THEN
             CALL cl_err('',g_errno,1)
             LET g_pmv01=g_pmv01_t
             NEXT FIELD pmv01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
           IF p_cmd='a' OR(p_cmd='u' AND g_pmv01!=g_pmv01_t) THEN                                         
           SELECT count(*) INTO l_m FROM ima_file
              WHERE ima01= g_pmv01
              AND ima_file.imaacti='Y'
              AND ima_file.ima151='Y'
            IF l_m=0 THEN
               CALL cl_err(g_pmv01,'ask-008',0)
               NEXT FIELD pmv01
            END IF 
             SELECT COUNT(*) INTO l_m FROM pmv_file
              WHERE pmv01=g_pmv01
              AND   pmv02=g_pmv02
              AND   pmv06='Y'
            IF l_m>0 THEN
              CALL cl_err(g_pmv01,'apm-103',0)
              NEXT FIELD pmv01
            END IF
             CALL i302_pmv01('d')
           END IF   
         END IF
       
       AFTER FIELD pmv02                       #場   s腹                         
         IF NOT cl_null(g_pmv02) THEN
           IF p_cmd='a' OR(p_cmd='u' AND g_pmv02!=g_pmv02_t) THEN 
           IF  g_pmv02 != '*' THEN                           #NO.FUN-870117                         
           SELECT count(*) INTO l_m FROM pmc_file
              WHERE pmc01= g_pmv02
              AND pmc_file.pmcacti='Y'
              AND pmc_file.pmc05!='2'
              AND pmc_file.pmc30 IN ('1','3')
            IF l_m=0 THEN
               CALL cl_err(g_pmv01,'ask-008',0)
               NEXT FIELD pmv02
            END IF
            SELECT COUNT(*) INTO l_m FROM pmv_file
              WHERE pmv01=g_pmv01
              AND   pmv02=g_pmv02
              AND   pmv06='Y'
            IF l_m>0 THEN
              CALL cl_err(g_pmv02,'apm-103',0)
              NEXT FIELD pmv02
            END IF
           END IF                                         #No.FUN-870117
             CALL i302_pmv02('d')
           END IF 
         END IF   
            
       AFTER FIELD pmv06
         IF p_cmd='a' OR(p_cmd='u' AND g_pmv06!=g_pmv06_t) THEN 
           SELECT COUNT(*) INTO l_m FROM pmv_file
              WHERE pmv01=g_pmv01
              AND   pmv02=g_pmv02
              AND   pmv06='Y'
            IF l_m>0 THEN
              CALL cl_err('','apm-103',0)
              NEXT FIELD pmv06
            END IF
         END IF 
         
         
         
       ON ACTION controlp                                                        
         CASE                                                                   
            WHEN INFIELD(pmv01)                                                 
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()                                           
             #  LET g_qryparam.form ="q_pmv01"                                     
             #  LET g_qryparam.default1 = g_pmv01                                
             #  CALL cl_create_qry() RETURNING g_pmv01                           
               CALL q_sel_ima(FALSE, "q_pmv01", "", g_pmv01, "", "", "", "" ,"",'' )  RETURNING g_pmv01
#FUN-AA0059 --End--
               DISPLAY g_pmv01 TO pmv01 
               CALL i302_pmv01('d')
            WHEN INFIELD(pmv02)                                                 
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form ="q_pmv02"                                     
               LET g_qryparam.default1 = g_pmv02                                
               CALL cl_create_qry() RETURNING g_pmv02                           
               DISPLAY g_pmv02 TO pmv02 
               CALL i302_pmv02('d')                                            
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
                                                                                
FUNCTION i302_q()
   CALL cl_opmsg('q')                                                           
                                                                                
   LET g_row_count = 0                                                          
   LET g_curs_index = 0                                                         
   CALL cl_navigator_setting(g_curs_index,g_row_count)                          
                                                                                
   CALL i302_cs()                     #   o d高兵⑦                             
                                                                                
   IF INT_FLAG THEN                   #ㄏв  ゅ   F                             
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i302_count                                                              
   FETCH i302_count INTO g_row_count                                            
   DISPLAY g_row_count TO FORMONLY.cnt                                          
                                                                                
   OPEN i302_cs                        # qDB玻б X G兵⑦TEMP(0-30  )            
   IF SQLCA.sqlcode THEN               #Τ拜 D                                  
      CALL cl_err('',SQLCA.sqlcode,0)                                           
   ELSE                                                                         
      CALL i302_fetch('F')             #弄 XTEMP材 @撣 }陪п                    
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i302_fetch(p_flag)                                                     
DEFINE                                                                          
   p_flag      LIKE type_file.chr1,    # B zプΑ                                
   l_abso      LIKE type_file.num10    #蕩癸﹕撣計                              
                                                                                
   MESSAGE ""                                                                   
   CASE p_flag                                                                  
      WHEN 'N' FETCH NEXT     i302_cs INTO g_pmv01,g_pmv02,g_pmv06                      
      WHEN 'P' FETCH PREVIOUS i302_cs INTO g_pmv01,g_pmv02,g_pmv06                      
      WHEN 'F' FETCH FIRST    i302_cs INTO g_pmv01,g_pmv02,g_pmv06                      
      WHEN 'L' FETCH LAST     i302_cs INTO g_pmv01,g_pmv02,g_pmv06                     
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
         FETCH ABSOLUTE g_jump i302_cs INTO g_pmv01,g_pmv02,g_pmv06                             
         LET mi_no_ask = FALSE                                                  
   END CASE 
 
   LET g_succ='Y'                                                               
   IF SQLCA.sqlcode THEN                         #Τ陳沸                        
      CALL cl_err(g_pmv01,SQLCA.sqlcode,0)                                      
      INITIALIZE g_pmv01 TO NULL                                                
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
      CALL i302_show()                                                          
   END IF                                                                       
                                                                                
END FUNCTION 
 
FUNCTION i302_show()                                                            
   LET g_pmv01_t = g_pmv01
   LET g_pmv02_t = g_pmv02
   LET g_pmv06_t = g_pmv06
   DISPLAY  g_pmv01,g_pmv02,g_pmv06 TO pmv01,pmv02,
            pmv06
 
   CALL i302_pmv01('d')
   CALL i302_pmv02('d')
   CALL i302_b_fill(g_wc)                 #蟲                                   
                                                                                
   CALL cl_show_fld_cont()                                                      
END FUNCTION 
 
FUNCTION i302_r()                                                               
                                                                                
   IF s_shut(0) THEN RETURN END IF        #浪 d v                               
                                                                                
   IF g_pmv01 IS NULL THEN                                                      
      CALL cl_err("",-400,0)                                                    
      RETURN                                                                    
   END IF 
 
   BEGIN WORK
   
   IF cl_delh(0,0) THEN                   # T { @ U                             
      DELETE FROM pmv_file WHERE pmv01 = g_pmv01 
                             AND pmv02 = g_pmv02
                             AND pmv06 = g_pmv06                                
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("del","pmv_file",g_pmv01,"",SQLCA.sqlcode,"","BODY DELETE"
         ,0)                                                                             
      ELSE                                                                      
         CLEAR FORM                                                             
         CALL g_pmv.clear()                                                     
         LET g_pmv01 = NULL                                                     
                                                                                
         OPEN i302_count                                                        
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i302_cs
            CLOSE i302_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i302_count INTO g_row_count                                      
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i302_cs
            CLOSE i302_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt                                    
         OPEN i302_cs                                                           
         IF g_curs_index = g_row_count + 1 THEN                                 
            LET g_jump = g_row_count                                            
            CALL i302_fetch('L')                                                
         ELSE 
            LET g_jump = g_curs_index                                           
            LET mi_no_ask = TRUE                                                
            CALL i302_fetch('/')                                                
         END IF                                                                 
         LET g_cnt=SQLCA.SQLERRD[3]                                             
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'                      
      END IF                                                                    
   END IF                                                                       
                                                                                
   COMMIT WORK                                                                  
                                                                                
END FUNCTION
 
FUNCTION i302_b()                                                               
DEFINE                                                                          
   l_ac_t          LIKE type_file.num5,      #К    ﹕ARRAY CNT                 
   l_n             LIKE type_file.num5,      #浪 d   _в                        
   l_lock_sw       LIKE type_file.chr1,      #蟲  瑪   _                        
   p_cmd           LIKE type_file.chr1,      # B z﹐ A                          
   l_allow_insert  LIKE type_file.num5,      # i s W _                          
   l_allow_delete  LIKE type_file.num5,       # i R埃 _                          
   l_m             LIKE type_file.num5,
   l_agc04         LIKE agc_file.agc04
                                                                   
   LET g_action_choice = ""                                                     
   IF s_shut(0) THEN RETURN END IF           #浪 d v                            
   IF g_pmv01 IS NULL THEN                                                      
      RETURN                                                                    
   END IF 
   
   IF g_pmv06='Y' THEN
     CALL cl_err('','apm-102',0)
     RETURN
   END IF
     
   CALL cl_opmsg('b')                                                           
                                                                                
   #No.TQC-9C0139  --Begin
   #LET g_forupd_sql = "SELECT pmv03,agc02,pmv04,pmv07,pmv05,pmv08,",
   #         " pmv09,pmv10 FROM pmv_file LEFT OUTER JOIN agc_file ON agc01=pmv03",  
   #         " AND pmv01=? AND pmv02=? AND pmv03=? ",
   #         " AND pmv04=? AND pmv05=? AND PMV06=? FOR UPDATE "          
   LET g_forupd_sql = "SELECT pmv03,'',pmv04,pmv07,pmv05,pmv08,pmv09,pmv10 ",
                      "  FROM pmv_file ",
                      " WHERE pmv01=? AND pmv02=? AND pmv03=? ",
                      "   AND pmv04=? AND pmv05=? AND pmv06=? FOR UPDATE "          
   #No.TQC-9C0139  --End  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i302_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR                  
                                                                                
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")                          
                                                                                
   INPUT ARRAY g_pmv WITHOUT DEFAULTS FROM s_pmv.*                              
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
#        LET g_pmv[l_ac].pmv04 = ' '          #No.FUN-840178                                            
         IF g_rec_b >= l_ac THEN                                                
            BEGIN WORK                                                          
            LET g_pmv_t.* = g_pmv[l_ac].*      #BACKUP                          
            LET p_cmd='u'    
                                                              
           OPEN i302_cl USING g_pmv01,g_pmv02,g_pmv[l_ac].pmv03,                
                              g_pmv[l_ac].pmv04,g_pmv[l_ac].pmv05,g_pmv06                                   
                                         
            IF STATUS THEN
                 CALL cl_err("OPEN i302_cl:", STATUS, 1)                          
               LET l_lock_sw = "Y" 
            ELSE 
               FETCH i302_cl INTO g_pmv[l_ac].*                                 
               IF SQLCA.sqlcode THEN                                            
                  CALL cl_err(g_pmv02_t,SQLCA.sqlcode,1)                    
                  LET l_lock_sw = "Y"                                           
               END IF                                                           
            END IF                                                              
            #No.TQC-9C0139  --Begin
            SELECT agc02 INTO g_pmv[l_ac].agc02 FROM agc_file WHERE agc01=g_pmv[l_ac].pmv03
            #No.TQC-9C0139  --End  
            CALL cl_show_fld_cont()                                             
         END IF 
         CALL cl_set_comp_entry('pmv04,pmv05,pmv08',TRUE)                                                                
                                                                                
      BEFORE INSERT                                                             
         LET l_n = ARR_COUNT()                                                  
         LET p_cmd='a'                                                          
         INITIALIZE g_pmv[l_ac].* TO NULL  
         LET g_pmv[l_ac].pmv09=g_today 
         LET g_pmv[l_ac].pmv04 = ' '
         LET g_pmv[l_ac].pmv05 = ' '
         LET g_pmv[l_ac].pmv07 = ' '                                                                            
         LET g_pmv_t.* = g_pmv[l_ac].*         # s塊 J戈                        
         NEXT FIELD pmv03                                                       
                                                                                
      AFTER INSERT                                                              
         IF INT_FLAG THEN                                                       
            CALL cl_err('',9001,0)                                              
            LET INT_FLAG = 0                                                    
            CANCEL INSERT                                                       
         END IF                                                                 
          IF cl_null(g_pmv[l_ac].pmv04) THEN LET g_pmv[l_ac].pmv04 = ' ' END IF #No.FUN-840178
          INSERT INTO pmv_file(pmv01,pmv02,pmv03,pmv04,pmv05,pmv06,pmv07,pmv08,
                               pmv09,pmv10)     
                     VALUES(g_pmv01,g_pmv02,g_pmv[l_ac].pmv03,g_pmv[l_ac].pmv04,      
                              g_pmv[l_ac].pmv05,g_pmv06,g_pmv[l_ac].pmv07,
                              g_pmv[l_ac].pmv08,g_pmv[l_ac].pmv09,
                              g_pmv[l_ac].pmv10)                              
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("ins","pmv_file",g_pmv01,g_pmv02,SQLCA.sqlcode,"","",0)
            CANCEL INSERT                                                       
         ELSE                                                                   
            MESSAGE 'INSERT O.K'                                                
            LET g_rec_b=g_rec_b+1                                               
            DISPLAY g_rec_b TO FORMONLY.cn2                                     
            COMMIT WORK                                                         
         END IF
         
      AFTER FIELD pmv03
       IF NOT cl_null(g_pmv[l_ac].pmv03) THEN 
        IF p_cmd="a" OR (p_cmd="u" AND g_pmv[l_ac].pmv03 !=g_pmv_t.pmv03) THEN
             SELECT COUNT(*) INTO l_m FROM ima_file,agb_file 
             WHERE ima_file.ima01=g_pmv01 
             AND (ima_file.imaag=agb_file.agb01
              OR  ima_file.imaag1=agb_file.agb01)
              AND agb_file.agb03=g_pmv[l_ac].pmv03  
               IF l_m=0 THEN
                 CALL cl_err(g_pmv[l_ac].pmv03,'ask-008',0)
                 NEXT FIELD pmv03
               END IF
               CALL i302_pmv03('d')
        END IF               	        
       END IF 
      
      BEFORE FIELD pmv04
       SELECT agc04 INTO l_agc04  
               FROM agc_file 
               WHERE agc01=g_pmv[l_ac].pmv03
             IF l_agc04!='2' THEN
               CALL cl_set_comp_entry('pmv04',FALSE)
             END IF
      
      AFTER FIELD pmv04
       IF g_pmv[l_ac].pmv04!='*' AND (NOT cl_null(g_pmv[l_ac].pmv04) AND g_pmv[l_ac].pmv04 != ' ') THEN      #No.FUN-840178
        IF p_cmd="a" OR (p_cmd="u" AND g_pmv[l_ac].pmv04 !=g_pmv_t.pmv04) THEN
              SELECT COUNT(*) INTO l_m FROM agd_file,agc_file 
               WHERE (agd_file.agd02=g_pmv[l_ac].pmv04 and agd_file.agd01=agc_file.agc01 
                AND agc_file.agc04='2' and agc_file.agc01=g_pmv[l_ac].pmv03)
                OR (g_pmv[l_ac].pmv04 between agc_file.agc05 AND agc_file.agc06 
                AND agc_file.agc04='3' and agc_file.agc01=g_pmv[l_ac].pmv03) 
                OR (agc_file.agc04='1' and agc_file.agc01=g_pmv[l_ac].pmv03)
                IF l_m=0 THEN
                   CALL cl_err(g_pmv[l_ac].pmv04,'ask-008',0)
                   NEXT FIELD pmv04
                END IF
                CALL i302_pmv04('d')
          END IF 
        ELSE 
        #No.FUN-840178--BEGIN
                IF g_pmv[l_ac].pmv04 IS NULL THEN 
                   LET g_pmv[l_ac].pmv04 = ' ' 
                END IF
        #No.FUN-840178--END
        	LET g_pmv[l_ac].pmv07=''  
        END IF   
        
      BEFORE FIELD pmv05
        IF l_agc04!='2' THEN
            CALL cl_set_comp_entry('pmv05',FALSE)
         END IF  
             
      AFTER FIELD pmv05
       IF g_pmv[l_ac].pmv05!='*' OR cl_null(g_pmv[l_ac].pmv05) THEN   #No.FUN-840178
        IF p_cmd="a" OR (p_cmd="u" AND g_pmv[l_ac].pmv05 !=g_pmv_t.pmv05) THEN
              SELECT COUNT(*) INTO l_m FROM agd_file,agc_file
               WHERE (agd_file.agd02=g_pmv[l_ac].pmv05 and agd_file.agd01=agc_file.agc01 
                AND agc_file.agc04='2' and agc_file.agc01=g_pmv[l_ac].pmv03)
                OR (g_pmv[l_ac].pmv05 between agc_file.agc05 AND agc_file.agc06 
                AND agc_file.agc04='3' and agc_file.agc01=g_pmv[l_ac].pmv03) 
                OR (agc_file.agc04='1' and agc_file.agc01=g_pmv[l_ac].pmv03)
                IF l_m=0 THEN
                   CALL cl_err(g_pmv[l_ac].pmv04,'ask-008',0)
                   NEXT FIELD pmv05
                END IF
                CALL i302_pmv05('d')
          END IF 
        ELSE 
        	LET g_pmv[l_ac].pmv08=''
        END IF  
      
      BEFORE FIELD pmv08
        IF l_agc04='2' THEN
            CALL cl_set_comp_entry('pmv08',FALSE)
         END IF
                               
      AFTER FIELD pmv09
       IF NOT cl_null(g_pmv[l_ac].pmv10) AND g_pmv[l_ac].pmv10<g_pmv[l_ac].pmv09 THEN
          CALL cl_err('','mfg2604',0)
          NEXT FIELD pmv09
       END IF 
      
      AFTER FIELD pmv10
       IF NOT cl_null(g_pmv[l_ac].pmv09) AND g_pmv[l_ac].pmv10<g_pmv[l_ac].pmv09 THEN
          CALL cl_err('','mfg2604',0)
          NEXT FIELD pmv10
       END IF
              
      BEFORE DELETE
           IF g_pmv_t.pmv03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
              END IF
              IF l_lock_sw="Y" THEN
               CALL cl_err("", -263, 1)                                         
               CANCEL DELETE                                                    
              END IF 
                DELETE FROM pmv_file
                   WHERE pmv03=g_pmv_t.pmv03 AND pmv01=g_pmv01
                   AND pmv04=g_pmv_t.pmv04 AND pmv02=g_pmv02
                   AND pmv05=g_pmv_t.pmv05 AND pmv06=g_pmv06
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_pmv_t.pmv03,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
  
            COMMIT WORK                                                                  
                                                                                
      ON ROW CHANGE                                                             
         IF INT_FLAG THEN                                                       
            CALL cl_err('',9001,0)                                              
            LET INT_FLAG = 0                                                    
            LET g_pmv[l_ac].* = g_pmv_t.*                                       
            CLOSE i302_cl             
         ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF                                                                 
         IF l_lock_sw = 'Y' THEN                                                
            CALL cl_err(g_pmv[l_ac].pmv03,-263,1)                               
            LET g_pmv[l_ac].* = g_pmv_t.*                                       
         ELSE                                                                   
            UPDATE pmv_file SET pmv03 = g_pmv[l_ac].pmv03,
                                pmv04 = g_pmv[l_ac].pmv04,
                                pmv05 = g_pmv[l_ac].pmv05,
                                pmv07 = g_pmv[l_ac].pmv07,
                                pmv08 = g_pmv[l_ac].pmv08,
                                pmv09 = g_pmv[l_ac].pmv09,
                                pmv10 = g_pmv[l_ac].pmv10
                                
             WHERE pmv01=g_pmv01
               AND pmv02=g_pmv02
               AND pmv06=g_pmv06
               AND pmv03=g_pmv_t.pmv03
               AND pmv04=g_pmv_t.pmv04
               AND pmv05=g_pmv_t.pmv05
         IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pmv_file",g_pmv01,g_pmv[l_ac].pmv03,SQLCA.sqlcode,"","",0)
               LET g_pmv[l_ac].* = g_pmv_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
         AFTER ROW 
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac            #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_pmv[l_ac].* = g_pmv_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_pmv.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i302_cl                                                       
            ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF            
         LET l_ac_t = l_ac            #FUN-D30034 add                                                     
         CLOSE i302_cl                                                          
         COMMIT WORK                                                            
                                                                                
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
      
      ON ACTION CONTROLP                                                      
          CASE 
            WHEN INFIELD(pmv03)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form= "q_pmv03" 
                 LET g_qryparam.arg1=g_pmv01                                                           
                 LET g_qryparam.default1  = g_pmv[l_ac].pmv03                   
                 CALL cl_create_qry() RETURNING g_pmv[l_ac].pmv03
                 CALL FGL_DIALOG_SETBUFFER(g_pmv[l_ac].pmv03)               
                 CALL i302_pmv03('d')                                           
                 NEXT FIELD pmv03                                                                 
            WHEN INFIELD(pmv04)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form= "q_pmv04"
                  LET g_qryparam.arg1 = g_pmv[l_ac].pmv03                                                             
                 LET g_qryparam.default1  = g_pmv[l_ac].pmv04                   
                 CALL cl_create_qry() RETURNING g_pmv[l_ac].pmv04
                 CALL FGL_DIALOG_SETBUFFER(g_pmv[l_ac].pmv04)               
                 CALL i302_pmv04('d')                                           
                 NEXT FIELD pmv04
            WHEN INFIELD(pmv05)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_pmv04"
                 LET g_qryparam.arg1 = g_pmv[l_ac].pmv03                                                             
                 LET g_qryparam.default1  = g_pmv[l_ac].pmv05                   
                 CALL cl_create_qry() RETURNING g_pmv[l_ac].pmv05
                 CALL FGL_DIALOG_SETBUFFER(g_pmv[l_ac].pmv05)               
                 CALL i302_pmv05('d')                                           
                 NEXT FIELD pmv05                                              
            END CASE                   
 
   END INPUT
   
   CLOSE i302_cl
   COMMIT WORK
#  CALL i302_delall() #No.FUN-870124
                                                                                
END FUNCTION 
 
#No.FUN-870124--BEGIN--
{FUNCTION i302_delall()
    SELECT COUNT(*) INTO g_cnt  FROM pmv_file
          WHERE pmv01=g_pmv01
            AND pmv02=g_pmv02
            AND pmv06=g_pmv06
    
    IF g_cnt=0 THEN
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
   END IF
 
END FUNCTION}
#No.FUN-870124--END--
 
FUNCTION i302_b_fill(p_wc)              #BODY FILL UP                           
                                                                                
   DEFINE p_wc  LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(200)            
                                                                                
   LET g_sql = "SELECT pmv03,agc02,pmv04,pmv07,pmv05,pmv08,pmv09,pmv10 ",   
               " FROM pmv_file LEFT OUTER JOIN agc_file ON agc01=pmv03",                           
               " WHERE pmv01 = '",g_pmv01 CLIPPED,"' ",
               " and pmv02 = '",g_pmv02 CLIPPED,"' ",
               " and pmv06 = '",g_pmv06 CLIPPED,"' ",                              
               " ORDER BY pmv03"                                                    
   PREPARE i302_prepare2 FROM g_sql      # w稱 @ U                              
   DECLARE pmv_cs CURSOR FOR i302_prepare2                                      
                                                                                
   CALL g_pmv.clear()                                                           
   LET g_cnt = 1                                                                
   LET g_rec_b=0                                                                
                                                                                
   FOREACH pmv_cs INTO g_pmv[g_cnt].*   #蟲   ARRAY 惡 R                        
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                                
         EXIT FOREACH                                                           
      END IF                                                                    
      LET g_cnt = g_cnt + 1                                                     
      IF g_cnt > g_max_rec THEN 
         CALL cl_err('',9035,0)                                                 
         EXIT FOREACH                                                           
      END IF                                                                    
   END FOREACH                                                                  
   CALL g_pmv.deleteElement(g_cnt)                                              
                                                                                
   LET g_rec_b = g_cnt - 1                                                      
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0                                                                
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i302_bp(p_ud)                                                          
    DEFINE p_ud            LIKE type_file.chr1
  
    IF p_ud <> "G" OR g_action_choice = "detail" THEN                           
        RETURN                                                                  
    END IF                                                                      
                                                                                
    LET g_action_choice = " "                                                   
   DISPLAY g_pmv01 TO pmv01               #蟲 Y                                 
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                             
   DISPLAY ARRAY g_pmv TO s_pmv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)          
                                                                                
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
 
        ON ACTION modify                                                        
           LET g_action_choice="modify"                                         
           EXIT DISPLAY                                                         
                                                                                
        ON ACTION detail                                                        
           LET g_action_choice="detail"                                         
           LET l_ac = 1                                                         
           EXIT DISPLAY                                                         
                                                             
        ON ACTION help                                                          
           LET g_action_choice="help"                                           
           EXIT DISPLAY                                                         
         
#No.TQC-960303 --Begin                                                                                                              
#        ON ACTION output                                                                                                           
#          LET g_action_choice="output"                                                                                             
#          EXIT DISPLAY                                                                                                             
#No.TQC-960303 --End                                                                          
        ON ACTION locale                                                        
           CALL cl_dynamic_locale()                                             
           CALL cl_show_fld_cont()                                               
           EXIT DISPLAY
 
         ON ACTION output                                                        
           LET g_action_choice="output"                                         
           EXIT DISPLAY                                                         
                                                                                
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
           CALL i302_fetch('F')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
           ACCEPT DISPLAY                                                       
                                                                                
        ON ACTION previous                                                      
           CALL i302_fetch('P')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
        ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION jump                                                          
           CALL i302_fetch('/')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF 
           ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION next                                                          
           CALL i302_fetch('N')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
        ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION last                                                          
           CALL i302_fetch('L')                                                 
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
                                                                                
      AFTER DISPLAY                                                             
         CONTINUE DISPLAY                                                       
                                                                                
    END DISPLAY                                                                 
    CALL cl_set_act_visible("accept,cancel", TRUE)                              
                                                                                
END FUNCTION  
 
FUNCTION i302_pmv01(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,                                       
           l_imaacti LIKE ima_file.imaacti                                      
   LET g_errno=' '                                                              
   SELECT ima02,imaacti ima021 INTO l_ima02,l_ima021,l_imaacti  FROM ima_file                   
         WHERE ima01=g_pmv01                                                
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                         
        WHEN l_imaacti='N'        LET g_errno='9028'                            
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       DISPLAY l_ima02 TO FORMONLY.pmv01_ima02
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i302_pmv02(p_cmd)                                                      
   DEFINE l_pmc03   LIKE pmc_file.pmc03,    #   u m W                                                               
          p_cmd     like type_file.chr1                                        
                                                                                
   LET g_errno=''
   IF g_pmv02!= '*' THEN         #No.FUN-830121                                                         
     SELECT pmc03 INTO l_pmc03 FROM pmc_file                     
          WHERE pmc01=g_pmv02 
   #No.FUN-830121 --begin--
   ELSE
   	  CALL cl_getmsg("apm-104",g_lang) RETURNING  l_pmc03         
   END IF 
   #No.FUN-830121 --end--
   	                                                                                                                                                            
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'                            
                           LET l_pmc03=NULL                                                                       
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'            
   END CASE                                                                     
                                                                               
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
     DISPLAY l_pmc03 TO FORMONLY.pmv02_pmc03
   END IF                                                                                                                 
END FUNCTION
 
FUNCTION i302_pmv03(p_cmd)                                                      
   DEFINE l_agc02   LIKE agc_file.agc02,    #   u m W
          p_cmd     like type_file.chr1
 
   LET g_errno=''
   SELECT agc02 INTO l_agc02 FROM agc_file
      WHERE agc01=g_pmv[l_ac].pmv03
 
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                           LET l_agc02=NULL
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     LET g_pmv[l_ac].agc02=l_agc02
   END IF
END FUNCTION
 
FUNCTION i302_pmv04(p_cmd)                                                      
   DEFINE l_agd03   LIKE bol_file.bol02,    #   u m W                          
          p_cmd     like type_file.chr1                                         
                                                                                
   LET g_errno=''
   IF g_pmv[l_ac].pmv04='*' THEN
     LET l_agd03=''
   ELSE                                                                   
     SELECT agd03 INTO l_agd03 FROM agd_file                      
          WHERE agd01=g_pmv[l_ac].pmv03
          AND agd02=g_pmv[l_ac].pmv04                                         
   END IF                                                                              
                                                                                
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'                            
                           LET l_agd03=NULL                                                                        
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'            
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
   LET g_pmv[l_ac].pmv07=l_agd03                                            
   END IF                                                                       
END FUNCTION
 
FUNCTION i302_pmv05(p_cmd)                                                      
   DEFINE l_agd03   LIKE bol_file.bol02,    #   u m W                          
          p_cmd     like type_file.chr1                                        
                                                                                
   LET g_errno=''
   IF g_pmv[l_ac].pmv05='*' THEN
     LET l_agd03=''
   ELSE                                                                
     SELECT agd03 INTO l_agd03 FROM agd_file                      
          WHERE agd01=g_pmv[l_ac].pmv03
            AND agd02=g_pmv[l_ac].pmv05 
   END IF                                                                                                                        
                                                                                
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'                            
                           LET l_agd03=NULL                                                                        
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'            
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
   LET g_pmv[l_ac].pmv08=l_agd03                                            
   END IF                                                                       
END FUNCTION
 
 
 
