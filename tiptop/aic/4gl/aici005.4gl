# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: aici005.4gl                                                  
# Descriptions...: ICD料件BIN資料維護作業                                   
# Date & Author..: 07/11/12 #No.FUN-7B0016 By ve007
# Modify.........: 08/04/20 FUN-840096 By ve007  7B0016 debug
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0022 09/11/05 By xiaofeizhu 標準SQL修改
# Modify.........: No:TQC-9B0154 09/11/19 By sherry BUG修改
# Modify.........: No:TQC-9B0154 09/11/19 By sherry BUG修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30027 10/05/10 By jan 新增icf07欄位
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:FUN-AB0025 11/11/10 By lixh1  開窗BUG處理
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B30178 11/08/17 By fengrui 新增同時將數據插入bmm_file表中，供abmi608抓取數據
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds                                                                     
                                                                                
GLOBALS "../../config/top.global"                                               
                                                                                
DEFINE
    g_icf01          LIKE icf_file.icf01,
    g_icf01_t        LIKE icf_file.icf01,
    g_icf            DYNAMIC ARRAY OF RECORD
                     icf02        LIKE icf_file.icf02,
                     icf03        LIKE icf_file.icf03,
                     icf07        LIKE icf_file.icf07,  #FUN-A30027
                     icf04        LIKE icf_file.icf04,
                     icf05        LIKE icf_file.icf05,
                     icf06        LIKE icf_file.icf06
                     END RECORD,
    g_icf_t          RECORD                                    
                     icf02        LIKE icf_file.icf02,
                     icf03        LIKE icf_file.icf03,
                     icf07        LIKE icf_file.icf07,  #FUN-A30027
                     icf04        LIKE icf_file.icf04,
                     icf05        LIKE icf_file.icf05,
                     icf06        LIKE icf_file.icf06
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
   
   IF NOT s_industry('icd') THEN                                                                                                    
     CALL cl_err('','aic-999',1)                                                                                                    
     EXIT PROGRAM                                                                                                                   
   END IF 
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)              
         RETURNING g_time                                                       
   LET g_icf01 = NULL                     #清除鍵值                             
   LET g_icf01_t = NULL
 
   LET p_row = 5 LET p_col = 25                                                 
   OPEN WINDOW i005_w AT p_row,p_col WITH FORM "aic/42f/aici005"                
   ATTRIBUTE (STYLE = g_win_style CLIPPED)                                      
                                                                                
   CALL cl_ui_init()
   
   CALL i005_menu()                                                             
     	                                                                      
   CLOSE WINDOW i005_w                    #結束畫面                             
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)              
         RETURNING g_time                                                       
END MAIN 
 
FUNCTION i005_cs()                                                              
                                                                                
   CLEAR FORM                             #清除畫面                             
   LET g_icf01=NULL                                                             
   CALL g_icf.clear()                                                           
                                                                                
      CONSTRUCT g_wc  ON icf01,icf.icf02,icf.icf03,icf07,  #FUN-A30027
                         icf.icf04,icf.icf05,icf.icf06
                    FROM icf01,s_icf[1].icf02,s_icf[1].icf03,s_icf[1].icf07, #FUN-A30027
                         s_icf[1].icf04,s_icf[1].icf05,s_icf[1].icf06
                                                                                
         ON ACTION controlp                                                     
            CASE                                                                
               WHEN INFIELD(icf01)                                              
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()                                        
               #   LET g_qryparam.form ="q_imaicd"                                 
               #   LET g_qryparam.state ="c"
               #   #LET g_qryparam.where="imaicd04 in('1','2','3')"  #TQC-9B0154 mark
               #   LET g_qryparam.where="imaicd04 in('0','1','2','3','4')"    #TQC-9B0154 add
               #   LET g_qryparam.default1 = g_icf01                             
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   CALL q_sel_ima( TRUE, "q_imaicd","imaicd04 in('0','1','2','3','4')","g_icf01","","","","","",'')  RETURNING  g_qryparam.multiret #FUN-AB0025
                  CALL q_sel_ima( TRUE, "q_imaicd","imaicd04 in('0','1','2','3','4')",g_icf01,"","","","","",'')  RETURNING  g_qryparam.multiret    #FUN-AB0025
                  DISPLAY g_qryparam.multiret TO icf01
                  NEXT FIELD icf01
              #FUN-A30027--begin--add------
               WHEN INFIELD(icf07)                                              
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()                                        
               #   LET g_qryparam.form ="q_ima"                                 
               #   LET g_qryparam.state ="c"
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO icf07
                  NEXT FIELD icf07
              #FUN-A30027--end--add-------
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
 
      LET g_sql=" SELECT UNIQUE icf01 FROM icf_file",
                " WHERE ",g_wc CLIPPED,
                " ORDER BY icf01 "
  
  PREPARE i005_prepare FROM g_sql                                               
  DECLARE i005_cs                                                               
          SCROLL CURSOR WITH HOLD FOR i005_prepare
 
  # 取合乎條件筆數
 
    LET g_sql=" SELECT COUNT(DISTINCT icf01) ",
              " FROM icf_file WHERE ",g_wc CLIPPED
  
  PREPARE i005_pp FROM g_sql                                                    
  DECLARE i005_count   CURSOR FOR i005_pp
 
END FUNCTION                                                                    
                                                                                
FUNCTION i005_menu()
DEFINE l_cmd    STRING
                                                            
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_icf),'','')
            END IF
 
         WHEN "output"                                                        
            IF cl_chk_act_auth() THEN
              IF cl_null(g_wc2) THEN                                            
                  LET g_wc2=" 1=1"                                             
               END IF                                                
               LET l_cmd='p_query aici005 "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
            END IF                                                              
           
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i005_copy()
            END IF
                                                                                
         WHEN "help"                                                          
            CALL cl_show_help()                                                 
                                                                                
         WHEN "exit"                                                          
            EXIT WHILE                                                          
                                                                                
         WHEN "controlg"                                                      
            CALL cl_cmdask()  
         
         WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF g_icf01 IS NOT NULL THEN
                 LET g_doc.column1 = "icf01"
                 LET g_doc.value1 = g_icf01
                 CALL cl_doc()
              END IF 
           END IF                                                    
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION
       
FUNCTION i005_a()                                                               
                                                                                
   MESSAGE ""                                                                   
   CLEAR FORM                                                                   
   CALL g_icf.clear()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
 
   LET g_icf01 = NULL                                                           
   LET g_icf01_t = NULL
   
   CALL cl_opmsg('a')                                                           
                                                                                
    WHILE TRUE                                                                  
       CALL i005_i("a")                   #輸入單頭                             
       IF INT_FLAG THEN                   #使用者不玩了   
          DISPLAY '' TO FORMONLY.ima02               
          LET INT_FLAG = 0                                                      
          CALL cl_err('',9001,0)                                                
          EXIT WHILE                                                            
       END IF                                                                   
       IF cl_null(g_icf01) THEN                                                 
          CONTINUE WHILE                                                        
       END IF                
       IF SQLCA.sqlcode THEN                                                    
          CALL cl_err(g_icf01,SQLCA.sqlcode,1)  #FUN-B80083 ADD
          ROLLBACK WORK                                                         
         # CALL cl_err(g_icf01,SQLCA.sqlcode,1)  #FUN-B80083   MARK                              
          CONTINUE WHILE                                                        
       ELSE                                                                     
          COMMIT WORK                                                           
       END IF
 
       CALL g_icf.clear()                                                       
       LET g_rec_b = 0                                                          
       DISPLAY g_rec_b TO FORMONLY.cn2                                          
                                                                                
       CALL i005_b()                      #輸入單身                             
                                                                                
       LET g_icf01_t = g_icf01            #保留舊值                             
       EXIT WHILE                                                               
    END WHILE                                                                   
    LET g_wc=' '                                                                
                                                                                
END FUNCTION
 
FUNCTION i005_i(p_cmd)                                                          
DEFINE                                                                          
   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改                    
   l_n             LIKE type_file.num5,
   l_success       LIKE type_file.chr1  
                                                                               
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   DISPLAY  g_icf01  TO icf01                                     
   INPUT  g_icf01 WITHOUT DEFAULTS  FROM icf01                    
      AFTER FIELD icf01                       #部門編號                         
         IF NOT cl_null(g_icf01) THEN                                           
            SELECT COUNT(DISTINCT icf01) INTO l_n FROM icf_file   
             WHERE icf01=g_icf01                                              
            IF l_n>0 then                                                       
               CALL cl_err(g_icf01,-239,0)                                      
               NEXT FIELD icf01                                                 
            END IF
            CALL i005_icf01_chk()  RETURNING l_success
            IF l_success='N' THEN
               NEXT FIELD icf01
            END IF  
         END IF
         CALL i005_icf01('a')
   
       ON ACTION controlp                                                       
         CASE                                                                   
            WHEN INFIELD(icf01)                                                 
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()                                           
            #   LET g_qryparam.form ="q_imaicd" 
            #   #LET g_qryparam.where ="imaicd04 in ('1','2','3')"     #TQC-9B0154 mark
            #   LET g_qryparam.where="imaicd04 in('0','1','2','3','4')"    #TQC-9B0154 add
            #   LET g_qryparam.default1 = g_icf01
            #   CALL FGL_DIALOG_SETBUFFER(g_icf01)                               
            #   CALL cl_create_qry() RETURNING g_icf01                           
               CALL q_sel_ima(FALSE, "q_imaicd", "imaicd04 in('0','1','2','3','4')", g_icf01, "", "", "", "" ,"",'' )  RETURNING g_icf01
#FUN-AA0059 --End--
               DISPLAY g_icf01 TO icf01                                         
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
      WHEN 'N' FETCH NEXT     i005_cs INTO g_icf01                      
      WHEN 'P' FETCH PREVIOUS i005_cs INTO g_icf01                      
      WHEN 'F' FETCH FIRST    i005_cs INTO g_icf01                      
      WHEN 'L' FETCH LAST     i005_cs INTO g_icf01                     
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
         FETCH ABSOLUTE g_jump i005_cs INTO g_icf01                             
         LET mi_no_ask = FALSE                                                  
   END CASE 
 
   LET g_succ='Y'                                                               
   IF SQLCA.sqlcode THEN                         #有麻煩                        
      CALL cl_err(g_icf01,SQLCA.sqlcode,0)                                      
      INITIALIZE g_icf01 TO NULL                                                
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
   LET g_icf01_t = g_icf01
   DISPLAY g_icf01 TO icf01  
   CALL i005_icf01('d')
   CALL i005_b_fill(g_wc)                 #單身                                 
                                                                                
   CALL cl_show_fld_cont()                                                      
END FUNCTION 
 
FUNCTION i005_r()                                                               
                                                                                
   IF s_shut(0) THEN RETURN END IF        #檢查權限                             
                                                                                
   IF g_icf01 IS NULL THEN                                                      
      CALL cl_err("",-400,0)                                                    
      RETURN                                                                    
   END IF 
 
   BEGIN WORK
   
   IF cl_delh(0,0) THEN                   #確認一下                             
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "icf01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_icf01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM icf_file WHERE icf01 = g_icf01                                
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("del","icf_file",g_icf01,"",SQLCA.sqlcode,"","BODY DELETE",0)
      ELSE                                                                      
         CLEAR FORM                                                             
         CALL g_icf.clear()                                                     
         LET g_icf01 = NULL                                                     
                                                                                
         OPEN i005_count                                                        
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i005_cs
             CLOSE i005_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i005_count INTO g_row_count                                      
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i005_cs
             CLOSE i005_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt                                    
         OPEN i005_cs                                                           
         IF g_curs_index = g_row_count + 1 THEN                                 
            LET g_jump = g_row_count                                            
            CALL i005_fetch('L')                                                
         ELSE 
            LET g_jump = g_curs_index                                           
            LET mi_no_ask = TRUE                                                
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
   l_m             LIKE type_file.num5,
   l_str           string
                                                                   
   LET g_action_choice = ""                                                     
   IF s_shut(0) THEN RETURN END IF           #檢查權限                          
   IF g_icf01 IS NULL THEN                                                      
      RETURN                                                                    
   END IF 
 
   CALL cl_opmsg('b')                                                           
                                                                                
   LET g_forupd_sql = "SELECT icf02,icf03,icf07,icf04,icf05,icf06 FROM icf_file ", #FUN-A30027
                      " WHERE  icf01=? AND icf02=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i005_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR                  
                                                                                
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")                          
                                                                                
   INPUT ARRAY g_icf WITHOUT DEFAULTS FROM s_icf.*                              
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
            LET g_icf_t.* = g_icf[l_ac].*      #BACKUP                          
            LET p_cmd='u'                                                       
            OPEN i005_cl USING g_icf01,g_icf[l_ac].icf02 
            IF STATUS THEN
                 CALL cl_err("OPEN i005_cl:", STATUS, 1)
               LET l_lock_sw = "Y"                                              
            ELSE                                                                
               FETCH i005_cl INTO g_icf[l_ac].*                                 
               IF SQLCA.sqlcode THEN                                            
                  CALL cl_err(g_icf_t.icf02,SQLCA.sqlcode,1)                    
                  LET l_lock_sw = "Y"                                           
               END IF                                                           
            END IF                                                              
            CALL cl_show_fld_cont()                                             
         END IF                                                                 
                                                                                
      BEFORE INSERT                                                             
         LET l_n = ARR_COUNT()                                                  
         LET p_cmd='a'                                                          
         INITIALIZE g_icf[l_ac].* TO NULL 
         LET g_icf_t.* = g_icf[l_ac].*         #新輸入資料
         LET g_icf[l_ac].icf04='N'
         LET g_icf[l_ac].icf05='0'                       
         NEXT FIELD icf02                                                       
                                                                                
      AFTER INSERT                                                              
         IF INT_FLAG THEN                                                       
            CALL cl_err('',9001,0)                                              
            LET INT_FLAG = 0                                                    
            CANCEL INSERT                                                       
         END IF                                                                 
         INSERT INTO icf_file(icf01,icf02,icf03,icf04,icf05,icf06,icf07)  #FUN-A30027     
              VALUES(g_icf01,g_icf[l_ac].icf02,g_icf[l_ac].icf03,      
                     g_icf[l_ac].icf04,g_icf[l_ac].icf05,g_icf[l_ac].icf06,
                     g_icf[l_ac].icf07)   #FUN-A30027
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("ins","icf_file",g_icf01,g_icf[l_ac].icf02,SQLCA.sqlcode,"","",0)
            CANCEL INSERT                                                       
         ELSE                                                                   
            IF NOT i005_bmm_ins() THEN CANCEL INSERT          #FUN-B30178--將相關數據插入bmm_file表中--
            ELSE 
               MESSAGE 'INSERT O.K'                                                
               LET g_rec_b=g_rec_b+1                                               
               DISPLAY g_rec_b TO FORMONLY.cn2                                     
               COMMIT WORK                                                         
            END IF                
         END IF
         
      BEFORE FIELD icf02
       IF g_icf[l_ac].icf02!=g_icf_t.icf02 OR g_icf_t.icf02 IS NULL THEN 
#         SELECT MAX(substr(icf02,4,5))+1 INTO l_m FROM icf_file                        #TQC-9B0022 Mark
          SELECT MAX(icf02[4,8])+1 INTO l_m FROM icf_file                               #TQC-9B0022 Add
            WHERE icf01=g_icf01
         IF cl_null(l_m) THEN 
            LET l_str='01'
         ELSE     
            LET l_str=l_m USING '&&'
         END IF   
         LET g_icf[l_ac].icf02='BIN',l_str 
      END IF
      
      AFTER FIELD icf02
         IF NOT cl_null(g_icf[l_ac].icf02) THEN
            IF g_icf[l_ac].icf02[1,3] != 'BIN' THEN
               CALL cl_err(g_icf[l_ac].icf02,'sub-005',0)
               LET g_icf[l_ac].icf02 = g_icf_t.icf02
               NEXT FIELD icf02
            END IF
            IF LENGTH(g_icf[l_ac].icf02) < 5 THEN
               CALL cl_err(g_icf[l_ac].icf02,'aic-006',0)
               LET g_icf[l_ac].icf02 = g_icf_t.icf02
               NEXT FIELD icf02
            END IF
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_icf[l_ac].icf02 != g_icf_t.icf02) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM icf_file
                 WHERE icf01 = g_icf01
                   AND icf02 = g_icf[l_ac].icf02
                 IF l_n > 0 THEN
                    CALL cl_err(g_icf[l_ac].icf02,'-239',0)
                    LET g_icf[l_ac].icf02 = g_icf_t.icf02
                    NEXT FIELD icf02
                 END IF
             END IF
         END IF
 
      AFTER FIELD icf04 
         IF NOT cl_null(g_icf[l_ac].icf04) THEN
            IF g_icf[l_ac].icf04 NOT MATCHES'[YN]' THEN
               NEXT FIELD icf04
            END IF
         END IF
 
      AFTER FIELD icf05 
         IF NOT cl_null(g_icf[l_ac].icf05) THEN
            IF g_icf[l_ac].icf05 NOT MATCHES'[012]' THEN
               NEXT FIELD icf05
            END IF
         END IF
 
      #FUN-A30027--begin--add--------
      AFTER FIELD icf07 
         IF NOT cl_null(g_icf[l_ac].icf07) THEN
           #FUN-AA0059 -----------------add start--------------
            IF NOT s_chk_item_no(g_icf[l_ac].icf07,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD icf07
            END IF 
           #FUN-AA0059 -----------------add end---------------- 
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM ima_file
             WHERE ima01 = g_icf[l_ac].icf07
               AND imaacti = 'Y'
            IF l_n =0 THEN
               CALL cl_err('','abm-202',1)
               NEXT FIELD icf07
            END IF
         END IF
      #FUN-A30027--end--add--------

      BEFORE DELETE
         IF g_icf_t.icf02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw="Y" THEN
               CALL cl_err("", -263, 1)                                         
               CANCEL DELETE                                                    
            END IF 
            DELETE FROM icf_file
               WHERE icf02=g_icf_t.icf02 AND icf01=g_icf01
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_icf_t.icf02,SQLCA.sqlcode,0)
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
            LET g_icf[l_ac].* = g_icf_t.*                                       
            CLOSE i005_cl             
         ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF                                                                 
         IF l_lock_sw = 'Y' THEN                                                
            CALL cl_err(g_icf[l_ac].icf02,-263,1)                               
            LET g_icf[l_ac].* = g_icf_t.*                                       
         ELSE                                                                   
            UPDATE icf_file SET icf02 = g_icf[l_ac].icf02,
                                icf03 = g_icf[l_ac].icf03,
                                icf07 = g_icf[l_ac].icf07,  #FUN-A30027
                                icf04 = g_icf[l_ac].icf04,
                                icf05 = g_icf[l_ac].icf05,
                                icf06 = g_icf[l_ac].icf06 
             WHERE icf01=g_icf01
               AND icf02=g_icf_t.icf02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","icf_file",g_icf01,g_icf[l_ac].icf02,SQLCA.sqlcode,"","",0)
              LET g_icf[l_ac].* = g_icf_t.*
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
               LET g_icf[l_ac].* = g_icf_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_icf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE i005_cl                                                       
            ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF                                                                 
         LET l_ac_t = l_ac #FUN-D40030 add
         CLOSE i005_cl                                                          
         COMMIT WORK                                                            
                                                                                
      ON ACTION CONTROLR                                                        
         CALL cl_show_req_fields()                                              
                                                                                
      ON ACTION CONTROLG                                                        
         CALL cl_cmdask()   
          
      #FUN-A30027--begin--add--
      ON ACTION controlp
         CASE
           WHEN INFIELD(icf07) #料件編號                                                                                         
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()                                                                                             
              #   LET g_qryparam.form ="q_ima"                                                                                       
              #   LET g_qryparam.default1 = g_icf[l_ac].icf07                                                                        
              #   CALL cl_create_qry() RETURNING g_icf[l_ac].icf07
                  CALL q_sel_ima(FALSE, "q_ima", "", g_icf[l_ac].icf07, "", "", "", "" ,"",'' )  RETURNING g_icf[l_ac].icf07
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_icf[l_ac].icf07
                 NEXT FIELD icf07
         END CASE
      #FUN-A30027--end--add-----

      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE INPUT                                                         
                                                                                
      ON ACTION about                                                           
         CALL cl_about()                                                        
                                                                                
      ON ACTION help                                                            
         CALL cl_show_help()               
 
   END INPUT                                                                    
                                                                                
   CLOSE i005_cl                                                                
   COMMIT WORK                                                                  
   CALL i005_delall()
                                                                                
END FUNCTION 
 
FUNCTION i005_delall()
    SELECT COUNT(*) INTO g_cnt  FROM icf_file
      WHERE icf01=g_icf01
    
    IF g_cnt=0 THEN
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
    END IF
 
END FUNCTION
 
FUNCTION i005_b_fill(p_wc)              #BODY FILL UP                           
                                                                                
   DEFINE 
       #p_wc  LIKE type_file.chr1000 
       p_wc   STRING         #NO.FUN-910082             
                                                                                
   LET g_sql = "SELECT icf02,icf03,icf07,icf04,icf05,icf06 ",    #FUN-A30027
               " FROM icf_file ",                           
               " WHERE icf01 = '",g_icf01 CLIPPED,"' ", 
               " ORDER BY icf02"                                   
   PREPARE i005_prepare2 FROM g_sql      #預備一下                              
   DECLARE icf_cs CURSOR FOR i005_prepare2                                      
                                                                                
   CALL g_icf.clear()                                                           
   LET g_cnt = 1                                                                
   LET g_rec_b=0                                                                
                                                                                
   FOREACH icf_cs INTO g_icf[g_cnt].*   #單身 ARRAY 填充                        
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
   CALL g_icf.deleteElement(g_cnt)                                              
                                                                                
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
    DISPLAY g_icf01 TO icf01               #單頭                                 
                                                                                
    CALL cl_set_act_visible("accept,cancel", FALSE)                             
    DISPLAY ARRAY g_icf TO s_icf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)          
                                                                                
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
        
        ON ACTION related_document
           LET g_action_choice = "related_document"
           EXIT DISPLAY
                                                                         
        AFTER DISPLAY                                                             
           CONTINUE DISPLAY                                                       
                                                                                
    END DISPLAY                                                                 
    CALL cl_set_act_visible("accept,cancel", TRUE)                              
                                                                                
END FUNCTION  
 
FUNCTION i005_icf01(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_ima02   LIKE ima_file.ima02,                                       
           l_imaicd04 LIKE imaicd_file.imaicd04     
                                 
   LET g_errno=' '                                                              
   SELECT ima02,imaicd04 INTO l_ima02,l_imaicd04  FROM ima_file,imaicd_file                   
         WHERE ima01 = g_icf01
           AND ima01 = imaicd00
                                                                       
   CASE WHEN SQLCA.sqlcode =100                LET g_errno='mfg3008'                         
        #WHEN l_imaicd04 NOT MATCHES '[0,1,2,4]'  LET g_errno = 'aic-800'      #TQC-9B0154 mark
        WHEN l_imaicd04 NOT MATCHES '[01234]'  LET g_errno = 'aic-800'     #TQC-9B0154 add                    
        OTHERWISE                              LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       DISPLAY l_ima02 TO FORMONLY.ima02
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i005_copy()
   DEFINE l_icf01     LIKE icf_file.icf01
   DEFINE l_oicf01    LIKE icf_file.icf01
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_success   LIKE type_file.chr1    
 
   IF s_shut(0) THEN RETURN END IF
   
   IF (g_icf01 IS NULL)  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   DISPLAY ' ' TO FORMONLY.ima02
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_icf01 FROM icf01  
   
   AFTER FIELD icf01
       IF NOT cl_null(l_icf01) THEN
          SELECT COUNT(*) INTO l_n  FROM icf_file
            WHERE icf01=l_icf01
          IF l_n>0 THEN
             CALL cl_err(l_icf01,'atm-310',1) 
          END IF                                       
          CALL i005_icf01_chk()  RETURNING l_success
          IF l_success='N' THEN
            NEXT FIELD icf01
          END IF     
       ELSE
          NEXT FIELD icf01
       END IF           
       
       ON ACTION controlp
            CASE
              WHEN INFIELD(icf01)
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()                                           
            #   LET g_qryparam.form     ="q_imaicd" 
            #   #LET g_qryparam.where = "imaicd04 IN ('1','2','3')"     #TQC-9B0154 mark
            #   LET g_qryparam.where = "imaicd04 IN ('0','1','2','3','4')" #TQC-9B0154 add
            #   CALL cl_create_qry() RETURNING l_icf01
               CALL q_sel_ima(FALSE, "q_imaicd", "imaicd04 IN ('0','1','2','3','4')", "" , "", "", "", "" ,"",'' )  RETURNING l_icf01
#FUN-AA0059 --End--
               DISPLAY l_icf01 TO icf01  
               NEXT FIELD icf01                                    
               OTHERWISE EXIT CASE
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
      LET INT_FLAG = 0
      DISPLAY BY NAME g_icf01
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM icf_file         #單頭複製
     WHERE icf01=g_icf01
     INTO TEMP y
 
   UPDATE y
     SET icf01=l_icf01  
 
   INSERT INTO icf_file SELECT * FROM y
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","icf_file","","",SQLCA.sqlcode,"","",1)  #FUN-B80083 ADD
      ROLLBACK WORK
      #CALL cl_err3("ins","icf_file","","",SQLCA.sqlcode,"","",1)  #FUN-B80083 MARK
      RETURN
   ELSE
      COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_icf01,') O.K'
 
   LET l_oicf01 = g_icf01
 
   SELECT icf01 INTO g_icf01 FROM icf_file WHERE icf01 = l_icf01
   CALL i005_b()
   #SELECT icf01 INTO g_icf01 FROM icf_file WHERE icf01 = l_oicf01  #FUN-C30027
   #CALL i005_show()  #FUN-C30027
 
END FUNCTION	
 
FUNCTION i005_icf01_chk()
DEFINE l_success  LIKE type_file.chr1,
       l_ima01    LIKE ima_file.ima01,
       l_imaacti  LIKE ima_file.imaacti,
       l_imaicd04 LIKE imaicd_file.imaicd04 
     
     LET l_success = 'Y'
     SELECT ima01,imaacti,imaicd04
       INTO l_ima01,l_imaacti,l_imaicd04
       FROM ima_file,imaicd_file 
       WHERE ima01=g_icf01
        AND  ima01=imaicd00
     IF SQLCA.sqlcode=100 THEN
        CALL cl_err(g_icf01,'aic-004',0)
        LET l_success='N'
     END IF 
     IF l_imaacti='N' THEN
        CALL cl_err(g_icf01,'aic-020',0)
        LET l_success='N'
     END IF
     #IF l_imaicd04 NOT MATCHES '[0,1,2,4]' OR l_imaicd04 IS NULL  THEN  #TQC-9B0154 mark
     IF l_imaicd04 NOT MATCHES '[01234]' OR l_imaicd04 IS NULL  THEN  #TQC-9B0154 add
        CALL cl_err(g_icf01,'aic-021',0)
        LET l_success='N'
     END IF 
    
     RETURN l_success                                #No.FUN-840096
END FUNCTION      
#FUN-B30178---新增同時將數據插入bmm_file表中，供abmi608抓取數據---add--Begin--
FUNCTION i005_bmm_ins()
DEFINE l_n        LIKE type_file.num5,
       l_bmm01    LIKE bmm_file.bmm01,
       l_bmm02    LIKE bmm_file.bmm02,
       l_bmm03    LIKE bmm_file.bmm03,
       l_bmm04    LIKE bmm_file.bmm04,
       l_bmm05    LIKE bmm_file.bmm05,
       l_imaacti  LIKE ima_file.imaacti

       LET l_n = 0
       LET l_bmm01 = g_icf01
       LET l_bmm03 = g_icf[l_ac].icf07
       LET l_bmm05 = 'Y'
       SELECT COUNT(*) INTO l_n FROM bma_file
          WHERE bma01=l_bmm01
       IF l_n > = 1 THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM bmm_file
             WHERE bmm01=l_bmm01 AND bmm02= l_bmm02
          IF l_n = 0 THEN
             SELECT MAX(bmm02)+1 INTO l_bmm02 FROM bmm_file
                WHERE bmm01 = l_bmm01
             IF l_bmm02 IS NULL THEN LET l_bmm02 = 1 END IF
             SELECT ima55,imaacti INTO l_bmm04,l_imaacti
                FROM ima_file WHERE ima01 = l_bmm03
             INSERT INTO bmm_file(bmm01,bmm02,bmm03,bmm04,bmm05)
                VALUES(l_bmm01,l_bmm02,l_bmm03,l_bmm04,l_bmm05)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","bmm_file",l_bmm01,l_bmm02,SQLCA.sqlcode,"","",1)
                RETURN FALSE
             END IF
          END IF
       END IF
       RETURN TRUE
END FUNCTION
#FUN-B30178---新增同時將數據插入bmm_file表中，供abmi608抓取數據---add--End----
#No.FUN-7B0016

