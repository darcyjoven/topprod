# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axms060.4gl
# Descriptions...: 銷售系統參數(六)設定作業–出貨控制
# Date & Author..: 95/02/24 By Danny
# Modify.........: 99/05/10 By Carol -->add oaz67:no use->包裝單之出貨單號來源
# Modify.........: No.7953 03/08/27 Kammy 1.三角貿易正逆拋設定取消
#                                         2.多角貿易參數移到 axms070
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-770159 07/08/02 By claire 當選擇(oaz67)出貨單時,不可選(oaz61)立即扣帳,否則設定需做invoice會無法做確認
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-960213 10/11/09 By sabrina _u()段中按放棄時並沒有做COMMIT WORK或ROLLBACK WORK導致沒有CLOSE TRANSACTION 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_oaz_t         RECORD LIKE oaz_file.*,  # 預留參數檔
        g_oaz_o         RECORD LIKE oaz_file.*   # 預留參數檔
 
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql    STRING
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0094
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
    LET p_row = 1 LET p_col = 10
 
    OPEN WINDOW s060_w AT p_row,p_col WITH FORM "axm/42f/axms060" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    CALL s060_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL s060_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
 
    CLOSE WINDOW s060_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION s060_show()
    LET g_oaz_t.* = g_oaz.*
    LET g_oaz_o.* = g_oaz.*
    DISPLAY BY NAME g_oaz.oaz22,g_oaz.oaz61,g_oaz.oaz62,
                    g_oaz.oaz64,g_oaz.oaz65,g_oaz.oaz66,g_oaz.oaz67,
                    g_oaz.oaz691,g_oaz.oaz692,g_oaz.oaz71
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s060_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
          CALL s060_u()
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
 
 
FUNCTION s060_u()
    IF s_axmshut(0) THEN RETURN END IF
    CALL cl_opmsg('u')
    MESSAGE ""
 
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
 
    WHILE TRUE
        CALL s060_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_oaz.* = g_oaz_t.* CALL s060_show()
           ROLLBACK WORK         #TQC-960213 add
           EXIT WHILE
        END IF
        UPDATE oaz_file SET * = g_oaz.* WHERE oaz00='0'
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
 
FUNCTION s060_i()
    DEFINE l_aza   LIKE type_file.chr1000     # No.FUN-680137 VARCHAR(01)
    
    INPUT BY NAME g_oaz.oaz65,g_oaz.oaz66,g_oaz.oaz71,g_oaz.oaz61,
                  g_oaz.oaz67,g_oaz.oaz22,g_oaz.oaz62,g_oaz.oaz64,
                  g_oaz.oaz691,g_oaz.oaz692
        WITHOUT DEFAULTS 
 
    AFTER FIELD oaz22
       IF g_oaz.oaz22 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz22) THEN
          LET g_oaz.oaz22=g_oaz_o.oaz22
          DISPLAY BY NAME g_oaz.oaz22
          NEXT FIELD oaz22
       END IF
       LET g_oaz_o.oaz22=g_oaz.oaz22
 
    #MOD-770159-begin-modify
    #AFTER FIELD oaz61
     ON CHANGE oaz61
       IF g_oaz.oaz67 = '2' AND g_oaz.oaz61='1' THEN
          CALL cl_err('','axm-070',1)
          NEXT FIELD oaz61
       END IF 
    #MOD-770159-end-modify
       IF g_oaz.oaz61 NOT MATCHES '[1-3]' OR cl_null(g_oaz.oaz61) THEN
          LET g_oaz.oaz61=g_oaz_o.oaz61
          DISPLAY BY NAME g_oaz.oaz61
          NEXT FIELD oaz61
       END IF
       LET g_oaz_o.oaz61=g_oaz.oaz61
 
    AFTER FIELD oaz62
       IF g_oaz.oaz62 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz62) THEN
          LET g_oaz.oaz62=g_oaz_o.oaz62
          DISPLAY BY NAME g_oaz.oaz62
          NEXT FIELD oaz62
       END IF
       LET g_oaz_o.oaz62=g_oaz.oaz62
 
    AFTER FIELD oaz64
       IF g_oaz.oaz64 NOT MATCHES '[YNO]' OR cl_null(g_oaz.oaz64) THEN
          LET g_oaz.oaz64=g_oaz_o.oaz64
          DISPLAY BY NAME g_oaz.oaz64
          NEXT FIELD oaz64
       END IF
       LET g_oaz_o.oaz64=g_oaz.oaz64
 
    AFTER FIELD oaz65
       IF g_oaz.oaz65 NOT MATCHES '[0-1]' OR cl_null(g_oaz.oaz65) THEN
          LET g_oaz.oaz65=g_oaz_o.oaz65
          DISPLAY BY NAME g_oaz.oaz65
          NEXT FIELD oaz65
       END IF
       LET g_oaz_o.oaz65=g_oaz.oaz65
 
    AFTER FIELD oaz66
       IF g_oaz.oaz66 NOT MATCHES '[0-1]' OR cl_null(g_oaz.oaz66) THEN
          LET g_oaz.oaz66=g_oaz_o.oaz66
          DISPLAY BY NAME g_oaz.oaz66
          NEXT FIELD oaz66
       END IF
       LET g_oaz_o.oaz66=g_oaz.oaz66
 
    #MOD-770159-begin-modify
    #AFTER FIELD oaz67
     ON CHANGE oaz67
       IF g_oaz.oaz61 = '1' AND g_oaz.oaz67='2' THEN
          CALL cl_err('','axm-070',1)
          NEXT FIELD oaz67
       END IF 
    #MOD-770159-end-modify
       IF g_oaz.oaz67 NOT MATCHES '[1-2]' OR cl_null(g_oaz.oaz67) THEN
          LET g_oaz.oaz67=g_oaz_o.oaz67
          DISPLAY BY NAME g_oaz.oaz67
          NEXT FIELD oaz67
       END IF
       LET g_oaz_o.oaz67=g_oaz.oaz67
 
    AFTER FIELD oaz691
       IF cl_null(g_oaz.oaz691) THEN
          LET g_oaz.oaz691=g_oaz_o.oaz691
          DISPLAY BY NAME g_oaz.oaz691
          NEXT FIELD oaz691
       END IF
       LET g_oaz_o.oaz691=g_oaz.oaz691
 
    AFTER FIELD oaz692
       IF cl_null(g_oaz.oaz692) THEN
          LET g_oaz.oaz692=g_oaz_o.oaz692
          DISPLAY BY NAME g_oaz.oaz692
          NEXT FIELD oaz692
       END IF
       LET g_oaz_o.oaz692=g_oaz.oaz692
 
    AFTER FIELD oaz71
       IF g_oaz.oaz71 NOT MATCHES '[1-2]' OR cl_null(g_oaz.oaz71) THEN
          LET g_oaz.oaz71=g_oaz_o.oaz71
          DISPLAY BY NAME g_oaz.oaz71
          NEXT FIELD oaz71
       END IF
       LET g_oaz_o.oaz71=g_oaz.oaz71
 
   #MOD-770159-begin-add
    AFTER INPUT 
       IF g_oaz.oaz67 = '2' AND g_oaz.oaz61='1' THEN
          CALL cl_err('','axm-070',1)
          NEXT FIELD oaz61
       END IF 
   #MOD-770159-end-add
 
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
