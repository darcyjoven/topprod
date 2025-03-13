# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmr720.4gl
# Descriptions...: 銷退理由分析表
# Input parameter:
# Return code....:
# Date & Author..: 95/01/26 by Nick
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: NO.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.TQC-5B0128 05/11/14 By echo 出現報表寬度錯誤message
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-720004 07/01/29 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/28 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-760014 08/07/01 By jamie 1.QBE增加：「分群碼」「客戶分類」「產品分類」。
#                                                  2.QBE增加開窗功能：銷退單號、部門代號、銷售分類、分群碼、客戶分類、產品分類。
# Modify.........: No.MOD-8A0092 08/10/09 By chenl 修正‘說明’字段的取值。
# Modify.........: No.MOD-990004 09/09/01 By Dido 過濾借貨還量的資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50044 10/05/17 By Carrier TQC-950118 追单
# Modify.........: No.TQC-B60204 11/06/21 By wuxj  l_sql字段類型改為string
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                    # Print condition RECORD
              wc      STRING,   # Where condition
	      a	      LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
              s       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)    # Order by sequence
              more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD,
          g_head1   STRING,        #排列順序
          l_tot1    LIKE type_file.num5,          # No.FUN-680137 SMALLINT           #退貨筆數合計
          l_tot2    LIKE ohb_file.ohb14  #退貨金額合計
DEFINE    g_i       LIKE type_file.num5               #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE    l_table     STRING,                 ### FUN-720004 ###
          g_str       STRING,                 ### FUN-720004 ###
          g_sql       STRING                  ### FUN-720004 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   #str FUN-720004 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/01/29 TSD.Martin  *** ##
  #LET g_sql = "reason.gsb_file.gsb05,",
  #            "desc.occ_file.occ02,",
  #            "count.type_file.num10,",
  #            "amount.ohb_file.ohb14,",
  #            "order1.faj_file.faj02,",
  #            "tot1.type_file.num5,",
  #            "tot2.ohb_file.ohb14"
   LET g_sql = "reason1.gsb_file.gsb05,",
               "desc1.occ_file.occ02,",
               "count1.type_file.num10,",
               "amount1.ohb_file.ohb14,",
               "percent1.gec_file.gec04,", #TQC-840066
               "percent2.gec_file.gec04,", #TQC-840066
               "order1.faj_file.faj02,",
               "tot1.type_file.num5,",
               "tot2.ohb_file.ohb14"
 
   LET l_table = cl_prt_temptable('axmr720',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,   ?, ?, ?, ? ) " 
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #str FUN-720004 add
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axmr720_tm(0,0)             # Input print condition
      ELSE CALL axmr720()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr720_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
         l_cmd        LIKE type_file.chr1000     #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 17
 
   OPEN WINDOW axmr720_w AT p_row,p_col WITH FORM "axm/42f/axmr720"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oha01,oha02,oha15,oha25,oha08,
                              ima06,occ03,ima131  #FUN-760014 add
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
        #FUN-760014---add---str---
         ON ACTION controlp
            CASE
             WHEN INFIELD(oha01) #銷退單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oha"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oha01
                  NEXT FIELD oha01
 
             WHEN INFIELD(oha15) #部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oha15
                  NEXT FIELD oha15
 
             WHEN INFIELD(oha25) #銷售分類
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oab"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oha25
                  NEXT FIELD oha25
 
             WHEN INFIELD(ima06) #分群碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imz"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima06
                  NEXT FIELD ima06
 
             WHEN INFIELD(occ03) #客戶分類
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_oca'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ03
                  NEXT FIELD occ03
 
             WHEN INFIELD(ima131) #產品分類
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oba"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131
         END CASE
        #FUN-760014---add---end---
 
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr720_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
#  IF tm.wc = ' 1=1' THEN
#     CALL cl_err('','9046',0) CONTINUE WHILE
#  END IF
   DISPLAY BY NAME tm.more         # Condition
   INPUT BY NAME tm.s,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD s
         IF tm.s NOT MATCHES '[123]' OR tm.s IS NULL THEN
            NEXT FIELD s
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr720_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr720'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr720','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr720',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr720_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr720()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr720_w
END FUNCTION
 
FUNCTION axmr720()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
         #l_sql     LIKE type_file.chr1000,      #TQC-B60204  mark # RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
          l_sql     STRING,                      #TQC-B60204  add 
          l_chr     LIKE type_file.chr1,         #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680137 VARCHAR(40)
          l_ohb06   LIKE gsb_file.gsb05,         # No.FUN-680137 VARCHAR(4)
          l_ohb08   LIKE gsb_file.gsb05,         # No.FUN-680137 VARCHAR(4)
          sr        RECORD
                    reason   LIKE gsb_file.gsb05,      # No.FUN-680137 VARCHAR(4)	  #Reason code
                    desc     LIKE occ_file.occ02,      # No.FUN-680137 VARCHAR(30)	  #Reason description
                    count    LIKE type_file.num10,     # No.FUN-680137 INTEGER	  #count
		    amount   LIKE ohb_file.ohb14,
                    percent1 LIKE gec_file.gec04,      # No.FUN-680137 DECIMAL(5,2)  #amount #TQC-840066
                    percent2 LIKE gec_file.gec04,      # No.FUN-680137 DECIMAL(5,2)  #amount #TQC-840066
                    order1   LIKE faj_file.faj02       # No.FUN-680137  VARCHAR(10)
                    END RECORD
 
  #str FUN-720004 add
  ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720004 *** ##
  CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
  #end FUN-720004 add
 
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720004 add ###
 
  FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#FUN-4C0096 add
   { SELECT azi03,azi04,azi05
       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
       FROM azi_file
      WHERE azi01=g_aza.aza17
##  }      #No.CHI-6A0004
 
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                   #只能使用自己的資料
  #      LET tm.wc = tm.wc clipped," AND ohauser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                   #只能使用相同群的資料
  #      LET tm.wc = tm.wc clipped," AND ohagrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #      LET tm.wc = tm.wc clipped," AND ohagrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ohauser', 'ohagrup')
  #End:FUN-980030
 
 #No.MOD-8A0092--begin-- modify
 #LET l_sql = "SELECT ohb50,oak02,count(*),sum(ohb14*oha24),0,0,'' ",
 #            "  FROM oha_file,OUTER oak_file,ohb_file,OUTER ima_file,OUTER occ_file",
 #            " WHERE ohb50=oak01 AND oha01 = ohb01 AND ",tm.wc CLIPPED,
 #            "   AND ohaconf != 'X' ",  #01/08/17 mandy
 #            "   AND oha_file.oha03=occ_file.occ01",  #FUN-760014 add
 #            "   AND ohb_file.ohb04=ima_file.ima01",  #FUN-760014 add
 #            " GROUP BY ohb50,azf03 "
  LET l_sql = "SELECT ohb50,azf03,count(*),sum(ohb14*oha24),0,0,'' ",
              "  FROM oha_file,OUTER azf_file,ohb_file,OUTER ima_file,OUTER occ_file",
              " WHERE ohb_file.ohb50=azf_file.azf01 AND oha01 = ohb_file.ohb01 AND ",tm.wc CLIPPED,
              "   AND ohaconf != 'X' ",  #01/08/17 mandy
              "   AND oha_file.oha03=occ_file.occ01",  #FUN-760014 add
              "   AND ohb_file.ohb04=ima_file.ima01",  #FUN-760014 add
              "   AND azf02 = '2' ",                   #No.TQC-A50044
              "   AND oha09 != '6' ", 				#MOD-990004
              " GROUP BY ohb50,azf03 "
 #No.MOD-8A0092---end--- modify
 
  PREPARE axmr720_p1 FROM l_sql
  IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
     EXIT PROGRAM 
  END IF
  DECLARE axmr720_c1 CURSOR FOR axmr720_p1
  LET l_tot1=0
  LET l_tot2=0
  FOREACH axmr720_c1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     LET l_tot1=l_tot1+sr.count
     LET l_tot2=l_tot2+sr.amount
  END FOREACH
 
  LET g_pageno = 0
  FOREACH axmr720_c1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     LET sr.order1 = tm.s 
     LET sr.percent1 =0
     LET sr.percent2 =0
     LET sr.percent1 =sr.count/l_tot1*100
     LET sr.percent2 =sr.amount/l_tot2*100
     #單價、金額、小計小數位數
     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
      FROM azi_file 
      WHERE azi01=g_aza.aza17
 
     #str FUN-720004 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720004 *** ##
     EXECUTE insert_prep USING 
        sr.reason,sr.desc,sr.count,sr.amount,sr.percent1,sr.percent2,
        sr.order1,l_tot1,l_tot2
     #------------------------------ CR (3) ------------------------------#
     #end FUN-720004 add
  END FOREACH
 
  #str FUN-720004 add
  ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720004 **** ##
  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
  #是否列印選擇條件
  IF g_zz05 = 'Y' THEN
     CALL cl_wcchp(tm.wc,'oha01,oha02,oha15,oha25,oha08,ima06,occ03,ima131') #FUN-760014 add ima06,occ03,ima131 
          RETURNING tm.wc
     LET g_str =tm.wc
  END IF
  LET g_str = g_str,";", tm.s,";",g_azi04,";",g_azi05
  CALL cl_prt_cs3('axmr720','axmr720',l_sql,g_str)   #FUN-710080 modify
  #------------------------------ CR (4) ------------------------------#
  #end FUN-720004 add
 
END FUNCTION
