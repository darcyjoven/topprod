# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmt430.4gl
# Descriptions...: 预测采购需求维护作业
# Date & Author..: No.FUN-9A0065 09/12/08 By destiny 
# Modify.........: No.FUN-A10034 10/01/07 By destiny 整批复制时不能把采购序号也复制
# Modify.........: No.FUN-A90009 10/09/13 By destiny B2B修改
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管                   
# Modify.........: No.TQC-B20184 11/02/28 By huangrh  修改整批複製窗口沒關閉的BUG
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正

DATABASE ds
#No.FUN-9A0065
GLOBALS "../../config/top.global"
DEFINE   g_wpb                 RECORD LIKE wpb_file.*
DEFINE   g_wpb_t               RECORD LIKE wpb_file.*
DEFINE   g_w                   RECORD 
                               wpb01 LIKE wpb_file.wpb01,
                               wpb02 LIKE wpb_file.wpb02,
                               wpb03 LIKE wpb_file.wpb03,
                               wpb05 LIKE wpb_file.wpb05
                               END RECORD
DEFINE   g_ima                 DYNAMIC ARRAY OF RECORD 
                               e       LIKE type_file.chr1,
                               wpc10   LIKE wpc_file.wpc10,
                               wpb01   LIKE wpb_file.wpb01,
                               ima02   LIKE ima_file.ima02,
                               ima021  LIKE ima_file.ima021,
                               wpb02   LIKE wpb_file.wpb02, 
                               ima44   LIKE ima_file.ima44,
                               wpb03   LIKE wpb_file.wpb03
                               END RECORD 
DEFINE   g_wpb01_t             LIKE wpb_file.wpb01
DEFINE   g_wpb02_t             LIKE wpb_file.wpb02
DEFINE   g_sql                 STRING
DEFINE   g_wc                  STRING
DEFINE   g_rec_b               LIKE type_file.num10
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_forupd_sql          STRING
DEFINE   g_msg                 LIKE ze_file.ze03
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_curs_index          LIKE type_file.num10
DEFINE   g_row_count           LIKE type_file.num10
DEFINE   g_jump                LIKE type_file.num10
DEFINE   g_no_ask              LIKE type_file.num5
DEFINE   g_edate               LIKE wpb_file.wpb02
DEFINE   g_pdate               LIKE wpb_file.wpb02
DEFINE   g_max_rec             LIKE type_file.num5
DEFINE   g_channel             base.Channel
DEFINE   g_tmpstr              STRING

MAIN
   DEFINE   lwin_curr   ui.Window

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   IF (NOT cl_user()) THEN 
      EXIT PROGRAM 
   END IF 
   WHENEVER ERROR CALL cl_err_msg_log

   IF NOT cl_setup('apm') THEN
      EXIT PROGRAM 
   END IF
   
 # CALL cl_used('apmt430',g_time,1) RETURNING g_time 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

   INITIALIZE g_wpb.* TO NULL
   INITIALIZE g_wpb_t.* TO NULL

   LET g_forupd_sql = "SELECT wpb01,wpb02,wpb03,wpb04,wpb05 FROM wpb_file ",
                      "  WHERE wpb01 =? AND wpb02 =? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)                   
   DECLARE t430_cl CURSOR FROM g_forupd_sql
   
   OPEN WINDOW t430_w WITH FORM "apm/42f/apmt430"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_init()
   LET g_action_choice = ""
   #No.FUN-A90009--begin
   IF g_aza.aza95='N' THEN 
      CALL cl_err('','apm-317',1)
      EXIT PROGRAM 
   END IF 
   #No.FUN-A90009--end 
   CALL t430_menu()

   CLOSE WINDOW t430_w
 # CALL cl_used('apmt430',g_time,2) RETURNING g_time 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN

FUNCTION t430_menu()
   DEFINE   li_restart   LIKE type_file.num5

   MENU 
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      ON ACTION INSERT
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN 
            CALL t430_a()
         END IF 
         
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN 
            CALL t430_q()
         END IF 
         
      ON ACTION DELETE 
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN 
            CALL t430_r()
         END IF    
         
      ON ACTION modify
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
             CALL t430_u()
          END IF

      ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
                CALL t430_copy()
           END IF
                                 
      ON ACTION first
         CALL t430_fetch('F')

      ON ACTION previous
         CALL t430_fetch('P')

      ON ACTION next 
         CALL t430_fetch('N') 
 
      ON ACTION jump
         CALL t430_fetch('/')
            
      ON ACTION last
         CALL t430_fetch('L')

         
      ON ACTION all_copy
         CALL t430_allcopy()

      ON ACTION all_report
         CALL t430_b()
         CALL t430_show()
         
      ON ACTION need
         CALL t430_need()
         
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

      ON ACTION close 
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT MENU       
                      
      ON ACTION exit
          EXIT MENU
          
#     COMMAND KEY(INTERRUPT)
#        LET INT_FLAG=FALSE
#        EXIT MENU
   END MENU
#   CLOSE t430_cs

END FUNCTION

FUNCTION t430_curs()
DEFINE l_sql    STRING

   CLEAR FORM
   INITIALIZE  g_wpb.* TO NULL 
   
      CONSTRUCT BY NAME g_wc ON wpb01,wpb02,wpb03,wpb04,wpb05,ima44
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(wpb01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_wpb01"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO wpb01
                 NEXT FIELD wpb01  
                  
            WHEN INFIELD(ima44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe01"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima44
                 NEXT FIELD ima44   
                                                 
         END CASE   
         
      ON ACTION controlg
         CALL cl_cmdask()
         
      ON ACTION about
         CALL cl_about()
         
      ON ACTION HELP
         CALL cl_show_help()
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
          
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
		     CALL cl_qbe_save()
		                     
      END CONSTRUCT
      
   IF INT_FLAG THEN
      RETURN
   END IF
   IF cl_null(g_wc) THEN
      LET g_wc=" 1=1 " 
   END IF 

   IF g_wc.getIndexOf("ima44",1) THEN
      LET l_sql="SELECT DISTINCT wpb01,wpb02 ",
                " FROM wpb_file LEFT OUTER JOIN ima_file ON ima01 = wpb01",
                " WHERE ",g_wc CLIPPED, " ORDER BY wpb01,wpb02"
   ELSE
      LET l_sql="SELECT wpb01,wpb02 FROM wpb_file ",
                " WHERE ",g_wc CLIPPED, " ORDER BY wpb01"
   END IF

   PREPARE t430_p FROM l_sql           
   DECLARE t430_cs                  
       SCROLL CURSOR WITH HOLD FOR t430_p

   IF g_wc.getIndexOf("ima44",1) THEN
      LET l_sql= "SELECT COUNT(*) ",
                 " FROM wpb_file LEFT OUTER JOIN ima_file ON ima01 = wpb01",
                 " WHERE ",g_wc CLIPPED
   ELSE
      LET l_sql= "SELECT COUNT(*) FROM wpb_file WHERE ",g_wc CLIPPED
   END IF

   PREPARE t430_precount FROM l_sql
   DECLARE t430_count CURSOR FOR t430_precount

END FUNCTION

FUNCTION t430_q()

   LET g_row_count = 0
   LET g_wpb.wpb01=""
   LET g_wpb.wpb02=""
   CALL cl_navigator_setting(g_curs_index, g_row_count)

   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt

   CALL t430_curs()                         

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF

   OPEN t430_count
   FETCH t430_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt

   OPEN t430_cs                           
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wpb.wpb01,SQLCA.sqlcode,0)
      INITIALIZE g_wpb.* TO NULL
   ELSE
      CALL t430_fetch('F')                 
   END IF

END FUNCTION

FUNCTION t430_fetch(p_flwpb)
   DEFINE   p_flwpb   LIKE type_file.chr1,
            l_abso    LIKE type_file.num10

   CASE p_flwpb
      WHEN 'N' FETCH NEXT     t430_cs INTO g_wpb.wpb01,g_wpb.wpb02
      WHEN 'P' FETCH PREVIOUS t430_cs INTO g_wpb.wpb01,g_wpb.wpb02
      WHEN 'F' FETCH FIRST    t430_cs INTO g_wpb.wpb01,g_wpb.wpb02
      WHEN 'L' FETCH LAST     t430_cs INTO g_wpb.wpb01,g_wpb.wpb02
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
            FETCH ABSOLUTE g_jump t430_cs INTO g_wpb.wpb01,g_wpb.wpb02
            LET g_no_ask = FALSE    
   END CASE 

   IF SQLCA.sqlcode THEN
      INITIALIZE g_wpb.* TO NULL
      CALL cl_err(g_wpb.wpb01,SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_flwpb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF

   SELECT wpb01,wpb02,wpb03,wpb04,wpb05 INTO g_wpb.*
     FROM wpb_file WHERE wpb01 = g_wpb.wpb01 
      AND wpb02 = g_wpb.wpb02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","wpb_file",g_wpb.wpb01,"",SQLCA.sqlcode,"","",0)
   ELSE
      CALL t430_show()                      
   END IF

END FUNCTION

FUNCTION t430_show()
DEFINE   l_ima02    LIKE ima_file.ima02
DEFINE   l_ima021   LIKE ima_file.ima021
DEFINE   l_ima44    LIKE ima_file.ima44
    
    SELECT * INTO g_wpb.* FROM wpb_file WHERE wpb01=g_wpb.wpb01 AND wpb02=g_wpb.wpb02
    LET g_wpb_t.* = g_wpb.*
    DISPLAY BY NAME g_wpb.wpb01,g_wpb.wpb02,g_wpb.wpb03,g_wpb.wpb04,g_wpb.wpb05
    
    SELECT ima02,ima021,ima44 INTO l_ima02,l_ima021,l_ima44 FROM ima_file
     WHERE ima01=g_wpb.wpb01
    DISPLAY l_ima02,l_ima021,l_ima44 TO ima02,ima021,ima44   

END FUNCTION

FUNCTION t430_a()
   MESSAGE ""
   CLEAR FORM                                   
   INITIALIZE g_wpb.* LIKE wpb_file.*
   LET g_wpb_t.*=g_wpb.*
   LET g_wc=NULL 
   LET g_wpb01_t=NULL
   LET g_wpb02_t=NULL 
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_wpb.wpb04="N"
      LET g_wpb.wpb03=0
      CALL t430_i("a")                      

      IF INT_FLAG THEN   
         INITIALIZE g_wpb.* TO NULL                      
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF

      IF g_wpb.wpb01 IS NULL THEN      
         CONTINUE WHILE
      END IF
      BEGIN WORK 
      INSERT INTO wpb_file (wpb01,wpb02,wpb03,wpb04,wpb05)
           VALUES (g_wpb.wpb01,g_wpb.wpb02,g_wpb.wpb03,g_wpb.wpb04,
                   g_wpb.wpb05)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","wpb_file",g_wpb.wpb01,"",SQLCA.sqlcode,"","",0)
         CONTINUE WHILE
         ROLLBACK WORK 
      ELSE 
      	 COMMIT WORK 
      END IF

      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION t430_i(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          l_n        LIKE type_file.num5
          
   DISPLAY BY NAME g_wpb.wpb03,g_wpb.wpb04 
   INPUT BY NAME g_wpb.wpb01,g_wpb.wpb02,g_wpb.wpb03 WITHOUT DEFAULTS
          BEFORE INPUT 
            CALL cl_set_comp_entry('wpb01,wpb02,wpb03',true)
            IF p_cmd='u' THEN 
               CALL cl_set_comp_entry('wpb01,wpb02',FALSE)
            ELSE 
               CALL cl_set_comp_entry('wpb01,wpb02',TRUE)
            END IF 
          AFTER FIELD wpb01
            IF NOT cl_null(g_wpb.wpb01) THEN 
               IF p_cmd='a' OR (p_cmd='u' AND g_wpb.wpb01 !=g_wpb_t.wpb01) THEN 
                  CALL t430_check(g_wpb.wpb01,g_wpb.wpb02) 
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,1)
                     LET g_wpb.wpb01=g_wpb_t.wpb01
                     NEXT FIELD wpb01
                  END IF 
                  CALL t430_wpb01(g_wpb.wpb01,'a') 
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,1)
                     LET g_wpb.wpb01=g_wpb_t.wpb01
                     NEXT FIELD wpb01
                  END IF     
               END IF               
            END IF 
            
          AFTER FIELD wpb02
            IF NOT cl_null(g_wpb.wpb02) THEN 
               IF p_cmd='a' OR (p_cmd='u' AND g_wpb.wpb02 !=g_wpb_t.wpb02) THEN 
                  CALL t430_check(g_wpb.wpb01,g_wpb.wpb02) 
                  IF NOT cl_null(g_errno) THEN 
                  	 CALL cl_err('',g_errno,1)
                  	 LET g_wpb.wpb02=g_wpb_t.wpb02
                     NEXT FIELD wpb02                      
                  ELSE 
                     IF g_wpb.wpb02<g_today THEN 
                        CALL cl_err('','apm-610',1)
                        LET g_wpb.wpb02=g_wpb_t.wpb02
                        NEXT FIELD wpb02
                     END IF    
                  END IF 
               END IF 
            END IF      
                 
          AFTER FIELD wpb03
            IF NOT cl_null(g_wpb.wpb03) THEN 
               IF g_wpb.wpb03<0 THEN 
                  CALL cl_err("","aim-223",1)
                  LET g_wpb.wpb03=g_wpb_t.wpb03
                  NEXT FIELD wpb03
               END IF 
            END IF 
            
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF           
                     
          ON ACTION controlp
             CASE           
                WHEN INFIELD(wpb01)
#FUN-AA0059---------mod------------str-----------------                
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_ima1"
#                   LET g_qryparam.arg1=g_plant
#                   LET g_qryparam.default1 = g_wpb.wpb01
#                   CALL cl_create_qry() RETURNING g_wpb.wpb01
                   CALL q_sel_ima(FALSE, "q_ima1","",g_wpb.wpb01,g_plant,"","","","",'')  RETURNING  g_wpb.wpb01
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY BY NAME g_wpb.wpb01
                   NEXT FIELD wpb01    
             END CASE     
             
          ON ACTION controlg 
             CALL cl_cmdask()
             
          ON ACTION HELP 
             CALL cl_show_help()
             
          ON ACTION about
             CALL cl_about()

          ON ACTION CONTROLF                        # 欄位說明
             CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
             CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
                      
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT    
             
   END INPUT

END FUNCTION

FUNCTION t430_check(p_wpb01,p_wpb02)
DEFINE   l_a     LIKE type_file.num5
DEFINE   p_wpb01    LIKE wpb_file.wpb01 
DEFINE   p_wpb02    LIKE wpb_file.wpb02
    LET g_errno=""
    LET l_a=0
    IF NOT cl_null(g_wpb.wpb01) AND NOT cl_null(g_wpb.wpb02) THEN 
       SELECT COUNT(*) INTO l_a FROM wpb_file 
        WHERE wpb01=p_wpb01
          AND wpb02=p_wpb02
       IF l_a>0 THEN
          LET g_errno="apm-622"
          RETURN 
       END IF 
    END IF 
    
END FUNCTION

FUNCTION t430_wpb01(p_wpb01,p_cmd)
DEFINE   p_cmd      LIKE type_file.chr1
DEFINE   p_wpb01    LIKE wpb_file.wpb01
DEFINE   l_ima02    LIKE ima_file.ima02
DEFINE   l_ima021   LIKE ima_file.ima021
DEFINE   l_ima44    LIKE ima_file.ima44
DEFINE   l_imaacti  LIKE ima_file.imaacti
DEFINE   l_ima927   LIKE ima_file.ima927

    LET g_errno = " "    
    SELECT ima02,ima021,ima44,imaacti,ima927 INTO l_ima02,l_ima021,l_ima44,l_imaacti,l_ima927
      FROM ima_file WHERE ima01=p_wpb01
    CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
       WHEN l_imaacti !='Y'     LET g_errno='9028'
       WHEN l_ima927 ='N'       LET g_errno='apm-318'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    IF cl_null(g_errno) OR p_cmd ='d' THEN 
       DISPLAY l_ima02,l_ima021,l_ima44 TO ima02,ima021,ima44
    END IF    
END FUNCTION

FUNCTION t430_u()

    IF g_wpb.wpb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_wpb.wpb04='Y' THEN 
       CALL cl_err('','apm-624',1)
       RETURN
    END IF
    LET g_wpb01_t = g_wpb.wpb01
    LET g_wpb02_t = g_wpb.wpb02 
    LET g_wpb_t.* = g_wpb.*
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN t430_cl USING g_wpb01_t,g_wpb02_t
    IF STATUS THEN
       CALL cl_err("OPEN t430_cl:", STATUS, 0)
       CLOSE t430_cl
       ROLLBACK WORK
       RETURN
    END IF          
    FETCH t430_cl INTO g_wpb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_wpb.wpb01,SQLCA.sqlcode,0)
       RETURN
    END IF
        
    CALL t430_show()                        
    WHILE TRUE
        CALL t430_i("u")                    
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_wpb.*=g_wpb_t.*
            CALL t430_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE wpb_file SET wpb_file.* = g_wpb.*    
            WHERE wpb01 = g_wpb01_t
              AND wpb02 = g_wpb02_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","wpb_file",g_wpb.wpb01,g_wpb.wpb02,SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t430_cl
    COMMIT WORK
END FUNCTION 

FUNCTION t430_copy()
    DEFINE
        l_newno1        LIKE wpb_file.wpb01,
        l_oldno1        LIKE wpb_file.wpb01,
        l_newno2        LIKE wpb_file.wpb02,
        l_oldno2        LIKE wpb_file.wpb02,
        l_wpb03         LIKE wpb_file.wpb03,
        p_cmd           LIKE type_file.chr1,          
        l_input         LIKE type_file.chr1,          
        l_cnt           LIKE type_file.num5
DEFINE  li_result       LIKE type_file.num5        
        
    IF g_wpb.wpb01 IS NULL or g_wpb.wpb02 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
       
    LET l_input='N'
    #LET INT_FLAG=1
    CALL cl_set_comp_entry('wpb01,wpb02,wpb03',TRUE)
    CALL cl_set_comp_entry('wpb03',FALSE)  

    INPUT l_newno1,l_newno2 FROM wpb01,wpb02
          BEFORE INPUT 
            DISPLAY '','','','','' TO ima02,ima021,ima44,wpb04,wpb05 
            LET l_oldno1=g_wpb.wpb01
            LET l_oldno2=g_wpb.wpb02
            
          AFTER FIELD wpb01
            IF NOT cl_null(l_newno1) THEN 
               CALL t430_check(l_newno1,l_newno2) 
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,1)
                  LET l_newno1=l_oldno1
                  NEXT FIELD wpb01
               END IF 
               CALL t430_wpb01(l_newno1,'a') 
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,1)
                  LET l_newno1=l_oldno1
                  NEXT FIELD wpb01
               END IF                  
            END IF 
            
          AFTER FIELD wpb02
            IF NOT cl_null(l_newno2) THEN 
                CALL t430_check(l_newno1,l_newno2) 
                IF NOT cl_null(g_errno) THEN 
                	 CALL cl_err('',g_errno,1)
                   LET l_newno2=l_oldno2
                   NEXT FIELD wpb02                      
                ELSE 
                   IF l_newno2<g_today THEN 
                      CALL cl_err('','apm-610',1)
                      LET l_newno2=l_oldno2
                      NEXT FIELD wpb02
                   END IF    
                END IF 
            END IF      
          ON ACTION controlp
             CASE           
                WHEN INFIELD(wpb01)
#FUN-AA0059---------mod------------str-----------------                
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_ima1"
#                   LET g_qryparam.arg1=g_plant
#                   LET g_qryparam.default1 = l_newno1
#                   CALL cl_create_qry() RETURNING l_newno1
                   CALL q_sel_ima(FALSE, "q_ima1","",l_newno1,g_plant,"","","","",'') RETURNING l_newno1
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY BY NAME l_newno1
                   NEXT FIELD wpb01    
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
        CALL t430_show()
        RETURN
    END IF 
    BEGIN WORK 
    SELECT wpb03 INTO l_wpb03 FROM wpb_file 
     WHERE wpb01=l_oldno1 AND wpb02=l_oldno2          
    INSERT INTO wpb_file(wpb01,wpb02,wpb03,wpb04,wpb05) 
    VALUES(l_newno1,l_newno2,l_wpb03,'N','')

    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","wpb_file",g_wpb.wpb01,"",SQLCA.sqlcode,"","",0) #No.FUN-B80088---上移一行調整至回滾事務前--- 
        ROLLBACK WORK
    ELSE
        COMMIT WORK
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1=g_wpb.wpb01
        LET l_oldno2=g_wpb.wpb02
        LET g_wpb.wpb01 = l_newno1
        LET g_wpb.wpb02 = l_newno2
        SELECT wpb_file.* INTO g_wpb.* FROM wpb_file
               WHERE wpb01 = l_newno1
                 AND wpb02 = l_newno2
#        CALL t430_u('c')
    END IF
    CALL t430_show()
END FUNCTION 

FUNCTION t430_r()
 
    IF g_wpb.wpb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_wpb.wpb04='Y' THEN 
       CALL cl_err('','apm-624',1)
       RETURN
    END IF
    LET g_wpb01_t = g_wpb.wpb01
    LET g_wpb02_t = g_wpb.wpb02
    BEGIN WORK
 
    OPEN t430_cl USING g_wpb01_t,g_wpb02_t
    IF STATUS THEN
       CALL cl_err("OPEN t430_cl:", STATUS, 0)
       CLOSE t430_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t430_cl INTO g_wpb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_wpb.wpb01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t430_show()
    IF cl_delete() THEN
       DELETE FROM wpb_file WHERE wpb01 = g_wpb01_t AND wpb02=g_wpb02_t
       CLEAR FORM
       OPEN t430_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t430_cs
          CLOSE t430_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t430_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t430_cs
          CLOSE t430_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t430_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t430_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL t430_fetch('/')
       END IF
    END IF
    CLOSE t430_cl
    COMMIT WORK
END FUNCTION

FUNCTION t430_allcopy()
DEFINE   l_wpb     RECORD LIKE wpb_file.*
DEFINE   l_n       LIKE type_file.num5
DEFINE   l_cnt     LIKE type_file.num5     
     
     CLOSE WINDOW t430_w2
     OPEN WINDOW t430_w2 WITH FORM "apm/42f/apmt4301" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED)   
     CALL cl_ui_locale('apmt4301')
     
    INPUT g_edate,g_pdate FROM FORMONLY.edate,FORMONLY.pdate
        AFTER FIELD edate 
          IF NOT cl_null(g_edate) THEN 
             IF NOT cl_null(g_pdate) THEN 
                IF g_pdate=g_edate THEN 
                   CALL cl_err('','apm-609',1)
                   NEXT FIELD pdate 
                END IF 
             END IF 
          END IF 
        AFTER FIELD pdate
          IF NOT cl_null(g_pdate) THEN 
             IF g_pdate <g_today THEN 
                CALL cl_err('','apm-610',1)
                NEXT FIELD pdate 
             END IF 
             IF NOT cl_null(g_edate) THEN
                IF g_pdate=g_edate THEN 
                   CALL cl_err('','apm-609',1)
                   NEXT FIELD pdate 
                END IF 
             END IF  
          END IF 
        AFTER INPUT
          IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET g_edate=NULL 
              LET g_pdate=NULL
              EXIT INPUT
          END IF
       ON ACTION CLOSE
         IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET g_edate=NULL 
              LET g_pdate=NULL
              EXIT INPUT
          END IF       
          #LET g_edate=NULL 
          #LET g_pdate=NULL
          #EXIT INPUT 

          
       ON ACTION cancel 
          IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET g_edate=NULL 
              LET g_pdate=NULL
              EXIT INPUT
          END IF       
          #LET g_edate=NULL 
          #LET g_pdate=NULL
          #EXIT INPUT 
              
    END INPUT 
    IF cl_null(g_edate) AND cl_null(g_pdate) THEN
       CLOSE WINDOW t430_w2        #TQC-B20184
       RETURN 
    END IF 
    IF NOT cl_null(g_edate) AND NOT cl_null(g_pdate) THEN  
       IF NOT cl_confirm('apm-604') THEN     
          LET g_edate=NULL 
          LET g_pdate=NULL
          CLOSE WINDOW t430_w2     #TQC-B20184
          RETURN 
#          CLOSE WINDOW t430_w2
       END IF  
    ELSE 
    	 RETURN 
    END IF 
    IF NOT cl_null(g_edate) THEN 
       SELECT COUNT(*) INTO l_n FROM wpb_file WHERE wpb02=g_edate
       IF l_n=0 THEN 
           CALL cl_err('','apm-605',1)
           CLOSE WINDOW t430_w2    #TQC-B20184
           RETURN 
#           CLOSE WINDOW t430_w2
       END IF  
    END IF 
    BEGIN WORK 
    CALL s_showmsg_init()
    LET g_success='N'
    LET g_sql=" SELECT wpb01,wpb02,wpb03,wpb04,wpb05 FROM wpb_file ",
              " WHERE wpb02='",g_edate,"' "
    PREPARE t430_pl FROM g_sql
    DECLARE t430_c2 CURSOR FOR t430_pl
    LET l_cnt=0
    FOREACH t430_c2 INTO l_wpb.*
       LET l_wpb.wpb04='N'     #No.FUN-A10034
       LET l_wpb.wpb05=null    #No.FUN-A10034
       INSERT INTO wpb_file VALUES(l_wpb.wpb01,g_pdate,l_wpb.wpb03,l_wpb.wpb04,l_wpb.wpb05)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
          CALL s_errmsg('wpb01',l_wpb.wpb01,'',SQLCA.sqlcode,1)
          LET g_success='N'
          CONTINUE FOREACH 
       ELSE
       	  LET g_success='Y' 
       	  LET l_cnt=l_cnt+1
       END IF  
    END FOREACH  
    CALL s_showmsg()
    IF g_success='N' THEN 
       ROLLBACK WORK 
    ELSE
    	 COMMIT WORK 
    	 IF l_cnt>0 THEN 
    	    CALL cl_err(l_cnt,'apm-606',1)
    	 END IF 
    END IF 
    CLOSE WINDOW t430_w2
      
END FUNCTION

FUNCTION t430_b()
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE l_i       LIKE type_file.num5
DEFINE l_ac      LIKE type_file.num5  
DEFINE l_a       LIKE type_file.num5 
DEFINE l_t       LIKE type_file.num5 
DEFINE l_t1      LIKE type_file.num5 
DEFINE l_chr     LIKE type_file.chr4
DEFINE l_date    LIKE type_file.chr10
DEFINE l_wpc01   LIKE wpc_file.wpc01
DEFINE l_wpbc03  LIKE wpbc_file.wpbc03
DEFINE l_sql     STRING 
DEFINE l_success LIKE type_file.chr1

       CLOSE WINDOW t430_w3
       OPEN WINDOW t430_w3 WITH FORM "apm/42f/apmt4302"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_ui_locale('apmt4302')
     
       LET l_sql= " SELECT 'Y','',wpb01,ima02,ima021,wpb02,ima44,wpb03 ", 
                  "   FROM wpb_file LEFT OUTER JOIN ima_file ON ima01=wpb01 ",
                  "  WHERE wpb04='N' ",
                  " ORDER BY wpb01 "
       PREPARE t430_preparel FROM l_sql
       DECLARE t430_bc CURSOR FOR t430_preparel

       CALL g_ima.clear()   
       LET l_cnt=1
       FOREACH t430_bc INTO g_ima[l_cnt].* 
          LET g_ima[l_cnt].wpc10=(g_today+g_ima[l_cnt].wpb02)/2
          LET l_cnt=l_cnt+1
       END FOREACH 
       CALL g_ima.deleteElement(l_cnt) 
       LET g_rec_b=l_cnt-1   
       
       INPUT ARRAY g_ima FROM s_ima.*
          ATTRIBUTE(COUNT=g_ima.getLength(),MAXCOUNT=g_rec_b,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,
                    APPEND ROW=FALSE,WITHOUT DEFAULTS=TRUE,UNBUFFERED)
          BEFORE ROW 
            LET l_ac = ARR_CURR()
            CALL cl_set_comp_entry('wpc10',FALSE) #No.FUN-A90009
         #ON ACTION accept 
            #SELECT count(*) INTO l_t1 FROM wpb_file WHERE wpb04='N'   
            #IF l_t1=0 THEN 
            #   CALL cl_err('','apm-623',1)
            #ELSE
            #   EXIT INPUT
            #END IF 
          #No.FUN-A90009--begin
          AFTER FIELD e 
            IF g_ima[l_ac].e='Y' THEN 
               CALL cl_set_comp_entry('wpc10',TRUE)
               LET g_ima[l_ac].wpc10=(g_today+g_ima[l_ac].wpb02)/2
               DISPLAY BY NAME g_ima[l_ac].wpc10
            ELSE 
            	 CALL cl_set_comp_entry('wpc10',FALSE)
            	 LET g_ima[l_ac].wpc10=NULL 
            	 DISPLAY BY NAME g_ima[l_ac].wpc10
            END IF 
            
          ON CHANGE e
            IF g_ima[l_ac].e='Y' THEN 
               CALL cl_set_comp_entry('wpc10',TRUE)
               LET g_ima[l_ac].wpc10=(g_today+g_ima[l_ac].wpb02)/2
               DISPLAY BY NAME g_ima[l_ac].wpc10               
            ELSE 
            	 CALL cl_set_comp_entry('wpc10',FALSE)
            	 LET g_ima[l_ac].wpc10=NULL 
            	 DISPLAY BY NAME g_ima[l_ac].wpc10
            END IF   
            
          AFTER FIELD wpc10 
            IF NOT cl_null(g_ima[l_ac].wpc10) THEN 
               IF g_ima[l_ac].wpc10<=g_today OR g_ima[l_ac].wpc10 >g_ima[l_ac].wpb02 THEN 
                  CALL cl_err('','apm-319',1)
                  NEXT FIELD wpc10 
               END IF 
            END IF             
          #No.FUN-A90009--end   
          AFTER INPUT  
             SELECT count(*) INTO l_t1 FROM wpb_file WHERE wpb04='N'   
             IF l_t1=0 THEN 
                CALL cl_err('','apm-623',1)
                RETURN
             END IF 
             IF NOT cl_confirm('apm-607') THEN 
                LET g_success = 'N'
                RETURN 
             END IF  
             BEGIN WORK 
             CALL s_showmsg_init()    
             LET g_success='N'
             LET l_n=0
             FOR l_i=1 TO g_ima.getLength() 
                 IF g_ima[l_i].e='Y' THEN 
                    LET l_success='Y'          #No.FUN-A90009
                    LET l_chr='P'
                    LET l_date=TODAY USING "yyyymmdd"
                    LET g_sql=" SELECT MAX(wpc01) FROM wpc_file ",
                              "  WHERE wpc01 like '",l_chr,"",l_date,"%' "
                    PREPARE t430_pre1 FROM g_sql 
                    EXECUTE t430_pre1 INTO l_wpc01
                    IF cl_null(l_wpc01) THEN 
                       LET l_wpc01=l_chr,l_date,"0001"
                    ELSE
                    	 LET l_a=l_wpc01[10,13]
                    	 LET l_a=l_a+1
                    	 LET l_wpc01=l_wpc01[1,9],l_a USING "&&&&"
                    END IF 
                    #No.FUN-A90009--begin
                    IF cl_null(g_ima[l_i].wpc10) THEN 
                       LET g_ima[l_i].wpc10=' '
                    END IF 
                    #No.FUN-A90009--end                  
                    SELECT COUNT(*) INTO l_t FROM wpbc_file 
                     WHERE wpbc01=g_ima[l_i].wpb01
                       AND wpbc02=g_ima[l_i].wpb02
                    IF l_t=0 THEN 
                       #No.FUN-A90009--begin
                       SELECT COUNT(*) INTO l_a FROM pmh_file WHERE pmh01=g_ima[l_i].wpb01 AND pmh25='Y'
                       IF l_a=0 THEN 
                          CALL s_errmsg('wpb01',g_ima[l_i].wpb01,'','apm-320',1)
                          LET l_success='N' 
                          CONTINUE FOR
                       ELSE 
                       #No.FUN-A90009--end 	
                          #LET l_wpbc03=' ' #No.FUN-A90009
                          #No.FUN-A90009--begin
                          DECLARE t430_pmh CURSOR FOR SELECT pmh02 FROM pmh_file WHERE pmh01=g_ima[l_i].wpb01 AND pmh25='Y'
                          FOREACH t430_pmh INTO l_wpbc03 
                          #No.FUN-A90009--end 
                             INSERT INTO wpc_file(wpc01,wpc02,wpc03,wpc04,wpc05,wpc06,wpc07,wpc08,wpc09,wpc10,wpc11)    
                             VALUES(l_wpc01,'2',l_wpbc03,g_ima[l_i].wpb02,g_ima[l_i].wpb01,
                                    g_ima[l_i].ima02,g_ima[l_i].ima44,g_ima[l_i].wpb03,'N',g_ima[l_i].wpc10,g_plant)
                             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
                                CALL s_errmsg('wpb01,wpb02',g_ima[l_i].wpb01,g_ima[l_i].wpb02,SQLCA.sqlcode,1)
                                LET g_success='N'
                                CONTINUE FOR 
                             ELSE
                             	 LET l_n=l_n+1
                             	 UPDATE wpb_file SET wpb04='Y',
                             	                     wpb05=l_wpc01
                             	               WHERE wpb01=g_ima[l_i].wpb01
                             	                 AND wpb02=g_ima[l_i].wpb02
                             	  LET g_success='Y'
                             	 CALL sendmail(g_ima[l_i].wpb01,g_ima[l_i].wpb02,l_wpbc03)
                             END IF   
                          END FOREACH 
                       END IF                     
                    ELSE
                    	 LET g_sql="SELECT wpbc03 FROM wpbc_file WHERE wpbc01='",g_ima[l_i].wpb01,"' AND wpbc02='",g_ima[l_i].wpb02,"'"   
                    	 PREPARE t430_pb1 FROM g_sql
                    	 DECLARE t430_cb1 CURSOR for t430_pb1
                    	 FOREACH t430_cb1 INTO l_wpbc03
                    	    INSERT INTO wpc_file(wpc01,wpc02,wpc03,wpc04,wpc05,wpc06,wpc07,wpc08,wpc09,wpc10,wpc11) 
                          VALUES(l_wpc01,'2',l_wpbc03,g_ima[l_i].wpb02,g_ima[l_i].wpb01,
                                 g_ima[l_i].ima02,g_ima[l_i].ima44,g_ima[l_i].wpb03,'N',g_ima[l_i].wpc10,g_plant)
                          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
                             CALL s_errmsg('wpb01,wpb02',g_ima[l_i].wpb01,g_ima[l_i].wpb02,SQLCA.sqlcode,1)
                             LET g_success='N'
                             EXIT FOREACH 
                          ELSE
                          	 LET l_n=l_n+1
                          	 UPDATE wpb_file SET wpb04='Y',
                          	                     wpb05=l_wpc01
                          	               WHERE wpb01=g_ima[l_i].wpb01
                          	                 AND wpb02=g_ima[l_i].wpb02
                          	 LET g_success='Y'
                          	 CALL sendmail(g_ima[l_i].wpb01,g_ima[l_i].wpb02,l_wpbc03)
                          END IF                     	 
                    	 END FOREACH 
                    END IF 
                 END IF 
             END FOR 
             IF g_success = 'N' THEN
                CALL s_showmsg()
                IF l_n=0 THEN 
                   CALL cl_err(l_n,'apm-608',1) 
                END IF 
                ROLLBACK WORK
             ELSE
                COMMIT WORK
                IF l_n>0 THEN 
                   CALL cl_err(l_n,'apm-608',1)
                END IF 
             END IF  
             
           ON ACTION close 
              IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT INPUT
              END IF                
           ON ACTION cancel 
              IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT INPUT
              END IF    

       END INPUT      
              
       CLOSE WINDOW t430_w3
END FUNCTION

FUNCTION sendmail(p_wpb01,p_wpb02,p_wpc03)
  DEFINE  l_str         STRING
  DEFINE  l_sql         STRING
  DEFINE  l_top         LIKE  type_file.chr100
  DEFINE  l_tempdir     LIKE  type_file.chr100
  DEFINE  p_wpb01       LIKE  wpb_file.wpb01
  DEFINE  p_wpb02       LIKE  wpb_file.wpb02
  DEFINE  p_wpc03       LIKE  wpc_file.wpc03
  DEFINE  l_pmd07       LIKE  pmd_file.pmd07
  DEFINE  l_pmd02       LIKE  pmd_file.pmd02
  DEFINE  l_cn          LIKE  type_file.num5
  DEFINE  ls_temppath   STRING
  DEFINE  ls_filename   STRING
        
  LET l_top = fgl_getenv("TOP")
  LET l_tempdir = fgl_getenv("TEMPDIR")

  INITIALIZE g_xml.* TO NULL
  SELECT wpb01,wpb02,wpb03,wpb05 INTO g_w.wpb01,g_w.wpb02,g_w.wpb03,g_w.wpb05 
    FROM wpb_file WHERE wpb01=p_wpb01 AND wpb02=p_wpb02
 
  LET ls_temppath = FGL_GETENV("TEMPDIR")
  LET ls_filename = ls_temppath.trim(),"/apmt430_" || FGL_GETPID() || ".htm"
  LET l_pmd07 = ''
  LET l_str = ''
  LET l_cn = 0 
  IF NOT cl_null(p_wpc03) THEN
     SELECT pmd07,pmd02 INTO l_pmd07,l_pmd02  FROM pmd_file
      WHERE pmd07 IS NOT NULL AND pmd08 = 'Y' AND pmd01 = p_wpc03 
     IF NOT cl_null(l_pmd07) THEN 
        LET l_str = l_pmd07,":",l_pmd02 
     END IF
  #No.FUN-A90009--begin--mark   
  #ELSE
  #   LET l_sql = " SELECT pmd07,pmd02 FROM pmd_file,wpa_file WHERE pmd07 IS NOT NULL ",
  #               "    AND pmd08 = 'Y' AND pmd01 = wpa01 AND wpa02 ='Y' "
  #   PREPARE pmd_pr2 FROM l_sql
  #   DECLARE pmd_curs2 CURSOR FOR pmd_pr2  
  #   FOREACH pmd_curs2 INTO l_pmd07,l_pmd02              
  #      IF l_cn = 0 THEN
  #         LET l_str = l_pmd07,":",l_pmd02
  #      ELSE    
  #         LET l_str = l_str,";",l_pmd07,":",l_pmd02
  #      END IF
  #      LET l_cn = l_cn +1   
  #   END FOREACH
  #No.FUN-A90009--end 
  END IF
  LET g_xml.recipient = l_str.trim()
   LET g_xml.subject   = "鼎新電腦股份有限公司-採購需求發佈通知"
 
   LET g_xml.body      = ls_filename.trim()
   LET g_xml.sender    = "tiptop@dsc.com.tw:top30"
#   LET g_xml.recipient="wangkunc@dcms.com.cn:destiny"
   LET g_channel = base.Channel.create()
   CALL g_channel.openFile( ls_filename CLIPPED, "a" )
   CALL g_channel.setDelimiter("")
 
   CALL t430_head()
   CALL t430_detail()
   CALL t430_tail()
 
   CALL g_channel.close()
 
   CALL cl_jmail()
 
   RUN "rm -f " || ls_filename
   RUN "rm -f " || FGL_GETPID() || ".xml"
     
END FUNCTION  
 
FUNCTION t430_head()

   DEFINE l_codeset STRING
   DEFINE l_lang    STRING
   
   CASE g_lang
      WHEN '0'
         LET l_lang = "zh-tw"
      WHEN '2'
         LET l_lang = "zh-cn"
      OTHERWISE
         LET l_lang = "en"
   END CASE
   LET l_codeset = "UTF-8"
 
   LET g_tmpstr ='<html><head>                                                               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<meta http-equiv="Content-Language" content="',l_lang,'">                  ' CALL g_channel.write(g_tmpstr.trimRight()) #No.FUN-740189
   LET g_tmpstr ='<meta http-equiv="Content-Type" content="text/html; charset=',l_codeset,'">' CALL g_channel.write(g_tmpstr.trimRight()) #No.FUN-740189
   LET g_tmpstr ='<title>',g_xml.subject CLIPPED,'</title>                                   ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<style><!--                                                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='div.Section1                                                               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      {page:Section1;}                                                     ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr =' p.MsoNormal                                                               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      {mso-style-parent:"";                                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      margin-bottom:.0001pt;                                               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      font-size:12.0pt;                                                    ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      font-family:新細明體;                                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      margin-left:0cm; margin-right:0cm; margin-top:0cm}                   ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='span.GramE                                                                 ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      {}  -->                                                              ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</style></head><body>                                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      <div class="Section1">                                               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      <p class="MsoNormal">                                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      <span style="COLOR: #000000; FONT-FAMILY: 新細明體; font-weight:700">' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      <font size="4"><i></i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      ',g_xml.subject CLIPPED,'</font></span></p></div>                    ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<p class="MsoNormal">　</p>                                                ' CALL g_channel.write(g_tmpstr.trimRight())
 
END FUNCTION
 
 
FUNCTION t430_detail()
   DEFINE l_gae04    LIKE gae_file.gae04 
   DEFINE ls_zl15    STRING
   DEFINE lc_kind    VARCHAR(10)       
   DEFINE lc_link    STRING    
   DEFINE l_ima02    LIKE ima_file.ima02  
   DEFINE l_ima021   LIKE ima_file.ima021 
   DEFINE l_ima44    LIKE ima_file.ima44
    
   SELECT ima02,ima021,ima44 INTO l_ima02,l_ima021,l_ima44
     FROM ima_file WHERE ima01=g_wpb.wpb01
   LET g_tmpstr ='<table border="1" style="border-collapse: collapse" width="680" id="table2">               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<tr><td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b>                                                       ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <font color="#FFFF00" size="2">需求序號</font></b></td>                                ' CALL g_channel.write(g_tmpstr.trimRight())   
   LET ls_zl15 = g_w.wpb05 CLIPPED 
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',ls_zl15.trim(),'</font></td>         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>                                                                                  ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b>                                                       ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <font color="#FFFF00" size="2">需求日期</font></b></td>                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',g_w.wpb02 CLIPPED,'</font></td>         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b><font color="#FFFF00" size="2">料件編號</font></b></td>' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',g_w.wpb01 CLIPPED,'</font></td>      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>                                                                                  ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b>                                                       ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <font color="#FFFF00" size="2">品名規格</font></b></td>                                ' CALL g_channel.write(g_tmpstr.trimRight())
 
   LET ls_zl15 = l_ima02 CLIPPED,l_ima021 CLIPPED
#   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2"><br>',ls_zl15.trim(),'<br>.</font></td> ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',ls_zl15.trim(),'</font></td> ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>                                                                                  ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b>                                                       ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <font color="#FFFF00" size="2">需求單位</font></b></td>                                ' CALL g_channel.write(g_tmpstr.trimRight())
   
#   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2"><br>',l_ima44 CLIPPED,'<br>.</font></td> ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',l_ima44 CLIPPED,'</font></td> ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>                                                                                  ' CALL g_channel.write(g_tmpstr.trimRight())

   LET g_tmpstr ='    <td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b>                                                       ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <font color="#FFFF00" size="2">需求數量</font></b></td>                                ' CALL g_channel.write(g_tmpstr.trimRight())
   
#   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2"><br>',g_w.wpb03 CLIPPED,'<br>.</font></td> ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',g_w.wpb03 CLIPPED,'</font></td> ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>                                                                                  ' CALL g_channel.write(g_tmpstr.trimRight())
 
   LET g_tmpstr ='</tr></table><p class="MsoNormal"></p>                                                     ' CALL g_channel.write(g_tmpstr.trimRight())
 
END FUNCTION
  
FUNCTION t430_tail()
 
   DEFINE l_time      DATETIME YEAR TO SECOND
   DEFINE lc_zx02     LIKE zx_file.zx02
 
   LET g_tmpstr ='<p class="MsoNormal"> </p>                                                    ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<table border="1" style="border-collapse: collapse" width="680" id="table3">  ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<tr><td width="50%" bgcolor="#000080" align="center">                         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><font color="#FFFF00" size="2">              ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    寄發人員</font></td>                                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="50%" bgcolor="#000080" align="center">                         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><font color="#FFFF00" size="2">              ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    寄發時間</font></td>                                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr>                                                                         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<tr><td width="50%" align="center">                                           ' CALL g_channel.write(g_tmpstr.trimRight())
   SELECT zx02 INTO lc_zx02 FROM zx_file WHERE zx01=g_user
   LET g_tmpstr ='    <p style="line-height: 150%"><font size="2">',g_user CLIPPED,' / ',lc_zx02 CLIPPED,'</font></td>' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="50%" align="center">                                           ' CALL g_channel.write(g_tmpstr.trimRight())
 
   LET l_time = CURRENT YEAR TO SECOND
 
   LET g_tmpstr ='    <p style="line-height: 150%"><font size="2">',l_time CLIPPED,'</font></td>' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr>                                                                         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</table></body></html>                                                        ' CALL g_channel.write(g_tmpstr.trimRight())
 
END FUNCTION

FUNCTION t430_need()
#DEFINE l_cnt        LIKE type_file.num5
#DEFINE l_ac         LIKE type_file.num5
#DEFINE l_ac_t       LIKE type_file.num5
#DEFINE p_cmd        LIKE type_file.chr1
#DEFINE l_lock_sw    LIKE type_file.chr1  
#DEFINE l_n          LIKE type_file.num5
#DEFINE l_wpbc_t     RECORD 
#                    wpbc03  LIKE wpbc_file.wpbc03,
#                    pmc03   LIKE pmc_file.pmc03
#                    END RECORD 
#DEFINE l_wpbc       DYNAMIC ARRAY OF RECORD 
#                    wpbc03  LIKE wpbc_file.wpbc03,
#                    pmc03   LIKE pmc_file.pmc03
#                    END RECORD 
DEFINE l_cmd        STRING                   
    IF cl_null(g_wpb.wpb01) OR cl_null(g_wpb.wpb02) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET l_cmd=" apmt4303 '",g_wpb.wpb01 CLIPPED ,"' '",g_wpb.wpb02 CLIPPED ,"' "
    CALL cl_cmdrun(l_cmd)
#    OPEN WINDOW t430_w4 WITH FORM "apm/42f/apmt4303"
#    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
#    CALL cl_ui_locale('apmt4303')
#    CALL l_wpbc.clear()
#    DISPLAY g_wpb.wpb01,g_wpb.wpb02 TO wpbc01,wpbc02 
#    LET g_sql=" SELECT wpbc03,pmc03 FROM wpbc_file,pmc_file ",
#              " WHERE wpbc01='",g_wpb.wpb01,"' AND wpbc02='",g_wpb.wpb02,"' AND pmc01=wpbc03 "
#    PREPARE t430_p1 FROM g_sql
#    DECLARE t430_c1 CURSOR FOR t430_p1
#    LET l_cnt=1
#    FOREACH t430_c1 INTO l_wpbc[l_cnt].*
#        IF g_cnt > g_max_rec THEN
#           CALL cl_err('', 9035, 0 )
#           EXIT FOREACH
#        END IF
#        LET l_cnt=l_cnt+1 
#    END FOREACH 
#    CALL l_wpbc.deleteElement(l_cnt)
#    LET g_rec_b = l_cnt-1
#    LET l_cnt = 0
#    
#    LET g_sql=" SELECT wpbc03,'' FROM wpbc_file ",
#              " WHERE wpbc01='",g_wpb.wpb01,"' AND wpbc02='",g_wpb.wpb02,"' AND wpbc03=? "
#    LET g_sql = cl_forupd_sql(g_sql)          
#    DECLARE t430_bc1 CURSOR FROM g_sql 
#    INPUT ARRAY l_wpbc FROM s_wpbc.* 
#      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,DELETE ROW =TRUE,APPEND ROW =TRUE,
#                 INSERT ROW =TRUE,WITHOUT DEFAULTS =true)
#        
#      BEFORE ROW 
#        LET p_cmd=''
#        LET l_ac = ARR_CURR()
#        LET l_lock_sw = 'N'    
#        IF g_rec_b>=l_ac THEN  
#           LET p_cmd='u' 
#           BEGIN WORK 
#           LET l_wpbc_t.*=l_wpbc[l_ac].*
#           OPEN t430_bc1 USING l_wpbc[l_ac].wpbc03
#           IF STATUS THEN 
#              CALL cl_err("OPEN t430_bc1:",STATUS, 1)
#              LET l_lock_sw = "Y"
#           ELSE 
#              FETCH t430_bc1 INTO l_wpbc[l_ac].*
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err(l_wpbc_t.wpbc03,SQLCA.sqlcode,1)
#                 LET l_lock_sw = "Y"
#              ELSE
#                 CALL t430_wpbc03(l_wpbc[l_ac].wpbc03)
#              END IF              
#           END IF 
#        END IF     
#        
#      BEFORE INSERT
#         LET p_cmd='a'                                                                                  
#         INITIALIZE l_wpbc[l_ac].* TO NULL           
#         
#      AFTER INSERT      
#         INSERT INTO wpbc_file VALUES(g_wpb.wpb01,g_wpb.wpb02,l_wpbc[l_ac].wpbc03)
#         IF SQLCA.sqlcode THEN 
#            CALL cl_err3('ins','wpbc_file',g_wpb.wpb01,g_wpb.wpb02,SQLCA.sqlerrd,'','',0)
#            ROLLBACK WORK 
#            CANCEL INSERT
#         ELSE
#            LET g_rec_b=g_rec_b+1
#            COMMIT WORK            
#         END IF 
#         
#      AFTER FIELD wpbc03   
#          IF NOT cl_null(l_wpbc[l_ac].wpbc03) THEN 
#             IF p_cmd='a' OR (p_cmd='u' AND l_wpbc[l_ac].wpbc03 !=l_wpbc_t.wpbc03) THEN
#                SELECT COUNT(*) INTO l_n FROM wpbc_file 
#                 WHERE wpbc01=g_wpb.wpb01
#                   AND wpbc02=g_wpb.wpb02
#                   AND wpbc03=l_wpbc[l_ac].wpbc03
#                IF l_n >0 THEN 
#                   CALL cl_err('','',1)
#                   LET l_wpbc[l_ac].wpbc03=l_wpbc_t.wpbc03
#                   NEXT FIELD wpbc03
#                END IF  
#                CALL t430_wpbc03(l_wpbc[l_ac].wpbc03)
#                IF NOT cl_null(g_errno) THEN 
#                   CALL cl_err('',g_errno,1)
#                   LET l_wpbc[l_ac].wpbc03=l_wpbc_t.wpbc03
#                   NEXT FIELD wpbc03
#                END IF 
#             END IF 
#          END IF  
#          
#       BEFORE DELETE                            #是否取消單身
#          IF l_wpbc_t.wpbc03 IS NOT NULL THEN
#             IF NOT cl_delete() THEN
#                CANCEL DELETE
#             END IF
#             IF l_lock_sw = "Y" THEN 
#                CALL cl_err("", -263, 1) 
#                CANCEL DELETE 
#             END IF 
#             DELETE FROM wpbc_file 
#              WHERE wpbc01=g_wpb.wpb01 
#                AND wpbc02=g_wpb.wpb02
#                AND wpbc03=l_wpbc_t.wpbc03  
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","wpbc_file",l_wpbc_t.wpbc03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
#                EXIT INPUT
#             END IF
#             LET g_rec_b=g_rec_b-1
#             COMMIT WORK
#          END IF
# 
#       ON ROW CHANGE
#          IF INT_FLAG THEN                 #新增程式段
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             LET l_wpbc[l_ac].* = l_wpbc_t.*
#             CLOSE t430_bc1
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
# 
#          IF l_lock_sw="Y" THEN
#             CALL cl_err(l_wpbc[l_ac].wpbc03,-263,0)
#             LET l_wpbc[l_ac].* = l_wpbc_t.*
#             UPDATE wpbc_file SET wpbc03=l_wpbc[l_ac].wpbc03
#              WHERE wpbc03 = l_wpbc_t.wpbc03 
#                AND wpbc01 = g_wpb.wpb01
#                AND wpbc01 = g_wpb.wpb01
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("upd","wpbc_file",l_wpbc_t.wpbc03,"",SQLCA.sqlcode,"","",1) 
#                LET l_wpbc[l_ac].* = l_wpbc_t.*
#             ELSE
#                COMMIT WORK
#             END IF
#          END IF
# 
#       AFTER ROW
#          LET l_ac = ARR_CURR()            # 新增
#          LET l_ac_t = l_ac                # 新增
# 
#          IF INT_FLAG THEN 
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             IF p_cmd='u' THEN
#                LET l_wpbc[l_ac].* = l_wpbc_t.*
#             END IF
#             CLOSE t430_bc1            # 新增
#             ROLLBACK WORK             # 新增
#             EXIT INPUT
#          END IF
# 
#          CLOSE t430_bc1              # 新增
#          COMMIT WORK
#          
#       ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(wpbc03)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_pmc01"
#                 LET g_qryparam.default1 = l_wpbc[l_ac].wpbc03
#                 CALL cl_create_qry() RETURNING l_wpbc[l_ac].wpbc03
#                 DISPLAY BY NAME l_wpbc[l_ac].wpbc03
#                 NEXT FIELD wpbc03
#           END CASE
#                 
#    END INPUT 
#    CLOSE t430_bc1
#    COMMIT WORK
#    CLOSE WINDOW t430_w4
    
END FUNCTION

