# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: aici012.4gl                                                  
# Descriptions...: ICD料件正背印維護作業                                    
# Date & Author..: 07/11/14 By zhoufeng No.FUN-7B0078
# Modify.........: No.TQC-830049 08/03/25 By sherry 查出資料,進入單身,備注顯示錯誤，下一筆備注會帶出下一筆備注 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改
# Modify.........: No:TQC-C40125 12/04/18 By fengrui 調用lib函數運行此程式，如果有參數則先查詢
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds                                                                     
                                                                                
GLOBALS "../../config/top.global"                                               
                                                                                
DEFINE
    g_icl01          LIKE icl_file.icl01,
    g_icl01_t        LIKE icl_file.icl01,
    g_icl            DYNAMIC ARRAY OF RECORD
                     icl02        LIKE icl_file.icl02,
                     icl03        LIKE icl_file.icl03,
                     icl04        LIKE icl_file.icl04,
                     icl05        LIKE icl_file.icl05
                     END RECORD,
    g_icl_t          RECORD                                    
                     icl02        LIKE icl_file.icl02,
                     icl03        LIKE icl_file.icl03,
                     icl04        LIKE icl_file.icl04,
                     icl05        LIKE icl_file.icl05
                     END RECORD,                  
    g_argv1             LIKE icl_file.icl01,
    g_wc                STRING,                                                 
    g_sql               STRING,                                                 
    g_rec_b             LIKE type_file.num5,         #單身筆數
    g_succ              LIKE type_file.chr1,
    l_ac                LIKE type_file.num5,         #目前處理的ARRAY CNT
    g_ss                LIKE type_file.chr1 
DEFINE   p_row,p_col    LIKE type_file.num5
DEFINE   g_forupd_sql   STRING                  
DEFINE   g_before_input_done  LIKE type_file.num5                               
DEFINE   g_cnt          LIKE type_file.num10                                    
DEFINE   g_chr          LIKE type_file.chr1 
DEFINE   g_i            LIKE type_file.num5
DEFINE   g_msg          LIKE type_file.chr1000                                  
DEFINE   g_curs_index   LIKE type_file.num10                                    
DEFINE   g_row_count    LIKE type_file.num10                                    
DEFINE   g_jump         LIKE type_file.num10                                    
DEFINE   mi_no_ask      LIKE type_file.num5 
 
MAIN                                                                            
   DEFINE  l_time      LIKE type_file.chr8                                  
                                                                                
   OPTIONS                                           #改變一些系統預設值        
      INPUT NO WRAP
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理 
 
   IF (NOT cl_user()) THEN                                                      
      EXIT PROGRAM                                                              
   END IF                                                                       
                                                                                
   WHENEVER ERROR CALL cl_err_msg_log                                           
                                                                                
   IF (NOT cl_setup("AIC")) THEN                                                
      EXIT PROGRAM                                                              
   END IF
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM                                                              
   END IF    
   
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)              
         RETURNING g_time                                                       
   LET g_argv1 = ARG_VAL(1)
   LET g_icl01 = NULL                     #清除鍵值                             
   LET g_icl01_t = NULL
   LET g_icl01 = g_argv1
 
   LET p_row = 5 LET p_col = 25                                                 
   OPEN WINDOW i012_w AT p_row,p_col WITH FORM "aic/42f/aici012"                
   ATTRIBUTE (STYLE = g_win_style CLIPPED)                                      
                                                                                
   CALL cl_ui_init()
   
   #TQC-C40125--add--str--
   IF NOT cl_null(g_argv1) THEN
      CALL i012_q()
   END IF
   #TQC-C40125--add--end--

   CALL i012_menu()                                                             
     	                                                                             
   CLOSE WINDOW i012_w                    #結束畫面                             
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)              
         RETURNING g_time                                                       
END MAIN 
 
FUNCTION i012_curs()                                                              
                                                                                
   CLEAR FORM                             #清除畫面                             
   LET g_icl01=NULL                                                             
   CALL g_icl.clear()                                                           
   IF cl_null(g_argv1) THEN                                                                               
      CONSTRUCT BY NAME g_wc ON icl01,icl02,icl03,icl04,icl05
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()               
                                                                                
         ON ACTION controlp                                                     
            CASE                                                                
               WHEN INFIELD(icl01)                                              
#FUN-AA0059 --Begin--
              #    CALL cl_init_qry_var()                                        
              #    LET g_qryparam.form ="q_ima"                                  
              #    LET g_qryparam.state ="c"
              #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--                  
                  DISPLAY g_qryparam.multiret TO icl01 
                  NEXT FIELD icl01
            END CASE
   
      ON IDLE g_idle_seconds                                                 
         CALL cl_on_idle()                                                   
         CONTINUE CONSTRUCT                                                  
                                                                                
      ON ACTION about                                                           
         CALL cl_about()
 
      ON ACTION controlg                                                        
         CALL cl_cmdask()                                                       
                                                                                
      ON ACTION help                                                 
         CALL cl_show_help()
 
      ON ACTION qbe_select                                                   
         CALL cl_qbe_select()                                                
                                                                                
      ON ACTION qbe_save                                                     
         CALL cl_qbe_save()
 
     END CONSTRUCT                                                              
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('icluser', 'iclgrup') #FUN-980030
                                                                                
     IF INT_FLAG THEN RETURN END IF                                             
   ELSE                                                                         
      LET g_wc = "icl01 = '",g_argv1,"'"                                    
   END IF  
 
   LET g_sql= "SELECT UNIQUE icl01 FROM icl_file ",                      
              " WHERE ", g_wc CLIPPED,                                          
              " ORDER BY icl01"                                                     
   PREPARE i012_prepare FROM g_sql                                                                                
   DECLARE i012_b_curs
      SCROLL CURSOR WITH HOLD FOR i012_prepare
 
END FUNCTION                                                                    
                                                                                
FUNCTION i012_count()
DEFINE l_icl   DYNAMIC ARRAY of RECORD
                 icl01 LIKE icl_file.icl01
               END RECORD
DEFINE l_cnt   LIKE type_file.num10 
DEFINE l_rec_b LIKE type_file.num10 
 
   LET g_sql= "SELECT UNIQUE icl01 FROM icl_file ",
              " WHERE ", g_wc CLIPPED,                                          
              " GROUP BY icl01 ORDER BY icl01"
                                                                                
   PREPARE i012_precount FROM g_sql                                        
   DECLARE i012_count CURSOR FOR i012_precount                        
   LET l_cnt=1                                                                 
   LET l_rec_b=0                                                               
   FOREACH i012_count INTO l_icl[l_cnt].*                                 
       LET l_rec_b = l_rec_b + 1                                              
       IF SQLCA.sqlcode THEN                                                    
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                               
          LET l_rec_b = l_rec_b - 1                                           
          EXIT FOREACH
       END IF                                                                   
       LET l_cnt = l_cnt + 1                                                  
    END FOREACH                                                                 
    LET g_row_count=l_rec_b                                                    
                                                                                
END FUNCTION 
 
FUNCTION i012_menu()   
DEFINE p_cmd    LIKE type_file.chr1                                                         
   WHILE TRUE                                                                   
     CALL i012_bp("G")                                                          
     CASE g_action_choice                                                       
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i012_q()                                                    
            END IF
 
         WHEN "insert"                                                        
            IF cl_chk_act_auth() THEN                                           
                CALL i012_a(p_cmd)                                                   
            END IF
 
         WHEN "modify"                                                        
            IF cl_chk_act_auth() THEN                                           
               CALL i012_u()                                                    
            END IF
           
          WHEN "delete"                                                        
            IF cl_chk_act_auth() THEN                                           
                CALL i012_r()                                                   
            END IF 
 
           WHEN "detail"                                                        
            IF cl_chk_act_auth() THEN                                           
                CALL i012_b()                                                   
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
                                                                                
           WHEN "exporttoexcel"                                                 
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_icl),'','')                                                             
            END IF
 
           WHEN "output"                                                        
            IF cl_chk_act_auth()                                                
               THEN CALL i012_out()                                             
            END IF                                                              
           
            WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i012_copy()
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
       
FUNCTION i012_a(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1                                                               
                                                                                
   MESSAGE ""                                                                   
   CLEAR FORM         
   INITIALIZE g_icl01 LIKE icl_file.icl01
   LET g_icl01_t = NULL                                                          
   
   CALL cl_opmsg('a')                                                           
                                                                                
    WHILE TRUE
       CALL i012_set_entry('a')                                                            
       CALL i012_i("a")                   #輸入單頭                             
       IF INT_FLAG THEN                   #使用者不玩了                         
          LET g_icl01 = NULL
          LET INT_FLAG = 0                                                      
          CALL cl_err('',9001,0)                                                
          EXIT WHILE                                                            
       END IF               
       LET g_rec_b =0
       IF g_ss = 'N' THEN
          CALL g_icl.clear()
       ELSE
          CALL i012_b_fill('1=1')
       END IF
                                                          
       CALL i012_b()                      #輸入單身                             
                                                                                
       LET g_icl01_t = g_icl01            #保留舊值                             
       EXIT WHILE                                                               
    END WHILE                                                                   
                                                                                
END FUNCTION
 
FUNCTION i012_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
#  IF g_chkey = 'N' THEN
#     CALL cl_err(g_icl01,'aoo-085',0)
#     RETURN
#  END IF
 
   IF cl_null(g_icl01) THEN                                                     
      CALL cl_err('',-400,0)                                                    
      RETURN                                                                    
   END IF                                                                       
                                                                                
   MESSAGE ""                                                                   
   CALL cl_opmsg('u')                                                           
   LET g_icl01_t = g_icl01
 
   BEGIN WORK
 
   CALL i012_show()
   WHILE TRUE                                                                   
      CALL i012_i("u")                      #欄位更改                           
                                                                                
      IF INT_FLAG THEN                                                          
         LET g_icl01=g_icl01_t                                                  
         DISPLAY g_icl01 TO icl01           #單頭                               
         CALL i012_icl01('d')
         LET INT_FLAG = 0                                                       
         CALL cl_err('',9001,0)                                                 
         EXIT WHILE                                                             
      END IF 
 
       IF g_icl01 != g_icl01_t THEN                  #更改單頭值                 
         UPDATE icl_file SET icl01 = g_icl01        #更新DB                     
          WHERE icl01 = g_icl01_t                   #COLAUTH?                   
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("upd","icl_file",g_icl01_t,"",SQLCA.sqlcode,"","",1)   
            CONTINUE WHILE                                                      
         END IF                                                                 
      END IF                                                                    
      EXIT WHILE                                                                
   END WHILE                                                                    
                                                                                
END FUNCTION
 
FUNCTION i012_i(p_cmd)                                                          
DEFINE                                                                          
   p_cmd           LIKE type_file.chr1       #a:輸入 u:更改                    
 
   LET g_ss='Y'
   INPUT g_icl01 
       WITHOUT DEFAULTS FROM icl01
   BEFORE INPUT 
       IF p_cmd = 'u' THEN
              CALL	i012_set_no_entry('u')
       END IF    
      
      AFTER FIELD icl01        #料件編號
           #FUN-AA0059 -----------------add start-----------------
           IF NOT cl_null(g_icl01) THEN
              IF NOT s_chk_item_no(g_icl01,'') THEN
                 CALL cl_err('',g_errno,1)
                 LET g_icl01 = g_icl01_t
                 NEXT FIELD icl01
              END IF
            END IF
           #FUN-AA0059 -----------------add end-------------------- 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_icl01 != g_icl01_t) THEN
               SELECT UNIQUE icl01 INTO g_chr
                 FROM icl_file
                WHERE icl01 = g_icl01
               IF SQLCA.sqlcode THEN 
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_icl01,-239,0)
                     LET g_icl01 = g_icl01_t
                     NEXT FIELD icl01
                  END IF
               END IF
            END IF
            CALL i012_icl01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_icl01,g_errno,0)
               LET g_icl01 = g_icl01_t
               NEXT FIELD icl01
            END IF
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(icl01)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form ="q_ima"
             #  LET g_qryparam.default1 = g_icl01
             #  CALL cl_create_qry() RETURNING g_icl01
               CALL q_sel_ima(FALSE, "q_ima", "", g_icl01, "", "", "", "" ,"",'' )  RETURNING g_icl01
#FUN-AA0059 --End--
               DISPLAY BY NAME g_icl01
               NEXT FIELD icl01
            OTHERWISE EXIT CASE
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
                                                                                
FUNCTION i012_q()
 
   LET g_row_count = 0                                                          
   LET g_curs_index = 0                                                         
   CALL cl_navigator_setting(g_curs_index,g_row_count)                          
 
   MESSAGE ""
   CALL cl_opmsg('q')
                                                                                
   CALL i012_curs()                     #取得查詢條件                             
                                                                                
   IF INT_FLAG THEN                   #使用者不玩了                             
      LET INT_FLAG = 0
      INITIALIZE g_icl01 TO NULL
      RETURN
   END IF
 
   OPEN i012_b_curs                    #從DB產生合乎條件TEMP(0-30秒)            
   IF SQLCA.sqlcode THEN               #有問題                                  
      CALL cl_err('',SQLCA.sqlcode,0)                                           
      INITIALIZE g_icl01 TO NULL
   ELSE              
      CALL i012_count()
      DISPLAY g_row_count TO FORMONLY.cnt                                                           
      CALL i012_fetch('F')             #讀出TEMP第一筆并顯示                    
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i012_fetch(p_flag)                                                     
DEFINE                                                                          
   p_flag      LIKE type_file.chr1,    #處理方式                                
   l_abso      LIKE type_file.num10    #絕對的筆數                              
                                                                                
   MESSAGE ""                                                                   
   CASE p_flag                                                                  
      WHEN 'N' FETCH NEXT     i012_b_curs INTO g_icl01                      
      WHEN 'P' FETCH PREVIOUS i012_b_curs INTO g_icl01                      
      WHEN 'F' FETCH FIRST    i012_b_curs INTO g_icl01                      
      WHEN 'L' FETCH LAST     i012_b_curs INTO g_icl01                     
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
         FETCH ABSOLUTE g_jump i012_b_curs INTO g_icl01                             
         LET mi_no_ask = FALSE                                                  
   END CASE 
   
   LET g_succ='Y'                                                               
   IF SQLCA.sqlcode THEN                         #有麻煩                        
      CALL cl_err(g_icl01,SQLCA.sqlcode,0)                                      
      INITIALIZE g_icl01 TO NULL                                                
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
      CALL i012_show()                                                          
   END IF                                                                       
                                                                                
END FUNCTION 
 
FUNCTION i012_show()                                                            
   LET g_icl01_t = g_icl01
   DISPLAY g_icl01 TO icl01     
   CALL i012_icl01('d')
   CALL i012_b_fill(g_wc)                 #單身                                 
                                                                                
   CALL cl_show_fld_cont()                                                      
END FUNCTION 
 
FUNCTION i012_r()                                                               
                                                                                
   IF s_shut(0) THEN RETURN END IF        #檢查權限                             
                                                                                
   IF g_icl01 IS NULL THEN                                                      
      CALL cl_err("",-400,0)                                                    
      RETURN                                                                    
   END IF 
 
   BEGIN WORK
   
   IF cl_delh(0,0) THEN                   #確認一下                             
      DELETE FROM icl_file WHERE icl01 = g_icl01                                
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("del","icl_file",g_icl01,"",SQLCA.sqlcode,"","BODY DELETE",0)                                                                             
      ELSE                                                                      
         CLEAR FORM                                                             
         CALL g_icl.clear()                                                     
         LET g_icl01 = NULL                                                     
          CALL i012_count()                                                                               
#         OPEN i012_count                                                        
#         FETCH i012_count INTO g_row_count                                      
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i012_b_curs
             CLOSE i012_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt                                    
         OPEN i012_b_curs                                                           
         IF g_curs_index = g_row_count + 1 THEN                                 
            LET g_jump = g_row_count                                            
            CALL i012_fetch('L')                                                
         ELSE 
            LET g_jump = g_curs_index                                           
            LET mi_no_ask = TRUE                                                
            CALL i012_fetch('/')                                                
         END IF                                                                 
         LET g_cnt=SQLCA.SQLERRD[3]                                             
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'                      
      END IF                                                                    
   END IF                                                                       
                                                                                
   COMMIT WORK                                                                  
                                                                                
END FUNCTION
 
FUNCTION i012_b()                                                               
DEFINE                                                                          
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT                 
   l_n             LIKE type_file.num5,      #檢查重復用                        
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否                        
   p_cmd           LIKE type_file.chr1,      #處理狀態                          
   l_allow_insert  LIKE type_file.num5,      #可新增否                          
   l_allow_delete  LIKE type_file.num5,       #可刪除否                          
   l_m             LIKE type_file.num5,
   l_icl           RECORD LIKE icl_file.*
                                                                   
   LET g_action_choice = ""                                                     
   IF s_shut(0) THEN RETURN END IF           #檢查權限                          
   IF g_icl01 IS NULL THEN                                                      
      RETURN                                                                    
   END IF 
 
   CALL cl_opmsg('b')                                                           
                                                                                
   LET g_forupd_sql = "SELECT icl02,icl03,icl04,icl05 ",
                      " FROM icl_file ",
                      #" WHERE  icl01=? AND icl02=? FOR UPDATE "            #No.TQC-830049    
                      " WHERE  icl01=? AND icl02=? AND icl03=? FOR UPDATE " #No.TQC-830049
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i012_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR                  
                                                                                
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")                          
                                                                                
   INPUT ARRAY g_icl WITHOUT DEFAULTS FROM s_icl.*                              
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
            LET g_icl_t.* = g_icl[l_ac].*      #BACKUP                          
            LET p_cmd='u'                                                       
            #OPEN i012_cl USING g_icl01,g_icl[l_ac].icl02     #No.TQC-830049
            OPEN i012_cl USING g_icl01,g_icl[l_ac].icl02,g_icl[l_ac].icl03 #No.TQC-830049
            IF STATUS THEN
                 CALL cl_err("OPEN i012_cl:", STATUS, 1)
               LET l_lock_sw = "Y"                                              
            ELSE                                                                
               FETCH i012_cl INTO g_icl[l_ac].*                                 
               IF SQLCA.sqlcode THEN                                            
                  CALL cl_err(g_icl_t.icl02,SQLCA.sqlcode,1)                    
                  LET l_lock_sw = "Y"                                           
               ELSE 
                  LET g_icl_t.*=g_icl[l_ac].*
               END IF                                                           
            END IF                                                              
            CALL cl_show_fld_cont()                                             
         END IF                                                                 
                                                                                
      BEFORE INSERT                                                             
         LET l_n = ARR_COUNT()                                                  
         LET p_cmd='a'                                                          
         INITIALIZE g_icl[l_ac].* TO NULL 
         LET g_icl_t.* = g_icl[l_ac].*         #新輸入資料
         LET g_icl[l_ac].icl04='N'
         LET g_icl[l_ac].icl02='1'                       
         NEXT FIELD icl02                                                       
                                                                                
      AFTER INSERT                                                              
         IF INT_FLAG THEN                                                       
            CALL cl_err('',9001,0)                                              
            LET INT_FLAG = 0                                                    
            CANCEL INSERT                                                       
         END IF  
           LET l_icl.icl01 = g_icl01
           LET l_icl.icl02 = g_icl[l_ac].icl02
           LET l_icl.icl03 = g_icl[l_ac].icl03
           LET l_icl.icl04 = g_icl[l_ac].icl04
           LET l_icl.icl05 = g_icl[l_ac].icl05
           LET l_icl.icluser  = g_user
           LET l_icl.iclgrup  = g_grup
           LET l_icl.iclmodu  = ''
           LET l_icl.iclacti  = 'Y'
           LET l_icl.icldate  = g_today                                       
         LET l_icl.icloriu = g_user      #No.FUN-980030 10/01/04
         LET l_icl.iclorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO icl_file     
              VALUES(l_icl.*)
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("ins","icl_file",g_icl01,g_icl[l_ac].icl02,SQLCA.sqlcode,"","",0)
            CANCEL INSERT                                                       
         ELSE                                                                   
            MESSAGE 'INSERT O.K'                                                
            LET g_rec_b=g_rec_b+1                                               
            DISPLAY g_rec_b TO FORMONLY.cn2                                     
            COMMIT WORK                                                         
         END IF
      AFTER FIELD icl02
         IF NOT cl_null(g_icl[l_ac].icl02) THEN
            IF g_icl[l_ac].icl02 NOT MATCHES'[1234]' THEN
               NEXT FIELD icl02
            END IF
         END IF
 
      AFTER FIELD icl03
         IF NOT cl_null(g_icl[l_ac].icl03) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND(
               g_icl[l_ac].icl02 != g_icl_t.icl02 OR
               g_icl[l_ac].icl03 != g_icl_t.icl03)) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM icl_file
                WHERE icl01 = g_icl01
                  AND icl02 = g_icl[l_ac].icl02
                  AND icl03 = g_icl[l_ac].icl03
               IF l_n > 0 THEN
                  CALL cl_err(g_icl[l_ac].icl03,'-239',0)
                  LET g_icl[l_ac].icl03 = g_icl_t.icl03
                  NEXT FIELD icl03
               END IF
            END IF
         END IF
 
      AFTER FIELD icl04
         IF NOT cl_null(g_icl[l_ac].icl04) THEN
            IF g_icl[l_ac].icl04 NOT MATCHES'[YN]' THEN
               NEXT FIELD icl04
            END IF
         END IF         
 
      BEFORE DELETE
           IF NOT cl_null(g_icl_t.icl02) AND
              NOT cl_null(g_icl_t.icl03) THEN
              IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
              END IF
              IF l_lock_sw="Y" THEN
               CALL cl_err("", -263, 1)                                         
               CANCEL DELETE                                                    
              END IF 
                DELETE FROM icl_file
                   WHERE icl02=g_icl_t.icl02 
                     AND icl01=g_icl01
                     AND icl03=g_icl_t.icl03
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_icl_t.icl02,SQLCA.sqlcode,0)
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
            LET g_icl[l_ac].* = g_icl_t.*                                       
            CLOSE i012_cl             
         ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF                                                                 
         IF l_lock_sw = 'Y' THEN                                                
            CALL cl_err(g_icl[l_ac].icl02,-263,1)                               
            LET g_icl[l_ac].* = g_icl_t.*                                       
         ELSE                                                                   
            UPDATE icl_file SET icl02 = g_icl[l_ac].icl02,
                                icl03 = g_icl[l_ac].icl03,
                                icl04 = g_icl[l_ac].icl04,
                                icl05 = g_icl[l_ac].icl05,
                               iclmodu= g_user,
                               icldate= g_today
             WHERE icl01=g_icl01
               AND icl02=g_icl_t.icl02
               AND icl03=g_icl_t.icl03
         IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","icl_file",g_icl01,g_icl[l_ac].icl02,SQLCA.sqlcode,"","",0)
               LET g_icl[l_ac].* = g_icl_t.*
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
               LET g_icl[l_ac].* = g_icl_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_icl.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE i012_cl                                                       
            ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF                                                                 
         LET l_ac_t = l_ac #FUN-D40030  add
         CLOSE i012_cl                                                          
         COMMIT WORK  
 
      ON ACTION CONTROLO
         IF INFIELD(icl02) AND l_ac > 1 THEN
            LET g_icl[l_ac].* = g_icl[l_ac-1].*
            DISPLAY BY NAME g_icl[l_ac].*
            NEXT FIELD icl02
         END IF                                                          
                                                                                
      ON ACTION CONTROLR                                                        
         CALL cl_show_req_fields()                                              
                                                                                
      ON ACTION CONTROLG                                                        
         CALL cl_cmdask()   
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
           RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE INPUT                                                         
                                                                                
      ON ACTION about                                                           
         CALL cl_about()                                                        
                                                                                
      ON ACTION help                                                            
         CALL cl_show_help()               
 
   END INPUT                                                                    
                                                                                
   CLOSE i012_cl                                                                
   COMMIT WORK                                                                  
                                                                                
END FUNCTION 
 
 
FUNCTION i012_b_fill(p_wc)              #BODY FILL UP                           
                                                                                
   DEFINE 
      #p_wc  LIKE type_file.chr1000  
      p_wc   STRING       #NO.FUN-910082           
                                                                                
   LET g_sql = "SELECT icl02,icl03,icl04,icl05 ",   
               " FROM icl_file ",                           
               " WHERE icl01 = '",g_icl01 CLIPPED,"' ", 
               " AND ",p_wc CLIPPED,
               " ORDER BY icl02,icl03"                                   
   PREPARE i012_prepare2 FROM g_sql      #預備一下                              
   DECLARE icl_cs CURSOR FOR i012_prepare2                                      
                                                                                
   CALL g_icl.clear()                                                           
   LET g_cnt = 1                                                                
   LET g_rec_b=0                                                                
                                                                                
   FOREACH icl_cs INTO g_icl[g_cnt].*   #單身 ARRAY 填充                        
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
   CALL g_icl.deleteElement(g_cnt)                                              
                                                                                
   LET g_rec_b = g_cnt - 1                                                      
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0       #No.TQC-830049                                                                             
END FUNCTION                                                                    
                                                                                
FUNCTION i012_bp(p_ud)                                                          
    DEFINE p_ud            LIKE type_file.chr1
  
    IF p_ud <> "G" OR g_action_choice = "detail" THEN                           
        RETURN                                                                  
    END IF                                                                      
                                                                                
    LET g_action_choice = " "                                                   
   DISPLAY g_icl01 TO icl01               #單頭                                 
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                             
   DISPLAY ARRAY g_icl TO s_icl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)          
                                                                                
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
       
#       ON ACTION invalid                                                        
#          LET g_action_choice="invalid"                                         
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
           CALL i012_fetch('F')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
           ACCEPT DISPLAY                                                       
                                                                                
        ON ACTION previous                                                      
           CALL i012_fetch('P')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
        ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION jump                                                          
           CALL i012_fetch('/')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF 
           ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION next                                                          
           CALL i012_fetch('N')                                                 
           CALL cl_navigator_setting(g_curs_index, g_row_count)                 
           IF g_rec_b != 0 THEN                                                 
           CALL fgl_set_arr_curr(1)                                             
           END IF                                                               
        ACCEPT DISPLAY                                                          
                                                                                
        ON ACTION last                                                          
           CALL i012_fetch('L')                                                 
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
 
FUNCTION i012_icl01(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_ima02   LIKE ima_file.ima02,                                       
           l_imaacti LIKE ima_file.imaacti                                      
   LET g_errno=' '                                                              
   SELECT ima02,imaacti INTO l_ima02,l_imaacti  FROM ima_file                   
         WHERE ima01=g_icl01                                                
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                         
        WHEN l_imaacti='N'        LET g_errno='9028'                            
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       DISPLAY l_ima02 TO FORMONLY.ima02
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i012_copy()
   DEFINE l_icl01     LIKE icl_file.icl01
   DEFINE l_oicl01    LIKE icl_file.icl01
   DEFINE li_result   LIKE type_file.num5,
          l_ima02     LIKE ima_file.ima02,
          l_imaacti   LIKE ima_file.imaacti,
          l_n         LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
   
   IF (g_icl01 IS NULL)  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   DISPLAY ' ' TO icl01 
   INPUT l_icl01 FROM icl01  
   
   AFTER FIELD icl01
         IF NOT cl_null(l_icl01) THEN 
           #FUN-AA0059 -----------------add start------------------
            IF NOT s_chk_item_no(l_icl01,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD icl01
            END IF
           #FUN-AA0059 -----------------add end-------------------- 
            LET l_n=0                                   
            SELECT COUNT(*) INTO l_n FROM ima_file
                  WHERE ima01=l_icl01  
              IF l_n<=0  THEN
                 CALL cl_err(l_icl01,'smy-002',0)
                 NEXT FIELD icl01
              END IF  
         ELSE
               NEXT FIELD icl01
         END IF           
         SELECT ima02,imaacti INTO l_ima02,l_imaacti
           FROM ima_file
          WHERE ima01 = l_icl01
          IF SQLCA.sqlcode THEN
             CALL cl_err('','mfg0002',0)
             NEXT FIELD icl01
          END IF
          IF l_imaacti != 'Y' THEN
             CALL cl_err(l_icl01,'9028',0)
             NEXT FIELD icl01
          END IF
          DISPLAY l_ima02 TO FORMONLY.ima02
       
       ON ACTION controlp
            CASE
              WHEN INFIELD(icl01)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()                                           
             #  LET g_qryparam.form  ="q_ima"   
             #  LET g_qryparam.default1 = g_icl01                                                       
             #  CALL cl_create_qry() RETURNING l_icl01                                                    
               CALL q_sel_ima(FALSE, "q_ima", "", g_icl01, "", "", "", "" ,"",'' )  RETURNING l_icl01
#FUN-AA0059 --End--
               DISPLAY BY NAME g_icl01  
               NEXT FIELD icl01                                    
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
      DISPLAY BY NAME g_icl01
      CALL i012_icl01('d')
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM icl_file         #單身複製
       WHERE icl01=g_icl01
       INTO TEMP y
 
   UPDATE y SET
                 icl01 = l_icl01 
 
   INSERT INTO icl_file SELECT * FROM y
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","icl_file","","",SQLCA.sqlcode,"","",1)  #FUN-B80083 ADD
      ROLLBACK WORK
     # CALL cl_err3("ins","icl_file","","",SQLCA.sqlcode,"","",1)  #FUN-B80083 MARK
      RETURN
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_icl01,') O.K'
 
   LET l_oicl01 = g_icl01
 
   SELECT icl01 INTO g_icl01 FROM icl_file WHERE icl01 = l_icl01
   CALL i012_u()
   CALL i012_b()
   #SELECT icl01 INTO g_icl01 FROM icl_file WHERE icl01 = l_oicl01  #FUN-C30027
   #CALL i012_show() #FUN-C30027
 
END FUNCTION	
 
FUNCTION i012_out()
  DEFINE  l_i          LIKE type_file.chr1, 
          sr           RECORD
               icl01   LIKE icl_file.icl01,
               icl02   LIKE icl_file.icl02,
               icl03   LIKE icl_file.icl03,
               icl04   LIKE icl_file.icl04,
               icl05   LIKE icl_file.icl05,
               ima02   LIKE ima_file.ima02
                       END RECORD,
          l_name       LIKE type_file.chr20,
          l_za05       LIKE type_file.chr1000,
          l_str        STRING 
 
   IF g_wc IS NULL THEN                                                        
       CALL cl_err('',-400,0)                                                   
       RETURN                                                                   
    END IF                                                                      
    CALL cl_wait()                                                              
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang                 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aici012'
  
    LET g_sql="SELECT icl01,icl02,icl03,icl04,icl05,ima02",
              " FROM icl_file,ima_file ",
              " WHERE icl01 = ima01 AND ",g_wc CLIPPED
    
    IF g_zz05 = 'Y' THEN                                                       
        CALL cl_wcchp(g_wc,'icl01,icl02,icl03,icl04,icl05')                    
        RETURNING g_wc                                                          
     END IF
    LET l_str = g_wc
    CALL cl_prt_cs1('aici012','aici012',g_sql,l_str)   
 
END FUNCTION       
 
FUNCTION i012_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("icl01",TRUE)
     END IF
END FUNCTION
 
FUNCTION i012_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       call cl_set_comp_entry("icl01",FALSE)
    END IF
END FUNCTION 
#No.FUN-7B0078 Create the program
