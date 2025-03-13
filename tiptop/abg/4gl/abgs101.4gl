# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abgs101.4gl
# Descriptions...: 加班時薪設定作業
# Date & Author..: 02/10/02 By qazzaq
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/30 By yangtingting 離開MAIN 時沒有cl_used(1)和cl_used(2)
 
DATABASE ds
GLOBALS "../../config/top.global"
    DEFINE
        g_n            LIKE type_file.num5,     #No.FUN-680061 SMALLINT 
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
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #FUN-B30211
    LET p_row = 5 LET p_col = 9
    OPEN WINDOW s101_w AT p_row,p_col
    WITH FORM "abg/42f/abgs101" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL s101_show()
    CALL s101_menu()
    CLOSE WINDOW s101_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B30211
END MAIN
 
FUNCTION s101_show()
 
    SELECT *
      INTO g_bgz.*
      FROM bgz_file
     WHERE bgz00 = '0'
 
    IF SQLCA.sqlcode THEN
#      CALL cl_err('','aap-131',0) #FUN-660105
       CALL cl_err3("sel","bgz_file","","","aap-131","","",0) #FUN-660105 
       RETURN
    END IF
 
    LET g_bgz_t.* = g_bgz.*
    LET g_bgz_o.* = g_bgz.*
 
    DISPLAY BY NAME
        g_bgz.bgz21,g_bgz.bgz22, g_bgz.bgz23, g_bgz.bgz24, g_bgz.bgz25,
        g_bgz.bgz26,g_bgz.bgz27, g_bgz.bgz28, g_bgz.bgz29, g_bgz.bgz30,
        g_bgz.bgz31,g_bgz.bgz32
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s101_menu()
    MENU ""
    ON ACTION modify
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
          CALL s101_u()
       END IF
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
FUNCTION s101_u()
    IF s_shut(0) THEN #判斷系統是否可用
        RETURN
    END IF
    IF NOT cl_chk_act_auth() THEN RETURN END IF   #無更改權限
    CALL cl_opmsg('u')
    MESSAGE ""
    LET g_forupd_sql="SELECT * FROM bgz_file WHERE bgz00 = ? ",
                     " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE bgz_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN bgz_curl USING '0'
    IF STATUS  THEN
        CALL cl_err('',STATUS,0)
        RETURN
    END IF
    IF STATUS  THEN
        CALL cl_err('',STATUS,0)
        RETURN
    END IF
    FETCH bgz_curl INTO g_bgz.*
    WHILE TRUE
        CALL s101_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            LET g_bgz.* = g_bgz_t.*
            CALL s101_show()
            EXIT WHILE
        END IF
        UPDATE bgz_file SET * = g_bgz.* WHERE bgz00='0'
        IF STATUS THEN
#           CALL cl_err('',STATUS,0) #FUN-660105
            CALL cl_err3("upd","bgz_file","","",STATUS,"","",0) #FUN-660105 
            CONTINUE WHILE
        END IF
        CLOSE bgz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION s101_i()
 
    IF cl_null(g_bgz.bgz31) THEN
       LET g_bgz.bgz28 = 1
       LET g_bgz.bgz30 = 1
       LET g_bgz.bgz31 = 30
       LET g_bgz.bgz32 = 8
       DISPLAY BY NAME g_bgz.bgz28,g_bgz.bgz30,g_bgz.bgz31,g_bgz.bgz32
    END IF
 
    INPUT BY NAME
        g_bgz.bgz21,g_bgz.bgz22,g_bgz.bgz23,g_bgz.bgz24,g_bgz.bgz25,
        g_bgz.bgz26,g_bgz.bgz27,g_bgz.bgz28,g_bgz.bgz29,g_bgz.bgz30,
        g_bgz.bgz31,g_bgz.bgz32
    WITHOUT DEFAULTS HELP 1
 
    AFTER FIELD bgz21
        IF cl_null(g_bgz.bgz21) THEN
           LET g_bgz.bgz21=' '
        ELSE
           CALL s101_check(g_bgz.bgz21)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bgz21
           END IF
        END IF
    AFTER FIELD bgz22
        IF cl_null(g_bgz.bgz22) THEN
           LET g_bgz.bgz22=' '
        ELSE
           CALL s101_check(g_bgz.bgz22)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bgz22
           END IF
        END IF
    AFTER FIELD bgz23
        IF cl_null(g_bgz.bgz23) THEN
           LET g_bgz.bgz23=' '
        ELSE
           CALL s101_check(g_bgz.bgz23)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bgz23
           END IF
        END IF
    AFTER FIELD bgz24
        IF cl_null(g_bgz.bgz24) THEN
           LET g_bgz.bgz24=' '
        ELSE
           CALL s101_check(g_bgz.bgz24)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bgz24
           END IF
        END IF
    AFTER FIELD bgz25
        IF cl_null(g_bgz.bgz25) THEN
           LET g_bgz.bgz25=' '
        ELSE
           CALL s101_check(g_bgz.bgz25)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bgz25
           END IF
        END IF
    AFTER FIELD bgz26
        IF cl_null(g_bgz.bgz26) THEN
           LET g_bgz.bgz26=' '
        ELSE
           CALL s101_check(g_bgz.bgz26)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bgz26
           END IF
        END IF
    AFTER FIELD bgz27
        IF NOT cl_null(g_bgz.bgz27) THEN
           CALL s101_check(g_bgz.bgz27)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bgz27
           END IF
        END IF
 
    AFTER FIELD bgz29
        IF cl_null(g_bgz.bgz29) THEN
           CALL s101_check(g_bgz.bgz29)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bgz29
           END IF
        END IF
 
    AFTER FIELD bgz31
        IF (g_bgz.bgz31>31) THEN
           LET g_bgz.bgz31=g_bgz_o.bgz31
           DISPLAY BY NAME g_bgz.bgz31
           NEXT FIELD bgz31
        END IF
        LET g_bgz_o.bgz31=g_bgz.bgz31
 
    AFTER FIELD bgz32
        IF (g_bgz.bgz32>24) THEN
           LET g_bgz.bgz32=g_bgz_o.bgz32
           DISPLAY BY NAME g_bgz.bgz32
           NEXT FIELD bgz32
        END IF
        LET g_bgz_o.bgz32=g_bgz.bgz32
     ON ACTION CONTROLP
            CASE
              WHEN INFIELD(bgz21)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz21
                   CALL cl_create_qry() RETURNING g_bgz.bgz21
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz21 )
                   DISPLAY BY NAME g_bgz.bgz21
                   NEXT FIELD bgz21
              WHEN INFIELD(bgz22)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz22
                   CALL cl_create_qry() RETURNING g_bgz.bgz22
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz22 )
                   DISPLAY BY NAME g_bgz.bgz22
                   NEXT FIELD bgz22
              WHEN INFIELD(bgz23)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz23
                   CALL cl_create_qry() RETURNING g_bgz.bgz23
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz23 )
                   DISPLAY BY NAME g_bgz.bgz23
                   NEXT FIELD bgz23
              WHEN INFIELD(bgz24)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz24
                   CALL cl_create_qry() RETURNING g_bgz.bgz24
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz24 )
                   DISPLAY BY NAME g_bgz.bgz24
                   NEXT FIELD bgz24
              WHEN INFIELD(bgz25)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz25
                   CALL cl_create_qry() RETURNING g_bgz.bgz25
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz25 )
                   DISPLAY BY NAME g_bgz.bgz25
                   NEXT FIELD bgz25
              WHEN INFIELD(bgz26)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz26
                   CALL cl_create_qry() RETURNING g_bgz.bgz26
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz26 )
                   DISPLAY BY NAME g_bgz.bgz26
                   NEXT FIELD bgz26
              WHEN INFIELD(bgz27)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz27
                   CALL cl_create_qry() RETURNING g_bgz.bgz27
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz27 )
                   DISPLAY BY NAME g_bgz.bgz27
                   NEXT FIELD bgz27
              WHEN INFIELD(bgz29)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz29
                   CALL cl_create_qry() RETURNING g_bgz.bgz29
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz29 )
                   DISPLAY BY NAME g_bgz.bgz29
                   NEXT FIELD bgz29
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
 
FUNCTION s101_check(p_cmd)
DEFINE
    p_cmd LIKE bgs_file.bgs01    #No.FUN-680061 VARCHAR(20)
 
    LET g_errno = ' '
    SELECT COUNT(*) INTO g_n
      FROM bgs_file
     WHERE bgs01 = p_cmd
    IF g_n=0 THEN LET g_errno = 'abg-004' END IF
END FUNCTION
#Patch....NO.TQC-610035 <001> #
