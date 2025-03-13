# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abmq616.4gl
# Descriptions...: 單階材料供應商明細表
# Input parameter:
# Return code....:
# Date & Author..: 92/03/20 By David
# Modify.........: 92/10/28 By Apple
# Modify.........: 93/09/10 By Apple(DEBUG)
# Modify.........: No.FUN-510033 05/02/15 By Mandy 報表轉XML
# Modify.........: No:FUN-550093 05/05/26 By kim 配方BOM
# Modify.........: No:FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No:TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No:TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE

# Modify.........: No:FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No:FUN-6A0088 06/11/13 By baogui 報表抬頭欄位虛線by欄位區分開
DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm  RECORD				 # Print condition RECORD
	       	wc  	  LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(500)
                edate     LIKE type_file.dat,    #No.FUN-680096 DATE 
                s         LIKE type_file.chr3,   #No.FUN-680096 VARCHAR(3)
   	        more	  LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
        END RECORD

DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF


   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No:FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL q616_tm(0,0)			# Input print condition
      ELSE CALL q616()			# Read data and create out-file
   END IF
END MAIN

FUNCTION q616_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
            l_one         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
            l_date        LIKE type_file.dat,     #No.FUN-680096 DATE
            l_bmb01       LIKE bmb_file.bmb01,	
            l_bmb29       LIKE bmb_file.bmb29,    #FUN-550093
            l_cmd	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(1000)
            l_sql         STRING                  #FUN-550093


   LET p_row = 4
   LET p_col = 9

   OPEN WINDOW q616_w AT p_row,p_col WITH FORM "abm/42f/abmq616"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

    #FUN-560021................begin
    CALL cl_set_comp_visible("bmb29",g_sma.sma118='Y')
    #FUN-560021................end

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET tm.edate = g_today
   LET tm.s    = g_sma.sma65
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   # genero  script marked  LET g_pageno = 0
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bmb01,bmb03,bmb13,bmb29 #FUN-550093
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
         ON ACTION locale
             CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
      END CONSTRUCT


      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW q616_w
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         #FUN-550093................begin
        #LET l_cmd="SELECT COUNT(DISTINCT bmb01),bmb01 FROM bmb_file",
        #          " WHERE ",tm.wc CLIPPED," GROUP BY bmb01 "
         LET l_cmd="SELECT DISTINCT bmb01,bmb29 FROM bmb_file",
                   "  WHERE ",tm.wc CLIPPED," GROUP BY bmb01,bmb29 "
         #FUN-550093................end
         PREPARE q616_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('Prepare:',SQLCA.sqlcode,1)
            EXIT PROGRAM
         END IF
         DECLARE q616_cnt CURSOR FOR q616_precnt
         OPEN q616_cnt
         #FUN-550093................begin
        #FETCH q616_cnt INTO g_cnt,l_bmb01
         FETCH q616_cnt INTO l_bmb01,l_bmb29
         DROP TABLE q616_cnttemp
#No.FUN-680096------------------begin-----------------
         CREATE TEMP TABLE q616_cnttemp(
                    bmb01   VARCHAR(40),
                    bmb29   VARCHAR(20))
#No.FUN-680096-------------end--------------------
         LET l_sql="INSERT INTO q616_cnttemp (",l_cmd,")"
         PREPARE q616_cnttemp_sql FROM l_sql
         EXECUTE q616_cnttemp_sql
         SELECT COUNT(*) INTO g_cnt FROM q616_cnttemp
         #FUN-550093................end
         IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)   
            CONTINUE WHILE
         ELSE
            #LET g_cnt=sqlca.sqlerrd[3]
            IF g_cnt=1 THEN
               LET l_one='Y'
            END IF
         END IF
      END IF
      INPUT BY NAME tm.s,tm.edate,tm.more WITHOUT DEFAULTS
 
         AFTER FIELD s
            IF tm.s IS NULL OR tm.s NOT MATCHES '[123]' THEN
               NEXT FIELD s
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW q616_w
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmq616'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('abmq616','9031',1)                
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
            CALL cl_cmdat('abmq616',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW q616_w
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL q616()
      ERROR ""
   END WHILE
   CLOSE WINDOW q616_w
END FUNCTION

FUNCTION q616()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_use_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
          l_ute_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT        #No.FUN-680096 VARCHAR(1000)
          l_sql1	LIKE type_file.chr1000, # RDSQL STATEMENT        #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_cnt         LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          sr  RECORD
              order1  LIKE bmb_file.bmb02,  #No.FUN-680096 VARCHAR(20)
              bma01 LIKE bma_file.bma01,    # assembly part no
              bmb01 LIKE bmb_file.bmb01,    # assembly part no
              bmb02 LIKE bmb_file.bmb02,    # 項次
              bmb03 LIKE bmb_file.bmb03,    # item no
              bmb06 LIKE bmb_file.bmb06,    # QPA
              bmb13 LIKE bmb_file.bmb13,    #balloon
              ima02 LIKE ima_file.ima02,    # p name & regular
              ima05 LIKE ima_file.ima05,    # version
              ima06 LIKE ima_file.ima06,    # group code
              ima08 LIKE ima_file.ima08,    # source code
              ima55 LIKE ima_file.ima55,    # production unit
              ima63 LIKE ima_file.ima63,    # issued unit
              bma06 LIKE bma_file.bma06     #FUN-550093
          END RECORD,
          l_order	ARRAY[3] OF LIKE bmb_file.bmb02   #No.FUN-680096 VARCHAR(20)

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同部門的資料
         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     END IF

     LET l_sql = "SELECT '',",
                 " bma01,bmb01,bmb02,bmb03,",
                 " bmb06,bmb13,",
                 " ima02,ima05,ima06,ima08,ima55,ima63,bma06", #FUN-550093
                 " FROM bma_file, ima_file, bmb_file  " ,
                 " WHERE bmb01 = bma01 AND bmb01 = ima01   ",
                 " AND bmb29=bma06 ", #FUN-550093
                 "   AND ",tm.wc

     #---->生效日及失效日的判斷
     IF tm.edate IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED,
          " AND (bmb04 <='",tm.edate CLIPPED,"' OR bmb04 IS NULL)",
          " AND (bmb05 > '",tm.edate CLIPPED,"' OR bmb05 IS NULL)" #FUN-550093
     END IF

     PREPARE q616_prepare1 FROM l_sql
     DECLARE q616_c1 CURSOR FOR q616_prepare1

     CALL cl_outnam('abmq616') RETURNING l_name
     START REPORT q616_rep TO l_name

# genero  script marked      LET g_pageno = 0
     LET l_cnt    = 0
     CALL q616_cur()
     FOREACH q616_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF tm.s = '1' THEN LET sr.order1 = sr.bmb02 END IF
       IF tm.s = '2' THEN LET sr.order1 = sr.bmb03 END IF
       IF tm.s = '3' THEN LET sr.order1 = sr.bmb13 END IF
       OUTPUT TO REPORT q616_rep(sr.*)
     END FOREACH
     FINISH REPORT q616_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
END FUNCTION
 
FUNCTION q616_cur()
 DEFINE  l_sql1,l_sql2   LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)

      LET l_sql1= "SELECT ",
                  " pmh01,pmh02,pmc03,pmh04,pmh03,pmh05,pmh06, ",
                  " pmh08,pmh09,pmh13  ",
                  " FROM pmh_file,OUTER pmc_file " ,
                  " WHERE pmh01 = ? AND pmh02 = pmc_file.pmc01 "
      PREPARE q616_prepare2 FROM l_sql1
      IF SQLCA.sqlcode THEN
         CALL cl_err('Prepare2:',SQLCA.sqlcode,1) EXIT PROGRAM
      END IF
      DECLARE q616_c2 CURSOR FOR q616_prepare2
END FUNCTION
 
REPORT q616_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          l_sql1     LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(1000)
          l_sql2     LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(1000)
          l_cnt      LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          sr  RECORD
              order1  LIKE bmb_file.bmb02,  #No.FUN-680096 VARCHAR(20)
              bma01 LIKE bma_file.bma01,    # assembly part no
              bmb01 LIKE bmb_file.bmb01,    # assembly part no
              bmb02 LIKE bmb_file.bmb02,    # 項次
              bmb03 LIKE bmb_file.bmb03,    # assembly part no
              bmb06 LIKE bmb_file.bmb06,
              bmb13 LIKE bmb_file.bmb13,
              ima02 LIKE ima_file.ima02,    # p name & regular
              ima05 LIKE ima_file.ima05,    # version
              ima06 LIKE ima_file.ima06,    # group code
              ima08 LIKE ima_file.ima08,    # source code
              ima55 LIKE ima_file.ima55,    # production unit
              ima63 LIKE ima_file.ima63,    # issued unit
              bma06 LIKE bma_file.bma06     #FUN-550093
          END RECORD,
          l_pmh01  LIKE pmh_file.pmh01,
          l_pmh02  LIKE pmh_file.pmh02,
          l_pmh03  LIKE pmh_file.pmh03,
          l_pmh04  LIKE pmh_file.pmh04,
          l_pmh05  LIKE pmh_file.pmh05,
          l_pmh06  LIKE pmh_file.pmh06,
          l_pmh08  LIKE pmh_file.pmh08,
          l_pmh09  LIKE pmh_file.pmh09,
          l_ima02  LIKE ima_file.ima02,
          l_ima021 LIKE ima_file.ima021, #FUN-510033
          l_ima06  LIKE ima_file.ima06,
          l_pmc03  LIKE pmc_file.pmc03,
          l_pmh13  LIKE pmh_file.pmh13,
          l_ver    LIKE ima_file.ima05

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bma01,sr.bma06,sr.order1,sr.bmb03 #FUN-550093
  FORMAT
   PAGE HEADER
      #effective date
      CALL s_effver(sr.bma01,tm.edate) RETURNING l_ver

      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN 01,g_x[27] CLIPPED,tm.edate,
            COLUMN 20,g_x[29] CLIPPED,l_ver
      PRINT g_dash
      #----
#-------No:TQC-5B0107 modify  #&051112
 #-------No:TQC-5B0030
      PRINT COLUMN  1,g_x[11] CLIPPED, sr.bma01,
            COLUMN 55,g_x[12] CLIPPED,sr.ima05,  #版本
            COLUMN 68,g_x[13] CLIPPED,sr.ima08,  #來源碼
            COLUMN 80,g_x[14] CLIPPED,sr.ima63,  #發料單位
            COLUMN 96,g_x[17] CLIPPED,sr.bma06   #FUN-550093
 #--------end

      PRINT COLUMN  1,g_x[15] CLIPPED,sr.ima02,
	    COLUMN 80,g_x[16] CLIPPED,sr.ima55        #生產單位
#------No:TQC-5B0107 end

      PRINT ' '
      #----
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]    #TQC-6A0081
      PRINTX name=H1 g_x[31],g_x[32],g_x[48],g_x[33],g_x[49],g_x[50],g_x[34],g_x[51],g_x[52],g_x[53],g_x[35],g_x[36]       #TQC-6A0081
      PRINTX name=H2 g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
      PRINT g_dash1
      LET l_last_sw = 'n'

   BEFORE GROUP OF sr.bma06 #FUN-550093
      IF (PAGENO > 1 OR LINENO > 13)
         THEN SKIP TO TOP OF PAGE
      END IF

   BEFORE GROUP OF sr.bmb03
      LET l_cnt = 0
      SELECT ima02,ima021,ima06 INTO l_ima02,l_ima021,l_ima06 FROM ima_file
                  WHERE sr.bmb03 = ima01
      IF SQLCA.sqlcode THEN
	     LET l_ima02 = ' '  LET l_ima06 = ' '
	     LET l_ima021 = ' '
      END IF
	  PRINTX name=D1 COLUMN g_c[31],sr.bmb02 USING '###&',
                         COLUMN g_c[32],sr.bmb03,
                         COLUMN g_c[33],l_ima02,
                         COLUMN g_c[34],l_ima021,
                         COLUMN g_c[35] CLIPPED,cl_numfor(sr.bmb06,35,5),
	                 COLUMN g_c[36] CLIPPED,sr.bmb13

   ON EVERY ROW
      FOREACH q616_c2
      USING sr.bmb03
                      INTO l_pmh01,l_pmh02,l_pmc03,l_pmh04,
                           l_pmh03,l_pmh05,l_pmh06,l_pmh08,l_pmh09,l_pmh13
        IF SQLCA.sqlcode THEN
		   EXIT FOREACH
        END IF
	    PRINTX name=D2 COLUMN g_c[37],' ',
	                   COLUMN g_c[38],l_pmh02,
                           COLUMN g_c[39],l_pmc03,
                           COLUMN g_c[40],l_pmh04,
                           COLUMN g_c[41],l_pmh13,
                           COLUMN g_c[42],l_pmh03,
                           COLUMN g_c[43],l_pmh05,
                           COLUMN g_c[44],l_pmh06,
                           COLUMN g_c[45],l_pmh08,
                           COLUMN g_c[46],l_pmh09,
                           COLUMN g_c[47],'1'
        LET l_cnt = l_cnt + 1
      END FOREACH
      PRINT '  '

#  AFTER GROUP OF sr.bma01
#  LET g_pageno = 0

   ON LAST ROW
      LET l_last_sw = 'y'

   PAGE TRAILER
      PRINT ' '
      PRINT g_x[23] CLIPPED
      PRINT g_x[24] CLIPPED
      PRINT g_dash
      IF l_last_sw = 'y'
#        OR g_pageno = 0
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      END IF
END REPORT
