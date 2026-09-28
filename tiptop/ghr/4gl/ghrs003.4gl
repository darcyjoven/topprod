# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghrs003.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hrbt    RECORD LIKE hrbt_file.*
DEFINE  g_hrbt_t  RECORD LIKE hrbt_file.*
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_h,g_m   LIKE  type_file.num5

MAIN
    DEFINE
    p_row,p_col         LIKE type_file.num5      #No.FUN-680123 SMALLINT
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 

   OPEN WINDOW s003_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghrs003"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   
   CALL s003_show()
 

   LET g_action_choice=""
   CALL s003_menu()

 
   CLOSE WINDOW s003_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION s003_show()
   
   SELECT * INTO g_hrbt.* FROM hrbt_file WHERE hrbt00='0'
   LET g_hrbt_t.* = g_hrbt.*

   DISPLAY BY NAME g_hrbt.hrbt01,g_hrbt.hrbt011,g_hrbt.hrbt016,   
                   g_hrbt.hrbt02,g_hrbt.hrbt021,g_hrbt.hrbt026,
                   g_hrbt.hrbt03,g_hrbt.hrbt031,g_hrbt.hrbt036,
                   g_hrbt.hrbt04,g_hrbt.hrbtud02,g_hrbt.hrbtuser,
                   g_hrbt.hrbtgrup,g_hrbt.hrbtoriu,
                   g_hrbt.hrbtorig,g_hrbt.hrbtmodu,g_hrbt.hrbtdate
                   
    CALL cl_show_fld_cont()                  
END FUNCTION
	
FUNCTION s003_menu()
 
   MENU ""
      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN 
            CALL s003_u()
         END IF
      
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          
      ON ACTION exit
           LET g_action_choice = "exit"
         EXIT MENU
         
      ON ACTION help
         CALL cl_show_help()
         
      ON ACTION controlg    
         CALL cl_cmdask()
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
         LET g_action_choice = "exit"
         CONTINUE MENU
       
       ON ACTION close    
          LET INT_FLAG=FALSE 		
          LET g_action_choice = "exit"
          EXIT MENU
 
   END MENU
 
END FUNCTION
	
FUNCTION s003_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_forupd_sql = "SELECT * FROM hrbt_file      ",
                     " WHERE hrbt00 = '0' FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE hrbt_curl CURSOR FROM g_forupd_sql
 
   BEGIN WORK
   OPEN hrbt_curl 
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   FETCH hrbt_curl INTO g_hrbt.*
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   WHILE TRUE
      CALL s003_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_hrbt.* = g_hrbt_t.*
         CALL s003_show()
         EXIT WHILE
      END IF
 
      UPDATE hrbt_file SET hrbt01 = g_hrbt.hrbt01,
                           hrbt011 = g_hrbt.hrbt011,
                           hrbt016 = g_hrbt.hrbt016,
                           hrbt02 = g_hrbt.hrbt02,
                           hrbt021 = g_hrbt.hrbt021,
                           hrbt026 = g_hrbt.hrbt026,
                           hrbt03 = g_hrbt.hrbt03,
                           hrbt031 = g_hrbt.hrbt031,
                           hrbt036 = g_hrbt.hrbt036,
                           hrbt04 = g_hrbt.hrbt04,
                           hrbtud02 = g_hrbt.hrbtud02,
                           hrbtmodu = g_user,
                           hrbtdate = g_today
                     WHERE hrbt00='0'
      IF STATUS THEN
         CALL cl_err3("upd","hrbt_file","","",STATUS,"","",0)   #No.FUN-660116
         CONTINUE WHILE          
      END IF   
      EXIT WHILE
   END WHILE
   CLOSE hrbt_curl    #TQC-960168 add 
   COMMIT WORK       #TQC-960168 add   
 
END FUNCTION
	
FUNCTION s003_i()
DEFINE l_cnt   LIKE type_file.num5

       IF s_shut(0) THEN
          RETURN
       END IF

       INPUT BY NAME g_hrbt.hrbt01,g_hrbt.hrbt011,g_hrbt.hrbt016,
                     g_hrbt.hrbt02,g_hrbt.hrbt021,g_hrbt.hrbt026,
                     g_hrbt.hrbt03,g_hrbt.hrbt031,g_hrbt.hrbt036,
                     g_hrbt.hrbt04,g_hrbt.hrbtud02
          WITHOUT DEFAULTS 				
       
       BEFORE INPUT
          LET g_before_input_done = FALSE             
          LET g_before_input_done = TRUE
          IF g_hrbt.hrbt01='N' THEN
             CALL cl_set_comp_entry("hrbt011,hrbt016",FALSE)
          ELSE
             CALL cl_set_comp_entry("hrbt011,hrbt016",TRUE)
          END IF
          IF g_hrbt.hrbt02='N' THEN
             CALL cl_set_comp_entry("hrbt021,hrbt026",FALSE)
          ELSE
             CALL cl_set_comp_entry("hrbt021,hrbt026",TRUE)
          END IF
          IF g_hrbt.hrbt03='N' THEN
             CALL cl_set_comp_entry("hrbt031,hrbt036",FALSE)
          ELSE
             CALL cl_set_comp_entry("hrbt031,hrbt036",TRUE)
          END IF
          
       ON CHANGE hrbt01
          IF g_hrbt.hrbt01='N' THEN
             CALL cl_set_comp_entry("hrbt011,hrbt016",FALSE)
             LET g_hrbt.hrbt011=NULL
             LET g_hrbt.hrbt016=NULL
             DISPLAY BY NAME g_hrbt.hrbt011,g_hrbt.hrbt016
          ELSE
             CALL cl_set_comp_entry("hrbt011,hrbt016",TRUE)
             NEXT FIELD hrbt011
          END IF	 
          
       AFTER FIELD hrbt011
          IF cl_null(g_hrbt.hrbt011) THEN
             NEXT FIELD hrbt011
          END IF 
          SELECT count(*) INTO l_cnt FROM hrbu_file WHERE hrbu01=g_hrbt.hrbt011
          IF l_cnt=0 THEN 
             NEXT FIELD hrbt011
          END IF

       ON CHANGE hrbt02
          IF g_hrbt.hrbt02='N' THEN
             CALL cl_set_comp_entry("hrbt021,hrbt026",FALSE)
             LET g_hrbt.hrbt021=NULL
             LET g_hrbt.hrbt026=NULL
             DISPLAY BY NAME g_hrbt.hrbt021,g_hrbt.hrbt026
          ELSE
             CALL cl_set_comp_entry("hrbt021,hrbt026",TRUE)
             NEXT FIELD hrbt021
          END IF	  	
         
       AFTER FIELD hrbt021
          IF cl_null(g_hrbt.hrbt021) THEN
             NEXT FIELD hrbt021
          END IF 
          SELECT count(*) INTO l_cnt FROM hrbu_file WHERE hrbu01=g_hrbt.hrbt021
          IF l_cnt=0 THEN 
             NEXT FIELD hrbt021
          END IF 

       ON CHANGE hrbt03
          IF g_hrbt.hrbt03='N' THEN
             CALL cl_set_comp_entry("hrbt031,hrbt036",FALSE)
             LET g_hrbt.hrbt031=NULL
             LET g_hrbt.hrbt036=NULL
             DISPLAY BY NAME g_hrbt.hrbt031,g_hrbt.hrbt036
          ELSE
             CALL cl_set_comp_entry("hrbt031,hrbt036",TRUE)
             NEXT FIELD hrbt031
          END IF	
         
       AFTER FIELD hrbt031
          IF cl_null(g_hrbt.hrbt031) THEN
             NEXT FIELD hrbt031
          END IF 
          SELECT count(*) INTO l_cnt FROM hrbu_file WHERE hrbu01=g_hrbt.hrbt031
          IF l_cnt=0 THEN 
             NEXT FIELD hrbt031
          END IF 

       AFTER INPUT
          IF g_hrbt.hrbt01='Y' AND (cl_null(g_hrbt.hrbt016) OR g_hrbt.hrbt016=' ') THEN NEXT FIELD hrbt016 END IF 
          IF g_hrbt.hrbt02='Y' AND (cl_null(g_hrbt.hrbt026) OR g_hrbt.hrbt026=' ') THEN NEXT FIELD hrbt026 END IF
          IF g_hrbt.hrbt03='Y' AND (cl_null(g_hrbt.hrbt036) OR g_hrbt.hrbt036=' ') THEN NEXT FIELD hrbt036 END IF

       ON ACTION controlp
          CASE WHEN INFIELD(hrbt011)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbu01"
                 CALL cl_create_qry() RETURNING g_hrbt.hrbt011
                 DISPLAY BY NAME g_hrbt.hrbt011
                 NEXT FIELD hrbt011
               WHEN INFIELD(hrbt021)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbu01"
                 CALL cl_create_qry() RETURNING g_hrbt.hrbt021
                 DISPLAY BY NAME g_hrbt.hrbt021
                 NEXT FIELD hrbt021
               WHEN INFIELD(hrbt031)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbu01"
                 CALL cl_create_qry() RETURNING g_hrbt.hrbt031
                 DISPLAY BY NAME g_hrbt.hrbt031
                 NEXT FIELD hrbt031
          END CASE
          
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

   END INPUT
 
END FUNCTION  
	
	
         
                   
