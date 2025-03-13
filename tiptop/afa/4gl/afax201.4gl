# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: afax201.4gl
# Descriptions...: 固定財產目錄
# Date & Author..: 96/06/08 By Charis
# Modify.........: 99/12/17 By Carol: add 2 個選項(列印方式改變)
#                                    1.英文名稱列印否:[a] (Y/N)
#                                    2.規格型號列印否:[b] (Y/N)
#
# Modify.........: No.CHI-480001 04/08/11 By Danny  增加資產停用選項/
#                                                   新增大陸版報表段(減值準備)
# Modify.........: No.FUN-510035 05/03/04 By Smapmin 放寬金額欄位
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.MOD-540112 05/04/14 By Nicola IN->MATCHES
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.FUN-5B0057 05/11/15 By Sarah 資產類別、保管部門、保管人員、存放位置增加開窗功能
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.TQC-610106 06/01/20 By Smapmin 成本欄位依金額方式取位
# Modify.........: No.MOD-620007 06/02/08 By Smapmin 小計與跳頁條件錯誤
# Modify.........: No.TQC-650103 06/05/24 By Smapmin 期別條件修改
# Modify.........: No.MOD-670028 06/07/07 By Smapmin 開帳資料也要納入本支報表
# Modify.........: No.TQC-680025 06/08/09 By Tracy 銷賬成本fap56->fap22
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.TQC-690072 06/09/26 By cl      修正前期累折為負數的情況，取消本期累折l_fan08_1
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0054 06/11/15 By Smapmin 新增總計功能
# Modify.........: No.TQC-6C0009 06/12/05 By Rayven 打印‘FROM、頁次’應該在同一行
# Modify.........: No.MOD-710042 07/01/05 By Smapmin 已出售的資產不應出現於報表
# Modify.........: No.MOD-710104 07/01/17 By Dido 當月份出售或銷帳之固定資產不應納入
# Modify.........: No.MOD-710203 07/02/02 By Smapmin 保管人欄位直接印出
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-770019 07/07/06 By Smapmin QBE增加資產狀態
# Modify.........: No.FUN-770033 07/07/31 By destiny 報表改為使用crystal report
# Modify.........: No.MOD-780025 07/08/23 By Smapmin 修改成本計算方式
# Modify.........: No.MOD-840680 08/07/13 By Pengu 成本金額未將調整成本(fap54)扣回
# Modify.........: No.CHI-850036 08/08/15 By Sarah 有報廢當月的成本、折舊金額計算錯誤,狀態顯示錯誤
# Modify.........: No.MOD-8C0038 08/12/04 By Sarah 將CHI-850036修改sr.tmp03段改回LET sr.tmp03 = sr.tmp05- sr.tmp04
# Modify.........: No.MOD-8C0045 08/12/09 By Sarah 修改成本(sr.tmp02)的計算邏輯,參考數量作法,改為
#                                                  成本=目前成本+調整成本-銷帳成本-(大於當期(調整)-大於當期(前一次調整))-大於當期(改良)
# Modify.........: No.MOD-930059 09/03/05 By Sarah 本期折舊計算式應為l_fan08-g_fap54
# Modify.........: No.MOD-930081 09/03/09 By lilingyu 報表增加回溯功能
# Modify.........: No.MOD-930293 09/03/30 By Sarah 抓取累折(fan14)時,若本月抓不到,應往前抓前一年/期
# Modify.........: No.MOD-950280 09/06/03 By Sarah 修正MOD-930293,當資產不需折畢再提,應抓當年最大折舊年月,折畢再提不考慮年度往前抓最大折舊年月
# Modify.........: No.MOD-960037 09/06/04 By baofei 入帳年度大與現行固定資產年度時增加報錯信息
# Modify.........: No.MOD-970072 09/07/09 By wujie 本月售出的也要列印
# Modify.........: No.MOD-980171 09/08/22 By Sarah 盤點過帳後看該月報表,前期折舊/本期折舊/累計折舊有誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0035 09/10/07 By Sarah 若報表回溯時本期折舊值有誤
# Modify.........: No.MOD-9A0007 09/10/19 By sabrina 本期折舊顯示有誤
# Modify.........: No:CHI-990060 09/10/21 By mike FUNCTION afax201(),改抓取l_fan03与l_fan04的写法,                                  
# Modify.........: No:MOD-9C0153 09/12/16 By Sarah 抓取l_fan03與l_fan04前先清空變數值
# Modify.........: No:MOD-A10024 10/01/06 By Sarah 修正MOD-980171,抓取g_fap57的WHERE條件
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No:MOD-AC0038 10/12/03 By Carrier 资产为'2.全部','1.停用'时,不过滤成本为零的资产
# Modify.........: No:MOD-B10186 11/01/25 By Dido 若入帳當月未折舊而是次月折舊時累折金額不可為 faj32,應扣除後面發生的折舊金額 
# Modify.........: No:MOD-B30682 11/03/28 By Dido 狀態邏輯調整 
# Modify.........: No:FUN-B50133 11/06/07 By lixiang 增加列印選項(財簽一、財簽二)
# Modify.........: No:MOD-B60063 11/06/09 By Dido 取消盤點盈虧數量計算
# Modify.........: No:FUN-B60045 11/06/10 By zhangweib QBE增加族群編號,條件選項下拉式菜單增加:族群編號,增加下拉菜單彙總列印,條件選項預設：族群編號>財產編號>資產類別，處理跳頁及小計
# Modify.........: No:MOD-B70258 11/07/29 By Dido 抓取 g_fap57 條件調整
# Modify.........: No:CHI-B70033 11/09/26 By johung 需考慮當月有作折舊調整的fan資料
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
# Modify.........: No:FUN-BB0163 12/01/13 By Sakura 族群資料增加追朔處理(抓取fap27)
# Modify.........: No:MOD-C20210 12/02/24 By Polly 帳面成本需再扣除8重估金額
# Modify.........: No:MOD-C30825 12/03/27 By Polly tm.d = '2'時，應抓取fbn_file資料
# Modify.........: No:MOD-C50131 12/05/21 By Polly 檢核是否有fap_file區間內的資料，若有才用fap27
# Modify.........: No:MOD-C60085 12/06/11 By Polly 調整資料年月份抓取
# Modify.........: No.CHI-C60010 12/06/14 By wangrr 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:MOD-C60049 12/06/22 By Elise 增加一變數判斷折畢時,fan15與調整累折互抵
# Modify.........: No.CHI-C70003 12/07/23 By Belle  增加財產減值欄位
# Modify.........: No.MOD-C90147 12/10/03 By Polly  報廢後資產仍有剩餘數量，狀態應仍為折舊中，並調整本期折舊與累計折計算
# Modify.........: No:MOD-CA0094 12/10/16 by Polly 調整財二資料抓取的SQL格式
# Modify.........: No.TQC-CC0042 12/12/07 By qirl QBE查詢條件開窗
# Modify.........: No.FUN-C90088 12/12/18 By Belle  增加列印年限判斷
# Modify.........: No.MOD-CC0015 13/01/11 By jt_chen 調整報表4gl傳值的順序與XML一致
# Modify.........: No.MOD-D10254 13/01/30 By Polly  調整分頁tm.t參數的傳遞
# Modify.........: No.CHI-D30018 13/03/11 By Polly 調整資產狀態抓取條件
# Modify.........: No.FUN-D30059 13/03/22 By yangtt CR轉XGrid 
# Modify.........: No.FUN-D40128 13/05/14 By wangrr 報表增加"資產類型名稱"欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item    LIKE type_file.num5    #No.FUN-680070 SMALLINT
END GLOBALS
 
DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
              s       LIKE type_file.chr3,          # Order by sequence     #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3,          # Eject sw              #No.FUN-680070 VARCHAR(3)
             #v       LIKE type_file.chr3,          # Group total sw        #No.FUN-680070 VARCHAR(3)  #FUN-D30059 mark
              yy1     LIKE type_file.num5,          #No.FUN-680070 SMALLINT
              mm1     LIKE type_file.num5,          #No.FUN-680070 SMALLINT
              a       LIKE type_file.chr1,          # 英文名稱列印否:[a] (Y/N)       #No.FUN-680070 VARCHAR(1)
              b       LIKE type_file.chr1,          # 規格型號列印否:[b] (Y/N)       #No.FUN-680070 VARCHAR(1)
              c       LIKE type_file.chr1,          # No.CHI-480001       #No.FUN-680070 VARCHAR(1)
              d       LIKE type_file.chr1,          # No.FUN-B50133   (列印選項)  
              e       LIKE type_file.chr1,          # FUN-B60045
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
       g_descripe   ARRAY[3] OF LIKE type_file.chr20,   # Report Heading & prompt   #MOD-620007       #No.FUN-680070 VARCHAR(17)
       g_header     LIKE type_file.chr1000,             #No:8190       #No.FUN-680070 VARCHAR(500)
       g_tot_bal    LIKE type_file.num20_6,      # User defined variable       #No.FUN-680070 DECIMAL(13,2)
       g_fap09      LIKE fap_file.fap09,      #CHI-850036 add
       g_fap10      LIKE fap_file.fap10,      #MOD-780025
       g_fap22      LIKE fap_file.fap22,      #No.TQC-680025
       g_fap45      LIKE fap_file.fap45,      #No.CHI-480001
       g_fap54      LIKE fap_file.fap54,
       g_fap54_7    LIKE fap_file.fap54,      #No.MOD-840680 add
       g_fap57      LIKE fap_file.fap57,
       g_fap660     LIKE fap_file.fap66,
       g_fap661     LIKE fap_file.fap661,     #MOD-780025
       g_fap662     LIKE fap_file.fap66,
       g_fap670     LIKE fap_file.fap67,
       g_fap671     LIKE fap_file.fap67,
       l_curr_qty   LIKE fap_file.fap67,
       g_bdate      LIKE type_file.dat,       #No.FUN-680070 DATE
       g_edate      LIKE type_file.dat,       #No.FUN-680070 DATE
       g_i          LIKE type_file.num5       #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_str        STRING                    #No.FUN-770033                                                                     
DEFINE l_table      STRING                    #No.FUN-770033                                                                     
DEFINE g_sql        STRING                    #No.FUN-770033 
DEFINE g_fap561     LIKE fap_file.fap56       #MOD-930081
#MOD-CC0015  -- modify start #調整順序與XML一致；方便開發、提高CR效能 --
##FUN-B60045   ---start   Add
#DEFINE l_tmp        DYNAMIC ARRAY OF RECORD
#             faf02     LIKE faf_file.faf02,
#             faj02     LIKE faj_file.faj02,
#             faj022    LIKE faj_file.faj022,
#             faj04     LIKE faj_file.faj04,
#             faj05     LIKE faj_file.faj05,
#             faj06     LIKE faj_file.faj06,
#             faj07     LIKE faj_file.faj07,
#             faj08     LIKE faj_file.faj08,
#             faj19     LIKE faj_file.faj19,
#             faj20     LIKE faj_file.faj20,
#             faj21     LIKE faj_file.faj21,
#             faj22     LIKE faj_file.faj22,
#             faj27     LIKE faj_file.faj27,
#             faj29     LIKE faj_file.faj29,
#             faj43     LIKE faj_file.faj43,
#             tmp01     LIKE faj_file.faj60,
#             tmp02     LIKE faj_file.faj60,
#             tmp03     LIKE faj_file.faj60,
#             tmp04     LIKE faj_file.faj60,
#             tmp05     LIKE faj_file.faj60,
#             tmp06     LIKE faj_file.faj60,
#             tmp08     LIKE faj_file.faj60,
#             faj93     LIKE faj_file.faj93
#            ,tmp07     LIKE faj_file.faj60        #CHI-C70003 
#                   END RECORD
DEFINE l_tmp        DYNAMIC ARRAY OF RECORD
              faj04     LIKE faj_file.faj04,
              faj02     LIKE faj_file.faj02,
              faj022    LIKE faj_file.faj022,
              faj20     LIKE faj_file.faj20,
              faj19     LIKE faj_file.faj19,
              faj07     LIKE faj_file.faj07,
              faj06     LIKE faj_file.faj06,
              tmp01     LIKE faj_file.faj60,
              tmp02     LIKE faj_file.faj60,
              tmp03     LIKE faj_file.faj60,
              tmp04     LIKE faj_file.faj60,
              tmp05     LIKE faj_file.faj60,
              tmp06     LIKE faj_file.faj60,
              tmp07     LIKE faj_file.faj60,       #CHI-C70003  
              tmp08     LIKE faj_file.faj60,   
              faj08     LIKE faj_file.faj08,
              faj27     LIKE faj_file.faj27,
              faj29     LIKE faj_file.faj29,
              faf02     LIKE faf_file.faf02,
              faj43     LIKE faj_file.faj43,
              faj05     LIKE faj_file.faj05,
              faj21     LIKE faj_file.faj21,
              faj22     LIKE faj_file.faj22,
              faj93     LIKE faj_file.faj93,       #FUN-B60045
              sts       LIKE type_file.chr20,  #FUN-D30059 add
              azi05     LIKE azi_file.azi05,   #FUN-D30059 add
              l_n       LIKE type_file.num5,   #FUN-D30059 add
              flag      LIKE type_file.chr1,   #FUN-D30059 add
              flag1     LIKE type_file.chr1    #FUN-D30059 add
                    END RECORD
#FUN-B60045   ---start  END 
#MOD-CC0015  -- modify end #調整順序與XML一致；方便開發、提高CR效能 --
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
   #MOD-CC0015  -- modify start #調整sql與XML一致；方便開發、提高CR效能 -- 
   #LET g_sql="faf02.faf_file.faf02,",                                                                                              
   #          "faj02.faj_file.faj02,",                                                                                              
   #          "faj022.faj_file.faj022,",                                                                                            
   #          "faj04.faj_file.faj04,",                                                                                              
   #          "faj05.faj_file.faj05,",                                                                                              
   #          "faj06.faj_file.faj06,",                                                                                              
   #          "faj07.faj_file.faj07,",                                                                                              
   #          "faj08.faj_file.faj08,",                                                                                              
   #          "faj19.faj_file.faj19,",                                                                                              
   #          "faj20.faj_file.faj20,",                                                                                              
   #          "faj21.faj_file.faj21,",                                                                                              
   #          "faj22.faj_file.faj22,",                                                                                              
   #          "faj27.faj_file.faj27,",                                                                                              
   #          "faj29.faj_file.faj29,",                                                                                              
   #          "faj43.faj_file.faj43,",                                                                                              
   #          "tmp01.faj_file.faj60,",
   #          "tmp02.faj_file.faj60,",
   #          "tmp03.faj_file.faj60,",
   #          "tmp04.faj_file.faj60,",
   #          "tmp05.faj_file.faj60,",
   #          "tmp06.faj_file.faj60,",
   #          "tmp08.faj_file.faj60"
   #         ,",faj93.faj_file.faj93"                             #FUN-B60045   Add
   #        ,",tmp07.faj_file.faj60"                              #CHI-C70003   Add
    LET g_sql="faj04.faj_file.faj04,",
              "faj02.faj_file.faj02,",
              "faj022.faj_file.faj022,",
              "faj20.faj_file.faj20,",
              "faj19.faj_file.faj19,",
              "faj07.faj_file.faj07,",
              "faj06.faj_file.faj06,",
              "tmp01.faj_file.faj60,",
              "tmp02.faj_file.faj60,",
              "tmp03.faj_file.faj60,",
              "tmp04.faj_file.faj60,",
              "tmp05.faj_file.faj60,",
              "tmp06.faj_file.faj60,",
              "tmp07.faj_file.faj60,",                             #CHI-C70003   
              "tmp08.faj_file.faj60,",                             #MOD-CC0015   
              "faj08.faj_file.faj08,",
              "faj27.faj_file.faj27,",
              "faj29.faj_file.faj29,",
              "faf02.faf_file.faf02,",
              "faj43.faj_file.faj43,",
              "faj05.faj_file.faj05,",
              "faj21.faj_file.faj21,",
              "faj22.faj_file.faj22,",
              "faj93.faj_file.faj93,",                            #FUN-B60045 
              "sts.type_file.chr20,",  #FUN-D30059 add 
              "azi05.azi_file.azi05,", #FUN-D30059 add 
              "l_n.type_file.num5,",   #FUN-D30059 add
              "flag.type_file.chr1,",  #FUN-D30059 add
              "flag1.type_file.chr1"   #FUN-D30059 add
             ,",fab02.fab_file.fab02"  #FUN-D40128

   #MOD-CC0015  -- modify end #調整sql與XML一致；方便開發、提高CR效能 --
     LET l_table = cl_prt_temptable('afax201',g_sql) CLIPPED                                                                        
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                         
               "        ?,?,?,?,?, ?,?,?,?,?,",                                                                                         
               "        ?,?,?,?,?, ?,?,?,?,?)"  #CHI-C70003 Add ,? #FUN-B60045 Add  ,?   FUN-D30059 add 5? #FUN-D40128 add 1?                                                                                      
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
    END IF                                                                                                                          
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
  #LET tm.v  = ARG_VAL(10) #FUN-D30059 mark
  #FUN-D30059----mod---str--
  #LET tm.yy1= ARG_VAL(11)
  #LET tm.mm1= ARG_VAL(12)
  #LET tm.a  = ARG_VAL(13)
  #LET tm.b  = ARG_VAL(14)
  #LET tm.c  = ARG_VAL(15)                     #No.CHI-480001
  #LET g_rep_user = ARG_VAL(16)
  #LET g_rep_clas = ARG_VAL(17)
  #LET g_template = ARG_VAL(18)
  #LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   LET tm.yy1= ARG_VAL(10)
   LET tm.mm1= ARG_VAL(11)
   LET tm.a  = ARG_VAL(12)
   LET tm.b  = ARG_VAL(13)
   LET tm.c  = ARG_VAL(14)                     #No.CHI-480001
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
  #FUN-D30059----mod---str--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        #If background job sw is off
      THEN CALL afax201_tm(0,0)                #Input print condition
      ELSE CALL afax201()                      #Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afax201_tm(p_row,p_col)
DEFINE   lc_qbe_sn     LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE   p_row,p_col   LIKE type_file.num5,      #No.FUN-680070 SMALLINT
         l_cmd         LIKE type_file.chr1000    #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW afax201_w AT p_row,p_col WITH FORM "afa/42f/afax201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = 'C31'              #FUN-B60045   123 --> C31
   LET tm.t    = 'Y  '
  #LET tm.v    = 'Y  '  #FUN-D30059 mark
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy1   = g_faa.faa07
   LET tm.mm1   = g_faa.faa08
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.c    = '0'                         #No.CHI-480001
   LET tm.d    = '1'       #No.FUN-B50133
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
#  LET tm2.u1   = tm.v[1,1]  #FUN-D30059 mark
#  LET tm2.u2   = tm.v[2,2]  #FUN-D30059 mark
#  LET tm2.u3   = tm.v[3,3]  #FUN-D30059 mark
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
#  IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF  #FUN-D30059 mark
#  IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF  #FUN-D30059 mark
#  IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF  #FUN-D30059 mark
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj02,faj20,faj19,faj43,faj06,faj27,   #MOD-770019
                                 faj14,faj21,faj22
                                ,faj93     #FUN-B60045
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
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
 
         ON ACTION controlp
            CASE
             #----TQC-CC0042-----add--star--
               WHEN INFIELD(faj05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_faj051"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO faj05
                    NEXT FIELD faj05
               WHEN INFIELD(faj02)   #保管部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_faj"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO faj02
                    NEXT FIELD faj02
             #----TQC-CC0042-----add--end--
               WHEN INFIELD(faj04)   #資產類別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_fab"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO faj04
                    NEXT FIELD faj04
               WHEN INFIELD(faj20)   #保管部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO faj20
                    NEXT FIELD faj20
               WHEN INFIELD(faj19)   #保管人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO faj19
                    NEXT FIELD faj19
               WHEN INFIELD(faj21)   #存放位置
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_faf"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO faj21
                    NEXT FIELD faj21
               WHEN INFIELD(faj22)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_azp"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO faj22
                    NEXT FIELD faj22
#FUN-B60045   ---start   Add
               WHEN INFIELD(faj93)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_faj93"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO faj93
                    NEXT FIELD faj93
#FUN-B60045   ---end     Add
            END CASE
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afax201_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
     #DISPLAY BY NAME tm.s,tm.t,tm.v,tm.yy1,tm.mm1,tm.a,tm.b,tm.d,tm.more     #No.FUN-B50133 add tm.d  #FUN-D30059 mark
      DISPLAY BY NAME tm.s,tm.t,tm.yy1,tm.mm1,tm.a,tm.b,tm.d,tm.more     #No.FUN-B50133 add tm.d  #FUN-D30059 add
      INPUT BY NAME
         tm.e,tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,                 #FUN-B60045   Add tm.e
        #tm2.u1,tm2.u2,tm2.u3,tm.yy1,tm.mm1,tm.a,tm.b,tm.c,tm.d,tm.more #No.CHI-480001   #No.FUN-B50133 add tm.d #FUN-D30059 mark
         tm.yy1,tm.mm1,tm.a,tm.b,tm.c,tm.d,tm.more #No.CHI-480001   #No.FUN-B50133 add tm.d  #FUN-D30059 add
         WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD yy1
            IF cl_null(tm.yy1) THEN
               NEXT FIELD FORMONLY.yy1
            END IF
            IF tm.yy1> g_faa.faa07  THEN    ##不可大於固定資產年度
               CALL cl_err('','afa-202',0)   #MOD-960037 
               NEXT FIELD FORMONLY.yy1
            END IF
 
         AFTER FIELD mm1
         IF NOT cl_null(tm.mm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.mm1 > 12 OR tm.mm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm1
               END IF
            ELSE
               IF tm.mm1 > 13 OR tm.mm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm1
               END IF
            END IF
         END IF
            IF cl_null(tm.mm1) THEN
               NEXT FIELD FORMONLY.mm1
            END IF
 
         AFTER FIELD a
            IF tm.a NOT MATCHES "[YN]" THEN
               NEXT FIELD FORMONLY.a
            END IF
 
         AFTER FIELD b
            IF tm.b NOT MATCHES "[YN]" THEN
               NEXT FIELD FORMONLY.b
            END IF
 
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES "[012]" THEN
               NEXT FIELD FORMONLY.c
            END IF
 
       #No.FUN-B50133--add--start--
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES "[12]" THEN
               NEXT FIELD FORMONLY.d
            END IF
       #No.FUN-B50133--add-end--

#FUN-B60045   ---start   Add
         AFTER FIELD e
            IF NOT cl_null(tm.e) THEN
               LET tm.a = 'N'
               LET tm.b = 'N'
               IF tm.e = '1' THEN
                  LET tm2.s1 = 'C'
               ELSE
                  LET tm2.s1 = '3'
               END IF
               LET tm2.t1 = 'Y'
            #  LET tm2.u1 = 'N'  #FUN-D30059 mark
               LET tm2.s2 = 'N'
               LET tm2.s3 = 'N'
               LET tm2.t2 = 'N'
               LET tm2.t3 = 'N'
            #  LET tm2.u2 = 'N'  #FUN-D30059 mark
            #  LET tm2.u3 = 'N'  #FUN-D30059 mark
              #DISPLAY BY NAME tm.a,tm.b,tm2.s1,tm2.t1,tm2.u1,tm2.s2,tm2.s3,tm2.t2,tm2.t3,tm2.u2,tm2.u3  #FUN-D30059 mark
               DISPLAY BY NAME tm.a,tm.b,tm2.s1,tm2.t1,tm2.s2,tm2.s3,tm2.t2,tm2.t3  #FUN-D30059 add
               CALL cl_set_comp_entry('a,b,s1,s2,s3,t2,t3,u1,u2,u3',FALSE)
            ELSE
               LET tm.a = 'Y'
               LET tm.b = 'Y'
               LET tm2.s1 = 'C'
               LET tm2.s2 = '3'
               LET tm2.s3 = '1'
               LET tm2.t1 = 'Y'
               LET tm2.t2 = 'N'
               LET tm2.t3 = 'N'
              #LET tm2.u1 = 'Y'  #FUN-D30059 mark
              #LET tm2.u2 = 'N'  #FUN-D30059 mark
              #LET tm2.u3 = 'N'  #FUN-D30059 mark
              #DISPLAY BY NAME tm.a,tm.b,tm2.s1,tm2.t1,tm2.u1,tm2.s2,tm2.s3,tm2.t2,tm2.t3,tm2.u2,tm2.u3  #FUN-D30059 mark
               DISPLAY BY NAME tm.a,tm.b,tm2.s1,tm2.t1,tm2.s2,tm2.s3,tm2.t2,tm2.t3  #FUN-D30059 add
               CALL cl_set_comp_entry('a,b,s1,s2,s3,t2,t3,u1,u2,u3',TRUE)
            END IF
#FUN-B60045   ---end     Add

         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD FORMONLY.more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
           #LET tm.v = tm2.u1,tm2.u2,tm2.u3  #FUN-D30059 mark
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
         LET INT_FLAG = 0 CLOSE WINDOW afax201_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afax201'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afax201','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                           #" '",tm.v CLIPPED,"'",  #FUN-D30059 mark
                            " '",tm.yy1 CLIPPED,"'",
                            " '",tm.mm1 CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'",
                            " '",tm.c CLIPPED,"'",     #No.CHI-480001
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afax201',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afax201_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afax201()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afax201_w
END FUNCTION
 
FUNCTION afax201()
DEFINE l_n      LIKE type_file.num5   #FUN-B60045   Add
   DEFINE l_name     LIKE type_file.chr20,             # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
          l_sql      LIKE type_file.chr1000,           # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr      LIKE type_file.chr1,              #No.FUN-680070 VARCHAR(1)
          l_za05     LIKE type_file.chr1000,           #No.FUN-680070 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(30)
          l_bdate,l_edate LIKE type_file.dat,          #No.FUN-680070 DATE
          l_year,l_mon LIKE type_file.num5,            #No.FUN-680070 SMALLINT
          l_fan03      LIKE fan_file.fan03,            #MOD-930293 add
          l_fan04      LIKE fan_file.fan04,
          l_fan07      LIKE fan_file.fan07,            #MOD-B10186
          l_fan08      LIKE fan_file.fan08,
          l_fan14      LIKE fan_file.fan14,
          l_fan15      LIKE fan_file.fan15,
          l_fan17      LIKE fan_file.fan17,            #No.CHI-480001
          l_cnt        LIKE type_file.num5,            #No.FUN-680070 SMALLINT
          l_fap04      LIKE fap_file.fap04,
          l_fap03      LIKE fap_file.fap03,
          l_fap06      LIKE fap_file.fap06,            #CHI-D30018 add
          l_faj34      LIKE faj_file.faj34,            #MOD-950280 add
          sr           RECORD order1 LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(30)
                              order2 LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(30)
                              order3 LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(30)
                              faj04  LIKE faj_file.faj04,    # 資產分類
                              fab02  LIKE fab_file.fab02,    #
                              faj05  LIKE faj_file.faj05,    # 資產分類
                              faj02  LIKE faj_file.faj02,    # 財產編號
                              faj022 LIKE faj_file.faj022,   # 財產附號
                              faj20  LIKE faj_file.faj20,    # 保管部門
                              faj21  LIKE faj_file.faj21,    # 存放位置
                              faf02  LIKE faf_file.faf02,    # 名稱
                              faj19  LIKE faj_file.faj19,    # 保管人
                              gen02  LIKE gen_file.gen02,    # 保管人姓名
                              faj07  LIKE faj_file.faj07,    # 英文名稱
                              faj06  LIKE faj_file.faj06,    # 中文名稱
                              faj17  LIKE faj_file.faj17,    # 數量
                              faj58  LIKE faj_file.faj58,    # 銷帳數量
                              faj08  LIKE faj_file.faj08,    # 規格型號
                              faj27  LIKE faj_file.faj27,    # 折舊年月
                              faj29  LIKE faj_file.faj29,    # 耐用年限
                              faj14  LIKE faj_file.faj14,    # 本幣成本
                              faj141 LIKE faj_file.faj141,   # 調整成本
                              faj59  LIKE faj_file.faj59,    # 銷帳成本
                              faj32  LIKE faj_file.faj32,    # 累績折舊
                              faj43  LIKE faj_file.faj43,    # 狀態
                              faj57  LIKE faj_file.faj57,
                              faj571 LIKE faj_file.faj571,
                              faj100 LIKE faj_file.faj100,
                              faj60  LIKE faj_file.faj60,    # 銷帳累折
                              tmp01  LIKE faj_file.faj60,    # 數量
                              tmp02  LIKE faj_file.faj60,    # 成本
                              tmp03  LIKE faj_file.faj60,    # 前期累折
                              tmp04  LIKE faj_file.faj60,    # 本期累折
                              tmp05  LIKE faj_file.faj60,    # 累積折舊
                              tmp06  LIKE faj_file.faj60,    # 帳面價值
                              tmp07  LIKE faj_file.faj60,    # 減值準備
                              tmp08  LIKE faj_file.faj60,    # 資產淨額
                              faj101 LIKE faj_file.faj101,   # 減值準備
                              faj102 LIKE faj_file.faj102,   # 銷帳減值
                              faj22  LIKE faj_file.faj22,    #MOD-620007
                              faj93  LIKE faj_file.faj93,    #FUN-B60045
                              faj31  LIKE faj_file.faj31,    #CHI-D30018 add
                              faj34  LIKE faj_file.faj34     #CHI-D30018 add
                        END RECORD
     DEFINE l_i               LIKE type_file.num5            #No.FUN-680070 SMALLINT
     DEFINE l_zaa02           LIKE zaa_file.zaa02
     #CHI-B70033 -- begin --
     DEFINE l_adj_fan07       LIKE fan_file.fan07,
            l_curr_fan07      LIKE fan_file.fan07,
            l_pre_fan15       LIKE fan_file.fan15
     #CHI-B70033 -- end --
     DEFINE l_sub_fan07       LIKE fan_file.fan07  #MOD-C60049
   DEFINE l_azi04  LIKE azi_file.azi04   #CHI-C60010 add
   DEFINE l_azi05  LIKE azi_file.azi05   #CHI-C60010 add
   DEFINE l_fap93           LIKE fap_file.fap83            #FUN-C90088
   DEFINE l_sts    LIKE type_file.chr20  #FUN-D30059 add
   DEFINE l_flag   LIKE type_file.chr1   #FUN-D30059 add
   DEFINE l_flag1  LIKE type_file.chr1   #FUN-D30059 add
   DEFINE l_n1     LIKE type_file.num5   #FUN-D30059 add
   DEFINE l_fab02  LIKE fab_file.fab02   #FUN-D40128

   #FUN-C90088--B--
   IF tm.d = 1 THEN
      LET l_sql = " SELECT fap93  FROM fap_file"
   ELSE
      LET l_sql = " SELECT fap932 FROM fap_file"
   END IF
   LET l_sql = l_sql ,"  WHERE fap03 ='9'"
                     ,"    AND fap02 = ? AND fap021= ? AND fap04 < ?"
                     ,"  ORDER BY fap04 desc"
   PREPARE x201_p01 FROM l_sql
   DECLARE x201_c01 SCROLL CURSOR WITH HOLD FOR x201_p01
   #FUN-C90088--E--
 
     LET l_n = 1     #FUN-B60045   Add
     CALL l_tmp.clear()  #FUN-B60045   Add
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-770033
     CALL cl_del_data(l_table)                                   #No.FUN-770033 

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
 
      CALL s_azn01(tm.yy1,tm.mm1) RETURNING g_bdate,g_edate
     IF tm.d = '1' THEN                #No.FUN-B50133  ADD
        LET l_sql = "SELECT '','','',",
                    " faj04, fab02,faj05,",
                    " faj02,faj022,faj20,faj21,faf02,",
                    " faj19,gen02,faj07,faj06,faj17,faj58,",
                    " faj08,faj27,faj29,faj14,faj141,faj59,",
                    " faj32,faj43,faj57,faj571,faj100,faj60,0,0,0,0,0,0,",
                    " 0,0,faj101,faj102,faj22 ",                                #MOD-620007
                    " ,faj93,faj31,faj34 ",                                     #FUN-B60045 Add #CHI-D30018 add faj31,faj34
                    "  FROM faj_file,OUTER fab_file,OUTER gen_file,OUTER faf_file",
                    " WHERE fajconf='Y' AND ",tm.wc CLIPPED,
                    " AND faj26 <='",g_edate,"'",
                    " AND faj_file.faj19 = gen_file.gen01 ",
                    " AND faj_file.faj21 = faf_file.faf01 ",
                    " AND faj_file.faj04 = fab_file.fab01 "
   #No.FUN-B50133---add--start--
     ELSE
        LET l_sql = "SELECT '','','',",
                    " faj04, fab02,faj05,",
                    " faj02,faj022,faj20,faj21,faf02,",
                    " faj19,gen02,faj07,faj06,faj17,faj582,",
                    " faj08,faj272,faj292,faj142,faj1412,faj592,",
                    " faj322,faj432,faj572,faj5712,faj100,faj602,0,0,0,0,0,0,",
                    " 0,0,faj1012,faj1022,faj22 ",  
                    " ,faj93,faj31,faj34 ",                                         #FUN-B60045 Add #CHI-D30018 add faj31,faj34
                    "  FROM faj_file,OUTER fab_file,OUTER gen_file,OUTER faf_file",
                    " WHERE fajconf='Y' AND ",tm.wc CLIPPED,
                    " AND faj262 <='",g_edate,"'",
                    " AND faj_file.faj19 = gen_file.gen01 ",
                    " AND faj_file.faj21 = faf_file.faf01 ",
                    " AND faj_file.faj04 = fab_file.fab01 "
     END IF    
   #No.FUN-B50133---add--end----

     IF tm.c = '1' THEN    #停用
        #LET l_sql = l_sql CLIPPED," AND faj105 = 'Y' " #No.FUN-B80081 mark
         LET l_sql = l_sql CLIPPED," AND faj43 = 'Z' "   #FUN-B80081 add
     END IF
     IF tm.c = '0' THEN    #正常使用
        LET l_sql = l_sql CLIPPED,
                   #" AND (faj105 = 'N' OR faj105 IS NULL OR faj105 = ' ') " #No.FUN-B80081 mark
                    " AND faj43<>'Z' "  #FUN-B80081 add
     END IF
 
     PREPARE afax201_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afax201_curs1 CURSOR FOR afax201_prepare1
     #--------------取得當時的資料狀態
     #LET l_sql = " SELECT fap04,fap03 FROM fap_file ",                  #CHI-D30018 mark
      LET l_sql = " SELECT fap04,fap03,fap06 FROM fap_file ",            #CHI-D30018 add fap06
                  " WHERE fap02 = ? AND fap021= ? ",
                  " AND fap04 BETWEEN '",g_bdate,"' AND '",g_edate,"'",  #CHI-850036 add
                  " ORDER BY fap04 DESC  "
     PREPARE x201_pre2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE x201_curs2 SCROLL CURSOR FOR x201_pre2

    #-MOD-B30682-add- 
    #取得未來的資料狀態
     LET l_sql = " SELECT fap04,fap05 FROM fap_file ",
                 " WHERE fap02 = ? AND fap021= ? ",
                 " AND fap04 > '",g_edate,"'",  
                 " ORDER BY fap04 "
     PREPARE x201_pre3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE x201_curs3 SCROLL CURSOR FOR x201_pre3
    #-MOD-B30682-add-
 
   IF cl_null(tm.e) THEN      #FUN-B60045    Add
      IF g_aza.aza26='2'   THEN
        IF tm.a='Y'        THEN
          IF tm.b='Y'      THEN 
             LET l_name='afax201'
             LET l_flag = 'Y'  #FUN-D30059 add
             LET l_flag1 = 'Y' #FUN-D30059 add
          ELSE 
             LET l_name='afax201_2'
             LET l_flag = 'Y'  #FUN-D30059 add
             LET l_flag1 = 'Y' #FUN-D30059 add
          END IF
        ELSE
          IF tm.b='Y'      THEN
             LET l_name='afax201_6'
             LET l_flag = 'Y'  #FUN-D30059 add
             LET l_flag1 = 'Y' #FUN-D30059 add
          ELSE 
             LET l_name='afax201_4'
             LET l_flag = 'Y'  #FUN-D30059 add
             LET l_flag1 = 'Y' #FUN-D30059 add
          END IF
        END IF
      ELSE
        IF tm.a='Y'        THEN
          IF tm.b='Y'      THEN
             LET l_name='afax201_5'
             LET l_flag = 'Y'  #FUN-D30059 add
             LET l_flag1 = 'Y' #FUN-D30059 add
          ELSE 
             LET l_name='afax201_7'
             LET l_flag = 'Y'  #FUN-D30059 add
             LET l_flag1 = 'Y' #FUN-D30059 add
          END IF
        ELSE
          IF tm.b='Y'      THEN
             LET l_name='afax201_3'
             LET l_flag = 'Y'  #FUN-D30059 add
             LET l_flag1 = 'Y' #FUN-D30059 add
          ELSE 
             LET l_name='afax201_1'
             LET l_flag = 'Y'  #FUN-D30059 add
             LET l_flag1 = 'Y' #FUN-D30059 add
          END IF
        END IF
      END IF 
#FUN-B60045   ---start   Add
   ELSE
      IF tm.e = '1' THEN
         LET l_name='afax201_8'
         LET l_flag = 'N'  #FUN-D30059 add
         LET l_flag1 = 'N' #FUN-D30059 add
      ELSE
         LET l_name='afax201_9'  
         LET l_flag = 'N'  #FUN-D30059 add
         LET l_flag1 = 'Y' #FUN-D30059 add
      END IF
   END IF
#FUN-B60045   ---end     Add
      CALL cl_prt_pos_len()
    LET g_pageno = 0

     FOREACH afax201_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #---上線後(5)出售(6)銷帳報廢不包含(當年度處份者要納入)
       SELECT count(*) INTO l_cnt FROM fap_file
          WHERE fap02=sr.faj02 AND fap021=sr.faj022
             AND fap77 IN ('5','6') AND (YEAR(fap04) < tm.yy1  
             OR (YEAR(fap04) = tm.yy1 AND MONTH(fap04) < tm.mm1)) #MOD-710104   #No.MOD-970072 
       IF l_cnt > 0 THEN CONTINUE FOREACH END IF
       #---上線期初值
       CALL s_azn01(sr.faj57,sr.faj571) RETURNING l_bdate,l_edate

       LET g_fap09 = 0 LET g_fap10 = 0
       LET g_fap22 = 0 LET g_fap45 = 0
       LET g_fap54 = 0 LET g_fap57 = 0
       LET g_fap660= 0 LET g_fap661= 0 LET g_fap662= 0
       LET g_fap670= 0 LET g_fap671= 0
       LET g_fap561 = 0                #MOD-930081 add
 
       #----推算至截止日期之資產數量
       CALL x201_cal(sr.faj02,sr.faj022)
 
       #數量=目前數量-銷帳數量-大於當期(異動值)+大於當期(銷帳)-大於當期(調整)
       LET sr.tmp01=sr.faj17-sr.faj58 - g_fap660 + g_fap670 - g_fap662
 
       #----本期累折/成本/累折
       LET l_fan14 = 0
       IF tm.d = '1' THEN                          #MOD-C30825 add
          SELECT fan14                   
            INTO l_fan14 FROM fan_file
           WHERE fan01=sr.faj02 AND fan02=sr.faj022
             AND fan03 = tm.yy1 AND fan04 = tm.mm1
            #AND fan041 = '1'   #MOD-670028
             AND fan041 IN ('0','1')    #MOD-670028
             AND fan05 IN ('1','2')    #No.MOD-540112
      #-------------------------MOD-C30825------------------(S)
       ELSE
          SELECT fbn14
            INTO l_fan14 FROM fbn_file
           WHERE fbn01 = sr.faj02
             AND fbn02 = sr.faj022
             AND fbn03 = tm.yy1
             AND fbn04 = tm.mm1
             AND fbn041 IN ('0','1')
             AND fbn05 IN ('1','2')
       END IF
      #-------------------------MOD-C30825------------------(E)
       IF cl_null(l_fan14) THEN LET l_fan14=0 END IF
 
       LET l_fan08 = 0    LET l_fan15 = 0    LET l_fan17 = 0
       IF tm.d = '1' THEN                          #MOD-C30825 add
          SELECT SUM(fan08),SUM(fan15),SUM(fan17)
            INTO l_fan08,l_fan15,l_fan17 FROM fan_file      #end No.CHI-480001
              WHERE fan01=sr.faj02 AND fan02=sr.faj022
                AND fan03 = tm.yy1 AND fan04 = tm.mm1
                AND fan041 IN ('0','1')    #MOD-670028
                AND fan05 IN ('1','2')    #No.MOD-540112
      #-------------------------MOD-C30825------------------(S)
       ELSE
          SELECT SUM(fbn08),SUM(fbn15),SUM(fbn17)
            INTO l_fan08,l_fan15,l_fan17
            FROM fbn_file
           WHERE fbn01 = sr.faj02
             AND fbn02 = sr.faj022
             AND fbn03 = tm.yy1
             AND fbn04 = tm.mm1
             AND fbn041 IN ('0','1')
             AND fbn05 IN ('1','2')
       END IF
      #-------------------------MOD-C30825------------------(E)
      #IF SQLCA.sqlcode OR cl_null(l_fan08) THEN          #MOD-CA0094  mark
       IF SQLCA.sqlcode THEN                              #MOD-CA0094  add
        #  SELECT faj34 INTO l_faj34 FROM faj_file         #No.FUN-B50133 mark
        #   WHERE faj02 = sr.faj02 ANd faj022 = sr.faj022  #No.FUN-B50133 mark
      #No.FUN-B50133---add--start--
          IF tm.d = '1' THEN
             SELECT faj34 INTO l_faj34 FROM faj_file
              WHERE faj02 = sr.faj02 ANd faj022 = sr.faj022
          ELSE
             SELECT faj342 INTO l_faj34 FROM faj_file
              WHERE faj02 = sr.faj02 ANd faj022 = sr.faj022
          END IF
      #No.FUN-B50133---add--end----
         #-MOD-B70258-mark-
         #IF l_faj34 = 'Y' THEN   #折毕再提,不考虑年度往前抓最后一期折旧年月                                                        
         #   LET l_sql="SELECT fan03,fan04 FROM fan_file",                                                                          
         #             " WHERE fan01 = '",sr.faj02,"' AND fan02 = '",sr.faj022,"'",                                                 
         #             "   AND fan03*12+fan04 <= ",tm.yy1*12+tm.mm1,                                                                
         #             "   AND fan041 MATCHES '[01]' ",                                                                             
         #             "   AND fan05 MATCHES '[12]' ",                                                                              
         #             " ORDER BY fan03 desc,fan04 desc "                                                                           
         #ELSE                                                                                                                      
         #-MOD-B70258-end-
          IF tm.d = '1' THEN                          #MOD-C30825 add
             LET l_sql="SELECT fan03,fan04 FROM fan_file",                                                                          
                       " WHERE fan01 = '",sr.faj02,"' AND fan02 = '",sr.faj022,"'",                                                 
                       "   AND fan03 = ",tm.yy1," AND fan04 < ",tm.mm1,                                                             
                      #"   AND fan041 MATCHES '[01]' ",      #MOD-B70258 mark 
                       "   AND fan041 IN ('0','1') ",        #MOD-B70258
                      #"   AND fan05 MATCHES '[12]' ",       #MOD-B70258 mark    
                       "   AND fan05 IN ('1','2') ",         #MOD-B70258
                       " ORDER BY fan03 desc,fan04 desc "                                                                           
         #-------------------------MOD-C30825------------------(S)
          ELSE
             LET l_sql="SELECT fbn03,fbn04 FROM fbn_file",
                       " WHERE fbn01 = '",sr.faj02,"'",
                       "   AND fbn02 = '",sr.faj022,"'",
                       "   AND fbn03 = '",tm.yy1,"'",
                       "   AND fbn04 < '",tm.mm1,"'",      #MOD-CA0094 add
                      #"   AND fbn04 < '",tm.mm1,",",      #MOD-CA0094 mark
                       "   AND fbn041 IN ('0','1') ",
                       "   AND fbn05 IN ('1','2') ",
                       " ORDER BY fbn03 DESC,fbn04 DESC "
          END IF
         #-------------------------MOD-C30825------------------(S)
         #END IF   #MOD-B70258 mark 
          PREPARE afax201_prepare_fan FROM l_sql                                                                                    
          DECLARE afax201_curs_fan CURSOR FOR afax201_prepare_fan                                                                   
          LET l_fan03=''  LET l_fan04=''  #MOD-9C0153 add
          FOREACH afax201_curs_fan INTO l_fan03,l_fan04                                                                             
             EXIT FOREACH                                                                                                           
          END FOREACH                                                                                                               
          IF cl_null(l_fan03) THEN LET l_fan03 = 0 END IF   #MOD-930293 add
          IF cl_null(l_fan04) THEN LET l_fan04 = 0 END IF
 
          IF SQLCA.sqlcode OR l_fan04 = 0 THEN
            #-MOD-B10186-add-
             IF tm.d = '1' THEN                          #MOD-C30825 add
                SELECT SUM(fan07) INTO l_fan07
                  FROM fan_file
                 WHERE fan01 = sr.faj02 
                   AND fan02 = sr.faj022
                   AND ((fan03 > tm.yy1) OR (fan03 = tm.yy1 AND fan04 > tm.mm1)) 
            #-------------------------MOD-C30825------------------(S)
             ELSE
                SELECT SUM(fbn07) INTO l_fan07
                  FROM fbn_file
                 WHERE fbn01 = sr.faj02
                   AND fbn02 = sr.faj022
                   AND ((fbn03 > tm.yy1) OR (fbn03 = tm.yy1 AND fbn04 > tm.mm1))
             END IF
            #-------------------------MOD-C30825------------------(E)
             IF cl_null(l_fan07) THEN LET l_fan07 = 0 END IF
             LET sr.faj32 = sr.faj32 - l_fan07
             IF sr.faj32 < 0 THEN LET sr.faj32 = 0 END IF
            #-MOD-B10186-end-
             #----視為折畢
             LET l_fan14 = sr.faj14 + sr.faj141  #成本
             LET l_fan08 = 0                     #本期折舊
             LET l_fan15 = sr.faj32              #累折
             LET l_fan17 = sr.faj101             #減值準備  #No.CHI-480001
             LET g_fap22 = 0      #No.TQC-680025
          ELSE
             #----本期累折/成本/累折
             LET l_fan14 = 0
             IF tm.d = '1' THEN                          #MOD-C30825 add
                SELECT fan14                                
                  INTO l_fan14 FROM fan_file
                 WHERE fan01=sr.faj02 AND fan02=sr.faj022
                   AND fan03 = l_fan03 AND fan04= l_fan04   #TQC-650103  #MOD-930293 
                   AND fan041 IN ('0','1')    #MOD-670028
                   AND fan05 IN ('1','2')    #No.MOD-540112
            #-------------------------MOD-C30825------------------(S)
             ELSE
                SELECT fbn14
                  INTO l_fan14 FROM fbn_file
                 WHERE fbn01 = sr.faj02
                   AND fbn02 = sr.faj022
                   AND fbn03 = l_fan03
                   AND fbn04= l_fan04
                   AND fbn041 IN ('0','1')
                   AND fbn05 IN ('1','2')
             END IF
            #-------------------------MOD-C30825------------------(E)
             LET l_fan08 = 0    LET l_fan15 = 0   LET l_fan17 = 0
             IF tm.d = '1' THEN                          #MOD-C30825 add
                SELECT SUM(fan08),SUM(fan15),SUM(fan17)
                  INTO l_fan08,l_fan15,l_fan17 FROM fan_file   #end No.CHI-480001
                 WHERE fan01=sr.faj02 AND fan02=sr.faj022
                   AND fan03 = l_fan03 AND fan04= l_fan04   #TQC-650103  #MOD-930293 
                   AND fan05 IN ('1','2')   #No.MOD-540112
            #-------------------------MOD-C30825------------------(S)
             ELSE
                SELECT SUM(fbn08),SUM(fbn15),SUM(fbn17)
                  INTO l_fan08,l_fan15,l_fan17
                  FROM fbn_file
                 WHERE fbn01 = sr.faj02
                   AND fbn02 = sr.faj022
                   AND fbn03 = l_fan03
                   AND fbn04= l_fan04
                   AND fbn05 IN ('1','2')
             END IF
            #-------------------------MOD-C30825------------------(E)
          END IF
       ELSE
          LET l_fan03 = tm.yy1
          LET l_fan04 = tm.mm1
       END IF
       IF cl_null(l_fan08) THEN LET l_fan08 = 0 END IF
       IF l_fan03 < tm.yy1 THEN LET l_fan08 = 0 END IF      #MOD-9A0007 add
       IF cl_null(l_fan17) THEN LET l_fan17 = 0 END IF      #No.CHI-480001
       IF g_fap09=0 THEN LET g_fap09=l_fan14 END IF   #CHI-850036 add

       #CHI-B70033 -- begin --
       LET l_cnt = 0
       LET l_adj_fan07 = 0
       LET l_sub_fan07 = 0   #MOD-C60049
       IF tm.d = '1' THEN                          #MOD-C30825 add
          SELECT COUNT(*) INTO l_cnt FROM fan_file
           WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
             AND fan03 = tm.yy1 AND fan04 = tm.mm1
             AND fan041 = '1'
         #------------------------MOD-C60085-------------------(S)
          IF (tm.yy1 >= sr.faj57 AND tm.mm1>sr.faj571) THEN
             SELECT SUM(fan07) INTO l_adj_fan07 FROM fan_file
              WHERE fan01 = sr.faj02
                AND fan02 = sr.faj022
                AND ((fan03 = sr.faj57 AND fan04 > sr.faj571) AND (fan03 = tm.yy1 AND fan04 <= tm.mm1))
                AND fan041 = '2'
          END IF
         #------------------------MOD-C60085-------------------(E)
          IF tm.yy1 = sr.faj57 AND tm.mm1 = sr.faj571 THEN          #MOD-C60085 add
             SELECT SUM(fan07) INTO l_adj_fan07 FROM fan_file
              WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
                AND fan03 = tm.yy1 AND fan04 = tm.mm1
                AND fan041 = '2'
          END IF                                                    #MOD-C60085 add
      #-------------------------MOD-C30825------------------(S)
       ELSE
          SELECT COUNT(*) INTO l_cnt FROM fbn_file
           WHERE fbn01 = sr.faj02
             AND fbn02 = sr.faj022
             AND fbn03 = tm.yy1
             AND fbn04 = tm.mm1
             AND fbn041 = '1'

         #------------------------MOD-C60085-------------------(S)
          IF (tm.yy1 >= sr.faj57 AND tm.mm1>sr.faj571) THEN
             SELECT SUM(fbn07) INTO l_adj_fan07 FROM fbn_file
              WHERE fbn01 = sr.faj02
                AND fbn02 = sr.faj022
                AND ((fbn03 = sr.faj57 AND fbn04 > sr.faj571) AND (fbn03 = tm.yy1 AND fbn04 <= tm.mm1))
                AND fbn041 = '2'
          END IF
         #------------------------MOD-C60085-------------------(E)
          IF tm.yy1 = sr.faj57 AND tm.mm1 = sr.faj571 THEN          #MOD-C60085 add
             SELECT SUM(fbn07) INTO l_adj_fan07 FROM fbn_file
              WHERE fbn01 = sr.faj02
                AND fbn02 = sr.faj022
                AND fbn03 = tm.yy1
                AND fbn04 = tm.mm1
                AND fbn041 = '2'
          END IF                                                    #MOD-C60085 add
       END IF
      #-------------------------MOD-C30825------------------(E)
       IF cl_null(l_adj_fan07) THEN LET l_adj_fan07 = 0 END IF

       IF l_cnt > 0 THEN
          IF g_aza.aza26 <> '2' THEN
             LET l_adj_fan07 = 0
          ELSE
             #大陸版有可能先折舊再調整
             IF tm.d = '1' THEN                          #MOD-C30825 add
                SELECT fan15 INTO l_pre_fan15 FROM fan_file
                 WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
                   AND fan041 = '1'
                   AND fan03 || fan04 IN (
                         SELECT MAX(fan03) || MAX(fan04) FROM fan_File
                          WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
                            AND ((fan03 < tm.yy1) OR (fan03 = tm.yy1 AND fan04 < tm.mm1))
                            AND fan041 = '1')
   
                SELECT fan07 INTO l_curr_fan07 FROM fan_file
                 WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
                   AND fan03 = tm.yy1 AND fan04 = tm.mm1
                   AND fan041 = '1'
            #-------------------------MOD-C30825------------------(S)
             ELSE
                SELECT fbn15 INTO l_pre_fan15 FROM fbn_file
                 WHERE fbn01 = sr.faj02
                   AND fbn02 = sr.faj022
                   AND fbn041 = '1'
                   AND fbn03 || fbn04 IN (
                       SELECT MAX(fbn03) || MAX(fbn04) FROM fbn_File
                          WHERE fbn01 = sr.faj02 AND fbn02 = sr.faj022
                            AND ((fbn03 < tm.yy1) OR (fbn03 = tm.yy1 AND fbn04 < tm.mm1))
                            AND fbn041 = '1')

                SELECT fbn07 INTO l_curr_fan07 FROM fbn_file
                 WHERE fbn01 = sr.faj02
                   AND fbn02 = sr.faj022
                   AND fbn03 = tm.yy1
                   AND fbn04 = tm.mm1
                   AND fbn041 = '1'
             END IF
            #-------------------------MOD-C30825------------------(E)
             IF cl_null(l_curr_fan07) THEN LET l_curr_fan07 = 0 END IF

             IF l_fan15 = (l_pre_fan15 + l_curr_fan07 + l_adj_fan07) THEN
                LET l_adj_fan07 = 0
             END IF
          END IF
       END IF
      #MOD-C60049---S---
       IF sr.faj43 = '4' AND (tm.yy1 < sr.faj57  OR sr.faj57 = 0 OR sr.faj57 IS NULL) THEN
          LET l_sub_fan07 = l_adj_fan07
       END IF
      #MOD-C60049---E---
      #LET l_fan15 = l_fan15 + l_adj_fan07  #MOD-C60049 mark
       LET l_fan15 = l_fan15 + l_adj_fan07 - l_sub_fan07  #MOD-C60049
       LET l_fan08 = l_fan08 + l_adj_fan07
       #CHI-B70033 -- end --

       #成本=目前成本+調整成本-銷帳成本-(大於當期(調整)-大於當期(前一次調整))-大於當期(改良)
         LET sr.tmp02 = sr.faj14+sr.faj141-sr.faj59-(g_fap661-g_fap10)-g_fap54_7 + g_fap561   #MOD-930081
       #--->成本為零
       #No.MOD-AC0038  --Begin                                                  
       #IF sr.tmp02 <=0 THEN CONTINUE FOREACH END IF                            
       IF sr.tmp02 <=0 AND tm.c = '0' THEN CONTINUE FOREACH END IF              
       #No.MOD-AC0038  --End 
       LET l_year = sr.faj27[1,4]
       LET l_mon  = sr.faj27[5,6]
       IF (l_year=tm.yy1 AND l_mon > tm.mm1) OR l_year > tm.yy1 THEN
          LET sr.tmp05 = 0
          LET sr.tmp07 = 0                       #No.CHI-480001
       ELSE
          LET sr.tmp05 = l_fan15 - g_fap57       #累折
          LET sr.tmp07 = l_fan17 - g_fap45       #減值準備  #No.CHI-480001
       END IF
       #-->本期累折
       IF l_fan08 = 0 THEN
          LET sr.tmp04 = 0
       ELSE
         #LET sr.tmp04 = l_fan08 - g_fap54    #本期折舊  #CHI-850036 mark   #MOD-930059 mark回復 #MOD-C90147 mark
          LET sr.tmp04 = l_fan08              #本期折舊  #MOD-C90147 add
       END IF
       LET sr.tmp03 = sr.tmp05- sr.tmp04      #前期折舊 = 累折 - 本期累折   #MOD-8C0038 mark回復
     
       LET sr.tmp06 = sr.tmp02- sr.tmp05      #帳面價值 (成本-累折)
       LET sr.tmp08 = sr.tmp06- sr.tmp07      #資產淨值 (帳面價值-減值準備)
       #----取得當時的資料狀態
       LET l_fap04 = NULL LET l_fap03 = NULL
       LET l_fap06 = NULL                                                    #CHI-D30018 add
       OPEN x201_curs2  USING sr.faj02,sr.faj022                             
      #FETCH FIRST x201_curs2 INTO l_fap04,l_fap03                           #CHI-D30018 mark
       FETCH FIRST x201_curs2 INTO l_fap04,l_fap03,l_fap06                   #CHI-D30018 add fap06
       CLOSE x201_curs2
       # 若有當時的歷史資料則將當時情況帶入
       IF sr.faj17 = sr.faj58 THEN                  #MOD-C90147 add
          IF NOT cl_null(l_fap04) THEN
             IF l_fap03 = '1' THEN                                         
                  LET sr.faj43 = '2'
             ELSE
                CASE l_fap03 WHEN '4' LET sr.faj43 = '5'
                             WHEN '5' LET sr.faj43 = '6'
                             WHEN '6' LET sr.faj43 = '6'
                             WHEN '7' LET sr.faj43 = '8'
                             WHEN '8' LET sr.faj43 = '9'
                           OTHERWISE LET sr.faj43 = sr.faj43
                END CASE
             END IF
         #-MOD-B30682-add-
          ELSE
             OPEN x201_curs3  USING sr.faj02,sr.faj022
             FETCH FIRST x201_curs3 INTO l_fap04,sr.faj43
             CLOSE x201_curs3
         #-MOD-B30682-end-
          END IF
       END IF                                        #MOD-C90147 add
      #----------------------CHI-D30018-------------(S)
       IF l_fap03 = '9' THEN
          IF l_fap06 <> '0' THEN
             CASE
               WHEN (sr.tmp06 = 0 )
                 LET sr.faj43 = '4'
               WHEN (sr.tmp06 = sr.faj31 )
                 IF sr.faj34 = 'Y' THEN
                    LET sr.faj43 = '7'
                 ELSE
                    LET sr.faj43 = '4'
                 END IF
               OTHERWISE
                    LET sr.faj43 = '2'
             END CASE
          END IF
       END IF
      #----------------------CHI-D30018-------------(E)
      #----------------------MOD-C50131---------------(S)
       SELECT COUNT(*) INTO l_cnt FROM fap_file
        WHERE fap02  = sr.faj02
          AND fap021 = sr.faj022
          AND fap27 IS NOT NULL
          AND fap04 IN (SELECT MAX(fap04) FROM fap_file
                         WHERE fap02 = sr.faj02
                           AND fap021 = sr.faj022
                           AND fap04 BETWEEN g_bdate AND g_edate)
       IF l_cnt > 0 THEN
      #----------------------MOD-C50131---------------(E)
         #FUN-BB0163-----being add
          SELECT fap27 INTO sr.faj93 FROM fap_file 
           WHERE fap02  = sr.faj02
             AND fap021 = sr.faj022
             AND fap04 IN (SELECT MAX(fap04) FROM fap_file
                            WHERE fap02 = sr.faj02 
                              AND fap021 = sr.faj022 
                              AND fap04 BETWEEN g_bdate AND g_edate)
         #FUN-BB0163-----end add
       END IF                                                      #MOD-C50131 add
     #FUN-C90088--B--
      LET l_fap93 = ""
      OPEN x201_c01 USING sr.faj02 ,sr.faj022,g_edate
      FETCH FIRST x201_c01 INTO l_fap93
      IF NOT cl_null(l_fap93) THEN LET sr.faj29 = l_fap93 END IF
     #FUN-C90088--E--
     #FUN-D30059---add---str--
     IF tm.d='2' THEN
        IF g_faa.faa31='Y' THEN
           SELECT azi05 INTO l_azi05 FROM azi_file,aaa_file
            WHERE azi01=aaa03 AND aaa01=g_faa.faa02c
        END IF
     ELSE
        LET l_azi05 = g_azi05
     END IF
     LET l_sts = cl_gr_getmsg('afa-422',g_lang,sr.faj43)
     LET l_n1 = 0
     LET l_fab02=NULL #FUN-D40128 
     SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=sr.faj04 #FUN-D40128
     #FUN-D30059---add---end--
    #MOD-CC0015  -- modify start #調整sql與XML一致；方便開發、提高CR效能 --
    #EXECUTE insert_prep USING
    #                    sr.faf02,sr.faj02,sr.faj022,sr.faj04,sr.faj05,sr.faj06,
    #                    sr.faj07,sr.faj08,sr.faj19,sr.faj20,sr.faj21,sr.faj22,
    #                    sr.faj27,sr.faj29,sr.faj43,sr.tmp01,sr.tmp02,sr.tmp03,
    #                    sr.tmp04,sr.tmp05,sr.tmp06,sr.tmp08
    #                   ,sr.faj93    #FUN-B60045
    #                   ,sr.tmp07    #CHI-C70003 Add
     EXECUTE insert_prep USING
                         sr.faj04,sr.faj02,sr.faj022,sr.faj20,sr.faj19,sr.faj07,
                         sr.faj06,sr.tmp01,sr.tmp02,sr.tmp03,sr.tmp04,sr.tmp05,
                         sr.tmp06,sr.tmp07,sr.tmp08,sr.faj08,sr.faj27,sr.faj29,   #CHI-C70003 add sr.tmp07
                         sr.faf02,sr.faj43,sr.faj05,sr.faj21,sr.faj22,sr.faj93    #FUN-B60045 add sr.faj93    
                         ,l_sts,l_azi05,l_n1,l_flag,l_flag1   #FUN-D30059 add
                         ,l_fab02  #FUN-D40128
    #MOD-CC0015  -- modify end #調整sql與XML一致；方便開發、提高CR效能 --
#FUN-B60045   ---start   Add
     IF NOT cl_null(tm.e) THEN
        LET l_tmp[l_n].faj02 = sr.faj02
        LET l_tmp[l_n].faj93 = sr.faj93
        LET l_tmp[l_n].tmp01 = sr.tmp01
        LET l_tmp[l_n].tmp02 = sr.tmp02
        LET l_tmp[l_n].tmp03 = sr.tmp03
        LET l_tmp[l_n].tmp04 = sr.tmp04
        LET l_tmp[l_n].tmp05 = sr.tmp05
        LET l_tmp[l_n].tmp06 = sr.tmp06
        LET l_tmp[l_n].tmp08 = sr.tmp08
        LET l_tmp[l_n].sts = l_sts       #FUN-D30059 add
        LET l_tmp[l_n].azi05 =l_azi05    #FUN-D30059 add
        LET l_tmp[l_n].l_n = 0           #FUN-D30059 add
        LET l_tmp[l_n].flag = l_flag     #FUN-D30059 add 
        LET l_tmp[l_n].flag1 = l_flag1   #FUN-D30059 add 
        LET l_n = l_n + 1
     END IF
#FUN-B60045   ---end     Add
     END FOREACH
#FUN-B60045   ---start   Add
     IF NOT cl_null(tm.e) THEN
        CALL x201_tmp()
     END IF
#FUN-B60045   ---end     Add
 
 
     IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj20,faj19,faj43,faj06,faj27,faj14,faj21,faj22')                                                                   
        RETURNING tm.wc                                                                                                              
        LET g_str =tm.wc                                                                                          
     END IF                                                                                                                         
    #-------------------------------------MOD-D10254----------------------------(S)
    #--MOD-D10254--mark
    #LET g_str =g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
    #           tm.t[2,2],";",tm.t[3,3],";",tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3],";"#,#CHI-C60010 mark ','
    #          #g_azi04,";",g_azi05  #CHI-C60010 mark
    #--MOD-D10254--mark
     LET g_str =g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",
              # tm.t,";",tm.t,";",tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3],";"   #FUN-D30059 mark
                tm.t,";",tm.t,";"   #FUN-D30059 add
    #-------------------------------------MOD-D10254----------------------------(E)
#CHI-C60010--add--str-- #財簽二帳套對應的幣別小數位數
   IF g_faa.faa31='Y' THEN
      SELECT azi04,azi05 INTO l_azi04,l_azi05 FROM azi_file,aaa_file
       WHERE azi01=aaa03 AND aaa01=g_faa.faa02c
   END IF
   IF tm.d='2' THEN
      LET g_str=g_str,l_azi04,";",l_azi05
   ELSE
###XtraGrid###      LET g_str=g_str,g_azi04,";",g_azi05
   END IF
#CHI-C60010--add--end                                                                                                              
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
###XtraGrid###     CALL cl_prt_cs3('afax201',l_name,g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    #FUN-D30059--add---str--
    IF cl_null(tm.e) THEN    
       IF g_aza.aza26='2' THEN
         IF tm.a='Y' THEN
           IF tm.b='Y' THEN
              LET l_name='afax201'
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj07","Y")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj08","Y")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"tmp08","Y")
           ELSE
              LET l_name='afax201_2'
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj07","Y")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj08","N")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"tmp08","Y")
           END IF
         ELSE
           IF tm.b='Y'      THEN
              LET l_name='afax201_6'
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj07","N")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj08","Y")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"tmp08","Y")
           ELSE
              LET l_name='afax201_4'
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj07","N")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj08","N")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"tmp08","Y")
           END IF
         END IF
       ELSE
         IF tm.a='Y'        THEN
           IF tm.b='Y'      THEN
              LET l_name='afax201_5'
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj07","Y")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj08","Y")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"tmp08","N")
           ELSE
              LET l_name='afax201_7'
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj07","Y")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj08","N")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"tmp08","N")
           END IF
         ELSE
           IF tm.b='Y'      THEN
              LET l_name='afax201_3'
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj07","N")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj08","Y")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"tmp08","N")
           ELSE
              LET l_name='afax201_1'
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj07","N")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj08","N")
              LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"tmp08","N")
           END IF
         END IF
       END IF
    ELSE
       IF tm.e = '1' THEN
          LET l_name='afax201_8'
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj07","Y")
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj08","N")
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"tmp08","N")
       ELSE
          LET l_name='afax201_9'
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj07","Y")
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"faj08","N")
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"tmp08","N")
       END IF
    END IF
    IF tm.s[2] = 'N' THEN LET tm.s[2] = ' ' END IF
    IF tm.s[3] = 'N' THEN LET tm.s[3] = ' ' END IF
    LET tm.s = tm.s[1],tm.s[2],tm.s[3]
    LET g_xgrid.order_field=cl_get_order_field(tm.s,"faj04,faj05,faj02,faj20,faj19,faj43,faj06,faj27,tmp02,faj21,faj22,faj93")
    LET g_xgrid.grup_field=cl_get_order_field(tm.s,"faj04,faj05,faj02,faj20,faj19,faj43,faj06,faj27,tmp02,faj21,faj22,faj93")
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"faj04,faj05,faj02,faj20,faj19,faj43,faj06,faj27,tmp02,faj21,faj22,faj93")
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
    #FUN-D30059--add---end--
    CALL cl_xg_view()    ###XtraGrid###
END FUNCTION
 
FUNCTION x201_cal(l_faj02,l_faj022)
  DEFINE l_faj02  LIKE faj_file.faj02,
         l_faj022 LIKE faj_file.faj022,
         l_cnt    LIKE type_file.num5            #MOD-B70258
 
       #----盤點、出售、報廢、銷帳(數量)
       SELECT SUM(fap66),SUM(fap67) INTO g_fap660,g_fap670
            FROM fap_file
           #WHERE fap03 IN ('2','4','5','6') AND fap02=l_faj02   #No:MOD-540112 #MOD-B60063 mark
            WHERE fap03 IN ('4','5','6') AND fap02=l_faj02       #MOD-B60063
             AND fap021=l_faj022 AND fap04 > g_edate
       IF cl_null(g_fap660) THEN LET g_fap660=0  END IF
       IF cl_null(g_fap670) THEN LET g_fap670=0  END IF
 
       #----出售、報廢、銷帳(數量)
       SELECT SUM(fap67) INTO g_fap671 FROM fap_file
           #WHERE fap03 IN ('2','4','5','6') AND fap02=l_faj02   #No:MOD-540112 #MOD-B60063 mark
            WHERE fap03 IN ('4','5','6') AND fap02=l_faj02       #MOD-B60063
             AND fap021=l_faj022 AND fap04 < g_bdate
       IF cl_null(g_fap671) THEN LET g_fap671=0  END IF
 
       #----調整(數量)
       SELECT SUM(fap66) INTO g_fap662 FROM fap_file
           WHERE fap03 IN ('9') AND fap02=l_faj02    #No.MOD-540112
            AND fap021=l_faj022 AND fap04 > g_edate
       IF cl_null(g_fap662) THEN LET g_fap662=0  END IF
 
       #----調整(金額)
       SELECT SUM(fap661),SUM(fap10) INTO g_fap661,g_fap10 FROM fap_file
           WHERE fap03 IN ('9') AND fap02=l_faj02
            AND fap021=l_faj022 AND fap04 > g_edate
       IF cl_null(g_fap661) THEN LET g_fap661 = 0 END IF
       IF cl_null(g_fap10) THEN LET g_fap10 = 0 END IF
       
         SELECT SUM(fap56) INTO g_fap561 FROM fap_file
          WHERE fap03 IN ('4','5','6','7','8','9') AND fap02=l_faj02
            AND fap021=l_faj022 AND fap04 > g_edate  
         IF cl_null(g_fap561) THEN LET g_fap561 = 0  END IF
 
       SELECT SUM(fap54) INTO g_fap54_7 FROM fap_file
          #WHERE fap03 IN ('7')                         #MOD-C20210 mark
           WHERE fap03 IN ('7','8')                     #MOD-C20210 add
             AND fap02=l_faj02
             AND fap021=l_faj022 
             AND fap04 > g_edate
       IF cl_null(g_fap54_7) THEN LET g_fap54_7 = 0 END IF
          #----出售、報廢、銷帳(成本)
         #SELECT fap54,fap22+fap56,fap45,fap09               #CHI-850036 add fap09  #MOD-980171                 #MOD-C90147 mark
         #  INTO g_fap54,g_fap22,g_fap45,g_fap09             #No.TQC-680025  #CHI-850036 add fap09  #MOD-980171 #MOD-C90147 mark
          SELECT fap22+fap56,fap45,fap09                     #MOD-C90147 del fap54
            INTO g_fap22,g_fap45,g_fap09                     #MOD-C90147 del fap54
            FROM fap_file
           #WHERE fap03 IN ('2','4','5','6') AND fap02=l_faj02   #No.MOD-540112 #MOD-B70258 mark
            WHERE fap03 IN ('4','5','6') AND fap02=l_faj02       #MOD-B70258 
             AND fap021=l_faj022
             AND fap04 between g_bdate AND g_edate
           ORDER BY fap04 DESC   #CHI-850036 add
         #-MOD-B70258-add-
          LET l_cnt = 0
          IF tm.d = '1' THEN                          #MOD-C30825 add
             SELECT COUNT(*) INTO l_cnt 
               FROM fan_file
              WHERE fan01=l_faj02 AND fan02=l_faj022
                AND fan03 = tm.yy1 AND fan04 = tm.mm1
                AND fan041 IN ('0','1')
                AND fan05 IN ('1','2') 
          #-------------------------MOD-C30825------------------(S)
           ELSE
             SELECT COUNT(*) INTO l_cnt
               FROM fbn_file
              WHERE fbn01 = l_faj02
                AND fbn02 = l_faj022
                AND fbn03 = tm.yy1
                AND fbn04 = tm.mm1
                AND fbn041 IN ('0','1')
                AND fbn05 IN ('1','2')
           END IF
          #-------------------------MOD-C30825------------------(E)
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
        #-------------------------MOD-C90147-----------------mark
        # IF l_cnt > 0 THEN
        ##-MOD-B70258-end-
        #    SELECT SUM(fap57) INTO g_fap57 FROM fap_file
        #      WHERE fap03 IN ('4','5','6') AND fap02=l_faj02   #No.MOD-540112  #MOD-A10024 mod
        #       AND fap021=l_faj022
        #       AND fap04 BETWEEN g_bdate AND g_edate  #MOD-A10024 mod
        ##-MOD-B70258-add-
        # END IF
        #-------------------------MOD-C90147-----------------mark
         #本月尚未折舊時,抓取此財產之前的銷貨累折
          IF l_cnt = 0 THEN
             SELECT SUM(fap57) INTO g_fap57 FROM fap_file
               WHERE fap03 IN ('4','5','6') AND fap02=l_faj02
                AND fap021=l_faj022
                AND fap04 < g_bdate  
          END IF
         #-MOD-B70258-end-
         #IF cl_null(g_fap54) THEN LET g_fap54=0  END IF  #MOD-C90147 mark
          IF cl_null(g_fap22) THEN LET g_fap22=0  END IF  #No.TQC-680025
          IF cl_null(g_fap57) THEN LET g_fap57=0  END IF
          IF cl_null(g_fap45) THEN LET g_fap45=0  END IF
          IF cl_null(g_fap09) THEN LET g_fap09=0  END IF  #CHI-850036 add

END FUNCTION
#No.FUN-9C0077 程式精簡

#FUN-B60045   ---start   Add
FUNCTION x201_tmp()
DEFINE p_i   LIKE type_file.num5
DEFINE l_n   LIKE type_file.num5
DEFINE l_sql STRING

   IF tm.e = 1 THEN
      FOR p_i = l_tmp.getLength() TO 1 STEP -1
         IF p_i - 1 = 0 THEN
            EXIT FOR
         END IF
         FOR l_n = 1 TO p_i - 1 STEP 1
            IF l_tmp[p_i].faj93 = l_tmp[p_i - l_n].faj93 THEN
               LET l_tmp[p_i - l_n].tmp01 = l_tmp[p_i - l_n].tmp01 + l_tmp[p_i].tmp01
               LET l_tmp[p_i - l_n].tmp02 = l_tmp[p_i - l_n].tmp02 + l_tmp[p_i].tmp02
               LET l_tmp[p_i - l_n].tmp03 = l_tmp[p_i - l_n].tmp03 + l_tmp[p_i].tmp03
               LET l_tmp[p_i - l_n].tmp04 = l_tmp[p_i - l_n].tmp04 + l_tmp[p_i].tmp04
               LET l_tmp[p_i - l_n].tmp05 = l_tmp[p_i - l_n].tmp05 + l_tmp[p_i].tmp05
               LET l_tmp[p_i - l_n].tmp06 = l_tmp[p_i - l_n].tmp06 + l_tmp[p_i].tmp06
               LET l_tmp[p_i - l_n].tmp08 = l_tmp[p_i - l_n].tmp08 + l_tmp[p_i].tmp08
               LET l_tmp[p_i - l_n].tmp07 = l_tmp[p_i - l_n].tmp07 + l_tmp[p_i].tmp07    #CHI-C70003
               CALL l_tmp.deleteElement(p_i)
               EXIT FOR
            END IF
         END FOR
      END FOR
   ELSE
      FOR p_i = l_tmp.getLength() TO 1 STEP -1
         IF p_i - 1 = 0 THEN
            EXIT FOR
         END IF
         FOR l_n = 1 TO p_i - 1 STEP 1
            IF l_tmp[p_i].faj93 = l_tmp[p_i - 1].faj93 AND l_tmp[p_i].faj02 = l_tmp[p_i - 1].faj02 THEN
               LET l_tmp[p_i - l_n].tmp01 = l_tmp[p_i - l_n].tmp01 + l_tmp[p_i].tmp01
               LET l_tmp[p_i - l_n].tmp02 = l_tmp[p_i - l_n].tmp02 + l_tmp[p_i].tmp02
               LET l_tmp[p_i - l_n].tmp03 = l_tmp[p_i - l_n].tmp03 + l_tmp[p_i].tmp03
               LET l_tmp[p_i - l_n].tmp04 = l_tmp[p_i - l_n].tmp04 + l_tmp[p_i].tmp04
               LET l_tmp[p_i - l_n].tmp05 = l_tmp[p_i - l_n].tmp05 + l_tmp[p_i].tmp05
               LET l_tmp[p_i - l_n].tmp06 = l_tmp[p_i - l_n].tmp06 + l_tmp[p_i].tmp06
               LET l_tmp[p_i - l_n].tmp08 = l_tmp[p_i - l_n].tmp08 + l_tmp[p_i].tmp08
               LET l_tmp[p_i - l_n].tmp07 = l_tmp[p_i - l_n].tmp07 + l_tmp[p_i].tmp07    #CHI-C70003
               CALL l_tmp.deleteElement(p_i)
               EXIT FOR
            END IF
         END FOR
      END FOR
   END IF
   CALL cl_del_data(l_table)
   FOR p_i = 1 TO l_tmp.getLength()
      EXECUTE insert_prep USING l_tmp[p_i].*
   END FOR
END FUNCTION
#FUN-B60045   ---end     Add


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
