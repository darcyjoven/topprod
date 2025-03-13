# Prog. Version..: '5.30.05-13.04.19(00010)'     #
#
# Modify.........: NO.TQC-7C0146 07/12/19 BY claire poz04已無使用, 應取單身第0站的上游廠商
# Pattern name...: axmp900.4gl
# Descriptions...: 三角貿易出貨單拋轉作業(反向)
# Date & Author..: 99/11/09 By Kammy
# Note...........: 由 axmp820 改寫
# Modify ........: No.+196 010612 by linda mod 各廠若料件主檔之主要倉庫有值,
#                  則以ima為主,ima35 is null 才以目的廠之倉庫給值
# Modify.........: No.7742 03/08/07 By Kammy 1.備品資料不回寫訂單已出貨量
#                                            2.若為備品資料金額單價皆為零
# Modify.........: No.8047 03/09/03 By Kammy 1.銷售逆拋、採購逆拋合併
#                                            2.請注意：採購逆拋來源廠不拋出貨單
#                                            3.新版多角貿易出貨單扣帳動作在
#                                              axmt820 所以取消 axmp902
# Modify.........: No.9059 04/01/27 Kammy 代採買 call s_mupimg 應判斷為 i = 0
#                                         而非 i = 1
# Modify.........: No.9337 04/03/12 Melody line#977寫錯了,應該是 LET l_ogb.ogb09
# Modify.........: No.9508 04/05/05 ching  取得多角貿易匯率程式段，移至_p2()
# Modify.........: No.9565 04/05/14 ching  "WHERE oga30 = ? "改應改為 oga01 = ?
# Modify.........: No.MOD-4B0148 04/11/15 ching tlf11,tlf12 單位錯誤
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-4C0064 04/12/17 By Carol 1.第一站的入庫量未回寫 , 因為 採用 l_ogb31 ,l_ogb32 但是第一站應該不會有 l_ogb 的資料 建議採用 l_rvv
# Modify.........: No.MOD-4C0070 04/12/17 By Carol 採逆出貨單拋轉產生之收貨單,其採購己交量錯誤
# Modify.........: No.MOD-520099 05/03/03 By ching 出通單更新錯誤處理
# Modify.........: No.MOD-530592 05/04/27 By kim 若為新倉/儲/批 新增詢問改confirm
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/07/06 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: No.MOD-570191 05/08/03 By Nicola SQL語法修改
# Modify.........: No.MOD-580202 05/08/17 By Smapmin 自動編號未給性質
# Modify.........: No.FUN-5A0155 05/10/24 By Sarah p900_ogains()寫入出貨單單頭檔(oga_file)單前,CALL p900_chk99()檢查序號是否重複
# Modify.........: No.MOD-5B0317 05/12/05 By Nicola oea161,162,163預設值設定
# Modify.........: No.MOD-5B0320 05/12/05 By Nicola ofa32 建議重新抓取各站的訂單oea32來 default，不要直接用來源站的ofa32
# Modify.........: No.MOD-5B0326 05/12/20 By Nicola 若一張出通單分批出貨時,在第一次拋轉時DS-4應產生一張出通單,此出通單內容同DS-6
# Modify.........: No.FUN-620029 06/02/11 By Carrier 將axmp900拆開成axmp900及saxmp900
# Modify.........: No.FUN-620024 06/02/20 By Rayven 增加拋轉時有代送銷退單產生
# Modify.........: No.FUN-620054 06/03/13 By ice 增加對指定工廠的三角貿易出貨單拋轉
# Modify.........: No.FUN-630006 06/03/15 By Nicola oaz19="Y"時，要產生最終出貨單 
# Modify.........: No.FUN-640025 06/04/08 By Nicola 改用oea37，取代oaz19的判斷
# Modify.........: NO.TQC-640078 06/04/08 BY yiting 產生收貨單不成功 
# Modify.........: NO.MOD-640189 06/04/09 BY yiting DS3多角出貨單axmt820(多角序號S001    -06040001)扣帳拋單至各廠時，DS2及DS1的多角收貨單及多角入庫單皆產生不出來，但tlf_file有產生成功!
# Modify.........: NO.FUN-640167 06/04/18 BY yiting 出貨或入庫扣帳拋單時，中間廠都會詢問"這是新的倉儲批，是否新增? -->不用問，直接產生 
# Modify.........: NO.MOD-640424 06/04/18 BY yiting update pmn_file條件不需加入分銷判斷
# Modify.........: NO.MOD-640424 06/04/19 BY yiting update pmn_file條件有誤"
# Modify.........: NO.TQC-650089 06/05/24 BY Rayven 選取出貨單時過濾掉返利的單子
# Modify.........: NO.TQC-640134 06/05/25 BY yiting 多判斷oaz19決定是否產生出貨單
# Modify.........: NO.MOD-640581 06/06/22 By Mandy 代採逆拋時,insert into tlf_file時, tlf19(廠商/客戶)有誤. 也就是tlf19 <> rvu04(入庫單apmt740之廠商)
# Modify.........: NO.MOD-620053 06/06/22 By Mandy 更新起始站之tlf99多角序號
# Modify.........: NO.MOD-630036 06/06/22 By Mandy update 沒檢查SQLCA.SQLCODE
# Modify.........: NO.FUN-630053 06/06/26 By Mandy 是否拋轉 Packing List 內的SQL條件式判斷不夠嚴謹,多再加上AND oga01=l_oga01
# Modify.........: No.FUN-660167 06/06/26 By wujie cl_err --> cl_err3 
# Modify.........: No.MOD-660122 06/06/30 By Rayven 當ima25與img09的單位一樣時，imgg21及imgg211所存的轉換率，也應該要一樣
# Modify.........: NO.MOD-660137 06/07/05 BY yiting pmn50回寫錯誤
# Modify.........: NO.FUN-670007 06/07/27 BY yiting 1.oaz32改取oax01,oaz203->oax04,oaz204->oax05
#                                                   2.拋轉時不再拋轉出通單，因出通單確認時己經自動拋轉過(不管oax07設定，必拋) 
#                                                   3.s_mutislip因應多角改善，多傳入站別參數以取得單別
#                                                   4.有中斷點設定時相關處理 
# Modify.........: NO.FUN-660068 06/08/28 BY yiting 出貨單科目別要一同拋轉到各區
# Modify.........: No.FUN-680137 06/09/11 By bnlent 欄位型態用LIKE定義
# Modify.........: No.TQC-690065 06/10/30 By Rayven 逆拋時oga55，狀況碼沒有拋
# Modify.........: No.TQC-690105 06/11/03 By Rayven 逆拋時生成的入庫單單位和出貨單不符時，沒有通過轉換率重新計算
# Modify.........: No.FUN-6A0094 06/11/07 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: NO.TQC-690057 06/11/15 BY Claire img_file值要取自imd_file
# Modify.........: NO.MOD-680071 06/11/16 BY Claire ogb13要取位 
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: NO.TQC-6A0084 06/12/05 By Nicola 含稅金額、未稅金額調整
# Modify.........: NO.MOD-6B0152 06/12/08 BY Claire 銷售取位應以採購單單頭幣別
# Modify.........: NO.MOD-6B0029 06/12/11 BY Claire 應拋轉packing list時,沒拋則不允許執行程式
# Modify.........: NO.MOD-6C0086 06/12/14 BY Claire 語法調整
# Modify.........: NO.MOD-6C0120 06/12/20 BY Claire g_tlf.tlf19=g_oga.oga04 改  l_oga.oga04
# Modify.........: NO.TQC-710049 07/01/11 By Mandy 出貨庫存過帳時,會出現"ins t_ogb: 無法將 null 插入欄的 '欄-名稱' ."的錯誤訊息,原因為ogb14/ogb14t為NULL
# Modify.........: No.FUN-710046 07/01/23 By yjkhero 錯誤訊息匯整  
# Modify.........: NO.MOD-6C0141 07/02/08 BY Claire ogb13要取位azi03 
# Modify.........: NO.MOD-710073 07/03/21 BY Claire 銷售逆拋時,拋轉產生的出通單ogb09倉庫應取poy11倉庫別
# Modify.........: NO.MOD-740042 07/04/19 BY Claire 改以多角序號為key值
# Modify.........: NO.MOD-740338 07/04/25 BY yiting 中斷工廠不應有入庫量，只有收貨量
# Modify.........: NO.TQC-740320 07/04/26 BY Yiting 回寫oga905時，應判斷g_success = 'Y' 
# Modify.........: NO.MOD-740162 07/04/26 BY yiting 拋轉每一站的INVOICE/PACKING訂單單號 應以每一站取出的訂單資料寫入
# Modify.........: NO.MOD-720030 07/05/17 By claire MISC不更新起始站之tlf99多角序號(MOD-620053) 
# Modify.........: NO.TQC-760054 07/06/06 By xufeng azf_file的index是azf_01(azf01,azf02),但是在抓‘中文說明’內容時，WHERE條件卻只有 azf01 = g_xxx
# Modify.........: NO.TQC-760096 07/06/21 BY yiting oga30更新時抓取出貨單號錯誤
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-750014 07/08/14 By pengu 庫存轉換率異常
# Modify.........; no.MOD-780191 07/08/29 by Yiting 拋轉時需檢查單別設定是否齊全
# Modify.........: NO.FUN-780025 07/08/31 BY yiting 拋轉出貨單時應一併拋轉ogbb_file
# Modify.........: No.MOD-780264 07/08/31 By Claire 未回寫呆滯日期 
# MOdify.........: No.CHI-790001 07/09/02 By Nicole 修正Insert Into ogd_file Error
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: NO.MOD-790154 07/10/09 BY claire 回寫ima74最近出庫日及ima73最近入庫日
# Modify.........: No.MOD-7A0051 07/10/09 By Claire Invoice單身應以(計價數量*單價)而非(數量*單價)
# Modify.........: No.MOD-7A0156 07/10/25 By Claire oga30,oga903,ogamksg拋至下站時,要給來源站的值
# Modify.........: No.FUN-7B0091 07/11/19 By Sarah oga65預設值抓oea65
# Modify.........: NO.MOD-7B0187 07/11/21 BY claire 送貨址址碼(oga044) 價格條件(oga31) 起運地(oga41) 到達地(oga42) 交運方式(oga43) 嘜頭編號(oga44) 皆改為取自出貨單
# Modify.........: No.TQC-7B0083 07/11/23 By Carrier rvv88給default值
# Modify.........: NO.TQC-7C0074 07/12/07 by fangyan 增加出貨單號的開窗查詢
# Modify.........: No.TQC-7C0064 07/12/07 By Beryl 拋轉時判斷拋轉單別是否在拋轉的資料庫中存在
# Modify.........: NO.MOD-7C0052 07/12/08 BY claire 中斷點的收貨單rvb22寫入流程代碼
# Modify.........: NO.CHI-7B0041 07/12/09 BY claire (1)中斷點的出貨單不可拋轉
#                                                   (2)中斷點的收貨單可收貨數rvb31不應為0 
# Modify.........: NO.TQC-7C0074 07/12/12 by fangyan 重新建立開窗查詢條件
# Modify.........: NO.TQC-7C0157 07/12/20 BY yiting 依站別取單別時 取法有誤 
# Modify.........: No.MOD-7C0189 07/12/25 By claire ofb34取ofa011即可
# Modify.........: NO.MOD-810014 08/01/03 BY claire (1) pmn50回寫條件錯誤
#                                                   (2) 中斷點不需回寫入庫量
# Modify.........: No.MOD-810077 08/01/11 By claire 拋轉前先確認出通單是否已拋轉完成
# Modify.........: No.MOD-810094 08/01/11 By claire 合併出貨拋轉訂單資料有問題
# Modify.........: No.MOD-810133 08/01/17 By claire 語法錯誤
# Modify.........: No.MOD-810255 08/01/30 By claire 合併出貨在中斷點產生的收貨單單身只有一筆資料
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-810179 08/03/18 By claire 對img09要重計轉換率(ogb15_fac,rvv35_fac)
# Modify.........: No.MOD-820061 08/03/18 By claire 合併出貨在中斷點產生的收貨單單身應重取流程序號
# Modify.........: No.MOD-840045 08/04/08 By claire 對img09要重計轉換率(ogb15_fac,rvv35_fac),若為二站代採逆拋時
# Modify.........: No.MOD-850062 08/05/08 By claire 回寫oea62條件值錯誤
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-860040 08/06/10 By claire 若為2站代採逆拋時,tlf12為空值
# Modify.........: No.TQC-870035 08/07/24 By claire axm-026改為axm-934
# Modify.........: No.MOD-880187 08/08/22 By lumx 當取不到雙單位的換算率時候 則讓拋磚不成功
#                                                 img_cs沒有close
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting完善報錯訊息匯總
# Modify.........: No.MOD-8A0165 08/10/27 By cliare 稅別要以出貨各站為主非來源站資料
# Modify.........: No.CHI-8B0047 09/01/14 By xiaofeizhu 正拋時不詢問是否自動產生出貨單，逆拋時才開窗詢問
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-910042 09/01/16 By cliare 調整條件
# Modify.........: No.MOD-920261 09/02/20 By claire ogb930值應以原訂單資料為來源
# Modify.........: No.MOD-930235 09/03/23 By Dido 無論是否有檢驗 rvb33 允收數量都必須要產生
# Modify.........: No.MOD-940204 09/04/15 By Dido 調整 ofa211/ofa212/ofa213 預設值
# Modify.........: No.TQC-950001 09/05/02 By Dido 增加 rvbs13 為 0
# Modify.........: No.MOD-940299 09/05/07 By Dido 科目別改用多角流程設定
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()   
# Modify.........: No.FUN-940083 09/05/20 By zhaijie調整批處理賦值   
# Modify.........: No.MOD-960029 09/06/04 By Dido 判斷 oga09 應考量若 p_oga09 為 null 請況改用 tm.oga09 判斷
# Modify.........: No.CHI-960012 09/06/10 By Dido 出貨理由碼抓取原理由碼
# Modify.........: No.MOD-960241 09/06/22 By Dido 代採出貨INVOICE單送貨客戶應為前一站資料
# Modify.........: No.MOD-960342 09/07/06 By Dido 送貨客戶應以單頭為主
# Modify.........: No.MOD-970042 09/07/06 By Dido 若為多倉儲時,rvbs022 應累增
# Modify.........: No.MOD-970048 09/07/07 By Dido 若為兩站時,rvv35會帶不到單位
# Modify.........: No.MOD-980058 09/08/10 By Dido tlf111 日期傳遞錯誤
# Modify.........: No.TQC-980083 09/08/11 By Dido 判斷 tlfs09 語法有誤  
# Modify.........: No.MOD-980127 09/08/17 By Dido p900_ogbins/p900_rvbins 抓取 img_file 改用 l_ima25
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun s_mupimg傳參修改營運中心改成機構別
# Modify.........: No.MOD-980118 09/08/28 By Dido 訂單變更單價後更新最終站出貨單單價與金額
# Modify.........: No.FUN-980010 09/08/31 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-8C0125 09/09/09 By chenmoyan INVOICE單別從apmi000中抓
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980059 09/09/09 By arman GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-8C0125 09/09/10 By chenmoyan 將l_sql2定義為STRING型
# Modify.........: No.FUN-980059 09/09/11 By arman  GP5.2架構,修改SUB傳入參數
# Modify.........: No.MOD-990172 09/09/18 By Dido 入庫單轉換率邏輯調整     
# Modify.........: No.FUN-980092 09/09/21 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-970041 09/10/05 By Dido 中斷點之檢驗否(rvb39)應參考該站料件設定
# Modify.........: No.MOD-990091 09/10/09 By mike 增加訂單項次      
# Modify.........: No.CHI-9A0040 09/10/20 By Dido rvbs06已為庫存數量,轉換率應採新舊庫存轉換率計算 
# Modify.........: No.TQC-9A0102 09/10/20 By Dido tlfs07重新抓取,tlfs13庫存數量計算調整 
# Modify.........: No.CHI-950020 09/10/21 By chenmoyan 将自定义栏位的值抛转各站
# Modify.........: No.MOD-9A0138 09/10/26 By Dido 若訂單對應多張出通語法有誤,應直接取此出貨之出通單即可 
# Modify.........: No.CHI-9B0008 09/11/11 By Dido 增加拋轉 tlf930
# Modify.........: No.MOD-9B0100 09/11/17 By Dido 語法調整 
# Modify.........: No.TQC-9B0233 09/11/30 By jan 語法調整 
# Modify.........: No:TQC-9B0013 09/11/27 By Dido 單別於建檔刪除後,應控卡不可產生拋轉
# Modify.........: No:TQC-9C0099 09/12/16 By jan s_umfchkm參數調整
# Modify.........: No:MOD-9C0210 09/12/19 By sherry s_umfchkm參數調整
# Modify.........: No:MOD-9C0274 09/12/22 By Dido 相關 l_sql 應改為 STRING 
# Modify.........: No:MOD-9C0298 09/12/25 By jan 修改程序BUG(漏寫mark符號)
# Modify.........: No:FUN-9C0073 10/01/06 By chenls 精簡程序
# Modify.........: No.FUN-A10036 10/01/18 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:CHI-940042 10/01/19 By Dido 參考 oea18 設定出貨與invoice匯率 
# Modify.........: No:FUN-A10099 10/01/18 By Carrier atmt254時,不能有影響transaction的語句
# Modify.........: No:MOD-A30108 10/03/16 By Smapmin 修改transaction架構
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:MOD-A40042 10/04/14 By Smapmin ogb15_fac的值沒有重新給予,導致tlf12的值錯誤
# Modify.........: No.FUN-A50102 10/06/18 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60076 10/06/28 By vealxu 製造功能優化-平行制程（批量修改） 
# Modify.........: No:MOD-A70175 10/07/23 By Smapmin rvv35單位帶錯
# Modify.........: No:MOD-A90029 10/09/13 By Smapmin 出貨單拋轉時,若單別為不產生帳款,則相對的入庫單樣品否要打勾.
# Modify.........: No:MOD-AA0024 10/10/22 By Smapmin 加強包裝單不存在或包裝單未確認的訊息顯示
# Modify.........: No.FUN-AB0061 10/11/16 By chenying 銷退單加基礎單價字段ohb37
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AA0023 10/12/14 By lixia 調撥調用時，給入庫單倉儲批賦默認值
# Modify.........: No:MOD-AC0147 10/12/21 By Smapmin 入庫品名改抓採購品名
# Modify.........: No.FUN-AC0055 10/12/21 By suncx 取消預設ohb71值，新增oha55欄位預設值
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No.MOD-B30584 11/03/11 By chenying 填充收貨檔時，rvb90應給原採購單位
# Modify.........: No.FUN-AB0023 11/03/17 By Lilan EF整合功能(EasyFlow)
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B60103 11/06/13 By zhangll 取消冗余程序段
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:MOD-B70272 11/08/17 By johung 出貨單tlf19應用oga03
# Modify.........: No:MOD-B80234 11/09/02 By johung 原因碼不需判斷aza50='Y'才給值
# Modify.........: No:FUN-B90012 11/09/15 By lixh1 增加多角ICD行業
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No:FUN-BB0083 11/11/21 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-BB0086 11/11/30 By tanxc 增加數量欄位小數取位
# Modify.........: No.FUN-BB0001 12/01/11 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No.CHI-BB0031 12/01/11 By jason 出貨單由來原營運中心拋到目的運中心時，倉儲批應該與目的一致
# Modify.........: No:MOD-C10097 12/02/08 By Summer MOD-960342的修正應該只針對銷售段,代採應該給還是給oea04 
# Modify.........: No:MOD-C10124 12/02/15 By suncx 最終出貨單檢驗否欄位從訂單抓取
# Modify.........: No:MOD-C20156 12/02/17 By Vampire FOREACH前沒有跑到DECLARE段,另拋轉還原也要刪除rvbs_file
# Modify.........: No:MOD-C30663 12/03/14 By ck2yuan tlfs07單位應寫img09
# Modify.........: No:MOD-C30877 12/04/10 By ck2yuan 更新ima73 ima74應一併更新ima29
# Modify.........: No:MOD-C50021 12/05/07 By Elise 入庫單自動確認時,因確認碼(rvaconf)為Y,簽核狀況碼(rva32)應該給1已核准
# Modify.........: No:MOD-C50031 12/05/08 By Elise 多角代採逆拋時，來源廠跟目的廠的庫存單位不同，會造成img的數量更新錯誤
# Modify.........: No.CHI-C40031 12/05/24 By Sakura 走多倉出貨改為抓取ogc、ogg轉換率
# Modify.........: No:FUN-C40072 12/05/29 By Sakura 排除需簽收的出貨單不拋轉(oga65='Y'),出貨單/簽收單傳入參數值修改
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52 #并入处理TQC-C70078            
# Modify.........: No.FUN-C50136 12/08/14 BY xianghui 出貨單逆拋時，如果有做信用管控，則需進行對oib_file,oic_file進行處理
# Modify.........: No.CHI-C80009 12/08/30 By Sakura 還原FUN-C40072 外部呼叫CALL p901_p2傳的參數值、transaction的判斷
# Modify.........: No.FUN-C80001 12/08/30 By bart 多角拋轉時，批號需一併拋轉sma96
# Modify.........: No.MOD-C80071 12/09/03 By Vampire CALL p900_imd(p_imd01,l_dbs_new)，附予g_imd10,g_imd11,g_imd12,g_imd13,g_imd14,g_imd15值
# Modify.........: No.FUN-CB0087 12/12/21 By xianghui 庫存理由碼改善
# Modify.........: No:MOD-CC0289 12/12/31 By SunLM 插入tlfcost时候,根据ccz28参数(成本计算方式)
# Modify.........: No:MOD-D10189 13/01/21 By SunLM tlf19/tlff19取值来源应该是oga03和oha03----->帐款客户编号
# Modify.........: No.MOD-CC0137 13/01/31 By jt_chen 代採逆拋,有中斷點,有最終供應商. 出貨單拋轉產生收貨單時rvb051未給值
# Modify.........: No.MOD-C80064 13/02/04 By Elise rvb88及rvb88t需做取位
# Modify.........: No.TQC-D20050 13/02/26 By xianghui 理由碼調整
# Modify.........: No.TQC-D20047 13/02/26 By xianghui 理由碼調整
# Modify.........: No.TQC-D20067 13/02/28 By xujing   理由碼調整
# Modify.........: No:FUN-BC0062 13/03/08 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:FUN-D10007 13/03/12 By Sakura 銷售正拋加上axms070,oax03重新取價判斷
# Modify.........: No.FUN-CC0157 13/03/20 By zm tlf920赋值(配合发出商品修改)
# Modify.........: No.MOD-D30187 13/03/24 By Vampire 當拋轉出貨單時，改為跨營運中心寫法，否則會抓不到入庫單資料，項次都會是1，導致Key重複
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08
# Modify.........: No:FUN-D20062 13/04/02 By jt_chen 季會決議：
#                                                    1.有效期限一併拋轉，已經存在的img有效期限就update 
#                                                    2.不能BY流程，維持用參數決定
#                                                    3.用參數pod08決定是否update img18有效期限
# Modify.........: No.MOD-D40101 13/04/16 By Vampire 當拋轉出貨單時，改為跨營運中心寫法，否則會抓不到入庫單資料，項次都會是1，導致Key重複
# Modify.........: No.MOD-D40139 13/04/19 By Vampire FOREACH ofb_cs INTO的變數與l_sql select的欄位不一致
# Modify.........: No.TQC-D40075 13/04/24 By SunLM 尾差調整
# Modify.........: No.TQC-D40064 13/06/19 By fengrui 理由碼調整
# Modify.........: No:MOD-D80197 13/08/29 By SunLM 出货单时候,将ogb41的值赋值给tlf20
# Modify.........: No:MOD-DA0106 13/10/16 By Vampire TQC-D40075 還原。如果apmi001中計價比例不為100%,就會出現價格數據錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea          RECORD LIKE oea_file.*
DEFINE g_oeb          RECORD LIKE oeb_file.*
DEFINE g_oga          RECORD LIKE oga_file.*    #出貨單(來源)
DEFINE g_ogb          RECORD LIKE ogb_file.*    #出貨單(來源)
DEFINE l_oga          RECORD LIKE oga_file.*    #出貨單(各廠)
DEFINE l_ogb          RECORD LIKE ogb_file.*    #出貨單(各廠)
DEFINE t_oga          RECORD LIKE oga_file.*    #出貨通知單(來源)
DEFINE t_ogb          RECORD LIKE ogb_file.*    #出貨通知單(來源)
DEFINE x_oga          RECORD LIKE oga_file.*    #出貨通知單(各廠)
DEFINE x_ogb          RECORD LIKE ogb_file.*    #出貨通知單(各廠)
DEFINE g_ogd          RECORD LIKE ogd_file.*
DEFINE g_ofa          RECORD LIKE ofa_file.*
DEFINE g_ofb          RECORD LIKE ofb_file.*
DEFINE l_oea          RECORD LIKE oea_file.*
DEFINE l_oeb          RECORD LIKE oeb_file.*
DEFINE l_rva          RECORD LIKE rva_file.*
DEFINE l_rvb          RECORD LIKE rvb_file.*
DEFINE l_rvu          RECORD LIKE rvu_file.*
DEFINE l_rvv          RECORD LIKE rvv_file.*
DEFINE g_pmm          RECORD LIKE pmm_file.*
DEFINE g_pmn          RECORD LIKE pmn_file.*
DEFINE g_oan          RECORD LIKE oan_file.*
DEFINE l_oha          RECORD LIKE oha_file.*    #NO.FUN-620024
DEFINE l_ohb          RECORD LIKE ohb_file.*    #NO.FUN-620024
DEFINE g_poz          RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8047
DEFINE g_poy          RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8047
DEFINE s_poy          RECORD LIKE poy_file.*    #來源流程資料(單身) No.8047
DEFINE n_poy          RECORD LIKE poy_file.*    #來源流程資料(單身) No.8047  #FUN-670007 
DEFINE tm             RECORD
                         oga09 LIKE oga_file.oga09,    #No.FUN-680137 VARCHAR(1)
                         wc    LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(600) 
                      END RECORD
DEFINE p_pmm09        LIKE pmm_file.pmm09,    #廠商代號
       p_oea03        LIKE oea_file.oea03,    #客戶代號
       g_imd10      LIKE imd_file.imd10,    #倉儲類別
       g_imd11      LIKE imd_file.imd11,    #是否為可用倉儲
       g_imd12      LIKE imd_file.imd12,    #MRP倉否
       g_imd13      LIKE imd_file.imd13,    #保稅否
       g_imd14      LIKE imd_file.imd14,    #生產發料順序
       g_imd15      LIKE imd_file.imd15,    #銷售出貨順序
       p_imd01        LIKE imd_file.imd01,    #各廠預設倉庫
       s_imd01        LIKE imd_file.imd01,    #各廠預設倉庫(來源)
       p_poy16        LIKE poy_file.poy16,    #AR科目類別 #MOD-940299                             
       p_poy28        LIKE poy_file.poy28,    #出貨理由碼 #NO.FUN-620024                             
       p_poy29        LIKE poy_file.poy29     #代送商編號 #NO.FUN-620024 
DEFINE g_flow99       LIKE oga_file.oga99     #No.FUN-680137 VARCHAR(17)   #多角序號    #FUN-560043
DEFINE g_oaz32        LIKE oaz_file.oaz32     #No.FUN-680137  VARCHAR(1)     #匯率方式
DEFINE s_dbs_new      LIKE type_file.chr21    #No.FUN-680137 VARCHAR(21)    #New DataBase Name
DEFINE s_dbs_source   LIKE type_file.chr21    #No.FUN-680137 VARCHAR(21)    #來源工廠
DEFINE l_dbs_new      LIKE type_file.chr21    #No.FUN-680137 VARCHAR(21)    #New DataBase Name
DEFINE l_plant_new    LIKE type_file.chr10    #No.FUN-980020
DEFINE s_plant_new    LIKE type_file.chr10    #下一站工廠
DEFINE s_dbs_new_tra  LIKE type_file.chr21    #下一站trans DB
DEFINE l_dbs_new_tra  LIKE type_file.chr21    #本  站trans DB
DEFINE l_aza          RECORD LIKE aza_file.*
DEFINE s_aza          RECORD LIKE aza_file.*
DEFINE s_azp          RECORD LIKE azp_file.*
DEFINE l_azp          RECORD LIKE azp_file.*
DEFINE l_azi          RECORD LIKE azi_file.*
DEFINE l_azi_p        RECORD LIKE azi_file.*   #MOD-6B0152 add
DEFINE g_sw           LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE g_argv1        LIKE oga_file.oga01
DEFINE g_argv2        LIKE oga_file.oga09
DEFINE p_last         LIKE type_file.num5    #No.FUN-680137 SMALLINT                #流程之最後家數
DEFINE p_last_plant   LIKE cre_file.cre08    #No.FUN-680137 VARCHAR(10)
DEFINE s_price        LIKE ogb_file.ogb13     #來源工廠單價
DEFINE s_oal11        LIKE oal_file.oal11     #記錄下游工廠計價方式
DEFINE s_oal12        LIKE oal_file.oal12     #記錄下游工廠計價方式
DEFINE g_t1           LIKE oay_file.oayslip                #No.FUN-550070  #No.FUN-680137 VARCHAR(05)
DEFINE l_t            LIKE oay_file.oayslip   #No.FUN-680137 VARCHAR(05)                #NO.FUN-620024 
DEFINE oga_t1         LIKE oay_file.oayslip   #No.FUN-680137 VARCHAR(5)
DEFINE rva_t1         LIKE oay_file.oayslip   #No.FUN-680137 VARCHAR(5)
DEFINE rvu_t1         LIKE oay_file.oayslip   #No.FUN-680137 VARCHAR(5)
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE g_ima906       LIKE ima_file.ima906   #FUN-560043
DEFINE g_oha01        LIKE oha_file.oha01    #銷退單號   #NO.FUN-620024
DEFINE g_oay18        LIKE oay_file.oay18    #銷退理由碼 #NO.FUN-620024
DEFINE g_cnt          LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE p_oga01        LIKE oga_file.oga01 #No.FUN-620054
DEFINE p_oga09        LIKE oga_file.oga09 #No.FUN-620054
DEFINE l_poy02        LIKE poy_file.poy02       #NO.FUN-670007
DEFINE l_c            LIKE type_file.num5       #No.FUN-680137 SMALLINT  #NO.FUN-670007
DEFINE g_oea99        LIKE oea_file.oea99 #MOD-740042  #合併訂單出貨
DEFINE l_ima29        LIKE ima_file.ima29    #MOD-790154 
DEFINE l_oga99        LIKE oga_file.oga99  #MOD-810077 add
DEFINE s_oga          RECORD LIKE oga_file.*    #出通單(各廠)  #MOD-790154
DEFINE g_fac          LIKE ogb_file.ogb15_fac, #MOD-810179 add
       g_unit         LIKE ogb_file.ogb15      #MOD-810179 add 
DEFINE g_ima918       LIKE ima_file.ima918  #No.FUN-850100
DEFINE g_ima921       LIKE ima_file.ima921  #No.FUN-850100
DEFINE l_rvbs         RECORD LIKE rvbs_file.*  #No.FUN-850100
DEFINE g_pmm01        LIKE pmm_file.pmm01      #CHI-8B0047
DEFINE g_pmm909       LIKE pmm_file.pmm909     #CHI-8B0047
DEFINE g_oea37        LIKE oea_file.oea37      #CHI-8B0047
DEFINE g_slip         LIKE oay_file.oayslip    #CHI-8B0047
DEFINE g_pmn24        LIKE pmn_file.pmn24      #CHI-8B0047
DEFINE begin_no       STRING                   #CHI-8B0047
DEFINE end_no         STRING                   #CHI-8B0047
DEFINE g_flag         LIKE type_file.chr10     #CHI-8B0047
DEFINE gp_plant   LIKE azp_file.azp01    #FUN-980010 add
DEFINE gp_legal   LIKE azw_file.azw02    #FUN-980010 add
DEFINE g_oay11        LIKE oay_file.oay11      #MOD-A90029
DEFINE g_ogg   RECORD LIKE ogg_file.*  #CHI-C40031 add
DEFINE g_ogc   RECORD LIKE ogc_file.*  #CHI-C40031 add
#FUN-D10007---add---START
DEFINE p_pox03  LIKE pox_file.pox03    #計價基準
DEFINE p_pox05  LIKE pox_file.pox05    #計價方式
DEFINE p_pox06  LIKE pox_file.pox06    #計價比率
DEFINE l_price  LIKE ogb_file.ogb13
DEFINE l_currm  LIKE pmm_file.pmm42    #計價幣別依原始來源廠的匯率
DEFINE t_dbs    LIKE type_file.chr21   #來源廠
DEFINE s_poy04  LIKE poy_file.poy04    #來源廠營運中心
DEFINE p_cnt    LIKE type_file.num5    #計價方式符合筆數
DEFINE l_curr   LIKE pmm_file.pmm22
#FUN-D10007---add-----END
DEFINE g_plant_ogb09  LIKE ogb_file.ogb09      #FUN-D20062 add  #來源站倉庫別
#yemy 20130530  --begin
DEFINE g_source_ogb09  LIKE ogb_file.ogb09 
DEFINE g_source_ogb091 LIKE ogb_file.ogb091
DEFINE g_source_ogb092 LIKE ogb_file.ogb092
#yemy 20130530  --End  

FUNCTION p900(p_argv1,p_argv2)
   DEFINE p_argv1     LIKE oga_file.oga01
   DEFINE p_argv2     LIKE oga_file.oga09
 
   WHENEVER ERROR CONTINUE
  
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
 
   CREATE TEMP TABLE p900_file(
       p_no        LIKE type_file.num5,  
       pab_no      LIKE oea_file.oea01, 
       pab_item    LIKE type_file.num5,  
       pab_price   LIKE type_file.num20_6)
      
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   #若有傳參數則不用輸入畫面
   IF cl_null(g_argv1) THEN 
      CALL p900_p1()
   ELSE
      LET tm.wc = " oga01='",g_argv1,"' " 
#FUN-C40072---add---START
      IF g_argv2 = '8' THEN
         LET g_argv2 ='4'
         LET tm.oga09 = g_argv2
      ELSE
#FUN-C40072---add-----END
         LET tm.oga09 = g_argv2
      END IF #FUN-C40072 add
 
      OPEN WINDOW win AT 10,5 WITH 6 ROWS,70 COLUMNS 
      CALL p900_p2('','','')        #No.FUN-620054            #FUN-C40072 mark #CHI-C80009 remark
     #CALL p900_p2(g_argv1,g_argv2,'')        #No.FUN-620054  #FUN-C40072 add  #CHI-C80009 mark
 
      DROP TABLE p900_file   #BUG-4C0064,MOD-4C0070
 
      CLOSE WINDOW win
   END IF
 
END FUNCTION
 
FUNCTION p900_p1()
   DEFINE l_flag   LIKE type_file.num5   #No.FUN-680137  SMALLINT
 
   LET p_row = 5 LET p_col = 16
 
   OPEN WINDOW p900_w AT p_row,p_col
     WITH FORM "axm/42f/axmp900"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   DISPLAY BY NAME tm.oga09
 
   WHILE TRUE
      LET g_action_choice = ''
      
      CONSTRUCT BY NAME tm.wc ON oga01,oga02 
      
      ON ACTION CONTROLP                                                                                                            
         CASE                                                                                                                       
           WHEN INFIELD(oga01)                                                                                                      
             CALL cl_init_qry_var() 
             LET g_qryparam.state = 'c'                                                                                                
             LET g_qryparam.form="q_oga101"  #add-by TQC-7C0074
             CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                                
             DISPLAY g_qryparam.multiret TO oga01                                                                                               
             NEXT FIELD oga01                                                                                                       
         END CASE       
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT CONSTRUCT
 
         ON ACTION exit
            LET INT_FLAG = 1
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
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
 
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         EXIT WHILE
      END IF
 
      INPUT BY NAME tm.oga09 WITHOUT DEFAULTS 
 
         AFTER FIELD oga09
            IF cl_null(tm.oga09) THEN
               NEXT FIELD oga09
            END IF
            IF tm.oga09 NOT MATCHES '[46]' THEN
               NEXT FIELD oga09 
            END IF
            #取得多角貿易使用匯率
            IF tm.oga09 = '4' THEN
               LET g_oaz32 = g_oax.oax01     
            ELSE
               SELECT pod01 INTO g_oaz32 FROM pod_file
                WHERE pod00 = '0'
            END IF
            IF cl_null(g_oaz32) THEN 
               LET g_oaz32 = 'S'
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         
         ON ACTION CONTROLG 
            CALL cl_cmdask()
         
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT INPUT
         
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      IF cl_sure(0,0) THEN 
         CALL p900_p2('','','')        #No.FUN-620054
         IF g_success = 'Y' THEN
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            CALL cl_end2(2) RETURNING l_flag
         END IF
 
         IF l_flag THEN 
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
   END WHILE
 
   CLOSE WINDOW p900_w
 
END FUNCTION 
 
FUNCTION p900_p2(p_oga01,p_oga09,p_plant)  #FUN-980092 add
   DEFINE l_ogb01    LIKE ogb_file.ogb01  #MOD-620053 add
   DEFINE l_ogb03    LIKE ogb_file.ogb03  #MOD-620053 add
   DEFINE l_ogb31    LIKE ogb_file.ogb31  #MOD-620053 add
   DEFINE l_ogb32    LIKE ogb_file.ogb32  #MOD-620053 add
   DEFINE l_tlf99    LIKE tlf_file.tlf99  #MOD-620053 add
   DEFINE p_oga01            LIKE oga_file.oga01 #No.FUN-620054
   DEFINE l_ogb04    LIKE ogb_file.ogb04  #MOD-720030 add
   DEFINE p_oga09            LIKE oga_file.oga09 #No.FUN-620054
   DEFINE p_dbs       LIKE type_file.chr21  #No.FUN-680137    VARCHAR(21)            #No.FUN-620054
   DEFINE l_pmm       RECORD LIKE pmm_file.*
   DEFINE l_pmn       RECORD LIKE pmn_file.*
   DEFINE l_occ       RECORD LIKE occ_file.*
   DEFINE l_pmc       RECORD LIKE pmc_file.*
   DEFINE l_oal       RECORD LIKE oal_file.*
   DEFINE l_oam       RECORD LIKE oam_file.*
   DEFINE l_gec       RECORD LIKE gec_file.*
   DEFINE l_ima       RECORD LIKE ima_file.*
   DEFINE #l_sql       LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
           l_sql,l_sql1,l_sql2       STRING     #No.FUN-910082
   DEFINE i,l_i       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE o_oal11     LIKE oal_file.oal11     #計價方式
   DEFINE diff_azi    LIKE type_file.chr1,    #若為Y表示單身計價方式有所不同 #No.FUN-680137 VARCHAR(1)
          l_cnt       LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          azi_oal11   LIKE oal_file.oal11,   #記錄單頭該用之計價方式
          min_oeb15   LIKE oeb_file.oeb15    #記錄該訂單之最小預交日
   DEFINE l_j         LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_msg       LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(60)
   DEFINE l_oea62     LIKE oea_file.oea62
   DEFINE s_oea62     LIKE oea_file.oea62
   DEFINE l_oeb24     LIKE oeb_file.oeb24 
   DEFINE l_x         LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5) #No.FUN-550070
   DEFINE p_oeb       RECORD LIKE oeb_file.*  
   DEFINE l_ogd01     LIKE ogd_file.ogd01       #包裝單號
   DEFINE g_ogd01     LIKE ogd_file.ogd01       #包裝單號
   DEFINE l_ofa01     LIKE ofa_file.ofa01       #INVOICE 單號
   DEFINE l_slip      LIKE ofa_file.ofa01       #INVOICE 單號
   DEFINE li_result   LIKE type_file.num5       #FUN-560043  #No.FUN-680137 SMALLINT
   DEFINE l_oga01     LIKE oga_file.oga01       #FUN-630053 add
   DEFINE l_poz01     LIKE poz_file.poz01,
          l_poz18     LIKE poz_file.poz18,
          l_poz19     LIKE poz_file.poz19,
          l_c1        LIKE type_file.num5
   DEFINE k           LIKE type_file.num5   #NO.TQC-7C0157
 
   DEFINE p_plant     LIKE azp_file.azp01  #FUN-980092 add
   DEFINE p_dbs_tra   LIKE type_file.chr21 #FUN-980092 add
 
   LET g_plant_new = p_plant
   CALL s_getdbs()     LET p_dbs     = g_dbs_new
   CALL s_gettrandbs() LET p_dbs_tra = g_dbs_tra
 
   #取得多角貿易使用匯率
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      IF tm.oga09 = '4' THEN
         LET g_oaz32 = g_oax.oax01    #NO.FUN-670007
      ELSE
         SELECT pod01 INTO g_oaz32 FROM pod_file
          WHERE pod00 = '0'
      END IF
   ELSE
      IF tm.oga09 = '4' THEN
         LET g_oaz32= g_oax.oax01    #NO.FUN-670007
      ELSE
         LET l_sql = "SELECT pod01 ",
                     #"  FROM ",p_dbs CLIPPED,"pod_file ",
                     "  FROM ",cl_get_target_table(p_plant,'pod_file'),  #FUN-A50102
                     " WHERE pod00 = '0' "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
         PREPARE pod01_pre FROM l_sql
         EXECUTE pod01_pre INTO g_oaz32
      END IF
   END IF
   
   IF cl_null(g_oaz32) THEN
      LET g_oaz32 = 'S'
   END IF
   
   CALL cl_wait() 
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN #FUN-C40072 mark #CHI-C80009 remark
      BEGIN WORK 
   END IF                                       #FUN-C40072 mark #CHI-C80009 remark
   LET g_success='Y'
 
   IF g_prog <> 'atmt254' THEN  #No.FUN-A10099 
      DELETE FROM p900_file
   END IF                       #No.FUN-A10099
   LET g_cnt=0
 
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      LET l_sql= "SELECT COUNT(*) FROM oga_file ",
                 " WHERE oga909='Y' ",    #三角貿易出貨單
                 "   AND oga905='N'  ",    #拋轉否
                 "   AND oga906='Y' ",     #必須為起始出貨單
                 "   AND ogaconf='Y' ",    #必須為已確認單
                 "   AND ogapost='Y' ",    #已出貨扣帳No.8047
                 "   AND oga65='N'   ",    #不需簽收的出貨單 #FUN-C40072 add
                 "   AND ",tm.wc CLIPPED
   
#FUN-C40072---add---START
      IF tm.oga09 = '4' THEN
         LET l_sql = l_sql CLIPPED, " AND oga09 IN ('4','8')"
      ELSE
#FUN-C40072---add-----END
         LET l_sql = l_sql CLIPPED, " AND oga09 = '",tm.oga09,"'"  #No.8047
      END IF #FUN-C40072 add
   ELSE
      #LET l_sql= "SELECT COUNT(*) FROM ",p_dbs_tra CLIPPED,"oga_file ", #FUN-980092 add
      LET l_sql= "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'oga_file'),  #FUN-A50102
                 " WHERE oga909='Y' ",    #三角貿易出貨單
                 "   AND oga905='N'  ",    #拋轉否
                 "   AND oga906='Y' ",     #必須為起始出貨單
                 "   AND ogaconf='Y' ",    #必須為已確認單
                 "   AND oga65='N'   ",    #不需簽收的出貨單 #FUN-C40072 add
                 "   AND oga01 = '",p_oga01,"' "
                #"   AND oga09 = '",p_oga09,"' "   #FUN-C40072 mark
   END IF
   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
   PREPARE p900_p2 FROM l_sql
   DECLARE p900_curs2 CURSOR FOR p900_p2
   
   OPEN p900_curs2
   FETCH p900_curs2 INTO g_cnt
   CLOSE p900_curs2
   
   IF g_cnt=0 THEN
      LET g_success = 'N'   #FUN-560043
      CALL cl_err('','mfg9169',1) 
      #-----MOD-A30108---------
      IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
         ROLLBACK WORK  
      END IF
      #-----END MOD-A30108-----
      RETURN
   END IF
   
   #讀取符合條件之三角貿易訂單資料
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      LET l_sql= "SELECT * FROM oga_file ",
                 " WHERE oga909='Y' ",    #三角貿易出貨單
                 "   AND oga905='N'  ",    #拋轉否
                 "   AND oga906='Y' ",     #必須為起始出貨單
                 "   AND ogaconf='Y' ",    #必須為已確認單
                 "   AND ogapost='Y' ",    #已出貨扣帳No.8047
                 "   AND oga65='N'   ",    #不需簽收的出貨單 #FUN-C40072 add
                 "   AND ",tm.wc CLIPPED
   
#FUN-C40072---add---START
      IF tm.oga09 = '4' THEN
         LET l_sql = l_sql CLIPPED, " AND oga09 IN ('4','8')"
      ELSE
#FUN-C40072---add-----END
         LET l_sql = l_sql CLIPPED, " AND oga09 = '",tm.oga09,"'"  #No.8047
      END IF #FUN-C40072 add
   ELSE
      #LET l_sql= "SELECT * FROM ",p_dbs_tra CLIPPED,"oga_file ", #FUN-980092 add
      LET l_sql= "SELECT * FROM ",cl_get_target_table(p_plant,'oga_file'),  #FUN-A50102
                 " WHERE oga909='Y' ",    #三角貿易出貨單
                 "   AND oga905='N'  ",    #拋轉否
                 "   AND oga906='Y' ",     #必須為起始出貨單
                 "   AND ogaconf='Y' ",    #必須為已確認單
                 "   AND oga65='N'   ",    #不需簽收的出貨單 #FUN-C40072 add
                 "   AND oga01 = '",p_oga01,"' "
                #"   AND oga09 = '",p_oga09,"' " #FUN-C40072 mark
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
   END IF   
 	
   PREPARE p900_p1 FROM l_sql 
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'           #No.FUN-8A0086 
      CALL cl_err('pre1',SQLCA.SQLCODE,1) 
   END IF
   
   DECLARE p900_curs1 CURSOR FOR p900_p1
   FOREACH p900_curs1 INTO g_oga.*
#FUN-C40072---add---START
   IF g_oga.oga09 = '8' THEN
      LET g_oga.oga09 = '4'
   END IF
#FUN-C40072---add-----END
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
      IF SQLCA.SQLCODE <> 0 THEN
         LET g_success = 'N'                #No.FUN-8A0086
         EXIT FOREACH
      END IF
   
      IF cl_null(g_oga.oga16) THEN     #modi in 00/02/24 by kammy
         #只讀取第一筆訂單之資料
         IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
            LET l_sql1= " SELECT * FROM oea_file,ogb_file ",
                        "  WHERE oea01 = ogb31 ",
                        "    AND ogb01 = '",g_oga.oga01,"'"
         ELSE
            LET l_sql1= " SELECT * ",
                        #"   FROM ",p_dbs_tra CLIPPED,"oea_file,", #FUN-980092 add
                        #           p_dbs_tra CLIPPED,"ogb_file ", #FUN-980092 add
                        "   FROM ",cl_get_target_table(p_plant,'oea_file'),",",  #FUN-A50102
                                   cl_get_target_table(p_plant,'ogb_file'),      #FUN-A50102
                        "  WHERE oea01 = ogb31 ",
                        "    AND ogb01 = '",g_oga.oga01,"'"            
         END IF
         LET l_sql1= l_sql1 CLIPPED," ORDER BY ogb03" #MOD-810255 add
 	     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092 add
         PREPARE oea_pre FROM l_sql1
 
         DECLARE oea_f CURSOR FOR oea_pre
         OPEN oea_f
         FETCH oea_f INTO g_oea.*
      ELSE
         #讀取該出貨單之訂單
         IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
            SELECT * INTO g_oea.*
              FROM oea_file
             WHERE oea01 = g_oga.oga16
         ELSE
            LET l_sql1 = " SELECT * ",
                         #"   FROM ",p_dbs_tra CLIPPED,"oea_file ", #FUN-980092 add
                         "   FROM ",cl_get_target_table(p_plant,'oea_file'),      #FUN-A50102
                         "  WHERE oea01 = '",g_oga.oga16,"' "
 	        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
            CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092 add
            PREPARE oea_pre2 FROM l_sql1
            EXECUTE oea_pre2 INTO g_oea.*
         END IF
      END IF
 
     #判斷出通單拋轉完成才可以繼續作業
     #No.FUN-A10099  --Begin
     IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
        SELECT occ56 INTO l_occ.occ56 FROM occ_file
         WHERE occ01 = g_oea.oea03 
        SELECT oga99 INTO l_oga99 FROM oga_file
         WHERE oga01 = g_oga.oga011 
           AND oga09 = '5'
     ELSE
        #LET l_sql1 = " SELECT occ56 FROM ",p_dbs CLIPPED,"occ_file ",
        LET l_sql1 = " SELECT occ56 FROM ",cl_get_target_table(p_plant,'occ_file'),      #FUN-A50102
                     "  WHERE occ01 = '",g_oea.oea03,"' "
        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
        CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
        PREPARE occ_pp1 FROM l_sql1
        EXECUTE occ_pp1 INTO l_occ.occ56

        #LET l_sql1 = " SELECT oga99 FROM ",p_dbs_tra CLIPPED,"oga_file ",
        LET l_sql1 = " SELECT oga99 FROM ",cl_get_target_table(p_plant,'oga_file'),      #FUN-A50102
                     "  WHERE oga01 = '",g_oga.oga011,"'", 
                     "    AND oga09 = '5' "
        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
        CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1
        PREPARE oga_pp1 FROM l_sql1
        EXECUTE oga_pp1 INTO l_oga99
     END IF
     #No.FUN-A10099  --End   
     IF l_occ.occ56 = 'Y' THEN   #勾選需製作出貨通知單
        IF cl_null(l_oga99) THEN
           IF g_bgerr THEN
              CALL s_errmsg('oga011',g_oga.oga011,' ','axm-951',1)  
           END IF
           LET g_success = 'N'
            CONTINUE FOREACH                          
        END IF
     END IF 
 
     #判斷是否為中斷點
      SELECT poz01,poz18,poz19 INTO l_poz01,l_poz18,l_poz19  
        FROM poz_file
       WHERE poz01  = g_oea.oea904
      
      LET l_c1 = 0
     IF l_poz19 = 'Y'  AND g_plant=l_poz18 THEN    #已設立中斷點
         SELECT COUNT(*) INTO l_c1   #check poz18設定的中斷營運中心是否存在單身設>
           FROM poy_file
         WHERE poy01 = l_poz01
           AND poy04 = l_poz18
     END IF 
     IF l_c1 > 0 THEN
        IF g_bgerr THEN
          CALL s_errmsg('oga01',g_oga.oga01,' ','axm-950',1)  
        END IF
         LET g_success = 'N'
         CONTINUE FOREACH                          
     END IF
 
   
      IF g_oea.oea902 = 'N' THEN
         IF g_bgerr THEN
           CALL s_errmsg('oea01',g_oga.oga16,' ','axm-934',1)   #TQC-870035 modify  
         ELSE
           CALL cl_err('','axm-934',1)   #TQC-870035 modify
         END IF 
         LET g_success = 'N'
         CONTINUE FOREACH                         #NO.FUN-710046    
      END IF
   
   
      #no.6158檢查各工廠關帳日(sma53)
      IF s_mchksma53(g_oea.oea904,g_oga.oga02) THEN
        IF g_bgerr THEN
          CALL s_errmsg('oea01',g_oga.oga16,' ','axm-026',1)  
        END IF
         LET g_success = 'N'
         CONTINUE FOREACH                         #NO.FUN-710046    
      END IF
   
      #讀取三角貿易流程代碼資料
      SELECT * INTO g_poz.*
        FROM poz_file
       WHERE poz01=g_oea.oea904
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
           CALL s_errmsg('poz01',g_oea.oea904,g_oea.oea904,'axm-318',1)   
         ELSE
           CALL cl_err3("sel","poz_file",g_oea.oea904,"","axm-318","","",0)  
         END IF
         LET g_success = 'N'
         CONTINUE FOREACH                         #NO.FUN-710046    
      END IF
 
      IF tm.oga09 = '4' AND g_poz.poz00='2' THEN
         IF g_bgerr THEN
           CALL s_errmsg('poz01',g_oea.oea904,g_oea.oea904,'tri-008',1) 
         ELSE 
           CALL cl_err(g_oea.oea904,'tri-008',1) 
         END IF
         LET g_success = 'N'
         CONTINUE FOREACH                         #NO.FUN-710046    
      END IF
   
      IF tm.oga09 = '6' AND g_poz.poz00='1' THEN
         IF g_bgerr THEN
           CALL s_errmsg('poz01',g_oea.oea904,g_oea.oea904,'tri-008',1)    
         ELSE 
           CALL cl_err(g_oea.oea904,'tri-008',1)
         END IF
         LET g_success = 'N'
         CONTINUE FOREACH                         #NO.FUN-710046    
      END IF
   
      IF g_poz.pozacti = 'N' THEN 
         IF g_bgerr THEN
           CALL s_errmsg('poz01',g_oea.oea904,g_oea.oea904,'tri-009',1)  
         ELSE
           CALL cl_err(g_oea.oea904,'tri-009',1) 
         END IF
         LET g_success = 'N'
         CONTINUE FOREACH                         #NO.FUN-710046    
      END IF
   
      IF g_poz.poz011 = '1' THEN
         IF g_bgerr THEN
           CALL s_errmsg('poz01',g_oea.oea904,' ','axm-412',1)    
         ELSE 
           CALL cl_err('','axm-412',1) 
         END IF
         LET g_success = 'N'
         CONTINUE FOREACH                         #NO.FUN-710046    
      END IF
   
      #no.4526抓取單別拋轉設定檔
   
      CALL p900_flow99()                           #No.8047 取得多角序號
      IF NOT cl_null(p_oga01) AND NOT cl_null(p_oga09) THEN
         IF cl_null(g_flow99) THEN 
            LET g_flow99 = g_oga.oga99
            LET tm.oga09 = p_oga09
         END IF
      END IF
   
      CALL s_mtrade_last_plant(g_oea.oea904) 
                     RETURNING p_last,p_last_plant    #記錄最後一筆之家數
   
      IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
         IF p_last_plant != g_plant THEN
            IF g_bgerr THEN
              CALL s_errmsg(' ',' ','','axm-410',1)  
            ELSE 
              CALL cl_err('','axm-410',1)
            END IF
            CLOSE WINDOW p900_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
      END IF
 
      LET s_oea62=0

      #-----MOD-A90029---------
      LET g_oay11 = NULL
      LET g_t1 = s_get_doc_no(g_oga.oga01)
      SELECT oay11 INTO g_oay11 FROM oay_file
        WHERE oayslip = g_t1 
      #-----END MOD-A90029-----   
   
      #依流程代碼最多6層
      FOR i = p_last TO 0 STEP -1  
         LET k = i + 1                  #NO.TQC-7C0157
         #因為反相拋轉，銷售段來源廠必須 insert 一筆出貨單(採購段不用)
         ##若為最終工廠則不須再 insert 出貨單，只需更新來源銷單之出貨量
         IF i = p_last THEN  
           CONTINUE FOR  
         END IF
   
         #得到廠商/客戶代碼及database
         CALL p900_azp(i)
 
          LET gp_plant = g_poy.poy04                    #FUN-980010 add
          CALL s_getlegal(gp_plant) RETURNING gp_legal  #FUN-980010 add
 
         CALL p900_chk99()            #No.8047       
         CALL p900_azi(g_oea.oea23)   #讀取幣別資料
        #FUN-D10007---add---START
         CALL s_pox(g_oea.oea904,i,g_oga.oga02)
              RETURNING p_pox03,p_pox05,p_pox06,p_cnt
        #FUN-D10007---add-----END         
 
         #LET l_sql2 = "INSERT INTO ",l_dbs_new_tra CLIPPED,"rvbs_file", #FUN-980092 add
         LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'rvbs_file'), #FUN-A50102
                      "(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03,",
                      " rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09,rvbs13,",  #TQC-950001
                      " rvbsplant,rvbslegal) ",  #FUN-980010 #TQC-9B0233
                      " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,  ?,?) "     #TQC-950001    #FUN-980010
 
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
         PREPARE ins_rvbs FROM l_sql2
 
             LET g_t1 = s_get_doc_no(g_oga.oga01)         #No.FUN-550070
             CALL s_mutislip('1','1',g_t1,g_poz.poz01,i)                      
                 RETURNING g_sw,oga_t1,l_x,l_x,l_x,l_x  #no.TQC-7C0157
             IF g_sw THEN 
                 IF g_bgerr THEN   
                 CALL s_errmsg(' ',' ',' ',SQLCA.sqlcode,1) 
                 END IF
                 LET g_success = 'N'
                 EXIT FOREACH 
             END IF 
             #取收貨/入庫單單別-------
             CALL s_mutislip('1','1',g_t1,g_poz.poz01,k)                      
                 RETURNING g_sw,l_x,rva_t1,rvu_t1,l_x,l_x 
             IF g_sw THEN 
                 IF g_bgerr THEN   
                 CALL s_errmsg(' ',' ',' ',SQLCA.sqlcode,1) 
                 END IF
                 LET g_success = 'N'
                 EXIT FOREACH 
             END IF 
            
             IF g_poz.poz00 != '2' AND i <> 0 THEN   #NO.TQC-7C0157 add代採段第0站無出貨單資料，不需檢查
                 IF cl_null(oga_t1) THEN
                     LET g_msg = l_dbs_new CLIPPED,oga_t1 CLIPPED
                     IF g_bgerr THEN
                        CALL s_errmsg("","","g_msg",'axm4012',1)
                     ELSE
                        CALL cl_err3("","","","",'axm4012',"","g_msg",1)
                     END IF
                     LET g_success = 'N'
                     EXIT FOREACH
                 ELSE
                    LET l_cnt = 0 
                    #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"oay_file ",
                    LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102
                                " WHERE oayslip = '",oga_t1,"'"
 	                CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                    PREPARE oay_pre1 FROM l_sql
                    EXECUTE oay_pre1 INTO l_cnt
                    IF l_cnt = 0 THEN
                       LET g_msg = l_dbs_new CLIPPED,oga_t1 CLIPPED
                       IF g_bgerr THEN                                            
                          CALL s_errmsg("","","g_msg",'axm-931',1)                
                       ELSE                                                       
                          CALL cl_err3("","","","",'axm-931',"","g_msg",1)        
                       END IF 
                       LET g_success = 'N'
                       EXIT FOREACH
                    END IF
                 END IF
             END IF                        #no.TQC-7C0157 add
             IF cl_null(rva_t1) THEN
                 LET g_msg = l_dbs_new CLIPPED,rva_t1 CLIPPED
                 IF g_bgerr THEN
                    CALL s_errmsg("","","g_msg",'axm4013',1)
                 ELSE
                    CALL cl_err3("","","","",'axm4013',"","g_msg",1)
                 END IF
                 LET g_success = 'N'
                 EXIT FOREACH
             ELSE
                LET l_cnt = 0 
                #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"smy_file ",
                LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'smy_file'), #FUN-A50102
                            " WHERE smyslip = '",rva_t1,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                PREPARE smy_pre1 FROM l_sql
                EXECUTE smy_pre1 INTO l_cnt
                IF l_cnt = 0 THEN
                   LET g_msg = l_dbs_new CLIPPED,rva_t1 CLIPPED
                   IF g_bgerr THEN       
                      CALL s_errmsg("","","g_msg",'axm-931',1)                
                   ELSE                                                       
                      CALL cl_err3("","","","",'axm-931',"","g_msg",1)        
                   END IF 
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF
             END IF
             IF NOT cl_null(rvu_t1) THEN
                LET l_cnt = 0 
                #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"smy_file ",
                LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'smy_file'), #FUN-A50102
                            " WHERE smyslip = '",rvu_t1,"'"
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                PREPARE smy_pre2 FROM l_sql
                EXECUTE smy_pre2 INTO l_cnt
                IF l_cnt = 0 THEN
                   LET g_msg = l_dbs_new CLIPPED,rvu_t1 CLIPPED
                   IF g_bgerr THEN                                            
                      CALL s_errmsg("","","g_msg",'axm-931',1)                
                   ELSE                                                       
                      CALL cl_err3("","","","",'axm-931',"","g_msg",1)        
                   END IF 
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF
             END IF
             LET l_cnt = 0 
             
 
#找出最尾站別的營運中心
         SELECT poy02 INTO l_poy02
           FROM poy_file
          WHERE poy01 = g_poz.poz01
            AND poy04 = g_poz.poz18
 
         LET l_c = 0
 
         SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設>
           FROM poy_file
          WHERE poy01 = g_poz.poz01
            AND poy04 = g_poz.poz18
 
         IF (g_poz.poz19 = 'Y' AND l_c > 0) THEN    #己設立中斷點
             IF g_poy.poy02 > l_poy02 THEN          #目前站別>中斷點站別時繼續拋轉 
                 CALL p900_p3(p_oga01,p_oga09,p_plant,i) #FUN-980092 add
             ELSE 
                 #---當目前站別=中斷站別時，只拋當站的收貨單資料---
                 #新增收貨單單頭檔(rva_file) 
                 CALL p900_rvains()              #MOD-810255 
                 #讀取出貨單身檔(ogb_file)
                 IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                     LET l_sql = " SELECT * FROM ogb_file ",
                                 "  WHERE ogb01 = '",g_oga.oga01,"' ",
                                 "     AND ogb1005 = '1'" #NO.TQC-640134 
                 ELSE
                     #LET l_sql = " SELECT * FROM ",p_dbs_tra CLIPPED,"ogb_file ", #FUN-980092 add
                     LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'ogb_file'), #FUN-A50102 
                                 "  WHERE ogb01 = '",g_oga.oga01,"' ",
                                 "    AND ogb1005 = '1'"  #NO.TQC-640134 
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-980092 add
                 END IF
                 LET l_sql = l_sql CLIPPED," ORDER BY ogb03" #MOD-810255 add
 	             
                 PREPARE ogb_pre2 FROM l_sql
                 DECLARE ogb_cus2 CURSOR FOR ogb_pre2
                 FOREACH ogb_cus2 INTO g_ogb.* 
                     IF SQLCA.SQLCODE <>0 THEN
                         EXIT FOREACH
                     END IF 

                     #yemy 20130530  --Begin
                     IF g_source_ogb09 IS NULL THEN
                        LET g_source_ogb09 = g_ogb.ogb09
                        LET g_source_ogb091= g_ogb.ogb091
                        LET g_source_ogb092= g_ogb.ogb092
                     END IF
                     #yemy 20130530  --End  

                     IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                         SELECT ima906 INTO g_ima906 FROM ima_file
                          WHERE ima01 = g_ogb.ogb04
                     ELSE
                         LET l_sql = "SELECT ima906 ",
                                     #"  FROM ",p_dbs CLIPPED,"ima_file ",
                                     "  FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102 
                                     " WHERE ima01 = '",g_ogb.ogb04,"' "
 	                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A50102
                         PREPARE ima906_pre2 FROM l_sql
                         EXECUTE ima906_pre2 INTO g_ima906
                     END IF
                     IF NOT p900_chkoeo(g_ogb.ogb31, 
                                        g_ogb.ogb32,g_ogb.ogb04) THEN  #No.7742
 
                    #單身訂單多角序號
                     LET l_sql1= " SELECT * ",
                                 #"   FROM ",p_dbs_tra CLIPPED,"oea_file ", #FUN-980092 add
                                 "   FROM ",cl_get_target_table(p_plant,'oea_file'), #FUN-A50102 
                                 "  WHERE oea01 = '",g_ogb.ogb31,"'"
 	                 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092 add
                     PREPARE oea99_pre1 FROM l_sql1
                     DECLARE oea99_cus1 CURSOR FOR oea99_pre1
                     OPEN oea99_cus1
                     FETCH oea99_cus1 INTO g_oea.*
                    #MOD-820061-end-add 單身訂單多角序號

                    CALL p900_rvbs_pre(p_oga01,p_oga09,p_plant)   #MOD-C20156 add
 
                    #MOD-810014-begin-add
                    
                     LET l_sql1 = "SELECT pmm01 ",                                  
                                  #" FROM ",l_dbs_new_tra CLIPPED,"pmm_file ", #FUN-980092 add
                                  " FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102 
                                  " WHERE pmm99='",g_oea.oea99,"' AND pmm18 <> 'X'" 
 	                 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092 add
                     PREPARE pmm_p21 FROM l_sql1                                     
                     IF SQLCA.SQLCODE THEN  
                        IF g_bgerr THEN
                         CALL s_errmsg('pmm99',g_oea.oea99,'pmm_p21',SQLCA.SQLCODE,1)
                      ELSE
                         CALL cl_err('pmm_p2',SQLCA.SQLCODE,1)
                      END IF
                    END IF    
                     DECLARE pmm_c21 CURSOR FOR pmm_p21                               
                     OPEN pmm_c21                                                    
                     FETCH pmm_c21 INTO g_pmm.pmm01                                  
                          #LET l_sql2="UPDATE ",l_dbs_new_tra CLIPPED,"pmn_file", #FUN-980092 add
                          LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102 
                                     " SET pmn50 = pmn50 + ? ",          #MOD-810133 
                                     " WHERE pmn01 = ? AND pmn02 = ? "  #MOD-4B0167
 	                      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                          CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                          PREPARE upd_pmn_1 FROM l_sql2
                          EXECUTE upd_pmn_1 USING 
                              g_ogb.ogb12,                  #MOD-810014 mark #g_ogb.ogb12,      #BUG-4C0064,MOD-4C0070
                              g_pmm.pmm01,g_ogb.ogb32       #BUG-4C0064,MOD-4C0070 #NO.FUN-620024 #NO.MOD-660137  #MOD-810014 modify
                          IF SQLCA.sqlcode<>0 THEN
                              IF g_bgerr THEN
                                     LET g_showmsg=g_ogb.ogb31,"/",g_ogb.ogb32,"/",g_pmm.pmm01
                                     CALL s_errmsg('pmm24,pmn25,pmn01,pmn02',g_showmsg,'upd pmn:',SQLCA.sqlcode,1)
                              ELSE
                                     CALL cl_err('upd pmn:',SQLCA.sqlcode,1)
                              END IF
                              LET g_success = 'N' 
                              EXIT FOREACH
                          END IF
                     END IF 
                     #新增收貨單單頭檔(rva_file)
                     #CALL p900_rvains()           #MOD-810255 mark
                     #---- 新增收貨單單身檔(rvb_file)----
                     #LET l_rvb.rvb22 = g_flow99[1,8] ,g_flow99[10,17]   #MOD-7C0052
                     #還需要寫rvw_file 
                     #FUN-C80001---begin
                    #IF g_sma.sma96 = 'Y' AND g_ogb.ogb17 = 'Y' THEN  #FUN-D30099 mark
                     IF g_pod.pod08 = 'Y' AND g_ogb.ogb17 = 'Y' THEN  #FUN-D30099
                        CALL p900_rvbins1(i,'N')
                     ELSE 
                     #FUN-C80001---end
                        CALL p900_rvbins(i)
                        CALL p900_log(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                                      l_rvb.rvb07,'2',l_rvb.rvb85) #FUN-C80001
                     END IF  #FUN-C80001
                 END FOREACH
             END IF
         ELSE
            #CALL p900_p3(p_oga01,p_oga09,p_dbs,i) #FUN-980092 mark
             CALL p900_p3(p_oga01,p_oga09,p_plant,i) #FUN-980092 add
         END IF            
      END FOR  {一個訂單流程代碼結束}
     
      MESSAGE ""
    
      IF g_success='N' THEN
         EXIT FOREACH 
      END IF
 
      #MOD-620053 ---------add-----------
      #更新起始站之tlf99多角序號
      IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
          DECLARE ogb_cus1 CURSOR FOR 
            SELECT ogb01,ogb03,ogb31,ogb32,ogb04  #MOD-720030 modify
              FROM ogb_file
             WHERE ogb01 = g_oga.oga01
          FOREACH ogb_cus1 INTO l_ogb01,l_ogb03,l_ogb31,l_ogb32,l_ogb04 #MOD-720030 modify
              IF SQLCA.SQLCODE <>0 THEN 
                  EXIT FOREACH 
              END IF
              IF l_ogb04[1,4] = 'MISC' THEN
                 CONTINUE FOREACH
              END IF
              SELECT DISTINCT tlf99 INTO l_tlf99 	#MOD-970042
                FROM tlf_file
               WHERE tlf026 = l_ogb01
                 AND tlf027 = l_ogb03
                 AND tlf036 = l_ogb31
                 AND tlf037 = l_ogb32
               IF cl_null(l_tlf99) THEN
                  UPDATE tlf_file 
                     SET tlf99  = g_flow99
                   WHERE tlf026 = l_ogb01 
                     AND tlf027 = l_ogb03
                     AND tlf036 = l_ogb31
                     AND tlf037 = l_ogb32
                  IF SQLCA.sqlcode<>0 OR SQLCA.sqlerrd[3]=0 THEN
                     #異動更新不成功
                     IF g_bgerr THEN
                        LET g_showmsg=l_ogb01,"/",l_ogb03,"/",l_ogb31,"/",l_ogb32   
                        CALL s_errmsg('tlf026,tlf027,tlf036,tlf037',g_showmsg,'UPDATE tlf99','lib-028',1)
                     ELSE
                        CALL cl_err3("upd","tlf_file",l_ogb01,"",'lib-028',"","UPDATE tlf99",1) 
                     END IF
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
              END IF
          END FOREACH
      END IF
 
      #更新起始出貨單單頭檔之拋轉否='Y'
      IF g_success = 'Y' THEN              #NO.TQC-740320
          IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
             UPDATE oga_file SET oga905='Y',
                                 oga906='Y' 
              WHERE oga01=g_oga.oga01
          ELSE
             #LET l_sql = "UPDATE ",p_dbs_tra CLIPPED,"oga_file SET oga905='Y', ", #FUN-980092 add
             LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                           " SET oga905='Y', ", 
                         "                                     oga906='Y'  ",
                         "                               WHERE oga01='",g_oga.oga01,"' "
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980092 add
             PREPARE oga_upd_pre FROM l_sql
             EXECUTE oga_upd_pre
          END IF
     
          IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err('upd oga905',SQLCA.SQLCODE,1)
             IF g_bgerr THEN
                CALL s_errmsg('oga01',g_oga.oga01,'upd oga905',SQLCA.SQLCODE,1)
             ELSE
                CALL cl_err('upd oga905',SQLCA.SQLCODE,1)
             END IF
             LET g_success='N' 
          END IF
       END IF                            #NO.TQC-740320
   END FOREACH     
 
   IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
   END IF                                                                          
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN #FUN-C40072 mark #CHI-C80009 remark
      IF g_success = 'Y' THEN 
         COMMIT WORK
      ELSE 
         ROLLBACK WORK
      END IF
   END IF                                       #FUN-C40072 mark #CHI-C80009 remark
 
END FUNCTION
 
#MOD-C20156 ----- add start -----
FUNCTION p900_rvbs_pre(p_oga01,p_oga09,p_plant)
DEFINE p_oga01     LIKE oga_file.oga01
DEFINE p_oga09     LIKE oga_file.oga09
DEFINE p_plant     LIKE azp_file.azp01
DEFINE l_sql       STRING
DEFINE l_sql1      STRING #CHI-C40031 add
DEFINE l_sql2      STRING #CHI-C40031 add

   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      LET l_sql = " SELECT * FROM rvbs_file ",
                  "  WHERE rvbs01 = '",g_oga.oga01,"'",
                  "    AND rvbs02 =  ",g_ogb.ogb03
   ELSE
      LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'rvbs_file'),
                  "  WHERE rvbs01 = '",g_oga.oga01,"'",
                  "    AND rvbs02 =  ",g_ogb.ogb03
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   DECLARE p900_g_rvbs CURSOR FROM l_sql
   #FUN-C80001---begin
   IF g_sma.sma115 = 'Y' THEN 
      IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
         LET l_sql = " SELECT rvbs_file.* FROM rvbs_file,ogg_file ",
                     "  WHERE rvbs01 = ogg01 ",
                     "    AND rvbs02 = ogg03 ",
                     "    AND rvbs13 = ogg18 ",
                     "    AND rvbs01 = '",g_oga.oga01,"'",
                     "    AND rvbs02 =  ",g_ogb.ogb03,
                     "    AND ogg092 = ? "
      ELSE
         LET l_sql = " SELECT rvbs_file.* FROM ",cl_get_target_table(p_plant,'rvbs_file'),",",
                                            cl_get_target_table(p_plant,'ogg_file'),
                     "  WHERE rvbs01 = ogg01 ",
                     "    AND rvbs02 = ogg03 ",
                     "    AND rvbs13 = ogg18 ",
                     "    AND rvbs01 = '",g_oga.oga01,"'",
                     "    AND rvbs02 =  ",g_ogb.ogb03,
                     "    AND ogg092 = ? "
      END IF
   ELSE
      IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
         LET l_sql = " SELECT rvbs_file.* FROM rvbs_file,ogc_file ",
                     "  WHERE rvbs01 = ogc01 ",
                     "    AND rvbs02 = ogc03 ",
                     "    AND rvbs13 = ogc18 ",
                     "    AND rvbs01 = '",g_oga.oga01,"'",
                     "    AND rvbs02 =  ",g_ogb.ogb03,
                     "    AND ogc092 = ? "
      ELSE
         LET l_sql = " SELECT rvbs_file.* FROM ",cl_get_target_table(p_plant,'rvbs_file'),",",
                                            cl_get_target_table(p_plant,'ogc_file'),
                     "  WHERE rvbs01 = ogc01 ",
                     "    AND rvbs02 = ogc03 ",
                     "    AND rvbs13 = ogc18 ",
                     "    AND rvbs01 = '",g_oga.oga01,"'",
                     "    AND rvbs02 =  ",g_ogb.ogb03,
                     "    AND oggc092 = ? "
      END IF
   END IF 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   DECLARE p900_g_rvbs1 CURSOR FROM l_sql  

   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      LET l_sql = " SELECT rvbs_file.* FROM rvbs_file,ogc_file ",
                  "  WHERE rvbs01 = ogc01 ",
                  "    AND rvbs02 = ogc03 ",
                  "    AND rvbs13 = ogc18 ",
                  "    AND rvbs01 = '",g_oga.oga01,"'",
                  "    AND rvbs02 =  ",g_ogb.ogb03,
                  "    AND ogc092 = ? "
   ELSE
      LET l_sql = " SELECT rvbs_file.* FROM ",cl_get_target_table(p_plant,'rvbs_file'),",",
                                         cl_get_target_table(p_plant,'ogc_file'),
                  "  WHERE rvbs01 = ogc01 ",
                  "    AND rvbs02 = ogc03 ",
                  "    AND rvbs13 = ogc18 ",
                  "    AND rvbs01 = '",g_oga.oga01,"'",
                  "    AND rvbs02 =  ",g_ogb.ogb03,
                  "    AND oggc092 = ? "
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   DECLARE p900_g_rvbs2 CURSOR FROM l_sql  

   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      LET l_sql = " SELECT rvbs_file.* FROM rvbs_file,ogg_file ",
                  "  WHERE rvbs01 = ogg01 ",
                  "    AND rvbs02 = ogg03 ",
                  "    AND rvbs13 = ogg18 ",
                  "    AND rvbs01 = '",g_oga.oga01,"'",
                  "    AND rvbs02 =  ",g_ogb.ogb03,
                  "    AND ogg092 = ? ",
                  "    AND ogg20 = ? "
   ELSE
      LET l_sql = " SELECT rvbs_file.* FROM ",cl_get_target_table(p_plant,'rvbs_file'),",",
                                         cl_get_target_table(p_plant,'ogg_file'),
                  "  WHERE rvbs01 = ogg01 ",
                  "    AND rvbs02 = ogg03 ",
                  "    AND rvbs13 = ogg18 ",
                  "    AND rvbs01 = '",g_oga.oga01,"'",
                  "    AND rvbs02 =  ",g_ogb.ogb03,
                  "    AND ogg092 = ? ",
                  "    AND ogg20 = ? "
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   DECLARE p900_g_rvbs3 CURSOR FROM l_sql  
   #FUN-C80001---end
#CHI-C40031---add---START
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      LET l_sql1 = " SELECT * FROM ogg_file ",
                  "  WHERE ogg01 = '",g_oga.oga01,"'",
                  "    AND ogg03 = '",g_ogb.ogb03,"'",
                  "    AND ogg18 = ? "
   ELSE
      LET l_sql1 = " SELECT * FROM ",cl_get_target_table(p_plant,'ogg_file'),
                  "  WHERE ogg01 = '",g_oga.oga01,"'",
                  "    AND ogg03 = '",g_ogb.ogb03,"'",
                  "    AND ogg18 = ? "
   END IF
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
   CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1
   DECLARE p900_g_ogg CURSOR FROM l_sql1

   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      LET l_sql2 = " SELECT * FROM ogc_file ",
                  "  WHERE ogc01 = '",g_oga.oga01,"'",
                  "    AND ogc03 = '",g_ogb.ogb03,"'",
                  "    AND ogc18 = ? "
   ELSE
      LET l_sql2 = " SELECT * FROM ",cl_get_target_table(p_plant,'ogc_file'),
                  "  WHERE ogc01 = '",g_oga.oga01,"'",
                  "    AND ogc03 = '",g_ogb.ogb03,"'",
                  "    AND ogc18 = ?"
   END IF
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
   CALL cl_parse_qry_sql(l_sql2,p_plant) RETURNING l_sql2
   DECLARE p900_g_ogc CURSOR FROM l_sql2
#CHI-C40031---add-----END

END FUNCTION
#MOD-C20156 ----- add end -----

FUNCTION p900_p3(p_oga01,p_oga09,p_plant,i) #FUN-980092 add
DEFINE l_ogb01     LIKE ogb_file.ogb01  #MOD-620053 add
DEFINE l_ogb03     LIKE ogb_file.ogb03  #MOD-620053 add
DEFINE l_ogb31     LIKE ogb_file.ogb31  #MOD-620053 add
DEFINE l_ogb32     LIKE ogb_file.ogb32  #MOD-620053 add
DEFINE l_tlf99     LIKE tlf_file.tlf99  #MOD-620053 add
DEFINE p_oga01     LIKE oga_file.oga01 #No.FUN-620054
DEFINE p_oga09     LIKE oga_file.oga09 #No.FUN-620054
DEFINE p_dbs       LIKE type_file.chr21  #No.FUN-680137    VARCHAR(21)            #No.FUN-620054
DEFINE l_pmm       RECORD LIKE pmm_file.*
DEFINE l_pmn       RECORD LIKE pmn_file.*
DEFINE l_occ       RECORD LIKE occ_file.*
DEFINE l_pmc       RECORD LIKE pmc_file.*
DEFINE l_oal       RECORD LIKE oal_file.*
DEFINE l_oam       RECORD LIKE oam_file.*
DEFINE l_gec       RECORD LIKE gec_file.*
DEFINE l_ima       RECORD LIKE ima_file.*
DEFINE l_sql,l_sql1,l_sql2       STRING    #MOD-9C0274
DEFINE i,l_i       LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE o_oal11     LIKE oal_file.oal11     #計價方式
DEFINE diff_azi    LIKE type_file.chr1,    #若為Y表示單身計價方式有所不同 #No.FUN-680137 VARCHAR(1)
       l_cnt       LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       azi_oal11   LIKE oal_file.oal11,   #記錄單頭該用之計價方式
       min_oeb15   LIKE oeb_file.oeb15    #記錄該訂單之最小預交日
DEFINE l_j         LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_msg       LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(60)
DEFINE l_oea62     LIKE oea_file.oea62
DEFINE s_oea62     LIKE oea_file.oea62
DEFINE l_oeb24     LIKE oeb_file.oeb24 
DEFINE l_x         LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5) #No.FUN-550070
DEFINE p_oeb       RECORD LIKE oeb_file.*  
DEFINE l_ogd01     LIKE ogd_file.ogd01       #包裝單號
DEFINE g_ogd01     LIKE ogd_file.ogd01       #包裝單號
DEFINE l_ofa01     LIKE ofa_file.ofa01       #INVOICE 單號
DEFINE l_slip      LIKE ofa_file.ofa01       #INVOICE 單號
DEFINE li_result   LIKE type_file.num5       #FUN-560043  #No.FUN-680137 SMALLINT
DEFINE l_oga01     LIKE oga_file.oga01       #FUN-630053 add
DEFINE l_ogbb      RECORD LIKE ogbb_file.*   #NO.FUN-780025
DEFINE l_ogdi      RECORD LIKE ogdi_file.*   #NO.FUN-7B0018
DEFINE l_sql_1     STRING                    #CHI-8B0047
DEFINE l_pmn24     LIKE pmn_file.pmn24       #CHI-8B0047
 
DEFINE p_dbs_tra   LIKE type_file.chr21      #FUN-980092 add  #No.FUN-A10099
DEFINE p_plant     LIKE azp_file.azp01       #FUN-980092 add
 
   LET g_plant_new = p_plant
   CALL s_getdbs()      LET p_dbs = g_dbs_new
   CALL s_gettrandbs()  LET p_dbs_tra = g_dbs_tra
 
   LET g_flag = 'N'                          #CHI-8B0047
 
   #新增出貨單單頭檔(oga_file)
   IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0) #No.8047
      OR (tm.oga09="6" AND g_oea.oea37="Y" AND i = 0 AND cl_null(p_oga01) AND g_oaz.oaz19 = 'Y') THEN   #No.FUN-630006 No.FUN-620054   #No.FUN-640025   #NO.TQC-640134     
      CALL p900_ogains(i)      #No.FUN-620054
   END IF
   
   #新增收貨單單頭檔(rva_file)
   CALL p900_rvains()
   
   #新增入庫單單頭檔(rvu_file)
   CALL p900_rvuins()   
 
   IF g_success='N' THEN
       RETURN    #FUN-670007
   END IF
   
   LET l_oea62=0
   
   #讀取出貨單身檔(ogb_file)
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
       LET l_sql = " SELECT * FROM ogb_file ",
                   "  WHERE ogb01 = '",g_oga.oga01,"' ",
                   "     AND ogb1005 = '1'" #NO.TQC-640134 
   ELSE
       #LET l_sql = " SELECT * FROM ",p_dbs_tra CLIPPED,"ogb_file ", #FUN-980092 add
       LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'ogb_file'), #FUN-A50102
                   "  WHERE ogb01 = '",g_oga.oga01,"' ",
                   "    AND ogb1005 = '1'"  #NO.TQC-640134 
   END IF
   LET l_sql= l_sql CLIPPED," ORDER BY ogb03" #MOD-810255 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
   PREPARE ogb_pre FROM l_sql
   DECLARE ogb_cus CURSOR FOR ogb_pre
   FOREACH ogb_cus INTO g_ogb.* 
       IF SQLCA.SQLCODE <>0 THEN
           EXIT FOREACH
       END IF 

       #yemy 20130530  --Begin
       IF g_source_ogb09 IS NULL THEN
          LET g_source_ogb09 = g_ogb.ogb09
          LET g_source_ogb091= g_ogb.ogb091
          LET g_source_ogb092= g_ogb.ogb092
       END IF
       #yemy 20130530  --End  
       IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
           SELECT ima906 INTO g_ima906 FROM ima_file
            WHERE ima01 = g_ogb.ogb04
       ELSE
           LET l_sql = "SELECT ima906 ",
                       #"  FROM ",p_dbs CLIPPED,"ima_file ",
                       "  FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                       " WHERE ima01 = '",g_ogb.ogb04,"' "
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
           PREPARE ima906_pre FROM l_sql
           EXECUTE ima906_pre INTO g_ima906
       END IF
 
       # 單身訂單多角序號
       LET l_sql1= " SELECT * ",
                   #"   FROM ",p_dbs_tra CLIPPED,"oea_file ", #FUN-980092 add
                   "   FROM ",cl_get_target_table(p_plant,'oea_file'), #FUN-A50102
                   "  WHERE oea01 = '",g_ogb.ogb31,"'"
 	   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
       CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092 add
       PREPARE oea99_pre FROM l_sql1
       DECLARE oea99_cus CURSOR FOR oea99_pre
       OPEN oea99_cus
       FETCH oea99_cus INTO g_oea.*
       # 單身訂單多角序號
 
       #No.FUN-A10099  --Begin
       #-----No:FUN-850100-----
       #DECLARE p900_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
       #                                  WHERE rvbs01 = g_oga.oga01
       #                                    AND rvbs02 = g_ogb.ogb03
       #-----No:FUN-850100 END-----
       #MOD-C20156 ----- mark start ----
       #IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
       #   LET l_sql = " SELECT * FROM rvbs_file ",
       #               "  WHERE rvbs01 = '",g_oga.oga01,"'",
       #               "    AND rvbs02 =  ",g_ogb.ogb03
       #ELSE
       #   #LET l_sql = " SELECT * FROM ",p_dbs_tra CLIPPED,"rvbs_file ",
       #   LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'rvbs_file'), #FUN-A50102
       #               "  WHERE rvbs01 = '",g_oga.oga01,"'",
       #               "    AND rvbs02 =  ",g_ogb.ogb03
       #END IF
       #CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-A50102
       #CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
       #DECLARE p900_g_rvbs CURSOR FROM l_sql
       #MOD-C20156 ----- mark end -----
       #No.FUN-A10099  --End

       CALL p900_rvbs_pre(p_oga01,p_oga09,p_plant)   #MOD-C20156 add

#FUN-B90012 -------------Begin----------------
       IF s_industry('icd') THEN
          IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
             LET l_sql1 = " SELECT * FROM idd_file ",
                          "  WHERE idd10 = '",g_oga.oga01,"'",
                          "    AND idd11 =  ",g_ogb.ogb03
          ELSE
             LET l_sql1 = " SELECT * FROM ",cl_get_target_table(p_plant,'idd_file'),
                          "  WHERE idd10 = '",g_oga.oga01,"'",
                          "    AND idd11 =  ",g_ogb.ogb03 
          END IF
          CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
          CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1
          DECLARE p900_g_idd CURSOR FROM l_sql1
          #FUN-C80001---begin
          IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
             LET l_sql1 = " SELECT idd04,idd05,idd06 FROM idd_file ",
                          "  WHERE idd10 = '",g_oga.oga01,"'",
                          "    AND idd11 =  ",g_ogb.ogb03,
                          "    AND idd04 = ? ", 
                          "  GROUP BY idd04,idd05,idd06 "
          ELSE
             LET l_sql1 = " SELECT idd04,idd05,idd06 FROM ",cl_get_target_table(p_plant,'idd_file'),
                          "  WHERE idd10 = '",g_oga.oga01,"'",
                          "    AND idd11 =  ",g_ogb.ogb03,
                          "    AND idd06 = ? ",
                          "  GROUP BY idd04,idd05,idd06 "  
          END IF
          CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
          CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1
          DECLARE p900_g_idd1 CURSOR FROM l_sql1
          
          IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
             LET l_sql1 = " SELECT * FROM idd_file ",
                          "  WHERE idd10 = '",g_oga.oga01,"'",
                          "    AND idd11 =  ",g_ogb.ogb03,
                          "    AND idd04 = ? ",
                          "    AND idd05 = ? ",
                          "    AND idd06 = ? " 
          ELSE
             LET l_sql1 = " SELECT * FROM ",cl_get_target_table(p_plant,'idd_file'),
                          "  WHERE idd10 = '",g_oga.oga01,"'",
                          "    AND idd11 =  ",g_ogb.ogb03,
                          "    AND idd04 = ? ",
                          "    AND idd05 = ? ",
                          "    AND idd06 = ? "  
          END IF
          CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
          CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1
          DECLARE p900_g_idd2 CURSOR FROM l_sql1
          
          IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
             LET l_sql1 = " SELECT SUM(idd13),SUM(idd18),SUM(idd19) FROM idd_file ",
                          "  WHERE idd10 = '",g_oga.oga01,"'",
                          "    AND idd11 =  ",g_ogb.ogb03,
                          "    AND idd04 = ? ",
                          "    AND idd05 = ? ",
                          "    AND idd06 = ? " 
          ELSE
             LET l_sql1 = " SELECT SUM(idd13),SUM(idd18),SUM(idd19) FROM ",cl_get_target_table(p_plant,'idd_file'),
                          "  WHERE idd10 = '",g_oga.oga01,"'",
                          "    AND idd11 =  ",g_ogb.ogb03,
                          "    AND idd04 = ? ",
                          "    AND idd05 = ? ",
                          "    AND idd06 = ? "  
          END IF
          CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
          CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1
          DECLARE p900_g_idd3 CURSOR FROM l_sql1
          #FUN-C80001---end
       END IF
#FUN-B90012 -------------End------------------
 
       #---- 新增出貨單單身檔(ogb_file)----
       IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0)  #No.8047
           OR (tm.oga09="6" AND g_oea.oea39="Y" AND i = 0 AND cl_null(p_oga01) AND g_oaz.oaz19 = 'Y') THEN    #No.FUN-630006 No.FUN-620054   #No.FUN-640025   #NO.TQC-640134
           CALL p900_ogbins(i,p_plant) #FUN-980092 add
           IF l_ogb.ogb17<>'Y' THEN  #FUN-C80001
              CALL p900_log(l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                            l_ogb.ogb092,l_ogb.ogb12,'1',l_ogb.ogb915)  #FUN-C80001
           END IF  #FUN-C80001
       END IF
       
      #IF g_sma.sma96 = 'Y' AND g_ogb.ogb17 = 'Y' THEN   #FUN-C80001 #FUN-D30099 mark
       IF g_pod.pod08 = 'Y' AND g_ogb.ogb17 = 'Y' THEN   #FUN-D30099 
          CALL p900_rvbins1(i,'Y')     #FUN-C80001
       ELSE                        #FUN-C80001
          IF s_aza.aza50 ='Y' THEN      #使用分銷功能                             
             IF g_oga.oga00 = '6' THEN  #代送出貨單                               
                CALL p900_log(l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091, 
                              l_ogb.ogb092,l_ogb.ogb12,'4',l_ogb.ogb915)  #FUN-C80001         
             END IF      
          END IF     

       #---- 新增收貨單單身檔(rvb_file)----
          CALL p900_rvbins(i)
          CALL p900_log(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                        l_rvb.rvb07,'2',l_rvb.rvb85)  #FUN-C80001
       
       #---- 新增入庫單身檔(rvv_file)----
          CALL p900_rvvins(i)
          CALL p900_log(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                        l_rvv.rvv17,'3',l_rvv.rvv85)  #FUN-C80001
       END IF                      #FUN-C80001              
       IF i = 0 AND tm.oga09="6" AND g_flag='N' THEN
          LET l_sql_1 = "SELECT pmm01,pmm909 ",                                  
                        #" FROM ",l_dbs_new_tra CLIPPED,"pmm_file ",  #FUN-980092 add
                        " FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                        " WHERE pmm99='",g_oea.oea99,"' AND pmm18 <> 'X'" 
         CALL cl_replace_sqldb(l_sql_1) RETURNING l_sql_1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql_1,l_plant_new) RETURNING l_sql_1 #FUN-980092 add
          PREPARE pmm_p211 FROM l_sql_1                                      
          DECLARE pmm_c211 CURSOR FOR pmm_p211                               
          OPEN pmm_c211                                                    
          FETCH pmm_c211 INTO g_pmm01,g_pmm909
    
          LET l_sql_1 = " SELECT pmn24 ",
                        #"   FROM ",l_dbs_new_tra CLIPPED,"pmn_file ", #FUN-980092 add
                        "   FROM ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                        "  WHERE pmn01 = '",g_pmm01,"' "
 	      CALL cl_replace_sqldb(l_sql_1) RETURNING l_sql_1        #FUN-920032
          CALL cl_parse_qry_sql(l_sql_1,l_plant_new) RETURNING l_sql_1 #FUN-980092 add
          PREPARE pmn_pre21 FROM l_sql_1
          DECLARE pmn_c211 CURSOR FOR pmn_pre21                               
          OPEN pmn_c211                                                    
          FETCH pmn_c211 INTO l_pmn24   
    
          LET l_sql_1 = " SELECT oea37 ",
                        #"   FROM ",l_dbs_new_tra CLIPPED,"oea_file ", #FUN-980092 add
                        "   FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                        "  WHERE oea01 = '",l_pmn24,"' "
 	      CALL cl_replace_sqldb(l_sql_1) RETURNING l_sql_1        #FUN-920032
          CALl cl_parse_qry_sql(l_sql_1,l_plant_new) RETURNING l_sql_1  #FUN-980092 add
          PREPARE oea_pre21 FROM l_sql_1
          EXECUTE oea_pre21 INTO g_oea37
          IF g_pmm909 = 3 AND g_oea37 = 'Y' THEN
             IF cl_confirm('axm-909') THEN
                LET g_flag = 'Y'
                CALL p900_exp_delivery()            
             END IF
          END IF                  
       END IF 
      #IF g_ogb.ogb17 <> 'Y' OR g_sma.sma96 <> 'Y' THEN  #FUN-C80001 #FUN-D30099 mark
       IF g_ogb.ogb17 <> 'Y' OR g_pod.pod08 <> 'Y' THEN  #FUN-D30099 
          # 代採買替來源廠做入庫動作
          IF tm.oga09 = '6' AND i = 0 THEN  #No.9059
             CALL s_mupimg(1,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                          #l_rvv.rvv34,l_rvv.rvv17*g_ogb.ogb15_fac, #MOD-4B0148  #MOD-C50031 mark
                           l_rvv.rvv34,l_rvv.rvv17*l_ogb.ogb15_fac, #MOD-C50031
                           g_oga.oga02,l_azp.azp01,1,l_rvv.rvv01,l_rvv.rvv02)  #No.FUN-870007 
             IF g_ima906 = '2' THEN                    #NO.FUN-620024
                CALL s_mupimgg(1,l_rvv.rvv31,
                               l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv80,l_rvv.rvv82,
                               g_oga.oga02,
                               l_plant_new) #FUN-980092 add
                CALL s_mupimgg(1,l_rvv.rvv31,
                               l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv83,l_rvv.rvv85,
                               g_oga.oga02,
                               l_plant_new) #FUN-980092 add
             ELSE 
                IF g_ima906 = '3' THEN
                   CALL s_mupimgg(1,l_rvv.rvv31,
                                  l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                  l_rvv.rvv83,l_rvv.rvv85,
                                  g_oga.oga02,
                                  l_plant_new) #FUN-980092 add
                END IF
             END IF
             CALL s_mudima(l_rvv.rvv31,l_plant_new) #FUN-980092 add
          END IF
       END IF  #FUN-C80001 
   
       IF g_success='N' THEN
           EXIT FOREACH 
       END IF
   
           LET l_sql1 = "SELECT pmm01 ",                                  
                        #" FROM ",l_dbs_new_tra CLIPPED,"pmm_file ", #FUN-980092 add
                        " FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                        " WHERE pmm99='",g_oea.oea99,"' AND pmm18 <> 'X'" 
 	       CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
           CALl cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092 add
           PREPARE pmm_p2 FROM l_sql1                                     
           IF SQLCA.SQLCODE THEN  
              IF g_bgerr THEN
               CALL s_errmsg('pmm99',g_oea.oea99,'pmm_p2',SQLCA.SQLCODE,1)
            ELSE
               CALL cl_err('pmm_p2',SQLCA.SQLCODE,1)
            END IF
          END IF    
           DECLARE pmm_c2 CURSOR FOR pmm_p2                               
           OPEN pmm_c2                                                    
           FETCH pmm_c2 INTO g_pmm.pmm01                                  
           IF SQLCA.SQLCODE <> 0 THEN                                     
               LET g_success='N'                                           
               RETURN                                                      
           END IF                                                         
           CLOSE pmm_c2                                                   
 
       IF NOT p900_chkoeo(g_ogb.ogb31, 
                          g_ogb.ogb32,g_ogb.ogb04) THEN  #No.7742
 
            #LET l_sql2="UPDATE ",l_dbs_new_tra CLIPPED,"pmn_file", #FUN-980092 add
            LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                       " SET pmn50 = pmn50 + ?,",
                       "     pmn53 = pmn53 + ? ", 
                       " WHERE pmn01 = ? AND pmn02 = ? "  #MOD-4B0167
 	        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALl cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
            PREPARE upd_pmn FROM l_sql2
            EXECUTE upd_pmn USING 
                g_ogb.ogb12,g_ogb.ogb12,      #BUG-4C0064,MOD-4C0070
                g_pmm.pmm01,g_ogb.ogb32       #NO.MOD-640424  #NO.MOD-660137 MARK  #MOD-810014 cancel mark
            IF SQLCA.sqlcode<>0 THEN
                IF g_bgerr THEN
                       LET g_showmsg=g_ogb.ogb31,"/",g_ogb.ogb32,"/",g_pmm.pmm01
                       CALL s_errmsg('pmm24,pmn25,pmn01,pmn02',g_showmsg,'upd pmn:',SQLCA.sqlcode,1)
                ELSE
                       CALL cl_err('upd pmn:',SQLCA.sqlcode,1)
                END IF
                LET g_success = 'N' 
                EXIT FOREACH
            END IF
          
            IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0)  #No.8047
                OR (tm.oga09="6" AND g_oea.oea37="Y" AND i = 0 AND cl_null(p_oga01) AND g_oaz.oaz19 = 'Y') THEN   #No.FUN-630006 No.FUN-620054   #No.FUN-640025  #NO.TQC-640134
                #更新銷單之已出貨量
                LET l_oeb24 = l_oeb.oeb24 + l_ogb.ogb12 
                LET l_oeb24 = s_digqty(l_oeb24,l_oeb.oeb05)    #FUN-BB0083 add
                IF l_oeb24 IS NULL THEN
                    LET l_oeb24 = 0
                END IF
 
                #LET l_sql2 = "UPDATE ",l_dbs_new_tra CLIPPED,"oeb_file", #FUN-980092 add
                LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102
                             "   SET oeb24= ? ",
                             " WHERE oeb01 = ? AND oeb03 = ? "
 	            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                CALl cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
                PREPARE upd_oeb2 FROM l_sql2
            
                EXECUTE upd_oeb2 USING 
                         l_oeb24, l_ogb.ogb31,l_ogb.ogb32  #BUG-4C0064,MOD-4C0070
                IF SQLCA.sqlcode<>0 THEN
                    IF g_bgerr THEN
                      LET g_showmsg=l_ogb.ogb31,"/",l_ogb.ogb32
                      CALL s_errmsg('oeb01,oeb03',g_showmsg,'upd oeb24:',SQLCA.sqlcode,1)
                    ELSE
                      CALL cl_err('upd oeb24:',SQLCA.sqlcode,1)
                    END IF
                    LET g_success = 'N'
                    EXIT FOREACH 
                END IF
                LET l_oea62 = l_oea62 + l_ogb.ogb12*l_oeb.oeb13
            END IF    ##No.8047(end)
       END IF      ##No.7742(end)
   END FOREACH {ogb_cus}
   
   #更新銷單已出貨未稅金額
   IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0)  #No.8047
       OR (tm.oga09="6" AND g_oea.oea37="Y" AND i = 0 AND cl_null(p_oga01) AND g_oaz.oaz19 = 'Y') THEN   #No.FUN-630006 No.FUN-620054   #No.FUN-640025  #NO.TQC-640134
       #LET l_sql2="UPDATE ",l_dbs_new_tra CLIPPED,"oea_file", #FUN-980092 add
       LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                  " SET oea62 = oea62 + ? ",
                  " WHERE oea01 = ?  "
       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
       CALl cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
       PREPARE upd_oea2 FROM l_sql2
   
       EXECUTE upd_oea2 USING l_oea62, l_ogb.ogb31    #MOD-850062
       IF SQLCA.sqlcode<>0 THEN
          IF g_bgerr THEN
            CALL s_errmsg('oea01',g_ogb.ogb31,'upd oea62:',SQLCA.sqlcode,1)
          ELSE
            CALL cl_err('upd oea62:',SQLCA.sqlcode,1)
          END IF
       LET g_success = 'N'
       END IF
   END IF
   #拋轉ogbb_file 出貨單序號檔------------------
   DECLARE ogbb_cs CURSOR FOR
    SELECT * FROM ogbb_file WHERE ogbb01 = g_oga.oga01
   FOREACH ogbb_cs INTO l_ogbb.* 
       LET l_ogbb.ogbb01 = l_oga.oga01
       #LET l_sql2 = "INSERT INTO ",l_dbs_new_tra CLIPPED,"ogbb_file", #FUN-980092 add
       LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'ogbb_file'), #FUN-A50102
                    "     (ogbb01,ogbb012,ogbb02,ogbbplant,ogbblegal) ", #FUN-980010
                    " VALUES(?,?,?, ?,?) "  #FUN-980010
 	   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
       CALl cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
       PREPARE ins_ogbb FROM l_sql2
       EXECUTE ins_ogbb USING l_ogbb.ogbb01,l_ogbb.ogbb012,l_ogbb.ogbb02,
                              gp_plant,gp_legal   #FUN-980010
         IF SQLCA.sqlcode<>0 THEN
            LET g_msg = l_dbs_new CLIPPED,"ins ogbb"
            CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1) 
            LET g_success = 'N'
         END IF
   END FOREACH
 
 
   #---------------- 是否拋轉 Packing List ----------------------
   IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0)  #No.8047
      OR (tm.oga09="6" AND g_oea.oea37="Y" AND i = 0 AND cl_null(p_oga01) AND g_oaz.oaz19 = 'Y') THEN   #No.FUN-630006 No.FUN-620054   #No.FUN-640025  #NO.TQC-640134
      #參數設定要拋轉packing且包裝單來源出貨單號為2
      IF g_oax.oax05='Y' AND g_oaz.oaz67 = '2' THEN   #NO.FUN-670007
              LET l_oga01=g_oga.oga01  #出貨單號
           IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
              SELECT COUNT(*) INTO l_cnt FROM ogd_file,oga_file
               WHERE ogd01 = oga01
                 AND (oga16 = g_oga.oga16 OR oga16 IS NULL)
                 AND oga30='Y'   #No.MOD-570191
                 AND oga01=l_oga01 #FUN-630053 add 此判斷
           ELSE
               LET l_sql = "SELECT COUNT(*) ",
                           #"  FROM ",p_dbs_tra CLIPPED,"ogd_file,", #FUN-980092 add
                           #          p_dbs_tra CLIPPED,"oga_file ", #FUN-980092 add
                           "  FROM ",cl_get_target_table(p_plant,'ogd_file'),",", #FUN-A50102
                                     cl_get_target_table(p_plant,'oga_file'),     #FUN-A50102
                           " WHERE ogd01 = oga01 ",
                           "   AND (oga16 = '",g_oga.oga16,"' OR oga16 IS NULL) "
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
               PREPARE ogd_pre FROM l_sql
               EXECUTE ogd_pre INTO l_cnt
           END IF
           #參數設定要拋packing的話，必需要有packing資料
           IF l_cnt = 0 THEN
                IF g_bgerr THEN
                 #CALL s_errmsg('','','sel ogd:',SQLCA.SQLCODE,1)   #MOD-AA0024
                 LET g_showmsg=g_oga.oga01              #MOD-AA0024
                 CALL s_errmsg('oga01',g_showmsg,'','axm_117',1)   #MOD-AA0024
                ELSE
                 #CALL cl_err('sel ogd:',SQLCA.SQLCODE,1)   #MOD-AA0024
                 CALL cl_err(g_oga.oga01,'axm_117',1)   #MOD-AA0024
                END IF
               LET g_success='N' RETURN  #FUN-670007
           ELSE
               LET l_ogd01 = l_oga.oga01    #No.8047
               LET g_ogd01 = g_oga.oga01
               
               IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                   LET l_sql = "SELECT * FROM ogd_file ",
                               " WHERE ogd01='",g_ogd01,"' "
               ELSE
                   #LET l_sql = "SELECT * FROM ",p_dbs_tra CLIPPED,"ogd_file ", #FUN-980092 add
                   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ogd_file'), #FUN-A50102
                               " WHERE ogd01='",g_ogd01,"' "
               END IF
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
               PREPARE ogd_pre3 FROM l_sql
               DECLARE ogd_cs CURSOR FOR ogd_pre3
               FOREACH ogd_cs INTO g_ogd.*
                   IF SQLCA.SQLCODE <>0 THEN
                       EXIT FOREACH
                   END IF 
                   #新增Packing List
                   LET g_ogd.ogd01 = l_ogd01
                   IF cl_null(g_ogd.ogd01) THEN LET g_ogd.ogd01=' ' END IF
                   #LET l_sql2="INSERT INTO ",l_dbs_new_tra CLIPPED,"ogd_file", #FUN-980092 add
                   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ogd_file'), #FUN-A50102
                              "(ogd01,ogd03,ogd04,ogd08, ",
                              " ogd09,ogd10,ogd11,ogd12b,",
                              " ogd12e,ogd13,ogd14,ogd15,",
                              " ogd16,ogd14t,ogd15t,ogd16t,",
                              " ogdplant,ogdlegal)",     #FUN-980010
                              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ",
                              "         ?,?,?,?, ?,? )"  #FUN-980010
 	               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
                   PREPARE ins_ogd FROM l_sql2
                   EXECUTE ins_ogd USING g_ogd.ogd01,g_ogd.ogd03,
                                         g_ogd.ogd04,g_ogd.ogd08,
                                         g_ogd.ogd09,g_ogd.ogd10,
                                         g_ogd.ogd11,g_ogd.ogd12b,
                                         g_ogd.ogd12e,g_ogd.ogd13,
                                         g_ogd.ogd14,g_ogd.ogd15,
                                         g_ogd.ogd16,g_ogd.ogd14t,
                                         g_ogd.ogd15t,g_ogd.ogd16t,
                                         gp_plant,gp_legal   #FUN-980010
                   IF SQLCA.sqlcode<>0 THEN
                       IF g_bgerr THEN
                          LET g_showmsg=g_ogd.ogd01,"/",g_ogd.ogd03,"/",g_ogd.ogd04           
                          CALL s_errmsg('ogd01,ogd03,ogd04',g_showmsg,'ins ogd:',SQLCA.sqlcode,1)
                       ELSE
                          CALL cl_err('ins ogd:',SQLCA.sqlcode,1)
                       END IF
                       LET g_success = 'N'
                       EXIT FOREACH 
                   END IF
                   IF NOT s_industry('std') THEN
                      INITIALIZE l_ogdi.* TO NULL
                      LET l_ogdi.ogdi01 = g_ogd.ogd01
                      LET l_ogdi.ogdi03 = g_ogd.ogd03
                      LET l_ogdi.ogdi04 = g_ogd.ogd04
                      IF NOT s_ins_ogdi(l_ogdi.*,l_plant_new) THEN #FUN-980092 add
                         LET g_success = 'N'
                      END IF
                   END IF
               END FOREACH
               
               #更新包裝單確認碼
               #LET l_sql2="UPDATE ",l_dbs_new_tra CLIPPED,"oga_file", #FUN-980092 add
               LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                          " SET oga30 = 'Y' ",
                          " WHERE oga01 = ?  " #No.9565
 	           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
               PREPARE upd_oga30 FROM l_sql2
               EXECUTE upd_oga30 USING l_oga.oga01   #NO.TQC-760096
               IF SQLCA.sqlcode<>0 THEN
                   IF g_bgerr THEN
                     CALL s_errmsg('oga01',g_oga.oga01,'upd oga30:',SQLCA.sqlcode,1)
                   ELSE
                     CALL cl_err('upd oga30:',SQLCA.sqlcode,1)
                   END IF
                   LET g_success = 'N'
                   RETURN   #FUN-670007
               END IF
               END IF
               END IF
               #------------- 是否拋轉 Invoice --------------------------
               IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0)  #No.8047
                   OR (tm.oga09="6" AND g_oea.oea37="Y" AND i = 0 AND cl_null(p_oga01) AND g_oaz.oaz19 = 'Y') THEN   #No.FUN-630006 No.FUN-620054   #No.FUN-640025   #NO.TQC-640134
                   #---參數設定要拋轉INVOICE----
                   IF g_oax.oax04='Y' AND g_oaz.oaz67 = '2' THEN   #NO.FUN-670007
                       LET l_slip=''
                      #MOD-B60103 mark 不可能走到这段
                      #IF g_oaz.oaz67 = '1' THEN
                      #    IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                      #        SELECT oga27 INTO l_slip FROM oga_file 
                      #         WHERE oga01=g_oga.oga011
                      #    ELSE
                      #        #LET l_sql = "SELECT oga27 FROM ",p_dbs_tra CLIPPED,"oga_file ", #FUN-980092 add
                      #        LET l_sql = "SELECT oga27 FROM ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                      #                    " WHERE oga01='",g_oga.oga011,"' "
 	              #            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                      #        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
                      #        PREPARE oga27_pre FROM l_sql
                      #        EXECUTE oga27_pre INTO l_slip
                      #    END IF
                      #ELSE 
                      #MOD-B60103 mark--end
                           LET l_slip=g_oga.oga27
                      #END IF  #MOD-B60103 mark
               
                       IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                           SELECT COUNT(*) INTO l_cnt FROM ofa_file,ofb_file
                            WHERE ofa01=l_slip      AND ofaconf='Y'
                              AND ofa01=ofb01    #MOD-810094 add
                       ELSE
                           LET l_sql = "SELECT COUNT(*) ",
                                       #"  FROM ",p_dbs_tra CLIPPED,"ofa_file,", #FUN-980092 add
                                       #          p_dbs_tra CLIPPED,"ofb_file ", #FUN-980092 add
                                       "  FROM ",cl_get_target_table(p_plant,'ofa_file'),",", #FUN-A50102
                                                 cl_get_target_table(p_plant,'ofb_file'),     #FUN-A50102
                                       " WHERE ofa01='",l_slip,"'  ",
                                       "   AND ofa01=ofb01 ",   #MOD-810094 add
                                       "   AND ofaconf='Y' "
 	                       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
                           PREPARE ofa_pre3 FROM l_sql
                           EXECUTE ofa_pre3 INTO l_cnt
                       END IF
                       IF l_cnt = 0 THEN
                           IF g_bgerr THEN
                             LET g_showmsg=l_slip,"/",'Y'          
                             CALL s_errmsg('ofa01,ofaconf',g_showmsg,'sel ofa:',SQLCA.SQLCODE,1)
                           ELSE
                             CALL cl_err('sel ofa:',SQLCA.SQLCODE,1)
                             END IF
                           LET g_success='N'  RETURN   #FUN-670007
                       ELSE
                           IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                               SELECT * INTO g_ofa.* FROM ofa_file
                                WHERE ofa01 = l_slip
                           ELSE
                               LET l_sql = "SELECT * ",
                                           #"  FROM ",p_dbs_tra CLIPPED,"ofa_file ", #FUN-980092 add
                                           "  FROM ",cl_get_target_table(p_plant,'ofa_file'),     #FUN-A50102
                                           " WHERE ofa01 = '",l_slip,"' "
 	                           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980092 add
                               PREPARE ofa_pre2 FROM l_sql
                               EXECUTE ofa_pre2 INTO g_ofa.*
                           END IF
                           SELECT poy48 INTO g_t1 FROM poy_file 
                            WHERE poy01=g_poz.poz01
                              AND poy02=i
                           IF SQLCA.sqlcode=100 THEN
                              CALL s_errmsg(' ',' ',' ',SQLCA.sqlcode,1)
                              LET g_success = 'N'
                           END IF
 
                           CALL s_auto_assign_no("axm",g_t1,g_ofa.ofa02,"55","ofa_file","ofa01",l_plant_new,"","") #FUN-980092 add
                               RETURNING li_result,l_ofa01
                           IF (NOT li_result) THEN 
                              LET g_msg = l_plant_new CLIPPED,l_ofa01
                              CALL s_errmsg("ofa01",l_ofa01,g_msg CLIPPED,"mfg3046",1) 
                              LET g_success ='N'
                              RETURN
                           END IF   
                           LET g_ofa.ofa03=l_oea.oea03   #FUN-670007
                           # 取得帳款客戶之 BILL TO 相關資料
                           #LET l_sql = " SELECT * FROM ",l_dbs_new CLIPPED,"occ_file",
                           LET l_sql = " SELECT * FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102
                                       "  WHERE occ01 = '",g_ofa.ofa03,"'"
 	                       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                           PREPARE occ_pre FROM l_sql
                    
                           DECLARE occ_cs CURSOR FOR occ_pre
                    
                           OPEN occ_cs 
                           FETCH occ_cs INTO l_occ.*
                           IF SQLCA.SQLCODE THEN
                               IF g_bgerr THEN
                                 CALL s_errmsg('occ01',g_ofa.ofa03,l_dbs_new CLIPPED,'anm-045',1)
                               ELSE
                                 CALL cl_err(l_dbs_new CLIPPED,'anm-045',1)
                               END IF
                               LET g_success = 'N'
                               RETURN    #FUN-670007
                           END IF
 
                           #  重取單頭訂單單號 
                            IF NOT cl_null(g_ofa.ofa16) THEN
                               LET l_sql  = "SELECT oea01 ",                          
                                            #"  FROM ",l_dbs_new_tra CLIPPED,"oea_file ",  #FUN-980092 add
                                            "  FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                                            " WHERE oea99 ='",g_oea.oea99,"'"   
 	                           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
                               PREPARE ofa16_pre FROM l_sql                          
                               DECLARE ofa16_cs CURSOR FOR ofa16_pre
                               OPEN ofa16_cs
                               FETCH ofa16_cs INTO g_ofa.ofa16
                            END IF
 
                           LET g_ofa.ofa032  = l_occ.occ02
                           LET g_ofa.ofa0351 = l_occ.occ18
                           LET g_ofa.ofa0352 = l_occ.occ19
                           LET g_ofa.ofa0353 = l_occ.occ231
                           LET g_ofa.ofa0354 = l_occ.occ232
                           LET g_ofa.ofa0355 = l_occ.occ233
                           IF tm.oga09 = '6' OR p_oga09 = '6' THEN
                              LET g_ofa.ofa04 = l_oga.oga04
                           ELSE
                              LET g_ofa.ofa04 = g_oga.oga04
                           END IF
                           LET g_ofa.ofa23=l_oga.oga23
                           LET g_ofa.ofa24=l_oga.oga24
                          #-CHI-940042-add-  
                           IF l_oea.oea18 IS NOT NULL AND l_oea.oea18='Y' THEN
                              LET g_ofa.ofa24 = l_oea.oea24
                           END IF
                           IF cl_null(g_ofa.ofa24) THEN LET g_ofa.ofa24=1 END IF
                          #-CHI-940042-end-  
                           LET g_ofa.ofa99=g_flow99        #No.8047
                           LET g_ofa.ofa011=l_oga.oga01    #NO.FUN-670007
                           LET g_ofa.ofa21 = l_oga.oga21   #MOD-8A0165 add
                           LET g_ofa.ofa211 = l_oga.oga211  #MOD-940204 add
                           LET g_ofa.ofa212 = l_oga.oga212  #MOD-940204 add
                           LET g_ofa.ofa213 = l_oga.oga213  #MOD-940204 add
                           LET g_ofa.ofa32 = l_oea.oea32   #No.MOD-5B0320
                           LET g_ofa.ofa16 = l_oga.oga16   #NO.MOD-740162
 
                           #LET l_sql2="INSERT INTO ",l_dbs_new_tra CLIPPED,"ofa_file", #FUN-980092 add
                           LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ofa_file'), #FUN-A50102
                                      " (ofa00,ofa01,ofa011,ofa02,ofa03,",
                                      "  ofa032,ofa033,ofa0351,ofa0352,ofa0353,",
                                      "  ofa0354,ofa0355,ofa04,ofa044,ofa0451, ",
                                      "  ofa0452,ofa0453,ofa0454,ofa0455,ofa08, ",
                                      "  ofa10,ofa16,ofa18,ofa21,ofa211, ",
                                      "  ofa212,ofa213,ofa23,ofa24,ofa25, ",
                                      "  ofa26,ofa27,ofa28,ofa29,ofa30, ",
                                      "  ofa31,ofa32,ofa33,ofa35,ofa36, ",
                                      "  ofa37,ofa38,ofa39,ofa41,ofa99, ", #No.8047
                                      "  ofa42,ofa43,ofa44,ofa45,ofa46, ",
                                      "  ofa47,ofa48,ofa49,ofa50,ofa61, ",
                                      "  ofa62,ofa63,ofa71,ofa72,ofa73, ",
                                      "  ofa741,ofa742,ofa743,ofa75,ofa76, ",
                                      "  ofa77,ofa78,ofa79,ofa908,ofaconf, ",
                                      "  ofaprsw,ofauser,ofagrup,ofamodu,ofadate, ",
                                      "  ofaplant,ofalegal, ",
                                      "  ofaud01,ofaud02,ofaud03,ofaud04,ofaud05,",
                                      "  ofaud06,ofaud07,ofaud08,ofaud09,ofaud10,",
                                      "  ofaud11,ofaud12,ofaud13,ofaud14,ofaud15,ofaoriu,ofaorig)", #FUN-A10036
                                      " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                                      "        ?,?,?,?,?, ?,?,?,?,?, ",
                                      "        ?,?,?,?,?, ?,?,?,?,?, ",
                                      "        ?,?,?,?,?, ?,?,?,?,?, ",
                                      "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", #CHI-950020
                                      "        ?,?,?,?,?, ?,?,?,?,?, ",
                                      "        ?,?,?,?,?, ?,?,?,?,?, ",
                                      "        ?,?,?,?,?, ?,?,?,?,?,  ",
                                      "        ?,?,?,?,?, ?,?,?,?) "  #FUN-980010 #FUN-A10036
 	                       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
                           PREPARE ins_ofa FROM l_sql2
                           EXECUTE ins_ofa USING 
                                   g_ofa.ofa00,l_ofa01,g_ofa.ofa011,g_ofa.ofa02,
                                   g_ofa.ofa03,
                                   g_ofa.ofa032,g_ofa.ofa033,g_ofa.ofa0351,
                                   g_ofa.ofa0352,g_ofa.ofa0353,
                                   g_ofa.ofa0354,g_ofa.ofa0355,g_ofa.ofa04,
                                   g_ofa.ofa044,g_ofa.ofa0451,
                                   g_ofa.ofa0452,g_ofa.ofa0453,g_ofa.ofa0454,
                                   g_ofa.ofa0455,g_ofa.ofa08,
                                   g_ofa.ofa10,g_ofa.ofa16,g_ofa.ofa18,g_ofa.ofa21,
                                   g_ofa.ofa211,
                                   g_ofa.ofa212,g_ofa.ofa213,g_ofa.ofa23,g_ofa.ofa24,
                                   g_ofa.ofa25,
                                   g_ofa.ofa26,g_ofa.ofa27,g_ofa.ofa28,g_ofa.ofa29,
                                   g_ofa.ofa30,
                                   g_ofa.ofa31,g_ofa.ofa32,g_ofa.ofa33,g_ofa.ofa35,
                                   g_ofa.ofa36,
                                   g_ofa.ofa37,g_ofa.ofa38,g_ofa.ofa39,
                                   g_ofa.ofa41,g_ofa.ofa99,  #No.8047
                                   g_ofa.ofa42,g_ofa.ofa43,g_ofa.ofa44,g_ofa.ofa45,
                                   g_ofa.ofa46,
                                   g_ofa.ofa47,g_ofa.ofa48,g_ofa.ofa49,g_ofa.ofa50,
                                   g_ofa.ofa61,
                                   g_ofa.ofa62,g_ofa.ofa63,g_ofa.ofa71,g_ofa.ofa72,
                                   g_ofa.ofa73,
                                   g_ofa.ofa741,g_ofa.ofa742,g_ofa.ofa743,
                                   g_ofa.ofa75, g_ofa.ofa76,
                                   g_ofa.ofa77,g_ofa.ofa78,g_ofa.ofa79,g_ofa.ofa908,
                                   g_ofa.ofaconf,
                                   g_ofa.ofaprsw,g_ofa.ofauser,g_ofa.ofagrup,
                                   g_ofa.ofamodu,g_ofa.ofadate,
                                   gp_plant,gp_legal   #FUN-980010
                                  ,g_ofa.ofaud01,g_ofa.ofaud02,g_ofa.ofaud03,
                                   g_ofa.ofaud04,g_ofa.ofaud05,g_ofa.ofaud06,
                                   g_ofa.ofaud07,g_ofa.ofaud08,g_ofa.ofaud09,
                                   g_ofa.ofaud10,g_ofa.ofaud11,g_ofa.ofaud12,
                                   g_ofa.ofaud13,g_ofa.ofaud14,g_ofa.ofaud15,g_user,g_grup #FUN-A10036
                           IF SQLCA.sqlcode<>0 THEN
                               IF g_bgerr THEN
                                LET g_showmsg=l_ofa01,"/",g_ofa.ofa02,"/",g_ofa.ofa03
                                CALL s_errmsg('ofa01,ofa02,ofa03',g_showmsg,'ins ofa:',SQLCA.sqlcode,1)
                               ELSE
                                CALL cl_err('ins ofa:',SQLCA.sqlcode,1)
                               END IF
                               LET g_success = 'N'
                           END IF
                    
                           #---INSERT Invoice 單身檔
                           IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                               LET l_sql = "SELECT ofb_file.*,oea_file.oea99 ",
                                           "  FROM ofb_file,oea_file ",
                                           "  WHERE ofb01 = '",g_ofa.ofa01,"'",
                                           "   AND ofb31 = oea01"
                           ELSE
                               #LET l_sql = "SELECT * FROM ",p_dbs_tra CLIPPED,"ofb_file, ",
                               #                             p_dbs_tra CLIPPED,"oea_file  ",
                              #LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ofb_file'),",", #FUN-A50102 #MOD-D40139 mark
                               LET l_sql = "SELECT ofb_file.*,oea_file.oea99 FROM ",cl_get_target_table(p_plant,'ofb_file'),",", #MOD-D40139 add
                                                            cl_get_target_table(p_plant,'oea_file'),     #FUN-A50102
                                           " WHERE ofb01 = '",g_ofa.ofa01,"' ",
                                           "   AND ofb31 = oea01"
                           END IF
 	                       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092 add
                           PREPARE ofb_pre2 FROM l_sql
                           DECLARE ofb_cs CURSOR FOR ofb_pre2
                           FOREACH ofb_cs INTO g_ofb.*,g_oea99   #MOD-740042 add g_oea99
                               LET l_sql1 = "SELECT * ",
                                            #"  FROM ",l_dbs_new_tra CLIPPED,"oeb_file,",
                                            #          l_dbs_new_tra CLIPPED,"oea_file ",
                                            "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'),",", #FUN-A50102
                                                      cl_get_target_table(l_plant_new,'oea_file'),     #FUN-A50102
                                            " WHERE oeb01=oea01 ",
                                            "   AND oea99 ='",g_oea99,"'",                            
                                            "   AND oeb03=",g_ofb.ofb32
                     
 	                           CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
                               CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1  #FUN-980092 add
                               PREPARE oeb_p3 FROM l_sql1
                               IF SQLCA.SQLCODE THEN 
                                   IF g_bgerr THEN
                                     LET g_showmsg=g_ofb.ofb31,"/",g_ofb.ofb32
                                     CALL s_errmsg('oeb01,oeb03',g_showmsg,'oeb_p3',SQLCA.SQLCODE,1)
                                   ELSE
                                     CALL cl_err('ins ofa:',SQLCA.sqlcode,1)
                                   END IF
                               END IF
                    
                               DECLARE oeb_c3 CURSOR FOR oeb_p3
                    
                               OPEN oeb_c3
                               FETCH oeb_c3 INTO p_oeb.*
                               CLOSE oeb_c3
 
                               LET g_ofb.ofb13=p_oeb.oeb13
                               IF g_ofa.ofa213 = 'N' THEN
                                   LET g_ofb.ofb14 =g_ofb.ofb917*g_ofb.ofb13  #MOD-7A0051 ofb12->ofb917
                                   LET g_ofb.ofb14t=g_ofb.ofb14*(1+g_ofa.ofa211/100)
                               ELSE
                                   LET g_ofb.ofb14t=g_ofb.ofb917*g_ofb.ofb13   #MOD-7A0051 ofb12->ofb917
                                   LET g_ofb.ofb14 =g_ofb.ofb14t/(1+g_ofa.ofa211/100)
                               END IF
                               CALL cl_digcut(g_ofb.ofb14,l_azi.azi04) RETURNING g_ofb.ofb14   #MOD-7A0051 add
                               CALL cl_digcut(g_ofb.ofb14t,l_azi.azi04) RETURNING g_ofb.ofb14t  #MOD-7A0051 add
                    
                               #LET l_sql2="INSERT INTO ",l_dbs_new_tra CLIPPED,"ofb_file", #FUN-980092 add
                               LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ofb_file'), #FUN-A50102
                                          " (ofb01,ofb03,ofb04,ofb05,ofb06,",
                                          " ofb07,ofb11,ofb12,ofb13,",
                                          " ofb14,ofb14t,ofb31,ofb32,ofb33,",
                                          " ofb34,ofb35,ofb910,ofb911,ofb912,",
                                          " ofb913,ofb914,ofb915,ofb916,ofb917,",
                                          " ofbplant,ofblegal,",
                                          " ofbud01,ofbud02,ofbud03,",
                                          " ofbud04,ofbud05,ofbud06,",
                                          " ofbud07,ofbud08,ofbud09,",
                                          " ofbud10,ofbud11,ofbud12,",
                                          " ofbud13,ofbud14,ofbud15)",
                                          " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                                          "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?, ",
                                          "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ", #CHI-950020
                                          "        ?,? )"  #FUN-980010
 	                           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2  #FUN-A50102
                               PREPARE ins_ofb FROM l_sql2
                       
                               EXECUTE ins_ofb USING 
                                       l_ofa01,g_ofb.ofb03,g_ofb.ofb04,g_ofb.ofb05,
                                       g_ofb.ofb06,
                                       g_ofb.ofb07,g_ofb.ofb11,g_ofb.ofb12,g_ofb.ofb13,
                                       g_ofb.ofb14,g_ofb.ofb14t,p_oeb.oeb01,p_oeb.oeb03,  #MOD-810094 add
                                       g_ofb.ofb33,
                                       g_ofa.ofa011,g_ofb.ofb35,g_ofb.ofb910,g_ofb.ofb911,  #MOD-7C0189 add
                                       g_ofb.ofb912,g_ofb.ofb913,g_ofb.ofb914,g_ofb.ofb915,
                                       g_ofb.ofb916,g_ofb.ofb917,
                                       gp_plant,gp_legal   #FUN-980010
                                      ,g_ofb.ofbud01,g_ofb.ofbud02,
                                       g_ofb.ofbud03,g_ofb.ofbud04,
                                       g_ofb.ofbud05,g_ofb.ofbud06,
                                       g_ofb.ofbud07,g_ofb.ofbud08,
                                       g_ofb.ofbud09,g_ofb.ofbud10,
                                       g_ofb.ofbud11,g_ofb.ofbud12,
                                       g_ofb.ofbud13,g_ofb.ofbud14,
                                       g_ofb.ofbud15
 
                                       IF SQLCA.sqlcode<>0 THEN
                                          IF g_bgerr THEN
                                             LET g_showmsg=l_ofa01,"/",g_ofb.ofb03,"/",g_ofb.ofb04
                                             CALL s_errmsg('ofb01,ofb03,ofb04',g_showmsg,'ins ofb:',SQLCA.sqlcode,1)
                                          ELSE
                                             CALL cl_err('ins ofb:',SQLCA.sqlcode,1)
                                          END IF
                                           LET g_success = 'N'
                                           EXIT FOREACH 
                                       END IF
                           END FOREACH
                    
                           #-------- 重計單頭金額 ---------------
                           #LET l_sql ="SELECT SUM(ofb14) FROM ",l_dbs_new_tra CLIPPED, #FUN-980092 add
                           #           " ofb_file ",
                           LET l_sql ="SELECT SUM(ofb14) FROM ",cl_get_target_table(l_plant_new,'ofb_file'), #FUN-A50102
                                      " WHERE ofb01 ='",l_ofa01,"'"
 	                       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
                           PREPARE ofa50_pre FROM l_sql
                           DECLARE ofa50_cs CURSOR FOR ofa50_pre
                    
                           OPEN ofa50_cs
                           FETCH ofa50_cs INTO g_ofa.ofa50
                           IF SQLCA.SQLCODE THEN
                               LET g_msg = l_dbs_new CLIPPED,'sum ofa14'
                               IF g_bgerr THEN
                                  CALL s_errmsg('ofb01',l_ofa01,g_msg,SQLCA.SQLCODE,1)
                               ELSE
                                  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                               END IF
                               LET g_success='N'
                           END IF
                    
                           #LET l_sql =" UPDATE ",l_dbs_new_tra CLIPPED," ofa_file ", #FUN-980092 add
                           LET l_sql =" UPDATE ",cl_get_target_table(l_plant_new,'ofa_file'), #FUN-A50102
                                      "    SET ofa50 =",g_ofa.ofa50,
                                      " WHERE ofa01 = '",l_ofa01,"'"
 	                       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
                           PREPARE upofa50_pre FROM l_sql
                     
                           EXECUTE upofa50_pre
                           IF SQLCA.SQLCODE OR SQLCA.SQLCODE THEN
                               LET g_msg = l_dbs_new CLIPPED,'sum ofa50'
                                IF g_bgerr THEN
                                  CALL s_errmsg('ofa01',l_ofa01,g_msg,SQLCA.SQLCODE,1)
                                ELSE
                                   CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                                END IF
                           END IF
                    
                           #  出貨單
                           #LET l_sql = "UPDATE ",l_dbs_new_tra CLIPPED, "oga_file", #FUN-980092 add
                           LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                                       "  SET oga27  =  ? ",
                                       " WHERE oga01 = '",l_oga.oga01,"'"
                           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
                           PREPARE ofa27_upd1 FROM l_sql
                           EXECUTE ofa27_upd1 USING l_ofa01
                           IF SQLCA.SQLCODE THEN
                               LET g_msg = l_dbs_new CLIPPED,'upd oga27'
                               IF g_bgerr THEN
                                  CALL s_errmsg('oga01',l_oga.oga01,g_msg,SQLCA.SQLCODE,1)
                               ELSE
                                   CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                               END IF
                               LET g_success='N'
                           END IF
                       END IF
                   END IF
               END IF       #No.8047(end)
           END IF
END FUNCTION
 
FUNCTION p900_azp(l_n)
   DEFINE l_source LIKE type_file.num5,    #No.FUN-680137 SMALLINT    #來源站別
          l_n      LIKE type_file.num5,    #當站站別  #No.FUN-680137 SMALLINT
          l_n2     LIKE type_file.num5     #當站站別
   DEFINE l_sql1   STRING                  #MOD-9C0274
   DEFINE l_poy11  LIKE poy_file.poy11
   DEFINE l_poy03  LIKE poy_file.poy03
    
   ##-------------取得前一站資料庫----------------------
   LET l_n2     = l_n + 1             #(前一站)  #No.8858
   LET l_source = l_n - 1             #來源站別(前一站)
      SELECT * INTO s_poy.* FROM poy_file 
       WHERE poy01 = g_poz.poz01
         AND poy02 = l_source
 
   ##-------------取得當站資料庫----------------------
   SELECT * INTO g_poy.* FROM poy_file               #取得當站流程設定
    WHERE poy01 = g_poz.poz01 AND poy02 = l_n
 
# 取得下一站資料
   SELECT * INTO n_poy.* FROM poy_file               #取得當站流程設定
    WHERE poy01 = g_poz.poz01 AND poy02 = l_n2
   LET s_imd01 = n_poy.poy11
 
   SELECT * INTO s_azp.* FROM azp_file
    WHERE azp01= n_poy.poy04
 
   LET s_dbs_new = s_dbstring(s_azp.azp03 CLIPPED)     #TQC-950032 ADD     
 
   LET s_plant_new = n_poy.poy04
   LET g_plant_new = n_poy.poy04
   CALL s_gettrandbs()
   LET s_dbs_new_tra = g_dbs_tra
 
 
   SELECT * INTO l_azp.* FROM azp_file
    WHERE azp01=g_poy.poy04
 
 
   LET l_plant_new = l_azp.azp01                     #FUN-980020
   LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED)   #TQC-950032 ADD
 
   LET g_plant_new = g_poy.poy04
   CALL s_gettrandbs()
   LET l_dbs_new_tra = g_dbs_tra
 
   LET l_sql1 = "SELECT * ",
                #"  FROM ",l_dbs_new CLIPPED,"aza_file ",
                "  FROM ",cl_get_target_table(l_plant_new,'aza_file'), #FUN-A50102
                " WHERE aza01 = '0' "
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE aza_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
         CALL s_errmsg('aza01',0,'aza_p1',SQLCA.SQLCODE,1) 
      ELSE
         CALL cl_err('aza_p1',SQLCA.SQLCODE,1)
      END IF
   END IF
 
   DECLARE aza_c1 CURSOR FOR aza_p1
 
   OPEN aza_c1
   FETCH aza_c1 INTO l_aza.*    #No.FUN-670007
   CLOSE aza_c1
   LET p_pmm09 = n_poy.poy03    #供應廠商    
   LET p_oea03 = g_poy.poy03    #帳款客戶(上游廠商)
   LET p_imd01 = g_poy.poy11    #倉庫別
   LET p_poy16 = g_poy.poy16    #MOD-940299
   LET p_poy28 = g_poy.poy28    #NO.FUN-620024
   LET p_poy29 = g_poy.poy29    #NO.FUN-620024
 
   #若為來源廠
   IF l_n = 0 THEN 
      #LET l_sql1= " SELECT oea03 FROM ",l_dbs_new_tra,"oea_file", #FUN-980092 add
      LET l_sql1= " SELECT oea03 FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                  "  WHERE oea01 = '",g_oea.oea01,"'"
 
 	  CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092 add
      PREPARE oea03_pre FROM l_sql1
 
      DECLARE oea03_cs CURSOR FOR oea03_pre
 
      OPEN oea03_cs 
      FETCH oea03_cs INTO p_oea03
      #no.6462(end)
 
      SELECT poy03 INTO p_pmm09 FROM poy_file 
       WHERE poy01 = g_poz.poz01
         AND poy02 = 1
   END IF
END FUNCTION
 
#讀取幣別檔之資料
FUNCTION p900_azi(l_oga23)
   DEFINE l_sql1   STRING                 #MOD-9C0274
   DEFINE l_oga23  LIKE oga_file.oga23
 
   #讀取l_dbs_new 之原幣資料
   LET l_sql1 = "SELECT * ",
                #"  FROM ",l_dbs_new CLIPPED,"azi_file ",
                "  FROM ",cl_get_target_table(l_plant_new,'azi_file'), #FUN-A50102
                " WHERE azi01='",l_oga23,"' " 
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE azi_p2 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN
        CALL s_errmsg('azi01',l_oga23,'azi_p2',SQLCA.SQLCODE,0)  
      ELSE
        CALL cl_err('azi_p2',SQLCA.SQLCODE,1)  
      END IF
   END IF
 
   DECLARE azi_c2 CURSOR FOR azi_p2
 
   OPEN azi_c2
   FETCH azi_c2 INTO l_azi.* 
   CLOSE azi_c2
 
END FUNCTION
 
FUNCTION p900_ogains(i)                   #No.FUN620054
   DEFINE l_sql,l_sql1,l_sql2       STRING #MOD-9C0274
   DEFINE i,l_i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE li_result LIKE type_file.num5     #FUN-560043  #No.FUN-680137 SMALLINT
   DEFINE l_pmn24   LIKE pmn_file.pmn24   #No.FUN-630006
    
   IF tm.oga09="6" AND g_oea.oea37="Y" AND i = 0  AND g_oaz.oaz19 = 'Y' THEN    #No.FUN-640025  #NO.TQC-640134  
      #LET l_sql1 = "SELECT ",l_dbs_new_tra CLIPPED,"pmn_file.pmn24 ",                    
      #             "  FROM ",l_dbs_new_tra CLIPPED,"pmn_file,",
      #                       l_dbs_new_tra CLIPPED,"pmm_file",
      LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'pmn_file'),".pmn24",  #FUN-A50102                    
                   "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",",       #FUN-A50102
                             cl_get_target_table(l_plant_new,'pmm_file'),           #FUN-A50102
                   " WHERE pmn01 = pmm01",                                       
                   "   AND pmm99 ='",g_oea.oea99,"'",                            
                   "   AND pmn02 =",g_ogb.ogb32
      
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092 add
      PREPARE pmn24_p1 FROM l_sql1
      IF SQLCA.SQLCODE THEN
         IF g_bgerr THEN
          LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32
          CALL s_errmsg('pmn01,pmn99,pmn02',g_showmsg,'pmn24_p1',SQLCA.SQLCODE,1) 
         ELSE 
          CALL cl_err('pmn24_p1',SQLCA.SQLCODE,1)
         END IF
      END IF
      
      DECLARE pmn24_c1 CURSOR FOR pmn24_p1
      
      OPEN pmn24_c1
      FETCH pmn24_c1 INTO l_pmn24
      IF SQLCA.SQLCODE <> 0 THEN
         IF g_bgerr THEN 
          CALL s_errmsg('pmn01,pmn99,pmn02',g_showmsg,'pmn24_c1',SQLCA.SQLCODE,1) 
         END IF 
         LET g_success='N'
         RETURN
      END IF
 
      #讀取該流程代碼之銷單資料
      LET l_sql1 = "SELECT * ",
                   #"  FROM ",l_dbs_new_tra CLIPPED,"oea_file ", #FUN-980092 add
                   "  FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                   " WHERE oea01='",l_pmn24,"' "
   ELSE
      #讀取該流程代碼之銷單資料
      LET l_sql1 = "SELECT * ",
                   #"  FROM ",l_dbs_new_tra CLIPPED,"oea_file ", #FUN-980092 add
                   "  FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                   " WHERE oea99='",g_oea.oea99,"' "      #NO.FUN-620024
   END IF
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1  #FUN-980092 add
   PREPARE oea_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
       CALL s_errmsg('oea99',g_oea.oea99,'oea_p1',SQLCA.SQLCODE,1)  
      ELSE 
       CALL cl_err('oea_p1',SQLCA.SQLCODE,1)
      END IF
   END IF
 
   DECLARE oea_c1 CURSOR FOR oea_p1
 
   OPEN oea_c1
   FETCH oea_c1 INTO l_oea.*
   IF SQLCA.SQLCODE <> 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('oea99',g_oea.oea99,'oea_c1',SQLCA.SQLCODE,1)  
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   CLOSE oea_c1
 
   #新增出貨單單頭檔(oga_file)
   LET l_oga.oga00 = l_oea.oea00        #出貨別
       CALL s_auto_assign_no("axm",oga_t1,g_oga.oga02,"","oga_file","oga01",l_plant_new,"","") #FUN-980092 add
            RETURNING li_result,l_oga.oga01
       IF (NOT li_result) THEN 
          LET g_msg = l_plant_new CLIPPED,l_oga.oga01
          CALL s_errmsg("oga01",l_oga.oga01,g_msg CLIPPED,"mfg3046",1) 
          LET g_success ='N'
          RETURN
       END IF   
   IF cl_null(l_oga99) THEN
      LET l_oga.oga011=g_oga.oga011        #出貨通知單號
   ELSE
      LET l_sql1 = "SELECT * ",
                   #"  FROM ",l_dbs_new_tra CLIPPED,"oga_file ", #FUN-980092 add
                   "  FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                   " WHERE oga99 ='",l_oga99,"' ",
                   "   AND oga09 = '5' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1  #FUN-980092 add
   PREPARE oga_p1 FROM l_sql1
 
   DECLARE oga_c1 CURSOR FOR oga_p1
 
   OPEN oga_c1
   FETCH oga_c1 INTO s_oga.*
      LET l_oga.oga011= s_oga.oga01       #出貨通知單號
   END IF
   LET l_oga.oga02 = g_oga.oga02        #出貨日期
   LET l_oga.oga021= g_oga.oga021       #結關日期
   LET l_oga.oga022= g_oga.oga022       #裝船日期
   LET l_oga.oga03 = l_oea.oea03
   LET l_oga.oga032= l_oea.oea032
   LET l_oga.oga033= l_oea.oea033
   #MOD-C10097 add --start--
   IF tm.oga09 = '6' OR p_oga09 = '6' THEN #代採買
      LET l_oga.oga04 = l_oea.oea04
   ELSE #銷售
   #MOD-C10097 add --end--
      LET l_oga.oga04 = g_oga.oga04	#MOD-960342
   END IF #MOD-C10097 add
   LET l_oga.oga044= g_oga.oga044
   LET l_oga.oga05 = l_oea.oea05
   LET l_oga.oga06 = l_oea.oea06
   LET l_oga.oga07 = l_oea.oea07
   LET l_oga.oga08 = l_oea.oea08
   LET l_oga.oga09 = tm.oga09           #No.8047
   LET l_oga.oga10 = null
   LET l_oga.oga11 = null
   LET l_oga.oga12 = null
   LET l_oga.oga13 = p_poy16           			#MOD-940299 add
   LET l_oga.oga14 = l_oea.oea14
   LET l_oga.oga15 = l_oea.oea15
   #來源出貨單單頭若無訂單號,拋轉後也不應有訂單號
   IF cl_null(g_oga.oga16) THEN
      LET l_oga.oga16 = null                              
   ELSE 
      LET l_oga.oga16 = l_oea.oea01     #NO.FUN-620024
   END IF
   IF cl_null(l_oea.oea161) THEN
      LET l_oea.oea161 = 0
   END IF
   IF cl_null(l_oea.oea162) THEN
      LET l_oea.oea162 = 100
   END IF
   IF cl_null(l_oea.oea163) THEN
      LET l_oea.oea163 = 0
   END IF
   LET l_oga.oga161= l_oea.oea161
   LET l_oga.oga162= l_oea.oea162
   LET l_oga.oga163= l_oea.oea163
   LET l_oga.oga18 = l_oea.oea17
   LET l_oga.oga19 = null
   LET l_oga.oga20 = 'Y'
   LET l_oga.oga21 = l_oea.oea21
   LET l_oga.oga211= l_oea.oea211
   LET l_oga.oga212= l_oea.oea212
   LET l_oga.oga213= l_oea.oea213
   LET l_oga.oga23 = l_oea.oea23
   CALL p900_azi(l_oea.oea23)   #讀取幣別資料
 
   #出貨時重新抓取匯率
   CALL s_currm(l_oga.oga23,l_oga.oga02,g_oaz32,l_plant_new)  #FUN-980020
       RETURNING l_oga.oga24
 
   #若出貨單頭之幣別=本幣幣別, 則匯率給1, (COI美金立帳, 99.03.05)
   IF l_oga.oga23 = l_aza.aza17 THEN
      LET l_oga.oga24=1
   END IF
   IF cl_null(l_oga.oga24) THEN LET l_oga.oga24=l_oea.oea24 END IF
  #-CHI-940042-add-  
   IF l_oea.oea18 IS NOT NULL AND l_oea.oea18='Y' THEN
      LET l_oga.oga24 = l_oea.oea24
   END IF
   IF cl_null(l_oga.oga24) THEN LET l_oga.oga24=1 END IF
  #-CHI-940042-end-  
   LET l_oga.oga25 = l_oea.oea25
   LET l_oga.oga26 = l_oea.oea26
   IF cl_null(l_oga99) THEN
      LET l_oga.oga27 = g_oga.oga27
   ELSE
      LET l_oga.oga27 = s_oga.oga27
   END IF
   LET l_oga.oga28 = l_oea.oea18
   LET l_oga.oga29 = 0
   LET l_oga.oga30 = g_oga.oga30  #MOD-7A0156 modify 'N'
   LET l_oga.oga31 = g_oga.oga31
   LET l_oga.oga32 = l_oea.oea32
   LET l_oga.oga33 = l_oea.oea33
   LET l_oga.oga34 = 0
   LET l_oga.oga35 = g_oga.oga35
   LET l_oga.oga36 = g_oga.oga36
   LET l_oga.oga37 = g_oga.oga37
   LET l_oga.oga38 = g_oga.oga38
   LET l_oga.oga39 = g_oga.oga39
   LET l_oga.oga40 = l_oea.oea19
   LET l_oga.oga41 = g_oga.oga41
   LET l_oga.oga42 = g_oga.oga42
   LET l_oga.oga43 = g_oga.oga43
   LET l_oga.oga44 = g_oga.oga44
   LET l_oga.oga45 = l_oea.oea45
   LET l_oga.oga46 = l_oea.oea46
   LET l_oga.oga47 = g_oga.oga47
   LET l_oga.oga48 = g_oga.oga48
   LET l_oga.oga49 = g_oga.oga49
   LET l_oga.oga50 = 0
   LET l_oga.oga52 = 0
   LET l_oga.oga53 = 0
   LET l_oga.oga54 = 0
   LET l_oga.oga55 = l_oea.oea49    #TQC-690065
   LET l_oga.oga57 = '1'            #FUN-AC0055 add 
  #LET l_oga.oga65 = l_oea.oea65    #FUN-7B0091 add #FUN-C40072 mark
   LET l_oga.oga65 = 'N'            #FUN-C40072 add
   LET l_oga.oga69 = g_oga.oga69    #FUN-670007
   LET l_oga.oga99 = g_flow99    #No.8047
   LET l_oga.oga901='N'
   LET l_oga.oga905='Y'
   LET l_oga.oga906='N'
   LET l_oga.oga909='Y'
   LET l_oga.oga903 = g_oga.oga903  #MOD-7A0156
   LET l_oga.ogamksg = g_oga.ogamksg  #MOD-7A0156
   IF s_aza.aza50 = 'Y' THEN                                                   
      LET l_oga.oga1001 = l_oea.oea1001  #收款客戶編號                                         
      LET l_oga.oga1002 = l_oea.oea1002  #債權代碼                                         
      LET l_oga.oga1003 = l_oea.oea1003  #業績歸屬方                                         
      LET l_oga.oga1004 = l_oea.oea1004  #代送商                                         
      LET l_oga.oga1005 = l_oea.oea1005  #是否計算業績                                         
      LET l_oga.oga1006 = 0              #未稅金額                                         
      LET l_oga.oga1007 = 0              #含稅金額                                         
      LET l_oga.oga1008 = 0              #出貨總含稅金額                                         
      LET l_oga.oga1009 = l_oea.oea1009  #客戶所屬渠道                                         
      LET l_oga.oga1010 = l_oea.oea1010  #客戶所屬方                                         
      LET l_oga.oga1011 = l_oea.oea1011  #開票客戶                                         
      LET l_oga.oga1012 = ''             #銷退單單號                                         
      LET l_oga.oga1013 = 'N'            #已打印提單否                                         
      LET l_oga.oga1014 = 'N'            #是否對應代送銷退單                                         
      LET l_oga.oga1015 = '0'            #導物流狀況碼
   END IF                                                   
   LET l_oga.ogaconf='Y'
   LET l_oga.ogapost='Y'
   LET l_oga.ogaprsw=0
   LET l_oga.ogauser=g_user
   LET l_oga.ogagrup=g_grup
   LET l_oga.ogamodu=null
   LET l_oga.ogadate=null
   LET l_oga.ogaud01 = g_oga.ogaud01
   LET l_oga.ogaud02 = g_oga.ogaud02
   LET l_oga.ogaud03 = g_oga.ogaud03
   LET l_oga.ogaud04 = g_oga.ogaud04
   LET l_oga.ogaud05 = g_oga.ogaud05
   LET l_oga.ogaud06 = g_oga.ogaud06
   LET l_oga.ogaud07 = g_oga.ogaud07
   LET l_oga.ogaud08 = g_oga.ogaud08
   LET l_oga.ogaud09 = g_oga.ogaud09
   LET l_oga.ogaud10 = g_oga.ogaud10
   LET l_oga.ogaud11 = g_oga.ogaud11
   LET l_oga.ogaud12 = g_oga.ogaud12
   LET l_oga.ogaud13 = g_oga.ogaud13
   LET l_oga.ogaud14 = g_oga.ogaud14
   LET l_oga.ogaud15 = g_oga.ogaud15
 
   CALL p900_chk99()   #FUN-5A0155
   #新增出貨單頭檔(oga_file)
   #LET l_sql2="INSERT INTO ",l_dbs_new_tra CLIPPED,"oga_file", #FUN-980092 add
   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
              "( oga00,oga01,oga011,oga02, ",
              "  oga021,oga022,oga03,oga032,",
              "  oga033,oga04,oga044,oga05,",
              "  oga06,oga07,oga08,oga09,",
              "  oga10,oga11,oga12,oga13,",
              "  oga14,oga15,oga16,oga161,",
              "  oga162,oga163,oga17,oga18,",
              "  oga19,oga20,oga21,oga211,",
              "  oga212,oga213,oga23,oga24,",
              "  oga25,oga26,oga27,oga28,",
              "  oga29,oga30,oga31,oga32,",
              "  oga33,oga34,oga35,",
              "  oga36,oga37,oga38,oga39,",
              "  oga40,oga41,oga42,oga43,",
              "  oga44,oga45,oga46,oga47,",
              "  oga48,oga49,oga50,oga52,",
              "  oga53,oga54,oga55,oga57,oga69,",          #No.8047 #No.TQC-690065 add oga55  #FUN-670007 add oga69 #FUN-AC0055 add oga57
              "  oga65,oga99,",                      #FUN-7B0091 add oga65
              "  oga901,oga902,",
              "  oga903,oga904,oga905,oga906,",
              "  oga907,oga908,oga909,oga1001,",     #NO.FUN-620024               
              "  oga1002,oga1003,oga1004,oga1005,",  #NO.FUN-620024               
              "  oga1006,oga1007,oga1008,oga1009,",  #NO.FUN-620024               
              "  oga1010,oga1011,oga1012,oga1013,",  #NO.FUN-620024               
              "  oga1014,oga1015,ogaconf,",          #NO.FUN-620024
              "  ogapost,ogaprsw,ogauser,ogagrup,",
              "  ogamodu,ogadate,ogamksg, ",         #MOD-7A0156 modify
              "  ogaplant,ogalegal, ",
              "  ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,",
              "  ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,",
              "  ogaud11,ogaud12,ogaud13,ogaud14,ogaud15,ogaoriu,ogaorig)",  #FUN-A10036
              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,", #No.TQC-690065 add ?
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",    #No.CHI-950020
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",    #NO.FUN-620024
                       "?,?,?,?, ?, ",  #MOD-7A0156 modify   #FUN-7B0091 add?
                       "?,?,?,? ) "          #FUN-980010 #FUN-A10036
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2  #FUN-A50102
   PREPARE ins_oga FROM l_sql2
 
   EXECUTE ins_oga USING 
         l_oga.oga00,l_oga.oga01,l_oga.oga011,l_oga.oga02, 
         l_oga.oga021,l_oga.oga022,l_oga.oga03,l_oga.oga032,
         l_oga.oga033,l_oga.oga04,l_oga.oga044,l_oga.oga05,
         l_oga.oga06,l_oga.oga07,l_oga.oga08,l_oga.oga09,
         l_oga.oga10,l_oga.oga11,l_oga.oga12,l_oga.oga13,
         l_oga.oga14,l_oga.oga15,l_oga.oga16,l_oga.oga161,
         l_oga.oga162,l_oga.oga163,l_oga.oga17,l_oga.oga18,
         l_oga.oga19,l_oga.oga20,l_oga.oga21,l_oga.oga211,
         l_oga.oga212,l_oga.oga213,l_oga.oga23,l_oga.oga24,
         l_oga.oga25,l_oga.oga26,l_oga.oga27,l_oga.oga28,
         l_oga.oga29,l_oga.oga30,l_oga.oga31,l_oga.oga32,
         l_oga.oga33,l_oga.oga34,l_oga.oga35,
         l_oga.oga36,l_oga.oga37,l_oga.oga38,l_oga.oga39,
         l_oga.oga40,l_oga.oga41,l_oga.oga42,l_oga.oga43,
         l_oga.oga44,l_oga.oga45,l_oga.oga46,l_oga.oga47,
         l_oga.oga48,l_oga.oga49,l_oga.oga50,l_oga.oga52,
         l_oga.oga53,l_oga.oga54,l_oga.oga55,l_oga.oga57,l_oga.oga69,     #No.8047 #No.TQC-690065 add oga55  #FUN-670007 add oga69  #FUN-AC0055 add l_oga.oga57
         l_oga.oga65,l_oga.oga99,   #FUN-7B0091 add oga65
         l_oga.oga901,l_oga.oga902,
         l_oga.oga903,l_oga.oga904,l_oga.oga905,l_oga.oga906,
         l_oga.oga907,l_oga.oga908,l_oga.oga909,l_oga.oga1001,    #NO.FUN-620024
         l_oga.oga1002,l_oga.oga1003,l_oga.oga1004,l_oga.oga1005, #NO.FUN-620024
         l_oga.oga1006,l_oga.oga1007,l_oga.oga1008,l_oga.oga1009, #NO.FUN-620024
         l_oga.oga1010,l_oga.oga1011,l_oga.oga1012,l_oga.oga1013, #NO.FUN-620024
         l_oga.oga1014,l_oga.oga1015,l_oga.ogaconf,               #NO.FUN-620024
         l_oga.ogapost,l_oga.ogaprsw,l_oga.ogauser,l_oga.ogagrup,
         l_oga.ogamodu,l_oga.ogadate,l_oga.ogamksg,  #MOD-7A0156 modify 
         gp_plant,gp_legal   #FUN-980010
        ,l_oga.ogaud01,l_oga.ogaud02,l_oga.ogaud03,l_oga.ogaud04,l_oga.ogaud05,
         l_oga.ogaud06,l_oga.ogaud07,l_oga.ogaud08,l_oga.ogaud09,l_oga.ogaud10,
         l_oga.ogaud11,l_oga.ogaud12,l_oga.ogaud13,l_oga.ogaud14,l_oga.ogaud15,g_user,g_grup #FUN-A10036
 
   IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_msg = l_dbs_new CLIPPED,'ins l_oga'
      IF g_bgerr THEN
      LET g_showmsg=l_oga.oga01,"/",l_oga.oga02,"/",l_oga.oga03 #NO.FUN-710046
        CALL s_errmsg('oga01,oga02,oga03',g_showmsg,g_msg,SQLCA.sqlcode,1)  
      ELSE
        CALL cl_err(g_msg,SQLCA.sqlcode,1)  
      END IF
      LET g_success = 'N'
   END IF
 
   IF s_aza.aza50 = 'Y' AND l_oea.oea00 = '6' THEN    #NO.FUN-620024    
      CALL p900_ohains()                              #NO.FUN-620024    
   END IF                                             #NO.FUN-620024
   #FUN-C80001---begin  刪除出通單idb
   IF s_industry('icd') THEN 
      LET l_sql2 = " DELETE FROM ",cl_get_target_table(l_plant_new,'idb_file'),
                   " WHERE idb07 = '",l_oga.oga011,"'"
      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2       
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
      PREPARE del_idb FROM l_sql2
      EXECUTE del_idb
   END IF    
   #FUN-C80001---end
END FUNCTION
 
#出貨單身檔
FUNCTION p900_ogbins(p_i,p_plant) #FUN-980092 add
   DEFINE p_dbs      LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)                         #No.FUN-620054
   DEFINE l_sql,l_sql1,l_sql2,l_sql3,l_sql4        STRING                 #MOD-9C0274
   DEFINE p_i        LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_no       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_price    LIKE ogb_file.ogb13
   DEFINE i,l_i      LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_msg      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
   DEFINE l_chr      LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_ima02    LIKE ima_file.ima02
   DEFINE l_ima25    LIKE ima_file.ima25
 #  DEFINE l_imaqty   LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_imaqty   LIKE type_file.num15_3#FUN-A20044
   DEFINE l_ima86    LIKE ima_file.ima86
   DEFINE l_ima39    LIKE ima_file.ima39
   DEFINE l_ima35    LIKE ima_file.ima35
   DEFINE l_ima36    LIKE ima_file.ima36
   DEFINE l_pmn24    LIKE pmn_file.pmn24   #No.FUN-630006
   DEFINE l_pmn25    LIKE pmn_file.pmn25   #No.FUN-630006
   DEFINE l_slip     LIKE oga_file.oga01   #FUN-670007
   DEFINE l_ogbi     RECORD LIKE ogbi_file.* #No.FUN-7B0018 
   DEFINE l_flag     SMALLINT     #MOD-810179 add
   DEFINE l_cnt      LIKE type_file.num5   #MOD-970042
   DEFINE l_fac      LIKE ogb_file.ogb15_fac 	#CHI-9A0040 add
 
   DEFINE p_dbs_tra  LIKE type_file.chr21 #FUN-980092 add
   DEFINE p_plant    LIKE azp_file.azp01 #FUN-980092 add
   DEFINE l_idd   RECORD LIKE idd_file.*            #FUN-B90012
   DEFINE l_flag1        LIKE type_file.num10       #FUN-B90012
   DEFINE l_imaicd08     LIKE imaicd_file.imaicd08  #FUN-B90012
   DEFINE l_ogbiicd028   LIKE ogbi_file.ogbiicd028  #FUN-B90012
   DEFINE l_ogbiicd029   LIKE ogbi_file.ogbiicd029  #FUN-B90012
#  DEFINE l_oia07   LIKE oia_file.oia07   #FUN-C50136
   DEFINE l_img09   LIKE img_file.img09      #FUN-C80001
   DEFINE l_qty     LIKE ogb_file.ogb915    #FUN-C80001
   DEFINE l_oga14   LIKE oga_file.oga14     #FUN-CB0087
   DEFINE l_oga15   LIKE oga_file.oga15     #FUN-CB0087
   
   LET g_plant_new = p_plant
   CALL s_getdbs()        LET p_dbs = g_dbs_new
   CALL s_gettrandbs()    LET p_dbs_tra = g_dbs_tra
 
   #讀取訂單單身檔(oeb_file)
 
   LET i = p_i                                              #No.FUN-620054
   IF tm.oga09="6" AND g_oea.oea37="Y" AND i = 0  AND g_oaz.oaz19 = 'Y' THEN    #No.FUN-640025  #NO.TQC-640134
      #LET l_sql1 = "SELECT ",l_dbs_new_tra CLIPPED,"pmn_file.pmn24, ",
      #                       l_dbs_new_tra CLIPPED,"pmn_file.pmn25 ",
      #             "  FROM ",l_dbs_new_tra CLIPPED,"pmn_file,",
      #                       l_dbs_new_tra CLIPPED,"pmm_file",
      LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'pmn_file'),".pmn24, ", #FUN-A50102
                             cl_get_target_table(l_plant_new,'pmn_file'),".pmn25  ", #FUN-A50102
                   "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",",        #FUN-A50102
                             cl_get_target_table(l_plant_new,'pmm_file'),            #FUN-A50102
                   " WHERE pmn01 = pmm01",                                       
                   "   AND pmm99 ='",g_oea.oea99,"'",                            
                   "   AND pmn02 =",g_ogb.ogb32
      
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092 add
      PREPARE pmn24_p2 FROM l_sql1
      IF SQLCA.SQLCODE THEN
         IF g_bgerr THEN
           LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32 
           CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn24_p1',SQLCA.SQLCODE,1)
         ELSE
           CALL cl_err('pmn24_p1',SQLCA.SQLCODE,1)
         END IF
      END IF
      
      DECLARE pmn24_c2 CURSOR FOR pmn24_p2
      
      OPEN pmn24_c2
      FETCH pmn24_c2 INTO l_pmn24,l_pmn25
      IF SQLCA.SQLCODE <> 0 THEN
         IF g_bgerr THEN
           LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32 
           CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn24_c2',SQLCA.SQLCODE,1)
         END IF
         LET g_success='N'
         RETURN
      END IF
 
      #LET l_sql1 = "SELECT ",l_dbs_new_tra CLIPPED,"oeb_file.* ",                    
      #             "  FROM ",l_dbs_new_tra CLIPPED,"oeb_file,",
      #                       l_dbs_new_tra CLIPPED,"oea_file",
      LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'oeb_file'),".* ", #FUN-A50102                  
                   "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'),", ",  #FUN-A50102
                             cl_get_target_table(l_plant_new,'oea_file'),       #FUN-A50102
                   " WHERE oeb01 = oea01",                                       
                   "   AND oea99 ='",g_oea.oea99,"'",     #TQC-910042                       
                   "  AND oeb03 =",l_pmn25
   ELSE
      #LET l_sql1 = "SELECT ",l_dbs_new_tra CLIPPED,"oeb_file.* ",                    
      #             "  FROM ",l_dbs_new_tra CLIPPED,"oeb_file,",
      #                       l_dbs_new_tra CLIPPED,"oea_file",
      LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'oeb_file'),".* ", #FUN-A50102                  
                   "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'),", ",  #FUN-A50102
                             cl_get_target_table(l_plant_new,'oea_file'),       #FUN-A50102
                   " WHERE oeb01 = oea01",                                       
                   "   AND oea99 ='",g_oea.oea99,"'",                            
                   "  AND oeb03 =",g_ogb.ogb32
   END IF
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1  #FUN-980092 add
   PREPARE oeb_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN
         CALL s_errmsg(' ',' ','oeb_p1',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err('oeb_p1',SQLCA.SQLCODE,1)
      END IF
   END IF
 
   DECLARE oeb_c1 CURSOR FOR oeb_p1
 
   OPEN oeb_c1
   FETCH oeb_c1 INTO l_oeb.*
   IF SQLCA.SQLCODE <> 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg(' ',' ','oeb_p1',SQLCA.SQLCODE,1)
      END IF
      LET g_success='N'
      RETURN
   END IF
   CLOSE oeb_c1
 
   CALL p900_ima(l_oeb.oeb04)
      RETURNING l_ima02,l_ima25,l_imaqty,l_ima86,l_ima39,l_ima35,l_ima36
   IF cl_null(l_ima35) THEN LET l_ima35=' ' END IF
   IF cl_null(l_ima36) THEN LET l_ima36=' ' END IF
 
   #新增出貨單身檔[ogb_file]
   LET l_ogb.ogb01 = l_oga.oga01      #出貨單號     No.8047
   LET l_ogb.ogb03 = g_ogb.ogb03      #項次
   LET l_ogb.ogb04 = g_ogb.ogb04      #產品編號     No.7742
   LET l_ogb.ogb05 = g_ogb.ogb05      #銷售單位     No.7742
   LET l_ogb.ogb05_fac= g_ogb.ogb05_fac  #換算率    No.7742
   LET l_ogb.ogb06 = g_ogb.ogb06      #品名規格     No.7742
   LET l_ogb.ogb07 = g_ogb.ogb07      #額外品名編號 No.7742
   LET l_ogb.ogb08 = l_oeb.oeb08      #出貨工廠
   IF NOT cl_null(p_imd01) THEN
      CALL p900_imd(p_imd01,l_plant_new) #FUN-980092 add
      LET l_ogb.ogb09 = p_imd01          #出貨倉庫
      LET l_ogb.ogb091= ' '              #出貨儲位
      LET l_ogb.ogb092= ' '              #出貨批號
   ELSE
      IF NOT cl_null(l_ima35) THEN
         LET l_ogb.ogb09 = l_ima35          #出貨倉庫
         LET l_ogb.ogb091= l_ima36          #出貨儲位
         LET l_ogb.ogb092= ' '              #出貨批號
         LET p_imd01 = l_ima35              #MOD-C80071 add
         CALL p900_imd(p_imd01,l_plant_new) #MOD-C80071 add
      ELSE
         LET l_ogb.ogb09 = g_ogb.ogb09
         LET l_ogb.ogb091= g_ogb.ogb091
         LET l_ogb.ogb092= g_ogb.ogb092  #No.9337
         LET p_imd01 = g_ogb.ogb09          #MOD-C80071 add
         CALL p900_imd(p_imd01,l_plant_new) #MOD-C80071 add
      END IF
   END IF
  #IF g_sma.sma96 = 'Y' THEN          #FUN-C80001 #FUN-D30099 mark
   IF g_pod.pod08 = 'Y' THEN          #FUN-D30099 
      LET l_ogb.ogb092= g_ogb.ogb092  #FUN-C80001
      LET g_plant_ogb09 = g_ogb.ogb09 #FUN-D20062 add
   END IF                             #FUN-C80001
   LET l_ogb.ogb11 = g_ogb.ogb11      #客戶產品編號 No.7742
   LET l_ogb.ogb12 = g_ogb.ogb12      #實際出貨數量
  #LET l_ogb.ogb13 = cl_digcut(l_oeb.oeb13,l_azi.azi03)   #原幣單價  #MOD-680071 取位  #MOD-6C0141 #FUN-D10007 mark 
#FUN-D10007---add---START  
   IF g_oax.oax03 = 'N' OR s_aza.aza50 = 'Y' THEN
      LET l_ogb.ogb13 = cl_digcut(l_oeb.oeb13,l_azi.azi03) #原幣單價
   ELSE
      #出貨必須重新計算價格, 因為分批出貨時, 有可能計價方式亦改變了
      #依計價方式來判斷價格
            CASE p_pox05
               WHEN '1' #按比率
                  IF p_pox03='1' THEN   #依來源營運中心 
                     #單價*比率
                     IF g_oea.oea23 = l_oga.oga23 THEN
                        LET l_ogb.ogb13 = t_ogb.ogb13 * p_pox06 /100
                     END IF
                     IF g_oea.oea23 <> l_oga.oga23 THEN  
                        LET l_price = t_ogb.ogb13 * g_oga.oga24 #先換算本幣
                        #依計價幣別抓來源工廠的匯率
                        CALL s_currm(l_oga.oga23,l_oga.oga02,
                                      g_oax.oax01,l_plant_new)
                             RETURNING l_currm
                        #g_oax.oax01 多角貿易使用匯率 s/b/c/d     
                        LET l_ogb.ogb13= l_price/l_currm * p_pox06/100  
                     END IF
                  ELSE
                     #依上游廠商計算, 先讀取S/O價格
                     IF p_i=1 THEN
                       #單價*比率
                       #(換算匯率)
                       IF g_oea.oea23 = l_oga.oga23 THEN
                          LET l_ogb.ogb13 = t_ogb.ogb13 * p_pox06 /100
                       END IF
                       IF g_oea.oea23 <> l_oga.oga23 THEN  
                          LET l_price = t_ogb.ogb13 * g_oga.oga24 #先換算本幣
                          #依計價幣別抓來源工廠的匯率
                          CALL s_currm(l_oga.oga23,l_oga.oga02,
                                        g_oax.oax01,l_plant_new)
                               RETURNING l_currm
                          LET l_ogb.ogb13= l_price/l_currm * p_pox06/100  
                       END IF
                     ELSE
                        LET l_no = p_i-1
                        SELECT pab_price,pab_curr INTO l_price,l_curr
                          FROM p820_file
                         WHERE p_no = l_no
                           AND pab_no = l_ogb.ogb01
                           AND pab_item=t_ogb.ogb03
                           AND pab_type='1'
                       #(換算匯率)
                        IF l_curr != l_oga.oga23 THEN
                           CALL s_currm(l_curr,l_oga.oga02,
                                        g_oax.oax01,l_plant_new)
                            RETURNING l_currm
                           LET l_price = l_price * l_currm   #換算成本幣
                           #依計價幣別抓來源廠的匯率
                           CALL s_currm(l_oga.oga23,l_oga.oga02,
                                        g_oax.oax01,l_plant_new)
                            RETURNING l_currm
                           LET l_ogb.ogb13 = l_price / l_currm * p_pox06/100
                        ELSE
                           #單價*比率
                           LET l_ogb.ogb13= l_price * p_pox06/100
                        END IF
                      END IF  
                  END IF
                  CALL cl_digcut(l_ogb.ogb13,l_azi.azi03) 
                        RETURNING l_ogb.ogb13
               WHEN '2' #取轉撥單價
                  #讀取合乎料件條件之價格
                  CALL s_pow(g_oea.oea904,l_ogb.ogb04,g_poy.poy04,g_oga.oga02)
                         RETURNING g_sw,l_ogb.ogb13
                   IF g_sw='N' THEN
                     CALL cl_err('sel pow:','axm-333',1)
                     LET g_success = 'N'
                   END IF
               WHEN '3'  #單價=0則給0,否則同2之方式 
                   IF t_ogb.ogb13 <> 0 THEN
                      CALL s_pow(g_oea.oea904,l_ogb.ogb04,g_poy.poy04,g_oga.oga02)
                         RETURNING g_sw,l_ogb.ogb13
                      IF g_sw='N' THEN
                        CALL cl_err('sel pow:','axm-333',1)
                        LET g_success = 'N'
                      END IF
                   ELSE
                      LET l_ogb.ogb13 = 0
                   END IF
            END CASE
            IF l_ogb.ogb13 IS NULL THEN LET l_ogb.ogb13 =0 END IF
   END IF
#FUN-D10007---add-----END
   LET l_ogb.ogb37 = cl_digcut(l_oeb.oeb37,l_azi.azi03)   #FUN-AB0061
 
   LET l_ogb.ogb917 = g_ogb.ogb917   #No.TQC-6A0084
 
   #未稅金額/含稅金額 : oeb14/oeb14t
   IF l_oga.oga213 = 'N' THEN
      LET l_ogb.ogb14=l_ogb.ogb917*l_ogb.ogb13  #No.TQC-6A0084
      CALL cl_digcut(l_ogb.ogb14,l_azi.azi04) RETURNING l_ogb.ogb14	#MOD-980118
      LET l_ogb.ogb14t=l_ogb.ogb14*(1+l_oga.oga211/100)
      CALL cl_digcut(l_ogb.ogb14t,l_azi.azi04)RETURNING l_ogb.ogb14t	#MOD-980118
   ELSE 
      LET l_ogb.ogb14t=l_ogb.ogb917*l_ogb.ogb13  #No.TQC-6A0084
      CALL cl_digcut(l_ogb.ogb14t,l_azi.azi04)RETURNING l_ogb.ogb14t	#MOD-980118
      LET l_ogb.ogb14=l_ogb.ogb14t/(1+l_oga.oga211/100)
      CALL cl_digcut(l_ogb.ogb14,l_azi.azi04) RETURNING l_ogb.ogb14	#MOD-980118
   END IF
   LET l_ogb.ogb15 = l_ima25			#MOD-980127
   LET l_ogb.ogb15_fac = 1
   #與庫存單位轉換率的計算
   #=====================================================
   #ogb15存放的是倉庫的單位(img09)，因此不管目前l_ogb.ogb15
   #是否為NULL都必須重新塞值給l_ogb.ogb15
   #=====================================================
   IF l_ogb.ogb09  IS NULL THEN LET l_ogb.ogb09  = ' ' END IF
   IF l_ogb.ogb091 IS NULL THEN LET l_ogb.ogb091 = ' ' END IF
   IF l_ogb.ogb092 IS NULL THEN LET l_ogb.ogb092 = ' ' END IF
 
      IF l_ogb.ogb05 = l_ogb.ogb15 THEN
          LET l_ogb.ogb15_fac =1
      ELSE
          #檢查該銷售單位與倉庫的庫存單位是否可以轉換
          CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb15,l_plant_new) #FUN-980092 add
               RETURNING l_flag,l_ogb.ogb15_fac
          IF l_flag THEN
             LET g_msg=l_dbs_new CLIPPED,' ',l_ogb.ogb04
             CALL cl_err(g_msg,'mfg3075',1)
             LET g_success = 'N'
          END IF 
      END IF
   IF cl_null(l_ogb.ogb15) THEN LET l_ogb.ogb15  = l_ogb.ogb05 END IF
   IF cl_null(l_ogb.ogb15_fac) THEN LET l_ogb.ogb15_fac = 1 END IF
 
   #銷售單位/庫存單位轉換率
   CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ima25,l_plant_new) #FUN-980092 add
        RETURNING l_flag,l_ogb.ogb05_fac
   IF l_flag THEN
      LET g_msg=l_dbs_new CLIPPED,' ',l_ogb.ogb04
      CALL cl_err(g_msg,'mfg3075',1)
      LET g_success = 'N'
   END IF 
 
   LET l_ogb.ogb16 = l_ogb.ogb12 * l_ogb.ogb15_fac
   LET l_ogb.ogb16 = s_digqty(l_ogb.ogb16,l_ogb.ogb15) #FUN-BB0083 add
   #=====================================================
  #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
   IF g_pod.pod08 = 'Y' THEN         #FUN-D30099
      LET l_ogb.ogb17 = g_ogb.ogb17  #FUN-C80001
   ELSE                              #FUN-C80001
      LET l_ogb.ogb17 = 'N'
   END IF                            #FUN-C80001
   LET l_ogb.ogb18 = l_ogb.ogb12
   LET l_ogb.ogb18 = s_digqty(l_ogb.ogb18,l_ogb.ogb15) #FUN-BB0083 add
   LET l_ogb.ogb19 = g_ogb.ogb19  #NO.FUN-620024
   LET l_ogb.ogb20 =' '
   LET l_ogb.ogb31 = l_oeb.oeb01
   LET l_ogb.ogb32 = l_oeb.oeb03
   LET l_ogb.ogb60 =0
   LET l_ogb.ogb63 =0
   LET l_ogb.ogb64 =0
   # 備品時金額、單價應為零
   IF p900_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
      LET l_ogb.ogb13 = 0 
      LET l_ogb.ogb14 = 0 
      LET l_ogb.ogb14t= 0 
   END IF
   LET l_ogb.ogbud01 = g_ogb.ogbud01
   LET l_ogb.ogbud02 = g_ogb.ogbud02
   LET l_ogb.ogbud03 = g_ogb.ogbud03
   LET l_ogb.ogbud04 = g_ogb.ogbud04
   LET l_ogb.ogbud05 = g_ogb.ogbud05
   LET l_ogb.ogbud06 = g_ogb.ogbud06
   LET l_ogb.ogbud07 = g_ogb.ogbud07
   LET l_ogb.ogbud08 = g_ogb.ogbud08
   LET l_ogb.ogbud09 = g_ogb.ogbud09
   LET l_ogb.ogbud10 = g_ogb.ogbud10
   LET l_ogb.ogbud11 = g_ogb.ogbud11
   LET l_ogb.ogbud12 = g_ogb.ogbud12
   LET l_ogb.ogbud13 = g_ogb.ogbud13
   LET l_ogb.ogbud14 = g_ogb.ogbud14
   LET l_ogb.ogbud15 = g_ogb.ogbud15
   LET l_ogb.ogb910 = g_ogb.ogb910
   LET l_ogb.ogb911 = g_ogb.ogb911
   LET l_ogb.ogb912 = g_ogb.ogb912
   LET l_ogb.ogb913 = g_ogb.ogb913
   LET l_ogb.ogb914 = g_ogb.ogb914
   LET l_ogb.ogb915 = g_ogb.ogb915
   LET l_ogb.ogb916 = g_ogb.ogb916
   LET l_ogb.ogb1001 = l_oeb.oeb1001  #原因碼      #MOD-B80234
   IF cl_null(l_ogb.ogb1001) THEN LET l_ogb.ogb1001 = g_poy.poy28 END IF  #TQC-D40064 add
   IF s_aza.aza50 = 'Y' THEN      
#     LET l_ogb.ogb1001 = l_oeb.oeb1001  #原因碼   #MOD-B80234 mark
      LET l_ogb.ogb1002 = l_oeb.oeb1002  #訂價編號                                        
      LET l_ogb.ogb1003 = l_oeb.oeb15    #預計出貨日期                                        
      LET l_ogb.ogb1004 = l_oeb.oeb1004  #提案編號                                        
      LET l_ogb.ogb1005 = l_oeb.oeb1003  #作業方式                                        
      LET l_ogb.ogb1007 = ''             #現金折扣單號                                        
      LET l_ogb.ogb1008 = ''             #稅種                                        
      LET l_ogb.ogb1009 = ''             #稅率                                        
      LET l_ogb.ogb1010 = ''             #含稅否                                        
      LET l_ogb.ogb1011 = ''             #非直營KAB                                       
      LET l_ogb.ogb1006 = l_oeb.oeb1006  #折扣率                                        
      LET l_ogb.ogb1012 = l_oeb.oeb1012  #搭贈
   END IF                                                                    
   IF l_ogb.ogb1012 = 'Y' THEN
      LET l_ogb.ogb14 = 0
      LET l_ogb.ogb14t= 0
   END IF
 
   LET l_ogb.ogb930 = l_oeb.oeb930  #MOD-920261 add
   IF g_aza.aza50 = 'N' THEN LET l_ogb.ogb1005 = '1' END IF  #FUN-670007 
   LET l_ogb.ogb1014='N' #保稅放行否 #FUN-6B0044
#FUN-AB0061 -----------add start----------------                             
    IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
       LET l_ogb.ogb37=l_ogb.ogb13                         
    END IF                                                                             
#FUN-AB0061 -----------add end----------------   
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 ------------add start-----------------
#   IF cl_null(l_ogb.ogb50) THEN
#      LET l_ogb.ogb50 = '1'
#   END IF
##FUN-AB0096 -----------add end--------------------  
#FUN-AC0055 mark ----------------------end------------------------
   #FUN-C50097 ADD BEGIN-----
   IF cl_null(l_ogb.ogb50) THEN 
     LET l_ogb.ogb50 = 0
   END IF 
   IF cl_null(l_ogb.ogb51) THEN 
     LET l_ogb.ogb51 = 0
   END IF 
   IF cl_null(l_ogb.ogb52) THEN 
     LET l_ogb.ogb52 = 0
   END IF         
   IF cl_null(l_ogb.ogb53) THEN 
     LET l_ogb.ogb53 = 0
   END IF 
   IF cl_null(l_ogb.ogb54) THEN 
     LET l_ogb.ogb54 = 0
   END IF 
   IF cl_null(l_ogb.ogb55) THEN 
     LET l_ogb.ogb55 = 0
   END IF                                
   #FUN-C50097 ADD END-------  

   #TQC-D20047--add--str--
   LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
   PREPARE aza115_pr FROM l_sql2
   EXECUTE aza115_pr INTO g_aza.aza115   
   #TQC-D20047--add--end--
   #FUN-CB0087--add--str--
   #IF g_aza.aza115='Y' THEN                             #TQC-D40064 mark
   IF g_aza.aza115='Y' AND cl_null(l_ogb.ogb1001) THEN   #TQC-D40064 add
      #TQC-D20050--mod--str--
      #SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
      #CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
      LET l_sql2= " SELECT oga14,oga15 FROM ",cl_get_target_table(l_plant_new,'oga_file')," WHERE oga01 = '",l_ogb.ogb01,"'"
      PREPARE ogb1001_pr FROM l_sql2
      EXECUTE ogb1001_pr INTO l_oga14,l_oga15
      CALL s_reason_code1(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15,l_plant_new) RETURNING l_ogb.ogb1001
      #TQC-D20050--mod--end--
      IF cl_null(l_ogb.ogb1001) THEN
         CALL cl_err(l_ogb.ogb1001,'aim-425',1)
         LET g_success="N"
         RETURN
      END IF
   END IF
   #FUN-CB0087--add--end--
   #新增出貨單身檔
   #LET l_sql2="INSERT INTO ",l_dbs_new_tra CLIPPED,"ogb_file", #FUN-980092 add
   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ogb_file'),       #FUN-A50102
              "(ogb01,ogb03,ogb04,ogb05, ",
              " ogb05_fac,ogb06,ogb07,ogb08, ",
              " ogb09,ogb091,ogb092,ogb11, ",
              " ogb12,ogb37,ogb13,ogb14,ogb14t,",#FUN-AB0061
              " ogb15,ogb15_fac,ogb16,ogb17, ",
              " ogb18,ogb19,ogb20,ogb31,",
              " ogb32,ogb60,ogb63,ogb64,",
              " ogb901,ogb902,ogb903,ogb904,",
              " ogb905,ogb906,ogb907,ogb908,",
              " ogb909,ogb910,ogb911,ogb912,",
              " ogb913,ogb914,ogb915,ogb916,",
              " ogb917,ogb930,ogb1001,ogb1002,ogb1003,", #NO.FUN-620024   #MOD-920261 add ogb930                          
              " ogb1004,ogb1005,ogb1007,ogb1008,",#NO.FUN-620024                           
              " ogb1009,ogb1010,ogb1011,ogb1012,ogb1006,ogb1014,",       #NO.FUN-620024 #FUN-6B0044
              " ogbplant,ogblegal ,",
              " ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",
              " ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",
              " ogbud11,ogbud12,ogbud13,ogbud14,ogbud15,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",    ##FUN-C50097 ADD 50,51,52
              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ",  #NO.FUN-620024 FUN-620054
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",  #No.FUN0054 #FUN-6B0044  #MOD-920261 add ?
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",  #No.CHI-950020
              "         ?,?,?,?, ?,?,?,?, ?) "   #FUN-980010#FUN-AB0061     #FUN-AB0096 add? #FUN-C50097 ADD 50,51,52 ,?,?,? 
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ins_ogb FROM l_sql2
   EXECUTE ins_ogb USING 
     l_ogb.ogb01,l_ogb.ogb03,l_ogb.ogb04,l_ogb.ogb05, 
     l_ogb.ogb05_fac,l_ogb.ogb06,l_ogb.ogb07,l_ogb.ogb08, 
     l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb11, 
     l_ogb.ogb12,l_ogb.ogb37,l_ogb.ogb13,l_ogb.ogb14,l_ogb.ogb14t,#FUN-AB0061
     l_ogb.ogb15,l_ogb.ogb15_fac,l_ogb.ogb16,l_ogb.ogb17, 
     l_ogb.ogb18,l_ogb.ogb19,l_ogb.ogb20,l_ogb.ogb31,
     l_ogb.ogb32,l_ogb.ogb60,l_ogb.ogb63,l_ogb.ogb64,
     l_ogb.ogb901,l_ogb.ogb902,l_ogb.ogb903,l_ogb.ogb904,
     l_ogb.ogb905,l_ogb.ogb906,l_ogb.ogb907,l_ogb.ogb908,
     l_ogb.ogb909,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,
     l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_ogb.ogb916,
     l_ogb.ogb917,l_ogb.ogb930,l_ogb.ogb1001,l_ogb.ogb1002,l_ogb.ogb1003,  #NO.FUN-620024     #MOD-920261 add ogb930
     l_ogb.ogb1004,l_ogb.ogb1005,l_ogb.ogb1007,l_ogb.ogb1008, #NO.FUN-620024     
     l_ogb.ogb1009,l_ogb.ogb1010,l_ogb.ogb1011,l_ogb.ogb1012,l_ogb.ogb1006,l_ogb.ogb1014,  #NO.FUN-620024 #FUN-6B0044
     gp_plant,gp_legal   #FUN-980010
    ,l_ogb.ogbud01,l_ogb.ogbud02,l_ogb.ogbud03,l_ogb.ogbud04,l_ogb.ogbud05,     
     l_ogb.ogbud06,l_ogb.ogbud07,l_ogb.ogbud08,l_ogb.ogbud09,l_ogb.ogbud10,     
     l_ogb.ogbud11,l_ogb.ogbud12,l_ogb.ogbud13,l_ogb.ogbud14,l_ogb.ogbud15,
     l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52,l_ogb.ogb53,l_ogb.ogb54,l_ogb.ogb55  #FUN-C50097 ADD 50,51,52 ,l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52
 
   IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3]=0 THEN
      LET g_msg = l_dbs_new CLIPPED,'ins l_ogb'
      IF g_bgerr THEN
         LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03,"/",l_ogb.ogb04  
         CALL s_errmsg('ogb01,ogb03,ogb04',g_showmsg,g_msg,SQLCA.sqlcode,1)
      ELSE
         CALL cl_err(g_msg,SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_ogbi.* TO NULL
         LET l_ogbi.ogbi01 = l_ogb.ogb01
         LET l_ogbi.ogbi03 = l_ogb.ogb03
         IF NOT s_ins_ogbi(l_ogbi.*,l_plant_new) THEN #FUN-980092 add
            LET g_success = 'N'
         END IF
      END IF
#     #FUN-C50136----add----str----
#     IF g_oaz.oaz96 ='Y' THEN
#        CALL s_ccc_oia07('D',l_oga.oga03) RETURNING l_oia07
#        IF l_oia07 = '0' THEN
#           CALL s_ccc_oia(l_oga.oga03,'D',l_oga.oga01,0,l_plant_new)
#        END IF
#     END IF
#     #FUN-C50136----add----end----
   END IF

#FUN-C80001---begin
   IF s_industry('icd') THEN 
      LET l_sql1 = "SELECT ogbiicd028,ogbiicd029 FROM ",cl_get_target_table(l_plant_new,'ogbi_file'),
                   " WHERE ogbi01 = '",l_ogb.ogb01,"'",
                   "   AND ogbi03 =  ",l_ogb.ogb03
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
      PREPARE p900_ogbi FROM l_sql1
      EXECUTE p900_ogbi INTO l_ogbiicd028,l_ogbiicd029 
   END IF  
   
   LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), 
                " WHERE ima01 = '",l_ogb.ogb04,"'",
                "   AND imaacti = 'Y'"
 
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
   PREPARE ima_ogb FROM l_sql2
   EXECUTE ima_ogb INTO g_ima918,g_ima921
   
   LET l_cnt = 0
   IF l_ogb.ogb17='Y' THEN
      IF g_sma.sma115 = 'Y' THEN
         DECLARE p821_g_ogg1 CURSOR FOR 
            SELECT ogg17,ogg092,ogg20 FROM ogg_file
             WHERE ogg01= g_oga.oga01
               AND ogg03= g_ogb.ogb03
             GROUP BY ogg17,ogg092,ogg20 

         FOREACH p821_g_ogg1 INTO g_ogg.ogg17,g_ogg.ogg092,g_ogg.ogg20
            IF STATUS THEN
               CALL cl_err('ogg1',STATUS,1)
            END IF

            SELECT * INTO g_ogg.* FROM ogg_file
             WHERE ogg01= g_oga.oga01
               AND ogg03= g_ogb.ogb03
               AND ogg17= g_ogg.ogg17
               AND ogg092= g_ogg.ogg092
               AND ogg20= g_ogg.ogg20
   
            SELECT SUM(ogg12) INTO g_ogg.ogg12 FROM ogg_file
             WHERE ogg01= g_oga.oga01
               AND ogg03= g_ogb.ogb03
               AND ogg092= g_ogg.ogg092    
               AND ogg20= g_ogg.ogg20
             GROUP BY ogg17,ogg092

            #LET l_fac = 1
            #SELECT img09 INTO l_img09 FROM img_file
            # WHERE img01 = l_ogb.ogb04
            #   AND img02 = g_ogg.ogg09
            #   AND img03 = g_ogg.ogg091
            #   AND img04 = g_ogg.ogg092
            #IF l_ogb.ogb05 <> l_img09 THEN
            #   CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) 
            #        RETURNING l_flag,l_fac
            #   IF l_flag = 1 THEN
            #      CALL cl_err('','mfg3075',1)
            #      LET l_fac = 1
            #   END IF
            #END IF
            #LET g_ogg.ogg16 = g_ogg.ogg12 * l_fac
            LET g_ogg.ogg16 = g_ogg.ogg12 * g_ogg.ogg15_fac
              
            LET g_ogg.ogg01 = l_oga.oga01
            LET g_ogg.ogg09 = l_ogb.ogb09
            LET g_ogg.ogg091= l_ogb.ogb091
          
            LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'ogg_file'),   
                         "(ogg01,ogg03,ogg09,ogg091,ogg092,ogg10,",
                         " ogg12,ogg15,ogg15_fac,ogg16,ogg20,ogg17,ogg18,",           
                         " oggplant,ogglegal,ogg13) ", 
                         " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?) "  
 
 	        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
            PREPARE ins_ogg FROM l_sql2
           
            EXECUTE ins_ogg USING g_ogg.ogg01,g_ogg.ogg03,g_ogg.ogg09,g_ogg.ogg091,g_ogg.ogg092,g_ogg.ogg10,
                                  g_ogg.ogg12,g_ogg.ogg15,g_ogg.ogg15_fac,g_ogg.ogg16,g_ogg.ogg20,g_ogg.ogg17,g_ogg.ogg18,
                                  gp_plant,gp_legal,g_ogg.ogg13  
        
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg = g_oga.oga01,"/",g_ogb.ogb03
               CALL s_errmsg('oga01,oga03',g_showmsg,'ins ogg:',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF 
            IF g_ogg.ogg20 = 1 THEN 
               SELECT SUM(ogg12) INTO l_qty 
                 FROM ogg_file
                WHERE ogg01= g_oga.oga01
                  AND ogg03= g_ogb.ogb03
                  AND ogg092= g_ogg.ogg092    
                  AND ogg20= 2
                GROUP BY ogg17,ogg092
               CALL p900_log(g_ogg.ogg17,g_ogg.ogg09,g_ogg.ogg091,
                             g_ogg.ogg092,g_ogg.ogg12,'1',l_qty)  

               IF s_aza.aza50 ='Y' THEN      #使用分銷功能                             
                  IF g_oga.oga00 = '6' THEN  #代送出貨單                               
                     CALL p900_log(g_ogg.ogg17,g_ogg.ogg09,g_ogg.ogg091,
                                   g_ogg.ogg092,g_ogg.ogg12,'4',l_qty)  #FUN-C80001          
                  END IF      
               END IF   
            END IF 
            IF s_industry('icd') AND g_ogg.ogg20 = 1 THEN 
               IF s_icdbin_multi(l_ogb.ogb04,l_plant_new) THEN  

                  FOREACH p900_g_idd1 USING g_ogg.ogg092 INTO l_idd.idd04,l_idd.idd05,l_idd.idd06
            
                     OPEN p900_g_idd2 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
                     FETCH p900_g_idd2 INTO l_idd.* 
                     CLOSE p900_g_idd2

                     OPEN p900_g_idd3 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
                     FETCH p900_g_idd3 INTO l_idd.idd13,l_idd.idd18,l_idd.idd19
                     CLOSE p900_g_idd3
                 
                     LET l_idd.idd10 = l_ogb.ogb01
                     LET l_idd.idd11 = l_ogb.ogb03 
                     LET l_idd.idd02 = g_ogg.ogg09
                     LET l_idd.idd03 = g_ogg.ogg091
                     LET l_idd.idd04 = g_ogg.ogg092

                     CALL icd_idb(l_idd.*,l_plant_new)
                  END FOREACH 
               END IF    
               CALL s_icdpost(12,l_ogb.ogb04,g_ogg.ogg09,g_ogg.ogg091,g_ogg.ogg092,l_ogb.ogb05,g_ogg.ogg12,l_ogb.ogb01,l_ogb.ogb03,
                                 l_oga.oga02,'Y','','',l_ogbiicd029,l_ogbiicd028,l_plant_new)
                    RETURNING l_flag1
               IF l_flag1 = 0 THEN
                  LET g_success = 'N'
               END IF  
            END IF 

            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               FOREACH p900_g_rvbs3 USING g_ogg.ogg092, g_ogg.ogg20 INTO l_rvbs.*
                  IF STATUS THEN
                     CALL cl_err('rvbs',STATUS,1)
                  END IF
      
                  IF cl_null(p_oga09) THEN
                     IF tm.oga09 = "4" THEN
                        LET l_rvbs.rvbs00 = "axmt820"
                     ELSE
                        LET l_rvbs.rvbs00 = "axmt821"
                     END IF
                  ELSE
                     IF p_oga09 = "4" THEN
                        LET l_rvbs.rvbs00 = "axmt820"
                     ELSE
                        LET l_rvbs.rvbs00 = "axmt821"
                     END IF
                  END IF
 
                  LET l_rvbs.rvbs01 = l_ogb.ogb01
      
                  LET l_cnt = l_cnt + 1 		
                  LET l_rvbs.rvbs022 = l_cnt 	

                  LET l_rvbs.rvbs09 = -1
 
                  IF cl_null(l_rvbs.rvbs06) THEN
                     LET l_rvbs.rvbs06 = 0
                  END IF

                  LET l_rvbs.rvbs13 = g_ogg.ogg18

                  #新增批/序號資料檔
                  EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                         l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                         l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                         l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09, 
                                         l_rvbs.rvbs13,  
                                         gp_plant,gp_legal   
 
                  IF STATUS OR SQLCA.SQLCODE THEN
                     LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                     CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                     LET g_success='N'
                  END IF
      
                  CALL p900_imgs(l_plant_new,g_ogg.ogg09,g_ogg.ogg091,g_ogg.ogg092,l_oga.oga02,l_rvbs.*)
               END FOREACH
            END IF 
            
         END FOREACH 
      ELSE 
         DECLARE p821_g_ogc1 CURSOR FOR
            SELECT ogc17,ogc092 FROM ogc_file  
             WHERE ogc01= g_oga.oga01
               AND ogc03= g_ogb.ogb03
             GROUP BY ogc17,ogc092

         FOREACH p821_g_ogc1 INTO g_ogc.ogc17,g_ogc.ogc092
            IF STATUS THEN
               CALL cl_err('ogc1',STATUS,1)
            END IF
            SELECT * INTO g_ogc.* FROM ogc_file
             WHERE ogc01= g_oga.oga01
               AND ogc03= g_ogb.ogb03
               AND ogc17= g_ogc.ogc17
               AND ogc092= g_ogc.ogc092
              
            SELECT SUM(ogc12) INTO g_ogc.ogc12 FROM ogc_file
             WHERE ogc01= g_oga.oga01
               AND ogc03= l_ogb.ogb03
               AND ogc092= g_ogc.ogc092   
             GROUP BY ogc17,ogc092 

            #LET l_fac = 1
            #SELECT img09 INTO l_img09 FROM img_file
            # WHERE img01 = l_ogb.ogb04
            #   AND img02 = g_ogc.ogc09
            #   AND img03 = g_ogc.ogc091
            #   AND img04 = g_ogc.ogc092
            #IF l_ogb.ogb05 <> l_img09 THEN
            #   CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) 
            #        RETURNING l_flag,l_fac
            #   IF l_flag = 1 THEN
            #      CALL cl_err('','mfg3075',1)
            #      LET l_fac = 1
            #   END IF
            #END IF
            #LET g_ogc.ogc16 = g_ogc.ogc12 * l_fac
            LET g_ogc.ogc16 = g_ogc.ogc12 * g_ogc.ogc15_fac
            
            LET g_ogc.ogc01 = l_oga.oga01
            LET g_ogc.ogc09 = l_ogb.ogb09
            LET g_ogc.ogc091= l_ogb.ogb091
           
            LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'ogc_file'),   
                         "(ogc01,ogc03,ogc09,ogc091,ogc092,",
                         " ogc12,ogc15,ogc15_fac,ogc16,ogc17,ogc18,",           
                         " ogcplant,ogclegal,ogc13) ", 
                         " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "  
 
            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
            PREPARE ins_ogc FROM l_sql2
           
            EXECUTE ins_ogc USING g_ogc.ogc01,g_ogc.ogc03,g_ogc.ogc09,g_ogc.ogc091,g_ogc.ogc092,
                                  g_ogc.ogc12,g_ogc.ogc15,g_ogc.ogc15_fac,g_ogc.ogc16,g_ogc.ogc17,g_ogc.ogc18,
                                  gp_plant,gp_legal,g_ogc.ogc13  
        
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg = g_oga.oga01,"/",g_ogb.ogb03
               CALL s_errmsg('oga01,oga03',g_showmsg,'ins ogc:',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF  
            CALL p900_log(g_ogc.ogc17,g_ogc.ogc09,g_ogc.ogc091,
                          g_ogc.ogc092,g_ogc.ogc12,'1','')   

            IF s_aza.aza50 ='Y' THEN      #使用分銷功能                             
               IF g_oga.oga00 = '6' THEN  #代送出貨單                               
                  CALL p900_log(g_ogc.ogc17,g_ogc.ogc09,g_ogc.ogc091, 
                                g_ogc.ogc092,g_ogc.ogc12,'4','')     
               END IF      
            END IF 
            IF s_industry('icd') THEN 
               IF s_icdbin_multi(l_ogb.ogb04,l_plant_new) THEN   

                  FOREACH p900_g_idd1 USING g_ogc.ogc092 INTO l_idd.idd04,l_idd.idd05,l_idd.idd06
            
                     OPEN p900_g_idd2 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
                     FETCH p900_g_idd2 INTO l_idd.* 
                     CLOSE p900_g_idd2

                     OPEN p900_g_idd3 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
                     FETCH p900_g_idd3 INTO l_idd.idd13,l_idd.idd18,l_idd.idd19
                     CLOSE p900_g_idd3

                     LET l_idd.idd10 = l_ogb.ogb01
                     LET l_idd.idd11 = l_ogb.ogb03 
                     LET l_idd.idd02 = g_ogc.ogc09
                     LET l_idd.idd03 = g_ogc.ogc091
                     LET l_idd.idd04 = g_ogc.ogc092

                     CALL icd_idb(l_idd.*,l_plant_new)
                  END FOREACH 
               END IF    
               CALL s_icdpost(12,l_ogb.ogb04,g_ogc.ogc09,g_ogc.ogc091,g_ogc.ogc092,l_ogb.ogb05,g_ogc.ogc12,l_ogb.ogb01,l_ogb.ogb03,
                                 l_oga.oga02,'Y','','',l_ogbiicd029,l_ogbiicd028,l_plant_new)
                    RETURNING l_flag1
               IF l_flag1 = 0 THEN
                  LET g_success = 'N'
               END IF  
            END IF 

            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               FOREACH p900_g_rvbs2 USING g_ogc.ogc092 INTO l_rvbs.*
                  IF STATUS THEN
                     CALL cl_err('rvbs',STATUS,1)
                  END IF
      
                  IF cl_null(p_oga09) THEN
                     IF tm.oga09 = "4" THEN
                        LET l_rvbs.rvbs00 = "axmt820"
                     ELSE
                        LET l_rvbs.rvbs00 = "axmt821"
                     END IF
                  ELSE
                     IF p_oga09 = "4" THEN
                        LET l_rvbs.rvbs00 = "axmt820"
                     ELSE
                        LET l_rvbs.rvbs00 = "axmt821"
                     END IF
                  END IF
 
                  LET l_rvbs.rvbs01 = l_ogb.ogb01
      
                  LET l_cnt = l_cnt + 1 		
                  LET l_rvbs.rvbs022 = l_cnt 	

                  LET l_rvbs.rvbs09 = -1
 
                  IF cl_null(l_rvbs.rvbs06) THEN
                     LET l_rvbs.rvbs06 = 0
                  END IF

                  LET l_rvbs.rvbs13 = g_ogc.ogc18

                  #新增批/序號資料檔
                  EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                         l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                         l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                         l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09, 
                                         l_rvbs.rvbs13,  
                                         gp_plant,gp_legal   
 
                  IF STATUS OR SQLCA.SQLCODE THEN
                     LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                     CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                     LET g_success='N'
                  END IF
      
                  CALL p900_imgs(l_plant_new,g_ogc.ogc09,g_ogc.ogc091,g_ogc.ogc092,l_oga.oga02,l_rvbs.*)
               END FOREACH
            END IF 
         END FOREACH   
      END IF 
   ELSE  
#FUN-C80001---end
#FUN-C80001---begin mark 移到上面 
#      #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_new CLIPPED,"ima_file",
#      LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
#                   " WHERE ima01 = '",l_ogb.ogb04,"'",
#                   "   AND imaacti = 'Y'"
# 
# 	  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
#      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
#      PREPARE ima_ogb FROM l_sql2
# 
#      EXECUTE ima_ogb INTO g_ima918,g_ima921                                                                             
#FUN-C80001---end   
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      
         #LET l_cnt = 0					#MOD-970042  #FUN-C80001
         FOREACH p900_g_rvbs INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
      
            IF cl_null(p_oga09) THEN
               IF tm.oga09 = "4" THEN
                  LET l_rvbs.rvbs00 = "axmt820"
               ELSE
                  LET l_rvbs.rvbs00 = "axmt821"
               END IF
            ELSE
               IF p_oga09 = "4" THEN
                  LET l_rvbs.rvbs00 = "axmt820"
               ELSE
                  LET l_rvbs.rvbs00 = "axmt821"
               END IF
            END IF
 
            LET l_rvbs.rvbs01 = l_ogb.ogb01
      
            LET l_cnt = l_cnt + 1 			#MOD-970042
            LET l_rvbs.rvbs022 = l_cnt 		#MOD-970042
           #IF g_sma.sma96 <> 'Y' THEN   #FUN-C80001 #FUN-D30099 mark
            IF g_pod.pod08 <> 'Y' THEN   #FUN-D30099 
#CHI-C40031---add---START
               IF g_ogb.ogb17='Y' THEN        #多倉儲出貨
                  IF g_sma.sma115 = 'Y' THEN  #多單位
                     OPEN p900_g_ogg USING l_rvbs.rvbs13
                     FETCH p900_g_ogg INTO g_ogg.*
                     IF STATUS THEN
                        CALL cl_err('ogg',STATUS,1)
                     END IF
                     IF g_ima906 = '3' AND g_ogg.ogg20 = '2' THEN
                        LET l_fac=1
                     ELSE
                     #檢查前站庫存單位與當站庫存單位是否可以轉換
                        CALL s_umfchkm(l_ogb.ogb04,g_ogg.ogg15,l_ogb.ogb15,l_plant_new)
                             RETURNING l_flag,l_fac
                        IF l_flag THEN
                           LET g_msg=l_dbs_new CLIPPED,' ',l_ogb.ogb04
                           CALL cl_err(g_msg,'mfg3075',1)
                           LET g_success = 'N'
                        END IF
                     END IF
                  ELSE
                     OPEN p900_g_ogc USING l_rvbs.rvbs13
                     FETCH p900_g_ogc INTO g_ogc.*
                     IF STATUS THEN
                        CALL cl_err('ogc',STATUS,1)
                     END IF
                   #檢查前站庫存單位與當站庫存單位是否可以轉換
                     CALL s_umfchkm(l_ogb.ogb04,g_ogc.ogc15,l_ogb.ogb15,l_plant_new)
                           RETURNING l_flag,l_fac
                     IF l_flag THEN
                        LET g_msg=l_dbs_new CLIPPED,' ',l_ogb.ogb04
                        CALL cl_err(g_msg,'mfg3075',1)
                        LET g_success = 'N'
                     END IF
                  END IF
               ELSE
#CHI-C40031---add-----END
                  IF g_ogb.ogb15 = l_ogb.ogb15 THEN
                     LET l_fac =1
                  ELSE
                   #檢查前站庫存單位與當站庫存單位是否可以轉換
                     CALL s_umfchkm(l_ogb.ogb04,g_ogb.ogb15,l_ogb.ogb15,l_plant_new) #TQC-9C0099
                          RETURNING l_flag,l_fac
                     IF l_flag THEN
                        LET g_msg=l_dbs_new CLIPPED,' ',l_ogb.ogb04
                        CALL cl_err(g_msg,'mfg3075',1)
                        LET g_success = 'N'
                     END IF 
                  END IF
               END IF #CHI-C40031 add
         
               LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_fac 
            END IF   #FUN-C80001
            LET l_rvbs.rvbs09 = -1
 
            IF cl_null(l_rvbs.rvbs06) THEN
               LET l_rvbs.rvbs06 = 0
            END IF
           #IF g_sma.sma96 <> 'Y' THEN   #FUN-C80001 #FUN-D30099 mark
            IF g_pod.pod08 <> 'Y' THEN   #FUN-D30099
               LET l_rvbs.rvbs13 = 0    #TQC-950001
            END IF                       #FUN-C80001
          #新增批/序號資料檔
            EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                   l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                   l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                   l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09, 
                                   l_rvbs.rvbs13,  #TQC-950001 
                                   gp_plant,gp_legal   #FUN-980010
 
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
               CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF
      
          # CALL p900_imgs(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_oga.oga02,l_rvbs.*)              #No.FUN-A10099
            CALL p900_imgs(l_plant_new,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_oga.oga02,l_rvbs.*)  #No.FUN-A10099
 
         END FOREACH
      END IF
 
#FUN-B90012 -----------------------------Begin----------------------------
      IF s_industry('icd') THEN 
      #FUN-BA0051 --START mark--
      #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",
      #                                     cl_get_target_table(l_plant_new,'ima_file'),
      #             " WHERE imaicd00 = '",l_ogb.ogb04,"'",
      #             "   AND ima01 = imaicd00 ",
      #             "   AND imaacti = 'Y'"
      #
      #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
      #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
      #PREPARE p900_ogb_imaicd08 FROM l_sql2
      #EXECUTE p900_ogb_imaicd08 INTO l_imaicd08 
      #
      #IF l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
         IF s_icdbin_multi(l_ogb.ogb04,l_plant_new) THEN   #FUN-BA0051      
            FOREACH p900_g_idd INTO l_idd.*
               LET l_idd.idd10 = l_ogb.ogb01
               LET l_idd.idd11 = l_ogb.ogb03
               LET l_idd.idd02 = l_ogb.ogb09    #CHI-BB0031
               LET l_idd.idd03 = l_ogb.ogb091   #CHI-BB0031
              #IF g_sma.sma96 <> 'Y' THEN   #FUN-C80001 #FUN-D30099 mark
               IF g_pod.pod08 <> 'Y' THEN   #FUN-D30099
                  LET l_idd.idd04 = l_ogb.ogb092   #CHI-BB0031
               END IF   #FUN-C80001
               CALL icd_idb(l_idd.*,l_plant_new)
            END FOREACH
         END IF
#FUN-C80001---begin  移到上面
#      LET l_sql1 = "SELECT ogbiicd028,ogbiicd029 FROM ",cl_get_target_table(l_plant_new,'ogbi_file'),
#                   " WHERE ogbi01 = '",l_ogb.ogb01,"'",
#                   "   AND ogbi03 =  ",l_ogb.ogb03
#      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
#      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
#      PREPARE p900_ogbi FROM l_sql1
#      EXECUTE p900_ogbi INTO l_ogbiicd028,l_ogbiicd029
#FUN-C80001 
         CALL s_icdpost(12,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,l_oga.oga01,l_ogb.ogb03,
                        l_oga.oga02,'Y','','',l_ogbiicd029,l_ogbiicd028,l_plant_new)
              RETURNING l_flag
         IF l_flag = 0 THEN
            LET g_success = 'N'
         END IF    
      END IF      
   END IF  #FUN-C80001 
#FUN-B90012 -----------------------------End------------------------------
   #新增至暫存檔中
   INSERT INTO p900_file VALUES(p_i,g_ogb.ogb01,g_ogb.ogb03,
                                       l_ogb.ogb13)
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
         LET g_showmsg=p_i,"/",g_ogb.ogb01,"/",l_ogb.ogb03,"/",l_ogb.ogb13  
         CALL s_errmsg('p_no.pab_no,pab_item,pab_price',g_showmsg,'ins p900_file:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","p900_file",g_ogb.ogb01,g_ogb.ogb03,SQLCA.sqlcode,"","ins p900_file",1)   
      END IF
      LET g_success = 'N'
   END IF
 
   #單頭之出貨金額
   LET l_oga.oga50 =l_oga.oga50 + l_ogb.ogb14   #原幣出貨金額(未稅)
   LET l_oga.oga51 =l_oga.oga51 + l_ogb.ogb14t  #原幣出貨金額(含稅)
   LET l_oga.oga52 = l_oga.oga50 * l_oga.oga161/100
   LET l_oga.oga53 = l_oga.oga50 * (l_oga.oga162+l_oga.oga163)/100
 
   IF s_aza.aza50 = 'Y' THEN     #使用分銷功能                                
   #單頭之含稅出貨總金額                                                      
      LET l_oga.oga1008 =l_oga.oga1008 + l_ogb.ogb14t   #原幣出貨金額(含稅)   
      #LET l_sql4="UPDATE ",l_dbs_new_tra CLIPPED,"oga_file",   #FUN-980092 add
      LET l_sql4="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                 "   SET oga1008 = ? ",                                       
                 " WHERE oga01 = ? "                                          
 	  CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
      CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092 add
      PREPARE upd_oga1008 FROM l_sql4                                         
      EXECUTE upd_oga1008 USING l_oga.oga1008,l_oga.oga01                     
      IF SQLCA.sqlcode<>0 THEN                                                
         IF g_bgerr THEN
           CALL s_errmsg('oga01',l_oga.oga01,'upd oga:',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('upd oga:',SQLCA.sqlcode,1)
         END IF
         LET g_success = 'N'                                                  
      END IF                                                                  
   END IF                                                                     
 
   #LET l_sql3="UPDATE ",l_dbs_new_tra CLIPPED,"oga_file", #FUN-980092 add
   LET l_sql3="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
              "   SET oga50 = ? ,",
              "       oga51 = ? ,",
              "       oga52 = ? ,",
              "       oga53 = ? ",
              " WHERE oga01 = ? "
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
   CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3  #FUN-980092 add
   PREPARE upd_oga50 FROM l_sql3
 
   EXECUTE upd_oga50 USING l_oga.oga50,l_oga.oga51,l_oga.oga52,
                           l_oga.oga53,l_oga.oga01
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('oga01',l_oga.oga01,'upd oga:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('upd oga:',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   END IF
 
   IF s_aza.aza50 = 'Y' AND l_oea.oea00 = '6' THEN    #NO.FUN-620024             
      CALL p900_ohbins(p_plant)                       #NO.FUN-620024 FUN-620054 #FUN-980092 add
   END IF                                             #NO.FUN-620024
 
   # 新增完出貨單頭單身後，應更新出通單的出貨單號
   #LET l_sql2="SELECT oga011 FROM ",l_dbs_new_tra CLIPPED,"oga_file",	#FUN-980092 add 
   LET l_sql2="SELECT oga011 FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102  
              " WHERE oga01 = '",l_oga.oga01,"'"                                          
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
   PREPARE oga_t FROM l_sql2                                                
   EXECUTE oga_t INTO l_slip
 
   #LET l_sql2="UPDATE ",l_dbs_new_tra CLIPPED,"oga_file",  #FUN-980092 add
   LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102   
              "   SET oga011  = ? ",                                          
              " WHERE oga01  = ? "                                           
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
   PREPARE upd_oga_t FROM l_sql2                                                
   EXECUTE upd_oga_t USING l_oga.oga01,l_slip
   IF SQLCA.sqlcode<>0 THEN                                                   
      IF g_bgerr THEN
         CALL s_errmsg('oga01',l_oga.oga01,'upd oga:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("upd","oga_file","l_oga.oga011","",SQLCA.sqlcode,"","upd oga01:",1) 
      END IF
      LET g_success = 'N'                                                     
      RETURN                                                                  
   END IF
 
   #回寫最近出庫日 ima74
    LET l_sql1 = "SELECT ima29 ", 
                 #" FROM ",l_dbs_new CLIPPED,"ima_file ", 
                 " FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102    
                 " WHERE ima01='",l_ogb.ogb04,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
    PREPARE ima_p1 FROM l_sql1
    IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN
         CALL s_errmsg("ima01",l_ogb.ogb04,"",SQLCA.sqlcode,1)  
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
      END IF
    END IF
    DECLARE ima_c1 CURSOR FOR ima_p1
    OPEN ima_c1	
    FETCH ima_c1 INTO l_ima29
    # 異動日期需大於原來的異動日期才可 
    #必須判斷null,否則新料不會update
    IF (l_oga.oga02 > l_ima29 OR l_ima29 IS NULL)  THEN
       #LET l_sql2="UPDATE ",l_dbs_new CLIPPED,"ima_file",
       LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102    
                  " SET ima74 = ? ",
                  "   , ima29 = ? ",     #MOD-C30877 add
                  " WHERE ima01 = ?  "
 	   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
       PREPARE upd_ima1 FROM l_sql2
      #EXECUTE upd_ima1 USING l_oga.oga02,l_ogb.ogb04                 #MOD-C30877 mark
       EXECUTE upd_ima1 USING l_oga.oga02,l_oga.oga02,l_ogb.ogb04     #MOD-C30877 add
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
          IF g_bgerr THEN
             CALL s_errmsg('ima01',l_ogb.ogb04,'upd ima',STATUS,1)
          ELSE
             CALL cl_err('upd ima:',STATUS,1)
          END IF
          LET g_success='N'
       END IF
    END IF
   #MOD-790154-end-add
 
END FUNCTION
 
FUNCTION p900_ohains()                                                          
 DEFINE l_oayauno LIKE oay_file.oayauno,  #自動編號否                                      
        l_oay17   LIKE oay_file.oay17,    #銷退單別                                      
        l_oay18   LIKE oay_file.oay18,    #銷退理由碼                                      
        l_oay20   LIKE oay_file.oay20,    #債權代碼                                      
        l_occ02   LIKE occ_file.occ02,    #客戶簡稱                                      
        l_occ07   LIKE occ_file.occ07,    #收款客戶編號                                      
        l_occ08   LIKE occ_file.occ08,    #慣用發票別                                      
        l_occ09   LIKE occ_file.occ09,    #送貨客戶編號                                      
        l_occ11   LIKE occ_file.occ11,    #稅號                                      
        l_occ1023 LIKE occ_file.occ1023,  #收款客戶編號                                      
        l_occ1005 LIKE occ_file.occ1005,  #所屬方                                      
        l_occ1006 LIKE occ_file.occ1006,  #所屬渠道                                      
        l_occ1022 LIKE occ_file.occ1022,  #發票客戶編號                                      
        l_tqk04   LIKE tqk_file.tqk04     #收款條件編號
 DEFINE l_sql,l_sql1   STRING             #MOD-9C0274
 DEFINE li_result LIKE type_file.num5     #TQC-9B0013
                                                                                
   #生成代送銷退單單頭                                                          
   INITIALIZE l_oha.* TO NULL                                                   
                                                                                
   #取得產生銷退單別
   LET l_t = s_get_doc_no(g_oga.oga01)                                          
                                                                                
   LET l_sql1 = "SELECT oayauno,oay17,oay18,oay20 ",                            
                #" FROM ",l_dbs_new CLIPPED,"oay_file ",  
                " FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102    
                " WHERE oayslip='",l_t,"'"                                      
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE oay_p2 FROM l_sql1                                                   
   IF SQLCA.SQLCODE THEN                                                        
      IF g_bgerr THEN
        CALL s_errmsg('oayslip',l_t,'oay_p2',SQLCA.SQLCODE,1)  
      ELSE 
        CALL cl_err('oay_p2',SQLCA.SQLCODE,1)
      END IF
   END IF                                                                       
   DECLARE oay_c2 CURSOR FOR oay_p2                                             
   OPEN oay_c2                                                                  
   FETCH oay_c2 INTO l_oayauno,l_oay17,l_oay18,l_oay20                          
   IF SQLCA.SQLCODE <> 0 THEN                                                   
      IF g_bgerr THEN 
        CALL s_errmsg('oayslip',l_t,'oay_c2',SQLCA.SQLCODE,1)
      END IF                                                                    
      LET g_success='N'                                                         
      RETURN                                                                    
   ELSE                                                                         
      LET g_oay18=l_oay18                                                       
   END IF                                                                       
   CLOSE oay_c2
 
       CALL s_auto_assign_no("axm",l_oay17,g_oga.oga02,"","oha_file","oha01",l_plant_new,"","") 
       RETURNING li_result,g_oha01                                                      
       IF (NOT li_result) THEN 
          LET g_msg = l_plant_new CLIPPED,g_oha01
          CALL s_errmsg("oha01",g_oha01,g_msg CLIPPED,"mfg3046",1) 
          LET g_success ='N'
          RETURN
       END IF   
       LET l_oha.oha01 = g_oha01                                                    
                                                                                
   IF g_cnt = 0 THEN                                                           
      IF g_bgerr THEN 
        CALL s_errmsg('','','','mfg3326',1)   
      ELSE 
        CALL cl_err('','mfg3326',1)
      END IF
      LET g_success = 'N'                                                       
      RETURN                                                                    
   END IF                                                                       
                                                                               
   LET l_sql1 = "SELECT occ07,occ08,occ09,occ1023,occ1005,occ1006,occ1022 ",    
                #" FROM ",l_dbs_new CLIPPED,"occ_file ",
                " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102                  
                " WHERE occ01 ='",l_oga.oga1004,"'"                             
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE occ_p1 FROM l_sql1                                                   
   IF SQLCA.SQLCODE THEN                                                        
      IF g_bgerr THEN
        CALL s_errmsg('oayslip',l_t,'oay_c2',SQLCA.SQLCODE,1) 
      ELSE 
        CALL cl_err('occ_p1',SQLCA.SQLCODE,1) 
      END IF
   END IF                                                                       
   DECLARE occ_c1 CURSOR FOR occ_p1                                             
   OPEN occ_c1                                                                  
   FETCH occ_c1 INTO l_occ07,l_occ08,l_occ09,l_occ1023,                         
                     l_occ1005,l_occ1006,l_occ1022                              
   IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN        
     IF g_bgerr THEN                  
        CALL s_errmsg('oayslip',l_t,'oay_c1',SQLCA.SQLCODE,1) 
     END IF                                                                    
     LET g_success='N'                                                         
      RETURN                                                                    
   END IF                                                                       
   CLOSE occ_c1
 
   IF cl_null(l_occ07) THEN LET l_occ07=' ' END IF                              
   IF cl_null(l_occ08) THEN LET l_occ08=' ' END IF                              
   IF cl_null(l_occ09) THEN LET l_occ09=' ' END IF                              
   IF cl_null(l_occ1005) THEN LET l_occ1005=' ' END IF                          
   IF cl_null(l_occ1006) THEN LET l_occ1006=' ' END IF                          
   IF cl_null(l_occ1023) THEN LET l_occ1023=' ' END IF                          
   IF cl_null(l_occ1022) THEN LET l_occ1022=' ' END IF                          
 
   LET l_sql1 = "SELECT occ02,occ11 ",                                          
                #" FROM ",l_dbs_new CLIPPED,"occ_file ", 
                " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102 
                " WHERE occ01 ='",l_occ07,"'"                                   
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE occ_p2 FROM l_sql1                                                   
   IF SQLCA.SQLCODE THEN                                                        
      IF g_bgerr THEN
        CALL s_errmsg('occ01',l_occ07,'occ_p2',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err('occ_p2',SQLCA.SQLCODE,1)
      END IF
   END IF                                                                       
   DECLARE occ_c2 CURSOR FOR occ_p2                                             
   OPEN occ_c2                                                                  
   FETCH occ_c2 INTO l_occ02,l_occ11                                            
   IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN       
      IF g_bgerr THEN                    
        CALL s_errmsg('occ01',l_occ07,'occ_c2',SQLCA.SQLCODE,1)
      END IF
      LET g_success='N'                                                         
      RETURN                                                                    
   END IF                                                                       
   CLOSE occ_c2 
 
   IF cl_null(l_occ02) THEN LET l_occ02=' ' END IF                              
   IF cl_null(l_occ11) THEN LET l_occ11=' ' END IF                              
 
   LET l_sql1 = "SELECT tqk04 ",                                                
                #" FROM ",l_dbs_new CLIPPED,"tqk_file ",
                " FROM ",cl_get_target_table(l_plant_new,'tqk_file'), #FUN-A50102                 
                " WHERE tqk01 ='",l_oga.oga1004,"'",                            
                "   AND tqk02 ='",l_oga.oga1002,"'",                            
                "   AND tqk03 ='",l_occ1023,"'"                                 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE tqk_p1 FROM l_sql1                                                   
   IF SQLCA.SQLCODE THEN                                                        
      IF g_bgerr THEN   
        LET g_showmsg=l_oga.oga1004,"/",l_oga.oga1002,"/",l_occ1023 
        CALL s_errmsg('tqk01,tqk02,tqk03',g_showmsg,'tqk_p1',SQLCA.SQLCODE,1) 
      ELSE
        CALL cl_err('tqk_p1',SQLCA.SQLCODE,1)
      END IF    
   END IF                                                                       
   DECLARE tqk_c1 CURSOR FOR tqk_p1                                             
   OPEN tqk_c1                                                                  
   FETCH tqk_c1 INTO l_tqk04                                                    
   IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN                          
   IF g_bgerr THEN   
      LET g_showmsg=l_oga.oga1004,"/",l_oga.oga1002,"/",l_occ1023           
      CALL s_errmsg('tqk01,tqk02,tqk03',g_showmsg,'tqk_c1',SQLCA.SQLCODE,1)
   END  IF
      LET g_success='N'                                                         
      RETURN                                                                    
   END IF                                                                       
   CLOSE tqk_c1
 
   IF cl_null(l_tqk04) THEN LET l_tqk04=' ' END IF
                                                                                
   LET l_oha.oha01 = g_oha01               #銷退單號                            
   LET l_oha.oha02 = l_oga.oga02           #銷退日期                            
   LET l_oha.oha03 = l_occ07               #帳款客戶編號                    
   LET l_oha.oha032 = l_occ02              #客戶簡稱                            
   LET l_oha.oha04 = l_oga.oga1004         #退貨客戶編號：代送商                
   LET l_oha.oha05 = '1'                   #銷退別                              
   LET l_oha.oha08 = '1'                   #內銷                                
   LET l_oha.oha09 = '1'                   #銷退處理方式：銷退折讓              
   LET l_oha.oha10 = ''                    #帳單編號                            
   LET l_oha.oha14 = l_oga.oga14           #人員編號                            
   LET l_oha.oha15 = l_oga.oga15           #部門編號                            
   LET l_oha.oha16 = ''                    #出貨單號                            
   LET l_oha.oha17 = ''                    # RMA單號                            
   LET l_oha.oha21 = l_oga.oga21           #稅別                                
   LET l_oha.oha211 = l_oga.oga211         #稅率                                
   LET l_oha.oha212 = l_oga.oga212         #聯數                                
   LET l_oha.oha213 = l_oga.oga213         #含稅否                              
   LET l_oha.oha23 = l_oga.oga23           #幣別                                
   LET l_oha.oha24 = l_oga.oga24           #匯率                                
   LET l_oha.oha25 = l_oga.oga25           #銷售分類一
   LET l_oha.oha24 = l_oga.oga24           #匯率                                
   LET l_oha.oha25 = l_oga.oga25           #銷售分類一                          
   LET l_oha.oha26 = l_oga.oga26           #銷售分類二                          
   LET l_oha.oha31 = l_oga.oga31           #價格條件編號                        
   LET l_oha.oha41 ='N'                    #三角貿易銷退單否                    
   LET l_oha.oha42 ='N'                    #是否入庫存                          
   LET l_oha.oha43 ='N'                    #起始三角貿易銷退單否                
   LET l_oha.oha44 ='N'                    #拋轉否                              
   LET l_oha.oha50 = 0                     #原幣銷退金額(未稅)                  
   LET l_oha.oha53 = 0                     #原幣應開發票未稅金額                
   LET l_oha.oha54 = 0                     #原幣已開發票未稅金額                
   LET l_oha.ohaconf = 'Y'                 #確認否/作廢碼                       
   LET l_oha.ohapost = 'Y'                 #銷退扣帳否                          
   LET l_oha.ohaprsw = 0                   #列印次數                            
   LET l_oha.ohauser = g_user              #資料所有者                          
   LET l_oha.ohagrup = g_grup              #資料所有部門                        
   LET l_oha.ohadate = g_today             #最近修改日                          
   LET l_oha.oha1001 = l_occ1023           #收款客戶編號                        
   LET l_oha.oha1002 = l_oay20             #債權                                
   LET l_oha.oha1003 = l_oga.oga1003       #業績歸屬方                          
   LET l_oha.oha1004 = l_oay18             #退貨原因碼                          
   LET l_oha.oha1005 = l_oga.oga1005       #是否計算業績                        
   LET l_oha.oha1006 = 0                   #折扣金額(未稅)
   LET l_oha.oha1007 = 0                   #折扣金額(含稅)                      
   LET l_oha.oha1008 = 0                   #銷退單總含稅金額                    
   LET l_oha.oha1009 = l_occ1006           #客戶所屬渠道                        
   LET l_oha.oha1010 = l_occ1005           #客戶所屬方                          
   LET l_oha.oha1011 = l_occ1022           #開票客戶                            
   LET l_oha.oha1012 = ''                  #原始退單號                          
   LET l_oha.oha1013 = ''                  #收料驗收單號                        
   LET l_oha.oha1014 = ''                  #代送商                              
   LET l_oha.oha1015 = 'Y'                 #是否對應代送出貨                    
   LET l_oha.oha1016 = l_oga.oga1004       #客戶編號                          
   LET l_oha.oha1017 = 0                   #導物流狀況碼                        
   LET l_oha.oha1018 = l_oga.oga01         #代送出貨單號                        
   LET l_oha.ohaud01 = l_oga.ogaud01
   LET l_oha.ohaud02 = l_oga.ogaud02
   LET l_oha.ohaud03 = l_oga.ogaud03
   LET l_oha.ohaud04 = l_oga.ogaud04
   LET l_oha.ohaud05 = l_oga.ogaud05
   LET l_oha.ohaud06 = l_oga.ogaud06
   LET l_oha.ohaud07 = l_oga.ogaud07
   LET l_oha.ohaud08 = l_oga.ogaud08
   LET l_oha.ohaud09 = l_oga.ogaud09
   LET l_oha.ohaud10 = l_oga.ogaud10
   LET l_oha.ohaud11 = l_oga.ogaud11
   LET l_oha.ohaud12 = l_oga.ogaud12
   LET l_oha.ohaud13 = l_oga.ogaud13
   LET l_oha.ohaud14 = l_oga.ogaud14
   LET l_oha.ohaud15 = l_oga.ogaud15
   IF cl_null(l_oha.oha57) THEN LET l_oha.oha57 = '1' END IF #FUN-AC0055 add
 
   #LET l_sql="INSERT INTO ",l_dbs_new_tra CLIPPED,"oha_file ",   #FUN-980092 add
   LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102 
               "( oha01,oha02,oha03,oha032,oha04, ",                            
               "  oha05,oha08,oha09,oha10,oha14,",                              
               "  oha15,oha16,oha17,oha21,oha211,",                             
               "  oha212,oha213,oha23,oha24,oha25,",                            
               "  oha26,oha31,oha41,oha42,oha43,",                              
               "  oha44,oha50,oha53,oha54,ohaconf,",                            
               "  ohapost,ohaprsw,ohauser,ohagrup,",                            
               "  ohadate,oha1001,oha1002,oha1003,oha1004,",                    
               "  oha1005,oha1006,oha1007,oha1008,oha1009,",                    
               "  oha1010,oha1011,oha1012,oha1013,oha1014,",                    
               "  oha1015,oha1016,oha1017,oha1018, ",                           
               "  ohaplant,ohalegal) ",   #FUN-980010                          
               "  oha1015,oha1016,oha1017,oha1018, ",                           
               "  ohaud01,ohaud02,ohaud03,ohaud04,ohaud05,",                    
               "  ohaud06,ohaud07,ohaud08,ohaud09,ohaud10,",                    
               "  ohaud11,ohaud12,ohaud13,ohaud14,ohaud15,ohaoriu,ohaorig,oha57)",  #FUN-A10036 #FUN-AC0055 add oha57                  
               "  VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                 
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                 
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                 
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",   #No.CHI-950020
                         "?,?,?,?, ?,  ?,?,?,?,?) "   #FUN-980010  #FUN-A10036                                      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE ins_oha FROM l_sql
   EXECUTE ins_oha USING                                                        
      l_oha.oha01,l_oha.oha02,l_oha.oha03,l_oha.oha032,l_oha.oha04,             
      l_oha.oha05,l_oha.oha08,l_oha.oha09,l_oha.oha10,l_oha.oha14,              
      l_oha.oha15,l_oha.oha16,l_oha.oha17,l_oha.oha21,l_oha.oha211,             
      l_oha.oha212,l_oha.oha213,l_oha.oha23,l_oha.oha24,l_oha.oha25,            
      l_oha.oha26,l_oha.oha31,l_oha.oha41,l_oha.oha42,l_oha.oha43,              
      l_oha.oha44,l_oha.oha50,l_oha.oha53,l_oha.oha54,l_oha.ohaconf,            
      l_oha.ohapost,l_oha.ohaprsw,l_oha.ohauser,l_oha.ohagrup,                  
      l_oha.ohadate,l_oha.oha1001,l_oha.oha1002,l_oha.oha1003,l_oha.oha1004,    
      l_oha.oha1005,l_oha.oha1006,l_oha.oha1007,l_oha.oha1008,l_oha.oha1009,    
      l_oha.oha1010,l_oha.oha1011,l_oha.oha1012,l_oha.oha1013,l_oha.oha1014,    
      l_oha.oha1015,l_oha.oha1016,l_oha.oha1017,l_oha.oha1018,                   
      gp_plant,gp_legal   #FUN-980010
     ,l_oha.ohaud01,l_oha.ohaud02,l_oha.ohaud03,l_oha.ohaud04,l_oha.ohaud05,
      l_oha.ohaud06,l_oha.ohaud07,l_oha.ohaud08,l_oha.ohaud09,l_oha.ohaud10,
      l_oha.ohaud11,l_oha.ohaud12,l_oha.ohaud13,l_oha.ohaud14,l_oha.ohaud15,g_user,g_grup, #FUN-A10036
      l_oha.oha57  #FUN-AC0055 add oha57                         
                                                       
      IF SQLCA.sqlcode THEN                                                     
         IF g_bgerr THEN 
           LET g_showmsg=l_oha.oha01,"/",l_oha.oha02,"/",l_oha.oha03        
           CALL s_errmsg('oha01,oha02,oha03',g_showmsg,'',SQLCA.sqlcode,0) 
         ELSE 
           CALL cl_err('',SQLCA.sqlcode,0) 
         END IF
         LET g_success = 'N'                                                    
         RETURN                                                                 
      END IF
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION p900_ohbins(p_plant)             #FUN-980092 add
 DEFINE p_dbs     LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)                  #No.FUN-620054
 DEFINE l_ohb03   LIKE ohb_file.ohb03,      #項次                                    
        l_occ1027 LIKE occ_file.occ1027,    #是否更改訂單單價                                    
        l_unit    LIKE ogb_file.ogb916,     #計價單位                                    
        l_ohb1001 LIKE ohb_file.ohb1001,    #訂價編號                                    
        l_ohb13   LIKE ohb_file.ohb13,      #原幣單價                                    
        l_ohb14   LIKE ohb_file.ohb14,      #原幣稅前金額                                    
        l_ohb13t  LIKE ohb_file.ohb13,      #原幣含稅單價                                    
        l_ohb14t  LIKE ohb_file.ohb14t,     #原幣含稅金額                                    
        l_oay18   LIKE oay_file.oay18,      #銷退理由碼                                    
        p_success LIKE apo_file.apo02       #No.FUN-680137 VARCHAR(04)                                                     
 DEFINE l_sql,l_sql2,l_sql3   STRING        #MOD-9C0274
                                                                                
 DEFINE p_dbs_tra LIKE type_file.chr21   #FUN-980092 add
 DEFINE p_plant   LIKE azp_file.azp01    #FUN-980092 add
 DEFINE l_ohbi   RECORD LIKE ohbi_file.* #FUN-B70074 add
#DEFINE l_oia07   LIKE oia_file.oia07     #FUN-C50136
 DEFINE l_oha14         LIKE oha_file.oha14   #FUN-CB0087
 DEFINE l_oha15         LIKE oha_file.oha15   #FUN-CB0087
 
 LET g_plant_new = p_plant
 CALL s_getdbs()      LET p_dbs = g_dbs_new
 CALL s_gettrandbs()  LET p_dbs_tra = g_dbs_tra
 
    #生成代送銷退單單身                                                         
                                                                                
    INITIALIZE l_ohb.* TO NULL                                                  
    #產生銷退單身                                                               
 
    LET l_sql = "SELECT MAX(ohb03)+1 ",                                         
                #" FROM ",l_dbs_new_tra CLIPPED,"ohb_file ",      #FUN-980092 add
                " FROM ",cl_get_target_table(l_plant_new,'ohb_file'), #FUN-A50102
                " WHERE ohb01 ='",g_oha01,"'"                                   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
    PREPARE ohb_p1 FROM l_sql                                                   
    IF SQLCA.SQLCODE THEN                                                       
       CALL cl_err('ohb_p1',SQLCA.SQLCODE,1)                                    
    END IF                                                                      
    DECLARE ohb_c1 CURSOR FOR ohb_p1                                            
    OPEN ohb_c1                                                                 
    FETCH ohb_c1 INTO l_ohb03                                                   
    IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN                         
       LET g_success='N'                                                        
       RETURN                                                                   
    END IF                                                                      
    CLOSE ohb_c1 
 
    IF cl_null(l_ohb03) OR l_ohb03 = 0 THEN                                     
       LET l_ohb03 = 1                                                          
    END IF                                                                      
 
    LET l_sql = "SELECT occ1027 ",                                              
                #" FROM ",l_dbs_new CLIPPED,"occ_file ",
                " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102                
                " WHERE occ01 ='",l_oga.oga1004,"',",                           
                "   AND occ1014 = '3'"                                          
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE occ_p3 FROM l_sql                                                   
    IF SQLCA.SQLCODE THEN                                                       
       CALL cl_err('occ_p3',SQLCA.SQLCODE,1)                                    
    END IF                                                                      
    DECLARE occ_c3 CURSOR FOR occ_p3                                            
    OPEN occ_c3                                                                 
    FETCH occ_c3 INTO l_occ1027                                                 
    CLOSE occ_c3
 
    IF l_occ1027 ='Y' THEN                                                      
       CALL cl_err(l_oga.oga1004,'atm-255',1)                                   
       LET g_success='N'                                                        
       RETURN                                                                   
    END IF                                                                      
                                                                                
    #根據客戶+產品編號+單位+日期+定價類型取定價編號及單價                       
    IF g_sma.sma116 MATCHES '[23]' THEN                                         
       LET l_unit=l_ogb.ogb916                                                  
    ELSE                                                                        
       LET l_unit=l_ogb.ogb05                                                   
    END IF                                                                      
                                                                                
    CALL s_fetch_price2(g_oga.oga1004,l_ogb.ogb04,l_unit,g_oga.oga02,'1',
                        l_plant_new,g_oga.oga23)   #No.FUN-980059
         RETURNING l_ohb1001,l_ohb13,p_success                                  
    IF p_success ='N' THEN                                                      
       CALL cl_err('fetch price','atm-256',0)                                   
       LET  g_success='N'                                                       
       RETURN                                                                   
    END IF
                                                                                
    #根據單頭單價是否含稅 進行未稅、含稅金額的計算                              
    IF l_oga.oga213='N' THEN                                                    
       LET l_ohb14 = l_ohb13*l_ogb.ogb12                                        
       LET l_ohb13t = l_ohb13*(1+g_oga.oga211/100)                              
       LET l_ohb14t = l_ohb13t*l_ogb.ogb12                                      
    ELSE                                                                        
       LET l_ohb13t = l_ohb13/(1+g_oga.oga211/100)                              
       LET l_ohb14 = l_ohb13t*l_ogb.ogb12                                       
       LET l_ohb14t = l_ohb13*l_ogb.ogb12                                       
    END IF                                                                      
                                                                                
    LET l_ohb.ohb01     = g_oha01             #銷退單號                         
    LET l_ohb.ohb03     = l_ohb03             #項次                             
    LET l_ohb.ohb04     = l_ogb.ogb04         #產品編號                         
    LET l_ohb.ohb05     = l_ogb.ogb05         #銷售單位                         
    LET l_ohb.ohb05_fac = l_ogb.ogb05_fac     #銷售/庫存單位換算率              
    LET l_ohb.ohb910    = l_ogb.ogb910        #第一單位                         
    LET l_ohb.ohb911    = l_ogb.ogb911        #第一單位轉換率                   
    LET l_ohb.ohb912    = l_ogb.ogb912        #第一單位數量                     
    LET l_ohb.ohb913    = l_ogb.ogb913        #第二單位
    LET l_ohb.ohb914    = l_ogb.ogb914        #第二單位轉換率                   
    LET l_ohb.ohb915    = l_ogb.ogb915        #第二單位數量                     
    LET l_ohb.ohb916    = l_ogb.ogb916        #計價單位                         
    LET l_ohb.ohb917    = l_ogb.ogb917        #計價數量                         
    LET l_ohb.ohb06     = l_ogb.ogb06         #品名規格                         
    LET l_ohb.ohb07     = l_ogb.ogb07         #額外品名規格                     
    LET l_ohb.ohb08     = l_ogb.ogb08         #銷退工廠                         
    LET l_ohb.ohb09     = l_ogb.ogb09         #銷退倉庫                         
    LET l_ohb.ohb091    = l_ogb.ogb091        #銷退庫位                         
    LET l_ohb.ohb092    = l_ogb.ogb092        #銷退批號                         
    LET l_ohb.ohb11     = l_ogb.ogb11         #客戶產品編號                     
    LET l_ohb.ohb12     = l_ogb.ogb12         #銷退數量                         
    LET l_ohb.ohb13     = l_ohb13             #原幣單價                         
    LET l_ohb.ohb14     = l_ohb14             #原幣稅前金額                     
    LET l_ohb.ohb14t    = l_ohb14t            #原幣含稅金額                     
    LET l_ohb.ohb15     = l_ogb.ogb15         #庫存明細單位                     
    LET l_ohb.ohb15_fac = l_ogb.ogb15_fac     #銷售/庫存明細單位換算率          
    LET l_ohb.ohb16     = l_ogb.ogb16         #數量                             
    LET l_ohb.ohb30     = ''                  #原出貨發票號                     
    LET l_ohb.ohb31     = ''                  #出貨單號                         
    LET l_ohb.ohb32     = ''                  #出貨項次
    LET l_ohb.ohb33     = ''                  #訂單單號                         
    LET l_ohb.ohb34     = ''                  #訂單項次                         
    LET l_ohb.ohb50     = g_oay18             #退貨理由碼                       
    IF cl_null(l_ohb.ohb50) THEN LET l_ohb.ohb50 = g_poy.poy31 END IF  #TQC-D40064 add
    LET l_ohb.ohb60     = 0                   #已開折讓數量                     
    LET l_ohb.ohb1001   = l_ohb1001           #定價編號                         
    LET l_ohb.ohb1002   = l_ogb.ogb1002       #提案編號                    
    LET l_ohb.ohb1003   = l_ogb.ogb1006       #折扣率                           
    LET l_ohb.ohbud01   = l_ogb.ogbud01
    LET l_ohb.ohbud02   = l_ogb.ogbud02
    LET l_ohb.ohbud03   = l_ogb.ogbud03
    LET l_ohb.ohbud04   = l_ogb.ogbud04
    LET l_ohb.ohbud05   = l_ogb.ogbud05
    LET l_ohb.ohbud06   = l_ogb.ogbud06
    LET l_ohb.ohbud07   = l_ogb.ogbud07
    LET l_ohb.ohbud08   = l_ogb.ogbud08
    LET l_ohb.ohbud09   = l_ogb.ogbud09
    LET l_ohb.ohbud10   = l_ogb.ogbud10
    LET l_ohb.ohbud11   = l_ogb.ogbud11
    LET l_ohb.ohbud12   = l_ogb.ogbud12
    LET l_ohb.ohbud13   = l_ogb.ogbud13
    LET l_ohb.ohbud14   = l_ogb.ogbud14
    LET l_ohb.ohbud15   = l_ogb.ogbud15
 
    #FUN-CB0087--add--str--
    #IF l_aza.aza115 ='Y' AND l_aza.aza50 ='Y' THEN  #TQC-D20067 mark
    IF l_aza.aza115 ='Y' THEN  #TQC-D20067
       IF cl_null(l_ohb.ohb50) THEN                  #TQC-D20067 mark  #TQC-D40064 remark
          #TQC-D20050--mod--str--
          #SELECT oha14,oha15 INTO l_oha14,l_oha15 FROM oha_file WHERE oha01 = l_ohb.ohb01
          #CALL s_reason_code(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15) RETURNING l_ohb.ohb50
          LET l_sql3 = "SELECT oha14,oha15 FROM ",cl_get_target_table(l_plant_new,'oha_file')," WHERE oha01 ='",l_ohb.ohb01,"'"
          PREPARE ohb50_pr FROM l_sql3
          EXECUTE ohb50_pr INTO l_oha14,l_oha15
          CALL s_reason_code1(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15,l_plant_new) RETURNING l_ohb.ohb50
          #TQC-D20050--mod--end--
          IF cl_null(l_ohb.ohb50) THEN
             CALL cl_err(l_ohb.ohb50,'aim-425',1)
             LET g_success="N"
             RETURN
          END IF
       END IF
    END IF
    #FUN-CB0087--add--end--

    LET l_sql3 = "SELECT azf10 ",                                               
                 #" FROM ",l_dbs_new CLIPPED,"azf_file ",
                 " FROM ",cl_get_target_table(l_plant_new,'azf_file'), #FUN-A50102
                 " WHERE azf01 = '",l_ohb.ohb50,"'",                             
                 "   AND azf02 = '2' "      #No.TQC-760054
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
     CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-A50102
    PREPARE azf_p2 FROM l_sql3                                                  
    IF SQLCA.SQLCODE THEN                                                       
       CALL cl_err('azf_p2',SQLCA.SQLCODE,1)                                    
    END IF                                                                      
    DECLARE azf_c2 CURSOR FOR azf_p2                                            
    OPEN azf_c2                                                                 
    FETCH azf_c2 INTO l_ohb.ohb1004                                             
    IF SQLCA.SQLCODE <> 0 THEN                                                  
       LET g_success='N'                                                        
       RETURN                                                                   
    END IF                                                                      
    CLOSE azf_c2     #No.FUN-6B0065
 
    IF l_ohb.ohb1004 = 'Y' THEN
       LET l_ohb.ohb14 = 0
       LET l_ohb.ohb14t= 0
    END IF
 
    #LET l_sql="INSERT INTO ",l_dbs_new_tra CLIPPED,"ohb_file ",        #FUN-980092 add
    #FUN-AB0061----------add---------------str----------------
    IF cl_null(l_ohb.ohb37) OR l_ohb.ohb37 = 0 THEN
       LET l_ohb.ohb37 = l_ohb.ohb13
    END IF
    #FUN-AB0061----------add---------------end----------------
    #FUN-AB0096 ---------------------add start----------------
    #IF cl_null(l_ohb.ohb71) THEN    #FUN-AC0055 mark
    #   LET l_ohb.ohb71 = '1'
    #END IF
    #FUN-AB0096 -------------------add end----------------------
    #FUN-CB0087--add--str--
    #IF l_aza.aza115 ='Y' AND l_aza.aza50 ='Y' THEN #TQC-D20067 mark
    IF l_aza.aza115 ='Y' THEN  #TQC-D20067
       IF cl_null(l_ohb.ohb50) THEN                 #TQC-D20067 mark #TQC-D40064 remark
          #TQC-D20050--mod--str--
          #SELECT oha14,oha15 INTO l_oha14,l_oha15 FROM oha_file WHERE oha01 = l_ohb.ohb01
          #CALL s_reason_code(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15) RETURNING l_ohb.ohb50
          LET l_sql = "SELECT oha14,oha15 FROM ",cl_get_target_table(l_plant_new,'oha_file')," WHERE oha01 = '",l_ohb.ohb01,"'"
          PREPARE ohb50_pr1 FROM l_sql
          EXECUTE ohb50_pr1 INTO l_oha14,l_oha15
          CALL s_reason_code1(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15,l_plant_new) RETURNING l_ohb.ohb50
          #TQC-D20050--mod--end--
          IF cl_null(l_ohb.ohb50) THEN
             CALL cl_err(l_ohb.ohb50,'aim-425',1)
             LET g_success="N"
             RETURN
          END IF
       END IF
    END IF
    #FUN-CB0087--add--end--
    LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'ohb_file'), #FUN-A50102
                "( ohb01,ohb03,ohb04,ohb05,ohb05_fac, ",                        
                "  ohb910,ohb911,ohb912,ohb913,ohb914,",                        
                "  ohb915,ohb916,ohb917,ohb06,ohb07,",                          
                "  ohb08,ohb09,ohb091,ohb092,ohb11,",                           
                "  ohb12,ohb37,ohb13,ohb14,ohb14t,ohb15,",            #FUN-AB0061 add ohba37                
                "  ohb15_fac,ohb16,ohb30,ohb31,ohb32,",                         
                "  ohb33,ohb34,ohb50,ohb60,ohb1001,",                           
                "  ohb1002,ohb1003,ohb1004, ",                                  
                "  ohbplant,ohblegal, ",
                "  ohbud01,ohbud02,ohbud03,ohbud04,ohbud05,",
                "  ohbud06,ohbud07,ohbud08,ohbud09,ohbud10,",
                #"  ohbud11,ohbud12,ohbud13,ohbud14,ohbud15,ohb71)",     #FUN-AB0096 add ohb71
                "  ohbud11,ohbud12,ohbud13,ohbud14,ohbud15)",          #FUN-AC0055 remove ohb71
                "  VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                
                          "?,?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",    #FUN-AB0061 add ?            
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",  #No.CHI-950020
                          "?,?,?,?, ?,?,  ?,? ) "    #FUN-980010          #FUN-AB0096 add ?                              
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE ins_ohb FROM l_sql                                                  
    EXECUTE ins_ohb USING                                                       
       l_ohb.ohb01,l_ohb.ohb03,l_ohb.ohb04,l_ohb.ohb05,l_ohb.ohb05_fac,         
       l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,l_ohb.ohb913,l_ohb.ohb914,        
       l_ohb.ohb915,l_ohb.ohb916,l_ohb.ohb917,l_ohb.ohb06,l_ohb.ohb07,          
       l_ohb.ohb08,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb11,           
       l_ohb.ohb12,l_ohb.ohb37,l_ohb.ohb13,l_ohb.ohb14,l_ohb.ohb14t,l_ohb.ohb15,   #FUN-AB0061 add ohba37            
       l_ohb.ohb15_fac,l_ohb.ohb16,l_ohb.ohb30,l_ohb.ohb31,l_ohb.ohb32,         
       l_ohb.ohb33,l_ohb.ohb34,l_ohb.ohb50,l_ohb.ohb60,l_ohb.ohb1001,           
       l_ohb.ohb1002,l_ohb.ohb1003,l_ohb.ohb1004,
       gp_plant,gp_legal   #FUN-980010
      ,l_ohb.ohbud01,l_ohb.ohbud02,l_ohb.ohbud03,l_ohb.ohbud04,l_ohb.ohbud05,
       l_ohb.ohbud06,l_ohb.ohbud07,l_ohb.ohbud08,l_ohb.ohbud09,l_ohb.ohbud10,
       #l_ohb.ohbud11,l_ohb.ohbud12,l_ohb.ohbud13,l_ohb.ohbud14,l_ohb.ohbud15,l_ohb.ohb71    #FUN-AB0096 add ohb71
       l_ohb.ohbud11,l_ohb.ohbud12,l_ohb.ohbud13,l_ohb.ohbud14,l_ohb.ohbud15    #FUN-AC0055 remove ohb71
 
     IF SQLCA.sqlcode THEN                                                      
        CALL cl_err('',SQLCA.sqlcode,0)                                         
        LET g_success = 'N'                                                     
        RETURN                 
#FUN-B70074--add--insert--
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_ohbi.* TO NULL
           LET l_ohbi.ohbi01 = l_ohb.ohb01
           LET l_ohbi.ohbi03 = l_ohb.ohb03
           IF NOT s_ins_ohbi(l_ohbi.*,l_plant_new) THEN
              LET g_success = 'N'  
              RETURN 
           END IF
        END IF 
#FUN-B70074--add--insert--        
#       #FUN-C50136----add----str----
#       IF g_oaz.oaz96 ='Y' THEN
#          CALL s_ccc_oia07('G',l_oha.oha03) RETURNING l_oia07
#          IF l_oia07 = '0' THEN
#             CALL s_ccc_oia(l_oha.oha03,'G',l_oha.oha01,0,l_plant_new)
#          END IF
#       END IF
#       #FUN-C50136----add----end----
     END IF                                                                     
                                                                                
     LET l_oha.oha50  =l_oha.oha50  +l_ohb.ohb14                                
     LET l_oha.oha53  =l_oha.oha53  +l_ohb.ohb14                                
     LET l_oha.oha1008=l_oha.oha1008+l_ohb.ohb14t                               
                                                                                
     #LET l_sql2="UPDATE ",l_dbs_new_tra CLIPPED,"oha_file",            #FUN-980092 add
     LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
                "   SET oha50  = ? ,",                                          
                "       oha53  = ?, ",                                          
                "       oha1008= ? ",                                           
                " WHERE oha01  = ?  "                                           
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 add
     PREPARE upd_oha FROM l_sql2                                                
     EXECUTE upd_oha USING l_oha.oha50,l_oha.oha53,                             
                           l_oha.oha1008,l_oha.oha01
     IF SQLCA.sqlcode<>0 THEN                                                   
        CALL cl_err('upd oha:',SQLCA.sqlcode,1)                                 
        LET g_success = 'N'                                                     
        RETURN                                                                  
     END IF
 
END FUNCTION                                                                    
                                                                                
#出貨通知單
FUNCTION p900_t_ogains()
   DEFINE l_sql       LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
   DEFINE l_sql1      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
   DEFINE l_sql2      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
   DEFINE i,l_i       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE li_result   LIKE type_file.num5     #FUN-560043  #No.FUN-680137 SMALLINT
   
  #讀取該流程代碼之銷單資料
   LET l_sql1 = "SELECT * ",
                #"  FROM ",l_dbs_new_tra CLIPPED,"oea_file ", #FUN-980092 add
                "  FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                " WHERE oea01='",g_oea.oea01,"' " 
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092 add
   PREPARE toea_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('oea_p1',SQLCA.SQLCODE,1)
   END IF
 
   DECLARE toea_c1 CURSOR FOR oea_p1
 
   OPEN toea_c1
   FETCH toea_c1 INTO l_oea.*
   IF SQLCA.SQLCODE <> 0 THEN
      LET g_success='N'
      RETURN
   END IF
   CLOSE oea_c1
 
  #新增出貨通知單單頭檔(oga_file)
   LET x_oga.oga00 = l_oea.oea00        #出貨別
   LET x_oga.oga01 = l_oga.oga011       #出貨通知單號
   LET g_t1 = s_get_doc_no(x_oga.oga01) #No.FUN-550070
       CALL s_auto_assign_no("axm",g_t1,t_oga.oga02,"","oga_file","oga01",l_plant_new,"","") #FUN-980092 add
            RETURNING li_result,x_oga.oga01
   LET x_oga.oga011= l_oga.oga01        #MOD-520099
   LET x_oga.oga02 = t_oga.oga02        #出貨日期
   LET x_oga.oga021= t_oga.oga021       #結關日期
   LET x_oga.oga022= t_oga.oga022       #裝船日期
   LET x_oga.oga03 = l_oea.oea03
   LET x_oga.oga032= l_oea.oea032
   LET x_oga.oga033= l_oea.oea033
   LET x_oga.oga04 = l_oea.oea04
   LET x_oga.oga044= l_oea.oea044
   LET x_oga.oga05 = l_oea.oea05
   LET x_oga.oga06 = l_oea.oea06
   LET x_oga.oga07 = l_oea.oea07
   LET x_oga.oga08 = l_oea.oea08
   LET x_oga.oga09 = '5'
   LET x_oga.oga10 = null
   LET x_oga.oga11 = null
   LET x_oga.oga12 = null
   LET x_oga.oga13 = g_oga.oga13   #NO.FUN-660068
   LET x_oga.oga14 = l_oea.oea14
   LET x_oga.oga15 = l_oea.oea15
   LET x_oga.oga16 = l_oea.oea01                  #NO.FUN-620024
   IF cl_null(l_oea.oea161) THEN
      LET l_oea.oea161 = 0
   END IF
   IF cl_null(l_oea.oea162) THEN
      LET l_oea.oea162 = 100
   END IF
   IF cl_null(l_oea.oea163) THEN
      LET l_oea.oea163 = 0
   END IF
   LET x_oga.oga161= l_oea.oea161
   LET x_oga.oga162= l_oea.oea162
   LET x_oga.oga163= l_oea.oea163
   LET x_oga.oga18 = l_oea.oea17
   LET x_oga.oga19 = null
   LET x_oga.oga20 = 'Y'
   LET x_oga.oga21 = l_oea.oea21
   LET x_oga.oga211= l_oea.oea211
   LET x_oga.oga212= l_oea.oea212
   LET x_oga.oga213= l_oea.oea213
   LET x_oga.oga23 = l_oea.oea23
   CALL p900_azi(l_oea.oea23)   #讀取幣別資料
 
   #出貨時重新抓取匯率
   CALL s_currm(x_oga.oga23,x_oga.oga02,g_oaz32,l_plant_new) #FUN-980020
       RETURNING x_oga.oga24
 
   #若出貨單頭之幣別=本幣幣別, 則匯率給1, (COI美金立帳, 99.03.05)
   IF x_oga.oga23 = l_aza.aza17 THEN
      LET x_oga.oga24=1
   END IF
   IF cl_null(x_oga.oga24) THEN
      LET x_oga.oga24 = l_oea.oea24
   END IF
   LET x_oga.oga25 = l_oea.oea25
   LET x_oga.oga26 = l_oea.oea26
   LET x_oga.oga27 = t_oga.oga27
   LET x_oga.oga28 = l_oea.oea18
   LET x_oga.oga29 = 0
   LET x_oga.oga30 = 'Y'
   LET x_oga.oga31 = l_oea.oea31
   LET x_oga.oga32 = l_oea.oea32
   LET x_oga.oga33 = l_oea.oea33
   LET x_oga.oga34 = 0
   LET x_oga.oga35 = t_oga.oga35
   LET x_oga.oga36 = t_oga.oga36
   LET x_oga.oga37 = t_oga.oga37
   LET x_oga.oga38 = t_oga.oga38
   LET x_oga.oga39 = t_oga.oga39
   LET x_oga.oga40 = l_oea.oea19
   LET x_oga.oga41 = l_oea.oea41
   LET x_oga.oga42 = l_oea.oea42
   LET x_oga.oga43 = l_oea.oea43
   LET x_oga.oga44 = l_oea.oea44
   LET x_oga.oga45 = l_oea.oea45
   LET x_oga.oga46 = l_oea.oea46
   LET x_oga.oga47 = t_oga.oga47
   LET x_oga.oga48 = t_oga.oga48
   LET x_oga.oga49 = t_oga.oga49
   LET x_oga.oga50 = 0
   LET x_oga.oga52 = 0
   LET x_oga.oga53 = 0
   LET x_oga.oga54 = 0
   LET x_oga.oga57 = '1'           #FUN-AC0055 add
  #LET x_oga.oga65 = l_oea.oea65   #FUN-7B0091 add #FUN-C40072 mark
   LET x_oga.oga65 = 'N'           #FUN-C40072 add
   LET x_oga.oga99 = g_flow99      #No.8047
   LET x_oga.oga901='N'
   LET x_oga.oga905='Y'
   LET x_oga.oga906='N'
   LET x_oga.oga909='Y'
   IF s_aza.aza50 = 'Y' THEN 
   LET x_oga.oga1001=l_oea.oea1001   #收款客戶編號                                          
   LET x_oga.oga1002=l_oea.oea1002   #債權代碼                                          
   LET x_oga.oga1003=l_oea.oea1003   #業績歸屬方                                          
   LET x_oga.oga1004=l_oea.oea1004   #代送商                                          
   LET x_oga.oga1005=l_oea.oea1005   #是否計算業績                                          
   LET x_oga.oga1006=0               #未稅金額                                          
   LET x_oga.oga1007=0               #含稅金額                                          
   LET x_oga.oga1008=0               #出貨總含稅金額                                          
   LET x_oga.oga1009=l_oea.oea1009   #客戶所屬渠道                                          
   LET x_oga.oga1010=l_oea.oea1010   #客戶所屬方                                          
   LET x_oga.oga1011=l_oea.oea1011   #開票客戶                                           
   LET x_oga.oga1012=''              #銷退單單號                                          
   LET x_oga.oga1013='N'             #已打印提案否                                          
   LET x_oga.oga1014='N'             #是否對應代送銷退單                                          
   LET x_oga.oga1015='0'             #導物流狀況碼                                          
   END IF
   LET x_oga.ogaconf='Y'
   LET x_oga.ogapost='Y'
   LET x_oga.ogaprsw=0
   LET x_oga.ogauser=g_user
   LET x_oga.ogagrup=g_grup
   LET x_oga.ogamodu=null
   LET x_oga.ogadate=null
   LET x_oga.ogaud01 = t_oga.ogaud01
   LET x_oga.ogaud02 = t_oga.ogaud02
   LET x_oga.ogaud03 = t_oga.ogaud03
   LET x_oga.ogaud04 = t_oga.ogaud04
   LET x_oga.ogaud05 = t_oga.ogaud05
   LET x_oga.ogaud06 = t_oga.ogaud06
   LET x_oga.ogaud07 = t_oga.ogaud07
   LET x_oga.ogaud08 = t_oga.ogaud08
   LET x_oga.ogaud09 = t_oga.ogaud09
   LET x_oga.ogaud10 = t_oga.ogaud10
   LET x_oga.ogaud11 = t_oga.ogaud11
   LET x_oga.ogaud12 = t_oga.ogaud12
   LET x_oga.ogaud13 = t_oga.ogaud13
   LET x_oga.ogaud14 = t_oga.ogaud14
   LET x_oga.ogaud15 = t_oga.ogaud15
   #新增出貨通知單頭檔(oga_file)
   #LET l_sql2="INSERT INTO ",l_dbs_new_tra CLIPPED,"oga_file", #FUN-980092 add
   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
              "( oga00,oga01,oga011,oga02, ",
              "  oga021,oga022,oga03,oga032,",
              "  oga033,oga04,oga044,oga05,",
              "  oga06,oga07,oga08,oga09,",
              "  oga10,oga11,oga12,oga13,",
              "  oga14,oga15,oga16,oga161,",
              "  oga162,oga163,oga17,oga18,",
              "  oga19,oga20,oga21,oga211,",
              "  oga212,oga213,oga23,oga24,",
              "  oga25,oga26,oga27,oga28,",
              "  oga29,oga30,oga31,oga32,",
              "  oga33,oga34,oga35,",
              "  oga36,oga37,oga38,oga39,",
              "  oga40,oga41,oga42,oga43,",
              "  oga44,oga45,oga46,oga47,",
              "  oga48,oga49,oga50,",
              "  oga52,oga53,oga54,oga57,oga65,oga99,",   #FUN-7B0091 add oga65  #FUN-AC0055 add oga57
              "  oga901,oga902,",
              "  oga903,oga904,oga905,oga906,",
              "  oga907,oga908,oga909,oga1001,",    #NO.FUN-620024                
              "  oga1002,oga1003,oga1004,oga1005,", #NO.FUN-620024                
              "  oga1006,oga1007,oga1008,oga1009,", #NO.FUN-620024                
              "  oga1010,oga1011,oga1012,oga1013,", #NO.FUN-620024                
              "  oga1014,oga1015,ogaconf,",         #NO.FUN-620024
              "  ogapost,ogaprsw,ogauser,ogagrup,",
              "  ogamodu,ogadate, ",
              "  ogaplant,ogalegal, ",
              "  ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,",
              "  ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,",
              "  ogaud11,ogaud12,ogaud13,ogaud14,ogaud15,ogaoriu,ogaorig)", #FUN-A10036
              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",   #No.CHI-950020
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",   #NO.FUN-620024 
                       "?,?,?,   ?,?,?,?) "   #FUN-7B0091 add ?  #FUN-980010  #FUN-A10036
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ins_t_oga FROM l_sql2
   EXECUTE ins_t_oga USING 
         x_oga.oga00,x_oga.oga01,x_oga.oga011,x_oga.oga02, 
         x_oga.oga021,x_oga.oga022,x_oga.oga03,x_oga.oga032,
         x_oga.oga033,x_oga.oga04,x_oga.oga044,x_oga.oga05,
         x_oga.oga06,x_oga.oga07,x_oga.oga08,x_oga.oga09,
         x_oga.oga10,x_oga.oga11,x_oga.oga12,x_oga.oga13,
         x_oga.oga14,x_oga.oga15,x_oga.oga16,x_oga.oga161,
         x_oga.oga162,x_oga.oga163,x_oga.oga17,x_oga.oga18,
         x_oga.oga19,x_oga.oga20,x_oga.oga21,x_oga.oga211,
         x_oga.oga212,x_oga.oga213,x_oga.oga23,x_oga.oga24,
         x_oga.oga25,x_oga.oga26,x_oga.oga27,x_oga.oga28,
         x_oga.oga29,x_oga.oga30,x_oga.oga31,x_oga.oga32,
         x_oga.oga33,x_oga.oga34,x_oga.oga35,
         x_oga.oga36,x_oga.oga37,x_oga.oga38,x_oga.oga39,
         x_oga.oga40,x_oga.oga41,x_oga.oga42,x_oga.oga43,
         x_oga.oga44,x_oga.oga45,x_oga.oga46,x_oga.oga47,
         x_oga.oga48,x_oga.oga49,x_oga.oga50,
         x_oga.oga52,x_oga.oga53,x_oga.oga54,x_oga.oga57,x_oga.oga65,x_oga.oga99,   #FUN-7B0091 add oga65   #FUN-AC0055 add x_oga.oga57
         x_oga.oga901,x_oga.oga902,
         x_oga.oga903,x_oga.oga904,x_oga.oga905,x_oga.oga906,
         x_oga.oga907,x_oga.oga908,x_oga.oga909,x_oga.oga1001,    #NO.FUN-620024
         x_oga.oga1002,x_oga.oga1003,x_oga.oga1004,x_oga.oga1005, #NO.FUN-620024
         x_oga.oga1006,x_oga.oga1007,x_oga.oga1008,x_oga.oga1009, #NO.FUN-620024
         x_oga.oga1010,x_oga.oga1011,x_oga.oga1012,x_oga.oga1013, #NO.FUN-620024
         x_oga.oga1014,x_oga.oga1015,x_oga.ogaconf,               #NO.FUN-620024
         x_oga.ogapost,x_oga.ogaprsw,x_oga.ogauser,x_oga.ogagrup,
         x_oga.ogamodu,x_oga.ogadate,
         gp_plant,gp_legal   #FUN-980010
        ,x_oga.ogaud01,x_oga.ogaud02,x_oga.ogaud03,x_oga.ogaud04,x_oga.ogaud05,
         x_oga.ogaud06,x_oga.ogaud07,x_oga.ogaud08,x_oga.ogaud09,x_oga.ogaud10,
         x_oga.ogaud11,x_oga.ogaud12,x_oga.ogaud13,x_oga.ogaud14,x_oga.ogaud15,g_user,g_grup #FUN-A10036
 
   IF SQLCA.sqlcode<>0 THEN
      CALL cl_err('ins t_oga:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
#出貨通知單身檔
FUNCTION p900_t_ogbins(p_i)
   DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
   DEFINE l_sql1     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
   DEFINE l_sql2     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
   DEFINE l_sql3     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(400)
   DEFINE l_sql5     LIKE type_file.chr1000            #NO.FUN-620024  #No.FUN-680137 VARCHAR(700)
   DEFINE p_i        LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_no       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_price    LIKE ogb_file.ogb13
   DEFINE i,l_i      LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_msg      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
   DEFINE l_chr      LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_ima02    LIKE ima_file.ima02
   DEFINE l_ima25    LIKE ima_file.ima25
  # DEFINE l_imaqty   LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_imaqty   LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_ima86    LIKE ima_file.ima86
   DEFINE l_ima39    LIKE ima_file.ima39
   DEFINE l_ima35    LIKE ima_file.ima35
   DEFINE l_ima36    LIKE ima_file.ima36
   DEFINE l_ogbi     RECORD LIKE ogbi_file.* #No.FUN-7B0018 
#  DEFINE l_oia07   LIKE oia_file.oia07     #FUN-C50136
   DEFINE x_oga14   LIKE oga_file.oga14   #FUN-CB0087
   DEFINE x_oga15   LIKE oga_file.oga15   #FUN-CB0087
   
   #讀取訂單單身檔(oeb_file)
   LET l_sql1 = "SELECT * ",
                #"  FROM ",l_dbs_new_tra CLIPPED,"oeb_file ", #FUN-980092 add
                "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102
                " WHERE oeb01='",t_ogb.ogb31,"' " ,   #No.MOD-5B0326
                "   AND oeb03 =",t_ogb.ogb32          #No.MOD-5B0326
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1  #FUN-980092 add
   PREPARE toeb_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('toeb_p1',SQLCA.SQLCODE,1)   #No.MOD-5B0326
   END IF
 
   DECLARE toeb_c1 CURSOR FOR toeb_p1   #No.MOD-5B0326
 
   OPEN toeb_c1
   FETCH toeb_c1 INTO l_oeb.*
   IF SQLCA.SQLCODE <> 0 THEN
      LET g_success='N'
      RETURN
   END IF
 
   CLOSE toeb_c1
 
   CALL p900_ima(l_oeb.oeb04)
      RETURNING l_ima02,l_ima25,l_imaqty,l_ima86,l_ima39,l_ima35,l_ima36
   IF cl_null(l_ima35) THEN LET l_ima35=' ' END IF
   IF cl_null(l_ima36) THEN LET l_ima36=' ' END IF
 
   #新增出貨單身檔[ogb_file]
   LET x_ogb.ogb01 = x_oga.oga01      #出貨單號
   LET x_ogb.ogb03 = t_ogb.ogb03      #項次
   LET x_ogb.ogb04 = l_oeb.oeb04      #產品編號
   LET x_ogb.ogb05 = l_oeb.oeb05      #銷售單位
   LET x_ogb.ogb05_fac= l_oeb.oeb05_fac  #換算率
   LET x_ogb.ogb06 = l_oeb.oeb06      #品名規格
   LET x_ogb.ogb07 = l_oeb.oeb07      #額外品名編號
   LET x_ogb.ogb08 = l_oeb.oeb08      #出貨工廠
   IF NOT cl_null(p_imd01) THEN
      CALL p900_imd(p_imd01,l_plant_new)  #FUN-980092 add
      LET x_ogb.ogb09 = p_imd01          #出貨倉庫
      LET x_ogb.ogb091= ' '              #出貨儲位
      LET x_ogb.ogb092= ' '              #出貨批號
   ELSE
   IF NOT cl_null(l_ima35) THEN
      LET x_ogb.ogb09 = l_ima35          #出貨倉庫
      LET x_ogb.ogb091= l_ima36          #出貨儲位
      LET x_ogb.ogb092= ' '              #出貨批號
      LET p_imd01 = l_ima35              #MOD-C80071 add
      CALL p900_imd(p_imd01,l_plant_new) #MOD-C80071 add
   ELSE   
      LET x_ogb.ogb09 = t_ogb.ogb09      #出貨倉庫
      LET x_ogb.ogb091= t_ogb.ogb091     #出貨儲位
      LET x_ogb.ogb092= t_ogb.ogb092     #出貨批號
      LET p_imd01 = t_ogb.ogb09          #MOD-C80071 add
      CALL p900_imd(p_imd01,l_plant_new) #MOD-C80071 add
   END IF
   END IF                             #MOD-710073 add
   LET x_ogb.ogb11 = l_oeb.oeb11      #客戶產品編號
   LET x_ogb.ogb12 = t_ogb.ogb12      #實際出貨數量
   LET x_ogb.ogb13 = l_oeb.oeb13      #原幣單價
 
   LET x_ogb.ogb917 = t_ogb.ogb917 #TQC-710049  add 因為x_ogb.ogb917為NULL導致x_ogb.ogb14,x_ogb.ogb14t 也為NULL
   #未稅金額/含稅金額 : oeb14/oeb14t
   IF x_oga.oga213 = 'N' THEN
      LET x_ogb.ogb14=x_ogb.ogb917*x_ogb.ogb13  #No.TQC-6A0084
      LET x_ogb.ogb14t=x_ogb.ogb14*(1+x_oga.oga211/100)
   ELSE 
      LET x_ogb.ogb14t=x_ogb.ogb917*x_ogb.ogb13  #No.TQC-6A0084
      LET x_ogb.ogb14=x_ogb.ogb14t/(1+x_oga.oga211/100)
   END IF
   LET x_ogb.ogb15 = l_oeb.oeb05
   LET x_ogb.ogb15_fac = 1
   LET x_ogb.ogb16 = x_ogb.ogb12
   LET x_ogb.ogb17 = 'N'
   LET x_ogb.ogb18 = x_ogb.ogb12
   LET x_ogb.ogb19 = g_ogb.ogb19  #NO.FUN-620024
   LET x_ogb.ogb20 =' '
   LET x_ogb.ogb31 = l_oeb.oeb01
   LET x_ogb.ogb32 = l_oeb.oeb03
   LET x_ogb.ogb60 =0
   LET x_ogb.ogb63 =0
   LET x_ogb.ogb64 =0
   CALL cl_digcut(x_ogb.ogb14,l_azi.azi04) RETURNING x_ogb.ogb14
   CALL cl_digcut(x_ogb.ogb14t,l_azi.azi04)RETURNING x_ogb.ogb14t
   LET x_ogb.ogb910 = t_ogb.ogb910
   LET x_ogb.ogb911 = t_ogb.ogb911
   LET x_ogb.ogb912 = t_ogb.ogb912
   LET x_ogb.ogb913 = t_ogb.ogb913
   LET x_ogb.ogb914 = t_ogb.ogb914
   LET x_ogb.ogb915 = t_ogb.ogb915
   LET x_ogb.ogb916 = t_ogb.ogb916
   LET x_ogb.ogb1001 = l_oeb.oeb1001                                  #MOD-B80234
   IF cl_null(x_ogb.ogb1001) THEN LET x_ogb.ogb1001 = g_poy.poy28 END IF  #TQC-D40064 add
                                                                                
   IF s_aza.aza50 = 'Y' THEN
#     LET x_ogb.ogb1001 = l_oeb.oeb1001   #原因碼       #CHI-960012   #MOD-B80234 mark
      LET x_ogb.ogb1002 = l_oeb.oeb1002   #訂價編號                                       
      LET x_ogb.ogb1003 = l_oeb.oeb15     #預計出貨日期                                       
      LET x_ogb.ogb1004 = l_oeb.oeb1004   #提案編號                                       
      LET x_ogb.ogb1005 = l_oeb.oeb1003   #作業方式                                        
      LET x_ogb.ogb1007 = ''              #現金折扣單號                                       
      LET x_ogb.ogb1008 = ''              #稅種                                       
      LET x_ogb.ogb1009 = ''              #稅率                                       
      LET x_ogb.ogb1010 = ''              #含稅否                                       
      LET x_ogb.ogb1011 = ''              #非直營KAB                                       
      LET x_ogb.ogb1006 = l_oeb.oeb1006   #折扣率                              
      LET x_ogb.ogb1012 = l_oeb.oeb1012   #搭贈
   END IF                                 
   IF x_ogb.ogb1012 = 'Y' THEN                               
      LET x_ogb.ogb14 =0                                       
      LET x_ogb.ogb14t=0                                  
   END IF                                     
   LET x_ogb.ogb1014='N' #保稅放行否 #FUN-6B0044
   LET x_ogb.ogbud01 = t_ogb.ogbud01
   LET x_ogb.ogbud02 = t_ogb.ogbud02
   LET x_ogb.ogbud03 = t_ogb.ogbud03
   LET x_ogb.ogbud04 = t_ogb.ogbud04
   LET x_ogb.ogbud05 = t_ogb.ogbud05
   LET x_ogb.ogbud06 = t_ogb.ogbud06
   LET x_ogb.ogbud07 = t_ogb.ogbud07
   LET x_ogb.ogbud08 = t_ogb.ogbud08
   LET x_ogb.ogbud09 = t_ogb.ogbud09
   LET x_ogb.ogbud10 = t_ogb.ogbud10
   LET x_ogb.ogbud11 = t_ogb.ogbud11
   LET x_ogb.ogbud12 = t_ogb.ogbud12
   LET x_ogb.ogbud13 = t_ogb.ogbud13
   LET x_ogb.ogbud14 = t_ogb.ogbud14
   LET x_ogb.ogbud15 = t_ogb.ogbud15
#FUN-AB0061 -----------add start---------------- 
    LET x_ogb.ogb37 = l_oeb.oeb37
    IF cl_null(x_ogb.ogb37) OR x_ogb.ogb37=0 THEN           
       LET x_ogb.ogb37=x_ogb.ogb13                         
    END IF                                                                             
#FUN-AB0061 -----------add end----------------   
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 -----------add start-------------
#    IF cl_null(x_ogb.ogb50) THEN
#       LET x_ogb.ogb50 = '1'
#    END IF
##FUN-AB0096 ----------add end---------------------  
#FUN-AC0055 mark ----------------------end------------------------
     #FUN-C50097 ADD BEGIN-----
     IF cl_null(x_ogb.ogb50) THEN 
       LET x_ogb.ogb50 = 0
     END IF 
     IF cl_null(x_ogb.ogb51) THEN 
       LET x_ogb.ogb51 = 0
     END IF 
     IF cl_null(x_ogb.ogb52) THEN 
       LET x_ogb.ogb52 = 0
     END IF        
     IF cl_null(x_ogb.ogb53) THEN 
       LET x_ogb.ogb53 = 0
     END IF 
     IF cl_null(x_ogb.ogb54) THEN 
       LET x_ogb.ogb54 = 0
     END IF 
     IF cl_null(x_ogb.ogb55) THEN 
       LET x_ogb.ogb55 = 0
     END IF                                      
     #FUN-C50097 ADD END------- 

     #TQC-D20047--add--str--
     LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
     PREPARE aza115_pr2 FROM l_sql2
     EXECUTE aza115_pr2 INTO g_aza.aza115   
     #TQC-D20047--add--end--
     #FUN-CB0087--add--str--
     #IF g_aza.aza115='Y' THEN                            #TQC-D40064 mark
     IF g_aza.aza115='Y' AND cl_null(x_ogb.ogb1001) THEN  #TQC-D40064 add
        #TQC-D20050--mod--str--
        #SELECT oga14,oga15 INTO x_oga14,x_oga15 FROM oga_file WHERE oga01 = x_ogb.ogb01
        #CALL s_reason_code(x_ogb.ogb01,x_ogb.ogb31,'',x_ogb.ogb04,x_ogb.ogb09,x_oga14,x_oga15) RETURNING x_ogb.ogb1001
        LET l_sql2="SELECT oga14,oga15 FROM ",cl_get_target_table(l_plant_new,'oga_file')," WHERE oga01 ='",x_ogb.ogb01,"'"
        PREPARE ogb1001_pr2 FROM l_sql2
        EXECUTE ogb1001_pr2 INTO x_oga14,x_oga15
        CALL s_reason_code1(x_ogb.ogb01,x_ogb.ogb31,'',x_ogb.ogb04,x_ogb.ogb09,x_oga14,x_oga15,l_plant_new) RETURNING x_ogb.ogb1001 
        #TQC-D20050--mod--end-- 
        IF cl_null(x_ogb.ogb1001) THEN
           CALL cl_err(x_ogb.ogb1001,'aim-425',1)
           LET g_success="N"
           RETURN
        END IF
     END IF
     #FUN-CB0087--add--end--
   #新增出貨單身檔
   #LET l_sql2="INSERT INTO ",l_dbs_new_tra CLIPPED,"ogb_file", #FUN-980092 add
   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
              "(ogb01,ogb03,ogb04,ogb05, ",
              " ogb05_fac,ogb06,ogb07,ogb08, ",
              " ogb09,ogb091,ogb092,ogb11, ",
              " ogb12,ogb37,ogb13,ogb14,ogb14t,",#FUN-AB0061
              " ogb15,ogb15_fac,ogb16,ogb17, ",
              " ogb18,ogb19,ogb20,ogb31,",
              " ogb32,ogb60,ogb63,ogb64,",
              " ogb901,ogb902,ogb903,ogb904,",
              " ogb905,ogb906,ogb907,ogb908,",
              " ogb909,ogb910,ogb911,ogb912,",
              " ogb913,ogb914,ogb915,ogb916,",
              " ogb917,ogb1001,ogb1002,ogb1003,",   #NO.FUN-620024                         
              " ogb1004,ogb1005,ogb1007,ogb1008,",  #NO.FUN-620024                         
              " ogb1009,ogb1010,ogb1011,ogb1006,ogb1012,ogb1014, ", #NO.FUN-620024 #FUN-6B0044 
              " ogbplant,ogblegal ,",
              " ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",
              " ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",
              " ogbud11,ogbud12,ogbud13,ogbud14,ogbud15,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",   #FUN-C50097 ADD 50,51,52  ,ogb50,ogb51,ogb52 
              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?,",    #NO.FUN-620024
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",         #No.CHI-950020
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?, ", #FUN-6B0044
              "         ?,?,?,?, ?,?,?,?, ?)  " #FUN-980010#FUN-AB0061     #FUN-AB0096 add? #FUN-C50097 ADD 50,51,52 ,?,?,?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ins_t_ogb FROM l_sql2
   EXECUTE ins_t_ogb USING 
       x_ogb.ogb01,x_ogb.ogb03,x_ogb.ogb04,x_ogb.ogb05, 
       x_ogb.ogb05_fac,x_ogb.ogb06,x_ogb.ogb07,x_ogb.ogb08, 
       x_ogb.ogb09,x_ogb.ogb091,x_ogb.ogb092,x_ogb.ogb11, 
       x_ogb.ogb12,x_ogb.ogb37,x_ogb.ogb13,x_ogb.ogb14,x_ogb.ogb14t,#FUN-AB0061
       x_ogb.ogb15,x_ogb.ogb15_fac,x_ogb.ogb16,x_ogb.ogb17, 
       x_ogb.ogb18,x_ogb.ogb19,x_ogb.ogb20,x_ogb.ogb31,
       x_ogb.ogb32,x_ogb.ogb60,x_ogb.ogb63,x_ogb.ogb64,
       x_ogb.ogb901,x_ogb.ogb902,x_ogb.ogb903,x_ogb.ogb904,
       x_ogb.ogb905,x_ogb.ogb906,x_ogb.ogb907,x_ogb.ogb908,
       x_ogb.ogb909,x_ogb.ogb910,x_ogb.ogb911,x_ogb.ogb912,
       x_ogb.ogb913,x_ogb.ogb914,x_ogb.ogb915,x_ogb.ogb916,
       x_ogb.ogb917,x_ogb.ogb1001,x_ogb.ogb1002,x_ogb.ogb1003,   #NO.FUN-620024    
       x_ogb.ogb1004,x_ogb.ogb1005,x_ogb.ogb1007,x_ogb.ogb1008,  #NO.FUN-620024    
       x_ogb.ogb1009,x_ogb.ogb1010,x_ogb.ogb1011,x_ogb.ogb1006,x_ogb.ogb1012,x_ogb.ogb1014, #NO.FUN-620024  #FUN-6B0044
       gp_plant,gp_legal   #FUN-980010
      ,x_ogb.ogbud01,x_ogb.ogbud02,x_ogb.ogbud03,x_ogb.ogbud04,x_ogb.ogbud05,
       x_ogb.ogbud06,x_ogb.ogbud07,x_ogb.ogbud08,x_ogb.ogbud09,x_ogb.ogbud10,
       x_ogb.ogbud11,x_ogb.ogbud12,x_ogb.ogbud13,x_ogb.ogbud14,x_ogb.ogbud15,
       x_ogb.ogb50,x_ogb.ogb51,x_ogb.ogb52,x_ogb.ogb53,x_ogb.ogb54,x_ogb.ogb55 #FUN-C50097 ADD 50,51,52 
 
   IF SQLCA.sqlcode<>0 THEN
      CALL cl_err('ins t_ogb:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_ogbi.* TO NULL
         LET l_ogbi.ogbi01 = x_ogb.ogb01
         LET l_ogbi.ogbi03 = x_ogb.ogb03
         IF NOT s_ins_ogbi(l_ogbi.*,l_plant_new) THEN #FUN-980092 add
            LET g_success = 'N'
         END IF
      END IF
#     #FUN-C50136----add----str----
#     IF g_oaz.oaz96 ='Y' THEN
#        CALL s_ccc_oia07('D',x_oga.oga03) RETURNING l_oia07
#        IF l_oia07 = '0' THEN
#           CALL s_ccc_oia(x_oga.oga03,'D',x_oga.oga01,0,l_plant_new)
#        END IF
#     END IF
#     #FUN-C50136----add----end----
   END IF
 
   IF s_aza.aza50 = 'Y' THEN     #使用分銷功能                                
   #單頭之含稅出貨總金額                                                      
      LET x_oga.oga1008 = x_oga.oga1008 + x_ogb.ogb14t   #原幣出貨金額(含稅)  
      #LET l_sql5="UPDATE ",l_dbs_new_tra CLIPPED,"oga_file",  #FUN-980092 add
      LET l_sql5="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                 "   SET oga1008 = ? ",                                       
                 " WHERE oga01 = ? "                                          
 	 CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5        #FUN-920032
      CALL cl_parse_qry_sql(l_sql5,l_plant_new) RETURNING l_sql5 #FUN-980092 add
      PREPARE upd_oga1008a FROM l_sql5                                        
      EXECUTE upd_oga1008a USING x_oga.oga1008,x_oga.oga01                    
      IF SQLCA.sqlcode<>0 THEN                                                
         CALL cl_err('upd oga:',SQLCA.sqlcode,1)                              
         LET g_success = 'N'                                                  
      END IF                                                                  
   END IF                                                                     
 
   #單頭之出貨金額
   LET x_oga.oga50 =x_oga.oga50 + x_ogb.ogb14   #原幣出貨金額(未稅)
   LET x_oga.oga51 =x_oga.oga51 + x_ogb.ogb14t  #原幣出貨金額(含稅)
   LET x_oga.oga52 = x_oga.oga50 * x_oga.oga161/100
   LET x_oga.oga53 = x_oga.oga50 * (x_oga.oga162+x_oga.oga163)/100
 
   #LET l_sql3="UPDATE ",l_dbs_new_tra CLIPPED,"oga_file", #FUN-980092 add
   LET l_sql3="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
              "   SET oga50 = ? ,",
              "       oga51 = ? ,",
              "       oga52 = ? ,",
              "       oga53 = ? ",
              " WHERE oga01 = ? "
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
   CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3  #FUN-980092 add
   PREPARE upd_toga50 FROM l_sql3
   EXECUTE upd_toga50 USING x_oga.oga50,x_oga.oga51,x_oga.oga52,
                           x_oga.oga53,x_oga.oga01
 
   IF SQLCA.sqlcode<>0 THEN
      CALL cl_err('upd oga:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
#INSERT 收貨單頭
FUNCTION p900_rvains()
   DEFINE l_sql,l_sql1,l_sql2       STRING   #MOD-9C0274
   DEFINE i,l_i       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE li_result   LIKE type_file.num5     #FUN-560043  #No.FUN-680137 SMALLINT
   
  #讀取該流程代碼之採購單資料
     LET l_sql1 = "SELECT * ",
                  #"  FROM ",l_dbs_new_tra CLIPPED,"pmm_file ", #FUN-980092 add
                  "  FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                  " WHERE pmm99='",g_oea.oea99,"' AND pmm18 <> 'X'"  #NO.FUN-620024
  
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALl cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092 add
     PREPARE pmm_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        IF g_bgerr THEN
          CALL s_errmsg('pmm99',g_oea.oea99,'pmm_p1',SQLCA.SQLCODE,1) 
        ELSE 
          CALL cl_err('pmm_p1',SQLCA.SQLCODE,1)
        END IF
     END IF
  
     DECLARE pmm_c1 CURSOR FOR pmm_p1
     OPEN pmm_c1
     FETCH pmm_c1 INTO g_pmm.*
     IF SQLCA.SQLCODE <> 0 THEN
      IF g_bgerr THEN 
        CALL s_errmsg('pmm99',g_oea.oea99,'pmm_c1',SQLCA.SQLCODE,1) 
      END IF                                                                    
        LET g_success='N'
        RETURN
     END IF
     CLOSE pmm_c1
 
   #讀取l_dbs_new 之原幣資料(採購幣別)
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs_new CLIPPED,"azi_file ",
                " FROM ",cl_get_target_table(l_plant_new,'azi_file'), #FUN-A50102
                " WHERE azi01='",g_pmm.pmm22,"' " 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE azi_p3 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
     IF g_bgerr THEN
       CALL s_errmsg('azi01',g_pmm.pmm22,'azi_p3',SQLCA.SQLCODE,1)
     ELSE
       CALL cl_err('azi_p3',SQLCA.SQLCODE,1)  
     END IF 
   END IF
   DECLARE azi_c3 CURSOR FOR azi_p3
   OPEN azi_c3
   FETCH azi_c3 INTO l_azi_p.* 
   CLOSE azi_c3
 
   #新增驗收單單頭檔(rva_file)
       CALL s_auto_assign_no("apm",rva_t1,g_oga.oga02,"","rva_file","rva01",l_plant_new,"","") #FUN-980092 add
            RETURNING li_result,l_rva.rva01
       IF (NOT li_result) THEN 
          LET g_msg = l_plant_new CLIPPED,l_rva.rva01
          CALL s_errmsg("rva01",l_rva.rva01,g_msg CLIPPED,"mfg3046",1) 
          LET g_success ='N'
          RETURN
       END IF   
   #來源出貨單單頭若無訂單號,拋轉後也不應有訂單號
   IF cl_null(g_oga.oga16) THEN
      LET l_rva.rva02 = null         
   ELSE 
      LET l_rva.rva02 = g_pmm.pmm01         
   END IF
   LET l_rva.rva04 = 'N'                #是否為 L/C 收料
   LET l_rva.rva05 = p_pmm09            #供應廠商    #FUN-6700007
   LET l_rva.rva06 = g_oga.oga02        #收貨日期
   LET l_rva.rva10 = g_pmm.pmm02        #採購類別
   LET l_rva.rvaprsw='Y'                #是否需列印驗收單 
   LET l_rva.rva21 = NULL
   LET l_rva.rva23 = NULL
   LET l_rva.rva99 = g_flow99           #No.8047
   LET l_rva.rvaconf= 'Y'
   LET l_rva.rva32 = '1'                #MOD-C50021 add
   LET l_rva.rvaacti= 'Y'
   LET l_rva.rvaprno= 0
   LET l_rva.rvauser= g_user
   LET l_rva.rvagrup= g_grup
   LET l_rva.rvamodu= null
   LET l_rva.rvadate= null
   LET l_rva.rva00 = '1'          #FUN-940083 add
   LET l_rva.rvaud01=g_oga.ogaud01
   LET l_rva.rvaud02=g_oga.ogaud02
   LET l_rva.rvaud03=g_oga.ogaud03
   LET l_rva.rvaud04=g_oga.ogaud04
   LET l_rva.rvaud05=g_oga.ogaud05
   LET l_rva.rvaud06=g_oga.ogaud06
   LET l_rva.rvaud07=g_oga.ogaud07
   LET l_rva.rvaud08=g_oga.ogaud08
   LET l_rva.rvaud09=g_oga.ogaud09
   LET l_rva.rvaud10=g_oga.ogaud10
   LET l_rva.rvaud11=g_oga.ogaud11
   LET l_rva.rvaud12=g_oga.ogaud12
   LET l_rva.rvaud13=g_oga.ogaud13
   LET l_rva.rvaud14=g_oga.ogaud14
   LET l_rva.rvaud15=g_oga.ogaud15
 
   #新增收貨單頭
   #LET l_sql="INSERT INTO ",l_dbs_new_tra CLIPPED,"rva_file", #FUN-980092 add
   LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'rva_file'), #FUN-A50102
             "(rva00,rva01  ,rva02  ,rva03  ,rva04  ,rva05  ,",  #FUN-940083 add rva00
             " rva06  ,rva07  ,rva08  ,rva09  ,rva10  ,",
             " rvaprsw,rva20  ,rva21  ,rva22  ,rva23  ,",
             " rva24  ,rva25  ,rva26  ,rva27  ,rva28  ,",
             " rvaconf,rva32  ,rvaprno,rvaacti,rvauser,rvagrup,", #MOD-C50021 add rva32
             " rvamodu,rvadate,rva99,",                      #No.8047
             " rvaplant,rvalegal ,",
             " rvaud01,rvaud02,rvaud03,rvaud04,rvaud05,",
             " rvaud06,rvaud07,rvaud08,rvaud09,rvaud10,",
             " rvaud11,rvaud12,rvaud13,rvaud14,rvaud15,rvaoriu,rvaorig)", #FUN-A10036
             " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
             "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",    #No.CHI-950020 
             "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?, ",   #No.8047 #FUN-940083
             "         ?,?,?,?,?) "      #FUN-980010 #FUN-A10036      #MOD-C50021 add ?
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE ins_rva FROM l_sql
   EXECUTE ins_rva USING 
      l_rva.rva00,                                           #FUN-940083 add
      l_rva.rva01, l_rva.rva02 ,l_rva.rva03,l_rva.rva04,l_rva.rva05,
      l_rva.rva06, l_rva.rva07 ,l_rva.rva08,l_rva.rva09,l_rva.rva10,
      l_rva.rvaprsw,l_rva.rva20,l_rva.rva21,l_rva.rva22,l_rva.rva23,
      l_rva.rva24, l_rva.rva25 ,l_rva.rva26,l_rva.rva27,l_rva.rva28,
      l_rva.rvaconf,l_rva.rva32,l_rva.rvaprno,l_rva.rvaacti,l_rva.rvauser,l_rva.rvagrup,  #MOD-C50021 add rva32
      l_rva.rvamodu,l_rva.rvadate,l_rva.rva99,      #No.8047
      gp_plant,gp_legal   #FUN-980010
     ,l_rva.rvaud01,l_rva.rvaud02,l_rva.rvaud03,l_rva.rvaud04,l_rva.rvaud05,
      l_rva.rvaud06,l_rva.rvaud07,l_rva.rvaud08,l_rva.rvaud09,l_rva.rvaud10,
      l_rva.rvaud11,l_rva.rvaud12,l_rva.rvaud13,l_rva.rvaud14,l_rva.rvaud15,g_user,g_grup #FUN-A10036
 
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
       LET g_showmsg=l_rva.rva01,"/",l_rva.rva05,"/",l_rva.rva06          
       CALL s_errmsg('rva01,rva05,rva06',g_showmsg,'ins rva:',SQLCA.sqlcode,1)
      ELSE 
       CALL cl_err('ins rva:',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
#收貨單身檔
FUNCTION p900_rvbins(p_i)
   DEFINE l_sql,l_sql1,l_sql2       STRING  #MOD-9C0274
   DEFINE p_i        LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_no       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_price    LIKE ogb_file.ogb13
   DEFINE i,l_i      LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_msg      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
   DEFINE l_chr      LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_ima491   LIKE ima_file.ima491
   DEFINE l_ima02    LIKE ima_file.ima02
   DEFINE l_ima25    LIKE ima_file.ima25
  # DEFINE l_qoh      LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_qoh      LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_ima39    LIKE ima_file.ima39
   DEFINE l_ima86    LIKE ima_file.ima86
   DEFINE l_ima35    LIKE ima_file.ima35
   DEFINE l_ima36    LIKE ima_file.ima36
   DEFINE l_rvbi     RECORD LIKE rvbi_file.*  #No.FUN-7B0018
   DEFINE l_flag     LIKE type_file.num5    #MOD-840045 add
   DEFINE l_sma90    LIKE sma_file.sma90  #No.FUN-850100
   DEFINE l_cnt      LIKE type_file.num5  #MOD-970042
   DEFINE l_poy02    LIKE poy_file.poy02  #CHI-970041
   DEFINE l_poy02_1  LIKE poy_file.poy02  #FUN-AA0023
   DEFINE l_idd   RECORD LIKE idd_file.*            #FUN-B90012
   DEFINE l_flag1        LIKE type_file.num10       #FUN-B90012
   #DEFINE l_imaicd08     LIKE imaicd_file.imaicd08  #FUN-B90012 #FUN-BA0051 mark
   DEFINE l_rvbiicd08    LIKE rvbi_file.rvbiicd08   #FUN-B90012
   DEFINE l_rvbiicd16    LIKE rvbi_file.rvbiicd16   #FUN-B90012
   DEFINE l_rvb02        LIKE rvb_file.rvb02  #FUN-C80001
   
   #讀取採購單身檔(pmn_file)
   #LET l_sql1 = "SELECT ",l_dbs_new_tra CLIPPED,"pmn_file.* ",                    
   #             "  FROM ",l_dbs_new_tra CLIPPED,"pmn_file,",
   #                       l_dbs_new_tra CLIPPED,"pmm_file",
   LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'pmn_file'),".* ", #FUN-A50102                    
                "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'),", ",  #FUN-A50102
                          cl_get_target_table(l_plant_new,'pmm_file'),       #FUN-A50102
                " WHERE pmn01 = pmm01",                                       
                "   AND pmm99 ='",g_oea.oea99,"'",                            
                "   AND pmn02 =",g_ogb.ogb32
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092 add
   PREPARE pmn_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
          LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32   
          CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn_p1',SQLCA.SQLCODE,1) 
      ELSE 
          CALL cl_err('pmn_p1',SQLCA.SQLCODE,1) 
      END IF
   END IF
 
   DECLARE pmn_c1 CURSOR FOR pmn_p1
 
   OPEN pmn_c1
   FETCH pmn_c1 INTO g_pmn.*
 
   IF SQLCA.SQLCODE <> 0 THEN
      IF g_bgerr THEN
        LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32   
        CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn_c1',SQLCA.SQLCODE,1) 
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   CLOSE pmn_c1
 
   #新增採購單身檔[pmn_file]
   LET l_rvb.rvb01 = l_rva.rva01      #驗收單身檔
   #FUN-C80001---begin
  #IF g_sma.sma96 = 'Y' THEN   #FUN-D30099 mark
   IF g_pod.pod08 = 'Y' THEN   #FUN-D30099
     #MOD-D30187 mark start -----
     #SELECT MAX(rvb02) INTO l_rvb02
     #  FROM rvb_file
     # WHERE rvb01 = l_rva.rva01
     #MOD-D30187 mark end   -----
     #MOD-D30187 add start -----
      LET l_sql1 = "SELECT MAX(rvb02) ",
                   "  FROM ",cl_get_target_table(l_plant_new,'rvb_file'),
                   " WHERE rvb01 = '", l_rva.rva01 ,"'"
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1 
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
      PREPARE rvb_p2 FROM l_sql1
      DECLARE rvb_c2 CURSOR FOR rvb_p2
      OPEN rvb_c2
      FETCH rvb_c2 INTO l_rvb02
     #MOD-D30187 add end   -----
      IF cl_null(l_rvb02) THEN LET l_rvb02 = 0 END IF 
      LET l_rvb02 = l_rvb02 + 1
      LET l_rvb.rvb02 = l_rvb02
   ELSE  
   #FUN-C80001---end
      LET l_rvb.rvb02 = g_ogb.ogb03      #驗收單項次
   END IF  #FUN-C80001
   LET l_rvb.rvb03 = g_pmn.pmn02      #採購單項次
   LET l_rvb.rvb04 = g_pmn.pmn01      #採購單號
   LET l_rvb.rvb05 = g_ogb.ogb04      #料件編號    No.7742
   LET l_rvb.rvb051= g_ogb.ogb06      #品名規格    #MOD-CC0137 add
   LET l_rvb.rvb06 = 0                #已請款量
   LET l_rvb.rvb07 = g_ogb.ogb12      #實收數量
 
   LET l_rvb.rvb08 = g_ogb.ogb12      #收貨數量
   LET l_rvb.rvb09 = 0                #允請款量
   LET l_rvb.rvb10 = g_pmn.pmn31      #原幣單價 
   LET l_rvb.rvb10t= g_pmn.pmn31t     #NO.FUN-620024
   LET l_rvb.rvb90 = g_pmn.pmn07      #MOD-B30584
   LET l_rvb.rvb07 = s_digqty(l_rvb.rvb07,l_rvb.rvb90) #FUN-BB0083 add
   LET l_rvb.rvb08 = s_digqty(l_rvb.rvb08,l_rvb.rvb90) #FUN-BB0083 add
 
   # 備品時金額、單價應為零
   IF p900_chkoeo(g_ogb.ogb31,g_ogb.ogb32,g_ogb.ogb04) THEN
      LET l_rvb.rvb10 = 0
      LET l_rvb.rvb10t= 0 #NO.FUN-620024 
   END IF
 
   LET l_rvb.rvb11 = 0
   SELECT ima491 INTO l_ima491 FROM ima_file
    WHERE ima01 = l_rvb.rvb05
 
   IF cl_null(l_ima491) THEN 
      LET l_ima491 = 0 
   END IF
 
   IF l_ima491 > 0 THEN
      CALL s_getdate1(g_oga.oga02,l_ima491) RETURNING l_rvb.rvb12
   ELSE
      IF cl_null(l_rvb.rvb12) THEN
         LET l_rvb.rvb12= g_oga.oga02
      END IF
   END IF
 
   LET l_rvb.rvb13 = NULL
   LET l_rvb.rvb14 = NULL
   LET l_rvb.rvb15 = 0
   LET l_rvb.rvb16 = 0 
   LET l_rvb.rvb17 = NULL
   LET l_rvb.rvb18 = '10'
   LET l_rvb.rvb19 = '1'
   LET l_rvb.rvb20 = NULL
   LET l_rvb.rvb21 = NULL
   LET l_rvb.rvb27 = 0 
   LET l_rvb.rvb28 = 0 
   LET l_rvb.rvb29 = 0 
   # 如果有設立中斷點時，只產生收貨單資料，rvb30不應有入庫數量
   IF (g_poz.poz19 = 'Y' AND l_c > 0) THEN    #己設立中斷點
       IF g_poy.poy02 > l_poy02 THEN          #目前站別>中斷點站別時繼續拋轉 
           LET l_rvb.rvb30 = l_rvb.rvb07    
           LET l_rvb.rvb31 = 0  #CHI-7B0041 add
       ELSE
           LET l_rvb.rvb30 = 0            
           LET l_rvb.rvb31 = l_rvb.rvb07  #CHI-7B0041 add
       END IF
   ELSE
       LET l_rvb.rvb30 = l_rvb.rvb07
       LET l_rvb.rvb31 = 0  #CHI-7B0041 add
   END IF
 
   LET l_rvb.rvb35 = 'N'
 
   CALL p900_ima(l_rvb.rvb05)
     RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,
               l_ima35,l_ima36           
   LET l_rvb.rvb38 = ' '
   IF NOT cl_null(p_imd01) THEN
      CALL p900_imd(p_imd01,l_plant_new) #FUN-980092 add
      LET l_rvb.rvb36 = p_imd01
      LET l_rvb.rvb37 = ' '
      LET l_rvb.rvb38 = ' '
   ELSE
      IF NOT cl_null(l_ima35) THEN
         LET l_rvb.rvb36 = l_ima35
         LET l_rvb.rvb37 = l_ima36
         LET l_rvb.rvb38 = ' '
         LET p_imd01 = l_ima35              #MOD-C80071 add
         CALL p900_imd(p_imd01,l_plant_new) #MOD-C80071 add
      ELSE
         LET l_rvb.rvb36 = g_ogb.ogb09
         LET l_rvb.rvb37 = g_ogb.ogb091
         LET l_rvb.rvb38 = g_ogb.ogb092
         LET p_imd01 = g_ogb.ogb09          #MOD-C80071 add
         CALL p900_imd(p_imd01,l_plant_new) #MOD-C80071 add
      END IF
   END IF
  #IF g_sma.sma96 = 'Y' THEN    #FUN-C80001 #FUN-D30099 mark
   IF g_pod.pod08 = 'Y' THEN   #FUN-D30099
      LET l_rvb.rvb38 = g_ogb.ogb092  #FUN-C80001
   END IF                             #FUN-C80001
#FUN-AA0023--add--str--
   IF g_prog='artt256' OR g_prog='artt255' THEN
      SELECT MIN(poy02) INTO l_poy02_1 FROM poz_file,poy_file
       WHERE poz01 = g_poz.poz01 AND poz01 = poy01
      IF g_poy.poy02 = l_poy02_1 THEN
         LET l_rvb.rvb36 = g_pmn.pmn52
         LET l_rvb.rvb37 = g_pmn.pmn54
         LET l_rvb.rvb38 = g_pmn.pmn56
      END IF
   END IF
#FUN-AA0023--add--end--
 
   IF l_rvb.rvb37 IS NULL THEN LET l_rvb.rvb37=' ' END IF   #No.+196
 
  #=====================================================
  #收料單位與倉庫的庫存單位轉換率的計算
   #IF cl_null(l_ogb.ogb15_fac) THEN      #代採逆拋時,二站沒有拋出貨單,就需進來計算 ##MOD-860040 ogb05->ogb15   #MOD-A40042
      
      LET g_ogb.ogb15 = l_ima25			
         IF g_pmn.pmn07 = g_ogb.ogb15 THEN  #MOD-860040 modify l_ogb.ogb15 ->g_ogb.ogb15
              LET l_ogb.ogb15_fac =1    #MOD-860040
         ELSE
              #檢查該銷售單位與倉庫的庫存單位是否可以轉換
              CALL s_umfchkm(l_rvb.rvb05,g_pmn.pmn07,g_ogb.ogb15,l_plant_new) #MOD-9C0210
                   RETURNING l_flag,l_ogb.ogb15_fac  #MOD-860040
              IF l_flag THEN
                 LET g_msg=l_dbs_new CLIPPED,' ',l_rvb.rvb05
                 CALL cl_err(g_msg,'mfg3075',1)
                 LET g_success = 'N'
              END IF 
         END IF
     IF cl_null(l_ogb.ogb15_fac) THEN LET l_ogb.ogb15_fac=1 END IF  #MOD-860040 
   #END IF   #MOD-A40042
   #=====================================================
   #銷售單位/庫存單位轉換率
   CALL s_umfchkm(l_rvb.rvb05,g_pmn.pmn07,l_ima25,l_plant_new)  #MOD-9C0210
        RETURNING l_flag,l_ogb.ogb05_fac
   IF l_flag THEN
      LET g_msg=l_dbs_new CLIPPED,' ',l_rvb.rvb05
      CALL cl_err(g_msg,'mfg3075',1)
      LET g_success = 'N'
   END IF 
   IF cl_null(l_ogb.ogb05_fac) THEN LET l_ogb.ogb05_fac=1 END IF
   SELECT poy02 INTO l_poy02
     FROM poz_file,poy_file
    WHERE poz01 = g_poz.poz01 
      AND poz01 = poy01 AND poz18 = poy04 
 
   IF p_i <> l_poy02 THEN
      LET l_rvb.rvb39 = 'N'   #免驗
      LET l_rvb.rvb33 = l_rvb.rvb07    #MOD-930235
   ELSE 
      CALL p900_get_rvb39(g_pmn.pmn02,g_pmn.pmn01,g_ogb.ogb04,l_rvb.rvb19,p_pmm09,g_sma.sma886)  
           RETURNING l_rvb.rvb39 
      LET l_rvb.rvb33 = 0 
   END IF
   LET l_rvb.rvb40 = NULL
   LET l_rvb.rvb41 = NULL
   LET l_rvb.rvb80 = g_ogb.ogb910
   LET l_rvb.rvb81 = g_ogb.ogb911
   LET l_rvb.rvb82 = g_ogb.ogb912
   LET l_rvb.rvb83 = g_ogb.ogb913
   LET l_rvb.rvb84 = g_ogb.ogb914
   LET l_rvb.rvb85 = g_ogb.ogb915
   LET l_rvb.rvb86 = g_ogb.ogb916
   LET l_rvb.rvb87 = g_ogb.ogb917
   LET l_rvb.rvbud01 = g_ogb.ogbud01
   LET l_rvb.rvbud02 = g_ogb.ogbud02
   LET l_rvb.rvbud03 = g_ogb.ogbud03
   LET l_rvb.rvbud04 = g_ogb.ogbud04
   LET l_rvb.rvbud05 = g_ogb.ogbud05
   LET l_rvb.rvbud06 = g_ogb.ogbud06
   LET l_rvb.rvbud07 = g_ogb.ogbud07
   LET l_rvb.rvbud08 = g_ogb.ogbud08
   LET l_rvb.rvbud09 = g_ogb.ogbud09
   LET l_rvb.rvbud10 = g_ogb.ogbud10
   LET l_rvb.rvbud11 = g_ogb.ogbud11
   LET l_rvb.rvbud12 = g_ogb.ogbud12
   LET l_rvb.rvbud13 = g_ogb.ogbud13
   LET l_rvb.rvbud14 = g_ogb.ogbud14
   LET l_rvb.rvbud15 = g_ogb.ogbud15
 
   LET l_rvb.rvb88=l_rvb.rvb87*l_rvb.rvb10  #TQC-D40075 mark #MOD-DA0106 remark
   LET l_rvb.rvb88t=l_rvb.rvb87*l_rvb.rvb10t #TQC-D40075 mark #MOD-DA0106 remark
   #LET l_rvb.rvb88 = g_ogb.ogb14  #TQC-D40075 add
   #LET l_rvb.rvb88t = g_ogb.ogb14t #TQC-D40075 add

   #MOD-C80064 add start -----
   LET l_sql = "SELECT azi04 FROM ",cl_get_target_table(l_plant_new,'azi_file'),
               " WHERE azi01='",g_pmm.pmm22,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
   PREPARE azi_rvb88 FROM l_sql
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN   
        CALL s_errmsg('azi01',g_pmm.pmm22,'azi_rvb88',SQLCA.SQLCODE,0)
      ELSE
        CALL cl_err('azi_rvb88',SQLCA.SQLCODE,1)
      END IF
   END IF
   DECLARE azi_c_rvb88 CURSOR FOR azi_rvb88
   OPEN azi_c_rvb88
   FETCH azi_c_rvb88 INTO t_azi04 
   CLOSE azi_c_rvb88
      
   CALL cl_digcut(l_rvb.rvb88,t_azi04) RETURNING l_rvb.rvb88
   CALL cl_digcut(l_rvb.rvb88t,t_azi04) RETURNING l_rvb.rvb88t
   #MOD-C80064 add end   -----
 
   LET l_rvb.rvb930 = g_pmn.pmn930  #MOD-920261 add
   LET l_rvb.rvb89 = 'N'            #FUN-940083 add
   #新增收貨單身檔
   #LET l_sql2="INSERT INTO ",l_dbs_new_tra CLIPPED,"rvb_file", #FUN-980092 add
   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
              "(rvb01,rvb02,rvb03,rvb04,rvb05,rvb051, ",   #MOD-CC0137 add rvb051,
              " rvb06,rvb07,rvb08,rvb09,rvb10, ",
              " rvb11,rvb12,rvb13,rvb14,rvb15, ",
              " rvb16,rvb17,rvb18,rvb19,rvb20, ",
              " rvb21,rvb22,rvb25,rvb26,rvb27, ",
              " rvb28,rvb29,rvb30,rvb31,rvb32, ",
              " rvb33,rvb34,rvb35,rvb36,rvb37, ",
              " rvb38,rvb39,rvb40,rvb41,rvb80, ",
              " rvb81,rvb82,rvb83,rvb84,rvb85, ",
              " rvb86,rvb87,rvb10t,rvb88,rvb88t,rvb930,rvb89,",  #NO.FUN-620024   #No.TQC-6A0084  #MOD-920261 add rvb930 #FUN-940083 add rvb89
              " rvbplant,rvblegal,",
              " rvbud01,rvbud02,rvbud03,rvbud04,rvbud05,",
              " rvbud06,rvbud07,rvbud08,rvbud09,rvbud10,",
              " rvbud11,rvbud12,rvbud13,rvbud14,rvbud15,rvb90)",  #MOD-B30584 add rvb90
              " VALUES( ?,?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,", #MOD-CC0137 add ?,
              "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,?,", #NO.FUN-620024
              "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?, ?,?,?,",  #No.CHI-950020
              "         ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?, ", #No.TQC-6A0084  #MOD-920261 add ? #FUN-940083 
              "         ?,?,?) "  #FUN-980010  #MOD-B30584 add ?
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ins_rvb FROM l_sql2
 
   EXECUTE ins_rvb USING 
      l_rvb.rvb01,l_rvb.rvb02,l_rvb.rvb03,l_rvb.rvb04,l_rvb.rvb05,l_rvb.rvb051,   #MOD-CC0137 add l_rvb.rvb051,
      l_rvb.rvb06,l_rvb.rvb07,l_rvb.rvb08,l_rvb.rvb09,l_rvb.rvb10,
      l_rvb.rvb11,l_rvb.rvb12,l_rvb.rvb13,l_rvb.rvb14,l_rvb.rvb15,
      l_rvb.rvb16,l_rvb.rvb17,l_rvb.rvb18,l_rvb.rvb19,l_rvb.rvb20,
      l_rvb.rvb21,l_rvb.rvb22,l_rvb.rvb25,l_rvb.rvb26,l_rvb.rvb27,
      l_rvb.rvb28,l_rvb.rvb29,l_rvb.rvb30,l_rvb.rvb31,l_rvb.rvb32,
      l_rvb.rvb33,l_rvb.rvb34,l_rvb.rvb35,l_rvb.rvb36,l_rvb.rvb37,
      l_rvb.rvb38,l_rvb.rvb39,l_rvb.rvb40,l_rvb.rvb41,l_rvb.rvb80,
      l_rvb.rvb81,l_rvb.rvb82,l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,
      l_rvb.rvb86,l_rvb.rvb87,l_rvb.rvb10t,  #NO.FUN-620024
      l_rvb.rvb88,l_rvb.rvb88t,l_rvb.rvb930, #No.TQC-6A0084  #MOD-920261 add rvb930
      l_rvb.rvb89,                           #FUN-940083 add rvb89
      gp_plant,gp_legal   #FUN-980010
     ,l_rvb.rvbud01,l_rvb.rvbud02,l_rvb.rvbud03,l_rvb.rvbud04,l_rvb.rvbud05,
      l_rvb.rvbud06,l_rvb.rvbud07,l_rvb.rvbud08,l_rvb.rvbud09,l_rvb.rvbud10,
      l_rvb.rvbud11,l_rvb.rvbud12,l_rvb.rvbud13,l_rvb.rvbud14,l_rvb.rvbud15,l_rvb.rvb90 #MOD-B30584 add rvb90
 
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
        LET g_showmsg=l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb03,"/",
                      l_rvb.rvb04,"/",l_rvb.rvb05
        CALL s_errmsg('rvb01,rvb02,rvb03,rvb04,rvb05',g_showmsg,'ins rvb:',SQLCA.sqlcode,1) 
      ELSE
        CALL cl_err('ins rvb:',SQLCA.sqlcode,1)  
      END IF
      LET g_success = 'N'
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_rvbi.* TO NULL
         LET l_rvbi.rvbi01 = l_rvb.rvb01
         LET l_rvbi.rvbi02 = l_rvb.rvb02
         IF NOT s_ins_rvbi(l_rvbi.*,l_plant_new) THEN #FUN-980092 add
            LET g_success = 'N'
         END IF
      END IF
   END IF
 
   #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_new CLIPPED,"ima_file",
   LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                " WHERE ima01 = '",l_rvb.rvb05,"'",
                "   AND imaacti = 'Y'"
 
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ima_rvb FROM l_sql2
 
   EXECUTE ima_rvb INTO g_ima918,g_ima921                                                                             
     
   #LET l_sql2 = "SELECT sma90 FROM ",l_dbs_new CLIPPED,"sma_file",
   LET l_sql2 = "SELECT sma90 FROM ",cl_get_target_table(l_plant_new,'sma_file'), #FUN-A50102
                " WHERE sma00 = '0'"
   
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE sma_rvb FROM l_sql2
   
   EXECUTE sma_rvb INTO l_sma90
     
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      IF l_sma90 = "Y" THEN
      
         LET l_cnt = 0					#MOD-970042
         FOREACH p900_g_rvbs INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
 
            LET l_rvbs.rvbs00 = "apmt300"
         
            LET l_rvbs.rvbs01 = l_rvb.rvb01
         
            LET l_cnt = l_cnt + 1 			#MOD-970042
            LET l_rvbs.rvbs022 = l_cnt 	 	        #MOD-970042
 
           #由於 g_ogb.ogb15 與 l_ima25 一致,故無須計算 rvbs06
      
            IF cl_null(l_rvbs.rvbs06) THEN
               LET l_rvbs.rvbs06 = 0
            END IF
 
            LET l_rvbs.rvbs09 = 1
            LET l_rvbs.rvbs13 = 0    #TQC-950001
 
            #新增批/序號資料檔
            EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                   l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                   l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                   l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09, 
                                   l_rvbs.rvbs13,  #TQC-950001 
                                   gp_plant,gp_legal   #FUN-980010
      
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
               CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF
         
           #CALL p900_imgs(l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rva.rva06,l_rvbs.*)	#MOD-980058   #No.FUN-A10099
            CALL p900_imgs(l_plant_new,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rva.rva06,l_rvbs.*)      #No.FUN-A10099
 
         END FOREACH
      END IF
   END IF

#FUN-B90012 ------------------------Begin------------------------
   IF s_industry('icd') THEN 
      #FUN-BA0051 --START mark--
      #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",
      #                                     cl_get_target_table(l_plant_new,'ima_file'),
      #             " WHERE imaicd00 = '",l_rvb.rvb05,"'",
      #             "   AND ima01 = imaicd00 ",
      #             "   AND imaacti = 'Y'"
      #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
      #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
      #PREPARE p900_rvb_imaicd08 FROM l_sql2
      #EXECUTE p900_rvb_imaicd08 INTO l_imaicd08 
      #IF l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
      IF s_icdbin_multi(l_rvb.rvb05,l_plant_new) THEN   #FUN-BA0051
         FOREACH p900_g_idd INTO l_idd.*
            LET l_idd.idd10 = l_rvb.rvb01
            LET l_idd.idd11 = l_rvb.rvb02
            LET l_idd.idd02 = l_rvb.rvb36    #CHI-BB0031
            LET l_idd.idd03 = l_rvb.rvb37    #CHI-BB0031
            LET l_idd.idd04 = l_rvb.rvb38    #CHI-BB0031
            CALL icd_ida(1,l_idd.*,l_plant_new) 
         END FOREACH
      END IF
      LET l_sql1 = "SELECT rvbiicd08,rvbiicd16 FROM ",cl_get_target_table(l_plant_new,'rvbi_file'),
                   " WHERE rvbi01 = '",l_rvb.rvb01,"'",
                   "   AND rvbi02 =  ",l_rvb.rvb02
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
      PREPARE p900_rvbi FROM l_sql1
      EXECUTE p900_rvbi INTO l_rvbiicd08,l_rvbiicd16
      CALL s_icdpost(13,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,g_pmn.pmn07,l_rvb.rvb07,l_rvb.rvb01,l_rvb.rvb02,
                     l_rva.rva06,'Y','','',l_rvbiicd16,l_rvbiicd08,l_plant_new)
           RETURNING l_flag1
      IF l_flag1 = 0 THEN
         LET g_success = 'N'
      END IF   
   END IF
#FUN-B90012 ------------------------End--------------------------
 
END FUNCTION
#FUN-C80001---begin
FUNCTION p900_rvbins1(p_i,p_rvv_flag)
   DEFINE l_sql,l_sql1,l_sql2       STRING  
   DEFINE p_i        LIKE type_file.num5  
   DEFINE p_rvv_flag LIKE type_file.chr1
   DEFINE l_no       LIKE type_file.num5   
   DEFINE l_price    LIKE ogb_file.ogb13
   DEFINE i,l_i      LIKE type_file.num5    
   DEFINE l_msg      LIKE type_file.chr1000 
   DEFINE l_chr      LIKE type_file.chr1   
   DEFINE l_ima491   LIKE ima_file.ima491
   DEFINE l_ima02    LIKE ima_file.ima02
   DEFINE l_ima25    LIKE ima_file.ima25
   DEFINE l_qoh      LIKE type_file.num15_3 
   DEFINE l_ima39    LIKE ima_file.ima39
   DEFINE l_ima86    LIKE ima_file.ima86
   DEFINE l_ima35    LIKE ima_file.ima35
   DEFINE l_ima36    LIKE ima_file.ima36
   DEFINE l_rvbi     RECORD LIKE rvbi_file.*  
   DEFINE l_flag     LIKE type_file.num5    
   DEFINE l_sma90    LIKE sma_file.sma90  
   DEFINE l_cnt      LIKE type_file.num5  
   DEFINE l_poy02    LIKE poy_file.poy02 
   DEFINE l_poy02_1  LIKE poy_file.poy02  
   DEFINE l_idd   RECORD LIKE idd_file.*            
   DEFINE l_flag1        LIKE type_file.num10       
   DEFINE l_rvbiicd08    LIKE rvbi_file.rvbiicd08   
   DEFINE l_rvbiicd16    LIKE rvbi_file.rvbiicd16  
   DEFINE l_rvb02        LIKE rvb_file.rvb02
   DEFINE l_ogc   RECORD 
                  ogc09  LIKE ogc_file.ogc09,
                  ogc091 LIKE ogc_file.ogc091,
                  ogc092 LIKE ogc_file.ogc092,
                  ogc12  LIKE ogc_file.ogc12
                  END RECORD

   IF tm.oga09 = '6' THEN #為代採買
      IF g_sma.sma115 = 'Y' THEN
         LET l_sql1 = " SELECT '','',ogg092,SUM(ogg12) FROM ogg_file ",
                     "  WHERE ogg01 = '",g_oga.oga01,"'",
                     "    AND ogg03 = '",g_ogb.ogb03,"'",
                     "    AND ogg20 = 1 ",
                     "  GROUP BY ogg092 "
      ELSE
         LET l_sql1 = " SELECT '','',ogc092,SUM(ogc12) FROM ogc_file ",
                        "  WHERE ogc01 = '",g_oga.oga01,"'",
                        "    AND ogc03 = '",g_ogb.ogb03,"'",
                        "  GROUP BY ogc092 "
      END IF
   ELSE
      IF g_sma.sma115 = 'Y' THEN
         LET l_sql1 = " SELECT ogg09,ogg091,ogg092,ogg12 ",
                      "FROM ",cl_get_target_table(l_plant_new,'ogg_file'),
                      "  WHERE ogg01 = '",l_oga.oga01,"'",
                      "    AND ogg03 = '",l_ogb.ogb03,"'",
                      "    AND ogg20 = 1 "
      ELSE 
         LET l_sql1 = " SELECT ogc09,ogc091,ogc092,ogc12 ",
                      " FROM ",cl_get_target_table(l_plant_new,'ogc_file'),
                      "  WHERE ogc01 = '",l_oga.oga01,"'",
                      "    AND ogc03 = '",l_ogb.ogb03,"'"
      END IF 
   END IF
   DECLARE p900_ogc_c1 CURSOR FROM l_sql1
   
   #讀取採購單身檔(pmn_file)
   LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'pmn_file'),".* ",                    
                "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'),", ",  
                          cl_get_target_table(l_plant_new,'pmm_file'),       
                " WHERE pmn01 = pmm01",                                       
                "   AND pmm99 ='",g_oea.oea99,"'",                            
                "   AND pmn02 =",g_ogb.ogb32
   
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1       
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 
   PREPARE pmn_p2 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
         LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32   
         CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn_p1',SQLCA.SQLCODE,1) 
     ELSE 
         CALL cl_err('pmn_p1',SQLCA.SQLCODE,1) 
     END IF
   END IF
 
   DECLARE pmn_c2 CURSOR FOR pmn_p2
 
   OPEN pmn_c2
   FETCH pmn_c2 INTO g_pmn.*
 
   IF SQLCA.SQLCODE <> 0 THEN
      IF g_bgerr THEN
        LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32   
        CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn_c1',SQLCA.SQLCODE,1) 
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   CLOSE pmn_c1

   LET l_sql2 = "SELECT sma90 FROM ",cl_get_target_table(l_plant_new,'sma_file'), 
                " WHERE sma00 = '0'"
   
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
   PREPARE sma_rvb1 FROM l_sql2
   
   EXECUTE sma_rvb1 INTO l_sma90
      
  #MOD-D40101 mark start -----
  #SELECT MAX(rvb02) INTO l_rvb02
  #  FROM rvb_file
  # WHERE rvb01 = l_rva.rva01
  #MOD-D40101 mark end   -----
  #MOD-D40101 add start -----
   LET l_sql1 = "SELECT MAX(rvb02) ",
                "  FROM ",cl_get_target_table(l_plant_new,'rvb_file'),
                " WHERE rvb01 = '", l_rva.rva01 ,"'"
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1 
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
   PREPARE rvb_p3 FROM l_sql1
   DECLARE rvb_c3 CURSOR FOR rvb_p3
   OPEN rvb_c3
   FETCH rvb_c3 INTO l_rvb02
  #MOD-D40101 add end   -----
   IF cl_null(l_rvb02) THEN LET l_rvb02 = 0 END IF 
   FOREACH p900_ogc_c1 INTO l_ogc.*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('ogc_c1',SQLCA.SQLCODE,1) 
      END IF
   #新增採購單身檔[pmn_file]
      LET l_rvb.rvb01 = l_rva.rva01      #驗收單身檔
      LET l_rvb02 = l_rvb02 + 1
      LET l_rvb.rvb02 = l_rvb02          #驗收單項次
      LET l_rvb.rvb03 = g_pmn.pmn02      #採購單項次
      LET l_rvb.rvb04 = g_pmn.pmn01      #採購單號
      LET l_rvb.rvb05 = g_ogb.ogb04      #料件編號    
      LET l_rvb.rvb06 = 0                #已請款量
      LET l_rvb.rvb07 = l_ogc.ogc12      #實收數量
      LET l_rvb.rvb08 = l_ogc.ogc12      #收貨數量
      LET l_rvb.rvb09 = 0                #允請款量
      LET l_rvb.rvb10 = g_pmn.pmn31      #原幣單價 
      LET l_rvb.rvb10t= g_pmn.pmn31t    
      LET l_rvb.rvb90 = g_pmn.pmn07      
      LET l_rvb.rvb07 = s_digqty(l_rvb.rvb07,l_rvb.rvb90) 
      LET l_rvb.rvb08 = s_digqty(l_rvb.rvb08,l_rvb.rvb90) 
 
      # 備品時金額、單價應為零
      IF p900_chkoeo(g_ogb.ogb31,g_ogb.ogb32,g_ogb.ogb04) THEN
         LET l_rvb.rvb10 = 0
         LET l_rvb.rvb10t= 0 #NO.FUN-620024 
      END IF
 
      LET l_rvb.rvb11 = 0
      SELECT ima491 INTO l_ima491 FROM ima_file
       WHERE ima01 = l_rvb.rvb05
 
      IF cl_null(l_ima491) THEN 
         LET l_ima491 = 0 
      END IF
 
      IF l_ima491 > 0 THEN
         CALL s_getdate1(g_oga.oga02,l_ima491) RETURNING l_rvb.rvb12
      ELSE
         IF cl_null(l_rvb.rvb12) THEN
            LET l_rvb.rvb12= g_oga.oga02
         END IF
      END IF
 
      LET l_rvb.rvb13 = NULL
      LET l_rvb.rvb14 = NULL
      LET l_rvb.rvb15 = 0
      LET l_rvb.rvb16 = 0 
      LET l_rvb.rvb17 = NULL
      LET l_rvb.rvb18 = '10'
      LET l_rvb.rvb19 = '1'
      LET l_rvb.rvb20 = NULL
      LET l_rvb.rvb21 = NULL
      LET l_rvb.rvb27 = 0 
      LET l_rvb.rvb28 = 0 
      LET l_rvb.rvb29 = 0 
      # 如果有設立中斷點時，只產生收貨單資料，rvb30不應有入庫數量
      IF (g_poz.poz19 = 'Y' AND l_c > 0) THEN    #己設立中斷點
         IF g_poy.poy02 > l_poy02 THEN          #目前站別>中斷點站別時繼續拋轉 
            LET l_rvb.rvb30 = l_rvb.rvb07    
            LET l_rvb.rvb31 = 0 
         ELSE
            LET l_rvb.rvb30 = 0            
            LET l_rvb.rvb31 = l_rvb.rvb07  
         END IF
      ELSE
         LET l_rvb.rvb30 = l_rvb.rvb07
         LET l_rvb.rvb31 = 0  
      END IF
 
      LET l_rvb.rvb35 = 'N'
 
      CALL p900_ima(l_rvb.rvb05)
        RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,
                  l_ima35,l_ima36           
      #LET l_rvb.rvb38 = ' '
      IF NOT cl_null(p_imd01) THEN
         CALL p900_imd(p_imd01,l_plant_new) 
         LET l_rvb.rvb36 = p_imd01
         LET l_rvb.rvb37 = ' '
         #LET l_rvb.rvb38 = ' '
      ELSE
         IF NOT cl_null(l_ima35) THEN
            LET l_rvb.rvb36 = l_ima35
            LET l_rvb.rvb37 = l_ima36
            LET p_imd01 = l_ima35              #MOD-C80071 add
            CALL p900_imd(p_imd01,l_plant_new) #MOD-C80071 add
         ELSE
            LET l_rvb.rvb36 = l_ogc.ogc09
            LET l_rvb.rvb37 = l_ogc.ogc091
            LET p_imd01 = g_ogb.ogb09          #MOD-C80071 add
            CALL p900_imd(p_imd01,l_plant_new) #MOD-C80071 add
         END IF
      END IF
       IF cl_null(l_rvb.rvb37) THEN LET l_rvb.rvb37 = ' ' END IF
       LET l_rvb.rvb38 = l_ogc.ogc092

      IF g_prog='artt256' OR g_prog='artt255' THEN
         SELECT MIN(poy02) INTO l_poy02_1 FROM poz_file,poy_file
          WHERE poz01 = g_poz.poz01 AND poz01 = poy01
         IF g_poy.poy02 = l_poy02_1 THEN
            LET l_rvb.rvb36 = g_pmn.pmn52
            LET l_rvb.rvb37 = g_pmn.pmn54
            LET l_rvb.rvb38 = g_pmn.pmn56
         END IF
      END IF

      IF l_rvb.rvb37 IS NULL THEN LET l_rvb.rvb37=' ' END IF   
 
     #收料單位與倉庫的庫存單位轉換率的計算
      LET g_ogb.ogb15 = l_ima25			
      IF g_pmn.pmn07 = g_ogb.ogb15 THEN  
         LET l_ogb.ogb15_fac =1   
      ELSE
         #檢查該銷售單位與倉庫的庫存單位是否可以轉換
         CALL s_umfchkm(l_rvb.rvb05,g_pmn.pmn07,g_ogb.ogb15,l_plant_new)
              RETURNING l_flag,l_ogb.ogb15_fac  
         IF l_flag THEN
            LET g_msg=l_dbs_new CLIPPED,' ',l_rvb.rvb05
            CALL cl_err(g_msg,'mfg3075',1)
            LET g_success = 'N'
         END IF 
      END IF
      IF cl_null(l_ogb.ogb15_fac) THEN LET l_ogb.ogb15_fac=1 END IF  

      #銷售單位/庫存單位轉換率
      CALL s_umfchkm(l_rvb.rvb05,g_pmn.pmn07,l_ima25,l_plant_new)  
           RETURNING l_flag,l_ogb.ogb05_fac
      IF l_flag THEN
         LET g_msg=l_dbs_new CLIPPED,' ',l_rvb.rvb05
         CALL cl_err(g_msg,'mfg3075',1)
         LET g_success = 'N'
      END IF 
      IF cl_null(l_ogb.ogb05_fac) THEN LET l_ogb.ogb05_fac=1 END IF
      SELECT poy02 INTO l_poy02
        FROM poz_file,poy_file
       WHERE poz01 = g_poz.poz01 
         AND poz01 = poy01 AND poz18 = poy04 
 
      IF p_i <> l_poy02 THEN
         LET l_rvb.rvb39 = 'N'   #免驗
         LET l_rvb.rvb33 = l_rvb.rvb07    
      ELSE 
         CALL p900_get_rvb39(g_pmn.pmn02,g_pmn.pmn01,g_ogb.ogb04,l_rvb.rvb19,p_pmm09,g_sma.sma886)  
              RETURNING l_rvb.rvb39 
         LET l_rvb.rvb33 = 0 
      END IF
      LET l_rvb.rvb40 = NULL
      LET l_rvb.rvb41 = NULL
      IF g_sma.sma115 = 'Y' THEN
         LET l_rvb.rvb80 = g_ogb.ogb910 
         LET l_rvb.rvb81 = g_ogb.ogb911 
         LET l_rvb.rvb82 = l_ogc.ogc12 
         LET l_rvb.rvb83 = NULL  
         LET l_rvb.rvb84 = NULL
         LET l_rvb.rvb85 = NULL
         SELECT ogg15,ogg15_fac,SUM(ogg12)
           INTO l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85
           FROM ogg_file
          WHERE ogg01 = g_oga.oga01
            AND ogg03 = g_ogb.ogb03
            AND ogg20 = 2
            AND ogg092 = l_ogc.ogc092
          GROUP BY ogg092,ogg15,ogg15_fac
          IF g_ima906 = '2' THEN
             CALL s_umfchk(l_rvb.rvb05,l_rvb.rvb83,l_ogb.ogb15) 
                  RETURNING l_flag,l_rvb.rvb84
          END IF 
      ELSE 
         LET l_rvb.rvb80 = g_ogb.ogb910 
         LET l_rvb.rvb81 = g_ogb.ogb911 
         LET l_rvb.rvb82 = l_ogc.ogc12 
         LET l_rvb.rvb83 = g_ogb.ogb913 
         LET l_rvb.rvb84 = g_ogb.ogb914 
         LET l_rvb.rvb85 = g_ogb.ogb915 
      END IF 
      LET l_rvb.rvb86 = g_ogb.ogb916
      IF g_ima906 = '2' THEN
         LET l_rvb.rvb87 = l_ogc.ogc12 + (l_rvb.rvb85*l_rvb.rvb84)
         LET l_rvb.rvb07 = l_ogc.ogc12 + (l_rvb.rvb85*l_rvb.rvb84)
         LET l_rvb.rvb08 = l_ogc.ogc12 + (l_rvb.rvb85*l_rvb.rvb84)
         LET l_rvb.rvb07 = s_digqty(l_rvb.rvb07,l_rvb.rvb90) 
         LET l_rvb.rvb08 = s_digqty(l_rvb.rvb08,l_rvb.rvb90) 
         LET l_rvb.rvb30 = l_rvb.rvb07
      ELSE 
         LET l_rvb.rvb87 = l_ogc.ogc12  
      END IF  
      LET l_rvb.rvbud01 = g_ogb.ogbud01
      LET l_rvb.rvbud02 = g_ogb.ogbud02
      LET l_rvb.rvbud03 = g_ogb.ogbud03
      LET l_rvb.rvbud04 = g_ogb.ogbud04
      LET l_rvb.rvbud05 = g_ogb.ogbud05
      LET l_rvb.rvbud06 = g_ogb.ogbud06
      LET l_rvb.rvbud07 = g_ogb.ogbud07
      LET l_rvb.rvbud08 = g_ogb.ogbud08
      LET l_rvb.rvbud09 = g_ogb.ogbud09
      LET l_rvb.rvbud10 = g_ogb.ogbud10
      LET l_rvb.rvbud11 = g_ogb.ogbud11
      LET l_rvb.rvbud12 = g_ogb.ogbud12
      LET l_rvb.rvbud13 = g_ogb.ogbud13
      LET l_rvb.rvbud14 = g_ogb.ogbud14
      LET l_rvb.rvbud15 = g_ogb.ogbud15

      LET l_rvb.rvb88=l_rvb.rvb87*l_rvb.rvb10
      LET l_rvb.rvb88t=l_rvb.rvb87*l_rvb.rvb10t
 
      LET l_rvb.rvb930 = g_pmn.pmn930  
      LET l_rvb.rvb89 = 'N'            
   #新增收貨單身檔
      LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'rvb_file'), 
                 "(rvb01,rvb02,rvb03,rvb04,rvb05, ",
                 " rvb06,rvb07,rvb08,rvb09,rvb10, ",
                 " rvb11,rvb12,rvb13,rvb14,rvb15, ",
                 " rvb16,rvb17,rvb18,rvb19,rvb20, ",
                 " rvb21,rvb22,rvb25,rvb26,rvb27, ",
                 " rvb28,rvb29,rvb30,rvb31,rvb32, ",
                 " rvb33,rvb34,rvb35,rvb36,rvb37, ",
                 " rvb38,rvb39,rvb40,rvb41,rvb80, ",
                 " rvb81,rvb82,rvb83,rvb84,rvb85, ",
                 " rvb86,rvb87,rvb10t,rvb88,rvb88t,rvb930,rvb89,", 
                 " rvbplant,rvblegal,",
                 " rvbud01,rvbud02,rvbud03,rvbud04,rvbud05,",
                 " rvbud06,rvbud07,rvbud08,rvbud09,rvbud10,",
                 " rvbud11,rvbud12,rvbud13,rvbud14,rvbud15,rvb90)", 
                 " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
                 "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,?,",
                 "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?, ?,?,?,", 
                 "         ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?, ", 
                 "         ?,?,?) "  
 
 	  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2       
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
      PREPARE ins_rvb1 FROM l_sql2
 
      EXECUTE ins_rvb1 USING 
         l_rvb.rvb01,l_rvb.rvb02,l_rvb.rvb03,l_rvb.rvb04,l_rvb.rvb05,
         l_rvb.rvb06,l_rvb.rvb07,l_rvb.rvb08,l_rvb.rvb09,l_rvb.rvb10,
         l_rvb.rvb11,l_rvb.rvb12,l_rvb.rvb13,l_rvb.rvb14,l_rvb.rvb15,
         l_rvb.rvb16,l_rvb.rvb17,l_rvb.rvb18,l_rvb.rvb19,l_rvb.rvb20,
         l_rvb.rvb21,l_rvb.rvb22,l_rvb.rvb25,l_rvb.rvb26,l_rvb.rvb27,
         l_rvb.rvb28,l_rvb.rvb29,l_rvb.rvb30,l_rvb.rvb31,l_rvb.rvb32,
         l_rvb.rvb33,l_rvb.rvb34,l_rvb.rvb35,l_rvb.rvb36,l_rvb.rvb37,
         l_rvb.rvb38,l_rvb.rvb39,l_rvb.rvb40,l_rvb.rvb41,l_rvb.rvb80,
         l_rvb.rvb81,l_rvb.rvb82,l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,
         l_rvb.rvb86,l_rvb.rvb87,l_rvb.rvb10t,  
         l_rvb.rvb88,l_rvb.rvb88t,l_rvb.rvb930, 
         l_rvb.rvb89,gp_plant,gp_legal   
        ,l_rvb.rvbud01,l_rvb.rvbud02,l_rvb.rvbud03,l_rvb.rvbud04,l_rvb.rvbud05,
         l_rvb.rvbud06,l_rvb.rvbud07,l_rvb.rvbud08,l_rvb.rvbud09,l_rvb.rvbud10,
         l_rvb.rvbud11,l_rvb.rvbud12,l_rvb.rvbud13,l_rvb.rvbud14,l_rvb.rvbud15,l_rvb.rvb90 #MOD-B30584 add rvb90
 
      IF SQLCA.sqlcode<>0 THEN
         IF g_bgerr THEN
            LET g_showmsg=l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb03,"/",
                          l_rvb.rvb04,"/",l_rvb.rvb05
            CALL s_errmsg('rvb01,rvb02,rvb03,rvb04,rvb05',g_showmsg,'ins rvb:',SQLCA.sqlcode,1) 
         ELSE
            CALL cl_err('ins rvb:',SQLCA.sqlcode,1)  
         END IF
         LET g_success = 'N'
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_rvbi.* TO NULL
            LET l_rvbi.rvbi01 = l_rvb.rvb01
            LET l_rvbi.rvbi02 = l_rvb.rvb02
            IF NOT s_ins_rvbi(l_rvbi.*,l_plant_new) THEN 
               LET g_success = 'N'
            END IF
         END IF
      END IF
 
      LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), 
                   " WHERE ima01 = '",l_rvb.rvb05,"'",
                   "   AND imaacti = 'Y'"
 
      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2       
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
      PREPARE ima_rvb1 FROM l_sql2
 
      EXECUTE ima_rvb1 INTO g_ima918,g_ima921                                                                             
     
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         IF l_sma90 = "Y" THEN
            
            LET l_cnt = 0					
            FOREACH p900_g_rvbs1 USING l_ogc.ogc092 INTO l_rvbs.*
               IF STATUS THEN
                  CALL cl_err('rvbs',STATUS,1)
               END IF
 
               LET l_rvbs.rvbs00 = "apmt300"
         
               LET l_rvbs.rvbs01 = l_rvb.rvb01
               LET l_rvbs.rvbs02 = l_rvb.rvb02
         
               LET l_cnt = l_cnt + 1 			
               LET l_rvbs.rvbs022 = l_cnt 	 	        
 
               #由於 g_ogb.ogb15 與 l_ima25 一致,故無須計算 rvbs06
               IF cl_null(l_rvbs.rvbs06) THEN
                  LET l_rvbs.rvbs06 = 0
               END IF
 
               LET l_rvbs.rvbs09 = 0
 
               #新增批/序號資料檔
               EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                      l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                      l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                      l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09, 
                                      l_rvbs.rvbs13,  
                                      gp_plant,gp_legal  
      
               IF STATUS OR SQLCA.SQLCODE THEN
                  LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                  CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                  LET g_success='N'
               END IF
         
               CALL p900_imgs(l_plant_new,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rva.rva06,l_rvbs.*)  
 
            END FOREACH
         END IF
      END IF

      IF s_industry('icd') THEN 
         IF s_icdbin_multi(l_rvb.rvb05,l_plant_new) THEN   #FUN-BA0051

            FOREACH p900_g_idd1 USING l_rvb.rvb38 INTO l_idd.idd04,l_idd.idd05,l_idd.idd06
            
               OPEN p900_g_idd2 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
               FETCH p900_g_idd2 INTO l_idd.* 
               CLOSE p900_g_idd2

               OPEN p900_g_idd3 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
               FETCH p900_g_idd3 INTO l_idd.idd13,l_idd.idd18,l_idd.idd19
               CLOSE p900_g_idd3

               LET l_idd.idd10 = l_rvb.rvb01
               LET l_idd.idd11 = l_rvb.rvb02
               LET l_idd.idd02 = l_rvb.rvb36   
               LET l_idd.idd03 = l_rvb.rvb37   
               #LET l_idd.idd04 = l_rvb.rvb38   
               CALL icd_ida(1,l_idd.*,l_plant_new) 
            END FOREACH
         END IF
         LET l_sql1 = "SELECT rvbiicd08,rvbiicd16 FROM ",cl_get_target_table(l_plant_new,'rvbi_file'),
                      " WHERE rvbi01 = '",l_rvb.rvb01,"'",
                      "   AND rvbi02 =  ",l_rvb.rvb02
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
         PREPARE p900_rvbi1 FROM l_sql1
         EXECUTE p900_rvbi1 INTO l_rvbiicd08,l_rvbiicd16
         CALL s_icdpost(13,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,g_pmn.pmn07,l_rvb.rvb07,l_rvb.rvb01,l_rvb.rvb02,
                        l_rva.rva06,'Y','','',l_rvbiicd16,l_rvbiicd08,l_plant_new)
              RETURNING l_flag1
         IF l_flag1 = 0 THEN
            LET g_success = 'N'
         END IF   
      END IF

      CALL p900_log(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                    l_rvb.rvb07,'2',l_rvb.rvb85)  #FUN-C80001
      IF p_rvv_flag = 'Y' THEN 
         #---- 新增入庫單身檔(rvv_file)----
         CALL p900_rvvins(p_i)
         CALL p900_log(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       l_rvv.rvv17,'3',l_rvv.rvv85) #FUN-C80001

         # 代採買替來源廠做入庫動作
         IF tm.oga09 = '6' AND i = 0 THEN  
            CALL s_mupimg(1,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                          l_rvv.rvv34,l_rvv.rvv17*l_ogb.ogb15_fac, 
                          g_oga.oga02,l_azp.azp01,1,l_rvv.rvv01,l_rvv.rvv02)   
            IF g_ima906 = '2' THEN                   
               CALL s_mupimgg(1,l_rvv.rvv31,
                              l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                              l_rvv.rvv80,l_rvv.rvv82,
                              g_oga.oga02,
                              l_plant_new) 
               CALL s_mupimgg(1,l_rvv.rvv31,
                              l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                              l_rvv.rvv83,l_rvv.rvv85,
                              g_oga.oga02,
                              l_plant_new) 
            ELSE 
               IF g_ima906 = '3' THEN
                  CALL s_mupimgg(1,l_rvv.rvv31,
                                 l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                 l_rvv.rvv83,l_rvv.rvv85,
                                 g_oga.oga02,
                                 l_plant_new) 
                END IF
            END IF
            CALL s_mudima(l_rvv.rvv31,l_plant_new) 
         END IF 
      END IF
   END FOREACH 
END FUNCTION
#FUN-C80001---end
FUNCTION p900_rvuins()
   DEFINE l_sql,l_sql1,l_sql2      STRING    #MOD-9C0274
   DEFINE i,l_i       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE li_result   LIKE type_file.num5     #FUN-560043  #No.FUN-680137 SMALLINT
 
   #新增入庫單單頭檔(rvu_file)
   LET l_rvu.rvu00 = '1'                #異動別
 
       CALL s_auto_assign_no("apm",rvu_t1,g_oga.oga02,"","rvu_file","rvu01",l_plant_new,"","") #FUN-980092 add
            RETURNING li_result,l_rvu.rvu01       
       IF (NOT li_result) THEN 
          LET g_msg = l_plant_new CLIPPED,l_rvu.rvu01
          CALL s_errmsg("rvu01",l_rvu.rvu01,g_msg CLIPPED,"mfg3046",1) 
          LET g_success ='N'
          RETURN
       END IF   
   LET l_rvu.rvu02 = l_rva.rva01        #驗收單號
   LET l_rvu.rvu03 = g_oga.oga02        #異動日期
   LET l_rvu.rvu04 = p_pmm09        #廠商編號     #FUN-670007
 
   #廠商簡稱
   LET l_sql = " SELECT pmc03 ",
               #" FROM ",s_dbs_new CLIPPED," pmc_file",
               " FROM ",cl_get_target_table(s_plant_new,'pmc_file'), #FUN-A50102
               " WHERE pmc01='",l_rvu.rvu04,"'"
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE pmc_pre FROM l_sql
 
   DECLARE pmc_c1 CURSOR FOR pmc_pre
 
   OPEN pmc_c1
   FETCH pmc_c1 INTO l_rvu.rvu05
   CLOSE pmc_c1
 
   LET l_rvu.rvu06 = g_pmm.pmm13        #採購部門
   LET l_rvu.rvu07 = g_pmm.pmm15        #人員
   LET l_rvu.rvu08 = g_pmm.pmm02        #採購性質
   LET l_rvu.rvu09 = null
   LET l_rvu.rvu11 = null
   LET l_rvu.rvu12 = null
   LET l_rvu.rvu20 = 'Y'                #已拋轉 
   LET l_rvu.rvu99 = g_flow99           #No.8047
   LET l_rvu.rvuconf= 'Y'
   LET l_rvu.rvuacti= 'Y'
   LET l_rvu.rvu17  = '1'               #簽核狀況:1.已核准  #FUN-AB0023 add
   LET l_rvu.rvumksg= 'N'               #是否簽核           #FUN-AB0023 add
   LET l_rvu.rvuuser= g_user
   LET l_rvu.rvugrup= g_grup
   LET l_rvu.rvumodu= null
   LET l_rvu.rvudate= null
   LET l_rvu.rvuud01=g_pmm.pmmud01
   LET l_rvu.rvuud02=g_pmm.pmmud02
   LET l_rvu.rvuud03=g_pmm.pmmud03
   LET l_rvu.rvuud04=g_pmm.pmmud04
   LET l_rvu.rvuud05=g_pmm.pmmud05
   LET l_rvu.rvuud06=g_pmm.pmmud06
   LET l_rvu.rvuud07=g_pmm.pmmud07
   LET l_rvu.rvuud08=g_pmm.pmmud08
   LET l_rvu.rvuud09=g_pmm.pmmud09
   LET l_rvu.rvuud10=g_pmm.pmmud10
   LET l_rvu.rvuud11=g_pmm.pmmud11
   LET l_rvu.rvuud12=g_pmm.pmmud12
   LET l_rvu.rvuud13=g_pmm.pmmud13
   LET l_rvu.rvuud14=g_pmm.pmmud14
   LET l_rvu.rvuud15=g_pmm.pmmud15
   LET l_rvu.rvu27  = '1'           #TQC-B60065
 
   #新增入庫單頭
   #LET l_sql="INSERT INTO ",l_dbs_new_tra CLIPPED,"rvu_file", #FUN-980092 add
   LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
    "(rvu00  ,rvu01  ,rvu02  ,rvu03  ,rvu04  ,",
    " rvu05  ,rvu06  ,rvu07  ,rvu08  ,rvu09  ,",
    " rvu10  ,rvu11  ,rvu12  ,rvu13  ,rvu14  ,",
    " rvu15  ,rvu20  ,rvu99  ,rvuconf,rvuacti,",  #No.8047
    " rvu17  ,rvumksg,",                          #FUN-AB0023 add
    " rvu27  ,",                                  #TQC-B60065
    " rvuuser,rvugrup,rvumodu,rvudate,",
    " rvuplant,rvulegal,",
    " rvuud01,rvuud02,rvuud03,rvuud04,rvuud05,",
    " rvuud06,rvuud07,rvuud08,rvuud09,rvuud10,",
    " rvuud11,rvuud12,rvuud13,rvuud14,rvuud15,rvuoriu,rvuorig)", #FUN-A10036
    " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
    "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,", #No.CHI-950020 
    "         ?,?,?,?,?,  ?,?,?,?,    ?,?,?,?,?,?, ?)"        #No.8047  #FUN-980010 #FUN-A10036 #TQC-B60065 Add ?
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE ins_rvu FROM l_sql
 
   EXECUTE ins_rvu USING 
       l_rvu.rvu00,l_rvu.rvu01,l_rvu.rvu02,l_rvu.rvu03,l_rvu.rvu04,
       l_rvu.rvu05,l_rvu.rvu06,l_rvu.rvu07,l_rvu.rvu08,l_rvu.rvu09,
       l_rvu.rvu10,l_rvu.rvu11,l_rvu.rvu12,l_rvu.rvu13,l_rvu.rvu14,
       l_rvu.rvu15,l_rvu.rvu20,l_rvu.rvu99,l_rvu.rvuconf,l_rvu.rvuacti, #8047
       l_rvu.rvu17,l_rvu.rvumksg,                                       #FUN-AB0023 add
       l_rvu.rvu27,                                                     #TQC-B60065
       l_rvu.rvuuser,l_rvu.rvugrup,l_rvu.rvumodu,l_rvu.rvudate,
       gp_plant,gp_legal   #FUN-980010
      ,l_rvu.rvuud01,l_rvu.rvuud02,l_rvu.rvuud03,l_rvu.rvuud04,l_rvu.rvuud05,
       l_rvu.rvuud06,l_rvu.rvuud07,l_rvu.rvuud08,l_rvu.rvuud09,l_rvu.rvuud10,
       l_rvu.rvuud11,l_rvu.rvuud12,l_rvu.rvuud13,l_rvu.rvuud14,l_rvu.rvuud15,g_user,g_grup #FUN-A10036
 
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
         LET g_showmsg=l_rvu.rvu00,"/",l_rvu.rvu01,"/",l_rvu.rvu02  
         CALL s_errmsg('rvu00,rvu01,rvu02',g_showmsg,'ins rvu:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('ins rvu:',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
#入庫單單身檔
FUNCTION p900_rvvins(p_i)
   DEFINE l_sql,l_sql1,l_sql2      STRING  #MOD-9C0274
   DEFINE p_i       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_no      LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_price   LIKE ogb_file.ogb13
   DEFINE i,l_i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_msg     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
   DEFINE l_chr     LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
  # DEFINE l_qoh     LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_qoh     LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_ima86   LIKE ima_file.ima86
   DEFINE l_ima39   LIKE ima_file.ima39
   DEFINE l_ima35   LIKE ima_file.ima35
   DEFINE l_ima36   LIKE ima_file.ima36
   DEFINE l_rvvi    RECORD LIKE rvvi_file.*  #No.FUN-7B0018
   DEFINE l_cnt     LIKE type_file.num5      #MOD-970042
   DEFINE l_ima25   LIKE ima_file.ima25    #MOD-990172
   DEFINE l_flag    LIKE type_file.num5    #MOD-990172
   DEFINE l_fac     LIKE ogb_file.ogb15_fac 	#CHI-9A0040 add
   DEFINE l_idd   RECORD LIKE idd_file.*            #FUN-B90012
   DEFINE l_flag1        LIKE type_file.num10       #FUN-B90012
   #DEFINE l_imaicd08     LIKE imaicd_file.imaicd08  #FUN-B90012 #FUN-BA0051 mark
   DEFINE l_rvviicd02    LIKE rvvi_file.rvviicd02   #FUN-B90012
   DEFINE l_rvviicd05    LIKE rvvi_file.rvviicd05   #FUN-B90012
   DEFINE l_rvu06        LIKE rvu_file.rvu06    #FUN-CB0087
   DEFINE l_rvu07        LIKE rvu_file.rvu07    #FUN-CB0087
   
   #讀取收貨單身檔(rvb_file)
   LET l_sql1 = "SELECT * ",
                #"  FROM ",l_dbs_new_tra CLIPPED,"rvb_file ", #FUN-980092 add
                "  FROM ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
                " WHERE rvb01='",l_rvb.rvb01,"' " ,
                "   AND rvb02 =",l_rvb.rvb02
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092 add
   PREPARE rvb_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN
         LET g_showmsg=l_rvb.rvb01,"/",l_rvb.rvb02
         CALL s_errmsg('rvb01,rvb02',g_showmsg,'rvb_p1',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err('rvb_p1',SQLCA.SQLCODE,1)
      END IF
   END IF
 
   DECLARE rvb_c1 CURSOR FOR rvb_p1
 
   OPEN rvb_c1
   FETCH rvb_c1 INTO l_rvb.*
   IF SQLCA.SQLCODE <> 0 THEN
      IF g_bgerr THEN
         LET g_showmsg=l_rvb.rvb01,"/",l_rvb.rvb02
         CALL s_errmsg('rvb01,rvb02',g_showmsg,'rvb_c1',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err('rvb_c1',SQLCA.SQLCODE,1)
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   CLOSE oeb_c1
 
   #新增入庫單身檔[rvv_file]
   LET l_rvv.rvv01 = l_rvu.rvu01     #入庫單號
   LET l_rvv.rvv02 = l_rvb.rvb02     #項次
   LET l_rvv.rvv03 = '1'             #異動類別
   LET l_rvv.rvv04 = l_rvb.rvb01     #驗收單號
   LET l_rvv.rvv05 = l_rvb.rvb02     #項次
   LET l_rvv.rvv06 = g_pmm.pmm09     #廠商編號
   LET l_rvv.rvv09 = g_oga.oga02     #異動日期 
   LET l_rvv.rvv17 = l_rvb.rvb07     #數量
   LET l_rvv.rvv23 = 0               #已請款匹配量
   LET l_rvv.rvv88 = 0               #暫估數量  #No.TQC-7B0083
   #-----MOD-A90029---------
   #LET l_rvv.rvv25 = 'N'             #樣品否
   IF g_oay11 = 'Y' THEN
      LET l_rvv.rvv25 = 'N'
   ELSE 
      LET l_rvv.rvv25 = 'Y'
   END IF
   #-----END MOD-A90029-----
   LET l_rvv.rvv31 = l_rvb.rvb05     #料件編號
   LET l_rvv.rvvud01 = l_rvb.rvbud01
   LET l_rvv.rvvud02 = l_rvb.rvbud02
   LET l_rvv.rvvud03 = l_rvb.rvbud03
   LET l_rvv.rvvud04 = l_rvb.rvbud04
   LET l_rvv.rvvud05 = l_rvb.rvbud05
   LET l_rvv.rvvud06 = l_rvb.rvbud06
   LET l_rvv.rvvud07 = l_rvb.rvbud07
   LET l_rvv.rvvud08 = l_rvb.rvbud08
   LET l_rvv.rvvud09 = l_rvb.rvbud09
   LET l_rvv.rvvud10 = l_rvb.rvbud10
   LET l_rvv.rvvud11 = l_rvb.rvbud11
   LET l_rvv.rvvud12 = l_rvb.rvbud12
   LET l_rvv.rvvud13 = l_rvb.rvbud13
   LET l_rvv.rvvud14 = l_rvb.rvbud14
   LET l_rvv.rvvud15 = l_rvb.rvbud15
 
   CALL p900_ima(l_rvv.rvv31)
     RETURNING l_rvv.rvv031,l_ima25,l_qoh,l_ima86,l_ima39,		#MOD-990172
               l_ima35,l_ima36
   IF cl_null(l_ima35) THEN LET l_ima35=' ' END IF
   IF cl_null(l_ima36) THEN LET l_ima36=' ' END IF
   LET l_rvv.rvv32 = l_rvb.rvb36     #倉庫
   LET l_rvv.rvv33 = l_rvb.rvb37     #儲   
   LET l_rvv.rvv34 = l_rvb.rvb38     #批
 
   #-----MOD-A70175---------
   #IF cl_null(l_ogb.ogb05) THEN
   #   LET l_rvv.rvv35 = g_ogb.ogb05
   #ELSE
   #   LET l_rvv.rvv35 = l_ogb.ogb05
   #END IF    
   #g_ogb.ogb05是目的站的資料,l_ogb.ogb05是當站的資料
   LET l_rvv.rvv35 = g_ogb.ogb05
   #-----END MOD-A70175-----
   LET l_rvv.rvv17=s_digqty(l_rvv.rvv17, l_rvv.rvv35)   #FUN-BB0086 add
 
   IF l_ima25 = l_rvv.rvv35 THEN
      LET l_rvv.rvv35_fac = 1
   ELSE
      CALL s_umfchkm(l_rvv.rvv31,l_rvv.rvv35,l_ima25,l_plant_new)
           RETURNING l_flag,l_rvv.rvv35_fac
      IF l_flag THEN
         LET g_msg=l_plant_new CLIPPED,' ',l_rvv.rvv31
         CALL cl_err(g_msg,'mfg3075',1)
         LET g_success = 'N'
      END IF
   END IF
   LET l_rvv.rvv36 = g_pmn.pmn01     #採購單號
   LET l_rvv.rvv37 = g_pmn.pmn02     #採購序號
   #-----MOD-AC0147---------
   LET l_rvv.rvv031 = NULL
   LET l_sql = "SELECT pmn041 ",
               "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'),
               " WHERE pmn01 = '",g_pmn.pmn01,"'",
               "   AND pmn02 = ",g_pmn.pmn02
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
   PREPARE pmn_pre FROM l_sql
   EXECUTE pmn_pre INTO l_rvv.rvv031
   #-----END MOD-AC0147-----
   LET l_rvv.rvv80 = l_rvb.rvb80
   LET l_rvv.rvv81 = l_rvb.rvb81
   LET l_rvv.rvv82 = l_rvb.rvb82
   LET l_rvv.rvv83 = l_rvb.rvb83
   LET l_rvv.rvv84 = l_rvb.rvb84
   LET l_rvv.rvv85 = l_rvb.rvb85
   LET l_rvv.rvv86 = l_rvb.rvb86
   LET l_rvv.rvv87 = l_rvb.rvb87
 
   LET l_rvv.rvv38 = l_rvb.rvb10     #單價
   LET l_rvv.rvv38t= l_rvb.rvb10t                                   #NO.FUN-620024
   CALL cl_digcut(l_rvv.rvv38,l_azi_p.azi03) RETURNING l_rvv.rvv38    
   CALL cl_digcut(l_rvv.rvv38t,l_azi_p.azi03) RETURNING l_rvv.rvv38t  #NO.FUN-620024
   LET l_rvv.rvv39 = l_rvv.rvv38 * l_rvv.rvv87   #金額  #No.TQC-6A0084 #TQC-D40075 mark #MOD-DA0106 remark
   LET l_rvv.rvv39t= l_rvv.rvv38t * l_rvv.rvv87                     #NO.FUN-620024  #No.TQC-6A0084 #TQC-D40075 mark #MOD-DA0106 remark
   #LET l_rvv.rvv39 = l_rvb.rvb88  #TQC-D40075 add
   #LET l_rvv.rvv39t= l_rvb.rvb88t #TQC-D40075 add
   CALL cl_digcut(l_rvv.rvv39,l_azi_p.azi04) RETURNING l_rvv.rvv39   #MOD-6B0152 modify
   CALL cl_digcut(l_rvv.rvv39t,l_azi_p.azi04) RETURNING l_rvv.rvv39t  #NO.FUN-620024
 
    LET l_rvv.rvv930 = g_pmn.pmn930   #MOD-920261 
    LET l_rvv.rvv89 = 'N'             #FUN-940083 
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF  #no.TQC-790003
   #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
   LET l_rvv.rvv22 = l_rvb.rvb22      #FUN-BB0001 add
   LET l_rvv.rvv26 = g_poy.poy30      #TQC-D40064 add
   #FUN-CB0087--add--str--
   IF l_aza.aza115 ='Y' THEN
      IF cl_null(l_rvv.rvv26) THEN    #TQC-D20067 mark  #TQC-D40064 remark
         #TQC-D20050--mod--str--
         #SELECT rvu06,rvu07 INTO l_rvu06,l_rvu07 FROM rvu_file WHERE rvu01 = l_rvv.rvv01
         #CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu07,l_rvu06) RETURNING l_rvv.rvv26
         LET l_sql2="SELECT rvu06,rvu07 FROM ",cl_get_target_table(l_plant_new,'rvu_file')," WHERE rvu01 = '",l_rvv.rvv01,"'"
         PREPARE rvv26_pr2 FROM l_sql2
         EXECUTE rvv26_pr2 INTO l_rvu06,l_rvu07
         CALL s_reason_code1(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu07,l_rvu06,l_plant_new) RETURNING l_rvv.rvv26
         #TQC-D20050--mod--end--
         IF cl_null(l_rvv.rvv26) THEN
            CALL cl_err(l_rvv.rvv26,'aim-425',1)
            LET g_success="N"
            RETURN
         END IF
      END IF
   END IF
   #FUN-CB0087--add--end--
   #新增入庫單身檔
   #LET l_sql2="INSERT INTO ",l_dbs_new_tra CLIPPED,"rvv_file", #FUN-980092 add
   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'rvv_file'), #FUN-A50102
              "(rvv01,rvv02,rvv03,rvv04,rvv05, ",
              " rvv06,rvv09,rvv17,rvv18,rvv23, ",
              " rvv24,rvv25,rvv26,rvv31,rvv031, ",
              " rvv32,rvv33,rvv34,rvv35,rvv35_fac,",
              " rvv36,rvv37,rvv38,rvv39,rvv40, ",
              " rvv41,rvv42,rvv43,rvv80,rvv81, ",
              " rvv82,rvv83,rvv84,rvv85,rvv86, ",
              " rvv87,rvv38t,rvv39t,rvv88,rvv930,rvv89,",  #NO.FUN-620024  #No.TQC-7B0083  #MOD-920261 add rvv930 #FUN-940083 add rvv89
              " rvvplant,rvvlegal,",
              " rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,",
              " rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,",
              " rvvud11,rvvud12,rvvud13,rvvud14,rvvud15,",
              " rvv22 )",      #FUN-BB0001 add
              " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?, ",  #NO.FUN-620024  #No.TQC-7B0083  #MOD-920261 add ? #FUN-940083
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",        #No.CHI-950020
              "         ?,?,?) "  #FUN-980010   #FUN-BB0001 add ?
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ins_rvv FROM l_sql2
 
   EXECUTE ins_rvv USING 
     l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv03,l_rvv.rvv04,l_rvv.rvv05,
     l_rvv.rvv06,l_rvv.rvv09,l_rvv.rvv17,l_rvv.rvv18,l_rvv.rvv23,
     l_rvv.rvv24,l_rvv.rvv25,l_rvv.rvv26,l_rvv.rvv31,l_rvv.rvv031,
     l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv35_fac,
     l_rvv.rvv36,l_rvv.rvv37,l_rvv.rvv38,l_rvv.rvv39,l_rvv.rvv40,
     l_rvv.rvv41,l_rvv.rvv42,l_rvv.rvv43,l_rvv.rvv80,l_rvv.rvv81,
     l_rvv.rvv82,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,l_rvv.rvv86,
     l_rvv.rvv87,l_rvv.rvv38t,l_rvv.rvv39t, #NO.FUN-620024  
     l_rvv.rvv88,l_rvv.rvv930,              #No.TQC-7B0083  #MOD-920261 add rvv930
     l_rvv.rvv89,                           #FUN-940083add rvv89
     gp_plant,gp_legal   #FUN-980010
    ,l_rvv.rvvud01,l_rvv.rvvud02,l_rvv.rvvud03,l_rvv.rvvud04,l_rvv.rvvud05,
     l_rvv.rvvud06,l_rvv.rvvud07,l_rvv.rvvud08,l_rvv.rvvud09,l_rvv.rvvud10,
     l_rvv.rvvud11,l_rvv.rvvud12,l_rvv.rvvud13,l_rvv.rvvud14,l_rvv.rvvud15,
     l_rvv.rvv22  #FUN-BB0001 add
 
   IF SQLCA.sqlcode<>0 THEN
      CALL cl_err('ins rvv:',SQLCA.sqlcode,1)
      IF g_bgerr THEN
         LET g_showmsg=l_rvv.rvv01,"/",l_rvv.rvv02,"/",l_rvv.rvv04,"/",l_rvv.rvv05
         CALL s_errmsg('rvv01,rvv02,rvv04,rvv05',g_showmsg,'ins rvv:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('ins rvv:',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_rvvi.* TO NULL
         LET l_rvvi.rvvi01 = l_rvv.rvv01
         LET l_rvvi.rvvi02 = l_rvv.rvv02
         IF NOT s_ins_rvvi(l_rvvi.*,l_plant_new) THEN #FUN-980092 add
            LET g_success = 'N'
         END IF
      END IF
   END IF
 
   #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_new CLIPPED,"ima_file",
   LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                " WHERE ima01 = '",l_rvv.rvv31,"'",
                "   AND imaacti = 'Y'"
 
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ima_rvv FROM l_sql2
 
   EXECUTE ima_rvv INTO g_ima918,g_ima921                                                                             
     
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      
      LET l_cnt = 0					#MOD-970042
      #FUN-C80001---begin
     #IF g_sma.sma96 = 'Y' THEN   #FUN-D30099 mark
      IF g_pod.pod08 = 'Y' THEN   #FUN-D30099
         FOREACH p900_g_rvbs1 USING l_rvv.rvv34 INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
 
            LET l_rvbs.rvbs00 = "apmt740"
      
            LET l_rvbs.rvbs01 = l_rvv.rvv01
            LET l_rvbs.rvbs02 = l_rvv.rvv02
       
            LET l_cnt = l_cnt + 1 				
            LET l_rvbs.rvbs022 = l_cnt 	 	      

            IF cl_null(l_rvbs.rvbs06) THEN
               LET l_rvbs.rvbs06 = 0
            END IF
 
            LET l_rvbs.rvbs09 = 0
 
            #新增批/序號資料檔
            EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                   l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                   l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                   l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09, 
                                   l_rvbs.rvbs13,  
                                   gp_plant,gp_legal  
 
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
               CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF
 
            CALL p900_imgs(l_plant_new,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu03,l_rvbs.*) 
      
         END FOREACH
      ELSE 
      #FUN-C80001---end
         FOREACH p900_g_rvbs INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
 
            LET l_rvbs.rvbs00 = "apmt740"
      
            LET l_rvbs.rvbs01 = l_rvv.rvv01
      
            LET l_cnt = l_cnt + 1 				#MOD-970042
            LET l_rvbs.rvbs022 = l_cnt 	 	        #MOD-970042

#CHI-C40031---add---START
            IF g_ogb.ogb17='Y' THEN        #多倉儲出貨
               IF g_sma.sma115 = 'Y' THEN  #多單位
                  OPEN p900_g_ogg USING l_rvbs.rvbs13
                  FETCH p900_g_ogg INTO g_ogg.*
                     IF STATUS THEN
                        CALL cl_err('ogg',STATUS,1)
                     END IF
                     IF g_ima906 = '3' AND g_ogg.ogg20 = '2' THEN
                        LET l_fac=1
                     ELSE
                     #檢查前站庫存單位與當站庫存單位是否可以轉換
                        CALL s_umfchkm(l_ogb.ogb04,g_ogg.ogg15,l_rvv.rvv35,l_plant_new)
                             RETURNING l_flag,l_fac
                        IF l_flag THEN
                           LET g_msg=l_dbs_new CLIPPED,' ',l_ogb.ogb04
                           CALL cl_err(g_msg,'mfg3075',1)
                           LET g_success = 'N'
                        END IF
                     END IF
               ELSE
                  OPEN p900_g_ogc USING l_rvbs.rvbs13
                  FETCH p900_g_ogc INTO g_ogc.*
                  IF STATUS THEN
                     CALL cl_err('ogc',STATUS,1)
                  END IF
                  #檢查前站庫存單位與當站庫存單位是否可以轉換
                  CALL s_umfchkm(l_ogb.ogb04,g_ogc.ogc15,l_rvv.rvv35,l_plant_new)
                     RETURNING l_flag,l_fac
                  IF l_flag THEN
                     LET g_msg=l_dbs_new CLIPPED,' ',l_ogb.ogb04
                     CALL cl_err(g_msg,'mfg3075',1)
                     LET g_success = 'N'
                  END IF
               END IF
            ELSE
#CHI-C40031---add-----END
               IF g_ogb.ogb15 = l_ima25 THEN
                   LET l_fac = 1
               ELSE
                #檢查該前站單位與當站庫存單位是否可以轉換
                  CALL s_umfchkm(l_ogb.ogb04,g_ogb.ogb15,l_rvv.rvv35,l_plant_new) #TQC-9C0099
                       RETURNING l_flag,l_fac
                  IF l_flag THEN
                     LET g_msg=l_dbs_new CLIPPED,' ',l_ogb.ogb04
                     CALL cl_err(g_msg,'mfg3075',1)
                     LET g_success = 'N'
                  END IF 
               END IF
            END IF #CHI-C40031 add

            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_fac 
 
            IF cl_null(l_rvbs.rvbs06) THEN
               LET l_rvbs.rvbs06 = 0
            END IF
 
            LET l_rvbs.rvbs09 = 1
            LET l_rvbs.rvbs13 = 0    #TQC-950001
 
         #新增批/序號資料檔
            EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                   l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                   l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                   l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09, 
                                   l_rvbs.rvbs13,  #TQC-950001 
                                   gp_plant,gp_legal   #FUN-980010
 
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
               CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF
 
          # CALL p900_imgs(l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu03,l_rvbs.*)	#MOD-980058  #No.FUN-A10099
            CALL p900_imgs(l_plant_new,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu03,l_rvbs.*)        #No.FUN-A10099
      
         END FOREACH
      END IF  #FUN-C80001
   END IF

#FUN-B90012 ---------------------------Begin----------------------------
   IF s_industry('icd') THEN
      #FUN-BA0051 --START mark--
      #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",
      #                                     cl_get_target_table(l_plant_new,'ima_file'),
      #             " WHERE imaicd00 = '",l_rvv.rvv31,"'",
      #             "   AND ima01 = imaicd00 ",
      #             "   AND imaacti = 'Y'"
      #          
      #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
      #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
      #PREPARE p900_rvv_imaicd08 FROM l_sql2 
      # 
      #EXECUTE p900_rvv_imaicd08 INTO l_imaicd08 
      #
      #IF l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
      IF s_icdbin_multi(l_rvv.rvv31,l_plant_new) THEN   #FUN-BA0051
         #FUN-C80001---begin
        #IF g_sma.sma96 = 'Y' THEN   #FUN-D30099 mark
         IF g_pod.pod08 = 'Y' THEN   #FUN-D30099
            FOREACH p900_g_idd1 USING l_rvv.rvv34 INTO l_idd.idd04,l_idd.idd05,l_idd.idd06
            
               OPEN p900_g_idd2 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
               FETCH p900_g_idd2 INTO l_idd.* 
               CLOSE p900_g_idd2

               OPEN p900_g_idd3 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
               FETCH p900_g_idd3 INTO l_idd.idd13,l_idd.idd18,l_idd.idd19
               CLOSE p900_g_idd3

               LET l_idd.idd10 = l_rvv.rvv01
               LET l_idd.idd11 = l_rvv.rvv02
               LET l_idd.idd02 = l_rvv.rvv32   
               LET l_idd.idd03 = l_rvv.rvv33  
               #LET l_idd.idd04 = l_rvv.rvv34   
               CALL icd_ida(1,l_idd.*,l_plant_new)  
            END FOREACH
         ELSE
         #FUN-C80001---end 
            FOREACH p900_g_idd INTO l_idd.*
               LET l_idd.idd10 = l_rvv.rvv01
               LET l_idd.idd11 = l_rvv.rvv02
               LET l_idd.idd02 = l_rvv.rvv32   #CHI-BB0031
               LET l_idd.idd03 = l_rvv.rvv33   #CHI-BB0031
               LET l_idd.idd04 = l_rvv.rvv34   #CHI-BB0031
               CALL icd_ida(1,l_idd.*,l_plant_new)  
            END FOREACH
         END IF   #FUN-C80001
      END IF  
      LET l_sql1 = "SELECT rvviicd02,rvviicd05 FROM ",cl_get_target_table(l_plant_new,'rvvi_file'),
                   " WHERE rvvi01 = '",l_rvv.rvv01,"'",
                   "   AND rvvi02 =  ",l_rvv.rvv02
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
      PREPARE p900_rvvi FROM l_sql1
      EXECUTE p900_rvvi INTO l_rvviicd02,l_rvviicd05
      CALL s_icdpost(11,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv17,l_rvv.rvv01,l_rvv.rvv02,
                     l_rvu.rvu03,'Y',l_rvv.rvv04,l_rvv.rvv05,l_rvviicd05,l_rvviicd02,l_plant_new)
           RETURNING l_flag1
      IF l_flag1 = 0 THEN
         LET g_success = 'N'
      END IF
   END IF
#FUN-B90012 ---------------------------End------------------------------ 
 
 
   #回寫最近入庫日 ima73
    LET l_sql1 = "SELECT ima29 ", 
                 #" FROM ",l_dbs_new CLIPPED,"ima_file ",
                 " FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102     
                 " WHERE ima01='",l_rvv.rvv31,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
    PREPARE ima_p2 FROM l_sql1
    IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN
         CALL s_errmsg("ima01",l_rvv.rvv31,"",SQLCA.sqlcode,1)  
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
      END IF
    END IF
    DECLARE ima_c2 CURSOR FOR ima_p2
    OPEN ima_c2	
    FETCH ima_c2 INTO l_ima29
    # 異動日期需大於原來的異動日期才可 
    #必須判斷null,否則新料不會update
    IF (l_rvu.rvu03 > l_ima29 OR l_ima29 IS NULL)  THEN
       #LET l_sql2="UPDATE ",l_dbs_new CLIPPED,"ima_file",
       LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102     
                  " SET ima73 = ? ",
                  "   , ima29 = ? ",     #MOD-C30877 add
                  " WHERE ima01 = ?  "
 	   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
       PREPARE upd_ima2 FROM l_sql2
      #EXECUTE upd_ima2 USING l_rvu.rvu03,l_rvv.rvv31                 #MOD-C30877 mark
       EXECUTE upd_ima2 USING l_rvu.rvu03,l_rvu.rvu03,l_rvv.rvv31     #MOD-C30877 add
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
          IF g_bgerr THEN
             CALL s_errmsg('ima01',l_rvv.rvv31,'upd ima',STATUS,1)
          ELSE
             CALL cl_err('upd ima:',STATUS,1)
          END IF
          LET g_success='N'
       END IF
    END IF
 
END FUNCTION
 
FUNCTION p900_imd(p_imd01,p_plant) #FUN-980092 add
   DEFINE p_imd01   LIKE imd_file.imd01,
          l_imd11   LIKE imd_file.imd11,
          p_dbs     LIKE type_file.chr21    #No.FUN-680137 VARCHAR(21)
   DEFINE l_sql     STRING                  #MOD-9C0274
 
   DEFINE p_dbs_tra LIKE type_file.chr21, #FUN-980092 add
          p_plant   LIKE azp_file.azp01   #FUN-980092 add
 
   LET g_plant_new = p_plant
   CALL s_getdbs()      LET p_dbs = g_dbs_new
   CALL s_gettrandbs()  LET p_dbs_tra = g_dbs_tra
 
   LET g_errno=''
 
   #LET l_sql="SELECT imd10,imd11,imd12,imd13,imd14,imd15  FROM ",p_dbs CLIPPED,"imd_file",  #MOD-6C0086 modify
   LET l_sql="SELECT imd10,imd11,imd12,imd13,imd14,imd15  FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
             " WHERE imd01 = '",p_imd01,"'",
             "   AND imd10 = 'S' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE imd_pre FROM l_sql
   DECLARE imd_cs CURSOR FOR imd_pre
   OPEN imd_cs                 #FUN-670007
   FETCH imd_cs INTO g_imd10,g_imd11,g_imd12,g_imd13,g_imd14,g_imd15
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg4020'
      WHEN g_imd11 ='N'          #TQC-690057 modify l_imd11->g_imd11
         LET g_errno = 'mfg6080'
      OTHERWISE 
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      IF g_bgerr THEN  
        CALL s_errmsg('imd01',p_imd01,p_dbs,g_errno,1) 
      ELSE
        CALL cl_err(p_dbs,g_errno,1)
      END IF
      LET g_success = 'N'
   END IF
 
   CLOSE imd_cs
 
END FUNCTION

#FUNCTION p900_log(p_part,p_ware,p_loca,p_lot,p_qty,p_sta)  #FUN-C80001
FUNCTION p900_log(p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_qty1)  #FUN-C80001
   DEFINE p_part       LIKE ima_file.ima01,       #料號
          p_ware       LIKE ogb_file.ogb09,       #倉
          p_loca       LIKE ogb_file.ogb091,      #儲
          p_lot        LIKE ogb_file.ogb092,      #批
          p_qty        LIKE ogb_file.ogb12 ,      #異動數量
          l_img        RECORD LIKE img_file.*,
          l_imgg       RECORD LIKE imgg_file.*,   #FUN-560043
          p_sta        LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)   #1.出貨單 2.驗收單 3.入庫單
          p_qty1      LIKE ogb_file.ogb12 ,       #參考數量  #FUN-C80001
          l_flag       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_img09      LIKE img_file.img09,       #庫存單位
          l_img10      LIKE img_file.img10,       #庫存數量
          l_imgg10     LIKE imgg_file.imgg10,       #庫存數量   #FUN-560043
          l_img26      LIKE img_file.img26,
          l_ima39      LIKE ima_file.ima39,
          l_ima86      LIKE ima_file.ima86,
          l_ima25      LIKE ima_file.ima25,
          l_ima35      LIKE ima_file.ima35,
          l_ima36      LIKE ima_file.ima36,
         # l_qoh        LIKE ima_file.ima262, #FUN-A20044
          l_qoh        LIKE type_file.num15_3, #FUN-A20044
          t_dbs        LIKE type_file.chr21,   #No.FUN-680137 VARCHAR(21)
          l_ima02      LIKE ima_file.ima02,
          l_msg        LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(50)
          l_chr        LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_n          LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_sql1,l_sql2,l_sql3,l_sql4,l_sql5   STRING,       #MOD-9C0274
          l_i,l_j,l_n2 LIKE type_file.num5      #FUN-560043  #No.FUN-680137 SMALLINT
  DEFINE  p_img10      LIKE img_file.img10     #NO.FUN-620024
  DEFINE  l_k          LIKE type_file.num5     #NO.FUN-620024  #No.FUN-680137 SMALLINT
  DEFINE p_unit        LIKE ima_file.ima25     #NO.FUN-620024                        
  DEFINE p_unit2       LIKE ima_file.ima25     #NO.FUN-620024
  DEFINE l_sw          LIKE type_file.num5     #No.FUN-680137 SMALLINT                #No.TQC-660122
# DEFINE l_azp03       LIKE azp_file.azp03     #No.TQC-660122 #FUN-B90012
# DEFINE l_azp01       LIKE azp_file.azp01     #No.FUN-980059 #FUN-B90012
  DEFINE l_ccz28       LIKE ccz_file.ccz28  #MOD-CC0289 add
  DEFINE l_sql         STRING                  #FUN-D20062
 
   IF p_part[1,4] = 'MISC' THEN  #No.8743
      RETURN
   END IF
 
   IF p_loca IS NULL THEN
      LET p_loca = ' '
   END IF
   IF p_lot IS NULL THEN 
      LET p_lot = ' '
   END IF
 
   CALL p900_ima(p_part) RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,
                                   l_ima35,l_ima36
 
   LET l_sql1 = "SELECT COUNT(*) ",
                #"  FROM ",l_dbs_new_tra CLIPPED,"img_file ", #FUN-980092 add
                "  FROM ",cl_get_target_table(l_plant_new,'img_file'), #FUN-A50102
                " WHERE img01='",p_part,"' ",
                "   AND img02='",p_ware,"'",
                "   AND img03='",p_loca,"'",
                "   AND img04='",p_lot,"'"
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092 add
   PREPARE img_pre1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
         LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot           
         CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img_pre',SQLCA.SQLCODE,1)
      ELSE
        CALL cl_err('img_pre',SQLCA.SQLCODE,1)
      END IF
   END IF
 
   DECLARE img_cs CURSOR FOR img_pre1
 
   OPEN img_cs
   FETCH img_cs INTO l_n
   IF SQLCA.SQLCODE <> 0 THEN                                               
   IF g_bgerr THEN
         LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot        
         CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img_cs',SQLCA.sqlcode,1)
   ELSE
        CALL cl_err('img_cs',SQLCA.sqlcode,1)
   END IF
      LET g_success='N'                                                     
      RETURN                                                                
   END IF                                                                   
   CLOSE img_cs                                                            

   #FUN-D20062 -- add start --  #撈取來源站 img18有效日期
   IF g_pod.pod08 = 'Y' THEN
      LET l_sql = "SELECT img18 FROM img_file ",
                  " WHERE img01='",p_part,"' ",
                  #yemy 20130530  --begin
                  "    AND img02  = '",g_source_ogb09 ,"'",
                  "    AND img03  = '",g_source_ogb091,"'",
                  "    AND img04  = '",g_source_ogb092,"'"
                  #"   AND img02='",g_plant_ogb09,"'",
                  #"   AND img03='",p_loca,"'",
                  #"   AND img04='",p_lot,"'"
                  #yemy 20130530  --End  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE img18_pre FROM l_sql
      IF SQLCA.SQLCODE THEN
         IF g_bgerr THEN
            #yemy 20130530  --Begin
            #LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
            LET  g_showmsg=p_part,"/",g_source_ogb09,"/",g_source_ogb091,"/",g_source_ogb092
            #yemy 20130530  --End  
            CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img18_pre',SQLCA.SQLCODE,1)
         ELSE
           CALL cl_err('img18_pre',SQLCA.SQLCODE,1)
         END IF
      END IF

      DECLARE img18_cs CURSOR FOR img18_pre

      OPEN img18_cs
      FETCH img18_cs INTO l_img.img18
      IF SQLCA.SQLCODE <> 0 THEN
         IF g_bgerr THEN
            LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
            CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img18_cs',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('img18_cs',SQLCA.sqlcode,1)
         END IF
         LET g_success='N'
      END IF
      CLOSE img18_cs
   END IF
   #FUN-D20062 -- add end --

 
   IF l_n = 0 THEN
        LET l_img.img01 = p_part
        LET l_img.img02 = p_ware
        LET l_img.img03 = p_loca
        LET l_img.img04 = p_lot
        LET l_img.img05 = g_ogb.ogb01
        LET l_img.img06 = g_ogb.ogb03
        LET l_img.img09 = l_ima25
        #No.FUN-A10099  --Begin
        IF g_prog = 'atmt254' THEN
           LET l_img.img09 = g_ogb.ogb05
        END IF
        #No.FUN-A10099  --End
        LET l_img.img10 = 0
        LET l_img.img13 = null   #No.7304
        LET l_img.img17 = g_today
        IF g_pod.pod08 = 'N' THEN    #FUN-D20062 add
           LET l_img.img18 = g_lastdat
        END IF                       #FUN-D20062 add
        LET l_img.img20 = 1
        LET l_img.img21 = 1
        LET l_img.img22 = g_imd10
        LET l_img.img23 = g_imd11
        LET l_img.img24 = g_imd12
        LET l_img.img25 = g_imd13
        LET l_img.img27 = g_imd14
        LET l_img.img28 = g_imd15
 
         #LET l_sql2 = "INSERT INTO ",l_dbs_new_tra CLIPPED,"img_file", #FUN-980092 add
         LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'img_file'), #FUN-A50102
                      "(img01,img02,img03,img04,img05,img06,",
                      " img09,img10,img13,img17,img18,", 
                      " img20,img21,img22,img23,img24,", 
                      " img25,img27,img28,",   #TQC-690057 add img27,img28
                      " imgplant,imglegal)",   #FUN-980010
                      " VALUES( ?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,",  #TQC-690057
                      "         ?,?)"  #FUN-980010
 
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
         PREPARE ins_img FROM l_sql2
 
         EXECUTE ins_img USING l_img.img01,l_img.img02,l_img.img03,l_img.img04,
                               l_img.img05,l_img.img06,l_img.img09,l_img.img10,
                               l_img.img13,l_img.img17,l_img.img18,
                               l_img.img20,l_img.img21,l_img.img22,l_img.img23,
                               l_img.img24,l_img.img25,l_img.img27,l_img.img28,  #TQC-690057
                               gp_plant,gp_legal   #FUN-980010
         IF SQLCA.sqlcode<>0 THEN
            LET g_msg = l_dbs_new CLIPPED,'ins img'
            IF g_bgerr THEN
              LET  g_showmsg=l_img.img01,"/",l_img.img02,"/",l_img.img03,"/",l_img.img03,"/",l_img.img04         
              CALL s_errmsg('img01,img02,img03,img04',g_showmsg,g_msg,SQLCA.sqlcode,1)
            ELSE
              CALL cl_err(g_msg,SQLCA.sqlcode,1)
            END IF
            LET g_success = 'N'
         END IF
   #FUN-D20062 -- add start --
   ELSE
      IF g_pod.pod08 = 'Y' THEN
         LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'img_file'),
                    " SET img18 = '",l_img.img18,"' ",
                    " WHERE img01='",p_part,"' ",
                    "   AND img02='",p_ware,"'",
                    "   AND img03='",p_loca,"'",
                    "   AND img04='",p_lot,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
         PREPARE upd_img18 FROM l_sql
         EXECUTE upd_img18
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            IF g_bgerr THEN
               LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
               CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'upd img18',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('upd img18:',STATUS,1)
            END IF
            LET g_success='N'
         END IF
      END IF
   #FUN-D20062 -- add end --
   END IF  
 
   LET l_sql3 = "SELECT img10 ",                                            
                #" FROM ",l_dbs_new_tra CLIPPED,"img_file ", #FUN-980092 add
                " FROM ",cl_get_target_table(l_plant_new,'img_file'), #FUN-A50102 
                " WHERE img01='",p_part,"' ",                               
                "   AND img02='",p_ware,"'",                                
                "   AND img03='",p_loca,"'",                                
                "   AND img04='",p_lot,"'"                                  
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
   CALl cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092 add
   PREPARE img_pre2 FROM l_sql3                                             
   IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN
            LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot        
            CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img_pre',SQLCA.sqlcode,1)
      ELSE
           CALL cl_err('img_pre',SQLCA.sqlcode,1)
      END IF
   END IF 
   DECLARE img_cs1 CURSOR FOR img_pre1                                      
   OPEN img_cs1                                                             
   FETCH img_cs1 INTO p_img10                                               
   IF SQLCA.SQLCODE <> 0 THEN                                               
      IF g_bgerr THEN
            LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot        
            CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img_cs1',SQLCA.sqlcode,1)
      ELSE
           CALL cl_err('img_cs1',SQLCA.sqlcode,1)
      END IF
      LET g_success='N'                                                     
      RETURN                                                                
   END IF                                                                   
   CLOSE img_cs1                                                            
 
   IF g_ima906 = '2' OR g_ima906 = '3' THEN
      IF g_ima906 = '2' THEN                                                     
         LET l_k = 1                                                             
      ELSE                                                                       
         LET l_k = 2                                                             
      END IF                                                                     
      FOR l_i = l_k TO 2                                                         
         LET l_sql3 = "SELECT COUNT(*) ",
                      #"  FROM ",l_dbs_new_tra CLIPPED,"imgg_file ", #FUN-980092 add
                      "  FROM ",cl_get_target_table(l_plant_new,'imgg_file'), #FUN-A50102
                      " WHERE imgg01='",p_part,"' ",
                      "   AND imgg02='",p_ware,"'",
                      "   AND imgg03='",p_loca,"'",
                      "   AND imgg04='",p_lot,"'"
 
         IF l_i = 1 THEN
            LET l_sql3 = l_sql3,"   AND imgg09='",g_ogb.ogb910,"'"
         ELSE  
            LET l_sql3 = l_sql3,"   AND imgg09='",g_ogb.ogb913,"'"  #No.FUN-620054
         END IF
 
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3  #FUN-980092 add
         PREPARE imgg_pre1 FROM l_sql3
         IF SQLCA.SQLCODE THEN
            IF g_bgerr THEN
              LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot        
              CALL s_errmsg('imgg01,imgg02,imgg03,imgg04',g_showmsg,'imgg_pre',SQLCA.sqlcode,1)
            ELSE
              CALL cl_err('imgg_pre',SQLCA.sqlcode,1)
            END IF
         END IF
 
         DECLARE imgg_cs CURSOR FOR imgg_pre1
 
         OPEN imgg_cs
         FETCH imgg_cs INTO l_n2
 
         IF l_n2 = 0 THEN
            LET l_imgg.imgg01 = p_part
            LET l_imgg.imgg02 = p_ware
            LET l_imgg.imgg03 = p_loca
            LET l_imgg.imgg04 = p_lot
            LET l_imgg.imgg05 = g_ogb.ogb01
            LET l_imgg.imgg06 = g_ogb.ogb03
            IF l_i = 1 THEN
               LET l_imgg.imgg09 = g_ogb.ogb910
            ELSE
               LET l_imgg.imgg09 = g_ogb.ogb913
            END IF
            LET l_imgg.imgg10 = 0
            LET l_imgg.imgg17 = g_today
            LET l_imgg.imgg18 = g_lastdat
           #LET l_azp03 = s_madd_img_catstr(l_azp.azp03)       #FUN-B90012
           #LET l_azp01 = s_madd_img_catstr(l_azp.azp01)       #FUN-B90012
           #CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_ima25,l_azp01)  #No.FUN-980059 #FUN-B90012                                                         
            CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_ima25,l_plant_new) #FUN-B90012
                 RETURNING l_sw,l_imgg.imgg21                                                                                        
            IF l_sw = 1 THEN                                                                                                         
               IF g_bgerr THEN
                 CALL s_errmsg(' ',' ','','mfg3075',1)
               ELSE
                 CALL cl_err('','mfg3075',1)
               END IF
               LET g_success = 'N'     #MOD-880187  add
            END IF
            LET l_imgg.imgg22 = 'S'
            LET l_imgg.imgg23 = 'Y'
            LET l_imgg.imgg24 = 'N'
            LET l_imgg.imgg25 = 'N'
           #CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_img.img09,l_azp01)  #No.FUN-980059  #FUN-B90012 
            CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_img.img09,l_plant_new) #FUN-B90012
                 RETURNING l_sw,l_imgg.imgg211                                                                                       
            IF l_sw = 1 THEN                                                                                                         
               IF g_bgerr THEN
                   CALL s_errmsg(' ',' ','','mfg3075',1)
               ELSE
                 CALL cl_err('','mfg3075',1)
               END IF
               LET g_success = 'N'     #MOD-880187  add
            END IF
            IF cl_null(l_imgg.imgg02) THEN LET l_imgg.imgg02 = ' ' END IF
            IF cl_null(l_imgg.imgg03) THEN LET l_imgg.imgg03 = ' ' END IF
            IF cl_null(l_imgg.imgg04) THEN LET l_imgg.imgg04 = ' ' END IF
            #LET l_sql4="INSERT INTO ",l_dbs_new_tra CLIPPED,"imgg_file", #FUN-980092 add
            LET l_sql4="INSERT INTO ",cl_get_target_table(l_plant_new,'imgg_file'), #FUN-A50102
              "(imgg01,imgg02,imgg03,imgg04,imgg05,",
              " imgg06,imgg09,imgg10,imgg17,imgg18,", 
              " imgg21,imgg22,imgg23,imgg24,imgg25,", 
              " imgg211, imggplant,imgglegal)",  #FUN-980010
              " VALUES(","'",l_imgg.imgg01,"',","'",l_imgg.imgg02,"',","'",l_imgg.imgg03,"',","'",l_imgg.imgg04,"',",
                         "'",l_imgg.imgg05,"',",l_imgg.imgg06,",","'",l_imgg.imgg09,"',",l_imgg.imgg10,",",
                         "'",l_imgg.imgg17,"',","'",l_imgg.imgg18,"',",l_imgg.imgg21,",","'",l_imgg.imgg22,"',",
                         "'",l_imgg.imgg23,"',","'",l_imgg.imgg24,"',","'",l_imgg.imgg25,"',",l_imgg.imgg211,",",
                         "'",gp_plant,"',","'",gp_legal,"'",")"   #FUN-980010 #FUN-B90012
 
 	    CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
            CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-A50102
            PREPARE ins_imgg FROM l_sql4
 
            EXECUTE ins_imgg 
            IF SQLCA.sqlcode<>0 THEN
               LET g_msg = l_dbs_new CLIPPED,'ins imgg'
               IF g_bgerr THEN
                  LET g_showmsg=l_imgg.imgg01,"/",l_imgg.imgg02,"/"
                             ,l_imgg.imgg03,"/",l_imgg.imgg03,"/",
                              l_imgg.imgg04     
                  CALL s_errmsg('imgg01,immgg02,imgg03,imgg04',g_showmsg,g_msg,SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err(g_msg,SQLCA.sqlcode,1)
               END IF
               LET g_success = 'N'
            END IF
         END IF   
      END FOR
   END IF
 
   LET g_tlf.tlf01=p_part               #異動料件編號
   #----來源----
   IF p_sta = '1' OR p_sta='2' THEN
      IF p_sta = '1' THEN
         LET g_tlf.tlf02=50             #'Stock'
         LET g_tlf.tlf021=p_ware        #倉庫
         LET g_tlf.tlf022=p_loca        #儲位
         LET g_tlf.tlf023=p_lot         #批號
      ELSE
         LET g_tlf.tlf02=10
         LET g_tlf.tlf021=' '           #倉庫
         LET g_tlf.tlf022=' '           #儲位
         LET g_tlf.tlf023=' '           #批號
      END IF
      LET g_tlf.tlf020=l_ogb.ogb08
      LET g_tlf.tlf024=''              #異動後數量
      LET g_tlf.tlf025=l_ima25         #庫存單位(ima_file or img_file)
   ELSE
      LET g_tlf.tlf02=20
      LET g_tlf.tlf021=' '
      LET g_tlf.tlf022=' '
      LET g_tlf.tlf023=' '
      LET g_tlf.tlf024=' '
      LET g_tlf.tlf025=' '
   END IF
 
   #no.3568 01/10/22
   CASE p_sta
      WHEN '1'  #出貨單
          LET g_tlf.tlf026=l_ogb.ogb01       #異動單號 No.8047
          LET g_tlf.tlf027=l_ogb.ogb03       #異動項次 No.8047
      WHEN '2'  #收貨單
          LET g_tlf.tlf026=l_rvb.rvb04       #異動單號 No.6178
          LET g_tlf.tlf027=l_rvb.rvb03       #異動項次 No.6178
      WHEN '3'  #入庫單
          LET g_tlf.tlf026=l_rvv.rvv04       #異動單號 No.6178
          LET g_tlf.tlf027=l_rvv.rvv05       #異動項次 No.6178
   END CASE
 
   #---目的----
   IF p_sta = '3' OR p_sta = '2' THEN
      IF p_sta='3' THEN
         LET g_tlf.tlf03=50
         LET g_tlf.tlf035=l_ima25
      ELSE
         LET g_tlf.tlf03=20
         LET g_tlf.tlf035=''
      END IF
      LET g_tlf.tlf031=p_ware
      LET g_tlf.tlf032=p_loca
      LET g_tlf.tlf033=p_lot
      LET g_tlf.tlf034=''
   ELSE  
      LET g_tlf.tlf03=724
      LET g_tlf.tlf030=' '
      LET g_tlf.tlf031=' '            #倉庫
      LET g_tlf.tlf032=' '            #儲位
      LET g_tlf.tlf033=' '            #批號
      LET g_tlf.tlf034=' '            #異動後庫存數量
      LET g_tlf.tlf035=' '            #庫存單位(ima_file or img_file)
   END IF
 
   #no.3568 01/10/22
   CASE p_sta
      WHEN '1'  #出貨單
          LET g_tlf.tlf036=l_ogb.ogb31       #異動單號 no.6178
          LET g_tlf.tlf037=l_ogb.ogb32       #異動項次 no.6178
      WHEN '2'  #收貨單
          LET g_tlf.tlf036=l_rvb.rvb01       #異動單號
          LET g_tlf.tlf037=l_rvb.rvb02       #異動項次
      WHEN '3'  #入庫單
          LET g_tlf.tlf036=l_rvv.rvv01       #異動單號
          LET g_tlf.tlf037=l_rvv.rvv02       #異動項次
   END CASE
 
   #-->異動數量
   LET g_tlf.tlf04= ' '                #工作站
   LET g_tlf.tlf05= ' '                #作業序號
   LET g_tlf.tlf06=g_oga.oga02         #發料日期 no.6178
   LET g_tlf.tlf07=g_today             #異動資料產生日期  
   LET g_tlf.tlf08=TIME                #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user              #產生人
   #FUN-C80001---begin
   IF g_ima906 = '2' THEN
      LET g_tlf.tlf10=p_qty + p_qty1*l_ogb.ogb914
   ELSE 
   #FUN-C80001---end
      LET g_tlf.tlf10=p_qty               #異動數量
   END IF #FUN-C80001
   LET g_tlf.tlf11=l_ima25             #發料單位
   LET g_tlf.tlf12=1                   #發料/庫存 換算率
   LET g_tlf.tlf11=g_ogb.ogb05         #MOD-4B0148
  LET g_tlf.tlf12=l_ogb.ogb15_fac      #MOD-810179
 
   CASE p_sta
      WHEN '1' LET g_tlf.tlf13='axmt620'
               LET g_tlf.tlf20 = g_ogb.ogb41 #MOD-D80197 add
      WHEN '2' LET g_tlf.tlf13='apmt1101'
      WHEN '3' LET g_tlf.tlf13='apmt150'
   END CASE
 
#  LET g_tlf.tlf14=' '              #異動原因           #MOD-B80234 mark
   LET g_tlf.tlf14=l_ogb.ogb1001                        #MOD-B80234
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   LET g_tlf.tlf18=l_qoh
 
   CASE p_sta
#     WHEN '1' LET g_tlf.tlf19=l_oga.oga04  #no.6178 #MOD-6C0120   #MOD-B70272 mark
      WHEN '1' LET g_tlf.tlf19=l_oga.oga03  #MOD-B70272
      WHEN '2' LET g_tlf.tlf19=l_rvu.rvu04
      WHEN '3' LET g_tlf.tlf19=l_rvu.rvu04
   END CASE
 
   #LET g_tlf.tlf20= ' '  
   IF cl_null(g_tlf.tlf20) THEN LET g_tlf.tlf20 = ' ' END IF    #MOD-D80197       
   LET g_tlf.tlf60=l_ogb.ogb05_fac     #MOD-4B0148 #MOD-810179
 
   IF p_sta = '4' THEN    #代送銷退單                                           
                                                                                
      LET g_tlf.tlf02 = 731                                                     
      LET g_tlf.tlf020 = ' '                                                    
      LET g_tlf.tlf021 = ' '                                                    
      LET g_tlf.tlf022 = ' '                                                    
      LET g_tlf.tlf023 = ' '                                                    
      LET g_tlf.tlf024 = 0                                                      
      LET g_tlf.tlf025 = ' '                                                    
                                                                                
      LET g_tlf.tlf026 = l_oha.oha01       #異動單號                            
      LET g_tlf.tlf027 = l_ohb.ohb03       #異動項次                            
                                                                                
      LET g_tlf.tlf03 = 50                                                      
      LET g_tlf.tlf030 = l_ohb.ohb08                                            
      LET g_tlf.tlf031 = p_ware                                                 
      LET g_tlf.tlf032 = p_loca                                                 
      LET g_tlf.tlf033 = p_lot                                                  
      LET g_tlf.tlf034 = p_img10                                                
      LET g_tlf.tlf035 = l_ima25           #庫存單位(ima_file or img_file)      
                                                                                
      LET g_tlf.tlf036 = l_oha.oha01       #異動單號
      LET g_tlf.tlf037 = l_ohb.ohb03       #異動項次                            
                                                                                
      LET g_tlf.tlf11 = l_ohb.ohb05                                             
      LET g_tlf.tlf12 = l_ohb.ohb15_fac                                         
                                                                                
      LET g_tlf.tlf13 = 'aomt800'                                               
     # LET g_tlf.tlf19 = l_oha.oha04# MOD-D10189                                             
      LET g_tlf.tlf19 = l_oha.oha03  # MOD-D10189 add 
       LET g_tlf.tlf60 = l_ohb.ohb05_fac                                         
   END IF                                                                       
                                                                                
 
   LET g_tlf.tlf62=g_ogb.ogb31    #參考單號(訂單)   
   LET g_tlf.tlf63=g_ogb.ogb32    #訂單項次
 
   CASE
      WHEN g_tlf.tlf02=50 
         LET g_tlf.tlf902=g_tlf.tlf021
         LET g_tlf.tlf903=g_tlf.tlf022
         LET g_tlf.tlf904=g_tlf.tlf023
         LET g_tlf.tlf905=g_tlf.tlf026
         LET g_tlf.tlf906=g_tlf.tlf027
         LET g_tlf.tlf907=-1
      WHEN g_tlf.tlf03=50 
         LET g_tlf.tlf902=g_tlf.tlf031
         LET g_tlf.tlf903=g_tlf.tlf032
         LET g_tlf.tlf904=g_tlf.tlf033
         LET g_tlf.tlf905=g_tlf.tlf036
         LET g_tlf.tlf906=g_tlf.tlf037
         LET g_tlf.tlf907=1
      OTHERWISE
         LET g_tlf.tlf902=' '
         LET g_tlf.tlf903=' '
         LET g_tlf.tlf904=' '
         LET g_tlf.tlf905=' '
         LET g_tlf.tlf906=' '
         LET g_tlf.tlf907=0
   END CASE
 
   LET g_tlf.tlf99 = g_flow99  #No.8047
   IF g_tlf.tlf902 IS NULL THEN LET g_tlf.tlf902 = ' ' END IF
   IF g_tlf.tlf903 IS NULL THEN LET g_tlf.tlf903 = ' ' END IF
   IF g_tlf.tlf904 IS NULL THEN LET g_tlf.tlf904 = ' ' END IF
   LET g_tlf.tlf61 = s_get_doc_no(g_tlf.tlf905)   #FUN-560043
   CASE p_sta
      WHEN '1'  #出貨單
          LET g_tlf.tlf930 = l_ogb.ogb930
      WHEN '2'  #收貨單
          LET g_tlf.tlf930 = l_rvb.rvb930
      WHEN '3'  #入庫單
          LET g_tlf.tlf930 = l_rvv.rvv930
   END CASE
 
   IF (g_tlf.tlf02=50 OR g_tlf.tlf03=50) THEN
      IF NOT s_tlfidle(l_plant_new,g_tlf.*) THEN      #更新呆滯日期 #FUN-980092 add
         CALL cl_err('upd ima902:','9050',1)
         LET g_success='N'
      END IF
   END IF

   #TQC-D20047--add--str--
   LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
   PREPARE aza115_pr3 FROM l_sql2
   EXECUTE aza115_pr3 INTO g_aza.aza115   
   #TQC-D20047--add--end--
   #FUN-CB0087--add--str--
   IF g_aza.aza115 ='Y' THEN
      IF cl_null(g_tlf.tlf14) THEN     #TQC-D20067 mark  #TQC-D40064 remark
         #CALL s_reason_code(g_tlf.tlf036,g_tlf.tlf026,'',g_tlf.tlf01,g_tlf.tlf031,'','') RETURNING g_tlf.tlf14              #TQC-D20050
         CALL s_reason_code1(g_tlf.tlf036,g_tlf.tlf026,'',g_tlf.tlf01,g_tlf.tlf031,'','',l_plant_new) RETURNING g_tlf.tlf14  #TQC-D20050
         IF cl_null(g_tlf.tlf14) THEN
            CALL cl_err(g_tlf.tlf14,'aim-425',1)
            LET g_success="N"
            RETURN
         END IF
      END IF
   END IF
   #FUN-CB0087--add--end-- 
#MOD-CC0289 add begin---------------------------------------------- 
    #依參考成本參數檔(ccz_file)中ccz28的值更新tlfcost的值  
    #當ccz28='1' OR '2'時,tlfcost=' '
    #當ccz28='3'時       ,tlfcost=批號 tlf904(tlf023/tlf033)
    #當ccz28='4'時       ,tlfcost=專案號 tlf20
    #當ccz28='5'時       ,tlfcost=倉庫
    SELECT ccz28 INTO l_ccz28 FROM ccz_file WHERE ccz00='0'
    CASE 
       WHEN l_ccz28='1' OR l_ccz28='2'
          LET g_tlf.tlfcost=' '
       WHEN l_ccz28='3'   #批號
          IF g_tlf.tlf904 IS NULL THEN LET g_tlf.tlf904=' ' END IF
          LET g_tlf.tlfcost=g_tlf.tlf904
       WHEN l_ccz28='4'   #專案編號
          IF g_tlf.tlf20 IS NULL THEN LET g_tlf.tlf20=' ' END IF
          LET g_tlf.tlfcost=g_tlf.tlf20
       WHEN l_ccz28='5'   #倉庫
          IF g_tlf.tlf901 IS NULL THEN LET g_tlf.tlf901=' ' END IF 
          LET g_tlf.tlfcost=g_tlf.tlf901                         
    END CASE
#MOD-CC0289 add end----------------------------------------------    

   #No.FUN-CC0157(S)
    CASE
      WHEN g_tlf.tlf13 MATCHES 'axmt*'
           CALL s_tlf920('1',g_tlf.tlf905) RETURNING g_tlf.tlf920
      WHEN g_tlf.tlf13 MATCHES 'aomt*' 
           CALL s_tlf920('2',g_tlf.tlf905) RETURNING g_tlf.tlf920
    END CASE
   #No.FUN-CC0157(E)

   #LET l_sql2="INSERT INTO ",l_dbs_new_tra CLIPPED,"tlf_file", #FUN-980092 add
   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102
     "(tlf01,tlf020,tlf02,tlf021,tlf022,",
     " tlf023,tlf024,tlf025,tlf026,tlf027,",
     " tlf03,tlf031,tlf032,tlf033,tlf034,",
     " tlf035,tlf036,tlf037,tlf04,tlf05,",
     " tlf06,tlf07,tlf08,tlf09,tlf10,",
     " tlf11,tlf12,tlf13,tlf14,tlf15,",
     " tlf16,tlf17,tlf18,tlf19,tlf20,",
     " tlf60,tlf61,tlf62,tlf63,tlf99, ",
     " tlf902,tlf903,tlf904,tlf905,tlf906,",
     " tlf907,tlf930,tlfplant,tlflegal,tlfcost,tlf920)",      #FUN-980010 #CHI-9B0008 add tlf930 #MOD-CC0289 addtlfcost #FUN-CC0157 add tlf920
     " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
     "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
     "         ?,?,?,?,?, ?,?,?,? ,?,?) "   #MOD-CC0289 addtlfcost #FUN-980010 #CHI-9B0008  #FUN-CC0157 
 
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ins_tlf FROM l_sql2
 
   EXECUTE ins_tlf USING 
      g_tlf.tlf01,g_tlf.tlf020,g_tlf.tlf02,g_tlf.tlf021,g_tlf.tlf022,
      g_tlf.tlf023,g_tlf.tlf024,g_tlf.tlf025,g_tlf.tlf026,g_tlf.tlf027,
      g_tlf.tlf03,g_tlf.tlf031,g_tlf.tlf032,g_tlf.tlf033,g_tlf.tlf034,
      g_tlf.tlf035,g_tlf.tlf036,g_tlf.tlf037,g_tlf.tlf04,g_tlf.tlf05,
      g_tlf.tlf06,g_tlf.tlf07,g_tlf.tlf08,g_tlf.tlf09,g_tlf.tlf10,
      g_tlf.tlf11,g_tlf.tlf12,g_tlf.tlf13,g_tlf.tlf14,g_tlf.tlf15,
      g_tlf.tlf16,g_tlf.tlf17,g_tlf.tlf18,g_tlf.tlf19,g_tlf.tlf20,
      g_tlf.tlf60,g_tlf.tlf61,g_tlf.tlf62,g_tlf.tlf63,g_tlf.tlf99, #No.8047
      g_tlf.tlf902,g_tlf.tlf903,g_tlf.tlf904,g_tlf.tlf905,g_tlf.tlf906,
      g_tlf.tlf907,g_tlf.tlf930,gp_plant,gp_legal,g_tlf.tlfcost,g_tlf.tlf920 #MOD-CC0289 addtlfcost    #FUN-980010 #CHI-9B0008 add tlf930 #FUN-CC0157 add tlf920
 
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
        LET g_showmsg=g_tlf.tlf01,"/",g_tlf.tlf06
        CALL s_errmsg('tlf01,tlf06',g_showmsg,'ins tlf:',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err('ins tlf:',SQLCA.sqlcode,1) 
      END IF
      LET g_success = 'N'
   END IF
   
#FUN-BC0062 ------------Begin-----------		
   #計算異動加權平均成本		
   IF NOT s_tlf_mvcost(l_plant_new) THEN		
      IF g_bgerr THEN
        LET g_showmsg=g_tlf.tlf01,"/",g_tlf.tlf06
        CALL s_errmsg('tlf01,tlf06',g_showmsg,'ins cfa:',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err('ins cfa:',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   END IF		
#FUN-BC0062 ------------End-------------		

   IF g_ima906 = '2' OR g_ima906 = '3' THEN
      FOR l_j = 1 TO 2 
         IF l_j = 1 AND g_ima906 = '3' THEN
            CONTINUE FOR
         END IF
         LET g_tlff.tlff01=p_part               #異動料件編號
 
         #----來源----
         IF p_sta = '1' OR p_sta='2' THEN
            IF p_sta = '1' THEN
               LET g_tlff.tlff02=50             #'Stock'
               LET g_tlff.tlff021=p_ware        #倉庫
               LET g_tlff.tlff022=p_loca        #儲位
               LET g_tlff.tlff023=p_lot         #批號
            ELSE
               LET g_tlff.tlff02=10
               LET g_tlff.tlff021=' '           #倉庫
               LET g_tlff.tlff022=' '           #儲位
               LET g_tlff.tlff023=' '           #批號
            END IF
            LET g_tlff.tlff020=l_ogb.ogb08
            LET g_tlff.tlff024=''              #異動後數量
            IF l_j = 1 THEN
               LET g_tlff.tlff025=g_ogb.ogb910      #庫存單位
            ELSE 
               LET g_tlff.tlff025=g_ogb.ogb913      #庫存單位
            END IF
         ELSE
            LET g_tlff.tlff02=20
            LET g_tlff.tlff021=' '
            LET g_tlff.tlff022=' '
            LET g_tlff.tlff023=' '
            LET g_tlff.tlff024=' '
            LET g_tlff.tlff025=' '
         END IF
         CASE p_sta
            WHEN '1'  #出貨單
                 LET g_tlff.tlff026=l_ogb.ogb01       #異動單號 No.8047
                 LET g_tlff.tlff027=l_ogb.ogb03       #異動項次 No.8047
            WHEN '2'  #收貨單
                 LET g_tlff.tlff026=l_rvb.rvb04       #異動單號 No.6178
                 LET g_tlff.tlff027=l_rvb.rvb03       #異動項次 No.6178
            WHEN '3'  #入庫單
                 LET g_tlff.tlff026=l_rvv.rvv04       #異動單號 No.6178
                 LET g_tlff.tlff027=l_rvv.rvv05       #異動項次 No.6178
         END CASE
         #---目的----
 
         IF p_sta = '3' OR p_sta = '2' THEN
            IF p_sta='3' THEN
               LET g_tlff.tlff03=50
               IF l_j = 1 THEN
                  LET g_tlff.tlff035=g_ogb.ogb910
               ELSE
                  LET g_tlff.tlff035=g_ogb.ogb913
               END IF
            ELSE
               LET g_tlff.tlff03=20
               LET g_tlff.tlff035=''
            END IF
            LET g_tlff.tlff031=p_ware
            LET g_tlff.tlff032=p_loca
            LET g_tlff.tlff033=p_lot
            LET g_tlff.tlff034=''
         ELSE  
            LET g_tlff.tlff03=724
            LET g_tlff.tlff030=' '
            LET g_tlff.tlff031=' '            #倉庫
            LET g_tlff.tlff032=' '            #儲位
            LET g_tlff.tlff033=' '            #批號
            LET g_tlff.tlff034=' '            #異動後庫存數量
            LET g_tlff.tlff035=' '            #庫存單位(ima_file or img_file)
         END IF
         CASE p_sta
            WHEN '1'  #出貨單
                LET g_tlff.tlff036=l_ogb.ogb31       #異動單號 no.6178
                LET g_tlff.tlff037=l_ogb.ogb32       #異動項次 no.6178
            WHEN '2'  #收貨單
                LET g_tlff.tlff036=l_rvb.rvb01       #異動單號
                LET g_tlff.tlff037=l_rvb.rvb02       #異動項次
            WHEN '3'  #入庫單
                LET g_tlff.tlff036=l_rvv.rvv01       #異動單號
                LET g_tlff.tlff037=l_rvv.rvv02       #異動項次
         END CASE
 
         #-->異動數量
         LET g_tlff.tlff04= ' '                #工作站
         LET g_tlff.tlff05= ' '                #作業序號
         LET g_tlff.tlff06=g_oga.oga02         #發料日期 no.6178
         LET g_tlff.tlff07=g_today             #異動資料產生日期  
         LET g_tlff.tlff08=TIME                #異動資料產生時:分:秒
         LET g_tlff.tlff09=g_user              #產生人
         IF l_j = 1 THEN 
            #LET g_tlff.tlff10=g_ogb.ogb912     #異動數量 #FUN-C80001
            LET g_tlff.tlff10= p_qty   #FUN-C80001
            LET g_tlff.tlff11=g_ogb.ogb910     #發料單位
            LET g_tlff.tlff12=g_ogb.ogb911     #發料/庫存 換算率
            LET g_tlff.tlff219 = 2             #NO.FUN-620024              
            LET g_tlff.tlff220 = g_ogb.ogb910  #NO.FUN-620024
         ELSE
            #LET g_tlff.tlff10=g_ogb.ogb915     #異動數量 ##FUN-C80001
            LET g_tlff.tlff10= p_qty1  ##FUN-C80001
            LET g_tlff.tlff11=g_ogb.ogb913     #發料單位
            LET g_tlff.tlff12=g_ogb.ogb914     #發料/庫存 換算率
            LET g_tlff.tlff219 = 1             #NO.FUN-620024              
            LET g_tlff.tlff220 = g_ogb.ogb913  #NO.FUN-620024
         END IF
 
         CASE p_sta
            WHEN '1' LET g_tlff.tlff13='axmt620'
            WHEN '2' LET g_tlff.tlff13='apmt1101'
            WHEN '3' LET g_tlff.tlff13='apmt150'
         END CASE
 
         LET g_tlff.tlff14=' '              #異動原因
        
         LET g_tlff.tlff17=' '              #非庫存性料件編號
         IF l_j = 1 THEN
            SELECT imgg10 INTO l_imgg10 FROM imgg_file
             WHERE imgg01 = p_part
               AND imgg02 = p_ware 
               AND imgg03 = p_loca
               AND imgg04 = p_lot
               AND imgg09 = g_ogb.ogb910
         ELSE
            SELECT imgg10 INTO l_imgg10 FROM imgg_file
             WHERE imgg01 = p_part
               AND imgg02 = p_ware 
               AND imgg03 = p_loca
               AND imgg04 = p_lot
               AND imgg09 = g_ogb.ogb913
         END IF
         
         CASE p_sta
            WHEN '1' 
               IF l_j = 1 THEN
                  #LET l_imgg10 = l_imgg10 - g_ogb.ogb912 #FUN-C80001
                  LET l_imgg10 = l_imgg10 - p_qty         #FUN-C80001
               ELSE
                  #LET l_imgg10 = l_imgg10 - g_ogb.ogb915 #FUN-C80001
                  LET l_imgg10 = l_imgg10 - p_qty1        #FUN-C80001
               END IF
            WHEN '2'
               IF l_j = 1 THEN
                  #LET l_imgg10 = l_imgg10 + g_ogb.ogb912 #FUN-C80001
                  LET l_imgg10 = l_imgg10 + p_qty         #FUN-C80001
               ELSE
                  #LET l_imgg10 = l_imgg10 + g_ogb.ogb915 #FUN-C80001
                  LET l_imgg10 = l_imgg10 + p_qty1        #FUN-C80001
               END IF
            WHEN '3'
               IF l_j = 1 THEN
                  #LET l_imgg10 = l_imgg10 + g_ogb.ogb912 #FUN-C80001
                  LET l_imgg10 = l_imgg10 + p_qty         #FUN-C80001
               ELSE
                  #LET l_imgg10 = l_imgg10 + g_ogb.ogb915 #FUN-C80001
                  LET l_imgg10 = l_imgg10 + p_qty1        #FUN-C80001
               END IF
         END CASE
 
         LET g_tlff.tlff18=l_imgg10
 
         CASE p_sta
            WHEN '1' LET g_tlff.tlff19=g_oga.oga04  
            WHEN '2' LET g_tlff.tlff19=p_pmm09
            WHEN '3' LET g_tlff.tlff19=p_pmm09
         END CASE
 
         LET g_tlff.tlff20= ' '     
         IF l_j = 1 THEN
            LET g_tlff.tlff60=g_ogb.ogb911
         ELSE     
            LET g_tlff.tlff60=g_ogb.ogb914
         END IF
 
      IF p_sta = '4' THEN    #代送銷退單                                        
                                                                                
         LET g_tlff.tlff02 = 731                                                
         LET g_tlff.tlff021 =''             #倉庫                               
         LET g_tlff.tlff022 =''             #儲位                               
         LET g_tlff.tlff023 =''             #批號                               
         LET g_tlff.tlff020 = ''                                                
         LET g_tlff.tlff024 = 0                                                 
                                                                                
         IF l_j = 1 THEN                                                        
            LET g_tlff.tlff025 = l_ohb.ohb910                                   
         ELSE                                                                   
            LET g_tlff.tlff025 = l_ohb.ohb913                                   
         END IF                                                                 
                                                                                
         LET g_tlff.tlff026 = l_oha.oha01       #異動單號                       
         LET g_tlff.tlff027 = l_ohb.ohb03       #異動項次                       
                                                                                
         LET g_tlff.tlff03 = 50                                                 
         LET g_tlff.tlff030 = ''                                                
         LET g_tlff.tlff031 = p_ware                                            
         LET g_tlff.tlff032 = p_loca                                            
         LET g_tlff.tlff033 = p_lot                                             
         LET g_tlff.tlff034 = l_qoh                                             
                                                                                
         IF l_j = 1 THEN                                                        
            LET g_tlff.tlff035 = l_ohb.ohb910  #庫存單位(ima_file or img_file)  
         ELSE
            LET g_tlff.tlff035 = l_ohb.ohb913                                   
         END IF                                                                 
                                                                                
         LET g_tlff.tlff036 = l_oha.oha01       #異動單號                       
         LET g_tlff.tlff037 = l_ohb.ohb03       #異動項次                       
                                                                                
         IF l_j = 1 THEN                                                        
            LET g_tlff.tlff10=l_ohb.ohb912     #異動數量                        
            LET g_tlff.tlff11=l_ohb.ohb910                                      
            LET g_tlff.tlff12=l_ohb.ohb911                                      
            LET g_tlff.tlff219 = 2                                              
            LET g_tlff.tlff220 = l_ohb.ohb910
         ELSE                                                                   
            LET g_tlff.tlff10=l_ohb.ohb915     #異動數量                        
            LET g_tlff.tlff11=l_ohb.ohb913                                      
            LET g_tlff.tlff12=l_ohb.ohb914   
            LET g_tlff.tlff219 = 1                                              
            LET g_tlff.tlff220 = l_ohb.ohb913                                   
         END IF                                                                 
                                                                                
         LET g_tlff.tlff13 = 'aomt800'                                          
        # LET g_tlff.tlff19 = l_oha.oha04                                        
         LET g_tlff.tlff19 = l_oha.oha03 #MOD-D10189 add                                                                       
         IF l_j = 1 THEN                                                        
            LET g_tlff.tlff60 = l_ohb.ohb911
         ELSE                                                                   
            LET g_tlff.tlff60 = l_ohb.ohb914                                    
         END IF                                                                 
                                                                                
         IF l_j = 1 THEN                                                        
            LET l_imgg10 = l_imgg10 - l_ohb.ohb912                              
         ELSE                                                                   
            LET l_imgg10 = l_imgg10 - l_ohb.ohb915                              
         END IF                                                                 
         LET g_tlff.tlff18=l_imgg10                                             
      END IF                                                                    
                                                                                
 
         LET g_tlff.tlff62=g_ogb.ogb31    #參考單號(訂單)   
         LET g_tlff.tlff63=g_ogb.ogb32    #訂單項次
 
         CASE WHEN  g_tlff.tlff02=50 
                    LET g_tlff.tlff902=g_tlff.tlff021
                    LET g_tlff.tlff903=g_tlff.tlff022
                    LET g_tlff.tlff904=g_tlff.tlff023
                    LET g_tlff.tlff905=g_tlff.tlff026
                    LET g_tlff.tlff906=g_tlff.tlff027
                    LET g_tlff.tlff907=-1
              WHEN  g_tlff.tlff03=50 
                    LET g_tlff.tlff902=g_tlff.tlff031
                    LET g_tlff.tlff903=g_tlff.tlff032
                    LET g_tlff.tlff904=g_tlff.tlff033
                    LET g_tlff.tlff905=g_tlff.tlff036
                    LET g_tlff.tlff906=g_tlff.tlff037
                    LET g_tlff.tlff907=1
              OTHERWISE
                    LET g_tlff.tlff902=' '
                    LET g_tlff.tlff903=' '
                    LET g_tlff.tlff904=' '
                    LET g_tlff.tlff905=' '
                    LET g_tlff.tlff906=0    #NO.FUN-620024
                    LET g_tlff.tlff907=0
         END CASE
         LET g_tlff.tlff99 = g_flow99  
         IF g_tlff.tlff902 IS NULL THEN LET g_tlff.tlff902 = ' ' END IF
         IF g_tlff.tlff903 IS NULL THEN LET g_tlff.tlff903 = ' ' END IF
         IF g_tlff.tlff904 IS NULL THEN LET g_tlff.tlff904 = ' ' END IF
         LET g_tlff.tlff61 = s_get_doc_no(g_tlff.tlff905)
         CASE p_sta
            WHEN '1'  #出貨單
                LET g_tlff.tlff930 = l_ogb.ogb930
            WHEN '2'  #收貨單
                LET g_tlff.tlff930 = l_rvb.rvb930
            WHEN '3'  #入庫單
                LET g_tlff.tlff930 = l_rvv.rvv930
         END CASE
 
         IF g_tlff.tlff10 IS NULL OR g_tlff.tlff10 = 0 OR                          
            g_tlff.tlff11 IS NULL  THEN                                            
              CONTINUE FOR                                                         
         END IF                                                                    
         IF l_j = 1 THEN                                                           
            LET p_unit = g_tlff.tlff11                                             
         ELSE                                                                      
            LET p_unit2 = g_tlff.tlff11                                            
         END IF                                                                    
        
        IF cl_null(g_tlff.tlff012) THEN LET g_tlff.tlff012 = ' ' END IF     #FUN-B90012
        IF cl_null(g_tlff.tlff013) THEN LET g_tlff.tlff013 = 0   END IF     #FUN-B90012

        #LET l_sql5="INSERT INTO ",l_dbs_new_tra CLIPPED,"tlff_file", #FUN-980092 add
        LET l_sql5="INSERT INTO ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102
           "(tlff01,tlff020,tlff02,tlff021,tlff022,",
           " tlff023,tlff024,tlff025,tlff026,tlff027,",
           " tlff03,tlff031,tlff032,tlff033,tlff034,",
           " tlff035,tlff036,tlff037,tlff04,tlff05,",
           " tlff06,tlff07,tlff08,tlff09,tlff10,",
           " tlff11,tlff12,tlff13,tlff14,tlff15,",
           " tlff16,tlff17,tlff18,tlff19,tlff20,",
           " tlff60,tlff61,tlff62,tlff63,tlff99, ",
           " tlff902,tlff903,tlff904,tlff905,tlff906,",
           " tlff907,tlff219,tlff220,tlff930,tlffplant,",          #NO.FUN-620024 #FUN-980010 #CHI-9B0008 add tlff930
           " tlfflegal,tlff012,tlff013 )",                         #FUN-980010    #FUN-B90012 add tlff012,tlff013
           " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
           "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
           "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?)  "               #NO.FUN-620024 #FUN-980010 #CHI-9B0008  #FUN-B90012 add ?,?
 
 	 CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5        #FUN-920032
         CALL cl_parse_qry_sql(l_sql5,l_plant_new) RETURNING l_sql5 #FUN-A50102
         PREPARE ins_tlff FROM l_sql5
 
         EXECUTE ins_tlff USING 
            g_tlff.tlff01,g_tlff.tlff020,g_tlff.tlff02,g_tlff.tlff021,g_tlff.tlff022,
            g_tlff.tlff023,g_tlff.tlff024,g_tlff.tlff025,g_tlff.tlff026,g_tlff.tlff027,
            g_tlff.tlff03,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff034,
            g_tlff.tlff035,g_tlff.tlff036,g_tlff.tlff037,g_tlff.tlff04,g_tlff.tlff05,
            g_tlff.tlff06,g_tlff.tlff07,g_tlff.tlff08,g_tlff.tlff09,g_tlff.tlff10,
            g_tlff.tlff11,g_tlff.tlff12,g_tlff.tlff13,g_tlff.tlff14,g_tlff.tlff15,
            g_tlff.tlff16,g_tlff.tlff17,g_tlff.tlff18,g_tlff.tlff19,g_tlff.tlff20,
            g_tlff.tlff60,g_tlff.tlff61,g_tlff.tlff62,g_tlff.tlff63,g_tlff.tlff99, #No.8047
            g_tlff.tlff902,g_tlff.tlff903,g_tlff.tlff904,g_tlff.tlff905,g_tlff.tlff906,
            g_tlff.tlff907,g_tlff.tlff219,g_tlff.tlff220,g_tlff.tlff930,gp_plant, #NO.FUN-620024 #FUN-980010 #CHI-9B0008 add tlff930
            gp_legal,g_tlff.tlff012,g_tlff.tlff013                                #FUN-980010    #FUN-B90012 add tlff012,tlff013
         IF SQLCA.sqlcode<>0 THEN
            CALL cl_err('ins tlff:',SQLCA.sqlcode,1)
         IF g_bgerr THEN
           LET g_showmsg=g_tlff.tlff01,"/",g_tlff.tlff06
           CALL s_errmsg('tlff01,tlff06',g_showmsg,'ins tlff:',SQLCA.sqlcode,1)
         ELSE
           CALL cl_err('ins tlff:',SQLCA.sqlcode,1) 
         END IF
            LET g_success = 'N'
         END IF
      END FOR
      IF g_tlff.tlff907 <> 0 THEN                           #NO.FUN-620024
         CALL s_tlff3(p_unit,p_unit2,l_plant_new)           #FUN-980092 add
      END IF                                                #NO.FUN-620024
   END IF
 
END FUNCTION
 
FUNCTION p900_ima(p_part)
   DEFINE p_part    LIKE ima_file.ima01
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_ima25   LIKE ima_file.ima25
  # DEFINE l_qoh     LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_qoh     LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_ima86   LIKE ima_file.ima86
   DEFINE l_ima39   LIKE ima_file.ima39
   DEFINE l_ima35   LIKE ima_file.ima35
   DEFINE l_ima36   LIKE ima_file.ima36
   DEFINE l_sql1    STRING                 #MOD-9C0274
   DEFINE l_msg     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(50)
   DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044 
 
   #抓取料件相關資料
 #  LET l_sql1 = "SELECT ima02,ima25,ima261+ima262,ima86,ima39,", #FUN-A20044
   LET l_sql1 = "SELECT ima02,ima25,0,ima86,ima39,", #FUN-A20044
                "       ima35,ima36 ",
                #" FROM ",l_dbs_new CLIPPED,"ima_file ",
                " FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                " WHERE ima01='",p_part,"' " 
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE ima_pre FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN
        CALL s_errmsg('ima01',p_part,'ima_pre',SQLCA.SQLCODE,1)   
      ELSE 
         CALL cl_err('ima_pre',SQLCA.SQLCODE,1) 
      END IF
   END IF
 
   DECLARE ima_cs CURSOR FOR ima_pre
 
   OPEN ima_cs
 
   FETCH ima_cs INTO l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
   CALL s_getstock(p_part,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
   LET l_qoh = l_unavl_stk + l_avl_stk   #FUN-A20044
   IF SQLCA.SQLCODE <> 0 THEN
      LET l_msg = l_dbs_new,":",p_part
      IF g_bgerr THEN 
        CALL s_errmsg('ima01',p_part,l_msg,'axm-297',1)     
      ELSE 
        CALL cl_err(l_msg,'axm-297',1)
      END IF
      LET g_success='N'
   END IF
 
   CLOSE ima_cs
 
   RETURN l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
 
END FUNCTION
 
FUNCTION p900_chkoeo(p_oeo01,p_oeo03,p_oeo04)
   DEFINE p_oeo01   LIKE oeo_file.oeo01
   DEFINE p_oeo03   LIKE oeo_file.oeo03
   DEFINE p_oeo04   LIKE oeo_file.oeo04
   DEFINE l_sql     STRING                 #MOD-9C0274
   
   #LET l_sql=" SELECT COUNT(*) FROM ",l_dbs_new_tra,"oeo_file ", #FUN-980092 add
   LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeo_file'), #FUN-A50102
             "  WHERE oeo01 = '",p_oeo01,"'",
             "    AND oeo03 = '",p_oeo03,"'",
             "    AND oeo04 = '",p_oeo04,"'",
             "    AND oeo08 = '2' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
   PREPARE chkoeo_pre FROM l_sql
 
   DECLARE chkoeo_cs CURSOR FOR chkoeo_pre
 
   OPEN chkoeo_cs 
   FETCH chkoeo_cs INTO g_cnt
 
   IF g_cnt > 0 THEN
      RETURN 1 
   ELSE
      RETURN 0
   END IF
 
END FUNCTION 
 
# 取得多角序號
FUNCTION p900_flow99()
   DEFINE l_azi03   LIKE azi_file.azi03		#MOD-980118
   DEFINE l_azi04   LIKE azi_file.azi04		#MOD-980118
   DEFINE l_ogb03   LIKE ogb_file.ogb03		#MOD-980118
   DEFINE l_oeb03   LIKE oeb_file.oeb03		#MOD-980118
   DEFINE l_oeb13   LIKE oeb_file.oeb13		#MOD-980118
   DEFINE l_ogb917  LIKE ogb_file.ogb917	#MOD-980118
   DEFINE l_ogb14   LIKE ogb_file.ogb14		#MOD-980118
   DEFINE l_ogb14t  LIKE ogb_file.ogb14t	#MOD-980118
   DEFINE l_sql     STRING 			#MOD-980118
     
   IF cl_null(g_oga.oga99) THEN
      CALL s_flowauno('oga',g_oea.oea904,g_oga.oga02)
           RETURNING g_sw,g_flow99
      IF g_sw THEN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ',' ','tri-011',1) 
         ELSE
           CALL cl_err('','tri-011',1)
         END IF
         LET g_success = 'N' RETURN
      END IF
 
      UPDATE oga_file SET oga99 = g_flow99
       WHERE oga01 = g_oga.oga01
      IF SQLCA.SQLCODE THEN
         IF g_bgerr THEN
           CALL s_errmsg('oga01',g_oga.oga01,'upd oga99',SQLCA.SQLCODE,1)
         ELSE 
          CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd oga99",1)   
         END IF
         LET g_success = 'N'
         RETURN
      END IF
 
      #更新INVOICE ofa99
      IF NOT cl_null(g_oga.oga27) AND g_oax.oax04='Y' AND g_oaz.oaz67 = '2' THEN  #FUN-670007
         UPDATE ofa_file SET ofa99= g_flow99
          WHERE ofa01 = g_oga.oga27
         IF SQLCA.SQLCODE THEN
            IF g_bgerr THEN  
              CALL s_errmsg('ofa01',g_oga.oga27,'upd ofa99',SQLCA.SQLCODE,1) 
            ELSE 
              CALL cl_err3("upd","ofa_file",g_oga.oga27,"",SQLCA.SQLCODE,"","upd ofa99",1)   
            END IF
            LET g_success = 'N'
            RETURN
         END IF
      END IF
 
 
      #馬上檢查是否有搶號
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM oga_file 
       WHERE oga99 = g_flow99
         AND oga09 = tm.oga09
      IF g_cnt > 1 THEN
         IF g_bgerr THEN 
           LET g_showmsg=g_flow99,"/",tm.oga09     
           CALL s_errmsg('oga99,oga09',g_showmsg,'','tri-011',1)
         ELSE 
           CALL cl_err('','tri-011',1)
         END IF
         LET g_success = 'N'
         RETURN
      END IF
      LET l_sql = " SELECT ogb03,oeb03,oeb13,ogb917 ",
                  "   FROM ogb_file,oeb_file ",
                  "  WHERE ogb01 = '",g_oga.oga01,"' ",
                  "    AND ogb31 = oeb01 ", 
                  "    AND ogb32 = oeb03 ",  #MOD-990091        
                  " ORDER BY ogb03 " 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
      PREPARE ogb_upd_p FROM l_sql
      DECLARE ogb_upd_c CURSOR FOR ogb_upd_p
      FOREACH ogb_upd_c INTO l_ogb03,l_oeb03,l_oeb13,l_ogb917
         IF SQLCA.SQLCODE <>0 THEN
             EXIT FOREACH
         END IF 
         SELECT azi03,azi04 INTO l_azi03,l_azi04
           FROM azi_file
          WHERE azi01=g_oga.oga23
         CALL cl_digcut(l_oeb13,l_azi03)  RETURNING l_oeb13
         IF g_oga.oga213 = 'N' THEN
            LET l_ogb14  = l_ogb917 * l_oeb13  
            CALL cl_digcut(l_ogb14,l_azi04)  RETURNING l_ogb14
            LET l_ogb14t = l_ogb14 * (1+g_oga.oga211/100)
            CALL cl_digcut(l_ogb14t,l_azi04) RETURNING l_ogb14t
         ELSE 
            LET l_ogb14t = l_ogb917 * l_oeb13  
            CALL cl_digcut(l_ogb14t,l_azi04) RETURNING l_ogb14t
            LET l_ogb14  = l_ogb14t / (1+g_oga.oga211/100)
            CALL cl_digcut(l_ogb14,l_azi04)  RETURNING l_ogb14
         END IF
         UPDATE ogb_file SET ogb13 = l_oeb13,ogb14 = l_ogb14,ogb14t = l_ogb14t
          WHERE ogb01 = g_oga.oga01 AND ogb03 = l_ogb03
      END FOREACH
      CALL p900_oga50_sum(l_azi03,l_azi04) 
   END IF
 
END FUNCTION 
 
FUNCTION p900_oga50_sum(p_azi03,p_azi04)    
   DEFINE p_azi03    LIKE azi_file.azi03		
   DEFINE p_azi04    LIKE azi_file.azi04		
   DEFINE l_sum1     LIKE ogb_file.ogb14
   DEFINE l_sum1_t   LIKE ogb_file.ogb14t
   DEFINE l_sum      LIKE ogb_file.ogb14
   DEFINE l_sum_t    LIKE ogb_file.ogb14t
 
    SELECT SUM(ogb14),SUM(ogb14t) into l_sum1,l_sum1_t 
      FROM ogb_file 
     WHERE ogb01 = g_oga.oga01
       AND ogb1005 ='1'
 
    SELECT SUM(ogb14),SUM(ogb14t) into l_sum,l_sum_t 
      FROM ogb_file 
     WHERE ogb01 = g_oga.oga01
       AND ogb1005 ='2'
 
    IF cl_null(l_sum1) THEN 
       LET l_sum1 = 0 
    ELSE 
       CALL cl_digcut(l_sum1,p_azi04)  RETURNING l_sum1
    END IF
 
    IF cl_null(l_sum) THEN 
       LET l_sum = 0 
    ELSE 
       CALL cl_digcut(l_sum,p_azi04)  RETURNING l_sum
    END IF
 
    IF cl_null(l_sum1_t) THEN 
       LET l_sum1_t = 0 
    ELSE 
       CALL cl_digcut(l_sum1_t,p_azi04)  RETURNING l_sum1_t
    END IF
 
    IF cl_null(l_sum_t) THEN 
       LET l_sum_t = 0 
    ELSE 
       CALL cl_digcut(l_sum_t,p_azi04)  RETURNING l_sum_t
    END IF
 
    UPDATE oga_file SET oga50 = l_sum1,oga53 = l_sum1 - l_sum,oga1008 = l_sum1_t,oga1006 = l_sum,oga1007 = l_sum_t 
     WHERE oga01 = g_oga.oga01
END FUNCTION
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p900_chk99()
   DEFINE l_sql STRING                 #MOD-9C0274
 
       #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new_tra CLIPPED,"rva_file ", #FUN-980092 add
       LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'rva_file'), #FUN-A50102
                   "  WHERE rva99 ='",g_flow99,"'"
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
       PREPARE rvacnt_pre FROM l_sql
 
       DECLARE rvacnt_cs CURSOR FOR rvacnt_pre
 
       OPEN rvacnt_cs 
       FETCH rvacnt_cs INTO g_cnt                                #收貨單
 
       IF g_cnt > 0 THEN
          LET g_msg = l_dbs_new CLIPPED,'rva99 duplicate'
          IF g_bgerr THEN           
            CALL s_errmsg('rva99',g_flow99,g_msg,'tri-011',1)   
          ELSE 
            CALL cl_err(g_msg,'tri-011',1)
          END IF
          LET g_success = 'N'
       END IF
       #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new_tra CLIPPED,"rvu_file ", #FUN-980092 add
       LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
                   "  WHERE rvu99 ='",g_flow99,"'",
                   "    AND rvu00 = '1' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql    #FUN-980092 add
       PREPARE rvucnt_pre FROM l_sql
 
       DECLARE rvucnt_cs CURSOR FOR rvucnt_pre
 
       OPEN rvucnt_cs 
       FETCH rvucnt_cs INTO g_cnt                                #入庫單
 
       IF g_cnt > 0 THEN
          LET g_msg = l_dbs_new CLIPPED,'rvu99 duplicate'
          IF g_bgerr  THEN 
            LET g_showmsg=g_flow99,"/",1 
            CALL s_errmsg('rvu99,rvu00',g_showmsg,g_msg,'tri-011',1)     
          ELSE 
            CALL cl_err(g_msg,'tri-011',1)
          END IF
          LET g_success = 'N'
       END IF
 
       #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new_tra CLIPPED,"oga_file ", #FUN-980092 add
       LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                   "  WHERE oga99 ='",g_flow99,"'",
                   "    AND oga09 = '",tm.oga09,"'"
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql    #FUN-980092 add
       PREPARE ogacnt_pre FROM l_sql
 
       DECLARE ogacnt_cs CURSOR FOR ogacnt_pre
 
       OPEN ogacnt_cs 
       FETCH ogacnt_cs INTO g_cnt                                #出貨單
 
       IF g_cnt > 0 THEN
          LET g_msg = l_dbs_new CLIPPED,'oga99 duplicate'
          IF  g_bgerr THEN 
            LET g_showmsg=g_flow99,"/",tm.oga09                
            CALL s_errmsg('oga99,oga09',g_showmsg,g_msg,'tri-011',1)    
          ELSE
            CALL cl_err(g_msg,'tri-011',1)
          END IF
          LET g_success = 'N'
       END IF
 
END FUNCTION
 
FUNCTION p900_imgs(p_plant,p_ware,p_loca,p_lot,p_date,p_rvbs)  #No.FUN-A10099
   DEFINE p_plant  LIKE azp_file.azp01                         #No.FUN-A10099 atmt254也会call此function,故参数增加
   DEFINE p_rvbs   RECORD LIKE rvbs_file.*
   DEFINE p_ware   LIKE imgs_file.imgs02
   DEFINE p_loca   LIKE imgs_file.imgs03
   DEFINE p_lot    LIKE imgs_file.imgs04
   DEFINE p_date   LIKE tlfs_file.tlfs111
   DEFINE l_imgs   RECORD LIKE imgs_file.*
   DEFINE l_tlfs   RECORD LIKE tlfs_file.*
   DEFINE l_ima25  LIKE ima_file.ima25
   DEFINE l_ima35  LIKE ima_file.ima35		#TQC-9A0102
   DEFINE l_ima36  LIKE ima_file.ima36		#TQC-9A0102
   DEFINE l_ima02  LIKE ima_file.ima02		#TQC-9A0102
 #  DEFINE l_imaqty LIKE ima_file.ima262		#TQC-9A0102 #FUN-A20044
   DEFINE l_imaqty LIKE type_file.num15_3		#TQC-9A0102 #FUN-A20044
   DEFINE l_ima86  LIKE ima_file.ima86		#TQC-9A0102
   DEFINE l_ima39  LIKE ima_file.ima39		#TQC-9A0102
   DEFINE l_sql1,l_sql2       STRING            #MOD-9C0274
   DEFINE l_n      LIKE type_file.num5
   DEFINE p_dbs      LIKE type_file.chr21         #No.FUN-A10099
   DEFINE p_dbs_tra  LIKE type_file.chr21         #No.FUN-A10099
 
   #No.FUN-A10099  --Begin
   LET g_plant_new = p_plant
   CALL s_getdbs()     LET p_dbs     = g_dbs_new
   CALL s_gettrandbs() LET p_dbs_tra = g_dbs_tra
   #No.FUN-A10099  --End  

   LET l_sql1 = "SELECT COUNT(*) ",
             #  "  FROM ",l_dbs_new_tra CLIPPED,"imgs_file ", #FUN-980092 add  #No.FUN-A10099
                #"  FROM ",p_dbs_tra CLIPPED,"imgs_file ",     #No.FUN-A10099
                "  FROM ",cl_get_target_table(p_plant,'imgs_file'), #FUN-A50102
                " WHERE imgs01='",p_rvbs.rvbs021,"' ",
                "   AND imgs02='",p_ware,"'",
                "   AND imgs03='",p_loca,"'",
                "   AND imgs04='",p_lot,"'",
                "   AND imgs05='",p_rvbs.rvbs03,"'",
                "   AND imgs06='",p_rvbs.rvbs04,"'",
                "   AND imgs11='",p_rvbs.rvbs08,"'"
  
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1   #FUN-980092 add  #No.FUN-A10099
   PREPARE imgs_pre1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
         LET  g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04           
         CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_pre',SQLCA.SQLCODE,1)
      ELSE
        CALL cl_err('imgs_pre',SQLCA.SQLCODE,1)
      END IF
   END IF
  
   DECLARE imgs_cs CURSOR FOR imgs_pre1
  
   OPEN imgs_cs
   FETCH imgs_cs INTO l_n
  
   CALL p900_ima(p_rvbs.rvbs021)						#TQC-9A0102
      RETURNING l_ima02,l_ima25,l_imaqty,l_ima86,l_ima39,l_ima35,l_ima36	#TQC-9A0102
   IF l_n = 0 THEN
      LET l_imgs.imgs01 = p_rvbs.rvbs021
      LET l_imgs.imgs02 = p_ware
      LET l_imgs.imgs03 = p_loca
      LET l_imgs.imgs04 = p_lot
      LET l_imgs.imgs05 = p_rvbs.rvbs03
      LET l_imgs.imgs06 = p_rvbs.rvbs04
      LET l_imgs.imgs07 = l_ima25
      LET l_imgs.imgs08 = 0
      LET l_imgs.imgs09 = p_rvbs.rvbs05
      LET l_imgs.imgs10 = p_rvbs.rvbs07
      LET l_imgs.imgs11 = p_rvbs.rvbs08
  
  #   LET l_sql2 = "INSERT INTO ",l_dbs_new_tra CLIPPED,"imgs_file", #FUN-980092 add  #No.FUN-A10099
      #LET l_sql2 = "INSERT INTO ",p_dbs_tra CLIPPED,"imgs_file",     #No.FUN-A10099
      LET l_sql2 = "INSERT INTO ",cl_get_target_table(p_plant,'imgs_file'), #FUN-A50102
                   "(imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,",
                   " imgs07,imgs08,imgs09,imgs10,imgs11,",
                   " imgsplant,imgslegal)",   #FUN-980010
                   " VALUES( ?,?,?,?,?,?, ?,?,?,?,?,  ?,?)"  #FUN-980010
  
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,p_plant) RETURNING l_sql2 #FUN-A50102
      PREPARE ins_imgs FROM l_sql2
  
      EXECUTE ins_imgs USING l_imgs.imgs01,l_imgs.imgs02,l_imgs.imgs03,
                             l_imgs.imgs04,l_imgs.imgs05,l_imgs.imgs06,
                             l_imgs.imgs07,l_imgs.imgs08,l_imgs.imgs09,
                             l_imgs.imgs10,l_imgs.imgs11,
                             gp_plant,gp_legal   #FUN-980010
      IF SQLCA.sqlcode<>0 THEN
      #  LET g_msg = l_dbs_new CLIPPED,'ins imgs'  #No.FUN-A10099
         LET g_msg = p_dbs CLIPPED,'ins imgs'      #No.FUN-A10099
         IF g_bgerr THEN
            LET g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04           
            CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_ins',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err("imgs_ins",SQLCA.sqlcode,1)
         END IF
         LET g_success = 'N'
      END IF
   END IF  
 
   LET l_tlfs.tlfs01=p_rvbs.rvbs021       #異動料件編號
   LET l_tlfs.tlfs02=p_ware                #倉庫
   LET l_tlfs.tlfs03=p_loca                #儲位
   LET l_tlfs.tlfs04=p_lot                 #批號
   LET l_tlfs.tlfs05=p_rvbs.rvbs03         #序號
   LET l_tlfs.tlfs06=p_rvbs.rvbs04         #外部批號
  #MOD-C30663 str------
  #LET l_tlfs.tlfs07=l_ima25
   SELECT img09 INTO l_tlfs.tlfs07 FROM img_file
    WHERE img01 = l_tlfs.tlfs01 AND img02 = l_tlfs.tlfs02
      AND img03 = l_tlfs.tlfs03 AND img04 = l_tlfs.tlfs04
  #MOD-C30663 end------
   LET l_tlfs.tlfs08=p_rvbs.rvbs00
 
   CASE l_tlfs.tlfs08
      WHEN "apmt300"    #收貨單
         LET l_tlfs.tlfs09=0
      WHEN "apmt740"    #入庫單
         LET l_tlfs.tlfs09=1
      WHEN "axmt820"    #銷售出貨單
         LET l_tlfs.tlfs09=-1
      WHEN "axmt821"    #代採出貨單
         LET l_tlfs.tlfs09=-1
   END CASE
 
   LET l_tlfs.tlfs10=p_rvbs.rvbs01
   LET l_tlfs.tlfs11=p_rvbs.rvbs02
   LET l_tlfs.tlfs111=p_date
   LET l_tlfs.tlfs12=g_today
   LET l_tlfs.tlfs13=p_rvbs.rvbs06
   LET l_tlfs.tlfs14=p_rvbs.rvbs07
   LET l_tlfs.tlfs15=p_rvbs.rvbs08
 
 # LET l_sql2 = "INSERT INTO ",l_dbs_new_tra CLIPPED,"tlfs_file", #FUN-980092 add  #No.FUN-A10099
   LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'tlfs_file'), #FUN-A50102
                "(tlfs01,tlfs02,tlfs03,tlfs04,tlfs05,tlfs06,tlfs07,",
                " tlfs08,tlfs09,tlfs10,tlfs11,tlfs12,tlfs13,tlfs14,",
                " tlfs15,tlfs111,",
                " tlfsplant,tlfslegal)",
                " VALUES( ?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,  ?,?)" #FUN-980010
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ins_tlfs FROM l_sql2
 
   EXECUTE ins_tlfs USING l_tlfs.tlfs01,l_tlfs.tlfs02,l_tlfs.tlfs03,
                          l_tlfs.tlfs04,l_tlfs.tlfs05,l_tlfs.tlfs06,
                          l_tlfs.tlfs07,l_tlfs.tlfs08,l_tlfs.tlfs09,
                          l_tlfs.tlfs10,l_tlfs.tlfs11,l_tlfs.tlfs12,
                          l_tlfs.tlfs13,l_tlfs.tlfs14,l_tlfs.tlfs15,
                          l_tlfs.tlfs111,
                          gp_plant,gp_legal   #FUN-980010
 
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
        LET g_showmsg=l_tlfs.tlfs01,"/",l_tlfs.tlfs12
        CALL s_errmsg('tlfs01,tlfs06',g_showmsg,'ins tlfs:',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err('ins tlfs:',SQLCA.sqlcode,1) 
      END IF
      LET g_success = 'N'
   END IF
   
END FUNCTION
 
FUNCTION p900_exp_delivery()
  DEFINE l_sql STRING
  DEFINE l_cnt LIKE type_file.num5
  DEFINE li_result LIKE type_file.num5 
  DEFINE sm RECORD
         slip     LIKE oay_file.oayslip
         END RECORD
  DEFINE l_n   LIKE type_file.num5 
 
 
  LET begin_no = NULL    
  LET end_no = NULL      
 
  LET p_row = 5 LET p_col = 11
 
  OPEN WINDOW p900_exp_w AT p_row,p_col WITH FORM "axm/42f/axmp900g"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axmp900g")
 
   INPUT BY NAME sm.slip
      AFTER FIELD slip
         IF NOT cl_null(sm.slip) THEN
            LET g_cnt = 0
            CALL s_check_no("axm",sm.slip,"","50","","","")
                 RETURNING li_result,sm.slip
 
            IF (NOT li_result) THEN
               CALL cl_err(sm.slip,'aap-010',0)
               NEXT FIELD slip
            END IF
         END IF
         LET g_slip = sm.slip
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         CLOSE WINDOW p900_exp_w
         RETURN
      END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(slip)
                 LET sm.slip=s_get_doc_no(sm.slip)
                 CALL q_oay(FALSE,FALSE,sm.slip,'50','AXM') RETURNING sm.slip
                 CALL FGL_DIALOG_SETBUFFER(sm.slip)
                 DISPLAY BY NAME sm.slip
                 NEXT FIELD slip
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()    
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      ROLLBACK WORK
      CLOSE WINDOW t400global_exp_po
      RETURN
   END IF
 
      LET l_sql  = "SELECT pmn24 ",                    
                   #"  FROM ",l_dbs_new_tra CLIPPED,"pmn_file,",
                   #          l_dbs_new_tra CLIPPED,"pmm_file",
                   "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",", #FUN-A50102
                             cl_get_target_table(l_plant_new,'pmm_file'),     #FUN-A50102
                   " WHERE pmn01 = pmm01 AND pmm909 = '3' ",                                       
                   "   AND pmm99 ='",g_oea.oea99,"'",                            
                   "   AND pmn24 IS NOT NULL AND pmn25 IS NOT NULL "
      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-980092 add
  PREPARE p900_pmn24 FROM l_sql
 
      IF SQLCA.SQLCODE THEN
         IF g_bgerr THEN
          LET g_showmsg=g_oea.oea99
          CALL s_errmsg('pmn01,pmn99,pmn02',g_showmsg,'pmn24_p1',SQLCA.SQLCODE,1) 
         ELSE 
          CALL cl_err('pmn24_p1',SQLCA.SQLCODE,1)
         END IF 
      END IF
      
  DECLARE pmn_curs CURSOR FOR p900_pmn24
  
  LET g_success = 'Y'
  LET l_n = 0
 
  FOREACH pmn_curs INTO g_pmn24
      IF SQLCA.SQLCODE <> 0 THEN
         IF g_bgerr THEN 
          CALL s_errmsg('pmn01,pmn99,pmn02',g_showmsg,'pmn24_c1',SQLCA.SQLCODE,1) 
         END IF 
         LET g_success='N'
         EXIT FOREACH
      END IF    
 
    CALL p900_exp_oga(g_pmn24)
    IF g_success = 'N' THEN
      EXIT FOREACH
    END IF
    LET l_n = l_n + 1
  END FOREACH
  IF l_n = 0 THEN
     LET g_success = 'N'
  END IF 
  IF g_success = 'Y' THEN
    MESSAGE '已轉出貨單'
     IF NOT cl_null(begin_no) THEN
       LET g_msg = begin_no CLIPPED,"~",end_no CLIPPED
       CALL cl_err(g_msg CLIPPED,"mfg0101",1)
     END IF
  END IF
 
  CLOSE WINDOW p900_exp_w
END FUNCTION
 
FUNCTION p900_exp_oga(p_oea01)
  DEFINE p_oea01 LIKE oea_file.oea01
  DEFINE l_sql STRING
  DEFINE l_oea RECORD LIKE oea_file.*
  DEFINE l_oga RECORD LIKE oga_file.*
  DEFINE li_result    LIKE type_file.num5
  DEFINE l_date1,l_date2,l_date3  LIKE oga_file.oga11
 
   #LET l_sql= "SELECT * FROM ",l_dbs_new_tra CLIPPED,"oea_file ", #FUN-980092 add
   LET l_sql= "SELECT * FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
              " WHERE oea01 = '",p_oea01,"' "
   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-980092 add
   PREPARE oea_p2 FROM l_sql
   DECLARE oea_curs2 CURSOR FOR oea_p2   
   OPEN oea_curs2
   FETCH oea_curs2 INTO l_oea.*
   CLOSE oea_curs2  
  
  LET l_oga.oga00 = l_oea.oea00        #出貨別
  CALL s_auto_assign_no("axm",g_slip,g_today,"","oga_file","oga01",l_plant_new,"","") #FUN-980092 add
     RETURNING li_result,l_oga.oga01                        
  IF (NOT li_result) THEN 
     LET g_msg = l_plant_new CLIPPED,l_oga.oga01
     CALL s_errmsg("oga01",l_oga.oga01,g_msg CLIPPED,"mfg3046",1) 
     LET g_success ='N'
     RETURN
  END IF   
  #LET l_oga.oga02  = g_today #TQC-C70078
  LET l_oga.oga02  = l_rvu.rvu03 #入庫时间 TQC-C70078
  LET l_oga.oga03  = l_oea.oea03
  LET l_oga.oga032 = l_oea.oea032
  LET l_oga.oga033 = l_oea.oea033
  LET l_oga.oga04  = l_oea.oea04
  LET l_oga.oga044 = l_oea.oea044
  LET l_oga.oga05  = l_oea.oea05
  LET l_oga.oga06  = '0'            #修改版本
  LET l_oga.oga07  = l_oea.oea07
  LET l_oga.oga08  = l_oea.oea08
  LET l_oga.oga09  = '2'            #出貨單
  LET l_oga.oga10  = ''             #帳單編號     
  #LET l_sql= "SELECT occ67 FROM ",l_dbs_new CLIPPED,"occ_file ",
  LET l_sql= "SELECT occ67 FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102
             " WHERE occ01 = '",l_oea.oea03,"' ",
             "   AND occ1004 = '1' AND occ06 = '1' AND occacti = 'Y'"   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
  PREPARE oga13_p2 FROM l_sql
  DECLARE oga13_curs2 CURSOR FOR oga13_p2   
  OPEN oga13_curs2
  FETCH oga13_curs2 INTO l_oga.oga13
  CLOSE oga13_curs2               
  LET l_oga.oga14  = l_oea.oea14     
  LET l_oga.oga15  = l_oea.oea15
  LET l_oga.oga16  = l_oea.oea01     #訂單編號
  LET l_oga.oga161 = l_oea.oea161
  LET l_oga.oga162 = l_oea.oea162
  LET l_oga.oga163 = l_oea.oea163
  LET l_oga.oga17  = 0
  LET l_oga.oga18  = l_oea.oea17
  LET l_oga.oga19 = null      
  LET l_oga.oga20  = 'Y'
  LET l_oga.oga21  = l_oea.oea21
  LET l_oga.oga211 = l_oea.oea211
  LET l_oga.oga212 = l_oea.oea212
  LET l_oga.oga213 = l_oea.oea213
  LET l_oga.oga23  = l_oea.oea23    
  LET l_oga.oga24  = l_oea.oea24
  LET l_oga.oga25  = l_oea.oea25
  LET l_oga.oga26  = l_oea.oea26
  LET l_oga.oga27  = ''
  LET l_oga.oga29  = 0             #信用額度餘額
  LET l_oga.oga30  = 'N'           #包裝單確認碼
  LET l_oga.oga31  = l_oea.oea31
  LET l_oga.oga32  = l_oea.oea32
  LET l_oga.oga33  = l_oea.oea33
  LET l_oga.oga34  = l_oea.oea34
  LET l_oga.oga41  = l_oea.oea41
  LET l_oga.oga42  = l_oea.oea42
  LET l_oga.oga43  = l_oea.oea43
  LET l_oga.oga44  = l_oea.oea44
  LET l_oga.oga45  = l_oea.oea45
  LET l_oga.oga46  = l_oea.oea46
  LET l_oga.oga49  = l_oea.oea35
  LET l_oga.oga50  = 0           #原幣金額
  LET l_oga.oga52  = 0           #原幣預收訂金轉銷貨收入金額
  LET l_oga.oga53  = 0           #原幣應開發票未稅金額
  LET l_oga.oga54  = 0           #原幣已開發票未稅金額
  LET l_oga.oga99  = ''          #多角貿易流程序號
  LET l_oga.oga901 = 'N'         #post to abx sys flag
  LET l_oga.oga902 = ''          #信用超限留置代碼
  LET l_oga.oga903 = 'N'         #信用查核放行否
  LET l_oga.oga905 = 'N'         #已轉三角貿易出貨單否
  LET l_oga.oga906 = l_oea.oea906
  LET l_oga.oga909 = 'N'    
  LET l_oga.oga914 = l_rvu.rvu01 #入庫單號     
  #LET l_sql= "SELECT tuo04,tuo05 FROM ",l_dbs_new CLIPPED,"tuo_file ",
  LET l_sql= "SELECT tuo04,tuo05 FROM ",cl_get_target_table(l_plant_new,'tuo_file'), #FUN-A50102
             " WHERE tuo01 = '",l_oea.oea03,"' " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
  PREPARE oga90_p2 FROM l_sql
  DECLARE oga90_curs2 CURSOR FOR oga90_p2   
  OPEN oga90_curs2
  FETCH oga90_curs2 INTO l_oga.oga910,l_oga.oga911
  CLOSE oga90_curs2    
  LET l_oga.ogaconf = 'N'
  LET l_oga.ogapost = 'N'
  LET l_oga.ogaprsw = 0
  LET l_oga.ogauser = g_user
  LET l_oga.ogagrup = g_grup
  LET l_oga.ogadate = g_today
  LET l_oga.oga55   = '0'
  LET l_oga.oga57   = '1'           #FUN-AC0055 add
  LET l_oga.oga65   = 'N'
  #LET l_sql= "SELECT oayapr FROM ",l_dbs_new CLIPPED,"oay_file ",
  LET l_sql= "SELECT oayapr FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102
             " WHERE oayslip = '",g_slip,"' " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
  PREPARE oga91_p2 FROM l_sql
  DECLARE oga91_curs2 CURSOR FOR oga91_p2   
  OPEN oga91_curs2
  FETCH oga91_curs2 INTO l_oga.ogamksg
  CLOSE oga91_curs2  
  LET l_oga.oga1001 = l_oea.oea1001
  LET l_oga.oga1002 = l_oea.oea1002
  LET l_oga.oga1003 = l_oea.oea1003
  LET l_oga.oga1004 = l_oea.oea1004
  LET l_oga.oga1005 = l_oea.oea1005
  LET l_oga.oga1016 = l_oea.oea1015
  LET l_oga.ogaspc  = '0'
  LET l_oga.oga69   = g_today
  LET l_oga.oga021  = ''   
  LET l_oga.oga11 = NULL
  LET l_oga.oga12 = NULL
  LET l_oga.ogaud01 = l_oea.oeaud01
  LET l_oga.ogaud02 = l_oea.oeaud02
  LET l_oga.ogaud03 = l_oea.oeaud03
  LET l_oga.ogaud04 = l_oea.oeaud04
  LET l_oga.ogaud05 = l_oea.oeaud05
  LET l_oga.ogaud06 = l_oea.oeaud06
  LET l_oga.ogaud07 = l_oea.oeaud07
  LET l_oga.ogaud08 = l_oea.oeaud08
  LET l_oga.ogaud09 = l_oea.oeaud09
  LET l_oga.ogaud10 = l_oea.oeaud10
  LET l_oga.ogaud11 = l_oea.oeaud11
  LET l_oga.ogaud12 = l_oea.oeaud12
  LET l_oga.ogaud13 = l_oea.oeaud13
  LET l_oga.ogaud14 = l_oea.oeaud14
  LET l_oga.ogaud15 = l_oea.oeaud15
 
   #LET l_sql ="INSERT INTO ",l_dbs_new_tra CLIPPED,"oga_file", #FUN-980092 add
   LET l_sql ="INSERT INTO ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
              "( oga00,oga01,oga011,oga02, ",
              "  oga021,oga022,oga03,oga032,",
              "  oga033,oga04,oga044,oga05,",
              "  oga06,oga07,oga08,oga09,",
              "  oga10,oga11,oga12,oga13,",
              "  oga14,oga15,oga16,oga161,",
              "  oga162,oga163,oga17,oga18,",
              "  oga19,oga20,oga21,oga211,",
              "  oga212,oga213,oga23,oga24,",
              "  oga25,oga26,oga27,oga28,",
              "  oga29,oga30,oga31,oga32,",
              "  oga33,oga34,oga35,",
              "  oga36,oga37,oga38,oga39,",
              "  oga40,oga41,oga42,oga43,",
              "  oga44,oga45,oga46,oga47,",
              "  oga48,oga49,oga50,oga52,",
              "  oga53,oga54,oga55,oga57,oga69,",  #FUN-AC0055 add oga57       
              "  oga65,oga99,",                      
              "  oga901,oga902,oga914,",
              "  oga903,oga904,oga905,oga906,", 
              "  oga907,oga908,oga909,oga1001,",                    
              "  oga1002,oga1003,oga1004,oga1005,",                
              "  oga1006,oga1007,oga1008,oga1009,",                
              "  oga1010,oga1011,oga1012,oga1013,",               
              "  oga1014,oga1015,ogaconf,",          
              "  ogapost,ogaprsw,ogauser,ogagrup,",
              "  ogamodu,ogadate,ogamksg, ",         
              "  ogaplant,ogalegal, ",
              "  ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,",
              "  ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,",
              "  ogaud11,ogaud12,ogaud13,ogaud14,ogaud15,ogaoriu,ogaorig)", #FUN-A10036
              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,", 
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",     #No.CHI-950020 
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",    
                       "?,?,?,?, ?,?, ?,?,?,? ) "    #FUN-980010 #FUN-A10036
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE ins_oga1 FROM l_sql
 
   EXECUTE ins_oga1 USING 
         l_oga.oga00,l_oga.oga01,l_oga.oga011,l_oga.oga02, 
         l_oga.oga021,l_oga.oga022,l_oga.oga03,l_oga.oga032,
         l_oga.oga033,l_oga.oga04,l_oga.oga044,l_oga.oga05,
         l_oga.oga06,l_oga.oga07,l_oga.oga08,l_oga.oga09,
         l_oga.oga10,l_oga.oga11,l_oga.oga12,l_oga.oga13,
         l_oga.oga14,l_oga.oga15,l_oga.oga16,l_oga.oga161,
         l_oga.oga162,l_oga.oga163,l_oga.oga17,l_oga.oga18,
         l_oga.oga19,l_oga.oga20,l_oga.oga21,l_oga.oga211,
         l_oga.oga212,l_oga.oga213,l_oga.oga23,l_oga.oga24,
         l_oga.oga25,l_oga.oga26,l_oga.oga27,l_oga.oga28,
         l_oga.oga29,l_oga.oga30,l_oga.oga31,l_oga.oga32,
         l_oga.oga33,l_oga.oga34,l_oga.oga35,
         l_oga.oga36,l_oga.oga37,l_oga.oga38,l_oga.oga39,
         l_oga.oga40,l_oga.oga41,l_oga.oga42,l_oga.oga43,
         l_oga.oga44,l_oga.oga45,l_oga.oga46,l_oga.oga47,
         l_oga.oga48,l_oga.oga49,l_oga.oga50,l_oga.oga52,
         l_oga.oga53,l_oga.oga54,l_oga.oga55,l_oga.oga57,l_oga.oga69,     #FUN-AC0055 add l_oga.oga57
         l_oga.oga65,l_oga.oga99,   
         l_oga.oga901,l_oga.oga902,l_oga.oga914,
         l_oga.oga903,l_oga.oga904,l_oga.oga905,l_oga.oga906,
         l_oga.oga907,l_oga.oga908,l_oga.oga909,l_oga.oga1001,    
         l_oga.oga1002,l_oga.oga1003,l_oga.oga1004,l_oga.oga1005, 
         l_oga.oga1006,l_oga.oga1007,l_oga.oga1008,l_oga.oga1009, 
         l_oga.oga1010,l_oga.oga1011,l_oga.oga1012,l_oga.oga1013, 
         l_oga.oga1014,l_oga.oga1015,l_oga.ogaconf,               
         l_oga.ogapost,l_oga.ogaprsw,l_oga.ogauser,l_oga.ogagrup,
         l_oga.ogamodu,l_oga.ogadate,l_oga.ogamksg, 
         gp_plant,gp_legal   #FUN-980010
        ,l_oga.ogaud01,l_oga.ogaud02,l_oga.ogaud03,l_oga.ogaud04,l_oga.ogaud05,
         l_oga.ogaud06,l_oga.ogaud07,l_oga.ogaud08,l_oga.ogaud09,l_oga.ogaud10,
         l_oga.ogaud11,l_oga.ogaud12,l_oga.ogaud13,l_oga.ogaud14,l_oga.ogaud15,g_user,g_grup #FUN-A10036
  
  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
     CALL cl_err3("ins","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","ins oga",1)
     LET g_success = 'N'
  ELSE
     IF cl_null(begin_no) THEN
        LET begin_no = l_oga.oga01
     END IF
     LET end_no=l_oga.oga01
     CALL p900_exp_ogb(l_oga.oga01,p_oea01)
  END IF
 
END FUNCTION
 
FUNCTION p900_exp_ogb(p_oga01,p_oea01)
  DEFINE p_oga01  LIKE oga_file.oga01
  DEFINE p_oea01  LIKE oea_file.oea01
  DEFINE l_sql    STRING
  DEFINE l_oeb    RECORD LIKE oeb_file.*,
         l_ogb    RECORD LIKE ogb_file.*
  DEFINE l_ima35  LIKE ima_file.ima35,
         l_ima36  LIKE ima_file.ima36
  DEFINE l_ima02  LIKE ima_file.ima02
  DEFINE l_ima25  LIKE ima_file.ima25
 # DEFINE l_imaqty LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_imaqty LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_ima86  LIKE ima_file.ima86
  DEFINE l_ima39  LIKE ima_file.ima39
  DEFINE l_flag   SMALLINT      
  DEFINE l_ogb03  LIKE ogb_file.ogb03
  DEFINE l_oea211 LIKE oea_file.oea211,
         l_oea213 LIKE oea_file.oea213  
# DEFINE l_oia07   LIKE oia_file.oia07     #FUN-C50136
  DEFINE l_oga14  LIKE oga_file.oga14     #FUN-CB0087
  DEFINE l_oga15  LIKE oga_file.oga15     #FUN-CB0087
  
   LET l_sql  = "SELECT oea211,oea213 ",
                #"  FROM ",l_dbs_new_tra CLIPPED,"oea_file ", #FUN-980092 add
                "  FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                " WHERE oea01 = '",p_oea01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql  #FUN-980092 add
   PREPARE oea_p5 FROM l_sql
   DECLARE oea_c5 CURSOR FOR oea_p5
   OPEN oea_c5
   FETCH oea_c5 INTO l_oea211,l_oea213      
         
  LET l_ogb03 = 0
              
  LET l_sql = "SELECT oeb_file.* ",
              #"  FROM ",l_dbs_new_tra CLIPPED,"pmn_file,",
              #          l_dbs_new_tra CLIPPED,"oeb_file ",
              "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",", #FUN-A50102
                        cl_get_target_table(l_plant_new,'oeb_file'),     #FUN-A50102
              " WHERE pmn24 = oeb01 AND pmn25 = oeb03 ",
              "   AND pmn24 ='", p_oea01 CLIPPED, "'",
              "   AND oeb70 <>'Y' "              
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql   #FUN-980092 add
  PREPARE ogb_pre6 FROM l_sql
  DECLARE ogb_curs6 CURSOR FOR ogb_pre6
  FOREACH ogb_curs6 INTO l_oeb.*
    LET l_ogb03 = l_ogb03 + 1
    LET l_ogb.ogb01 = p_oga01
    LET l_ogb.ogb03 = l_ogb03
    LET l_ogb.ogb04 = l_oeb.oeb04
    LET l_ogb.ogb05 = l_oeb.oeb05
    LET l_ogb.ogb05_fac = l_oeb.oeb05_fac
    LET l_ogb.ogb06 = l_oeb.oeb06
    LET l_ogb.ogb07 = l_oeb.oeb07
    LET l_ogb.ogb08 = l_oeb.oeb08    
    LET l_sql  = "SELECT ima15,ima36 ",
                 #"  FROM ",l_dbs_new CLIPPED,"ima_file ",
                 "  FROM ",cl_get_target_table(l_plant_new,'ima_file'),     #FUN-A50102
                 " WHERE ima01 = '",l_oeb.oeb04,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE ima_p5 FROM l_sql
    DECLARE ima_c5 CURSOR FOR ima_p5
    OPEN ima_c5
    FETCH ima_c5 INTO l_ima35,l_ima36
    IF cl_null(l_ima35) THEN LET l_ima35=' ' END IF
    IF cl_null(l_ima36) THEN LET l_ima36=' ' END IF       
    LET l_ogb.ogb09 = l_oeb.oeb09
    LET l_ogb.ogb091 = l_oeb.oeb091
    IF cl_null(l_ogb.ogb09) THEN LET l_ogb.ogb09 = l_ima35 END IF
    IF cl_null(l_ogb.ogb091) THEN LET l_ogb.ogb091 = l_ima36 END IF
    LET l_ogb.ogb092 = l_oeb.oeb092        
    LET l_ogb.ogb11 = l_oeb.oeb11
    LET l_ogb.ogb12 = l_rvv.rvv17
    LET l_ogb.ogb12 = s_digqty(l_ogb.ogb12,l_ogb.ogb05) #FUN-BB0083 add
    LET l_ogb.ogb13 = l_oeb.oeb13              
    LET l_sql  = "SELECT img09 ",
                 #"  FROM ",l_dbs_new_tra CLIPPED,"img_file ", #FUN-980092 add
                 "  FROM ",cl_get_target_table(l_plant_new,'img_file'), #FUN-A50102
                 " WHERE img01 = '",l_oeb.oeb04,"' ",
                 "   AND img02 = '",l_ogb.ogb09,"' ",
                 "   AND img03 = '",l_ogb.ogb091,"' ",
                 "   AND img04 = '",l_ogb.ogb092,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
    PREPARE img_p5 FROM l_sql
    DECLARE img_c5 CURSOR FOR img_p5
    OPEN img_c5
    FETCH img_c5 INTO l_ogb.ogb15                     
    LET l_ogb.ogb15_fac = 1
    LET l_ogb.ogb16 = l_rvv.rvv17
    LET l_ogb.ogb16 = s_digqty(l_ogb.ogb16,l_ogb.ogb15) #FUN-BB0083 add
    LET l_ogb.ogb17 = 'N'
    LET l_ogb.ogb18 = l_rvv.rvv17    
    #MOD-C10124 mark----------------------------
    #SELECT rvb39 INTO l_ogb.ogb19 FROM rvb_file
    # WHERE rvb04 = l_rvv.rvv36 AND rvb03 = l_rvv.rvv37    
    #LET l_sql  = "SELECT rvb39 ",
    #             #"  FROM ",l_dbs_new_tra CLIPPED,"rvb_file ", #FUN-980092 add
    #             "  FROM ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
    #             " WHERE rvb04 = '",l_rvv.rvv36,"' ",
    #             "   AND rvb03 = '",l_rvv.rvv37,"' "
    #     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    #CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
    #PREPARE ogb19_p5 FROM l_sql
    #DECLARE ogb19_c5 CURSOR FOR ogb19_p5
    #OPEN ogb19_c5
    #FETCH ogb19_c5 INTO l_ogb.ogb19            
    #MOD-C10124 mark end------------------------
    LET l_ogb.ogb19 = l_oeb.oeb906  #MOD-C10124 add             
    LET l_ogb.ogb31 = l_oeb.oeb01
    LET l_ogb.ogb32 = l_oeb.oeb03
    LET l_ogb.ogb60 = 0
    LET l_ogb.ogb63 = 0
    LET l_ogb.ogb64 = 0
    LET l_ogb.ogb908 = l_oeb.oeb908
    LET l_ogb.ogb910 = l_rvv.rvv80
    LET l_ogb.ogb911 = l_rvv.rvv81
    LET l_ogb.ogb912 = l_rvv.rvv82
    LET l_ogb.ogb913 = l_rvv.rvv83
    LET l_ogb.ogb914 = l_rvv.rvv84
    LET l_ogb.ogb915 = l_rvv.rvv85
    LET l_ogb.ogb916 = l_rvv.rvv86
    LET l_ogb.ogb917 = l_rvv.rvv87
    LET l_ogb.ogb65  = ''
    LET l_ogb.ogb41 = l_oeb.oeb41    
    LET l_ogb.ogb42 = l_oeb.oeb42  
    LET l_ogb.ogb43 = l_oeb.oeb43   
    LET l_ogb.ogb1001 = l_oeb.oeb1001 
    IF cl_null(l_ogb.ogb1001) THEN LET l_ogb.ogb1001 = g_poy.poy28 END IF  #TQC-D40064 add
    LET l_ogb.ogb1002 = l_oeb.oeb1002
    LET l_ogb.ogb1003 = l_oeb.oeb15
    LET l_ogb.ogb1004 = l_oeb.oeb1004
    LET l_ogb.ogb1005 = '1'
    LET l_ogb.ogb1006 = l_oeb.oeb1006
    LET l_ogb.ogb1007 = l_oeb.oeb1007
    LET l_ogb.ogb1008 = l_oeb.oeb1008
    LET l_ogb.ogb1009 = l_oeb.oeb1009
    LET l_ogb.ogb1010 = l_oeb.oeb1010
    LET l_ogb.ogb1012 = 'N'
    LET l_ogb.ogb1013 = '0'
    LET l_ogb.ogb1014 = 'N'
    LET l_ogb.ogb14  = l_ogb.ogb917*l_ogb.ogb13
    LET l_ogb.ogb14t = l_ogb.ogb14*(1+l_oea211/100)
    LET l_ogb.ogbud01 = l_oeb.oebud01
    LET l_ogb.ogbud02 = l_oeb.oebud02
    LET l_ogb.ogbud03 = l_oeb.oebud03
    LET l_ogb.ogbud04 = l_oeb.oebud04
    LET l_ogb.ogbud05 = l_oeb.oebud05
    LET l_ogb.ogbud06 = l_oeb.oebud06
    LET l_ogb.ogbud07 = l_oeb.oebud07
    LET l_ogb.ogbud08 = l_oeb.oebud08
    LET l_ogb.ogbud09 = l_oeb.oebud09
    LET l_ogb.ogbud10 = l_oeb.oebud10
    LET l_ogb.ogbud11 = l_oeb.oebud11
    LET l_ogb.ogbud12 = l_oeb.oebud12
    LET l_ogb.ogbud13 = l_oeb.oebud13
    LET l_ogb.ogbud14 = l_oeb.oebud14
    LET l_ogb.ogbud15 = l_oeb.oebud15
#FUN-AB0061 -----------add start---------------- 
    LET l_ogb.ogb37 = l_oeb.oeb37                             
    IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
       LET l_ogb.ogb37=l_ogb.ogb13                         
    END IF                                                                             
#FUN-AB0061 -----------add end----------------  
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 -----------add start-------------
#   IF cl_null(l_ogb.ogb50) THEN
#      LET l_ogb.ogb50 = '1'
#   END IF
##FUN-AB0096 ----------add end------------------- 
#FUN-AC0055 mark ----------------------end------------------------
     #FUN-C50097 ADD BEGIN-----
     IF cl_null(l_ogb.ogb50) THEN 
       LET l_ogb.ogb50 = 0
     END IF 
     IF cl_null(l_ogb.ogb51) THEN 
       LET l_ogb.ogb51 = 0
     END IF 
     IF cl_null(l_ogb.ogb52) THEN 
       LET l_ogb.ogb52 = 0
     END IF             
     IF cl_null(l_ogb.ogb53) THEN 
       LET l_ogb.ogb53 = 0
     END IF 
     IF cl_null(l_ogb.ogb54) THEN 
       LET l_ogb.ogb54 = 0
     END IF 
     IF cl_null(l_ogb.ogb55) THEN 
       LET l_ogb.ogb55 = 0
     END IF                              
     #FUN-C50097 ADD END------- 

     #TQC-D20047--add--str--
     LET l_sql = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
     PREPARE aza115_pr4 FROM l_sql
     EXECUTE aza115_pr4 INTO g_aza.aza115   
     #TQC-D20047--add--end--
     #FUN-CB0087--add--str--
     #IF g_aza.aza115='Y' THEN                            #TQC-D40064 mark
     IF g_aza.aza115='Y' AND cl_null(l_ogb.ogb1001) THEN  #TQC-D40064 add
        #TQC-D20050--mod--str--
        SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
        CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
        LET l_sql="SELECT oga14,oga15 FROM ",cl_get_target_table(l_plant_new,'oga_file')," WHERE oga01 ='",l_ogb.ogb01,"'"
        PREPARE ogb1001_pr3 FROM l_sql
        EXECUTE ogb1001_pr3 INTO l_oga14,l_oga15
        CALL s_reason_code1(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15,l_plant_new) RETURNING l_ogb.ogb1001 
        #TQC-D20050--mod--end--
        IF cl_null(l_ogb.ogb1001) THEN
           CALL cl_err(l_ogb.ogb1001,'aim-425',1)
           LET g_success="N"
           RETURN
        END IF
     END IF
     #FUN-CB0087--add--end--
   #新增出貨單身檔  
   #LET l_sql ="INSERT INTO ",l_dbs_new_tra CLIPPED,"ogb_file", #FUN-980092 add
   LET l_sql ="INSERT INTO ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
              "(ogb01,ogb03,ogb04,ogb05, ",
              " ogb05_fac,ogb06,ogb07,ogb08, ",
              " ogb09,ogb091,ogb092,ogb11, ",
              " ogb12,ogb37,ogb13,ogb14,ogb14t,",#FUN-AB0061 
              " ogb15,ogb15_fac,ogb16,ogb17, ",
              " ogb18,ogb19,ogb20,ogb31,",
              " ogb32,ogb60,ogb63,ogb64,",
              " ogb901,ogb902,ogb903,ogb904,",
              " ogb905,ogb906,ogb907,ogb908,",
              " ogb909,ogb910,ogb911,ogb912,",
              " ogb913,ogb914,ogb915,ogb916,",
              " ogb917,ogb1001,ogb1002,ogb1003,",                           
              " ogb1004,ogb1005,ogb1007,ogb1008,",                         
              " ogb1009,ogb1010,ogb1011,ogb1012,ogb1006,ogb1014,",      
              " ogbplant,ogblegal,",
              " ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",
              " ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",
              " ogbud11,ogbud12,ogbud13,ogbud14,ogbud15,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",      #FUN-C50097 ADD 50,51,52 ,ogb50,ogb51,ogb52 
              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ",  
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",     #No.CHI-950020 
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?, ?,?,?, ?,?,?, ?,?,?) "  #FUN-980010#FUN-AB0061    #FUN-AB0096 add ?  #FUN-C50097 ADD 50,51,52 , ?,?,?, ?,?,? 
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE ins_ogb1 FROM l_sql  
   EXECUTE ins_ogb1 USING 
     l_ogb.ogb01,l_ogb.ogb03,l_ogb.ogb04,l_ogb.ogb05, 
     l_ogb.ogb05_fac,l_ogb.ogb06,l_ogb.ogb07,l_ogb.ogb08, 
     l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb11, 
     l_ogb.ogb12,l_ogb.ogb37,l_ogb.ogb13,l_ogb.ogb14,l_ogb.ogb14t,#FUN-AB0061 
     l_ogb.ogb15,l_ogb.ogb15_fac,l_ogb.ogb16,l_ogb.ogb17, 
     l_ogb.ogb18,l_ogb.ogb19,l_ogb.ogb20,l_ogb.ogb31,
     l_ogb.ogb32,l_ogb.ogb60,l_ogb.ogb63,l_ogb.ogb64,
     l_ogb.ogb901,l_ogb.ogb902,l_ogb.ogb903,l_ogb.ogb904,
     l_ogb.ogb905,l_ogb.ogb906,l_ogb.ogb907,l_ogb.ogb908,
     l_ogb.ogb909,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,
     l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_ogb.ogb916,
     l_ogb.ogb917,l_ogb.ogb1001,l_ogb.ogb1002,l_ogb.ogb1003,      
     l_ogb.ogb1004,l_ogb.ogb1005,l_ogb.ogb1007,l_ogb.ogb1008,    
     l_ogb.ogb1009,l_ogb.ogb1010,l_ogb.ogb1011,l_ogb.ogb1012,l_ogb.ogb1006,l_ogb.ogb1014,
     gp_plant,gp_legal   #FUN-980010
    ,l_ogb.ogbud01,l_ogb.ogbud02,l_ogb.ogbud03,l_ogb.ogbud04,l_ogb.ogbud05,
     l_ogb.ogbud06,l_ogb.ogbud07,l_ogb.ogbud08,l_ogb.ogbud09,l_ogb.ogbud10,
     l_ogb.ogbud11,l_ogb.ogbud12,l_ogb.ogbud13,l_ogb.ogbud14,l_ogb.ogbud15,
     l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52,l_ogb.ogb53,l_ogb.ogb54,l_ogb.ogb55  #FUN-C50097 ADD 50,51,52 ,l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52
 
   IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3]=0 THEN
      LET g_msg = l_dbs_new CLIPPED,'ins l_ogb'
 
      IF g_bgerr THEN
         LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03,"/",l_ogb.ogb04  
         CALL s_errmsg('ogb01,ogb03,ogb04',g_showmsg,g_msg,SQLCA.sqlcode,1)
      ELSE
         CALL cl_err(g_msg,SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
#  #FUN-C50136----add----str----
#  ELSE
#     IF g_oaz.oaz96 ='Y' THEN
#        CALL s_ccc_oia07('D',l_oga.oga03) RETURNING l_oia07
#        IF l_oia07 = '0' THEN
#           CALL s_ccc_oia(l_oga.oga03,'D',l_oga.oga01,0,l_plant_new)
#        END IF
#     END IF
#  #FUN-C50136----add----end----
   END IF
  END FOREACH 
  IF g_success = 'Y' THEN
    CALL p900_upd_oga(p_oga01)
  END IF
END FUNCTION
 
FUNCTION p900_upd_oga(p_oga01)
  DEFINE p_oga01  LIKE oga_file.oga01
  DEFINE l_oga50  LIKE oga_file.oga50,
         l_oga51  LIKE oga_file.oga51,
         l_oga52  LIKE oga_file.oga52,
         l_oga53  LIKE oga_file.oga53,
         l_oga161 LIKE oga_file.oga161,
         l_oga162 LIKE oga_file.oga162,
         l_oga163 LIKE oga_file.oga163
  DEFINE l_sql    STRING
 
   LET l_oga50 = NULL
   LET l_oga161= NULL    
   LET l_oga162= NULL   
   LET l_oga163= NULL    
    
   #LET l_sql= "SELECT SUM(ogb14) FROM ",l_dbs_new_tra CLIPPED,"ogb_file ", #FUN-980092 add
   LET l_sql= "SELECT SUM(ogb14) FROM ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
              " WHERE ogb01 = '",p_oga01,"' "
   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
   PREPARE ogb_p2 FROM l_sql
   DECLARE ogb_curs2 CURSOR FOR ogb_p2   
   OPEN ogb_curs2
   FETCH ogb_curs2 INTO l_oga50
   CLOSE ogb_curs2    
 
   IF cl_null(l_oga50) THEN LET l_oga50 = 0 END IF
 
   #LET l_sql= "SELECT oga161,oga162,oga163 FROM ",l_dbs_new_tra CLIPPED,"oga_file ", #FUN-980092 add
   LET l_sql= "SELECT oga161,oga162,oga163 FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
              " WHERE oga01 = '",p_oga01,"' "
   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
   PREPARE oga_p2 FROM l_sql
   DECLARE oga_curs2 CURSOR FOR oga_p2   
   OPEN oga_curs2
   FETCH oga_curs2 INTO l_oga161,l_oga162,l_oga163
   CLOSE oga_curs2     
     
   IF cl_null(l_oga161) THEN LET l_oga161 = 0 END IF 
   IF cl_null(l_oga162) THEN LET l_oga162 = 0 END IF 
   IF cl_null(l_oga163) THEN LET l_oga163 = 0 END IF 
   LET l_oga52 = l_oga50 * l_oga161/100
   LET l_oga53 = l_oga50 * (l_oga162+l_oga163)/100
    
       #LET l_sql="UPDATE ",l_dbs_new_tra CLIPPED,"oga_file", #FUN-980092 add
       LET l_sql="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                  " SET oga50='",l_oga50,"', ",
                  "     oga52='",l_oga52,"', ",
                  "     oga53='",l_oga53,"' ",
                  " WHERE oga01 = '",p_oga01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092 add
       PREPARE upd_oga1 FROM l_sql
       EXECUTE upd_oga1
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
          IF g_bgerr THEN
             CALL s_errmsg('ima01',l_ogb.ogb04,'upd ima',STATUS,1)
          ELSE
             CALL cl_err('upd ima:',STATUS,1)
          END IF
          LET g_success='N'
       END IF
 
END FUNCTION
#參考 sapmt110_sub.4gl
FUNCTION p900_get_rvb39(p_rvb03,p_rvb04,p_rvb05,p_rvb19,p_rva05,p_sma886) 
   DEFINE l_pmh08   LIKE pmh_file.pmh08,    
          l_pmm22   LIKE pmm_file.pmm22,
          p_rvb03   LIKE rvb_file.rvb03,   
          p_rvb04   LIKE rvb_file.rvb04,
          p_rvb05   LIKE rvb_file.rvb05,
          p_rvb19   LIKE rvb_file.rvb19,
          l_rvb39   LIKE rvb_file.rvb39,
          p_rva05   LIKE rva_file.rva05,
          p_sma886  LIKE sma_file.sma886
   DEFINE l_ima915  LIKE ima_file.ima915  
   DEFINE l_pmm02   LIKE pmm_file.pmm02    
   DEFINE l_type    LIKE type_file.chr1   
   DEFINE l_pmn41   LIKE pmn_file.pmn41  
   DEFINE l_pmn43   LIKE pmn_file.pmn43 
   DEFINE l_ecm04   LIKE ecm_file.ecm04   
   DEFINE l_pmn18   LIKE pmn_file.pmn18  
   DEFINE l_sql     STRING     
   DEFINE l_pmn012  LIKE pmn_file.pmn012   #FUN-A60076 add
 
   #料件供應商控制方式: 0.不管制、1.請購單需管制、2.採購單需管制、3.二者皆需管制
   LET l_sql = "SELECT ima24,ima915 ",
               #"  FROM ",l_dbs_new CLIPPED,"ima_file ",
               "  FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
               " WHERE ima01 = '",p_rvb05,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE ima02_pre FROM l_sql
   EXECUTE ima02_pre INTO l_pmh08,l_ima915 
 
   IF l_ima915='2' OR l_ima915='3' THEN
      LET l_sql = "SELECT pmm02,pmm22,pmn41,pmn43,pmn18,pmn012 ",           #FUN-A60076 add pmn012          
                  #"  FROM ",l_dbs_new CLIPPED,"pmn_file,",
                  #          l_dbs_new CLIPPED,"pmm_file ",
                  "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",", #FUN-A50102
                            cl_get_target_table(l_plant_new,'pmm_file'),     #FUN-A50102
                  " WHERE pmm01 = '",p_rvb04,"'",
                  "   AND pmn01 = pmm01 AND pmn02 = ",p_rvb03  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE pmm01_pre FROM l_sql
      EXECUTE pmm01_pre INTO l_pmm02,l_pmm22,l_pmn41,l_pmn43,l_pmn18,l_pmn012   #FUN-A60076  add l_pmn012 
 
      IF l_pmm02='SUB' THEN
         LET l_type='2'
         IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
            LET l_ecm04=' '
         ELSE
            IF NOT cl_null(l_pmn18) THEN
               LET l_sql = "SELECT sgm04 ",
                           #"  FROM ",l_dbs_new CLIPPED,"sgm_file ",
                           "  FROM ",cl_get_target_table(l_plant_new,'sgm_file'),     #FUN-A50102
                           " WHERE sgm01 = '",l_pmn18,"'",
                           "   AND sgm02 = '",l_pmn41,"'",  
                           "   AND sgm03 =  ",l_pmn43  
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
               PREPARE sgm_pre FROM l_sql
               EXECUTE sgm_pre INTO l_ecm04 
            ELSE
               LET l_sql = "SELECT ecm04 ",
                           #"  FROM ",l_dbs_new CLIPPED,"ecm_file ",
                           "  FROM ",cl_get_target_table(l_plant_new,'ecm_file'),     #FUN-A50102
                           " WHERE ecm01 = '",l_pmn41,"'",
                           "   AND ecm012 = '",l_pmn012,"'",                          #FUN-A60076
                           "   AND ecm03 =  ",l_pmn43  
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
               PREPARE ecm_pre FROM l_sql
               EXECUTE ecm_pre INTO l_ecm04 
            END IF
         END IF   
      ELSE
         LET l_type='1'
         LET l_ecm04=' '
      END IF
      LET l_sql = "SELECT pmh08 ",
                  #"  FROM ",l_dbs_new CLIPPED,"pmh_file ",
                  "  FROM ",cl_get_target_table(l_plant_new,'pmh_file'),     #FUN-A50102
                  " WHERE pmh01 = '",p_rvb05,"'",
                  "   AND pmh02 = '",p_rva05,"'",           #MOD-9B0100 
                  "   AND pmh13 = '",l_pmm22,"'",           #MOD-9B0100 
                  "   AND pmh21 = '",l_ecm04,"'",           #MOD-9B0100
                  "   AND pmh22 = '",l_type,"'",            #MOD-9B0100
                  "   AND pmhacti =  'Y'"  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE pmh_pre FROM l_sql
      EXECUTE pmh_pre INTO l_pmh08 
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   ELSE
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   END IF
 
   IF l_pmh08='N' OR     #免驗料
      (p_sma886[6,6]='N' AND p_sma886[8,8]='N') OR #視同免驗
      p_rvb19='2' THEN #委外代買料
      LET l_rvb39 = 'N'
   ELSE
      LET l_rvb39 = 'Y'
   END IF
 
   RETURN l_rvb39
 
END FUNCTION
#No.FUN-9C0073 ---------------By chenls  10/01/06
