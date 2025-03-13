# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr210.4gl
# Descriptions...: 客戶信用查核明細表
# Date & Author..: 95/01/24 By Nick
# Modify.........: 01/10/04 By Carol 改以額度客戶(occ33)為信用查核之客戶
# Modify.........: No:7650 03/08/27 Carol 當只下一個額度客戶編號時,信用額
#                                         度是正確的,但超過一位以上的客戶,
#                                         則信用度會有錯誤->信用額度歸零重計
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy DEFINE 匯率時用LIKE的方式
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-580212 05/09/08 By ice  修改報表列印格式
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-5C0087 06/03/21 By Ray AR月底重評價
# Modify.........: NO.FUN-630086 06/04/04 By Niocla 多工廠客戶信用查詢
# Modify.........: NO.MOD-640569 06/04/26 By Nicola 出貨改用況狀碼判斷
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-660014 06/06/06 By sam_lin CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-640498 06/06/21 By Mandy cal_t66() pab_amt==>由SUM(oeb24*oeb13) 的值不正確
# Modify.........: NO.MOD-650058 06/06/21 By Mandy承MOD-640498補強, pab_amt應該要抓當站資料庫的資料來計算
# Modify.........: No.MOD-660024 06/06/22 By Pengu 修改信用餘額的計算公式
# Modify.........: No.FUN-660167 06/06/23 By douzh cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.MOD-6A0121 06/12/14 By pengu FUNCTION cal_t66中,SELECT oeb24*oeb13要改成SELECT SUM(oeb24*oeb13)
# Modify.........: NO.FUN-640215 08/02/20 By Mandy s_exrate()改用s_exrate_m() 
# Modify.........: No.MOD-820186 08/03/24 By chenl 增加折扣率計算
# Modify.........: No.TQC-840060 08/04/24 By claire MOD-820186 調整 
# Modify.........: NO.FUN-850009 08/05/05 By zhaijie 老報表修改為CR
# Modify.........: No.MOD-860089 08/06/10 By Smapmin 抓取訂單單身資料時,要加上oeb12>oeb24的條件
# Modify.........: No.MOD-8A0126 08/10/21 By chenyu 在計算訂單信用時，使用計價單位的時候，需要有轉換率
# Modify.........: No.MOD-8C0151 08/12/16 By Smapmin 修改變數定義大小
# Modify.........: No.MOD-8C0094 08/12/16 By Smapmin 將t64()/t66()的計算方式調整成與s_ccc一致.
# Modify.........: No.CHI-8C0028 09/01/12 By xiaofeizhu oga09的條件由2348調整為23468
# Modify.........: No.TQC-920037 09/02/23 By liuxqa 重新過單
# Modify.........: No.FUN-930006 09/03/04 By mike 對于跨庫的SQL，去掉冒號，用s_dbstring()包起dbname
# Modify.........: No.CHI-910034 09/07/14 By chenmoyan 對金額取位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.MOD-990029 09/09/07 By Dido 信用額度金額計算邏輯調整 
# Modify.........: No.MOD-990044 09/09/07 By Dido 條件調整
# Modify.........: No.CHI-980048 09/09/17 By Dido 應收逾期帳(t65)計算邏輯調整(應收-已沖-未確認收款) 
# Modify.........: No:CHI-9C0003 09/12/17 By Smapmin 待抵的金額回頭抓訂金的金額
# Modify.........: No:MOD-9C0317 09/12/24 By Smapmin 還原CHI-9C0003
# Modify.........: No:MOD-9C0316 09/12/25 By sabrina 跨資料庫拋轉 
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No:FUN-A10056 10/01/12 by dxfwo  跨DB處理 
# Modify.........: No:MOD-A50023 10/05/05 By sabrina 信用額度計算有誤
# Modify.........: No:MOD-B20126 11/02/23 By Summer 計算FUNCTION cal_t66()的餘額錯誤
# Modify.........: No:MOD-B80001 11/08/01 By johung pab_amt計算後應取位
# Modify.........: No:MOD-B80027 11/09/15 By johung 計算出貨通知單應加上未結案項次條件
# Modify.........: No:CHI-B50037 12/06/11 By Elise 借出管理
# Modify.........: No:TQC-C60125 12/06/14 By yangtt 額度客戶、業務員編號以及部門編號都增加開窗
# Modify.........: No:TQC-C90025 12/10/17 By Nina 呈現的資料以 s_ccc 為主

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc       STRING,       #TQC-630166      # Where condition
              n       LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)              # 列印單價
              more    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD,
	g_occ261	LIKE occ_file.occ261,
        g_occ29		LIKE occ_file.occ29,
	g_occ292	LIKE occ_file.occ292,
        g_occ631        LIKE occ_file.occ631,
        g_ocg    RECORD LIKE ocg_file.*,
        l_occ631        LIKE occ_file.occ631,
        l_occ36         LIKE occ_file.occ36,   #寬限天數
        g_occ01         LIKE occ_file.occ01,
        g_occ02_o       LIKE occ_file.occ02,
        g_occ02         LIKE occ_file.occ02,
        g_occ33         LIKE occ_file.occ33,
        l_occ33         LIKE occ_file.occ33,
        l_type          LIKE type_file.chr8,          #No.FUN-680137 VARCHAR(8)
        g_aza17         LIKE aza_file.aza17,
        g_azp01 ARRAY[10,4] OF LIKE cre_file.cre08,       #No.FUN-680137 VARCHAR(10)
        g_azp03 ARRAY[10,4] OF LIKE cre_file.cre08,       #No.FUN-680137 VARCHAR(10)
        g_exrate        LIKE azk_file.azk03,  #FUN-4B0050
        g_curr          LIKE azi_file.azi01,
        l_tmp           LIKE oma_file.oma50   #FUN-4C0096
DEFINE t51,t52,t53,t54,t55,t61,t62,t63,t64,t65,t66,t67,t70,bal,tot	LIKE oma_file.oma50    #FUN-4C0096   #CHI-B50037 add t67
DEFINE s51,s52,s53,s54,s55,s61,s62,s63,s64,s65,s66,s67,s70,sbal,stot LIKE oma_file.oma50  #FUn-4C0096  #CHI-B50037 add s67
DEFINE g_head1        LIKE type_file.chr1000  #No.FUN-680137 STRING
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#DEFINE t_azi03        LIKE azi_file.azi03     #No.MOD-820186     #TQC-C90025 mark
#DEFINE t_azi04        LIKE azi_file.azi04     #No.MOD-820186     #TQC-C90025 mark
DEFINE g_sql          STRING
DEFINE g_str          STRING
DEFINE l_table        STRING
DEFINE t_azi04h       LIKE azi_file.azi04
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.n  = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   LET  g_sql = "occ01.occ_file.occ01,",
                "occ02.occ_file.occ02,",
                "occ02_o.occ_file.occ02,",
                "tot.occ_file.occ63,",
	              "plant.cre_file.cre08,",
	              "tradetype.type_file.chr8,",
                "oma11.oma_file.oma11,",
                "oma01.oma_file.oma01,",
                "oma23.oma_file.oma23,",
                "oma50.oma_file.oma50,",
                "weight.ocg_file.ocg02,",
                "balance.oma_file.oma50,",
                "kind.type_file.chr1,",
                "num.type_file.num10,",
                "t_azi04h.azi_file.azi04,",
                "t_azi04.azi_file.azi04,",
                "l_occ631.occ_file.occ631"
   LET l_table = cl_prt_temptable('axmr210',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF                      
 
   INITIALIZE tm.* TO NULL            # Default condition
   DROP TABLE r210_ccc
   CREATE TEMP TABLE r210_ccc(
	    plant       LIKE cre_file.cre08,
	    tradetype	LIKE type_file.chr8,  
            oma11       LIKE type_file.dat,   
            oma01       LIKE oma_file.oma01,
            oma23       LIKE oma_file.oma23,
            oma50       LIKE type_file.num20_6,
            weight      LIKE type_file.num5,  
            balance     LIKE type_file.num20_6,
            kind        LIKE type_file.chr1,  
	    occ02       LIKE occ_file.occ02);   #MOD-8C0151
        
    DELETE FROM r210_ccc WHERE 1=1
    SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
   
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'                                                                              
 
   IF cl_null(tm.wc) THEN
      CALL axmr210_tm(0,0)             # Input print condition
   ELSE
      CALL axmr210()                   # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr210_tm(p_row,p_col)
 
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   OPEN WINDOW axmr210_w WITH FORM "axm/42f/axmr210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='1'
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON occ33,occ04,occgrup
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

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
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr210_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.n,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr210_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr210'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axmr210','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr210',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr210()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr210_w
END FUNCTION
 
FUNCTION axmr210()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_i       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_exrate  LIKE azk_file.azk03,#FUN-4B0050
          l_occ01   LIKE occ_file.occ01,
          l_occ61   LIKE occ_file.occ61,
          l_occ63   LIKE occ_file.occ63,
          l_occ631  LIKE occ_file.occ631,
          l_occ64   LIKE occ_file.occ64,
          old_kind  LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          i         LIKE type_file.num10,         #No.FUN-680137 INTEGER
          l_bal		LIKE oma_file.oma50,
          sr RECORD
            occ01       LIKE occ_file.occ01,
            occ02       LIKE occ_file.occ02,
            occ02_o     LIKE occ_file.occ02,
            tot         LIKE occ_file.occ63,
	          plant       LIKE cre_file.cre08,      #No.FUN-680137 VARCHAR(10)
	          tradetype	  LIKE type_file.chr8,      #No.FUN-680137 VARCHAR(8)
            oma11   LIKE oma_file.oma11,
            oma01   LIKE oma_file.oma01,
            oma23   LIKE oma_file.oma23,
            oma50   LIKE oma_file.oma50,
            weight  LIKE ocg_file.ocg02,
            balance LIKE oma_file.oma50,
            kind        LIKE type_file.chr1,      #No.FUN-680137 VARCHAR(1)
            num         LIKE type_file.num10      #No.FUN-680137 INTEGER
            END RECORD,
         g_cnt	LIKE type_file.num10              #No.FUN-680137 INTEGER
         
   CALL cl_del_data(l_table)                     #NO.FUN-850009
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr210'  #NO.FUN-850009
   
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     DECLARE axmr210_za_cur CURSOR FOR
             SELECT za02,za05 FROM za_file
              WHERE za01 = "axmr210" AND za03 = g_rlang
     FOREACH axmr210_za_cur INTO g_i,l_za05
        LET g_x[g_i] = l_za05
     END FOREACH
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr210'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
 
     LET l_sql="SELECT UNIQUE occ33,'',''",
               " FROM occ_file ",
               " WHERE ",tm.wc CLIPPED,
               "  AND occ33 IS NOT NULL ",
               "  AND occ61 IS NOT NULL AND occ62 = 'Y'",
               " ORDER BY occ33 "
     PREPARE axmr210_prepare  FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare0:',SQLCA.sqlcode,1)
        RETURN
     END IF
     DECLARE axmr210_curs CURSOR FOR axmr210_prepare
     IF SQLCA.sqlcode THEN
        CALL cl_err('dec_cus:',SQLCA.sqlcode,1)
        RETURN
     END IF
     LET l_sql=" SELECT occ01,occ02,occ61,occ63,occ64,occ36,occ631 ",
               "  FROM occ_file",
               " WHERE (occ33 = ? AND occ33 IS NOT NULL) OR (occ01 = ?) ",
               "   AND occ62 = 'Y'",
               " ORDER BY occ01 "
     PREPARE axmr210_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        RETURN
     END IF
     DECLARE axmr210_curs1 CURSOR FOR axmr210_prepare1
     IF SQLCA.sqlcode THEN
        CALL cl_err('dec_cus1:',SQLCA.sqlcode,1)
        RETURN
     END IF
 
 
     LET g_pageno = 0
     LET stot=0 LET sbal=0
     LET s65=0  LET s70=0
     FOREACH axmr210_curs  INTO g_occ33
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT occ02,occ631 INTO g_occ02_o,g_occ631
         FROM occ_file WHERE occ01 = g_occ33
 
       DELETE FROM r210_ccc WHERE 1=1
       LET stot=0 LET sbal=0
       LET s65=0  LET s70=0
       FOREACH axmr210_curs1 USING g_occ33,g_occ33
               INTO sr.occ01,g_occ02,l_occ61,l_occ63,l_occ64,l_occ36,l_occ631
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(l_occ36) THEN LET l_occ36=0 END IF
         IF cl_null(l_occ61)  THEN
            CALL cl_err('','axm-270',0)
            CONTINUE FOREACH
         END IF
         LET g_errno='Y'
         LET t51=0 LET t52=0 LET t53=0 LET t54=0 LET tot=0 LET t55=0
         LET t61=0 LET t62=0 LET t63=0 LET t64=0 LET bal=0
         LET t65=0 LET t66=0 LET t67=0 LET t70=0 #CHI-B50037 add t67 
 
         CALL r210_b_get(sr.occ01,l_occ61)
 
         #換算額度客戶幣別匯率
         IF l_occ631 = g_occ631 THEN
            LET l_exrate = 1
         ELSE
            LET l_exrate = s_exrate_m(l_occ631,g_occ631,g_oaz.oaz212,'') #FUN-640215
         END IF
 
         IF l_occ63 IS NULL THEN LET l_occ63=0 END IF
         IF l_occ64 IS NULL THEN LET l_occ64=0 END IF
         LET tot=(l_occ63*(1+l_occ64/100)) * l_exrate  #信用額度總額
         IF cl_null(tot) THEN LET tot = 0 END IF
 
         #信用餘額
         LET bal=tot+t51+t52+t53+t54+t55+t61+t62+t63+t64+t66+t67 #CHI-B50037 add t67
 
         #客戶各項金額累計
         LET stot=stot + tot
         LET sbal=sbal + bal
         LET s65=s65 + t65
         LET s70=s70 + t70
       END FOREACH
 
       IF sbal < 0 THEN LET g_errno = 'N' ELSE LET g_errno = 'Y' END IF
       IF g_errno='Y' THEN
          #逾期應收 或 逾期未兌現票據
          IF s65 > 0 OR s70 > 0 THEN
             LET g_errno = 'N'
             CALL cl_err('','axm-689',1)  #TQC-C90025 add
          END IF
       END IF
         #僅印超限者
       IF tm.n='1' AND g_errno='Y' THEN
          CONTINUE FOREACH
       END IF
 
       LET i = 1
       LET l_bal=stot
       #計算信用餘額
       DECLARE r210_b CURSOR FOR
          SELECT * FROM r210_ccc
           WHERE oma50 <> 0
             AND kind <> 'A' AND  kind<> 'C'
            ORDER BY oma11,kind,plant
        FOREACH r210_b INTO sr.plant,sr.tradetype,sr.oma11,
                            sr.oma01,sr.oma23,sr.oma50,sr.weight,sr.balance,
                            sr.kind,sr.occ02
            IF SQLCA.sqlcode THEN
                CALL cl_err('Foreach1:',SQLCA.sqlcode,1)   
                EXIT FOREACH
            END IF
            LET sr.occ01 = g_occ33
            LET sr.occ02_o = g_occ02_o
            LET sr.kind='1'
            LET sr.num = i
            LET sr.tot = stot
            LET l_bal = l_bal + sr.oma50			#MOD-990029
            LET sr.balance = l_bal
      SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01=sr.occ01
      SELECT azi04 INTO  t_azi04h FROM azi_file WHERE azi01 = l_occ631
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = sr.oma23
      EXECUTE insert_prep USING
        sr.occ01,sr.occ02,sr.occ02_o,sr.tot,sr.plant,sr.tradetype,sr.oma11,
        sr.oma01,sr.oma23,sr.oma50,sr.weight,sr.balance,sr.kind,sr.num,
        t_azi04h,t_azi04,l_occ631
            LET i = i +1
        END FOREACH
 
       LET l_bal=0
       LET old_kind='1'
       #計算逾期票據/逾期帳款
       DECLARE r210_b2 CURSOR FOR
          SELECT * FROM r210_ccc
           WHERE oma50 <> 0
             AND (kind = 'A' OR  kind= 'C')
            ORDER BY kind,oma11,plant
        FOREACH r210_b2 INTO sr.plant,sr.tradetype,sr.oma11,
                            sr.oma01,sr.oma23,sr.oma50,sr.weight,sr.balance,
                            sr.kind,sr.occ02
            IF SQLCA.sqlcode THEN
                CALL cl_err('Foreach2:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            LET sr.occ01 = g_occ33
            LET sr.occ02 = g_occ02_o
            IF sr.kind ='A' THEN
                LET sr.kind='2'
            ELSE
                LET sr.kind='3'
            END IF
            IF old_kind <> sr.kind THEN
               LET l_bal =0
               LET old_kind=sr.kind
            END IF
            LET sr.num = i
            LET l_bal = l_bal + sr.oma50*-1
            LET sr.balance = l_bal
      SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01=sr.occ01
      SELECT azi04 INTO  t_azi04h FROM azi_file WHERE azi01 = l_occ631
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = sr.oma23
      EXECUTE insert_prep USING
        sr.occ01,sr.occ02,sr.occ02_o,sr.tot,sr.plant,sr.tradetype,sr.oma11,
        sr.oma01,sr.oma23,sr.oma50,sr.weight,sr.balance,sr.kind,sr.num,
        t_azi04h,t_azi04,l_occ631
            LET i = i +1
        END FOREACH
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'occ33,occ04,occgrup')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     CALL cl_prt_cs3('axmr210','axmr210',g_sql,g_str) 
END FUNCTION
 
FUNCTION r210_b_get(p_cus_no,l_occ61)
 DEFINE p_cus_no	LIKE cre_file.cre08        #No.FUN-680137 VARCHAR(10)
 DEFINE l_occ61         LIKE cre_file.cre08        #No.FUN-680137 VARCHAR(10)
 
  SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01=l_occ61
  IF STATUS THEN CALL 
       cl_err3("sel","ocg_file",l_occ61,"","axm-271","","",0)  # FUN-660167
       RETURN  END IF
#-(1)-----------------------------------------
 IF g_ocg.ocg02 > 0 THEN     # 待抵帳款
       CALL cal_t51(p_cus_no,l_occ61) RETURNING t51
 END IF
#-(2)-----------------------------------------
 IF g_ocg.ocg03 > 0 THEN     # ＬＣ收狀   #No.FUN-630086
       CALL cal_t52(p_cus_no,l_occ61) RETURNING t52
 END IF
#-(3)-----------------------------------------
 IF g_ocg.ocg04 > 0 THEN     # 財務暫收支票   #No.FUN-630086
       CALL cal_t53(p_cus_no,l_occ61) RETURNING t53
 END IF
#-(4)-----------------------------------------
 IF g_ocg.ocg04 > 0 THEN     # 財務暫收ＴＴ   #No.FUN-630086
       CALL cal_t54(p_cus_no,l_occ61) RETURNING t54
 END IF
#-(B)-----------------------------------------
 IF g_ocg.ocg05 > 0 THEN     # 沖帳未確認   #No.FUN-630086
       CALL cal_t55(p_cus_no,l_occ61) RETURNING t55
 END IF
#-(5)-----------------------------------------
 IF g_ocg.ocg06 > 0 THEN     # 未兌應收票據   #No.FUN-630086
       CALL cal_t61(p_cus_no,l_occ61) RETURNING t61
 END IF
#-(6)-----------------------------------------
 IF g_ocg.ocg07 > 0 THEN     # 發票應收 (AR)   #No.FUN-630086
       CALL cal_t62(p_cus_no,l_occ61) RETURNING t62
 END IF
#-(7)-----------------------------------------
 IF g_ocg.ocg08 > 0 THEN     # 出貨未開發票  (PA)   #No.FUN-630086
       CALL cal_t63(p_cus_no,l_occ61) RETURNING t63
 END IF
#-(8)-----------------------------------------
 IF g_ocg.ocg09 > 0 THEN     # 出貨通知單  (IF)   #No.FUN-630086
       CALL cal_t66(p_cus_no,'',l_occ61) RETURNING t66
 END IF
#-(9)-----------------------------------------
 IF g_ocg.ocg10 > 0 THEN     # 接單未出貨  (SO)   #No.FUN-630086
       CALL cal_t64(p_cus_no,l_occ61) RETURNING t64
 END IF
#CHI-B50037 add --start--    
#-(D)-----------------------------------------
 IF g_ocg.ocg10 > 0 THEN     # 接單未出貨  (SO)
       CALL cal_t67(p_cus_no,l_occ61) RETURNING t67
 END IF
#CHI-B50037 add --end--
#-(A)-----------------------------------------
#若直接RUN axmr210 則不顯示逾期應收 及逾期票據
 IF g_ocg.ocg11 = 'Y' THEN   # 逾期應收  (OVERDUE)   #No.FUN-630086
    CALL cal_t65(p_cus_no,l_occ61) RETURNING t65
 END IF
#-(C)-----------------------------------------
#若直接RUN axmr210 則不顯示逾期應收 及逾期票據
 IF g_ocg.ocg12 = 'Y' THEN   #逾期未兌現票據   #No.FUN-630086
    CALL cal_t70(p_cus_no,l_occ61) RETURNING t70
 END IF
END FUNCTION
 
#以下sql的where條件必須維持與s_ccc 相同
#-(1)---------------------------------#
# 多工廠待抵帳款計算 by WUPN 96-05-23 #
#-------------------------------------#
FUNCTION cal_t51(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t51,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE          #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql           LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(800)
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,     #No.FUN-630086    #No.FUN-680137 SMALLINT
#         l_plant     DYNAMIC ARRAY OF LIKE och_file.och03       #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
          l_plant     LIKE och_file.och03                        #NO.FUN-A10056
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ##NO.FUN-A10056   --begin
#    LET l_sql = "SELECT och03 FROM och_file",
#                " WHERE och01 ='",p_occ61,"'",
#                "   AND och02 = 1"
#    PREPARE t51_poch FROM l_sql
#    DECLARE t51_och CURSOR FOR t51_poch
 
#    LET l_j = 1
 
#    FOREACH t51_och INTO l_plant[l_j]
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach t51_och:',SQLCA.sqlcode,1)   #No.FUN-660167
#          EXIT FOREACH
#       END IF
# 
#       LET l_j = l_j +1
# 
#    END FOREACH
 
#    LET l_j = l_j - 1
 
    LET l_t51=0
#   FOR l_i = 1 TO l_j   #No.FUN-630086
#       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
#       LET l_azp01 = l_plant[l_i]          # FUN-980020 
#       LET l_azp01 = l_plant
#      SELECT azp03 INTO l_azp03           # DATABASE ID
#       FROM azp_file WHERE azp01=l_plant[l_i]
#       FROM azp_file WHERE azp01=l_plant
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 
                   "SELECT aza17 FROM aza_file ",          #NO.FUN-A10056  
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE aza_t51_pre FROM l_sql
        DECLARE aza_t51_cur CURSOR FOR aza_t51_pre
        OPEN aza_t51_cur 
        FETCH aza_t51_cur INTO l_aza17
        CLOSE aza_t51_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006   
                   "SELECT oaz211,oaz212 FROM oaz_file ",  #NO.FUN-A10056
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE oaz_t51_pre FROM l_sql
        DECLARE oaz_t51_cur CURSOR FOR oaz_t51_pre
        OPEN oaz_t51_cur
        FETCH oaz_t51_cur INTO l_oaz211,l_oaz212
 
        IF g_ooz.ooz07 = 'N' THEN                                                                                                   
           LET l_sql="SELECT oma54t-oma55,oma56t-oma57,oma23,oma01,oma11 ",                                                         
#                    "  FROM ", s_dbstring(l_azp03 CLIPPED),"oma_file ", #FUN-930006                                                                        
                     "  FROM oma_file ",
                     " WHERE oma03 ='",p_occ01,"'",                                                                                 
                     " AND oma54t > oma55",
                     " AND omaconf='Y' AND oma00 LIKE '2%'", #TQC-C90025 add
                     #TQC-C90025 add start -----
                     " AND oma00 <> '23' ",
                     " UNION ALL ",
                     "SELECT (oma54t-oma55)*(1+oma211/100),(oma56t-oma57)*(1+oma211/100),oma23,oma01,oma11 ",
                     "  FROM oma_file ",
                     " WHERE oma03 ='",p_occ01,"'",
                     " AND oma54t > oma55",
                     " AND omaconf='Y' AND oma00 = '23'"
                     #TQC-C90025 add end   -----                                                                                         
        ELSE                                                                                                                        
           LET l_sql="SELECT oma54t-oma55,oma61,oma23,oma01,oma11 ",                                                                
#                    "  FROM ", s_dbstring(l_azp03 CLIPPED),"oma_file ",    #FUN-930006                                                                     
                     "  FROM oma_file ",            #NO.FUN-A10056
                     " WHERE oma03 ='",p_occ01,"'",                                                                                 
                     " AND oma54t > oma55", 
                     " AND omaconf='Y' AND oma00 LIKE '2%'", #TQC-C90025 add
                     #TQC-C90025 add start -----
                     " AND oma00 <> '23' ",
                     " UNION ALL ",
                     "SELECT (oma54t-oma55)*(1+oma211/100),oma61,oma23,oma01,oma11 ",
                     "  FROM oma_file ",
                     " WHERE oma03 ='",p_occ01,"'",
                     " AND oma54t > oma55",
                     " AND omaconf='Y' AND oma00 = '23'"
                     #TQC-C90025 add end   -----                                                                                        
        END IF                                                                                                                      
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       PREPARE t51_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t51',SQLCA.SQLCODE,1)
       END IF
       DECLARE t51_curs CURSOR FOR t51_pre
       FOREACH t51_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
       ##FUN-640215 mark改成下段
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN  
               LET l_tmp = ntd_amt            #換作本幣
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,'')
               LET l_tmp = l_amt * g_exrate   #換作本幣
            END IF
            IF l_occ631 <> l_aza17 THEN       #換作原幣
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,'')
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg02/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-211',g_lang)
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
#       INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
        INSERT INTO r210_ccc VALUES('',l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg02,0,'1',g_occ02)
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t51=l_t51+l_tmp
       END FOREACH
#   END FOR
  ##NO.FUN-A10056   --end
    RETURN l_t51
END FUNCTION
 
#-(2)-------------------------------#
# ＬＣ收狀金額計算 by WUPN 96-05-23 #
#-----------------------------------#
FUNCTION cal_t52(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t52,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_ola07     LIKE ola_file.ola07,
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql           LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(300)
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,     #No.FUN-630086     #No.FUN-680137 SMALLINT
#         l_plant     DYNAMIC ARRAY OF LIKE och_file.och03        #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
          l_plant     LIKE och_file.och03                        #NO.FUN-A10056  
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ##NO.FUN-A10056   --begin
#    SELECT och03 INTO l_plant FROM och_file 
#     WHERE och01 = p_occ61 
#       AND och02 = 2 
#    LET l_sql = "SELECT och03 FROM och_file",
#                " WHERE och01 ='",p_occ61,"'",
#                "   AND och02 = 2"
#    PREPARE t52_poch FROM l_sql
#    DECLARE t52_och CURSOR FOR t52_poch
# 
#    LET l_j = 1
# 
#    FOREACH t52_och INTO l_plant[l_j]
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach t52_och:',SQLCA.sqlcode,1)   
#          EXIT FOREACH
#       END IF
# 
#       LET l_j = l_j +1
# 
#    END FOREACH
# 
#    LET l_j = l_j - 1
    
    LET l_t52=0
#   FOR l_i = 1 TO l_j   #No.FUN-630086
#      IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
#      LET l_azp01 = l_plant[l_i]          # FUN-980020
#       LET l_azp01 = l_plant
#       SELECT azp03 INTO l_azp03           # DATABASE ID
#       FROM azp_file WHERE azp01=l_plant[l_i]
#        FROM azp_file WHERE azp01=l_plant
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006  
                   "SELECT aza17 FROM aza_file",
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE aza_t52_pre FROM l_sql
        DECLARE aza_t52_cur CURSOR FOR aza_t52_pre
        OPEN aza_t52_cur 
        FETCH aza_t52_cur INTO l_aza17
        CLOSE aza_t52_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006   
                   "SELECT oaz211,oaz212 FROM oaz_file", 
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE oaz_t52_pre FROM l_sql
        DECLARE oaz_t52_cur CURSOR FOR oaz_t52_pre
        OPEN oaz_t52_cur
        FETCH oaz_t52_cur INTO l_oaz211,l_oaz212
        LET l_sql=" SELECT ola09-ola10,ola06,ola07,ola01,ola02 ",
#                 " FROM ", s_dbstring(l_azp03 CLIPPED),"ola_file ", #FUN-930006       
                  " FROM ola_file ",
                  " WHERE ola05='",p_occ01,"' AND ola40 = 'N'",
                  "   AND ola09>ola10 AND olaconf !='X' " #010806增
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       PREPARE t52_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t52',SQLCA.SQLCODE,1)
       END IF
       DECLARE t52_curs CURSOR FOR t52_pre
       FOREACH t52_curs INTO l_amt,g_curr,l_ola07,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF l_ola07 IS NULL THEN LET l_ola07 = 1 END IF
       ##FUN-640215 mark改成下段
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = l_amt * l_ola07
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,'')
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,'')
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg03/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-212',g_lang)
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
#       INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
        INSERT INTO r210_ccc VALUES('',l_type,l_date,l_no,g_curr, 
                                    l_tmp,g_ocg.ocg03,0,'2',g_occ02)   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t52=l_t52+l_tmp
       END FOREACH
#   END FOR
  ##NO.FUN-A10056   --end
    RETURN l_t52
END FUNCTION
 
#-(3)-----------------------------------------#
# 多工廠財務暫收支票金額計算 by WUPN 96-05-23 #
#---------------------------------------------#
FUNCTION cal_t53(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t53,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql           LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(800)
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,     #No.FUN-630086     #No.FUN-680137 SMALLINT
#         l_plant     DYNAMIC ARRAY OF LIKE och_file.och03        #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
          l_plant     LIKE och_file.och03                        #NO.FUN-A10056 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ##NO.FUN-A10056   --begin
#    SELECT och03 INTO l_plant FROM och_file 
#     WHERE och01 = p_occ61 
#       AND och02 = 3  
#    LET l_sql = "SELECT och03 FROM och_file",
#                " WHERE och01 ='",p_occ61,"'",
#                "   AND och02 = 3"
#    PREPARE t53_poch FROM l_sql
#    DECLARE t53_och CURSOR FOR t53_poch
# 
#    LET l_j = 1
# 
#    FOREACH t53_och INTO l_plant[l_j]
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach t53_och:',SQLCA.sqlcode,1)  
#          EXIT FOREACH
#       END IF
# 
#       LET l_j = l_j +1
# 
#    END FOREACH
# 
#    LET l_j = l_j - 1
    
    LET l_t53=0
#   FOR l_i = 1 TO l_j   #No.FUN-630086
#      IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
#      LET l_azp01 = l_plant[l_i]          # FUN-980020
#       LET l_azp01 = l_plant 
#       SELECT azp03 INTO l_azp03           # DATABASE ID
#       FROM azp_file WHERE azp01=l_plant[l_i]
#        FROM azp_file WHERE azp01=l_plant
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006   
                   "SELECT aza17 FROM aza_file",
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE aza_t53_pre FROM l_sql
        DECLARE aza_t53_cur CURSOR FOR aza_t53_pre
        OPEN aza_t53_cur 
        FETCH aza_t53_cur INTO l_aza17
        CLOSE aza_t53_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006
                   "SELECT oaz211,oaz212 FROM oaz_file ",
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE oaz_t53_pre FROM l_sql
        DECLARE oaz_t53_cur CURSOR FOR oaz_t53_pre
        OPEN oaz_t53_cur
        FETCH oaz_t53_cur INTO l_oaz211,l_oaz212
       LET l_sql=" SELECT nmh02,nmh32,nmh03,nmh01,nmh09 ",
#                "   FROM ",s_dbstring(l_azp03 CLIPPED),"nmh_file", #FUN-930006  
                 "   FROM nmh_file ",
                 " WHERE nmh11='", p_occ01,"'",
                 "   AND nmh24 IN ( '1','2','3','4') ",
                 "   AND (nmh17 IS NULL OR nmh17 =0 )",
                 "   AND nmh38 <> 'X' ",
                 "   AND nmh02 > 0 "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       PREPARE t53_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t53',SQLCA.SQLCODE,1)
       END IF
       DECLARE t53_curs CURSOR FOR t53_pre
       FOREACH t53_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,'')
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,'')
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg04/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-213',g_lang)
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
#       INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
        INSERT INTO r210_ccc VALUES('',l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg04,0,'3',g_occ02)   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t53=l_t53+l_tmp
       END FOREACH
#   END FOR
  ##NO.FUN-A10056   --end   
    RETURN l_t53
END FUNCTION
 
#-(4)-------------------------------------#
# 多工廠財務暫收ＴＴ計算 by WUPN 96-05-23 #
#-----------------------------------------#
FUNCTION cal_t54(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t54,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_sql           LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(300)
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,     #No.FUN-630086     #No.FUN-680137 SMALLINT
#         l_plant     DYNAMIC ARRAY OF LIKE cre_file.cre08        #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
          l_plant     LIKE och_file.och03                        #NO.FUN-A10056 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ##NO.FUN-A10056   --begin
#    SELECT och03 INTO l_plant FROM och_file 
#     WHERE och01 = p_occ61 
#       AND och02 = 3     
#    LET l_sql = "SELECT och03 FROM och_file",
#                " WHERE och01 ='",p_occ61,"'",
#                "   AND och02 = 3"
#    PREPARE t54_poch FROM l_sql
#    DECLARE t54_och CURSOR FOR t54_poch
# 
#    LET l_j = 1
# 
#    FOREACH t54_och INTO l_plant[l_j]
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach t54_och:',SQLCA.sqlcode,1)  
#          EXIT FOREACH
#       END IF
# 
#       LET l_j = l_j +1
# 
#    END FOREACH
# 
#    LET l_j = l_j - 1
    
    LET l_t54=0
#   FOR l_i = 1 TO l_j   #No.FUN-630086
#      IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
#      LET l_azp01 = l_plant[l_i]          # FUN-980020
#      LET l_azp01 = l_plant
#      SELECT azp03 INTO l_azp03           # DATABASE ID
#       FROM azp_file WHERE azp01=l_plant[l_i]
#       FROM azp_file WHERE azp01=l_plant
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006   
                   "SELECT aza17 FROM aza_file", 
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE aza_t54_pre FROM l_sql
        DECLARE aza_t54_cur CURSOR FOR aza_t54_pre
        OPEN aza_t54_cur 
        FETCH aza_t54_cur INTO l_aza17
        CLOSE aza_t54_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006  
                   "SELECT oaz211,oaz212 FROM oaz_file",
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE oaz_t54_pre FROM l_sql
        DECLARE oaz_t54_cur CURSOR FOR oaz_t54_pre
        OPEN oaz_t54_cur
        FETCH oaz_t54_cur INTO l_oaz211,l_oaz212
        #nmg22在系統中是null值,所以必須以單身之幣別判斷
        LET l_sql=" SELECT npk08,npk09,npk05,nmg00,nmg01 ", #原幣,本幣,幣別
#                 " FROM ",s_dbstring(l_azp03 CLIPPED),"nmg_file,", #FUN-930006 
#                   s_dbstring(l_azp03 CLIPPED),"npk_file", #FUN-930006  
                  " FROM nmg_file,npk_file ",
                 " WHERE nmg18='",p_occ01,"' AND nmgconf = 'Y'",
                 "  AND nmg00=npk00 ",
                 "  AND nmg20 LIKE '2%' ",
                 "   AND nmg23 > 0 ",
                 " AND (nmg24 IS NULL OR nmg24=0 )"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       PREPARE t54_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t54',SQLCA.SQLCODE,1)
       END IF
       DECLARE t54_curs CURSOR FOR t54_pre
       FOREACH t54_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
       ##FUN-640215 mark改成下段
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,'')
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,'')
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg04/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-213',g_lang)
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
#       INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
        INSERT INTO r210_ccc VALUES('',l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg04,0,'4',g_occ02)   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t54=l_t54+l_tmp
       END FOREACH
#   END FOR
  ##NO.FUN-A10056   --end    
    RETURN l_t54
END FUNCTION
 
#-(B)-------------------------------------#
# 沖帳未確認                              #
#-----------------------------------------#
FUNCTION cal_t55(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t55,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_nmg05     LIKE nmg_file.nmg05,
         #l_sql       LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(300)  #MOD-A50023 mark
          l_sql       STRING,                       #MOD-A50023 add 
          l_sql2      STRING,                       #MOD-A50023 add
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,     #No.FUN-630086     #No.FUN-680137 SMALLINT
#         l_plant     DYNAMIC ARRAY OF LIKE cre_file.cre08        #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
          l_plant     LIKE och_file.och03                        #NO.FUN-A10056 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ##NO.FUN-A10056   --begin
#    SELECT och03 INTO l_plant FROM och_file 
#     WHERE och01 = p_occ61  
#       AND och02 = 4  
#    LET l_sql = "SELECT och03 FROM och_file",
#                " WHERE och01 ='",p_occ61,"'",
#                "   AND och02 = 4"
#    PREPARE t55_poch FROM l_sql
#    DECLARE t55_och CURSOR FOR t55_poch
# 
#    LET l_j = 1
# 
#    FOREACH t55_och INTO l_plant[l_j]
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach t55_och:',SQLCA.sqlcode,1)  
#          EXIT FOREACH
#       END IF
# 
#       LET l_j = l_j +1
# 
#    END FOREACH
# 
#    LET l_j = l_j - 1
#    
     LET l_t55=0
#    FOR l_i = 1 TO l_j   #No.FUN-630086
#      IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
#      LET l_azp01 = l_plant[l_i]          # FUN-980020
#       SELECT azp03 INTO l_azp03           # DATABASE ID
#       FROM azp_file WHERE azp01=l_plant[l_i]
#        FROM azp_file WHERE azp01=l_plant
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006
                   "SELECT aza17 FROM aza_file ",
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE aza_t55_pre FROM l_sql
        DECLARE aza_t55_cur CURSOR FOR aza_t55_pre
        OPEN aza_t55_cur 
        FETCH aza_t55_cur INTO l_aza17
        CLOSE aza_t55_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006 
                   "SELECT oaz211,oaz212 FROM oaz_file ",
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE oaz_t55_pre FROM l_sql
        DECLARE oaz_t55_cur CURSOR FOR oaz_t55_pre
        OPEN oaz_t55_cur
        FETCH oaz_t55_cur INTO l_oaz211,l_oaz212
       LET l_sql=" SELECT oob09,oob10,oob07,ooa01,ooa02 ",
#                " FROM ", s_dbstring(l_azp03 CLIPPED),"oob_file,", #FUN-930006 
#                          s_dbstring(l_azp03 CLIPPED),"ooa_file",  #FUN-930006  
                 " FROM oob_file,ooa_file ",
                 " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,
                 "   AND oob09 > 0 ",
                 " AND oob04 = '1'  AND oob03='2' AND ooa01=oob01 "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
      #MOD-A50023---add---start---
       LET l_sql2 = "SELECT oob09*-1,oob10*-1,oob07,ooa01,ooa02 ",
                    " FROM oob_file,ooa_file ",
                    " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,
                    "   AND oob09 > 0 ",
                    " AND oob04 = '3'  AND oob03='1' AND ooa01=oob01 "
       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
       LET l_sql=l_sql," UNION ",l_sql2
      #MOD-A50023---add---end---
       PREPARE t55_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
         CALL cl_err('pre t55',SQLCA.SQLCODE,1)   
       END IF
       DECLARE t55_curs CURSOR FOR t55_pre
       FOREACH t55_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,'')
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,'') 
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
 
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg05/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-214',g_lang)
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
#       INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
        INSERT INTO r210_ccc VALUES('',l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg05,0,'B',g_occ02)   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t55=l_t55+l_tmp
       END FOREACH
#   END FOR
  ##NO.FUN-A10056   --end   
    RETURN l_t55
END FUNCTION
 
#-(5)-------------------------------------#
# 多工廠未兌應收票據計算 by WUPN 96-05-23 #
#-----------------------------------------#
FUNCTION cal_t61(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t61,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql           LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(800)
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,     #No.FUN-630086     #No.FUN-680137 SMALLINT
#         l_plant     DYNAMIC ARRAY OF LIKE cre_file.cre08        #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
          l_plant     LIKE och_file.och03                        #NO.FUN-A10056 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ##NO.FUN-A10056   --begin
#    SELECT och03 INTO l_plant FROM och_file 
#     WHERE och01 = p_occ61  
#       AND och02 = 5  
#   LET l_sql = "SELECT och03 FROM och_file",
#               " WHERE och01 ='",p_occ61,"'",
#               "   AND och02 = 5"
#   PREPARE t61_poch FROM l_sql
#   DECLARE t61_och CURSOR FOR t61_poch
#
#   LET l_j = 1
#
#   FOREACH t61_och INTO l_plant[l_j]
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach t61_och:',SQLCA.sqlcode,1) 
#         EXIT FOREACH
#      END IF
#
#      LET l_j = l_j +1
#
#   END FOREACH
#
#   LET l_j = l_j - 1
#   
    LET l_t61=0
#   FOR l_i = 1 TO l_j   #No.FUN-630086
#      IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
#      LET l_azp01 = l_plant[l_i]          # FUN-980020
#       LET l_azp01 = l_plant 
#       SELECT azp03 INTO l_azp03           # DATABASE ID
#       FROM azp_file WHERE azp01=l_plant[l_i]
#        FROM azp_file WHERE azp01=l_plant
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006  
                   "SELECT aza17 FROM aza_file",
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE aza_t61_pre FROM l_sql
        DECLARE aza_t61_cur CURSOR FOR aza_t61_pre
        OPEN aza_t61_cur 
        FETCH aza_t61_cur INTO l_aza17
        CLOSE aza_t61_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006  
                   "SELECT oaz211,oaz212 FROM oaz_file", 
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE oaz_t61_pre FROM l_sql
        DECLARE oaz_t61_cur CURSOR FOR oaz_t61_pre
        OPEN oaz_t61_cur
        FETCH oaz_t61_cur INTO l_oaz211,l_oaz212
       LET l_sql=" SELECT nmh02,nmh32,nmh03,nmh01,nmh09  ",
#                "   FROM ",s_dbstring(l_azp03 CLIPPED),"nmh_file", #FUN-930006    
                 "   FROM nmh_file",
                 " WHERE nmh11='",p_occ01,"' AND nmh24 IN ('1','2','3','4')",
                 "   AND nmh02 > 0 ",
                 "   AND nmh38 <> 'X' ",
                 " AND (nmh17 >0 AND nmh17 IS NOT NULL)"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       PREPARE t61_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t61',SQLCA.SQLCODE,1)   
       END IF
       DECLARE t61_curs CURSOR FOR t61_pre
       FOREACH t61_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,'')
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,'')
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
 
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg06/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-215',g_lang)
        LET l_tmp=l_tmp * -1
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
#       INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
        INSERT INTO r210_ccc VALUES('',l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg06,0,'5',g_occ02)   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t61=l_t61+l_tmp
       END FOREACH
#   END FOR
  ##NO.FUN-A10056   --end 
    RETURN l_t61
END FUNCTION
 
#-(6)-----------------------------------#
# 多工廠發票應收帳計算 by WUPN 96-05-23 #
#---------------------------------------#
FUNCTION cal_t62(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t62,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql           LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(800)
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,     #No.FUN-630086     #No.FUN-680137 SMALLINT
#         l_plant     DYNAMIC ARRAY OF LIKE cre_file.cre08        #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
          l_plant     LIKE och_file.och03                        #NO.FUN-A10056 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ##NO.FUN-A10056   --begin
#    SELECT och03 INTO l_plant FROM och_file 
#     WHERE och01 = p_occ61  
#       AND och02 = 6 
#    LET l_sql = "SELECT och03 FROM och_file",
#                " WHERE och01 ='",p_occ61,"'",
#                "   AND och02 = 6"
#    PREPARE t62_poch FROM l_sql
#    DECLARE t62_och CURSOR FOR t62_poch
# 
#    LET l_j = 1
# 
#    FOREACH t62_och INTO l_plant[l_j]
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach t62_och:',SQLCA.sqlcode,1)   
#          EXIT FOREACH
#       END IF
# 
#       LET l_j = l_j +1
# 
#    END FOREACH
# 
#    LET l_j = l_j - 1
    
    LET l_t62=0
#   FOR l_i = 1 TO l_j   #No.FUN-630086
#      IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
#      LET l_azp01 = l_plant[l_i]          # FUN-980020
#       LET l_azp01 = l_plant 
#       SELECT azp03 INTO l_azp03           # DATABASE ID
#       FROM azp_file WHERE azp01=l_plant[l_i]
#        FROM azp_file WHERE azp01=l_plant
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006       
                   "SELECT aza17 FROM aza_file",
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE aza_t62_pre FROM l_sql
        DECLARE aza_t62_cur CURSOR FOR aza_t62_pre
        OPEN aza_t62_cur 
        FETCH aza_t62_cur INTO l_aza17
        CLOSE aza_t62_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006    
                   "SELECT oaz211,oaz212 FROM oaz_file",
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE oaz_t62_pre FROM l_sql
        DECLARE oaz_t62_cur CURSOR FOR oaz_t62_pre
        OPEN oaz_t62_cur
        FETCH oaz_t62_cur INTO l_oaz211,l_oaz212
        IF g_ooz.ooz07 = 'N' THEN                                                                                                   
           LET l_sql="SELECT oma54t-oma55,oma56t-oma57,oma23,oma01,oma11 ",                                                         
#                    "  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file",      #FUN-930006                                                                              
                     "  FROM oma_file", 
                     " WHERE oma03='",p_occ01,"'",                                                                                  
                     "   AND oma54t>oma55",                                                                                         
                     "   AND omaconf='Y' AND oma00 LIKE '1%'"                                                                       
        ELSE                                                                                                                        
           LET l_sql="SELECT oma54t-oma55,oma61,oma23,oma01,oma11 ",                                                                
#                    "  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file",    #FUN-930006                                                                       
                     "  FROM oma_file",
                     " WHERE oma03='",p_occ01,"'",                                                                                  
                     "   AND oma54t>oma55",                                                                                         
                     "   AND omaconf='Y' AND oma00 LIKE '1%'"                                                                       
        END IF                                                                                                                      
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       PREPARE t62_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t62',SQLCA.SQLCODE,1)
       END IF
       DECLARE t62_curs CURSOR FOR t62_pre
       FOREACH t62_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,'')
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,'')
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
 
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg07/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-216',g_lang)
        LET l_tmp=l_tmp * -1
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
#       INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
        INSERT INTO r210_ccc VALUES('',l_type,l_date,l_no,g_curr, 
                                    l_tmp,g_ocg.ocg07,0,'6',g_occ02)   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t62=l_t62+l_tmp
       END FOREACH
#   END FOR
  ##NO.FUN-A10056   --end  
    RETURN l_t62
END FUNCTION
 
#-(7)-------------------------------------#
# 多工廠出貨未轉應收計算 by WUPN 96-05-23 #
#-----------------------------------------#
FUNCTION cal_t63(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t63,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oga24     LIKE oga_file.oga24,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql       LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(800)
          l_sql1      LIKE type_file.chr1000,   #No.MOD-9C0316 add 
          l_sql2      LIKE type_file.chr1000,   #No.MOD-9C0316 add 
          l_sql3      LIKE type_file.chr1000,   #No.MOD-9C0316 add 
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,     #No.FUN-630086      #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE cre_file.cre08         #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 7"
    PREPARE t63_poch FROM l_sql
    DECLARE t63_och CURSOR FOR t63_poch
 
    LET l_j = 1
 
    FOREACH t63_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t63_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t63=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          # FUN-980020
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 #NO.FUN-A10056 
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i], 'aza_file'),      #NO.FUN-A10056
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
        PREPARE aza_t63_pre FROM l_sql
        DECLARE aza_t63_cur CURSOR FOR aza_t63_pre
        OPEN aza_t63_cur 
        FETCH aza_t63_cur INTO l_aza17
        CLOSE aza_t63_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006 #NO.FUN-A10056    
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i], 'oaz_file'),      #NO.FUN-A10056
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
        PREPARE oaz_t63_pre FROM l_sql
        DECLARE oaz_t63_cur CURSOR FOR oaz_t63_pre
        OPEN oaz_t63_cur
        FETCH oaz_t63_cur INTO l_oaz211,l_oaz212
         #己出貨未轉應收, 所以要考慮應收未確認的亦歸在出貨未轉應收
         LET l_sql1=" SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
#                " FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file ", #FUN-930006  #NO.FUN-A10056
                 " FROM ",cl_get_target_table(l_plant[l_i], 'oga_file'),        #NO.FUN-A10056
                 " WHERE oga03='",p_occ01,"' ",
                 "  AND oga09 IN ('2','3','4','6','8') ",#No.8347
                 "  AND oga65='N' ",  #No.FUN-610020
                 "  AND oga00 IN ('1','4','5')",
                 "  AND (oga10 IS NULL OR oga10 =' ') ",   #帳款編號
                 "  AND ogaconf = 'Y'",              #已確認
                 "  AND ogapost = 'Y'"               #已扣帳
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1 
         CALL cl_parse_qry_sql(l_sql1,l_plant[l_i]) RETURNING l_sql1   #NO.FUN-A10056
         LET l_sql2= " SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
#                " FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file, ", #FUN-930006  
#                "      ",s_dbstring(l_azp03 CLIPPED),"oma_file ",  #FUN-930006       
                 " FROM ",cl_get_target_table(l_plant[l_i], 'oga_file'),",",     #NO.FUN-A10056
                 cl_get_target_table(l_plant[l_i], 'oma_file'),                  #NO.FUN-A10056
                 " WHERE oga03='",p_occ01,"' ",
                 "  AND oga09 IN ('2','3','4','6','8') ",#No.8347
                 "  AND oga65='N' ",  #No.FUN-610020
                 "  AND oga00 IN ('1','4','5')",
                 "  AND (oga10 IS NOT NULL AND oga10 <> ' ') ",   #帳款編號
                 "  AND oga10=oma01 ",
                 "  AND ogaconf = 'Y'",              #已確認
                 "  AND ogapost = 'Y'",              #已扣帳
                 "  AND omaconf='N' "                #應收未確認
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2 
         CALL cl_parse_qry_sql(l_sql2,l_plant[l_i]) RETURNING l_sql2   #NO.FUN-A10056
         LET l_sql = l_sql1," UNION ", l_sql2 
       IF g_ocg.ocg09 = 0 AND g_ocg.ocg10 = 0 THEN
          LET l_sql3= " SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
#                     " FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file ", #FUN-930006 #NO.FUN-A10056  
                      " FROM ",cl_get_target_table(l_plant[l_i], 'oga_file'),       #NO.FUN-A10056                      
                      " WHERE oga03='",p_occ01,"' ",
                      "  AND oga09 IN ('2','3','4','6','8') ",#No.8347
                      "  AND oga65='N' ",  #No.FUN-610020
                      "  AND oga00 IN ('1','4','5')",
                      "  AND (oga10 IS NULL OR oga10 =' ') ",   #帳款編號
                      "  AND ogapost = 'N'",              #未扣帳
                      "  AND oga55 IN ('1','S') "         #已確認
          CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3
          CALL cl_parse_qry_sql(l_sql3,l_plant[l_i]) RETURNING l_sql3   #NO.FUN-A10056
          LET l_sql = l_sql," UNION ", l_sql3
       END IF
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
       PREPARE t63_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t63',SQLCA.SQLCODE,1)
       END IF
       DECLARE t63_curs CURSOR FOR t63_pre
       FOREACH t63_curs INTO l_amt,g_curr,l_oga24,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = l_amt*l_oga24
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_tmp*g_exrate  
            END IF
        END IF
 
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg08/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-217',g_lang)
        LET l_tmp=l_tmp * -1
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
        INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg08,0,'7',g_occ02)   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t63=l_t63+l_tmp
       END FOREACH
    END FOR
    RETURN l_t63
END FUNCTION
 
#-(8)--Sales Order ---------------------#
# 多工廠接單未出貨計算 by WUPN 96-05-23 #
#---------------------------------------#
FUNCTION cal_t64(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t64,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oea01     LIKE oea_file.oea01,
          l_oea211    LIKE oea_file.oea211,
          oea_amt     LIKE oea_file.oea61,
          ifb_amt     LIKE oea_file.oea61,
          pab_amt     LIKE oea_file.oea61,
          l_oea24     LIKE oea_file.oea24,
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql           LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(600)
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,     #No.FUN-630086     #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE cre_file.cre08        #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
   DEFINE l_oeb04     LIKE oeb_file.oeb04        #訂單料號
   DEFINE l_oeb05     LIKE oeb_file.oeb05        #銷售單位
   DEFINE l_oeb916    LIKE oeb_file.oeb916       #計價單位
   DEFINE l_amt2      LIKE oeb_file.oeb14t       #訂單項次金額
   DEFINE l_amt3      LIKE oeb_file.oeb14t       #訂單項次已出貨金額
   DEFINE l_num       LIKE type_file.num5
   DEFINE l_factor    LIKE ima_file.ima31_fac
   DEFINE l_oeb13     LIKE oeb_file.oeb13   #TQC-C90025 add
   DEFINE l_oeb24     LIKE oeb_file.oeb24   #TQC-C90025 add
   DEFINE l_oeb1006   LIKE oeb_file.oeb1006 #TQC-C90025 add
   DEFINE l_oeb12     LIKE oeb_file.oeb12   #TQC-C90025 add
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 9"
    PREPARE t64_poch FROM l_sql
    DECLARE t64_och CURSOR FOR t64_poch
 
    LET l_j = 1
 
    FOREACH t64_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t64_och:',SQLCA.sqlcode,1)   
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t64=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          # FUN-980020
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 #NO.FUN-A10056     
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i], 'aza_file'),      #NO.FUN-A10056
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
        PREPARE aza_t64_pre FROM l_sql
        DECLARE aza_t64_cur CURSOR FOR aza_t64_pre
        OPEN aza_t64_cur 
        FETCH aza_t64_cur INTO l_aza17
        CLOSE aza_t64_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006 #NO.FUN-A10056   
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i], 'oaz_file'),      #NO.FUN-A10056
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
        PREPARE oaz_t64_pre FROM l_sql
        DECLARE oaz_t64_cur CURSOR FOR oaz_t64_pre
        OPEN oaz_t64_cur
        FETCH oaz_t64_cur INTO l_oaz211,l_oaz212
       LET l_sql=" SELECT DISTINCT oea01,oea02,oea23,oea24,oea211 ",
#                " FROM ",s_dbstring(l_azp03 CLIPPED),"oea_file, ", #FUN-930006 #NO.FUN-A10056  
#                "      ",s_dbstring(l_azp03 CLIPPED),"oeb_file ",  #FUN-930006 #NO.FUN-A10056 
                 " FROM ",cl_get_target_table(l_plant[l_i], 'oea_file'),",",    #NO.FUN-A10056 
                 cl_get_target_table(l_plant[l_i], 'oeb_file'),                 #NO.FUN-A10056  
                 " WHERE oea03='",p_occ01,"' ",
                 " AND oea01=oeb01 ",
                 " AND oeaconf='Y' AND oea00 IN ('1','4','5') " ,	#MOD-990044
                 " AND oeb70='N' ",  
                 " AND oea49 IN ('1','S') ",     #MOD-8C0094
                 " GROUP BY oea01,oea02,oea23,oea24,oea211 ",   #MOD-8C0094
                 " ORDER BY oea01 "
 
 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
       PREPARE t64_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          #CALL cl_err('pre t61',SQLCA.SQLCODE,1)  #TQC-C90025 mark
          CALL cl_err('pre t64',SQLCA.SQLCODE,1)   #TQC-C90025 add
       END IF
       DECLARE t64_curs CURSOR FOR t64_pre
       FOREACH t64_curs INTO l_oea01,l_date,g_curr,l_oea24,l_oea211
         SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
          WHERE azi01 = g_curr
         #LET l_sql = " SELECT oeb04,oeb05,oeb916,oeb14t,oeb24* CAST(oeb13*oeb1006/100 AS DECIMAL(20,",t_azi03,"))", #TQC-C90025 mark
          LET l_sql = " SELECT oeb04,oeb05,oeb916,oeb14,oeb24,oeb13,oeb1006,oeb12",                                  #TQC-C90025 add
#                " FROM ",s_dbstring(l_azp03 CLIPPED),"oeb_file ", #FUN-930006  #NO.FUN-A10056
                 " FROM ",cl_get_target_table(l_plant[l_i], 'oeb_file'),        #NO.FUN-A10056
                 " WHERE oeb01='",l_oea01 CLIPPED,"'",
                 " AND oeb70='N' "   
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
         CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
         PREPARE t64_pre_1 FROM l_sql
         IF SQLCA.SQLCODE <> 0 THEN
            #CALL cl_err('pre t61',SQLCA.SQLCODE,1) #TQC-C90025 mark
            CALL cl_err('pre t64',SQLCA.SQLCODE,1)  #TQC-C90025 add
         END IF
         DECLARE t64_cur_1 CURSOR FOR t64_pre_1
         LET l_amt = 0
         LET pab_amt = 0
         #FOREACH t64_cur_1 INTO l_oeb04,l_oeb05,l_oeb916,l_amt2,l_amt3                          #TQC-C90025 mark
         FOREACH t64_cur_1 INTO l_oeb04,l_oeb05,l_oeb916,l_amt2,l_amt3,l_oeb13,l_oeb1006,l_oeb12 #TQC-C90025 add 
            IF l_amt2 IS NULL THEN LET l_amt2 = 0 END IF 
            #TQC-C90025 add --start--
            IF l_oeb24 = l_oeb12 THEN
               LET l_amt3 = l_amt2
            ELSE
               LET l_amt3 = l_oeb24 * cl_digcut((l_oeb13*l_oeb1006/100),t_azi03)
            #TQC-C90025 add --end--
               IF l_amt3 IS NULL THEN LET l_amt3 = 0 END IF
               IF cl_null(l_oeb916) THEN
                  LET l_oeb916 = l_oeb05
               END IF 
               CALL s_umfchk(l_oeb04,l_oeb05,l_oeb916) RETURNING l_num,l_factor
               IF l_num = 1 THEN LET l_factor = 1 END IF
               LET l_amt3 = l_amt3 * l_factor
            END IF #TQC-C90025 add
            LET l_amt = l_amt + l_amt2
            LET pab_amt = pab_amt + l_amt3
         END FOREACH
         LET l_no=l_oea01
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         LET pab_amt = pab_amt*(1+l_oea211/100)    #含稅金額
         LET pab_amt = cl_digcut(pab_amt,t_azi04)  #MOD-B80001 add
         LET l_amt = l_amt*(1+l_oea211/100)        #含稅金額 #TQC-C90025 add
         LET l_amt = cl_digcut(l_amt,t_azi04)                #TQC-C90025 add
         #計算出貨通知單量
         LET ifb_amt =0
         LET l_sql = "SELECT SUM(ogb14t)",
#                    "  FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file, ", #FUN-930006  #NO.FUN-A10056 
#                    "       ",s_dbstring(l_azp03 CLIPPED),"ogb_file ",  #FUN-930006  #NO.FUN-A10056
                     "  FROM ",cl_get_target_table(l_plant[l_i], 'oga_file'),",",     #NO.FUN-A10056
                     cl_get_target_table(l_plant[l_i], 'ogb_file'),                   #NO.FUN-A10056
                     " WHERE oga01=ogb01",
                     "   AND oga09 IN ('1','5') ",
                     "   AND ogb31='",l_oea01,"'",
#MOD-B80027 -- begin --
                     "   AND ogb31||ogb32 IN (SELECT oeb01||oeb03 FROM ",cl_get_target_table(l_plant[l_i],'oeb_file'),
                     "                        WHERE oeb01='",l_oea01,"' AND oeb70='N')",
#MOD-B80027 -- end --
                     "   AND oga55 IN ('1','S')"   #No.MOD-640569
 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
         CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
         PREPARE t64_pre2 FROM l_sql
         IF SQLCA.SQLCODE <> 0 THEN
             CALL cl_err('pre t64_pre2',SQLCA.SQLCODE,1)
         END IF
         DECLARE t64_curs2 CURSOR FOR t64_pre2
         OPEN t64_curs2
         FETCH t64_curs2 INTO ifb_amt
 
         IF cl_null(ifb_amt) THEN LET ifb_amt=0 END IF
         LET ifb_amt = ifb_amt - pab_amt   #出貨通知單金額-已出貨金額
         IF ifb_amt < 0 THEN LET ifb_amt = 0 END IF
         #訂單未出貨金額=訂單金額-已出貨金額-出貨通知單金額(扣除已出貨)
         LET l_amt = l_amt - pab_amt - ifb_amt
         IF l_amt <= 0 THEN CONTINUE FOREACH END IF
 
        IF l_occ631=g_curr THEN
           LET l_tmp = l_amt
        ELSE
           IF l_oaz211 = '1' THEN
              LET l_tmp = l_amt*l_oea24
           ELSE
              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
              LET l_tmp = l_amt * g_exrate
           END IF
           IF l_occ631 <> l_aza17 THEN
              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
              LET l_tmp = l_tmp*g_exrate  
           END IF
        END IF
 
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg10/100	#MOD-990029 
 
   	LET l_type = cl_getmsg('axm-218',g_lang)
        LET l_tmp=l_tmp * -1
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
        INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg10,0,'8',g_occ02)   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t64=l_t64+l_tmp
       END FOREACH
    END FOR
    RETURN l_t64
END FUNCTION

#CHI-B50037 add --start--
#-(D)--Borrow --------------------------#
# 借貨金額                              #
#---------------------------------------#
FUNCTION cal_t67(p_occ01,p_occ61) 
   DEFINE l_aza17     LIKE aza_file.aza17
   DEFINE l_oaz211    LIKE oaz_file.oaz211
   DEFINE l_oaz212    LIKE oaz_file.oaz212
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t67,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oea01     LIKE oea_file.oea01,
          l_oea211    LIKE oea_file.oea211,
          oea_amt     LIKE oea_file.oea61,
          ifb_amt     LIKE oea_file.oea61,
          pab_amt     LIKE oea_file.oea61,
          l_oea24     LIKE oea_file.oea24,
          l_date      LIKE type_file.dat,    #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,   
          l_sql       STRING,             
          l_azp03     LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02  

    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01

    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 9"
    PREPARE t67_poch FROM l_sql
    DECLARE t67_och CURSOR FOR t67_poch

    LET l_j = 1

    FOREACH t67_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t67_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       LET l_j = l_j +1

    END FOREACH

    LET l_j = l_j - 1

    LET l_t67=0 
    FOR l_i = 1 TO l_j
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF

       SELECT azp03 INTO l_azp03
        FROM azp_file WHERE azp01=l_plant[l_i]
        LET l_sql =
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i], 'aza_file'),
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql
        PREPARE aza_t67_pre FROM l_sql
        DECLARE aza_t67_cur CURSOR FOR aza_t67_pre
        OPEN aza_t67_cur
        FETCH aza_t67_cur INTO l_aza17
        CLOSE aza_t67_cur

        LET l_sql =
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i], 'oaz_file'),
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql
        PREPARE oaz_t67_pre FROM l_sql
        DECLARE oaz_t67_cur CURSOR FOR oaz_t67_pre
        OPEN oaz_t67_cur
        FETCH oaz_t67_cur INTO l_oaz211,l_oaz212

      #借貨量為實際借貨量-已還數量-償價數量
      LET l_sql=" SELECT oea01,oea02,oea23,oea24,oea211,",
                "        SUM((oeb12-oeb25-oeb29)*oeb13) ",
                " FROM ",cl_get_target_table(l_plant[l_i], 'oea_file'),",",
                cl_get_target_table(l_plant[l_i], 'oeb_file'),
                " WHERE oea03='",p_occ01,"' ",
                " AND oea01=oeb01 ",
                " AND oea00 = '8'" ,
                " AND oeb70='N' ",
                " AND oea49 MATCHES '[1S]' ",
                " GROUP BY 1,2,3,4,5 "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql
       PREPARE t67_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t67',SQLCA.SQLCODE,1)
       END IF
       DECLARE t67_curs CURSOR FOR t67_pre
       FOREACH t67_curs INTO l_oea01,l_date,g_curr,l_oea24,l_oea211,
                             pab_amt
         LET l_no=l_oea01
         IF pab_amt IS NULL THEN LET pab_amt = 0 END IF
         LET pab_amt = pab_amt*(1+l_oea211/100)    #含稅金額
         IF l_occ631=g_curr THEN
            LET l_tmp = pab_amt
         ELSE
            IF g_oaz.oaz211 = '1' THEN
               LET l_tmp = pab_amt*l_oea24
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03)
               LET l_tmp = pab_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03)
               LET l_tmp = l_tmp*g_exrate
            END IF
        END IF
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg10/100

        LET l_type = cl_getmsg('axm-146',g_lang)
        LET l_tmp=l_tmp * -1
        LET l_tmp = cl_digcut(l_tmp,t_azi04)
        INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg10,0,'D',g_occ02)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("ins","r210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins r210_cccD",0)
           EXIT FOREACH
        END IF
        LET l_t67=l_t67+l_tmp
       END FOREACH
    END FOR
    RETURN l_t67
END FUNCTION
#CHI-B50037 add --end--

 
#-(9)Shipping Notice----------------------#
# 多工廠出貨通知單                        #
#-----------------------------------------#
FUNCTION cal_t66(p_occ01,p_slip,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61 LIKE occ_file.occ61,
          p_slip  LIKE cre_file.cre02,        #No.FUN-680137 VARCHAR(10)
          l_t66,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oea01     LIKE oea_file.oea01,
          l_oea211    LIKE oea_file.oea211,
          oea_amt     LIKE oea_file.oea61,
          ifb_amt     LIKE oea_file.oea61,
          pab_amt     LIKE oea_file.oea61,
          l_oea24     LIKE oea_file.oea24,
          l_date      LIKE type_file.dat,           #No.FUN-680137  DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql           LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(800)
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,     #No.FUN-630086     #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE cre_file.cre08,       #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
          l_tmp2      LIKE oma_file.oma57,   #MOD-8C0094
          ifb_tot,pab_tot   LIKE oea_file.oea61,   #MOD-8C0094
          ifb_tot2,pab_tot2   LIKE oea_file.oea61,  #MOD-8C0094
          l_amt2      LIKE oma_file.oma57,  #MOD-8C0094
          l_curr      LIKE azi_file.azi01,  #MOD-8C0094
          l_oga24     LIKE oga_file.oga24   #MOD-8C0094
 
 
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 8"
    PREPARE t66_poch FROM l_sql
    DECLARE t66_och CURSOR FOR t66_poch
 
    LET l_j = 1
 
    FOREACH t66_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t66_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t66=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          # FUN-980020
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 #NO.FUN-A10056   
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i], 'aza_file'),      #NO.FUN-A10056
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
        PREPARE aza_t66_pre FROM l_sql
        DECLARE aza_t66_cur CURSOR FOR aza_t66_pre
        OPEN aza_t66_cur 
        FETCH aza_t66_cur INTO l_aza17
        CLOSE aza_t66_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006 #NO.FUN-A10056 
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i], 'oaz_file'),      #NO.FUN-A10056
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
        PREPARE oaz_t66_pre FROM l_sql
        DECLARE oaz_t66_cur CURSOR FOR oaz_t66_pre
        OPEN oaz_t66_cur
        FETCH oaz_t66_cur INTO l_oaz211,l_oaz212
      LET l_sql=" SELECT oea01,oea02,oea23 ",
#               " FROM ",s_dbstring(l_azp03 CLIPPED),"oea_file, ", #FUN-930006  #NO.FUN-A10056 
#               "      ",s_dbstring(l_azp03 CLIPPED),"oeb_file",   #FUN-930006  #NO.FUN-A10056
                " FROM ",cl_get_target_table(l_plant[l_i], 'oea_file'),",",     #NO.FUN-A10056
                cl_get_target_table(l_plant[l_i], 'oeb_file'),                  #NO.FUN-A10056
                " WHERE oea03='",p_occ01,"' ",
                " AND oea01=oeb01 ",
                " AND oeaconf='Y' AND oea00 IN ('1','4','5')" ,
                " AND oeb70='N' ",   #不含已結案
                " GROUP BY oea01,oea02,oea23 "
 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
      CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
      PREPARE t66_pre FROM l_sql
      IF SQLCA.SQLCODE <> 0 THEN
         CALL cl_err('pre t66',SQLCA.SQLCODE,1)
      END IF
      DECLARE t66_curs CURSOR FOR t66_pre
      FOREACH t66_curs INTO l_oea01,l_date,l_curr 
        LET l_no = l_oea01
        LET l_sql = " SELECT oga23,oga24,SUM(ogb14t) ",
#                   " FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file, ", #FUN-930006 
#                   "      ",s_dbstring(l_azp03 CLIPPED),"ogb_file, ", #FUN-930006  
#                   "      ",s_dbstring(l_azp03 CLIPPED),"oeb_file ",  #FUN-930006
                    " FROM ",cl_get_target_table(l_plant[l_i], 'oga_file'),",",     #NO.FUN-A10056
                    cl_get_target_table(l_plant[l_i], 'ogb_file'),",",              #NO.FUN-A10056
                    cl_get_target_table(l_plant[l_i], 'oeb_file'),                  #NO.FUN-A10056
                    "  WHERE ogb31 ='",l_oea01,"'",
                    "    AND oga01 = ogb01 ",
                    "    AND ogaconf='Y' ",
                    "    AND ogapost='Y' ",
                    "    AND oga09 IN ('2','3','4','6','8') ",                 #CHI-8C0028
                    "    AND ogb31 = oeb01 ",  
                    "    AND ogb32 = oeb03 ",  
                    "    AND oeb70 = 'N' ",    
                    "    GROUP BY oga23,oga24 "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
        PREPARE t66_pab_pre FROM l_sql
        DECLARE t66_pab_cur CURSOR FOR t66_pab_pre
        LET pab_tot = 0
        LET pab_tot2 = 0
        FOREACH t66_pab_cur INTO g_curr,l_oga24,pab_amt
           IF l_occ631=g_curr THEN
              LET l_tmp = pab_amt
           ELSE
              IF l_oaz211 = '1' THEN
                 LET l_tmp = pab_amt*l_oga24
              ELSE
                 LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01)  #FUN-980020
                 LET l_tmp = pab_amt * g_exrate
              END IF
              IF l_occ631 <> l_aza17 THEN
                 LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020 
                 LET l_tmp = l_tmp*g_exrate
              END IF
           END IF
           LET l_tmp2 = l_tmp   
           LET pab_tot2 = pab_tot2 + l_tmp2 
           LET l_tmp= l_tmp * g_ocg.ocg09/100
           LET pab_tot = pab_tot + l_tmp
        END FOREACH
        LET l_sql = " SELECT oga23,oga24,SUM(ogb14t) ",
#                   " FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file, ", #FUN-930006 
#                   "      ",s_dbstring(l_azp03 CLIPPED),"ogb_file, ", #FUN-930006  
#                   "      ",s_dbstring(l_azp03 CLIPPED),"oeb_file ",  #FUN-930006      
                    " FROM ",cl_get_target_table(l_plant[l_i], 'oga_file'),",",     #NO.FUN-A10056
                    cl_get_target_table(l_plant[l_i], 'ogb_file'),",",              #NO.FUN-A10056
                    cl_get_target_table(l_plant[l_i], 'oeb_file'),                  #NO.FUN-A10056
                    "  WHERE ogb31 ='",l_oea01,"'",
                    "    AND oga01 = ogb01 ",
                    "    AND oga09 IN ('1','5') ",
                    "    AND ogb31 = oeb01 ",  
                    "    AND ogb32 = oeb03 ",  
                    "    AND oeb70 = 'N' "     
        IF cl_null(p_slip) THEN
           LET l_sql = l_sql CLIPPED,
                       " AND oga55 IN ('1','S') ",
                       " GROUP BY oga23,oga24 "
        ELSE
           LET l_sql = l_sql CLIPPED,
                       " AND ( oga55 IN ('1','S') ",
                       "     OR oga01 = '",p_slip,"' ) ",
                       " GROUP BY oga23,oga24 "
        END IF
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #NO.FUN-A10056
        PREPARE t66_ifb_pre FROM l_sql
        DECLARE t66_ifb_cur CURSOR FOR t66_ifb_pre
        LET ifb_tot = 0
        LET ifb_tot2= 0
        FOREACH t66_ifb_cur INTO g_curr,l_oga24,ifb_amt
           IF l_occ631=g_curr THEN
              LET l_tmp = ifb_amt
           ELSE
              IF l_oaz211 = '1' THEN
                 LET l_tmp = ifb_amt*l_oga24
              ELSE
                 LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01)   #FUN-980020
                 LET l_tmp = ifb_amt * g_exrate
              END IF
              IF l_occ631 <> l_aza17 THEN
                 LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
                 LET l_tmp = l_tmp*g_exrate
              END IF
           END IF
           LET l_tmp2 = l_tmp   
           LET ifb_tot2 = ifb_tot2 + l_tmp2   
           LET l_tmp= l_tmp * g_ocg.ocg09/100
           LET ifb_tot = ifb_tot + l_tmp
        END FOREACH
        LET l_amt2 = ifb_tot2 - pab_tot2  
        LET l_amt = ifb_tot - pab_tot   #出貨通知單金額-已出貨金額
        IF l_amt2<= 0 THEN CONTINUE FOREACH END IF   
        IF l_amt <= 0 THEN CONTINUE FOREACH END IF
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
       #LET l_amt2 = l_amt2*g_exrate #MOD-B20126 mark
       
        LET l_type = cl_getmsg('axm-219',g_lang)
        LET l_amt2=l_amt2 * -1
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_amt2 = cl_digcut(l_amt2,t_azi04)                       #No.CHI-910034
        LET l_amt=l_amt * -1 #MOD-B20126 add
        LET l_amt = cl_digcut(l_amt,t_azi04) #MOD-B20126 add
        INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,l_curr,
                                   #l_amt2,g_ocg.ocg09,0,'9',g_occ02) #MOD-B20126 mark 
                                    l_amt,g_ocg.ocg09,0,'9',g_occ02)  #MOD-B20126
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)  
           EXIT FOREACH
        END IF
       LET l_t66=l_t66+l_amt
      END FOREACH
    END FOR
    RETURN l_t66
END FUNCTION
 
#-(10)(A)--------------------------------#
# 多工廠應收逾期帳計算 by ERIC 98-06-24 #
#---------------------------------------#
FUNCTION cal_t65(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61 LIKE occ_file.occ61,
          l_t65,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oma01     LIKE oma_file.oma01,
          l_oob09     LIKE oob_file.oob09,
          l_oob10     LIKE oob_file.oob10,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql           LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(800)
          l_sql1          LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(800)
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_today         LIKE type_file.dat,       #No.FUN-680137 DATE
          l_oob06         LIKE oob_file.oob06,
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_oma11         LIKE oma_file.oma11,
          l_j         LIKE type_file.num5,     #No.FUN-630086     #No.FUN-680137 SMALLINT
#         l_plant     DYNAMIC ARRAY OF LIKE cre_file.cre08        #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
          l_plant     LIKE och_file.och03                        #NO.FUN-A10056 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ##NO.FUN-A10056   --begin
#    SELECT och03 INTO l_plant FROM och_file 
#     WHERE och01 = p_occ61  
#       AND och02 = 10  
#    LET l_sql = "SELECT och03 FROM och_file",
#                " WHERE och01 ='",p_occ61,"'",
#                "   AND och02 = 10"
#    PREPARE t65_poch FROM l_sql
#    DECLARE t65_och CURSOR FOR t65_poch
# 
#    LET l_j = 1
# 
#    FOREACH t65_och INTO l_plant[l_j]
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach t65_och:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
# 
#       LET l_j = l_j +1
# 
#    END FOREACH
# 
#    LET l_j = l_j - 1
    
# 逾期金額 = t62應收帳款中已逾期之金額 - t55應收沖帳未確認中已逾期之金額
    LET l_t65=0
    LET l_today=TODAY-l_occ36
#   FOR l_i = 1 TO l_j   #No.FUN-630086
#      IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
#      LET l_azp01 = l_plant[l_i]          # FUN-980020
#       LET l_azp01 = l_plant 
#       SELECT azp03 INTO l_azp03           # DATABASE ID
#       FROM azp_file WHERE azp01=l_plant[l_i]
#        FROM azp_file WHERE azp01=l_plant
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006  
                   "SELECT aza17 FROM aza_file",
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE aza_t65_pre FROM l_sql
        DECLARE aza_t65_cur CURSOR FOR aza_t65_pre
        OPEN aza_t65_cur 
        FETCH aza_t65_cur INTO l_aza17
        CLOSE aza_t65_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006   
                   "SELECT oaz211,oaz212 FROM oaz_file",
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE oaz_t65_pre FROM l_sql
        DECLARE oaz_t65_cur CURSOR FOR oaz_t65_pre
        OPEN oaz_t65_cur
        FETCH oaz_t65_cur INTO l_oaz211,l_oaz212
       #應收已沖帳未確認金額
       LET l_sql1=" SELECT SUM(oob09),SUM(oob10) ",
#                 " FROM ",s_dbstring(l_azp03 CLIPPED),"oob_file,",  #FUN-930006 
#                          s_dbstring(l_azp03 CLIPPED),"ooa_file,",  #FUN-930006 
#                          s_dbstring(l_azp03 CLIPPED),"oma_file,",  #FUN-930006  
#                          s_dbstring(l_azp03 CLIPPED),"omc_file",   #CHI-980048 
                  " FROM oob_file,ooa_file,oma_file,omc_file",
                 " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,
                 " AND oob04 = '1'  AND oob03='2' AND ooa01=oob01 ",
                 " AND oob09>0",
                 " AND oma01 = oob06",
                 " AND oma01 = omc01 AND oob19=omc02 AND omc04<'",l_today,"'",		#CHI-980048
                 " AND oma01 = ? "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       PREPARE t65_pre2 FROM l_sql1
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre2 t65',SQLCA.SQLCODE,1)
       END IF
       DECLARE t65_curs2 CURSOR FOR t65_pre2
 
       IF g_ooz.ooz07 = 'N' THEN                                                                                                    
          LET l_sql=" SELECT omc01,SUM(omc08-omc10),SUM(omc09-omc11),oma23,oma11 ",	#CHI-980048
#                   "  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file,", #FUN-930006                                                                             
#                             s_dbstring(l_azp03 CLIPPED),"omc_file",     		#CHI-980048
                    "  FROM oma_file,omc_file", 
                    " WHERE oma03='",p_occ01,"'",                                                                                   
                    "  AND omc04 <'",l_today,"' ",					#CHI-980048
                    "  AND omc01 = oma01 AND omc08 > omc10 ",  				#CHI-980048 
                    " AND omaconf='Y' AND oma00 LIKE '1%'"                                                                          
       ELSE                                                                                                                         
          LET l_sql=" SELECT omc01,SUM(omc08-omc10),SUM(omc13),oma23,oma11 ",		#CHI-980048	
#                   "  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file,", #FUN-930006                                                                            
#                             s_dbstring(l_azp03 CLIPPED),"omc_file",     		#CHI-980048
                    "  FROM oma_file,omc_file",
                    " WHERE oma03='",p_occ01,"'",                                                                                   
                    "  AND omc04 <'",l_today,"' ",					#CHI-980048
                    "  AND omc01 = oma01 AND omc08 > omc10 ",  				#CHI-980048 
                    " AND omaconf='Y' AND oma00 LIKE '1%'"                                                                          
       END IF                                                                                                                       
       LET l_sql = l_sql CLIPPED," GROUP BY omc01,oma23,oma11 "	#CHI-980048
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       PREPARE t65_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t65',SQLCA.SQLCODE,1)
       END IF
       DECLARE t65_curs CURSOR FOR t65_pre
       FOREACH t65_curs INTO l_oma01,l_amt,ntd_amt,g_curr,l_date
         LET l_no=l_oma01
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         #需扣除已沖帳未確認金額
         LET l_oob09=0  LET l_oob10=0
         OPEN t65_curs2 USING l_oma01
         IF SQLCA.SQLCODE THEN
            LET l_oob09=0  LET l_oob10=0
         END IF
         FETCH t65_curs2 INTO l_oob09,l_oob10
         IF cl_null(l_oob09) THEN LET l_oob09=0 END IF
         IF cl_null(l_oob10) THEN LET l_oob10=0 END IF
         LET l_amt=l_amt-l_oob09
         LET ntd_amt=ntd_amt-l_oob10
       ##FUN-640215 mark改成下段
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,'') 
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,'')
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
 
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
 
   	LET l_type = cl_getmsg('axm-210',g_lang)
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
#       INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
        INSERT INTO r210_ccc VALUES('',l_type,l_date,l_no,g_curr, 
                                    l_tmp,0,0,'A',g_occ02)
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t65=l_t65+l_tmp
       END FOREACH
#   END FOR
  ##NO.FUN-A10056   --end  
    RETURN l_t65
END FUNCTION
 
#-(11)(C)--------------------------------#
# 多工廠逾期未兌現應收票據計算 010404 add#
#----------------------------------------#
FUNCTION cal_t70(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61 LIKE occ_file.occ61,
          l_t70,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql           LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(800)
          l_date      LIKE type_file.dat,           #No.FUN-680137 DATE                  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_today         LIKE type_file.dat,       #No.FUN-680137 DATE
          l_oob06         LIKE oob_file.oob06,
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03,
          l_oma11         LIKE oma_file.oma11,
          l_j         LIKE type_file.num5,     #No.FUN-630086     #No.FUN-680137 SMALLINT
#         l_plant     DYNAMIC ARRAY OF LIKE cre_file.cre08        #No.FUN-680137 VARCHAR(10)   #No.FUN-630086
          l_plant     LIKE och_file.och03                        #NO.FUN-A10056 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ##NO.FUN-A10056   --begin
#    SELECT och03 INTO l_plant FROM och_file 
#     WHERE och01 = p_occ61  
#       AND och02 = 11  
#    LET l_sql = "SELECT och03 FROM och_file",
#                " WHERE och01 ='",p_occ61,"'",
#                "   AND och02 = 11"
#    PREPARE t70_poch FROM l_sql
#    DECLARE t70_och CURSOR FOR t70_poch
# 
#    LET l_j = 1
# 
#    FOREACH t70_och INTO l_plant[l_j]
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach t70_och:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
# 
#       LET l_j = l_j +1
# 
#    END FOREACH
# 
#    LET l_j = l_j - 1
    
    LET l_t70=0
    LET l_today=TODAY-l_occ36
#   FOR l_i = 1 TO l_j   #No.FUN-630086
#      IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
#       LET l_azp01 = l_plant[l_i]          # FUN-980020
#        LET l_azp01 = l_plant
#       SELECT azp03 INTO l_azp03           # DATABASE ID
#       FROM azp_file WHERE azp01=l_plant[l_i]
#        FROM azp_file WHERE azp01=l_plant
        LET l_sql =
#                  "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006  
                   "SELECT aza17 FROM aza_file", 
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE aza_t70_pre FROM l_sql
        DECLARE aza_t70_cur CURSOR FOR aza_t70_pre
        OPEN aza_t70_cur 
        FETCH aza_t70_cur INTO l_aza17
        CLOSE aza_t70_cur
       
        LET l_sql =
#                  "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006 
                   "SELECT oaz211,oaz212 FROM oaz_file",
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        PREPARE oaz_t70_pre FROM l_sql
        DECLARE oaz_t70_cur CURSOR FOR oaz_t70_pre
        OPEN oaz_t70_cur
        FETCH oaz_t70_cur INTO l_oaz211,l_oaz212
 
       LET l_sql=" SELECT nmh02,nmh32,nmh03,nmh01,nmh05 ",
#                "   FROM ",s_dbstring(l_azp03 CLIPPED),"nmh_file",#FUN-930006  
                 "   FROM nmh_file",
                 " WHERE nmh11='", p_occ01,"'",
                 "   AND nmh24 IN ( '1','2','3','4') ",
                 "   AND nmh05 < '",l_today,"' ",
                 "   AND nmh38 ='Y' "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       PREPARE t70_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t70',SQLCA.SQLCODE,1)
       END IF
       DECLARE t70_curs CURSOR FOR t70_pre
       FOREACH t70_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,'')
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,'')
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL r210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
 
   	LET l_type = cl_getmsg('axm-209',g_lang)
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631 #No.CHI-910034
        LET l_tmp = cl_digcut(l_tmp,t_azi04)                         #No.CHI-910034
#       INSERT INTO r210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
        INSERT INTO r210_ccc VALUES('',l_type,l_date,l_no,g_curr, 
                                    l_tmp,0,0,'C',g_occ02)
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","r210_ccc","","",SQLCA.SQLCODE,"","ins r210_ccc",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t70=l_t70+l_tmp
       END FOREACH
#   END FOR
  ##NO.FUN-A10056   --end   
    RETURN l_t70
END FUNCTION
 
FUNCTION r210_check_exrate(p_occ631)
  DEFINE p_occ631    LIKE occ_file.occ631
  DEFINE p_exrate    LIKE azk_file.azk03 #FUN-4B0050
 
        #換算額度客戶幣別匯率
        IF p_occ631 = g_occ631 THEN
           LET p_exrate = 1
        ELSE
           LET p_exrate=s_exrate_m(p_occ631,g_occ631,g_oaz.oaz212,'') #FUN-640215 add ''
        END IF
        IF cl_null(p_exrate) THEN LET p_exrate = 1 END IF
        RETURN p_exrate
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
