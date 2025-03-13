# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: agli019.4gl
# Descriptions...: 合併財報現金變動碼維護作業
# Date & Author..: No.FUN-B70003 11/07/05 By lujh
# Modify.........: No.MOD-B80311 11/08/26 by lujh 單頭公司編號報錯訊息有誤
# Modify.........: NO.MOD-BB0262 11/11/23 By xuxz 註釋中版本號修改
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE  g_aess02             LIKE aess_file.aess02,      
        g_aess02_t           LIKE aess_file.aess02,      
        g_aess01             LIKE aess_file.aess01,  
        g_aess01_t           LIKE aess_file.aess01, 
        g_aess01_o           LIKE aess_file.aess01,
        g_aess00             LIKE aess_file.aess00,   
        g_aess00_t           LIKE aess_file.aess00,   
        g_aess00_o           LIKE aess_file.aess00,  
        
        g_aess       DYNAMIC ARRAY OF RECORD   
        aess03               LIKE aess_file.aess03,                 
        aess04               LIKE aess_file.aess04,                 
        aess05               LIKE aess_file.aess05, 
        aess06               LIKE aess_file.aess06,
        aes02                LIKE aes_file.aes02,
        aes03                LIKE aes_file.aes03,
        aess07               LIKE aess_file.aess07,   
        aess08               LIKE aess_file.aess08    
                             END RECORD,
        g_aess_t     RECORD                    #程式變數 (舊值)
        aess03               LIKE aess_file.aess03,                 
        aess04               LIKE aess_file.aess04,                 
        aess05               LIKE aess_file.aess05, 
        aess06               LIKE aess_file.aess06,
        aes02                LIKE aes_file.aes02,
        aes03                LIKE aes_file.aes03,
        aess07               LIKE aess_file.aess07,   
        aess08               LIKE aess_file.aess08
                             END RECORD,
        i                    LIKE type_file.num5,           
        g_wc,g_sql,g_wc2     STRING,       
        g_sql_tmp            STRING, 
        g_rec_b              LIKE type_file.num5,      #單身筆數        
        g_ss                 LIKE type_file.chr1,           
        g_dbs_gl             LIKE type_file.chr20,           
        g_plant_gl           LIKE type_file.chr20,           
        l_ac                 LIKE type_file.num5,      #目前處理的ARRAY CNT     
        g_cnt                LIKE type_file.num5,      #目前處理的ARRAY CNT     
        tm           RECORD 
        aess02               LIKE aess_file.aess02,       
        aess01               LIKE aess_file.aess01, 
        aess00               LIKE aess_file.aess00,             
        y                    LIKE type_file.chr1              
                             END RECORD
DEFINE  g_forupd_sql         STRING                    #SELECT ... FOR UPDATE  SQL 
DEFINE  g_before_input_done  LIKE type_file.num5          
DEFINE  g_axz03              LIKE axz_file.axz03   
DEFINE  g_axz04              LIKE axz_file.axz04            
DEFINE  g_aess03             LIKE aess_file.aess03                                                
DEFINE  g_str                STRING                            
DEFINE  g_i                  LIKE type_file.num5     
DEFINE  g_msg                LIKE type_file.chr1000       
DEFINE  g_row_count          LIKE type_file.num10         
DEFINE  g_curs_index         LIKE type_file.num10         
DEFINE  g_jump               LIKE type_file.num10         
DEFINE  g_no_ask             LIKE type_file.num5          
                                                                       
DEFINE  g_aaw01              LIKE aaw_file.aaw01
                                                                            
DEFINE  g_plant_axz03        LIKE type_file.chr21                                                                                                                                                      
DEFINE  g_aess00_def         LIKE aess_file.aess00                               
   
MAIN
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET i=0
   LET g_aess02_t = NULL  
   LET g_aess01_t = NULL
   LET g_aess00_t = NULL  
 
   OPEN WINDOW i019_w WITH FORM "agl/42f/agli019"
        ATTRIBUTE(STYLE = g_win_style)
   
   CALL cl_ui_init()
 
   CALL i019_menu()
 
   CLOSE FORM i019_w                      #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i019_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_aess.clear()
   CALL cl_set_head_visible("","YES")     
 
   INITIALIZE g_aess02 TO NULL    
   INITIALIZE g_aess01 TO NULL    
   INITIALIZE g_aess00 TO NULL    
   CONSTRUCT g_wc ON aess02,aess01,aess00,aess03,aess04,aess05,aess06,aes02,aes03,aess07,aess08                 
                FROM aess02,aess01,aess00,s_aess[1].aess03,s_aess[1].aess04,s_aess[1].aess05,                
                     s_aess[1].aess06,s_aess[1].aes02,s_aess[1].aes03,s_aess[1].aess07,s_aess[1].aess08 
 
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aess02) #族群編號                                                                                   
               CALL cl_init_qry_var()                                                                                       
               LET g_qryparam.state = "c"                                                                                   
               LET g_qryparam.form = "q_aess02"                                                                               
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                           
               DISPLAY g_qryparam.multiret TO aess02                                                                        
               NEXT FIELD aess02                                                                                             
            WHEN INFIELD(aess01)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_axz"      
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL i019_aess01('a',g_aess01)
               DISPLAY g_qryparam.multiret TO aess01  
               NEXT FIELD aess01
            WHEN INFIELD(aess06)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aes"      
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aess06  
               NEXT FIELD aess06                                                                                                  
 
            OTHERWISE EXIT CASE
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aessuser', 'aessgrup') 
 
   IF INT_FLAG THEN
      RETURN 
   END IF
 
   LET g_sql = "SELECT UNIQUE aess02,aess01,aess00 FROM aess_file ",  
               " WHERE ", g_wc CLIPPED,
               " ORDER BY aess02,aess01,aess00"    
   PREPARE i019_prepare FROM g_sql        #預備一下
   DECLARE i019_bcs SCROLL CURSOR WITH HOLD FOR i019_prepare
 
   LET g_sql_tmp = "SELECT UNIQUE aess02,aess01,aess00 ",    
                   "  FROM aess_file WHERE ", g_wc CLIPPED,
                   "  INTO TEMP x "
   DROP TABLE x
   PREPARE i019_pre_x FROM g_sql_tmp  
   EXECUTE i019_pre_x
   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE i019_precount FROM g_sql
   DECLARE i019_count CURSOR FOR i019_precount
 
END FUNCTION
 
FUNCTION i019_menu()
 
   WHILE TRUE
      CALL i019_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i019_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i019_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i019_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i019_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i019_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i019_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "batch_generate"
            IF cl_chk_act_auth() THEN
               CALL i019_g()
            END IF
          WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_aess01 IS NOT NULL THEN
                  LET g_doc.column1 = "aess02"                                                                               
                  LET g_doc.value1 = g_aess02                                                                                
                  LET g_doc.column2 = "aess01"                                                                               
                  LET g_doc.value2 = g_aess01                                                                                
                  LET g_doc.column3 = "aess00"                                                                               
                  LET g_doc.value3 = g_aess00                                                                                
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aess),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i019_a()
 
   IF s_aglshut(0) THEN
      RETURN
   END IF  
 
   MESSAGE ""
   CLEAR FORM
   CALL g_aess.clear()
   INITIALIZE g_aess02 LIKE aess_file.aess02        
   INITIALIZE g_aess01 LIKE aess_file.aess01         
   INITIALIZE g_aess00 LIKE aess_file.aess00         
 
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i019_i("a")                           #輸入單頭
 
      IF INT_FLAG THEN                           #使用者不玩了
         LET g_aess02=NULL  
         LET g_aess01=NULL
         LET g_aess00=NULL  
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0                    
      IF g_ss='N' THEN
         CALL g_aess.clear()
      ELSE
         CALL i019_b_fill('1=1')         #單身
      END IF
 
      CALL i019_b()                       #輸入單身
 
      LET g_aess02_t = g_aess02            #保留舊值  
      LET g_aess01_t = g_aess01             #保留舊值
      LET g_aess00_t = g_aess00             #保留舊值  
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i019_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入   
   l_n        LIKE type_file.num5,     
   p_cmd           LIKE type_file.chr1           #a:輸入 u:更改        
 
   LET g_ss = 'Y'
 
   DISPLAY g_aess02 TO aess02    
   DISPLAY g_aess01 TO aess01 
   DISPLAY g_aess00 TO aess00   
   CALL cl_set_head_visible("","YES")            
   INPUT g_aess02,g_aess01,g_aess00 WITHOUT DEFAULTS FROM aess02,aess01,aess00 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      AFTER FIELD aess02   #族群代號                                                                                         
        IF NOT cl_null(g_aess02) THEN                                                                                                                                                                                                          
            LET l_n = 0                                                                                                     
            SELECT COUNT(*) INTO l_n FROM axa_file                                                                          
             WHERE axa01=g_aess02                                                                                            
            IF l_n = 0 THEN                                                                                                 
               CALL cl_err(g_aess02,'agl-608',0)    #MOD-B80311                                                                             
               NEXT FIELD aess02                                                                                             
            END IF                                                                                                          
        END IF                                                                                                             
 
      AFTER FIELD aess01 
         IF NOT cl_null(g_aess01) THEN 
               CALL i019_aess01('a',g_aess01)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aess01,g_errno,0)
                  NEXT FIELD aess01
               END IF                                                                                                        
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
        
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aess02) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_aess02"                                                                                     
               LET g_qryparam.default1 = g_aess02                                                                                    
               CALL cl_create_qry() RETURNING g_aess02                                                                               
               DISPLAY g_aess02 TO aess02                                                                                             
               NEXT FIELD aess02                                                                                                     
            WHEN INFIELD(aess01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"     
               LET g_qryparam.default1 = g_aess01
               CALL cl_create_qry() RETURNING g_aess01
               CALL i019_aess01('a',g_aess01)
               DISPLAY g_aess01 TO aess01 
               NEXT FIELD aess01
            OTHERWISE EXIT CASE
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
 
FUNCTION  i019_aess01(p_cmd,p_aess01)   
 
DEFINE p_cmd       LIKE type_file.chr1,         
       p_aess01    LIKE aess_file.aess01,
       l_axz02     LIKE axz_file.axz02,
       l_axz03     LIKE axz_file.axz03,
       l_axz05     LIKE axz_file.axz05    
 
    LET g_errno = ' '
 
    SELECT DISTINCT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05   
      FROM axz_file,axa_file,axb_file
     WHERE axz01 = p_aess01 AND axa01=g_aess02 AND axb01=g_aess02 AND axa01=axb01 
       AND (axa02 = g_aess01 OR axb04 = g_aess01) 
       
 
    CASE
       WHEN SQLCA.SQLCODE=100 
          LET g_errno = 'agl-608'    #MOD-B80311   
          LET l_axz02 = NULL
          LET l_axz03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_aess00=l_axz05
       DISPLAY l_axz02 TO FORMONLY.axz02 
       DISPLAY l_axz03 TO FORMONLY.axz03
       DISPLAY l_axz05 TO FORMONLY.aess00    
    END IF
 
END FUNCTION
 
FUNCTION i019_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_aess02 TO NULL            
   INITIALIZE g_aess01 TO NULL             
   INITIALIZE g_aess00 TO NULL             
   MESSAGE ""
   CLEAR FORM
   CALL g_aess.clear()
 
   CALL i019_cs()                         #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i019_bcs                          #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aess02 TO NULL  
      INITIALIZE g_aess01 TO NULL
      INITIALIZE g_aess00 TO NULL  
   ELSE
      CALL i019_fetch('F')                #讀出TEMP第一筆並顯示
 
      OPEN i019_count
      FETCH i019_count INTO g_row_count
      DISPLAY g_curs_index TO FORMONLY.cnt  
   END IF
END FUNCTION
 
FUNCTION i019_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        
    l_abso          LIKE type_file.num10                 #絕對的筆數      
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i019_bcs INTO g_aess02,g_aess01,g_aess00  
      WHEN 'P' FETCH PREVIOUS i019_bcs INTO g_aess02,g_aess01,g_aess00  
      WHEN 'F' FETCH FIRST    i019_bcs INTO g_aess02,g_aess01,g_aess00  
      WHEN 'L' FETCH LAST     i019_bcs INTO g_aess02,g_aess01,g_aess00  
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
 
            IF INT_FLAG THEN
               LET INT_FLAG = 0 
               EXIT CASE 
            END IF
         END IF
 
         FETCH ABSOLUTE g_jump i019_bcs INTO g_aess02,g_aess01,g_aess00  
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_aess01,SQLCA.sqlcode,0)
      INITIALIZE g_aess02 TO NULL    
      INITIALIZE g_aess01 TO NULL  
      INITIALIZE g_aess00 TO NULL  
   ELSE
      CALL i019_show()

      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
   
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
FUNCTION i019_show()
 
   DISPLAY g_aess02 TO aess02      
   DISPLAY g_aess01 TO aess01 
   DISPLAY g_aess00 TO aess00      
 
   CALL i019_aess01('d',g_aess01)
         
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaw01
   CALL i019_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i019_r()
   DEFINE l_chr LIKE type_file.chr1          
 
   IF s_aglshut(0) THEN RETURN END IF
 
   IF cl_null(g_aess02) OR cl_null(g_aess01) OR cl_null(g_aess00) THEN   
      CALL cl_err('',-400,0)
      RETURN 
   END IF
 
   BEGIN WORK
 
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       
       LET g_doc.column1 = "aess02"     
       LET g_doc.value1  = g_aess02       
       LET g_doc.column2 = "aess01"      
       LET g_doc.value2  = g_aess01       
       LET g_doc.column3 = "aess00"     
       LET g_doc.value3  = g_aess00       
       CALL cl_del_doc()                                        
      DELETE FROM aess_file WHERE aess01=g_aess01 
                              AND aess00=g_aess00  
                              AND aess02=g_aess02  
      IF SQLCA.sqlcode THEN
          CALL cl_err3("del","aess_file",g_aess01,g_aess00,SQLCA.sqlcode,"","BODY DELETE:",1)  
      ELSE
         CLEAR FORM
         CALL g_aess.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
 
         DROP TABLE x
         PREPARE i003_pre_x2 FROM g_sql_tmp
         EXECUTE i003_pre_x2              
         OPEN i019_count
         IF STATUS THEN
            CLOSE i019_bcs
            CLOSE i019_count
            COMMIT WORK
            RETURN
         END IF
         FETCH i019_count INTO g_row_count
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i019_bcs
            CLOSE i019_count
            COMMIT WORK
            RETURN
         END IF
         DISPLAY g_curs_index TO FORMONLY.cnt
 
         OPEN i019_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i019_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i019_fetch('/')
         END IF
      END IF
 
      LET g_msg=TIME
 
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i019_b()
DEFINE
    l_aess04        LIKE aess_file.aess04,
    l_aess05        LIKE aess_file.aess05,
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,      #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        
    p_cmd           LIKE type_file.chr1,      #處理狀態          
    l_sql           LIKE type_file.chr1000,      
    l_allow_insert  LIKE type_file.chr1,      #可新增否  
    l_allow_delete  LIKE type_file.chr1       #可刪除否        
           
      
   LET g_action_choice = ""
   IF s_aglshut(0) THEN 
       RETURN 
   END IF
   IF cl_null(g_aess02) THEN
       RETURN 
   END IF
   CALL cl_opmsg('b')    
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT aess03,aess04,aess05,aess06,'','',aess07,aess08 FROM aess_file ",  
                      " WHERE aess02= ? AND aess01= ? AND aess00 = ? AND aess03 = ? FOR UPDATE "  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i019_bcl CURSOR FROM g_forupd_sql       # LOCK CURSOR
 
   LET l_ac_t = 0
   INPUT ARRAY g_aess WITHOUT DEFAULTS FROM s_aess.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,
                   DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd='' 
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_aess_t.* = g_aess[l_ac].*  #BACKUP
 
            OPEN i019_bcl USING g_aess02,g_aess01,g_aess00,g_aess_t.aess03  
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_aess_t.aess03,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i019_bcl INTO g_aess[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aess_t.aess03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i019_aess06(l_ac)
                  LET g_errno = ' '                         
               END IF
            END IF
 
            CALL cl_show_fld_cont()    
         END IF 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_aess[l_ac].* TO NULL
         LET g_aess_t.* = g_aess[l_ac].*  
         CALL cl_show_fld_cont()     
         NEXT FIELD aess03
         
 
      AFTER INSERT
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         
 
         INSERT INTO aess_file(aess00,aess01,aess02,aess03,aess04,aess05,aess06,aess07,aess08,aessacti,aessuser,  
                              aessgrup,aessmodu,aessdate,aessoriu,aessorig)  
                       VALUES(g_aess00,g_aess01,g_aess02,g_aess[l_ac].aess03,g_aess[l_ac].aess04,g_aess[l_ac].aess05,  
                              g_aess[l_ac].aess06,g_aess[l_ac].aess07,g_aess[l_ac].aess08,
                              'Y',g_user,g_grup,g_user,g_today, g_user, g_grup)  
 
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","aess_file",g_aess01,g_aess[l_ac].aess03,SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
          

       AFTER FIELD aess03
         IF NOT cl_null(g_aess[l_ac].aess03) THEN 
             LET g_axz04 = ' ' 
             SELECT axz04 INTO g_axz04 FROM axz_file
              WHERE axz01 = g_aess01
               
                IF (g_aess_t.aess03 IS NOT NULL AND g_aess[l_ac].aess03 != g_aess_t.aess03) OR g_aess_t.aess03 IS NULL THEN  
                    SELECT count(*) INTO l_n 
                      FROM aess_file  
                     WHERE aess01 = g_aess01 
                       AND aess02 = g_aess02
                       AND aess03 = g_aess[l_ac].aess03                     
                       IF l_n > 0 THEN
                          CALL cl_err(g_aess[l_ac].aess03,'agl-602',0)
                          NEXT FIELD aess03
                       END IF 
                       CALL i019_aess03(l_ac)
                END IF
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_aess[l_ac].aess03,g_errno,0)
                   NEXT FIELD aess03
                END IF
        END IF 
        DISPLAY BY NAME g_aess[l_ac].aess07,g_aess[l_ac].aess08     

      AFTER FIELD aess06
         IF cl_null(g_aess[l_ac].aess06) THEN 
               CALL cl_err('','agl-605',2)
               NEXT FIELD aess06
         END IF
         IF NOT cl_null(g_aess[l_ac].aess06) THEN 
            CALL i019_aess06(l_ac)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_aess[l_ac].aess06,g_errno,2)
               NEXT FIELD aess06
            END IF
         END IF
      
      BEFORE DELETE                            #是否取消單身
         IF g_aess_t.aess03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            DELETE FROM aess_file
             WHERE aess01 = g_aess01 AND aess03 = g_aess_t.aess03 
               AND aess00 = g_aess00 AND aess02 = g_aess02  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aess_file",g_aess01,g_aess[l_ac].aess03,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
 
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_aess[l_ac].* = g_aess_t.*
            CLOSE i019_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN 
            CALL cl_err(g_aess[l_ac].aess04,-263,0)
            LET g_aess[l_ac].* = g_aess_t.*
         ELSE 
            UPDATE aess_file 
               SET aess03 = g_aess[l_ac].aess03,
                   aess04 = g_aess[l_ac].aess04,
                   aess05 = g_aess[l_ac].aess05,
                   aess06 = g_aess[l_ac].aess06,
                   aess07 = g_aess[l_ac].aess07,   
                   aess08 = g_aess[l_ac].aess08,   
                   aessmodu = g_user,
                   aessdate = g_today
             WHERE aess01 = g_aess01 
               AND aess00 = g_aess00  
               AND aess02 = g_aess02   
               AND aess03 = g_aess_t.aess03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","aess_file",g_aess01,g_aess_t.aess03,SQLCA.sqlcode,"","",1)  
               LET g_aess[l_ac].* = g_aess_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()         # 新增
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_aess[l_ac].* = g_aess_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_aess.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            
            CLOSE i019_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  
         CLOSE i019_bcl
         COMMIT WORK

      AFTER INPUT
         FOR l_ac=1 TO g_rec_b
            IF g_aess[l_ac].aess06=' ' THEN
               CALL cl_err('','agl-603',2)
               CALL fgl_set_arr_curr(l_ac)  
               NEXT FIELD aess06
            END IF
         END FOR
      
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(aess03) AND l_ac > 1 THEN
            LET g_aess[l_ac].* = g_aess[l_ac-1].*
            NEXT FIELD aess03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aess06) 
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aes"  
              LET g_qryparam.default1 = g_aess[l_ac].aess06    
              CALL cl_create_qry() RETURNING g_aess[l_ac].aess06
              DISPLAY BY NAME g_aess[l_ac].aess06  
              NEXT FIELD aess06                                                                                                      
            OTHERWISE EXIT CASE
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

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END INPUT
 
   CLOSE i019_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i019_aess06(l_cnt)
   DEFINE  l_cnt           LIKE type_file.num5,          
           l_aes02         LIKE aes_file.aes02,
           l_aes03         LIKE aes_file.aes03,
           l_aagacti       LIKE aag_file.aagacti  
 
   LET g_errno = ' '
 
   SELECT aes02,aes03,aesacti INTO l_aes02,l_aes03,l_aagacti FROM aes_file                                                                                                                                                                  
    WHERE aes01 = g_aess[l_cnt].aess06                                                                                                                                    
 
   CASE 
         WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-606' 
                                  LET g_aess[l_cnt].aess06=' '
         WHEN l_aagacti = 'N'     LET g_errno = '9028' 
         OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE 
 
   IF cl_null(g_errno) THEN
       LET g_aess[l_cnt].aes02 = l_aes02
       LET g_aess[l_cnt].aes03 = l_aes03
   END IF
    
END FUNCTION
   
FUNCTION i019_aess03(l_cnt)                    
   DEFINE  l_n             LIKE type_file.num5,  
           l_cnt           LIKE type_file.num5,
           l_nml02         LIKE nml_file.nml02,
           l_nml03         LIKE nml_file.nml03,
           l_nmlacti       LIKE nml_file.nmlacti

    LET g_axz04 = ' ' 
    SELECT axz04 INTO g_axz04 FROM axz_file
    WHERE axz01 = g_aess01
    LET g_errno = ' '     
 
    IF g_axz04 = 'N' THEN   #非TIPTOP公司
       LET g_sql = "SELECT aep16,aep17,'Y' ",
                   "  FROM aep_file ",
                   " WHERE aep02 ='",g_aess01,"'",
                   "   AND aep01 ='",g_aess02,"'",
                   "   AND aep05 ='",g_aess[l_ac].aess03,"'"
    ELSE                                        
       LET g_sql = "SELECT nml02,nml03,nmlacti ",
                   "  FROM ",cl_get_target_table(g_plant_gl,'nml_file'),  
                   " WHERE nml01 = '",g_aess[l_cnt].aess03,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql
    END IF 
    PREPARE i019_sel_nml FROM g_sql
    DECLARE i019_cur_nml CURSOR FOR i019_sel_nml
    OPEN i019_cur_nml
    FETCH i019_cur_nml INTO l_nml02,l_nml03,l_nmlacti

    CASE
         WHEN SQLCA.SQLCODE=100   LET g_errno = 'anm-140'
         WHEN l_nmlacti = 'N'     LET g_errno = '9028'
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
    
    LET g_aess[l_ac].aess07 = '1'
    LET g_aess[l_ac].aess08 = '1'

    IF cl_null(g_errno) THEN
       LET g_aess[l_cnt].aess04 = l_nml02
       LET g_aess[l_cnt].aess05 = l_nml03 
       
       SELECT count(aes01) INTO l_n FROM aes_file 
                WHERE aes01=g_aess[l_ac].aess03
       IF l_n>0 THEN 
           LET g_aess[l_ac].aess06 = g_aess[l_ac].aess03
           CALL i019_aess06(l_ac)
       END IF
    END IF
    DISPLAY BY NAME g_aess[l_cnt].aess04,g_aess[l_ac].aess05 
END FUNCTION


FUNCTION i019_b_askkey()
   DEFINE  l_wc   LIKE type_file.chr1000    
 
   CLEAR FORM
   CALL g_aess.clear()
   CALL g_aess.clear()
 
   CONSTRUCT l_wc ON aess03,aess04,aess05,aess06,aes02,aes03,aess07,aess08  #螢幕上取條件        
        FROM s_aess[1].aess03,s_aess[1].aess04,s_aess[1].aess05,s_aess[1].aess06,s_aess[1].aes02,s_aess[1].aes03,s_aess[1].aess07,s_aess[1].aess08
 
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
   
   IF INT_FLAG THEN
      RETURN 
   END IF
 
   CALL i019_b_fill(l_wc)
   
END FUNCTION
 
FUNCTION i019_b_fill(p_wc)              
   DEFINE p_wc   LIKE type_file.chr1000 
 
   IF cl_null(p_wc) THEN LET p_wc = " 1=1" END IF 
   LET g_sql = "SELECT aess03,aess04,aess05,aess06,'','',aess07,aess08 ",  
               " FROM aess_file ",
               " WHERE aess01 = '",g_aess01,"' AND ", p_wc CLIPPED ,
               "   AND aess00 = '",g_aess00,"'",
               "   AND aess02 = '",g_aess02,"'",     
               " ORDER BY aess03 "
   PREPARE i019_prepare2 FROM g_sql      #預備一下
   DECLARE aess_cs CURSOR FOR i019_prepare2
 
   CALL g_aess.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH aess_cs INTO g_aess[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      CALL i019_aess06(g_cnt)
      LET g_errno = ' '                 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_aess.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i019_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aess TO s_aess.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first 
         CALL i019_fetch('F')
         DISPLAY g_curs_index TO cnt
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                  
 
      ON ACTION previous
         CALL i019_fetch('P')
         DISPLAY g_curs_index TO cnt
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
                              
 
    ON ACTION jump
       CALL i019_fetch('/')
       DISPLAY g_curs_index TO cnt
       CALL cl_navigator_setting(g_curs_index, g_row_count)   
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)  
       END IF
	ACCEPT DISPLAY                   
                              
 
    ON ACTION next
       CALL i019_fetch('N')
       DISPLAY g_curs_index TO cnt
       CALL cl_navigator_setting(g_curs_index, g_row_count)   
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)  
       END IF
	ACCEPT DISPLAY                  
                              
 
    ON ACTION last
       CALL i019_fetch('L')
       DISPLAY g_curs_index TO cnt
       CALL cl_navigator_setting(g_curs_index, g_row_count)  
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)  
       END IF
	ACCEPT DISPLAY                   
                              
    ON ACTION reproduce
       LET g_action_choice="reproduce"
       EXIT DISPLAY
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
       EXIT DISPLAY
 
    ON ACTION exit
       LET g_action_choice="exit"
       EXIT DISPLAY
    ON ACTION controlg
       LET g_action_choice="controlg"
       EXIT DISPLAY
    ON ACTION batch_generate
       LET g_action_choice="batch_generate"
       EXIT DISPLAY
 
#     ON ACTION 相關文件  
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
 
 
FUNCTION i019_copy()
DEFINE l_aess         RECORD LIKE aess_file.*,
       l_sql          LIKE type_file.chr1000,     
       l_oldno0       LIKE aess_file.aess00,        
       l_newno0       LIKE aess_file.aess00,        
       l_oldno1       LIKE aess_file.aess01,
       l_newno1       LIKE aess_file.aess01,
       l_oldno2       LIKE aess_file.aess02,                                                                          
       l_newno2       LIKE aess_file.aess02,                                                                          
       l_n       LIKE type_file.num5        
DEFINE l_aess01_cnt   LIKE type_file.num5         
   IF s_aglshut(0) THEN RETURN END IF
 
   IF cl_null(g_aess02) OR cl_null(g_aess01) OR cl_null(g_aess00) THEN  
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")    
 
     INPUT l_newno2,l_newno1 FROM aess02,aess01    
      AFTER FIELD aess02   #族群代號                                                                                                 
         IF l_newno2 IS NULL THEN                                                                                                   
            NEXT FIELD aess02                                                                                                        
         END IF                                                                                                                     
 
      AFTER FIELD aess01
         IF l_newno1 IS NULL THEN 
            NEXT FIELD aess01
         END IF
         SELECT COUNT(*)                                                                                                            
           INTO l_aess01_cnt                                                                                                         
           FROM axz_file                                                                                                            
          WHERE axz01 = l_newno1                                                                                                    
         IF SQLCA.SQLCODE=100  THEN                                                                                                 
            LET g_errno = 'aco-025'                                                                                     
         END IF                                                                                                                     
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(l_newno1,g_errno,0)
            NEXT FIELD aess01
         ELSE                                                                                                                       
            SELECT axz05 INTO l_newno0                                                                                              
              FROM axz_file                                                                                                         
             WHERE axz01 = l_newno1                                                                                                 
            DISPLAY l_newno0 TO aess00                                                                                               
         END IF
         IF l_newno2 IS NOT NULL AND l_newno1 IS NOT NULL AND                                                                       
            l_newno0 IS NOT NULL THEN                                                                                               
            LET l_n = 0                                                                                                
            SELECT COUNT(*) INTO l_n FROM axa_file,axb_file
             WHERE axa01=l_newno2 AND axa03=l_newno0 AND axb01=l_newno2 AND axa01=axb01
               AND (axa02=l_newno1 OR axb04=l_newno1)
        
            IF l_n = 0 THEN                                                                                                    
               CALL cl_err(l_newno1,'agl-608',0)    #MOD-B80311                                                                                    
               NEXT FIELD aess01                                                                                                     
            END IF                                                                                                                  
         END IF                                                                                                                     
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aess02) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_aess02"                                                                                     
               LET g_qryparam.default1 = l_newno2                                                                                   
               CALL cl_create_qry() RETURNING l_newno2                                                                              
               DISPLAY l_newno2 TO aess02                                                                                            
               NEXT FIELD aess02                                                                                                     
            WHEN INFIELD(aess01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz" 
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               CALL i019_aess01('a',g_aess01)
               DISPLAY l_newno1 TO aess01 
               NEXT FIELD aess01
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
      DISPLAY g_aess01 TO aess01 
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM aess_file         #單身複製
    WHERE aess01=g_aess01 
      AND aess00=g_aess00  
      AND aess02=g_aess02  
     INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","aess_file",g_aess01,g_aess00,SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET aess01=l_newno1,aess00=l_newno0,aess02=l_newno2  
 
   INSERT INTO aess_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","aess_file",l_newno1,l_newno0,SQLCA.sqlcode,"","aess:",1)  
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
 
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
   
   LET l_oldno2 = g_aess02     
   LET l_oldno1 = g_aess01 
   LET l_oldno0 = g_aess00   
   LET g_aess02 = l_newno2     
   LET g_aess01 = l_newno1
   LET g_aess00 = l_newno0     
 
   CALL i019_b()
   #FUN-C30027---begin
   #LET g_aess02 = l_oldno2     
   #LET g_aess01 = l_oldno1
   #LET g_aess00 = l_oldno0     
   #
   #CALL i019_show()
   #FUN-C30027---end
END FUNCTION
 
FUNCTION i019_out()
   DEFINE l_i             LIKE type_file.num5,          
          l_name          LIKE type_file.chr20,         
          l_chr           LIKE type_file.chr1,          
          sr              RECORD
          aess02          LIKE aess_file.aess02,     #族群代號  
          aess01          LIKE aess_file.aess01,     #營運中心
          aess00          LIKE aess_file.aess00,     #帳套  
          aess03          LIKE aess_file.aess03,     #來源公司現金變動碼
          aess04          LIKE aess_file.aess04,     #來源公司現金碼名稱
          aess05          LIKE aess_file.aess05,     #來源公司現金碼分類
          aess06          LIKE aess_file.aess06,     #合併后現金變動碼
          aes02           LIKE aes_file.aes02,       #合併現金碼名稱
          aes03           LIKE aes_file.aes03,       #合併現金碼分類
          aess07          LIKE aess_file.aess07,     #再衡量匯率類別
          aess08          LIKE aess_file.aess08      #換算匯率類別
                          END RECORD
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql="SELECT DISTINCT * ", # 組合出 SQL 指令  
             " FROM aess_file, aes_file ",
             " WHERE ",g_wc CLIPPED ,
             "   AND aess06 = aes_file.aes01",   
             " ORDER BY 1 "   
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(g_wc,'aess02,aess01,aess00,aess03,aess04,aess05,aess06,aess07,aess08')  
      RETURNING g_wc                                                          
      LET g_str = g_str CLIPPED,";", g_wc                                     
   END IF                                                                      
   LET g_str =  g_wc    
   CALL cl_prt_cs1('agli019','agli019',g_sql,g_str)
END FUNCTION

FUNCTION  i019_aess01_g(p_aess01,p_aess02)  
DEFINE p_aess01    LIKE aess_file.aess01,        
       p_aess02    LIKE aess_file.aess02,
       l_axz02     LIKE axz_file.axz02,
       l_axz03     LIKE axz_file.axz03,
       l_axz05     LIKE axz_file.axz05 

      SELECT DISTINCT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05   
        FROM axz_file,axa_file,axb_file
       WHERE axz01 = p_aess01 AND axa01=p_aess02 AND axb01=p_aess02 AND axa01=axb01 
         AND (axa02 = p_aess01 OR axb04 = p_aess01) 
      CASE
        WHEN SQLCA.SQLCODE=100 
         LET g_errno = 'agl-608'    #MOD-B80311   
         LET l_axz02 = NULL
         LET l_axz03 = NULL 
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
      END CASE

      IF cl_null(g_errno)  THEN
         LET g_aess00=l_axz05
         DISPLAY l_axz02 TO FORMONLY.axz02 
         DISPLAY l_axz03 TO FORMONLY.axz03
         DISPLAY l_axz05 TO FORMONLY.aess00    
      END IF
END FUNCTION
 
FUNCTION i019_g()
   DEFINE l_sql         LIKE type_file.chr1000,   
          l_aess06      LIKE aess_file.aess06,
          l_nml01       LIKE nml_file.nml01,
          l_nml02       LIKE nml_file.nml02,
          l_nml03       LIKE nml_file.nml03,
          l_type        STRING,                   
          l_flag        LIKE type_file.chr1,      
          l_axz03       LIKE axz_file.axz03,      
          g_axz04       LIKE axz_file.axz04,      
          l_n           LIKE type_file.num5          
     
   DEFINE l_aess07      LIKE aess_file.aess07       
   DEFINE l_aess08      LIKE aess_file.aess08            
   DEFINE l_aag01_t     LIKE aag_file.aag01       
   DEFINE l_aes01       LIKE aes_file.aes01
   DEFINE l_aes01_t     LIKE aes_file.aes01  
   DEFINE l_tmp         LIKE aag_file.aag08       
   DEFINE l_qbe_nml01   LIKE nml_file.nml01      
   DEFINE l_aess        DYNAMIC ARRAY OF RECORD
          aess03        LIKE aess_file.aess03,  
          aess04        LIKE aess_file.aess04,                 
          aess05        LIKE aess_file.aess05,                 
          aess06        LIKE aess_file.aess06,                  
          aes02         LIKE aes_file.aes02,
          aes03         LIKE aes_file.aes03,
          aess07        LIKE aess_file.aess07, 
          aess08        LIKE aess_file.aess08 
                        END RECORD
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_wc          LIKE type_file.chr1000
   DEFINE l_axz02       LIKE axz_file.axz02,
          l_axz05       LIKE axz_file.axz05 
 
   OPEN WINDOW i019_w3 AT 6,11
     WITH FORM "agl/42f/agli019_g"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("agli019_g")
 
   CALL cl_getmsg('agl-021',g_lang) RETURNING g_msg
   MESSAGE g_msg 
 
   LET g_success='Y'   
 
   WHILE TRUE  
      CONSTRUCT g_wc2 ON nml01 FROM nml01
 
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
    
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW i019_w3 
         RETURN 
      END IF
    
      INPUT tm.aess02,tm.aess01 WITHOUT DEFAULTS                                      
       FROM FORMONLY.aess02,FORMONLY.aess01   
 
         AFTER FIELD aess01
            IF NOT cl_null(tm.aess01) THEN 
                CALL i019_aess01_g(tm.aess01,tm.aess02)
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.aess01,g_errno,0)
                  NEXT FIELD aess01
                ELSE                                                                                                                 
                  SELECT axz05 INTO g_aess00_def                                                                                     
                    FROM axz_file                                                                                                   
                   WHERE axz01 = tm.aess01                                                                                           
               END IF                                                                                                               
            END IF

         AFTER FIELD aess02   #族群代號                                                                                         
            IF cl_null(tm.aess02) THEN                                                                                           
               CALL cl_err(tm.aess02,'mfg0037',0)                                                                                
               NEXT FIELD aess02                                                                                                
            ELSE                                                                                                               
              LET l_n = 0                                                                                                     
              SELECT COUNT(*) INTO l_n FROM axa_file                                                                          
               WHERE axa01=tm.aess02                                                                                                                                                                   
              IF l_n = 0 THEN                                                                                                 
                 CALL cl_err(tm.aess02,'agl-608',0)    #MOD-B80311                                                                             
                 NEXT FIELD aess02                                                                                             
              END IF                                                                                                          
            END IF       
    
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()
    
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(aess02) #族群編號                                                                                        
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_aess02"           
                  LET g_qryparam.default1 = tm.aess02                                                                                
                  CALL cl_create_qry() RETURNING tm.aess02                                                                           
                  DISPLAY tm.aess02 TO aess02                                                                                         
                  NEXT FIELD aess02                                                                                                  
               WHEN INFIELD(aess01)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz"     
                  LET g_qryparam.default1 = tm.aess01
                  CALL cl_create_qry() RETURNING tm.aess01
                  CALL i019_aess01('a',g_aess01)
                  DISPLAY tm.aess01 TO aess01 
                  NEXT FIELD aess01
               OTHERWISE EXIT CASE
            END CASE
    
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
         ON ACTION about         
            CALL cl_about()      
        
         ON ACTION help         
            CALL cl_show_help()  
    
      END INPUT
    
      IF INT_FLAG THEN 
         LET INT_FLAG=0
         CLOSE WINDOW i019_w3
         RETURN
      END IF
    
      IF cl_sure(0,0) THEN 
         BEGIN WORK    

        SELECT axz03,axz04 INTO g_axz03,g_axz04 FROM axz_file
         WHERE axz01 = tm.aess01
         IF g_axz04 = 'N' THEN			
            LET g_plant_gl = g_plant			
         ELSE			
            LET g_plant_gl = g_axz03			
         END IF 			
  
          IF g_axz04 = 'N' THEN 
             LET g_wc2=cl_replace_str(g_wc2,"nml01",'aep05')
             LET l_sql ="SELECT UNIQUE aep05,aep16,aep17 FROM aep_file ", 
                        " WHERE ", g_wc2 CLIPPED, 
                        "   AND aep01 = '",tm.aess02,"'",   #下層公司
                        "   AND aep02 = '",tm.aess01,"'"   #群組 
  
          ELSE
             LET l_sql ="SELECT nml01,nml02,nml03 ",  
                        "  FROM ",cl_get_target_table(g_plant_gl,'nml_file'),
                        "  WHERE ",g_wc2 CLIPPED,              
                        " ORDER BY nml01 "
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
             CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  
          END IF
	      
          PREPARE i019_g_pre  FROM l_sql
          DECLARE i019_g CURSOR FOR i019_g_pre 

          LET i = 1    
          FOREACH i019_g INTO l_nml01,l_nml02,l_nml03   
            IF SQLCA.sqlcode THEN 
               CALL cl_err('i019_g',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
 
            LET l_aess[i].aess03 = l_nml01
            LET l_aess[i].aess04 = l_nml02
            LET l_aess[i].aess05 = l_nml03

            SELECT count(aes01) INTO l_n FROM aes_file 
                                WHERE aes01=l_aess[i].aess03
            IF l_n=0 THEN 
               LET l_aess[i].aess06=' '
            ELSE
               LET l_aess[i].aess06 = l_aess[i].aess03
            END IF  

            SELECT aes02,aes03 INTO l_aess[i].aes02,l_aess[i].aes03 FROM aes_file 
                 WHERE aes01=l_aess06

            LET l_aess[i].aess07 = '1'
            LET l_aess[i].aess08 = '1'
            
            INSERT INTO aess_file (aess00,aess01,aess02,aess03,aess04,aess05,aess06,aess07,aess08, 
                                 aessacti,aessuser,aessgrup,aessmodu,aessdate,aessoriu,aessorig)
                         VALUES (g_aess00_def,tm.aess01,tm.aess02,l_aess[i].aess03,l_aess[i].aess04,
                                 l_aess[i].aess05,l_aess[i].aess06,
                                 l_aess[i].aess07,l_aess[i].aess08,
                                  'Y',g_user,g_grup,' ',g_today, g_user, g_grup)        
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  
               CONTINUE FOREACH     
            ELSE
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","aess_file",tm.aess01,l_nml01,STATUS,"","ins aess",1)  
                  LET g_success='N'   
                  EXIT FOREACH    
               END IF
            END IF 
            LET i = i + 1 
         END FOREACH
      END IF
    
      IF g_success='Y' THEN
         COMMIT WORK     
         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK   
         CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         CLOSE WINDOW i019_w3
         EXIT WHILE
      END IF
   END WHILE
   LET g_aess01=tm.aess01
   LET g_aess02=tm.aess02
   LET g_aess00=g_aess00_def
   CALL i019_show()
   CALL i019_b()
END FUNCTION

#MOD-BB0262
