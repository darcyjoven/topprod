# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axms070.4gl
# Descriptions...: 銷售多角貿易參數設定
# Date & Author..: 03/09/16 By Kammy (No.8222)
# Modify.........: No.FUN-620024 06/03/03 By Ray 添加CHECKBOX一單到底
# Modify.........: No.FUN-640012 06/04/06 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: no.FUN-670007 06/07/26 by yiting 原程式欄位oza_file->ozx_file 
# Modify.........: No.FUN-680137 06/09/11 By bnlent  欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.FUN-720037 07/03/20 By Nicola 依參數判斷取價日期
# Modify.........: No.MOD-7A0026 07/10/05 By Carol 調整欄位輸入邏輯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-960213 10/11/09 By sabrina _u()段中按放棄時並沒有做COMMIT WORK或ROLLBACK WORK導致沒有CLOSE TRANSACTION 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50039 11/07/06 By xianghui 增加自訂欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_oax_t         RECORD LIKE oax_file.*,  # 預留參數檔
        g_oax_o         RECORD LIKE oax_file.*   # 預留參數檔
 
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql     STRING
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
 
#   LET g_oax.oax00='0' INSERT INTO oax_file VALUES(g_oax.*)
#   CALL cl_user()

    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
    LET p_row = 4 LET p_col = 28
 
    OPEN WINDOW s070_w AT p_row,p_col WITH FORM "axm/42f/axms070" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL s070_show()
 
    LET g_action_choice=""
    CALL s070_menu()
 
    CLOSE WINDOW s070_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION s070_show()
    LET g_oax_t.* = g_oax.*
    LET g_oax_o.* = g_oax.*
    DISPLAY BY NAME g_oax.oax01,g_oax.oax02,g_oax.oax03,
                    g_oax.oax04,g_oax.oax05,g_oax.oax06,  #No.FUN-620024
                    g_oax.oax07,g_oax.oax08,   #NO.FUN-670007   #No.FUN-720037
                    g_oax.oaxud01,g_oax.oaxud02,g_oax.oaxud03,g_oax.oaxud04,g_oax.oaxud05,       #FUN-B50039
                    g_oax.oaxud06,g_oax.oaxud07,g_oax.oaxud08,g_oax.oaxud09,g_oax.oaxud10,       #FUN-B50039
                    g_oax.oaxud11,g_oax.oaxud12,g_oax.oaxud13,g_oax.oaxud14,g_oax.oaxud15        #FUN-B50039
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s070_menu()
    MENU ""
        ON ACTION modify 
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL s070_u()
           END IF
 
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
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s070_u()
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('u')
    MESSAGE ""
 
    SELECT COUNT(*) INTO g_cnt FROM oax_file
     WHERE oax00 = '0'
    IF g_cnt = 0 THEN
       LET g_oax.oax00 = '0'
       INSERT INTO oax_file VALUES(g_oax.*)
    END IF
 
    LET g_forupd_sql = " SELECT * FROM oax_file WHERE oax00 = ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE oax_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN oax_curl USING '0'
    IF STATUS THEN
       CALL cl_err('',STATUS,1)
       ROLLBACK WORK         #TQC-960213 add
       RETURN
    END IF
 
    FETCH oax_curl INTO g_oax.*
    IF STATUS THEN
       CALL cl_err('',STATUS,1)
       ROLLBACK WORK         #TQC-960213 add
       RETURN
    END IF
 
    WHILE TRUE
        CALL s070_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_oax.* = g_oax_t.* CALL s070_show()
           ROLLBACK WORK         #TQC-960213 add
           EXIT WHILE
        END IF
        UPDATE oax_file SET * = g_oax.* WHERE oax00='0'
        IF STATUS THEN 
#          CALL cl_err('',STATUS,0) 
           CALL cl_err3("upd","oax_file","","",SQLCA.sqlcode,"","",0)    #No.FUN-660167
           CONTINUE WHILE 
        END IF
        CLOSE oax_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s070_i()
    DEFINE l_aza LIKE type_file.chr1   #No.FUN-680137 VARCHAR(01)
    
    INPUT BY NAME g_oax.oax01,g_oax.oax08,g_oax.oax02,g_oax.oax03,   #No.FUN-720037
                  g_oax.oax04,g_oax.oax05,g_oax.oax06,  #No.FUN-620024
                  g_oax.oax07,  #NO.FUN-670007
                  g_oax.oaxud01,g_oax.oaxud02,g_oax.oaxud03,g_oax.oaxud04,g_oax.oaxud05,       #FUN-B50039
                  g_oax.oaxud06,g_oax.oaxud07,g_oax.oaxud08,g_oax.oaxud09,g_oax.oaxud10,       #FUN-B50039
                  g_oax.oaxud11,g_oax.oaxud12,g_oax.oaxud13,g_oax.oaxud14,g_oax.oaxud15        #FUN-B50039
        WITHOUT DEFAULTS 
 
    AFTER FIELD oax01
 
#MOD-7A0026-modify
#      IF g_oax.oax01 NOT MATCHES "[BSMCD]" OR cl_null(g_oax.oax01) THEN #FUN-640012 BSCDT->BSMCD
       IF g_oax.oax01 NOT MATCHES "[BSMCD]" AND NOT cl_null(g_oax.oax01) THEN 
#MOD-7A0026-modify-end
          LET g_oax.oax01=g_oax_o.oax01 
          DISPLAY BY NAME g_oax.oax01   
          NEXT FIELD oax01
       END IF
       LET g_oax_o.oax01=g_oax.oax01
 
    #-----No.FUN-720037-----
    AFTER FIELD oax08
#MOD-7A0026-modify
#      IF g_oax.oax08 NOT MATCHES "[12]" OR cl_null(g_oax.oax08) THEN
       IF g_oax.oax08 NOT MATCHES "[12]" AND NOT cl_null(g_oax.oax08) THEN
#MOD-7A0026-modify-end
          LET g_oax.oax08=g_oax_o.oax08
          DISPLAY BY NAME g_oax.oax08
          NEXT FIELD oax08
       END IF
       LET g_oax_o.oax08=g_oax.oax08
    #-----No.FUN-720037 END-----
 
    AFTER FIELD oax02
#MOD-7A0026-modify
#      IF g_oax.oax02 NOT MATCHES "[YN]" OR cl_null(g_oax.oax02) THEN
       IF g_oax.oax02 NOT MATCHES "[YN]" AND NOT cl_null(g_oax.oax02) THEN
#MOD-7A0026-modify-end
          LET g_oax.oax02=g_oax_o.oax02
          DISPLAY BY NAME g_oax.oax02
          NEXT FIELD oax02
       END IF
       LET g_oax.oax02=g_oax.oax02
 
    AFTER FIELD oax03
#MOD-7A0026-modify
#      IF g_oax.oax03 NOT MATCHES "[YN]" OR cl_null(g_oax.oax03) THEN
       IF g_oax.oax03 NOT MATCHES "[YN]" AND NOT cl_null(g_oax.oax03) THEN
#MOD-7A0026-modify-end
          LET g_oax.oax03=g_oax_o.oax03
          DISPLAY BY NAME g_oax.oax03
          NEXT FIELD oax03
       END IF
       LET g_oax_o.oax03=g_oax.oax03
 
    #No.FUN-620024
    AFTER FIELD oax06
#MOD-7A0026-modify
#      IF cl_null(g_oax.oax06) THEN NEXT FIELD oax06 END IF
#      IF g_oax.oax06 NOT MATCHES '[YN]' THEN NEXT FIELD oax06 END IF
       IF NOT cl_null(g_oax.oax06) THEN
          IF g_oax.oax06 NOT MATCHES '[YN]' THEN 
             NEXT FIELD oax06
          END IF
       END IF
#MOD-7A0026-modify-end
 
    #end No.FUN-620024
    
    AFTER FIELD oax05
#MOD-7A0026-modify
#      IF cl_null(g_oax.oax05) THEN NEXT FIELD oax05 END IF
#      IF g_oax.oax05 NOT MATCHES '[YN]' THEN NEXT FIELD oax05 END IF
       IF NOT cl_null(g_oax.oax05) THEN 
          IF g_oax.oax05 NOT MATCHES '[YN]' THEN
             NEXT FIELD oax05
           END IF
       END IF
#MOD-7A0026-modify-end
 
    AFTER FIELD oax04
#MOD-7A0026-modify
#      IF cl_null(g_oax.oax04) THEN NEXT FIELD oax04 END IF
#      IF g_oax.oax04 NOT MATCHES '[YN]' THEN NEXT FIELD oax04 END IF
       IF NOT cl_null(g_oax.oax04) THEN 
          IF g_oax.oax04 NOT MATCHES '[YN]' THEN
             NEXT FIELD oax04 
          END IF
       END IF
#MOD-7A0026-modify-end

    #FUN-B50039-add-str--
    AFTER FIELD oaxud01
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud02
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud03
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud04
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud05
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud06
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud07
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud08
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud09
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud10
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud11
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud12
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud13
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud14
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD oaxud15
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
