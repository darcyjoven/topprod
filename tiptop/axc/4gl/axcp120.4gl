# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axcp120.4gl
# Descriptions...: LCM 存貨成品成本計算作業
# Date & Author..: 99/03/29 By Linda
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4C0005 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530637 05/03/31 By Carol Define ima08='P','V'->cma03='0', 其它 cma03='2'
# Modify.........: No.FUN-550110 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-5A0226 05/10/20 By Sarah 資料處理若選1.全部資料時,未過濾tm.wc
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7B0117 07/12/18 By Sarah 移除QBE的 類別 選擇功能
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting完善錯誤信息修改
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.TQC-8C0060 08/12/23 By sherry 採購單價應轉換成本幣
# Modify.........: No.TQC-8C0018 08/12/24 By sherry 半成品取價
# Modify.........: No.TQC-910013 09/01/09 By kim 十號公報修改
# Modify.........: No.MOD-920011 09/02/02 By Pengu 展BOM考慮生失效日期時應該用計算基準日"(tm.bdate)
# Modify.........: No.MOD-920145 09/02/16 By Pengu 工單入庫處理部份未包含Runcard 工單
# Modify.........: No.MOD-920155 09/02/16 By Pengu AFTER FIELD kind選擇2時,不應再檢查cma_file是否存在
# Modify.........: No.CHI-910033 09/02/25 By jan 計算各料號的重置單價時.沒有考慮到單位換算率
# Modify.........: No.CHI-920003 09/03/03 By jan p150_p1_3() 當選逆推成品時,抓不到逆推的bom時，也要往下執行，不應RETURN回去
# Modify.........: No.MOD-930041 09/03/04 By shiwuying SQL中欄位錯誤
# Modify.........: No.FUN-930075 09/03/12 By jan 逆推成本時無考慮聯產品
# Modify.........: No.CHI-920005 09/03/13 By jan trn_price和l_price作以下單位換算處理
# Modify.........: No.FUN-930100 09/03/25 By jan 新增"計算成品出貨量/入庫量起始日"欄位
# Modify.........: No.CHI-940029 09/04/14 By jan 1.展BOM時(兩個地方都要改)，寫入cmh03應該是 g_ccc.ccc01而不是展出的bmb03
# .............................................. 2.新增 凈變現單價平均值取價起始日 欄位
# Modify.........: NO.TQC-940146 09/04/28 By jan DDL的SQL不可寫在transation中
# Modify.........: NO.TQC-940181 09/04/30 By jan 改SQL語句
# Modify.........: No.FUN-950025 09/05/11 By lutingting完善錯誤匯總信息,以利于確認錯誤得料號
# Modify.........: NO.FUN-950058 09/05/18 By kim for 十號公報-將取單價的所有單據/項次,記錄於cmg_file
# Modify.........: NO.TQC-960080 09/06/09 By jan 在CALL p150_p1_0_get(2,l_cmh04) 前加一個判斷的，增加axcp120效能
# Modify.........: NO.TQC-960081 09/06/10 By jan 當計算類別 選1時，重計前不需刪除當期的全部資料
# Modify.........: NO.MOD-960135 09/06/10 By mike SQL語句寫法有誤         
# Modify.........: NO.CHI-970033 09/07/15 By jan 解決 凈變現單價會為負值的問題
# Modify.........: NO.CHI-970011 09/07/15 By jan 若axcs020上的凈變現逆推成本的排序沒有設定，執行中會當掉
# Modify.........: NO.CHI-960084 09/07/15 By jan jan 重復單位換算mark掉
# Modify.........: No.CHI-970034 09/07/20 By jan 1:期間內的單據總出貨數量，除上個別單據的出貨數量，得到比重后，再乘上個別單據的單價，加總起來
# ...............................................2:錯誤信息以報表形式顯示
# Modify.........: NO.FUN-970090 09/08/10 By jan 呆滯料不應該納入LCM計算(包含展BOM)
# Modify.........: NO.CHI-920004 09/08/10 By jan 將此程式所有的Transaction移除
# Modify.........: NO.CHI-970063 09/08/10 By jan _back_1() 如果逆推成品沒卷算過單據單據啊才需要卷算
# Modify.........: NO.FUN-970102 09/08/10 By jan 移除cmz01/cmz02/cmz70
# Modify.........: NO.CHI-970066 09/08/10 By jan 更改最近異動日(cma16)算法
# Modify.........: NO.CHI-970067 09/08/10 By jan 當料號有設人工市價時：cma27="MARKET"/cma28=NULL
# Modify.........: NO.FUN-970103 09/08/10 By jan 畫面增加"入庫種類"選項，._bom()及_bom_2()抓入庫量時(出庫量的邏輯不變)，針對所挑選的選項，對tlf13篩選
# Modify.........: NO.CHI-970054 09/08/10 By jan 調整已結筆數算法
# Modify.........: NO.CHI-980002 09/08/10 By jan 程式修改
# Modify.........: NO.CHI-980003 09/08/10 By jan 1:逆推成品取代料號時,cmh_file只需保留"代表料號"的資料。其余刪除(否則axcr154會顯示多筆)
# ...............................................2:取得cma25后,將結果更新回cmh041
# Modify.........: NO.TQC-980008 09/08/10 By jan 錯誤信息打印時，拿掉IF tm.no_tot <> tm.no_ok THEN判斷條件
# Modify.........: NO.CHI-980006 09/08/10 By jan 根據cmz23的設定來抓入庫量或出庫量
# Modify.........: NO.CHI-980009 09/08/10 By jan 1.取人工市價get_i311()要再重抓一次該料號的銷售費用率
# .............................................. 2.取成本價不可再扣銷售費用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO:MOD-9A0066 09/10/09 By mike 1.在p150_bom_2() FUNCTION中新增l_bmm06变数                                        
#                                                 2.在FOREACH p150_bom_bmm06 INTO后面应该再多接l_bmm06变数                          
#                                                 3.sr[l_ac].qpa应该该为l_qpa * (l_bmm06/100) 
# Modify.........: No:MOD-9A0095 09/10/27 By sabrina 調整p150_bom_2()中bmb03的給值
# Modify.........: No:MOD-9A0159 09/10/27 By sabrina 應排除MISC料號
# Modify.........: No.CHI-980020 09/11/04 By jan 程式修改
# Modify.........: No.FUN-980077 09/11/04 By jan cma16最近異動日期應依照tm.b1 入庫範圍的選項取tlf的最大值
# Modify.........: No.FUN-980062 09/11/04 By jan 程式已改成不CALL Transation了，不需再用g_success判斷成功與否
# Modify.........: No.FUN-980088 09/11/04 By jan _bom()和_bom_2()里面，不需要再勾稽 p120_file
# Modify.........: No.CHI-980053 09/11/04 By jan _bom()考慮bmb29條件
# Modify.........: No.FUN-980101 09/11/04 By jan 程式調整
# Modify.........: No.CHI-980069 09/11/04 By jan _back_1() 凈變現單價不可為負值
# Modify.........: No.FUN-980117 09/11/04 By jan 若成品無ccc23,則抓離最近那期的cca23 
# Modify.........: No.FUN-980122 09/11/04 By jan 處理完所有料號才將cma25為負值的資料清成0,
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-980031 09/11/11 By jan 程式語法調整
# Modify.........: No:MOD-970208 09/11/25 By sabrina cma271欄位應default為NULL
# Modify.........: No:MOD-970162 09/11/26 By sabrina 加總imk09未考慮庫存轉換率
# Modify.........: No:CHI-9C0025 09/12/22 By kim add 成本計算類別(cma07)及類別編號(cma08)
# Modify.........: No:TQC-A10001 10/01/04 By kim 修正CHI-9C0025的問題
# Modify.........: No.FUN-9C0073 10/01/11 By chenls 程序精簡
# Modify.........: No:TQC-A10116 10/01/13 By kim 修正CHI-9C0025的問題
# Modify.........: No:MOD-A10051 10/01/13 By Pengu 計算應收金額時未考慮匯率
# Modify.........: No:MOD-A30007 10/03/29 By Summer 當淨變現單價的取價方式為3.取平均值時,應該用該料號的本幣金額/數量來計算
# Modify.........: No:MOD-A30174 10/03/29 By Summer 取消arrno的限制
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No:MOD-A60060 10/06/09 By Sarah 修正MOD-A30174,資料抓完就EXIT WHILE
# Modify.........: No:MOD-A60101 10/06/15 By Sarah tm.b1='Y'時,需增加抓tlf13='asft6231'的資料
# Modify.........: No:MOD-AA0048 10/10/11 By sabrina 修正MOD-A30174,資料抓完就EXIT WHILE
# Modify.........: No:MOD-AA0155 10/10/26 By sabrina (1)成本計算有誤
#                                                    (2)取淨變現單價未考慮計價單位
# Modify.........: No:FUN-AB0036 10/11/11 By jan 新增cmz28欄位
# Modify.........: No:MOD-9C0101 10/11/26 By sabrina 執報表時，列印格式跑掉
# Modify.........: No:MOD-B10076 11/01/11 By sabrina 半成品之再投入成本的料號成本應乘上QPA
# Modify.........: No:MOD-B10130 11/01/18 By sabrina 取	MAX(price)時，單號和項次也要重新抓取 
# Modify.........: No:FUN-B30173 11/03/25 By lixh1  「無法抓到單價」的料件無法區分出「原料、半成品、製成品」
# Modify.........: No:MOD-B30684 11/03/28 By sabrina 在讀取應收資料時應排除作廢資料
# Modify.........: No:FUN-B30212 11/03/31 By shenyang 程序追單處理
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B30218 11/04/01 By shenyang 程序追單處理
# Modify.........: No:MOD-B40049 11/07/17 By Pengu 調整FUN-B30218的公式
# Modify.........: No:MOD-B30672 11/07/17 By JoHung 逆推成品選擇"取成品代表料號"最後算再投入成本後，應再除qpa
# Modify.........: No:MOD-B60110 11/07/17 By Summer g_cma.cma271日期抓取有誤
# Modify.........: No:MOD-C10169 12/01/30 By ck2yuan 修改註解 符合程式邏輯
# Modify.........: No:MOD-BA0181 12/02/16 By Pengu 調整除外倉數量計算
# Modify.........: No:CHI-B60002 12/02/23 By ck2yuan 在逆推成品淨變現時應考慮成品的生產與庫存單位換算率
# Modify.........: No:MOD-C20175 12/02/23 By ck2yuan 出貨應在乘上tlf907避免負值
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:MOD-C30068 12/03/08 By ck2yuan 取位應參考ccc26設定
# Modify.........: No:CHI-B80090 12/03/08 By ck2yuan 刪除LCM相關table時，依UI畫面查詢條件刪除
# Modify.........: No:MOD-C10167 12/03/08 By ck2yuan 排除無效料號
# Modify.........: No:MOD-C30735 12/03/15 By ck2yuan 清空變數值,避免抓不到而使用到上一筆資料
# Modify.........: No:MOD-C30888 12/03/29 By ck2yuan 抓原料單價時,應抓未稅單價
# Modify.........: No:MOD-C40074 12/04/10 By ck2yuan 1.展BOM應排除回收料 2.用tlf07判斷tlf的應用tlf06 3.應過濾掉出貨簽收
# Modify.........: No:CHI-C50013 12/05/10 By Elise aooi312的成本性質為3.原料時，類別為"原料"，其他則為"成品"
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No:MOD-B90277 12/06/18 By ck2yuan 取開張資料時不應乘上銷售費用率
# Modify.........: No:MOD-B90275 12/06/18 By ck2yuan 原物料取平均值時，若是取到成本價時cma27也應顯示"CCC-9999999999"
# Modify.........: No:CHI-C50065 12/06/25 By Smapmin BOM的最上階也是半成品時,下階半成品的淨變現價值計算會有問題
# Modify.........: No:MOD-C70151 12/07/12 By ck2yuan 當cam25是取平均單價時，不用再除cmh031
# Modify.........: No:MOD-C70282 12/08/03 By ck2yuan 盤點或倉退 異動數量=0 不應影響最後異動日 ,故sql加上tlf10<>0
# Modify.........: No:MOD-C60024 12/08/08 By ck2yuan 此單不用修改
# Modify.........: No:CHI-C80002 12/10/01 By bart 改善效能 1.NOT IN 改為 NOT EXISTS
# Modify.........: No:MOD-CB0125 12/11/23 By Elise 期別不一定等於月份,調整sql
# Modify.........: No:CHI-CC0006 12/12/13 By bart 依參數決定是否計算聯產品分配率
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
# Modify.........: No:CHI-BC0007 11/12/01 By Pengu 當原物料是逆推成品料號時，當AR取不到時應在取AP若也取不到才取成本
# Modify.........: No:MOD-D10183 13/01/24 By bart 抓取apb_file的資料時,應加上apb29='1'的條件
# Modify.........: No:MOD-D20049 13/03/13 By Alberti p120_ar()中抓取應付帳款單價時判斷oma213
# Modify.........: No:MOD-D40113 13/04/17 By ck2yuan 判斷 g_success='N' 顯示不成功，然後刪除該料LCM對應資料,並讓其繼續執行

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            wc      STRING,       #No.FUN-680122 ,   #FUN-950058
            type    LIKE type_file.chr1,          #FUN-8B0047
            ctype   LIKE ccc_file.ccc07,          #CHI-9C0025
            yy      LIKE type_file.num5,          #FUN-8B0047
            mm      LIKE type_file.num5,          #FUN-8B0047
            bdate   LIKE type_file.dat,           #基準日       #No.FUN-680122 
            cmz70   LIKE type_file.dat,           #異動起始日   #No.FUN-680122 
            qtydate LIKE type_file.dat,           #FUN-930100
            kind    LIKE type_file.chr1,          #資料處理類別 #No.FUN-680122 
            b1      LIKE type_file.chr1,          #FUN-970103
            b2      LIKE type_file.chr1,          #FUN-970103
            b3      LIKE type_file.chr1,          #FUN-970103
            price1  LIKE type_file.num20_6,       #標準工時單價 #No.FUN-680122     #MOD-4C0005
            price2  LIKE type_file.num20_6,       #製造工時單價 #No.FUN-680122     #MOD-4C0005
            cme06        LIKE cme_file.cme06,     #銷售費用率分類 #FUN-8B0047
            choice       LIKE type_file.chr1,     #原料評價       #FUN-8B0047
            cmz28        LIKE cmz_file.cmz28,     #FUN-AB0036
            choice2      LIKE type_file.chr1,     #單價選項       #FUN-8B0047
            choice4      LIKE type_file.chr1,     #FUN-930100
            avgdate      LIKE type_file.dat,      #CHI-940029
            choice3      LIKE type_file.chr1,     #FUN-930100
            choice5      LIKE type_file.chr1,     #FUN-930100
            s            LIKE type_file.chr3,     #逆推成品的排序 #FUN-8B0047
            s1           LIKE type_file.chr1,     #逆推成品的排序1 #FUN-8B0047
            s2           LIKE type_file.chr1,     #逆推成品的排序2 #FUN-8B0047
            s3           LIKE type_file.chr1,     #逆推成品的排序3 #FUN-8B0047
            wc1          STRING,   #FUN-8B0047  #FUN-950058
            no_tot  LIKE type_file.num10,         #應結筆數     #No.FUN-680122 
            no_ok   LIKE type_file.num10,         #已結筆數     #No.FUN-680122 
            p1      LIKE ima_file.ima57,          #階數
            p2      LIKE ima_file.ima01           #料件編號
           END RECORD,
       g_cmz   RECORD LIKE cmz_file.*,
       a_bdate,a_edate  LIKE type_file.dat,       #No.FUN-680122  #區段1
       b_bdate,b_edate  LIKE type_file.dat,       #No.FUN-680122  #區段2
       c_bdate,c_edate  LIKE type_file.dat,       #No.FUN-680122  #區段3
       yy,mm            LIKE type_file.num5,      #No.FUN-680122  #現行會計年月
       g_yy             LIKE type_file.num5,      #No.FUN-680122  #基準日之年度
       g_mm             LIKE type_file.num5       #No.FUN-680122  #基準日之月份
DEFINE l_flag           LIKE type_file.chr1,      #No.FUN-570153  #No.FUN-680122 
       g_date           STRING,                   #No:MOD-970208 add
       g_change_lang    LIKE type_file.chr1,      #No.FUN-680122  #是否有做語言切換 No.FUN-570153
       ls_date          STRING                    #No.FUN-570153
 
DEFINE g_cnt            LIKE type_file.num10      #No.FUN-680122 
DEFINE g_flag           LIKE type_file.chr1       #No.FUN-680122 
DEFINE p_row,p_col      LIKE type_file.num5       #No.FUN-680122 
DEFINE g_qbdate         LIKE type_file.dat        #FUN-930100
DEFINE g_qedate         LIKE type_file.dat        #FUN-930100    
DEFINE g_agv_bdate      LIKE type_file.dat        #FUN-930100
DEFINE g_agv_edate      LIKE type_file.dat        #FUN-930100
DEFINE g_msg            LIKE ze_file.ze03         #FUN-930100
DEFINE g_sql2           STRING   #FUN-970103
DEFINE g_nvl_str        STRING   #CHI-980053
 
DEFINE g_cma   RECORD LIKE cma_file.*  
DEFINE g_ccc23        LIKE ccc_file.ccc23      #其逆推的成品之成本單價 
DEFINE g_ccc          RECORD
         ccc01        LIKE ccc_file.ccc01,     #料號
         ccc07        LIKE ccc_file.ccc07,     #成本計算類別   #CHI-9C0025
         ccc08        LIKE ccc_file.ccc08,     #類別代號(批次號/專案號/利潤中心)  #CHI-9C0025
         ccc23        LIKE ccc_file.ccc23,     #單價
         azf06        LIKE azf_file.azf06,     #類別(成本性質)
         cma11        LIKE cma_file.cma11,     #進貨單價
         cma12        LIKE cma_file.cma12,     #銷售單價
         ima25        LIKE ima_file.ima25,     #庫存單位
         ima06        LIKE ima_file.ima06,     #主分群碼
         ima09        LIKE ima_file.ima09,     #分群碼一
         ima10        LIKE ima_file.ima10,     #分群碼二
         ima11        LIKE ima_file.ima11,     #分群碼三
         ima12        LIKE ima_file.ima12,     #成本分群
         ima131       LIKE ima_file.ima131,    #產品分類
         ima57        LIKE ima_file.ima57      #成本階數
                      END RECORD
 
MAIN
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc    = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET tm.bdate = cl_batch_bg_date_convert(ls_date)
   LET ls_date  = ARG_VAL(3)
   LET tm.cmz70 = cl_batch_bg_date_convert(ls_date)
   LET tm.qtydate = ARG_VAL(4)  #FUN-930100
   LET tm.price1= ARG_VAL(5)
   LET tm.price2= ARG_VAL(6)
   LET tm.kind  = ARG_VAL(7)
   LET g_bgjob  = ARG_VAL(8)
   LET tm.type  = ARG_VAL(9) #FUN-8B0047
   LET tm.yy    = ARG_VAL(10) #FUN-8B0047
   LET tm.mm    = ARG_VAL(11) #FUN-8B0047
   LET tm.cme06 = ARG_VAL(12) #FUN-8B0047
   LET tm.choice= ARG_VAL(13) #FUN-8B0047
   LET tm.cmz28 = ARG_VAL(14) #FUN-AB0036
   LET tm.choice2= ARG_VAL(15) #FUN-8B0047
   LET tm.s1    = ARG_VAL(16) #FUN-8B0047
   LET tm.s2    = ARG_VAL(17) #FUN-8B0047
   LET tm.s3    = ARG_VAL(18) #FUN-8B0047
   LET tm.choice3= ARG_VAL(19) #FUN-930100
   LET tm.ctype  = ARG_VAL(20) #CHI-9C0025
   LET g_date = FGL_GETENV("DBDATE")     #No:MOD-970208 add
   
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_time = TIME    #No.FUN-6A0146
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
   
    LET g_nvl_str="COALESCE"
 
   WHILE TRUE
      LET g_flag = 'Y' 
      LET g_success = 'Y'

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

      IF g_bgjob = "N" THEN
         CALL p120_tm()
         IF cl_sure(18,20) THEN 
            DROP TABLE p120_file       #TQC-940146
            CREATE TEMP TABLE p120_file    #TQC-940146
            ( cma01 LIKE bmb_file.bmb01 );  #TQC-940146
            CREATE INDEX p120_index ON p120_file(cma01)  #CHI-C80002
            LET g_totsuccess='Y'                  #MOD-D40113
            CALL p120()
            IF g_totsuccess='Y' THEN              #MOD-D40113 add
               CALL cl_end2(1) RETURNING l_flag
            ELSE                                  #MOD-D40113 add
               CALL cl_end2(2) RETURNING l_flag   #MOD-D40113 add
            END IF                                #MOD-D40113 add
            IF l_flag THEN 
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p120_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p120_w
      ELSE
         SELECT * INTO g_cmz.* FROM cmz_file WHERE cmz00 = '0'
         DROP TABLE p120_file       #TQC-940146
         CREATE TEMP TABLE p120_file    #TQC-940146
         ( cma01 LIKE bmb_file.bmb01 );  #TQC-940146
         CREATE INDEX p120_index ON p120_file(cma01)  #CHI-C80002
         CALL p120()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   DROP TABLE p120_file  #TQC-940146 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION p120_tm()
   DEFINE   l_msg     LIKE type_file.chr1000         #No.FUN-680122
   DEFINE   c         LIKE cre_file.cre08,           #No.FUN-680122
            l_yy      LIKE type_file.num5,           #No.FUN-680122
            l_mm      LIKE type_file.num5,           #No.FUN-680122
            l_cnt     LIKE type_file.num10,          #No.FUN-680122
            l_cdate   LIKE type_file.chr8            #No.FUN-680122
   DEFINE lc_cmd      LIKE type_file.chr1000         #No.FUN-680122            #No.FUN-570153
   DEFINE l_correct   LIKE type_file.chr1 #FUN-8B0047
   DEFINE l_date      LIKE type_file.dat  #FUN-8B0047
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p120_w AT p_row,p_col WITH FORM "axc/42f/axcp120" 
      ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   #讀取LCM系統參數檔
   SELECT * INTO g_cmz.*
     FROM cmz_file
    WHERE cmz00 = '0'
   IF SQLCA.SQLCODE <>0 THEN
      CALL cl_err3("sel","cmz_file","","",sqlca.sqlcode,"","sel cmz error:",1)   #No.FUN-660127
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   LET yy=g_ccz.ccz01 LET mm=g_ccz.ccz02 
   LET tm.kind='1'
   LET tm.price1=0
   LET tm.price2=0
#  LET tm.type  = '1' #FUN-8B0047
   LET tm.type  = '2' #FUN-B30173
   LET tm.yy    = g_ccz.ccz01 #FUN-8B0047
   LET tm.mm    = g_ccz.ccz02 #FUN-8B0047
   LET tm.cme06 = g_cmz.cmz18
   LET tm.choice= g_cmz.cmz19
   LET tm.choice2= g_cmz.cmz26
   LET tm.choice4= g_cmz.cmz24
   LET tm.choice3= g_cmz.cmz25
   LET tm.choice5= g_cmz.cmz17
   LET tm.avgdate= g_cmz.cmz27  #CHI-940029
   LET tm.cmz28  = g_cmz.cmz28  #FUN-AB0036 
   IF cl_null(g_cmz.cmz23) THEN
      CALL cl_err('','axc-009',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   LET tm.s1 = g_cmz.cmz23[1,3]
   LET tm.s2 = g_cmz.cmz23[2,3]
   LET tm.s3 = g_cmz.cmz23[3,3]
   LET tm.b1 = 'Y' #FUN-970103
   LET tm.b2 = 'N' #FUN-970103
   LET tm.b3 = 'N' #FUN-970103
   IF NOT cl_null(tm.yy) AND NOT cl_null(tm.mm) THEN
      CALL p120_get_qtydate(tm.yy,tm.mm) RETURNING tm.qtydate
   END IF 
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_date, tm.bdate 
   #計算異動截止日, 往後推一年半
   IF NOT cl_null(tm.bdate) THEN
      CALL p120_get_cmz70(tm.bdate) RETURNING tm.cmz70
   END IF
   LET tm.ctype = g_ccz.ccz28  #CHI-9C0025
 
   CLEAR FORM
   ERROR ''
   WHILE TRUE   #NO.FUN-570153
   CONSTRUCT BY NAME tm.wc ON ima01,ima57,ima08         #FUN-7B0117
 
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
     #ON ACTION CONTROLR           #FUN-AB0036
     #   CALL cl_show_req_fields() #FUN-AB0036
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale                    #genero
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
 
      ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
  
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
      RETURN
   END IF
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      CLOSE WINDOW p120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   CALL cl_set_comp_entry('bdate',FALSE) #FUN-8B0047
 
   DISPLAY BY NAME tm.type,tm.ctype,tm.yy,tm.mm, #FUN-8B0047 #CHI-9C0025
                   tm.bdate,tm.cmz70,tm.qtydate,tm.kind, #FUN-930100 add qtydate
                   tm.b1,tm.b2,tm.b3,                #FUN-970103 add
                   tm.price1,tm.price2,
                   tm.cme06,tm.choice,tm.choice2,tm.choice3,tm.choice4,tm.choice5,tm.s1,tm.s2,tm.s3, #FUN-8B0047
                   tm.avgdate,tm.cmz28    #CHI-940029  #FUN-AB0036
 
      LET g_bgjob = 'N'    # FUN-570153
      INPUT BY NAME
         tm.type,tm.ctype,tm.yy,tm.mm, #FUN-8B0047  #CHI-9C0025
         tm.bdate,tm.cmz70,tm.qtydate,tm.price1,tm.price2, #FUN-930100 add qtydate
         tm.kind,tm.b1,tm.b2,tm.b3,       #FUN-970103 add b1/b2/b3
         g_bgjob   #NO.FUN-570153 
         WITHOUT DEFAULTS 
 
         AFTER FIELD bdate
            IF tm.bdate IS NULL THEN
               NEXT FIELD bdate
            END IF
            LET g_yy = YEAR(tm.bdate)
            LET g_mm = MONTH(tm.bdate)
            LET g_cnt = 0
           #SELECT COUNT(*) INTO g_cnt FROM ccc_file WHERE ccc02 = g_yy AND ccc03 = g_mm   #MOD-CB0125 mark
            SELECT COUNT(*) INTO g_cnt FROM ccc_file WHERE ccc02 = tm.yy AND ccc03 = tm.mm   #MOD-CB0125
            IF g_cnt =0 OR g_cnt IS NULL THEN
               CALL cl_getmsg('axc-004',g_lang) RETURNING l_msg
               CALL cl_err(l_msg CLIPPED,'!',0)
               NEXT FIELD bdate
            END IF
      
        
         AFTER FIELD cmz70
            IF tm.cmz70 IS NULL THEN
               NEXT FIELD cmz70
            END IF
            IF tm.cmz70 > tm.bdate THEN
               NEXT FIELD cmz70
            END IF
 
         AFTER FIELD kind
            IF cl_null(tm.kind) OR tm.kind NOT MATCHES '[12]' THEN
               NEXT FIELD kind
            END IF
            
         AFTER FIELD price1
            IF cl_null(tm.price1) THEN
               LET tm.price1=0
            END IF
 
         AFTER FIELD price2
            IF cl_null(tm.price2) THEN
               LET tm.price2=0 
            END IF
 
 
         AFTER FIELD yy
            IF NOT cl_null(tm.yy) THEN
               IF tm.yy < 0 THEN
                  CALL cl_err('','mfg5034',0)
                  NEXT FIELD yy
               END IF
               IF NOT cl_null(tm.mm) THEN
                  CALL p120_get_qtydate(tm.yy,tm.mm) RETURNING tm.qtydate
                  DISPLAY BY NAME tm.qtydate
               END IF
            END IF
         
         AFTER FIELD mm
            IF NOT cl_null(tm.mm) THEN
               IF tm.mm < 1 OR tm.mm > 12 THEN
                  CALL cl_err('','aom-580',0)
                  NEXT FIELD mm
               END IF
               CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_date, tm.bdate 
               DISPLAY BY NAME tm.bdate
              #計算異動截止日, 往後推一年半
              IF NOT cl_null(tm.bdate) THEN
                 CALL p120_get_cmz70(tm.bdate) RETURNING tm.cmz70
              END IF
               IF NOT cl_null(tm.yy) THEN
                  CALL p120_get_qtydate(tm.yy,tm.mm) RETURNING tm.qtydate
                  DISPLAY BY NAME tm.qtydate
               END IF
            END IF
 
 
         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               CLOSE WINDOW p120_w
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
               EXIT PROGRAM
            END IF
            IF tm.b1 MATCHES '[Nn]' AND tm.b3 MATCHES '[Nn]' AND tm.b2 MATCHES '[Nn]' THEN
                CALL cl_err('','axc-011',0)
                NEXT FIELD b1
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axcp120"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axcp120','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.wc CLIPPED ,"'",
                      " '",tm.bdate CLIPPED ,"'",
                      " '",tm.cmz70 CLIPPED ,"'",
                      " '",tm.qtydate CLIPPED ,"'", #FUN-930100
                      " '",tm.price1 CLIPPED ,"'",
                      " '",tm.price2 CLIPPED ,"'",
                      " '",tm.kind CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",tm.type CLIPPED,"'", #FUN-8B0047
                      " '",tm.yy   CLIPPED,"'", #FUN-8B0047
                      " '",tm.mm   CLIPPED,"'", #FUN-8B0047
                      " '",tm.cme06 CLIPPED,"'", #FUN-8B0047
                      " '",tm.choice CLIPPED,"'", #FUN-8B0047
                      " '",tm.cmz28 CLIPPED,"'",  #FUN-AB0036
                      " '",tm.choice2 CLIPPED,"'", #FUN-8B0047
                      " '",tm.s1 CLIPPED,"'", #FUN-8B0047
                      " '",tm.s2 CLIPPED,"'", #FUN-8B0047
                      " '",tm.s3 CLIPPED,"'",  #FUN-8B0047
                      " '",tm.choice3 CLIPPED,"'", #FUN-930100
                      " '",tm.ctype CLIPPED,"'"  #CHI-9C0025
         CALL cl_cmdat('axcp120',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p120_get_qtydate(l_yy,l_mm)
DEFINE l_yy   LIKE type_file.num5
DEFINE l_mm   LIKE type_file.num5
DEFINE l_qtydate  LIKE type_file.dat
 
  IF l_mm <=2 THEN 
     LET l_yy = l_yy - 1
     LET l_mm = l_mm - 2 + 12
  ELSE
     LET l_yy = l_yy
     LET l_mm = l_mm - 2
  END IF
  LET l_qtydate = MDY(l_mm,1,l_yy)
  RETURN l_qtydate
END FUNCTION
 
FUNCTION p120_get_cmz70(l_bdate)
DEFINE l_bdate  LIKE type_file.dat
DEFINE l_mm     LIKE type_file.num5
DEFINE l_yy     LIKE type_file.num5
DEFINE l_cmz70  LIKE type_file.dat
DEFINE l_cdate  LIKE type_file.chr8 
 
   LET l_mm=MONTH(l_bdate)    
   IF l_mm <= 6 THEN
      LET l_yy=YEAR(l_bdate) -2 
      LET l_mm=l_mm+6
      LET l_cdate =  l_yy USING "&&&&",l_mm USING "&&",'01'
      LET l_cmz70 = l_cdate
   ELSE
      LET l_yy=YEAR(l_bdate) -1 
      LET l_mm=l_mm-6
      LET l_cdate =  l_yy USING "&&&&",l_mm USING "&&",'01'
      LET l_cmz70 = l_cdate
   END IF
   RETURN l_cmz70
END FUNCTION
 
FUNCTION p120()
   DEFINE l_sql       STRING       #No.FUN-680122  #FUN-950058
   DEFINE l_name      LIKE type_file.chr20 #FUN-8B0047
 
   LET tm.no_tot = 0
   LET tm.no_ok = 0
   LET tm.p1 = ''
   DISPLAY tm.no_tot TO FORMONLY.no_tot
   DISPLAY tm.no_ok TO FORMONLY.no_ok
   DISPLAY tm.p1 TO FORMONLY.p1
   CALL ui.Interface.refresh()
   #依本國幣別取得小數位
   SELECT azi03,azi04,azi05
     INTO g_azi03,g_azi04,g_azi05
     FROM azi_file
    WHERE azi01 = g_aza.aza17
  #逆推成品的排序
   IF cl_null(tm.s1) THEN LET tm.s1 = ' ' END IF
   IF cl_null(tm.s2) THEN LET tm.s2 = ' ' END IF
   IF cl_null(tm.s3) THEN LET tm.s3 = ' ' END IF
   LET tm.s = tm.s1,tm.s2,tm.s3
   IF cl_null(tm.ctype) THEN LET tm.ctype='1' END IF  #CHI-9C0025
 
   #得知各區段之起迄日期
   CALL p120_get_date() 
   IF g_success = 'N' THEN RETURN END IF
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  LET g_len = 304
  CALL cl_outnam('axcp120') RETURNING l_name
  START REPORT p120_rep TO l_name
  LET g_pageno = 0
   #將欲處理之料號,新增至暫存檔中
   CALL p120_ins_tmp()
   #將料件先新增至LCM價格檔中
   CALL p120_ins_cma()
 
   IF tm.type<>'2' THEN #FUN-8B0047
     #讀取AR資料
     CALL p120_ar() 
     #讀取AP資料
     CALL p120_ap() 
     #更新取價類別資料
     CALL p120_up_cma05() 
     #計算ROLLUP價格
     CALL p120_rollup()
   END IF #FUN-8B0047
 
   CALL p150() #FUN-8B0047 淨變現
   FINISH REPORT p120_rep
   CALL cl_prt(l_name,g_prtway,g_copies,g_len) #TQC-980008
 
 
 
END FUNCTION
 
#得到各區段之起迄日期
FUNCTION p120_get_date()
   DEFINE l_correct     LIKE type_file.chr1           #No.FUN-680122CHAR(1)
   #基準日之年月
   LET g_yy = YEAR(tm.bdate)
   LET g_mm = MONTH(tm.bdate)
   #(1)得出區段 1 之起始日與截止日
   CALL s_azm(g_yy,g_mm) RETURNING l_correct, a_bdate, a_edate 
   IF l_correct != '0' THEN LET g_success = 'N' RETURN END IF
   #(2)得出區段 2 之起始日與截止日
   LET b_bdate = a_bdate + 1 UNITS MONTH
   #截止日 = 起始日之次月減 1
   LET b_edate = a_bdate + 2 UNITS MONTH
   LET b_edate = b_edate - 1
   #(3)得出區段 3 之起始日與截止日
   LET c_edate = a_bdate - 1 
   LET c_bdate = tm.cmz70
   LET g_qbdate = tm.qtydate
   LET g_qedate = MDY(tm.mm,1,tm.yy)  + 1 UNITS MONTH
   LET g_qedate = g_qedate - 1
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, g_agv_bdate, g_agv_edate
   IF tm.avgdate IS NOT NULL AND tm.avgdate <> 0 THEN
      LET g_agv_bdate = tm.avgdate
   END IF
END FUNCTION
 
FUNCTION p120_ins_tmp()
  DEFINE l_sql  STRING,       #No.FUN-680122CHAR(1200), #FUN-950058
         l_sql1 STRING       #No.FUN-680122CHAR(600)  #FUN-950058
  DEFINE l_ima01 LIKE ima_file.ima01 
   DEFINE l_b1    STRING
   DEFINE l_b2    STRING
   DEFINE l_b3    STRING

  LET l_sql = " INSERT INTO p120_file VALUES(?) " #CHI-C80002
  PREPARE p120_ins_sub_p1 FROM l_sql  #CHI-C80002
 
  LET tm.no_tot=0
  IF tm.kind='1' THEN
     LET l_sql = " SELECT ima01 ",
                 " FROM ima_file " 
               ," WHERE ",tm.wc CLIPPED,   #MOD-5A0226
                 " AND imaacti = 'Y' "     #MOD-C10167 add
  ELSE
     LET l_sql = " SELECT DISTINCT ima01 ",  #CHI-9C0025
                 " FROM ima_file,ccc_file ",
                 " WHERE ccc01=ima01 ",
                #"   AND ccc02= ",g_yy," ",   #MOD-CB0125 mark
                 "   AND ccc02= ",tm.yy," ",        #MOD-CB0125
                #"   AND ccc03= ",g_mm," ",   #MOD-CB0125 mark
                 "   AND ccc03= ",tm.mm," ",        #MOD-CB0125
                 "   AND ccc07= '",tm.ctype,"' ",  #CHI-970011  #CHI-9C0025
                 " AND (ccc91 <> (select ",g_nvl_str,
                #-------------No:MOD-BA0181 modify
                #" (sum(tlf10),0) from tlf_file,cmw_file where cmw01=tlf021 and tlf01=ccc01 )",  # 若ccc_file的庫存數量=呆滯倉的數量且大于0，則此料不納入LCM計算#FUN-970090#FUN-980101
                 " (sum(tlf10*tlf60*tlf907),0) from tlf_file,cmw_file where cmw01=tlf902 and tlf01=ccc01 ",
                 #"  AND tlf907 != 0 AND tlf902 NOT IN (SELECT jce02 FROM jce_file))",  # 若ccc_file的庫存數量=呆滯倉的數量且大于0，則此料不納入LCM計算#FUN-970090#FUN-980101 #CHI-C80002
                 "  AND tlf907 != 0 AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902))",  #CHI-C80002
                #-------------No:MOD-BA0181 end
                 " OR ccc91 = 0 ) ",    #CHI-970090
                 "   AND  ",tm.wc CLIPPED,
                 " AND imaacti = 'Y' "     #MOD-C10167 add
  END IF
     PREPARE p120_ima1 FROM l_sql
     DECLARE p120_ima CURSOR FOR p120_ima1
     FOREACH p120_ima INTO l_ima01
       IF SQLCA.SQLCODE <>0 THEN 
          LET g_success = 'N'             #No.FUN-8A0086  
          EXIT FOREACH 
       END IF
       IF l_ima01[1,4] = 'MISC' THEN CONTINUE FOREACH END IF  #No:MOD-9A0159 add
       LET tm.no_tot=tm.no_tot+1
       #INSERT INTO p120_file VALUES(l_ima01)  #CHI-C80002
       EXECUTE p120_ins_sub_p1 USING l_ima01   #CHI-C80002
       IF SQLCA.SQLCODE <> 0 THEN 
          LET g_success='N'
          CALL p120_error('cma01',l_ima01,'ins p102_file',SQLCA.sqlcode,1)            #CHI-970034
       END IF
     END FOREACH
   IF g_bgjob = 'N' THEN 
      DISPLAY BY NAME tm.no_tot
   END IF 
   #先刪除此次要計算之LCM料件價格資料
      LET l_sql = " DELETE FROM cma_file",
     #------------No:CHI-B80090 modify
     #    " WHERE cma01 IN (SELECT cma01 FROM p120_file) " ,
          #" WHERE cma01 IN (SELECT ima01 FROM ima_file WHERE ",tm.wc CLIPPED," AND imaacti = 'Y' ) " , #MOD-C10167 add AND imaacti = 'Y' #CHI-C80002
          " WHERE EXISTS(SELECT 1 FROM ima_file WHERE ",tm.wc CLIPPED," AND ima01 = cma01 AND imaacti = 'Y' ) ", #CHI-C80002
     #------------No:CHI-B80090
          "   AND cma021=",tm.yy, #FUN-8B0047
          "   AND cma022=",tm.mm, #FUN-8B0047
          "   AND cma07='",tm.ctype,"'"  #CHI-9C0025
      PREPARE del_cma FROM l_sql
      EXECUTE del_cma 
      LET l_sql = " DELETE FROM cmb_file",
     #------------No:CHI-B80090 modify
     #    " WHERE cmb01 IN (SELECT  cma01 FROM p120_file) " ,
          #" WHERE cmb01 IN (SELECT  ima01 FROM ima_file WHERE ",tm.wc CLIPPED," AND imaacti = 'Y' ) " , #MOD-C10167 add AND imaacti = 'Y'  #CHI-C80002
          " WHERE EXISTS(SELECT 1 FROM ima_file WHERE ",tm.wc CLIPPED," AND ima01 = cmb01 AND imaacti = 'Y' ) " ,  #CHI-C80002
     #------------No:CHI-B80090 modify
          "   AND cmb021=",tm.yy, #FUN-8B0047
          "   AND cmb022=",tm.mm  #FUN-8B0047
      PREPARE del_cmb FROM l_sql
      EXECUTE del_cmb 
     #---------------No:CHI-B80090 modify
     #DELETE FROM cmg_file WHERE cmg03 IN (SELECT cma01 FROM p120_file) 
     #                       AND cmg01=tm.yy AND cmg02=tm.mm  #FUN-950058
     #                       AND cmg071=tm.ctype
      LET l_sql = " DELETE FROM cmg_file",
          #" WHERE cmg03 IN (SELECT  ima01 FROM ima_file WHERE ",tm.wc CLIPPED," AND imaacti = 'Y' ) " , #MOD-C10167 add AND imaacti = 'Y' #CHI-C80002
          " WHERE EXISTS(SELECT 1 FROM ima_file WHERE ",tm.wc CLIPPED," AND ima01 = cmg03 AND imaacti = 'Y' ) " , #CHI-C80002
          "   AND cmg01=",tm.yy,
          "   AND cmg02=",tm.mm,
          "   AND cmg071='",tm.ctype,"'"
      PREPARE del_cmg FROM l_sql
      EXECUTE del_cmg
     #---------------No:CHI-B80090 end
   IF SQLCA.SQLCODE <> 0 THEN   
      LET g_success='N'
   END IF
   LET l_b1 = NULL
   LET l_b2 = NULL
   LET l_b3 = NULL
   LET g_sql2 = ''
   IF tm.b1 = 'Y' THEN
      LET l_b1 = " ((tlf02 = '50' AND  tlf13 IN ('asft6201','asrt320','asft6231')) OR ",
                 "  (tlf13 IN ('apmt150','asft6201','asft6231','apmt230','apmt102','apmt1072')))"   #MOD-A60101 add asft6231
   END IF
   IF tm.b2 = 'Y' THEN
      LET l_b2 = " (tlf13 IN ('aimt302','aimt312') OR (tlf03='50' AND tlf13='aimp880'))" 
   END IF
   IF tm.b3 = 'Y' THEN
      LET l_b3 = " (tlf13 IN ('asfi526','asfi527','asfi528','asfi529','asri220') OR ",
                 " (tlf02='65' AND tlf13='asft6201') OR tlf13='aomt800')" 
   END IF
   IF l_b1 IS NOT NULL THEN 
      LET g_sql2 = " OR ",l_b1
   END IF
   IF l_b2 IS NOT NULL THEN
      LET g_sql2 = g_sql2 ," OR ",l_b2
   END IF
   IF l_b3 IS NOT NULL THEN
      LET g_sql2 = g_sql2 ," OR ",l_b3
   END IF
   IF g_sql2.getlength() > 4 THEN
      #將第一個"OR"刪掉
      LET g_sql2 = g_sql2.substring(5,g_sql2.getlength())
      LET g_sql2 = " AND (",g_sql2 ,") "
   END IF
   
END FUNCTION
 
FUNCTION p120_ins_cma()
  DEFINE l_sql   STRING,      #No.FUN-680122 #FUN-950058
         l_sql1  STRING       #No.FUN-680122 #FUN-950058
  DEFINE l_ccc01 LIKE ccc_file.ccc01,
         l_ima08 LIKE ima_file.ima08,   #MOD-530637
         l_ima09 LIKE ima_file.ima09,
         l_ccc23 LIKE ccc_file.ccc23,
         l_imk09 LIKE imk_file.imk09,
         l_cma   RECORD LIKE cma_file.*
  DEFINE l_ccc08 LIKE ccc_file.ccc08    #CHI-9C0025
  DEFINE l_ima12    LIKE ima_file.ima12  #CHI-9C0025
  DEFINE l_azf06    LIKE azf_file.azf06  #CHI-9C0025
   
   LET l_sql = " SELECT ima01,ima09,ccc23,0,ima08,ccc08,ima12,azf06 ",   #MOD-530637  #CHI-9C0025
               " FROM ima_file LEFT OUTER JOIN ccc_file ON (ccc01=ima01 ",  #CHI-9C0025
              #"  AND ccc02= ",g_yy,   #CHI-9C0025  #MOD-CB0125 mark
               "  AND ccc02= ",tm.yy,  #MOD-CB0125
              #"  AND ccc03= ",g_mm,   #CHI-9C0025  #MOD-CB0125 mark
               "  AND ccc03= ",tm.mm,  #MOD-CB0125
               "  AND ccc07= '",tm.ctype,"') ",   #CHI-9C0025
               " LEFT OUTER JOIN azf_file ON (azf01=ima12 AND azf02='G') ",  #CHI-9C0025
               " ,p120_file ",
               " WHERE ima01=cma01 " 
   PREPARE p120_p1 FROM l_sql
   DECLARE p120_c1 CURSOR FOR p120_p1
 
 
   LET l_sql = " SELECT SUM(imk09*img21) ",
               " FROM imk_file,img_file ",
               " WHERE imk01=? ",
              #"   AND imk05= ",g_yy," ",   #MOD-CB0125 mark
              #"   AND imk06= ",g_mm," ",   #MOD-CB0125 mark
               "   AND imk05= ",tm.yy," ",  #MOD-CB0125
               "   AND imk06= ",tm.mm," ",  #MOD-CB0125
               "   AND imk01=img01 ",
               "   AND imk02=img02 ",
               "   AND imk03=img03 ",
               "   AND imk04=img04 ",
               #"   AND imk02 NOT IN (SELECT jce02 FROM jce_file) ", #CHI-C80002
               #"   AND imk02 NOT IN (SELECT cmw01 FROM cmw_file) "  #FUN-930100 #CHI-C80002
               "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = imk02) ",  #CHI-C80002
               "   AND NOT EXISTS(SELECT 1 FROM cmw_file WHERE cmw01 = imk02) "   #CHI-C80002
   PREPARE p120_pimk1 FROM l_sql #TQC-A10001
   DECLARE p120_imk1 CURSOR FOR p120_pimk1 #TQC-A10001

   CASE tm.ctype
      WHEN '3'
         LET l_sql = " SELECT SUM(imk09*img21) ",
                     " FROM imk_file,img_file ",
                     " WHERE imk01=? ",
                     "   AND imk04=? ",
                    #"   AND imk05= ",g_yy," ",   #MOD-CB0125 mark
                    #"   AND imk06= ",g_mm," ",   #MOD-CB0125 mark 
                     "   AND imk05= ",tm.yy," ",  #MOD-CB0125
                     "   AND imk06= ",tm.mm," ",  #MOD-CB0125
                     "   AND imk01=img01 ",
                     "   AND imk02=img02 ",
                     "   AND imk03=img03 ",
                     "   AND imk04=img04 ",
                     #"   AND imk02 NOT IN (SELECT jce02 FROM jce_file) ", #CHI-C80002
                     #"   AND imk02 NOT IN (SELECT cmw01 FROM cmw_file) "  #CHI-C80002
                     "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = imk02) ",  #CHI-C80002
                     "   AND NOT EXISTS(SELECT 1 FROM cmw_file WHERE cmw01 = imk02) "   #CHI-C80002
      WHEN '5'
         LET l_sql = " SELECT SUM(imk09*img21) ",
                     " FROM imk_file,img_file,imd_file ",
                     " WHERE imk01=? ",
                     "   AND imd09=? ",
                    #"   AND imk05= ",g_yy," ",   #MOD-CB0125 mark
                    #"   AND imk06= ",g_mm," ",   #MOD-CB0125 mark
                     "   AND imk05= ",tm.yy," ",  #MOD-CB0125
                     "   AND imk06= ",tm.mm," ",  #MOD-CB0125
                     "   AND imk01=img01 ",
                     "   AND imk02=img02 ",
                     "   AND imk03=img03 ",
                     "   AND imk04=img04 ",
                     "   AND imk02=imd01 ",
                     #"   AND imk02 NOT IN (SELECT jce02 FROM jce_file) ", #CHI-C80002
                     #"   AND imk02 NOT IN (SELECT cmw01 FROM cmw_file) "  #CHI-C80002
                     "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = imk02) ",  #CHI-C80002
                     "   AND NOT EXISTS(SELECT 1 FROM cmw_file WHERE cmw01 = imk02) "   #CHI-C80002
      OTHERWISE
        LET l_sql = l_sql
   END CASE
   PREPARE p120_pimk2 FROM l_sql
   DECLARE p120_imk2 CURSOR FOR p120_pimk2

   #得到該料件之最近異動日
   LET l_sql1 = "SELECT MAX(tlf06) ",
                " FROM tlf_file ",
                " WHERE tlf01 = ? ",
                " AND tlfcost = ? ",  #CHI-9C0025
                " AND tlf10 <>0 ",    #MOD-C70282 add
                " AND tlf06 <= '",tm.bdate,"' ",
                #" AND tlf902 NOT IN (SELECT jce02 FROM jce_file)", #CHI-C80002
                #" AND tlf902 NOT IN (SELECT cmw01 FROM cmw_file)" #FUN-980077 #CHI-C80002
                " AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902) ",  #CHI-C80002
                " AND NOT EXISTS(SELECT 1 FROM cmw_file WHERE cmw01 = tlf902) "   #CHI-C80002
   LET l_sql1 = l_sql1 ,g_sql2 #FUN-980077
   PREPARE p120_tlf FROM l_sql1
   DECLARE p120_ctlf CURSOR FOR p120_tlf

   INITIALIZE l_ccc01,l_ima09,l_ccc23,l_imk09,l_ima08,l_ccc08,l_ima12,l_azf06 TO NULL         #MOD-C30735 add
 
   FOREACH p120_c1 INTO l_ccc01,l_ima09,l_ccc23,l_imk09,l_ima08,l_ccc08,l_ima12,l_azf06  #CHI-9C0025
     IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
     CALL p120_ins_cma_1(l_ccc01,l_ima09,l_ccc23,l_imk09,l_ima08,l_ccc08,l_ima12,l_azf06) #FUN-980101 add  #CHI-9C0025
   END FOREACH 

END FUNCTION

FUNCTION p120_ins_cma_1(l_ccc01,l_ima09,l_ccc23,l_imk09,l_ima08,l_ccc08,l_ima12,l_azf06) #CHI-9C0025
DEFINE l_ccc01    LIKE ccc_file.ccc01
DEFINE l_ima09    LIKE ima_file.ima09
DEFINE l_ccc23    LIKE ccc_file.ccc23
DEFINE l_imk09    LIKE imk_file.imk09
DEFINE l_ima08    LIKE ima_file.ima08
DEFINE l_cma      RECORD LIKE cma_file.*
DEFINE l_ima12    LIKE ima_file.ima12
DEFINE l_azf06    LIKE azf_file.azf06
DEFINE l_ccc_flag LIKE type_file.num5 #CHI-9C0025
DEFINE l_ccc08    LIKE ccc_file.ccc08  #CHI-9C0025

     IF cl_null(l_ccc23) THEN LET l_ccc23=0 END IF
     IF cl_null(l_imk09) THEN LET l_imk09=0 END IF
     IF g_bgjob = 'N' THEN 
        DISPLAY l_ccc01 TO FORMONLY.p2 #FUN-8B0047
        DISPLAY l_ima09 TO FORMONLY.p1 #FUN-8B0047
     END IF 
     LET l_cma.cma01 = l_ccc01
     LET l_cma.cma02 = tm.bdate

    #IF l_ima08 MATCHES '[PV]' THEN  #CHI-C50013 mark
     IF l_azf06 = '3' THEN           #CHI-C50013 
        LET l_cma.cma03 = '0'
     ELSE
        LET l_cma.cma03 = '2'
     END IF
 
     LET l_cma.cma05='C'
     LET l_cma.cma11 =0
     LET l_cma.cma12 =0
     LET l_cma.cma13 =0
     #得出不含04/05及JIT倉之庫存量
     CASE tm.ctype
       WHEN '3'
          OPEN p120_imk2 USING l_cma.cma01,l_ccc08  
          FETCH p120_imk2 INTO l_imk09
          IF SQLCA.SQLCODE <>0 OR l_imk09 IS NULL THEN
             LET l_imk09=0
          END IF
       WHEN '5'
          OPEN p120_imk2 USING l_cma.cma01,l_ccc08
          FETCH p120_imk2 INTO l_imk09
          IF SQLCA.SQLCODE <>0 OR l_imk09 IS NULL THEN
             LET l_imk09=0
          END IF
       OTHERWISE
          OPEN p120_imk1 USING l_cma.cma01
          FETCH p120_imk1 INTO l_imk09
          IF SQLCA.SQLCODE <>0 OR l_imk09 IS NULL THEN
             LET l_imk09=0
          END IF
     END CASE
     LET l_cma.cma15 = l_imk09
     LET l_cma.cmauser = g_user
     LET l_cma.cmagrup = g_grup
     LET l_cma.cmamodu = null
     LET l_cma.cmadate = g_today
     LET l_cma.cmaorig = g_plant #CHI-9C0025
     LET l_cma.cmaoriu = g_user  #CHI-9C0025
 
     LET l_cma.cma021  = tm.yy 
     LET l_cma.cma022  = tm.mm 
     IF l_azf06 MATCHES '[01]' THEN LET l_cma.cma24='1' END IF
     IF l_azf06 MATCHES '[2]' THEN LET l_cma.cma24='2' END IF
     IF l_azf06 MATCHES '[3]' THEN LET l_cma.cma24='3' END IF
     LET l_cma.cma25   = 0
     LET l_cma.cma26   = 0
     LET l_cma.cma30   = tm.s
     LET l_cma.cma31   = tm.cme06
     LET l_cma.cma32   = 0
 
      CALL FGL_SETENV("DBDATE","Y4MD/")
      IF l_cma.cma271 = '1899/12/31' THEN 
         LET l_cma.cma271 = NULL 
      END IF   
      CALL FGL_SETENV("DBDATE",g_date)

     IF l_ccc23 IS NULL THEN
        LET l_ccc23=0
     END IF
     #判斷材料分類
     IF l_ccc23 >= g_cmz.cmz03 THEN
        LET l_cma.cma04='A'
     ELSE  
        IF l_ccc23 < g_cmz.cmz03 AND l_ccc23 >= g_cmz.cmz04 THEN
           LET l_cma.cma04='B'
        ELSE
           LET l_cma.cma04='C'
        END IF
     END IF
     LET l_cma.cma14 =l_ccc23
     LET l_cma.cma07 = tm.ctype
     IF l_ccc08 IS NULL THEN
        LET l_ccc08=' '
     END IF
     LET l_cma.cma08 = l_ccc08
     #得出最近異動日
     OPEN p120_ctlf USING l_cma.cma01,l_cma.cma08  #CHI-9C0025
     FETCH p120_ctlf INTO l_cma.cma16
     IF SQLCA.SQLCODE <>0 OR l_cma.cma16 IS NULL THEN
        SELECT max(cao02) INTO l_cma.cma16 FROM cao_file  #CHI-970066
         WHERE cao01 = l_cma.cma01                        #CHI-970066
           AND cao07 = tm.ctype                           #CHI-9C0025
           AND cao08 = l_cma.cma08                        #CHI-9C0025
        IF cl_null(l_cma.cma16) THEN                      #CHI-970066
           LET l_cma.cma16 = tm.cmz70
        END IF                                            #CHI-970066
     END IF
     LET l_cma.cmalegal = g_legal    #FUN-A50075
     INSERT INTO cma_file VALUES(l_cma.*)
     IF (SQLCA.SQLCODE <>0) THEN
         CALL p120_error('cma01',l_cma.cma01,'ins cma:',SQLCA.sqlcode,1) #CHI-970034
        LET g_success='N'
     END IF

END FUNCTION
 
#讀取應收帳款資料
FUNCTION p120_ar()
  DEFINE l_sql     STRING,         #No.FUN-680122 #FUN-950058
         l_flag    LIKE type_file.chr1,            #No.FUN-680122 
         l_cmb02   LIKE cmb_file.cmb02
  DEFINE trn_part  LIKE ccc_file.ccc01,  #異動料號
         trn_date  LIKE cmb_file.cmb05,  #異動日期 #No.FUN-680122 DATE,
         trn_price LIKE ccc_file.ccc23,  #異動價格
         trn_cmb03 LIKE cmb_file.cmb03,  #取價
         old_part  LIKE ccc_file.ccc01,  #異動料號
         old_date  LIKE cmb_file.cmb05,  #異動日期 #No.FUN-680122 DATE,
         old_price LIKE ccc_file.ccc23,  #異動價格
         old_cmb03 LIKE cmb_file.cmb03,  #取價
         s_date    LIKE cmb_file.cmb05,            #No.FUN-680122 DATE,
         e_date    LIKE cmb_file.cmb05,            #No.FUN-680122 DATE
         l_cma     RECORD LIKE cma_file.*,
         l_cmb     RECORD LIKE cmb_file.*,
         l_omb31   LIKE omb_file.omb31,
         l_omb32   LIKE omb_file.omb32,
         l_ogb916  LIKE ogb_file.ogb916,
         l_ima25   LIKE ima_file.ima25,
         l_cnt     LIKE type_file.num5,
         l_ogb05_fac LIKE ogb_file.ogb05_fac
   
  #LET l_sql = " SELECT omb04,oma02,omb15,omb31,omb32 ",  #CHI-920005 add omb31,omb32   #MOD-D20049 mark
   LET l_sql = " SELECT omb04,oma02,",  #MOD-D20049
               " CASE oma213 WHEN 'Y' THEN (omb16/omb12) ELSE omb15 END AS amt,",  #MOD-D20049
               " omb31,omb32 ",  #MOD-D20049
               " FROM oma_file,omb_file,p120_file ",
               " WHERE oma01=omb01 ",
               "  AND omb04 = cma01 ",
               "  AND oma00='12' ",
               "  AND oma02 BETWEEN '",c_bdate,"' AND '",b_edate,"' ",
               "  AND omavoid = 'N' ",          #MOD-B30684 add
               "  ORDER BY 1,2,3 " 
   PREPARE p120_p2 FROM l_sql
   DECLARE p120_c2 CURSOR FOR p120_p2
   LET old_part='@@@@'
   LET l_cmb02=1
   LET l_flag = 'N'
   FOREACH p120_c2 INTO trn_part,trn_date,trn_price,l_omb31,l_omb32   #CHI-920005
     IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
     SELECT ogb916 INTO l_ogb916 FROM ogb_file WHERE ogb01 = l_omb31 AND ogb03 = l_omb32
     SELECT ima25 INTO l_ima25 FROM im a_file WHERE ima01 = trn_part
     CALL s_umfchk(trn_part,l_ogb916,l_ima25) RETURNING l_cnt,l_ogb05_fac
     IF l_cnt = 1 THEN
        LET g_showmsg= l_omb31,"/", l_omb32
        CALL p120_error('ogb01,ogb03',g_showmsg,'unit trans:','abm-731',1)  #CHI-970034
        LET l_ogb05_fac = 1 #TQC-940146
     END IF
     LET trn_price = trn_price / l_ogb05_fac  #TQC-940146
     IF cl_null(trn_price) THEN LET trn_price=0 END IF
     LET l_flag = 'Y'
     LET tm.p1 ='AR'
     LET tm.p2 = trn_part
     IF g_bgjob = 'N' THEN 
        DISPLAY BY NAME tm.p1,tm.p2
     END IF 
     #判斷異動區段
     IF trn_date >= a_bdate AND trn_date <= a_edate THEN
         LET trn_cmb03='1A'
     ELSE
         IF trn_date >= b_bdate AND trn_date <= b_edate THEN
            LET trn_cmb03='1B'
         ELSE
            LET trn_cmb03='1C'
         END IF
     END IF
     IF old_part='@@@@'  THEN   #第一次進來給初值
        LET old_part = trn_part
        LET old_date = trn_date
        LET old_cmb03 = trn_cmb03
        LET old_price = trn_price
        LET s_date = trn_date
        LET e_date = trn_date
     END IF
     #料號或取價區段或價格不同時
     IF trn_part <> old_part OR trn_cmb03 <> old_cmb03 OR 
        trn_price <> old_price THEN
        LET l_cmb.cmb01 = old_part
        LET l_cmb.cmb02 = l_cmb02
        LET l_cmb.cmb03 = old_cmb03
        LET l_cmb.cmb04 = s_date
        LET l_cmb.cmb05 = e_date
        LET l_cmb.cmb06 = old_price
        LET l_cmb.cmb021=tm.yy   #FUN-8B0047
        LET l_cmb.cmb022=tm.mm   #FUN-8B0047
        LET l_cmb.cmblegal = g_legal    #FUN-A50075
        INSERT INTO cmb_file VALUES(l_cmb.*)
        IF SQLCA.SQLCODE <> 0 THEN
           LET g_success='N'
           LET g_showmsg=l_cmb.cmb01,"/",l_cmb.cmb02
           CALL p120_error('cmb01,cmb02',g_showmsg,'ins cmb:',SQLCA.sqlcode,1) #CHI-970034
        END IF
        LET l_cmb02 = l_cmb02+1
        #若料號不同時,項次重計
        IF trn_part <> old_part THEN
           LET l_cmb02=1
        END IF
        #給舊值
        LET old_part = trn_part
        LET old_date = trn_date
        LET old_cmb03 = trn_cmb03
        LET old_price = trn_price
        LET s_date = trn_date
        LET e_date = trn_date
     END IF
     LET e_date =trn_date
   END FOREACH 
   #將最後一筆資料存入
   IF l_flag='Y' THEN
        LET l_cmb.cmb01 = trn_part
        LET l_cmb.cmb02 = l_cmb02
        LET l_cmb.cmb03 = trn_cmb03
        LET l_cmb.cmb04 = s_date
        LET l_cmb.cmb05 = trn_date
        LET l_cmb.cmb06 = trn_price
        LET l_cmb.cmb021=tm.yy   #FUN-8B0047
        LET l_cmb.cmb022=tm.mm   #FUN-8B0047
        LET l_cmb.cmblegal = g_legal   #FUN-A50075
        INSERT INTO cmb_file VALUES(l_cmb.*)
        IF SQLCA.SQLCODE <> 0 THEN
           LET g_success='N'
            LET g_showmsg=l_cmb.cmb01,"/",l_cmb.cmb02                                                                        
            CALL p120_error('cmb01,cmb02',g_showmsg,'ins cmb:',SQLCA.sqlcode,1) #CHI-970034                                                
        END IF
   END IF
END FUNCTION
 
#讀取應付帳款資料
FUNCTION p120_ap()
  DEFINE l_sql STRING,          #No.FUN-680122CHAR(1200),  #FUN-950058
         l_flag LIKE type_file.chr1,            #No.FUN-680122 
         l_cmb02 LIKE cmb_file.cmb02
  DEFINE trn_part LIKE ccc_file.ccc01,   #異動料號
         trn_date  LIKE cmb_file.cmb05,         #No.FUN-680122DATE,                 #異動日期
         trn_price LIKE ccc_file.ccc23,  #異動價格
         trn_cmb03 LIKE cmb_file.cmb03,  #取價
         old_part LIKE ccc_file.ccc01,   #異動料號
         old_date  LIKE cmb_file.cmb05,         #No.FUN-680122DATE,                 #異動日期
         old_price LIKE ccc_file.ccc23,  #異動價格
         old_cmb03 LIKE cmb_file.cmb03,  #取價
         s_date    LIKE cmb_file.cmb05,         #No.FUN-680122DATE,
         e_date    LIKE cmb_file.cmb05,         #No.FUN-680122 DATE
         l_cma   RECORD LIKE cma_file.*,
         l_cmb   RECORD LIKE cmb_file.*,
         l_apb06   LIKE apb_file.apb06,
         l_apb07   LIKE apb_file.apb07,
         l_pmn86   LIKE pmn_file.pmn86,
         l_rvb81   LIKE rvb_file.rvb81,
         l_ima25   LIKE ima_file.ima25,
         l_cnt     LIKE type_file.num5
   
   #讀取內購+外購之資料
   LET l_sql = " SELECT apb12,apa02,apb08,apb06,apb07 ", #CHI-920005 add apb06,apb07
               " FROM apa_file,apb_file,p120_file ",
               " WHERE apa00='11'  ",
               "  AND apa01=apb01   ",
               "  AND apb12=cma01 ",
               "  AND apb29='1' ",  #MOD-D10183
               "  AND apa42 = 'N' ",
               "  AND apa02 BETWEEN '",c_bdate,"' AND '",b_edate,"' ",
               "  UNION ",
               "   SELECT ale11,alk02,ale08,ale14,ale15 ",#CHI-920005 add ale04,ale05
               "   FROM ale_file,alk_file,p120_file ",
               "  WHERE ale01=alk01 ",
               "    AND ale11=cma01 ",
               "    AND alk02 BETWEEN '",c_bdate,"' AND '",b_edate,"' ",
               "    AND alkfirm <> 'X' ", #CHI-C80041
               "  ORDER BY 1,2,3 " 
   PREPARE p120_p3 FROM l_sql
   DECLARE p120_c3 CURSOR FOR p120_p3
   LET old_part='@@@@'
   LET l_cmb02=1
   LET l_flag = 'N'
   FOREACH p120_c3 INTO trn_part,trn_date,trn_price,l_apb06,l_apb07 #CHI-920005
     IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
     SELECT pmn86 INTO l_pmn86 FROM pmn_file WHERE pmn01=l_apb06 AND pmn02=l_apb07
     SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=trn_part 
     CALL s_umfchk(trn_part,l_pmn86,l_ima25) RETURNING l_cnt,l_rvb81
     IF l_cnt = 1 THEN
        LET g_showmsg= l_apb06,"/", l_apb07
        CALL p120_error('pmn01,pmn02',g_showmsg,'unit trans:','abm-731',1) #CHI-970034
        LET l_rvb81 = 1       #TQC-940146
     END IF
     LET trn_price = trn_price / l_rvb81   #TQC-940146 
     IF cl_null(trn_price) THEN LET trn_price=0 END IF
     LET l_flag = 'Y'
     LET tm.p1 ='AP'
     LET tm.p2 = trn_part
     IF g_bgjob = 'N' THEN   #NO.FUN-570153 
         DISPLAY BY NAME tm.p1,tm.p2
     END IF
     #判斷異動區段
     IF trn_date >= a_bdate AND trn_date <= a_edate THEN
         LET trn_cmb03='2A'
     ELSE
         IF trn_date >= b_bdate AND trn_date <= b_edate THEN
            LET trn_cmb03='2B'
         ELSE
            LET trn_cmb03='2C'
         END IF
     END IF
     IF old_part='@@@@'  THEN   #第一次進來給初值
        LET old_part = trn_part
        LET old_date = trn_date
        LET old_cmb03 = trn_cmb03
        LET old_price = trn_price
        LET s_date = trn_date
        LET e_date = trn_date
        #讀取該料之最大項次
        SELECT MAX(cmb02)+1 INTO l_cmb02
          FROM cmb_file
          WHERE cmb01 = trn_part
            AND cmb021=tm.yy #FUN-8B0047
            AND cmb022=tm.mm #FUN-8B0047
        IF SQLCA.SQLCODE <> 0 OR l_cmb02 IS NULL THEN
           LET l_cmb02=1
        END IF
     END IF
     #料號或取價區段或價格不同時
     IF trn_part <> old_part OR trn_cmb03 <> old_cmb03 OR 
        trn_price <> old_price THEN
        LET l_cmb.cmb01 = old_part
        LET l_cmb.cmb02 = l_cmb02
        LET l_cmb.cmb03 = old_cmb03
        LET l_cmb.cmb04 = s_date
        LET l_cmb.cmb05 = e_date
        LET l_cmb.cmb06 = old_price
        LET l_cmb.cmb021=tm.yy   #FUN-8B0047
        LET l_cmb.cmb022=tm.mm   #FUN-8B0047
        LET l_cmb.cmblegal = g_legal    #FUN-A50075
        INSERT INTO cmb_file VALUES(l_cmb.*)
        IF SQLCA.SQLCODE <> 0 THEN
           LET g_success='N'
            LET g_showmsg=l_cmb.cmb01,"/",l_cmb.cmb02                                                                        
            CALL p120_error('cmb01,cmb02',g_showmsg,'ins cmb:',SQLCA.sqlcode,1)  #CHI-970034                                              
        END IF
        LET l_cmb02 = l_cmb02+1
        #若料號不同時,項次重計
        IF trn_part <> old_part THEN
           #讀取該料之最大項次
           SELECT MAX(cmb02)+1 INTO l_cmb02
             FROM cmb_file
             WHERE cmb01 = trn_part
               AND cmb021=tm.yy #FUN-8B0047
               AND cmb022=tm.mm #FUN-8B0047
           IF SQLCA.SQLCODE <> 0 OR l_cmb02 IS NULL THEN
              LET l_cmb02=1
           END IF
        END IF
        #給舊值
        LET old_part = trn_part
        LET old_date = trn_date
        LET old_cmb03 = trn_cmb03
        LET old_price = trn_price
        LET s_date = trn_date
        LET e_date = trn_date
     END IF
     LET e_date =trn_date
   END FOREACH 
   #將最後一筆資料存入
   IF l_flag='Y' THEN
        LET l_cmb.cmb01 = trn_part
        LET l_cmb.cmb02 = l_cmb02
        LET l_cmb.cmb03 = trn_cmb03
        LET l_cmb.cmb04 = s_date
        LET l_cmb.cmb05 = trn_date
        LET l_cmb.cmb06 = trn_price
        LET l_cmb.cmb021=tm.yy   #FUN-8B0047
        LET l_cmb.cmb022=tm.mm   #FUN-8B0047
        LET l_cmb.cmblegal = g_legal   #FUN-A50075
        INSERT INTO cmb_file VALUES(l_cmb.*)
        IF SQLCA.SQLCODE <> 0 THEN
           LET g_success='N'
           LET g_showmsg=l_cmb.cmb01,"/",l_cmb.cmb02                                                                        
           CALL p120_error('cmb01,cmb02',g_showmsg,'ins cmb:',SQLCA.sqlcode,1) #CHI-970034                                           
        END IF
   END IF
END FUNCTION
 
FUNCTION p120_up_cma05()
  DEFINE  #l_cma RECORD LIKE cma_file.*,  #CHI-9C0025 mark
         l_cnt LIKE type_file.num5,          #No.FUN-680122 
         old_cmb03  LIKE cmb_file.cmb03,
         old_cmb06  LIKE cmb_file.cmb06 ,
         l_cma05  LIKE cma_file.cma05,
         l_cmb03  LIKE cmb_file.cmb03,
         l_cmb04  LIKE cmb_file.cmb04,
         l_cmb06  LIKE cmb_file.cmb06 ,
         l_sw     LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
         l_flag   LIKE type_file.chr1,          #No.FUN-680122 
         l_sql    STRING       #No.FUN-680122CHAR(600)  #FUN-950058
  DEFINE l_cma01  LIKE cma_file.cma01  #CHI-9C0025
  DEFINE l_cma03  LIKE cma_file.cma03  #CHI-9C0025

  #CHI-C80002---begin
  LET l_sql = " SELECT cmb03,cmb06,cmb04 ",
              " FROM cmb_file ",
              " WHERE cmb01=? ",
              " AND cmb06 <> 0 ",
              " AND cmb03 <> '1B' ",
              " AND cmb03 MATCHES '1*' ",
              " AND cmb021= ",tm.yy,
              " AND cmb022= ",tm.mm,
              " ORDER BY cmb03,cmb04 DESC "
  PREPARE p120_up2_p1 FROM l_sql          
  DECLARE p120_up2 CURSOR FOR p120_up2_p1   

  LET l_sql = " SELECT cmb03,cmb06,cmb04 ",
              "  FROM cmb_file ",
              " WHERE cmb01=? ",
              "    AND cmb06 <> 0 ",
              "    AND cmb03 = '1B' ",
              "    AND cmb021= ",tm.yy, 
              "    AND cmb022= ",tm.mm,
              "    ORDER BY cmb03,cmb04 "
  PREPARE p120_up3_p1 FROM l_sql 
  DECLARE p120_up3 CURSOR FOR p120_up3_p1 
       
  LET l_sql = " SELECT cmb03,cmb06,cmb04 ",
              " FROM cmb_file ",
              " WHERE cmb01=? ",
              " AND cmb06 <> 0 ", 
              " AND cmb03 <> '2B' ",
              " AND cmb03 MATCHES '2*' ",
              " AND cmb021= ",tm.yy, 
              " AND cmb022= ",tm.mm,
              " ORDER BY cmb03,cmb04 DESC "
  PREPARE ap_up2_p1 FROM l_sql          
  DECLARE ap_up2 CURSOR FOR ap_up2_p1 

  LET l_sql = " SELECT cmb03,cmb06,cmb04 ",
              "   FROM cmb_file ",
              "   WHERE cmb01=? ",
              "     AND cmb06 <> 0 ",
              "     AND cmb03 = '2B' ",
              "     AND cmb021= ",tm.yy,
              "     AND cmb022= ",tm.mm,
              "     ORDER BY cmb03,cmb04 "
  PREPARE ap_up3_p1 FROM l_sql 
  DECLARE ap_up3 CURSOR FOR ap_up3_p1 

  LET l_sql = " UPDATE cma_file ",
              " SET cma05='S', ",
              "     cma12=? ",
              " WHERE cma01=? ",
              " AND cma021= ",tm.yy,
              " AND cma022= ",tm.mm
  PREPARE cma_upd_p1 FROM l_sql 

  LET l_sql = " UPDATE cma_file ",
              "    SET cma05='I', ",
              "        cma11=? ",
              "  WHERE cma01=? ",
              "    AND cma021= ",tm.yy,
              "    AND cma022= ",tm.mm
  PREPARE cma_upd_p2 FROM l_sql            

  LET l_sql = " UPDATE cma_file ",
              "    SET cma11=? ",
              "  WHERE cma01=? ",
              "    AND cma021= ",tm.yy,
              "    AND cma022= ",tm.mm
  PREPARE cma_upd_p3 FROM l_sql
  #CHI-C80002---end
 
  LET l_cnt=0
  DECLARE p120_up1 CURSOR FOR
    SELECT DISTINCT b.cma01,b.cma03  #CHI-9C0025
      FROM p120_file a,cma_file b
     WHERE a.cma01=b.cma01
  FOREACH p120_up1 INTO l_cma01,l_cma03 #CHI-9C0025
     IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
     LET l_cnt=l_cnt+1
     LET tm.no_ok=l_cnt
     #先更新AR
     LET tm.p1 ='UP'
     LET tm.p2 = l_cma01 #CHI-9C0025
     IF g_bgjob = 'N' THEN  #NO.FUN-570153 
         DISPLAY BY NAME tm.no_ok,tm.p1,tm.p2
     END IF
     LET l_sw='N'
     #CHI-C80002---begin mark
     #DECLARE p120_up2 CURSOR FOR
     #   SELECT cmb03,cmb06,cmb04
     #     FROM cmb_file
     #     WHERE cmb01=l_cma01   #CHI-9C0025
     #       AND cmb06 <> 0 
     #       AND cmb03 <> '1B'
     #       AND cmb03 MATCHES '1*'
     #       AND cmb021=tm.yy #FUN-8B0047
     #       AND cmb022=tm.mm #FUN-8B0047
     #       ORDER BY cmb03,cmb04 DESC
     #FOREACH p120_up2 INTO l_cmb03,l_cmb06,l_cmb04
     #CHI-C80002---end
     FOREACH p120_up2 USING l_cma01 INTO l_cmb03,l_cmb06,l_cmb04  #CHI-C80002
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
        LET l_sw='Y'
        IF l_cmb03='1A' THEN
           #CHI-C80002---begin mark
           #UPDATE cma_file
           #   SET cma05='S',   #取價類別
           #       cma12=l_cmb06    #異動單價
           #  WHERE cma01=l_cma01      #CHI-9C0025
           #    AND cma021=tm.yy #FUN-8B0047
           #    AND cma022=tm.mm #FUN-8B0047
           #CHI-C80002---end  
           EXECUTE cma_upd_p1 USING l_cmb06,l_cma01 #CHI-C80002
           IF SQLCA.SQLCODE <>0 THEN
              LET g_success='N'
              CALL p120_error('cam01',l_cma01,'upd cma',SQLCA.sqlcode,1)            #CHI-970034 #CHI-9C0025
           END IF
           EXIT FOREACH
        ELSE
           LET old_cmb03=l_cmb03
           LET old_cmb06=l_cmb06
           LET l_flag = 'N'
           #若為1C則判斷1B
           #CHI-C80002---begin mark
           #DECLARE p120_up3 CURSOR FOR
           #   SELECT cmb03,cmb06,cmb04
           #     FROM cmb_file
           #     WHERE cmb01=l_cma01  #CHI-9C0025
           #       AND cmb06 <> 0 
           #       AND cmb03 = '1B'
           #       AND cmb021=tm.yy #FUN-8B0047   #No.MOD-930041
           #       AND cmb022=tm.mm #FUN-8B0047   #No.MOD-930041
           #       ORDER BY cmb03,cmb04 
           #FOREACH p120_up3 INTO l_cmb03,l_cmb06,l_cmb04
           #CHI-C80002---end
           FOREACH p120_up3 USING l_cma01 INTO l_cmb03,l_cmb06,l_cmb04 #CHI-C80002
              IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
              LET l_flag='Y'
              #CHI-C80002---begin mark
              #UPDATE cma_file
              #   SET cma05='S',   #取價類別
              #       cma12=l_cmb06    #異動單價
              #  WHERE cma01=l_cma01      #CHI-9C0025
              #    AND cma021=tm.yy #FUN-8B0047
              #    AND cma022=tm.mm #FUN-8B0047
              #CHI-C80002---end
              EXECUTE cma_upd_p1 USING l_cmb06,l_cma01 #CHI-C80002
              IF SQLCA.SQLCODE <>0 THEN
                 LET g_success='N'
                 CALL p120_error('cma01',l_cma01,'upd cma',SQLCA.sqlcode,1)                               #CHI-970034 #CHI-9C0025
              END IF
              EXIT FOREACH
           END FOREACH
           IF l_flag='N' THEN
               #CHI-C80002---begin mark
               #UPDATE cma_file
               #   SET cma05='S',   #取價類別
               #       cma12=old_cmb06    #異動單價
               #  WHERE cma01=l_cma01      #CHI-9C0025
               #    AND cma021=tm.yy #FUN-8B0047
               #    AND cma022=tm.mm #FUN-8B0047
               #CHI-C80002---end
               EXECUTE cma_upd_p1 USING old_cmb06,l_cma01 #CHI-C80002 
               IF SQLCA.SQLCODE <>0 THEN
                  LET g_success='N'
                  CALL p120_error('cma01',l_cma01,'upd cma',SQLCA.sqlcode,1)                               #CHI-970034 #CHI-9C0025
               END IF
           END IF
           EXIT FOREACH
        END IF
     END FOREACH
     IF l_sw='N' THEN
           #判斷1B
           #CHI-C80002---begin mark
           #DECLARE p120_up4 CURSOR FOR
           #   SELECT cmb03,cmb06,cmb04
           #     FROM cmb_file
           #     WHERE cmb01=l_cma01  #CHI-9C0025
           #       AND cmb06 <> 0 
           #       AND cmb03 = '1B'
           #       AND cmb021=tm.yy #FUN-8B0047
           #       AND cmb022=tm.mm #FUN-8B0047
           #       ORDER BY cmb03,cmb04 
           #FOREACH p120_up4 INTO l_cmb03,l_cmb06,l_cmb04
           #CHI-C80002---end
           FOREACH p120_up3 USING l_cma01 INTO l_cmb03,l_cmb06,l_cmb04 #CHI-C80002
              IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
              LET l_flag='Y'
              #CHI-C80002---begin mark
              #UPDATE cma_file
              #   SET cma05='S',   #取價類別
              #       cma12=l_cmb06    #異動單價
              #  WHERE cma01=l_cma01      #CHI-9C0025
              #    AND cma021=tm.yy #FUN-8B0047
              #    AND cma022=tm.mm #FUN-8B0047
              #CHI-C80002---end
              EXECUTE cma_upd_p1 USING l_cmb06,l_cma01 #CHI-C80002
              IF SQLCA.SQLCODE <>0 THEN
                 LET g_success='N'
                 CALL p120_error('cma01',l_cma01,'upd cma',SQLCA.sqlcode,1)                               #CHI-970034 #CHI-9C0025
              END IF
              EXIT FOREACH
           END FOREACH
     END IF
     #更新AP
     LET l_sw='N'
     #CHI-C80002---begin
     #DECLARE ap_up2 CURSOR FOR
     #   SELECT cmb03,cmb06,cmb04
     #     FROM cmb_file
     #     WHERE cmb01=l_cma01  #CHI-9C0025
     #       AND cmb06 <> 0 
     #       AND cmb03 <> '2B'
     #       AND cmb03 MATCHES '2*'
     #       AND cmb021=tm.yy #FUN-8B0047
     #       AND cmb022=tm.mm #FUN-8B0047
     #       ORDER BY cmb03,cmb04 DESC
     #FOREACH ap_up2 INTO l_cmb03,l_cmb06,l_cmb04
     #CHI-C80002---end
     FOREACH ap_up2 USING l_cma01 INTO l_cmb03,l_cmb06,l_cmb04 #CHI-C80002
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
        LET l_sw='Y'
        IF l_cmb03='2A' THEN
           IF l_cma03='0' THEN    #原料時才要更新取價類別  #CHI-9C0025
              #CHI-C80002---begin mark
              #UPDATE cma_file
              #   SET cma05='I',   #取價類別
              #       cma11=l_cmb06    #異動單價
              #  WHERE cma01=l_cma01      #CHI-9C0025
              #    AND cma021=tm.yy #FUN-8B0047
              #    AND cma022=tm.mm #FUN-8B0047
              #CHI-C80002---end
              EXECUTE cma_upd_p2 USING l_cmb06,l_cma01 #CHI-C80002
           ELSE
              #CHI-C80002---begin mark
              #UPDATE cma_file
              #   SET cma11=l_cmb06    #異動單價
              #  WHERE cma01=l_cma01      #CHI-9C0025
              #    AND cma021=tm.yy #FUN-8B0047
              #    AND cma022=tm.mm #FUN-8B0047
              #CHI-C80002---end
              EXECUTE cma_upd_p3 USING l_cmb06,l_cma01 #CHI-C80002
           END IF
           IF SQLCA.SQLCODE <>0 THEN
              LET g_success='N'
               CALL p120_error('cma01',l_cma01,'upd cma',SQLCA.sqlcode,1)                               #CHI-970034 #CHI-9C0025
           END IF
           EXIT FOREACH
        ELSE
           LET old_cmb03=l_cmb03
           LET old_cmb06=l_cmb06
           LET l_flag = 'N'
           #若為2C則判斷2B
           #CHI-C80002---begin mark
           #DECLARE ap_up3 CURSOR FOR
           #   SELECT cmb03,cmb06,cmb04
           #     FROM cmb_file
           #     WHERE cmb01=l_cma01  #CHI-9C0025
           #       AND cmb06 <> 0 
           #       AND cmb03 = '2B'
           #       AND cmb021=tm.yy #FUN-8B0047
           #       AND cmb022=tm.mm #FUN-8B0047
           #       ORDER BY cmb03,cmb04 
           #FOREACH ap_up3 INTO l_cmb03,l_cmb06,l_cmb04
           #CHI-C80002---end
           FOREACH ap_up3 USING l_cma01 INTO l_cmb03,l_cmb06,l_cmb04 #CHI-C80002
              IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
              LET l_flag='Y'
              IF l_cma03='0' THEN    #原料時才要更新取價類別  #CHI-9C0025
                 #CHI-C80002---begin mark
                 #UPDATE cma_file
                 #   SET cma05='I',   #取價類別
                 #       cma11=l_cmb06    #異動單價
                 #  WHERE cma01=l_cma01      #CHI-9C0025
                 #    AND cma021=tm.yy #FUN-8B0047
                 #    AND cma022=tm.mm #FUN-8B0047
                 #CHI-C80002---end
                 EXECUTE cma_upd_p2 USING l_cmb06,l_cma01 #CHI-C80002
              ELSE
                 #CHI-C80002---begin mark
                 #UPDATE cma_file
                 #   SET cma11=l_cmb06    #異動單價
                 #  WHERE cma01=l_cma01      #CHI-9C0025
                 #    AND cma021=tm.yy #FUN-8B0047
                 #    AND cma022=tm.mm #FUN-8B0047
                 #CHI-C80002---end
                 EXECUTE cma_upd_p3 USING l_cmb06,l_cma01 #CHI-C80002 
              END IF
              IF SQLCA.SQLCODE <>0 THEN
                 LET g_success='N'
                  CALL p120_error('cm01',l_cma01,'upd cma:',SQLCA.sqlcode,1)    #CHI-970034 #CHI-9C0025
              END IF
              EXIT FOREACH
           END FOREACH
           IF l_flag='N' THEN
              IF l_cma03='0' THEN    #原料時才要更新取價類別  #CHI-9C0025
                  #CHI-C80002---begin mark
                  #UPDATE cma_file
                  #   SET cma05='I',   #取價類別
                  #       cma11=old_cmb06    #異動單價
                  #  WHERE cma01=l_cma01      #CHI-9C0025
                  #    AND cma021=tm.yy #FUN-8B0047
                  #    AND cma022=tm.mm #FUN-8B0047
                  #CHI-C80002---end
                  EXECUTE cma_upd_p2 USING old_cmb06,l_cma01 #CHI-C80002
               ELSE
                  #CHI-C80002---begin
                  #UPDATE cma_file
                  #   SET cma11=old_cmb06    #異動單價
                  #  WHERE cma01=l_cma01      #CHI-9C0025
                  #    AND cma021=tm.yy #FUN-8B0047
                  #    AND cma022=tm.mm #FUN-8B0047
                  #CHI-C80002---end
                  EXECUTE cma_upd_p3 USING old_cmb06,l_cma01 #CHI-C80002
               END IF
               IF SQLCA.SQLCODE <>0 THEN
                  LET g_success='N'
                   CALL p120_error('cm01',l_cma01,'upd cma:',SQLCA.sqlcode,1)                                #CHI-970034 #CHI-9C0025
               END IF
           END IF
           EXIT FOREACH
        END IF
     END FOREACH
     IF l_sw='N' THEN
           #判斷2B
           #CHI-C80002---begin mark
           #DECLARE ap_up4 CURSOR FOR
           #   SELECT cmb03,cmb06,cmb04
           #     FROM cmb_file
           #     WHERE cmb01=l_cma01  #CHI-9C0025
           #       AND cmb06 <> 0 
           #       AND cmb03 = '2B'
           #       AND cmb021=tm.yy #FUN-8B0047
           #       AND cmb022=tm.mm #FUN-8B0047
           #       ORDER BY cmb03,cmb04 
           #FOREACH ap_up4 INTO l_cmb03,l_cmb06,l_cmb04
           #CHI-C80002---end
           FOREACH ap_up3 USING l_cma01 INTO l_cmb03,l_cmb06,l_cmb04 #CHI-C80002
              IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
              LET l_flag='Y'
              IF l_cma03='0' THEN    #原料時才要更新取價類別  #CHI-9C0025
                 #CHI-C80002---begin mark
                 #UPDATE cma_file
                 #   SET cma05='I',   #取價類別
                 #       cma11=l_cmb06    #異動單價
                 #  WHERE cma01=l_cma01      #CHI-9C0025
                 #    AND cma021=tm.yy #FUN-8B0047
                 #    AND cma022=tm.mm #FUN-8B0047
                 #CHI-C80002---end
                 EXECUTE cma_upd_p2 USING l_cmb06,l_cma01 #CHI-C80002
              ELSE
                 #CHI-C80002---begin mark
                 #UPDATE cma_file
                 #   SET cma11=l_cmb06    #異動單價
                 #  WHERE cma01=l_cma01      #CHI-9C0025
                 #    AND cma021=tm.yy #FUN-8B0047
                 #    AND cma022=tm.mm #FUN-8B0047
                 #CHI-C80002---end
                 EXECUTE cma_upd_p3 USING l_cmb06,l_cma01 #CHI-C80002
              END IF
              IF SQLCA.SQLCODE <>0 THEN
                 LET g_success='N'
                  CALL p120_error('cm01',l_cma01,'upd cma:',SQLCA.sqlcode,1)   #CHI-970034 #CHI-9C0025
              END IF
              EXIT FOREACH
           END FOREACH
     END IF
     #一個料件結束
  END FOREACH
END FUNCTION
 
#讀取ROLLUP資料
FUNCTION p120_rollup()
  DEFINE l_sql     STRING, #No.FUN-680122CHAR(1200),  #FUN-950058
         l_cnt     LIKE type_file.num5,    #No.FUN-680122 
         l_flag    LIKE type_file.chr1,    #No.FUN-680122 
         l_ima01   LIKE ima_file.ima01,    #料件編號    
         l_ima08   LIKE ima_file.ima08,    #來源碼
         l_ima57   LIKE ima_file.ima57,    #成本階
         l_ima58   LIKE ima_file.ima58,    #標準人工工時
         l_ima16   LIKE ima_File.ima16,    #低階碼
         l_ima09   LIKE ima_file.ima09,    #原料/成品
         l_bmb03   LIKE bmb_file.bmb03,    #元件料號
         l_bmb06   LIKE bmb_file.bmb06,    #組成用量
         l_cma13   LIKE cma_file.cma13,    #rollup 
         l_cma05   LIKE cma_file.cma05,    #主件取價原則
         l_cma     RECORD LIKE cma_file.*,
         l_ima     RECORD LIKE ima_file.* 
  DEFINE l_ima910  LIKE ima_file.ima910    #FUN-550110
 
   #CHI-C80002---begin
   LET l_sql = " SELECT bmb03,bmb06/bmb07,cma_file.* ",
               "   FROM bmb_file,cma_file ",
               "   WHERE bmb03 = cma01 ",
               "     AND bmb01 = ? ",
               "     AND bmb04 <= '",tm.bdate,"'",
               "     AND (bmb05 IS NULL OR bmb05 > '",tm.bdate,"' ) ",
               "     AND bmb29 = ? ",
               "     AND cma021= ",tm.yy,
               "     AND cma022= ",tm.mm
   PREPARE bmb_pre FROM l_sql
   DECLARE bmb_cus CURSOR FOR bmb_pre
   
   LET l_sql = " UPDATE cma_file ",
               "    SET cma13 = ?, ",
               "        cma05 = 'B' ",
               "  WHERE cma01 = ? ",
               "    AND cma021= ",tm.yy,
               "    AND cma022= ",tm.mm
   PREPARE cma_upd_p4 FROM l_sql

   LET l_sql = " UPDATE cma_file ",
               "    SET cma13 = ? ",
               "  WHERE cma01 = ? ",
               "    AND cma021= ",tm.yy,
               "    AND cma022= ",tm.mm
   PREPARE cma_upd_p5 FROM l_sql            
   #CHI-C80002---end
   LET l_cnt=0
   LET l_sql = " SELECT DISTINCT ima01,ima08,ima57,ima58,ima16,ima09,cma05 ", #CHI-9C0025
               " FROM ima_file,bma_file,cma_file ",
               " WHERE ima01=bma01 ",
               "   AND ima910=bma06 ",  #FUN-550110
               "   AND ima01=cma01 ",
               "   AND ima57<>'99' ",
               "   AND cma021=",tm.yy, #FUN-8B0047
               "   AND cma022=",tm.mm, #FUN-8B0047
               "   AND imaacti = 'Y' ",     #MOD-C10167 add
               "   ORDER BY ima57 DESC,ima16 DESC,ima01 "
   PREPARE p120_rol3 FROM l_sql
   DECLARE p120_rop3 CURSOR FOR p120_rol3
   FOREACH p120_rop3 INTO l_ima01,l_ima08,l_ima57,l_ima58,
                          l_ima16,l_ima09,l_cma05
     IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
     IF cl_null(l_ima58) THEN LET l_ima58=0 END IF
     #若為採購料件, 則標準工時=0
     IF l_ima08 ='P' THEN LET l_ima58=0 END IF
     LET l_cnt=l_cnt+1
     LET tm.no_ok=l_cnt
     LET tm.p1 =l_ima57
     LET tm.p2 = l_ima01
     IF g_bgjob = 'N' THEN      #NO.FUN-570153 
         DISPLAY BY NAME tm.no_ok,tm.p1,tm.p2
     END IF
     CALL ui.Interface.refresh()
     LET l_cma13=0
     LET l_flag='N'
 
     LET l_ima910=''
     SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=l_ima01
     IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
     #CHI-C80002---begin mark
     #DECLARE bmb_cus CURSOR FOR
     #   SELECT DISTINCT bmb03,bmb06/bmb07,cma_file.*  #CHI-9C0025
     #     FROM bmb_file,cma_file
     #     WHERE bmb03 = cma01 
     #       AND bmb01 = l_ima01
     #       AND bmb04 <= tm.bdate
     #       AND (bmb05 IS NULL OR bmb05 > tm.bdate)
     #       AND bmb29 = l_ima910       #FUN-550110
     #       AND cma021=tm.yy #FUN-8B0047
     #       AND cma022=tm.mm #FUN-8B0047
     #FOREACH bmb_cus INTO l_bmb03,l_bmb06,l_cma.*
     #CHI-C80002---end
     FOREACH bmb_cus USING l_ima01,l_ima910 INTO l_bmb03,l_bmb06,l_cma.*  #CHI-C80002
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
        LET l_flag='Y'
        IF l_bmb06 IS NULL THEN LET l_bmb06=1 END IF
        CASE l_cma.cma05 
          WHEN 'I'  LET l_cma13 = l_cma13 + l_cma.cma11*l_bmb06
          WHEN 'S'  LET l_cma13 = l_cma13 + l_cma.cma12*l_bmb06
          WHEN 'B'  LET l_cma13 = l_cma13 + l_cma.cma13*l_bmb06
          WHEN 'C'  LET l_cma13 = l_cma13 + l_cma.cma14*l_bmb06
        END CASE
     END FOREACH 
     IF cl_null(l_cma13) THEN LET l_cma13=0 END IF
     #成本=下階成本+本階之標準工時*標準工時單價+本階之標準工時*製造費用
     LET l_cma13 = l_cma13 + l_ima58*tm.price1 + l_ima58*tm.price2
     IF l_flag='Y' THEN
        IF l_ima09 = '0' THEN    #材料
           IF  l_cma05 <> 'I' AND l_cma13 <>0 THEN
               #CHI-C80002---begin mark
               #UPDATE cma_file 
               #  SET cma13 = l_cma13,
               #      cma05 = 'B'
               #WHERE cma01 = l_ima01
               #  AND cma021=tm.yy #FUN-8B0047
               #  AND cma022=tm.mm #FUN-8B0047
               #CHI-C80002---end
               EXECUTE cma_upd_p4 USING l_cma13,l_ima01  #CHI-C80002
           ELSE
               #CHI-C80002---begin mark
               #UPDATE cma_file 
               #  SET cma13 = l_cma13 
               # WHERE cma01 = l_ima01
               #   AND cma021=tm.yy #FUN-8B0047
               #   AND cma022=tm.mm #FUN-8B0047
               #CHI-C80002---end
               EXECUTE cma_upd_p5 USING l_cma13,l_ima01  #CHI-C80002
           END IF
         ELSE
           #成品
           IF  l_cma05 = 'C' AND l_cma13 <>0 THEN
               #CHI-C80002---begin mark
               #UPDATE cma_file 
               #  SET cma13 = l_cma13,
               #      cma05 = 'B'
               # WHERE cma01 = l_ima01
               #   AND cma021=tm.yy #FUN-8B0047
               #   AND cma022=tm.mm #FUN-8B0047
               #CHI-C80002---end
               EXECUTE cma_upd_p4 USING l_cma13,l_ima01  #CHI-C80002
           ELSE
               #CHI-C80002---begin mark
               #UPDATE cma_file 
               #  SET cma13 = l_cma13 
               # WHERE cma01 = l_ima01
               #   AND cma021=tm.yy #FUN-8B0047
               #   AND cma022=tm.mm #FUN-8B0047
               #CHI-C80002---end
               EXECUTE cma_upd_p5 USING l_cma13,l_ima01  #CHI-C80002
           END IF
        END IF    
        IF SQLCA.SQLCODE <> 0 THEN
           LET g_success='N'
            CALL p120_error('cma01',l_ima01,'rollup:',SQLCA.sqlcode,1) #CHI-970034       
        END IF
     END IF
   END FOREACH
END FUNCTION
 
#====================================
# 淨變現開始處理資料
#====================================
FUNCTION p150()
   DEFINE l_sql       STRING
   DEFINE l_name      LIKE type_file.chr20  #CHI-970034
 
   LET tm.wc1 = cl_replace_str(tm.wc,'ima01','ccc01')
 
   LET tm.no_ok = 0
   LET tm.p1 = ''
   DISPLAY tm.no_ok TO FORMONLY.no_ok
   DISPLAY tm.p1 TO FORMONLY.p1
 
 
   LET l_sql = "SELECT ima01,ccc07,ccc08,ccc23,azf06,0,0,ima25, ",  #CHI-9C0025
               "       ima06,ima09,ima10,ima11,ima12,ima131,ima57 ",
               "  FROM p120_file,ima_file ",
               " LEFT OUTER JOIN azf_file ON ((ima_file.ima12 = azf_file.azf01) AND azf_file.azf02 = 'G') ",
               " LEFT OUTER JOIN ccc_file ON ((ima_file.ima01 = ccc_file.ccc01) AND ccc_file.ccc07 = '",tm.ctype,"' ", #CHI-9C0025
               " AND ccc_file.ccc02 = ", tm.yy," AND ccc_file.ccc03 = ",tm.mm,") ", #CHI-970011 add ccc08 #CHI-9C0025 拿掉ccc08
               " WHERE cma01 = ima01 ",
               " AND imaacti = 'Y' ",     #MOD-C10167 add
               " ORDER BY azf06,ima57,ima01,ccc08"   #FUN-930100  #CHI-9C0025 add ccc08   #CHI-C50065 add ima57
 
   PREPARE p150_ccc_p1 FROM l_sql
   DECLARE p150_ccc_cs1 CURSOR FOR p150_ccc_p1
   FOREACH p150_ccc_cs1 INTO g_ccc.*
      IF SQLCA.SQLCODE THEN
         CALL p120_error('ccc01',g_ccc.ccc01,'ccc_cs1',SQLCA.sqlcode,1)#CHI-970034
         LET g_success = 'N'
         RETURN
      END IF
      IF g_bgjob = 'N' THEN
         DISPLAY g_ccc.ccc01 TO FORMONLY.p1
         CALL ui.Interface.refresh()
      END IF
      IF cl_null(g_ccc.ccc07) THEN
         LET g_ccc.ccc07=tm.ctype
      END IF
      IF g_ccc.ccc08 IS NULL THEN
         LET g_ccc.ccc08=' '
      END IF
      INITIALIZE g_cma.* TO NULL
      SELECT * INTO g_cma.* 
        FROM cma_file
       WHERE cma01=g_ccc.ccc01
         AND cma021=tm.yy
         AND cma022=tm.mm
         AND cma07=g_ccc.ccc07  #CHI-9C0025
         AND cma08=g_ccc.ccc08  #CHI-9C0025
      LET g_ccc.cma11=g_cma.cma11
      LET g_ccc.cma12=g_cma.cma12
      CASE 
         WHEN g_ccc.azf06 MATCHES '[01]'  #成品
              CALL p150_p1_0('0',g_ccc.ccc01)   #FUN-980101
         WHEN g_ccc.azf06 = '2'           #半成品
              CALL p150_p1_2()
         WHEN g_ccc.azf06 = '3'           #原料
              CALL p150_p1_3()
         OTHERWISE
           #該料號之成本分群碼(ima12)，成本性質欄位未設定或設定錯誤
            CALL p120_error('ccc01',g_ccc.ccc01,'ima12','axc-888',1)  #CHI-970034
            LET tm.no_ok = tm.no_ok + 1       #CHI-970054
            DISPLAY tm.no_ok TO FORMONLY.no_ok#CHI-970054
            CALL ui.Interface.refresh()       #CHI-970054
            CONTINUE FOREACH
      END CASE
      LET tm.no_ok = tm.no_ok + 1       #CHI-970054
      DISPLAY tm.no_ok TO FORMONLY.no_ok#CHI-970054
      CALL ui.Interface.refresh()       #CHI-970054
     #MOD-D40113 str -----
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF
     #MOD-D40113 end -----
   END FOREACH
   #處理完所有料號才將cma25為負值的資料清成0,以區別處理過程中cma25為0和為負值的差別
   UPDATE cma_file SET cma25=0 WHERE cma25 < 0 
                                 AND cma021=tm.yy AND cma022=tm.mm
                                 AND cma07=tm.ctype  #CHI-9C0025
     #MOD-D40113 str -----
      IF g_totsuccess='N' THEN
         LET l_sql = " DELETE FROM cma_file",
             " WHERE EXISTS(SELECT 1 FROM ima_file WHERE ",tm.wc CLIPPED," AND ima01 = cma01 AND imaacti = 'Y' ) ", 
             "   AND cma021=",tm.yy, 
             "   AND cma022=",tm.mm, 
             "   AND cma07='",tm.ctype,"'"  #CHI-9C0025
         PREPARE del_cma2 FROM l_sql
         EXECUTE del_cma2

         LET l_sql = " DELETE FROM cmb_file",
             " WHERE EXISTS(SELECT 1 FROM ima_file WHERE ",tm.wc CLIPPED," AND ima01 = cmb01 AND imaacti = 'Y' ) " , 
             "   AND cmb021=",tm.yy, 
             "   AND cmb022=",tm.mm  
         PREPARE del_cmb2 FROM l_sql
         EXECUTE del_cmb2

         LET l_sql = " DELETE FROM cmg_file",
             " WHERE EXISTS(SELECT 1 FROM ima_file WHERE ",tm.wc CLIPPED," AND ima01 = cmg03 AND imaacti = 'Y' ) " , #CHI-C80002
             "   AND cmg01=",tm.yy,
             "   AND cmg02=",tm.mm,
             "   AND cmg071='",tm.ctype,"'"
         PREPARE del_cmg2 FROM l_sql
         EXECUTE del_cmg2
      END IF
     #MOD-D40113 end -----
 
END FUNCTION
 
#====================================
# 成品：計算淨變現單價_INS
#====================================
FUNCTION p150_p1_0(p_cmd,p_ccc01)  #FUN-980101
#  DEFINE l_mark_price  LIKE cmf_file.cmf05   #FUN-930100 add   #FUN-B30212 mark
#  DEFINE l_flag        LIKE type_file.num5   #FUN-930100 add   #FUN-B30212 mark
   DEFINE p_ccc01       LIKE ccc_file.ccc01   #FUN-980101
   DEFINE p_cmd         LIKE type_file.chr1   #0:成品 2:半成品 #FUN-980101
   
   IF p_cmd = '0' THEN               #FUN-980101
      LET g_cma.cma26 = g_ccc.cma12
   ELSE                              #FUN-980101
      LET g_cma.cma26 = 0            #FUN-980101
   END IF                            #FUN-980101
 
   CALL p150_p1_0_get(p_cmd,p_ccc01) #FUN-980101
   IF g_success = 'N' THEN RETURN END IF
 #FUN-B30212 mark (S) 移到p150_p1_0_get裡面做 
 #   #如果有設人工市價,則cma26改抓人工市價
 #  CALL p120_get_i311(p_ccc01) RETURNING l_flag,l_mark_price  #FUN-980101 g_ccc.ccc02-->p_ccc01
 #  IF l_flag THEN
 #     LET g_cma.cma26  = l_mark_price
 #     LET g_cma.cma25  = l_mark_price * (1-(g_cma.cma32/100))
 #     LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_azi03)      
 #     LET g_cma.cma27  = 'MARKET'  #CHI-970067
 #     LET g_cma.cma28  = NULL      #CHI-970067
 #  END IF
 #FUN-B30212 mark (E)
   CALL FGL_SETENV("DBDATE","Y4MD/")
   IF g_cma.cma271 = '1899/12/31' THEN 
      LET g_cma.cma271 = NULL 
   END IF   
   CALL FGL_SETENV("DBDATE",g_date)
 
   UPDATE cma_file 
      SET cma25 = g_cma.cma25,
          cma26 = g_cma.cma26,
          cma27 = g_cma.cma27,
          cma271 = g_cma.cma271, #FUN-930100
          cma28 = g_cma.cma28,
          cma29 = g_cma.cma29,
          cma32 = g_cma.cma32
    WHERE cma01 = p_ccc01       #FUN-980101 g_ccc.ccc02-->p_ccc01
      AND cma021= tm.yy
      AND cma022= tm.mm
      AND cma07 = g_cma.cma07  #CHI-9C0025
      AND cma08 = g_cma.cma08  #CHI-9C0025
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     #資料新增失敗
      CALL p120_error('cma01',p_ccc01,'upd cma','9050',1)       #CHI-970034 #FUN-980101
      LET g_success = 'N'
      RETURN
   ELSE
      IF g_bgjob = 'N' THEN
      END IF
   END IF
END FUNCTION
 
#====================================
# 成品：計算淨變現單價
#====================================
FUNCTION p150_p1_0_get(p_cmd,p_ima01)
   DEFINE p_cmd         LIKE type_file.chr1                  #0:成品 2:半成品 #3:原料 #FUN-B30173
   DEFINE p_ima01       LIKE ima_file.ima01
   DEFINE l_sql         STRING
   DEFINE l_price       LIKE cma_file.cma25,  #單價
          l_oeb01       LIKE oeb_file.oeb01,        #單號
          l_oeb03       LIKE oeb_file.oeb03,        #項次
          l_fac         LIKE ogb_file.ogb05_fac,    #單位轉換率
          l_cme03       LIKE cme_file.cme03         #分類碼
   DEFINE l_ogb916      LIKE ogb_file.ogb916
   DEFINE l_oeb916      LIKE oeb_file.oeb916
   DEFINE l_oeb916_a    LIKE oeb_file.oeb916
   DEFINE l_ima25       LIKE ima_file.ima25
   DEFINE l_ogb05_fac   LIKE ogb_file.ogb05_fac
   DEFINE l_oeb05_fac_a LIKE oeb_file.oeb05_fac
   DEFINE l_oeb05_fac   LIKE oeb_file.oeb05_fac
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_avg_cnt     LIKE type_file.num10  #FUN-930100 add
   DEFINE l_cma271      LIKE cma_file.cma271  #FUN-930100 add
   DEFINE l_cmg_flag    LIKE type_file.num5   #FUN-950058 #FALSE - cmg_file已被新增過, TRUE - cmg_file未被新增過 
                                              #(若第一筆新增出現-239,則表示此料已存在cmg資料,不需再新增第二筆以後的資料,因為第二筆以後也會是-239,以節省效率)
   DEFINE l_omb12       LIKE omb_file.omb12   #CHI-970034
   DEFINE l_omb16       LIKE omb_file.omb16   #CHI-970034
   DEFINE l_omb05       LIKE omb_file.omb05   #CHI-970034
   DEFINE l_tot_qty     LIKE omb_file.omb12   #CHI-970034
   DEFINE l_tot_amt     LIKE omb_file.omb16   #CHI-970034
   DEFINE l_oma02_t     LIKE oma_file.oma02   #No:MOD-AA0155 add
   DEFINE l_msg         LIKE ze_file.ze03     #FUN-B30173 
   DEFINE l_azf06       LIKE azf_file.azf06   #FUN-B30173 
   DEFINE l_mark_price  LIKE cmf_file.cmf05   #FUN-930100 add
   DEFINE l_flag        LIKE type_file.num5   #FUN-930100 add
   
   #FUN-B30212 (S)
   #如果有設人工市價,則cma26改抓人工市價,後面都不做
   CALL p120_get_i311(p_ima01) RETURNING l_flag,l_mark_price
   IF l_flag THEN
      LET g_cma.cma26  = l_mark_price
      LET g_cma.cma25  = l_mark_price * (1-(g_cma.cma32/100))
     #LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_azi03)         #MOD-C30068 mark
      LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_ccz.ccz26)     #MOD-C30068 add      
      LET g_cma.cma27  = 'MARKET'
      LET g_cma.cma28  = NULL
      RETURN
   END IF
   #FUN-B30212 (E) 
   IF (g_cmz.cmz17 IS NULL OR g_cmz.cmz17 = 'Y') THEN #FUN-930100 add
      #取得成本單價
      IF p_cmd = '0' THEN
         LET g_ccc23 = g_ccc.ccc23
      ELSE
        LET g_ccc23 = 0
        SELECT ccc23 INTO g_ccc23 FROM ccc_file
         WHERE ccc01 = p_ima01
           AND ccc02 = tm.yy
           AND ccc03 = tm.mm
           AND ccc07 = g_cma.cma07  #CHI-9C0025
           AND ccc08 = g_cma.cma08  #CHI-9C0025
      END IF 
      IF g_ccc23 IS NULL THEN LET g_ccc23 = 0 END IF
   END IF   #FUN-930100
  #MOD-AA0155---add---start---
   DROP TABLE  p120_tmp
   CREATE TEMP TABLE p120_tmp(
     oeb01  LIKE oeb_file.oeb01, 
     oeb03  LIKE oeb_file.oeb03, 
     price  LIKE cma_file.cma25) 
   CREATE INDEX p120_index ON p120_tmp(oeb01) #CHI-C80002 
  #MOD-AA0155---add---end---
  #MOD-B10130---add---start---
   LET l_sql = "SELECT * FROM (SELECT oeb01,oeb03,MAX(price) AS price ",
               " FROM p120_tmp GROUP BY oeb01,oeb03 ORDER BY price DESC) ",
               " WHERE rownum <=1 "
   PREPARE oeb01_max FROM l_sql
   DECLARE oeb01_1 CURSOR FOR oeb01_max

   LET l_sql = "SELECT * FROM (SELECT oeb01,oeb03,MIN(price) AS price ",
               " FROM p120_tmp GROUP BY oeb01,oeb03 ORDER BY price) ",
               " WHERE rownum <=1 "
   PREPARE oeb01_min FROM l_sql
   DECLARE oeb01_2 CURSOR FOR oeb01_min
  #MOD-B10130---add---end---
 
  #-->取應收帳款之單價
   SELECT ima25 INTO l_ima25   
                      FROM ima_file WHERE ima01 = p_ima01  #CHI-970034
   LET l_price = 0
   LET l_sql = 
      "SELECT omb01,omb03,",  #TQC-940146
      #調整單價取值應判斷稅率否及匯率換算
      "  CASE oma213 WHEN 'Y' THEN (omb16/omb12) ELSE omb15 END AS amt,", #TQC-940146  #TQC-940181 modify
      "       ogb916,oma02,omb12,omb05,omb16 ",   #TQC-940146 #CHI-970034
      "  FROM oma_file,omb_file,ogb_file ",
      " WHERE oma01 = omb01 ",
      "   AND oma00[1,1] = '1'  ", #帳款類別 (1*:應收帳款)  #No.TQC-9B0021
      "   AND omb04 = '",p_ima01,"'    ",
      "   AND omb31 = ogb01       ",
      "   AND omb32 = ogb03       ",
      "   AND omaconf = 'Y'       ",      #已確認
      "   AND omavoid = 'N'       ",      #未作廢
      "   AND omb15 > 0           " 
   IF tm.choice2 = '3' THEN
      LET l_sql = l_sql ,"   AND oma02 BETWEEN '",g_agv_bdate,"' AND '",g_agv_edate,"' "      
   ELSE
      LET l_sql = l_sql ,"   AND oma02 BETWEEN '",tm.cmz70,"' AND '",a_edate,"' "   
   END IF
   CASE tm.choice2
      WHEN "1"
         LET l_sql=l_sql CLIPPED, " ORDER BY oma02 DESC,omb15 DESC "
      WHEN "2"
         LET l_sql=l_sql CLIPPED, " ORDER BY oma02 DESC,omb15 "
      WHEN "3"  #平均值
         LET l_sql=l_sql CLIPPED, " ORDER BY oma01,omb03 "
      OTHERWISE
         LET l_sql=l_sql CLIPPED, " ORDER BY oma02 DESC,omb15 "
   END CASE
   
   LET l_avg_cnt = 0 #FUN-930100
   LET l_tot_amt = 0 #CHI-970034
   LET l_tot_qty = 0 #CHI-970034
   LET l_cmg_flag = TRUE #FUN-950058
   LET l_oma02_t = NULL  #No:MOD-AA0155 add
   PREPARE p150_k1_p1 FROM l_sql
   DECLARE p150_k1_cs1 CURSOR FOR p150_k1_p1
   FOREACH p150_k1_cs1 INTO l_oeb01,l_oeb03,l_price,l_ogb916,l_cma271,  #CHI-920005 FUN-930100 add l_cma271
                            l_omb12,l_omb05,l_omb16   #CHI-970034
      IF SQLCA.SQLCODE THEN
         CALL p120_error('ima01',p_ima01,'k1_cs1',SQLCA.sqlcode,1) #CHI-970034
         LET g_success = 'N'
         RETURN
      END IF
     LET l_cnt = 0
     CALL s_umfchk(p_ima01,l_ogb916,l_ima25) RETURNING l_cnt,l_ogb05_fac
     IF l_cnt = 1 THEN
        LET g_showmsg= l_oeb01,"/",l_oeb03
        CALL p120_error('omb01,omb03',g_showmsg,'unit trans:','abm-731',1) #CHI-970034
        LET l_ogb05_fac = 1   #TQC-940146
     END IF
     LET l_price = l_price / l_ogb05_fac   #TQC-940146
      IF cl_null(l_price) THEN LET l_price = 0 END IF
      IF l_price <= 0 THEN CONTINUE FOREACH END IF  #FUN-950058
      LET l_avg_cnt = l_avg_cnt + 1
      IF tm.choice2 ='3' THEN
         IF l_cmg_flag THEN
            LET l_cnt = 0
            CALL s_umfchk(p_ima01,l_omb05,l_ima25) RETURNING l_cnt,l_ogb05_fac
            IF l_cnt = 1 THEN
               LET g_showmsg= l_oeb01,"/",l_oeb03
               CALL p120_error('omb01,omb03',g_showmsg,'sale-unit trans:','abm-731',1)  #CHI-970034
               LET l_ogb05_fac = 1
            END IF
            CALL p120_ins_cmg(l_oeb01,l_oeb03,p_ima01,l_avg_cnt,l_omb16,l_cma271,'1',
                              l_omb12,l_omb05,l_ogb05_fac) RETURNING l_cmg_flag  #CHI-970034
         END IF
         LET l_tot_amt = l_tot_amt + l_omb16   #CHI-970034
         LET l_tot_qty = l_tot_qty + (l_omb12 * l_ogb05_fac)  #CHI-970034
      ELSE
        #MOD-AA0155---add---start---
         IF cl_null(l_oma02_t) OR l_oma02_t = l_cma271 THEN
            LET l_oma02_t = l_cma271
            INSERT INTO p120_tmp (oeb01,oeb03,price)     
                        VALUES(l_oeb01,l_oeb03,l_price)   
         ELSE
        #MOD-AA0155---add---end---
            LET l_cma271 = l_oma02_t     #MOD-B60110 add
            EXIT FOREACH
         END IF        #No:MOD-AA0155 add
      END IF
   END FOREACH
  #MOD-AA0155---add---start---
   IF tm.choice2 ='1' THEN
     #MOD-B10130---modify---start---     #改與MOD-B10130寫法一致
     #DECLARE p150_p1_0_get_c1 CURSOR FOR 
     # SELECT oeb01,oeb03,price FROM p120_tmp ORDER BY price DESC
     #OPEN p150_p1_0_get_c1
     #FETCH p150_p1_0_get_c1 INTO l_oeb01,l_oeb03,l_price
     #CLOSE p150_p1_0_get_c1
      OPEN oeb01_1
      FETCH oeb01_1 INTO l_oeb01,l_oeb03,l_price
     #MOD-B10130---modify---end---
   ELSE
      IF tm.choice2 ='2' THEN
        #MOD-B10130---modify---start---     #改與MOD-B10130寫法一致
        #DECLARE p150_p1_0_get_c2 CURSOR FOR 
        # SELECT oeb01,oeb03,price FROM p120_tmp ORDER BY price ASC
        #OPEN p150_p1_0_get_c2
        #FETCH p150_p1_0_get_c2 INTO l_oeb01,l_oeb03,l_price
        #CLOSE p150_p1_0_get_c2
         OPEN oeb01_2
         FETCH oeb01_2 INTO l_oeb01,l_oeb03,l_price
        #MOD-B10130---modify---end---
      END IF 
   END IF 
   DELETE FROM p120_tmp
  #MOD-AA0155---add---end---
   IF l_price IS NULL THEN LET l_price = 0 END IF
   IF l_price <= 0 THEN
     #取一般訂單之單價
      LET l_price = 0
      LET l_sql = "SELECT oeb01,oeb03,oeb916,oea02,",  #CHI-920005 #FUN-930100 add oea02
                  "  CASE oea213 ",
                  "       WHEN 'Y' THEN (oeb14/oeb12)*oea24 ",
                  "       ELSE oeb13*oea24 ",
                  "  END AS amt ,",
                  "   oeb12,oeb05,(oeb14*oea24) ",  #CHI-970034  #No:MOD-A10051 modify
                  "  FROM oea_file,oeb_file ",
                  " WHERE oea01 = oeb01 ",
                  "   AND oeaconf = 'Y' ",  #已確認
                  "   AND oea00 = '1' ",    #一般訂單
                  "   AND oeb04 = '", p_ima01, "'",
                  "   AND oeb12 <> 0 ",     #數量不可為0
                  "   AND oeb13 > 0  "      #單價不可為0  #FUN-950058
      IF tm.choice2 = '3' THEN
         LET l_sql = l_sql ,"   AND oea02 BETWEEN '",g_agv_bdate,"' AND '",g_agv_edate,"' "
      ELSE
         LET l_sql = l_sql ,"   AND oea02 BETWEEN '", tm.cmz70, "' AND '", a_edate, "'"
      END IF
      CASE tm.choice2
         WHEN "1"
            LET l_sql=l_sql CLIPPED, " ORDER BY oea02 DESC, amt DESC "
         WHEN "2"
            LET l_sql=l_sql CLIPPED, " ORDER BY oea02 DESC, amt "
         WHEN "3"  #平均值
            LET l_sql=l_sql CLIPPED, " ORDER BY oeb01,oeb03 "
         OTHERWISE
            LET l_sql=l_sql CLIPPED, " ORDER BY oea02 DESC, amt "
      END CASE
 
      LET l_avg_cnt = 0 #FUN-930100
      LET l_tot_amt = 0    #CHI-970034
      LET l_tot_qty = 0    #CHI-970034
      LET l_cmg_flag = TRUE #FUN-950058
      LET l_oma02_t = NULL  #No:MOD-AA0155 add
      PREPARE p150_k1_p2 FROM l_sql
      DECLARE p150_k1_cs2 CURSOR FOR p150_k1_p2
      FOREACH p150_k1_cs2 INTO l_oeb01,l_oeb03,l_oeb916,l_cma271,l_price, #CHI-920005 add l_oeb916 #FUN-930100 add l_cma271
                               l_omb12,l_omb05,l_omb16  #CHI-970034
         IF SQLCA.SQLCODE THEN
            CALL p120_error('ima01',p_ima01,'ks_cs2',SQLCA.sqlcode,1)  #CHI-970034
            LET g_success = 'N'
            RETURN
         END IF
         LET l_cnt = 0
         CALL s_umfchk(p_ima01,l_oeb916,l_ima25) RETURNING l_cnt,l_oeb05_fac
         IF l_cnt = 1 THEN
            LET g_showmsg= l_oeb01,"/",l_oeb03
            CALL p120_error('oeb01,oeb03',g_showmsg,'unit trans:','abm-731',1) #CHI-970034
            LET l_oeb05_fac = 1   #TQC-940146
         END IF
         LET l_price = l_price / l_oeb05_fac     #TQC-940146
         IF l_price IS NULL THEN LET l_price = 0 END IF
         IF l_price <= 0 THEN CONTINUE FOREACH END IF
         LET l_avg_cnt = l_avg_cnt + 1
         IF tm.choice2 ='3' THEN
            IF l_cmg_flag THEN
                LET l_cnt = 0
               CALL s_umfchk(p_ima01,l_omb05,l_ima25) RETURNING l_cnt,l_oeb05_fac
               IF l_cnt = 1 THEN
                  LET g_showmsg= l_oeb01,"/",l_oeb03
                  CALL p120_error('oeb01,oeb03',g_showmsg,'sale-unit trans:','abm-731',1)  #CHI-970034
                  LET l_oeb05_fac = 1
               END IF
               CALL p120_ins_cmg(l_oeb01,l_oeb03,p_ima01,l_avg_cnt,l_omb16,l_cma271,'2',
                                 l_omb12,l_omb05,l_oeb05_fac) RETURNING l_cmg_flag  #CHI-970034
            END IF
             LET l_tot_amt = l_tot_amt + l_omb16      #CHI-970034
             LET l_tot_qty = l_tot_qty + (l_omb12 * l_oeb05_fac)  #CHI-970034
         ELSE
           #MOD-AA0155---add---start---
            IF cl_null(l_oma02_t) OR l_oma02_t = l_cma271 THEN
               LET l_oma02_t = l_cma271
               INSERT INTO p120_tmp (oeb01,oeb03,price)     #MOD-B10130 add oeb01,oeb03
                           VALUES(l_oeb01,l_oeb03,l_price)  #MOD-B10130 add l_oeb01,l_oeb03
            ELSE
           #MOD-AA0155---add---end---
               LET l_cma271 = l_oma02_t     #MOD-B60110 add
               EXIT FOREACH
            END IF      #No:MOD-AA0155 add
         END IF
      END FOREACH
     #MOD-AA0155---add---start---
      IF tm.choice2 ='1' THEN
        #MOD-B10130---modify---start---
        #SELECT MAX(price) INTO l_price FROM p120_tmp
         OPEN oeb01_1
         FETCH oeb01_1 INTO l_oeb01,l_oeb03,l_price
        #MOD-B10130---modify---end---
      ELSE
         IF tm.choice2 ='2' THEN
           #MOD-B10130---modify---start---
           #SELECT MIN(price) INTO l_price FROM p120_tmp
            OPEN oeb01_2
            FETCH oeb01_2 INTO l_oeb01,l_oeb03,l_price
           #MOD-B10130---modify---end---
         END IF 
      END IF 
      DELETE FROM p120_tmp
     #MOD-AA0155---add---end---
      IF l_price IS NULL THEN LET l_price = 0 END IF
      IF l_price <= 0 THEN
        #取合約訂單之單價
         LET l_price = 0
         LET l_sql = "SELECT oeb01,oeb03,oeb916,oea02,",  #CHI-920005 add oeb916 #FUN-930100 add oea02
                     "  CASE oea213 ",
                     "       WHEN 'Y' THEN (oeb14/oeb12)*oea24 ",
                     "       ELSE oeb13*oea24 ",
                     "  END AS amt, ",
                     "   oeb12,oeb05,(oeb14*oea24) ", #CHI-970034  #No:MOD-A10051 modify
                     "  FROM oea_file,oeb_file ",
                     " WHERE oea01 = oeb01 ",
                     "   AND oeaconf = 'Y' ",  #已確認
                     "   AND oea00 = '0' ",    #合約訂單
                     "   AND oeb12 <> 0 ",     #數量不可為0
                     "   AND oeb13 > 0  ",     #FUN-950058  單價不可為0
                     "   AND oeb04 = '", p_ima01, "'" 
         IF tm.choice2 = '3' THEN
            LET l_sql = l_sql ,"   AND oea02 BETWEEN '",g_agv_bdate,"' AND '",g_agv_edate,"' "
         ELSE
            LET l_sql = l_sql ,"   AND oea02 BETWEEN '", tm.cmz70,"' AND '", a_edate,"'"
         END IF
         CASE tm.choice2
            WHEN "1"
               LET l_sql=l_sql CLIPPED, " ORDER BY oea02 DESC, amt DESC "
            WHEN "2"
               LET l_sql=l_sql CLIPPED, " ORDER BY oea02 DESC, amt "
            WHEN "3"  #平均值
               LET l_sql=l_sql CLIPPED, " ORDER BY oeb01,oeb03 "
            OTHERWISE
               LET l_sql=l_sql CLIPPED, " ORDER BY oea02 DESC, amt "
         END CASE
         LET l_avg_cnt = 0 #FUN-930100
         LET l_tot_amt = 0   #CHI-970034
         LET l_tot_qty = 0   #CHI-970034
         LET l_cmg_flag = TRUE #FUN-950058
         LET l_oma02_t = NULL     #No:MOD-AA0155 add
         PREPARE p150_k1_p3 FROM l_sql
         DECLARE p150_k1_cs3 CURSOR FOR p150_k1_p3
         FOREACH p150_k1_cs3 INTO l_oeb01,l_oeb03,l_oeb916_a,l_cma271,l_price,  #CHI-920005 #FUN-930100 add l_cma271
                                  l_omb12,l_omb05,l_omb16  #CHI-970034
            IF SQLCA.SQLCODE THEN
               CALL p120_error('ima01',p_ima01,'ks_cs3',SQLCA.sqlcode,1)  #CHI-970034
               LET g_success = 'N'
               RETURN
            END IF
            LET l_cnt = 0
            CALL s_umfchk(p_ima01,l_oeb916_a,l_ima25) RETURNING l_cnt,l_oeb05_fac_a
            IF l_cnt = 1 THEN
               LET g_showmsg= l_oeb01,"/",l_oeb03
               CALL p120_error('oeb01,oeb03',g_showmsg,'unit trans:','abm-731',1) #CHI-970034
               LET l_oeb05_fac_a = 1     #TQC-940146
            END IF
            LET l_price = l_price / l_oeb05_fac_a      #TQC-940146
            IF l_price IS NULL THEN LET l_price = 0 END IF
            IF l_price <= 0 THEN CONTINUE FOREACH END IF
            LET l_avg_cnt = l_avg_cnt + 1
            IF tm.choice2 ='3' THEN
               IF l_cmg_flag THEN
                  LET l_cnt = 0
                  CALL s_umfchk(p_ima01,l_omb05,l_ima25) RETURNING l_cnt,l_oeb05_fac_a
                  IF l_cnt = 1 THEN
                     LET g_showmsg= l_oeb01,"/",l_oeb03
                     CALL p120_error('oeb01,oeb03',g_showmsg,'sale-unit trans:','abm-731',1)  #CHI-970034
                     LET l_oeb05_fac_a = 1
                  END IF
                  CALL p120_ins_cmg(l_oeb01,l_oeb03,p_ima01,l_avg_cnt,l_omb16,l_cma271,'3',
                                    l_omb12,l_omb05,l_oeb05_fac_a) RETURNING l_cmg_flag  #CHI-970034
               END IF
                LET l_tot_amt = l_tot_amt + l_omb16     #CHI-970034
                LET l_tot_qty = l_tot_qty + (l_omb12 * l_oeb05_fac_a)  #CHI-970034
            ELSE
              #MOD-AA0155---add---start---
               IF cl_null(l_oma02_t) OR l_oma02_t = l_cma271 THEN
                  LET l_oma02_t = l_cma271
                  INSERT INTO p120_tmp (oeb01,oeb03,price)     #MOD-B10130 add oeb01,oeb03
                              VALUES(l_oeb01,l_oeb03,l_price)  #MOD-B10130 add l_oeb01,l_oeb03
               ELSE
              #MOD-AA0155---add---end---
                  LET l_cma271 = l_oma02_t     #MOD-B60110 add
                  EXIT FOREACH
               END IF    #No:MOD-AA0155 add 
            END IF
         END FOREACH
        #MOD-AA0155---add---start---
         IF tm.choice2 ='1' THEN
           #MOD-B10130---modify---start---
           #SELECT MAX(price) INTO l_price FROM p120_tmp
            OPEN oeb01_1
            FETCH oeb01_1 INTO l_oeb01,l_oeb03,l_price
           #MOD-B10130---modify---end---
         ELSE
            IF tm.choice2 ='2' THEN
              #MOD-B10130---modify---start---
              #SELECT MIN(price) INTO l_price FROM p120_tmp
               OPEN oeb01_2
               FETCH oeb01_2 INTO l_oeb01,l_oeb03,l_price
              #MOD-B10130---modify---end---
            END IF 
         END IF 
         DELETE FROM p120_tmp
        #MOD-AA0155---add---end---
         IF g_success = 'N' THEN RETURN END IF
         IF l_price IS NULL THEN LET l_price = 0 END IF
         IF (l_price <= 0) AND (g_cmz.cmz17 IS NULL OR g_cmz.cmz17 = 'Y') AND g_ccc.azf06 != '3' THEN #FUN-930100 No:CHI-BC0007 add azf06
             #取得成本單價
              LET l_price = g_ccc23
              LET l_oeb01 = 'CCC-999999999'
              LET l_oeb03 = NULL
              IF l_price IS NULL THEN LET l_price = 0 END IF
              IF l_price <= 0 THEN
                 #FUN-980117--begin--add--
                 #若成品無ccc23,則抓離最近那期的cca23
                 LET l_sql = "SELECT cca23 FROM cca_file ",
                             " WHERE cca01 = '",p_ima01,"'",
                             " ORDER BY cca02,cca03 DESC" 
                 PREPARE p120_cca_p FROM l_sql
                 DECLARE p120_cca_cs CURSOR FOR p120_cca_p
                 FOREACH p120_cca_cs INTO l_price
                    IF l_price IS NOT NULL THEN
                       LET l_oeb01 = 'CCA-999999999'
                       LET l_oeb03 = NULL
                       EXIT FOREACH
                    END IF
                END FOREACH
#FUN-B30173 ---------------------------Begin---------------------------------------
                #無法抓到單價,請查核..!
#                 CALL p120_error('ima01',p_ima01,'l_price','axm-333',1) #CHI-970034
#                 RETURN
#FUN-B30173 ---------------------------End-----------------------------------------
              END IF
          END IF
#FUN-B30173 ---------------------Begin-------------------------
          IF (l_price <= 0) THEN
             SELECT azf06 INTO l_azf06 FROM ima_file LEFT OUTER JOIN azf_file ON (azf01=ima12 AND  azf02='G')
              WHERE ima01=p_ima01
             IF l_azf06 MATCHES '[01]' THEN LET p_cmd='0' END IF
             IF l_azf06 MATCHES '[2]'  THEN LET p_cmd='2' END IF
             IF l_azf06 MATCHES '[3]'  THEN LET p_cmd='3' END IF 
           #無法抓到單價,請查核..!           
             CASE p_cmd
                WHEN '0'  #成品
                 LET l_msg=cl_getmsg('aco-047',g_lang)
                WHEN '2'  #半成品
                 LET l_msg=cl_getmsg('aco-072',g_lang)      
                WHEN '3'  #原料
                 LET l_msg=cl_getmsg('mfg3228',g_lang)      
             END CASE
             CALL p120_error(l_msg,p_ima01,'l_price','axm-333',1)
             RETURN
          END IF 
#FUN-B30173 ---------------------End---------------------------
      END IF
   END IF
#FUN-B30212 mark (S) #在i311(理取市價的時候已經處理過 
  #取銷售費用率
 #  LET g_cma.cma32 = 0
 #  IF p_cmd = '2' THEN
 #     SELECT ima06,ima09,ima10,ima11,ima12,ima131
 #       INTO g_ccc.ima06,g_ccc.ima09,g_ccc.ima10,g_ccc.ima11,
 #            g_ccc.ima12,g_ccc.ima131
 #       FROM ima_file
 #      WHERE ima01 = p_ima01
 #  END IF
 #  CASE tm.cme06
 #       WHEN '1'  LET l_cme03 = g_ccc.ima06
 #       WHEN '2'  LET l_cme03 = g_ccc.ima09
 #       WHEN '3'  LET l_cme03 = g_ccc.ima10
 #       WHEN '4'  LET l_cme03 = g_ccc.ima11
 #       WHEN '5'  LET l_cme03 = g_ccc.ima12
 #       WHEN '6'  LET l_cme03 = g_ccc.ima131
 #  END CASE
 #  IF tm.cme06='6' THEN
 #    SELECT cme04 INTO g_cma.cma32
 #      FROM cme_file
 #     WHERE cme01 = tm.yy
 #       AND cme02 = tm.mm
 #       AND cme06 = tm.cme06
 #       AND cme031= l_cme03
 #  ELSE
 #    SELECT cme04 INTO g_cma.cma32
 #      FROM cme_file
 #     WHERE cme01 = tm.yy
 #       AND cme02 = tm.mm
 #       AND cme06 = tm.cme06
 #       AND cme03= l_cme03
 #  END IF
 #  IF SQLCA.SQLCODE THEN
 #     SELECT cme04 INTO g_cma.cma32
 #       FROM cme_file
 #      WHERE cme01 = tm.yy
 #        AND cme02 = tm.mm
 #        AND cme06 = tm.cme06
 #        AND (cme03 = 'ALL' OR cme031='ALL')
 #     IF SQLCA.SQLCODE THEN
 #        SELECT cme04 INTO g_cma.cma32
 #          FROM cme_file
 #         WHERE cme01 = tm.yy
 #           AND cme02 = tm.mm
 #           AND cme06 = '1'
 #           AND cme03 = 'ALL'
 #        IF SQLCA.SQLCODE THEN
 #          #未設定銷售費用率(axci310)
 #          #CALL s_errmsg('ima01',p_ima01,'sel cme04','axc-777',1)    #CHI-970034
 #           CALL p120_error('ima01',p_ima01,'sel cme04','axc-777',1)  #CHI-970034
 #          #LET g_success = 'N'
 #           RETURN
 #        END IF
 #     END IF
 #  END IF
 #FUN-B30212 mark (E)
   IF g_cma.cma32 IS NULL THEN LET g_cma.cma32 = 0 END IF
   #取平均值
   IF (tm.choice2 ='3' AND l_avg_cnt > 0) THEN
      IF l_tot_qty > 0 THEN
         LET l_price = l_tot_amt / l_tot_qty
      END IF
   END IF
   
   CALL cl_getmsg('axc-008',g_lang) RETURNING g_msg
   CALL FGL_SETENV("DBDATE","Y4MD/")
   IF l_cma271 = '1899/12/31' THEN 
      LET l_cma271 = NULL 
   END IF  
   CALL FGL_SETENV("DBDATE",g_date)
   IF tm.choice2 ='3' THEN
     #LET g_cma.cma26  = cl_digcut(l_price,g_azi03)           #MOD-C30068 mark
      LET g_cma.cma26  = cl_digcut(l_price,g_ccz.ccz26)       #MOD-C30068 add
      #取成本價不可再扣銷售費用
      IF l_oeb01 = 'CCC-999999999' OR l_oeb01 = 'CCA-999999999' THEN   #MOD-B90277 add OR l_oeb01 = 'CCA-999999999'
         LET g_cma.cma25  = l_price
        #LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_azi03))         #MOD-C30068 mark
         LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_ccz.ccz26)     #MOD-C30068 add
         LET g_cma.cma27  = l_oeb01
      ELSE
         LET g_cma.cma25  = l_price * (1-(g_cma.cma32/100))
        #LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_azi03))         #MOD-C30068 mark
         LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_ccz.ccz26)     #MOD-C30068 add
         LET g_cma.cma27  = g_msg
	  END IF  #CHI-980009
      LET g_cma.cma28  = 0
      LET g_cma.cma271 = NULL  #取平均值無法取得單一單據日期
   ELSE                
     #LET g_cma.cma26  = cl_digcut(l_price,g_azi03)           #MOD-C30068 mark
      LET g_cma.cma26  = cl_digcut(l_price,g_ccz.ccz26)       #MOD-C30068 add
      IF l_oeb01 = 'CCC-999999999' OR l_oeb01 = 'CCA-999999999' THEN   #MOD-B90277 add OR l_oeb01 = 'CCA-999999999'
         LET g_cma.cma25 = l_price
      ELSE
         LET g_cma.cma25  = l_price * (1-(g_cma.cma32/100))
      END IF  #CHI-980009
     #LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_azi03)       #MOD-C30068 mark
      LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_ccz.ccz26)   #MOD-C30068 add
      LET g_cma.cma27  = l_oeb01
      LET g_cma.cma28  = l_oeb03
      LET g_cma.cma271 = l_cma271  #FUN-930100 add
    END IF     #FUN-930100
END FUNCTION
 
#====================================
# 半成品：計算淨變現單價
#====================================
FUNCTION p150_p1_2()
   DEFINE l_sql       STRING,
          l_ord       LIKE type_file.chr30,
          i           LIKE type_file.num5
   DEFINE l_mark_price  LIKE cmf_file.cmf05    #FUN-930100 add
   DEFINE l_flag        LIKE type_file.num5    #FUN-930100 add
 
   LET g_cma.cma26 = g_ccc.cma12
   CASE tm.choice3
     WHEN '1'  CALL p120_back_1()
     WHEN '2'  CALL p120_back_2(g_ccc.ccc01)
     OTHERWISE CALL p120_back_1()
   END CASE
 
   #FUN-B30212:_get_0(中已處理過一次,這裡需要再跑一次,因為有可能有逆推成品價,但半成品自己又設了人工市價,此時還是要以人工市價為準 
   #如果有設人工市價,則cma26改抓人工市價
   CALL p120_get_i311(g_ccc.ccc01) RETURNING l_flag,l_mark_price
   IF l_flag THEN
      LET g_cma.cma26  = l_mark_price
      LET g_cma.cma25  = l_mark_price * (1-(g_cma.cma32/100))
     #LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_azi03)         #MOD-C30068 mark
      LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_ccz.ccz26)     #MOD-C30068 add      
      LET g_cma.cma27  = 'MARKET'  #CHI-970067
      LET g_cma.cma28  = NULL      #CHI-970067
   END IF
   CALL FGL_SETENV("DBDATE","Y4MD/")
   IF g_cma.cma271 = '1899/12/31' THEN 
      LET g_cma.cma271 = NULL 
   END IF   
   CALL FGL_SETENV("DBDATE",g_date)
 
   UPDATE cma_file 
      SET cma25  = g_cma.cma25,
          cma26  = g_cma.cma26,
          cma27  = g_cma.cma27,
          cma271 = g_cma.cma271, #FUN-930100 
          cma28  = g_cma.cma28,
          cma29  = g_cma.cma29,
          cma32  = g_cma.cma32
    WHERE cma01  = g_ccc.ccc01
      AND cma021 = tm.yy
      AND cma022 = tm.mm
      AND cma07  = g_ccc.ccc07  #CHI-9C0025
      AND cma08  = g_ccc.ccc08  #CHI-9C0025
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     #資料新增失敗
      CALL p120_error('cma01',g_ccc.ccc01,'ins cma','9050',1)  #CHI-970034
      LET g_success = 'N'
      RETURN
   ELSE
      IF g_bgjob = 'N' THEN
      END IF
   END IF
END FUNCTION
 
#====================================
# 展BOM取主件料號
#====================================
#FUNCTION p150_bom(p_level,p_key)                 #MOD-B30672 mark
FUNCTION p150_bom(p_level,p_key,p_qpa)            #MOD-B30672 add
   DEFINE p_level       LIKE type_file.num5,
          p_key         LIKE bma_file.bma01,    #元件料件編號
          l_ac,i        LIKE type_file.num5,
         #arrno         LIKE type_file.num5,    #BUFFER SIZE (可存筆數) #MOD-A30174 mark
          b_seq         LIKE bmb_file.bmb02,    #滿時,重新讀單身之起始序號
          sr            DYNAMIC ARRAY OF RECORD #每階存放資料
              bmb01     LIKE bmb_file.bmb01,    #主件料號
              bmb03     LIKE bmb_file.bmb03,    #元件料件
              qpa       LIKE bmb_file.bmb06,    #MOD-B30672 add
              ima903    LIKE ima_file.ima903    #FUN-930100 
                        END RECORD,
          l_cnt         LIKE type_file.num10,
          lp_qty        LIKE type_file.num20_6,              #當月生產入庫量
          lo_qty        LIKE type_file.num20_6,              #當月出貨量
          l_cmd         LIKE type_file.chr1000
DEFINE    l_ima903      LIKE ima_file.ima903       #FUN-930075
DEFINE    l_bmm03       LIKE bmm_file.bmm03        #FUN-930075
DEFINE    l_sql1        STRING                     #FUN-970103
DEFINE    p_qpa         LIKE bmb_file.bmb06        #MOD-B30672 add
DEFINE    l_qpa         LIKE bmb_file.bmb06        #MOD-B30672 add
DEFINE    l_bmb06       LIKE bmb_file.bmb06        #MOD-B30672 add
DEFINE    l_bmb07       LIKE bmb_file.bmb07        #MOD-B30672 add
DEFINE    l_bmm06       LIKE bmm_file.bmm06        #MOD-B30672 add
DEFINE    l_ima25       LIKE ima_file.ima25        #No:CHI-B60002 add
DEFINE    l_ima55       LIKE ima_file.ima25        #No:CHI-B60002 add
DEFINE    l_ima55_fac   LIKE ima_file.ima55_fac    #No:CHI-B60002 add
DEFINE    l_bmb10_fac   LIKE bmb_file.bmb10_fac    #No:CHI-B60002 add
DEFINE    l_flag        LIKE type_file.chr1        #No:CHI-B60002 add

   IF p_level > 25 THEN
     #階數超過25階,結構建立可能錯,請先執行偵錯作業
      CALL p120_error('p_key',p_key,'sel bom','mfg2733',1)   #CHI-970034
      LET g_success = 'N'
      RETURN
   END IF
   LET p_level = p_level + 1
   IF p_level = 1 THEN
      INITIALIZE sr[1].* TO NULL
      LET sr[1].bmb03 = p_key
   END IF
   #CHI-C80002---begin
   LET l_cmd = "SELECT bmm03,bmm06 FROM bmm_file ",
               " WHERE bmm01 = ? ",
               "   AND bmm05 = 'Y' "
   PREPARE p150_bom_bmm03_p1 FROM l_cmd             
   DECLARE p150_bom_bmm03 CURSOR FOR p150_bom_bmm03_p1

   LET l_sql1 = "SELECT SUM(tlf10*tlf60)  ",
                "  FROM tlf_file ",
                " WHERE tlf01 = ? ",
                "   AND tlfcost = '",g_ccc.ccc08,"' ",
                "   AND tlf06 BETWEEN '",g_qbdate,"' AND '",g_qedate,"' ",
                "   AND NOT EXISTS(SELECT 1 FROM cmw_file WHERE cmw01 = tlf021) "
   LET l_sql1 = l_sql1 ,g_sql2
   PREPARE p120_tlf_pre FROM l_sql1                                                                                                     
   DECLARE p120_tlf_cs CURSOR FOR p120_tlf_Pre  
   #CHI-C80002---end
   #LET arrno = 600 #MOD-A30174 mark
   WHILE TRUE
      LET l_cmd = "SELECT bmb01,bmb03,'',ima903,bmb06,bmb07",  #FUN-930100   #MOD-B30672 add '',bmb06,bmb07
                  " ,ima25,ima55,bmb10_fac ",                                #No:CHI-B60002 add
                  "  FROM bmb_file,ima_file", #FUN-930100 #FUN-970090  #FUN-980088
                  " WHERE bmb03='", p_key,"' ",
                  "   AND ima01=bmb01",      #FUN-930100
                  "   AND bmb29=",g_nvl_str,"(ima910,' ')", #CHI-980053
                  "   AND (bmb04 <='", tm.bdate, "' OR bmb04 IS NULL)",
                  "   AND (bmb05 > '", tm.bdate, "' OR bmb05 IS NULL)",
                  "   AND imaacti = 'Y' ",     #MOD-C10167 add
                  "   AND bmb14 != '2' ",      #MOD-C40074 add
                  " ORDER BY bmb01"
      PREPARE p150_bom_p1 FROM l_cmd
      IF SQLCA.sqlcode THEN
         CALL p120_error('p_key',p_key,'sel bmb',SQLCA.sqlcode,1)   #CHI-970034
         LET g_success = 'N'
         RETURN
      END IF
      DECLARE p150_bom_cs1 CURSOR for p150_bom_p1
      LET l_ac = 1
      FOREACH p150_bom_cs1 INTO sr[l_ac].*,l_bmb06,l_bmb07,l_ima25,l_ima55,l_bmb10_fac        # 先將BOM單身存入BUFFER   #MOD-B30672 add l_bmb06,l_bmb07 #No:CHI-B60002 add ima25,ima55
         LET l_qpa = p_qpa * l_bmb06 / l_bmb07  #不考慮損耗率     #MOD-B30672 add
         LET sr[l_ac].qpa = l_qpa                                 #MOD-B30672 add
        #-------------------No:CHI-B60002 add
         IF cl_null (l_bmb10_fac) THEN LET l_bmb10_fac = 1 END IF
            LET sr[l_ac].qpa = sr[l_ac].qpa * l_bmb10_fac  #考慮半成品/元件的發料單位與庫存單位換算率

         IF l_ima25 != l_ima55 THEN
            CALL s_umfchk(sr[l_ac].bmb01,l_ima25,l_ima55) RETURNING l_flag,l_ima55_fac
            IF l_flag = '1' THEN
               LET l_ima55_fac = 1
            END IF
            LET sr[l_ac].qpa = sr[l_ac].qpa * l_ima55_fac   #考慮成品/半成品的生產單位與庫存單位換算率
         END IF
        #-------------------No:CHI-B60002 end
         IF g_sma.sma104 = 'Y' AND sr[l_ac].ima903 = 'Y' THEN #FUN-930100
            #CHI-C80002---begin mark
            #DECLARE p150_bom_bmm03 CURSOR FOR
            # SELECT bmm03,bmm06 FROM bmm_file             #MOD-B30672 add bmm06
            #  WHERE bmm01 = sr[l_ac].bmb01
            #    AND bmm05 = 'Y'
            #FOREACH p150_bom_bmm03 INTO l_bmm03,l_bmm06   #MOD-B30672 add l_bmm06
            #CHI-C80002---end
            FOREACH p150_bom_bmm03 USING sr[l_ac].bmb01 INTO l_bmm03,l_bmm06  #CHI-C80002
                LET l_ac = l_ac + 1
                LET sr[l_ac].bmb01=l_bmm03
                IF g_ccz.ccz13 = '2' THEN  #CHI-CC0006
                   LET sr[l_ac].qpa = l_qpa * (l_bmm06/100)  #MOD-B30672 add
                ELSE    #CHI-CC0006
                   LET sr[l_ac].qpa = l_qpa  #CHI-CC0006
                END IF  #CHI-CC0006
            END FOREACH
         END IF
         LET l_ac = l_ac + 1                         #但BUFFER不宜太大
         #IF l_ac >= arrno THEN EXIT FOREACH END IF  #MOD-A30174 mark
      END FOREACH
      LET l_cmd= "SELECT COUNT(*) ",
                 "  FROM bmb_file",
                 " WHERE bmb03= ? ",
                 "   AND bmb14 != '2' ",          #MOD-C40074 add
                 "   AND (bmb04 <='", tm.bdate,"' OR bmb04 IS NULL) ",
                 "   AND (bmb05 > '", tm.bdate,"' OR bmb05 IS NULL)"
      PREPARE p150_bom_p2 FROM l_cmd
      IF SQLCA.sqlcode THEN
         CALL p120_error('p_key',p_key,'bom_p2',SQLCA.sqlcode,1)  #CHI-970034
         LET g_success = 'N'
         RETURN
      END IF
      DECLARE p150_bom_cs2 CURSOR for p150_bom_p2
      FOR i = 1 TO l_ac-1                  # 讀BUFFER傳給REPORT
         LET l_cnt = 0
         OPEN p150_bom_cs2 USING sr[i].bmb01
         FETCH p150_bom_cs2 INTO l_cnt
         IF l_cnt <= 0 THEN
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM cmh_file
             WHERE cmh01 = tm.yy
               AND cmh02 = tm.mm
               AND cmh03 = g_ccc.ccc01  #CHI-940029
               AND cmh04 = sr[i].bmb01  #CHI-940029
               AND cmh071= g_ccc.ccc07  #CHI-9C0025
               AND cmh081= g_ccc.ccc08  #CHI-9C0025
            IF g_cnt IS NULL THEN LET g_cnt = 0 END IF
            IF g_cnt = 0 THEN
              #當月生產入庫量
               LET lp_qty = 0
               #CHI-C80002---begin mark
               #LET l_sql1 = "SELECT SUM(tlf10*tlf60) ",  #No:CHI-B60002 add *tlf60
               #             "  FROM tlf_file ",
               #             " WHERE tlf01 = '",sr[i].bmb01,"' ",
               #             "   AND tlfcost = '",g_ccc.ccc08,"' ", #CHI-9C0025
               #            #"   AND tlf07 BETWEEN '",g_qbdate,"' AND '",g_qedate,"' ",  #FUN-930100   #MOD-C40074 mark
               #             "   AND tlf06 BETWEEN '",g_qbdate,"' AND '",g_qedate,"' ",  #MOD-C40074 add
               #             #"   AND tlf021 NOT IN (select cmw01 FROM cmw_file) "  #CHI-C80002
               #             "   AND NOT EXISTS(select 1 FROM cmw_file WHERE cmw01 = tlf021) "  #CHI-C80002
               #LET l_sql1 = l_sql1 ,g_sql2
               #PREPARE p120_tlf_pre FROM l_sql1                                                                                                     
               #DECLARE p120_tlf_cs CURSOR FOR p120_tlf_Pre                                                                                             
               #OPEN p120_tlf_cs 
               #CHI-C80002---end
               OPEN p120_tlf_cs USING sr[i].bmb01  #CHI-C80002
               FETCH p120_tlf_cs INTO lp_qty
               IF lp_qty IS NULL THEN LET lp_qty = 0 END IF
              #當月出貨量
               LET lo_qty = 0
               SELECT SUM(tlf10*tlf60*tlf907) INTO lo_qty FROM tlf_file   #No:CHI-B60002 add *tlf60 #MOD-C20175 add *tlf907
                 LEFT OUTER JOIN oga_file ON tlf026 = oga01               #MOD-C40074 add
                WHERE tlf01 = sr[i].bmb01
                  AND tlf13 IN ('axmt620','axmt650')
                  AND tlfcost = g_ccc.ccc08  #TQC-A10116
                 #AND tlf07 BETWEEN g_qbdate AND g_qedate  #FUN-930100    #MOD-C40074 mark
                  AND tlf06 BETWEEN g_qbdate AND g_qedate  #MOD-C40074 add
                  AND oga65 != 'Y'                         #MOD-C40074 add
               IF lo_qty IS NULL THEN LET lo_qty = 0 END IF
               INSERT INTO cmh_file (cmh01,cmh02,cmh03,cmh031,cmh04,cmh041,cmh05,cmh06,
                                     cmh07,cmh08,cmh071,cmh081,         #CHI-9C0025
                                     cmhdate,cmhgrup,cmhmodu,cmhuser,cmhoriu,cmhorig,cmhlegal)    #FUN-A50075
#                             VALUES(tm.yy,tm.mm,g_ccc.ccc01,1,sr[i].bmb01,  #CHI-940029    #MOD-B30672 mark
                              VALUES(tm.yy,tm.mm,g_ccc.ccc01,sr[i].qpa,sr[i].bmb01,         #MOD-B30672 add
                                     g_cma.cma25,lp_qty,lo_qty,g_qbdate,g_qedate,
                                     g_ccc.ccc07,g_ccc.ccc08,           #CHI-9C0025
                                     g_today,g_grup,'',g_user, g_user, g_grup,g_legal)      #No.FUN-980030 10/01/04  insert columns oriu, orig   #FUN-A50075 add legal
               CASE SQLCA.sqlcode
                  WHEN "-239"
                     EXIT CASE   #有重復原件料號時只抓一次
                  WHEN "-268"    #CHI-C30115 -239重複錯誤會變成-268
                     EXIT CASE
                  WHEN "0"
                     EXIT CASE
                  OTHERWISE
                     LET g_showmsg= tm.yy,"/",tm.mm
                     CALL p120_error('cmh01,cmh02',g_showmsg,'ins cmh',SQLCA.sqlcode,1)  #CHI-970034
                     LET g_success = 'N'
                     RETURN
               END CASE
            END IF
         ELSE
            CALL p150_bom(p_level,sr[i].bmb01,sr[i].qpa)    #MOD-B30672 add sr[i].qpa
         END IF
      END FOR
     #IF l_ac < arrno OR l_ac=1 THEN   # BOM單身已讀完   #MOD-A30174 mark
     #IF l_ac=1 THEN                   # BOM單身已讀完   #MOD-A30174  #MOD-A60060 mark
         EXIT WHILE
      #ELSE                            #MOD-A30174 mark
      #   LET b_seq = sr[arrno].bmb03  #MOD-A30174 mark
     #END IF                                                          #MOD-A60060 mark
   END WHILE
END FUNCTION
 
#====================================
# 原料：計算淨變現單價
#====================================
FUNCTION p150_p1_3()
   DEFINE l_rvv35       LIKE rvv_file.rvv35,        #入庫單位
          l_price       LIKE cma_file.cma25,        #單價
          l_apb01       LIKE apb_file.apb01,        #單號
          l_apb02       LIKE apb_file.apb02,        #項次
          l_sql         STRING,
          l_flag        LIKE type_file.num5,
          l_fac         LIKE ima_file.ima31_fac,    ##單位轉換率
          l_ord       LIKE type_file.chr30,
          i           LIKE type_file.num5
   DEFINE l_pmn07     LIKE pmn_file.pmn07           #CHI-910033
   DEFINE l_pmn86     LIKE pmn_file.pmn86
   DEFINE l_pmn121    LIKE pmn_file.pmn121
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_rvv86     LIKE rvv_file.rvv86
   DEFINE l_rvv35_fac LIKE rvv_file.rvv35_fac
   DEFINE l_avg_cnt     LIKE type_file.num10  #FUN-930100 add
   DEFINE l_cma271      LIKE cma_file.cma271  #FUN-930100 add
   DEFINE l_mark_price  LIKE cmf_file.cmf05   #FUN-930100 add
   DEFINE l_cmg_flag    LIKE type_file.num5   #FUN-950058 #FALSE - cmg_file已被新增過, TRUE - cmg_file未被新增過 
                                              #(若第一筆新增出現-239,則表示此料已存在cmg資料,不需再新增第二筆以後的資料,因為第二筆以後也會是-239,以節省效率)
   DEFINE l_apb10       LIKE apb_file.apb10   #CHI-970034
   DEFINE l_apb09       LIKE apb_file.apb09   #CHI-970034
   DEFINE l_apb28       LIKE apb_file.apb28   #CHI-970034
   DEFINE l_tot_qty     LIKE omb_file.omb12   #CHI-970034
   DEFINE l_tot_amt     LIKE omb_file.omb16   #CHI-970034
   DEFINE l_msg         LIKE ze_file.ze03     #FUN-B30173
 
   LET g_cma.cma26 = g_ccc.cma11
   LET g_cma.cma32 = 0
 
  #IF tm.choice='2' THEN   #FUN-AB0036
   IF (tm.choice='2') OR (tm.choice='1' AND tm.cmz28='Y') THEN  #FUN-AB0036 
      CASE tm.choice3
        WHEN '1'  CALL p120_back_1()
        WHEN '2'  CALL p120_back_2(g_ccc.ccc01)
        OTHERWISE CALL p120_back_1()
      END CASE
   END IF

   #FUN-AB0036(S)  
   IF (tm.choice='1' AND tm.cmz28='Y') THEN
      LET g_cma.cma25 = 0  #原料NRV不用逆推成品價
   END IF
   #FUN-AB0036(E)
   #FUN-B30212 (S) 
   #FUN-B30212:_get_0(中已處理過一次,這裡需要再跑一次,因為有可能有逆推成品價,但原料自己又設了人工市價,此時還是要以人工市價為準
   #如果有設人工市價,則cma26改抓人工市價
   CALL p120_get_i311(g_ccc.ccc01) RETURNING l_flag,l_mark_price
   IF l_flag THEN
      LET g_cma.cma26  = l_mark_price
      LET g_cma.cma25  = l_mark_price * (1-(g_cma.cma32/100))
     #LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_azi03)         #MOD-C30068 mark
      LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_ccz.ccz26)     #MOD-C30068 add      
      LET g_cma.cma27  = 'MARKET'  #CHI-970067
      LET g_cma.cma28  = NULL      #CHI-970067
   END IF
   #FUN-B30212 (E)
   IF ((tm.choice='2' AND g_cma.cma25=0) OR             #FUN-B30212
      tm.choice='1') AND (NOT l_flag) THEN              #FUN-B30212
     SELECT ima25 INTO l_ima25    #CHI-970034
       FROM ima_file WHERE ima01 = g_ccc.ccc01  #CHI-970034
     LET l_sql =
        "SELECT apb01,apb02,apb08,rvv35,rvv86,apa02,",   #CHI-920005 add rvv86  #FUN-930100 add apa02
        "       apb09,apb28,apb10 ",  #CHI-970034
        "  FROM apa_file,apb_file,rvv_file",
        " WHERE apa01 = apb01 ",
        "  AND apb12 = '",g_ccc.ccc01,"'",
        "  AND apa00 = '11'  ",
        "  AND apb29 = '1' ",  #MOD-D10183
        "  AND apa41 = 'Y'   ",         #已確認 
        "  AND apa42 = 'N'   ",         #未作廢
        "  AND apb08 > 0     ",
        "  AND apb21 = rvv01 ",
        "  AND apb22 = rvv02 " 
     
     IF tm.choice2 = '3' THEN
        LET l_sql = l_sql ,"   AND apa02 BETWEEN '",g_agv_bdate,"' AND '",g_agv_edate,"' "      
     ELSE
        LET l_sql = l_sql ,"   AND apa02 BETWEEN '",tm.cmz70,"' AND '",a_edate,"'  " #MOD-960135  
     END IF
     
     LET l_sql = l_sql ," ORDER BY apa02 DESC,apb08"
     
     LET l_avg_cnt = 0
     LET l_tot_amt = 0     #CHI-970034
     LET l_tot_qty = 0     #CHI-970034
     LET l_cmg_flag = TRUE #FUN-950058
     PREPARE p150_k3_p1 FROM l_sql
     DECLARE p150_k3_cs1 CURSOR FOR p150_k3_p1
     FOREACH p150_k3_cs1 INTO l_apb01,l_apb02,l_price,l_rvv35,l_rvv86,l_cma271,   #FUN-930100 add L_CMA271 #CHI-920005
                              l_apb09,l_apb28,l_apb10   #CHI-970034
        IF SQLCA.SQLCODE THEN
           CALL p120_error('ccc01',g_ccc.ccc01,'k3_cs1',SQLCA.sqlcode,1)  #CHI-970034
           LET g_success = 'N'
           RETURN
        END IF
        LET l_cnt = 0 
        CALL s_umfchk(g_ccc.ccc01,l_rvv86,l_ima25) RETURNING l_cnt,l_rvv35_fac
        IF l_cnt = 1 THEN
            LET g_showmsg= l_apb01,"/",l_apb02
            CALL p120_error('apb01,apb02',g_showmsg,'unit trans:','abm-731',1)  #CHI-970034
            LET l_rvv35_fac = 1     #TQC-940146
        END IF
        LET l_price = l_price / l_rvv35_fac    #TQC-940146
        IF cl_null(l_price) THEN LET l_price = 0 END IF
        IF l_price <=0 THEN CONTINUE FOREACH END IF  #FUN-950058
        LET l_avg_cnt = l_avg_cnt + 1
        IF tm.choice2 ='3' THEN
           IF l_cmg_flag THEN
              LET l_cnt = 0
              CALL s_umfchk(g_ccc.ccc01,l_apb28,l_ima25) RETURNING l_cnt,l_rvv35_fac
              IF l_cnt = 1 THEN
                 LET g_showmsg= l_apb01,"/",l_apb02
                 CALL p120_error('apb01,apb02',g_showmsg,'po-unit trans:','abm-731',1) #CHI-970034
                 LET l_rvv35_fac = 1
              END IF
              CALL p120_ins_cmg(l_apb01,l_apb02,g_ccc.ccc01,l_avg_cnt,l_apb10,l_cma271,'4',
                                l_apb09,l_apb28,l_rvv35_fac) RETURNING l_cmg_flag  #CHI-970034
           END IF
            LET l_tot_amt = l_tot_amt + l_apb10     #CHI-970034
            LET l_tot_qty = l_tot_qty + (l_apb09 * l_rvv35_fac) #CHI-970034
        ELSE
           EXIT FOREACH
        END IF
     END FOREACH
     IF l_price IS NULL THEN LET l_price = 0 END IF
    #取得單位換算率
     IF l_price <= 0 THEN
        LET l_price = 0
        LET l_sql = "SELECT pmn01,pmn02,pmn07,pmn86,pmm04,",  #CHI-910033 add pmn07#CHI-920005 add pmn86 #FUN-930100 add pmm04
                   #MOD-C30888 srt------
                   #"  CASE gec07 ",
                   #"       WHEN 'Y' THEN pmn31t/pmn09*pmm42 ", #FUN-950058
                   #"       ELSE pmn31/pmn09*pmm42 ", #FUN-950058
                   #"  END AS amt ,", #CHI-970034
                    "  pmn31/pmn09*pmm42 AS amt ,",
                   #MOD-C30888 end------
                   #"  pmn20,pmn07,pmn88 ", #CHI-970034         #MOD-A30007 mark
                    "  pmn20,pmn07,pmn88*pmm42 ", #CHI-970034   #MOD-A30007
                    "  FROM pmm_file LEFT OUTER JOIN gec_file ON pmm21 = gec01 AND gec011 = '1' ,pmn_file ",
                    " WHERE pmm01 = pmn01 ",
                    "   AND pmm18 = 'Y' ",    #已確認
                    "   AND pmn31 > 0 ",      #FUN-950058 單價不可為0
                    "   AND pmn04 = '", g_ccc.ccc01, "'"
        IF tm.choice2 = '3' THEN
           LET l_sql = l_sql ,"   AND pmm04 BETWEEN '",g_agv_bdate,"' AND '",g_agv_edate,"' "      
        ELSE
           LET l_sql = l_sql ,"   AND pmm04 BETWEEN '", tm.cmz70, "' AND '", a_edate, "'"
        END IF
        
        LET l_sql = l_sql , " ORDER BY pmm04 DESC, amt "
  
        LET l_avg_cnt = 0 #FUN-930100
        LET l_tot_amt = 0        #CHI-970034
        LET l_tot_qty = 0        #CHI-970034
        LET l_cmg_flag = TRUE #FUN-950058
  
        PREPARE p150_k3_p2 FROM l_sql
        DECLARE p150_k3_cs2 CURSOR FOR p150_k3_p2
        FOREACH p150_k3_cs2 INTO l_apb01,l_apb02,l_pmn07,l_pmn86,l_cma271,l_price,   #CHI-910033 #CHI-920005 #FUN-930100 add l_cma271
                                 l_apb09,l_apb28,l_apb10  #CHI-970034
           IF SQLCA.SQLCODE THEN
              CALL p120_error('ccc01',g_ccc.ccc01,'k3_cs2',SQLCA.sqlcode,1)  #CHI-970034
              LET g_success = 'N'
              RETURN
           END IF
           IF cl_null(l_price) THEN LET l_price = 0 END IF
           IF l_price <=0 THEN CONTINUE FOREACH END IF  #FUN-950058
           LET l_avg_cnt = l_avg_cnt + 1
           IF tm.choice2 ='3' THEN
              IF l_cmg_flag THEN
                 LET l_cnt = 0
                 CALL s_umfchk(g_ccc.ccc01,l_apb28,l_ima25) RETURNING l_cnt,l_rvv35_fac
                 IF l_cnt = 1 THEN
                    LET g_showmsg= l_apb01,"/",l_apb02
                    CALL p120_error('pmn01,pmn02',g_showmsg,'po-unit trans:','abm-731',1)   #CHI-970034
                    LET l_rvv35_fac = 1
                 END IF
                 CALL p120_ins_cmg(l_apb01,l_apb02,g_ccc.ccc01,l_avg_cnt,l_apb10,l_cma271,'5', #CHI-970034 l_price -> l_avg_cnt
                                   l_apb09,l_apb28,l_rvv35_fac) RETURNING l_cmg_flag  #CHI-970034
              END IF
               LET l_tot_amt = l_tot_amt + l_apb10    #CHI-970034
               LET l_tot_qty = l_tot_qty + (l_apb09 * l_rvv35_fac)    #CHI-970034
           ELSE
              EXIT FOREACH
           END IF
        END FOREACH
        IF l_price IS NULL THEN LET l_price = 0 END IF
         IF (l_price <= 0) AND (g_cmz.cmz17 IS NULL OR g_cmz.cmz17 = 'Y') THEN #FUN-930100
          #取得成本單價
           LET l_price = g_ccc.ccc23
           LET l_apb01 = 'CCC-999999999'
           LET l_apb02 = NULL
           IF l_price IS NULL THEN LET l_price = 0 END IF
#FUN-B30173 --------------------------Begin-------------------------------
#           IF l_price <= 0 THEN
#             #無法抓到單價,請查核..!
#              CALL p120_error('ccc01',g_ccc.ccc01,'price','axm-333',1)  #CHI-970034
#              RETURN
#           END IF
#FUN-B30173 --------------------------End--------------------------------
        END IF
#FUN-B30173 --------------------------Begin------------------------------
        IF (l_price <= 0) THEN
          #無法抓到單價,請查核..!           
           LET l_msg=cl_getmsg('mfg3228',g_lang)      
           CALL p120_error(l_msg,g_cma.cma01,'l_price','axm-333',1)
           RETURN
        END IF 
#FUN-B30173 --------------------------End--------------------------------
     END IF
     
     #取平均值   
     IF (tm.choice2 ='3' AND l_avg_cnt > 0) THEN
        IF l_tot_qty > 0 THEN
           LET l_price = l_tot_amt / l_tot_qty
        END IF
     END IF
     
     CALL cl_getmsg('axc-008',g_lang) RETURNING g_msg  
     CALL FGL_SETENV("DBDATE","Y4MD/")
     IF l_cma271 = '1899/12/31' THEN 
        LET l_cma271 = NULL 
     END IF   
     CALL FGL_SETENV("DBDATE",g_date)
     IF tm.choice2 ='3' THEN
       #LET g_cma.cma26  = cl_digcut(l_price,g_azi03)           #MOD-C30068 mark
        LET g_cma.cma26  = cl_digcut(l_price,g_ccz.ccz26)       #MOD-C30068 add
        LET g_cma.cma25  = l_price
       #LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_azi03)       #MOD-C30068 mark
        LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_ccz.ccz26)   #MOD-C30068 add
       #-------------No:MOD-B90275 add
       #LET g_cma.cma27  = g_msg
        IF l_apb01 = 'CCC-999999999' THEN
           LET g_cma.cma27  = l_apb01
        ELSE
           LET g_cma.cma27  = g_msg
        END IF                       
       #-------------No:MOD-B90275 end
        LET g_cma.cma28  = 0
        LET g_cma.cma271 = NULL  #取平均值無法取的單一單據日期
     ELSE                
       #LET g_cma.cma26 = cl_digcut(l_price,g_azi03)           #MOD-C30068 mark
        LET g_cma.cma26 = cl_digcut(l_price,g_ccz.ccz26)       #MOD-C30068 add
        LET g_cma.cma25 = l_price
       #LET g_cma.cma25 = cl_digcut(g_cma.cma25,g_azi03)       #MOD-C30068 mark
        LET g_cma.cma25 = cl_digcut(g_cma.cma25,g_ccz.ccz26)   #MOD-C30068 add
        LET g_cma.cma271= l_cma271    #FUN-930100
        LET g_cma.cma27 = l_apb01
        LET g_cma.cma28 = l_apb02
     END IF
   END IF
  #FUN-B30212 mark (S) 移到上面處理 
   #如果有設人工市價,則cma26改抓人工市價
  # CALL p120_get_i311(g_ccc.ccc01) RETURNING l_flag,l_mark_price
  # IF l_flag THEN
  #    LET g_cma.cma26  = l_mark_price
  #    LET g_cma.cma25  = l_mark_price * (1-(g_cma.cma32/100))
  #    LET g_cma.cma25  = cl_digcut(g_cma.cma25,g_azi03)      
  #    LET g_cma.cma27  = 'MARKET'  #CHI-970067
  #    LET g_cma.cma28  = NULL      #CHI-970067
  # END IF
  #FUN-B30212 mark (E)
   CALL FGL_SETENV("DBDATE","Y4MD/")
   IF g_cma.cma271 = '1899/12/31' THEN 
      LET g_cma.cma271 = NULL 
   END IF   
   CALL FGL_SETENV("DBDATE",g_date)
 
   UPDATE cma_file 
      SET cma24 = g_cma.cma24,
          cma25 = g_cma.cma25,
          cma26 = g_cma.cma26,
          cma27 = g_cma.cma27,
          cma271 = g_cma.cma271, #FUN-930100 
          cma28 = g_cma.cma28,
          cma29 = g_cma.cma29,
          cma32 = g_cma.cma32
    WHERE cma01 = g_ccc.ccc01
      AND cma021= tm.yy
      AND cma022= tm.mm
      AND cma07 = g_ccc.ccc07  #CHI-9C0025
      AND cma08 = g_ccc.ccc08  #CHI-9C0025
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     #資料新增失敗
      CALL p120_error('cma01',g_ccc.ccc01,'upd cma','9050',1)  #CHI-970034
      LET g_success = 'N'
      RETURN
   ELSE
      IF g_bgjob = 'N' THEN
      END IF
   END IF
END FUNCTION
 
FUNCTION p120_back_1()
DEFINE l_ord       LIKE type_file.chr30
DEFINE i           LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_put_cost  LIKE cma_file.cma25
DEFINE l_ccc01     LIKE ccc_file.ccc01
DEFINE l_ima09     LIKE ima_file.ima09
DEFINE l_ccc23     LIKE ccc_file.ccc23
DEFINE l_imk09     LIKE imk_file.imk09
DEFINE l_ima08     LIKE ima_file.ima08
DEFINE l_ima12    LIKE ima_file.ima12  #CHI-9C0025
DEFINE l_azf06    LIKE azf_file.azf06  #CHI-9C0025
DEFINE l_cmh031    LIKE cmh_file.cmh031     #MOD-B30672 add 
DEFINE l_flag      LIKE type_file.chr1      #MOD-C70151 add

    DELETE FROM cmh_file
     WHERE cmh01=tm.yy
       AND cmh02=tm.mm
       AND cmh03=g_ccc.ccc01
       AND cmh071= g_ccc.ccc07  #CHI-9C0025
       AND cmh081= g_ccc.ccc08  #CHI-9C0025
   CALL p150_bom(0,g_ccc.ccc01,1)     #MOD-B30672 add 1
   IF g_success = 'N' THEN RETURN END IF
   LET l_ord = ' '
   FOR i = 1 TO 3
      CASE tm.s[i,i]
           WHEN '1' LET l_ord = l_ord CLIPPED, 'cmh05 DESC,'
           WHEN '2' LET l_ord = l_ord CLIPPED, 'cmh06 DESC,'
           WHEN '3' LET l_ord = l_ord CLIPPED, 'cmh04,'
      END CASE
   END FOR
   LET g_cnt = LENGTH(l_ord CLIPPED)
   IF g_cnt IS NULL THEN LET g_cnt = 0 END IF
   LET l_ord = l_ord[1,g_cnt-1]
   LET l_sql = "SELECT cmh04,cmh031 FROM cmh_file ",   #MOD-B30672 add cmh031
               " WHERE cmh01 =",tm.yy,
               "   AND cmh02 =",tm.mm,
               "   AND cmh03 ='",g_ccc.ccc01,"' ",
               "   AND cmh071='",g_ccc.ccc07,"' ",  #CHI-9C0025
               "   AND cmh081='",g_ccc.ccc08,"' ",  #CHI-9C0025
               " ORDER BY ", l_ord CLIPPED
   PREPARE p150_k2_p1 FROM l_sql
   DECLARE p150_k2_cs1 CURSOR FOR p150_k2_p1
   OPEN p150_k2_cs1
   FETCH p150_k2_cs1 INTO g_cma.cma29,l_cmh031         #MOD-B30672 add l_cmh031
   IF SQLCA.SQLCODE THEN
      IF SQLCA.SQLCODE = 100 THEN
        #沒有可逆展的成品料號
        #CALL s_errmsg('ima01',g_ccc.ccc01,'k2_cs1','axc-999',1)    #CHI-970034
         CALL p120_error('ima01',g_ccc.ccc01,'k2_cs1','axc-999',1)  #CHI-970034
      ELSE
         CALL p120_error('ima01',g_ccc.ccc01,'k2_cs1',SQLCA.sqlcode,1)#CHI-970034
         LET g_success = 'N'
      END IF
     #CALL p150_p1_0_get(0,g_cma.cma01)            #FUN-B30173 
      CALL p150_p1_0_get(g_ccc.azf06,g_cma.cma01)  #FUN-B30173
   ELSE 
      SELECT cma25 INTO g_cma.cma25 FROM cma_file
       WHERE cma01 = g_cma.cma29
         AND cma021= tm.yy
         AND cma022= tm.mm
         AND cma07 = g_ccc.ccc07  #CHI-9C0025
         AND cma08 = g_ccc.ccc08  #CHI-9C0025
      #有逆推成品料號,但其無cma_file資料(ex:當成品為本月上市的新料時,
      #又當資料類別選"2有庫存成本資料"時,因新料不會有ccc_file資料,所以此時
      #不會有cma_file資料,此時要幫他新增cma_file)
      IF SQLCA.sqlcode =100 THEN 
         SELECT ima01,ima09,ccc23,0,ima08,ima12,azf06
           INTO l_ccc01,l_ima09,l_ccc23,l_imk09,l_ima08,l_ima12,l_azf06
           FROM ima_file 
           LEFT OUTER JOIN ccc_file ON (ccc01=ima01 AND ccc02= tm.yy  #MOD-CB0125 mod g_yy->tm.yy
            AND ccc03= tm.mm AND ccc07= g_ccc.ccc07 AND ccc08=g_ccc.ccc08)  #MOD-CB0125 mod g_mm->tm.mm
           LEFT OUTER JOIN azf_file ON (azf01=ima12 AND azf02='G')
           WHERE ima01=g_cma.cma29
             AND imaacti = 'Y'           #MOD-C10167 add
         IF l_ccc01 IS NOT NULL THEN        #MOD-D40113 add
           CALL p120_ins_cma_1(l_ccc01,l_ima09,l_ccc23,l_imk09,l_ima08,g_ccc.ccc08,l_ima12,l_azf06)
           CALL p150_p1_0('2', g_cma.cma29)
         END IF                             #MOD-D40113 add
      END IF
      IF cl_null(g_cma.cma25) THEN
         LET g_cma.cma25 = 0
      END IF
      LET l_flag = 'N'                                   #MOD-C70151 add
      #如果逆推成品沒卷算過單據單價才需要卷算
      IF g_cma.cma25 = 0 THEN
      #  CALL p150_p1_0_get(2,g_ccc.ccc01)  #FUN-980122  #FUN-B30173
         CALL p150_p1_0_get(g_ccc.azf06,g_ccc.ccc01)     #FUN-B30173
         LET l_flag = 'Y'                                #MOD-C70151 add
      ELSE
         SELECT ccc23 INTO g_ccc23 FROM ccc_file
          WHERE ccc01 = g_cma.cma29
            AND ccc02 = tm.yy
            AND ccc03 = tm.mm
            AND ccc07 = g_ccc.ccc07  #CHI-9C0025
            AND ccc08 = g_ccc.ccc08  #CHI-9C0025
         IF cl_null(g_ccc23) THEN LET g_ccc23 = 0 END IF
         #逆推成品取代料號時,cmh_file只需保留"代表料號"的資料。其余刪除(否則axcr154會顯示多筆)
         IF tm.choice3 = '1' THEN
            DELETE FROM cmh_file WHERE cmh01 = tm.yy 
                                   AND cmh02 = tm.mm
                                   AND cmh03 = g_ccc.ccc01 
                                   AND cmh04 <> g_cma.cma29
                                   AND cmh071= g_ccc.ccc07  #CHI-9C0025
                                   AND cmh081= g_ccc.ccc08  #CHI-9C0025
         END IF
      END IF
     IF g_success = 'N' THEN RETURN END IF
    #半成品/原料淨變現單價=成品淨變現單價-再投入成本                              #MOD-C10169 add
     IF cl_null(g_ccc.ccc23) THEN  #CHI-980003
        LET g_ccc.ccc23 = 0        #CHI-980003
     END IF                        #CHI-980003
#    LET l_put_cost=g_ccc23-g_ccc.ccc23                 #MOD-B30672 mark
     LET l_put_cost=g_ccc23-g_ccc.ccc23 * l_cmh031      #MOD-B30672
     IF l_put_cost > 0 THEN     #CHI-980020
        LET g_cma.cma25= g_cma.cma25 - l_put_cost
     END IF   #CHI-980020
#MOD-B30672 -- begin --
     IF l_cmh031 IS NULL OR l_cmh031 =0 THEN
        LET l_cmh031 = 1
     END IF
     IF l_flag = 'N' THEN     #MOD-C70151 add
        LET g_cma.cma25 = g_cma.cma25 / l_cmh031
     END IF                   #MOD-C70151 add
#MOD-B30672 -- end --
     #取得cma25后,將結果更新回cmh041
     IF tm.choice3 = '1' THEN
        UPDATE cmh_file SET cmh041 = g_cma.cma25
         WHERE cmh01 = tm.yy AND cmh02 = tm.mm
           AND cmh03 = g_ccc.ccc01
     END IF
   END IF 
END FUNCTION
 
FUNCTION p120_back_2(p_ccc01)   
   DEFINE l_cma29      LIKE cma_file.cma29
   DEFINE l_data_cnt   LIKE type_file.num10
   DEFINE l_cma25      LIKE cma_file.cma25
   DEFINE l_avg_price  LIKE cma_file.cma25 #平均成品之ccc23
   DEFINE l_net_price  LIKE cma_file.cma25 #平均成品之淨變現單價
   DEFINE l_tot_in_qty  LIKE type_file.num26_10   #總入庫數  #FUN-B30173
   DEFINE l_tot_out_qty LIKE type_file.num26_10   #總出庫數  #FUN-B30173
#  DEFINE l_tot_in_qty  LIKE tlf_file.tlf10   #總入庫數      #FUN-B30173
#  DEFINE l_tot_out_qty LIKE tlf_file.tlf10  #總出庫數       #FUN-B30173
   DEFINE l_put_cost   LIKE cma_file.cma25  #再投入成本
   DEFINE p_ccc01      LIKE ccc_file.ccc01
   DEFINE l_sql        STRING
   DEFINE l_cmh031     LIKE cmh_file.cmh031
   DEFINE l_cmh04      LIKE cmh_file.cmh04
   DEFINE l_cmh05      LIKE cmh_file.cmh05
   DEFINE l_cmh06      LIKE cmh_file.cmh06
   DEFINE l_ccc23      LIKE ccc_file.ccc23
   DEFINE l_ccc23_in      LIKE ccc_file.ccc23
   DEFINE l_cma25_in      LIKE cma_file.cma25
   DEFINE l_avg_price_in  LIKE cma_file.cma25
   DEFINE l_net_price_in  LIKE cma_file.cma25
   DEFINE l_ccc23_out     LIKE ccc_file.ccc23
   DEFINE l_cma25_out     LIKE cma_file.cma25
   DEFINE l_avg_price_out LIKE cma_file.cma25
   DEFINE l_net_price_out LIKE cma_file.cma25
   DEFINE l_ccc01     LIKE ccc_file.ccc01
   DEFINE l_ima09     LIKE ima_file.ima09
   DEFINE l_ccc23_a   LIKE ccc_file.ccc23
   DEFINE l_imk09     LIKE imk_file.imk09
   DEFINE l_ima08     LIKE ima_file.ima08
   DEFINE l_ima12    LIKE ima_file.ima12  #CHI-9C0025
   DEFINE l_azf06    LIKE azf_file.azf06  #CHI-9C0025
   DEFINE l_qpa_in    LIKE type_file.num26_10 #FUN-B30218
   DEFINE l_qpa_out   LIKE type_file.num26_10 #FUN-B30218
   DEFINE l_qpa_tot   LIKE type_file.num26_10 #FUN-B30218   
   DEFINE l_qpa_in_qty  LIKE type_file.num26_10  #No:MOD-B40049 add
   DEFINE l_qpa_out_qty LIKE type_file.num26_10  #No:MOD-B40049 add
 
   DELETE FROM cmh_file WHERE cmh01=tm.yy AND cmh02=tm.mm AND cmh03=p_ccc01
                          AND cmh071= g_ccc.ccc07 #TQC-A10116
                          AND cmh081= g_ccc.ccc08 #TQC-A10116
   CALL p150_bom_2(0,g_ccc.ccc01,1)
 
   SELECT COUNT(*) INTO l_data_cnt FROM cmh_file
    WHERE cmh01=tm.yy AND cmh02=tm.mm AND cmh03=p_ccc01
      AND cmh071= g_ccc.ccc07  #CHI-9C0025
      AND cmh081= g_ccc.ccc08  #CHI-9C0025
   IF l_data_cnt > 0 THEN
      SELECT SUM(cmh031*cmh05),SUM(cmh031*cmh06) INTO
             l_tot_in_qty,l_tot_out_qty FROM cmh_file
             WHERE cmh01=tm.yy AND cmh02=tm.mm AND cmh03=p_ccc01
               AND cmh071= g_ccc.ccc07  #CHI-9C0025
               AND cmh081= g_ccc.ccc08  #CHI-9C0025
     #------------No:MOD-B40049 modify
     #SELECT SUM(cmh031*cmh05),SUM(cmh031*cmh06) INTO
     #       l_tot_in_qty,l_tot_out_qty FROM cmh_file
     #       WHERE cmh01=tm.yy AND cmh02=tm.mm AND cmh03=p_ccc01
     #         AND cmh071= g_ccc.ccc07  #CHI-9C0025
     #         AND cmh081= g_ccc.ccc08  #CHI-9C0025
      SELECT SUM(cmh031*cmh05),SUM(cmh031*cmh06),SUM(cmh05),SUM(cmh06) INTO
             l_tot_in_qty,l_tot_out_qty,l_qpa_in_qty,l_qpa_out_qty FROM cmh_file
             WHERE cmh01=tm.yy AND cmh02=tm.mm AND cmh03=p_ccc01
               AND cmh071= g_ccc.ccc07  #CHI-9C0025
               AND cmh081= g_ccc.ccc08  #CHI-9C0025
     #------------No:MOD-B40049 end
      IF cl_null(l_tot_in_qty) THEN
         LET l_tot_in_qty = 0
      END IF
      IF cl_null(l_tot_out_qty) THEN
         LET l_tot_out_qty = 0
      END IF
     #-------------No:MOD-B40049 add
      IF cl_null(l_qpa_in_qty) THEN
         LET l_qpa_in_qty = 0
      END IF
      IF cl_null(l_qpa_out_qty) THEN
         LET l_qpa_out_qty = 0
      END IF
     #-------------No:MOD-B40049 end
      LET l_sql = "SELECT cmh031,cmh04,cmh05,cmh06,ccc23 FROM cmh_file ",
                  "  LEFT OUTER JOIN ccc_file ON (ccc_file.ccc01=cmh_file.cmh04 ",
                  "   AND ccc07 = '",g_ccc.ccc07,"' AND ccc08 = '",g_ccc.ccc08,"' ",  #CHI-9C0025
                  "   AND ccc_file.ccc02 = ", tm.yy," AND ccc_file.ccc03 = ",tm.mm,") ",   #CHI-970011
                  " WHERE cmh01 =",tm.yy,
                  "   AND cmh02 =",tm.mm,
                  "   AND cmh03 ='",p_ccc01,"' ",
                  "   AND cmh071='",g_ccc.ccc07,"'",  #CHI-9C0025
                  "   AND cmh081='",g_ccc.ccc08,"'"   #CHI-9C0025
      PREPARE p150_k3_p3 FROM l_sql
      DECLARE p150_k3_cs3 CURSOR FOR p150_k3_p3
      LET l_cma25 = 0
      LET l_avg_price_in = 0
      LET l_net_price_in = 0
      LET l_avg_price_out = 0
      LET l_net_price_out = 0
      #FUN-B30218(S) 
      LET l_qpa_in  = 0
      LET l_qpa_out = 0
      LET l_qpa_tot  = 0
      #FUN-B30218(E)
      FOREACH p150_k3_cs3 INTO l_cmh031,l_cmh04,l_cmh05,l_cmh06,l_ccc23
         LET g_cma.cma25 = 0
         #先取逆推成品的NRV
         IF cl_null(l_ccc23) THEN LET l_ccc23=0 END IF
         LET l_cma25 = 0
         SELECT cma25 INTO l_cma25 FROM cma_file 
          WHERE cma021=tm.yy AND cma022=tm.mm 
            AND cma01 =l_cmh04
            AND cma07 =g_ccc.ccc07  #CHI-9C0025
            AND cma08 =g_ccc.ccc08  #CHI-9C0025
            
         #有逆推成品料號,但其無cma_file資料(ex:當成品為本月上市的新料時,
         #又當資料類別選"2有庫存成本資料"時,因新料不會有ccc_file資料,所以此時
         #不會有cma_file資料,此時要幫他新增cma_file)
         IF SQLCA.sqlcode =100 THEN 
            SELECT ima01,ima09,ccc23,0,ima08,ima12,azf06
              INTO l_ccc01,l_ima09,l_ccc23_a,l_imk09,l_ima08,l_ima12,l_azf06
              FROM ima_file 
              LEFT OUTER JOIN ccc_file ON (ccc01=ima01 AND ccc02= tm.yy   #MOD-CB0125 mod g_yy->tm.yy
               AND ccc03= tm.mm AND ccc07= g_ccc.ccc07 AND ccc08=g_ccc.ccc08)  #MOD-CB0125 mod g_mm->tm.mm
              LEFT OUTER JOIN azf_file ON (azf01=ima12 AND azf02='G')
             WHERE ima01= l_cmh04
               AND imaacti = 'Y'           #MOD-C10167 add
            CALL p120_ins_cma_1(l_ccc01,l_ima09,l_ccc23_a,l_imk09,l_ima08,g_ccc.ccc08,l_ima12,l_azf06)
            CALL p150_p1_0('2', l_cmh04)
            LET l_cma25=g_cma.cma25
         END IF

         IF cl_null(l_cma25) THEN LET l_cma25 = 0 END IF 
         IF l_cma25 = 0 THEN 
         #  CALL p150_p1_0_get(2,l_cmh04)            #FUN-B30173
            CALL p150_p1_0_get(g_ccc.azf06,l_cmh04)  #FUN-B30173
            LET l_cma25 = g_cma.cma25
         END IF 
         #成品料號的平均成本單價(C)  = sum( 成品i的成本*(成品i的生產入庫量*該料的QPA / total 生產入庫量))
         IF l_tot_in_qty <> 0 THEN
            #取位
            #成品料號的平均成本單價(c) = sum(成品i的成本*(成品i的生產入庫量*該料的QPA/total生產入庫量))
            LET l_ccc23_in = l_ccc23 * l_cmh031*l_cmh05 / l_tot_in_qty
            LET l_avg_price_in = l_avg_price_in + l_ccc23_in
            #成品料號的平均NRV單價(C) = sum(成品i的NRV*(成品i的生產入庫量*該料的QPA / total生產入庫量))
            LET l_cma25_in = l_cma25 * l_cmh031*l_cmh05 / l_tot_in_qty
            LET l_net_price_in = l_net_price_in + l_cma25_in
            #FUN-B30218(S)
            LET l_qpa_tot = l_cmh031*l_cmh05 / l_qpa_in_qty    #No:MOD-B40049 modify
            LET l_qpa_in = l_qpa_in + l_qpa_tot
            #FUN-B30218(E)
         END IF
         
         #成品料號的平均淨變現單價(S) = sum( 成品i的淨變現單價*(成品i的出貨量*該料的QPA / total 出貨量))
         IF l_tot_out_qty <> 0 THEN
            #成品料號的平均成本單價(S) = sum(成品i的成本單價*(成品i的出貨量*該料的QPA / total出貨量)) 
            LET l_ccc23_out = l_ccc23 * l_cmh031*l_cmh06 / l_tot_out_qty
            LET l_avg_price_out = l_avg_price_out + l_ccc23_out
            #成品料號的平均NRV單價(S) = sum(成品i的NRV單價*(成品i的出貨量*該料的QPA / total出貨量))
            LET l_cma25_out = l_cma25 * l_cmh031*l_cmh06 / l_tot_out_qty
            LET l_net_price_out = l_net_price_out + l_cma25_out
            #FUN-B30218(S)
            LET l_qpa_tot  = l_cmh031*l_cmh06 / l_qpa_out_qty   #No:MOD-B40049 modify
            LET l_qpa_out = l_qpa_out + l_qpa_tot
            #FUN-B30218(E)
            END IF 
         UPDATE cmh_file SET cmh041 = l_cma25
          WHERE cmh01  = tm.yy   AND cmh02 = tm.mm 
            AND cmh03  = p_ccc01 AND cmh04 = l_cmh04
            AND cmh071 = g_ccc.ccc07   #CHI-9C0025
            AND cmh081 = g_ccc.ccc08   #CHI-9C0025
      END FOREACH
      IF tm.s[1,1] = 1 THEN   #入庫量
         LET l_avg_price = l_avg_price_in
         LET l_net_price = l_net_price_in
         LET l_qpa_tot    = l_qpa_in       #FUN-B30218
      ELSE
         LET l_avg_price = l_avg_price_out
         LET l_net_price = l_net_price_out
         LET l_qpa_tot    = l_qpa_out      #FUN-B30218
      END IF 
 
      #半成品/原料之再投入成本 = 逆推成品的成本單價平均值 - 此料之成本
 #    LET l_put_cost = l_avg_price - g_ccc.ccc23 * l_cmh031     #MOD-B10076 add l_cmh031 #FUN-B30218
      LET l_put_cost = l_avg_price - g_ccc.ccc23 * l_qpa_tot     #FUN-B30218 
      #半成品/原料之淨變現單價 = 逆推成品料號的平均淨變現單價(S) - 半成品/原料之再投入成本
      IF l_put_cost > 0 THEN     #CHI-980020
         LET g_cma.cma25 = l_net_price - l_put_cost
     #   LET g_cma.cma25 = g_cma.cma25 / l_cmh031     #MOD-B10076 add #FUN-B30218
         LET g_cma.cma25 = g_cma.cma25 / l_qpa_tot     #FUN-B30218
      END IF  #CHI-980020
     #IF g_cma.cma25 < 0 THEN LET g_cma.cma25 = 0 END IF   #CHI-970033 #FUN-980122
 
   ELSE  #沒有可逆展的成品料號
      CALL p120_error('ima01',p_ccc01,'k2_cs1','axc-999',1)  #CHI-970034
   #  CALL p150_p1_0_get(0,g_cma.cma01)           #FUN-B30173
      CALL p150_p1_0_get(g_ccc.azf06,g_cma.cma01) #FUN-B30173
   END IF
 
   LET g_cma.cma29='AVG'  #FUN-930100
   CALL cl_getmsg('axc-007',g_lang) RETURNING g_msg
   UPDATE cma_file 
      SET cma25  = g_cma.cma25,
          cma26  = g_cma.cma26,
          cma27  = g_msg,
          cma271 = NULL, #FUN-930100
          cma28  = 0,
          cma29  = g_cma.cma29,
          cma32  = 0,
          cma291 = l_avg_price,
          cma292 = l_net_price,
          cma293 = l_qpa_tot         #FUN-B30218
    WHERE cma01 = p_ccc01
      AND cma021= tm.yy
      AND cma022= tm.mm
      AND cma07 = g_ccc.ccc07   #CHI-9C0025
      AND cma08 = g_ccc.ccc08   #CHI-9C0025
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     #資料新增失敗
      CALL p120_error('cma01',p_ccc01,'ins cma','9050',1) #CHI-970034
      LET g_success = 'N'
      RETURN
   ELSE
   END IF   
END FUNCTION
 
FUNCTION p150_bom_2(p_level,p_key,p_qpa)
   DEFINE p_level       LIKE type_file.num5,
          p_key         LIKE bma_file.bma01,    #元件料件編號
          p_qpa         LIKE bmb_file.bmb06,    #累積QPA
          l_ac,i        LIKE type_file.num5,
         #arrno         LIKE type_file.num5,    #BUFFER SIZE (可存筆數)  #MOD-A30174 mark
          b_seq         LIKE bmb_file.bmb02,    #滿時,重新讀單身之起始序號
          sr            DYNAMIC ARRAY OF RECORD #每階存放資料
              bmb01     LIKE bmb_file.bmb01,    #主件料號
              bmb03     LIKE bmb_file.bmb03,    #元件料件
              qpa       LIKE bmb_file.bmb06,    #QPA
              ima903    LIKE ima_file.ima903
                        END RECORD,
          l_cnt         LIKE type_file.num10,
          lp_qty        LIKE type_file.num20_6,              #當月生產入庫量
          lo_qty        LIKE type_file.num20_6,              #當月出貨量
          l_cmd         LIKE type_file.chr1000
DEFINE    l_bmm03       LIKE bmm_file.bmm03 
DEFINE    l_qpa         LIKE bmb_file.bmb06
DEFINE    l_bmb06       LIKE bmb_file.bmb06
DEFINE    l_bmb07       LIKE bmb_file.bmb06
DEFINE    l_bmb08       LIKE bmb_file.bmb06
DEFINE    l_sql1        STRING   #FUN-970103
DEFINE    l_bmm06       LIKE bmm_file.bmm06  #MOD-9A0066       
DEFINE    l_ima25       LIKE ima_file.ima25        #No:CHI-B60002 add
DEFINE    l_ima55       LIKE ima_file.ima25        #No:CHI-B60002 add
DEFINE    l_ima55_fac   LIKE ima_file.ima55_fac    #No:CHI-B60002 add
DEFINE    l_bmb10_fac   LIKE bmb_file.bmb10_fac    #No:CHI-B60002 add
DEFINE    l_flag        LIKE type_file.chr1        #No:CHI-B60002 add

   IF p_level > 25 THEN
     #階數超過25階,結構建立可能錯,請先執行偵錯作業
      CALL p120_error('p_key',p_key,'sel bom','mfg2733',1)   #CHI-970034
      LET g_success = 'N'
      RETURN
   END IF
   LET p_level = p_level + 1
   IF p_level = 1 THEN
      INITIALIZE sr[1].* TO NULL
      LET sr[1].bmb03 = p_key
   END IF
   #CHI-C80002---begin mark
   LET l_cmd = "SELECT bmm03,bmm06 FROM bmm_file ",
               " WHERE bmm01 = ? ",
               "   AND bmm05 = 'Y' "
   PREPARE p150_bom_bmm06_p1 FROM l_cmd            
   DECLARE p150_bom_bmm06 CURSOR FOR p150_bom_bmm06_p1

   LET l_sql1 = "SELECT SUM(tlf10*tlf60) FROM tlf_file ",  
                " WHERE tlf01 = ? ",
                "   AND tlfcost = '",g_ccc.ccc08,"' ",   
                "   AND tlf06 BETWEEN '",g_qbdate,"' AND '",g_qedate,"' ", 
                "   AND NOT EXISTS(select 1 FROM cmw_file WHERE cmw01 = tlf021) " 
   LET l_sql1 = l_sql1 ,g_sql2
   PREPARE p120_tlf_pre1 FROM l_sql1                                                                                                     
   DECLARE p120_tlf_cs1 CURSOR FOR p120_tlf_Pre1 
   #CHI-C80002---end
   #LET arrno = 600 #MOD-A30174 mark
   WHILE TRUE
      LET l_cmd = "SELECT bmb01,bmb03,'',ima903,bmb06,bmb07,bmb08",
                  " ,bmb10_fac ",                                     #No:CHI-B60002 add
                  "  FROM bmb_file,ima_file", #FUN-970090  #FUN-980088
                  " WHERE bmb03='", p_key,"' ",
                  "   AND ima01  = bmb03",
                  "   AND bmb29 = ",g_nvl_str,"(ima910,' ')", #CHI-980053 
                  "   AND (bmb04 <='", tm.bdate, "' OR bmb04 IS NULL)",
                  "   AND (bmb05 > '", tm.bdate, "' OR bmb05 IS NULL)",
                  "   AND imaacti = 'Y' ",     #MOD-C10167 add
                  "   AND bmb14 != '2' ",      #MOD-C40074 add
                  " ORDER BY bmb01"
      PREPARE p150_bom_p3 FROM l_cmd
      IF SQLCA.sqlcode THEN
         CALL p120_error('p_key',p_key,'sel bmb',SQLCA.sqlcode,1) # CHI-970034
         LET g_success = 'N'
         RETURN
      END IF
      DECLARE p150_bom_cs3 CURSOR for p150_bom_p3
      LET l_ac = 1
      FOREACH p150_bom_cs3 INTO sr[l_ac].*,l_bmb06,l_bmb07,l_bmb08,l_bmb10_fac        # 先將BOM單身存入BUFFER  #No:CHI-B60002 add l_bmb10_fac
         LET l_qpa = p_qpa * l_bmb06 / l_bmb07  #不考慮損耗率
         LET sr[l_ac].qpa = l_qpa
        #-------------------No:CHI-B60002 add
         IF cl_null (l_bmb10_fac) THEN LET l_bmb10_fac = 1 END IF
            LET sr[l_ac].qpa = sr[l_ac].qpa * l_bmb10_fac  #考慮半成品/元件的發料單位與庫存單位換算率

         LET l_ima25 = NULL
         LET l_ima55 = NULL
         SELECT ima25,ima55 INTO l_ima25,l_ima55 FROM ima_file WHERE ima01 = sr[l_ac].bmb01
         IF l_ima25 != l_ima55 THEN
            CALL s_umfchk(sr[l_ac].bmb01,l_ima25,l_ima55) RETURNING l_flag,l_ima55_fac
            IF l_flag = '1' THEN
               LET l_ima55_fac = 1
            END IF
            LET sr[l_ac].qpa = sr[l_ac].qpa * l_ima55_fac   #考慮成品/半成品的生產單位與庫存單位換算率
         END IF
        #-------------------No:CHI-B60002 end
         IF g_sma.sma104 = 'Y' AND sr[l_ac].ima903 = 'Y' THEN
            #CHI-C80002---begin mark
            #DECLARE p150_bom_bmm06 CURSOR FOR
            # SELECT bmm03,bmm06 FROM bmm_file
            #  WHERE bmm01 = sr[l_ac].bmb01
            #    AND bmm05 = 'Y'
            #FOREACH p150_bom_bmm06 INTO l_bmm03,l_bmm06 #MOD-9A0066 add bmm06
            #CHI-C80002---end
            FOREACH p150_bom_bmm06 USING sr[l_ac].bmb01 INTO l_bmm03,l_bmm06  #CHI-C80002        
               LET l_ac = l_ac + 1
               LET sr[l_ac].bmb01  = l_bmm03
               LET sr[l_ac].bmb03  = sr[l_ac-1].bmb03     #No:MOD-9A0095 modify
               LET sr[l_ac].qpa    = l_qpa * (l_bmm06/100) #MOD-9A0066 bmm03-->bmm06      
               LET sr[l_ac].ima903 = 'N'
            END FOREACH
         END IF
         LET l_ac = l_ac + 1                        #但BUFFER不宜太大
        #IF l_ac >= arrno THEN EXIT FOREACH END IF  #MOD-A30174 mark
      END FOREACH
      LET l_cmd= "SELECT COUNT(*) ",
                 "  FROM bmb_file,ima_file",
                 " WHERE bmb03  = ? ",
                 "   AND bmb03  = ima01",
                 "   AND ima910 = bmb29",
                 "   AND (bmb04 <='", tm.bdate,"' OR bmb04 IS NULL) ",
                 "   AND (bmb05 > '", tm.bdate,"' OR bmb05 IS NULL)",
                 "   AND bmb14 != '2' ",     #MOD-C40074 add
                 "   AND imaacti = 'Y' "     #MOD-C10167 add
      PREPARE p150_bom_p4 FROM l_cmd
      IF SQLCA.sqlcode THEN
         CALL p120_error('p_key',p_key,'bom_p4',SQLCA.sqlcode,1) #CHI-970034
         LET g_success = 'N'
         RETURN
      END IF
      DECLARE p150_bom_cs4 CURSOR for p150_bom_p4
      FOR i = 1 TO l_ac-1                  # 讀BUFFER傳給REPORT
         LET l_cnt = 0
         OPEN p150_bom_cs4 USING sr[i].bmb01
         FETCH p150_bom_cs4 INTO l_cnt
         IF l_cnt <= 0 THEN
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM cmh_file 
             WHERE cmh01  = tm.yy AND cmh02 = tm.mm 
               AND cmh03  = g_ccc.ccc01 AND cmh04 = sr[i].bmb01  #CHI-940029
               AND cmh071 = g_ccc.ccc07   #CHI-9C0025
               AND cmh081 = g_ccc.ccc08   #CHI-9C0025
            IF g_cnt IS NULL THEN LET g_cnt = 0 END IF
            IF g_cnt = 0 THEN
              #當月生產入庫量
               LET lp_qty = 0
               #CHI-C80002---begin mark
               #LET l_sql1 = "SELECT SUM(tlf10*tlf60) FROM tlf_file ",  #No:CHI-B60002 add *tlf60
               #             " WHERE tlf01 = '",sr[i].bmb01,"' ",
               #            #"   AND tlfcost = '",g_ccc.ccc07,"' ",    #CHI-9C0025  #TQC-A10116
               #             "   AND tlfcost = '",g_ccc.ccc08,"' ",    #TQC-A10116
               #            #"   AND tlf07 BETWEEN '",g_qbdate,"' AND '",g_qedate,"' ",  #MOD-C40074 mark
               #             "   AND tlf06 BETWEEN '",g_qbdate,"' AND '",g_qedate,"' ",  #MOD-C40074 add
               #             "   AND tlf021 NOT IN (select cmw01 FROM cmw_file) "  #CHI-C80002
               #LET l_sql1 = l_sql1 ,g_sql2
               #PREPARE p120_tlf_pre1 FROM l_sql1                                                                                                     
               #DECLARE p120_tlf_cs1 CURSOR FOR p120_tlf_Pre1                                                                                             
               #OPEN p120_tlf_cs1   
               #CHI-C80002---end
               OPEN p120_tlf_cs1 USING sr[i].bmb01   #CHI-C80002             
               FETCH p120_tlf_cs1 INTO lp_qty
               IF lp_qty IS NULL THEN LET lp_qty = 0 END IF
              #當月出貨量
               LET lo_qty = 0
               SELECT SUM(tlf10*tlf60*tlf907) INTO lo_qty FROM tlf_file   #No:CHI-B60002 add *tlf60 #MOD-C20175 add *tlf907
                 LEFT OUTER JOIN oga_file ON tlf026 = oga01               #MOD-C40074 add
                WHERE tlf01 = sr[i].bmb01
                 #AND tlfcost = g_ccc.ccc07    #CHI-9C0025 #TQC-A10116
                  AND tlfcost = g_ccc.ccc08    #TQC-A10116
                  AND tlf13 IN ('axmt620','axmt650')
                 #AND tlf07 BETWEEN g_qbdate AND g_qedate  #MOD-C40074 mark
                  AND tlf06 BETWEEN g_qbdate AND g_qedate  #MOD-C40074 add
                  AND oga65 != 'Y'                         #MOD-C40074 add
               IF lo_qty IS NULL THEN LET lo_qty = 0 END IF
 
               INSERT INTO cmh_file (cmh01,cmh02,cmh03,cmh031,cmh04,cmh041,cmh05,cmh06,
                                     cmh07,cmh08,cmh071,cmh081,  #CHI-9C0025
                                     cmhdate,cmhgrup,cmhmodu,cmhuser,cmhoriu,cmhorig,cmhlegal)    #FUN-A50075 add legal
                           VALUES(tm.yy,tm.mm,g_ccc.ccc01,sr[i].qpa,sr[i].bmb01,  #CHI-940029
                                  g_cma.cma25,lp_qty,lo_qty,g_qbdate,g_qedate,
                                  g_ccc.ccc07,g_ccc.ccc08,    #CHI-9C0025
                                  g_today,g_grup,'',g_user, g_user, g_grup,g_legal)      #No.FUN-980030 10/01/04  insert columns oriu, orig   #FUN-A50075 add legal
               
               CASE SQLCA.sqlcode
                  WHEN "-239"
                     EXIT CASE   #有重復原件料號時只抓一次
                  WHEN "0"
                     EXIT CASE
                  OTHERWISE
                     LET g_showmsg= tm.yy,"/",tm.mm
                     CALL p120_error('cmh01,cmh02',g_showmsg,'ins cmh',SQLCA.sqlcode,1)   #CHI-970034
                     LET g_success = 'N'
                     RETURN
               END CASE
            ELSE
               UPDATE cmh_file SET cmh031  = cmh031 + sr[i].qpa 
                WHERE cmh01  = tm.yy AND cmh02 = tm.mm 
                  AND cmh03  = g_ccc.ccc01 AND cmh04 = sr[i].bmb01  #CHI-940029
                  AND cmh071 = g_ccc.ccc07   #CHI-9C0025
                  AND cmh081 = g_ccc.ccc08   #CHI-9C0025
            END IF
         ELSE
            CALL p150_bom_2(p_level,sr[i].bmb01,sr[i].qpa)
         END IF
      END FOR
     #IF l_ac < arrno OR l_ac=1 THEN    # BOM單身已讀完   #MOD-A30174 mark
     #IF l_ac=1 THEN                    # BOM單身已讀完   #MOD-A30174   #MOD-AA0048 mark
         EXIT WHILE
     #ELSE                              #MOD-A30174 mark
     #   LET b_seq = sr[arrno].bmb03    #MOD-A30174 mark
     #END IF                            #MOD-AA0048 mark
   END WHILE
END FUNCTION
 
#RETURN FLAG,人工市價 => WHEN FLAG = TRUE 則有取到人工市價, FALSE 則無取到市價
FUNCTION p120_get_i311(p_ima01)
   DEFINE p_ima01 LIKE ima_file.ima01
   DEFINE l_sql STRING
   DEFINE l_where STRING
   DEFINE l_cmf05 LIKE cmf_file.cmf05
   DEFINE l_cme03 LIKE cme_file.cme031      #CHI-980009
   
   #分類來源(tm.choice4 = cmf06): 1.主分群碼  2.分群碼一  3.分群碼二  4.分群碼三  5.成本分群  6.產品分類  7.料號
   CASE tm.choice4
      WHEN '1'  LET l_where = "TRIM(cmf03)  = ima06"
      WHEN '2'  LET l_where = "TRIM(cmf03)  = ima09"
      WHEN '3'  LET l_where = "TRIM(cmf03)  = ima10"
      WHEN '4'  LET l_where = "TRIM(cmf03)  = ima11"
      WHEN '5'  LET l_where = "TRIM(cmf03)  = ima12"
      WHEN '6'  LET l_where = "TRIM(cmf031) = ima131"
      WHEN '7'  LET l_where = "TRIM(cmf04)  = ima01"
      OTHERWISE RETURN FALSE,0
   END CASE
 
   #重抓一次該料號銷售費用
 # LET g_cma.cma32='' #FUN-B30212
   LET g_cma.cma32=0  #FUN-B30212
   SELECT ima06,ima09,ima10,ima11,ima12,ima131
     INTO g_ccc.ima06,g_ccc.ima09,g_ccc.ima10,g_ccc.ima11,
          g_ccc.ima12,g_ccc.ima131
     FROM ima_file
    WHERE ima01 = p_ima01
      AND imaacti = 'Y'      #MOD-C10167 add
   CASE tm.cme06
        WHEN '1'  LET l_cme03 = g_ccc.ima06
        WHEN '2'  LET l_cme03 = g_ccc.ima09
        WHEN '3'  LET l_cme03 = g_ccc.ima10
        WHEN '4'  LET l_cme03 = g_ccc.ima11
        WHEN '5'  LET l_cme03 = g_ccc.ima12
        WHEN '6'  LET l_cme03 = g_ccc.ima131
   END CASE
   IF tm.cme06='6' THEN 
      SELECT cme04 INTO g_cma.cma32
        FROM cme_file
       WHERE cme01 = tm.yy
         AND cme02 = tm.mm
         AND cme06 = tm.cme06
         AND cme031= l_cme03
      IF SQLCA.SQLCODE THEN
         SELECT cme04 INTO g_cma.cma32
           FROM cme_file
          WHERE cme01 = tm.yy
            AND cme02 = tm.mm
            AND cme06 = tm.cme06
            AND cme031 = 'ALL' 
       END IF
   ELSE
      SELECT cme04 INTO g_cma.cma32
        FROM cme_file
       WHERE cme01 = tm.yy
         AND cme02 = tm.mm
         AND cme06 = tm.cme06
         AND cme03= l_cme03
      IF SQLCA.SQLCODE THEN
         SELECT cme04 INTO g_cma.cma32
           FROM cme_file
          WHERE cme01 = tm.yy
            AND cme02 = tm.mm
            AND cme06 = tm.cme06
            AND cme03 = 'ALL' 
       END IF
   END IF 
   LET l_sql = "SELECT cmf05 FROM cmf_file,ima_file ",
               " WHERE cmf01 = ",tm.yy,
               "   AND cmf02 = ",tm.mm,
               "   AND cmf06 = '",tm.choice4,"'",
               "   AND ima01 = '",p_ima01,"'",
               "   AND ", l_where CLIPPED,
               "   AND imaacti = 'Y' "     #MOD-C10167 add
 
   PREPARE p120_get_i311_p FROM l_sql                                                                                                   
   DECLARE p120_get_i311_c CURSOR FOR p120_get_i311_p
   FOREACH p120_get_i311_c INTO l_cmf05
      IF (l_cmf05 IS NULL) OR (l_cmf05 = 0) THEN
         CONTINUE FOREACH
      END IF
      EXIT FOREACH
   END FOREACH
 
   IF l_cmf05 > 0 THEN
      RETURN TRUE,l_cmf05
   ELSE
      RETURN FALSE,0
   END IF
END FUNCTION
 
#函數目的:取得成品/原料取單價的單據
#回傳值:FALSE - 資料重複 ; TRUE - 資料新增成功
#(若第一筆新增出現-239,則表示此料已存在cmg資料,不需再新增第二筆以後的資料,因為第二筆以後也會是-239,加以判斷以節省效率)
 
#p_type's type:
#1:應收帳款 (成品) (omb_file)
#2:訂單 (成品)
#3:合約訂單 (成品)
#4:應付帳款 (原料) (apb_file)
#5.採購單 (原料)
 
FUNCTION p120_ins_cmg(p_docno,p_lineno,p_itemno,p_maxno,p_price,p_cma271,p_type,l_qty,l_unit,l_unit_fac) #CHI-970034 add ,l_qty,l_unit
  DEFINE p_docno  LIKE oeb_file.oeb01
  DEFINE p_lineno LIKE oeb_file.oeb03
  DEFINE p_itemno LIKE ima_file.ima01
  DEFINE p_maxno  LIKE oeb_file.oeb03
  DEFINE p_price  LIKE omb_file.omb15
  DEFINE p_cma271 LIKE cma_file.cma271
  DEFINE p_type   LIKE type_file.chr1
  DEFINE l_qty    LIKE cmg_file.cmg10   #CHI-970034
  DEFINE l_unit   LIKE cmg_file.cmg11   #CHI-970034
  DEFINE l_unit_fac   LIKE cmg_file.cmg11_fac #CHI-970034
 
   CALL FGL_SETENV("DBDATE","Y4MD/")
   IF p_cma271 = '1899/12/31' THEN 
      LET p_cma271 = NULL 
   END IF   
   CALL FGL_SETENV("DBDATE",g_date)
  INSERT INTO cmg_file (cmg01,cmg02,cmg03,cmg04,cmg05,cmg06,cmg07,
                        cmg08,cmg09,cmg10,cmg11,cmg11_fac,
                        cmg071,cmg081,cmglegal) #CHI-970034  #CHI-9C0025   #FUN-A50075 add legal
        #VALUES (g_yy,g_mm,p_itemno,p_maxno,p_type,p_docno,p_lineno,  #MOD-CB0125 mark
         VALUES (tm.yy,tm.mm,p_itemno,p_maxno,p_type,p_docno,p_lineno,  #MOD-CB0125
                        p_price,p_cma271,l_qty,l_unit,l_unit_fac,
                        g_cma.cma07,g_cma.cma08,g_legal)    #CHI-9C0025    #FUN-A50075 add legal
  CASE
     WHEN SQLCA.sqlcode=-239 OR SQLCA.sqlcode=-268
        RETURN FALSE
     WHEN SQLCA.sqlcode <> 0
        LET g_showmsg= p_docno,"/", p_lineno
        CALL p120_error('omb01,omb03',g_showmsg,'ins cmg:',SQLCA.sqlcode,1)  #CHI-970034
  END CASE
 
  RETURN TRUE
END FUNCTION
 
FUNCTION p120_error(p_field,p_data,p_msg,err_code,p_n) 
   DEFINE p_field     STRING
   DEFINE p_data      STRING
   DEFINE g_field     STRING
   DEFINE l_field     STRING
   DEFINE p_msg       LIKE type_file.chr50
   DEFINE err_code    LIKE type_file.chr7
   DEFINE p_n         LIKE type_file.num5
   DEFINE lc_ze03     LIKE ze_file.ze03
   DEFINE lc_name     LIKE ze_file.ze03
   DEFINE l_ze03      STRING
   DEFINE tok base.StringTokenizer
   DEFINE lc_gaq03 LIKE gaq_file.gaq03 
#FUN-B30173 ---------------------Begin-----------------------
   DEFINE sr          RECORD
                          order    LIKE type_file.chr50,
                          name     LIKE type_file.chr50,
                          field    LIKE gae_file.gae02,
                          data     LIKE type_file.chr50,
                          err_code LIKE ze_file.ze01,
                          ze03     LIKE ze_file.ze03
                      END RECORD  
#FUN-B30173 ---------------------End-------------------------
   
   CALL cl_getmsg(err_code,g_lang) RETURNING lc_ze03 
   
   IF p_n = "1" THEN
      CALL cl_getmsg("aaz-200",g_lang) RETURNING lc_name
   ELSE 
      CALL cl_getmsg("aaz-199",g_lang) RETURNING lc_name
   END IF
   IF err_code <> 'axm-333' THEN      #FUN-B30173 
      LET g_field =""                                                                                                                  
      LET tok = base.StringTokenizer.create(p_field,",")                                                                               
      WHILE tok.hasMoreTokens()                                                                                                                                                                                                             
         LET l_field = tok.nextToken()                                                                                                 
         LET lc_gaq03 = ''            #FUN-B30173
         CALL cl_get_feldname(l_field,g_lang) RETURNING lc_gaq03                                                                       
         IF cl_null(g_field) THEN                                                                                                      
            LET g_field = lc_gaq03 CLIPPED,"(",l_field,")"        #MOD-9C0101 add CLIPPED                                                                                 
         ELSE                                                                                                                          
            LET g_field = g_field,"/",lc_gaq03 CLIPPED,"(",l_field,")"     #MOD-9C0101 add CLIPPED                                                                      
         END IF                                                                                                                        
      END WHILE
      LET l_ze03 = p_msg CLIPPED,lc_ze03 CLIPPED        #MOD-9C0101 add CLIPPED
#FUN-B30173 ---------------Begin----------------
   ELSE
      LET g_field = p_field
      LET l_ze03 = lc_ze03 CLIPPED
   END IF
   LET sr.order    = err_code,p_data
   LET sr.name     = lc_name
   LET sr.field    = g_field
   LET sr.data     = p_data
   LET sr.err_code = err_code
   LET sr.ze03     = l_ze03
#FUN-B30173 ---------------End------------------
   
  #OUTPUT TO REPORT p120_rep(lc_name,g_field,p_data,err_code,l_ze03)     #FUN-B30173
  OUTPUT TO REPORT p120_rep(sr.*)      #FUN-B30173 

END FUNCTION
 
#REPORT p120_rep(lc_name,g_field,p_data,err_code,l_ze03) #FUN-B30173
REPORT p120_rep(sr)                                      #FUN-B30173
   DEFINE l_last_sw   LIKE type_file.chr1
#FUN-B30173 ------------Begin--------------
#  DEFINE lc_name     LIKE ze_file.ze03
#  DEFINE l_ze03      STRING
#  DEFINE p_data      STRING
#  DEFINE g_field     STRING
#  DEFINE err_code    LIKE type_file.chr7
   DEFINE sr          RECORD
                          order    LIKE type_file.chr50,
                          name     LIKE type_file.chr50,
                          field    LIKE gae_file.gae02,
                          data     LIKE type_file.chr50,
                          err_code LIKE ze_file.ze01,
                          ze03     LIKE ze_file.ze03
                      END RECORD    
#FUN-B30173 ------------End----------------
          
  OUTPUT TOP MARGIN 0
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN 6
         PAGE LENGTH g_page_line
  ORDER BY sr.order  #FUN-B30173
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[11] CLIPPED, tm.yy USING '<<<<<', '/', tm.mm USING '&&'
      PRINT g_x[12] CLIPPED, tm.cmz70 USING 'YY/MM/DD'
      PRINT g_dash2[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
      PRINT g_dash1
 
  #ON EVERY ROW              #FUN-B30173
   AFTER GROUP OF sr.order   #FUN-B30173
#FUN-B30173 ---------------Begin------------------
#     PRINT COLUMN g_c[31], lc_name CLIPPED,
#           COLUMN g_c[32], g_field CLIPPED,
#           COLUMN g_c[33], p_data CLIPPED,
#           COLUMN g_c[34], err_code CLIPPED,
#           COLUMN g_c[35], l_ze03 CLIPPED
      PRINT COLUMN g_c[31], sr.name CLIPPED,
            COLUMN g_c[32], sr.field CLIPPED,
            COLUMN g_c[33], sr.data CLIPPED,
            COLUMN g_c[34], sr.err_code CLIPPED,
            COLUMN g_c[35], sr.ze03 CLIPPED
#FUN-B30173 ---------------End-------------------
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
 
END REPORT
#No.FUN-9C0073 --------------By chenls 10/01/11
#MOD-C60024
