# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aici001.4gl
# Descriptions...: ICD基本資料維護作業 
# Date & Author..: No.FUN-7B0015 07/11/13 By lilingyu
# Modify.........: No.FUN-830124 08/03/29 By lilingyu查詢出資料后，點擊更改按鈕，右邊ACTION消失
# Modify.........: No.FUN-850068 08/05/15 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-860115 08/06/30 By wujie    群組欄位后帶出相應的值 
# Modify.........: No.TQC-8C0052 09/01/15 By kim 欄位檢查
# Modify.........: No.TQC-920008 09/02/05 By chenyu icb79欄位后面的判斷有問題
# Modify.........: No.FUN-920114 09/02/23 By ve007 增加一個傳入參數
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940038 09/06/05 By dxfwo   無效資料可刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-980063 09/11/04 By jan 程式調整
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改:596
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30288 12/03/10 By bart 存檔時,請將icb05回寫回imaicd_file的imaicd14
# Modify.........: No.TQC-C40075 12/04/11 By xianghui 查詢時增加icboriu,icborig
# Modify.........: No.FUN-C50110 12/05/30 By bart 狀態0,1,2時才回寫gross die
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_icb       RECORD LIKE icb_file.*,
       g_icb_t     RECORD LIKE icb_file.*,   
       g_icb_o     RECORD LIKE icb_file.*,  
       g_icb01_t          LIKE icb_file.icb01
DEFINE g_wc                  STRING 
DEFINE g_sql                 STRING                 
DEFINE g_forupd_sql          STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5   
DEFINE g_chr                 LIKE type_file.chr1 
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10 
DEFINE g_jump                LIKE type_file.num10             
DEFINE g_no_ask              LIKE type_file.num5 
DEFINE g_argv1               LIKE icb_file.icb01
DEFINE g_argv2               LIKE imaicd_file.imaicd01            #No.FUN-920114
DEFINE g_argv3               LIKE imaicd_file.imaicd01            #No.MOD-C30288
DEFINE l_table               STRING
DEFINE g_str                 STRING  
DEFINE l_ice01               LIKE ice_file.ice01                  #No.FUN-920114
 
MAIN
   DEFINE l_cnt   LIKE type_file.num5    #MOD-C30288
   DEFINE l_sql   STRING                 #MOD-C30288
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT          
   
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)    #No.FUN-920114
 
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
   LET g_sql="icb01.icb_file.icb01,",                                                                               
             "imaicd01.imaicd_file.imaicd01,",                                                                           
             "icb02.icb_file.icb02,",                                                                               
             "icb79.icb_file.icb79,",                                                                               
             "icb04.icb_file.icb04,",                                                                               
             "icb05.icb_file.icb05,",                                                                               
             "icb09.icb_file.icb09,",                                                                               
             "icb09_desc.icd_file.icd03,",                                                                            
             "icb11.icb_file.icb11,",                                                                               
             "icb11_desc.pmc_file.pmc03,",                                                                            
             "icb12.icb_file.icb12,",                                                                               
             "icb12_desc.icd_file.icd03,",                                                                            
             "icb07.icb_file.icb07,",                                                                               
             "icb07_desc.icd_file.icd03,",                                                                            
             "icb06.icb_file.icb06,",                                                                              
             "icb08.icb_file.icb08,",                                                                               
             "icb08_desc.pmc_file.pmc03,",                                                                            
             "icb72.icb_file.icb72,",       
             "icb13.icb_file.icb13,",                                                                               
             "icb14.icb_file.icb14,",                                                                               
             "icb14_desc.icd_file.icd03,",                                                                            
             "icb15.icb_file.icb15,",                                                                               
             "icb15_desc.icd_file.icd03,",                                                                            
             "icb10.icb_file.icb10,",                                                                               
             "icb16.icb_file.icb16,",                                                                               
             "icb17.icb_file.icb17,",                                                                               
             "icb18.icb_file.icb18,",                                                                               
             "icb30.icb_file.icb30,",                                                                               
             "icb32.icb_file.icb32,",                                                                               
             "icb34.icb_file.icb34,",                                                                               
             "icb36.icb_file.icb36,",                                                                               
             "icb19.icb_file.icb19,",                                                                               
             "icb20.icb_file.icb20,",                                                                               
             "icb26.icb_file.icb26,",                                                                               
             "icb33.icb_file.icb33,",                                                                               
             "icb35.icb_file.icb35,",                                                                               
             "icb37.icb_file.icb37,",                                                                               
             "icb21.icb_file.icb21,",
             "icb22.icb_file.icb22,",                                                                               
             "icb23.icb_file.icb23,",                                                                               
             "icb24.icb_file.icb24,",                                                                               
             "icb25.icb_file.icb25"  
  
   LET l_table =cl_prt_temptable('aici001',g_sql) CLIPPED
   IF l_table  = -1 THEN EXIT PROGRAM END IF  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_forupd_sql = "SELECT * FROM icb_file WHERE icb01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i001_w WITH FORM "aic/42f/aici001"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

   IF NOT cl_null(g_argv2) OR NOT cl_null(g_argv1)   THEN       #No.FUN-920114
   #MOD-C30288---begin
      LET l_cnt = 0
      LET l_sql = "SELECT count(*)  FROM icb_file WHERE icb01 = '",g_argv1,"'" 
      PREPARE icb_cnt FROM l_sql 
      EXECUTE icb_cnt INTO l_cnt 
      IF l_cnt = 0 THEN
         CALL i001_a()
      ELSE  
   #MOD-C30288---end
      CALL i001_q()
      END IF      #MOD-C30288
   END IF
 
   LET g_action_choice = ""
   CALL i001_menu()
 
   CLOSE WINDOW i001_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i001_curs()
 
    CLEAR FORM
    IF cl_null(g_argv1) AND cl_null(g_argv2) THEN          #No.FUN-920114
       CONSTRUCT BY NAME g_wc ON  
                         icb01,icb02,icb79,icb04,
                         icb05,icb09,icb11,icb12,icb07,
                         icb06,icb08,icb72,icb13,
                         icb14,icb15,icb10,icb16,icb17,icb18,
                         icb30,icb32,icb34,icb36,
                         icb19,icb20,icb26,icb33,icb35,icb37,
			                   icb21,icb22,icb23,icb24,
                         icb25,icbuser,icbgrup,icbacti,
                         icbmodu,icbdate,icboriu,icborig,                #TQC-C40075  add icboriu,icborig
                         icbud01,icbud02,icbud03,icbud04,icbud05,
                         icbud06,icbud07,icbud08,icbud09,icbud10,
                         icbud11,icbud12,icbud13,icbud14,icbud15
 
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(icb01)
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.state = "c"
                 #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO icb01
                    NEXT FIELD icb01
 
                 WHEN INFIELD(icb02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ice1"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icb02
                    NEXT FIELD icb02
 
                 WHEN INFIELD(icb79)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_icc"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icb79
                    NEXT FIELD icb79
 
                 WHEN INFIELD(icb08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc1"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icb08
                    NEXT FIELD icb08
 
                 WHEN INFIELD(icb11)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc1" 
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icb11
                    NEXT FIELD icb11
 
                 WHEN INFIELD(icb07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_icd1"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "K"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icb07
                    NEXT FIELD icb07
 
                 WHEN INFIELD(icb09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_icd1"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "M"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icb09
                    NEXT FIELD icb09
 
                 WHEN INFIELD(icb12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_icd1"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "J"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icb12 
                    NEXT FIELD icb12
 
                 WHEN INFIELD(icb14)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_icd1"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "L"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icb14
                    NEXT FIELD icb14
 
                 WHEN INFIELD(icb15)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_icd1"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "N"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icb15
                    NEXT FIELD icb15
 
                 WHEN INFIELD(icbuser)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zx"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icbuser
                    NEXT FIELD icbuser
 
                 WHEN INFIELD(icbmodu)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zx"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icbmodu
                    NEXT FIELD icbmodu
 
                 WHEN INFIELD(icbgrup)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icbgrup
                    NEXT FIELD icbgrup
 
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
 
          ON ACTION qbe_select                                           
             CALL cl_qbe_select()                                         
 
          ON ACTION qbe_save                                             
             CALL cl_qbe_save()   
 
       END CONSTRUCT
       IF INT_FLAG THEN
          RETURN
       END IF
    ELSE
    	IF NOT cl_null(g_argv1) THEN 
    	  LET g_wc = "icb01 = '",g_argv1 CLIPPED,"'"
      	IF NOT cl_null(g_argv2) THEN 	 
    	     LET g_sql = "SELECT ice01  FROM ice_file WHERE ice02 = '",g_argv2,"'" 
    	     PREPARE ice_sel FROM g_sql 
    	     EXECUTE ice_sel INTO l_ice01 
           LET g_wc = g_wc CLIPPED," icb02 = '",l_ice01 CLIPPED,"'"
        END IF 
       ELSE 
       	IF NOT cl_null(g_argv2) THEN 	 
    	     LET g_sql = "SELECT ice01  FROM ice_file WHERE ice02 = '",g_argv2,"'"          
    	     PREPARE ice_sel1 FROM g_sql
    	     EXECUTE ice_sel1 INTO l_ice01
           LET g_wc = " icb02 = '",l_ice01 CLIPPED,"'" 
        END IF  
      END IF                              
    END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('icbuser', 'icbgrup')
 
    LET g_sql = "SELECT icb01 FROM icb_file ",
                " WHERE ",g_wc CLIPPED,
                " ORDER BY icb01"
 
    PREPARE i001_prepare FROM g_sql
    DECLARE i001_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i001_prepare
 
    LET g_sql = "SELECT COUNT(*) FROM icb_file WHERE ",g_wc CLIPPED
    PREPARE i001_precount FROM g_sql
    DECLARE i001_count CURSOR FOR i001_precount
END FUNCTION
 
FUNCTION i001_menu()
    DEFINE  l_msg          LIKE type_file.chr1000
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index,g_row_count)
           CALL cl_set_act_visible("role1,role2,role3,role4,role5,role6,role7",TRUE)
        
        ON ACTION WAFER
           CALL cl_set_act_visible("role1,role2,role3,role4,role5,role6,role7",TRUE)
         
        ON ACTION CP
           CALL cl_set_act_visible("role1,role2,role3,role4,role5,role6,role7",TRUE)
 
        ON ACTION INFO
           CALL cl_set_act_visible("role1,role2,role3,role4,role5,role6,role7",TRUE)
 
 
        ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL i001_a()
           END IF
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL i001_q()
           END IF
 
        ON ACTION next
           CALL i001_fetch('N')
 
        ON ACTION previous
           CALL i001_fetch('P')
 
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i001_u()
           END IF
   
        ON ACTION output  
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
              CALL i001_out()
           END IF
   
        ON ACTION invalid
           LET g_action_choice="invalid"
           IF cl_chk_act_auth() THEN
              CALL i001_x()
           END IF
 
        ON ACTION delete
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
              CALL i001_r()
           END IF
 
        ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
              CALL i001_copy()
           END IF

        ON ACTION role1
           LET g_action_choice="role1"
           IF cl_chk_act_auth() THEN
           IF NOT cl_null(g_icb.icb01) THEN
              LET l_msg = "aici012 '",g_icb.icb01 CLIPPED,"'"
              CALL cl_cmdrun_wait(l_msg)
           ELSE
              CALL cl_err('',-400,1)
           END IF
           END IF   
           
         ON ACTION role2
           LET g_action_choice="role2"
           IF cl_chk_act_auth() THEN
           IF NOT cl_null(g_icb.icb01) THEN
              LET l_msg = "aici013 '",g_icb.icb01 CLIPPED,"'"
              CALL cl_cmdrun_wait(l_msg)
           ELSE
              CALL cl_err('',-400,1)
           END IF
           END IF   
           
         ON ACTION role3
           LET g_action_choice="role3"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_icb.icb01) THEN
                 LET l_msg = "aici006 '",g_icb.icb01 CLIPPED,"'"
                 CALL cl_cmdrun_wait(l_msg)
              ELSE
                CALL cl_err('',-400,1)
              END IF
           END IF
           
          ON ACTION role4
           LET g_action_choice="role4"
           IF cl_chk_act_auth() THEN
           IF NOT cl_null(g_icb.icb01) THEN
              LET l_msg = "aici010 '",g_icb.icb01 CLIPPED,"'"
              CALL cl_cmdrun_wait(l_msg)
           ELSE
              CALL cl_err('',-400,1)
           END IF
           END IF  
           
          ON ACTION role5
           LET g_action_choice="role5"
           IF cl_chk_act_auth() THEN
           LET l_msg = "aici003" 
           CALL cl_cmdrun_wait(l_msg)
           END IF
           
           ON ACTION role6
           LET g_action_choice="role6"
           IF cl_chk_act_auth() THEN
           IF NOT cl_null(g_icb.icb01) THEN     
               LET l_msg = "aici004  '",g_icb.icb01 CLIPPED,"'"  
               CALL cl_cmdrun_wait(l_msg)
           ELSE
              CALL cl_err('',-400,1)
           END IF
           END IF 
           
           ON ACTION role7
           LET g_action_choice="role7"
           IF cl_chk_act_auth() THEN
           IF NOT cl_null(g_icb.icb01) THEN
              LET l_msg = "aici008 '",g_icb.icb01 CLIPPED,"'"
              CALL cl_cmdrun_wait(l_msg)
           ELSE
              CALL cl_err('',-400,1)
           END IF
           END IF            
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i001_fetch('/')
 
        ON ACTION first
           CALL i001_fetch('F')
 
        ON ACTION last
           CALL i001_fetch('L')
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont() 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about 
           CALL cl_about() 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG = FALSE 
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document 
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_icb.icb01) THEN
                 LET g_doc.column1 = "icb01"
                 LET g_doc.value1 = g_icb.icb01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE i001_cs
END FUNCTION
 
FUNCTION i001_a()
    MESSAGE ""
    CLEAR FORM    
    INITIALIZE g_icb.* LIKE icb_file.*
    LET g_icb.icb05 = 1
    LET g_icb.icb06 = '1' 
    LET g_icb.icb24 = '1'
    LET g_icb.icb30 = 'N'
    INITIALIZE g_icb_t.* LIKE icb_file.*
    INITIALIZE g_icb_o.* LIKE icb_file.*
    LET g_icb01_t = NULL
    LET g_wc = NULL
    #MOD-C30288---begin
    IF NOT cl_null(g_argv1) THEN
       LET g_icb.icb01 = g_argv1
       SELECT imaicd14 INTO g_icb.icb05 FROM imaicd_file WHERE imaicd01 = g_argv1
    END IF 
    #MOD-C30288---end
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_icb.icbuser = g_user
        LET g_icb.icboriu = g_user #FUN-980030
        LET g_icb.icborig = g_grup #FUN-980030
        LET g_icb.icbgrup = g_grup 
        LET g_icb.icbdate = g_today
        LET g_icb.icbacti = 'Y'
        CALL i001_i("a")    
        IF INT_FLAG THEN  
           LET INT_FLAG = 0
           INITIALIZE g_icb.* TO NULL
           LET g_icb01_t = NULL
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF cl_null(g_icb.icb01) THEN    
           CONTINUE WHILE
        END IF
        INSERT INTO icb_file VALUES(g_icb.*) 
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_icb.icb01,SQLCA.SQLCODE,0)
           CONTINUE WHILE
        ELSE
           SELECT icb01 INTO g_icb.icb01 FROM icb_file
            WHERE icb01 = g_icb.icb01
           #MOD-C30288---begin
              IF NOT cl_null(g_icb.icb05) THEN 
                 UPDATE imaicd_file SET imaicd14 = g_icb.icb05
                 WHERE imaicd00 = g_icb.icb01
                   AND imaicd04 IN ('0','1','2')  #FUN-C50110
                 IF SQLCA.SQLCODE THEN 
                    CALL cl_err(g_icb.icb01,SQLCA.SQLCODE,0)
                 END IF 
              END IF 
           #MOD-C30288---end 
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc = NULL
END FUNCTION
 
FUNCTION i001_i(p_cmd)
DEFINE   p_cmd      LIKE type_file.chr1 
DEFINE   l_cnt      LIKE type_file.num5 
 
   INPUT BY NAME g_icb.icb01,g_icb.icb02,                       g_icb.icboriu,g_icb.icborig,
                 g_icb.icb79,                      
                 g_icb.icb04,g_icb.icb05,                      
                 g_icb.icb09,g_icb.icb11,                      
                 g_icb.icb12,g_icb.icb07,                      
                 g_icb.icb06,g_icb.icb08,                      
                 g_icb.icb72,                      
                 g_icb.icb13,g_icb.icb14,                      
                 g_icb.icb15,g_icb.icb10,g_icb.icb16,                      
                 g_icb.icb17,g_icb.icb18,                      
                 g_icb.icb30,g_icb.icb32,                      
                 g_icb.icb34,g_icb.icb36,                      
                 g_icb.icb19,                      
                 g_icb.icb20,g_icb.icb26,g_icb.icb33,                      
                 g_icb.icb35,g_icb.icb37,
		 g_icb.icb21,g_icb.icb22,                      
                 g_icb.icb23,g_icb.icb24,                      
                 g_icb.icb25,                      
                 g_icb.icbuser,g_icb.icbgrup,                    
                 g_icb.icbacti,g_icb.icbmodu,                    
                 g_icb.icbdate,                         
                 g_icb.icbud01,g_icb.icbud02,g_icb.icbud03,g_icb.icbud04,
                 g_icb.icbud05,g_icb.icbud06,g_icb.icbud07,g_icb.icbud08,
                 g_icb.icbud09,g_icb.icbud10,g_icb.icbud11,g_icb.icbud12,
                 g_icb.icbud13,g_icb.icbud14,g_icb.icbud15 
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i001_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD icb01
         IF NOT cl_null(g_icb.icb01) THEN
           #MOD-C30288---begin mark
           #FUN-AA0059 --------------add start---------------
           # IF NOT s_chk_item_no(g_icb.icb01,'') THEN
           #    CALL cl_err('',g_errno,1)
           #    LET g_icb.icb01 = g_icb_t.icb01
           #    DISPLAY BY NAME g_icb.icb01
           #    NEXT FIELD icb01
           # END IF 
           #FUN-AA0059 ---------------add end-------------
           #MOD-C30288---end mark
           #MOD-C30288---begin
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = g_icb.icb01
           IF l_cnt = 0 THEN
              CALL cl_err('','mfg0002',1)
              LET g_icb.icb01 = g_icb_t.icb01
              DISPLAY BY NAME g_icb.icb01
              NEXT FIELD icb01
           END IF 
           #MOD-C30288---end
            CALL i001_icb01_chk(g_icb.icb01,'a')

            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_icb.icb01,g_errno,0)
               LET g_icb.icb01 = g_icb_t.icb01
               DISPLAY BY NAME g_icb.icb01
               NEXT FIELD icb01
            END IF

            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_icb.icb01 != g_icb_t.icb01) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM icb_file
                WHERE icb01 = g_icb.icb01
               IF l_cnt > 0 THEN
                  CALL cl_err(g_icb.icb01,-239,0)
                  LET g_icb.icb01 = g_icb_t.icb01
                  DISPLAY BY NAME g_icb.icb01
                  NEXT FIELD icb01
               END IF
               CALL i001_icb01_chk(g_icb.icb01,'d')
            END IF
         ELSE
            DISPLAY ' ' TO FORMONLY.imaicd01
         END IF
 
      AFTER FIELD icb07
        IF NOT cl_null(g_icb.icb07) THEN
           CALL i001_icd_chk(g_icb.icb07,'K') 
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icb.icb07,g_errno,1)
              LET g_icb.icb07 = g_icb_t.icb07
              DISPLAY BY NAME g_icb.icb07
              DISPLAY ' ' TO FORMONLY.icb07_desc
              NEXT FIELD icb07
           END IF
        END IF
        CALL i001_field_xxx()
 
    
      AFTER FIELD icb09    
        IF NOT cl_null(g_icb.icb09) THEN
           CALL i001_icd_chk(g_icb.icb09,'M')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icb.icb09,g_errno,1)
              LET g_icb.icb09 = g_icb_t.icb09              
              DISPLAY BY NAME g_icb.icb09
              DISPLAY ' ' TO FORMONLY.icb09_desc
              NEXT FIELD icb09
           END IF
        END IF
        CALL i001_field_xxx()
    
       AFTER FIELD icb12
         IF NOT cl_null(g_icb.icb12) THEN
           CALL i001_icd_chk(g_icb.icb12,'J')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icb.icb12,g_errno,1)
              LET g_icb.icb12 = g_icb_t.icb12
              DISPLAY BY NAME g_icb.icb12
              DISPLAY ' ' TO FORMONLY.icb12_desc
              NEXT FIELD icb12
           END IF
        END IF
        CALL i001_field_xxx()
 
      AFTER FIELD icb14
        IF NOT cl_null(g_icb.icb14) THEN
           CALL i001_icd_chk(g_icb.icb14,'L')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icb.icb14,g_errno,1)
              LET g_icb.icb14 = g_icb_t.icb14
              DISPLAY BY NAME g_icb.icb14
              DISPLAY ' ' TO FORMONLY.icb14_desc
              NEXT FIELD icb14
           END IF
        END IF
        CALL i001_field_xxx()
 
      AFTER FIELD icb15
        IF NOT cl_null(g_icb.icb15) THEN
           CALL i001_icd_chk(g_icb.icb15,'N')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icb.icb15,g_errno,1)
              LET g_icb.icb15 = g_icb_t.icb15
              DISPLAY BY NAME g_icb.icb15
              DISPLAY ' ' TO FORMONLY.icb15_desc
              NEXT FIELD icb15
           END IF
        END IF
        CALL i001_field_xxx()
 
      AFTER FIELD icb06
        IF NOT cl_null(g_icb.icb06) THEN
           IF g_icb.icb06 NOT MATCHES '[12]' THEN
              NEXT FIELD icb06
           END IF
        END IF
 
      AFTER FIELD icb24
        IF NOT cl_null(g_icb.icb24) THEN
           IF g_icb.icb24 NOT MATCHES '[1234]' THEN
              NEXT FIELD icb24
           END IF
        END IF
 
      AFTER FIELD icb30
        IF NOT cl_null(g_icb.icb30) THEN
           IF g_icb.icb30 NOT MATCHES '[YN]' THEN
              NEXT FIELD icb30
           END IF
        END IF
      
      AFTER FIELD icb04
        IF NOT cl_null(g_icb.icb04) THEN
           IF g_icb.icb04 < 0 THEN
              CALL cl_err(g_icb.icb04,'aic-043',0)
              LET g_icb.icb04 = g_icb_t.icb04
              DISPLAY BY NAME g_icb.icb04
              NEXT FIELD icb04
           END IF
        END IF
 
      AFTER FIELD icb05
        IF NOT cl_null(g_icb.icb05) THEN
           IF g_icb.icb05 < 0 THEN
              CALL cl_err(g_icb.icb05,'aic-043',0)
              LET g_icb.icb05 = g_icb_t.icb05
              DISPLAY BY NAME g_icb.icb05
              NEXT FIELD icb05
           END IF
        END IF
      
      AFTER FIELD icb16
        IF NOT cl_null(g_icb.icb16) THEN
           IF g_icb.icb16 < 0 THEN
              CALL cl_err(g_icb.icb16,'aic-043',0)
              LET g_icb.icb16 = g_icb_t.icb16
              DISPLAY BY NAME g_icb.icb16
              NEXT FIELD icb16
           END IF
        END IF
 
      AFTER FIELD icb17
        IF NOT cl_null(g_icb.icb17) THEN
           IF g_icb.icb17 < 0 THEN
              CALL cl_err(g_icb.icb17,'aic-043',0)
              LET g_icb.icb17 = g_icb_t.icb17
              DISPLAY BY NAME g_icb.icb17
              NEXT FIELD icb17
           END IF
        END IF
 
      AFTER FIELD icb18
        IF NOT cl_null(g_icb.icb18) THEN
           IF g_icb.icb18 < 0 THEN
              CALL cl_err(g_icb.icb18,'aic-043',0)
              LET g_icb.icb18 = g_icb_t.icb18
              DISPLAY BY NAME g_icb.icb18
              NEXT FIELD icb18
           END IF
        END IF
 
      AFTER FIELD icb19
        IF NOT cl_null(g_icb.icb19) THEN
           IF g_icb.icb19 < 0 THEN
              CALL cl_err(g_icb.icb19,'aic-043',0)
              LET g_icb.icb19 = g_icb_t.icb19
              DISPLAY BY NAME g_icb.icb19
              NEXT FIELD icb19
           END IF
        END IF
 
      AFTER FIELD icb20
        IF NOT cl_null(g_icb.icb20) THEN
           IF g_icb.icb20 < 0 THEN
              CALL cl_err(g_icb.icb20,'aic-043',0)
              LET g_icb.icb20 = g_icb_t.icb20
              DISPLAY BY NAME g_icb.icb20
              NEXT FIELD icb20
           END IF
        END IF
 
      AFTER FIELD icb26
        IF NOT cl_null(g_icb.icb26) THEN
           IF g_icb.icb26 < 0 THEN
              CALL cl_err(g_icb.icb26,'aic-043',0)
              LET g_icb.icb26 = g_icb_t.icb26
              DISPLAY BY NAME g_icb.icb26
              NEXT FIELD icb26
           END IF
        END IF
 
      AFTER FIELD icb08
        IF NOT cl_null(g_icb.icb08) THEN
           CALL i001_pmc_chk(g_icb.icb08,g_icb.icb01,'1','a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icb.icb08,g_errno,0)
              LET g_icb.icb08 = g_icb_t.icb08
              DISPLAY BY NAME g_icb.icb08 
              NEXT FIELD icb08
           END IF
        ELSE
           DISPLAY ' ' TO FORMONLY.icb08_desc
        END IF
 
      AFTER FIELD icb11
        IF NOT cl_null(g_icb.icb11) THEN
           CALL i001_pmc_chk(g_icb.icb11,g_icb.icb01,'2','a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icb.icb11,g_errno,0)
              LET g_icb.icb11 = g_icb_t.icb11
              DISPLAY BY NAME g_icb.icb11 
              NEXT FIELD icb11
           END IF
        ELSE
           DISPLAY ' ' TO FORMONLY.icb11_desc
        END IF
 
      AFTER FIELD icb02
        IF NOT cl_null(g_icb.icb02) THEN
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM ice_file
            WHERE ice01 = g_icb.icb02
           IF l_cnt = 0 THEN
              CALL cl_err(g_icb.icb02,'aic-044',0)
              LET g_icb.icb02 = g_icb_t.icb02
              DISPLAY BY NAME g_icb.icb02
              NEXT FIELD icb02
           END IF
        END IF
 
      AFTER FIELD icb79
        IF NOT cl_null(g_icb.icb79)                                          #No.TQC-920008 add
           AND (g_icb.icb79 <> g_icb_t.icb79 OR g_icb_t.icb79 IS NULL) THEN  #No.TQC-920008 add
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM icc_file
            WHERE icc01 = g_icb.icb79
              AND iccacti = 'Y'
           IF l_cnt = 0 THEN
              CALL cl_err(g_icb.icb79,'aic-044',0)
              LET g_icb.icb79 = g_icb_o.icb79
              DISPLAY BY NAME g_icb.icb79
              NEXT FIELD icb79
           END IF
           CALL i001_icb79()       #No.FUN-860115
        END IF
        LET g_icb_o.icb79 = g_icb.icb79
 
      AFTER FIELD icbud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icbud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER INPUT
         LET g_icb.icbuser = s_get_data_owner("icb_file") #FUN-C10039
         LET g_icb.icbgrup = s_get_data_group("icb_file") #FUN-C10039
        IF INT_FLAG THEN
           EXIT INPUT
        END IF
 
        IF NOT cl_null(g_icb.icb08) THEN
              CALL i001_pmc_chk(g_icb.icb08,g_icb.icb01,'1','a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_icb.icb08,g_errno,0)
                 NEXT FIELD icb08
              END IF
        END IF
      
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(icb01)
#FUN-AA0059 --Begin--
          #  CALL cl_init_qry_var()
          #  LET g_qryparam.form = "q_ima"  
          #  LET g_qryparam.default1 = g_icb.icb01
          #  CALL cl_create_qry() RETURNING g_icb.icb01
            CALL q_sel_ima(FALSE, "q_ima", "", g_icb.icb01, "", "", "", "" ,"",'' )  RETURNING g_icb.icb01
#FUN-AA0059 --End--
            DISPLAY BY NAME g_icb.icb01
            NEXT FIELD icb01
 
          WHEN INFIELD(icb02)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ice1"
            LET g_qryparam.default1 = g_icb.icb02
            CALL cl_create_qry() RETURNING g_icb.icb02
            DISPLAY BY NAME g_icb.icb02
            NEXT FIELD icb02
 
          WHEN INFIELD(icb79)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icc"
            LET g_qryparam.default1 = g_icb.icb79
            CALL cl_create_qry() RETURNING g_icb.icb79
            DISPLAY BY NAME g_icb.icb79
            NEXT FIELD icb79
          
          WHEN INFIELD(icb08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc1"
               LET g_qryparam.default1 = g_icb.icb08
               CALL cl_create_qry() RETURNING g_icb.icb08
               DISPLAY BY NAME g_icb.icb08
               NEXT FIELD icb08
 
          WHEN INFIELD(icb11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc1"
               LET g_qryparam.default1 = g_icb.icb11
               CALL cl_create_qry() RETURNING g_icb.icb11
               DISPLAY BY NAME g_icb.icb11
               NEXT FIELD icb11
 
          WHEN INFIELD(icb07)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icd1"
            LET g_qryparam.arg1 = "K"
            LET g_qryparam.default1 = g_icb.icb07
            CALL cl_create_qry() RETURNING g_icb.icb07
            DISPLAY BY NAME g_icb.icb07
            NEXT FIELD icb07
 
          WHEN INFIELD(icb09)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icd1"
            LET g_qryparam.arg1 = "M"
            LET g_qryparam.default1 = g_icb.icb09
            CALL cl_create_qry() RETURNING g_icb.icb09
            DISPLAY BY NAME g_icb.icb09
            NEXT FIELD icb09
 
          WHEN INFIELD(icb12)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icd1"
            LET g_qryparam.arg1 = "J"
            LET g_qryparam.default1 = g_icb.icb12
            CALL cl_create_qry() RETURNING g_icb.icb12
            DISPLAY BY NAME g_icb.icb12
            NEXT FIELD icb12
 
          WHEN INFIELD(icb14)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icd1"
            LET g_qryparam.arg1 = "L"
            LET g_qryparam.default1 = g_icb.icb14
            CALL cl_create_qry() RETURNING g_icb.icb14
            DISPLAY BY NAME g_icb.icb14
            NEXT FIELD icb14
 
          WHEN INFIELD(icb15)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icd1"
            LET g_qryparam.arg1 = "N"
            LET g_qryparam.default1 = g_icb.icb15
            CALL cl_create_qry() RETURNING g_icb.icb15
            DISPLAY BY NAME g_icb.icb15
            NEXT FIELD icb15
 
          OTHERWISE
            EXIT CASE
        END CASE
 
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
END FUNCTION
 
FUNCTION i001_icb01_chk(p_key,p_cmd)
DEFINE p_key        LIKE ima_file.ima01
DEFINE p_cmd        LIKE type_file.chr1     
DEFINE l_imaicd01   LIKE imaicd_file.imaicd01
DEFINE l_imaacti    LIKE ima_file.imaacti
DEFINE l_ima01      LIKE ima_file.ima01
 
   LET g_errno = ''
   
    SELECT ima01,imaacti INTO l_ima01,l_imaacti
      FROM ima_file  WHERE ima01 = p_key      
       
   IF p_cmd = 'a' THEN
      CASE
        WHEN SQLCA.SQLCODE = 100   LET g_errno = 'aic-045'
        WHEN l_imaacti = 'N'       LET g_errno = 'aic-046'
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '------'
      END CASE
   END IF
   
   IF p_cmd = 'd' OR cl_null(g_errno) THEN 
       LET l_imaacti = ''
      SELECT imaicd01,imaacti INTO l_imaicd01,l_imaacti
        FROM ima_file,imaicd_file
       WHERE ima01 = p_key
         AND ima01=imaicd00 
      IF l_imaacti IS NOT NULL THEN  #FUN-980063
           DISPLAY l_imaicd01 TO FORMONLY.imaicd01
       ELSE 
           DISPLAY ' ' TO FORMONLY.imaicd01
       END IF	         
   END IF
 
END FUNCTION
 
FUNCTION i001_icd_chk(p_key,p_kind)
DEFINE p_key      LIKE icd_file.icd01
DEFINE p_kind     LIKE icd_file.icd02
DEFINE l_icd02    LIKE icd_file.icd02
DEFINE l_icdacti  LIKE icd_file.icdacti
 
  LET g_errno = ''
 
  SELECT icd02,icdacti
    INTO l_icd02,l_icdacti
    FROM icd_file
   WHERE icd01 = p_key
     AND icd02 = p_kind  #TQC-8C0052
 
  CASE
    WHEN SQLCA.SQLCODE = 100   LET g_errno = 'aic-049'
    WHEN l_icd02 != p_kind     LET g_errno = 'aic-048'
    WHEN l_icdacti = 'N'       LET g_errno = 'aic-046'
    OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '------'
  END CASE
 
END FUNCTION
 
FUNCTION i001_pmc_chk(p_key1,p_key2,p_ary,p_cmd)
DEFINE p_key1      LIKE pmc_file.pmc01
DEFINE p_key2      LIKE ima_file.ima01
DEFINE p_ary       LIKE type_file.chr1
DEFINE p_cmd       LIKE type_file.chr1 
DEFINE l_pmc03     LIKE pmc_file.pmc03
DEFINE l_pmc30     LIKE pmc_file.pmc30
DEFINE l_pmcacti   LIKE pmc_file.pmcacti
DEFINE l_cnt       LIKE type_file.num5        
 
   LET g_errno = ''
 
   SELECT pmc03,pmc30,pmcacti
     INTO l_pmc03,l_pmc30,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = p_key1
 
   IF p_cmd = 'a' THEN
      CASE
        WHEN SQLCA.SQLCODE = 100        LET g_errno = 'aic-050'
        WHEN l_pmc30 NOT MATCHES '[13]' LET g_errno = 'aic-051'
        WHEN l_pmcacti = 'N'            LET g_errno = 'aic-046'
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '------'
      END CASE 
 
 
      IF cl_null(g_errno) AND p_ary = '1' THEN    
         IF NOT cl_null(p_key2) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
              FROM icg_file
             WHERE icg01 = p_key2 
               AND icg03 = p_key1
               AND icgacti = 'Y'
            IF l_cnt = 0 THEN
            END IF
          END IF
       END IF
    END IF
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_ary = '1' THEN
         DISPLAY l_pmc03 TO FORMONLY.icb08_desc
      ELSE
         DISPLAY l_pmc03 TO FORMONLY.icb11_desc
      END IF
   END IF
END FUNCTION
 
FUNCTION i001_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_icb.* TO NULL
    INITIALIZE g_icb_t.* TO NULL
    INITIALIZE g_icb_o.* TO NULL
    
    LET g_icb01_t = NULL
    LET g_wc = NULL
    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cn2
    
    CALL i001_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_icb.* TO NULL
       LET g_icb01_t = NULL
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN i001_count
    FETCH i001_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cn2
    OPEN i001_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icb.icb01,SQLCA.sqlcode,0)
       INITIALIZE g_icb.* TO NULL
       LET g_icb01_t = NULL
       LET g_wc = NULL
    ELSE
       CALL i001_fetch('F')  
    END IF
END FUNCTION
 
FUNCTION i001_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     i001_cs INTO g_icb.icb01
        WHEN 'P' FETCH PREVIOUS i001_cs INTO g_icb.icb01
        WHEN 'F' FETCH FIRST    i001_cs INTO g_icb.icb01
        WHEN 'L' FETCH LAST     i001_cs INTO g_icb.icb01
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
            FETCH ABSOLUTE g_jump i001_cs INTO g_icb.icb01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icb.icb01,SQLCA.sqlcode,0)
       INITIALIZE g_icb.* TO NULL
       LET g_icb01_t = NULL
       RETURN
    ELSE
      CASE p_icb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
    END IF
 
    SELECT * INTO g_icb.* FROM icb_file  
     WHERE icb01 = g_icb.icb01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icb.icb01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_icb.icbuser 
       LET g_data_group = g_icb.icbgrup
       CALL i001_show() 
    END IF
END FUNCTION
 
FUNCTION i001_show()
    LET g_icb_t.* = g_icb.*
    LET g_icb_o.* = g_icb.*
    DISPLAY BY NAME g_icb.icb01,g_icb.icb02, g_icb.icboriu,g_icb.icborig,
                    g_icb.icb79,
                    g_icb.icb04,g_icb.icb05,
                    g_icb.icb09,g_icb.icb11,
                    g_icb.icb12,g_icb.icb07,
                    g_icb.icb06,g_icb.icb08,
                    g_icb.icb72,
                    g_icb.icb13,g_icb.icb14,
                    g_icb.icb15,g_icb.icb10,g_icb.icb16,
                    g_icb.icb17,g_icb.icb18,
                    g_icb.icb30,g_icb.icb32,
                    g_icb.icb34,g_icb.icb36,
                    g_icb.icb19,
                    g_icb.icb20,g_icb.icb26,g_icb.icb33,
                    g_icb.icb35,g_icb.icb37,
		    g_icb.icb21,g_icb.icb22,
                    g_icb.icb23,g_icb.icb24,
                    g_icb.icb25,
                    g_icb.icbuser,g_icb.icbgrup,
                    g_icb.icbacti,g_icb.icbmodu,
                    g_icb.icbdate, 
                    g_icb.icbud01,g_icb.icbud02,g_icb.icbud03,g_icb.icbud04,
                    g_icb.icbud05,g_icb.icbud06,g_icb.icbud07,g_icb.icbud08,
                    g_icb.icbud09,g_icb.icbud10,g_icb.icbud11,g_icb.icbud12,
                    g_icb.icbud13,g_icb.icbud14,g_icb.icbud15 
    CALL i001_icb01_chk(g_icb.icb01,'d')
    CALL i001_pmc_chk(g_icb.icb08,g_icb.icb01,'1','d')
    CALL i001_pmc_chk(g_icb.icb11,g_icb.icb01,'2','d')
    CALL cl_show_fld_cont()
    CALL i001_field_xxx()
END FUNCTION
 
FUNCTION i001_u()
    IF cl_null(g_icb.icb01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_icb.* FROM icb_file WHERE icb01=g_icb.icb01
 
    IF g_icb.icbacti = 'N' THEN
       CALL cl_err(g_icb.icb01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_icb01_t = g_icb.icb01
    BEGIN WORK
 
    OPEN i001_cl USING g_icb.icb01
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:",STATUS,1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_icb.*  
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icb.icb01,SQLCA.sqlcode,1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    LET g_icb.icbmodu = g_user  
    LET g_icb.icbdate = g_today 
    CALL i001_show()                 
    WHILE TRUE
        CALL i001_i("u")          
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_icb.*=g_icb_t.*
           CALL i001_show()
           CALL cl_err('',9001,0)
           CALL cl_set_act_visible("role1,role2,role3,role4,role5,role6,role7",TRUE)
           EXIT WHILE
        END IF
  #_q()出資料后,點擊狀態頁簽,再選擇_u()，顯示右邊的ACTION按鈕     
       CALL cl_set_act_visible("role1,role2,role3,role4,role5,role6,role7",TRUE)
       UPDATE icb_file SET icb_file.* = g_icb.*
         WHERE icb01 = g_icb.icb01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_icb.icb01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        #MOD-C30288---begin
        IF NOT cl_null(g_icb.icb05) THEN 
            UPDATE imaicd_file SET imaicd14 = g_icb.icb05
             WHERE imaicd00 = g_icb.icb01
               AND imaicd04 IN ('0','1','2')  #FUN-C50110
            IF SQLCA.SQLCODE THEN 
                CALL cl_err(g_icb.icb01,SQLCA.SQLCODE,0)
            END IF 
        END IF 
        #MOD-C30288---end
        EXIT WHILE
    END WHILE
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_x()
    IF cl_null(g_icb.icb01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i001_cl USING g_icb.icb01
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:",STATUS,1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_icb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icb.icb01,SQLCA.sqlcode,1)
       CLOSE i001_cl
       ROLLBACK WORK  
       RETURN
    END IF
    CALL i001_show()
    IF cl_exp(0,0,g_icb.icbacti) THEN
       LET g_chr=g_icb.icbacti
       IF g_icb.icbacti='Y' THEN
          LET g_icb.icbacti='N'
       ELSE
          LET g_icb.icbacti='Y'
       END IF
       UPDATE icb_file SET icbacti = g_icb.icbacti
        WHERE icb01 = g_icb.icb01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(g_icb.icb01,SQLCA.sqlcode,0)
          LET g_icb.icbacti = g_chr
          DISPLAY BY NAME g_icb.icbacti
          CLOSE i001_cl
          ROLLBACK WORK
          RETURN 
       END IF
       DISPLAY BY NAME g_icb.icbacti
    END IF
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_r()
    IF cl_null(g_icb.icb01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    IF g_icb.icbacti = 'N' THEN                                                                                                     
       CALL cl_err('','abm-950',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
 
    BEGIN WORK
 
    OPEN i001_cl USING g_icb.icb01
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:",STATUS,0)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_icb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icb.icb01,SQLCA.sqlcode,0)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i001_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "icb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_icb.icb01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM icb_file WHERE icb01 = g_icb.icb01
       CLEAR FORM
       OPEN i001_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i001_cs
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i001_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i001_cs
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cn2
       OPEN i001_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i001_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i001_fetch('/')
       END IF
    END IF
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_copy()
DEFINE l_newno   LIKE icb_file.icb01
DEFINE l_oldno   LIKE icb_file.icb01
DEFINE l_cnt     LIKE type_file.num5
 
    IF cl_null(g_icb.icb01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i001_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM icb01
 
        AFTER FIELD icb01
           IF NOT cl_null(l_newno) THEN
             #MOD-C30288---begin mark
             #FUN-AA0059 -------------------add start------------
             # IF NOT s_chk_item_no(l_newno,'') THEN
             #    CALL cl_err('',g_errno,1)
             #    LET l_newno = NULL
             #    DISPLAY l_newno TO icb01
             #    NEXT FIELD icb01
             # END IF 
             #FUN-AA0059 --------------------add end---------------  
             #MOD-C30288---end mark
             #MOD-C30288---begin
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = l_newno
             IF l_cnt = 0 THEN
                CALL cl_err('','mfg0002',1)
                LET l_newno = NULL 
                DISPLAY l_newno TO icb01
                NEXT FIELD icb01
             END IF 
             #MOD-C30288---end
              CALL i001_icb01_chk(l_newno,'a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_newno,g_errno,0)
                 LET l_newno = NULL
                 DISPLAY l_newno TO icb01
                 NEXT FIELD icb01
              END IF
              LET g_cnt = 0
              SELECT COUNT(*) INTO g_cnt FROM icb_file
               WHERE icb01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                 LET l_newno = NULL
                 DISPLAY l_newno TO icb01
                 NEXT FIELD icb01
              END IF
           ELSE
              DISPLAY ' ' TO FORMONLY.imaicd01
           END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
 
        IF NOT cl_null(g_icb.icb08) THEN
           CALL i001_pmc_chk(g_icb.icb08,l_newno,'1','a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icb.icb08,g_errno,0)
              NEXT FIELD icb01
           END IF
        END IF
        
       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(icb01)
#FUN-AA0059 --Begin--
             # CALL cl_init_qry_var()
             # LET g_qryparam.form = "q_ima"
             # LET g_qryparam.default1 = l_newno
             # CALL cl_create_qry() RETURNING l_newno
              CALL q_sel_ima(FALSE, "q_ima", "", l_newno, "", "", "", "" ,"",'' )  RETURNING l_newno
#FUN-AA0059 --End--
              DISPLAY l_newno TO icb01
              NEXT FIELD icb01
 
            OTHERWISE
              EXIT CASE
          END CASE
           
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION about 
          CALL cl_about() 
 
       ON ACTION help 
          CALL cl_show_help() 
  
       ON ACTION controlg 
          CALL cl_cmdask() 
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_icb.icb01
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM icb_file
     WHERE icb01 = g_icb.icb01
      INTO TEMP x
    UPDATE x
        SET icb01=l_newno,  
            icbacti='Y',     
            icbuser=g_user, 
            icbgrup=g_grup, 
            icbmodu=NULL, 
            icbdate=g_today  
    INSERT INTO icb_file SELECT * FROM x
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err(l_newno,SQLCA.sqlcode,0)
    ELSE
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_icb.icb01
       LET g_icb.icb01 = l_newno
       SELECT icb_file.* INTO g_icb.*
         FROM icb_file
        WHERE icb01 = l_newno
       CALL i001_u()
       #SELECT icb_file.* INTO g_icb.*  #FUN-C30027
       #  FROM icb_file                 #FUN-C30027
       # WHERE icb01 = l_oldno          #FUN-C30027
    END IF
    #LET g_icb.icb01 = l_oldno          #FUN-C30027
    CALL i001_show()
END FUNCTION
 
FUNCTION i001_set_entry(p_cmd)
DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("icb01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i001_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("icb01",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i001_field_xxx()
# DEFINE l_xxx01 LIKE icd_file.icd03
  DEFINE l_xxx02 LIKE icd_file.icd03
  DEFINE l_xxx03 LIKE icd_file.icd03
  DEFINE l_xxx04 LIKE icd_file.icd03
  DEFINE l_xxx05 LIKE icd_file.icd03
  DEFINE l_xxx06 LIKE icd_file.icd03
  
  DISPLAY '' TO  FORMONLY.icb09_desc
  DISPLAY '' TO  FORMONLY.icb12_desc
  DISPLAY '' TO  FORMONLY.icb07_desc
  DISPLAY '' TO  FORMONLY.icb14_desc
  DISPLAY '' TO  FORMONLY.icb15_desc
 
  IF NOT cl_null(g_icb.icb09) THEN 
     SELECT icd03 INTO l_xxx02 
       FROM icd_file
      WHERE icd01 = g_icb.icb09
        AND icd02 = 'M'
     DISPLAY l_xxx02 TO FORMONLY.icb09_desc
  END IF
 
  IF NOT cl_null(g_icb.icb12) THEN 
     SELECT icd03 INTO l_xxx03 
       FROM icd_file
      WHERE icd01 = g_icb.icb12
        AND icd02 = 'J'
     DISPLAY l_xxx03 TO FORMONLY.icb12_desc
  END IF
 
  IF NOT cl_null(g_icb.icb07) THEN 
     SELECT icd03 INTO l_xxx04 
       FROM icd_file
      WHERE icd01 = g_icb.icb07
        AND icd02 = 'K'
     DISPLAY l_xxx04 TO FORMONLY.icb07_desc
  END IF
 
  IF NOT cl_null(g_icb.icb14) THEN 
     SELECT icd03 INTO l_xxx05 
       FROM icd_file
      WHERE icd01 = g_icb.icb14
        AND icd02 = 'L'
     DISPLAY l_xxx05 TO FORMONLY.icb14_desc
  END IF
 
  IF NOT cl_null(g_icb.icb15) THEN 
     SELECT icd03 INTO l_xxx06
       FROM icd_file
      WHERE icd01 = g_icb.icb15
        AND icd02 = 'N'
     DISPLAY l_xxx06 TO FORMONLY.icb15_desc
  END IF
 
END FUNCTION
 
FUNCTION i001_out()
    DEFINE l_i           LIKE type_file.num5,
           sr            RECORD
              icb01      LIKE icb_file.icb01, 
              imaicd01   LIKE imaicd_file.imaicd01, 
              icb02      LIKE icb_file.icb02,
              icb79      LIKE icb_file.icb79,
              icb04      LIKE icb_file.icb04,
              icb05      LIKE icb_file.icb05,
              icb09      LIKE icb_file.icb09,
              icb09_desc LIKE icd_file.icd03,
              icb11      LIKE icb_file.icb11,
              icb11_desc LIKE pmc_file.pmc03,
              icb12      LIKE icb_file.icb12,
              icb12_desc LIKE icd_file.icd03,
              icb07      LIKE icb_file.icb07,
              icb07_desc LIKE icd_file.icd03,
              icb06      LIKE icb_file.icb06,
              icb08      LIKE icb_file.icb08,
              icb08_desc LIKE pmc_file.pmc03,
              icb72      LIKE icb_file.icb72,    
              icb13      LIKE icb_file.icb13,
              icb14      LIKE icb_file.icb14,
              icb14_desc LIKE icd_file.icd03,
              icb15      LIKE icb_file.icb15,
              icb15_desc LIKE icd_file.icd03,
              icb10      LIKE icb_file.icb10,
              icb16      LIKE icb_file.icb16,
              icb17      LIKE icb_file.icb17,
              icb18      LIKE icb_file.icb18,
              icb30      LIKE icb_file.icb30,   
              icb32      LIKE icb_file.icb32,
              icb34      LIKE icb_file.icb34,
              icb36      LIKE icb_file.icb36,  
              icb19      LIKE icb_file.icb19, 
              icb20      LIKE icb_file.icb20,
              icb26      LIKE icb_file.icb26,
              icb33      LIKE icb_file.icb33,
              icb35      LIKE icb_file.icb35,
              icb37      LIKE icb_file.icb37,
              icb21      LIKE icb_file.icb21,
              icb22      LIKE icb_file.icb22,
              icb23      LIKE icb_file.icb23, 
              icb24      LIKE icb_file.icb24,
              icb25      LIKE icb_file.icb25              
                         END RECORD,
               l_name    LIKE type_file.chr20,
               l_za05    LIKE za_file.za05
 
     IF cl_null(g_icb.icb01) THEN
          CALL cl_err('','9057',0)
          RETURN
     END IF
     IF cl_null(g_wc) THEN
        LET g_wc=" icb01='",g_icb.icb01,"'"
     END IF
     CALL cl_wait()
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_lang
     CALL cl_del_data(l_table)
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?)" 
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
 
     LET g_sql="SELECT icb01,imaicd01,icb02,icb79,",
                  "icb04,icb05,icb09,a.icd03,icb11,w.pmc03,icb12,b.icd03,",
                  "icb07,c.icd03,icb06,icb08,j.pmc03,icb72,icb13,icb14,",
                  "d.icd03,icb15,e.icd03,icb10,icb16,icb17,icb18,icb30,",
                  "icb32,icb34,icb36,icb19,icb20,icb26,icb33,icb35,icb37,",
                  "icb21,icb22,icb23,icb24,icb25",
               " FROM icb_file,imaicd_file,",
                     "icd_file a,icd_file b,icd_file c,icd_file d",
                    ",icd_file e,pmc_file w,pmc_file j",
               " WHERE icb01=imaicd_file.imaicd00",
                    " AND a.icd01=icb09 AND b.icd01=icb12",
                    " AND c.icd01=icb07 AND d.icd01=icb14 AND e.icd01=icb15",  
                    " AND w.pmc01=icb11 AND j.pmc01=icb08",
                    " AND ",g_wc CLIPPED
 
     LET g_sql=g_sql CLIPPED," ORDER BY icb01" 
     PREPARE i001_pl FROM g_sql 
     IF STATUS THEN CALL cl_err('i001_pl',STATUS,0) END IF
     
     DECLARE i001_co CURSOR FOR i001_pl
 
    FOREACH i001_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF  
     EXECUTE insert_prep USING sr.*
    END FOREACH 
 
    CALL cl_wcchp(g_wc,'icb01,icb79')
         RETURNING g_wc
    LET g_str=g_wc
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('aici001','aici001',g_sql,g_str) 
  
    CLOSE i001_co
    ERROR ""        
END FUNCTION
#No.FUN-860115 --begin
FUNCTION i001_icb79()
DEFINE    l_iccacti     LIKE icc_file.iccacti
                                                                                                                                    
  SELECT icc04,icc05,icc06,icc07,icc08,icc09,icc10,icc11,icc12,icc13,icc14,
         icc15,icc16,icc17,icc18,icc19,icc20,icc21,icc22,icc23,icc24,icc25,icc26,icc27,icc30,icc32,icc33,
         icc34,icc35,icc36,icc37,iccacti
    INTO g_icb.icb04,g_icb.icb05,g_icb.icb06,g_icb.icb07,g_icb.icb08,g_icb.icb09,g_icb.icb10,g_icb.icb11,g_icb.icb12,g_icb.icb13,g_icb.icb14,
         g_icb.icb15,g_icb.icb16,g_icb.icb17,g_icb.icb18,g_icb.icb19,g_icb.icb20,g_icb.icb21,g_icb.icb22,g_icb.icb23,g_icb.icb24,g_icb.icb25,g_icb.icb26,g_icb.icb72,g_icb.icb30,g_icb.icb32,g_icb.icb33,
         g_icb.icb34,g_icb.icb35,g_icb.icb36,g_icb.icb37,g_icb.icb72,l_iccacti
    FROM icc_file                                                                                                                   
   WHERE icc01 = g_icb.icb79                                                                                                        
                                                                                                                                    
  CASE                                                                                                                              
    WHEN SQLCA.SQLCODE = 100   LET g_errno = 'agl-117'                                                                              
    WHEN l_iccacti = 'N'       LET g_errno = '9028'                                                                                 
  END CASE                                                                                                                          
 
  CALL i001_field_xxx()                                                                                                                                    
  CALL i001_show()
END FUNCTION
#No.FUN-9C0072 精簡程式碼

