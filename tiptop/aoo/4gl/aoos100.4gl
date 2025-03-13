# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aoos100.4gl
# Descriptions...: 系統 UI 參數設定
# Date & Author..: 2004/03/10 By hjwang
# Modify.........: NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
# Modify.........: No.FUN-B50039 11/07/06 By fengrui 增加自定義欄位

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_gas_t     RECORD LIKE gas_file.*,
        g_gas01_t   LIKE gas_file.gas01,
        g_gas02_t   LIKE gas_file.gas02,
        g_gas03_t   LIKE gas_file.gas03,
        g_gas04_t   LIKE gas_file.gas04
DEFINE  g_forupd_sql STRING  
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8             #No.FUN-6A0081
    DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
    OPTIONS
       INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   #檢查是否有更改的權限
   LET g_action_choice = 'modify'
   IF NOT cl_chk_act_auth() THEN EXIT PROGRAM END IF   #無更改權限
 
   LET p_row = 4 LET p_col = 2
   OPEN WINDOW s100_w AT p_row,p_col WITH FORM "aoo/42f/aoos100" 
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL s100_show()
 
   #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL s100_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
   #END WHILE    ####040512
 
   CLOSE WINDOW s100_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION s100_show()
 
    SELECT * INTO g_gas.* FROM gas_file
    IF SQLCA.sqlcode OR g_gas.gas01 IS NULL THEN
        IF SQLCA.sqlcode=-284 THEN
#           CALL cl_err("GAS_FILE fail,Restart!","!",1)   #No.FUN-660131
            CALL cl_err3("sel","gas_file",g_gas.gas01,"",SQLCA.sqlcode,"","GAS_FILE fail,Restart!",1)   #No.FUN-660131
            DELETE FROM gas_file WHERE 1=1
        END IF
 
        LET g_gas.gas01 = "0"          # KEY值
        LET g_gas.gas02 = "red"        # NOT NULL,REQUIRED (red)
        LET g_gas.gas03 = "red"        # KEY VALUE in FILE (yellow)
        LET g_gas.gas04 = "yellow"     # KEY VALUE in FILE (yellow)
 
        INSERT INTO gas_file VALUES (g_gas.*)
        IF SQLCA.sqlcode THEN
#          CALL cl_err('INSERT GAS_FILE',SQLCA.sqlcode,1)   #No.FUN-660131
           CALL cl_err3("ins","gas_file",g_gas.gas01,"",SQLCA.sqlcode,"","INSERT GAS_FILE",1)    #No.FUN-660131
            RETURN
        END IF
    END IF
 
    DISPLAY BY NAME g_gas.gas02,g_gas.gas03,g_gas.gas04,
                    #FUN-B50039-add-str--
                    g_gas.gasud01,g_gas.gasud02,g_gas.gasud03,
                    g_gas.gasud04,g_gas.gasud05,g_gas.gasud06,
                    g_gas.gasud07,g_gas.gasud08,g_gas.gasud09,
                    g_gas.gasud10,g_gas.gasud11,g_gas.gasud12,
                    g_gas.gasud13,g_gas.gasud14,g_gas.gasud15
                    #FUN-B50039-add-end--
		 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s100_menu()
 
  MENU ""
    ON ACTION modify 
#NO.FUN-5B0134
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
           CALL s100_u()
       END IF
#NO.FUN-5B0134
    ON ACTION help 
       CALL cl_show_help()
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#      EXIT MENU
    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       LET g_action_choice = "exit"
       CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s100_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gas01_t = g_gas.gas01
    LET g_gas02_t = g_gas.gas02
    LET g_gas03_t = g_gas.gas03
    LET g_gas04_t = g_gas.gas04
 
    LET g_forupd_sql = "SELECT * FROM gas_file FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE gas_cl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN gas_cl
    IF STATUS  THEN CALL cl_err('OPEN gas_curl',STATUS,1) RETURN END IF
    FETCH gas_cl INTO g_gas.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_gas_t.*=g_gas.*
 
    DISPLAY BY NAME g_gas.gas02,g_gas.gas03,g_gas.gas04,
                    #FUN-B50039-add-str--
                    g_gas.gasud01,g_gas.gasud02,g_gas.gasud03,
                    g_gas.gasud04,g_gas.gasud05,g_gas.gasud06,
                    g_gas.gasud07,g_gas.gasud08,g_gas.gasud09,
                    g_gas.gasud10,g_gas.gasud11,g_gas.gasud12,
                    g_gas.gasud13,g_gas.gasud14,g_gas.gasud15
                    #FUN-B50039-add-end--
    WHILE TRUE
        CALL s100_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE gas_file
           SET gas_file.*=g_gas.*
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","gas_file",g_gas.gas01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE gas_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s100_i()
 
   INPUT BY NAME g_gas.gas02,g_gas.gas03,g_gas.gas04,
                 #FUN-B50039-add-str--
                 g_gas.gasud01,g_gas.gasud02,g_gas.gasud03,
                 g_gas.gasud04,g_gas.gasud05,g_gas.gasud06,
                 g_gas.gasud07,g_gas.gasud08,g_gas.gasud09,
                 g_gas.gasud10,g_gas.gasud11,g_gas.gasud12,
                 g_gas.gasud13,g_gas.gasud14,g_gas.gasud15
                 #FUN-B50039-add-end--
                 WITHOUT DEFAULTS 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gas02)
               CALL s_color(g_gas.gas02) RETURNING g_gas.gas02
               DISPLAY g_gas.gas02 TO gas02
               NEXT FIELD gas02
 
            WHEN INFIELD(gas03)
               CALL s_color(g_gas.gas03) RETURNING g_gas.gas03
               DISPLAY g_gas.gas03 TO gas03
               NEXT FIELD gas03
 
            WHEN INFIELD(gas04)
               CALL s_color(g_gas.gas04) RETURNING g_gas.gas04
               DISPLAY g_gas.gas04 TO gas04
               NEXT FIELD gas04
         END CASE
      #FUN-B50039-add-str--
      AFTER FIELD gasud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD gasud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--
 
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
 
