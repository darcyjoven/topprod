# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asms220.4gl
# Descriptions...: 系統參數設定作業–庫存料件ＡＢＣ
# Date & Author..: 92/12/21 By David 
#                : Rearrange Screen Format and recoding
# Modify.........: NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_sma_o         RECORD LIKE sma_file.*,  # 參數檔
        g_sma_t         RECORD LIKE sma_file.*   # 參數檔
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms220()
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN  
 
FUNCTION asms220()
    DEFINE
        p_row,p_col LIKE type_file.num5     #No.FUN-690010 SMALLINT
#       l_time        LIKE type_file.chr8          #No.FUN-6A0089
 
 
   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.CHI-960043
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET p_row = 5 LET p_col = 25
    ELSE LET p_row = 4 LET p_col = 5
    END IF
    OPEN WINDOW asms220_w AT  p_row,p_col       
        WITH FORM "asm/42f/asms220" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL asms220_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL asms220_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW asms220_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms220_show()
    SELECT *      
        INTO g_sma.*
        FROM sma_file WHERE sma00 = '0'
    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
       CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
    IF g_sma.sma15 IS NULL OR g_sma.sma15 = ' ' THEN
       LET g_sma.sma15=0
    END IF
    IF g_sma.sma16 IS NULL OR g_sma.sma16 = ' ' THEN
       LET g_sma.sma16=0
    END IF
    IF g_sma.sma17 IS NULL OR g_sma.sma17 = ' ' THEN
       LET g_sma.sma17=0
    END IF
    IF g_sma.sma48 IS NULL OR g_sma.sma48 = ' ' THEN
       LET g_sma.sma48=0
    END IF
    DISPLAY BY NAME g_sma.sma47,g_sma.sma49,g_sma.sma13,g_sma.sma14,
					g_sma.sma15,g_sma.sma16,g_sma.sma17,g_sma.sma48
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asms220_menu()
    MENU ""
    ON ACTION modify 
#NO.FUN-5B0134 START--
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
           CALL asms220_u()
       END IF
#NO.FUN-5B0134 END----
    ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #EXIT MENU
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
 
 
FUNCTION asms220_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql =
      "SELECT *  FROM sma_file",
      "  WHERE sma00 = ?       ",
      " FOR UPDATE            "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE sma_curl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN sma_curl USING '0'
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('open cursor',SQLCA.sqlcode,1)
       RETURN
    END IF
    FETCH sma_curl INTO g_sma.*
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_sma_o.* = g_sma.*
    LET g_sma_t.* = g_sma.*
    DISPLAY BY NAME g_sma.sma47,g_sma.sma49,g_sma.sma13,g_sma.sma14,
					g_sma.sma15,g_sma.sma16,g_sma.sma17,g_sma.sma48
                    
    WHILE TRUE
        CALL asms220_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE sma_file SET
                sma47=g_sma.sma47,
                sma49=g_sma.sma49,
                sma13=g_sma.sma13,
                sma14=g_sma.sma14,
                sma15=g_sma.sma15,
                sma16=g_sma.sma16,
                sma17=g_sma.sma17,
		sma48=g_sma.sma48
            WHERE sma00='0'
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        END IF
        UNLOCK TABLE sma_file
        EXIT WHILE
    END WHILE
    CLOSE sma_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION asms220_i()
 
   INPUT BY NAME g_sma.sma47,g_sma.sma49,g_sma.sma13,g_sma.sma14,
       		g_sma.sma15,g_sma.sma16,g_sma.sma17,g_sma.sma48
                WITHOUT DEFAULTS 
 
      AFTER FIELD sma47
         IF NOT cl_null(g_sma.sma47) THEN
             IF g_sma.sma47 NOT MATCHES '[134]'    #No.B250 010328 by linda mod
                THEN
                   LET g_sma.sma47=g_sma_o.sma47
                   DISPLAY BY NAME g_sma.sma47
                   NEXT FIELD sma47
             END IF
             LET g_sma_o.sma47=g_sma.sma47
         END IF
 
      AFTER FIELD sma49
         IF NOT cl_null(g_sma.sma49) THEN
             IF g_sma.sma49 NOT MATCHES '[12]' THEN
                LET g_sma.sma49=g_sma_o.sma49
                DISPLAY BY NAME g_sma.sma49
                NEXT FIELD sma49
             END IF
             LET g_sma_o.sma49=g_sma.sma49
         END IF
 
      BEFORE FIELD sma13
         IF g_sma.sma13 IS NULL OR g_sma.sma13 = ' ' THEN
            LET g_sma.sma13 = 0
            DISPLAY  BY NAME g_sma.sma13
         END IF
 
      AFTER FIELD sma13
         IF g_sma.sma13 IS NULL OR g_sma.sma13 = ' ' THEN
            LET g_sma.sma13 = 0
            DISPLAY  BY NAME g_sma.sma13
         ELSE
             IF g_sma.sma13 < 0 OR g_sma.sma13 > 100 THEN
                CALL cl_err(g_sma.sma13,'mfg0091',1)
                LET g_sma.sma13 = g_sma_o.sma13
                DISPLAY  BY NAME g_sma.sma13
                NEXT FIELD sma13
             END IF
         END IF
 
 
      BEFORE FIELD sma14
         IF g_sma.sma14 IS NULL OR g_sma.sma14 = ' ' THEN
            LET g_sma.sma14 = g_sma.sma13
            DISPLAY  BY NAME g_sma.sma14
         END IF
 
      AFTER FIELD sma14
         IF g_sma.sma14 IS NULL OR g_sma.sma14 = ' ' THEN
            LET g_sma.sma14 = g_sma.sma13
            DISPLAY  BY NAME g_sma.sma14
         ELSE
             IF g_sma.sma14 < 0 OR g_sma.sma14 > 100 THEN
                CALL cl_err(g_sma.sma14,'mfg0091',1)
                NEXT FIELD sma14
             END IF
             IF g_sma.sma14 < g_sma.sma13 THEN
                CALL cl_err(g_sma.sma14,'mfg0092',1)
                LET g_sma.sma14 = g_sma_o.sma14
                DISPLAY BY NAME g_sma.sma14
                NEXT FIELD sma13
             END IF
         END IF
 
      AFTER FIELD sma15
         IF g_sma.sma15 < 0 THEN
            CALL cl_err(g_sma.sma15,'mfg0093',1)
            LET g_sma.sma15 = g_sma_o.sma15
            DISPLAY BY NAME g_sma.sma15
            NEXT FIELD sma15
         END IF
 
      AFTER FIELD sma16
         IF g_sma.sma16 < 0 THEN
            CALL cl_err(g_sma.sma16,'mfg0093',1)
            LET g_sma.sma16 = g_sma_o.sma16
            DISPLAY BY NAME g_sma.sma16
            NEXT FIELD sma16
         END IF
 
      AFTER FIELD sma17
         IF g_sma.sma17 < 0 THEN
            CALL cl_err(g_sma.sma17,'mfg0093',1)
            LET g_sma.sma17 = g_sma_o.sma17
            DISPLAY BY NAME g_sma.sma17
            NEXT FIELD sma17
         END IF
 
      AFTER FIELD sma48
         IF g_sma.sma48 < 0 THEN
            CALL cl_err(g_sma.sma48,'mfg0093',1)
            LET g_sma.sma48 = g_sma_o.sma48
            DISPLAY BY NAME g_sma.sma48
            NEXT FIELD sma48
         END IF
         IF g_sma.sma47 ='1' OR g_sma.sma47 ='2' THEN
            IF g_sma.sma48 <=0 THEN
               CALL cl_err(g_sma.sma48,'mfg0099',1)
               NEXT FIELD sma48
            END IF
         END IF
 
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
