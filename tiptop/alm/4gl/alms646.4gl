# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: alms646.4gl
# Descriptions...: 系統參數設定作業-顧客忠誠計劃參數 
# Date & Author..: No.FUN-CC0023 12/12/04 By pauline


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE  g_lld       RECORD LIKE lld_file.*
DEFINE  g_lld_t     RECORD LIKE lld_file.*
DEFINE  g_lld01_t   LIKE lld_file.lld01
DEFINE  g_forupd_sql STRING
DEFINE  g_before_input_done LIKE type_file.num5

MAIN
    OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("alm")) THEN
      EXIT PROGRAM
   END IF

    SELECT * INTO g_lld.* FROM lld_file 

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW s646_w WITH FORM "alm/42f/alms646"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

     CALL s646_show()

      LET g_action_choice=""
      CALL s646_menu()

    CLOSE WINDOW s646_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION s646_show()

  SELECT * INTO g_lld.* FROM lld_file

  IF SQLCA.sqlcode OR cl_null(g_lld.lld01) THEN

    IF SQLCA.sqlcode=-284 THEN
       CALL cl_err3("sel","lld_file",g_lld.lld01,"",SQLCA.SQLCODE,"","ERROR!",1)
       DELETE FROM lld_file
    END IF
    LET g_lld.lld01 = '1234'
    INSERT INTO lld_file VALUES (g_lld.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","lld_file",g_lld.lld01,"",SQLCA.sqlcode,"","I",0)  
       RETURN
    END IF
  END IF
  DISPLAY BY NAME g_lld.lld01 



END FUNCTION


FUNCTION s646_menu()
MENU ""
    ON ACTION modify
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
           CALL s646_u()
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

    LET g_action_choice = "exit"
       CONTINUE MENU


    ON ACTION close
       LET INT_FLAG=FALSE
       LET g_action_choice = "exit"
       EXIT MENU

    END MENU
END FUNCTION
 
FUNCTION s646_u()

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lld01_t=g_lld.lld01
    LET g_forupd_sql = "SELECT * FROM lld_file FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE lld_cl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN lld_cl
    IF STATUS  THEN CALL cl_err('OPEN lld_curl',STATUS,1) RETURN END IF
    FETCH lld_cl INTO g_lld.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_lld_t.*=g_lld.*
    DISPLAY BY NAME g_lld.lld01 
     WHILE TRUE
        CALL s646_i()
        IF INT_FLAG THEN
            CALL s646_show()
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
         UPDATE lld_file
           SET lld_file.*=g_lld.*
         EXIT WHILE
     END WHILE
    CLOSE lld_cl
    COMMIT WORK
END FUNCTION

FUNCTION s646_i()
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_j     LIKE type_file.num5
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_1     LIKE type_file.chr1
   DEFINE l_2     LIKE type_file.chr1
   DEFINE l_3     LIKE type_file.chr1
   DEFINE l_4     LIKE type_file.chr1

   INPUT BY NAME g_lld.lld01
           WITHOUT DEFAULTS

      BEFORE INPUT

      AFTER FIELD lld01 
         IF NOT cl_null(g_lld.lld01) THEN
            LET l_i = length(g_lld.lld01)
            IF l_i > 4 OR l_i < 1 THEN
               CALL cl_err('','alm-h97',0)
               NEXT FIELD lld01
            END IF 
            LET l_1 = 'N'
            LET l_2 = 'N'
            LET l_3 = 'N'
            LET l_4 = 'N'
            FOR l_j = 1 TO l_i 
                IF g_lld.lld01[l_j,l_j] NOT MATCHES '[1-4]' THEN
                   CALL cl_err('','alm-h99',0)
                   NEXT FIELD lld01
                END IF
                IF g_lld.lld01[l_j,l_j] = '1' THEN  
                   IF l_1 = 'Y' THEN
                      CALL cl_err('','alm-h98',0)
                      NEXT FIELD lld01
                   ELSE
                      LET l_1 = 'Y'
                   END IF
                END IF
                IF g_lld.lld01[l_j,l_j] = '2' THEN
                   IF l_2 = 'Y' THEN
                      CALL cl_err('','alm-h98',0)
                      NEXT FIELD lld01
                   ELSE 
                      LET l_2 = 'Y'
                   END IF
                END IF
                IF g_lld.lld01[l_j,l_j] = '3' THEN
                   IF l_3 = 'Y' THEN
                      CALL cl_err('','alm-h98',0)
                      NEXT FIELD lld01
                   ELSE
                      LET l_3 = 'Y'
                   END IF
                END IF
                IF g_lld.lld01[l_j,l_j] = '4' THEN
                   IF l_4 = 'Y' THEN
                      CALL cl_err('','alm-h98',0)
                      NEXT FIELD lld01
                   ELSE
                      LET l_4 = 'Y'
                   END IF
                END IF
            END FOR
         END IF

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
#FUN-CC0023
