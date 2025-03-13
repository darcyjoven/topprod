# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aqcr711.4gl
# Descriptions...: 倉庫檢驗已申請未檢驗明細表
# Date & Author..: 05/12/26 By Rayven
# Modify.........: No.FUN-630051 06/04/03 By Carrier add qsa14='1'
# Modify.........: No.TQC-610086 06/04/18 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-680121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh  l_time轉g_time 
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-950135 09/06/05 By chenmoyan tm.s,tm.t與畫面上欄位不符
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds        #FUN-6C0017
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680104  VARCHAR(600)
              bdate   LIKE type_file.dat,          #No.FUN-680104  DATE
              edate   LIKE type_file.dat,          #No.FUN-680104  DATE
              s       LIKE type_file.chr4,          #No.FUN-680104  VARCHAR(3)   # Order by sequence
              t       LIKE type_file.chr2,          #No.FUN-680104  VARCHAR(3)   # Eject sw
              more    LIKE type_file.chr1          #No.FUN-680104  VARCHAR(1)   # Input more condition(Y/N)
              END RECORD
   DEFINE g_i         LIKE type_file.num5          #count/index for any purpose        #No.FUN-680104 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                    # Supress DEL key function
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690121
   LET g_pdate = ARG_VAL(1)           # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#------------No.TQC-610086 modify
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.s      = ARG_VAL(10)
   LET tm.t      = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
#------------No.TQC-610086 modify
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL aqcr711_tm(0,0)           # Input print condition
      ELSE CALL aqcr711()                 # Read data and create out-file
   END IF
   CALL aqcr711()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
FUNCTION aqcr711_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW aqcr711_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr711"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '12'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON qsa01,qsa11,qsa12,qsa02,qsa03,qsa04,qsa05
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
     ON ACTION controlp
        CASE
           WHEN INFIELD(qsa01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_qsa"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO qsa01
                NEXT FIELD qsa01
           WHEN INFIELD(qsa12)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmc"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO qsa12
                NEXT FIELD qsa12
           WHEN INFIELD(qsa02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO qsa02
                NEXT FIELD qsa02
           WHEN INFIELD(qsa03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imd1"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO qsa03
                NEXT FIELD qsa03
           OTHERWISE
        END CASE
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aqcr711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   LET tm.bdate=TODAY
   LET tm.edate=TODAY
#  DISPLAY BY NAME tm.bdate,tm.edate,tm.s,tm.t,tm.more  #No.TQC-950135
   DISPLAY BY NAME tm.bdate,tm.edate,tm2.s1,tm2.s2,     #No.TQC-950135        
                   tm2.t1,tm2.t2,tm.more                #No.TQC-950135 
   INPUT BY NAME tm.bdate,tm.edate,
                 tm2.s1,tm2.s2,
		 tm2.t1,tm2.t2,
                 tm.more
      WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
              CALL cl_err('','aap-099',0)
              NEXT FIELD bdate
         ELSE
           IF tm.bdate > tm.edate THEN
              CALL cl_err('','anm-091',1)
              NEXT FIELD bdate
           END IF
         END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN
              CALL cl_err('','aap-099',0)
              NEXT FIELD edate
         ELSE
           IF tm.bdate > tm.edate THEN
              CALL cl_err('','anm-091',1)
              NEXT FIELD edate
           END IF
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()   # Command execution
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aqcr711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aqcr711'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr711','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'",         #No.TQC-610086 add 
                         " '",tm.t CLIPPED,"'",         #No.TQC-610086 add
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('aqcr711',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aqcr711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aqcr711()
   ERROR ""
END WHILE
   CLOSE WINDOW aqcr711_w
END FUNCTION
FUNCTION aqcr711()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680104 VARCHAR(1200)
          l_order   ARRAY[2] OF LIKE qsa_file.qsa01,            #No.FUN-680104 VARCHAR(40)
          g_cnt     LIKE type_file.num5,                        #No.FUN-680104 SMALLINT
          sr               RECORD order1 LIKE qsa_file.qsa01,   #No.FUN-680104 VARCHAR(40)
                                  order2 LIKE qsa_file.qsa01,   #No.FUN-680104 VARCHAR(40)
                                  qsa01  LIKE qsa_file.qsa01,
				  qsa11  LIKE qsa_file.qsa11,
				  qsa02  LIKE qsa_file.qsa02,
   				  ima02  LIKE ima_file.ima02,
				  ima021 LIKE ima_file.ima021,
				  qsa03  LIKE qsa_file.qsa03,
				  qsa04  LIKE qsa_file.qsa04,
				  qsa05  LIKE qsa_file.qsa05,
				  qsa10  LIKE qsa_file.qsa10,
				  qsa12  LIKE qsa_file.qsa12,
				  pmc03  LIKE pmc_file.pmc03,
   				  qsa06  LIKE qsa_file.qsa06
                           END RECORD
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND qsauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND qsagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND qsagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qsauser', 'qsagrup')
     #End:FUN-980030
     LET l_sql = "SELECT '','',",
                 "     qsa01,qsa11,qsa02,ima02,ima021,qsa03,qsa04, ",
                 "     qsa05,qsa10,qsa12,pmc03,qsa06",
                 "  FROM qsa_file LEFT OUTER JOIN ima_file ON qsa02=ima01 LEFT OUTER JOIN pmc_file ON qsa12=pmc01",
                 " WHERE qsa11 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND qsa14 = '1'",   #No.FUN-630051
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY qsa01 "
     PREPARE aqcr711_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE aqcr711_curs1 CURSOR FOR aqcr711_prepare1
      CALL cl_outnam('aqcr711') RETURNING l_name
     START REPORT aqcr711_rep TO l_name
     LET g_pageno = 0
     FOREACH aqcr711_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT COUNT(*) INTO g_cnt FROM qcs_file,qsa_file
        WHERE qcs01=qsa01
          AND qcs14='N'
       IF g_cnt=0 THEN
          CONTINUE FOREACH
       END IF
       FOR g_i = 1 TO 2
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.qsa01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.qsa11
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       OUTPUT TO REPORT aqcr711_rep(sr.*)
     END FOREACH
     FINISH REPORT aqcr711_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
REPORT aqcr711_rep(sr)
   DEFINE l_last_sw      LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
          l_ima021       LIKE ima_file.ima021,
          sr               RECORD order1 LIKE qsa_file.qsa01,      #No.FUN-680104 VARCHAR(40)
                                  order2 LIKE qsa_file.qsa01,      #No.FUN-680104 VARCHAR(40)
                                  qsa01  LIKE qsa_file.qsa01,
				  qsa11  LIKE qsa_file.qsa11,
				  qsa02  LIKE qsa_file.qsa02,
   				  ima02  LIKE ima_file.ima02,
				  ima021 LIKE ima_file.ima021,
				  qsa03  LIKE qsa_file.qsa03,
				  qsa04  LIKE qsa_file.qsa04,
				  qsa05  LIKE qsa_file.qsa05,
				  qsa10  LIKE qsa_file.qsa10,
				  qsa12  LIKE qsa_file.qsa12,
				  pmc03  LIKE pmc_file.pmc03,
   				  qsa06  LIKE qsa_file.qsa06
                           END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED, tm.bdate ,'-',tm.edate CLIPPED
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
            g_x[37],g_x[38],g_x[40],g_x[41],g_x[42]         
      PRINT g_dash1
      LET l_last_sw = 'n'
   BEFORE GROUP OF sr.order1
     IF tm.t[1,1] = 'Y' THEN
         SKIP TO TOP OF PAGE
     END IF
   BEFORE GROUP OF sr.order2
     IF tm.t[2,2] = 'Y' THEN
        SKIP TO TOP OF PAGE
     END IF
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.qsa01,
            COLUMN g_c[32],sr.qsa11,
            COLUMN g_c[33],sr.qsa02,
            COLUMN g_c[34],sr.ima02,
            COLUMN g_c[35],sr.ima021,
            COLUMN g_c[36],sr.qsa03,
            COLUMN g_c[37],sr.qsa04,
            COLUMN g_c[38],sr.qsa05,
            COLUMN g_c[40],sr.qsa12,
            COLUMN g_c[41],sr.pmc03,
            COLUMN g_c[42],sr.qsa06 USING "##########&.###"
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
   PAGE TRAILER
       IF l_last_sw = 'n' THEN
           PRINT g_dash
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
       ELSE
           SKIP 2 LINE
       END IF
END REPORT
