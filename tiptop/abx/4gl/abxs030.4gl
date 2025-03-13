# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abxs030.4gl
# Descriptions...: 參數設定
# Date & Author..: 97/08/14 BY connie
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-660052 05/06/14 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_bnz_t       RECORD LIKE bnz_file.*   # 預留參數檔
DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-680062 smallint
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL    
 
DEFINE   g_bnz           RECORD LIKE bnz_file.*   
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   CALL s030(0 ,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN  
 
FUNCTION s030(p_row,p_col)
    DEFINE
        p_row,p_col LIKE type_file.num5          #No.FUN-680062 smallint
#       l_time      LIKE type_file.chr8          #No.FUN-6A0062
 
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW s030_w AT p_row,p_col WITH FORM "abx/42f/abxs030" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL s030_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL s030_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s030_w
END FUNCTION
 
FUNCTION s030_show()
    SELECT * INTO g_bnz.*
             FROM bnz_file WHERE bnz00 = '0'
        IF SQLCA.sqlcode THEN
            INSERT INTO bnz_file(bnz00,bnz01,bnz02,bnz03,bnz04)  #No.MOD-470041
                VALUES('0',' ',' ',' ',' ')
            IF SQLCA.sqlcode THEN
#              CALL cl_err('',SQLCA.sqlcode,0)   #NO.FUN-660052
               CALL cl_err3("ins","bnz_file","","",SQLCA.sqlcode,"","",0) 
               RETURN
            END IF
        ELSE
           UPDATE bnz_file SET * = g_bnz.* 
            WHERE bnz00 = '0'
           IF SQLCA.sqlcode THEN
#             CALL cl_err('',SQLCA.sqlcode,0)   #NO.FUN-660052
              CALL cl_err3("upd","bnz_file","","",SQLCA.sqlcode,"","",0) 
              RETURN
           END IF
        END IF
#No.FUN-660052 --Begin
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)
#          RETURN
#       END IF
#No.FUN-660052 --End
    DISPLAY BY NAME g_bnz.bnz01,g_bnz.bnz02,g_bnz.bnz03,g_bnz.bnz04
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s030_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice = "modify"
       IF cl_chk_act_auth() THEN 
          CALL s030_u()
        END IF 
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#      EXIT MENU
    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU
    ON ACTION CONTROLG
       CALL cl_cmdask()
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
       LET g_action_choice = "exit"
       CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s030_u()
    CALL cl_opmsg('u')
    #檢查是否有更改的權限
    MESSAGE ""
 
    LET g_forupd_sql = "SELECT * FROM bnz_file WHERE bnz00 = '0' FOR UPDATE"    
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE bnz_curl CURSOR FROM g_forupd_sql 
 
    BEGIN WORK
    OPEN bnz_curl
    IF STATUS  THEN CALL cl_err('OPEN bnz_curl',STATUS,1) RETURN END IF         
    FETCH bnz_curl INTO g_bnz.*
    IF STATUS  THEN CALL cl_err('',STATUS,0) RETURN END IF
    IF SQLCA.sqlcode  THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END If
    LET g_bnz_t.* = g_bnz.*
    DISPLAY BY NAME g_bnz.bnz01,g_bnz.bnz02,g_bnz.bnz03,g_bnz.bnz04
                    
    WHILE TRUE
        CALL s030_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           LET g_bnz.* = g_bnz_t.*
           CALL s030_show()
           EXIT WHILE
        END IF
        UPDATE bnz_file SET * = g_bnz.*
            WHERE bnz00='0'
        IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660052
           CALL cl_err3("upd","bnz_file","","",SQLCA.sqlcode,"","",0) 
           CONTINUE WHILE
        END IF
        CLOSE bnz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s030_i()
   DEFINE   l_aza   LIKE type_file.chr1,         #No.FUN-680062  VARCHAR(1)    
            l_cmd   LIKE type_file.chr50         #No.FUN-680062  VARCHAR(50)
 
 
   INPUT BY NAME g_bnz.bnz01,g_bnz.bnz02,g_bnz.bnz03,g_bnz.bnz04 WITHOUT DEFAULTS 
 
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
