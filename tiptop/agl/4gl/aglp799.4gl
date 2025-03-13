# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglp799.4gl
# Descriptions...: 帳別傳票拋轉記錄檔批次寫入作業aglp799
# Date & Author..: 12/07/24 By Lori  #FUN-C40112
# Modify.........: No.CHI-CC0005 12/12/04 By Lori action錯誤:controlz應改為controlr

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5
DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   l_flag          LIKE type_file.chr1
DEFINE   g_change_lang   LIKE type_file.chr1
DEFINE   ls_date         STRING
DEFINE   g_more          LIKE type_file.chr1
DEFINE   g_sql           STRING
DEFINE   g_dbs_gl        LIKE type_file.chr21

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF s_aglshut(0) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_bgjob     = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   WHILE TRUE
      CALL s_showmsg_init()
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL p799_tm()
         BEGIN WORK
         CALL p799()
         IF g_success='Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag    #批次作業正確結束
         ELSE
            CALL s_showmsg() 
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag    #批次作業失敗
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW aglp799_w
            EXIT WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p799()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            CALL s_showmsg() 
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p799_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680098 SMALLINT
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白  #No.FUN-680098  char(1)
          l_cmd          LIKE type_file.chr1000,       #No.FUN-680098   char(400)
          lc_cmd         LIKE type_file.chr1000#NO.FUN-570145   #No.FUN-680098   char(400)
   DEFINE li_chk_bookno LIKE type_file.num5       #No.FUN-670005   #No.FUN-680098  smallint
 
   LET p_row = 2 LET p_col = 26

   OPEN WINDOW p799_w AT p_row,p_col WITH FORM "agl/42f/aglp799"
      ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('p')
   LET g_bgjob = "N"

   INPUT BY NAME g_bgjob WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_bgjob = "N"
         DISPLAY g_bgjob TO bgjob

     #ON ACTION CONTROLZ    #CHI-CC0005 mark
      ON ACTION CONTROLR    #CHI-CC0005 add
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION locale
         LET g_change_lang = TRUE 
      ON ACTION about                    
         CALL cl_about()                 
      ON ACTION help                     
         CALL cl_show_help()             
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT

   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p799_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'aglp799'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aglp799','9031',1)
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_bgjob CLIPPED, "'"
         CALL cl_cmdat('aglp799',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p799_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
END FUNCTION

FUNCTION p799()
   DEFINE l_abm   RECORD LIKE abm_file.*
   DEFINE l_aba   RECORD
            aba00 LIKE aba_file.aba00,
            aba01 LIKE aba_file.aba01,
            aba16 LIKE aba_file.aba16,
            aba17 LIKE aba_file.aba17
                  END RECORD
   DEFINE l_cnt   LIKE type_file.num5,
          l_scnt  LIKE type_file.num5,    #成功筆數
          l_ecnt  LIKE type_file.num5     #失敗筆數
   DEFINE i       LIKE type_file.num5
   DEFINE l_db    LIKE type_file.chr8

   LET l_cnt  = 0
   LET l_scnt = 0
   LET l_ecnt = 0

   LET l_abm.abm07 = g_today
   LET l_abm.abm08 = time(current)
   LET l_abm.abm09 = g_user
   
   WHILE TRUE

      LET g_sql = "SELECT COUNT(*) ",
                  "  FROM aba_file",
                  " WHERE aba01 NOT IN (SELECT  abm03 FROM abm_file",
                  "                     WHERE aba00 = abm02 AND aba01 = abm03",
                  "                       AND aba16 = abm05 AND aba17 = abm06",
                  "                       AND abm01 = '",g_plant,"')",
                  "   AND aba16 IS NOT NULL AND aba17 IS NOT NULL" 
                      
      PREPARE p799_pre FROM g_sql
      DECLARE p799_cur CURSOR FOR p799_pre
      OPEN p799_cur
      FETCH p799_cur INTO l_cnt
      DISPLAY 'Total Records:',l_cnt
      IF l_cnt = 0 THEN
         EXIT WHILE
      END IF

      LET l_abm.abm01 = g_plant
      LET l_abm.abm04 = g_plant


      LET g_sql = "SELECT aba00,aba01,aba16,aba17",
                  "  FROM aba_file",
                  " WHERE aba01 NOT IN (SELECT  abm03 FROM abm_file",
                  "                     WHERE aba00 = abm02 AND aba01 = abm03",
                  "                       AND aba16 = abm05 AND aba17 = abm06",
                  "                       AND abm01 = '",g_plant,"')",
                  "   AND aba16 IS NOT NULL AND aba17 IS NOT NULL"

      PREPARE p799_pre_01 FROM g_sql
      DECLARE p799_cur_01 CURSOR FOR p799_pre_01
      FOREACH p799_cur_01 INTO l_aba.*
         LET l_abm.abm02 = l_aba.aba00
         LET l_abm.abm03 = l_aba.aba01
         LET l_abm.abm05 = l_aba.aba16
         LET l_abm.abm06 = l_aba.aba17
         INSERT INTO abm_file VALUES(l_abm.*)
         IF STATUS THEN
            IF STATUS THEN
               LET l_ecnt = l_ecnt + 1
               LET g_showmsg=l_aba.aba00,"/" ,l_aba.aba01
               CALL s_errmsg('abb00,abb01',g_showmsg,'agl1053',STATUS,1)
               LET g_success='N'
            ELSE
               CALL cl_err3("ins","abm_file",l_aba.aba00,l_aba.aba01,STATUS,"agl1053","INSERT abm",0)
               LET g_success='N'
            END IF
         ELSE
            LET l_scnt = l_scnt + 1
            LET g_success='Y'
         END IF
         IF (l_scnt + l_ecnt) > l_cnt THEN
            EXIT FOREACH
         END IF
      END FOREACH
      EXIT WHILE
   END WHILE   

   IF l_cnt = 0 THEN
      LET l_scnt = 0
      LET l_ecnt = 0
      LET g_success='Y'
   ELSE
      IF (l_scnt + l_ecnt) < l_cnt THEN
         LET l_scnt = 0 
         LET l_ecnt = l_cnt
      END IF
   END IF

   CALL cl_err_msg("","agl1013",l_scnt CLIPPED|| "|" || l_ecnt CLIPPED,0)

END FUNCTION
#FUN-C40112

