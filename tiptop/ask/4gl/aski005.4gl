# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aski005.4gl                                                  
# Descriptions...: 款式版片基本資料維護作業                                    
# Date & Author..: 07/08/09 By hongmei FUN-810016 FUN-840178 FUN-870117 
# Modify.........: No.FUN-8A0145 08/10/31 By arman 
# Modify.........: No.TQC-8C0056 08/12/22 By alex 修改LOCK CURSOR串接REF table問題
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No:FUN-D40030 13/04/07 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds                                                                     
                                                                                
GLOBALS "../../config/top.global"                                               
                                                                                
DEFINE
    g_skp01          LIKE skp_file.skp01,
    g_skp01_t        LIKE skp_file.skp01,
    g_skp            DYNAMIC ARRAY OF RECORD
                     skp02        LIKE skp_file.skp02,     #版片序號
                     skp03        LIKE skp_file.skp03,     #元件料號
                     ima02a       LIKE ima_file.ima02,     #品名
                     ima021a      LIKE ima_file.ima021,    #規格
                     skp04        LIKE skp_file.skp04,     #部位
                     bol02        LIKE bol_file.bol02,     #部位說明 
                     skp05        LIKE skp_file.skp05      #單件片數 
                     END RECORD,
    g_skp_t          RECORD                                    
                     skp02        LIKE skp_file.skp02,                          
                     skp03        LIKE skp_file.skp03,
                     ima02a       LIKE ima_file.ima02,                          
                     ima021a      LIKE ima_file.ima021,                         
                     skp04        LIKE skp_file.skp04, 
                     bol02        LIKE bol_file.bol02,                         
                     skp05        LIKE skp_file.skp05                         
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
DEFINE   g_no_ask      LIKE type_file.num5 
 
MAIN                                                                            
   DEFINE l_sma124      LIKE sma_file.sma124                                 
                                                                                
   OPTIONS                                           #改變一些系統預設值        
      INPUT NO WRAP
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理 
 
   IF (NOT cl_user()) THEN                                                      
      EXIT PROGRAM                                                              
   END IF                                                                       
                                                                                
   WHENEVER ERROR CALL cl_err_msg_log                                           
                                                                                
   IF (NOT cl_setup("ASK")) THEN                                                
      EXIT PROGRAM                                                              
   END IF
   
   SELECT sma124 INTO l_sma124 FROM sma_file 
                                      
   IF NOT s_industry('slk') THEN
      CALL cl_err("","-1000",1)
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time                                                       
   LET g_skp01 = NULL                     #清除鍵值                             
   LET g_skp01_t = NULL
 
   OPEN WINDOW i005_w WITH FORM "ask/42f/aski005"                
      ATTRIBUTE (STYLE = g_win_style CLIPPED)                                      
                                                                                
   CALL cl_ui_init()
 
   CALL i005_menu()                                                             
                                                                                
   CLOSE WINDOW i005_w                    #結束畫面                             
   CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                       
 
END MAIN 
 
FUNCTION i005_cs()                                                              
                                                                                
   CLEAR FORM                             #清除畫面                             
   LET g_skp01=NULL                                                             
   CALL g_skp.clear()                                                           
                                                                                
      CONSTRUCT BY NAME g_wc ON skp01                                     
                                                                                
      ON ACTION controlp                                                     
         CASE                                                                
           WHEN INFIELD(skp01)   
#FUN-AA0059---------mod------------str-----------------                                           
#          CALL cl_init_qry_var()                                        
#          LET g_qryparam.form ="q_ima_slk"                                  
#          LET g_qryparam.state ="c"                                     
#          LET g_qryparam.default1 = g_skp01                             
#          CALL cl_create_qry() RETURNING g_qryparam.multiret
           CALL q_sel_ima(TRUE, "q_ima_slk","",g_skp01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
           DISPLAY g_qryparam.multiret TO skp01 
           CALL i005_skp01('d')
           NEXT FIELD skp01                         
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
   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET g_wc=g_wc CLIPPED," AND skpuser= '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                                                          
   #      LET g_wc=g_wc CLIPPED," AND skpgrup MATCHES '",g_grup CLIPPED,"*'"                       
   #   END IF
  
    CONSTRUCT g_wc2 ON skp02,skp03,skp04,skp05
                FROM s_skp[1].skp02,s_skp[1].skp03,           
                     s_skp[1].skp04,s_skp[1].skp05 
    ON ACTION CONTROLP                                                      
          CASE                                                                  
            WHEN INFIELD(skp04)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form= "q_bol" 
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO skp04
                 NEXT FIELD skp04
            WHEN INFIELD(skp03)              
#FUN-AA0059---------mod------------str-----------------                                   
#                CALL cl_init_qry_var()                                         
#                LET g_qryparam.form      = "q_ima" 
#                LET g_qryparam.state='c'                                                             
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO skp03
                 NEXT FIELD skp03                                              
            END CASE                                      
         
    ON IDLE g_idle_seconds                                                      
       CALL cl_on_idle()                                                        
       CONTINUE CONSTRUCT                                                       
  END CONSTRUCT
 
  MESSAGE ' WAIT '                                                              
                                                                                
  IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF                                 
                                                                                
  IF g_wc2=" 1=1" THEN                                                          
      LET g_sql=" SELECT DISTINCT skp01 FROM skp_file",               
                " WHERE ",g_wc CLIPPED                                          
  ELSE                                                                          
      LET g_sql=" SELECT DISTINCT skp01 FROM skp_file",
                " WHERE ",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED
  END IF
  
  PREPARE i005_prepare FROM g_sql                                               
  DECLARE i005_cs                                                               
          SCROLL CURSOR WITH HOLD FOR i005_prepare
 
  # 取合乎條件筆數
  IF g_wc2=" 1=1" THEN                                                          
    LET g_sql=" SELECT COUNT(DISTINCT skp01) ",                              
              " FROM skp_file WHERE ",g_wc CLIPPED                        
  ELSE
    LET g_sql=" SELECT COUNT(DISTINCT skp01) ",                                 
              " FROM skp_file WHERE ",g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED
  END IF
  
  PREPARE i005_pp FROM g_sql                                                    
  DECLARE i005_count   CURSOR FOR i005_pp
 
END FUNCTION                                                                    
                                                                                
FUNCTION i005_menu()                                                            
   WHILE TRUE                                                                   
     CALL i005_bp("G")                                                          
     CASE g_action_choice                                                       
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i005_q()                                                    
            END IF
 
         WHEN "insert"                                                        
            IF cl_chk_act_auth() THEN                                           
                CALL i005_a()                                                   
            END IF
 
         WHEN "modify"                                                        
            IF cl_chk_act_auth() THEN                                           
               CALL i005_u()                                                    
            END IF
         
         WHEN "output"                                                        
            IF cl_chk_act_auth() THEN
               CALL i005_out()
            END IF
             
         WHEN "delete"                                                        
           IF cl_chk_act_auth() THEN                                           
               CALL i005_r()                                                   
           END IF                                                              
                                                                               
          WHEN "detail"                                                        
           IF cl_chk_act_auth() THEN                                           
               CALL i005_b()                                                   
           ELSE                                                                
              LET g_action_choice = NULL                                       
           END IF                                                              
                                                                               
          WHEN "exporttoexcel"                                                 
           IF cl_chk_act_auth() THEN                                           
             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_skp),'','')                                                             
           END IF
 
          WHEN "help"                                                          
           CALL cl_show_help()                                                 
                                                                               
          WHEN "exit"                                                          
           EXIT WHILE                                                          
                                                                               
          WHEN "controlg"                                                      
           CALL cl_cmdask()                                                    
     END CASE                                                                  
   END WHILE                                                                    
END FUNCTION
       
FUNCTION i005_a()                                                               
                                                                                
   MESSAGE ""                                                                   
   CLEAR FORM                                                                   
   CALL g_skp.clear()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
 
   LET g_skp01 = NULL                                                           
   LET g_skp01_t = NULL
   
   CALL cl_opmsg('a')                                                           
                                                                                
    WHILE TRUE                                                                  
       CALL i005_i("a")                   #輸入單頭                             
       IF INT_FLAG THEN                   #使用者不玩了                         
          LET INT_FLAG = 0                                                      
          CALL cl_err('',9001,0)                                                
          EXIT WHILE                                                            
       END IF                                                                   
       IF cl_null(g_skp01) THEN                                                 
          CONTINUE WHILE                                                        
       END IF                
       IF SQLCA.sqlcode THEN      
         CALL cl_err(g_skp01,SQLCA.sqlcode,1)   #FUN-B80030 ADD                                             
          ROLLBACK WORK                                                         
         # CALL cl_err(g_skp01,SQLCA.sqlcode,1) #FUN-B80030 MARK                                 
          CONTINUE WHILE                                                        
       ELSE                                                                     
          COMMIT WORK                                                           
       END IF
 
       CALL g_skp.clear()                                                       
       LET g_rec_b = 0                                                          
       DISPLAY g_rec_b TO FORMONLY.cn2                                          
                                                                                
       CALL i005_b()                      #輸入單身                             
                                                                                
       LET g_skp01_t = g_skp01            #保留舊值                             
       EXIT WHILE                                                               
    END WHILE                                                                   
    LET g_wc=' '                                                                
                                                                                
END FUNCTION
 
FUNCTION i005_u()
 
    IF cl_null(g_skp01) THEN                                                     
      CALL cl_err('',-400,0)                                                    
      RETURN                                                                    
   END IF                                                                       
                                                                                
   MESSAGE ""                                                                   
   CALL cl_opmsg('u')                                                           
   LET g_skp01_t = g_skp01
 
   WHILE TRUE                                                                   
      CALL i005_i("u")                      #欄位更改                           
                                                                                
      IF INT_FLAG THEN
         LET INT_FLAG = 0                                                       
         LET g_skp01=g_skp01_t                                                  
         DISPLAY g_skp01 TO skp01           #單頭
         CALL i005_show()                               
         CALL cl_err('',9001,0)                                                 
         EXIT WHILE                                                             
      END IF 
 
       IF g_skp01 != g_skp01_t THEN                  #更改單頭值                 
         UPDATE skp_file SET skp01 = g_skp01        #更新DB                     
          WHERE skp01 = g_skp01_t                   #COLAUTH?                   
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("upd","skp_file",g_skp01_t,"",SQLCA.sqlcode,"","",1)   
            CONTINUE WHILE                                                      
         END IF                                                                 
       END IF                                                                    
       EXIT WHILE                                                                
   END WHILE                                                                    
                                                                                
END FUNCTION
 
FUNCTION i005_i(p_cmd)                                                          
DEFINE                                                                          
   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改                    
   l_n             LIKE type_file.num5,                                          
   l_m             LIKE type_file.num5 
                                                                               
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   DISPLAY  g_skp01  TO skp01                                     
   INPUT  g_skp01 WITHOUT DEFAULTS  FROM skp01                    
      AFTER FIELD skp01                       #部門編號                         
         IF NOT cl_null(g_skp01) THEN  
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_skp01,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_skp01= g_skp01_t
               NEXT FIELD skp01
            END IF
#FUN-AA0059 ---------------------end-------------------------------                                         
#            SELECT COUNT(distinct skp01) INTO l_n FROM skp_file                              
#             WHERE skp01=g_skp01                                                
#            IF l_n>0 then                                                       
#               CALL cl_err(g_skp01,-239,0)                                      
#               NEXT FIELD skp01                                                 
#            END IF
            CALL i005_skp01('d')
            SELECT COUNT(*) INTO l_m FROM ima_file
                                    WHERE ima01= g_skp01
            IF l_m=0 THEN
               CALL cl_err(g_skp01,'ask-016',0)
               NEXT FIELD skp01
            END IF   
         END IF
         
   
       ON ACTION controlp                                                        
         CASE                                                                   
            WHEN INFIELD(skp01)      
#FUN-AA0059---------mod------------str-----------------                                           
#              CALL cl_init_qry_var()                                           
#              LET g_qryparam.form ="q_ima_slk"                                     
#              LET g_qryparam.default1 = g_skp01                                
#              CALL cl_create_qry() RETURNING g_skp01                           
               CALL q_sel_ima(FALSE, "q_ima_slk","",g_skp01,"","","","","",'' ) 
                RETURNING  g_skp01  
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_skp01 TO skp01                                         
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
                                                                                
FUNCTION i005_q()
   CALL cl_opmsg('q')                                                           
                                                                                
   LET g_row_count = 0                                                          
   LET g_curs_index = 0                                                         
   CALL cl_navigator_setting(g_curs_index,g_row_count)                          
                                                                                
   CALL i005_cs()                     #取得查詢條件                             
                                                                                
   IF INT_FLAG THEN                   #使用者不玩了                             
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i005_count                                                              
   FETCH i005_count INTO g_row_count                                            
   DISPLAY g_row_count TO FORMONLY.cnt                                          
                                                                                
   OPEN i005_cs                        #從DB產生合乎條件TEMP(0-30秒)            
   IF SQLCA.sqlcode THEN               #有問題                                  
      CALL cl_err('',SQLCA.sqlcode,0)                                           
   ELSE                                                                         
      CALL i005_fetch('F')             #讀出TEMP第一筆并顯示                    
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i005_fetch(p_flag)                                                     
DEFINE                                                                          
   p_flag      LIKE type_file.chr1,    #處理方式                                
   l_abso      LIKE type_file.num10    #絕對的筆數                              
                                                                                
   MESSAGE ""                                                                   
   CASE p_flag                                                                  
      WHEN 'N' FETCH NEXT     i005_cs INTO g_skp01                      
      WHEN 'P' FETCH PREVIOUS i005_cs INTO g_skp01                      
      WHEN 'F' FETCH FIRST    i005_cs INTO g_skp01                      
      WHEN 'L' FETCH LAST     i005_cs INTO g_skp01                     
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
         FETCH ABSOLUTE g_jump i005_cs INTO g_skp01                             
         LET g_no_ask = FALSE                                                  
   END CASE 
 
   LET g_succ='Y'                                                               
   IF SQLCA.sqlcode THEN                         #有麻煩                        
      CALL cl_err(g_skp01,SQLCA.sqlcode,0)                                      
      INITIALIZE g_skp01 TO NULL                                                
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
      CALL i005_show()                                                          
   END IF                                                                       
                                                                                
END FUNCTION 
 
FUNCTION i005_show()                                                            
   LET g_skp01_t = g_skp01
   DISPLAY g_skp01 TO skp01                                                                             
   CALL i005_skp01('d')
   CALL i005_b_fill(g_wc)                 #單身                                 
                                                                                
   CALL cl_show_fld_cont()                                                      
END FUNCTION 
 
FUNCTION i005_r()                                                               
                                                                                
   IF s_shut(0) THEN RETURN END IF        #檢查權限                             
                                                                                
   IF g_skp01 IS NULL THEN                                                      
      CALL cl_err("",-400,0)                                                    
      RETURN                                                                    
   END IF 
 
   BEGIN WORK
   
   IF cl_delh(0,0) THEN                   #確認一下                             
      DELETE FROM skp_file WHERE skp01 = g_skp01                                
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("del","skp_file",g_skp01,"",SQLCA.sqlcode,"","BODY DELETE",0)                                                                             
      ELSE                                                                      
         CLEAR FORM                                                             
         CALL g_skp.clear()                                                     
         LET g_skp01 = NULL                                                     
                                                                                
         OPEN i005_count                                                        
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i005_cs
            CLOSE i005_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i005_count INTO g_row_count                                      
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i005_cs
            CLOSE i005_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt                                    
         OPEN i005_cs                                                           
         IF g_curs_index = g_row_count + 1 THEN                                 
            LET g_jump = g_row_count                                            
            CALL i005_fetch('L')                                                
         ELSE 
            LET g_jump = g_curs_index                                           
            LET g_no_ask = TRUE                                                
            CALL i005_fetch('/')                                                
         END IF                                                                 
         LET g_cnt=SQLCA.SQLERRD[3]                                             
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'                      
      END IF                                                                    
   END IF                                                                       
                                                                                
   COMMIT WORK                                                                  
                                                                                
END FUNCTION
 
FUNCTION i005_b()                                                               
DEFINE                                                                          
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT                 
   l_n             LIKE type_file.num5,      #檢查重復用                        
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否                        
   p_cmd           LIKE type_file.chr1,      #處理狀態                          
   l_allow_insert  LIKE type_file.num5,      #可新增否                          
   l_allow_delete  LIKE type_file.num5,      #可刪除否                          
   l_m             LIKE type_file.num5
                                                                   
   LET g_action_choice = ""                                                     
   IF s_shut(0) THEN RETURN END IF           #檢查權限                          
   IF g_skp01 IS NULL THEN                                                      
      RETURN                                                                    
   END IF 
 
   CALL cl_opmsg('b')                                                           
                                                                                
#  #TQC-8C0056
#  LET g_forupd_sql = " SELECT skp02,skp03,ima02,ima021,skp04,bol02,skp05 ",
#                       " FROM skp_file,ima_file,bol_file "
#                      " WHERE ima_file.ima01(+)=skp03 ",
#                        " AND bol_file.bol01(+)=skp04 ",    #No.FUN-8A0145 
#                        " AND skp01=? AND skp02=? FOR UPDATE"            
 
   LET g_forupd_sql = " SELECT skp02,skp03,'','',skp04,'',skp05 ",
                        " FROM skp_file ",
                       " WHERE skp01 = ? AND skp02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i005_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR                  
                                                                                
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")                          
                                                                                
   INPUT ARRAY g_skp WITHOUT DEFAULTS FROM s_skp.*                              
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
            LET g_skp_t.* = g_skp[l_ac].*      #BACKUP                          
            LET p_cmd='u'                                                       
            OPEN i005_cl USING g_skp01,g_skp[l_ac].skp02                                  
            IF STATUS THEN
                 CALL cl_err("OPEN i005_cl:", STATUS, 1)                          
               LET l_lock_sw = "Y"                                              
            ELSE                                                                
               FETCH i005_cl INTO g_skp[l_ac].*                                 
               IF SQLCA.sqlcode THEN                                            
                  CALL cl_err(g_skp_t.skp02,SQLCA.sqlcode,1)                    
                  LET l_lock_sw = "Y"                                           
               ELSE
                  #TQC-8C0056
                  SELECT ima02,ima021 INTO g_skp[l_ac].ima02a,g_skp[l_ac].ima021a
                    FROM ima_file
                   WHERE ima01 = g_skp[l_ac].skp03 
                  SELECT bol02 INTO g_skp[l_ac].bol02 
                    FROM bol_file
                   WHERE bol01 = g_skp[l_ac].skp04 
                  DISPLAY BY NAME g_skp[l_ac].ima02a,g_skp[l_ac].ima021a,g_skp[l_ac].bol02 
               END IF                                                           
            END IF                                                              
            CALL cl_show_fld_cont()                                             
         END IF                                                                 
                                                                                
      BEFORE INSERT                                                             
         LET l_n = ARR_COUNT()                                                  
         LET p_cmd='a'                                                          
         INITIALIZE g_skp[l_ac].* TO NULL                                                                               
         LET g_skp_t.* = g_skp[l_ac].*         #新輸入資料                      
         NEXT FIELD skp02                                                       
                                                                                
      AFTER INSERT                                                              
         IF INT_FLAG THEN                                                       
            CALL cl_err('',9001,0)                                              
            LET INT_FLAG = 0                                                    
            CANCEL INSERT                                                       
         END IF                                                                 
          INSERT INTO skp_file(skp01,skp02,skp03,skp04,skp05)     
                       VALUES(g_skp01,g_skp[l_ac].skp02,g_skp[l_ac].skp03,      
                              g_skp[l_ac].skp04,g_skp[l_ac].skp05)                              
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("ins","skp_file",g_skp01,g_skp[l_ac].skp02,SQLCA.sqlcode,"","",0)
            CANCEL INSERT                                                       
         ELSE                                                                   
            MESSAGE 'INSERT O.K'                                                
            LET g_rec_b=g_rec_b+1                                               
            DISPLAY g_rec_b TO FORMONLY.cn2                                     
            COMMIT WORK                                                         
         END IF
 
      AFTER FIELD skp02                                                         
         IF   NOT cl_null(g_skp[l_ac].skp02) THEN
           IF g_skp[l_ac].skp02!=g_skp_t.skp02 OR g_skp_t.skp02 IS NULL THEN
              SELECT COUNT(*) INTO l_n FROM skp_file 
                 WHERE skp02=g_skp[l_ac].skp02
                   AND skp01=g_skp01
            IF l_n>0 THEN
               CALL cl_err('',-239,0)
               LET g_skp[l_ac].skp02=g_skp_t.skp02
               NEXT FIELD skp02 
            END IF                                                              
           END IF
         END IF  
         
      AFTER FIELD skp03
        IF NOT cl_null(g_skp[l_ac].skp03) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_skp[l_ac].skp03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_skp[l_ac].skp03= g_skp_t.skp03
               NEXT FIELD skp03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF p_cmd="a" OR (p_cmd="u" AND g_skp[l_ac].skp03 !=g_skp_t.skp03) THEN
                SELECT COUNT(*) INTO l_m FROM ima_file
                 WHERE ima01 = g_skp[l_ac].skp03 
                   AND imaacti='Y'  
                IF l_m=0 THEN
                   CALL cl_err(g_skp[l_ac].skp03,'ask-016',0)
                   NEXT FIELD skp03
                END IF
                CALL i005_skp03('d')       
            END IF 
        END IF
        
      AFTER FIELD skp04
        IF p_cmd="a" OR (p_cmd="u" AND g_skp[l_ac].skp04 !=g_skp_t.skp04) THEN
                SELECT COUNT(*) INTO l_m FROM bol_file
                 WHERE bol01 = g_skp[l_ac].skp04 
                   AND bolacti='Y'  
                IF l_m=0 THEN
                   CALL cl_err(g_skp[l_ac].skp04,'ask-016',0)
                   NEXT FIELD skp04
                END IF
           CALL i005_skp04('d') #No.FUN-870117  
        END IF 
        
      AFTER FIELD skp05
        IF g_skp[l_ac].skp05<0 THEN
          CALL cl_err('','aim-223',0)
          NEXT FIELD skp05
        END IF             
         
      BEFORE DELETE
           IF g_skp_t.skp02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
              END IF
              IF l_lock_sw="Y" THEN
               CALL cl_err("", -263, 1)                                         
               CANCEL DELETE                                                    
              END IF 
                DELETE FROM skp_file
                   WHERE skp02=g_skp_t.skp02 AND skp01=g_skp01
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_skp_t.skp02,SQLCA.sqlcode,0)
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
            LET g_skp[l_ac].* = g_skp_t.*                                       
            CLOSE i005_cl             
         ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF                                                                 
         IF l_lock_sw = 'Y' THEN                                                
            CALL cl_err(g_skp[l_ac].skp02,-263,1)                               
            LET g_skp[l_ac].* = g_skp_t.*                                       
         ELSE                                                                   
            UPDATE skp_file SET skp02 = g_skp[l_ac].skp02,
                                skp03 = g_skp[l_ac].skp03,
                                skp04 = g_skp[l_ac].skp04,
                                skp05 = g_skp[l_ac].skp05
             WHERE skp01=g_skp01
               AND skp02=g_skp_t.skp02
         IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","skp_file",g_skp01,g_skp[l_ac].skp02,SQLCA.sqlcode,"","",0)
               LET g_skp[l_ac].* = g_skp_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
         AFTER ROW 
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac                    #FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_skp[l_ac].* = g_skp_t.*
            #FUN-D40030---add---str---
            ELSE
               CALL g_skp.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030---add---end---
            END IF
            CLOSE i005_cl                                                       
            ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF         
         LET l_ac_t = l_ac    #FUN-D40030 add                                                        
         CLOSE i005_cl                                                          
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
            WHEN INFIELD(skp04)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form= "q_bol"                             
                 LET g_qryparam.construct = "Y"                                 
                 LET g_qryparam.default1  = g_skp[l_ac].skp04                   
                 CALL cl_create_qry() RETURNING g_skp[l_ac].skp04
                 CALL FGL_DIALOG_SETBUFFER(g_skp[l_ac].skp04)               
                 CALL i005_skp04('d')                                           
                 NEXT FIELD skp04
            WHEN INFIELD(skp03)              
#FUN-AA0059---------mod------------str-----------------                                   
#                CALL cl_init_qry_var()                                         
#                LET g_qryparam.form      = "q_ima"                             
#                LET g_qryparam.construct = "Y"                                 
#                LET g_qryparam.default1  = g_skp[l_ac].skp03                   
#                CALL cl_create_qry() RETURNING g_skp[l_ac].skp03
                 CALL q_sel_ima(FALSE, "q_ima","",g_skp[l_ac].skp03,"","","","","",'' ) 
                   RETURNING  g_skp[l_ac].skp03 
#FUN-AA0059---------mod------------end-----------------
                 CALL FGL_DIALOG_SETBUFFER(g_skp[l_ac].skp03)               
                 CALL i005_skp03('d')                                           
                 NEXT FIELD skp03                                              
            END CASE                   
 
   END INPUT                                                                    
                                                                                
   CLOSE i005_cl                                                                
   COMMIT WORK                                                                  
   CALL i005_delall()
                                                                                
END FUNCTION 
 
FUNCTION i005_delall()
    SELECT COUNT(*) INTO g_cnt  FROM skp_file
          WHERE skp01=g_skp01
    
    IF g_cnt=0 THEN
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
   END IF
 
END FUNCTION
 
FUNCTION i005_b_fill(p_wc)              #BODY FILL UP                           
                                                                                
   DEFINE
   # p_wc  LIKE type_file.chr1000 
     p_wc           STRING       #NO.FUN-910082          
                                                                                
   LET g_sql = "SELECT skp02,skp03,ima02,ima021,skp04,bol02,skp05 ",   
               " FROM skp_file,OUTER ima_file,OUTER bol_file ",                          
               " WHERE skp01 = '",g_skp01 CLIPPED,"' ",                            
               " AND bol_file.bol01=skp_file.skp04 AND ima_file.ima01=skp_file.skp03 ",  
               " ORDER BY skp02"                                                    
   PREPARE i005_prepare2 FROM g_sql      #預備一下                              
   DECLARE skp_cs CURSOR FOR i005_prepare2                                      
                                                                                
   CALL g_skp.clear()                                                           
   LET g_cnt = 1                                                                
   LET g_rec_b=0                                                                
                                                                                
   FOREACH skp_cs INTO g_skp[g_cnt].*   #單身 ARRAY 填充                        
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
   CALL g_skp.deleteElement(g_cnt)                                              
                                                                                
   LET g_rec_b = g_cnt - 1                                                      
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0                                                                
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i005_bp(p_ud)                                                          
    DEFINE p_ud            LIKE type_file.chr1
  
    IF p_ud <> "G" OR g_action_choice = "detail" THEN                           
        RETURN                                                                  
    END IF                                                                      
                                                                                
    LET g_action_choice = " "                                                   
   DISPLAY g_skp01 TO skp01               #單頭                                 
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                             
   DISPLAY ARRAY g_skp TO s_skp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)          
                                                                                
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
           CALL i005_fetch('F')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
           ACCEPT DISPLAY                                                       
                                                                                
        ON ACTION previous                                                      
           CALL i005_fetch('P')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
        ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION jump                                                          
           CALL i005_fetch('/')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF 
           ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION next                                                          
           CALL i005_fetch('N')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
        ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION last                                                          
           CALL i005_fetch('L')                                                 
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
 
FUNCTION i005_skp01(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,                                       
           l_imaacti LIKE ima_file.imaacti                                      
   LET g_errno=' '                                                              
   SELECT ima02,imaacti ima021 
     INTO l_ima02,l_ima021,l_imaacti 
     FROM ima_file                   
    WHERE ima01 = g_skp01
      AND ima151='Y'
      AND imaacti='Y'
                                                         
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                         
        WHEN l_imaacti='N'        LET g_errno='9028'                            
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       DISPLAY l_ima02 TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i005_skp03(p_cmd)                                                      
   DEFINE l_ima02   LIKE ima_file.ima02,    #員工姓名                           
          l_imaacti LIKE ima_file.imaacti,
          l_ima021  LIKE ima_file.ima021,                                      
          p_cmd     like type_file.chr1                                         
                                                                                
   LET g_errno=''                                                               
   SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file                     
          WHERE ima01=g_skp[l_ac].skp03                                         
                                                                                
                                                                                
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'                            
                          LET l_ima02=NULL
                          LET l_ima021=NULL                                       
        WHEN l_imaacti='N' LET g_errno='9028'                                   
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'            
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
   LET g_skp[l_ac].ima021a=l_ima021
   LET g_skp[l_ac].ima02a=l_ima02                                            
   END IF 
   DISPLAY l_ima02 TO FORMONLY.ima02a
   DISPLAY l_ima021 TO FORMONLY.ima021a                                                                     
END FUNCTION
 
FUNCTION i005_skp04(p_cmd)                                                      
   DEFINE l_bol02   LIKE bol_file.bol02,    #員工姓名
          l_bolacti LIKE bol_file.bolacti,                           
          p_cmd     like type_file.chr1                                         
                                                                                
   LET g_errno=''                                                               
   SELECT bol02,bolacti INTO l_bol02,l_bolacti FROM bol_file                      
          WHERE bol01=g_skp[l_ac].skp04                                         
                                                                                
                                                                                
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'                            
                          LET l_bol02=NULL                                      
        WHEN l_bolacti='N' LET g_errno='9028'                                   
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'            
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
   LET g_skp[l_ac].bol02=l_bol02                                            
   END IF 
   DISPLAY l_bol02 TO FORMONLY.bol02                                                                      
END FUNCTION
 
FUNCTION i005_out()
  DEFINE l_cmd  LIKE type_file.chr1000   
 
     IF cl_null(g_wc) AND NOT cl_null(g_skp01) THEN                         
        LET g_wc = " skp01 = '",g_skp01,"'"                                 
     END IF                                                                     
     IF g_wc IS NULL THEN                                                       
        CALL cl_err('','9057',0)                                                
        RETURN                                                                  
     END IF                                                                     
     LET l_cmd = 'p_query "aski005" "',g_wc CLIPPED,'"'                         
     CALL cl_cmdrun(l_cmd)      
END FUNCTION
#No.FUN-810016 FUN-840178 NO.FUN-870117
