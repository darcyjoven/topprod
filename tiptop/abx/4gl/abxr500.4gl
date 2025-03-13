# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: abxr500.4gl
# Desc/riptions..: 保稅機器設備記帳卡
# Date & Author..: 2006/10/14 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-860021 08/06/11 By Sarah INPUT漏了ON IDLE控制
# Modify.........: No.FUN-850089 08/05/23 By TSD.Ken 傳統報表轉Crystal Report
# Modify.........: No.FUN-890101 08/09/23 By dxfwo  CR 追單到31區
# Modify.........: No.MOD-8C0199 09/02/20 By Pengu "海關監管編號" MI003應抓abxs020的海關監管編號
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-C30645 12/03/13 By chenjing 將抓取資料的sql，join gen_file的部份放在foreach里抓取人員資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			# Print condition RECORD
	      wc   STRING,	# Where condition
   	      y    LIKE type_file.chr1,		# group code choice
   	      more LIKE type_file.chr1 		# Input more condition(Y/N)
              END RECORD
   DEFINE g_i LIKE type_file.num5                  #count/index for any purpose
   DEFINE   l_table              STRING,    #FUN-850089 add
            g_sql                STRING,    #FUN-850089 add
            g_str                STRING     #FUN-850089 add
            
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
 
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bzc03.bzc_file.bzc03,",
              "gen02_1.gen_file.gen02,",
              "bzc04.bzc_file.bzc04,",
              "gen02_2.gen_file.gen02,",
              "bzc01.bzc_file.bzc01,",
              "bzd02.bzd_file.bzd02,",
              "bzd03.bzd_file.bzd03,",
              "bza05.bza_file.bza05,",
              "bza06.bza_file.bza06,",
              "bza02.bza_file.bza02,",
              "bza04.bza_file.bza04,",
              "bza08.bza_file.bza08,",
              "bza09.bza_file.bza09,",
              "bza07.bza_file.bza07,",
              "bza10.bza_file.bza10,",
              "bza11.bza_file.bza11,",
              "bza12.bza_file.bza12,",
              "bza13.bza_file.bza13,",
              "bza14.bza_file.bza14,",
              "bzd04.bzd_file.bzd04,",
              "l_n.type_file.num5"     #假項次
 
  LET l_table = cl_prt_temptable('abxr500',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?)" #21 items
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.y     = ARG_VAL(8)
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add--
   IF cl_null(tm.wc) THEN
      CALL r500_tm(0,0)	
   ELSE
      LET tm.wc="bzc01= '",tm.wc CLIPPED,"'"
      CALL r500()	
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION r500_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd	        LIKE type_file.chr1000
  
   LET p_row = 5 LET p_col = 5 
 
   OPEN WINDOW r500_w AT p_row,p_col WITH FORM "abx/42f/abxr500"
   ATTRIBUTE (STYLE = g_win_style) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   WHILE TRUE
      INITIALIZE tm.* TO NULL                      # Default condition
      LET tm.y    = 'Y'
      LET tm.more = 'N'
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
 
 
      CONSTRUCT BY NAME tm.wc ON bzc01,bzc03,bzc04
 
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bzc01) #記帳卡編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_bzc01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bzc01
                  NEXT FIELD bzc01
               WHEN INFIELD(bzc03) #負責人
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bzc03
                  NEXT FIELD bzc03
               WHEN INFIELD(bzc04)  #承辦人
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bzc04
                  NEXT FIELD bzc04
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
   
         ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bzcuser', 'bzcgrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r500_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
 
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm.y
 
      INPUT BY NAME tm.y,tm.more WITHOUT DEFAULTS 
         AFTER FIELD y
            IF tm.y NOT MATCHES "[YyNn]" THEN
               NEXT FIELD y
            END IF
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YyNn]"  THEN
               NEXT FIELD more
            END IF
         IF tm.more = 'Y' OR tm.more = 'y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,    #詢問特殊列印條件
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()	# Command execution
 
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE INPUT        #TQC-860021
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abxr500'
 
         IF SQLCA.sqlcode OR cl_null(l_cmd)  THEN
            CALL cl_err('abxr500','9031',1)
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
                        " '",tm.y CLIPPED,"'"
            CALL cl_cmdat('abxr500',g_time,l_cmd)   # Execute cmd at later time
         END IF
         CLOSE WINDOW r500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r500()
      ERROR ""
   END WHILE
   CLOSE WINDOW r500_w
END FUNCTION
 
FUNCTION r500()
   DEFINE l_name LIKE type_file.chr20,		# External(Disk) file name
#       l_time          LIKE type_file.chr8     #No.FUN-6A0062
          l_sql  STRING,		# RDSQL STATEMENT
          sr     RECORD
              bzc03 LIKE bzc_file.bzc03, #負責人
              gen02_1  LIKE gen_file.gen02, #負責人/承辦人姓名 
              bzc04 LIKE bzc_file.bzc04, #承辦人
              gen02_2  LIKE gen_file.gen02, #負責人/承辦人姓名
              bzc01 LIKE bzc_file.bzc01, #卡號
              bzd02 LIKE bzd_file.bzd02, #項次
              bzd03 LIKE bzd_file.bzd03, #機器設備編號
              bza05 LIKE bza_file.bza05, #型態
              bza06 LIKE bza_file.bza06, #主件編號 
              bza02 LIKE bza_file.bza02, #機器設備名稱
              bza04 LIKE bza_file.bza04, #機器設備規格
              bza08 LIKE bza_file.bza08, #單位
              bza09 LIKE bza_file.bza09, #數量
              bza07 LIKE bza_file.bza07, #報單號碼
              bza10 LIKE bza_file.bza10, #稅捐記帳金額
              bza11 LIKE bza_file.bza11, #管理局核准文號
              bza12 LIKE bza_file.bza12, #放行日期
              bza13 LIKE bza_file.bza13, #記帳到期日
              bza14 LIKE bza_file.bza14, #稽核日期
              bzd04 LIKE bzd_file.bzd04  #備註
                 END RECORD
 DEFINE l_n   LIKE type_file.num5,       #FUN-850089 
        l_bza   RECORD LIKE bza_file.*   #FUN-850089
#FUN-850089 add---START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END

   #No.FUN-B80082--mark--Begin--- 
   #CALL cl_used('abxr500',g_time,1) RETURNING g_time
   #No.FUN-B80082--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
#MOD-C30645--mark--start--
#  LET l_sql = "SELECT bzc03,A.gen02,bzc04,B.gen02,   ", 
#              "       bzc01,bzd02,bzd03, ",
#              "       bza05,bza06,bza02,bza04,bza08, ",
#              "       bza09,bza07,bza10,bza11, ",
#              "       bza12,bza13,bza14,bzd04  ",
#              "  FROM bzc_file,bza_file, ",
#              "       bzd_file,gen_file A,gen_file B  ", 
#              " WHERE bzd01=bzc01 AND bzd03=bza01 ",
#              "   AND bzc03 = A.gen01 AND B.gen01=bzc04 ",
#              "   AND ",tm.wc CLIPPED
#MOD-C30645--maek--end--
#MOD-C30645--add--start--
   LET l_sql = "SELECT bzc03,'',bzc04,'',   ",
               "       bzc01,bzd02,bzd03, ",
               "       bza05,bza06,bza02,bza04,bza08, ",
               "       bza09,bza07,bza10,bza11, ",
               "       bza12,bza13,bza14,bzd04  ",
               "  FROM bzc_file,bza_file,bzd_file  ",
               " WHERE bzd01=bzc01 AND bzd03=bza01 ",
               "   AND ",tm.wc CLIPPED
#MOD-C30645--add--end--

 
   LET l_sql = l_sql CLIPPED," ORDER BY bzc01,bzd02"
   PREPARE r500_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM 
   END IF
   DECLARE r500_cs1 CURSOR FOR r500_prepare1
   #FUN-850089  ---start---
   LET l_sql = "SELECT * FROM bza_file",
               " WHERE bza05 = '2'",         #型態是附件
               "   AND bza06 = ?",
               "   AND bzaacti = 'Y'"
   DECLARE r500_bza_cus_n CURSOR FROM l_sql
   #FUN-850089  ---end--
#   CALL cl_outnam('abxr500') RETURNING l_name     #No.FUN-890101
#   START REPORT r500_rep TO l_name                #No.FUN-890101
 
   FOREACH r500_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
      END IF
    
 #MOD-C30645--add--start--
   SELECT gen02 INTO sr.gen02_1
     FROM gen_file 
    WHERE gen01 = sr.bzc03
   SELECT gen02 INTO sr.gen02_2
     FROM gen_file  
    WHERE gen01 = sr.bzc04 
 #MOD-C30645--add--end--
       #FUN-850089  ---start--- 
#      OUTPUT TO REPORT r500_rep(sr.*)
      IF tm.y = 'N' THEN
         LET sr.bza10 = ''
      END IF
 
      LET l_n = 0
      LET sr.bza05 = '1'
      EXECUTE insert_prep USING sr.*, l_n
 
      INITIALIZE l_bza.* TO NULL
      FOREACH r500_bza_cus_n USING sr.bzd03
         INTO l_bza.*
         IF SQLCA.SQLCODE THEN
            EXIT FOREACH
         END IF
         IF tm.y = 'N' THEN
            LET l_bza.bza10 = ''
         END IF
         LET l_n = l_n + 1
 
         EXECUTE insert_prep USING sr.bzc03,
                                   sr.gen02_1,
                                   sr.bzc04,
                                   sr.gen02_2,
                                   sr.bzc01, 
                                   sr.bzd02, 
                                   l_bza.bza01, #機器設備
                                   l_bza.bza05,
                                   l_bza.bza06,
                                   l_bza.bza02,
                                   l_bza.bza04,
                                   l_bza.bza08,
                                   l_bza.bza09, 
                                   l_bza.bza07,
                                   l_bza.bza10,
                                   l_bza.bza11,
                                   l_bza.bza12,
                                   l_bza.bza13,
                                   l_bza.bza14,
                                   ' ', #備註
                                   l_n
      END FOREACH
      #FUN-850089  ---end---
   END FOREACH
 
#  FINISH REPORT r500_rep
   #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'bzc01,bzc03,bzc04')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
 
    LET g_str = g_str,";",g_azi03,";",g_bxz.bxz101   #No.MOD-8C0199 add bxz01
 
    CALL cl_prt_cs3('abxr500','abxr500',l_sql,g_str)
   #---FUN-850089 add---END
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr500',g_time,2) RETURNING g_time
   #No.FUN-B80082--mark--End-----
END FUNCTION
 
#REPORT r500_rep(sr)
#   DEFINE l_last_sw  LIKE type_file.chr1,
#          l_bza05 LIKE type_file.chr8,
#          l_bza   RECORD LIKE bza_file.*,
#          sr      RECORD 
#               bzc03 LIKE bzc_file.bzc03, #負責人
#               gen02_1  LIKE gen_file.gen02,       #負責人姓名 
#               bzc04 LIKE bzc_file.bzc04, #承辦人
#               gen02_2  LIKE gen_file.gen02,       #負責人姓名
#               bzc01 LIKE bzc_file.bzc01, #卡號
#               bzd02 LIKE bzd_file.bzd02, #項次
#               bzd03 LIKE bzd_file.bzd03, #機器設備編號
#               bza05 LIKE bza_file.bza05, #型態
#               bza06 LIKE bza_file.bza06, #主件編號
#               bza02 LIKE bza_file.bza02, #機器設備名稱
#               bza04 LIKE bza_file.bza04, #機器設備規格
#               bza08 LIKE bza_file.bza08, #單位
#               bza09 LIKE bza_file.bza09, #數量
#               bza07 LIKE bza_file.bza07, #報單號碼
#               bza10 LIKE bza_file.bza10, #稅捐記帳金額
#               bza11 LIKE bza_file.bza11, #管理局核准文號
#               bza12 LIKE bza_file.bza12, #放行日期
#               bza13 LIKE bza_file.bza13, #記帳到期日
#               bza14 LIKE bza_file.bza14, #稽核日期
#               bzd04 LIKE bzd_file.bzd04  #備註
#                  END RECORD
# 
#   OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin 
#       BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#   ORDER BY sr.bzc01,sr.bzd02 
#   FORMAT
#   PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#
#      PRINT g_x[11] CLIPPED,sr.bzc03,' ',sr.gen02_1,
#            COLUMN g_c[34],g_x[12] CLIPPED,sr.bzc04,' ',sr.gen02_2,
#            COLUMN g_c[37],g_x[13] CLIPPED,sr.bzc01,
#            COLUMN g_c[39],g_x[14] CLIPPED,
#            COLUMN g_c[41],g_x[15] CLIPPED
#      PRINT g_dash
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,
#            g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,
#            g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,
#            g_x[41] CLIPPED,g_x[42] CLIPPED,
#            g_x[43] CLIPPED,g_x[44] CLIPPED
#      PRINT g_dash1
#
#      LET l_last_sw = 'n'
#    
#   BEFORE GROUP OF sr.bzc01
#      SKIP TO TOP OF PAGE
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
#      LET l_bza05 = g_x[16]
#
#      IF tm.y = 'N' THEN
#         LET sr.bza10 = ''
#      END IF
#      PRINT COLUMN g_c[31],sr.bzd02 USING '####',
#            COLUMN g_c[32],sr.bzd03 CLIPPED,
#            COLUMN g_c[33],l_bza05 CLIPPED,
#            COLUMN g_c[34],sr.bza02 CLIPPED,
#            COLUMN g_c[35],sr.bza04[1,20] CLIPPED,
#            COLUMN g_c[36],sr.bza08 CLIPPED,
#            COLUMN g_c[37],sr.bza09 USING '#####',
#            COLUMN g_c[38],sr.bza07 CLIPPED,
#            COLUMN g_c[39],cl_numfor(sr.bza10,39,g_azi03),
#            COLUMN g_c[40],sr.bza11 CLIPPED,
#            COLUMN g_c[41],sr.bza12 CLIPPED,
#            COLUMN g_c[42],sr.bza13 CLIPPED,
#            COLUMN g_c[43],sr.bza14 CLIPPED,
#            COLUMN g_c[44],sr.bzd04 CLIPPED
#      DECLARE r500_bza_cus CURSOR FOR 
#       SELECT * FROM bza_file
#        WHERE bza05 = '2'           #型態是附件
#          AND bza06 = sr.bzd03   #主件編號=機器設備編號
#          AND bzaacti = 'Y'
#      INITIALIZE l_bza.* TO NULL
#      FOREACH r500_bza_cus INTO l_bza.*
#         IF SQLCA.SQLCODE THEN
#            EXIT FOREACH
#         END IF
#         LET l_bza05 = g_x[17]
#         IF tm.y = 'N' THEN
#            LET l_bza.bza10 = ''
#         END IF
#         PRINT COLUMN g_c[32],l_bza.bza01 CLIPPED,
#               COLUMN g_c[33],l_bza05 CLIPPED, 
#               COLUMN g_c[34],l_bza.bza02 CLIPPED,
#               COLUMN g_c[35],l_bza.bza04 CLIPPED,
#               COLUMN g_c[36],l_bza.bza08 CLIPPED,
#               COLUMN g_c[37],l_bza.bza09 USING '#####',
#               COLUMN g_c[38],l_bza.bza07 CLIPPED,
#               COLUMN g_c[39],cl_numfor(l_bza.bza10,39,g_azi03),
#               COLUMN g_c[40],l_bza.bza11 CLIPPED,
#               COLUMN g_c[41],l_bza.bza12 CLIPPED,
#               COLUMN g_c[42],l_bza.bza13 CLIPPED,
#               COLUMN g_c[43],l_bza.bza14 CLIPPED
#      END FOREACH
#
#   AFTER GROUP OF sr.bzc01
#      LET g_pageno = 0
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash
#         PRINT g_x[4] CLIPPED,COLUMN (g_len-9), g_x[5] CLIPPED
#      ELSE
#         PRINT g_dash
#         PRINT g_x[4] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED
#      END IF
#END REPORT
#No.FUN-890101
