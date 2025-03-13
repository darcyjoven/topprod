# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acoi106.4gl
# Descriptions...: 料件海關資料維護作業 
# Input parameter: 
# Date & Author..: 04/06/25 By Carrier
# Modify.........: No.FUN-4B0018 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-510042 05/02/17 By pengu 報表轉XML
# Modify.........: No.MOD-530224 05/03/24 By Carrier 新增單身預設"海關代號"
# Modify.........: No.MOD-540158 05/05/11 By vivien  更新control-f的寫法   
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err-->cl_err3 
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0" 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770006 07/07/06 By zhoufeng 報表輸出改為Crystal Reports
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-8B0018 08/11/15 By Pengu 單身顯示資料異常
# Modify.........: No.MOD-960089 09/07/07 By Smapmin 修正複製時,料件編號的合理性判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	 
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

 
DATABASE ds
 
GLOBALS "../../config/top.global"   
 
#模組變數(Module Variables)
DEFINE 
    g_coa01         LIKE coa_file.coa01,   #科目編號 (假單頭)
    g_coa01_t       LIKE coa_file.coa01,   #科目編號 (舊值)
    g_coa           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        coa02       LIKE coa_file.coa02,   #行序          
        coa05       LIKE coa_file.coa05,   #海關編號        
        coa03       LIKE coa_file.coa03,   #海關料號        
        cob02       LIKE cob_file.cob02,
        cob04       LIKE cob_file.cob04,
        coa04       LIKE coa_file.coa04 
                    END RECORD,
    g_coa_t         RECORD                 #程式變數 (舊值)
        coa02       LIKE coa_file.coa02,   #行序          
        coa05       LIKE coa_file.coa05,   #海關編號        
        coa03       LIKE coa_file.coa03,   #海關料號        
        cob02       LIKE cob_file.cob02,
        cob04       LIKE cob_file.cob04,
        coa04       LIKE coa_file.coa04 
                    END RECORD,
    g_argv1         LIKE coa_file.coa01,
    g_ss            LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(01)
     g_wc,g_sql     STRING,  #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL                            #No.FUN-680069
DEFINE   g_sql_tmp       STRING   #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose                        #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680069 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680069 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_str          STRING                       #No.FUN-770006 
DEFINE   l_table        STRING                       #No.FUN-770006
 
#主程式開始
MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0063
DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log        
 
    IF (NOT cl_setup("ACO")) THEN                                               
       EXIT PROGRAM                                                             
    END IF                                                                      
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
#No.FUN-770006 --start--
    LET g_sql="coa01.coa_file.coa01,ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,coa05.coa_file.coa05,",
              "cna02.cna_file.cna02,coa03.coa_file.coa03,",
              "cob02.cob_file.cob02,cob021.cob_file.cob021,",
              "cob04.cob_file.cob04,coa04.coa_file.coa04"
 
    LET l_table = cl_prt_temptable('acoi106',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#No.FUN-770006 --end--
 
         LET p_row = 4 LET p_col = 12
 
    OPEN WINDOW i400_w AT p_row,p_col                                           
         WITH FORM "aco/42f/acoi106"                                            
          ATTRIBUTE (STYLE = g_win_style CLIPPED)     #No.FUN-580092 HCN
 
    CALL cl_ui_init()                                                           
                                                                                
#   DECLARE i106_b_curl CURSOR FROM g_forupd_sql  #No.TQC-720019
 
    CALL i106_menu()      
 
    LET g_argv1 = ARG_VAL(1)
 
    CLOSE WINDOW i106_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN     
 
#QBE 查詢資料
FUNCTION i106_curs()
    CLEAR FORM   
    CALL g_coa.clear()
                          #清除畫面
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' 
       THEN LET g_coa01 =  g_argv1
            DISPLAY g_coa01 TO coa01
            CALL i106_coa01('d',g_coa01)
            LET g_wc = " coa01 ='",g_argv1,"'"
            IF INT_FLAG THEN RETURN END IF
       ELSE
            CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INITIALIZE g_coa01 TO NULL    #No.FUN-750051
            CONSTRUCT g_wc ON coa01,coa02,coa05,coa03,coa04    #螢幕上取條件
            FROM coa01,s_coa[1].coa02,s_coa[1].coa05,
                 s_coa[1].coa03,s_coa[1].coa04
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON ACTION CONTROLP                                                  
               CASE                                                             
                  WHEN INFIELD(coa01)                                 
#FUN-AA0059 --Begin--
                   #    CALL cl_init_qry_var()                                   
                   #    LET g_qryparam.state = "c"                               
                   #    LET g_qryparam.form ="q_ima6"                             
                   #    CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       CALL q_sel_ima( TRUE, "q_ima6","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                       DISPLAY g_qryparam.multiret TO coa01                     
                       NEXT FIELD coa01              
                  WHEN INFIELD(coa03)                              
                       CALL cl_init_qry_var()                                   
                       LET g_qryparam.state = "c"                               
                       LET g_qryparam.form ="q_cob"                             
                       CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       DISPLAY g_qryparam.multiret TO coa03                     
                       NEXT FIELD coa03              
                  WHEN INFIELD(coa05)                                 
                       CALL cl_init_qry_var()                                   
                       LET g_qryparam.state = "c"                               
                       LET g_qryparam.form ="q_cna"                             
                       CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       DISPLAY g_qryparam.multiret TO coa05                     
                       NEXT FIELD coa05              
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
             LET g_wc = g_wc CLIPPED,cl_get_extra_cond('coauser', 'coagrup') #FUN-980030
            IF INT_FLAG THEN RETURN END IF
    END IF  
    LET g_sql= "SELECT UNIQUE coa01 FROM coa_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY coa01"
    PREPARE i106_prepare FROM g_sql      #預備一下
    DECLARE i106_b_curs                  #宣告成可卷動的
        SCROLL CURSOR WITH HOLD FOR i106_prepare
    #因主鍵值有兩個故所抓出資料筆數有誤                                         
    DROP TABLE x                                                                
#   LET g_sql="SELECT DISTINCT coa01 ",           #No.TQC-720019
    LET g_sql_tmp="SELECT DISTINCT coa01 ",       #No.TQC-720019
              " FROM coa_file WHERE ", g_wc CLIPPED," INTO TEMP x"              
#   PREPARE i106_precount_x  FROM g_sql           #No.TQC-720019
    PREPARE i106_precount_x  FROM g_sql_tmp       #No.TQC-720019
    EXECUTE i106_precount_x                                                     
    LET g_sql="SELECT COUNT(*) FROM x "                                         
    PREPARE i106_precount FROM g_sql                                            
    DECLARE i106_count CURSOR FOR  i106_precount          
END FUNCTION
 
FUNCTION i106_menu()
   WHILE TRUE                                                                   
      CALL i106_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "insert"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i106_a()                                                    
            END IF                                                              
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i106_q()                                                    
            END IF                                                              
         WHEN "modify"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i106_u()                                                    
            END IF                                                              
         WHEN "delete"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i106_r()                                                    
            END IF                                                              
         WHEN "reproduce"                                                       
            IF cl_chk_act_auth() THEN                                           
               CALL i106_copy()                                                 
            END IF                
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i106_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i106_out()                                                  
            END IF      
           WHEN "next"         
            CALL i106_fetch('N')                                                
           WHEN "previous"                                                      
            CALL i106_fetch('P')                                                                         
         WHEN "help"                                                            
            CALL cl_show_help()                                                 
         WHEN "exit"                                                            
            EXIT WHILE                                                          
 
         #FUN-4B0018
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_coa),'','')
             END IF
         #--
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_coa01 IS NOT NULL THEN
                 LET g_doc.column1 = "coa01"
                 LET g_doc.value1 = g_coa01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
 
         WHEN "controlg"                                                        
            CALL cl_cmdask()                                                    
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION                       
 
FUNCTION i106_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_coa.clear()
    INITIALIZE g_coa01 LIKE coa_file.coa01
    LET g_coa01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i106_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            LET g_coa01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b =0                     #NO.FUN-680064
        CALL g_coa.clear()
        CALL i106_b_fill(' 1=1')           #單身
        CALL i106_b()                      #輸入單身
        IF SQLCA.sqlcode THEN 
           CALL cl_err(g_coa01,SQLCA.sqlcode,0)
        END IF
        LET g_coa01_t = g_coa01                 #保留舊值
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i106_u()
  DEFINE  l_buf      LIKE coa_file.coa01       #No.FUN-680069 VARCHAR(30)
 
    IF s_shut(0) THEN 
       RETURN 
    END IF
    IF cl_null(g_coa01)  THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_coa01_t = g_coa01
    BEGIN WORK
    WHILE TRUE
        CALL i106_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_coa01=g_coa01_t
            DISPLAY g_coa01 TO coa01               #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_coa01 != g_coa01_t THEN
           UPDATE coa_file 
              SET coa01 = g_coa01   #更新DB
            WHERE coa01 = g_coa01_t 
           IF SQLCA.sqlcode THEN
              LET l_buf = g_coa01 clipped
#              CALL cl_err(l_buf,SQLCA.sqlcode,0) #No.TQC-660045
              CALL cl_err3("upd","coa_file",g_coa01_t,"",SQLCA.sqlcode,"","",1)         #NO.TQC-660045    
              CONTINUE WHILE
           END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i106_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
    l_buf           LIKE coa_file.coa01,         #No.FUN-680069 VARCHAR(60)
    l_n             LIKE type_file.num5          #No.FUN-680069 SMALLINT
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
 
    LET g_ss = 'Y'
    INPUT g_coa01 WITHOUT DEFAULTS FROM coa01 
 
      BEFORE INPUT                                                              
         LET g_before_input_done = FALSE                                        
         CALL i106_set_entry(p_cmd)                                             
         CALL i106_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                
 
       AFTER FIELD coa01 
          IF NOT cl_null(g_coa01) THEN
               #FUN-AA0059 --------------------------add start---------------------
                IF NOT s_chk_item_no(g_coa01,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_coa01 = g_coa01_t
                   DISPLAY g_coa01 TO coa01
                   NEXT FIELD coa01
                END IF 
               #FUN-AA0059 -------------------------add end-------------------------
                CALL i106_coa01('a',g_coa01)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_coa01,g_errno,0)
                   LET g_coa01 = g_coa01_t
                   DISPLAY g_coa01 TO coa01
                   NEXT FIELD coa01
                END IF
          END IF
          SELECT UNIQUE coa01 FROM coa_file WHERE coa01=g_coa01 
          IF SQLCA.sqlcode THEN             #不存在, 新來的
             IF p_cmd='a' THEN LET g_ss='N' END IF
          END IF
             
        ON ACTION CONTROLF                  #欄位說明                           
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name   
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913   
 
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()    
 
        ON ACTION CONTROLP                                                      
           CASE                                                                 
              WHEN INFIELD(coa01)                                     
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()                                       
                #   LET g_qryparam.form ="q_ima6"                                 
                #   LET g_qryparam.default1 = g_coa01                            
                #   CALL cl_create_qry() RETURNING g_coa01                       
                   CALL q_sel_ima(FALSE, "q_ima6", "", g_coa01, "", "", "", "" ,"",'' )  RETURNING g_coa01
#FUN-AA0059 --End--
                   NEXT FIELD coa01                                  
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
END FUNCTION
 
 
FUNCTION i106_coa01(p_cmd,p_key)
    DEFINE p_key   LIKE coa_file.coa01
    DEFINE p_cmd   LIKE type_file.chr1,           #No.FUN-680069 VARCHAR(1)
           l_ima02 LIKE ima_file.ima02,  
           l_ima08 LIKE ima_file.ima08, 
           l_ima25 LIKE ima_file.ima25,
           l_ima15 LIKE ima_file.ima15,
           l_acti  LIKE ima_file.imaacti 
                                        
    LET g_errno = ' '                  
    SELECT ima02,ima08,ima15,ima25,imaacti
      INTO l_ima02,l_ima08,l_ima15,l_ima25,l_acti       
      FROM ima_file                                    
     WHERE ima01 = p_key
       AND (ima130 IS NULL OR ima130 <> '2')
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL       
                                   LET l_ima08 = NULL      
                                   LET l_ima25 = NULL     
         WHEN l_acti='N'           LET g_errno = '9028'  
         WHEN l_ima15='N'          LET g_errno = 'afa-060' 
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------' 
    END CASE 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN  
        DISPLAY l_ima02 TO  FORMONLY.ima02           
        DISPLAY l_ima08 TO  FORMONLY.ima08          
        DISPLAY l_ima25 TO  FORMONLY.ima25         
    END IF                               
END FUNCTION
 
#Query 查詢
FUNCTION i106_q()
    LET g_row_count = 0                                                         
    LET g_curs_index = 0                                                        
    CALL cl_navigator_setting( g_curs_index, g_row_count )                      
    INITIALIZE g_coa01 TO NULL             #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')  
    CLEAR FORM
    CALL g_coa.clear()
    DISPLAY '   ' TO FORMONLY.cnt 
    CALL i106_curs()                       #取得查詢條件
    IF INT_FLAG THEN                       #用戶不玩了
       LET INT_FLAG = 0 
       INITIALIZE g_coa01 TO NULL
       RETURN
    END IF
    OPEN i106_b_curs                       #從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_coa01 TO NULL
    ELSE
        OPEN i106_count                                                     
        FETCH i106_count INTO g_row_count                                         
        DISPLAY g_row_count TO FORMONLY.cnt                                       
        CALL i106_fetch('F')               #讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i106_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1    #處理方式 #No.FUN-680069 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i106_b_curs INTO g_coa01
        WHEN 'P' FETCH PREVIOUS i106_b_curs INTO g_coa01
        WHEN 'F' FETCH FIRST    i106_b_curs INTO g_coa01
        WHEN 'L' FETCH LAST     i106_b_curs INTO g_coa01
        WHEN '/' 
          IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF
            FETCH ABSOLUTE g_jump i106_b_curs INTO g_coa01
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_coa01,SQLCA.sqlcode,0)
       INITIALIZE g_coa01 TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1                                         
          WHEN 'P' LET g_curs_index = g_curs_index - 1                          
          WHEN 'N' LET g_curs_index = g_curs_index + 1                          
          WHEN 'L' LET g_curs_index = g_row_count                               
          WHEN '/' LET g_curs_index = g_jump                                    
       END CASE                                                                 
                                                                                
       CALL cl_navigator_setting( g_curs_index, g_row_count )                   
                                                                                
    END IF                                                                      
    CALL i106_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i106_show()
    DISPLAY g_coa01 TO coa01               #單頭
    CALL i106_coa01('d',g_coa01)   
    CALL i106_b_fill(g_wc)                 #單身
    CALL i106_bp("D")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION i106_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_coa01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6A0168
       RETURN 
    END IF
 
    BEGIN WORK
    CALL i106_show()                 
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "coa01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_coa01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM coa_file WHERE coa01 = g_coa01 
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.TQC-660045
           CALL cl_err3("del","coa_file",g_coa01,"",SQLCA.sqlcode,"","BODY DELETE:",1)           #NO.TQC-660045                     
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i106_precount_x                  #No.TQC-720019
            PREPARE i106_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i106_precount_x2                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_coa.clear()
            DROP TABLE x
            EXECUTE i106_precount_x                                                     
            OPEN i106_count                                                        
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i106_b_curs
               CLOSE i106_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i106_count INTO g_row_count            
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i106_b_curs
               CLOSE i106_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--                          
            DISPLAY g_row_count TO FORMONLY.cnt                                    
            OPEN i106_b_curs                                                           
            IF g_curs_index = g_row_count + 1 THEN                                 
               LET g_jump = g_row_count                                            
               CALL i106_fetch('L')                                                
            ELSE                                                                   
               LET g_jump = g_curs_index                                           
               LET mi_no_ask = TRUE                                                
               CALL i106_fetch('/')                                                
            END IF
         END IF
    END IF
#   CLOSE i106_b_curl  #No.TQC-720019
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i106_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重復用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,    #No.FUN-680069 SMALLINT
    l_modify_flag   LIKE type_file.chr1,    #單身更改否        #No.FUN-680069 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,    #No.FUN-680069 VARCHAR(1)   #Esc結案INPUT ARRAY 否
    p_cmd           LIKE type_file.chr1,    #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,    #No.FUN-680069 VARCHAR(1)  #可新增否
    l_allow_delete  LIKE type_file.chr1,    #No.FUN-680069 VARCHAR(1)  #可更改否 (含撤銷)
    l_jump          LIKE type_file.num5     #No.FUN-680069 SMALLINT  #判斷是否跳過AFTER ROW的處理
 
    LET g_action_choice = ""    
 
    IF g_coa01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =                                                          
        "SELECT coa02,coa05,coa03,' ',' ',coa04 FROM coa_file ",            
        " WHERE coa01 = ? AND coa02 = ? FOR UPDATE"           
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i106_b_cl CURSOR FROM g_forupd_sql      
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")                         
    LET l_allow_delete = cl_detail_input_auth("delete")    
 
    INPUT ARRAY g_coa WITHOUT DEFAULTS FROM s_coa.*                             
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
               LET p_cmd = 'u'                                                     
               LET g_coa_t.* = g_coa[l_ac].*  #BACKUP
               OPEN i106_b_cl USING g_coa01,g_coa_t.coa02
               IF STATUS THEN                                                   
                  CALL cl_err("OPEN i106_b_cl:", STATUS, 1)                     
                  LET l_lock_sw = "Y"                                           
               ELSE                                         
                    FETCH i106_b_cl INTO g_coa[l_ac].* 
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_coa_t.coa04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    ELSE
                       CALL i106_coa03('d')
                       LET g_coa_t.*=g_coa[l_ac].*
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
            NEXT FIELD coa02
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_coa[l_ac].* TO NULL      #900423
            LET g_coa_t.* = g_coa[l_ac].*         #新輸入資料
            LET g_coa[l_ac].coa04 = 1
             #No.MOD-530224  --begin
            LET g_coa[l_ac].coa05 = g_coz.coz02
             #No.MOD-530224  --end   
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD coa02
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               CANCEL INSERT                                                    
            END IF                                                              
              INSERT INTO coa_file(coa01,coa02,coa03,coa04,coa05,     
                     coaacti,coauser,coagrup,coadate,coaoriu,coaorig)                 
              VALUES(g_coa01,g_coa[l_ac].coa02,                       
                     g_coa[l_ac].coa03,g_coa[l_ac].coa04,             
                     g_coa[l_ac].coa05,'Y',g_user,g_grup,g_today, g_user, g_grup)          #No.FUN-980030 10/01/04  insert columns oriu, orig
              IF SQLCA.sqlcode THEN                                   
 #                CALL cl_err(g_coa[l_ac].coa02,SQLCA.sqlcode,0) #No.TQC-660045
                 CALL cl_err3("ins","coa_file",g_coa01,g_coa[l_ac].coa02,SQLCA.sqlcode,"","",1)       #NO.TQC-660045   
                 CANCEL INSERT                                                    
              ELSE
                 MESSAGE 'INSERT O.K'                                             
                 LET g_rec_b=g_rec_b+1                                            
              END IF                                                              
 
        BEFORE FIELD coa02                        # dgeeault 序號
            IF cl_null(g_coa[l_ac].coa02) OR g_coa[l_ac].coa02 = 0 THEN
                SELECT MAX(coa02)+1 INTO g_coa[l_ac].coa02 FROM coa_file
                    WHERE coa01 = g_coa01 
                IF g_coa[l_ac].coa02 IS NULL THEN
                    LET g_coa[l_ac].coa02 = 1
                END IF
            END IF
 
        AFTER FIELD coa02                        # dgeeault 序號
           IF g_coa[l_ac].coa02 IS NOT NULL  #item no+lineno                   
              AND (g_coa[l_ac].coa02 != g_coa_t.coa02 OR                       
                   g_coa_t.coa02 IS NULL ) THEN   
               SELECT COUNT(*) INTO l_cnt FROM coa_file
                WHERE coa02 = g_coa[l_ac].coa02
                  AND coa01 = g_coa01
                   IF l_cnt > 0 THEN                                              
                      CALL cl_err('',-239,0)
                                                          
                      LET g_coa[l_ac].coa02 = g_coa_t.coa02                     
                      NEXT FIELD coa02                                          
                   END IF   
            END IF
 
        AFTER FIELD coa05
            IF NOT cl_null(g_coa[l_ac].coa05) THEN 
               CALL i106_coa05('a')                                             
               IF NOT cl_null(g_errno) THEN                                     
                   CALL cl_err(g_coa[l_ac].coa05,g_errno,0)
                  LET g_coa[l_ac].coa05 = g_coa_t.coa05                         
                  NEXT FIELD coa05                                              
               END IF                                                           
            END IF
 
        AFTER FIELD coa03                       
            IF NOT cl_null(g_coa[l_ac].coa03) THEN 
               CALL i106_coa03('a')                                             
               IF NOT cl_null(g_errno) THEN                                     
                  CALL cl_err(g_coa[l_ac].coa03,g_errno,0)
                  LET g_coa[l_ac].coa03 = g_coa_t.coa03                         
                  NEXT FIELD coa03                                              
               END IF                                                           
               IF (p_cmd = 'a' OR 
                  (p_cmd = 'u' AND (g_coa[l_ac].coa03 != g_coa_t.coa03 OR
                                    g_coa[l_ac].coa05 != g_coa_t.coa05))) THEN
                  SELECT COUNT(*) INTO l_n FROM coa_file
                   WHERE coa01=g_coa01
                     AND coa03=g_coa[l_ac].coa03
                     AND coa05=g_coa[l_ac].coa05
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_coa[l_ac].coa03 = g_coa_t.coa03
                      NEXT FIELD coa03
                   END IF
                END IF
            END IF            
 
        AFTER FIELD coa04                                                       
            IF NOT cl_null(g_coa[l_ac].coa04) THEN 
               IF g_coa[l_ac].coa04 <= 0 THEN 
                  NEXT FIELD coa04 
               END IF  
            END IF 
 
        BEFORE DELETE                            #是否撤銷單身
            IF NOT cl_null(g_coa_t.coa02) OR 
               NOT cl_null(g_coa_t.coa03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN                                         
                   CALL cl_err("", -263, 1)                                     
                   CANCEL DELETE                                                
                END IF        
                DELETE FROM coa_file
                    WHERE coa01 = g_coa01 
                      AND coa02 = g_coa_t.coa02
                IF SQLCA.sqlcode THEN
 #                   CALL cl_err(g_coa_t.coa02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","coa_file",g_coa01,g_coa_t.coa02,SQLCA.sqlcode,"","",1)         #NO.TQC-660045
                    ROLLBACK WORK 
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                COMMIT WORK 
            END IF
 
        ON ROW CHANGE                                                           
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               LET g_coa[l_ac].* = g_coa_t.*                                    
               CLOSE i106_b_cl                                                  
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            IF l_lock_sw = 'Y' THEN                                             
               CALL cl_err(g_coa[l_ac].coa02,-263,1)                            
               LET g_coa[l_ac].* = g_coa_t.*                                    
            ELSE                    
                UPDATE coa_file 
                   SET coa02   = g_coa[l_ac].coa02,
                       coa03   = g_coa[l_ac].coa03,
                       coa04   = g_coa[l_ac].coa04,
                       coa05   = g_coa[l_ac].coa05,         
                       coamodu = g_user,
                       coadate = g_today                    
                  WHERE CURRENT OF i106_b_cl                           
                 IF SQLCA.sqlcode THEN                                   
#                     CALL cl_err(g_coa[l_ac].coa02,SQLCA.sqlcode,0)       #No.TQC-660045
                     CALL cl_err3("upd","coa_file",g_coa01,g_coa[l_ac].coa02,SQLCA.sqlcode,"","",1)                   #NO.TQC-660045
                     LET g_coa[l_ac].* = g_coa_t.* 
                     CLOSE i106_b_cl                      
                     ROLLBACK WORK                                       
                 ELSE                                                    
                     MESSAGE 'UPDATE O.K'                                
                     COMMIT WORK 
                 END IF                                                  
             END IF                
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
           #LET l_ac_t = l_ac        #FUN-D30034 Mark                                             
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN                                              
                  LET g_coa[l_ac].* = g_coa_t.*                                 
               #FUN-D30034--add--str--
               ELSE
                  CALL g_coa.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF                                                           
#              CLOSE i106_b_curl  #No.TQC-720019
                                                                                
               ROLLBACK WORK                                                    
               EXIT INPUT                            
            END IF                                                              
            LET l_ac_t = l_ac     #FUN-D30034 Add    
#           CLOSE i106_b_curl     #No.TQC-720019
                                                                                
            COMMIT WORK                                                         
                                  
 
        ON ACTION CONTROLN
            CALL i106_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLP                                                      
           CASE                                                                 
              WHEN INFIELD(coa03)                                         
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_cob"                                 
                   LET g_qryparam.default1 = g_coa[l_ac].coa03                  
                   CALL cl_create_qry() RETURNING g_coa[l_ac].coa03            
                   DISPLAY BY NAME g_coa[l_ac].coa03                           
                   NEXT FIELD coa03                              
              WHEN INFIELD(coa05)                                         
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_cna"                                 
                   LET g_qryparam.default1 = g_coa[l_ac].coa05                 
                   CALL cl_create_qry() RETURNING g_coa[l_ac].coa05            
                   DISPLAY BY NAME g_coa[l_ac].coa05                           
                   NEXT FIELD coa05                              
           END CASE
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(coa02) AND l_ac > 1 THEN
                LET g_coa[l_ac].* = g_coa[l_ac-1].*
                NEXT FIELD coa02
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
 #No.MOD-540158--begin                                                           
        ON ACTION CONTROLF                                                      
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913           
 #No.MOD-540158--end   
 
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT      
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
      #FUN-5B0043-begin
       UPDATE coa_file SET coamodu = g_user,coadate = g_today
        WHERE coa01 = g_coa01
      #FUN-5B0043-end
 
END FUNCTION
 
FUNCTION i106_coa05(p_cmd)                                                      
    DEFINE                                                                      
           p_cmd   LIKE type_file.chr1,   #No.FUN-680069 VARCHAR(1)
           l_acti  LIKE cob_file.cobacti                                        
                                                                                
    LET g_errno = ' '                                                           
    SELECT cnaacti                                                  
      INTO l_acti                                               
      FROM cna_file                                                             
     WHERE cna01 = g_coa[l_ac].coa05        
 
                                                                                
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'                      
         WHEN l_acti='N'           LET g_errno = '9028'                         
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'  
    END CASE                                                                    
END FUNCTION   
   
FUNCTION i106_coa03(p_cmd)                                                      
    DEFINE                                                                      
           p_cmd   LIKE type_file.chr1,   #No.FUN-680069 VARCHAR(1)
           l_cob02 LIKE cob_file.cob02,                                         
           l_cob04 LIKE cob_file.cob04,                                         
           l_acti  LIKE cob_file.cobacti                                        
                                                                                
    LET g_errno = ' '                                                           
    SELECT cob02,cob04,cobacti                                                  
      INTO l_cob02,l_cob04,l_acti                                               
      FROM cob_file                                                             
     WHERE cob01 = g_coa[l_ac].coa03                                            
                                                                                
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'                      
                                   LET l_cob02 = NULL                           
                                   LET l_cob04 = NULL                           
         WHEN l_acti='N'           LET g_errno = '9028'                         
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'  
    END CASE                                                                    
    IF p_cmd = 'd' OR cl_null(g_errno) THEN                                     
        LET g_coa[l_ac].cob02 = l_cob02                                         
        LET g_coa[l_ac].cob04 = l_cob04                                         
        DISPLAY g_coa[l_ac].cob02 TO cob02        
        DISPLAY g_coa[l_ac].cob04 TO cob04                         
    END IF                                                                      
END FUNCTION   
 
FUNCTION i106_b_askkey()
DEFINE
    l_wc   LIKE type_file.chr1000    #No.FUN-680069 VARCHAR(200)
 
    CONSTRUCT l_wc ON coa02,coa05,coa03,coa04    #螢幕上取條件
                 FROM s_coa[1].coa02,s_coa[1].coa05,
                      s_coa[1].coa03,s_coa[1].coa04
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    IF INT_FLAG THEN RETURN END IF
    CALL i106_b_fill(l_wc)
END FUNCTION
 
FUNCTION i106_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000   #No.FUN-680069 VARCHAR(200)
                                                                                
    LET g_sql ="SELECT coa02,coa05,coa03,cob02,cob04,coa04 ",
               "  FROM coa_file LEFT OUTER JOIN cob_file ON coa_file.coa03 = cob_file.cob01 ",
               " WHERE coa01 = '",g_coa01,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY coa02 "
    PREPARE i106_p2 FROM g_sql      #預備一下                                   
    DECLARE coa_curs CURSOR FOR i106_p2       
    CALL g_coa.clear()
    LET g_cnt = 1                                                               
    FOREACH coa_curs INTO g_coa[g_cnt].*   #單身 ARRAY 填充                     
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
    CALL g_coa.deleteElement(g_cnt)               
 
    LET g_rec_b = g_cnt - 1
END FUNCTION
 
FUNCTION i106_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_coa TO s_coa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #No.MOD-8B0018 modify                      
                                                                                
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )                 
                                                                                
      BEFORE ROW                                                                
         LET l_ac = ARR_CURR()                                                  
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      ON ACTION reproduce                                                       
         LET g_action_choice="reproduce"                                        
         EXIT DISPLAY           
 
      ON ACTION first                                                           
         CALL i106_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF                                                               
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY           
                                                                                
      ON ACTION previous                                                        
         CALL i106_fetch('P')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF                                                               
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY           
                                                                                
      ON ACTION jump                                                            
         CALL i106_fetch('/')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF                                         
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY           
      ON ACTION next                                                            
         CALL i106_fetch('N')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF                                                               
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY           
                                                                                
      ON ACTION last                                                            
         CALL i106_fetch('L')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF                         
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY           
      ON ACTION detail                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION output                                                          
         LET g_action_choice="output"                                           
         EXIT DISPLAY                                                           
      ON ACTION help                                                            
         LET g_action_choice="help"                                             
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION locale                                                          
         CALL cl_dynamic_locale()                                               
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION exit                                                            
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                       
      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION close                                                           
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION controlg                                                        
         LET g_action_choice="controlg"                                         
         EXIT DISPLAY                                                           
                               
      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE DISPLAY                                                       
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
                                                                                
      #FUN-4B0018
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0168  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)                               
                                                                                
END FUNCTION         
 
 
FUNCTION i106_copy()
DEFINE
    l_coa01,l_oldno1 LIKE coa_file.coa01,
    l_coa02          LIKE coa_file.coa02,
    l_coa03          LIKE coa_file.coa03,
    l_ima02          LIKE ima_file.ima02,
    l_cnt            LIKE type_file.num10,        #No.FUN-680069 INTEGER
    l_buf            LIKE coa_file.coa01          #No.FUN-680069 VARCHAR(40)
    
    IF s_shut(0) THEN RETURN END IF
    IF g_coa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
 
    LET g_before_input_done = FALSE                                             
    CALL i106_set_entry('a')                                                    
    CALL i106_set_no_entry('a')                                                 
    LET g_before_input_done = TRUE       
    CALL cl_set_head_visible("","YES")  #No.FUN-6B0033 
    INPUT l_coa01 WITHOUT DEFAULTS FROM coa01 
        AFTER FIELD coa01
            IF NOT cl_null(l_coa01) THEN
               #FUN-AA0059 ------------------------add start------------------------
               IF NOT s_chk_item_no(l_coa01,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET l_coa01 = NULL
                  NEXT FIELD coa01
               END IF 
               #FUN-AA0059 -----------------------add end------------------------
               SELECT COUNT(*) INTO l_cnt FROM ima_file                      
                WHERE ima_file.ima01 = l_coa01                                    
                   IF l_cnt = 0 THEN                                    
                      CALL cl_err(l_coa01,'mfg2729',0)
                       
                      LET l_coa01 = NULL
                   ELSE                
                      #-----MOD-960089---------
                      #CALL i106_coa01('d',l_coa01)
                      CALL i106_coa01('a',l_coa01)
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err(l_coa01,g_errno,0)
                         LET l_coa01 = NULL
                         NEXT FIELD coa01
                      END IF
                      #-----END MOD-960089-----
                   END IF
            END IF
 
        ON ACTION CONTROLP                                                      
           CASE                                                                 
              WHEN INFIELD(coa01)
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()                                       
                #   LET g_qryparam.form ="q_ima6"                                 
                #   LET g_qryparam.default1 = l_coa01                           
                #   CALL cl_create_qry() RETURNING l_coa01                     
                   CALL q_sel_ima(FALSE, "q_imai6", "", l_coa01, "", "", "", "" ,"",'' )  RETURNING l_coa01
#FUN-AA0059 --End--
                   DISPLAY l_coa01 TO coa01 
                   NEXT FIELD coa01                     
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
    IF INT_FLAG OR l_coa01 IS NULL THEN
       LET INT_FLAG = 0 RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM coa_file WHERE coa01 = l_coa01 
    IF g_cnt > 0 THEN
       CALL cl_err(l_coa01,-239,0) RETURN
    END IF
    LET l_buf = l_coa01 CLIPPED
    DROP TABLE z
    SELECT * FROM coa_file
     WHERE coa01 = g_coa01 
      INTO TEMP z
    UPDATE z
        SET coa01=l_coa01
    INSERT INTO coa_file
        SELECT * FROM z
    IF SQLCA.sqlcode THEN
#        CALL cl_err(l_buf,SQLCA.sqlcode,0) #No.TQC-660045
         CALL cl_err3("ins","coa_file",l_buf,"",SQLCA.sqlcode,"","",1)                   #NO.TQC-660045
        RETURN
    END IF
    LET g_coa01=l_coa01
    CALL i106_show()
 
END FUNCTION
 
 
FUNCTION i106_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    sr              RECORD
        coa01       LIKE coa_file.coa01,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,   #品名
        coa05       LIKE coa_file.coa05,   #客戶的產品編號
        coa03       LIKE coa_file.coa03,   #客戶的產品編號
        cob02       LIKE cob_file.cob02,   #規格
        cob021      LIKE cob_file.cob021,   #規格
        cob04       LIKE cob_file.cob04,   #最近訂單日
        coa04       LIKE coa_file.coa04
                    END RECORD,
    l_name          LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) #External(Disk) file name
    l_za05          LIKE cob_file.cob01          #No.FUN-680069 VARCHAR(40)
DEFINE 
    l_cna02         LIKE cna_file.cna02,         #No.FUN-770006
    l_sql           LIKE type_file.chr1000       #No.FUN-770006
 
    CALL cl_del_data(l_table)                    #No.FUN-770006
 
    IF cl_null(g_wc) AND NOT cl_null(g_coa01) AND NOT cl_null(g_coa[l_ac].coa02) THEN 
       LET g_wc=" coa01='",g_coa01,"'",
            " AND coa02='",g_coa[l_ac].coa02,"'"
    END IF
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('acoi106') RETURNING l_name        #No.FUN-770006
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql= "SELECT UNIQUE coa01,ima02,ima021,coa05,coa03,cob02,cob021,cob04,coa04 ",
               "  FROM coa_file LEFT OUTER JOIN ima_file ON coa_file.coa01=ima_file.ima01 LEFT OUTER JOIN cob_file ON coa_file.coa03 = cob_file.cob01 ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY coa01,coa03 "
    PREPARE i106_p1 FROM g_sql                # RUNTIME 編譯
    IF SQLCA.sqlcode THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,0) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
           
        
    END IF
    DECLARE i106_co                         # CURSOR
        CURSOR FOR i106_p1
 
#   START REPORT i106_rep TO l_name         #No.FUN-770006
 
    FOREACH i106_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#       OUTPUT TO REPORT i106_rep(sr.*)     #No.FUN-770006
#No.FUN-770006 --start--
        SELECT cna02 INTO l_cna02 FROM cna_file                             
               WHERE cna01=sr.coa05                                                
        IF SQLCA.sqlcode THEN                                               
           LET l_cna02 = ' '                                                
        END IF                        
        EXECUTE insert_prep USING sr.coa01,sr.ima02,sr.ima021,sr.coa05,l_cna02,
                                  sr.coa03,sr.cob02,sr.cob021,sr.cob04,sr.coa04
#No.FUN-770006 --end--
    END FOREACH
 
#   FINISH REPORT i106_rep                  #No.FUN-770006
 
    CLOSE i106_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)       #No.FUN-770006
#No.FUN-770006 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'coa01,coa02,coa05,coa03,coa04')
            RETURNING g_wc
       LET g_str = g_wc
    END IF
    LET g_str = g_str
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('acoi106','acoi106',l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT i106_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
    l_sw            LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
    l_sw1           LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
    l_i             LIKE type_file.num5,         #No.FUN-680069 SMALLINT
    l_cna02         LIKE cna_file.cna02,
    sr              RECORD
        coa01       LIKE coa_file.coa01,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,   #品名
        coa05       LIKE coa_file.coa05,   #客戶的產品編號
        coa03       LIKE coa_file.coa03,   #客戶的產品編號
        cob02       LIKE cob_file.cob02,   #規格
        cob021      LIKE cob_file.cob021,   #規格
        cob04       LIKE cob_file.cob04,   #最近訂單日
        coa04       LIKE coa_file.coa04
                    END RECORD,
    l_first         LIKE type_file.num5         #No.FUN-680069 SMALLINT
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.coa01,sr.coa05,sr.coa03
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED               
                  LET g_pageno = g_pageno + 1                                   
                  LET pageno_total = PAGENO USING '<<<',"/pageno"               
                  PRINT g_head CLIPPED,pageno_total                             
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                     
            PRINT ' '                                                           
            PRINT g_dash[1,g_len]   
 
            LET l_trailer_sw = 'y'
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[38] CLIPPED,
                  g_x[33] CLIPPED,g_x[40] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[39] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
            PRINT g_dash1
 
        ON EVERY ROW
            SELECT cna02 INTO l_cna02 FROM cna_file
            WHERE cna01=sr.coa05
            IF SQLCA.sqlcode THEN 
               LET l_cna02 = ' ' 
            END IF
            PRINT COLUMN g_c[31],sr.coa01 CLIPPED,
                  COLUMN g_c[32],sr.ima02 CLIPPED,
                  COLUMN g_c[38],sr.ima021 CLIPPED,
                  COLUMN g_c[33],sr.coa05 CLIPPED,
                  COLUMN g_c[40],l_cna02  CLIPPED,
                  COLUMN g_c[34],sr.coa03 CLIPPED,
                  COLUMN g_c[35],sr.cob02 CLIPPED,
                  COLUMN g_c[39],sr.cob021 CLIPPED,
                  COLUMN g_c[36],sr.cob04 CLIPPED,
                  COLUMN g_c[37],sr.coa04 USING "###########&.&&&"
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-770006 --end--
FUNCTION i106_set_entry(p_cmd)                                                  
DEFINE   p_cmd   LIKE type_file.chr1     #No.FUN-680069 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                            
      CALL cl_set_comp_entry("coa01",TRUE)                                      
   END IF                                                                       
                                                                                
END FUNCTION    
 
FUNCTION i106_set_no_entry(p_cmd)                                               
DEFINE   p_cmd   LIKE type_file.chr1     #No.FUN-680069 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN  
      CALL cl_set_comp_entry("coa01",FALSE)                                     
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                          
