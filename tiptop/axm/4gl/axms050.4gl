# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axms050.4gl
# Descriptions...: 銷售系統參數(五)設定作業–訂單控制
# Date & Author..: 95/02/24 By Danny
# Modify.........: No.8222 03/09/16 Kammy 多角貿易參數移到 axms070
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........; NO.FUN-670007 06/07/26 BY yiting 1.oaz32->oax01,oaz07->oax02,oaz08->oax03
#	                                            2.沒有判斷是否該INSERT
# Modify.........: No.FUN-680137 06/09/11 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-960213 10/11/09 By sabrina _u()段中按放棄時並沒有做COMMIT WORK或ROLLBACK WORK導致沒有CLOSE TRANSACTION 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50039 11/07/07 By xianghui 增加自訂欄位
 
DATABASE ds 
 
GLOBALS "../../config/top.global"
    DEFINE
        g_oaz_t         RECORD LIKE oaz_file.*,  # 預留參數檔
        g_oaz_o         RECORD LIKE oaz_file.*   # 預留參數檔
 
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql    STRING
DEFINE g_cnt           LIKE type_file.num5   #No.FUN-680137 SMALLINT   #NO.FUN-670007
 
MAIN
#    DEFINE l_time      LIKE type_file.chr8    #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
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
 
 
#   LET g_oaz.oaz00='0' INSERT INTO oaz_file VALUES(g_oaz.*)
#   CALL cl_user()

    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
    LET p_row = 2 LET p_col = 6
 
    OPEN WINDOW s050_w AT p_row,p_col WITH FORM "axm/42f/axms050" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    CALL s050_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL s050_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s050_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION s050_show()
    LET g_oaz_t.* = g_oaz.*
    LET g_oaz_o.* = g_oaz.*
    DISPLAY BY NAME g_oaz.oaz41,g_oaz.oaz43,
                    g_oaz.oaz44,g_oaz.oaz46,g_oaz.oaz201,
                    g_oaz.oaz681,g_oaz.oaz682,
                    g_oaz.oaz52,g_oaz.oaz70,g_oaz.oaz25,
                    g_oaz.oaz184,g_oaz.oaz185,                #no.7150
                    g_oaz.oazud01,g_oaz.oazud02,g_oaz.oazud03,g_oaz.oazud04,g_oaz.oazud05,   #FUN-B50039
                    g_oaz.oazud06,g_oaz.oazud07,g_oaz.oazud08,g_oaz.oazud09,g_oaz.oazud10,   #FUN-B50039
                    g_oaz.oazud11,g_oaz.oazud12,g_oaz.oazud13,g_oaz.oazud14,g_oaz.oazud15    #FUN-B50039
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s050_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
          CALL s050_u()
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
 
 
FUNCTIOn s050_u()
    IF s_axmshut(0) THEN RETURN END IF
    CALL cl_opmsg('u')
    MESSAGE ""
 
#NO.FUN-670007 start--
    SELECT COUNT(*) INTO g_cnt FROM oaz_file
     WHERE oaz00 = '0'
    IF g_cnt = 0 THEN
       LET g_oaz.oaz00 = '0'
       INSERT INTO oaz_file VALUES(g_oaz.*)
    END IF
#NO.FUN-670007 end----
 
    LET g_forupd_sql = " SELECT * FROM oaz_file WHERE oaz00 = ? ",
                          " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE oaz_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN oaz_curl USING '0'
    IF STATUS THEN
       CALL cl_err('',STATUS,1)
       ROLLBACK WORK         #TQC-960213 add
       RETURN
    END IF
 
    FETCH oaz_curl INTO g_oaz.*
    IF STATUS THEN
       CALL cl_err('',STATUS,1)
       ROLLBACK WORK         #TQC-960213 add
       RETURN
    END IF
 
#NO.FUN-670007 start**
    LET g_forupd_sql = " SELECT * FROM oax_file  WHERE oax00 = ? ",
                          " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE oax_curl CURSOR FROM g_forupd_sql
 
    OPEN oax_curl USING '0'
    IF STATUS THEN
       CALL cl_err3("sel","oax_file","","",STATUS,"","",0)
       ROLLBACK WORK         #TQC-960213 add
       RETURN
    END IF
 
    FETCH oax_curl INTO g_oax.*
    IF STATUS THEN
       CALL cl_err3("sel","oax_file","","",STATUS,"","",0)
       ROLLBACK WORK         #TQC-960213 add
       RETURN
    END IF
#NO.FUN-670007 end---
 
    WHILE TRUE
        CALL s050_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_oaz.* = g_oaz_t.* CALL s050_show()
           ROLLBACK WORK         #TQC-960213 add
           EXIT WHILE
        END IF
        UPDATE oaz_file SET * = g_oaz.* WHERE oaz00='0'
        #NO.FUN-670007 start--
        UPDATE oax_file SET oax01 = g_oax.oax01,
                            oax02 = g_oax.oax02,
                            oax03 = g_oax.oax03
                      WHERE oax00 = '0'
        #NO.FUN-670007 end----
        IF STATUS THEN 
        #  CALL cl_err('',STATUS,0)   #No.FUN-660167
           CALL cl_err3("upd","oaz_file","","",SQLCA.sqlcode,"","",0)    #No.FUN-660167
           CONTINUE WHILE 
        END IF
        CLOSE oaz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s050_i()
    DEFINE l_aza LIKE type_file.chr1   #No.FUN-680137 VARCHAR(01)
    
    INPUT BY NAME g_oaz.oaz41 ,g_oaz.oaz46,g_oaz.oaz44,
                  g_oaz.oaz681,g_oaz.oaz682, g_oaz.oaz25 ,g_oaz.oaz201,
                  #g_oaz.oaz08 ,g_oaz.oaz184,g_oaz.oaz185,
                  g_oax.oax03 ,g_oaz.oaz184,g_oaz.oaz185        ,   #NO.FUN-670007
                  #g_oaz.oaz52 ,g_oaz.oaz70,g_oaz.oaz07,g_oaz.oaz32
                  g_oaz.oaz52 ,g_oaz.oaz70,g_oax.oax02,g_oax.oax01, #NO.FUN-670007
                  g_oaz.oazud01,g_oaz.oazud02,g_oaz.oazud03,g_oaz.oazud04,g_oaz.oazud05,   #FUN-B50039
                  g_oaz.oazud06,g_oaz.oazud07,g_oaz.oazud08,g_oaz.oazud09,g_oaz.oazud10,   #FUN-B50039
                  g_oaz.oazud11,g_oaz.oazud12,g_oaz.oazud13,g_oaz.oazud14,g_oaz.oazud15    #FUN-B50039
        WITHOUT DEFAULTS 
 
    AFTER FIELD oaz41
       IF cl_null(g_oaz.oaz41) THEN
          LET g_oaz.oaz41=g_oaz_o.oaz41
          DISPLAY BY NAME g_oaz.oaz41
          NEXT FIELD oaz41
       END IF
       LET g_oaz_o.oaz41=g_oaz.oaz41
 
{
    AFTER FIELD oaz43
       IF g_oaz.oaz43 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz43) THEN
          LET g_oaz.oaz43=g_oaz_o.oaz43
          DISPLAY BY NAME g_oaz.oaz43
          NEXT FIELD oaz43
       END IF
       LET g_oaz_o.oaz43=g_oaz.oaz43
}
 
    AFTER FIELD oaz44
       IF g_oaz.oaz44 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz44) THEN
          LET g_oaz.oaz44=g_oaz_o.oaz44
          DISPLAY BY NAME g_oaz.oaz44
          NEXT FIELD oaz44
       END IF
       LET g_oaz_o.oaz44=g_oaz.oaz44
 
    AFTER FIELD oaz46
       IF g_oaz.oaz46 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz46) THEN
          LET g_oaz.oaz46=g_oaz_o.oaz46
          DISPLAY BY NAME g_oaz.oaz46
          NEXT FIELD oaz46
       END IF
       LET g_oaz_o.oaz46=g_oaz.oaz46
 
    AFTER FIELD oaz681
       IF cl_null(g_oaz.oaz681) THEN
          LET g_oaz.oaz681=g_oaz_o.oaz681
          DISPLAY BY NAME g_oaz.oaz681
          NEXT FIELD oaz681
       END IF
       LET g_oaz_o.oaz681=g_oaz.oaz681
 
    AFTER FIELD oaz682
       IF cl_null(g_oaz.oaz682) THEN
          LET g_oaz.oaz682=g_oaz_o.oaz682
          DISPLAY BY NAME g_oaz.oaz682
          NEXT FIELD oaz682
       END IF
       LET g_oaz_o.oaz682=g_oaz.oaz682
 
    AFTER FIELD oaz52
       IF g_oaz.oaz52 NOT MATCHES "[BSCD]" OR cl_null(g_oaz.oaz52) THEN
          LET g_oaz.oaz52=g_oaz_o.oaz52
          DISPLAY BY NAME g_oaz.oaz52
          NEXT FIELD oaz52
       END IF
       LET g_oaz_o.oaz52=g_oaz.oaz52
 
    AFTER FIELD oaz70
       IF g_oaz.oaz70 NOT MATCHES "[BSCD]" OR cl_null(g_oaz.oaz70) THEN
          LET g_oaz.oaz70=g_oaz_o.oaz70
          DISPLAY BY NAME g_oaz.oaz70
          NEXT FIELD oaz70
       END IF
       LET g_oaz_o.oaz70=g_oaz.oaz70
 
    #no.7150
    AFTER FIELD oaz184
       IF g_oaz.oaz184 NOT MATCHES '[RWN]' OR cl_null(g_oaz.oaz184) THEN
          LET g_oaz.oaz184=g_oaz_o.oaz184
          DISPLAY BY NAME g_oaz.oaz184
          NEXT FIELD oaz184
       END IF
       LET g_oaz_o.oaz184=g_oaz.oaz184
 
    AFTER FIELD oaz185
       IF cl_null(g_oaz.oaz185) THEN LET g_oaz.oaz185 = 0 END IF
       IF g_oaz.oaz185 < 0 OR cl_null(g_oaz.oaz185) THEN
          LET g_oaz.oaz185=g_oaz_o.oaz185
          DISPLAY BY NAME g_oaz.oaz185
          NEXT FIELD oaz185
       END IF
       LET g_oaz_o.oaz185=g_oaz.oaz185
 
    #no.7150(end)
 
    AFTER FIELD oaz25
       IF g_oaz.oaz25>99 OR g_oaz.oaz25<1 THEN NEXT FIELD oaz25 END IF

    #FUN-B50039-add-str-- 
    AFTER FIELD oazud01
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud02
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud03
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud04
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud05
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud06
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud07
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud08
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud09
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud10
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud11
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud12
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud13
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud14
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oazud15
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
