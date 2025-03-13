# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: sanmi011.4gl
# Descriptions...: 網銀結構設定作業公用子程序
# Date & Author..: No.FUN-B30213 11/03/30 By lixia
# Modify.........: No.FUN-B50065 11/06/09 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_noa       RECORD LIKE noa_file.*,
        g_noa_t     RECORD LIKE noa_file.*, 
        g_noa04     LIKE noa_file.noa04,   
        g_nob       DYNAMIC ARRAY OF RECORD #程式變數
                    nob05       LIKE nob_file.nob05,           
                    nob06       LIKE nob_file.nob06,                     
                    nob07       LIKE nob_file.nob07,           
                    nob08       LIKE nob_file.nob08,           
                    nob09       LIKE nob_file.nob09,           
                    nob10       LIKE nob_file.nob10,           
                    nob11       LIKE nob_file.nob11, 
                    nob12       LIKE nob_file.nob12,
                    nob13       LIKE nob_file.nob13,
                    nob14       LIKE nob_file.nob14,
                    nob15       LIKE nob_file.nob15,
                    nob16       LIKE nob_file.nob16,
                    nob17       LIKE nob_file.nob17,
                    nob18       LIKE nob_file.nob18,
                    nob19       LIKE nob_file.nob19,
                    nob20       LIKE nob_file.nob20,
                    nob21       LIKE nob_file.nob21,
                    nob22       LIKE nob_file.nob22,
                    nob23       LIKE nob_file.nob23        
                    END RECORD,
        g_nob_t     RECORD                   #程式變數 (舊值)
                    nob05       LIKE nob_file.nob05,           
                    nob06       LIKE nob_file.nob06,                     
                    nob07       LIKE nob_file.nob07,           
                    nob08       LIKE nob_file.nob08,           
                    nob09       LIKE nob_file.nob09,           
                    nob10       LIKE nob_file.nob10,           
                    nob11       LIKE nob_file.nob11, 
                    nob12       LIKE nob_file.nob12,
                    nob13       LIKE nob_file.nob13,
                    nob14       LIKE nob_file.nob14,
                    nob15       LIKE nob_file.nob15,
                    nob16       LIKE nob_file.nob16,
                    nob17       LIKE nob_file.nob17,
                    nob18       LIKE nob_file.nob18,
                    nob19       LIKE nob_file.nob19,
                    nob20       LIKE nob_file.nob20,
                    nob21       LIKE nob_file.nob21,
                    nob22       LIKE nob_file.nob22,
                    nob23       LIKE nob_file.nob23                   
                    END RECORD,
       g_wc,g_wc2      STRING,
       g_sql           STRING,   
       g_rec_b         LIKE type_file.num5,     #單身筆數        
       l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT 
DEFINE g_forupd_sql    STRING                   #SELECT ... FOR UPDATE   SQL
DEFINE g_cnt           LIKE type_file.num10       
DEFINE g_msg           LIKE type_file.chr1000      
DEFINE g_i             LIKE type_file.num5   
DEFINE g_curs_index    LIKE type_file.num10 
DEFINE g_row_count     LIKE type_file.num10  
DEFINE g_jump          LIKE type_file.num10  
DEFINE g_no_ask        LIKE type_file.num5  

#p_argv1 : 1.網銀報文結構設定作業
#p_argv1 : 2.網銀傳輸規格設定作業
#p_argv1 : 3.網銀公共配置設定作業 
FUNCTION i011(p_argv1)
   DEFINE p_argv1    LIKE type_file.chr1     
   WHENEVER ERROR CALL cl_err_msg_log 
   IF cl_null(p_argv1) THEN RETURN END IF
   CALL cl_set_comp_required("nob06",TRUE)
   LET g_noa04 = p_argv1
   IF p_argv1 = '1' THEN      
      CALL cl_set_comp_visible("noa06,noa07,noa08,noa09,noa10,noa11,noa12,
                               nob06,nob07,nob08,nob10,nob11,nob12,nob14,nob15,
                               nob16,nob17,nob18,nob19,nob20,nob21,nob22,Group1",FALSE)
      CALL cl_set_comp_required("nob09",TRUE)
   ELSE                   
      IF p_argv1 = '3' THEN 
         CALL cl_set_comp_visible("noa02,noa03,noa05,noa06,noa07,noa08,noa09,noa10,noa11,noa12,
                                   noa13,noa14,azf03,nob08,nob10,nob11,nob12,nob13,nob14,nob15,
                                   nob16,nob17,nob18,nob19,nob20,nob21,nob22,Group1",FALSE) 
      END IF
   END IF  
   
   LET g_forupd_sql = "SELECT * FROM noa_file ",
                      " WHERE noa01 = ? AND noa02 = ? AND noa04 = ? AND noa05 = ?  AND noa14 = ? FOR UPDATE" 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i011_cl CURSOR FROM g_forupd_sql  
   CALL i011_menu()
END FUNCTION
 
FUNCTION i011_menu()
   WHILE TRUE
      CALL i011_bp("G")
      CASE g_action_choice
         WHEN "insert"                      
            IF cl_chk_act_auth() THEN
               CALL i011_a()
            END IF
         WHEN "modify"                          
            IF cl_chk_act_auth() THEN
               CALL i011_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i011_q()
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
               CALL i011_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()         
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nob),'','')
            END IF 
      END CASE
   END WHILE
END FUNCTION

#依照所選action，呼叫所屬功能的function
FUNCTION i011_bp(p_ud)			
   DEFINE   p_ud   LIKE type_file.chr1 
   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " " 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nob TO s_nob.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION insert                       
         LET g_action_choice='insert'
         EXIT DISPLAY
 
      ON ACTION query                           
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION modify                         
         LET g_action_choice='modify'
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY   

      ON ACTION detail                          
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
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
         CALL i011_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous                         
         CALL i011_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION jump                            
         CALL i011_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY               
 
      ON ACTION next                            
         CALL i011_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION last                            
         CALL i011_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
       ON ACTION help                            
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit                           
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel     
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")  

      AFTER DISPLAY
         CONTINUE DISPLAY 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#定義curs
FUNCTION i011_curs()

   DEFINE  lc_qbe_sn   LIKE  gbm_file.gbm01 
   CLEAR FORM
   CALL g_nob.clear()
   CONSTRUCT BY NAME g_wc ON  noa01,noa05,noa02,noa03,noa13,noa06,noa07,noa14,noa08,noa09,noa10,
                              noa11,noa12,noauser,noagrup,noaoriu,noaorig,noamodu,noadate,noaacti                              
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
              
   ON ACTION controlp
      CASE
         WHEN INFIELD(noa01)
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form="q_noc"
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO noa01
            NEXT FIELD noa01
         WHEN INFIELD(noa05)
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form="q_azf"
            LET g_qryparam.arg1 = 'T'
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO noa05
            NEXT FIELD noa05         
         OTHERWISE
            EXIT CASE
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

      ON ACTION browse
         LET g_noa.noa12 = cl_browse_dir()
         DISPLAY BY NAME g_noa.noa12    
 
      ON ACTION qbe_select                         	  
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)          
		
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('noauser', 'noagrup')
    
    CONSTRUCT g_wc2 ON nob05,nob06,nob07,nob08,nob09,nob10,nob11,nob12,nob13,nob14,
                       nob15,nob16,nob17,nob18,nob19,nob20,nob21,nob22,nob23 
                    FROM s_nob[1].nob05,s_nob[1].nob06,s_nob[1].nob07,s_nob[1].nob08,s_nob[1].nob09,
                         s_nob[1].nob10,s_nob[1].nob11,s_nob[1].nob12,s_nob[1].nob13,s_nob[1].nob14,
                         s_nob[1].nob15,s_nob[1].nob16,s_nob[1].nob17,s_nob[1].nob18,s_nob[1].nob19,
                         s_nob[1].nob20,s_nob[1].nob21,s_nob[1].nob22,s_nob[1].nob23
                    
    BEFORE CONSTRUCT
       CALL cl_qbe_display_condition(lc_qbe_sn)
            
    ON ACTION controlp
       IF g_noa04 = '2' THEN
       CASE
          WHEN INFIELD(nob13)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_nob13"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO nob13
             NEXT FIELD nob13          
          OTHERWISE
             EXIT CASE
       END CASE
       END IF
       
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
      ON ACTION qbe_save                        
         CALL cl_qbe_save()
		
    END CONSTRUCT
    
    IF INT_FLAG THEN 
        RETURN
    END IF
    
    LET g_wc2 = g_wc2 CLIPPED
    IF g_wc2 = " 1=1" THEN        
       LET g_sql = "SELECT noa01,noa02,noa04,noa05,noa14 FROM noa_file ", 
                   " WHERE ",g_wc CLIPPED,
                   "   AND noa04 = '",g_noa04,"'",                    
                   " ORDER BY noa01"
    ELSE                                 
       LET g_sql = "SELECT UNIQUE noa_file.noa01,noa_file.noa02,noa_file.noa04,
                           noa_file.noa05,noa_file.noa14",
                   "  FROM noa_file,nob_file",
                   " WHERE noa01 = nob01 AND noa02 = nob02 AND noa05 = nob03 ",
                   "   AND noa04 = nob04 AND noa14 = nob24",
                   "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   "   AND noa04 = '",g_noa04,"'",
                   " ORDER BY noa01"
    END IF    
    PREPARE i011_prepare FROM g_sql
    DECLARE i011_cs SCROLL CURSOR WITH HOLD FOR i011_prepare
    IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT COUNT(*) FROM noa_file WHERE ",g_wc CLIPPED,
                 "   AND noa04 = '",g_noa04,"'"
    ELSE
       LET g_sql="SELECT COUNT(*) FROM noa_file,nob_file ",                 
                 " WHERE noa01 = nob01 AND noa02 = nob02 AND noa05 = nob03 ",
                 "   AND noa04 = nob04 AND noa14 = nob24",
                 "   AND noa04 = '",g_noa04,"'",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF 
    PREPARE i011_precount FROM g_sql
    DECLARE i011_count CURSOR FOR i011_precount  
       
END FUNCTION

#新增
FUNCTION i011_a()

   MESSAGE ""
   CLEAR FORM
   CALL g_nob.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF   
 
   INITIALIZE g_noa.* LIKE noa_file.*                  
   LET g_noa_t.* = g_noa.*
   CALL cl_opmsg('a')                  
   
   WHILE TRUE       
      LET g_noa.noaacti  ='Y'
      LET g_noa.noaoriu = g_user     
      LET g_noa.noaorig = g_grup 
      LET g_noa.noauser  = g_user
      LET g_noa.noagrup  = g_grup    
      LET g_noa.noa04 = g_noa04    #資料類型  
      LET g_noa.noa06 = '1'        #傳輸格式
      LET g_noa.noa10 = '1'        #文件名編碼方式
      LET g_noa.noa11 = '1'        #文件格式
      LET g_noa.noa13 = 'N'        #默認版本
      LET g_noa.noa14 = '1'        #報文類型
      
      IF g_noa04 = '1' THEN         #網銀報文結構設定         
         LET g_noa.noa07 = ' '      #分隔符
         LET g_noa.noa08 = ' '      #支付文件分隔符         
      ELSE
         IF g_noa04 = '3' THEN      #網銀公共配置
            LET g_noa.noa02 = ' '   #版本
            LET g_noa.noa05 = ' '   #交易類型
            LET g_noa.noa07 = ' '   #分隔符
            LET g_noa.noa08 = ' '   #支付文件分隔符            
            LET g_noa.noa14 = '3'   #報文類型
         END IF
      END IF
      CALL i011_i("a") 
      
      IF INT_FLAG THEN                      
         INITIALIZE g_noa.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      
      IF cl_null(g_noa.noa01) THEN       
         CONTINUE WHILE
      END IF

      BEGIN WORK
      
      IF cl_null(g_noa.noa08) THEN LET g_noa.noa08=' ' END IF
      INSERT INTO noa_file VALUES (g_noa.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                     
         CALL cl_err3("ins","noa_file",g_noa.noa01,"",SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK    
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF 
      LET g_noa_t.* = g_noa.*
      CALL g_nob.clear()
 
      LET g_rec_b = 0  
      CALL i011_b()                   
      EXIT WHILE
   END WHILE      
END FUNCTION

#錄入 
FUNCTION i011_i(p_cmd)       
   DEFINE   p_cmd        LIKE type_file.chr1    
   DEFINE   l_count      LIKE type_file.num5    

   DISPLAY BY NAME g_noa.noa01,g_noa.noa02,g_noa.noa03,g_noa.noa13,g_noa.noa05,g_noa.noa06,g_noa.noa07,
                   g_noa.noa08,g_noa.noa09,g_noa.noa10,g_noa.noa11,g_noa.noa12,g_noa.noa14,g_noa.noauser,
                   g_noa.noagrup,g_noa.noamodu,g_noa.noadate,g_noa.noaoriu,g_noa.noaorig,g_noa.noaacti    

   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME g_noa.noa01,g_noa.noa05,g_noa.noa02,g_noa.noa03,g_noa.noa13,g_noa.noa06,g_noa.noa07,g_noa.noa14,
                 g_noa.noa08,g_noa.noa09,g_noa.noa10,g_noa.noa11,g_noa.noa12
   WITHOUT DEFAULTS
      BEFORE INPUT 
         IF g_noa.noa06 = '1' THEN
            CALL cl_set_comp_entry("noa07",FALSE) 
         ELSE
            CALL cl_set_comp_entry("noa07",TRUE) 
         END IF   
          
      AFTER FIELD noa01
         IF NOT cl_null(g_noa.noa01) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_noa.noa01 <> g_noa_t.noa01) THEN     
               CALL i011_noa01(g_noa.noa01)                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                        
                  CALL cl_err('',g_errno,0)                                                                                         
                  LET g_noa.noa01 = g_noa_t.noa01
                  DISPLAY BY NAME g_noa.noa01
                  NEXT FIELD noa01                                                                                                  
               END IF
               CALL i011_noa03(p_cmd)
            END IF
         END IF 

      AFTER FIELD noa02
         IF NOT cl_null(g_noa.noa02) THEN
            CALL i011_noa03(p_cmd)
         END IF 

      AFTER FIELD noa05
         IF NOT cl_null(g_noa.noa05) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_noa.noa05 <> g_noa_t.noa05) THEN     
               CALL i011_noa05(g_noa.noa05)                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                        
                  CALL cl_err('',g_errno,0)                                                                                         
                  LET g_noa.noa05 = g_noa_t.noa05
                  DISPLAY BY NAME g_noa.noa05
                  NEXT FIELD noa05                                                                                                  
               END IF
               CALL i011_noa03(p_cmd)
            END IF
         END IF

      AFTER FIELD noa06
         IF NOT cl_null(g_noa.noa06) THEN
            IF g_noa.noa06 = '2' THEN
               CALL cl_set_comp_entry("noa07",TRUE)
            ELSE
               LET g_noa.noa07 = ' '
               CALL cl_set_comp_entry("noa07",FALSE)
            END IF   
         END IF    

      AFTER FIELD noa13
         IF NOT cl_null(g_noa.noa13) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_noa.noa13 <> g_noa_t.noa13) THEN
               CALL i011_noa13(p_cmd,g_noa.noa13,g_noa_t.noa13)                                                                                                  
               IF NOT cl_null(g_errno)  THEN   
                  LET g_noa.noa13 = 'N'
                  DISPLAY BY NAME g_noa.noa13              
                  CALL cl_err('',g_errno,0)                                                                                         
                  NEXT FIELD noa13                                                                                                  
               END IF
            END IF
         END IF 

      AFTER FIELD noa14
         IF NOT cl_null(g_noa.noa02) THEN
            CALL i011_noa03(p_cmd)
         END IF  
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(noa01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_noc"
               LET g_qryparam.default1= g_noa.noa01
               CALL cl_create_qry() RETURNING g_noa.noa01
               NEXT FIELD noa01 
            WHEN INFIELD(noa05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.arg1 = 'T'
               LET g_qryparam.default1= g_noa.noa05
               CALL cl_create_qry() RETURNING g_noa.noa05
               NEXT FIELD noa05    
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

      ON ACTION browse
           LET g_noa.noa12 = cl_browse_dir()
           DISPLAY BY NAME g_noa.noa12 

      ON ACTION CONTROLR
         CALL cl_show_req_fields() 
     
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
END FUNCTION

#修改 
FUNCTION i011_u() 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_noa.noa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_noa.* 
     FROM noa_file
    WHERE noa01 = g_noa.noa01
      AND noa02 = g_noa.noa02
      AND noa04 = g_noa04
      AND noa05 = g_noa.noa05
      AND noa14 = g_noa.noa14
      
   CALL cl_opmsg('u')      
 
   BEGIN WORK
   OPEN i011_cl USING g_noa.noa01,g_noa.noa02,g_noa04,g_noa.noa05,g_noa.noa14  
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i011_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i011_cl INTO g_noa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("OPEN i011_cl::",SQLCA.sqlcode,1)
      CLOSE i011_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL i011_show() 
   WHILE TRUE
      LET g_noa_t.* = g_noa.*
      LET g_noa.noamodu = g_user
      LET g_noa.noadate = g_today
   
      CALL i011_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_noa.* = g_noa_t.*
         CALL i011_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF g_noa.noa01 <> g_noa_t.noa01 OR g_noa.noa02 <> g_noa_t.noa02 
         OR g_noa.noa05 <> g_noa_t.noa05 OR g_noa.noa14 <> g_noa_t.noa14 THEN            
         UPDATE nob_file 
            SET nob01 = g_noa.noa01,nob02 = g_noa.noa02,
                nob03 = g_noa.noa05,nob24 = g_noa.noa14
          WHERE nob01 = g_noa_t.noa01
            AND nob02 = g_noa_t.noa02
            AND nob04 = g_noa_t.noa04
            AND nob03 = g_noa_t.noa05
            AND nob24 = g_noa_t.noa14
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","noa_file",g_noa_t.noa01,"",SQLCA.sqlcode,"","noa",1)  
            CONTINUE WHILE
         END IF
      END IF

      IF g_noa.noa13 <> g_noa_t.noa13 OR g_noa.noa03 <> g_noa_t.noa03  THEN
         UPDATE noa_file SET noa03 = g_noa.noa03,noa13 = g_noa.noa13
          WHERE noa01 = g_noa_t.noa01
            AND noa02 = g_noa_t.noa02
            AND noa05 = g_noa_t.noa05
            AND noa14 = g_noa_t.noa14 
      END IF 
 
      IF cl_null(g_noa.noa08) THEN LET g_noa.noa08=' ' END IF
      UPDATE noa_file SET noa_file.* = g_noa.*
       WHERE noa01 = g_noa_t.noa01
         AND noa02 = g_noa_t.noa02
         AND noa04 = g_noa_t.noa04
         AND noa05 = g_noa_t.noa05
         AND noa14 = g_noa_t.noa14 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","noa_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF   
      EXIT WHILE
   END WHILE 
   CLOSE i011_cl
   COMMIT WORK
   CALL i011_show() 
   CALL i011_bp_refresh()
END FUNCTION

FUNCTION i011_bp_refresh()
   DISPLAY ARRAY g_nob TO s_nob.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

#查詢
FUNCTION i011_q()                            #Query 查詢

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
  
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_nob.clear()
   DISPLAY ' ' TO FORMONLY.cnt 
   CALL i011_curs() 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_noa.* TO NULL
      RETURN
   END IF
 
   OPEN i011_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_noa.* TO NULL
   ELSE
      OPEN i011_count
      FETCH i011_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt 
      CALL i011_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i011_r()        
   DEFINE   l_cnt   LIKE type_file.num5,          
            l_nob   RECORD LIKE nob_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_noa.noa01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 

   SELECT * INTO g_noa.* 
     FROM noa_file
    WHERE noa01 = g_noa.noa01
      AND noa02 = g_noa.noa02
      AND noa04 = g_noa04
      AND noa05 = g_noa.noa05
      AND noa14 = g_noa.noa14

   BEGIN WORK
   OPEN i011_cl USING g_noa.noa01,g_noa.noa02,g_noa04,g_noa.noa05,g_noa.noa14
   IF STATUS THEN
      CALL cl_err("OPEN i011_cl:", STATUS, 1)
      CLOSE i011_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i011_cl INTO g_noa.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_noa.noa01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
   CALL i011_show()    
   
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM noa_file 
       WHERE noa01 = g_noa.noa01  AND noa02 = g_noa.noa02
         AND noa04 = g_noa04      AND noa05 = g_noa.noa05
         AND noa14 = g_noa.noa14 
      DELETE FROM nob_file
       WHERE nob01 = g_noa.noa01  AND nob02 = g_noa.noa02
         AND nob04 = g_noa04      AND nob03 = g_noa.noa05
         AND nob24 = g_noa.noa14 

      CLEAR FORM
      CALL g_nob.clear()
      OPEN i011_count
      #FUN-B50065-add-start--
      IF STATUS THEN
         CLOSE i011_cl
         CLOSE i011_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50065-add-end--
      FETCH i011_count INTO g_row_count
      #FUN-B50065-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i011_cl
         CLOSE i011_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50065-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i011_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i011_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE      
            CALL i011_fetch('/')
         END IF
      END IF
   END IF 
   CLOSE i011_cl
   COMMIT WORK     
END FUNCTION

#處理資料的讀取
FUNCTION i011_fetch(p_flag)                       
   DEFINE   p_flag   LIKE type_file.chr1         #處理方式     
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i011_cs INTO g_noa.noa01,g_noa.noa02,g_noa.noa04,g_noa.noa05,g_noa.noa14  
      WHEN 'P' FETCH PREVIOUS i011_cs INTO g_noa.noa01,g_noa.noa02,g_noa.noa04,g_noa.noa05,g_noa.noa14
      WHEN 'F' FETCH FIRST    i011_cs INTO g_noa.noa01,g_noa.noa02,g_noa.noa04,g_noa.noa05,g_noa.noa14
      WHEN 'L' FETCH LAST     i011_cs INTO g_noa.noa01,g_noa.noa02,g_noa.noa04,g_noa.noa05,g_noa.noa14
      WHEN '/' 
         IF (NOT g_no_ask) THEN        
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i011_cs INTO g_noa.noa01,g_noa.noa02,g_noa.noa04,g_noa.noa05,g_noa.noa14
         LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_noa.noa01,SQLCA.sqlcode,0)
      INITIALIZE g_noa.* TO NULL  
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump 
      END CASE 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF

   SELECT * INTO g_noa.* FROM noa_file 
    WHERE noa01 = g_noa.noa01 
      AND noa02 = g_noa.noa02 
      AND noa05 = g_noa.noa05 
      AND noa04 = g_noa.noa04 
      AND noa14 = g_noa.noa14
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","noa_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_noa.* TO NULL
      RETURN
   END IF 
   LET g_data_owner = g_noa.noauser     
   LET g_data_group = g_noa.noagrup  

   CALL i011_show()   
END FUNCTION

#將資料顯示在畫面上
FUNCTION i011_show() 
                        
   LET g_noa_t.* = g_noa.*
   DISPLAY BY NAME g_noa.noa01,g_noa.noa02,g_noa.noa03,g_noa.noa13,g_noa.noa05,g_noa.noa06,g_noa.noa07,
                   g_noa.noa08,g_noa.noa09,g_noa.noa10,g_noa.noa11,g_noa.noa12,g_noa.noa14,g_noa.noauser,
                   g_noa.noagrup,g_noa.noamodu,g_noa.noadate,g_noa.noaoriu,g_noa.noaorig,g_noa.noaacti 
   CALL i011_noa01(g_noa.noa01) 
   CALL i011_noa05(g_noa.noa05)    
   CALL i011_b_fill(g_wc2)                    # 單身
   CALL cl_show_fld_cont()                  
END FUNCTION

#單身填充
FUNCTION i011_b_fill(p_wc)               
    DEFINE p_wc         STRING 
    
    LET g_sql = "SELECT nob05,nob06,nob07,nob08,nob09,nob10,nob11,nob12,nob13,nob14,",
                "       nob15,nob16,nob17,nob18,nob19,nob20,nob21,nob22,nob23 FROM nob_file ",   
                " WHERE nob01='",g_noa.noa01,"' ",
                "   AND nob02='",g_noa.noa02,"' ",
                "   AND nob03='",g_noa.noa05,"' ",
                "   AND nob04='",g_noa04,"' ",
                "   AND nob24='",g_noa.noa14,"' "                
    IF NOT cl_null(p_wc) THEN
       LET g_sql = g_sql CLIPPED," AND ",p_wc CLIPPED
    END IF 
    LET g_sql = g_sql CLIPPED,"  ORDER BY nob05"     
    PREPARE i011_prepare2 FROM g_sql           #預備一下
    DECLARE nob_curs CURSOR FOR i011_prepare2
 
    CALL g_nob.clear() 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH nob_curs INTO g_nob[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
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
    CALL g_nob.deleteElement(g_cnt) 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

#單身處理 
FUNCTION i011_b()  
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重復用    
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
    p_cmd           LIKE type_file.chr1,                #處理狀態          
    l_allow_insert  LIKE type_file.num5,                #可新增否          
    l_allow_delete  LIKE type_file.num5,                #可刪除否          
    l_cnt           LIKE type_file.num5
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_noa.noa01) THEN 
       CALL cl_err('',-400,0)
       RETURN
    END IF 
    SELECT * INTO g_noa.* 
      FROM noa_file
     WHERE noa01 = g_noa.noa01
       AND noa02 = g_noa.noa02
       AND noa04 = g_noa04
       AND noa05 = g_noa.noa05
       AND noa14 = g_noa.noa14
    
    CALL cl_opmsg('b')                     #顯示操作方法
    IF g_noa04='1' OR (g_noa04='2' AND g_noa.noa06='1') THEN      
       CALL cl_set_comp_required("nob13",TRUE)
    ELSE
       CALL cl_set_comp_required("nob13",FALSE)
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    LET g_forupd_sql = "SELECT nob05,nob06,nob07,nob08,nob09,nob10,nob11,nob12,nob13,nob14,",
                       "       nob15,nob16,nob17,nob18,nob19,nob20,nob21,nob22,nob23 FROM nob_file ",   
                       " WHERE nob01= ?  AND nob02= ? AND nob03= ? AND nob04= ? AND nob05 = ? AND nob24= ? FOR UPDATE  " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i011_bcl CURSOR FROM g_forupd_sql      
 
    LET l_ac_t = 0
    INPUT ARRAY g_nob WITHOUT DEFAULTS FROM s_nob.*
          ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
          INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_n  = ARR_COUNT()
        LET l_lock_sw = 'N'            #DEFAULT
        BEGIN WORK
        OPEN i011_cl USING g_noa.noa01,g_noa.noa02,g_noa.noa04,g_noa.noa05,g_noa.noa14
        IF STATUS THEN
           CALL cl_err("OPEN i011_cl:",STATUS,1)
           CLOSE i011_cl
           ROLLBACK WORK
        END IF
                
        FETCH i011_cl INTO g_noa.*
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_noa.noa01,SQLCA.sqlcode,0)
           CLOSE i011_cl
           ROLLBACK WORK 
           RETURN
        END IF
           
        IF g_rec_b >= l_ac THEN           
           LET p_cmd='u'                                    
           LET g_nob_t.* = g_nob[l_ac].*  #BACKUP
           OPEN i011_bcl USING g_noa.noa01,g_noa.noa02,g_noa.noa05,g_noa.noa04,g_nob_t.nob05,g_noa.noa14
           IF STATUS THEN
              CALL cl_err("OPEN i011_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i011_bcl INTO g_nob[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_noa.noa01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
        END IF
        CALL i011_set_entry_b(p_cmd)
        CALL i011_set_no_entry_b(p_cmd) 
        --CALL cl_set_comp_required("nob15,nob17,nob18",FALSE)
        --CALL cl_set_comp_required("nob20",FALSE)
        --CALL cl_set_comp_required("nob22",FALSE)
        
     BEFORE INSERT        
        LET l_n = ARR_COUNT()
        LET p_cmd='a'                       
        INITIALIZE g_nob[l_ac].* TO NULL 
        LET g_nob_t.* = g_nob[l_ac].*
        LET g_nob[l_ac].nob08 = '1'
        LET g_nob[l_ac].nob14 = 'Y'
        LET g_nob[l_ac].nob16 = 'N'
        LET g_nob[l_ac].nob19 = 'N'
        LET g_nob[l_ac].nob21 = 'N'
        LET g_nob[l_ac].nob22 = ' ' 
        CALL cl_show_fld_cont()
        CALL i011_set_entry_b(p_cmd)
        CALL i011_set_no_entry_b(p_cmd)  
        NEXT FIELD nob05

     BEFORE FIELD nob05     #序號
        IF cl_null(g_nob[l_ac].nob05) OR g_nob[l_ac].nob05 = 0 THEN
           SELECT MAX(nob05)+1 INTO g_nob[l_ac].nob05
             FROM nob_file
            WHERE nob01 = g_noa.noa01
              AND nob02 = g_noa.noa02
              AND nob03 = g_noa.noa05
              AND nob04 = g_noa.noa04
              AND nob24 = g_noa.noa14
           IF g_nob[l_ac].nob05 IS NULL THEN
              LET g_nob[l_ac].nob05 = 1
           END IF
        END IF

     AFTER FIELD nob05   #序號
        IF NOT cl_null(g_nob[l_ac].nob05) THEN
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_nob[l_ac].nob05 <> g_nob_t.nob05) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM nob_file
               WHERE nob01 = g_noa.noa01
                 AND nob02 = g_noa.noa02
                 AND nob03 = g_noa.noa05
                 AND nob04 = g_noa.noa04
                 AND nob24 = g_noa.noa14
                 AND nob05 = g_nob[l_ac].nob05
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_nob[l_ac].nob05 = g_nob_t.nob05
                 NEXT FIELD nob05
              END IF
           END IF
        END IF

     ON CHANGE nob08  #取值來源   
        IF NOT cl_null(g_nob[l_ac].nob08) THEN
           CALL i011_nob08_entry(g_nob[l_ac].nob08) 
        END IF

     AFTER FIELD nob06 #銀行字段名
        IF g_noa.noa04 <> '1' AND g_nob[l_ac].nob06 MATCHES "<*>" THEN
           CALL cl_err(g_nob[l_ac].nob06,'sub-005',0)
           NEXT FIELD nob06
        END IF

     AFTER FIELD nob09 #固定值
        IF g_noa.noa04 = '1' AND NOT cl_null(g_nob[l_ac].nob09) THEN
           IF g_nob[l_ac].nob09 NOT MATCHES "<*>"  THEN
              CALL cl_err(g_nob[l_ac].nob09,'sub-005',0)
              NEXT FIELD nob09
           END IF
           CALL i011_chknob13()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_nob[l_ac].nob09,g_errno,0)
              LET g_nob[l_ac].nob09 = g_nob_t.nob09
              NEXT FIELD nob09
           END IF
        END IF

     AFTER FIELD nob13 #類別  
        IF NOT cl_null(g_nob[l_ac].nob13) THEN
           IF g_noa.noa04 = '2' THEN   #来源类型2时检查
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM nob_file
               WHERE nob01 = g_noa.noa01 AND nob02 = g_noa.noa02 
                 AND nob03 = g_noa.noa05 AND nob24 = g_noa.noa14
                 AND nob13 = g_nob[l_ac].nob13 AND nob04 = '1'         
              IF l_cnt < 1 THEN
                 CALL cl_err(g_nob[l_ac].nob13,'art-248',0)
                 LET g_nob[l_ac].nob13 = g_nob_t.nob13
                 NEXT FIELD nob13
              END IF 
           ELSE
              IF g_noa.noa04 = '1' THEN
                 CALL i011_chknob13()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nob[l_ac].nob13,g_errno,0)
                    LET g_nob[l_ac].nob13 = g_nob_t.nob13
                    NEXT FIELD nob13
                 END IF
              END IF
           END IF
        END IF   

     AFTER FIELD nob15 #最大長度
        IF g_nob[l_ac].nob16 = 'Y' THEN
           IF NOT cl_null(g_nob[l_ac].nob15) AND g_nob[l_ac].nob15 <= 0 THEN
              CALL cl_err(g_nob[l_ac].nob15,'anm1025',0)
              LET g_nob[l_ac].nob15 = g_nob_t.nob15
              NEXT FIELD nob15
           END IF
        ELSE
           CALL cl_set_comp_required("nob15",FALSE)
        END IF
        

     ON CHANGE nob16  #不足需補字符
        IF NOT cl_null(g_nob[l_ac].nob16) THEN
           IF g_nob[l_ac].nob16 = 'Y' THEN
              CALL cl_set_comp_entry("nob17,nob18",TRUE)
              CALL cl_set_comp_required("nob15,nob17,nob18",TRUE)
           ELSE
              CALL cl_set_comp_entry("nob17,nob18",FALSE)
              CALL cl_set_comp_required("nob15,nob17,nob18",FALSE)
              LET g_nob[l_ac].nob17 = ''
              LET g_nob[l_ac].nob18 = ''
              DISPLAY BY NAME g_nob[l_ac].nob17,g_nob[l_ac].nob18
           END IF
        END IF        

     ON CHANGE nob19  #是否控制小數位數
        IF NOT cl_null(g_nob[l_ac].nob19) THEN
           IF g_nob[l_ac].nob19 = 'Y' THEN
              CALL cl_set_comp_entry("nob20",TRUE)
              CALL cl_set_comp_required("nob20",TRUE)
           ELSE
              CALL cl_set_comp_entry("nob20",FALSE)
              CALL cl_set_comp_required("nob20",FALSE)
              LET g_nob[l_ac].nob20 = ''
              DISPLAY BY NAME g_nob[l_ac].nob20
           END IF
        END IF    


     ON CHANGE nob21  #多域串
        IF NOT cl_null(g_nob[l_ac].nob21) THEN
           IF g_nob[l_ac].nob21 = 'Y' THEN
              CALL cl_set_comp_entry("nob22",TRUE)
              CALL cl_set_comp_required("nob22",TRUE)
           ELSE
              CALL cl_set_comp_entry("nob22",FALSE)
              CALL cl_set_comp_required("nob22",FALSE)
              LET g_nob[l_ac].nob22 = ' '
              DISPLAY BY NAME g_nob[l_ac].nob22
           END IF
        END IF        

     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CANCEL INSERT
        END IF
        INSERT INTO nob_file(nob01,nob02,nob03,nob04,nob05,nob06,nob07,nob08,nob09,nob10,nob11,nob12,nob13,
                             nob14,nob15,nob16,nob17,nob18,nob19,nob20,nob21,nob22,nob23,nob24,nobacti,nobuser,nobdate,noboriu,noborig) 
        VALUES(g_noa.noa01,g_noa.noa02,g_noa.noa05,g_noa.noa04,g_nob[l_ac].nob05,g_nob[l_ac].nob06,g_nob[l_ac].nob07,g_nob[l_ac].nob08,  
               g_nob[l_ac].nob09,g_nob[l_ac].nob10,g_nob[l_ac].nob11,g_nob[l_ac].nob12,g_nob[l_ac].nob13,g_nob[l_ac].nob14,       
               g_nob[l_ac].nob15,g_nob[l_ac].nob16,g_nob[l_ac].nob17,g_nob[l_ac].nob18,g_nob[l_ac].nob19,g_nob[l_ac].nob20,
               g_nob[l_ac].nob21,g_nob[l_ac].nob22,g_nob[l_ac].nob23,g_noa.noa14,'Y',g_user,g_today,g_user,g_grup)                              
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","nob_file",g_nob[l_ac].nob05,"",SQLCA.sqlcode,"","",1)  
           CANCEL INSERT
        ELSE
           LET g_rec_b=g_rec_b+1
           DISPLAY g_rec_b TO FORMONLY.cn2  
        END IF     
          
     BEFORE DELETE                            #是否取消單身
        IF NOT cl_null(g_nob_t.nob05) THEN
           IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM nob_file WHERE nob01 = g_noa.noa01
                                   AND nob02 = g_noa.noa02
                                   AND nob03 = g_noa.noa05
                                   AND nob04 = g_noa.noa04
                                   AND nob05 = g_nob[l_ac].nob05
                                   AND nob24 = g_noa.noa14
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","nob_file",g_nob[l_ac].nob05,"",SQLCA.sqlcode,"","",0)
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
            LET g_nob[l_ac].* = g_nob_t.*
            CLOSE i011_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF         
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nob[l_ac].nob05,-263,1)
            LET g_nob[l_ac].* = g_nob_t.*
         ELSE
            UPDATE nob_file
               SET nob05 = g_nob[l_ac].nob05,nob06 = g_nob[l_ac].nob06,
                   nob07 = g_nob[l_ac].nob07,nob08 = g_nob[l_ac].nob08,
                   nob09 = g_nob[l_ac].nob09,nob10 = g_nob[l_ac].nob10,
                   nob11 = g_nob[l_ac].nob11,nob12 = g_nob[l_ac].nob12,
                   nob13 = g_nob[l_ac].nob13,nob14 = g_nob[l_ac].nob14,
                   nob15 = g_nob[l_ac].nob15,nob16 = g_nob[l_ac].nob16,
                   nob17 = g_nob[l_ac].nob17,nob18 = g_nob[l_ac].nob18,
                   nob19 = g_nob[l_ac].nob19,nob20 = g_nob[l_ac].nob20,
                   nob21 = g_nob[l_ac].nob21,nob22 = g_nob[l_ac].nob22,
                   nob23 = g_nob[l_ac].nob23,nobmodu = g_user,
                   nobdate = g_today  
             WHERE nob01 = g_noa.noa01
               AND nob02 = g_noa.noa02
               AND nob03 = g_noa.noa05
               AND nob04 = g_noa.noa04
               AND nob05 = g_nob_t.nob05
               AND nob24 = g_noa.noa14
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","nob_file",g_nob_t.nob05,"",SQLCA.sqlcode,"","",0)  
               LET g_nob[l_ac].* = g_nob_t.*
            ELSE
               COMMIT WORK
            END IF
         END IF
         
     AFTER ROW
         LET l_ac = ARR_CURR()
     #   LET l_ac_t = l_ac     #FUN-D30032 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nob[l_ac].* = g_nob_t.*
           #FUN-D30032--add--str--
            ELSE
               CALL g_nob.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D30032--add--end--
            END IF
            CLOSE i011_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30032 add
         CLOSE i011_bcl
         COMMIT WORK
   
     ON ACTION CONTROLO                        #沿用所有欄位
        IF INFIELD(nob01) AND l_ac > 1 THEN
          LET g_nob[l_ac].* = g_nob[l_ac-1].*
          NEXT FIELD nob01
        END IF   
        
     ON ACTION CONTROLR
       CALL cl_show_req_fields()
       
     ON ACTION CONTROLP
        IF g_noa04 = '2' THEN
           CASE
           WHEN INFIELD(nob13)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nob13"
              LET g_qryparam.arg1 = g_noa.noa01
              LET g_qryparam.arg2 = g_noa.noa02
              LET g_qryparam.arg3 = g_noa.noa05
              LET g_qryparam.arg4 = g_noa.noa14
              LET g_qryparam.default1 = g_nob[l_ac].nob13
              CALL cl_create_qry() RETURNING g_nob[l_ac].nob13
              DISPLAY BY NAME g_nob[l_ac].nob13
              NEXT FIELD nob13
           END CASE
        END IF 
         
     ON ACTION CONTROLG
        CALL cl_cmdask()
        
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
        
     ON ACTION CONTROLS                                                                                                          
        CALL cl_set_head_visible("","AUTO")  
   END INPUT 

   LET g_noa.noamodu = g_user
   LET g_noa.noadate = g_today
   UPDATE noa_file SET noamodu = g_noa.noamodu,noadate = g_noa.noadate
    WHERE noa01 = g_noa.noa01
      AND noa02 = g_noa.noa02
      AND noa04 = g_noa.noa04
      AND noa05 = g_noa.noa05
      AND noa14 = g_noa.noa14 
   DISPLAY BY NAME g_noa.noamodu,g_noa.noadate
   
   CLOSE i011_bcl
   COMMIT WORK 
#  CALL i011_delall()        #CHI-C30002 mark
   CALL i011_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i011_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM noa_file WHERE noa01 = g_noa.noa01
                                AND noa02 = g_noa.noa02
                                AND noa04 = g_noa.noa04
                                AND noa05 = g_noa.noa05
                                 AND noa14 = g_noa.noa14
         INITIALIZE g_noa.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i011_delall()

#  SELECT COUNT(*) INTO g_cnt FROM nob_file
#   WHERE nob01 = g_noa.noa01
#     AND nob02 = g_noa.noa02
#     AND nob04 = g_noa.noa04
#     AND nob03 = g_noa.noa05
#     AND nob24 = g_noa.noa14
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM noa_file WHERE noa01 = g_noa.noa01
#                            AND noa02 = g_noa.noa02
#                            AND noa04 = g_noa.noa04
#                            AND noa05 = g_noa.noa05
#                            AND noa14 = g_noa.noa14
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end

#接口銀行編碼
FUNCTION i011_noa01(p_noa01)
   DEFINE p_noa01     LIKE noa_file.noa01
   DEFINE l_noc02     LIKE noc_file.noc02
   DEFINE l_nocacti   LIKE noc_file.nocacti

   LET g_errno = ''
   SELECT noc02,nocacti INTO l_noc02,l_nocacti FROM noc_file WHERE noc01 = p_noa01
   CASE
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'anm1036'
                                 LET l_noc02 = NULL
      WHEN l_nocacti = 'N'       LET g_errno='9028'  
                                 LET l_noc02 = NULL      
      OTHERWISE
                                 LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   DISPLAY l_noc02 TO FORMONLY.noc02
END FUNCTION

#交易類型
FUNCTION i011_noa05(p_noa05)
   DEFINE p_noa05     LIKE noa_file.noa05
   DEFINE l_azf03     LIKE azf_file.azf03
   DEFINE l_azfacti   LIKE azf_file.azfacti

   LET g_errno = ''
   SELECT azf03,azfacti INTO l_azf03,l_azfacti FROM azf_file WHERE azf01 = p_noa05 AND azf02 = 'T'
   CASE
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'anm1034'
                                 LET l_azf03 = NULL
      WHEN l_azfacti = 'N'       LET g_errno='9028' 
                                 LET l_azf03 = NULL      
      OTHERWISE
                                 LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   DISPLAY l_azf03 TO FORMONLY.azf03
END FUNCTION

#銀行版本名稱
#接口銀行編碼+交易類型+版本+報文類型存在于noa_file中，自動帶出名稱及默認版本，不可修改
FUNCTION i011_noa03(p_cmd)
   DEFINE l_noa03  LIKE noa_file.noa03 #版本說明
   DEFINE l_noa13  LIKE noa_file.noa13 #默認版本
   DEFINE p_cmd      LIKE type_file.chr1

   IF cl_null(g_noa.noa01) OR cl_null(g_noa.noa02) OR cl_null(g_noa.noa05) OR cl_null(g_noa.noa14)THEN
      CALL cl_set_comp_entry("noa03,noa13",TRUE)
      RETURN
   END IF
   SELECT DISTINCT noa03,noa13 INTO l_noa03,l_noa13 FROM noa_file 
    WHERE noa01 = g_noa.noa01 AND noa02 = g_noa.noa02
      AND noa05 = g_noa.noa05 AND noa14 = g_noa.noa14
      AND noa04 <> g_noa04
   IF NOT cl_null(l_noa03) AND p_cmd = 'a' THEN
      CALL cl_set_comp_entry("noa03,noa13",FALSE)
      LET g_noa.noa03 = l_noa03
      LET g_noa.noa13 = l_noa13
      DISPLAY BY NAME g_noa.noa03,g_noa.noa13
   ELSE
      CALL cl_set_comp_entry("noa03,noa13",TRUE)
   END IF
END FUNCTION

#默認版本
#同一接口銀行編碼+交易類型+報文類型只能有一個默認版本
FUNCTION i011_noa13(p_cmd,p_noa13,p_noa13_t)   
   DEFINE l_n        LIKE type_file.num5
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE p_noa13    LIKE noa_file.noa13
   DEFINE p_noa13_t  LIKE noa_file.noa13  
   
   IF cl_null(g_noa.noa01) OR cl_null(g_noa.noa05) OR cl_null(g_noa.noa14)THEN
      RETURN
   END IF
   LET g_errno = ''
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM noa_file 
    WHERE noa01 = g_noa.noa01 AND noa05 = g_noa.noa05 
      AND noa14 = g_noa.noa14 AND noa13 = 'Y'      
   IF p_cmd = 'a' AND p_noa13 = 'Y' AND l_n > 0 THEN
      LET g_errno = 'anm1037' 
   ELSE
      IF p_cmd = 'u' THEN         
         IF p_noa13_t = 'N' AND p_noa13 = 'Y' AND l_n > 0 THEN
            LET g_errno = 'anm1037'         
         END IF
      END IF   
   END IF
END FUNCTION

#來源類型不同對應欄位開啟和關閉
FUNCTION i011_nob08_entry(p_nob08)                                          
   DEFINE p_nob08   LIKE nob_file.nob08
   CASE p_nob08
        WHEN '1'  #固定值
           CALL cl_set_comp_entry("nob09",TRUE)
           CALL cl_set_comp_entry("nob10",FALSE)
           CALL cl_set_comp_entry("nob11",FALSE)
           CALL cl_set_comp_entry("nob12",FALSE)
           LET g_nob[l_ac].nob10=''
           LET g_nob[l_ac].nob11=''
           LET g_nob[l_ac].nob12=''
        WHEN '2'  #從TIPTOP中取值
           CALL cl_set_comp_entry("nob09",FALSE)
           CALL cl_set_comp_entry("nob10",TRUE)
           CALL cl_set_comp_entry("nob11",TRUE)
           CALL cl_set_comp_entry("nob12",TRUE)
           LET g_nob[l_ac].nob09=''    
        WHEN '4'  #畫面
           CALL cl_set_comp_entry("nob09",TRUE)
           CALL cl_set_comp_entry("nob10",FALSE)
           CALL cl_set_comp_entry("nob11",FALSE)
           CALL cl_set_comp_entry("nob12",FALSE)
           LET g_nob[l_ac].nob10=''
           LET g_nob[l_ac].nob11=''
           LET g_nob[l_ac].nob12=''
        WHEN '6'  #日期
           CALL cl_set_comp_entry("nob09",TRUE)
           CALL cl_set_comp_entry("nob10",FALSE)
           CALL cl_set_comp_entry("nob11",FALSE)
           CALL cl_set_comp_entry("nob12",FALSE)
           LET g_nob[l_ac].nob10=''
           LET g_nob[l_ac].nob11=''
           LET g_nob[l_ac].nob12=''
        WHEN '7'  #時間
           CALL cl_set_comp_entry("nob09",TRUE)
           CALL cl_set_comp_entry("nob10",FALSE)
           CALL cl_set_comp_entry("nob11",FALSE)
           CALL cl_set_comp_entry("nob12",FALSE)
           LET g_nob[l_ac].nob10=''
           LET g_nob[l_ac].nob11=''
           LET g_nob[l_ac].nob12=''
        OTHERWISE           
           CALL cl_set_comp_entry("nob09",FALSE)
           CALL cl_set_comp_entry("nob10",FALSE)
           CALL cl_set_comp_entry("nob11",FALSE)
           CALL cl_set_comp_entry("nob12",FALSE)
   END CASE   
   DISPLAY BY NAME g_nob[l_ac].nob09,g_nob[l_ac].nob10,
                   g_nob[l_ac].nob11,g_nob[l_ac].nob12   
END FUNCTION    

#固定值與類別
FUNCTION i011_chknob13()
   DEFINE l_t             LIKE type_file.num5
   DEFINE l_flag          LIKE type_file.num5
   DEFINE l_value         STRING
   
   LET l_flag = 0
   LET g_errno = ""
   IF cl_null(g_nob[l_ac].nob13) OR cl_null(g_nob[l_ac].nob09) THEN
      RETURN
   END IF 
   FOR l_t = 1 TO g_rec_b
       IF g_nob[l_ac].nob13 = g_nob[l_t].nob13 AND l_ac != l_t THEN
          LET l_flag = l_flag + 1
          IF l_flag > 1 OR g_nob[l_ac].nob09 = g_nob[l_t].nob09 THEN
             LET g_errno="anm1023"
             EXIT FOR
          END IF
          LET l_value = g_nob[l_ac].nob09
          IF g_nob[l_ac].nob09 MATCHES "</*"  THEN
             LET l_value = cl_replace_str(l_value,"</","<")
          ELSE
             LET l_value = cl_replace_str(l_value,"<","</")
          END IF
          IF l_value <> g_nob[l_t].nob09 THEN
             LET g_errno="anm1023"
             EXIT FOR
          END IF
        END IF
   END FOR
END FUNCTION

#複製
FUNCTION i011_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   

  IF p_cmd = 'a' THEN
     CALL cl_set_comp_entry("nob09",TRUE)
  ELSE 
     CALL i011_nob08_entry(g_nob[l_ac].nob08) 
     IF g_nob[l_ac].nob16 = 'Y' THEN
        CALL cl_set_comp_required("nob15,nob17,nob18",TRUE)
        CALL cl_set_comp_entry("nob17,nob18",TRUE) 
     END IF
     IF g_nob[l_ac].nob19 = 'Y' THEN
        CALL cl_set_comp_required("nob20",TRUE)
        CALL cl_set_comp_entry("nob20",TRUE) 
     END IF 
     IF g_nob[l_ac].nob21 = 'Y' THEN
        CALL cl_set_comp_required("nob22",TRUE)
        CALL cl_set_comp_entry("nob22",TRUE) 
     END IF   
  END IF
 
END FUNCTION
 
FUNCTION i011_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
  IF p_cmd = 'a' THEN
     CALL cl_set_comp_required("nob17,nob18,nob20,nob22",FALSE)
     CALL cl_set_comp_entry("nob10,nob11,nob12,nob17,nob18,nob20,nob22",FALSE)
  ELSE      
     IF g_nob[l_ac].nob16 = 'N' THEN
        CALL cl_set_comp_required("nob15,nob17,nob18",FALSE)
        CALL cl_set_comp_entry("nob17,nob18",FALSE) 
     END IF
     IF g_nob[l_ac].nob19 = 'N' THEN
        CALL cl_set_comp_required("nob20",FALSE)
        CALL cl_set_comp_entry("nob20",FALSE) 
     END IF 
     IF g_nob[l_ac].nob21 = 'N' THEN
        CALL cl_set_comp_required("nob22",FALSE)
        CALL cl_set_comp_entry("nob22",FALSE) 
     END IF    
  END IF
END FUNCTION

#複製
FUNCTION i011_copy()
   DEFINE l_noa01     LIKE noa_file.noa01,
          l_noa02     LIKE noa_file.noa02,
          l_noa05     LIKE noa_file.noa05,
          l_noa14     LIKE noa_file.noa14
   DEFINE l_noa01_old LIKE noa_file.noa01,
          l_noa02_old LIKE noa_file.noa02,
          l_noa05_old LIKE noa_file.noa05,
          l_noa14_old LIKE noa_file.noa14       
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_n         LIKE type_file.num5  
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_noa.noa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF    
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_noa01,l_noa05,l_noa02,l_noa14 FROM noa01,noa05,noa02,noa14
      BEFORE INPUT
         CALL cl_set_comp_entry("noa01,noa02,noa05,noa14",TRUE)
         IF g_noa.noa04 = '3' THEN
            LET l_noa05 = g_noa.noa05
            LET l_noa02 = g_noa.noa02
            LET l_noa14 = g_noa.noa14
         END IF
         
      AFTER FIELD noa01
         IF NOT cl_null(l_noa01) THEN
            CALL i011_noa01(l_noa01)                                                                                                  
            IF NOT cl_null(g_errno)  THEN                                                                                        
               CALL cl_err('',g_errno,0) 
               NEXT FIELD noa01                                                                                                  
            END IF
         END IF

      AFTER FIELD noa05
         IF NOT cl_null(l_noa05) THEN
            CALL i011_noa05(l_noa05)                                                                                                  
            IF NOT cl_null(g_errno)  THEN                                                                                        
               CALL cl_err('',g_errno,0) 
               NEXT FIELD noa05                                                                                                  
            END IF
         END IF  

      AFTER INPUT  
         LET l_n = 0     
         SELECT COUNT(*) INTO l_n FROM noa_file 
          WHERE noa01 = l_noa01   AND noa02 = l_noa02 
            AND noa05 = l_noa05   AND noa14 = l_noa14
            AND noa04 = g_noa.noa04
         IF l_n > 0 THEN
            CALL cl_err('','abm-644',0)
            NEXT FIELD noa01
         END IF      
       
      ON ACTION controlp
         CASE
           WHEN INFIELD(noa01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_noc"
              LET g_qryparam.default1= l_noa01
              CALL cl_create_qry() RETURNING l_noa01
              NEXT FIELD noa01 
           WHEN INFIELD(noa05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf"
              LET g_qryparam.arg1 = 'T'
              LET g_qryparam.default1= l_noa05
              CALL cl_create_qry() RETURNING l_noa05
              NEXT FIELD noa05    
           OTHERWISE 
              EXIT CASE
         END CASE     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION HELP          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask() 
        
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_noa.noa01,g_noa.noa02,g_noa.noa05,g_noa.noa14
      ROLLBACK WORK
      RETURN
   END IF

   BEGIN WORK
   DROP TABLE y 
   SELECT * FROM noa_file         #單頭複製
    WHERE noa01 = g_noa.noa01
      AND noa02 = g_noa.noa02
      AND noa04 = g_noa.noa04
      AND noa05 = g_noa.noa05
      AND noa14 = g_noa.noa14
     INTO TEMP y
 
   UPDATE y
      SET noa01 = l_noa01,    #新的鍵值
          noa02 = l_noa02,    #新的鍵值
          noa05 = l_noa05,    #新的鍵值
          noa13 = 'N',        #新的鍵值
          noa14 = l_noa14,    #新的鍵值
          noauser = g_user,   #資料所有者
          noagrup = g_grup,   #資料所有者所屬群
          noamodu = NULL,     #資料修改日期
          noadate = g_today,  #資料建立日期
          noaacti = 'Y'       #有效資料 
   INSERT INTO noa_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","noa_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN   
   END IF
 
   DROP TABLE x 
   SELECT * FROM nob_file         #單身複製
    WHERE nob01 = g_noa.noa01
      AND nob02 = g_noa.noa02
      AND nob04 = g_noa.noa04
      AND nob03 = g_noa.noa05
      AND nob24 = g_noa.noa14
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE x SET nob01 = l_noa01,    
                nob02 = l_noa02,   
                nob03 = l_noa05,   
                nob24 = l_noa14 
   INSERT INTO nob_file SELECT * FROM x       
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","nob_file","","",SQLCA.sqlcode,"","",1) #No.FUN-B80067---調整至回滾事務前--- 
      ROLLBACK WORK 
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_noa01,') O.K'
 
   LET l_noa01_old = g_noa.noa01 
   LET l_noa02_old = g_noa.noa02
   LET l_noa14_old = g_noa.noa14
   LET l_noa05_old = g_noa.noa05
   SELECT noa_file.* INTO g_noa.* FROM noa_file 
    WHERE noa01 = l_noa01
      AND noa02 = l_noa02
      AND noa04 = g_noa.noa04
      AND noa05 = l_noa05
      AND noa14 = l_noa14
   CALL i011_u()
   CALL i011_b()
   #FUN-C80046---begin
   #SELECT noa_file.* INTO g_noa.* FROM noa_file 
   # WHERE noa01 = l_noa01_old 
   #   AND noa02 = l_noa02_old 
   #   AND noa04 = g_noa.noa04
   #   AND noa05 = l_noa05_old 
   #   AND noa14 = l_noa14_old 
   #CALL i011_show() 
   #FUN-C80046---end
END FUNCTION
#FUN-B30213--end--
