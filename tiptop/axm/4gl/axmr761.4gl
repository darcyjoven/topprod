# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axmr761.4gl
# Descriptions...: 客訴原因分析表
# Date & Author..: 02/03/26 By Mandy
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: NO.TQC-5B0029 05/11/07 By Nicola 列印位置調整
# Modify.........: No.TQC-5B0212 05/12/01 By kevin 結束位置調整
# Modify.........: No.MOD-640163 06/04/09 By Alexstar 百分比欄位新增 % 符號
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-720004 07/02/01 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/28 By Sarah CR報表串cs3()增加傳一個參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-D10010 13/01/05 By qirl 客訴單號，客戶編號欄位增加開窗
# Modify.........: No.TQC-D10011 13/01/05 By qirl 報表的顯示有誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		     # Print condition RECORD
              wc     STRING,   # Where Condition
              bdate  LIKE type_file.dat,      # No.FUN-680137  DATE
              edate  LIKE type_file.dat,      # No.FUN-680137  DATE
              more   LIKE type_file.chr1     # No.FUN-680137  VARCHAR(1)    # 特殊列印條件
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_total         LIKE type_file.num5     # No.FUN-680137 SMALLINT
DEFINE   g_head1         STRING
DEFINE    l_table     STRING,                 ### FUN-720004 ###
          g_str       STRING,                 ### FUN-720004 ###
          g_sql       STRING                  ### FUN-720004 ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   #str FUN-720004 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.Martin  *** ##
   LET g_sql = "ohe03.ohe_file.ohe03,",
               "ock02.ock_file.ock02,",
               "count.type_file.num10,",
               "pis.ecd_file.ecd12,",      
               "total1.type_file.num5"      
 
   LET l_table = cl_prt_temptable('axmr761',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?)" 
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #end FUN-720004 add
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r761_tm(0,0)	
      ELSE CALL r761()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r761_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r761_w AT p_row,p_col WITH FORM "axm/42f/axmr761"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.bdate  = g_today
   LET tm.edate  = g_today
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON ohc01,ohc06
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
#--TQC-D10010--add--star--
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ohc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_ohc01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohc01
                 NEXT FIELD ohc01

              WHEN INFIELD(ohc06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_ohc06"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohc06
                 NEXT FIELD ohc06
           END CASE

#--TQC-D10010--add--end---
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
       CLOSE WINDOW r761_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
       EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
   END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF tm.edate < tm.bdate THEN NEXT FIELD bdate END IF
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
      CLOSE WINDOW r761_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='axmr761'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr761','9031',1)
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
                         " '",tm.bdate,"'",
                         " '",tm.edate,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr761',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r761_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r761()
   ERROR ""
END WHILE
   CLOSE WINDOW r761_w
END FUNCTION
 
FUNCTION r761()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0094
          l_sql      LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_order    ARRAY[3] of LIKE faj_file.faj02,   # No.FUN-680137 VARCHAR(10)
          sr         RECORD
                     ohe03     LIKE    ohe_file.ohe03,  #原因
                     ock02     LIKE    ock_file.ock02,  #說明
                     count     LIKE type_file.num10,    # No.FUN-680137 INTEGER
                     pis       LIKE ecd_file.ecd12      # No.FUN-680137 DEC(6,3)
                     END RECORD
 
   #str FUN-720004 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720004 *** TSD.Martin  ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720004 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720004 add ###
 
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET l_sql = l_sql clipped," AND ohcuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET l_sql = l_sql clipped," AND ohcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET l_sql = l_sql clipped," AND ohcgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET l_sql = l_sql CLIPPED,cl_get_extra_cond('ohcuser', 'ohcgrup')
   #End:FUN-980030
 
   LET l_sql = " SELECT COUNT(ohe01)",
               "   FROM ohe_file,ohc_file ",
               "  WHERE ",tm.wc CLIPPED,
               "    AND ohe01 = ohc01",
               "    AND ohc02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
               "    AND ohcconf != 'X' "
 
   PREPARE r761_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:r761_p1',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE r761_c1 CURSOR FOR r761_p1
 
   LET l_sql = " SELECT UNIQUE ohe03 ,'',COUNT(ohe03)",
               "   FROM ohe_file,ohc_file ",
               "  WHERE ",tm.wc CLIPPED,
               "    AND ohe01 = ohc01",
               "    AND ohc02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
               "    AND ohcconf != 'X' ",   #--TQC-D10011--add--
               "  GROUP BY ohe03 "
 
   PREPARE r761_p2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:r761_p2',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE r761_c2 CURSOR FOR r761_p2
 
   LET g_pageno = 0
   OPEN r761_c1
   FETCH r761_c1 INTO g_total
   IF SQLCA.sqlcode THEN
       CALL cl_err('fetch:r761_c1',SQLCA.sqlcode,1) RETURN
   END IF
 
   FOREACH r761_c2 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      SELECT ock02 INTO sr.ock02
        FROM ock_file
       WHERE ock01 = sr.ohe03
      LET sr.pis = (sr.count/g_total) * 100
 
      #str FUN-720004 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720004 *** ##
      EXECUTE insert_prep USING 
              sr.ohe03,sr.ock02,sr.count,sr.pis,g_total
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720004 add
   END FOREACH
   
   #str FUN-720004 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720004 **** ##
   LET g_str = '' 
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ohc01,ohc06') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.bdate,";",tm.edate
   CALL cl_prt_cs3('axmr761','axmr761',l_sql,g_str)   #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720004 add
 
END FUNCTION
