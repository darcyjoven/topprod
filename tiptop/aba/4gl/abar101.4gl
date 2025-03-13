# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abar101.4gl
# Descriptions...: 倉儲條碼列印作業
# Date & Author..: No:DEV-CB0004 2012/11/08 By TSD.JIE
# Modify.........: No.DEV-D30025 2013/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
           wc      STRING,
           more    LIKE type_file.chr1
              END RECORD
DEFINE g_i             LIKE type_file.num5
DEFINE g_sql           STRING
DEFINE g_str           STRING
DEFINE l_table         STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql = " imd01.imd_file.imd01,",   #倉庫
               " imd02.imd_file.imd02,",   #倉庫名稱
               " ime02.ime_file.ime02,",   #儲位
               " ime03.ime_file.ime03 "    #儲位名稱
   LET l_table = cl_prt_temptable('abar101',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF


   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL abar101_tm(0,0)        # Input print condition
   ELSE
      CALL abar101()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN

FUNCTION abar101_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd        LIKE type_file.chr1000

   LET p_row = 6 LET p_col = 16

   OPEN WINDOW abar101_w AT p_row,p_col WITH FORM "aba/42f/abar101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON imd01,ime02

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            LET g_action_choice = NULL
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(imd01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_imd"
                 LET g_qryparam.arg1  = 'SW'
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imd01
                 NEXT FIELD imd01
              WHEN INFIELD(ime02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ime"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ime02
                 NEXT FIELD ime02
            END CASE


         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_select()


      END CONSTRUCT

      IF g_action_choice = "locale" THEN
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW abar101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM

      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      INPUT BY NAME tm.more WITHOUT DEFAULTS

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   #FUN-550037(smin)
            LET g_action_choice = "locale"

         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION CONTROLZ
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

        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW abar101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='abar101'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abar101','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                             " '",g_rlang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                             " '",g_rep_user CLIPPED,"'",
                             " '",g_rep_clas CLIPPED,"'",
                             " '",g_template CLIPPED,"'",
                             " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('abar101',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW abar101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL abar101()
      ERROR ""
   END WHILE
   CLOSE WINDOW abar101_w
END FUNCTION

FUNCTION abar101()
   DEFINE l_sql     STRING,
          sr        RECORD
               imd01        LIKE imd_file.imd01,   #倉庫
               imd02        LIKE imd_file.imd02,   #倉庫名稱
               ime02        LIKE ime_file.ime02,   #儲位
               ime03        LIKE ime_file.ime03    #儲位名稱
                    END RECORD

   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

   LET l_sql = "SELECT imd01,imd02,ime02,ime03",
               "  FROM imd_file,ime_file ",
               " WHERE ",tm.wc,
               "   AND imd01 = ime01 "
   PREPARE r101_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r101_curs1 CURSOR FOR r101_prepare1

   FOREACH r101_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF

      EXECUTE insert_prep USING sr.*
   END FOREACH


   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'imd01,ime02')
         RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF
   LET g_str = tm.wc
   CALL cl_prt_cs3('abar101','abar101',g_sql,g_str)
END FUNCTION
#DEV-CB0004--add
#DEV-D30025--add
