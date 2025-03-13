# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aici018.4gl
# Descriptions...: ICD料件光罩資料維護作業 
# Date & Author..: 07/11/15 By ve007        #FUN-7B0016 
# Modify... .....: No.FUN-830073 08/02/24 By ve007   debug 7B0016
# Modify... .....: No.TQC-910024 09/01/19 By jan解決ics01--ics05不能手動錄入的問題
# Modify... .....: No.TQC-910051 09/01/21 By jan修正 檢查程序時發現的錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0025 10/11/11 By chenying 修改料號開窗改為CALL q_sel_ima()
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 11/12/26 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C20183 12/02/20 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ima02     LIKE ima_file.ima02,
       g_ima021    LIKE ima_file.ima021,
       g_ics       RECORD LIKE ics_file.*,
       g_ics_t     RECORD LIKE ics_file.*,  #備份舊值
       g_ics00_t   LIKE ics_file.ics00,     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件  
       g_sql       STRING                  #組 sql 用    
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL        
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        
DEFINE g_msg                 LIKE type_file.chr1000       
DEFINE g_curs_index          LIKE type_file.num10         
DEFINE g_row_count           LIKE type_file.num10         #總筆數        
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        
DEFINE g_no_ask              LIKE type_file.num5          #是否開啟指定筆視窗  
DEFINE l_table               STRING    
DEFINE g_ics14_t             LIKE ics_file.ics14          #FUN-910088--add--
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
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
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 mark
     
   LET g_sql= "ics00.ics_file.ics00,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "ics01.ics_file.ics01,",
              "ics02.ics_file.ics02,",
              "ima02a.ima_file.ima02,",
              "ics03.ics_file.ics03,",
              "ics04.ics_file.ics04,",
              "ics05.ics_file.ics05,",
              "ecb17.ecb_file.ecb17,",
              "ics06.ics_file.ics06,",
              "occ02.occ_file.occ02,",
              "ics20.ics_file.ics20,",
              "ima02b.ima_file.ima02,",
              "ics07.ics_file.ics07,",
              "pmc02.pmc_file.pmc02,",
              "ics08.ics_file.ics08,",
              "ics09.ics_file.ics09,",
              "ics10.ics_file.ics10,",
              "occ02a.occ_file.occ02,",
              "ics11.ics_file.ics11,",
              "ics12.ics_file.ics12,",
              "ics13.ics_file.ics13,",
              "ics14.ics_file.ics14,",
              "ics15.ics_file.ics15,",
              "ics16.ics_file.ics16,",
              "ics17.ics_file.ics17,",
              "ics18.ics_file.ics18,",
              "ics19.ics_file.ics19,",
              "icspost.ics_file.icspost"
    LET l_table=cl_prt_temptable("aici018",g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,",
              "        ?,?,?,?,?,?,?,?,?,?,",
              "        ?,?,?,?,?,?,?,?,?,?)"
              
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
      CALL cl_err("insert_prep:",status,1)  
    END IF 
     
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   INITIALIZE g_ics.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM ics_file WHERE ics00 = ? FOR UPDATE "       
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i018_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i018_w WITH FORM "aic/42f/aici018"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i018_menu()
 
   CLOSE WINDOW i018_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i018_curs()
 
    CLEAR FORM
    LET g_ima02 = NULL
    LET g_ima021 = NULL
    DISPLAY g_ima02 TO FORMONLY.ima02
    DISPLAY g_ima021 TO FORMONLY.ima021
    INITIALIZE g_ics.* TO NULL      
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        ics00,icspost,
        ics01,ics02,ics03,ics04,ics05,ics06,ics20,ics07,ics08,ics09,
        ics10,ics11,ics12,ics13,ics14,ics15,ics16,ics17,ics18,ics19
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
               WHEN INFIELD(ics00)
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.form = "q_ima24"
               #  LET g_qryparam.state = "c"
               #  LET g_qryparam.default1 = g_ics.ics00
               #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima( TRUE, "q_ima24","",g_ics.ics00,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO ics00
                 NEXT FIELD ics00
               WHEN INFIELD(ics01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ice"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ics.ics01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ics01
                 NEXT FIELD ics01
               WHEN INFIELD(ics02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ice"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ics.ics02
                 LET g_qryparam.multiret_index=2
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ics02
                 NEXT FIELD ics02
               WHEN INFIELD(ics03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ice"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ics.ics03
                 LET g_qryparam.multiret_index=3
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ics03
                 NEXT FIELD ics03
               WHEN INFIELD(ics04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ice"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ics.ics04
                 LET g_qryparam.multiret_index=3
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ics04
                 NEXT FIELD ics04
               WHEN INFIELD(ics05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ice"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ics.ics05
                 LET g_qryparam.multiret_index=5
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ics05
                 NEXT FIELD ics05
               WHEN INFIELD(ics06)                                               
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form = 'q_occ'                                  
                 LET g_qryparam.default1 = g_ics.ics06                          
                 LET g_qryparam.state  = "c"                                    
                 CALL cl_create_qry() RETURNING g_qryparam.multiret             
                 DISPLAY g_qryparam.multiret TO ics06                           
                 NEXT FIELD ics06
               WHEN INFIELD(ics10)                                               
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form = 'q_occ'                                  
                 LET g_qryparam.default1 = g_ics.ics10                         
                 LET g_qryparam.state  = "c"                                    
                 CALL cl_create_qry() RETURNING g_qryparam.multiret             
                 DISPLAY g_qryparam.multiret TO ics10                           
                 NEXT FIELD ics10  
               WHEN INFIELD(ics20)
#FUN-AB0025---------mod---------------str----------------                                               
#                CALL cl_init_qry_var()                                         
#                LET g_qryparam.form = 'q_ima'                                  
#                LET g_qryparam.default1 = g_ics.ics20                          
#                LET g_qryparam.state  = "c" 
#                LET g_qryparam.where=" imaicd05='3' "                                   
#                CALL cl_create_qry() RETURNING g_qryparam.multiret             
                 CALL q_sel_ima(TRUE, "q_ima"," imaicd05='3' ",g_ics.ics20,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AB0025--------mod---------------end----------------
                 DISPLAY g_qryparam.multiret TO ics20                          
                 NEXT FIELD ics20
               WHEN INFIELD(ics07)                                               
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form = 'q_pmc'                                  
                 LET g_qryparam.default1 = g_ics.ics07                          
                 LET g_qryparam.state  = "c"                                    
                 CALL cl_create_qry() RETURNING g_qryparam.multiret             
                 DISPLAY g_qryparam.multiret TO ics07                           
                 NEXT FIELD ics07          
               WHEN INFIELD(ics12)                                               
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form = 'q_azi'                                  
                 LET g_qryparam.default1 = g_ics.ics12                          
                 LET g_qryparam.state  = "c"                                    
                 CALL cl_create_qry() RETURNING g_qryparam.multiret             
                 DISPLAY g_qryparam.multiret TO ics12                           
                 NEXT FIELD ics12
               WHEN INFIELD(ics14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ics14
                   NEXT FIELD ics14 
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
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imagrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #群組權限
    #        LET g_wc = g_wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ics_file.ics00 FROM ics_file,imaicd_file ", # 組合出 SQL 指令
              " WHERE ics00 = imaicd00 AND imaicd05 = '3'",
              " AND  ",g_wc CLIPPED, " ORDER BY ics00"
    PREPARE i018_prepare FROM g_sql
    DECLARE i018_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i018_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ics_file,imaicd_file WHERE ics00 = imaicd00  AND imaicd05 = '3' AND ",g_wc CLIPPED
    PREPARE i018_precount FROM g_sql
    DECLARE i018_count CURSOR FOR i018_precount
END FUNCTION
 
 
FUNCTION i018_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ics.* LIKE ics_file.*
    LET g_ics00_t = NULL
    LET g_ics14_t = NULL                         #FUN-910088--add--
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ics.ics05 = NULL 
        LET g_ics.ics11 = 0               
        LET g_ics.ics13 = 0               
        LET g_ics.ics15 = 0               
        LET g_ics.ics16 = 1               
        LET g_ics.icspost = 'N'
        CALL i018_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_ics.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ics.ics00 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ics_file VALUES(g_ics.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ics_file",g_ics.ics00,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        ELSE
            SELECT ics00 INTO g_ics.ics00 FROM ics_file
                     WHERE ics00 = g_ics.ics00
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i018_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000       
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
        
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i018_a()
            END IF
            
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i018_q()
            END IF
            
        ON ACTION next
            CALL i018_fetch('N')
            
        ON ACTION previous
            CALL i018_fetch('P')
            
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i018_u()
            END IF
        
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i018_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i018_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN 
              CALL i018_out()                                
            END IF
        
        ON ACTION p019
           LET l_cmd= "aicp019 '",g_ics.ics00,"'"
           CALL cl_cmdrun(l_cmd)
               
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i018_fetch('/')
        ON ACTION first
            CALL i018_fetch('F')
        ON ACTION last
            CALL i018_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
        
        ON ACTION conf
           IF cl_chk_act_auth() THEN                                            
              CALL i018_confirm()                                                                                                
           END IF  
        
        ON ACTION notconf
           IF cl_chk_act_auth() THEN                                            
              CALL i018_notconfirm()                                                                                                
           END IF
           
        ON ACTION about         
         CALL cl_about()      
 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document    
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_ics.ics00 IS NOT NULL THEN
                 LET g_doc.column1 = "ics00"
                 LET g_doc.value1 = g_ics.ics00
                 CALL cl_doc()
              END IF
           END IF
 
          &include "qry_string.4gl" 
    END MENU
    CLOSE i018_cs
END FUNCTION
 
FUNCTION i018_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   LIKE type_file.chr1,          
            l_n       LIKE type_file.num5,
            l_ima31   LIKE ima_file.ima31         
   DEFINE   l_case    STRING
    
 
   DISPLAY BY NAME
      g_ics.ics00,
      g_ics.icspost,
      g_ics.ics01,g_ics.ics02,g_ics.ics03,
      g_ics.ics04,g_ics.ics05,g_ics.ics06,
      g_ics.ics20,g_ics.ics07,g_ics.ics08,
      g_ics.ics09,g_ics.ics10,g_ics.ics11,
      g_ics.ics12,g_ics.ics13,g_ics.ics14,
      g_ics.ics15,g_ics.ics16,g_ics.ics17,
      g_ics.ics18,g_ics.ics19
 
   INPUT g_ics.ics00,
      g_ics.icspost,
      g_ics.ics01,g_ics.ics02,g_ics.ics03,
      g_ics.ics04,g_ics.ics05,g_ics.ics06,
      g_ics.ics20,g_ics.ics07,g_ics.ics08,
      g_ics.ics09,g_ics.ics10,g_ics.ics11,
      g_ics.ics12,g_ics.ics13,g_ics.ics14,
      g_ics.ics15,g_ics.ics16,g_ics.ics17,
      g_ics.ics18,g_ics.ics19
      WITHOUT DEFAULTS
    FROM  ics00, icspost,ics01,ics02,ics03,
          ics04,ics05,ics06,ics20,ics07,ics08,
          ics09,ics10,ics11,ics12,ics13,ics14,ics15,
          ics16,ics17,ics18,ics19
      
 
      BEFORE INPUT
          
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i018_set_entry(p_cmd)
          CALL i018_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
            
 
      AFTER FIELD ics00
        IF cl_null(g_ics.ics00) THEN
           NEXT FIELD ics00
        END IF
        IF NOT cl_null(g_ics.ics00) THEN
          #FUN-AA0059 -----------------add start------------------
           IF NOT s_chk_item_no(g_ics.ics00,'') THEN
              CALL cl_err('',g_errno,1)
              LET g_ics.ics00 = g_ics00_t
              NEXT FIELD ics00
           END IF
          #FUN-AA0059 ----------------add end--------------------   
           SELECT COUNT(*) INTO l_n FROM ima_file,imaicd_file
            WHERE ima01 = g_ics.ics00
              AND ima01 = imaicd00 
              AND imaicd05 = '3'
              IF l_n = 0 THEN
                 CALL cl_err('','mfg1201',0)
                 NEXT FIELD ics00
              END IF
           IF p_cmd='a' OR (p_cmd = 'u' AND g_ics.ics00!=g_ics00_t)THEN 
             SELECT COUNT(*) INTO l_n FROM ics_file
                WHERE ics00 = g_ics.ics00
             IF l_n > 0 THEN
                CALL cl_err(g_ics.ics00,-239,1)
                LET g_ics.ics00 = g_ics00_t
                NEXT FIELD ics00
             END IF
           END IF            
           CALL i018_ics00('a')
           SELECT ima31 INTO l_ima31 FROM ima_file 
            WHERE ima01=g_ics.ics00
          LET g_ics.ics14 = l_ima31 
       #FUN-910088--add--start--
          CALL i018_ics13_check() 
          LET g_ics.ics15 = s_digqty(g_ics.ics15,g_ics.ics14)      #TQC-C20183--add--
          LET g_ics14_t = g_ics.ics14   
          DISPLAY BY NAME g_ics.ics15                              #TQC-C20183--add--
       #FUN-910088--add--end--
        END IF

     #TQC-C20183--add--start--
      AFTER FIELD ics13
         CALL i018_ics13_check()
         DISPLAY BY NAME g_ics.ics13
     #TQC-C20183--add--end--
        
      AFTER FIELD ics01
          IF NOT cl_null(g_ics.ics01) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_ics.ics01 != g_ics_t.ics01) THEN
             #TQC-910024--BEGIN--
             #SELECT COUNT(*) INTO l_n FROM ice_file 
             # WHERE  ice01=g_ics.ics01
             #   AND  ice02=g_ics.ics02
             #   AND  ice03=g_ics.ics03
             #   AND  ice14=g_ics.ics04
             #   AND  ice05=g_ics.ics05   
             # IF l_n=0 THEN 
               IF NOT i018_chk_ics(g_ics.ics01,g_ics.ics02,g_ics.ics03,
                               g_ics.ics04,g_ics.ics05) THEN
             #TQC-910024--END--
                  CALL cl_err('','aic-004',0)
                  NEXT FIELD ics01
               END IF 
            END IF 
          END IF 
        
      AFTER FIELD ics02
          IF NOT cl_null(g_ics.ics02) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_ics.ics02 != g_ics_t.ics02) THEN
             #No.TQC-910024--BEGIN
             #SELECT COUNT(*) INTO l_n FROM ice_file 
             # WHERE  ice01=g_ics.ics01
             #   AND  ice02=g_ics.ics02
             #   AND  ice03=g_ics.ics03
             #   AND  ice14=g_ics.ics04
             #   AND  ice05=g_ics.ics05   
             # IF l_n=0 THEN 
               IF NOT i018_chk_ics(g_ics.ics01,g_ics.ics02,g_ics.ics03,
                               g_ics.ics04,g_ics.ics05) THEN
               #No.TQC-910024--END--
                  CALL cl_err('','aic-004',0)
                  NEXT FIELD ics02
               END IF 
            END IF 
          END IF
          
     AFTER FIELD ics03
          IF NOT cl_null(g_ics.ics03) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_ics.ics03 != g_ics_t.ics03) THEN
            #No.TQC-910024--BEGIN--
             #SELECT COUNT(*) INTO l_n FROM ice_file 
             # WHERE  ice01=g_ics.ics01
             #   AND  ice02=g_ics.ics02
             #   AND  ice03=g_ics.ics03
             #   AND  ice14=g_ics.ics04
             #   AND  ice05=g_ics.ics05   
             # IF l_n=0 THEN 
               IF NOT i018_chk_ics(g_ics.ics01,g_ics.ics02,g_ics.ics03,
                               g_ics.ics04,g_ics.ics05) THEN
               #No.TQC-910024--END--
                  CALL cl_err('','aic-004',0)
                  NEXT FIELD ics03
               END IF 
            END IF 
          END IF
          
      AFTER FIELD ics04
          IF NOT cl_null(g_ics.ics04) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_ics.ics04 != g_ics_t.ics04) THEN
             #No.TQC-910024--BEGIN-- 
             #SELECT COUNT(*) INTO l_n FROM ice_file 
             # WHERE  ice01=g_ics.ics01
             #   AND  ice02=g_ics.ics02
             #   AND  ice03=g_ics.ics03
             #   AND  ice14=g_ics.ics04
             #   AND  ice05=g_ics.ics05   
             # IF l_n=0 THEN 
               IF NOT i018_chk_ics(g_ics.ics01,g_ics.ics02,g_ics.ics03,
                               g_ics.ics04,g_ics.ics05) THEN
               #No.TQC-910024--END--
                  CALL cl_err('','aic-004',0)
                  NEXT FIELD ics04
               END IF 
            END IF 
          END IF 
          
      AFTER FIELD ics05
          IF NOT cl_null(g_ics.ics05) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_ics.ics05 != g_ics_t.ics05) THEN
             #No.TQC-910024--BEGIN-- 
             #SELECT COUNT(*) INTO l_n FROM ice_file 
             # WHERE  ice01=g_ics.ics01
             #   AND  ice02=g_ics.ics02
             #   AND  ice03=g_ics.ics03
             #   AND  ice14=g_ics.ics04
             #   AND  ice05=g_ics.ics05   
             # IF l_n=0 THEN 
               IF NOT i018_chk_ics(g_ics.ics01,g_ics.ics02,g_ics.ics03,
                               g_ics.ics04,g_ics.ics05) THEN
               #No.TQC-910024--END--
                  CALL cl_err('','aic-004',0)
                  NEXT FIELD ics05
               END IF 
            END IF 
          END IF 
          
      AFTER FIELD ics06
          IF NOT cl_null(g_ics.ics06) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_ics.ics06 != g_ics_t.ics06) THEN
             SELECT COUNT(*) INTO l_n FROM occ_file 
              WHERE  occ01=g_ics.ics06
                AND  occacti='Y'   
              IF l_n=0 THEN 
                CALL cl_err('','aic-004',0)
                NEXT FIELD ics06
              END IF 
            END IF 
          END IF 
          
      AFTER FIELD ics20
          IF NOT cl_null(g_ics.ics20) THEN
           #FUN-A0059 ---------------add start--------------
            IF NOT s_chk_item_no(g_ics.ics20,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ics20
            END IF
           #FUN-AA0059 ---------------add end---------------
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_ics.ics20 != g_ics_t.ics20) THEN
             SELECT COUNT(*) INTO l_n FROM ima_file,imaicd_file    #TQC-910051 add imaicd_file 
             #WHERE  ima01=g_ics.ics20 #TQC-910051
              WHERE  ima01=imaicd00    #TQC-910051
                AND  imaicd00=g_ics.ics20 #TQC-910051
                AND  imaacti='Y'
                AND  imaicd05='3'   
              IF l_n=0 THEN 
                CALL cl_err('','aic-004',0)
                NEXT FIELD ics20
              END IF 
            END IF 
          END IF
          
       AFTER FIELD ics07
          IF NOT cl_null(g_ics.ics07) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_ics.ics07 != g_ics_t.ics07) THEN
             SELECT COUNT(*) INTO l_n FROM pmc_file 
              WHERE  pmc01=g_ics.ics07
                AND  pmcacti='Y'
                AND  pmc30 IN('2','3')   
              IF l_n=0 THEN 
                CALL cl_err('','aic-004',0)
                NEXT FIELD ics07
              END IF 
            END IF 
          END IF
       
       AFTER FIELD ics10
         IF NOT cl_null(g_ics.ics10) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_ics.ics10 != g_ics_t.ics10) THEN
               SELECT COUNT(*)INTO l_n FROM occ_file
                  WHERE occ01=g_ics.ics10
               IF l_n=0 THEN
                 CALL cl_err('','aic-004',0)
                 NEXT FIELD ics10
               END IF      
            END IF 
         END IF 
                 
       AFTER FIELD ics12  
          IF NOT cl_null(g_ics.ics12) THEN
              CALL i018_ics12('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD ics12
              END IF
           END IF                                                                             
#        CALL i018_ics01() RETURN l_n
          	       
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_ics.ics00 IS NULL THEN
               DISPLAY BY NAME g_ics.ics00
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD ics00
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(ics00) THEN
            LET g_ics.* = g_ics_t.*
            CALL i018_show()
            NEXT FIELD ics00
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(ics00) 
#FUN-AA0059 --Begin--
           #  CALL cl_init_qry_var()
           #  LET g_qryparam.form     = "q_ima24"
           #  CALL FGL_DIALOG_SETBUFFER(g_ics.ics00)
           #  CALL cl_create_qry() RETURNING g_ics.ics00 
             CALL q_sel_ima(FALSE, "q_ima24", "", g_ics.ics00, "", "", "", "" ,"",'' )  RETURNING g_ics.ics00 
#FUN-AA0059 --End--
             DISPLAY BY NAME g_ics.ics00 
             CALL i018_ics00('d')
             NEXT FIELD ics00
           WHEN INFIELD(ics01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ice"
#             LET g_qryparam.default1 = g_ics.ics01
              CALL cl_create_qry() RETURNING g_ics.ics01,g_ics.ics02,g_ics.ics03,g_ics.ics04,g_ics.ics05
              CALL FGL_DIALOG_SETBUFFER(g_ics.ics01)
              CALL i018_ics05('d')
#             DISPLAY BY NAME g_ics.ics01,g_ics.ics02,g_ics.ics03,g_ics.ics04,g_ics.ics05
              NEXT FIELD ics01
           WHEN INFIELD(ics02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ice"
#             LET g_qryparam.default1 = g_ics.ics02
              CALL cl_create_qry() RETURNING g_ics.ics01,g_ics.ics02,g_ics.ics03,g_ics.ics04,g_ics.ics05
              CALL FGL_DIALOG_SETBUFFER(g_ics.ics02)
              CALL i018_ics05('d')
#             DISPLAY BY NAME g_ics.ics01,g_ics.ics02,g_ics.ics03,g_ics.ics04,g_ics.ics05
              NEXT FIELD ics02
           WHEN INFIELD(ics03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ice"
#             LET g_qryparam.default1 = g_ics.ics03
              CALL cl_create_qry() RETURNING g_ics.ics01,g_ics.ics02,g_ics.ics03,g_ics.ics04,g_ics.ics05
              CALL FGL_DIALOG_SETBUFFER(g_ics.ics03)
               CALL i018_ics05('d')
#             DISPLAY BY NAME g_ics.ics01,g_ics.ics02,g_ics.ics03,g_ics.ics04,g_ics.ics05
              NEXT FIELD ics03
           WHEN INFIELD(ics04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ice"
#             LET g_qryparam.default1 = g_ics.ics04
              CALL cl_create_qry() RETURNING g_ics.ics01,g_ics.ics02,g_ics.ics03,g_ics.ics04,g_ics.ics05
              CALL FGL_DIALOG_SETBUFFER(g_ics.ics04)
              CALL i018_ics05('d')
#             DISPLAY BY NAME g_ics.ics01,g_ics.ics02,g_ics.ics03,g_ics.ics04,g_ics.ics05
              NEXT FIELD ics04
           WHEN INFIELD(ics05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ice"
#             LET g_qryparam.default1 = g_ics.ics05
              CALL cl_create_qry() RETURNING g_ics.ics01,g_ics.ics02,g_ics.ics03,g_ics.ics04,g_ics.ics05
              CALL FGL_DIALOG_SETBUFFER(g_ics.ics05)
              CALL i018_ics05('d')
#             DISPLAY BY NAME g_ics.ics01,g_ics.ics02,g_ics.ics03,g_ics.ics04,g_ics.ics05
              NEXT FIELD ics05
            WHEN INFIELD(ics06)                                                  
              CALL cl_init_qry_var()                                            
              LET g_qryparam.form = "q_occ"                                     
              CALL cl_create_qry() RETURNING g_ics.ics06
              CALL FGL_DIALOG_SETBUFFER(g_ics.ics06)
              CALL i018_ics06('d')
              NEXT FIELD ics06
            WHEN INFIELD(ics20)                                                 
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()                                            
            #  LET g_qryparam.form = "q_ima24"  
            #  LET g_qryparam.where = "ima_file.imaacti = 'Y' "                                 
            #  CALL cl_create_qry() RETURNING g_ics.ics20
            #  CALL FGL_DIALOG_SETBUFFER(g_ics.ics20)
              CALL q_sel_ima(FALSE, "q_ima24", "ima_file.imaacti = 'Y'", g_ics.ics20, "", "", "", "" ,"",'' )  RETURNING g_ics.ics20
#FUN-AA0059 --End--
              CALL i018_ics20('d')                        
              NEXT FIELD ics20
            WHEN INFIELD(ics10)                                                 
              CALL cl_init_qry_var()                                            
              LET g_qryparam.form = "q_occ"                                    
              CALL cl_create_qry() RETURNING g_ics.ics10
              CALL FGL_DIALOG_SETBUFFER(g_ics.ics10)
              CALL i018_ics10('d')                        
              NEXT FIELD ics10    
            WHEN INFIELD(ics07)                                                 
              CALL cl_init_qry_var()                                            
              LET g_qryparam.form = "q_pmc"                                     
              CALL cl_create_qry() RETURNING g_ics.ics07
              CALL FGL_DIALOG_SETBUFFER(g_ics.ics07)
              CALL i018_ics07('d')                        
              NEXT FIELD ics07
            WHEN INFIELD(ics12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_azi'
              LET g_qryparam.default1 = g_ics.ics12
              CALL cl_create_qry() RETURNING g_ics.ics12
              CALL FGL_DIALOG_SETBUFFER(g_ics.ics12)
              NEXT FIELD ics12  
           OTHERWISE
              EXIT CASE
           END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
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
 
FUNCTION i018_ics00(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_imaacti  LIKE ima_file.imaacti,
   l_imaicd05 LIKE imaicd_file.imaicd05  
 
   LET g_errno=''
   SELECT ima02,ima021,imaacti,imaicd05
     INTO g_ima02,g_ima021,l_imaacti,l_imaicd05
     FROM ima_file,imaicd_file
    WHERE ima01=g_ics.ics00
      AND imaicd00 = ima01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='mfg1201'
                                LET g_ima02=NULL
                                LET g_ima021=NULL
       WHEN l_imaicd05 != '3'   LET g_errno = 'aic-800'
       WHEN l_imaacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY g_ima02 TO FORMONLY.ima02
      DISPLAY g_ima021 TO FORMONLY.ima021
   END IF
END FUNCTION
 
FUNCTION i018_ics01()
DEFINE l_n   LIKE type_file.num5
 
    SELECT COUNT(*) INTO l_n 
     FROM ice_file 
    WHERE ice01 = g_ics.ics01 
      AND ice02 = g_ics.ics02 
      AND ice03 = g_ics.ics03 
      AND ice14 = g_ics.ics04 
      AND ice05 = g_ics.ics05
      IF SQLCA.sqlcode THEN
         CALL cl_err('',SQLCA.sqlcode,0)
         RETURN
      END IF
      RETURN l_n
END FUNCTION
 
FUNCTION i018_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_ics.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i018_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i018_count
    FETCH i018_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i018_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ics.ics00,SQLCA.sqlcode,0)
        INITIALIZE g_ics.* TO NULL
    ELSE
        CALL i018_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i018_fetch(p_flics)
    DEFINE
        p_flics         LIKE type_file.chr1           
 
    CASE p_flics
        WHEN 'N' FETCH NEXT     i018_cs INTO g_ics.ics00
        WHEN 'P' FETCH PREVIOUS i018_cs INTO g_ics.ics00
        WHEN 'F' FETCH FIRST    i018_cs INTO g_ics.ics00
        WHEN 'L' FETCH LAST     i018_cs INTO g_ics.ics00
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
            FETCH ABSOLUTE g_jump i018_cs INTO g_ics.ics00
            LET g_no_ask = FALSE         
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ics.ics00,SQLCA.sqlcode,0)
        INITIALIZE g_ics.* TO NULL  
        RETURN
    ELSE
      CASE p_flics
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF
 
    SELECT * INTO g_ics.* FROM ics_file    # 重讀DB,因TEMP有不被更新特性
       WHERE ics00 = g_ics.ics00
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ics_file",g_ics.ics00,"",SQLCA.sqlcode,"","",0)  
    ELSE
        CALL i018_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i018_show()
    LET g_ics.ics00 = g_ics.ics00
    
    LET g_ics_t.* = g_ics.*
    DISPLAY BY NAME
      g_ics.ics00,
      g_ics.icspost,
      g_ics.ics01,g_ics.ics02,g_ics.ics03,
      g_ics.ics04,g_ics.ics05,g_ics.ics06,
      g_ics.ics20,g_ics.ics07,g_ics.ics08,
      g_ics.ics09,g_ics.ics10,g_ics.ics11,
      g_ics.ics12,g_ics.ics13,g_ics.ics14,
      g_ics.ics15,g_ics.ics16,g_ics.ics17,
      g_ics.ics18,g_ics.ics19
    CALL i018_ics00('d')  
    CALL i018_ics05('d')
    CALL i018_ics06('d')
    CALL i018_ics20('d')
    CALL i018_ics07('d') 
    CALL i018_ics10('d') 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i018_u()
    IF g_ics.ics00 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    IF g_ics.icspost='Y' THEN
       CALL cl_err('','aap-730',0)
       RETURN
    END IF 
       
    SELECT * INTO g_ics.* FROM ics_file WHERE ics00=g_ics.ics00
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ics00_t = g_ics.ics00
    LET g_ics14_t = g_ics.ics14   #FUN-910088--add--
    BEGIN WORK
 
    OPEN i018_cl USING g_ics.ics00
    IF STATUS THEN
       CALL cl_err("OPEN i018_cl:", STATUS, 1)
       CLOSE i018_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i018_cl INTO g_ics.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ics.ics00,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL i018_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i018_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ics.*=g_ics_t.*
            CALL i018_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ics_file SET ics_file.* = g_ics.*    
            WHERE ics00 = g_ics00_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ics_file",g_ics.ics00,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i018_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i018_r()
    IF g_ics.ics00 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    IF g_ics.icspost='Y' THEN
       CALL cl_err('','aap-730',0)
       RETURN
    END IF 
    
    BEGIN WORK
 
    OPEN i018_cl USING g_ics.ics00
    IF STATUS THEN
       CALL cl_err("OPEN i018_cl:", STATUS, 0)
       CLOSE i018_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i018_cl INTO g_ics.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ics.ics00,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i018_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ics00"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ics.ics00      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ics_file WHERE ics00 = g_ics.ics00
       CLEAR FORM
       OPEN i018_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i018_cs
          CLOSE i018_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i018_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i018_cs
          CLOSE i018_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i018_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i018_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 
          CALL i018_fetch('/')
       END IF
    END IF
    CLOSE i018_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i018_copy()
    DEFINE
        l_newno         LIKE ics_file.ics00,
        l_oldno         LIKE ics_file.ics00,
        p_cmd     LIKE type_file.chr1,          
        l_input   LIKE type_file.chr1           
 
    IF g_ics.ics00 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i018_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM ics00
 
        AFTER FIELD ics00
           IF l_newno IS NOT NULL THEN
             #FUN-AA0059 ------------------add start------------
              IF NOT s_chk_item_no(l_newno,'') THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ics00
              END IF
             #FUN-AA0059 -----------------add end--------------------
              SELECT count(*) INTO g_cnt FROM ics_file
                  WHERE ics00 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD ics00
              END IF 
           END IF 
           
        ON ACTION controlp                        # 沿用所有欄位
           IF INFIELD(ics00) THEN
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()
            #  LET g_qryparam.form = "q_ima24"
            #  LET g_qryparam.default1 = g_ics.ics00
            #  CALL cl_create_qry() RETURNING l_newno
              CALL q_sel_ima(FALSE, "q_ima24", "", g_ics.ics00, "", "", "", "" ,"",'' )  RETURNING l_newno
#FUN-AA0059 --End--
              DISPLAY l_newno TO ics00                
              CALL i018_ics00('d')
              NEXT FIELD ics00
           END IF
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
        DISPLAY g_ics.ics00 TO ics00
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM ics_file
        WHERE ics00 = g_ics.ics00
        INTO TEMP x
    UPDATE x
        SET ics00=l_newno   #資料鍵值
    INSERT INTO ics_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","ics_file",g_ics.ics00,"",SQLCA.sqlcode,"","",0)  
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_ics.ics00
        LET g_ics.ics00 = l_newno
        SELECT ics_file.* INTO g_ics.* FROM ics_file
               WHERE ics00 = l_newno
        CALL i018_u()
        #SELECT ics_file.* INTO g_ics.* FROM ics_file  #FUN-C30027
        #       WHERE ics00 = l_oldno                  #FUN-C30027
    END IF
    #LET g_ics.ics00 = l_oldno                         #FUN-C30027
    CALL i018_show()
END FUNCTION
 
FUNCTION i018_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("ics00",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i018_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("ics00",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i018_ics06(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_occ02   LIKE occ_file.occ02,
           l_occ42   LIKE occ_file.occ42
                         
   LET g_errno=' '                                                              
   SELECT occ02,occ42 INTO l_occ02,l_occ42  FROM occ_file                   
         WHERE occ01=g_ics.ics06                                             
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'  
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       DISPLAY l_occ02 TO FORMONLY.ics06_desc
       LET g_ics.ics12=l_occ42
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i018_ics20(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_ima02   LIKE ima_file.ima02,
           l_imaacti LIKE ima_file.imaacti 
                   
   LET g_errno=' '                                                              
   SELECT imaacti,ima02 INTO l_imaacti,l_ima02  FROM ima_file,imaicd_file #TQC-910051                   
         WHERE ima01=g_ics.ics20
           AND ima01=imaicd00    #TQC-910051
           AND imaicd05='3'                                            
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                         
        WHEN l_imaacti='N'        LET g_errno='9028'                            
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       DISPLAY l_ima02 TO FORMONLY.ics20_desc
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i018_ics07(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_pmc03   LIKE pmc_file.pmc03
                                         
   LET g_errno=' ' 
   SELECT pmc03 INTO l_pmc03  FROM pmc_file                   
         WHERE pmc01=g_ics.ics07                                             
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                         
                               
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       DISPLAY l_pmc03 TO FORMONLY.ics07_desc
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i018_ics10(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_occ02   LIKE occ_file.occ02
                                         
   LET g_errno=' ' 
   SELECT occ02 INTO l_occ02  FROM occ_file                   
         WHERE occ01=g_ics.ics10                                            
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                         
                               
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       DISPLAY l_occ02 TO FORMONLY.ics10_desc
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i018_ics05(p_cmd)                                                      
DEFINE     p_cmd     LIKE type_file.chr1,                                       
           l_ecd02   LIKE ecd_file.ecd02,
           l_ima02   LIKE ima_file.ima02
                                         
   LET g_errno=' ' 
   SELECT ecd02 INTO l_ecd02  FROM ecd_file                   
         WHERE ecd01=g_ics.ics05 
   SELECT ima02 INTO l_ima02  FROM ima_file
         WHERE ima01=g_ics.ics00                                                
                                                                                
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                         
                               
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'   
   END CASE                                                                     
                                                                                
   IF cl_null(g_errno) OR p_cmd='d' THEN                                        
       DISPLAY l_ecd02 TO FORMONLY.ics05_desc
       DISPLAY l_ima02 TO FORMONLY.ics02_desc
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION i018_confirm()
  IF cl_null(g_ics.ics00)  THEN                      
     CALL cl_err('',-400,0)                                                     
     RETURN                                                                     
  END IF                                                                       
    IF g_ics.icspost="Y" THEN                                                 
       CALL cl_err("",'aim-041',1)                                                   
       RETURN                                                                   
    END IF                                                                          
        IF cl_confirm('amm-049') THEN                                           
            BEGIN WORK                                                          
            UPDATE ics_file                                                     
            SET icspost="Y"                                                   
            WHERE ics00=g_ics.ics00
            
        IF SQLCA.sqlcode THEN                                                   
            CALL cl_err3("upd","ics_file",g_ics.ics00,"",SQLCA.sqlcode,"","icspost",1)
            ROLLBACK WORK                                                       
        ELSE                                                                    
            COMMIT WORK                                                         
            LET g_ics.icspost="Y"                                             
            DISPLAY BY NAME g_ics.icspost                                   
        END IF                                                                  
        END IF                                                                                                                                      
END FUNCTION
 
FUNCTION i018_notconfirm()
  IF cl_null(g_ics.ics00)  THEN                      
     CALL cl_err('',-400,0)                                                     
     RETURN                                                                     
  END IF                                                                       
    IF g_ics.icspost="N" THEN                                                 
       CALL cl_err("",9020,1)                                                   
       RETURN                                                                   
    END IF                                                                          
        IF cl_confirm('amm-050') THEN                                           
            BEGIN WORK                                                          
            UPDATE ics_file                                                     
            SET icspost="N"                                                   
            WHERE ics00=g_ics.ics00
            
        IF SQLCA.sqlcode THEN                                                   
            CALL cl_err3("upd","ics_file",g_ics.ics00,"",SQLCA.sqlcode,"","icspost",1)
            ROLLBACK WORK                                                       
        ELSE                                                                    
            COMMIT WORK                                                         
            LET g_ics.icspost="N"                                             
            DISPLAY BY NAME g_ics.icspost                                   
        END IF                                                                  
        END IF                                                                                                                                      
END FUNCTION
 
FUNCTION i018_out()
  DEFINE  l_i          LIKE type_file.chr1, 
          sr           RECORD
               ics00   LIKE ics_file.ics00,
               ima02   LIKE ima_file.ima02,
               ima021  LIKE ima_file.ima021,
               ics01   LIKE ics_file.ics01,
               ics02   LIKE ics_file.ics02,
               ima02a  LIKE ima_file.ima02,
               ics03   LIKE ics_file.ics03,
               ics04   LIKE ics_file.ics04,
               ics05   LIKE ics_file.ics05,
               ecb17   LIKE ecb_file.ecb17,
               ics06   LIKE ics_file.ics06,
               occ02   LIKE occ_file.occ02,
               ics20   LIKE ics_file.ics20,
               ima02b  LIKE ima_file.ima02,
               ics07   LIKE ics_file.ics07,
               pmc02   LIKE pmc_file.pmc02,
               ics08   LIKE ics_file.ics08,
               ics09   LIKE ics_file.ics09,
               ics10   LIKE ics_file.ics10,
               occ02a  LIKE occ_file.occ02,
               ics11   LIKE ics_file.ics11,
               ics12   LIKE ics_file.ics12,
               ics13   LIKE ics_file.ics13,
               ics14   LIKE ics_file.ics14,
               ics15   LIKE ics_file.ics15,
               ics16   LIKE ics_file.ics16,
               ics17   LIKE ics_file.ics17,
               ics18   LIKE ics_file.ics18,
               ics19   LIKE ics_file.ics19,
               icspost LIKE ics_file.icspost
                       END RECORD, 
          g_str        STRING 
 
   IF g_wc IS NULL THEN                                                        
       CALL cl_err('',-400,0)                                                   
       RETURN                                                                   
    END IF                                                                      
    CALL cl_wait()                                                              
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang                 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aici005'
  
    LET g_sql="SELECT ics_file.ics00, ima021, ima02, ics_file.ics01, ics_file.ics02, 
               (select ima02 from ima_file where ima01=ics02) as ics02_desc,
               ics_file.ics03, ics_file.ics04, ics_file.ics05,ecb_file.ecb17,
               ics_file.ics06, occ_file.occ02,ics_file.ics20,
               (select ima02 from ima_file where ima01=ics20) as ics20_desc, 
               ics_file.ics07,pmc_file.pmc02,ics_file.ics08, ics_file.ics09, 
               ics_file.ics10, (select occ02 from occ_file where occ01=ics10)as ics10_desc, 
               ics_file.ics11, ics_file.ics12, ics_file.ics13, ics_file.ics14, 
               ics_file.ics15, ics_file.ics16, ics_file.ics17, ics_file.ics18, 
               ics_file.ics19, ics_file.icspost 
               FROM ics_file,ima_file, ecb_file,occ_file ,pmc_file
               WHERE ( ics_file.ics00 = ima_file.ima01 ) AND
                     ( ics_file.ics05 = ecb_file.ecb06 ) AND
                     ( ics_file.ics06 = occ_file.occ01 ) AND
                     ( ics_file.ics07 = pmc_file.pmc01 ) AND  ",g_wc CLIPPED
    PREPARE i018_p1 FROM g_sql               
    DECLARE i018_co                        
         CURSOR FOR i018_p1                 
    CALL cl_del_data(l_table)
     FOREACH i018_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        EXECUTE insert_prep USING sr.ics00,sr.ima02,sr.ima021,sr.ics01,sr.ics02,
                                  sr.ima02a,sr.ics03,sr.ics04,sr.ics05,sr.ecb17,
                                  sr.ics06,sr.occ02,sr.ics20,sr.ima02b,sr.ics07,
                                  sr.pmc02,sr.ics08,sr.ics09,sr.ics10,sr.occ02a,
                                  sr.ics11,sr.ics12,sr.ics13,sr.ics14,sr.ics15,
                                  sr.ics16,sr.ics17,sr.ics18,sr.ics19,sr.icspost
     END FOREACH                              
    IF g_zz05 = 'Y' THEN                                                       
        CALL cl_wcchp(g_wc,'ics01,ics02,ics03,ics04,ics05,ics06,ics07,ics08,ics09,ics10,
                            ics11,ics12,ics13,ics14,ics15,ics16,ics17,ics18,ics19,ics20,icspost')                    
        RETURNING g_wc                                                          
     END IF
    LET g_str = g_wc
    LET g_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
    CALL cl_prt_cs3('aici018','aici018',g_sql,g_str)   
 
END FUNCTION
 
FUNCTION i018_ics12(p_cmd)  #幣別
DEFINE
    p_cmd           LIKE type_file.chr1,    
    l_aziacti       LIKE azi_file.aziacti
 
    LET g_errno = ' '
    SELECT aziacti INTO l_aziacti
        FROM azi_file
        WHERE azi01 = g_ics.ics12
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
         WHEN l_aziacti='N'        LET g_errno='9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#TQC-910024--BEGIN--
FUNCTION i018_chk_ics(p_ics01,p_ics02,p_ics03,p_ics04,p_ics05)
DEFINE p_ics01      LIKE ics_file.ics01
DEFINE p_ics02      LIKE ics_file.ics02
DEFINE p_ics03      LIKE ics_file.ics03
DEFINE p_ics04      LIKE ics_file.ics04
DEFINE p_ics05      LIKE ics_file.ics05
DEFINE l_sql        STRING
DEFINE l_n          LIKE type_file.num5
 
   LET l_sql = " SELECT COUNT(*) FROM ice_file ",
               "  WHERE  1=1 "
   IF p_ics01 IS NOT NULL THEN
      LET l_sql=l_sql CLIPPED,
               "    AND ice01 = '",p_ics01,"'"
   END IF
   IF p_ics02 IS NOT NULL THEN
      LET l_sql=l_sql CLIPPED,
               "    AND ice02 = '",p_ics02,"'"
   END IF
   IF p_ics03 IS NOT NULL THEN
      LET l_sql=l_sql CLIPPED,
               "    AND ice03 = '",p_ics03,"'"
   END IF
   IF p_ics04 IS NOT NULL THEN
      LET l_sql=l_sql CLIPPED,
               "    AND ice14 = '",p_ics04,"'"
   END IF
   IF p_ics05 IS NOT NULL THEN
      LET l_sql=l_sql CLIPPED,
               "    AND ice05 = '",p_ics05,"'"
   END IF
   PREPARE count_ics_pre FROM l_sql
   DECLARE count_ics_cur CURSOR FOR count_ics_pre
   OPEN count_ics_cur
   FETCH count_ics_cur INTO l_n
   IF l_n > 0 THEN
      RETURN 1
   ELSE
      RETURN 0
   END IF
END FUNCTION
#TQC-910024--END--
#No.FUN-7B0016
#No.FUn-830073

#FUN-910088--add--start--
FUNCTION i018_ics13_check()
   IF NOT cl_null(g_ics.ics13) AND NOT cl_null(g_ics.ics14) THEN
      IF cl_null(g_ics14_t) OR cl_null(g_ics_t.ics13) OR g_ics14_t != g_ics.ics14 OR g_ics_t.ics13 != g_ics.ics13 THEN 
         LET g_ics.ics13 = s_digqty(g_ics.ics13,g_ics.ics14)
         DISPLAY BY NAME g_ics.ics13
      END IF
   END IF
END FUNCTION
#FUN-910088--add--end--
