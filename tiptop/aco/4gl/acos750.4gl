# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: acos750.4gl
# Descriptions...: 電子海關合同參數設定
# Date & Author..: FUN-930151 09/04/01 BY rainy 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50039 11/07/06 By xianghui 增加自訂欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_cez_t         RECORD LIKE cez_file.*,  
        g_cez_o         RECORD LIKE cez_file.*   
DEFINE  g_forupd_sql    STRING                         
DEFINE  g_before_input_done   LIKE type_file.num5      
DEFINE  p_cmd           LIKE type_file.chr1           
DEFINE  g_cnt           LIKE type_file.num10           
 
MAIN
 DEFINE    p_row,p_col        LIKE type_file.num5     
 
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   SELECT * INTO g_cez.* FROM cez_file WHERE cez00 = '0'
   IF STATUS = 100 THEN
      LET g_cez.cez00='0' 
      INSERT INTO cez_file VALUES(g_cez.*)
   END IF
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW s750_w AT p_row,p_col 
     WITH FORM "aco/42f/acos750"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
 
   CALL s750_show()
 
   LET g_action_choice=""
   CALL s750_menu()
 
   CLOSE WINDOW s750_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION s750_show()
  LET g_cez_t.* = g_cez.*
  LET g_cez_o.* = g_cez.*
  DISPLAY BY NAME g_cez.cez01,g_cez.cez02,g_cez.cez03
                 ,g_cez.cez04,
                  g_cez.cezud01,g_cez.cezud02,g_cez.cezud03,g_cez.cezud04,g_cez.cezud05,     #FUN-B50039
                  g_cez.cezud06,g_cez.cezud07,g_cez.cezud08,g_cez.cezud09,g_cez.cezud10,     #FUN-B50039
                  g_cez.cezud11,g_cez.cezud12,g_cez.cezud13,g_cez.cezud14,g_cez.cezud15      #FUN-B50039
  
  CALL s750_cez03()                
  CALL cl_show_fld_cont()               
END FUNCTION
 
FUNCTION s750_menu()
 
   MENU ""
      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN 
            CALL s750_u()
         END IF
      ON ACTION reopen
         LET g_action_choice="reopen"
         IF cl_chk_act_auth() THEN
            CALL s750_y()
         END IF
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()        
         
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
 
       #-- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 	
           LET g_action_choice = "exit"
           EXIT MENU
 
   END MENU
END FUNCTION
 
 
FUNCTION s750_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_forupd_sql = "SELECT * FROM cez_file      ",
                      " WHERE cez00 = '0' FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE cez_curl CURSOR FROM g_forupd_sql
 
   BEGIN WORK
   OPEN cez_curl 
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   FETCH cez_curl INTO g_cez.*
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   WHILE TRUE
      CALL s750_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_cez.* = g_cez_t.*
         CALL s750_show()
         EXIT WHILE
      END IF
 
      UPDATE cez_file SET * = g_cez.* WHERE cez00='0'
      IF STATUS THEN
         CALL cl_err('',STATUS,0)
         CONTINUE WHILE
      END IF
 
      CLOSE cez_curl
      COMMIT WORK
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
 
FUNCTION s750_i()
   
   INPUT BY NAME g_cez.cez01,g_cez.cez02,g_cez.cez03
                ,g_cez.cez04,
                 g_cez.cezud01,g_cez.cezud02,g_cez.cezud03,g_cez.cezud04,g_cez.cezud05,     #FUN-B50039
                 g_cez.cezud06,g_cez.cezud07,g_cez.cezud08,g_cez.cezud09,g_cez.cezud10,     #FUN-B50039
                 g_cez.cezud11,g_cez.cezud12,g_cez.cezud13,g_cez.cezud14,g_cez.cezud15      #FUN-B50039
       WITHOUT DEFAULTS 
 
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL s750_set_entry(p_cmd)
          CALL s750_set_no_entry(p_cmd)
          CALL s750_set_no_required()
          CALL s750_set_required()
          LET g_before_input_done = TRUE
 
      AFTER FIELD cez01
         IF NOT cl_null(g_cez.cez01) THEN
            IF g_cez.cez01 NOT MATCHES '[YN]' THEN
               LET g_cez.cez01=g_cez_o.cez01
               DISPLAY BY NAME g_cez.cez01
               NEXT FIELD cez01
            END IF
         END IF
         LET g_cez_o.cez01=g_cez.cez01
 
 
      ON CHANGE cez02
         IF NOT cl_null(g_cez.cez02) THEN
            IF g_cez.cez02 NOT MATCHES '[YN]' THEN
               LET g_cez.cez02=g_cez_o.cez02
               DISPLAY BY NAME g_cez.cez02
               NEXT FIELD cez02
            END IF
         END IF
         LET g_cez_o.cez02=g_cez.cez02
         IF g_cez.cez02 = 'N' THEN
            CALL s750_set_no_entry(p_cmd)
            CALL s750_set_no_required()
         ELSE
            CALL s750_set_entry(p_cmd)
            CALL s750_set_required()
           NEXT FIELD cez03
         END IF
       
 
      AFTER FIELD cez03
         IF NOT cl_null(g_cez.cez03) THEN
            SELECT COUNT(*) INTO g_cnt FROM cna_file
             WHERE cna01 = g_cez.cez03 
            IF g_cnt = 0 THEN
               CALL cl_err('',100,0)
               LET g_cez.cez03 =g_cez_o.cez03 
               DISPLAY BY NAME g_cez.cez03 
               NEXT FIELD cez03 
            END IF
         END IF
         CALL s750_cez03()                
         LET g_cez_o.cez03 =g_cez.cez03  
 
      #FUN-B50039-add-str--
      AFTER FIELD cezud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cezud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF      

      #FUN-B50039-add-end--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(cez03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_cna' 
               LET g_qryparam.default1 =g_cez.cez03  
               CALL cl_create_qry() RETURNING g_cez.cez03 
               DISPLAY BY NAME g_cez.cez03
               CALL s750_cez03()                
               NEXT FIELD cez03
       END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
   END INPUT
 
END FUNCTION
 
 
FUNCTION s750_y()
 DEFINE   l_cez01    LIKE type_file.chr1         
     SELECT cez01 INTO l_cez01 FROM cez_file WHERE cez00='0'
     IF l_cez01 = 'Y' THEN RETURN END IF
     UPDATE cez_file SET cez01='Y' WHERE cez00='0'
     IF STATUS THEN
        LET g_cez.cez01='N'
        CALL cl_err('upd cez01:',STATUS,0)
     ELSE
        LET g_cez.cez01='Y'
     END IF
     DISPLAY BY NAME g_cez.cez01 
END FUNCTION
 
FUNCTION s750_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1        
 
   IF INFIELD(cez02) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("cez03",TRUE)
   END IF
END FUNCTION
 
FUNCTION s750_set_no_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1      
 
   IF INFIELD(cez02) OR (NOT g_before_input_done) THEN
         IF g_cez.cez02 = 'N'  THEN
              LET g_cez.cez03 = NULL
              CALL s750_cez03()
              DISPLAY BY NAME g_cez.cez03
              CALL cl_set_comp_entry("cez03",FALSE)
         ELSE
              CALL cl_set_comp_entry("cez03",TRUE)
         END IF
   END IF
END FUNCTION
 
FUNCTION s750_set_required()
  IF g_cez.cez02 = 'Y' THEN
     CALL cl_set_comp_required("cez03",TRUE)
  END IF
END FUNCTION
 
FUNCTION s750_set_no_required()
  CALL cl_set_comp_required("cez03",FALSE)
END FUNCTION
 
FUNCTION s750_cez03()
  DEFINE l_cna02  LIKE cna_file.cna02
 
  SELECT cna02 INTO l_cna02
    FROM cna_file
   WHERE cna01 = g_cez.cez03
  
  DISPLAY l_cna02 TO cna02 
END FUNCTION
#FUN-930151
