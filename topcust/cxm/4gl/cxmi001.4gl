# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cxmi001.4gl
# Descriptions...: 流程单
# Date & Author..: 16/06/13 BY guanyao
# Modify.........: No:160712      By guanyao 16/07/12  修改主键，将主键变成tc_dhyud02

IMPORT os                                                
DATABASE ds                                             
 
GLOBALS "../../../tiptop/config/top.global"                        
                        
          
 
DEFINE g_tc_dhy                 RECORD LIKE tc_dhy_file.*
DEFINE g_tc_dhy_t               RECORD LIKE tc_dhy_file.*     
DEFINE g_tc_dhy05_t             LIKE tc_dhy_file.tc_dhy05        
DEFINE g_wc                  STRING                             
DEFINE g_sql                 STRING                      
DEFINE g_forupd_sql          STRING                      
DEFINE g_before_input_done   LIKE type_file.num5         
DEFINE g_chr,g_chr1,g_chr2   LIKE tc_dhy_file.tc_dhyacti
DEFINE g_void                LIKE tc_dhy_file.tc_dhyacti
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5        
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10          
DEFINE g_jump                LIKE type_file.num10    
DEFINE g_no_ask              LIKE type_file.num5       
 
MAIN
    OPTIONS

        INPUT NO WRAP                          
    DEFER INTERRUPT                           

   IF (NOT cl_user()) THEN                     
      EXIT PROGRAM                            
   END IF

   WHENEVER ERROR CALL cl_err_msg_log         
 
   IF (NOT cl_setup("CXM")) THEN               
      EXIT PROGRAM                             
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time          
   INITIALIZE g_tc_dhy.* TO NULL
 
   #LET g_forupd_sql = "SELECT * FROM tc_dhy_file WHERE tc_dhy05 = ? FOR UPDATE "        #mark by guanyao160712
   LET g_forupd_sql = "SELECT * FROM tc_dhy_file WHERE tc_dhyud02 = ? FOR UPDATE "        #mark by guanyao160712
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)          
   DECLARE i001_cl CURSOR FROM g_forupd_sql                
 
   OPEN WINDOW i001_w WITH FORM "cxm/42f/cxmi001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)             
   CALL cl_ui_init()                                       

   LET g_action_choice = ""
   CALL i001_menu()                                        
 
   CLOSE WINDOW i001_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time          
END MAIN
 


FUNCTION i001_curs()
    CLEAR FORM
    INITIALIZE g_tc_dhy.* TO NULL   
    CONSTRUCT BY NAME g_wc ON                              
        tc_dhy00,tc_dhy01,tc_dhy02,tc_dhy03,tc_dhy04,tc_dhy05,tc_dhy06,tc_dhy07,
        tc_dhy08,tc_dhy09,tc_dhy10,tc_dhy11,tc_dhy12,tc_dhy13,tc_dhy14,tc_dhy15,
        tc_dhy16,tc_dhy17,tc_dhy18,tc_dhy19,tc_dhy20,tc_dhy21,tc_dhy22,tc_dhy23,
        tc_dhy24,tc_dhy241,tc_dhy25,tc_dhy26,tc_dhy261,tc_dhy27,tc_dhy271,tc_dhy28,
        tc_dhy29,tc_dhy291,tc_dhy30,tc_dhy301,tc_dhy31,tc_dhy311,tc_dhy32,tc_dhy321,
        tc_dhy33,tc_dhy331,tc_dhy34,tc_dhy35,tc_dhy36,tc_dhy37,tc_dhy38,tc_dhy39,
        tc_dhy40,tc_dhy41, 
        tc_dhyacti,tc_dhyuser,tc_dhygrup,tc_dhymodu,tc_dhydate,
        tc_dhyud01,tc_dhyud02,tc_dhyud03,tc_dhyud04,tc_dhyud05,tc_dhyud06,tc_dhyud07,
        tc_dhyud08,tc_dhyud09,tc_dhyud10,tc_dhyud11,tc_dhyud12,tc_dhyud13,tc_dhyud14,tc_dhyud15

        BEFORE CONSTRUCT                                   
           CALL cl_qbe_init()                              


        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_dhy01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima011"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_dhy.tc_dhy01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_dhy01
                 NEXT FIELD tc_dhy01

              WHEN INFIELD(tc_dhy03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_occ02"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_dhy.tc_dhy03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_dhy03
                 CALL i001_tc_dhy03('a')
                 NEXT FIELD tc_dhy03
 
              OTHERWISE
                 EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds                                
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about                                      
         CALL cl_about()  

      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help                                       
         CALL cl_show_help()  
 
      ON ACTION controlg                                    
         CALL cl_cmdask()  
 
      ON ACTION qbe_select                                 
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    
         CALL cl_qbe_save()
    END CONSTRUCT
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_dhyuser', 'tc_dhygrup')  
                                                                     

    LET g_sql = "SELECT tc_dhy05 FROM tc_dhy_file ",                       
                " WHERE ",g_wc CLIPPED, " ORDER BY tc_dhyud02"
    PREPARE i001_prepare FROM g_sql
    DECLARE i001_cs                                                 
        SCROLL CURSOR WITH HOLD FOR i001_prepare

    LET g_sql = "SELECT COUNT(*) FROM tc_dhy_file WHERE ",g_wc CLIPPED
    PREPARE i001_precount FROM g_sql
    DECLARE i001_count CURSOR FOR i001_precount
END FUNCTION
 

FUNCTION i001_menu()
    DEFINE l_cmd    STRING 

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i001_a()
            END IF

        ON ACTION gc
           LET g_action_choice="gc"
           IF cl_chk_act_auth() THEN 
              CALL i001_u1('c')
           END IF

        ON ACTION sg
           LET g_action_choice="sg"
           IF cl_chk_act_auth() THEN 
              CALL i001_u1('s')
           END IF

        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
              CALL i001_confirm()
              CALL i001_show_pic()
           END IF
 
        ON ACTION unconfirm
           LET g_action_choice="unconfirm"
           IF cl_chk_act_auth() THEN
              CALL i001_unconfirm()
              CALL i001_show_pic()
           END IF

         ON ACTION void
            LET g_action_choice="void"
            IF cl_chk_act_auth() THEN
               CALL i001_x(1) 
               CALL i001_show_pic()  
            END IF

         ON ACTION undo_void
            LET g_action_choice="undo_void"
            IF cl_chk_act_auth() THEN
               CALL i001_x(2)
               CALL i001_show_pic()
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

       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN 
               CALL i001_out()                         
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
 
       { ON ACTION generate_link
           CALL cl_generate_shortcut()}
 
        ON ACTION close 
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
       { ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_tc_dhy.tc_dhy05 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_dhy05"
                 LET g_doc.value1 = g_tc_dhy.tc_dhy05
                 CALL cl_doc()
              END IF
           END IF}

         #&include "qry_string.4gl"
    END MENU
    CLOSE i001_cs
END FUNCTION
 
 
FUNCTION i001_a()
#str------add by guanyao160712
DEFINE l_y       LIKE type_file.chr10
DEFINE l_m       LIKE type_file.chr10
DEFINE l_str     LIKE type_file.chr20
DEFINE l_tmp     LIKE type_file.chr20
#end------add by guanyao160712

    CLEAR FORM                                  
    INITIALIZE g_tc_dhy.* LIKE tc_dhy_file.*
    LET g_tc_dhy05_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        #str-----add by guanyao160712
        LET l_y =YEAR(g_today)
        LET l_y = l_y USING '&&&&' 
        LET l_y = l_y[3,4]
        LET l_m =MONTH(g_today)
        LET l_m = l_m USING '&&' 
        LET l_str=l_y clipped,l_m CLIPPED
        SELECT max(substr(tc_dhyud02,9,12)) INTO l_tmp FROM tc_dhy_file
         WHERE substr(tc_dhyud02,1,8)=l_str
        IF cl_null(l_tmp) THEN 
           LET l_tmp = '0001' 
        ELSE 
           LET l_tmp = l_tmp + 1
           LET l_tmp = l_tmp USING '&&&&'     
        END IF 
        LET g_tc_dhy.tc_dhyud02 ='PCD-' CLIPPED,l_str clipped,l_tmp
        #end-----add by guanyao160712
        LET g_tc_dhy.tc_dhyuser = g_user
        LET g_tc_dhy.tc_dhygrup = g_grup               #使用者所屬群
        LET g_tc_dhy.tc_dhydate = g_today
        LET g_tc_dhy.tc_dhyacti = 'Y'
        LET g_tc_dhy.tc_dhy02 = g_today
        LET g_tc_dhy.tc_dhy07 = g_today
        LET g_tc_dhy.tc_dhy09 = 'N'
        LET g_tc_dhy.tc_dhy12 = 'N'
        LET g_tc_dhy.tc_dhy13 = 'N'
        LET g_tc_dhy.tc_dhy14 = 'N'
        LET g_tc_dhy.tc_dhy15 = 'N'
        LET g_tc_dhy.tc_dhy16 = 'N'
        LET g_tc_dhy.tc_dhy20 = 'N'
        LET g_tc_dhy.tc_dhy21 = 'N'
        LET g_tc_dhy.tc_dhy24 = 'N'
        LET g_tc_dhy.tc_dhy25 = 'N'
        LET g_tc_dhy.tc_dhy26 = 'N'
        LET g_tc_dhy.tc_dhy27 = 'N'
        LET g_tc_dhy.tc_dhy29 = 'N'
        LET g_tc_dhy.tc_dhy30 = 'N'
        LET g_tc_dhy.tc_dhy31 = 'N'
        LET g_tc_dhy.tc_dhy32 = 'N'
        LET g_tc_dhy.tc_dhy33 = 'N'
        LET g_tc_dhy.tc_dhy38 = 'N'
        LET g_tc_dhy.tc_dhy40 = 'N'
        LET g_tc_dhy.tc_dhy41 = g_today
        CALL i001_i("a")
                               
        IF INT_FLAG THEN                         
            INITIALIZE g_tc_dhy.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        #str-----add by guanyao160712
        IF g_tc_dhy.tc_dhyud02 IS NULL THEN             
            CONTINUE WHILE
        END IF
        #end-----add by guanyao160712
        IF g_tc_dhy.tc_dhy05 IS NULL THEN             
            CONTINUE WHILE
        END IF
        INSERT INTO tc_dhy_file VALUES(g_tc_dhy.*)    
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_dhy_file",g_tc_dhy.tc_dhy05,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        ELSE
            SELECT tc_dhy05 INTO g_tc_dhy.tc_dhy05 FROM tc_dhy_file WHERE tc_dhy05 = g_tc_dhy.tc_dhy05
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i001_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
   DEFINE l_a           LIKE type_file.num5
   DEFINE l_b           LIKE type_file.chr10
   DEFINE l_tc_dhy03    LIKE tc_dhy_file.tc_dhy03
   DEFINE l_t1,l_t2     LIKE type_file.chr20
   DEFINE l_t3,l_tmp    LIKE type_file.chr10
   DEFINE l_tc_dhy05    LIKE tc_dhy_file.tc_dhy05
   DEFINE l_x           LIKE type_file.num5
   DEFINE lcbo_target ui.ComboBox 
   
 
    DISPLAY BY NAME
      g_tc_dhy.tc_dhy02,g_tc_dhy.tc_dhy07,
      g_tc_dhy.tc_dhy09,g_tc_dhy.tc_dhy12,g_tc_dhy.tc_dhy13,g_tc_dhy.tc_dhy14,g_tc_dhy.tc_dhy15,
      g_tc_dhy.tc_dhy16,g_tc_dhy.tc_dhy20,g_tc_dhy.tc_dhy21,g_tc_dhy.tc_dhy24,g_tc_dhy.tc_dhy25,
      g_tc_dhy.tc_dhy26,g_tc_dhy.tc_dhy27,g_tc_dhy.tc_dhy29,g_tc_dhy.tc_dhy30,g_tc_dhy.tc_dhy31,
      g_tc_dhy.tc_dhy32,g_tc_dhy.tc_dhy33,g_tc_dhy.tc_dhy38,g_tc_dhy.tc_dhy40,g_tc_dhy.tc_dhy41,
      g_tc_dhy.tc_dhyuser,g_tc_dhy.tc_dhygrup,
      g_tc_dhy.tc_dhymodu,g_tc_dhy.tc_dhydate,g_tc_dhy.tc_dhyacti
      ,g_tc_dhy.tc_dhyud02   #add by guanyao160712

 
   INPUT BY NAME
      g_tc_dhy.tc_dhy00,g_tc_dhy.tc_dhy01,g_tc_dhy.tc_dhy02,g_tc_dhy.tc_dhy03,g_tc_dhy.tc_dhy04,
      g_tc_dhy.tc_dhy05,g_tc_dhy.tc_dhy06,g_tc_dhy.tc_dhy07,g_tc_dhy.tc_dhy08,g_tc_dhy.tc_dhy09,
      g_tc_dhy.tc_dhy10,g_tc_dhy.tc_dhy11,g_tc_dhy.tc_dhy12,g_tc_dhy.tc_dhy13,g_tc_dhy.tc_dhy14,
      g_tc_dhy.tc_dhy15,g_tc_dhy.tc_dhy16,g_tc_dhy.tc_dhy17,g_tc_dhy.tc_dhy18,g_tc_dhy.tc_dhy19,
      g_tc_dhy.tc_dhy20,g_tc_dhy.tc_dhy21,g_tc_dhy.tc_dhy22,g_tc_dhy.tc_dhy23,g_tc_dhy.tc_dhy24,
      g_tc_dhy.tc_dhy241,g_tc_dhy.tc_dhy25,g_tc_dhy.tc_dhy26,g_tc_dhy.tc_dhy261,g_tc_dhy.tc_dhy27,
      g_tc_dhy.tc_dhy271,g_tc_dhy.tc_dhy28,g_tc_dhy.tc_dhy29,g_tc_dhy.tc_dhy291,g_tc_dhy.tc_dhy30,
      g_tc_dhy.tc_dhy301,g_tc_dhy.tc_dhy31,g_tc_dhy.tc_dhy311,g_tc_dhy.tc_dhy32,g_tc_dhy.tc_dhy321,
      g_tc_dhy.tc_dhy33,g_tc_dhy.tc_dhy331,g_tc_dhy.tc_dhy34,g_tc_dhy.tc_dhy35,g_tc_dhy.tc_dhy36,
      g_tc_dhy.tc_dhy37,g_tc_dhy.tc_dhy38,g_tc_dhy.tc_dhy39,
      g_tc_dhy.tc_dhyacti,g_tc_dhy.tc_dhyuser,g_tc_dhy.tc_dhygrup,g_tc_dhy.tc_dhymodu,g_tc_dhy.tc_dhydate,
      g_tc_dhy.tc_dhyud01,g_tc_dhy.tc_dhyud02,g_tc_dhy.tc_dhyud03,g_tc_dhy.tc_dhyud04,g_tc_dhy.tc_dhyud05,
      g_tc_dhy.tc_dhyud06,g_tc_dhy.tc_dhyud07,g_tc_dhy.tc_dhyud08,g_tc_dhy.tc_dhyud09,g_tc_dhy.tc_dhyud10,
      g_tc_dhy.tc_dhyud11,g_tc_dhy.tc_dhyud12,g_tc_dhy.tc_dhyud13,g_tc_dhy.tc_dhyud14,g_tc_dhy.tc_dhyud15
      WITHOUT DEFAULTS
   
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i001_set_entry(p_cmd)
          CALL i001_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

      AFTER FIELD tc_dhy00
         IF p_cmd = 'a' OR p_cmd  = 'u' THEN 
            IF cl_null(g_tc_dhy.tc_dhy00) THEN
               CALL cl_err('','cxm-003',0)
               NEXT FIELD tc_dhy00
            ELSE 
               #CASE g_tc_dhy.tc_dhy00
               #   WHEN '1'
               #      CALL cl_set_comp_entry('tc_dhy01',FALSE)
               #      CALL cl_set_comp_entry('tc_dhy03,tc_dhy04,tc_dhy05,tc_dhy06',TRUE)
               #      CALL cl_set_comp_required('tc_dhy03,tc_dhy04,tc_dhy05,tc_dhy06',TRUE)
               #   WHEN '2'
               #      CALL cl_set_comp_entry('tc_dhy01',TRUE)
               #      CALL cl_set_comp_entry('tc_dhy03,tc_dhy04,tc_dhy05,tc_dhy06',FALSE)
               #      CALL cl_set_comp_required('tc_dhy01',TRUE)
               #END CASE 
            END IF 
         END IF 

      #str----add by guanyao160712
      ON CHANGE tc_dhy00
         CASE g_tc_dhy.tc_dhy00
            WHEN '1'
               CALL cl_set_comp_entry('tc_dhy01',FALSE)
               CALL cl_set_comp_entry('tc_dhy03,tc_dhy04,tc_dhy06',TRUE)
               CALL cl_set_comp_required('tc_dhy03,tc_dhy04,tc_dhy05,tc_dhy06',TRUE)
               DISPLAY '' TO tc_dhy01
               DISPLAY '' TO tc_dhy03
               DISPLAY '' TO tc_dhy04
               DISPLAY '' TO tc_dhy05
               DISPLAY '' TO tc_dhy06 
               DISPLAY '' TO occ02
               LET lcbo_target = ui.ComboBox.forName("tc_dhy11")   
               CALL lcbo_target.removeItem('2')  			
            WHEN '2'
               CALL cl_set_comp_entry('tc_dhy01',TRUE)
               CALL cl_set_comp_entry('tc_dhy03,tc_dhy04,tc_dhy06',FALSE)
               CALL cl_set_comp_required('tc_dhy01',TRUE)
               DISPLAY '' TO tc_dhy03
               DISPLAY '' TO tc_dhy04
               DISPLAY '' TO tc_dhy05
               DISPLAY '' TO tc_dhy06 
               DISPLAY '' TO occ02    
               LET lcbo_target = ui.ComboBox.forName("tc_dhy11")
               CALL lcbo_target.AddItem("2",'2：重复样品')
         END CASE 
      #end----add by guanyao160712

      AFTER FIELD tc_dhy01 
         IF cl_null(g_tc_dhy.tc_dhy01) THEN
            CALL cl_err('','cxm-005',0)
            NEXT FIELD tc_dhy01
         ELSE 
            IF p_cmd = "a" OR (p_cmd = "u" AND g_tc_dhy.tc_dhy01 != g_tc_dhy.tc_dhy01) THEN
               SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01 = g_tc_dhy.tc_dhy01
               IF cl_null(l_n) OR l_n = 0 THEN 
                  CALL cl_err(g_tc_dhy.tc_dhy01,'cxm-004',0)
                  NEXT FIELD tc_dhy01
               END IF  
               SELECT tc_dhy03,tc_dhy04,tc_dhy06,tc_dhy07
                 INTO g_tc_dhy.tc_dhy03,g_tc_dhy.tc_dhy04,g_tc_dhy.tc_dhy06,g_tc_dhy.tc_dhy07
                 FROM tc_dhy_file 
                WHERE tc_dhy05 = g_tc_dhy.tc_dhy01
               DISPLAY BY NAME g_tc_dhy.tc_dhy03,g_tc_dhy.tc_dhy04,g_tc_dhy.tc_dhy06,g_tc_dhy.tc_dhy07
               SELECT MAX(ASCII(substr(ima01,9,1))) INTO l_tmp  FROM ima_file 
                WHERE substr(ima01,8)= substr(g_tc_dhy.tc_dhy01,8)
                  AND substr(ima01,1,6)=substr(g_tc_dhy.tc_dhy01,1,6)
                  AND substr(ima01,7,1)>substr(g_tc_dhy.tc_dhy01,7,1)
               SELECT substr(g_tc_dhy.tc_dhy01,1,8),substr(g_tc_dhy.tc_dhy01,10),ASCII(substr(g_tc_dhy.tc_dhy01,9,1))
                 INTO l_t1,l_t2,l_t3
                 FROM dual 
               IF cl_null(l_tmp) THEN 
                  LET l_tmp = l_t3+1
               ELSE 
                  LET l_tmp = l_tmp+1
               END IF 
               SELECT chr(l_tmp) INTO l_tmp FROM dual
               LET g_tc_dhy.tc_dhy05 =l_t1 CLIPPED,l_tmp CLIPPED,l_t2 CLIPPED 
               SELECT COUNT(*) INTO l_x FROM tc_dhy_file WHERE tc_dhy05 = g_tc_dhy.tc_dhy05
               IF l_x > 0 THEN 
                  SELECT MAX(ASCII(substr(tc_dhy05,9,1))) INTO l_tmp FROM ima_file 
                   WHERE substr(tc_dhy05,10)= substr(g_tc_dhy.tc_dhy01,10)
                     AND substr(tc_dhy05,1,8)=substr(g_tc_dhy.tc_dhy01,1,8)
                     AND substr(tc_dhy05,9,1)>substr(g_tc_dhy.tc_dhy01,9,1)
                  LET l_tmp = l_tmp+1  
                  SELECT chr(l_tmp) INTO l_tmp FROM dual
                  LET g_tc_dhy.tc_dhy05 =l_t1 CLIPPED,l_tmp CLIPPED,l_t2 CLIPPED 
               END IF 
               DISPLAY BY NAME g_tc_dhy.tc_dhy05
            END IF             
         END IF 
         
      AFTER FIELD tc_dhy05
         IF g_tc_dhy.tc_dhy05 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_tc_dhy.tc_dhy05 != g_tc_dhy05_t) THEN 
               SELECT count(*) INTO l_n FROM tc_dhy_file WHERE tc_dhy05 = g_tc_dhy.tc_dhy05
               IF l_n > 0 THEN                 
                  CALL cl_err(g_tc_dhy.tc_dhy05,-239,1)
                  LET g_tc_dhy.tc_dhy05 = g_tc_dhy05_t
                  DISPLAY BY NAME g_tc_dhy.tc_dhy05
                  NEXT FIELD tc_dhy05
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('tc_dhy05:',100,1)
                  LET g_tc_dhy.tc_dhy05 = g_tc_dhy05_t
                  DISPLAY BY NAME g_tc_dhy.tc_dhy05
                  NEXT FIELD tc_dhy05
               END IF
            END IF
         END IF

        AFTER FIELD tc_dhy03 
           IF g_tc_dhy.tc_dhy03 IS NOT NULL THEN
              IF p_cmd = "a" OR (p_cmd = "u" AND g_tc_dhy.tc_dhy01 != g_tc_dhy.tc_dhy01) THEN
                 SELECT COUNT(*) INTO l_a FROM occ_file WHERE occ01 =  g_tc_dhy.tc_dhy03 AND occ01 = substr(g_tc_dhy.tc_dhy03,1,2)
                 IF cl_null(l_a) OR l_a=0 THEN 
                    CALL cl_err('tc_dhy03:',100,1)
                    NEXT FIELD tc_dhy03
                 END IF
                 CALL ins_tc_dhy05()
                 #SELECT MAX(substr(tc_dhy05,3,4)) INTO l_b FROM tc_dhy_file 
                 # WHERE substr(tc_dhy05,1,2)=g_tc_dhy.tc_dhy03
                 #IF cl_null(l_b) THEN 
                 #   LET l_b = '0001'
                 #ELSE 
                 #   LET l_b = l_b+1 
                 #   LET l_b = l_b USING '&&&&'
                 #END IF 
                 #LET g_tc_dhy.tc_dhy05 = g_tc_dhy.tc_dhy03 CLIPPED,l_b,'A'
                 #DISPLAY BY NAME g_tc_dhy.tc_dhy05
              END IF               
           END IF 
           CALL i001_tc_dhy03('a')

      #str-----add by guanyao160712
      AFTER FIELD tc_dhy08 
         IF NOT cl_null(g_tc_dhy.tc_dhy08) THEN 
            IF p_cmd = "a" OR (p_cmd = "u" AND g_tc_dhy.tc_dhy08 != g_tc_dhy.tc_dhy08) THEN
               CALL ins_tc_dhy05()
            END IF 
         END IF 

      AFTER FIELD tc_dhyud10
         IF NOT cl_null(g_tc_dhy.tc_dhyud10) THEN 
            IF p_cmd = "a" OR (p_cmd = "u" AND g_tc_dhy.tc_dhyud10 != g_tc_dhy.tc_dhyud10) THEN
               CALL ins_tc_dhy05()
            END IF 
         END IF

      AFTER FIELD tc_dhyud03
         IF NOT cl_null(g_tc_dhy.tc_dhyud03) THEN 
            IF p_cmd = "a" OR (p_cmd = "u" AND g_tc_dhy.tc_dhyud03 != g_tc_dhy.tc_dhyud03) THEN
               CALL ins_tc_dhy05()
            END IF 
         END IF
      AFTER FIELD tc_dhy11
         IF NOT cl_null(g_tc_dhy.tc_dhy11) THEN 
            IF p_cmd = "a" OR (p_cmd = "u" AND g_tc_dhy.tc_dhy11!= g_tc_dhy.tc_dhy11) THEN
               IF g_tc_dhy.tc_dhy11 = '2' THEN 
                  LET g_tc_dhy.tc_dhy05 = g_tc_dhy.tc_dhy01
                  DISPLAY BY NAME g_tc_dhy.tc_dhy05
               ELSE 
                  CALL ins_tc_dhy05()
               END IF 
            END IF 
         END IF
      #end-----add by guanyao160712
 
      AFTER INPUT      
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_tc_dhy.tc_dhy05 IS NULL THEN
               DISPLAY BY NAME g_tc_dhy.tc_dhy05
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD tc_dhy05
            END IF
            
      ON ACTION CONTROLO                      
         IF INFIELD(tc_dhy05) THEN
            LET g_tc_dhy.* = g_tc_dhy_t.*
            CALL i001_show()
            NEXT FIELD tc_dhy05
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(tc_dhy01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima011"
              LET g_qryparam.default1 = g_tc_dhy.tc_dhy01
              CALL cl_create_qry() RETURNING g_tc_dhy.tc_dhy01
              DISPLAY BY NAME g_tc_dhy.tc_dhy01
              NEXT FIELD tc_dhy01

            WHEN INFIELD(tc_dhy03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_occ02"
              LET g_qryparam.default1 = g_tc_dhy.tc_dhy03
              CALL cl_create_qry() RETURNING g_tc_dhy.tc_dhy03
              DISPLAY BY NAME g_tc_dhy.tc_dhy03
              CALL i001_tc_dhy03('a')
              NEXT FIELD tc_dhy03
 
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
 
      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION

FUNCTION i001_tc_dhy03(p_cmd)

   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_occ02    LIKE occ_file.occ02
   DEFINE l_occacti  LIKE occ_file.occacti
 
   LET g_errno=''
   SELECT occ02,occacti INTO l_occ02,l_occacti FROM occ_file
    WHERE occ01=g_tc_dhy.tc_dhy03
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='cxm-070'
                                LET l_occ02=NULL
                                
       WHEN l_occacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_occ02 TO FORMONLY.occ02     
   END IF
END FUNCTION


FUNCTION i001_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tc_dhy.* TO NULL    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i001_curs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i001_count
    FETCH i001_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i001_cs                          
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_dhy.tc_dhy05,SQLCA.sqlcode,0)
        INITIALIZE g_tc_dhy.* TO NULL
    ELSE
        CALL i001_fetch('F')              
    END IF
END FUNCTION


 
FUNCTION i001_fetch(p_fltc_dhy)
    DEFINE p_fltc_dhy         LIKE type_file.chr1
 
    CASE p_fltc_dhy
        WHEN 'N' FETCH NEXT     i001_cs INTO g_tc_dhy.tc_dhy05
        WHEN 'P' FETCH PREVIOUS i001_cs INTO g_tc_dhy.tc_dhy05
        WHEN 'F' FETCH FIRST    i001_cs INTO g_tc_dhy.tc_dhy05
        WHEN 'L' FETCH LAST     i001_cs INTO g_tc_dhy.tc_dhy05
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about       
                     CALL cl_about()    
 
                  ON ACTION generate_link
                     CALL cl_generate_shortcut()
 
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
            FETCH ABSOLUTE g_jump i001_cs INTO g_tc_dhy.tc_dhy05
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_dhy.tc_dhy05,SQLCA.sqlcode,0)
        INITIALIZE g_tc_dhy.* TO NULL  
        LET g_tc_dhy.tc_dhy05 = NULL      
        RETURN
    ELSE
      CASE p_fltc_dhy
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_tc_dhy.* FROM tc_dhy_file    
       WHERE tc_dhy05 = g_tc_dhy.tc_dhy05
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","tc_dhy_file",g_tc_dhy.tc_dhy05,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_tc_dhy.tc_dhyuser          
        LET g_data_group=g_tc_dhy.tc_dhygrup
        CALL i001_show()                   
    END IF
END FUNCTION

FUNCTION i001_show()

    LET g_tc_dhy_t.* = g_tc_dhy.*
    DISPLAY BY NAME g_tc_dhy.tc_dhy00,g_tc_dhy.tc_dhy01,g_tc_dhy.tc_dhy02,g_tc_dhy.tc_dhy03,
        g_tc_dhy.tc_dhy04,g_tc_dhy.tc_dhy05,g_tc_dhy.tc_dhy06,g_tc_dhy.tc_dhy07,g_tc_dhy.tc_dhy08,
        g_tc_dhy.tc_dhy09,g_tc_dhy.tc_dhy10,g_tc_dhy.tc_dhy11,g_tc_dhy.tc_dhy12,g_tc_dhy.tc_dhy13,
        g_tc_dhy.tc_dhy14,g_tc_dhy.tc_dhy15,g_tc_dhy.tc_dhy16,g_tc_dhy.tc_dhy17,g_tc_dhy.tc_dhy18,
        g_tc_dhy.tc_dhy19,g_tc_dhy.tc_dhy20,g_tc_dhy.tc_dhy21,g_tc_dhy.tc_dhy22,g_tc_dhy.tc_dhy23,
        g_tc_dhy.tc_dhy24,g_tc_dhy.tc_dhy241,g_tc_dhy.tc_dhy25,g_tc_dhy.tc_dhy26,g_tc_dhy.tc_dhy261,
        g_tc_dhy.tc_dhy27,g_tc_dhy.tc_dhy271,g_tc_dhy.tc_dhy28,g_tc_dhy.tc_dhy29,g_tc_dhy.tc_dhy291,
        g_tc_dhy.tc_dhy30,g_tc_dhy.tc_dhy301,g_tc_dhy.tc_dhy31,g_tc_dhy.tc_dhy311,g_tc_dhy.tc_dhy32,
        g_tc_dhy.tc_dhy321,g_tc_dhy.tc_dhy33,g_tc_dhy.tc_dhy331,g_tc_dhy.tc_dhy34,g_tc_dhy.tc_dhy35,
        g_tc_dhy.tc_dhy36,g_tc_dhy.tc_dhy37,g_tc_dhy.tc_dhy38,g_tc_dhy.tc_dhy39,
        g_tc_dhy.tc_dhy40,g_tc_dhy.tc_dhy41, 
        g_tc_dhy.tc_dhyacti,g_tc_dhy.tc_dhyuser,g_tc_dhy.tc_dhygrup,g_tc_dhy.tc_dhymodu,g_tc_dhy.tc_dhydate,
        g_tc_dhy.tc_dhyud01,g_tc_dhy.tc_dhyud02,g_tc_dhy.tc_dhyud03,g_tc_dhy.tc_dhyud04,g_tc_dhy.tc_dhyud05,
        g_tc_dhy.tc_dhyud06,g_tc_dhy.tc_dhyud07,g_tc_dhy.tc_dhyud08,g_tc_dhy.tc_dhyud09,g_tc_dhy.tc_dhyud10,
        g_tc_dhy.tc_dhyud11,g_tc_dhy.tc_dhyud12,g_tc_dhy.tc_dhyud13,g_tc_dhy.tc_dhyud14,g_tc_dhy.tc_dhyud15
        
    CALL i001_tc_dhy03('d')
    CALL i001_show_pic()
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i001_u()
    IF g_tc_dhy.tc_dhy05 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_tc_dhy.* FROM tc_dhy_file WHERE tc_dhy05=g_tc_dhy.tc_dhy05
    IF g_tc_dhy.tc_dhy40= 'X' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    CALL cl_opmsg('u')
    LET g_tc_dhy05_t = g_tc_dhy.tc_dhy05
    BEGIN WORK
 
    #OPEN i001_cl USING g_tc_dhy.tc_dhy05    #mark by guanyao160712
    OPEN i001_cl USING g_tc_dhy.tc_dhyud02   #add by guanyao160712
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_tc_dhy.*               
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_dhy.tc_dhy05,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_tc_dhy.tc_dhyuser=g_user
    LET g_tc_dhy.tc_dhygrup=g_grup
    LET g_tc_dhy.tc_dhymodu=g_user                  
    LET g_tc_dhy.tc_dhydate = g_today               
    CALL i001_show() 
    
    WHILE TRUE
       CALL i001_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tc_dhy.*=g_tc_dhy_t.*
            CALL i001_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE tc_dhy_file SET tc_dhy_file.* = g_tc_dhy.*                  
            WHERE tc_dhy05 = g_tc_dhy_t.tc_dhy05    
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tc_dhy_file",g_tc_dhy.tc_dhy05,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_r()
    IF g_tc_dhy.tc_dhy05 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    #OPEN i001_cl USING g_tc_dhy.tc_dhy05    #mark by guanyao160712
    OPEN i001_cl USING g_tc_dhy.tc_dhyud02   #add by guanyao160712
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 0)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_tc_dhy.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_dhy.tc_dhy05,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i001_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "tc_dhy05"   
       LET g_doc.value1 = g_tc_dhy.tc_dhy05 
       CALL cl_del_doc()
       DELETE FROM tc_dhy_file WHERE tc_dhy05 = g_tc_dhy.tc_dhy05

       CLEAR FORM
       OPEN i001_count
      
       IF STATUS THEN
          CLOSE i001_cl
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
      
       FETCH i001_count INTO g_row_count
       
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i001_cl
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
      
       DISPLAY g_row_count TO FORMONLY.cnt

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

    DEFINE l_newno         LIKE tc_dhy_file.tc_dhy05
    DEFINE l_oldno         LIKE tc_dhy_file.tc_dhy05
    DEFINE p_cmd           LIKE type_file.chr1
    DEFINE l_input         LIKE type_file.chr1 
 
    IF g_tc_dhy.tc_dhy05 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i001_set_entry('a')
    LET g_before_input_done = TRUE

    INPUT l_newno FROM tc_dhy05
 
        AFTER FIELD tc_dhy05
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM tc_dhy_file WHERE tc_dhy05 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD tc_dhy05
              END IF
           END IF

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()  
 
       ON ACTION generate_link
          CALL cl_generate_shortcut()
 
       ON ACTION HELP      
          CALL cl_show_help() 
 
       ON ACTION controlg  
          CALL cl_cmdask() 
    END INPUT

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_tc_dhy.tc_dhy05
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM tc_dhy_file
        WHERE tc_dhy05=g_tc_dhy.tc_dhy05
        INTO TEMP x
    UPDATE x
        SET tc_dhy05=l_newno,    
            tc_dhyacti='Y',      
            tc_dhyuser=g_user,   
            tc_dhygrup=g_grup,   
            tc_dhymodu=NULL,     
            tc_dhydate=g_today   
    INSERT INTO tc_dhy_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tc_dhy_file",g_tc_dhy.tc_dhy05,"",SQLCA.sqlcode,"","",0)  
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_tc_dhy.tc_dhy05
        LET g_tc_dhy.tc_dhy05 = l_newno
        SELECT tc_dhy_file.* INTO g_tc_dhy.* FROM tc_dhy_file
               WHERE tc_dhy05 = l_newno
        CALL i001_u()                
    END IF
                          
    CALL i001_show()
END FUNCTION

FUNCTION i001_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
     # CALL cl_set_comp_entry("tc_dhy05",TRUE)
   END IF
   IF p_cmd = 'c' THEN 
      CALL cl_set_comp_entry("tc_dhy24,tc_dhy241,tc_dhy25,tc_dhy26,tc_dhy261",TRUE)
      CALL cl_set_comp_entry("tc_dhy27,tc_dhy271,tc_dhy28,tc_dhy29,tc_dhy291",TRUE)
      CALL cl_set_comp_entry("tc_dhy30,tc_dhy301,tc_dhy25,tc_dhy26,tc_dhy261,tc_dhy35",TRUE)
   END IF
   IF p_cmd = 's' THEN 
      CALL cl_set_comp_entry("tc_dhy31,tc_dhy311,tc_dhy32,tc_dhy321,tc_dhy33",TRUE)
      CALL cl_set_comp_entry("tc_dhy331,tc_dhy36",TRUE)
   END IF
   IF p_cmd='a' OR p_cmd = 'u'THEN 
      CALL cl_set_comp_entry("tc_dhy00,tc_dhy01,tc_dhy02,tc_dhy03,tc_dhy04",TRUE)
      CALL cl_set_comp_entry("tc_dhy06,tc_dhy07,tc_dhy08,tc_dhy09,tc_dhy10,tc_dhy11",TRUE)
      CALL cl_set_comp_entry("tc_dhy12,tc_dhy13,tc_dhy14,tc_dhy15,tc_dhy16,tc_dhy17",TRUE)
      CALL cl_set_comp_entry("tc_dhy18,tc_dhy19,tc_dhy20,tc_dhy21,tc_dhy22,tc_dhy23",TRUE)
      CALL cl_set_comp_entry("tc_dhy34,tc_dhy37,tc_dhy38,tc_dhy39",TRUE)
   END IF 
   
END FUNCTION

 
FUNCTION i001_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
     # CALL cl_set_comp_entry("tc_dhy05",FALSE)
   END IF
   IF p_cmd='u' THEN 
      CALL cl_set_comp_entry("tc_dhy00",FALSE)
   END IF 
   IF p_cmd = 'c' THEN  
      CALL cl_set_comp_entry("tc_dhy00,tc_dhy01,tc_dhy02,tc_dhy03,tc_dhy04,tc_dhy05",FALSE)
      CALL cl_set_comp_entry("tc_dhy06,tc_dhy07,tc_dhy08,tc_dhy09,tc_dhy10,tc_dhy11",FALSE)
      CALL cl_set_comp_entry("tc_dhy12,tc_dhy13,tc_dhy14,tc_dhy15,tc_dhy16,tc_dhy17",FALSE)
      CALL cl_set_comp_entry("tc_dhy18,tc_dhy19,tc_dhy20,tc_dhy21,tc_dhy22,tc_dhy23",FALSE)
      CALL cl_set_comp_entry("tc_dhy34,tc_dhy37,tc_dhy38,tc_dhy39",FALSE)
      CALL cl_set_comp_entry("tc_dhy31,tc_dhy311,tc_dhy32,tc_dhy321,tc_dhy33",FALSE)
      CALL cl_set_comp_entry("tc_dhy331,tc_dhy36",FALSE)
   END IF 
   IF p_cmd = 's' THEN 
      CALL cl_set_comp_entry("tc_dhy00,tc_dhy01,tc_dhy02,tc_dhy03,tc_dhy04,tc_dhy05",FALSE)
      CALL cl_set_comp_entry("tc_dhy06,tc_dhy07,tc_dhy08,tc_dhy09,tc_dhy10,tc_dhy11",FALSE)
      CALL cl_set_comp_entry("tc_dhy12,tc_dhy13,tc_dhy14,tc_dhy15,tc_dhy16,tc_dhy17",FALSE)
      CALL cl_set_comp_entry("tc_dhy18,tc_dhy19,tc_dhy20,tc_dhy21,tc_dhy22,tc_dhy23",FALSE)
      CALL cl_set_comp_entry("tc_dhy34,tc_dhy37,tc_dhy38,tc_dhy39",FALSE) 
      CALL cl_set_comp_entry("tc_dhy24,tc_dhy241,tc_dhy25,tc_dhy26,tc_dhy261",FALSE)
      CALL cl_set_comp_entry("tc_dhy27,tc_dhy271,tc_dhy28,tc_dhy29,tc_dhy291",FALSE)
      CALL cl_set_comp_entry("tc_dhy30,tc_dhy301,tc_dhy25,tc_dhy26,tc_dhy261,tc_dhy35",FALSE)
   END IF 
   IF p_cmd = 'u' OR p_cmd = 'a' THEN
      CALL cl_set_comp_entry("tc_dhy24,tc_dhy241,tc_dhy25,tc_dhy26,tc_dhy261",FALSE)
      CALL cl_set_comp_entry("tc_dhy27,tc_dhy271,tc_dhy28,tc_dhy29,tc_dhy291",FALSE)
      CALL cl_set_comp_entry("tc_dhy30,tc_dhy301,tc_dhy25,tc_dhy26,tc_dhy261,tc_dhy35",FALSE) 
      CALL cl_set_comp_entry("tc_dhy31,tc_dhy311,tc_dhy32,tc_dhy321,tc_dhy33",FALSE)
      CALL cl_set_comp_entry("tc_dhy331,tc_dhy36",FALSE)
   END IF 
END FUNCTION

FUNCTION i001_u1(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1

    IF g_tc_dhy.tc_dhy05 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_tc_dhy.* FROM tc_dhy_file WHERE tc_dhy05=g_tc_dhy.tc_dhy05
    IF g_tc_dhy.tc_dhy40= 'X' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    CALL cl_opmsg('u')
    LET g_tc_dhy05_t = g_tc_dhy.tc_dhy05
    BEGIN WORK
 
    #OPEN i001_cl USING g_tc_dhy.tc_dhy05    #mark by guanyao160712
    OPEN i001_cl USING g_tc_dhy.tc_dhyud02   #add by guanyao160712
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_tc_dhy.*               
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_dhy.tc_dhy05,SQLCA.sqlcode,1)
        RETURN
    END IF             
    CALL i001_show() 
    
    WHILE TRUE
       CALL i001_i(p_cmd)                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tc_dhy.*=g_tc_dhy_t.*
            CALL i001_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE tc_dhy_file SET tc_dhy_file.* = g_tc_dhy.*                  
            WHERE tc_dhy05 = g_tc_dhy_t.tc_dhy05    
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tc_dhy_file",g_tc_dhy.tc_dhy05,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION 

FUNCTION i001_unconfirm()
   DEFINE l_occ01 LIKE occ_file.occ01
   DEFINE l_cnt   LIKE type_file.num5   #FUN-A50078  
   DEFINE l_imaacti  LIKE ima_file.imaacti   #add by guanyao160614 
   DEFINE l_x      LIKE type_file.num5   #add by guanyao160614
    
   IF (g_tc_dhy.tc_dhy05 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_tc_dhy.tc_dhy40='X' THEN
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   #非審核狀態 不能取消審核
   IF g_tc_dhy.tc_dhy40!='Y' THEN #FUN-690021-mod
      CALL  cl_err('','atm-053',1)
      RETURN
   END IF 
   #str-----add by guanyao160614
   LET l_imaacti =''
   SELECT imaacti INTO l_imaacti FROM ima_file WHERE ima01 = g_tc_dhy.tc_dhy05
   IF l_imaacti = 'Y' THEN 
      CALL cl_err('','cxm-009',0)
      RETURN 
   END IF 
   #end-----add by guanyao160614
 
   IF NOT cl_confirm('aim-302') THEN RETURN END IF    #lyl
   LET g_success = 'Y'  #FUN-9A0056 add
   BEGIN WORK
 
   #OPEN i001_cl USING g_tc_dhy.tc_dhy05    #mark by guanyao160712
   OPEN i001_cl USING g_tc_dhy.tc_dhyud02   #add by guanyao160712
   IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i001_cl INTO g_tc_dhy.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      CLOSE i001_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
   CALL i001_show()
   UPDATE tc_dhy_file
      SET tc_dhy40='N',
          tc_dhy41=g_today
    WHERE tc_dhy05 = g_tc_dhy.tc_dhy05
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","tc_dhy_file",g_tc_dhy.tc_dhy05,"",SQLCA.sqlcode,"","",1)  
      LET g_success = 'N'   
   END IF
  CLOSE i001_cl
  #str----add by guanyao160614
  IF g_success = 'Y' THEN
     LET l_x = 0
     SELECT COUNT(*) INTO l_x  FROM ima_file WHERE ima01 = g_tc_dhy.tc_dhy05
     IF l_x > 0 THEN 
        CALL i001_ima_r()
     END IF 
  END IF 
  #end----add by guanyao160614
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   ELSE
     COMMIT WORK
   END IF

  SELECT * INTO g_tc_dhy.* FROM tc_dhy_file where tc_dhy05=g_tc_dhy.tc_dhy05 #FUN-690021--add
  CALL i001_show()
END FUNCTION 

FUNCTION i001_confirm()
   DEFINE l_n          LIKE type_file.num5   
   DEFINE l_x          LIKE type_file.num5   #add by guanyao160614 
   IF (g_tc_dhy.tc_dhy05 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_tc_dhy.* FROM tc_dhy_file WHERE tc_dhy05 =g_tc_dhy.tc_dhy05
   IF g_tc_dhy.tc_dhyacti='N' THEN
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_tc_dhy.tc_dhy40 = 'Y' THEN  #資料已確認
      CALL cl_err('','9023',1)
      RETURN
   END IF
   IF g_tc_dhy.tc_dhy40 !='N' THEN
      #不在開立狀態，不能申請確認
      CALL cl_err('','atm-221',1)
      RETURN
   END IF
   #str-----add by guanyao160614
   LET l_x = 0
   SELECT COUNT(*) INTO l_x FROM ima_file WHERE ima01 = g_tc_dhy.tc_dhy05
   IF l_x > 0 THEN 
      CALL cl_err('','cxm-008',0)
      RETURN 
   END IF
   #end-----add by guanyao160614
   IF NOT cl_confirm('aim-301') THEN RETURN END IF       

   LET g_success = 'Y'                                #FUN-9A0056  add

   BEGIN WORK
 
   #OPEN i001_cl USING g_tc_dhy.tc_dhy05    #mark by guanyao160712
   OPEN i001_cl USING g_tc_dhy.tc_dhyud02   #add by guanyao160712
   IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i001_cl INTO g_tc_dhy.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      CLOSE i001_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
   CALL i001_show()
   IF g_success = 'Y' THEN  #add by guanyao160614
      #LET g_tc_dhy.tc_dhy40 = 'Y'  #mark by guanyao160614
      UPDATE tc_dhy_file
         SET tc_dhy40='Y',
             tc_dhy41=g_today
       WHERE tc_dhy05 = g_tc_dhy.tc_dhy05
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tc_dhy_file",g_tc_dhy.tc_dhy05,"",SQLCA.sqlcode,"","",1)  
         LET g_success = 'N'                                                 
      END IF
   END IF    #add by guanyao160614

  CLOSE i001_cl
  #str------add by guanyao160614
  IF g_success = 'Y' THEN 
     CALL i001_ins_ima(g_tc_dhy.tc_dhy05) 
  END IF 
  #end------add by guanyao160614
  IF g_success = 'N' THEN
     ROLLBACK WORK
     RETURN
   ELSE
     COMMIT WORK
   END IF

  SELECT * INTO g_tc_dhy.* FROM tc_dhy_file where tc_dhy05=g_tc_dhy.tc_dhy05 
  CALL i001_show()
END FUNCTION 


FUNCTION i001_out()
 DEFINE l_i             LIKE type_file.num5,         
        l_name          LIKE type_file.chr20,
        l_prog        LIKE zz_file.zz01,
        l_prtway      LIKE type_file.chr1
 DEFINE l_wc           LIKE type_file.chr1000        
 DEFINE l_cmd          LIKE type_file.chr1000              #No.FUN-7C0043                                                                    
   IF cl_null(g_tc_dhy.tc_dhy05) THEN
      CALL cl_err('','-400',1)  #MOD-640492 0->1
      RETURN
   END IF
   LET l_prog='cxmr010' 

   IF NOT cl_null(l_prog) THEN #BugNo:5548
      LET l_wc='tc_dhy05="',g_tc_dhy.tc_dhy05,'"'
      LET l_cmd = l_prog CLIPPED,
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'N' '",l_prtway,"' '1'",
                  " '",l_wc CLIPPED,"' 'N' 'N' '0' 'N'"
      CALL cl_cmdrun(l_cmd)
   END IF
 
 
END FUNCTION

FUNCTION i001_x(p_type) 
   DEFINE l_cnt     LIKE type_file.num5   #CHI-6A0054
   DEFINE l_chr     LIKE type_file.chr1   #TQC-C50221
   DEFINE p_type    LIKE type_file.num5     #FUN-D20025
   DEFINE l_flag    LIKE type_file.chr1     #FUN-D20025
   
   IF g_tc_dhy.tc_dhy05 IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   SELECT * INTO g_tc_dhy.* FROM tc_dhy_file WHERE tc_dhy05=g_tc_dhy.tc_dhy05
   IF g_tc_dhy.tc_dhy40 = 'Y' THEN 
      CALL cl_err('',9023,0) 
      RETURN 
   END IF

   LET g_success = 'Y'

   IF p_type = 1 THEN 
      IF g_tc_dhy.tc_dhy40='X' THEN 
         RETURN 
      END IF
   ELSE
      IF g_tc_dhy.tc_dhy40<>'X' THEN 
         RETURN 
      END IF
   END IF
   
   BEGIN WORK
   #OPEN i001_cl USING g_tc_dhy.tc_dhy05    #mod by liuxqa 091020  #mark by guanyao160712
   OPEN i001_cl USING g_tc_dhy.tc_dhyud02   #add by guanyao160712
   IF STATUS THEN
      CALL cl_err("OPEN i001_cl:", STATUS, 1)
      CLOSE i001_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i001_cl INTO g_tc_dhy.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_dhy.tc_dhy05,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE i001_cl ROLLBACK WORK RETURN
    END IF
    IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #FUN-D20025
    IF cl_void(0,0,l_flag) THEN         #FUN-D20025
       LET l_chr = g_tc_dhy.tc_dhy40
       IF p_type = 1 THEN           
          LET g_tc_dhy.tc_dhy40 = 'X'
       ELSE
          LET g_tc_dhy.tc_dhy40 = 'N'
        END IF
    ELSE
       ROLLBACK WORK
       RETURN
    END IF

    UPDATE tc_dhy_file
       SET tc_dhy40 = g_tc_dhy.tc_dhy40,
           tc_dhymodu = g_user,
           tc_dhydate = g_today,
           tc_dhy41   = g_today
     WHERE tc_dhy05 =g_tc_dhy.tc_dhy05
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","tc_dhy_file",g_tc_dhy.tc_dhy05,"",SQLCA.sqlcode,"","upd oeaconf:",1)  #No.FUN-650108
       LET g_tc_dhy.tc_dhy40 = l_chr
       LET g_success = 'N'
    END IF
    CLOSE i001_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_flow_notify(g_tc_dhy.tc_dhy05,'V')
    ELSE
       ROLLBACK WORK
    END IF

    SELECT * INTO g_tc_dhy.* FROM tc_dhy_file WHERE tc_dhy05=g_tc_dhy.tc_dhy05
    CALL i001_show()
END FUNCTION 

FUNCTION i001_show_pic()

     LET g_chr='N'
     LET g_chr1='N'
     LET g_chr2='N'
     LET g_void ='N'
     IF g_tc_dhy.tc_dhy40='Y' THEN
         LET g_chr='Y'
     END IF
     IF g_tc_dhy.tc_dhy40='N' THEN
         LET g_void= 'N'
     END IF
     IF g_tc_dhy.tc_dhy40='X' THEN
        LET g_void= 'Y'
        LET g_chr = 'X'
     END IF 
     CALL cl_set_field_pic1(g_chr,""  ,""  ,""  ,g_void,"",""    ,g_chr2)
                           #確認 ,核准,過帳,結案,作廢,有效         ,申請  ,留置
END FUNCTION

#str----add by guanyao160614
FUNCTION i001_ins_ima(p_tc_dhy05)
DEFINE p_tc_dhy05        LIKE tc_dhy_file.tc_dhy05
DEFINE l_ima             RECORD LIKE ima_file.*
DEFINE l_x               LIKE type_file.num5
    LET l_x = 0 
    SELECT COUNT(*) INTO l_x FROM ima_file WHERE ima01 = p_tc_dhy05
    IF l_x > 0 THEN 
       CALL cl_err('','cxm-008',0)
       LET g_success = 'N'
       RETURN 
    END IF 
    LET l_ima.ima01 = p_tc_dhy05
    LET l_ima.ima07 = 'A'
    LET l_ima.ima08 = 'P'
    LET l_ima.ima108 = 'N'
    LET l_ima.ima14 = 'N'
    LET l_ima.ima903= 'N' #NO:6872
    LET l_ima.ima905= 'N'
    LET l_ima.ima15 = 'N'
    LET l_ima.ima16 = 99
    LET l_ima.ima18 = 0
    LET l_ima.ima022 = 0  #FUN-A20037
    LET l_ima.ima09 =' '
    LET l_ima.ima10 =' '
    LET l_ima.ima11 =' '
    LET l_ima.ima12 =''  
    LET l_ima.ima23 = ' '
    LET l_ima.ima918= 'N'
    LET l_ima.ima919= 'N'
    LET l_ima.ima921= 'N'
    LET l_ima.ima922= 'N'
    LET l_ima.ima924= 'N'
    LET l_ima.ima925= '1'   #MOD-C30088
    LET l_ima.ima24 = 'N'
    LET l_ima.ima911= 'N'   #FUN-610080
    LET l_ima.ima27 = 0
    LET l_ima.ima271 = 0
    LET l_ima.ima28 = 0
    LET l_ima.ima30 = g_today #No:7643 新增 aimi100料號時應default ima30=料件建立日期,以便循環盤點機制
    LET l_ima.ima31_fac = 1
    LET l_ima.ima32 = 0
    LET l_ima.ima33 = 0
    LET l_ima.ima37 = '0'
    LET l_ima.ima38 = 0
    LET l_ima.ima40 = 0
    LET l_ima.ima41 = 0
    LET l_ima.ima42 = '0'
    LET l_ima.ima44_fac = 1
    LET l_ima.ima45 = 0
    LET l_ima.ima46 = 0
    LET l_ima.ima47 = 0
    LET l_ima.ima48 = 0
    LET l_ima.ima49 = 0
    LET l_ima.ima491 = 0
    LET l_ima.ima50 = 0
    LET l_ima.ima51 = 1
    LET l_ima.ima52 = 1
    LET l_ima.ima140 = 'N'
    LET l_ima.ima53 = 0
    LET l_ima.ima531 = 0
    LET l_ima.ima55_fac = 1
    LET l_ima.ima56 = 1
    LET l_ima.ima561 = 1  #最少生產數量
    LET l_ima.ima562 = 0  #生產時損耗率
    LET l_ima.ima57 = 0
    LET l_ima.ima58 = 0
    LET l_ima.ima59 = 0
    LET l_ima.ima60 = 0
    LET l_ima.ima61 = 0
    LET l_ima.ima62 = 0
    LET l_ima.ima63_fac = 1
    LET l_ima.ima64 = 1
    LET l_ima.ima641 = 1   #最少發料數量
    LET l_ima.ima65 = 0
    LET l_ima.ima66 = 0
    LET l_ima.ima68 = 0
    LET l_ima.ima69 = 0
    LET l_ima.ima70 = 'N'
    LET l_ima.ima107= 'N'
    LET l_ima.ima147= 'N' #BugNo:6542 add ima147
    LET l_ima.ima71 = 0
    LET l_ima.ima72 = 0
    LET l_ima.ima721 = 0  #CHI-C50068
    LET l_ima.ima75 = ''
    LET l_ima.ima76 = ''
    LET l_ima.ima77 = 0
    LET l_ima.ima78 = 0
    LET l_ima.ima80 = 0
    LET l_ima.ima81 = 0
    LET l_ima.ima82 = 0
    LET l_ima.ima83 = 0
    LET l_ima.ima84 = 0
    LET l_ima.ima85 = 0
    LET l_ima.ima852= 'N'
    LET l_ima.ima853= 'N'
    LET l_ima.ima871 = 0
    LET l_ima.ima86_fac = 1
    LET l_ima.ima873 = 0
    LET l_ima.ima88 = 1
    LET l_ima.ima91 = 0
    LET l_ima.ima92 = 'N'
    LET l_ima.ima93 = "NNNNNNNN"
    LET l_ima.ima94 = ''
    LET l_ima.ima95 = 0
    LET l_ima.ima96 = 0
    LET l_ima.ima97 = 0
    LET l_ima.ima98 = 0
    LET l_ima.ima99 = 0
    LET l_ima.ima100 = 'N'
    LET l_ima.ima101 = '1'
    LET l_ima.ima102 = '1'
    LET l_ima.ima103 = '0'
    LET l_ima.ima104 = 0
    LET l_ima.ima910 = ' '  #FUN-550014
    LET l_ima.ima105 = 'N'
    LET l_ima.ima110 = '1'
    LET l_ima.ima139 = 'N'
    LET l_ima.imaacti= 'P' #P:Processing #FUN-690060
    LET l_ima.imauser= g_user
    LET l_ima.imaoriu = g_user #FUN-980030
    LET l_ima.imaorig = g_grup #FUN-980030
    LET l_ima.imagrup= g_grup                #使用者所屬群
    LET l_ima.imadate= g_today
    LET l_ima.ima901 = g_today               #料件建檔日期
    LET l_ima.ima912 = 0   #FUN-610080
    LET l_ima.ima912 = 'N' #TQC-AB0041
    #產品資料
    LET l_ima.ima130 = '1'
    LET l_ima.ima121 = 0
    LET l_ima.ima122 = 0
    LET l_ima.ima123 = 0
    LET l_ima.ima124 = 0
    LET l_ima.ima125 = 0
    LET l_ima.ima126 = 0
    LET l_ima.ima127 = 0
    LET l_ima.ima128 = 0
    LET l_ima.ima129 = 0
    LET l_ima.ima141 = '0'
    LET l_ima.ima1010 = '0' #0:開立        #FUN-690060
    #單位控制部分
 
    IF g_sma.sma115 = 'Y' THEN
       IF g_sma.sma122 MATCHES '[13]' THEN
          LET l_ima.ima906 = '2'
       ELSE
          LET l_ima.ima906 = '3'
       END IF
    ELSE
       LET l_ima.ima906 = '1'
    END IF
    LET l_ima.ima909 = 0
    LET l_ima.ima1001 = ''
    LET l_ima.ima1002 = ''
    LET l_ima.ima1014 = '1'
    LET l_ima.ima159 = '3'    #FUN-B90035
    LET l_ima.ima916 = ' '
    LET l_ima.ima150 = ' '
    LET l_ima.ima151 = ' '
    LET l_ima.ima152 = ' '
    LET l_ima.ima918='N'
    LET l_ima.ima919='N'
    LET l_ima.ima921='N'
    LET l_ima.ima922='N'
    LET l_ima.ima924='N'
    LET l_ima.ima925='1'
    LET l_ima.ima916=g_plant  #No.FUN-7C0010
    LET l_ima.ima917=0        #No.FUN-7C0010
    LET l_ima.ima156='N'      #FUN-A80150 add
    LET l_ima.ima157=' '      #FUN-A80150 add
    LET l_ima.ima158='N'      #FUN-A80150 add
    LET l_ima.ima159= '3'     #MOD-C30088
    LET l_ima.ima930 = 'N'    #DEV-D30026 add  #使用條碼否
    LET l_ima.ima931 = 'N'    #DEV-D30026 add
    LET l_ima.ima934 = 'Y'
    LET l_ima.ima151='N'                       # No.FUN-810016
    LET l_ima.ima928='N'


    LET l_ima.ima06 = 'G01'
    SELECT imz01,imz03 ,imz04,
           imz07,imz08,imz09,imz10,
           imz11,imz12,imz14,imz15,
           imz17,imz19,imz21,
           imz23,imz24,imz25,imz27,
           imz28,imz31,imz31_fac,imz34,
           imz35,imz36,imz37,imz38,
           imz39,imz42,imz43,imz44,
           imz44_fac,imz45,imz46 ,imz47,
           imz48,imz49,imz491,imz50,
           imz51,imz52,imz54,imz55,
           imz55_fac,imz56,imz561,imz562,
           imz571,
           imz59 ,imz60,imz61,imz62,
           imz63,imz63_fac ,imz64,imz641,
           imz65,imz66,imz67,imz68,
           imz69,imz70,imz71,imz86,
           imz86_fac ,imz87,imz871,imz872,
           imz873,imz874,imz88,imz89,
           imz90,imz94,imz99,imz100 ,
           imz101,imz102 ,imz103,imz105,
           imz106,imz107,imz108,imz109,
           imz110,imz130,imz131,imz132,
           imz133,imz134,
           imz147,imz148,imz903,
           imz906,imz907,imz908,imz909,
           imz911,
           imz918,imz919,imz920,imz921,imz922,imz923,imz924,imz925,   
           imz136,imz137,imz391,imz1321,
           imz72,imz153,imz601,  
           imz926,        
           imz156,imz157,imz158,               
           imz022,imz251,imz159,                
           imz163,imz1631                       
           
      INTO l_ima.ima06,l_ima.ima03,l_ima.ima04,
           l_ima.ima07,l_ima.ima08,l_ima.ima09,l_ima.ima10,
           l_ima.ima11,l_ima.ima12,l_ima.ima14,l_ima.ima15,
           l_ima.ima17,l_ima.ima19,l_ima.ima21,
           l_ima.ima23,l_ima.ima24,l_ima.ima25,l_ima.ima27, #No:7703 add ima24
           l_ima.ima28,l_ima.ima31,l_ima.ima31_fac,l_ima.ima34,
           l_ima.ima35,l_ima.ima36,l_ima.ima37,l_ima.ima38,
           l_ima.ima39,l_ima.ima42,l_ima.ima43,l_ima.ima44,
           l_ima.ima44_fac,l_ima.ima45,l_ima.ima46,l_ima.ima47,
           l_ima.ima48,l_ima.ima49,l_ima.ima491,l_ima.ima50,
           l_ima.ima51,l_ima.ima52,l_ima.ima54,l_ima.ima55,
           l_ima.ima55_fac,l_ima.ima56,l_ima.ima561,l_ima.ima562,
           l_ima.ima571,
           l_ima.ima59, l_ima.ima60,l_ima.ima61,l_ima.ima62,
           l_ima.ima63, l_ima.ima63_fac,l_ima.ima64,l_ima.ima641,
           l_ima.ima65, l_ima.ima66,l_ima.ima67,l_ima.ima68,
           l_ima.ima69, l_ima.ima70,l_ima.ima71,l_ima.ima86,
           l_ima.ima86_fac, l_ima.ima87,l_ima.ima871,l_ima.ima872,
           l_ima.ima873, l_ima.ima874,l_ima.ima88,l_ima.ima89,
           l_ima.ima90,l_ima.ima94,l_ima.ima99,l_ima.ima100,     
           l_ima.ima101,l_ima.ima102,l_ima.ima103,l_ima.ima105,  
           l_ima.ima106,l_ima.ima107,l_ima.ima108,l_ima.ima109,  
           l_ima.ima110,l_ima.ima130,l_ima.ima131,l_ima.ima132,  
           l_ima.ima133,l_ima.ima134,                            
           l_ima.ima147,l_ima.ima148,l_ima.ima903,
           l_ima.ima906,l_ima.ima907,l_ima.ima908,l_ima.ima909,  
           l_ima.ima911,                                         
           l_ima.ima918,l_ima.ima919,l_ima.ima920,               
           l_ima.ima921,l_ima.ima922,l_ima.ima923,               
           l_ima.ima924,l_ima.ima925,                           
           l_ima.ima136,l_ima.ima137,l_ima.ima391,l_ima.ima1321, 
           l_ima.ima915,l_ima.ima153,l_ima.ima601,               
           l_ima.ima926,                                         
           l_ima.ima156,l_ima.ima157,l_ima.ima158,               
           l_ima.ima022,l_ima.ima251,l_ima.ima159,               
           l_ima.ima163,l_ima.ima1631                            
           FROM  imz_file
           WHERE imz01 = l_ima.ima06

    IF cl_null(l_ima.ima159) THEN
       LET l_ima.ima159 = '3'
    END IF    
    IF ( l_ima.ima37='0' OR l_ima.ima37 ='5' ) AND ( l_ima.ima08 NOT MATCHES '[MSPVZ]')  THEN 
       LET l_ima.ima37='2'
    END IF 

    #检查
    IF l_ima.ima31 IS NULL THEN
       LET l_ima.ima31=l_ima.ima25
       LET l_ima.ima31_fac=1
    END IF
 
    IF l_ima.ima133 IS NULL THEN
       LET l_ima.ima133 = l_ima.ima01
    END IF
 
    IF l_ima.ima571 IS NULL THEN
       LET l_ima.ima571 = l_ima.ima01
    END IF
 
    IF l_ima.ima44 IS NULL OR l_ima.ima44=' ' THEN
       LET l_ima.ima44=l_ima.ima25   #採購單位
       LET l_ima.ima44_fac=1
    END IF
 
    IF l_ima.ima55 IS NULL OR l_ima.ima55=' ' THEN
       LET l_ima.ima55=l_ima.ima25   #生產單位
       LET l_ima.ima55_fac=1
    END IF
 
    IF l_ima.ima63 IS NULL OR l_ima.ima63=' ' THEN
       LET l_ima.ima63=l_ima.ima25   #發料單位
       LET l_ima.ima63_fac=1
    END IF
 
    LET l_ima.ima86=l_ima.ima25   #庫存單位=成本單位
    LET l_ima.ima86_fac=1
 
    IF l_ima.ima35 IS NULL THEN
       LET l_ima.ima35=' ' #No:7726
    END IF
 
    IF l_ima.ima36 IS NULL THEN
       LET l_ima.ima36=' ' #No:7726
    END IF
 
    IF l_ima.ima910 IS NULL THEN
       LET l_ima.ima910=' ' #FUN-550014
    END IF
    IF l_ima.ima131 IS NULL THEN LET l_ima.ima131 = ' ' END IF #No.FUN-880032
   
 
    LET l_ima.ima913 = "N"   #No.MOD-640061

    IF l_ima.ima926 IS NULL THEN
       LET l_ima.ima926='N'
    END IF
    LET l_ima.ima01  = l_ima.ima01 CLIPPED      #No.FUN-870150
    IF cl_null(l_ima.ima601) THEN 
       LET l_ima.ima601 = '1'    #No:FUN-860111 
    END IF
    LET l_ima.ima154 = 'N'      #FUN-870100 ADD                                                                                     
    LET l_ima.ima155 = 'N'      #FUN-870100 ADD 
    IF l_ima.ima01[1,4]='MISC' THEN
       LET l_ima.ima130='2'
    END IF
    LET l_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
    LET l_ima.ima927 = 'N'          #No.FUN-A90049 add 
#FUN-A20037 --begin--
    IF cl_null(l_ima.ima022) THEN
      LET l_ima.ima022 = 0 
    END IF 
#FUN-A20037 --end--
    IF cl_null(l_ima.ima156) THEN LET l_ima.ima156 ='N' END IF  #FUN-A80102
    IF cl_null(l_ima.ima157) THEN LET l_ima.ima157 =' ' END IF  #FUN-A80102
    IF cl_null(l_ima.ima158) THEN LET l_ima.ima158 ='N' END IF  #FUN-A80102
    LET l_ima.ima927='N'   #No:FUN-AA0014
    LET l_ima.ima120='1'   #No:TQC-AA0117
    IF cl_null(l_ima.ima912) THEN LET l_ima.ima912 = 0 END IF   #TQC-B20161
    IF cl_null(l_ima.ima159) THEN LET l_ima.ima159 = '3' END IF #FUN-B90035
    #TQC-C20278--add--begin
    IF cl_null(l_ima.ima918) THEN LET l_ima.ima918 = 'N' END IF
    IF cl_null(l_ima.ima919) THEN LET l_ima.ima919 = 'N' END IF
    IF cl_null(l_ima.ima921) THEN LET l_ima.ima921 = 'N' END IF
    IF cl_null(l_ima.ima922) THEN LET l_ima.ima922 = 'N' END IF
    IF cl_null(l_ima.ima924) THEN LET l_ima.ima924 = 'N' END IF
    #TQC-C20278--add--end
    IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
    INSERT INTO ima_file VALUES(l_ima.*)       # DISK WRITE
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","ima_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
       LET g_success = 'N'
       RETURN 
    END IF 
END FUNCTION 

FUNCTION i001_ima_r()
    DEFINE l_chr    LIKE type_file.chr1    
    DEFINE l_azo06  LIKE azo_file.azo06
    DEFINE l_azo04  LIKE azo_file.azo04
    DEFINE l_n      LIKE type_file.num5   
    DEFINE l_ima    RECORD LIKE ima_file.* 
    DEFINE l_forupd_sql    STRING 
 
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO l_ima.* FROM ima_file WHERE ima01=g_tc_dhy.tc_dhy05
    IF l_ima.ima01 IS NULL THEN
        LET g_success = 'N'
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF NOT s_dc_ud_flag('1',l_ima.ima916,g_plant,'r') THEN
       LET g_success = 'N'
       CALL cl_err(l_ima.ima916,'aoo-044',1)
       RETURN
    END IF
   
    IF l_ima.imaacti = 'N' THEN
       LET g_success = 'N'
       CALL cl_err(l_ima.ima01,'aim-153',1)
       RETURN
    END IF
    IF l_ima.imaacti = 'Y' THEN
       #此筆資料已確認
       LET g_success = 'N'
       CALL cl_err(l_ima.ima01,'9023',1)
       RETURN
    END IF

    LET l_forupd_sql = " SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE "
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)

    DECLARE i100_cl CURSOR FROM l_forupd_sql
    OPEN i100_cl USING l_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err(l_ima.ima01,SQLCA.sqlcode,0)
       LET g_success = 'N'
       RETURN
    END IF
    FETCH i100_cl INTO l_ima.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(l_ima.ima01,SQLCA.sqlcode,0)
       LET g_success = 'N'
       RETURN
    END IF
    CALL s_chkitmdel(l_ima.ima01) RETURNING g_errno
    IF NOT cl_null(g_errno) THEN
       CALL cl_err('',g_errno,0)
       LET g_success = 'N'
       RETURN
    END IF
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ima01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = l_ima.ima01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        #No.FUN-550103 Start,如果當前料件是子料件則要刪除其在imx_file中對應的紀錄
        IF l_ima.imaag = '@CHILD' THEN
           DELETE FROM imx_file WHERE imx000 = l_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imx_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              LET g_success = 'N'
              RETURN
           END IF
        END IF
 
        IF (NOT cl_del_itemname("ima_file","ima02", l_ima.ima01)) THEN   #CHI-6B0034
           LET g_success = 'N'
           RETURN              #TQC-710103
        END IF
        IF (NOT cl_del_itemname("ima_file","ima021",l_ima.ima01)) THEN   #CHI-6B0034
           LET g_success = 'N'
           RETURN              #TQC-710103
        END IF
 
        DELETE FROM ima_file WHERE ima01 = l_ima.ima01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","ima_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
           LET g_success = 'N'
           RETURN         #NO.FUN-680010
        ELSE
           CALL cl_del_pic("ima01",l_ima.ima01,"ima04")  #TQC-660041
            DELETE  FROM vmk_file where vmk01 = l_ima.ima01
            UPDATE ima_file SET imadate=g_today WHERE ima01 = l_ima.ima01
 
           DELETE FROM imc_file WHERE imc01 = l_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imc_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              LET g_success = 'N'
              RETURN
           END IF
           DELETE FROM ind_file WHERE ind01 = l_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","ind_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              LET g_success = 'N'
              RETURN
           END IF
           DELETE FROM imb_file WHERE imb01 = l_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imb_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              LET g_success = 'N'
              RETURN
           END IF
           DELETE FROM smd_file WHERE smd01 = l_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","smd_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)
              LET g_success = 'N'
              RETURN
           END IF
          DELETE FROM imt_file WHERE imt01 = l_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imt_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)
              LET g_success = 'N'
              RETURN
           END IF
           DELETE FROM vmi_file WHERE vmi01 = l_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","vmi_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)
              LET g_success = 'N'
              RETURN
           END IF
           #MOD-C80145 -- add start --
           DELETE FROM rta_file WHERE rta01 = l_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","rta_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)
              LET g_success = 'N'
              RETURN
           END IF
           #MOD-C80145 -- add end --
           UPDATE ima_file SET imadate=g_today WHERE ima01 = l_ima.ima01

#TQC-B90236-------add------begin  删除imac_file资料
           DELETE FROM imac_file WHERE imac01 = l_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imac_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)
              LET g_success = 'N'
              RETURN
           END IF
#TQC-B90236-------add------end
          
           #增加記錄料號
           #LET l_azo06='R: ',l_ima.ima01 CLIPPED   #CHI-BC0005 mark
           LET l_azo06='delete'                     #CHI-BC0005 add
           LET l_azo04 = TIME

           INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #No.FUN-980004
             VALUES ('aimi100',g_user,g_today,l_azo04,l_ima.ima01,l_azo06,g_plant,g_legal)   #MOD-940394 #No.FUN-980004  #mod by liuxqa 091020
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","aimi100","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              LET g_success = 'N'
              RETURN
           END IF

        END IF
       CLOSE i100_cl  
       RETURN
END FUNCTION 
#end----add by guanyao160614
#str----add by guanyao160712
FUNCTION ins_tc_dhy05()
DEFINE l_x          LIKE type_file.num5
DEFINE l_b          LIKE type_file.chr10
DEFINE l_tc_dhyud10 LIKE type_file.chr10

    IF cl_null(g_tc_dhy.tc_dhy03) OR 
       cl_null(g_tc_dhy.tc_dhy08) OR 
       cl_null(g_tc_dhy.tc_dhyud10) OR 
       cl_null(g_tc_dhy.tc_dhyud03) THEN
       RETURN  
    END IF 

    #LET l_x = 0
    #SELECT length(g_tc_dhy.tc_dhy03) INTO l_x FROM dual 
    #IF cl_null(l_x) THEN 
    #   RETURN 
    #END IF 
    SELECT MAX(substr(tc_dhy05,3,4)) INTO l_b FROM tc_dhy_file 
     WHERE substr(tc_dhy05,1,2)=g_tc_dhy.tc_dhy03
    IF cl_null(l_b) THEN 
       LET l_b = '0001'
    ELSE 
       LET l_b = l_b+1 
       LET l_b = l_b USING '&&&&'
    END IF 
    LET l_tc_dhyud10 = g_tc_dhy.tc_dhyud10
    LET g_tc_dhy.tc_dhy05 = g_tc_dhy.tc_dhy03 CLIPPED,l_b,g_tc_dhy.tc_dhy08 CLIPPED,l_tc_dhyud10 CLIPPED,'A',
                            g_tc_dhy.tc_dhyud03 CLIPPED 
    DISPLAY BY NAME g_tc_dhy.tc_dhy05
    
END FUNCTION 
#end----add by guanyao160712