# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: ggli019.4gl
# Descriptions...: 合併財報現金變動碼維護作業
# Date & Author..: No.FUN-B70003 11/07/05 By lujh
# Modify.........: No.MOD-B80311 11/08/26 by lujh 單頭公司編號報錯訊息有誤
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-BB0037
 
#模組變數(Module Variables)
DEFINE  g_ath02             LIKE ath_file.ath02,      
        g_ath02_t           LIKE ath_file.ath02,      
        g_ath01             LIKE ath_file.ath01,  
        g_ath01_t           LIKE ath_file.ath01, 
        g_ath01_o           LIKE ath_file.ath01,
        g_ath00             LIKE ath_file.ath00,   
        g_ath00_t           LIKE ath_file.ath00,   
        g_ath00_o           LIKE ath_file.ath00,  
        
        g_ath       DYNAMIC ARRAY OF RECORD   
        ath03               LIKE ath_file.ath03,                 
        ath04               LIKE ath_file.ath04,                 
        ath05               LIKE ath_file.ath05, 
        ath06               LIKE ath_file.ath06,
        atg02                LIKE atg_file.atg02,
        atg03                LIKE atg_file.atg03,
        ath07               LIKE ath_file.ath07,   
        ath08               LIKE ath_file.ath08    
                             END RECORD,
        g_ath_t     RECORD                    #程式變數 (舊值)
        ath03               LIKE ath_file.ath03,                 
        ath04               LIKE ath_file.ath04,                 
        ath05               LIKE ath_file.ath05, 
        ath06               LIKE ath_file.ath06,
        atg02                LIKE atg_file.atg02,
        atg03                LIKE atg_file.atg03,
        ath07               LIKE ath_file.ath07,   
        ath08               LIKE ath_file.ath08
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
        ath02               LIKE ath_file.ath02,       
        ath01               LIKE ath_file.ath01, 
        ath00               LIKE ath_file.ath00,             
        y                    LIKE type_file.chr1              
                             END RECORD
DEFINE  g_forupd_sql         STRING                    #SELECT ... FOR UPDATE  SQL 
DEFINE  g_before_input_done  LIKE type_file.num5          
DEFINE  g_asg03              LIKE asg_file.asg03   
DEFINE  g_asg04              LIKE asg_file.asg04            
DEFINE  g_ath03             LIKE ath_file.ath03                                                
DEFINE  g_str                STRING                            
DEFINE  g_i                  LIKE type_file.num5     
DEFINE  g_msg                LIKE type_file.chr1000       
DEFINE  g_row_count          LIKE type_file.num10         
DEFINE  g_curs_index         LIKE type_file.num10         
DEFINE  g_jump               LIKE type_file.num10         
DEFINE  g_no_ask             LIKE type_file.num5          
                                                                       
DEFINE  g_asz01              LIKE asz_file.asz01
                                                                            
DEFINE  g_plant_asg03        LIKE type_file.chr21                                                                                                                                                      
DEFINE  g_ath00_def         LIKE ath_file.ath00                               
   
MAIN
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET i=0
   LET g_ath02_t = NULL  
   LET g_ath01_t = NULL
   LET g_ath00_t = NULL  
 
   OPEN WINDOW i019_w WITH FORM "ggl/42f/ggli019"
        ATTRIBUTE(STYLE = g_win_style)
   
   CALL cl_ui_init()
 
   CALL i019_menu()
 
   CLOSE FORM i019_w                      #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i019_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_ath.clear()
   CALL cl_set_head_visible("","YES")     
 
   INITIALIZE g_ath02 TO NULL    
   INITIALIZE g_ath01 TO NULL    
   INITIALIZE g_ath00 TO NULL    
   CONSTRUCT g_wc ON ath02,ath01,ath00,ath03,ath04,ath05,ath06,atg02,atg03,ath07,ath08                 
                FROM ath02,ath01,ath00,s_ath[1].ath03,s_ath[1].ath04,s_ath[1].ath05,                
                     s_ath[1].ath06,s_ath[1].atg02,s_ath[1].atg03,s_ath[1].ath07,s_ath[1].ath08 
 
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ath02) #族群編號                                                                                   
               CALL cl_init_qry_var()                                                                                       
               LET g_qryparam.state = "c"                                                                                   
               LET g_qryparam.form = "q_ath02"                                                                               
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                           
               DISPLAY g_qryparam.multiret TO ath02                                                                        
               NEXT FIELD ath02                                                                                             
            WHEN INFIELD(ath01)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_asg"      
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL i019_ath01('a',g_ath01)
               DISPLAY g_qryparam.multiret TO ath01  
               NEXT FIELD ath01
            WHEN INFIELD(ath06)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_atg"      
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ath06  
               NEXT FIELD ath06                                                                                                  
 
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('athuser', 'athgrup') 
 
   IF INT_FLAG THEN
      RETURN 
   END IF
 
   LET g_sql = "SELECT UNIQUE ath02,ath01,ath00 FROM ath_file ",  
               " WHERE ", g_wc CLIPPED,
               " ORDER BY ath02,ath01,ath00"    
   PREPARE i019_prepare FROM g_sql        #預備一下
   DECLARE i019_bcs SCROLL CURSOR WITH HOLD FOR i019_prepare
 
   LET g_sql_tmp = "SELECT UNIQUE ath02,ath01,ath00 ",    
                   "  FROM ath_file WHERE ", g_wc CLIPPED,
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
               IF g_ath01 IS NOT NULL THEN
                  LET g_doc.column1 = "ath02"                                                                               
                  LET g_doc.value1 = g_ath02                                                                                
                  LET g_doc.column2 = "ath01"                                                                               
                  LET g_doc.value2 = g_ath01                                                                                
                  LET g_doc.column3 = "ath00"                                                                               
                  LET g_doc.value3 = g_ath00                                                                                
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ath),'','')
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
   CALL g_ath.clear()
   INITIALIZE g_ath02 LIKE ath_file.ath02        
   INITIALIZE g_ath01 LIKE ath_file.ath01         
   INITIALIZE g_ath00 LIKE ath_file.ath00         
 
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i019_i("a")                           #輸入單頭
 
      IF INT_FLAG THEN                           #使用者不玩了
         LET g_ath02=NULL  
         LET g_ath01=NULL
         LET g_ath00=NULL  
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0                    
      IF g_ss='N' THEN
         CALL g_ath.clear()
      ELSE
         CALL i019_b_fill('1=1')         #單身
      END IF
 
      CALL i019_b()                       #輸入單身
 
      LET g_ath02_t = g_ath02            #保留舊值  
      LET g_ath01_t = g_ath01             #保留舊值
      LET g_ath00_t = g_ath00             #保留舊值  
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i019_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入   
   l_n        LIKE type_file.num5,     
   p_cmd           LIKE type_file.chr1           #a:輸入 u:更改        
 
   LET g_ss = 'Y'
 
   DISPLAY g_ath02 TO ath02    
   DISPLAY g_ath01 TO ath01 
   DISPLAY g_ath00 TO ath00   
   CALL cl_set_head_visible("","YES")            
   INPUT g_ath02,g_ath01,g_ath00 WITHOUT DEFAULTS FROM ath02,ath01,ath00 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      AFTER FIELD ath02   #族群代號                                                                                         
        IF NOT cl_null(g_ath02) THEN                                                                                                                                                                                                          
            LET l_n = 0                                                                                                     
            SELECT COUNT(*) INTO l_n FROM asa_file                                                                          
             WHERE asa01=g_ath02                                                                                            
            IF l_n = 0 THEN                                                                                                 
               CALL cl_err(g_ath02,'agl-608',0)    #MOD-B80311                                                                             
               NEXT FIELD ath02                                                                                             
            END IF                                                                                                          
        END IF                                                                                                             
 
      AFTER FIELD ath01 
         IF NOT cl_null(g_ath01) THEN 
               CALL i019_ath01('a',g_ath01)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ath01,g_errno,0)
                  NEXT FIELD ath01
               END IF                                                                                                        
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
        
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ath02) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_ath02"                                                                                     
               LET g_qryparam.default1 = g_ath02                                                                                    
               CALL cl_create_qry() RETURNING g_ath02                                                                               
               DISPLAY g_ath02 TO ath02                                                                                             
               NEXT FIELD ath02                                                                                                     
            WHEN INFIELD(ath01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asg"     
               LET g_qryparam.default1 = g_ath01
               CALL cl_create_qry() RETURNING g_ath01
               CALL i019_ath01('a',g_ath01)
               DISPLAY g_ath01 TO ath01 
               NEXT FIELD ath01
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
 
FUNCTION  i019_ath01(p_cmd,p_ath01)   
 
DEFINE p_cmd       LIKE type_file.chr1,         
       p_ath01    LIKE ath_file.ath01,
       l_asg02     LIKE asg_file.asg02,
       l_asg03     LIKE asg_file.asg03,
       l_asg05     LIKE asg_file.asg05    
 
    LET g_errno = ' '
 
    SELECT DISTINCT asg02,asg03,asg05 INTO l_asg02,l_asg03,l_asg05   
      FROM asg_file,asa_file,asb_file
     WHERE asg01 = p_ath01 AND asa01=g_ath02 AND asb01=g_ath02 AND asa01=asb01 
       AND (asa02 = g_ath01 OR asb04 = g_ath01) 
       
 
    CASE
       WHEN SQLCA.SQLCODE=100 
          LET g_errno = 'agl-608'    #MOD-B80311   
          LET l_asg02 = NULL
          LET l_asg03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_ath00=l_asg05
       DISPLAY l_asg02 TO FORMONLY.asg02 
       DISPLAY l_asg03 TO FORMONLY.asg03
       DISPLAY l_asg05 TO FORMONLY.ath00    
    END IF
 
END FUNCTION
 
FUNCTION i019_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ath02 TO NULL            
   INITIALIZE g_ath01 TO NULL             
   INITIALIZE g_ath00 TO NULL             
   MESSAGE ""
   CLEAR FORM
   CALL g_ath.clear()
 
   CALL i019_cs()                         #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i019_bcs                          #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ath02 TO NULL  
      INITIALIZE g_ath01 TO NULL
      INITIALIZE g_ath00 TO NULL  
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
      WHEN 'N' FETCH NEXT     i019_bcs INTO g_ath02,g_ath01,g_ath00  
      WHEN 'P' FETCH PREVIOUS i019_bcs INTO g_ath02,g_ath01,g_ath00  
      WHEN 'F' FETCH FIRST    i019_bcs INTO g_ath02,g_ath01,g_ath00  
      WHEN 'L' FETCH LAST     i019_bcs INTO g_ath02,g_ath01,g_ath00  
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
 
         FETCH ABSOLUTE g_jump i019_bcs INTO g_ath02,g_ath01,g_ath00  
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_ath01,SQLCA.sqlcode,0)
      INITIALIZE g_ath02 TO NULL    
      INITIALIZE g_ath01 TO NULL  
      INITIALIZE g_ath00 TO NULL  
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
 
   DISPLAY g_ath02 TO ath02      
   DISPLAY g_ath01 TO ath01 
   DISPLAY g_ath00 TO ath00      
 
   CALL i019_ath01('d',g_ath01)
         
   CALL s_get_aaz641(g_plant_asg03) RETURNING g_asz01
   CALL i019_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i019_r()
   DEFINE l_chr LIKE type_file.chr1          
 
   IF s_aglshut(0) THEN RETURN END IF
 
   IF cl_null(g_ath02) OR cl_null(g_ath01) OR cl_null(g_ath00) THEN   
      CALL cl_err('',-400,0)
      RETURN 
   END IF
 
   BEGIN WORK
 
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       
       LET g_doc.column1 = "ath02"     
       LET g_doc.value1  = g_ath02       
       LET g_doc.column2 = "ath01"      
       LET g_doc.value2  = g_ath01       
       LET g_doc.column3 = "ath00"     
       LET g_doc.value3  = g_ath00       
       CALL cl_del_doc()                                        
      DELETE FROM ath_file WHERE ath01=g_ath01 
                              AND ath00=g_ath00  
                              AND ath02=g_ath02  
      IF SQLCA.sqlcode THEN
          CALL cl_err3("del","ath_file",g_ath01,g_ath00,SQLCA.sqlcode,"","BODY DELETE:",1)  
      ELSE
         CLEAR FORM
         CALL g_ath.clear()
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
    l_ath04        LIKE ath_file.ath04,
    l_ath05        LIKE ath_file.ath05,
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
   IF cl_null(g_ath02) THEN
       RETURN 
   END IF
   CALL cl_opmsg('b')    
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT ath03,ath04,ath05,ath06,'','',ath07,ath08 FROM ath_file ",  
                      " WHERE ath02= ? AND ath01= ? AND ath00 = ? AND ath03 = ? FOR UPDATE "  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i019_bcl CURSOR FROM g_forupd_sql       # LOCK CURSOR
 
   LET l_ac_t = 0
   INPUT ARRAY g_ath WITHOUT DEFAULTS FROM s_ath.*
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
            LET g_ath_t.* = g_ath[l_ac].*  #BACKUP
 
            OPEN i019_bcl USING g_ath02,g_ath01,g_ath00,g_ath_t.ath03  
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ath_t.ath03,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i019_bcl INTO g_ath[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ath_t.ath03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i019_ath06(l_ac)
                  LET g_errno = ' '                         
               END IF
            END IF
 
            CALL cl_show_fld_cont()    
         END IF 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ath[l_ac].* TO NULL
         LET g_ath_t.* = g_ath[l_ac].*  
         CALL cl_show_fld_cont()     
         NEXT FIELD ath03
         
 
      AFTER INSERT
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         
 
         INSERT INTO ath_file(ath00,ath01,ath02,ath03,ath04,ath05,ath06,ath07,ath08,athacti,athuser,  
                              athgrup,athmodu,athdate,athoriu,athorig)  
                       VALUES(g_ath00,g_ath01,g_ath02,g_ath[l_ac].ath03,g_ath[l_ac].ath04,g_ath[l_ac].ath05,  
                              g_ath[l_ac].ath06,g_ath[l_ac].ath07,g_ath[l_ac].ath08,
                              'Y',g_user,g_grup,g_user,g_today, g_user, g_grup)  
 
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ath_file",g_ath01,g_ath[l_ac].ath03,SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
          

       AFTER FIELD ath03
         IF NOT cl_null(g_ath[l_ac].ath03) THEN 
             LET g_asg04 = ' ' 
             SELECT asg04 INTO g_asg04 FROM asg_file
              WHERE asg01 = g_ath01
               
                IF (g_ath_t.ath03 IS NOT NULL AND g_ath[l_ac].ath03 != g_ath_t.ath03) OR g_ath_t.ath03 IS NULL THEN  
                    SELECT count(*) INTO l_n 
                      FROM ath_file  
                     WHERE ath01 = g_ath01 
                       AND ath02 = g_ath02
                       AND ath03 = g_ath[l_ac].ath03                     
                       IF l_n > 0 THEN
                          CALL cl_err(g_ath[l_ac].ath03,'agl-602',0)
                          NEXT FIELD ath03
                       END IF 
                       CALL i019_ath03(l_ac)
                END IF
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ath[l_ac].ath03,g_errno,0)
                   NEXT FIELD ath03
                END IF
        END IF 
        DISPLAY BY NAME g_ath[l_ac].ath07,g_ath[l_ac].ath08     

      AFTER FIELD ath06
         IF cl_null(g_ath[l_ac].ath06) THEN 
               CALL cl_err('','agl-605',2)
               NEXT FIELD ath06
         END IF
         IF NOT cl_null(g_ath[l_ac].ath06) THEN 
            CALL i019_ath06(l_ac)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ath[l_ac].ath06,g_errno,2)
               NEXT FIELD ath06
            END IF
         END IF
      
      BEFORE DELETE                            #是否取消單身
         IF g_ath_t.ath03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            DELETE FROM ath_file
             WHERE ath01 = g_ath01 AND ath03 = g_ath_t.ath03 
               AND ath00 = g_ath00 AND ath02 = g_ath02  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ath_file",g_ath01,g_ath[l_ac].ath03,SQLCA.sqlcode,"","",1)  
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
            LET g_ath[l_ac].* = g_ath_t.*
            CLOSE i019_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN 
            CALL cl_err(g_ath[l_ac].ath04,-263,0)
            LET g_ath[l_ac].* = g_ath_t.*
         ELSE 
            UPDATE ath_file 
               SET ath03 = g_ath[l_ac].ath03,
                   ath04 = g_ath[l_ac].ath04,
                   ath05 = g_ath[l_ac].ath05,
                   ath06 = g_ath[l_ac].ath06,
                   ath07 = g_ath[l_ac].ath07,   
                   ath08 = g_ath[l_ac].ath08,   
                   athmodu = g_user,
                   athdate = g_today
             WHERE ath01 = g_ath01 
               AND ath00 = g_ath00  
               AND ath02 = g_ath02   
               AND ath03 = g_ath_t.ath03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ath_file",g_ath01,g_ath_t.ath03,SQLCA.sqlcode,"","",1)  
               LET g_ath[l_ac].* = g_ath_t.*
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
               LET g_ath[l_ac].* = g_ath_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_ath.deleteElement(l_ac)
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
            IF g_ath[l_ac].ath06=' ' THEN
               CALL cl_err('','agl-603',2)
               CALL fgl_set_arr_curr(l_ac)  
               NEXT FIELD ath06
            END IF
         END FOR
      
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ath03) AND l_ac > 1 THEN
            LET g_ath[l_ac].* = g_ath[l_ac-1].*
            NEXT FIELD ath03
         END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ath06) 
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_atg"  
              LET g_qryparam.default1 = g_ath[l_ac].ath06    
              CALL cl_create_qry() RETURNING g_ath[l_ac].ath06
              DISPLAY BY NAME g_ath[l_ac].ath06  
              NEXT FIELD ath06                                                                                                      
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
 
FUNCTION i019_ath06(l_cnt)
   DEFINE  l_cnt           LIKE type_file.num5,          
           l_atg02         LIKE atg_file.atg02,
           l_atg03         LIKE atg_file.atg03,
           l_aagacti       LIKE aag_file.aagacti  
 
   LET g_errno = ' '
 
   SELECT atg02,atg03,atgacti INTO l_atg02,l_atg03,l_aagacti FROM atg_file                                                                                                                                                                  
    WHERE atg01 = g_ath[l_cnt].ath06                                                                                                                                    
 
   CASE 
         WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-606' 
                                  LET g_ath[l_cnt].ath06=' '
         WHEN l_aagacti = 'N'     LET g_errno = '9028' 
         OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE 
 
   IF cl_null(g_errno) THEN
       LET g_ath[l_cnt].atg02 = l_atg02
       LET g_ath[l_cnt].atg03 = l_atg03
   END IF
    
END FUNCTION
   
FUNCTION i019_ath03(l_cnt)                    
   DEFINE  l_n             LIKE type_file.num5,  
           l_cnt           LIKE type_file.num5,
           l_nml02         LIKE nml_file.nml02,
           l_nml03         LIKE nml_file.nml03,
           l_nmlacti       LIKE nml_file.nmlacti

    LET g_asg04 = ' ' 
    SELECT asg04 INTO g_asg04 FROM asg_file
    WHERE asg01 = g_ath01
    LET g_errno = ' '     
 
    IF g_asg04 = 'N' THEN   #非TIPTOP公司
       LET g_sql = "SELECT atd16,atd17,'Y' ",
                   "  FROM atd_file ",
                   " WHERE atd02 ='",g_ath01,"'",
                   "   AND atd01 ='",g_ath02,"'",
                   "   AND atd05 ='",g_ath[l_ac].ath03,"'"
    ELSE                                        
       LET g_sql = "SELECT nml02,nml03,nmlacti ",
                   "  FROM ",cl_get_target_table(g_plant_gl,'nml_file'),  
                   " WHERE nml01 = '",g_ath[l_cnt].ath03,"'"
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
    
    LET g_ath[l_ac].ath07 = '1'
    LET g_ath[l_ac].ath08 = '1'

    IF cl_null(g_errno) THEN
       LET g_ath[l_cnt].ath04 = l_nml02
       LET g_ath[l_cnt].ath05 = l_nml03 
       
       SELECT count(atg01) INTO l_n FROM atg_file 
                WHERE atg01=g_ath[l_ac].ath03
       IF l_n>0 THEN 
           LET g_ath[l_ac].ath06 = g_ath[l_ac].ath03
           CALL i019_ath06(l_ac)
       END IF
    END IF
    DISPLAY BY NAME g_ath[l_cnt].ath04,g_ath[l_ac].ath05 
END FUNCTION


FUNCTION i019_b_askkey()
   DEFINE  l_wc   LIKE type_file.chr1000    
 
   CLEAR FORM
   CALL g_ath.clear()
   CALL g_ath.clear()
 
   CONSTRUCT l_wc ON ath03,ath04,ath05,ath06,atg02,atg03,ath07,ath08  #螢幕上取條件        
        FROM s_ath[1].ath03,s_ath[1].ath04,s_ath[1].ath05,s_ath[1].ath06,s_ath[1].atg02,s_ath[1].atg03,s_ath[1].ath07,s_ath[1].ath08
 
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
   LET g_sql = "SELECT ath03,ath04,ath05,ath06,'','',ath07,ath08 ",  
               " FROM ath_file ",
               " WHERE ath01 = '",g_ath01,"' AND ", p_wc CLIPPED ,
               "   AND ath00 = '",g_ath00,"'",
               "   AND ath02 = '",g_ath02,"'",     
               " ORDER BY ath03 "
   PREPARE i019_prepare2 FROM g_sql      #預備一下
   DECLARE ath_cs CURSOR FOR i019_prepare2
 
   CALL g_ath.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH ath_cs INTO g_ath[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      CALL i019_ath06(g_cnt)
      LET g_errno = ' '                 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_ath.deleteElement(g_cnt)
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
   DISPLAY ARRAY g_ath TO s_ath.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
DEFINE l_ath         RECORD LIKE ath_file.*,
       l_sql          LIKE type_file.chr1000,     
       l_oldno0       LIKE ath_file.ath00,        
       l_newno0       LIKE ath_file.ath00,        
       l_oldno1       LIKE ath_file.ath01,
       l_newno1       LIKE ath_file.ath01,
       l_oldno2       LIKE ath_file.ath02,                                                                          
       l_newno2       LIKE ath_file.ath02,                                                                          
       l_n       LIKE type_file.num5        
DEFINE l_ath01_cnt   LIKE type_file.num5         
   IF s_aglshut(0) THEN RETURN END IF
 
   IF cl_null(g_ath02) OR cl_null(g_ath01) OR cl_null(g_ath00) THEN  
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")    
 
     INPUT l_newno2,l_newno1 FROM ath02,ath01    
      AFTER FIELD ath02   #族群代號                                                                                                 
         IF l_newno2 IS NULL THEN                                                                                                   
            NEXT FIELD ath02                                                                                                        
         END IF                                                                                                                     
 
      AFTER FIELD ath01
         IF l_newno1 IS NULL THEN 
            NEXT FIELD ath01
         END IF
         SELECT COUNT(*)                                                                                                            
           INTO l_ath01_cnt                                                                                                         
           FROM asg_file                                                                                                            
          WHERE asg01 = l_newno1                                                                                                    
         IF SQLCA.SQLCODE=100  THEN                                                                                                 
            LET g_errno = 'aco-025'                                                                                     
         END IF                                                                                                                     
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(l_newno1,g_errno,0)
            NEXT FIELD ath01
         ELSE                                                                                                                       
            SELECT asg05 INTO l_newno0                                                                                              
              FROM asg_file                                                                                                         
             WHERE asg01 = l_newno1                                                                                                 
            DISPLAY l_newno0 TO ath00                                                                                               
         END IF
         IF l_newno2 IS NOT NULL AND l_newno1 IS NOT NULL AND                                                                       
            l_newno0 IS NOT NULL THEN                                                                                               
            LET l_n = 0                                                                                                
            SELECT COUNT(*) INTO l_n FROM asa_file,asb_file
             WHERE asa01=l_newno2 AND asa03=l_newno0 AND asb01=l_newno2 AND asa01=asb01
               AND (asa02=l_newno1 OR asb04=l_newno1)
        
            IF l_n = 0 THEN                                                                                                    
               CALL cl_err(l_newno1,'agl-608',0)    #MOD-B80311                                                                                    
               NEXT FIELD ath01                                                                                                     
            END IF                                                                                                                  
         END IF                                                                                                                     
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ath02) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_ath02"                                                                                     
               LET g_qryparam.default1 = l_newno2                                                                                   
               CALL cl_create_qry() RETURNING l_newno2                                                                              
               DISPLAY l_newno2 TO ath02                                                                                            
               NEXT FIELD ath02                                                                                                     
            WHEN INFIELD(ath01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asg" 
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               CALL i019_ath01('a',g_ath01)
               DISPLAY l_newno1 TO ath01 
               NEXT FIELD ath01
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
      DISPLAY g_ath01 TO ath01 
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM ath_file         #單身複製
    WHERE ath01=g_ath01 
      AND ath00=g_ath00  
      AND ath02=g_ath02  
     INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ath_file",g_ath01,g_ath00,SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET ath01=l_newno1,ath00=l_newno0,ath02=l_newno2  
 
   INSERT INTO ath_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ath_file",l_newno1,l_newno0,SQLCA.sqlcode,"","ath:",1)  
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
 
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
   
   LET l_oldno2 = g_ath02     
   LET l_oldno1 = g_ath01 
   LET l_oldno0 = g_ath00   
   LET g_ath02 = l_newno2     
   LET g_ath01 = l_newno1
   LET g_ath00 = l_newno0     
 
   CALL i019_b()
   #FUN-C80046---end
   #LET g_ath02 = l_oldno2     
   #LET g_ath01 = l_oldno1
   #LET g_ath00 = l_oldno0     
   #
   #CALL i019_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION i019_out()
   DEFINE l_i             LIKE type_file.num5,          
          l_name          LIKE type_file.chr20,         
          l_chr           LIKE type_file.chr1,          
          sr              RECORD
          ath02          LIKE ath_file.ath02,     #族群代號  
          ath01          LIKE ath_file.ath01,     #營運中心
          ath00          LIKE ath_file.ath00,     #帳套  
          ath03          LIKE ath_file.ath03,     #來源公司現金變動碼
          ath04          LIKE ath_file.ath04,     #來源公司現金碼名稱
          ath05          LIKE ath_file.ath05,     #來源公司現金碼分類
          ath06          LIKE ath_file.ath06,     #合併后現金變動碼
          atg02           LIKE atg_file.atg02,       #合併現金碼名稱
          atg03           LIKE atg_file.atg03,       #合併現金碼分類
          ath07          LIKE ath_file.ath07,     #再衡量匯率類別
          ath08          LIKE ath_file.ath08      #換算匯率類別
                          END RECORD
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql="SELECT DISTINCT * ", # 組合出 SQL 指令  
             " FROM ath_file, atg_file ",
             " WHERE ",g_wc CLIPPED ,
             "   AND ath06 = atg_file.atg01",   
             " ORDER BY 1 "   
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(g_wc,'ath02,ath01,ath00,ath03,ath04,ath05,ath06,ath07,ath08')  
      RETURNING g_wc                                                          
      LET g_str = g_str CLIPPED,";", g_wc                                     
   END IF                                                                      
   LET g_str =  g_wc    
   CALL cl_prt_cs1('ggli019','ggli019',g_sql,g_str)
END FUNCTION

FUNCTION  i019_ath01_g(p_ath01,p_ath02)  
DEFINE p_ath01    LIKE ath_file.ath01,        
       p_ath02    LIKE ath_file.ath02,
       l_asg02     LIKE asg_file.asg02,
       l_asg03     LIKE asg_file.asg03,
       l_asg05     LIKE asg_file.asg05 

      SELECT DISTINCT asg02,asg03,asg05 INTO l_asg02,l_asg03,l_asg05   
        FROM asg_file,asa_file,asb_file
       WHERE asg01 = p_ath01 AND asa01=p_ath02 AND asb01=p_ath02 AND asa01=asb01 
         AND (asa02 = p_ath01 OR asb04 = p_ath01) 
      CASE
        WHEN SQLCA.SQLCODE=100 
         LET g_errno = 'agl-608'    #MOD-B80311   
         LET l_asg02 = NULL
         LET l_asg03 = NULL 
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
      END CASE

      IF cl_null(g_errno)  THEN
         LET g_ath00=l_asg05
         DISPLAY l_asg02 TO FORMONLY.asg02 
         DISPLAY l_asg03 TO FORMONLY.asg03
         DISPLAY l_asg05 TO FORMONLY.ath00    
      END IF
END FUNCTION
 
FUNCTION i019_g()
   DEFINE l_sql         LIKE type_file.chr1000,   
          l_ath06      LIKE ath_file.ath06,
          l_nml01       LIKE nml_file.nml01,
          l_nml02       LIKE nml_file.nml02,
          l_nml03       LIKE nml_file.nml03,
          l_type        STRING,                   
          l_flag        LIKE type_file.chr1,      
          l_asg03       LIKE asg_file.asg03,      
          g_asg04       LIKE asg_file.asg04,      
          l_n           LIKE type_file.num5          
     
   DEFINE l_ath07      LIKE ath_file.ath07       
   DEFINE l_ath08      LIKE ath_file.ath08            
   DEFINE l_aag01_t     LIKE aag_file.aag01       
   DEFINE l_atg01       LIKE atg_file.atg01
   DEFINE l_atg01_t     LIKE atg_file.atg01  
   DEFINE l_tmp         LIKE aag_file.aag08       
   DEFINE l_qbe_nml01   LIKE nml_file.nml01      
   DEFINE l_ath        DYNAMIC ARRAY OF RECORD
          ath03        LIKE ath_file.ath03,  
          ath04        LIKE ath_file.ath04,                 
          ath05        LIKE ath_file.ath05,                 
          ath06        LIKE ath_file.ath06,                  
          atg02         LIKE atg_file.atg02,
          atg03         LIKE atg_file.atg03,
          ath07        LIKE ath_file.ath07, 
          ath08        LIKE ath_file.ath08 
                        END RECORD
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_wc          LIKE type_file.chr1000
   DEFINE l_asg02       LIKE asg_file.asg02,
          l_asg05       LIKE asg_file.asg05 
 
   OPEN WINDOW i019_w3 AT 6,11
     WITH FORM "ggl/42f/ggli019_g"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("ggli019_g")
 
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
    
      INPUT tm.ath02,tm.ath01 WITHOUT DEFAULTS                                      
       FROM FORMONLY.ath02,FORMONLY.ath01   
 
         AFTER FIELD ath01
            IF NOT cl_null(tm.ath01) THEN 
                CALL i019_ath01_g(tm.ath01,tm.ath02)
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.ath01,g_errno,0)
                  NEXT FIELD ath01
                ELSE                                                                                                                 
                  SELECT asg05 INTO g_ath00_def                                                                                     
                    FROM asg_file                                                                                                   
                   WHERE asg01 = tm.ath01                                                                                           
               END IF                                                                                                               
            END IF

         AFTER FIELD ath02   #族群代號                                                                                         
            IF cl_null(tm.ath02) THEN                                                                                           
               CALL cl_err(tm.ath02,'mfg0037',0)                                                                                
               NEXT FIELD ath02                                                                                                
            ELSE                                                                                                               
              LET l_n = 0                                                                                                     
              SELECT COUNT(*) INTO l_n FROM asa_file                                                                          
               WHERE asa01=tm.ath02                                                                                                                                                                   
              IF l_n = 0 THEN                                                                                                 
                 CALL cl_err(tm.ath02,'agl-608',0)    #MOD-B80311                                                                             
                 NEXT FIELD ath02                                                                                             
              END IF                                                                                                          
            END IF       
    
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()
    
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ath02) #族群編號                                                                                        
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_ath02"           
                  LET g_qryparam.default1 = tm.ath02                                                                                
                  CALL cl_create_qry() RETURNING tm.ath02                                                                           
                  DISPLAY tm.ath02 TO ath02                                                                                         
                  NEXT FIELD ath02                                                                                                  
               WHEN INFIELD(ath01)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_asg"     
                  LET g_qryparam.default1 = tm.ath01
                  CALL cl_create_qry() RETURNING tm.ath01
                  CALL i019_ath01('a',g_ath01)
                  DISPLAY tm.ath01 TO ath01 
                  NEXT FIELD ath01
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

        SELECT asg03,asg04 INTO g_asg03,g_asg04 FROM asg_file
         WHERE asg01 = tm.ath01
         IF g_asg04 = 'N' THEN			
            LET g_plant_gl = g_plant			
         ELSE			
            LET g_plant_gl = g_asg03			
         END IF 			
  
          IF g_asg04 = 'N' THEN 
             LET g_wc2=cl_replace_str(g_wc2,"nml01",'atd05')
             LET l_sql ="SELECT UNIQUE atd05,atd16,atd17 FROM atd_file ", 
                        " WHERE ", g_wc2 CLIPPED, 
                        "   AND atd01 = '",tm.ath02,"'",   #下層公司
                        "   AND atd02 = '",tm.ath01,"'"   #群組 
  
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
 
            LET l_ath[i].ath03 = l_nml01
            LET l_ath[i].ath04 = l_nml02
            LET l_ath[i].ath05 = l_nml03

            SELECT count(atg01) INTO l_n FROM atg_file 
                                WHERE atg01=l_ath[i].ath03
            IF l_n=0 THEN 
               LET l_ath[i].ath06=' '
            ELSE
               LET l_ath[i].ath06 = l_ath[i].ath03
            END IF  

            SELECT atg02,atg03 INTO l_ath[i].atg02,l_ath[i].atg03 FROM atg_file 
                 WHERE atg01=l_ath06

            LET l_ath[i].ath07 = '1'
            LET l_ath[i].ath08 = '1'
            
            INSERT INTO ath_file (ath00,ath01,ath02,ath03,ath04,ath05,ath06,ath07,ath08, 
                                 athacti,athuser,athgrup,athmodu,athdate,athoriu,athorig)
                         VALUES (g_ath00_def,tm.ath01,tm.ath02,l_ath[i].ath03,l_ath[i].ath04,
                                 l_ath[i].ath05,l_ath[i].ath06,
                                 l_ath[i].ath07,l_ath[i].ath08,
                                  'Y',g_user,g_grup,' ',g_today, g_user, g_grup)        
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  
               CONTINUE FOREACH     
            ELSE
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","ath_file",tm.ath01,l_nml01,STATUS,"","ins ath",1)  
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
   LET g_ath01=tm.ath01
   LET g_ath02=tm.ath02
   LET g_ath00=g_ath00_def
   CALL i019_show()
   CALL i019_b()
END FUNCTION

