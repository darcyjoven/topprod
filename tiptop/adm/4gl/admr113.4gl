# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: admr113.4gl
# Descriptions...: 新舊客戶營業額比較
# Input parameter:
# Date & Author..: 02/07/31 By Kitty
# Modify.........: No.FUN-4C0099 05/01/17 By kim 報表轉XML功能
# Modify.........: No.MOD-530210 05/03/23 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.TQC-5C0057 05/12/12 By kevin 欄位沒對齊
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-750122 07/07/08 By xufeng 新增幣別欄位
# Modify.........: NO.FUN-750027 07/07/18 BY TSD.c123k 改為crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70180 10/07/23 By Sarah 權限控管段抓取的欄位fakuser與fakgrup應改為omauser與omagrup
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				        # Print condition RECORD
              wc      STRING,                           # Where Condition No.TQC-630166  
              bdate   LIKE type_file.dat,              #No.FUN-680097 DATE
              edate   LIKE type_file.dat,              #No.FUN-680097 DATE
              basdate LIKE type_file.dat,              #No.FUN-680097 DATE
              a       LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(01)
              more    LIKE type_file.chr1              # 特殊列印條件   #No.FUN-680097 VARCHAR(01)
              END RECORD
 
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   g_str       STRING          # FUN-750027 TSD.c123k
DEFINE   l_table     STRING          # FUN-750027 TSD.c123k
DEFINE   g_sql       STRING          # FUN-750027 TSD.c123k  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
 
   # add FUN-750027
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "oma56a.oma_file.oma56,", 
               "oma56b.oma_file.oma56,",
               "aza17.aza_file.aza17" 
 
   LET l_table = cl_prt_temptable('admr113',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.basdate= ARG_VAL(10)
   LET tm.a = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   CALL r113_tmp()
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r113_tm(0,0)	
      ELSE CALL r113()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION r113_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680097 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   OPEN WINDOW r113_w AT p_row,p_col
        WITH FORM "adm/42f/admr113"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a      ='1'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON occ01,occ20,occ03,occ21
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      CLOSE WINDOW r113_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.basdate,tm.a,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
         IF cl_null(tm.edate) OR (tm.bdate>tm.edate) THEN
            NEXT FIELD edate
         END IF
 
      AFTER FIELD basdate
         IF cl_null(tm.basdate) THEN
            NEXT FIELD basdate
         END IF
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
            NEXT FIELD a
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r113_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='admr113'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr113','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.basdate CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('admr113',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r113_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r113()
   ERROR ""
END WHILE
   CLOSE WINDOW r113_w
END FUNCTION
 
FUNCTION r113()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0100
          l_sql      LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680097 VARCHAR(1000)
          l_sql1     LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680097 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(40)
          l_oma00     LIKE    oma_file.oma00,    #性質
          l_oma56a    LIKE    oma_file.oma56,    #基準金額1
          sr         RECORD
                     oma56a    LIKE    oma_file.oma56,    #新客戶
                     oma56b    LIKE    oma_file.oma56     #舊客戶
                     END RECORD
 
     # add FUN-750027
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
     # end FUN-750027
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fakuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
    #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup')  #MOD-A70180 mark
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')  #MOD-A70180
     #End:FUN-980030
 
     DELETE FROM admr113_tmp
     #--新客戶營業額
     IF tm.a='1' THEN
       LET l_sql = " SELECT oma00,SUM(oma56) ",    #依帳款
                   " FROM oma_file,occ_file",
                   " WHERE (oma00 ='11' OR oma00='12' OR oma00='13' OR oma00='21')",
                   "  AND  oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   "  AND  occ16 >='",tm.basdate,"' AND oma03=occ01 ",
                   "  AND  omaconf='Y' AND omavoid='N' AND ",tm.wc CLIPPED,
                   "  GROUP BY oma00 "
     ELSE
       LET l_sql = " SELECT oma00,SUM(oma59) ",    #依帳款
                   " FROM oma_file,occ_file",
                   " WHERE (oma00 ='11' OR oma00='12' OR oma00='13' OR oma00='21')",
                   "  AND  oma09 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   "  AND  occ16 >='",tm.basdate,"' AND oma03=occ01 ",
                   "  AND  omaconf='Y' AND omavoid='N' AND ",tm.wc CLIPPED,
                   "  GROUP BY oma00 "
     END IF
 
     PREPARE r113_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     DECLARE r113_c1 CURSOR FOR r113_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
    #CALL cl_outnam('admr113') RETURNING l_name  #FUN-750027 TSD.c123k mark
 
    #START REPORT r113_rep TO l_name  #FUN-750027 TSD.c123k mark
 
     LET g_pageno = 0
     FOREACH r113_c1 INTO l_oma00,l_oma56a
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF l_oma00='21' THEN
          LET l_oma56a=l_oma56a*-1
       END IF
       INSERT INTO admr113_tmp VALUES (l_oma56a,0)
     END FOREACH
 
     #--取舊客戶金額
     IF tm.a='1' THEN
       LET l_sql1= " SELECT oma00,SUM(oma56) ",    #依帳款  
                   " FROM oma_file,occ_file", 
                   " WHERE (oma00 ='11' OR oma00='12' OR oma00='13' OR oma00='21')",
                   "  AND  oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   "  AND  occ16 <'",tm.basdate,"' AND oma03=occ01 ",
                   "  AND  omaconf='Y' AND omavoid='N' AND ",tm.wc CLIPPED,
                   "  GROUP BY oma00 "  
     ELSE
       LET l_sql1= " SELECT oma00,SUM(oma59) ",    #依帳款 
                   " FROM oma_file,occ_file",  
                   " WHERE (oma00 ='11' OR oma00='12' OR oma00='13' OR oma00='21')",
                   "  AND  oma09 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   "  AND  occ16 <'",tm.basdate,"' AND oma03=occ01 ",
                   "  AND  omaconf='Y' AND omavoid='N' AND ",tm.wc CLIPPED,
                   "  GROUP BY oma00 " 
     END IF
 
 
     PREPARE r113_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     DECLARE r113_c2 CURSOR FOR r113_p2
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     FOREACH r113_c2 INTO l_oma00,l_oma56a
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach2:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF l_oma00='21' THEN
          LET sr.oma56a=sr.oma56a*-1
       END IF
       INSERT INTO admr113_tmp VALUES (0,l_oma56a)
     END FOREACH
 
     #--將暫存檔的資料依需求丟到sr列印
     DECLARE r113_temp CURSOR FOR
      SELECT SUM(tmp_oma56a),SUM(tmp_oma56b) FROM admr113_tmp
     FOREACH r113_temp INTO sr.oma56a,sr.oma56b
       IF STATUS THEN CALL cl_err('foreach temp',STATUS,0) EXIT FOREACH END IF
 
          #FUN-750027 TSD.c123k add
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
          EXECUTE insert_prep USING
             sr.oma56a, sr.oma56b, g_aza.aza17
          #------------------------------ CR (3) ------------------------------#
          #FUN-750027 TSD.c123k end
     END FOREACH
 
     #FINISH REPORT r113_rep  #FUN-750027 TSD.c123k mark
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #FUN-750027 TSD.c123k mark
 
     # FUN-750027 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'occ01,occ20,occ03,occ21')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.bdate,";",tm.edate,";",tm.basdate,";",tm.a
  
     CALL cl_prt_cs3('admr113','admr113',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
     # FUN-750027 end
END FUNCTION
FUNCTION r113_tmp()
 
  #No.FUN-750122   --begin
  #CREATE TEMP TABLE admr113_tmp
  # ( tmp_oma56a    DEC(20,6),   #新客戶 #MOD-530210 
  #  tmp_oma56b    DEC(20,6)    #舊客戶 #MOD-530210
  # ) 
  #No.FUN-750122   --end   
  
  #No.FUN-750122   --begin
    CREATE TEMP TABLE admr113_tmp
    (tmp_oma56a LIKE type_file.num20_6,
     tmp_oma56b LIKE type_file.num20_6)
  #No.FUN-750122   --end   
 
END FUNCTION
