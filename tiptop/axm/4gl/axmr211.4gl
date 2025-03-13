# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr211.4gl
# Descriptions...: 客戶信用查核彙總表
# Date & Author..: 95/01/25 by Nick
                 # 1.客戶編號改為10碼 2.多工廠處理
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy DEFINE 匯率時用LIKE的方式
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.MOD-540054 05/05/11 By Mandy axmr211 的金額與抬頭的資料不match且和s_ccc 對不起來
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-580212 05/09/08 By ice  修改報表列印格式
# Modify.........: NO.FUN-630086 06/04/04 By Niocla 多工廠客戶信用查詢
# Modify.........: NO.TQC-650036 06/05/10 By Mandy CALL s_ccc_cal_t63,s_ccc_cal_t64()需多傳一個參數
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE  
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: NO.MOD-6A0083 06/11/16 By Claire occ64避免null
# Modify.........: No.FUN-720004 07/02/06 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/28 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: NO.FUN-640215 08/02/20 By Mandy s_exrate()改用s_exrate_m() 
# Modify.........: NO.TQC-830003 08/03/04 By claire 金額無法計算
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B50037 12/06/11 By Elise 借出管理
# Modify.........: No:TQC-C60125 12/06/14 By yangtt 額度客戶、業務員編號以及部門編號都增加開窗
# Modify.........: No.MOD-C60138 12/06/15 By SunLM 對t_azi04賦初值,避免call s_ccc的時候,返回值有尾差
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
            #  wc      VARCHAR(500),             # Where condition
              wc      STRING,       #TQC-630166      # Where condition
              n       LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01)              # 列印單價
              more    LIKE type_file.chr1000 # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD,
          g_ocg   RECORD LIKE ocg_file.*
 DEFINE g_curr   LIKE apo_file.apo02   #No.FUN-680137 VARCHAR(04)
 DEFINE g_aza17  LIKE aza_file.aza17
 DEFINE g_occ33  LIKE cre_file.cre08   #No.FUN-680137 VARCHAR(10)
 DEFINE l_occ33  LIKE cre_file.cre08   #No.FUN-680137 VARCHAR(10)
 DEFINE l_occ02,l_occ62		LIKE cre_file.cre08     #No.FUN-680137 VARCHAR(10)
#FUN-4C0096 modify
 DEFINE g_t51,g_t52,g_t53,g_t54,g_t55                     LIKE oma_file.oma50
 DEFINE g_t61,g_t62,g_t63,g_t64,g_t65,g_t66,g_t67,g_t70,g_bal,g_tot   LIKE oma_file.oma50  #CHI-B50037 add g_t67,g_t70
 DEFINE g_s51,g_s52,g_s53,g_s54,g_s55                     LIKE oma_file.oma50
 DEFINE g_s61,g_s62,g_s63,g_s64,g_s65,g_s66,g_s67,g_s70,g_sbal,g_stot LIKE oma_file.oma50  #CHI-B50037 add g_s67,g_s70
##
DEFINE    l_table     STRING,                 ### FUN-720004 ###
          g_str       STRING,                 ### FUN-720004 ###
          g_sql       STRING                  ### FUN-720004 ###
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
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
   LET g_sql =  " occ33.occ_file.occ33,",
                " occ02.occ_file.occ02,",
                " tot01.oma_file.oma50,",
                " tot02.oma_file.oma50,",
                " tot03.oma_file.oma50,",
                " tot04.oma_file.oma50,",
                " tot05.oma_file.oma50,",
                " tot06.oma_file.oma50,",
                " tot07.oma_file.oma50,",
                " tot08.oma_file.oma50,",
                " tot09.oma_file.oma50,",
                " tot10.oma_file.oma50,",
                " tot11.oma_file.oma50,",
                " tot12.oma_file.oma50,", #CHI-B50037 add 
                " tot13.oma_file.oma50,", #CHI-B50037 add
                " tot_all.oma_file.oma50,",
                " balance.oma_file.oma50,",
                " occ61.occ_file.occ61"
 
   LET l_table = cl_prt_temptable('axmr211',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?,  ?, ?, ?)"   #CHI-B50037 add 2?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #end FUN-720004 add
 
   INITIALIZE tm.* TO NULL            # Default condition
#------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.n ='1'
  #LET g_occ33 = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.n  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------No.TQC-610089 end
   IF cl_null(g_oaz.oaz211) THEN LET g_oaz.oaz211='1' END IF
   IF cl_null(g_oaz.oaz212) THEN LET g_oaz.oaz212='B' END IF
   SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
   IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
#------------No.TQC-610089 modify
  #IF cl_null(g_occ33)
   IF cl_null(tm.wc)
      THEN CALL axmr211_tm(0,0)             # Input print condition
   ELSE
     #SELECT occ33 INTO l_occ33 FROM occ_file WHERE occ01 = g_occ33
     #IF cl_null(l_occ33) THEN LET l_occ33 = g_occ33 END IF
     #LET tm.wc="occ33= '",l_occ33 CLIPPED,"'"
      CALL axmr211()   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr211_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW axmr211_w AT p_row,p_col WITH FORM "axm/42f/axmr211"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #------------No.TQC-610089 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='1'
   #------------No.TQC-610089 end
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON occ33,occ04,occgrup
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---

      #TQC-C60125 --begin--
      ON ACTION CONTROLP
        CASE
          WHEN INFIELD(occ33)
             CALL cl_init_qry_var()
             LET g_qryparam.state = 'c'
             LET g_qryparam.form ="q_occ33"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO occ33
             NEXT FIELD occ33
          WHEN INFIELD(occ04)
             CALL cl_init_qry_var()
             LET g_qryparam.state = 'c'
             LET g_qryparam.form ="q_occ04"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO occ04
             NEXT FIELD occ04
          WHEN INFIELD(occgrup)
             CALL cl_init_qry_var()
             LET g_qryparam.state = 'c'
             LET g_qryparam.form ="q_occgrup"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO occgrup
             NEXT FIELD occgrup
        END CASE
#TQC-C60125 --end--
 
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
 
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr211_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.n,tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[12]' THEN
            NEXT FIELD n
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
         CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr211_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr211'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr211','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")   #"
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr211',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr211_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr211()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr211_w
END FUNCTION
 
FUNCTION axmr211()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_occ63   LIKE occ_file.occ63,
          l_occ631  LIKE occ_file.occ631,
          l_occ64   LIKE occ_file.occ64,
          l_exrate  LIKE azk_file.azk03,#FUN-4B0050
          sr        RECORD
                    occ33     LIKE occ_file.occ33,   #FUN-4C0096
                    occ02     LIKE occ_file.occ02,
                    tot01     LIKE oma_file.oma50,
                    tot02     LIKE oma_file.oma50,
                    tot03     LIKE oma_file.oma50,
                    tot04     LIKE oma_file.oma50,
                    tot05     LIKE oma_file.oma50,
                    tot06     LIKE oma_file.oma50,
                    tot07     LIKE oma_file.oma50,
                    tot08     LIKE oma_file.oma50,
                    tot09     LIKE oma_file.oma50,
                    tot10     LIKE oma_file.oma50,
                    tot11     LIKE oma_file.oma50,
                    tot12     LIKE oma_file.oma50, #CHI-B50037 add
                    tot13     LIKE oma_file.oma50, #CHI-B50037 add
                    tot_all   LIKE oma_file.oma50,
                    balance   LIKE oma_file.oma50,
                    occ61     LIKE occ_file.occ61
                    END RECORD,
          sr1       RECORD
                    occ01     LIKE occ_file.occ01,
                    occ02     LIKE occ_file.occ02,
                    occ61     LIKE occ_file.occ61,
                    occ631    LIKE occ_file.occ631
                    END RECORD
 
   #str FUN-720004 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720004 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720004 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720004 add ###
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
  #   SELECT azi03,azi04,azi05               #No.CHI-6A0004
  #    INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取 #No.CHI-6A0004
  #    FROM azi_file                         #No.CHI-6A0004
  #   WHERE azi01=g_aza.aza17                #No.CHI-6A0004
  
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND occuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND occgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
   #End:FUN-980030
 
   LET l_sql="SELECT UNIQUE occ33,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,''",  #CHI-B50037 add 20
             " FROM occ_file ",
             " WHERE ",tm.wc CLIPPED,
             "  AND occ33 IS NOT NULL ",
             "  AND occ61 IS NOT NULL AND occ62 = 'Y'",
             " ORDER BY occ33 "
   PREPARE axmr211_prepare  FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare0:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE axmr211_curs CURSOR FOR axmr211_prepare
 
   LET l_sql="SELECT occ01,occ02,occ61,occ631 ",
             "  FROM occ_file ",
             " WHERE (occ33 = ? AND occ33 IS NOT NULL ) OR (occ01 = ? ) ",
             "  AND occ61 IS NOT NULL AND occ62 = 'Y' "
   PREPARE axmr211_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE axmr211_curs1 CURSOR FOR axmr211_prepare1
 
   LET g_pageno = 0
   FOREACH axmr211_curs INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #讀取額度客戶幣別
      SELECT occ631 INTO l_occ631 FROM occ_file
       WHERE occ01 = sr.occ33
      #MOD-C60138 add begin
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_occ631 
      IF cl_null(t_azi04) THEN 
         LET t_azi04 = 2
      END IF    
      # MOD-C60138 add end       
      LET g_s51=0 LET g_s52=0 LET g_s53=0 LET g_s54=0 LET g_stot=0 LET g_s55=0
      LET g_s61=0 LET g_s62=0 LET g_s63=0 LET g_s64=0 LET g_sbal=0
      LET g_s65=0 LET g_s66=0 LET g_s67=0 LET g_s70=0 #CHI-B50037 add g_s67,g_s70
      FOREACH axmr211_curs1 USING sr.occ33,sr.occ33 INTO sr1.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF sr.occ33 = sr1.occ01 THEN
            LET sr.occ02 = sr1.occ02
            LET sr.occ61 = sr1.occ61
         END IF
         LET g_t51=0 LET g_t52=0 LET g_t53=0 LET g_t54=0 LET g_tot=0 LET g_t55=0
         LET g_t61=0 LET g_t62=0 LET g_t63=0 LET g_t64=0 LET g_bal=0
         LET g_t65=0 LET g_t66=0 LET g_t67=0 LET g_t70=0 #CHI-B50037 add g_t67,g_t70
         SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = sr1.occ61  #TQC-830003 add
         #MOD-6A0083-begin-mark
         #SELECT occ63*(1+occ64/100) INTO g_tot FROM occ_file
         # WHERE occ01=sr1.occ01    #客戶編號
         #IF STATUS THEN
         #MOD-6A0083-end-mark
            SELECT occ63,occ64 INTO l_occ63,l_occ64 FROM occ_file
             WHERE occ01 = sr1.occ01
            IF l_occ63 IS NULL THEN LET l_occ63=0 END IF
            IF l_occ64 IS NULL THEN LET l_occ64=0 END IF
            LET g_tot=l_occ63*(1+l_occ64/100)
         #END IF #MOD-6A0083 mark
         MESSAGE 'cus no:',sr1.occ01,'--t51--',sr.occ33
         CALL ui.Interface.refresh()
         IF g_ocg.ocg02 > 0 THEN
            CALL s_ccc_cal_t51(sr1.occ01,sr1.occ61) RETURNING g_t51
         END IF
         MESSAGE 'cus no:',sr1.occ01,'--t52'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg03 > 0 THEN   #No.FUN-630086
            CALL s_ccc_cal_t52(sr1.occ01,sr1.occ61) RETURNING g_t52
         END IF
         MESSAGE 'cus no:',sr1.occ01,'--t53'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg04 > 0 THEN   #No.FUN-630086
            CALL s_ccc_cal_t53(sr1.occ01,sr1.occ61) RETURNING g_t53
         END IF
         MESSAGE 'cus no:',sr1.occ01,'--t54'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg04 > 0 THEN   #No.FUN-630086
            CALL s_ccc_cal_t54(sr1.occ01,sr1.occ61) RETURNING g_t54
         END IF
         MESSAGE 'cus no:',sr1.occ01,'--t55'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg05 > 0 THEN   #No.FUN-630086
            CALL s_ccc_cal_t55(sr1.occ01,sr1.occ61) RETURNING g_t55
         END IF
         MESSAGE 'cus no:',sr1.occ01,'--t61'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg06 > 0 THEN   #No.FUN-630086
            CALL s_ccc_cal_t61(sr1.occ01,sr1.occ61) RETURNING g_t61
         END IF
         MESSAGE 'cus no:',sr1.occ01,'--t62'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg07 > 0 THEN   #No.FUN-630086
            CALL s_ccc_cal_t62(sr1.occ01,sr1.occ61) RETURNING g_t62
         END IF
         MESSAGE 'cus no:',sr1.occ01,'--t63'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg08 > 0 THEN   #No.FUN-630086
           #CALL s_ccc_cal_t63(sr1.occ01,sr1.occ61) RETURNING g_t63
            CALL s_ccc_cal_t63(sr1.occ01,'',sr1.occ61) RETURNING g_t63 #TQC-650036 add '',因為:FUN-630086調整需多傳一個參數
         END IF
         MESSAGE 'cus no:',sr1.occ01,'--t66'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg09 > 0 THEN   #No.FUN-630086
            CALL s_ccc_cal_t66(sr1.occ01,'',sr1.occ61) RETURNING g_t66
         END IF
         MESSAGE 'cus no:',sr1.occ01,'--t64'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg10 > 0 THEN   #No.FUN-630086
           #CALL s_ccc_cal_t64(sr1.occ01,sr1.occ61) RETURNING g_t64
            CALL s_ccc_cal_t64(sr1.occ01,'',sr1.occ61) RETURNING g_t64 #TQC-650036 add '',因為MOD-640569調整需多傳一個參數
         END IF
         #CHI-B50037 add --start--
         MESSAGE 'cus no:',sr1.occ01,'--t67'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg10 > 0 THEN 
            CALL s_ccc_cal_t67(sr1.occ01,'',sr1.occ61) RETURNING g_t67
         END IF
         #CHI-B50037 add --end--
         MESSAGE 'cus no:',sr1.occ01,'--t65'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg11 = 'Y' THEN   #No.FUN-630086
            CALL s_ccc_cal_t65(sr1.occ01,sr1.occ61) RETURNING g_t65
         END IF
         #CHI-B50037 add --start--
         MESSAGE 'cus no:',sr1.occ01,'--t70'
         CALL ui.Interface.refresh()
         IF g_ocg.ocg12 = 'Y' THEN   # 逾期未兌現票據 
            CALL s_ccc_cal_t70(sr1.occ01,sr1.occ61) RETURNING g_t70
         END IF
         #CHI-B50037 add --end--
         LET g_bal = g_tot + g_t51 + g_t52 + g_t53 + g_t54 + g_t55
                           - g_t61 - g_t62 - g_t63 - g_t64 - g_t66
                           - g_t67 #CHI-B50037 add
 
         #額度幣別轉換
         IF sr1.occ631 = l_occ631 THEN
            LET l_exrate = 1
         ELSE
           #LET l_exrate=s_exrate(sr1.occ631,l_occ631,g_oaz.oaz212)      #FUN-640215 mark
            LET l_exrate=s_exrate_m(sr1.occ631,l_occ631,g_oaz.oaz212,'') #FUN-640215 add
            IF cl_null(l_exrate) THEN LET l_exrate = 1 END IF
         END IF
         LET g_stot = g_stot + g_tot * l_exrate
         LET g_s51  = g_s51 + g_t51 * l_exrate
         LET g_s52  = g_s52 + g_t52 * l_exrate
         LET g_s53  = g_s53 + g_t53 * l_exrate
         LET g_s54  = g_s54 + g_t54 * l_exrate
         LET g_s55  = g_s55 + g_t55 * l_exrate
         LET g_s61  = g_s61 + g_t61 * l_exrate
         LET g_s62  = g_s62 + g_t62 * l_exrate
         LET g_s63  = g_s63 + g_t63 * l_exrate
         LET g_s64  = g_s64 + g_t64 * l_exrate
         LET g_s65  = g_s65 + g_t65 * l_exrate
         LET g_s66  = g_s66 + g_t66 * l_exrate
         LET g_s67  = g_s67 + g_t67 * l_exrate #CHI-B50037 add
         LET g_s70  = g_s70 + g_t70 * l_exrate #CHI-B50037 add
         LET g_sbal = g_stot + g_s51 + g_s52 + g_s53 + g_s54 + g_s55
                             - g_s61 - g_s62 - g_s63 - g_s64 - g_s66
                             - g_s67 #CHI-B50037 add
      END FOREACH
      LET sr.balance = g_sbal
      IF tm.n = 1 AND sr.balance > 0 THEN CONTINUE FOREACH END IF
      LET sr.tot01 = g_s51
      LET sr.tot02 = g_s52
      LET sr.tot03 = g_s53
      LET sr.tot04 = g_s54
      LET sr.tot09 = g_s55
      LET sr.tot05 = -g_s61
      LET sr.tot06 = -g_s62
      LET sr.tot07 = -g_s63
      LET sr.tot08 = -g_s66
      LET sr.tot10 = -g_s64
      LET sr.tot11 = -g_s65
      LET sr.tot12 = -g_s67 #CHI-B50037 add
      LET sr.tot13 = -g_s70 #CHI-B50037 add
      LET sr.tot_all = g_stot
 
      #str FUN-720004 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720004 *** ##
      IF cl_null(sr.occ02) THEN LET sr.occ02 = ' ' END IF 
      IF cl_null(sr.occ61) THEN LET sr.occ61 = ' ' END IF 
      EXECUTE insert_prep USING 
         sr.occ33,sr.occ02,sr.tot01,sr.tot02,sr.tot03,sr.tot04,sr.tot05,
         sr.tot06,sr.tot07,sr.tot08,sr.tot09,sr.tot10,sr.tot11,
         sr.tot12,sr.tot13, #CHI-B50037 add
         sr.tot_all,sr.balance,sr.occ61
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720004 add
   END FOREACH
 
   #str FUN-720004 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720004 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'occ33,occ04,occgrup') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",g_azi04,";",g_azi05          #FUN-710080 add
   CALL cl_prt_cs3('axmr211','axmr211',l_sql,g_str)   #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720004 add
 
END FUNCTION
 
