# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: aski003.4gl
# Descriptions...: 報工群組維護作業
# Date & Author..: 08/03/25 By hongmei FUN-810016 FUN-840178 No.FUN-870117 FUN-8B0023 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-8C0056 08/12/22 By alex 修改LOCK CURSOR串接REF table問題
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940168 09/08/25 By alex 調整cl_used位置
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D40030 13/04/07 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_skl01      LIKE skl_file.skl01,
   g_skl01_t    LIKE skl_file.skl01,        #群組編號
   g_skl03_t    LIKE skl_file.skl03,        #款式料號
   g_skl        RECORD LIKE skl_file.*,
   g_skl_t      RECORD LIKE skl_file.*,
   g_skl_o      RECORD LIKE skl_file.*,
   g_skm        DYNAMIC ARRAY OF RECORD
       skm04 LIKE skm_file.skm04,           #員工編號
       gen02 LIKE gen_file.gen02,           #員工姓名
       skm05 LIKE skm_file.skm05,           #工藝單元編號
       sga02 LIKE sga_file.sga02,           #單元名稱
       skm06 LIKE skm_file.skm06,           #同工藝單元報工比例
       skm07 LIKE skm_file.skm07,           #生效日期
       skm08 LIKE skm_file.skm08            #失效日期
       END RECORD,
   g_skm_t       RECORD
       skm04 LIKE skm_file.skm04,           #員工編號
       gen02 LIKE gen_file.gen02,           #員工姓名                     
       skm05 LIKE skm_file.skm05,           #工藝單元編號  
       sga02 LIKE sga_file.sga02,           #單元名稱
       skm06 LIKE skm_file.skm06,           #同工藝單元報工比例          
       skm07 LIKE skm_file.skm07,           #生效日期                    
       skm08 LIKE skm_file.skm08            #失效日期                   
       END RECORD, 
       g_wc,g_sql,g_wc2  STRING,
       g_rec_b         LIKE type_file.num5,     #單身筆數    
       l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT
DEFINE g_forupd_sql    STRING                   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_jump          LIKE type_file.num10
DEFINE g_no_ask        LIKE type_file.num5
DEFINE g_delete        LIKE type_file.chr1
DEFINE g_chr           STRING
 
MAIN
   DEFINE l_sma124        LIKE sma_file.sma124
 
   OPTIONS                                                            
      INPUT NO WRAP
   DEFER INTERRUPT      
 
   IF (NOT cl_user()) THEN                                             
      EXIT PROGRAM                                                       
   END IF                      
                                                                        
   WHENEVER ERROR CALL cl_err_msg_log                                                                                                                    
 
   IF (NOT cl_setup("ASK")) THEN                                         
      EXIT PROGRAM                                                       
   END IF   
   
   IF NOT s_industry('slk') THEN
      CALL cl_err("","-1000",1)
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #TQC-940168
 
   LET g_forupd_sql = "SELECT * FROM skl_file WHERE skl01= ? and skl03 = ? FOR UPDATE"                                                                               
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i003_crl CURSOR FROM g_forupd_sql 
 
   OPEN WINDOW i003_w WITH FORM "ask/42f/aski003"               
      ATTRIBUTE (STYLE = g_win_style CLIPPED)             
                                                                                
   CALL cl_ui_init()      
    
   CALL i003_menu()                                                            
                                                                                
   CLOSE WINDOW i003_w                                                         
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION i003_cs()
   CLEAR FORM                             #清除畫面 
   CONSTRUCT BY NAME g_wc ON skl01,skl02,skl03,skl04,
                             sklacti,skluser,sklmodu,sklgrup,skldate
     ON ACTION controlp         #查詢款式料號                                   
       CASE
          WHEN INFIELD(skl03)     
#FUN-AA0059---------mod------------str-----------------                                            
#            CALL cl_init_qry_var()                                           
#            LET g_qryparam.state="c"                                    
#            LET g_qryparam.form="q_ima_slk"
#            LET g_qryparam.default1=g_skl.skl03                            
#            CALL cl_create_qry() RETURNING g_qryparam.multiret               
             CALL q_sel_ima(TRUE, "q_ima_slk","",g_skl.skl03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------	  
              DISPLAY g_qryparam.multiret TO skl03                             
          OTHERWISE                                                             
             EXIT CASE  
       END CASE
           
     ON ACTION about                                                           
        CALL cl_about()
 
     ON ACTION controlg     
        CALL cl_cmdask()    
 
     ON ACTION help         
        CALL cl_show_help() 
              
     ON IDLE g_idle_seconds   
        CALL cl_on_idle()                                                 
        CONTINUE CONSTRUCT
   END CONSTRUCT
   
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('skluser', 'sklgrup')
    
    CONSTRUCT g_wc2 ON skm04,skm05,skm06,skm07,skm08
                  FROM s_skm[1].skm04,s_skm[1].skm05,
                       s_skm[1].skm06,s_skm[1].skm07,s_skm[1].skm08
                       
       ON ACTION CONTROLP
          CASE                                                                  
            WHEN INFIELD(skm04)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_gen"                           
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO skm04
                 NEXT FIELD skm04
            WHEN INFIELD(skm05)
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_sga"                             
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO skm05                                           
                 NEXT FIELD skm05
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
 
        ON ACTION qbe_save
           CALL cl_qbe_save()
 
    END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT skl01,skl03 FROM skl_file ",
                 " WHERE ",g_wc CLIPPED,
                 " ORDER BY skl01"
    ELSE
      LET g_sql= "SELECT UNIQUE skl01,skl03 FROM skl_file,skm_file",
                 " WHERE skl01=skm01 AND skl03=skm03 AND ", g_wc CLIPPED," AND ",g_wc2 CLIPPED,         
                 " ORDER BY skl01 " 
    END IF                                             
    PREPARE i003_prepare FROM g_sql      #預備一下                              
    DECLARE i003_b_cs                  #宣告成可卷動的                          
        SCROLL CURSOR WITH HOLD FOR i003_prepare
    IF g_wc2=" 1=1" THEN
      LET g_sql="SELECT  COUNT(*)     ",                                 
              " FROM skl_file WHERE ", g_wc CLIPPED
    ELSE
      LET g_sql="SELECT  COUNT(*)     ",                                        
                " FROM skl_file,skm_file WHERE ", 
                " skl01=skm01 AND skl03=skm03 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED                       
    END IF
    PREPARE i003_precount FROM g_sql                                            
    DECLARE i003_count CURSOR FOR i003_precount                                 
END FUNCTION  
         
FUNCTION i003_menu()
    WHILE TRUE                                                                   
      CALL i003_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "insert"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i003_a()                                                    
            END IF                                                              
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i003_q()                                                    
            END IF                                                              
         WHEN "delete"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i003_r()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i003_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF 
         WHEN "invalid"                                                         
            IF cl_chk_act_auth() THEN                                           
               CALL i003_x()
               CALL i003_show()                                                
            END IF
         WHEN "modify"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i003_u()                                                    
            END IF             
 
         WHEN "confirm"                                                       
           IF cl_chk_act_auth() THEN                                            
              CALL i003_confirm()                                               
              CALL i003_show()                                                  
           END IF
                                                                          
         WHEN "output"                                                        
            IF cl_chk_act_auth() THEN
               CALL i003_out()
            END IF 
                                                                                  
         WHEN "notconfirm"                                                    
           IF cl_chk_act_auth() THEN                                            
              CALL i003_notconfirm()                                            
              CALL i003_show()                                                  
           END IF 
                                                                          
         WHEN "help"                                                            
            CALL cl_show_help()
                                                             
         WHEN "exit"                                                            
            EXIT WHILE 
                                                                     
         WHEN "controlg"                                                        
            CALL cl_cmdask()
              
         WHEN "exporttoexcel"                                                  
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_skl),'','')                                                             
            END IF   
      END CASE
    END WHILE
END FUNCTION
 
FUNCTION i003_a()
   
    MESSAGE ""                                                                  
    CLEAR FORM                                                                  
    CALL g_skm.clear()
    
    IF s_shut(0) THEN
       RETURN
    END IF
    
    CALL cl_opmsg('a')
 
    WHILE TRUE
       LET g_skl.skluser = g_user                                              
       LET g_skl.sklgrup = g_grup               #使用者所屬群                  
       LET g_skl.skldate = g_today                                             
       LET g_skl.sklacti = 'Y'
       LET g_skl.skl01  = ' '                                                      
       LET g_skl01_t  = ' '                                                        
       LET g_skl.skl02=' '                                                         
       LET g_skl.skl03  = ' '                                                      
       LET g_skl03_t  = ' '                                                        
       LET g_skl.skl04='N'                                                 
       CALL i003_i("a")
        IF INT_FLAG THEN                   #使用者不玩了                        
            LET INT_FLAG = 0                                                    
            LET g_skl.skl01  = NULL 
            LET g_skl.skl03  = NULL                                                
            CALL cl_err('',9001,0)                                              
            EXIT WHILE                                                          
        END IF         
 
        IF cl_null(g_skl.skl01) OR cl_null(g_skl.skl02)  THEN
           CONTINUE WHILE
        END IF
 
        BEGIN WORK
           LET g_skl.skloriu = g_user      #No.FUN-980030 10/01/04
           LET g_skl.sklorig = g_grup      #No.FUN-980030 10/01/04
           INSERT INTO skl_file VALUES(g_skl.*)
           
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_skl.skl01,SQLCA.sqlcode,1)    #FUN-B80030 ADD
              ROLLBACK WORK
             # CALL cl_err(g_skl.skl01,SQLCA.sqlcode,1)    #FUN-B80030 MARK   
              CONTINUE WHILE
           ELSE
              LET g_skl01_t = g_skl.skl01                     # 保存上筆資料            
              LET g_skl03_t = g_skl.skl03                                           
              SELECT skl01,skl03 INTO g_skl.skl01, g_skl.skl03 FROM skl_file                       
                   WHERE skl01 = g_skl.skl01 AND skl03=g_skl.skl03 
              COMMIT WORK 
           END IF
          
        CALL cl_flow_notify(g_skl.skl01,'I')
        LET g_rec_b=0
        CALL i003_b_fill('1=1')         #單身                                   
        CALL i003_b()                   #輸入單身
        EXIT WHILE 
      END WHILE
END FUNCTION
 
FUNCTION i003_i(p_cmd)  
   DEFINE    p_cmd     LIKE type_file.chr1     #a:輸入 u:更改             
   DEFINE    l_n,l_n1  LIKE type_file.num5     #SMALLINT
   DEFINE    l_skl02   LIKE skl_file.skl02
 
   DISPLAY BY NAME g_skl.skluser,g_skl.sklgrup,g_skl.sklmodu,g_skl.skldate,g_skl.sklacti,g_skl.skl01,
                   g_skl.skl02,g_skl.skl03,g_skl.skl04
   INPUT BY NAME g_skl.skl01,g_skl.skl02,g_skl.skl03,g_skl.skl04,
                 g_skl.skluser,g_skl.sklgrup,g_skl.sklmodu,g_skl.skldate,g_skl.sklacti WITHOUT DEFAULTS
 
       BEFORE INPUT
         LET g_before_input_done=FALSE
         CALL i003_set_entry(p_cmd)
         CALL i003_set_no_entry(p_cmd)
         LET g_before_input_done=TRUE
         
      AFTER FIELD skl01
         IF cl_null(g_skl.skl01) THEN                                    
            IF p_cmd ='a' OR (g_skl.skl01 != g_skl01_t AND p_cmd='u') THEN
              NEXT FIELD skl01
            END IF
         END IF
         IF NOT cl_null(g_skl.skl01) THEN  
           SELECT COUNT(*) INTO l_n1 FROM skl_file
            WHERE skl01=g_skl.skl01                    
             IF l_n1>0  THEN  
              SELECT skl02 INTO l_skl02 FROM skl_file
               WHERE skl01=g_skl.skl01 
             LET g_skl.skl02 = l_skl02                                   
             DISPLAY BY NAME g_skl.skl02
             END IF 
          END IF 
              
       AFTER FIELD  skl03
          IF cl_null(g_skl.skl03) THEN
             CALL cl_err('skl03','ask-014',0)
             NEXT FIELD skl03
          END IF
          IF NOT cl_null(g_skl.skl03) THEN 
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_skl.skl03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_skl.skl03= g_skl03_t
               NEXT FIELD skl03
            END IF
#FUN-AA0059 ---------------------end-------------------------------                                      
             IF p_cmd ='a' OR (g_skl.skl03 != g_skl03_t AND p_cmd='u') THEN
                SELECT count(*) INTO g_cnt FROM skl_file                    
                 WHERE skl01=g_skl.skl01                                    
                   AND skl03=g_skl.skl03                               
                 IF g_cnt>0  THEN                      #資料重復                
                 CALL cl_err('','-239',0)
                 NEXT FIELD skl03
                 END IF
              END IF
              CALL i003_skl03(p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_skl.skl04,g_errno,0)
                    LET g_skl.skl03=g_skl03_t                               
                    NEXT FIELD skl03
                END IF
          END IF
          
      AFTER INPUT                                                             
           IF INT_FLAG THEN                                                    
              EXIT INPUT                                                       
           END IF
           IF cl_null(g_skl.skl02) THEN
               NEXT FIELD skl02
           END IF
           IF cl_null(g_skl.skl03) THEN
            CALL cl_err('skl03','ask-014',0)
            NEXT FIELD skl03
            END IF
 
       ON ACTION controlz
          CALL cl_show_req_fields()
       
       ON ACTION controlg
          CALL cl_cmdask()                                                              
                                                                                
       ON ACTION controlp
            CASE
              WHEN INFIELD(skl03)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()                                           
#              LET g_qryparam.form     ="q_ima_slk"                                 
#              LET g_qryparam.default1 = g_skl.skl03                           
#              CALL cl_create_qry() RETURNING g_skl.skl03 
               CALL q_sel_ima(FALSE, "q_ima_slk","",g_skl.skl03,"","","","","",'' ) 
                   RETURNING g_skl.skl03  
#FUN-AA0059---------mod------------end-----------------
               IF g_skl.skl03 IS NULL THEN                                      
                  DISPLAY g_skl03_t TO skl03                                    
               ELSE                                                            
                  DISPLAY g_skl.skl03 TO skl03                                      
               END IF                                                           
          END CASE                           
      
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT
                                                                  
       ON ACTION about                                                           
         CALL cl_about()                                                        
                                                                                
       ON ACTION help                                                            
          CALL cl_show_help()                                                                         
    END INPUT                                                                   
END FUNCTION               
 
FUNCTION i003_q()
   
    LET g_row_count = 0                                                         
    LET g_curs_index = 0                                                        
    CALL cl_navigator_setting( g_curs_index, g_row_count )                      
    INITIALIZE g_skl.skl01,g_skl.skl03 TO NULL
    CALL cl_opmsg('q')                                                          
    MESSAGE ""                                                                  
    CLEAR FORM                                                                  
    CALL g_skm.clear()                                                          
    CALL i003_cs()
    IF INT_FLAG THEN                         #使用者不玩了                      
        LET INT_FLAG = 0                                                        
        RETURN                                                                  
    END IF                                                                      
    OPEN i003_b_cs                           #從DB產生合乎條件TEMP(0-30秒)      
    IF SQLCA.sqlcode THEN                    #有問題                            
        CALL cl_err('',SQLCA.sqlcode,0)                                         
        INITIALIZE g_skl.skl01,g_skl.skl03 TO NULL                             
    ELSE                                                                        
        OPEN i003_count                                                         
        FETCH i003_count INTO g_row_count                                       
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i003_fetch('F')                 #讀出TEMP第一筆并顯示                                      
    END IF                                                                      
END FUNCTION
 
FUNCTION i003_fetch(p_flag)                                                     
DEFINE                                                                          
    p_flag          LIKE type_file.chr1                  #處理方式
   
    MESSAGE ""                                                                  
    CASE p_flag                                                                 
        WHEN 'N' FETCH NEXT     i003_b_cs INTO 
                                               g_skl.skl01,g_skl.skl03         
        WHEN 'P' FETCH PREVIOUS i003_b_cs INTO 
                                               g_skl.skl01,g_skl.skl03         
        WHEN 'F' FETCH FIRST    i003_b_cs INTO 
                                               g_skl.skl01,g_skl.skl03     
        WHEN 'L' FETCH LAST     i003_b_cs INTO 
                                               g_skl.skl01,g_skl.skl03         
        WHEN '/'                                                                
            IF (NOT g_no_ask) THEN                                             
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
            FETCH ABSOLUTE g_jump i003_b_cs INTO  g_skl.skl01,
                           g_skl.skl03       
            LET g_no_ask = FALSE                                               
    END CASE 
    
    IF SQLCA.sqlcode THEN                         #有麻煩                       
        CALL cl_err(g_skl.skl01,SQLCA.sqlcode,0)                               
        INITIALIZE g_skl.skl01,g_skl.skl03 TO NULL 
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
    SELECT * INTO g_skl.* FROM skl_file WHERE skl01 = g_skl.skl01 and skl03 = g_skl.skl03
    IF SQLCA.sqlcode THEN                         #有麻煩                       
        CALL cl_err(g_skl.skl01,SQLCA.sqlcode,0)                                
        INITIALIZE g_skl.skl01,g_skl.skl03 TO NULL                              
        RETURN                                                                  
    END IF
    CALL  i003_show()               
END FUNCTION 
 
#將資料顯示在畫面上                                                             
FUNCTION i003_show()
      
      LET g_skl_t.* = g_skl.*
   DISPLAY BY NAME g_skl.skl01,g_skl.skl02,g_skl.skl03,g_skl.skl04,         #單頭
                   g_skl.skluser,g_skl.sklgrup,g_skl.sklmodu,g_skl.skldate,g_skl.sklacti
      CALL i003_skl03('d')
      CALL i003_b_fill(g_wc2)              #單身 
      CALL i003_show_pic()
      CALL cl_show_fld_cont()                                   
END FUNCTION
 
FUNCTION i003_r()                                                               
  DEFINE                                                                        
    l_skl03      LIKE skl_file.skl03                                            
    IF s_shut(0) THEN RETURN END IF                                             
    IF cl_null(g_skl.skl01) OR cl_null(g_skl.skl03) THEN   
        CALL cl_err('',-400,0)                                                  
        RETURN                                                                  
    END IF    
                                                                    
    
    SELECT * INTO g_skl.* FROM skl_file                                         
        WHERE skl01=g_skl.skl01                                              
         AND  skl03=g_skl.skl03                                              
    IF g_skl.sklacti='N' THEN                                                   
         CALL cl_err(g_skl.skl01,'mfg1000',0)                                   
         RETURN                                                                 
    END IF 
    IF g_skl.skl04='Y' THEN 
         CALL  cl_err('',9023,0)
         RETURN
    END IF
   
    BEGIN WORK
    
    OPEN i003_crl USING g_skl.skl01, g_skl.skl03
    IF STATUS THEN
       CALL cl_err("OPEN i003_cl:",STATUS,1)
       CLOSE i003_crl
       ROLLBACK WORK
       RETURN
    END IF
   
    FETCH i003_crl INTO g_skl.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_skl.skl01,SQLCA.sqlcode,0)
        CLOSE i003_crl
        ROLLBACK WORK
        RETURN
    END IF
    
    CALL i003_show()
                                                                     
    IF cl_delh(0,0) THEN                   #確認一下         
         DELETE FROM skl_file WHERE skl01=g_skl.skl01 AND skl03=g_skl.skl03
         DELETE FROM skm_file WHERE skm01=g_skl.skl01 AND skm03=g_skl.skl03 
         CLEAR FORM
         CALL g_skm.clear()                                                  
         LET g_cnt=SQLCA.SQLERRD[3]                                          
         LET g_delete = 'Y'                                                  
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'                   
         OPEN i003_count                                                     
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i003_b_cs
            CLOSE i003_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
           FETCH i003_count INTO g_row_count                                   
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i003_b_cs
            CLOSE i003_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt                                 
         OPEN i003_b_cs                                                      
         IF g_curs_index = g_row_count + 1 THEN                              
         LET g_jump = g_row_count                                         
         CALL i003_fetch('L')                                             
         ELSE                                                                
           LET g_jump = g_curs_index                                        
           LET g_no_ask = TRUE                                             
           CALL i003_fetch('/')                                             
         END IF    
      END IF
  
   COMMIT WORK                                                                 
   CALL cl_flow_notify(g_skl.skl01,'D')                                            
                                                                                
END FUNCTION      
 
#單身                                                                           
FUNCTION i003_b()                                                               
DEFINE                                                                          
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT      
    l_n             LIKE type_file.num5,                #檢查重復用        
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
    p_cmd           LIKE type_file.chr1,                #處理狀態        
    l_allow_insert  LIKE type_file.num5,                #可新增否
    l_allow_delete  LIKE type_file.num5,                #可刪除否
    l_acti          LIKE sfb_file.sfbacti,
    l_str           LIKE type_file.chr20,
    l_skm05         LIKE skm_file.skm05,
    l_skm06         LIKE skm_file.skm06,
    l_sql           STRING,
    l_m             LIKE type_file.num5
    
    LET g_action_choice = ""                                                    
                                                                                
    IF s_shut(0) OR g_skl.skl04="Y"  THEN RETURN END IF   
               
    IF cl_null(g_skl.skl01) OR cl_null(g_skl.skl03) THEN               
        RETURN                                                                  
    END IF 
    
    SELECT sklacti INTO l_acti                                                  
           FROM skl_file WHERE skl01 = g_skl.skl01 AND skl03= g_skl.skl03                                  
    IF l_acti = 'N'  OR l_acti = 'n' THEN                                       
           LET l_str = g_skl.skl01,g_skl.skl03 CLIPPED                                          
           CALL cl_err(l_str,'mfg1000',0)                                       
    END IF                                                                      
                                                                                
    CALL cl_opmsg('b') 
    
    LET l_allow_insert = cl_detail_input_auth("insert")                         
    LET l_allow_delete = cl_detail_input_auth("delete")                         
                                                                                
    LET g_forupd_sql =" SELECT skm04,'',skm05,'',skm06,skm07,skm08 ",
                        " FROM skm_file ",         
                       "  WHERE skm01 = ? AND skm03 = ? AND skm04 = ? ", 
                         " AND skm05 = ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i003_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR  
   
    IF g_rec_b=0 THEN CALL g_skm.clear() END IF 
   
    INPUT ARRAY g_skm WITHOUT DEFAULTS FROM s_skm.*                             
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
                                                                           
       BEGIN WORK
       OPEN i003_crl USING g_skl.skl01, g_skl.skl03
       IF STATUS THEN
          CALL cl_err("OPEN i003_crl:",STATUS,1)
          CLOSE i003_crl                                                   
          ROLLBACK WORK                                                    
          RETURN                                                           
       END IF                                                              
                                                                           
       FETCH i003_crl INTO g_skl.*                                         
       IF SQLCA.sqlcode THEN                                               
           CALL cl_err(g_skl.skl01,SQLCA.sqlcode,0)                        
           ROLLBACK WORK 
           CLOSE i003_crl                                                  
           RETURN                                                          
       END IF      
       
       IF g_rec_b >= l_ac THEN                                             
           LET p_cmd='u'                                                   
           LET g_skm_t.* = g_skm[l_ac].*  #BACKUP                          
           OPEN i003_bcl USING g_skl.skl01,g_skl.skl03,g_skm_t.skm04,g_skm_t.skm05         
           IF STATUS THEN                                                  
              CALL cl_err("OPEN i003_bcl:",STATUS,1)                     
              LET l_lock_sw = "Y"                                          
           ELSE                                                            
              FETCH i003_bcl INTO g_skm[l_ac].*                            
              IF SQLCA.sqlcode THEN
                  LET l_str=g_skm_t.skm04,g_skm_t.skm05 CLIPPED                                        
                  CALL cl_err(l_str,SQLCA.sqlcode,1)               
                  LET l_lock_sw = "Y"                                      
              ELSE    #TQC-8C0056
                  SELECT gen02 INTO g_skm[l_ac].gen02 FROM gen_file
                   WHERE gen01 = g_skm[l_ac].skm04 
                  SELECT sga02 INTO g_skm[l_ac].sga02 FROM sga_file
                   WHERE sga01 = g_skm[l_ac].skm05
                  DISPLAY BY NAME g_skm[l_ac].gen02, g_skm[l_ac].sga02
              END IF                                                       
           END IF
       END IF
        
       BEFORE INSERT                                                           
            LET l_n = ARR_COUNT()                                               
            LET p_cmd='a'                                                       
            INITIALIZE g_skm[l_ac].* TO NULL                             
            LET g_skm_t.* = g_skm[l_ac].*         #新輸入資料  
            LET g_skm[l_ac].skm07=g_today
            LET g_skm[l_ac].skm06=1                 
            CALL cl_show_fld_cont()                            
            NEXT FIELD skm04
 
       AFTER INSERT                                                            
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               CANCEL INSERT                                                    
            END IF
            SELECT count(*) INTO l_n FROM skm_file                                                  
             WHERE skm01=g_skl.skl01       AND skm03=g_skl.skl03                                        
               AND skm04=g_skm[l_ac].skm04 AND skm05=g_skm[l_ac].skm05                                  
            IF l_n>0 THEN                                                    
               CALL cl_err('',-239,0)                                        
               LET g_skm[l_ac].skm04=g_skm_t.skm04                           
               LET g_skm[l_ac].skm05=g_skm_t.skm05                           
               NEXT FIELD skm04                                              
            END IF
            INSERT INTO skm_file(skm01,skm05,skm03,skm04,skm06,
                                 skm07,skm08)
            VALUES(g_skl.skl01,g_skm[l_ac].skm05,
                   g_skl.skl03,g_skm[l_ac].skm04,
                   g_skm[l_ac].skm06,
                   g_skm[l_ac].skm07,g_skm[l_ac].skm08)
            IF SQLCA.sqlcode THEN
               CALL cl_err(l_str,SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cnt2
            END IF
 
        AFTER FIELD skm05 
           IF NOT cl_null(g_skm[l_ac].skm05) THEN
              IF g_skm[l_ac].skm05!= g_skm_t.skm05 OR g_skm_t.skm05 IS NULL THEN
               SELECT count(*) INTO l_n FROM skm_file
                WHERE skm01=g_skl.skl01       AND skm03=g_skl.skl03
                  AND skm04=g_skm[l_ac].skm04 AND skm05=g_skm[l_ac].skm05
               IF l_n>0 THEN
                  CALL cl_err('',-239,0)
                  LET g_skm[l_ac].skm04=g_skm_t.skm04
                  LET g_skm[l_ac].skm05=g_skm_t.skm05
                  NEXT FIELD skm04
               END IF
             END IF
             SELECT COUNT(*) INTO l_m FROM sga_file
              WHERE sga01 = g_skm[l_ac].skm05 
                AND sgaacti='Y'  
             IF l_m=0 THEN
                CALL cl_err(g_skm[l_ac].skm05,'',0)
                NEXT FIELD skm05
             END IF
             CALL i003_skm05('d')                                
          END IF 
      
        
        AFTER FIELD skm04
          IF g_skm[l_ac].skm04 IS NOT NULL THEN
                SELECT COUNT(*) INTO l_m FROM gen_file
                 WHERE gen01 = g_skm[l_ac].skm04 
                   AND genacti='Y'  
                IF l_m=0 THEN
                   CALL cl_err(g_skm[l_ac].skm04,'',0)
                   NEXT FIELD skm04
                END IF
               CALL i003_skm04('d')                                
          END IF 
          
        AFTER FIELD skm06
          IF g_skm[l_ac].skm06>1 OR g_skm[l_ac].skm06<0 THEN
            CALL cl_err(g_skm[l_ac].skm06,'ask-012',1)
            NEXT FIELD skm06
          END IF
          	          
        AFTER FIELD skm07
            IF NOT cl_null(g_skm[l_ac].skm08) AND g_skm[l_ac].skm08<g_skm[l_ac].skm07 THEN                                                                       
               CALL cl_err(g_skm[l_ac].skm08,'mfg2604',0)                       
               NEXT FIELD skm07                                               
            END IF 
            
        AFTER FIELD skm08
           IF NOT cl_null(g_skm[l_ac].skm08) THEN 
             IF  g_skm[l_ac].skm08<g_skm[l_ac].skm07 THEN
               CALL cl_err(g_skm[l_ac].skm08,'mfg2604',0)
               NEXT FIELD skm08
             END IF
           ELSE  
           END IF
            
        BEFORE DELETE
          IF g_skm_t.skm04 IS NOT NULL AND g_skm_t.skm05 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
             END IF
             IF l_lock_sw="Y"  THEN
                 CALL cl_err("",-263,1)
                 CANCEL DELETE
             END IF
             DELETE FROM skm_file
                WHERE  skm01=g_skl.skl01 AND skm03=g_skl.skl03                 
                AND skm04=g_skm_t.skm04 AND skm05=g_skm_t.skm05
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                       
                  CALL cl_err('',SQLCA.sqlcode,0)                               
                  ROLLBACK WORK
                  CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1 
             DISPLAY g_rec_b TO FORMONLY.cnt2
          END IF
          COMMIT WORK 
        
        ON ROW CHANGE 
          IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG=0
              LET g_skm[l_ac].*=g_skm_t.*
              CLOSE i003_bcl
              ROLLBACK WORK
              EXIT INPUT
          END IF
          IF l_lock_sw='Y' THEN
              CALL cl_err(g_skm[l_ac].skm04,-263,1)
              LET g_skm[l_ac].*=g_skm_t.* 
          ELSE
              UPDATE skm_file SET skm04=g_skm[l_ac].skm04,
                                  skm05=g_skm[l_ac].skm05,
                                  skm06=g_skm[l_ac].skm06,
                                  skm07=g_skm[l_ac].skm07,
                                  skm08=g_skm[l_ac].skm08
              WHERE  skm01=g_skl.skl01 AND skm03=g_skl.skl03
                     AND skm04=g_skm_t.skm04 AND skm05=g_skm_t.skm05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_skm[l_ac].*=g_skm_t.* 
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
          LET l_ac=ARR_CURR()
#         LET l_ac_t=l_ac         #FUN-D40030 mark
         
          SELECT count(*)                                                     
                 INTO l_n                                                       
                 FROM skm_file                                                  
                 WHERE skm01=g_skl.skl01                                        
                  AND  skm03=g_skl.skl03                                        
                  AND  skm04=g_skm[l_ac].skm04                                  
                  AND  skm05=g_skm[l_ac].skm05                                  
               IF l_n>1 THEN                                                    
                  CALL cl_err('',-239,0)                                        
                  LET g_skm[l_ac].skm04=g_skm_t.skm04                           
                  LET g_skm[l_ac].skm05=g_skm_t.skm05                           
                  NEXT FIELD skm04                                              
               END IF  
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
             IF p_cmd='u' THEN
                LET g_skm[l_ac].*=g_skm_t.*
             #FUN-D40030---add---str---
             ELSE
                CALL g_skm.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030---add---end---
             END IF  
          CLOSE i003_bcl
          ROLLBACK WORK
          EXIT INPUT
      END IF
          LET l_ac_t = l_ac     #FUN-D40030 add
          CLOSE i003_bcl
          COMMIT WORK
        
       AFTER INPUT
          LET l_sql="SELECT UNIQUE skm05 FROM skm_file", 
                    " WHERE skm01= '",g_skl.skl01,"' AND skm03='",
                    g_skl.skl03,"'"
          PREPARE i003_ck FROM l_sql
          DECLARE skm_ck CURSOR FOR i003_ck
          FOREACH skm_ck INTO l_skm05
          SELECT SUM(skm06) INTO l_skm06 FROM skm_file WHERE skm01=g_skl.skl01
                 AND skm03=g_skl.skl03 AND skm07<=g_today AND (skm08>=g_today OR skm08 IS NULL)
                 AND skm05=l_skm05
          IF l_skm06<>1 THEN 
             CALL cl_err('','ask-013',1)
             NEXT FIELD skm06
          END IF
          END FOREACH    
 
        ON ACTION CONTROLP
          CASE                                                                  
            WHEN INFIELD(skm04)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_gen"                           
                 LET g_qryparam.construct = "Y"                                 
                 LET g_qryparam.default1  = g_skm[l_ac].skm04 
                 CALL cl_create_qry() RETURNING g_skm[l_ac].skm04
                 CALL FGL_DIALOG_SETBUFFER(g_skm[l_ac].skm04)
                 CALL i003_skm04('d')
                 NEXT FIELD skm04
            WHEN INFIELD(skm05)
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_sga"                             
                 LET g_qryparam.construct = "Y"                                 
                 LET g_qryparam.default1  = g_skm[l_ac].skm05                   
                 CALL cl_create_qry() RETURNING g_skm[l_ac].skm05
                 CALL FGL_DIALOG_SETBUFFER(g_skm[l_ac].skm05)               
                 CALL i003_skm05('d')                                           
                 NEXT FIELD skm05
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
    
    CLOSE i003_bcl
    COMMIT WORK
#   CALL i003_delall()  #CHI-C30002 mark
    CALL i003_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i003_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM skl_file WHERE skl01=g_skl.skl01
                                AND skl03=g_skl.skl03
         INITIALIZE g_skl.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i003_delall()
#   SELECT COUNT(*) INTO g_cnt FROM skm_file
#     WHERE skm01=g_skl.skl01
#       AND skm03=g_skl.skl03
#  
#   IF g_cnt=0 THEN
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM skl_file WHERE skl01=g_skl.skl01 
#                             AND skl03=g_skl.skl03
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i003_b_askkey()                                                        
DEFINE                                                                          
    l_wc           STRING      #NO.FUN-910082
   
    CONSTRUCT l_wc ON skm04,skm05,skm06,skm07,skm08
                   FROM   s_skm[1].skm04,s_skm[1].skm05,
                          s_skm[1].skm06,s_skm[1].skm07,s_skm[1].skm08
       
        ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE CONSTRUCT
      
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF                                              
    CALL i003_b_fill(l_wc)                                                      
                                                                                
END FUNCTION             
 
FUNCTION i003_b_fill(p_wc)              #BODY FILL UP                           
DEFINE                                                                          
    p_wc           STRING      #NO.FUN-910082
    
    LET g_sql =                                                                 
       "SELECT skm04,gen02,skm05,sga02,skm06,skm07,skm08",
       " FROM skm_file,OUTER gen_file, OUTER sga_file ",
       " WHERE skm01='",g_skl.skl01,"'",
       " AND skm03='",g_skl.skl03,"'",
       " AND skm_file.skm04 = gen_file.gen01 ",
       " AND skm_file.skm05 = sga_file.sga01 "
    IF NOT cl_null(p_wc) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1 " 
    DISPLAY g_sql
 
    PREPARE i003_prepare2 FROM g_sql      #預備一下                             
    DECLARE skm_cs CURSOR FOR i003_prepare2                                     
                                                                                
    CALL g_skm.clear()                                                          
                                                                                
    LET g_cnt = 1 
  
    FOREACH skm_cs INTO g_skm[g_cnt].*   #單身 ARRAY 填充                       
        IF SQLCA.sqlcode THEN                                                   
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                             
            EXIT FOREACH                                                        
        END IF 
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN                                              
           CALL cl_err('',9035,0)                                             
           EXIT FOREACH                                                        
        END IF                                                                    
        END FOREACH                                                                 
    CALL g_skm.deleteElement(g_cnt)                                             
    LET g_rec_b=g_cnt-1                                                         
                                                                                
    DISPLAY g_rec_b TO FORMONLY.cnt2                                            
    LET g_cnt = 0                                                               
                                                                                
END FUNCTION 
                  
FUNCTION i003_bp(p_ud)                                                          
   DEFINE   p_ud   LIKE type_file.chr1
   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF
 
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_skm TO s_skm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
  
   BEFORE DISPLAY                                                            
       CALL cl_navigator_setting( g_curs_index, g_row_count )                 
                                                                                
   BEFORE ROW                                                                
       LET l_ac = ARR_CURR() 
 
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
    ON ACTION first                                                           
         CALL i003_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
    ON ACTION previous                                                        
         CALL i003_fetch('P')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY                        
    
    ON ACTION modify                                                          
         LET g_action_choice="modify"                                           
         EXIT DISPLAY
 
    ON ACTION invalid                                                         
         LET g_action_choice="invalid"                                          
         EXIT DISPLAY 
    ON ACTION jump                                                            
         CALL i003_fetch('/')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1) 
         ACCEPT DISPLAY
 
     ON ACTION next                                                            
         CALL i003_fetch('N')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1) 
         ACCEPT DISPLAY                          
      
     ON ACTION last                                                            
         CALL i003_fetch('L')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1) 
         ACCEPT DISPLAY                         
                                                                                
      ON ACTION detail                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = 1                                                           
         EXIT DISPLAY  
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY 
      ON ACTION notconfirm                                                      
         LET g_action_choice="notconfirm"                                       
         EXIT DISPLAY                                                         
      ON ACTION help                                                            
         LET g_action_choice="help"                                             
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION locale
         CALL cl_dynamic_locale()
     
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
                                                                                
      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE DISPLAY  
     
      ON ACTION exporttoexcel                                                   
         LET g_action_choice = 'exporttoexcel'                                  
         EXIT DISPLAY
         
      ON ACTION about
          CALL cl_about()
           
    END DISPLAY                                                                  
    CALL cl_set_act_visible("accept,cancel", TRUE)                               
END FUNCTION   
 
FUNCTION i003_x()                                                               
                                                                                
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   IF g_skl.skl01 IS NULL OR g_skl.skl03 IS NULL  THEN                    
      CALL cl_err("",-400,0)                                                    
      RETURN                                                                    
   END IF
   IF g_skl.skl04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF            
   BEGIN WORK                                                                   
                                                                                
   OPEN i003_crl USING g_skl.skl01, g_skl.skl03                                              
   IF STATUS THEN                                                               
      CALL cl_err("OPEN i003_crl:", STATUS, 1)                                  
      CLOSE i003_crl                                                            
      ROLLBACK WORK                                                             
      RETURN                                                                    
   END IF 
 
   FETCH i003_crl INTO g_skl.*             #鎖住將被更改或取消的資料           
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err(g_skl.skl01,SQLCA.sqlcode,0)          #資料被他人LOCK         
      ROLLBACK WORK                                                             
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_success = 'Y'                                                          
                                                                                
   CALL i003_show()
 
   IF cl_exp(0,0,g_skl.sklacti) THEN        #確認一下                           
      LET g_chr=g_skl.sklacti                                                   
      IF g_skl.sklacti='Y' THEN                                                 
         LET g_skl.sklacti='N'                                                  
      ELSE                                                                      
         LET g_skl.sklacti='Y'                                                  
      END IF                                                                    
                                                                                
      UPDATE skl_file SET sklacti=g_skl.sklacti,                                
                          sklmodu=g_user,                                       
                          skldate=g_today                                       
       WHERE skl01=g_skl.skl01 AND skl03=g_skl.skl03                                                  
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                               
         CALL cl_err3("upd","skl_file",g_skl.skl01,"",SQLCA.sqlcode,"","",1)    
         LET g_skl.sklacti=g_chr                                                
      END IF                                                                    
   END IF
   CLOSE i003_crl
   IF g_success = 'Y' THEN                                                      
      COMMIT WORK                                                               
      CALL cl_flow_notify(g_skl.skl01,'V')                                      
   ELSE                                                                         
      ROLLBACK WORK                                                             
   END IF                                                                       
                                                                                
   SELECT sklacti,sklmodu,skldate                                               
     INTO g_skl.sklacti,g_skl.sklmodu,g_skl.skldate FROM skl_file               
    WHERE skl01=g_skl.skl01 AND skl03=g_skl.skl03            
   DISPLAY BY NAME g_skl.sklacti,g_skl.sklmodu,g_skl.skldate                    
END FUNCTION
 
FUNCTION i003_u()                                                               
                                                                                
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   IF g_skl.skl01 IS NULL OR g_skl.skl03 IS NULL THEN                    
      CALL cl_err('',-400,0)                                                    
      RETURN                                                                    
   END IF                                                                       
                                                                                
   SELECT * INTO g_skl.* FROM skl_file                                          
    WHERE skl01=g_skl.skl01 AND skl03=g_skl.skl03                           
                                                                                
   IF g_skl.sklacti ='N' THEN    #檢查資料是否為無效                            
      CALL cl_err(g_skl.skl01,'mfg1000',0)                                      
      RETURN                                                                    
   END IF
 
   IF g_skl.skl04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF              
   MESSAGE ""                                                                   
   CALL cl_opmsg('u')                                                           
   LET g_skl01_t = g_skl.skl01
   LET g_skl03_t = g_skl.skl03                                                   
   BEGIN WORK                                                                   
                                                                                
   OPEN i003_crl USING g_skl.skl01, g_skl.skl03 
 
   IF STATUS THEN                                                               
      CALL cl_err("OPEN i003_crl:", STATUS, 1)                                  
      CLOSE i003_crl                                                            
      ROLLBACK WORK                                                             
      RETURN                                                                    
   END IF
  
    FETCH i003_crl INTO g_skl.*                      # 鎖住將被更改或取消的資料   
   IF SQLCA.sqlcode THEN                                                        
       CALL cl_err(g_skl.skl01,SQLCA.sqlcode,0)    # 資料被他人LOCK             
       CLOSE i003_crl                                                           
       ROLLBACK WORK                                                            
       RETURN                                                                   
   END IF                                                                       
                                                                                
   CALL i003_show()                                                             
                                                                                
   WHILE TRUE                                                                   
      LET g_skl01_t = g_skl.skl01
      LET g_skl.sklmodu=g_user                                                  
      LET g_skl.skldate=g_today                                                 
                                                                                
      CALL i003_i("u") 
 
      IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_skl.*=g_skl_t.*
            CALL i003_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
              
      IF g_skl.skl01!=g_skl01_t  THEN
         UPDATE  skl_file SET skl01=g_skl.skl01
            WHERE skl01=g_skl01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","skl_file",g_skl01_t,"",SQLCA.sqlcode,"","skl",1)
            CONTINUE WHILE
         END IF
      END IF
   
      IF g_skl.skl03!=g_skl03_t  THEN                                           
         UPDATE  skl_file SET skl03=g_skl.skl03                                 
            WHERE skl03=g_skl03_t                                               
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                            
            CALL cl_err3("upd","skl_file",g_skl03_t,"",SQLCA.sqlcode,"","skl",1)
            CONTINUE WHILE                                                      
         END IF                                                                 
      END IF        
     IF INT_FLAG THEN                                                          
         LET INT_FLAG = 0                                                       
         LET g_skl.*=g_skl_t.*                                                  
         CALL i003_show()                                                       
         CALL cl_err('','9001',0)                                               
         EXIT WHILE                                                             
      END IF                                                                    
                                                                                
      UPDATE skl_file SET skl_file.* = g_skl.*                                  
       WHERE skl01 = g_skl_t.skl01 and skl03 = g_skl_t.skl03
                                                                                
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                             
         CALL cl_err3("upd","skl_file","","",SQLCA.sqlcode,"","",1)             
         CONTINUE WHILE                                                         
      END IF                                                                    
      EXIT WHILE                                                                
   END WHILE                                                                    
                                                                                
   CLOSE i003_crl                                                               
   COMMIT WORK                                                                  
   CALL cl_flow_notify(g_skl.skl01,'U')                                         
                                                                                
END FUNCTION
  
FUNCTION i003_set_entry(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1
  
  IF p_cmd='a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("skl01,skl03",TRUE)
  END IF
END FUNCTION
 
FUNCTION i003_set_no_entry(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1
  
  IF p_cmd='u' AND g_chkey='N' AND (NOT g_before_input_done) THEN 
     CALL cl_set_comp_entry("skl01,skl03",FALSE)
  END IF                                                                        
END FUNCTION
 
FUNCTION i003_skl03(p_cmd)
   DEFINE l_ima02   LIKE ima_file.ima02,    #品名
          l_ima021  LIKE ima_file.ima021,   #規格
          l_imaacti LIKE ima_file.imaacti,
          p_cmd     like type_file.chr1
 
   LET g_errno=''
   SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
          WHERE ima01 =g_skl.skl03
            AND ima151='Y'
            AND imaacti='Y'
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                          LET l_ima02=NULL
                          LET l_ima021=NULL
        WHEN l_imaacti='N' LET g_errno='9028'
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_ima02,l_ima021 TO ima02,ima021 
   END IF
END FUNCTION
 
FUNCTION i003_skm04(p_cmd)                                                      
   DEFINE l_gen02   LIKE gen_file.gen02,    #員工姓名                               
          l_genacti LIKE gen_file.genacti,                                      
          p_cmd     like type_file.chr1                                         
                                                                                
   LET g_errno=''                                                               
   SELECT gen02 INTO l_gen02 FROM gen_file                        
          WHERE gen01=g_skm[l_ac].skm04                                               
                                                                                
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'                            
                          LET l_gen02=NULL                                      
        WHEN l_genacti='N' LET g_errno='9028'                                   
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'           
   END CASE                                                                     
   
   IF cl_null(g_errno) OR p_cmd='d' THEN 
   LET g_skm[l_ac].gen02=l_gen02
   END IF
END FUNCTION 
 
FUNCTION i003_skm05(p_cmd)                                                      
   DEFINE l_sga02   LIKE sga_file.sga02,    #員工姓名                           
          l_sgaacti LIKE sga_file.sgaacti,                                      
          p_cmd     like type_file.chr1                                         
                                                                                
   LET g_errno=''                                                               
   SELECT sga02 INTO l_sga02 FROM sga_file                                      
          WHERE sga01=g_skm[l_ac].skm05                                         
                                                                                
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'                            
                          LET l_sga02=NULL                                      
        WHEN l_sgaacti='N' LET g_errno='9028'                                   
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'           
   END CASE                     
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
   LET g_skm[l_ac].sga02=l_sga02
   END IF                                              
END FUNCTION     
 
FUNCTION i003_show_pic() 
  DEFINE l_chr   LIKE type_file.chr1                                                       
      LET l_chr='N'                                                             
      IF g_skl.skl04='Y' THEN                                               
         LET l_chr="Y"                                                          
      END IF                                                                    
      CALL cl_set_field_pic1(l_chr,"","","","",g_skl.sklacti,"","")             
END FUNCTION
 
FUNCTION i003_confirm()
  IF cl_null(g_skl.skl01) OR cl_null(g_skl.skl03) THEN                      
     CALL cl_err('',-400,0)                                                     
     RETURN                                                                     
   END IF                                                
#CHI-C30107 ------------------ add ------------------ begin                       
    IF g_skl.skl04="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_skl.sklacti="N" THEN
       CALL cl_err("",'aim-153',1)
    END IF
   IF NOT cl_confirm('aap-222') THEN  RETURN END IF
   SELECT * INTO g_skl.* FROM skl_file WHERE skl01 = g_skl.skl01
                                         AND skl03 = g_skl.skl03
#CHI-C30107 ------------------ add ------------------ end
    IF g_skl.skl04="Y" THEN                                                 
       CALL cl_err("",9023,1)                                                   
       RETURN                                                                   
    END IF   
    IF g_skl.sklacti="N" THEN                                                   
       CALL cl_err("",'aim-153',1)                                              
    ELSE                                                                        
#       IF cl_confirm('aap-222') THEN                           #CHI-C30107 mark                
            BEGIN WORK                                                          
            UPDATE skl_file                                                     
            SET skl04="Y"                                                   
            WHERE skl01=g_skl.skl01
              AND skl03=g_skl.skl03
        IF SQLCA.sqlcode THEN                                                   
            CALL cl_err3("upd","skl_file",g_skl.skl01,"",SQLCA.sqlcode,"","skl04",1)                                                                        
            ROLLBACK WORK                                                       
        ELSE                                                                    
            COMMIT WORK                                                         
            LET g_skl.skl04="Y"                                             
            DISPLAY BY NAME g_skl.skl04                                     
        END IF                                                                  
#       END IF                       #CHI-C30107 mark                                           
     END IF                                                                     
END FUNCTION
 
 
FUNCTION i003_notconfirm()                                                      
   IF cl_null(g_skl.skl01) OR cl_null(g_skl.skl03) THEN
     CALL cl_err('',-400,0)                                                     
     RETURN                                                                     
   END IF
   
   SELECT COUNT(*) INTO g_cnt FROM sko_file
    WHERE sko02 = g_skl.skl01
    IF g_cnt >0 THEN
        CALL cl_err(g_skl.skl01,'ask-055',0)
        RETURN
    END IF 
                                                                          
   IF g_skl.skl04="N" OR g_skl.sklacti="N" THEN                            
      CALL cl_err("",'atm-365',1)                                            
   ELSE                                                                        
     IF cl_confirm('aap-224') THEN                                           
            BEGIN WORK                                                          
            UPDATE skl_file                                                     
            SET skl04="N"                                                       
            WHERE skl01=g_skl.skl01                                             
              AND skl03=g_skl.skl03                                             
        IF SQLCA.sqlcode THEN                                                   
            CALL cl_err3("upd","skl_file",g_skl.skl01,"",SQLCA.sqlcode,"","skl04",1)                                                                            
            ROLLBACK WORK                                                       
        ELSE
            COMMIT WORK                                                         
            LET g_skl.skl04="N"                                                 
            DISPLAY BY NAME g_skl.skl04                                         
        END IF                                                                  
      END IF                                                                  
   END IF                                                                     
END FUNCTION  
 
FUNCTION i003_out()
  DEFINE l_cmd  LIKE type_file.chr1000   
 
     IF cl_null(g_wc) AND NOT cl_null(g_skl01) THEN                         
        LET g_wc = " skl01 = '",g_skl01,"'"                                 
     END IF                                                                     
     IF g_wc IS NULL THEN                                                       
        CALL cl_err('','9057',0)                                                
        RETURN                                                                  
     END IF                                                                     
     LET l_cmd = 'p_query "aski003" "',g_wc CLIPPED,'"'                         
     CALL cl_cmdrun(l_cmd)      
END FUNCTION             
#No.FUN-9C0072 精簡程式碼
