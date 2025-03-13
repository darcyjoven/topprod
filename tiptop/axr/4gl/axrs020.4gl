# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axrs020.4gl
# Descriptions...: 應收系統參數設定-for流通版
# Date & Author..: 09/06/22 By lutingting #No.FUN-960140
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9C0139 09/12/22 By lutingting 1.退款單 儲值卡退余額以及支出單改用axrt410單別 
#                                                       2.oow16改為應收賬款單別-儲值卡
# Modify.........: No.FUN-9C0168 10/01/04 By lutingting oow21隐藏
# Modify.........: No.TQC-AB0025 10/11/04 By chenying Sybase问题
# Modify.........: No.MOD-C30422 12/03/12 By minpp 修改oow18，oow20增加判断，若ooydmy1='Y'，怎报错
DATABASE ds
 
GLOBALS "../../config/top.global"
  DEFINE
        g_oow           RECORD LIKE oow_file.*,
        g_oow_t         RECORD LIKE oow_file.*,  # 預留參數檔
        g_oow_o         RECORD LIKE oow_file.*   # 預留參數檔
  DEFINE  g_forupd_sql    STRING
  DEFINE  g_cnt           LIKE type_file.num10
  DEFINE  g_t1             LIKE ooy_file.ooyslip
 
MAIN
  DEFINE   p_row,p_col         LIKE type_file.num5
    OPTIONS
          INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)
     RETURNING g_time
 
   OPEN WINDOW s020_w AT p_row,p_col
     WITH FORM "axr/42f/axrs020"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_set_comp_visible("oow21",FALSE)    #FUN-9C0168

   CALL s020_show()
 
   LET g_action_choice=""
 
 
   CALL s020_menu()
 
   CLOSE WINDOW s020_w
   CALL cl_used(g_prog,g_time,2)
     RETURNING g_time
 
END MAIN
 
FUNCTION s020_show()
   SELECT * INTO g_oow.* FROM oow_file
     WHERE oow00 = '0'          #TQC-AB0025 mod oow00 = 0 --> oow00 = '0'
 
   IF SQLCA.sqlcode OR g_oow.oow00 IS NULL THEN
      LET g_oow.oow00 = '0'     #TQC-AB0025 mod oow00 = 0 --> oow00 = '0' 
      LET g_oow.oow01 = NULL
      LET g_oow.oow02 = NULL
      LET g_oow.oow03 = NULL
      LET g_oow.oow04 = NULL
      LET g_oow.oow05 = NULL
      LET g_oow.oow06 = NULL
      LET g_oow.oow07 = NULL
      LET g_oow.oow08 = NULL
      LET g_oow.oow09 = NULL
      LET g_oow.oow10 = NULL
      LET g_oow.oow11 = NULL
      LET g_oow.oow12 = NULL
      LET g_oow.oow13 = NULL
      LET g_oow.oow14 = NULL
      LET g_oow.oow15 = NULL
      LET g_oow.oow16 = NULL
      LET g_oow.oow17 = NULL
      LET g_oow.oow18 = NULL
      LET g_oow.oow19 = NULL
      LET g_oow.oow20 = NULL
      LET g_oow.oow21 = NULL
      LET g_oow.oow22 = NULL
      LET g_oow.oow23 = NULL
      LET g_oow.oow24 = NULL
      LET g_oow.oow25 = NULL
      LET g_oow.oow26 = NULL
      LET g_oow.oow27 = NULL
      INSERT INTO oow_file VALUES (g_oow.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","oow_file","","",SQLCA.sqlcode,"","I",0)
        END IF
   END IF
 
   LET g_oow_t.* = g_oow.*
   LET g_oow_o.* = g_oow.*
 
   DISPLAY BY NAME g_oow.oow01,g_oow.oow04,g_oow.oow08,g_oow.oow17,g_oow.oow10,
                   g_oow.oow11,g_oow.oow12,g_oow.oow06,g_oow.oow13,g_oow.oow21,g_oow.oow27, 
                   g_oow.oow22,g_oow.oow23,g_oow.oow24,g_oow.oow25,            
                   g_oow.oow02,g_oow.oow03,g_oow.oow26,g_oow.oow09,g_oow.oow18,
                   g_oow.oow19,g_oow.oow20,g_oow.oow05,g_oow.oow07,g_oow.oow14,
                   g_oow.oow15,g_oow.oow16
 
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION s020_menu()
 
   MENU ""
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL s020_u()
         END IF
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
           LET g_action_choice = "exit"
         EXIT MENU
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
         LET g_action_choice = "exit"
         CONTINUE MENU
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
   END MENU
 
END FUNCTION
 
FUNCTION s020_u()
 
   MESSAGE ""
   CALL cl_opmsg('u')
 
    LET g_forupd_sql = "SELECT * FROM oow_file WHERE oow00 = '0'   ",
                       " FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE oow_cl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN oow_cl
    IF STATUS  THEN
       CALL cl_err('',STATUS,0)
       RETURN
    END IF
    FETCH oow_cl INTO g_oow.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    #No.FUN-9A0024--begin
    #DISPLAY BY NAME g_oow.*
    DISPLAY BY NAME g_oow.oow01,g_oow.oow04,g_oow.oow08,g_oow.oow17,g_oow.oow10,
                    g_oow.oow11,g_oow.oow12,g_oow.oow06,g_oow.oow13,g_oow.oow21,g_oow.oow27, 
                    g_oow.oow22,g_oow.oow23,g_oow.oow24,g_oow.oow25,            
                    g_oow.oow02,g_oow.oow03,g_oow.oow26,g_oow.oow09,g_oow.oow18,
                    g_oow.oow19,g_oow.oow20,g_oow.oow05,g_oow.oow07,g_oow.oow14,
                    g_oow.oow15,g_oow.oow16
    #No.FUN-9A0024--end                 
   WHILE TRUE
      CALL s020_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_oow.* = g_oow_t.*
         CALL s020_show()
         EXIT WHILE
      END IF
      UPDATE oow_file SET oow_file.*=g_oow.*
       WHERE oow00 = '0'    #TQC-AB0025 mod oow00 = 0 --> oow00 = '0'
 
      IF STATUS THEN
         CALL cl_err3("upd","oow_file","","",STATUS,"","",0)
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
   CLOSE oow_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION s020_i()
  DEFINE l_ooyacti  LIKE ooy_file.ooyacti
  DEFINE l_ooytype  LIKE ooy_file.ooytype
  DEFINE l_nmykind  LIKE nmy_file.nmykind
  DEFINE l_nmyacti  LIKE nmy_file.nmyacti
  DEFINE l_nmaacti  LIKE nma_file.nmaacti
  DEFINE li_result  LIKE type_file.num5
  LET g_oow_t.* = g_oow.*
   INPUT BY NAME g_oow.oow01,g_oow.oow04,g_oow.oow08,g_oow.oow17,g_oow.oow10,
                 g_oow.oow11,g_oow.oow12,g_oow.oow06,g_oow.oow13,g_oow.oow21,g_oow.oow27, 
                 g_oow.oow22,g_oow.oow23,g_oow.oow24,g_oow.oow25,           
                 g_oow.oow02,g_oow.oow03,g_oow.oow26,g_oow.oow09,g_oow.oow16,g_oow.oow18,   #FUN-9C0139 oow16擺在oow09后面
                 g_oow.oow19,g_oow.oow20,g_oow.oow05,g_oow.oow07,g_oow.oow14,
                 g_oow.oow15   #FUN-9C0139 del oow16
       WITHOUT DEFAULTS
 
      AFTER FIELD oow01
         IF NOT cl_null(g_oow.oow01) THEN
             CALL s020_oow01(g_oow.oow01,'1')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_oow.oow01,g_errno,0)
                LET g_oow.oow01 = g_oow_o.oow01
                DISPLAY BY NAME g_oow.oow01
                NEXT FIELD oow01
             END IF
             LET g_oow_o.oow01=g_oow.oow01
         END IF
 
 
      AFTER FIELD oow02
         IF NOT cl_null(g_oow.oow02) THEN
            CALL s_check_no("axr",g_oow.oow02,"","15","","","")
                   RETURNING li_result,g_oow.oow02
            IF (NOT li_result) THEN
                NEXT FIELD oow02
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow02)
            LET g_oow.oow02 = g_t1
            DISPLAY BY NAME g_oow.oow02
            CALL s020_oow02(g_oow.oow02,'15')
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err(g_oow.oow02,g_errno,0)
               LET g_oow.oow02 = g_oow_o.oow02
               DISPLAY BY NAME g_oow.oow02
               NEXT FIELD oow02
            END IF
            LET g_oow_o.oow02=g_oow.oow02
         END IF
 
 
      AFTER FIELD oow03
         IF NOT cl_null(g_oow.oow03) THEN
            CALL  s_check_no("axr",g_oow.oow03,"","17","","","")
                   RETURNING li_result,g_oow.oow03
            IF (NOT li_result) THEN
                NEXT FIELD oow03
            END IF
 
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow03)
            LET g_oow.oow03 = g_t1
            DISPLAY BY NAME g_oow.oow03
            CALL s020_oow02(g_oow.oow03,'17')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow03,g_errno,0)
               LET g_oow.oow03 = g_oow_o.oow03
               DISPLAY BY NAME g_oow.oow03
               NEXT FIELD oow03
            END IF
            LET g_oow_o.oow03 = g_oow.oow03
         END IF
 
 
      AFTER FIELD oow04
         IF NOT cl_null(g_oow.oow04) THEN
            CALL s020_oow01(g_oow.oow04,'2')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow04,g_errno,0)
               LET g_oow.oow04 = g_oow_o.oow04
               DISPLAY BY NAME g_oow.oow04
               NEXT FIELD oow04
            END IF
            LET g_oow_o.oow04=g_oow.oow04
         END IF
 
 
      AFTER FIELD oow05
         IF NOT cl_null(g_oow.oow05) THEN
            #CALL s_check_no('axr',g_oow.oow05,"","30","ooa_file","ooa01","")  #FUN-9C0139 
             CALL s_check_no('axr',g_oow.oow05,"","32","ooa_file","ooa01","")  #FUN-9C0139
               RETURNING li_result,g_oow.oow05
            IF (NOT li_result) THEN
                  NEXT FIELD oow05
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow05)
            LET g_oow.oow05 = g_t1
            DISPLAY BY NAME g_oow.oow05
            #CALL s020_oow02(g_oow.oow05,'30')   #FUN-9C0139
            CALL s020_oow02(g_oow.oow05,'32')    #FUN-9C0139
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow05,g_errno,0)
               LET g_oow.oow05 = g_oow_o.oow05
               DISPLAY BY NAME g_oow.oow05
               NEXT FIELD oow05
            END IF
            LET g_oow_o.oow05 = g_oow.oow05
         END IF
 
      AFTER FIELD oow06
         IF NOT cl_null(g_oow.oow06) THEN
            CALL s_check_no("anm",g_oow.oow06,g_oow_t.oow06,"3",""," ","")
               RETURNING li_result,g_oow.oow06
            IF (NOT li_result) THEN
               NEXT FIELD oow06
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow06)
            LET g_oow.oow06 = g_t1
            DISPLAY BY NAME g_oow.oow06
            CALL s020_oow06(g_oow.oow06,'3')
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err(g_oow.oow06,g_errno,0)
               LET g_oow.oow06 = g_oow_o.oow06
               DISPLAY BY NAME g_oow.oow06
               NEXT FIELD oow06
            END IF
            LET g_oow_o.oow06 = g_oow.oow06
         END IF
 
      AFTER FIELD oow07
         IF NOT cl_null(g_oow.oow07) THEN
            #CALL s_check_no('axr',g_oow.oow07,"","30","ooa_file","ooa01","")   #FUN-9C0139
             CALL s_check_no('axr',g_oow.oow07,"","32","ooa_file","ooa01","")   #FUN-9C0139
               RETURNING li_result,g_oow.oow07
            IF (NOT li_result) THEN
               NEXT FIELD oow07
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow07)
            LET g_oow.oow07 = g_t1
            DISPLAY BY NAME g_oow.oow07
            #CALL s020_oow02(g_oow.oow07,'30')   #FUN-9C0139
            CALL s020_oow02(g_oow.oow07,'32')   #FUN-9C0139
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow07,g_errno,0)
               LET g_oow.oow07 = g_oow_o.oow07
               DISPLAY BY NAME g_oow.oow07
               NEXT FIELD oow07
            END IF
            LET g_oow_o.oow07 = g_oow.oow07
         END IF
 
      AFTER FIELD oow08
         IF NOT cl_null(g_oow.oow08) THEN
            CALL s020_oow01(g_oow.oow08,'1')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow08,g_errno,0)
               LET g_oow.oow08 = g_oow_o.oow08
               DISPLAY BY NAME g_oow.oow08
               NEXT FIELD oow08
            END IF
            LET g_oow_o.oow08=g_oow.oow08
         END IF
 
 
      AFTER FIELD oow09
         IF NOT cl_null(g_oow.oow09) THEN
            CALL  s_check_no("axr",g_oow.oow09,"","18","","","")
                   RETURNING li_result,g_oow.oow09
            IF (NOT li_result) THEN
                NEXT FIELD oow09
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow09)
            LET g_oow.oow09 = g_t1
            DISPLAY BY NAME g_oow.oow09
            CALL s020_oow02(g_oow.oow09,'18')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow09,g_errno,0)
               LET g_oow.oow09 = g_oow_o.oow09
               DISPLAY BY NAME g_oow.oow09
               NEXT FIELD oow09
            END IF
            LET g_oow_o.oow09 = g_oow.oow09
         END IF
 
      AFTER FIELD oow10
         IF NOT cl_null(g_oow.oow10) THEN
            CALL s020_oow01(g_oow.oow10,'1')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow10,g_errno,0)
               LET g_oow.oow10 = g_oow_o.oow10
               DISPLAY BY NAME g_oow.oow10
               NEXT FIELD oow10
            END IF
            LET g_oow_o.oow10=g_oow.oow10
         END IF
 
      AFTER FIELD oow11
         IF NOT cl_null(g_oow.oow11) THEN
            CALL s020_oow01(g_oow.oow11,'1')
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err(g_oow.oow11,g_errno,0)
               LET g_oow.oow11 = g_oow_o.oow11
               DISPLAY BY NAME g_oow.oow11
               NEXT FIELD oow11
            END IF
            LET g_oow_o.oow11=g_oow.oow11
         END IF
 
      AFTER FIELD oow12
         IF NOT cl_null(g_oow.oow12) THEN
            CALL s020_oow01(g_oow.oow12,'2')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow12,g_errno,0)
               LET g_oow.oow12 = g_oow_o.oow12
               DISPLAY BY NAME g_oow.oow12
               NEXT FIELD oow12
            END IF
            LET g_oow_o.oow12=g_oow.oow12
         END IF
 
       AFTER FIELD oow13
         IF NOT cl_null(g_oow.oow13) THEN
            CALL s020_oow13(g_oow.oow13)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow13,g_errno,0)
               LET g_oow.oow13  = g_oow_o.oow13
               DISPLAY BY NAME g_oow.oow13
               NEXT FIELD oow13
            END IF
         END IF
         LET g_oow_o.oow13 = g_oow.oow13
 
      AFTER FIELD oow14
         IF NOT cl_null(g_oow.oow14) THEN
            CALL s_check_no('axr',g_oow.oow14,"","30","ooa_file","ooa01","")
               RETURNING li_result,g_oow.oow14
            IF (NOT li_result) THEN
                  NEXT FIELD oow14
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow14)
            LET g_oow.oow14 = g_t1
            DISPLAY BY NAME g_oow.oow14
            CALL s020_oow02(g_oow.oow14,'30')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow14,g_errno,0)
               LET g_oow.oow14 = g_oow_o.oow14
               DISPLAY BY NAME g_oow.oow14
               NEXT FIELD oow14
            END IF
            LET g_oow_o.oow14 = g_oow.oow14
         END IF
 
      AFTER FIELD oow15
         IF NOT cl_null(g_oow.oow15) THEN
            #CALL s_check_no('axr',g_oow.oow15,"","30","ooa_file","ooa01","")   #FUN-9C0139
            CALL s_check_no('axr',g_oow.oow15,"","32","ooa_file","ooa01","")   #FUN-9C0139
               RETURNING li_result,g_oow.oow15
            IF (NOT li_result) THEN
                  NEXT FIELD oow15
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow15)
            LET g_oow.oow15 = g_t1
            DISPLAY BY NAME g_oow.oow15
            #CALL s020_oow02(g_oow.oow15,'30')   #FUN-9C0139
            CALL s020_oow02(g_oow.oow15,'32')   #FUN-9C0139	
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow15,g_errno,0)
               LET g_oow.oow15 = g_oow_o.oow15
               DISPLAY BY NAME g_oow.oow15
               NEXT FIELD oow15
            END IF
            LET g_oow_o.oow15 = g_oow.oow15
         END IF
 
       AFTER FIELD oow16
         IF NOT cl_null(g_oow.oow16) THEN
            #CALL s_check_no('axr',g_oow.oow16,"","30","ooa_file","ooa01","")  #FUN-9C0139
            CALL s_check_no('axr',g_oow.oow16,"","17","ooa_file","ooa01","")  #FUN-9C0139
               RETURNING li_result,g_oow.oow16
            IF (NOT li_result) THEN
                  NEXT FIELD oow16
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow16)
            LET g_oow.oow16 = g_t1
            DISPLAY BY NAME g_oow.oow16
            #CALL s020_oow02(g_oow.oow16,'30')   #FUN-9C0139
            CALL s020_oow02(g_oow.oow16,'17')   #FUN-9C0139
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow16,g_errno,0)
               LET g_oow.oow16 = g_oow_o.oow16
               DISPLAY BY NAME g_oow.oow16
               NEXT FIELD oow16
            END IF
            LET g_oow_o.oow16 = g_oow.oow16
         END IF
 
      AFTER FIELD oow17
         IF NOT cl_null(g_oow.oow17) THEN
            CALL s020_oow01(g_oow.oow17,'2')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow17,g_errno,0)
               LET g_oow.oow17 = g_oow_o.oow17
               DISPLAY BY NAME g_oow.oow17
               NEXT FIELD oow17
            END IF
            LET g_oow_o.oow17=g_oow.oow17
         END IF
 
 
       AFTER FIELD oow18
         IF NOT cl_null(g_oow.oow18) THEN
            #MOD-C30422--ADD--STR
            SELECT ooydmy1 INTO g_ooy.ooydmy1 FROM ooy_file WHERE ooyslip=g_oow.oow18
            IF g_ooy.ooydmy1='Y' THEN
               CALL cl_err(g_oow.oow18,'axr002',1)
               NEXT FIELD oow18
            END IF 
            #MOD-C30422--ADD--END
            CALL  s_check_no("axr",g_oow.oow18,"","16","","","")
                   RETURNING li_result,g_oow.oow18
            IF (NOT li_result) THEN
                NEXT FIELD oow18
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow18)
            LET g_oow.oow18 = g_t1
            DISPLAY BY NAME g_oow.oow18
            CALL s020_oow02(g_oow.oow18,'16')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow18,g_errno,0)
               LET g_oow.oow18 = g_oow_o.oow18
               DISPLAY BY NAME g_oow.oow18
               NEXT FIELD oow18
            END IF
            LET g_oow_o.oow18 = g_oow.oow18
         END IF
 
       AFTER FIELD oow19
         IF NOT cl_null(g_oow.oow19) THEN
            CALL s_check_no("axr",g_oow.oow19,"","26","","","")
                 RETURNING li_result,g_oow.oow19
            IF (NOT li_result) THEN
               NEXT FIELD oow19
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow19)
            LET g_oow.oow19 = g_t1
            DISPLAY BY NAME g_oow.oow19
            CALL s020_oow02(g_oow.oow19,'26')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow19,g_errno,0)
               LET g_oow.oow19 = g_oow_o.oow19
               DISPLAY BY NAME g_oow.oow19
               NEXT FIELD oow19
            END IF
            LET g_oow_o.oow19 = g_oow.oow19
         END IF
 
       AFTER FIELD oow20
         IF NOT cl_null(g_oow.oow20) THEN
            #MOD-C30422--ADD---STR
            SELECT ooydmy1 INTO g_ooy.ooydmy1 FROM ooy_file WHERE ooyslip=g_oow.oow20
            IF g_ooy.ooydmy1='Y' THEN
               CALL cl_err(g_oow.oow20,'axr003',1)
               NEXT FIELD oow20
            END IF
            #MOD-C30422--ADD---END
            CALL s_check_no("axr",g_oow.oow20,"","27","","","")
                 RETURNING li_result,g_oow.oow20
            IF (NOT li_result) THEN
                NEXT FIELD oow20
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow20)
            LET g_oow.oow20 = g_t1
            DISPLAY BY NAME g_oow.oow20
            CALL s020_oow02(g_oow.oow20,'27')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow20,g_errno,0)
               LET g_oow.oow20 = g_oow_o.oow20
               DISPLAY BY NAME g_oow.oow20
               NEXT FIELD oow20
            END IF
            LET g_oow_o.oow20 = g_oow.oow20
         END IF
 
       AFTER FIELD oow21
         IF NOT cl_null(g_oow.oow21) THEN
            CALL s020_oow13(g_oow.oow21)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow21,g_errno,0)
               LET g_oow.oow21 = g_oow_o.oow21
               DISPLAY BY NAME g_oow.oow21
               NEXT FIELD oow21
            END IF
            LET g_oow_o.oow21 = g_oow.oow21
         END IF
 
      AFTER FIELD oow22
         IF NOT cl_null(g_oow.oow22) THEN
            CALL s_check_no("anm",g_oow.oow22,g_oow_t.oow22,"2","nmd_file","nmd01","")
                RETURNING li_result,g_oow.oow22
            IF (NOT li_result) THEN
              NEXT FIELD oow22
            END IF
            LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow22)
            LET g_oow.oow22 = g_t1
            DISPLAY BY NAME g_oow.oow22
            CALL s020_oow06(g_oow.oow22,'2')
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err(g_oow.oow22,g_errno,0)
               LET g_oow.oow22 = g_oow_o.oow22
               DISPLAY BY NAME g_oow.oow22
               NEXT FIELD oow22
            END IF
            LET g_oow_o.oow22 = g_oow.oow22
         END IF
 
       AFTER FIELD oow23
        IF NOT cl_null(g_oow.oow23) THEN
           CALL s020_oow23(g_oow.oow23)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_oow.oow23,g_errno,0)
              LET g_oow.oow23 = g_oow_o.oow23
              DISPLAY BY NAME g_oow.oow23
              NEXT FIELD oow23
           END IF
           LET g_oow_o.oow23 = g_oow.oow23
        END IF
 
       AFTER FIELD oow24
        IF NOT cl_null(g_oow.oow24) THEN
           CALL s020_oow24(g_oow.oow24)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_oow.oow24,g_errno,0)
              LET g_oow.oow24 = g_oow_o.oow24
              DISPLAY BY NAME g_oow.oow24
              NEXT FIELD oow24
           END IF
           LET g_oow_o.oow24 = g_oow.oow24
        END IF
 
       AFTER FIELD oow25
        IF NOT cl_null(g_oow.oow25) THEN
           CALL s020_oow25(g_oow.oow25)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_oow.oow25,g_errno,0)
              LET g_oow.oow25 = g_oow_o.oow25
              DISPLAY BY NAME g_oow.oow25
              NEXT FIELD oow25
           END IF
           LET g_oow_o.oow25 = g_oow.oow25
        END IF
 
       AFTER FIELD oow26
        IF NOT cl_null(g_oow.oow26) THEN
           CALL  s_check_no("axr",g_oow.oow26,"","22","","","")
                   RETURNING li_result,g_oow.oow26
           IF (NOT li_result) THEN
               NEXT FIELD oow26
           END IF
           LET g_t1 = NULL
            LET g_t1 = s_get_doc_no(g_oow.oow26)
            LET g_oow.oow26 = g_t1
           DISPLAY BY NAME g_oow.oow26
           CALL s020_oow02(g_oow.oow26,'22')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_oow.oow26,g_errno,0)
              LET g_oow.oow26 = g_oow_o.oow26
              DISPLAY BY NAME g_oow.oow26
              NEXT FIELD oow26
           END IF
           LET g_oow_o.oow26 = g_oow.oow26
        END IF
 
       AFTER FIELD oow27
         IF NOT cl_null(g_oow.oow27) THEN
            CALL s020_oow13(g_oow.oow27)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_oow.oow27,g_errno,0)
               LET g_oow.oow27  = g_oow_o.oow27
               DISPLAY BY NAME g_oow.oow27
               NEXT FIELD oow27
            END IF
         END IF
         LET g_oow_o.oow27 = g_oow.oow27
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oow01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_nmc02'
               LET g_qryparam.arg1 = '1'
               LET g_qryparam.default1 =g_oow.oow01
               CALL cl_create_qry() RETURNING g_oow.oow01
               DISPLAY BY NAME g_oow.oow01
               NEXT FIELD oow01
 
            WHEN INFIELD(oow02)
               LET g_t1 = NULL
               CALL q_ooy( FALSE, TRUE, g_oow.oow02,'15','AXR')
               RETURNING g_t1
               LET g_oow.oow02 = g_t1
               DISPLAY BY NAME g_oow.oow02
               NEXT FIELD oow02
 
            WHEN INFIELD(oow03)
               LET g_t1 = NULL
               CALL q_ooy( FALSE, TRUE, g_oow.oow03,'17','AXR')
               RETURNING g_t1
               LET g_oow.oow03 = g_t1
               DISPLAY BY NAME g_oow.oow03
               NEXT FIELD oow03
 
            WHEN INFIELD(oow04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_nmc02'
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.default1 =g_oow.oow04
               CALL cl_create_qry() RETURNING g_oow.oow04
               DISPLAY BY NAME g_oow.oow04
               NEXT FIELD oow04
 
            WHEN INFIELD(oow05)
               LET g_t1 = NULL
               #CALL q_ooy( FALSE, TRUE, g_oow.oow05,'30','AXR')   #FUN-9C0139
               CALL q_ooy( FALSE, TRUE, g_oow.oow05,'32','AXR')   #FUN-9C0139
               RETURNING g_t1
               LET g_oow.oow05 = g_t1
               DISPLAY BY NAME g_oow.oow05
               NEXT FIELD oow05
 
            WHEN INFIELD(oow06)
               LET g_t1 = NULL
               LET g_t1 = s_get_doc_no(g_oow.oow06)
               CALL q_nmy2(FALSE,TRUE,g_t1,'3','ANM') RETURNING g_t1
               LET g_oow.oow06 = g_t1
               DISPLAY BY NAME g_oow.oow06
               NEXT FIELD oow06
 
            WHEN INFIELD(oow07)
               LET g_t1 = NULL
               #CALL q_ooy( FALSE, TRUE, g_oow.oow07,'30','AXR')   #FUN-9C0139
               CALL q_ooy( FALSE, TRUE, g_oow.oow07,'32','AXR')   #FUN-9C0139
               RETURNING g_t1
               LET g_oow.oow07 = g_t1
               DISPLAY BY NAME g_oow.oow07
               NEXT FIELD oow07
 
            WHEN INFIELD(oow08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_nmc02'
               LET g_qryparam.arg1 = '1'
               LET g_qryparam.default1 =g_oow.oow08
               CALL cl_create_qry() RETURNING g_oow.oow08
               DISPLAY BY NAME g_oow.oow08
               NEXT FIELD oow08
 
             WHEN INFIELD(oow09)
               LET g_t1 = NULL
               CALL q_ooy( FALSE, TRUE, g_oow.oow09,'18','AXR')
               RETURNING g_t1
               LET g_oow.oow09 = g_t1
               DISPLAY BY NAME g_oow.oow09
               NEXT FIELD oow09
           
            WHEN INFIELD(oow10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_nmc02'
               LET g_qryparam.arg1 = '1'
               LET g_qryparam.default1 =g_oow.oow10
               CALL cl_create_qry() RETURNING g_oow.oow10
               DISPLAY BY NAME g_oow.oow10
               NEXT FIELD oow10
 
            WHEN INFIELD(oow11)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_nmc02'
               LET g_qryparam.arg1 = '1'
               LET g_qryparam.default1 =g_oow.oow11
               CALL cl_create_qry() RETURNING g_oow.oow11
               DISPLAY BY NAME g_oow.oow11
               NEXT FIELD oow11
 
            WHEN INFIELD(oow12)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_nmc02'
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.default1 =g_oow.oow12
               CALL cl_create_qry() RETURNING g_oow.oow12
               DISPLAY BY NAME g_oow.oow12
               NEXT FIELD oow12
 
             WHEN INFIELD(oow13)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_nma'
               LET g_qryparam.default1 =g_oow.oow13
               CALL cl_create_qry() RETURNING g_oow.oow13
               DISPLAY BY NAME g_oow.oow13
               NEXT FIELD oow13
 
             WHEN INFIELD(oow14)
               LET g_t1 = NULL
               CALL q_ooy( FALSE, TRUE, g_oow.oow14,'30','AXR')
               RETURNING g_t1
               LET g_oow.oow14 = g_t1
               DISPLAY BY NAME g_oow.oow14
               NEXT FIELD oow14
 
             WHEN INFIELD(oow15)
               LET g_t1 = NULL
               #CALL q_ooy( FALSE, TRUE, g_oow.oow15,'30','AXR')   #FUN-9C0139
               CALL q_ooy( FALSE, TRUE, g_oow.oow15,'32','AXR')   #FUN-9C0139
               RETURNING g_t1
               LET g_oow.oow15 = g_t1
               DISPLAY BY NAME g_oow.oow15
               NEXT FIELD oow15
 
             WHEN INFIELD(oow16)
               LET g_t1 = NULL
               #CALL q_ooy( FALSE, TRUE, g_oow.oow16,'30','AXR')   #FUN-9C0139
               CALL q_ooy( FALSE, TRUE, g_oow.oow16,'17','AXR')   #FUN-9C0139
               RETURNING g_t1
               LET g_oow.oow16 = g_t1
               DISPLAY BY NAME g_oow.oow16
               NEXT FIELD oow16
 
            WHEN INFIELD(oow17)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_nmc02'
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.default1 =g_oow.oow17
               CALL cl_create_qry() RETURNING g_oow.oow17
               DISPLAY BY NAME g_oow.oow17
               NEXT FIELD oow17
 
             WHEN INFIELD(oow18)
               LET g_t1 = NULL
               CALL q_ooy( FALSE, TRUE, g_oow.oow18,'16','AXR')
               RETURNING g_t1
               LET g_oow.oow18 = g_t1
               DISPLAY BY NAME g_oow.oow18
               NEXT FIELD oow18
 
             WHEN INFIELD(oow19)
               LET g_t1 = NULL
               CALL q_ooy( FALSE, TRUE, g_oow.oow19,'26','AXR')
               RETURNING g_t1
               LET g_oow.oow19 = g_t1
               DISPLAY BY NAME g_oow.oow19
               NEXT FIELD oow19
 
             WHEN INFIELD(oow20)
               LET g_t1 = NULL
               CALL q_ooy( FALSE, TRUE, g_oow.oow20,'27','AXR')
               RETURNING g_t1
               LET g_oow.oow20 = g_t1
               DISPLAY BY NAME g_oow.oow20
               NEXT FIELD oow20
 
             WHEN INFIELD(oow21)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_nma'
               LET g_qryparam.default1 =g_oow.oow21
               CALL cl_create_qry() RETURNING g_oow.oow21
               DISPLAY BY NAME g_oow.oow21
               NEXT FIELD oow21
 
             WHEN INFIELD(oow22)
               LET g_t1 = NULL
               CALL q_nmy2( FALSE,TRUE,g_oow.oow22,'2','ANM')
               RETURNING g_t1
               LET g_oow.oow22 = g_t1
               DISPLAY BY NAME g_oow.oow22
               NEXT FIELD oow22
 
            WHEN INFIELD(oow23)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_nml'
               LET g_qryparam.default1 = g_oow.oow23
               CALL cl_create_qry() RETURNING g_oow.oow23
               DISPLAY BY NAME g_oow.oow23
               NEXT FIELD oow23
 
            WHEN INFIELD(oow24)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_gem'
               LET g_qryparam.default1 = g_oow.oow24
               CALL cl_create_qry() RETURNING g_oow.oow24
               DISPLAY BY NAME g_oow.oow24
               NEXT FIELD oow24
 
            WHEN INFIELD(oow25)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_azi'
              LET g_qryparam.default1 = g_oow.oow25
              CALL cl_create_qry() RETURNING g_oow.oow25
              DISPLAY BY NAME g_oow.oow25
              NEXT FIELD oow25
 
             WHEN INFIELD(oow26)
               LET g_t1 = NULL
               CALL q_ooy( FALSE, TRUE, g_oow.oow26,'22','AXR')
               RETURNING g_t1
               LET g_oow.oow26 = g_t1
               DISPLAY BY NAME g_oow.oow26
               NEXT FIELD oow26
 
             WHEN INFIELD(oow27)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_nma'
               LET g_qryparam.default1 =g_oow.oow27
               CALL cl_create_qry() RETURNING g_oow.oow27
               DISPLAY BY NAME g_oow.oow27
               NEXT FIELD oow27
       END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
 
   END INPUT
END FUNCTION
 
FUNCTION s020_oow01(p_code,p_flag)
  DEFINE    p_code     LIKE oow_file.oow10
  DEFINE    p_flag     LIKE type_file.chr1
  DEFINE    l_nmcacti  LIKE nmc_file.nmcacti
  DEFINE    l_nmc03    LIKE nmc_file.nmc03
 
  LET g_errno = ""
  SELECT nmcacti,nmc03 INTO l_nmcacti,l_nmc03 FROM nmc_file
      WHERE nmc01 = p_code
 
  CASE WHEN l_nmcacti = 'N'     LET g_errno = 'axr-092'
       WHEN (l_nmc03 <> '1'  AND  p_flag = '1' )
                                LET g_errno = 'anm-334'
       WHEN (l_nmc03 <> '2'  AND  p_flag = '2' )
                                LET g_errno = 'anm-333'
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'agl-153'
       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
FUNCTION  s020_oow02(p_code,p_flag)
    DEFINE    p_code     LIKE  oow_file.oow02
    DEFINE    p_flag     LIKE  ooy_file.ooytype
    DEFINE    l_ooyacti  LIKE  ooy_file.ooyacti
    DEFINE    l_ooytype  LIKE  ooy_file.ooytype
 
    LET g_errno = ''
    SELECT ooyacti,ooytype INTO l_ooyacti,l_ooytype
      FROM ooy_file
     WHERE ooyslip = p_code
  
    CASE WHEN  l_ooyacti = 'N'      LET  g_errno = 'axr-956'
         WHEN  l_ooytype<>p_flag    LET  g_errno = 'aap-009'
         WHEN  SQLCA.SQLCODE = 100  LET g_errno = 'aap-010'
         OTHERWISE                  LET  g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION s020_oow06(p_code,p_kind)
  DEFINE    p_code      LIKE   oow_file.oow06
  DEFINE    p_kind      LIKE   nmy_file.nmykind
  DEFINE    l_nmykind   LIKE   nmy_file.nmykind
  DEFINE    l_nmyacti   LIKE   nmy_file.nmyacti
  DEFINE    l_nmydmy3   LIKE   nmy_file.nmydmy3
 
 
  LET g_errno = ''
  SELECT nmykind,nmyacti,nmydmy3 INTO l_nmykind,l_nmyacti,l_nmydmy3
    FROM nmy_file
   WHERE nmyslip = p_code
 
  CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'aap-010'
       WHEN l_nmyacti = 'N'        LET g_errno = 'axr-956'
       WHEN l_nmykind <> p_kind    LET g_errno = 'aap-009'
       WHEN l_nmydmy3 = 'Y'        LET g_errno = 'axr-161'
       OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
FUNCTION s020_oow13(p_code)
  DEFINE l_nmaacti       LIKE  nma_file.nmaacti
  DEFINE p_code          LIKE  nma_file.nma01
 
  LET g_errno = ''
  SELECT nmaacti INTO l_nmaacti FROM nma_file
     WHERE nma01  = p_code
 
   CASE WHEN   SQLCA.SQLCODE = 100   LET  g_errno = 'aap-007'
        WHEN   l_nmaacti = 'N'       LET  g_errno = 'axr-093'
        OTHERWISE                LET  g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
FUNCTION s020_oow23(p_code)
  DEFINE p_code        LIKE  oow_file.oow23
  DEFINE l_nmlacti     LIKE  nml_file.nmlacti
  DEFINE l_nml01       LIKE  nml_file.nml01
 
  LET g_errno = ''
  SELECT  nml01,nmlacti INTO l_nml01,l_nmlacti FROM nml_file
    WHERE nml01 = p_code
 
  CASE WHEN SQLCA.sqlcode = 100  LET g_errno = 'anm-140'
       WHEN l_nmlacti = 'N'      LET g_errno = 'axr-097'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
FUNCTION s020_oow24(p_code)
  DEFINE    p_code        LIKE  oow_file.oow24
  DEFINE    l_gem01       LIKE  gem_file.gem01
  DEFINE    l_gemacti     LIKE  gem_file.gemacti
 
  LET g_errno = ''
  SELECT gem01,gemacti INTO l_gem01,l_gemacti FROM gem_file
    WHERE gem01 = p_code
 
  CASE WHEN SQLCA.sqlcode = 100  LET g_errno = 'aap-039'
       WHEN l_gemacti = 'N'      LET g_errno = 'asf-472'
       OTHERWISE                 LET  g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
FUNCTION s020_oow25(p_code)
  DEFINE   p_code      LIKE oow_file.oow25
  DEFINE   l_azi01     LIKE azi_file.azi01
  DEFINE   l_aziacti   LIKE azi_file.aziacti
 
  LET g_errno = ''
  SELECT azi01,aziacti  INTO l_azi01,l_aziacti FROM azi_file
   WHERE azi01 = p_code
 
  CASE WHEN SQLCA.sqlcode = 100  LET g_errno = 'aap-002'
       WHEN l_aziacti = 'N'      LET g_errno = 'ggl-998'
       OTHERWISE                 LET  g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
#FUN-960140--add
