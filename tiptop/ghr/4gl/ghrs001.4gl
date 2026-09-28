# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghrs001.4gl
# Descriptions...: 参数配置（人事跟踪，电子卡，身份证）
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  g_hrah    RECORD LIKE hrah_file.*
DEFINE  g_hrah_t  RECORD LIKE hrah_file.*
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5

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
 

   OPEN WINDOW s001_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghrs001"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   
   CALL s001_show()
 

   LET g_action_choice=""
   CALL s001_menu()

 
   CLOSE WINDOW s001_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION s001_show()
   
   SELECT * INTO g_hrah.* FROM hrah_file WHERE hrah00='000000'
   LET g_hrah_t.* = g_hrah.*

   DISPLAY BY NAME g_hrah.hrah01,g_hrah.hrah02,g_hrah.hrah03,g_hrah.hrah04,g_hrah.hrahoriu,   
                   g_hrah.hrahorig,g_hrah.hrahuser,g_hrah.hrahgrup,g_hrah.hrahmodu,g_hrah.hrahdate,
                   g_hrah.hrahacti
                   
    CALL cl_show_fld_cont()                  
END FUNCTION
	
FUNCTION s001_menu()
 
   MENU ""
      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN 
            CALL s001_u()
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
	
FUNCTION s001_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_forupd_sql = "SELECT * FROM hrah_file      ",
                     " WHERE hrah00 = '000000' FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE hrah_curl CURSOR FROM g_forupd_sql
 
   BEGIN WORK
   OPEN hrah_curl 
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   FETCH hrah_curl INTO g_hrah.*
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   WHILE TRUE
      CALL s001_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_hrah.* = g_hrah_t.*
         CALL s001_show()
         EXIT WHILE
      END IF
 
      UPDATE hrah_file SET hrah01 = g_hrah.hrah01,
                           hrah02 = g_hrah.hrah02,
                           hrah03 = g_hrah.hrah03,
                           hrah04 = g_hrah.hrah04,
                           hrahmodu = g_user,
                           hrahdate = g_today
                     WHERE hrah00='000000'
      IF STATUS THEN
         CALL cl_err3("upd","hrah_file","","",STATUS,"","",0)   #No.FUN-660116
         CONTINUE WHILE          
      END IF   
      EXIT WHILE
   END WHILE
   CLOSE hrah_curl    #TQC-960168 add 
   COMMIT WORK       #TQC-960168 add   
   CALL s001_show()
 
END FUNCTION
	
FUNCTION s001_i()
       
       IF s_shut(0) THEN
          RETURN
       END IF

       INPUT BY NAME g_hrah.hrah01,g_hrah.hrah02,g_hrah.hrah03,g_hrah.hrah04
          WITHOUT DEFAULTS 				
       
       BEFORE INPUT
          LET g_before_input_done = FALSE             
          LET g_before_input_done = TRUE
          
       AFTER FIELD hrah01
         IF NOT cl_null(g_hrah.hrah01) THEN
            IF g_hrah.hrah01 NOT MATCHES '[YN]' THEN
               LET g_hrah.hrah01=g_hrah_t.hrah01
               DISPLAY BY NAME g_hrah.hrah01
               NEXT FIELD hrah01
            END IF
         END IF
         LET g_hrah_t.hrah01=g_hrah.hrah01
         
       AFTER FIELD hrah02
         IF NOT cl_null(g_hrah.hrah02) THEN
            IF g_hrah.hrah02 NOT MATCHES '[YN]' THEN
               LET g_hrah.hrah02=g_hrah_t.hrah02
               DISPLAY BY NAME g_hrah.hrah02
               NEXT FIELD hrah02
            END IF
         END IF
         LET g_hrah_t.hrah02=g_hrah.hrah02
         
       AFTER FIELD hrah03
         IF NOT cl_null(g_hrah.hrah03) THEN
            IF g_hrah.hrah03 NOT MATCHES '[01]' THEN
               LET g_hrah.hrah03=g_hrah_t.hrah03
               DISPLAY BY NAME g_hrah.hrah03
               NEXT FIELD hrah03
            END IF
         END IF
         LET g_hrah_t.hrah03=g_hrah.hrah03
         
       AFTER FIELD hrah04
         IF NOT cl_null(g_hrah.hrah04) THEN
            IF g_hrah.hrah04 NOT MATCHES '[012]' THEN
               LET g_hrah.hrah04=g_hrah_t.hrah04
               DISPLAY BY NAME g_hrah.hrah04
               NEXT FIELD hrah04
            END IF
         END IF
         LET g_hrah_t.hrah04=g_hrah.hrah04
         
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
	
	
         
                   
