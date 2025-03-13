# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: axcr430.4gl
# Descriptions...: 庫存成本期報表(一)
# Input parameter:
# Return code....:
# Date & Author..: 95/10/20 By Nick
# modify by Ostrich 010627  No.+275
#  1.可跨期間查詢
#  2.可選擇列印單據異動明細
#  3.ccc52 包含 ccc93
#  4.無期初或期末且異動之料件不列印
# Modify ........: No:8628 03/11/12 By Melody 加上 tlf13=apmt230 FOR 代買資料
# Modify ........: No:9450 04/04/14 By Melody 修改tlf10 為tlf10*tlf60
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify ........: No.MOD-4A0351 04/11/01 By Carol sql中起迄年月的判斷有錯
#                                               報表排列調整
# Modify.........: No.FUN-4C0099 05/01/25 By kim 報表轉XML功能
# Modify.........: No.MOD-530048 05/03/21 By ching fix 雜項入庫明細
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.MOD-530252 05/03/27 By ching fix ccg03 SELECT error
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.MOD-550159 05/06/10 By kim 列印 "本月結存調整"
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-580100 05/08/11 By Claire 列印 ima21 -> ima021
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-650001 06/05/23 By Sarah 增加"應列印入庫細項",列印入庫細項資料
# Modify.........: No.MOD-680060 06/08/22 By Claire (1)明細資料應印於入庫而非期初
#                                                   (2)明細再加上ccb_file(axct002)
# Modify.........: No.FUN-680122 06/09/07 By ice 欄位類型修改
# Modify.........: No.FUN-660073 06/09/08 By Nicola 訂單樣品修改
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/13 By ice 修正報表格式錯誤;修正FUN-680122改錯部分
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-710081 07/02/02 By yoyo Crystal report
# Modify.........: No.TQC-730113 07/04/05 By Nicole 增加CR參數
# Modify.........: No.FUN-740023 07/04/09 By Sarah 串cl_prt_cs3()前組的l_sql忘記加上g_cr_db_str字串
# Modify.........: No.MOD-740384 07/04/25 By Carol add run card工單入庫的資料計算
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.CHI-770026 07/07/31 By Carol 加印借料償還單的明細(aimt306,aimt309)
# Modify.........: No.CHI-7B0018 07/11/13 By Sarah 料件明細打勾時,工單領料的資料每個料件都出現相同的金額及數量
# Modify.........: No.CHI-7B0019 07/11/13 By Sarah 出現insert_prep3的錯誤(在INSERT的欄位數量與VALUES的數量不符合)
# Modify.........: No.MOD-7B0134 07/11/14 By Carol 調整CR文字說明及SQL調整
# Modify.........: No.TQC-810067 08/01/21 By Sarah 在Informix環境執行axcr430會出現-999錯誤訊息
# Modify.........: No.MOD-810204 08/01/25 By Pengu 調整FUN-660073修改的SQL語法
# Modify.........: No.MOD-810254 08/01/25 By Pengu 調整OUTER語法
# Modify.........: No.CHI-820012 08/02/25 By jamie 小計、總計錯誤
# Modify.........: No.MOD-820093 08/02/25 By Pengu 還原MOD-810204調整的SQL語法
# Modify.........: No.FUN-7C0101 08/01/24 By ChenMoyan 成本改善報表部分
# Modify.........: No.FUN-830002 08/03/03 By lala    WHERE條件修改
# Modify.........: No.MOD-810254 08/03/23 By Pengu 調整OUTER語法
# Modify.........: No.FUN-820035 08/07/15 By lutingting  雜項入庫雜項出庫增加抓atmt260 atmt261的資料列印
# Modify.........: No.MOD-870120 08/07/22 By Sarah 抓銷貨出庫與樣品出庫的SQL,不要OUTER azf_file,在條件裡直接判斷tlf14有沒有存在azf_file裡,
#                                                  銷貨出庫判斷tlf14存在azf01 WHERE azf08<>'Y',樣品出庫判斷tlf14存在azf01 WHERE azf08 ='Y'
# Modify.........: No.TQC-880015 08/08/12 By lumx  修改傳參數接受的值，避免和tm.mm2重復
# Modify.........: No.MOD-8C0106 09/02/16 By Pengu 會撈取azf03的資料放到變數msg但msg的長度只有50
# Modify.........: No.MOD-8A0117 09/02/19 By Pengu 跑一個區間(多個月份)的時候，明細的數量金額加總後，和小計的數量、金額不一致
# Modify.........: No.MOD-930143 09/03/31 By liuxqa 報表在列印料件明細時，沒有區分重工領用和工單領用，都放在工單領用的下方，需用sfb99來加以區分。
# Modify.........: No.MOD-940201 09/04/14 By chenl 增加雜項領用的報廢類數據。
# Modify.........: NO.MOD-950127 09/05/13 By lutingting l_sql定義改為string
# Modify.........: NO.FUN-980069 09/08/21 By mike 將年度欄位default ccz01月份欄位default ccz02
# Modify.........: NO.MOD-980193 09/08/24 By xiaofeizhu 工單領用需考慮拆件工單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0050 09/11/11 By xiaofeizhu 增加會計科目，成本中心等信息
# Modify.........: No:MOD-9B0138 09/11/24 By sabrina 期初數量金額與期末數量金額會累加
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.CHI-9B0012 10/01/26 By wuxj  新增報表呈現方式
# Modify.........: No.TQC-A50166 10/06/01 By Carrier MOD-990066 & CHI-950048追单
# Modify.........: No.MOD-A80150 10/08/23 By sabrina 將NOT cl_null(sr2.ima12)改為sr2.ima12 NOT NULL，
#                                                    不然ima12=' '會取不到空白成本分群的前期成本
# Modify.........: No.MOD-AC0391 10/12/29 By sabrina 修正TQC-A50166 
# Modify.........: No:MOD-B30619 11/03/30 By Summer 轉換MATCHES 
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:MOD-B90185 11/09/26 By johung 修正工單轉出差異未列入明細問題
#                                                   修正寫入日期欄位的INSERT語法
# Modify.........: No:MOD-B90238 11/09/28 By sabrina 如果是重工工單入庫，明細應放在重工工單欄位顯示而非一般工單 
# Modify.........: No.CHI-BB0010 11/11/09 By kim 本月入庫應該要扣除銷退入庫成本,而將銷退入庫放再銷售出貨的減項
# Modify.........: No.MOD-C30052 12/03/07 By Elise 數量欄位皆在4gl先依ccz27進行取位，再寫到temp table
# Modify.........: No.CHI-C50025 12/05/14 By bart 1.程式中xxx_cs的部分是在抓未入庫即結案的資料
#                                                   需再加上"部分入庫已結案"，但ccg32金額與tlf21金額不符的資料(flag給'01')
#                                                 2.生產入庫的部分需區分一般工單及委外工單(flag給'17')
# Modify.........: No:MOD-C60150 12/06/18 By ck2yuan 銷退入庫對銷售出貨應是加項
# Modify.........: No:MOD-C70004 12/07/03 By ck2yuan 在判斷ccc欄位不可為0部分,多判斷幾個欄位
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:TQC-C80054 12/08/07 By lujh 倉庫tlf031改抓tlf902，tlf032改抓tlf903
# Modify.........: No:TQC-D10068 13/01/17 By wujie CHI-C50025写错，sql中应该使用b_date,e_date,而不是bdate，edate
# Modify.........: No:MOD-D10152 13/02/19 By bart 多倉儲出貨，報表上只會顯示其中一筆
# Modify.........: No:CHI-D10041 13/01/23 By bart 在報表中少了“銷退入庫“
# Modify.........: No:MOD-D20166 13/03/01 By bart 拆件式工單元件顯在工單領用

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
              wc       LIKE type_file.chr1000,#Where condition #No.FUN-680122 VARCHAR(300)
              yy,mm    LIKE type_file.num5,   #No.FUN-680122 SMALLINT
              type     LIKE type_file.chr1,   #No.FUN-7C0101
              yy2,mm2  LIKE type_file.num5,   #No.FUN-680122 SMALLINT
              azh01    LIKE azh_file.azh01,   #No.FUN-680122 VARCHAR(10)
              azh02    LIKE azh_file.azh02,   #No.FUN-680122 VARCHAR(40)
              n        LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(1)
              b        LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(1)
              c        LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(1)
              d        LIKE type_file.chr1,   #FUN-650001 add #No.FUN-680122 VARCHAR(1)
              line     LIKE type_file.chr1,   #CHI-9B0012  add
              more     LIKE type_file.chr1    #Input more condition(Y/N) #No.FUN-680122 VARCHAR(1)
           END RECORD,
       g_tot_bal       LIKE ccq_file.ccq03    #User defined variable #No.FUN-680122 DECIMAL(13,2)
DEFINE bdate,b_date    LIKE type_file.dat     #No.FUN-680122 DATE
DEFINE edate,e_date    LIKE type_file.dat     #No.FUN-680122 DATE
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
DEFINE g_i             LIKE type_file.num5    #count/index FOR any purpose  #No.FUN-680122 SMALLINT
DEFINE   g_sql         STRING
DEFINE   l_table       STRING
DEFINE   l_table1      STRING
DEFINE   l_table2      STRING
DEFINE   g_msg         LIKE azf_file.azf03
DEFINE   l_str         STRING

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo

   LET g_pdate = ARG_VAL(1)        # Get arguments FROM commAND line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.yy2 = ARG_VAL(10)
   LET tm.mm2 = ARG_VAL(11)
   LET tm.azh02 = ARG_VAL(12)
   LET tm.azh01 = ARG_VAL(13)
   LET tm.b = ARG_VAL(14)
   LET tm.c = ARG_VAL(15)
   LET tm.d = ARG_VAL(16)   #FUN-650001 add
   LET tm.line = ARG_VAL(17) #CHI-9B0012 add
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
    LET g_rpt_name = ARG_VAL(21)  #TQC-880015


   LET g_sql = "ccc01.ccc_file.ccc01,  ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,ima25.ima_file.ima25,",
               "ima12.ima_file.ima12,  ccc11.ccc_file.ccc11,",
               "ccc12.ccc_file.ccc12,  ccc21.ccc_file.ccc21,",
               "ccc27.ccc_file.ccc27,  ccc28.ccc_file.ccc28,",
               "ccc211.ccc_file.ccc211,ccc221.ccc_file.ccc221,",
               "ccc212.ccc_file.ccc212,ccc222.ccc_file.ccc222,",
               "ccc213.ccc_file.ccc213,ccc223.ccc_file.ccc223,",
               "ccc214.ccc_file.ccc214,ccc224.ccc_file.ccc224,",
               "ccc215.ccc_file.ccc215,ccc225.ccc_file.ccc225,",
               "ccc216.ccc_file.ccc216,ccc226.ccc_file.ccc226,",  #CHI-D10041
               "ccc31.ccc_file.ccc31,  ccc25.ccc_file.ccc25,",
               "ccc32.ccc_file.ccc32,  ccc26.ccc_file.ccc26,",
               "ccc41.ccc_file.ccc41,  ccc42.ccc_file.ccc42,",
               "ccc52.ccc_file.ccc52,  ccc93.ccc_file.ccc93,",
               "ccc51.ccc_file.ccc51,  ccc61.ccc_file.ccc61,",
               "ccc62.ccc_file.ccc62,  ccc81.ccc_file.ccc81,",
               "ccc82.ccc_file.ccc82,  ccc71.ccc_file.ccc71,",
               "ccc72.ccc_file.ccc72,  ccc91.ccc_file.ccc91,",
               "ccc92.ccc_file.ccc92,  ccb22.ccb_file.ccb22,",
               "yy.type_file.num5,     mm.type_file.num5,",
               "yy2.type_file.num5,    mm2.type_file.num5,",
               "ccz27.ccz_file.ccz27,",                        #CHI-820012 mod
               "azi03.azi_file.azi03,  ccc22.ccc_file.ccc22,", #CHI-7B0018 add ccc22
               "ccc08.ccc_file.ccc08"  #CHI-820012 add
   LET l_table = cl_prt_temptable('axcr430',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF


  #tlf_file+ccg_file
   LET g_sql = "tlf01.tlf_file.tlf01,",
               "tlf06.tlf_file.tlf06,",
               "tlf905.tlf_file.tlf905,",
               "tlf906.tlf_file.tlf906,",
               "tlf10.tlf_file.tlf10,",
              #------------No:TQC-A50166 modify
               "tlf21.tlf_file.tlf21,",
              #"tlfc21.tlfc_file.tlfc21,",        #No.FUN-7C0101
              #------------No:TQC-A50166 end
               "tlf907.tlf_file.tlf907,",
               "sfb99.sfb_file.sfb99,",           #No.MOD-930143 add
               "tlfccost.tlfc_file.tlfccost,",    #No.FUN-7C0101
               "flag.type_file.chr2,",
               "ccg04.ccg_file.ccg04,",
               "ccg01.ccg_file.ccg01,",
               "ccg31.ccg_file.ccg31,",
               "ccg32.ccg_file.ccg32,",
               "ccg07.ccg_file.ccg07,",             #CHI-820012 add
               "ima39.ima_file.ima39,",                                           #FUN-9A0050
               "ima391.ima_file.ima391,",                                         #FUN-9A0050
               "tlf930.tlf_file.tlf930"                                           #FUN-9A0050
   LET l_table1 = cl_prt_temptable('axcr4301',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF

  #小計
   LET g_sql = "ima12.ima_file.ima12,",
               "ccc08.ccc_file.ccc08,",     #TQC-A50166
               "sum_ccc11.ccc_file.ccc11,   sum_ccc12.ccc_file.ccc12,",
               "sum_ccc21_27.ccc_file.ccc21,sum_ccc22_28.ccc_file.ccc22,",
               "sum_ccc211.ccc_file.ccc211, sum_ccc221.ccc_file.ccc221,",
               "sum_ccc212.ccc_file.ccc212, sum_ccc222.ccc_file.ccc222,",
               "sum_ccc213.ccc_file.ccc213, sum_ccc223.ccc_file.ccc223,",
               "sum_ccc214.ccc_file.ccc214, sum_ccc224.ccc_file.ccc224,",
               "sum_ccc215.ccc_file.ccc215, sum_ccc225.ccc_file.ccc225,",
               "sum_ccc216.ccc_file.ccc216, sum_ccc226.ccc_file.ccc226,",  #CHI-D10041
               "sum_ccc25.ccc_file.ccc25,   sum_ccc26.ccc_file.ccc26,",
               "sum_ccc27.ccc_file.ccc27,   sum_ccc28.ccc_file.ccc28,",
               "sum_ccc31_25.ccc_file.ccc31,sum_ccc32_26.ccc_file.ccc32,",
               "sum_ccc41.ccc_file.ccc41,   sum_ccc42.ccc_file.ccc42,",
               "sum_ccc52_93.ccc_file.ccc52,sum_ccc51.ccc_file.ccc51,",
               "sum_ccc61.ccc_file.ccc61,   sum_ccc62.ccc_file.ccc62,",
               "sum_ccc81.ccc_file.ccc81,   sum_ccc82.ccc_file.ccc82,",
               "sum_ccc71.ccc_file.ccc71,   sum_ccc72.ccc_file.ccc72,",
               "sum_ccc91.ccc_file.ccc91,   sum_ccc92.ccc_file.ccc92,",
               "msg.azf_file.azf03"      #No.MOD-8C0106 modify
   LET l_table2 = cl_prt_temptable('axcr4302',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL axcr430_tm(0,0)
   ELSE
      CALL axcr430()
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
END MAIN

FUNCTION axcr430_tm(p_row,p_col)
   DEFINE lc_qbe_sn    LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,   #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(400)

   LET p_row = 5 LET p_col = 20

   OPEN WINDOW axcr430_w AT p_row,p_col
     WITH FORM "axc/42f/axcr430"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN


   CALL cl_ui_init()

   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b    = 'Y'
   LET tm.c    = 'Y'
   LET tm.d    = 'Y'   #FUN-650001 add
   LET tm.line = '1'   #CHI-9B0012 add
   LET tm.more = 'N'
   LET tm.yy   =  g_ccz.ccz01 #FUN-980069 year( today)-->g_ccz.ccz01
   LET tm.mm   =  g_ccz.ccz02 #FUN-980069 month( today)-->g_ccz.ccz02
   LET tm.yy2  =  g_ccz.ccz01 #FUN-980069 year( today)-->g_ccz.ccz01
   LET tm.mm2  =  g_ccz.ccz02 #FUN-980069 month( today)-->g_ccz.ccz02
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima01,ima39,ima57,ima08,
                                 ima06,ima09,ima10,ima11,ima12

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION CONTROLP
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF

         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121

         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121

         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON ACTION qbe_SELECT
            CALL cl_qbe_SELECT()

      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF


      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axcr430_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
         EXIT PROGRAM
      END IF

     #LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'" #MOD-B30619 mark
      LET tm.wc=tm.wc CLIPPED," AND ima01 NOT IN 'MISC%'"      #MOD-B30619

      INPUT BY NAME tm.yy,tm.mm,tm.yy2,tm.mm2,tm.type,tm.azh02,tm.azh01,   #No.FUN-7C0101 mod
                    tm.b,tm.c,tm.d,tm.line,tm.more   #FUN-650001 add tm.d   #CHI-9B0012 tm.line
          WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD yy
            IF tm.yy IS NULL THEN NEXT FIELD yy END IF

         AFTER FIELD mm
            IF tm.mm IS NULL THEN NEXT FIELD mm END IF

         AFTER FIELD yy2
            IF tm.yy2 IS NULL THEN NEXT FIELD yy2 END IF
            IF tm.yy2 < tm.yy THEN
               NEXT FIELD yy2
            END IF

         AFTER FIELD type
            IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF

         AFTER FIELD mm2
            IF tm.mm2 IS NULL THEN NEXT FIELD mm2 END IF

         AFTER FIELD azh01
            SELECT azh02 INTO tm.azh02 FROM azh_file WHERE azh01=tm.azh01
            DISPLAY BY NAME tm.azh02

         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(azh01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azh'
                  LET g_qryparam.default1 = tm.azh01
                  LET g_qryparam.default2 = tm.azh02
                  CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
                  DISPLAY BY NAME tm.azh01,tm.azh02
            END CASE

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

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

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF tm.yy2 < tm.yy THEN
               NEXT FIELD yy2
            END IF
            IF tm.yy2 = tm.yy THEN
               IF tm.mm > tm.mm2 THEN
                  NEXT FIELD mm2
               END IF
            END IF

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axcr430_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axcr430'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axcr430','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.yy2 CLIPPED,"'",
                        " '",tm.mm2 CLIPPED,"'",
                        " '",tm.azh02 CLIPPED,"'",
                        " '",tm.azh01 CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",                 #FUN-650001 add
                        " '",tm.line CLIPPED,"'",              #CHI-9B0012  add
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axcr430',g_time,l_cmd)    # Execute cmd at later time
         END IF

         CLOSE WINDOW axcr430_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
         EXIT PROGRAM
      END IF

      CALL cl_wait()

      CALL axcr430()

      ERROR ""
   END WHILE

   CLOSE WINDOW axcr430_w

END FUNCTION

FUNCTION axcr430()
   DEFINE l_name   LIKE type_file.chr20,      # External(Disk) file name  #No.FUN-680122 VARCHAR(20)
          l_sql    STRING,                     #No.MOD-950127
          l_chr    LIKE type_file.chr1,       #No.FUN-680122 VARCHAR(1)
          l_za05   LIKE za_file.za05,         #No.FUN-680122 VARCHAR(40)
          l_ccc01_t LIKE ccc_file.ccc01,       #No.MOD-8A0117 add
          l_ccc08_t LIKE ccc_file.ccc08,       #No:TQC-A50166 add
          ccc      RECORD LIKE ccc_file.*,
          ima      RECORD LIKE ima_file.*

 DEFINE  l_ccb22 LIKE ccb_file.ccb22
 DEFINE  l_gaz03 LIKE gaz_file.gaz03


   DEFINE sr1  RECORD
                tlf01    LIKE tlf_file.tlf01,
                tlf06    LIKE tlf_file.tlf06,
                tlf905   LIKE tlf_file.tlf905,
                tlf906   LIKE tlf_file.tlf906,
                tlf10    LIKE tlf_file.tlf10,
                tlfc21   LIKE tlfc_file.tlfc21,    #No.FUN-7C0101 mod
                tlf907   LIKE tlf_file.tlf907,
                sfb99    LIKE sfb_file.sfb99,     #No.MOD-930143
                tlfccost LIKE tlfc_file.tlfccost,  #No.FUN-7C0101 add
                tlf902   LIKE tlf_file.tlf902,    #TQC-C80054 add
                tlf903   LIKE tlf_file.tlf903     #TQC-C80054 add
               END RECORD,

          xxx  RECORD
                ccg04    LIKE ccg_file.ccg04,
                ccg01    LIKE ccg_file.ccg01,
                ccg31    LIKE ccg_file.ccg31,
                ccg32    LIKE ccg_file.ccg32,
                ccg07    LIKE ccg_file.ccg07      #CHI-820012 add
               END RECORD,

          sr2  RECORD
                ima12 LIKE ima_file.ima12,
                ccc08 LIKE ccc_file.ccc08,          #MOD-9B0138 add
                sum_ccc11 LIKE ccc_file.ccc11,
                sum_ccc12 LIKE ccc_file.ccc12,
                sum_ccc21_27 LIKE ccc_file.ccc21,
                sum_ccc22_28 LIKE ccc_file.ccc22,
                sum_ccc211 LIKE ccc_file.ccc211,
                sum_ccc221 LIKE ccc_file.ccc221,
                sum_ccc212 LIKE ccc_file.ccc212,
                sum_ccc222 LIKE ccc_file.ccc222,
                sum_ccc213 LIKE ccc_file.ccc213,
                sum_ccc223 LIKE ccc_file.ccc223,
                sum_ccc214 LIKE ccc_file.ccc214,
                sum_ccc224 LIKE ccc_file.ccc224,
                sum_ccc215 LIKE ccc_file.ccc215,
                sum_ccc225 LIKE ccc_file.ccc225,
                sum_ccc216 LIKE ccc_file.ccc216,  #CHI-D10041
                sum_ccc226 LIKE ccc_file.ccc226,  #CHI-D10041
                sum_ccc25 LIKE ccc_file.ccc25,
                sum_ccc26 LIKE ccc_file.ccc26,
                sum_ccc27 LIKE ccc_file.ccc27,
                sum_ccc28 LIKE ccc_file.ccc28,
                sum_ccc31_25 LIKE ccc_file.ccc31,
                sum_ccc32_26 LIKE ccc_file.ccc32,
                sum_ccc41 LIKE ccc_file.ccc41,
                sum_ccc42 LIKE ccc_file.ccc42,
                sum_ccc52_93 LIKE  ccc_file.ccc52,
                sum_ccc51 LIKE ccc_file.ccc51,
                sum_ccc61 LIKE ccc_file.ccc61,
                sum_ccc62 LIKE ccc_file.ccc62,
                sum_ccc81 LIKE ccc_file.ccc81,
                sum_ccc82 LIKE ccc_file.ccc82,
                sum_ccc71 LIKE ccc_file.ccc71,
                sum_ccc72 LIKE ccc_file.ccc72,
                sum_ccc91 LIKE ccc_file.ccc91,
                sum_ccc92 LIKE ccc_file.ccc92
               END RECORD
 DEFINE l_tlf031     LIKE tlf_file.tlf031                #No.FUN-9A0050
 DEFINE l_tlf032     LIKE tlf_file.tlf032                #No.FUN-9A0050
 DEFINE l_tlf930     LIKE tlf_file.tlf930                #No.FUN-9A0050
 DEFINE l_ima39      LIKE ima_file.ima39                 #No.FUN-9A0050
 DEFINE l_ima391     LIKE ima_file.ima391                #No.FUN-9A0050
 DEFINE l_ccz07      LIKE ccz_file.ccz07                 #No.FUN-9A0050
 DEFINE l_sfb02      LIKE sfb_file.sfb02                 #CHI-C50025
 DEFINE l_cnt        LIKE type_file.num5    #MOD-D10152
 DEFINE l_tlf62      LIKE tlf_file.tlf62    #MOD-D20166
 
   #清除暫存檔資料
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?)" #CHI-820012 add 1? #CHI-820012拿掉3?  #CHI-7B0018 add ? #CHI-D10041 add 2?
   PREPARE insert_prept111 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF


   ##tlf_file+ccg_file
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?)"  #CHI-820012 add 1? #FUN-7C0101 add ? #No.MOD-930143 add ? #FUN-9A0050 Add ?,?,?
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
       CALL cl_err('insert_prep1:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
       EXIT PROGRAM
   END IF

   ##小計
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"         #CHI-9B0012   add ?  #CHI-D10041 add 2?
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
       CALL cl_err('insert_prep2:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
       EXIT PROGRAM
   END IF
   
   #MOD-D10152---begin
   LET g_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " WHERE tlf01 = ? AND tlf06 = ? AND tlf905 = ? AND tlf906 = ?"
   PREPARE sr6_perp2 FROM g_sql
   IF STATUS THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       CALL cl_err('sr6_perp2:',STATUS,1) EXIT PROGRAM
   END IF
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " SET tlf10 = tlf10+? , tlf21 = tlf21+? ",
               " WHERE tlf01 = ? AND tlf06 = ? AND tlf905 = ? AND tlf906 = ?"
   PREPARE sr6_perp3 FROM g_sql 
   IF STATUS THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       CALL cl_err('sr6_perp3:',STATUS,1) EXIT PROGRAM
   END IF   
   #MOD-D10152---end
   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axcr430'
   SELECT gaz03 INTO l_gaz03 FROM gaz_file WHERE gaz01 = g_prog AND gaz02=g_rlang
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

   CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate

   LET b_date = bdate

   CALL s_azm(tm.yy2,tm.mm2) RETURNING g_chr,bdate,edate

   LET e_date = edate

   LET l_sql = "SELECT ccc_file.*, ima_file.*",
               "  FROM ccc_file, ima_file",
               " WHERE ",tm.wc CLIPPED,
               "   AND (ccc02*12+ccc03 BETWEEN " ,tm.yy*12+tm.mm,
               "   AND ",tm.yy2*12+tm.mm2 ,") AND ccc01=ima01 " CLIPPED,
               "   AND ccc07='",tm.type,"'",   #No.FUN-7C0101 add
               "   ORDER BY ccc01 "     #No.MOD-8A0117 add

   PREPARE axcr430_PREPARE1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('PREPARE:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF

   DECLARE axcr430_curs1 CURSOR FOR axcr430_PREPARE1

   #雜項入庫
   LET l_sql = "SELECT tlf01,tlf06,tlf905,tlf906,tlf10*tlf60,tlfc21,tlf907,'',tlfccost,tlf902,tlf903,tlf031,tlf032,tlf930",  #No.FUN-7C0101 mod  #FUN-9A0050 Add tlf031,tlf032,tlf930       #TQC-C80054 add  tlf902,tlf903
               "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype = '",tm.type,"'",                                      #No.FUN-7C0101 mod
               " WHERE tlf01 = ?",
              #"   AND tlfccost = ?",  #TQC-A50166      #MOD-AC0391 mark
               "   AND tlfc_file.tlfccost = ?",         #MOD-AC0391 add
               "   AND (tlf13='aimt302' OR tlf13='aimt312' OR tlf13='aimt306' OR tlf13 = 'aimt309' OR tlf13 = 'atmt260' OR tlf13 = 'atmt261' )",  #CHI-770026 modify  #FUN-820035
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
               "   AND tlf06 BETWEEN '",b_date,"' AND '",e_date,"'",
               " ORDER BY tlf06 "
   PREPARE sr1_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('sr1_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
   DECLARE sr1_cs CURSOR FOR sr1_pre

   #採購入庫
   LET l_sql = "SELECT tlf01,tlf06,tlf905,tlf906,tlf10*tlf60,tlfc21,tlf907,'',tlfccost,tlf902,tlf903,tlf031,tlf032,tlf930",  #No.FUN-7C0101 mod  #FUN-9A0050 Add tlf031,tlf032,tlf930  #CHI-9B0012 add ''      #TQC-C80054 add  tlf902,tlf903
               "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype = '",tm.type,"'",                                      #No.FUN-7C0101 mod
               " WHERE tlf01 = ?",
              #"   AND tlfccost = ?",  #TQC-A50166      #MOD-AC0391 mark
               "   AND tlfc_file.tlfccost = ?",         #MOD-AC0391 add
               "   AND (tlf13='apmt150' OR tlf13='apmt1072')",
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
               "   AND tlf06 BETWEEN '",b_date,"' AND '",e_date,"'",
               " ORDER BY tlf06 "
   PREPARE sr2_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('sr2_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
   DECLARE sr2_cs CURSOR FOR sr2_pre

   #工單入庫
   LET l_sql = "SELECT tlf01,tlf06,tlf905,tlf906,tlf10*tlf60,tlfc21,tlf907,sfb99,tlfccost,tlf902,tlf903,tlf031,tlf032,tlf930",  #No.FUN-7C0101 mod #FUN-9A0050 Add tlf031,tlf032,tlf930 #FUN-A30031  add ''     #TQC-C80054 add  tlf902,tlf903
               " ,sfb02",  #CHI-C50025
               "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype = '",tm.type,"',sfb_file ",                            #No.FUN-7C0101 mod
               " WHERE tlf01 = ?",
              #"   AND tlfccost = ?",  #TQC-A50166      #MOD-AC0391 mark
               "   AND tlfc_file.tlfccost = ?",         #MOD-AC0391 add
               "   AND tlf62=sfb01",    #CHI-9B0012   add
               "   AND sfb02!='11'",
               "   AND (tlf13='asft6201' OR tlf13='asft6101' OR tlf13='asft6231' )",  #MOD-740384 add  tlf13='asft6231'
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
               "   AND tlf06 BETWEEN '",b_date,"' AND '",e_date,"'",
               " ORDER BY tlf06"
   PREPARE sr3_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('sr3_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
   DECLARE sr3_cs CURSOR FOR sr3_pre

   #xxx入庫
   #LET l_sql = "SELECT ccg04,ccg01,ccg31,ccg32,ccg07",   #CHI-820012 add ccg07#CHI-7B0019 mod   #MOD-B90185 mark
   #LET l_sql = "SELECT ccg04,ccg01,ccg31,ccg32*(-1),ccg07",                   #MOD-B90185  #CHI-C50025 mark
   LET l_sql = "SELECT ccg04,ccg01,ccg31,ccg32*(-1),ccg07,sfb02",   #CHI-C50025
               "  FROM ccg_file,ima_file,sfb_file",
               " WHERE ccg04 = ?",
               "   AND ima01=ccg04",          #MOD-7B0134-modify ccg01->ccg04
               "   AND ccg01=sfb01",
               "   AND ccg31=0 ",
               "   AND ccg32<>0 ",   #MOD-B90185 add
               "   AND (ccg02*12+ccg03 BETWEEN " ,tm.yy*12+tm.mm," AND ", #MOD-530252
               tm.yy2*12+tm.mm2 ,") " CLIPPED,
               "   AND ccg06='",tm.type,"'"       #No.FUN-7C0101
   PREPARE xxx_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('xxx_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
   DECLARE xxx_cs CURSOR FOR xxx_pre

   #CHI-C50025---begin
   LET l_sql = "SELECT ccg_file.ccg04,ccg_file.ccg01,0,-1*(b+c),ccg_file.ccg07,sfb_file.sfb02", 
               "  FROM ccg_file,sfb_file",              
               "       ,(SELECT ccg01,SUM(ccg32) as b FROM ccg_file,sfb_file",
               "          WHERE (ccg02*12+ccg03 BETWEEN ",tm.yy*12+tm.mm," AND ",tm.yy2*12+tm.mm2,")",
               "            AND ccg04 = ? AND ccg01 = sfb01 AND sfb04 = 8",
               "          GROUP BY ccg01) ccgsum",
               "       ,(SELECT tlf62,SUM(tlf907*tlf21) as c FROM tlf_file,sfb_file",
               "          WHERE tlf01 = ? AND tlf06 >='",b_date,"' AND tlf06 <='",e_date,"'",    #No.TQC-D10068
               "            AND tlf13 LIKE 'asft6%' AND tlf907 <> 0",
               "            AND tlf62 = sfb01 AND sfb04 = 8",
               "          GROUP BY tlf62) tlfsum",
               " WHERE ccg_file.ccg04 = ?",
               "   AND ccg_file.ccg01 = ccgsum.ccg01",
               "   AND ccg_file.ccg01 = tlfsum.tlf62",
               "   AND ccg_file.ccg31<>0 ",
               "   AND (b+c) <>0 ",
               "   AND (ccg_file.ccg02*12+ccg_file.ccg03 BETWEEN " ,tm.yy*12+tm.mm," AND ",
               tm.yy2*12+tm.mm2 ,") " CLIPPED,
               "   AND ccg_file.ccg01 = sfb_file.sfb01 AND sfb_file.sfb04 = 8",
               "   AND ccg_file.ccg06='",tm.type,"'"
   PREPARE xxx1_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('xxx1_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE xxx1_cs CURSOR FOR xxx1_pre
   #CHI-C50025---end
   
   #雜項出庫
   LET l_sql = "SELECT tlf01,tlf06,tlf905,tlf906,tlf10*tlf60,tlfc21,tlf907,'',tlfccost,tlf902,tlf903,tlf031,tlf032,tlf930",  #No.FUN-7C0101 mod  #FUN-9A0050 Add tlf031,tlf032,tlf930  #CHI-9B0012 add ''    #TQC-C80054 add  tlf902,tlf903 
               "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype = '",tm.type,"'",                                      #No.FUN-7C0101 mod
               " WHERE tlf01 = ?",
              #"   AND tlfccost = ?",  #TQC-A50166      #MOD-AC0391 mark
               "   AND tlfc_file.tlfccost = ?",         #MOD-AC0391 add
               "   AND (tlf13='aimt301' OR tlf13='aimt311' OR tlf13 = 'atmt260' OR tlf13 = 'atmt261' OR tlf13='aimt303' OR tlf13='aimt313')",  #FUN-820035 #No.MOD-940201 add aimt303,aimt313
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
               "   AND tlf06 BETWEEN '",b_date,"' AND '",e_date,"'",
               " ORDER BY tlf06"
   PREPARE sr4_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('sr4_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
   DECLARE sr4_cs CURSOR FOR sr4_pre

   #工單領用
   LET l_sql = "SELECT tlf01,tlf06,tlf905,tlf906,tlf10*tlf60,tlfc21,tlf907,sfb99,tlfccost,tlf902,tlf903,tlf031,tlf032,tlf930",#No.MOD-930143 add sfb99,    #No.FUN-7C0101 mod  #CHI-820012 mod  #No:9450 #FUN-9A0050 Add tlf031,tlf032,tlf930     #TQC-C80054 add  tlf902,tlf903
               "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype = '",tm.type,"',sfb_file ",                              #No.FUN-7C0101 mod
               " WHERE tlf01 = ?",
              #"   AND tlfccost = ?",  #TQC-A50166      #MOD-AC0391 mark
               "   AND tlfc_file.tlfccost = ?",         #MOD-AC0391 add
               "   AND tlf62=sfb01",   #CHI-9B0012   add
               "   AND (tlf13 LIKE 'asfi5%')",
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
               "   AND tlf06 BETWEEN '",b_date,"' AND '",e_date,"'",
               " ORDER BY tlf06"
   PREPARE sr5_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('sr5_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
   DECLARE sr5_cs CURSOR FOR sr5_pre

#拆件
   LET l_sql = "SELECT tlf01,tlf06,tlf905,tlf906,tlf10*tlf60,tlfc21,tlf907,sfb99,tlfccost,tlf902,tlf903,tlf031,tlf032,tlf930,tlf62",    #FUN-9A0050 Add tlf031,tlf032,tlf930     #TQC-C80054 add  tlf902,tlf903  #MOD-D20166 add tlf62
               "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype = '",tm.type,"',sfb_file ",
               " WHERE tlf01 = ?",
              #"   AND tlfccost = ?",  #TQC-A50166      #MOD-AC0391 mark
               "   AND tlfc_file.tlfccost = ?",         #MOD-AC0391 add
               "   AND tlf62=sfb01",     #CHI-9B0012   add
               "   AND sfb02='11'",
               "   AND (tlf13='asft6201' OR tlf13='asft6101' OR tlf13='asft6231' )",
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
               "   AND tlf06 BETWEEN '",b_date,"' AND '",e_date,"'",
               " ORDER BY tlf06"
   PREPARE sr5_pre1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('sr5_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE sr5_cs1 CURSOR FOR sr5_pre1

   #銷貨出庫
   LET l_sql = "SELECT tlf01,tlf06,tlf905,tlf906,tlf10*tlf60,tlfc21,tlf907,'',tlfccost,tlf902,tlf903,tlf031,tlf032,tlf930", #FUN-7C0101 mod  #FUN-9A0050 Add tlf031,tlf032,tlf930 #CHI-9B0012 add ''     #TQC-C80054 add  tlf902,tlf903
               "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype = '",tm.type,"'",                                     #FUN-7C0101 mod  #MOD-870120
               " WHERE tlf01 = ?",
              #"   AND tlfccost = ?",  #TQC-A50166      #MOD-AC0391 mark
               "   AND tlfc_file.tlfccost = ?",         #MOD-AC0391 add
               " AND ( tlf14 IS NULL OR",
               "      (tlf14 IS NOT NULL AND ",
               "       tlf14 NOT IN (SELECT azf01 FROM azf_file WHERE azf08='Y')))",
               "   AND (tlf13 LIKE 'axmt%' OR tlf13 LIKE 'aomt%')",
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
               "   AND tlf06 BETWEEN '",b_date,"' AND '",e_date,"'",
               " ORDER BY tlf06"
   PREPARE sr6_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('sr6_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
   DECLARE sr6_cs CURSOR FOR sr6_pre

   #樣品出庫
   LET l_sql = "SELECT tlf01,tlf06,tlf905,tlf906,tlf10*tlf60,tlfc21,tlf907,'',tlfccost,tlf902,tlf903,tlf031,tlf032,tlf930", #FUN-7C0101 mod #CHI-820012 mod  #FUN-9A0050 Add tlf031,tlf032,tlf930 #CHI-9B0012   add ''     #TQC-C80054 add  tlf902,tlf903
               "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype = '",tm.type,"'",                                     #FUN-7C0101 mod  #MOD-870120
               " WHERE tlf01 = ?",
              #"   AND tlfccost = ?",  #TQC-A50166      #MOD-AC0391 mark
               "   AND tlfc_file.tlfccost = ?",         #MOD-AC0391 add
               " AND (tlf14 IS NOT NULL AND ",
               "      tlf14 IN (SELECT azf01 FROM azf_file WHERE azf08='Y'))",
               "   AND (tlf13 LIKE 'axmt%' OR tlf13 LIKE 'aomt%')",
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
               "   AND tlf06 BETWEEN '",b_date,"' AND '",e_date,"'",
               " ORDER BY tlf06"
   PREPARE sr8_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('sr8_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
   DECLARE sr8_cs CURSOR FOR sr8_pre

   #盤盈虧
   LET l_sql = "SELECT tlf01,tlf06,tlf905,tlf906,tlf10*tlf60,tlfc21,tlf907,'',tlfccost,tlf902,tlf903,tlf031,tlf032,tlf930", #FUN-7C0101 mod #CHI-820012 mod  #No:9450 #FUN-9A0050 Add tlf031,tlf032,tlf930   #CHI-9B0012  add ''     #TQC-C80054 add  tlf902,tlf903
               "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype = '",tm.type,"'",                                    #FUN-7C0101 mod
               " WHERE tlf01 = ?",
              #"   AND tlfccost = ?",  #TQC-A50166      #MOD-AC0391 mark
               "   AND tlfc_file.tlfccost = ?",         #MOD-AC0391 add
               "   AND tlf13='aimp880'",
               "   AND tlf10 <>0",
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
               "   AND tlf06 BETWEEN '",b_date,"' AND '",e_date,"'",
               " ORDER BY tlf06"
   PREPARE sr7_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('sr7_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
   DECLARE sr7_cs CURSOR FOR sr7_pre


   LET l_ccc01_t = NULL        #No.MOD-8A0117 add
   LET l_ccc08_t = ' '        #No:TQC-A50166
   FOREACH axcr430_curs1 INTO ccc.*, ima.*
      IF STATUS THEN
         CALL cl_err('FOREACH:',STATUS,1)
         EXIT FOREACH
      END IF
      IF ccc.ccc08 IS NULL THEN LET ccc.ccc08 = ' ' END IF  #TQC-A50166

      #-------工單領用-----------------
      IF NOT (ccc.ccc02 = tm.yy AND ccc.ccc03 = tm.mm) THEN
         LET ccc.ccc11 = 0
         LET ccc.ccc12 = 0
      END IF
      IF NOT (ccc.ccc02 = tm.yy2 AND ccc.ccc03 = tm.mm2) THEN
         LET ccc.ccc91 = 0
         LET ccc.ccc92 = 0
      END IF
      #-----


      IF ccc.ccc11=0 AND ccc.ccc12=0 AND ccc.ccc21=0 AND ccc.ccc22=0 AND
         ccc.ccc25=0 AND ccc.ccc26=0 AND ccc.ccc27=0 AND ccc.ccc28=0 AND
         ccc.ccc211=0 AND ccc.ccc221=0 AND ccc.ccc212=0 AND ccc.ccc222=0 AND   #MOD-C70004 add
         ccc.ccc213=0 AND ccc.ccc223=0 AND ccc.ccc214=0 AND ccc.ccc224=0 AND   #MOD-C70004 add
         #ccc.ccc215=0 AND ccc.ccc223=0 AND                                     #MOD-C70004 add  #CHI-D10041
         ccc.ccc215=0 AND ccc.ccc225=0 AND ccc.ccc216=0 AND ccc.ccc226=0 AND  #CHI-D10041
         ccc.ccc31=0 AND ccc.ccc32=0 AND ccc.ccc41=0 AND ccc.ccc42=0 AND
         ccc.ccc43=0 AND ccc.ccc44=0 AND ccc.ccc51=0 AND ccc.ccc52=0 AND
         ccc.ccc61=0 AND ccc.ccc62=0 AND ccc.ccc64=0 AND ccc.ccc66=0 AND
         ccc.ccc71=0 AND ccc.ccc72=0 AND ccc.ccc91=0 AND ccc.ccc92=0 AND
         ccc.ccc93=0 AND ccc.ccc81=0 AND ccc.ccc82=0 THEN  #No.FUN-660073
         CONTINUE FOREACH
      END IF


      #入庫成本資料調整
      IF cl_null(l_ccc01_t) OR l_ccc01_t != ccc.ccc01 OR
         l_ccc08_t != ccc.ccc08  THEN  #TQC-A50166
         LET l_ccc01_t = ccc.ccc01
         LET l_ccc08_t = ccc.ccc08     #TQC-A50166
         SELECT SUM(ccc22-ccc226),SUM(ccc21-ccc216),SUM(ccc27),SUM(ccc28),          #CHI-BB0010 add -ccc216 & -ccc226
                SUM(ccc211),SUM(ccc221),SUM(ccc212),SUM(ccc222),SUM(ccc213),
                SUM(ccc223),SUM(ccc214),SUM(ccc224),SUM(ccc215),SUM(ccc225),
                SUM(ccc31),SUM(ccc25),SUM(ccc32),SUM(ccc26),SUM(ccc41),
               #MOD-C60150 -- modify start --
               #SUM(ccc42),SUM(ccc52),SUM(ccc93),SUM(ccc51),SUM(ccc61-ccc216),      #CHI-BB0010 add -ccc216
               #SUM(ccc62-ccc226),SUM(ccc81),SUM(ccc82),SUM(ccc71),SUM(ccc72)       #CHI-BB0010 add -ccc216
                SUM(ccc42),SUM(ccc52),SUM(ccc93),SUM(ccc51),SUM(ccc61+ccc216),
                SUM(ccc62+ccc226),SUM(ccc81),SUM(ccc82),SUM(ccc71),SUM(ccc72),
                SUM(ccc216),SUM(ccc226)  #CHI-D10041
               #MOD-C60150 -- modify end --
           INTO ccc.ccc22,ccc.ccc21,ccc.ccc27,ccc.ccc28,
                ccc.ccc211,ccc.ccc221,ccc.ccc212,ccc.ccc222,ccc.ccc213,
                ccc.ccc223,ccc.ccc214,ccc.ccc224,ccc.ccc215,ccc.ccc225,
                ccc.ccc31,ccc.ccc25,ccc.ccc32,ccc.ccc26,ccc.ccc41,
                ccc.ccc42,ccc.ccc52,ccc.ccc93,ccc.ccc51,ccc.ccc61,
                ccc.ccc62,ccc.ccc81,ccc.ccc82,ccc.ccc71,ccc.ccc72,
                ccc.ccc216,ccc.ccc226  #CHI-D10041 
           FROM ccc_file
          WHERE ccc01 = ccc.ccc01
            AND (ccc02*12+ccc03 BETWEEN tm.yy*12+tm.mm AND tm.yy2*12+tm.mm2)
            AND  ccc07 = ccc.ccc07 AND ccc08 = ccc.ccc08

         SELECT ccc11,ccc12 INTO ccc.ccc11,ccc.ccc12 FROM ccc_file
          WHERE ccc01 = ccc.ccc01
            AND ccc02 = tm.yy AND ccc03 = tm.mm
            AND  ccc07 = ccc.ccc07 AND ccc08 = ccc.ccc08

         SELECT ccc91,ccc92 INTO ccc.ccc91,ccc.ccc92 FROM ccc_file
          WHERE ccc01 = ccc.ccc01
            AND ccc02 = tm.yy2 AND ccc03 = tm.mm2
            AND  ccc07 = ccc.ccc07 AND ccc08 = ccc.ccc08
          LET l_ccb22 = 0
          SELECT SUM(ccb22) INTO l_ccb22 FROM ccb_file
           WHERE ccb01 = ccc.ccc01
             AND (ccb02*12+ccb03 BETWEEN tm.yy*12+tm.mm AND tm.yy2*12+tm.mm2)
          IF cl_null(l_ccb22) THEN LET l_ccb22=0 END IF

         IF cl_null(ccc.ccc08) THEN LET ccc.ccc08=' ' END IF   #CHI-820012 add

        #MOD-C30052---str---
         CALL cl_digcut(ccc.ccc11,g_ccz.ccz27) RETURNING ccc.ccc11
         CALL cl_digcut(ccc.ccc21,g_ccz.ccz27) RETURNING ccc.ccc21
         CALL cl_digcut(ccc.ccc25,g_ccz.ccz27) RETURNING ccc.ccc25
         CALL cl_digcut(ccc.ccc27,g_ccz.ccz27) RETURNING ccc.ccc27
         CALL cl_digcut(ccc.ccc211,g_ccz.ccz27) RETURNING ccc.ccc211
         CALL cl_digcut(ccc.ccc212,g_ccz.ccz27) RETURNING ccc.ccc212
         CALL cl_digcut(ccc.ccc213,g_ccz.ccz27) RETURNING ccc.ccc213
         CALL cl_digcut(ccc.ccc214,g_ccz.ccz27) RETURNING ccc.ccc214
         CALL cl_digcut(ccc.ccc215,g_ccz.ccz27) RETURNING ccc.ccc215
         CALL cl_digcut(ccc.ccc216,g_ccz.ccz27) RETURNING ccc.ccc216  #CHI-D10041
         CALL cl_digcut(ccc.ccc31,g_ccz.ccz27) RETURNING ccc.ccc31
         CALL cl_digcut(ccc.ccc41,g_ccz.ccz27) RETURNING ccc.ccc41
         CALL cl_digcut(ccc.ccc51,g_ccz.ccz27) RETURNING ccc.ccc51
         CALL cl_digcut(ccc.ccc61,g_ccz.ccz27) RETURNING ccc.ccc61
         CALL cl_digcut(ccc.ccc81,g_ccz.ccz27) RETURNING ccc.ccc81
         CALL cl_digcut(ccc.ccc71,g_ccz.ccz27) RETURNING ccc.ccc71
         CALL cl_digcut(ccc.ccc91,g_ccz.ccz27) RETURNING ccc.ccc91
        #MOD-C30052---end---

         EXECUTE insert_prept111 USING
            ccc.ccc01 ,ima.ima02 ,ima.ima021,ima.ima25 ,ima.ima12,
            ccc.ccc11 ,ccc.ccc12 ,ccc.ccc21 ,ccc.ccc27 ,ccc.ccc28,
            ccc.ccc211,ccc.ccc221,ccc.ccc212,ccc.ccc222,ccc.ccc213,
            ccc.ccc223,ccc.ccc214,ccc.ccc224,ccc.ccc215,ccc.ccc225,
            ccc.ccc216,ccc.ccc226,  #CHI-D10041
            ccc.ccc31 ,ccc.ccc25 ,ccc.ccc32 ,ccc.ccc26 ,ccc.ccc41,
            ccc.ccc42 ,ccc.ccc52 ,ccc.ccc93 ,ccc.ccc51 ,ccc.ccc61,
            ccc.ccc62 ,ccc.ccc81 ,ccc.ccc82 ,ccc.ccc71 ,ccc.ccc72,
            ccc.ccc91 ,ccc.ccc92 ,l_ccb22   ,                   #CHI-820012 mod
            tm.yy     ,tm.mm     ,tm.yy2    ,tm.mm2    ,        #CHI-820012 mod
            #g_ccz.ccz27,g_azi03  ,ccc.ccc22 ,ccc.ccc08          #CHI-820012 add ccc08  #CHI-7B0018 add ccc22 #CHI-C30012
            g_ccz.ccz27,g_ccz.ccz26  ,ccc.ccc22 ,ccc.ccc08  #CHI-C30012
        END IF     #No.MOD-8A0117 add
   END FOREACH

     IF tm.c = 'Y' then
        LET l_sql = "SELECT UNIQUE ccc01,ccc08 ",    #TQC-A50166 add ccc08
                    "  FROM ccc_file, ima_file",
                    " WHERE ",tm.wc CLIPPED,
                    "   AND (ccc02*12+ccc03 BETWEEN " ,tm.yy*12+tm.mm,
                    "   AND ",tm.yy2*12+tm.mm2 ,") AND ccc01=ima01 " CLIPPED,
                    "   AND ccc07='",tm.type,"'"    #No.FUN-7C0101 add

        PREPARE axcr430_PREPARE2 FROM l_sql
        IF STATUS THEN
           CALL cl_err('PREPARE2:',STATUS,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
           EXIT PROGRAM
        END IF
        DECLARE axcr430_curs2 CURSOR FOR axcr430_PREPARE2

        FOREACH axcr430_curs2 INTO ccc.ccc01,ccc.ccc08           #TQC-A50166 add
           IF STATUS THEN
              CALL cl_err('FOREACH2:',STATUS,1)
              EXIT FOREACH
           END IF
           IF ccc.ccc08 IS NULL THEN LET ccc.ccc08 = ' ' END IF   #TQC-A50166

           #雜項入庫
           INITIALIZE sr1.* TO NULL
           FOREACH sr1_cs using ccc.ccc01,ccc.ccc08 into sr1.*,l_tlf031,l_tlf032,l_tlf930       #FUN-9A0050 Add l_tlf031,l_tlf032,l_tlf930  #No.TQC-A50166
             LET sr1.tlf10 = sr1.tlf10*sr1.tlf907
             LET sr1.tlfc21 = sr1.tlfc21*sr1.tlf907  #FUN-7C0101 mod
              LET l_sql = "SELECT ccz07 ",
                          " FROM ccz_file ",
                          " WHERE ccz00 = '0' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              PREPARE ccz_p1 FROM l_sql
              IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p1',SQLCA.SQLCODE,1) END IF
              DECLARE ccz_c1 CURSOR FOR ccz_p1
              OPEN ccz_c1
              FETCH ccz_c1 INTO l_ccz07
              CLOSE ccz_c1
              CASE WHEN l_ccz07='1'
                        LET l_sql="SELECT ima39,ima391 FROM ima_file ",
                                  " WHERE ima01='",sr1.tlf01,"'"
                   WHEN l_ccz07='2'
                        LET l_sql="SELECT imz39,imz391 ",
                                  " FROM ima_file,imz_file",
                                  " WHERE ima01='",sr1.tlf01,"' AND ima06=imz01 "
                   WHEN l_ccz07='3'
                        LET l_sql="SELECT imd08,imd081 FROM imd_file",
                                  #" WHERE imd01='",l_tlf031,"'"    #TQC-C80054  mark
                                  " WHERE imd01='",sr1.tlf902,"'"   #TQC-C80054  add 
                   WHEN l_ccz07='4'
                        LET l_sql="SELECT ime09,ime091 FROM ime_file",
                                  #" WHERE ime01='",l_tlf031,"' ",  #TQC-C80054  mark
                                  #" AND ime02='",l_tlf032,"'"      #TQC-C80054  mark
                                  " WHERE ime01='",sr1.tlf902,"' ", #TQC-C80054  add
                                  "   AND ime02='",sr1.tlf903,"'"   #TQC-C80054  add
             END CASE
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             PREPARE stock_p1 FROM l_sql
             IF SQLCA.SQLCODE THEN CALL cl_err('stock_p1',SQLCA.SQLCODE,1) END IF
             DECLARE stock_c1 CURSOR FOR stock_p1
             OPEN stock_c1
             FETCH stock_c1 INTO l_ima39,l_ima391
             CLOSE stock_c1
             EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                        sr1.tlf10,sr1.tlfc21,sr1.tlf907,
                                        ' ',sr1.tlfccost,'11',' ',' ','0','0',' '
                                        ,l_ima39,l_ima391,l_tlf930                                 #FUN-9A0050 Add
           END FOREACH

           #採購入庫
           INITIALIZE sr1.* TO NULL
           FOREACH sr2_cs using ccc.ccc01,ccc.ccc08 into sr1.*,l_tlf031,l_tlf032,l_tlf930   #FUN-9A0050 Add l_tlf031,l_tlf032,l_tlf930  #No.TQC-A50166
             LET sr1.tlf10 = sr1.tlf10*sr1.tlf907
             LET sr1.tlfc21 = sr1.tlfc21*sr1.tlf907  #FUN-7C0101 mod
             IF cl_null(sr1.tlfccost) THEN LET sr1.tlfccost= ' ' END IF   #CHI-820012 add
              LET l_sql = "SELECT ccz07 ",
                          " FROM ccz_file ",
                          " WHERE ccz00 = '0' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              PREPARE ccz_p2 FROM l_sql
              IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p2',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
              DECLARE ccz_c2 CURSOR FOR ccz_p2
              OPEN ccz_c2
              FETCH ccz_c2 INTO l_ccz07
              CLOSE ccz_c2
              CASE WHEN l_ccz07='1'
                        LET l_sql="SELECT ima39,ima391 FROM ima_file ",
                                  " WHERE ima01='",sr1.tlf01,"'"
                   WHEN l_ccz07='2'
                        LET l_sql="SELECT imz39,imz391 ",
                                  " FROM ima_file,imz_file",
                                  " WHERE ima01='",sr1.tlf01,"' AND ima06=imz01 "
                   WHEN l_ccz07='3'
                        LET l_sql="SELECT imd08,imd081 FROM imd_file",
                                  #" WHERE imd01='",l_tlf031,"'"    #TQC-C80054  mark
                                  " WHERE imd01='",sr1.tlf902,"'"   #TQC-C80054  add
                   WHEN l_ccz07='4'
                        LET l_sql="SELECT ime09,ime091 FROM ime_file",
                                  #" WHERE ime01='",l_tlf031,"' ",  #TQC-C80054  mark
                                  #" AND ime02='",l_tlf032,"'"      #TQC-C80054  mark
                                  " WHERE ime01='",sr1.tlf902,"' ", #TQC-C80054  add
                                  "   AND ime02='",sr1.tlf903,"'"   #TQC-C80054  add
             END CASE
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             PREPARE stock_p2 FROM l_sql
             IF SQLCA.SQLCODE THEN CALL cl_err('stock_p2',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
             DECLARE stock_c2 CURSOR FOR stock_p2
             OPEN stock_c2
             FETCH stock_c2 INTO l_ima39,l_ima391
             CLOSE stock_c2
             EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                        sr1.tlf10,sr1.tlfc21,sr1.tlf907,
                                        ' ',sr1.tlfccost,'12',' ',' ','0','0',' '
                                        ,l_ima39,l_ima391,l_tlf930                                 #FUN-9A0050 Add
           END FOREACH

           #工單入庫
           INITIALIZE sr1.* TO NULL
           LET l_sfb02 = NULL  #CHI-C50025
           #FOREACH sr3_cs using ccc.ccc01,ccc.ccc08 into sr1.*,l_tlf031,l_tlf032,l_tlf930  #FUN-9A0050 Add l_tlf031,l_tlf032,l_tlf930  #No.TQC-A50166  #CHI-C50025 mark
           FOREACH sr3_cs using ccc.ccc01,ccc.ccc08 into sr1.*,l_tlf031,l_tlf032,l_tlf930,l_sfb02  #CHI-C50025
             LET sr1.tlf10 = sr1.tlf10*sr1.tlf907
             LET sr1.tlfc21 = sr1.tlfc21*sr1.tlf907  #FUN-7C0101 mod
             IF cl_null(sr1.tlfccost) THEN LET sr1.tlfccost= ' ' END IF   #CHI-820012 add
              LET l_sql = "SELECT ccz07 ",
                          " FROM ccz_file ",
                          " WHERE ccz00 = '0' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              PREPARE ccz_p3 FROM l_sql
              IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p3',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
              DECLARE ccz_c3 CURSOR FOR ccz_p3
              OPEN ccz_c3
              FETCH ccz_c3 INTO l_ccz07
              CLOSE ccz_c3
              CASE WHEN l_ccz07='1'
                        LET l_sql="SELECT ima39,ima391 FROM ima_file ",
                                  " WHERE ima01='",sr1.tlf01,"'"
                   WHEN l_ccz07='2'
                        LET l_sql="SELECT imz39,imz391 ",
                                  " FROM ima_file,imz_file",
                                  " WHERE ima01='",sr1.tlf01,"' AND ima06=imz01 "
                   WHEN l_ccz07='3'
                        LET l_sql="SELECT imd08,imd081 FROM imd_file",
                                  #" WHERE imd01='",l_tlf031,"'"    #TQC-C80054  mark
                                  " WHERE imd01='",sr1.tlf902,"'"   #TQC-C80054  add
                   WHEN l_ccz07='4'
                        LET l_sql="SELECT ime09,ime091 FROM ime_file",
                                  #" WHERE ime01='",l_tlf031,"' ",  #TQC-C80054  mark
                                  #" AND ime02='",l_tlf032,"'"      #TQC-C80054  mark
                                  " WHERE ime01='",sr1.tlf902,"' ", #TQC-C80054  add
                                  "   AND ime02='",sr1.tlf903,"'"   #TQC-C80054  add
             END CASE
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             PREPARE stock_p3 FROM l_sql
             IF SQLCA.SQLCODE THEN CALL cl_err('stock_p3',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
             DECLARE stock_c3 CURSOR FOR stock_p3
             OPEN stock_c3
             FETCH stock_c3 INTO l_ima39,l_ima391
             CLOSE stock_c3
             IF sr1.sfb99 = 'N' THEN    #MOD-B90238 add     #一般入庫
                #CHI-C50025---begin
                IF l_sfb02 = '7' THEN
                   EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                              sr1.tlf10,sr1.tlfc21,sr1.tlf907,
                                              sr1.sfb99,sr1.tlfccost,'17',' ',' ','0','0',' ' 
                                              ,l_ima39,l_ima391,l_tlf930 
                ELSE
                #CHI-C50025---end
                   EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                              sr1.tlf10,sr1.tlfc21,sr1.tlf907,
                                            # ' ',sr1.tlfccost,'13',' ',' ','0','0',' '        #TQC-A50166 mark
                                              sr1.sfb99,sr1.tlfccost,'13',' ',' ','0','0',' '  #TQC-A50166
                                              ,l_ima39,l_ima391,l_tlf930                                 #FUN-9A0050 Add
                END IF   #CHI-C50025 
            #MOD-B90238---add---start---
             ELSE     #重工入庫
                EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                           sr1.tlf10,sr1.tlfc21,sr1.tlf907,
                                           sr1.sfb99,sr1.tlfccost,'19',' ',' ','0','0',' '  
                                           ,l_ima39,l_ima391,l_tlf930                                 
             END IF
            #MOD-B90238---add---end---
           END FOREACH

           INITIALIZE xxx.* TO NULL
           LET l_sfb02 = NULL   #CHI-C50025
           #FOREACH xxx_cs USING ccc.ccc01 INTO xxx.*   #CHI-C50025 mark
           FOREACH xxx_cs USING ccc.ccc01 INTO xxx.*,l_sfb02    #CHI-C50025
             IF cl_null(xxx.ccg07) THEN LET xxx.ccg07= ' ' END IF   #CHI-820012 add
             #CHI-C50025---begin
             IF l_sfb02 = '7' THEN
                EXECUTE insert_prep1 USING xxx.ccg04,'',xxx.ccg01,'0','0',
                                          '0','0',' ',' ','01',xxx.*
                                          ,'','',''
             ELSE 
             #CHI-C50025---end
                #EXECUTE insert_prep1 USING xxx.ccg01,' ',xxx.ccg01,'0','0',   #MOD-B90185 mark
                EXECUTE insert_prep1 USING xxx.ccg04,'',xxx.ccg01,'0','0',    #MOD-B90185
                                          '0','0',' ',' ','00',xxx.* #No.MOD-930143 mod #CHI-820012 mod  #注意:tlf01和tlf905皆塞入ccg01的值，為了rpt排序使用
                                          ,'','',''                   #FUN-9A0050 Add
             END IF   #CHI-C50025
           END FOREACH
           #CHI-C50025---begin
           INITIALIZE xxx.* TO NULL
           LET l_sfb02 = NULL
           FOREACH xxx1_cs USING ccc.ccc01,ccc.ccc01,ccc.ccc01 INTO xxx.*,l_sfb02
              IF cl_null(xxx.ccg07) THEN LET xxx.ccg07 = ' ' END IF
              IF l_sfb02 = '7' THEN
                EXECUTE insert_prep1 USING xxx.ccg04,'',xxx.ccg01,'0','0',
                                          '0','0',' ',' ','01',xxx.*
                                          ,'','',''
              ELSE
                EXECUTE insert_prep1 USING xxx.ccg04,'',xxx.ccg01,'0','0',
                                          '0','0',' ',' ','00',xxx.*
                                          ,'','',''
              END IF
           END FOREACH
           #CHI-C50025---end
           #雜項出庫
           INITIALIZE sr1.* TO NULL
           FOREACH sr4_cs using ccc.ccc01,ccc.ccc08 into sr1.*,l_tlf031,l_tlf032,l_tlf930  #FUN-9A0050 Add l_tlf031,l_tlf032,l_tlf930  #No.TQC-A50166
             LET sr1.tlf10 = sr1.tlf10*sr1.tlf907
             LET sr1.tlfc21 = sr1.tlfc21*sr1.tlf907  #FUN-7C0101 mod
             IF cl_null(sr1.tlfccost) THEN LET sr1.tlfccost= ' ' END IF   #CHI-820012 add
              LET l_sql = "SELECT ccz07 ",
                          " FROM ccz_file ",
                          " WHERE ccz00 = '0' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              PREPARE ccz_p4 FROM l_sql
              IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p4',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
              DECLARE ccz_c4 CURSOR FOR ccz_p4
              OPEN ccz_c4
              FETCH ccz_c4 INTO l_ccz07
              CLOSE ccz_c4
              CASE WHEN l_ccz07='1'
                        LET l_sql="SELECT ima39,ima391 FROM ima_file ",
                                  " WHERE ima01='",sr1.tlf01,"'"
                   WHEN l_ccz07='2'
                        LET l_sql="SELECT imz39,imz391 ",
                                  " FROM ima_file,imz_file",
                                  " WHERE ima01='",sr1.tlf01,"' AND ima06=imz01 "
                   WHEN l_ccz07='3'
                        LET l_sql="SELECT imd08,imd081 FROM imd_file",
                                  #" WHERE imd01='",l_tlf031,"'"    #TQC-C80054  mark
                                  " WHERE imd01='",sr1.tlf902,"'"   #TQC-C80054  add
                   WHEN l_ccz07='4'
                        LET l_sql="SELECT ime09,ime091 FROM ime_file",
                                  #" WHERE ime01='",l_tlf031,"' ",  #TQC-C80054  mark
                                  #" AND ime02='",l_tlf032,"'"      #TQC-C80054  mark
                                  " WHERE ime01='",sr1.tlf902,"' ", #TQC-C80054  add
                                  "   AND ime02='",sr1.tlf903,"'"   #TQC-C80054  add 
             END CASE
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             PREPARE stock_p4 FROM l_sql
             IF SQLCA.SQLCODE THEN CALL cl_err('stock_p4',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
             DECLARE stock_c4 CURSOR FOR stock_p4
             OPEN stock_c4
             FETCH stock_c4 INTO l_ima39,l_ima391
             CLOSE stock_c4
             EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                        sr1.tlf10,sr1.tlfc21,sr1.tlf907,
                                        ' ',sr1.tlfccost,'14',' ',' ','0','0',' '
                                        ,l_ima39,l_ima391,l_tlf930                                 #FUN-9A0050 Add
           END FOREACH

           #工單領用
           INITIALIZE sr1.* TO NULL
           FOREACH sr5_cs using ccc.ccc01,ccc.ccc08 into sr1.*,l_tlf031,l_tlf032,l_tlf930  #FUN-9A0050 Add l_tlf031,l_tlf032,l_tlf930  #No.TQC-A50166
             LET sr1.tlf10 = sr1.tlf10*sr1.tlf907
             LET sr1.tlfc21 = sr1.tlfc21*sr1.tlf907  #FUN-7C0101 mod
             IF cl_null(sr1.tlfccost) THEN LET sr1.tlfccost= ' ' END IF   #CHI-820012 add
              LET l_sql = "SELECT ccz07 ",
                          " FROM ccz_file ",
                          " WHERE ccz00 = '0' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              PREPARE ccz_p5 FROM l_sql
              IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p5',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
              DECLARE ccz_c5 CURSOR FOR ccz_p5
              OPEN ccz_c5
              FETCH ccz_c5 INTO l_ccz07
              CLOSE ccz_c5
              CASE WHEN l_ccz07='1'
                        LET l_sql="SELECT ima39,ima391 FROM ima_file ",
                                  " WHERE ima01='",sr1.tlf01,"'"
                   WHEN l_ccz07='2'
                        LET l_sql="SELECT imz39,imz391 ",
                                  " FROM ima_file,imz_file",
                                  " WHERE ima01='",sr1.tlf01,"' AND ima06=imz01 "
                   WHEN l_ccz07='3'
                        LET l_sql="SELECT imd08,imd081 FROM imd_file",
                                  #" WHERE imd01='",l_tlf031,"'"    #TQC-C80054  mark
                                  " WHERE imd01='",sr1.tlf902,"'"   #TQC-C80054  add
                   WHEN l_ccz07='4'
                        LET l_sql="SELECT ime09,ime091 FROM ime_file",
                                  #" WHERE ime01='",l_tlf031,"' ",  #TQC-C80054  mark
                                  #" AND ime02='",l_tlf032,"'"      #TQC-C80054  mark
                                  " WHERE ime01='",sr1.tlf902,"' ", #TQC-C80054  add
                                  "   AND ime02='",sr1.tlf903,"'"   #TQC-C80054  add
             END CASE
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             PREPARE stock_p5 FROM l_sql
             IF SQLCA.SQLCODE THEN CALL cl_err('stock_p5',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
             DECLARE stock_c5 CURSOR FOR stock_p5
             OPEN stock_c5
             FETCH stock_c5 INTO l_ima39,l_ima391
             CLOSE stock_c5
             #No.TQC-A50166  --Begin
             EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906, #TQC-A50166
                                        sr1.tlf10,sr1.tlfc21,sr1.tlf907,           #TQC-A50166
                                       #' ',sr1.tlfccost,'15',' ',' ','0','0',' '  #TQC-A50166  #TQC-A50166
                                        sr1.sfb99,sr1.tlfccost,'15',' ',' ','0','0',' '  #TQC-A50166 #TQC-A50166
                                        ,l_ima39,l_ima391,l_tlf930                                 #FUN-9A0050 Add
             #No.TQC-A50166  --End
           END FOREACH

           #拆件工單領用
           INITIALIZE sr1.* TO NULL
           FOREACH sr5_cs1 using ccc.ccc01,ccc.ccc08 into sr1.*,l_tlf031,l_tlf032,l_tlf930,l_tlf62   #FUN-9A0050 Add l_tlf031,l_tlf032,l_tlf930  #No.TQC-A50166  #MOD-D20166 add tlf62
             LET sr1.tlf10 = sr1.tlf10*sr1.tlf907
             LET sr1.tlfc21 = sr1.tlfc21*sr1.tlf907
             IF cl_null(sr1.tlfccost) THEN LET sr1.tlfccost= ' ' END IF
              LET l_sql = "SELECT ccz07 ",
                          " FROM ccz_file ",
                          " WHERE ccz00 = '0' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              PREPARE ccz_p51 FROM l_sql
              IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p51',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
              DECLARE ccz_c51 CURSOR FOR ccz_p51
              OPEN ccz_c51
              FETCH ccz_c51 INTO l_ccz07
              CLOSE ccz_c51
              CASE WHEN l_ccz07='1'
                        LET l_sql="SELECT ima39,ima391 FROM ima_file ",
                                  " WHERE ima01='",sr1.tlf01,"'"
                   WHEN l_ccz07='2'
                        LET l_sql="SELECT imz39,imz391 ",
                                  " FROM ima_file,imz_file",
                                  " WHERE ima01='",sr1.tlf01,"' AND ima06=imz01 "
                   WHEN l_ccz07='3'
                        LET l_sql="SELECT imd08,imd081 FROM imd_file",
                                  #" WHERE imd01='",l_tlf031,"'"    #TQC-C80054  mark
                                  " WHERE imd01='",sr1.tlf902,"'"   #TQC-C80054  add
                   WHEN l_ccz07='4'
                        LET l_sql="SELECT ime09,ime091 FROM ime_file",
                                  #" WHERE ime01='",l_tlf031,"' ",  #TQC-C80054  mark
                                  #" AND ime02='",l_tlf032,"'"      #TQC-C80054  mark
                                  " WHERE ime01='",sr1.tlf902,"' ", #TQC-C80054  add
                                  "   AND ime02='",sr1.tlf903,"'"   #TQC-C80054  add
             END CASE
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             PREPARE stock_p51 FROM l_sql
             IF SQLCA.SQLCODE THEN CALL cl_err('stock_p51',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
             DECLARE stock_c51 CURSOR FOR stock_p51
             OPEN stock_c51
             FETCH stock_c51 INTO l_ima39,l_ima391
             CLOSE stock_c51
             #MOD-D20166---begin
             SELECT COUNT(*) INTO l_cnt
               FROM sfa_file 
              WHERE sfa01 = l_tlf62
                AND sfa03 = sr1.tlf01
             IF l_cnt = 0 THEN
                LET sr1.sfb99 = 'N'
             END IF 
             #MOD-D20166---end
             #No.TQC-A50116  --Begin
             EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                        sr1.tlf10,sr1.tlfc21,sr1.tlf907,        
                                        sr1.sfb99,sr1.tlfccost,'15',' ',' ','0','0',' '
                                        ,l_ima39,l_ima391,l_tlf930
             #No.TQC-A50116  --End  

           END FOREACH

           #銷貨出庫
           INITIALIZE sr1.* TO NULL
           FOREACH sr6_cs using ccc.ccc01,ccc.ccc08 into sr1.*,l_tlf031,l_tlf032,l_tlf930   #FUN-9A0050 Add l_tlf031,l_tlf032,l_tlf930  #No.TQC-A50166
             LET sr1.tlf10 = sr1.tlf10*sr1.tlf907
             LET sr1.tlfc21 = sr1.tlfc21*sr1.tlf907  #FUN-7C0101 mod
             IF cl_null(sr1.tlfccost) THEN LET sr1.tlfccost= ' ' END IF   #CHI-820012 add
              LET l_sql = "SELECT ccz07 ",
                          " FROM ccz_file ",
                          " WHERE ccz00 = '0' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              PREPARE ccz_p6 FROM l_sql
              IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p6',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
              DECLARE ccz_c6 CURSOR FOR ccz_p6
              OPEN ccz_c6
              FETCH ccz_c6 INTO l_ccz07
              CLOSE ccz_c6
              CASE WHEN l_ccz07='1'
                        LET l_sql="SELECT ima39,ima391 FROM ima_file ",
                                  " WHERE ima01='",sr1.tlf01,"'"
                   WHEN l_ccz07='2'
                        LET l_sql="SELECT imz39,imz391 ",
                                  " FROM ima_file,imz_file",
                                  " WHERE ima01='",sr1.tlf01,"' AND ima06=imz01 "
                   WHEN l_ccz07='3'
                        LET l_sql="SELECT imd08,imd081 FROM imd_file",
                                  #" WHERE imd01='",l_tlf031,"'"    #TQC-C80054  mark
                                  " WHERE imd01='",sr1.tlf902,"'"   #TQC-C80054  add
                   WHEN l_ccz07='4'
                        LET l_sql="SELECT ime09,ime091 FROM ime_file",
                                  #" WHERE ime01='",l_tlf031,"' ",  #TQC-C80054  mark
                                  #" AND ime02='",l_tlf032,"'"      #TQC-C80054  mark
                                  " WHERE ime01='",sr1.tlf902,"' ", #TQC-C80054  add
                                  "   AND ime02='",sr1.tlf903,"'"   #TQC-C80054  add
             END CASE
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             PREPARE stock_p6 FROM l_sql
             IF SQLCA.SQLCODE THEN CALL cl_err('stock_p6',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
             DECLARE stock_c6 CURSOR FOR stock_p6
             OPEN stock_c6
             FETCH stock_c6 INTO l_ima39,l_ima391
             CLOSE stock_c6
             #CHI-D10041---begin
             IF sr1.tlf10 > 0 THEN 
                EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                           sr1.tlf10,sr1.tlfc21,sr1.tlf907,
                                           ' ',sr1.tlfccost,'20',' ',' ','0','0',' '
                                           ,l_ima39,l_ima391,l_tlf930   
             ELSE 
             #CHI-D10041---end
                #MOD-D10152---begin
                EXECUTE sr6_perp2 INTO l_cnt USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906 
                IF l_cnt > 0 THEN
                   EXECUTE sr6_perp3 USING sr1.tlf10,sr1.tlfc21,sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906
                ELSE 
                #MOD-D10152---end 
                   EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                              sr1.tlf10,sr1.tlfc21,sr1.tlf907,
                                              ' ',sr1.tlfccost,'16',' ',' ','0','0',' '
                                              ,l_ima39,l_ima391,l_tlf930                                 #FUN-9A0050 Add
                END IF  #MOD-D10152 
             END IF  #CHI-D10041
           END FOREACH

           #樣品出庫#
           INITIALIZE sr1.* TO NULL
           FOREACH sr8_cs using ccc.ccc01,ccc.ccc08 into sr1.*,l_tlf031,l_tlf032,l_tlf930   #FUN-9A0050 Add l_tlf031,l_tlf032,l_tlf930  #No.TQC-A50166
             LET sr1.tlf10 = sr1.tlf10*sr1.tlf907
             LET sr1.tlfc21 = sr1.tlfc21*sr1.tlf907  #FUN-7C0101 mod
             IF cl_null(sr1.tlfccost) THEN LET sr1.tlfccost= ' ' END IF   #CHI-820012 add
              LET l_sql = "SELECT ccz07 ",
                          " FROM ccz_file ",
                          " WHERE ccz00 = '0' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              PREPARE ccz_p8 FROM l_sql
              IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p8',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
              DECLARE ccz_c8 CURSOR FOR ccz_p8
              OPEN ccz_c8
              FETCH ccz_c8 INTO l_ccz07
              CLOSE ccz_c8
              CASE WHEN l_ccz07='1'
                        LET l_sql="SELECT ima39,ima391 FROM ima_file ",
                                  " WHERE ima01='",sr1.tlf01,"'"
                   WHEN l_ccz07='2'
                        LET l_sql="SELECT imz39,imz391 ",
                                  " FROM ima_file,imz_file",
                                  " WHERE ima01='",sr1.tlf01,"' AND ima06=imz01 "
                   WHEN l_ccz07='3'
                        LET l_sql="SELECT imd08,imd081 FROM imd_file",
                                  #" WHERE imd01='",l_tlf031,"'"    #TQC-C80054  mark
                                  " WHERE imd01='",sr1.tlf902,"'"   #TQC-C80054  add
                   WHEN l_ccz07='4'
                        LET l_sql="SELECT ime09,ime091 FROM ime_file",
                                  #" WHERE ime01='",l_tlf031,"' ",  #TQC-C80054  mark
                                  #" AND ime02='",l_tlf032,"'"      #TQC-C80054  mark
                                  " WHERE ime01='",sr1.tlf902,"' ", #TQC-C80054  add
                                  "   AND ime02='",sr1.tlf903,"'"   #TQC-C80054  add
             END CASE
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             PREPARE stock_p8 FROM l_sql
             IF SQLCA.SQLCODE THEN CALL cl_err('stock_p8',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
             DECLARE stock_c8 CURSOR FOR stock_p8
             OPEN stock_c8
             FETCH stock_c8 INTO l_ima39,l_ima391
             CLOSE stock_c8
             EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                        sr1.tlf10,sr1.tlfc21,sr1.tlf907,
                                        ' ',sr1.tlfccost,'18',' ',' ','0','0',' '
                                        ,l_ima39,l_ima391,l_tlf930                                 #FUN-9A0050 Add
           END FOREACH

           #盤盈虧
           INITIALIZE sr1.* TO NULL
           FOREACH sr7_cs using ccc.ccc01,ccc.ccc08 INTO sr1.*,l_tlf031,l_tlf032,l_tlf930   #FUN-9A0050 Add l_tlf031,l_tlf032,l_tlf930  #No.TQC-A50166
             LET sr1.tlf10 = sr1.tlf10*sr1.tlf907
             LET sr1.tlfc21 = sr1.tlfc21*sr1.tlf907  #FUN-7C0101 mod
             IF cl_null(sr1.tlfccost) THEN LET sr1.tlfccost= ' ' END IF   #CHI-820012 add
              LET l_sql = "SELECT ccz07 ",
                          " FROM ccz_file ",
                          " WHERE ccz00 = '0' "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              PREPARE ccz_p7 FROM l_sql
              IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p7',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
              DECLARE ccz_c7 CURSOR FOR ccz_p7
              OPEN ccz_c7
              FETCH ccz_c7 INTO l_ccz07
              CLOSE ccz_c7
              CASE WHEN l_ccz07='1'
                        LET l_sql="SELECT ima39,ima391 FROM ima_file ",
                                  " WHERE ima01='",sr1.tlf01,"'"
                   WHEN l_ccz07='2'
                        LET l_sql="SELECT imz39,imz391 ",
                                  " FROM ima_file,imz_file",
                                  " WHERE ima01='",sr1.tlf01,"' AND ima06=imz01 "
                   WHEN l_ccz07='3'
                        LET l_sql="SELECT imd08,imd081 FROM imd_file",
                                  #" WHERE imd01='",l_tlf031,"'"    #TQC-C80054  mark
                                  " WHERE imd01='",sr1.tlf902,"'"   #TQC-C80054  add
                   WHEN l_ccz07='4'
                        LET l_sql="SELECT ime09,ime091 FROM ime_file",
                                  #" WHERE ime01='",l_tlf031,"' ",  #TQC-C80054  mark
                                  #" AND ime02='",l_tlf032,"'"      #TQC-C80054  mark
                                  " WHERE ime01='",sr1.tlf902,"' ", #TQC-C80054  add
                                  "   AND ime02='",sr1.tlf903,"'"   #TQC-C80054  add
             END CASE
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             PREPARE stock_p7 FROM l_sql
             IF SQLCA.SQLCODE THEN CALL cl_err('stock_p7',SQLCA.SQLCODE,1) END IF  #No.TQC-A50166
             DECLARE stock_c7 CURSOR FOR stock_p7
             OPEN stock_c7
             FETCH stock_c7 INTO l_ima39,l_ima391
             CLOSE stock_c7
             EXECUTE insert_prep1 USING sr1.tlf01,sr1.tlf06,sr1.tlf905,sr1.tlf906,
                                        sr1.tlf10,sr1.tlfc21,sr1.tlf907,
                                        ' ',sr1.tlfccost,'17',' ',' ','0','0',' '
                                        ,l_ima39,l_ima391,l_tlf930                                 #FUN-9A0050 Add
           END FOREACH
        END FOREACH
     END IF

  #小計
  #LET l_sql = "SELECT ima12,ccc08,SUM(ccc11),SUM(ccc12),SUM(ccc21+ccc27),(SUM(ccc22)+SUM(ccc28)),",  #No.TQC-A50166  #CHI-BB0010
   LET l_sql = "SELECT ima12,ccc08,SUM(ccc11),SUM(ccc12),SUM(ccc21-ccc216+ccc27),(SUM(ccc22-ccc226)+SUM(ccc28)),",  #No.TQC-A50166  #CHI-BB0010
               "       SUM(ccc211),SUM(ccc221),SUM(ccc212),SUM(ccc222),",
               "       SUM(ccc213),SUM(ccc223),SUM(ccc214),SUM(ccc224),",
               "       SUM(ccc215),SUM(ccc225),SUM(ccc216),SUM(ccc226),SUM(ccc25),SUM(ccc26),",  #CHI-D10041 SUM(ccc216),SUM(ccc226)
               "       SUM(ccc27),SUM(ccc28),",
               "       SUM(ccc31+ccc25),(SUM(ccc32)+SUM(ccc26)),",
               "       SUM(ccc41),SUM(ccc42),SUM(ccc52+ccc93),",
              #"       SUM(ccc51),SUM(ccc61),SUM(ccc62),",      #CHI-BB0010
              #"       SUM(ccc51),SUM(ccc61-ccc216),SUM(ccc62-ccc226),",      #CHI-BB0010   #MOD-C60150 mark
               "       SUM(ccc51),SUM(ccc61+ccc216),SUM(ccc62+ccc226),",                    #MOD-C60150 add 
               "       SUM(ccc81),SUM(ccc82),SUM(ccc71),",
               "       SUM(ccc72),SUM(ccc91),SUM(ccc92) ",
               "FROM ccc_file, ima_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND (ccc02*12+ccc03 BETWEEN " ,tm.yy*12+tm.mm,
               "   AND ",tm.yy2*12+tm.mm2 ,") AND ccc01=ima01 ",
               "   AND ccc07='",tm.type,"'",      #No.FUN-7C0101 add
               " GROUP BY ima12,ccc08"
   PREPARE sr9_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('sr9_pre',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE sr9_cs CURSOR FOR sr9_pre

   LET l_sql = "SELECT SUM(ccc11),SUM(ccc12)",
               "FROM ccc_file, ima_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND ccc02 = ",tm.yy,
               "   AND ccc03 = ",tm.mm,
               "   AND ccc01 = ima01 ",
               "   AND ccc07='",tm.type,"'",
               "   AND ccc08 = ? ",       #MOD-9B0138 add
               "   AND ima12 = ? "
   PREPARE sr10_pre FROM l_sql
   DECLARE sr10_cs CURSOR FOR sr10_pre

   LET l_sql = "SELECT SUM(ccc11),SUM(ccc12)",
               "FROM ccc_file,ima_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND ccc02 = ",tm.yy,
               "   AND ccc03 = ",tm.mm,
               "   AND ccc01 = ima01 ",
               "   AND ccc07='",tm.type,"'",
               "   AND ccc08 = ? ",       #MOD-9B0138 add
               "   AND ima12 IS NULL "
   PREPARE sr13_pre FROM l_sql
   DECLARE sr13_cs CURSOR FOR sr13_pre

   LET l_sql = "SELECT SUM(ccc91),SUM(ccc92)",
               "FROM ccc_file, ima_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND ccc02 = ",tm.yy2,
               "   AND ccc03 = ",tm.mm2,
               "   AND ccc01 = ima01 ",
               "   AND ccc07='",tm.type,"'",
               "   AND ccc08 = ? ",       #MOD-9B0138 add
               "   AND ima12 = ? "
   PREPARE sr11_pre FROM l_sql
   DECLARE sr11_cs CURSOR FOR sr11_pre

   LET l_sql = "SELECT SUM(ccc91),SUM(ccc92)",
               "FROM ccc_file, ima_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND ccc02 = ",tm.yy2,
               "   AND ccc03 = ",tm.mm2,
               "   AND ccc01 = ima01 ",
               "   AND ccc07='",tm.type,"'",
               "   AND ccc08 = ? ",       #MOD-9B0138 add
               "   AND ima12 IS NULL "
   PREPARE sr14_pre FROM l_sql
   DECLARE sr14_cs CURSOR FOR sr14_pre
   FOREACH sr9_cs INTO sr2.*,g_msg
    #IF NOT cl_null(sr2.ima12) THEN        #MOD-A80150 mark
     IF sr2.ima12 IS NOT NULL THEN         #MOD-A80150 add
        OPEN sr10_cs USING sr2.ccc08,sr2.ima12       #MOD-9B0138 add sr2.ccc08
        FETCH sr10_cs INTO sr2.sum_ccc11,sr2.sum_ccc12
        CLOSE sr10_cs

        OPEN sr11_cs USING sr2.ccc08,sr2.ima12       #MOD-9B0138 add sr2.ccc08
        FETCH sr11_cs INTO sr2.sum_ccc91,sr2.sum_ccc92
        CLOSE sr11_cs
     ELSE
        OPEN sr13_cs USING sr2.ccc08                 #MOD-9B0138 add sr2.ccc08
        FETCH sr13_cs INTO sr2.sum_ccc11,sr2.sum_ccc12
        CLOSE sr13_cs

        OPEN sr14_cs USING sr2.ccc08                 #MOD-9B0138 add sr2.ccc08
        FETCH sr14_cs INTO sr2.sum_ccc91,sr2.sum_ccc92
        CLOSE sr14_cs
     END IF
     LET g_msg=' '
     SELECT azf03 INTO g_msg FROM azf_file
      WHERE azf01=sr2.ima12 AND azf02='G'   #6818
     IF cl_null(g_msg) THEN LET g_msg=' ' END IF
     EXECUTE insert_prep2 USING sr2.*,g_msg
   END FOREACH


   LET l_sql = "SELECT * ",
               "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A",   #FUN-740023 modify
               " LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B"," ON (B.tlf01 = A.ccc01 AND B.tlfccost = A.ccc08) ",  #TQC-A50166 add
               " ORDER BY A.ccc01,A.ccc08 ","|",  #TQC-A50166 add ccc08
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED

   PREPARE axcr430_preparet FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #p1
   IF tm.azh02 IS NOT NULL THEN
      LET l_str = tm.azh02
   ELSE
      LET l_str = l_gaz03
   END IF

   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ima01,ima39,ima57,ima08,
                       ima06,ima09,ima10,ima11,ima12')
      RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF

   #p2,p3
   LET l_str = l_str CLIPPED,";",g_zz05 CLIPPED,";",tm.wc CLIPPED,";",
               tm.b CLIPPED,";",tm.c CLIPPED,";",tm.d CLIPPED,";",tm.type   #CHI-820012 add  ##TQC-A50166 add tm.type

   IF tm.d = "Y" THEN
      IF g_aza.aza63 = 'Y' THEN
         IF tm.line = '1' THEN                #CHI-9B0012  add
            LET l_name = 'axcr430_5'          #CHI-9B0012  add
         ELSE
            LET l_name = 'axcr430_1'
         END IF
      ELSE
         IF tm.line = '1' THEN                #CHI-9B0012  add
            LET l_name = 'axcr430_4'          #CHI-9B0012  add
         ELSE
       	    LET l_name = 'axcr430'
         END IF
      END IF	
     CALL cl_prt_cs3('axcr430',l_name,l_sql,l_str)             #FUN-9A0050 Add
   ELSE
      IF g_aza.aza63 = 'Y' THEN
         IF tm.line = '1' THEN                  #CHI-9B0012  add
            LET l_name = 'axcr430_7'          #CHI-9B0012  add
         ELSE
            LET l_name = 'axcr430_3'
         END IF
      ELSE
         IF tm.line = '1' THEN                  #CHI-9B0012  add
            LET l_name = 'axcr430_6'          #CHI-9B0012  add
         ELSE
       	    LET l_name = 'axcr430_2'
         END IF
      END IF	
     CALL cl_prt_cs3('axcr430',l_name,l_sql,l_str)             #FUN-9A0050 Add
   END IF



END FUNCTION


#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r430_getStartPos(l_sta,l_end,l_str)
   DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5    #No.FUN-680122 SMALLINT
   DEFINE l_str STRING

   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos

END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/12
