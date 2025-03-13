# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Pattern name...: asfr102.4gl
# Descriptions...: 工單資料列印
# Date & Author..: 92/08/14 By Nora
# Modify.........:(NO:6882, (g_argv1,g_argv2先mark無用到),g5掃過只有asfi301 串此支程式)
# Modify.........: No.7967 03/09/01 Carol 若工單有輸入備註資料時，工單列印時應一併列印出來
#                                         --> per add 選項列印
# Modify.........: No.MOD-4A0203 04/10/14 By Smapmin 將ima02全部印出來
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-530401 05/04/04 By Carol 1.列印嘜頭有 PPPPPP的字樣轉成客戶訂單號
#                                                  2.QBE料號欄位增加 Ctrl+P
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-580068 05/08/12 By Claire RETURN ss => RETURN g_count,原判斷 ss=2  => g_count=0
# Modify.........: No.MOD-580275 05/09/13 By Nicola l_dept 改為like pmc_file.pmc03
# Modify.........: No.FUN-5A0140 05/10/21 By Claire 修改報表格式
# Modify.........: No.MOD-5B0296 05/11/30 By Claire 當產品BOM階數大于2，並且發料時3階以上（3階、4階）料件發生取替代時,不被印出
# Modify.........: No.MOD-620075 06/02/24 By Claire 備料清單超過一頁時, 前頁末筆部份資料會產生在次頁表頭,而非清單明細
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-670066 06/07/24 By xiake voucher型報表轉template1型
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0090 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6A0090 06/11/06 By douzh l_time轉g_time
# Modify.........: No.MOD-6B0100 06/11/20 By Claire sfb93加入判斷再印g_x[57]
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-710070 07/03/28 By atsea 單身抬頭錯誤修改
# Modify.........: No.TQC-740275 07/04/25 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.FUN-750047 07/05/15 By Sarah 畫面新增選項"列印工單Barcode"
# Modify.........: No.FUN-670104 08/10/06 By jan 改r102_p2,s_momo1_c,r102_memo1_c  CURSOR
# Modify.........: No.FUN-940008 09/05/09 By hongmei 發料改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A60097 10/05/27 By Carrier MOD-960330追单
# Modify.........: No.FUN-A60027 10/06/09 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-A60129 10/06/21 By Sarah Temptable增加sfa27
# Modify.........: No.TQC-A60097 10/06/22 By liuxqa TQC-A60097拆单过来，不做修改，过单用
# Modify.........: No.FUN-A80150 10/09/14 By sabrina 新增計畫批號(sfb919)
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-940042 11/11/04 By minpp 整合單據列印EF簽核
# Modify.........: No:TQC-BA0010 11/11/11 By lilingyu 過單
# Modify.........: No.FUN-B50095 11/12/06 By jason 來源特性為'X'時(資訊參考),應發數量以sfa16*數量計算
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C10039 12/01/12 By wangrr 整合單據列印EF簽核
# Modify.........: No.MOD-CA0097 13/03/07 By Alberti asfi301應發數量有依gfe03取位,報表請比照處理

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD         #TQC-BA0010
            wc     STRING,                 #No.TQC-630166 VARCHAR(600) #Where condition
            a      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)# 是否列印備料資料
            b      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)# 是否列印製程資料
            c      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)# 是否列印訂單memo
            d      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)# 是否列印訂單嘜頭
            e      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)# 是否列印工單嘜頭    #No:7967 add
            f      LIKE type_file.chr1,    #No.FUN-750047 add    # 是否列印工單Barcode
            more   LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
           END RECORD
     # g_argv1     LIKE sfb_file.sfb01,    # 工單編號
     # g_argv2     LIKE sfb_file.sfb05,    # 料件編號
DEFINE g_count     LIKE type_file.num5     #No.FUN-680121 SMALLINT
DEFINE g_i         LIKE type_file.num5     #No.FUN-680121 SMALLINT #count/index for any purpose
DEFINE g_msg       LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE g_po_no     LIKE oea_file.oea10     #No.MOD-530401
DEFINE g_ctn_no1,g_ctn_no2   LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20) #MOD-530401
#No.FUN-710082--begin
DEFINE g_sql       STRING                                                       
DEFINE l_table     STRING                                                       
DEFINE l_str       STRING   
#No.FUN-710082--end  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   LET tm.e  = ARG_VAL(12)
   LET tm.f  = ARG_VAL(13)   #FUN-750047 add
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047
 
   display "g_pdate  =",g_pdate
   display "g_towhom =",g_towhom
   display "g_rlang  =",g_rlang
   display "g_bgjob  =",g_bgjob
   display "g_prtway =",g_prtway
   display "g_copies =",g_copies
   display "tm.wc    =",tm.wc
   display "tm.a     =",tm.a
   display "tm.b     =",tm.b
   display "tm.c     =",tm.c
   display "tm.d     =",tm.d
   display "tm.e     =",tm.e
   display "tm.f     =",tm.f
 # LET g_argv1 = ARG_VAL(10) #NO:6882
 # LET g_argv2 = ARG_VAL(11) #NO:6882
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
 
   #No.FUN-710082--begin     
   LET g_sql ="sfb01.sfb_file.sfb01,sfb02.sfb_file.sfb02,",
              "sfb04.sfb_file.sfb04,sfb39.sfb_file.sfb39,",
              "sfb22.sfb_file.sfb22,sfb221.sfb_file.sfb221,",
              "sfb82.sfb_file.sfb82,gem02.gem_file.gem02,",
              "sfb919.sfb_file.sfb919,",      #FUN-A80150 add
              "sfb05.sfb_file.sfb05,ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,sfb071.sfb_file.sfb071,",
              "sfb08.sfb_file.sfb08,sfb09.sfb_file.sfb09,",
              "sfb11.sfb_file.sfb11,sfb40.sfb_file.sfb40,",
              "sfb34.sfb_file.sfb34,sfb28.sfb_file.sfb28,",
              "sfb41.sfb_file.sfb41,sfb06.sfb_file.sfb06,",
              "sfb27.sfb_file.sfb27,sfb07.sfb_file.sfb07,",
              "sfb38.sfb_file.sfb38,sfb42.sfb_file.sfb42,",
              "sfb87.sfb_file.sfb87,sfb13.sfb_file.sfb13,",
              "sfb15.sfb_file.sfb15,sfb25.sfb_file.sfb25,",
              "sfb251.sfb_file.sfb251,sfb88.sfb_file.sfb88,",
              "ima08.ima_file.ima08,ima55.ima_file.ima55,",
              "sfa03.sfa_file.sfa03,sfa05.sfa_file.sfa05,",
              "sfa06.sfa_file.sfa06,sfa062.sfa_file.sfa062,",
              "sfa063.sfa_file.sfa063,sfa07.sfa_file.sfa07,",
              "sfa08.sfa_file.sfa08,sfa09.sfa_file.sfa09,",
              "sfa11.sfa_file.sfa11,sfa12.sfa_file.sfa12,",
              "sfa25.sfa_file.sfa25,sfa26.sfa_file.sfa26,",
              "sfa27.sfa_file.sfa27,sfa29.sfa_file.sfa29,",  #MOD-A60129 add sfa27
              "sfa012.sfa_file.sfa012,sfa013.sfa_file.sfa013,",    #FUN-A60027 add
              "ima02_1.ima_file.ima02,eca04d.eca_file.eca04,",
              "ecb012.ecb_file.ecb012,ecb03.ecb_file.ecb03,",      #FUN-A60027 add ecb012
              "ecb06.ecb_file.ecb06,ecb08.ecb_file.ecb08,",
              "srtdt.sfb_file.sfb071,duedt.sfb_file.sfb071,",
              "esrtdt.sfb_file.sfb071,lsrtdt.sfb_file.sfb071,",
              "eduedt.sfb_file.sfb071,lduedt.sfb_file.sfb071,",
              "ocf01.ocf_file.ocf01,ocf02.ocf_file.ocf02,",
              "ocf101.ocf_file.ocf101,ocf102.ocf_file.ocf102,",
              "ocf103.ocf_file.ocf103,ocf104.ocf_file.ocf104,",
              "ocf105.ocf_file.ocf105,ocf106.ocf_file.ocf106,",
              "ocf107.ocf_file.ocf107,ocf108.ocf_file.ocf108,",
              "ocf109.ocf_file.ocf109,ocf110.ocf_file.ocf110,",
              "ocf111.ocf_file.ocf111,ocf112.ocf_file.ocf112,",
              "ocf201.ocf_file.ocf201,ocf202.ocf_file.ocf202,",
              "ocf203.ocf_file.ocf203,ocf204.ocf_file.ocf204,",
              "ocf205.ocf_file.ocf205,ocf206.ocf_file.ocf206,",
              "ocf207.ocf_file.ocf207,ocf208.ocf_file.ocf208,",
              "ocf209.ocf_file.ocf209,ocf210.ocf_file.ocf210,",
              "ocf211.ocf_file.ocf211,ocf212.ocf_file.ocf212,",
              "occ02.occ_file.occ02,sfw02.sfw_file.sfw02,",
              "sfw03.sfw_file.sfw03,oao03.oao_file.oao03,",
              "oao05.oao_file.oao05,oao06.oao_file.oao06,", 
              "gfe03.gfe_file.gfe03,",           #MOD-CA0097 
              "sfb02doc.type_file.chr30,",       #No:MOD-960330 add
              "sign_type.type_file.chr1,",       #簽核方式   #No.FUN-940042
              "sign_img.type_file.blob,",        #簽核圖檔   #No.FUN-940042
              "sign_show.type_file.chr1,",       #是否顯示簽核資料(Y/N) #No.FUN-940042
              "sign_str.type_file.chr1000"       #TQC-C10039 add sign_str

   LET l_table = cl_prt_temptable('asfr102',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) " #No.TQC-A60097 #FUN-A60027 add 3?#MOD-A60129 add ? #FUN-B940042 ADD 3?#TQC-C10039 add 1?  #MOD-CA0097 add ,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   #No.FUN-710082--end  
 
   #str TQC-740275 add
   DROP TABLE r102_tmp 
   CREATE TEMP TABLE r102_tmp(
      sfb01    LIKE sfb_file.sfb01,
      sfb02    LIKE sfb_file.sfb02,
      sfb04    LIKE sfb_file.sfb04,
      sfb39    LIKE sfb_file.sfb39,
      sfb22    LIKE sfb_file.sfb22,
      sfb221   LIKE sfb_file.sfb221,
      sfb82    LIKE sfb_file.sfb82,
      gem02    LIKE gem_file.gem02,
      sfb919   LIKE sfb_file.sfb919,   #FUN-A80150 add
      sfb05    LIKE sfb_file.sfb05,
      ima02    LIKE ima_file.ima02,
      ima021   LIKE ima_file.ima021,
      sfb071   LIKE sfb_file.sfb071,
      sfb08    LIKE sfb_file.sfb08,
      sfb09    LIKE sfb_file.sfb09,
      sfb11    LIKE sfb_file.sfb11,
      sfb40    LIKE sfb_file.sfb40,
      sfb34    LIKE sfb_file.sfb34,
      sfb28    LIKE sfb_file.sfb28,
      sfb41    LIKE sfb_file.sfb41,
      sfb06    LIKE sfb_file.sfb06,
      sfb27    LIKE sfb_file.sfb27,
      sfb07    LIKE sfb_file.sfb07,
      sfb38    LIKE sfb_file.sfb38,
      sfb42    LIKE sfb_file.sfb42,
      sfb87    LIKE sfb_file.sfb87,
      sfb13    LIKE sfb_file.sfb13,
      sfb15    LIKE sfb_file.sfb15,
      sfb25    LIKE sfb_file.sfb25,
      sfb251   LIKE sfb_file.sfb251,
      sfb88    LIKE sfb_file.sfb88,
      ima08    LIKE ima_file.ima08, 
      ima55    LIKE ima_file.ima55) 
 
   DROP TABLE r102_tmp1
   CREATE TEMP TABLE r102_tmp1(
      sfb01_1  LIKE sfb_file.sfb01,
      sfa03    LIKE sfa_file.sfa03,
      sfa05    LIKE sfa_file.sfa05,
      sfa06    LIKE sfa_file.sfa06,
      sfa062   LIKE sfa_file.sfa06,
      sfa063   LIKE sfa_file.sfa06,
      sfa07    LIKE sfa_file.sfa07,
      sfa08    LIKE sfa_file.sfa08,
      sfa09    LIKE sfa_file.sfa09,
      sfa11    LIKE sfa_file.sfa11,
      sfa12    LIKE sfa_file.sfa12,
      sfa16    LIKE sfa_file.sfa16,   #FUN-B50095
      sfa25    LIKE sfa_file.sfa25,
      sfa26    LIKE sfa_file.sfa26,
      sfa27    LIKE sfa_file.sfa27,     #MOD-A60129 add
      sfa29    LIKE sfa_file.sfa29,
      sfa012   LIKE sfa_file.sfa012,    #FUN-A60027
      sfa013   LIKE sfa_file.sfa013,    #FUN-A60027
      gfe03    LIKE gfe_file.gfe03,     #MOD-CA0097 add
      ima02_1  LIKE ima_file.ima02)
 
   DROP TABLE r102_tmp2
   CREATE TEMP TABLE r102_tmp2(
      sfb01_2  LIKE sfb_file.sfb01,
      eca04d   LIKE eca_file.eca04,
      ecb012   LIKE ecb_file.ecb012,                 #FUN-A60027
      ecb03    LIKE ecb_file.ecb03,
      ecb06    LIKE ecb_file.ecb06,
      ecb08    LIKE ecb_file.ecb08,
      srtdt    LIKE type_file.dat,
      duedt    LIKE type_file.dat,
      esrtdt   LIKE type_file.dat,
      lsrtdt   LIKE type_file.dat,
      eduedt   LIKE type_file.dat,
      lduedt   LIKE type_file.dat)
 
   DROP TABLE r102_tmp3
   CREATE TEMP TABLE r102_tmp3(
      sfb01_3  LIKE sfb_file.sfb01,
      ocf01    LIKE ocf_file.ocf01,
      ocf02    LIKE ocf_file.ocf02,
      ocf101   LIKE ocf_file.ocf101,
      ocf102   LIKE ocf_file.ocf102,
      ocf103   LIKE ocf_file.ocf103,
      ocf104   LIKE ocf_file.ocf104,
      ocf105   LIKE ocf_file.ocf105,
      ocf106   LIKE ocf_file.ocf106,
      ocf107   LIKE ocf_file.ocf107,
      ocf108   LIKE ocf_file.ocf108,
      ocf109   LIKE ocf_file.ocf109,
      ocf110   LIKE ocf_file.ocf110,
      ocf111   LIKE ocf_file.ocf111,
      ocf112   LIKE ocf_file.ocf112,
      ocf201   LIKE ocf_file.ocf201,
      ocf202   LIKE ocf_file.ocf202,
      ocf203   LIKE ocf_file.ocf203,
      ocf204   LIKE ocf_file.ocf204,
      ocf205   LIKE ocf_file.ocf205,
      ocf206   LIKE ocf_file.ocf206,
      ocf207   LIKE ocf_file.ocf207,
      ocf208   LIKE ocf_file.ocf208,
      ocf209   LIKE ocf_file.ocf209,
      ocf210   LIKE ocf_file.ocf210,
      ocf211   LIKE ocf_file.ocf211,
      ocf212   LIKE ocf_file.ocf212,
      occ02    LIKE occ_file.occ02)
 
   DROP TABLE r102_tmp4
   CREATE TEMP TABLE r102_tmp4(
      sfb01_4  LIKE sfb_file.sfb01,
      sfw02    LIKE sfw_file.sfw02,
      sfw03    LIKE sfw_file.sfw03)
 
   DROP TABLE r102_tmp5
   CREATE TEMP TABLE r102_tmp5(
      sfb01_5  LIKE sfb_file.sfb01,
      oao03    LIKE oao_file.oao03,
      oao05    LIKE oao_file.oao05,
      oao06    LIKE oao_file.oao06)
   #end TQC-740275 add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL asfr102_tm(0,0)        # Input print condition
   ELSE
      CALL asfr102()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr102_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
 
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW asfr102_w AT p_row,p_col WITH FORM "asf/42f/asfr102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition
  LET tm.a    = 'Y'
  LET tm.b='N'
  IF g_sma.sma54 = 'N' THEN
     LET tm.b = 'N'
  ELSE
     LET tm.b = 'Y'
  END IF
  LET tm.c    = 'N'
  LET tm.d    = 'N'
  LET tm.e    = 'Y'
  LET tm.f    = 'N'   #FUN-750047 add
  LET tm.more = 'N'
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb82
       #No.FUN-580031 --start--
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 ---end---
 
       ON ACTION CONTROLP        #FUN-4B0001
          IF INFIELD(sfb01) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.state    = "c"
             LET g_qryparam.form     = "q_sfb01"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO sfb01
             NEXT FIELD sfb01
          END IF
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
  
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
  
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
       EXIT WHILE
    END IF
 
    IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.more                  #FUN-750047 add tm.f
    INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.more WITHOUT DEFAULTS   #FUN-750047 add tm.f
       #No.FUN-580031 --start--
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
       #No.FUN-580031 ---end---
 
       AFTER FIELD a
          IF tm.a NOT MATCHES "[YN]" THEN
             NEXT FIELD a
          END IF
          LET l_dir = 'D'
 
       BEFORE FIELD b
          IF g_sma.sma54 = 'N' THEN
             IF l_dir = 'D' THEN
                LET l_dir = 'U'
                NEXT FIELD c
             ELSE
                NEXT FIELD a
             END IF
          END IF
 
       AFTER FIELD b
          IF tm.b NOT MATCHES "[YN]" THEN
             NEXT FIELD b
          END IF
 
       AFTER FIELD c
          IF tm.c NOT MATCHES "[YN]" THEN
             NEXT FIELD c
          END IF
 
       AFTER FIELD d
          IF tm.d NOT MATCHES "[YN]" THEN
             NEXT FIELD d
          END IF
 
       AFTER FIELD e
          IF tm.e NOT MATCHES "[YN]" THEN
             NEXT FIELD e
          END IF
 
       #str FUN-750047 add
       AFTER FIELD f   #是否列印工單Barcode
          IF tm.f NOT MATCHES "[YN]" THEN
             NEXT FIELD f 
          END IF
       #end FUN-750047 add
 
       AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
       EXIT WHILE
    END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='asfr102'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asfr102','9031',1)  
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
                          " '",tm.a CLIPPED,"'",
                          " '",tm.b CLIPPED,"'",
                          " '",tm.c CLIPPED,"'",
                          " '",tm.d CLIPPED,"'",
                          " '",tm.e CLIPPED,"'",
                          " '",tm.f CLIPPED,"'",                #FUN-750047 add
                       #   " '",g_argv1 CLIPPED,"'",
                       #   " '",g_argv2 CLIPPED,"'"
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('asfr102',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW asfr102_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL asfr102()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW asfr102_w
END FUNCTION
 
FUNCTION asfr102()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#         l_time    LIKE type_file.chr8               #No.FUN-6A0090
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
#         l_order   ARRAY[5] OF LIKE apm_file.apm08,  #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr        RECORD
                     sfb      RECORD LIKE sfb_file.*,
                     ima02    LIKE ima_file.ima02,    #品名規格
                     ima021   LIKE ima_file.ima021,   #品名規格
                     ima08    LIKE ima_file.ima08,    #來源碼
                     ima55    LIKE ima_file.ima55     #生產單位
                    END RECORD
#No.FUN-710082--begin
DEFINE    sr1       RECORD
                     sfa03    LIKE sfa_file.sfa03,    #料件編號
                     sfa05    LIKE sfa_file.sfa05,    #應發數量
                     sfa06    LIKE sfa_file.sfa06,    #已發數量
                     sfa062   LIKE sfa_file.sfa06,    #
                     sfa063   LIKE sfa_file.sfa06,    #
                     sfa07    LIKE sfa_file.sfa07,    #缺料數量
                     sfa08    LIKE sfa_file.sfa08,    #作業編號
                     sfa09    LIKE sfa_file.sfa09,    #前置時間調整
                     sfa11    LIKE sfa_file.sfa11,    #旗標
                     sfa12    LIKE sfa_file.sfa12,    #發料單位
                     sfa16    LIKE sfa_file.sfa16,    #標準QPA #FUN-B50095
                     sfa25    LIKE sfa_file.sfa25,    #未備料量
                     sfa26    LIKE sfa_file.sfa26,    #來源
                     sfa27    LIKE sfa_file.sfa27,    #被替代料號   #MOD-A60129 add
                     sfa29    LIKE sfa_file.sfa29,    #上階料號
                     sfa012   LIKE sfa_file.sfa012,   #製程段號
                     sfa013   LIKE sfa_file.sfa013    #製程段號 
                    END RECORD,
          sr2       RECORD
                     ecm03    LIKE ecm_file.ecm03,    #作業序號
                     ecm06    LIKE ecm_file.ecm06,    #工作站
                     ecm11    LIKE ecm_file.ecm11,    #製程編號
                     eca04    LIKE eca_file.eca04     #工作站型態
                    END RECORD,
          sr3       RECORD
                     ocf      RECORD LIKE ocf_file.*     #NO:6882
                    END RECORD,
          sr4       RECORD
                     oao03      LIKE oao_file.oao03,   #NO:6882
                     oao05      LIKE oao_file.oao05,
                     oao06      LIKE oao_file.oao06
                    END RECORD
   DEFINE cr        RECORD                        #TQC-740275 add
                     sfb01    LIKE sfb_file.sfb01,
                     sfb02    LIKE sfb_file.sfb02,
                     sfb04    LIKE sfb_file.sfb04,
                     sfb39    LIKE sfb_file.sfb39,
                     sfb22    LIKE sfb_file.sfb22,
                     sfb221   LIKE sfb_file.sfb221,
                     sfb82    LIKE sfb_file.sfb82,
                     gem02    LIKE gem_file.gem02,
                     sfb919   LIKE sfb_file.sfb919,   #FUN-A80150 add
                     sfb05    LIKE sfb_file.sfb05,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,
                     sfb071   LIKE sfb_file.sfb071,
                     sfb08    LIKE sfb_file.sfb08,
                     sfb09    LIKE sfb_file.sfb09,
                     sfb11    LIKE sfb_file.sfb11,
                     sfb40    LIKE sfb_file.sfb40,
                     sfb34    LIKE sfb_file.sfb34,
                     sfb28    LIKE sfb_file.sfb28,
                     sfb41    LIKE sfb_file.sfb41,
                     sfb06    LIKE sfb_file.sfb06,
                     sfb27    LIKE sfb_file.sfb27,
                     sfb07    LIKE sfb_file.sfb07,
                     sfb38    LIKE sfb_file.sfb38,
                     sfb42    LIKE sfb_file.sfb42,
                     sfb87    LIKE sfb_file.sfb87,
                     sfb13    LIKE sfb_file.sfb13,
                     sfb15    LIKE sfb_file.sfb15,
                     sfb25    LIKE sfb_file.sfb25,
                     sfb251   LIKE sfb_file.sfb251,
                     sfb88    LIKE sfb_file.sfb88,
                     ima08    LIKE ima_file.ima08, 
                     ima55    LIKE ima_file.ima55, 
                     sfa03    LIKE sfa_file.sfa03,
                     sfa05    LIKE sfa_file.sfa05,
                     sfa06    LIKE sfa_file.sfa06,
                     sfa062   LIKE sfa_file.sfa06,
                     sfa063   LIKE sfa_file.sfa06,
                     sfa07    LIKE sfa_file.sfa07,
                     sfa08    LIKE sfa_file.sfa08,
                     sfa09    LIKE sfa_file.sfa09,
                     sfa11    LIKE sfa_file.sfa11,
                     sfa12    LIKE sfa_file.sfa12,
                     sfa16    LIKE sfa_file.sfa16,   #FUN-B50095
                     sfa25    LIKE sfa_file.sfa25,
                     sfa26    LIKE sfa_file.sfa26,
                     sfa27    LIKE sfa_file.sfa27,          #MOD-A60129 add
                     sfa29    LIKE sfa_file.sfa29,
                     sfa012   LIKE sfa_file.sfa012,         #FUN-A60027
                     sfa013   LIKE sfa_file.sfa013,         #FUN-A60027
                     ima02_1  LIKE ima_file.ima02,
                     eca04d   LIKE eca_file.eca04,
                     ecb012   LIKE ecb_file.ecb012,         #FUN-A60027
                     ecb03    LIKE ecb_file.ecb03,
                     ecb06    LIKE ecb_file.ecb06,
                     ecb08    LIKE ecb_file.ecb08,
                     srtdt    LIKE type_file.dat,
                     duedt    LIKE type_file.dat,
                     esrtdt   LIKE type_file.dat,
                     lsrtdt   LIKE type_file.dat,
                     eduedt   LIKE type_file.dat,
                     lduedt   LIKE type_file.dat,
                     ocf01    LIKE ocf_file.ocf01,
                     ocf02    LIKE ocf_file.ocf02,
                     ocf101   LIKE ocf_file.ocf101,
                     ocf102   LIKE ocf_file.ocf102,
                     ocf103   LIKE ocf_file.ocf103,
                     ocf104   LIKE ocf_file.ocf104,
                     ocf105   LIKE ocf_file.ocf105,
                     ocf106   LIKE ocf_file.ocf106,
                     ocf107   LIKE ocf_file.ocf107,
                     ocf108   LIKE ocf_file.ocf108,
                     ocf109   LIKE ocf_file.ocf109,
                     ocf110   LIKE ocf_file.ocf110,
                     ocf111   LIKE ocf_file.ocf111,
                     ocf112   LIKE ocf_file.ocf112,
                     ocf201   LIKE ocf_file.ocf201,
                     ocf202   LIKE ocf_file.ocf202,
                     ocf203   LIKE ocf_file.ocf203,
                     ocf204   LIKE ocf_file.ocf204,
                     ocf205   LIKE ocf_file.ocf205,
                     ocf206   LIKE ocf_file.ocf206,
                     ocf207   LIKE ocf_file.ocf207,
                     ocf208   LIKE ocf_file.ocf208,
                     ocf209   LIKE ocf_file.ocf209,
                     ocf210   LIKE ocf_file.ocf210,
                     ocf211   LIKE ocf_file.ocf211,
                     ocf212   LIKE ocf_file.ocf212,
                     occ02    LIKE occ_file.occ02,
                     sfw02    LIKE sfw_file.sfw02,
                     sfw03    LIKE sfw_file.sfw03,
                     oao03    LIKE oao_file.oao03,
                     oao05    LIKE oao_file.oao05,
                     oao06    LIKE oao_file.oao06 
                    END RECORD
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_dept    LIKE pmc_file.pmc03,          #No.MOD-580275
          l_occ02   LIKE occ_file.occ02,
          l_eca04   LIKE eca_file.eca04,
          l_eca04d  LIKE eca_file.eca04,          #TQC-740275 add
          l_sum1,l_sum2,l_sum3    LIKE smh_file.smh103,        #No.FUN-680121 DEC(13,5)
          l_cnt     LIKE type_file.num5           #No.FUN-680121 SMALLINT
   DEFINE l_oea01   LIKE oea_file.oea01
   DEFINE l_ofb01   LIKE ofb_file.ofb01
   DEFINE l_oea04   LIKE oea_file.oea04
   DEFINE l_oea44   LIKE oea_file.oea44
   DEFINE l_sfw02   LIKE sfw_file.sfw02
   DEFINE l_sfw03   LIKE sfw_file.sfw03
#No.FUN-710082--end  
   DEFINE l_short_qty   LIKE sfa_file.sfa07   #FUN-940008 add
   DEFINE l_sfa  RECORD LIKE sfa_file.*       #FUN-940008 add
   DEFINE l_gfe03   LIKE gfe_file.gfe03       #MOD-CA0097 add
   #str TQC-740275 add
#FUN-940042--ADD--STR--
   DEFINE            l_img_blob     LIKE type_file.blob
#TQC-C10039--start--mark--   
   #DEFINE            l_ii           INTEGER
   #DEFINE            l_key          RECORD                  #主鍵
                       # v1          LIKE sfb_file.sfb01
                       #            END RECORD
#TQC-C10039--end--mark--
#FUN-940042--ADD--END--


   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#
   DELETE FROM r102_tmp
   DELETE FROM r102_tmp1
   DELETE FROM r102_tmp2
   DELETE FROM r102_tmp3
   DELETE FROM r102_tmp4
   DELETE FROM r102_tmp5
 
   LET g_sql = "INSERT INTO r102_tmp ",
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?)"
   PREPARE insert_prep0 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep0:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO r102_tmp1 VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   #FUN-A60027 add 2?  #MOD-A60129 add ? #FUN-B50095 add ?  #MOD-CA0097 add ?
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO r102_tmp2 VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"      #FUN-A60027 add ?
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO r102_tmp3 ",
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep3:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO r102_tmp4 VALUES(?,?,?)"
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep4:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO r102_tmp5 VALUES(?,?,?,?)"
   PREPARE insert_prep5 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep5:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
   #end TQC-740275 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #No.FUN-670066---Begin
   #  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr102'
   #  IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
   #  FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   #No.FUN-670066---End
#No.CHI-6A0004--------Begin--------------
#     SELECT azi03,azi05 INTO g_azi03,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file WHERE azi01=g_aza.aza17
#No.CHI-6A0004--------End--------------
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   #End:FUN-980030
 
   LET l_sql = " SELECT sfb_file.*,ima02,ima021,ima08,ima55",
   #           " FROM sfb_file,OUTER ima_file",                 #FUN-A60027
               " FROM sfb_file LEFT OUTER JOIN ima_file ON sfb_file.sfb05 = ima_file.ima01 ",   #FUN-A60027
              #" WHERE  sfb_file.sfb05 = ima_file.ima01  AND sfb87!='X' AND ",tm.wc CLIPPED     #FUN-A60027
               " WHERE  sfb87!='X' AND ",tm.wc CLIPPED                                          #FUN-A60027
   LET l_sql=l_sql CLIPPED," ORDER BY sfb01"   #No.FUN-710082
   PREPARE asfr102_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('p1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE asfr102_curs1 CURSOR FOR asfr102_p1
#TQC-C10039--start--mark---   
#FUN-B940042--ADD--STR--
   #LET l_sql = " SELECT sfb01",
   #            " FROM sfb_file LEFT OUTER JOIN ima_file ON sfb_file.sfb05 = ima_file.ima01 ",
   #            " WHERE  sfb87!='X' AND ",tm.wc CLIPPED
   #LET l_sql=l_sql CLIPPED," ORDER BY sfb01"
   #PREPARE key_pr FROM l_sql
   #DECLARE key_curs CURSOR FOR key_pr
#FUN-B940042--ADD--END--
#TQC-C10039--end--mark---

   LET l_sql = " SELECT * FROM ocf_file ",      #NO:6882
               " WHERE  ocf01=? AND ocf02=? "
   PREPARE asfr102_p2 FROM l_sql                  # RUNTIME 編譯
   DECLARE asfr102_curs2 CURSOR FOR asfr102_p2    # CURSOR

#No.FUN-670104--BEGIN--
   IF tm.a = 'Y' THEN        #備料資料
      LET l_sql = " SELECT sfa03,sfa05,sfa06,sfa062,sfa063,'',sfa08,", #FUN-940008 sfa07-->''
                  " sfa09,sfa11,sfa12,sfa16,sfa25,sfa26,sfa27,sfa29,sfa012,sfa013",    #FUN-A60027 add sfa012,sfa013  #MOD-A60129 add sfa27 #FUN-B50095 add sfa16
                  " FROM sfa_file",
                  " WHERE sfa01 = ? ",
                  " ORDER BY sfa27 "
      PREPARE r102_p2 FROM l_sql
      IF STATUS THEN CALL cl_err('p2:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM 
      END IF
      DECLARE r102_c2 CURSOR FOR r102_p2
#FUN-A60027 --------------mark------------      
#      #FUN-940008---Begin add
#      FOREACH r102_c2 INTO l_sfa.*
#         CALL s_shortqty(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,
#                         l_sfa.sfa12,l_sfa.sfa27,l_sfa.sfa012,l_sfa.sfa013)    #FUN-A60027 add sfa012,sfa013
#              RETURNING l_short_qty
#         IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
#      END FOREACH
#      #FUN-940008---End
#FUN-A60027 --------------mark-------------
    END IF     
      IF tm.c ='Y' THEN
         LET l_sql = " SELECT oao03,oao05,oao06,oao04 FROM oao_file",
                     " WHERE oao01 = ? ",
                     "   AND oao05 ='0'",
                     "   AND (oao03=0 OR oao03=?)",
                     " ORDER BY oao03 "
        PREPARE r102_memo1_1 FROM l_sql
        DECLARE s_memo1_c CURSOR FOR r102_memo1_1
      END IF
      IF tm.e ='Y' THEN
         LET l_sql = " SELECT sfw02,sfw03 FROM sfw_file ",
                     "  WHERE sfw01 = ? ",
                     "  ORDER BY sfw02 "
        PREPARE r102_memo1_2 FROM l_sql
        DECLARE r102_memo1_c CURSOR FOR r102_memo1_2
      END IF
#No.FUN-670104--END--
   #No.FUN-710082--begin
   #CALL cl_outnam('asfr102') RETURNING l_name
   #START REPORT asfr102_rep TO l_name
   #LET g_pageno = 0
   #CALL cl_prt_pos_len()                      #NO.FUN-670066
   CALL cl_del_data(l_table) 
   FOREACH asfr102_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF sr.sfb.sfb04='2' THEN  #發放
         UPDATE sfb_file set sfb04='3'
          WHERE sfb01=sr.sfb.sfb01
         IF sqlca.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","sfb_file",sr.sfb.sfb01,"",status,"","upd sfb04",0)   #No.FUN-660128
         END IF
      END IF
 
      IF NOT cl_null(sr.sfb.sfb02) THEN
         IF sr.sfb.sfb02 = 7 THEN
            SELECT pmc03 INTO l_dept FROM pmc_file
             WHERE pmc01 = sr.sfb.sfb82
            IF SQLCA.sqlcode THEN LET l_dept = ' ' END IF 
         ELSE
            SELECT gem02 INTO l_dept FROM gem_file
             WHERE gem01 = sr.sfb.sfb82
            IF SQLCA.sqlcode THEN LET l_dept = ' ' END IF
         END IF
      END IF
     
      #str TQC-740275 add 
      EXECUTE insert_prep0 USING
         sr.sfb.sfb01 ,sr.sfb.sfb02 ,sr.sfb.sfb04,sr.sfb.sfb39 ,sr.sfb.sfb22 ,
         sr.sfb.sfb221,sr.sfb.sfb82 ,l_dept      ,sr.sfb.sfb919,sr.sfb.sfb05 ,sr.ima02 ,  #FUN-A80150 add sfb919
         sr.ima021    ,sr.sfb.sfb071,sr.sfb.sfb08,sr.sfb.sfb09 ,sr.sfb.sfb11 ,
         sr.sfb.sfb40 ,sr.sfb.sfb34 ,sr.sfb.sfb28,sr.sfb.sfb41 ,sr.sfb.sfb06 ,
         sr.sfb.sfb27 ,sr.sfb.sfb07 ,sr.sfb.sfb38,sr.sfb.sfb42 ,sr.sfb.sfb87 ,
         sr.sfb.sfb13 ,sr.sfb.sfb15 ,sr.sfb.sfb25,sr.sfb.sfb251,sr.sfb.sfb88 ,
         sr.ima08     ,sr.ima55
      #end TQC-740275 add 
 
#No.FUN-670104--BEGIN--
      IF tm.a = 'Y' THEN        #備料資料
#         LET l_sql = " SELECT sfa03,sfa05,sfa06,sfa062,sfa063,sfa07,sfa08,",
#                     " sfa09,sfa11,sfa12,sfa25,sfa26,sfa29,",  
#                     " FROM sfa_file",
#                     " WHERE sfa01 = '",sr.sfb.sfb01,"'",
#                    #MOD-5B0296-begin
#                     " ORDER BY sfa27 "
#                    #" AND sfa26 IN ('0','1','2','3','4','5','T')",  #MODNO:7111 add '56'
#                    #" ORDER BY sfa03 "
#                    #MOD-5B0296-end
#         PREPARE r102_p2 FROM l_sql
#         IF STATUS THEN CALL cl_err('p2:',STATUS,1) 
#            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
#            EXIT PROGRAM 
#         END IF
#         DECLARE r102_c2 CURSOR FOR r102_p2
#No.FUN-670104--END--
         LET l_cnt = 0
         FOREACH r102_c2 USING sr.sfb.sfb01 INTO sr1.*  #No.FUN-670104
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            #FUN-A60027  -------------start---------------
           #CALL s_shortqty(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,l_sfa.sfa12,l_sfa.sfa27,l_sfa.sfa012,l_sfa.sfa013)
            CALL s_shortqty(sr.sfb.sfb01,sr1.sfa03,sr1.sfa08,sr1.sfa12,sr1.sfa27,sr1.sfa012,sr1.sfa013)
               RETURNING sr1.sfa07
            #FUN-A60027 -------------end----------------  
            #str TQC-740275 add 
            SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr1.sfa03
            IF cl_null(l_ima02) THEN LET l_ima02 = ' ' END IF
            #MOD-CA0097 add start -----
            SELECT gfe03 INTO l_gfe03 FROM gfe_file
             WHERE gfe01 = sr1.sfa12
            IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
               LET l_gfe03 = 0
            END IF
            #MOD-CA0097 add end   -----
            
            EXECUTE insert_prep1 USING
               sr.sfb.sfb01,sr1.sfa03 ,sr1.sfa05,sr1.sfa06,sr1.sfa062,
               sr1.sfa063  ,sr1.sfa07 ,sr1.sfa08,sr1.sfa09,sr1.sfa11,
               sr1.sfa12   ,sr1.sfa16 ,sr1.sfa25,sr1.sfa26,sr1.sfa27,sr1.sfa29,   #MOD-A60129 add sr1.sfa27 #FUN-B50095 add sfa16
               sr1.sfa012  ,sr1.sfa013,l_gfe03,l_ima02   #FUN-A60027 add sfa012,sfa013      #MOD-CA0097 add ,l_gfe03
            #end TQC-740275 add  
         END FOREACH
      END IF 
 
      IF tm.b = 'Y' THEN        #製程追蹤資料
         IF g_sma.sma26 != '1' AND sr.sfb.sfb24= 'N' 
            AND sr.sfb.sfb93 ='Y' THEN                 #MOD-6B0100 add
         ELSE
            CALL s_taskdat(0,sr.sfb.sfb13,sr.sfb.sfb15,sr.sfb.sfb071,
                           sr.sfb.sfb01,sr.sfb.sfb06,sr.sfb.sfb02,
                           sr.sfb.sfb05,sr.sfb.sfb08) RETURNING g_count   #MOD-580068 add
            FOR g_i = g_count TO 1 STEP -1
                SELECT eca04 INTO l_eca04 FROM eca_file
                 WHERE eca01 = g_takdate[g_i].ecb08
                IF l_eca04 = '2' THEN
                   LET l_eca04d='*'
                ELSE
                   LET l_eca04d=' '
                END IF
                #str TQC-740275 add 
                EXECUTE insert_prep2 USING
                   sr.sfb.sfb01,l_eca04d,g_takdate[g_i].ecb012,g_takdate[g_i].ecb03,     #FUN-A60027 add g_takdate[g_i].ecb012
                   g_takdate[g_i].ecb06 ,g_takdate[g_i].ecb08,
                   g_takdate[g_i].srtdt ,g_takdate[g_i].duedt,
                   g_takdate[g_i].esrtdt,g_takdate[g_i].lsrtdt,
                   g_takdate[g_i].eduedt,g_takdate[g_i].lduedt 
                #end TQC-740275 add 
            END FOR
         END IF
      END IF
 
#No.FUN-670104--BEGIN--
      IF tm.c ='Y' THEN
#         DECLARE s_memo1_c CURSOR FOR
#            SELECT oao03,oao05,oao06,oao04 FROM oao_file
#             WHERE oao01 = sr.sfb.sfb22
#               AND oao05 ='0'
#               AND (oao03=0 OR oao03=sr.sfb.sfb221)
#             ORDER BY oao03
#No.FUN-670104--END--
         FOREACH s_memo1_c USING sr.sfb.sfb22,sr.sfb.sfb221 INTO sr4.* #No.FUN-670104
            IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
            #str TQC-740275 add 
            EXECUTE insert_prep5 USING
               sr.sfb.sfb01,sr4.oao03,sr4.oao05,sr4.oao06
            #end TQC-740275 add 
         END FOREACH
      END IF
 
      IF tm.d ='Y' THEN
         LET g_po_no=''
         SELECT oea01,oea04,oea44,oea10 INTO l_oea01,l_oea04,l_oea44,g_po_no #MOD-530401
          FROM oea_file              #抓單頭資料
         WHERE oea01=sr.sfb.sfb22
         IF SQLCA.SQLCODE THEN
            LET l_oea01=NULL
            LET l_oea04=NULL
            LET l_oea44=NULL
         END IF
         OPEN asfr102_curs2 USING l_oea04,l_oea44
         FETCH asfr102_curs2 INTO sr3.*
         IF SQLCA.SQLCODE=0 AND NOT cl_null(l_oea04) THEN
            SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr3.ocf.ocf01
 #MOD-530401
            LET g_ctn_no1=''
            LET g_ctn_no2=''
            LET sr3.ocf.ocf101=r102_ocf_c(sr3.ocf.ocf101)
            LET sr3.ocf.ocf102=r102_ocf_c(sr3.ocf.ocf102)
            LET sr3.ocf.ocf103=r102_ocf_c(sr3.ocf.ocf103)
            LET sr3.ocf.ocf104=r102_ocf_c(sr3.ocf.ocf104)
            LET sr3.ocf.ocf105=r102_ocf_c(sr3.ocf.ocf105)
            LET sr3.ocf.ocf106=r102_ocf_c(sr3.ocf.ocf106)
            LET sr3.ocf.ocf107=r102_ocf_c(sr3.ocf.ocf107)
            LET sr3.ocf.ocf108=r102_ocf_c(sr3.ocf.ocf108)
            LET sr3.ocf.ocf109=r102_ocf_c(sr3.ocf.ocf109)
            LET sr3.ocf.ocf110=r102_ocf_c(sr3.ocf.ocf110)
            LET sr3.ocf.ocf111=r102_ocf_c(sr3.ocf.ocf111)
            LET sr3.ocf.ocf112=r102_ocf_c(sr3.ocf.ocf112)
            LET sr3.ocf.ocf201=r102_ocf_c(sr3.ocf.ocf201)
            LET sr3.ocf.ocf202=r102_ocf_c(sr3.ocf.ocf202)
            LET sr3.ocf.ocf203=r102_ocf_c(sr3.ocf.ocf203)
            LET sr3.ocf.ocf204=r102_ocf_c(sr3.ocf.ocf204)
            LET sr3.ocf.ocf205=r102_ocf_c(sr3.ocf.ocf205)
            LET sr3.ocf.ocf206=r102_ocf_c(sr3.ocf.ocf206)
            LET sr3.ocf.ocf207=r102_ocf_c(sr3.ocf.ocf207)
            LET sr3.ocf.ocf208=r102_ocf_c(sr3.ocf.ocf208)
            LET sr3.ocf.ocf209=r102_ocf_c(sr3.ocf.ocf209)
            LET sr3.ocf.ocf210=r102_ocf_c(sr3.ocf.ocf210)
            LET sr3.ocf.ocf211=r102_ocf_c(sr3.ocf.ocf211)
            LET sr3.ocf.ocf212=r102_ocf_c(sr3.ocf.ocf212)
            #str TQC-740275 add 
            EXECUTE insert_prep3 USING
               sr.sfb.sfb01,sr3.ocf.ocf01,sr3.ocf.ocf02,
               sr3.ocf.ocf101,sr3.ocf.ocf102,sr3.ocf.ocf103,
               sr3.ocf.ocf104,sr3.ocf.ocf105,sr3.ocf.ocf106,
               sr3.ocf.ocf107,sr3.ocf.ocf108,sr3.ocf.ocf109,
               sr3.ocf.ocf110,sr3.ocf.ocf111,sr3.ocf.ocf112,
               sr3.ocf.ocf201,sr3.ocf.ocf202,sr3.ocf.ocf203,
               sr3.ocf.ocf204,sr3.ocf.ocf205,sr3.ocf.ocf206,
               sr3.ocf.ocf207,sr3.ocf.ocf208,sr3.ocf.ocf209,
               sr3.ocf.ocf210,sr3.ocf.ocf211,sr3.ocf.ocf212,
               l_occ02
            #end TQC-740275 add 
         END IF
      END IF
 
#No.FUN-670104--BEGIN--
      IF tm.e ='Y' THEN
#         DECLARE r102_memo1_c CURSOR FOR
#            SELECT sfw02,sfw03 FROM sfw_file
#             WHERE sfw01 = sr.sfb.sfb01
#             ORDER BY sfw02
#No.FUN-670104--END--
         FOREACH r102_memo1_c USING sr.sfb.sfb01 INTO l_sfw02,l_sfw03 #No.FUN-670104
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)  
               EXIT FOREACH
            END IF
            #str TQC-740275 add 
            EXECUTE insert_prep4 USING
               sr.sfb.sfb01,l_sfw02,l_sfw03
            #end TQC-740275 add 
         END FOREACH
      END IF
 
#      OUTPUT TO REPORT asfr102_rep(sr.*)
   END FOREACH
 
   #str TQC-740275 add
   LET l_sql=
      "SELECT DISTINCT A.*,",
      "       B.sfa03,B.sfa05,B.sfa06,B.sfa062,B.sfa063,B.sfa07,B.sfa08,",
      "       B.sfa09,B.sfa11,B.sfa12,B.sfa16,B.sfa25,B.sfa26,B.sfa27,B.sfa29,B.sfa012,B.sfa013,B.ima02_1,",   #FUN-A60027 add sfa012,sfa013  #MOD-A60129 add B.sfa27 #FUN-B50095 add sfa16
      "       C.eca04d,C.ecb012,C.ecb03,C.ecb06,C.ecb08,C.srtdt,C.duedt,C.esrtdt,",            #FUN-A60027 add ecb012   
      "       C.lsrtdt,C.eduedt,C.lduedt,",
      "       D.ocf01,D.ocf02,D.ocf101,D.ocf102,D.ocf103,D.ocf104,D.ocf105,",
      "       D.ocf106,D.ocf107,D.ocf108,D.ocf109,D.ocf110,D.ocf111,D.ocf112,",
      "       D.ocf201,D.ocf202,D.ocf203,D.ocf204,D.ocf205,D.ocf206,",
      "       D.ocf207,D.ocf208,D.ocf209,D.ocf210,D.ocf211,D.ocf212,D.occ02,",
      "       E.sfw02,E.sfw03,",
      "       F.oao03,F.oao05,F.oao06",
      "  FROM r102_tmp A LEFT OUTER JOIN r102_tmp1 B ON ",
#      "  FROM r102_tmp A  ",
      "  A.sfb01 = B.sfb01_1 LEFT OUTER JOIN r102_tmp2 C ",
#      "  LEFT OUTER JOIN r102_tmp2 C ", 
      " ON A.sfb01 = C.sfb01_2 LEFT OUTER JOIN r102_tmp3 D ",
      " ON A.sfb01 = D.sfb01_3 LEFT OUTER JOIN r102_tmp4 E ",
      " ON A.sfb01 = E.sfb01_4 LEFT OUTER JOIN r102_tmp5 F ",
      " ON A.sfb01 = F.sfb01_5 "
 
   PREPARE asfr102_prepare0 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare0:',SQLCA.sqlcode,1)
   END IF
   DECLARE asfr102_curs0 CURSOR FOR asfr102_prepare0
 
   FOREACH asfr102_curs0 INTO cr.*
     #--------------No:TQC-A60097 add                                           
      IF NOT cl_null(cr.sfb02) THEN                                             
         LET l_sfb02doc = s_wotype(cr.sfb02)                                    
      ELSE                                                                      
         LET l_sfb02doc = NULL                                                  
      END IF                                                                    
     #--------------No:TQC-A60097 end
      #FUN-B50095 --START--
      IF cr.sfa11 = 'X' THEN
         LET cr.sfa05 = cr.sfa16 * cr.sfb08
      END IF  
      #FUN-B50095 --END--

      #MOD-CA0097 add start -----
      SELECT gfe03 INTO l_gfe03 FROM gfe_file
       WHERE gfe01 = cr.sfa12
      IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
         LET l_gfe03 = 0
      END IF
      #MOD-CA0097 add end   -----
     
      EXECUTE insert_prep USING 
         cr.sfb01  ,cr.sfb02  ,cr.sfb04 ,cr.sfb39 ,cr.sfb22 ,
         cr.sfb221 ,cr.sfb82  ,cr.gem02 ,cr.sfb919,cr.sfb05 ,cr.ima02 ,      #FUN-A80150 add
         cr.ima021 ,cr.sfb071 ,cr.sfb08 ,cr.sfb09 ,cr.sfb11 ,
         cr.sfb40  ,cr.sfb34  ,cr.sfb28 ,cr.sfb41 ,cr.sfb06 ,
         cr.sfb27  ,cr.sfb07  ,cr.sfb38 ,cr.sfb42 ,cr.sfb87 ,
         cr.sfb13  ,cr.sfb15  ,cr.sfb25 ,cr.sfb251,cr.sfb88 ,
         cr.ima08  ,cr.ima55  ,cr.sfa03 ,cr.sfa05 ,cr.sfa06 ,
         cr.sfa062 ,cr.sfa063 ,cr.sfa07 ,cr.sfa08 ,cr.sfa09 ,
         cr.sfa11  ,cr.sfa12  ,cr.sfa25 ,cr.sfa26 ,cr.sfa27 ,  #MOD-A60129 add cr.sfa27
         cr.sfa29  ,cr.sfa012 ,cr.sfa013,                      #FUN-A60027 addsfa012,sfa013
         cr.ima02_1,cr.eca04d ,cr.ecb012,cr.ecb03 ,cr.ecb06 ,  #FUN-A60027 add ecb012
         cr.ecb08  ,cr.srtdt  ,cr.duedt ,cr.esrtdt,cr.lsrtdt,
         cr.eduedt ,cr.lduedt ,cr.ocf01 ,cr.ocf02 ,cr.ocf101,
         cr.ocf102 ,cr.ocf103 ,cr.ocf104,cr.ocf105,cr.ocf106,
         cr.ocf107 ,cr.ocf108 ,cr.ocf109,cr.ocf110,cr.ocf111,
         cr.ocf112 ,cr.ocf201 ,cr.ocf202,cr.ocf203,cr.ocf204,
         cr.ocf205 ,cr.ocf206 ,cr.ocf207,cr.ocf208,cr.ocf209,
         cr.ocf210 ,cr.ocf211 ,cr.ocf212,cr.occ02 ,cr.sfw02 ,
         cr.sfw03  ,cr.oao03  ,cr.oao05 ,cr.oao06 ,l_gfe03  ,l_sfb02doc,  #No:MOD-960330 add l_sfb02doc  #MOD-CA0097 add ,l_gfe03
          ""       ,l_img_blob,"N"      ,""   #No.FUN-940042 ADD #TQC-C10039 add ""
   END FOREACH
   #end TQC-740275 add
 
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                 
 
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb82')  
      RETURNING tm.wc                                                           
   ELSE
      LET tm.wc = ''
   END IF                      
 
   LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",
               tm.a,";",tm.b,";",tm.c,";",tm.d,";",tm.e,";",tm.f   #FUN-750047 add tm.f   
               ,";",g_sma.sma1421            
   LET l_str = l_str, ";;;;;;;;;;;", FGL_GETENV("CRIP") 
   #FUN-940042--ADD--STR-
   LET g_cr_table = l_table                 #主報表的temp table名稱
   #LET g_cr_gcx01 = "asmi300"               #單別維護程式 #TQC-C10039 mark--
   LET g_cr_apr_key_f = "sfb01"             #報表主鍵欄位名稱，用"|"隔開
#TQC-C10039--start--mark--  
   #LET l_ii = 1
   #報表主鍵值
   #CALL g_cr_apr_key.clear()                #清空
   #FOREACH key_curs INTO l_key.*
   #LET g_cr_apr_key[l_ii].v1 = l_key.v1
   #LET l_ii = l_ii + 1
  #END FOREACH
#TQC-C10039--end--mark-- 
#FUN-940042--ADD--END--

  #CALL cl_prt_cs3('asfr102','asfr102',l_sql,l_str)    #FUN-A60027
  #No.FUN-A60027 ------------------------start----------------------
  IF g_sma.sma541 = 'Y' THEN
     CALL cl_prt_cs3('asfr102','asfr102_1',l_sql,l_str)  
  ELSE
     CALL cl_prt_cs3('asfr102','asfr102',l_sql,l_str)
  END IF 
  #No.FUN-A60027 -------------------------end-----------------------  
  #FINISH REPORT asfr102_rep
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #No.FUN-710082--end  
 
END FUNCTION
 
#No.FUN-710082--begin
#REPORT asfr102_rep(sr)
#  DEFINE l_oea01 LIKE oea_file.oea01
#  DEFINE l_ofb01 LIKE ofb_file.ofb01
#  DEFINE l_oea04 LIKE oea_file.oea04
#  DEFINE l_oea44 LIKE oea_file.oea44
#  DEFINE l_sfw02 LIKE sfw_file.sfw02
#  DEFINE l_sfw03 LIKE sfw_file.sfw03
#  DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         sr            RECORD
#                       sfb        RECORD LIKE sfb_file.*,
#                       ima02    LIKE ima_file.ima02,    #品名規格
#                       ima021   LIKE ima_file.ima021,    #品名規格
#                       ima08    LIKE ima_file.ima08,    #來源碼
#                       ima55    LIKE ima_file.ima55        #生產單位
#                       END        RECORD,
#         sr1            RECORD
#                       sfa03    LIKE sfa_file.sfa03,    #料件編號
#                       sfa05    LIKE sfa_file.sfa05,    #應發數量
#                       sfa06    LIKE sfa_file.sfa06,    #已發數量
#                       sfa062  LIKE sfa_file.sfa06,    #
#                       sfa063  LIKE sfa_file.sfa06,    #
#                       sfa07    LIKE sfa_file.sfa07,    #缺料數量
#                       sfa08    LIKE sfa_file.sfa08,    #作業編號
#                       sfa09    LIKE sfa_file.sfa09,    #前置時間調整
#                       sfa11    LIKE sfa_file.sfa11,    #旗標
#                       sfa12    LIKE sfa_file.sfa12,    #發料單位
#                       sfa25    LIKE sfa_file.sfa25,    #未備料量
#                       sfa26    LIKE sfa_file.sfa26,    #來源
#                       sfa29    LIKE sfa_file.sfa29     #上階料號
#                       END        RECORD,
#         sr2            RECORD
#                       ecm03        LIKE ecm_file.ecm03,    #作業序號
#                       ecm06        LIKE ecm_file.ecm06,    #工作站
#                       ecm11        LIKE ecm_file.ecm11,    #製程編號
#                       eca04        LIKE eca_file.eca04     #工作站型態
#                       END        RECORD,
#         sr3           RECORD
#                       ocf        RECORD LIKE ocf_file.*,    #NO:6882
#                       occ02      LIKE occ_file.occ02
#                       END        RECORD,
#         sr4           RECORD
#                       oao03      LIKE oao_file.oao03,   #NO:6882
#                       oao05      LIKE oao_file.oao05,
#                       oao06      LIKE oao_file.oao06
#                       END        RECORD,
#     l_sql     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1200)
#     l_ima02   LIKE ima_file.ima02,
#     l_dept    LIKE pmc_file.pmc03,          #No.MOD-580275
#     l_occ02   LIKE occ_file.occ02,
#     l_page    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_page1   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_lineno  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_eca04    LIKE eca_file.eca04,
#     l_sum1,l_sum2,l_sum3    LIKE smh_file.smh103,        #No.FUN-680121 DEC(13,5)
#     l_cnt        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     ss           LIKE type_file.num5,          #No.FUN-680121 SMALLINT#status code
#     l_chr        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#     l_y          LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
# OUTPUT TOP MARGIN 0
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN 5
#        PAGE LENGTH g_page_line
# ORDER BY sr.sfb.sfb01
# FORMAT
#  PAGE HEADER
#   #NO.FUN-670066---Begin  
#   # PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED 
#   #  IF cl_null(g_towhom)
#   #     THEN PRINT '';
#   #     ELSE PRINT 'TO:',g_towhom;
#   #  END IF
#   #  PRINT ''
#     LET g_pageno = g_pageno +1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#   #  PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#   # PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT COLUMN((g_len-length(g_x[1]))/2)+1,g_x[1]
#     PRINT ' '
#   #  LET g_pageno = g_pageno + 1
#   #  PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#   #        COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#   #  LET g_head1 = g_x[12] CLIPPED, g_orderA[1] CLIPPED,'-',
#   #                g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
#   #  PRINT g_head1
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'n'
#     LET l_page1 = PAGENO
#   #NO.FUN-670066---End
#  BEFORE GROUP OF sr.sfb.sfb01
### No:2455 modify 1998/09/29 -----------
#     IF sr.sfb.sfb04='2' #發放
#        THEN
#        UPDATE sfb_file set sfb04='3'
#         WHERE sfb01=sr.sfb.sfb01
#        IF sqlca.sqlerrd[3]=0
#           THEN
#   #       CALL cl_err('upd sfb04',status,0)   #No.FUN-660128
#           CALL cl_err3("upd","sfb_file",sr.sfb.sfb01,"",status,"","upd sfb04",0)   #No.FUN-660128
#        END IF
#     END IF
##
#     IF (PAGENO>1 OR LINENO>9) THEN SKIP TO TOP OF PAGE END IF
#     LET l_page = l_page1
#     PRINT g_x[11] CLIPPED,sr.sfb.sfb01,"   (",
#           s_wotype(sr.sfb.sfb02) CLIPPED,"/",s_wostatu(sr.sfb.sfb04) CLIPPED,
#           ")"
#     IF NOT cl_null(sr.sfb.sfb02) THEN
#        IF sr.sfb.sfb02 = 7 THEN
#           SELECT pmc03 INTO l_dept FROM pmc_file
#            WHERE pmc01 = sr.sfb.sfb82
#           IF SQLCA.sqlcode THEN
#              LET l_dept = ' '
#           END IF
#        ELSE
#           SELECT gem02 INTO l_dept FROM gem_file
#            WHERE gem01 = sr.sfb.sfb82
#           IF SQLCA.sqlcode THEN
#              LET l_dept = ' '
#           END IF
#        END IF
#     END IF
#     PRINT g_x[12] CLIPPED,sr.sfb.sfb05,' ',sr.ima08,COLUMN 59,g_x[13] CLIPPED,    #No.FUN-670066
#           sr.sfb.sfb28,' ';
#     CASE sr.sfb.sfb28
#        WHEN '1' CALL cl_getmsg('asf-021',g_lang) RETURNING g_msg
#        WHEN '2' CALL cl_getmsg('asf-022',g_lang) RETURNING g_msg
#        WHEN '3' CALL cl_getmsg('asf-023',g_lang) RETURNING g_msg
#        OTHERWISE LET g_msg = g_x[81] CLIPPED
#     END CASE
#     PRINT g_msg CLIPPED
#     PRINT COLUMN 10,sr.ima02,sr.ima021
#     PRINT g_x[15] CLIPPED,sr.sfb.sfb07
#     PRINT g_x[17] CLIPPED,sr.sfb.sfb071,'    ','(BOM/ROUTING)';
#     IF sr.sfb.sfb38 IS NOT NULL THEN
#         PRINT COLUMN 53,sr.sfb.sfb38
#     ELSE
#         PRINT
#     END IF
#     #No.FUN-670066---Begin
#     PRINT g_x[18] CLIPPED,sr.sfb.sfb06,COLUMN 63,g_x[19] CLIPPED,
#           sr.sfb.sfb41
#     PRINT g_x[20] CLIPPED,sr.sfb.sfb40,COLUMN 59,g_x[21] CLIPPED;
#     IF sr.sfb.sfb42 IS NULL OR sr.sfb.sfb42 = '0' THEN
#        PRINT '0'
#     ELSE
#        PRINT sr.sfb.sfb42
#     END IF
#     PRINT g_x[22] CLIPPED,sr.sfb.sfb34,COLUMN 63,g_x[23] CLIPPED,
#           sr.sfb.sfb22,'/',sr.sfb.sfb221 USING '<<<'
#     PRINT g_x[24] CLIPPED,sr.ima55,COLUMN 63,g_x[25] CLIPPED,
#           sr.sfb.sfb27
#     #No.FUN-670066---End
#     PRINT g_x[26] CLIPPED,sr.sfb.sfb08
#        #  COLUMN 37,g_x[27] CLIPPED,sr.sfb.sfb03
#     IF sr.sfb.sfb88 =' ' or sr.sfb.sfb88 IS NULL THEN
#         PRINT
#     ELSE
#           PRINT COLUMN 43,g_x[85] CLIPPED,sr.sfb.sfb88,COLUMN 66,
#                     g_x[86] CLIPPED, sr.sfb.sfb87
#     END IF
#     PRINT g_x[28] CLIPPED,sr.sfb.sfb09,
#           COLUMN 59,g_x[106] CLIPPED,sr.sfb.sfb13         #No.FUN-670066
#         # COLUMN 35,g_x[29] CLIPPED,sr.sfb.sfb20,
#         # '      ',g_x[30] CLIPPED,sr.sfb.sfb29
#     PRINT g_x[109] CLIPPED,sr.sfb.sfb11,
#           COLUMN 59,g_x[108] CLIPPED,sr.sfb.sfb15         #No.FUN-670066
#   # PRINT g_x[31] CLIPPED,sr.sfb.sfb10,
#   # PRINT g_x[33] CLIPPED,sr.sfb.sfb12,
#     PRINT COLUMN 59,g_x[110] CLIPPED,sr.sfb.sfb251,' ';   #No.FUN-670066
#      IF sr.sfb.sfb04 = '1' THEN
#       PRINT g_x[82] CLIPPED
#     ELSE
#        PRINT
#     END IF
#   # PRINT g_x[37] CLIPPED,COLUMN 39,g_x[38] CLIPPED,
#   #      sr.sfb.sfb32;
#   # CASE sr.sfb.sfb32
#   #    WHEN '1' PRINT 'window scheduling forward'
#   #    WHEN '2' PRINT 'window scheduling backward'
#   #    WHEN '3' PRINT 'weighted window scheduling'
#   #    WHEN '4' PRINT 'tracking scheduling forward'
#   #    WHEN '5' PRINT 'tracking scheduling backward'
#   #    OTHERWISE PRINT
#   # END CASE
#    #PRINT COLUMN 39,g_x[39] CLIPPED,sr.sfb.sfb33;
#    #CASE sr.sfb.sfb33
#    #   WHEN '1' PRINT 'window scheduling forward'
#    #   WHEN '2' PRINT 'window scheduling backward'
#    #   WHEN '3' PRINT 'weighted window scheduling'
#    #   WHEN '4' PRINT 'tracking scheduling forward'
#    #   WHEN '5' PRINT 'tracking scheduling backward'
#    #   OTHERWISE EXIT CASE
#    #END CASE
#    #PRINT
#    #IF sr.sfb.sfb28 IS NOT NULL THEN
#    #     PRINT g_x[40] CLIPPED,'Y','/',sr.sfb.sfb81;
#    #ELSE
#    #     PRINT g_x[40] CLIPPED,'N ';
#    #END IF
#   # PRINT COLUMN 33,g_x[41] CLIPPED,sr.sfb.sfb23
#    #PRINT g_x[42] CLIPPED,sr.sfb.sfb25,
#     PRINT COLUMN 59,g_x[117] CLIPPED,sr.sfb.sfb39,' ';      #No.FUN-670066
#     CASE sr.sfb.sfb39
#           WHEN '1' CALL cl_getmsg('mfg5054',g_lang) RETURNING g_msg
#           WHEN '2' CALL cl_getmsg('mfg5055',g_lang) RETURNING g_msg
#           OTHERWISE LET g_msg = ''
#     END CASE
#     PRINT g_msg CLIPPED
#     PRINT g_x[84] CLIPPED,sr.sfb.sfb82 CLIPPED,' / ',l_dept
 
#     PRINT ' '
 
#     IF tm.a = 'Y' THEN
#      #FUN-5A0140-begin
#      #No.FUN-670066---Begin
#      # PRINT "-------------------------------";
#      # PRINT "---------------------------------------------------";
#        PRINT g_dash2[1,(g_len-FGL_WIDTH(g_x[44]))/2];
#      #  PRINT g_dash2[1,g_len];
#        PRINT COLUMN((g_len-FGL_WIDTH(g_x[44] CLIPPED))/2)+1,g_x[44] CLIPPED; 
#      # PRINT g_x[44] CLIPPED,"-------------------------------"
#      #  PRINT g_x[44] CLIPPED,"-------------------------------------"
#        
#      # PRINT "---------------------------------------------------"
#        PRINT g_dash2[(g_len+FGL_WIDTH(g_x[44]))/2+1,g_len]
#      #FUN-5A0140-end
#     ELSE
##No.TQC-710070--begin
#         PRINTX name=H6 g_x[156]
#         PRINT g_dash1
#         PRINTX name=D6 COLUMN g_c[156],''
##No.TQC-710070--end
#      #No.FUN-670066---End
#       # PRINT "-----------------------------------------";
#      #FUN-5A0140-begin
#      #  PRINT "-------------------------------------"
#       # PRINT "--------------------------------------------------"
#      #FUN-5A0140-end
#     END IF
#     IF tm.a = 'Y' THEN        #備料資料
#        LET l_sql = " SELECT sfa03,sfa05,sfa06,sfa062,sfa063,sfa07,sfa08,",
#                    " sfa09,sfa11,sfa12,sfa25,sfa26,sfa29",
#                    " FROM sfa_file",
#                    " WHERE sfa01 = '",sr.sfb.sfb01,"'",
#                   #MOD-5B0296-begin
#                    " ORDER BY sfa27 "
#                   #" AND sfa26 IN ('0','1','2','3','4','5','T')",  #MODNO:7111 add '56'
#                   #" ORDER BY sfa03 "
#                   #MOD-5B0296-end
#        PREPARE r102_p2 FROM l_sql
#        IF STATUS THEN CALL cl_err('p2:',STATUS,1) 
#           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
#           EXIT PROGRAM 
#        END IF
#        DECLARE r102_c2 CURSOR FOR r102_p2
#        LET l_cnt = 0
#        FOREACH r102_c2 INTO sr1.*
#           IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#        IF l_cnt = 0 THEN         # PRINT HEADING   
#           #FUN-5A0140-begin
#           # PRINT COLUMN 2,g_x[45],g_x[46] CLIPPED
#           # PRINT COLUMN 2,g_x[47] CLIPPED,g_x[48] CLIPPED
#           #    PRINT "    -------------------- -- ---- ------------ ",
#           #       "------------ ------------ --------"
#           #NO.FUN-670066---Begin
#           #  PRINT COLUMN  5,g_x[100],
#           #        COLUMN 47,g_x[101]
#           #  PRINT COLUMN  5,g_x[102],
#           #        COLUMN 63,g_x[103]
#           #  PRINT COLUMN  5,g_x[104]
#           #  PRINT "    ---- ---- --------------- --------------- ",
#           #        "--------------- --------------- ---------------"
#              PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#              PRINTX name=H2 g_x[39],g_x[40],g_x[118],g_x[119],g_x[120],g_x[41]
#              PRINTX name=H3 g_x[42],g_x[43]      
#              PRINT g_dash1 
#           #NO.FUN-670066---End        
#           #FUN-5A0140-end
          
#        END IF  
#               LET l_lineno = LINENO
#               IF l_lineno > 51 THEN  #MOD-620075 56->51
#                  SKIP TO TOP OF PAGE
#               END IF
#               IF l_page < l_page1 THEN
#                   #MOD-620075-begin
#                   #PRINT g_x[11] CLIPPED,sr.sfb.sfb01,'  ',
#                   #   #  g_x[12] CLIPPED,sr.sfb.sfb05,'  ', #FUN-5A0140
#                   #      g_x[26] CLIPPED,sr.sfb.sfb08
#                   #PRINT g_x[12] CLIPPED,sr.sfb.sfb05,'  '  #FUN-5A0140
#                   PRINT g_x[11] CLIPPED,sr.sfb.sfb01,"   (",
#                         s_wotype(sr.sfb.sfb02) CLIPPED,"/",s_wostatu(sr.sfb.sfb04) CLIPPED,
#                         ")"
#                   PRINT g_x[12] CLIPPED,sr.sfb.sfb05,' ',sr.ima08,COLUMN 51,g_x[13] CLIPPED,
#                         sr.sfb.sfb28,' ';
#                   CASE sr.sfb.sfb28
#                      WHEN '1' CALL cl_getmsg('asf-021',g_lang) RETURNING g_msg
#                      WHEN '2' CALL cl_getmsg('asf-022',g_lang) RETURNING g_msg
#                      WHEN '3' CALL cl_getmsg('asf-023',g_lang) RETURNING g_msg
#                      OTHERWISE LET g_msg = g_x[81] CLIPPED
#                   END CASE
#                   PRINT g_msg CLIPPED
#                   PRINT g_x[26] CLIPPED,sr.sfb.sfb08
#                   PRINT
#                   #MOD-620075-end
#             #FUN-5A0140-begin
#             #      PRINT COLUMN 2,g_x[45],g_x[46] CLIPPED
#             #      PRINT COLUMN 2,g_x[47] CLIPPED,g_x[48] CLIPPED
#             #      PRINT "    -------------------- -- ---- ------------ ",
#             #        "------------ ------------ --------"
#             #PRINT COLUMN  5,g_x[100],
#             #      COLUMN 47,g_x[101]
#             #PRINT COLUMN  5,g_x[102],
#             #      COLUMN 63,g_x[103]
#             #PRINT COLUMN  5,g_x[104]
#             #PRINT "    ---- ---- --------------- --------------- ",
#             #      "--------------- --------------- ---------------"
#             #NO.FUN-670066---Begin
#              PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#              PRINTX name=H2 g_x[39],g_x[40],g_x[118],g_x[119],g_x[120],g_x[41]                           
#              PRINTX name=H3 g_x[42],g_x[43]                                   
#              PRINT g_dash1 
#             #NO.FUN-670066---End                                          
#             #FUN-5A0140-end
#                   LET l_page = l_page1
#               END IF
 
#           #FUN-5A0140-begin
#           #PRINT COLUMN 3,sr1.sfa11,
#           #      COLUMN 5,sr1.sfa03,
#           #      COLUMN 26,sr1.sfa26,
#           #      COLUMN 29,sr1.sfa12,
#           #      COLUMN 34,sr1.sfa05 USING'-------&.###',
#           #      COLUMN 47,sr1.sfa06 USING'-------&.###',
#           #      COLUMN 60,sr1.sfa07 USING'-------&.###',
#           #      COLUMN 73,sr1.sfa08
#           #SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr1.sfa03
#           # PRINT COLUMN 05,l_ima02{[1,20]}, #MOD-4A0203將ima02全部印出來
#           #      COLUMN 34,sr1.sfa062 USING '-------&.###',' ',
#           #                sr1.sfa063 USING '-------&.###',' '
#
#           #NO.FUN-670066---Begin 
#           #PRINT COLUMN  3,sr1.sfa11,
#           #      COLUMN  5,sr1.sfa26,
#           #      COLUMN 10,sr1.sfa12,
#           #      COLUMN 15,sr1.sfa062 USING '----------&.###',
#           #      COLUMN 31,sr1.sfa063 USING '----------&.###',
 
#           #      COLUMN 47,sr1.sfa05 USING '----------&.###',
#           #      COLUMN 64,sr1.sfa06 USING '---------&.###',
#           #      COLUMN 79,sr1.sfa07 USING '----------&.###'
#           #PRINT COLUMN  5,sr1.sfa03,
#           #      COLUMN 63,sr1.sfa08
#             PRINTX name=D1 COLUMN 04,sr1.sfa11, 
#                            COLUMN g_c[32],sr1.sfa26,
#                            COLUMN g_c[33],sr1.sfa12,
#                            COLUMN g_c[34],sr1.sfa062 USING '----------&.###',
#                            COLUMN g_c[35],sr1.sfa063 USING '----------&.###',
#                            COLUMN g_c[36],sr1.sfa05 USING '----------&.###',
#                            COLUMN g_c[37],sr1.sfa06 USING '----------&.###',
#                            COLUMN g_c[38],sr1.sfa07 USING '----------&.###'
#             PRINTX name=D2 COLUMN g_c[40],sr1.sfa03,
#                            COLUMN g_c[41],sr1.sfa08
 
#           SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr1.sfa03
#            PRINTX name=D3 COLUMN g_c[43],l_ima02 #MOD-4A0203將ima02全部印出來
#           #NO.FUN-670066---End
#           #FUN-5A0140-end
 
#           #MOD-620075-begin
#            NEED 3 LINES
#           #MOD-620075-end
 
#           #MOD-5B0296-begin
#           #取,替代料件
#           #LET l_sql = " SELECT sfa03,sfa05,sfa06,sfa062,sfa063,sfa07,sfa08,",
#           #            "        sfa09,sfa11,sfa12,sfa25,sfa26,sfa29",
#           #            " FROM sfa_file,bmd_file",
#           #            " WHERE sfa01 = '",sr.sfb.sfb01,"'",
#           #            " AND bmd01 = '",sr1.sfa03,"'",
#           #            " AND sfa03 = bmd04",
#           #            " AND sfa26 IN ('U','S')",
#           #            " AND (bmd05 <= '",sr.sfb.sfb071,"'",
#           #            " AND (bmd06 IS NULL OR bmd06 >= '",sr.sfb.sfb071,"'))",
#           #            " AND (bmd08 ='",sr.sfb.sfb05,"'",
#           #            "  OR bmd08 ='ALL')",
#           #            " ORDER BY sfa03"
#           #PREPARE r102_p3 FROM l_sql
#           #IF STATUS THEN CALL cl_err('p3:',STATUS,1) EXIT PROGRAM END IF
#           #DECLARE r102_c3 CURSOR FOR r102_p3
#           #FOREACH r102_c3 INTO sr1.*
#           #    IF STATUS THEN
#           #        CALL cl_err('foreach:',STATUS,1)
#           #        EXIT FOREACH
#           #    END IF
#           #    LET l_lineno = LINENO
#           #    IF l_lineno > 56 THEN
#           #       SKIP TO TOP OF PAGE
#           #    END IF
#           #    IF l_page < l_page1 THEN
#           #        PRINT g_x[11] CLIPPED,sr.sfb.sfb01,'  ',
#           #         #    g_x[12] CLIPPED,sr.sfb.sfb05,'  ', #FUN-5A0140
#           #              g_x[26] CLIPPED,sr.sfb.sfb08
#           #        PRINT g_x[12] CLIPPED,sr.sfb.sfb05,'  '  #FUN-5A0140
#           #        PRINT
#           # #FUN-5A0140-begin
#           # #       PRINT COLUMN 26,g_x[45],g_x[46] CLIPPED
#           # #       PRINT COLUMN 2,g_x[47] CLIPPED,g_x[48] CLIPPED
#           # #       PRINT "    -------------------- -- ---- ------------ ",
#           # #         "------------ ------------ --------"
#           #  PRINT COLUMN  5,g_x[100],
#           #        COLUMN 47,g_x[101]
#           #  PRINT COLUMN  5,g_x[102],
#           #        COLUMN 63,g_x[103]
#           #  PRINT COLUMN  5,g_x[104]
#           #  PRINT "    ---- ---- --------------- ---------------",
#           #        "--------------- --------------- ---------------"
#           ##FUN-5A0140-end
#           #       LET l_page = l_page1
#           #    END IF
 
#           ##FUN-5A0140-begin
#           ##PRINT COLUMN 3,sr1.sfa11,
#           ##      COLUMN 5,sr1.sfa03,
#           ##      COLUMN 26,sr1.sfa26,
#           ##      COLUMN 29,sr1.sfa12,
#           ##      COLUMN 34,sr1.sfa05 USING'-------&.###',
#           ##      COLUMN 47,sr1.sfa06 USING'-------&.###',
#           ##      COLUMN 60,sr1.sfa07 USING'-------&.###',
#           ##      COLUMN 73,sr1.sfa08
 
#           ##    SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr1.sfa03
#           ##     PRINT COLUMN 5, l_ima02 CLIPPED, #MOD-4A0238
#           ##          COLUMN 34,sr1.sfa062 USING '-------&.###',' ',
#           ##                    sr1.sfa063 USING '-------&.###',' '
#           #PRINT COLUMN  3,sr1.sfa11,
#           #      COLUMN  5,sr1.sfa26,
#           #      COLUMN 10,sr1.sfa12,
#           #      COLUMN 15,sr1.sfa062 USING '----------&.###',
#           #      COLUMN 31,sr1.sfa063 USING '----------&.###',
#           #      COLUMN 47,sr1.sfa05 USING'----------&.###',
#           #      COLUMN 64,sr1.sfa06 USING'---------&.###',
#           #      COLUMN 79,sr1.sfa07 USING'----------&.###'
#           #PRINT COLUMN  5,sr1.sfa03,
#           #      COLUMN 63,sr1.sfa08
#           #
#           #SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr1.sfa03
#           # PRINT COLUMN 05,l_ima02{[1,20]} #MOD-4A0203將ima02全部印出來
#           ##FUN-5A0140-end
 
#           #END FOREACH
#           #MOD-5B0296-end
#           LET l_cnt = l_cnt + 1
#        END FOREACH
#        IF l_cnt = 0 THEN
#           PRINT
#           PRINT COLUMN 32,g_x[56] CLIPPED
#        END IF
#        PRINT
#     END IF
#     IF tm.b = 'Y' THEN        #製程追蹤資料
#        LET l_lineno = LINENO
#        IF l_lineno > 51 THEN  #MOD-620075 56->51
#           SKIP TO TOP OF PAGE
#        END IF
#        IF l_page < l_page1 THEN
#           PRINT g_x[11] CLIPPED,sr.sfb.sfb01,'  ',
#             #   g_x[12] CLIPPED,sr.sfb.sfb05,'  ', #FUN-5A0140
#                 g_x[26] CLIPPED,sr.sfb.sfb08
#           PRINT g_x[12] CLIPPED,sr.sfb.sfb05,'  '  #FUN-5A0140
#           PRINT
#           LET l_page = l_page1
#        END IF
#        #FUN-5A0140-begin
#        #FUN-670066---Begin
#         PRINT g_dash2[1,(g_len-FGL_WIDTH(g_x[52]))/2];                         
#         PRINT COLUMN((g_len-FGL_WIDTH(g_x[52] CLIPPED))/2)+1,g_x[52] CLIPPED;  
#         PRINT g_dash2[(g_len+FGL_WIDTH(g_x[52]))/2+1,g_len]   
#        #PRINT "-------------------------------";
#        #PRINT "--------------------------------------";
#        #PRINT g_x[52] CLIPPED,"-------------------------------"
#        #PRINT g_x[52] CLIPPED, "-------------------------------------"
#        #FUN-670066---End
#        #FUN-5A0140-end
 
#        IF g_sma.sma26 != '1' AND sr.sfb.sfb24= 'N' 
#           AND sr.sfb.sfb93 ='Y' THEN                 #MOD-6B0100 add
#           PRINT
#           PRINT COLUMN 27,g_x[57] CLIPPED
#        ELSE
#           CALL s_taskdat(0,sr.sfb.sfb13,sr.sfb.sfb15,sr.sfb.sfb071,
#                           sr.sfb.sfb01,sr.sfb.sfb06,sr.sfb.sfb02,
#  #                        sr.sfb.sfb05,sr.sfb.sfb08) RETURNING ss  #MOD-580068 mark
#                           sr.sfb.sfb05,sr.sfb.sfb08) RETURNING g_count   #MOD-580068 add
#  #        IF ss = 2 THEN   #MOD-580068 mark
#           IF g_count = 0 THEN        #MOD-580068 add
#               PRINT
#               PRINT COLUMN 32,g_x[80] CLIPPED
#               PRINT
#           END IF
#           IF g_count > 0 THEN
#              NEED 3 LINES
#              PRINT COLUMN 3,g_x[83] CLIPPED,COLUMN 38,g_x[53] CLIPPED
#              PRINT COLUMN 3,g_x[54] CLIPPED,g_x[55] CLIPPED
#              PRINT "   ---- ------ ---------- -------- -------- -------- ",
#                    "-------- -------- --------"
#              FOR g_i = g_count TO 1 STEP -1
#                  LET l_lineno = LINENO
#                  IF l_lineno > 51 THEN  #MOD-620075 56->51
#                     SKIP TO TOP OF PAGE
#                  END IF
#                  IF l_page < l_page1 THEN
#                      PRINT g_x[11] CLIPPED,sr.sfb.sfb01,'  ',
#                        #   g_x[12] CLIPPED,sr.sfb.sfb05,'  ', #FUN-5A0140
#                            g_x[26] CLIPPED,sr.sfb.sfb08
#                      PRINT g_x[12] CLIPPED,sr.sfb.sfb05,'  '  #FUN-5A0140
#                      PRINT
#                      PRINT COLUMN 3,g_x[83] CLIPPED,COLUMN 38,g_x[53] CLIPPED
#                      PRINT COLUMN 3,g_x[54] CLIPPED,g_x[55] CLIPPED
#                      PRINT "   ---- ------ ---------- -------- -------- ",
#                            "-------- -------- -------- --------"
#                      LET l_page = l_page1
#                  END IF
#                  SELECT eca04 INTO l_eca04 FROM eca_file
#                       WHERE eca01 = g_takdate[g_i].ecb08
#                  IF l_eca04 = '2' THEN
#                     PRINT COLUMN 2,'*';
#                  END IF
#                     PRINT COLUMN 4,g_takdate[g_i].ecb03 USING'####',' ',
#                         #MOD-580068 列印加上指定位置 begin
#                          COLUMN  9,g_takdate[g_i].ecb06 ,' ',
#                          COLUMN 16,g_takdate[g_i].ecb08 ,' ',
#                          COLUMN 27,g_takdate[g_i].srtdt ,' ',
#                          COLUMN 34,g_takdate[g_i].esrtdt,' ',
#                          COLUMN 41,g_takdate[g_i].lsrtdt,' ',
#                          COLUMN 48,g_takdate[g_i].duedt ,' ',
#                          COLUMN 55,g_takdate[g_i].eduedt,' ',
#                          COLUMN 62,g_takdate[g_i].lduedt
#                         #MOD-580068 列印加上指定位置 end
#              END FOR
#              PRINT
#           END IF
#        END IF
#     PRINT
#     END IF
#     #====================================================NO:6882印memo
#     IF tm.c ='Y' THEN
#        DECLARE s_memo1_c CURSOR FOR
#          SELECT oao03,oao05,oao06,oao04 FROM oao_file
#            WHERE oao01 = sr.sfb.sfb22
#              AND oao05 ='0'
#              AND (oao03=0 OR oao03=sr.sfb.sfb221)
#            ORDER BY oao03
 
#        LET l_y='Y'            #PRINT title one time
#        FOREACH s_memo1_c INTO sr4.*
#            IF SQLCA.SQLCODE THEN
#               EXIT FOREACH
#            ELSE
#               IF l_y='Y' THEN    #PRINT title
#                 #No.FUN-670066---Begin
#                    PRINT g_dash2[1,(g_len-FGL_WIDTH(g_x[123]))/2];                        
#                    PRINT COLUMN((g_len-FGL_WIDTH(g_x[123] CLIPPED))/2)+1,g_x[123] CLIPPED; 
#                    PRINT g_dash2[(g_len+FGL_WIDTH(g_x[123]))/2+1,g_len]  
 
#                 #   PRINT g_x[94] CLIPPED,g_x[95] CLIPPED
#                 #No.FUN-670066---End
#                    PRINT COLUMN 10,g_x[96] CLIPPED
#                    PRINT COLUMN 10,g_x[97] CLIPPED
#               END IF
#               PRINT COLUMN 11,sr4.oao03 USING '&&',
#                     COLUMN 16,sr4.oao05,
#                     COLUMN 19,sr4.oao06
#            END IF
#            LET l_y='N'
#        END FOREACH
#     END IF
#     #====================================================NO:6882印麥頭
#     IF tm.d ='Y' THEN
#         LET g_po_no=''
#          SELECT oea01,oea04,oea44,oea10 INTO l_oea01,l_oea04,l_oea44,g_po_no #MOD-530401
#           FROM oea_file              #抓單頭資料
#          WHERE oea01=sr.sfb.sfb22
#          IF SQLCA.SQLCODE THEN
#             LET l_oea01=NULL
#             LET l_oea04=NULL
#             LET l_oea44=NULL
#          END IF
#          OPEN asfr102_curs2 USING l_oea04,l_oea44
#          FETCH asfr102_curs2 INTO sr3.*
#          IF SQLCA.SQLCODE=0 AND NOT cl_null(l_oea04) THEN
#              SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr3.ocf.ocf01
##MOD-530401
#              LET g_ctn_no1=''
#              LET g_ctn_no2=''
#              LET sr3.ocf.ocf101=r102_ocf_c(sr3.ocf.ocf101)
#              LET sr3.ocf.ocf102=r102_ocf_c(sr3.ocf.ocf102)
#              LET sr3.ocf.ocf103=r102_ocf_c(sr3.ocf.ocf103)
#              LET sr3.ocf.ocf104=r102_ocf_c(sr3.ocf.ocf104)
#              LET sr3.ocf.ocf105=r102_ocf_c(sr3.ocf.ocf105)
#              LET sr3.ocf.ocf106=r102_ocf_c(sr3.ocf.ocf106)
#              LET sr3.ocf.ocf107=r102_ocf_c(sr3.ocf.ocf107)
#              LET sr3.ocf.ocf108=r102_ocf_c(sr3.ocf.ocf108)
#              LET sr3.ocf.ocf109=r102_ocf_c(sr3.ocf.ocf109)
#              LET sr3.ocf.ocf110=r102_ocf_c(sr3.ocf.ocf110)
#              LET sr3.ocf.ocf111=r102_ocf_c(sr3.ocf.ocf111)
#              LET sr3.ocf.ocf112=r102_ocf_c(sr3.ocf.ocf112)
#              LET sr3.ocf.ocf201=r102_ocf_c(sr3.ocf.ocf201)
#              LET sr3.ocf.ocf202=r102_ocf_c(sr3.ocf.ocf202)
#              LET sr3.ocf.ocf203=r102_ocf_c(sr3.ocf.ocf203)
#              LET sr3.ocf.ocf204=r102_ocf_c(sr3.ocf.ocf204)
#              LET sr3.ocf.ocf205=r102_ocf_c(sr3.ocf.ocf205)
#              LET sr3.ocf.ocf206=r102_ocf_c(sr3.ocf.ocf206)
#              LET sr3.ocf.ocf207=r102_ocf_c(sr3.ocf.ocf207)
#              LET sr3.ocf.ocf208=r102_ocf_c(sr3.ocf.ocf208)
#              LET sr3.ocf.ocf209=r102_ocf_c(sr3.ocf.ocf209)
#              LET sr3.ocf.ocf210=r102_ocf_c(sr3.ocf.ocf210)
#              LET sr3.ocf.ocf211=r102_ocf_c(sr3.ocf.ocf211)
#              LET sr3.ocf.ocf212=r102_ocf_c(sr3.ocf.ocf212)
##
 
#              IF LINENO>40 THEN SKIP TO TOP OF PAGE END IF
#             #No.FUN-670066---Begin 
#              PRINT g_dash2[1,(g_len-FGL_WIDTH(g_x[122]))/2];                        
#              PRINT COLUMN((g_len-FGL_WIDTH(g_x[122] CLIPPED))/2)+1,g_x[122] CLIPPED; 
#              PRINT g_dash2[(g_len+FGL_WIDTH(g_x[122]))/2+1,g_len]                 
 
#             # PRINT g_x[92] CLIPPED,g_x[93] CLIPPED
#             #No.FUN-670066---End
#              PRINT
#              PRINT COLUMN 10,g_x[88] CLIPPED,sr3.ocf.ocf01,' ',l_occ02,
#                    COLUMN 45,g_x[89] CLIPPED,sr3.ocf.ocf02
#              PRINT '       ------------------------------   ',
#                           '-----------------------------'
#              PRINT COLUMN 21,g_x[90] CLIPPED,
#                    COLUMN 52,g_x[91] CLIPPED
#              PRINT '       ------------------------------   '
#                           ,'-----------------------------'
#              PRINT COLUMN 8,sr3.ocf.ocf101,
#                    COLUMN 41,sr3.ocf.ocf201
#              PRINT COLUMN 8,sr3.ocf.ocf102,
#                    COLUMN 41,sr3.ocf.ocf202
#              PRINT COLUMN 8,sr3.ocf.ocf103,
#                    COLUMN 41,sr3.ocf.ocf203
#              PRINT COLUMN 8,sr3.ocf.ocf104,
#                    COLUMN 41,sr3.ocf.ocf204
#              PRINT COLUMN 8,sr3.ocf.ocf105,
#                    COLUMN 41,sr3.ocf.ocf205
#              PRINT COLUMN 8,sr3.ocf.ocf106,
#                    COLUMN 41,sr3.ocf.ocf206
#              PRINT COLUMN 8,sr3.ocf.ocf107,
#                    COLUMN 41,sr3.ocf.ocf207
#              PRINT COLUMN 8,sr3.ocf.ocf108,
#                    COLUMN 41,sr3.ocf.ocf208
#              PRINT COLUMN 8,sr3.ocf.ocf109,
#                    COLUMN 41,sr3.ocf.ocf209
#              PRINT COLUMN 8,sr3.ocf.ocf110,
#                    COLUMN 41,sr3.ocf.ocf210
#              PRINT COLUMN 8,sr3.ocf.ocf111,
#                    COLUMN 41,sr3.ocf.ocf211
#              PRINT COLUMN 8,sr3.ocf.ocf112,
#                    COLUMN 41,sr3.ocf.ocf212
#          END IF
#     END IF
#     #====================================================NO:6882
 
##No:7967 add
#     IF tm.e ='Y' THEN
#        DECLARE r102_memo1_c CURSOR FOR
#          SELECT sfw02,sfw03 FROM sfw_file
#            WHERE sfw01 = sr.sfb.sfb01
#            ORDER BY sfw02
 
#        LET l_y='Y'
#        FOREACH r102_memo1_c INTO l_sfw02,l_sfw03
#          IF SQLCA.sqlcode THEN
#             CALL cl_err('',SQLCA.sqlcode,0)  
#             EXIT FOREACH
#          END IF
#          IF l_y = 'Y' THEN
#          #No.FUN-670066---Begin
#          PRINT g_dash2[1,(g_len-FGL_WIDTH(g_x[121] CLIPPED))/2];                         
#          PRINT COLUMN((g_len-FGL_WIDTH(g_x[121] CLIPPED))/2)+1,g_x[121] CLIPPED;  
#          PRINT g_dash2[(g_len+FGL_WIDTH(g_x[121] CLIPPED))/2+1,g_len]
#          #No.FUN-670066---End
#         #    PRINT g_x[99] CLIPPED,g_x[95] CLIPPED
#          END IF
#          PRINT COLUMN 11,l_sfw03 CLIPPED
#          LET l_y = 'N'
#        END FOREACH
#     END IF
#     IF l_y = 'N' THEN
#        PRINT ''
#     END IF
##
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'sfb01,sfb02,sfb03,sfb04,sfb05')
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
##TQC-630166-start
#        CALL cl_prt_pos_wc(tm.wc) 
##             IF tm.wc[001,070] > ' ' THEN            # for 80
##        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##             IF tm.wc[071,140] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
##TQC-630166-end
#     END IF
#     LET l_last_sw='y'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
### FUN-550124
#     PRINT
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[9]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[9]
#            PRINT g_memo
#     END IF
## END FUN-550124
 
#END REPORT
#No.FUN-710082--end  
 
 #MOD-530401 add
FUNCTION r102_ocf_c(str)
  DEFINE str    LIKE oea_file.oea10,       #No.FUN-680121 VARCHAR(30)
         i,j    LIKE type_file.num5          #No.FUN-680121 SMALLINT
  # 把麥頭內'PPPPPP'字串改為 P/O NO (oea10)
  # 把麥頭內'CCCCCC'字串改為 CTN NO ('')
  # 把麥頭內'DDDDDD'字串改為 CTN NO ('')
  FOR i=1 TO 20
    LET j=i+5
    IF str[i,j]='PPPPPP' THEN LET str[i,30]=g_po_no   RETURN str END IF
    IF str[i,j]='CCCCCC' THEN LET str[i,30]=g_ctn_no1 RETURN str END IF
    IF str[i,j]='DDDDDD' THEN LET str[i,30]=g_ctn_no2 RETURN str END IF
  END FOR
 RETURN str
 END FUNCTION
##
#Patch....NO.TQC-610037 <001,002> #
#TQC-A60097
