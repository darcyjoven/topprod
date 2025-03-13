# Prog. Version..: '5.30.07-13.04.01(00001)'     #
#
# Pattern name...: aglp101.4gl
# Descriptions...: 合併報表關帳作業
# Input parameter:
# Return code....:
# Date & Author..: 13/03/21 BY Lori(FUN-D20046)

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
   tm        RECORD
             axa01  LIKE axa_file.axa01,
             bookno LIKE aaz_file.aaz641,
             aaz642 LIKE aaz_file.aaz642
             END RECORD
DEFINE l_flag           LIKE type_file.chr1,
       g_change_lang    LIKE type_file.chr1

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL

   LET tm.axa01  = ARG_VAL(1)
   LET tm.bookno = ARG_VAL(2)
   LET tm.aaz642 = ARG_VAL(3)
   LET g_bgjob   = ARG_VAL(4)

   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   WHILE TRUE
      CALL s_showmsg_init()
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL aglp101_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            CALL saglp101(tm.axa01,tm.bookno,tm.aaz642)
            CALL s_showmsg()
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW aglp101_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success = 'Y'
         CALL saglp101(tm.axa01,tm.bookno,tm.aaz642)
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END  IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION aglp101_tm(p_row,p_col)
   DEFINE  p_row,p_col     LIKE type_file.num5,        #smallint
           l_str           LIKE ze_file.ze03,          #VARCHAR(30)
           l_flag          LIKE type_file.chr1         #VARCHAR(1)
   DEFINE  lc_cmd          LIKE type_file.chr1000      #VARCHAR(500)

   CALL s_dsmark(tm.bookno)

   LET p_row = 4 LET p_col = 26

   OPEN WINDOW aglp101_w AT p_row,p_col WITH FORM "agl/42f/aglp101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()

   CALL  s_shwact(0,0,tm.bookno)

   INITIALIZE tm.* TO NULL

   WHILE TRUE
      IF s_aglshut(0) THEN RETURN END IF
      CLEAR FORM
      LET g_bgjob = 'N'
      LET tm.bookno = g_aaz.aaz641
      DISPLAY g_aaz.aaz641 TO bookno

      INPUT BY NAME tm.axa01,tm.aaz642,g_bgjob WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_init()

         AFTER FIELD axa01
            IF cl_null(tm.axa01) THEN
               NEXT FIELD axa01
            END IF
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,"","agl-11","","",1)
                  NEXT FIELD axa01
               END IF
            END IF

         AFTER FIELD aaz642
            IF tm.aaz642  IS NULL OR tm.aaz642 = ' ' THEN
               NEXT FIELD aaz642
            END IF


         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT

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

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa5"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01
                  DISPLAY BY NAME tm.axa01
                  NEXT FIELD axa01
            END CASE

      END INPUT

     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        CONTINUE WHILE
     END IF

     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW aglp101_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF

     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'aglp101'
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aglp101','9031',1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " ''",
                        " '",tm.bookno CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('aglp101',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW aglp101_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     EXIT WHILE

   END WHILE
END FUNCTION
#FUN-D20046

