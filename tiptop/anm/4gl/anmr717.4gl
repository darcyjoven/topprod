# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: anmr717.4gl
# Descriptions...: 短期貸款還款明細表
# Input parameter:
# Return code....:
# Date & Author..: #FUN-A30069 10/04/23 By chenmoyan
# Modify.........: No:CHI-A60020 10/06/15 By Summer nne30改為nne01
# Modify.........: No.TQC-A70079 10/07/16 By Dido 增加排序 nne01 
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-C20136 12/02/17 By Polly 1.排除已作廢的單據
#                                                  2.l_sql型態改為STRING

DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD		      	     # Print condition RECORD
              wc    STRING,                  #Where Condiction
	      nne03_1 LIKE nne_file.nne03,   #動用日範圍
	      nne03_2 LIKE nne_file.nne03,
	      edate   LIKE type_file.dat,    
              a       LIKE type_file.chr1,   #'1'列印明細,'2'列印彙總
              b       LIKE type_file.chr1,   #(1)已結案  (2)未結案 (3)全部
              more    LIKE type_file.chr1    #是否列印其它條件
              END RECORD
   DEFINE g_nne12_tot LIKE nne_file.nne12
   DEFINE g_nne19_tot LIKE nne_file.nne19

   DEFINE g_i         LIKE type_file.num5    #count/index for any purpose
   DEFINE g_head1     STRING
   DEFINE g_sql      STRING
   DEFINE l_table    STRING
   DEFINE l_table1   STRING
   DEFINE l_table2   STRING
   DEFINE g_str      STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time


   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.nne03_1= ARG_VAL(8)
   LET tm.nne03_2= ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)
   LET tm.a= ARG_VAL(11)
   LET tm.b= ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)

   LET g_sql = "nne01.nne_file.nne01,",
              #"nne30.nne_file.nne30,",  #CHI-A60020 mark
               "nne04.nne_file.nne04,",
               "nne07.nne_file.nne07,",
               "nne16.nne_file.nne16,",
               "nne12.nne_file.nne12,",
               "nne19.nne_file.nne19,",
               "nne14.nne_file.nne14,",
               "nnl14.nnl_file.nnl13,", #CHI-A60020 mod nnl14->nnl13
               "nnk02.nnk_file.nnk02,",
               "nnkconf.nnk_file.nnkconf,",
               "alg02.alg_file.alg02,",
               "l_nmd26_tot.nmd_file.nmd26,",
               "l_nmd26_tot1.nmd_file.nmd26,",
               "t_azi04.azi_file.azi04,",
               "l_date.type_file.chr20,", #CHI-A60020 mod
               "l_nnl14_tot.nnl_file.nnl13"  #CHI-A60020 add
   LET l_table = cl_prt_temptable('anmr717',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "nmd02.nmd_file.nmd02,",
               "nmd05.nmd_file.nmd05,",
               "nmd10.nmd_file.nmd10,",
               "nmd26.nmd_file.nmd26"
   LET l_table1 = cl_prt_temptable('anmr7171',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "nnl01.nnl_file.nnl01,",
               "nnl04.nnl_file.nnl04,",
               "nnl14.nnl_file.nnl13" #CHI-A60020 mod nnl14->nnl13 
   LET l_table2 = cl_prt_temptable('anmr7172',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr717_tm()	        	# Input print condition
      ELSE CALL anmr717()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN

FUNCTION anmr717_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
DEFINE p_row,p_col LIKE type_file.num5,
       l_cmd	   LIKE type_file.chr1000,
       l_flag      LIKE type_file.chr1,   #是否必要欄位有輸入
       l_jmp_flag  LIKE type_file.chr1

   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW anmr717_w AT p_row,p_col
        WITH FORM "anm/42f/anmr717"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.nne03_1 = g_today
   LET tm.nne03_2 = g_today
   LET tm.edate = g_today
   LET tm.a = '2'
   LET tm.b = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON nne01,nne04,nne21  #CHI-A60020 mod nne30->nne01
            BEFORE CONSTRUCT
                CALL cl_qbe_init()

         ON ACTION locale
             CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
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
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()

      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW anmr717_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      INPUT BY NAME tm.nne03_1,tm.nne03_2,tm.edate,tm.a,tm.b,tm.more
                 WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

	 AFTER FIELD nne03_1
            IF cl_null(tm.nne03_1) THEN
	       DISPLAY BY NAME tm.nne03_1
	       NEXT FIELD nne03_1
            END IF

	 AFTER FIELD nne03_2
	    IF cl_null(tm.nne03_2) THEN
	       LET tm.nne03_2 = g_lastdat
	       DISPLAY BY NAME tm.nne03_2
	       NEXT FIELD nne03_2
            END IF
            IF tm.nne03_2 < tm.nne03_1 THEN
               NEXT FIELD nne03_2
            END IF

	 AFTER FIELD edate
	    IF cl_null(tm.edate) THEN
	       LET tm.edate = g_today
	       DISPLAY BY NAME tm.edate
	       NEXT FIELD edate
            END IF
 
         AFTER FIELD a
            IF tm.a NOT MATCHES "[12]" OR cl_null(tm.a) THEN
               NEXT FIELD a
            END IF
         AFTER FIELD b
            IF tm.b NOT MATCHES "[123]" OR cl_null(tm.b) THEN
               NEXT FIELD b
            END IF

         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more) THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
         AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF tm.nne03_1 IS NULL THEN
                LET l_flag='Y'
                DISPLAY BY NAME tm.nne03_1
                NEXT FIELD nne03_1
            END IF
            IF tm.nne03_2 IS NULL THEN
                LET l_flag='Y'
                DISPLAY BY NAME tm.nne03_2
                NEXT FIELD nne03_2
            END IF
            IF tm.a  IS NULL THEN
                LET l_flag='Y'
                DISPLAY BY NAME tm.a
                NEXT FIELD a
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD nne03_1
            END IF
  
         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG CALL cl_cmdask()	# Command execution

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
         LET INT_FLAG = 0 CLOSE WINDOW anmr717_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
                WHERE zz01='anmr717'
         IF SQLCA.SQLCODE OR cl_null(l_cmd) THEN
             CALL cl_err('anmr717','9031',1)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.nne03_1 CLIPPED,"'",
                            " '",tm.nne03_2 CLIPPED,"'",
                            " '",tm.edate   CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",
                            " '",g_rep_clas CLIPPED,"'",
                            " '",g_template CLIPPED,"'"
            CALL cl_cmdat('anmr717',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW anmr717_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL anmr717()
      ERROR ""
   END WHILE
   CLOSE WINDOW anmr717_w
END FUNCTION
 
FUNCTION anmr717()
   DEFINE l_name	LIKE type_file.chr20,              # External(Disk) file name
         #l_sql 	LIKE type_file.chr1000,            # RDSQL STATEMENT  #MOD-C20136 mark
          l_sql         STRING,                            # MOD-C20136 add
          l_za05	LIKE type_file.chr1000,            #標題內容
          l_order   ARRAY[2] OF LIKE type_file.chr20,
          l_i       LIKE type_file.num5,
          sr        RECORD
                       nne      RECORD LIKE nne_file.*,
                       nnk02    LIKE nnk_file.nnk02,
                       nnl14    LIKE nnl_file.nnl13,  #CHI-A60020 mod nnl14->nnl13
                       nnl12    LIKE nnl_file.nnl12,
                       alg02    LIKE alg_file.alg02,
                       nnkconf  LIKE nnk_file.nnkconf,
                       nnl01    LIKE nnl_file.nnl01
                    END RECORD
   DEFINE l_nmd04       LIKE nmd_file.nmd04
   DEFINE l_nmd05       LIKE nmd_file.nmd05
   DEFINE l_nnf01       LIKE nnf_file.nnf01
   DEFINE l_nmd01       LIKE nmd_file.nmd01
   DEFINE l_nmd02       LIKE nmd_file.nmd02
   DEFINE l_nmd26       LIKE nmd_file.nmd26
   DEFINE l_nnl01       LIKE nnl_file.nnl01
   DEFINE l_nnl14       LIKE nnl_file.nnl13  #CHI-A60020 mod nnl14->nnl13
   DEFINE l_nmd26_tot   LIKE nmd_file.nmd26
   DEFINE l_nmd26_tot1  LIKE nmd_file.nmd26
   DEFINE l_date        LIKE type_file.chr20
  #DEFINE l_nne30_t     LIKE nne_file.nne30  #CHI-A60020 mark
   DEFINE l_nne01_t     LIKE nne_file.nne01  #CHI-A60020 add
   DEFINE l_nnl14_tot   LIKE nnl_file.nnl13  #CHI-A60020 add
   DEFINE l_b_tot       LIKE nnl_file.nnl13  #CHI-A60020 add
   DEFINE l_nnl13_b     LIKE nnl_file.nnl13  #CHI-A60020 add

   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM
   END IF

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   IF g_priv2='4' THEN                           #只能使用自己的資料
       LET tm.wc = tm.wc clipped," AND nneuser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用相同群的資料
       LET tm.wc = tm.wc clipped," AND nnegrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       LET tm.wc = tm.wc clipped," AND nnegrup IN ",cl_chk_tgrup_list()
   END IF

 
   LET l_sql = "SELECT nne_file.*,'',nnl13,nnl12,alg02,'',nnl01 ", #CHI-A60020 mod nnl14->nnl13
               "  FROM nne_file LEFT OUTER JOIN nnl_file ON nne01=nnl04 ",
               "                LEFT OUTER JOIN alg_file ON nne04=alg01 ",
               " WHERE ",tm.wc CLIPPED,
               "   AND nne03 BETWEEN '",tm.nne03_1,"' AND '",tm.nne03_2,"'",     #TQC-A70079
               "   AND nneconf <> 'X' ",                                         #MOD-C20136 add
               " ORDER BY nne01 "                                              #TQC-A70079

   PREPARE anmr717_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   DECLARE anmr717_curs1 CURSOR FOR anmr717_prepare1

   LET g_pageno = 0
   LET g_nne12_tot = 0
   LET g_nne19_tot = 0
  #LET l_nne30_t   = NULL #CHI-A60020 mark
   LET l_nne01_t   = NULL #CHI-A60020 add

   FOREACH anmr717_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #CHI-A60020 add --start--
      LET l_b_tot = 0
      DECLARE r717_nnl_cur2 CURSOR FOR
       SELECT nnl13 FROM nnl_file,nnk_file 
        WHERE nnl01 = nnk01 AND nnl04 = sr.nne.nne01
          AND nnk02  <= tm.edate AND nnkconf = 'Y'
      FOREACH r717_nnl_cur2 INTO l_nnl13_b
         IF STATUS THEN
            CALL cl_err("foreach r717_nnl_cur:",STATUS,1)
            EXIT FOREACH
         END IF
         LET l_b_tot=l_b_tot+l_nnl13_b
      END FOREACH
      LET g_success='Y'
      CASE tm.b
         WHEN '1'#已結案
            IF sr.nne.nne19 - l_b_tot > 0 THEN
               LET g_success='N'
            END IF
         WHEN '2' #未結案
            IF sr.nne.nne19 - l_b_tot = 0 THEN
               LET g_success='N'
            END IF
      END CASE
      #CHI-A60020 add --end--
    IF g_success='Y' THEN #CHI-A60020 add
      IF cl_null(l_nne01_t) OR l_nne01_t <> sr.nne.nne01 THEN  #CHI-A60020 add
         SELECT nnk02,nnkconf INTO sr.nnk02,sr.nnkconf FROM nnk_file
          WHERE nnk01 = sr.nnl01 AND nnk02 <= tm.edate AND nnkconf = 'Y'
         IF cl_null(sr.nnl14) THEN LET sr.nnl14 = 0 END IF
         SELECT SUM(nmd26) INTO l_nmd26_tot FROM nmd_file
          WHERE nmd10 = sr.nne.nne01 AND nmd05  <= tm.edate AND nmd12 ='8'
         SELECT SUM(nmd26) INTO l_nmd26_tot1  # 支票不可當作已還啦
           FROM nmd_file,nnf_file
          WHERE nmd10 = sr.nne.nne01 AND nmd05  <= tm.edate
            AND nmd12 ='8' AND nnf06 = nmd01 AND nnf08 = '1'
         IF cl_null(l_nmd26_tot) THEN LET l_nmd26_tot = 0 END IF
         IF cl_null(l_nmd26_tot1) THEN LET l_nmd26_tot1 = 0 END IF
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nne.nne16
         LET l_date=sr.nne.nne111,"-",sr.nne.nne112
   
         DECLARE r717_nmd_cur CURSOR FOR
          SELECT nmd01,nmd02,nmd05,nmd26 FROM nmd_file
          #WHERE nmd10 = sr.nnl01 AND nmd05  <= tm.edate      #CHI-A60020 mark
           WHERE nmd10 = sr.nne.nne01 AND nmd05  <= tm.edate  #CHI-A60020
         FOREACH r717_nmd_cur INTO l_nmd01,l_nmd02,l_nmd05,l_nmd26
            IF STATUS THEN
               CALL cl_err("foreach r717_nmd_cur:",STATUS,1)
               EXIT FOREACH
            END IF
            LET l_nnf01 = NULL
            SELECT nnf01 INTO l_nnf01 FROM nnf_file
             WHERE nnf06 = l_nmd01 AND nnf08 = '1'
            IF cl_null(l_nnf01) THEN
               EXECUTE insert_prep1 USING l_nmd02,l_nmd05,sr.nne.nne01,l_nmd26
               IF STATUS THEN
                  CALL cl_err("execute insert_prep1:",STATUS,1)
                  EXIT FOREACH
               END IF
            END IF
         END FOREACH
   
         LET l_nnl14_tot = 0 #CHI-A60020 add
         DECLARE r717_nnl_cur CURSOR FOR
          SELECT nnl01,nnl13 FROM nnl_file,nnk_file     #CHI-A60020 mod nnl14->nnl13 
          #WHERE nnl01 = nnk01 AND nnl01 = sr.nnl01     #CHI-A60020 mark
           WHERE nnl01 = nnk01 AND nnl04 = sr.nne.nne01 #CHI-A60020
             AND nnk02  <= tm.edate AND nnkconf = 'Y'
         FOREACH r717_nnl_cur INTO l_nnl01,l_nnl14
            IF STATUS THEN
               CALL cl_err("foreach r717_nnl_cur:",STATUS,1)
               EXIT FOREACH
            END IF
            LET l_nnl14_tot=l_nnl14_tot+l_nnl14  #CHI-A60020 add
            EXECUTE insert_prep2 USING l_nnl01,sr.nne.nne01,l_nnl14
            IF STATUS THEN
               CALL cl_err("execute insert_prep2:",STATUS,1)
               EXIT FOREACH
            END IF
         END FOREACH
        #IF cl_null(l_nne30_t) OR l_nne30_t <> sr.nne.nne30 THEN  #CHI-A60020 mark
          #EXECUTE insert_prep USING sr.nne.nne01,sr.nne.nne30,sr.nne.nne04,sr.nne.nne07,sr.nne.nne16,sr.nne.nne12, #CHI-A60020 mark
           EXECUTE insert_prep USING sr.nne.nne01,sr.nne.nne04,sr.nne.nne07,sr.nne.nne16,sr.nne.nne12, #CHI-A60020
                                      sr.nne.nne19,sr.nne.nne14,sr.nnl14,sr.nnk02,sr.nnkconf,sr.alg02,
                                      l_nmd26_tot,l_nmd26_tot1,t_azi04,l_date,l_nnl14_tot #CHI-A60020 add l_nnl14_tot
            IF STATUS THEN
               CALL cl_err("execute insert_prep:",STATUS,1)
               EXIT FOREACH
            END IF
           #LET l_nne30_t = sr.nne.nne30 #CHI-A60020 mark
        #END IF  #CHI-A60020 mark
        LET l_nne01_t = sr.nne.nne01 #CHI-A60020 add
      END IF  #CHI-A60020 add
    END IF #CHI-A60020 add
   END FOREACH

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 ='Y' THEN
      CALL cl_wcchp(tm.wc,'nne01,nne04,nne21')  #CHI-A60020 mod nne30->nne01
           RETURNING tm.wc
   ELSE 
      LET tm.wc = ''
   END IF
   LET g_str = tm.wc,";",tm.nne03_1,";",tm.nne03_2,";",
               tm.a,";",tm.b,";",g_azi04
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
          ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #No.CHI-9C0007
   CALL cl_prt_cs3('anmr717','anmr717',g_sql,g_str)
END FUNCTION
#FUN-A30069
