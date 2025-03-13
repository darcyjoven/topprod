# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aeci202.4gl
# Descriptions...: 產品結構元件資料維護作業
# Date & Author..: NO.FUN-A80054 10/09/10 By jan
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:FUN-D40103 13/05/15 By fengrui 添加庫位有效性檢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_edd   RECORD LIKE edd_file.*,
    g_edd_t RECORD LIKE edd_file.*,
    g_edd_o RECORD LIKE edd_file.*,
    g_edd01_t LIKE edd_file.edd01,
    g_edd011_t LIKE edd_file.edd011,
    g_edd013_t LIKE edd_file.edd013,
    g_edd02_t LIKE edd_file.edd02,
    g_edd03_t LIKE edd_file.edd03,
    g_edd04_t LIKE edd_file.edd04,
    g_edd29_t LIKE edd_file.edd29,
    g_edd10_t LIKE edd_file.edd10,
    g_edd25_t LIKE edd_file.edd25,
    g_edd26_t LIKE edd_file.edd26,
    g_ima08_b LIKE ima_file.ima08,
    g_ima37_b LIKE ima_file.ima37,
    g_ima70_b LIKE ima_file.ima70,
    g_ima25_b LIKE ima_file.ima25,
    g_ima63_b LIKE ima_file.ima63,
    g_ima86_b LIKE ima_file.ima86,
    g_ima63_fac LIKE ima_file.ima63_fac,
    g_argv1     LIKE edd_file.edd01,     
    g_argv2     LIKE edd_file.edd011,      
    g_argv3     LIKE edd_file.edd013, 
    g_argv4     LIKE edd_file.edd03,     
    g_sw        LIKE type_file.num5,   
    g_ecd03     LIKE ecd_file.ecd03,
    g_factor    LIKE pml_file.pml09,   
    g_wc,g_sql  string,              
    g_ima08     LIKE ima_file.ima08,
    g_ima70     LIKE ima_file.ima70  
DEFINE g_forupd_sql          STRING                  
DEFINE g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1    
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_msg           LIKE ze_file.ze03          
DEFINE   g_row_count     LIKE type_file.num10       
DEFINE   g_curs_index    LIKE type_file.num10      
DEFINE   g_jump          LIKE type_file.num10      
DEFINE   g_no_ask        LIKE type_file.num5       
 
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

   IF g_sma.sma541='N' OR cl_null(g_sma.sma541) THEN
      CALL cl_err('','aec-056',1)
      EXIT PROGRAM
   END IF

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_edd.* TO NULL
    INITIALIZE g_edd_t.* TO NULL
    INITIALIZE g_edd_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM edd_file WHERE edd01 = ? AND edd011 = ? AND edd013 = ? ",
                       "   AND edd02 = ?  AND edd03= ? AND edd04= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i202_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
 
    OPEN WINDOW i202_w WITH FORM "aec/42f/aeci202"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("edd14,edd15,edd16,edd19,group05",FALSE)
    
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3) 
    LET g_argv4 = ARG_VAL(4) 
    
    
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL i202_q()
    END IF
    IF g_sma.sma542='N' THEN 
       CALL cl_err('','abm-213',1)
       CLOSE WINDOW i202_w             
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time           
    END IF     
      LET g_action_choice=""
      CALL i202_menu()
 
    CLOSE WINDOW i202_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i202_curs()
DEFINE  l_cmd     LIKE type_file.chr1000  
    CLEAR FORM
    DISPLAY BY NAME  g_edd.edd01
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_sql="SELECT edd01,edd011,edd013,edd02,edd03,edd04 ", 
                      "  FROM edd_file ",                      # 組合出 SQL 指令
                      " WHERE edd01 ='",g_argv1,"'",
                      "   AND edd011= ",g_argv2,
                      "   AND edd013= ",g_argv3,
                      "   AND edd03= '",g_argv4,"' "
     
            IF g_argv2 IS NOT NULL AND g_argv2 != ' ' THEN
               LET  g_sql = g_sql  CLIPPED,
                         " AND (edd04 <='", g_today,"'"," OR edd04 IS NULL )",
                         " AND (edd05 > '",g_today,"'"," OR edd05 IS NULL )"
            END IF
            CASE g_sma.sma65
              WHEN '1'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edd01,edd011,edd013,edd02,edd03,edd04" 
              WHEN '2'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edd01,edd011,edd013,edd03,edd02,edd04" 
              WHEN '3'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edd01,edd011,edd013,edd13,edd02,edd03,edd04" 
              OTHERWISE LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edd01,edd011,edd013,edd02,edd03,edd04"
            END CASE
   ELSE
     INITIALIZE g_edd.* TO NULL    
     CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
              edd01,edd011,edd013,edd02,edd03,edd04,edd05,edd10,edd10_fac, 
              edd10_fac2, edd06,edd07,edd08,edd23,edd11,edd13,
              edd27,edd09,edd18,edd28,edd25,edd26,edd24,
              eddmodu,edddate,eddcomm    
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(edd01) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_eda"   
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_edd.edd01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO edd01
                     NEXT FIELD edd01                                                              
                  WHEN INFIELD(edd03) #料件主檔
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.state = "c"
                  #   LET g_qryparam.default1 = g_edd.edd03
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima",g_edd.edd03,"","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO edd03
                     NEXT FIELD edd03
                  WHEN INFIELD(edd09) #作業主檔
                     CALL q_ecd(TRUE,TRUE,g_edd.edd09)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO edd09
                     NEXT FIELD edd09
                  WHEN INFIELD(edd10) #單位檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_edd.edd10
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO edd10
                     NEXT FIELD edd10
                  WHEN INFIELD(edd25) #倉庫
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imfd"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_edd.edd25
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO edd25
                     NEXT FIELD edd25
                  WHEN INFIELD(edd26) #儲位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imfe"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_edd.edd26
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO edd26
                     NEXT FIELD edd26
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
            LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, NULL)
 
             LET g_sql="SELECT edd01,edd011,edd013,edd02,edd03,edd04 ",
                       " FROM edd_file ",                      
                       " WHERE ",g_wc CLIPPED
            CASE g_sma.sma65
              WHEN '1'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edd01,edd011,edd013,edd02,edd03,edd04" 
              WHEN '2'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edd01,edd011,edd013,edd03,edd02,edd04"
              WHEN '3'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edd01,edd011,edd013,edd13,edd02,edd03,edd04"
              OTHERWISE LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edd01,edd011,edd013,edd02,edd03,edd04"
            END CASE
   END IF
 
    PREPARE i202_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i202_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i202_prepare
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_sql =
                "SELECT COUNT(*) FROM edd_file WHERE edd01 ='",g_argv1,"'",
                                               " AND edd03 ='",g_argv4,"'",  
                                               " AND edd011='",g_argv2,"' ",
                                               " AND edd013='",g_argv3,"' " 
    ELSE LET g_sql=
                "SELECT COUNT(*) FROM edd_file WHERE ",g_wc CLIPPED
    END IF
    PREPARE i202_precount FROM g_sql
    DECLARE i202_count CURSOR FOR i202_precount
END FUNCTION
 
FUNCTION i202_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i202_q()
            END IF
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i202_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i202_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()       

        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION first
            CALL i202_fetch('F')
         ON ACTION next
            CALL i202_fetch('N')
         ON ACTION jump
            CALL i202_fetch('/')
         ON ACTION previous
            CALL i202_fetch('P')
         ON ACTION last
            CALL i202_fetch('L')
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about       
         CALL cl_about()     
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION CLOSE 
             LET INT_FLAG=FALSE 	
            LET g_action_choice = "exit"
            EXIT MENU
 
          ON ACTION related_document                
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_edd.edd01 IS NOT NULL THEN
                  LET g_doc.column1 = "edd01"
                  LET g_doc.value1  = g_edd.edd01
                  LET g_doc.column2 = "edd02"
                  LET g_doc.value2  = g_edd.edd02
                  LET g_doc.column3 = "edd03"
                  LET g_doc.value3  = g_edd.edd03
                  LET g_doc.column4 = "edd04"
                  LET g_doc.value4  = g_edd.edd04
                  LET g_doc.column5= "edd011" 
                  LET g_doc.value5 = g_edd.edd011
                  CALL cl_doc()
               END IF
            END IF

      &include "qry_string.4gl"
    END MENU
    CLOSE i202_curs
END FUNCTION
  
FUNCTION i202_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    
        l_cmd           LIKE type_file.chr1000,
        l_dir1          LIKE type_file.chr1,   
        l_n             LIKE type_file.num5,    
        l_ima08         LIKE ima_file.ima08,
        l_edd01         LIKE edd_file.edd01,
        l_ime09         LIKE ime_file.ime09,
        l_qpa           LIKE edd_file.edd06,
        l_code          LIKE type_file.num5,   
        l_flag          LIKE type_file.chr1,   
        l_cnt           LIKE type_file.num5,   
        l_bmd02  LIKE bmd_file.bmd02 

    DISPLAY BY NAME
      g_edd.edd01,g_edd.edd011,g_edd.edd013,g_edd.edd02,
      g_edd.edd03,g_edd.edd04,
      g_edd.edd05,g_edd.edd10,g_edd.edd10_fac,g_edd.edd10_fac2,
      g_edd.edd06,g_edd.edd07,g_edd.edd08,g_edd.edd23,
      g_edd.edd11,g_edd.edd13,g_edd.edd27,
      g_edd.edd09,g_edd.edd18,
      g_edd.edd28,g_edd.edd25,g_edd.edd26,g_edd.edd24,
      g_edd.eddmodu,g_edd.edddate,g_edd.eddcomm

 
    INPUT BY NAME
      g_edd.edd01,g_edd.edd011,g_edd.edd013,g_edd.edd02,g_edd.edd03,
      g_edd.edd04,g_edd.edd05,g_edd.edd10,g_edd.edd10_fac,g_edd.edd10_fac2,
      g_edd.edd06,g_edd.edd07,g_edd.edd08,g_edd.edd23,
      g_edd.edd11,g_edd.edd13,g_edd.edd27,
      g_edd.edd09,g_edd.edd18,
      g_edd.edd28,g_edd.edd25,g_edd.edd26,g_edd.edd24,
      g_edd.eddmodu,g_edd.edddate,g_edd.eddcomm
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i202_set_entry(p_cmd)
            CALL i202_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD edd01                 
            IF g_argv1 IS NOT NULL AND g_argv1 != ' '
               AND g_edd.edd01 != g_edd_t.edd01 THEN
               CALL cl_err('','mfg2627',0)
               NEXT FIELD edd01
            END IF
            IF NOT cl_null(g_edd.edd01) THEN
              IF p_cmd = "a" OR                    # 若輸入或更改且改KEY 
                 (p_cmd = "u" AND g_edd.edd01 != g_edd_t.edd01) THEN
                 LET l_cnt=0
                 SELECT COUNT(*) INTO l_cnt FROM eda_file
                  WHERE eda01=g_edd.edd01
                    AND edaconf='Y'
                 IF l_cnt = 0 THEN CALL cl_err('','aec-057',1) NEXT FIELD edd01 END IF
                 CALL i202_edd01('a')
                 IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_edd.edd01,g_errno,0) 
                  LET g_edd.edd01=g_edd_t.edd01
                  DISPLAY BY NAME g_edd.edd01
                  NEXT FIELD edd01
               END IF 
              END IF  
            END IF
            
        AFTER FIELD edd011
           IF NOT cl_null(g_edd.edd011) AND NOT cl_null(g_edd.edd01) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file
               WHERE edb01=g_edd.edd01 AND edb02=g_edd.edd011
                 AND eda01=edb01 AND edaconf='Y'
              IF l_cnt = 0 THEN CALL cl_err('','aec-058',1) NEXT FIELD edd011 END IF
           END IF
       
       AFTER FIELD edd013
           IF NOT cl_null(g_edd.edd011) AND NOT cl_null(g_edd.edd01)
              AND NOT cl_null(g_edd.edd013) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM edc_file,eda_file
               WHERE edc01=g_edd.edd01 AND edc02=g_edd.edd011
                 AND edc03=g_edd.edd013
                 AND eda01=edc01 AND edaconf='Y'
              IF l_cnt = 0 THEN CALL cl_err('','abm-215',1) NEXT FIELD edd011 END IF
           END IF    
        
 
        BEFORE FIELD edd02                        #default 項次
            IF g_edd.edd02 IS NULL OR
               g_edd.edd02 = 0 THEN
                SELECT max(edd02)+1
                   INTO g_edd.edd02
                   FROM edd_file
                   WHERE edd01 = g_edd.edd01
                IF g_edd.edd02 IS NULL
                   THEN LET g_edd.edd02 = 1
                END IF
                DISPLAY BY NAME g_edd.edd02
            END IF
 
        BEFORE FIELD edd03
	        IF g_sma.sma60 = 'Y'		# 若須分段輸入
	           THEN CALL s_inp5(10,15,g_edd.edd03) RETURNING g_edd.edd03
	           DISPLAY BY NAME g_edd.edd03
	        END IF
          LET g_edd03_t = g_edd.edd03
 
        AFTER FIELD edd03                  #元件料號
            IF NOT cl_null(g_edd.edd03) THEN
              #FUN-AA0059 -------------add start------------
               IF NOT s_chk_item_no(g_edd.edd03,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_edd.edd03=g_edd_t.edd03
                  DISPLAY BY NAME g_edd.edd03
                  NEXT FIELD edd03
               END IF 
              #FUN-AA0059 -------------addd end------------ 
               CALL i202_edd03(p_cmd)   #必需讀取料件主檔
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_edd.edd03,g_errno,0) 
                  LET g_edd.edd03=g_edd_t.edd03
                  DISPLAY BY NAME g_edd.edd03
                  NEXT FIELD edd03
               END IF
            END IF
 
        AFTER FIELD edd04                        #check 是否重複
            IF NOT cl_null(g_edd.edd04) THEN
               IF g_edd.edd01 != g_edd01_t OR g_edd01_t IS NULL
                  OR g_edd.edd02 != g_edd02_t OR g_edd02_t IS NULL
                  OR g_edd.edd03 != g_edd03_t OR g_edd03_t IS NULL
                  OR g_edd.edd04 != g_edd04_t OR g_edd04_t IS NULL 
                  OR g_edd.edd011 != g_edd011_t OR g_edd011_t IS NULL 
                  OR g_edd.edd013 != g_edd013_t OR g_edd013_t IS NULL THEN  
                   SELECT count(*) INTO g_cnt FROM edd_file
                       WHERE edd01 = g_edd.edd01 AND edd02 = g_edd.edd02
                         AND edd03 = g_edd.edd03 AND edd04 = g_edd.edd04
                         AND edd011 = g_edd.edd011 AND edd013=g_edd.edd013
                   IF g_cnt > 0 THEN   #資料重複
                       LET g_msg = g_edd.edd01 CLIPPED,'+',g_edd.edd02
                                   CLIPPED,'+',g_edd.edd03 CLIPPED,'+',
                                   g_edd.edd04,'+',g_edd.edd011,'+',g_edd.edd013 
                       CALL cl_err(g_msg,-239,0)
                       LET g_edd.edd02 = g_edd02_t
                       LET g_edd.edd03 = g_edd03_t
                       LET g_edd.edd04 = g_edd04_t
                       LET g_edd.edd011 = g_edd011_t 
                       LET g_edd.edd013 = g_edd011_t 
                       DISPLAY BY NAME g_edd.edd01
                       DISPLAY BY NAME g_edd.edd02
                       DISPLAY BY NAME g_edd.edd03
                       DISPLAY BY NAME g_edd.edd04
                       DISPLAY BY NAME g_edd.edd011 
                       DISPLAY BY NAME g_edd.edd013
                       NEXT FIELD edd01
                   END IF
               END IF
               CALL i202_bdate(p_cmd)     #生效日
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_edd.edd04,g_errno,0)
                  LET g_edd.edd04 = g_edd_t.edd04
                  DISPLAY BY NAME g_edd.edd04
                  NEXT FIELD edd04
               END IF
            END IF
 
        AFTER FIELD edd05   #check失效日小於生效日
            IF NOT cl_null(g_edd.edd05) THEN
               IF g_edd.edd05 < g_edd.edd04 THEN
                  CALL cl_err(g_edd.edd05,'mfg2604',0)
                  NEXT FIELD edd04
               END IF
            END IF
            CALL i202_edate(p_cmd)     #生效日
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_edd.edd05,g_errno,0)
               LET g_edd.edd05 = g_edd_t.edd05
               DISPLAY BY NAME g_edd.edd05
               NEXT FIELD edd04
            END IF
 
        AFTER FIELD edd06    #組成用量不可小於零
           IF g_edd.edd06 <= 0 THEN
              CALL cl_err(g_edd.edd06,'mfg2614',0)
              LET g_edd.edd06 = g_edd_o.edd06
              DISPLAY BY NAME g_edd.edd06
              NEXT FIELD edd06
           END IF
           LET g_edd_o.edd06 = g_edd.edd06
 
        AFTER FIELD edd07    #底數不可小於等於零
            IF g_edd.edd07 <= 0  THEN
               CALL cl_err(g_edd.edd07,'mfg2615',0)
               LET g_edd.edd07 = g_edd_o.edd07
               DISPLAY BY NAME g_edd.edd07
               NEXT FIELD edd07
            END IF
            LET g_edd_o.edd07 = g_edd.edd07
 
        AFTER FIELD edd08    #損耗率
            IF g_edd.edd08 < 0 OR g_edd.edd08 > 100 THEN
               CALL cl_err(g_edd.edd08,'mfg0013',0)
               LET g_edd.edd08 = g_edd_o.edd08
               DISPLAY BY NAME g_edd.edd08
               NEXT FIELD edd08
            END IF
            LET g_edd_o.edd08 = g_edd.edd08
 
        AFTER FIELD edd10   #發料單位
          IF NOT cl_null(g_edd.edd10) THEN
             IF (g_edd_o.edd10 IS NULL) OR (g_edd.edd10 != g_edd_o.edd10)
             THEN SELECT gfe01 FROM gfe_file
                   WHERE gfe01 = g_edd.edd10 AND
                         gfeacti IN ('Y','y')  
                   IF SQLCA.sqlcode != 0 THEN
                      CALL cl_err3("sel","gfe_file",g_edd.edd10,"","mfg2605","","",1)  
                      LET g_edd.edd10 = g_edd_o.edd10
                      DISPLAY BY NAME g_edd.edd10
                      LET g_edd.edd10_fac = g_edd_o.edd10_fac
                      DISPLAY BY NAME g_edd.edd10_fac
                      LET g_edd.edd10_fac2= g_edd_o.edd10_fac2
                      DISPLAY BY NAME g_edd.edd10_fac2
                      NEXT FIELD edd10
                   ELSE IF g_edd.edd10 != g_ima25_b
                        THEN CALL s_umfchk(g_edd.edd03,g_edd.edd10,
                                            g_ima25_b)
                              RETURNING g_sw,g_edd.edd10_fac #發料/庫存單位
                              IF g_sw = '1' THEN
                                 CALL cl_err(g_edd.edd10,'mfg2721',0)
                                 LET g_edd.edd10 = g_edd_o.edd10
                                 DISPLAY BY NAME g_edd.edd10
                                 LET g_edd.edd10_fac = g_edd_o.edd10_fac
                                 DISPLAY BY NAME g_edd.edd10_fac
                                 LET g_edd.edd10_fac2= g_edd_o.edd10_fac2
                                 DISPLAY BY NAME g_edd.edd10_fac2
                                 NEXT FIELD edd10
                              END IF
                        ELSE LET g_edd.edd10_fac  = 1
                        END  IF
                        IF g_edd.edd10 != g_ima86_b  #發料/成本單位
                        THEN CALL s_umfchk(g_edd.edd03,g_edd.edd10,
                                             g_ima86_b)
                             RETURNING g_sw,g_edd.edd10_fac2
                             IF g_sw = '1' THEN
                                CALL cl_err(g_edd.edd03,'mfg2722',0)
                                LET g_edd.edd10 = g_edd_o.edd10
                                DISPLAY BY NAME g_edd.edd10
                                LET g_edd.edd10_fac = g_edd_o.edd10_fac
                                DISPLAY BY NAME g_edd.edd10_fac
                                LET g_edd.edd10_fac2 = g_edd_o.edd10_fac2
                                DISPLAY BY NAME g_edd.edd10_fac2
                                NEXT FIELD edd10
                             END IF
                        ELSE LET g_edd.edd10_fac2 = 1
                        END IF
                   END IF
             END IF
          END IF
          DISPLAY BY NAME g_edd.edd10_fac
          DISPLAY BY NAME g_edd.edd10_fac2
          LET g_edd_o.edd10 = g_edd.edd10
          LET g_edd_o.edd10_fac = g_edd.edd10_fac
          LET g_edd_o.edd10_fac2 = g_edd.edd10_fac2
 
        AFTER FIELD edd10_fac   #發料/料件庫存轉換率
            IF g_edd.edd10_fac <= 0
               THEN CALL cl_err(g_edd.edd10_fac,'mfg1322',0)
                    LET g_edd.edd10_fac = g_edd_o.edd10_fac
                    DISPLAY BY NAME g_edd.edd10_fac
                    NEXT FIELD edd10_fac
            END IF
            LET g_edd_o.edd10_fac = g_edd.edd10_fac
 
        AFTER FIELD edd10_fac2   #發料/料件成本轉換率
            IF g_edd.edd10_fac2 <= 0
               THEN CALL cl_err(g_edd.edd10_fac2,'mfg1322',0)
                    LET g_edd.edd10_fac2 = g_edd_o.edd10_fac2
                    DISPLAY BY NAME g_edd.edd10_fac2
                    NEXT FIELD edd10_fac2
            END IF
            LET g_edd_o.edd10_fac2 = g_edd.edd10_fac2
 
        AFTER FIELD edd09    #作業編號
             #有使用製程(sma54='Y')
             IF NOT cl_null(g_edd.edd09) THEN
                SELECT COUNT(*) INTO g_cnt FROM ecd_file
                 WHERE ecd01=g_edd.edd09
                IF g_cnt=0 THEN
                   CALL cl_err('sel ecd_file',100,0)
                   NEXT FIELD edd09
                END IF
             END IF
 
        AFTER FIELD edd27  #軟體物件
            LET g_edd_o.edd27 = g_edd.edd27
 
          AFTER FIELD edd18     #投料時距
             LET l_dir1 = 'U'
             IF g_edd.edd18 < 0 THEN
                CALL cl_err(g_edd.edd18,'aim-223',0)
                NEXT FIELD edd18
             END IF
             IF cl_null(g_edd.edd18)
             THEN LET g_edd.edd18 = 0
                  DISPLAY BY NAME g_edd.edd18
             END IF
 
        AFTER FIELD edd23    #選中率
            IF g_edd.edd23 < 0 OR g_edd.edd23 > 100
               THEN CALL cl_err(g_edd.edd23,'mfg0013',0)
                    LET g_edd.edd23 = g_edd_o.edd23
                    DISPLAY BY NAME g_edd.edd23
                    NEXT FIELD edd23
            END IF
            LET g_edd_o.edd23 = g_edd.edd23
 
       AFTER FIELD edd28
            IF g_edd.edd28 < 0 OR g_edd.edd28 > 100
               THEN CALL cl_err(g_edd.edd28,'mfg0013',0)
                    LET g_edd.edd28 = g_edd_o.edd28
                    DISPLAY BY NAME g_edd.edd28
                    NEXT FIELD edd28
            END IF
            LET g_edd_o.edd28 = g_edd.edd28

          AFTER FIELD edd25     # Warehouse
            IF NOT cl_null(g_edd.edd25) THEN
                 CALL i202_edd25('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_edd.edd25,g_errno,0)
                    LET g_edd.edd25 = g_edd_o.edd25
                    DISPLAY BY NAME g_edd.edd25
                    NEXT FIELD edd25
                 END IF
                 IF NOT s_imfchk1(g_edd.edd03,g_edd.edd25)
                    THEN CALL cl_err(g_edd.edd25,'mfg9036',0)
                         NEXT FIELD edd25
                 END IF
                 CALL s_stkchk(g_edd.edd25,'A') RETURNING l_code
                 IF NOT l_code THEN
                     CALL cl_err(g_edd.edd25,'mfg1100',0)
                     NEXT FIELD edd25
                 END IF
            END IF
	#IF NOT s_imechk(g_edd.edd25,g_edd.edd26) THEN NEXT FIELD edd26 END IF  #FUN-D40103 add  #TQC-D50124 mark
 
          AFTER FIELD edd26     # Location
            IF g_edd.edd26 IS NOT NULL AND g_edd.edd26 != ' ' THEN
               IF NOT s_imfchk(g_edd.edd03,g_edd.edd25,g_edd.edd26)
                 THEN CALL cl_err(g_edd.edd26,'mfg6095',0)
                      NEXT FIELD edd26
               END IF
            END IF
            IF g_edd.edd26 IS NULL THEN LET g_edd.edd26 = ' ' END IF
 	 #IF NOT s_imechk(g_edd.edd25,g_edd.edd26) THEN NEXT FIELD edd26 END IF  #FUN-D40103 add  #TQC-D50124 mark

        AFTER INPUT
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF cl_null(g_edd.edd05) THEN
               IF g_edd.edd05 < g_edd.edd04 THEN
                  CALL cl_err(g_edd.edd05,'mfg2604',0)
                  LET l_flag = 'Y'
               END IF
            END IF
            IF cl_null(g_edd.edd10_fac) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_edd.edd10_fac
            END IF
            IF cl_null(g_edd.edd10_fac2) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_edd.edd10_fac2
            END IF
            IF cl_null(g_edd.edd27) OR g_edd.edd27 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_edd.edd27
            END IF
            IF cl_null(g_edd.edd18) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_edd.edd18
            END IF
            IF cl_null(g_edd.edd23) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_edd.edd23
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD  edd01
            END IF
		 ON KEY(F1)
			NEXT FIELD edd01
		 ON KEY(F2)
			NEXT FIELD edd06
			NEXT FIELD edd13
			NEXT FIELD edd25
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(edd01) OR INFIELD(edd011) OR INFIELD(edd013) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_edc01"   
                  LET g_qryparam.default1 = g_edd.edd01
                  LET g_qryparam.default2 = g_edd.edd011
                  LET g_qryparam.default3 = g_edd.edd013
                  CALL cl_create_qry() RETURNING g_edd.edd01,g_edd.edd011,g_edd.edd013
                  DISPLAY BY NAME g_edd.edd01,g_edd.edd011,g_edd.edd013
                  NEXT FIELD CURRENT
               WHEN INFIELD(edd03) #料件主檔
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima"
                #  LET g_qryparam.default1 = g_edd.edd03
                #  CALL cl_create_qry() RETURNING g_edd.edd03
                  CALL q_sel_ima(FALSE, "q_ima", "", g_edd.edd03, "", "", "", "" ,"",'' )  RETURNING g_edd.edd03
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_edd.edd03
                  NEXT FIELD edd03
               WHEN INFIELD(edd09) #作業主檔
                  CALL q_ecd(FALSE,TRUE,g_edd.edd09)
                       RETURNING g_edd.edd09
                  DISPLAY BY NAME g_edd.edd09
                  NEXT FIELD edd09
               WHEN INFIELD(edd10) #單位檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_edd.edd10
                  CALL cl_create_qry() RETURNING g_edd.edd10
                  DISPLAY BY NAME g_edd.edd10
                  NEXT FIELD edd10
               WHEN INFIELD(edd25) #倉庫
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imfd"
                  LET g_qryparam.default1 = g_edd.edd25
                  CALL cl_create_qry() RETURNING g_edd.edd25
                  DISPLAY BY NAME g_edd.edd25
                  NEXT FIELD edd25
               WHEN INFIELD(edd26) #儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imfe"
                  LET g_qryparam.default1 = g_edd.edd26
                  CALL cl_create_qry() RETURNING g_edd.edd26
                  DISPLAY BY NAME g_edd.edd26
                  NEXT FIELD edd26
            END CASE

        ON ACTION CONTROLF                    # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help() 
 
 
    END INPUT
END FUNCTION
 
FUNCTION i202_edd03(p_cmd)  #元件料件
    DEFINE p_cmd     LIKE type_file.chr1,    
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima04   LIKE ima_file.ima04,
           l_ima105  LIKE ima_file.ima105,
           l_ima110  LIKE ima_file.ima110,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima04,ima25,ima63,ima37,ima08,ima70,ima105,
           ima110,imaacti,ima86,ima70 
      INTO l_ima02,l_ima021,l_ima04,g_ima25_b,g_ima63_b,g_ima37_b,
           g_ima08_b,g_ima70_b,l_ima105,l_ima110,l_imaacti,g_ima86_b,g_ima70 
      FROM ima_file WHERE ima01 = g_edd.edd03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL LET l_ima021= NULL
                                   LET l_ima105= NULL LET l_ima110= NULL
                                   LET l_imaacti = NULL
                                   LET g_ima70=NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima08_b = 'D' THEN LET g_edd.edd17 = 'Y'      #元件為feature flag
                       ELSE LET g_edd.edd17 = 'N'
    END IF
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z' THEN LET g_errno = 'mfg2752' RETURN END IF
    IF p_cmd = 'a' THEN
      LET g_edd.edd10 = g_ima63_b
      LET g_edd.edd27 = l_ima105
      LET g_edd.edd11 = l_ima04
      DISPLAY BY NAME g_edd.edd10
      DISPLAY BY NAME g_edd.edd27
      DISPLAY BY NAME g_edd.edd11
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02 TO FORMONLY.ima02_h2
       DISPLAY l_ima021 TO FORMONLY.ima021_h2
       DISPLAY g_ima08_b TO FORMONLY.ima08_2
    END IF
END FUNCTION
 
FUNCTION i202_bdate(p_cmd)
  DEFINE   l_edd04_a,l_edd04_i LIKE edd_file.edd04,
           l_edd05_a,l_edd05_i LIKE edd_file.edd05,
           p_cmd   LIKE type_file.chr1,     
           l_n     LIKE type_file.num10      
 
    LET g_errno = " "
    IF p_cmd = 'a' THEN
       SELECT COUNT(*) INTO l_n FROM edd_file
                            WHERE edd01 = g_edd.edd01   #主件
                              AND edd011 = g_edd.edd011 
                              AND edd013 = g_edd.edd013 
                              AND  edd02 = g_edd.edd02   #項次
                              AND  edd04 = g_edd.edd04
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    SELECT MAX(edd04),MAX(edd05) INTO l_edd04_a,l_edd05_a
                       FROM edd_file
                      WHERE edd01 = g_edd.edd01         #主件
                        AND edd011 = g_edd.edd011 
                        AND edd013 = g_edd.edd013 
                        AND  edd02 = g_edd.edd02         #項次
                        AND  edd04 < g_edd.edd04         #生效日
    IF g_edd.edd04 <  l_edd04_a THEN LET g_errno = 'mfg2737' END IF
 
    SELECT MIN(edd04),MIN(edd05) INTO l_edd04_i,l_edd05_i
                       FROM edd_file
                      WHERE edd01 = g_edd.edd01         #主件
                        AND edd011 = g_edd.edd011 
                        AND edd013 = g_edd.edd013
                        AND  edd02 = g_edd.edd02         #項次
                        AND  edd04 > g_edd.edd04         #生效日
 
    IF l_edd04_i IS NULL AND l_edd05_i IS NULL THEN RETURN END IF
    IF l_edd04_a IS NULL AND l_edd05_a IS NULL THEN
       IF g_edd.edd04 < l_edd04_i THEN LET g_errno = 'mfg2737' END IF
    END IF
    IF g_edd.edd04 > l_edd04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION
 
FUNCTION i202_edate(p_cmd)
  DEFINE   l_edd04_i   LIKE edd_file.edd04,
           l_edd04_a   LIKE edd_file.edd04,
           p_cmd       LIKE type_file.chr1,   
           l_n         LIKE type_file.num5     
 
    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n FROM edd_file
                      WHERE edd01 = g_edd.edd01         #主件
                        AND edd011 = g_edd.edd011 
                        AND edd013 = g_edd.edd013 
                        AND edd02 = g_edd.edd02   #項次
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(edd04) INTO l_edd04_i
                       FROM edd_file
                      WHERE edd01 = g_edd.edd01         #主件
                        AND edd011 = g_edd.edd011 
                        AND edd013 = g_edd.edd013 
                       AND  edd02 = g_edd.edd02         #項次
                       AND  edd04 > g_edd.edd04         #生效日
   SELECT MAX(edd04) INTO l_edd04_a
                       FROM edd_file
                      WHERE edd01 = g_edd.edd01         #主件
                        AND edd011 = g_edd.edd011 
                        AND edd013 = g_edd.edd013 
                        AND  edd02 = g_edd.edd02         #項次
                        AND  edd04 > g_edd.edd04         #生效日
   IF l_edd04_i IS NULL THEN RETURN END IF
   IF g_edd.edd05 > l_edd04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION
 
FUNCTION i202_edd25(p_cmd)  
    DEFINE p_cmd     LIKE type_file.chr1,      
           l_imd02   LIKE imd_file.imd02,
           l_imdacti LIKE imd_file.imdacti
 
    LET g_errno = ' '
    SELECT  imd02,imdacti INTO l_imd02,l_imdacti FROM imd_file
            WHERE imd01 = g_edd.edd25
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
                            LET l_imd02 = NULL
                            LET l_imdacti= NULL
         WHEN l_imdacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i202_edd01(p_cmd)  
    DEFINE p_cmd     LIKE type_file.chr1,      
           l_eda02   LIKE eda_file.eda02
 
    LET g_errno = ' '
    SELECT  eda02 INTO l_eda02 FROM eda_file
            WHERE eda01 = g_edd.edd01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aec-057'
                            LET l_eda02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_eda02 TO FORMONLY.eda02
    END IF
END FUNCTION
 
#=====>此FUNCTION 目的在update 上一筆的失效日
FUNCTION i202_update(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,     
         l_edd02   LIKE edd_file.edd02,
         l_edd03   LIKE edd_file.edd03,
         l_edd04   LIKE edd_file.edd04,
         l_edd29   LIKE edd_file.edd29 

    DECLARE i202_update SCROLL CURSOR  FOR
            SELECT edd02,edd03,edd04,edd29 FROM edd_file
                   WHERE edd01 = g_edd.edd01 AND
                         edd011 = g_edd.edd011 AND
                         edd013 = g_edd.edd013 AND                   
                         edd02 = g_edd.edd02 AND
                         (edd04 < g_edd.edd04)       #生效日
                   ORDER BY edd04
    OPEN i202_update
    FETCH LAST i202_update INTO l_edd02,l_edd03,l_edd04,l_edd29 
    IF SQLCA.sqlcode = 0
       THEN UPDATE edd_file SET edd05 = g_edd.edd04,
                                eddmodu = g_user,    
                                edddate = g_today, 
                                eddcomm = "aeci202" 
                          WHERE edd01 = g_edd.edd01 AND
                                edd011 = g_edd.edd011 AND
                                edd013 = g_edd.edd013 AND
                                edd02 = l_edd02 AND
                                edd03 = l_edd03 AND
                                edd04 = l_edd04 
           IF SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","edd_file",g_edd.edd01,l_edd02,"mfg2635","","",1)  
           END IF

    END IF
    CLOSE i202_update
END FUNCTION
 
FUNCTION i202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_edd.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i202_curs()                          
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_edd.* TO NULL
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i202_count
    FETCH i202_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i202_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_edd.edd01 CLIPPED,'+',g_edd.edd011 CLIPPED,'+',
                      g_edd.edd013 CLIPPED,'+',g_edd.edd02 CLIPPED,'+',g_edd.edd03 CLIPPED,'+',g_edd.edd04                                       
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_edd.* TO NULL
    ELSE
        CALL i202_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i202_fetch(p_fledd)
    DEFINE
        p_fledd      LIKE type_file.chr1     
 
    CASE p_fledd
        WHEN 'N' FETCH NEXT     i202_curs INTO g_edd.edd01,g_edd.edd011,g_edd.edd013,g_edd.edd02,g_edd.edd03,g_edd.edd04
        WHEN 'P' FETCH PREVIOUS i202_curs INTO g_edd.edd01,g_edd.edd011,g_edd.edd013,g_edd.edd02,g_edd.edd03,g_edd.edd04                                          
        WHEN 'F' FETCH FIRST    i202_curs INTO g_edd.edd01,g_edd.edd011,g_edd.edd013,g_edd.edd02,g_edd.edd03,g_edd.edd04                                           
        WHEN 'L' FETCH LAST     i202_curs INTO g_edd.edd01,g_edd.edd011,g_edd.edd013,g_edd.edd02,g_edd.edd03,g_edd.edd04                                              
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i202_curs INTO g_edd.edd01,g_edd.edd011,g_edd.edd013,g_edd.edd02,g_edd.edd03,g_edd.edd04                                             
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_edd.edd01 CLIPPED,'+',g_edd.edd011 CLIPPED,'+',
                  g_edd.edd013 CLIPPED,'+',g_edd.edd02 CLIPPED,'+',g_edd.edd03 CLIPPED,'+',g_edd.edd04
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_edd.* TO NULL  
        RETURN
    ELSE
       CASE p_fledd
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_edd.* FROM edd_file            # 重讀DB,因TEMP有不被更新特性
     WHERE edd01=g_edd.edd01 AND edd011 = g_edd.edd011 AND edd013 = g_edd.edd013 
       AND edd02=g_edd.edd02 AND edd03=g_edd.edd03 AND edd04=g_edd.edd04 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_edd.edd01 CLIPPED,'+',g_edd.edd011 CLIPPED,'+',
                  g_edd.edd013 CLIPPED,'+',g_edd.edd02 CLIPPED,'+',g_edd.edd03 CLIPPED,'+',g_edd.edd04
        CALL cl_err3("sel","edd_file",g_msg,"",SQLCA.sqlcode,"","",1) 
    ELSE
        CALL i202_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i202_show()
DEFINE  l_ecu014   LIKE ecu_file.ecu014
DEFINE  l_ecu03    LIKE ecu_file.ecu03 

    LET g_edd_t.* = g_edd.*
    LET g_edd_o.* = g_edd.*
    DISPLAY BY NAME g_edd.edd01,g_edd.edd011,g_edd.edd013,
                    g_edd.edd02,g_edd.edd03,g_edd.edd04, 
                    g_edd.edd05,g_edd.edd10,g_edd.edd10_fac,
                    g_edd.edd10_fac2,g_edd.edd06,g_edd.edd07,
                    g_edd.edd08,g_edd.edd23,g_edd.edd11,g_edd.edd13,
                    g_edd.edd09,g_edd.edd18,g_edd.edd27,g_edd.edd28,                    
                    g_edd.edd25,g_edd.edd26,g_edd.edd24,
                    g_edd.eddmodu,g_edd.edddate,g_edd.eddcomm
    CALL i202_edd03('d')
    CALL i202_edd01('d')
    CALL cl_show_fld_cont()                 
END FUNCTION
 
FUNCTION i202_u()
DEFINE l_edcconf  LIKE edc_file.edcconf
 
    IF cl_null(g_edd.edd01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT edcconf INTO l_edcconf FROM edc_file
     WHERE edc01=g_edd.edd01 AND edc02=g_edd.edd02
    IF l_edcconf MATCHES '[YX]' THEN CALL cl_err(g_edd.edd01,'alm-638',1) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_edd01_t = g_edd.edd01
    LET g_edd011_t = g_edd.edd011
    LET g_edd013_t = g_edd.edd013
    LET g_edd02_t = g_edd.edd02
    LET g_edd03_t = g_edd.edd03
    LET g_edd04_t = g_edd.edd04
    LET g_edd_o.* = g_edd.*
 
    BEGIN WORK
    OPEN i202_curl USING g_edd.edd01,g_edd.edd011,g_edd.edd013,g_edd.edd02,g_edd.edd03,g_edd.edd04
 
    IF STATUS THEN
       CALL cl_err("OPEN i202_curl:", STATUS, 1)
       CLOSE i202_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i202_curl INTO g_edd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        LET g_msg=g_edd.edd01 CLIPPED,'+',g_edd.edd011 CLIPPED,'+',
                  g_edd.edd013 CLIPPED,'+',g_edd.edd02 CLIPPED,'+',g_edd.edd03 CLIPPED,'+',g_edd.edd04 
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i202_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_edd.eddmodu = g_user    
        LET g_edd.edddate = g_today  
        LET g_edd.eddcomm = 'aeci202'
        CALL i202_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_edd.*=g_edd_t.*
            CALL i202_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE edd_file SET edd_file.* = g_edd.*    # 更新DB
         WHERE edd01=g_edd01_t AND edd011=g_edd011_t  AND edd013=g_edd013_t 
          AND edd02=g_edd02_t AND edd03=g_edd03_t AND edd04=g_edd04_t  
        IF SQLCA.SQLERRD[3] = 0 THEN
            LET g_msg=g_edd.edd01 CLIPPED,'+',g_edd.edd011 CLIPPED,'+',
                      g_edd.edd013 CLIPPED,'+',g_edd.edd02 CLIPPED,'+',g_edd.edd03 CLIPPED,'+',g_edd.edd04  
             CALL cl_err3("upd","edd_file",g_edd01_t,g_edd02_t,SQLCA.sqlcode,"",g_msg,1) 
            CONTINUE WHILE
        END IF
        #--->上筆生效日之處理/BOM 說明檔(bmc_file) unique key
        CALL i202_update('u')
        EXIT WHILE
    END WHILE
    CLOSE i202_curl
	COMMIT WORK
END FUNCTION
 
FUNCTION i202_r()
    DEFINE l_chr      LIKE type_file.chr1  
    DEFINE l_edcconf  LIKE edc_file.edcconf
            
 
    IF cl_null(g_edd.edd01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT edcconf INTO l_edcconf FROM edc_file
     WHERE edc01=g_edd.edd01 AND edc02=g_edd.edd02
    IF l_edcconf MATCHES '[YX]' THEN CALL cl_err(g_edd.edd01,'alm-638',1) RETURN END IF

    BEGIN WORK
    OPEN i202_curl USING g_edd.edd01,g_edd.edd011,g_edd.edd013,g_edd.edd02,g_edd.edd03,g_edd.edd04
    IF STATUS THEN
       CALL cl_err("OPEN i202_curl:", STATUS, 1)
       CLOSE i202_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i202_curl INTO g_edd.*
    IF SQLCA.sqlcode THEN
       LET g_msg=g_edd.edd01 CLIPPED,'+',g_edd.edd011 CLIPPED,'+',g_edd.edd013 CLIPPED,'+',
                 g_edd.edd02 CLIPPED,'+',g_edd.edd03 CLIPPED,'+',g_edd.edd04 CLIPPED                
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i202_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL            
        LET g_doc.column1 = "edd01"           
        LET g_doc.value1  = g_edd.edd01       
        LET g_doc.column2 = "edd02"           
        LET g_doc.value2  = g_edd.edd02       
        LET g_doc.column3 = "edd03"           
        LET g_doc.value3  = g_edd.edd03       
        LET g_doc.column4 = "edd04"           
        LET g_doc.value4  = g_edd.edd04       
        LET g_doc.column5 = "edd011" 
        LET g_doc.value5 = g_edd.edd011
        CALL cl_del_doc()                                        
 
       DELETE FROM edd_file WHERE edd01 = g_edd.edd01
                              AND edd011= g_edd.edd011
                              AND edd013= g_edd.edd013
                              AND edd02 = g_edd.edd02
                              AND edd03 = g_edd.edd03
                              AND edd04 = g_edd.edd04

       LET g_edd.edd01 = NULL LET g_edd.edd011 = NULL LET g_edd.edd013= NULL 
       LET g_edd.edd02 = NULL LET g_edd.edd03  = NULL LET g_edd.edd04 = NULL        
       INITIALIZE g_edd.* TO NULL
       CLEAR FORM
       OPEN i202_count
       FETCH i202_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i202_curs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i202_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i202_fetch('/')
       END IF
       LET g_msg=TIME
    END IF
    CLOSE i202_curl
	COMMIT WORK
END FUNCTION

FUNCTION i202_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("edd01,edd011,edd013,edd02,edd03,edd04",TRUE)
   END IF
END FUNCTION
 
FUNCTION i202_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1     
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("edd01,edd011,edd013,edd02,edd03,edd04",FALSE) 
   END IF
   IF NOT cl_null(g_argv1) AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("edd01,edd011,edd013",FALSE)
   END IF
   IF g_sma.sma12 = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("edd26",FALSE)
   END IF

END FUNCTION
#FUN-A80054 

