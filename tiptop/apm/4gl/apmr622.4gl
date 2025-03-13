# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: apmr622.4gl
# Descriptions...: 採購收貨統計分析表
# Input parameter:
# Date & Author..: 93/02/10 By Keith
# Modify.........: No.FUN-4C0095 05/01/05 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6A0089 06/11/07 By xumin 對品名截位供應商編號及簡稱列印
# Modify.........: No.FUN-720010 07/02/08 By TSD.Hazel 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-910033 09/02/12 by ve007 抓取作業編號時，委外要區分制程和非制程
# Modify.........: No.TQC-950170 09/06/08 By destiny 程式可能會有溢出問題 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No.FUN-A60027 10/06/21 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/29 By vealxu 製造功能優化-平行制程
# Modify.........: No.TQC-B10253 11/02/11 By lilingyu 產生報表資料的sql 語句錯誤,漏寫了pmn012
# Modify.........: No.TQC-C30176 12/03/09 By suncx l_buf類型定義錯誤 
# Modify.........: No.MOD-C70096 12/07/09 By Elise 修正重新計算收貨量、入庫量、驗退量
# Modify.........: No.TQC-C80046 12/08/06 By dongsz 下條件時*和具體某個料號所打出報表的數據應相同
# Modify.........: No.MOD-C80129 12/08/23 By Elise 查詢收貨與入庫的SQL，group by 增加pmn012

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	       #wc   VARCHAR(500),	     	# Where condition   #TQC-630166 mark
		wc  	STRING,	     	        # Where condition   #TQC-630166
                bdate   LIKE type_file.dat,     #No.FUN-680136 DATE 
                edate   LIKE type_file.dat,     #No.FUN-680136 DATE
                a       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  
              END RECORD,
          g_today1  LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          g_year    LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          g_season  LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          g_month   LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          g_month1  LIKE aba_file.aba18     #No.FUN-680136 VARCHAR(2)
   DEFINE g_i       LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
   DEFINE l_table   STRING,                 ### FUN-720010 ###
          g_str     STRING,                 ### FUN-720010 ###
          g_sql     STRING                  ### FUN-720010 ###
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
 
## *** FUN-720010 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.Hazel  *** ##
    LET g_sql = "order1.pmn_file.pmn40, ",
                "pmn04.pmn_file.pmn04,",     #料號
                "pmn041.pmn_file.pmn041,",   #品名
                "ima25.ima_file.ima25,",     #庫存單位
                "pmm09.pmm_file.pmm09,",     #供應廠商
                "pmn20.pmn_file.pmn20,",     #訂購量
                "rvb07.rvb_file.rvb07,",     #收貨數量
                "rvv171.rvv_file.rvv17,",    #入庫量
                "rvv172.rvv_file.rvv17,",    #驗退量
                "rvv173.rvv_file.rvv17,",    #倉退量
                "pmc03.pmc_file.pmc03, ",    #簡稱
                "ima021.ima_file.ima021,",   #規格 
                "pmh02.pmh_file.pmh02 "      #主要供應商編號
 
    LET l_table = cl_prt_temptable('apmr622',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
                " VALUES(?, ?, ?, ?, ?,   ?, ? , ?, ? , ?, ",
                "        ?, ?, ? )"
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
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.a     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       #If background job sw is off
      CALL r622_tm(0,0)             		# Input print condition
   ELSE 	                               	# Read data and create out-file
      CALL r622()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r622_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r622_w AT p_row,p_col WITH FORM "apm/42f/apmr622"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.a     = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmn04,pmm09
#No.FUN-570243 --start--
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
#No.FUN-570243 --end--
 
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
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r622_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM 
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.bdate,tm.edate,tm.a,tm.more
   INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         IF tm.edate<tm.bdate THEN NEXT FIELD bdate END IF
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
            NEXT FIELD a
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
      CLOSE WINDOW r622_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr622'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr622','9031',1)
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
                         " '",tm.a    ,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr622',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r622_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r622()
   ERROR ""
END WHILE
CLOSE WINDOW r622_w
END FUNCTION
 
FUNCTION r622()
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	      # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql 	LIKE type_file.chr1000,       # RDSQL STATEMENT  #TQC-630166 mark   #No.FUN-680136 VARCHAR(1000)
          l_sql 	STRING,	     	              #RDSQL STATEMENT   #TQC-630166
          l_chr		LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
         #l_buf         LIKE type_file.chr1000,       #TQC-630166 mark   #No.FUN-680136 VARCHAR(1000)   #TQC-C30176 mark
         #l_buf         STRING,                       #TQC-630166
          l_buf         STRING,                       #TQC-C30176 add
          l_i,l_j       LIKE type_file.num5,          #No.FUN-680136 SMALLINT
         #l_wc          LIKE type_file.chr1000,       #TQC-630166 mark   #No.FUN-680136 VARCHAR(1000)
          l_wc          STRING,       #TQC-630166
          l_za05	LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
          l_rvu00       LIKE rvu_file.rvu00,
          sr           RECORD
                        order1   LIKE pmn_file.pmn40,        #No.FUN-680136 VARCHAR(24)
                        pmn04    LIKE pmn_file.pmn04,        #料件編號
                        pmn041   LIKE pmn_file.pmn041,       #FUN-4C0095
                        ima25    LIKE ima_file.ima25,        #庫存單位
                        pmm09    LIKE pmm_file.pmm09,        #供應廠商
                        pmn20    LIKE pmn_file.pmn20,        #訂購量
                        rvb07    LIKE rvb_file.rvb07,        #收貨量
                        rvv171   LIKE rvv_file.rvv17,        #入庫量
                        rvv172   LIKE rvv_file.rvv17,        #驗退量
                        rvv173   LIKE rvv_file.rvv17,        #倉退量
                        pmc03    LIKE pmc_file.pmc03,        #FUN-720010簡稱
                        ima021   LIKE ima_file.ima021,       #FUN-720010規格 
                        pmh02    LIKE pmh_file.pmh02         #FUN-720010主要供應商編號
                        END RECORD
   DEFINE               l_pmm02  LIKE pmm_file.pmm02,   #No.CHI-8C0017
                        l_pmn18  LIKE pmn_file.pmn18,   #No.CHI-8C0017  
                        l_pmn41  LIKE pmn_file.pmn41,   #No.CHI-8C0017
                        l_pmn43  LIKE pmn_file.pmn43,   #No.CHI-8C0017
                        l_pmh21  LIKE pmh_file.pmh21,   #No.CHI-8C0017
                        l_pmh22  LIKE pmh_file.pmh22,   #No.CHI-8C0017
                        l_cnt    LIKE type_file.num5   #No.CHI-8C0017                        
   DEFINE               l_pmn012 LIKE pmn_file.pmn012  #No.FUN-A60027  
 
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
 
     #計算訂購量(pmn_file)
     LET l_sql = "SELECT ' ',pmn04,pmn041,ima25,pmm09,SUM(pmn20*pmn09), ",
                 "       0,0,0,0,'','','',pmm02,pmn18,pmn41,pmn43,pmn012 ",            #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43  #FUN-A60027 add pmn012
                 " FROM pmm_file,pmn_file LEFT OUTER JOIN ima_file ON pmn04 = ima01",
                 " WHERE pmn04 = ima_file.ima01 AND pmm01 = pmn01  AND " ,
                 " pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND pmm18 <> 'X' AND ",tm.wc CLIPPED,
                 " GROUP BY pmn04,pmn041,ima25,pmm09,pmm02,pmn18,pmn41,pmn43,pmn012 "  #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43 
                                                                                       #TQC-B10253 add pmn012
     PREPARE r622_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
 
     DECLARE r622_cs1 CURSOR FOR r622_prepare1
 
     LET g_pageno = 0
     LET l_cnt = 0                                    #CHI-8C0017
     FOREACH r622_cs1 INTO sr.*,l_pmm02,l_pmn18,l_pmn41,l_pmn43,l_pmn012                  #CHI-8C0017 Add l_pmm02,l_pmn18,l_pmn41,l_pmn43  #FUN-A60027 add l_pmn012
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET sr.order1 = tm.a 
       IF tm.a='1' THEN
          LET sr.pmm09=' '
       END IF

       #計算收貨量、入庫量、驗退量(rvb07)
      #MOD-C70096---add-S---
  #    LET tm.wc = cl_replace_str(tm.wc,"pmn04","rvb05")        #TQC-C80046 mark
       LET l_sql="SELECT SUM(rvb07),SUM(rvb30),SUM(rvb29) ",
                 "  FROM rvb_file ",
                 "  LEFT OUTER JOIN ima_file ",
                 "    ON (rvb_file.rvb05 = ima_file.ima01) ",
                 "       ,rva_file ",
                 " WHERE rva01 = rvb01 ",
                 "   AND rva06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                 "   AND rvaconf <> 'X' ",
  #              "   AND ",tm.wc CLIPPED ,                     #TQC-C80046 mark
                 "   AND rvb05 = '",sr.pmn04,"' "              #TQC-C80046 add
       PREPARE rvb07_cs FROM l_sql
       EXECUTE rvb07_cs INTO sr.rvb07,sr.rvv171,sr.rvv172

  #    LET tm.wc = cl_replace_str(tm.wc,"rvb05","rvv31")       #TQC-C80046 mark
       LET l_sql="SELECT SUM(rvv17) ",
                 "  FROM rvv_file ",
                 "  LEFT OUTER JOIN ima_file ",
                 "    ON (rvv_file.rvv31 = ima_file.ima01) ",
                 "       ,rvu_file ",
                 " WHERE rvv01 = rvu01 ",
                 "   AND rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                 "   AND rvu00='3' ",
                 "   AND rvuconf <> 'X' ",
  #              "   AND ",tm.wc CLIPPED                       #TQC-C80046 mark
                 "   AND rvv31 = '",sr.pmn04,"' "              #TQC-C80046 add
       PREPARE rvv_cs FROM l_sql
       EXECUTE rvv_cs INTO sr.rvv173

       IF sr.rvb07=sr.rvv171 AND (sr.rvv172<>0 OR sr.rvv173<>0) THEN
          LET sr.rvv171=sr.rvv171-sr.rvv172
          LET sr.rvv171=sr.rvv171-sr.rvv173
       END IF
      #MOD-C70096---add-E---

       IF cl_null(sr.pmn20) THEN LET sr.pmn20 = 0 END IF 
       IF cl_null(sr.rvb07) THEN LET sr.rvb07 = 0 END IF 
       IF cl_null(sr.rvv171) THEN LET sr.rvv171 = 0 END IF 
       IF cl_null(sr.rvv172) THEN LET sr.rvv172 = 0 END IF 
       IF cl_null(sr.rvv173) THEN LET sr.rvv173 = 0 END IF 
       #取得pmc03
       #CHI-8C0017--Begin--#                             
       IF l_pmm02='SUB' THEN
          LET l_pmh22='2'
          #NO,TQC-910033  --begin--
          IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
             LET l_pmh21 =' '
          ELSE
          #NO.TQC-910033 --end--
            IF NOT cl_null(l_pmn18) THEN
             SELECT sgm04 INTO l_pmh21 FROM sgm_file
              WHERE sgm01=l_pmn18
                AND sgm02=l_pmn41
                AND sgm03=l_pmn43
                AND sgm012 = l_pmn012   #FUN-A60076
            ELSE
             SELECT ecm04 INTO l_pmh21 FROM ecm_file 
              WHERE ecm01=l_pmn41
                AND ecm03=l_pmn43
                AND ecm012 = l_pmn012   #FUN-A60027
            END IF
          END IF         #NO.TQC-910033
       ELSE
          LET l_pmh22='1'
          LET l_pmh21=' '
       END IF
       #CHI-8C0017--End--#       
       SELECT pmh02 INTO sr.pmh02 FROM pmh_file   
        WHERE pmh01=sr.pmn04
#         AND pmh21 = " "                                             #CHI-860042      #CHI-8C0017 Mark
#         AND pmh22 = '1'                                             #CHI-860042      #CHI-8C0017 Mark
          AND pmh21 = l_pmh21                                                          #CHI-8C0017
          AND pmh22 = l_pmh22                                                          #CHI-8C0017
          AND pmh23 = ' '                                             #No.CHI-960033
          AND pmhacti = 'Y'                                           #CHI-910021          
       IF SQLCA.sqlcode THEN LET sr.pmh02 =  NULL END IF                
       IF tm.a='2' THEN
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01=sr.pmm09
           IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF
       ELSE
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01= sr.pmh02
          IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF               
       END IF               
       IF tm.a = '1' THEN 
          LET sr.pmm09 = sr.pmh02 
       END IF 
       SELECT ima021 INTO sr.ima021 FROM ima_file
        WHERE ima01 = sr.pmn04 
       LET sr.pmc03 = sr.pmc03[1,10]
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
       EXECUTE insert_prep USING 
           sr.order1,sr.pmn04,sr.pmn041,sr.ima25,sr.pmm09,sr.pmn20,
           sr.rvb07,sr.rvv171,sr.rvv172,sr.rvv173,sr.pmc03,sr.ima021,sr.pmh02
       #------------------------------ CR (3) ------------------------------#
     END FOREACH
     #計算收貨量(rvb_file)
     LET l_buf=tm.wc
     LET l_j=length(l_buf)
     #NO.TQC-950170--begin
#    FOR l_i=1 TO l_j
#        IF l_buf[l_i,l_i+4]='pmn04' THEN LET l_buf[l_i,l_i+4]='rvb05' END IF
#        IF l_buf[l_i,l_i+4]='pmm09' THEN LET l_buf[l_i,l_i+4]='rva05' END IF
#    END FOR
     LET l_buf=cl_replace_str(l_buf,"pmn04","rvb05")                                                                                
     LET l_buf=cl_replace_str(l_buf,"pmm09","rva05")                                                                                
     #NO.TQC-950170--end
     LET l_wc = l_buf
     LET l_sql = "SELECT ' ',rvb05,ima02,ima25,rva05,0,SUM(rvb07*pmn09), ",
                 "       0,0,0,'','','',pmm02,pmn18,pmn41,pmn43,pmn012 ",                          #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43  #FUN-A60027 add pmn012
                 " FROM rva_file,rvb_file LEFT OUTER JOIN ima_file ON rvb05=ima_file.ima01 ,pmn_file,pmm_file ",               #CHI-8C0017 Add pmm_file
                 " WHERE rva01 = rvb01 AND ",
                 " rvaconf !='X' AND ",
                 " rvb04 = pmn01 AND rvb03 = pmn02 AND ",
                 " rvb04 = pmm01 AND ",                                                     #CHI-8C0017
                 " rva06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND ",l_wc CLIPPED,
                 " GROUP BY rvb05,ima02,ima25,rva05,pmm02,pmn18,pmn41,pmn43,pmn012 " #add ima02    #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43  #MOD-C80129 add pmn012
     PREPARE r622_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare 2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r622_cs2 CURSOR FOR r622_prepare2
     LET l_cnt = 0                                    #CHI-8C0017
     FOREACH r622_cs2 INTO sr.*,l_pmm02,l_pmn18,l_pmn41,l_pmn43,l_pmn012                  #CHI-8C0017 Add l_pmm02,l_pmn18,l_pmn41,l_pmn43  #FUN-A60027 add l_pmn012
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach 2:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.pmn20) THEN LET sr.pmn20 = 0 END IF 
       IF cl_null(sr.rvb07) THEN LET sr.rvb07 = 0 END IF 
       IF cl_null(sr.rvv171) THEN LET sr.rvv171 = 0 END IF 
       IF cl_null(sr.rvv172) THEN LET sr.rvv172 = 0 END IF 
       IF cl_null(sr.rvv173) THEN LET sr.rvv173 = 0 END IF 
       IF tm.a='1' THEN
          LET sr.pmm09=' '
       END IF
       #取得pmc03
       #CHI-8C0017--Begin--#                             
       IF l_pmm02='SUB' THEN
          LET l_pmh22='2'
          #NO,TQC-910033  --begin--
          IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
             LET l_pmh21 =' '
          ELSE
          #NO.TQC-910033 --end--
            IF NOT cl_null(l_pmn18) THEN
             SELECT sgm04 INTO l_pmh21 FROM sgm_file
              WHERE sgm01=l_pmn18
                AND sgm02=l_pmn41
                AND sgm03=l_pmn43
                AND sgm012 = l_pmn012   #FUN-A60076  
            ELSE
             SELECT ecm04 INTO l_pmh21 FROM ecm_file 
              WHERE ecm01=l_pmn41
                AND ecm03=l_pmn43
                AND ecm012 = l_pmn012   #FUN-A60027
            END IF    
          END IF             #No.TQC-910033
       ELSE
          LET l_pmh22='1'
          LET l_pmh21=' '
       END IF
       #CHI-8C0017--End--#       
       SELECT pmh02 INTO sr.pmh02 FROM pmh_file   
        WHERE pmh01=sr.pmn04
#         AND pmh21 = " "                                             #CHI-860042      #CHI-8C0017 Mark
#         AND pmh22 = '1'                                             #CHI-860042      #CHI-8C0017 Mark
          AND pmh21 = l_pmh21                                                          #CHI-8C0017
          AND pmh22 = l_pmh22                                                          #CHI-8C0017
          AND pmh23 = ' '                                             #No.CHI-960033
          AND pmhacti = 'Y'                                           #CHI-910021          
       IF SQLCA.sqlcode THEN LET sr.pmh02 =  NULL END IF                
       IF tm.a='2' THEN
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01=sr.pmm09
           IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF
       ELSE
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01= sr.pmh02
          IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF               
       END IF               
       SELECT ima021 INTO sr.ima021 FROM ima_file
        WHERE ima01 = sr.pmn04 
       LET sr.pmc03 = sr.pmc03[1,10]
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
       EXECUTE insert_prep USING 
           sr.order1,sr.pmn04,sr.pmn041,sr.ima25,sr.pmm09,sr.pmn20,
           sr.rvb07,sr.rvv171,sr.rvv172,sr.rvv173,sr.pmc03,sr.ima021,sr.pmh02
       #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
     #計算入/退量(rvv_file)
     LET l_buf=tm.wc
     #TQC-C30176 modify begin------------------------------
     #LET l_j=length(l_buf)
     #FOR l_i=1 TO l_j
     #   IF l_buf[l_i,l_i+4]='pmn04' THEN LET l_buf[l_i,l_i+4]='rvv31' END IF
     #   IF l_buf[l_i,l_i+4]='pmm09' THEN LET l_buf[l_i,l_i+4]='rvu04' END IF
     #END FOR
     LET l_buf=cl_replace_str(l_buf,"pmn04","rvv31")
     LET l_buf=cl_replace_str(l_buf,"pmm09","rvu04")
     #TQC-C30176 modify end--------------------------------
     LET l_wc = l_buf
     LET l_sql = "SELECT ' ',rvv31,rvv031,ima25,rvu04,0,0,SUM(rvv17*rvv35_fac),", #FUN-4C0095 add rvv031
                 "       0,0,'','','',rvu00,pmm02,pmn18,pmn41,pmn43,pmn012 ",                 #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43  #FUN-A60027 add pmn012 
                 " FROM rvu_file,rvv_file LEFT OUTER JOIN ima_file ON rvv31=ima_file.ima01 ,rvb_file,pmm_file,pmn_file ",#CHI-8C0017 Add rvb_file,pmn_file,pmm_file
                 " WHERE rvu01 = rvv01  AND " ,
                 " rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND rvv04 = rvb01 AND rvv05 = rvb02 ",                              #CHI-8C0017
                 " AND rvb04 = pmn01 AND rvb03 = pmn02 ",                              #CHI-8C0017
                 " AND rvb04 = pmm01 ",                                                #CHI-8C0017
                 " AND rvuconf !='X' AND ",l_wc CLIPPED,
                 " GROUP BY rvv31,rvv031,ima25,rvu04,rvu00,pmm02,pmn18,pmn41,pmn43,pmn012 " #add rvv031 #FUN-4C0095  #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43  #MOD-C80129 add pmn012
     PREPARE r622_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare 3:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r622_cs3 CURSOR FOR r622_prepare3
     LET l_cnt = 0                                    #CHI-8C0017
     FOREACH r622_cs3 INTO sr.*,l_rvu00,l_pmm02,l_pmn18,l_pmn41,l_pmn43,l_pmn012                #CHI-8C0017 Add l_pmm02,l_pmn18,l_pmn41,l_pmn43  #FUN-A60027 add l_pmn012
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach 3:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_rvu00='2' THEN
          LET sr.rvv172 = sr.rvv171
          LET sr.rvv171 = 0
       END IF
       IF l_rvu00='3' THEN
          LET sr.rvv173 = sr.rvv171
          LET sr.rvv171 = 0
       END IF
       IF cl_null(sr.pmn20) THEN LET sr.pmn20 = 0 END IF 
       IF cl_null(sr.rvb07) THEN LET sr.rvb07 = 0 END IF 
       IF cl_null(sr.rvv171) THEN LET sr.rvv171 = 0 END IF 
       IF cl_null(sr.rvv172) THEN LET sr.rvv172 = 0 END IF 
       IF cl_null(sr.rvv173) THEN LET sr.rvv173 = 0 END IF 
 
       IF tm.a='1' THEN
          LET sr.pmm09=' '
       END IF
 
       #取得pmc03
       #CHI-8C0017--Begin--#                               
       IF l_pmm02='SUB' THEN
          LET l_pmh22='2'
          #NO,TQC-910033  --begin--
          IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
             LET l_pmh21 =' '
          ELSE
          #NO.TQC-910033 --end--
            IF NOT cl_null(l_pmn18) THEN
             SELECT sgm04 INTO l_pmh21 FROM sgm_file
              WHERE sgm01=l_pmn18
                AND sgm02=l_pmn41
                AND sgm03=l_pmn43
                AND sgm012 = l_pmn012   #FUN-A60076
            ELSE
             SELECT ecm04 INTO l_pmh21 FROM ecm_file 
              WHERE ecm01=l_pmn41
                AND ecm03=l_pmn43
                AND ecm012 = l_pmn012   #FUN-A60027 
            END IF
          END IF       #No.TQC-910033  
       ELSE
          LET l_pmh22='1'
          LET l_pmh21=' '
       END IF
       #CHI-8C0017--End--#       
       SELECT pmh02 INTO sr.pmh02 FROM pmh_file   
        WHERE pmh01=sr.pmn04
#         AND pmh21 = " "                                             #CHI-860042      #CHI-8C0017 Mark
#         AND pmh22 = '1'                                             #CHI-860042      #CHI-8C0017 Mark
          AND pmh21 = l_pmh21                                                          #CHI-8C0017
          AND pmh22 = l_pmh22                                                          #CHI-8C0017
          AND pmh23 = ' '                                             #No.CHI-960033
          AND pmhacti = 'Y'                                           #CHI-910021          
       IF SQLCA.sqlcode THEN LET sr.pmh02 =  NULL END IF                
       IF tm.a='2' THEN
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01=sr.pmm09
           IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF
       ELSE
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01= sr.pmh02
          IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF               
       END IF               
       SELECT ima021 INTO sr.ima021 FROM ima_file
        WHERE ima01 = sr.pmn04 
       LET sr.pmc03 = sr.pmc03[1,10]
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
       EXECUTE insert_prep USING 
           sr.order1,sr.pmn04,sr.pmn041,sr.ima25,sr.pmm09,sr.pmn20,
           sr.rvb07,sr.rvv171,sr.rvv172,sr.rvv173,sr.pmc03,sr.ima021,sr.pmh02
       #------------------------------ CR (3) ------------------------------#
     END FOREACH
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     LET g_str = ''
     #IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pmn04,pmm09') 
             RETURNING tm.wc
        LET g_str = tm.wc
     #END IF
     LET g_str = g_str,";",tm.a,";",tm.bdate,";",tm.edate
     CALL cl_prt_cs3('apmr622','apmr622',l_sql,g_str)   #FUN-710080 modify
     #------------------------------ CR (4) ------------------------------#
END FUNCTION
