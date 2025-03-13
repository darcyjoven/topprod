# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abxs020.4gl
# Descriptions...: 保稅系統參數設定作業–連線參數
# Date & Author..: 95/07/12 By Roger
# Modify.........: MOD-550117 05/05/17 By Smapmin 無法進行"更改"動作
# Modify.........: No.FUN-660052 05/06/14 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/10/30 By kim GP3.5 台虹保稅客製功能回收修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_bxz_t         RECORD LIKE bxz_file.*,  # 預留參數檔
        g_bxz_o         RECORD LIKE bxz_file.*,  # 預留參數檔
        g_bxr02         LIKE bxr_file.bxr02      #FUN-6A0007
DEFINE p_row,p_col     LIKE type_file.num5       #No.FUN-680062 smallint
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL     
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0062
    DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680062 smallint
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
 
 
    LET p_row = 3 LET p_col = 8
    OPEN WINDOW s020_w AT  p_row,p_col WITH FORM "abx/42f/abxs020" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL s020_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL s020_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s020_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION s020_show()
    LET g_bxz_t.* = g_bxz.*
    LET g_bxz_o.* = g_bxz.*
   #FUN-6A0007...............begin
   #DISPLAY BY NAME g_bxz.bxz01,g_bxz.bxz05,
    DISPLAY BY NAME g_bxz.bxz01,g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102,
                    g_bxz.bxz103,g_bxz.bxz05,
   #FUN-6A0007...............end
                    g_bxz.bxz06,g_bxz.bxz07,g_bxz.bxz08,g_bxz.bxz09,
                    g_bxz.bxz11,g_bxz.bxz12,g_bxz.bxz13,g_bxz.bxz14,
                    g_bxz.bxz25,g_bxz.bxz26,
                    g_bxz.bxz104,g_bxz.bxz105   #FUN-6A0007
    CALL s020_bxz103()      #FUN-6A0007
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s020_menu()
  MENU ""
    ON ACTION modify 
       LET g_action_choice="modify" 
       IF cl_chk_act_auth() THEN 
          CALL s020_u()
       END IF  
    ON ACTION reset 
       LET g_action_choice="reset" 
       IF cl_chk_act_auth() THEN
          CALL s020_y()
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
 
 
FUNCTION s020_u()
    MESSAGE ""
    CALL cl_opmsg('u')
 
     #LET g_forupd_sql = "SELECT * FROM bxz_file WHERE bxz00 = '0' FOR UPDATE "    #MOD-550117 
     LET g_forupd_sql = "SELECT * FROM bxz_file WHERE bxz00 = '0' FOR UPDATE "    #MOD-550117 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE bxz_curl CURSOR FROM g_forupd_sql  
 
    BEGIN WORK
    OPEN bxz_curl 
    IF STATUS  THEN CALL cl_err('OPEN bxz_curl',STATUS,1) RETURN END IF         
    FETCH bxz_curl INTO g_bxz.*
    IF STATUS  THEN CALL cl_err('',STATUS,0) RETURN END IF 
    CALL s020_show()   #FUN-6A0007
    WHILE TRUE
        CALL s020_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_bxz.* = g_bxz_t.* 
           CALL s020_show()
           EXIT WHILE
        END IF
        UPDATE bxz_file SET * = g_bxz.* WHERE bxz00='0'
        IF STATUS THEN 
#          CALL cl_err('',STATUS,0) #No.FUN-660052
           CALL cl_err3("upd","bxz_file","","",STATUS,"","",0) 
           CONTINUE WHILE 
        END IF
        CLOSE bxz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s020_i()
   DEFINE l_aza LIKE type_file.chr1           #No.FUN-680062      VARCHAR(1) 
   
  #FUN-6A0007...............begin
  #INPUT BY NAME g_bxz.bxz01,g_bxz.bxz05,
   INPUT BY NAME g_bxz.bxz01,g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102,
                 g_bxz.bxz103,g_bxz.bxz05,
  #FUN-6A0007...............end
                 g_bxz.bxz06,g_bxz.bxz07,g_bxz.bxz08,g_bxz.bxz09,
                 g_bxz.bxz11,g_bxz.bxz12,g_bxz.bxz13,g_bxz.bxz14,
                 g_bxz.bxz25,g_bxz.bxz26,
                 g_bxz.bxz104,g_bxz.bxz105   #FUN-6A0007
      WITHOUT DEFAULTS
      
      AFTER FIELD bxz01
         IF g_bxz.bxz01 NOT MATCHES '[YN]' THEN
            LET g_bxz.bxz01=g_bxz_o.bxz01
            DISPLAY BY NAME g_bxz.bxz01
            NEXT FIELD bxz01
         END IF
         LET g_bxz_o.bxz01=g_bxz.bxz01
 
      #FUN-6A0007...............begin
      AFTER FIELD bxz103
         IF NOT cl_null(g_bxz.bxz103) THEN
            CALL s020_bxz103() 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_bxz.bxz103,g_errno,0)
               NEXT FIELD bxz103
            END IF
         ELSE
            LET g_bxr02 = NULL
            DISPLAY g_bxr02 TO FORMONLY.reason
         END IF
      #FUN-6A0007...............end
 
      AFTER FIELD bxz08
         IF g_bxz.bxz07 > g_bxz.bxz08 THEN 
            CALL cl_err('','aap-100',0) 
            NEXT FIELD bxz07
         END IF
 
      #FUN-6A0007...............begin
      ON ACTION CONTROLP
         IF INFIELD(bxz103) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_bxr"
            LET g_qryparam.default1 = g_bxz.bxz103
            CALL cl_create_qry() RETURNING g_bxz.bxz103
            CALL s020_bxz103() 
            DISPLAY BY NAME g_bxz.bxz103
         END IF
      #FUN-6A0007...............end
 
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
 
FUNCTION s020_y()
 DEFINE   l_bxz01  LIKE bxz_file.bxz01         #No.FUN-680062  VARCHAR(1)    
     SELECT bxz01 INTO l_bxz01 FROM bxz_file WHERE bxz00='0'
     IF l_bxz01 = 'Y' THEN RETURN END IF
     UPDATE bxz_file SET bxz01='Y' WHERE bxz00='0'
     IF STATUS THEN
        LET g_bxz.bxz01='N'
#       CALL cl_err('upd bxz01:',STATUS,0)   #No.FUN-660052
        CALL cl_err3("upd","bxz_file","","",STATUS,"","upd bxz01:",0)
     ELSE
        LET g_bxz.bxz01='Y'
     END IF
     DISPLAY BY NAME g_bxz.bxz01
END FUNCTION
 
#FUN-6A0007...............begin
FUNCTION s020_bxz103()
 
   LET g_errno = ' '
   SELECT bxr02 INTO g_bxr02 FROM bxr_file
      WHERE bxr01 = g_bxz.bxz103
 
   IF SQLCA.SQLCODE THEN
      LET g_errno = 'abx-056'
      LET g_bxr02 = NULL
   END IF
 
   DISPLAY g_bxr02 TO FORMONLY.reason
 
END FUNCTION
#FUN-6A0007...............end
