# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aeci200.4gl
# Descriptions...: 合拼版資料維護作業
# Date & Author..: 10/08/10 By jan(FUN-A80054)
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-B10168 11/01/18 By lixh1  被取代製程段開窗,如果單身已經有打料號和製程編號應該做為開窗撈資料的條件 
# Modify.........: No.TQC-B10215 11/01/20 By destiny orig,oriu新增时未付值
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改
# Modify.........: No.TQC-BC0048 12/01/10 By destiny 非平行工艺时不能运行
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/16 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.CHI-C80041 13/02/05 By bart 無單身刪除單頭
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_eda      RECORD LIKE eda_file.*,
    g_eda_t    RECORD LIKE eda_file.*,
    g_eda_o    RECORD LIKE eda_file.*,
    g_eda01_t  LIKE eda_file.eda01,
    g_ima      RECORD LIKE ima_file.*,
    g_wc,g_wc2,g_sql   string,   
    g_edb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        edb02           LIKE edb_file.edb02,     
        edb03           LIKE edb_file.edb03,   
        ima02           LIKE ima_file.ima02,
        ima021          LIKE ima_file.ima021,
        edb05           LIKE edb_file.edb05,  
        edb06           LIKE edb_file.edb06, 
        edb04           LIKE edb_file.edb04,    
        edb07           LIKE edb_file.edb07     
                    END RECORD,
    g_edb_t         RECORD                 #程式變數 (舊值)
        edb02           LIKE edb_file.edb02,     
        edb03           LIKE edb_file.edb03,   
        ima02           LIKE ima_file.ima02,
        ima021          LIKE ima_file.ima021,
        edb05           LIKE edb_file.edb05,  
        edb06           LIKE edb_file.edb06, 
        edb04           LIKE edb_file.edb04,    
        edb07           LIKE edb_file.edb07 
                    END RECORD,  
    g_cmd           LIKE type_file.chr1000,      
    p_row,p_col     LIKE type_file.num5,         
    g_rec_b         LIKE type_file.num5,         
    l_ac            LIKE type_file.num5          
 
DEFINE g_forupd_sql          STRING                     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_msg                 LIKE type_file.chr1000     
DEFINE g_row_count           LIKE type_file.num10       
DEFINE g_curs_index          LIKE type_file.num10       
DEFINE g_jump                LIKE type_file.num10       
DEFINE mi_no_ask             LIKE type_file.num10       
DEFINE g_count               LIKE type_file.num10   
DEFINE g_chr                 LIKE type_file.chr1 
DEFINE g_t1                  LIKE oay_file.oayslip   
DEFINE l_table               STRING
DEFINE g_str                 STRING

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
   #TQC-BC0048--begin 
   IF g_sma.sma541='N' OR cl_null(g_sma.sma541) THEN                                                                                                    
      CALL cl_err('','aec-056',1)                                                                                                   
      EXIT PROGRAM                                                                                                                  
   END IF
   #TQC-BC0048--end
   LET g_sql="eda01.eda_file.eda01,", 
             "eda02.eda_file.eda02,", 
             "eda03.eda_file.eda03,", 
             "edaconf.eda_file.edaconf,",
             "edb02.edb_file.edb02,",   
             "edb03.edb_file.edb03,",  
             "edb05.edb_file.edb05,",   
             "edb06.edb_file.edb06,", 
             "edb04.edb_file.edb04,",  
             "edb07.edb_file.edb07,",   
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021"
   LET l_table = cl_prt_temptable('aeci200',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET p_row = 1 LET p_col = 3
 
   OPEN WINDOW i200_w AT p_row,p_col WITH FORM "aec/42f/aeci200"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CALL cl_set_comp_visible("edb07",g_sma.sma541='Y')
   
 
   CALL i200()
 
   CLOSE WINDOW i200_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION i200()
 
   INITIALIZE g_eda.* TO NULL
   INITIALIZE g_eda_t.* TO NULL
   INITIALIZE g_eda_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM eda_file WHERE eda01 = ?  FOR UPDATE"   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i200_cl CURSOR FROM g_forupd_sql
 
   CALL i200_menu()
 
END FUNCTION
 
FUNCTION i200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  
   CLEAR FORM
   CALL g_edb.clear()
   CALL cl_set_head_visible("","YES")  
   INITIALIZE g_eda.* TO NULL   
   
   CONSTRUCT BY NAME g_wc ON
       eda01, eda02, eda03,edaconf,edauser, edagrup, edamodu, edadate, edaacti 
      
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(eda01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_eda" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO eda01
                   NEXT FIELD eda01
              OTHERWISE EXIT CASE
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
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 
   CONSTRUCT g_wc2 ON edb02,edb03,edb05,edb06,edb04,edb07
 
           FROM s_edb[1].edb02,s_edb[1].edb03,s_edb[1].edb05,
                s_edb[1].edb06,s_edb[1].edb04,s_edb[1].edb07
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
        ON ACTION controlp                        #
           CASE
              WHEN INFIELD(edb03) 
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.state    = "c"
                #   LET g_qryparam.form = "q_ima"
                #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO edb03
                   NEXT FIELD edb03
              WHEN INFIELD(edb04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_ecu"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO edb04
                   NEXT FIELD edb04
              WHEN INFIELD(edb07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_ecu012_1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO edb07
                   NEXT FIELD edb07
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
 
   IF INT_FLAG THEN RETURN END IF
 

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('edauser', 'edagrup')
 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT eda01 FROM eda_file ",  
                " WHERE ",g_wc CLIPPED, " ORDER BY eda01"  
   ELSE
      LET g_sql="SELECT UNIQUE eda01",  
                "  FROM eda_file,edb_file ",
                " WHERE eda01=edb01",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY eda01"            
   END IF
   PREPARE i200_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE i200_cs SCROLL CURSOR WITH HOLD FOR i200_prepare
   IF g_wc2 = ' 1=1' THEN
      LET g_sql= "SELECT COUNT(*) ",  
                 "FROM eda_file ",
                 "WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql= "SELECT COUNT(DISTINCT eda01) ",  
                 "FROM eda_file,edb_file ",
                 "WHERE eda01=edb01 ",
                 "  AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i200_precount FROM g_sql
   DECLARE i200_count CURSOR FOR i200_precount
 
END FUNCTION
 
FUNCTION i200_menu()
DEFINE  l_msg          STRING    
DEFINE  l_cmd          LIKE type_file.chr1000
 
   WHILE TRUE
      CALL i200_bp("G")
      
      LET g_count = 0       
      
      CASE g_action_choice
      
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i200_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i200_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i200_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i200_copy()    
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i200_b()
            END IF
            LET g_action_choice = ""
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
     #   WHEN "resource_fm"
     #      LET g_cmd = "aeci110 '",g_eda.eda01,"' '",g_eda.eda02,"' '",g_eda.eda012 clipped,"'" 
     #      CALL cl_cmdrun(g_cmd)

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_edb),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_eda.eda01 IS NOT NULL THEN
                LET g_doc.column1 = "eda01"
                LET g_doc.value1 = g_eda.eda01
                CALL cl_doc()
             END IF 
          END IF
        
        WHEN "confirm"                                                                                                           
           IF cl_chk_act_auth() THEN                                                                                                
              CALL i200_confirm()                                                                                                   
              CALL i200_show()                                                                                                      
           END IF                                                                                                                   
                                                                                                                                    
        WHEN "notconfirm"                                                                                                        
           IF cl_chk_act_auth() THEN                                                                                                
              CALL i200_notconfirm()                                                                                                
              CALL i200_show()                                                                                                      
           END IF                                                                                                                   
 
       #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i200_x()   #CHI-D20010
               CALL i200_x(1)  #CHI-D20010
               CALL i200_show()
            END IF

       #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
             # CALL i200_x()    #CHI-D20010
               CALL i200_x(2)   #CHI-D20010
               CALL i200_show()
            END IF
       #CHI-D20010---end
            
         WHEN "Combined_Form"                                                                                                            
            IF cl_chk_act_auth() THEN                                                                                               
             IF l_ac >0 THEN                                                                                          
               LET l_cmd = "aeci201 "," '",g_eda.eda01,"'",                                                                             
                           " '",g_edb[l_ac].edb02,"' "                                                                             
               CALL cl_cmdrun(l_cmd)                                                                                                
             END IF                                                                                                                 
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i200_out()
            END IF
 
      END CASE
   END WHILE
   CLOSE i200_cs
END FUNCTION


FUNCTION i200_a()
DEFINE li_result     LIKE type_file.num5

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_edb.clear()
    INITIALIZE g_eda.* LIKE eda_file.*
    LET g_eda01_t = NULL
    LET g_eda.eda03 ='N'
    LET g_eda.edaconf = 'N'
    LET g_eda.edaacti = 'Y'
    LET g_eda.edauser = g_user
    LET g_eda.edagrup = g_grup
    LET g_eda.edadate = TODAY
    LET g_eda.edaoriu = g_user #TQC-B10215
    LET g_eda.edaorig = g_grup #TQC-B10215
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i200_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_edb.clear()
            EXIT WHILE
        END IF
        BEGIN WORK                                                                                                                  
        CALL s_auto_assign_no("asf",g_eda.eda01,g_today,"V","eda_file","eda01","","","")                                        
        RETURNING li_result,g_eda.eda01                                                                                           
        IF (NOT li_result) THEN                                                                                                     
           CONTINUE WHILE                                                                                                           
        END IF                                                                                                                      
        DISPLAY BY NAME g_eda.eda01
        LET g_eda.edaoriu = g_user 
        LET g_eda.edaorig = g_grup 
        INSERT INTO eda_file VALUES(g_eda.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","eda_file",g_eda.eda01,'',SQLCA.sqlcode,"","",1) 
           ROLLBACK WORK
           CONTINUE WHILE
        ELSE
           COMMIT WORK
           LET g_eda_t.* = g_eda.*               # 保存上筆資料
           SELECT eda01 INTO g_eda.eda01 FROM eda_file  
                  WHERE eda01 = g_eda.eda01 
        END IF
 
        CALL g_edb.clear()
        LET g_rec_b = 0
 
        CALL i200_b()
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i200_i(p_cmd)
DEFINE
       p_cmd           LIKE type_file.chr1, 
       l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入
       l_n             LIKE type_file.num5 
DEFINE li_result     LIKE type_file.num5

    CALL cl_set_head_visible("","YES")   
    DISPLAY BY NAME g_eda.eda03,g_eda.edaconf,
                    g_eda.edauser,g_eda.edagrup,g_eda.edadate,g_eda.edaacti,g_eda.edaoriu,g_eda.edaorig #TQC-B10215 
    
    INPUT BY NAME
        g_eda.eda01, g_eda.eda02, g_eda.eda03,
        g_eda.edauser,g_eda.edagrup,g_eda.edamodu,g_eda.edadate,g_eda.edaacti
 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i200_set_entry(p_cmd)
            CALL i200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("eda01") 
 
        AFTER FIELD eda01
           IF NOT cl_null(g_eda.eda01) THEN                                                                                        
                CALL s_check_no("asf",g_eda.eda01,g_eda_t.eda01,"V","eda_file","eda01","")                                          
                RETURNING li_result,g_eda.eda01                                                                                     
                DISPLAY BY NAME g_eda.eda01                                                                                         
                IF (NOT li_result) THEN                                                                                             
                  NEXT FIELD eda01                                                                                                  
                END IF   
            END IF
 

        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_eda.edauser = s_get_data_owner("eda_file") #FUN-C10039
           LET g_eda.edagrup = s_get_data_group("eda_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF   
 

        ON ACTION controlp
           CASE
              WHEN INFIELD(eda01)
                   LET g_t1 = s_get_doc_no(g_eda.eda01)                                                                                                  
                   CALL q_smy( FALSE,TRUE,g_t1,'ASF','V') RETURNING g_t1                                      
                   LET g_eda.eda01=g_t1                                                                   
                   DISPLAY BY NAME g_eda.eda01                                                                                     
                   NEXT FIELD eda01                
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i200_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1        
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("eda01",TRUE)  
    END IF
 
END FUNCTION
 
FUNCTION i200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("eda01",FALSE)    
    END IF
 
END FUNCTION
 
FUNCTION i200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_eda.* TO NULL   
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i200_cs()  
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_edb.clear()
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
    OPEN i200_count
    FETCH i200_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eda.eda01,SQLCA.sqlcode,0)
        INITIALIZE g_eda.* TO NULL
    ELSE
        CALL i200_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i200_fetch(p_fleda)
    DEFINE
        p_fleda         LIKE type_file.chr1, 
        l_abso          LIKE type_file.chr1 
 
    CASE p_fleda
        WHEN 'N' FETCH NEXT     i200_cs INTO g_eda.eda01
        WHEN 'P' FETCH PREVIOUS i200_cs INTO g_eda.eda01
        WHEN 'F' FETCH FIRST    i200_cs INTO g_eda.eda01
        WHEN 'L' FETCH LAST     i200_cs INTO g_eda.eda01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i200_cs INTO g_eda.eda01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eda.eda01,SQLCA.sqlcode,0)
        INITIALIZE g_eda.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_fleda
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_eda.* FROM eda_file       # 重讀DB,因TEMP有不被更新特性
       WHERE eda01 = g_eda.eda01 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","eda_file",g_eda.eda01,g_eda.eda02,SQLCA.sqlcode,"","",1) 
    ELSE
        LET g_data_owner = g_eda.edauser
        LET g_data_group = g_eda.edagrup
        CALL i200_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i200_show()
    LET g_eda_t.* = g_eda.*
    DISPLAY BY NAME
        g_eda.eda01,g_eda.eda02,g_eda.eda03,
        g_eda.edaconf,g_eda.edaorig,g_eda.edaoriu,
        g_eda.edauser,g_eda.edagrup,g_eda.edamodu,g_eda.edadate,g_eda.edaacti
       
    CALL i200_b_fill(g_wc2)
    CALL i200_show_pic() 
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION i200_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_eda.eda01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_eda.edaconf = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
    IF g_eda.edaconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
 
    BEGIN WORK
 
    OPEN i200_cl USING g_eda.eda01
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i200_cl INTO g_eda.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock eda:',SQLCA.sqlcode,0)
        CLOSE i200_cl ROLLBACK WORK RETURN
    END IF
 
    LET g_eda01_t = g_eda.eda01
    LET g_eda_o.*=g_eda.*
    LET g_eda.edamodu = g_user
    LET g_eda.edadate = g_today               #修改日期
    CALL i200_show()                          # 顯示最新資料
 
    WHILE TRUE
        CALL i200_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_eda.*=g_eda_t.*
            CALL i200_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE eda_file SET eda_file.* = g_eda.*    # 更新DB
            WHERE eda01 = g_eda01_t 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","eda_file",g_eda01_t,'',SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i200_r()
    DEFINE l_chr      LIKE type_file.chr1,  
           l_cnt      LIKE type_file.num5  
           
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_eda.eda01) THEN 
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_eda.edaconf = 'Y' OR g_eda.edaconf = 'X' THEN                                                                                                       
       CALL cl_err('','apc-138',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
 
    BEGIN WORK
 
    OPEN i200_cl USING g_eda.eda01
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i200_cl INTO g_eda.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock eda:',SQLCA.sqlcode,0)
       CLOSE i200_cl ROLLBACK WORK RETURN
    END IF
 
    CALL i200_show()
 
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          
        LET g_doc.column1 = "eda01"             
        LET g_doc.value1 = g_eda.eda01         
        CALL cl_del_doc()                          
         
        DELETE FROM eda_file WHERE eda01 = g_eda.eda01
        IF STATUS THEN 
        CALL cl_err3("del","eda_file",g_eda.eda01,'',STATUS,"","del eda:",1)        
        RETURN END IF
 
        DELETE FROM edb_file WHERE edb01 = g_eda.eda01 
        IF STATUS THEN 
        CALL cl_err3("del","edb_file",g_eda.eda01,'',STATUS,"","del edb:",1)     
        RETURN END IF
 
        INITIALIZE g_eda.* TO NULL
        CLEAR FORM
        CALL g_edb.clear()
        OPEN i200_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i200_cs
             CLOSE i200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        FETCH i200_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i200_cs
             CLOSE i200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i200_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i200_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i200_fetch('/')
        END IF
 
    END IF
    CLOSE i200_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i200_confirm()
DEFINE l_msg              STRING

    IF cl_null(g_eda.eda01) IS NULL THEN    
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF                                                                                                
#CHI-C30107 -------- add --------- begin
    IF g_eda.edaconf="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_eda.edaconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    IF g_eda.edaacti="N" THEN
       CALL cl_err("",'aim-153',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-222') THEN RETURN END IF
    SELECT * INTO g_eda.* FROM eda_file WHERE eda01 = g_eda.eda01
#CHI-C30107 -------- add --------- end
    IF g_eda.edaconf="Y" THEN                                                                                                     
       CALL cl_err("",9023,1)                                                                                                       
       RETURN          
    END IF    
    IF g_eda.edaconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    IF g_eda.edaacti="N" THEN                                                                                                       
       CALL cl_err("",'aim-153',1)                
       RETURN                                                                
    ELSE                                                                                                                            
    #   IF cl_confirm('aap-222') THEN           #CHI-C30107 mark                                                                                    
            BEGIN WORK                                                                                                              
            UPDATE eda_file                                                                                                         
            SET edaconf="Y"                                                                                                       
            WHERE eda01=g_eda.eda01
        IF SQLCA.sqlcode THEN                                                                                                       
            CALL cl_err3("upd","eda_file",g_eda.eda01,'',SQLCA.sqlcode,"","edaconf",1)                                            
            ROLLBACK WORK                                                                                                           
        ELSE                                                                                                                        
            COMMIT WORK                                                                                                             
            LET g_eda.edaconf="Y"                                                                                                 
            DISPLAY g_eda.edaconf TO FORMONLY.edaconf
        END IF
     #  END IF            #CHI-C30107 mark
    END IF
END FUNCTION
 
FUNCTION i200_notconfirm()
DEFINE l_cnt  LIKE type_file.num5

    IF cl_null(g_eda.eda01) THEN                                                                                                      
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF
    IF g_eda.edaconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    SELECT count(*) INTO l_cnt FROM edc_file WHERE edc01=g_eda.eda01
    IF l_cnt > 0 THEN
       CALL cl_err(g_eda.eda01,'aec-061',1)
       RETURN
    END IF
    IF g_eda.edaconf="N" OR g_eda.edaacti="N" THEN                                                                                  
        CALL cl_err("",'atm-365',1)                                                                                                 
        RETURN
    ELSE
        IF cl_confirm('aap-224') THEN                                                                                                
         BEGIN WORK                                                                                                                 
         UPDATE eda_file                                                                                                            
           SET edaconf="N"                                                                                                        
         WHERE eda01=g_eda.eda01
        IF SQLCA.sqlcode THEN                                                                                                         
          CALL cl_err3("upd","eda_file",g_eda.eda01,'',SQLCA.sqlcode,"","edaconf",1)                                               
          ROLLBACK WORK
        ELSE                                                                                                                          
          COMMIT WORK                                                                                                                
          LET g_eda.edaconf="N"                                                                                                    
          DISPLAY g_eda.edaconf TO FORMONLY.edaconf
        END IF
        END IF
    END IF
END FUNCTION

#FUNCTION i200_x()        #CHI-D20010
FUNCTION i200_x(p_type)   #CHI-D20010 
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_eda.eda01) IS NULL THEN    
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF                                                                                                
    IF g_eda.edaconf="Y" THEN                                                                                                     
       CALL cl_err("",9023,1)                                                                                                       
       RETURN          
    END IF    

    #CHI-D20010---begin
    IF p_type = 1 THEN
       IF g_eda.edaconf ='X' THEN RETURN END IF
    ELSE
       IF g_eda.edaconf <>'X' THEN RETURN END IF
    END IF
    #CHI-D20010---end
    
   IF g_eda.edaacti="N" THEN                                                                                                       
       CALL cl_err("",'aim-153',1)                
       RETURN                                                                
   ELSE 
      IF g_eda.edaconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
     #IF cl_void(0,0,g_eda.edaconf)   THEN  #FUN-D20010
      IF cl_void(0,0,l_flag)   THEN     #FUN-D20010
        LET g_chr=g_eda.edaconf
       #IF g_eda.edaconf ='N' THEN  #FUN-D20010
        IF p_type = 1 THEN          #FUN-D20010
           LET g_eda.edaconf='X'
        ELSE
            LET g_eda.edaconf='N'
        END IF
        UPDATE eda_file
            SET edaconf=g_eda.edaconf,
                edamodu=g_user,
                edadate=g_today
            WHERE eda01  =g_eda.eda01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","eda_file",g_eda.eda01,"",SQLCA.sqlcode,"","",1) 
            LET g_eda.edaconf=g_chr
        END IF
        DISPLAY BY NAME g_eda.edaconf,g_eda.edamodu,g_eda.edadate                                                             
      END IF
   END IF
END FUNCTION
 
FUNCTION i200_show_pic()                                                                                                            
DEFINE l_void    LIKE type_file.chr1
DEFINE l_confirm LIKE type_file.chr1

     LET l_void=NULL
     LET l_confirm=NULL
     IF g_eda.edaconf MATCHES '[Yy]' THEN
           LET l_confirm='Y'
           LET l_void='N'
     ELSE
        IF g_eda.edaconf ='X' THEN
              LET l_confirm='N'
              LET l_void='Y'
        ELSE
           LET l_confirm='N'
           LET l_void='N'
        END IF
     END IF
     CALL cl_set_field_pic(l_confirm,"","","",l_void,"g_eda.edaacti")
    #CALL cl_set_field_pic1(g_eda.edaconf,"","","","",g_eda.edaacti,"","")                                                                 
END FUNCTION                                                                                                                        
 
FUNCTION i200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY
    l_n             LIKE type_file.num5,         #檢查重復用 
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否
    p_cmd           LIKE type_file.chr1,         #處理狀態
    l_allow_insert  LIKE type_file.num5,         #可新增否 
    l_allow_delete  LIKE type_file.num5          #可刪除否
DEFINE l_edb05      LIKE edb_file.edb05 
DEFINE l_cnt,i      LIKE type_file.num5     
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_eda.eda01 IS NULL THEN RETURN END IF
    IF g_eda.edaconf='Y' OR g_eda.edaconf='X' THEN RETURN END IF  
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT edb02,edb03,'','',edb05,edb06,edb04,edb07 ",
        " FROM edb_file ",
        "WHERE edb01= ? AND edb02= ? FOR UPDATE" 
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_edb WITHOUT DEFAULTS FROM s_edb.*
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
 
            OPEN i200_cl USING g_eda.eda01
            IF STATUS THEN
               CALL cl_err("OPEN i200_cl_b:", STATUS, 1)
               CLOSE i200_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i200_cl INTO g_eda.*               # 對DB鎖定
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock eda:',SQLCA.sqlcode,0)
                  CLOSE i200_cl ROLLBACK WORK RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
 
                LET p_cmd='u'
                LET g_edb_t.* = g_edb[l_ac].*  #BACKUP
 
                OPEN i200_bcl USING g_eda.eda01,g_edb_t.edb02
                IF STATUS THEN
                   CALL cl_err("OPEN i200_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i200_bcl INTO g_edb[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_edb_t.edb03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL i200_edb03('d')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_edb[l_ac].* TO NULL  
            LET g_edb[l_ac].edb05 = 1
            LET g_edb_t.* = g_edb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont() 
            NEXT FIELD edb02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_edb[l_ac].edb07) THEN LET g_edb[l_ac].edb07=' ' END IF
            INSERT INTO edb_file(edb01,edb02,edb03,edb04,edb05,edb06,edb07)
                          VALUES(g_eda.eda01,g_edb[l_ac].edb02,g_edb[l_ac].edb03,
                                 g_edb[l_ac].edb04,g_edb[l_ac].edb05,
                                 g_edb[l_ac].edb06,g_edb[l_ac].edb07)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","edb_file",g_eda.eda01,g_edb[l_ac].edb02,STATUS,"","ins edb:",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
          BEFORE FIELD edb02
            IF cl_null(g_edb[l_ac].edb02) OR g_edb[l_ac].edb02 = 0 THEN
               SELECT max(edb02) INTO g_edb[l_ac].edb02 FROM edb_file  
                WHERE edb01 = g_eda.eda01   
               IF cl_null(g_edb[l_ac].edb02) THEN
                  LET g_edb[l_ac].edb02 = 0   
               END IF
               LET g_edb[l_ac].edb02 = g_edb[l_ac].edb02 + g_sma.sma849 
            END IF
 
          AFTER FIELD edb02
            IF NOT cl_null(g_edb[l_ac].edb02) THEN
               IF g_edb[l_ac].edb02 != g_edb_t.edb02
                  OR g_edb_t.edb02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM edb_file
                   WHERE edb01 = g_eda.eda01
                     AND edb02 = g_edb[l_ac].edb02
                  IF l_n > 0 THEN
                     CALL cl_err('','aec-010',0)
                     LET g_edb[l_ac].edb02 = g_edb_t.edb02
                     NEXT FIELD edb02
                  END IF
               END IF
            END IF
 
        AFTER FIELD edb03
            IF NOT cl_null(g_edb[l_ac].edb03) THEN
              #FUN-AA0059 ------------------add start------------
               IF NOT s_chk_item_no(g_edb[l_ac].edb03,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_edb[l_ac].edb03 = g_edb_t.edb03
                  DISPLAY BY NAME g_edb[l_ac].edb03
                  NEXT FIELD edb03
               END IF 
              #FUN-AA0059 ------------------add end----------------                           
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM ecu_file
                WHERE ecu01=g_edb[l_ac].edb03
                  AND ecuacti = 'Y'  #CHI-C90006
                IF l_cnt=0 THEN
                   CALL cl_err('','mfg5075',0)
                   NEXT FIELD edb03
                END IF
                CALL i200_edb04()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD edb03
                END IF
               CALL i200_edb03(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_edb[l_ac].edb03 = g_edb_t.edb03
                  DISPLAY BY NAME g_edb[l_ac].edb03
                  NEXT FIELD edb03
               END IF
            END IF
 
        AFTER FIELD edb04
            IF NOT cl_null(g_edb[l_ac].edb04)  THEN
               CALL i200_edb04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                   NEXT FIELD edb04
                END IF
            END IF
 
        AFTER FIELD edb07
            IF NOT cl_null(g_edb[l_ac].edb07) THEN
               CALL i200_edb04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD edb07
               END IF
            END IF

        AFTER FIELD edb05
            IF NOT cl_null(g_edb[l_ac].edb05) THEN
               IF g_edb[l_ac].edb05 < 1 THEN
                  CALL cl_err(g_edb[l_ac].edb05,'atm-114',0)  
                  NEXT FIELD edb05
               END IF
            END IF
 
      # AFTER FIELD edb06
      #     IF NOT cl_null(g_edb[l_ac].edb06) THEN
      #        IF g_edb[l_ac].edb06 < 0 THEN
      #           CALL cl_err(g_edb[l_ac].edb06,'aec-020',0)
      #           NEXT FIELD edb06
      #        END IF
      #     END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_edb_t.edb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM edb_file
                 WHERE edb01 = g_eda.eda01 
                   AND edb02 = g_edb_t.edb02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","edb_file",g_eda.eda01,g_edb_t.edb02,SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
                   LET g_rec_b=g_rec_b - 1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                   COMMIT WORK
                END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_edb[l_ac].* = g_edb_t.*
               CLOSE i200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_edb[l_ac].edb02,-263,1)
               LET g_edb[l_ac].* = g_edb_t.*
            ELSE
               UPDATE edb_file SET edb02=g_edb[l_ac].edb02,
                                   edb03=g_edb[l_ac].edb03,
                                   edb04=g_edb[l_ac].edb04,
                                   edb05=g_edb[l_ac].edb05,
                                   edb06=g_edb[l_ac].edb06,
                                   edb07=g_edb[l_ac].edb07
                WHERE edb01=g_eda.eda01
                  AND edb02=g_edb_t.edb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","edb_file",g_eda.eda01,g_edb_t.edb02,SQLCA.sqlcode,"","",1) 
                  LET g_edb[l_ac].* = g_edb_t.*
                  ROLLBACK WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_edb[l_ac].* = g_edb_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_edb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               ROLLBACK WORK
               CLOSE i200_bcl
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i200_bcl
            COMMIT WORK
            
        AFTER INPUT
            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                ROLLBACK WORK
                CLOSE i200_bcl
                EXIT INPUT
            END IF
            SELECT SUM(edb05) INTO l_edb05 FROM edb_file
             WHERE edb01=g_eda.eda01
            UPDATE edb_file SET edb06=l_edb05
             WHERE edb01=g_eda.eda01
            FOR i=1 TO g_rec_b
                LET g_edb[i].edb06=l_edb05
            END FOR

 
        ON ACTION controlp  
           CASE
#TQC-B10168 ------------------------Begin-------------------------------------
#             WHEN INFIELD(edb03) OR INFIELD(edb04) OR INFIELD(edb07) 
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ecu2"
#                  LET g_qryparam.default1 = g_edb[l_ac].edb03
#                  LET g_qryparam.default2 = g_edb[l_ac].edb04                   
#                  LET g_qryparam.default3 = g_edb[l_ac].edb07
#                  CALL cl_create_qry() RETURNING g_edb[l_ac].edb03,g_edb[l_ac].edb04,g_edb[l_ac].edb07
#                  DISPLAY BY NAME g_edb[l_ac].edb03,g_edb[l_ac].edb04,g_edb[l_ac].edb07
#                  NEXT FIELD CURRENT
              WHEN INFIELD(edb03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima01"
                   LET g_qryparam.default1 = g_edb[l_ac].edb03
                   CALL cl_create_qry() RETURNING g_edb[l_ac].edb03
                   DISPLAY BY NAME g_edb[l_ac].edb03 
                   NEXT FIELD edb03
              WHEN INFIELD(edb04) OR INFIELD(edb07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecu4"
                   IF NOT cl_null(g_edb[l_ac].edb03) THEN
                      LET g_qryparam.where = "ecu01 = '",g_edb[l_ac].edb03,"'"
                   END IF    
                   LET g_qryparam.default2 = g_edb[l_ac].edb04
                   LET g_qryparam.default3 = g_edb[l_ac].edb07
                   CALL cl_create_qry() RETURNING g_edb[l_ac].edb04,g_edb[l_ac].edb07
                   DISPLAY BY NAME g_edb[l_ac].edb04,g_edb[l_ac].edb07
                   NEXT FIELD CURRENT
#TQC-B10168 ------------------------End---------------------------------------- 
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(edb02) AND l_ac > 1 THEN
               LET g_edb[l_ac].* = g_edb[l_ac-1].*
               NEXT FIELD edb02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
 
    UPDATE eda_file SET edamodu=g_user,
                        edadate=TODAY
     WHERE eda01=g_eda.eda01 
 
    CLOSE i200_bcl
    COMMIT WORK
    CALL i200_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i200_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_eda.eda01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM eda_file ",
                  "  WHERE eda01 LIKE '",l_slip,"%' ",
                  "    AND eda01 > '",g_eda.eda01,"'"
      PREPARE i200_pb1 FROM l_sql 
      EXECUTE i200_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL i200_x()    #CHI-D20010
         CALL i200_x(1)   #CHI-D20010
         CALL i200_show()
      END IF 
      
      IF l_cho = 3 THEN    
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM eda_file WHERE eda01 = g_eda.eda01
         INITIALIZE g_eda.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i200_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000      #No.FUN-680073 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON edb02,edb03,edb05,edb06,edb04,edb07
            FROM s_edb[1].edb02,s_edb[1].edb03,s_edb[1].edb05,
                 s_edb[1].edb06,s_edb[1].edb04,s_edb[1].edb07
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
		     CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i200_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000    
 
IF cl_null(p_wc2) THEN LET p_wc2=' 1=1' END IF  
    LET g_sql =
        "SELECT edb02,edb03,'','',edb05,edb06,edb04,edb07 ",
        " FROM edb_file",
        " WHERE edb01 ='",g_eda.eda01,"'",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY edb02"
    PREPARE i200_pb FROM g_sql
    DECLARE edb_curs CURSOR FOR i200_pb
 
    CALL g_edb.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH edb_curs INTO g_edb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT ima02,ima021 INTO g_edb[g_cnt].ima02,g_edb[g_cnt].ima021
        FROM ima_file
       WHERE ima01 = g_edb[g_cnt].edb03
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    END FOREACH
    CALL g_edb.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt -1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_edb TO s_edb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()    
 
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY 
 
 
      ON ACTION previous
         CALL i200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	       ACCEPT DISPLAY 
 
 
      ON ACTION jump
         CALL i200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	       ACCEPT DISPLAY 
 
 
      ON ACTION next
         CALL i200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	       ACCEPT DISPLAY 
 
 
      ON ACTION last
         CALL i200_fetch('L')
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
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont() 
          CALL i200_show_pic()  
         EXIT DISPLAY
 
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION related_document   
         LET g_action_choice="related_document"          
         EXIT DISPLAY
         
        ON ACTION confirm                                                                                                           
           LET g_action_choice="confirm"                                                                                            
           EXIT DISPLAY                                                                                                                  
                                                                                                                                    
        ON ACTION notconfirm                                                                                                        
           LET g_action_choice="notconfirm"                                                                                         
           EXIT DISPLAY                                                                                                               
 
        #@ON ACTION 作廢
         ON ACTION void
           LET g_action_choice="void"
           EXIT DISPLAY

        #CHI-D20010---begin
        ON ACTION undo_void
           LET g_action_choice="undo_void"
           EXIT DISPLAY
        #CHI-D20010---end
           
         ON ACTION Combined_Form
           LET g_action_choice="Combined_Form"
           EXIT DISPLAY

        ON ACTION output
           LET g_action_choice="output"
           EXIT DISPLAY
           
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i200_copy()
   DEFINE l_newno     LIKE eda_file.eda01,
          l_oldno     LIKE eda_file.eda01
   DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_eda.eda01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i200_set_entry('a')
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT l_newno FROM eda01
       BEFORE INPUT
          CALL cl_set_docno_format("eda01")
 
       AFTER FIELD eda01
           CALL s_check_no("asf",l_newno,"","V","eda_file","eda01","") RETURNING li_result,l_newno
           DISPLAY l_newno TO eda01
           IF (NOT li_result) THEN
              LET g_eda.eda01 = g_eda_o.eda01
              NEXT FIELD eda01
           END IF
           CALL s_auto_assign_no("asf",l_newno,g_today,"V","eda_file","eda01","","","")                                            
           RETURNING li_result,l_newno                                                                                             
           IF (NOT li_result) THEN                                                                                                     
              NEXT FIELD eda01
           END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(eda01) #單據編號
                 LET g_t1=s_get_doc_no(l_newno) 
                CALL q_smy(FALSE,FALSE,g_t1,'ASF','V') RETURNING g_t1 
                 LET l_newno=g_t1
                DISPLAY BY NAME l_newno
                NEXT FIELD eda01
              OTHERWISE EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
 
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_eda.eda01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM eda_file         #單頭複製
       WHERE eda01=g_eda.eda01
       INTO TEMP y
 
   UPDATE y
       SET eda01=l_newno,    #新的鍵值
           eda03='N',          
           edaconf='N',
           edauser=g_user,   #資料所有者
           edagrup=g_grup,   #資料所有者所屬群
           edamodu=NULL,     #資料修改日期
           edadate=g_today,  #資料建立日期
           edaacti='Y',      #有效資料
           edaoriu = g_user, 
           edaorig = g_grup 
 
   INSERT INTO eda_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","eda_file",l_newno,"",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
  
   SELECT * FROM edb_file         #單身複製
       WHERE edb01=g_eda.eda01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET edb01=l_newno
 
  
   INSERT INTO edb_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","edb_file","","",SQLCA.sqlcode,"","",1)   #FUN-B80046 
      ROLLBACK WORK 
     # CALL cl_err3("ins","edb_file","","",SQLCA.sqlcode,"","",1)   #FUN-B80046
      RETURN
   ELSE
       COMMIT WORK 
   END IF
 

   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_eda.eda01
   SELECT eda_file.* INTO g_eda.* FROM eda_file WHERE eda01 = l_newno
   CALL i200_u()
   CALL i200_b()
   #SELECT eda_file.* INTO g_eda.* FROM eda_file WHERE eda01 = l_oldno  #FUN-C30027
   #CALL i200_show()  #FUN-C30027
 
END FUNCTION

FUNCTION i200_out()
DEFINE sr RECORD
          eda01    LIKE eda_file.eda01,
          eda02    LIKE eda_file.eda02,
          eda03    LIKE eda_file.eda03,          
          edaconf  LIKE eda_file.edaconf,
          edb02    LIKE edb_file.edb02,
          edb03    LIKE edb_file.edb03,
          edb05    LIKE edb_file.edb05,
          edb06    LIKE edb_file.edb06,
          edb04    LIKE edb_file.edb04,
          edb07    LIKE edb_file.edb07,
          ima02    LIKE ima_file.ima02,
          ima021   LIKE ima_file.ima021
          END RECORD
DEFINE l_wc   STRING

    IF cl_null(g_eda.eda01) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc =" eda01='",g_eda.eda01,"'"
       LET g_wc2=" 1=1"   
    END IF
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
    CALL cl_del_data(l_table)
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"   
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
    LET g_sql="SELECT eda01,eda02,eda03,edaconf,", 
              " edb02,edb03,edb05,edb06,edb04,edb07,ima02,ima021", 
              " FROM eda_file,edb_file LEFT OUTER JOIN ima_file ON edb03=ima01 ",  
              " WHERE edb01 = eda01 AND ",g_wc CLIPPED,"AND ",g_wc2 CLIPPED 
    LET g_sql = g_sql CLIPPED," ORDER BY eda01,edb02" 
    PREPARE i200_p1 FROM g_sql  
    IF STATUS THEN CALL cl_err('i200_p1',STATUS,0) END IF
 
    DECLARE i200_co                         # CURSOR
        CURSOR FOR i200_p1
 
 
    FOREACH i200_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        EXECUTE insert_prep USING sr.*
    END FOREACH
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'eda01,eda02,eda03,edaconf,edauser,edagrup,edamodu,edadate,edaacti')                 
            RETURNING l_wc
    ELSE
       LET l_wc = ' '
    END IF
    LET g_str = l_wc CLIPPED
    LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('aeci200','aeci200',g_sql,g_str) 
    CLOSE i200_co
    ERROR ""
END FUNCTION

FUNCTION i200_edb03(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1,  
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
       SELECT ima02,ima021,imaacti INTO
              g_edb[l_ac].ima02,g_edb[l_ac].ima021,l_imaacti
         FROM ima_file
        WHERE ima01 = g_edb[l_ac].edb03
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ams-003'
                                      LET g_edb[l_ac].ima02 = NULL
                                      LET g_edb[l_ac].ima021 = NULL
            WHEN l_imaacti='N' LET g_errno = '9028'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       DISPLAY BY NAME g_edb[l_ac].ima02
       DISPLAY BY NAME g_edb[l_ac].ima021

END FUNCTION

FUNCTION i200_edb04()
DEFINE l_cnt LIKE type_file.num5

   LET g_errno = " "
   LET l_cnt=''
   IF NOT cl_null(g_edb[l_ac].edb04) AND
      cl_null(g_edb[l_ac].edb07) THEN
      SELECT count(*) INTO l_cnt FROM ecu_file
       WHERE ecu01=g_edb[l_ac].edb03
         AND ecu02=g_edb[l_ac].edb04
         AND ecuacti = 'Y'  #CHI-C90006
   END IF
   IF NOT cl_null(g_edb[l_ac].edb04) AND
      NOT cl_null(g_edb[l_ac].edb07) THEN
      SELECT count(*) INTO l_cnt FROM ecu_file
       WHERE ecu01=g_edb[l_ac].edb03
         AND ecu02=g_edb[l_ac].edb04
         AND ecu012=g_edb[l_ac].edb07
         AND ecuacti = 'Y'  #CHI-C90006
   END IF
   IF l_cnt = 0 THEN LET g_errno=100 END IF
END FUNCTION
#FUN-A80054
#FUN-B80046

