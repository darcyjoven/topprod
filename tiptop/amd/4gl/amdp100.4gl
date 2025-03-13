# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amdp100.4gl
# Descriptions...: 進銷項媒體產生作業
# Date & Author..: 95/02/07 By Danny
# Modify ........: 01/05/25 by plum 增加一選擇要不要截取零稅率資料
# Modify.........: No:9021 04/01/06 By Kitty 格式36發票號碼不可以有值
# Modify.........: No.FUN-4C0022 04/12/03 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.MOD-560233 05/06/29 By day  報表檔名固定，g_page_line取法改變
# Modify.........: No.MOD-570163 05/07/08 By Smapmin 將 sr1.* record 中的 amd175 type改為 integer/number(10,0)
# Modify.........: No.MOD-580386 05/09/02 By Smapmin 產生進貨折讓的媒體時，折讓的發票，產生的資料年月，
#                                                    應是資料年月，而不是發票年月
# Modify.........: No.MOD-5A0281 05/10/19 By Smapmin 調整SQL語法
# Modify.........: NO.TQC-5B0201 05/12/13 BY yiting 年月輸入模式統一為：年/起始月份-截止月份
# Modify.........: No.MOD-610045 06/01/12 By Smapmin修復MOD-570163的問題
# Modify.........: No.FUN-570123 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.MOD-670019 06/07/05 By Smapmin 增加進項不得扣抵轉入媒體檔的CHECKBOX
# Modify.........: No.FUN-680074 06/08/23 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent g_time轉g_time
# Modify.........: No.FUN-690020 06/10/27 By Nicola 加入TET,T01,T02等格式
# Modify.........: No.MOD-6B0041 06/11/07 By Nicola 數字轉換時，判斷取10碼或12碼
# Modify.........: No.MOD-6B0033 06/11/10 By Smapmin 產生T02時，申報年月應該依起迄年月為主(amd26,amd27)
# Modify.........: No.MOD-6B0059 06/11/16 By Smapmin 依條件區間產生一筆資料
# Modify.........: No.FUN-6B0056 06/11/16 By Smapmin 當執行產生完 401媒體資料後,請自動新增ㄧ筆 amdi002 下期申報之用,
#                                                    並帶將本期的累積留抵稅額存放於上期累積留抵稅額欄位中
# Modify.........: No.TQC-6B0134 06/11/27 By Smapmin 所屬年月改抓畫面條件的截止年月
# Modify.........: No.FUN-6B0062 06/11/27 By Smapmin 產生的檔案下載至客戶端
# Modify.........: No.MOD-690113 06/12/14 By Mandy 格式為22 或 格式為31而無買受人統編者(即個人),amd07,amd08的值
# Modify.........: No.MOD-710084 07/01/15 By Smapmin 修改得退稅限額計算方式
# Modify.........: No.MOD-710100 07/01/16 By Dido 1.tm.eyy 應抓取 tm.byy而不是 g_today
#                                                 2.a113 比照 g_tot113(amdr401)取位
#                                                 3.修正 MOD-690113 發現 amd171 = '22' 進項不可再重新 set amd07/amd08
# Modify.........: No.MOD-730074 07/03/19 By Smapmin 修改產生T02抓取條件
# Modify.........: No.MOD-730128 07/03/27 By Smapmin 修改計算發票份數的where條件
# Modify.........: No.MOD-750122 07/05/25 By Smapmin 將作廢資料也抓進來
# Modify.........: No.CHI-760026 07/06/25 By Smapmin 空白發票也要產生
# Modify.........: No.TQC-760182 07/06/26 By chenl   申報部門增加開窗功能。
# Modify.........: No.CHI-760025 07/07/04 By Smapmin 合併稅籍列印
# Modify.........: No.MOD-770088 07/07/18 By Smapmin 修改列印空白發票的條件
# Modify.........: No.MOD-770085 07/07/19 By Smapmin 修改變數定義
# Modify.........: No.MOD-7B0153 07/11/16 By Smapmin  p100_4 中增加判斷若格式為 36 者,amd03 要為空白
# Modify.........: No.FUN-7B0132 07/11/30 By Nicola 稅額提示訊息
# Modify.........: No.MOD-820013 08/02/12 By Smapmin 已申報年度為空時,Default該年度
# Modify.........: No.CHI-850019 08/05/13 By Sarah CALL cl_addrcr(l_name)增加換行符號
# Modify.........: No.FUN-770040 08/06/04 By Smapmin 格式22/發票聯數2時,重新計算amd08,amd07
# Modify.........: No.MOD-910171 09/01/15 By Sarah 空白發票資料的sr1.amd05應給予截止月份最後一天
# Modify.........: No.MOD-920197 09/02/16 By Smapmin 計算發票份數時,要將作廢的排除
# Modify.........: No.MOD-930122 09/03/11 By lilingyu  增加判斷amd04在不同情況下的輸出格式
# Modify.........: No.CHI-8C0011 09/03/11 By Sarah 進項資料稅別26,27格式於後續產生TXT格式時,各彙總成單一筆資料
# Modify.........: No.MOD-930145 09/03/12 By lilingyu a113 的值應考慮a111 < 0時才計算
# Modify.........: No.CHI-910039 09/06/05 By Sarah 22二聯式收銀機+22載有稅額稅金的計算方式不符法規
# Modify.........: NO.FUN-950013 09/06/24 By hongmei根據年月列印不同格式的報表
# Modify.........: No.MOD-970006 09/07/01 By Sarah 產生之零稅率清單格式有誤,同一張報單有多筆出貨時,金額應只呈現在其中一筆,其他筆空白
# Modify.........: No.MOD-970100 09/07/10 By Sarah 修正MOD-970006,造成非經海關的銷售金額異常
# Modify.........: No.MOD-970181 09/07/20 By mike "   AND oom02 =",tm.bmm,                                                          
#                                                 "   AND oom021=",tm.emm,                                                          
#                                                 請改成                                                                            
#                                                 "   AND oom02 >=",tm.bmm,                                                         
#                                                 "   AND oom021<=",tm.emm, 
# Modify.........: NO.CHI-8B0032 09/08/06 By hongmei增加 a26土地金額，a27固定資產金額的計算
# Modify.........: No.TQC-980112 09/08/17 By Sarah 22/27格式的計算方式不符法規,需用含稅金額倒推算出未稅金額與稅額
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980162 09/08/20 By sabrina 電子計算機統一發票(不論二聯式或三聯式)的格式一律是31。
#                                                    不應該是用聯數判斷，而應該是用amdi010發票字軌維護的格式。
#                                                    空白發票若是連號，改為產生一筆，給發票號碼起訖
# Modify.........: No.MOD-980183 09/08/21 By Sarah 1.產生tet檔時,21/26類應計算入a30與a31,22/27類應計算入a38與a39
#                                                  2.32/22/27格式稅額應用倒推後算出的未稅總金額*0.05計算
# Modify.........: No.MOD-980270 09/09/02 By Sarah p100_2(),調整進項合計計算方式
# Modify.........: No.FUN-970108 09/08/21 By hongmei 在p100_1()中加入抓取oom_file的條件 
# Modify.........: No.MOD-970137 09/10/10 By baofei 修改l_y1和l_m1抓不到值    
# Modify.........: NO.MOD-9A0082 09/10/12 By mike 在OUTPUT TO REPORT p100_rep2(sr2.*)后,当sr2.ama15='2'才将tmp.a01~tmp.a115清为0    
# Modify.........: NO.CHI-950033 09/10/29  BY yiting p100_2()產出格式修正
# Modify.........: NO.FUN-980024 09/10/29 BY yiting add ama21,ama22,原本的ama19拆為三個欄位來組
# Modify.........: NO.FUN-990034 09/10/29 BY yiting 總公司彙總總繳時產出TET檔，一個檔案內共有二筆申報資料
#                                1.第一筆需為總繳代號為'2'，第二筆為'1'，在p100_rep2()中的ORDER BY 會影響到此總繳代號順序 ，要修正
#                                2.第一筆申報代號第25碼固定為'1'，第二筆申報代號25碼固定為'5'
# Modify.........: NO.FUN-990021 09/10/30 BY Yiting add ama24
# Modify.........: NO.FUN-990057 09/10/30 BY yiting 進銷資料併總公司合併申報時，申報營業人稅籍編號及銷售人統一編號應依分支機構資料做產出
# Modify.........: NO.FUN-980090 09/10/30 BY yiting  1.輸入部門後檢核總繳代號，為0時表代為總公司申報，產生的TET有二筆資料
#                                                    2.將"稅籍合併申報"改為 "進銷資料併總公司合併申報"，只有選擇TXT檔時才能勾選
#                                                    3.勾選"進銷資料併總公司合併申報"者，輸出的TXT檔為相同"總機構統編"一起產出
# Modify.........: No:MOD-9B0057 09/11/10 By Sarah PRINT變數後都要加上CLIPPED
# Modify.........: No:MOD-9B0153 09/11/24 By Sarah 抓取銷項空白發票的SQL不過濾amb04條件,寫入amd171時將抓到的l_amb04做轉換21->31,22->32,25->35
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Mddify.........: No:MOD-A10085 10/01/15 By Sarah 修正TQC-980112與MOD-980270程式碼放置位置錯誤造成計算錯誤
# Modify.........: No:FUN-A10039 10/01/18 By jan amd172='D'-->amd172='F'
# Modify.........: NO.MOD-A30019 10/03/04 BY sabrina 申報檢核異常
# Modify.........: No.FUN-A30038 09/03/09 By lutingting windows改用zhcode方式來進行轉碼
# Modify.........: NO.MOD-A30081 10/03/12 BY sabrina 格式35應同格式31 
# Modify.........: No:MOD-A40155 10/04/26 By sabrina 一張出口報單會有多筆出貨單,在amdp100印t02時，僅印一筆統計即可，可不用印到明細
# Modify.........: No:CHI-A40039 10/04/28 By Summer 調整進項合計 格式22和27依發票聯數來決定是採內含稅或是分稅垂直
# Modify.........: No:MOD-A70013 10/07/02 By Dido 若空白發票剩一張,應與一般發票資料相同 
# Modify.........: No:MOD-A70103 10/07/15 By Dido 銷售固定資產金額應僅於 403 報表使用 
# Modify.........: No:MOD-A70149 10/07/19 By Dido 403 報表 a25,a50,a51 計算調整 
# Modify.........: NO.MOD-A40070 10/08/03 BY sabrina FUN-980090追版不完全 
# Modify.........: No:MOD-A80115 10/08/13 By Dido 變數預設值;稅額取整數位 
# Modify.........: No:MOD-A80244 10/09/01 By Dido T02 結匯日期先判斷 amd43 是否有值若沒有才抓 amd05 
# Modify.........: No:MOD-A90042 10/09/07 By Dido T02 增加 ooz64 判斷是否彙總 
# Modify.........: No:MOD-B10199 11/01/25 By Dido 調整銷項二聯式稅額計算公式
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2) 
# Modify.........: NO.FUN-B40063 11/04/21 BY yiting 1.增加tm.type,tm.deduct,tm.rep輸入欄位 2.tm.fil增加第三選項(T01) 3.選擇直扣法時，TET產出資料代號51,代號76應以直扣法ama97,ama103寫入
# Modify.........: No:MOD-B50169 11/05/20 By Dido 無論是否 aza94 為何,都需要串 oom13
# Modify.........: No:MOD-B60026 11/06/08 By Dido a50左邊補零微調 
# Modify.........: No:MOD-B70156 11/07/15 By Polly 針對MOD-A40155調整，改為判斷amd03方式
# Modify.........: No:MOD-B70184 11/07/19 By Polly 1.調整tmp.a24累加l_amd08時，在l_amd171=33或34時，應將 l_amd08 * -1
#                                                  2.計算tmp.a51前先將tmp.a50去尾調整 
# Modify.........: No:FUN-B80160 11/08/24 By huangtao 修改當畫面選類型格式為 '1:TXT:營業人進、銷項資料檔', 彙加註記為 'A' 時, 產出的媒體申報檔一併產出發票訖號.
# Modify.........: No.MOD-B90114 11/09/15 By Polly 修正匯出T02檔時，取得資料時未針對申報部門(amd22)篩選
# Modify.........: No.CHI-B90005 11/09/09 By Polly 自行在amdi100新增26/27資料時，應抓取amd04為發票張數，再加上匯入的資料筆數
# Modify.........: No.MOD-B90193 11/09/23 By Polly 調整p1004_prepare ORDER BY欄位
# Modify.........: No.MOD-B90279 11/10/05 By Polly TXT檔判斷銷項外銷零稅率是否需合併一筆或拆多筆，改用T02 中用ooz64判斷
# Modify.........: No.FUN-BA0021 11/10/21 By Belle 原來寫入ama_file的ama25之後的資料改為amk04之後
# Modify.........: No.MOD-BB0213 11/11/17 By Polly 修正31格式買受人統編為空值改取amd04
# Modify.........: No.MOD-BB0216 11/11/18 By Polly 針對MOD-B90114調整JOIN table
# Modify.........: No.MOD-BC0301 12/01/02 By Polly 修正110小計計算的判斷
# Modify.........: No.MOD-C10106 12/01/12 By Polly 抓取ame10的值給予a105
# Modify.........: No.MOD-C10166 12/01/30 By Polly 增加判斷，調整a51、a106、a103、a76、a74給予的值
# Modify.........: No.MOD-C10220 12/02/02 By Polly 調整l_idx欄位型態
# Modify.........: No.TQC-C20389 12/02/22 By minpp radio選項值得改變會影響媒體檔案欄位是否可輸，將這個控制寫在on change中
# Modify.........: No.MOD-C20129 12/02/17 By Polly a106是共用401、403格式，當為401時將a103、a104、a105歸零
# Modify.........: No.MOD-C40156 12/04/20 By Elise FUNCTION p100_1(→p100_amb_pre的sql串查AND amb07 <= tm.emm會查不到amdi010的資料
# Modify.........: No.MOD-C50112 12/05/18 By Polly 格式為22且發票聯數為二聯式收銀機發票稅額也應為0
# Modify.........: No.MOD-C50113 12/05/18 By Polly 無法查詢單期的發票字軌，調整修正起迄日期抓取
# Modify.........: No.MOD-C60135 12/06/14 By Polly sql抓取欄位有誤，將ma21改為ama21
# Modify.........: No.MOD-D10082 13/01/18 By apo p100_curs1_2與p100_curs1_3增加amd021為應付(5)的條件

IMPORT os
 
IMPORT os DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
         type   LIKE type_file.chr1,          #FUN-B40063
         upd    LIKE type_file.chr1,          #FUN-B40063
         deduct LIKE type_file.chr1,          #FUN-B40063
         rep1   LIKE ama_file.ama02,          #FUN-B40063
         wc     LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(1000)
         a      LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
         b      LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
         d      LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
         e      LIKE type_file.chr1,          #CHI-760025
         ama01  LIKE ama_file.ama01,
         rep    LIKE ama_file.ama02,        #No.FUN-680074 VARCHAR(08)
         fil    LIKE type_file.chr1,   #No.FUN-690020
         byy    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
         bmm    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
         eyy    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
         emm    LIKE type_file.num5           #No.FUN-680074 SMALLINT
           END RECORD,
         g_ama02     LIKE ama_file.ama02,
         g_ama03     LIKE ama_file.ama03,
         g_ama05     LIKE ama_file.ama05,
         g_ama08     LIKE ama_file.ama08, #NO.TQC-5B0201
         g_ama09     LIKE ama_file.ama09, #NO.TQC-5B0201
         g_ama10     LIKE ama_file.ama10, #NO.TQC-5B0201
         g_ama13     LIKE ama_file.ama13, #No.FUN-690020
         g_ama14     LIKE ama_file.ama14, #No.FUN-690020
         g_ama15     LIKE ama_file.ama15, #No.FUN-690020
         g_ama16     LIKE ama_file.ama16, #No.FUN-950013
         g_ama17     LIKE ama_file.ama17, #No.FUN-950013
         g_ama18     LIKE ama_file.ama18, #No.FUN-950013
         g_ama19     LIKE ama_file.ama19, #No.FUN-950013
         g_ama20     LIKE ama_file.ama20, #No.FUN-950013
         g_ama21     LIKE ama_file.ama21, #FUN-980024 add
         g_ama22     LIKE ama_file.ama22, #FUN-980024 add
         l_flag          LIKE type_file.chr1,                  #No.FUN-570123        #No.FUN-680074 VARCHAR(1)
         g_change_lang   LIKE type_file.chr1                   # Prog. Version..: '5.30.06-13.03.12(01) #是否有做語言切換 No.FUN-57012
DEFINE   g_name      LIKE type_file.chr20  #FUN-6B0062
DEFINE   g_ama24     LIKE ama_file.ama24   #FUN-990021
DEFINE   l_ama02     LIKE ama_file.ama02   #MOD-B90114 add
DEFINE   l_ama03     LIKE ama_file.ama03   #MOD-B90114 add
DEFINE   l_n         LIKE type_file.num5   #FUN-BA0021 
DEFINE   g_amk RECORD  LIKE amk_file.*                       #MOD-BC0301 add

MAIN
   DEFINE l_source,l_target,l_status   STRING   #FUN-6B0062
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_pdate  = ARG_VAL(1) 
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.a    = ARG_VAL(7)
   LET tm.b    = ARG_VAL(8)
   LET tm.d    = ARG_VAL(9)   #MOD-670019
   LET tm.e    = ARG_VAL(10)   #CHI-760025
   LET tm.ama01= ARG_VAL(11)
   LET tm.rep  = ARG_VAL(12)
   LET tm.fil  = ARG_VAL(13)   #No.FUN-690020
   LET tm.byy  = ARG_VAL(14)
   LET tm.bmm  = ARG_VAL(15)
   LET tm.emm  = ARG_VAL(16)
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used('amdp100',g_time,1) RETURNING g_time    #No.FUN-6A0068  #FUN-B30211
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #No.FUN-6A0068   #FUN-B30211
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p100_tm(0,0)
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            IF cl_null(tm.eyy) THEN 
               LET tm.eyy = tm.byy 
            END IF  
            IF cl_null(tm.emm) THEN
               LET tm.emm = tm.bmm
            END IF
            #---FUN-B40063 start--
            IF tm.upd = 'Y' THEN 
                CALL p100_2()
            ELSE
            #---FUN-B40063 end----
                CASE
                   WHEN tm.fil="1"
                      CALL p100_1()
                   WHEN tm.fil="2"
                      CALL p100_2()
                   WHEN tm.fil="3"
                      CALL p100_3()   #FUN-B40063
                   WHEN tm.fil="4"
                      CALL p100_4()
                END CASE
            END IF    #FUN-B40063 add
            IF tm.upd = 'N' THEN    #FUN-B40063 add
                LET l_source=os.Path.join(FGL_GETENV("TEMPDIR"),g_name CLIPPED)
                LET l_target="C:\\tiptop\\",g_name CLIPPED
                LET l_status = cl_download_file(l_source,l_target)
                IF l_status THEN
                   CALL cl_err(g_name,"amd-020",1)
                ELSE
                   CALL cl_err(g_name,"amd-021",1)
                END IF
            END IF    #FUN-B40063 add
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p100_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
#-----------------------MOD-B90114----------------------------------------------start
        #SELECT ama02,ama03,ama05 INTO g_ama02,g_ama03,g_ama05
        #  FROM ama_file WHERE ama01 = tm.ama01 AND amaacti = 'Y'
         SELECT ama02,ama03,ama05,ama08,ama09,ama10,ama13,ama14,ama15,
                ama16,ama17,ama18,ama19,ama20,ama21,ama22,ama24           #MOD-C60135 ma21 mod ama21
           INTO g_ama02,g_ama03,g_ama05,g_ama08,g_ama09,g_ama10,g_ama13,g_ama14,g_ama15,
                g_ama16,g_ama17,g_ama18,g_ama19,g_ama20,g_ama21,g_ama22,g_ama24
           FROM ama_file WHERE ama01 = tm.ama01 AND amaacti = 'Y'
#------------------------MOD-B90114-----------------------------------------------end
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","ama_file",tm.ama01,"","amd-002","","",1)  #No.FUN-660093
         END IF
         IF cl_null(tm.eyy) THEN 
            LET tm.eyy = tm.byy 
         END IF  
         IF cl_null(tm.emm) THEN
            LET tm.emm = tm.bmm
         END IF
         #---FUN-B40063 start--
         IF tm.upd = 'Y' THEN 
             CALL p100_2()
         ELSE
         #---FUN-B40063 end----
             CASE
                WHEN tm.fil="1"
                   CALL p100_1()
                WHEN tm.fil="2"
                   CALL p100_2()
                WHEN tm.fil="3"
                   CALL p100_3()   #FUN-B40063
                WHEN tm.fil="4"
                   CALL p100_4()
             END CASE
         END IF   #FUN-B40063 add
         IF tm.upd = 'N' THEN   #FUN-B40063 add
             LET l_source = os.Path.join(FGL_GETENV("TEMPDIR"), g_name CLIPPED)
             LET l_target="C:\\tiptop\\",g_name CLIPPED
             LET l_status = cl_download_file(l_source,l_target)
             IF l_status THEN
                CALL cl_err(g_name,"amd-020",1)
             ELSE
                CALL cl_err(g_name,"amd-021",1)
             END IF
         END IF    #FUN-B40063 add
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #CALL cl_used('amdp100',g_time,2) RETURNING g_time   #No.FUN-6A0068  #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-6A0068    #FUN-B30211
END MAIN
 
FUNCTION p100_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-680074 SMALLINT
            l_cmd         LIKE type_file.chr1000        #No.FUN-680074
   DEFINE   lc_cmd        LIKE type_file.chr1000        #No.FUN-680074 VARCHAR(500) #No.FUN-570123 
 
   OPEN WINDOW p100_w WITH FORM "amd/42f/amdp100"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.a = '3'
   LET tm.b = 'Y'              #No.B211 010528 by plum
   LET tm.d = 'Y'   #MOD-670019
   LET tm.e = 'N'   #CHI-760025
   LET tm.byy=YEAR(g_today)
   LET tm.bmm=MONTH(g_today)
   LET tm.emm=MONTH(g_today)
   LET g_bgjob = 'N'  #NO.FUN-570123 
   LET tm.type = '1'     #FUN-B40063
   LET tm.deduct = '1'   #FUN-B40063
   LET tm.upd = 'N'

   WHILE TRUE
      #INPUT BY NAME tm.a,tm.b,tm.d,tm.rep,tm.fil,tm.ama01,tm.byy,tm.bmm,   #MOD-670019   #No:FUN-690020   #CHI-760025  #FUN-990021
      INPUT BY NAME tm.type,tm.deduct,tm.a,tm.upd,tm.b,tm.d,tm.fil,tm.rep,tm.rep1,tm.ama01,tm.byy,tm.bmm,  #FUN-B40063
         tm.emm,g_bgjob  WITHOUT DEFAULTS  #NO.FUN-570123 

       ON ACTION locale
           LET g_change_lang = TRUE        #NO.FUN-570123 
           EXIT INPUT
 
         #--FUN-B40063 start--
         ON CHANGE type
            CALL p100_set_entry()    
            CALL p100_set_no_entry() 
            IF tm.type = '1' THEN
                LET tm.deduct = '1'
                LET tm.upd = 'N'
            END IF
            DISPLAY BY NAME tm.deduct
            DISPLAY BY NAME tm.upd

         AFTER FIELD type
            CALL p100_set_entry()    
            CALL p100_set_no_entry() 
            IF tm.type = '1' THEN
                LET tm.deduct = '1'
                LET tm.upd = 'N'
            END IF
            DISPLAY BY NAME tm.deduct
            DISPLAY BY NAME tm.upd

         ON CHANGE upd
            CALL p100_set_entry()    
            CALL p100_set_no_entry() 
            IF tm.upd = 'Y' THEN
                LET tm.b = 'N'
                LET tm.d = 'N'
            ELSE
                LET tm.b = 'Y'
                LET tm.d = 'Y'
            END IF  
            DISPLAY BY NAME tm.b
            DISPLAY BY NAME tm.d

         ON CHANGE deduct
            CALL p100_set_entry()    
            CALL p100_set_no_entry() 

         #AFTER FIELD fil #TQC-C20389 mark
          ON CHANGE fil   #TQC-C20389 ADD
            CALL p100_set_entry()    
            CALL p100_set_no_entry() 
            CALL p001_set_no_required()  
            CALL p001_set_required()  
            IF tm.fil != '3' THEN
                LET tm.rep1 = ''
            ELSE
                LET tm.rep = ''
            END IF
         #--FUN-B40063 end---

         AFTER FIELD a
            IF tm.a NOT MATCHES '[1-3]' THEN
               NEXT FIELD a
            END IF
 
         BEFORE FIELD b
            IF tm.a='1' THEN
               LET tm.b = 'N'
               DISPLAY tm.b TO FORMONLY.b
            END IF
 
         AFTER FIELD b
            IF tm.b NOT MATCHES '[YyNn]' THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD d
            IF tm.d NOT MATCHES '[YyNn]' THEN
               NEXT FIELD d
            END IF
 
        #------------------------------------MOD-BC0301--------------------------------start
         AFTER INPUT
            IF NOT cl_null(tm.ama01) AND NOT cl_null(tm.byy)
                                     AND NOT cl_null(tm.bmm) THEN
               SELECT * INTO g_amk.* FROM amk_file WHERE amk01 = tm.ama01
                                                     AND amk02 = tm.byy
                                                     AND amk03 = tm.emm
            END IF
        #------------------------------------MOD-BC0301----------------------------------end 

         AFTER FIELD ama01
            IF NOT cl_null(tm.ama01) THEN        #FUN-980090
               SELECT ama02,ama03,ama05,ama08,ama09,ama10,ama13,ama14,ama15, #No:FUN-690020
                      ama16,ama17,ama18,ama19,ama20,             #FUN-950013 
                      ama21,ama22,                                #FUN-980024 add
                      ama24                                      #FUN-990021
                 INTO g_ama02,g_ama03,g_ama05,g_ama08,g_ama09,g_ama10,g_ama13,g_ama14,g_ama15,   #No:FUN-690020
                      g_ama16,g_ama17,g_ama18,g_ama19,g_ama20,   #FUN-950013
                      g_ama21,g_ama22,                            #FUN-980024
                      g_ama24                                     #FUN-990021
                 FROM ama_file WHERE ama01 = tm.ama01 AND amaacti = 'Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","ama_file",tm.ama01,"","amd-002","","",1)   #No.FUN-660093
                  NEXT FIELD ama01
               END IF
               IF cl_null(g_ama08) THEN
                  LET tm.byy = YEAR(g_today)
               ELSE
                  LET tm.byy = g_ama08
               END IF
               IF cl_null(g_ama09) THEN
                  LET tm.bmm = MONTH(g_today)
               ELSE
                  LET tm.bmm = g_ama09 + 1
               END IF
               IF tm.bmm > 12 THEN
                   LET tm.byy = tm.byy + 1
                   LET tm.bmm = tm.bmm - 12
               END IF
               LET tm.emm = tm.bmm + g_ama10 - 1
               DISPLAY tm.byy TO FORMONLY.byy
               DISPLAY tm.bmm TO FORMONLY.bmm
               DISPLAY tm.emm TO FORMONLY.emm
               DISPLAY g_ama24 TO FORMONLY.e   #FUN-990021
            END IF
 
         AFTER FIELD byy
            IF cl_null(tm.byy) THEN
               NEXT FIELD byy
            END IF
 
 
         AFTER FIELD bmm
            IF cl_null(tm.bmm) THEN
               NEXT FIELD bmm
            END IF
            IF tm.bmm > 12 OR tm.bmm < 1 THEN
               NEXT FIELD bmm
            END IF
 
 
         AFTER FIELD emm
            IF cl_null(tm.emm) THEN
               NEXT FIELD emm
            END IF
            IF tm.emm > 12 OR tm.emm < 1 THEN
               NEXT FIELD emm
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(ama01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ama"
             LET g_qryparam.default1 = tm.ama01
             CALL cl_create_qry() RETURNING tm.ama01
             DISPLAY  BY NAME tm.ama01
             NEXT FIELD ama01
         END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         BEFORE INPUT
             CALL cl_qbe_init()
             CALL p001_set_required()   #FUN-980090
             CALL p100_set_entry()      #FUN-B40063
             CALL p100_set_no_entry()   #FUN-B40063

         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW p100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "amdp100"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('amdp100','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                  " '",g_pdate CLIPPED ,"'",
                  " '",g_towhom CLIPPED ,"'",
                  " '",g_rlang CLIPPED ,"'",
                  " '",g_bgjob CLIPPED ,"'",
                  " '",g_prtway CLIPPED ,"'",
                  " '",g_copies CLIPPED ,"'",
                  " '",tm.a CLIPPED ,"'",
                  " '",tm.b CLIPPED ,"'",
                  " '",tm.d CLIPPED ,"'",
                  " '",tm.ama01 CLIPPED ,"'",
                  " '",tm.rep CLIPPED ,"'",
                  " '",tm.byy CLIPPED ,"'",
                  " '",tm.bmm CLIPPED ,"'",
                  " '",tm.emm CLIPPED ,"'",
                  " '",tm.eyy CLIPPED ,"'",
                  " '",g_rep_user CLIPPED ,"'",
                  " '",g_rep_clas CLIPPED ,"'",
                  " '",g_template CLIPPED ,"'",
                  " '",tm.fil CLIPPED ,"'"   #No.FUN-690020
            CALL cl_cmdat('amdp100',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
    EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p100_1()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680074 VARCHAR(20) # External(Disk) file name 
          l_sql     STRING,                      # RDSQL STATEMENT                #No.FUN-680074
          l_chr     LIKE type_file.chr1,         #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680074 VARCHAR(40)    
         #l_idx     LIKE type_file.num5,         #No.FUN-680074 SMALLINT #MOD-C10220 mark
          l_idx     LIKE amd_file.amd175,        #MOD-C10220 add
          sr1       RECORD
                     amd22   LIKE amd_file.amd22,   #FUN-990057
                     amd171 LIKE amd_file.amd171,   #格式               #No.FUN-680074 VARCHAR(02)
                     ama03  LIKE ama_file.ama03,    #稅籍編號           #No.FUN-680074 VARCHAR(09)
                     amd175 LIKE amd_file.amd175,   #流水號             #No.FUN-680074 INTEGER
                     amd173 LIKE amd_file.amd173,   #年度               #No.FUN-680074 SMALLINT
                     amd174 LIKE amd_file.amd174,   #月份               #No.FUN-680074 SMALLINT
                     ama02  LIKE ama_file.ama02,    #買方統一編號       #No.FUN-680074 VARCHAR(08)
                     amd04  LIKE amd_file.amd04,    #賣方統一編號       #No.FUN-680074 VARCHAR(08)
                     amd05  LIKE amd_file.amd05,    #發票日期           #No.FUN-680074 DATE
                     amd06  LIKE amd_file.amd06,    #含稅金額           #No.FUN-680074 INTEGER
                     amd03  LIKE amd_file.amd03,    #發票編號           #No.FUN-680074 VARCHAR(14) #MODNO4197  
                     amd08  LIKE amd_file.amd08,    #扣抵稅額           #FUN-4C0022
                     amd172 LIKE amd_file.amd172,   #課稅別             #No.FUN-680074 VARCHAR(01)
                     amd07  LIKE amd_file.amd07,    #扣抵金額           #FUN-4C0022
                     amd17  LIKE amd_file.amd17,    #扣扺代號           #No.FUN-680074 VARCHAR(01)
                     amd09  LIKE amd_file.amd09,    #匯加注記           #No.FUN-680074 VARCHAR(01)
                     amd10  LIKE amd_file.amd10,    #洋菸酒注記         #No.FUN-680074 VARCHAR(01) 
                     amd031 LIKE amd_file.amd031,   #發票聯數           #FUN-770040
                     amd032 LIKE amd_file.amd032,   #發票訖號           #FUN-B80160 add
                     cnt     LIKE type_file.num5,   #26,27彙總張數      #CHI-8C0011 add
                     t_amd07 LIKE amd_file.amd07,   #26,27彙總銷售金額  #CHI-8C0011 add
                     t_amd08 LIKE amd_file.amd08,   #26,27彙總營業稅額  #CHI-8C0011 add
                     amd021  LIKE amd_file.amd021,  #來源類別           #CHI-B90005 add
                     amd35   LIKE amd_file.amd35,   #外銷方式           #MOD-B90279 add
                     amd39   LIKE amd_file.amd39    #號碼               #MOD-B90279 add
                    END RECORD,
          l_flg     LIKE type_file.chr1,                                #CHI-8C0011 add
          o_amd171  LIKE amd_file.amd171                                #CHI-8C0011 add
   DEFINE l_oom RECORD LIKE oom_file.*   
   DEFINE l_s,l_e LIKE type_file.num10    #MOD-770085 
   DEFINE i,l_cnt LIKE type_file.num10    #MOD-770085
   DEFINE l_begin,l_end LIKE oom_file.oom08
   DEFINE l_amb04 LIKE amb_file.amb04     #MOD-980162 add
   DEFINE l_amd03 LIKE amd_file.amd03     #MOD-A70013
   DEFINE l_cnt1       LIKE type_file.num10    #CHI-B90005 add
   DEFINE l_amd39      LIKE amd_file.amd39     #MOD-B90279 add 

     SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'  #MOD-B90279 add
     #-->進項
     ## 增加判斷amd17,amd172
     LET l_sql = "SELECT amd22,amd171,'',amd175,amd173,amd174,'',amd04,amd05,amd06,",  #FUN-990057 mod
                 "       amd03,amd08,amd172,amd07,amd17,amd09,amd10,amd031,amd032",   #FUN-770040    #FUN-B80160 add amd032
                 "      ,0,0,0,amd021,amd35,amd39",  #CHI-8C0011 add  #CHI-B90005 add amd021 #MOD-B90279 add amd35、amd39
                 "   FROM amd_file JOIN ama_file ON amd22=ama01",       #FUN-980090 mod
                 " WHERE amd173=",tm.byy,                               #MOD-710100
                 "   AND (amd174 BETWEEN ",tm.bmm," AND ",tm.emm,")",   #MOD-710100
                 "   AND amd171 LIKE '2%' ",
                 "   AND amd30 = 'Y' "  #5446
 
     IF (g_ama24 = 'Y' AND g_ama15 = '1') THEN   #FUN-990021
        LET l_sql = l_sql,
            "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))"
     ELSE
        LET l_sql = l_sql,
            "   AND amd22 = '",tm.ama01,"'"
     END IF

     IF tm.d = 'Y' THEN
        LET l_sql = l_sql,
                  " AND amd17 IN ('1','2','3','4')",
                  " ORDER BY amd171,amd22,amd03" #FUN-990057
     ELSE 
        LET l_sql = l_sql,
                  " AND amd17 IN ('1','2')",
                  " ORDER BY amd171,amd22,amd03"  #FUN-990057
     END IF
     PREPARE p100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        IF STATUS THEN
           CALL cl_err('',STATUS,0)
           CALL cl_batch_bg_javamail("N")
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
        END IF
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE p100_curs1 CURSOR FOR p100_prepare1
 
     #-->進項(26、27格式)
     LET l_sql = "SELECT SUM(amd07),SUM(amd08)",
                 "  FROM amd_file JOIN ama_file ON amd22=ama01",       #FUN-980090 mod
                 " WHERE amd173=",tm.byy,
                 "   AND (amd174 BETWEEN ",tm.bmm," AND ",tm.emm,")",
                 "   AND amd171=? ",
                 "   AND amd30 = 'Y'",
                 "   AND amd22 =? "    #FUN-990057

     IF (g_ama24 = 'Y' AND g_ama15 = '1') THEN   #FUN-990021
        LET l_sql = l_sql,
            "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))"
     ELSE
        LET l_sql = l_sql,
            "   AND amd22 = '",tm.ama01,"'"
     END IF

     IF tm.d = 'Y' THEN
        LET l_sql = l_sql," AND amd17 IN ('1','2','3','4')"
     ELSE 
        LET l_sql = l_sql," AND amd17 IN ('1','2')"
     END IF
     PREPARE p100_prepare1_1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1_1:',SQLCA.sqlcode,1)
        IF STATUS THEN
           CALL cl_err('',STATUS,0)
           CALL cl_batch_bg_javamail("N")
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
        END IF
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE p100_curs1_1 CURSOR FOR p100_prepare1_1
 
     LET l_sql = "SELECT COUNT(*)",
                 "  FROM amd_file JOIN ama_file ON amd22=ama01",       #FUN-980090 mod
                 " WHERE amd173=",tm.byy,
                 "   AND (amd174 BETWEEN ",tm.bmm," AND ",tm.emm,")",
                 "   AND amd171=? ",
                 "   AND amd30 = 'Y'",
                 "   AND amd22 =? ",  #FUN-990057
                #"   AND amd021 <> '4'"      #CHI-B90005 add   #MOD-D10082 mark
                 "   AND amd021 NOT IN ('4','5')"              #MOD-D10082
     IF tm.d = 'Y' THEN
        LET l_sql = l_sql," AND amd17 IN ('1','2','3','4')"
     ELSE 
        LET l_sql = l_sql," AND amd17 IN ('1','2')"
     END IF
     IF (g_ama24 = 'Y' AND g_ama15 = '1') THEN   #FUN-990021
        LET l_sql = l_sql,
            "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))"
     ELSE
        LET l_sql = l_sql,
            "   AND amd22 = '",tm.ama01,"'"
     END IF

     PREPARE p100_prepare1_2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1_2:',SQLCA.sqlcode,1)
        IF STATUS THEN
           CALL cl_err('',STATUS,0)
           CALL cl_batch_bg_javamail("N")
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
        END IF
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE p100_curs1_2 CURSOR FOR p100_prepare1_2

#-------------------------------------No.CHI-B90005--------------------------------------------start
     LET l_sql = "SELECT SUM(AMD04)",
                 "  FROM amd_file JOIN ama_file ON amd22=ama01",
                 " WHERE amd173=",tm.byy,
                 "   AND (amd174 BETWEEN ",tm.bmm," AND ",tm.emm,")",
                 "   AND amd171=? ",
                 "   AND amd30 = 'Y'",
                 "   AND amd22 =? ",
                #"   AND amd021 = '4'"         #MOD-D10082 mark
                 "   AND amd021 IN('4','5')"   #MOD-D10082
     IF tm.d = 'Y' THEN
        LET l_sql = l_sql," AND amd17 IN ('1','2','3','4')"
     ELSE
        LET l_sql = l_sql," AND amd17 IN ('1','2')"
     END IF
     IF (g_ama24 = 'Y' AND g_ama15 = '1') THEN
        LET l_sql = l_sql,
            "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))"
     ELSE
        LET l_sql = l_sql,
            "   AND amd22 = '",tm.ama01,"'"
     END IF

     PREPARE p100_prepare1_3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1_2:',SQLCA.sqlcode,1)
        IF STATUS THEN
           CALL cl_err('',STATUS,0)
           CALL cl_batch_bg_javamail("N")
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
        END IF
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE p100_curs1_3 CURSOR FOR p100_prepare1_3
#-------------------------------------No.CHI-B90005--------------------------------------------end 

     #-->銷項(含零稅率)
     ##--------增加判斷amd172
     LET l_sql = "SELECT amd22,amd171,'',amd175,amd173,amd174,amd04,'',amd05,amd06,",  #FUN-990057 mod #MOD-B90279 mark #MOD-BB0213 remark
    #LET l_sql = "SELECT amd22,amd171,'',amd175,amd173,amd174,'',amd04,amd05,amd06,",  #MOD-B90279 add #MOD-BB0213 mark
                 "       amd03,amd08,amd172,amd07,amd17,amd09,amd10,amd031,amd032",   #FUN-770040    #FUN-B80160 add amd032
                 "      ,0,0,0,amd021,amd35,amd39",  #CHI-8C0011 add #MOD-B90279 add amd021 amd35 amd39
                 " FROM amd_file JOIN ama_file ON amd22=ama01",       #FUN-980090 mod
                 " WHERE amd173=",tm.byy,                               #MOD-710100
                 "   AND (amd174 BETWEEN ",tm.bmm," AND ",tm.emm,")",   #MOD-710100
                 "   AND amd30 = 'Y' ",  #5446
                 "   AND (amd171 LIKE '3%' OR amd172 = 'F') "  #FUN-A10039

     IF (g_ama24 = 'Y' AND g_ama15 = '1') THEN   #FUN-990021
        LET l_sql = l_sql,
            "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))"
     ELSE
        LET l_sql = l_sql,
            "   AND amd22 = '",tm.ama01,"'"
     END IF

     IF tm.b='N' THEN
        LET l_sql=l_sql CLIPPED," AND amd172 <>'2' "
     END IF
    #LET l_sql=l_sql CLIPPED," ORDER BY amd171,amd03"         #MOD-B90279 mark
     LET l_sql=l_sql CLIPPED," ORDER BY amd171,amd03,amd39"   #MOD-B90279 add
 
     PREPARE p100_prepare2 FROM l_sql
     IF SQLCA.SQLCODE THEN CALL cl_err('prepare2',STATUS,0) END IF
     DECLARE p100_curs2 CURSOR FOR p100_prepare2
    #------------------------------------MOD-B90279--------------------------------start
     LET l_sql = "SELECT SUM(amd08)",
                 " FROM amd_file JOIN ama_file ON amd22=ama01",
                 " WHERE amd173=",tm.byy,
                 "   AND (amd174 BETWEEN ",tm.bmm," AND ",tm.emm,")",
                 "   AND amd30 = 'Y' ",
                 "   AND amd39 = ?",
                 "   AND (amd171 LIKE '3%' OR amd172 = 'F') "

     IF (g_ama24 = 'Y' AND g_ama15 = '1') THEN
        LET l_sql = l_sql,
            "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))"
     ELSE
        LET l_sql = l_sql,
            "   AND amd22 = '",tm.ama01,"'"
     END IF
     PREPARE p100_prepare3 FROM l_sql
     IF SQLCA.SQLCODE THEN CALL cl_err('prepare3',STATUS,0) END IF
     DECLARE p100_curs3 CURSOR FOR p100_prepare3
    #------------------------------------MOD-B90279--------------------------------end 
     LET l_idx = 1
     LET l_name  = tm.rep CLIPPED,'.TXT'
     LET g_name  = l_name   #FUN-6B0062
     SELECT UNIQUE zaa12 INTO g_page_line FROM zaa_file WHERE zaa01=g_prog  #No.MOD-560233
     START REPORT p100_rep1 TO l_name
     #-->進項(amd_file)
     IF tm.a = '1' OR tm.a = '3' THEN
        LET l_flg = 'Y'   #CHI-8C0011 add
        FOREACH p100_curs1 INTO sr1.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
          #SELECT ama02,ama03 INTO g_ama02,g_ama03      #MOD-B90114 mark
           SELECT ama02,ama03 INTO l_ama02,l_ama03      #MOD-B90114 add
           FROM ama_file WHERE ama01 = sr1.amd22 AND amaacti = 'Y'
          #LET sr1.ama03 =g_ama03    #MOD-B90114 mark
           LET sr1.ama03 =l_ama03    #MOD-B90114 add
          #LET sr1.ama02 =g_ama02    #MOD-B90114 mark
           LET sr1.ama02 =l_ama02    #MOD-B90114 add
           LET sr1.amd175 = l_idx    #98/10/23 modify
 
          #IF sr1.amd171 = '22' AND sr1.amd031 = '2' THEN                             #MOD-C50112 mark
           IF sr1.amd171 = '22' AND (sr1.amd031 = '2' OR sr1.amd031 = '5') THEN       #MOD-C50112 add
              LET sr1.amd07=0
              LET sr1.amd08=sr1.amd06
           END IF
 
 
           IF cl_null(sr1.amd07) THEN LET sr1.amd07=0 END IF
           IF cl_null(sr1.amd08) THEN LET sr1.amd08=0 END IF
 
          #進項(26、27格式)
           IF sr1.amd171 = '26' OR sr1.amd171 = '27' THEN
              IF cl_null(o_amd171) OR o_amd171 != sr1.amd171 THEN
                 LET l_flg = 'Y'
              ELSE
                 LET l_flg = 'N'
              END IF
              IF l_flg = 'Y' THEN   #第一筆進來
                 OPEN p100_curs1_1 USING sr1.amd171,sr1.amd22  #FUN-990057 mod   
                 FETCH p100_curs1_1 INTO sr1.t_amd07,sr1.t_amd08
                 LET sr1.cnt = 0
                 LET l_cnt1 = 0                                #CHI-B90005 add
                 OPEN p100_curs1_3 USING sr1.amd171,sr1.amd22  #CHI-B90005 add   
                 FETCH p100_curs1_3 INTO l_cnt1                #CHI-B90005 add
                 OPEN p100_curs1_2 USING sr1.amd171,sr1.amd22  #FUN-990057 mod  
                 FETCH p100_curs1_2 INTO sr1.cnt
                 LET sr1.cnt = sr1.cnt + l_cnt1                #CHI-B90005 add
                 LET o_amd171 = sr1.amd171
              ELSE
                 CONTINUE FOREACH
              END IF
           END IF
 
           OUTPUT TO REPORT p100_rep1(sr1.*)
           LET l_idx = l_idx + 1
        END FOREACH
     END IF
     #-->銷項(amd_file)
     IF tm.a = '2' OR tm.a = '3' THEN
        LET l_amd39 =' '     #MOD-B90279 add
        FOREACH p100_curs2 INTO sr1.*
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
            #SELECT ama02,ama03 INTO g_ama02,g_ama03  #MOD-B90114 mark
             SELECT ama02,ama03 INTO l_ama02,l_ama03  #MOD-B90114 add
             FROM ama_file WHERE ama01 = sr1.amd22 AND amaacti = 'Y'
            #LET sr1.ama03=g_ama03   #MOD-B90114 mark
             LET sr1.ama03=l_ama03   #MOD-B90114 add
            #LET sr1.amd04=g_ama02   #MOD-B90114 mark
             LET sr1.amd04=l_ama02   #MOD-B90114 add
             LET sr1.amd17 = ' '
             LET sr1.amd175 = l_idx
             IF cl_null(sr1.amd06) THEN LET sr1.amd06=0 END IF
             IF cl_null(sr1.amd07) THEN LET sr1.amd07=0 END IF
             IF cl_null(sr1.amd08) THEN LET sr1.amd08=0 END IF
             #若為銷項二聯式
             IF sr1.amd171 = '32' THEN
                LET sr1.amd08 = sr1.amd06
                LET sr1.amd07 = 0
             END IF
             #IF sr1.amd171='31' AND cl_null(sr1.ama02) THEN #MOD-690113 mod      #MOD-A30081 mark
              IF (sr1.amd171='31' OR sr1.amd171='35') AND cl_null(sr1.ama02) THEN #MOD-A30081 add
                 LET sr1.amd08 = sr1.amd06
                 LET sr1.amd07 = 0
              END IF
             IF sr1.amd171='36' THEN
                LET sr1.amd03=' '
             END IF
#FUN-B80160 ---------------STA
             IF sr1.amd09 = 'A' THEN
                LET sr1.ama02 = sr1.amd032[3,10]
             END IF
#FUN-B80160 ---------------END
            #-------------------------------MOD-B90279--------------------------------start
             IF NOT cl_null(sr1.amd35 ) THEN
                IF g_ooz.ooz64 = 'N' THEN
               #同一張報單金額應只呈現在第一筆,其他筆空白
                   IF NOT cl_null(sr1.amd39) AND sr1.amd39 != ' ' THEN
                      IF sr1.amd39 != l_amd39 THEN
                         OPEN p100_curs3 USING sr1.amd39
                         FETCH p100_curs3 INTO sr1.amd08
                         CLOSE p100_curs3
                         LET l_amd39 = sr1.amd39
                      ELSE
                        IF cl_null(sr1.amd03) THEN
                           LET sr1.amd08 = 0
                        ELSE
                           CONTINUE FOREACH
                        END IF
                      END IF
                   END IF
                END IF
             END IF
            #-------------------------------MOD-B90279--------------------------------end
             OUTPUT TO REPORT p100_rep1(sr1.*)
             LET l_idx = l_idx + 1
        END FOREACH
        #空白發票也要能印出來
        IF cl_null(l_idx) THEN LET l_idx = 1 END IF
        LET l_sql ="SELECT * ",
                   "  FROM oom_file",
                   " WHERE oom01 =",tm.byy,
                   "   AND oom02>=",tm.bmm, #MOD-970181 add >   
                   "   AND oom021<=",tm.emm,#MOD-970181 add <    
                   "   AND oom04 <> 'X' ",
                 "   AND (oom08 <> oom09 OR oom09 IS NULL)"    #MOD-770088
       #IF g_aza.aza94 = 'Y' THEN    #MOD-B50169 mark
           LET l_sql = l_sql CLIPPED, "   AND oom13 = '",g_ama02,"' ",  
                       " ORDER BY oom01" 
       #-MOD-B50169-mark- 
       #ELSE
       #   LET l_sql = l_sql CLIPPED, 
       #                    " ORDER BY oom01" 
       #END IF
       #-MOD-B50169-end- 
                   
        PREPARE oom_pr FROM l_sql
        IF SQLCA.SQLCODE THEN CALL cl_err('oom_pr',STATUS,0) END IF
        DECLARE oom_curs CURSOR FOR oom_pr
        FOREACH oom_curs INTO l_oom.*
           IF l_oom.oom021 != 12 THEN
              LET sr1.amd05 = MDY(l_oom.oom021+1,1,l_oom.oom01) - 1
           ELSE
              LET sr1.amd05 = MDY(1,1,l_oom.oom01+1) - 1
           END IF
           IF cl_null(l_oom.oom09) THEN
              LET l_begin = l_oom.oom07
              LET l_cnt = 0
           ELSE
              LET l_begin = l_oom.oom09
              LET l_cnt = 1
           END IF
           LET l_amb04 = ''
           LET l_sql = "SELECT amb04 ",
                       "  FROM amb_file",
                       " WHERE amb01 = ", tm.byy,
                      #"   AND amb02 >= ", tm.bmm,                               #MOD-C50113 mark
                       "   AND (amb02 < ", tm.bmm, " OR amb02 = ", tm.bmm, ")",  #MOD-C50113 add
                      #"   AND amb07 <= ", tm.emm,                               #MOD-C40156 mark
                       "   AND (amb07 > ", tm.emm, " OR amb07 = ", tm.emm, ")",  #MOD-C40156
                       "   AND amb03 = '", l_begin[1,2], "'"
           PREPARE p100_amb_pre FROM l_sql
           DECLARE p100_amb_cs CURSOR FOR p100_amb_pre
           FOREACH p100_amb_cs INTO l_amb04 
              IF SQLCA.SQLCODE THEN
                 CALL cl_err('SEL amb04:',SQLCA.SQLCODE,1)
                 EXIT FOREACH
              END IF
              EXIT FOREACH
           END FOREACH
           IF NOT cl_null(l_amb04) THEN
              CASE l_amb04
                 WHEN "21"  LET sr1.amd171="31"
                 WHEN "22"  LET sr1.amd171="32"
                 WHEN "25"  LET sr1.amd171="35"
              END CASE
              LET sr1.ama03 = g_ama03            #稅籍編號
              LET sr1.amd175= l_idx              #流水號
              LET sr1.amd173= tm.eyy             #年度
              LET sr1.amd174= tm.emm             #月份
             #-MOD-A70013-add-
             #LET sr1.ama02 = l_oom.oom08[3,10]  #買方統一編號(發票迄號)
              LET l_amd03 = l_begin[1,2],(l_begin[3,10]+l_cnt) USING '&&&&&&&&'
              IF l_amd03 <> l_oom.oom08 THEN
                 LET sr1.ama02 = l_oom.oom08[3,10]  #買方統一編號(發票迄號)
              ELSE
                 LET sr1.ama02 = '        '
              END IF
             #-MOD-A70013-end-
              LET sr1.amd04 = g_ama02            #賣方統一編號
              LET sr1.amd06 = 0                  #含稅金額
              LET sr1.amd03 =l_begin[1,2],(l_begin[3,10]+l_cnt) USING '&&&&&&&&'    #發票起號
              LET sr1.amd08 = 0                  #扣抵稅額
              LET sr1.amd172= 'D'                #課稅別
              LET sr1.amd07 = 0                  #扣抵金額
              LET sr1.amd17 = ' '                #扣抵代號
             #-MOD-A70013-add-
             #LET sr1.amd09 = 'A'                #彙加註記
              IF l_amd03 <> l_oom.oom08 THEN
                 LET sr1.amd09 = 'A'                #彙加註記
              ELSE
                 LET sr1.amd09 = ' '
              END IF
             #-MOD-A70013-end-
              LET sr1.amd10 = ' '                #洋菸酒註記
              OUTPUT TO REPORT p100_rep1(sr1.*)
              LET l_idx = l_idx + 1
              LET l_cnt = l_cnt +1
           END IF
        END FOREACH
     END IF
     FINISH REPORT p100_rep1
     CALL cl_addcr(l_name)   #CHI-850019 add
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT p100_rep1(sr1)
DEFINE  l_last_sw    LIKE type_file.chr1,    #No.FUN-680074 VARCHAR(1)
        l_idx        LIKE type_file.num5,    #No.FUN-680074 SMALLINT
        l_yy,l_mm    LIKE type_file.num5,    #No.FUN-680074 SMALLINT
        l_cyy,l_cmm  LIKE type_file.num5,    #No.FUN-680074 VARCHAR(2)
        l_y1,l_m1    LIKE type_file.num5,    #FUN-950013
        p_y1,p_m1    LIKE type_file.num5,    #MOD-970137   
       sr1           RECORD
                      amd22  LIKE amd_file.amd22,    #FUN-990057 add
                      amd171 LIKE amd_file.amd171,   #格式               #No.FUN-680074 VARCHAR(02)
                      ama03  LIKE ama_file.ama03,    #稅籍編號           #No.FUN-680074 VARCHAR(09)
                      amd175 LIKE amd_file.amd175,   #流水號             #No.FUN-680074 INTEGER
                      amd173 LIKE amd_file.amd173,   #年度               #No.FUN-680074 SMALLINT
                      amd174 LIKE amd_file.amd174,   #月份               #No.FUN-680074 SMALLINT
                      ama02  LIKE ama_file.ama02,    #買方統一編號       #No.FUN-680074 VARCHAR(08)
                      amd04  LIKE amd_file.amd04,    #賣方統一編號       #No.FUN-680074 VARCHAR(08)
                      amd05  LIKE amd_file.amd05,    #發票日期           #No.FUN-680074 DATE
                      amd06  LIKE amd_file.amd06,    #含稅金額           #No.FUN-680074 INTEGER
                      amd03  LIKE amd_file.amd03,    #發票編號           #No.FUN-680074 VARCHAR(14) #MODNO4197  
                      amd08  LIKE amd_file.amd08,    #扣抵稅額           #FUN-4C0022
                      amd172 LIKE amd_file.amd172,   #課稅別             #No.FUN-680074 VARCHAR(01)
                      amd07  LIKE amd_file.amd07,    #扣抵金額           #FUN-4C0022
                      amd17  LIKE amd_file.amd17,    #扣扺代號           #No.FUN-680074 VARCHAR(01)
                      amd09  LIKE amd_file.amd09,    #匯加注記           #No.FUN-680074 VARCHAR(01)
                      amd10  LIKE amd_file.amd10,    #洋菸酒注記         #No.FUN-680074 VARCHAR(01) 
                      amd031 LIKE amd_file.amd031,   #發票聯數           #FUN-770040
                      amd032 LIKE amd_file.amd032,   #發票訖號           #FUN-B80160 add
                      cnt     LIKE type_file.num5,   #26,27彙總張數      #CHI-8C0011 add
                      t_amd07 LIKE amd_file.amd07,   #26,27彙總銷售金額  #CHI-8C0011 add
                      t_amd08 LIKE amd_file.amd08,   #26,27彙總營業稅額  #CHI-8C0011 add
                      amd021 LIKE amd_file.amd021,   #來源類別           #CHI-B90005 add
                      amd35   LIKE amd_file.amd35,   #外銷方式           #MOD-B90279 add
                      amd39   LIKE type_file.chr14   #號碼               #MOD-B90279 add
                     END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr1.amd22,sr1.amd171,sr1.amd175  #FUN-990057
  FORMAT
   ON EVERY ROW
      IF sr1.amd171 = '33' OR sr1.amd171 = '34' OR   #MOD-580386
         sr1.amd171 = '23' OR sr1.amd171 = '24' THEN   #MOD-580386
         LET p_y1 = sr1.amd173  - 1911   #FUN-950013   #MOD-970137   
         LET p_m1 = sr1.amd174           #FUN-950013   #MOD-970137 
      ELSE
         LET p_y1 = YEAR(sr1.amd05) - 1911  #FUN-950013     #MOD-970137  
         LET p_m1 = MONTH(sr1.amd05)        #FUN-950013     #MOD-970137  
      END IF
      LET l_cmm = l_mm using '&&'  #FUN-950013
      
    IF tm.byy < 2009 OR (tm.byy = 2009 AND tm.emm < 7) THEN   #FUN-950013 add
       LET l_cyy = l_yy using '&&'   #FUN-950013
         
      IF sr1.amd171 !='28' AND sr1.amd171!='29' AND           #no:7393
         sr1.amd171 !='26' AND sr1.amd171!='27' THEN          #CHI-8C0011 add
        IF sr1.amd171 = '25' AND sr1.amd09 = 'A' THEN         #MOD-930122
           PRINT COLUMN  1,sr1.amd171 CLIPPED,                          #2 (格式代碼)
                 COLUMN  3,sr1.ama03 CLIPPED,                           #9 (稅籍編號)
                 COLUMN 12,sr1.amd175 CLIPPED USING '&&&&&&&',          #7 (流水號) #MOD-570163   #MOD-610045
                 COLUMN 19,p_y1 CLIPPED USING '&&',p_m1 CLIPPED USING '&&',   #4 (資料年月)  #FUN-950013  #MOD-970137 
                 COLUMN 23,sr1.ama02 CLIPPED,                           #8 (買受人統編)
                 COLUMN 31,sr1.amd04 CLIPPED USING '&&&&' ,             #MOD-930122            
                 COLUMN 39,sr1.amd03[1,10] CLIPPED,                     #10(發票號碼)
                 COLUMN 49,sr1.amd08 CLIPPED USING '&&&&&&&&&&&&',      #12(銷售金額)
                 COLUMN 61,sr1.amd172 CLIPPED,                          #1 (課稅別)
                 COLUMN 62,sr1.amd07 CLIPPED USING '&&&&&&&&&&',        #10(營業稅額)
                 COLUMN 72,sr1.amd17 CLIPPED,'      ',                  #1 (扣扺代號)
                 COLUMN 79,sr1.amd09 CLIPPED,                           #1 (匯加注記)
                 COLUMN 80,sr1.amd10 CLIPPED                            #1 (洋菸酒注記)
        ELSE
      	   PRINT COLUMN  1,sr1.amd171 CLIPPED,                        
                 COLUMN  3,sr1.ama03 CLIPPED,                          
                 COLUMN 12,sr1.amd175 CLIPPED USING '&&&&&&&',                      
                 COLUMN 19,p_y1 CLIPPED USING '&&',p_m1 CLIPPED USING '&&',   #FUN-950013     #MOD-970137  
                 COLUMN 23,sr1.ama02 CLIPPED,
                 COLUMN 31,sr1.amd04 CLIPPED,              
                 COLUMN 39,sr1.amd03[1,10] CLIPPED,
                 COLUMN 49,sr1.amd08 CLIPPED USING '&&&&&&&&&&&&',      
                 COLUMN 61,sr1.amd172 CLIPPED,                          
                 COLUMN 62,sr1.amd07 CLIPPED USING '&&&&&&&&&&',       
                 COLUMN 72,sr1.amd17 CLIPPED,'      ',                 
                 COLUMN 79,sr1.amd09 CLIPPED,                           
                 COLUMN 80,sr1.amd10 CLIPPED                            
      	END IF       
       ELSE
         IF sr1.amd171 !='26' AND sr1.amd171!='27' THEN       #CHI-8C0011 add
            PRINT COLUMN  1,sr1.amd171 CLIPPED,                       #2 (格式代碼)
                  COLUMN  3,sr1.ama03 CLIPPED,                        #9 (稅籍編號)
                  COLUMN 12,sr1.amd175 CLIPPED USING '&&&&&&&',       #7 (流水號)   #MOD-570163   #MOD-610045
                  COLUMN 19,p_y1 CLIPPED USING '&&',p_m1 CLIPPED USING '&&',  #4 (資料年月) #MOD-970137  
                  COLUMN 23,sr1.ama02 CLIPPED,                        #8 (買受人統編)
                  COLUMN 35,sr1.amd03 CLIPPED,                        #14(海關憑證)
                  COLUMN 49,sr1.amd08 CLIPPED USING '&&&&&&&&&&&&',   #12(營業稅基)
                  COLUMN 61,sr1.amd172 CLIPPED,                       #1 (課稅別)
                  COLUMN 62,sr1.amd07 CLIPPED USING '&&&&&&&&&&',     #10(營業稅額)
                  COLUMN 72,sr1.amd17 CLIPPED,'      ',               #1 (扣抵代號)
                  COLUMN 79,sr1.amd09 CLIPPED,                        #1 (彙加註記)
                  COLUMN 80,sr1.amd10 CLIPPED                         #1 (洋菸酒註記)
         ELSE
#產生格式相關位置為:31~:34 彙總張數;
#                  :35~:38 空白;
#                  :39~:48 其他憑證號碼(取第一筆發票編號amd03前十位);
#                  :49~:60 銷售金額(合計amd08);
#                  :62~:71 營業稅額(合計 amd07);
#                  :79為彙加註記 = 'A'
            PRINT COLUMN  1,sr1.amd171 CLIPPED,                       #2 (格式代碼)
                  COLUMN  3,sr1.ama03 CLIPPED,                        #9 (稅籍編號)
                  COLUMN 12,sr1.amd175 CLIPPED USING '&&&&&&&',       #7 (流水號)
                  COLUMN 19,p_y1 CLIPPED USING '&&',p_m1 CLIPPED USING '&&',  #4 (資料年月)  #FUN-950013  #MOD-970137  
                  COLUMN 23,sr1.ama02 CLIPPED,                        #8 (買受人統編)
                  COLUMN 31,sr1.cnt CLIPPED USING '&&&&',             #4 (彙總張數)
                  COLUMN 35,4 SPACES,                                 #4 (空白)
                  COLUMN 39,sr1.amd03[1,10] CLIPPED,                  #10(發票號碼)
                  COLUMN 49,sr1.t_amd08 CLIPPED USING '&&&&&&&&&&&&', #12(彙總銷售金額)
                  COLUMN 61,sr1.amd172 CLIPPED,                       #1 (課稅別)
                  COLUMN 62,sr1.t_amd07 CLIPPED USING '&&&&&&&&&&',   #10(彙總營業稅額)
                  COLUMN 72,sr1.amd17 CLIPPED,'      ',               #1 (扣扺代號)
                  COLUMN 79,sr1.amd09 CLIPPED,                        #1 (匯加注記)
                  COLUMN 80,sr1.amd10 CLIPPED                         #1 (洋菸酒注記)
         END IF
       END IF
    END IF    #FUN-950013 add 
    
    IF tm.byy > 2009 OR (tm.byy = 2009 AND tm.emm > 7) THEN   #FUN-950013 add     
       LET l_cyy = l_yy using '&&&'    #FUN-950013 add
       IF sr1.amd171 !='28' AND sr1.amd171!='29' AND           #no:7393
          sr1.amd171 !='26' AND sr1.amd171!='27' THEN          #CHI-8C0011 add
         IF sr1.amd171 = '25' AND sr1.amd09 = 'A' THEN   
         PRINT COLUMN  1,sr1.amd171 CLIPPED,                          #2 (格式代碼)
               COLUMN  3,sr1.ama03 CLIPPED,                           #9 (稅籍編號)
               COLUMN 12,sr1.amd175 CLIPPED USING '&&&&&&&',          #7 (流水號)   #MOD-570163   #MOD-610045
               COLUMN 19,p_y1 CLIPPED USING '&&&',p_m1 CLIPPED USING '&&',    #4 (資料年月)              #MOD-970137  
               COLUMN 24,sr1.ama02 CLIPPED,                           #8 (買受人統編)
               COLUMN 32,sr1.amd04 CLIPPED USING '&&&&',              #MOD-930122
               COLUMN 40,sr1.amd03[1,10] CLIPPED,                     #10(發票號碼)
               COLUMN 50,sr1.amd08 CLIPPED USING '&&&&&&&&&&&&',      #12(銷售金額)
               COLUMN 62,sr1.amd172 CLIPPED,                          #1 (課稅別)
               COLUMN 63,sr1.amd07 CLIPPED USING '&&&&&&&&&&',        #10(營業稅額)
               COLUMN 73,sr1.amd17 CLIPPED,'      ',                  #1 (扣扺代號)
               COLUMN 80,sr1.amd09 CLIPPED,                           #1 (匯加注記)
              #COLUMN 81,sr1.amd10 CLIPPED                            #1 (洋菸酒注記)     #MOD-A30019 mark
               COLUMN 81,sr1.amd10                                    #1 (洋菸酒注記)     #MOD-A30019 add
         ELSE
            PRINT COLUMN  1,sr1.amd171 CLIPPED,                         
                  COLUMN  3,sr1.ama03 CLIPPED,                          
                  COLUMN 12,sr1.amd175 CLIPPED USING '&&&&&&&', 
                  COLUMN 19,p_y1 CLIPPED USING '&&&',p_m1 CLIPPED USING '&&',   #MOD-970137 
                  COLUMN 24,sr1.ama02 CLIPPED,                           
                  COLUMN 32,sr1.amd04 CLIPPED,                                      
                  COLUMN 40,sr1.amd03[1,10] CLIPPED,                    
                  COLUMN 50,sr1.amd08 CLIPPED USING '&&&&&&&&&&&&',     
                  COLUMN 62,sr1.amd172 CLIPPED,                         
                  COLUMN 63,sr1.amd07 CLIPPED USING '&&&&&&&&&&',      
                  COLUMN 73,sr1.amd17 CLIPPED,'      ',                 
                  COLUMN 80,sr1.amd09 CLIPPED,                         
                 #COLUMN 81,sr1.amd10 CLIPPED           #MOD-A30019 mark 
                  COLUMN 81,sr1.amd10                   #MOD-A30019 add
         END IF 	   
      ELSE
         IF sr1.amd171 !='26' AND sr1.amd171!='27' THEN       #CHI-8C0011 add
            PRINT COLUMN  1,sr1.amd171 CLIPPED,                       #2 (格式代碼)
                  COLUMN  3,sr1.ama03 CLIPPED,                        #9 (稅籍編號)
                  COLUMN 12,sr1.amd175 CLIPPED USING '&&&&&&&',       #7 (流水號) #MOD-570163   #MOD-610045
                  COLUMN 19,p_y1 CLIPPED USING '&&&',p_m1 CLIPPED USING '&&',  #4 (資料年月)              #MOD-970137  
                  COLUMN 24,sr1.ama02 CLIPPED,                        #8 (買受人統編)
                  COLUMN 36,sr1.amd03 CLIPPED,                        #14(海關憑證)
                  COLUMN 50,sr1.amd08 CLIPPED USING '&&&&&&&&&&&&',   #12(營業稅基)
                  COLUMN 62,sr1.amd172 CLIPPED,                       #1 (課稅別)
                  COLUMN 63,sr1.amd07 CLIPPED USING '&&&&&&&&&&',     #10(營業稅額)
                  COLUMN 73,sr1.amd17 CLIPPED,'      ',               #1 (扣抵代號)
                  COLUMN 80,sr1.amd09 CLIPPED,                        #1 (彙加註記)
                 #COLUMN 81,sr1.amd10 CLIPPED                         #1 (洋菸酒注記)     #MOD-A30019 mark
                  COLUMN 81,sr1.amd10                                 #1 (洋菸酒注記)     #MOD-A30019 add
         ELSE
#產生格式相關位置為:31~:34 彙總張數;
#                  :35~:38 空白;
#                  :39~:48 其他憑證號碼(取第一筆發票編號amd03前十位);
#                  :49~:60 銷售金額(合計amd08);
#                  :62~:71 營業稅額(合計 amd07);
#                  :79為彙加註記 = 'A'
            PRINT COLUMN  1,sr1.amd171 CLIPPED,                       #2 (格式代碼)
                  COLUMN  3,sr1.ama03 CLIPPED,                        #9 (稅籍編號)
                  COLUMN 12,sr1.amd175 CLIPPED USING '&&&&&&&',       #7 (流水號)
                  COLUMN 19,p_y1 CLIPPED USING '&&&',p_m1 CLIPPED USING '&&', #4 (資料年月)  #MOD-970137  
                  COLUMN 24,sr1.ama02 CLIPPED,                        #8 (買受人統編)
                  COLUMN 32,sr1.cnt CLIPPED USING '&&&&',             #4 (彙總張數)
                  COLUMN 36,4 SPACES,                                 #4 (空白)
                  COLUMN 40,sr1.amd03[1,10] CLIPPED,                  #10(發票號碼)
                  COLUMN 50,sr1.t_amd08 CLIPPED USING '&&&&&&&&&&&&', #12(彙總銷售金額)
                  COLUMN 62,sr1.amd172 CLIPPED,                       #1 (課稅別)
                  COLUMN 63,sr1.t_amd07 CLIPPED USING '&&&&&&&&&&',   #10(彙總營業稅額)
                  COLUMN 73,sr1.amd17 CLIPPED,'      ',               #1 (扣扺代號)
                  COLUMN 80,sr1.amd09 CLIPPED,                        #1 (匯加注記)
                 #COLUMN 81,sr1.amd10 CLIPPED                         #1 (洋菸酒注記)     #MOD-A30019 mark
                  COLUMN 81,sr1.amd10                                 #1 (洋菸酒注記)     #MOD-A30019 add
         END IF
      END IF
    END IF  #FUN-950013 add
END REPORT
 
FUNCTION p100_2()
   DEFINE l_name     LIKE type_file.chr20,        #No.FUN-680074 VARCHAR(20) # External(Disk) file name 
          l_sql      STRING,                      # RDSQL STATEMENT                #No.FUN-680074
          l_chr      LIKE type_file.chr1,         #No.FUN-680074 VARCHAR(1)
          l_za05     LIKE type_file.chr1000,      #No.FUN-680074 VARCHAR(40)    
          l_ame      RECORD LIKE ame_file.*,    #FUN-6B0056
          l_cnt      LIKE type_file.num5,   #FUN-6B0056
          l_idx      LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          sr2        RECORD
                       ama13   LIKE type_file.chr1,
                       filna   LIKE type_file.chr8,
                       ama02   LIKE type_file.chr8,
                       amd173  LIKE amd_file.amd173,
                       amd174  LIKE amd_file.amd174,
                       ama03   LIKE type_file.chr9,
                       ama15   LIKE type_file.chr1,
                       cps     LIKE type_file.num5,
                       a01     LIKE type_file.chr12,
                       a05     LIKE type_file.chr12,
                       a09     LIKE type_file.chr12,
                       a13     LIKE type_file.chr12,
                       a17     LIKE type_file.chr12,
                       a21     LIKE type_file.chr12,
                       a02     LIKE type_file.chr10,
                       a06     LIKE type_file.chr10,
                       a10     LIKE type_file.chr10,
                       a14     LIKE type_file.chr10,
                       a18     LIKE type_file.chr10,
                       a22     LIKE type_file.chr10,
                       a82     LIKE type_file.chr12,
                       a07     LIKE type_file.chr12,
                       a15     LIKE type_file.chr12,
                       a19     LIKE type_file.chr12,
                       a23     LIKE type_file.chr12,
                       a04     LIKE type_file.chr12,
                       a08     LIKE type_file.chr12,
                       a12     LIKE type_file.chr12,
                       a16     LIKE type_file.chr12,
                       a20     LIKE type_file.chr12,
                       a24     LIKE type_file.chr12,
                       a52     LIKE type_file.chr12,
                       a53     LIKE type_file.chr10,
                       a54     LIKE type_file.chr12,
                       a55     LIKE type_file.chr10,
                       a56     LIKE type_file.chr12,
                       a57     LIKE type_file.chr10,
                       a58     LIKE type_file.chr12,
                       a59     LIKE type_file.chr10,
                       a60     LIKE type_file.chr12,
                       a61     LIKE type_file.chr10,
                       a62     LIKE type_file.chr12,
                       a63     LIKE type_file.chr12,
                       a64     LIKE type_file.chr10,
                       a65     LIKE type_file.chr12,
                       a66     LIKE type_file.chr10,
                       a25     LIKE type_file.chr12,
                       a26     LIKE type_file.chr12,
                       a27     LIKE type_file.chr12,
                       a28     LIKE type_file.chr12,
                       a30     LIKE type_file.chr12,
                       a32     LIKE type_file.chr12,
                       a34     LIKE type_file.chr12,
                       a36     LIKE type_file.chr12,
                       a38     LIKE type_file.chr12,
                       a40     LIKE type_file.chr12,
                       a42     LIKE type_file.chr12,
                       a44     LIKE type_file.chr12,
                       a46     LIKE type_file.chr12,
                       a29     LIKE type_file.chr10,
                       a31     LIKE type_file.chr10,
                       a33     LIKE type_file.chr10,
                       a35     LIKE type_file.chr10,
                       a37     LIKE type_file.chr10,
                       a39     LIKE type_file.chr10,
                       a41     LIKE type_file.chr10,
                       a43     LIKE type_file.chr10,
                       a45     LIKE type_file.chr10,
                       a47     LIKE type_file.chr10,
                       a48     LIKE type_file.chr12,
                       a49     LIKE type_file.chr12,
                      #a50     LIKE type_file.chr3,      #MOD-A70149 mark
                       a50     STRING,                   #MOD-A70149
                       a51     LIKE type_file.chr10,
                       a78     LIKE type_file.chr12,
                       a80     LIKE type_file.chr12,
                       a73     LIKE type_file.chr12,
                       a74     LIKE type_file.chr12,
                       a79     LIKE type_file.chr10,
                       a81     LIKE type_file.chr10,
                       a75     LIKE type_file.chr10,
                       a76     LIKE type_file.chr10,
                       a101    LIKE type_file.chr10,
                       a103    LIKE type_file.chr10,
                       a104    LIKE type_file.chr10,
                       a105    LIKE type_file.chr10,
                       a106    LIKE type_file.chr10,
                       a107    LIKE type_file.chr10,
                       a108    LIKE type_file.chr10,
                       a109    LIKE type_file.chr10,
                       a110    LIKE type_file.chr10,
                       a111    LIKE type_file.chr10,
                       a112    LIKE type_file.chr10,
                       a113    LIKE type_file.chr10,
                       a114    LIKE type_file.chr10,
                       a115    LIKE type_file.chr10,
                       ama14   LIKE type_file.chr1,
                       ama16   LIKE ama_file.ama16,   #FUN-950013
                       ama17   LIKE ama_file.ama17,   #FUN-950013
                       ama18   LIKE ama_file.ama19,   #FUN-950013
                       ama19   LIKE ama_file.ama19,   #FUN-950013
                       ama20   LIKE ama_file.ama20,    #FUN-950013
                       ama21   LIKE ama_file.ama21,   #FUN-980024
                       ama22   LIKE ama_file.ama22    #FUN-980024
                     END RECORD
   DEFINE tmp        RECORD
                       a01     LIKE type_file.num10,
                       a05     LIKE type_file.num10,
                       a09     LIKE type_file.num10,
                       a13     LIKE type_file.num10,
                       a17     LIKE type_file.num10,
                       a21     LIKE type_file.num10,
                       a02     LIKE type_file.num10,
                       a06     LIKE type_file.num10,
                       a10     LIKE type_file.num10,
                       a14     LIKE type_file.num10,
                       a18     LIKE type_file.num10,
                       a22     LIKE type_file.num10,
                       a82     LIKE type_file.num10,
                       a07     LIKE type_file.num10,
                       a15     LIKE type_file.num10,
                       a19     LIKE type_file.num10,
                       a23     LIKE type_file.num10,
                       a04     LIKE type_file.num10,
                       a08     LIKE type_file.num10,
                       a12     LIKE type_file.num10,
                       a16     LIKE type_file.num10,
                       a20     LIKE type_file.num10,
                       a24     LIKE type_file.num10,
                       a52     LIKE type_file.num10,
                       a53     LIKE type_file.num10,
                       a54     LIKE type_file.num10,
                       a55     LIKE type_file.num10,
                       a56     LIKE type_file.num10,
                       a57     LIKE type_file.num10,
                       a58     LIKE type_file.num10,
                       a59     LIKE type_file.num10,
                       a60     LIKE type_file.num10,
                       a61     LIKE type_file.num10,
                       a62     LIKE type_file.num10,
                       a63     LIKE type_file.num10,
                       a64     LIKE type_file.num10,
                       a65     LIKE type_file.num10,
                       a66     LIKE type_file.num10,
                       a25     LIKE type_file.num10,
                       a26     LIKE type_file.num10,
                       a27     LIKE type_file.num10,
                       a28     LIKE type_file.num10,
                       a30     LIKE type_file.num10,
                       a32     LIKE type_file.num10,
                       a34     LIKE type_file.num10,
                       a36     LIKE type_file.num10,
                       a38     LIKE type_file.num10,
                       a40     LIKE type_file.num10,
                       a42     LIKE type_file.num10,
                       a44     LIKE type_file.num10,
                       a46     LIKE type_file.num10,
                       a29     LIKE type_file.num10,
                       a31     LIKE type_file.num10,
                       a33     LIKE type_file.num10,
                       a35     LIKE type_file.num10,
                       a37     LIKE type_file.num10,
                       a39     LIKE type_file.num10,
                       a41     LIKE type_file.num10,
                       a43     LIKE type_file.num10,
                       a45     LIKE type_file.num10,
                       a47     LIKE type_file.num10,
                       a48     LIKE type_file.num10,
                       a49     LIKE type_file.num10,
                      #a50     LIKE type_file.num10,        #MOD-A70149 mark
                       a50     LIKE type_file.num20_6,      #MOD-A70149
                      #a51     LIKE type_file.num10,        #MOD-A70149 mark
                       a51     LIKE type_file.num20_6,      #MOD-A70149
                       a78     LIKE type_file.num10,
                       a80     LIKE type_file.num10,
                       a73     LIKE type_file.num10,
                       a74     LIKE type_file.num10,
                       a79     LIKE type_file.num10,
                       a81     LIKE type_file.num10,
                       a75     LIKE type_file.num10,
                       a76     LIKE type_file.num10,
                       a101    LIKE type_file.num10,
                       a103    LIKE type_file.num10,
                       a104    LIKE type_file.num10,
                       a105    LIKE type_file.num10,
                       a106    LIKE type_file.num10,
                       a107    LIKE type_file.num10,
                       a108    LIKE type_file.num10,
                       a109    LIKE type_file.num10,
                       a110    LIKE type_file.num10,
                       a111    LIKE type_file.num10,
                       a112    LIKE type_file.num10,
                      #a113    LIKE type_file.num10,      #MOD-710100
                       a113    LIKE type_file.num20_6,    #MOD-710100
                       a114    LIKE type_file.num10,
                       a115    LIKE type_file.num10,
                       ama13   LIKE type_file.num10,
                       ama14   LIKE type_file.num10,
                       ama16   LIKE ama_file.ama16,   #FUN-950013                  
                       ama17   LIKE ama_file.ama17,   #FUN-950013                  
                       ama18   LIKE ama_file.ama18,   #FUN-950013                  
                       ama19   LIKE ama_file.ama19,   #FUN-950013                  
                       ama20   LIKE ama_file.ama20    #FUN-950013
                     END RECORD
   DEFINE l_amd171   LIKE amd_file.amd171
   DEFINE l_amd172   LIKE amd_file.amd172
   DEFINE l_amd173   LIKE amd_file.amd173
   DEFINE l_amd174   LIKE amd_file.amd174
   DEFINE l_amd17    LIKE amd_file.amd17
   DEFINE l_amd07    LIKE amd_file.amd07
   DEFINE l_amd08    LIKE amd_file.amd08
   DEFINE l_amd06_32 LIKE amd_file.amd06       #CHI-910039 add
   DEFINE l_amd06_31 LIKE amd_file.amd06       #CHI-910039 add
 #  DEFINE l_amd061_22_27 LIKE amd_file.amd06  #TQC-980112 add #CHI-A40039 mark
 #  DEFINE l_amd062_22_27 LIKE amd_file.amd06  #TQC-980112 add #CHI-A40039 mark
   DEFINE a36_22_27  LIKE type_file.num10      #TQC-980112 add
   DEFINE a01_31     LIKE type_file.num10      #CHI-910039 add
   DEFINE l_amd04    LIKE amd_file.amd04       #CHI-910039 add
   DEFINE i          LIKE type_file.num5
   DEFINE l_find     LIKE type_file.num5       #MOD-A70149
   DEFINE l_amd10    LIKE amd_file.amd10       #MOD-6B0059
   DEFINE l_tax      LIKE amd_file.amd07       #No.FUN-7B0132
   DEFINE l_msg      STRING   #No.FUN-7B0132
   DEFINE j,k,l_rec  LIKE type_file.num5       #CHI-950033
   DEFINE l_tmp      STRING                    #FUN-950013
   DEFINE l_file     LIKE type_file.chr100     #FUN-950013
   DEFINE l_file1    LIKE type_file.chr100     #FUN-950013
   DEFINE l_txt1     LIKE type_file.chr100     #FUN-950013
   DEFINE l_cmd      LIKE type_file.chr1000    #FUN-950013
   DEFINE ms_codeset STRING                    #FUN-950013
   #土地
   DEFINE tmp26     RECORD
                       a01     LIKE type_file.num10,
                       a05     LIKE type_file.num10,
                       a09     LIKE type_file.num10,
                       a13     LIKE type_file.num10,
                       a17     LIKE type_file.num10,
                       a21     LIKE type_file.num10,
                       a23     LIKE type_file.num10,
                       a25     LIKE type_file.num10,
                       a26     LIKE type_file.chr12
                     END RECORD
   DEFINE l_amd171_26   LIKE amd_file.amd171
   DEFINE l_amd172_26   LIKE amd_file.amd172
   DEFINE l_amd173_26   LIKE amd_file.amd173
   DEFINE l_amd174_26   LIKE amd_file.amd174
   DEFINE l_amd07_26    LIKE amd_file.amd07
   DEFINE l_amd08_26    LIKE amd_file.amd08
   DEFINE l_amd06_32_26 LIKE amd_file.amd06   
   DEFINE l_amd06_31_26 LIKE amd_file.amd06   
   DEFINE a01_31_26     LIKE type_file.num10  
   DEFINE l_amd04_26    LIKE amd_file.amd04  
   DEFINE l_amd10_26    LIKE amd_file.amd10
   #其他固定資產
   DEFINE tmp27     RECORD
                       a01     LIKE type_file.num10,
                       a05     LIKE type_file.num10,
                       a09     LIKE type_file.num10,
                       a13     LIKE type_file.num10,
                       a17     LIKE type_file.num10,
                       a21     LIKE type_file.num10,
                       a23     LIKE type_file.num10,
                       a25     LIKE type_file.num10,
                       a27     LIKE type_file.chr12
                    END RECORD
DEFINE l_amd171_27   LIKE amd_file.amd171
DEFINE l_amd172_27   LIKE amd_file.amd172
DEFINE l_amd173_27   LIKE amd_file.amd173
DEFINE l_amd174_27   LIKE amd_file.amd174
DEFINE l_amd07_27    LIKE amd_file.amd07
DEFINE l_amd08_27    LIKE amd_file.amd08
DEFINE l_amd06_32_27 LIKE amd_file.amd06   
DEFINE l_amd06_31_27 LIKE amd_file.amd06   
DEFINE a01_31_27     LIKE type_file.num10  
DEFINE l_amd04_27    LIKE amd_file.amd04  
DEFINE l_amd10_27    LIKE amd_file.amd10 
DEFINE l_sql26,l_sql27    STRING
DEFINE l_a48         LIKE type_file.num10      #MOD-980270 add
DEFINE l_a49         LIKE type_file.num10      #MOD-980270 add
#CHI-A40039 add --start--
DEFINE l_amd031          LIKE amd_file.amd03
DEFINE l_amd061_22_27_1  LIKE amd_file.amd06   #22:未稅金額
DEFINE l_amd061_22_27_2  LIKE amd_file.amd06   #22:4收據未稅
DEFINE l_amd061_22_27_t1 LIKE amd_file.amd06   #22:稅額
DEFINE l_amd061_22_27_t2 LIKE amd_file.amd06   #22:4收據稅額
DEFINE l_amd062_22_27_1  LIKE amd_file.amd06   #22:未稅金額
DEFINE l_amd062_22_27_2  LIKE amd_file.amd06   #22:4收據未稅
DEFINE l_amd062_22_27_t1 LIKE amd_file.amd06   #22:稅額
DEFINE l_amd062_22_27_t2 LIKE amd_file.amd06   #22:4收據稅額
#CHI-A40039 add --end--
DEFINE l_a50             LIKE type_file.num10  #FUN-B40063

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET l_name  = tm.rep CLIPPED,'.TET'
   LET g_name  = l_name   #FUN-6B0062
   SELECT UNIQUE zaa12 INTO g_page_line FROM zaa_file WHERE zaa01=g_prog
 
   START REPORT p100_rep2 TO l_name
 

   #輸入tm.ama01為ama15= '0'(單一機構)者無影響，產出單筆資料，金額為自己本身公司
   #輸入tm.ama01為ama15= '1'(總機構彙總申報)者，產出資料應有二筆
   #-->第一筆為ama15 = '2'資料，a101~a115資料應為0,且只有總公司自己的銷項/進項
   #-->第二筆為ama15 = '1'資料，a101~a115資料為進項及銷項合併金額(包含總公司及分公司)
   #輸入tm.ama01為ama15= '2'(各單位分別申報)者無影響，產出單筆資料，金額0

   LET i = 1
   LET j = 2
  
   #--FUN-B40063 start---#tm.upd = 'Y'時，單純只是更新直接扣抵法的"進項稅額分攤"及"國外勞務"欄位資料時，不產出報表，
   #只更新ama_file,迴圈不用跑二次，只要算出代號(29,31,33,35,37,39,41,43,45,47,50,74,79,81) 即可
   IF tm.upd = 'Y' THEN
       LET l_rec = i 
   ELSE
   #--FUN-B40063 end---
       #--當總繳代號為'1'時，產出的TET要有二筆資料---
       #--第一筆的總繳代號為'2'，第二筆則為'1'------
       IF g_ama15 = '1' THEN LET l_rec = j ELSE LET l_rec = i END IF
       #--判斷迴圈要跑二次或一次，總繳代號為'1'者，迴圈固定要二次----
   END IF   #FUN-B40063 add

   FOR k = 1 TO l_rec
 
       IF tm.upd = 'N' THEN      #FUN-B40063
           IF k = 1 THEN    #CHI-950033
               IF g_ama15 <> '1' THEN        #FUN-980090 add
                   LET sr2.ama15 = g_ama15
               ELSE
                   LET sr2.ama15 = '2' 
               END IF
           ELSE
               LET sr2.ama15 = '1'    #FUN-980090 mod
           END IF
      #--FUN-B40063 start
      ELSE
         LET sr2.ama15 = g_ama15
      END IF
      #--FUN-B40063 end---
     
      LET sr2.ama14 = g_ama14
      LET sr2.ama13 = g_ama13
      LET sr2.ama03 = g_ama03
      LET sr2.ama02 = g_ama02
      LET sr2.ama16 = g_ama16   #FUN-950013
      LET sr2.ama17 = g_ama17   #FUN-950013
      LET sr2.ama18 = g_ama18   #FUN-950013
      LET sr2.ama19 = g_ama19   #FUN-950013
      LET sr2.ama20 = g_ama20   #FUN-950013
      LET sr2.ama21 = g_ama21   #FUN-980024 
      LET sr2.ama22 = g_ama22   #FUN-980024 
      LET sr2.filna = '00000000'
 
      IF sr2.ama15 = '1' THEN  

         LET l_sql = 
             " SELECT COUNT(*) ",
             "   FROM amd_file JOIN ama_file ON amd22=ama01",
             "  WHERE amd173 = '",tm.byy,"'",
             "    AND amd174 BETWEEN '",tm.bmm,"' AND '",tm.emm,"'", 
             "    AND (amd171='31' or amd171='32' or amd171='35') ",  
             "    AND amd172 <> 'F' AND amd30='Y'",  #FUN-A10039
             "    AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))" 
         PREPARE p100_cnt_p1 FROM l_sql
         IF SQLCA.SQLCODE THEN CALL cl_err('cnt_p1',STATUS,0) END IF
         DECLARE p100_cnt_c1 CURSOR FOR p100_cnt_p1
         OPEN p100_cnt_c1 
         FETCH p100_cnt_c1 INTO sr2.cps
         CLOSE p100_cnt_c1
         
         LET l_sql = "SELECT 0,0,amd171,amd172,amd10,amd04,SUM(amd07),SUM(amd08)",  #MOD-6B0059  #CHI-910039 add amd04
                     "   FROM amd_file JOIN ama_file ON amd22=ama01 ", #FUN-980090
                     " WHERE amd173=",tm.byy,
                     "   AND amd174 BETWEEN ",tm.bmm," AND ",tm.emm,   #MOD-6B0059
                     "   AND amd171 LIKE '3%' ",
                     "   AND amd30 = 'Y' ",
                     "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))",   #FUN-980090 add
                     " GROUP BY amd171,amd172,amd10,amd04",  #CHI-910039 add amd04
                     " ORDER BY amd171,amd172,amd10,amd04"   #CHI-910039 add amd04
      ELSE
         SELECT COUNT(*) INTO sr2.cps FROM amd_file
          WHERE amd173 = tm.byy
            AND amd174 BETWEEN tm.bmm AND tm.emm
            AND (amd171='31' or amd171='32' or amd171='35')
            AND amd22 = tm.ama01
            AND amd172 <> 'F' AND amd30='Y'   #MOD-920197 #FUN-A10039
 
         LET l_sql = "SELECT 0,0,amd171,amd172,amd10,amd04,SUM(amd07),SUM(amd08)",  #CHI-910039 add amd04
                     "  FROM amd_file ",
                     " WHERE amd173=",tm.byy,
                     "   AND amd174 BETWEEN ",tm.bmm," AND ",tm.emm,
                     "   AND amd171 LIKE '3%' ",
                     "   AND amd30 = 'Y' ",
                     "   AND amd22 = '",tm.ama01,"'",
                     " GROUP BY amd171,amd172,amd10,amd04",  #CHI-910039 add amd04
                     " ORDER BY amd171,amd172,amd10,amd04"   #CHI-910039 add amd04
      END IF
      PREPARE p1002_prepare FROM l_sql
      IF SQLCA.SQLCODE THEN CALL cl_err('prepare2',STATUS,0) END IF
      DECLARE p1002_curs CURSOR FOR p1002_prepare
      
      LET l_amd06_31=0   LET l_amd06_32=0   #CHI-910039 add
      FOREACH p1002_curs INTO l_amd173,l_amd174,l_amd171,l_amd172,
                              l_amd10,l_amd04,   #MOD-6B0059  #CHI-910039 add l_amd04
                              l_amd07,l_amd08
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach2:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         LET l_amd173=tm.byy   #MOD-6B0059
         LET l_amd174=tm.emm   #MOD-6B0059
      
         LET sr2.amd173= l_amd173   #No.MOD-6B0041
         LET sr2.amd174= l_amd174   #No.MOD-6B0041
 
         IF cl_null(l_amd07) THEN LET l_amd07 = 0 END IF
         IF cl_null(l_amd08) THEN LET l_amd08 = 0 END IF
         IF cl_null(l_amd06_31) THEN LET l_amd06_31 = 0 END IF  #CHI-910039 add
         IF cl_null(l_amd06_32) THEN LET l_amd06_32 = 0 END IF  #CHI-910039 add
      
         CASE l_amd172     #課稅別
            WHEN "1"
               CASE l_amd171   #格式
                  WHEN "35"
                     LET tmp.a05 = tmp.a05 + l_amd08
                     LET tmp.a06 = tmp.a06 + l_amd07
                  WHEN "32"
                     LET l_amd06_32 = l_amd06_32 + l_amd08 + l_amd07  #CHI-910039 add
                  WHEN "36"
                     LET tmp.a13 = tmp.a13 + l_amd08
                     LET tmp.a14 = tmp.a14 + l_amd07
                  WHEN "33"
                     LET tmp.a17 = tmp.a17 + l_amd08
                     LET tmp.a18 = tmp.a18 + l_amd07
                  WHEN "34"
                     LET tmp.a17 = tmp.a17 + l_amd08
                     LET tmp.a18 = tmp.a18 + l_amd07
               END CASE
               IF l_amd171 = '33' OR l_amd171 = '34' THEN
                  LET tmp.a21 = tmp.a21 - l_amd08
                  LET tmp.a22 = tmp.a22 - l_amd07
               ELSE
                  LET tmp.a21 = tmp.a21 + l_amd08
                  LET tmp.a22 = tmp.a22 + l_amd07
               END IF
               IF l_amd171 ='31' AND cl_null(l_amd04) THEN
                  LET l_amd06_31 = l_amd06_31 + l_amd08 +l_amd07            
               END IF
               IF l_amd171='31' AND NOT cl_null(l_amd04) THEN
                  LET tmp.a01 = tmp.a01 + l_amd08
                  LET tmp.a02 = tmp.a02 + l_amd07
               END IF
            WHEN "2"
               CASE l_amd10
                  WHEN '1'
                     LET tmp.a07 = tmp.a07 + l_amd08
                     LET tmp.a23 = tmp.a23 + l_amd08   #MOD-710084
                  WHEN '2'
                     LET tmp.a15 = tmp.a15 + l_amd08
                     LET tmp.a23 = tmp.a23 + l_amd08   #MOD-710084
               END CASE
               CASE l_amd171
                  WHEN '33'
                     LET tmp.a19 = tmp.a19 + l_amd08
                     LET tmp.a23 = tmp.a23 - l_amd08
                  WHEN '34'
                     LET tmp.a19 = tmp.a19 + l_amd08
                     LET tmp.a23 = tmp.a23 - l_amd08
               END CASE
            WHEN "3"
               CASE l_amd171   #格式
                  WHEN "31"
                     LET tmp.a04 = tmp.a04 + l_amd08
                  WHEN "35"
                     LET tmp.a08 = tmp.a08 + l_amd08
                  WHEN "32"
                     LET tmp.a12 = tmp.a12 + l_amd08
                  WHEN "36"
                     LET tmp.a16 = tmp.a16 + l_amd08
                  WHEN "33"
                     LET tmp.a20 = tmp.a20 + l_amd08
                     LET l_amd08 = l_amd08 * -1         #No.MOD-B70184 add
                  WHEN "34"
                     LET tmp.a20 = tmp.a20 + l_amd08
                     LET l_amd08 = l_amd08 * -1         #No.MOD-B70184 add
               END CASE
               LET tmp.a24 = tmp.a24 + l_amd08
         END CASE
      END FOREACH
 
      IF sr2.ama15 = '1' THEN #FUN-980090 mod
         LET l_sql = "SELECT 0,0,amd171,amd17,amd031,SUM(amd07),SUM(amd08)",   #MOD-6B0059 #CHI-A40039 add amd031
                     "  FROM amd_file JOIN ama_file ON amd22=ama01 ", #FUN-980090
                     " WHERE amd173=",tm.byy,
                     "   AND amd174 BETWEEN ",tm.bmm," AND ",tm.emm,   #MOD-6B0059
                     "   AND amd171 LIKE '2%' ",
                     "   AND amd30 = 'Y' ",
                     "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))",   #FUN-980090 add
                     " GROUP BY amd171,amd17,amd031",  #CHI-A40039 add amd031
                     " ORDER BY amd171,amd17,amd031"   #CHI-A40039 add amd031
      ELSE
         LET l_sql = "SELECT 0,0,amd171,amd17,amd031,SUM(amd07),SUM(amd08)",  #CHI-A40039 add amd031
                     "  FROM amd_file ",
                     " WHERE amd173=",tm.byy,
                     "   AND amd174 BETWEEN ",tm.bmm," AND ",tm.emm,
                     "   AND amd171 LIKE '2%' ",
                     "   AND amd30 = 'Y' ",
                     "   AND amd22 = '",tm.ama01,"'",
                     " GROUP BY amd171,amd17,amd031",  #CHI-A40039 add amd031
                     " ORDER BY amd171,amd17,amd031"   #CHI-A40039 add amd031
      END IF
      PREPARE p1002_prepare1 FROM l_sql
      IF SQLCA.SQLCODE THEN CALL cl_err('prepare21',STATUS,0) END IF
      DECLARE p1002_curs1 CURSOR FOR p1002_prepare1
 
      #LET l_amd061_22_27=0   #TQC-980112 add #CHI-A40039 mark
      #LET l_amd062_22_27=0   #TQC-980112 add #CHI-A40039 mark
      LET l_a48 = 0          #MOD-980270 add
      LET l_a49 = 0          #MOD-980270 add

     #CHI-A40039 add --start--
      LET l_amd061_22_27_1 = 0
      LET l_amd061_22_27_2 = 0
      LET l_amd061_22_27_t1= 0
      LET l_amd061_22_27_t2= 0
      LET l_amd062_22_27_1 = 0
      LET l_amd062_22_27_2 = 0
      LET l_amd062_22_27_t1= 0
      LET l_amd062_22_27_t2= 0
     #CHI-A40039 add --end--

      FOREACH p1002_curs1 INTO l_amd173,l_amd174,l_amd171,l_amd17,l_amd031,l_amd07,l_amd08 #CHI-A40039 add l_amd031
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach21:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         LET l_amd173=tm.byy   #MOD-6B0059
         LET l_amd174=tm.emm   #MOD-6B0059
      
         IF cl_null(l_amd07) THEN LET l_amd07=0 END IF
         IF cl_null(l_amd08) THEN LET l_amd08=0 END IF
         #IF cl_null(l_amd061_22_27) THEN LET l_amd061_22_27=0 END IF  #TQC-980112 add #CHI-A40039 mark
         #IF cl_null(l_amd062_22_27) THEN LET l_amd062_22_27=0 END IF  #TQC-980112 add #CHI-A40039 mark
      
        #CHI-A40039 add --start--
         IF cl_null(l_amd061_22_27_1) THEN LET l_amd061_22_27_1=0 END IF
         IF cl_null(l_amd061_22_27_2) THEN LET l_amd061_22_27_2=0 END IF
         IF cl_null(l_amd062_22_27_1) THEN LET l_amd062_22_27_1=0 END IF
         IF cl_null(l_amd062_22_27_2) THEN LET l_amd062_22_27_2=0 END IF
        #CHI-A40039 add --end--

         CASE l_amd17    #扣抵區分
            WHEN "1"
               CASE l_amd171   #格式
                  WHEN "21"
                     LET tmp.a28 = tmp.a28 + l_amd08
                     LET tmp.a29 = tmp.a29 + l_amd07
                  WHEN "25"
                     LET tmp.a32 = tmp.a32 + l_amd08
                     LET tmp.a33 = tmp.a33 + l_amd07
                 WHEN "22"
                    #LET l_amd061_22_27 = l_amd061_22_27 + l_amd08 + l_amd07  #TQC-980112 add  #CHI-A40039 mark

                    #CHI-A40039 add --start--
                    IF l_amd031 = '4' THEN
                       LET l_amd061_22_27_2 = l_amd061_22_27_2 + l_amd08
                       LET l_amd061_22_27_t2= l_amd061_22_27_t2+ l_amd07
                    ELSE
                       LET l_amd061_22_27_1 = l_amd061_22_27_1 + l_amd08 + l_amd07
                    END IF
                    #CHI-A40039 add --end--

                 WHEN "26"
                    LET tmp.a28 = tmp.a28 + l_amd08   #MOD-980183 mod a36->a28
                    LET tmp.a29 = tmp.a29 + l_amd07   #MOD-980183 mod a37->a29
                 WHEN "27"
                    #LET l_amd061_22_27 = l_amd061_22_27 + l_amd08 + l_amd07  #TQC-980112 add  #CHI-A40039 mark

                    #CHI-A40039 add --start--
                    IF l_amd031 = '4' THEN
                       LET l_amd061_22_27_2 = l_amd061_22_27_2 + l_amd08
                       LET l_amd061_22_27_t2= l_amd061_22_27_t2+ l_amd07
                    ELSE
                       LET l_amd061_22_27_1 = l_amd061_22_27_1 + l_amd08 + l_amd07
                    END IF
                    #CHI-A40039 add --end--

                 WHEN "23"
                    LET tmp.a40 = tmp.a40 + l_amd08
                    LET tmp.a41 = tmp.a41 + l_amd07
                 WHEN "24"
                    LET tmp.a40 = tmp.a40 + l_amd08
                    LET tmp.a41 = tmp.a41 + l_amd07
                 WHEN "29"
                    LET tmp.a40 = tmp.a40 + l_amd08
                    LET tmp.a41 = tmp.a41 + l_amd07
                  WHEN "28"
                     LET tmp.a78 = tmp.a78 + l_amd08
                     LET tmp.a79 = tmp.a79 + l_amd07
               END CASE
            WHEN "2"
               CASE l_amd171   #格式
                  WHEN "21"
                     LET tmp.a30 = tmp.a30 + l_amd08
                     LET tmp.a31 = tmp.a31 + l_amd07
                  WHEN "25"
                     LET tmp.a34 = tmp.a34 + l_amd08
                     LET tmp.a35 = tmp.a35 + l_amd07
                  WHEN "22"
                     #LET l_amd062_22_27 = l_amd062_22_27 + l_amd08 + l_amd07  #TQC-980112 add  #CHI-A40039 mark

                    #CHI-A40039 add --start--
                     IF l_amd031 = '4' THEN
                        LET l_amd062_22_27_2 = l_amd062_22_27_2 + l_amd08
                        LET l_amd062_22_27_t2= l_amd062_22_27_t2+ l_amd07
                     ELSE
                        LET l_amd062_22_27_1 = l_amd062_22_27_1 + l_amd08 + l_amd07
                     END IF
                    #CHI-A40039 add --end--

                  WHEN "26"
                     LET tmp.a30 = tmp.a30 + l_amd08   #MOD-980183 mod a38->a30
                     LET tmp.a31 = tmp.a31 + l_amd07   #MOD-980183 mod a39->a31
                  WHEN "27"
                     #LET l_amd062_22_27 = l_amd062_22_27 + l_amd08 + l_amd07  #TQC-980112 add  #CHI-A40039 mark

                    #CHI-A40039 add --start--
                     IF l_amd031 = '4' THEN
                        LET l_amd062_22_27_2 = l_amd062_22_27_2 + l_amd08
                        LET l_amd062_22_27_t2= l_amd062_22_27_t2+ l_amd07
                     ELSE
                        LET l_amd062_22_27_1 = l_amd062_22_27_1 + l_amd08 + l_amd07
                     END IF
                    #CHI-A40039 add --end--

                  WHEN "23"
                     LET tmp.a42 = tmp.a42 + l_amd08
                     LET tmp.a43 = tmp.a43 + l_amd07
                  WHEN "24"
                     LET tmp.a42 = tmp.a42 + l_amd08
                     LET tmp.a43 = tmp.a43 + l_amd07
                  WHEN "28"
                     LET tmp.a80 = tmp.a80 + l_amd08
                     LET tmp.a81 = tmp.a81 + l_amd07
               END CASE
            WHEN "3"
               IF l_amd171 <> '23' AND l_amd171 <> '24' AND
                  l_amd171 <> '29'  THEN
                  LET l_a48 = l_a48 + l_amd08
               ELSE
                  LET l_a48 = l_a48 - l_amd08
               END IF
            WHEN "4"
               IF l_amd171 <> '23' AND l_amd171 <> '24' AND
                  l_amd171 <> '29'  THEN
                  LET l_a49 = l_a49 + l_amd08
               ELSE
                  LET l_a49 = l_a49 - l_amd08
               END IF
         END CASE
 
      END FOREACH
      CALL cl_digcut((l_amd06_32/1.05),0) RETURNING tmp.a09
     #CALL cl_digcut((tmp.a09*0.05),0) RETURNING tmp.a10   #MOD-980183      #MOD-B10199 mark
      CALL cl_digcut(((l_amd06_32/1.05)*0.05),0) RETURNING tmp.a10          #MOD-B10199 
      CALL cl_digcut((l_amd06_31/1.05),0) RETURNING a01_31
      LET tmp.a01=tmp.a01+a01_31
      LET tmp.a02=tmp.a02+l_amd06_31-a01_31
      LET tmp.a21=tmp.a01+tmp.a05+tmp.a09+tmp.a13-tmp.a17
      LET tmp.a22=tmp.a02+tmp.a06+tmp.a10+tmp.a14-tmp.a18

    #str MOD-A10085 mod   #移動程式碼位置
     #CHI-A40039 mark --start--
     ##a36包含格式22/27資料,22/27需用倒推算出未稅金額,再以未稅金額*0.05算出稅額
     # CALL cl_digcut((l_amd061_22_27/1.05),0) RETURNING tmp.a36   #MOD-980183 mod  #a36_22_27
     # CALL cl_digcut((l_amd062_22_27/1.05),0) RETURNING tmp.a38   #MOD-980183 mod  #a36_22_27
     # LET tmp.a37=cl_digcut((tmp.a36*0.05),0)       #22/27未稅金額*0.05                    #MOD-980183  #MOD-980270 mod
     # LET tmp.a39=cl_digcut((tmp.a38*0.05),0)       #22/27未稅金額*0.05                    #MOD-980183  #MOD-980270 mod
     #CHI-A40039 mark --end--

    #CHI-A40039 add --start--
    #格式22和27採內含稅或是分稅垂直
    #a37內含稅-稅額
     CALL cl_digcut(((l_amd061_22_27_1/1.05)*0.05),0) RETURNING l_amd061_22_27_t1
    #a36內含稅-未稅金額
     CALL cl_digcut((l_amd061_22_27_1/1.05),0) RETURNING l_amd061_22_27_1
    #a36分稅-未稅金額
     CALL cl_digcut(l_amd061_22_27_2,0) RETURNING  l_amd061_22_27_2
    #a37分稅-稅額
     CALL cl_digcut(l_amd061_22_27_t2,0) RETURNING  l_amd061_22_27_t2
     LET tmp.a36 = l_amd061_22_27_1 + l_amd061_22_27_2
     LET tmp.a37= l_amd061_22_27_t1 + l_amd061_22_27_t2
    #a39內含稅-稅額
     CALL cl_digcut(((l_amd062_22_27_1/1.05)*0.05),0) RETURNING l_amd062_22_27_t1
    #a38內含稅-未稅金額
     CALL cl_digcut((l_amd062_22_27_1/1.05),0) RETURNING l_amd062_22_27_1
    #a38分稅-未稅金額
     CALL cl_digcut(l_amd062_22_27_2,0) RETURNING  l_amd062_22_27_2
    #a39分稅-稅額
     CALL cl_digcut(l_amd062_22_27_t2,0) RETURNING  l_amd062_22_27_t2
     LET tmp.a38 = l_amd062_22_27_1 + l_amd062_22_27_2
     LET tmp.a39= l_amd062_22_27_t1 + l_amd062_22_27_t2
    #CHI-A40039 add --end--

      LET tmp.a44 = tmp.a28+tmp.a32+tmp.a36+tmp.a78-tmp.a40
      LET tmp.a45 = tmp.a29+tmp.a33+tmp.a37+tmp.a79-tmp.a41
      LET tmp.a46 = tmp.a30+tmp.a34+tmp.a38+tmp.a80-tmp.a42
      LET tmp.a47 = tmp.a31+tmp.a35+tmp.a39+tmp.a81-tmp.a43
      LET tmp.a48 = tmp.a44+l_a48
      LET tmp.a49 = tmp.a46+l_a49
    #end MOD-A10085 mod   #移動程式碼位置
     #----------------------------------MOD-C10106 移至2021行--------------------start 
     #IF sr2.ama15 = '2' THEN
     #    LET tmp.a101 = 0
     #    LET tmp.a103 = 0
     #    LET tmp.a104 = 0
     #    LET tmp.a105 = 0
     #ELSE
     #    LET tmp.a101 = tmp.a22
     #END IF

     #LET tmp.a106 = tmp.a101 + tmp.a103 + tmp.a104 + tmp.a105
     #----------------------------------MOD-C10106---------------------------------end
     #-----------------------------MOD-BC0301--------------------------start
      LET tmp.a25 = tmp.a21 + tmp.a23 + tmp.a24 + tmp.a65
      LET tmp.a50 = ((tmp.a24 + tmp.a65) - tmp.a26) / (tmp.a25 - tmp.a26)
      LET tmp.a50 = s_trunc(tmp.a50,2)
      LET tmp.a50 = tmp.a50 * 100
      IF tm.deduct = '1' THEN
         LET tmp.a51 = (tmp.a45 + tmp.a47) * (1 - tmp.a50)
      ELSE
         LET tmp.a51 = g_amk.amk76
      END IF
      LET tmp.a51 = cl_digcut(tmp.a51,0)
     #-----------------------------MOD-BC0301----------------------------end

      IF sr2.ama15 = '2' THEN
          LET tmp.a107 = 0
      ELSE
          IF sr2.ama13 = '1' THEN               #MOD-BC0301 add
             LET tmp.a107 = tmp.a47 + tmp.a45
         #-------------------MOD-BC0301-------------------start
          ELSE
             IF sr2.ama13 = '3' THEN
                LET tmp.a107 = tmp.a51
             END IF
          END IF
         #-------------------MOD-BC0301---------------------end
      END IF                #CHI-950033 add
      
     #SELECT ame07,ame08,ame06 INTO tmp.a108,tmp.a73,tmp.a74 FROM ame_file                   #MOD-BC0301 mark
     #SELECT ame07,ame08,ame06,ame11 INTO tmp.a108,tmp.a73,tmp.a74,tmp.a109 FROM ame_file    #MOD-BC0301 add #MOD-C10106 mark
      SELECT ame07,ame08,ame06,ame11,ame10                             #MOD-C10106 add
        INTO tmp.a108,tmp.a73,tmp.a74,tmp.a109,tmp.a105                #MOD-C10106 add
        FROM ame_file                                                  #MOD-C10106 add
        WHERE ame01= tm.ama01 AND
              ame02= tm.byy AND
              ame03= tm.emm
      IF cl_null(tmp.a108) THEN LET tmp.a108 = 0 END IF
     #----------------------------------MOD-C10106--------------------start
      IF sr2.ama15 = '2' THEN
          LET tmp.a101 = 0
          LET tmp.a103 = 0
          LET tmp.a104 = 0
          LET tmp.a105 = 0
      ELSE
          LET tmp.a101 = tmp.a22
      END IF
     #--------------------------------MOD-C10166----------------------start
      IF tm.deduct = '2' THEN
         LET tmp.a74 = g_amk.amk78
         LET tmp.a76 = g_amk.amk82
         LET tmp.a103 = g_amk.amk82
      END IF
     #--------------------------------MOD-C10166------------------------end
     #LET tmp.a106 = tmp.a101 + tmp.a103 + tmp.a104 + tmp.a105   #MOD-C20129移至2054行
     #----------------------------------MOD-C10106----------------------end
      IF sr2.ama13 = '1' THEN                                    #MOD-BC0301 add
         LET tmp.a51 = 0                                         #MOD-C10166 add
         LET tmp.a74 = 0                                         #MOD-C10166 add
         LET tmp.a76 = 0                                         #MOD-C10166 add
         LET tmp.a106 = 0                                        #MOD-C10166 add
         LET tmp.a103 = 0                                        #MOD-C10166 add
         LET tmp.a104 = 0                                        #MOD-C20129 add
         LET tmp.a105 = 0                                        #MOD-C20129 add
         LET tmp.a109 = 0                                        #MOD-BC0301 add
      END IF                                                     #MOD-BC0301 add
      LET tmp.a106 = tmp.a101 + tmp.a103 + tmp.a104 + tmp.a105   #MOD-C20129 add
      IF sr2.ama15 = '2' THEN  
          LET tmp.a108 = 0  
          LET tmp.a109 = 0
      ELSE
          LET tmp.a108 = tmp.a108
          LET tmp.a109 = tmp.a109
      END IF
      IF cl_null(tmp.a73) THEN LET tmp.a73 = 0 END IF
      IF cl_null(tmp.a74) THEN LET tmp.a74 = 0 END IF
      LET tmp.a110 = tmp.a107 + tmp.a108 + tmp.a109
      LET tmp.a111 = tmp.a106 - tmp.a110
      IF sr2.ama15 = '2' THEN  
         LET tmp.a111 = 0   
      ELSE
         LET tmp.a111 = tmp.a111
      END IF
      IF tmp.a111 > 0 THEN
         LET tmp.a112 = 0
         LET tmp.a113 = 0    #MOD-930145        
      ELSE
         LET tmp.a111 = 0
         LET tmp.a112 = tmp.a110 - tmp.a106
         LET tmp.a113 = tmp.a23 * 0.05 + tmp.a47    #MOD-930145
         LET tmp.a113 = cl_digcut(tmp.a113,0)       #MOD-930145
      END IF
      IF sr2.ama15 = '2' THEN  
         LET tmp.a111 = 0   
         LET tmp.a112 = 0 
         LET tmp.a113 = 0
      ELSE
         LET tmp.a111 = tmp.a111
         LET tmp.a112 = tmp.a112
         LET tmp.a113 = tmp.a113
      END IF

      IF sr2.ama13 <> '3' THEN                  #MOD-A70149 
         LET tmp.a25 = tmp.a21 + tmp.a23
      END IF                                    #MOD-A70149
      IF tmp.a112 > tmp.a113 THEN
         LET tmp.a114 = tmp.a113
      ELSE
         LET tmp.a114 = tmp.a112
      END IF
      LET tmp.a115 = tmp.a112 - tmp.a114
      IF sr2.ama15 = '2' THEN  
         LET tmp.a114 = 0
         LET tmp.a115 = 0
      ELSE
         LET tmp.a114 = tmp.a114
         LET tmp.a115 = tmp.a115
      END IF
 
       #-------土地金額計算 -------#
       IF sr2.ama13 = '3' THEN                   #MOD-A70103
          IF sr2.ama15 = '1' THEN   #FUN-980090 mod

             LET l_sql = 
                 " SELECT COUNT(*) ",
                 "   FROM amd_file JOIN ama_file ON amd22=ama01", #FUN-980090 add
                 "  WHERE amd173 = '",tm.byy,"'",
                 "    AND amd174 BETWEEN '",tm.bmm,"' AND '",tm.emm,"'", 
                 "    AND (amd171='31' or amd171='32' or amd171='35') ",  
                 "    AND amd172 <> 'F' AND amd30='Y'",  #FUN-A10039
                 "    AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))" 
             PREPARE p100_cnt_p2 FROM l_sql
             IF SQLCA.SQLCODE THEN CALL cl_err('cnt_p2',STATUS,0) END IF
             DECLARE p100_cnt_c2 CURSOR FOR p100_cnt_p2
             OPEN p100_cnt_c2 
             FETCH p100_cnt_c2 INTO sr2.cps
             CLOSE p100_cnt_c2
          ELSE
             SELECT COUNT(*) INTO sr2.cps FROM amd_file
              WHERE amd173 = tm.byy
                AND amd174 BETWEEN tm.bmm AND tm.emm
                AND (amd171='31' or amd171='32' or amd171='35')
                AND amd22 = tm.ama01 
                AND amd172 <> 'F' AND amd30='Y'  #FUN-A10039
          END IF
          
          LET l_sql26 = "SELECT 0,0,amd171,amd172,amd10,amd04,SUM(amd07),SUM(amd08)", 
                        "  FROM amd_file ",
                        " WHERE amd173=",tm.byy,
                        "   AND amd174 BETWEEN ",tm.bmm," AND ",tm.emm,
                        "   AND amd171 LIKE '3%' ",
                        "   AND amd30 = 'Y' ",
                        "   AND amd22 = '",tm.ama01,"'",
                        "   AND amd44 = '1' ",  #土地
                        " GROUP BY amd171,amd172,amd10,amd04",
                        " ORDER BY amd171,amd172,amd10,amd04"  
          PREPARE p1002_pre_26 FROM l_sql26
          IF SQLCA.SQLCODE THEN CALL cl_err('prepare2',STATUS,0) END IF
          DECLARE p1002_curs_26 CURSOR FOR p1002_pre_26
          
          LET l_amd06_31_26=0   LET l_amd06_32_26=0 
          FOREACH p1002_curs_26 INTO l_amd173_26,l_amd174_26,l_amd171_26,l_amd172_26,
                                     l_amd10_26,l_amd04_26,   
                                     l_amd07_26,l_amd08_26
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach2:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
          
              LET l_amd173_26=tm.byy   
              LET l_amd174_26=tm.emm  
         
              IF cl_null(l_amd07_26) THEN LET l_amd07_26 = 0 END IF
              IF cl_null(l_amd08_26) THEN LET l_amd08_26 = 0 END IF
              IF cl_null(l_amd06_31_26) THEN LET l_amd06_31_26 = 0 END IF  
              IF cl_null(l_amd06_32_26) THEN LET l_amd06_32_26 = 0 END IF 
          
              CASE l_amd172_26 
                 WHEN "1"
                    CASE l_amd171_26 
                       WHEN "35"
                          LET tmp26.a05 = tmp26.a05 + l_amd08_26
                       WHEN "32"
                          LET l_amd06_32_26 = l_amd06_32_26 + l_amd08_26 + l_amd07_26 
                       WHEN "36"
                          LET tmp26.a13 = tmp26.a13 + l_amd08_26
                       WHEN "33"
                          LET tmp26.a17 = tmp26.a17 + l_amd08_26
                       WHEN "34"
                          LET tmp26.a17 = tmp26.a17 + l_amd08_26
                    END CASE
                    IF l_amd171_26 = '33' OR l_amd171_26 = '34' THEN
                        LET tmp26.a21 = tmp26.a21 - l_amd08_26
                    ELSE
                       LET tmp26.a21 = tmp26.a21 + l_amd08_26
                    END IF
                    IF l_amd171_26 ='31' AND cl_null(l_amd04_26) THEN
                       LET l_amd06_31_26 = l_amd06_31_26 + l_amd08_26 +l_amd07_26            
                    END IF
                    IF l_amd171_26='31' AND NOT cl_null(l_amd04_26) THEN
                       LET tmp26.a01 = tmp26.a01 + l_amd08_26
                    END IF
                 WHEN "2"
                    CASE l_amd10_26
                       WHEN '1'
                          LET tmp26.a23 = tmp26.a23 + l_amd08_26  
                       WHEN '2'
                          LET tmp26.a23 = tmp26.a23 + l_amd08_26 
                    END CASE
                    CASE l_amd171_26
                       WHEN '33'
                          LET tmp26.a23 = tmp26.a23 - l_amd08_26
                       WHEN '34'
                          LET tmp26.a23 = tmp26.a23 - l_amd08_26
                    END CASE
                #-MOD-A70149-add-
                 WHEN "3"
                    CASE l_amd10_26
            	       WHEN '1'
               	          LET tmp.a26 = tmp.a24 
            	       WHEN '2'
            	          LET tmp.a26 = tmp.a24
                        END CASE
                    CASE l_amd171_26
            	       WHEN '32'
            	          LET tmp.a26 = tmp.a24
            	       WHEN '33'
            	          LET tmp.a26 = tmp.a24 
                           WHEN '34'
            	          LET tmp.a26 = tmp.a24 
       	            END CASE
                #-MOD-A70149-end-
                END CASE
          END FOREACH
        #-MOD-BC0301----------mark 移至1984行
        ##-MOD-A70149-add-
        # LET tmp.a25 = tmp.a21 + tmp.a23 + tmp.a24 + tmp.a65
        # LET tmp.a50 = ((tmp.a24 + tmp.a65) - tmp.a26) / (tmp.a25 - tmp.a26)
        # LET tmp.a50 = s_trunc(tmp.a50,2)             #No.MOD-B70184 add
        # LET tmp.a51 = (tmp.a45 + tmp.a47) * (1 - tmp.a50)
        # LET tmp.a51 = cl_digcut(tmp.a51,0)
        # LET tmp.a50 = tmp.a50 * 100
        # LET tmp.a107 = tmp.a51
        ##-MOD-A70149-end-
        #-MOD-BC0301----------mark
          
          CALL cl_digcut((l_amd06_32_26/1.05),0) RETURNING tmp26.a09
          CALL cl_digcut((l_amd06_31_26/1.05),0) RETURNING a01_31_26
          LET tmp26.a01=tmp26.a01+a01_31_26
          LET tmp26.a21=tmp26.a01+tmp26.a05+tmp26.a09+tmp26.a13-tmp26.a17
          LET tmp26.a25 = tmp26.a21 + tmp26.a23      #土地金額
          
          #------------其他固定資產--------#
         #MOD-A40070---modify---start---
         #IF tm.e = 'Y' THEN   
         #     SELECT COUNT(*) INTO sr2.cps FROM amd_file
         #      WHERE amd173 = tm.byy
         #        AND amd174 BETWEEN tm.bmm AND tm.emm   
         #        AND (amd171='31' or amd171='32' or amd171='35') 
         #        AND amd172 <> 'F' AND amd30='Y'   #FUN-A10039 D-->F
          IF sr2.ama15 = '1' THEN 
               LET l_sql = 
                   " SELECT COUNT(*) ",
                   "   FROM amd_file JOIN ama_file ON amd22=ama01",
                   "  WHERE amd173 = '",tm.byy,"'",
                   "    AND amd174 BETWEEN '",tm.bmm,"' AND '",tm.emm,"'", 
                   "    AND (amd171='31' or amd171='32' or amd171='35') ",  
                   "    AND amd172 <> 'F' AND amd30='Y'",  #FUN-A10039 D-->F
                   "    AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))" 
               PREPARE p100_cnt_p3 FROM l_sql
               IF SQLCA.SQLCODE THEN CALL cl_err('cnt_p3',STATUS,0) END IF
               DECLARE p100_cnt_c3 CURSOR FOR p100_cnt_p3
               OPEN p100_cnt_c3 
               FETCH p100_cnt_c3 INTO sr2.cps
               CLOSE p100_cnt_c3
         #MOD-A40070---modify---end---
               LET l_sql27 = "SELECT 0,0,amd171,amd172,amd10,amd04,SUM(amd07),SUM(amd08)",
                            #"  FROM amd_file ",                                              #MOD-BB0216 mark
                             "  FROM amd_file,ama_file",                                      #MOD-BB0216 add
                             " WHERE amd173=",tm.byy,
                             "   AND amd174 BETWEEN ",tm.bmm," AND ",tm.emm,  
                             "   AND amd171 LIKE '3%' ",
                             "   AND amd30 = 'Y' ",
                             "   AND amd44 = '2' ", #固定資產
                             "   AND amd22=ama01 ",                                            #MOD-BB0216 add
                             "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))",   #MOD-A40070 add
                             " GROUP BY amd171,amd172,amd10,amd04", 
                             " ORDER BY amd171,amd172,amd10,amd04"  
          ELSE
             SELECT COUNT(*) INTO sr2.cps FROM amd_file
              WHERE amd173 = tm.byy
                AND amd174 BETWEEN tm.bmm AND tm.emm
                AND (amd171='31' or amd171='32' or amd171='35')
                AND amd22 = tm.ama01 
                AND amd172 <> 'F' AND amd30='Y'  #FUN-A10039
          
             LET l_sql27 = "SELECT 0,0,amd171,amd172,amd10,amd04,SUM(amd07),SUM(amd08)", 
                           "  FROM amd_file ",
                           " WHERE amd173=",tm.byy,
                           "   AND amd174 BETWEEN ",tm.bmm," AND ",tm.emm,
                           "   AND amd171 LIKE '3%' ",
                           "   AND amd30 = 'Y' ",
                           "   AND amd22 = '",tm.ama01,"'",
                           "   AND amd44 = '2' ",  #固定資產
                           " GROUP BY amd171,amd172,amd10,amd04",
                           " ORDER BY amd171,amd172,amd10,amd04"  
          END IF
          PREPARE p1002_pre_27 FROM l_sql27
          IF SQLCA.SQLCODE THEN CALL cl_err('prepare2',STATUS,0) END IF
          DECLARE p1002_curs_27 CURSOR FOR p1002_pre_27
          
          LET l_amd06_31_27=0   LET l_amd06_32_27=0 
          FOREACH p1002_curs_27 INTO l_amd173_27,l_amd174_27,l_amd171_27,l_amd172_27,
                                     l_amd10_27,l_amd04_27,   
                                     l_amd07_27,l_amd08_27
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach2:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
          
              LET l_amd173_27=tm.byy   
              LET l_amd174_27=tm.emm  
         
              IF cl_null(l_amd07_27) THEN LET l_amd07_27 = 0 END IF
              IF cl_null(l_amd08_27) THEN LET l_amd08_27 = 0 END IF
              IF cl_null(l_amd06_31_27) THEN LET l_amd06_31_27 = 0 END IF  
              IF cl_null(l_amd06_32_27) THEN LET l_amd06_32_27 = 0 END IF 
          
              CASE l_amd172_27  
                 WHEN "1"
                    CASE l_amd171_27
                       WHEN "35"
                          LET tmp27.a05 = tmp27.a05 + l_amd08_27
                       WHEN "32"
                          LET l_amd06_32_27 = l_amd06_32_27 + l_amd08_27 + l_amd07_27 
                       WHEN "36"
                          LET tmp27.a13 = tmp27.a13 + l_amd08_27
                       WHEN "33"
                          LET tmp27.a17 = tmp27.a17 + l_amd08_27
                       WHEN "34"
                          LET tmp27.a17 = tmp27.a17 + l_amd08_27
                    END CASE
                    IF l_amd171_27 = '33' OR l_amd171_27 = '34' THEN
                        LET tmp27.a21 = tmp27.a21 - l_amd08_27
                    ELSE
                       LET tmp27.a21 = tmp27.a21 + l_amd08_27
                    END IF
                    IF l_amd171_27 ='31' AND cl_null(l_amd04_27) THEN
                       LET l_amd06_31_27 = l_amd06_31_27 + l_amd08_27 +l_amd07_27            
                    END IF
                    IF l_amd171_27='31' AND NOT cl_null(l_amd04_27) THEN
                       LET tmp27.a01 = tmp27.a01 + l_amd08_27
                    END IF
                 WHEN "2"
                    CASE l_amd10_27
                       WHEN '1'
                          LET tmp27.a23 = tmp27.a23 + l_amd08_27  
                       WHEN '2'
                          LET tmp27.a23 = tmp27.a23 + l_amd08_27 
                    END CASE
                    CASE l_amd171_27
                       WHEN '33'
                          LET tmp27.a23 = tmp27.a23 - l_amd08_27
                       WHEN '34'
                          LET tmp27.a23 = tmp27.a23 - l_amd08_27
                    END CASE
                END CASE
          END FOREACH
          
          CALL cl_digcut((l_amd06_32_27/1.05),0) RETURNING tmp27.a09
          CALL cl_digcut((l_amd06_31_27/1.05),0) RETURNING a01_31_27
          LET tmp27.a01=tmp27.a01+a01_31_27
          LET tmp27.a21=tmp27.a01+tmp27.a05+tmp27.a09+tmp27.a13-tmp27.a17
          LET tmp27.a25 = tmp27.a21 + tmp27.a23  #其他固定資產
      END IF                                  #MOD-A70103
      LET l_a50 = tmp.a50                     #FUN-B40063
      IF cl_null(l_a50) THEN LET l_a50 = 0 END IF  #FUN-B40063
   
      #--FUN-B40063 start---
      IF tm.upd = 'Y' THEN
         #FUN-BA0021--Begin--
         #UPDATE ama_file SET ama25 = tmp.a29,
         #                    ama31 = tmp.a31,
         #                    ama37 = tmp.a33,
         #                    ama43 = tmp.a35,
         #                    ama49 = tmp.a37,
         #                    ama55 = tmp.a39,
         #                    ama61 = tmp.a79,
         #                    ama67 = tmp.a81,
         #                    ama73 = tmp.a41,
         #                    ama79 = tmp.a43,
         #                    ama85 = tmp.a45,
         #                    ama91 = tmp.a47,
         #                    ama98 = l_a50,
         #                    ama99 = tmp.a74
         #  WHERE ama01 = tm.ama01
        IF NOT cl_null(tm.ama01) AND NOT cl_null(tm.byy) AND NOT cl_null(tm.emm) THEN
           SELECT count(*) INTO l_n FROM AMK_FILE WHERE amk01 = tm.ama01
                                                    AND amk02 = tm.byy
                                                    AND amk03 = tm.emm
           IF l_n=0 THEN
              INSERT INTO amk_file(amk01,amk02,amk03,amk04,amk10
                                  ,amk16,amk22,amk28,amk34,amk40
                                  ,amk46,amk52,amk58,amk64,amk70
                                  ,amk77,amk78)
                   VALUES (tm.ama01,tm.byy,tm.emm ,tmp.a29,tmp.a31
                          ,tmp.a33,tmp.a35,tmp.a37,tmp.a39,tmp.a79
                          ,tmp.a81,tmp.a41,tmp.a43,tmp.a45,tmp.a47
                          ,l_a50,tmp.a74)
           ELSE
              UPDATE amk_file SET amk04 = tmp.a29,amk10 = tmp.a31,amk16 = tmp.a33,amk22 = tmp.a35
                                 ,amk28 = tmp.a37,amk34 = tmp.a39,amk40 = tmp.a79,amk46 = tmp.a81
                                 ,amk52 = tmp.a41,amk58 = tmp.a43,amk64 = tmp.a45,amk70 = tmp.a47
                                 ,amk77 = l_a50  ,amk78 = tmp.a74
                           WHERE amk01=tm.ama01 AND amk02 = tm.byy AND amk03 = tm.emm
           END IF
        END IF
       #FUN-BA0021---End---
      ELSE
      #---FUN-B40063 end---
          #數值資料轉換
          LET sr2.a01 = p100_chans(tmp.a01,"2")   #No.MOD-6B0041
          LET sr2.a05 = p100_chans(tmp.a05,"2")   #No.MOD-6B0041
          LET sr2.a09 = p100_chans(tmp.a09,"2")   #No.MOD-6B0041
          LET sr2.a13 = p100_chans(tmp.a13,"2")   #No.MOD-6B0041
          LET sr2.a17 = p100_chans(tmp.a17,"2")   #No.MOD-6B0041
          LET sr2.a21 = p100_chans(tmp.a21,"2")   #No.MOD-6B0041
          LET sr2.a02 = p100_chans(tmp.a02,"1")   #No.MOD-6B0041
          LET sr2.a06 = p100_chans(tmp.a06,"1")   #No.MOD-6B0041
          LET sr2.a10 = p100_chans(tmp.a10,"1")   #No.MOD-6B0041
          LET sr2.a14 = p100_chans(tmp.a14,"1")   #No.MOD-6B0041
          LET sr2.a18 = p100_chans(tmp.a18,"1")   #No.MOD-6B0041
          LET sr2.a22 = p100_chans(tmp.a22,"1")   #No.MOD-6B0041
          LET sr2.a82 = "00000000000{"
          LET sr2.a07 = p100_chans(tmp.a07,"2")
          LET sr2.a15 = p100_chans(tmp.a15,"2")
          LET sr2.a19 = p100_chans(tmp.a19,"2")   #MOD-710084
          LET sr2.a23 = p100_chans(tmp.a23,"2")   #MOD-6B0059
          LET sr2.a04 = p100_chans(tmp.a04,"2")   #No.MOD-6B0041
          LET sr2.a08 = p100_chans(tmp.a08,"2")   #No.MOD-6B0041
          LET sr2.a12 = p100_chans(tmp.a12,"2")   #No.MOD-6B0041
          LET sr2.a16 = p100_chans(tmp.a16,"2")   #No.MOD-6B0041
          LET sr2.a20 = p100_chans(tmp.a20,"2")   #No.MOD-6B0041
          LET sr2.a24 = p100_chans(tmp.a24,"2")   #No.MOD-6B0041
          LET sr2.a52 = "00000000000{"
          LET sr2.a53 = "000000000{"
          LET sr2.a54 = "00000000000{"
          LET sr2.a55 = "000000000{"
          LET sr2.a56 = "00000000000{"
          LET sr2.a57 = "000000000{"
          LET sr2.a58 = "00000000000{"
          LET sr2.a59 = "000000000{"
          LET sr2.a60 = "00000000000{"
          LET sr2.a61 = "000000000{"
          LET sr2.a62 = "00000000000{"
          LET sr2.a63 = "00000000000{"
          LET sr2.a64 = "000000000{"
          LET sr2.a65 = "00000000000{"
          LET sr2.a66 = "000000000{"
          LET sr2.a25 = p100_chans(tmp.a25,"2")   #MOD-6B0059
          LET sr2.a26 = p100_chans(tmp26.a25,"2") #土地金額
          LET sr2.a27 = p100_chans(tmp27.a25,"2") #其他固定資產
          LET sr2.a28 = p100_chans(tmp.a28,"2")   #No.MOD-6B0041
          LET sr2.a30 = p100_chans(tmp.a30,"2")   #No.MOD-6B0041
          LET sr2.a32 = p100_chans(tmp.a32,"2")   #No.MOD-6B0041
          LET sr2.a34 = p100_chans(tmp.a34,"2")   #No.MOD-6B0041
          LET sr2.a36 = p100_chans(tmp.a36,"2")   #No.MOD-6B0041
          LET sr2.a38 = p100_chans(tmp.a38,"2")   #No.MOD-6B0041
          LET sr2.a40 = p100_chans(tmp.a40,"2")   #No.MOD-6B0041
          LET sr2.a42 = p100_chans(tmp.a42,"2")   #No.MOD-6B0041
          LET sr2.a44 = p100_chans(tmp.a44,"2")   #No.MOD-6B0041
          LET sr2.a46 = p100_chans(tmp.a46,"2")   #No.MOD-6B0041
          LET sr2.a29 = p100_chans(tmp.a29,"1")   #No.MOD-6B0041
          LET sr2.a31 = p100_chans(tmp.a31,"1")   #No.MOD-6B0041
          LET sr2.a33 = p100_chans(tmp.a33,"1")   #No.MOD-6B0041
          LET sr2.a35 = p100_chans(tmp.a35,"1")   #No.MOD-6B0041
          LET sr2.a37 = p100_chans(tmp.a37,"1")   #No.MOD-6B0041
          LET sr2.a39 = p100_chans(tmp.a39,"1")   #No.MOD-6B0041
          LET sr2.a41 = p100_chans(tmp.a41,"1")   #No.MOD-6B0041
          LET sr2.a43 = p100_chans(tmp.a43,"1")   #No.MOD-6B0041
          LET sr2.a45 = p100_chans(tmp.a45,"1")   #No.MOD-6B0041
          LET sr2.a47 = p100_chans(tmp.a47,"1")   #No.MOD-6B0041
          LET sr2.a48 = p100_chans(tmp.a48,"2")   #No.MOD-6B0041
          LET sr2.a49 = p100_chans(tmp.a49,"2")   #No.MOD-6B0041
          #-MOD-A70149-add-
          IF sr2.ama13 = '3' THEN
             LET sr2.a50 = tmp.a50 
            #使用 l_find 作去尾法,找出小數以前的資料存入 sr2.a50 中
             LET l_find = sr2.a50.getIndexOf(".",1)           
             LET sr2.a50 = sr2.a50.subString(1,l_find-1)
             LET l_find = sr2.a50.getLength()
            #IF  l_find < 3 THEN           #MOD-B60026 mark
             IF l_find = 2 THEN            #MOD-B60026
               LET sr2.a50 = "0",sr2.a50
             END IF
            #-MOD-B60026-add-
             IF l_find = 1 THEN 
               LET sr2.a50 = "00",sr2.a50
             END IF
            #-MOD-B60026-end-
         ELSE
            LET sr2.a50 = "000"
         END IF 
         #-MOD-A70149-end-
         #LET sr2.a50 = "000"                     #MOD-A70149 mark
         #LET sr2.a51 = "000000000{"              #MOD-A70149 mark
          LET sr2.a51 = p100_chans(tmp.a51,"1")   #MOD-A70149
          LET sr2.a78 = p100_chans(tmp.a78,"2")   #No.MOD-6B0041
          LET sr2.a80 = p100_chans(tmp.a80,"2")   #No.MOD-6B0041
          LET sr2.a73 = p100_chans(tmp.a73,"2")
          LET sr2.a74 = p100_chans(tmp.a74,"2")
          LET sr2.a79 = p100_chans(tmp.a79,"1")   #No.MOD-6B0041
          LET sr2.a81 = p100_chans(tmp.a81,"1")   #No.MOD-6B0041
          LET sr2.a75 = "000000000{"
         #LET sr2.a76 = "000000000{"              #MOD-C10166 mark
          LET sr2.a76 = p100_chans(tmp.a76,"1")   #MOD-C10166 add
          LET sr2.a101 = p100_chans(tmp.a101,"1")   #No.MOD-6B0041
         #LET sr2.a103 = "000000000{"               #MOD-C10166 mark
          LET sr2.a103 = p100_chans(tmp.a103,"1")   #MOD-C10166 add
          LET sr2.a104 = "000000000{"
         #LET sr2.a105 = "000000000{"               #MOD-C10106 mark
          LET sr2.a105 = p100_chans(tmp.a105,"1")   #MOD-C10106 add
          LET sr2.a106 = p100_chans(tmp.a106,"1")   #No.MOD-6B0041
          LET sr2.a107 = p100_chans(tmp.a107,"1")   #No.MOD-6B0041
          LET sr2.a108 = p100_chans(tmp.a108,"1")   #MOD-6B0059
          LET sr2.a109 = "000000000{"
          LET sr2.a110 = p100_chans(tmp.a110,"1")   #No.MOD-6B0041
          LET sr2.a111 = p100_chans(tmp.a111,"1")   #No.MOD-6B0041
          LET sr2.a112 = p100_chans(tmp.a112,"1")   #No.MOD-6B0041
          LET sr2.a113 = p100_chans(tmp.a113,"1")
          LET sr2.a114 = p100_chans(tmp.a114,"1")
          LET sr2.a115 = p100_chans(tmp.a115,"1")
 
          OUTPUT TO REPORT p100_rep2(sr2.*)
          IF sr2.ama15='2' THEN 
             LET tmp.a01 = 0                                                                                                            
             LET tmp.a05 = 0                                                                                                            
             LET tmp.a09  = 0                                                                                                           
             LET tmp.a13  = 0                                                                                                           
             LET tmp.a17  = 0                                                                                                           
             LET tmp.a21  = 0                                                                                                           
             LET tmp.a02  = 0                                                                                                           
             LET tmp.a06  = 0                                                                                                           
             LET tmp.a10  = 0                                                                                                           
             LET tmp.a14  = 0                                                                                                           
             LET tmp.a18  = 0                                                                                                           
             LET tmp.a22  = 0                                                                                                           
             LET tmp.a82  = 0                                                                                                           
             LET tmp.a07  = 0                                                                                                           
             LET tmp.a15  = 0                                                                                                           
             LET tmp.a19  = 0                                                                                                           
             LET tmp.a23  = 0                                                                                                           
             LET tmp.a04  = 0                                                                                                           
             LET tmp.a08  = 0     
             LET tmp.a12  = 0                                                                                                           
             LET tmp.a16  = 0                                                                                                           
             LET tmp.a20  = 0                                                                                                           
             LET tmp.a24  = 0                                                                                                           
             LET tmp.a52  = 0                                                                                                           
             LET tmp.a53  = 0                                                                                                           
             LET tmp.a54  = 0                                                                                                           
             LET tmp.a55  = 0                                                                                                           
             LET tmp.a56  = 0                                                                                                           
             LET tmp.a57  = 0                                                                                                           
             LET tmp.a58  = 0                                                                                                           
             LET tmp.a59  = 0                                                                                                           
             LET tmp.a60  = 0                                                                                                           
             LET tmp.a61  = 0                                                                                                           
             LET tmp.a62  = 0                                                                                                           
             LET tmp.a63  = 0                                                                                                           
             LET tmp.a64  = 0                                                                                                           
             LET tmp.a65  = 0                                                                                                           
             LET tmp.a66  = 0                                                                                                           
             LET tmp.a25  = 0                                                                                                           
             LET tmp.a26  = 0                                                                                                           
             LET tmp.a27  = 0                                                                                                           
             LET tmp.a28  = 0                                                                                                           
             LET tmp.a30  = 0          
             LET tmp.a32  = 0                                                                                                           
             LET tmp.a34  = 0                                                                                                           
             LET tmp.a36  = 0                                                                                                           
             LET tmp.a38  = 0                                                                                                           
             LET tmp.a40  = 0                                                                                                           
             LET tmp.a42  = 0                                                                                                           
             LET tmp.a44  = 0                                                                                                           
             LET tmp.a46  = 0                                                                                                           
             LET tmp.a29  = 0                                                                                                           
             LET tmp.a31  = 0                                                                                                           
             LET tmp.a33  = 0                                                                                                           
             LET tmp.a35  = 0                                                                                                           
             LET tmp.a37  = 0                                                                                                           
             LET tmp.a39  = 0                                                                                                           
             LET tmp.a41  = 0                                                                                                           
             LET tmp.a43  = 0                                                                                                           
             LET tmp.a45  = 0                                                                                                           
             LET tmp.a47  = 0                                                                                                           
             LET tmp.a48  = 0                                                                                                           
             LET tmp.a49  = 0                                                                                                           
             LET tmp.a50  = 0                                                                                                           
             LET tmp.a51  = 0                                                                                                           
             LET tmp.a78  = 0                                                                                                           
             LET tmp.a80  = 0      
             LET tmp.a73  = 0                                                                                                           
             LET tmp.a74  = 0                                                                                                           
             LET tmp.a79  = 0                                                                                                           
             LET tmp.a81  = 0                                                                                                           
             LET tmp.a75  = 0                                                                                                           
             LET tmp.a76  = 0                                                                                                           
             LET tmp.a101 = 0                                                                                                           
             LET tmp.a103 = 0                                                                                                           
             LET tmp.a104 = 0                                                                                                           
             LET tmp.a105 = 0                                                                                                           
             LET tmp.a106 = 0                                                                                                           
             LET tmp.a107 = 0                                                                                                           
             LET tmp.a108 = 0                                                                                                           
             LET tmp.a109 = 0                                                                                                           
             LET tmp.a110 = 0                                                                                                           
             LET tmp.a111 = 0                                                                                                           
             LET tmp.a112 = 0                                                                                                           
             LET tmp.a113 = 0                                                                                                           
             LET tmp.a114 = 0                                                                                                           
             LET tmp.a115 = 0       
          END IF 
       END IF    #FUN-B40063 add 
   END FOR   #MOD-6B0059
 
   IF tm.upd = 'N' THEN   #FUN-B40063 add
       FINISH REPORT p100_rep2
       CALL cl_addcr(l_name)   #CHI-850019 add
 
       IF g_ama15  = '1' THEN   #FUN-990021
          SELECT SUM(amd07),SUM(amd08) INTO l_amd07,l_amd08
           #FROM amd_file                                                      #MOD-BB0216 mark
            FROM amd_file,ama_file                                             #MOD-BB0216 add 
           WHERE amd173=tm.byy
             AND amd174 BETWEEN tm.bmm AND tm.emm
             AND amd171 = '32'
             AND amd172 = '1'
             AND amd30 = 'Y'
             AND (amd22 = tm.ama01 OR (amd22<> tm.ama01 AND ama23 =g_ama02))   #MOD-B90114 add
             AND amd04 IS NULL
             AND amd22 = ama01                                                 #MOD-BB0216 add
       ELSE
          SELECT SUM(amd07),SUM(amd08) INTO l_amd07,l_amd08
            FROM amd_file 
           WHERE amd173=tm.byy
             AND amd174 BETWEEN tm.bmm AND tm.emm
             AND amd171 = '32'
             AND amd172 = '1'
             AND amd30 = 'Y' 
             AND amd22 = tm.ama01
             AND amd04 IS NULL
       END IF
 
       IF cl_null(l_amd07) THEN
          LET l_amd07=0
       END IF
 
       IF cl_null(l_amd08) THEN
          LET l_amd08=0
       END IF
 
       #LET l_tax = l_amd08 * 0.05                    #MOD-B10199 mark
       LET l_tax = ((l_amd07+l_amd08) / 1.05) * 0.05 #MOD-B10199
       CALL cl_digcut(l_tax,0) RETURNING l_tax                     #MOD-A80115
 
       IF l_tax <> l_amd07 THEN
          LET l_msg=cl_getmsg("amd-024",g_lang) CLIPPED,l_amd07,
                    cl_getmsg("amd-025",g_lang) CLIPPED,l_tax,
                    cl_getmsg("amd-026",g_lang) CLIPPED
          CALL cl_msgany(10,20,l_msg)
       END IF
 
       LET l_ame.ame01 = tm.ama01
       LET l_ame.ame02 = tm.byy 
       LET l_ame.ame03 = tm.emm + (tm.emm - tm.bmm + 1)
       LET l_ame.ame07 = tmp.a115
       LET l_ame.ameacti = 'Y'
       LET l_ame.amedate = g_today
       LET l_ame.amegrup = g_grup
       LET l_ame.amemodu = g_user
       LET l_ame.ameuser = g_user
 
       IF l_ame.ame03 > 12 THEN
          LET l_ame.ame03 = l_ame.ame03 - 12
          LET l_ame.ame02 = tm.byy + 1
       END IF
 
       LET l_cnt = 0 
       SELECT COUNT(*) INTO l_cnt FROM ame_file 
         WHERE ame01= l_ame.ame01 AND
               ame02= l_ame.ame02 AND
               ame03= l_ame.ame03
 
       IF l_cnt = 0 THEN
          LET l_ame.ameoriu = g_user      #No.FUN-980030 10/01/04
          LET l_ame.ameorig = g_grup      #No.FUN-980030 10/01/04
          INSERT INTO ame_file VALUES(l_ame.*)
          IF STATUS OR SQLCA.sqlcode THEN 
             CALL cl_err3("ins","ame_file",l_ame.ame01,"","amd-016","","",1)  
          END IF
       ELSE
          UPDATE ame_file SET ame07 = l_ame.ame07 
            WHERE ame01= l_ame.ame01 AND
                  ame02= l_ame.ame02 AND
                  ame03= l_ame.ame03
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
             CALL cl_err3("upd","ame_file",l_ame.ame01,"","amd-016","","",1)  
          END IF
       END IF
 
       CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       #取得環境
       LET l_tmp = FGL_GETENV("TEMPDIR")
       LET l_file = os.Path.join(l_tmp CLIPPED,g_name CLIPPED)
       LET l_txt1 = g_name,'.txt'
       LET l_txt1 = os.Path.join(l_tmp CLIPPED,l_txt1 CLIPPED)
 
       #如為unicode環境，進行轉碼
       LET ms_codeset = cl_get_codeset()   
       IF ms_codeset = "UTF-8" THEN
          IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
             LET l_cmd = "iconv -f UTF-8 -t big5 ",l_file," > ",l_txt1
          #FUN-A30038--add--str--FOR WINDOWS
          ELSE
             LET l_cmd = "java -cp zhcode.jar zhcode -8b ",l_file," > ",l_txt1 
          END IF
          #FUN-A30038--add--end
          RUN l_cmd
          LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || l_file CLIPPED 
          RUN l_cmd      
       END IF
   END IF    #FUN-B40063 add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END FUNCTION
 
FUNCTION p100_chans(l_amt,l_c)
   DEFINE l_amt    LIKE type_file.num10
   DEFINE l_i      LIKE type_file.chr30
   DEFINE l_cha    LIKE type_file.chr12
   DEFINE l_cha1   LIKE type_file.chr1
   DEFINE l_c      LIKE type_file.chr1   #No.MOD-6B0041
 
   IF cl_null(l_amt) THEN LET l_amt = 0 END IF           #MOD-A80115
   IF l_c = "1" THEN    #取10碼
      LET l_i = l_amt USING "&&&&&&&&&&"
      LET l_cha = l_i[LENGTH(l_i)-9,LENGTH(l_i)-1]
   ELSE   #取12碼
      LET l_i = l_amt USING "&&&&&&&&&&&&"
      LET l_cha = l_i[LENGTH(l_i)-11,LENGTH(l_i)-1]
   END IF
 
   LET l_cha1 = l_i[LENGTH(l_i),LENGTH(l_i)]
 
   IF l_amt < 0 THEN
      CASE l_cha1
         WHEN "0"
            LET l_cha = l_cha CLIPPED,"}"
         WHEN "1"
            LET l_cha = l_cha CLIPPED,"J"
         WHEN "2"
            LET l_cha = l_cha CLIPPED,"K"
         WHEN "3"
            LET l_cha = l_cha CLIPPED,"L"
         WHEN "4"
            LET l_cha = l_cha CLIPPED,"M"
         WHEN "5"
            LET l_cha = l_cha CLIPPED,"N"
         WHEN "6"
            LET l_cha = l_cha CLIPPED,"O"
         WHEN "7"
            LET l_cha = l_cha CLIPPED,"P"
         WHEN "8"
            LET l_cha = l_cha CLIPPED,"Q"
         WHEN "9"
            LET l_cha = l_cha CLIPPED,"R"
      END CASE
   ELSE
      CASE l_cha1
         WHEN "0"
            LET l_cha = l_cha CLIPPED,"{"
         WHEN "1"
            LET l_cha = l_cha CLIPPED,"A"
         WHEN "2"
            LET l_cha = l_cha CLIPPED,"B"
         WHEN "3"
            LET l_cha = l_cha CLIPPED,"C"
         WHEN "4"
            LET l_cha = l_cha CLIPPED,"D"
         WHEN "5"
            LET l_cha = l_cha CLIPPED,"E"
         WHEN "6"
            LET l_cha = l_cha CLIPPED,"F"
         WHEN "7"
            LET l_cha = l_cha CLIPPED,"G"
         WHEN "8"
            LET l_cha = l_cha CLIPPED,"H"
         WHEN "9"
            LET l_cha = l_cha CLIPPED,"I"
      END CASE
   END IF
 
   RETURN l_cha
 
END FUNCTION
 
REPORT p100_rep2(sr2)
   DEFINE l_last_sw    LIKE type_file.chr1,
          l_yy,l_mm    LIKE type_file.num5,
          l_cyy,l_cmm  LIKE type_file.chr2,
          l_y1,l_m1    LIKE type_file.num5,  #FUN-950013
          l_type       LIKE type_file.chr1,   #MOD-6B0059
          sr2       RECORD
                       ama13   LIKE type_file.chr1,
                       filna   LIKE type_file.chr8,
                       ama02   LIKE type_file.chr8,
                       amd173  LIKE amd_file.amd173,
                       amd174  LIKE amd_file.amd174,
                       ama03   LIKE type_file.chr9,
                       ama15   LIKE type_file.chr1,
                       cps     LIKE type_file.num5,
                       a01     LIKE type_file.chr12,
                       a05     LIKE type_file.chr12,
                       a09     LIKE type_file.chr12,
                       a13     LIKE type_file.chr12,
                       a17     LIKE type_file.chr12,
                       a21     LIKE type_file.chr12,
                       a02     LIKE type_file.chr10,
                       a06     LIKE type_file.chr10,
                       a10     LIKE type_file.chr10,
                       a14     LIKE type_file.chr10,
                       a18     LIKE type_file.chr10,
                       a22     LIKE type_file.chr10,
                       a82     LIKE type_file.chr12,
                       a07     LIKE type_file.chr12,
                       a15     LIKE type_file.chr12,
                       a19     LIKE type_file.chr12,
                       a23     LIKE type_file.chr12,
                       a04     LIKE type_file.chr12,
                       a08     LIKE type_file.chr12,
                       a12     LIKE type_file.chr12,
                       a16     LIKE type_file.chr12,
                       a20     LIKE type_file.chr12,
                       a24     LIKE type_file.chr12,
                       a52     LIKE type_file.chr12,
                       a53     LIKE type_file.chr10,
                       a54     LIKE type_file.chr12,
                       a55     LIKE type_file.chr10,
                       a56     LIKE type_file.chr12,
                       a57     LIKE type_file.chr10,
                       a58     LIKE type_file.chr12,
                       a59     LIKE type_file.chr10,
                       a60     LIKE type_file.chr12,
                       a61     LIKE type_file.chr10,
                       a62     LIKE type_file.chr12,
                       a63     LIKE type_file.chr12,
                       a64     LIKE type_file.chr10,
                       a65     LIKE type_file.chr12,
                       a66     LIKE type_file.chr10,
                       a25     LIKE type_file.chr12,
                       a26     LIKE type_file.chr12,
                       a27     LIKE type_file.chr12,
                       a28     LIKE type_file.chr12,
                       a30     LIKE type_file.chr12,
                       a32     LIKE type_file.chr12,
                       a34     LIKE type_file.chr12,
                       a36     LIKE type_file.chr12,
                       a38     LIKE type_file.chr12,
                       a40     LIKE type_file.chr12,
                       a42     LIKE type_file.chr12,
                       a44     LIKE type_file.chr12,
                       a46     LIKE type_file.chr12,
                       a29     LIKE type_file.chr10,
                       a31     LIKE type_file.chr10,
                       a33     LIKE type_file.chr10,
                       a35     LIKE type_file.chr10,
                       a37     LIKE type_file.chr10,
                       a39     LIKE type_file.chr10,
                       a41     LIKE type_file.chr10,
                       a43     LIKE type_file.chr10,
                       a45     LIKE type_file.chr10,
                       a47     LIKE type_file.chr10,
                       a48     LIKE type_file.chr12,
                       a49     LIKE type_file.chr12,
                       a50     LIKE type_file.chr3,
                       a51     LIKE type_file.chr10,
                       a78     LIKE type_file.chr12,
                       a80     LIKE type_file.chr12,
                       a73     LIKE type_file.chr12,
                       a74     LIKE type_file.chr12,
                       a79     LIKE type_file.chr10,
                       a81     LIKE type_file.chr10,
                       a75     LIKE type_file.chr10,
                       a76     LIKE type_file.chr10,
                       a101    LIKE type_file.chr10,
                       a103    LIKE type_file.chr10,
                       a104    LIKE type_file.chr10,
                       a105    LIKE type_file.chr10,
                       a106    LIKE type_file.chr10,
                       a107    LIKE type_file.chr10,
                       a108    LIKE type_file.chr10,
                       a109    LIKE type_file.chr10,
                       a110    LIKE type_file.chr10,
                       a111    LIKE type_file.chr10,
                       a112    LIKE type_file.chr10,
                       a113    LIKE type_file.chr10,
                       a114    LIKE type_file.chr10,
                       a115    LIKE type_file.chr10,
                       ama14   LIKE type_file.chr1,
                       ama16   LIKE ama_file.ama16,   #FUN-950013
                       ama17   LIKE ama_file.ama17,   #FUN-950013
                       ama18   LIKE ama_file.ama19,   #FUN-950013
                       ama19   LIKE ama_file.ama19,   #FUN-950013
                       ama20   LIKE ama_file.ama20,   #FUN-950013
                       ama21   LIKE ama_file.ama21,   #FUN-980024
                       ama22   LIKE ama_file.ama22    #FUN-980024
                    END RECORD
   DEFINE l_ama19   STRING
   DEFINE l_ama21   STRING
   DEFINE l_ama22   STRING
   DEFINE l_ama19_len  LIKE type_file.num5
   DEFINE l_ama21_len  LIKE type_file.num5
   DEFINE l_ama22_len  LIKE type_file.num5
   DEFINE l_type1       LIKE type_file.chr1  #FUN-990034
   DEFINE l_length18    LIKE type_file.num5  #FUN-950013
   DEFINE l_length20    LIKE type_file.num5  #FUN-950013

   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN 0
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
  
 
   FORMAT
      ON EVERY ROW
         LET l_y1 = tm.byy - 1911  #FUN-950013
         LET l_m1 = tm.emm         #FUN-950013
         
 
         IF tm.bmm = tm.emm THEN
            LET l_type='2'
         ELSE
            LET l_type='1'
         END IF
         
         #將ama21[1,4],ama19[1,11],ama22[1,5]組成sr2.ama19
         LET l_ama19 = sr2.ama19
         LET l_ama21 = sr2.ama21
         LET l_ama22 = sr2.ama22
         LET l_ama19_len = length(sr2.ama19)
         LET l_ama21_len = length(sr2.ama21)
         LET l_ama22_len = length(sr2.ama22)
     
         IF l_ama19_len < 11 THEN 
             LET l_ama19_len = 11-l_ama19_len
             LET l_ama19 = l_ama19,l_ama19_len SPACE
         ELSE
             LET l_ama19 = l_ama19.substring(1,11)
         END IF
         IF l_ama21_len < 4 THEN
             LET l_ama21_len = 4 - l_ama21_len
             LET l_ama21 = l_ama21,l_ama21_len SPACE
         ELSE
             LET l_ama21 = l_ama21.substring(1,4)
         END IF
         IF l_ama22_len < 5 THEN
            LET l_ama22_len = 5 - l_ama22_len
            LET l_ama22 = l_ama22,l_ama22_len SPACE
         ELSE
            LET l_ama22 = l_ama22.substring(1,5)
         END IF
         LET l_ama19 = l_ama21,l_ama19,l_ama22

         IF sr2.ama15 = '1' THEN LET l_type1 = '5' ELSE LET l_type1 = '1' END IF  #FUN-990034 

         IF tm.byy < 2009 OR (tm.byy = 2009 AND tm.emm < 7) THEN
            LET l_cyy = l_yy USING '&&'
            PRINT COLUMN    1,sr2.ama13[1,1] CLIPPED,
                  COLUMN    2,"00",
                  COLUMN    4,"00000000",
                  COLUMN   12,sr2.ama02[1,8] CLIPPED,
                  COLUMN   20,l_y1 CLIPPED USING '&&',l_m1 CLIPPED USING '&&',  #FUN-950013
                  COLUMN   24,l_type1 CLIPPED,  #FUN-990034
                  COLUMN   25,sr2.ama03[1,9] CLIPPED,
                  COLUMN   34,"00000",
                  COLUMN   39,sr2.ama15[1,1] CLIPPED,
                  COLUMN   40,"000000",
                  COLUMN   46,sr2.cps CLIPPED USING '&&&&&&&&&&',
                  COLUMN   56,sr2.a01 CLIPPED,
                  COLUMN   68,sr2.a05 CLIPPED,
                  COLUMN   80,sr2.a09 CLIPPED,
                  COLUMN   92,sr2.a13 CLIPPED,
                  COLUMN  104,sr2.a17 CLIPPED,
                  COLUMN  116,sr2.a21 CLIPPED,
                  COLUMN  128,sr2.a02 CLIPPED,
                  COLUMN  138,sr2.a06 CLIPPED,
                  COLUMN  148,sr2.a10 CLIPPED,
                  COLUMN  158,sr2.a14 CLIPPED,
                  COLUMN  168,sr2.a18 CLIPPED,
                  COLUMN  178,sr2.a22 CLIPPED,
                  COLUMN  188,sr2.a82 CLIPPED,
                  COLUMN  200,sr2.a07 CLIPPED,
                  COLUMN  212,"000000000000",
                  COLUMN  224,sr2.a15 CLIPPED,
                  COLUMN  236,sr2.a19 CLIPPED,
                  COLUMN  248,sr2.a23 CLIPPED,
                  COLUMN  260,sr2.a04 CLIPPED,
                  COLUMN  272,sr2.a08 CLIPPED,
                  COLUMN  284,sr2.a12 CLIPPED,
                  COLUMN  296,sr2.a16 CLIPPED,
                  COLUMN  308,sr2.a20 CLIPPED,
                  COLUMN  320,sr2.a24 CLIPPED,
                  COLUMN  332,sr2.a52 CLIPPED,
                  COLUMN  344,sr2.a53 CLIPPED,
                  COLUMN  354,sr2.a54 CLIPPED,
                  COLUMN  366,sr2.a55 CLIPPED,
                  COLUMN  376,sr2.a56 CLIPPED,
                  COLUMN  388,sr2.a57 CLIPPED,
                  COLUMN  398,sr2.a58 CLIPPED,
                  COLUMN  410,sr2.a59 CLIPPED,
                  COLUMN  420,sr2.a60 CLIPPED,
                  COLUMN  432,sr2.a61 CLIPPED,
                  COLUMN  442,sr2.a62 CLIPPED,
                  COLUMN  454,sr2.a63 CLIPPED,
                  COLUMN  466,sr2.a64 CLIPPED,
                  COLUMN  476,sr2.a65 CLIPPED,
                  COLUMN  488,sr2.a66 CLIPPED,
                  COLUMN  498,sr2.a25 CLIPPED,
                  COLUMN  510,sr2.a26 CLIPPED,
                  COLUMN  522,sr2.a27 CLIPPED,
                  COLUMN  534,sr2.a28 CLIPPED,
                  COLUMN  546,sr2.a30 CLIPPED,
                  COLUMN  558,sr2.a32 CLIPPED,
                  COLUMN  570,sr2.a34 CLIPPED,
                  COLUMN  582,sr2.a36 CLIPPED,
                  COLUMN  594,sr2.a38 CLIPPED,
                  COLUMN  606,sr2.a40 CLIPPED,
                  COLUMN  618,sr2.a42 CLIPPED,
                  COLUMN  630,sr2.a44 CLIPPED,
                  COLUMN  642,sr2.a46 CLIPPED,
                  COLUMN  654,sr2.a29 CLIPPED,
                  COLUMN  664,sr2.a31 CLIPPED,
                  COLUMN  674,sr2.a33 CLIPPED,
                  COLUMN  684,sr2.a35 CLIPPED,
                  COLUMN  694,sr2.a37 CLIPPED,
                  COLUMN  704,sr2.a39 CLIPPED,
                  COLUMN  714,sr2.a41 CLIPPED,
                  COLUMN  724,sr2.a43 CLIPPED,
                  COLUMN  734,sr2.a45 CLIPPED,
                  COLUMN  744,sr2.a47 CLIPPED,
                  COLUMN  754,sr2.a48 CLIPPED,
                  COLUMN  766,sr2.a49 CLIPPED,
                  COLUMN  778,sr2.a50 CLIPPED,
                  COLUMN  781,sr2.a51 CLIPPED,
                  COLUMN  791,sr2.a78 CLIPPED,
                  COLUMN  803,sr2.a80 CLIPPED,
                  COLUMN  815,sr2.a73 CLIPPED,
                  COLUMN  827,sr2.a74 CLIPPED,
                  COLUMN  839,sr2.a79 CLIPPED,
                  COLUMN  849,sr2.a81 CLIPPED,
                  COLUMN  859,sr2.a75 CLIPPED,
                  COLUMN  869,"0000000000",
                  COLUMN  879,"0000000000",
                  COLUMN  889,sr2.a76 CLIPPED,
                  COLUMN  899,sr2.a101 CLIPPED,
                  COLUMN  909,"0000000000",
                  COLUMN  919,sr2.a103 CLIPPED,
                  COLUMN  929,sr2.a104 CLIPPED,
                  COLUMN  939,sr2.a105 CLIPPED,
                  COLUMN  949,sr2.a106 CLIPPED,
                  COLUMN  959,sr2.a107 CLIPPED,
                  COLUMN  969,sr2.a108 CLIPPED,
                  COLUMN  979,sr2.a109 CLIPPED,
                  COLUMN  989,sr2.a110 CLIPPED,
                  COLUMN  999,sr2.a111 CLIPPED,
                  COLUMN 1009,sr2.a112 CLIPPED,
                  COLUMN 1019,sr2.a113 CLIPPED,
                  COLUMN 1029,sr2.a114 CLIPPED,
                  COLUMN 1039,sr2.a115 CLIPPED,
                  COLUMN 1049,"00000000000000000000000",
                  COLUMN 1072,l_type CLIPPED,   #MOD-6B0059
                  COLUMN 1073,"0",
                  COLUMN 1074,sr2.ama14[1,1] CLIPPED,
                  COLUMN 1075,"000000"
         END IF 
         IF (tm.byy = 2009 AND tm.emm > 7) OR tm.byy > 2009 THEN                
            LET l_cyy = l_yy USING '&&&'                                        
            LET l_length18 = length(sr2.ama18)
            IF l_length18 > 12 THEN 
                LET sr2.ama18 = sr2.ama18[1,12] 
            ELSE
                LET sr2.ama18 = sr2.ama18
            END IF
            LET l_length20 = length(sr2.ama20) 
            IF l_length20 > 50 THEN
                LET sr2.ama20 = sr2.ama20[1,50]
            ELSE
                LET sr2.ama20 = sr2.ama20
            END IF
            PRINT COLUMN    1,sr2.ama13[1,1] CLIPPED,
                  COLUMN    2,"00",
                  COLUMN    4,"00000000",
                  COLUMN   12,sr2.ama02[1,8] CLIPPED,
                  COLUMN   20,l_y1 CLIPPED USING '&&&',l_m1 CLIPPED USING '&&',    #FUN-950013
                  COLUMN   25,l_type1 CLIPPED,  #FUN-990034
                  COLUMN   26,sr2.ama03[1,9] CLIPPED,
                  COLUMN   35,"00000",
                  COLUMN   40,sr2.ama15[1,1] CLIPPED,
                  COLUMN   41,"000000",
                  COLUMN   47,sr2.cps CLIPPED USING '&&&&&&&&&&',
                  COLUMN   57,sr2.a01 CLIPPED,
                  COLUMN   69,sr2.a05 CLIPPED,
                  COLUMN   81,sr2.a09 CLIPPED,
                  COLUMN   93,sr2.a13 CLIPPED,
                  COLUMN  105,sr2.a17 CLIPPED,
                  COLUMN  117,sr2.a21 CLIPPED,
                  COLUMN  129,sr2.a02 CLIPPED,
                  COLUMN  139,sr2.a06 CLIPPED,
                  COLUMN  149,sr2.a10 CLIPPED,
                  COLUMN  159,sr2.a14 CLIPPED,
                  COLUMN  169,sr2.a18 CLIPPED,
                  COLUMN  179,sr2.a22 CLIPPED,
                  COLUMN  189,sr2.a82 CLIPPED,
                  COLUMN  201,sr2.a07 CLIPPED,
                  COLUMN  213,"000000000000",
                  COLUMN  225,sr2.a15 CLIPPED,
                  COLUMN  237,sr2.a19 CLIPPED,
                  COLUMN  249,sr2.a23 CLIPPED,
                  COLUMN  261,sr2.a04 CLIPPED,
                  COLUMN  273,sr2.a08 CLIPPED,
                  COLUMN  285,sr2.a12 CLIPPED,
                  COLUMN  297,sr2.a16 CLIPPED,
                  COLUMN  309,sr2.a20 CLIPPED,
                  COLUMN  321,sr2.a24 CLIPPED,
                  COLUMN  333,sr2.a52 CLIPPED,
                  COLUMN  345,sr2.a53 CLIPPED,
                  COLUMN  355,sr2.a54 CLIPPED,
                  COLUMN  367,sr2.a55 CLIPPED,
                  COLUMN  377,sr2.a56 CLIPPED,
                  COLUMN  389,sr2.a57 CLIPPED,
                  COLUMN  399,sr2.a58 CLIPPED,
                  COLUMN  411,sr2.a59 CLIPPED,
                  COLUMN  421,sr2.a60 CLIPPED,
                  COLUMN  433,sr2.a61 CLIPPED,
                  COLUMN  443,sr2.a62 CLIPPED,
                  COLUMN  455,sr2.a63 CLIPPED,
                  COLUMN  467,sr2.a64 CLIPPED,
                  COLUMN  477,sr2.a65 CLIPPED,
                  COLUMN  489,sr2.a66 CLIPPED,
                  COLUMN  499,sr2.a25 CLIPPED,
                  COLUMN  511,sr2.a26 CLIPPED,
                  COLUMN  523,sr2.a27 CLIPPED,
                  COLUMN  535,sr2.a28 CLIPPED,
                  COLUMN  547,sr2.a30 CLIPPED,
                  COLUMN  559,sr2.a32 CLIPPED,
                  COLUMN  571,sr2.a34 CLIPPED,
                  COLUMN  583,sr2.a36 CLIPPED,
                  COLUMN  595,sr2.a38 CLIPPED,
                  COLUMN  607,sr2.a40 CLIPPED,
                  COLUMN  619,sr2.a42 CLIPPED,
                  COLUMN  631,sr2.a44 CLIPPED,
                  COLUMN  643,sr2.a46 CLIPPED,
                  COLUMN  655,sr2.a29 CLIPPED,
                  COLUMN  665,sr2.a31 CLIPPED,
                  COLUMN  675,sr2.a33 CLIPPED,
                  COLUMN  685,sr2.a35 CLIPPED,
                  COLUMN  695,sr2.a37 CLIPPED,
                  COLUMN  705,sr2.a39 CLIPPED,
                  COLUMN  715,sr2.a41 CLIPPED,
                  COLUMN  725,sr2.a43 CLIPPED,
                  COLUMN  735,sr2.a45 CLIPPED,
                  COLUMN  745,sr2.a47 CLIPPED,
                  COLUMN  755,sr2.a48 CLIPPED,
                  COLUMN  767,sr2.a49 CLIPPED,
                  COLUMN  779,sr2.a50 CLIPPED,
                  COLUMN  782,sr2.a51 CLIPPED,
                  COLUMN  792,sr2.a78 CLIPPED,
                  COLUMN  804,sr2.a80 CLIPPED,
                  COLUMN  816,sr2.a73 CLIPPED,
                  COLUMN  828,sr2.a74 CLIPPED,
                  COLUMN  840,sr2.a79 CLIPPED,
                  COLUMN  850,sr2.a81 CLIPPED,
                  COLUMN  860,sr2.a75 CLIPPED,
                  COLUMN  870,"0000000000",
                  COLUMN  880,"0000000000",
                  COLUMN  890,sr2.a76 CLIPPED,
                  COLUMN  900,sr2.a101 CLIPPED,
                  COLUMN  910,"0000000000",
                  COLUMN  920,sr2.a103 CLIPPED,
                  COLUMN  930,sr2.a104 CLIPPED,
                  COLUMN  940,sr2.a105 CLIPPED,
                  COLUMN  950,sr2.a106 CLIPPED,
                  COLUMN  960,sr2.a107 CLIPPED,
                  COLUMN  970,sr2.a108 CLIPPED,
                  COLUMN  980,sr2.a109 CLIPPED,
                  COLUMN  990,sr2.a110 CLIPPED,
                  COLUMN 1000,sr2.a111 CLIPPED,
                  COLUMN 1010,sr2.a112 CLIPPED,
                  COLUMN 1020,sr2.a113 CLIPPED,
                  COLUMN 1030,sr2.a114 CLIPPED,
                  COLUMN 1040,sr2.a115 CLIPPED,
                  COLUMN 1050,"00000000000000000000000",
                  COLUMN 1073,l_type CLIPPED,   #MOD-6B0059
                  COLUMN 1074,"0",
                  COLUMN 1075,sr2.ama14[1,1] CLIPPED,
                  COLUMN 1076,"000000",
                  COLUMN 1082,sr2.ama16[1,1] CLIPPED,
                  COLUMN 1083,sr2.ama17[1,10] CLIPPED,
                  COLUMN 1093,sr2.ama18 CLIPPED,
                  COLUMN 1105,l_ama19 CLIPPED,    #FUN-980024
                  COLUMN 1125,sr2.ama20 CLIPPED,
                  COLUMN 1175,"0",
                  COLUMN 1176,"0",
                  COLUMN 1177,"0",
                  COLUMN 1178,"0",
                  COLUMN 1179,"0",
                  COLUMN 1180,"0",
                  COLUMN 1181,"0",
                  COLUMN 1182,"0",
                  COLUMN 1183,"0",
                  COLUMN 1184,"0",
                  COLUMN 1185,"0",
                  COLUMN 1186,"0",
                  COLUMN 1187,"0",
                  COLUMN 1188,"0",
                  COLUMN 1189,"0",
                  COLUMN 1190,"0",
                  COLUMN 1191,"0",
                  COLUMN 1192,"0",
                  COLUMN 1193,"0",
                  COLUMN 1194,"0",
                  COLUMN 1195,"0",
                  COLUMN 1196,"0",
                  COLUMN 1197,"0",
                  COLUMN 1198,"0",
                  COLUMN 1199,"0",
                  COLUMN 1200,"0",
                  COLUMN 1201,"0",
                  COLUMN 1202,"0",
                  COLUMN 1203,"0",
                  COLUMN 1204,"0",
                  COLUMN 1205,"0",
                  COLUMN 1206,"0",
                  COLUMN 1207,"0",
                  COLUMN 1208,"0",
                  COLUMN 1209,"0",
                  COLUMN 1210,"0",
                  COLUMN 1211,"0",
                  COLUMN 1212,"0",
                  COLUMN 1213,"0",
                  COLUMN 1214,"0",
                  COLUMN 1215,"0",
                  COLUMN 1216,"0",
                  COLUMN 1217,"0",
                  COLUMN 1218,"0",
                  COLUMN 1219,"0",
                  COLUMN 1220,"0",
                  COLUMN 1221,"0",
                  COLUMN 1222,"0",
                  COLUMN 1223,"0",
                  COLUMN 1224,"0",
                  COLUMN 1225,"0",
                  COLUMN 1226,"0",
                  COLUMN 1227,"0",
                  COLUMN 1228,"0",
                  COLUMN 1229,"0",
                  COLUMN 1230,"0",
                  COLUMN 1231,"0",
                  COLUMN 1232,"0",
                  COLUMN 1233,"0",
                  COLUMN 1234,"0",
                  COLUMN 1235,"0",
                  COLUMN 1236,"0",
                  COLUMN 1237,"0",
                  COLUMN 1238,"0",
                  COLUMN 1239,"0",
                  COLUMN 1240,"0",
                  COLUMN 1241,"0",
                  COLUMN 1242,"0",
                  COLUMN 1243,"0",
                  COLUMN 1244,"0",
                  COLUMN 1245,"0",
                  COLUMN 1246,"0",
                  COLUMN 1247,"0",
                  COLUMN 1248,"0",
                  COLUMN 1249,"0",
                  COLUMN 1250,"0",
                  COLUMN 1251,"0",
                  COLUMN 1252,"0",
                  COLUMN 1253,"0",
                  COLUMN 1254,"0",
                  COLUMN 1255,"0",
                  COLUMN 1256,"0",
                  COLUMN 1257,"0",
                  COLUMN 1258,"0",
                  COLUMN 1259,"0",
                  COLUMN 1260,"0",
                  COLUMN 1261,"0",
                  COLUMN 1262,"0",
                  COLUMN 1263,"0",
                  COLUMN 1264,"0",
                  COLUMN 1265,"0",
                  COLUMN 1266,"0"
         END IF                                                                 
 
 
END REPORT
 
#---FUN-B40063 start---
FUNCTION p100_3()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680074 VARCHAR(20) # External(Disk) file name 
          l_sql     STRING,                      # RDSQL STATEMENT                #No.FUN-680074
          l_chr     LIKE type_file.chr1,         #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680074 VARCHAR(40)    
          l_amd39   LIKE amd_file.amd39,         #MOD-970006 add
          l_find    LIKE type_file.num5,
#FUN-BA0021--Begin--
          l_ama     RECORD
                       ama02   LIKE ama_file.ama02,
                       ama03   LIKE ama_file.ama03,
                       ama15   LIKE type_file.chr1,
                       amk04   LIKE type_file.num10,
                       amk05   LIKE type_file.num10,
                       amk06   LIKE type_file.num10,
                       amk07   LIKE type_file.num10, 
                       amk08   LIKE type_file.num10,
                       amk09   LIKE type_file.num10,
                       amk10   LIKE type_file.num10,
                       amk11   LIKE type_file.num10,
                       amk12   LIKE type_file.num10,
                       amk13   LIKE type_file.num10,
                       amk14   LIKE type_file.num10,
                       amk15   LIKE type_file.num10,
                       amk16   LIKE type_file.num10,
                       amk17   LIKE type_file.num10,
                       amk18   LIKE type_file.num10,
                       amk19   LIKE type_file.num10,
                       amk20   LIKE type_file.num10,
                       amk21   LIKE type_file.num10,
                       amk22   LIKE type_file.num10,
                       amk23   LIKE type_file.num10,
                       amk24   LIKE type_file.num10,
                       amk25   LIKE type_file.num10,
                       amk26   LIKE type_file.num10,
                       amk27   LIKE type_file.num10,
                       amk28   LIKE type_file.num10,
                       amk29   LIKE type_file.num10,
                       amk30   LIKE type_file.num10,
                       amk31   LIKE type_file.num10,
                       amk32   LIKE type_file.num10,
                       amk33   LIKE type_file.num10,
                       amk34   LIKE type_file.num10,
                       amk35   LIKE type_file.num10,
                       amk36   LIKE type_file.num10,
                       amk37   LIKE type_file.num10,
                       amk38   LIKE type_file.num10,
                       amk39   LIKE type_file.num10,
                       amk40   LIKE type_file.num10,
                       amk41   LIKE type_file.num10,
                       amk42   LIKE type_file.num10,
                       amk43   LIKE type_file.num10,
                       amk44   LIKE type_file.num10,
                       amk45   LIKE type_file.num10,
                       amk46   LIKE type_file.num10,
                       amk47   LIKE type_file.num10,
                       amk48   LIKE type_file.num10,
                       amk49   LIKE type_file.num10,
                       amk50   LIKE type_file.num10,
                       amk51   LIKE type_file.num10,
                       amk52   LIKE type_file.num10,
                       amk53   LIKE type_file.num10,
                       amk54   LIKE type_file.num10,
                       amk55   LIKE type_file.num10,
                       amk56   LIKE type_file.num10,
                       amk57   LIKE type_file.num10,
                       amk58   LIKE type_file.num10,
                       amk59   LIKE type_file.num10,
                       amk60   LIKE type_file.num10,
                       amk61   LIKE type_file.num10,
                       amk62   LIKE type_file.num10, 
                       amk63   LIKE type_file.num10,
                       amk64   LIKE type_file.num10,
                       amk65   LIKE type_file.num10,
                       amk66   LIKE type_file.num10, 
                       amk67   LIKE type_file.num10,
                       amk68   LIKE type_file.num10,
                       amk69   LIKE type_file.num10,
                       amk70   LIKE type_file.num10,
                       amk71   LIKE type_file.num10,
                       amk72   LIKE type_file.num10,
                       amk73   LIKE type_file.num10,
                       amk74   LIKE type_file.num10,
                       amk75   LIKE type_file.num10,
                       amk76   LIKE type_file.num10,
                       amk77   LIKE type_file.num10,
                       amk78   LIKE type_file.num10,
                       amk79   LIKE type_file.num10,
                       amk80   LIKE type_file.num10,
                       amk81   LIKE type_file.num10,
                       amk82   LIKE type_file.num10,
                       amk83   LIKE type_file.num10,
                       amk84   LIKE type_file.num10
                    END RECORD
DEFINE    sr2       RECORD
                       ama02   LIKE ama_file.ama02,
                       ama03   LIKE ama_file.ama03,
                       ama15   LIKE type_file.chr1,
                       amk04   LIKE type_file.chr10,
                       amk05   LIKE type_file.chr10,
                       amk06   LIKE type_file.chr10,
                       amk07   LIKE type_file.chr10, 
                       amk08   LIKE type_file.chr10,
                       amk09   LIKE type_file.chr10,
                       amk10   LIKE type_file.chr10,
                       amk11   LIKE type_file.chr10,
                       amk12   LIKE type_file.chr10,
                       amk13   LIKE type_file.chr10,
                       amk14   LIKE type_file.chr10,
                       amk15   LIKE type_file.chr10,
                       amk16   LIKE type_file.chr10,
                       amk17   LIKE type_file.chr10,
                       amk18   LIKE type_file.chr10,
                       amk19   LIKE type_file.chr10,
                       amk20   LIKE type_file.chr10,
                       amk21   LIKE type_file.chr10,
                       amk22   LIKE type_file.chr10,
                       amk23   LIKE type_file.chr10,
                       amk24   LIKE type_file.chr10,
                       amk25   LIKE type_file.chr10,
                       amk26   LIKE type_file.chr10,
                       amk27   LIKE type_file.chr10,
                       amk28   LIKE type_file.chr10,
                       amk29   LIKE type_file.chr10,
                       amk30   LIKE type_file.chr10,
                       amk31   LIKE type_file.chr10,
                       amk32   LIKE type_file.chr10,
                       amk33   LIKE type_file.chr10,
                       amk34   LIKE type_file.chr10,
                       amk35   LIKE type_file.chr10,
                       amk36   LIKE type_file.chr10,
                       amk37   LIKE type_file.chr10,
                       amk38   LIKE type_file.chr10,
                       amk39   LIKE type_file.chr10,
                       amk40   LIKE type_file.chr12,
                       amk41   LIKE type_file.chr12,
                       amk42   LIKE type_file.chr12,
                       amk43   LIKE type_file.chr12,
                       amk44   LIKE type_file.chr10,
                       amk45   LIKE type_file.chr10,
                       amk46   LIKE type_file.chr12,
                       amk47   LIKE type_file.chr12,
                       amk48   LIKE type_file.chr12,
                       amk49   LIKE type_file.chr12,
                       amk50   LIKE type_file.chr10,
                       amk51   LIKE type_file.chr10,
                       amk52   LIKE type_file.chr10,
                       amk53   LIKE type_file.chr10,
                       amk54   LIKE type_file.chr10,
                       amk55   LIKE type_file.chr10,
                       amk56   LIKE type_file.chr10,
                       amk57   LIKE type_file.chr10,
                       amk58   LIKE type_file.chr10,
                       amk59   LIKE type_file.chr10,
                       amk60   LIKE type_file.chr10,
                       amk61   LIKE type_file.chr10,
                       amk62   LIKE type_file.chr10, 
                       amk63   LIKE type_file.chr10,
                       amk64   LIKE type_file.chr10,
                       amk65   LIKE type_file.chr10,
                       amk66   LIKE type_file.chr10, 
                       amk67   LIKE type_file.chr10,
                       amk68   LIKE type_file.chr10,
                       amk69   LIKE type_file.chr10,
                       amk70   LIKE type_file.chr10,
                       amk71   LIKE type_file.chr10,
                       amk72   LIKE type_file.chr10,
                       amk73   LIKE type_file.chr10,
                       amk74   LIKE type_file.chr10,
                       amk75   LIKE type_file.chr10,
                       amk76   LIKE type_file.chr10,
                       amk77   STRING,
                       amk78   LIKE type_file.chr12,
                       amk79   LIKE type_file.chr12,
                       amk80   LIKE type_file.chr12,
                       amk81   LIKE type_file.chr12,
                       amk82   LIKE type_file.chr10,
                       amk83   LIKE type_file.chr10,
                       amk84   LIKE type_file.chr10
                   END RECORD
#         l_ama     RECORD
#                      ama02   LIKE ama_file.ama02,
#                      ama03   LIKE ama_file.ama03,
#                      ama15   LIKE type_file.chr1,
#                      ama25   LIKE type_file.num10,
#                      ama26   LIKE type_file.num10,
#                      ama27   LIKE type_file.num10,
#                      ama28   LIKE type_file.num10, 
#                      ama29   LIKE type_file.num10,
#                      ama30   LIKE type_file.num10,
#                      ama31   LIKE type_file.num10,
#                      ama32   LIKE type_file.num10,
#                      ama33   LIKE type_file.num10,
#                      ama34   LIKE type_file.num10,
#                      ama35   LIKE type_file.num10,
#                      ama36   LIKE type_file.num10,
#                      ama37   LIKE type_file.num10,
#                      ama38   LIKE type_file.num10,
#                      ama39   LIKE type_file.num10,
#                      ama40   LIKE type_file.num10,
#                      ama41   LIKE type_file.num10,
#                      ama42   LIKE type_file.num10,
#                      ama43   LIKE type_file.num10,
#                      ama44   LIKE type_file.num10,
#                      ama45   LIKE type_file.num10,
#                      ama46   LIKE type_file.num10,
#                      ama47   LIKE type_file.num10,
#                      ama48   LIKE type_file.num10,
#                      ama49   LIKE type_file.num10,
#                      ama50   LIKE type_file.num10,
#                      ama51   LIKE type_file.num10,
#                      ama52   LIKE type_file.num10,
#                      ama53   LIKE type_file.num10,
#                      ama54   LIKE type_file.num10,
#                      ama55   LIKE type_file.num10,
#                      ama56   LIKE type_file.num10,
#                      ama57   LIKE type_file.num10,
#                      ama58   LIKE type_file.num10,
#                      ama59   LIKE type_file.num10,
#                      ama60   LIKE type_file.num10,
#                      ama61   LIKE type_file.num10,
#                      ama62   LIKE type_file.num10,
#                      ama63   LIKE type_file.num10,
#                      ama64   LIKE type_file.num10,
#                      ama65   LIKE type_file.num10,
#                      ama66   LIKE type_file.num10,
#                      ama67   LIKE type_file.num10,
#                      ama68   LIKE type_file.num10,
#                      ama69   LIKE type_file.num10,
#                      ama70   LIKE type_file.num10,
#                      ama71   LIKE type_file.num10,
#                      ama72   LIKE type_file.num10,
#                      ama73   LIKE type_file.num10,
#                      ama74   LIKE type_file.num10,
#                      ama75   LIKE type_file.num10,
#                      ama76   LIKE type_file.num10,
#                      ama77   LIKE type_file.num10,
#                      ama78   LIKE type_file.num10,
#                      ama79   LIKE type_file.num10,
#                      ama80   LIKE type_file.num10,
#                      ama81   LIKE type_file.num10,
#                      ama82   LIKE type_file.num10,
#                      ama83   LIKE type_file.num10, 
#                      ama84   LIKE type_file.num10,
#                      ama85   LIKE type_file.num10,
#                      ama86   LIKE type_file.num10,
#                      ama87   LIKE type_file.num10, 
#                      ama88   LIKE type_file.num10,
#                      ama89   LIKE type_file.num10,
#                      ama90   LIKE type_file.num10,
#                      ama91   LIKE type_file.num10,
#                      ama92   LIKE type_file.num10,
#                      ama93   LIKE type_file.num10,
#                      ama94   LIKE type_file.num10,
#                      ama95   LIKE type_file.num10,
#                      ama96   LIKE type_file.num10,
#                      ama97   LIKE type_file.num10,
#                      ama98   LIKE type_file.num10,
#                      ama99   LIKE type_file.num10,
#                      ama100  LIKE type_file.num10,
#                      ama101  LIKE type_file.num10,
#                      ama102  LIKE type_file.num10,
#                      ama103  LIKE type_file.num10,
#                      ama104  LIKE type_file.num10,
#                      ama105  LIKE type_file.num10
#                   END RECORD
#DEFINE    sr2      RECORD
#                      ama02   LIKE ama_file.ama02,
#                      ama03   LIKE ama_file.ama03,
#                      ama15   LIKE type_file.chr1,
#                      ama25   LIKE type_file.chr10,
#                      ama26   LIKE type_file.chr10,
#                      ama27   LIKE type_file.chr10,
#                      ama28   LIKE type_file.chr10, 
#                      ama29   LIKE type_file.chr10,
#                      ama30   LIKE type_file.chr10,
#                      ama31   LIKE type_file.chr10,
#                      ama32   LIKE type_file.chr10,
#                      ama33   LIKE type_file.chr10,
#                      ama34   LIKE type_file.chr10,
#                      ama35   LIKE type_file.chr10,
#                      ama36   LIKE type_file.chr10,
#                      ama37   LIKE type_file.chr10,
#                      ama38   LIKE type_file.chr10,
#                      ama39   LIKE type_file.chr10,
#                      ama40   LIKE type_file.chr10,
#                      ama41   LIKE type_file.chr10,
#                      ama42   LIKE type_file.chr10,
#                      ama43   LIKE type_file.chr10,
#                      ama44   LIKE type_file.chr10,
#                      ama45   LIKE type_file.chr10,
#                      ama46   LIKE type_file.chr10,
#                      ama47   LIKE type_file.chr10,
#                      ama48   LIKE type_file.chr10,
#                      ama49   LIKE type_file.chr10,
#                      ama50   LIKE type_file.chr10,
#                      ama51   LIKE type_file.chr10,
#                      ama52   LIKE type_file.chr10,
#                      ama53   LIKE type_file.chr10,
#                      ama54   LIKE type_file.chr10,
#                      ama55   LIKE type_file.chr10,
#                      ama56   LIKE type_file.chr10,
#                      ama57   LIKE type_file.chr10,
#                      ama58   LIKE type_file.chr10,
#                      ama59   LIKE type_file.chr10,
#                      ama60   LIKE type_file.chr10,
#                      ama61   LIKE type_file.chr12,
#                      ama62   LIKE type_file.chr12,
#                      ama63   LIKE type_file.chr12,
#                      ama64   LIKE type_file.chr12,
#                      ama65   LIKE type_file.chr10,
#                      ama66   LIKE type_file.chr10,
#                      ama67   LIKE type_file.chr12,
#                      ama68   LIKE type_file.chr12,
#                      ama69   LIKE type_file.chr12,
#                      ama70   LIKE type_file.chr12,
#                      ama71   LIKE type_file.chr10,
#                      ama72   LIKE type_file.chr10,
#                      ama73   LIKE type_file.chr10,
#                      ama74   LIKE type_file.chr10,
#                      ama75   LIKE type_file.chr10,
#                      ama76   LIKE type_file.chr10,
#                      ama77   LIKE type_file.chr10,
#                      ama78   LIKE type_file.chr10,
#                      ama79   LIKE type_file.chr10,
#                      ama80   LIKE type_file.chr10,
#                      ama81   LIKE type_file.chr10,
#                      ama82   LIKE type_file.chr10,
#                      ama83   LIKE type_file.chr10, 
#                      ama84   LIKE type_file.chr10,
#                      ama85   LIKE type_file.chr10,
#                      ama86   LIKE type_file.chr10,
#                      ama87   LIKE type_file.chr10, 
#                      ama88   LIKE type_file.chr10,
#                      ama89   LIKE type_file.chr10,
#                      ama90   LIKE type_file.chr10,
#                      ama91   LIKE type_file.chr10,
#                      ama92   LIKE type_file.chr10,
#                      ama93   LIKE type_file.chr10,
#                      ama94   LIKE type_file.chr10,
#                      ama95   LIKE type_file.chr10,
#                      ama96   LIKE type_file.chr10,
#                      ama97   LIKE type_file.chr10,
#                      ama98   STRING,
#                      ama99   LIKE type_file.chr12,
#                      ama100  LIKE type_file.chr12,
#                      ama101  LIKE type_file.chr12,
#                      ama102  LIKE type_file.chr12,
#                      ama103  LIKE type_file.chr10,
#                      ama104  LIKE type_file.chr10,
#                      ama105  LIKE type_file.chr10
#                  END RECORD
#FUN-BA0021---End---
   DEFINE l_tmp      STRING                   
   DEFINE l_file     LIKE type_file.chr100    
   DEFINE l_file1    LIKE type_file.chr100    
   DEFINE l_txt1     LIKE type_file.chr100    
   DEFINE l_cmd      LIKE type_file.chr1000   
   DEFINE ms_codeset STRING     
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

#FUN-BA0021--Begin--
   LET l_sql = "SELECT ama02,ama03,ama15,amk04,amk05,amk06,amk07,amk08,amk09, ",
               "       amk10,amk11,amk12,amk13,amk14,amk15,amk16,amk17,amk18, ",
               "       amk19,amk20,amk21,amk22,amk23,amk24,amk25,amk26,amk27, ",
               "       amk28,amk29,amk30,amk31,amk32,amk33,amk34,amk35,amk36, ",
               "       amk37,amk38,amk39,amk40,amk41,amk42,amk43,amk44,amk45, ",
               "       amk46,amk47,amk48,amk49,amk50,amk51,amk52,amk53,amk54, ",
               "       amk55,amk56,amk57,amk58,amk59,amk60,amk61,amk62,amk63, ",
               "       amk64,amk65,amk66,amk67,amk68,amk69,amk70,amk71,amk72, ",
               "       amk73,amk74,amk75,amk76,amk77,amk78,amk79,amk80,amk81, ",
               "       amk82,amk83,amk84 ",
               "  FROM ama_file,amk_file ",
               "  WHERE amk01 = '",tm.ama01,"' AND amk02 = '",tm.byy,"' AND amk03 = '",tm.bmm,"'",
               "    AND ama01 = amk01 AND amaacti = 'Y' "
 
#  LET l_sql = "SELECT ama02,ama03,ama15,ama25,ama26,ama27,ama28,ama29,ama30, ",
#              "       ama31,ama32,ama33,ama34,ama35,ama36,ama37,ama38,ama39, ",
#              "       ama40,ama41,ama42,ama43,ama44,ama45,ama46,ama47,ama48, ",
#              "       ama49,ama50,ama51,ama52,ama53,ama54,ama55,ama56,ama57, ",
#              "       ama58,ama59,ama60,ama61,ama62,ama63,ama64,ama65,ama66, ",
#              "       ama67,ama68,ama69,ama70,ama71,ama72,ama73,ama74,ama75, ",
#              "       ama76,ama77,ama78,ama79,ama80,ama81,ama82,ama83,ama84, ",
#              "       ama85,ama86,ama87,ama88,ama89,ama90,ama91,ama92,ama93, ",
#              "       ama94,ama95,ama96,ama97,ama98,ama99,ama100,ama101,ama102, ",
#              "       ama103,ama104,ama105 ",
#              "  FROM ama_file ",
#              "  WHERE ama01 = '",tm.ama01,"'",
#              "    AND amaacti = 'Y' "
#FUN-BA0021---End---
   PREPARE p1003_prepare FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare4',STATUS,0) END IF
   DECLARE p1003_curs CURSOR FOR p1003_prepare
 
   LET l_name  = tm.rep1 CLIPPED,'.T01'
   LET g_name  = l_name  
 
   SELECT UNIQUE zaa12 INTO g_page_line FROM zaa_file WHERE zaa01=g_prog
 
   START REPORT p100_rep3 TO l_name
 
   FOREACH p1003_curs INTO l_ama.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach3:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_ama08) THEN
         LET tm.byy = YEAR(g_today)
      ELSE
         LET tm.byy = g_ama08
      END IF
      IF cl_null(g_ama09) THEN
         LET tm.bmm = MONTH(g_today)
      ELSE
         LET tm.bmm = g_ama09 + 1
      END IF
      IF tm.bmm > 12 THEN
          LET tm.byy = tm.byy + 1
          LET tm.bmm = tm.bmm - 12
      END IF
      LET tm.emm = tm.bmm + g_ama10 - 1
      
      LET sr2.ama02 = l_ama.ama02
      LET sr2.ama03 = l_ama.ama03
      LET sr2.ama15 = l_ama.ama15
#FUN-BA0021--Begin--
      LET sr2.amk04 = p100_chans(l_ama.amk04,"1")  
      LET sr2.amk05 = p100_chans(l_ama.amk05,"1")  
      LET sr2.amk06 = p100_chans(l_ama.amk06,"1")  
      LET sr2.amk07 = p100_chans(l_ama.amk07,"1")  
      LET sr2.amk08 = p100_chans(l_ama.amk08,"1")  
      LET sr2.amk09 = p100_chans(l_ama.amk09,"1")  

      LET sr2.amk10 = p100_chans(l_ama.amk10,"1")  
      LET sr2.amk11 = p100_chans(l_ama.amk11,"1")  
      LET sr2.amk12 = p100_chans(l_ama.amk12,"1")  
      LET sr2.amk13 = p100_chans(l_ama.amk13,"1")  
      LET sr2.amk14 = p100_chans(l_ama.amk14,"1")  
      LET sr2.amk15 = p100_chans(l_ama.amk15,"1")  

      LET sr2.amk16 = p100_chans(l_ama.amk16,"1")  
      LET sr2.amk17 = p100_chans(l_ama.amk17,"1")  
      LET sr2.amk18 = p100_chans(l_ama.amk18,"1")  
      LET sr2.amk19 = p100_chans(l_ama.amk19,"1")  
      LET sr2.amk20 = p100_chans(l_ama.amk20,"1")  
      LET sr2.amk21 = p100_chans(l_ama.amk21,"1")  

      LET sr2.amk22 = p100_chans(l_ama.amk22,"1")  
      LET sr2.amk23 = p100_chans(l_ama.amk23,"1")  
      LET sr2.amk24 = p100_chans(l_ama.amk24,"1")  
      LET sr2.amk25 = p100_chans(l_ama.amk25,"1")  
      LET sr2.amk26 = p100_chans(l_ama.amk26,"1")  
      LET sr2.amk27 = p100_chans(l_ama.amk27,"1")  

      LET sr2.amk28 = p100_chans(l_ama.amk28,"1")  
      LET sr2.amk29 = p100_chans(l_ama.amk29,"1")  
      LET sr2.amk30 = p100_chans(l_ama.amk30,"1")  
      LET sr2.amk31 = p100_chans(l_ama.amk31,"1")  
      LET sr2.amk32 = p100_chans(l_ama.amk32,"1")  
      LET sr2.amk33 = p100_chans(l_ama.amk33,"1")  

      LET sr2.amk34 = p100_chans(l_ama.amk34,"1")  
      LET sr2.amk35 = p100_chans(l_ama.amk35,"1")  
      LET sr2.amk36 = p100_chans(l_ama.amk36,"1")  
      LET sr2.amk37 = p100_chans(l_ama.amk37,"1")  
      LET sr2.amk38 = p100_chans(l_ama.amk38,"1")  
      LET sr2.amk39 = p100_chans(l_ama.amk39,"1")  

      LET sr2.amk52 = p100_chans(l_ama.amk52,"1")  
      LET sr2.amk53 = p100_chans(l_ama.amk53,"1")  
      LET sr2.amk54 = p100_chans(l_ama.amk54,"1")  
      LET sr2.amk55 = p100_chans(l_ama.amk55,"1")  
      LET sr2.amk56 = p100_chans(l_ama.amk56,"1")  
      LET sr2.amk57 = p100_chans(l_ama.amk57,"1")  

      LET sr2.amk58 = p100_chans(l_ama.amk58,"1")  
      LET sr2.amk59 = p100_chans(l_ama.amk59,"1")  
      LET sr2.amk60 = p100_chans(l_ama.amk60,"1")  
      LET sr2.amk61 = p100_chans(l_ama.amk61,"1")  
      LET sr2.amk62 = p100_chans(l_ama.amk62,"1")  
      LET sr2.amk63 = p100_chans(l_ama.amk63,"1")  

      LET sr2.amk64 = p100_chans(l_ama.amk64,"1")  
      LET sr2.amk65 = p100_chans(l_ama.amk65,"1")  
      LET sr2.amk66 = p100_chans(l_ama.amk66,"1")  
      LET sr2.amk67 = p100_chans(l_ama.amk67,"1")  
      LET sr2.amk68 = p100_chans(l_ama.amk68,"1")  
      LET sr2.amk69 = p100_chans(l_ama.amk69,"1")  

      LET sr2.amk70 = p100_chans(l_ama.amk70,"1")  
      LET sr2.amk71 = p100_chans(l_ama.amk71,"1")  
      LET sr2.amk72 = p100_chans(l_ama.amk72,"1")  
      LET sr2.amk73 = p100_chans(l_ama.amk73,"1")  
      LET sr2.amk74 = p100_chans(l_ama.amk74,"1")  
      LET sr2.amk75 = p100_chans(l_ama.amk75,"1")  
      LET sr2.amk76 = p100_chans(l_ama.amk76,"1")  
      IF g_ama13 = '3' THEN
         LET sr2.amk77 = l_ama.amk77
        #使用 l_find 作去尾法,找出小數以前的資料存入 sr2.a50 中
         LET l_find = sr2.amk77.getIndexOf(".",1)           
         LET sr2.amk77 = sr2.amk77.subString(1,l_find-1)
         LET l_find = sr2.amk77.getLength()
         IF  l_find < 3 THEN 
           LET sr2.amk77 = "0",sr2.amk77
         END IF
      ELSE
         LET sr2.amk77 = "000"
      END IF 
      
      LET sr2.amk40 = p100_chans(l_ama.amk40,"2")
      LET sr2.amk41 = p100_chans(l_ama.amk41,"2")
      LET sr2.amk42 = p100_chans(l_ama.amk42,"2")
      LET sr2.amk43 = p100_chans(l_ama.amk43,"2")
      LET sr2.amk44 = p100_chans(l_ama.amk44,"1")
      LET sr2.amk45 = p100_chans(l_ama.amk45,"1")

      LET sr2.amk46 = p100_chans(l_ama.amk46,"2")
      LET sr2.amk47 = p100_chans(l_ama.amk47,"2")
      LET sr2.amk48 = p100_chans(l_ama.amk48,"2")
      LET sr2.amk49 = p100_chans(l_ama.amk49,"2")
      LET sr2.amk50 = p100_chans(l_ama.amk50,"1")
      LET sr2.amk51 = p100_chans(l_ama.amk51,"1")

      LET sr2.amk78 = p100_chans(l_ama.amk78,"2")
      LET sr2.amk79 = p100_chans(l_ama.amk79,"2")
      LET sr2.amk80 = p100_chans(l_ama.amk80,"2")
      LET sr2.amk81 = p100_chans(l_ama.amk81,"2")

      LET sr2.amk82 = p100_chans(l_ama.amk82,"1")
      LET sr2.amk83 = p100_chans(l_ama.amk83,"1")
      LET sr2.amk84 = p100_chans(l_ama.amk84,"1")

#     LET sr2.ama25 = p100_chans(l_ama.ama25,"1")  
#     LET sr2.ama26 = p100_chans(l_ama.ama26,"1")  
#     LET sr2.ama27 = p100_chans(l_ama.ama27,"1")  
#     LET sr2.ama28 = p100_chans(l_ama.ama28,"1")  
#     LET sr2.ama29 = p100_chans(l_ama.ama29,"1")  
#     LET sr2.ama30 = p100_chans(l_ama.ama30,"1")  

#     LET sr2.ama31 = p100_chans(l_ama.ama31,"1")  
#     LET sr2.ama32 = p100_chans(l_ama.ama32,"1")  
#     LET sr2.ama33 = p100_chans(l_ama.ama33,"1")  
#     LET sr2.ama34 = p100_chans(l_ama.ama34,"1")  
#     LET sr2.ama35 = p100_chans(l_ama.ama35,"1")  
#     LET sr2.ama36 = p100_chans(l_ama.ama36,"1")  

#     LET sr2.ama37 = p100_chans(l_ama.ama37,"1")  
#     LET sr2.ama38 = p100_chans(l_ama.ama38,"1")  
#     LET sr2.ama39 = p100_chans(l_ama.ama39,"1")  
#     LET sr2.ama40 = p100_chans(l_ama.ama40,"1")  
#     LET sr2.ama41 = p100_chans(l_ama.ama41,"1")  
#     LET sr2.ama42 = p100_chans(l_ama.ama42,"1")  

#     LET sr2.ama43 = p100_chans(l_ama.ama43,"1")  
#     LET sr2.ama44 = p100_chans(l_ama.ama44,"1")  
#     LET sr2.ama45 = p100_chans(l_ama.ama45,"1")  
#     LET sr2.ama46 = p100_chans(l_ama.ama46,"1")  
#     LET sr2.ama47 = p100_chans(l_ama.ama47,"1")  
#     LET sr2.ama48 = p100_chans(l_ama.ama48,"1")  

#     LET sr2.ama49 = p100_chans(l_ama.ama49,"1")  
#     LET sr2.ama50 = p100_chans(l_ama.ama50,"1")  
#     LET sr2.ama51 = p100_chans(l_ama.ama51,"1")  
#     LET sr2.ama52 = p100_chans(l_ama.ama52,"1")  
#     LET sr2.ama53 = p100_chans(l_ama.ama53,"1")  
#     LET sr2.ama54 = p100_chans(l_ama.ama54,"1")  

#     LET sr2.ama55 = p100_chans(l_ama.ama55,"1")  
#     LET sr2.ama56 = p100_chans(l_ama.ama56,"1")  
#     LET sr2.ama57 = p100_chans(l_ama.ama57,"1")  
#     LET sr2.ama58 = p100_chans(l_ama.ama58,"1")  
#     LET sr2.ama59 = p100_chans(l_ama.ama59,"1")  
#     LET sr2.ama60 = p100_chans(l_ama.ama60,"1")  

#     LET sr2.ama73 = p100_chans(l_ama.ama73,"1")  
#     LET sr2.ama74 = p100_chans(l_ama.ama74,"1")  
#     LET sr2.ama75 = p100_chans(l_ama.ama75,"1")  
#     LET sr2.ama76 = p100_chans(l_ama.ama76,"1")  
#     LET sr2.ama77 = p100_chans(l_ama.ama77,"1")  
#     LET sr2.ama78 = p100_chans(l_ama.ama78,"1")  

#     LET sr2.ama79 = p100_chans(l_ama.ama79,"1")  
#     LET sr2.ama80 = p100_chans(l_ama.ama80,"1")  
#     LET sr2.ama81 = p100_chans(l_ama.ama81,"1")  
#     LET sr2.ama82 = p100_chans(l_ama.ama82,"1")  
#     LET sr2.ama83 = p100_chans(l_ama.ama83,"1")  
#     LET sr2.ama84 = p100_chans(l_ama.ama84,"1")  

#     LET sr2.ama85 = p100_chans(l_ama.ama85,"1")  
#     LET sr2.ama86 = p100_chans(l_ama.ama86,"1")  
#     LET sr2.ama87 = p100_chans(l_ama.ama87,"1")  
#     LET sr2.ama88 = p100_chans(l_ama.ama88,"1")  
#     LET sr2.ama89 = p100_chans(l_ama.ama89,"1")  
#     LET sr2.ama90 = p100_chans(l_ama.ama90,"1")  

#     LET sr2.ama91 = p100_chans(l_ama.ama91,"1")  
#     LET sr2.ama92 = p100_chans(l_ama.ama92,"1")  
#     LET sr2.ama93 = p100_chans(l_ama.ama93,"1")  
#     LET sr2.ama94 = p100_chans(l_ama.ama94,"1")  
#     LET sr2.ama95 = p100_chans(l_ama.ama95,"1")  
#     LET sr2.ama96 = p100_chans(l_ama.ama96,"1")  
#     LET sr2.ama97 = p100_chans(l_ama.ama97,"1")  
#     IF g_ama13 = '3' THEN
#        LET sr2.ama98 = l_ama.ama98
#       #使用 l_find 作去尾法,找出小數以前的資料存入 sr2.a50 中
#        LET l_find = sr2.ama98.getIndexOf(".",1)           
#        LET sr2.ama98 = sr2.ama98.subString(1,l_find-1)
#        LET l_find = sr2.ama98.getLength()
#        IF  l_find < 3 THEN 
#          LET sr2.ama98 = "0",sr2.ama98
#        END IF
#     ELSE
#        LET sr2.ama98 = "000"
#     END IF 
#     
#     LET sr2.ama61 = p100_chans(l_ama.ama61,"2")
#     LET sr2.ama62 = p100_chans(l_ama.ama62,"2")
#     LET sr2.ama63 = p100_chans(l_ama.ama63,"2")
#     LET sr2.ama64 = p100_chans(l_ama.ama64,"2")
#     LET sr2.ama65 = p100_chans(l_ama.ama65,"1")
#     LET sr2.ama66 = p100_chans(l_ama.ama66,"1")

#     LET sr2.ama67 = p100_chans(l_ama.ama67,"2")
#     LET sr2.ama68 = p100_chans(l_ama.ama68,"2")
#     LET sr2.ama69 = p100_chans(l_ama.ama69,"2")
#     LET sr2.ama70 = p100_chans(l_ama.ama70,"2")
#     LET sr2.ama71 = p100_chans(l_ama.ama71,"1")
#     LET sr2.ama72 = p100_chans(l_ama.ama72,"1")

#     LET sr2.ama99 = p100_chans(l_ama.ama99,"2")
#     LET sr2.ama100 = p100_chans(l_ama.ama100,"2")
#     LET sr2.ama101 = p100_chans(l_ama.ama101,"2")
#     LET sr2.ama102 = p100_chans(l_ama.ama102,"2")

#     LET sr2.ama103 = p100_chans(l_ama.ama103,"1")
#     LET sr2.ama104 = p100_chans(l_ama.ama104,"1")
#     LET sr2.ama105 = p100_chans(l_ama.ama105,"1")
#FUN-BA0021---End--- 

      OUTPUT TO REPORT p100_rep3(sr2.*)
 
   END FOREACH
 
   FINISH REPORT p100_rep3
   CALL cl_addcr(l_name)
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #取得環境
   LET l_tmp = FGL_GETENV("TEMPDIR")
   LET l_file = os.Path.join(l_tmp CLIPPED,g_name CLIPPED)
   LET l_txt1 = g_name,'.txt'
   LET l_txt1 = os.Path.join(l_tmp CLIPPED,l_txt1 CLIPPED)
 
   #如為unicode環境，進行轉碼
   LET ms_codeset = cl_get_codeset()   
   IF ms_codeset = "UTF-8" THEN
      IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
         LET l_cmd = "iconv -f UTF-8 -t big5 ",l_file," > ",l_txt1
      ELSE
         LET l_cmd = "java -cp zhcode.jar zhcode -8b ",l_file," > ",l_txt1 
      END IF
      RUN l_cmd
      LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || l_file CLIPPED 
      RUN l_cmd      
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END FUNCTION
 
REPORT p100_rep3(sr2)
DEFINE l_last_sw    LIKE type_file.chr1,
       l_y1,l_m1    LIKE type_file.num5
#FUN-BA0021--Begin--
   DEFINE    sr2       RECORD
                       ama02   LIKE type_file.chr10,
                       ama03   LIKE type_file.chr10,
                       ama15   LIKE type_file.chr1,
                       amk04   LIKE type_file.chr10,
                       amk05   LIKE type_file.chr10,
                       amk06   LIKE type_file.chr10,
                       amk07   LIKE type_file.chr10, 
                       amk08   LIKE type_file.chr10,
                       amk09   LIKE type_file.chr10,
                       amk10   LIKE type_file.chr10,
                       amk11   LIKE type_file.chr10,
                       amk12   LIKE type_file.chr10,
                       amk13   LIKE type_file.chr10,
                       amk14   LIKE type_file.chr10,
                       amk15   LIKE type_file.chr10,
                       amk16   LIKE type_file.chr10,
                       amk17   LIKE type_file.chr10,
                       amk18   LIKE type_file.chr10,
                       amk19   LIKE type_file.chr10,
                       amk20   LIKE type_file.chr10,
                       amk21   LIKE type_file.chr10,
                       amk22   LIKE type_file.chr10,
                       amk23   LIKE type_file.chr10,
                       amk24   LIKE type_file.chr10,
                       amk25   LIKE type_file.chr10,
                       amk26   LIKE type_file.chr10,
                       amk27   LIKE type_file.chr10,
                       amk28   LIKE type_file.chr10,
                       amk29   LIKE type_file.chr10,
                       amk30   LIKE type_file.chr10,
                       amk31   LIKE type_file.chr10,
                       amk32   LIKE type_file.chr10,
                       amk33   LIKE type_file.chr10,
                       amk34   LIKE type_file.chr10,
                       amk35   LIKE type_file.chr10,
                       amk36   LIKE type_file.chr10,
                       amk37   LIKE type_file.chr10,
                       amk38   LIKE type_file.chr10,
                       amk39   LIKE type_file.chr10,
                       amk40   LIKE type_file.chr12,
                       amk41   LIKE type_file.chr12,
                       amk42   LIKE type_file.chr12,
                       amk43   LIKE type_file.chr12,
                       amk44   LIKE type_file.chr10,
                       amk45   LIKE type_file.chr10,
                       amk46   LIKE type_file.chr12,
                       amk47   LIKE type_file.chr12,
                       amk48   LIKE type_file.chr12,
                       amk49   LIKE type_file.chr12,
                       amk50   LIKE type_file.chr10,
                       amk51   LIKE type_file.chr10,
                       amk52   LIKE type_file.chr10,
                       amk53   LIKE type_file.chr10,
                       amk54   LIKE type_file.chr10,
                       amk55   LIKE type_file.chr10,
                       amk56   LIKE type_file.chr10,
                       amk57   LIKE type_file.chr10,
                       amk58   LIKE type_file.chr10,
                       amk59   LIKE type_file.chr10,
                       amk60   LIKE type_file.chr10,
                       amk61   LIKE type_file.chr10,
                       amk62   LIKE type_file.chr10, 
                       amk63   LIKE type_file.chr10,
                       amk64   LIKE type_file.chr10,
                       amk65   LIKE type_file.chr10,
                       amk66   LIKE type_file.chr10, 
                       amk67   LIKE type_file.chr10,
                       amk68   LIKE type_file.chr10,
                       amk69   LIKE type_file.chr10,
                       amk70   LIKE type_file.chr10,
                       amk71   LIKE type_file.chr10,
                       amk72   LIKE type_file.chr10,
                       amk73   LIKE type_file.chr10,
                       amk74   LIKE type_file.chr10,
                       amk75   LIKE type_file.chr10,
                       amk76   LIKE type_file.chr10,
                       amk77   STRING,
                       amk78   LIKE type_file.chr12,
                       amk79   LIKE type_file.chr12,
                       amk80   LIKE type_file.chr12,
                       amk81   LIKE type_file.chr12,
                       amk82   LIKE type_file.chr10,
                       amk83   LIKE type_file.chr10,
                       amk84   LIKE type_file.chr10
                   END RECORD
#DEFINE    sr2       RECORD
#                      ama02   LIKE type_file.chr10,
#                      ama03   LIKE type_file.chr10,
#                      ama15   LIKE type_file.chr1,
#                      ama25   LIKE type_file.chr10,
#                      ama26   LIKE type_file.chr10,
#                      ama27   LIKE type_file.chr10,
#                      ama28   LIKE type_file.chr10, 
#                      ama29   LIKE type_file.chr10,
#                      ama30   LIKE type_file.chr10,
#                      ama31   LIKE type_file.chr10,
#                      ama32   LIKE type_file.chr10,
#                      ama33   LIKE type_file.chr10,
#                      ama34   LIKE type_file.chr10,
#                      ama35   LIKE type_file.chr10,
#                      ama36   LIKE type_file.chr10,
#                      ama37   LIKE type_file.chr10,
#                      ama38   LIKE type_file.chr10,
#                      ama39   LIKE type_file.chr10,
#                      ama40   LIKE type_file.chr10,
#                      ama41   LIKE type_file.chr10,
#                      ama42   LIKE type_file.chr10,
#                      ama43   LIKE type_file.chr10,
#                      ama44   LIKE type_file.chr10,
#                      ama45   LIKE type_file.chr10,
#                      ama46   LIKE type_file.chr10,
#                      ama47   LIKE type_file.chr10,
#                      ama48   LIKE type_file.chr10,
#                      ama49   LIKE type_file.chr10,
#                      ama50   LIKE type_file.chr10,
#                      ama51   LIKE type_file.chr10,
#                      ama52   LIKE type_file.chr10,
#                      ama53   LIKE type_file.chr10,
#                      ama54   LIKE type_file.chr10,
#                      ama55   LIKE type_file.chr10,
#                      ama56   LIKE type_file.chr10,
#                      ama57   LIKE type_file.chr10,
#                      ama58   LIKE type_file.chr10,
#                      ama59   LIKE type_file.chr10,
#                      ama60   LIKE type_file.chr10,
#                      ama61   LIKE type_file.chr12,
#                      ama62   LIKE type_file.chr12,
#                      ama63   LIKE type_file.chr12,
#                      ama64   LIKE type_file.chr12,
#                      ama65   LIKE type_file.chr10,
#                      ama66   LIKE type_file.chr10,
#                      ama67   LIKE type_file.chr12,
#                      ama68   LIKE type_file.chr12,
#                      ama69   LIKE type_file.chr12,
#                      ama70   LIKE type_file.chr12,
#                      ama71   LIKE type_file.chr10,
#                      ama72   LIKE type_file.chr10,
#                      ama73   LIKE type_file.chr10,
#                      ama74   LIKE type_file.chr10,
#                      ama75   LIKE type_file.chr10,
#                      ama76   LIKE type_file.chr10,
#                      ama77   LIKE type_file.chr10,
#                      ama78   LIKE type_file.chr10,
#                      ama79   LIKE type_file.chr10,
#                      ama80   LIKE type_file.chr10,
#                      ama81   LIKE type_file.chr10,
#                      ama82   LIKE type_file.chr10,
#                      ama83   LIKE type_file.chr10, 
#                      ama84   LIKE type_file.chr10,
#                      ama85   LIKE type_file.chr10,
#                      ama86   LIKE type_file.chr10,
#                      ama87   LIKE type_file.chr10, 
#                      ama88   LIKE type_file.chr10,
#                      ama89   LIKE type_file.chr10,
#                      ama90   LIKE type_file.chr10,
#                      ama91   LIKE type_file.chr10,
#                      ama92   LIKE type_file.chr10,
#                      ama93   LIKE type_file.chr10,
#                      ama94   LIKE type_file.chr10,
#                      ama95   LIKE type_file.chr10,
#                      ama96   LIKE type_file.chr10,
#                      ama97   LIKE type_file.chr10,
#                      ama98   STRING,
#                      ama99   LIKE type_file.chr12,
#                      ama100  LIKE type_file.chr12,
#                      ama101  LIKE type_file.chr12,
#                      ama102  LIKE type_file.chr12,
#                      ama103  LIKE type_file.chr10,
#                      ama104  LIKE type_file.chr10,
#                      ama105  LIKE type_file.chr10
#                  END RECORD
#FUN-BA0021---End---
   DEFINE l_ama02  LIKE type_file.chr10
   DEFINE l_ama03  LIKE type_file.chr10
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN 0
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line

   FORMAT
      ON EVERY ROW
         LET l_y1 = tm.byy - 1911  
         LET l_m1 = tm.emm        
           
         LET l_y1 = l_y1 USING '&&&'
         LET l_m1 = l_m1 USING '&&'

         PRINT COLUMN 1,sr2.ama02[1,8] CLIPPED, 
               COLUMN 9,l_y1 CLIPPED USING '&&&',l_m1 CLIPPED USING '&&',
               COLUMN 14,sr2.ama15 CLIPPED,
#FUN-BA0021--Begin--
               COLUMN 15,sr2.amk04 CLIPPED,
               COLUMN 25,sr2.amk05 CLIPPED,
               COLUMN 35,sr2.amk06 CLIPPED,
               COLUMN 45,sr2.amk07 CLIPPED,
               COLUMN 55,sr2.amk08 CLIPPED,
               COLUMN 65,sr2.amk09 CLIPPED,
               COLUMN 75,sr2.amk10 CLIPPED,
               COLUMN 85,sr2.amk11 CLIPPED,
               COLUMN 95,sr2.amk12 CLIPPED,
               COLUMN 105,sr2.amk13 CLIPPED,
               COLUMN 115,sr2.amk14 CLIPPED,
               COLUMN 125,sr2.amk15 CLIPPED,
               COLUMN 135,sr2.amk16 CLIPPED,
               COLUMN 145,sr2.amk17 CLIPPED,
               COLUMN 155,sr2.amk18 CLIPPED,
               COLUMN 165,sr2.amk19 CLIPPED,
               COLUMN 175,sr2.amk20 CLIPPED,
               COLUMN 185,sr2.amk21 CLIPPED,
               COLUMN 195,sr2.amk22 CLIPPED,
               COLUMN 205,sr2.amk23 CLIPPED,
               COLUMN 215,sr2.amk24 CLIPPED,
               COLUMN 225,sr2.amk25 CLIPPED,
               COLUMN 235,sr2.amk26 CLIPPED,
               COLUMN 245,sr2.amk27 CLIPPED,
               COLUMN 255,sr2.amk28 CLIPPED,
               COLUMN 265,sr2.amk29 CLIPPED,
               COLUMN 275,sr2.amk30 CLIPPED,
               COLUMN 285,sr2.amk31 CLIPPED,
               COLUMN 295,sr2.amk32 CLIPPED,
               COLUMN 305,sr2.amk33 CLIPPED,
               COLUMN 315,sr2.amk34 CLIPPED,
               COLUMN 325,sr2.amk35 CLIPPED,
               COLUMN 335,sr2.amk36 CLIPPED,
               COLUMN 345,sr2.amk37 CLIPPED,
               COLUMN 355,sr2.amk38 CLIPPED,
               COLUMN 365,sr2.amk39 CLIPPED,
               COLUMN 375,sr2.amk52 CLIPPED,
               COLUMN 385,sr2.amk53 CLIPPED,
               COLUMN 395,sr2.amk54 CLIPPED,
               COLUMN 405,sr2.amk55 CLIPPED,
               COLUMN 415,sr2.amk56 CLIPPED,
               COLUMN 425,sr2.amk57 CLIPPED,
               COLUMN 435,sr2.amk58 CLIPPED,
               COLUMN 445,sr2.amk59 CLIPPED,
               COLUMN 455,sr2.amk60 CLIPPED,
               COLUMN 465,sr2.amk61 CLIPPED,
               COLUMN 475,sr2.amk62 CLIPPED,
               COLUMN 485,sr2.amk63 CLIPPED,
               COLUMN 495,sr2.amk64 CLIPPED,
               COLUMN 505,sr2.amk65 CLIPPED,
               COLUMN 515,sr2.amk66 CLIPPED,
               COLUMN 525,sr2.amk67 CLIPPED,
               COLUMN 535,sr2.amk68 CLIPPED,
               COLUMN 545,sr2.amk69 CLIPPED,
               COLUMN 555,sr2.amk70 CLIPPED,
               COLUMN 565,sr2.amk71 CLIPPED,
               COLUMN 575,sr2.amk72 CLIPPED,
               COLUMN 585,sr2.amk73 CLIPPED,
               COLUMN 595,sr2.amk74 CLIPPED,
               COLUMN 605,sr2.amk75 CLIPPED,
               COLUMN 615,sr2.amk76 CLIPPED,
               COLUMN 625,sr2.amk77 CLIPPED,
               COLUMN 628,sr2.amk40 CLIPPED,
               COLUMN 640,sr2.amk41 CLIPPED,
               COLUMN 652,sr2.amk42 CLIPPED,
               COLUMN 664,sr2.amk43 CLIPPED,
               COLUMN 676,sr2.amk44 CLIPPED,
               COLUMN 686,sr2.amk45 CLIPPED,
               COLUMN 696,'0000000000',
               COLUMN 706,sr2.amk46 CLIPPED,
               COLUMN 718,sr2.amk47 CLIPPED,
               COLUMN 730,sr2.amk48 CLIPPED,
               COLUMN 742,sr2.amk49 CLIPPED,
               COLUMN 754,sr2.amk50 CLIPPED,
               COLUMN 764,sr2.amk51 CLIPPED,
               COLUMN 774,'0000000000',
               COLUMN 784,'000000000000',
               COLUMN 796,'000000000000',
               COLUMN 808,'000000000000',
               COLUMN 820,'000000000000',
               COLUMN 832,sr2.amk78 CLIPPED,
               COLUMN 844,sr2.amk79 CLIPPED,
               COLUMN 856,sr2.amk80 CLIPPED,
               COLUMN 868,sr2.amk81 CLIPPED,
               COLUMN 880,sr2.amk82 CLIPPED,
               COLUMN 890,sr2.amk83 CLIPPED,
               COLUMN 900,sr2.amk84 CLIPPED,
               COLUMN 910,sr2.ama03[1,9] CLIPPED,
               COLUMN 919,'000'
#              COLUMN 15,sr2.ama25 CLIPPED,
#              COLUMN 25,sr2.ama26 CLIPPED,
#              COLUMN 35,sr2.ama27 CLIPPED,
#              COLUMN 45,sr2.ama28 CLIPPED,
#              COLUMN 55,sr2.ama29 CLIPPED,
#              COLUMN 65,sr2.ama30 CLIPPED,
#              COLUMN 75,sr2.ama31 CLIPPED,
#              COLUMN 85,sr2.ama32 CLIPPED,
#              COLUMN 95,sr2.ama33 CLIPPED,
#              COLUMN 105,sr2.ama34 CLIPPED,
#              COLUMN 115,sr2.ama35 CLIPPED,
#              COLUMN 125,sr2.ama36 CLIPPED,
#              COLUMN 135,sr2.ama37 CLIPPED,
#              COLUMN 145,sr2.ama38 CLIPPED,
#              COLUMN 155,sr2.ama39 CLIPPED,
#              COLUMN 165,sr2.ama40 CLIPPED,
#              COLUMN 175,sr2.ama41 CLIPPED,
#              COLUMN 185,sr2.ama42 CLIPPED,
#              COLUMN 195,sr2.ama43 CLIPPED,
#              COLUMN 205,sr2.ama44 CLIPPED,
#              COLUMN 215,sr2.ama45 CLIPPED,
#              COLUMN 225,sr2.ama46 CLIPPED,
#              COLUMN 235,sr2.ama47 CLIPPED,
#              COLUMN 245,sr2.ama48 CLIPPED,
#              COLUMN 255,sr2.ama49 CLIPPED,
#              COLUMN 265,sr2.ama50 CLIPPED,
#              COLUMN 275,sr2.ama51 CLIPPED,
#              COLUMN 285,sr2.ama52 CLIPPED,
#              COLUMN 295,sr2.ama53 CLIPPED,
#              COLUMN 305,sr2.ama54 CLIPPED,
#              COLUMN 315,sr2.ama55 CLIPPED,
#              COLUMN 325,sr2.ama56 CLIPPED,
#              COLUMN 335,sr2.ama57 CLIPPED,
#              COLUMN 345,sr2.ama58 CLIPPED,
#              COLUMN 355,sr2.ama59 CLIPPED,
#              COLUMN 365,sr2.ama60 CLIPPED,
#              COLUMN 375,sr2.ama73 CLIPPED,
#              COLUMN 385,sr2.ama74 CLIPPED,
#              COLUMN 395,sr2.ama75 CLIPPED,
#              COLUMN 405,sr2.ama76 CLIPPED,
#              COLUMN 415,sr2.ama77 CLIPPED,
#              COLUMN 425,sr2.ama78 CLIPPED,
#              COLUMN 435,sr2.ama79 CLIPPED,
#              COLUMN 445,sr2.ama80 CLIPPED,
#              COLUMN 455,sr2.ama81 CLIPPED,
#              COLUMN 465,sr2.ama82 CLIPPED,
#              COLUMN 475,sr2.ama83 CLIPPED,
#              COLUMN 485,sr2.ama84 CLIPPED,
#              COLUMN 495,sr2.ama85 CLIPPED,
#              COLUMN 505,sr2.ama86 CLIPPED,
#              COLUMN 515,sr2.ama87 CLIPPED,
#              COLUMN 525,sr2.ama88 CLIPPED,
#              COLUMN 535,sr2.ama89 CLIPPED,
#              COLUMN 545,sr2.ama90 CLIPPED,
#              COLUMN 555,sr2.ama91 CLIPPED,
#              COLUMN 565,sr2.ama92 CLIPPED,
#              COLUMN 575,sr2.ama93 CLIPPED,
#              COLUMN 585,sr2.ama94 CLIPPED,
#              COLUMN 595,sr2.ama95 CLIPPED,
#              COLUMN 605,sr2.ama96 CLIPPED,
#              COLUMN 615,sr2.ama97 CLIPPED,
#              COLUMN 625,sr2.ama98 CLIPPED,
#              COLUMN 628,sr2.ama61 CLIPPED,
#              COLUMN 640,sr2.ama62 CLIPPED,
#              COLUMN 652,sr2.ama63 CLIPPED,
#              COLUMN 664,sr2.ama64 CLIPPED,
#              COLUMN 676,sr2.ama65 CLIPPED,
#              COLUMN 686,sr2.ama66 CLIPPED,
#              COLUMN 696,'0000000000',
#              COLUMN 706,sr2.ama67 CLIPPED,
#              COLUMN 718,sr2.ama68 CLIPPED,
#              COLUMN 730,sr2.ama69 CLIPPED,
#              COLUMN 742,sr2.ama70 CLIPPED,
#              COLUMN 754,sr2.ama71 CLIPPED,
#              COLUMN 764,sr2.ama72 CLIPPED,
#              COLUMN 774,'0000000000',
#              COLUMN 784,'000000000000',
#              COLUMN 796,'000000000000',
#              COLUMN 808,'000000000000',
#              COLUMN 820,'000000000000',
#              COLUMN 832,sr2.ama99 CLIPPED,
#              COLUMN 844,sr2.ama100 CLIPPED,
#              COLUMN 856,sr2.ama101 CLIPPED,
#              COLUMN 868,sr2.ama102 CLIPPED,
#              COLUMN 880,sr2.ama103 CLIPPED,
#              COLUMN 890,sr2.ama104 CLIPPED,
#              COLUMN 900,sr2.ama105 CLIPPED,
#              COLUMN 910,sr2.ama03[1,9] CLIPPED,
#              COLUMN 919,'000'
#FUN-BA0021---End---
END REPORT
#---FUN-B40063 end------------------------------------------
 
FUNCTION p100_4()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680074 VARCHAR(20) # External(Disk) file name 
          l_sql     STRING,                      # RDSQL STATEMENT                #No.FUN-680074
          l_chr     LIKE type_file.chr1,         #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680074 VARCHAR(40)    
          l_amd39   LIKE amd_file.amd39,         #MOD-970006 add
          sr4       RECORD
                       ama02  LIKE type_file.chr8,          #賣方統一編號   #MOD-6B0059
                       ama14  LIKE type_file.chr1,   #縣市別
                       ama03  LIKE type_file.chr9,   #稅籍編號
                       amd26 LIKE type_file.num5,     #年度
                       amd27 LIKE type_file.num5,     #月份
                       amd05  LIKE type_file.dat,    #發票日期
                       amd03  LIKE amd_file.amd03,   #發票編號
                       amd04  LIKE type_file.chr8,          #買受人統一編號   #MOD-6B0059
                       amd35  LIKE type_file.chr1,   #外銷方式
                       amd10  LIKE type_file.chr1,   #通關方式註記
                       amd38  LIKE type_file.chr2,   #類別
                       amd39  LIKE type_file.chr14,  #號碼
                       amd08  LIKE amd_file.amd08,   #扣抵稅額 
                      #amd43  LIKE type_file.chr7,   #輸出或結匯日期   #MOD-A80244 mark
                       amd43  LIKE amd_file.amd43,   #輸出或結匯日期   #MOD-A80244
                       amd171 LIke amd_file.amd171   #MOD-7B0153
                    END RECORD
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'      #MOD-A90042

  #LET l_sql = "SELECT SUM(amd08) FROM amd_file ",                                 #MOD-BB0216 mark
   LET l_sql = "SELECT SUM(amd08) ",                                               #MOD-BB0216 add
               "  FROM amd_file,ama_file",                                         #MOD-BB0216 add
               " WHERE (amd173*12+amd174 BETWEEN ",tm.byy*12+tm.bmm,
               "   AND ",tm.eyy*12+tm.emm,")",
               "   AND amd171 IN ('31','32','35','36')",
               "   AND amd30 = 'Y'",
               "   AND amd172= '2'",
               "   AND amd39 = ?",
               "   AND amd22 = ama01"                                              #MOD-BB0216 add 
  #-------------------------------------MOD-B90114-----------start
   IF (g_ama24 = 'Y' AND g_ama15 = '1') THEN
      LET l_sql = l_sql,
          "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))"
   ELSE
      LET l_sql = l_sql,
          "   AND amd22 = '",tm.ama01,"'"
   END IF
  #-------------------------------------MOD-B90114-----------end
   PREPARE p1004_prepare0 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare0',STATUS,0) END IF
   DECLARE p1004_curs0 CURSOR FOR p1004_prepare0
 
   LET l_sql = "SELECT '','','',amd26,amd27,amd05,amd03,",   #MOD-6B0033    #MOD-6B0059
               "       amd04,amd35,amd10,amd38,amd39,amd08,amd43,amd171",   #MOD-6B0059   #MOD-7B0153
              #"  FROM amd_file ",                                          #MOD-BB0216 mark
               "  FROM amd_file,ama_file ",                                 #MOD-BB0216 add
               " WHERE (amd173*12+amd174 BETWEEN ",tm.byy*12+tm.bmm,
               "   AND ",tm.eyy*12+tm.emm,") ",
               "   AND  amd171 IN ('31','32','35','36') ",   #MOD-730074
               "   AND amd30 = 'Y' ",
               "   AND amd172 = '2'",
               "   AND amd22 = ama01"                                        #MOD-BB0216 add
              #" ORDER BY amd04,amd05,amd39"  #MOD-970006 #MOD-B90114 mark
  #-------------------------------------MOD-B90114-----------------------------------------------start
   IF (g_ama24 = 'Y' AND g_ama15 = '1') THEN
      LET l_sql = l_sql,
          "   AND (amd22 = '",tm.ama01,"' OR (amd22<> '",tm.ama01,"' AND ama23 ='",g_ama02,"'))",
         #" ORDER BY amd04,amd05,amd39"  #MOD-B90193 mark
          " ORDER BY amd04,amd39,amd05"  #MOD-B90193 add
   ELSE
      LET l_sql = l_sql,
          "   AND amd22 = '",tm.ama01,"'",
         #" ORDER BY amd04,amd05,amd39"  #MOD-B90193 mark
          " ORDER BY amd04,amd39,amd05"  #MOD-B90193 add
   END IF
  #-------------------------------------MOD-B90114--------------------------------------------------end 
   PREPARE p1004_prepare FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare4',STATUS,0) END IF
   DECLARE p1004_curs CURSOR FOR p1004_prepare
 
   LET l_name  = tm.rep CLIPPED,'.T02'
   LET g_name  = l_name   #FUN-6B0062
 
   SELECT UNIQUE zaa12 INTO g_page_line FROM zaa_file WHERE zaa01=g_prog
 
   START REPORT p100_rep4 TO l_name
 
   LET l_amd39 =' '   #MOD-970006 add
   FOREACH p1004_curs INTO sr4.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach4:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET sr4.ama14 = g_ama14
      LET sr4.ama03 = g_ama03
      LET sr4.ama02 = g_ama02   #MOD-6B0059
      IF g_ooz.ooz64 = 'N' THEN                             #MOD-A90042
        #同一張報單金額應只呈現在第一筆,其他筆空白
         IF NOT cl_null(sr4.amd39) AND sr4.amd39 != ' ' THEN   #MOD-970100 add
            IF sr4.amd39 != l_amd39 THEN
               OPEN p1004_curs0 USING sr4.amd39
               FETCH p1004_curs0 INTO sr4.amd08
               CLOSE p1004_curs0
               LET l_amd39 = sr4.amd39
            ELSE
              IF cl_null(sr4.amd03) THEN  #MOD-B70156 add
                 LET sr4.amd08 = 0        #MOD-A40155 mark #MOD-B70156 add
              ELSE                        #MOD-B70156 add
                 CONTINUE FOREACH         #MOD-A40155 add
              END IF                      #MOD-B70156 add
            END IF
         END IF   #MOD-970100 add
      END IF                                                #MOD-A90042
      IF cl_null(sr4.amd08) THEN
         LET sr4.amd08 = 0
      END IF
      IF sr4.amd171 = '36' THEN
         LET sr4.amd03 = ''
      END IF
 
      OUTPUT TO REPORT p100_rep4(sr4.*)
 
   END FOREACH
 
   FINISH REPORT p100_rep4
   CALL cl_addcr(l_name)   #CHI-850019 add
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END FUNCTION
REPORT p100_rep4(sr4)
   DEFINE l_last_sw    LIKE type_file.chr1,
          l_yy,l_mm    LIKE type_file.num5,
          l_cyy,l_cyy1 LIKE type_file.chr3,
          l_yy1,l_mm1,l_dd1  LIKE type_file.num5,
          l_cmm,l_cmm1,l_cdd1 LIKE type_file.chr2,
          sr4          RECORD
                          ama02  LIKE type_file.chr8,          #賣方統一編號   #MOD-6B0059
                          ama14  LIKE type_file.chr1,   #縣市別
                          ama03  LIKE type_file.chr9,   #稅籍編號
                          amd26 LIKE type_file.num5,          #年度
                          amd27 LIKE type_file.num5,          #月份
                          amd05  LIKE type_file.dat,    #發票日期
                          amd03  LIKE amd_file.amd03,   #發票編號
                          amd04  LIKE type_file.chr8,          #買受人統一編號   #MOD-6B0059
                          amd35  LIKE type_file.chr1,   #外銷方式
                          amd10  LIKE type_file.chr1,   #通關方式註記
                          amd38  LIKE type_file.chr2,   #類別
                          amd39  LIKE type_file.chr14,  #號碼
                          amd08  LIKE amd_file.amd08,   #扣抵稅額 
                         #amd43  LIKE type_file.chr7,   #輸出或結匯日期   #MOD-A80244 mark
                          amd43  LIKE amd_file.amd43,   #輸出或結匯日期   #MOD-A80244
                          amd171 LIke amd_file.amd171   #MOD-7B0153
                       END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN 0
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr4.amd04,sr4.ama14,sr4.ama03
 
   FORMAT
      ON EVERY ROW
         LET l_yy = tm.byy - 1911
         LET l_mm = tm.emm
         
         LET l_cyy = l_yy USING '&&&'
         LET l_cmm = l_mm USING '&&'
 
        #LET l_yy1 = YEAR(sr4.amd05) - 1911            #MOD-A80244 mark
        #LET l_mm1 = MONTH(sr4.amd05)                  #MOD-A80244 mark
        #LET l_dd1 = DAY(sr4.amd05)   #MOD-6B0059      #MOD-A80244 mark
        #-MOD-A80244-add-
         IF NOT cl_null(sr4.amd43) THEN
            LET l_yy1 = YEAR(sr4.amd43) - 1911
            LET l_mm1 = MONTH(sr4.amd43)
            LET l_dd1 = DAY(sr4.amd43)   
         ELSE
            LET l_yy1 = YEAR(sr4.amd05) - 1911
            LET l_mm1 = MONTH(sr4.amd05)
            LET l_dd1 = DAY(sr4.amd05)  
         END IF
        #-MOD-A80244-end-
 
         LET l_cyy1 = l_yy1 USING '&&&'
         LET l_cmm1 = l_mm1 USING '&&'
         LET l_cdd1 = l_dd1 USING '&&'   #MOD-6B0059
 
         PRINT COLUMN  1,sr4.ama02[1,8] CLIPPED,   #MOD-6B0059
               COLUMN  9,sr4.ama14[1,1] CLIPPED,
               COLUMN 10,sr4.ama03[1,9] CLIPPED,
               COLUMN 19,l_cyy CLIPPED USING '&&&',l_cmm CLIPPED USING '&&',
               COLUMN 24,l_cyy1 CLIPPED USING '&&&',l_cmm1 CLIPPED USING '&&',
               COLUMN 29,sr4.amd03[1,10] CLIPPED,
               COLUMN 39,sr4.amd04[1,8] CLIPPED,   #MOD-6B0059
               COLUMN 47,sr4.amd35[1,1] CLIPPED,
               COLUMN 48,sr4.amd10[1,1] CLIPPED,
               COLUMN 49,sr4.amd38[1,2] CLIPPED,
               COLUMN 51,sr4.amd39[1,14] CLIPPED,
               COLUMN 65,sr4.amd08 CLIPPED USING '&&&&&&&&&&&&',
               COLUMN 77,l_cyy1 CLIPPED USING '&&&',l_cmm1 CLIPPED USING '&&',l_cdd1 CLIPPED USING '&&'   #MOD-6B0059
 
END REPORT
 
FUNCTION p100_set_entry()
   #CALL cl_set_comp_entry("e",TRUE)
   CALL cl_set_comp_entry("e,deduct,a,upd,b,d,fil,rep,rep1,",TRUE)    #FUN-B40063
END FUNCTION

FUNCTION p100_set_no_entry()
  #IF tm.fil = '1' OR tm.fil = '4' THEN         #MOD-A40070 mark
   IF tm.fil != '1' THEN                        #MOD-A40070 add
      CALL cl_set_comp_entry("e",FALSE)
      LET tm.e = 'N'
      DISPLAY BY NAME tm.e
   END IF
   #---FUN-B40063 start---
   IF tm.type = '1' THEN
      CALL cl_set_comp_entry("deduct,upd,rep1",FALSE)
   END IF

   IF tm.upd = 'Y' THEN
      CALL cl_set_comp_entry("b,d,fil,rep,rep1",FALSE)
   END IF

   IF tm.deduct = '1' THEN
      CALL cl_set_comp_entry("upd",FALSE)
   ELSE
      CALL cl_set_comp_entry("a",FALSE)
   END IF

   IF tm.fil !=  '3' THEN
      CALL cl_set_comp_entry("rep1",FALSE)
   ELSE
      CALL cl_set_comp_entry("rep",FALSE)
   END IF
   #--FUN-B40063 end----

END FUNCTION

#---FUN-B40063 start--
FUNCTION p001_set_no_required()
      CALL cl_set_comp_required("rep1",FALSE)
END FUNCTION
#--FUN-B40063 end---

FUNCTION p001_set_required()   
      CALL cl_set_comp_required("ama01,rep,fil,byy,bmm,emm",TRUE)
      #--FUN-B40063 start--
      IF tm.fil = '3' THEN  
          CALL cl_set_comp_required("rep1",TRUE)
      END IF
      #--FUN-B40063 end---
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
