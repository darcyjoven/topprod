# Prog. Version..: '5.30.06-13.04.03(00010)'     #
#
# Pattern name...: apmr257.4gl
# Desc/riptions..: 採購價格調幅表
# Date & Author..: 97/08/25 By Kitty
# Modify.........: No.FUN-4C0095 04/12/22 By Mandy 報表轉XML
 # Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 修改結束定位點
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6C0077 06/12/15 By Judy 報表排列順序未打印
# Modify.........: No.TQC-6C0139 06/12/25 By Mandy 採購金額有誤
# Modify.........: No.FUN-720010 07/02/07 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.TQC-930160 09/03/30 By chenyu 采購單價（起）應該取第一筆不是0的單價，如果全都是0或者為NULL，則取0
# Modify.........: No.TQC-970091 09/07/08 By sherry 計算調幅公式有誤，應是（采購單價(訖)-采購單價(起)）/采購單價(起))*100
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No.TQC-B30072 11/03/07 By lilingyu 料件編號開窗後,選擇全部資料,然後確定,程序報錯:找到一個未成對的引號
# Modify.........: No.MOD-CA0198 12/11/26 By jt_chen 此調幅是為了看這個區間最近一次採購時的採購價格與這個區間之前最後一次的採購價格浮動,故還原MOD-CA0143的調整
# Modify.........: No:TQC-CC0108 12/12/24 By qirl 【厂商编号】栏位建议增加开窗 报表中料件增加规格
# Modify.........: No:MOD-D30275 13/04/01 By Vampire 料件編號若為MISC 料，應列印採購單身之品名
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				 # Print condition RECORD
              #   wc   VARCHAR(1000),	 	 # Where condition
                 wc  	STRING,	               	 #TQC-630166 # Where condition
                 pmm04a LIKE type_file.dat,      #No.FUN-680136 DATE
                 pmm04b LIKE type_file.dat,      #No.FUN-680136 DATE
                 s      LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3) chr4  
                 t      LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3) chr4  
                 u      LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3) chr4  
                 a      LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
                 a1     LIKE type_file.num5,     #No.FUN-680136 SMALLINT
                 a2     LIKE type_file.num5,     #No.FUN-680136 SMALLINT
                 more	LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_aza17        LIKE aza_file.aza17,    # 本國幣別
          g_total1       LIKE pmn_file.pmn31,    #MOD-530190
           g_total2       LIKE pmn_file.pmn31    #MOD-530190
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE l_table        STRING,                 ### FUN-720010 ###
       g_str          STRING,                 ### FUN-720010 ###
       g_sql          STRING                  ### FUN-720010 ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
## *** FUN-720010 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.Martin  *** ##
    LET g_sql = " pmm09.pmm_file.pmm09, ",  # 廠商
                " pmc03.pmc_file.pmc03, ",  # 廠商簡稱
                " pmm22.pmm_file.pmm22, ",	
                " pmm42.pmm_file.pmm42, ",	
                " pmn04.pmn_file.pmn04, ",  # 料號
                " ima02.ima_file.ima02, ",  # 品名
                " ima021.ima_file.ima021, ",  #--TQC-CC0108--add
                " pmm01a.pmm_file.pmm01,",  # 採購單號起
                " pmm04a.pmm_file.pmm04,",  # 日期
                " pmn31a.pmn_file.pmn31,",  # 單價(起)
                " tot.pmn_file.pmn31,   ",  #MOD-530190
                " pmm01b.pmm_file.pmm01,",  # 採購單號止
                " pmm04b.pmm_file.pmm04,",  # 日期
                " pmn31b.pmn_file.pmn31, ", # 單價(止)
               #" rr.type_file.num5 "       #MOD-CA0198 mark
                " rr.type_file.num15_3 "    #MOD-CA0198 add 
 
    LET l_table = cl_prt_temptable('apmr257',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
                " VALUES(?, ?, ?, ?, ?,   ?, ? , ?, ? , ?, ",
                "        ?, ?, ?, ?       ,?)"   #--TQC-CC0108--add--1?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.pmm04a  = ARG_VAL(8)
   LET tm.pmm04b  = ARG_VAL(9)
   LET tm.s  = ARG_VAL(10)
   LET tm.t  = ARG_VAL(11)
   LET tm.u  = ARG_VAL(12)
   LET tm.a  = ARG_VAL(13)
   LET tm.a1 = ARG_VAL(14)
   LET tm.a2 = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r257_tm(0,0)		# Input print condition
      ELSE CALL apmr257()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r257_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 11
 
   OPEN WINDOW r257_w AT p_row,p_col WITH FORM "apm/42f/apmr257"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.pmm04a=g_today
   LET tm.pmm04b=g_today
   LET tm.s    = '12'
   LET tm.t    = ' '
   LET tm.u    = ' '
   LET tm.a    = 'N'
   LET tm.a1   = 0
   LET tm.a2   = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm09,pmn04
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP
            IF INFIELD(pmn04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmn04
               NEXT FIELD pmn04
            END IF
    #--TQC-CC0108---add---star--
            IF INFIELD(pmm09) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmm091"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmm09
               NEXT FIELD pmm09
    #--TQC-CC0108---add---end----
            END IF
#No.FUN-570243 --end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r257_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
 
   DISPLAY BY NAME tm2.s1,tm2.s2, tm2.t1,tm2.t2, tm2.u1,tm2.u2,
                   tm.pmm04a,tm.pmm04b,tm.a,tm.a1,tm.a2,tm.more
   INPUT BY NAME tm2.s1,tm2.s2, tm2.t1,tm2.t2, tm2.u1,tm2.u2,
            tm.pmm04a,tm.pmm04b,tm.a,tm.a1,tm.a2,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD pmm04a
         IF cl_null(tm.pmm04a) THEN NEXT FIELD pmm04a END IF
 
      AFTER FIELD pmm04b
         IF cl_null(tm.pmm04b) OR tm.pmm04b<tm.pmm04a THEN
            NEXT FIELD pmm04b
         END IF
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
 
      AFTER FIELD a1
         IF cl_null(tm.a1) THEN NEXT FIELD a1 END IF
 
      AFTER FIELD a2
         IF cl_null(tm.a2) OR (tm.a2<tm.a1) THEN NEXT FIELD a2 END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more)
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
         LET tm.u = tm2.u1,tm2.u2
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
      LET INT_FLAG = 0 CLOSE WINDOW r257_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr257'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr257','9031',1)
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
                         " '",tm.pmm04a CLIPPED,"'",
                         " '",tm.pmm04b CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.a1 CLIPPED,"'",
                         " '",tm.a2 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr257',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r257_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr257()
   ERROR ""
END WHILE
   CLOSE WINDOW r257_w
END FUNCTION
 
FUNCTION apmr257()
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	      # Used time for running the job   #No.FUN-680136 VARCHAR(8)
#         l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)         #TQC-B30072
          l_sql 	STRING,                                                                                              #TQC-B30072
          l_chr		LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_za05	LIKE za_file.za05,            #No.FUN-680136 VARCHAR(40)
          l_order	ARRAY[2] OF  LIKE pmn_file.pmn04,        #No.FUN-680136 VARCHAR(40)
          sr               RECORD order1 LIKE pmn_file.pmn04,    #No.FUN-680136 VARCHAR(40)
                                  order2 LIKE pmn_file.pmn04,    #No.FUN-680136 VARCHAR(40)
                                  pmm09 LIKE pmm_file.pmm09, 	 # 廠商
                                  pmc03 LIKE pmc_file.pmc03,     # 廠商簡稱
                                  pmm22 LIKE pmm_file.pmm22,	
                                  pmm42 LIKE pmm_file.pmm42,	
                                  pmn04 LIKE pmn_file.pmn04, 	 # 料號
                                  ima02 LIKE ima_file.ima02, 	 # 品名
                                  ima021 LIKE ima_file.ima021,    #--TQC-CC0108--add
                                  pmm01a LIKE pmm_file.pmm01,    # 採購單號起
                                  pmm04a LIKE pmm_file.pmm04,    # 日期
                                  pmn31a LIKE pmn_file.pmn31,    # 單價(起)
                                  tot    LIKE pmn_file.pmn31,    # MOD-530190
                                  pmm01b LIKE pmm_file.pmm01,    # 採購單號止
                                  pmm04b LIKE pmm_file.pmm04,    # 日期
                                  pmn31b LIKE pmn_file.pmn31,    # 單價(止)
                                 #rr2   LIKE type_file.num5      # No.FUN-680136 SMALLINT   # MOD-CA0198 mark
                                  rr2   LIKE type_file.num15_3   # MOD-CA0198 add 
                        END RECORD
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720010 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720010 add ###
     #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','',",
                #"   pmm09,pmc03, pmm22,pmm42,pmn04,ima02,ima021,' ',' ',0,",   #--TQC-CC0108--add #MOD-D30275 mark
                 "   pmm09,pmc03, pmm22,pmm42,pmn04,pmn041,ima021,' ',' ',0,",   #MOD-D30275 add
                #"   SUM(pmn20*pmn31*pmm42),' ',' ',0,0 ", #TQC-6C0139 mark
                 "   SUM(pmn87*pmn31*pmm42),' ',' ',0,0 ", #TQC-6C0139 mod
                 " FROM pmm_file,pmn_file, ",
                 " OUTER pmc_file, OUTER ima_file ",
                 " WHERE pmm01=pmn01 AND pmm_file.pmm09 = pmc_file.pmc01 AND pmn_file.pmn04 = ima_file.ima01 ",
                 "  AND pmn16 NOT IN ('X','0','1','9') ",
                 "  AND pmm04 BETWEEN '",tm.pmm04a,"' AND '",tm.pmm04b,"'",
                 " AND ",tm.wc
    #LET l_sql = l_sql CLIPPED," GROUP BY pmm09,pmc03,pmm22,pmm42,pmn04,ima02 ,ima021 "          #--TQC-CC0108--add #MOD-D30275 mark
     LET l_sql = l_sql CLIPPED," GROUP BY pmm09,pmc03,pmm22,pmm42,pmn04,pmn041 ,ima021 "          #MOD-D30275 add
     PREPARE r257_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r257_cs1 CURSOR FOR r257_prepare1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
 
     LET g_pageno = 0
     FOREACH r257_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       FOR g_i = 1 TO 2
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pmm09
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pmn04
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       IF cl_null(sr.tot) THEN LET sr.tot=0 END IF
       # 取起始採購單價,日期,單號
       LET l_sql ="SELECT pmm01,pmm04,pmn31 FROM pmm_file,pmn_file ",
                  "WHERE pmm01=pmn01 AND pmn16 NOT IN ('X','0','1','9') ",
                  "AND pmm09='",sr.pmm09,"' AND pmn04='",sr.pmn04,"'",
                  "   AND pmm04<'",tm.pmm04a,"'",
                  " ORDER BY pmm04 DESC "
       PREPARE r257_prepare2 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
           EXIT PROGRAM
              
       END IF
       DECLARE r257_cs2 CURSOR FOR r257_prepare2
       FOREACH r257_cs2 INTO sr.pmm01a,sr.pmm04a,sr.pmn31a
          IF cl_null(sr.pmn31a) THEN LET sr.pmn31a=0 END IF
          #No.TQC-930160 add --begin
          IF sr.pmn31a=0 THEN 
             CONTINUE FOREACH 
          END IF
          #No.TQC-930160 add --end
          EXIT FOREACH
       END FOREACH
       # 取截止採購單價,日期,單號
       LET l_sql ="SELECT pmm01,pmm04,pmn31 FROM pmm_file,pmn_file ",
                  "WHERE pmm01=pmn01 AND pmn16 NOT IN ('X','0','1','9') ",
                  "AND pmm09='",sr.pmm09,"' AND pmn04='",sr.pmn04,"'",
                  "   AND pmm04<'",tm.pmm04b,"'",
                  " ORDER BY pmm04 DESC "
       PREPARE r257_prepare3 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
           EXIT PROGRAM
              
       END IF
       DECLARE r257_cs3 CURSOR FOR r257_prepare3
       FOREACH r257_cs3 INTO sr.pmm01b,sr.pmm04b,sr.pmn31b
          IF cl_null(sr.pmn31b) THEN LET sr.pmn31b=0 END IF
          EXIT FOREACH
       END FOREACH
       # 計算調幅
        IF sr.pmn31b!=0 THEN
           #LET sr.rr2=(sr.pmn31b-sr.pmn31a)/sr.pmn31b*100    #TQC-970091 mark
           LET sr.rr2=(sr.pmn31b-sr.pmn31a)/sr.pmn31a*100     #TQC-970091 add
        ELSE
           LET sr.rr2=0
        END IF
        IF tm.a='Y' THEN
           IF sr.rr2>=tm.a1 AND sr.rr2<=tm.a2 THEN
              CONTINUE FOREACH
           END IF
        END IF
        LET sr.rr2 = cl_digcut(sr.rr2,2)   #MOD-CA0198 add
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
       EXECUTE insert_prep USING 
               sr.pmm09,sr.pmc03,sr.pmm22,sr.pmm42,sr.pmn04,
               sr.ima02,sr.ima021,sr.pmm01a,sr.pmm04a,sr.pmn31a,sr.tot,   #--TQC-CC0108--add
               sr.pmm01b,sr.pmm04b,sr.pmn31b,sr.rr2 
       #------------------------------ CR (3) ------------------------------#
     END FOREACH
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pmm09,pmn04') 
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t,";",tm.u
                      ,";",g_azi03,";",g_azi04,";",g_azi05   #FUN-710080 add
     CALL cl_prt_cs3('apmr257','apmr257',l_sql,g_str)        #FUN-710080 modify
     #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
