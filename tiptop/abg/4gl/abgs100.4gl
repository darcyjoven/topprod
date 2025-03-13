# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abgs100.4gl
# Descriptions...: 預算管理系統參數設定作業
# Date & Author..: 02/10/02 By qazzaq
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/30 By yangtingting 離開MAIN 時沒有cl_used(1)和cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_bgz_t        RECORD LIKE bgz_file.*,   # 預留參數檔
        g_bgz_o        RECORD LIKE bgz_file.*    # 預留參數檔
DEFINE g_forupd_sql    STRING
MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0056
    DEFINE   p_row,p_col        LIKE type_file.num5       #No.FUN-680061 SMALLINT
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
    OPEN WINDOW s100_w AT p_row,p_col
    WITH FORM "abg/42f/abgs100" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL s100_show()
    CALL s100_menu()
    CLOSE WINDOW s100_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B30211
END MAIN
 
FUNCTION s100_show()
 
    SELECT * INTO g_bgz.* FROM bgz_file
     WHERE bgz00 = '0'
 
    IF SQLCA.sqlcode THEN
#      CALL cl_err('','aap-131',0) #FUN-660105
       CALL cl_err3("sel","bgz_file","","","aap-131","","",0) #FUN-660105 
       
       RETURN
    END IF
 
    LET g_bgz_t.* = g_bgz.*
    LET g_bgz_o.* = g_bgz.*
 
    DISPLAY BY NAME
        g_bgz.bgz14,g_bgz.bgz15,g_bgz.bgz16,g_bgz.bgz17,g_bgz.bgz18,
        g_bgz.bgz19,g_bgz.bgz20,g_bgz.bgz33,g_bgz.bgz34,g_bgz.bgz35
    CALL s100_bgz33('D')
    CALL s100_bgz34('D')
    CALL s100_bgz35('D')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s100_menu()
    MENU ""
    ON ACTION modify
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
             CALL s100_u()
       END IF
    ON ACTION help
       CALL cl_show_help()
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
FUNCTION s100_u()
    IF s_shut(0) THEN #判斷系統是否可用
        RETURN
    END IF
    IF NOT cl_chk_act_auth() THEN RETURN END IF   #無更改權限
 
    CALL cl_opmsg('u')
    MESSAGE ""
 
    LET g_forupd_sql= "SELECT *  FROM bgz_file  WHERE bgz00 = 0 ",
                      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE bgz_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN bgz_curl
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
        CALL s100_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            LET g_bgz.* = g_bgz_t.*
            CALL s100_show()
            EXIT WHILE
        END IF
        UPDATE bgz_file SET * = g_bgz.* WHERE bgz00='0'
        IF STATUS THEN
#           CALL cl_err('',STATUS,0) #FUN-660105
            CALL cl_err3("upd","bgz_file","","",STATUS,"","",0)#FUN-660105
            CONTINUE WHILE
        END IF
        CLOSE bgz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION s100_i()
 
    IF cl_null(g_bgz.bgz14) THEN
       LET g_bgz.bgz15 = 0
       LET g_bgz.bgz17 = 0
       LET g_bgz.bgz18 = 0
       LET g_bgz.bgz19 = 0
       LET g_bgz.bgz20 = 0
       DISPLAY BY NAME g_bgz.bgz15,g_bgz.bgz17,
                       g_bgz.bgz18,g_bgz.bgz19,g_bgz.bgz20
    END IF
 
    INPUT BY NAME
        g_bgz.bgz14,g_bgz.bgz15,g_bgz.bgz16,g_bgz.bgz17,g_bgz.bgz18,
        g_bgz.bgz19,g_bgz.bgz20,g_bgz.bgz33,g_bgz.bgz34,g_bgz.bgz35
    WITHOUT DEFAULTS HELP 1
 
    AFTER FIELD bgz14
        IF cl_null(g_bgz.bgz14) THEN
           LET g_bgz.bgz14=YEAR(g_today)
           DISPLAY BY NAME g_bgz.bgz14
        END IF
        LET g_bgz_o.bgz14=g_bgz.bgz14
 
    AFTER FIELD bgz15
        IF NOT cl_null(g_bgz.bgz15) THEN
           LET g_bgz_o.bgz15=g_bgz.bgz15
        END IF
 
    AFTER FIELD bgz16
        IF NOT cl_null(g_bgz.bgz16) THEN
           IF g_bgz.bgz16 > 12 OR g_bgz.bgz16 < 1 THEN
              LET g_bgz.bgz16=g_bgz_o.bgz16
              DISPLAY BY NAME g_bgz.bgz16
              NEXT FIELD bgz16
           END IF
           LET g_bgz_o.bgz16=g_bgz.bgz16
        END IF
 
    AFTER FIELD bgz17
        IF NOT cl_null(g_bgz.bgz17) THEN
           LET g_bgz_o.bgz17=g_bgz.bgz17
        END IF
 
    AFTER FIELD bgz18
        IF NOT cl_null(g_bgz.bgz18) THEN
           LET g_bgz_o.bgz10=g_bgz.bgz18
        END IF
 
    AFTER FIELD bgz19
        IF NOT cl_null(g_bgz.bgz19) THEN
           LET g_bgz_o.bgz19=g_bgz.bgz19
        END IF
 
    AFTER FIELD bgz20
        IF NOT cl_null(g_bgz.bgz20) THEN
           LET g_bgz_o.bgz12=g_bgz.bgz20
        END IF
 
    AFTER FIELD bgz33
        IF NOT cl_null(g_bgz.bgz33) THEN
           CALL s100_bgz33('a')      #必需讀取(費用項目)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              LET g_bgz.bgz33=g_bgz_o.bgz33
              NEXT FIELD bgz33
           END IF
        END IF
 
    AFTER FIELD bgz34
        IF NOT cl_null(g_bgz.bgz34) THEN
           CALL s100_bgz34('a')      #必需讀取(費用項目)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              LET g_bgz.bgz34=g_bgz_o.bgz34
              NEXT FIELD bgz34
           END IF
        END IF
 
    AFTER FIELD bgz35
        IF NOT cl_null(g_bgz.bgz35) THEN
           CALL s100_bgz35('a')      #必需讀取(費用項目)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              LET g_bgz.bgz35=g_bgz_o.bgz35
              NEXT FIELD bgz35
           END IF
        END IF
 
   ON ACTION CONTROLP
            CASE
              WHEN INFIELD(bgz33)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz33
                   CALL cl_create_qry() RETURNING g_bgz.bgz33
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz33 )
                   DISPLAY BY NAME g_bgz.bgz33
                   NEXT FIELD bgz33
              WHEN INFIELD(bgz34)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz34
                   CALL cl_create_qry() RETURNING g_bgz.bgz34
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz34 )
                   DISPLAY BY NAME g_bgz.bgz34
                   NEXT FIELD bgz34
              WHEN INFIELD(bgz35)        #費用項目
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bgs'
                   LET g_qryparam.default1 = g_bgz.bgz35
                   CALL cl_create_qry() RETURNING g_bgz.bgz35
#                   CALL FGL_DIALOG_SETBUFFER( g_bgz.bgz35 )
                   DISPLAY BY NAME g_bgz.bgz35
                   NEXT FIELD bgz35
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
 
FUNCTION s100_bgz33(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680061 VARCHAR(1)
    l_bgs02         LIKE bgs_file.bgs02,
    l_bgsacti       LIKE bgs_file.bgsacti
 
    LET g_errno = ' '
    SELECT bgs02,bgsacti
      INTO l_bgs02,l_bgsacti
      FROM bgs_file
     WHERE bgs01 = g_bgz.bgz33
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-004'
                                   LET l_bgs02   = NULL
                                   LET l_bgsacti = NULL
         WHEN l_bgsacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_bgs02 TO bgs02
    END IF
END FUNCTION
 
FUNCTION s100_bgz34(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(1)
    l_bgs02         LIKE bgs_file.bgs02,
    l_bgsacti       LIKE bgs_file.bgsacti
 
    LET g_errno = ' '
    SELECT bgs02,bgsacti
      INTO l_bgs02,l_bgsacti
      FROM bgs_file
     WHERE bgs01 = g_bgz.bgz34
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-004'
                                   LET l_bgs02   = NULL
                                   LET l_bgsacti = NULL
         WHEN l_bgsacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_bgs02 TO bgs02_1
    END IF
END FUNCTION
 
FUNCTION s100_bgz35(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680061 VARCHAR(1)
    l_bgs02         LIKE bgs_file.bgs02,
    l_bgsacti       LIKE bgs_file.bgsacti
 
    LET g_errno = ' '
    SELECT bgs02,bgsacti
      INTO l_bgs02,l_bgsacti
      FROM bgs_file
     WHERE bgs01 = g_bgz.bgz35
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-004'
                                   LET l_bgs02   = NULL
                                   LET l_bgsacti = NULL
         WHEN l_bgsacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_bgs02 TO bgs02_2
    END IF
END FUNCTION
#Patch....NO.TQC-610035 <001> #
