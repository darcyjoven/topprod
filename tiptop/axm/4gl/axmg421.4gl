# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axmg421.4gl
# Descriptions...: 商品借用送貨單
# Date & Author..: No.FUN-750036 07/05/10 by rainy
# Modify.........: 03/03/12 BY Wiky(增列印訂單嘜頭)
# Modify.........: No:7674 03/08/08 Carol 報表列印麥頭時
#                                         須轉換 CCCCCC / PPPPPP / DDDDDD 資料
# Modify.........: No:#No.MOD-480345 03/08/16 Wiky 修改單價跟金額長度
# Modify.........: No.FUN-4C0096 05/03/04 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.FUN-550070 05/05/26 By day  單據編號加大
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-570176 05/07/19 By yoyo 項次欄位加大
# Modify.........: No.MOD-570395 05/08/19 By Nicola 嘜頭列印修改,嘜頭拿訂單的嘜頭資料
# Modify.........: No.FUN-590110 05/09/29 By day  報表轉xml
# Modify.........: No.FUN-5A0143 05/10/20 By Rosayu 調整報表格式
# Modify.........: No.TQC-5A0128 05/11/21 By Nicola 數量取位錯誤
# Modify.........: No.TQC-5B0156 05/11/29 By Nicola LET sr.oea12=''
# Modify.........: No.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-610017 06/01/13 By Nicola 報表格式修改
# Modify.........: No.FUN-570069 06/05/04 By Sarah 列印時,要參考axmi221的慣用語言出表(occ55)
# Modify.........: No.FUN-650020 06/05/26 By kim 整合信用額度的錯誤訊息為一個視窗,不要每筆都秀
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690032 06/10/18 By rainy 新增是否列印客戶料號
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.MOD-6B0114 07/01/03 By Mandy 遵循多單位報表列印規則
# Modify.........: No.TQC-730022 07/03/28 By rainy 流程自動化
# Modify.........: No.MOD-730125 07/04/03 By claire 客戶簡稱取自訂單
# Modify.........: No.TQC-720017 07/04/04 By claire 慣用語言別沒有依客戶取值
# Modify.........: No.FUN-720014 07/04/09 By rainy 地址擴充成5欄位
# Modify.........: No.TQC-740271 07/05/08 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.FUN-7B0142 07/12/12 By jamie 不應在rpt寫入各語言的title，要廢除這樣的寫法(程式中使用g_rlang再切換)，報表列印不需參考慣用語言的設定。
# Modify.........: No.MOD-870006 08/07/02 By Smapmin 以子報表方式呈現備註資料
# Modify.........: No.MOD-870012 08/07/02 By Smapmin 修改ora檔
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40092 11/05/09 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No:FUN-C10036 12/01/16 By lujh FUN-B80089追單
# Modify.........: No:FUN-C40026 12/04/11 By xumm GR動態簽核
# Modify.........: No.FUN-C50008 12/04/28 By wangrr GR程式優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5          #No.FUN-680137 SMALLINT
END GLOBALS
 
DEFINE tm  RECORD                         # Print condition RECORD
            wc      LIKE type_file.chr1000,       # Where condition
            more    LIKE type_file.chr1           # Input more condition(Y/N)
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20,         #No.FUN-680137 VARCHAR(20)   # For TIPTOP 串 EasyFlow
       g_po_no,g_ctn_no1,g_ctn_no2      LIKE type_file.chr20         #No.FUN-680137  VARCHAR(20)      #No:7674
DEFINE g_cnt       LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE g_i         LIKE type_file.num5      #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE g_msg       LIKE type_file.chr1000    #No.FUN-680137 VARCHAR(72)
DEFINE g_show_msg  DYNAMIC ARRAY OF RECORD  #FUN-650020
          oea01     LIKE oea_file.oea01,
          oea03     LIKE oea_file.oea03,
          occ02     LIKE occ_file.occ02,
          occ18     LIKE occ_file.occ18,
          ze01      LIKE ze_file.ze01,
          ze03      LIKE ze_file.ze03
                   END RECORD
DEFINE g_oea01     LIKE oea_file.oea01   #FUN-650020
DEFINE g_sma115    LIKE sma_file.sma115  #MOD-6B0114
DEFINE g_sma116    LIKE sma_file.sma116  #MOD-6B0114
DEFINE l_table     STRING                #TQC-740271 add
DEFINE l_table1    STRING                #MOD-870006
DEFINE l_table2    STRING                #MOD-870006
DEFINE l_table3    STRING                #MOD-870006
DEFINE l_table4    STRING                #MOD-870006
DEFINE g_sql       STRING                #TQC-740271 add
DEFINE g_str       STRING                #TQC-740271 add
 
###GENGRE###START
TYPE sr1_t RECORD
    oea00 LIKE oea_file.oea00,
    oea01 LIKE oea_file.oea01,
    oea02 LIKE oea_file.oea02,
    oea10 LIKE oea_file.oea10,
    oea11 LIKE oea_file.oea11,
    oea12 LIKE oea_file.oea12,
    oea03 LIKE oea_file.oea03,
    oea032 LIKE oea_file.oea032,
    oea04 LIKE oea_file.oea04,
    oea044 LIKE oea_file.oea032,
    oea43 LIKE oea_file.oea43,
    ged02 LIKE ged_file.ged02,
    oea44 LIKE oea_file.oea44,
    occ02 LIKE occ_file.occ02,
    oea06 LIKE oea_file.oea06,
    oea14 LIKE oea_file.oea14,
    oea15 LIKE oea_file.oea15,
    oea23 LIKE oea_file.oea23,
    oea21 LIKE oea_file.oea21,
    oea25 LIKE oea_file.oea25,
    oea31 LIKE oea_file.oea31,
    oea32 LIKE oea_file.oea32,
    oea33 LIKE oea_file.oea33,
    oeb03 LIKE oeb_file.oeb03,
    oeb04 LIKE oeb_file.oeb04,
    ima021 LIKE ima_file.ima021,
    oeb05 LIKE oeb_file.oeb05,
    oeb12 LIKE oeb_file.oeb12,
    oeb13 LIKE oeb_file.oeb13,
    oeb14 LIKE oeb_file.oeb14,
    oeb14t LIKE oeb_file.oeb14t,
    oeb15 LIKE oeb_file.oeb15,
    oeb1001 LIKE oeb_file.oeb1001,
    azf03 LIKE azf_file.azf03,
    oeb30 LIKE oeb_file.oeb30,
    oeb06 LIKE oeb_file.oeb06,
    oeb11 LIKE oeb_file.oeb11,
    oeb17 LIKE oeb_file.oeb17,
    oeb18 LIKE oeb_file.oeb18,
    oeb19 LIKE oeb_file.oeb19,
    oeb20 LIKE oeb_file.oeb20,
    oeb21 LIKE oeb_file.oeb21,
    oeb916 LIKE oeb_file.oeb916,
    oeb917 LIKE oeb_file.oeb917,
    gfe03 LIKE gfe_file.gfe03,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    occ02_1 LIKE occ_file.occ02,
    gen02 LIKE gen_file.gen02,
    oab02 LIKE oab_file.oab02,
    gem02 LIKE gem_file.gem02,
    oah02 LIKE oah_file.oah02,
    oag02 LIKE oag_file.oag02,
    gec02 LIKE gec_file.gec02,
    addr1 LIKE occ_file.occ241,
    addr2 LIKE occ_file.occ241,
    addr3 LIKE occ_file.occ241,
    addr4 LIKE occ_file.occ241,
    addr5 LIKE occ_file.occ241,
    unit LIKE type_file.chr50,
    ocf01 LIKE ocf_file.ocf01,
    ocf02 LIKE ocf_file.ocf02,
    ocf101 LIKE ocf_file.ocf101,
    ocf102 LIKE ocf_file.ocf102,
    ocf103 LIKE ocf_file.ocf103,
    ocf104 LIKE ocf_file.ocf104,
    ocf105 LIKE ocf_file.ocf105,
    ocf106 LIKE ocf_file.ocf106,
    ocf107 LIKE ocf_file.ocf107,
    ocf108 LIKE ocf_file.ocf108,
    ocf109 LIKE ocf_file.ocf109,
    ocf110 LIKE ocf_file.ocf110,
    ocf111 LIKE ocf_file.ocf111,
    ocf112 LIKE ocf_file.ocf112,
    ocf201 LIKE ocf_file.ocf201,
    ocf202 LIKE ocf_file.ocf202,
    ocf203 LIKE ocf_file.ocf203,
    ocf204 LIKE ocf_file.ocf204,
    ocf205 LIKE ocf_file.ocf205,
    ocf206 LIKE ocf_file.ocf206,
    ocf207 LIKE ocf_file.ocf207,
    ocf208 LIKE ocf_file.ocf208,
    ocf209 LIKE ocf_file.ocf209,
    ocf210 LIKE ocf_file.ocf210,
    ocf211 LIKE ocf_file.ocf211,
    ocf212 LIKE ocf_file.ocf212,   #FUN-C40026 add,
#FUN-C40026----add---str---
    sign_type LIKE type_file.chr1,
    sign_img  LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str  LIKE type_file.chr1000
#FUN-C40026----add---end---
END RECORD

TYPE sr2_t RECORD
    oao01_1 LIKE oao_file.oao01,
    oao03_1 LIKE oao_file.oao03,
    oao05_1 LIKE oao_file.oao05,
    oao06_1 LIKE oao_file.oao06
END RECORD

TYPE sr3_t RECORD
    oao01_2 LIKE oao_file.oao01,
    oao03_2 LIKE oao_file.oao03,
    oao05_2 LIKE oao_file.oao05,
    oao06_2 LIKE oao_file.oao06
END RECORD

TYPE sr4_t RECORD
    oao01_3 LIKE oao_file.oao01,
    oao03_3 LIKE oao_file.oao03,
    oao05_3 LIKE oao_file.oao05,
    oao06_3 LIKE oao_file.oao06
END RECORD

TYPE sr5_t RECORD
    oao01_4 LIKE oao_file.oao01,
    oao03_4 LIKE oao_file.oao03,
    oao05_4 LIKE oao_file.oao05,
    oao06_4 LIKE oao_file.oao06
END RECORD
###GENGRE###END

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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-C10036   mark
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oea00.oea_file.oea00  ,oea01.oea_file.oea01,",
               "oea02.oea_file.oea02  ,oea10.oea_file.oea10,",
               "oea11.oea_file.oea11  ,oea12.oea_file.oea12,",
               "oea03.oea_file.oea03  ,oea032.oea_file.oea032,",
               "oea04.oea_file.oea04  ,oea044.oea_file.oea032,",
               "oea43.oea_file.oea43  ,ged02.ged_file.ged02,",
               "oea44.oea_file.oea44  ,occ02.occ_file.occ02,",
               "oea06.oea_file.oea06  ,oea14.oea_file.oea14,",
               "oea15.oea_file.oea15  ,oea23.oea_file.oea23,",
               "oea21.oea_file.oea21  ,oea25.oea_file.oea25,",
               "oea31.oea_file.oea31  ,oea32.oea_file.oea32,",
               "oea33.oea_file.oea33  ,oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04  ,ima021.ima_file.ima021,",
               "oeb05.oeb_file.oeb05  ,oeb12.oeb_file.oeb12,",
               "oeb13.oeb_file.oeb13  ,oeb14.oeb_file.oeb14,",
               "oeb14t.oeb_file.oeb14t,oeb15.oeb_file.oeb15,",
               "oeb1001.oeb_file.oeb1001,azf03.azf_file.azf03,",
               "oeb30.oeb_file.oeb30, ",
               "oeb06.oeb_file.oeb06  ,oeb11.oeb_file.oeb11,",
               "oeb17.oeb_file.oeb17  ,oeb18.oeb_file.oeb18,",
               "oeb19.oeb_file.oeb19  ,oeb20.oeb_file.oeb20,",
               "oeb21.oeb_file.oeb21  ,",                         #FUN-7B0142 mod
              #"oeb21.oeb_file.oeb21  ,occ55.occ_file.occ55,",    #FUN-7B0142 mark
               "oeb916.oeb_file.oeb916,oeb917.oeb_file.oeb917,",
               "gfe03.gfe_file.gfe03  ,azi03.azi_file.azi03,",
               "azi04.azi_file.azi04  ,azi05.azi_file.azi05,",
               "occ02_1.occ_file.occ02,gen02.gen_file.gen02,",
               "oab02.oab_file.oab02  ,gem02.gem_file.gem02,",
               "oah02.oah_file.oah02  ,oag02.oag_file.oag02,",
               "gec02.gec_file.gec02  ,addr1.occ_file.occ241,",
               "addr2.occ_file.occ241 ,addr3.occ_file.occ241,",
               "addr4.occ_file.occ241 ,addr5.occ_file.occ241,",
               "unit.type_file.chr50  ,ocf01.ocf_file.ocf01,",
               "ocf02.ocf_file.ocf02  ,ocf101.ocf_file.ocf101,",
               "ocf102.ocf_file.ocf102,ocf103.ocf_file.ocf103,",
               "ocf104.ocf_file.ocf104,ocf105.ocf_file.ocf105,",
               "ocf106.ocf_file.ocf106,ocf107.ocf_file.ocf107,",
               "ocf108.ocf_file.ocf108,ocf109.ocf_file.ocf109,",
               "ocf110.ocf_file.ocf110,ocf111.ocf_file.ocf111,",
               "ocf112.ocf_file.ocf112,ocf201.ocf_file.ocf201,",
               "ocf202.ocf_file.ocf202,ocf203.ocf_file.ocf203,",
               "ocf204.ocf_file.ocf204,ocf205.ocf_file.ocf205,",
               "ocf206.ocf_file.ocf206,ocf207.ocf_file.ocf207,",
               "ocf208.ocf_file.ocf208,ocf209.ocf_file.ocf209,",
               "ocf210.ocf_file.ocf210,ocf211.ocf_file.ocf211,",
               "ocf212.ocf_file.ocf212,",#,oao04.oao_file.oao04,",    #MOD-870006    #FUN-C40026 add 2,
               #FUN-C40026----add---str----
               "sign_type.type_file.chr1,sign_img.type_file.blob,",   #簽核方式, 簽核圖檔
               "sign_show.type_file.chr1,sign_str.type_file.chr1000"
               #FUN-C40026----add---end----
               #"oao06h.oao_file.oao06 ,oao06d1.oao_file.oao06,",   #MOD-870006
               #"oao06d2.oao_file.oao06,oao06t.oao_file.oao06"      #MOD-870006
 
   LET l_table = cl_prt_temptable('axmg421',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092   #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生
 
   #-----MOD-870006---------
   LET g_sql = "oao01_1.oao_file.oao01,",
               "oao03_1.oao_file.oao03,",
               "oao05_1.oao_file.oao05,",
               "oao06_1.oao_file.oao06 "
   LET l_table1 = cl_prt_temptable('axmg4211',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092   #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "oao01_2.oao_file.oao01,",
               "oao03_2.oao_file.oao03,",
               "oao05_2.oao_file.oao05,",
               "oao06_2.oao_file.oao06 "
   LET l_table2 = cl_prt_temptable('axmg4212',g_sql) CLIPPED
   IF l_table2 = -1 THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092  #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "oao01_3.oao_file.oao01,",
               "oao03_3.oao_file.oao03,",
               "oao05_3.oao_file.oao05,",
               "oao06_3.oao_file.oao06 "
   LET l_table3 = cl_prt_temptable('axmg4213',g_sql) CLIPPED
   IF l_table3 = -1 THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092   #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "oao01_4.oao_file.oao01,",
               "oao03_4.oao_file.oao03,",
               "oao05_4.oao_file.oao05,",
               "oao06_4.oao_file.oao06 "
   LET l_table4 = cl_prt_temptable('axmg4214',g_sql) CLIPPED
   IF l_table4 = -1 THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092   #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
 
   #LET g_sql = "INSERT INTO ds_report:",l_table CLIPPED,
   #            " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
   #            "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
   #            "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
   #            "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
   #            "        ?,?,?,?,?, ?,?,?,?,?, ?,?)"   #FUN-7B0142 拿掉一個?
   #PREPARE insert_prep FROM g_sql
   #IF STATUS THEN
   #   CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   #END IF
   #------------------------------ CR (1) ------------------------------#
 
   #DROP TABLE g421_tmp
   #CREATE TEMP TABLE g421_tmp(
   #   oea00   LIKE oea_file.oea00,
   #   oea01   LIKE oea_file.oea01,
   #   oea02   LIKE oea_file.oea02,
   #   oea10   LIKE oea_file.oea10,
   #   oea11   LIKE oea_file.oea11,
   #   oea12   LIKE oea_file.oea12,
   #   oea03   LIKE oea_file.oea03,
   #   oea032  LIKE oea_file.oea032,
   #   oea04   LIKE oea_file.oea04,
   #   oea044  LIKE oea_file.oea032,
   #   oea43   LIKE oea_file.oea43,
   #   ged02   LIKE ged_file.ged02,
   #   oea44   LIKE oea_file.oea44,
   #   occ02   LIKE occ_file.occ02,
   #   oea06   LIKE oea_file.oea06,
   #   oea14   LIKE oea_file.oea14,
   #   oea15   LIKE oea_file.oea15,
   #   oea23   LIKE oea_file.oea23,
   #   oea21   LIKE oea_file.oea21,
   #   oea25   LIKE oea_file.oea25,
   #   oea31   LIKE oea_file.oea31,
   #   oea32   LIKE oea_file.oea32,
   #   oea33   LIKE oea_file.oea33,
   #   oeb03   LIKE oeb_file.oeb03,
   #   oeb04   LIKE oeb_file.oeb04,
   #   ima021  LIKE ima_file.ima021,
   #   oeb05   LIKE oeb_file.oeb05,
   #   oeb12   LIKE oeb_file.oeb12,
   #   oeb13   LIKE oeb_file.oeb13,
   #   oeb14   LIKE oeb_file.oeb14,
   #   oeb14t  LIKE oeb_file.oeb14t,
   #   oeb15   LIKE oeb_file.oeb15,
   #   oeb1001 LIKE oeb_file.oeb1001,
   #   azf03   LIKE azf_file.azf03,
   #   oeb30   LIKE oeb_file.oeb30,
   #   oeb06   LIKE oeb_file.oeb06,
   #   oeb11   LIKE oeb_file.oeb11,
   #   oeb17   LIKE oeb_file.oeb17,
   #   oeb18   LIKE oeb_file.oeb18,
   #   oeb19   LIKE oeb_file.oeb19,
   #   oeb20   LIKE oeb_file.oeb20,
   #   oeb21   LIKE oeb_file.oeb21,
   #   oeb916  LIKE oeb_file.oeb916,
   #   oeb917  LIKE oeb_file.oeb917,
   #   gfe03   LIKE gfe_file.gfe03,
   #   azi03   LIKE azi_file.azi03,
   #   azi04   LIKE azi_file.azi04,
   #   azi05   LIKE azi_file.azi05,
   #   occ02_1 LIKE occ_file.occ02,
   #   gen02   LIKE gen_file.gen02,
   #   oab02   LIKE oab_file.oab02,
   #   gem02   LIKE gem_file.gem02,
   #   oah02   LIKE oah_file.oah02,
   #   oag02   LIKE oag_file.oag02,
   #   gec02   LIKE gec_file.gec02,
   #   addr1   LIKE occ_file.occ241,
   #   addr2   LIKE occ_file.occ241,
   #   addr3   LIKE occ_file.occ241,
   #   addr4   LIKE occ_file.occ241,
   #   addr5   LIKE occ_file.occ241,
   #   unit    LIKE type_file.chr50,
   #   ocf01   LIKE ocf_file.ocf01,
   #   ocf02   LIKE ocf_file.ocf02,
   #   ocf101  LIKE ocf_file.ocf101,
   #   ocf102  LIKE ocf_file.ocf102,
   #   ocf103  LIKE ocf_file.ocf103,
   #   ocf104  LIKE ocf_file.ocf104,
   #   ocf105  LIKE ocf_file.ocf105,
   #   ocf106  LIKE ocf_file.ocf106,
   #   ocf107  LIKE ocf_file.ocf107,
   #   ocf108  LIKE ocf_file.ocf108,
   #   ocf109  LIKE ocf_file.ocf109,
   #   ocf110  LIKE ocf_file.ocf110,
   #   ocf111  LIKE ocf_file.ocf111,
   #   ocf112  LIKE ocf_file.ocf112,
   #   ocf201  LIKE ocf_file.ocf201,
   #   ocf202  LIKE ocf_file.ocf202,
   #   ocf203  LIKE ocf_file.ocf203,
   #   ocf204  LIKE ocf_file.ocf204,
   #   ocf205  LIKE ocf_file.ocf205,
   #   ocf206  LIKE ocf_file.ocf206,
   #   ocf207  LIKE ocf_file.ocf207,
   #   ocf208  LIKE ocf_file.ocf208,
   #   ocf209  LIKE ocf_file.ocf209,
   #   ocf210  LIKE ocf_file.ocf210,
   #   ocf211  LIKE ocf_file.ocf211,
   #   ocf212  LIKE ocf_file.ocf212) 
   #  #occ55   LIKE occ_file.occ55,   #FUN-7B0142 mark 原本在oeb916之上
   #
   #DROP TABLE g421_tmp1
   #CREATE TEMP TABLE g421_tmp1(
   #   oea01_1 LIKE oea_file.oea01,
   #   oao03   LIKE oao_file.oao03,
   #   oao04   LIKE oao_file.oao04,
   #   oao05   LIKE oao_file.oao05,
   #   oao06h  LIKE oao_file.oao06,
   #   oao06d1 LIKE oao_file.oao06,
   #   oao06d2 LIKE oao_file.oao06,
   #   oao06t  LIKE oao_file.oao06)
   #-----END MOD-870006-----
   #end TQC-740271 add
 

  #start FUN-570069 add
   LET g_pdate  = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  #end FUN-570069 add
   LET tm.wc    = ARG_VAL(7)                          
  #LET g_rpt_name = ARG_VAL(2)   # 外部指定報表名稱  
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)                       
   LET g_rep_clas = ARG_VAL(11)                       
   LET g_template = ARG_VAL(12)                       
   #No.FUN-570264 ---end---
#TQC-730022 begin
   LET g_xml.subject = ARG_VAL(14)
   LET g_xml.body = ARG_VAL(15)
   LET g_xml.recipient = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
#TQC-730022 end
 
  
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') THEN  # If background   #FUN-570069
      CALL axmg421_tm(0,0)             # Input print condition
   ELSE 
      CALL axmg421()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
END MAIN
 
FUNCTION axmg421_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmg421_w AT p_row,p_col WITH FORM "axm/42f/axmg421"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'       
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(oea01)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_oea11"   
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO oea01
             NEXT FIELD oea01
           WHEN INFIELD(oea03)     
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_occ3"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea03  
                NEXT FIELD oea03  
         END CASE
      ON ACTION locale
         CALL cl_show_fld_cont()                  
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg421_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
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
      ON ACTION about         
         CALL cl_about()      
      ON ACTION help          
         CALL cl_show_help()  
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmg421_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmg421'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmg421','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('axmg421',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmg421_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmg421()
   ERROR ""
END WHILE
   CLOSE WINDOW axmg421_w
END FUNCTION
 
FUNCTION axmg421()
  DEFINE l_cmd          LIKE type_file.chr1000 
  DEFINE l_oce03        LIKE   oce_file.oce03
  DEFINE l_oce05        LIKE   oce_file.oce05
  DEFINE l_zo02         LIKE   zo_file.zo02
  DEFINE l_subject      STRING   #主旨
  DEFINE l_body         STRING   #內文路徑
  DEFINE l_recipient    STRING   #收件者
  DEFINE l_cnt          LIKE   type_file.num5    #SMALLINT
  DEFINE l_wc           STRING
  DEFINE ls_context        STRING  
  DEFINE ls_temp_path      STRING 
  DEFINE ls_context_file   STRING
  DEFINE l_oea01_t      LIKE oea_file.oea01
 
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          #l_sql     LIKE type_file.chr1000,
          l_sql     STRING,       #NO.FUN-910082       
          l_za05    LIKE type_file.chr1000,       
          sr        RECORD
                    oea00     LIKE oea_file.oea00,
                    oea01     LIKE oea_file.oea01,
                    oea02     LIKE oea_file.oea02,
                    oea10     LIKE oea_file.oea10,   
                    oea11     LIKE oea_file.oea11,
                    oea12     LIKE oea_file.oea12,
                    oea03     LIKE oea_file.oea03,
                    oea032    LIKE oea_file.oea032,
                    oea04     LIKE oea_file.oea04,
                    oea044    LIKE oea_file.oea044,
                    oea43     LIKE oea_file.oea43,   
                    ged02     LIKE ged_file.ged02,
                    oea44     LIKE oea_file.oea44,   
                    occ02     LIKE occ_file.occ02,
                    oea06     LIKE oea_file.oea06,
                    oea14     LIKE oea_file.oea14,
                    oea15     LIKE oea_file.oea15,
                    oea23     LIKE oea_file.oea23,
                    oea21     LIKE oea_file.oea21,
                    oea25     LIKE oea_file.oea25,
                    oea31     LIKE oea_file.oea31,
                    oea32     LIKE oea_file.oea32,
                    oea33     LIKE oea_file.oea33,
                    oeb03     LIKE oeb_file.oeb03,
                    oeb04     LIKE oeb_file.oeb04,
                    ima021    LIKE ima_file.ima021,
                    oeb05     LIKE oeb_file.oeb05,
                    oeb12     LIKE oeb_file.oeb12,
                    oeb13     LIKE oeb_file.oeb13,
                    oeb14     LIKE oeb_file.oeb14,
                    oeb14t    LIKE oeb_file.oeb14t,
                    oeb15     LIKE oeb_file.oeb15,
                    oeb1001 LIKE oeb_file.oeb1001,
                    azf03   LIKE azf_file.azf03,
                    oeb30   LIKE oeb_file.oeb30,
                    oeb06     LIKE oeb_file.oeb06,
                    oeb11     LIKE oeb_file.oeb11,
                    oeb17     LIKE oeb_file.oeb17,
                    oeb18     LIKE oeb_file.oeb18,
                    oeb19     LIKE oeb_file.oeb19,
                    oeb20     LIKE oeb_file.oeb20,
                    oeb21     LIKE oeb_file.oeb21,
                    ofa04     LIKE ofa_file.ofa04,  
                    ofa10     LIKE ofa_file.ofa10,  
                    ofa44     LIKE ofa_file.ofa44,  
                    ofa45     LIKE ofa_file.ofa45,  
                    ofa46     LIKE ofa_file.ofa46,  
                   #occ55     LIKE occ_file.occ55,    #FUN-7B0142 mark
                    oeb910    LIKE oeb_file.oeb910, 
                    oeb912    LIKE oeb_file.oeb912, 
                    oeb913    LIKE oeb_file.oeb913, 
                    oeb915    LIKE oeb_file.oeb915, 
                    oeb916    LIKE oeb_file.oeb916, 
                    oeb917    LIKE oeb_file.oeb917  
                    END RECORD
   DEFINE l_msg    STRING    #FUN-650020
   DEFINE l_msg2   STRING    #FUN-650020
   DEFINE lc_gaq03 LIKE gaq_file.gaq03   #FUN-650020
   DEFINE l_oea03 DYNAMIC ARRAY OF LIKE oea_file.oea03  #TQC-730022
   DEFINE l_oea01 DYNAMIC ARRAY OF LIKE oea_file.oea01  #TQC-730022
   DEFINE l_i,l_j     LIKE type_file.num5     #TQC-730022
#FUN-C50008--mark--str
#   DEFINE cr       RECORD
#                    oea00   LIKE oea_file.oea00,
#                    oea01   LIKE oea_file.oea01,
#                    oea02   LIKE oea_file.oea02,
#                    oea10   LIKE oea_file.oea10,
#                    oea11   LIKE oea_file.oea11,
#                    oea12   LIKE oea_file.oea12,
#                    oea03   LIKE oea_file.oea03,
#                    oea032  LIKE oea_file.oea032,
#                    oea04   LIKE oea_file.oea04,
#                    oea044  LIKE oea_file.oea032,
#                    oea43     LIKE oea_file.oea43,   
#                    ged02     LIKE ged_file.ged02,
#                    oea44   LIKE oea_file.oea44,
#                    occ02   LIKE occ_file.occ02,
#                    oea06   LIKE oea_file.oea06,
#                    oea14   LIKE oea_file.oea14,
#                    oea15   LIKE oea_file.oea15,
#                    oea23   LIKE oea_file.oea23,
#                    oea21   LIKE oea_file.oea21,
#                    oea25   LIKE oea_file.oea25,
#                    oea31   LIKE oea_file.oea31,
#                    oea32   LIKE oea_file.oea32,
#                    oea33   LIKE oea_file.oea33,
#                    oeb03   LIKE oeb_file.oeb03,
#                    oeb04   LIKE oeb_file.oeb04,
#                    ima021  LIKE ima_file.ima021,
#                    oeb05   LIKE oeb_file.oeb05,
#                    oeb12   LIKE oeb_file.oeb12,
#                    oeb13   LIKE oeb_file.oeb13,
#                    oeb14   LIKE oeb_file.oeb14,
#                    oeb14t  LIKE oeb_file.oeb14t,
#                    oeb15   LIKE oeb_file.oeb15,
#                    oeb1001 LIKE oeb_file.oeb1001,
#                    azf03   LIKE azf_file.azf03,
#                    oeb30   LIKE oeb_file.oeb30,
#                    oeb06   LIKE oeb_file.oeb06,
#                    oeb11   LIKE oeb_file.oeb11,
#                    oeb17   LIKE oeb_file.oeb17,
#                    oeb18   LIKE oeb_file.oeb18,
#                    oeb19   LIKE oeb_file.oeb19,
#                    oeb20   LIKE oeb_file.oeb20,
#                    oeb21   LIKE oeb_file.oeb21,
#                   #occ55   LIKE occ_file.occ55,   #FUN-7B0142 mark
#                    oeb916  LIKE oeb_file.oeb916,
#                    oeb917  LIKE oeb_file.oeb917,
#                    gfe03   LIKE gfe_file.gfe03,
#                    azi03   LIKE azi_file.azi03,
#                    azi04   LIKE azi_file.azi04,
#                    azi05   LIKE azi_file.azi05,
#                    occ02_1 LIKE occ_file.occ02,
#                    gen02   LIKE gen_file.gen02,
#                    oab02   LIKE oab_file.oab02,
#                    gem02   LIKE gem_file.gem02,
#                    oah02   LIKE oah_file.oah02,
#                    oag02   LIKE oag_file.oag02,
#                    gec02   LIKE gec_file.gec02,
#                    addr1   LIKE occ_file.occ241,
#                    addr2   LIKE occ_file.occ241,
#                    addr3   LIKE occ_file.occ241,
#                    addr4   LIKE occ_file.occ241,
#                    addr5   LIKE occ_file.occ241,
#                    unit    LIKE type_file.chr50,
#                    ocf01   LIKE ocf_file.ocf01,
#                    ocf02   LIKE ocf_file.ocf02,
#                    ocf101  LIKE ocf_file.ocf101,
#                    ocf102  LIKE ocf_file.ocf102,
#                    ocf103  LIKE ocf_file.ocf103,
#                    ocf104  LIKE ocf_file.ocf104,
#                    ocf105  LIKE ocf_file.ocf105,
#                    ocf106  LIKE ocf_file.ocf106,
#                    ocf107  LIKE ocf_file.ocf107,
#                    ocf108  LIKE ocf_file.ocf108,
#                    ocf109  LIKE ocf_file.ocf109,
#                    ocf110  LIKE ocf_file.ocf110,
#                    ocf111  LIKE ocf_file.ocf111,
#                    ocf112  LIKE ocf_file.ocf112,
#                    ocf201  LIKE ocf_file.ocf201,
#                    ocf202  LIKE ocf_file.ocf202,
#                    ocf203  LIKE ocf_file.ocf203,
#                    ocf204  LIKE ocf_file.ocf204,
#                    ocf205  LIKE ocf_file.ocf205,
#                    ocf206  LIKE ocf_file.ocf206,
#                    ocf207  LIKE ocf_file.ocf207,
#                    ocf208  LIKE ocf_file.ocf208,
#                    ocf209  LIKE ocf_file.ocf209,
#                    ocf210  LIKE ocf_file.ocf210,
#                    ocf211  LIKE ocf_file.ocf211,
#                    ocf212  LIKE ocf_file.ocf212, 
#                    oao04   LIKE oao_file.oao04,
#                    oao06h  LIKE oao_file.oao06,
#                    oao06d1 LIKE oao_file.oao06,
#                    oao06d2 LIKE oao_file.oao06,
#                   oao06t  LIKE oao_file.oao06 
#                  END RECORD,
#          l_gfe03   LIKE gfe_file.gfe03,
#FUN-C50008--mark--end

DEFINE    l_gfe03   LIKE gfe_file.gfe03,  #FUN-C50008 Add
          l_occ02   LIKE occ_file.occ02,
          l_gen02   LIKE gen_file.gen02,
          l_oab02   LIKE oab_file.oab02,
          l_gem02   LIKE gem_file.gem02,
          l_oah02   LIKE oah_file.oah02,
          l_oag02   LIKE oag_file.oag02,
          l_gec02   LIKE gec_file.gec02,
          l_addr1   LIKE occ_file.occ241,
          l_addr2   LIKE occ_file.occ241,
          l_addr3   LIKE occ_file.occ241,
          l_addr4   LIKE occ_file.occ241,
          l_addr5   LIKE occ_file.occ241,
          l_ima906  LIKE ima_file.ima906,
          l_oeb910  LIKE oeb_file.oeb910,
          l_oeb912  LIKE oeb_file.oeb912,
          l_oeb913  LIKE oeb_file.oeb913,
          l_oeb915  LIKE oeb_file.oeb915,
          l_oeb12   LIKE oeb_file.oeb12,
          l_unit    LIKE type_file.chr50,
          #l_oao04   LIKE oao_file.oao04,   #MOD-870006
          l_oao06   LIKE oao_file.oao06,
          l_ocf     RECORD LIKE ocf_file.* 
   DEFINE l_img_blob      LIKE type_file.blob  #FUN-C40026 add

   LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
      #-----MOD-870006-----
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   CALL cl_del_data(l_table4)
   #------------------------------ CR (2) ------------------------------#
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?)"       #FUN-C40026 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,? )"
 
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,? )"
 
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,? )"
 
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep3:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
               " VALUES(?,?,?,? )"
 
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep4:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4) #FUN-B40092
      EXIT PROGRAM
   END IF
 
   #DELETE FROM g421_tmp
   #DELETE FROM g421_tmp1
   #
   #LET g_sql = "INSERT INTO g421_tmp ",
   #            " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
   #            "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
   #            "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
   #            "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
   #            "        ?,?,?,?,?, ?,?)"   #FUN-7B0142 拿掉一個?
   #PREPARE insert_prep0 FROM g_sql
   #IF STATUS THEN
   #   CALL cl_err('insert_prep0:',status,1) EXIT PROGRAM
   #END IF
   #
   #LET g_sql = "INSERT INTO g421_tmp1 VALUES(?,?,?,?,?, ?,?,?)"
   #PREPARE insert_prep1 FROM g_sql
   #IF STATUS THEN
   #   CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
   #END IF
   #-----END MOD-870006-----
   #end TQC-740271 add
 
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
   LET l_sql="SELECT oea00,oea01,oea02,oea10,oea11,oea12,",   #No.MOD-570395
             "       oea03,oea032,oea04,oea044,oea43,ged02,oea44,occ02,oea06,",   #No:BGU-570395
             "       oea14,oea15,oea23,oea21,oea25,oea31,oea32,",
             "       oea33,oeb03,oeb04,ima021,oeb05,oeb12,oeb13,oeb14,",
             "       oeb14t,oeb15,oeb1001,azf03,oeb30,oeb06,oeb11,oeb17,oeb18,oeb19,oeb20,oeb21",
             ",'','','','','', ",  #No:7674
            #"      ,occ55,",      #FUN-7B0142 mark  #FUN-570069 add
             "oeb910,oeb912,oeb913,oeb915,oeb916,oeb917 ", #MOD-6B0114 add
             ",azi03,azi04,azi05 ", #FUN-C50008 Add azi03,azi04,azi05
            #"  FROM oea_file,oeb_file,occ_file,OUTER ima_file,OUTER azf_file,OUTER ged_file ",#FUN-C50008 mark--
       #FUN-C50008--add--str  ADD 'LEFT OUTER'
             " FROM oea_file LEFT OUTER JOIN ged_file ON (oea43=ged01) ",
             "               LEFT OUTER JOIN azi_file ON (azi01=oea23),",
             "      oeb_file LEFT OUTER JOIN azf_file ON (oeb1001=azf01)",
             "               LEFT OUTER JOIN ima_file ON (oeb04=ima01) ,occ_file ",
       #FUN-C50008--add--end
             " WHERE oea01=oeb01 ",
            #"   AND oea_file.oea43=ged_file.ged01 ",   #FUN-C50008 mark--
             "   AND oea04=occ01 ",                    
            #"   AND oeb_file.oeb1001=azf_file.azf01 ", #FUN-C50008 mark--
             "   AND oeaconf != 'X' ", 
            #"   AND ima_file.ima01=oeb_file.oeb04 ",   #FUN-C50008 mark--
             "   AND oea00 IN ('8','9') ",
             "   AND ",tm.wc CLIPPED,
             " ORDER BY oea01,oea02,oeb03 "
   PREPARE axmg421_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
      EXIT PROGRAM 
   END IF
   DECLARE axmg421_curs1 CURSOR FOR axmg421_prepare1
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
#FUN-C50008--add--str
   #單身備註-列印於前
   DECLARE oao_c2 CURSOR FOR
      SELECT oao06 FROM oao_file
       WHERE oao01=? AND oao03=? AND oao05='1'
   
   #單身備註-列印於後
   DECLARE oao_c3 CURSOR FOR
      SELECT oao06 FROM oao_file
       WHERE oao01=? AND oao03=? AND oao05='2'

#FUN-C50008--add--end
   LET l_i = 0  
   CALL g_show_msg.clear() #FUN-650020
   #FOREACH axmg421_curs1 INTO sr.*  #FUN-C50008 mark--
   FOREACH axmg421_curs1 INTO sr.*,t_azi03,t_azi04,t_azi05
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
      #str TQC-740271 add
      #慣用文件列印語言
      #IF cl_null(sr.occ55) THEN LET sr.occ55 = '0' END IF  #FUN-7B0142 mark
      #單位小數位數
      SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.oeb05
      IF cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
      #單價、金額、小計小數位數
      #SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #FUN-C50008 mark--
      #  FROM azi_file WHERE azi01=sr.oea23                   #FUN-C50008 mark--  
      IF cl_null(t_azi03) THEN LET t_azi03 = 0 END IF
      IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF
      IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF
      #帳款客戶名稱
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oea03
      IF SQLCA.SQLCODE THEN LET l_occ02='' END IF
      #員工姓名
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oea14
      IF SQLCA.SQLCODE THEN LET l_gen02='' END IF
      #分類名稱
      SELECT oab02 INTO l_oab02 FROM oab_file WHERE oab01=sr.oea25
      IF SQLCA.SQLCODE THEN LET l_oab02='' END IF
      #部門名稱
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oea15
      IF SQLCA.SQLCODE THEN LET l_gem02='' END IF
      #說明
      SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01=sr.oea31
      IF SQLCA.SQLCODE THEN LET l_oah02='' END IF
      #說明
      SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01=sr.oea32
      IF SQLCA.SQLCODE THEN LET l_oah02='' END IF
      #稅別名稱
      SELECT gec02 INTO l_gec02 FROM gec_file WHERE gec01=sr.oea21 AND gec011='2'   #銷項
      IF SQLCA.SQLCODE THEN LET l_gec02='' END IF
      #地址檔
      CALL s_addr(sr.oea01,sr.oea04,sr.oea044) 
           RETURNING l_addr1,l_addr2,l_addr3,l_addr4,l_addr5
      IF SQLCA.SQLCODE THEN
         LET l_addr1='' LET l_addr2='' LET l_addr3='' 
         LET l_addr4='' LET l_addr5=''
      END IF
      #客戶信用查核
      LET g_msg=NULL
      IF g_oaz.oaz121 = "1" THEN
         CALL s_ccc_logerr()  
         LET g_oea01=sr.oea01 
         CALL s_ccc(sr.oea03,'0','')      #Customer Credit Check 客戶信用查核
         #FUN-650020...............begin
         IF g421_err_ana(g_showmsg) THEN
 
         END IF
         #Fun-650020...............end
         IF g_errno = 'N' THEN
            CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
         END IF
      END IF
      #單位備註(當使用多單位時才需要印)
      LET l_unit = ""
      IF g_sma115 = "Y" THEN
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=sr.oeb04
         CASE l_ima906
            WHEN "2"
               CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
               LET l_unit = l_oeb915 , sr.oeb913 CLIPPED
               IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
                  CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                  LET l_unit = l_oeb912, sr.oeb910 CLIPPED
               ELSE
                 IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                    LET l_unit = l_unit CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
                 END IF
               END IF
            WHEN "3"
               IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
                  CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                  LET l_unit = l_oeb915 , sr.oeb913 CLIPPED
               END IF
         END CASE
      END IF
      IF g_sma116 MATCHES '[13]' THEN    #No.FUN-610076
         IF sr.oeb05  <> sr.oeb916 THEN
            CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
            LET l_unit = l_unit CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
         END IF
      END IF
      #列印備註
      #-----MOD-870006---------
      ##整張備註-列印於前
      #DECLARE oao_c1 CURSOR FOR
      # SELECT oao04,oao06 FROM oao_file
      #  WHERE oao01=sr.oea01 AND oao03=0 AND oao05='1'
      #FOREACH oao_c1 INTO l_oao04,l_oao06
      #   IF NOT cl_null(l_oao06) THEN
      #      EXECUTE insert_prep1 USING sr.oea01,'0','1',l_oao04,l_oao06,'','',''
      #   END IF
      #END FOREACH
      ##整張備註-列印於後
      #DECLARE oao_c2 CURSOR FOR
      # SELECT oao04,oao06 FROM oao_file
      #  WHERE oao01=sr.oea01 AND oao03=0 AND oao05='2'
      #FOREACH oao_c2 INTO l_oao04,l_oao06
      #   IF NOT cl_null(l_oao06) THEN
      #      EXECUTE insert_prep1 USING sr.oea01,'0','2',l_oao04,'','','',l_oao06
      #   END IF
      #END FOREACH
      ##單身備註-列印於前
      #DECLARE oao_c3 CURSOR FOR
      # SELECT oao04,oao06 FROM oao_file
      #  WHERE oao01=sr.oea01 AND oao03=sr.oeb03 AND oao05='1'
      #FOREACH oao_c3 INTO l_oao04,l_oao06
      #   IF NOT cl_null(l_oao06) THEN
      #      EXECUTE insert_prep1 USING sr.oea01,sr.oeb03,'1',l_oao04,'',l_oao06,'',''
      #   END IF
      #END FOREACH
      ##單身備註-列印於後
      #DECLARE oao_c4 CURSOR FOR
      # SELECT oao04,oao06 FROM oao_file
      #  WHERE oao01=sr.oea01 AND oao03=sr.oeb03 AND oao05='2'
      #FOREACH oao_c4 INTO l_oao04,l_oao06
      #   IF NOT cl_null(l_oao06) THEN
      #      EXECUTE insert_prep1 USING sr.oea01,sr.oeb03,'2',l_oao04,'','',l_oao06,''
      #   END IF
      #END FOREACH
      #單身備註-列印於前
  #FUN-C50008--mark--str  
     #DECLARE oao_c2 CURSOR FOR
     # SELECT oao06 FROM oao_file
     #  WHERE oao01=sr.oea01 AND oao03=sr.oeb03 AND oao05='1'
     #FOREACH oao_c2 INTO l_oao06
  #FUN-C50008--mark--end
     FOREACH oao_c2 USING sr.oea01,sr.oeb03 INTO l_oao06  #FUN-C50008 add
         IF NOT cl_null(l_oao06) THEN
            EXECUTE insert_prep2 USING sr.oea01,sr.oeb03,'1',l_oao06
         END IF
      END FOREACH
      #單身備註-列印於後
  #FUN-C50008--mark--str
     #DECLARE oao_c3 CURSOR FOR
     # SELECT oao06 FROM oao_file
     #   WHERE oao01=sr.oea01 AND oao03=sr.oeb03 AND oao05='2'
     # FOREACH oao_c3 INTO l_oao06
  #FUN-C50008--mark--end
      FOREACH oao_c3 USING sr.oea01,sr.oeb03 INTO l_oao06  #FUN-C50008 add  
         IF NOT cl_null(l_oao06) THEN
            EXECUTE insert_prep3 USING sr.oea01,sr.oeb03,'2',l_oao06
         END IF
      END FOREACH
      #-----END MOD-870006-----
      #客戶嘜頭檔
      SELECT * INTO l_ocf.* FROM ocf_file WHERE ocf01=sr.oea04 AND ocf02=sr.oea44
      IF SQLCA.SQLCODE THEN INITIALIZE l_ocf.* TO NULL END IF
      IF NOT cl_null(l_ocf.ocf01) THEN
         #-----No.MOD-570395-----
         LET g_po_no=sr.oea10
         LET g_ctn_no1=""
         LET g_ctn_no2=""
         #-----No.MOD-570395 END-----
         LET l_ocf.ocf101=g421_ocf_c(l_ocf.ocf101)
         LET l_ocf.ocf102=g421_ocf_c(l_ocf.ocf102)
         LET l_ocf.ocf103=g421_ocf_c(l_ocf.ocf103)
         LET l_ocf.ocf104=g421_ocf_c(l_ocf.ocf104)
         LET l_ocf.ocf105=g421_ocf_c(l_ocf.ocf105)
         LET l_ocf.ocf106=g421_ocf_c(l_ocf.ocf106)
         LET l_ocf.ocf107=g421_ocf_c(l_ocf.ocf107)
         LET l_ocf.ocf108=g421_ocf_c(l_ocf.ocf108)
         LET l_ocf.ocf109=g421_ocf_c(l_ocf.ocf109)
         LET l_ocf.ocf110=g421_ocf_c(l_ocf.ocf110)
         LET l_ocf.ocf111=g421_ocf_c(l_ocf.ocf111)
         LET l_ocf.ocf112=g421_ocf_c(l_ocf.ocf112)
         LET l_ocf.ocf201=g421_ocf_c(l_ocf.ocf201)
         LET l_ocf.ocf202=g421_ocf_c(l_ocf.ocf202)
         LET l_ocf.ocf203=g421_ocf_c(l_ocf.ocf203)
         LET l_ocf.ocf204=g421_ocf_c(l_ocf.ocf204)
         LET l_ocf.ocf205=g421_ocf_c(l_ocf.ocf205)
         LET l_ocf.ocf206=g421_ocf_c(l_ocf.ocf206)
         LET l_ocf.ocf207=g421_ocf_c(l_ocf.ocf207)
         LET l_ocf.ocf208=g421_ocf_c(l_ocf.ocf208)
         LET l_ocf.ocf209=g421_ocf_c(l_ocf.ocf209)
         LET l_ocf.ocf210=g421_ocf_c(l_ocf.ocf210)
         LET l_ocf.ocf211=g421_ocf_c(l_ocf.ocf211)
         LET l_ocf.ocf212=g421_ocf_c(l_ocf.ocf212)
      ELSE
         LET l_ocf.ocf01=' '
         LET l_ocf.ocf02=' '
         LET l_ocf.ocf101=' '
         LET l_ocf.ocf102=' '
         LET l_ocf.ocf103=' '
         LET l_ocf.ocf104=' '
         LET l_ocf.ocf105=' '
         LET l_ocf.ocf106=' '
         LET l_ocf.ocf107=' '
         LET l_ocf.ocf108=' '
         LET l_ocf.ocf109=' '
         LET l_ocf.ocf110=' '
         LET l_ocf.ocf111=' '
         LET l_ocf.ocf112=' '
         LET l_ocf.ocf201=' '
         LET l_ocf.ocf202=' '
         LET l_ocf.ocf203=' '
         LET l_ocf.ocf204=' '
         LET l_ocf.ocf205=' '
         LET l_ocf.ocf206=' '
         LET l_ocf.ocf207=' '
         LET l_ocf.ocf208=' '
         LET l_ocf.ocf209=' '
         LET l_ocf.ocf210=' '
         LET l_ocf.ocf211=' '
         LET l_ocf.ocf212=' '
      END IF
 
      #EXECUTE insert_prep0 USING    #MOD-870006
      EXECUTE insert_prep USING    #MOD-870006
         sr.oea00    ,sr.oea01    ,sr.oea02    ,sr.oea10    ,sr.oea11    ,
         sr.oea12    ,sr.oea03    ,sr.oea032   ,sr.oea04    ,sr.oea044   ,
         sr.oea43    ,sr.ged02    ,
         sr.oea44    ,sr.occ02    ,sr.oea06    ,sr.oea14    ,sr.oea15    ,
         sr.oea23    ,sr.oea21    ,sr.oea25    ,sr.oea31    ,sr.oea32    ,
         sr.oea33    ,sr.oeb03    ,sr.oeb04    ,sr.ima021   ,sr.oeb05    ,
         sr.oeb12    ,sr.oeb13    ,sr.oeb14    ,sr.oeb14t   ,sr.oeb15    ,
         sr.oeb1001  ,sr.azf03    ,sr.oeb30    ,
         sr.oeb06    ,sr.oeb11    ,sr.oeb17    ,sr.oeb18    ,sr.oeb19    ,
        #sr.oeb20    ,sr.oeb21    ,sr.occ55    ,sr.oeb916   ,sr.oeb917   ,  #FUN-7B0142 mod
         sr.oeb20    ,sr.oeb21    ,sr.oeb916   ,sr.oeb917   ,               #FUN-7B0142 mark
         l_gfe03     ,t_azi03     ,t_azi04     ,t_azi05     ,l_occ02     ,
         l_gen02     ,l_oab02     ,l_gem02     ,l_oah02     ,l_oag02     ,
         l_gec02     ,l_addr1     ,l_addr2     ,l_addr3     ,l_addr4     ,
         l_addr5     ,l_unit      ,l_ocf.ocf01 ,l_ocf.ocf02 ,l_ocf.ocf101,
         l_ocf.ocf102,l_ocf.ocf103,l_ocf.ocf104,l_ocf.ocf105,l_ocf.ocf106,
         l_ocf.ocf107,l_ocf.ocf108,l_ocf.ocf109,l_ocf.ocf110,l_ocf.ocf111,
         l_ocf.ocf112,l_ocf.ocf201,l_ocf.ocf202,l_ocf.ocf203,l_ocf.ocf204,
         l_ocf.ocf205,l_ocf.ocf206,l_ocf.ocf207,l_ocf.ocf208,l_ocf.ocf209,
         l_ocf.ocf210,l_ocf.ocf211,l_ocf.ocf212,                            #FUN-C40026 add ,
         "",l_img_blob,"N",""                                               #FUN-C40026 add
 
   END FOREACH
    
   LET g_cr_table = l_table                 #FUN-C40026 add
   LET g_cr_apr_key_f = "oea01"             #FUN-C40026 add 
   #-----MOD-870006---------
   LET l_sql = "SELECT DISTINCT oea01 FROM ",
                g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE g421_p FROM l_sql
   DECLARE g421_curs CURSOR FOR g421_p

#FUN-C50008--add--str
   #整張備註-列印於前
   DECLARE oao_c1 CURSOR FOR
      SELECT oao06 FROM oao_file
       WHERE oao01=? AND oao03=0 AND oao05='1'

   #整張備註-列印於後
   DECLARE oao_c4 CURSOR FOR
      SELECT oao06 FROM oao_file
       WHERE oao01=? AND oao03=0 AND oao05='2'
#FUN-C50008--add--end
   FOREACH g421_curs INTO sr.oea01
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     #整張備註-列印於前
#FUN-C50008--mark--str
    # DECLARE oao_c1 CURSOR FOR
    #   SELECT oao06 FROM oao_file
    #   WHERE oao01=sr.oea01 AND oao03=0 AND oao05='1'
    # FOREACH oao_c1 INTO l_oao06
#FUN-C50008--mark--end
    FOREACH oao_c1 USING sr.oea01 INTO l_oao06 #FUN-C50008 add
        IF NOT cl_null(l_oao06) THEN
           EXECUTE insert_prep1 USING sr.oea01,'0','1',l_oao06
        END IF
     END FOREACH
     #整張備註-列印於後
#FUN-C50008--mark--str
     #DECLARE oao_c4 CURSOR FOR
     # SELECT oao06 FROM oao_file
     #  WHERE oao01=sr.oea01 AND oao03=0 AND oao05='2'
     #FOREACH oao_c4 INTO l_oao06
#FUN-C50008--mark--end
     FOREACH oao_c4 USING sr.oea01 INTO l_oao06  #FUN-C50008 add
        IF NOT cl_null(l_oao06) THEN
           EXECUTE insert_prep4 USING sr.oea01,'0','2',l_oao06
        END IF
     END FOREACH
   END FOREACH
   #-----END MOD-870006-----
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  #TQC-730022
      IF g_show_msg.getlength()>0 THEN
         CALL cl_get_feldname("oea01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("oea03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("occ02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("occ18",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
         CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
      END IF
   END IF   #TQC-730022
 
   #str TQC-740271 add
   #-----MOD-870006---------
   #LET l_sql=
   #   "SELECT A.*,",
   #   "       B.oao04,B.oao06h,'','',B.oao06t ",
   #   "  FROM g421_tmp A,",
   #   "       OUTER g421_tmp1 B ",
   #   " WHERE A.oea01=B.oea01_1",
   #   " UNION ",
   #   "SELECT A.*,",
   #   "       C.oao04,'',C.oao06d1,C.oao06d2,'' ",
   #   "  FROM g421_tmp A,",
   #   "       OUTER g421_tmp1 C ",
   #   " WHERE A.oea01=C.oea01_1 AND A.oeb03=C.oao03"
   #   
   #PREPARE axmg421_prepare0 FROM l_sql
   #IF SQLCA.sqlcode != 0 THEN
   #   CALL cl_err('prepare0:',SQLCA.sqlcode,1)
   #END IF
   #DECLARE axmg421_curs0 CURSOR FOR axmg421_prepare0
   #FOREACH axmg421_curs0 INTO cr.*
   #   ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
   #   EXECUTE insert_prep USING
   #      cr.oea00  ,cr.oea01  ,cr.oea02 ,cr.oea10 ,cr.oea11  ,
   #      cr.oea12  ,cr.oea03  ,cr.oea032,cr.oea04 ,cr.oea044 ,
   #      cr.oea43  ,cr.ged02  ,
   #      cr.oea44  ,cr.occ02  ,cr.oea06 ,cr.oea14 ,cr.oea15  ,
   #      cr.oea23  ,cr.oea21  ,cr.oea25 ,cr.oea31 ,cr.oea32  ,
   #      cr.oea33  ,cr.oeb03  ,cr.oeb04 ,cr.ima021,cr.oeb05  ,
   #      cr.oeb12  ,cr.oeb13  ,cr.oeb14 ,cr.oeb14t,cr.oeb15  ,
   #      cr.oeb1001,cr.azf03  ,cr.oeb30 ,
   #      cr.oeb06  ,cr.oeb11  ,cr.oeb17 ,cr.oeb18 ,cr.oeb19  ,
   #     #cr.oeb20  ,cr.oeb21  ,cr.occ55 ,cr.oeb916,cr.oeb917 ,  #FUN-7B0142 mark
   #      cr.oeb20  ,cr.oeb21  ,cr.oeb916,cr.oeb917 ,            #FUN-7B0142 mod
   #      cr.gfe03  ,cr.azi03  ,cr.azi04 ,cr.azi05 ,cr.occ02_1,
   #      cr.gen02  ,cr.oab02  ,cr.gem02 ,cr.oah02 ,cr.oag02  ,
   #      cr.gec02  ,cr.addr1  ,cr.addr2 ,cr.addr3 ,cr.addr4  ,
   #      cr.addr5  ,cr.unit   ,cr.ocf01 ,cr.ocf02 ,cr.ocf101 ,
   #      cr.ocf102 ,cr.ocf103 ,cr.ocf104,cr.ocf105,cr.ocf106 ,
   #      cr.ocf107 ,cr.ocf108 ,cr.ocf109,cr.ocf110,cr.ocf111 ,
   #      cr.ocf112 ,cr.ocf201 ,cr.ocf202,cr.ocf203,cr.ocf204 ,
   #      cr.ocf205 ,cr.ocf206 ,cr.ocf207,cr.ocf208,cr.ocf209 ,
   #      cr.ocf210 ,cr.ocf211 ,cr.ocf212,cr.oao04 ,cr.oao06h ,
   #      cr.oao06d1,cr.oao06d2,cr.oao06t
   #   #------------------------------ CR (3) ------------------------------#
   #END FOREACH
   #-----END MOD-870006-----
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   #-----MOD-870006---------
   #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table  CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED
   #-----END MOD-870006-----
   #LET g_str = g_sma116
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'oea01,oea02,oea14')
           RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF
###GENGRE###   LET g_str = tm.wc
###GENGRE###   CALL cl_prt_cs3('axmg421','axmg421',g_sql,g_str)
    CALL axmg421_grdata()    ###GENGRE###
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
 
#No:7674 add
FUNCTION g421_ocf_c(str)
  DEFINE str   LIKE cob_file.cob08        #No.FUN-680137 VARCHAR(30)
  DEFINE i,j    LIKE type_file.num5       #No.FUN-680137 SMALLINT
  # 把麥頭內'PPPPPP'字串改為 P/O NO (ofa.ofa10)
  # 把麥頭內'CCCCCC'字串改為 CTN NO (ofa.ofa45)
  # 把麥頭內'DDDDDD'字串改為 CTN NO (ofa.ofa46)
  FOR i=1 TO 20
    LET j=i+5
    IF str[i,j]='PPPPPP' THEN LET str[i,30]=g_po_no   RETURN str END IF
    IF str[i,j]='CCCCCC' THEN LET str[i,30]=g_ctn_no1 RETURN str END IF
    IF str[i,j]='DDDDDD' THEN LET str[i,30]=g_ctn_no2 RETURN str END IF
  END FOR
  RETURN str
END FUNCTION
##
 
FUNCTION g421_err_ana(ls_showmsg)    #FUN-650020
   DEFINE ls_showmsg  STRING
   DEFINE lc_oea03    LIKE oea_file.oea03
   DEFINE lc_ze01     LIKE ze_file.ze01
   DEFINE lc_occ02    LIKE occ_file.occ02
   DEFINE lc_occ18    LIKE occ_file.occ18
   DEFINE li_newerrno LIKE type_file.num5     #No.FUN-680137 SMALLINT
   DEFINE ls_tmpstr   STRING
 
   IF cl_null(ls_showmsg) THEN
      RETURN FALSE
   END IF
 
   LET lc_oea03 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
   LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                         ls_showmsg.getLength())
   IF ls_showmsg.getIndexOf("||",1) THEN
      LET lc_ze01 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
      LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                            ls_showmsg.getLength())
   ELSE
      LET lc_ze01 = ls_showmsg.trim()
      LET ls_showmsg = ""
   END IF
 
   SELECT occ02,occ18 INTO lc_occ02,lc_occ18 FROM occ_file
    WHERE occ01=lc_oea03
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].oea01   = g_oea01
   LET g_show_msg[li_newerrno].oea03   = lc_oea03
   LET g_show_msg[li_newerrno].occ02   = lc_occ02
   LET g_show_msg[li_newerrno].occ18   = lc_occ18
   LET g_show_msg[li_newerrno].ze01    = lc_ze01
   CALL cl_getmsg(lc_ze01,g_lang) RETURNING ls_tmpstr
   LET g_show_msg[li_newerrno].ze03    = ls_showmsg.trim(),ls_tmpstr.trim()
   #kim test
   LET li_newerrno = g_show_msg.getLength()
   DISPLAY li_newerrno
   RETURN TRUE
 
END FUNCTION
#FUN-750036
#MOD-870012

###GENGRE###START
FUNCTION axmg421_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    LOCATE sr1.sign_img IN MEMORY    #FUN-C40026 add
    CALL cl_gre_init_apr()           #FUN-C40026 add
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg421")
        IF handler IS NOT NULL THEN
            START REPORT axmg421_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY oea01,oeb03"            #FUN-B40092 add
            DECLARE axmg421_datacur1 CURSOR FROM l_sql
            FOREACH axmg421_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg421_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg421_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg421_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE sr4 sr4_t
    DEFINE sr5 sr5_t
    DEFINE l_oea01_oea00 STRING
    DEFINE l_oea04_occ02 STRING
    DEFINE l_oea14_gen02 STRING
    DEFINE l_oea15_gem02 STRING
    DEFINE l_oea43_ged02 STRING
    DEFINE l_oea00 STRING
    DEFINE l_sql   STRING
    DEFINE l_oeb12_sum LIKE oeb_file.oeb12
    DEFINE l_lineno    LIKE type_file.num5

    
    ORDER EXTERNAL BY sr1.oea01,sr1.oeb03
    
    FORMAT
        FIRST PAGE HEADER
          IF sr1.oea00 = '8' OR sr1.oea00 = '9' THEN
            LET g_grPageHeader.title2 = cl_gr_getmsg("gre-013",g_lang,sr1.oea00)
            LET g_grPageHeader.title2 = g_grPageHeader.title2
          END IF
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.oea01
            LET l_lineno = 0
           #FUN-B40092---------add---------str
            IF NOT cl_null(sr1.oea01) AND NOT cl_null(sr1.oea00) THEN
            LET l_oea01_oea00 = sr1.oea01,' ','(',sr1.oea00,')'
         ELSE
            IF NOT cl_null(sr1.oea01) AND cl_null(sr1.oea00) THEN
               LET l_oea01_oea00 = sr1.oea01
            END IF
            IF  cl_null(sr1.oea01) AND NOT cl_null(sr1.oea00) THEN
               LET l_oea01_oea00 = '(',sr1.oea00,')'
            END IF
        END IF

            IF NOT cl_null(sr1.oea04) AND NOT cl_null(sr1.occ02) THEN
            LET l_oea04_occ02 = sr1.oea04,' ',sr1.occ02
         ELSE
            IF NOT cl_null(sr1.oea04) AND cl_null(sr1.occ02) THEN
               LET l_oea04_occ02 = sr1.oea04
            END IF
            IF  cl_null(sr1.oea04) AND NOT cl_null(sr1.occ02) THEN
               LET l_oea04_occ02 = sr1.occ02
            END IF
        END IF

            IF NOT cl_null(sr1.oea14) AND NOT cl_null(sr1.gen02) THEN
            LET l_oea14_gen02 = sr1.oea14,' ',sr1.gen02
         ELSE
            IF NOT cl_null(sr1.oea14) AND  cl_null(sr1.gen02) THEN
               LET l_oea14_gen02 = sr1.oea14
            END IF
            IF  cl_null(sr1.oea14) AND NOT cl_null(sr1.gen02) THEN
               LET l_oea14_gen02 = sr1.gen02
            END IF
        END IF

        IF NOT cl_null(sr1.oea15) AND NOT cl_null(sr1.gem02) THEN
            LET l_oea15_gem02 = sr1.oea15,' ',sr1.gem02
         ELSE
            IF NOT cl_null(sr1.oea15) AND  cl_null(sr1.gem02) THEN
               LET l_oea15_gem02 = sr1.oea15
            END IF
            IF  cl_null(sr1.oea15) AND NOT cl_null(sr1.gem02) THEN
               LET l_oea15_gem02 = sr1.gem02
            END IF
        END IF
    
        IF NOT cl_null(sr1.oea43) AND NOT cl_null(sr1.ged02) THEN
            LET l_oea43_ged02 = sr1.oea43,' ',sr1.ged02
         ELSE
            IF NOT cl_null(sr1.oea43) AND  cl_null(sr1.ged02) THEN
               LET l_oea43_ged02 = sr1.oea43
            END IF
            IF  cl_null(sr1.oea43) AND NOT cl_null(sr1.ged02) THEN
               LET l_oea43_ged02 = sr1.ged02
            ELSE
               LET l_oea43_ged02 = NULL
            END IF
        END IF
            #FUN-B40092---------add---------end
            #FUN-B40092---------add---------str
         #單身前單據備註
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01_1 = '",sr1.oea01 CLIPPED,"'",
                        " AND oao03_1 = 0 AND oao05_1='1'"
            START REPORT axmg421_subrep01
            DECLARE axmg421_repcur1 CURSOR FROM l_sql
            FOREACH axmg421_repcur1 INTO sr2.*
                OUTPUT TO REPORT axmg421_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axmg421_subrep01
            #FUN-B40092---------add---------end
        PRINTX l_oea01_oea00
        PRINTX l_oea04_occ02
        PRINTX l_oea14_gen02
        PRINTX l_oea15_gem02
        PRINTX l_oea43_ged02
        BEFORE GROUP OF sr1.oeb03

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B40092---------add---------str
            #單身前備註
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE oao01_2 = '",sr1.oea01 CLIPPED,"'",
                        " AND oao03_2 = ",sr1.oeb03 CLIPPED," AND oao05_2='1'"
            START REPORT axmg421_subrep02
            DECLARE axmg421_repcur2 CURSOR FROM l_sql
            FOREACH axmg421_repcur2 INTO sr3.*
                OUTPUT TO REPORT axmg421_subrep02(sr3.*)
            END FOREACH
            FINISH REPORT axmg421_subrep02
       
            #單身後備註
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE oao01_3 = '",sr1.oea01 CLIPPED,"'",
                        " AND oao03_3 = ",sr1.oeb03 CLIPPED," AND oao05_3='2'"
            START REPORT axmg421_subrep03
            DECLARE axmg421_repcur3 CURSOR FROM l_sql
            FOREACH axmg421_repcur3 INTO sr4.*
                OUTPUT TO REPORT axmg421_subrep03(sr4.*)
            END FOREACH
            FINISH REPORT axmg421_subrep03
            #FUN-B40092---------add---------end
            PRINTX sr1.*

        AFTER GROUP OF sr1.oea01
            #FUN-B40092---------add---------str
            #單身後單據備註
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                        " WHERE oao01_4 = '",sr1.oea01 CLIPPED,"'",
                        " AND oao03_4 = 0 AND oao05_4='2'"
            START REPORT axmg421_subrep04
            DECLARE axmg421_repcur4 CURSOR FROM l_sql
            FOREACH axmg421_repcur4 INTO sr5.*

                OUTPUT TO REPORT axmg421_subrep04(sr5.*)
            END FOREACH
            FINISH REPORT axmg421_subrep04
            LET l_oeb12_sum = GROUP SUM(sr1.oeb12)

            PRINTX l_oeb12_sum
            #FUN-B40092---------add---------end
        AFTER GROUP OF sr1.oeb03
        ON LAST ROW

END REPORT
#FUN-B40092---------add---------str
REPORT axmg421_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg421_subrep02(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT

REPORT axmg421_subrep03(sr4)
    DEFINE sr4 sr4_t

    FORMAT
        ON EVERY ROW
            PRINTX sr4.*
END REPORT

REPORT axmg421_subrep04(sr5)
    DEFINE sr5 sr5_t

    FORMAT
        ON EVERY ROW
            PRINTX sr5.*
END REPORT

#FUN-B40092---------add---------end
###GENGRE###END
