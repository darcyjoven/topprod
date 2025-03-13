# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abar300.4gl
# Descriptions...: 交接單列印作業
# Date & Author..: No:DEV-CB0017 2012/11/20 By TSD.JIE
# Modify.........: No.DEV-D30025 2013/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---

DATABASE ds

GLOBALS "../..//config/top.global"

DEFINE tm   RECORD
            wc       STRING,
            wc1      STRING,
            a        LIKE type_file.chr1,
            more     LIKE type_file.chr1
            END RECORD
DEFINE g_i        LIKE type_file.num5
DEFINE g_str      STRING
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE l_table1   STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF


   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql=" ibf01.ibf_file.ibf01,",   #交接單號
             " ibf03.ibf_file.ibf03,",   #班別
             " ibf04.ibf_file.ibf04,",   #異動日期
             " ibf06.ibf_file.ibf06,",   #訂單單號
             " ibf07.ibf_file.ibf07,",   #料號

             " ima02.ima_file.ima02,",   #品名
             " ima021.ima_file.ima021,", #規格
             " oea04.oea_file.oea04,",   #客戶
             " occ02.occ_file.occ02 "    #客戶名稱

   LET l_table = cl_prt_temptable('abar300',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF

   LET g_sql=" ibg01.ibg_file.ibg01,",   #交接單號
             " ibg02.ibg_file.ibg02,",   #項次
             " ibg04.ibg_file.ibg04,",   #條碼編號
             " ibg05.ibg_file.ibg05,",   #數量
             " ima02.ima_file.ima02,",   #品名
             " ima021.ima_file.ima021 "  #規格

   LET l_table1 = cl_prt_temptable('abar3001',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF


   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1) EXIT PROGRAM
   END IF


   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_rep_user = ARG_VAL(7)
   LET g_rep_clas = ARG_VAL(8)
   LET g_template = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)
   LET tm.wc    = ARG_VAL(11)

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL abar300_tm(0,0)        # Input print condition
   ELSE
      CALL abar300()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION abar300_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000

   LET p_row = 4 LET p_col = 16
   OPEN WINDOW abar300_w AT p_row,p_col WITH FORM "aba/42f/abar300"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON iba01,ibf03,ibf04,ibf05,ibf06,ibf07

            
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(iba01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                   #LET g_qryparam.form = "q_tc_iba"
                    LET g_qryparam.form = "q_iba02"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO iba01
                    NEXT FIELD iba01
               WHEN INFIELD(ibf05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                   #LET g_qryparam.form = "cq_sfb02"
                    LET g_qryparam.form = "q_sfb32"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ibf05
                    NEXT FIELD ibf05
               WHEN INFIELD(ibf06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_oea03"
                    LET g_qryparam.where = "oea00 <> '0'"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ibf06
                    NEXT FIELD ibf06
               WHEN INFIELD(ibf07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_ima"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ibf07
                    NEXT FIELD ibf07
            END CASE

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION CONTROLG
            CALL cl_cmdask()    #No.TQC-740008 add

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_select()
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW abar300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
      INPUT BY NAME tm.more WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

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
         LET INT_FLAG = 0 CLOSE WINDOW abar300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL abar300()
      ERROR ""
   END WHILE
   CLOSE WINDOW abar300_w
END FUNCTION


FUNCTION abar300()
   DEFINE sr    RECORD
             ibf01      LIKE ibf_file.ibf01,   #交接單號
             ibf03      LIKE ibf_file.ibf03,   #班別
             ibf04      LIKE ibf_file.ibf04,   #異動日期
             ibf06      LIKE ibf_file.ibf06,   #訂單單號
             ibf07      LIKE ibf_file.ibf07,   #料號
             ima02      LIKE ima_file.ima02,   #品名
             ima021     LIKE ima_file.ima021,  #規格
             oea04      LIKE oea_file.oea04,   #客戶
             occ02      LIKE occ_file.occ02    #客戶名稱
                END RECORD 
   DEFINE sr1   RECORD
             ibg01      LIKE ibg_file.ibg01,   #交接單號
             ibg02      LIKE ibg_file.ibg02,   #項次
             ibg04      LIKE ibg_file.ibg04,   #條碼編號
             ibg05      LIKE ibg_file.ibg05,   #數量
             ima02      LIKE ima_file.ima02,   #品名
             ima021     LIKE ima_file.ima021   #規格
                END RECORD 
   DEFINE l_ibf      RECORD LIKE ibf_file.*
   DEFINE l_ibg      RECORD LIKE ibg_file.*
   DEFINE l_ibb      RECORD LIKE ibb_file.*

   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)

   LET g_sql = "SELECT ibf_file.*",
               "  FROM iba_file,ibf_file ",
               " WHERE iba01 = ibf01",
               "   AND ",tm.wc

   PREPARE r300_p1 FROM g_sql
   IF STATUS THEN CALL cl_err('r300_p1',STATUS,0) END IF
   DECLARE r300_cs CURSOR FOR r300_p1


   LET g_sql = "SELECT ibb_file.*,ibg_file.*",
               "  FROM ibb_file,ibg_file ",
               " WHERE ibb01 = ibg04",
               "   AND ibg01 = ?"

   PREPARE r300_p2 FROM g_sql
   IF STATUS THEN CALL cl_err('r300_p2',STATUS,0) END IF
   DECLARE r300_cs2 CURSOR FOR r300_p2


   FOREACH r300_cs INTO l_ibf.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:r300_cs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      INITIALIZE sr.* TO NULL
      LET sr.ibf01  = l_ibf.ibf01    #交接單號
      LET sr.ibf03  = l_ibf.ibf03    #班別
      LET sr.ibf04  = l_ibf.ibf04    #異動日期
      LET sr.ibf06  = l_ibf.ibf06    #訂單單號
      LET sr.ibf07  = l_ibf.ibf07    #料號

      SELECT ima02,ima021
        INTO sr.ima02,sr.ima021
        FROM ima_file
       WHERE ima01 = l_ibf.ibf07

      SELECT oea04,occ02
        INTO sr.oea04,sr.occ02
        FROM oea_file LEFT JOIN occ_file ON occ01 = oea04
       WHERE oea01 = l_ibf.ibf06

      FOREACH r300_cs2 USING sr.ibf01 INTO l_ibb.*,l_ibg.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:r300_cs',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         INITIALIZE sr1.* TO NULL
         LET sr1.ibg01 = sr.ibf01       #交接單號
         LET sr1.ibg02 = l_ibg.ibg02    #項次
         LET sr1.ibg04 = l_ibg.ibg04    #條碼編號
         LET sr1.ibg05 = l_ibg.ibg05    #數量
     
         SELECT ima02,ima021
           INTO sr1.ima02,sr1.ima021
           FROM ima_file
          WHERE ima01 = l_ibb.ibb06
     
         EXECUTE insert_prep1 USING sr1.*
      END FOREACH
      EXECUTE insert_prep USING sr.*
   END FOREACH


   LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED

   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'iba01,ibf03,ibf04,ibf05,ibf06,ibf07')
         RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF

   LET g_str = tm.wc
    CALL cl_prt_cs3('abar300','abar300',g_sql,g_str)

END FUNCTION
#No:DEV-CB0017--add
#DEV-D30025--add
