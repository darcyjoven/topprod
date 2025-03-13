# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr770.4gl
# Descriptions...: 短期融資月底重評價表(anmr770)
# Date & Author..: 05/04/14 By Jackie
# Modify.........: No.FUN-550015 05/05/24 By Smapmin 新增INPUT "匯率選項"
# Modify.........: No.MOD-560008 05/06/02 By Smapmin DEFINE單價,金額,匯率
# Modify.........: No.FUN-550114 05/06/11 By echo 新增報表備註
# Modify.........: No.MOD-580154 05/08/19 By CoCo PAGE LENGTH改為 g_page_line
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/21 By johnray 報表修改
# Modify.........: No.MOD-720058 07/02/07 By Smapmin UPDATE r770_tmp1
# Modify.........: No.MOD-740213 07/04/26 By kim 輸入條件後程式自動關閉
# Modify.........: No.TQC-790094 07/09/14 By Judy 報表中制表日期在表名之上
# Modify.........: NO.FUN-7B0026 07/11/14 By zhaijie報表輸出改為Crystal Report
# Modify.........: No.MOD-810101 08/01/16 By Smapmin 報表應判斷結案日期=NULL OR 結案日期>供需截止日的融資資料才需重評價
# Modify.........: No.MOD-840091 08/04/14 By Carol 借款餘額未扣除已還款金額
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.MOD-8A0010 08/10/02 By clover 列印排除以作廢資料
# Modify.........: No.MOD-8B0165 08/11/18 By Sarah 中長期貸款資料(anmt720)印不出來
# Modify.........: No.TQC-8B0039 08/12/02 By Sarah 中長期沒計算到重評價匯率、重估本幣餘額、匯兌收益、匯兌損失四個值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.TQC-A40115 10/04/26 By Carrier sql缺少条件
# Modify.........: No:MOD-A60049 10/07/28 By sabrina 短期融資之餘額計算應同中長期融資一樣
# Modify.........: No:MOD-B30659 11/03/24 By Dido 取位調整
# Modify.........: No:MOD-B80183 11/08/22 By Polly 調整原幣餘額計算
# Modify.........: No:MOD-C60073 12/06/08 By Polly 調整原幣未還金額抓取
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc      LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(600) # Where Condiction #TQC-5A0134 VARCHAR-->CHAR
              edate   LIKE type_file.dat,        #No.FUN-680107 DATE
              rate_op LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1) #FUN-550015
              more    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1) #TQC-5A0134 VARCHAR-->CHAR
              END RECORD,
          g_day       LIKE type_file.num5,       #No.FUN-680107 SMALLINT
          g_day01     LIKE type_file.num5,       #No.FUN-680107 SMALLINT
          g_day02     LIKE type_file.num5       #No.FUN-680107 SMALLINT
    DEFINE yymm       LIKE azj_file.azj02        #No.FUN-680107 VARCHAR(6) #TQC-5A0134 VARCHAR-->CHAR
    DEFINE g_i        LIKE type_file.num5        #No.FUN-680107 SMALLINT
    DEFINE g_sql      STRING                     #NO.FUN-7B0026
    DEFINE g_str      STRING                     #NO.FUN-7B0026
    DEFINE l_table    STRING                     #NO.FUN-7B0026
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN              # Main program start up process
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
   LET g_sql = "nne02.nne_file.nne02,   nne01.nne_file.nne01,",
               "nne04.nne_file.nne04,   nne06.nne_file.nne06,",
               "nne112.nne_file.nne112, nne12.nne_file.nne12,",
               "nne14.nne_file.nne14,   nne15.nne_file.nne15,",
               "nne16.nne_file.nne16,   nne19.nne_file.nne19,",
               "nne20.nne_file.nne20,   nne22.nne_file.nne22,",
               "nne27.nne_file.nne27,   nnn02.nnn_file.nnn02,",
               "nnn03.nnn_file.nnn03,   alg01.alg_file.alg01,",
               "alg02.alg_file.alg02,   t_alg01.alg_file.alg01,",
               "t_alg02.alg_file.alg02, day01.type_file.dat,",
               "day02.type_file.num5,   int01.type_file.num20_6,",
               "int02.type_file.num20_6,azj05.azj_file.azj05,",
               "amt_y.type_file.num20_6,amt_b.type_file.num20_6,",
               "amt_c.type_file.num20_6,azi04.azi_file.azi04,",
               "azi07.azi_file.azi07,   azi05.azi_file.azi05"    #No:FUN-870151 #MOD-B30659 add azi05
   LET l_table = cl_prt_temptable('anmr770',g_sql) CLIPPED
   IF  l_table =-1 THEN EXIT PROGRAM END IF
   LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?)" #No:FUN-870151 Add ? #MOD-B30659 Add ? 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   LET g_trace = 'N'                            # default trace off
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.edate = ARG_VAL(8)   #TQC-610058
   LET tm.rate_op = ARG_VAL(9)   #TQC-610058
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
 
   IF cl_null(tm.wc) THEN
      CALL anmr770_tm(0,0)
   ELSE 
      CALL anmr770()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr770_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd         LIKE type_file.chr1000,#TQC-5A0134 VARCHAR-->CHAR #No.FUN-680107 VARCHAR(400)
       l_jmp_flag    LIKE type_file.chr1    #TQC-5A0134 VARCHAR-->CHAR #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 25
   OPEN WINDOW anmr770_w AT p_row,p_col
        WITH FORM "anm/42f/anmr770" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_locale("anmr770")
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET tm.edate= g_today
   LET tm.rate_op = 'S'   #FUN-550015
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON
         nne01, nne02, nne03, nne06
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
     ON ACTION locale
         CALL cl_dynamic_locale()
 
     ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr770_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
 
 
 
INPUT BY NAME tm.edate,tm.rate_op,tm.more WITHOUT DEFAULTS    #FUN-550015
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD edate
         IF NOT cl_null(tm.edate) THEN
            LET yymm=tm.edate USING 'yyyymmdd'    #031217 DSC.Anny
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
     ON ACTION locale
         CALL cl_dynamic_locale()
 
     ON IDLE g_idle_seconds
           CALL cl_on_idle()
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr770_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr770'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr770','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc,"'","\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",   #TQC-610058
                         " '",tm.rate_op CLIPPED,"'",   #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('anmr770',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr770_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr770()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr770_w
END FUNCTION
 
FUNCTION anmr770()
   DEFINE l_name        LIKE type_file.chr20,     #TQC-5A0134 VARCHAR-->CHAR # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
          l_sql         LIKE type_file.chr1000,   # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05        LIKE type_file.chr1000,   #TQC-5A0134 VARCHAR-->CHAR  #標題內容 #No.FUN-680107 VARCHAR(40)
          l_day         LIKE type_file.num5,      #No.FUN-680107 SMALLINT  #計算每月日數
          l_buf         STRING, #MOD-740213
          l_alg011      LIKE type_file.chr3,      #No.FUN-680107 VARCHAR(3) #TQC-5A0134 VARCHAR-->CHAR #因alg01為012-5804
          l_alg012      LIKE type_file.chr4,      #No.FUN-680107 VARCHAR(4) #TQC-5A0134 VARCHAR-->CHAR #而nnf05為0125804-01
          l_i           LIKE type_file.num5,      #No.FUN-680107 SMALLINT
          l_ramt        LIKE nne_file.nne20,
          sr            RECORD
                        nne02   LIKE  nne_file.nne02 ,  #申請日期
                        nne01   LIKE  nne_file.nne01 ,  #融資單號
                        nne04   LIKE  nne_file.nne04 ,  #信貸銀行編號
                        nne06   LIKE  nne_file.nne06 ,  #融資種類
                        nne112  LIKE  nne_file.nne112 , #融資到期日
                        nne12   LIKE  nne_file.nne12 ,  #借款原幣
                        nne14   LIKE  nne_file.nne14 ,  #還款利率
                        nne15   LIKE  nne_file.nne15 ,  #LC NO
                        nne16   LIKE  nne_file.nne16 ,  #幣別
                        nne19   LIKE  nne_file.nne19 ,  #本幣融資金額
                        nne20   LIKE  nne_file.nne20 ,  #本幣已還餘額
                        nne22   LIKE  nne_file.nne22 ,  #還息日
                        nne27   LIKE  nne_file.nne27 ,  #原幣已還餘額
                        nnn02   LIKE  nnn_file.nnn02 ,  #授信類別名稱
                        nnn03   LIKE  nnn_file.nnn03 ,  #記息方式
                        alg01   LIKE  alg_file.alg01 ,  #銀行代號
                        alg02   LIKE  alg_file.alg02 ,  #銀行名稱
                      t_alg01   LIKE  alg_file.alg01 ,  #擔當銀行代號
                      t_alg02   LIKE  alg_file.alg02 ,  #擔當銀行名稱
                        day01   LIKE type_file.dat,     #No.FUN-680107 DATE      #應息始日
                        day02   LIKE type_file.num5,    #No.FUN-680107 SMALLINT  #應息日數
                        int01   LIKE type_file.num20_6, #No.FUN-680107 DEC(20,6) #應付利息 #--MOD-560008
                        int02   LIKE type_file.num20_6, #No.FUN-680107 DEC(20,6) #每月利息
                        azj05   LIKE azj_file.azj05,    #月匯率  #031217
                        amt_y   LIKE type_file.num20_6, #No.FUN-680107 DEC(20,6) #重估本幣餘額#031217
                        amt_b   LIKE type_file.num20_6, #No.FUN-680107 DEC(20,6) #匯兌收益 #031217
                        amt_c   LIKE type_file.num20_6  #No.FUN-680107 DEC(20,6) #匯兌損失  #031217  #--END MOD-560008
                 END RECORD
DEFINE l_nmd26_tot       LIKE nmd_file.nmd26
DEFINE l_nmd26_tot1      LIKE nmd_file.nmd26
DEFINE l_nmd04_tot       LIKE nmd_file.nmd04
DEFINE l_nmd04_tot1      LIKE nmd_file.nmd04
DEFINE l_nnl13_tot       LIKE nnl_file.nnl13            #No.MOD-B80183 add
DEFINE l_nnl14_tot       LIKE nnl_file.nnl14
DEFINE l_nnl12_tot       LIKE nnl_file.nnl12
 
   CALL cl_del_data(l_table)                           #NO.FUN-7B0026
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='anmr770'  #NO.FUN-7B0026
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET g_len=158
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nneuser', 'nnegrup')
 
   LET l_sql =
             #MOD-A60049---modify---start---
             #" SELECT nne111,nne01,nne04,nne06,nne112,(nne12-nne27),nne14,nne15,",
             #"nne16,(nne19-nne20),nne20,nne22,nne27,'','','','','','','','','','',",
              " SELECT nne111,nne01,nne04,nne06,nne112,nne12,nne14,nne15,",
              "nne16,nne19,nne20,nne22,nne27,'','','','','','','','','','',",
             #MOD-A60049---modify---end---
              "0,0,0,0",   #FUN-550015
              "   FROM nne_file LEFT OUTER JOIN azj_file ",
              "   ON nne16 = azj01  ",
              "   AND azj02 = '",yymm,"'", 
              "   WHERE ", tm.wc CLIPPED,
              "    AND nneconf!='X'",                               #No.TQC-A40115
              "    AND (nne26 IS NULL OR nne26 > '",tm.edate,"')",  #No.TQC-A40115
              "   AND nne111 <= '",tm.edate,"'"
   IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
   LET l_sql = l_sql CLIPPED, " ORDER BY nne112 "  # Jason 020619
   PREPARE anmr770_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM 
   END IF
   DECLARE anmr770_curs1 CURSOR FOR anmr770_prepare1
 
   FOREACH anmr770_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF sr.nne16=g_aza.aza17 THEN   #031217 DSC.Anny 資料限取非本幣者
         CONTINUE FOREACH
      END IF
 
      #預防取出null
      CALL s_curr3(sr.nne16,tm.edate,tm.rate_op) RETURNING sr.azj05   #FUN-550015
      IF cl_null(sr.azj05) THEN
         LET sr.azj05=0
      END IF
 
    #-------------------------------No.MOD-B80183--move----------------------start
     ##取重估本幣餘額       #031217 DSC.Anny
     #LET sr.amt_y=sr.azj05*sr.nne12
     #LET sr.amt_y = cl_digcut(sr.amt_y,g_azi04)   #MOD-B30659
     #LET sr.nne19 = cl_digcut(sr.nne19,g_azi04)   #MOD-B30659
     #IF cl_null(sr.amt_y) THEN LET sr.amt_y=0 END IF
     ##取匯兌收益           #031217 DSC.Anny
     #IF sr.amt_y-sr.nne19 > 0 THEN
     #   LET sr.amt_b=0
     #   LET sr.amt_c=sr.amt_y-sr.nne19
     #ELSE
     #   LET sr.amt_b=sr.amt_y-sr.nne19
     #   LET sr.amt_c=0
     #END IF
     #IF cl_null(sr.amt_b) THEN LET sr.amt_b=0 END IF
     #IF cl_null(sr.amt_c) THEN LET sr.amt_c=0 END IF
     #LET sr.amt_b = cl_digcut(sr.amt_b,g_azi04)   #MOD-B30659
     #LET sr.amt_c = cl_digcut(sr.amt_c,g_azi04)   #MOD-B30659
     #LET sr.day01 = MDY( month(tm.edate), sr.nne22, year(tm.edate))
     #LET sr.day02 = tm.edate - sr.day01
     #LET sr.int01 = sr.nne19 * sr.nne14 /365 * sr.day02 /100
     #IF sr.int01 IS NULL THEN LET sr.int01 = 0 END IF
 
     ####計算每月日數
     #LET g_day01 = MONTH(tm.edate)
     #IF g_day01 = 12 THEN LET g_day01 = 0 END IF  ###12月的下個月是1月
 
     #LET g_day = MDY(g_day01 + 1,1,YEAR(tm.edate)) -
     #            MDY(g_day01,1,YEAR(tm.edate))
     #LET sr.int02 = sr.nne19 * sr.nne14 /365 * g_day /100
     #IF sr.int02 IS NULL THEN LET sr.int02 = 0 END IF
    #-------------------------No.MOD-B80183------move-----------------------------end 
      SELECT alg01,alg02 INTO sr.alg01,sr.alg02 FROM alg_file
       WHERE alg01 = sr.nne04
      SELECT nnn02,nnn03 INTO sr.nnn02,sr.nnn03 FROM nnn_file
       WHERE nnn01 = sr.nne06
      IF sr.nnn03 IS NULL THEN LET sr.nnn03 = ' ' END IF   #TQC-8B0039
      IF sr.nnn03 = '2' THEN
         EXIT FOREACH
      ELSE
         SELECT azi04,azi07,azi05 INTO t_azi04,t_azi07,t_azi05   #No:FUN-870151  #MOD-B30659 add azi05 
           FROM azi_file
          WHERE azi01=sr.nne16
      END IF
     #MOD-A60049---add---start---
      LET l_nnl12_tot = NULL
     #LET l_nnl14_tot = NULL                   #No.MOD-B80183 mark
      LET l_nnl13_tot = NULL                   #No.MOD-B80183 add
     #SELECT SUM(nnl12),SUM(nnl14) INTO l_nnl12_tot,l_nnl14_tot       #No.MOD-B80183 mark
     #SELECT SUM(nnl12),SUM(nnl13) INTO l_nnl12_tot,l_nnl13_tot       #No.MOD-B80183 add #MOD-C60073 mark
      SELECT SUM(nnl11),SUM(nnl13)                                    #MOD-C60073 add
        INTO l_nnl12_tot,l_nnl13_tot                                  #MOD-C60073 add
       FROM nnl_file,nnk_file
      WHERE nnl01=nnk01  AND nnl04 = sr.nne01 AND nnk02 <=tm.edate 
        AND nnkconf= 'Y' # Jason 020807
 
      LET l_nmd04_tot = NULL
      LET l_nmd26_tot = NULL
      SELECT SUM(nmd04),SUM(nmd26) INTO l_nmd04_tot,l_nmd26_tot
        FROM nmd_file
       WHERE nmd10 = sr.nne01 AND nmd05  <= tm.edate AND nmd12 ='8'

                        # 支票不可當作已還啦
      LET l_nmd04_tot1 = NULL
      LET l_nmd26_tot1 = NULL
      SELECT SUM(nmd04),SUM(nmd26) INTO l_nmd04_tot1,l_nmd26_tot1
        FROM nmd_file,nnf_file
       WHERE nmd10 = sr.nne01 AND nmd05  <= tm.edate AND nmd12 ='8'
         AND nnf06 = nmd01 AND nnf08 = '1'

     #IF cl_null(l_nnl14_tot) THEN LET l_nnl14_tot = 0 END IF         #No.MOD-B80183 mark
      IF cl_null(l_nnl13_tot) THEN LET l_nnl13_tot = 0 END IF         #No.MOD-B80183 add
      IF cl_null(l_nmd26_tot) THEN LET l_nmd26_tot = 0 END IF
      IF cl_null(l_nmd26_tot1) THEN LET l_nmd26_tot1 = 0 END IF
      IF cl_null(l_nnl12_tot) THEN LET l_nnl12_tot = 0 END IF
      IF cl_null(l_nmd04_tot) THEN LET l_nmd04_tot = 0 END IF
      IF cl_null(l_nmd04_tot1) THEN LET l_nmd04_tot1 = 0 END IF
     #LET sr.nne20 = l_nnl14_tot + l_nmd26_tot - l_nmd26_tot1         #No.MOD-B80183 mark
      LET sr.nne20 = l_nnl13_tot + l_nmd26_tot - l_nmd26_tot1         #No.MOD-B80183 add
      LET sr.nne27 = l_nnl12_tot + l_nmd04_tot - l_nmd04_tot1
      LET sr.nne12 = sr.nne12 - sr.nne27
      LET sr.nne19 = sr.nne19 - sr.nne20
     #MOD-A60049---add---end---
     #-----------------------No.MOD-B80183--------------------------move start
      #取重估本幣餘額       #031217 DSC.Anny
      LET sr.amt_y=sr.azj05*sr.nne12
      LET sr.amt_y = cl_digcut(sr.amt_y,g_azi04)   #MOD-B30659
      LET sr.nne19 = cl_digcut(sr.nne19,g_azi04)   #MOD-B30659
      IF cl_null(sr.amt_y) THEN LET sr.amt_y=0 END IF
      #取匯兌收益           #031217 DSC.Anny
      IF sr.amt_y-sr.nne19 > 0 THEN
         LET sr.amt_b=0
         LET sr.amt_c=sr.amt_y-sr.nne19
      ELSE
         LET sr.amt_b=sr.amt_y-sr.nne19
         LET sr.amt_c=0
      END IF
      IF cl_null(sr.amt_b) THEN LET sr.amt_b=0 END IF
      IF cl_null(sr.amt_c) THEN LET sr.amt_c=0 END IF
      LET sr.amt_b = cl_digcut(sr.amt_b,g_azi04)   #MOD-B30659
      LET sr.amt_c = cl_digcut(sr.amt_c,g_azi04)   #MOD-B30659
      LET sr.day01 = MDY( month(tm.edate), sr.nne22, year(tm.edate))
      LET sr.day02 = tm.edate - sr.day01
      LET sr.int01 = sr.nne19 * sr.nne14 /365 * sr.day02 /100
      IF sr.int01 IS NULL THEN LET sr.int01 = 0 END IF
 
      ###計算每月日數
      LET g_day01 = MONTH(tm.edate)
      IF g_day01 = 12 THEN LET g_day01 = 0 END IF  ###12月的下個月是1月
 
      LET g_day = MDY(g_day01 + 1,1,YEAR(tm.edate)) -
                  MDY(g_day01,1,YEAR(tm.edate))
      LET sr.int02 = sr.nne19 * sr.nne14 /365 * g_day /100
      IF sr.int02 IS NULL THEN LET sr.int02 = 0 END IF
     #------------------------No.MOD-B80183-------------------------move end 
      IF sr.nne12 IS NULL THEN LET sr.nne12 = 0 END IF   #TQC-8B0039 add
      IF sr.nne14 IS NULL THEN LET sr.nne14 = 0 END IF
      IF sr.nne19 IS NULL THEN LET sr.nne19 = 0 END IF
 
      #擔當行庫
      LET l_alg011 = ''
      LET l_alg012 = ''
      SELECT nnf05 INTO sr.t_alg01 FROM nnf_file
       WHERE nnf01 = sr.nne01 and nnf02=1
      LET l_alg011 = sr.t_alg01[1,3]
      LET l_alg012 = sr.t_alg01[4,7]
      SELECT alg02 INTO sr.t_alg02 FROM alg_file
       WHERE alg01[1,3]=l_alg011  and alg01[5,8]=l_alg012
 
 
      EXECUTE insert_prep USING
         sr.nne02,sr.nne01,sr.nne04,sr.nne06,sr.nne112,sr.nne12,sr.nne14,
         sr.nne15,sr.nne16,sr.nne19,sr.nne20,sr.nne22,sr.nne27,sr.nnn02,
         sr.nnn03,sr.alg01,sr.alg02,sr.t_alg01,sr.t_alg02,sr.day01,
         sr.day02,sr.int01,sr.int02,sr.azj05,sr.amt_y,sr.amt_b,
         sr.amt_c,t_azi04
         ,t_azi07,t_azi05   #No:FUN-870151 #MOD-B30659 add azi05
   END FOREACH
#---新增...
   LET l_buf = tm.wc
   LET l_buf=cl_replace_str(l_buf,'nne01','nng01')
   LET l_buf=cl_replace_str(l_buf,'nne02','nng02')
   LET l_buf=cl_replace_str(l_buf,'nne03','nng03')
   LET l_buf=cl_replace_str(l_buf,'nne24','nng24')
   LET l_sql = "SELECT DISTINCT",
               " nng081,nng01, nng04, nng24, nng082, nng20, nng53, '', ",
               " nng18, nng22,0,nng13,0, '','', alg01, alg02, '', '', '',",
               " '','','' ",
" FROM nng_file LEFT OUTER JOIN nnl_file LEFT OUTER JOIN nnk_file ",   
"   ON nnk01 = nnl01 AND nnk02 <= '",tm.edate,"' AND nnkconf = 'Y' ON nng01 = nnl04 ",
" LEFT OUTER JOIN alg_file ON alg01 = nng04  ",   
" WHERE ",l_buf CLIPPED ,    
" AND nng081 <= '",tm.edate,"'"
 
   IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
   PREPARE anmr770_prepare2 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM 
   END IF
   DECLARE anmr770_curs2 CURSOR FOR anmr770_prepare2
   FOREACH anmr770_curs2 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF sr.nne16=g_aza.aza17 THEN   #031217 DSC.Anny 資料限取非本幣者
         CONTINUE FOREACH
      END IF
 
      #預防取出null
      CALL s_curr3(sr.nne16,tm.edate,tm.rate_op) RETURNING sr.azj05   #FUN-550015
      IF cl_null(sr.azj05) THEN
         LET sr.azj05=0
      END IF
 
      #取重估本幣餘額       #031217 DSC.Anny
      LET sr.amt_y=sr.azj05*sr.nne12
      LET sr.amt_y = cl_digcut(sr.amt_y,g_azi04)   #MOD-B30659
      LET sr.nne19 = cl_digcut(sr.nne19,g_azi04)   #MOD-B30659
      IF cl_null(sr.amt_y) THEN LET sr.amt_y=0 END IF
      #取匯兌收益           #031217 DSC.Anny
      IF sr.amt_y-sr.nne19 > 0 THEN
         LET sr.amt_b=0
         LET sr.amt_c=sr.amt_y-sr.nne19
      ELSE
         LET sr.amt_b=sr.amt_y-sr.nne19
         LET sr.amt_c=0
      END IF
      IF cl_null(sr.amt_b) THEN LET sr.amt_b=0 END IF
      IF cl_null(sr.amt_c) THEN LET sr.amt_c=0 END IF
      LET sr.amt_b = cl_digcut(sr.amt_b,g_azi04)   #MOD-B30659
      LET sr.amt_c = cl_digcut(sr.amt_c,g_azi04)   #MOD-B30659
 
      LET sr.day01 = MDY( month(tm.edate), sr.nne22, year(tm.edate))
      LET sr.day02 = tm.edate - sr.day01
      LET sr.int01 = sr.nne19 * sr.nne14 /365 * sr.day02 /100
      IF sr.int01 IS NULL THEN LET sr.int01 = 0 END IF
 
      ###計算每月日數
      LET g_day01 = MONTH(tm.edate)
      IF g_day01 = 12 THEN LET g_day01 = 0 END IF  ###12月的下個月是1月
 
      LET g_day = MDY(g_day01 + 1,1,YEAR(tm.edate)) -
                  MDY(g_day01,1,YEAR(tm.edate))
      LET sr.int02 = sr.nne19 * sr.nne14 /365 * g_day /100
      IF sr.int02 IS NULL THEN LET sr.int02 = 0 END IF
 
      SELECT nnn02,nnn03 INTO sr.nnn02,sr.nnn03 FROM nnn_file
       WHERE nnn01 = sr.nne06
      IF sr.nnn03 IS NULL THEN LET sr.nnn03 = ' ' END IF
      IF sr.nnn03 = '2' THEN
         EXIT FOREACH
      ELSE
         SELECT azi04,azi07,azi05 INTO t_azi04,t_azi07,t_azi05   #No:FUN-870151 #MOD-B30659 add azi05
           FROM azi_file
          WHERE azi01=sr.nne16
      END IF
 
      LET l_nnl12_tot = NULL    #MOD-A60049 add
      LET l_nnl14_tot = NULL    #MOD-A60049 add
     #SELECT SUM(nnl12),SUM(nnl14) INTO l_nnl12_tot,l_nnl14_tot   #MOD-C60073 mark
      SELECT SUM(nnl11),SUM(nnl14)                                #MOD-C60073 add
        INTO l_nnl12_tot,l_nnl14_tot                              #MOD-C60073 add
       FROM nnl_file,nnk_file
      WHERE nnl01=nnk01  AND nnl04 = sr.nne01 AND nnk02 <=tm.edate # Jason0806
        AND nnkconf= 'Y' # Jason 020807
 
      LET l_nmd04_tot = NULL   #MOD-A60049 add
      LET l_nmd26_tot = NULL   #MOD-A60049 add
      SELECT SUM(nmd04),SUM(nmd26) INTO l_nmd04_tot,l_nmd26_tot
        FROM nmd_file
       WHERE nmd10 = sr.nne01 AND nmd05  <= tm.edate AND nmd12 ='8'
 
                        # 支票不可當作已還啦
      LET l_nmd04_tot1 = NULL   #MOD-A60049 add
      LET l_nmd26_tot1 = NULL   #MOD-A60049 add
      SELECT SUM(nmd04),SUM(nmd26) INTO l_nmd04_tot1,l_nmd26_tot1
        FROM nmd_file,nnf_file
       WHERE nmd10 = sr.nne01 AND nmd05  <= tm.edate AND nmd12 ='8'
         AND nnf06 = nmd01 AND nnf08 = '1'
 
      IF cl_null(l_nnl14_tot) THEN LET l_nnl14_tot = 0 END IF
      IF cl_null(l_nmd26_tot) THEN LET l_nmd26_tot = 0 END IF
      IF cl_null(l_nmd26_tot1) THEN LET l_nmd26_tot1 = 0 END IF
      IF cl_null(l_nnl12_tot) THEN LET l_nnl12_tot = 0 END IF
      IF cl_null(l_nmd04_tot) THEN LET l_nmd04_tot = 0 END IF
      IF cl_null(l_nmd04_tot1) THEN LET l_nmd04_tot1 = 0 END IF
      LET sr.nne20 = l_nnl14_tot + l_nmd26_tot - l_nmd26_tot1
      LET sr.nne27 = l_nnl12_tot + l_nmd04_tot - l_nmd04_tot1
      LET sr.nne12 = sr.nne12 - sr.nne27
      LET sr.nne19 = sr.nne19 - sr.nne20
 
      IF sr.nne12 IS NULL THEN LET sr.nne12 = 0 END IF
      IF sr.nne14 IS NULL THEN LET sr.nne14 = 0 END IF
      IF sr.nne19 IS NULL THEN LET sr.nne19 = 0 END IF
 
 
     # 擔當行庫
      LET l_alg011 = ''
      LET l_alg012 = ''
      SELECT nnf05 INTO sr.t_alg01 FROM nnf_file
       WHERE nnf01 = sr.nne01 AND nnf02=1
      LET l_alg011 = sr.t_alg01[1,3]
      LET l_alg012 = sr.t_alg01[4,7]
      SELECT alg02 INTO sr.t_alg02 FROM alg_file
       WHERE alg01[1,3]=l_alg011 AND alg01[5,8]=l_alg012
 
 
      EXECUTE insert_prep USING
         sr.nne02,sr.nne01,sr.nne04,sr.nne06,sr.nne112,sr.nne12,sr.nne14,
         sr.nne15,sr.nne16,sr.nne19,sr.nne20,sr.nne22,sr.nne27,sr.nnn02,
         sr.nnn03,sr.alg01,sr.alg02,sr.t_alg01,sr.t_alg02,sr.day01,
         sr.day02,sr.int01,sr.int02,sr.azj05,sr.amt_y,sr.amt_b,
         sr.amt_c,t_azi04
         ,t_azi07,t_azi05   #No:FUN-870151 #MOD-B30659
   END FOREACH
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF g_zz05 ='Y' THEN 
      CALL cl_wcchp(tm.wc,'nne01,nne02,nne03,nne06')
           RETURNING tm.wc
   END IF 
  #LET  g_str=tm.wc,";",tm.edate,";",tm.rate_op            #MOD-B30659 mark
   LET  g_str=tm.wc,";",tm.edate,";",g_azi04,";",g_azi05   #MOD-B30659
   CALL cl_prt_cs3('anmr770','anmr770',g_sql,g_str)
#--新增
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/15
