# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abgs010.4gl
# Descriptions...: 預算管理系統參數設定作業
# Date & Author..: 02/08/13 By Julius
# Modify.........: 03/11/04 BY Jukey (拿掉bgz17,bgz18,bgz19,bgz20,No.8626)
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-730033 07/03/20 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740003 07/04/02 By Smapmin 切換語言別即跳出畫面
# Modify.........: No.MOD-830223 08/03/28 By Smapmin 判斷沒資料時,要先insert資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B30211 11/03/30 By yangtingting 離開MAIN 時沒有cl_used(1)和cl_used(2)
# Modify.........: No.FUN-B50039 11/07/05 By xianghui 增加自訂欄位
 
DATABASE ds
GLOBALS "../../config/top.global"
    DEFINE
        g_bgz_t        RECORD LIKE bgz_file.*,  # 預留參數檔
        g_bgz_o        RECORD LIKE bgz_file.*   # 預留參數檔
DEFINE g_forupd_sql    STRING
MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0056
    DEFINE    p_row,p_col        LIKE type_file.num5      #No.FUN-680061 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
    WHENEVER ERROR CONTINUE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   #-----MOD-830223---------  
   #IF (NOT cl_setup("ABG")) THEN
   #   EXIT PROGRAM
   #END IF 
   #-----END MOD-830223-----
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B30211
   SELECT *					 #當bgz_file中沒有資料時
    INTO g_bgz.*				
    FROM bgz_file
    WHERE bgz00 = '0'
 
    IF cl_null(g_bgz.bgz00) THEN
	INSERT INTO bgz_file(bgz00, bgz01, bgz02, bgz03, bgz04)
	VALUES ('0', 'N', 'N', 3, 1)
    END IF
 
   #-----MOD-830223---------  
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF 
   #-----END MOD-830223-----
        LET p_row = 5 LET p_col = 9
 
    OPEN WINDOW s010_w AT p_row,p_col
    WITH FORM "abg/42f/abgs010" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL s010_show()
    CALL s010_menu()
    CLOSE WINDOW s010_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B30211
END MAIN
 
FUNCTION s010_show()
    LET g_bgz_t.* = g_bgz.*
    LET g_bgz_o.* = g_bgz.*
 
    DISPLAY BY NAME
        g_bgz.bgz01, g_bgz.bgz02, g_bgz.bgz03, g_bgz.bgz04,
        g_bgz.bgz10, g_bgz.bgz11, g_bgz.bgz12, g_bgz.bgz13,g_bgz.bgz36,
        g_bgz.bgzud01,g_bgz.bgzud02,g_bgz.bgzud03,g_bgz.bgzud04,g_bgz.bgzud05,    #FUN-B50039
        g_bgz.bgzud08,g_bgz.bgzud07,g_bgz.bgzud08,g_bgz.bgzud09,g_bgz.bgzud10,    #FUN-B50039
        g_bgz.bgzud11,g_bgz.bgzud12,g_bgz.bgzud13,g_bgz.bgzud14,g_bgz.bgzud15     #FUN-B50039
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s010_menu()
    MENU ""
    ON ACTION modify
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
          CALL s010_u()
       END IF
    ON ACTION locale
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       #EXIT MENU   #TQC-740003
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
    IF s_shut(0) THEN #判斷系統是否可用
        RETURN
    END IF
    IF NOT cl_chk_act_auth() THEN RETURN END IF   #無更改權限
    CALL cl_opmsg('u')
    MESSAGE ""
 
    LET g_forupd_sql="SELECT * FROM bgz_file  WHERE bgz00 = 0",
                     "   FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE bgz_curl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN bgz_curl
    IF STATUS  THEN
        CALL cl_err('',STATUS,0)
        RETURN
    END IF
    FETCH bgz_curl INTO g_bgz.*
    IF STATUS  THEN
        CALL cl_err('',STATUS,0)
        RETURN
    END IF
    WHILE TRUE
        CALL s010_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0 CALL cl_err('',9001,0)
            LET g_bgz.* = g_bgz_t.* CALL s010_show()
            EXIT WHILE
        END IF
        UPDATE bgz_file SET * = g_bgz.* WHERE bgz00='0'
        IF STATUS THEN
            CALL cl_err('',STATUS,0)
            CONTINUE WHILE
        END IF
        CLOSE bgz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION s010_i()
    DEFINE l_aza LIKE type_file.chr1      #No.FUN-680061 VARCHAR(1)
 
    IF cl_null(g_bgz.bgz01) THEN
        LET g_bgz.bgz01 = 'N'
        LET g_bgz.bgz02 = 'N'
        LET g_bgz.bgz03 = '3'
        LET g_bgz.bgz04 = '1'
        DISPLAY BY NAME g_bgz.bgz01,g_bgz.bgz02,g_bgz.bgz03,g_bgz.bgz04
    END IF
 
    INPUT BY NAME
        g_bgz.bgz01, g_bgz.bgz02, g_bgz.bgz03, g_bgz.bgz04,
        g_bgz.bgz10, g_bgz.bgz11, g_bgz.bgz12, g_bgz.bgz13,
        g_bgz.bgz36,
        g_bgz.bgzud01,g_bgz.bgzud02,g_bgz.bgzud03,g_bgz.bgzud04,g_bgz.bgzud05,    #FUN-B50039
        g_bgz.bgzud06,g_bgz.bgzud07,g_bgz.bgzud08,g_bgz.bgzud09,g_bgz.bgzud10,    #FUN-B50039
        g_bgz.bgzud11,g_bgz.bgzud12,g_bgz.bgzud13,g_bgz.bgzud14,g_bgz.bgzud15     #FUN-B50039
    WITHOUT DEFAULTS HELP 1
 
    AFTER FIELD bgz01
        IF g_bgz.bgz01 NOT MATCHES '[YN]' THEN
            LET g_bgz.bgz01=g_bgz_o.bgz01
            DISPLAY BY NAME g_bgz.bgz01
            NEXT FIELD bgz01
        END IF
        LET g_bgz_o.bgz01=g_bgz.bgz01
 
    AFTER FIELD bgz02
        IF g_bgz.bgz02 NOT MATCHES "[YN]" THEN
            LET g_bgz.bgz02=g_bgz_o.bgz02
            DISPLAY BY NAME g_bgz.bgz02
            NEXT FIELD bgz02
        END IF
        LET g_bgz_o.bgz02=g_bgz.bgz02
 
    AFTER FIELD bgz03
        IF g_bgz.bgz03 NOT MATCHES "[123]" THEN
            LET g_bgz.bgz03=g_bgz_o.bgz03
            DISPLAY BY NAME g_bgz.bgz03
            NEXT FIELD bgz03
        END IF
        LET g_bgz_o.bgz03=g_bgz.bgz03
 
    AFTER FIELD bgz04
        IF g_bgz.bgz04 NOT MATCHES "[12]" THEN
            LET g_bgz.bgz04=g_bgz_o.bgz04
            DISPLAY BY NAME g_bgz.bgz04
            NEXT FIELD bgz04
        END IF
        LET g_bgz_o.bgz04=g_bgz.bgz04
 
    AFTER FIELD bgz10
        IF NOT cl_null(g_bgz.bgz10) THEN
           CALL s010_bgz10(g_bgz.bgz10)
           IF NOT cl_null(g_errno)THEN
               CALL cl_err('',g_errno,0)
               #FUN-B10049--begin
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_bgz.bgz10  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bgz.bgz10 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_bgz.bgz10
               DISPLAY BY NAME g_bgz.bgz10                 
               #LET g_bgz.bgz10=g_bgz_o.bgz10
               #DISPLAY BY NAME g_bgz.bgz10
               #FUN-B10049--end
               NEXT FIELD bgz10
           END IF
           LET g_bgz_o.bgz10=g_bgz.bgz10
        END IF
 
    AFTER FIELD bgz11
        IF NOT cl_null(g_bgz.bgz11) THEN
           CALL s010_bgz10(g_bgz.bgz11)
           IF NOT cl_null(g_errno)THEN
               CALL cl_err('',g_errno,0)
               #FUN-B10049--begin
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_bgz.bgz11  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bgz.bgz11 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_bgz.bgz11
               DISPLAY BY NAME g_bgz.bgz11                   
               #LET g_bgz.bgz11=g_bgz_o.bgz11
               #DISPLAY BY NAME g_bgz.bgz11
               #FUN-B10049--end
               NEXT FIELD bgz11
           END IF
           LET g_bgz_o.bgz11=g_bgz.bgz11
        END IF
 
    AFTER FIELD bgz12
        IF NOT cl_null(g_bgz.bgz12) THEN
           CALL s010_bgz10(g_bgz.bgz12)
           IF NOT cl_null(g_errno)THEN
               CALL cl_err('',g_errno,0)
               #FUN-B10049--begin
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_bgz.bgz12  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bgz.bgz12 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_bgz.bgz12
               DISPLAY BY NAME g_bgz.bgz12                   
               #LET g_bgz.bgz11=g_bgz_o.bgz12
               #DISPLAY BY NAME g_bgz.bgz12
               #FUN-B10049--end               
               NEXT FIELD bgz12
           END IF
           LET g_bgz_o.bgz12=g_bgz.bgz12
        END IF
 
    AFTER FIELD bgz13
        IF NOT cl_null(g_bgz.bgz13) THEN
           CALL s010_bgz10(g_bgz.bgz13)
           IF NOT cl_null(g_errno)THEN
               CALL cl_err('',g_errno,0)
               #FUN-B10049--begin
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_bgz.bgz13  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bgz.bgz13 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_bgz.bgz13
               DISPLAY BY NAME g_bgz.bgz13                  
               #LET g_bgz.bgz11=g_bgz_o.bgz13
               #DISPLAY BY NAME g_bgz.bgz13
               #FUN-B10049--end
               NEXT FIELD bgz13
           END IF
           LET g_bgz_o.bgz13=g_bgz.bgz13
        END IF
 
    AFTER FIELD bgz36
        IF NOT cl_null(g_bgz.bgz36) THEN
           CALL s010_bgz10(g_bgz.bgz36)
           IF NOT cl_null(g_errno)THEN
               CALL cl_err('',g_errno,0)
               #FUN-B10049--begin
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_bgz.bgz36  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bgz.bgz36 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_bgz.bgz36
               DISPLAY BY NAME g_bgz.bgz36                   
               #LET g_bgz.bgz11=g_bgz_o.bgz36
               #DISPLAY BY NAME g_bgz.bgz36
               #FUN-B10049--end
               NEXT FIELD bgz36
           END IF
           LET g_bgz_o.bgz13=g_bgz.bgz36
        END IF

   #FUN-B50039-add-str-- 
   AFTER FIELD bgzud01
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud02
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud03
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud04
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud05
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud06
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud07
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud08
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud09
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud10
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud11
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud12
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud13
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud14
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD bgzud15
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   #FUN-B50039-add-end--
   ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
    ON ACTION CONTROLP
        CASE
            WHEN INFIELD(bgz10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_bgz.bgz10
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2')"
                 LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_bgz.bgz10
                DISPLAY BY NAME g_bgz.bgz10
            WHEN INFIELD(bgz11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_bgz.bgz11
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2')"
                 LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_bgz.bgz11
                DISPLAY BY NAME g_bgz.bgz11
            WHEN INFIELD(bgz12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_bgz.bgz12
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2')"
                 LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_bgz.bgz12
                DISPLAY BY NAME g_bgz.bgz12
            WHEN INFIELD(bgz13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_bgz.bgz13
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2')"
                 LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_bgz.bgz13
                DISPLAY BY NAME g_bgz.bgz13
            WHEN INFIELD(bgz36)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_bgz.bgz36
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2')"
                 LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_bgz.bgz36
                DISPLAY BY NAME g_bgz.bgz36
        END CASE
 
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
 
FUNCTION s010_bgz10(p_code)
 DEFINE p_code     LIKE aag_file.aag01
 DEFINE l_aagacti  LIKE aag_file.aagacti
 DEFINE l_aag07    LIKE aag_file.aag07
 DEFINE l_aag09    LIKE aag_file.aag09
 DEFINE l_aag03    LIKE aag_file.aag03
 
  SELECT aag03,aag07,aag09,aagacti
    INTO l_aag03,l_aag07,l_aag09,l_aagacti
    FROM aag_file
   WHERE aag01=p_code
     AND aag00=g_aza.aza81   #No.FUN-730033
  CASE WHEN STATUS=100         LET g_errno='agl-001'  #No.7926
       WHEN l_aagacti='N'      LET g_errno='9028'
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
        WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
        WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
       OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
  END CASE
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
