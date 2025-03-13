# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axms020.4gl
# Descriptions...: 銷售系統參數(二)設定作業信用控制
# Date & Author..: 94/12/12 By Nick
# Modify.........: 95/02/24 By Danny
# Modify.........: No.+047 by linda 增加參數oaz211,oaz212
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
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
   LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW s020_w AT p_row,p_col WITH FORM "axm/42f/axms020" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    CALL s020_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL s020_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s020_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION s020_show()
    LET g_oaz_t.* = g_oaz.*
    LET g_oaz_o.* = g_oaz.*
    DISPLAY BY NAME g_oaz.oaz11,g_oaz.oaz121,g_oaz.oaz122,g_oaz.oaz131,
                    g_oaz.oaz132,g_oaz.oaz141,g_oaz.oaz142,
                    g_oaz.oaz211,g_oaz.oaz212 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s020_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
          CALL s020_u()
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
 
 
FUNCTION s020_u()
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
       RETURN
    END IF
 
    FETCH oaz_curl INTO g_oaz.*
    IF STATUS THEN
       CALL cl_err('',STATUS,1)
       RETURN
    END IF
 
    WHILE TRUE
        CALL s020_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_oaz.* = g_oaz_t.* CALL s020_show()
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
 
FUNCTION s020_i()
    DEFINE l_aza LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
    
    INPUT BY NAME g_oaz.oaz11,g_oaz.oaz121,g_oaz.oaz122,g_oaz.oaz131,
                  g_oaz.oaz132,g_oaz.oaz141,g_oaz.oaz142,
                  g_oaz.oaz211,g_oaz.oaz212 
        WITHOUT DEFAULTS 
 
    AFTER FIELD oaz11
       IF cl_null(g_oaz.oaz11) THEN
          LET g_oaz.oaz11=g_oaz_o.oaz11
          DISPLAY BY NAME g_oaz.oaz11
          NEXT FIELD oaz11
       ELSE
          SELECT oak02 FROM oak_file WHERE oak01=g_oaz.oaz11 AND oak03='1'
          IF STATUS THEN
#              CALL cl_err(g_oaz.oaz11,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("sel","oak_file",g_oaz.oaz11,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
               LET g_oaz.oaz11=g_oaz_o.oaz11
               DISPLAY BY NAME g_oaz.oaz11
               NEXT FIELD oaz11
          END IF
       END IF
       LET g_oaz_o.oaz11=g_oaz.oaz11
 
    AFTER FIELD oaz121
       IF g_oaz.oaz121 NOT MATCHES '[0-1]' OR cl_null(g_oaz.oaz121) THEN
          LET g_oaz.oaz121=g_oaz_o.oaz121
          DISPLAY BY NAME g_oaz.oaz121
          NEXT FIELD oaz121
       END IF
       LET g_oaz_o.oaz121=g_oaz.oaz121
 
    AFTER FIELD oaz122
       IF g_oaz.oaz122 NOT MATCHES '[0-2]' OR cl_null(g_oaz.oaz122) THEN
          LET g_oaz.oaz122=g_oaz_o.oaz122
          DISPLAY BY NAME g_oaz.oaz122
          NEXT FIELD oaz122
       END IF
       LET g_oaz_o.oaz122=g_oaz.oaz122
 
    AFTER FIELD oaz131
       IF g_oaz.oaz131 NOT MATCHES '[0-1]' OR cl_null(g_oaz.oaz131) THEN
          LET g_oaz.oaz131=g_oaz_o.oaz131
          DISPLAY BY NAME g_oaz.oaz131
          NEXT FIELD oaz131
       END IF
       LET g_oaz_o.oaz131=g_oaz.oaz131
 
    AFTER FIELD oaz132
       IF g_oaz.oaz132 NOT MATCHES '[012]' OR cl_null(g_oaz.oaz132) THEN
          LET g_oaz.oaz132=g_oaz_o.oaz132
          DISPLAY BY NAME g_oaz.oaz132
          NEXT FIELD oaz132
       END IF
       LET g_oaz_o.oaz132=g_oaz.oaz132
 
    AFTER FIELD oaz141
       IF g_oaz.oaz141 NOT MATCHES '[0-1]' OR cl_null(g_oaz.oaz141) THEN
          LET g_oaz.oaz141=g_oaz_o.oaz141
          DISPLAY BY NAME g_oaz.oaz141
          NEXT FIELD oaz141
       END IF
       LET g_oaz_o.oaz141=g_oaz.oaz141
 
    AFTER FIELD oaz142
       IF g_oaz.oaz142 NOT MATCHES '[012]' OR cl_null(g_oaz.oaz142) THEN
          LET g_oaz.oaz142=g_oaz_o.oaz142
          DISPLAY BY NAME g_oaz.oaz142
          NEXT FIELD oaz142
       END IF
       LET g_oaz_o.oaz142=g_oaz.oaz142
 
    AFTER FIELD oaz211
       IF g_oaz.oaz211 NOT MATCHES '[12]' OR cl_null(g_oaz.oaz211) THEN
          LET g_oaz.oaz211=g_oaz_o.oaz211
          DISPLAY BY NAME g_oaz.oaz211
          NEXT FIELD oaz211
       END IF
       LET g_oaz_o.oaz211=g_oaz.oaz211
 
    AFTER FIELD oaz212
       IF g_oaz.oaz212 NOT MATCHES '[BSMPCD]' OR cl_null(g_oaz.oaz212) THEN
          LET g_oaz.oaz212=g_oaz_o.oaz212
          DISPLAY BY NAME g_oaz.oaz212
          NEXT FIELD oaz212
       END IF
       LET g_oaz_o.oaz212=g_oaz.oaz212
 
    ON ACTION CONTROLP
       CASE
            WHEN INFIELD(oaz11)                       #No:7909
#                CALL q_oak1(10,3,g_oaz.oaz11,'1') RETURNING g_oaz.oaz11 
#                CALL FGL_DIALOG_SETBUFFER( g_oaz.oaz11 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oak1'
                 LET g_qryparam.default1 = g_oaz.oaz11
                 LET g_qryparam.arg1 ='1'
                 CALL cl_create_qry() RETURNING g_oaz.oaz11
#                 CALL FGL_DIALOG_SETBUFFER( g_oaz.oaz11 )
                 DISPLAY BY NAME g_oaz.oaz11 
                 NEXT FIELD oaz11 
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
