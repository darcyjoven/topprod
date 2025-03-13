# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abxr602.4gl
# Descriptions..: 機器設備帳(園區用)
# Date & Author..: No.FUN-BC0115 12/01/05 By Sakura
# Modify.........: No.FUN-C20035 12/02/13 By Sakura 欄位抓取方式改與abxr501同
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD    # Print condition RECORD
	      wc   STRING,	# Where condition
   	      y    LIKE type_file.chr1		# group code choice
   	      #more LIKE type_file.chr1 		# Input more condition(Y/N) #FUN-C20035 mark
              END RECORD
   DEFINE   l_table              STRING,
            g_sql                STRING,
            g_str                STRING
            
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
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
 #FUN-C20035---start---mark
 #LET g_sql = "bzc01.bzc_file.bzc01,",
 #            "bzd03.bzd_file.bzd03,",
 #            "bza05.bza_file.bza05,",
 #            "bza06.bza_file.bza06,",
 #            "bza02.bza_file.bza02,",
 #            "bza04.bza_file.bza04,",
 #            "bza08.bza_file.bza08,",
 #            "bza09.bza_file.bza09,",
 #            "bza07.bza_file.bza07,",
 #            "bza10.bza_file.bza10,",
 #            "bza12.bza_file.bza12,",
 #            "bza13.bza_file.bza13,",
 #            "bzd04.bzd_file.bzd04"
#FUN-C20035---end---mark
#FUN-C20035---start---add
  LET g_sql = "bza01.bza_file.bza01,",
              "bza02.bza_file.bza02,",
              "bza03.bza_file.bza03,",
              "bza04.bza_file.bza04,",
              "bza05.bza_file.bza05,",
              "bza06.bza_file.bza06,",
              "bza08.bza_file.bza08,",
              "bza09.bza_file.bza09,",
              "bza07.bza_file.bza07,",
              "bza11.bza_file.bza11,",
              "bza10.bza_file.bza10,",
              "bza12.bza_file.bza12,",
              "bza13.bza_file.bza13,",
              "bzb02.bzb_file.bzb02,",
              "bzb03.bzb_file.bzb03,",
              "bzb04.bzb_file.bzb04,",
              "bzb05.bzb_file.bzb05,",
              "bzb06.bzb_file.bzb06,",
              "bzb14.bzb_file.bzb14,",
              "gem02.gem_file.gem02,",
              "gen02.gen_file.gen02"
#FUN-C20035---end---add
 
  LET l_table = cl_prt_temptable('abxr602',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
              "        ?,?,?,?,?, ?)" #FUN-C20035 add 8? 
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.y     = ARG_VAL(8)
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   IF cl_null(tm.wc) THEN
      CALL r602_tm(0,0)	
   ELSE
      LET tm.wc="bza01= '",tm.wc CLIPPED,"'" #FUN-C20035 bzc01-->bza01
      CALL r602()	
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
FUNCTION r602_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd	        LIKE type_file.chr1000
  
   LET p_row = 5 
   LET p_col = 5 
   OPEN WINDOW r602_w AT p_row,p_col WITH FORM "abx/42f/abxr602"
   ATTRIBUTE (STYLE = g_win_style) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   WHILE TRUE
      INITIALIZE tm.* TO NULL                      # Default condition
      #LET tm.more = 'N' #FUN-C20035 mark
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
      LET tm.y    = 'Y'
 
 
      #CONSTRUCT BY NAME tm.wc ON bzc01,bzc03,bzc04 #FUN-C20035 mark 
      CONSTRUCT BY NAME tm.wc ON bza01 #FUN-C20035 add
 
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
              #FUN-C20035---start---add
               WHEN INFIELD(bza01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_bza1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bza01
                  NEXT FIELD bza01
              #FUN-C20035---end---add
              #FUN-C20035---start---mark
              #WHEN INFIELD(bzc01) #記帳卡編號
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.state = 'c'
              #   LET g_qryparam.form ="q_bzc01"
              #   CALL cl_create_qry() RETURNING g_qryparam.multiret
              #   DISPLAY g_qryparam.multiret TO bzc01
              #   NEXT FIELD bzc01
              #WHEN INFIELD(bzc03) #負責人
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.state = 'c'
              #   LET g_qryparam.form ="q_gen"
              #   CALL cl_create_qry() RETURNING g_qryparam.multiret
              #   DISPLAY g_qryparam.multiret TO bzc03
              #   NEXT FIELD bzc03
              #WHEN INFIELD(bzc04)  #承辦人
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.state = 'c'
              #   LET g_qryparam.form ="q_gen"
              #   CALL cl_create_qry() RETURNING g_qryparam.multiret
              #   DISPLAY g_qryparam.multiret TO bzc04
              #   NEXT FIELD bzc04
              #FUN-C20035---end---mark
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bzauser', 'bzagrup') #FUN-C20035 bzc-->bza
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r602_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
 
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
     DISPLAY BY NAME tm.y
 
     INPUT BY NAME tm.y WITHOUT DEFAULTS #FUN-C20035 delete tm.more
        AFTER FIELD y
           IF tm.y NOT MATCHES "[YyNn]" THEN
              NEXT FIELD y
           END IF
       #FUN-C20035---start---mark
       #AFTER FIELD more
       #   IF tm.more NOT MATCHES "[YyNn]"  THEN
       #      NEXT FIELD more
       #   END IF
       #IF tm.more = 'Y' OR tm.more = 'y' THEN
       #   CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,    #詢問特殊列印條件
       #                  g_bgjob,g_time,g_prtway,g_copies)
       #   RETURNING g_pdate,g_towhom,g_rlang,
       #             g_bgjob,g_time,g_prtway,g_copies
       #END IF
       #FUN-C20035---end---mark
     
        ON ACTION locale
           CALL cl_dynamic_locale()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()

        ON ACTION CONTROLG 
           CALL cl_cmdask()	# Command execution
 
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
 
     END INPUT
     
      IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW r602_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
      END IF
     #FUN-C20035---start---mark 
     #IF g_bgjob = 'Y' THEN
     #   SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
     #    WHERE zz01='abxr602'
 
     #   IF SQLCA.sqlcode OR cl_null(l_cmd)  THEN
     #      CALL cl_err('abxr602','9031',1)
     #   ELSE
     #      LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
     #      LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
     #                  " '",g_pdate CLIPPED,"'",
     #                  " '",g_towhom CLIPPED,"'",
     #                  " '",g_lang CLIPPED,"'",
     #                  " '",g_bgjob CLIPPED,"'",
     #                  " '",g_prtway CLIPPED,"'",
     #                  " '",g_copies CLIPPED,"'",
     #                  " '",tm.wc CLIPPED,"'",
     #                  " '",tm.y CLIPPED,"'"
     #      CALL cl_cmdat('abxr602',g_time,l_cmd)   # Execute cmd at later time
     #   END IF
     #   CLOSE WINDOW r602_w
     #   EXIT PROGRAM
     #END IF
     #FUN-C20035---start---mark
      CALL cl_wait()
      CALL r602()
      ERROR ""
   END WHILE
   CLOSE WINDOW r602_w
END FUNCTION

#FUN-C20035---start---mark 
#FUNCTION r602()
#   DEFINE l_sql  STRING,		# RDSQL STATEMENT
#          sr     RECORD
#             bzc01 LIKE bzc_file.bzc01, #帳卡編號
#             bzd03 LIKE bzd_file.bzd03, #編號
#             bza05 LIKE bza_file.bza05, #型態
#             bza06 LIKE bza_file.bza06, #主件編號 
#             bza02 LIKE bza_file.bza02, #機器設備名稱
#             bza04 LIKE bza_file.bza04, #機器設備規格
#             bza08 LIKE bza_file.bza08, #單位
#             bza09 LIKE bza_file.bza09, #數量
#             bza07 LIKE bza_file.bza07, #報單號碼
#             bza10 LIKE bza_file.bza10, #稅捐記帳金額-->完稅價格
#             bza12 LIKE bza_file.bza12, #放行日期
#             bza13 LIKE bza_file.bza13, #記帳到期日-->五年屆滿日
#             bzd04 LIKE bzd_file.bzd04  #備註
#                END RECORD
# DEFINE l_bza   RECORD LIKE bza_file.*
#   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
#   CALL cl_del_data(l_table)
#  #------------------------------ CR (2) ------------------------------#
#   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
# 
#  CALL cl_used('abxr602',g_time,1) RETURNING g_time
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
# 
#  LET l_sql = "SELECT bzc01,bzd03, ",
#              "       bza05,bza06,bza02,bza04,bza08, ",
#              "       bza09,bza07,bza10, ",
#              "       bza12,bza13,bzd04  ",
#              "  FROM bzc_file,bza_file,bzd_file ", 
#              " WHERE bzd01=bzc01 AND bzd03=bza01 ",
#              "   AND ",tm.wc CLIPPED
# 
#  LET l_sql = l_sql CLIPPED," ORDER BY bzc01"
#  PREPARE r602_prepare1 FROM l_sql
#  IF SQLCA.sqlcode != 0 THEN 
#     CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#     EXIT PROGRAM 
#  END IF
#  DECLARE r602_cs1 CURSOR FOR r602_prepare1
#  LET l_sql = "SELECT * FROM bza_file",
#              " WHERE bza05 = '2'",         #型態是附件
#              "   AND bza06 = ?",
#              "   AND bzaacti = 'Y'"
#  DECLARE r602_bza_cus_n CURSOR FROM l_sql
# 
#  FOREACH r602_cs1 INTO sr.*
#     IF SQLCA.sqlcode != 0 THEN 
#        CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
#     END IF
#     IF tm.y = 'N' THEN
#        LET sr.bza10 = ''
#     END IF
#     
#     LET sr.bza05 = '1'
#     EXECUTE insert_prep USING sr.*
# 
#     INITIALIZE l_bza.* TO NULL
#     FOREACH r602_bza_cus_n USING sr.bzd03
#        INTO l_bza.*
#        IF SQLCA.SQLCODE THEN
#           EXIT FOREACH
#        END IF
#        IF tm.y = 'N' THEN
#           LET l_bza.bza10 = ''
#        END IF
# 
#        EXECUTE insert_prep USING sr.bzc01,
#                                  l_bza.bza05,
#                                  l_bza.bza06,
#                                  l_bza.bza02,
#                                  l_bza.bza04,
#                                  l_bza.bza08,
#                                  l_bza.bza09, 
#                                  l_bza.bza07,
#                                  l_bza.bza10,
#                                  l_bza.bza12,
#                                  l_bza.bza13,
#                                  ' ' #備註
#     END FOREACH
#  END FOREACH
#
#   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
#   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
# 
#   #是否列印選擇條件
#   IF g_zz05 = 'Y' THEN
#      CALL cl_wcchp(tm.wc,'bzc01,bzc03,bzc04')
#           RETURNING g_str
#   ELSE
#      LET g_str = ''
#   END IF
# 
#   LET g_str = g_str,";",g_azi03,";",g_bxz.bxz101
#   CALL cl_prt_cs3('abxr602','abxr602',l_sql,g_str)
#  CALL cl_used('abxr602',g_time,2) RETURNING g_time
#END FUNCTION
##FUN-BC0115
#FUN-C20035---end---mark

#FUN-C20035---start---add
FUNCTION r602()
   DEFINE l_name  LIKE type_file.chr20,        # External(Disk) file name
          l_sql   STRING,
          sr    RECORD 
                bza01 LIKE bza_file.bza01,
                bza02 LIKE bza_file.bza02,
                bza03 LIKE bza_file.bza03,
                bza04 LIKE bza_file.bza04,
                bza05 LIKE bza_file.bza05,
                bza06 LIKE bza_file.bza06,
                bza08 LIKE bza_file.bza08,
                bza09 LIKE bza_file.bza09,
                bza07 LIKE bza_file.bza07,
                bza11 LIKE bza_file.bza11,
                bza10 LIKE bza_file.bza10,
                bza12 LIKE bza_file.bza12,
                bza13 LIKE bza_file.bza13,
                bzb02 LIKE bzb_file.bzb02, 
                bzb03 LIKE bzb_file.bzb03, 
                bzb04 LIKE bzb_file.bzb04, 
                bzb05 LIKE bzb_file.bzb05, 
                bzb06 LIKE bzb_file.bzb06,
                bzb14 LIKE bzb_file.bzb14, 
                gem02 LIKE gem_file.gem02, 
                gen02 LIKE gen_file.gen02 
                END RECORD

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

   LET l_sql = " SELECT bza01,bza02,bza03,bza04,",
               "        bza05,bza06,bza08,bza09,",
               "        bza07,bza11,bza10,bza12,",
               "        bza13,bzb02,bzb03,bzb04,",
               "        bzb05,bzb06,bzb14",
               " FROM bza_file,bzb_file ",
               " WHERE bza01=bzb01 AND ",tm.wc CLIPPED
 
   PREPARE r602_pb FROM l_sql
   DECLARE r602_curs1 CURSOR FOR r602_pb
 
   FOREACH r602_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT FOREACH 
      END IF
      IF cl_null(sr.bza09) THEN LET sr.bza09 =0  END IF
      IF cl_null(sr.bza10) THEN LET sr.bza10 =0  END IF
      IF cl_null(sr.bzb05) THEN LET sr.bzb05 =0  END IF
      SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01=sr.bzb03
      SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01=sr.bzb04
      EXECUTE insert_prep USING sr.*
   END FOREACH

    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'bza01')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
 
    LET g_str = g_str,";",tm.y
 
   CALL cl_prt_cs3('abxr602','abxr602',l_sql,g_str)
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END FUNCTION
#FUN-C20035---end---add
