# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aici011.4gl
# Descriptions...: ICD料件ASS維護作業
# Date & Author..: No.FUN-7B0073 07/11/14 By arman
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改 
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_icj01       LIKE icj_file.icj01,
    g_icj01_t     LIKE icj_file.icj01,
    g_icj02       LIKE icj_file.icj02,
    g_icj02_t     LIKE icj_file.icj02,
    g_icj03       LIKE icj_file.icj03,
    g_icj03_t     LIKE icj_file.icj03,
    g_icj         DYNAMIC ARRAY OF RECORD
       icj02      LIKE icj_file.icj02,
       icj02_desc LIKE type_file.chr1000,
       icj03      LIKE icj_file.icj03,
       pmc03      LIKE pmc_file.pmc03,
       icj04      LIKE icj_file.icj04,
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
       icj04      LIKE icj_file.icj04,
       icj05      LIKE icj_file.icj05,
       icj06      LIKE icj_file.icj06,
       icj07      LIKE icj_file.icj07,
       icj17      LIKE icj_file.icj17                                          
                  END RECORD,           
      
    a             LIKE type_file.chr1,     
    g_wc,g_sql,g_wc2  STRING,                                                   
    g_show            LIKE type_file.chr1,         
    g_rec_b           LIKE type_file.num5,   #單身筆數 
    g_flag            LIKE type_file.chr1,               
    g_ss              LIKE type_file.chr1,               
    l_ac              LIKE type_file.num5,   #目前處理
    g_argv1           LIKE ick_file.ick01,                                      
    g_argv2           LIKE ahi_file.ahi02                                       
DEFINE p_row,p_col    LIKE type_file.num5    
#主程式開始                                                                     
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL                       
DEFINE   g_sql_tmp    STRING   #No.TQC-720019                                   
DEFINE   g_before_input_done   LIKE type_file.num5     
DEFINE   g_cnt                 LIKE type_file.num10      
DEFINE   g_msg         LIKE ze_file.ze03            
DEFINE   g_row_count   LIKE type_file.num10              
DEFINE   g_curs_index  LIKE type_file.num10             
DEFINE   l_cmd         LIKE type_file.chr1000   
DEFINE   l_abso        LIKE type_file.num10 
DEFINE   g_no_ask      LIKE type_file.num5 
DEFINE   g_str         STRING
MAIN                                                                            
#       l_time   LIKE type_file.chr8                           
                                                                                
   OPTIONS                                #改變一些系統預設值                   
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理               
                                                                                
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
   LET g_argv2 =ARG_VAL(2)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i140_w AT p_row,p_col
     WITH FORM "aic/42f/aici011"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) THEN                                                                            
      CALL i011_q()                                                                                                                 
   END IF                
      CALL i011_menu()
 
   CLOSE WINDOW i011_w                 #結束畫面 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料                                                                   
FUNCTION i011_cs()                                                              
DEFINE l_sql STRING                                                             
                                                           
       CLEAR FORM                            #清除畫面                                                                               
       CALL cl_set_head_visible("","YES")    #No.FUN-6B0029                     
                                                                                
   INITIALIZE g_icj01 TO NULL    #No.FUN-750051     
   IF NOT cl_null(g_argv1) THEN                                                                                                     
      LET g_wc = " icj01 = '",g_argv1,"'"           
   ELSE                  
       CONSTRUCT g_wc ON icj01,icj02,icj03,icj04,icj05,icj06,icj07,icj17
                                               
          FROM icj01,s_icj[1].icj02,s_icj[1].icj03,s_icj[1].icj04,
               s_icj[1].icj05,s_icj[1].icj06,s_icj[1].icj07,s_icj[1].icj17
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
 
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select()
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
       
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('icjuser', 'icjgrup') #FUN-980030
 
   END IF             
       IF INT_FLAG THEN
          RETURN
       END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT UNIQUE icj01 FROM icj_file ",
               " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY icj01"       
    PREPARE i011_prepare FROM g_sql      #預備一下                              
    DECLARE i011_bcs                     #宣告成可卷動的                        
        SCROLL CURSOR WITH HOLD FOR i011_prepare                                
                                                                                
    DROP TABLE i011_cnttmp                                                                     
#    LET g_sql_tmp=l_sql," INTO TEMP i011_cnttmp"                
                                                                                                   
#    PREPARE i011_cnttmp_pre FROM g_sql_tmp                      
#    EXECUTE i011_cnttmp_pre                                                     
                                                                                
    LET g_sql="SELECT COUNT(UNIQUE icj01) FROM icj_file WHERE ",g_wc CLIPPED                              
                                                                                
    PREPARE i011_precount FROM g_sql                                            
    DECLARE i011_count CURSOR FOR i011_precount                                 
                                                                                
    IF NOT cl_null(g_argv1) THEN                                                
       LET g_icj01=g_argv1                                                      
    END IF  
                                                                    
    #IF NOT cl_null(g_argv2) THEN
    #   LET g_ahi02=g_argv2
    #END IF
 
    CALL i011_show()
END FUNCTION     
 
FUNCTION i011_menu()
DEFINE p_cmd   LIKE type_file.chr1
   WHILE TRUE
      CALL i011_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_argv1) THEN
                  CALL i011_a(p_cmd)
               END IF
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i011_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i011_u()
            END IF  
         WHEN "delete" 
              IF cl_chk_act_auth() THEN
                 CALL i011_r()
              END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i011_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i011_b(p_cmd)
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
               CALL i011_out()
            END IF    
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_icj),'','')
            END IF
         #No.FUN-6B0040-------add--------str----
         WHEN "related_document"           #  閩ピ⑦
          IF cl_chk_act_auth() THEN
             IF g_icj01 IS NOT NULL THEN
                LET g_doc.column1 = "icj01"
 
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0040-------add--------end----
      END CASE
   END WHILE
END FUNCTION     
FUNCTION i011_bp(p_cd)      
DEFINE p_cd         LIKE type_file.chr1

  #FUN-D40030--add--str
   IF p_cd <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
  #FUN-D40030--add--end
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
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
 
      ON ACTION first
         CALL i011_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL i011_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL i011_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL i011_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION last
         CALL i011_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
#     ON ACTION invalid
#        LET g_action_choice="invalid"
#        EXIT DISPLAY
 
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                  
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i011_a(p_cmd)  
DEFINE  p_cmd    LIKE type_file.chr1                                                            
   MESSAGE ""                                                                   
   CLEAR FORM                                                                   
   CALL g_icj.clear()   
   LET g_icj01 = 	NULL                                                        
   LET g_icj01_t  = NULL                                                        
   LET g_icj02_t  = NULL                                                        
   LET g_icj03_t  = NULL 
   CALL cl_opmsg('a')                                                           
                                                                                
   WHILE TRUE                                                                   
      CALL i011_i("a")                   #輸入單頭                              
                                                                                
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
         CALL i011_b_fill('1=1')            #單身                               
      END IF                                                                    
                                                                                
      CALL i011_b(p_cmd)                      #輸入單身                              
                                                                                
      LET g_icj01_t = g_icj01                                                   
      LET g_icj02_t = g_icj02                                                   
      LET g_icj03_t = g_icj03                                                   
      EXIT WHILE                                                                
   END WHILE                                                                    
                                                                                
END FUNCTION                 
 
FUNCTION i011_i(p_cmd)                                                          
DEFINE                                                                          
    p_cmd           LIKE type_file.chr1,   
    l_cnt           LIKE type_file.num10,       
    l_ima02         LIKE ima_file.ima02                                                                           
    LET g_ss='Y'                                                                
                                                                                
                                                
    CALL cl_set_head_visible("","YES")                     
    INPUT g_icj01  WITHOUT DEFAULTS                                      
        FROM icj01
       BEFORE INPUT 
       CALL i011_set_entry('a')
       IF p_cmd = 'u' THEN
              CALL	i011_set_no_entry('u')
       END IF                                                       
       AFTER FIELD icj01
         IF NOT cl_null(g_icj01) THEN
         #FUN-AA0059 ----------------add start--------------------
          IF NOT s_chk_item_no(g_icj01,'') THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD icj01
          END IF
         #FUN-AA0059 ----------------add start------------------  
          SELECT COUNT(*)  INTO l_cnt FROM ima_file WHERE ima01 = g_icj01
           IF l_cnt <=0 THEN
                CALL cl_err('','apj-004',0)
                NEXT FIELD icj01
           END IF 
           
             CALL i011_icj01()                          
         END IF
         
         ON ACTION CONTROLP                                                       
            CASE                                                                  
              WHEN INFIELD(icj01)                                                
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()                                          
              #  LET g_qryparam.form  ="q_ima"                                   
              #  LET g_qryparam.default1 = g_icj01                     
              #  CALL cl_create_qry() RETURNING g_icj01               
                CALL q_sel_ima(FALSE, "q_ima", "", g_icj01, "", "", "", "" ,"",'' )  RETURNING g_icj01
#FUN-AA0059 --End--
                DISPLAY  g_icj01 TO icj01                               
                NEXT FIELD icj01
              OTHERWISE EXIT CASE   
              END CASE                                                                                                                                  
         ON ACTION CONTROLG                                                     
           CALL cl_cmdask()                                                     
                                                                                
         ON IDLE g_idle_seconds                                                 
           CALL cl_on_idle()                                                    
           CONTINUE INPUT                                                       
                                                                                
         ON ACTION about         #MOD-4C0121                                    
            CALL cl_about()      #MOD-4C0121                                                            
         ON ACTION help          #MOD-4C0121                                    
            CALL cl_show_help()  #MOD-4C0121                                    
                                                                                
       ON ACTION CONTROLF                  #欄位說明                            
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)                          
                                                                                
    END INPUT          
END FUNCTION
 
FUNCTION i011_q()                                                               
   LET g_icj01 = ''                                                             
   LET g_icj02 = ''                                                             
   LET g_icj03 = ''                                                             
   LET g_row_count = 0                                                          
   LET g_curs_index = 0                                                         
   CALL cl_navigator_setting( g_curs_index, g_row_count )                       
   INITIALIZE g_icj01 TO NULL       #No.FUN-6B0040                      
   MESSAGE ""                                                                   
   CALL cl_opmsg('q')                                                           
   CLEAR FORM                                                                   
   CALL g_icj.clear()                                                           
   DISPLAY '' TO FORMONLY.cnt                                                   
                                                                                
   CALL i011_cs()                      #取得查詢條件                            
                                                                                
   IF INT_FLAG THEN                    #使用者不玩了                            
      LET INT_FLAG = 0         
      INITIALIZE g_icj01 TO NULL                                        
      RETURN                                                                    
   END IF                                                                       
                                                                                
   OPEN i011_bcs                       #從DB產生合乎條件TEMP(0-30秒)            
   IF SQLCA.sqlcode THEN               #有問題                                  
      CALL cl_err('',SQLCA.sqlcode,0)                                           
      INITIALIZE g_icj01 TO NULL                                        
   ELSE                                                                         
      OPEN i011_count                                                           
      FETCH i011_count INTO g_row_count                                         
      DISPLAY g_row_count TO FORMONLY.cnt                                       
      CALL i011_fetch('F')            #讀出TEMP第一筆并顯示                     
   END IF                                                                       
                                                                                
END FUNCTION     
 
#處理資料的讀取                                                                 
FUNCTION i011_fetch(p_flag)                                                     
DEFINE                                                                          
   p_flag          LIKE type_file.chr1   
                                                                                
   MESSAGE ""                                                                   
   CASE p_flag                                                                  
       WHEN 'N' FETCH NEXT     i011_bcs INTO g_icj01                    
       WHEN 'P' FETCH PREVIOUS i011_bcs INTO g_icj01                    
       WHEN 'F' FETCH FIRST    i011_bcs INTO g_icj01                    
       WHEN 'L' FETCH LAST     i011_bcs INTO g_icj01                    
       WHEN '/'                                                                 
          IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg                      
            LET INT_FLAG = 0  ######add for prompt bug                          
            PROMPT g_msg CLIPPED,': ' FOR l_abso  
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
              
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
              
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
              
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
            FETCH ABSOLUTE l_abso i011_bcs 
                  INTO g_icj01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                     #有麻煩
      CALL cl_err(g_icj01,SQLCA.sqlcode,0)
      INITIALIZE g_icj01 TO NULL  #TQC-6B0105
      INITIALIZE g_icj02 TO NULL  #TQC-6B0105
      INITIALIZE g_icj03 TO NULL  #TQC-6B0105
   ELSE
      CALL i011_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上                                                             
FUNCTION i011_show()                                                            
                                                                                
   DISPLAY g_icj01 TO icj01 
   CALL i011_icj01()                                                                            
   CALL i011_b_fill(g_wc)                      #單身                            
                                                                                
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf                 
END FUNCTION
FUNCTION i011_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          
            l_icj   RECORD LIKE icj_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_icj01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "icj01"      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM icj_file
       WHERE icj01 = g_icj01 
#         AND icj02 = g_icj02 
#         AND icj03 = g_icj03  
      IF SQLCA.sqlcode THEN  
         CALL cl_err3("del","icj_file",g_icj01,'',SQLCA.sqlcode,"","BODY DELETE",0)   
      ELSE
         COMMIT WORK
         CLEAR FORM
         CALL g_icj.clear()
         OPEN i011_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i011_bcs
             CLOSE i011_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i011_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i011_bcs
             CLOSE i011_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i011_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET l_abso = g_row_count
            CALL i011_fetch('L')
         ELSE
            LET l_abso = g_curs_index           
            LET g_no_ask = TRUE
            CALL i011_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION i011_b(p_cmd)                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT 
            l_n             LIKE type_file.num5,               # 檢查重複用        
            l_gau01         LIKE type_file.num5,               # 檢查重複用        
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        
            p_cmd           LIKE type_file.chr1,               # 處理狀態          
            l_allow_insert  LIKE type_file.num5,               
            l_n1             LIKE type_file.num5,   
            l_allow_delete  LIKE type_file.num5                
   DEFINE   l_count         LIKE type_file.num5                
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_icj01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   CALL cl_opmsg('b')
 
 
   LET g_forupd_sql= "SELECT icj02,'',icj03,'',icj04,icj05,icj06,icj07,icj17",
                     "  FROM icj_file",
                     "  WHERE icj01 = ? AND icj02 = ? AND icj03 = ? ",   
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i011_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_icj WITHOUT DEFAULTS FROM s_icj.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
         
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_icj_t.* = g_icj[l_ac].*    #BACKUP
            OPEN i011_bcl USING g_icj01,g_icj[l_ac].icj02,g_icj[l_ac].icj03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i011_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i011_bcl INTO g_icj[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i011_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT  ima02  INTO  g_icj[l_ac].icj02_desc  FROM ima_file WHERE ima01 = g_icj[l_ac].icj02
               SELECT  pmc03  INTO  g_icj[l_ac].pmc03 FROM pmc_file WHERE pmcacti = 'Y' AND pmc01 = g_icj[l_ac].icj03
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_icj[l_ac].* TO NULL       
         LET g_icj_t.* = g_icj[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     
         NEXT FIELD icj02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO icj_file(icj01,icj02,icj03,icj04,icj05,icj06,icj07,icj17,icjuser,icjgrup,icjmodu,icjacti,icjdate,icjoriu,icjorig) 
                      VALUES (g_icj01,g_icj[l_ac].icj02,g_icj[l_ac].icj03,
                              g_icj[l_ac].icj04,g_icj[l_ac].icj05,
                              g_icj[l_ac].icj06,g_icj[l_ac].icj07,
                              g_icj[l_ac].icj17,g_user,g_grup,'','Y',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_ice01,SQLCA.sqlcode,0)  
            CALL cl_err3("ins","icj_file",g_icj01,g_icj[l_ac].icj04,SQLCA.sqlcode,"","",0)   
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
      AFTER FIELD icj02
         IF NOT cl_null(g_icj[l_ac].icj02) THEN
          #FUN-AA0059 ---------------------add end------------------
           IF NOT s_chk_item_no(g_icj[l_ac].icj02,'') THEN 
              CALL  cl_err('',g_errno,1)
              NEXT FIELD icj02
           END IF
          #FUN-AA0059 ---------------------add end-----------------
           SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01 = g_icj[l_ac].icj02
             IF l_n <= 0 THEN
                CALL cl_err('','apj-004',0)
                NEXT FIELD icj02 
                LET l_n = 0
             END IF 
            CALL i011_icj02()
          END IF
      AFTER FIELD icj03 
         IF NOT cl_null(g_icj[l_ac].icj03) THEN
           SELECT COUNT(*) INTO l_n FROM pmc_file WHERE pmc01 = g_icj[l_ac].icj03
             IF l_n <= 0 THEN
                CALL cl_err('','apj-004',0)
                NEXT FIELD  icj03
                LET l_n = 0 
             END IF
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
           CALL i011_pmc03()
         END IF 
         
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_icj_t.icj02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err(g_icj[l_ac].icj02,"aic-082",1)
            END IF
            DELETE FROM icj_file WHERE icj01 = g_icj01
                                   AND icj02 = g_icj_t.icj02
                                   AND icj03 = g_icj_t.icj03          
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","icj_file",g_icj01,g_icj_t.icj02,SQLCA.sqlcode,"","",0)   
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
            LET g_icj[l_ac].* = g_icj_t.*
            CLOSE i011_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("g_icj[l_ac].icj02","aic-083",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_icj[l_ac].icj02,-263,1)
            LET g_icj[l_ac].* = g_icj_t.*
         ELSE
            UPDATE icj_file
               SET icj02 = g_icj[l_ac].icj02,
                   icj03 = g_icj[l_ac].icj03,
                   icj04 = g_icj[l_ac].icj04,
                   icj05 = g_icj[l_ac].icj05,
                   icj06 = g_icj[l_ac].icj06,
                   icj07 = g_icj[l_ac].icj07,
                   icj17 = g_icj[l_ac].icj17,
                   icjmodu = g_user,
                   icjdate = g_today
             WHERE icj01 = g_icj01
               AND icj03 = g_icj_t.icj03
               AND icj02 = g_icj_t.icj02
            IF SQLCA.sqlcode THEN  
               CALL cl_err3("upd","icj_file",g_icj01,g_icj_t.icj02,SQLCA.sqlcode,"","",0)   
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
            IF p_cmd='u' THEN
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
            CLOSE i011_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac#FUN-D40030  add
         CLOSE i011_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(ice04) AND l_ac > 1 THEN
            LET g_icj[l_ac].* = g_icj[l_ac-1].*
            NEXT FIELD ice04
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE                                                                
             WHEN INFIELD(icj02)                                                
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()                                          
              #  LET g_qryparam.form  ="q_ima"     
              #  LET g_qryparam.default1 = g_icj[l_ac].icj02                              
              #  CALL cl_create_qry() RETURNING g_icj[l_ac].icj02               
                CALL q_sel_ima(FALSE, "q_ima", "", g_icj[l_ac].icj02, "", "", "", "" ,"",'' )  RETURNING g_icj[l_ac].icj02
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
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
 
   END INPUT
 
   CLOSE i011_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i011_b_fill(p_wc)               
   DEFINE
        # p_wc         LIKE type_file.chr1000 
          p_wc         STRING     #NO.FUN-910082
   DEFINE p_ac         LIKE type_file.num5    
 
    LET g_sql = "SELECT icj02,'',icj03,'',icj04,icj05,icj06,icj07,icj17 ",
                 " FROM icj_file ",
                " WHERE icj01 = '",g_icj01 CLIPPED,"' ",
                  " AND ",p_wc CLIPPED
 
 
    PREPARE i004_prepare2 FROM g_sql           #預備一下
    DECLARE icj_curs CURSOR FOR i004_prepare2
 
    CALL g_icj.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH icj_curs INTO g_icj[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT  ima02  INTO  g_icj[g_cnt].icj02_desc  FROM ima_file WHERE ima01 = g_icj[g_cnt].icj02
       SELECT  pmc03  INTO  g_icj[g_cnt].pmc03 FROM pmc_file WHERE pmcacti = 'Y' AND pmc01 = g_icj[g_cnt].icj03 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_icj.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i011_copy()
DEFINE  
   p_cmd           LIKE type_file.chr1,         
   l_n             LIKE type_file.num5, 
   l_cnt           LIKE type_file.num10,
   l_oldno1        LIKE icj_file.icj01,
   l_ima02         LIKE ima_file.ima02, 
   l_imaacti       LIKE ima_file.imaacti,
   l_newno         LIKE icj_file.icj01
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_icj01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   
   INPUT l_newno WITHOUT DEFAULTS FROM icj01
 
      AFTER INPUT
 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
      AFTER FIELD icj01 
         IF NOT cl_null(l_newno) THEN
           #FUN-AA0059 ---------------add start----------------
            IF NOT s_chk_item_no(l_newno,'') THEN 
               CALL cl_err('',g_errno,1)
               NEXT FIELD icj01
            END IF
           #FUN-AA0059 -------------add end-------------------
            #LET  l_n = 0 
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
            CALL cl_err3("sel","icj_file",g_icj01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660138
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
          #  CALL cl_init_qry_var()                                          
          #  LET g_qryparam.form  ="q_ima"                                   
          #  LET g_qryparam.default1 = g_icj01                               
          #  CALL cl_create_qry() RETURNING l_newno                          
            CALL q_sel_ima(FALSE, "q_ima", "",g_icj01, "", "", "", "" ,"",'' )  RETURNING l_newno 
#FUN-AA0059 --End--
            DISPLAY l_newno TO icj01                                        
            NEXT FIELD icj01                                                
            OTHERWISE EXIT CASE                                               
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
      DISPLAY g_icj01 TO icj01 
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM icj_file 
     WHERE icj01=g_icj01
   INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_icj01,'',SQLCA.sqlcode,"","",0)   
      RETURN
   END IF
 
   UPDATE x
      SET icj01 = l_newno                     # 資料鍵值
                  
   INSERT INTO icj_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      #CALL cl_err('icj:',SQLCA.SQLCODE,0)  
      CALL cl_err3("ins","icj_file",l_newno,'',SQLCA.sqlcode,"","",0)   
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_oldno1 = g_icj01
 
   
   LET g_icj01 = l_newno
 
   
   CALL i011_b(p_cmd)
   #LET g_icj01 = l_oldno1 #FUN-C30027
 
  
   #CALL i011_show()       #FUN-C30027
END FUNCTION
 
FUNCTION i011_pmc03()
 
     SELECT  pmc03  INTO  g_icj[l_ac].pmc03 FROM pmc_file WHERE pmcacti = 'Y' AND pmc01 = g_icj[l_ac].icj03 
     CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3098'
                                  LET g_icj[l_ac].pmc03 = NULL
          OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE       
    DISPLAY BY NAME g_icj[l_ac].pmc03
 
END FUNCTION
 
FUNCTION i011_icj01()
DEFINE l_ima02 LIKE ima_file.ima02
     SELECT  ima02  INTO  l_ima02 FROM ima_file WHERE ima01 = g_icj01 
     CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3098'
                                  LET l_ima02 = NULL
          OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE    
    DISPLAY l_ima02 TO icj01_desc   
 
END FUNCTION
 
FUNCTION i011_icj02()
 
     SELECT  ima02  INTO  g_icj[l_ac].icj02_desc  FROM ima_file WHERE ima01 = g_icj[l_ac].icj02 
     CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3098'
                                  LET g_icj[l_ac].icj02_desc = NULL
          OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE    
    DISPLAY BY NAME g_icj[l_ac].icj02_desc   
END FUNCTION
 
 
FUNCTION i011_u()
DEFINE p_cmd   LIKE	 type_file.chr1
    IF g_icj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
  
    CALL i011_show()
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    CALL i011_show()                         
    OPEN i011_bcs USING g_icj01
    WHILE TRUE
        LET g_icj01_t = g_icj01
        LET p_cmd = 'u'
        CALL i011_i("u")                    
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL i011_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE icj_file SET icj01 = g_icj01  
            WHERE icj01 = g_icj01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","icj_file",g_icj01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i011_bcs
    COMMIT WORK
END FUNCTION 
FUNCTION i011_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("icj01",TRUE)
     END IF
END FUNCTION
 
FUNCTION i011_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       call cl_set_comp_entry("icj01",FALSE)
    END IF
END FUNCTION 
    
FUNCTION i011_out()
    DEFINE
        sr              RECORD LIKE ahi_file.*,
        l_i             LIKE type_file.num5,   
        l_name          LIKE type_file.chr20, 
        l_za05          LIKE za_file.za05    
   
    IF g_wc IS NULL THEN 
       IF g_icj01>0 THEN
          LET g_wc=" icj01=",g_icj01
       ELSE
          CALL cl_err('',-400,0)
          RETURN 
       END IF
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog
    LET g_sql="SELECT icj01,a.ima02 icj01_desc,icj02,b.ima02 icj02_desc,",
              " icj03,pmc03,icj04,icj05,icj06,",          #  組合出SQL指令   
              " icj07,icj17",
              " FROM icj_file,ima_file a,ima_file b,pmc_file",
              " WHERE icj01=a.ima01 AND icj03=pmc01  ",
              " AND icj02=b.ima01 ",     
              " AND ",g_wc CLIPPED,
              " ORDER BY icj01 "
    #PREPARE i140_p1 FROM g_sql                # RUNTIME  s畝
    #DECLARE i140_co                         # SCROLL CURSOR
    #     CURSOR FOR i140_p1
 
    #CALL cl_outnam('agli140') RETURNING l_name
    #START REPORT i140_rep TO l_name
 
    #FOREACH i140_co INTO sr.*
    #    IF SQLCA.sqlcode THEN
    #        CALL cl_err('foreach:',SQLCA.sqlcode,1)    
    #        EXIT FOREACH
    #        END IF
    #    OUTPUT TO REPORT i140_rep(sr.*)
    #END FOREACH
 
    #FINISH REPORT i140_rep
 
    #CLOSE i140_co
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                         
       CALL cl_wcchp(g_wc,'icj01,icj02,icj03,icj04,icj05,icj06,icj07,icj17 ')                                               
       RETURNING g_wc
    END IF 
    LET g_str = g_wc                                                                      
    CALL cl_prt_cs1('aici011','aici011',g_sql,g_str) 
END FUNCTION               
#No.FUN-7B0073
