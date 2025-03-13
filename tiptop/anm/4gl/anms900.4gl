# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anms900.4gl
# Descriptions...: 票據管理系統參數(二)設定作業–資金模擬參數設定
# Date & Author..: 06/02/20 By Nicola
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-740058 07/04/12 By Judy 選擇幣種不能帶出相應的幣種名稱
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_nqa        RECORD LIKE nqa_file.*,
          g_nqa_t      RECORD LIKE nqa_file.*
   DEFINE g_azi02      LIKE azi_file.azi02
   DEFINE g_forupd_sql STRING
 
MAIN
 
   OPTIONS 
      INPUT NO WRAP
   DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL s900(4,12)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN  
 
FUNCTION s900(p_row,p_col)
   DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
   OPEN WINDOW s900_w WITH FORM "anm/42f/anms900" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL s900_show()
 
   LET g_action_choice=""
 
   CALL s900_menu()
 
   CLOSE WINDOW s900_w
 
END FUNCTION
 
FUNCTION s900_show()
 
   SELECT * INTO g_nqa.* FROM nqa_file WHERE nqa00 = '0'

   IF SQLCA.sqlcode THEN
      INSERT INTO nqa_file(nqa00,nqa01,nqaoriu,nqaorig)
                   VALUES ('0',g_aza.aza17, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
      IF SQLCA.sqlcode THEN
#        CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660148
         CALL cl_err3("ins","nqa_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660148
         RETURN
      END IF
      LET g_nqa.nqa00 = "0"
      LET g_nqa.nqa01 = g_aza.aza17
   END IF
 
   SELECT azi02 INTO g_azi02
     FROM azi_file
    WHERE azi01 = g_nqa.nqa01
 
   DISPLAY g_nqa.nqa01,g_azi02 TO nqa01,azi02
                   
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION s900_menu()
 
   MENU ""
      ON ACTION modify 
         LET g_action_choice = "modify"
         IF cl_chk_act_auth() THEN
            CALL s900_u()
         END IF
 
      ON ACTION help 
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about 
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
    
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE
         LET g_action_choice = "exit"
         EXIT MENU
 
   END MENU
 
END FUNCTION
 
 
FUNCTION s900_u()
 
   CALL cl_opmsg('u')
   MESSAGE ""
 
   LET g_forupd_sql = "SELECT * FROM nqa_file WHERE nqa00 = '0' FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE nqa_curl CURSOR FROM g_forupd_sql
 
   BEGIN WORK
 
   OPEN nqa_curl
   IF STATUS THEN
      CALL cl_err('OPEN nqa_curl',STATUS,1)
      RETURN
   END IF
 
   FETCH nqa_curl INTO g_nqa.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_nqa_t.* = g_nqa.*
 
   DISPLAY BY NAME g_nqa.nqa01
                   
   WHILE TRUE
      CALL s900_i()
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_nqa.* = g_nqa_t.*
         CALL s900_show()
         EXIT WHILE
      END IF
 
      UPDATE nqa_file SET nqa01 = g_nqa.nqa01
       WHERE nqa00 = '0'
      IF SQLCA.sqlcode THEN
#        CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660148
         CALL cl_err3("upd","nqa_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660148
         CONTINUE WHILE
      END IF
 
      CLOSE nqa_curl
      COMMIT WORK
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION s900_i()
   DEFINE l_n   LIKE type_file.num5          #No.FUN-680107 SMALLINT
          
   INPUT BY NAME g_nqa.nqa01 WITHOUT DEFAULTS 
 
      AFTER FIELD nqa01
         IF NOT cl_null(g_nqa.nqa01) THEN
#TQC-740058.....begin
#            SELECT azi02 INTO g_azi02
#              FROM azi_file
#             WHERE azi01 = g_nqa.nqa01
              CALL s900_nqa01()
#             IF SQLCA.sqlcode THEN
#                CALL cl_err('nqa01','anm-007',0)   #No.FUN-660148
#                CALL cl_err3("sel","azi_file",g_nqa.nqa01,"","anm-007","","nqa01",0) #No.FUN-660148
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nqa.nqa01,g_errno,0)
#TQC-740058.....end
                 NEXT FIELD nqa01
              END IF
              LET g_nqa_t.nqa01 = g_nqa.nqa01
         END IF
      
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      
      ON ACTION CONTROLG
         CALL cl_cmdask()
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqa01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_nqa.nqa01
               CALL cl_create_qry() RETURNING g_nqa.nqa01
               DISPLAY BY NAME g_nqa.nqa01
               NEXT FIELD nqa01
            OTHERWISE
               EXIT CASE
         END CASE
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
  
   END INPUT
 
END FUNCTION
#TQC-740058.....begin                                                           
FUNCTION s900_nqa01()                                                           
                                                                                
      LET g_errno = ' '                                                         
                                                                                
      SELECT azi02 INTO g_azi02                                                 
        FROM azi_file                                                           
       WHERE azi01 = g_nqa.nqa01                                                
      CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3008'                     
                                    LET g_azi02 = NULL                          
           OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-----'   
      END CASE                                                                  
      IF cl_null(g_errno) THEN                                                  
         DISPLAY g_azi02 TO FORMONLY.azi02                                      
      END IF                                                                    
END FUNCTION                                                                    
#TQC-740058.....end
