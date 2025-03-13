# Prog. Version..: '5.00.00-07.09.05(00004)'     #
#
# Pattern name...: apmr800.4gl
# Descriptions...: 已收未驗清單
# Input parameter:
# Date & Author..: 92/04/28 By saki
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增料號,廠商開窗
# Modify.........: No.FUN-4C0095 05/01/05 By Mandy 報表轉XML
# Modify.........: No.MOD-590003 05/09/05 By DAY 報表結束未對齊
# Modify.......... No.FUN-5C0078 05/12/20 By day 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.MOD-630053 06/03/14 By Mandy 已作廢的出貨單不印出
# Modify.........: No:FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No:FUN-590099 06/09/08 By kim 並沒有考慮是否有退貨量應該考慮驗退的情況
# Modify.........: No:FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.130710     13/07/10 By zhangjiao 修正程序编译报错的问题 


DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD				# Print condition RECORD
	       #wc  	LIKE type_file.chr1000,	# Where condition   #TQC-630166 mark #No.FUN-680136 VARCHAR(500)
		wc  	STRING,		        # Where condition   #TQC-630166  
   		more	LIKE type_file.chr1  	# Input more condition(Y/N)          #No.FUN-680136 VARCHAR(1)
              END RECORD

   DEFINE g_i           LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
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
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119


   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No:FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r800_tm(0,0)		        # Input print condition
      ELSE CALL apmr800()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN

FUNCTION r800_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01            #No:FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)

   LET p_row = 5 LET p_col = 16

   OPEN WINDOW r800_w AT p_row,p_col WITH FORM "apm/42f/apmr800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()


   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME tm.more 		# Condition
   CONSTRUCT BY NAME tm.wc ON rva05,rva01,rvb05,rva06,rvb04
     #--No.FUN-4B0022-------
         #No:FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No:FUN-580031 ---end---

     ON ACTION CONTROLP
       CASE WHEN INFIELD(rva05)      #廠商編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rva05
                 NEXT FIELD rva05
            WHEN INFIELD(rvb05)      #料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvb05
                 NEXT FIELD rvb05

       OTHERWISE EXIT CASE
       END CASE
     #--END---------------
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 

           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No:FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No:FUN-580031 ---end---

END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r800_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No:FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No:FUN-580031 ---end---

      AFTER FIELD more      #輸入其它特殊列印條件
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command epmnecution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No:FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 ---end---

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r800_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='apmr800'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr800','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,	#(at time fglgo pmnpmnpmnpmn p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
         CALL cl_cmdat('apmr800',g_time,l_cmd)	# Epmnecute cmd at later time
      END IF
      CLOSE WINDOW r800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr800()
   ERROR ""
END WHILE
   CLOSE WINDOW r800_w
END FUNCTION

FUNCTION apmr800()
   DEFINE l_name	LIKE type_file.chr20, 	# Epmnternal(Disk) file name           #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	# Used time for running the job        #No.FUN-680136 VARCHAR(8)
         #l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT   #TQC-630166 mark   #No.FUN-680136 VARCHAR(1000)
          l_sql 	STRING,		        # RDSQL STATEMENT   #TQC-630166
          l_za05	LIKE za_file.za05,      # No.FUN-680136 VARCHAR(40)
          l_cnt         LIKE type_file.num5,    # No.FUN-680136 SMALLINT
          l_qcs14  LIKE qcs_file.qcs14,
          l_tempdir  STRING,
          l_status   STRING,
          sr            RECORD
            rva01  LIKE rva_file.rva01,
            rva06  LIKE rva_file.rva06,
            rvb02  LIKE rvb_file.rvb02,
            rvb03  LIKE rvb_file.rvb03,
            rvb04  LIKE rvb_file.rvb04,
            rvb05  LIKE rvb_file.rvb05,
            rvb07  LIKE rvb_file.rvb07,
            rvb29  LIKE rvb_file.rvb29, #FUN-590099
            pmn041 LIKE pmn_file.pmn041,
            pmn63  LIKE pmn_file.pmn63            
            END RECORD

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     END IF

     LET l_sql = " SELECT ",
                 " rva01,rva06,rvb02,rvb03,rvb04,rvb05,rvb07,rvb29,", #FUN-590099
                 " pmn041,pmn63 ",
                 " FROM rva_file,rvb_file,pmn_file ",
                 " WHERE rva01 = rvb01 ",
                 "  AND rvb03 = pmn02 ",
                 "  AND rvb04 = pmn01 ",
                 "  AND rvb04 = pmn01 ",
                 "  AND rvb39 = 'Y' AND  ",tm.wc CLIPPED ,
                 "  AND rvaconf <> 'X' ", #MOD-630053 作廢不應印出
                 " ORDER BY rva01,rvb02,rva06 "

     PREPARE r800_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r800_cs  CURSOR FOR r800_prepare
#    LET l_name = 'apmr800.out'
     CALL cl_outnam('apmr800') RETURNING l_name
     START REPORT r800_rep TO l_name
     FOREACH r800_cs INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT COUNT(*) INTO l_cnt FROM qcs_file
       WHERE sr.rva01 = qcs01
         AND sr.rvb02 = qcs02
         AND (qcs14='Y' OR qcs14 = 'N')
         AND qcs00<'5'   #No.FUN-5C0078
    #  SELECT qcs14 INTO l_qcs14 FROM qcs_file
    #  WHERE sr.rva01 = qcs01 AND sr.rvb02 = qcs02
       #IF l_cnt<=0  THEN #FUN-590099
       IF (NOT sr.rvb07=sr.rvb29) AND (l_cnt<=0)  THEN #FUN-590099
          OUTPUT TO REPORT r800_rep(sr.*)
       END IF
     END FOREACH

     FINISH REPORT r800_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION

REPORT r800_rep(sr)
   DEFINE l_ima021     LIKE ima_file.ima021  #FUN-4C0095
   DEFINE l_last_sw	LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
          l_sw          LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
          sr            RECORD
            rva01  LIKE rva_file.rva01,
            rva06  LIKE rva_file.rva06,
            rvb02  LIKE rvb_file.rvb02,
            rvb03  LIKE rvb_file.rvb03,
            rvb04  LIKE rvb_file.rvb04,
            rvb05  LIKE rvb_file.rvb05,
            rvb07  LIKE rvb_file.rvb07,
            rvb29  LIKE rvb_file.rvb29, #FUN-590099
            pmn041 LIKE pmn_file.pmn041,
            pmn63  LIKE pmn_file.pmn63
            END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.rva01,sr.rvb02,sr.rva06
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'

ON EVERY ROW
      SELECT ima021
        INTO l_ima021
        FROM ima_file
       WHERE ima01=sr.rvb05
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
         PRINT COLUMN g_c[31],sr.rva01,
               COLUMN g_c[32],sr.rvb02 USING '########',
               COLUMN g_c[33],sr.rva06,
               COLUMN g_c[34],sr.rvb05,
               COLUMN g_c[35],sr.pmn041,
               COLUMN g_c[36],l_ima021,
               COLUMN g_c[37],sr.rvb04,
               COLUMN g_c[38],sr.rvb03 USING '########',
               COLUMN g_c[39],cl_numfor(sr.rvb07,14,3),
               COLUMN g_c[40],sr.pmn63
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-201,240,300
         THEN PRINT g_dash
             #TQC-630166
             #IF tm.wc[001,70] > ' ' THEN			# for 80
             #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
             #IF tm.wc[071,140] > ' ' THEN
             #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
             #IF tm.wc[141,210] > ' ' THEN
  	     #  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
             #IF tm.wc[211,280] > ' ' THEN
  	     #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
             CALL cl_prt_pos_wc(tm.wc)
             #END TQC-630166
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.MOD-590003

PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.MOD-590003
         ELSE SKIP 2 LINE
      END IF
END REPORT


#修正编译报错的问题
#No.130710---mark by zhangjiao---Str
##以下函式為動態設定於畫面元件設定作業(p_per)內的函式
#FUNCTION cl_validate_fun01(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun02(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun03(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun04(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun05(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun06(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun07(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun08(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun09(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun10(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun11(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun12(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun13(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun14(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun15(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun16(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun17(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun18(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun19(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION cl_validate_fun20(ps_value)
#   DEFINE   ps_value   STRING
#   RETURN TRUE
#END FUNCTION
#No.130710------mark by zhangjiao---End
