# Prog. Version..: '5.30.06-13.04.02(00006)'     #
#
# Pattern name...: apms010.4gl
# Descriptions...: 三角代採買參數設定作業
# Date & Author..: 02/03/02 By Kammy
# Modify.........: No.FUN-620025 06/03/03 By Ray 添加CHECKBOX一單到底
# Modify.........: No.FUN-640012 06/04/06 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: NO.FUN-670007 06/08/08 BY yiting add pod05
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50039 11/07/11 By xianghui 增加自訂欄位
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_pod_t         RECORD LIKE pod_file.*,  # 預留參數檔
        g_pod_o         RECORD LIKE pod_file.*   # 預留參數檔
    DEFINE
        g_buf           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(20)
DEFINE  g_forupd_sql    STRING       #SELECT ... FOR UPDATE SQL
DEFINE  g_cnt           LIKE type_file.num10      #No.FUN-680136 INTEGER
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW s010_w WITH FORM "apm/42f/apms010" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   SELECT * INTO g_pod.* FROM pod_file WHERE pod00 = '0'
   CALL s010_show()
 
   LET g_action_choice=""
   CALL s010_menu()
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CLOSE WINDOW s010_w
END MAIN
 
FUNCTION s010_show()
    LET g_pod_t.* = g_pod.*
    LET g_pod_o.* = g_pod.*
    DISPLAY BY NAME g_pod.pod01,g_pod.pod02,
                    g_pod.pod03,g_pod.pod04,   #No.FUN-620025 
                    g_pod.pod05,g_pod.pod08,   #NO.FUN-670007 #FUN-D30099 add pod08
                    g_pod.podud01,g_pod.podud02,g_pod.podud03,g_pod.podud04,g_pod.podud05,     #FUN-B50039
                    g_pod.podud06,g_pod.podud07,g_pod.podud08,g_pod.podud09,g_pod.podud10,     #FUN-B50039
                    g_pod.podud11,g_pod.podud12,g_pod.podud13,g_pod.podud14,g_pod.podud15      #FUN-B50039
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s010_menu()
    MENU ""
        ON ACTION modify 
           LET g_action_choice = "modify"
           IF cl_chk_act_auth() THEN 
              CALL s010_u()
           END IF   #無更改權限
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION help
           CALL cl_show_help()

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
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('u')
    MESSAGE ""
    SELECT COUNT(*) INTO g_cnt FROM pod_file
     WHERE pod00 = '0'
    IF g_cnt = 0 THEN
       LET g_pod.pod00 = '0'
       INSERT INTO pod_file VALUES(g_pod.*)
    END IF
 
    LET g_forupd_sql="SELECT * FROM pod_file  WHERE pod00 = ? ",
                       " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE pod_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN pod_curl USING '0'
    IF STATUS THEN
       CALL cl_err("OPEN pod_curl:", STATUS, 1)
       CLOSE pod_curl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH pod_curl INTO g_pod.*
    IF STATUS = 100 THEN
       LET g_pod.pod00 = '0'
       INSERT INTO pod_file VALUES(g_pod.*)
    ELSE
       IF STATUS THEN CALL cl_err('',STATUS,1) RETURN END IF
    END IF
    WHILE TRUE
        CALL s010_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_pod.* = g_pod_t.* CALL s010_show()
           EXIT WHILE
        END IF
        UPDATE pod_file SET * = g_pod.* WHERE pod00='0'
        IF STATUS THEN
#          CALL cl_err('',STATUS,0)  #No.FUN-660129
           CALL cl_err3("upd","pod_file","","",STATUS,"","",1) #No.FUN-660129
           CONTINUE WHILE
         END IF
        CLOSE pod_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s010_i()
    DEFINE l_aza LIKE type_file.chr1     #No.FUN-680136 VARCHAR(01)
    DEFINE l_n   LIKE type_file.num5    #No.FUN-680136 SMALLINT
    
    INPUT BY NAME g_pod.pod01,g_pod.pod02,g_pod.pod03,g_pod.pod04,  #No.FUN-620025
                  g_pod.pod05,g_pod.pod08,                          #NO.FUN-670007 #FUN-D30099 add pod08
                  g_pod.podud01,g_pod.podud02,g_pod.podud03,g_pod.podud04,g_pod.podud05,     #FUN-B50039
                  g_pod.podud06,g_pod.podud07,g_pod.podud08,g_pod.podud09,g_pod.podud10,     #FUN-B50039
                  g_pod.podud11,g_pod.podud12,g_pod.podud13,g_pod.podud14,g_pod.podud15      #FUN-B50039
                   WITHOUT DEFAULTS 
 
    AFTER FIELD pod01  
       IF cl_null(g_pod.pod01) THEN
          LET g_pod.pod01=g_pod_o.pod01
          DISPLAY BY NAME g_pod.pod01
          NEXT FIELD pod01
       END IF
       IF g_pod.pod01 NOT MATCHES '[BSMCD]' THEN  #FUN-640012 BSCDT->BSMCD
          NEXT FIELD pod01
       END IF
       LET g_pod_o.pod01=g_pod.pod01
 
    AFTER FIELD pod02
       IF cl_null(g_pod.pod02) THEN
          LET g_pod.pod02=g_pod_o.pod02
          DISPLAY BY NAME g_pod.pod02
          NEXT FIELD pod02
       END IF
       IF g_pod.pod02 NOT MATCHES '[YN]' THEN
          NEXT FIELD pod02
       END IF
       LET g_pod_o.pod02=g_pod.pod02
 
    AFTER FIELD pod03
       IF cl_null(g_pod.pod03) THEN
          LET g_pod.pod03=g_pod_o.pod03
          DISPLAY BY NAME g_pod.pod03
          NEXT FIELD pod03
       END IF
       IF g_pod.pod03 NOT MATCHES '[YN]' THEN
          NEXT FIELD pod03
       END IF
       LET g_pod_o.pod03=g_pod.pod03
   
    #No.FUN-620025
    AFTER FIELD pod04
       IF cl_null(g_pod.pod04) THEN
          LET g_pod.pod04=g_pod_o.pod04
          DISPLAY BY NAME g_pod.pod04
          NEXT FIELD pod04
       END IF
       IF g_pod.pod04 NOT MATCHES '[YN]' THEN
          NEXT FIELD pod04
       END IF
       LET g_pod_o.pod04=g_pod.pod04
    #end No.FUN-620025
 
#NO.FUN-670007 start-
    AFTER FIELD pod05
       IF cl_null(g_pod.pod05) THEN
          LET g_pod.pod05=g_pod_o.pod05
          DISPLAY BY NAME g_pod.pod05
          NEXT FIELD pod05
       END IF
       IF g_pod.pod05 NOT MATCHES '[YN]' THEN
          NEXT FIELD pod05
       END IF
       LET g_pod_o.pod05=g_pod.pod05
#NO.FUN-670007 end--

   #FUN-D30099---add---S
    AFTER FIELD pod08
       IF cl_null(g_pod.pod08) THEN
          LET g_pod.pod08=g_pod_o.pod08
          DISPLAY BY NAME g_pod.pod08
          NEXT FIELD pod08
       END IF
       IF g_pod.pod08 NOT MATCHES '[YN]' THEN
          NEXT FIELD pod08
       END IF
       LET g_pod_o.pod08=g_pod.pod08
   #FUN-D30099---add---E 

    #FUN-B50039-add-str--
    AFTER FIELD podud01
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud02
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud03
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud04
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud05
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud06
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud07
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud08
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud09
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud10
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud11
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud12
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud13
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud14
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD podud15
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
