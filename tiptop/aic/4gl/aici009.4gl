# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: aici009.4gl
# Descriptions...: ICD料件ASS維護作業
# Date & Author..: No.FUN-7B0073 07/11/14 By sherry
#                  No.TQC-830049 08/03/36 By sherry 修改資料的狀態字段 
#                  No.TQC-8C0052 09/01/15 By kim 理由碼的欄位檢查有誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0027 09/11/04 By wujie 5.2SQL转标准语法
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

 
GLOBALS "../../config/top.global"
#No.FUN-7B0073---Begin
#模組變數(Module Variables)
DEFINE 
    g_icj01       LIKE icj_file.icj01,
    g_icj01_t     LIKE icj_file.icj01,
    g_icj02       LIKE icj_file.icj02,
    g_icj02_t     LIKE icj_file.icj02,
    g_icj03       LIKE icj_file.icj03,
    g_icj03_t     LIKE icj_file.icj03,
    g_icjuser     LIKE icj_file.icjuser,
    g_icjgrup     LIKE icj_file.icjgrup,
    g_icjdate     LIKE icj_file.icjdate,
    g_icjacti     LIKE icj_file.icjacti,
    g_icjmodu     LIKE icj_file.icjmodu,    
    g_icj         DYNAMIC ARRAY OF RECORD
       icj02      LIKE icj_file.icj02,
       icj02_desc LIKE type_file.chr1000,
       icj03      LIKE icj_file.icj03,
       pmc03      LIKE pmc_file.pmc03,
       icj09      LIKE icj_file.icj09,
       icj10      LIKE icj_file.icj10,
       icj11      LIKE icj_file.icj11,
       icj12      LIKE icj_file.icj12,
       icj13      LIKE icj_file.icj13,
       icj14      LIKE icj_file.icj14,
       icj15      LIKE icj_file.icj15,
       icj16      LIKE icj_file.icj16,
       icd03      LIKE icd_file.icd03,
       icj18      LIKE icj_file.icj18,
       icj05      LIKE icj_file.icj05,
       icj06      LIKE icj_file.icj06,
       icj07      LIKE icj_file.icj07,
       icj17      LIKE icj_file.icj17
                  END RECORD,
    g_icj_t       RECORD 
       icj02      LIKE icj_file.icj02,                                          
       icj02_desc LIKE type_file.chr1000,                                       
       icj03      LIKE icj_file.icj03,                                          
       pmc03      LIKE pmc_file.pmc03,                                          
       icj09      LIKE icj_file.icj09,                                          
       icj10      LIKE icj_file.icj10,                                          
       icj11      LIKE icj_file.icj11,                                          
       icj12      LIKE icj_file.icj12,                                          
       icj13      LIKE icj_file.icj13,                                          
       icj14      LIKE icj_file.icj14,                                          
       icj15      LIKE icj_file.icj15,                                          
       icj16      LIKE icj_file.icj16,                                          
       icd03      LIKE icd_file.icd03,                                          
       icj18      LIKE icj_file.icj18,                                          
       icj05      LIKE icj_file.icj05,                                          
       icj06      LIKE icj_file.icj06,                                          
       icj07      LIKE icj_file.icj07,                                          
       icj17      LIKE icj_file.icj17                                           
                  END RECORD,           
      
    a             LIKE type_file.chr1,     
    g_wc,g_sql,g_wc2  STRING,                                                   
    g_show            LIKE type_file.chr1,         
    g_rec_b           LIKE type_file.num5,    #單身筆數 
    g_flag            LIKE type_file.chr1,               
    g_ss              LIKE type_file.chr1,               
    l_ac              LIKE type_file.num5,    #目前處理
    g_argv1           LIKE ick_file.ick01                                      
DEFINE p_row,p_col    LIKE type_file.num5    
#主程式開始                                                                     
DEFINE   g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL                       
DEFINE   g_sql_tmp    STRING                              
DEFINE   g_before_input_done   LIKE type_file.num5     
DEFINE   g_chr                 LIKE type_file.chr1
DEFINE   g_cnt                 LIKE type_file.num10      
DEFINE   g_msg         LIKE ze_file.ze03            
DEFINE   g_jump        LIKE type_file.num10   
DEFINE   g_abso        LIKE type_file.num10   
DEFINE   g_row_count   LIKE type_file.num10       
DEFINE   g_curs_index  LIKE type_file.num10          
DEFINE   l_cmd         LIKE type_file.chr1000  
DEFINE   mi_no_ask     LIKE type_file.num5
DEFINE   g_str         STRING
MAIN                                                                            
                                                                                
   OPTIONS                               #改變一些系統預設值                   
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理               
                                                                                
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
                                                                        
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_argv1 =ARG_VAL(1)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i009_w AT p_row,p_col
     WITH FORM "aic/42f/aici009"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN                                                                                                     
      CALL i009_q()                                                                                                                 
   END IF
 
   CALL i009_menu()
 
   CLOSE WINDOW i009_w                 #結束畫面 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料                                                                   
FUNCTION i009_cs()                                                              
DEFINE l_sql STRING                                                             
   IF NOT cl_null(g_argv1) THEN                                                 
      LET g_wc = " icj01 = '",g_argv1,"'"                  
   ELSE                                                                                       
       INITIALIZE g_icj01 TO NULL                    
       CONSTRUCT g_wc ON icj01,icj02,icj03,icj09,icj10,icj11,icj12,icj13,
                         icj14,icj15,icj16,icj18,icj05,icj06,icj07,icj17
          FROM icj01,s_icj[1].icj02,s_icj[1].icj03,s_icj[1].icj09,
               s_icj[1].icj10,s_icj[1].icj11,s_icj[1].icj12,
               s_icj[1].icj13,s_icj[1].icj14,s_icj[1].icj15,
               s_icj[1].icj16,s_icj[1].icj18,s_icj[1].icj05,
               s_icj[1].icj06,s_icj[1].icj07,s_icj[1].icj17
                
       BEFORE CONSTRUCT                                                         
          CALL cl_qbe_init()                     
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(icj01)
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form  ="q_ima"
              #  LET g_qryparam.state ="c"
              #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO icj01
                NEXT FIELD icj01
             WHEN INFIELD(icj02)                                                
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()                                          
              #  LET g_qryparam.form  ="q_ima"                                   
              #  LET g_qryparam.state ="c"                                       
              #  CALL cl_create_qry() RETURNING g_qryparam.multiret              
                CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO icj02                           
                NEXT FIELD icj02
             WHEN INFIELD(icj03)                                                
                CALL cl_init_qry_var()                                          
                LET g_qryparam.form  ="q_pmc2"                                   
                LET g_qryparam.state ="c"                                       
                CALL cl_create_qry() RETURNING g_qryparam.multiret              
                DISPLAY g_qryparam.multiret TO icj03                            
                NEXT FIELD icj03
             WHEN INFIELD(icj16)                                                
                CALL cl_init_qry_var()                                          
                LET g_qryparam.form  ="q_icd"                                  
                LET g_qryparam.state ="c"                                       
                CALL cl_create_qry() RETURNING g_qryparam.multiret              
                DISPLAY g_qryparam.multiret TO icj16                            
                NEXT FIELD icj16 
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('icjuser', 'icjgrup') #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT UNIQUE icj01 FROM icj_file ",
              " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY icj01"       
    PREPARE i009_prepare FROM g_sql      #預備一下                              
    DECLARE i009_bcs                     #宣告成動的                        
      SCROLL CURSOR WITH HOLD FOR i009_prepare                                
 
    DROP TABLE i009_cnttmp
    LET g_sql = "SELECT COUNT(UNIQUE icj01) FROM icj_file WHERE ",g_wc CLIPPED  
    PREPARE i009_precount FROM g_sql    
    DECLARE i009_count CURSOR FOR i009_precount
 
    IF NOT cl_null(g_argv1) THEN                                                
       LET g_icj01=g_argv1                                                      
    END IF  
 
    CALL i009_show()
END FUNCTION     
 
FUNCTION i009_menu()
 
   WHILE TRUE
      CALL i009_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i009_a()
            END IF
         #WHEN "modify"
         #   IF cl_chk_act_auth() THEN
         #      CALL i009_u()
         #   END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i009_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i009_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i009_copy()
            END IF
         #WHEN "invalid"
         #   IF cl_chk_act_auth() THEN
         #      CALL i009_x()
         #   END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i009_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i009_out()
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_icj),'','')
            END IF
         WHEN "related_document"           
            IF cl_chk_act_auth() THEN
               IF g_icj01 IS NOT NULL THEN
                  LET g_doc.column1 = "icj01"
                  LET g_doc.value1 = g_icj01
                  CALL cl_doc()
               END IF 
            END IF
      END CASE
   END WHILE
END FUNCTION     
 
FUNCTION i009_a()                                                               
   MESSAGE ""                                                                   
   CLEAR FORM 
   LET g_wc = NULL                                                                  
   CALL g_icj.clear()  
   LET g_icj01  = NULL                                                         
   LET g_icj01_t  = NULL                                                        
   LET g_icj02_t  = NULL                                                        
   LET g_icj03_t  = NULL
   LET g_icjuser = g_user                                                       
   LET g_icjgrup = g_grup                                                       
   LET g_icjdate = g_today                                                      
   LET g_icjacti = 'Y'                                                                   
   LET g_icjmodu = ''
   CALL cl_opmsg('a')                                                           
                                                                                
   WHILE TRUE
      CALL i009_i("a")                   #輸入單頭                              
                                                                                
      IF INT_FLAG THEN                   #使用者不玩了                          
         LET g_icj01=NULL                                                       
         LET g_icj02=NULL                                                       
         LET g_icj03=NULL                                                       
         LET INT_FLAG = 0                                                       
         CALL cl_err('',9001,0)                                                 
         EXIT WHILE                                                             
      END IF   
      IF g_ss='N' THEN                                                          
         CALL g_icj.clear()                                                     
      ELSE                                                                      
         CALL i009_b_fill('1=1')         #單身                               
      END IF                                                                    
      LET g_rec_b = 0                     
                                                                                
      CALL i009_b()                      #輸入單身                              
                                                                                
      LET g_icj01_t = g_icj01                                                   
      LET g_icj02_t = g_icj02                                                   
      LET g_icj03_t = g_icj03    
      EXIT WHILE                                                                
   END WHILE                                                                    
                                                                                
END FUNCTION                 
 
FUNCTION i009_i(p_cmd)                                                          
DEFINE                                                                          
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改   
    l_cnt           LIKE type_file.num10,      
    l_n             LIKE type_file.num5                                                                               
    LET g_ss='Y'                                                                
                                                                                
    CALL cl_set_head_visible("","YES")                           
    INPUT g_icj01 WITHOUT DEFAULTS FROM icj01                                     
 
    AFTER FIELD icj01 
         IF NOT cl_null(g_icj01) THEN
           #FUN-AA0059 ------------------add start--------------
            IF NOT s_chk_item_no(g_icj01,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_icj01 = g_icj01_t
               NEXT FIELD icj01
            END IF 
           #FUN-AA0059 --------------------add end-------------
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_icj01 != g_icj01_t) THEN
               SELECT UNIQUE icj01 INTO g_chr
                 FROM icj_file
                WHERE icj01 = g_icj01
               IF SQLCA.sqlcode THEN             
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_icj01,-239,0)
                     LET g_icj01 = g_icj01_t
                     NEXT FIELD icj01
                  END IF
               END IF
            END IF
            CALL i009_icj01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_icj01,g_errno,0)
               LET g_icj01 = g_icj01_t
               NEXT FIELD icj01
            END IF
         END IF                
                                                                
       AFTER INPUT          
          IF INT_FLAG THEN
             EXIT INPUT
          END IF                                                    
          IF g_icj01 IS NULL THEN               
             NEXT FIELD icj01                  
          END IF 
 
         ON ACTION CONTROLP                                                       
            CASE                                                                  
              WHEN INFIELD(icj01)                                                
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()                                          
              #  LET g_qryparam.form  ="q_ima"                                   
              #  LET g_qryparam.default1 = g_icj01                     
              #  CALL cl_create_qry() RETURNING g_icj01               
                CALL q_sel_ima(FALSE, "q_ima", "",g_icj01, "", "", "", "" ,"",'' )  RETURNING g_icj01 
#FUN-AA0059 --End--
                DISPLAY g_icj01 TO icj01                               
                NEXT FIELD icj01
              OTHERWISE EXIT CASE
            END CASE        
 
         ON ACTION CONTROLG                                                     
           CALL cl_cmdask()                                                     
                                                                                
         ON IDLE g_idle_seconds                                                 
           CALL cl_on_idle()                                                    
           CONTINUE INPUT                                                       
                                                                                
         ON ACTION about                                       
            CALL cl_about()                                     
                                                                                
         ON ACTION help                                        
            CALL cl_show_help()                                
                                                                                
         ON ACTION CONTROLF                  #欄位說明                            
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)                          
    END INPUT          
END FUNCTION
 
FUNCTION i009_q()                                                               
   LET g_icj01 = ''                                                             
   LET g_icj02 = ''                                                             
   LET g_icj03 = ''                                                             
   LET g_row_count = 0                                                          
   LET g_curs_index = 0                                                         
   CALL cl_navigator_setting( g_curs_index, g_row_count )                       
   INITIALIZE g_icj01 TO NULL                            
   MESSAGE ""                                                                   
   CALL cl_opmsg('q')                                                           
   CLEAR FORM                                                                   
   CALL g_icj.clear()                                                           
   DISPLAY '' TO FORMONLY.cnt                                                   
                                                                                
   CALL i009_cs()                      #取得查詢條件                            
                                                                                
   IF INT_FLAG THEN                    #使用者不玩了                            
      LET INT_FLAG = 0         
      INITIALIZE g_icj01 TO NULL                                        
      RETURN                                                                    
   END IF                                                                       
                                                                                
   OPEN i009_bcs                       #從DB產生合乎條件TEMP(0-30秒)            
   IF SQLCA.sqlcode THEN               #有問題                                  
      CALL cl_err('',SQLCA.sqlcode,0)                                           
      INITIALIZE g_icj01 TO NULL                                        
   ELSE                                                                         
      OPEN i009_count                                                           
      FETCH i009_count INTO g_row_count   
      DISPLAY g_row_count TO FORMONLY.cnt                                       
      CALL i009_fetch('F')            #讀出TEMP第一筆并顯示                     
   END IF                                                                       
                                                                                
END FUNCTION     
 
#處理資料的讀取                                                                 
FUNCTION i009_fetch(p_flag)                                                     
DEFINE                                                                          
   p_flag          LIKE type_file.chr1    #處理方式       
                                                                                
   MESSAGE ""                                                                   
   CASE p_flag                                                                  
       WHEN 'N' FETCH NEXT     i009_bcs INTO g_icj01                   
       WHEN 'P' FETCH PREVIOUS i009_bcs INTO g_icj01             
       WHEN 'F' FETCH FIRST    i009_bcs INTO g_icj01       
       WHEN 'L' FETCH LAST     i009_bcs INTO g_icj01
       WHEN '/'  
         IF (NOT mi_no_ask) THEN                                                              
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg                      
            LET INT_FLAG = 0  ######add for prompt bug                          
            PROMPT g_msg CLIPPED,': ' FOR g_abso  
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
            FETCH ABSOLUTE g_abso i009_bcs 
                  INTO g_icj01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                     #有麻煩
      CALL cl_err(g_icj01,SQLCA.sqlcode,0)
      INITIALIZE g_icj01 TO NULL  
      INITIALIZE g_icj02 TO NULL  
      INITIALIZE g_icj03 TO NULL  
   ELSE
      CALL i009_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上                                                             
FUNCTION i009_show()                                                            
  
   DISPLAY g_icj01 TO icj01
 
   CALL i009_icj01('d')                                                                             
   CALL i009_b_fill(g_wc)                      #單身                            
   CALL cl_show_fld_cont()                             
END FUNCTION
 
#單身                                                                           
FUNCTION i009_b()                                                               
DEFINE                                                                          
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,          #檢查重復用        
   l_n1            LIKE type_file.num5,          #檢查重復用        
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        
   p_cmd           LIKE type_file.chr1,          #處理狀態         
   l_allow_insert  LIKE type_file.num5,          #可新增否         
   l_allow_delete  LIKE type_file.num5,          #可刪除否         
   l_cnt           LIKE type_file.num10,     
   l_imaacti       LIKE ima_file.imaacti,
   l_pmcacti       LIKE pmc_file.pmcacti,
   l_icdacti       LIKE icd_file.icdacti,
   l_icjacti       LIKE icj_file.icjacti,
   l_ima02         LIKE ima_file.ima02
                                                                             
   LET g_action_choice = ""
 
   #No.TQC-830049---Begin                                                     
   LET g_icjuser = g_user                                                       
   LET g_icjgrup = g_grup                                                       
   LET g_icjdate = g_today                                                      
   LET g_icjacti = 'Y'                                                          
   LET g_icjmodu = ''    
   #No.TQC-830049---End                                                                              
   IF cl_null(g_icj01) THEN   
      CALL cl_err('',-400,1)                                                    
      RETURN                                        
   END IF                                                                       
                                                                                
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF           
  
   IF g_icjacti = 'N' THEN                                                 
      CALL cl_err('',9027,0)                                                  
      RETURN                                                                  
   END IF
           
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT icj02,'',icj03,'',icj09,icj10,icj11,icj12, ",
                      "icj13,icj14,icj15,icj16,'',icj18,icj05,icj06,icj07,",
                      "icj17 ",
                      " FROM icj_file",
                      " WHERE icj01 = ? AND icj02= ? AND icj03= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i009_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   #IF g_rec_b=0 THEN CALL g_icj.clear() END IF
 
   INPUT ARRAY g_icj WITHOUT DEFAULTS FROM s_icj.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
            LET p_cmd='u'
            LET g_icj01_t = g_icj01
            LET g_icj_t.* = g_icj[l_ac].*  #BACKUP
            OPEN i009_bcl USING g_icj01,g_icj[l_ac].icj02,g_icj[l_ac].icj03
            IF STATUS THEN
               CALL cl_err("OPEN i009_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i009_bcl INTO g_icj[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i009_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT ima02 INTO g_icj[l_ac].icj02_desc FROM ima_file
                   WHERE ima01 = g_icj[l_ac].icj02
                  SELECT pmc03 INTO g_icj[l_ac].pmc03 FROM pmc_file
                   WHERE pmc01 = g_icj[l_ac].icj03   
                  SELECT icd03 INTO g_icj[l_ac].icd03 FROM icd_file
                   WHERE icd01 = g_icj[l_ac].icj16
                     AND icd02 = 'S'  #TQC-8C0052
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
  
      BEFORE INSERT                                                             
         LET l_n = ARR_COUNT()                                                  
         LET p_cmd='a'                                                          
         LET g_before_input_done = FALSE
         INITIALIZE g_icj[l_ac].* TO NULL                   
         LET g_before_input_done = TRUE
         LET g_icj_t.* = g_icj[l_ac].*               #新輸入資料                
         CALL cl_show_fld_cont()                                                
         NEXT FIELD icj02 
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO icj_file(icj01,icj02,icj03,icj09,icj10,icj11,icj12,icj13,
                              icj14,icj15,icj16,icj18,icj05,icj06,icj07,icj17,
                              icjuser,icjgrup,icjmodu,icjacti,icjdate ,icjoriu,icjorig)
               VALUES(g_icj01,g_icj[l_ac].icj02,g_icj[l_ac].icj03,
                      g_icj[l_ac].icj09,g_icj[l_ac].icj10,g_icj[l_ac].icj11,
                      g_icj[l_ac].icj12,g_icj[l_ac].icj13,g_icj[l_ac].icj14,
                      g_icj[l_ac].icj15,g_icj[l_ac].icj16,g_icj[l_ac].icj18,
                      g_icj[l_ac].icj05,g_icj[l_ac].icj06,g_icj[l_ac].icj07,
                      g_icj[l_ac].icj17,g_icjuser,g_icjgrup,g_icjmodu,
                      g_icjacti,g_icjdate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","icj_file",g_icj[l_ac].icj02,g_icj[l_ac].icj03,SQLCA.sqlcode,"","",1)  #No.FUN-660138
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cnt2
         END IF
    
      AFTER FIELD icj02                         # check data  是否重復
         IF NOT cl_null(g_icj[l_ac].icj02) THEN
           #FUN-AA0059 -----------------------add start-----------
            IF NOT s_chk_item_no(g_icj[l_ac].icj02,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_icj[l_ac].icj02 = g_icj02_t
               NEXT FIELD icj02
            END IF 
           #FUN-AA0059 ----------------------add end--------------
            IF g_icj[l_ac].icj02 != g_icj_t.icj02 OR g_icj_t.icj02 IS NULL THEN
               CALL i009_icj02('a')
               IF NOT cl_null(g_errno) THEN                                        
                  CALL cl_err(g_icj[l_ac].icj02,g_errno,0)                                   
                  LET g_icj[l_ac].icj02 = g_icj02_t                                          
                  NEXT FIELD icj02                                                 
               END IF  
            END IF
         END IF
 
         AFTER FIELD icj03 #ASS VENDOR
            IF NOT cl_null(g_icj[l_ac].icj03) THEN
               IF g_icj[l_ac].icj02 = g_icj_t.icj02 AND g_icj[l_ac].icj03 = g_icj_t.icj03 THEN
                  LET g_icj[l_ac].icj02 = g_icj_t.icj02
                  LET g_icj[l_ac].icj03 = g_icj_t.icj03
               ELSE
                  SELECT COUNT(*) INTO l_n1 FROM icj_file WHERE icj01 = g_icj01 AND icj02 = g_icj[l_ac].icj02 AND icj03 = g_icj[l_ac].icj03
                  IF l_n1 > 0 THEN
                     CALL cl_err('','atm-310',0)
                     NEXT FIELD  icj03
                     LET l_n1 = 0 
                  END IF
               END IF 
               #SELECT pmc03,pmcacti INTO g_icj[l_ac].pmc03,l_pmcacti
               #  FROM pmc_file
               # WHERE pmc01 = g_icj[l_ac].icj03
               #IF SQLCA.SQLCODE THEN
               #   CALL cl_err(g_icj[l_ac].icj03,SQLCA.SQLCODE,0)
               #   LET g_icj[l_ac].icj03 = g_icj_t.icj03
               #   LET g_icj[l_ac].pmc03 = g_icj_t.pmc03
               #   NEXT FIELD icj03
               #END IF
               #IF l_pmcacti != 'Y' THEN
               #   CALL cl_err(g_icj[l_ac].icj03,'9028',0)
               #   LET g_icj[l_ac].icj03 = g_icj_t.icj03
               #   LET g_icj[l_ac].pmc03 = g_icj_t.pmc03
               #   NEXT FIELD icj03
               #END IF
               #DISPLAY BY NAME g_icj[l_ac].pmc03
               CALL i009_icj03('a')                                             
               IF NOT cl_null(g_errno) THEN                                     
                  CALL cl_err(g_icj[l_ac].icj03,g_errno,0)                      
                  LET g_icj[l_ac].icj03 = g_icj03_t                             
                  NEXT FIELD icj03                                              
               END IF 
               IF p_cmd = 'a' OR (p_cmd = 'u' AND
                  (g_icj[l_ac].icj02 != g_icj_t.icj02 OR
                   g_icj[l_ac].icj03 != g_icj_t.icj03)) THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM icj_file
                   WHERE icj01 = g_icj01
                     AND icj02 = g_icj[l_ac].icj02
                     AND icj03 = g_icj[l_ac].icj03
                  IF l_n > 0 THEN
                     CALL cl_err(g_icj[l_ac].icj03,'-239',0)
                     LET g_icj[l_ac].icj03 = g_icj_t.icj03
                     LET g_icj[l_ac].pmc03 = g_icj_t.pmc03
                     NEXT FIELD icj03
                  END IF
               END IF
            END IF  
 
         AFTER FIELD icj16 #Ink Material
            IF NOT cl_null(g_icj[l_ac].icj16) THEN
               SELECT icd03,icdacti INTO g_icj[l_ac].icd03,l_icdacti
                 FROM icd_file
                WHERE icd01 = g_icj[l_ac].icj16
                  AND icd02 = "S"
                  AND icdacti = "Y"
               IF SQLCA.SQLCODE THEN
                  CALL cl_err(g_icj[l_ac].icj16,SQLCA.SQLCODE,0)
                  LET g_icj[l_ac].icj16 = g_icj_t.icj16
                  LET g_icj[l_ac].icd03 = g_icj_t.icd03
                  NEXT FIELD icj16
               END IF
               IF l_icjacti != 'Y' THEN
                  CALL cl_err(g_icj[l_ac].icj16,'9028',0)
                  LET g_icj[l_ac].icj16 = g_icj_t.icj16
                  LET g_icj[l_ac].icd03 = g_icj_t.icd03
                  NEXT FIELD icj16
               END IF
               DISPLAY BY NAME g_icj[l_ac].icd03 
            END IF 
      AFTER FIELD icj18
         IF g_icj[l_ac].icj18 < 0 THEN
            CALL cl_err(g_icj[l_ac].icj18,'amm-110',0)
            NEXT FIELD icj18
         END IF  
      BEFORE DELETE                            # 是否取消單身 
         IF NOT cl_null(g_icj_t.icj02) AND 
            NOT cl_null(g_icj_t.icj03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM icj_file WHERE icj01 = g_icj01
                                   AND icj02 = g_icj_t.icj02
                                   AND icj03 = g_icj_t.icj03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","icj_file",g_icj[l_ac].icj02,g_icj[l_ac].icj03,SQLCA.sqlcode,"","",1)  #No.FUN-660138
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cnt2
         END IF
         COMMIT WORK   
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_icj[l_ac].* = g_icj_t.*
            CLOSE i009_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_icj[l_ac].icj02,-263,1)
            LET g_icj[l_ac].* = g_icj_t.*
         ELSE
            UPDATE icj_file SET icj02 = g_icj[l_ac].icj02,
                                icj03 = g_icj[l_ac].icj03,
                                icj09 = g_icj[l_ac].icj09,
                                icj10 = g_icj[l_ac].icj10,
                                icj11 = g_icj[l_ac].icj11,
                                icj12 = g_icj[l_ac].icj12,
                                icj13 = g_icj[l_ac].icj13,
                                icj14 = g_icj[l_ac].icj14,
                                icj15 = g_icj[l_ac].icj15,
                                icj16 = g_icj[l_ac].icj16,
                                icj18 = g_icj[l_ac].icj18,
                                icj05 = g_icj[l_ac].icj05,
                                icj06 = g_icj[l_ac].icj06,
                                icj07 = g_icj[l_ac].icj07,
                                icj17 = g_icj[l_ac].icj17,
                                icjmodu = g_user,
                                icjdate = g_today 
                                 WHERE icj01 = g_icj01
                                   AND icj02 = g_icj_t.icj02
                                   AND icj03 = g_icj_t.icj03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","icj_file",g_icj[l_ac].icj02,g_icj[l_ac].icj03,SQLCA.sqlcode,"","",1)  #No.FUN-660138
               LET g_icj[l_ac].* = g_icj_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF          
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac#FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_icj[l_ac].* = g_icj_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_icj.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE i009_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac#FUN-D40030 add
         CLOSE i009_bcl
         COMMIT WORK
 
       ON ACTION CONTROLP                                                       
          CASE                                                                  
             WHEN INFIELD(icj02)                                                
#FUN-AA0059 --Begin--
             #   CALL cl_init_qry_var()                                          
             #   LET g_qryparam.form  ="q_ima"     
             #   LET g_qryparam.default1 = g_icj[l_ac].icj02                              
             #   CALL cl_create_qry() RETURNING g_icj[l_ac].icj02               
                CALL q_sel_ima(FALSE, "q_ima", "",g_icj[l_ac].icj02, "", "", "", "" ,"",'' )  RETURNING g_icj[l_ac].icj02
#FUN-AA0059 --End--
                DISPLAY BY NAME g_icj[l_ac].icj02                             
                NEXT FIELD icj02                                                
             WHEN INFIELD(icj03)                                                
                CALL cl_init_qry_var()                                          
                LET g_qryparam.form  ="q_pmc2"                                  
                LET g_qryparam.default1 = g_icj[l_ac].icj03                             
                CALL cl_create_qry() RETURNING g_icj[l_ac].icj03             
                DISPLAY BY NAME g_icj[l_ac].icj03                            
                NEXT FIELD icj03      
             WHEN INFIELD(icj16)                                                
                CALL cl_init_qry_var()                                          
                LET g_qryparam.form  ="q_icd"                                   
                LET g_qryparam.default1 = g_icj[l_ac].icj16                             
                CALL cl_create_qry() RETURNING g_icj[l_ac].icj16             
                DISPLAY BY NAME g_icj[l_ac].icj03                            
                NEXT FIELD icj16    
            OTHERWISE EXIT CASE                                             
          END CASE             
 
      ON ACTION CONTROLO                      
         IF INFIELD(icj01) AND l_ac > 1 THEN
            LET g_icj[l_ac].* = g_icj[l_ac-1].*
            LET g_icj[l_ac].icj02=null
            NEXT FIELD icj02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
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
 
   CLOSE i009_bcl
   COMMIT WORK
 
END FUNCTION            
 
FUNCTION i009_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
   LET g_sql = "SELECT icj02,'',icj03,'',icj09,icj10,icj11,icj12,",
               "icj13,icj14,icj15,icj16,'',icj18,icj05,icj06,icj07,icj17 ",
               " FROM icj_file ",
               " WHERE icj01 = '",g_icj01,"'",
               "  AND ",p_wc CLIPPED ,
               " ORDER BY icj02"
   PREPARE i009_prepare2 FROM g_sql       #預備一下 
   DECLARE icj_cs CURSOR FOR i009_prepare2
 
   CALL g_icj.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH icj_cs INTO g_icj[g_cnt].*     #單身ARRAY填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima02 INTO g_icj[g_cnt].icj02_desc 
        FROM ima_file WHERE ima01 = g_icj[g_cnt].icj02
      SELECT pmc03 INTO g_icj[g_cnt].pmc03 
        FROM pmc_file WHERE pmc01 = g_icj[g_cnt].icj03 AND pmcacti = 'Y' 
      SELECT icd03 INTO g_icj[g_cnt].icd03
        FROM icd_file WHERE icd01 = g_icj[g_cnt].icj16 AND icdacti = 'Y'
                        AND icd02 = 'S' 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_icj.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cnt2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i009_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_icj TO s_icj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      #ON ACTION modify
      #   LET g_action_choice="modify"
      #   EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      #ON ACTION invalid
      #   LET g_action_choice="invalid"
      #   EXIT DISPLAY
 
      ON ACTION first
         CALL i009_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         #IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         #END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i009_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         #IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         #END IF
	 ACCEPT DISPLAY              
 
      ON ACTION jump
         CALL i009_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         #IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         #END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL i009_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         #IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         #END IF
	 ACCEPT DISPLAY               
 
      ON ACTION last
         CALL i009_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         #IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         #END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION output
         LET g_action_choice="output"
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                  
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION   
 
#FUNCTION i009_u()
#DEFINE p_cmd   LIKE	 type_file.chr1
 
#   IF s_shut(0) THEN
#      RETURN
#   END IF
 
#   #IF g_chkey = 'N' THEN
#   #   CALL cl_err(g_icj01,'aoo-085',0)
#   #   RETURN
#   #END IF
 
#   IF cl_null(g_icj01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
 
#   CALL i009_show()
#   IF g_icjacti = 'N' THEN
#       CALL cl_err('',9027,1) 
#       RETURN
#   END IF
#   MESSAGE ""
#   CALL cl_opmsg('u')
 
#   BEGIN WORK
 
#   LET g_icjmodu=g_user                 
#   LET g_icjdate = g_today             
#   CALL i009_show()         
#   OPEN i009_bcs USING g_icj01
#   WHILE TRUE
#      LET g_icj01_t = g_icj01
#      LET g_icjdate = g_today
#      LET g_icjmodu = g_user  
#      LET p_cmd = 'u'
#      CALL i009_i("u") 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 
#         CALL i009_show()
#         CALL cl_err('',9001,0)
#         EXIT WHILE
#      END IF
#      #IF g_icj01 != g_icj01_t THEN
#         UPDATE icj_file SET icj01 = g_icj01,
#                             icjuser = g_icjuser,
#                             icjgrup = g_icjgrup,
#                             icjmodu = g_icjmodu,
#                             icjdate = g_icjdate,
#                             icjacti = g_icjacti 
#             WHERE icj01 = g_icj01_t
#          IF SQLCA.sqlcode THEN
#             CALL cl_err3("upd","icj_file",g_icj01,'',SQLCA.sqlcode,"","",1)
#             CONTINUE WHILE
#          END IF
#      #END IF
#      EXIT WHILE
#   END WHILE
#   CLOSE i009_bcs 
#   COMMIT WORK
#END FUNCTION                             
#
 
FUNCTION i009_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_icj01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   IF cl_delh(0,0) THEN             #確認一下      
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "icj01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_icj01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()          #No.FUN-9B0098 10/02/24
      DELETE FROM icj_file WHERE icj01 = g_icj01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","icj_file",g_icj01,'',SQLCA.sqlcode,"","BODY DELETE",0) 
      ELSE
         COMMIT WORK
         CLEAR FORM
         CALL g_icj.clear()
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i009_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i009_bcs
             CLOSE i009_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i009_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i009_bcs
             CLOSE i009_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i009_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET  g_abso= g_row_count
            CALL i009_fetch('L')
         ELSE
            LET g_abso = g_curs_index
            LET mi_no_ask = TRUE
            CALL i009_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i009_copy()
DEFINE
   l_n             LIKE type_file.num5,   
   l_cnt           LIKE type_file.num10,  
   l_oldno1        LIKE icj_file.icj01,
   l_ima02         LIKE ima_file.ima02, 
   l_imaacti       LIKE ima_file.imaacti,
   l_newno         LIKE icj_file.icj01
  
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_icj01) THEN
      CALL cl_err('',-400,1)
      RETURN  
   END IF
 
   CALL cl_set_head_visible("","YES")     
 
   INPUT l_newno FROM icj01
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         
      AFTER FIELD icj01 
         IF NOT cl_null(l_newno) THEN
           #FUN-AA0059 ----------------add start--------------
            IF NOT s_chk_item_no(l_newno,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD icj01 
            END IF 
            #FUN-AA0059 ----------------add end----------------  
            SELECT COUNT(*) INTO l_n FROM icj_file
             WHERE icj01 = l_newno
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD icj01
            END IF
         END IF
         SELECT ima02 INTO l_ima02 FROM ima_file
          WHERE ima01 = l_newno
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","icj_file",g_icj01,'',SQLCA.sqlcode,"","",1)  
            NEXT FIELD icj01
         END IF
         IF l_imaacti != 'Y' THEN
            CALL cl_err(l_newno,'9028',0)
            NEXT FIELD icj01
         END IF
         DISPLAY l_ima02 TO FORMONLY.icj01_desc
 
     ON ACTION CONTROLP                                                     
        CASE                                                                
          WHEN INFIELD(icj01)                                               
#FUN-AA0059 --Begin--
         #   CALL cl_init_qry_var()                                          
         #   LET g_qryparam.form  ="q_ima"                                   
         #   LET g_qryparam.default1 = g_icj01                               
         #   CALL cl_create_qry() RETURNING l_newno                          
            CALL q_sel_ima(FALSE, "q_ima", "", g_icj01, "", "", "", "" ,"",'' )  RETURNING l_newno
#FUN-AA0059 --End--
            DISPLAY l_newno TO icj01                                        
            NEXT FIELD icj01                                                
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
      DISPLAY g_icj01 TO icj01
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM icj_file             
    WHERE icj01 = g_icj01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_icj01,'',SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET icj01  = l_newno,
                icjuser= g_user,
                icjgrup= g_grup,
                icjdate= g_today,
                icjacti= 'Y'    
   
   INSERT INTO icj_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","icj_file",l_newno,'',SQLCA.sqlcode,"",g_msg,1)  
      RETURN
   ELSE 
      MESSAGE 'COPY O.K'
      LET l_oldno1 = g_icj01
      LET g_icj01=l_newno
      CALL i009_b()
      #LET g_icj01 = l_oldno1  #FUN-C30027
      #CALL i009_show()        #FUN-C30027
   END IF
END FUNCTION
 
FUNCTION i009_out()
    DEFINE
        sr              RECORD LIKE ahi_file.*,
        l_i             LIKE type_file.num5,    
        l_name          LIKE type_file.chr20,  
        l_za05          LIKE za_file.za05       
    IF cl_null(g_wc)AND NOT cl_null(g_icj01) THEN
       #IF g_icj01>0 THEN
          LET g_wc=" icj01='",g_icj01,"'"
       #END IF
    END IF
 
    IF g_wc IS NULL THEN  
       CALL cl_err('','9057',0) RETURN 
    END IF  
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog
   #TQC-8C0052.............begin
   #LET g_sql="SELECT icj01,a.ima02 icj01_desc,icj02,b.ima02 icj02_desc,",
   #          " icj03,pmc03,icj09,icj10,icj11,",          #  組合出SQL指令   
   #          " icj12,icj13,icj14,icj15,icj16,icd03,icj18,icj05,icj06,icj07,",
   #          " icj17 FROM icj_file,ima_file a,ima_file b,
   #          " icd_file,pmc_file",
   #          " WHERE icj01=a.ima01 AND icj03=pmc01  ",
   #          " AND icj02=b.ima01 ",     
   #         #" AND icd02='S' ", #TQC-8C0052
   #          " AND ",g_wc CLIPPED,
   #          " ORDER BY icj01 "
    LET g_sql="SELECT icj01,a.ima02 icj01_desc,icj02,b.ima02 icj02_desc,",
              " icj03,pmc03,icj09,icj10,icj11,",          #  組合出SQL指令   
              " icj12,icj13,icj14,icj15,icj16,icd03,icj18,icj05,icj06,icj07,",
              " icj17 FROM icj_file ",
#             " LEFT OUTER JOIN icd_file ON ((icj_file.icj16=icd_file.icd01(+)) AND icd02='S') ",
              " LEFT OUTER JOIN icd_file ON (icj_file.icj16=icd_file.icd01 AND icd02='S') ",    #No.FUN-9B0027
              " LEFT OUTER JOIN pmc_file ON ((icj_file.icj03=pmc_file.pmc01)) ",
              " LEFT OUTER JOIN ima_file a ON ((icj_file.icj01=a.ima01)) ",
              " LEFT OUTER JOIN ima_file b ON ((icj_file.icj02=b.ima01)) ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY icj01 "
   #TQC-8C0052.............end
    IF g_zz05 = 'Y' THEN                                                         
       CALL cl_wcchp(g_wc,'icj01,icj02,icj03,icj09,icj10,icj11,icj12,icj13,       
                         icj14,icj15,icj16,icj18,icj05,icj06,icj07,icj17 ')                                               
       RETURNING g_str
    END IF 
    CALL cl_prt_cs1('aici009','aici009',g_sql,g_str) 
END FUNCTION
 
FUNCTION i009_icj01(p_cmd)    #主料件編號
DEFINE
   p_cmd           LIKE type_file.chr1,
   l_desc          LIKE type_file.chr4,
   l_ima02         LIKE ima_file.ima02,
   l_imaacti       LIKE ima_file.imaacti          
 
   LET g_errno = ' '
   SELECT ima02,imaacti INTO l_ima02,l_imaacti FROM ima_file
    WHERE ima01 = g_icj01
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3006'
                                 LET l_ima02 = NULL
                                 LET l_imaacti = NULL
        WHEN l_imaacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ima02  TO FORMONLY.icj01_desc
   END IF
 
END FUNCTION
 
FUNCTION i009_icj02(p_cmd)    #產品型號                                       
DEFINE                                                                          
   p_cmd           LIKE type_file.chr1,                                         
   l_desc          LIKE type_file.chr4,                                         
   l_ima02         LIKE ima_file.ima02,                                         
   l_imaacti       LIKE ima_file.imaacti                                        
                                                                                
   LET g_errno = ' '                                                            
   SELECT ima02,imaacti INTO l_ima02,l_imaacti FROM ima_file                    
    WHERE ima01 = g_icj[l_ac].icj02                                                       
                                                                                
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3006'                        
                                 LET l_ima02 = NULL                             
                                 LET l_imaacti = NULL                           
        WHEN l_imaacti = 'N' LET g_errno = '9028'                               
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING '-------'        
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                      
      LET g_icj[l_ac].icj02_desc = l_ima02
      DISPLAY BY NAME g_icj[l_ac].icj02_desc                                   
   END IF                                                                       
                                                                                
END FUNCTION 
 
FUNCTION i009_icj03(p_cmd)    #ASS VENDOR                                        
DEFINE                                                                          
   p_cmd           LIKE type_file.chr1,                                         
   l_pmcacti       LIKE pmc_file.pmcacti                                        
                                                                                
   LET g_errno = ' '                                                            
   SELECT pmc03,pmcacti INTO g_icj[l_ac].pmc03,l_pmcacti            
     FROM pmc_file                                                  
    WHERE pmc01 = g_icj[l_ac].icj03
                                                                                 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3006'                        
                                 LET g_icj[l_ac].pmc03 = NULL                             
                                 LET l_pmcacti = NULL                           
        WHEN l_pmcacti = 'N' LET g_errno = '9028'                               
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING '-------'        
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                      
      DISPLAY BY NAME g_icj[l_ac].pmc03                                    
   END IF                  
END FUNCTION       
 
#FUNCTION i009_x()                                                               
#DEFINE g_chr    LIKE icj_file.icjacti                                           
 
#   IF g_icj01 IS NULL THEN                                                     
#      CALL cl_err('',-400,0)                                                  
#      RETURN                                                                  
#   END IF                                                                      
#                                                                               
#   BEGIN WORK                                                                  
#                                                                               
#   CALL i009_show()                                                            
#                                                                               
#   IF cl_exp(0,0,g_icjacti) THEN                                               
#      LET g_chr=g_icjacti                                                     
#      IF g_icjacti='Y' THEN                                                   
#          LET g_icjacti='N'                                                   
#      ELSE                                                                    
#          LET g_icjacti='Y'                                                   
#      END IF                                                                  
#      UPDATE icj_file                                                         
#         SET icjacti = g_icjacti,      
#             icjmodu = g_user,
#             icjdate = g_today                                           
#         WHERE icj01=g_icj01                                                 
#      IF SQLCA.SQLERRD[3]=0 THEN                                              
#         CALL cl_err(g_icj01,SQLCA.sqlcode,0) 
#         LET g_icjacti=g_chr                                                 
#      END IF                                                                  
#      DISPLAY  g_icjacti TO icjacti                                           
#   END IF                                                                      
#   COMMIT WORK                                                                 
#END FUNCTION    
 
FUNCTION i009_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("icj01",TRUE)
     END IF
END FUNCTION
 
FUNCTION i009_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       call cl_set_comp_entry("icj01",FALSE)
    END IF
END FUNCTION 
#No.FUN-7B0073---End           
# FUN-B80083   
