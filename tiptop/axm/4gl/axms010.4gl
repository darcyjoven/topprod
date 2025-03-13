# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axms010.4gl
# Descriptions...: 銷售系統參數(一)設定作業–連線參數
# Date & Author..: 94/12/12 By Nick
# Modify.........: 95/02/24 By Danny
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6B0027 07/02/14 By jamie oaz101改為nouse 相關程式移除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-960213 10/11/09 By sabrina _u()段中按放棄時並沒有做COMMIT WORK或ROLLBACK WORK導致沒有CLOSE TRANSACTION 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_oaz_t         RECORD LIKE oaz_file.*,  # 預留參數檔
        g_oaz_o         RECORD LIKE oaz_file.*   # 預留參數檔
 
DEFINE g_forupd_sql     STRING
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0094
    DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680137 SMALLINT
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
    LET p_row = 4 LET p_col = 18
 
    OPEN WINDOW s010_w AT p_row,p_col WITH FORM "axm/42f/axms010" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    
    CALL s010_show()
    WHILE TRUE
       LET g_action_choice = ""
       CALL s010_menu()
       IF g_action_choice = "exit" THEN
          EXIT WHILE
       END IF
    END WHILE
    CLOSE WINDOW s010_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION s010_show()
    LET g_oaz_t.* = g_oaz.*
    LET g_oaz_o.* = g_oaz.*
    DISPLAY BY NAME g_oaz.oaz01,g_oaz.oaz02,g_oaz.oaz02p,g_oaz.oaz02b,
                g_oaz.oaz03,g_oaz.oaz04,g_oaz.oaz05 ,g_oaz.oaz06,g_oaz.oaz09,
                g_oaz.oaz102,g_oaz.oaz103,g_oaz.oaz104               #CHI-6B0027 mod
               #g_oaz.oaz101,g_oaz.oaz102,g_oaz.oaz103,g_oaz.oaz104  #CHI-6B0027 mark
                
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s010_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
          CALL s010_u()
       END IF
    ON ACTION reopen 
       LET g_action_choice="reopen"
       IF cl_chk_act_auth() THEN
          CALL s010_y()
       END IF
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       #EXIT MENU
    ON ACTION help 
       CALL cl_show_help()
    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU
    ON ACTION controlg
       CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s010_u()
 
    IF s_axmshut(0) THEN RETURN END IF
    CALL cl_opmsg('u')
    MESSAGE ""
 
    LET g_forupd_sql = "SELECT * FROM oaz_file WHERE oaz00 = ? ",
                         " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE oaz_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
 
    OPEN oaz_curl USING '0'
    IF STATUS THEN
       CALL cl_err('',STATUS,1)
       RETURN
    END IF
 
    FETCH oaz_curl INTO g_oaz.*
    IF STATUS THEN
       CALL cl_err('',STATUS,1)
       RETURN
    END IF
 
    WHILE TRUE
        CALL s010_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_oaz.* = g_oaz_t.* CALL s010_show()
           ROLLBACK WORK         #TQC-960213 add
           EXIT WHILE
        END IF
        UPDATE oaz_file SET * = g_oaz.* WHERE oaz00='0'
        IF STATUS THEN CALL cl_err('',STATUS,0) CONTINUE WHILE END IF
        CLOSE oaz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s010_i()
    DEFINE l_aza   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
    
    INPUT BY NAME g_oaz.oaz01,g_oaz.oaz02,g_oaz.oaz02p,g_oaz.oaz02b,
              g_oaz.oaz03,g_oaz.oaz04,g_oaz.oaz05,g_oaz.oaz06,
              g_oaz.oaz102,g_oaz.oaz103,g_oaz.oaz104,              #CHI-6B0027 mod
             #g_oaz.oaz101,g_oaz.oaz102,g_oaz.oaz103,g_oaz.oaz104, #CHI-6B0027 mark
              g_oaz.oaz09
        WITHOUT DEFAULTS 
 
    AFTER FIELD oaz01
       IF g_oaz.oaz01 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz01) THEN
          LET g_oaz.oaz01=g_oaz_o.oaz01
          DISPLAY BY NAME g_oaz.oaz01
          NEXT FIELD oaz01
       END IF
       LET g_oaz_o.oaz01=g_oaz.oaz01
 
    AFTER FIELD oaz02
       IF g_oaz.oaz02 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz02) THEN
          LET g_oaz.oaz02=g_oaz_o.oaz02
          DISPLAY BY NAME g_oaz.oaz02
          NEXT FIELD oaz02
       END IF
       LET g_oaz_o.oaz02=g_oaz.oaz02
 
    AFTER FIELD oaz02p
       IF cl_null(g_oaz.oaz02p) THEN
          LET g_oaz.oaz02p=g_oaz_o.oaz02p
          DISPLAY BY NAME g_oaz.oaz02p
          NEXT FIELD oaz02p
       END IF
       LET g_oaz_o.oaz02p=g_oaz.oaz02p
 
    AFTER FIELD oaz02b
       IF cl_null(g_oaz.oaz02b) THEN
          LET g_oaz.oaz02b=g_oaz_o.oaz02b
          DISPLAY BY NAME g_oaz.oaz02b
          NEXT FIELD oaz02b
       END IF
       LET g_oaz_o.oaz02b=g_oaz.oaz02b
 
    AFTER FIELD oaz03
       IF g_oaz.oaz03 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz03) THEN
          LET g_oaz.oaz03=g_oaz_o.oaz03
          DISPLAY BY NAME g_oaz.oaz03
          NEXT FIELD oaz03
       END IF
       LET g_oaz_o.oaz03=g_oaz.oaz03
 
    AFTER FIELD oaz04
       IF g_oaz.oaz04 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz04) THEN
          LET g_oaz.oaz04=g_oaz_o.oaz04
          DISPLAY BY NAME g_oaz.oaz04
          NEXT FIELD oaz04
       END IF
       LET g_oaz_o.oaz04=g_oaz.oaz04
 
    AFTER FIELD oaz05
       IF g_oaz.oaz05 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz05) THEN
          LET g_oaz.oaz05=g_oaz_o.oaz05
          DISPLAY BY NAME g_oaz.oaz05
          NEXT FIELD oaz05
       END IF
       LET g_oaz_o.oaz05=g_oaz.oaz05
 
    AFTER FIELD oaz06
       IF g_oaz.oaz06 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz06) THEN
          LET g_oaz.oaz06=g_oaz_o.oaz06
          DISPLAY BY NAME g_oaz.oaz06
          NEXT FIELD oaz06
       END IF
       LET g_oaz_o.oaz06=g_oaz.oaz06
 
    AFTER FIELD oaz09
       IF cl_null(g_oaz.oaz09) THEN
          LET g_oaz.oaz09=g_today
          DISPLAY BY NAME g_oaz.oaz09
          NEXT FIELD oaz09
       END IF
       LET g_oaz_o.oaz09=g_oaz.oaz09
 
   #CHI-6B0027---mark---str---
   #AFTER FIELD oaz101
   #   IF g_oaz.oaz101 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz101) THEN
   #      LET g_oaz.oaz101=g_oaz_o.oaz101
   #      DISPLAY BY NAME g_oaz.oaz101
   #      NEXT FIELD oaz101
   #   END IF
   #   LET g_oaz_o.oaz101=g_oaz.oaz101
   #CHI-6B0027---mark---str---
 
    AFTER FIELD oaz102
       IF g_oaz.oaz102 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz102) THEN
          LET g_oaz.oaz102=g_oaz_o.oaz102
          DISPLAY BY NAME g_oaz.oaz102
          NEXT FIELD oaz102
       END IF
       LET g_oaz_o.oaz102=g_oaz.oaz102
 
    AFTER FIELD oaz103
       IF g_oaz.oaz103 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz103) THEN
          LET g_oaz.oaz103=g_oaz_o.oaz103
          DISPLAY BY NAME g_oaz.oaz103
          NEXT FIELD oaz103
       END IF
       LET g_oaz_o.oaz103=g_oaz.oaz103
 
    AFTER FIELD oaz104
       IF g_oaz.oaz104 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz104) THEN
          LET g_oaz.oaz104=g_oaz_o.oaz104
          DISPLAY BY NAME g_oaz.oaz104
          NEXT FIELD oaz104
       END IF
       LET g_oaz_o.oaz104=g_oaz.oaz104
 
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
 
#--->NO:3044
FUNCTION s010_y()
 DEFINE   l_oaz01  LIKE type_file.chr1        # No.FUN-680137 VARCHAR(01)
     SELECT oaz01 INTO l_oaz01 FROM oaz_file WHERE oaz00='0'
     IF l_oaz01 = 'Y' THEN RETURN END IF
     UPDATE oaz_file SET oaz01='Y' WHERE oaz00='0'
     IF STATUS THEN 
        LET g_oaz.oaz01='N'
#       CALL cl_err('upd oaz01:',STATUS,0)   #No.FUN-660167
        CALL cl_err3("upd","oaz_file","","",STATUS,"","upd oaz01",0)   #No.FUN-660167
     ELSE
        LET g_oaz.oaz01='Y'
     END IF
     DISPLAY BY NAME g_oaz.oaz01 
END FUNCTION
