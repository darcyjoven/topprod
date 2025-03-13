# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: amdg312.4gl
# Descriptions...: 營業人申報適用零稅率銷售額清單
# Date & Author..: 95/02/28 By Danny
# Modify ........: No.dbo.B594 010524 by linda 原本抓oga_file,改用amd_file
# Modify.........: No:6887 03/08/07 By Wiky amd39 放寬欄位20
# Modify.........: No:8028 03/09/02 By Wiky 字軌號碼不應列印帳款編號,應列印發票號碼
# Modify.........: No:8389 03/10/16 By Kitty 選擇是否列印出貨明細 為 N 時, 資料錯誤
# Modify.........: No.MOD-520086 05/03/14 By Kitty 增加選項選擇是否列印海關出口文件
# Modify.........: No.MOD-530241 05/03/24 By Nicola 4GL中有中文、把USING改為cl_numfor
# Modify.........: No.MOD-540017 05/04/06 By Nicola 1.輸出或結匯日期年改為3碼  Ex: 94 ==> 094
#                                                   2.依不同之外銷方式分頁,
#                                                   3.屬於4之部份放置於首頁後依序號編號裝訂
# Modify.........: No.FUN-550114 05/05/31 By echo 新增報表備註
# Modify.........: No.MOD-590097 05/09/08 By wujie 報表全型表格維護
# Modify.........: No.FUN-580030 05/09/16 By Nicola (1) 發票資料有問題 :
#                                                       [開立發票]下的 [字軌號碼],  應該跟 [非經海關出口應附證明文件者]下的[號碼] 為同一發票.
#                                                       i.e. 不同發票應該會先有獨立的一個項次後, 再把明細列印出來.
#                                                   (2) QBE條件的 申報年月 抓出的資料不夠完整:
#                                                       應該是抓 5,6 月份的資料. 以要申報的那一期為一個單位抓資料.
#                                                       i.e. , 若QBE條件下的年度/月份 為  " 2005 / 6 " ,   查詢出來的資料應該是 5 -6 月份所有資料才是.
#                                                   (3) 總計資訊 要分兩類 ---
#                                                       針對[外銷方式4印於首頁]功能選取後,於外銷方式為4.的那一資料區塊最後,要有一個總計資訊(針對4.的資料來做總計).
#                                                                                                   非4.的其他所有資料最後,也要有一個總計資訊(針對非4.的資料來做總計).
# Modify.........: No.MOD-590455 05/11/03 By Smapmin 報表列印格式修改
# Modify.........: No.MOD-5B0041 05/11/28 By Smapmin INPUT 條件改為:年/起始月份-截止月份
# Modify.........: No.TQC-5B0201 05/12/22 BY yiting 年月輸入模式統一為：年/起始月份-截止月份
# Modify.........: No.MOD-5A0280 06/01/04 By Smapmin 報表修正
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.MOD-610040 06/01/11 By Smapmin 申報部門開窗
# Modify.........: No.TQC-610057 06/01/20 By Kevin 修改外部參數接收
# Modify.........: No.MOD-630067 06/03/20 By Smapmin SQL語法調整
# Modify.........: No.MOD-640504 06/04/19 By Smapmin amd03放大到16
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-6A0122 06/10/31 By Smapmin 報表年月有錯
#                                                    報表跳頁有錯
#　　　　　　　　　　　　　　　　　　　　　　　　　　列印海關出口免附證明文件應只影響海關資料列印與否
# Modify.........: No.MOD-6C0162 07/01/05 By Smapmin 依帳款編號加項次為GROUP的依據
# Modify.........: No.FUN-730010 07/03/08 By chenl   報表改為使用crystal report
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.MOD-730109 07/04/03 By Smapmin 將資料年度列入SELECT條件
# Modify.........: No.MOD-740394 07/04/26 By Sarah 報表印不出來,更改EXECUTE insert_prep寫法
# Modify.........: No.MOD-7B0139 07/11/14 By jamie 產品明細列印不完整，以及最後一頁需要有總合計數
# Modify.........: No.FUN-7B0086 07/11/15 By jamie 同一筆帳款(字軌號碼)日期、字軌、名稱、統編、金額 應只顯示一筆。
#                                                  目前若銷項明細有多筆，就會印多次，總金額亦會被重複加總，需修正。
# Modify.........: No:EXT-7B0152 07/11/29 By jamie 列印時，出現頁次亂跳的情況
# Modify.........: No.FUN-830012 08/03/10 By Sarah 當tm.a(應列印出貨明細)='N'時,amf_file資料只抓一筆(非MISC),將數量加總後顯示
# Modify.........: No.MOD-8A0171 08/10/20 By Sarah SQL增加amd30='Y'條件
# Modify.........: No.MOD-8A0237 08/10/31 By Sarah 1.當tm.a='N'時,相同報關單金額需加總只顯示在第一筆
#                                                  2.報表改以amd05,amd03,amd39排序
#                                                  3.報表金額欄位為0時不顯示
# Modify.........: No.MOD-8B0163 08/11/17 By Sarah 當外銷方式(amd35)!='4'時,排序方式改為ORDER BY amd10,amd05,amd39
# Modify.........: No.MOD-910165 09/01/16 By Sarah 程式現在判斷當amd03,amd39與前一筆相同時,將amd08歸零,應增加判斷amd37,ORDER BY也應增加amd37
# Modify.........: No.MOD-930016 09/03/04 By lilingyu 若勾選應列印出貨明細,當遇到相同報關單號碼時,第二筆金額的資料不會顯示
# Modify.........: No.MOD-930116 09/03/04 By lilingyu 增加判斷amd01(賬款編號)
# Modify.........: No.MOD-930132 09/03/11 By lilingyu 修改料號為MISC時的資料條件處理
# Modify.........: No.MOD-930129 09/03/30 By Sarah 當tm.a(應列印出貨明細)為Y時,應比較amd03,amd39,amd37,amd01,amd02不同時,將資料寫入Temptable
#                                                                        為N時,應比較amd03,amd39,amd37不同時,將資料寫入Temptable
# Modify.........: No.MOD-960130 09/06/10 By Sarah 檢查amd03需存在ome_file裡,不存在則報表不顯示amd03
# Modify.........: No.CHI-910022 09/07/14 By mike 依據 amd171 若為 '31' 時才需要列印 occ11 買方統一編號                             
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990242 09/09/25 By Sarah 調整SQL的排序順序
# Modify.........: No:MOD-9C0123 09/12/14 By Sarah 報表增加抓取zo05
# Modify.........: No:MOD-9C0324 09/12/25 By Sarah 修改MOD-960130,當ooz64='Y'時才檢查發票號碼是否存在ome_file,不然手動於amdi100新增的發票資料會被清空
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No.FUN-A10098 10/01/20 By chenls plant(azp01)拿掉，程式中 foreach azp03 的迴圈拿掉，跨DB的SQL段改成不跨
# Modify.........: No.TQC-A40101 10/04/21 By Carrier Main中各段落顺序调整 & TQC-A40101追单
# Modify.........: No:MOD-A50087 10/05/13 By sabrina MOD-9C0324所加的檢查應增加判斷為應收發票(amd021='3')才檢查ome_file
# Modify.........: No:MOD-A70177 10/07/22 By Dido amd03 增加檢核條件 
# Modify.........: No:MOD-B50098 11/05/11 By Dido 判斷 tm.d = 'Y'才歸零加總變數 s_total
# Modify.........: No:MOD-B50126 11/05/13 By Dido 結匯日期先判斷 amd43 是否有值若沒有才抓 amd05
# Modify.........: No.FUN-B40092 11/06/07 By xujing \t特殊字元導致轉GR的時候p_gengre出錯
# Modify.........: No.FUN-B40092 11/06/08 By xujing 憑證報表轉GRW 
# Modify.........: No.FUN-B80050 11/08/03 By minpp 程序撰写规范修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm       RECORD
                   wc          LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(1000)
                   ooz61       LIKE ooz_file.ooz61,       #No.FUN-680074 VARCHAR(50) #受文者
                   yy          LIKE type_file.num10,      #No.FUN-680074 INTEGER #年度
                   mm          LIKE type_file.num10,      #No.FUN-680074 INTEGER #月份
                   mm2         LIKE type_file.num10,      #No.FUN-680074 INTEGER #月份   #MOD-5B0041
                   date        LIKE type_file.dat,        #No.FUN-680074 DATE #申請日期
                   amd22       LIKE amd_file.amd22,
                   a           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(01)
                   b           LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01) #No:8389
                   c           LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01) #No.MOD-520086
                   d           LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01) #No.MOD-540017
                   more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(01)
                END RECORD,
       g_ama    RECORD LIKE ama_file.*,
       b_date   LIKE type_file.dat,           #No.FUN-680074 DATE
       e_date   LIKE type_file.dat,           #No.FUN-680074 DATE
       g_zo     RECORD LIKE zo_file.*
DEFINE g_sql    STRING
DEFINE g_str    STRING
DEFINE l_table  STRING
 
DEFINE g_cnt      LIKE type_file.num10           #MOD-930132
 
###GENGRE###START
TYPE sr1_t RECORD
    amd01_0 LIKE amd_file.amd01,
    amd03_0 LIKE amd_file.amd03,
    amd02_0 LIKE amd_file.amd02,
    amd05_0 LIKE type_file.chr9,
    amd41_0 LIKE amd_file.amd41,
    amd08_0 LIKE amd_file.amd08,
    occ11_0 LIKE occ_file.occ11,
    amf04_0 LIKE amf_file.amf04,
    amf06_0 LIKE amf_file.amf06,
    amf07_0 LIKE amf_file.amf07,
    amd43_0 LIKE type_file.chr9,
    amd35_0 LIKE amd_file.amd35,
    amd35a_0 LIKE amd_file.amd35,
    amd36_0 LIKE amd_file.amd36,
    amd37_0 LIKE amd_file.amd37,
    amd38_0 LIKE amd_file.amd38,
    amd39_0 LIKE amd_file.amd39,
    amd10_0 LIKE amd_file.amd10,
    amd01a_0 LIKE type_file.chr30,
    amd01_1 LIKE amd_file.amd01,
    amd03_1 LIKE amd_file.amd03,
    amd02_1 LIKE amd_file.amd02,
    amd05_1 LIKE type_file.chr9,
    amd41_1 LIKE amd_file.amd41,
    amd08_1 LIKE amd_file.amd08,
    occ11_1 LIKE occ_file.occ11,
    amf04_1 LIKE amf_file.amf04,
    amf06_1 LIKE amf_file.amf06,
    amf07_1 LIKE amf_file.amf07,
    amd43_1 LIKE type_file.chr9,
    amd35_1 LIKE amd_file.amd35,
    amd35a_1 LIKE amd_file.amd35,
    amd36_1 LIKE amd_file.amd36,
    amd37_1 LIKE amd_file.amd37,
    amd38_1 LIKE amd_file.amd38,
    amd39_1 LIKE amd_file.amd39,
    amd10_1 LIKE amd_file.amd10,
    amd01a_1 LIKE type_file.chr30,
    amd01_2 LIKE amd_file.amd01,
    amd03_2 LIKE amd_file.amd03,
    amd02_2 LIKE amd_file.amd02,
    amd05_2 LIKE type_file.chr9,
    amd41_2 LIKE amd_file.amd41,
    amd08_2 LIKE amd_file.amd08,
    occ11_2 LIKE occ_file.occ11,
    amf04_2 LIKE amf_file.amf04,
    amf06_2 LIKE amf_file.amf06,
    amf07_2 LIKE amf_file.amf07,
    amd43_2 LIKE type_file.chr9,
    amd35_2 LIKE amd_file.amd35,
    amd35a_2 LIKE amd_file.amd35,
    amd36_2 LIKE amd_file.amd36,
    amd37_2 LIKE amd_file.amd37,
    amd38_2 LIKE amd_file.amd38,
    amd39_2 LIKE amd_file.amd39,
    amd10_2 LIKE amd_file.amd10,
    amd01a_2 LIKE type_file.chr30,
    amd01_3 LIKE amd_file.amd01,
    amd03_3 LIKE amd_file.amd03,
    amd02_3 LIKE amd_file.amd02,
    amd05_3 LIKE type_file.chr9,
    amd41_3 LIKE amd_file.amd41,
    amd08_3 LIKE amd_file.amd08,
    occ11_3 LIKE occ_file.occ11,
    amf04_3 LIKE amf_file.amf04,
    amf06_3 LIKE amf_file.amf06,
    amf07_3 LIKE amf_file.amf07,
    amd43_3 LIKE type_file.chr9,
    amd35_3 LIKE amd_file.amd35,
    amd35a_3 LIKE amd_file.amd35,
    amd36_3 LIKE amd_file.amd36,
    amd37_3 LIKE amd_file.amd37,
    amd38_3 LIKE amd_file.amd38,
    amd39_3 LIKE amd_file.amd39,
    amd10_3 LIKE amd_file.amd10,
    amd01a_3 LIKE type_file.chr30,
    amd01_4 LIKE amd_file.amd01,
    amd03_4 LIKE amd_file.amd03,
    amd02_4 LIKE amd_file.amd02,
    amd05_4 LIKE type_file.chr9,
    amd41_4 LIKE amd_file.amd41,
    amd08_4 LIKE amd_file.amd08,
    occ11_4 LIKE occ_file.occ11,
    amf04_4 LIKE amf_file.amf04,
    amf06_4 LIKE amf_file.amf06,
    amf07_4 LIKE amf_file.amf07,
    amd43_4 LIKE type_file.chr9,
    amd35_4 LIKE amd_file.amd35,
    amd35a_4 LIKE amd_file.amd35,
    amd36_4 LIKE amd_file.amd36,
    amd37_4 LIKE amd_file.amd37,
    amd38_4 LIKE amd_file.amd38,
    amd39_4 LIKE amd_file.amd39,
    amd10_4 LIKE amd_file.amd10,
    amd01a_4 LIKE type_file.chr30,
    amd01_5 LIKE amd_file.amd01,
    amd03_5 LIKE amd_file.amd03,
    amd02_5 LIKE amd_file.amd02,
    amd05_5 LIKE type_file.chr9,
    amd41_5 LIKE amd_file.amd41,
    amd08_5 LIKE amd_file.amd08,
    occ11_5 LIKE occ_file.occ11,
    amf04_5 LIKE amf_file.amf04,
    amf06_5 LIKE amf_file.amf06,
    amf07_5 LIKE amf_file.amf07,
    amd43_5 LIKE type_file.chr9,
    amd35_5 LIKE amd_file.amd35,
    amd35a_5 LIKE amd_file.amd35,
    amd36_5 LIKE amd_file.amd36,
    amd37_5 LIKE amd_file.amd37,
    amd38_5 LIKE amd_file.amd38,
    amd39_5 LIKE amd_file.amd39,
    amd10_5 LIKE amd_file.amd10,
    amd01a_5 LIKE type_file.chr30,
    amd01_6 LIKE amd_file.amd01,
    amd03_6 LIKE amd_file.amd03,
    amd02_6 LIKE amd_file.amd02,
    amd05_6 LIKE type_file.chr9,
    amd41_6 LIKE amd_file.amd41,
    amd08_6 LIKE amd_file.amd08,
    occ11_6 LIKE occ_file.occ11,
    amf04_6 LIKE amf_file.amf04,
    amf06_6 LIKE amf_file.amf06,
    amf07_6 LIKE amf_file.amf07,
    amd43_6 LIKE type_file.chr9,
    amd35_6 LIKE amd_file.amd35,
    amd35a_6 LIKE amd_file.amd35,
    amd36_6 LIKE amd_file.amd36,
    amd37_6 LIKE amd_file.amd37,
    amd38_6 LIKE amd_file.amd38,
    amd39_6 LIKE amd_file.amd39,
    amd10_6 LIKE amd_file.amd10,
    amd01a_6 LIKE type_file.chr30,
    amd01_7 LIKE amd_file.amd01,
    amd03_7 LIKE amd_file.amd03,
    amd02_7 LIKE amd_file.amd02,
    amd05_7 LIKE type_file.chr9,
    amd41_7 LIKE amd_file.amd41,
    amd08_7 LIKE amd_file.amd08,
    occ11_7 LIKE occ_file.occ11,
    amf04_7 LIKE amf_file.amf04,
    amf06_7 LIKE amf_file.amf06,
    amf07_7 LIKE amf_file.amf07,
    amd43_7 LIKE type_file.chr9,
    amd35_7 LIKE amd_file.amd35,
    amd35a_7 LIKE amd_file.amd35,
    amd36_7 LIKE amd_file.amd36,
    amd37_7 LIKE amd_file.amd37,
    amd38_7 LIKE amd_file.amd38,
    amd39_7 LIKE amd_file.amd39,
    amd10_7 LIKE amd_file.amd10,
    amd01a_7 LIKE type_file.chr30,
    amd01_8 LIKE amd_file.amd01,
    amd03_8 LIKE amd_file.amd03,
    amd02_8 LIKE amd_file.amd02,
    amd05_8 LIKE type_file.chr9,
    amd41_8 LIKE amd_file.amd41,
    amd08_8 LIKE amd_file.amd08,
    occ11_8 LIKE occ_file.occ11,
    amf04_8 LIKE amf_file.amf04,
    amf06_8 LIKE amf_file.amf06,
    amf07_8 LIKE amf_file.amf07,
    amd43_8 LIKE type_file.chr9,
    amd35_8 LIKE amd_file.amd35,
    amd35a_8 LIKE amd_file.amd35,
    amd36_8 LIKE amd_file.amd36,
    amd37_8 LIKE amd_file.amd37,
    amd38_8 LIKE amd_file.amd38,
    amd39_8 LIKE amd_file.amd39,
    amd10_8 LIKE amd_file.amd10,
    amd01a_8 LIKE type_file.chr30,
    amd01_9 LIKE amd_file.amd01,
    amd03_9 LIKE amd_file.amd03,
    amd02_9 LIKE amd_file.amd02,
    amd05_9 LIKE type_file.chr9,
    amd41_9 LIKE amd_file.amd41,
    amd08_9 LIKE amd_file.amd08,
    occ11_9 LIKE occ_file.occ11,
    amf04_9 LIKE amf_file.amf04,
    amf06_9 LIKE amf_file.amf06,
    amf07_9 LIKE amf_file.amf07,
    amd43_9 LIKE type_file.chr9,
    amd35_9 LIKE amd_file.amd35,
    amd35a_9 LIKE amd_file.amd35,
    amd36_9 LIKE amd_file.amd36,
    amd37_9 LIKE amd_file.amd37,
    amd38_9 LIKE amd_file.amd38,
    amd39_9 LIKE amd_file.amd39,
    amd10_9 LIKE amd_file.amd10,
    amd01a_9 LIKE type_file.chr30,
    azp03 LIKE azp_file.azp03,
    ooz61 LIKE ooz_file.ooz61,
    total1 LIKE type_file.num20_6,
    total2 LIKE type_file.num20_6,
    total3 LIKE type_file.num20_6,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    ama02 LIKE ama_file.ama02,
    ama07 LIKE ama_file.ama07,
    ama03 LIKE ama_file.ama03,
    ama05 LIKE ama_file.ama05,
    ama11 LIKE ama_file.ama11,
    yy LIKE type_file.chr3,
    mm1 LIKE type_file.chr2,
    mm2 LIKE type_file.chr2,
    date_yy LIKE type_file.chr3,
    date_mm LIKE type_file.chr2,
    date_dd LIKE type_file.chr2,
    l_page LIKE type_file.num5,
    amd35 LIKE amd_file.amd35,
    amd351 LIKE amd_file.amd35,
    s_total1 LIKE type_file.num20_6,
    s_total2 LIKE type_file.num20_6,
    s_total3 LIKE type_file.num20_6
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   #No.TQC-A40101  --Begin
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.ooz61 = ARG_VAL(7)
   LET tm.yy    = ARG_VAL(8)
   LET tm.mm    = ARG_VAL(9)
   LET tm.mm2   = ARG_VAL(10)   #MOD-5B0041
   LET tm.date  = ARG_VAL(11)
   LET tm.a     = ARG_VAL(12)
   LET tm.b     = ARG_VAL(13) #No:8389
   LET tm.c     = ARG_VAL(14) #No.MOD-520086
   LET tm.wc    = ARG_VAL(15)
   LET tm.amd22 = ARG_VAL(16)
   LET tm.d     = ARG_VAL(17)
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
     LET g_sql= "amd01_0.amd_file.amd01, amd03_0.amd_file.amd03,amd02_0.amd_file.amd02,",
     "amd05_0.type_file.chr9, amd41_0.amd_file.amd41,amd08_0.amd_file.amd08,",
     "occ11_0.occ_file.occ11, amf04_0.amf_file.amf04,amf06_0.amf_file.amf06,",
     "amf07_0.amf_file.amf07, amd43_0.type_file.chr9,amd35_0.amd_file.amd35,",
     "amd35a_0.amd_file.amd35,amd36_0.amd_file.amd36,amd37_0.amd_file.amd37,",
     "amd38_0.amd_file.amd38, amd39_0.amd_file.amd39,amd10_0.amd_file.amd10,",
     "amd01a_0.type_file.chr30,",   #MOD-740394 modify
     "amd01_1.amd_file.amd01, amd03_1.amd_file.amd03,amd02_1.amd_file.amd02,",
     "amd05_1.type_file.chr9, amd41_1.amd_file.amd41,amd08_1.amd_file.amd08,",
     "occ11_1.occ_file.occ11, amf04_1.amf_file.amf04,amf06_1.amf_file.amf06,",
     "amf07_1.amf_file.amf07, amd43_1.type_file.chr9,amd35_1.amd_file.amd35,",
     "amd35a_1.amd_file.amd35,amd36_1.amd_file.amd36,amd37_1.amd_file.amd37,",
     "amd38_1.amd_file.amd38, amd39_1.amd_file.amd39,amd10_1.amd_file.amd10,",
     "amd01a_1.type_file.chr30,",   #MOD-740394 modify
     "amd01_2.amd_file.amd01, amd03_2.amd_file.amd03,amd02_2.amd_file.amd02,",
     "amd05_2.type_file.chr9, amd41_2.amd_file.amd41,amd08_2.amd_file.amd08,",
     "occ11_2.occ_file.occ11, amf04_2.amf_file.amf04,amf06_2.amf_file.amf06,",
     "amf07_2.amf_file.amf07, amd43_2.type_file.chr9,amd35_2.amd_file.amd35,",
     "amd35a_2.amd_file.amd35,amd36_2.amd_file.amd36,amd37_2.amd_file.amd37,",
     "amd38_2.amd_file.amd38, amd39_2.amd_file.amd39,amd10_2.amd_file.amd10,",
     "amd01a_2.type_file.chr30,",   #MOD-740394 modify
     "amd01_3.amd_file.amd01, amd03_3.amd_file.amd03,amd02_3.amd_file.amd02,",
     "amd05_3.type_file.chr9, amd41_3.amd_file.amd41,amd08_3.amd_file.amd08,",
     "occ11_3.occ_file.occ11, amf04_3.amf_file.amf04,amf06_3.amf_file.amf06,",
     "amf07_3.amf_file.amf07, amd43_3.type_file.chr9,amd35_3.amd_file.amd35,",
     "amd35a_3.amd_file.amd35,amd36_3.amd_file.amd36,amd37_3.amd_file.amd37,",
     "amd38_3.amd_file.amd38, amd39_3.amd_file.amd39,amd10_3.amd_file.amd10,",
     "amd01a_3.type_file.chr30,",   #MOD-740394 modify
     "amd01_4.amd_file.amd01, amd03_4.amd_file.amd03,amd02_4.amd_file.amd02,",
     "amd05_4.type_file.chr9, amd41_4.amd_file.amd41,amd08_4.amd_file.amd08,",
     "occ11_4.occ_file.occ11, amf04_4.amf_file.amf04,amf06_4.amf_file.amf06,",
     "amf07_4.amf_file.amf07, amd43_4.type_file.chr9,amd35_4.amd_file.amd35,",
     "amd35a_4.amd_file.amd35,amd36_4.amd_file.amd36,amd37_4.amd_file.amd37,",
     "amd38_4.amd_file.amd38, amd39_4.amd_file.amd39,amd10_4.amd_file.amd10,",
     "amd01a_4.type_file.chr30,",   #MOD-740394 modify
     "amd01_5.amd_file.amd01, amd03_5.amd_file.amd03,amd02_5.amd_file.amd02,",
     "amd05_5.type_file.chr9, amd41_5.amd_file.amd41,amd08_5.amd_file.amd08,",
     "occ11_5.occ_file.occ11, amf04_5.amf_file.amf04,amf06_5.amf_file.amf06,",
     "amf07_5.amf_file.amf07, amd43_5.type_file.chr9,amd35_5.amd_file.amd35,",
     "amd35a_5.amd_file.amd35,amd36_5.amd_file.amd36,amd37_5.amd_file.amd37,",
     "amd38_5.amd_file.amd38, amd39_5.amd_file.amd39,amd10_5.amd_file.amd10,",
     "amd01a_5.type_file.chr30,",   #MOD-740394 modify
     "amd01_6.amd_file.amd01, amd03_6.amd_file.amd03,amd02_6.amd_file.amd02,",
     "amd05_6.type_file.chr9, amd41_6.amd_file.amd41,amd08_6.amd_file.amd08,",
     "occ11_6.occ_file.occ11, amf04_6.amf_file.amf04,amf06_6.amf_file.amf06,",
     "amf07_6.amf_file.amf07, amd43_6.type_file.chr9,amd35_6.amd_file.amd35,",
     "amd35a_6.amd_file.amd35,amd36_6.amd_file.amd36,amd37_6.amd_file.amd37,",
     "amd38_6.amd_file.amd38, amd39_6.amd_file.amd39,amd10_6.amd_file.amd10,",
     "amd01a_6.type_file.chr30,",   #MOD-740394 modify
     "amd01_7.amd_file.amd01, amd03_7.amd_file.amd03,amd02_7.amd_file.amd02,",
     "amd05_7.type_file.chr9, amd41_7.amd_file.amd41,amd08_7.amd_file.amd08,",
     "occ11_7.occ_file.occ11, amf04_7.amf_file.amf04,amf06_7.amf_file.amf06,",
     "amf07_7.amf_file.amf07, amd43_7.type_file.chr9,amd35_7.amd_file.amd35,",
     "amd35a_7.amd_file.amd35,amd36_7.amd_file.amd36,amd37_7.amd_file.amd37,",
     "amd38_7.amd_file.amd38, amd39_7.amd_file.amd39,amd10_7.amd_file.amd10,",
     "amd01a_7.type_file.chr30,",   #MOD-740394 modify
     "amd01_8.amd_file.amd01, amd03_8.amd_file.amd03,amd02_8.amd_file.amd02,",
     "amd05_8.type_file.chr9, amd41_8.amd_file.amd41,amd08_8.amd_file.amd08,",
     "occ11_8.occ_file.occ11, amf04_8.amf_file.amf04,amf06_8.amf_file.amf06,",
     "amf07_8.amf_file.amf07, amd43_8.type_file.chr9,amd35_8.amd_file.amd35,",
     "amd35a_8.amd_file.amd35,amd36_8.amd_file.amd36,amd37_8.amd_file.amd37,",
     "amd38_8.amd_file.amd38, amd39_8.amd_file.amd39,amd10_8.amd_file.amd10,",
     "amd01a_8.type_file.chr30,",   #MOD-740394 modify
     "amd01_9.amd_file.amd01, amd03_9.amd_file.amd03,amd02_9.amd_file.amd02,",
     "amd05_9.type_file.chr9, amd41_9.amd_file.amd41,amd08_9.amd_file.amd08,",
     "occ11_9.occ_file.occ11, amf04_9.amf_file.amf04,amf06_9.amf_file.amf06,",
     "amf07_9.amf_file.amf07, amd43_9.type_file.chr9,amd35_9.amd_file.amd35,",
     "amd35a_9.amd_file.amd35,amd36_9.amd_file.amd36,amd37_9.amd_file.amd37,",
     "amd38_9.amd_file.amd38, amd39_9.amd_file.amd39,amd10_9.amd_file.amd10,",
     "amd01a_9.type_file.chr30,",   #MOD-740394 modify
     "azp03.azp_file.azp03,ooz61.ooz_file.ooz61,",
     "total1.type_file.num20_6,total2.type_file.num20_6,total3.type_file.num20_6,",
     "azi04.azi_file.azi04,azi05.azi_file.azi05,ama02.ama_file.ama02,",
     "ama07.ama_file.ama07,ama03.ama_file.ama03,ama05.ama_file.ama05,",
     "ama11.ama_file.ama11,",
     "yy.type_file.chr3,mm1.type_file.chr2,mm2.type_file.chr2,",
     "date_yy.type_file.chr3,date_mm.type_file.chr2,date_dd.type_file.chr2,",
     "l_page.type_file.num5,",   #EXT-7B0152 add
     "amd35.amd_file.amd35,amd351.amd_file.amd35,",      #FUN-830012 add
     "s_total1.type_file.num20_6,s_total2.type_file.num20_6,s_total3.type_file.num20_6"   #TQC-A40101 add
 
   LET l_table = cl_prt_temptable('amdg312',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql= " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              "  VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
              "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
              "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
              "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
              "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
              "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
              "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
              "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
              "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
              "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
              "         ?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"  #EXT-7B0152 add ?  #FUN-830012 add ?,?  #TQC-A40101 add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116

   DROP TABLE amdg312_tmp
   #FUN-B40092------mod------str
#   CREATE TEMP TABLE amdg312_tmp
#     (amd10 LIKE amd_file.amd10,   #MOD-910165 add
#      amd39 LIKE amd_file.amd39,
#      amd35 LIKE amd_file.amd35,
#      amd08 LIKE amd_file.amd08,
#      flag  LIKE type_file.chr1)
   #FUN-B40092------mod------end
   #No.TQC-A40101  --End  
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g312_tm(0,0)
   ELSE
      CALL g312()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g312_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680074 SMALLINT
       l_cmd          LIKE type_file.chr1000,     #No.FUN-680074 VARCHAR(1000)
       l_flag         LIKE type_file.chr1         #No.FUN-680074 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 25
   OPEN WINDOW g312_w AT p_row,p_col
     WITH FORM "amd/42f/amdg312"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   SELECT ooz61 INTO tm.ooz61 FROM ooz_file WHERE ooz00='0'
   LET tm.more = 'N'
   LET tm.yy   =  YEAR(g_today)
   LET tm.mm   = MONTH(g_today)
   LET tm.mm2  = MONTH(g_today)   #MOD-5B0041
   LET tm.date = g_today
   LET tm.a    = 'Y'
   LET tm.b    = '1' #No:8389
   LET tm.c    = 'Y'   #No.MOD-520086
   LET tm.d    = 'N'   #No.MOD-540017
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
 
   WHILE TRUE
#No.FUN-A10098 --------mark start
#      CONSTRUCT BY NAME tm.wc ON azp01
# 
#         BEFORE CONSTRUCT
#             CALL cl_qbe_init()
# 
#         ON ACTION locale
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
# 
#         ON ACTION CONTROLP
#            CASE
#               WHEN INFIELD(azp01)
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.state = "c"
#                    LET g_qryparam.form = "q_azp"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
#                    DISPLAY g_qryparam.multiret TO azp01
#                    NEXT FIELD azp01
#            END CASE
# 
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
# 
#      END CONSTRUCT
#      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.FUN-A10098 --------mark end 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW g312_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
#No.FUN-A10098 --------mark start 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
#No.FUN-A10098 --------mark end 
      INPUT BY NAME tm.ooz61,tm.date,tm.amd22,tm.yy,tm.mm,tm.mm2,tm.a,tm.b,tm.c,    #TQC-5B0201
                     tm.d,tm.more WITHOUT DEFAULTS  #No:8389 No.MOD-520086 No.MOD-540017
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD ooz61
            IF cl_null(tm.ooz61) THEN
               NEXT FIELD ooz61
            END IF
            UPDATE ooz_file SET ooz61 = tm.ooz61 WHERE ooz00 = '0'
 
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               NEXT FIELD mm
            END IF
            IF tm.mm > 12 OR tm.mm < 1 THEN
               NEXT FIELD mm
            END IF
 
        AFTER FIELD mm2
           IF cl_null(tm.mm2) THEN
              NEXT FIELD mm2
           END IF
           IF tm.mm2 > 12 OR tm.mm2 < 1 THEN
              NEXT FIELD mm2
           END IF
           IF tm.mm2 < tm.mm THEN
              NEXT FIELD mm2
           END IF
 
 
         AFTER FIELD date
            IF cl_null(tm.date) THEN
               NEXT FIELD date
            END IF
 
         AFTER FIELD amd22
            IF cl_null(tm.amd22) THEN
               NEXT FIELD amd22
            END IF
            SELECT * INTO g_ama.* FROM ama_file WHERE ama01 = tm.amd22
            IF SQLCA.sqlcode  THEN
               CALL cl_err3("sel","ama_file",tm.amd22,"",SQLCA.sqlcode,"","sel ama",1)   #No.FUN-660093
               NEXT FIELD amd22
            END IF
            LET tm.yy = g_ama.ama08
            LET tm.mm = g_ama.ama09 + 1
            IF tm.mm > 12 THEN
                LET tm.yy = tm.yy + 1
                LET tm.mm = tm.mm - 12
            END IF
            LET tm.mm2 = tm.mm + g_ama.ama10 - 1
            DISPLAY tm.yy TO FORNONLY.yy
            DISPLAY tm.mm TO FORMONLY.mm
            DISPLAY tm.mm2 TO FORMONLY.mm2
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES "[YN]" THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES "[12]" THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES "[YN]" THEN
               NEXT FIELD c
            END IF
 
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES "[YN]" THEN
               NEXT FIELD d
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            LET l_flag = 'N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
            IF cl_null(tm.amd22) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.amd22
            END IF
 
            IF cl_null(tm.ooz61) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.ooz61
            END IF
 
            IF cl_null(tm.yy) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.yy
            END IF
 
            IF cl_null(tm.mm) THEN
               LET l_flag='Y'
               DISPLAY BY NAME tm.mm
            END IF
           IF cl_null(tm.mm2) THEN
              LET l_flag='Y'
              DISPLAY BY NAME tm.mm2
           END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9036',0)
               NEXT FIELD yy
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP
          IF INFIELD(amd22) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_amd"
              LET g_qryparam.state ="i"
              LET g_qryparam.default1 = tm.amd22
              CALL cl_create_qry() RETURNING tm.amd22
              DISPLAY BY NAME tm.amd22
              NEXT FIELD amd22
          END IF
 
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW g312_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='amdg312'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('amdg312','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.ooz61 CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.mm2 CLIPPED,"'",   #MOD-5B0041
                        " '",tm.date CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",     #No:8389
                         " '",tm.c CLIPPED,"'",     #No.MOD-520086
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.amd22 CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('amdg312',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW g312_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL g312()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g312_w
 
END FUNCTION
 
FUNCTION g312()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20) # External(Disk) file name
          l_sql     STRING,     # RDSQL STATEMENT        #No.FUN-680074 VARCHAR(1000)
          l_sql1    STRING,     # RDSQL STATEMENT        #FUN-830012 add
          l_chr     LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_azp03   LIKE azp_file.azp03,
          sr        RECORD
                       amd01     LIKE amd_file.amd01,    #MOD-6C0162
                       amd03     LIKE amd_file.amd03,    #字軌號碼   #No:8028
                       amd02     LIKE amd_file.amd02,    #
                       amd021    LIKE amd_file.amd021,   #FUN-830012 add
                       amd05     LIKE amd_file.amd05,    #開立日期
                       amd41     LIKE amd_file.amd41,    #買受人名稱
                       amd08     LIKE amd_file.amd08,    #未稅金額
                       occ11     LIKE occ_file.occ11,    #買受人統一編號
                       amf04     LIKE amf_file.amf04,    #品號    No:8389
                       amf06     LIKE amf_file.amf06,    #品名
                       amf07     LIKE amf_file.amf07,    #數量
                       amd43     LIKE amd_file.amd43,    #輸出或結匯日期
                       amd35     LIKE amd_file.amd35,    #外銷方式
                       amd35a    LIKE amd_file.amd35,    #外銷方式   #No.MOD-540017
                       amd36     LIKE amd_file.amd36,    #證明文件名稱
                       amd37     LIKE amd_file.amd37,    #證明文件號碼
                       amd38     LIKE amd_file.amd38,    #出口報單類別
                       amd39     LIKE amd_file.amd39,    #出口報單號碼
                       amd10     LIKE amd_file.amd10,    #MOD-5A0280
                       amd01a    LIKE type_file.chr30    #MOD-6C0162  #No.FUN-730010 alter   #MOD-740394 modify
                    END RECORD
   DEFINE l_ooz61   LIKE ooz_file.ooz61 
   DEFINE l_total1  LIKE amd_file.amd08
   DEFINE l_total2  LIKE amd_file.amd08
   DEFINE l_total3  LIKE amd_file.amd08
   DEFINE s_total1  LIKE amd_file.amd08    #TQC-A40101 add
   DEFINE s_total2  LIKE amd_file.amd08    #TQC-A40101 add
   DEFINE s_total3  LIKE amd_file.amd08    #TQC-A40101 add
   DEFINE l_amd35   LIKE amd_file.amd35    #FUN-830012 add
   DEFINE l_amd351  LIKE amd_file.amd35    #FUN-830012 add
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_yy      LIKE type_file.chr3
   DEFINE l_mm1     LIKE type_file.chr2
   DEFINE l_mm2     LIKE type_file.chr2
   DEFINE l_date_y  LIKE type_file.chr3
   DEFINE l_date_m  LIKE type_file.chr2
   DEFINE l_date_d  LIKE type_file.chr2
   DEFINE l_amd05   LIKE type_file.chr9
   DEFINE l_amd43   LIKE type_file.chr9
   DEFINE l_amd10   LIKE amd_file.amd10    #MOD-910165 add
   DEFINE l_amd39   LIKE amd_file.amd39    #MOD-8A0237 add
   DEFINE l_amd08   LIKE amd_file.amd08    #MOD-8A0237 add
   DEFINE l_flag    LIKE type_file.chr1    #MOD-8A0237 add
   DEFINE l_page    LIKE type_file.num5    #EXT-7B0152 add
   DEFINE sr1       ARRAY[10] OF RECORD
                       amd01     LIKE amd_file.amd01,    #MOD-6C0162
                       amd03     LIKE amd_file.amd03,    #字軌號碼   #No:8028
                       amd02     LIKE amd_file.amd02,    #
                       amd05     LIKE type_file.chr9,    #開立日期
                       amd41     LIKE amd_file.amd41,    #買受人名稱
                       amd08     LIKE amd_file.amd08,    #未稅金額
                       occ11     LIKE occ_file.occ11,    #買受人統一編號
                       amf04     LIKE amf_file.amf04,    #品號    No:8389
                       amf06     LIKE amf_file.amf06,    #品名
                       amf07     LIKE amf_file.amf07,    #數量
                       amd43     LIKE type_file.chr9,    #輸出或結匯日期
                       amd35     LIKE amd_file.amd35,    #外銷方式
                       amd35a    LIKE amd_file.amd35,    #外銷方式   #No.MOD-540017
                       amd36     LIKE amd_file.amd36,    #證明文件名稱
                       amd37     LIKE amd_file.amd37,    #證明文件號碼
                       amd38     LIKE amd_file.amd38,    #出口報單類別
                       amd39     LIKE amd_file.amd39,    #出口報單號碼
                       amd10     LIKE amd_file.amd10,    #MOD-5A0280
                       amd01a    LIKE type_file.chr30    #MOD-6C0162  #No.FUN-730010 alter   #MOD-740394 modify
                    END RECORD
   DEFINE sr2       RECORD
                       amd01     LIKE amd_file.amd01,    #
                       amd03     LIKE amd_file.amd03,    #字軌號碼   #No:8028
                       amd02     LIKE amd_file.amd02,    #
                       amd05     LIKE type_file.chr9,    #開立日期
                       amd41     LIKE amd_file.amd41,    #買受人名稱
                       amd08     LIKE amd_file.amd08,    #未稅金額
                       occ11     LIKE occ_file.occ11,    #買受人統一編號
                       amf04     LIKE amf_file.amf04,    #品號    No:8389
                       amf06     LIKE amf_file.amf06,    #品名
                       amf07     LIKE amf_file.amf07,    #數量
                       amd43     LIKE type_file.chr9,    #輸出或結匯日期
                       amd35     LIKE amd_file.amd35,    #外銷方式
                       amd35a    LIKE amd_file.amd35,    #外銷方式   
                       amd36     LIKE amd_file.amd36,    #證明文件名稱
                       amd37     LIKE amd_file.amd37,    #證明文件號碼
                       amd38     LIKE amd_file.amd38,    #出口報單類別
                       amd39     LIKE amd_file.amd39,    #出口報單號碼
                       amd10     LIKE amd_file.amd10,    #
                       amd01a    LIKE type_file.chr30    #
                    END RECORD
 
   DEFINE m_sql     STRING                                                                                                   
   DEFINE n_sql     STRING                                                                                                   
   DEFINE m_cnt     LIKE type_file.num5                                                                                      
   DEFINE m_sr      DYNAMIC ARRAY OF RECORD                                                                                  
            amf04   LIKE amf_file.amf04,                                                                                     
            amf06   LIKE amf_file.amf06                                                                                      
                    END RECORD                                                                                               
   DEFINE l_amd171 LIKE amd_file.amd171 #CHI-910022     
   INITIALIZE sr.*  TO NULL
   INITIALIZE sr2.*  TO NULL   #EXT-7B0152  add
   CALL sr1.clear()
 
   DELETE FROM amdg312_tmp   #MOD-8A0237 add
   CALL cl_del_data(l_table) #No.FUN-730010
 
   SELECT * INTO g_zo.* FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'amdg312'   #No.FUN-730010 
 
#No.FUN-A10098 --------mark start 
#   LET l_sql = "SELECT azp03 FROM azp_file ",
#               " WHERE ",tm.wc CLIPPED,
#               "   AND azp053 != 'N' " #no.7431
# 
#   PREPARE azp_pr FROM l_sql
#   IF SQLCA.SQLCODE THEN
#      CALL cl_err('azp_pr',STATUS,0)
#   END IF
#   DECLARE azp_cur CURSOR FOR azp_pr
#No.FUN-A10098 --------mark end
 
   
   LET l_yy  = tm.yy-1911 USING '&&&'
   LET l_mm1 = tm.mm USING '##'   
   LET l_mm2 = tm.mm2 USING '##'   
   LET l_date_y = YEAR(tm.date)-1911 USING '&&&'
   LET l_date_m = tm.date USING 'MM'
   LET l_date_d = tm.date USING 'DD'
 
#No.FUN-A10098 --------mark start 
#   FOREACH azp_cur INTO l_azp03
#      IF SQLCA.SQLCODE THEN
#         CALL cl_err('foreach',STATUS,1)
#         EXIT FOREACH
#      END IF
#No.FUN-A10098 --------mark end
 
     #當tm.a='N'時,相同報關單金額加總顯示在第一筆,以下相同報關單金額不顯示
      IF tm.a = 'N' THEN
#No.FUN-A10098 --------mark start
#         LET l_sql = "SELECT amd10,amd39,amd35,SUM(amd08)",  #MOD-910165 add amd10
#                     "  FROM ",s_dbstring(l_azp03 CLIPPED),"amd_file,",  #MOD-9C0123 mod
#                     "       ",s_dbstring(l_azp03 CLIPPED),"occ_file ",  #MOD-9C0123 mod
#No.FUN-A10098 --------mark end
         LET l_sql = "SELECT amd10,amd39,amd35,SUM(amd08)  FROM amd_file,occ_file ",   #No.FUN-A10098 --------add
                     " WHERE amd171 LIKE '3%' ",
                     "   AND amd171 <>'33' AND amd171<>'34' ",
                     "   AND amd172= '2' ",
                     "   AND amd30 = 'Y' ",
                     "   AND occ_file.occ01 = amd_file.amd40 ",
                     "   AND (amd174 BETWEEN ",tm.mm," AND ",tm.mm2," )",
                     "   AND amd173='",tm.yy,"'",
                     "   AND amd22 ='",tm.amd22,"'",
                     "   AND amd10 ='2'",
                     " GROUP BY amd10,amd39,amd35"   #MOD-910165 add amd10
         LET l_sql = l_sql," UNION ",
#No.FUN-A10098 --------mark start
#                     "SELECT amd10,amd37,amd35,SUM(amd08)",
#                     "  FROM ",s_dbstring(l_azp03 CLIPPED),"amd_file,",   #MOD-9C0123 mod
#                     "       ",s_dbstring(l_azp03 CLIPPED),"occ_file ",   #MOD-9C0123 mod
#No.FUN-A10098 --------mark end
                     "SELECT amd10,amd37,amd35,SUM(amd08)   FROM amd_file,occ_file ",       #No.FUN-A10098 --------add
                     " WHERE amd171 LIKE '3%' ",
                     "   AND amd171 <>'33' AND amd171<>'34' ",
                     "   AND amd172= '2' ",
                     "   AND amd30 = 'Y' ",
                     "   AND occ_file.occ01 = amd_file.amd40 ",
                     "   AND (amd174 BETWEEN ",tm.mm," AND ",tm.mm2," )",
                     "   AND amd173='",tm.yy,"'",
                     "   AND amd22 ='",tm.amd22,"'",
                     "   AND amd10 ='1'",
                     " GROUP BY amd10,amd37,amd35",
                     " ORDER BY amd10,amd39,amd35"
         PREPARE g312_tmp_prep FROM l_sql
         DECLARE g312_tmp_cs CURSOR FOR g312_tmp_prep
         LET l_flag = 'N'
         FOREACH g312_tmp_cs INTO l_amd10,l_amd39,l_amd35,l_amd08  #MOD-910165 add amd10
            INSERT INTO amdg312_tmp VALUES (l_amd10,l_amd39,l_amd35,l_amd08,l_flag)
         END FOREACH
      END IF
 
      LET l_i = 0      #FUN-730010 更換營運中心后，計數應重新開始
      LET l_page = 1   #EXT-7B0152 add
      LET s_total1 = 0   LET s_total2 = 0   LET s_total3 = 0   #TQC-A40101 add
 
     #先抓amd35='4'的資料出來印
     #當tm.a='Y'時,每一筆銷項明細(amf_file)都應印出,
     #當tm.a='N'時,則只須印一筆銷項明細(產品編號非MISC),數量加總起來顯示
      IF tm.a='Y' THEN   #應列印出貨明細
         LET l_sql = "SELECT amd01,amd03,amd02,amd021,amd05,amd41,amd08,occ11,amf04,amf06,amf07,",    #No:8389   #MOD-6C0162   #FUN-830012 add amd021
                     "       amd43,amd35,'',amd36,amd37,amd38,amd39,amd10,'',amd171 ",   #MOD-5A0280 #CHI-910022 add amd171    
#No.FUN-A10098 --------mark start
#                     "  FROM ",s_dbstring(l_azp03 CLIPPED),"amd_file,",  #MOD-9C0123 mod
#                     "       ",s_dbstring(l_azp03 CLIPPED),"amf_file,",  #MOD-9C0123 mod
#                     "       ",s_dbstring(l_azp03 CLIPPED),"occ_file ",  #MOD-9C0123 mod
#No.FUN-A10098 --------mark end
                     "  FROM amd_file,amf_file,occ_file ",               #No.FUN-A10098 --------add
                     " WHERE amd_file.amd01 = amf_file.amf01 ",
                     "   AND amd_file.amd02 = amf_file.amf02 ",    #MOD-630067
                     "   AND amd_file.amd021= amf_file.amf021 ",   #MOD-630067
                     "   AND amd171 LIKE '3%' ",
                     "   AND amd171 <>'33' AND amd171<>'34' ",
                     "   AND amd172= '2' ",   #010813增
                     "   AND amd30 = 'Y' ",   #MOD-8A0171 add
                     "   AND occ_file.occ01 = amd_file.amd40 ",
                     "   AND (amd174 BETWEEN ",tm.mm," AND ",tm.mm2," )",   #MOD-5B0041
                     "   AND amd173='",tm.yy,"'",     #MOD-730109
                     "   AND amd22 ='",tm.amd22,"' "
      ELSE
         LET l_sql = "SELECT amd01,amd03,amd02,amd021,amd05,amd41,amd08,occ11,'','',0,",    #No:8389   #MOD-6C0162       #FUN-830012 add amd021
                     "       amd43,amd35,'',amd36,amd37,amd38,amd39,amd10,'',amd171 ",   #MOD-5A0280 #CHI-910022 add amd171    
#No.FUN-A10098 --------mark start
#                     "  FROM ",s_dbstring(l_azp03 CLIPPED),"amd_file,",                      #MOD-9C0123 mod
#                     "       ",s_dbstring(l_azp03 CLIPPED),"occ_file ",                      #MOD-9C0123 mod
#No.FUN-A10098 --------mark end
                     "  FROM amd_file,occ_file ",                                    #No.FUN-A10098 --------add
                     " WHERE amd171 LIKE '3%' ",
                     "   AND amd171 <>'33' AND amd171<>'34' ",
                     "   AND amd172= '2' ",   #010813增
                     "   AND amd30 = 'Y' ",   #MOD-8A0171 add
                     "   AND occ_file.occ01 = amd_file.amd40 ",
                     "   AND (amd174 BETWEEN ",tm.mm," AND ",tm.mm2," )",   #MOD-5B0041
                     "   AND amd173='",tm.yy,"'",     #MOD-730109
                     "   AND amd22 ='",tm.amd22,"' "
      END IF
      IF tm.a = 'N' THEN
         LET l_sql1=l_sql CLIPPED,
                    "   AND amd35 ='4'",
                    " ORDER BY amd05,amd03,amd39,amd37,amd01,amd02 "
      ELSE
         LET l_sql1=l_sql CLIPPED,
                    "   AND amd35 ='4'",
                    " ORDER BY amd05,amd03,amd39,amd37,amd01,amd02,amf04 "
      END IF
 
      PREPARE g312_prepare1 FROM l_sql1
 
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
#         EXIT FOREACH                             #No.FUN-A10098 ----mark
      END IF
      DECLARE g312_curs1 CURSOR FOR g312_prepare1
 
     LET m_sql = "SELECT amf04,amf06 FROM amf_file ",
                 " WHERE amf01 = ? AND amf02 = ? AND amf021 = ?",
                 "   AND amf04 = 'MISC'",
                 " ORDER BY amf03"
    PREPARE m_pb_1 FROM m_sql
    IF SQLCA.sqlcode THEN                                                                                                   
       CALL cl_err('prepare:',SQLCA.sqlcode,1)                                                                            
#       EXIT FOREACH                                 #No.FUN-A10098 ----mark 
    END IF 
    DECLARE m_curs_1 CURSOR FOR m_pb_1
   
    LET n_sql = "SELECT amf04,amf06 FROM amf_file ",                                                               
                " WHERE amf01=? AND amf02=? AND amf021=? ",                                                                 
                "   AND amf04 != 'MISC' ",                                                                                  
                " ORDER BY amf04"                                                                                           
    PREPARE n_pb_1 FROM n_sql                                                                                               
    DECLARE n_curs_1 CURSOR FOR n_pb_1    
 
 
      FOREACH g312_curs1 INTO sr.*,l_amd171 #CHI-910022 add amd171    
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         LET sr.amd35a = sr.amd35
         IF tm.d = "Y" AND sr.amd35 = "4" THEN
            LET sr.amd35a = "0"
         END IF
 
         LET sr.amd01a = sr.amd01,sr.amd02
 
        #當tm.a='N'時,則只須印一筆銷項明細(產品編號非MISC),數量加總起來顯示
         IF tm.a='N' THEN   #應列印出貨明細
            SELECT COUNT(*) INTO g_cnt FROM amf_file
             WHERE amf01 = sr.amd01 AND amf02 = sr.amd02 AND amf021 = sr.amd021
               AND amf04 != 'MISC'
            IF g_cnt = 0 then 
               CALL m_sr.clear()
               LET m_cnt = 1 
               FOREACH m_curs_1 USING sr.amd01,sr.amd02,sr.amd021
                                INTO m_sr[m_cnt].*
                 IF STATUS THEN
                    CALL cl_err('foreach:',STATUS,1)
                    EXIT FOREACH
                 END IF         
                 LET sr.amf04 = m_sr[m_cnt].amf04
                 LET sr.amf06 = m_sr[m_cnt].amf06
                 LET m_cnt = m_cnt + 1
                 IF m_cnt = 2  THEN
                    EXIT FOREACH
                 END IF 
               END FOREACH
            ELSE
               CALL m_sr.clear()
               LET m_cnt = 1
               FOREACH n_curs_1 USING sr.amd01,sr.amd02,sr.amd021
                                INTO m_sr[m_cnt].*
                  IF STATUS THEN
                     CALL cl_err('foreach:',STATUS,1)
                     EXIT FOREACH
                  END IF
                  LET sr.amf04 = m_sr[m_cnt].amf04
                  LET sr.amf06 = m_sr[m_cnt].amf06
                  LET m_cnt = m_cnt + 1
                  IF m_cnt = 2 THEN
                     EXIT FOREACH
                  END IF  
               END FOREACH
            END IF          #MOD-930132                 
             SELECT SUM(amf07) INTO sr.amf07
              FROM amf_file
             WHERE amf01=sr.amd01 AND amf02=sr.amd02 AND amf021=sr.amd021
         END IF
 
         LET l_amd35 = '4'
         LET l_amd351= '4'
 
         IF cl_null(sr.amf07) THEN
            LET sr.amf07 = 0
         END IF
 
         IF cl_null(sr.amd08) THEN
            LET sr.amd08 = 0
         END IF
 
         IF tm.a = 'N' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM amdg312_tmp
             WHERE amd39=sr.amd39 AND amd35='4'
               AND amd10='2'  #MOD-910165 add
            IF l_cnt > 0 THEN
               SELECT amd08 INTO sr.amd08 FROM amdg312_tmp
                WHERE amd39=sr.amd39 AND amd35='4' AND flag='N'
                  AND amd10='2'  #MOD-910165 add
               IF STATUS != 100 THEN
                  UPDATE amdg312_tmp SET flag = 'Y'
                   WHERE amd39=sr.amd39 AND amd35='4' AND flag='N'
                     AND amd10='2'  #MOD-910165 add
               ELSE
                  LET sr.amd08 = 0
               END IF
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM amdg312_tmp
             WHERE amd39=sr.amd37 AND amd35='4'
               AND amd10='1'  #MOD-910165 add
            IF l_cnt > 0 THEN
               SELECT amd08 INTO sr.amd08 FROM amdg312_tmp
                WHERE amd39=sr.amd37 AND amd35='4' AND flag='N'
                  AND amd10='1'  #MOD-910165 add
               IF STATUS != 100 THEN
                  UPDATE amdg312_tmp SET flag = 'Y'
                   WHERE amd39=sr.amd37 AND amd35='4' AND flag='N'
                     AND amd10='1'  #MOD-910165 add
               ELSE
                  LET sr.amd08 = 0
               END IF
            END IF
         END IF
 
         IF sr.amd03[1,3] = 'zzz' THEN   #No:8028
            LET sr.amd03 = sr.amd03 CLIPPED,sr.amd02 USING '<<'
         END IF
         IF cl_null(sr.amd03) THEN LET sr.amd03 = ' ' END IF   #MOD-8A0237 add
         IF cl_null(sr.amd39) THEN LET sr.amd39 = ' ' END IF   #MOD-8A0237 add
         IF cl_null(sr.amd37) THEN LET sr.amd37 = ' ' END IF   #MOD-910165 add
 
         #檢查amd03需存在ome_file裡,不存在則報表不顯示amd03
         IF sr.amd03 != ' ' THEN
           #IF g_ooz.ooz64='Y' THEN   #MOD-9C0324 add     #MOD-A50087 mark
            IF g_ooz.ooz64='Y' AND sr.amd021='3' THEN   #MOD-9C0324 add  #MOD-A50087 add
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM ome_file
                WHERE ome01=sr.amd03
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt = 0 THEN
                  LET sr.amd03 = ' '
               END IF
            END IF   #MOD-9C0324 add
         END IF
        
         LET l_amd05 = ''
         LET l_amd43 = ''
         LET l_amd05 = YEAR(sr.amd05)-1911 USING '&&&'  ,'/',
                       MONTH(sr.amd05) USING '&#','/',DAY(sr.amd05) USING '&#'
        #-MOD-B50126-add-
         IF cl_null(sr.amd43) THEN
            LET l_amd43 = YEAR(sr.amd05)-1911 USING '&&&'  ,'/',
                          MONTH(sr.amd05) USING '&#','/',DAY(sr.amd05) USING '&#'
         ELSE
        #-MOD-B50126-end-
            LET l_amd43 = YEAR(sr.amd43)-1911 USING '&&&' ,'/' ,
                          MONTH(sr.amd43) USING '&#','/',DAY(sr.amd43) USING '&#'
         END IF  #MOD-B50126
         IF l_amd171<>'31' THEN LET sr.occ11=' ' END IF #CHI-910022 
         #此處用于將10筆記錄合并成一筆記錄
         LET l_i = l_i + 1
         LET sr1[l_i].amd01  = sr.amd01
         LET sr1[l_i].amd03  = sr.amd03
         LET sr1[l_i].amd02  = sr.amd02
         LET sr1[l_i].amd05  = l_amd05
         LET sr1[l_i].amd41  = sr.amd41
         LET sr1[l_i].occ11  = sr.occ11
         LET sr1[l_i].amf04  = sr.amf04
         LET sr1[l_i].amf06  = sr.amf06
         LET sr1[l_i].amf07  = sr.amf07
         LET sr1[l_i].amd43  = l_amd43
         LET sr1[l_i].amd35  = sr.amd35
         LET sr1[l_i].amd35a = sr.amd35a
         LET sr1[l_i].amd36  = sr.amd36
         LET sr1[l_i].amd37  = sr.amd37
         LET sr1[l_i].amd38  = sr.amd38
         LET sr1[l_i].amd39  = sr.amd39
         LET sr1[l_i].amd10  = sr.amd10
         LET sr1[l_i].amd01a = sr.amd01a
         LET l_amd05 = ''
         LET l_amd43 = ''
         IF tm.a='Y' THEN   #列印出貨明細
            CASE
               WHEN l_i=1
                  IF cl_null(sr2.amd03) AND cl_null(sr2.amd39) AND
                     cl_null(sr2.amd37) AND cl_null(sr2.amd01) AND
                     cl_null(sr2.amd02) THEN
                     LET sr1[l_i].amd08 = sr.amd08
                  ELSE
                     IF sr1[1].amd03=sr2.amd03 AND sr1[1].amd39=sr2.amd39 AND
                        sr1[1].amd37=sr2.amd37 AND sr1[1].amd01=sr2.amd01 AND
                        sr1[1].amd02=sr2.amd02 THEN
                        LET sr1[l_i].amd08 = 0
                     ELSE 
                        LET sr1[l_i].amd08 = sr.amd08
                     END IF
                  END IF
               WHEN l_i=2 OR l_i=3 OR l_i=4 OR l_i=5 OR
                    l_i=6 OR l_i=7 OR l_i=8 OR l_i=9 OR l_i=10
                  IF sr1[l_i].amd03=sr1[l_i-1].amd03 AND
                     sr1[l_i].amd39=sr1[l_i-1].amd39 AND
                     sr1[l_i].amd37=sr1[l_i-1].amd37 AND
                     sr1[l_i].amd01=sr1[l_i-1].amd01 AND
                     sr1[l_i].amd02=sr1[l_i-1].amd02 THEN
                     LET sr1[l_i].amd08 = 0
                  ELSE 
                     LET sr1[l_i].amd08 = sr.amd08
                  END IF
            END CASE 
         END IF
         IF tm.a='N' THEN    #不印出貨明細
            CASE
               WHEN l_i=1
                  IF cl_null(sr2.amd03) AND cl_null(sr2.amd39) AND
                     cl_null(sr2.amd37) THEN
                     LET sr1[l_i].amd08 = sr.amd08
                  ELSE
                     IF sr1[1].amd03=sr2.amd03 AND sr1[1].amd39=sr2.amd39 AND
                        sr1[1].amd37=sr2.amd37 THEN
                        INITIALIZE sr1[l_i].* TO NULL
                        LET l_i = l_i - 1
                        CONTINUE FOREACH
                     ELSE 
                        LET sr1[l_i].amd08 = sr.amd08
                     END IF
                  END IF
               WHEN l_i=2 OR l_i=3 OR l_i=4 OR l_i=5 OR
                    l_i=6 OR l_i=7 OR l_i=8 OR l_i=9 OR l_i=10
                  IF sr1[l_i].amd03=sr1[l_i-1].amd03 AND
                     sr1[l_i].amd39=sr1[l_i-1].amd39 AND
                     sr1[l_i].amd37=sr1[l_i-1].amd37 THEN
                     INITIALIZE sr1[l_i].* TO NULL
                     LET l_i = l_i - 1
                     CONTINUE FOREACH
                  ELSE 
                     LET sr1[l_i].amd08 = sr.amd08
                  END IF
            END CASE 
         END IF
         IF l_i=10 THEN
            LET sr2.amd01  = sr1[l_i].amd01
            LET sr2.amd03  = sr1[l_i].amd03            
            LET sr2.amd02  = sr1[l_i].amd02            
            LET sr2.amd05  = sr1[l_i].amd05           
            LET sr2.amd41  = sr1[l_i].amd41            
            LET sr2.amd08  = sr1[l_i].amd08           
            LET sr2.occ11  = sr1[l_i].occ11            
            LET sr2.amf04  = sr1[l_i].amf04            
            LET sr2.amf06  = sr1[l_i].amf06            
            LET sr2.amf07  = sr1[l_i].amf07            
            LET sr2.amd43  = sr1[l_i].amd43           
            LET sr2.amd35  = sr1[l_i].amd35            
            LET sr2.amd35a = sr1[l_i].amd35a            
            LET sr2.amd36  = sr1[l_i].amd36            
            LET sr2.amd37  = sr1[l_i].amd37            
            LET sr2.amd38  = sr1[l_i].amd38            
            LET sr2.amd39  = sr1[l_i].amd39            
            LET sr2.amd10  = sr1[l_i].amd10            
            LET sr2.amd01a = sr1[l_i].amd01a            
            ###滿10筆資料後合併為一筆插入到報表資料庫中
            LET l_total1 = 0   LET l_total2 = 0
            FOR l_cnt = 1 TO 10
               IF sr1[l_cnt].amd10='1' THEN
                  LET l_total1 = l_total1 + sr1[l_cnt].amd08
               END IF
               IF sr1[l_cnt].amd10='2' THEN
                  LET l_total2 = l_total2 + sr1[l_cnt].amd08
               END IF
            END FOR
            LET l_total3 = l_total1 + l_total2
            LET s_total1 = s_total1 + l_total1   #TQC-A40101 add
            LET s_total2 = s_total2 + l_total2   #TQC-A40101 add
            LET s_total3 = s_total3 + l_total3   #TQC-A40101 add
            EXECUTE insert_prep USING 
               sr1[1].*,sr1[2].*,sr1[3].*,sr1[4].*,sr1[5].*,
               sr1[6].*,sr1[7].*,sr1[8].*,sr1[9].*,sr1[10].*,
               l_azp03,tm.ooz61,l_total1,l_total2,l_total3,
               g_azi04,g_azi05,g_ama.ama02,g_ama.ama07,g_ama.ama03,
               g_ama.ama05,g_ama.ama11,l_yy,l_mm1,l_mm2,l_date_y,
               l_date_m,l_date_d,l_page,l_amd35,l_amd351, #EXT-7B0152 add l_page   #FUN-830012 add l_amd35,l_amd351
               s_total1,s_total2,s_total3   #TQC-A40101 add
            LET l_i = 0
            CALL sr1.clear()
         END IF
         LET l_page=l_page+1   #EXT-7B0152 add
      END FOREACH
      IF l_i>0 THEN
         LET l_total1 = 0
         LET l_total2 = 0
         LET l_total3 = 0
         FOR l_cnt = 1 TO l_i
           IF sr1[l_cnt].amd10='1' THEN
              LET l_total1 = l_total1 + sr1[l_cnt].amd08
           END IF
           IF sr1[l_cnt].amd10='2' THEN
              LET l_total2 = l_total2 + sr1[l_cnt].amd08
           END IF
         END FOR
         LET l_total3 = l_total1 + l_total2
         LET s_total1 = s_total1 + l_total1   #TQC-A40101 add
         LET s_total2 = s_total2 + l_total2   #TQC-A40101 add
         LET s_total3 = s_total3 + l_total3   #TQC-A40101 add
         EXECUTE insert_prep USING 
            sr1[1].*,sr1[2].*,sr1[3].*,sr1[4].*,sr1[5].*,
            sr1[6].*,sr1[7].*,sr1[8].*,sr1[9].*,sr1[10].*,
            l_azp03,tm.ooz61,l_total1,l_total2,l_total3,
            g_azi04,g_azi05,g_ama.ama02,g_ama.ama07,g_ama.ama03,
            g_ama.ama05,g_ama.ama11,l_yy,l_mm1,l_mm2,l_date_y,
            l_date_m,l_date_d,l_page,l_amd35,l_amd351, #EXT-7B0152 add l_page   #FUN-830012 add l_amd35,l_amd351
            s_total1,s_total2,s_total3   #TQC-A40101 add
         LET l_i = 0
         CALL sr1.clear()
      END IF
 
      IF tm.d = 'Y' THEN   #MOD-B50098
         LET s_total1 = 0   LET s_total2 = 0   LET s_total3 = 0   #TQC-A40101 add
      END IF               #MOD-B50098 

     #抓amd35!='4'的資料出來印
      IF tm.a = 'N' THEN
         LET l_sql1=l_sql CLIPPED,
                    "   AND amd35!='4'",
                    " ORDER BY amd10,amd05,amd03,amd39,amd37,amd01,amd02 "
      ELSE
         LET l_sql1=l_sql CLIPPED,
                    "   AND amd35!='4'",
                    " ORDER BY amd10,amd05,amd03,amd39,amd37,amd01,amd02,amf04 "
      END IF
 
      PREPARE g312_prepare2 FROM l_sql1
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1)
#         EXIT FOREACH                                                #No.FUN-A10098 ----mark
      END IF
      DECLARE g312_curs2 CURSOR FOR g312_prepare2
 
     LET m_sql = "SELECT amf04,amf06 FROM amf_file ",
                 " WHERE amf01 = ? AND amf02 = ? AND amf021=? ",
                 "   AND amf04 = 'MISC' ",
                 " ORDER BY amf03"
     PREPARE m_pb_2 FROM m_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
#        EXIT FOREACH                                                   #No.FUN-A10098 ----mark
     END IF
     DECLARE m_curs_2 CURSOR FOR m_pb_2
 
     LET n_sql = "SELECT amf04,amf06 FROM amf_file ",
                 " WHERE amf01 = ? AND amf02 = ? AND amf021 = ? ",
                 "   AND amf04 != 'MISC' ",
                 " ORDER BY amf04"
     PREPARE n_pb_2 FROM n_sql
     DECLARE n_curs_2 CURSOR FOR n_pb_2  
 
      FOREACH g312_curs2 INTO sr.*,l_amd171 #CHI-910022 add amd171        
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach2:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         LET sr.amd35a = sr.amd35
         IF tm.d = "Y" AND sr.amd35 = "4" THEN
            LET sr.amd35a = "0"
         END IF
 
         LET sr.amd01a = sr.amd01,sr.amd02
 
        #當tm.a='N'時,則只須印一筆銷項明細(產品編號非MISC),數量加總起來顯示
         IF tm.a='N' THEN   #應列印出貨明細
            SELECT COUNT(*) INTO g_cnt FROM amf_file
             WHERE amf01 = sr.amd01 AND amf02 = sr.amd02 AND amf021 = sr.amd021
               AND amf04 != 'MISC'
            IF g_cnt = 0 then 
               CALL m_sr.clear()
               LET m_cnt = 1 
               FOREACH m_curs_2 USING sr.amd01,sr.amd02,sr.amd021
                                INTO m_sr[m_cnt].*
                 IF STATUS THEN
                    CALL cl_err('foreach:',STATUS,1)
                    EXIT FOREACH
                 END IF
                 LET sr.amf04 = m_sr[m_cnt].amf04 
                 LET sr.amf06 = m_sr[m_cnt].amf06 
                 LET m_cnt = m_cnt + 1 
                 IF m_cnt = 2 THEN
                    EXIT FOREACH
                 END IF
               END FOREACH
            ELSE 
                CALL m_sr.clear()
                LET m_cnt = 1 
                FOREACH n_curs_2 USING sr.amd01,sr.amd02,sr.amd021 
                                 INTO m_sr[m_cnt].*
                   IF STATUS THEN
                      CALL cl_err('foreach:',STATUS,1)
                      EXIT FOREACH
                   END IF 
                   LET sr.amf04 = m_sr[m_cnt].amf04     
                   LET sr.amf06 = m_sr[m_cnt].amf06     
                   LET m_cnt = m_cnt + 1 
                   IF m_cnt = 2 THEN 
                       EXIT FOREACH
                   END IF 
                END FOREACH
            END IF         #MOD-930132     
            SELECT SUM(amf07) INTO sr.amf07
              FROM amf_file
             WHERE amf01=sr.amd01 AND amf02=sr.amd02 AND amf021=sr.amd021
         END IF
 
         LET l_amd35 = ' '
         IF tm.d='Y' THEN
            LET l_amd351= ' '
         ELSE
            LET l_amd351= '4'
         END IF
 
         IF cl_null(sr.amf07) THEN
            LET sr.amf07 = 0
         END IF
 
         IF cl_null(sr.amd08) THEN
            LET sr.amd08 = 0
         END IF
 
         IF tm.a = 'N' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM amdg312_tmp
             WHERE amd39=sr.amd39 AND amd35!='4'
               AND amd10='2'  #MOD-910165 add
            IF l_cnt > 0 THEN
               SELECT amd08 INTO sr.amd08 FROM amdg312_tmp
                WHERE amd39=sr.amd39 AND amd35!='4' AND flag='N'
                  AND amd10='2'  #MOD-910165 add
               IF STATUS != 100 THEN
                  UPDATE amdg312_tmp SET flag = 'Y'
                   WHERE amd39=sr.amd39 AND amd35!='4' AND flag='N'
                     AND amd10='2'  #MOD-910165 add
               ELSE
                  LET sr.amd08 = 0
               END IF
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM amdg312_tmp
             WHERE amd39=sr.amd37 AND amd35!='4'
               AND amd10='1'  #MOD-910165 add
            IF l_cnt > 0 THEN
               SELECT amd08 INTO sr.amd08 FROM amdg312_tmp
                WHERE amd39=sr.amd37 AND amd35!='4' AND flag='N'
                  AND amd10='1'  #MOD-910165 add
               IF STATUS != 100 THEN
                  UPDATE amdg312_tmp SET flag = 'Y'
                   WHERE amd39=sr.amd37 AND amd35!='4' AND flag='N'
                     AND amd10='1'  #MOD-910165 add
               ELSE
                  LET sr.amd08 = 0
               END IF
            END IF
         END IF
 
         IF sr.amd03[1,3] = 'zzz' THEN   #No:8028
            LET sr.amd03 = sr.amd03 CLIPPED,sr.amd02 USING '<<'
         END IF
         IF cl_null(sr.amd03) THEN LET sr.amd03 = ' ' END IF   #MOD-8A0237 add
         IF cl_null(sr.amd39) THEN LET sr.amd39 = ' ' END IF   #MOD-8A0237 add
         IF cl_null(sr.amd37) THEN LET sr.amd37 = ' ' END IF   #MOD-910165 add
        
 
         #檢查amd03需存在ome_file裡,不存在則報表不顯示amd03
         IF sr.amd03 != ' ' THEN
            IF g_ooz.ooz64='Y' AND sr.amd021='3' THEN          #MOD-A70177
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM ome_file
                WHERE ome01=sr.amd03
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt = 0 THEN
                  LET sr.amd03 = ' '
               END IF
            END IF                                             #MOD-A70177
         END IF
 
         LET l_amd05 = ''
         LET l_amd43 = ''
         LET l_amd05 = YEAR(sr.amd05)-1911 USING '&&&'  ,'/',
                       MONTH(sr.amd05) USING '&#','/',DAY(sr.amd05) USING '&#'
        #-MOD-B50126-add-
         IF cl_null(sr.amd43) THEN
            LET l_amd43 = YEAR(sr.amd05)-1911 USING '&&&'  ,'/',
                          MONTH(sr.amd05) USING '&#','/',DAY(sr.amd05) USING '&#'
         ELSE
        #-MOD-B50126-end-
            LET l_amd43 = YEAR(sr.amd43)-1911 USING '&&&' ,'/' ,
                          MONTH(sr.amd43) USING '&#','/',DAY(sr.amd43) USING '&#'
         END IF   #MOD-B50126
         IF l_amd171<>'31' THEN LET sr.occ11=' ' END IF #CHI-910022      
         #此處用于將10筆記錄合并成一筆記錄
         LET l_i = l_i + 1
         LET sr1[l_i].amd01  = sr.amd01
         LET sr1[l_i].amd03  = sr.amd03
         LET sr1[l_i].amd02  = sr.amd02
         LET sr1[l_i].amd05  = l_amd05
         LET sr1[l_i].amd41  = sr.amd41
         LET sr1[l_i].occ11  = sr.occ11
         LET sr1[l_i].amf04  = sr.amf04
         LET sr1[l_i].amf06  = sr.amf06
         LET sr1[l_i].amf07  = sr.amf07
         LET sr1[l_i].amd43  = l_amd43
         LET sr1[l_i].amd35  = sr.amd35
         LET sr1[l_i].amd35a = sr.amd35a
         LET sr1[l_i].amd36  = sr.amd36
         LET sr1[l_i].amd37  = sr.amd37
         LET sr1[l_i].amd38  = sr.amd38
         LET sr1[l_i].amd39  = sr.amd39
         LET sr1[l_i].amd10  = sr.amd10
         LET sr1[l_i].amd01a = sr.amd01a
         LET l_amd05 = ''
         LET l_amd43 = ''
         IF tm.a='Y' THEN   #列印出貨明細
            CASE
               WHEN l_i=1
                  IF cl_null(sr2.amd03) AND cl_null(sr2.amd39) AND
                     cl_null(sr2.amd37) AND cl_null(sr2.amd01) AND
                     cl_null(sr2.amd02) THEN
                     LET sr1[l_i].amd08 = sr.amd08
                  ELSE
                     IF sr1[1].amd03=sr2.amd03 AND sr1[1].amd39=sr2.amd39 AND
                        sr1[1].amd37=sr2.amd37 AND sr1[1].amd01=sr2.amd01 AND
                        sr1[1].amd02=sr2.amd02 THEN
                        LET sr1[l_i].amd08 = 0
                     ELSE 
                        LET sr1[l_i].amd08 = sr.amd08
                     END IF
                  END IF
               WHEN l_i=2 OR l_i=3 OR l_i=4 OR l_i=5 OR
                    l_i=6 OR l_i=7 OR l_i=8 OR l_i=9 OR l_i=10
                  IF sr1[l_i].amd03=sr1[l_i-1].amd03 AND
                     sr1[l_i].amd39=sr1[l_i-1].amd39 AND
                     sr1[l_i].amd37=sr1[l_i-1].amd37 AND
                     sr1[l_i].amd01=sr1[l_i-1].amd01 AND
                     sr1[l_i].amd02=sr1[l_i-1].amd02 THEN
                     LET sr1[l_i].amd08 = 0
                  ELSE 
                     LET sr1[l_i].amd08 = sr.amd08
                  END IF
            END CASE 
         END IF
         IF tm.a='N' THEN    #不印出貨明細
            CASE
               WHEN l_i=1
                  IF cl_null(sr2.amd03) AND cl_null(sr2.amd39) AND
                     cl_null(sr2.amd37) THEN
                     LET sr1[l_i].amd08 = sr.amd08
                  ELSE
                     IF sr1[1].amd03=sr2.amd03 AND sr1[1].amd39=sr2.amd39 AND
                        sr1[1].amd37=sr2.amd37 THEN
                        INITIALIZE sr1[l_i].* TO NULL
                        LET l_i = l_i - 1
                        CONTINUE FOREACH
                     ELSE 
                        LET sr1[l_i].amd08 = sr.amd08
                     END IF
                  END IF
               WHEN l_i=2 OR l_i=3 OR l_i=4 OR l_i=5 OR
                    l_i=6 OR l_i=7 OR l_i=8 OR l_i=9 OR l_i=10
                  IF sr1[l_i].amd03=sr1[l_i-1].amd03 AND
                     sr1[l_i].amd39=sr1[l_i-1].amd39 AND
                     sr1[l_i].amd37=sr1[l_i-1].amd37 THEN
                     INITIALIZE sr1[l_i].* TO NULL
                     LET l_i = l_i - 1
                     CONTINUE FOREACH
                  ELSE 
                     LET sr1[l_i].amd08 = sr.amd08
                  END IF
            END CASE 
         END IF
         IF l_i=10 THEN
            LET sr2.amd01  = sr1[l_i].amd01
            LET sr2.amd03  = sr1[l_i].amd03            
            LET sr2.amd02  = sr1[l_i].amd02            
            LET sr2.amd05  = sr1[l_i].amd05           
            LET sr2.amd41  = sr1[l_i].amd41            
            LET sr2.amd08  = sr1[l_i].amd08           
            LET sr2.occ11  = sr1[l_i].occ11            
            LET sr2.amf04  = sr1[l_i].amf04            
            LET sr2.amf06  = sr1[l_i].amf06            
            LET sr2.amf07  = sr1[l_i].amf07            
            LET sr2.amd43  = sr1[l_i].amd43           
            LET sr2.amd35  = sr1[l_i].amd35            
            LET sr2.amd35a = sr1[l_i].amd35a            
            LET sr2.amd36  = sr1[l_i].amd36            
            LET sr2.amd37  = sr1[l_i].amd37            
            LET sr2.amd38  = sr1[l_i].amd38            
            LET sr2.amd39  = sr1[l_i].amd39            
            LET sr2.amd10  = sr1[l_i].amd10            
            LET sr2.amd01a = sr1[l_i].amd01a            
            ###滿10筆資料後合併為一筆插入到報表資料庫中
            LET l_total1 = 0   LET l_total2 = 0
            FOR l_cnt = 1 TO 10
               IF sr1[l_cnt].amd10='1' THEN
                  LET l_total1 = l_total1 + sr1[l_cnt].amd08
               END IF
               IF sr1[l_cnt].amd10='2' THEN
                  LET l_total2 = l_total2 + sr1[l_cnt].amd08
               END IF
            END FOR
            LET l_total3 = l_total1 + l_total2
            LET s_total1 = s_total1 + l_total1   #TQC-A40101 add
            LET s_total2 = s_total2 + l_total2   #TQC-A40101 add
            LET s_total3 = s_total3 + l_total3   #TQC-A40101 add
            EXECUTE insert_prep USING 
               sr1[1].*,sr1[2].*,sr1[3].*,sr1[4].*,sr1[5].*,
               sr1[6].*,sr1[7].*,sr1[8].*,sr1[9].*,sr1[10].*,
               l_azp03,tm.ooz61,l_total1,l_total2,l_total3,
               g_azi04,g_azi05,g_ama.ama02,g_ama.ama07,g_ama.ama03,
               g_ama.ama05,g_ama.ama11,l_yy,l_mm1,l_mm2,l_date_y,
               l_date_m,l_date_d,l_page,l_amd35,l_amd351, #EXT-7B0152 add l_page   #FUN-830012 add l_amd35,l_amd351
               s_total1,s_total2,s_total3   #TQC-A40101 add
            LET l_i = 0
            CALL sr1.clear()
         END IF
         LET l_page=l_page+1   #EXT-7B0152 add
      END FOREACH
      IF l_i>0 THEN
         LET l_total1 = 0
         LET l_total2 = 0
         FOR l_cnt = 1 TO l_i
           IF sr1[l_cnt].amd10='1' THEN
              LET l_total1 = l_total1 + sr1[l_cnt].amd08
           END IF
           IF sr1[l_cnt].amd10='2' THEN
              LET l_total2 = l_total2 + sr1[l_cnt].amd08
           END IF
         END FOR
         LET l_total3 = l_total1 + l_total2
         LET s_total1 = s_total1 + l_total1   #TQC-A40101 add
         LET s_total2 = s_total2 + l_total2   #TQC-A40101 add
         LET s_total3 = s_total3 + l_total3   #TQC-A40101 add
         EXECUTE insert_prep USING 
            sr1[1].*,sr1[2].*,sr1[3].*,sr1[4].*,sr1[5].*,
            sr1[6].*,sr1[7].*,sr1[8].*,sr1[9].*,sr1[10].*,
            l_azp03,tm.ooz61,l_total1,l_total2,l_total3,
            g_azi04,g_azi05,g_ama.ama02,g_ama.ama07,g_ama.ama03,
            g_ama.ama05,g_ama.ama11,l_yy,l_mm1,l_mm2,l_date_y,
            l_date_m,l_date_d,l_page,l_amd35,l_amd351, #EXT-7B0152 add l_page  #FUN-830012 add l_amd35,l_amd351
            s_total1,s_total2,s_total3   #TQC-A40101 add
         LET l_i = 0
         CALL sr1.clear()
      END IF
#   END FOREACH                        #No.FUN-A10098 --------mark
 
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'azp01,ooz61,amd22')
           RETURNING tm.wc
   END IF
###GENGRE###   LET g_str = tm.wc,';',tm.a,';',tm.b,';',tm.c,';',tm.d,';',g_zo.zo05  #MOD-9C0123 add zo05
###GENGRE###   CALL cl_prt_cs3('amdg312','amdg312',g_sql,g_str)
    CALL amdg312_grdata()    ###GENGRE###
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
#FUN-B40092

###GENGRE###START
FUNCTION amdg312_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("amdg312")
        IF handler IS NOT NULL THEN
            START REPORT amdg312_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE amdg312_datacur1 CURSOR FROM l_sql
            FOREACH amdg312_datacur1 INTO sr1.*
                OUTPUT TO REPORT amdg312_rep(sr1.*)
            END FOREACH
            FINISH REPORT amdg312_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT amdg312_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_amd08_01 LIKE amd_file.amd08
    DEFINE l_amd08_02 LIKE amd_file.amd08
    DEFINE l_amd08_11 LIKE amd_file.amd08
    DEFINE l_amd08_12 LIKE amd_file.amd08
    DEFINE l_amd08_21 LIKE amd_file.amd08
    DEFINE l_amd08_22 LIKE amd_file.amd08
    DEFINE l_amd08_31 LIKE amd_file.amd08
    DEFINE l_amd08_32 LIKE amd_file.amd08
    DEFINE l_amd08_41 LIKE amd_file.amd08
    DEFINE l_amd08_42 LIKE amd_file.amd08
    DEFINE l_amd08_51 LIKE amd_file.amd08
    DEFINE l_amd08_52 LIKE amd_file.amd08
    DEFINE l_amd08_61 LIKE amd_file.amd08
    DEFINE l_amd08_62 LIKE amd_file.amd08
    DEFINE l_amd08_71 LIKE amd_file.amd08
    DEFINE l_amd08_72 LIKE amd_file.amd08
    DEFINE l_amd08_81 LIKE amd_file.amd08
    DEFINE l_amd08_82 LIKE amd_file.amd08
    DEFINE l_amd08_91 LIKE amd_file.amd08
    DEFINE l_amd08_92 LIKE amd_file.amd08
    DEFINE l_amd38_0  LIKE amd_file.amd38
    DEFINE l_amd38_1  LIKE amd_file.amd38
    DEFINE l_amd38_2  LIKE amd_file.amd38
    DEFINE l_amd38_3  LIKE amd_file.amd38
    DEFINE l_amd38_4  LIKE amd_file.amd38
    DEFINE l_amd38_5  LIKE amd_file.amd38
    DEFINE l_amd38_6  LIKE amd_file.amd38
    DEFINE l_amd38_7  LIKE amd_file.amd38
    DEFINE l_amd38_8  LIKE amd_file.amd38
    DEFINE l_amd38_9  LIKE amd_file.amd38
    DEFINE l_amd39_0  LIKE amd_file.amd39
    DEFINE l_amd39_1  LIKE amd_file.amd39
    DEFINE l_amd39_2  LIKE amd_file.amd39
    DEFINE l_amd39_3  LIKE amd_file.amd39
    DEFINE l_amd39_4  LIKE amd_file.amd39
    DEFINE l_amd39_5  LIKE amd_file.amd39
    DEFINE l_amd39_6  LIKE amd_file.amd39
    DEFINE l_amd39_7  LIKE amd_file.amd39
    DEFINE l_amd39_8  LIKE amd_file.amd39
    DEFINE l_amd39_9  LIKE amd_file.amd39
    DEFINE l_amf06_amf04_0  STRING
    DEFINE l_amf06_amf04_1  STRING
    DEFINE l_amf06_amf04_2  STRING
    DEFINE l_amf06_amf04_3  STRING
    DEFINE l_amf06_amf04_4  STRING
    DEFINE l_amf06_amf04_5  STRING
    DEFINE l_amf06_amf04_6  STRING
    DEFINE l_amf06_amf04_7  STRING
    DEFINE l_amf06_amf04_8  STRING
    DEFINE l_amf06_amf04_9  STRING
    DEFINE l_option         STRING
    DEFINE l_mm1_mm2        STRING
    #FUN-B40092------add------end 

    
    ORDER EXTERNAL BY sr1.amd01_0
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.amd01_0
            LET l_lineno = 0

        
        ON EVERY ROW
            #FUN-B40092------add------str
            IF sr1.amd10_0 = '1' THEN
               LET l_amd08_01 = sr1.amd08_0
            END IF
            PRINTX l_amd08_01

            IF tm.c = 'Y' AND sr1.amd10_0 = '2' THEN
               LET l_amd08_02 = sr1.amd08_0
            END IF
            PRINTX l_amd08_02

            IF sr1.amd10_1 = '1' THEN
               LET l_amd08_11 = sr1.amd08_1
            END IF
            PRINTX l_amd08_11

            IF tm.c = 'Y' AND sr1.amd10_1 = '2' THEN
               LET l_amd08_12 = sr1.amd08_1
            END IF
            PRINTX l_amd08_12

            IF sr1.amd10_2 = '1' THEN
               LET l_amd08_21 = sr1.amd08_2
            END IF
            PRINTX l_amd08_21

            IF tm.c = 'Y' AND sr1.amd10_2 = '2' THEN
               LET l_amd08_22 = sr1.amd08_2
            END IF
            PRINTX l_amd08_22

            IF sr1.amd10_3 = '1' THEN
               LET l_amd08_31 = sr1.amd08_3
            END IF
            PRINTX l_amd08_31

            IF tm.c = 'Y' AND sr1.amd10_3 = '2' THEN
               LET l_amd08_32 = sr1.amd08_3
            END IF
            PRINTX l_amd08_32

            IF sr1.amd10_4 = '1' THEN
               LET l_amd08_41 = sr1.amd08_4
            END IF
            PRINTX l_amd08_41

            IF tm.c = 'Y' AND sr1.amd10_4 = '2' THEN
               LET l_amd08_42 = sr1.amd08_4
            END IF
            PRINTX l_amd08_42

            IF sr1.amd10_5 = '1' THEN
               LET l_amd08_51 = sr1.amd08_5
            END IF
            PRINTX l_amd08_51

            IF tm.c = 'Y' AND sr1.amd10_5 = '2' THEN
               LET l_amd08_52 = sr1.amd08_5
            END IF
            PRINTX l_amd08_52

            IF sr1.amd10_6 = '1' THEN
               LET l_amd08_61 = sr1.amd08_6
            END IF
            PRINTX l_amd08_61

            IF tm.c = 'Y' AND sr1.amd10_6 = '2' THEN
               LET l_amd08_62 = sr1.amd08_6
            END IF
            PRINTX l_amd08_62

            IF sr1.amd10_7 = '1' THEN
               LET l_amd08_71 = sr1.amd08_7
            END IF
            PRINTX l_amd08_71

            IF tm.c = 'Y' AND sr1.amd10_7 = '2' THEN
               LET l_amd08_72 = sr1.amd08_7
            END IF
            PRINTX l_amd08_72

            IF sr1.amd10_8 = '1' THEN
               LET l_amd08_81 = sr1.amd08_8
            END IF
            PRINTX l_amd08_81

            IF tm.c = 'Y' AND sr1.amd10_8 = '2' THEN
               LET l_amd08_82 = sr1.amd08_8
            END IF
            PRINTX l_amd08_82

            IF sr1.amd10_9 = '1' THEN
               LET l_amd08_91 = sr1.amd08_9
            END IF
            PRINTX l_amd08_91

            IF tm.c = 'Y' AND sr1.amd10_9 = '2' THEN
               LET l_amd08_92 = sr1.amd08_9
            END IF
            PRINTX l_amd08_92

            IF tm.c = 'Y' AND sr1.amd10_0 = '2' THEN
               LET l_amd38_0 = sr1.amd38_0
            END IF
            PRINTX l_amd38_0

            IF tm.c = 'Y' AND sr1.amd10_1 = '2' THEN
               LET l_amd38_1 = sr1.amd38_1
            END IF
            PRINTX l_amd38_1

            IF tm.c = 'Y' AND sr1.amd10_2 = '2' THEN
               LET l_amd38_2 = sr1.amd38_2
            END IF
            PRINTX l_amd38_2

            IF tm.c = 'Y' AND sr1.amd10_3 = '2' THEN
               LET l_amd38_3 = sr1.amd38_3
            END IF
            PRINTX l_amd38_3 

            IF tm.c = 'Y' AND sr1.amd10_4 = '2' THEN
               LET l_amd38_4 = sr1.amd38_4
            END IF
            PRINTX l_amd38_4

            IF tm.c = 'Y' AND sr1.amd10_5 = '2' THEN
               LET l_amd38_5 = sr1.amd38_5
            END IF
            PRINTX l_amd38_5

            IF tm.c = 'Y' AND sr1.amd10_6 = '2' THEN
               LET l_amd38_6 = sr1.amd38_6
            END IF
            PRINTX l_amd38_6

            IF tm.c = 'Y' AND sr1.amd10_7 = '2' THEN
               LET l_amd38_7 = sr1.amd38_7
            END IF
            PRINTX l_amd38_7

            IF tm.c = 'Y' AND sr1.amd10_8 = '2' THEN
               LET l_amd38_8 = sr1.amd38_8
            END IF
            PRINTX l_amd38_8

            IF tm.c = 'Y' AND sr1.amd10_9 = '2' THEN
               LET l_amd38_9 = sr1.amd38_9
            END IF
            PRINTX l_amd38_9

            IF tm.c = 'Y' AND sr1.amd10_0 = '2' THEN
               LET l_amd39_0 = sr1.amd39_0
            END IF
            PRINTX l_amd39_0

            IF tm.c = 'Y' AND sr1.amd10_1 = '2' THEN
               LET l_amd39_1 = sr1.amd39_1
            END IF
            PRINTX l_amd39_1

            IF tm.c = 'Y' AND sr1.amd10_2 = '2' THEN
               LET l_amd39_2 = sr1.amd39_2
            END IF
            PRINTX l_amd39_2
            
            IF tm.c = 'Y' AND sr1.amd10_3 = '2' THEN
               LET l_amd39_3 = sr1.amd39_3
            END IF
            PRINTX l_amd39_3

            IF tm.c = 'Y' AND sr1.amd10_4 = '2' THEN
               LET l_amd39_4 = sr1.amd39_4
            END IF
            PRINTX l_amd39_4
            
            IF tm.c = 'Y' AND sr1.amd10_5 = '2' THEN
               LET l_amd39_5 = sr1.amd39_5
            END IF
            PRINTX l_amd39_5
            
            IF tm.c = 'Y' AND sr1.amd10_6 = '2' THEN
               LET l_amd39_6 = sr1.amd39_6
            END IF
            PRINTX l_amd39_6

            IF tm.c = 'Y' AND sr1.amd10_7 = '2' THEN
               LET l_amd39_7 = sr1.amd39_7
            END IF
            PRINTX l_amd39_7

            IF tm.c = 'Y' AND sr1.amd10_8 = '2' THEN
               LET l_amd39_8 = sr1.amd39_8
            END IF
            PRINTX l_amd39_8

            IF tm.c = 'Y' AND sr1.amd10_9 = '2' THEN
               LET l_amd39_9 = sr1.amd39_9
            END IF
            PRINTX l_amd39_9

            LET l_option = cl_gr_getmsg("gre-087",g_lang,'0')
 
            IF cl_null(sr1.amf06_0) THEN
               LET l_amf06_amf04_0 = sr1.amf06_0,l_option
            ELSE
               IF cl_null(sr1.amf04_0) THEN
                  LET l_amf06_amf04_0 = sr1.amf04_0,l_option
               END IF
            END IF
            PRINTX l_amf06_amf04_0
            
            IF cl_null(sr1.amf06_1) THEN
               LET l_amf06_amf04_1 = sr1.amf06_1,l_option
            ELSE
               IF cl_null(sr1.amf04_1) THEN
                  LET l_amf06_amf04_1 = sr1.amf04_1,l_option
               END IF
            END IF
            PRINTX l_amf06_amf04_1


            IF cl_null(sr1.amf06_2) THEN
               LET l_amf06_amf04_2 = sr1.amf06_2,l_option
            ELSE
               IF cl_null(sr1.amf04_2) THEN
                  LET l_amf06_amf04_2 = sr1.amf04_2,l_option
               END IF
            END IF
            PRINTX l_amf06_amf04_2

            IF cl_null(sr1.amf06_3) THEN
               LET l_amf06_amf04_3 = sr1.amf06_3,l_option
            ELSE
               IF cl_null(sr1.amf04_3) THEN
                  LET l_amf06_amf04_3 = sr1.amf04_3,l_option
               END IF
            END IF
            PRINTX l_amf06_amf04_3

            
            IF cl_null(sr1.amf06_4) THEN
               LET l_amf06_amf04_4 = sr1.amf06_4,l_option
            ELSE
               IF cl_null(sr1.amf04_4) THEN
                  LET l_amf06_amf04_4 = sr1.amf04_4,l_option
               END IF
            END IF
            PRINTX l_amf06_amf04_4

            IF cl_null(sr1.amf06_5) THEN
               LET l_amf06_amf04_5 = sr1.amf06_5,l_option
            ELSE
               IF cl_null(sr1.amf04_5) THEN
                  LET l_amf06_amf04_5 = sr1.amf04_5,l_option
               END IF
            END IF
            PRINTX l_amf06_amf04_5


            IF cl_null(sr1.amf06_6) THEN
               LET l_amf06_amf04_6 = sr1.amf06_6,l_option
            ELSE
               IF cl_null(sr1.amf04_6) THEN
                  LET l_amf06_amf04_6 = sr1.amf04_6,l_option
               END IF
            END IF
            PRINTX l_amf06_amf04_6

            IF cl_null(sr1.amf06_7) THEN
               LET l_amf06_amf04_7 = sr1.amf06_7,l_option
            ELSE
               IF cl_null(sr1.amf04_7) THEN
                  LET l_amf06_amf04_7 = sr1.amf04_7,l_option
               END IF
            END IF
            PRINTX l_amf06_amf04_7

            IF cl_null(sr1.amf06_8) THEN
               LET l_amf06_amf04_8 = sr1.amf06_8,l_option
            ELSE
               IF cl_null(sr1.amf04_8) THEN
                  LET l_amf06_amf04_8 = sr1.amf04_8,l_option
               END IF
            END IF
            PRINTX l_amf06_amf04_8

            IF cl_null(sr1.amf06_9) THEN
               LET l_amf06_amf04_9 = sr1.amf06_9,l_option
            ELSE
               IF cl_null(sr1.amf04_9) THEN
                  LET l_amf06_amf04_9 = sr1.amf04_9,l_option
               END IF
            END IF
            PRINTX l_amf06_amf04_9

            LET l_mm1_mm2 = sr1.mm1,'-',sr1.mm2
            PRINTX l_mm1_mm2

            #FUN-B40092------add------end
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.amd01_0

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-B80050
