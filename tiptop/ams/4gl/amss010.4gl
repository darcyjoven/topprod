# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: amss010.4gl
# Descriptions...: MPS系統參數設定
# Date & Author..: 00/01/16 By Apple
# Modify.........: No.FUN-4C0041 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/31 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
# Modify.........: No.FUN-B50039 11/07/07 By fengrui 增加自定義欄位
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_mpz_t         RECORD LIKE mpz_file.*,  # 預留參數檔
        g_mpz_o         RECORD LIKE mpz_file.*   # 預留參數檔
DEFINE p_row,p_col      LIKE type_file.num5      #NO.FUN-680101 SMALLINT                                                
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #NO.FUN-680101 SMALLINT
 
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
    OPEN WINDOW s010_w WITH FORM "ams/42f/amss010" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_mpz.mpz00='0'
    LET g_mpz.mpzoriu = g_user      #No.FUN-980030 10/01/04
    LET g_mpz.mpzorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO mpz_file VALUES(g_mpz.*)
 
    CALL s010_show()
 
    LET g_action_choice=""
    CALL s010_menu()
 
    CLOSE WINDOW s010_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION s010_show()
    SELECT * INTO g_mpz.* FROM mpz_file WHERE mpz00 = '0' 
    LET g_mpz_t.* = g_mpz.*
    LET g_mpz_o.* = g_mpz.*
    DISPLAY BY NAME g_mpz.mpz_v,g_mpz.mpz02,g_mpz.mpz03,g_mpz.mpz04,
                    g_mpz.mpz05,
                    g_mpz.mpzuser,g_mpz.mpzgrup,g_mpz.mpzmodu,
                    g_mpz.mpzdate,
                    #FUN-B50039-add-str--
                    g_mpz.mpzud01,g_mpz.mpzud02,g_mpz.mpzud03,
                    g_mpz.mpzud04,g_mpz.mpzud05,g_mpz.mpzud06,
                    g_mpz.mpzud07,g_mpz.mpzud08,g_mpz.mpzud09,
                    g_mpz.mpzud10,g_mpz.mpzud11,g_mpz.mpzud12,
                    g_mpz.mpzud13,g_mpz.mpzud14,g_mpz.mpzud15
                    #FUN-B50039-add-end--
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s010_menu()
    MENU ""
       ON ACTION modify 
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN 
              CALL s010_u()
          END IF 
       
       ON ACTION help 
              CALL cl_show_help()
       
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU
       
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s010_u()
 
    CALL cl_opmsg('u')
    MESSAGE ""
 
    LET g_forupd_sql = "SELECT * FROM mpz_file WHERE mpz00 = '0' FOR UPDATE"    
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE mpz_curl CURSOR FROM g_forupd_sql 
 
    BEGIN WORK
    OPEN mpz_curl 
    IF STATUS  THEN CALL cl_err('OPEN mpz_curl',STATUS,1) RETURN END IF         
    FETCH mpz_curl INTO g_mpz.*
    IF STATUS  THEN CALL cl_err('',STATUS,0) RETURN END IF 
 
    WHILE TRUE
	LET g_mpz.mpzuser = g_user
	LET g_mpz.mpzoriu = g_user #FUN-980030
	LET g_mpz.mpzorig = g_grup #FUN-980030
	LET g_mpz.mpzgrup = g_grup               #使用者所屬群
	LET g_mpz.mpzdate = g_today
	LET g_mpz.mpzmodu=g_user                     #修改者
        CALL s010_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_mpz.* = g_mpz_t.* CALL s010_show()
           EXIT WHILE
        END IF
        UPDATE mpz_file SET * = g_mpz.* WHERE mpz00='0'
        IF STATUS THEN 
 #      CALL cl_err('',STATUS,0) #No.FUN-660108
        CALL cl_err3("upd","mpz_file",g_mpz.mpz00,"",STATUS,"","",0)       #No.FUN-660108      
         CONTINUE WHILE
        ELSE                                    #FUN-4C0041權限控管
           LET g_data_owner=g_mpz.mpzuser
           LET g_data_group=g_mpz.mpzgrup
           CALL s010_show()
   
        END IF
        CLOSE mpz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s010_i()
   DEFINE   l_aza     LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(01)
 
   
   INPUT BY NAME 
      g_mpz.mpz_v,g_mpz.mpz02,g_mpz.mpz03,g_mpz.mpz05,
      g_mpz.mpzuser,g_mpz.mpzgrup,g_mpz.mpzmodu,
      g_mpz.mpzdate,
      #FUN-B50039-add-str--
      g_mpz.mpzud01,g_mpz.mpzud02,g_mpz.mpzud03,
      g_mpz.mpzud04,g_mpz.mpzud05,g_mpz.mpzud06,
      g_mpz.mpzud07,g_mpz.mpzud08,g_mpz.mpzud09,
      g_mpz.mpzud10,g_mpz.mpzud11,g_mpz.mpzud12,
      g_mpz.mpzud13,g_mpz.mpzud14,g_mpz.mpzud15
      #FUN-B50039-add-end--
      WITHOUT DEFAULTS 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL s010_set_entry()
         CALL s010_set_no_entry()
         LET g_before_input_done = TRUE 
 
      BEFORE FIELD mpz02
         CALL s010_set_entry()
 
      AFTER FIELD mpz02
         IF NOT cl_null(g_mpz.mpz02) THEN 
            IF g_mpz.mpz02 NOT MATCHES '[12345]' THEN
               NEXT FIELD mpz02 
            END IF
            IF g_mpz.mpz02 <> '1' THEN 
               LET g_mpz.mpz03 = '' 
               DISPLAY BY NAME g_mpz.mpz03
            END IF
         END IF
         CALL s010_set_no_entry()
 
      AFTER FIELD mpz03
         IF NOT cl_null(g_mpz.mpz03) THEN 
            SELECT * FROM rpg_file WHERE rpg01 = g_mpz.mpz03
            IF STATUS THEN
    #          CALL cl_err('sel rpg:',STATUS,0)  #No.FUN-660108
               CALL cl_err3("sel","rpg_file",g_mpz.mpz03,"",STATUS,"","sel rpg:",0)       #No.FUN-660108
               NEXT FIELD mpz03
            END IF
         END IF
 
      AFTER FIELD mpz05
         IF cl_null(g_mpz.mpz05) THEN
            LET g_mpz.mpz05 = ' ' 
         END IF
      #FUN-B50039-add-str--
      AFTER FIELD mpzud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mpzud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--
      ON ACTION controlp
         CASE 
            WHEN INFIELD(mpz03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_rpg"
                 LET g_qryparam.default1 = g_mpz.mpz03
                 CALL cl_create_qry() RETURNING g_mpz.mpz03
#                 CALL FGL_DIALOG_SETBUFFER( g_mpz.mpz03 )
                 DISPLAY BY NAME g_mpz.mpz03
                 NEXT FIELD mpz03
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
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
 
FUNCTION s010_set_entry() 
 
    CASE WHEN INFIELD(mpz02) OR ( NOT g_before_input_done )
              CALL cl_set_comp_entry("mpz03",TRUE) 
    END CASE
 
END FUNCTION
 
FUNCTION s010_set_no_entry() 
 
    CASE WHEN INFIELD(mpz02) OR ( NOT g_before_input_done ) 
              IF g_mpz.mpz02 <> '1' THEN  
                 CALL cl_set_comp_entry("mpz03",FALSE) 
              END IF 
    END CASE
 
END FUNCTION
 
FUNCTION s010_aae(p_cmd,p_type)
 DEFINE   p_cmd       LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
          p_type      LIKE aag_file.aag223,
          l_aaeacti   LIKE aae_file.aaeacti
 
  LET g_errno = ' '
    SELECT aaeacti INTO l_aaeacti FROM aae_file 
     WHERE aae01 = p_type      
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
         WHEN l_aaeacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
END FUNCTION
