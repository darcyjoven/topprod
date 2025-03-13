# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: abmi505.4gl
# Descriptions...: 產品結構元件資料維護作業
# Date & Author..: NO.FUN-A60031 10/06/21 By destiny
# Modify.........: NO.FUN-A70125 10/07/26 By lilingyu 平行工藝
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu  全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_brb   RECORD LIKE brb_file.*,
    g_brb_t RECORD LIKE brb_file.*,
    g_brb_o RECORD LIKE brb_file.*,
    g_brb01_t LIKE brb_file.brb01,
    g_brb011_t LIKE brb_file.brb011,
    g_brb012_t LIKE brb_file.brb012,
    g_brb013_t LIKE brb_file.brb013,
    g_brb02_t LIKE brb_file.brb02,
    g_brb03_t LIKE brb_file.brb03,
    g_brb04_t LIKE brb_file.brb04,
    g_brb29_t LIKE brb_file.brb29,
    g_brb10_t LIKE brb_file.brb10,
    g_brb25_t LIKE brb_file.brb25,
    g_brb26_t LIKE brb_file.brb26,
    g_ima08_h LIKE ima_file.ima08,
    g_ima37_h LIKE ima_file.ima37,
    g_ima70_h LIKE ima_file.ima70,
    g_ima08_b LIKE ima_file.ima08,
    g_ima37_b LIKE ima_file.ima37,
    g_ima70_b LIKE ima_file.ima70,
    g_ima25_b LIKE ima_file.ima25,
    g_ima63_b LIKE ima_file.ima63,
    g_ima86_b LIKE ima_file.ima86,
    g_ima63_fac LIKE ima_file.ima63_fac,
    g_argv1     LIKE brb_file.brb01,     
    g_argv2     LIKE type_file.dat,      
    g_argv3     LIKE type_file.chr1000, 
    g_argv4     LIKE brb_file.brb29,     
    g_argv5     LIKE brb_file.brb03,  
    g_argv6     LIKE brb_file.brb011,
    g_argv7     LIKE brb_file.brb012,
    g_argv8     LIKE brb_file.brb013,
    g_sw        LIKE type_file.num5,   
    g_ecd03     LIKE ecd_file.ecd03,
    g_factor    LIKE pml_file.pml09,   
    g_wc,g_sql  string,              
    g_bra05     LIKE bra_file.bra05,
    g_ima08     LIKE ima_file.ima08,
    g_ima70     LIKE ima_file.ima70,
    g_ecu03     LIKE ecu_file.ecu03,
    g_ecu014    LIKE ecu_file.ecu014    
DEFINE g_forupd_sql          STRING                  
DEFINE g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1    
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_msg           LIKE ze_file.ze03          
DEFINE   g_row_count    LIKE type_file.num10       
DEFINE   g_curs_index   LIKE type_file.num10      
DEFINE   g_jump         LIKE type_file.num10      
DEFINE   g_no_ask      LIKE type_file.num5       
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_brb.* TO NULL
    INITIALIZE g_brb_t.* TO NULL
    INITIALIZE g_brb_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM brb_file WHERE brb01 = ? AND brb02 = ? AND brb03 = ? AND brb04 = ? AND brb29 =? AND brb011= ? AND brb012= ? AND brb013= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i505_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
#    CALL s_decl_brb()
 
    OPEN WINDOW i505_w WITH FORM "abm/42f/abmi505"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3) 
    LET g_argv4 = ARG_VAL(4) 
    LET g_argv5 = ARG_VAL(5)
    LET g_argv6 = ARG_VAL(6) 
    LET g_argv7 = ARG_VAL(7) 
    
    CALL cl_set_comp_visible("brb29",g_sma.sma118='Y')
    
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL i505_q()
    END IF
    IF g_sma.sma542='N' THEN 
       CALL cl_err('','abm-213',1)
       CLOSE WINDOW i505_w             
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time           
    END IF     
      LET g_action_choice=""
      CALL i505_menu()
 
    CLOSE WINDOW i505_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i505_curs()
DEFINE  l_cmd     LIKE type_file.chr1000  
    CLEAR FORM
    DISPLAY BY NAME  g_brb.brb01
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_sql="SELECT brb01,brb011,brb012,brb013,brb02,brb03,brb04,brb13,brb29 ", 
                      " FROM brb_file ",                      # 組合出 SQL 指令
                      " WHERE brb01 ='",g_argv1,"'",
                      " AND  brb29='",g_argv3,"'", 
                      " AND  brb03='",g_argv4,"'",
                      " AND brb011='",g_argv5,"' ",
                      " AND brb012='",g_argv6,"' ",
                      " AND brb013='",g_argv7,"' "       
            IF g_argv2 IS NOT NULL AND g_argv2 != ' ' THEN
               LET  g_sql = g_sql  CLIPPED,
                         " AND (brb04 <='", g_argv2,"'"," OR brb04 IS NULL )",
                         " AND (brb05 > '",g_argv2,"'"," OR brb05 IS NULL )"
            END IF
            CASE g_sma.sma65
              WHEN '1'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY brb01,brb011,brb012,brb013,brb02,brb03,brb04,brb29" 
              WHEN '2'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY brb01,brb011,brb012,brb013,brb03,brb02,brb04,brb29" 
              WHEN '3'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY brb01,brb011,brb012,brb013,brb13,brb02,brb03,brb04,brb29" 
              OTHERWISE LET g_sql = g_sql CLIPPED,
                                    " ORDER BY brb01,brb011,brb012,brb013,brb02,brb03,brb04, brb29"
            END CASE
       ELSE
   INITIALIZE g_brb.* TO NULL    
            CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
              brb01,brb011,brb012,brb013,brb02,brb29,brb03,brb04,brb05,brb10,brb10_fac, 
              brb10_fac2, brb06,brb07,brb08,brb23,brb11,brb13,brb16,
              brb27,brb15,brb09,brb18,brb28,brb19,brb14,brb25,brb26,brb24,
              brbmodu,brbdate,brbcomm    
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(brb01) #料件主檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_brb01"   
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_brb.brb01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO brb01
                     NEXT FIELD brb01
                  WHEN INFIELD(brb011) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_brb011"   
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_brb.brb011
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO brb011
                     NEXT FIELD brb011
                  WHEN INFIELD(brb012) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_brb012"   
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_brb.brb012
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO brb012
                     NEXT FIELD brb012
                  WHEN INFIELD(brb013)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_brb013"   
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_brb.brb013
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO brb013
                     NEXT FIELD brb013                                                               
                  WHEN INFIELD(brb03) #料件主檔
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.state = "c"
                   #  LET g_qryparam.default1 = g_brb.brb03
                   #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","",g_brb.brb03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO brb03
                     NEXT FIELD brb03
                  WHEN INFIELD(brb09) #作業主檔
                     CALL q_ecd(TRUE,TRUE,g_brb.brb09)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO brb09
                     NEXT FIELD brb09
                  WHEN INFIELD(brb10) #單位檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_brb.brb10
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO brb10
                     NEXT FIELD brb10
                  WHEN INFIELD(brb25) #倉庫
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imfd"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_brb.brb25
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO brb25
                     NEXT FIELD brb25
                  WHEN INFIELD(brb26) #儲位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imfe"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_brb.brb26
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO brb26
                     NEXT FIELD brb26
                  WHEN INFIELD(brb05)
                     IF g_brb_t.brb02 IS NOT NULL
                        THEN LET l_cmd = "abmi603 '",g_brb.brb01,"'",
                                          " '",g_brb.brb02,"' '",  
                                          g_brb.brb03,"' '",
                                          g_brb.brb04,"' '",
                                          g_brb.brb29,"'" CLIPPED
                             CALL cl_cmdrun(l_cmd)
                     END IF
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
 
             LET g_sql="SELECT brb01,brb011,brb012,brb013,brb02,brb03,brb04,brb13,brb29 ",
                       " FROM brb_file ",                      
                       " WHERE ",g_wc CLIPPED
            CASE g_sma.sma65
              WHEN '1'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY brb01,brb011,brb012,brb013,brb02,brb03,brb04,brb29" 
              WHEN '2'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY brb01,brb011,brb012,brb013,brb03,brb02,brb04,brb29"
              WHEN '3'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY brb01,brb011,brb012,brb013,brb13,brb02,brb03,brb04,brb29"
              OTHERWISE LET g_sql = g_sql CLIPPED,
                                    " ORDER BY brb01,brb011,brb012,brb013,brb02,brb03,brb04,brb29"
            END CASE
    END IF
 
    PREPARE i505_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i505_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i505_prepare
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_sql =
                "SELECT COUNT(*) FROM brb_file WHERE brb01 ='",g_argv1,"'",
                                               " AND brb29 ='",g_argv3,"'",
                                               " AND brb03 ='",g_argv4,"'",  
                                               " AND brb011='",g_argv5,"' ",
                                               " AND brb012='",g_argv6,"' ",
                                               " AND brb013='",g_argv7,"' "  
       ELSE LET g_sql=
                "SELECT COUNT(*) FROM brb_file WHERE ",g_wc CLIPPED
    END IF
    PREPARE i505_precount FROM g_sql
    DECLARE i505_count CURSOR FOR i505_precount
END FUNCTION
 
FUNCTION i505_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i505_q()
            END IF
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i505_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i505_r()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i505_copy()
            END IF
            
#        ON ACTION gen_group_link
#           IF g_ima08_h = 'A' AND g_brb.brb01 IS NOT NULL THEN
#              CALL p500_tm(0,0,g_brb.brb01)
#           ELSE
#              CALL cl_err(g_brb.brb01,'mfg2634',0)
#           END IF
 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()       

        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION first
            CALL i505_fetch('F')
         ON ACTION next
            CALL i505_fetch('N')
         ON ACTION jump
            CALL i505_fetch('/')
         ON ACTION previous
            CALL i505_fetch('P')
         ON ACTION last
            CALL i505_fetch('L')
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
               IF g_brb.brb01 IS NOT NULL THEN
                  LET g_doc.column1 = "brb01"
                  LET g_doc.value1  = g_brb.brb01
                  LET g_doc.column2 = "brb02"
                  LET g_doc.value2  = g_brb.brb02
                  LET g_doc.column3 = "brb03"
                  LET g_doc.value3  = g_brb.brb03
                  LET g_doc.column4 = "brb04"
                  LET g_doc.value4  = g_brb.brb04
                  LET g_doc.column5 = "brb29" 
                  LET g_doc.value5  = g_brb.brb29 
                  #LET g_doc.column6 = "brb011" 
                  #LET g_doc.value6 = g_brb.brb011
                  #LET g_doc.column7 = "brb012" 
                  #LET g_doc.value7 = g_brb.brb012
                  #LET g_doc.column8 = "brb013" 
                  #LET g_doc.value8 = g_brb.brb013
                  CALL cl_doc()
               END IF
            END IF

      &include "qry_string.4gl"
    END MENU
    CLOSE i505_curs
END FUNCTION
  
FUNCTION i505_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    
        l_cmd           LIKE type_file.chr1000,
        l_dir1          LIKE type_file.chr1,   
        l_n             LIKE type_file.num5,    
        l_ima08         LIKE ima_file.ima08,
        l_brb01         LIKE brb_file.brb01,
        l_ime09         LIKE ime_file.ime09,
        l_qpa           LIKE brb_file.brb06,
        l_code          LIKE type_file.num5,   
        l_flag          LIKE type_file.chr1,   
        l_cnt           LIKE type_file.num5,   
        l_bmd02  LIKE bmd_file.bmd02 

    DISPLAY BY NAME
      g_brb.brb01,g_brb.brb011,g_brb.brb012,g_brb.brb013,g_brb.brb02,
      g_brb.brb29,g_brb.brb03,g_brb.brb04,
      g_brb.brb05,g_brb.brb10,g_brb.brb10_fac,g_brb.brb10_fac2,
      g_brb.brb06,g_brb.brb07,g_brb.brb08,g_brb.brb23,
      g_brb.brb11,g_brb.brb13,g_brb.brb16,g_brb.brb27,
      g_brb.brb15,g_brb.brb09,g_brb.brb18,
      g_brb.brb28,g_brb.brb19,g_brb.brb14,g_brb.brb25,g_brb.brb26,g_brb.brb24,
      g_brb.brbmodu,g_brb.brbdate,g_brb.brbcomm

 
    INPUT BY NAME
      g_brb.brb01,g_brb.brb02,g_brb.brb29,g_brb.brb03,g_brb.brb04, 
      g_brb.brb05,g_brb.brb10,g_brb.brb10_fac,g_brb.brb10_fac2,
      g_brb.brb06,g_brb.brb07,g_brb.brb08,g_brb.brb23,
      g_brb.brb11,g_brb.brb13,g_brb.brb16,g_brb.brb27,
      g_brb.brb15,g_brb.brb09,g_brb.brb18,
      g_brb.brb28,g_brb.brb19,g_brb.brb14,g_brb.brb25,g_brb.brb26,g_brb.brb24,
      g_brb.brbmodu,g_brb.brbdate,g_brb.brbcomm
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i505_set_entry(p_cmd)
            CALL i505_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
       BEFORE FIELD brb01
      	   IF g_sma.sma60 = 'Y'		# 若須分段輸入
	      THEN CALL s_inp5(7,15,g_brb.brb01) RETURNING g_brb.brb01
	           DISPLAY BY NAME g_brb.brb01
	   END IF
 
        AFTER FIELD brb01                  #主件料號
            IF g_argv1 IS NOT NULL AND g_argv1 != ' '
                  AND g_brb.brb01 != g_brb_t.brb01
               THEN CALL cl_err('','mfg2627',0)
                    NEXT FIELD brb01
            END IF
            IF NOT cl_null(g_brb.brb01) THEN
              #FUN-AA0059 --------------------------add start----------------------
              IF NOT s_chk_item_no(g_brb.brb01,'') THEN
                 CALL cl_err('',g_errno,1) 
                 LET g_brb.brb01 = g_brb_o.brb01
                 DISPLAY BY NAME g_brb.brb01
                 NEXT FIELD brb01
              END IF 
              #FUN-AA0059 --------------------------add end---------------------   
              IF p_cmd = "a" OR                    # 若輸入或更改且改KEY  #MOD-8C0097 
                 (p_cmd = "u" AND g_brb.brb01 != g_brb_t.brb01) THEN    #MOD-8C0097 
               CALL i505_brb01('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_brb.brb01,g_errno,0)
                   LET g_brb.brb01 = g_brb_o.brb01
                  DISPLAY BY NAME g_brb.brb01
                  NEXT FIELD brb01
               END IF
              END IF  #MOD-8C0097 add
            END IF
 
        BEFORE FIELD brb02                        #default 項次
            IF g_brb.brb02 IS NULL OR
               g_brb.brb02 = 0 THEN
                SELECT max(brb02)+1
                   INTO g_brb.brb02
                   FROM brb_file
                   WHERE brb01 = g_brb.brb01
                IF g_brb.brb02 IS NULL
                   THEN LET g_brb.brb02 = 1
                END IF
                DISPLAY BY NAME g_brb.brb02
            END IF
 
        BEFORE FIELD brb03
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(10,15,g_brb.brb03) RETURNING g_brb.brb03
	            DISPLAY BY NAME g_brb.brb03
	    END IF
            LET g_brb03_t = g_brb.brb03
 
        AFTER FIELD brb03                  #元件料號
            IF NOT cl_null(g_brb.brb03) THEN
               #FUN-AA0059 ------------------------------add start------------------
               IF NOT s_chk_item_no(g_brb.brb03,'') THEN
                  CALL cl_err('',g_errno,1) 
                  LET g_brb.brb03=g_brb_t.brb03
                  DISPLAY BY NAME g_brb.brb03
                  NEXT FIELD brb03
               END IF 
               #FUN-AA0059 ----------------------------add end------------------------- 
               CALL i505_brb03(p_cmd)   #必需讀取料件主檔
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_brb.brb03,g_errno,0) 
                  LET g_brb.brb03=g_brb_t.brb03
                  DISPLAY BY NAME g_brb.brb03
                  NEXT FIELD brb03
               END IF
               IF s_bomchk(g_brb.brb01,g_brb.brb03,g_ima08_h,g_ima08_b)
                THEN NEXT FIELD brb03
               END IF
            END IF
 
        AFTER FIELD brb04                        #check 是否重複
            IF NOT cl_null(g_brb.brb04) THEN
               IF g_brb.brb01 != g_brb01_t OR g_brb01_t IS NULL
                  OR g_brb.brb02 != g_brb02_t OR g_brb02_t IS NULL
                  OR g_brb.brb03 != g_brb03_t OR g_brb03_t IS NULL
                  OR g_brb.brb04 != g_brb04_t OR g_brb04_t IS NULL
                  OR g_brb.brb29 != g_brb29_t  THEN  #FUN-550093 #TQC-5C0052 04->29
                   SELECT count(*) INTO g_cnt FROM brb_file
                       WHERE brb01 = g_brb.brb01 AND brb02 = g_brb.brb02
                         AND brb03 = g_brb.brb03 AND brb04 = g_brb.brb04
                         AND brb29 = g_brb.brb29  #FUN-550093
                   IF g_cnt > 0 THEN   #資料重複
                       LET g_msg = g_brb.brb01 CLIPPED,'+',g_brb.brb02
                                   CLIPPED,'+',g_brb.brb03 CLIPPED,'+',
                                   g_brb.brb04,'+',g_brb.brb29 #FUN-550093
                       CALL cl_err(g_msg,-239,0)
                       LET g_brb.brb02 = g_brb02_t
                       LET g_brb.brb03 = g_brb03_t
                       LET g_brb.brb04 = g_brb04_t
                       LET g_brb.brb29 = g_brb29_t #FUN-550093
                       DISPLAY BY NAME g_brb.brb01
                       DISPLAY BY NAME g_brb.brb02
                       DISPLAY BY NAME g_brb.brb03
                       DISPLAY BY NAME g_brb.brb04
                       DISPLAY BY NAME g_brb.brb29 #FUN-550093
                       NEXT FIELD brb01
                   END IF
               END IF
               CALL i505_bdate(p_cmd)     #生效日
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_brb.brb04,g_errno,0)
                  LET g_brb.brb04 = g_brb_t.brb04
                  DISPLAY BY NAME g_brb.brb04
                  NEXT FIELD brb04
               END IF
            END IF
 
        AFTER FIELD brb05   #check失效日小於生效日
            IF NOT cl_null(g_brb.brb05)
               THEN IF g_brb.brb05 < g_brb.brb04
                       THEN CALL cl_err(g_brb.brb05,'mfg2604',0)
                       NEXT FIELD brb04
                    END IF
            END IF
            CALL i505_edate(p_cmd)     #生效日
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_brb.brb05,g_errno,0)
               LET g_brb.brb05 = g_brb_t.brb05
               DISPLAY BY NAME g_brb.brb05
               NEXT FIELD brb04
            END IF
 
        AFTER FIELD brb06    #組成用量不可小於零
           IF g_brb.brb06 <= 0
              THEN CALL cl_err(g_brb.brb06,'mfg2614',0)
                   LET g_brb.brb06 = g_brb_o.brb06
                   DISPLAY BY NAME g_brb.brb06
                   NEXT FIELD brb06
           END IF
           LET g_brb_o.brb06 = g_brb.brb06
 
        AFTER FIELD brb07    #底數不可小於等於零
            IF g_brb.brb07 <= 0  THEN
               CALL cl_err(g_brb.brb07,'mfg2615',0)
               LET g_brb.brb07 = g_brb_o.brb07
               DISPLAY BY NAME g_brb.brb07
               NEXT FIELD brb07
            END IF
            LET g_brb_o.brb07 = g_brb.brb07
 
        AFTER FIELD brb08    #損耗率
            IF g_brb.brb08 < 0 OR g_brb.brb08 > 100
               THEN CALL cl_err(g_brb.brb08,'mfg0013',0)
                    LET g_brb.brb08 = g_brb_o.brb08
                    DISPLAY BY NAME g_brb.brb08
                    NEXT FIELD brb08
            END IF
            LET g_brb_o.brb08 = g_brb.brb08
 
        AFTER FIELD brb10   #發料單位
          IF NOT cl_null(g_brb.brb10) THEN
             IF (g_brb_o.brb10 IS NULL) OR (g_brb.brb10 != g_brb_o.brb10)
             THEN SELECT gfe01 FROM gfe_file
                   WHERE gfe01 = g_brb.brb10 AND
                        #gfeacti IN ('Y','y') #MOD-5C0034
                         gfeacti IN ('Y','y')  #MOD-5C0034
                   IF SQLCA.sqlcode != 0 THEN
#                      CALL cl_err(g_brb.brb10,'mfg2605',0) #No.TQC-660046
                      CALL cl_err3("sel","gfe_file",g_brb.brb10,"","mfg2605","","",1)   #TQC-660046
                      LET g_brb.brb10 = g_brb_o.brb10
                      DISPLAY BY NAME g_brb.brb10
                      #MOD-5C0034...............begin
                      LET g_brb.brb10_fac = g_brb_o.brb10_fac
                      DISPLAY BY NAME g_brb.brb10_fac
                      LET g_brb.brb10_fac2= g_brb_o.brb10_fac2
                      DISPLAY BY NAME g_brb.brb10_fac2
                      #MOD-5C0034...............end
                      NEXT FIELD brb10
                   ELSE IF g_brb.brb10 != g_ima25_b
                        THEN CALL s_umfchk(g_brb.brb03,g_brb.brb10,
                                            g_ima25_b)
                              RETURNING g_sw,g_brb.brb10_fac #發料/庫存單位
                              IF g_sw = '1' THEN
                                 CALL cl_err(g_brb.brb10,'mfg2721',0)
                                 LET g_brb.brb10 = g_brb_o.brb10
                                 DISPLAY BY NAME g_brb.brb10
                                 LET g_brb.brb10_fac = g_brb_o.brb10_fac
                                 DISPLAY BY NAME g_brb.brb10_fac
                                 #MOD-5C0034...............begin
                                 LET g_brb.brb10_fac2= g_brb_o.brb10_fac2
                                 DISPLAY BY NAME g_brb.brb10_fac2
                                 #MOD-5C0034...............end
                                 NEXT FIELD brb10
                              END IF
                        ELSE LET g_brb.brb10_fac  = 1
                        END  IF
                        IF g_brb.brb10 != g_ima86_b  #發料/成本單位
                        THEN CALL s_umfchk(g_brb.brb03,g_brb.brb10,
                                             g_ima86_b)
                             RETURNING g_sw,g_brb.brb10_fac2
                             IF g_sw = '1' THEN
                                CALL cl_err(g_brb.brb03,'mfg2722',0)
                                LET g_brb.brb10 = g_brb_o.brb10
                                DISPLAY BY NAME g_brb.brb10
                                #MOD-5C0034...............begin
                                LET g_brb.brb10_fac = g_brb_o.brb10_fac
                                DISPLAY BY NAME g_brb.brb10_fac
                                #MOD-5C0034...............end
                                LET g_brb.brb10_fac2 = g_brb_o.brb10_fac2
                                DISPLAY BY NAME g_brb.brb10_fac2
                                NEXT FIELD brb10
                             END IF
                        ELSE LET g_brb.brb10_fac2 = 1
                        END IF
                   END IF
             END IF
          END IF
          DISPLAY BY NAME g_brb.brb10_fac  #MOD-5C0034 add
          DISPLAY BY NAME g_brb.brb10_fac2 #MOD-5C0034 add
          LET g_brb_o.brb10 = g_brb.brb10
          LET g_brb_o.brb10_fac = g_brb.brb10_fac
          LET g_brb_o.brb10_fac2 = g_brb.brb10_fac2
 
        AFTER FIELD brb10_fac   #發料/料件庫存轉換率
            IF g_brb.brb10_fac <= 0
               THEN CALL cl_err(g_brb.brb10_fac,'mfg1322',0)
                    LET g_brb.brb10_fac = g_brb_o.brb10_fac
                    DISPLAY BY NAME g_brb.brb10_fac
                    NEXT FIELD brb10_fac
            END IF
            LET g_brb_o.brb10_fac = g_brb.brb10_fac
 
        AFTER FIELD brb10_fac2   #發料/料件成本轉換率
            IF g_brb.brb10_fac2 <= 0
               THEN CALL cl_err(g_brb.brb10_fac2,'mfg1322',0)
                    LET g_brb.brb10_fac2 = g_brb_o.brb10_fac2
                    DISPLAY BY NAME g_brb.brb10_fac2
                    NEXT FIELD brb10_fac2
            END IF
            LET g_brb_o.brb10_fac2 = g_brb.brb10_fac2
 
        AFTER FIELD brb09    #作業編號
             #有使用製程(sma54='Y')
             IF NOT cl_null(g_brb.brb09) THEN
                SELECT COUNT(*) INTO g_cnt FROM ecd_file
                 WHERE ecd01=g_brb.brb09
                IF g_cnt=0 THEN
                   CALL cl_err('sel ecd_file',100,0)
                   NEXT FIELD brb09
                END IF
             END IF
 
        AFTER FIELD brb14     #使用特性
             IF g_brb.brb14 NOT MATCHES'[0123]'   #FUN-910053 add 23
                THEN NEXT FIELD brb14
             END IF
 
        AFTER FIELD brb27  #軟體物件
            LET g_brb_o.brb27 = g_brb.brb27
 
#可使為消耗性料件 1.多倉儲管理(sma12 = 'y')
#                 2.使用製程(sma54 = 'y')
        AFTER FIELD brb15  #消耗料件
            LET g_brb_o.brb15 = g_brb.brb15
	    LET l_dir1='D'
            #FUN-640208...............begin
            IF (NOT cl_null(g_brb.brb15)) AND (g_brb.brb15<>g_ima70) THEN
               CALL cl_err('','abm-209',1)
            END IF
            #FUN-640208...............end
 
          AFTER FIELD brb16  #替代特性
             IF g_brb.brb16 NOT MATCHES '[01257]' #bugno:7111 add 5   #FUN-A20037 add '7'
               THEN NEXT FIELD brb16
                    LET g_brb.brb16 = g_brb_o.brb16
                    DISPLAY BY NAME g_brb.brb16
                    NEXT FIELD brb16
             END IF
#             IF g_brb.brb16 != '0' AND (g_brb.brb16 != g_brb_o.brb16)
#                THEN CALL i505_prompt()   #詢問是否輸入取代或替代料件
#             END IF
             LET g_brb_o.brb16 = g_brb.brb16
 
          AFTER FIELD brb18     #投料時距
             LET l_dir1 = 'U'
             IF g_brb.brb18 < 0 THEN
                CALL cl_err(g_brb.brb18,'aim-223',0)
                NEXT FIELD brb18
             END IF
             IF cl_null(g_brb.brb18)
             THEN LET g_brb.brb18 = 0
                  DISPLAY BY NAME g_brb.brb18
             END IF
 
        AFTER FIELD brb23    #選中率
            IF g_brb.brb23 < 0 OR g_brb.brb23 > 100
               THEN CALL cl_err(g_brb.brb23,'mfg0013',0)
                    LET g_brb.brb23 = g_brb_o.brb23
                    DISPLAY BY NAME g_brb.brb23
                    NEXT FIELD brb23
            END IF
            LET g_brb_o.brb23 = g_brb.brb23
 
       AFTER FIELD brb28
            IF g_brb.brb28 < 0 OR g_brb.brb28 > 100
               THEN CALL cl_err(g_brb.brb28,'mfg0013',0)
                    LET g_brb.brb28 = g_brb_o.brb28
                    DISPLAY BY NAME g_brb.brb28
                    NEXT FIELD brb28
            END IF
            LET g_brb_o.brb28 = g_brb.brb28
 
       AFTER FIELD brb19
            IF g_brb.brb19 not matches '[1234]'
            THEN  LET g_brb.brb19 = g_brb_o.brb19
                  DISPLAY BY NAME g_brb.brb19
                  NEXT FIELD brb19
            END IF
            LET g_brb_o.brb19 = g_brb.brb19
 
          AFTER FIELD brb25     # Warehouse
            IF NOT cl_null(g_brb.brb25) THEN
                 CALL i505_brb25('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_brb.brb25,g_errno,0)
                    LET g_brb.brb25 = g_brb_o.brb25
                    DISPLAY BY NAME g_brb.brb25
                    NEXT FIELD brb25
                 END IF
                 IF NOT s_imfchk1(g_brb.brb03,g_brb.brb25)
                    THEN CALL cl_err(g_brb.brb25,'mfg9036',0)
                         NEXT FIELD brb25
                 END IF
                 CALL s_stkchk(g_brb.brb25,'A') RETURNING l_code
                 IF NOT l_code THEN
                     CALL cl_err(g_brb.brb25,'mfg1100',0)
                     NEXT FIELD brb25
                 END IF
            END IF
 
          AFTER FIELD brb26     # Location
            IF g_brb.brb26 IS NOT NULL AND g_brb.brb26 != ' ' THEN
               IF NOT s_imfchk(g_brb.brb03,g_brb.brb25,g_brb.brb26)
                 THEN CALL cl_err(g_brb.brb26,'mfg6095',0)
                      NEXT FIELD brb26
               END IF
            END IF
            IF g_brb.brb26 IS NULL THEN LET g_brb.brb26 = ' ' END IF
 
        AFTER INPUT
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF cl_null(g_brb.brb05)
               THEN IF g_brb.brb05 < g_brb.brb04
                       THEN CALL cl_err(g_brb.brb05,'mfg2604',0)
                            LET l_flag = 'Y'
                    END IF
            END IF
            IF cl_null(g_brb.brb10_fac) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_brb.brb10_fac
            END IF
            IF cl_null(g_brb.brb10_fac2) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_brb.brb10_fac2
            END IF
            IF cl_null(g_brb.brb14) OR g_brb.brb14 NOT MATCHES'[0123]' THEN 
               LET l_flag = 'Y'
               DISPLAY BY NAME g_brb.brb14
            END IF
            IF cl_null(g_brb.brb15) OR g_brb.brb15 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_brb.brb15
            END IF
            IF cl_null(g_brb.brb27) OR g_brb.brb27 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_brb.brb27
            END IF
            IF cl_null(g_brb.brb16) OR g_brb.brb16 NOT MATCHES'[0127]' THEN   
               LET l_flag = 'Y'
               DISPLAY BY NAME g_brb.brb16
            END IF
            IF cl_null(g_brb.brb18) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_brb.brb18
            END IF
            IF cl_null(g_brb.brb23) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_brb.brb23
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD  brb01
            END IF
		 ON KEY(F1)
			NEXT FIELD brb01
		 ON KEY(F2)
			NEXT FIELD brb06
			NEXT FIELD brb13
			NEXT FIELD brb25
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(brb01) #料件主檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bra2"   
                  LET g_qryparam.default1 = g_brb.brb01
                  CALL cl_create_qry() RETURNING g_brb.brb01
                  DISPLAY BY NAME g_brb.brb01
                  NEXT FIELD brb01
               WHEN INFIELD(brb03) #料件主檔
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima"
                #  LET g_qryparam.default1 = g_brb.brb03
                #  CALL cl_create_qry() RETURNING g_brb.brb03
                  CALL q_sel_ima(FALSE, "q_ima", "", g_brb.brb03, "", "", "", "" ,"",'' )  RETURNING g_brb.brb03  
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_brb.brb03
                  NEXT FIELD brb03
               WHEN INFIELD(brb09) #作業主檔
                  CALL q_ecd(FALSE,TRUE,g_brb.brb09)
                       RETURNING g_brb.brb09
                  DISPLAY BY NAME g_brb.brb09
                  NEXT FIELD brb09
               WHEN INFIELD(brb10) #單位檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_brb.brb10
                  CALL cl_create_qry() RETURNING g_brb.brb10
                  DISPLAY BY NAME g_brb.brb10
                  NEXT FIELD brb10
               WHEN INFIELD(brb25) #倉庫
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imfd"
                  LET g_qryparam.default1 = g_brb.brb25
                  CALL cl_create_qry() RETURNING g_brb.brb25
                  DISPLAY BY NAME g_brb.brb25
                  NEXT FIELD brb25
               WHEN INFIELD(brb26) #儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imfe"
                  LET g_qryparam.default1 = g_brb.brb26
                  CALL cl_create_qry() RETURNING g_brb.brb26
#                  CALL FGL_DIALOG_SETBUFFER( g_brb.brb26 )
                  DISPLAY BY NAME g_brb.brb26
                  NEXT FIELD brb26
            END CASE
#        ON ACTION bom_description
#                  IF g_brb_t.brb02 IS NOT NULL
#                     THEN LET l_cmd = "abmi603 '",g_brb.brb01,"'",
#                                      " '",g_brb.brb02,"' '",  #No.B062
#                                      g_brb.brb03,"' '",
#                                      g_brb.brb04,"' '",
#                                      g_brb.brb29,"'" CLIPPED #FUN-550093
#                             CALL cl_cmdrun(l_cmd)
#                  END IF
 
 
#        ON ACTION mntn_insert_loc      #建立插件位置
#                   IF g_brb_t.brb03 IS NOT NULL AND g_brb_t.brb03 != ' '
#                   THEN LET l_qpa = g_brb.brb06/g_brb.brb07
#                        CALL i200(g_brb.brb01,g_brb.brb02,
#                                   g_brb.brb03,g_brb.brb04,'u',l_qpa,g_brb.brb29) #FUN-550093
#                   END IF
 
        ON ACTION mntn_item_brand
              LET l_cmd="abmi650 '",g_brb.brb03,"' '",g_brb.brb01,"'"
	      CALL cl_cmdrun(l_cmd)
              NEXT FIELD brb03
 
        ON ACTION mntn_rep_sub
                IF g_brb.brb16 matches'[12]' THEN
                   LET l_cmd = "abmi604 '",g_brb.brb03,"' ",
                                       "'",g_brb.brb01,"' ",
                                       "'",g_brb.brb16,"' "
                   #-----MOD-9A0084---------
                   #CALL cl_cmdrun(l_cmd)   
                   CALL cl_cmdrun_wait(l_cmd)  
                   
                   LET l_n = 0 
                   SELECT COUNT(*) INTO l_n FROM bmd_file 
                    WHERE bmd01=g_brb.brb03  
                      AND bmdacti = 'Y'               
                   IF l_n = 0 THEN
                      UPDATE brb_file SET brb16 = '0'
                       WHERE brb01=g_brb.brb01 AND brb03=g_brb.brb03
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","brb_file",g_brb.brb01,g_brb.brb03,SQLCA.sqlcode,"","",0)
                       END IF
                   ELSE 
                      LET l_bmd02 = ''
                      SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
                         WHERE bmd01=g_brb.brb03 AND bmd08 = g_brb.brb01 
                           AND bmdacti = 'Y' 
                      IF NOT cl_null(l_bmd02) THEN
                         UPDATE brb_file SET brb16 = l_bmd02 
                          WHERE brb01=g_brb.brb01 AND brb03=g_brb.brb03
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","brb_file",g_brb.brb01,g_brb.brb03,SQLCA.sqlcode,"","",0)
                         END IF
                      ELSE
                         LET l_bmd02 = ''
                         SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
                            WHERE bmd01=g_brb.brb03 AND bmd08 = 'ALL' 
                              AND bmdacti = 'Y' 
                         IF NOT cl_null(l_bmd02) THEN
                            UPDATE brb_file SET brb16 = l_bmd02 
                             WHERE brb01=g_brb.brb01 AND brb03=g_brb.brb03
                            IF SQLCA.sqlcode THEN
                               CALL cl_err3("upd","brb_file",g_brb.brb01,g_brb.brb03,SQLCA.sqlcode,"","",0)
                            END IF
                         END IF
                      END IF  
                   END IF 
                   SELECT brb16 INTO g_brb.brb16 FROM brb_file
                     WHERE brb01 = g_brb.brb01 
                       AND brb29 = g_brb.brb29
                       AND brb02 = g_brb.brb02
                       AND brb03 = g_brb.brb03
                       AND brb04 = g_brb.brb04
                   DISPLAY BY NAME g_brb.brb16
                   #-----END MOD-9A0084-----
                END IF
       IF g_brb.brb16 matches'[7]' THEN
          LET l_cmd = "abmi6043  "                               
          CALL cl_cmdrun_wait(l_cmd)                  
       END IF

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
 
FUNCTION i505_prompt()
    DEFINE l_cmd    LIKE type_file.chr1000  
    DEFINE l_n      LIKE type_file.num5
    DEFINE l_bmd02  LIKE bmd_file.bmd02  
 
  IF g_brb.brb16 = '5' THEN RETURN END IF   
  IF g_brb.brb16 = '1' THEN
     CALL cl_getmsg('mfg2629',g_lang) RETURNING g_msg
  ELSE
     CALL cl_getmsg('mfg2716',g_lang) RETURNING g_msg
  END IF
  WHILE TRUE
            LET INT_FLAG = 0 
    PROMPT g_msg CLIPPED FOR g_chr
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about      
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
 
 
    END PROMPT
    IF g_chr  MATCHES'[YyNn]' THEN EXIT WHILE END IF
    IF INT_FLAG THEN LET INT_FLAG = 0 END IF
  END WHILE
  IF g_chr MATCHES '[Yy]'
     THEN  IF g_brb.brb16 MATCHES '[12]' THEN
                   LET l_cmd = "abmi604 '",g_brb.brb03,"' ",
                                       "'",g_brb.brb01,"' ",
                                       "'",g_brb.brb16,"' "
                   CALL cl_cmdrun_wait(l_cmd)  
                   
                   LET l_n = 0 
                   SELECT COUNT(*) INTO l_n FROM bmd_file 
                    WHERE bmd01=g_brb.brb03  
                      AND bmdacti = 'Y'               
                   IF l_n = 0 THEN
                      UPDATE brb_file SET brb16 = '0'
                       WHERE brb01=g_brb.brb01 AND brb03=g_brb.brb03
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","brb_file",g_brb.brb01,g_brb.brb03,SQLCA.sqlcode,"","",0)
                       END IF
                   ELSE 
                      LET l_bmd02 = ''
                      SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
                         WHERE bmd01=g_brb.brb03 AND bmd08 = g_brb.brb01 
                           AND bmdacti = 'Y' 
                      IF NOT cl_null(l_bmd02) THEN
                         UPDATE brb_file SET brb16 = l_bmd02 
                          WHERE brb01=g_brb.brb01 AND brb03=g_brb.brb03
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","brb_file",g_brb.brb01,g_brb.brb03,SQLCA.sqlcode,"","",0)
                         END IF
                      ELSE
                         LET l_bmd02 = ''
                         SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
                            WHERE bmd01=g_brb.brb03 AND bmd08 = 'ALL' 
                              AND bmdacti = 'Y' 
                         IF NOT cl_null(l_bmd02) THEN
                            UPDATE brb_file SET brb16 = l_bmd02 
                             WHERE brb01=g_brb.brb01 AND brb03=g_brb.brb03
                            IF SQLCA.sqlcode THEN
                               CALL cl_err3("upd","brb_file",g_brb.brb01,g_brb.brb03,SQLCA.sqlcode,"","",0)
                            END IF
                         END IF
                      END IF  
                   END IF 
                   SELECT brb16 INTO g_brb.brb16 FROM brb_file
                     WHERE brb01 = g_brb.brb01 
                       AND brb29 = g_brb.brb29
                       AND brb02 = g_brb.brb02
                       AND brb03 = g_brb.brb03
                       AND brb04 = g_brb.brb04
                   DISPLAY BY NAME g_brb.brb16
           END IF
       IF g_brb.brb16 matches'[7]' THEN
          LET l_cmd = "abmi6043  "                               
          CALL cl_cmdrun_wait(l_cmd)                  
       END IF        
  END IF
END FUNCTION
 
FUNCTION i505_brb01(p_cmd)  #主件料件
    DEFINE  l_ima02   LIKE ima_file.ima02,
            l_ima021  LIKE ima_file.ima021,
            l_imaacti LIKE ima_file.imaacti,
            p_cmd     LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima37,ima08,ima70,imaacti
      INTO l_ima02,l_ima021,g_ima37_h,g_ima08_h,g_ima70_h,l_imaacti
       FROM ima_file WHERE ima01 = g_brb.brb01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                            LET l_ima02   = NULL
                            LET l_ima021  = NULL
                            LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #--->來源碼為'Z':雜項料件
    IF g_ima08_h ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    SELECT bra05 INTO g_bra05 FROM bra_file WHERE bra01 = g_brb.brb01
    IF STATUS = 0 AND p_cmd = 'a' THEN
       IF NOT cl_null(g_bra05) AND g_sma.sma101 = 'N' THEN
          IF g_ima08_h MATCHES '[MPXTS]' THEN LET g_errno = 'abm-120' END IF
       END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_ima02 TO FORMONLY.ima02_h1
       DISPLAY l_ima021 TO FORMONLY.ima021_h1
       DISPLAY g_ima08_h TO FORMONLY.ima08_1
    END IF
END FUNCTION
 
FUNCTION i505_brb03(p_cmd)  #元件料件
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
      FROM ima_file WHERE ima01 = g_brb.brb03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL LET l_ima021= NULL
                                   LET l_ima105= NULL LET l_ima110= NULL
                                   LET l_imaacti = NULL
                                   LET g_ima70=NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima08_b = 'D' THEN LET g_brb.brb17 = 'Y'      #元件為feature flag
                       ELSE LET g_brb.brb17 = 'N'
    END IF
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z' THEN LET g_errno = 'mfg2752' RETURN END IF
    IF p_cmd = 'a' THEN
      LET g_brb.brb10 = g_ima63_b
      LET g_brb.brb15 = g_ima70_b
      LET g_brb.brb27 = l_ima105
      LET g_brb.brb19 = l_ima110
      LET g_brb.brb11 = l_ima04
      DISPLAY BY NAME g_brb.brb10
      DISPLAY BY NAME g_brb.brb19
      DISPLAY BY NAME g_brb.brb15
      DISPLAY BY NAME g_brb.brb27
      DISPLAY BY NAME g_brb.brb11
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02 TO FORMONLY.ima02_h2
       DISPLAY l_ima021 TO FORMONLY.ima021_h2
       DISPLAY g_ima08_b TO FORMONLY.ima08_2
    END IF
END FUNCTION
 
FUNCTION i505_bdate(p_cmd)
  DEFINE   l_brb04_a,l_brb04_i LIKE brb_file.brb04,
           l_brb05_a,l_brb05_i LIKE brb_file.brb05,
           p_cmd   LIKE type_file.chr1,     
           l_n     LIKE type_file.num10      
 
    LET g_errno = " "
    IF p_cmd = 'a' THEN
       SELECT COUNT(*) INTO l_n FROM brb_file
                            WHERE brb01 = g_brb.brb01   #主件
                              AND brb011 = g_brb.brb011 
                              AND brb012 = g_brb.brb012 
                              AND brb013 = g_brb.brb013 
                              AND  brb02 = g_brb.brb02   #項次
                              AND  brb04 = g_brb.brb04
                              AND  brb29 = g_brb.brb29
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    SELECT MAX(brb04),MAX(brb05) INTO l_brb04_a,l_brb05_a
                       FROM brb_file
                      WHERE brb01 = g_brb.brb01         #主件
                        AND brb011 = g_brb.brb011 
                        AND brb012 = g_brb.brb012 
                        AND brb013 = g_brb.brb013 
                        AND  brb02 = g_brb.brb02         #項次
                        AND  brb04 < g_brb.brb04         #生效日
                        AND  brb29 = g_brb.brb29
    IF g_brb.brb04 <  l_brb04_a THEN LET g_errno = 'mfg2737' END IF
 
    SELECT MIN(brb04),MIN(brb05) INTO l_brb04_i,l_brb05_i
                       FROM brb_file
                      WHERE brb01 = g_brb.brb01         #主件
                        AND brb011 = g_brb.brb011 
                        AND brb012 = g_brb.brb012 
                        AND brb013 = g_brb.brb013
                        AND  brb02 = g_brb.brb02         #項次
                        AND  brb04 > g_brb.brb04         #生效日
                        AND  brb29 = g_brb.brb29 
 
    IF l_brb04_i IS NULL AND l_brb05_i IS NULL THEN RETURN END IF
    IF l_brb04_a IS NULL AND l_brb05_a IS NULL THEN
       IF g_brb.brb04 < l_brb04_i THEN LET g_errno = 'mfg2737' END IF
    END IF
    IF g_brb.brb04 > l_brb04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION
 
FUNCTION i505_edate(p_cmd)
  DEFINE   l_brb04_i   LIKE brb_file.brb04,
           l_brb04_a   LIKE brb_file.brb04,
           p_cmd       LIKE type_file.chr1,   
           l_n         LIKE type_file.num5     
 
    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n FROM brb_file
                      WHERE brb01 = g_brb.brb01         #主件
                        AND brb011 = g_brb.brb011 
                        AND brb012 = g_brb.brb012 
                        AND brb013 = g_brb.brb013 
                        AND brb02 = g_brb.brb02   #項次
                       AND  brb29 = g_brb.brb29 
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(brb04) INTO l_brb04_i
                       FROM brb_file
                      WHERE brb01 = g_brb.brb01         #主件
                        AND brb011 = g_brb.brb011 
                        AND brb012 = g_brb.brb012 
                        AND brb013 = g_brb.brb013 
                       AND  brb02 = g_brb.brb02         #項次
                       AND  brb04 > g_brb.brb04         #生效日
                       AND  brb29 = g_brb.brb29
   SELECT MAX(brb04) INTO l_brb04_a
                       FROM brb_file
                      WHERE brb01 = g_brb.brb01         #主件
                        AND brb011 = g_brb.brb011 
                        AND brb012 = g_brb.brb012 
                        AND brb013 = g_brb.brb013 
                        AND  brb02 = g_brb.brb02         #項次
                        AND  brb04 > g_brb.brb04         #生效日
                        AND  brb29 = g_brb.brb29
   IF l_brb04_i IS NULL THEN RETURN END IF
   IF g_brb.brb05 > l_brb04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION
 
FUNCTION i505_brb25(p_cmd)  
    DEFINE p_cmd     LIKE type_file.chr1,      
           l_imd02   LIKE imd_file.imd02,
           l_imdacti LIKE imd_file.imdacti
 
    LET g_errno = ' '
    SELECT  imd02,imdacti INTO l_imd02,l_imdacti FROM imd_file
            WHERE imd01 = g_brb.brb25
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
                            LET l_imd02 = NULL
                            LET l_imdacti= NULL
         WHEN l_imdacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#=====>此FUNCTION 目的在update 上一筆的失效日
FUNCTION i505_update(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,     
         l_brb02   LIKE brb_file.brb02,
         l_brb03   LIKE brb_file.brb03,
         l_brb04   LIKE brb_file.brb04,
         l_brb29   LIKE brb_file.brb29 
 
#    IF p_cmd ='u' THEN
#       #--->更新BOM說明檔(bmc_file)的index key
#       UPDATE bmc_file SET bmc02  = g_brb.brb02,
#                           bmc021 = g_brb.brb03,
#                           bmc03  = g_brb.brb04,
#                           bmc06  = g_brb.brb29 
#                       WHERE bmc01 = g_brb.brb01
#                         AND bmc02 = g_brb_t.brb02
#                         AND bmc021= g_brb_t.brb03
#                         AND bmc03 = g_brb_t.brb04
#                         AND bmc06 = g_brb_t.brb29
#    END IF
    DECLARE i505_update SCROLL CURSOR  FOR
            SELECT brb02,brb03,brb04,brb29 FROM brb_file
                   WHERE brb01 = g_brb.brb01 AND
                         brb011 = g_brb.brb011 AND
                         brb012 = g_brb.brb012 AND
                         brb013 = g_brb.brb013 AND                   
                         brb02 = g_brb.brb02 AND
                         (brb04 < g_brb.brb04)       #生效日
                         AND  brb29 = g_brb.brb29 
                   ORDER BY brb04
    OPEN i505_update
    FETCH LAST i505_update INTO l_brb02,l_brb03,l_brb04,l_brb29 
    IF SQLCA.sqlcode = 0
       THEN UPDATE brb_file SET brb05 = g_brb.brb04,
                                brbmodu = g_user,    
                                brbdate = g_today, 
                                brbcomm = "abmi505" 
                          WHERE brb01 = g_brb.brb01 AND
                                brb011 = g_brb.brb011 AND
                                brb012 = g_brb.brb012 AND
                                brb013 = g_brb.brb013 AND
                                brb02 = l_brb02 AND
                                brb03 = l_brb03 AND
                                brb04 = l_brb04 AND
                                brb29 = l_brb29 
           IF SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","brb_file",g_brb.brb01,l_brb02,"mfg2635","","",1)  
           END IF

          UPDATE bra_file SET bramodu = g_user,
                                bradate = g_today  
                          WHERE bra01 = g_brb.brb01 AND
                                bra011 = g_brb.brb011 AND
                                bra012 = g_brb.brb012 AND
                                bra013 = g_brb.brb013 AND
                                bra06 = l_brb29 
           IF SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","bra_file",g_brb.brb01,"","aap-161","","",1)  
           END IF

    END IF
    CLOSE i505_update
END FUNCTION
 
FUNCTION i505_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_brb.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i505_curs()                          
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_brb.* TO NULL
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i505_count
    FETCH i505_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i505_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_brb.brb01 CLIPPED,'+',g_brb.brb011 CLIPPED,'+',g_brb.brb012 CLIPPED,'+',
                      g_brb.brb013 CLIPPED,'+',g_brb.brb02 CLIPPED,'+',g_brb.brb03 CLIPPED,'+',g_brb.brb04,
                      '+',g_brb.brb29                   
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_brb.* TO NULL
    ELSE
        CALL i505_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i505_fetch(p_flbrb)
    DEFINE
        p_flbrb      LIKE type_file.chr1     
 
    CASE p_flbrb
        WHEN 'N' FETCH NEXT     i505_curs INTO g_brb.brb01,
                                               g_brb.brb011,
                                               g_brb.brb012,
                                               g_brb.brb013, 
                                               g_brb.brb02,
                                               g_brb.brb03,
                                               g_brb.brb04,
                                               g_brb.brb13,
                                               g_brb.brb29
                                                                                             
        WHEN 'P' FETCH PREVIOUS i505_curs INTO g_brb.brb01,
                                               g_brb.brb011,
                                               g_brb.brb012,
                                               g_brb.brb013,         
                                               g_brb.brb02,
                                               g_brb.brb03,
                                               g_brb.brb04,
                                               g_brb.brb13,
                                               g_brb.brb29                                               
        WHEN 'F' FETCH FIRST    i505_curs INTO g_brb.brb01,
                                               g_brb.brb011,
                                               g_brb.brb012,
                                               g_brb.brb013,         
                                               g_brb.brb02,
                                               g_brb.brb03,
                                               g_brb.brb04,
                                               g_brb.brb13,
                                               g_brb.brb29                                              
        WHEN 'L' FETCH LAST     i505_curs INTO g_brb.brb01,
                                               g_brb.brb011,
                                               g_brb.brb012,
                                               g_brb.brb013,         
                                               g_brb.brb02,
                                               g_brb.brb03,
                                               g_brb.brb04,
                                               g_brb.brb13,
                                               g_brb.brb29                                              
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
            FETCH ABSOLUTE g_jump i505_curs INTO g_brb.brb01,
                                                 g_brb.brb02,
                                                 g_brb.brb03,
                                                 g_brb.brb04,
                                                 g_brb.brb13,
                                                 g_brb.brb29,
                                                 g_brb.brb011,
                                                 g_brb.brb012,
                                                 g_brb.brb013                                                 
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_brb.brb01 CLIPPED,'+',g_brb.brb011 CLIPPED,'+',g_brb.brb012 CLIPPED,'+',
                  g_brb.brb013 CLIPPED,'+',g_brb.brb02 CLIPPED,'+',g_brb.brb03 CLIPPED,'+',g_brb.brb04,
                  '+',g_brb.brb29 
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_brb.* TO NULL  
        RETURN
    ELSE
       CASE p_flbrb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_brb.* FROM brb_file            # 重讀DB,因TEMP有不被更新特性
     WHERE brb01=g_brb.brb01 AND brb011 = g_brb.brb011 AND brb012 = g_brb.brb012 AND brb013 = g_brb.brb013 
       AND brb02=g_brb.brb02 AND brb03=g_brb.brb03 AND brb04=g_brb.brb04 AND brb29=g_brb.brb29
    IF SQLCA.sqlcode THEN
        LET g_msg=g_brb.brb01 CLIPPED,'+',g_brb.brb011 CLIPPED,'+',g_brb.brb012 CLIPPED,'+',
                  g_brb.brb013 CLIPPED,'+',g_brb.brb02 CLIPPED,'+',g_brb.brb03 CLIPPED,'+',g_brb.brb04,
                  '+',g_brb.brb29 
        CALL cl_err3("sel","brb_file",g_msg,"",SQLCA.sqlcode,"","",1) 
    ELSE
        CALL i505_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i505_show()
DEFINE  l_ecu014   LIKE ecu_file.ecu014
DEFINE  l_ecu03    LIKE ecu_file.ecu03 

    LET g_brb_t.* = g_brb.*
    LET g_brb_o.* = g_brb.*
    DISPLAY BY NAME g_brb.brb01,g_brb.brb011,g_brb.brb012,g_brb.brb013,
                    g_brb.brb02,g_brb.brb29,g_brb.brb03,g_brb.brb04, 
                    g_brb.brb05,g_brb.brb10,g_brb.brb10_fac,
                    g_brb.brb10_fac2,g_brb.brb06,g_brb.brb07,
                    g_brb.brb08,g_brb.brb23,g_brb.brb11,g_brb.brb13,
                    g_brb.brb16,g_brb.brb09,g_brb.brb18,
                    g_brb.brb27,g_brb.brb15,g_brb.brb14,
                    g_brb.brb19,g_brb.brb28,
                    g_brb.brb25,g_brb.brb26,g_brb.brb24,
                    g_brb.brbmodu,g_brb.brbdate,g_brb.brbcomm
    SELECT DISTINCT ecu03 INTO l_ecu03 FROM ecu_file WHERE ecu01=g_brb.brb01 AND ecu02=g_brb.brb011
    SELECT ecu014 INTO l_ecu014 FROM ecu_file WHERE ecu01=g_brb.brb01 AND ecu02=g_brb.brb011
       AND ecu012=g_brb.brb012
    DISPLAY l_ecu014 TO ecu014
    DISPLAY l_ecu03 TO ecu03
    CALL i505_brb01('d')
    CALL i505_brb03('d')
    CALL cl_show_fld_cont()                 
END FUNCTION
 
FUNCTION i505_u()
 
    IF cl_null(g_brb.brb01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_brb01_t = g_brb.brb01
    LET g_brb011_t = g_brb.brb011
    LET g_brb012_t = g_brb.brb012
    LET g_brb013_t = g_brb.brb013
    LET g_brb02_t = g_brb.brb02
    LET g_brb03_t = g_brb.brb03
    LET g_brb04_t = g_brb.brb04
    LET g_brb29_t = g_brb.brb29
    LET g_brb_o.* = g_brb.*
 
    BEGIN WORK
    OPEN i505_curl USING g_brb.brb01,g_brb.brb02,g_brb.brb03,g_brb.brb04,g_brb.brb29,g_brb.brb011,g_brb.brb012,g_brb.brb013
 
    IF STATUS THEN
       CALL cl_err("OPEN i505_curl:", STATUS, 1)
       CLOSE i505_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i505_curl INTO g_brb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        LET g_msg=g_brb.brb01 CLIPPED,'+',g_brb.brb011 CLIPPED,'+',g_brb.brb012 CLIPPED,'+',
                  g_brb.brb013 CLIPPED,'+',g_brb.brb02 CLIPPED,'+',g_brb.brb03 CLIPPED,'+',g_brb.brb04,
                  '+',g_brb.brb29 
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i505_show()                          # 顯示最新資料
    WHILE TRUE
    #modify需考慮參數sma101:『 BOM表發放後是否可以修改單身』
        SELECT ima08 INTO g_ima08 FROM ima_file WHERE ima01 = g_brb.brb01
        SELECT bra05 INTO g_bra05 FROM bra_file WHERE bra01 = g_brb.brb01
        IF NOT cl_null(g_bra05) AND g_sma.sma101 = 'N' THEN
           IF g_ima08 MATCHES '[MPXTS]' THEN
              CALL cl_err('','abm-120',0)
              RETURN
           END IF
        END IF
        LET g_brb.brbmodu = g_user    
        LET g_brb.brbdate = g_today  
        LET g_brb.brbcomm = 'abmi505'
        CALL i505_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_brb.*=g_brb_t.*
            CALL i505_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE brb_file SET brb_file.* = g_brb.*    # 更新DB
         WHERE brb01=g_brb01_t AND brb011=g_brb011_t AND brb012=g_brb012_t AND brb013=g_brb013_t 
          AND brb02=g_brb02_t AND brb03=g_brb03_t AND brb04=g_brb04_t AND brb29=g_brb29_t  
        IF SQLCA.SQLERRD[3] = 0 THEN
            LET g_msg=g_brb.brb01 CLIPPED,'+',g_brb.brb011 CLIPPED,'+',g_brb.brb012 CLIPPED,'+',
                      g_brb.brb013 CLIPPED,'+',g_brb.brb02 CLIPPED,'+',g_brb.brb03 CLIPPED,'+',g_brb.brb04,
                      '+',g_brb.brb29  
             CALL cl_err3("upd","brb_file",g_brb01_t,g_brb02_t,SQLCA.sqlcode,"",g_msg,1)   #TQC-660046
            CONTINUE WHILE
        END IF
        #--->上筆生效日之處理/BOM 說明檔(bmc_file) unique key
        CALL i505_update('u')
#        IF g_ima08_h = 'A' THEN      #主件為family 時
#           CALL p500_tm(0,0,g_brb.brb01)
#        END IF
        EXIT WHILE
    END WHILE
    CLOSE i505_curl
	COMMIT WORK
END FUNCTION
 
FUNCTION i505_r()
    DEFINE
        l_chr    LIKE type_file.chr1      
 
    IF cl_null(g_brb.brb01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    #modify需考慮參數sma101:『 BOM表發放後是否可以修改單身』
        SELECT ima08 INTO g_ima08 FROM ima_file WHERE ima01 = g_brb.brb01
        SELECT bra05 INTO g_bra05 FROM bra_file WHERE bra01 = g_brb.brb01
        IF NOT cl_null(g_bra05) AND g_sma.sma101 = 'N' THEN
           IF g_ima08 MATCHES '[MPXTS]' THEN
              CALL cl_err('','abm-120',0)
              RETURN
           END IF
        END IF

    BEGIN WORK
    OPEN i505_curl USING g_brb.brb01,g_brb.brb02,g_brb.brb03,g_brb.brb04,g_brb.brb29,g_brb.brb011,g_brb.brb012,g_brb.brb013
    IF STATUS THEN
       CALL cl_err("OPEN i505_curl:", STATUS, 1)
       CLOSE i505_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i505_curl INTO g_brb.*
    IF SQLCA.sqlcode THEN
       LET g_msg=g_brb.brb01 CLIPPED,'+',g_brb.brb011 CLIPPED,'+',g_brb.brb012 CLIPPED,'+',
                 g_brb.brb013 CLIPPED,'+',g_brb.brb02 CLIPPED,'+',g_brb.brb03 
                 CLIPPED,'+',g_brb.brb04,'+',g_brb.brb29 
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i505_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL            
        LET g_doc.column1 = "brb01"           
        LET g_doc.value1  = g_brb.brb01       
        LET g_doc.column2 = "brb02"           
        LET g_doc.value2  = g_brb.brb02       
        LET g_doc.column3 = "brb03"           
        LET g_doc.value3  = g_brb.brb03       
        LET g_doc.column4 = "brb04"           
        LET g_doc.value4  = g_brb.brb04       
        LET g_doc.column5 = "brb29"           
        LET g_doc.value5  = g_brb.brb29       
        #LET g_doc.column6 = "brb011" 
        #LET g_doc.value6 = g_brb.brb011
        #LET g_doc.column7 = "brb012" 
        #LET g_doc.value7 = g_brb.brb012
        #LET g_doc.column8 = "brb013" 
        #LET g_doc.value8 = g_brb.brb013
        CALL cl_del_doc()                                        
#       IF g_sma.sma845='Y'   #低階碼可否部份重計
#          THEN
#          LET g_success='Y'
#          CALL s_uima146(g_brb.brb03)
#          MESSAGE ""
#       END IF
 
       DELETE FROM brb_file WHERE brb01 = g_brb.brb01
                              AND brb011= g_brb.brb011
                              AND brb012= g_brb.brb012
                              AND brb013= g_brb.brb013
                              AND brb02 = g_brb.brb02
                              AND brb03 = g_brb.brb03
                              AND brb04 = g_brb.brb04
                              AND brb29 = g_brb.brb29 
                              
#       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     
#           VALUES ('abmi505',g_user,g_today,g_msg,g_brb.brb01,'delete',g_plant,g_legal)
 
       LET g_brb.brb01 = NULL LET g_brb.brb011 = NULL LET g_brb.brb012 = NULL 
       LET g_brb.brb013= NULL LET g_brb.brb02 = NULL  LET g_brb.brb03 = NULL 
       LET g_brb.brb04 = NULL LET g_brb.brb29 = NULL
       INITIALIZE g_brb.* TO NULL
       CLEAR FORM
       OPEN i505_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i505_curl
          CLOSE i505_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i505_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i505_curl
          CLOSE i505_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i505_curs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i505_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i505_fetch('/')
       END IF
       LET g_msg=TIME
    END IF
    CLOSE i505_curl
	COMMIT WORK
END FUNCTION
 
FUNCTION i505_copy()
    DEFINE
        l_n               LIKE type_file.num5,     
        l_brb RECORD LIKE brb_file.*,
        l_newno1,l_oldno1 LIKE brb_file.brb01,
        l_newno2,l_oldno2 LIKE brb_file.brb02,
        l_newno3,l_oldno3 LIKE brb_file.brb03,
        l_newno4,l_oldno4 LIKE brb_file.brb04,
        l_newno5,l_oldno5 LIKE brb_file.brb29
 
    IF g_brb.brb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET l_newno1  = NULL  LET l_newno2 = NULL
    LET l_newno3  = NULL  LET l_newno4 = NULL
    LET l_newno5  = NULL  LET l_newno5 = NULL 
 
    LET g_before_input_done = FALSE
    CALL i505_set_entry('a')
    LET g_before_input_done = TRUE
    LET l_newno1=g_brb.brb01
    INPUT 
    #l_newno1,
    l_newno2,l_newno3,l_newno4,l_newno5 WITHOUT DEFAULTS 
       FROM 
       #brb01,
       brb02,brb03,brb04,brb29 
 
#        BEFORE FIELD brb01
#	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
#	       THEN CALL s_inp5(7,15,l_newno1) RETURNING l_newno1
#	            DISPLAY l_newno1 TO brb01
#	    END IF
# 
#        AFTER FIELD brb01
#            IF l_newno1 IS NOT NULL THEN
#               SELECT ima08 INTO g_ima08 FROM ima_file WHERE ima01 = l_newno1
#               IF SQLCA.sqlcode THEN 
#                  CALL cl_err3("sel","ima_file",l_newno1,"","mfg2717","","",1)  
#                  NEXT FIELD brb01
#               END IF
#               SELECT bra05 INTO g_bra05 FROM bra_file
#                WHERE bra01 = g_brb.brb01
#               IF STATUS = 0 THEN
#                  IF NOT cl_null(g_bra05) AND g_sma.sma101 = 'N' THEN
#                     IF g_ima08_h MATCHES '[MPXTS]' THEN
#                         CALL cl_err(l_newno1,'abm-120',1) NEXT FIELD brb01
#                     END IF
#                  END IF
#               END IF
#            END IF
 
        BEFORE FIELD brb03
	        IF g_sma.sma60 = 'Y'		# 若須分段輸入
	           THEN CALL s_inp5(10,15,l_newno3) RETURNING l_newno3
	           DISPLAY l_newno3 TO brb03
	        END IF
 
        AFTER FIELD brb03
            IF l_newno3 IS NOT NULL THEN
               IF l_newno1=l_newno3 THEN
                  NEXT FIELD brb03
               ELSE
                 #FUN-AA0059 -----------------------------add start---------------------
                 IF NOT s_chk_item_no(l_newno1,'') THEN
                    CALL cl_err('',g_errno,1)
                    NEXT FIELD brb03
                 END IF  
                 #FUN-AA0059 ----------------------------add end------------------------  
                 SELECT ima01 FROM ima_file WHERE ima01 = l_newno3
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("sel","ima_file",l_newno3,"","mfg2717","","",1) 
                       NEXT FIELD brb03
                    END IF
               END IF
            END IF
 
        AFTER FIELD brb04
            IF l_newno4 IS NOT NULL THEN
               SELECT count(*) INTO g_cnt FROM brb_file
                   WHERE brb01 = l_newno1 AND brb02 = l_newno2
                     AND brb03 = l_newno3 AND brb04 = l_newno4
               IF g_cnt > 0 THEN
                   LET g_msg=l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',
                             l_newno3 CLIPPED,'+',l_newno4
                   CALL cl_err(g_msg,-239,0)
                   NEXT FIELD brb01
               END IF
            END IF
        AFTER INPUT
         ON ACTION controlp
            CASE
#               WHEN INFIELD(brb01) #料件主檔
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = l_newno1
#                  CALL cl_create_qry() RETURNING l_newno1
#                   DISPLAY l_newno1 TO brb01         
#                  NEXT FIELD brb01
               WHEN INFIELD(brb03) #料件主檔
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima"
                #  LET g_qryparam.default1 = l_newno3
                #  CALL cl_create_qry() RETURNING l_newno3
                  CALL q_sel_ima(FALSE, "q_ima", "",l_newno3, "", "", "", "" ,"",'' )  RETURNING l_newno3
#FUN-AA0059 --End--
                  DISPLAY l_newno3 TO brb03           
                  NEXT FIELD brb03
            END CASE
 
         ON ACTION controlg       
            CALL cl_cmdask()     
 
         ON IDLE g_idle_seconds  
            CALL cl_on_idle()   
            CONTINUE INPUT    
 
         ON ACTION about          
            CALL cl_about()   
 
         ON ACTION help          
            CALL cl_show_help() 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_brb.brb01
        DISPLAY BY NAME g_brb.brb02
        DISPLAY BY NAME g_brb.brb03
        DISPLAY BY NAME g_brb.brb04
        DISPLAY BY NAME g_brb.brb29 
        RETURN
    END IF
    IF l_newno5 IS NULL THEN LET l_newno5=' ' END IF

    DROP TABLE x

    SELECT * FROM brb_file
     WHERE brb01=g_brb.brb01 
       AND brb02=g_brb.brb02 
       AND brb03=g_brb.brb03
       AND brb04=g_brb.brb04 
       AND brb29=g_brb.brb29
       AND brb012=g_brb.brb012  #FUN-A70125
       AND brb013=g_brb.brb013  #FUN-A70125
      INTO TEMP x

    UPDATE x
        SET brb01=l_newno1,   #資料鍵值-1
            brb02=l_newno2,   #資料鍵值-2
            brb03=l_newno3,   #資料鍵值-3
            brb04=l_newno4,   #資料鍵值-4
            brb29=l_newno5, 
            brb24=NULL        #工程變異單號ECN
    INSERT INTO brb_file
        SELECT * FROM x

    IF SQLCA.sqlcode THEN
       LET g_msg=g_brb.brb01 CLIPPED,'+',g_brb.brb011 CLIPPED,'+',g_brb.brb012 CLIPPED,'+',
                 g_brb.brb013 CLIPPED,'+',g_brb.brb02 CLIPPED,'+',g_brb.brb03 CLIPPED,'+',g_brb.brb04,
                 '+',g_brb.brb29 
         CALL cl_err3("ins","brb_file",g_brb.brb01,g_brb.brb02,SQLCA.sqlcode,"",g_msg,1)   
    ELSE
       LET g_msg=g_brb.brb01 CLIPPED,'+',g_brb.brb011 CLIPPED,'+',g_brb.brb012 CLIPPED,'+',
                 g_brb.brb013 CLIPPED,'+',g_brb.brb02 CLIPPED,'+',g_brb.brb03 CLIPPED,'+',g_brb.brb04,
                 '+',g_brb.brb29  
        MESSAGE 'ROW(',g_msg,') O.K'
        LET l_oldno1 = g_brb.brb01
        LET l_oldno2 = g_brb.brb02
        LET l_oldno3 = g_brb.brb03
        LET l_oldno4 = g_brb.brb04
        LET l_oldno5 = g_brb.brb29
        SELECT brb_file.* INTO g_brb.*
                FROM brb_file WHERE brb01 = l_newno1 AND
                     brb02=l_newno2  AND brb03=l_newno3
                     AND brb04=l_newno4
                     AND brb29=l_newno5 
        CALL i505_u()
        #FUN-C30027---bgin
        #SELECT brb_file.* INTO g_brb.*
        #        FROM brb_file WHERE brb01 = l_oldno1 AND
        #             brb02=l_oldno2  AND brb03=l_oldno3
        #             AND brb04=l_oldno4 AND brb29=l_oldno5 
        #CALL i505_show()
        #FUN-C30027---end
#        IF g_sma.sma845='Y'   #低階碼可否部份重計
#           THEN
#           LET g_success='Y'
#           CALL s_uima146(l_newno3)
#           MESSAGE ""
#        END IF
    END IF
    DISPLAY BY NAME g_brb.brb01
    DISPLAY BY NAME g_brb.brb011
    DISPLAY BY NAME g_brb.brb012
    DISPLAY BY NAME g_brb.brb013
    DISPLAY BY NAME g_brb.brb02
    DISPLAY BY NAME g_brb.brb03
    DISPLAY BY NAME g_brb.brb04
    DISPLAY BY NAME g_brb.brb29
END FUNCTION
 
FUNCTION i505_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("brb01,brb011,brb012,brb013,brb02,brb03,brb04",TRUE)
      IF g_sma.sma118='Y' THEN
         CALL cl_set_comp_entry("brb29",TRUE)
      END IF

   END IF
END FUNCTION
 
FUNCTION i505_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1     
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("brb01,brb011,brb012,brb013,brb02,brb03,brb04,brb19,brb29",FALSE) 
   END IF
   IF NOT cl_null(g_argv1) AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("brb01",FALSE)
   END IF
   IF g_sma.sma12 = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("brb26",FALSE)
   END IF

   IF NOT (g_sma.sma118='Y') THEN
      CALL cl_set_comp_entry("brb29",FALSE)
   END IF

END FUNCTION
 

