# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Descriptions...: 客戶主檔維護作業
# Date & Author..: 94/12/22 by Nick
# Modify.........: 95/08/29 By Danny (修改畫面)
# Modify.........: 95/11/07 By Danny 1.加occ57製作包裝單否之欄位)
#                                    2.加occ48,occ49,occ42之欄位判斷
#                  1.occ01改為10碼,occ61改為10碼
#                  2.信用額度拋轉
# Modify.........: 97/06/17 By Lynn 信用評等(occ61) 若輸入則須存在信用查核檔
# Modify.........: No.2581 98/10/21 By Star 增加關係人否欄位
# Modify.........: No.3612 01/09/26 By Carol 增加7.資料拋轉功能
# Modify.........: No.3614 01/09/26 By Carol 增加額度客戶欄位
# Modify.........: No:8184 03/09/10 By Mandy 7.資料拋轉  按^P查詢時 -> CALL q_azp 的display 錯誤,應為:DISPLAY tm.plant[l_c] TO s_plant[l_s].plant
# Modify.........: No:8362 03/09/29 By Mandy 客戶全名無法印出
# Modify.........: No:8372 03/10/01 By Melody 性質(occ06)欄位在做新增及修改時，
#                  畫面occ6_ds沒有做display動作(Genero occ6_ds已拿掉不適用)
# Modify.........: No.9076 04/03/17 By Melody 加入insert azo_file
# Modify.........: No:A086 04/06/23 By Danny 增加自動編碼
# Modify.........: No.MOD-470041 04/07/19 By Wiky 修改INSERT INTO...
# Modify.........: No.A112 04/05/26 By Carrier Add occ31 庫存管理否
# Modify.........: No.MOD-490356 04/09/21 By Wiky 區域,國別應代出名稱,檢查統一編號重複(警告)
# Modify.........: No.MOD-4A0047 Kammy 拋轉資料選Update時，會有upd ocd..的error
# Modify.........: No.FUN-4A0013 Carol construct add call q_occ()
# Modify.........: No.MOD-4A0073 04/10/13 By Nicola 客戶資料拋轉中的小視窗目前以英文顯示
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: No.MOD-4B0240 04/11/30 By Mandy 客戶類別輸入代碼後，應該自動帶出類別說明資料。(增加顯示)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-4B0241 04/12/13 By Mandy 性質欄選取 2送貨客戶時，會卡在只能輸入「送貨客戶」==> 錯誤。應改為只能輸入「收款客戶」，而非「送貨客戶」。
#                  2005/01/05 alex FUN-4C0104 修改 4js bug 定義超長
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: NO.MOD-530303 05/03/25 By Mandy 功能鍵:客戶Remark無法執行
# Modify.........: NO.MOD-530410 05/03/26 By Mandy 慣用發票別請預設值帶1
# Modify.........: NO.MOD-530303 05/03/29 By Mandy 1.區域開窗時會篩選出有效的區域編號, 但直接輸入時未檢查區域編號是否有效.
#                                                  2.國別開窗時會篩選出有效的國別編號, 但直接輸入時未檢查國別編號是否有效.
#                                                  3.慣用幣別開窗時會篩選出有效的幣別代碼, 但直接輸入時未檢查幣別代碼是否有效.
#                                                  4.初次交易,最近報價/接單/出貨/收款要不允許修改.
# Modify.........: No.FUN-550091 05/05/26 By Smapmin 單身新增地區欄位
# Modify.........: NO.MOD-570176 05/07/27 By Nicola 選擇國別後，自動帶出區域編號
# Modify.........: NO.MOD-540056 05/08/04 By Nicola 額度大於0 then 幣別不可空白
# Modify.........: NO.MOD-580081 05/08/10 By Rosayu 慣用條件設定(慣用銷售分類)一定要打值,沒有提示訊息
# Modify.........: NO.MOD-570108 05/08/20 By alex  修正 530303 改錯部份
# Modify.........: NO.MOD-590138 05/09/12 BY yiting 1.客戶性質改為「收款客戶」後，無法再改回「買受人」，需離開後才能再次修改。
#                   2. 月結日、付款日輸入日期欄需檢查不得為無效值(需介於 1~31 )。
# Modify.........: NO.MOD-5A0070 05/10/06 BY Nicola 地址列印方式修改
# Modify.........: NO.MOD-570248 05/10/07 By Mandy 客戶簡稱若有資料重複，出現的訊息 "資料重複,請檢查主鍵欄位資料 !"，請改為 " 資料重複,請檢查客戶簡稱欄位資料 !"
# Modify.........: NO.MOD-590029 05/10/19 By Nicola 錯誤訊息修改
# Modify.........: NO.MOD-5A0173 05/10/24 By Rosayu 1.客戶簡稱不可給空字串
#                  2.若使用客戶編號自動編碼功能,一些原本程式判斷欄位不可空白的功能會有問題,客戶簡稱,銷售分類
# Modify.........: No.TQC-5A0115 05/11/15 By Nicola 國別顯示錯誤
# Modify.........: No.TQC-5B0192 05/11/30 By Nicola 地區,國別,區域 查詢時其說明沒有show出
# Modify.........: No.FUN-610020 06/01/04 By Carrier 出貨驗收功能 -- 新增occ65
# Modify.........: No.FUN-620063 06/02/27 By saki 自訂欄位功能
# Modify.........: No.FUN-630027 06/03/10 By Sarah 增加occ66(代送商),occ31改成"客戶銷售庫存管理否"
# Modify.........: No.FUN-590083 06/03/15 By Alexstar 增加多語言資料功能
# Modify.........: No.FUN-640014 06/04/06 By Sarah 將occ66開窗使用q_pmc7改成q_pmc8
# Modify.........: No.TQC-640052 06/04/08 By Echo 新增完一筆資料後,馬上用列印功能,無法印出資料!
# Modify.........: No.TQC-640053 06/04/08 By Echo '客戶聯絡人' & '客戶其它地址'  INSERT 不成功
# Modify.........: No.FUN-640011 06/04/08 By yoyo 把axmi221和atmi200合并
# Modify.........: No.MOD-640199 06/04/09 By yoyo 分銷時的客戶聯絡人界面離開按鈕灰掉
# Modify.........: No.MOD-640228 06/04/10 By yoyo 分銷時資料必須為審核才能拋磚
# Modify.........: No.TQC-640084 06/04/13 By yoyo 審核時拿掉對定價的check
# Modify.........: No.FUN-640038 06/04/19 By Sarah 輸入時回頭清掉原廠商代號時，廠商名稱不會清掉
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.MOD-640535 06/05/16 By pengu 信用查核打勾時,信用評等,幣別不可空白
# Modify.........: No.FUN-570065 06/05/22 By kim 在客戶主檔新增"預設科目別"
# Modify.........: No.FUN-4C0102 06/05/24 By kim 增加複製的功能
# Modify.........: No.TQC-650089 06/05/24 By yoyo  資料拋轉，無法新增,更新時沒有更新新增的欄位,客戶性質更改為4.開票客戶后，更其它的性質判斷方式不一致
# Modify.........: No.FUN-650182 06/06/07 By sam_lin 資料拋轉選擇更新時若不存在於目的資料庫則將其INSERT到目的資料庫中!
# Modify.........: No.FUN-660042 06/06/14 By Sarah 1.新增客戶時,'客戶銷售庫存管理否'應預設為'N'
#                                                  2.按複製後,新增的那筆客戶的送貨客戶應預設為新的客戶代號,而不是原來的送貨客戶
# Modify.........: No.TQC-660075 06/06/15 By Pengu FUN-650182 add 的程式段內sql語法應透過ora轉換
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: NO.FUN-680010 06/08/08 By Joe SPC整合專案-基本資料傳遞
# Modify.........: NO.FUN-690021 06/09/01 By Mandy 客戶主檔申請作業
# Modify.........: No.FUN-680137 06/09/15 By bnlent 欄位型態用LIKE定義
# Modify.........: No.TQC-680107 06/09/22 By Rayven 刪除時同時刪除定價資料和債權資料
# Modify.........: No.TQC-690035 06/10/03 By Sarah 1.大陸版(aza26='2')才檢查發票全稱沒有維護
#                                                  2.拿掉檢查有沒有維護客戶其他地址(atm-049)的部份
# Modify.........: No.FUN-6A0007 06/10/25 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.TQC-6B0103 06/11/20 By alexstar 做 'R' delete 時,相關多語言檔(gbc_file)需要一併處理
# Modify.........: No.FUN-6B0079 06/12/01 By jamie 新增action"相關文件"
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.TQC-6B0148 07/01/10 By rainy 資料拋轉客戶主檔時會錯誤跳開
# Modify.........: No.MOD-720063 07/02/07 By claire 新增時客戶簡稱帶出客戶代碼
# Modify.........: No.FUN-720014 07/03/01 By rainy 客戶的發票地址和送貨地址擴充為5欄255
# Modify.........: No.MOD-720053 07/03/01 By claire 額度客戶<>客戶編號時,occ63可允許輸入0
# Modify.........: No.FUN-730018 07/03/26 By kim 行業別架構
# Modify.........: No.MOD-740031 07/04/10 By claire 新增時未檢查統一編號
# Modify.........: No.TQC-740073 07/04/12 By wujie  修改審核時對發票全稱的判斷
# Modify.........: No.TQC-740140 07/04/19 By Mandy 不使用流通配銷,不使用客戶申請,按確認時,最後無法確認,出現atm-066 的錯誤訊息
# Modify.........: No.TQC-740137 07/04/21 By Carrier 打印時加一個有效標志位
# Modify.........: No.CHI-740027 07/04/26 By Mandy 當aoos010設定為走客戶申請流程時，不可使用複製功能
# Modify.........: No.TQC-750108 07/05/21 By rainy 5.0複測
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760150 07/08/08 By claire 性質為2時應default送貨客戶,性質為3時應default收款客戶
# Modify.........: No.MOD-780257 07/08/28 By claire 複製功能無法連續使用二次
# Modify.........: No.MOD-790130 07/09/26 By claire 統一編號邏輯性檢查調整
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7B0080 07/11/16 By saki 自定義欄位功能修改
# Modify.........: No.TQC-7B0112 07/11/19 By wujie 在流通配銷參數打開的情況下，“客戶屬性”標簽頁上所有的欄位除了“更改訂單單價”是必填項外，其他都改成非必填項
# Modify.........: No.TQC-7B0163 07/11/30 By wujie 客戶資料庫拋轉時，SELECT語句報錯（-254) ins ds6:occ 指定的主機變數太多或太少．
# Modify.........: No.FUN-7C0004 07/12/05 By rainy 新增Action 內部交易資料維護 pov
# Modify.........: No.TQC-7C0090 07/12/08 By wujie 取消FUN-690022 使用流通配銷功能 add if 判斷
# Modify.........: No.MOD-7C0124 07/12/20 By claire 在informix資料判斷統一編號長度時會連空白字元一併算入
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0010 08/02/20 By Carrier 資料中心功能
# Modify.........: No.FUN-830090 08/03/26 By Carrier 修改s_axmi221_carry的參數
# Modify.........: NO.FUN-840018 08/04/07 BY yiting 增加一個頁面放置清單資料
# Modify.........: NO.FUN-840033 08/04/08 BY yiting axmp221 call axmi221 add cust_detail
# Modify.........: No.MOD-840192 08/04/20 By Carrier mark'信用額度更新'action
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: NO.FUN-860036 08/06/17 by kim  MDM 整合 for GP5.1
# Modify.........: NO.FUN-850147 08/06/23 by Echo 新增 TIPTOP & MDM 整合
# Modify.........: NO.FUN-840183 08/07/07 by xiaofeizhu 新增occ68,occ69兩個攔位 
# Modify.........: NO.CHI-860015 08/07/08 by xiaofeizhu 客戶集團碼開窗
# Modify.........: No.FUN-830154 08/04/15 By destiny 報表改為CR輸出
#                                08/08/18 By Cockroach 5X-->5.1X
# Modify.........: No.FUN-870166 08/08/22 By kevin 改為call aws_mdmdata
# Modify.........: No.CHI-880031 08/09/09 By xiaofeizhu 查出資料后,應該停在第一筆資料上,不必預設是看資料清單,有需要瀏覽,再行點選
# Modify.........: No.FUN-870101 08/09/10 By jamie MES整合
# Modify.........: No.MOD-890143 08/09/19 By Smapmin 已確認的資料不可刪除
# Modify.........: No.FUN-890113 08/10/27 By kevin 移除MDM刪除功能
# Modify.........: No.TQC-8B0011 08/11/05 BY duke 呼叫MES前先判斷aza90必須MATCHE [Yy]
# Modify.........: No.MOD-8B0218 08/11/21 By Smapmin 修改後,離開程式再執行程式進行查詢後,資料並未修正
# Modify.........: No.MOD-8C0249 08/12/25 By Smapmin 新增時,如果性質是買受人,客戶簡稱無法帶出.
# Modify.........: No.MOD-910146 09/01/13 By Smapmin 將occ1001/occ1002從畫面上拿掉
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920219 09/02/17 By Smapmin 複製後輸入客戶編號其收款客戶要default為客戶編號
# Modify.........: No.FUN-930006 09/03/03 By mike 對于跨庫的SQL語句，去掉冒號，用s_dbstring()包起dbname
# Modify.........: No.TQC-930017 09/03/04 By chenyu 無效的資料不可以刪除
# Modify.........: No.FUN-930106 09/03/19 By destiny pov12增加管控
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-950005 09/05/05 By Dido i221_cl 使用後需搭配 加上 roll back 或者 CLOSE i221_cl
# Modify.........: No.MOD-960248 09/06/24 By Dido 1.若因重複而重新編碼時不可清空客戶簡稱
#                                                 2.送貨客戶與收款客戶依客戶性質設定
# Modify.........: No.MOD-960249 09/06/24 By Dido 若 occ06 為 '1' 時,一律更新 occ07,occ09
# Modify.........: No.FUN-870100 09/07/15 By Cockroach 零售
# Modify.........: No.MOD-970184 09/07/23 By sabrina occ55在uni區無泰文選項，將occ55改為動態抓取語言還項
# Modify.........: No.FUN-980018 09/08/04 By mike 於客戶主檔維護中下方慣用條件設定內其慣用交運方式、慣用運送起點、慣用運送起點、卸貨
# Modify.........: No.FUN-980010 09/08/21 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980221 09/08/24 By sherry 慣用條件設置頁簽“折扣率%”欄位小於0及大於100沒有控管！
# Modify.........: No.TQC-980153 09/08/31 By lilingyu "慣用發票別"欄位需開窗
                        
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-980222 09/08/24 By Carrier 加上AFTER FIELD 集團碼的判斷
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.TQC-9A0020 09/10/09 By lilingyu 過單
# Modify.........: NO.FUN-990069 09/10/12 By baofei 增加子公司可新增資料的檢查
# Modify.........: No.FUN-990031 09/10/15 By lutingting新增欄位occ73以交款金額產生應收
# Modify.........: No:TQC-9B0147 09/11/18 By sherry 加上寬限天數不為負數的控管
# Modify.........: NO.FUN-9C0109 09/12/23 By lutingting 以交款金額產生應收只有在零售業時才顯示 
# Modify.........: NO.TQC-A10018 10/01/08 By lilingyu"慣用傭金率"未控管負數和大于100的值
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:FUN-9C0071 10/01/15 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A30030 10/03/15 By Cockroach err_msg:aim-944-->art-648
# Modify.........: No:FUN-A30110 10/04/12 By Carrier 客户/厂商简称修改
# Modify.........: No:MOD-A50036 10/05/07 By Smapmin 連續列印二次就無法印出來
# Modify.........: No:MOD-A40187 10/05/10 By Smapmin 複製時,會計/狀態分頁內的日期欄位要清空
# Modify.........: No:TQC-A50069 10/05/19 By lilingyu 新增時,慣用發票別occ08不應該給預設值:1
# Modify.........: No.FUN-A50102 10/06/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A50012 10/06/24 By chenls 增加按鈕 --補貨換貨設定
# Modify.........: No:CHI-A60017 10/07/13 By Summer 將axm-052的判斷式mark掉
# Modify.........: No:MOD-A70076 10/07/29 By Smapmin 資料清單頁籤需要有基本功能action可使用
# Modify.........: No:FUN-A70130 10/08/12 By huangtao 修改開窗q_oay5
# Modify.........: No:FUN-A80073 10/08/20 By wangxin 客戶資料來源為商戶資料, 禁止在本作業維護
# Modify.........: No:TQC-AA0053 10/10/11 By houlia construct段添加occoriu、occorig字段
# Modify.........: No:FUN-AA0078 10/10/27 By wangxin MARK“FUN-A50012：增加按鈕 --補貨換貨設定”功能
# Modify.........: No.TQC-960216 10/11/08 By sabrina _copy()時不與MES、SPC做整合 
# Modify.........: No.FUN-AB0080 10/11/17 By sabrina 新增電子發票設定頁面 
# Modify.........: No:TQC-AB0087 10/11/26 By wangxin BUG修改
# Modify.........: No:MOD-B30027 11/03/07 By Summer 複製時occ1022發票客戶編號未一起更新，使得後續產生帳款時收款客戶會異常
# Modify.........: No:MOD-B30480 11/03/14 By sabrina 輸入的總店號若不為有效資料，則不可使用
# Modify.........: No:FUN-A50078 11/03/22 By chenying 取消確認時需判斷訂單資料及出貨單資料是否已存在
# Modify.........: No:MOD-B30641 11/03/22 By lilingyu 已有訂單資料,不可刪除
# Modify.........: No:FUN-9A0056 11/03/30 By abby MES功能調整
# Modify.........: No:FUN-B50023 11/05/03 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-9C0089 11/05/04 By suncx 新增資料清單的excel匯出功能
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70075 11/07/26 By baogc 添加已傳POS否的狀態4.修改中，不下傳
# Modify.........: No:TQC-BB0002 11/01/01 By Carrier MISC/EMPL简称修改时,不进行各资料档案的UPDATE
# Modify.........: No:FUN-BB0049 11/11/15 By Carrier aza125='Y'&厂商及客户编号相同时,简称需保持相同,若为'N',则不需有此管控
#                                                    aza126='Y'&厂商客户简称修改后,需更新历史资料
# Modify.........: No:CHI-BA0022 11/12/12 By Vampire 加上occ01做排序
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B90105 11/09/20 By linlin 根據期貨或是現貨的折扣率，計算訂單售價
# Modify.........: No:FUN-BC0065 12/01/15 By Abby 當系統有與CRM整合時,客戶做留置/取消留置/停止交易/恢復交易動作時，需同步通知CRM
# Modify.........: No:CHI-BB0034 12/02/02 By ck2yuan 只有在查詢時才出現9025警告，其他action不需要

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30314 12/03/10 By xumeimei 新增客戶資料時Default客戶類型為 2.帳款客戶
# Modify.........: No:MOD-C40104 12/04/16 by SunLM 刪除資料時,業態判斷
# Modify.........: No:TQC-C50154 12/05/17 By zhuhao 信用額度修改時，同步更新資料更改者，資料更改日期。
# Modify.........: No:FUN-C50036 12/05/22 By yangxf 隐藏收取比例栏位，默认为0
# Modify.........: No:FUN-C50070 12/06/05 By Sakura 修改aza50判斷,統一call customer_address1,並將開啟的畫面加入ocd230及ocd231欄位
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C50136 12/06/26 By xujing 信用管控處理
# Modify.........: No.FUN-C80019 12/08/16 By pauline 集團碼開放可輸入自己的編號
# Modify.........: No:FUN-C80046 12/08/22 By bart 複製後停在新資料畫面
# Modify.........: No:TQC-D10038 13/01/08 by SunLM 已经审核的客户联系人可以更改
# Modify.........: No.MOD-CC0094 13/01/31 By jt_chen 移除營業執照有效日期相關欄位(occ1001/occ1002;occa1001/occa1002)
# Modify.........: No:FUN-CC0080 13/03/13 By Elise 異動時寫入aooq030異動作業
# Modify.........: No:CHI-B60094 13/03/22 By Elise s_cusqry加傳參數
# Modify.........: No.MOD-D30241 13/03/27 By bart 修改停留在資料清單頁籤 需按兩次 esc才能關閉主程式

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-7C0010
 
DEFINE
    tm              RECORD
        plant              ARRAY[20] OF LIKE imd_file.imd01,  #No.FUN-680137 VARCHAR(10)
        dbs                ARRAY[20] OF LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)
                    END RECORD,
    g_occ           RECORD LIKE occ_file.*,
    g_occ_t         RECORD LIKE occ_file.*,
    g_occ_ct        RECORD LIKE occ_file.*,
    g_occ01_t              LIKE occ_file.occ01,
    g_wc,g_sql             string,  #No.FUN-580092 HCN
    g_argv1                LIKE occ_file.occ01,
    g_buf                  LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(40)
    p_row,p_col            LIKE type_file.num5,    #No.FUN-680137 SMALLINT
    g_forupd_sql           STRING,          #SELECT ... FOR UPDATE SQL
    g_before_input_done    LIKE type_file.num5,    #No.FUN-680137 SMALLINT
    g_on_change            LIKE type_file.num5    #No.FUN-680137 SMALLINT   #FUN-590083
DEFINE g_argv2             LIKE type_file.chr1    #no.FUN-840033
DEFINE  g_occ_l       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      occ01_l     LIKE occ_file.occ01,
                      occ02_l     LIKE occ_file.occ02,
                      occ03_l     LIKE occ_file.occ03,
                      occ04_l     LIKE occ_file.occ04,
                      occ05_l     LIKE occ_file.occ05,
                      occ06_l     LIKE occ_file.occ06,
                      occ22_l     LIKE occ_file.occ22,
                      occ21_l     LIKE occ_file.occ21,
                      occ20_l     LIKE occ_file.occ20,
                      occ11_l     LIKE occ_file.occ11,
                      occ1004_l   LIKE occ_file.occ1004,
                      occacti_l   LIKE occ_file.occacti,
                      occ246_l    LIKE occ_file.occ246
                      END RECORD
DEFINE  g_occ_x       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      sel         LIKE type_file.chr1,
                      occ01       LIKE occ_file.occ01
                      END RECORD
#DEFINE g_tqo          DYNAMIC ARRAY OF RECORD
#                      sel      LIKE type_file.chr1,
#                      tqo01    LIKE tqo_file.tqo01,
#                      tqo02    LIKE tqo_file.tqo02
#                      END RECORD
DEFINE g_gev04        LIKE gev_file.gev04
DEFINE l_ac1          LIKE type_file.num10
DEFINE g_rec_b1       LIKE type_file.num10
DEFINE g_bp_flag      LIKE type_file.chr10
DEFINE g_flag2        LIKE type_file.chr1
DEFINE g_gew06        LIKE gew_file.gew06
DEFINE g_gew07        LIKE gew_file.gew07
DEFINE g_chr          LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE g_chr1,g_chr2  LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE g_chr3         LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE g_count        LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE g_cmd          LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(100)
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE i              LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE j              LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE g_no_ask       LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE g_bxr02_2      LIKE bxr_file.bxr02    #FUN-6A0007
DEFINE g_bxr02_1      LIKE bxr_file.bxr02    #FUN-6A0007
DEFINE g_u_flag       LIKE type_file.chr1    #FUN-870101 add 
DEFINE g_occ02_t      LIKE occ_file.occ02    #No.FUN-A30110
DEFINE g_flag         LIKE type_file.num5    #No.FUN-A30110
DEFINE g_flag1        LIKE type_file.num5    #No.FUN-A30110
DEFINE g_crmStatus    LIKE type_file.num10   #FUN-BC0065 add
DEFINE g_crmDesc      STRING                 #FUN-BC0065 add
 
MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730018
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)   #NO.FUN-840033 add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0094
   INITIALIZE g_occ.* TO NULL
   INITIALIZE g_occ_t.* TO NULL
 
   LET g_forupd_sql = " SELECT * FROM occ_file  WHERE occ01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE i221_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   OPEN WINDOW i221_w WITH FORM "axm/42f/axmi221"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL i221_q()
   END IF
 
   LET g_action_choice=""
   IF g_azw.azw04 = '2' THEN
      CALL cl_set_comp_visible("occ73",TRUE)
   ELSE
      CALL cl_set_comp_visible("occ73",FALSE)
   END IF 
   CALL cl_set_comp_visible("occ72,occ72_1",FALSE)           #FUN-C50036 add 
   IF g_aza.aza50='N' THEN
      CALL cl_set_comp_visible("Customer",FALSE)
     #CALL cl_set_act_visible("customer_deal_kind,customer_deal_catena,customer_contact1,customer_address1",FALSE) #FUN-C50070 mark
      CALL cl_set_act_visible("customer_deal_kind,customer_deal_catena,customer_contact1",FALSE)                   #FUN-C50070 add
      CALL cl_set_act_visible("finance_info_maintenance",FALSE)
      CALL cl_set_act_visible("client_price",FALSE)
     #CALL cl_set_act_visible("customer_contact,customer_address",TRUE) #FUN-C50070 mark
      CALL cl_set_act_visible("customer_contact",TRUE)                  #FUN-C50070 add
   ELSE
      IF g_aza.aza50='Y' THEN
         CALL cl_set_comp_visible("Customer",TRUE)
        #CALL cl_set_act_visible("customer_deal_kind,customer_deal_catena,customer_contact1,customer_address1",TRUE) #FUN-C50070 mark
         CALL cl_set_act_visible("customer_deal_kind,customer_deal_catena,customer_contact1",TRUE)                   #FUN-C50070 add
         CALL cl_set_act_visible("client_pirce,finance_info_maintenance",TRUE)
        #CALL cl_set_act_visible("customer_contact,customer_address",FALSE) #FUN-C50070 mark
         CALL cl_set_act_visible("customer_contact",FALSE) #FUN-C50070 add
         CALL cl_set_comp_required("occ1006,occ1007,occ1008,occ1009,occ1010,occ1011,occ1012,occ1013,occ1014,occ1015,occ1016",FALSE)
         CALL cl_set_comp_required("occ1027",TRUE)
      END IF
   END IF
    IF g_aza.aza61 = 'N' THEN #不使用客戶申請作業時,才可按確認/取消確認/新增
        CALL cl_set_act_visible("confirm,unconfirm,insert",TRUE)
    ELSE
        CALL cl_set_act_visible("confirm,unconfirm,insert",FALSE)
    END IF
 
   CALL cl_set_comp_visible("page07",g_sma.sma79='Y')  #FUN-6A0007
   CALL cl_set_comp_visible("page1",g_aza.aza26='0')  #FUN-AB0080 add
   CALL cl_set_act_visible("abx_maintain",g_sma.sma79='Y') #FUN-6A0007
 
   IF g_azw.azw04='2' THEN
      CALL cl_set_comp_visible("gb21",TRUE)
      CALL cl_set_act_visible("client_price",TRUE)   
   ELSE
      CALL cl_set_comp_visible("gb21",FALSE)
      CALL cl_set_act_visible("client_price",FALSE)   
   END IF
 
   IF g_aza.aza88 = 'N' THEN
      CALL cl_set_comp_visible('occpos',FALSE)
   END IF

#  CALL cl_set_comp_entry('occ63,occ64',g_oaz.oaz96='N') #FUN-C50136 add
   CALL cl_set_combo_lang("occ55")            #MOD-970184 add
   CALL i221_menu()
 
   CLOSE WINDOW i221_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0094
 
END MAIN
 
FUNCTION i221_curs()
    CLEAR FORM
 
    IF cl_null(g_argv1) THEN #2581
   INITIALIZE g_occ.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          occ01,  occ02,  occ18,  occ19, #occ1001,occ1002,  #FUN-640011   #MOD-910146
          occ11,  occ37,  occ28,  occ34, occ66,occ1005,   #FUN-630027 增加occ66
          occ246,         #No.FUN-7C0010
          occ1004,occ06,  occ09,  occ07,  occ03, occ04,  #FUN-640011
          occ56,  occ57,
          occ31,  occ65, occpos,     #FUN-870100 ADD OCCPOS  #No.FUN-610020
          occ22,  occ21,  occ20,
          occ261, occ262, occ263,
          occ271,occ272,
          occ29,  occ30,  occ292, occ302,
          occ35,
          occ231,occ232, occ233, occ234, occ235,  #FUN-720014 add occ234/235
          occ241,occ242, occ243, occ244, occ245,  #FUN-720014 add occ244/245
          occ40,  occ38,  occ39,
          occ73,           #FUN-990031 
          occ16,  occ171, occ172, occ173,occ174,
          occ62,  occ33,  occ61,  occ36, occ175,
          occ631, occ63,  occ64,
          occ42,  occ41,  occ08,  occ44, occ45,occ68,occ69,occ67,  #FUN-570065 add occ67  #FUN-840183 add occ68,occ69
          occ43,  occ55,  occ47,
          occ48,  occ49,  occ50,
          occ46,  occ53,  occ32,
          occ51,  occ52, #BugNo:A036
          occ701, occ702, occ703, occ704,
          occ76,occ77,   #FUN-B90105 add
          occ12,  occ13,  occ14,  occ15, occ05,
          occ930, occ71,occ72,   #FUN-870100 add
          occ1706,     #FUN-6A0007
          occ1705,     #FUN-6A0007
          occ1707,occ1708,    #FUN-6A0007
          occ74,occ75,        #FUN-AB0080 add
          occud01,occud02,occud03,occud04,occud05,
          occud06,occud07,occud08,occud09,occud10,
          occud11,occud12,occud13,occud14,occud15,
          occ1003,occ1006,occ1007,occ1008,occ1009,occ1010,
          occ1011,occ1012,occ1013,occ1014,occ1015,occ1016,occ1027,
          occuser,occgrup,occmodu,occdate,occacti,occoriu,occorig       #TQC-AA0053   add occoriu/occorig
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
            CASE
             WHEN INFIELD(occ01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ01
                  NEXT FIELD occ01
             WHEN INFIELD(occ03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_oca'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ03
                  NEXT FIELD occ03
             WHEN INFIELD(occ04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_gen'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ04
                  NEXT FIELD occ04
             WHEN INFIELD(occ09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ09
                  NEXT FIELD occ09
             WHEN INFIELD(occ07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ07
                  NEXT FIELD occ07
             WHEN INFIELD(occ08)
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = 'q_occ08'   #CHI-BA0022 mark 
                  LET g_qryparam.form = 'q_occ082'   #CHI-BA0022 add
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ08
                  NEXT FIELD occ08
                  
             WHEN INFIELD(occ34)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ34'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ34
                  NEXT FIELD occ34             
             WHEN INFIELD(occ20)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_gea'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ20
                  NEXT FIELD occ20
             WHEN INFIELD(occ21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_geb'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ21
                  NEXT FIELD occ21
             WHEN INFIELD(occ22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_geo'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ22
                  NEXT FIELD occ22
             WHEN INFIELD(occ631)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azi'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ631
                  NEXT FIELD occ631
             WHEN INFIELD(occ61)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_ocg'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ61
                  NEXT FIELD occ61
             WHEN INFIELD(occ33)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ33
                  NEXT FIELD occ33
              WHEN INFIELD(occ41)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_gec'
                   LET g_qryparam.arg1 = '2'
                   LET g_qryparam.state  = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO occ41
                   NEXT FIELD occ41
              WHEN INFIELD(occ47)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_ged'
                  LET g_qryparam.default1 = g_occ.occ47
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ47
                  NEXT FIELD occ47
              WHEN INFIELD(occ43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oab'
                 LET g_qryparam.default1 = g_occ.occ43
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ43
                 NEXT FIELD occ43
 
              WHEN INFIELD(occ44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oah'
                 LET g_qryparam.default1 = g_occ.occ44
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ44
                 NEXT FIELD occ44
 
              WHEN INFIELD(occ45)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occ.occ45
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ45
                 NEXT FIELD occ45
                 
                 WHEN INFIELD(occ68)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occ.occ68
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ68
                 NEXT FIELD occ68
                 
              WHEN INFIELD(occ69)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occ.occ69
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ69
                 NEXT FIELD occ69                            
 
              WHEN INFIELD(occ67)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ool"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO occ67
                   NEXT FIELD occ67
 
# 加查詢明細資料
              WHEN INFIELD(occ42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_azi'
                 LET g_qryparam.default1 = g_occ.occ42
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ42
                 NEXT FIELD occ42
 
              WHEN INFIELD(occ48)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oac'
                 LET g_qryparam.default1 = g_occ.occ48
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ48
                 NEXT FIELD occ48
 
              WHEN INFIELD(occ49)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oac'
                 LET g_qryparam.default1 = g_occ.occ49
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ49
                 NEXT FIELD occ49
 
              WHEN INFIELD(occ50)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_oac'
                  LET g_qryparam.default1 = g_occ.occ50
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ50
                  NEXT FIELD occ50
 
              WHEN INFIELD(occ51)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_pmc'
                 LET g_qryparam.default1 = g_occ.occ51
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ51
                 NEXT FIELD occ51
              WHEN INFIELD(occ1706)  #保稅出貨異動原因代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_bxr'
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ1706
                 NEXT FIELD occ1706
              WHEN INFIELD(occ1705)  #保稅銷退異動原因代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_bxr'
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ1705
                 NEXT FIELD occ1705
              WHEN INFIELD(occ66)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_pmc8'   #FUN-640014 modify
                 LET g_qryparam.default1 = g_occ.occ66
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ66
                 NEXT FIELD occ66
              WHEN INFIELD(occ1005)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_tqb'
                   LET g_qryparam.state  = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO occ1005
                   NEXT FIELD occ1005
              WHEN INFIELD(occ246)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ246
                 NEXT FIELD occ246
 
              WHEN INFIELD(occud02)
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occud02
                 NEXT FIELD occud02
              WHEN INFIELD(occud03)
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occud03
                 NEXT FIELD occud03
              WHEN INFIELD(occud04)
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occud04
                 NEXT FIELD occud04
              WHEN INFIELD(occud05)
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occud05
                 NEXT FIELD occud05
              WHEN INFIELD(occud06)
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occud06
                 NEXT FIELD occud06
            #FUN-AB0080---add---start---
             WHEN INFIELD(occ74)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ02'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ74
                  NEXT FIELD occ74
            #FUN-AB0080---add---end---
             WHEN INFIELD(occ1003)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqa'
                  LET g_qryparam.arg1 = '12'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1003
                  NEXT FIELD occ1003
              WHEN INFIELD(occ1006)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="19"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1006
                  NEXT FIELD occ1006
              WHEN INFIELD(occ1007)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="10"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1007
                  NEXT FIELD occ1007
              WHEN INFIELD(occ1008)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1008
                  NEXT FIELD occ1008
             WHEN INFIELD(occ1009)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_too2'      #MOD-640199
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1009
                  NEXT FIELD occ1009
             WHEN INFIELD(occ1010)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_top01'     #MOD-640199
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1010
                  NEXT FIELD occ1010
             WHEN INFIELD(occ1011)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_toq1'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1011
                  NEXT FIELD occ1011
              WHEN INFIELD(occ1016)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_imd1'
                  LET g_qryparam.default1 = g_occ.occ1016
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1016
                  NEXT FIELD occ1016
              WHEN INFIELD(occ930)                                                                                                 
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form = 'q_occ930'                                                                                   
                  LET g_qryparam.default1 = g_occ.occ930                                                                           
                  LET g_qryparam.state  = "c"                                                                                       
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO occ930                                                                            
                  NEXT FIELD occ930
             END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
    ELSE
        LET g_wc = "occ01 ='",g_argv1,"'"
    END IF
 
    IF INT_FLAG THEN RETURN END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
 
    LET g_sql="SELECT occ01 FROM occ_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY occ01"
 
    PREPARE i221_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i221_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i221_prepare
    DECLARE i221_list_cur CURSOR FOR i221_prepare
    LET g_sql= "SELECT COUNT(*) FROM occ_file WHERE ",g_wc CLIPPED
    PREPARE i221_precount FROM g_sql
    DECLARE i221_count CURSOR FOR i221_precount
 
END FUNCTION
 
FUNCTION i221_menu()
 
  DEFINE l_cmd           LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(30)
         l_priv1         LIKE zy_file.zy03,       # 使用者執行權限
         l_priv2         LIKE zy_file.zy04,       # 使用者資料權限
         l_priv3         LIKE zy_file.zy05        # 使用部門資料權限
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF g_aza.aza61 = 'N' THEN #不使用客戶申請作業時,才可按新增!
                IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
                     CALL i221_a()
                END IF
            ELSE
                CALL cl_err('','axm-222',1)
                #不使用客戶申請作業時,才可按新增!
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN    #cl_prichk('Q') THEN
                 CALL i221_q()
            END IF
 
        ON ACTION next
            CALL i221_fetch('N')
 
        ON ACTION previous
            CALL i221_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN    #cl_prichk('U') THEN
               CALL i221_u()
            END IF
 
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF g_aza.aza61 = 'N' THEN  #CHI-740027 add if判斷
                IF cl_chk_act_auth() THEN
                   CALL i221_copy()
                END IF
            ELSE
                #參數設定使用客戶申請作業時,不可做複製!
                CALL cl_err('','aim-156',1)
            END IF

       #No.FUN-9C0089 add begin------------------
        ON ACTION exporttoexcel
           LET g_action_choice="exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_occ_l),'','')
           END IF
       #No.FUN-9C0089 add -end-------------------
 
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN    #cl_prich3(g_occ.occuser,g_occ.occgrup,'X') THEN
               CALL i221_x()
            END IF
           #圖形顯示
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN    #cl_prichk('R') THEN
               CALL i221_r()
            END IF
 
      #@ON ACTION 信用額度設定
        ON ACTION credit_line
            LET g_action_choice="credit_line"
            IF cl_chk_act_auth() THEN    #cl_prichk('D') THEN
               CALL i221_d()
            END IF
 
        #信用額度更新
        ON ACTION carry_credit
            LET g_action_choice = "carry_credit"
            IF cl_chk_act_auth() THEN
               CALL i221_credit_carry()
            END IF
 
      #@ON ACTION 客戶其它地址
#FUN-C50070 mark -begin--------------------------
#       ON ACTION customer_address
#           LET g_action_choice="customer_address"
#           IF cl_chk_act_auth() THEN    #cl_prichk('1') THEN
#              CALL i221_1()
#           END IF
#FUN-C50070 mark --end---------------------------
 
        ON ACTION customer_address1
            LET g_action_choice="customer_address1"
            IF cl_chk_act_auth() THEN
               CALL i221_11(g_occ.occ01)
            END IF
 
      #@ON ACTION 客戶聯絡人
        ON ACTION customer_contact
            LET g_action_choice="customer_contact"
            IF cl_chk_act_auth() THEN    #cl_prichk('2') THEN
               CALL i221_2()
            END IF
 
        ON ACTION customer_contact1
            LET g_action_choice="customer_contact1"
            IF cl_chk_act_auth() THEN
               CALL i221_22(g_occ.occ01)
               LET INT_FLAG=0
            END IF
 
      #@ON ACTION 客戶Notify/Consignee
        ON ACTION customer_notify_consignee
            LET g_action_choice="customer_notify_consignee"
            IF cl_chk_act_auth() THEN    #cl_prichk('4') THEN
               CALL i221_4()
            END IF
 
      #@ON ACTION 往來銀行
        ON ACTION bank_list
            LET g_action_choice="bank_list"
            IF cl_chk_act_auth() THEN    #cl_prichk('5') THEN
               IF NOT cl_null(g_occ.occ01)
               THEN LET l_cmd = "axmi225 '",g_occ.occ01,"'" CLIPPED
                    CALL cl_cmdrun(l_cmd)
               END IF
            END IF
 
      #@ON ACTION 客戶Remark
        ON ACTION customer_remark
             LET g_action_choice="customer_remark" #MOD-530303
            IF cl_chk_act_auth() THEN    #cl_prichk('6') THEN
               CALL i221_6()
            END IF
 
         ON ACTION cust_carry
            LET g_action_choice = "cust_carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL i221_carry()
            END IF
 
         ON ACTION price_carry
            LET g_action_choice = "price_carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL i221_price_carry()
            END IF
 
         ON ACTION download
            LET g_action_choice = "download"
            IF cl_chk_act_auth() THEN
               CALL i221_download()
            END IF
 
         ON ACTION qry_carry_history
            LET g_action_choice = "qry_carry_history"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_occ.occ01) THEN  #No.FUN-830090
                  IF NOT cl_null(g_occ.occ246) THEN
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '4' AND gev02 = g_occ.occ246
                  ELSE      #歷史資料,即沒有ima916的值
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '4' AND gev02 = g_plant
                  END IF
                  IF NOT cl_null(g_gev04) THEN
                     LET l_cmd='aooq604 "',g_gev04,'" "4" "',g_prog,'" "',g_occ.occ01,'"'
                     CALL cl_cmdrun(l_cmd)
                  END IF
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
         
         ON ACTION cust_list
            #CALL i221_bp("G")          #MOD-A70076
            LET g_action_choice = ""    #MOD-A70076
            CALL i221_b_menu()          #MOD-A70076
            IF g_action_choice = "exit" THEN  #MOD-D30241
               EXIT MENU  #MOD-D30241
            END IF   #MOD-D30241
            LET g_action_choice = ""    #MOD-A70076
 
      #ON ACTION 客戶經營品類
      ON ACTION customer_deal_kind
         LET g_action_choice="customer_deal_kind"
         IF cl_chk_act_auth() THEN
            CALL i221_8(g_occ.occ01,'1')
            LET INT_FLAG=0
         END IF
 
      #ON ACTION 客戶經營系列
      ON ACTION customer_deal_catena
         LET g_action_choice="customer_deal_catena"
         IF cl_chk_act_auth() THEN
            CALL i221_8(g_occ.occ01,'3')
            LET INT_FLAG=0
         END IF
 
      ON ACTION client_price                     #客戶定價
         LET g_action_choice="client_price"
         IF cl_chk_act_auth() THEN
            IF NOT cl_null(g_occ.occ01) THEN
               SELECT COUNT(*) INTO g_count
                 FROM tqo_file
                WHERE tqo01 = g_occ.occ01
               IF g_count = 0 THEN
                  LET g_cmd = "atmi228 '",g_occ.occ01,"' 'insert'"
                  CALL cl_cmdrun(g_cmd CLIPPED)
                  LET INT_FLAG=0
               ELSE
                  LET g_cmd = "atmi228 '",g_occ.occ01,"' 'query'"
                  CALL cl_cmdrun(g_cmd CLIPPED)
                  LET INT_FLAG=0
               END IF
            END IF
         END IF
 
      #客戶財務信息維護
      ON ACTION finance_info_maintenance
         LET g_action_choice="finance_info_maintenance"
         IF cl_chk_act_auth() THEN
            IF NOT cl_null(g_occ.occ01) THEN
               CALL i221_5(g_occ.occ01)
               SELECT * INTO g_occ.* FROM occ_file
                WHERE occ01=g_occ.occ01
               LET INT_FLAG = 0
            END IF
         END IF
 
        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
              CALL i221_confirm()
              CALL i221_show_pic()
           END IF
 
        ON ACTION unconfirm
           LET g_action_choice="unconfirm"
           IF cl_chk_act_auth() THEN
              CALL i221_unconfirm()
              CALL i221_show_pic()
           END IF
 
        ON ACTION hang
           LET g_action_choice="hang"
           IF cl_chk_act_auth() THEN
              CALL i221_hang()
              CALL i221_show_pic()
           END IF
 
        ON ACTION unhang
           LET g_action_choice="unhang"
           IF cl_chk_act_auth() THEN
              CALL i221_unhang()
              CALL i221_show_pic()
           END IF
 
        ON ACTION untransaction
           LET g_action_choice="untransaction"
           IF cl_chk_act_auth() THEN
              CALL i221_untransaction()
              CALL i221_show_pic()
           END IF
 
        ON ACTION transaction
           LET g_action_choice="transaction"
           IF cl_chk_act_auth() THEN
              CALL i221_transaction()
              CALL i221_show_pic()
           END IF
 
      ON ACTION internal_trade_data
         LET g_action_choice = "internal_trade_data"
         IF cl_chk_act_auth() THEN
            CALL i221_i_t()
         END IF
#FUN-AA0078 mark -----begin-------
#FUN-A50012 ---add begin
#      ON ACTION set_replacement
#         LET g_action_choice = "set_replacement"
#         IF cl_chk_act_auth() THEN
#            CALL i221_3()
#         END IF
#FUN-A50012 ---add end
#FUN-AA0078 mark -----end------- 
       #ON ACTION 相關查詢
        ON ACTION related_query
            CALL s_cusqry(g_occ.occ01,'') #CHI-B60094 add ''
#          IF g_oaz.oaz96 = 'Y' THEN                         #FUN-C50136
#             LET g_msg = 'axmq274 ',g_occ.occ01              #FUN-C50136
#             CALL cl_cmdrun(g_msg)                          #FUN-C50136
#          ELSE                                              #FUN-C50136
#            CALL s_cusqry(g_occ.occ01)   #CHI-B60094 mark
#          END IF                                            #FUN-C50136
       #ON ACTION 產品庫存受訂明細查詢
        ON ACTION qry_product_inventory
              LET g_msg='axmq450'
              CALL cl_cmdrun(g_msg)
 
 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN    #THEN cl_prichk('O')
               CALL i221_out()
            END IF
 
        ON ACTION help
            CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           #圖形顯示
           CALL cl_set_combo_lang("occ55")            #MOD-970184 add
           CALL i221_show_pic()
           CALL cl_show_fld_cont()                  #FUN-590083
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION related_document
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_occ.occ01 IS NOT NULL THEN
                  LET g_doc.column1 = "occ01"
                  LET g_doc.value1 = g_occ.occ01
                  CALL cl_doc()
               END IF
            END IF
 
        ON ACTION abx_maintain
           LET g_action_choice = "abx_maintain"
           IF cl_chk_act_auth() THEN
              CALL i221_abx()
           END IF

        #darcy:2024/12/06 add s---
      --   锁住
        on action btnLock
            let g_action_choice = "btnLock"
            IF cl_chk_act_auth() THEN
               CALL i221_lock()
            END IF
        #darcy:2024/12/06 add e---
 
        ON ACTION jump
            CALL i221_fetch('/')
 
        ON ACTION first
            CALL i221_fetch('F')
 
        ON ACTION last
            CALL i221_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE i221_cs
END FUNCTION
 
 
FUNCTION i221_a()
DEFINE   l_occ02        LIKE occ_file.occ02     #MOD-960248
 
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM
    LET g_occ_ct.*=g_occ.*
    INITIALIZE g_occ.* TO NULL
    LET g_occ.occ1004 ='0' #0:開立#FUN-690021
    LET g_occ.occ1027 ='N' #No.FUN-640011
    LET g_occ.occ05   ='1'
    LET g_occ.occ06   ='1'
#   LET g_occ.occ08   ='1' #MOD-530410   #TQC-A50069
    LET g_occ.occ62   ='N'
    LET g_occ.occ34   =' '
    LET g_occ.occ66   =' '   #FUN-630027 add
    LET g_occ.occ37   ='N'
    LET g_occ.occ40   ='Y'
    LET g_occ.occ56   ='Y'    #No.7334
    LET g_occ.occ57   ='N'    #No.7334
    LET g_occ.occ63   =0
    LET g_occ.occ64   =0
    LET g_occ.occ31   ='Y'    #NO.A112   #FUN-660042 modify 預設為N
    LET g_occ.occ65   ='Y'    #No.FUN-610020
    LET g_occ.occuser = g_user
    LET g_occ.occoriu = g_user #FUN-980030
    LET g_occ.occorig = g_grup #FUN-980030
    LET g_occ.occgrup = g_grup               #使用者所屬群
    LET g_occ.occdate = g_today
    LET g_occ.occacti = 'P' #P:Processing #FUN-690021
    LET g_occ.occ246  = g_plant   #No.FUN-7C0010
    #LET g_occ.occ71 = '1'         #FUN-870100    #MOD-C30314 mark
    LET g_occ.occ71 = '2'          #MOD-C30314 add
    LET g_occ.occ72 = 0            #FUN-C50036 add 
    #LET g_occ.occpos  ='N'        #FUN-870100
    LET g_occ.occpos  ='1'        #FUN-B50023
    DISPLAY g_occ.occpos TO occpos #FUN-870100
    LET g_occ.occ73 = 'N'         #FUN-990031 add 
    LET g_occ.occud03 = 'N'       #darcy:2025/05/26
    LET g_occ_t.*=g_occ.*
    LET g_occ01_t = NULL
    CALL cl_opmsg('a')
    IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'a') THEN                                                                           
       CALL cl_err(g_occ.occ246,'aoo-078',1)                                                                                         
       RETURN                                                                                                                        
    END IF   
    WHILE TRUE
        IF g_aza.aza29 = 'Y' THEN
           LET l_occ02 = g_occ.occ02    #MOD-960248
           CALL s_auno(g_occ.occ01,'2','') RETURNING g_occ.occ01,g_occ.occ02  #No.FUN-850100
           IF NOT cl_null(l_occ02) THEN
              LET g_occ.occ02 = l_occ02
           END IF
        END IF
        CALL i221_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_occ.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_occ.occ01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
 
        BEGIN WORK     #NO.FUN-680010
 
        INSERT INTO occ_file VALUES(g_occ.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            ROLLBACK WORK    #NO.FUN-680010
            CONTINUE WHILE
        ELSE
            #No.FUN-BB0049  --Begin
            CALL s_showmsg_init()
            CALL s_upd_abbr(g_occ.occ01,g_occ.occ02,g_plant,'2','Y','a')
            IF g_success = 'N' THEN
               CALL s_showmsg()
               ROLLBACK WORK
               CONTINUE WHILE
            END IF
            #No.FUN-BB0049  --End

            LET g_occ_t.* = g_occ.*                # 保存上筆資料
            SELECT occ01 INTO g_occ.occ01 FROM occ_file
                WHERE occ01 = g_occ.occ01
 
            # CALL aws_mdmcli
            # 傳入參數: (1)TABLE名稱, (2)功能：insert(新增),update(修改),delete(刪除),
            #           (3-7)新增資料 
            CASE aws_mdmdata('occ_file','insert',g_occ.occ01,base.TypeInfo.create(g_occ),'CreateCustomerData')#FUN-870166
               WHEN 0  #無與 MDM 整合
                    MESSAGE 'INSERT O.K'
               WHEN 1  #呼叫 MDM 成功
                    MESSAGE 'INSERT O.K, INSERT MDM O.K'
               WHEN 2  #呼叫 MDM 失敗
                    ROLLBACK WORK
                    CONTINUE WHILE      
            END CASE
 
            # CALL aws_spccli_base()
            # 傳入參數: (1)TABLE名稱, (2)新增資料,
            #           (3)功能選項：insert(新增),update(修改),delete(刪除)
            CASE aws_spccli_base('occ_file',base.TypeInfo.create(g_occ),'insert')
               WHEN 0  #無與 SPC 整合
                    MESSAGE 'INSERT O.K'
                    COMMIT WORK
               WHEN 1  #呼叫 SPC 成功
                    MESSAGE 'INSERT O.K, INSERT SPC O.K'
                    COMMIT WORK
               WHEN 2  #呼叫 SPC 失敗
                    ROLLBACK WORK
                    CONTINUE WHILE
            END CASE
 
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i221_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_msg         LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(40)
          l_n           LIKE type_file.num5     #No.FUN-680137 SMALLINT
   DEFINE li_result     LIKE type_file.num5                #No.FUN-620063  #No.FUN-680137 SMALLINT
   DEFINE l_occ11       STRING                  #MOD-790130
   DEFINE l_count       LIKE type_file.num5     #TQC-980153
   DEFINE l_occacti     LIKE occ_file.occacti   #MOD-B30480 add
   DEFINE l_str         STRING  #darcy:2022/04/08
   DEFINE l_occ01       LIKE occ_file.occ01  #darcy:2022/04/08
   DEFINE l_pmc01       LIKE occ_file.occ01  #darcy:2022/04/08
 
   LET g_on_change = TRUE   #FUN-590083
 
    DISPLAY BY NAME g_occ.occ246      #No.FUN-7C0010
    INPUT BY NAME g_occ.occoriu,g_occ.occorig,
          g_occ.occ01,  g_occ.occ02,  g_occ.occ18,  g_occ.occ19, #g_occ.occ1001, g_occ.occ1002,   #No.FUN-640011   #MOD-910146
          g_occ.occ11,  g_occ.occ37,  g_occ.occ28,  g_occ.occ34,
          g_occ.occ66,  g_occ.occ1005,   #FUN-630027 增加g_occ.occ66
          g_occ.occ1004,g_occ.occ06,  g_occ.occ09,  g_occ.occ07,  g_occ.occ03, g_occ.occ04, #No.FUN-640011
          g_occ.occ56,  g_occ.occ57,
          g_occ.occ31,
          g_occ.occ65,  #No.FUN-610020
          g_occ.occ22,  g_occ.occ21,  g_occ.occ20,
          g_occ.occ261, g_occ.occ262, g_occ.occ263,
          g_occ.occ271,g_occ.occ272,
          g_occ.occ29, g_occ.occ292, g_occ.occ30, g_occ.occ302,
          g_occ.occ35,
          g_occ.occ231, g_occ.occ232, g_occ.occ233, g_occ.occ234, g_occ.occ235,  #FUN-720014 add 234/235
          g_occ.occ241, g_occ.occ242, g_occ.occ243, g_occ.occ244, g_occ.occ245,  #FUN-720014 add 244/245
          g_occ.occ40,  g_occ.occ38,  g_occ.occ39,
          g_occ.occ73,       #FUN-990031 
          g_occ.occ16,  g_occ.occ171, g_occ.occ172, g_occ.occ173,g_occ.occ174,
          g_occ.occuser,g_occ.occgrup,g_occ.occmodu,g_occ.occdate,g_occ.occacti,
        # 信用查核在此只能查詢不可輸入
          g_occ.occ42,  g_occ.occ41,  g_occ.occ08,  g_occ.occ44, g_occ.occ45,
          g_occ.occ68,  g_occ.occ69,  g_occ.occ67,  #FUN-570065                  #FUN-840183 add occ68,occ69   
          g_occ.occ43,  g_occ.occ55,  g_occ.occ47,
          g_occ.occ48,  g_occ.occ49,  g_occ.occ50,
          g_occ.occ46,  g_occ.occ53,  g_occ.occ32,
          g_occ.occ51,  g_occ.occ52, #BugNo:A036
          g_occ.occ701, g_occ.occ702, g_occ.occ703, g_occ.occ704,
          g_occ.occ76,  g_occ.occ77,   #FUN-B90105 add
          g_occ.occ12,  g_occ.occ13,  g_occ.occ14,  g_occ.occ15, g_occ.occ05,
          g_occ.occ930,  g_occ.occ71,  g_occ.occ72,  #FUN-870100
          g_occ.occ74,g_occ.occ75,         #FUN-AB0080 add
          g_occ.occud01,#g_occ.occud02,    # darcy:2024/12/06 remark occud02
          g_occ.occud03,g_occ.occud04,g_occ.occud05,
          g_occ.occud06,g_occ.occud07,g_occ.occud08,g_occ.occud09,g_occ.occud10,
          g_occ.occud11,g_occ.occud12,g_occ.occud13,g_occ.occud14,g_occ.occud15,
          g_occ.occ1003,g_occ.occ1006,g_occ.occ1007,g_occ.occ1008,g_occ.occ1009,
          g_occ.occ1010,g_occ.occ1011,g_occ.occ1012,g_occ.occ1013,g_occ.occ1014,
          g_occ.occ1015,g_occ.occ1016,g_occ.occ1027
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i221_set_entry(p_cmd)
            CALL i221_set_no_entry(p_cmd)
            CALL i221_set_no_required(p_cmd)
            CALL i221_set_required(p_cmd)
            LET g_before_input_done = TRUE
 
        #No.FUN-A30110  --Begin
        BEFORE FIELD occ01
            CALL i221_set_entry(p_cmd)
        #No.FUN-A30110  --End

        AFTER FIELD occ01
            IF NOT cl_null(g_occ.occ01) THEN
               IF cl_null(g_occ_t.occ01) OR ( g_occ.occ01 != g_occ_t.occ01) THEN
                  SELECT count(*) INTO l_n FROM occ_file
                   WHERE occ01 = g_occ.occ01
                  IF l_n > 0 THEN
                     CALL cl_err(g_occ.occ01,-239,0)
                     LET g_occ.occ01 = g_occ_t.occ01
                     DISPLAY BY NAME g_occ.occ01
                     NEXT FIELD occ01
                  END IF
                  CALL s_field_chk(g_occ.occ01,'4',g_plant,'occ01') RETURNING g_flag2
                  IF g_flag2 = '0' THEN
                     CALL cl_err(g_occ.occ01,'aoo-043',1)
                     LET g_occ.occ01 = g_occ_t.occ01
                     DISPLAY BY NAME g_occ.occ01
                     NEXT FIELD occ01
                  END IF
               END IF
               #No.FUN-A30110  --Begin
               IF p_cmd = 'a' THEN
                  CALL i221_set_occ02(p_cmd)
               END IF
               #No.FUN-A30110  --End
               IF p_cmd!='u' THEN
                  IF cl_null(g_occ.occ02) THEN       #MOD-960248
                     LET g_occ.occ02 = g_occ.occ01   #MOD-720063 modify [1,8]
                  END IF                             #MOD-960248
               END IF
               LET g_occ.occ1022 = g_occ.occ01 #MOD-B30027 add 
               IF g_occ.occ06 = '1' THEN
                  LET g_occ.occ07=g_occ.occ01
                  LET g_occ.occ09=g_occ.occ01
                  IF g_occ.occ07 = g_occ.occ01 THEN
                     DISPLAY g_occ.occ02 TO FORMONLY.occ7_ds
                  ELSE
                     SELECT occ02 INTO g_buf FROM occ_file
                      WHERE occ01 = g_occ.occ07
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occ7_ds
                  END IF
                  IF g_occ.occ09 = g_occ.occ01 THEN
                     DISPLAY g_occ.occ02 TO FORMONLY.occ9_ds
                  ELSE
                     SELECT occ02 INTO g_buf FROM occ_file
                      WHERE occ01 = g_occ.occ09
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occ9_ds
                  END IF
               END IF
               IF g_occ.occ06 = '2' THEN
                  IF cl_null(g_occ.occ07) THEN
                     LET g_occ.occ07=g_occ.occ01
                  END IF
                  LET g_occ.occ1022=NULL
                  CALL cl_set_comp_entry("occ1022",FALSE)
                  LET g_occ.occ09=g_occ.occ01
                  DISPLAY g_occ.occ02 TO FORMONLY.occ9_ds
                  IF g_occ.occ07 = g_occ.occ01 THEN
                     DISPLAY g_occ.occ02 TO FORMONLY.occ7_ds
                  ELSE
                     SELECT occ02 INTO g_buf FROM occ_file
                       WHERE occ01 = g_occ.occ07
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occ7_ds
                  END IF
               END IF
               IF g_occ.occ06='3' THEN
                  IF cl_null(g_occ.occ09) THEN
                     LET g_occ.occ09=g_occ.occ01
                  END IF
                  LET g_occ.occ07=g_occ.occ01
                  DISPLAY g_occ.occ02 TO FORMONLY.occ7_ds
                  IF g_occ.occ09 = g_occ.occ01 THEN
                     DISPLAY g_occ.occ02 TO FORMONLY.occ9_ds
                  ELSE
                     SELECT occ02 INTO g_buf FROM occ_file
                       WHERE occ01 = g_occ.occ09
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occ9_ds
                  END IF
               END IF
               IF g_occ.occ06='4' THEN
                  IF cl_null(g_occ.occ09) THEN
                     LET g_occ.occ09=g_occ.occ01
                  END IF
                  LET g_occ.occ1022=' '
                  CALL cl_set_comp_entry("occ1022",FALSE)
                  IF g_occ.occ09 = g_occ.occ01 THEN
                     DISPLAY g_occ.occ02 TO FORMONLY.occ9_ds
                  ELSE
                     SELECT occ02 INTO g_buf FROM occ_file
                       WHERE occ01 = g_occ.occ09
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occ9_ds
                  END IF
               END IF
              #LET g_occ.occ1022 = g_occ.occ01 #MOD-B30027 mark
               DISPLAY BY NAME g_occ.occ02,g_occ.occ09,g_occ.occ07
               IF cl_null(g_occ.occ02) THEN
                  LET g_occ.occ02 = ''
                  DISPLAY BY NAME g_occ.occ02
               END IF
            END IF
            #No.FUN-BB0049  --Begin
            ##No.FUN-A30110  --Begin
            ##CALL s_check_pmc01_occ01(g_occ.occ01,g_occ.occ02,g_dbs,'2','Y')
            #CALL s_check_pmc01_occ01(g_occ.occ01,g_occ.occ02,g_plant,'2','Y')  #FUN-A50102
            #     RETURNING g_flag,g_flag1
            #IF g_flag = FALSE THEN
#           #   NEXT FIELD occ01
            #END IF
            #No.FUN-BB0049  --End  
            CALL i221_set_no_entry(p_cmd)
            #No.FUN-A30110  --End  

        #No.FUN-BB0049  --Begin
        BEFORE FIELD occ02
           IF g_action_choice = "reproduce" THEN
              CALL i221_set_occ02(p_cmd)
           END IF
        #No.FUN-BB0049  --End

		
	AFTER FIELD occ02
            IF NOT cl_null(g_occ.occ02) THEN
               LET l_n =0
               SELECT count(*) INTO l_n FROM occ_file
                WHERE occ02 = g_occ.occ02 AND occ01 != g_occ.occ01
               #資料重複,請檢查客戶簡稱欄位資料
               IF l_n > 0 THEN CALL cl_err(g_occ.occ02,'axm-205',0) END IF
               IF cl_null(g_occ.occ18) THEN
                  LET g_occ.occ18=g_occ.occ02
                  DISPLAY BY NAME g_occ.occ18
                END IF
            ELSE
               LET g_occ.occ02 = NULL
               NEXT FIELD occ02
            END IF
            #No.FUN-BB0049  --Begin
            ##No.FUN-A30110  --Begin
            ##CALL s_check_pmc01_occ01(g_occ.occ01,g_occ.occ02,g_dbs,'2','Y')
            #CALL s_check_pmc01_occ01(g_occ.occ01,g_occ.occ02,g_plant,'2','Y')   #FUN-A50102
            #     RETURNING g_flag,g_flag1
            #IF g_flag = FALSE THEN
            #   LET g_occ.occ02 = g_occ_t.occ02
            #   DISPLAY BY NAME g_occ.occ02
            #   NEXT FIELD occ02
            #END IF
            ##No.FUN-A30110  --End 
            #No.FUN-BB0049  --End  
 
        AFTER FIELD occ34
           IF NOT cl_null(g_occ.occ34) THEN
               CALL i221_occ34('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_occ.occ34,g_errno,0)
                  LET g_occ.occ34 = g_occ_t.occ34
                  DISPLAY BY NAME g_occ.occ34
                  NEXT FIELD occ34
               END IF
           END IF
 
        AFTER FIELD occ08
          IF NOT cl_null(g_occ.occ08) THEN 
             LET l_count = 0 
             SELECT COUNT(*) INTO l_count FROM oom_file
              WHERE oom03 = g_occ.occ08
             IF l_count = 0 THEN 
                CALL cl_err('','axr-128',0)
                NEXT FIELD occ08
             END IF 
          END IF 
 
	AFTER FIELD occ03
            IF NOT cl_null(g_occ.occ03) THEN
                SELECT oca02 INTO g_buf FROM oca_file  #MOD-4B0240
                WHERE oca01=g_occ.occ03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","oca_file",g_occ.occ03,"",STATUS,"","select oca",1)  #No.FUN-660167
                  NEXT FIELD occ03
               END IF
               CALL s_field_chk(g_occ.occ03,'4',g_plant,'occ03') RETURNING g_flag2
               IF g_flag2 = '0' THEN
                  CALL cl_err(g_occ.occ03,'aoo-043',1)
                  LET g_occ.occ03 = g_occ_t.occ03
                  DISPLAY BY NAME g_occ.occ03
                  NEXT FIELD occ03
               END IF
                DISPLAY g_buf TO FORMONLY.oca02  #MOD-4B0240
            ELSE                               #FUN-640038 add
               DISPLAY ' ' TO FORMONLY.oca02   #FUN-640038 add
            END IF
 
     #FUN-AB0080---add---start---
      AFTER FIELD occ74
            IF NOT cl_null(g_occ.occ74) THEN
               LET l_n = 0
               SELECT COUNT(occ01) INTO l_n FROM occ_file
                WHERE occ01 = g_occ.occ74 
                  AND occ1004 = '1'
               IF cl_null(l_n) THEN LET l_n = 0 END IF
               IF l_n = 0 THEN
                  CALL cl_err(g_occ.occ74,'mfg9329',1)
                  LET g_occ.occ74 = g_occ_t.occ74
                  DISPLAY BY NAME g_occ.occ74
                  NEXT FIELD occ74
               END IF
              #MOD-B30480---modify---start---
              #SELECT occ02 INTO g_buf FROM occ_file
              # WHERE occ01=g_occ.occ74 AND occacti='Y'
              #DISPLAY g_buf TO FORMONLY.occ74_ds
               SELECT occ02,occacti INTO g_buf,l_occacti FROM occ_file
                WHERE occ01=g_occ.occ74
               IF l_occacti != 'Y' THEN
                  CALL cl_err(g_occ.occ74,'9028',1)
                  LET g_occ.occ74 = g_occ_t.occ74
                  DISPLAY BY NAME g_occ.occ74
                  NEXT FIELD occ74
               ELSE
                  DISPLAY g_buf TO FORMONLY.occ74_ds
               END IF
              #MOD-B30480---modify---end---
            END IF
     #FUN-AB0080---add---end---

      AFTER FIELD occ1003
            IF NOT cl_null(g_occ.occ1003) THEN
               CALL i221_occ1003('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_occ.occ1003,g_errno,0)
                  LET g_occ.occ1003 = g_occ_t.occ1003
                  DISPLAY BY NAME g_occ.occ1003
                  NEXT FIELD occ1003
               END IF
            END IF
 
        AFTER FIELD occ1006
           IF NOT cl_null(g_occ.occ1006) THEN
              CALL i221_occ1006('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_occ.occ1006,g_errno,0)
                 LET g_occ.occ1006 = g_occ_t.occ1006
                 DISPLAY BY NAME g_occ.occ1006
                 NEXT FIELD occ1006
              END IF
            END IF
 
        AFTER FIELD occ1007
           IF NOT cl_null(g_occ.occ1007) THEN
              CALL i221_occ1007('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_occ.occ1007,g_errno,0)
                 LET g_occ.occ1007 = g_occ_t.occ1007
                 DISPLAY BY NAME g_occ.occ1007
                 NEXT FIELD occ1007
              END IF
            END IF
 
        AFTER FIELD occ1008
           IF NOT cl_null(g_occ.occ1008) THEN
              CALL i221_occ1008('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_occ.occ1008,g_errno,0)
                 LET g_occ.occ1008 = g_occ_t.occ1008
                 DISPLAY BY NAME g_occ.occ1008
                 NEXT FIELD occ1008
              END IF
            END IF
 
        AFTER FIELD occ1009
           IF NOT cl_null(g_occ.occ1009) THEN
              CALL i221_occ1009('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_occ.occ1009,g_errno,0)
                 LET g_occ.occ1009 = g_occ_t.occ1009
                 DISPLAY BY NAME g_occ.occ1009
                 NEXT FIELD occ1009
              END IF
            END IF
 
        AFTER FIELD occ1010
           IF NOT cl_null(g_occ.occ1010) THEN
              CALL i221_occ1010('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_occ.occ1010,g_errno,0)
                 LET g_occ.occ1010 = g_occ_t.occ1010
                 DISPLAY BY NAME g_occ.occ1010
                 NEXT FIELD occ1010
              END IF
            END IF
 
        AFTER FIELD occ1011
           IF NOT cl_null(g_occ.occ1011) THEN
              CALL i221_occ1011('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_occ.occ1011,g_errno,0)
                 LET g_occ.occ1011 = g_occ_t.occ1011
                 DISPLAY BY NAME g_occ.occ1011
                 NEXT FIELD occ1011
              END IF
            END IF
 
        AFTER FIELD occ1016
	      IF NOT cl_null(g_occ.occ1016) THEN
	         CALL i221_occ1016('d')
	         IF NOT cl_null(g_errno) THEN
	            CALL cl_err('',g_errno,0)
                    NEXT FIELD occ1016
                 END IF
	      END IF
					
	BEFORE FIELD occ06
            CALL i221_set_entry(p_cmd)
            CALL i221_set_no_required(p_cmd)
 
	AFTER FIELD occ06
            IF NOT cl_null(g_occ.occ06) THEN
               IF g_occ.occ06 NOT MATCHES '[1234]' THEN    #NO.FUN-640011
                  NEXT FIELD occ06
               END IF
               IF g_occ.occ06 = '1' THEN
                     LET g_occ.occ07=g_occ.occ01 
                     LET g_occ.occ09=g_occ.occ01 
                  DISPLAY BY NAME g_occ.occ07,g_occ.occ09
                  IF g_occ.occ07 = g_occ.occ01 THEN
                     DISPLAY g_occ.occ02 TO FORMONLY.occ7_ds
                  ELSE
                     SELECT occ02 INTO g_buf FROM occ_file
                       WHERE occ01 = g_occ.occ07
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occ7_ds
                  END IF
                  IF g_occ.occ09 = g_occ.occ01 THEN
                     DISPLAY g_occ.occ02 TO FORMONLY.occ9_ds
                  ELSE
                     SELECT occ02 INTO g_buf FROM occ_file
                       WHERE occ01 = g_occ.occ09
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occ9_ds
                  END IF
               END IF
                IF g_occ.occ06 = '2' THEN #MOD-4B0241
                  IF cl_null(g_occ.occ07) THEN 
                     LET g_occ.occ07=g_occ.occ01 
                  END IF
                  LET g_occ.occ1022=NULL   #NO.FUN-640011
                  CALL cl_set_comp_entry("occ1022",FALSE)   #NO.FUN-640011
                  LET g_occ.occ09=g_occ.occ01   #MOD-760150 add
                  DISPLAY g_occ.occ02 TO FORMONLY.occ9_ds  #MOD-760150
                  DISPLAY BY NAME g_occ.occ07,g_occ.occ09
                  IF g_occ.occ07 = g_occ.occ01 THEN
                     DISPLAY g_occ.occ02 TO FORMONLY.occ7_ds
                  ELSE
                     SELECT occ02 INTO g_buf FROM occ_file
                       WHERE occ01 = g_occ.occ07
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occ7_ds
                  END IF
               END IF
                IF g_occ.occ06='3' THEN   #NO.TQC-650089
                  IF cl_null(g_occ.occ09) THEN 
                     LET g_occ.occ09=g_occ.occ01 
                  END IF
                  LET g_occ.occ07=g_occ.occ01             #MOD-760150 add
                  DISPLAY g_occ.occ02 TO FORMONLY.occ7_ds #MOD-760150 modify
                  DISPLAY BY NAME g_occ.occ07,g_occ.occ09
                  IF g_occ.occ09 = g_occ.occ01 THEN
                     DISPLAY g_occ.occ02 TO FORMONLY.occ9_ds
                  ELSE
                     SELECT occ02 INTO g_buf FROM occ_file
                       WHERE occ01 = g_occ.occ09
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occ9_ds
                  END IF
               END IF
                IF g_occ.occ06='4' THEN
                   IF cl_null(g_occ.occ09) THEN 
                      LET g_occ.occ09=g_occ.occ01 
                   END IF
                   LET g_occ.occ1022=' '
                   CALL cl_set_comp_entry("occ1022",FALSE)
                   DISPLAY BY NAME g_occ.occ07,g_occ.occ09
                  IF g_occ.occ09 = g_occ.occ01 THEN
                     DISPLAY g_occ.occ02 TO FORMONLY.occ9_ds
                  ELSE
                     SELECT occ02 INTO g_buf FROM occ_file
                       WHERE occ01 = g_occ.occ09
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occ9_ds
                  END IF
                END IF
            END IF
            CALL i221_set_no_entry(p_cmd)
            CALL i221_set_required(p_cmd)
 
	AFTER FIELD occ09
           IF NOT cl_null(g_occ.occ09) AND g_occ.occ09 != g_occ.occ01 THEN
 
              SELECT occ02 INTO g_buf FROM occ_file
               WHERE occ01=g_occ.occ09 AND occacti='Y'
                IF SQLCA.sqlcode THEN
                   LET g_buf=''
                   CALL cl_err3("sel","occ_file",g_occ.occ09,"",STATUS,"","select occ",1)  #No.FUN-660167
                   NEXT FIELD occ09
                END IF
                DISPLAY g_buf TO FORMONLY.occ9_ds
           ELSE
                DISPLAY g_occ.occ02 TO FORMONLY.occ9_ds
           END IF
 
        AFTER FIELD occ07
           IF NOT cl_null(g_occ.occ07) AND g_occ.occ07 != g_occ.occ01 THEN
              SELECT occ02 INTO g_buf FROM occ_file
               WHERE occ01=g_occ.occ07
                 AND occacti='Y'
              IF SQLCA.sqlcode THEN
                 LET g_buf=''
                 CALL cl_err3("sel","occ_file",g_occ.occ07,"",STATUS,"","select occ",1)  #No.FUN-660167
                 NEXT FIELD occ07
              END IF
              DISPLAY g_buf TO FORMONLY.occ7_ds
           ELSE
              DISPLAY g_occ.occ02 TO FORMONLY.occ7_ds
           END IF
 
	AFTER FIELD occ04
           IF NOT cl_null(g_occ.occ04) THEN
              SELECT gen02 INTO g_buf FROM gen_file
               WHERE gen01=g_occ.occ04
              IF STATUS THEN
                 LET g_buf = ''
                 CALL cl_err3("sel","gen_file",g_occ.occ04,"",STATUS,"","select gen",1)  #No.FUN-660167
                 NEXT FIELD occ04
              END IF
              DISPLAY g_buf TO FORMONLY.gen02
           ELSE                               #FUN-640038 add
              DISPLAY ' ' TO FORMONLY.gen02   #FUN-640038 add
           END IF
					
	AFTER FIELD occ11
           IF NOT cl_null(g_occ.occ11) THEN
              IF cl_null(g_occ_t.occ11) OR (g_occ_t.occ11 <> g_occ.occ11) THEN  #MOD-590138  #MOD-740031 add cl_null()
                 SELECT count(*) INTO l_n FROM occ_file
	          WHERE occ11 = g_occ.occ11 AND occ01 != g_occ.occ01
            #darcy:2022/04/08 s---
               IF l_n = 0 THEN 
                  SELECT count(1) INTO l_n FROM pmc_file 
                WHERE pmc24 = g_occ.occ11 
               END IF
               LET  l_occ01 = ""
               LET  l_pmc01 = ""
               SELECT occ01 INTO l_occ01 FROM occ_file 
                WHERE occ11 = g_occ.occ11 AND occ01 != g_occ.occ01
               SELECT pmc01 INTO l_pmc01 FROM pmc_file 
                WHERE pmc24 = g_occ.occ11 
               IF NOT cl_null(l_occ01) THEN 
                  LET l_str = "客户:",l_occ01
               END IF
               IF NOT cl_null(l_pmc01) THEN
                  IF cl_null(l_str) THEN 
                     LET l_str = " 供应商:",l_pmc01
                  ELSE 
                     LET l_str = l_str," 供应商:",l_pmc01
                  END IF 
               END IF 
            #darcy:2022/04/08 e---
	         IF l_n > 0 THEN
                    CALL cl_err(l_str,'axm-028',1) #MOD-490356
	         END IF
            #darcy:2023/04/19 add s---
            if not cl_null(l_occ01) then
               next field occ11
            end if
            #darcy:2023/04/19 add e---
                 IF g_aza.aza21 = 'Y' AND g_aza.aza26='0' THEN  #MOD-790130 modify aza26=0
                    LET l_occ11= g_occ.occ11 CLIPPED      #MOD-790130  #MOD-7C0124
                    IF NOT s_chkban(g_occ.occ11) OR l_occ11.getLength() > 8   #MOD-790130 modify 長度不可>8
                       OR NOT cl_numchk(g_occ.occ11,8)  THEN                  #MOD-790130
                       CALL cl_err('chkban-occ11:','aoo-080',0)
                       NEXT FIELD occ11
                    END IF
                 END IF
              END IF  #MOD-590138
           END IF
 
	AFTER FIELD occ20
           IF NOT cl_null(g_occ.occ20) THEN
              CALL i221_occ20('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD occ20
              END IF
           END IF
					
	AFTER FIELD occ21
           IF NOT cl_null(g_occ.occ21) THEN
              CALL i221_occ21('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD occ21
              END IF
              SELECT geb03 INTO g_occ.occ20 FROM geb_file
               WHERE geb01 = g_occ.occ21
              DISPLAY BY NAME g_occ.occ20
              CALL i221_occ20('a')
           END IF
	AFTER FIELD occ22
           IF NOT cl_null(g_occ.occ22) THEN
              CALL i221_occ22('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_occ.occ22,g_errno,0)
                 LET g_occ.occ22 = g_occ_t.occ22
                 DISPLAY BY NAME g_occ.occ22
                 DISPLAY ' ' TO occ21
                 DISPLAY ' ' TO occ20
                 DISPLAY ' ' TO occ21_desc
                 DISPLAY ' ' TO occ20_desc
                 NEXT FIELD occ22
              END IF
           END IF

       AFTER FIELD occ53
          IF NOT cl_null(g_occ.occ53) THEN
              IF g_occ.occ53 < 0 OR g_occ.occ53 > 100 THEN
                 CALL cl_err('','aec-002',0)
                 NEXT FIELD CURRENT  
              END IF 
          END IF  
 
        AFTER FIELD occ235   #FUN-720014
           IF cl_null(g_occ.occ241) THEN
              LET g_occ.occ241 = g_occ.occ231
              LET g_occ.occ242 = g_occ.occ232
              LET g_occ.occ243 = g_occ.occ233
              LET g_occ.occ244 = g_occ.occ234  #FUN-720014 add
              LET g_occ.occ245 = g_occ.occ235  #FUN-720014 add
              DISPLAY BY NAME g_occ.occ241,g_occ.occ242,g_occ.occ243,g_occ.occ244,g_occ.occ245 #FUN-720014 add 244/245
           END IF
 
        AFTER FIELD occ32                                                                                                           
           IF g_occ.occ32 < 0 OR g_occ.occ32 > 100 THEN                                                                             
              CALL cl_err(g_occ.occ32,'mfg0013',0)                                                                                  
              NEXT FIELD occ32                                                                                                      
           END IF                                                                                                                   
 
        AFTER FIELD occ38
           IF NOT cl_null(g_occ.occ38) THEN
              IF g_occ.occ38 < 1 OR g_occ.occ38 > 31 THEN
#                 CALL cl_err('','apy-000',0)    #CHI-B40058
                 CALL cl_err('','alm-729',0)     #CHI-B40058
                 NEXT FIELD occ38
              END IF
           END IF
 
        AFTER FIELD occ39
           IF NOT cl_null(g_occ.occ39) THEN
              IF g_occ.occ39 < 1 OR g_occ.occ39 > 31 THEN
#                 CALL cl_err('','apy-000',0)    #CHI-B40058
                 CALL cl_err('','alm-729',0)     #CHI-B40058
                 NEXT FIELD occ39
              END IF
           END IF
 
	AFTER FIELD occ40
           IF NOT cl_null(g_occ.occ40) THEN
              IF g_occ.occ40 NOT MATCHES '[YN]' THEN
                 NEXT FIELD occ40
              END IF
           END IF
 
        AFTER FIELD occ73
           IF NOT cl_null(g_occ.occ73) THEN
              IF g_occ.occ73 NOT MATCHES '[YN]' THEN
                 NEXT FIELD occ73
              END IF 
           END IF  
 
        AFTER FIELD occ41
	      IF NOT cl_null(g_occ.occ41) THEN
                 CALL i221_occ41('a')
	         IF NOT cl_null(g_errno) THEN
	            CALL cl_err('',g_errno,0)
                    NEXT FIELD occ41
	         END IF
              END IF
 
        AFTER FIELD occ43
	   IF g_occ.occ06 MATCHES "[13]" THEN
              IF cl_null(g_occ.occ43) THEN
                 CALL cl_err('','axm-221',0)
                 NEXT FIELD occ43
              END IF
 
	      CALL i221_occ43('a')
	      IF NOT cl_null(g_errno) THEN
	         CALL cl_err('',g_errno,0)
                 NEXT FIELD occ43
	      END IF
	   END IF
 
        AFTER FIELD occ44
	  #IF g_occ.occ06 MATCHES "[13]" THEN
	      IF NOT cl_null(g_occ.occ44) THEN
	         CALL i221_occ44('a')
	         IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0) NEXT FIELD occ44
                 END IF
	      END IF
	  # END IF
 
        AFTER FIELD occ45
	   #IF g_occ.occ06 MATCHES "[13]" THEN #TQC-AB0087 mark
 	      IF NOT cl_null(g_occ.occ45) THEN   #No.MOD-490356
	         CALL i221_occ45('a')
	         IF NOT cl_null(g_errno) THEN
	            CALL cl_err('',g_errno,0) NEXT FIELD occ45
	         END IF
	      END IF
	   #END IF                            #TQC-AB0087 mark
	   
	   #No.FUN-840183 -Add--Begin--#
	   AFTER FIELD occ68
	   IF g_occ.occ06 MATCHES "[13]" THEN
 	      IF NOT cl_null(g_occ.occ68) THEN   
	         CALL i221_occ68('a')
	         IF NOT cl_null(g_errno) THEN
	            CALL cl_err('',g_errno,0) NEXT FIELD occ68
	         END IF
	      END IF
	   END IF
	   
	   AFTER FIELD occ69
	   IF g_occ.occ06 MATCHES "[13]" THEN
 	      IF NOT cl_null(g_occ.occ69) THEN   
	         CALL i221_occ69('a')
	         IF NOT cl_null(g_errno) THEN
	            CALL cl_err('',g_errno,0) NEXT FIELD occ69
	         END IF
	      END IF
	   END IF
	   #No.FUN-840183 -Add--End--#
 
        AFTER FIELD occ67
           IF NOT cl_null(g_occ.occ67) THEN
              IF NOT i221_occ67('a') THEN
                 NEXT FIELD occ67
              END IF
           ELSE
              DISPLAY NULL TO FORMONLY.ool02
           END IF
 
	AFTER FIELD occ42
           IF NOT cl_null(g_occ.occ42) THEN
              CALL i221_occ42('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD occ42
              END IF
           END IF
 
        AFTER FIELD occ47
           IF NOT cl_null(g_occ.occ47) THEN
              SELECT COUNT(*) INTO l_n FROM ged_file
               WHERE ged01 = g_occ.occ47
              IF l_n = 0 THEN
                 CALL cl_err('','axm-309',0)
                 NEXT FIELD occ47
              END IF
           END IF
           CALL i221_occ47('a') #FUN-980018        
 
        AFTER FIELD occ48
           IF NOT cl_null(g_occ.occ48) THEN
              SELECT oac01 FROM oac_file
               WHERE oac01 = g_occ.occ48
              IF STATUS THEN
                 CALL cl_err3("sel","oac_file",g_occ.occ48,"",STATUS,"","select oac",1)  #No.FUN-660167
                 NEXT FIELD occ48
              END IF
           END IF
           CALL i221_occ48('a') #FUN-980018   
        AFTER FIELD occ49
           IF NOT cl_null(g_occ.occ49) THEN
              SELECT oac01 FROM oac_file
               WHERE oac01=g_occ.occ49
              IF STATUS THEN
                 CALL cl_err3("sel","oac_file",g_occ.occ49,"",STATUS,"","select oac",1)  #No.FUN-660167
                 NEXT FIELD occ49
              END IF
           END IF
           CALL i221_occ49('a') #FUN-980018                                                                                         
       AFTER FIELD occ50                                                                                                            
          IF NOT cl_null(g_occ.occ50) THEN                                                                                          
              SELECT oac01 FROM oac_file                                                                                            
               WHERE oac01=g_occ.occ50                                                                                              
              IF STATUS THEN                                                                                                        
                 CALL cl_err3("sel","oac_file",g_occ.occ50,"",STATUS,"","select oac",1)                                             
                 NEXT FIELD occ50                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
           CALL i221_occ50('a')                                                                                                     
        AFTER FIELD occ51
           IF NOT cl_null(g_occ.occ51) THEN
              SELECT pmc03 INTO g_buf FROM pmc_file
               WHERE pmc01 = g_occ.occ51
              IF STATUS THEN
                 CALL cl_err3("sel","pmc_file",g_occ.occ51,"",STATUS,"","select pmc_file",1)  #No.FUN-660167
                 NEXT FIELD occ51
              END IF
              DISPLAY g_buf TO pmc03
           END IF
 
        BEFORE FIELD occ55
           IF cl_null(g_occ.occ55) THEN
              LET g_occ.occ55 = '0' #中文
              DISPLAY BY NAME g_occ.occ55
           END IF
 
        AFTER FIELD occ56
           IF cl_null(g_occ.occ56) OR g_occ.occ56 NOT MATCHES '[YN]' THEN
              NEXT FIELD occ56
           END IF
 
        AFTER FIELD occ57
           IF cl_null(g_occ.occ57) OR g_occ.occ57 NOT MATCHES '[YN]' THEN
              NEXT FIELD occ57
           END IF
 
        AFTER FIELD occ65
           IF cl_null(g_occ.occ65) OR g_occ.occ65 NOT MATCHES '[YN]' THEN
              NEXT FIELD occ65
           END IF
 
        AFTER FIELD occ66
           IF NOT cl_null(g_occ.occ66) THEN
              SELECT pmc03 INTO g_buf FROM pmc_file
               WHERE pmc01=g_occ.occ66 AND pmc14='6'   #FUN-640014 將pmc14='5'改成pmc14='6'
              IF STATUS THEN
                 CALL cl_err3("sel","pmc_file",g_occ.occ66,"",STATUS,"","select pmc_file",1)  #No.FUN-660167
                 NEXT FIELD occ51
              END IF
              DISPLAY g_buf TO FORMONLY.pmc03_1
           ELSE                                 #FUN-640038 add
              DISPLAY ' ' TO FORMONLY.pmc03_1   #FUN-640038 add
           END IF
 
        AFTER FIELD occ1005
           IF NOT cl_null(g_occ.occ1005) THEN
              CALL i221_occ1005('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_occ.occ1005,g_errno,0)
                 LET g_occ.occ1005 = g_occ_t.occ1005
                 DISPLAY BY NAME g_occ.occ1005
                 NEXT FIELD occ1005
              END IF
              LET g_occ.occ1024=g_occ.occ1005
              LET g_occ.occ1025=g_occ.occ1005
           ELSE
              DISPLAY ' ' TO FORMONLY.tqb02
           END IF
      AFTER FIELD occ930
         IF NOT cl_null(g_occ.occ930) THEN
            SELECT COUNT(*) INTO l_n FROM occ_file WHERE occ930 = g_occ.occ930
            IF l_n > 0 THEN
               CALL cl_err(g_occ.occ930,'apm-191',0)
               LET g_occ.occ930 = g_occ_t.occ930                                                                                    
               NEXT FIELD occ930 
            END IF
            IF p_cmd='a' OR (p_cmd='u' AND g_occ.occ930<>g_occ_t.occ930) THEN 
               CALL i221_occ930('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_occ.occ930,g_errno,0)
                  LET g_occ.occ930 = g_occ_t.occ930
                  NEXT FIELD occ930
               END IF
            END IF
         END IF
 
      AFTER FIELD occ72
         IF NOT cl_null(g_occ.occ72) THEN
            IF g_occ.occ72<0 THEN
               CALL cl_err('','axm-109',0)
               LET g_occ.occ72 = g_occ_t.occ72
               NEXT FIELD occ72
            END IF
        END IF

#FUN-B90105 add------begin-----
    AFTER FIELD occ76
       IF NOT cl_null(g_occ.occ76) THEN
          IF g_occ.occ76 < 0 OR g_occ.occ76 > 100 THEN
             CALL cl_err(g_occ.occ76,'axm1100',0)
             NEXT FIELD occ76
          END IF
      END IF

     AFTER FIELD occ77
        IF NOT cl_null(g_occ.occ77) THEN
           IF g_occ.occ77 < 0 OR g_occ.occ77 > 100 THEN
              CALL cl_err(g_occ.occ77,'axm1100',0)
              NEXT FIELD occ77
           END IF
        END IF
#FUN-B90105 add---------end---------
 
        AFTER FIELD occud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #AFTER FIELD occud02
        #   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       ON CHANGE occ02
          IF g_aza.aza44 = "Y" THEN
             IF g_zx14 = "Y" AND g_on_change THEN
                CALL p_itemname_update("occ_file","occ02",g_occ.occ01) #TQC-6C0060
                CALL cl_show_fld_cont()   #TQC-6C0060
             END IF
          END IF

       #No.FUN-A30110  --Begin
       AFTER INPUT
          LET g_occ.occuser = s_get_data_owner("occ_file") #FUN-C10039
          LET g_occ.occgrup = s_get_data_group("occ_file") #FUN-C10039
          IF INT_FLAG THEN EXIT INPUT  END IF
       #No.FUN-A30110  --End  

       ON ACTION update_item
          IF g_aza.aza44 = "Y" THEN
             CALL GET_FLDBUF(occ02) RETURNING g_occ.occ02
             CALL p_itemname_update("occ_file","occ02",g_occ.occ01) #TQC-6C0060 mark
             LET g_on_change=FALSE
             CALL cl_show_fld_cont()   #TQC-6C0060
          ELSE
             CALL cl_err(g_occ.occ02,"lib-151",1)
          END IF
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(occ03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oca'
                 LET g_qryparam.default1 = g_occ.occ03
                 CALL cl_create_qry() RETURNING g_occ.occ03
                 DISPLAY BY NAME g_occ.occ03
                 NEXT FIELD occ03
             WHEN INFIELD(occ04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_gen'
                 LET g_qryparam.default1 = g_occ.occ04
                 CALL cl_create_qry() RETURNING g_occ.occ04
                 DISPLAY BY NAME g_occ.occ04
                 NEXT FIELD occ04
        WHEN INFIELD(occ08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_occ081'
                 LET g_qryparam.default1 = g_occ.occ08
                 CALL cl_create_qry() RETURNING g_occ.occ08
                 DISPLAY BY NAME g_occ.occ08
                 NEXT FIELD occ08
 
             WHEN INFIELD(occ09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_occ'
                 LET g_qryparam.default1 = g_occ.occ09
                 CALL cl_create_qry() RETURNING g_occ.occ09
                 DISPLAY BY NAME g_occ.occ09
                 NEXT FIELD occ09
 
             WHEN INFIELD(occ07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_occ'
                 LET g_qryparam.default1 = g_occ.occ07
                 CALL cl_create_qry() RETURNING g_occ.occ07
                 DISPLAY BY NAME g_occ.occ07
                 NEXT FIELD occ07
             WHEN INFIELD(occ34)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ34'
                  LET g_qryparam.arg1 = g_occ.occ01
                  LET g_qryparam.default1 = g_occ.occ34
                  CALL cl_create_qry() RETURNING g_occ.occ34
                  DISPLAY BY NAME g_occ.occ34
                  NEXT FIELD occ34             
             WHEN INFIELD(occ20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_gea'
                 LET g_qryparam.default1 = g_occ.occ20
                 CALL cl_create_qry() RETURNING g_occ.occ20
                 DISPLAY BY NAME g_occ.occ20
                 NEXT FIELD occ20
             WHEN INFIELD(occ21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_geb'
                 LET g_qryparam.default1 = g_occ.occ21
                 CALL cl_create_qry() RETURNING g_occ.occ21
                 DISPLAY BY NAME g_occ.occ21
                 NEXT FIELD occ21
             WHEN INFIELD(occ22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_geo'
                 LET g_qryparam.default1 = g_occ.occ22
                 CALL cl_create_qry() RETURNING g_occ.occ22
                 DISPLAY BY NAME g_occ.occ22
                 NEXT FIELD occ22
              WHEN INFIELD(occ41)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_gec'
                   LET g_qryparam.default1 = g_occ.occ41
                   LET g_qryparam.arg1 = '2'
                   CALL cl_create_qry() RETURNING g_occ.occ41
                   DISPLAY BY NAME g_occ.occ41
                   NEXT FIELD occ41
              WHEN INFIELD(occ47)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_ged'
                  LET g_qryparam.default1 = g_occ.occ47
                  CALL cl_create_qry() RETURNING g_occ.occ47
                  DISPLAY BY NAME g_occ.occ47
                  NEXT FIELD occ47
              WHEN INFIELD(occ03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oca'
                 LET g_qryparam.default1 = g_occ.occ03
                 CALL cl_create_qry() RETURNING g_occ.occ03
                 DISPLAY BY NAME g_occ.occ03
                 NEXT FIELD occ03
 
              WHEN INFIELD(occ43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oab'
                 LET g_qryparam.default1 = g_occ.occ43
                 CALL cl_create_qry() RETURNING g_occ.occ43
                 DISPLAY BY NAME g_occ.occ43
                 NEXT FIELD occ43
 
              WHEN INFIELD(occ44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oah'
                 LET g_qryparam.default1 = g_occ.occ44
                 CALL cl_create_qry() RETURNING g_occ.occ44
                 DISPLAY BY NAME g_occ.occ44
                 NEXT FIELD occ44
 
              WHEN INFIELD(occ45)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occ.occ45
                 CALL cl_create_qry() RETURNING g_occ.occ45
                 DISPLAY BY NAME g_occ.occ45
                 NEXT FIELD occ45
                 
                WHEN INFIELD(occ68)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occ.occ68
                 CALL cl_create_qry() RETURNING g_occ.occ68
                 DISPLAY BY NAME g_occ.occ68
                 NEXT FIELD occ68
                 
              WHEN INFIELD(occ69)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occ.occ69
                 CALL cl_create_qry() RETURNING g_occ.occ69
                 DISPLAY BY NAME g_occ.occ69
                 NEXT FIELD occ69                             
 
              WHEN INFIELD(occ67)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ool"
                   LET g_qryparam.default1 = g_occ.occ67
                   CALL cl_create_qry() RETURNING g_occ.occ67
                   DISPLAY BY NAME g_occ.occ67
                   NEXT FIELD occ67
 
# 加查詢明細資料
              WHEN INFIELD(occ42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_azi'
                 LET g_qryparam.default1 = g_occ.occ42
                 CALL cl_create_qry() RETURNING g_occ.occ42
                 DISPLAY BY NAME g_occ.occ42
                 NEXT FIELD occ42
 
              WHEN INFIELD(occ48)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oac'
                 LET g_qryparam.default1 = g_occ.occ48
                 CALL cl_create_qry() RETURNING g_occ.occ48
                 DISPLAY BY NAME g_occ.occ48
                 NEXT FIELD occ48
 
              WHEN INFIELD(occ49)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oac'
                 LET g_qryparam.default1 = g_occ.occ49
                 CALL cl_create_qry() RETURNING g_occ.occ49
                 DISPLAY BY NAME g_occ.occ49
                 NEXT FIELD occ49
 
              WHEN INFIELD(occ50)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_oac'
                  LET g_qryparam.default1 = g_occ.occ50
                  CALL cl_create_qry() RETURNING g_occ.occ50
                  DISPLAY BY NAME g_occ.occ50
                  NEXT FIELD occ50
 
              WHEN INFIELD(occ51)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_pmc'
                 LET g_qryparam.default1 = g_occ.occ51
                 CALL cl_create_qry() RETURNING g_occ.occ51
                 DISPLAY BY NAME g_occ.occ51
                 NEXT FIELD occ51
 
              WHEN INFIELD(occ66)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_pmc8'   #FUN-640014 modify
                 LET g_qryparam.default1 = g_occ.occ66
                 CALL cl_create_qry() RETURNING g_occ.occ66
                 DISPLAY BY NAME g_occ.occ66
                 NEXT FIELD occ66
             WHEN INFIELD(occ1005)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqb'
                  LET g_qryparam.default1 = g_occ.occ1005
                  CALL cl_create_qry() RETURNING g_occ.occ1005
                  DISPLAY BY NAME g_occ.occ1005
                  NEXT FIELD occ1005
            #FUN-AB0080---add---start---
             WHEN INFIELD(occ74)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ02'
                  LET g_qryparam.default1 = g_occ.occ74
                  CALL cl_create_qry() RETURNING g_occ.occ74
                  DISPLAY BY NAME g_occ.occ74
                  NEXT FIELD occ74
            #FUN-AB0080---add---end---
             WHEN INFIELD(occ1003)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqa'
                  LET g_qryparam.arg1 = '12'
                  LET g_qryparam.default1 = g_occ.occ1003
                  CALL cl_create_qry() RETURNING g_occ.occ1003
                  DISPLAY BY NAME g_occ.occ1003
                  NEXT FIELD occ1003
             WHEN INFIELD(occ1006)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqa'
                  LET g_qryparam.arg1 = '19'
                  LET g_qryparam.default1 = g_occ.occ1006
                  CALL cl_create_qry() RETURNING g_occ.occ1006
                  DISPLAY BY NAME g_occ.occ1006
                  NEXT FIELD occ1006
             WHEN INFIELD(occ1007)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqa'
                  LET g_qryparam.arg1 = '10'
                  LET g_qryparam.default1 = g_occ.occ1007
                  CALL cl_create_qry() RETURNING g_occ.occ1007
                  DISPLAY BY NAME g_occ.occ1007
                  NEXT FIELD occ1007
             WHEN INFIELD(occ1008)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqa'
                  LET g_qryparam.arg1 = '11'
                  LET g_qryparam.default1 = g_occ.occ1008
                  CALL cl_create_qry() RETURNING g_occ.occ1008
                  DISPLAY BY NAME g_occ.occ1008
                  NEXT FIELD occ1008
             WHEN INFIELD(occ1009)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_too2'
                 LET g_qryparam.default1 = g_occ.occ1009
                 CALL cl_create_qry() RETURNING g_occ.occ1009
                 DISPLAY BY NAME g_occ.occ1009
                 NEXT FIELD occ1009
             WHEN INFIELD(occ1010)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_top01'     #MOD-640199
                 LET g_qryparam.arg1 = g_occ.occ1009
                 LET g_qryparam.default1 = g_occ.occ1010
                 CALL cl_create_qry() RETURNING g_occ.occ1010
                 DISPLAY BY NAME g_occ.occ1010
                 NEXT FIELD occ1010
             WHEN INFIELD(occ1011)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_toq1'
                 LET g_qryparam.arg1 = g_occ.occ1010
                 LET g_qryparam.default1 = g_occ.occ1011
                 CALL cl_create_qry() RETURNING g_occ.occ1011
                 DISPLAY BY NAME g_occ.occ1011
                 NEXT FIELD occ1011
             WHEN INFIELD(occ1016)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_imd1'
                 LET g_qryparam.default1 = g_occ.occ1016
                 CALL cl_create_qry() RETURNING g_occ.occ1016
                 DISPLAY BY NAME g_occ.occ1016
                 NEXT FIELD occ1016
             WHEN INFIELD(occ930)                                                                                                  
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = 'q_azp'                                                                                     
                 LET g_qryparam.default1 = g_occ.occ930                                                                            
                 CALL cl_create_qry() RETURNING g_occ.occ930                                                                       
                 DISPLAY BY NAME g_occ.occ930
                 CALL i221_occ930('d')                                                                                      
                 NEXT FIELD occ930
 
             #WHEN INFIELD(occud02)
             #   CALL cl_dynamic_qry() RETURNING g_occ.occud02
             #   DISPLAY BY NAME g_occ.occud02
             #   NEXT FIELD occud02
             WHEN INFIELD(occud03)
                CALL cl_dynamic_qry() RETURNING g_occ.occud03
                DISPLAY BY NAME g_occ.occud03
                NEXT FIELD occud03
             WHEN INFIELD(occud04)
                CALL cl_dynamic_qry() RETURNING g_occ.occud04
                DISPLAY BY NAME g_occ.occud04
                NEXT FIELD occud04
             WHEN INFIELD(occud05)
                CALL cl_dynamic_qry() RETURNING g_occ.occud05
                DISPLAY BY NAME g_occ.occud05
                NEXT FIELD occud05
             WHEN INFIELD(occud06)
                CALL cl_dynamic_qry() RETURNING g_occ.occud06
                DISPLAY BY NAME g_occ.occud06
                NEXT FIELD occud06
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
FUNCTION i221_occ47(p_cmd)  #慣用交運方式                                                                                           
   DEFINE   p_cmd       LIKE type_file.chr1,                                                                                        
            l_ged02     LIKE ged_file.ged02            #交運方式說明                                                                
   LET g_errno = ' '                                                                                                                
   SELECT ged02                                                                                                                     
     INTO l_ged02                                                                                                                   
     FROM ged_file                                                                                                                  
    WHERE ged01 = g_occ.occ47                                                                                                       
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'                                                                           
                                  LET l_ged02   = NULL                                                                              
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   DISPLAY l_ged02 TO occ47_desc                                                                                                    
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i221_occ48(p_cmd)  #慣用運送起點                                                                                           
   DEFINE   p_cmd       LIKE type_file.chr1,                                                                                        
            l_oac02     LIKE ged_file.ged02            #運送起點說明                                                                
                                                                                                                                    
   LET g_errno = ' '                                                                                                                
   SELECT oac02                                                                                                                     
     INTO l_oac02                        
     FROM oac_file                                                                                                                  
    WHERE oac01 = g_occ.occ48                                                                                                       
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'                                                                           
                                  LET l_oac02   = NULL                                                                              
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   DISPLAY l_oac02 TO occ48_desc                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i221_occ49(p_cmd)  #慣用運送終點                                                                                           
   DEFINE   p_cmd       LIKE type_file.chr1,                                                                                        
            l_oac02     LIKE oac_file.oac02            #運送終點說明                                                                
                                                                                                                                    
   LET g_errno = ' '                                                                                                                
   SELECT oac02                                                                                                                     
     INTO l_oac02                                                                                                                   
     FROM oac_file                                                                                                                  
    WHERE oac01 = g_occ.occ49                                                                                                       
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'                                                                           
                                  LET l_oac02   = NULL                                                                              
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   DISPLAY l_oac02 TO occ49_desc                                                                                                    
END FUNCTION                                      
FUNCTION i221_occ50(p_cmd)  #卸貨港                                                                                                 
   DEFINE   p_cmd       LIKE type_file.chr1,                                                                                        
            l_oac02     LIKE oac_file.oac02            #卸貨港說明                                                                  
                                                                                                                                    
   LET g_errno = ' '                                                                                                                
   SELECT oac02                                                                                                                     
     INTO l_oac02                                                                                                                   
     FROM oac_file                                                                                                                  
    WHERE oac01 = g_occ.occ50                                                                                                       
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'                                                                           
                                  LET l_oac02   = NULL                                                                              
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   DISPLAY l_oac02 TO occ50_desc                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
 
FUNCTION i221_occ41(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
       l_gecacti       LIKE gec_file.gecacti,
       l_gec02         LIKE gec_file.gec02
 
   LET g_errno = ' '
 
   SELECT gec02,gecacti INTO l_gec02,l_gecacti
       FROM gec_file
       WHERE gec01 = g_occ.occ41
         AND gec011='2'  #銷項
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axm-142'
                           LET l_gec02 = NULL
        WHEN l_gecacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
      DISPLAY l_gec02 TO gec02
 
END FUNCTION
 
FUNCTION i221_occ43(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
    l_oab02       	LIKE oab_file.oab02
 
    LET g_errno = ' '
    SELECT oab02 INTO l_oab02
        FROM oab_file
        WHERE oab01 = g_occ.occ43
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4099'
                            LET l_oab02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
       DISPLAY l_oab02 TO oab02
END FUNCTION
 
FUNCTION i221_occ44(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
    l_oah02         LIKE oah_file.oah02
 
    LET g_errno = ' '
    SELECT oah02 INTO l_oah02
        FROM oah_file
        WHERE oah01 = g_occ.occ44
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4101'
                            LET l_oah02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
       DISPLAY l_oah02 TO oah02
END FUNCTION
 
FUNCTION i221_occ20(p_cmd)  #區域
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
    l_gea02         LIKE gea_file.gea02,
     l_geaacti       LIKE gea_file.geaacti #MOD-530303
 
    LET g_errno = ' '
     SELECT gea02,geaacti INTO l_gea02,l_geaacti #MOD-530303
        FROM gea_file
        WHERE gea01 = g_occ.occ20
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3139'   #No.MOD-590029
                                   LET l_gea02 = NULL
          WHEN l_geaacti='N'        LET g_errno='9028' #MOD-530303
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
       DISPLAY l_gea02 TO occ20_desc
END FUNCTION
 
FUNCTION i221_occ21(p_cmd)  #國別
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
    l_geb02         LIKE geb_file.geb02,
     l_gebacti       LIKE geb_file.gebacti #MOD-530303
 
    LET g_errno = ' '
     SELECT geb02,gebacti INTO l_geb02,l_gebacti #MOD-530303
        FROM geb_file
        WHERE geb01 = g_occ.occ21
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3029'   #No.MOD-590029
                            LET l_geb02 = NULL
          WHEN l_gebacti='N'        LET g_errno='9028' #MOD-530303
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
       DISPLAY l_geb02 TO occ21_desc
END FUNCTION
FUNCTION i221_occ22(p_cmd)  #地區代號
   DEFINE   p_cmd       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
            l_geo03     LIKE geb_file.geb03,            #國別代號
            l_geb02     LIKE gea_file.gea02,            #國別名稱
            l_geo02     LIKE geb_file.geb02,            #地區代號
            l_geoacti   LIKE geb_file.gebacti,          #有效碼
            l_gea02     LIKE gea_file.gea02             #區域名稱
 
   LET g_errno = ' '
   SELECT geo03,geoacti,geo02
     INTO l_geo03,l_geoacti,l_geo02
     FROM geo_file
    WHERE geo01 = g_occ.occ22
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'
                                  LET l_geo03   = NULL
                                  LET l_geoacti = NULL
        WHEN l_geoacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'a' THEN
      LET g_occ.occ21 = l_geo03
 
      DISPLAY BY NAME g_occ.occ21
      SELECT geb02 INTO l_geb02 FROM geb_file WHERE geb01 = g_occ.occ21
      DISPLAY l_geb02 TO occ21_desc
      SELECT gea01,gea02 INTO g_occ.occ20,l_gea02 FROM gea_file,geb_file
       WHERE gea01 = geb03 AND geb01 = l_geo03
      DISPLAY BY NAME g_occ.occ20
      DISPLAY l_gea02 TO occ20_desc
   END IF
   DISPLAY l_geo02 TO occ22_desc  #No.TQC-5B0192
 
END FUNCTION
 
FUNCTION i221_occ45(p_cmd)
 
   DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_oag02         LIKE oag_file.oag02
 
    LET g_errno = ' '
    SELECT oag02 INTO l_oag02
        FROM oag_file
        WHERE oag01 = g_occ.occ45
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9357'
                            LET l_oag02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
       DISPLAY l_oag02 TO oag02
END FUNCTION
 
FUNCTION i221_occ68(p_cmd)
 
   DEFINE p_cmd           LIKE type_file.chr1,  
          l_oag02         LIKE oag_file.oag02
 
    LET g_errno = ' '
    SELECT oag02 INTO l_oag02
        FROM oag_file
        WHERE oag01 = g_occ.occ68
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9357'
                            LET l_oag02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
       DISPLAY l_oag02 TO oag02_1
END FUNCTION
 
FUNCTION i221_occ69(p_cmd)
 
   DEFINE p_cmd           LIKE type_file.chr1,  
          l_oag02         LIKE oag_file.oag02
 
    LET g_errno = ' '
    SELECT oag02 INTO l_oag02
        FROM oag_file
        WHERE oag01 = g_occ.occ69
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9357'
                            LET l_oag02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
       DISPLAY l_oag02 TO oag02_2
 
END FUNCTION
 
FUNCTION i221_occ67(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_ool02 LIKE ool_file.ool02
   LET l_ool02=''
   SELECT ool02 INTO l_ool02 FROM ool_file WHERE ool01=g_occ.occ67
   IF (SQLCA.sqlcode) AND (p_cmd='a') THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      DISPLAY NULL TO FORMONLY.ool02
      RETURN FALSE
   END IF
   DISPLAY l_ool02 TO FORMONLY.ool02
   RETURN TRUE
END FUNCTION
 
FUNCTION i221_occ42(p_cmd)  #幣別
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
    l_aziacti       LIKE azi_file.aziacti
 
    LET g_errno = ' '
    SELECT aziacti INTO l_aziacti
        FROM azi_file
        WHERE azi01 = g_occ.occ42
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
         WHEN l_aziacti='N'        LET g_errno='9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
 
FUNCTION i221_occ1005(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_tqb02    LIKE tqb_file.tqb02,
          l_tqbacti  LIKE tqb_file.tqbacti
 
   LET g_errno=''
 
   SELECT tqb02,tqbacti INTO l_tqb02,l_tqbacti
     FROM tqb_file
    WHERE tqb01=g_occ.occ1005
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_tqb02=NULL
        WHEN l_tqbacti='N'       LET g_errno='9028'
                                 LET l_tqb02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_tqb02 TO FORMONLY.tqb02
 
END FUNCTION
FUNCTION i221_occ1003(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqaacti  LIKE tqa_file.tqaacti
 
   LET g_errno=''
 
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01=g_occ.occ1003
      AND tqa03='12'
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_tqa02=NULL
        WHEN l_tqaacti='N'       LET g_errno='9028'
                                 LET l_tqa02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_tqa02 TO FORMONLY.tqa02c
 
END FUNCTION
FUNCTION i221_occ1006(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqaacti  LIKE tqa_file.tqaacti
 
   LET g_errno=''
 
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01=g_occ.occ1006
      AND tqa03='19'
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_tqa02=NULL
        WHEN l_tqaacti='N'       LET g_errno='9028'
                                 LET l_tqa02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_tqa02 TO FORMONLY.tqa02
 
END FUNCTION
 
FUNCTION i221_occ1007(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqaacti  LIKE tqa_file.tqaacti
 
   LET g_errno=''
 
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01=g_occ.occ1007
      AND tqa03='10'
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_tqa02=NULL
        WHEN l_tqaacti='N'       LET g_errno='9028'
                                 LET l_tqa02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_tqa02 TO FORMONLY.tqa02a
 
END FUNCTION
 
FUNCTION i221_occ1008(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqaacti  LIKE tqa_file.tqaacti
 
   LET g_errno=''
 
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01=g_occ.occ1008
      AND tqa03='11'
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_tqa02=NULL
        WHEN l_tqaacti='N'       LET g_errno='9028'
                                 LET l_tqa02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_tqa02 TO FORMONLY.tqa02b
 
END FUNCTION
FUNCTION i221_occ1009(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_too02    LIKE too_file.too02,
          l_tooacti  LIKE too_file.tooacti
 
   LET g_errno=''
 
   SELECT too02,tooacti INTO l_too02,l_tooacti
     FROM too_file
    WHERE too01=g_occ.occ1009
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_too02=NULL
        WHEN l_tooacti='N'       LET g_errno='9028'
                                 LET l_too02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_too02 TO FORMONLY.too02
 
END FUNCTION
 
FUNCTION i221_occ1010(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_top02    LIKE top_file.top02,
          l_topacti  LIKE top_file.topacti
 
   LET g_errno=''
 
   SELECT top02,topacti INTO l_top02,l_topacti
     FROM top_file
    WHERE top01=g_occ.occ1010
      AND top03=g_occ.occ1009
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_top02=NULL
        WHEN l_topacti='N'       LET g_errno='9028'
                                 LET l_top02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_top02 TO FORMONLY.top02
 
END FUNCTION
 
FUNCTION i221_occ1011(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_toq02    LIKE toq_file.toq02,
          l_toqacti  LIKE toq_file.toqacti
 
   LET g_errno=''
 
   SELECT toq02,toqacti INTO l_toq02,l_toqacti
     FROM toq_file
    WHERE toq01=g_occ.occ1011
      AND toq03=g_occ.occ1010
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_toq02=NULL
        WHEN l_toqacti='N'       LET g_errno='9028'
                                 LET l_toq02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_toq02 TO FORMONLY.toq02
 
END FUNCTION
 
FUNCTION i221_occ1016(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_imd02    LIKE imd_file.imd02,
          l_imdacti  LIKE imd_file.imdacti
 
   LET g_errno=''
 
   SELECT imd02,imdacti INTO l_imd02,l_imdacti
     FROM imd_file
    WHERE imd01=g_occ.occ1016
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_imd02=NULL
        WHEN l_imdacti='N'       LET g_errno='9028'
                                 LET l_imd02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_imd02 TO FORMONLY.imd02
 
END FUNCTION
 
FUNCTION i221_occ930(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1,  
        l_azp02    LIKE azp_file.azp02
          
   LET g_errno = ' '
   SELECT azp02 INTO l_azp02
          FROM azp_file 
          WHERE azp01 = g_occ.occ930
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-002' 
                                 LET l_azp02=NULL 
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azp02 TO FORMONLY.occ930_desc
  END IF
 
END FUNCTION
 
FUNCTION i221_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i221_curs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
 
   OPEN i221_count
   FETCH i221_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i221_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
      INITIALIZE g_occ.* TO NULL
   ELSE
      CALL i221_fetch('F')                  # 讀出TEMP第一筆並顯示
      CALL i221_list_fill()  #No.FUN-7C0010
      LET g_bp_flag = 'list' #No.FUN-7C0010
   END IF
END FUNCTION
 
FUNCTION i221_list_fill()
  DEFINE l_occ01         LIKE occ_file.occ01
  DEFINE l_i             LIKE type_file.num10
 
    CALL g_occ_l.clear()
    LET l_i = 1
    FOREACH i221_list_cur INTO l_occ01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach list_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT occ01,occ02,occ03,occ04,occ05,occ06,
              occ22,occ21,occ20,occ11,occ1004,
              occacti,occ246
         INTO g_occ_l[l_i].*
         FROM occ_file
        WHERE occ01=l_occ01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN   #CHI-BB0034 add
            CALL cl_err( '', 9035, 0 )
          END IF                              #CHI-BB0034 add
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_occ_l TO s_occ_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
END FUNCTION
 
FUNCTION i221_fetch(p_flocc)
   DEFINE p_flocc       LIKE type_file.chr1    #No.FUN-680137   VARCHAR(1)
 
   CASE p_flocc
       WHEN 'N' FETCH NEXT     i221_cs INTO g_occ.occ01
       WHEN 'P' FETCH PREVIOUS i221_cs INTO g_occ.occ01
       WHEN 'F' FETCH FIRST    i221_cs INTO g_occ.occ01
       WHEN 'L' FETCH LAST     i221_cs INTO g_occ.occ01
       WHEN '/'
           IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
 
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
 
                 ON ACTION about         #MOD-4C0121
                    CALL cl_about()      #MOD-4C0121
 
                 ON ACTION help          #MOD-4C0121
                    CALL cl_show_help()  #MOD-4C0121
 
                 ON ACTION controlg      #MOD-4C0121
                    CALL cl_cmdask()     #MOD-4C0121
 
              END PROMPT
 
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
           END IF
           FETCH ABSOLUTE g_jump i221_cs INTO g_occ.occ01
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
      INITIALIZE g_occ.* TO NULL    #NO.FUN-6B0079 add
      RETURN
   ELSE
      CASE p_flocc
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_occ.* FROM occ_file
    WHERE occ01 = g_occ.occ01
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      INITIALIZE g_occ.* TO NULL            #FUN-4C0057 add
   ELSE
 
      LET g_data_owner = g_occ.occuser      #FUN-4C0057 add
      LET g_data_group = g_occ.occgrup      #FUN-4C0057 add
      CALL i221_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i221_show()
  DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(40)
    DISPLAY BY NAME g_occ.occoriu,g_occ.occorig,
          g_occ.occ01,  g_occ.occ02,  g_occ.occ18,  g_occ.occ19, #g_occ.occ1001,g_occ.occ1002,  #NO.FUN-640011   #MOD-910146
          g_occ.occ11,  g_occ.occ37,  g_occ.occ28,  g_occ.occ34,
          g_occ.occ66,  g_occ.occ1005,   #FUN-630027 增加g_occ.occ66
          g_occ.occ1004,g_occ.occ06,  g_occ.occ09,  g_occ.occ07,  g_occ.occ03, g_occ.occ04,    #No.FUN-640011
          g_occ.occ56,  g_occ.occ57,
          g_occ.occ22,  g_occ.occ21,  g_occ.occ20,   g_occ.occ35,    #FUN-550091
          g_occ.occ231, g_occ.occ232, g_occ.occ233, g_occ.occ234, g_occ.occ235,  #FUN-720014 add occ234/235
          g_occ.occ241, g_occ.occ242, g_occ.occ243, g_occ.occ244, g_occ.occ245,  #FUN-720014 add occ244/245
          g_occ.occ31, g_occ.occpos,  #FUN-870100 add occpos
          g_occ.occ65,  #No.FUN-610020
          g_occ.occ261, g_occ.occ262, g_occ.occ263, g_occ.occ271,g_occ.occ272,
          g_occ.occ29,  g_occ.occ30,  g_occ.occ292, g_occ.occ302,
          g_occ.occ40,  g_occ.occ38,  g_occ.occ39,
          g_occ.occ73,     #FUN-990031 add
          g_occ.occ16,  g_occ.occ171, g_occ.occ172, g_occ.occ173,g_occ.occ174,
          g_occ.occuser,g_occ.occgrup,g_occ.occmodu,g_occ.occdate,g_occ.occacti,
          g_occ.occ62,  g_occ.occ33,  g_occ.occ61,  g_occ.occ36, g_occ.occ175,
          g_occ.occ631, g_occ.occ63,  g_occ.occ64,
          g_occ.occ42,  g_occ.occ41,  g_occ.occ08,  g_occ.occ44, g_occ.occ45,
          g_occ.occ68,  g_occ.occ69,  g_occ.occ67,  #FUN-570065                 #FUN-840183 add occ68,occ69
          g_occ.occ43,  g_occ.occ55,  g_occ.occ47,
          g_occ.occ48,  g_occ.occ49,  g_occ.occ50,
          g_occ.occ46,  g_occ.occ53,  g_occ.occ32,
          g_occ.occ51,  g_occ.occ52, #BugNo:A036
          g_occ.occ701, g_occ.occ702, g_occ.occ703, g_occ.occ704,
          g_occ.occ76, g_occ.occ77,   #FUN-B90105 add
          g_occ.occ12,  g_occ.occ13,  g_occ.occ14,  g_occ.occ15, g_occ.occ05,
          g_occ.occ930,  g_occ.occ71,  g_occ.occ72,  #FUN-870100 add
          g_occ.occ1706,   #FUN-6A0007
          g_occ.occ1705,   #FUN-6A0007
          g_occ.occ1707,g_occ.occ1708,   #FUN-6A0007
          g_occ.occ74,g_occ.occ75,      #FUN-AB0080 add
          g_occ.occud01,g_occ.occud02,g_occ.occud03,g_occ.occud04,g_occ.occud05,
          g_occ.occud06,g_occ.occud07,g_occ.occud08,g_occ.occud09,g_occ.occud10,
          g_occ.occud11,g_occ.occud12,g_occ.occud13,g_occ.occud14,g_occ.occud15,
          g_occ.occ1003,g_occ.occ1006,g_occ.occ1007,g_occ.occ1008,g_occ.occ1009,
          g_occ.occ1010,g_occ.occ1011,g_occ.occ1012,g_occ.occ1013,g_occ.occ1014,
          g_occ.occ1015,g_occ.occ1016,g_occ.occ1027,g_occ.occ246  #No.FUN-7C0010
     SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_occ.occ09
     IF STATUS THEN LET g_buf='' END IF
     DISPLAY g_buf TO FORMONLY.occ9_ds
     SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_occ.occ07
     IF STATUS THEN LET g_buf='' END IF
     DISPLAY g_buf TO FORMONLY.occ7_ds
     SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=g_occ.occ04
     IF STATUS THEN LET g_buf='' END IF
     DISPLAY g_buf TO FORMONLY.gen02
     SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_occ.occ74     #FUN-AB0080 add       
     IF STATUS THEN LET g_buf='' END IF                                #FUN-AB0080 add     
     DISPLAY g_buf TO FORMONLY.occ74_ds                                #FUN-AB0080 add  
     SELECT oca02 INTO g_buf FROM oca_file
       WHERE oca01=g_occ.occ03
     IF STATUS THEN LET g_buf='' END IF
     DISPLAY g_buf TO FORMONLY.oca02
     CALL i221_occ1006('d')
     CALL i221_occ1007('d')
     CALL i221_occ1008('d')
     CALL i221_occ1003('d')
     CALL i221_occ1009('d')
     CALL i221_occ1010('d')
     CALL i221_occ1011('d')
     CALL i221_occ1016('d')
     CALL i221_occ1706()    #FUN-6A0007
     CALL i221_occ1705()    #FUN-6A0007
     CALL i221_occ41('d')   #No.TQC-5A0115
     CALL i221_occ43('d')   #No.TQC-5A0115
     CALL i221_occ44('d')   #No.TQC-5A0115
     CALL i221_occ45('d')   #No.TQC-5A0115
     CALL i221_occ47('d')                                                                                                           
     CALL i221_occ48('d')                                                                                                           
     CALL i221_occ49('d')                                                                                                           
     CALL i221_occ50('d')                                                                                                           
     CALL i221_occ68('d')   #No.FUN-840183
     CALL i221_occ69('d')   #No.FUN-840183
     CALL i221_occ67('d') RETURNING g_buf   #FUN-570065
     CALL i221_occ22('d')   #No.TQC-5A0115
     CALL i221_occ21('d')   #No.TQC-5A0115
     CALL i221_occ20('d')   #FUN-550091   #No.TQC-5A0115
     CALL i221_occ930('d')   #FUN-870100
     CALL i221_set_occud02() #darcy:2022/04/13 
     LET g_buf=NULL
     SELECT pmc03 INTO g_buf FROM pmc_file
      WHERE pmc01 = g_occ.occ51
     DISPLAY g_buf TO pmc03
     LET g_buf = ''
     SELECT pmc03 INTO g_buf FROM pmc_file
      WHERE pmc01 = g_occ.occ66 AND pmc14 = '6'   #FUN-640014 將pmc14='5'改成pmc14='6'
     DISPLAY g_buf TO pmc03_1
     LET g_buf = ''
     SELECT tqb02 INTO g_buf FROM tqb_file
      WHERE tqb01 = g_occ.occ1005
     DISPLAY g_buf TO tqb02
     CALL i221_show_pic()
     #圖形顯示
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i221_u()
DEFINE l_count    LIKE type_file.num5   #FUN-A80073 ---ADD---
DEFINE l_occpos   LIKE occ_file.occpos  #FUN-B70075 ADD
DEFINE l_action   STRING                #No.FUN-BB0049


    IF s_shut(0) THEN RETURN END IF
    IF g_occ.occ01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    ###FUN-A80073 START ###
    SELECT COUNT(*) INTO l_count FROM lne_file 
     WHERE lne01 = g_occ.occ01
    IF l_count > 0 THEN
       CALL cl_err('','alm-h04',0)
       RETURN
    END IF
    ###FUN-A80073 END ###
    IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
       CALL cl_err(g_occ.occ246,'aoo-045',1)
       RETURN
    END IF
    IF g_occ.occacti = 'N' THEN
        CALL cl_err('',9027,1)
        RETURN
    END IF
    IF g_occ.occacti = 'H' THEN
        #已留置或停止交易,則不能做任何修改!
        CALL cl_err('','axm-223',1)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_occ01_t = g_occ.occ01
 
    IF g_action_choice <> "reproduce" THEN    #FUN-680010
       LET g_success = 'Y'                    #FUN-9A0056 add
       #FUN-B70075 Add Begin---
       IF g_aza.aza88 = 'Y' THEN
          UPDATE occ_file SET occpos = '4' 
           WHERE occ01 = g_occ.occ01
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","occ_file",g_occ_t.occ01,"",SQLCA.sqlcode,"","",1)
             RETURN
          END IF
          LET l_occpos = g_occ.occpos
          LET g_occ.occpos = '4' 
          DISPLAY BY NAME g_occ.occpos
       END IF
       #FUN-B70075 Add End-----
       BEGIN WORK
    #No.FUN-BB0049  --Begin
       LET l_action = 'u'
    ELSE
       LET l_action = 'c'
    #No.FUN-BB0049  --End
    END IF
 
    OPEN i221_cl USING g_occ.occ01
    IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 1)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i221_cl INTO g_occ.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
       CLOSE i221_cl         #MOD-950005
       ROLLBACK WORK         #FUN-680010
       RETURN
    END IF
    IF NOT cl_null(g_occ.occ930) THEN
       CALL cl_set_comp_entry("occ37",FALSE)
    ELSE
       CALL cl_set_comp_entry("occ37",TRUE)
    END IF
    LET g_occ_t.*=g_occ.*
    LET g_occ.occmodu = g_user                #修改者
    LET g_occ.occdate = g_today               #修改日期
    LET g_occ02_t = g_occ.occ02               #No.FUN-A30110
   #FUN-B70075 Mark Begin---
   #IF g_aza.aza88='Y' THEN
   #  #FUN-B50023 --START--
   #   #LET g_occ.occpos = 'N'               #FUN-A30030 ADD
   #   IF g_occ.occpos <> '1' THEN   
   #      LET g_occ.occpos = '2'
   #   END IF
   #  #FUN-B50023 --END--
   #END IF
   ##FUN-A30030 END ----------------------------
   #FUN-B70075 Mark End-----
    CALL i221_show()                          # 顯示最新資料
    WHILE TRUE
          CALL i221_i("u")                      # 欄位更改
          IF INT_FLAG THEN
             LET INT_FLAG = 0
             LET g_occ.*=g_occ_t.*
             CALL i221_show()
             CALL cl_err('',9001,0)
             ROLLBACK WORK      #FUN-680010
             #FUN-B70075 Add Begin---
             IF g_aza.aza88 = 'Y' THEN
                LET g_occ.occpos = l_occpos
                UPDATE occ_file 
                   SET occpos = g_occ.occpos
                 WHERE occ01 = g_occ.occ01
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","occ_file",g_occ_t.occ01,"",SQLCA.sqlcode,"","",1)
                END IF
                DISPLAY BY NAME g_occ.occpos
             END IF
             #FUN-B70075 Add End-----
             EXIT WHILE
          END IF

          #FUN-B70075 Add Begin---
          IF g_aza.aza88='Y' THEN
             IF l_occpos <> '1' THEN
                LET g_occ.occpos = '2'
             ELSE
                LET g_occ.occpos = '1'
             END IF
          END IF
          #FUN-B70075 Add End-----
 
          UPDATE occ_file SET occ_file.* = g_occ.*  # 更新DB
              WHERE occ01 = g_occ.occ01             # COLAUTH?
          IF SQLCA.SQLERRD[3]=0 THEN     #FUN-680010
             CALL cl_err3("upd","occ_file",g_occ01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
             ROLLBACK WORK     #FUN-680010
             BEGIN WORK        #FUN-680010
             LET g_success = 'Y'         #No.FUN-A30110
             CONTINUE WHILE
          ELSE #FUN-590083
             #No.FUN-A30110  --Begin
             IF NOT (g_occ.occ01 MATCHES 'MISC*' OR g_occ.occ01 MATCHES 'EMPL*' ) THEN  #No.TQC-BB0002 
                IF g_occ.occ02 <> g_occ02_t OR l_action = "c" THEN  #No.FUN-BB0049
                   CALL s_showmsg_init()
                   #CALL s_upd_abbr(g_occ.occ01,g_occ.occ02,g_dbs,'2','N')
                   CALL s_upd_abbr(g_occ.occ01,g_occ.occ02,g_plant,'2','Y',l_action) #FUN-A50102  #No.FUN-BB0049
                   IF g_success = 'N' THEN
                      CALL s_showmsg()
                      ROLLBACK WORK
                      BEGIN WORK
                      LET g_success = 'Y'
                      CONTINUE WHILE
                   END IF   
                END IF 
             END IF     #No.TQC-BB0002  
             #No.FUN-A30110  --End 

            #LET g_u_flag=''   #FUN-870101 add   #FUN-9A0056 mark
             IF g_action_choice <> "reproduce" THEN
               
                CASE aws_mdmdata('occ_file','update',g_occ.occ01,base.TypeInfo.create(g_occ),'CreateCustomerData')#FUN-870166
                   WHEN 0  #無與 MDM 整合
                       #LET g_u_flag='0'         #FUN-870101 add   #FUN-9A0056 mark
                        LET g_success = 'Y'      #FUN-9A0056 add                
                        MESSAGE 'UPDATE O.K'
                   WHEN 1  #呼叫 MDM 成功
                       #LET g_u_flag='0'         #FUN-870101 add   #FUN-9A0056 mark
                        LET g_success = 'Y'      #FUN-9A0056 add                
                        MESSAGE 'UPDATE O.K, UPDATE MDM O.K'
                   WHEN 2  #呼叫 MDM 失敗
                        LET g_success ='N'       #FUN-9A0056 add
                       #LET g_u_flag='1'         #FUN-870101 add   #FUN-9A0056 mark               
                       #CONTINUE WHILE           #FUN-9A0056 mark
                END CASE
 
                # CALL aws_spccli_base()
                # 傳入參數: (1)TABLE名稱, (2)修改資料,
                #           (3)功能選項：insert(新增),update(修改),delete(刪除)
                CASE aws_spccli_base('occ_file',base.TypeInfo.create(g_occ),'update')
                   WHEN 0  #無與 SPC 整合
                       #LET g_u_flag='0'         #FUN-870101 add  #FUN-9A0056 mark
                        LET g_success ='Y'       #FUN-9A0056 add              
                        MESSAGE 'UPDATE O.K'
                   WHEN 1  #呼叫 SPC 成功
                       #LET g_u_flag='0'         #FUN-870101 add  #FUN-9A0056 mark
                        LET g_success ='Y'       #FUN-9A0056 add            
                        MESSAGE 'UPDATE O.K. UPDATE SPC O.K'
                   WHEN 2  #呼叫 SPC 失敗
                        LET g_success ='N'       #FUN-9A0056 add
                       #LET g_u_flag='1'         #FUN-870101 add  #FUN-9A0056 mark            
                       #CONTINUE WHILE           #FUN-9A0056 mark
                END CASE
 
 
               IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD  #FUN-9A0056 mod
                  IF g_occ.occ1004='1' AND g_occ.occacti='Y' THEN  #FUN-9A0056 add
                     # CALL aws_mescli()
                     # 傳入參數: (1)程式代號
                     #           (2)功能選項：insert(新增),update(修改),delete(刪除)
                     #           (3)Key
                     CASE aws_mescli('axmi221','update',g_occ.occ01)
                        WHEN 0  #無與 MES 整合
                             LET g_u_flag='0'                   
                             MESSAGE 'UPDATE O.K'
                        WHEN 1  #呼叫 MES 成功
                             LET g_u_flag='0'                   
                             MESSAGE 'UPDATE O.K, UPDATE MES O.K'
                        WHEN 2  #呼叫 MES 失敗
                             LET g_u_flag='1'   
                     END CASE
                     IF g_u_flag='1' THEN ROLLBACK WORK ELSE COMMIT WORK END IF  
                  END IF         #FUN-9A0056 add
               END IF #TQC-8B0011  ADD

               #FUN-9A0056 add str ---------
                IF g_success = 'Y' THEN
                   COMMIT WORK
                   DISPLAY BY NAME g_occ.occpos    #FUN-B70075 ADD
                ELSE
                   ROLLBACK WORK
                   BEGIN WORK
                   LET g_success = 'Y'  #No.FUN-A30110
                   CONTINUE WHILE
                END IF
               #FUN-9A0056 add end----------

                CALL i221_list_fill()
             END IF
 
          END IF
          CALL i221_show_pic()
       EXIT WHILE
    END WHILE
    CLOSE i221_cl
   #FUN-9A0056 mark str ----
   #IF g_action_choice <> "reproduce" THEN    #MOD-8B0218
   #   COMMIT WORK                            #FUN-680010   #MOD-8B0218 取消mark
   #END IF                                    #MOD-8B0218
   #FUN-9A0056 mark end ----
END FUNCTION
 
FUNCTION i221_1_set_ocd(l_ocd01,l_ocd)
   DEFINE l_ocd01    LIKE ocd_file.ocd01
   DEFINE l_ocd      RECORD
                        ocd02    LIKE ocd_file.ocd02,
                        ocd03    LIKE ocd_file.ocd03,
                        ocd04    LIKE ocd_file.ocd04,
                        ocd221   LIKE ocd_file.ocd221,
                        ocd222   LIKE ocd_file.ocd222,
                        ocd223   LIKE ocd_file.ocd223,
                        ocd230   LIKE ocd_file.ocd230,   #FUN-720014
                        ocd231   LIKE ocd_file.ocd231    #FUN-720014
                     END RECORD
   DEFINE l_ocd2     RECORD LIKE ocd_file.*
   
   INITIALIZE l_ocd2.* TO NULL
   LET l_ocd2.ocd01  = l_ocd01
   LET l_ocd2.ocd02  = l_ocd.ocd02 
   LET l_ocd2.ocd03  = l_ocd.ocd03 
   LET l_ocd2.ocd04  = l_ocd.ocd04 
   LET l_ocd2.ocd221 = l_ocd.ocd221
   LET l_ocd2.ocd222 = l_ocd.ocd222
   LET l_ocd2.ocd223 = l_ocd.ocd223
   LET l_ocd2.ocd230 = l_ocd.ocd230
   LET l_ocd2.ocd231 = l_ocd.ocd231
   RETURN l_ocd2.*
END FUNCTION
 
#FUN-C50070 mark -begin--------------------------
#FUNCTION i221_1()
#  DEFINE l_rec_b    LIKE type_file.num5    #No.FUN-680137 SMALLINT
#  DEFINE l_ocd      DYNAMIC ARRAY OF RECORD
#                       ocd02    LIKE ocd_file.ocd02,
#                       ocd03    LIKE ocd_file.ocd03,
#                       ocd04    LIKE ocd_file.ocd04,
#                       ocd221   LIKE ocd_file.ocd221,
#                       ocd222   LIKE ocd_file.ocd222,
#                       ocd223   LIKE ocd_file.ocd223,
#                       ocd230   LIKE ocd_file.ocd230,   #FUN-720014
#                       ocd231   LIKE ocd_file.ocd231    #FUN-720014
#                    END RECORD
#  DEFINE l_ocd2     RECORD LIKE ocd_file.*  #FUN-860036
#  DEFINE l_key      LIKE wsw_file.wsw03 #FUN-870166
#
#  IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
#     CALL cl_err(g_occ.occ246,'aoo-045',1)
#     RETURN
#  END IF
#  LET p_row = 11 LET p_col = 3
#
#  OPEN WINDOW i221_1_w AT p_row,p_col WITH FORM "axm/42f/axmi221_1"
#        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#
#  CALL cl_ui_locale("axmi221_1")
#
#  CALL l_ocd.clear()
#  DECLARE i221_1_c CURSOR FOR
#    SELECT ocd02,ocd03,ocd04,ocd221,ocd222,ocd223,ocd230,ocd231 FROM ocd_file   #FUN-720014 add ocd230/231
#     WHERE ocd01 = g_occ.occ01
#
#  LET i = 1
#  FOREACH i221_1_c INTO l_ocd[i].*
#     IF STATUS THEN
#        CALL cl_err('foreach ocd',STATUS,0)
#        EXIT FOREACH
#     END IF
#     LET i = i + 1
#     IF i > g_max_rec THEN
#        CALL cl_err( '', 9035, 0 )
#        EXIT FOREACH
#     END IF
#
#  END FOREACH
#  CALL l_ocd.deleteElement(i)
#
#  LET l_rec_b =i-1
#  DISPLAY l_rec_b TO cn2
#
#  WHILE TRUE
#   LET i = 1
#   INPUT ARRAY l_ocd WITHOUT DEFAULTS FROM s_ocd.*
#         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#                   INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
#
#      BEFORE INPUT
#         IF l_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(j)
#         END IF
#
#      BEFORE ROW
#         LET j=ARR_CURR()
#
#      AFTER FIELD ocd02
#         FOR i = 1 TO l_ocd.getLength()
#             IF cl_null(l_ocd[i].ocd02) OR i = j THEN
#                CONTINUE FOR
#             END IF
#             IF l_ocd[j].ocd02 = l_ocd[i].ocd02 THEN
#             	CALL cl_err('ocd02','axm-220',1)
#             	NEXT FIELD ocd02
#             END IF
#         END FOR
#
#      AFTER INSERT
#          CALL i221_1_set_ocd(g_occ.occ01,l_ocd[j].*) RETURNING l_ocd2.*           
#          LET l_key = g_occ.occ01 , "|" , l_ocd2.ocd02 #FUN-870166
#          CASE aws_mdmdata('ocd_file','insert',l_key,base.TypeInfo.create(l_ocd2),'CreateAddressData')#FUN-870166
#             WHEN 0  #無與 MDM 整合
#                  CALL cl_msg('INSERT O.K')
#             WHEN 1  #呼叫 MDM 成功
#                  CALL cl_msg('INSERT O.K, INSERT MDM O.K')
#             WHEN 2  #呼叫 MDM 失敗
#                  CANCEL INSERT
#          END CASE       
#          
#      ON ROW CHANGE
#          CALL i221_1_set_ocd(g_occ.occ01,l_ocd[ARR_CURR()].*) RETURNING l_ocd2.*           
#          LET l_key = g_occ.occ01 , "|" , l_ocd2.ocd02 #FUN-870166
#          CASE aws_mdmdata('ocd_file','update',l_key,base.TypeInfo.create(l_ocd2),'CreateAddressData')#FUN-870166
#             WHEN 0  #無與 MDM 整合
#                  CALL cl_msg('Update O.K')
#             WHEN 1  #呼叫 MDM 成功
#                  CALL cl_msg('Update O.K, Update MDM O.K')
#             WHEN 2  #呼叫 MDM 失敗
#                  CONTINUE INPUT
#          END CASE
#
#      BEFORE DELETE
#         IF g_occ.occ01 IS NOT NULL THEN
#            CALL i221_1_set_ocd(g_occ.occ01,l_ocd[ARR_CURR()].*) RETURNING l_ocd2.*            
#         END IF
#
#      AFTER INPUT
#         LET j = ARR_COUNT()
#
#      ON ACTION CONTROLP    #FUN-4B0043
#         IF INFIELD(ocd02) THEN
#            CALL cl_init_qry_var()
#            LET g_qryparam.form ="q_ocd"
#            LET g_qryparam.default1 = l_ocd[j].ocd02
#            LET g_qryparam.arg1 = g_occ.occ01
#            CALL cl_create_qry() RETURNING l_ocd[j].ocd02
#            DISPLAY BY NAME l_ocd[j].ocd02
#            NEXT FIELD ocd02
#         END IF
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
#
#   END INPUT
#
#   IF INT_FLAG THEN
#      CALL cl_err('',9001,0)
#      CLOSE WINDOW i221_1_w
#      LET INT_FLAG = 0
#      RETURN
#   END IF
#
#   EXIT WHILE
#  END WHILE
#
#  LET g_success ='Y'
#
#  BEGIN WORK
#
#  DELETE FROM ocd_file WHERE ocd01 = g_occ.occ01
#  FOR i = 1 TO l_ocd.getLength()
#     IF cl_null(l_ocd[i].ocd02) THEN
#        CONTINUE FOR
#     END IF
#     MESSAGE g_occ.occ01,' ',l_ocd[i].ocd02
#
#     INSERT INTO ocd_file(ocd01,ocd02,ocd03,ocd04,ocd221,ocd222,ocd223,ocd230,ocd231)   #FUN-720014 add ocd230/231
#                 VALUES(g_occ.occ01,l_ocd[i].*)
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","ocd_file",g_occ.occ01,l_ocd[i].ocd02,SQLCA.sqlcode,"","INS-ocd",1)  #No.FUN-660167
#        LET g_success = 'N' EXIT FOR
#     END IF
#  END FOR
#
#  IF g_success='Y' THEN
#     COMMIT WORK
#  ELSE
#     ROLLBACK WORK
#  END IF
#
#  CLOSE WINDOW i221_1_w                #結束畫面
#
#END FUNCTION
#FUN-C50070 mark --end--------------------------- 
 
FUNCTION i221_2()
   DEFINE  l_rec_b      LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE  l_oce        DYNAMIC ARRAY OF RECORD
                           oce02   LIKE oce_file.oce02,
                           oce03   LIKE oce_file.oce03,
                           oce04   LIKE oce_file.oce04,
                           oce05   LIKE oce_file.oce05
                        END RECORD
 
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
   LET p_row = 5 LET p_col = 2
 
   OPEN WINDOW i221_2_w AT p_row,p_col WITH FORM "axm/42f/axmi221_2"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmi221_2")
 
   DECLARE i221_2_c CURSOR FOR
    SELECT oce02,oce03,oce04,oce05 FROM oce_file
     WHERE oce01 = g_occ.occ01
 
   CALL l_oce.clear()
   LET i = 1
 
   FOREACH i221_2_c INTO l_oce[i].*
      IF STATUS THEN
         CALL cl_err('foreach oce',STATUS,0)
         EXIT FOREACH
      END IF
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
   END FOREACH
 
   LET l_rec_b=i-1
   DISPLAY l_rec_b TO cn2
 
   WHILE TRUE
 
      INPUT ARRAY l_oce WITHOUT DEFAULTS FROM s_oce.*
 
         BEFORE ROW
            LET j=ARR_CURR()
 
         AFTER FIELD oce03
            FOR i = 1 TO l_oce.getLength()
                IF cl_null(l_oce[j].oce03) THEN
                   EXIT FOR
                END IF
                IF cl_null(l_oce[i].oce03)  THEN
                   EXIT FOR
                END IF
                IF cl_null(l_oce[i].oce03) OR i = j THEN
                   CONTINUE FOR
                END IF
                IF l_oce[j].oce03 = l_oce[i].oce03 THEN
                   CALL cl_err('oce03','axm-298',1)
                   NEXT FIELD oce03
                END IF
            END FOR
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
      END INPUT
 
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         CLOSE WINDOW i221_2_w
         LET INT_FLAG = 0
         RETURN
      END IF
 
      EXIT WHILE
   END WHILE
 
   LET g_success ='Y'
   BEGIN WORK
 
   DELETE FROM oce_file WHERE oce01 = g_occ.occ01
   FOR i = 1 TO l_oce.getLength()
      IF cl_null(l_oce[i].oce03) THEN CONTINUE FOR END IF
      INSERT INTO oce_file(oce01,oce02,oce03,oce04,oce05)
                  VALUES(g_occ.occ01,l_oce[i].*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","oce_file",g_occ.occ01,l_oce[i].oce03,SQLCA.sqlcode,"","INS-oce",1)  #No.FUN-660167
         LET g_success = 'N' EXIT FOR
      END IF
   END FOR
 
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CLOSE WINDOW i221_2_w                #結束畫面
 
END FUNCTION
 
FUNCTION i221_22(p_oce01)
   DEFINE  l_rec_b      LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE  l_oce        DYNAMIC ARRAY OF RECORD
		oce02	LIKE oce_file.oce02,
                oce03	LIKE oce_file.oce03,
	        oce04	LIKE oce_file.oce04,
		oce07	LIKE oce_file.oce07,
		oce08	LIKE oce_file.oce08,
		oce05	LIKE oce_file.oce05,
		oce09	LIKE oce_file.oce09,
		oce10	LIKE oce_file.oce10
                END RECORD
   DEFINE  l_oce_t      RECORD
		oce02	LIKE oce_file.oce02,
                oce03	LIKE oce_file.oce03,
	        oce04	LIKE oce_file.oce04,
		oce07	LIKE oce_file.oce07,
		oce08	LIKE oce_file.oce08,
		oce05	LIKE oce_file.oce05,
		oce09	LIKE oce_file.oce09,
		oce10	LIKE oce_file.oce10
                END RECORD
   DEFINE   l_occ1004    LIKE occ_file.occ1004
   DEFINE   l_occacti    LIKE occ_file.occacti
   DEFINE   l_allow_insert    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
            l_allow_delete    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
            p_cmd             LIKE type_file.chr1,                                              #No.FUN-680137 VARCHAR(1)
            p_oce01      LIKE oce_file.oce01,
            i,l_ac,l_ac_t,l_n LIKE type_file.num5            #No.FUN-680137 SMALLINT
 
   IF cl_null(p_oce01) THEN
      CALL cl_err('','atm-047',1)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
 
   LET p_row = 5 LET p_col = 2
 
 
   OPEN WINDOW i221_22_w AT p_row,p_col WITH FORM "axm/42f/axmi221_22"
        ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_locale("axmi221_22")
 
 
   DECLARE i221_22_c CURSOR FOR
    SELECT oce02,oce03,oce04,oce07,
           oce08,oce05,oce09,oce10
      FROM oce_file
     WHERE oce01 = p_oce01
 
   CALL l_oce.clear()
   LET i = 1
 
   FOREACH i221_22_c INTO l_oce[i].*
      IF STATUS THEN CALL cl_err('foreach oce',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
   END FOREACH
   CALL l_oce.deleteElement(i)
 
   LET l_rec_b=i-1
   DISPLAY l_rec_b TO cn2
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY l_oce TO s_oce.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         LET l_ac = ARR_CURR()
      ON ACTION exit
         EXIT DISPLAY
      ON ACTION accept
#TQC-D10038 mark begin
#         SELECT occ1004 INTO l_occ1004
#           FROM occ_file
#          WHERE occ01=p_oce01
#         IF l_occ1004 !='0' THEN #FUN-690021 mod
#            #非開立狀態，不可異動！
#            CALL cl_err('','atm-046',1)
#            RETURN
#         END IF
#TQC-D10038 mark end
         SELECT occacti INTO l_occacti
           FROM occ_file
          WHERE occ01=p_oce01
         IF l_occacti ='N' THEN
            CALL cl_err('','mfg0301',1)
            RETURN
         END IF
         CALL cl_set_act_visible("accept,cancel", TRUE)
         LET g_forupd_sql=" SELECT oce02,oce03,oce04,oce07,oce08,oce05,oce09,oce10",
                          "   FROM oce_file ",
                          "  WHERE oce01= ? ",
                          "    AND oce03= ? ",
                          " FOR UPDATE "
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

         DECLARE i221_22_bc1 CURSOR FROM g_forupd_sql
         LET l_allow_insert = cl_detail_input_auth("insert")
         LET l_allow_delete = cl_detail_input_auth("delete")
 
         INPUT ARRAY l_oce WITHOUT DEFAULTS FROM s_oce.*
               ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                         APPEND ROW=l_allow_insert)
         BEFORE INPUT
 
            IF l_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
 
         BEFORE ROW
            LET l_ac=ARR_CURR()
            LET j=ARR_CURR()
            LET p_cmd = ''
            BEGIN WORK
            IF l_rec_b >= l_ac THEN
               LET p_cmd = 'u'
               LET l_oce_t.* = l_oce[l_ac].*
               OPEN i221_22_bc1 USING p_oce01,l_oce_t.oce03
               IF STATUS THEN
                  CALL cl_err("OPEN i221_22_bc1:", STATUS, 1)
               ELSE
                  FETCH i221_22_bc1 INTO l_oce[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,1)
                  END IF
               END IF
            END IF
 
         BEFORE INSERT
            LET p_cmd = 'a'
            INITIALIZE l_oce[l_ac].* TO NULL
            LET l_oce_t.* = l_oce[l_ac].*
            NEXT FIELD oce02
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO oce_file(oce01,oce02,oce03,oce04,oce05,oce07,oce08,oce09,oce10)
               VALUES(p_oce01,l_oce[l_ac].oce02,l_oce[l_ac].oce03,l_oce[l_ac].oce04,
                      l_oce[l_ac].oce05,l_oce[l_ac].oce07,l_oce[l_ac].oce08,l_oce[l_ac].oce09,l_oce[l_ac].oce10)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","oce_file",p_oce01,l_oce[l_ac].oce03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  DISPLAY l_rec_b TO FORMONLY.cn2
                  COMMIT WORK
               END IF
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_oce[l_ac].* = l_oce_t.*
               CLOSE i221_22_bc1
               ROLLBACK WORK
               EXIT INPUT
            END IF
            UPDATE oce_file SET oce02 = l_oce[l_ac].oce02,
                                oce03 = l_oce[l_ac].oce03,
                                oce04 = l_oce[l_ac].oce04,
                                oce05 = l_oce[l_ac].oce05,
                                oce07 = l_oce[l_ac].oce07,
                                oce08 = l_oce[l_ac].oce08,
                                oce09 = l_oce[l_ac].oce09,
                                oce10 = l_oce[l_ac].oce10
                             WHERE oce01 = p_oce01
                               AND oce03 = l_oce_t.oce03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","oce_file",p_oce01,l_oce_t.oce03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET l_oce[l_ac].* = l_oce_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET l_oce[l_ac].* = l_oce_t.*
               END IF
               CLOSE i221_22_bc1
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i221_22_bc1
            COMMIT WORK
 
         BEFORE DELETE
            IF l_oce_t.oce03 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               DELETE FROM oce_file
                WHERE oce01 = p_oce01
                  AND oce03 = l_oce_t.oce03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","oce_file",p_oce01,l_oce_t.oce03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  EXIT INPUT
               END IF
               LET l_rec_b=l_rec_b-1
               DISPLAY l_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
         AFTER FIELD oce03
            FOR i = 1 TO l_oce.getLength()
                IF cl_null(l_oce[j].oce03) THEN
                   EXIT FOR
                END IF
                IF cl_null(l_oce[i].oce03)  THEN
                   EXIT FOR
                END IF
                IF cl_null(l_oce[i].oce03) OR i = j THEN
	        	CONTINUE FOR
                END IF
                IF l_oce[j].oce03 = l_oce[i].oce03 THEN
                   CALL cl_err('oce03','atm-310',1)
                   NEXT FIELD oce03
                END IF
            END FOR
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
 
      ON ACTION detail
#TQC-D10038 mark begin
#         SELECT occ1004 INTO l_occ1004
#           FROM occ_file
#          WHERE occ01=p_oce01
#         IF l_occ1004 !='0' THEN #FUN-690021-mod
#            #非開立狀態，不可異動！
#            CALL cl_err('','atm-046',1)
#            RETURN
#         END IF
#TQC-D10038 mark end
         SELECT occacti INTO l_occacti
           FROM occ_file
          WHERE occ01=p_oce01
         IF l_occacti ='N' THEN
            CALL cl_err('','mfg0301',1)
            RETURN
         END IF
         CALL cl_set_act_visible("accept,cancel", TRUE)
         LET g_forupd_sql=" SELECT oce02,oce03,oce04,oce07,oce08,oce05,oce09,oce10",
                          "   FROM oce_file ",
                          "  WHERE oce01= ? ",
                          "    AND oce03= ? ",
                          " FOR UPDATE "
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

         DECLARE i221_22_bc2 CURSOR FROM g_forupd_sql
         LET l_allow_insert = cl_detail_input_auth("insert")
         LET l_allow_delete = cl_detail_input_auth("delete")
 
         INPUT ARRAY l_oce WITHOUT DEFAULTS FROM s_oce.*
               ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                         APPEND ROW=l_allow_insert)
         BEFORE INPUT
 
            IF l_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
 
         BEFORE ROW
            LET l_ac=ARR_CURR()
            LET j=ARR_CURR()
            LET p_cmd = ''
            BEGIN WORK
            IF l_rec_b >= l_ac THEN
               LET p_cmd = 'u'
               LET l_oce_t.* = l_oce[l_ac].*
               OPEN i221_22_bc2 USING p_oce01,l_oce_t.oce03
               IF STATUS THEN
                  CALL cl_err("OPEN i221_22_bc2:", STATUS, 1)
               ELSE
                  FETCH i221_22_bc2 INTO l_oce[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,1)
                  END IF
               END IF
            END IF
 
         BEFORE INSERT
            LET p_cmd = 'a'
            INITIALIZE l_oce[l_ac].* TO NULL
            LET l_oce_t.* = l_oce[l_ac].*
            NEXT FIELD oce02
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO oce_file(oce01,oce02,oce03,oce04,oce05,oce07,oce08,oce09,oce10)
               VALUES(p_oce01,l_oce[l_ac].oce02,l_oce[l_ac].oce03,l_oce[l_ac].oce04,
                      l_oce[l_ac].oce05,l_oce[l_ac].oce07,l_oce[l_ac].oce08,l_oce[l_ac].oce09,l_oce[l_ac].oce10)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","oce_file",p_oce01,l_oce[l_ac].oce03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  DISPLAY l_rec_b TO FORMONLY.cn2
                  COMMIT WORK
               END IF
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_oce[l_ac].* = l_oce_t.*
               CLOSE i221_22_bc2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            UPDATE oce_file SET oce02 = l_oce[l_ac].oce02,
                                oce03 = l_oce[l_ac].oce03,
                                oce04 = l_oce[l_ac].oce04,
                                oce05 = l_oce[l_ac].oce05,
                                oce07 = l_oce[l_ac].oce07,
                                oce08 = l_oce[l_ac].oce08,
                                oce09 = l_oce[l_ac].oce09,
                                oce10 = l_oce[l_ac].oce10
                             WHERE oce01 = p_oce01
                               AND oce03 = l_oce_t.oce03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","oce_file",p_oce01,l_oce_t.oce03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET l_oce[l_ac].* = l_oce_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET l_oce[l_ac].* = l_oce_t.*
               END IF
               CLOSE i221_22_bc2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i221_22_bc2
            COMMIT WORK
 
         BEFORE DELETE
            IF l_oce_t.oce03 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               DELETE FROM oce_file
                WHERE oce01 = p_oce01
                  AND oce03 = l_oce_t.oce03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","oce_file",p_oce01,l_oce_t.oce03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  EXIT INPUT
               END IF
               LET l_rec_b=l_rec_b-1
               DISPLAY l_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
         AFTER FIELD oce03
            FOR i = 1 TO l_oce.getLength()
                IF cl_null(l_oce[j].oce03) THEN
                   EXIT FOR
                END IF
                IF cl_null(l_oce[i].oce03)  THEN
                   EXIT FOR
                END IF
                IF cl_null(l_oce[i].oce03) OR i = j THEN
	        	CONTINUE FOR
                END IF
                IF l_oce[j].oce03 = l_oce[i].oce03 THEN
                   CALL cl_err('oce03','atm-310',1)
                   NEXT FIELD oce03
                END IF
            END FOR
 
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
 
      CALL cl_set_act_visible("accept,cancel", FALSE)
      CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
  LET INT_FLAG=0
  CLOSE WINDOW i221_22_w
 
END FUNCTION

#FUN-AA0078 mark -----begin-------
#FUN-A50012 ----add begin
#FUNCTION i221_3()
#   DEFINE l_cmd     LIKE type_file.chr1
#   DEFINE l_odw     RECORD LIKE odw_file.*
#   DEFINE l_odw_t   RECORD LIKE odw_file.*
#   DEFINE l_success LIKE type_file.chr1
#   DEFINE l_msg     LIKE ze_file.ze03
#
#   IF cl_null(g_occ.occ01) THEN
#      RETURN
#   END IF
#   
#   LET p_row = 11 LET p_col = 3
#
#   OPEN WINDOW i221_3_w AT p_row,p_col WITH FORM "axm/42f/axmi221_9"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#   CALL cl_ui_locale("axmi221_9")
#   CALL cl_getmsg('axm_607',g_lang) RETURNING l_msg
#   CALL cl_set_comp_lab_text("lb1",l_msg CLIPPED)
#
#   SELECT * INTO l_odw.* FROM odw_file WHERE odw01 = g_occ.occ01
#   IF SQLCA.SQLCODE = 100 THEN
#      LET l_cmd = 'a'
#      LET l_odw.odw02 = 'N'
#      CALL cl_set_comp_entry("odw03,odw04,odw05,odw06,odw07,odw08,odw09",FALSE)
#   ELSE
#      LET l_cmd = 'u'
#      IF l_odw.odw02 = 'Y' THEN
#         CALL cl_set_comp_entry("odw03,odw07,odw08,odw09",TRUE)
#         IF l_odw.odw03 = '1' THEN
#             CALL cl_set_comp_entry("odw04,odw05,odw06",FALSE)
#          ELSE
#             CALL cl_set_comp_entry("odw04,odw05,odw06",TRUE)
#          END IF
#      ELSE
#         CALL cl_set_comp_entry("odw03,odw04,odw05,odw06,odw07,odw08,odw09",FALSE)
#      END IF
#   END IF
#   LET l_odw_t.* = l_odw.*
#
#   WHILE TRUE
#    LET i = 1
#    INPUT BY NAME l_odw.odw02,l_odw.odw03,l_odw.odw04,
#                  l_odw.odw05,l_odw.odw06,l_odw.odw07,
#                  l_odw.odw08,l_odw.odw09
#       WITHOUT DEFAULTS
#       
#       BEFORE INPUT
##          CALL i221_3_set_entry(p_cmd)
##          CALL i221_3_set_no_entry(p_cmd)
#       
#       ON CHANGE odw02
#          IF l_odw.odw02 = 'Y' THEN
#             CALL cl_set_comp_entry("odw03,odw04,odw05,odw06,odw07,odw08,odw09",TRUE)
#             IF l_odw.odw03 = '1' THEN
#                CALL cl_set_comp_entry("odw04,odw05,odw06",FALSE)
#             ELSE
#                CALL cl_set_comp_entry("odw04,odw05,odw06",TRUE)
#             END IF
#          ELSE
#             CALL cl_set_comp_entry("odw03,odw04,odw05,odw06,odw07,odw08,odw09",FALSE)
#          END IF
#          IF l_odw.odw02 = 'Y' AND l_cmd = 'a' THEN
#             LET l_odw.odw03 = '1'
#             LET l_odw.odw07 = '1'
#             LET l_odw.odw08 = 'N'
#             DISPLAY BY NAME l_odw.odw03,l_odw.odw07,l_odw.odw08
#             CALL cl_set_comp_entry("odw04,odw05,odw06",FALSE)
#          END IF
# 
#       ON CHANGE odw03
#          IF l_odw.odw03 = '1' THEN
#             LET l_odw.odw04 = 0
#             LET l_odw.odw05 = 0
#             LET l_odw.odw06 = 0
#             DISPLAY BY NAME l_odw.odw04,l_odw.odw05,l_odw.odw06
#             CALL cl_set_comp_entry("odw04,odw05,odw06",FALSE)
#          ELSE
#             LET l_odw.odw04 = 0
#             LET l_odw.odw05 = 0
#             LET l_odw.odw06 = 0
#             DISPLAY BY NAME l_odw.odw04,l_odw.odw05,l_odw.odw06
#             CALL cl_set_comp_entry("odw04,odw05,odw06",TRUE)
#          END IF
#          
#       AFTER FIELD odw04
#          IF NOT cl_null(l_odw.odw04) THEN
#             IF l_odw.odw04 <=0 THEN
#                CALL cl_err('','aec-020',0)
#                LET l_odw.odw04 = l_odw_t.odw04
#                DISPLAY BY NAME l_odw.odw04
#                NEXT FIELD odw04
#             END IF
#          END IF
#       
#       AFTER FIELD odw05
#          IF NOT cl_null(l_odw.odw05) THEN
#             IF l_odw.odw05 <=0 THEN
#                CALL cl_err('','aec-020',0)
#                LET l_odw.odw05 = l_odw_t.odw05
#                DISPLAY BY NAME l_odw.odw05
#                NEXT FIELD odw05
#             END IF
#          END IF
#          
#       AFTER FIELD odw06
#          IF NOT cl_null(l_odw.odw06) THEN
#             IF l_odw.odw06 <=0 THEN
#                CALL cl_err('','aec-020',0)
#                LET l_odw.odw06 = l_odw_t.odw06
#                DISPLAY BY NAME l_odw.odw06
#                NEXT FIELD odw06
#             END IF
#          END IF
#       
#       AFTER FIELD odw09
#          IF NOT cl_null(l_odw.odw09) THEN
#             IF l_odw.odw09 <=0 THEN
#                CALL cl_err('','aec-020',0)
#                LET l_odw.odw09 = l_odw_t.odw09
#                DISPLAY BY NAME l_odw.odw09
#                NEXT FIELD odw09
#             END IF
#          END IF
#       AFTER INPUT
#          IF INT_FLAG THEN
#             LET INT_FLAG = 1 
#             EXIT INPUT  
#          END IF
#          IF l_odw.odw02 = 'Y' THEN
#             IF l_odw.odw03 = '2' THEN
#                IF cl_null(l_odw.odw04) OR l_odw.odw04 <= 0 THEN
#                   CALL cl_err('','aec-020',0)
#                   NEXT FIELD odw04
#                END IF
#                IF cl_null(l_odw.odw05) OR l_odw.odw05 <= 0 THEN
#                   CALL cl_err('','aec-020',0)
#                   NEXT FIELD odw05
#                END IF
#                IF cl_null(l_odw.odw06) OR l_odw.odw06 <= 0 THEN
#                   CALL cl_err('','aec-020',0)
#                   NEXT FIELD odw06
#                END IF
#             END IF
#             IF cl_null(l_odw.odw09) OR l_odw.odw09 <= 0 THEN
#                CALL cl_err('','aec-020',0)
#                NEXT FIELD odw09
#             END IF
#          END IF 
#       
#       ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about
#           CALL cl_about()
#    END INPUT
#
#    IF INT_FLAG THEN
#       CALL cl_err('',9001,0)
#       CLOSE WINDOW i221_3_w
#       LET INT_FLAG = 0
#       RETURN
#    END IF
#
#    EXIT WHILE
#   END WHILE
#
#   BEGIN WORK
#   LET l_success = 'Y'
#   IF l_cmd = 'a' THEN
#      LET l_odw.odw01 = g_occ.occ01
#      INSERT INTO odw_file VALUES(l_odw.*)
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("ins","odw_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)
#         LET l_success = 'N'
#      END IF
#   ELSE
#      UPDATE odw_file SET odw_file.* = l_odw.* WHERE odw01 = g_occ.occ01
#      IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err3("upd","odw_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)
#         LET l_success = 'N'
#      END IF
#   END IF
#   IF l_success = 'Y' THEN
#      COMMIT WORK
#   ELSE
#      ROLLBACK WORK
#   END IF
#   CLOSE WINDOW i221_3_w                #結束畫面
#END FUNCTION
#FUN-A50012 ---add end
#FUN-AA0078 mark -----end-------
 
FUNCTION i221_4()
 
   IF g_occ.occ01 IS NULL THEN
      RETURN
   END IF
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
 
   CALL axmi222(g_occ.occ01,'a')
 
END FUNCTION
 
FUNCTION i221_6()
 
   IF g_occ.occ01 IS NULL THEN
      RETURN
   END IF
 
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
   CALL axmi224(g_occ.occ01,'a')
 
END FUNCTION
 
FUNCTION i221_d()
   DEFINE l_n     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_occ62 LIKE occ_file.occ62
   DEFINE l_occpos LIKE occ_file.occpos   #FUN-B70075 ADD
#  DEFINE l_occ33 LIKE occ_file.occ33     #FUN-C50136 add
 
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
   #FUN-B70075 Add Begin---
   IF g_aza.aza88 = 'Y' THEN
      UPDATE occ_file SET occpos = '4'
       WHERE occ01 = g_occ.occ01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","occ_file",g_occ_t.occ01,"",SQLCA.sqlcode,"","",1)
         RETURN
      END IF
      LET l_occpos = g_occ.occpos
      LET g_occ.occpos = '4'
      DISPLAY BY NAME g_occ.occpos
   END IF 
   #FUN-B70075 Add End-----
   BEGIN WORK
 
   OPEN i221_cl USING g_occ.occ01
   IF STATUS THEN
      CALL cl_err("OPEN i221_cl:", STATUS, 1)
      CLOSE i221_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i221_cl INTO g_occ.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_occ.occ01,SQLCA.sqlcode,1)
      CLOSE i221_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
 
   IF g_occ.occ01 IS NULL THEN
      CLOSE i221_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
 
   CALL i221_show()   #MOD-A70076

   INPUT BY NAME g_occ.occ62,g_occ.occ33,g_occ.occ61,g_occ.occ36,
                 g_occ.occ175,g_occ.occ631,g_occ.occ63,g_occ.occ64
         WITHOUT DEFAULTS
     
#     #FUN-C50136---add---str---
#     BEFORE INPUT
#        IF g_oaz.oaz96 = 'Y' THEN 
#           IF cl_null(g_occ.occ33) THEN
#              LET l_occ33 = g_occ.occ01
#           ELSE
#              LET l_occ33 = g_occ.occ33
#           END IF 
#           LET l_n = 0
#           SELECT COUNT(*) INTO l_n FROM oib_file,occ_file
#               WHERE oib01 = occ01 
#                 AND (occ01 = l_occ33 OR (occ33 = l_occ33 AND occ33 IS NOT NULL))
#                 AND oib03 <> 'axmi221'
#           IF l_n > 0 THEN
#              CALL cl_set_comp_entry('occ631,occ33',FALSE)
#           ELSE
#              CALL cl_set_comp_entry('occ631,occ33',TRUE) 
#           END IF
#        END IF
#     #FUN-C50136---add---end---
 
      AFTER FIELD occ61
         IF NOT cl_null(g_occ.occ61) THEN
             SELECT * FROM ocg_file WHERE ocg01 = g_occ.occ61
             IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","ocg_file",g_occ.occ61,"",SQLCA.sqlcode,"","sel ocg",1)  #No.FUN-660167
                  NEXT FIELD occ61
             END IF
          END IF
 
       AFTER FIELD occ62
          IF cl_null(g_occ.occ62) THEN NEXT FIELd occ62 END IF
          IF g_occ.occ62 NOT MATCHES "[YN]" THEN NEXT FIELd occ62 END IF
          IF g_occ.occ62='N' THEN
             LET g_occ.occ63=0
             CALL cl_set_comp_required("occ61,occ631",FALSE)
          ELSE
             CALL cl_set_comp_required("occ61,occ631",TRUE)
          END IF
          DISPLAY BY NAME g_occ.occ63
 
       AFTER FIELD occ631
          IF NOT cl_null(g_occ.occ631) THEN
             SELECT COUNT(*) INTO l_n FROM azi_file WHERE azi01=g_occ.occ631
             IF l_n = 0  THEN
                CALL cl_err('','mfg3008',0) NEXT FIELD occ631
             END IF
          ELSE
             IF g_occ.occ63 > 0 THEN
                CALL cl_err('occ631','axm-917',0)
                NEXT FIELD occ631
             END IF
          END IF
 
 
       AFTER FIELD occ63
          IF cl_null(g_occ.occ63) THEN LET g_occ.occ63 = 0  END IF
          IF g_occ.occ63=0 AND g_occ.occ62 ='Y' THEN
            LET l_n = 0
            IF g_occ.occ33 <> g_occ.occ01 THEN
             SELECT SUM(occ63) INTO l_n FROM occ_file
              WHERE occ33 = g_occ.occ33
            END IF
            #CHI-A60017 mark --start--
            # IF cl_null(l_n) OR l_n=0 THEN
            #    CALL cl_err('occ63','axm-052',0)
            #    NEXT FIELD occ63
            # END IF  #MOD-720053 add
            #CHI-A60017 mark --end-- 
          END IF
          IF g_occ.occ63 > 0 AND cl_null(g_occ.occ631) THEN
             CALL cl_err('occ631','axm-917',0)
             NEXT FIELD occ631
          END IF
 
       AFTER FIELD occ64
          IF cl_null(g_occ.occ64) THEN LET g_occ.occ64 = 0 END IF
          IF g_occ.occ64<0 AND g_occ.occ62='Y' THEN
             CALL cl_err('occ64','mfg5034',0)
             NEXT FIELD occ64
          END IF
 
       BEFORE FIELD occ33
          IF cl_null(g_occ.occ33) THEN
             LET g_occ.occ33 = g_occ.occ01
             DISPLAY BY NAME g_occ.occ33
          ELSE
             LET g_occ_t.occ33 = g_occ.occ33
          END IF
 
       AFTER FIELD occ33
          IF cl_null(g_occ.occ33) THEN NEXT FIELD occ33 END IF
          IF g_occ.occ33 !=g_occ.occ01 THEN
             SELECT COUNT(*) INTO l_n FROM occ_file
              WHERE occ01 = g_occ.occ33
             IF l_n = 0 THEN
                CALL cl_err(g_occ.occ33,'mfg1306',1)
                LET g_occ.occ33 = g_occ_t.occ33
                DISPLAY BY NAME g_occ.occ33
                NEXT FIELD occ33
             ELSE
                SELECT occ62 INTO l_occ62 FROM occ_file
                 WHERE occ01= g_occ.occ33
                IF cl_null(l_occ62) OR l_occ62='N' THEN
                   CALL cl_err(g_occ.occ33,'axm-103',1)
                   NEXT FIELD occ33
                END IF
             END IF
          END IF
 
       AFTER FIELD occ36
         IF g_occ.occ36 < 0 THEN
            NEXT FIELD occ36
         END IF

       ON ACTION controlp
          CASE WHEN INFIELD(occ631)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_azi'
                    LET g_qryparam.default1 = g_occ.occ631
                    CALL cl_create_qry() RETURNING g_occ.occ631
                    DISPLAY BY NAME g_occ.occ631
                    NEXT FIELD occ631
               WHEN INFIELD(occ61)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_ocg'
                    LET g_qryparam.default1 = g_occ.occ61
                    CALL cl_create_qry() RETURNING g_occ.occ61
                    DISPLAY BY NAME g_occ.occ61
                    NEXT FIELD occ61
               WHEN INFIELD(occ33)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_occ'
                    LET g_qryparam.default1 = g_occ.occ33
                    CALL cl_create_qry() RETURNING g_occ.occ33
                    DISPLAY BY NAME g_occ.occ33
                    NEXT FIELD occ33
               WHEN INFIELD(occ66)   #代送商
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_pmc8'   #FUN-640014 modify
                    LET g_qryparam.default1 = g_occ.occ56
                    CALL cl_create_qry() RETURNING g_occ.occ66
                    DISPLAY BY NAME g_occ.occ66
                    NEXT FIELD occ66
          END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
 
    IF INT_FLAG THEN 
       LET INT_FLAG=0 
       CLOSE i221_cl        #MOD-950005
       ROLLBACK WORK        #MOD-950005
       #FUN-B70075 Add Begin---
       IF g_aza.aza88 = 'Y' THEN
          LET g_occ.occpos = l_occpos
          UPDATE occ_file 
             SET occpos = g_occ.occpos
           WHERE occ01 = g_occ.occ01
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","occ_file",g_occ_t.occ01,"",SQLCA.sqlcode,"","",1)
          END IF
          DISPLAY BY NAME g_occ.occpos
       END IF
       #FUN-B70075 Add End-----
       RETURN 
    END IF

    #FUN-B70075 Add Begin---
    IF g_aza.aza88='Y' THEN
       IF l_occpos <> '1' THEN
          LET g_occ.occpos = '2'
       ELSE
          LET g_occ.occpos = '1'
       END IF
    END IF
    #FUN-B70075 Add End-----
   #TQC-C50154 -- add -- begin
    LET g_occ.occmodu = g_user                #修改者
    LET g_occ.occdate = g_today               #修改日期 
   #TQC-C50154 -- add -- end
    UPDATE occ_file SET * = g_occ.* WHERE occ01 = g_occ.occ01
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("upd","occ_file",g_occ.occ01,"",SQLCA.SQLCODE,"","update occ",1)  #No.FUN-660167
       ROLLBACK WORK
    ELSE
       CALL i221_list_fill()  #No.FUN-7C0010
       COMMIT WORK
       DISPLAY BY NAME g_occ.occpos   #FUN-B70075 ADD
    END IF
 
    CALL i221_s()
    CALL i221_show()    #TQC-C50154 add  同步顯示
END FUNCTION
 
 
FUNCTION i221_x()
 
   DEFINE g_chr LIKE occ_file.occacti
 
   IF s_shut(0) THEN RETURN END IF
   IF g_occ.occ01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF

   LET g_success='Y'    #FUN-9A0056 add

   BEGIN WORK
 
   OPEN i221_cl USING g_occ.occ01
   IF STATUS THEN
      CALL cl_err("OPEN i221_cl:", STATUS, 1)
      CLOSE i221_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i221_cl INTO g_occ.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_occ.occ01,SQLCA.sqlcode,1)
      CLOSE i221_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
 
   IF NOT cl_null(g_occ.occ930) THEN
      CALL cl_err('','art-455',0)
      RETURN
   END IF
   CALL i221_show()
 
   IF cl_exp(0,0,g_occ.occacti) THEN
      LET g_chr=g_occ.occacti
     CASE g_occ.occ1004
       WHEN '0' #開立
            IF g_occ.occacti='N' THEN
               LET g_occ.occacti='P'
            ELSE
               LET g_occ.occacti='N'
            END IF
       WHEN '1' #確認
            IF g_occ.occacti='N' THEN
               LET g_occ.occacti='Y'
            ELSE
               LET g_occ.occacti='N'
            END IF
       WHEN '2' #留置
            IF g_occ.occacti='N' THEN
               LET g_occ.occacti='H'
            ELSE
               LET g_occ.occacti='N'
            END IF
       WHEN '3' #停止交易
            IF g_occ.occacti='N' THEN
               LET g_occ.occacti='H'
            ELSE
               LET g_occ.occacti='N'
            END IF
      END CASE
 
      UPDATE occ_file SET occacti = g_occ.occacti
       WHERE occ01 = g_occ.occ01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
         LET g_occ.occacti=g_chr
 
      ELSE 
         IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
           #FUN-9A0056 add str ---
           #當確定資料由有效變無效,傳送刪除MES;若確定資料由無效變有效則傳送新增MES
            IF g_occ.occ1004='1' THEN
              IF g_occ.occacti='N' THEN
                 CALL i221_mes('delete',g_occ.occ01)
              ELSE
                 CALL i221_mes('insert',g_occ.occ01)
              END IF
            END IF
           #FUN-9A0056 add end ---

           #FUN-9A0056 mark str -----
           #IF g_occ.occacti='N' THEN
           #   # CALL aws_mescli()
           #   # 傳入參數: (1)程式代號
           #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
           #   #           (3)Key
           #   CASE aws_mescli('axmi221','delete',g_occ.occ01)
           #      WHEN 0  #無與 MES 整合
           #            MESSAGE 'DELETE O.K'
           #      WHEN 1  #呼叫 MES 成功
           #            MESSAGE 'DELETE O.K, DELETE MES O.K'
           #      WHEN 2  #呼叫 MES 失敗
           #            RETURN FALSE
           #   END CASE
           #END IF
           #FUN-9A0056 mark end -----
         END IF  #TQC-8B0011  ADD
 
      END IF
      DISPLAY BY NAME g_occ.occacti
      CALL i221_list_fill()  #No.FUN-7C0010
   END IF
 
   CLOSE i221_cl

  #FUN-9A0056 add begin--
   IF g_success = 'N' THEN
     ROLLBACK WORK
   ELSE
     COMMIT WORK
   END IF
  #FUN-9A0056 add end  --

   #COMMIT WORK   #FUN-9A0056 mark

   SELECT * INTO g_occ.* FROM occ_file where occ01=g_occ.occ01 #FUN-690021--add
   CALL i221_show()                                            #FUN-690021--add
 
END FUNCTION
 
FUNCTION i221_r()
 DEFINE l_cnt    LIKE type_file.num5       #MOD-B30641
#DEFINE l_n      LIKE type_file.num5       #FUN-C50136 add 
    IF s_shut(0) THEN RETURN END IF
    IF g_occ.occ01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_occ.occ1004 = '1' THEN CALL cl_err('',9023,0) RETURN END IF   #MOD-890143
 
    IF g_aza.aza88='Y' THEN
      #FUN-B50023 --START--
       #IF NOT (g_occ.occacti='N' AND g_occ.occpos='Y') THEN
       #   #CALL cl_err('', 'aim-944', 1)    #FUN-A30030 MARK
       #   CALL cl_err('', 'art-648', 1)    #ADD
       #   RETURN
       #END IF
       IF NOT ((g_occ.occpos='3' AND g_occ.occacti='N') 
                 OR (g_occ.occpos='1'))  THEN                  
         CALL cl_err('','apc-139',0)            
         RETURN
      END IF    
      #FUN-B50023 --END--
    END IF
 
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'r') THEN
      CALL cl_err(g_occ.occ246,'aoo-044',1)
      RETURN
   END IF

#MOD-B30641 --begin--
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM oea_file
    WHERE oea03 = g_occ.occ01
      AND (oea49 != '2' OR oeaconf != 'X')
   IF l_cnt > 0 THEN 
      CALL cl_err('','axm-376',0)
      RETURN 
   END IF        
#MOD-B30641 --end--
 
#FUN-C50136---add---str---
#   LET l_n = 0
#   SELECT COUNT(*) INTO l_n FROM oig_file,oif_file
#      WHERE oig01=oif01 AND oifacti<>'N' AND oifconf<>'X'
#        AND oig02=g_occ.occ01
#   IF l_n > 0 THEN
#      CALL cl_err('','axm-690',0)
#      RETURN
#   END IF
#FUN-C50136---add---end---
 
    BEGIN WORK
 
    OPEN i221_cl USING g_occ.occ01
    IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 1)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i221_cl INTO g_occ.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_occ.occ01,SQLCA.sqlcode,1)
       CLOSE i221_cl        #MOD-950005
       ROLLBACK WORK       #FUN-680010
       RETURN
    END IF
    IF g_occ.occacti = 'N' THEN
       CALL cl_err('','abm-950',0)
       CLOSE i221_cl        #MOD-950005
       ROLLBACK WORK
       RETURN
    END IF
    IF g_azw.azw04 = '2' THEN ##MOD-C40104添加業態條件
       IF NOT cl_null(g_occ.occ930) THEN
          CALL cl_err('','art-454',0)
          RETURN
       END IF
    END IF 
    CALL i221_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "occ01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_occ.occ01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       IF (NOT cl_del_itemname("occ_file","occ02", g_occ.occ01)) THEN
          CLOSE i221_cl        #MOD-950005
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM occg_file WHERE occg01 = g_occ.occ01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","occg_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)
          CLOSE i221_cl        #MOD-950005
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM ocd_file  WHERE ocd01 = g_occ.occ01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","ocd_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)
          CLOSE i221_cl        #MOD-950005
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM oce_file  WHERE oce01 = g_occ.occ01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","oce_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)
          CLOSE i221_cl        #MOD-950005
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM oci_file  WHERE oci01 = g_occ.occ01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","oci_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)
          CLOSE i221_cl        #MOD-950005
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM ocj_file  WHERE ocj01 = g_occ.occ01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","ocj_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)
          CLOSE i221_cl        #MOD-950005
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM tqo_file  WHERE tqo01 = g_occ.occ01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","tqo_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)
          CLOSE i221_cl        #MOD-950005
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM tqk_file  WHERE tqk01 = g_occ.occ01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","tqk_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)
          CLOSE i221_cl        #MOD-950005
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM occ_file  WHERE occ01 = g_occ.occ01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)
          CLOSE i221_cl        #MOD-950005
          ROLLBACK WORK
          RETURN
       END IF

       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980010
          VALUES ('axmi221',g_user,g_today,g_msg,g_occ.occ01,'delete',g_plant,g_legal)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","azo_file","axmi221","",SQLCA.sqlcode,"","",1)
          CLOSE i221_cl        #MOD-950005
          ROLLBACK WORK
          RETURN
       END IF
 
       # CALL aws_spccli_base()
       # 傳入參數: (1)TABLE名稱, (2)刪除資料,
       #           (3)功能選項：insert(新增),update(修改),delete(刪除)
       CASE aws_spccli_base('occ_file',base.TypeInfo.create(g_occ),'delete')
          WHEN 0  #無與 SPC 整合
               MESSAGE 'DELETE O.K'
          WHEN 1  #呼叫 SPC 成功
               MESSAGE 'DELETE O.K, DELETE SPC O.K'
          WHEN 2  #呼叫 SPC 失敗
               CLOSE i221_cl        #MOD-950005
               ROLLBACK WORK
               RETURN
       END CASE
 
       CLEAR FORM
       INITIALIZE g_occ.* TO NULL
       OPEN i221_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i221_cs
          CLOSE i221_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i221_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i221_cs
          CLOSE i221_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i221_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i221_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i221_fetch('/')
       END IF
       CALL i221_list_fill()  #No.FUN-7C0010
    END IF
    CLOSE i221_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i221_out()
   DEFINE l_occ           RECORD LIKE occ_file.*,
          l_i             LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680137 VARCHAR(20)
          l_za05          LIKE type_file.chr1000                #  #No.FUN-680137 VARCHAR(40)
   DEFINE g_str           STRING                  #No.FUN-830154 
   DEFINE l_wc string 
   --SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog      #No.FUN-830154    
   --IF cl_null(g_wc) THEN
      --IF cl_null(g_occ.occ01) THEN
          --CALL cl_err('','9057',0) RETURN
      --ELSE
           --LET g_wc=" occ01='",g_occ.occ01,"'"
      --END IF
   --END IF
 --
   --CALL cl_wait()
 --
   --SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 --
   --LET g_sql = "SELECT * FROM occ_file ",          # 組合出 SQL 指令
               --" WHERE ",g_wc CLIPPED
     --IF g_zz05 = 'Y' THEN                                                                                                           
        --CALL cl_wcchp(g_wc,'occ01,occ02,occ18,occ19,occ11,occ37,occ28,occ34,occ66,occ1005,    #MOD-910146                         
                           --occ1004,occ06,occ09,occ07,occ03,occ04,occ56,occ57,occ31,occ65,occ22,occ21,occ20,                         
                           --occ261,occ262,occ263,occ271,occ272,occ29,occ30,occ292,occ302,occ35,occ231,occ232,                        
                           --occ233,occ234,occ235,occ241,occ242,occ243,occ244,occ245,occ40,occ38,occ39,occ73,occ16,     #FUN-990031 add occ73                       
                           --occ171,occ172,occ173,occ174,occ62,occ33,occ61,occ36,occ175,occ631,occ63,occ64,occ42,                     
                           --occ41,occ08,occ44,occ45,occ68,occ69,occ67,occ43,occ55,occ47,occ48,occ49,occ50,occ46,occ53,occ32,                     
                           --occ51,occ52,occ701,occ702,occ703,occ704,occ76,occ77,occ12,occ13,occ14,occ15,occ05,occ1706,occ1705,    #FUN-B90105 add occ76/77
#                           occ51,occ52,occ701,occ702,occ703,occ704,occ12,occ13,occ14,occ15,occ05,occ1706,occ1705,                #FUN-B90105 add occ76/77
                           --occ1707,occ1708,occud01,occud02,occud03,occud04,occud05,occud06,occud07,occud08,occud09,                 
                           --occud10,occud11,occud12,occud13,occud14,occud15,occ1003,occ1006,occ1007,occ1008,occ1009,                 
                           --occ1010,occ1011,occ1012,occ1013,occ1014,occ1015,occ1016,occ1027,occuser,occgrup,occmodu,                 
                           --occdate,occacti')                                                                                        
        #RETURNING g_wc   #MOD-A50036                                                                                                            
        --RETURNING g_str   #MOD-A50036                                                                                                            
        #LET g_str = g_wc #MOD-A50036                                                                                                           
     --END IF                                                                                                                         
   #LET g_str =g_str      #MOD-A50036                                                                                                           
   --CALL cl_prt_cs1('axmi221','axmi221',g_sql,g_str)    
   LET l_wc='occ01="',g_occ.occ01,'"'
           LET g_msg = "cxmr009",  #FUN-C30085 add
                  " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '' '1'",
                   " '",l_wc CLIPPED,"' "
                  ," '1' 'N' 'N' 'Y'" 
    CALL cl_cmdrun(g_msg)
 
END FUNCTION
 
#--------------#
# 信用額度拋轉 #
#--------------#
FUNCTION i221_s()
   DEFINE l_occg     RECORD LIKE occg_file.*    # 客戶GLOBAL檔
 
   IF g_occ.occ01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_occ.occ62='N' OR cl_null(g_occ.occ62) THEN RETURN END IF   # 信用查核否
   LET g_success='Y'
   BEGIN WORK
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM occg_file
    WHERE occg01=g_occ.occ01                    # 客戶編號
   IF cl_null(g_occ.occ63) THEN LET g_occ.occ63=0 END IF
   IF cl_null(g_occ.occ64) THEN LET g_occ.occ64=0 END IF
   IF g_cnt>0
      THEN
      UPDATE occg_file SET occg03=g_occ.occ63,
                           occg04=g_occ.occ64
       WHERE occg01=g_occ.occ01                    # 客戶編號
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","occg_file",g_occ.occ01,g_occ.occ11,SQLCA.sqlcode,"","upd occg_file",1)  #No.FUN-660167
	 LET g_success = 'N'
      ELSE
         MESSAGE "Update Ok !!"
      END IF
   ELSE
       INSERT INTO occg_file(occg01,occg02,occg03,occg04)  #No.MOD-470041
                     VALUES(g_occ.occ01,g_occ.occ11,
                            g_occ.occ63,g_occ.occ64)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","occg_file",g_occ.occ01,"",SQLCA.sqlcode,"","ins occg_file",1)  #No.FUN-660167
	 LET g_success = 'N'
      ELSE
         MESSAGE "Insert Ok !!"
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
# here -----
END FUNCTION
 
FUNCTION i221_dbs() # Add By Carol for multiplant transfer 01/09/26
   DEFINE l_ans         LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
          l_exit_sw     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_c,l_s,i     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_cnt         LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
   IF g_occ.occ1004!='1' THEN                     #FUN-690021-mod
      #不在確認狀態，不可異動！
      CALL cl_err('','atm-053',0)
      RETURN
   END IF
   IF s_shut(0) THEN RETURN END IF
   LET l_ans = ' '
   WHILE l_ans IS NULL OR l_ans NOT MATCHES "[120]"
      CALL cl_getmsg('axm-029',g_lang) RETURNING g_msg
      LET INT_FLAG = 0  ######add for prompt bug
      PROMPT g_msg CLIPPED || ': ' FOR CHAR l_ans
#     PROMPT ' (1)INSERT   (2)UPDATE   (0)Exit : ' FOR CHAR l_ans
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END PROMPT
      IF INT_FLAG THEN EXIT WHILE END IF
   END WHILE
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF l_ans = '0' THEN RETURN END IF
 
   LET p_row = 10 LET p_col = 25
 
   OPEN WINDOW i221_7_w AT p_row,p_col WITH FORM "axm/42f/axmi221_7"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmi221_7")
 
 
   CALL tm.plant.clear()
   CALL tm.dbs.clear()
 
   WHILE TRUE
      LET l_exit_sw='y'
      INPUT ARRAY tm.plant WITHOUT DEFAULTS FROM s_plant.*
         BEFORE FIELD plant
            LET l_c = ARR_CURR()
            LET l_s = SCR_LINE() #No:8184
         AFTER FIELD plant
            IF NOT cl_null(tm.plant[l_c]) THEN
               IF g_plant = tm.plant[l_c] THEN
                  CALL cl_err(tm.plant[l_c],'mfg9186',1) NEXT FIELD plant
               END IF
               SELECT azp01 FROM azp_file WHERE azp01 = tm.plant[l_c]
                                            AND azp053 != 'N' #no.7431
               IF STATUS THEN
                  CALL cl_err3("sel","azp_file",tm.plant[l_c],"",STATUS,"","sel azp",1)  #No.FUN-660167
                  NEXT FIELD plant
               ELSE
                  SELECT azp03 INTO tm.dbs[l_c] FROM azp_file
                   WHERE azp01 = tm.plant[l_c]
                  IF cl_null(tm.dbs[l_c]) THEN
                     CALL cl_err('sel azp',STATUS,1)
                     NEXT FIELD plant
                  END IF
               END IF
               LET g_success = 'Y'
               FOR i = 1 TO 20      # 檢查工廠/database是否重覆
                   IF cl_null(tm.plant[i]) OR i = l_c THEN CONTINUE FOR END IF
                   IF tm.plant[i] = tm.plant[l_c] THEN
                      CALL cl_err(tm.plant[l_c],'aom-492',1)
                      LET g_success = 'N'
                      EXIT FOR
                   END IF
                   IF tm.dbs[i] = tm.dbs[l_c] THEN
                      LET g_msg=tm.plant[l_c] CLIPPED,'/',tm.dbs[l_c] CLIPPED
                      CALL cl_err(g_msg,'mfg9184',1)
                      LET g_success = 'N'
                      EXIT FOR
                   END IF
               END FOR
               IF g_success = 'N' THEN NEXT FIELD plant END IF
 
               IF NOT s_chkdbs(g_user,tm.plant[l_c],g_rlang) THEN
                  NEXT FIELD plant
               END IF
            ELSE
               LET tm.dbs[l_c]=''
            END IF
         AFTER INPUT                    # 檢查至少輸入一個工廠
            IF INT_FLAG THEN EXIT INPUT END IF
            LET l_cnt = ARR_COUNT()
            FOR i = 1 TO l_cnt
               IF NOT cl_null(tm.plant[i]) THEN
                  EXIT INPUT
               ELSE
                  LET tm.dbs[i] = ''
               END IF
            END FOR
            IF i = l_cnt+1 THEN
               CALL cl_err('','aom-423',1)
               NEXT FIELD plant
            END IF
        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(plant)  #工廠
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_azp'
                     LET g_qryparam.default1 = tm.plant[l_c]
                     CALL cl_create_qry() RETURNING tm.plant[l_c]
                     DISPLAY tm.plant[l_c] TO s_plant[l_s].plant #No:8184
                OTHERWISE EXIT CASE
           END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i221_7_w
         RETURN
      END IF
      IF l_exit_sw='y' THEN EXIT WHILE END IF
   END WHILE
   CLOSE WINDOW i221_7_w
 
   BEGIN WORK
 
   LET g_success='Y'
   IF l_ans = '1' THEN CALL i221_dbs_ins() END IF
   IF l_ans = '2' THEN CALL i221_dbs_upd() END IF
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
 
END FUNCTION
 
FUNCTION i221_dbs_ins()
   DEFINE l_exit_sw     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_chk_occg    LIKE type_file.chr1,    #No.FUN-680137  VARCHAR(1)
          l_chk_ocd     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_chk_oce     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_chk_oci     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_chk_occ     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_chk_ocj     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_chk_tql     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_chk_tqk     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)    #債權維護
          l_chk_tqo     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)    #定價維護
          l_chk_pov     LIKE type_file.chr1,    #FUN-7C0004 add 內部交易資料
          l_c,l_s,i     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_cnt         LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_dbs,l_dbs2  LIKE azp_file.azp03    #FUN-7C0004
 
   MESSAGE ' COPY FOR INSERT .... '
 
  #讀取相關資料..........................................
   LET l_chk_occg = 'Y'
   LET l_chk_ocd = 'Y'
   LET l_chk_oce = 'Y'
   LET l_chk_oci = 'Y'
   LET l_chk_occ = 'Y'
   LET l_chk_ocj = 'Y'
   LET l_chk_tql = 'Y'
   LET l_chk_tqk = 'Y'
   LET l_chk_tqo = 'Y'
   LET l_chk_pov = 'Y'   #FUN-7C0004 add
   DROP TABLE w1
   DROP TABLE w2
   DROP TABLE w3
   DROP TABLE w4
   DROP TABLE w5
   DROP TABLE w6
   DROP TABLE w7
   DROP TABLE w8
   DROP TABLE w9
   DROP TABLE w10      #FUN-7C0004 add
 
   SELECT * FROM occg_file WHERE occg01 = g_occ.occ01 INTO TEMP w1
   IF STATUS THEN LET l_chk_occg='N' END IF
 
   SELECT * FROM ocd_file WHERE ocd01 = g_occ.occ01 INTO TEMP w2
   IF STATUS THEN LET l_chk_ocd='N' END IF
 
   SELECT * FROM oce_file WHERE oce01 = g_occ.occ01 INTO TEMP w3
   IF STATUS THEN LET l_chk_oce='N' END IF
 
   SELECT * FROM occ_file WHERE occ01 = g_occ.occ01 INTO TEMP w4
   IF STATUS THEN LET l_chk_occ='N' END IF
 
   SELECT * FROM oci_file WHERE oci01 = g_occ.occ01 INTO TEMP w5
   IF STATUS THEN LET l_chk_oci='N' END IF
 
   SELECT * FROM ocj_file WHERE ocj01 = g_occ.occ01 INTO TEMP w6
   IF STATUS THEN LET l_chk_ocj='N' END IF
   SELECT * FROM tql_file WHERE tql01 = g_occ.occ01 INTO TEMP w7   #No.TQC-650089
   IF STATUS THEN LET l_chk_tql='N' END IF
 
   SELECT * FROM tqk_file WHERE tqk01 = g_occ.occ01 INTO TEMP w8   #NO.TQC-650089
   IF STATUS THEN LET l_chk_tqk='N' END IF
 
   SELECT * FROM tqo_file WHERE tqo01 = g_occ.occ01 INTO TEMP w9    #No.TQC-650089
   IF STATUS THEN LET l_chk_tqo='N' END IF
   SELECT * FROM pov_file WHERE pov01 = '1' and pov02 = g_occ.occ01 INTO TEMP w10
   IF STATUS THEN LET l_chk_pov='N' END IF
 
   FOR i = 1 TO 20
       IF cl_null(tm.dbs[i]) THEN  CONTINUE FOR END IF
       LET l_dbs = tm.dbs[i]           #FUN-7C0004
 
       #LET g_sql='INSERT INTO ',s_dbstring(l_dbs CLIPPED),'occg_file ', #FUN-930006 #FUN-A50102
       #         'SELECT * FROM ',s_dbstring(l_dbs2 CLIPPED),'w1'       #FUN-930006  #FUN-A50102
       LET g_sql='INSERT INTO  ',cl_get_target_table(tm.plant[i], 'occg_file'), #FUN-930006 #FUN-A50102
                 '  SELECT * FROM w1 '  #FUN-A50102
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102     
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102  
       PREPARE i_occg FROM g_sql
 
       #LET g_sql='INSERT INTO ',s_dbstring(l_dbs CLIPPED),'ocd_file ',    #FUN-930006 #FUN-A50102
       #          'SELECT * FROM ',s_dbstring(l_dbs2 CLIPPED),'w2'         #FUN-930006  #FUN-A50102
       LET g_sql='INSERT INTO ',cl_get_target_table(tm.plant[i], 'ocd_file'), #FUN-930006 #FUN-A50102
                 ' SELECT * FROM w2 '  #FUN-A50102
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102     
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102       
       PREPARE i_ocd FROM g_sql
 
       #LET g_sql='INSERT INTO ',s_dbstring(l_dbs CLIPPED),'oce_file ',    #FUN-930006  #FUN-A50102
       #          'SELECT * FROM ',s_dbstring(l_dbs2 CLIPPED),'w3'         #FUN-930006   #FUN-A50102   
       LET g_sql='INSERT INTO ',cl_get_target_table(tm.plant[i], 'oce_file'), #FUN-930006 #FUN-A50102
                 ' SELECT * FROM w3 '   #FUN-A50102
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102     
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102       
       PREPARE i_oce FROM g_sql
 
       #LET g_sql='INSERT INTO ',s_dbstring(l_dbs CLIPPED),'occ_file ',    #FUN-930006  #FUN-A50102
       #          'SELECT * FROM ',s_dbstring(l_dbs2 CLIPPED),'w4'         #FUN-930006   #FUN-A50102
       LET g_sql='INSERT INTO ',cl_get_target_table(tm.plant[i], 'occ_file'), #FUN-930006 #FUN-A50102
                 ' SELECT * FROM  w4 '   #FUN-A50102
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102     
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102       
       PREPARE i_occ FROM g_sql
 
       #LET g_sql='INSERT INTO ',s_dbstring(l_dbs CLIPPED),'oci_file ',    #FUN-930006  #FUN-A50102
       #          'SELECT * FROM ',s_dbstring(l_dbs2 CLIPPED),'w5'         #FUN-930006   #FUN-A50102
       LET g_sql='INSERT INTO ',cl_get_target_table(tm.plant[i], 'oci_file'), #FUN-930006 #FUN-A50102
                 ' SELECT * FROM w5 '   #FUN-A50102
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102     
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102       
       PREPARE i_oci FROM g_sql
 
       #LET g_sql='INSERT INTO ',s_dbstring(l_dbs CLIPPED),'ocj_file ',    #FUN-930006      #FUN-A50102
       #          'SELECT * FROM ',s_dbstring(l_dbs2 CLIPPED),'w6'         #FUN-930006       #FUN-A50102
       LET g_sql='INSERT INTO ',cl_get_target_table(tm.plant[i], 'ocj_file'), #FUN-930006 #FUN-A50102
                 ' SELECT * FROM w6 '   #FUN-A50102
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102     
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102       
       PREPARE i_ocj FROM g_sql
 
       #LET g_sql='INSERT INTO ',s_dbstring(l_dbs CLIPPED),'tql_file ',     #FUN-930006   #FUN-A50102
       #          'SELECT * FROM ',s_dbstring(l_dbs2 CLIPPED),'w7'          #FUN-930006    #FUN-A50102
       LET g_sql='INSERT INTO ',cl_get_target_table(tm.plant[i], 'tql_file'), #FUN-930006 #FUN-A50102
                 ' SELECT * FROM w7 '   #FUN-A50102
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102      
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102      
       PREPARE i_tql FROM g_sql
 
       #LET g_sql='INSERT INTO ',s_dbstring(l_dbs CLIPPED),'tqk_file ', #FUN-930006   #FUN-A50102
       #          'SELECT * FROM ',s_dbstring(l_dbs2 CLIPPED),'w8'      #FUN-930006    #FUN-A50102
       LET g_sql='INSERT INTO ',cl_get_target_table(tm.plant[i], 'tqk_file'), #FUN-930006 #FUN-A50102
                 ' SELECT * FROM w8 '   #FUN-A50102
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102     
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102       
       PREPARE i_tqk FROM g_sql
 
       #LET g_sql='INSERT INTO ',s_dbstring(l_dbs CLIPPED),'tqo_file ', #FUN-930006   #FUN-A50102
       #          'SELECT * FROM ',s_dbstring(l_dbs2 CLIPPED),'w9'      #FUN-930006    #FUN-A50102
       LET g_sql='INSERT INTO ',cl_get_target_table(tm.plant[i], 'tqo_file'), #FUN-930006 #FUN-A50102
                 ' SELECT * FROM w9 '   #FUN-A50102
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102     
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102       
       PREPARE i_tqo FROM g_sql
 
       #LET g_sql='INSERT INTO ',s_dbstring(l_dbs CLIPPED),'pov_file ', #FUN-930006   #FUN-A50102
       #          'SELECT * FROM ',s_dbstring(l_dbs2 CLIPPED),'w10'     #FUN-930006    #FUN-A50102
       LET g_sql='INSERT INTO ',cl_get_target_table(tm.plant[i], 'pov_file'), #FUN-930006 #FUN-A50102
                 ' SELECT * FROM w10 '   #FUN-A50102
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102     
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102       
       PREPARE i_pov FROM g_sql
 
#-------------------- COPY FILE ------------------------------
       IF l_chk_occg = 'Y' THEN
          EXECUTE i_occg
          IF STATUS THEN
             LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':occg'
             CALL cl_err(g_msg,SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
       END IF
       IF l_chk_ocd = 'Y' THEN
          EXECUTE i_ocd
          IF STATUS THEN
             LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':ocd'
             CALL cl_err(g_msg,SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
       END IF
       IF l_chk_oce = 'Y' THEN
          EXECUTE i_oce
          IF STATUS THEN
             LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':oce'
             CALL cl_err(g_msg,SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
       END IF
       IF l_chk_occ = 'Y' THEN
          EXECUTE i_occ
          IF STATUS THEN
             LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':occ'
             CALL cl_err(g_msg,SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
       END IF
       IF l_chk_oci = 'Y' THEN
          EXECUTE i_oci
          IF STATUS THEN
             LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':oci'
             CALL cl_err(g_msg,SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
       END IF
       IF l_chk_ocj = 'Y' THEN
          EXECUTE i_ocj
          IF STATUS THEN
             LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':ocj'
             CALL cl_err(g_msg,SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
       END IF
       IF l_chk_tql = 'Y' THEN
          EXECUTE i_tql
          IF STATUS THEN
             LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':tql'
             CALL cl_err(g_msg,SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
       END IF
       IF l_chk_tqk = 'Y' THEN
          EXECUTE i_tqk
          IF STATUS THEN
             LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':tqk'
             CALL cl_err(g_msg,SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
       END IF
       IF l_chk_tqo = 'Y' THEN
          EXECUTE i_tqo
          IF STATUS THEN
             LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':tqo'
             CALL cl_err(g_msg,SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
       END IF
       IF l_chk_pov = 'Y' THEN
          EXECUTE i_pov
          IF STATUS THEN
             LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':pov'
             CALL cl_err(g_msg,SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
       END IF
 
   END FOR
 
END FUNCTION
 
FUNCTION i221_dbs_upd()
   DEFINE l_occg        RECORD LIKE occg_file.*,
          l_ocd         RECORD LIKE ocd_file.*,
          l_oce         RECORD LIKE oce_file.*,
          l_occ         RECORD LIKE occ_file.*,
          l_oci         RECORD LIKE oci_file.*,
          l_ocj         RECORD LIKE ocj_file.*,
          l_tqk         RECORD LIKE tqk_file.*,
          l_tqo         RECORD LIKE tqo_file.*,
          l_tql         RECORD LIKE tql_file.*,
          l_pov         RECORD LIKE pov_file.*,   #FUN-7C0004 add
          l_c,l_s,i     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_sql         STRING, #No.TQC-6B0148  type_file.char1000-->STRING
          l_cnt         LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE  l_dbs         LIKE azp_file.azp03    #FUN-7C0004
  DEFINE  l_occ02_t     LIKE occ_file.occ02    #No.FUN-A30110
 
   MESSAGE ' COPY FOR THE UPDATE .... '      #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE
  #讀取相關資料..........................................
   LET g_sql='SELECT * FROM occg_file WHERE occg01="',g_occ.occ01 CLIPPED,'" '
   PREPARE s_occg_p FROM g_sql
   DECLARE s_occg CURSOR FOR s_occg_p
 
   LET g_sql='SELECT * FROM ocd_file WHERE ocd01="',g_occ.occ01 CLIPPED,'" '
   PREPARE s_ocd_p FROM g_sql
   DECLARE s_ocd CURSOR FOR s_ocd_p
 
   LET g_sql='SELECT * FROM oce_file WHERE oce01="',g_occ.occ01 CLIPPED,'" '
   PREPARE s_oce_p FROM g_sql
   DECLARE s_oce CURSOR FOR s_oce_p
 
   LET g_sql='SELECT * FROM occ_file WHERE occ01="',g_occ.occ01 CLIPPED,'" '
   PREPARE s_occ_p FROM g_sql
   DECLARE s_occ CURSOR FOR s_occ_p
 
   LET g_sql='SELECT * FROM oci_file WHERE oci01="',g_occ.occ01 CLIPPED,'" '
   PREPARE s_oci_p FROM g_sql
   DECLARE s_oci CURSOR FOR s_oci_p
 
   LET g_sql='SELECT * FROM ocj_file WHERE ocj01="',g_occ.occ01 CLIPPED,'" '
   PREPARE s_ocj_p FROM g_sql
   DECLARE s_ocj CURSOR FOR s_ocj_p
   
   LET g_sql='SELECT * FROM tql_file WHERE tql01="',g_occ.occ01 CLIPPED,'" '
   PREPARE s_tql_p FROM g_sql
   DECLARE s_tql CURSOR FOR s_tql_p
 
   LET g_sql='SELECT * FROM tqk_file WHERE tqk01="',g_occ.occ01 CLIPPED,'" '
   PREPARE s_tqk_p FROM g_sql
   DECLARE s_tqk CURSOR FOR s_tqk_p
 
   LET g_sql='SELECT * FROM tqo_file WHERE tqo01="',g_occ.occ01 CLIPPED,'" '
   PREPARE s_tqo_p FROM g_sql
   DECLARE s_tqo CURSOR FOR s_tqo_p
   
   LET g_sql="SELECT * FROM pov_file WHERE pov01='1' AND pov02 ='",g_occ.occ01 CLIPPED,"'"
   PREPARE s_pov_p FROM g_sql
   DECLARE s_pov CURSOR FOR s_pov_p
   FOR i = 1 TO 20
       IF cl_null(tm.dbs[i]) THEN  CONTINUE FOR END IF
 
       LET l_dbs = tm.dbs[i]           #FUN-7C0004
 
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(l_dbs CLIPPED),'occg_file ', #FUN-930006  #FUN-A50102
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm.plant[i], 'occg_file'), #FUN-930006  #FUN-A50102
                 ' WHERE occg01= ? ' CLIPPED
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
       PREPARE c_occg_p FROM g_sql
       DECLARE c_occg CURSOR FOR c_occg_p
 
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(l_dbs CLIPPED),'ocd_file ', #FUN-930006 #FUN-A50102
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm.plant[i], 'ocd_file'), #FUN-930006 #FUN-A50102
                 ' WHERE ocd01= ? ',
                 '  AND  ocd02= ?' CLIPPED
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102           
       PREPARE c_ocd_p FROM g_sql
       DECLARE c_ocd CURSOR FOR c_ocd_p
 
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(l_dbs CLIPPED),'oce_file ', #FUN-930006 #FUN-A50102
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm.plant[i], 'oce_file'), #FUN-930006 #FUN-A50102
                 ' WHERE oce01= ? ',
                 '  AND  oce03= ? ' CLIPPED
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
       PREPARE c_oce_p FROM g_sql
       DECLARE c_oce CURSOR FOR c_oce_p
 
       #LET g_sql='SELECT COUNT(*),occ02 FROM ',s_dbstring(l_dbs CLIPPED),'occ_file ', #FUN-930006    #No.FUN-A30110 #FUN-A50102
       LET g_sql='SELECT COUNT(*),occ02 FROM ',cl_get_target_table(tm.plant[i], 'occ_file'), #FUN-930006    #No.FUN-A30110 #FUN-A50102
                 ' WHERE occ01 = ? '
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
       PREPARE c_occ_p FROM g_sql
       DECLARE c_occ CURSOR FOR c_occ_p
 
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(l_dbs CLIPPED),'oci_file ', #FUN-930006  #FUN-A50102
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm.plant[i], 'oci_file'), #FUN-930006  #FUN-A50102
                 ' WHERE oci01 = ? ',
                 '  AND oci02 = ? ',
                 '  AND oci03 = ? ' CLIPPED
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
       PREPARE c_oci_p FROM g_sql
       DECLARE c_oci CURSOR FOR c_oci_p
 
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(l_dbs CLIPPED),'ocj_file ', #FUN-930006 #FUN-A50102
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm.plant[i], 'ocj_file'), #FUN-930006 #FUN-A50102
                 ' WHERE ocj01 = ? ',
                 '  AND ocj02 = ? ',
                 '  AND ocj03 = ? ' CLIPPED
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
       PREPARE c_ocj_p FROM g_sql
       DECLARE c_ocj CURSOR FOR c_ocj_p
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(l_dbs CLIPPED),'tql_file ', #FUN-930006 #FUN-A50102
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm.plant[i], 'tql_file'), #FUN-930006 #FUN-A50102
                 ' WHERE tql01= ? ',
                 '   AND tql02= ? ',
                 '   AND tql03= ?' CLIPPED
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
       PREPARE c_tql_p FROM g_sql
       DECLARE c_tql CURSOR FOR c_tql_p
 
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(l_dbs CLIPPED),'tqk_file ', #FUN-930006 #FUN-A50102
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm.plant[i], 'tqk_file'), #FUN-930006 #FUN-A50102
                 ' WHERE tqk01 = ? ',
                 '  AND tqk02 = ? ',
                 '  AND tqk03 = ? ' CLIPPED
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
       PREPARE c_tqk_p FROM g_sql
       DECLARE c_tqk CURSOR FOR c_tqk_p
 
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(l_dbs CLIPPED),'tqo_file ', #FUN-930006   #FUN-A50102
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm.plant[i], 'tqo_file'), #FUN-930006   #FUN-A50102
                 ' WHERE tqo01 = ? ',
                 '  AND tqo02 = ? ' CLIPPED
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102             
       PREPARE c_tqo_p FROM g_sql
       DECLARE c_tqo CURSOR FOR c_tqo_p
 
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(l_dbs CLIPPED),'pov_file ', #FUN-930006 #FUN-A50102
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm.plant[i], 'pov_file'), #FUN-930006 #FUN-A50102
                 ' WHERE pov01 = ? ',
                 '  AND pov02 = ? ' CLIPPED
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102             
       PREPARE c_pov_p FROM g_sql
       DECLARE c_pov CURSOR FOR c_pov_p
 
#-------------------- UPDATE FILE.occg_file ------------------------------
   MESSAGE ' COPY FOR THE UPDATE.occg_file .... '  #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE
       FOREACH s_occg INTO l_occg.*
          IF STATUS THEN
             CALL cl_err('foreach occg',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_occg USING l_occg.occg01
          FETCH c_occg INTO l_cnt
          IF l_cnt > 0 THEN
             #LET g_sql='UPDATE ',s_dbstring(l_dbs CLIPPED),'occg_file ',  #FUN-930006 #FUN-A50102
             LET g_sql='UPDATE ',cl_get_target_table(tm.plant[i], 'occg_file'),  #FUN-930006 #FUN-A50102
                       ' SET occg01= ?,',
                           ' occg02= ?,',
                           ' occg03= ?,',
                           ' occg04= ? ',
                       ' WHERE occg01= ? ' CLIPPED
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
             CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102         
             PREPARE u_occg FROM g_sql
             EXECUTE u_occg USING l_occg.occg01,l_occg.occg02,l_occg.occg03,
                                  l_occg.occg04,l_occg.occg01
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                LET g_msg = 'upd ',tm.dbs[i] CLIPPED,':occg'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          ELSE
             #LET g_sql="INSERT INTO ",s_dbstring(l_dbs CLIPPED),"occg_file", #FUN-930006   #FUN-A50102
             LET g_sql="INSERT INTO ",cl_get_target_table(tm.plant[i], 'occg_file'), #FUN-930006   #FUN-A50102
                       "(occg01, occg02, occg03, occg04)",
                       "  VALUES( ?, ?, ?, ?)"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           	 CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102
             PREPARE i_occg_cpy FROM g_sql
             EXECUTE i_occg_cpy USING l_occg.occg01,l_occg.occg02,l_occg.occg03,
                                  l_occg.occg04
             IF STATUS THEN
                 LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':occg'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
             END IF
          END IF
       END FOREACH
 
#-------------------- UPDATE FILE.ocd_file ------------------------------
   MESSAGE ' COPY FOR THE  UPDATE.ocd_file .... '       #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE  I
       FOREACH s_ocd INTO l_ocd.*
          IF STATUS THEN
             CALL cl_err('foreach ocd',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_ocd USING l_ocd.ocd01,l_ocd.ocd02
          FETCH c_ocd INTO l_cnt
          IF l_cnt > 0 THEN
             #LET g_sql='UPDATE ',s_dbstring(l_dbs CLIPPED),'ocd_file ',   #FUN-930006   #FUN-A50102
             LET g_sql='UPDATE ',cl_get_target_table(tm.plant[i], 'ocd_file'),   #FUN-930006   #FUN-A50102
                       ' SET ocd01= ?,',
                           ' ocd02= ?,',
                           ' ocd03= ?,',
                           ' ocd04= ?,',
                            ' ocd221= ?,', #No.MOD-4A0047
                            ' ocd222= ?,', #No.MOD-4A0047
                           ' ocd223= ?,',
                           ' ocd230= ?,',  #FUN-720014 add
                           ' ocd231= ? ',  #FUN-720014 add
                       ' WHERE ocd01= ? ',
                       '  AND  ocd02= ?' CLIPPED
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-A50102
 	           CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
             PREPARE u_ocd FROM g_sql
             EXECUTE u_ocd USING l_ocd.ocd01,l_ocd.ocd02,l_ocd.ocd03,
                                 l_ocd.ocd04,l_ocd.ocd221,l_ocd.ocd222,
                                 l_ocd.ocd223,
                                 l_ocd.ocd230,l_ocd.ocd231,   #FUN-720014 add
                                 l_ocd.ocd01,l_ocd.ocd02
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                LET g_msg = 'upd ',tm.dbs[i] CLIPPED,':ocd'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          ELSE
             #LET g_sql="INSERT INTO ",s_dbstring(l_dbs CLIPPED),"ocd_file",  #FUN-930006  #FUN-A50102
             LET g_sql="INSERT INTO ",cl_get_target_table(tm.plant[i], 'ocd_file'),  #FUN-930006  #FUN-A50102
                       "(ocd01, ocd02, ocd03, ocd04,",
                       " ocd221, ocd222, ocd223,ocd230,ocd231)",   #FUN-720014 add ocd230/231
                       "  VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?)"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
 	           CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102
             PREPARE i_ocd_cpy FROM g_sql
             EXECUTE i_ocd_cpy USING l_ocd.ocd01,l_ocd.ocd02,l_ocd.ocd03,
                                 l_ocd.ocd04,l_ocd.ocd221,l_ocd.ocd222,
                                 l_ocd.ocd223,l_ocd.ocd230,l_ocd.ocd231   #FUN-720014 add ocd230/231
             IF STATUS THEN
                 LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':ocd'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
             END IF
          END IF
       END FOREACH
 
#-------------------- UPDATE FILE.oce_file ------------------------------
   MESSAGE ' COPY FOR THE  UPDATE.oce_file .... '      #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE
       FOREACH s_oce INTO l_oce.*
          IF STATUS THEN
             CALL cl_err('foreach oce',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_oce USING l_oce.oce01,l_oce.oce03
          FETCH c_oce INTO l_cnt
          IF l_cnt > 0 THEN
             #LET g_sql='UPDATE ',s_dbstring(l_dbs CLIPPED),'oce_file ', #FUN-930006    #FUN-A50102
             LET g_sql='UPDATE ',cl_get_target_table(tm.plant[i], 'oce_file'), #FUN-930006    #FUN-A50102
                       ' SET oce01= ?,',
                           ' oce02= ?,',
                           ' oce03= ?,',
                           ' oce04= ?,',
                           ' oce05= ?,',
                           ' oce06= ? ',
                       ' WHERE oce01= ? ',
                       '  AND  oce03= ? ' CLIPPED
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
             CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
             PREPARE u_oce FROM g_sql
             EXECUTE u_oce USING l_oce.oce01,l_oce.oce02,l_oce.oce03,
                                 l_oce.oce04,l_oce.oce05,l_oce.oce06,
                                 l_oce.oce01,l_oce.oce03
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                LET g_msg = 'upd ',tm.dbs[i] CLIPPED,':oce'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          ELSE
             #LET g_sql="INSERT INTO ",s_dbstring(l_dbs CLIPPED),"oce_file ",  #FUN-930006  #FUN-A50102
             LET g_sql="INSERT INTO ",cl_get_target_table(tm.plant[i], 'oce_file'),  #FUN-930006  #FUN-A50102
                       "(oce01, oce02, oce03, oce04, oce05, oce06)",
                       "  VALUES( ?, ?, ?, ?, ?, ?)"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
 	 CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102  
             PREPARE i_oce_cpy FROM g_sql
             EXECUTE i_oce_cpy USING l_oce.oce01,l_oce.oce02,l_oce.oce03,
                                 l_oce.oce04,l_oce.oce05,l_oce.oce06
             IF STATUS THEN
                 LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':oce'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
             END IF
          END IF
       END FOREACH
 
#-------------------- UPDATE FILE.occ_file ------------------------------
   MESSAGE ' COPY FOR THE UPDATE.occ_file .... '       #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE
       FOREACH s_occ INTO l_occ.*
          IF STATUS THEN
             CALL cl_err('foreach occ',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_occ USING l_occ.occ01
         #FETCH c_occ INTO l_cnt           #No.FUN-A30110
          FETCH c_occ INTO l_cnt,l_occ02_t #No.FUN-A30110
          IF l_cnt > 0 THEN
             #LET l_sql='UPDATE ',s_dbstring(l_dbs CLIPPED),'occ_file ',    #FUN-930006 #FUN-A50102
             LET l_sql='UPDATE ',cl_get_target_table(tm.plant[i], 'occ_file'),    #FUN-930006 #FUN-A50102
                       '   SET occ01=?,occ02=?,occ03=?,',
                           'occ04=?,occ05=?,occ06=?,',
                           'occ07=?,occ08=?,occ09=?,',
                           'occ10=?,occ11=?,occ12=?,',
                           'occ13=?,occ14=?,occ15=?,',
                           'occ16=?,occ171=?,occ172=?,',
                           'occ173=?,occ174=?,occ175=?,',
                           'occ18=?, occ19=?,occ22=?, ',
                           'occ21=?,occ20=?,occ231=?,',
                           'occ232=?,occ233=?,occ234=?,occ235=?,occ241=?,',  #FUN-720014 add occ234/235
                           'occ242=?,occ243=?,occ244=?,occ245=?,occ261=?,',  #FUN-720014 add occ244/245
                           'occ262=?,occ263=?,occ271=?,',
                           'occ272=?,occ273=?,occ28=?,',
                           'occ29=?,occ292=?,occ30=?,',
                           'occ302=?,occ31=?,occ32=?,',
                           'occ33=?,occ34=?,occ35=?,',
                           'occ36=?,occ37=?,occ38=?,',
                           'occ39=?,occ39a=?,occ40=?,',
                           'occ41=?,occ42=?,occ43=?,',
                           'occ44=?,occ45=?,occ46=?,',
                           'occ47=?,occ48=?,occ49=?,',
                           'occ50=?,occ51=?,occ52=?,',
                           'occ53=?,occ55=?,',
                           'occ56=?,occ57=?,occ61=?,',
                           'occ62=?,occ63=?,occ631=?,',
                           'occ64=?,occ701=?,occ702=?, ',
                          #'occ1001=?,occ1002=?,occ1003=?,',   #MOD-CC0094 mark
                           'occ1003=?,',                       #MOD-CC0094 add
                           'occ1004=?,occ1006=?,',
                           'occ1007=?,',
                           'occ1008=?,occ1009=?,occ1010=?,',
                           'occ1011=?,occ1014=?,occ1015=?,',
                           'occ1012=?,occ1013=?,occ1016=?,',
                           'occ1017=?,occ1018=?,occ1019=?,',
                           'occ1020=?,occ1021=?,occ1022=?,',
                           'occ1024=?,occ1025=?,',
                           'occ1026=?,occ1027=?,occ1028=?,',
                           'occ703=?,occ704=?,',
                           'occ76=?,occ77=?, ',                     #FUN-B90105 add occ76/77
                           'occacti=?,',
                           'occuser=?,occgrup=?,occmodu=?,',
                           'occdate=?,occ65=? ',  #No.FUN-610020
                           ',occ66=?,occ1005=?,occ68=?,occ69=? ',   #FUN-630027 增加occ66 #FUN-840183 增加occ68,occ69
                       ' WHERE occ01 =? '
            #CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102     #FUN_B80089  MARK
             CALL cl_parse_qry_sql(l_sql, tm.plant[i]) RETURNING l_sql  #FUN-A50102          
             PREPARE u_occ FROM l_sql
             EXECUTE u_occ USING l_occ.occ01, l_occ.occ02, l_occ.occ03,
                                 l_occ.occ04, l_occ.occ05, l_occ.occ06,
                                 l_occ.occ07, l_occ.occ08, l_occ.occ09,
                                 l_occ.occ10, l_occ.occ11, l_occ.occ12,
                                 l_occ.occ13, l_occ.occ14, l_occ.occ15,
                                 l_occ.occ16, l_occ.occ171,l_occ.occ172,
                                 l_occ.occ173,l_occ.occ174,l_occ.occ175,
                                 l_occ.occ18, l_occ.occ19, l_occ.occ22,
                                 l_occ.occ21, l_occ.occ20, l_occ.occ231,
                                 l_occ.occ232,l_occ.occ233,l_occ.occ234,l_occ.occ235,l_occ.occ241,  #FUN-720014 add occ234/235
                                 l_occ.occ242,l_occ.occ243,l_occ.occ244,l_occ.occ245,l_occ.occ261,  #FUN-720014 add occ244/245
                                 l_occ.occ262, l_occ.occ263, l_occ.occ271,
                                 l_occ.occ272, l_occ.occ273, l_occ.occ28,
                                 l_occ.occ29, l_occ.occ292, l_occ.occ30,
                                 l_occ.occ302, l_occ.occ31, l_occ.occ32,
                                 l_occ.occ33, l_occ.occ34, l_occ.occ35,
                                 l_occ.occ36, l_occ.occ37, l_occ.occ38,
                                 l_occ.occ39, l_occ.occ39a, l_occ.occ40,
                                 l_occ.occ41, l_occ.occ42, l_occ.occ43,
                                 l_occ.occ44, l_occ.occ45, l_occ.occ46,
                                 l_occ.occ47, l_occ.occ48, l_occ.occ49,
                                 l_occ.occ50, l_occ.occ51, l_occ.occ52,
                                 l_occ.occ53, l_occ.occ55,
                                 l_occ.occ56, l_occ.occ57, l_occ.occ61,
                                 l_occ.occ62, l_occ.occ63, l_occ.occ631,
                                 l_occ.occ64, l_occ.occ701,l_occ.occ702,
                                #l_occ.occ1001,l_occ.occ1002,l_occ.occ1003,   #MOD-CC0094 mark
                                 l_occ.occ1003,                               #MOD-CC0094 add
                                 l_occ.occ1004,l_occ.occ1006,
                                 l_occ.occ1007,
                                 l_occ.occ1008,l_occ.occ1009,l_occ.occ1010,
                                 l_occ.occ1011,l_occ.occ1014,l_occ.occ1015,
                                 l_occ.occ1012,l_occ.occ1013,l_occ.occ1016,
                                 l_occ.occ1017,l_occ.occ1018,l_occ.occ1019,
                                 l_occ.occ1020,l_occ.occ1021,l_occ.occ1022,
                                 l_occ.occ1024,l_occ.occ1025,
                                 l_occ.occ1026,l_occ.occ1027,l_occ.occ1028,
                                 l_occ.occ703,l_occ.occ704,#l_occ.occ76, l_occ.occ77,                      #FUN-720014 add occ76/77
                                 l_occ.occacti,
                                 l_occ.occuser, l_occ.occgrup, l_occ.occmodu,
                                 l_occ.occdate, l_occ.occ65,
                                 l_occ.occ66,   #FUN-630027 增加l_occ.occ66
                                 l_occ.occ1005, #FUN-630027 增加l_occ.occ66
                                 l_occ.occ68,   #FUN-840183 增加l_occ.occ68
                                 l_occ.occ69,   #FUN-840183 增加l_occ.occ69
                                 l_occ.occ01  #No.FUN-610020
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                LET g_msg = 'upd ',tm.dbs[i] CLIPPED,':occ'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             #No.FUN-A30110  --Begin
             IF NOT (l_occ.occ01 MATCHES 'MISC*' OR l_occ.occ01 MATCHES 'EMPL*') THEN   #No.TQC-BB0002 
                IF l_occ02_t <> l_occ.occ02 THEN
                   CALL s_showmsg_init()
                   #CALL s_upd_abbr(l_occ.occ01,l_occ.occ02,l_dbs,'2','Y')
                   CALL s_upd_abbr(l_occ.occ01,l_occ.occ02,tm.plant[i],'2','Y','u') #FUN-A50102
                   IF g_success = 'N' THEN
                      CALL s_showmsg()
                      EXIT FOREACH
                   END IF
                END IF
             END IF   #No.TQC-BB0002 
             #No.FUN-A30110  --End  
          ELSE
             #LET g_sql="INSERT INTO ",s_dbstring(l_dbs CLIPPED),"occ_file ",   #FUN-930006 #FUN-A50102
             LET g_sql="INSERT INTO ",cl_get_target_table(tm.plant[i], 'occ_file'),   #FUN-930006 #FUN-A50102
                       "( occ01,occ02,occ03,",
                         "occ04,occ05,occ06,",
                         "occ07,occ08,occ09,",
                         "occ10,occ11,occ12,",
                         "occ13,occ14,occ15,",
                         "occ16,occ171,occ172,",
                         "occ173,occ174,occ175,",
                         "occ18, occ19,occ20,",
                         "occ21,occ22,occ231,",
                         "occ232,occ233,occ234,occ235,occ241,",  #FUN-720014 add occ234/235
                         "occ242,occ243,occ244,occ245,occ261,",  #FUN-720014 add occ244/245
                         "occ262,occ263,occ271,",
                         "occ272,occ273,occ28,",
                         "occ29,occ292,occ30,",
                         "occ302,occ31,occ32,",
                         "occ33,occ34,occ35,",
                         "occ36,occ37,occ38,",
                         "occ39,occ39a,occ40,",
                         "occ41,occ42,occ43,",
                         "occ44,occ45,occ46,",
                         "occ47,occ48,occ49,",
                         "occ50,occ51,occ52,",
                         "occ53,occ55,",
                         "occ56,occ57,occ61,",
                         "occ62,occ63,occ631,",
                         "occ64,occ701,occ702,",
                         "occ703,occ704,occ76,occ77,occacti,",      #FUN-B90105 add  occ76/77
#                        "occ703,occ704,occacti,",      #FUN-B90105 add  occ76/77
                         "occuser,occgrup,occmodu,",
                         "occdate,occ68,occ69,occoriu,occorig)",    #FUN-A10036                        #FUN-840813 ADD occ68,occ69
                       "  VALUES ( ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",  #No.TQC-7B0163
                               " ?, ?, ? ,",  #No.TQC-7B0163
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?, ?, ? ,",
                               " ?,?,?,?,?)"   #FUN-A10036
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
 	           CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102
             PREPARE i_occ_cpy FROM g_sql
             EXECUTE i_occ_cpy USING l_occ.occ01, l_occ.occ02, l_occ.occ03,
                                 l_occ.occ04, l_occ.occ05, l_occ.occ06,
                                 l_occ.occ07, l_occ.occ08, l_occ.occ09,
                                 l_occ.occ10, l_occ.occ11, l_occ.occ12,
                                 l_occ.occ13, l_occ.occ14, l_occ.occ15,
                                 l_occ.occ16, l_occ.occ171,l_occ.occ172,
                                 l_occ.occ173,l_occ.occ174,l_occ.occ175,
                                 l_occ.occ18, l_occ.occ19, l_occ.occ20,
                                 l_occ.occ21, l_occ.occ22, l_occ.occ231,
                                 l_occ.occ232,l_occ.occ233,l_occ.occ234,l_occ.occ235,l_occ.occ241,  #FUN-720014 add occ234/235
                                 l_occ.occ242,l_occ.occ243,l_occ.occ244,l_occ.occ245,l_occ.occ261,  #FUN-720014 add occ244/245
                                 l_occ.occ262, l_occ.occ263, l_occ.occ271,
                                 l_occ.occ272, l_occ.occ273, l_occ.occ28,
                                 l_occ.occ29, l_occ.occ292, l_occ.occ30,
                                 l_occ.occ302, l_occ.occ31, l_occ.occ32,
                                 l_occ.occ33, l_occ.occ34, l_occ.occ35,
                                 l_occ.occ36, l_occ.occ37, l_occ.occ38,
                                 l_occ.occ39, l_occ.occ39a, l_occ.occ40,
                                 l_occ.occ41, l_occ.occ42, l_occ.occ43,
                                 l_occ.occ44, l_occ.occ45, l_occ.occ46,
                                 l_occ.occ47, l_occ.occ48, l_occ.occ49,
                                 l_occ.occ50, l_occ.occ51, l_occ.occ52,
                                 l_occ.occ53, l_occ.occ55,
                                 l_occ.occ56, l_occ.occ57, l_occ.occ61,
                                 l_occ.occ62, l_occ.occ63, l_occ.occ631,
                                 l_occ.occ64, l_occ.occ701,l_occ.occ702,
                                 l_occ.occ703,l_occ.occ704,l_occ.occ76,l_occ.occ77,l_occ.occacti,    #FUN-B90105 add occ76/77
#                                 l_occ.occ703,l_occ.occ704,l_occ.occacti,    #FUN-B90105 add occ76/77
                                 l_occ.occuser, l_occ.occgrup, l_occ.occmodu,
                                 l_occ.occdate,l_occ.occ68,l_occ.occ69,g_user,g_grup #FUN-A10036                              #FUN-840813 ADD occ68,occ69
              IF STATUS THEN
                 LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':occ'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
              END IF
              CALL s_upd_abbr(l_occ.occ01,l_occ.occ02,tm.plant[i],'2','Y','a')    #No.FUN-BB0049
              IF g_success = 'N' THEN
                 CALL s_showmsg()     #No.FUN-BB0049
                 LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':occ'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 EXIT FOR
              END IF
          END IF
       END FOREACH
 
#-------------------- UPDATE FILE.oci_file ------------------------------
   MESSAGE ' COPY FOR THE UPDATE.oci_file .... '     #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE
       FOREACH s_oci INTO l_oci.*
          IF STATUS THEN
             CALL cl_err('foreach oci',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_oci USING l_oci.oci01,l_oci.oci02,l_oci.oci03
          FETCH c_oci INTO l_cnt
          IF l_cnt > 0 THEN
             #LET g_sql='UPDATE ',s_dbstring(l_dbs CLIPPED),'oci_file ', #FUN-930006   #FUN-A50102
             LET g_sql='UPDATE ',cl_get_target_table(tm.plant[i], 'oci_file'), #FUN-930006   #FUN-A50102
                       ' SET oci01= ?,',
                           ' oci02= ?,',
                           ' oci03= ?,',
                           ' oci11= ?,',
                           ' oci12= ?,',
                           ' oci13= ?,',
                           ' oci14= ?,',
                           ' oci15= ?,',
                           ' oci16= ?,',
                           ' oci17= ?,',
                           ' oci18= ?,',
                           ' oci19= ?,',
                           ' oci20= ? ',
                       ' WHERE oci01= ? ',
                       '  AND  oci02= ? ',
                       '  AND  oci03= ? ' CLIPPED
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
             CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
             PREPARE u_oci FROM g_sql
             EXECUTE u_oci USING l_oci.oci01,l_oci.oci02,l_oci.oci03,
                                 l_oci.oci11,l_oci.oci12,l_oci.oci13,
                                 l_oci.oci14,l_oci.oci15,l_oci.oci16,
                                 l_oci.oci17,l_oci.oci18,l_oci.oci19,
                                 l_oci.oci20,
                                 l_oci.oci01,l_oci.oci02,l_oci.oci03
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                LET g_msg = 'upd ',tm.dbs[i] CLIPPED,':oci'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          ELSE
             #LET g_sql="INSERT INTO ",s_dbstring(l_dbs CLIPPED),"oci_file ",   #FUN-930006 #FUN-A50102
             LET g_sql="INSERT INTO ",cl_get_target_table(tm.plant[i], 'oci_file'),   #FUN-930006 #FUN-A50102
                       "(oci01, oci02, oci03, oci11, oci12, oci13, oci14,",
                       " oci15, oci16, oci17, oci18, oci19, oci20)",
                       " VALUES( ?, ?, ?, ?, ?, ?, ?, ",
                               " ?, ?, ?, ?, ?, ? )"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
 	           CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102
             PREPARE i_oci_cpy FROM g_sql
             EXECUTE i_oci_cpy USING l_oci.oci01,l_oci.oci02,l_oci.oci03,
                                 l_oci.oci11,l_oci.oci12,l_oci.oci13,
                                 l_oci.oci14,l_oci.oci15,l_oci.oci16,
                                 l_oci.oci17,l_oci.oci18,l_oci.oci19,
                                 l_oci.oci20
             IF STATUS THEN
                 LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':oci'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
             END IF
          END IF
       END FOREACH
 
#-------------------- UPDATE FILE.ocj_file ------------------------------
   MESSAGE ' COPY FOR THE  UPDATE.ocj_file .... '     #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE
       FOREACH s_ocj INTO l_ocj.*
          IF STATUS THEN
             CALL cl_err('foreach oci',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_ocj USING l_ocj.ocj01,l_ocj.ocj02,l_ocj.ocj03
          FETCH c_ocj INTO l_cnt
          IF l_cnt > 0 THEN
             #LET g_sql='UPDATE ',s_dbstring(l_dbs CLIPPED),'ocj_file ',  #FUN-930006 #FUN-A50102
             LET g_sql='UPDATE ',cl_get_target_table(tm.plant[i], 'ocj_file'),  #FUN-930006 #FUN-A50102
                       ' SET ocj01= ?,',
                           ' ocj02= ?,',
                           ' ocj03= ?,',
                           ' ocjacti= ? ',
                       ' WHERE ocj01= ? ',
                       '  AND  ocj02= ? ',
                       '  AND  ocj03= ? ' CLIPPED
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
             CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
             PREPARE u_ocj FROM g_sql
             EXECUTE u_ocj USING l_ocj.ocj01,l_ocj.ocj02,l_ocj.ocj03,
                                 l_ocj.ocjacti,
                                 l_ocj.ocj01,l_ocj.ocj02,l_ocj.ocj03
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                LET g_msg = 'upd ',tm.dbs[i] CLIPPED,':ocj'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          ELSE
             #LET g_sql="INSERT INTO ",s_dbstring(l_dbs CLIPPED),"ocj_file ",   #FUN-930006 #FUN-A50102 
             LET g_sql="INSERT INTO ",cl_get_target_table(tm.plant[i], 'ocj_file'),   #FUN-930006 #FUN-A50102 
                       "(ocj01, ocj02, ocj03, ocjacti )",
                       "  VALUES( ?, ?, ?, ?)"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
 	           CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102
             PREPARE i_ocj_cpy FROM g_sql
             EXECUTE i_ocj_cpy USING l_ocj.ocj01,l_ocj.ocj02,l_ocj.ocj03,
                                 l_ocj.ocjacti
             IF STATUS THEN
                 LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':ocj'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
             END IF
          END IF
       END FOREACH
#-------------------- UPDATE FILE.tql_file ------------------------------
   MESSAGE ' COPY FOR THE UPDATE .tql_file .... '   #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE
       FOREACH s_tql INTO l_tql.*
          IF STATUS THEN
             CALL cl_err('foreach tql',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_tql USING l_tql.tql01,l_tql.tql02,l_tql.tql03
          FETCH c_tql INTO l_cnt
          IF l_cnt > 0 THEN
             #LET g_sql='UPDATE ',s_dbstring(l_dbs CLIPPED),'tql_file ',        #FUN-930006 #FUN-A50102
             LET g_sql='UPDATE ',cl_get_target_table(tm.plant[i], 'tql_file'),        #FUN-930006 #FUN-A50102
                       ' SET tql01= ?,',
                           ' tql02= ?,',
                           ' tql03= ?,',
                           ' tql04= ? ',
                       ' WHERE tql01= ? AND tql02=? AND tql03=? ' CLIPPED
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
             CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102           
             PREPARE u_tql FROM g_sql
             EXECUTE u_tql USING l_tql.tql01,l_tql.tql02,l_tql.tql03,
                                 l_tql.tql04,l_tql.tql01,l_tql.tql02,l_tql.tql03
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                LET g_msg = 'upd ',tm.dbs[i] CLIPPED,':tql'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          END IF
       END FOREACH
#-------------------- UPDATE FILE.tqk_file ------------------------------
   MESSAGE ' COPY FOR THE UPDATE .tqk_file .... '      #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE
       FOREACH s_tqk INTO l_tqk.*
          IF STATUS THEN
             CALL cl_err('foreach tqk',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_tqk USING l_tqk.tqk01,l_tqk.tqk02,l_tqk.tqk03
          FETCH c_tqk INTO l_cnt
          IF l_cnt > 0 THEN
             #LET g_sql='UPDATE ',s_dbstring(l_dbs CLIPPED),'tqk_file ',  #FUN-930006 #FUN-A50102
             LET g_sql='UPDATE ',cl_get_target_table(tm.plant[i], 'tqk_file'),  #FUN-930006 #FUN-A50102
                       ' SET tqk01= ?,',
                           ' tqk02= ?,',
                           ' tqk03= ?,',
                           ' tqk04= ?,',
                           ' tqk05= ?,',
                           ' tqk06= ?,',
                           ' tqk07= ?,',
                           ' tqkacti= ?,',
                           ' tqkuser= ?,',
                           ' tqkgrup= ?,',
                           ' tqkmodu= ?,',
                           ' tqkdate= ? ',
                       ' WHERE tqk01= ? ',
                       '  AND  tqk02= ? ',
                       '  AND  tqk03= ? ' CLIPPED
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
             CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
             PREPARE u_tqk FROM g_sql
             EXECUTE u_tqk USING l_tqk.tqk01,l_tqk.tqk02,l_tqk.tqk03,
                                 l_tqk.tqk04,l_tqk.tqk05,l_tqk.tqk06,
                                 l_tqk.tqk07,
                                 l_tqk.tqkacti,l_tqk.tqkuser,l_tqk.tqkgrup,l_tqk.tqkmodu,l_tqk.tqkdate,
                                 l_tqk.tqk01,l_tqk.tqk02,l_tqk.tqk03
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                LET g_msg = 'upd ',tm.dbs[i] CLIPPED,':tqk'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          ELSE
             #LET g_sql="INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tqk_file ",  #FUN-930006 #FUN-A50102
             LET g_sql="INSERT INTO ",cl_get_target_table(tm.plant[i], 'tqk_file'),  #FUN-930006 #FUN-A50102
                       "(tqk01,tqk02,tqk03,tqk04,tqk05,tqk06,tqk07,",
                       " tqkacti,tqkuser,tqkgrup,tqkmodu,tqkdate,tqkoriu,tqkorig)",  #FUN-A10036
                       "  VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
 	 CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102
             PREPARE i_tqk_cpy FROM g_sql
             EXECUTE i_tqk_cpy USING l_tqk.tqk01,l_tqk.tqk02,l_tqk.tqk03,
                                 l_tqk.tqk04,l_tqk.tqk05,l_tqk.tqk06,
                                 l_tqk.tqk07,
                                 l_tqk.tqkacti,l_tqk.tqkuser,l_tqk.tqkgrup,
                                 l_tqk.tqkmodu,l_tqk.tqkdate,g_user,g_grup #FUN-A10036
             IF STATUS THEN
                 LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':tqk'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
             END IF
          END IF
       END FOREACH
 
#-------------------- UPDATE FILE.tqo_file ------------------------------
   MESSAGE ' COPY FOR THE UPDATE .tqo_file .... '      #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE
       FOREACH s_tqo INTO l_tqo.*
          IF STATUS THEN
             CALL cl_err('foreach tqo',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_tqo USING l_tqo.tqo01,l_tqo.tqo02
          FETCH c_tqo INTO l_cnt
          IF l_cnt > 0 THEN
             #LET g_sql='UPDATE ',s_dbstring(l_dbs CLIPPED),'tqo_file ', #FUN-930006 #FUN-A50102
             LET g_sql='UPDATE ',cl_get_target_table(tm.plant[i], 'tqo_file'), #FUN-930006 #FUN-A50102
                       ' SET tqo01= ?,',
                           ' tqo02= ?,',
                           ' tqoacti= ?,',
                           ' tqouser= ?,',
                           ' tqogrup= ?,',
                           ' tqomodu= ?,',
                           ' tqodate= ? ',
                       ' WHERE tqo01= ? ',
                       '   AND tqo02= ? ' CLIPPED
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
             CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
             PREPARE u_tqo FROM g_sql
             EXECUTE u_tqo USING l_tqo.tqo01,l_tqo.tqo02,
                                 l_tqo.tqoacti,l_tqo.tqouser,l_tqo.tqogrup,l_tqo.tqomodu,l_tqo.tqodate,
                                 l_tqo.tqo01 ,l_tqo.tqo02
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                LET g_msg = 'upd ',tm.dbs[i] CLIPPED,':tqo'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          ELSE
             #LET g_sql="INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tqo_file ",   #FUN-930006 #FUN-A50102
             LET g_sql="INSERT INTO ",cl_get_target_table(tm.plant[i], 'tqo_file'),   #FUN-930006 #FUN-A50102
                       "(tqo01,tqo02,tqoacti,tqouser,tqogrup,tqomodu,tqodate,tqooriu,tqoorig)",  #FUN-A10036
                       "  VALUES( ?, ?, ?, ?, ?, ?, ?,?,?)" #FUN-A10036
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
 	           CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102
             PREPARE i_tqo_cpy FROM g_sql
             EXECUTE i_tqo_cpy USING l_tqo.tqo01,l_tqo.tqo02,
                                 l_tqo.tqoacti,l_tqo.tqouser,l_tqo.tqogrup,l_tqo.tqomodu,l_tqo.tqodate,g_user,g_grup #FUN-A10036
             IF STATUS THEN
                 LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':tqo'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
             END IF
          END IF
       END FOREACH
 
#-------------------- UPDATE FILE.pov_file ------------------------------
   MESSAGE ' COPY FOR THE  UPDATE .pov_file .... '     #FUN-B80089 MOD FOR UPDATE 改为 FOR THE FPDATE
       FOREACH s_pov INTO l_pov.*
          IF STATUS THEN
             CALL cl_err('foreach pov',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_pov USING l_pov.pov01,l_pov.pov02
          FETCH c_pov INTO l_cnt
          IF l_cnt > 0 THEN
             #LET g_sql='UPDATE ',s_dbstring(l_dbs CLIPPED),'pov_file ', #FUN-930006    #FUN-A50102
              LET g_sql='UPDATE ',cl_get_target_table(tm.plant[i], 'pov_file'), #FUN-930006    #FUN-A50102
                       ' SET pov01= ?,',
                           ' pov02= ?,',
                           ' pov03= ?,',
                           ' pov13= ?,',
                           ' pov26= ?,',
                           ' pov15= ?,',
                           ' pov20= ?,',
                           ' pov04= ?,',
                           ' pov12= ?,',
                           ' pov10= ?,',
                           ' pov18= ?,',
                           ' pov22= ?,',
                           ' pov06= ?,',
                           ' pov09= ?,',
                           ' pov25= ?,',
                           ' pov11= ?,',
                           ' pov28= ? ',
                       ' WHERE pov01= ? ',
                       '   AND pov02= ? ' CLIPPED
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
             CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102          
             PREPARE u_pov FROM g_sql
             EXECUTE u_pov USING l_pov.pov01,l_pov.pov02,l_pov.pov03,
                                 l_pov.pov13,l_pov.pov26,l_pov.pov15,
                                 l_pov.pov20,l_pov.pov04,l_pov.pov12,
                                 l_pov.pov10,l_pov.pov18,l_pov.pov22,
                                 l_pov.pov06,l_pov.pov09,l_pov.pov25,
                                 l_pov.pov11,l_pov.pov28,
                                 l_pov.pov01,l_pov.pov02
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                LET g_msg = 'upd ',tm.dbs[i] CLIPPED,':pov'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          ELSE
             #LET g_sql="INSERT INTO ",s_dbstring(l_dbs CLIPPED),"pov_file ", #FUN-930006            #FUN-A50102
             LET g_sql="INSERT INTO ",cl_get_target_table(tm.plant[i], 'pov_file'), #FUN-930006            #FUN-A50102
                       "(pov01,pov02,pov03,pov13,pov26,pov15,pov20,pov04,",
                       " pov12,pov10,pov18,pov22,pov06,pov09,pov25,pov11,",
                       " pov28) ",
                       "VALUES( ?, ?, ?, ?, ?,",
                       "        ?, ?, ?, ?, ?,",
                       "        ?, ?, ?, ?, ?,",
                       "        ?, ?)"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
 	 CALL cl_parse_qry_sql(g_sql, tm.plant[i]) RETURNING g_sql  #FUN-A50102
             PREPARE i_pov_cpy FROM g_sql
             EXECUTE i_pov_cpy USING l_pov.pov01,l_pov.pov02,l_pov.pov03,
                                     l_pov.pov13,l_pov.pov26,l_pov.pov15,
                                     l_pov.pov20,l_pov.pov04,l_pov.pov12,
                                     l_pov.pov10,l_pov.pov18,l_pov.pov22,
                                     l_pov.pov06,l_pov.pov09,l_pov.pov25,
                                     l_pov.pov11,l_pov.pov28
             IF STATUS THEN
                 LET g_msg = 'ins ',tm.dbs[i] CLIPPED,':pov'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
             END IF
          END IF
       END FOREACH
   END FOR
 
END FUNCTION
 
FUNCTION i221_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("occ01",TRUE)
    END IF
 
    IF INFIELD(occ06) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("occ09,occ07",TRUE)
    END IF
    IF INFIELD(occ01) OR NOT g_before_input_done THEN      #No.FUN-A30110
       CALL cl_set_comp_entry("occ02,occ18,occ19",TRUE)
    END IF                                                 #No.FUN-A30110
 
END FUNCTION
 
FUNCTION i221_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
  DEFINE l_cnt   LIKE type_file.num5    #No.FUN-A30110
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("occ01",FALSE)
    END IF
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
        #當參數設定使用客戶申請作業時,修改時不可更改簡稱/全名
        IF g_aza.aza61 = 'Y' THEN #當參數設定使用客戶申請作業時,修改時不可更改簡稱/全名
            CALL cl_set_comp_entry("occ02,occ18,occ19",FALSE)
        END IF
        #No.FUN-A30110  --Begin
        ##確認時不能修改客戶簡稱
        #IF g_occ.occacti = 'Y' THEN
        #    CALL cl_set_comp_entry("occ02",FALSE)
        #END IF
        #No.FUN-A30110  --End  
    END IF
 
    IF INFIELD(occ06) OR ( NOT g_before_input_done ) THEN
       IF g_occ.occ06 MATCHES '[12]' THEN
           CALL cl_set_comp_entry("occ09",FALSE) #MOD-4B0241
       END IF
 
       IF g_occ.occ06 MATCHES '[13]' THEN
           CALL cl_set_comp_entry("occ07",FALSE) #MOD-4B0241
       END IF
       IF g_aza.aza50='Y' AND g_occ.occ06 MATCHES '[1]' THEN
          CALL cl_set_comp_entry("occ07,occ09",TRUE)
       END IF
       IF g_occ.occ06 MATCHES '[4]' THEN
           CALL cl_set_comp_entry("occ1022",FALSE)
       END IF
    END IF

    #No.FUN-BB0049  --Begin
    #IF g_aza.aza125 = 'Y' THEN    #No.FUN-BB0049
    #   #No.FUN-A30110  --Begin
    #   IF p_cmd = 'a' THEN
    #      IF INFIELD(occ01) AND NOT cl_null(g_occ.occ01) THEN
    #         #客户编号和厂商编号相同时,要求简称也要一致,新增时会锁简称字段 
    #         SELECT COUNT(*) INTO l_cnt FROM pmc_file 
    #          WHERE pmc01 = g_occ.occ01
    #         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
    #         IF l_cnt > 0 AND NOT (g_occ.occ01 MATCHES 'MISC*' OR g_occ.occ01 MATCHES 'EMPL*') THEN   #No.TQC-BB0002 
    #            CALL cl_set_comp_entry('occ02',FALSE)
    #         END IF
    #      END IF
    #   END IF
    #   #No.FUN-A30110  --End  
    #END IF                        #No.FUN-BB0049
    #No.FUN-BB0049  --End  
 
END FUNCTION
 
FUNCTION i221_set_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
  IF NOT g_before_input_done OR INFIELD(occ06) THEN
     IF g_occ.occ06 MATCHES '[13]' THEN
        CALL cl_set_comp_required("occ41,occ43,occ44",TRUE) #MOD-5A0173 add
     END IF
  END IF
END FUNCTION
 
FUNCTION i221_set_no_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
  IF NOT g_before_input_done OR INFIELD(occ06) THEN
     CALL cl_set_comp_required("occ41,occ43,occ44",FALSE) #MOD-5A0173 add
  END IF
            IF cl_chk_act_auth() THEN
  END IF
END FUNCTION
 
FUNCTION i221_confirm()
   DEFINE l_occ01      LIKE   occ_file.occ01
   DEFINE l_tqo01      LIKE   tqo_file.tqo01
   DEFINE l_tqk01      LIKE   tqk_file.tqk01
   DEFINE l_n          LIKE type_file.num5    #No.FUN-680137 SMALLINT
   IF (g_occ.occ01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 --------------------- add ------------------------ begin
   IF g_occ.occacti='N' THEN
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occ.occ1004 = '1' THEN  #資料已確認
      CALL cl_err('','9023',1)
      RETURN
   END IF
   IF g_occ.occ1004 !='0' THEN
      #不在開立狀態，不能申請確認
      CALL cl_err('','atm-221',1)
      RETURN
   END IF
   IF NOT cl_confirm('aim-301') THEN RETURN END IF
   SELECT * INTO g_occ.* FROM occ_file WHERE occ01 = g_occ.occ01
#CHI-C30107 --------------------- add ------------------------ end
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
   IF g_occ.occacti='N' THEN
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occ.occ1004 = '1' THEN  #資料已確認
      CALL cl_err('','9023',1)
      RETURN
   END IF
   IF g_occ.occ1004 !='0' THEN
      #不在開立狀態，不能申請確認
      CALL cl_err('','atm-221',1)
      RETURN
   END IF
 
  IF g_occ.occ06 MATCHES '[1]' THEN
     IF g_aza.aza26 = '2' AND g_aza.aza50 ='Y' THEN    #TQC-690035 add   #大陸版才檢查   #No.TQC-740073
        IF cl_null(g_occ.occ1021) THEN
           CALL cl_err(g_occ.occ1021,'atm-051',0)
           RETURN
        END IF
     END IF                       #TQC-690035 add
 
   IF cl_null(g_occ.occ42) THEN
      CALL cl_err(g_occ.occ42,'atm-062',0)
      RETURN
   END IF
 
   IF cl_null(g_occ.occ41) THEN
      CALL cl_err(g_occ.occ41,'atm-063',0)
      RETURN
   END IF
 
   IF cl_null(g_occ.occ08) THEN
      CALL cl_err(g_occ.occ08,'atm-064',0)
      RETURN
   END IF
 
 
   IF g_aza.aza50 = 'Y' THEN #使用流通配銷功能 #FUN-690021 add if 判斷
       IF cl_null(g_occ.occ1022) THEN
          CALL cl_err(g_occ.occ1022,'atm-066',0)
          RETURN
       END IF
       IF cl_null(g_occ.occ1024) THEN
          CALL cl_err(g_occ.occ1024,'atm-068',0)
          RETURN
       END IF
       IF cl_null(g_occ.occ1025) THEN
          CALL cl_err(g_occ.occ1025,'atm-069',0)
          RETURN
       END IF
   END IF
  END IF
 
#  IF NOT cl_confirm('aim-301') THEN RETURN END IF    #是否確定執行確認(Y/N)?  #CHI-C30107 mark

   LET g_success = 'Y'                                #FUN-9A0056  add

   BEGIN WORK
 
   OPEN i221_cl USING g_occ.occ01
   IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 1)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i221_cl INTO g_occ.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      CLOSE i221_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
   CALL i221_show()
   LET g_occ.occ1004 = '1'
   LET g_occ.occacti = 'Y'
   UPDATE occ_file
      SET occ1004=g_occ.occ1004,
          occacti=g_occ.occacti
    WHERE occ01 = g_occ.occ01
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      LET g_success = 'N'                                                  #FUN-9A0056 add
     #ROLLBACK WORK               #FUN-9A0056 mark
 
   #FUN-9A0056 mark str -----
   #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
   ##FUN-870101---add---str---
   #  ELSE
   #     # CALL aws_mescli()
   #     # 傳入參數: (1)程式代號
   #     #           (2)功能選項：insert(新增),update(修改),delete(刪除)
   #     #           (3)Key
   #     CASE aws_mescli('axmi221','insert',g_occ.occ01)
   #        WHEN 0  #無與 MES 整合
   #             MESSAGE 'INSERT O.K'
   #        WHEN 1  #呼叫 MES 成功
   #             MESSAGE 'INSERT O.K, INSERT MES O.K'
   #        WHEN 2  #呼叫 MES 失敗
   #             RETURN FALSE
   #     END CASE
   ##FUN-870101---add---end---
   #END IF #TQC-8B0011 ADD
   #FUN-9A0056 mark end ------
   END IF

  #FUN-9A0056 add str --
   IF g_success ='Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
      CALL i221_mes('insert',g_occ.occ01)
   END IF
  #FUN-9A0056 add end--

  CLOSE i221_cl
  CALL i221_list_fill()  #No.FUN-7C0010

  #FUN-9A0056 add str--
   IF g_success = 'N' THEN
     ROLLBACK WORK
     RETURN
   ELSE
     COMMIT WORK
   END IF
  #FUN-9A0056 add end--

 #COMMIT WORK   #FUN-9A0056 mark

  SELECT * INTO g_occ.* FROM occ_file where occ01=g_occ.occ01 #FUN-690021--add
  CALL i221_show()
END FUNCTION
 
FUNCTION i221_unconfirm()
   DEFINE l_occ01 LIKE occ_file.occ01
   DEFINE l_cnt   LIKE type_file.num5   #FUN-A50078   
    
   IF (g_occ.occ01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
   IF g_occ.occacti='N' THEN
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   #非審核狀態 不能取消審核
   IF g_occ.occ1004!='1' THEN #FUN-690021-mod
      CALL  cl_err('','atm-053',1)
      RETURN
   END IF

   #FUN-A50078----add----str--------------
   #已存在訂單資料，客戶不可取消確認 
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt
     FROM oea_file
   WHERE oea03 = g_occ.occ01
   IF l_cnt > 0 THEN
      CALL cl_err('','apm-513',1)
      RETURN
   END IF

   #已存在出貨單資料，客戶不可取消確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM oga_file
   WHERE oga03 = g_occ.occ01
   IF l_cnt > 0 THEN
      CALL cl_err('','apm-514',1)
      RETURN
   END IF
   #FUN-A50078----add----end----------------   
 
   IF NOT cl_confirm('aim-302') THEN RETURN END IF    #lyl
   LET g_success = 'Y'  #FUN-9A0056 add
   BEGIN WORK
 
   OPEN i221_cl USING g_occ.occ01
   IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 1)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i221_cl INTO g_occ.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      CLOSE i221_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
   CALL i221_show()
   UPDATE occ_file
      SET occ1004='0',
          occacti='P'
    WHERE occ01 = g_occ.occ01
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
     #ROLLBACK WORK          #FUN-9A0056 mark
      LET g_success = 'N'    #FUN-9A0056 add
   END IF

  #FUN-9A0056 add begin --------
  #反確認的資料要傳送刪除MES
   IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
      CALL i221_mes('delete',g_occ.occ01)
   END IF
  #FUN-9A0056 add end ------

  CLOSE i221_cl
  CALL i221_list_fill()  #No.FUN-7C0010

  #FUN-9A0056 add begin ----
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   ELSE
     COMMIT WORK
   END IF
  #FUN-9A0056 add end ------

 #COMMIT WORK     #FUN-9A0056 mark

  SELECT * INTO g_occ.* FROM occ_file where occ01=g_occ.occ01 #FUN-690021--add
  CALL i221_show()
END FUNCTION
 
FUNCTION i221_hang()
   DEFINE l_occ01 LIKE occ_file.occ01
 
   IF cl_null(g_occ.occ01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
   IF g_occ.occacti='N' THEN
      #本筆資料無效
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occ.occacti !='Y' THEN
      #不在確認狀態，不可異動！
      CALL cl_err('','atm-053',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('atm-236') THEN RETURN END IF    #確定要留置?
 
   #FUN-BC0065 add str -------
   #若有與CRM整合,執行"置留"動作時，需即時通知CRM系統
    IF g_aza.aza123 MATCHES "[Yy]" THEN
       CALL aws_crmcli('axmi221','hang','',g_occ.occ01,'') RETURNING g_crmStatus,g_crmDesc
       IF g_crmStatus <> 0 THEN
          CALL cl_err(g_crmDesc,'!',1)
          RETURN
       END IF
    END IF
   #FUN-BC0065 add end -------

   BEGIN WORK
 
   OPEN i221_cl USING g_occ.occ01
   IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 1)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i221_cl INTO g_occ.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      CLOSE i221_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
   CALL i221_show()
   LET g_occ_t.* = g_occ.*
   UPDATE occ_file
      SET occ1004='2', #留置
          occacti='H'
    WHERE occ01 = g_occ.occ01
   IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       ROLLBACK WORK
       LET g_occ.occ1004 = g_occ_t.occ1004
       LET g_occ.occacti = g_occ_t.occacti
       DISPLAY BY NAME g_occ.occ1004,g_occ.occacti
    END IF
    CLOSE i221_cl
    CALL i221_list_fill()  #No.FUN-7C0010
    COMMIT WORK
    SELECT * INTO g_occ.* FROM occ_file where occ01=g_occ.occ01 #FUN-690021--add
    CALL i221_show()
END FUNCTION
 
FUNCTION i221_unhang()
   DEFINE l_occ01 LIKE occ_file.occ01
 
   IF (g_occ.occ01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
   IF g_occ.occacti='N' THEN
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occ.occ1004 !='2' THEN
      #不在留置狀態，不可異動！
      CALL cl_err('','atm-054',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('atm-237') THEN RETURN END IF    #確定取消留置?

  #FUN-BC0065 add str -------
  #若有與CRM整合,執行"取消置留"動作時，需即時通知CRM系統
   IF g_aza.aza123 MATCHES "[Yy]" THEN
      CALL aws_crmcli('axmi221','unhang','',g_occ.occ01,'') RETURNING g_crmStatus,g_crmDesc
      IF g_crmStatus <> 0 THEN
         CALL cl_err(g_crmDesc,'!',1)
         RETURN
      END IF
   END IF
  #FUN-BC0065 add end -------

   BEGIN WORK
 
   OPEN i221_cl USING g_occ.occ01
   IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 1)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i221_cl INTO g_occ.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      CLOSE i221_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
   CALL i221_show()
   LET g_chr=g_occ.occ1004
   LET g_occ_t.* = g_occ.*
   UPDATE occ_file
      SET occ1004='1', #確認
          occacti='Y'
    WHERE occ01 = g_occ.occ01
   IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       ROLLBACK WORK
       LET g_occ.occ1004=g_occ_t.occ1004
       LET g_occ.occacti=g_occ_t.occacti
       DISPLAY BY NAME g_occ.occ1004,g_occ.occacti
   END IF
   CLOSE i221_cl
   CALL i221_list_fill()  #No.FUN-7C0010
   COMMIT WORK
   SELECT * INTO g_occ.* FROM occ_file where occ01=g_occ.occ01 #FUN-690021--add
   CALL i221_show()
END FUNCTION
 
FUNCTION i221_untransaction() #停止交易
   DEFINE l_occ01 LIKE occ_file.occ01
 
   IF (g_occ.occ01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
   IF g_occ.occacti='N' THEN
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occ.occacti != 'Y' THEN
      #不在確認狀態，不可異動！
      CALL cl_err('','atm-053',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('atm-055') THEN RETURN END IF    #是否停止交易？

  #FUN-BC0065 add str -------
  #若有與CRM整合,執行"停止交易"動作時，需即時通知CRM系統
   IF g_aza.aza123 MATCHES "[Yy]" THEN
      CALL aws_crmcli('axmi221','untransaction','',g_occ.occ01,'') RETURNING g_crmStatus,g_crmDesc
      IF g_crmStatus <> 0 THEN
         CALL cl_err(g_crmDesc,'!',1)
         RETURN
      END IF
   END IF
  #FUN-BC0065 add end -------

   BEGIN WORK
 
   OPEN i221_cl USING g_occ.occ01
   IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 1)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i221_cl INTO g_occ.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      CLOSE i221_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
   CALL i221_show()
   LET g_occ_t.* = g_occ.*
   UPDATE occ_file
      SET occ1004='3',#停上交易
          occacti='H'
    WHERE occ01 = g_occ.occ01
   IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       ROLLBACK WORK
       LET g_occ.* = g_occ_t.*
       DISPLAY BY NAME g_occ.occ1004,g_occ.occacti
   END IF

  #FUN-CC0080---add---S
   LET g_msg=TIME
   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
      VALUES ('axmi221',g_user,g_today,g_msg,g_occ.occ01,'untransaction',g_plant,g_legal)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","azo_file","axmi221","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
  #FUN-CC0080---add---E

   CLOSE i221_cl
   CALL i221_list_fill()  #No.FUN-7C0010
   COMMIT WORK
   SELECT * INTO g_occ.* FROM occ_file where occ01=g_occ.occ01 #FUN-690021--add
   CALL i221_show()
END FUNCTION
 
FUNCTION i221_transaction() #恢復交易
   DEFINE l_occ01 LIKE occ_file.occ01
 
   IF (g_occ.occ01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
   IF g_occ.occacti='N' THEN
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occ.occ1004!='3' THEN
      #不在停止交易狀態，不可異動！
      CALL cl_err('','atm-057',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('atm-056') THEN RETURN END IF    #lyl

  #FUN-BC0065 add str -------
  #若有與CRM整合,執行"恢復交易"動作時，需即時通知CRM系統
   IF g_aza.aza123 MATCHES "[Yy]" THEN
      CALL aws_crmcli('axmi221','transaction','',g_occ.occ01,'') RETURNING g_crmStatus,g_crmDesc
      IF g_crmStatus <> 0 THEN
         CALL cl_err(g_crmDesc,'!',1)
         RETURN
      END IF
   END IF
  #FUN-BC0065 add end -------

   BEGIN WORK
 
   OPEN i221_cl USING g_occ.occ01
   IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 1)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i221_cl INTO g_occ.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      CLOSE i221_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
      RETURN
   END IF
   CALL i221_show()
   LET g_occ_t.* = g_occ.*
   UPDATE occ_file
      SET occ1004='1',#恢復交易
          occacti='Y'
    WHERE occ01 = g_occ.occ01
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       ROLLBACK WORK
       LET g_occ.* = g_occ_t.*
       DISPLAY BY NAME g_occ.occ1004,g_occ.occacti
   END IF

  #FUN-CC0080---add---S
   LET g_msg=TIME
   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
      VALUES ('axmi221',g_user,g_today,g_msg,g_occ.occ01,'transaction',g_plant,g_legal)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","azo_file","axmi221","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
  #FUN-CC0080---add---E

   CLOSE i221_cl
   CALL i221_list_fill()  #No.FUN-7C0010
   COMMIT WORK
   SELECT * INTO g_occ.* FROM occ_file where occ01=g_occ.occ01 #FUN-690021--add
   CALL i221_show()
END FUNCTION
 
 
#經營品類、經營系列
FUNCTION i221_8(p_occ01,p_tql03)
   DEFINE l_tql DYNAMIC ARRAY OF RECORD
                tql02 LIKE tql_file.tql02,
                tql04 LIKE tql_file.tql04,
                tqa02 LIKE tqa_file.tqa02
                END RECORD,
        l_tql_t RECORD
                tql02 LIKE tql_file.tql02,
                tql04 LIKE tql_file.tql04,
                tqa02 LIKE tqa_file.tqa02
                END RECORD,
        l_occ1004   LIKE occ_file.occ1004,
        l_occacti   LIKE occ_file.occacti,
        l_allow_insert    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
        l_allow_delete    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
        p_cmd             LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
        l_rec_b           LIKE type_file.num5,    #No.FUN-680137 SMALLINT
        p_occ01           LIKE occ_file.occ01,
        p_tql03           LIKE tql_file.tql03,
        i,l_ac,l_ac_t,l_n LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
   IF cl_null(p_occ01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
 
   LET p_row = 11 LET p_col = 3
   OPEN WINDOW i221_8_w AT p_row,p_col WITH FORM "axm/42f/axmi221_8"
     ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("axmi221_8")
   IF p_tql03 = '3' THEN
      CALL cl_set_comp_att_text("tql04",cl_getmsg('atm-058',g_lang))
   END IF
   LET g_sql = " SELECT tql02,tql04,tqa02 ",
               "   FROM tql_file,tqa_file ",
               "  WHERE tql01 = '",p_occ01,"' ",
               "    AND tql03 = '",p_tql03,"' ",
               "    AND tql04 = tqa01 ",
               "    AND tql03 = tqa03 ",
               "  ORDER BY tql02 "
   PREPARE i221_8_pb FROM g_sql
   DECLARE tql_curs CURSOR FOR i221_8_pb
   CALL l_tql.clear()
   LET i = 1
   LET l_rec_b = 0
   FOREACH tql_curs INTO l_tql[i].*
      IF STATUS THEN
         CALL cl_err('foreach tql',STATUS,0)
         EXIT FOREACH
      END IF
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL l_tql.deleteElement(i)
   LET l_rec_b = i-1
   DISPLAY l_rec_b TO FORMONLY.cn2
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY l_tql TO s_tql.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         LET l_ac = ARR_CURR()
 
 
      ON ACTION accept
 
          SELECT occacti INTO l_occacti
            FROM occ_file
           WHERE occ01=p_occ01
          IF l_occacti='N' THEN
             CALL cl_err('','mfg0301',1)
             RETURN
          END IF
 
         #判斷若客戶已審核則不允許進入單身進行相應的動作               051024
          SELECT occ1004 INTO l_occ1004
            FROM occ_file
           WHERE occ01=p_occ01
           IF l_occ1004!='0' THEN #FUN-690021
              #非開立狀態，不可異動！
              CALL cl_err(p_occ01,'atm-046',1)
              RETURN
           END IF
 
 
          CALL cl_set_act_visible("accept,cancel", TRUE)
          LET g_forupd_sql = " SELECT tql02,tql04,tqa02 ",
                             "   FROM tql_file,tqa_file ",
                             "  WHERE tql01 = ?  ",
                             "   AND tql02 = ? ",
                             "   AND tql03 = ? ",
                             "   AND tql04 = tqa01 ",
                             "   AND tql03 = tqa03 ",
                             " ORDER by tql02 ",
                             " FOR UPDATE "
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

         DECLARE i221_8_bc1 CURSOR FROM g_forupd_sql
         LET l_allow_insert = cl_detail_input_auth("insert")
         LET l_allow_delete = cl_detail_input_auth("delete")
         INPUT ARRAY l_tql WITHOUT DEFAULTS FROM s_tql.*
            ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
 
            IF l_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
         BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            BEGIN WORK
            IF l_rec_b >= l_ac THEN
               LET p_cmd = 'u'
               LET l_tql_t.* = l_tql[l_ac].*
               OPEN i221_8_bc1 USING p_occ01,l_tql_t.tql02,p_tql03
               IF STATUS THEN
                  CALL cl_err("OPEN i221_8_bc1:", STATUS, 1)
               ELSE
                  FETCH i221_8_bc1 INTO l_tql[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(l_tql_t.tql02,SQLCA.sqlcode,1)
                  END IF
               END IF
            END IF
 
         BEFORE INSERT
            LET p_cmd = 'a'
            INITIALIZE l_tql[l_ac].* TO NULL
            LET l_tql_t.* = l_tql[l_ac].*
            NEXT FIELD tql02
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO tql_file(tql01,tql02,tql03,tql04)
               VALUES(p_occ01,l_tql[l_ac].tql02,p_tql03,
                                    l_tql[l_ac].tql04)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","tql_file",p_occ01,l_tql[l_ac].tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  DISPLAY l_rec_b TO FORMONLY.cn2
                  COMMIT WORK
               END IF
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_tql[l_ac].* = l_tql_t.*
               CLOSE i221_8_bc1
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            UPDATE tql_file SET tql02 = l_tql[l_ac].tql02,
                                tql04 = l_tql[l_ac].tql04
                            WHERE tql01 = p_occ01
                              AND tql02 = l_tql_t.tql02
                              AND tql03 = p_tql03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tql_file",p_occ01,l_tql_t.tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET l_tql[l_ac].* = l_tql_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET l_tql[l_ac].* = l_tql_t.*
               END IF
               CLOSE i221_8_bc1
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i221_8_bc1
            COMMIT WORK
 
         BEFORE DELETE                            #是否取消單身
            IF l_tql_t.tql02 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               DELETE FROM tql_file
                WHERE tql01 = p_occ01
                  AND tql02 = l_tql_t.tql02
                  AND tql03 = p_tql03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","tql_file",p_occ01,l_tql_t.tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  EXIT INPUT
               END IF
               LET l_rec_b=l_rec_b-1
               DISPLAY l_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
         BEFORE FIELD tql02
            IF cl_null(l_tql[l_ac].tql02) OR l_tql[l_ac].tql02 = 0 THEN
               SELECT MAX(tql02)+1 INTO l_tql[l_ac].tql02
                 FROM tql_file
                WHERE tql01 = p_occ01
                  AND tql03 = p_tql03
               IF cl_null(l_tql[l_ac].tql02) THEN
                  LET l_tql[l_ac].tql02 = 1
               END IF
            END IF
 
         AFTER FIELD tql02
            IF NOT cl_null(l_tql[l_ac].tql02) THEN
               IF l_tql[l_ac].tql02 != l_tql_t.tql02
                             OR cl_null(l_tql_t.tql02) THEN
                  SELECT COUNT(*) INTO l_n
                    FROM tql_file
                   WHERE tql01 = p_occ01
                     AND tql02 = l_tql[l_ac].tql02
                     AND tql03 = p_tql03
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET l_tql[l_ac].tql02 = l_tql_t.tql02
                     NEXT FIELD tql02
                  END IF
               END IF
            END IF
 
         AFTER FIELD tql04
            IF NOT cl_null(l_tql[l_ac].tql04) THEN
               SELECT COUNT(*) INTO l_n FROM tqa_file
                WHERE tqa01 = l_tql[l_ac].tql04
                  AND tqa03 = p_tql03
               IF l_n = 0 THEN
                  IF p_tql03 = '1' THEN
                     CALL cl_err('','atm-059',0)
                  END IF
                  IF p_tql03 = '3' THEN
                     CALL cl_err('','atm-060',0)
                  END IF
                  NEXT FIELD tql04
               END IF
               IF (p_cmd = 'u' AND l_tql[l_ac].tql04 != l_tql_t.tql04 )
                                OR p_cmd = 'a' THEN
                  SELECT COUNT(*) INTO l_n FROM tql_file
                   WHERE tql01 = p_occ01
                     AND tql03 = p_tql03
                     AND tql04 = l_tql[l_ac].tql04
                  IF l_n > 0 THEN
                     CALL cl_err('','axm-298',0)
                     NEXT FIELD tql04
                  END IF
               END IF
               SELECT tqa02 INTO l_tql[l_ac].tqa02
                 FROM tqa_file
                WHERE tqa01 = l_tql[l_ac].tql04
                  AND tqa03 = p_tql03
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(tql04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = p_tql03
                  LET g_qryparam.default1 = l_tql[l_ac].tql04
                  CALL cl_create_qry() RETURNING l_tql[l_ac].tql04
                  DISPLAY BY NAME l_tql[l_ac].tql04
                  NEXT FIELD tql04
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()               #No.FUN-590083
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds                                                   
            CALL cl_on_idle()                                                     
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode())
               RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
      END INPUT
 
 
      ON ACTION detail
 
          SELECT occacti INTO l_occacti
            FROM occ_file
           WHERE occ01=p_occ01
          IF l_occacti='N' THEN
             CALL cl_err('','mfg0301',1)
             RETURN
          END IF
 
         #判斷若客戶已審核則不允許進入單身進行相應的動作               051024
          SELECT occ1004 INTO l_occ1004
            FROM occ_file
           WHERE occ01=p_occ01
           IF l_occ1004!='0' THEN #FUN-690021
              #非開立狀態，不可異動！
              CALL cl_err(p_occ01,'atm-046',1)
              RETURN
           END IF
 
 
          CALL cl_set_act_visible("accept,cancel", TRUE)
          LET g_forupd_sql = " SELECT tql02,tql04,tqa02 ",
                             "   FROM tql_file,tqa_file ",
                             "  WHERE tql01 = ?  ",
                             "   AND tql02 = ? ",
                             "   AND tql03 = ? ",
                             "   AND tql04 = tqa01 ",
                             "   AND tql03 = tqa03 ",
                             " ORDER by tql02 ",
                             " FOR UPDATE "
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

         DECLARE i221_8_bc2 CURSOR FROM g_forupd_sql
         LET l_allow_insert = cl_detail_input_auth("insert")
         LET l_allow_delete = cl_detail_input_auth("delete")
         INPUT ARRAY l_tql WITHOUT DEFAULTS FROM s_tql.*
            ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
 
            IF l_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
         BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            BEGIN WORK
            IF l_rec_b >= l_ac THEN
               LET p_cmd = 'u'
               LET l_tql_t.* = l_tql[l_ac].*
               OPEN i221_8_bc2 USING p_occ01,l_tql_t.tql02,p_tql03
               IF STATUS THEN
                  CALL cl_err("OPEN i221_8_bc2:", STATUS, 1)
               ELSE
                  FETCH i221_8_bc2 INTO l_tql[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(l_tql_t.tql02,SQLCA.sqlcode,1)
                  END IF
               END IF
            END IF
 
         BEFORE INSERT
            LET p_cmd = 'a'
            INITIALIZE l_tql[l_ac].* TO NULL
            LET l_tql_t.* = l_tql[l_ac].*
            NEXT FIELD tql02
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO tql_file(tql01,tql02,tql03,tql04)
               VALUES(p_occ01,l_tql[l_ac].tql02,p_tql03,
                                    l_tql[l_ac].tql04)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","tql_file",p_occ01,l_tql[l_ac].tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  DISPLAY l_rec_b TO FORMONLY.cn2
                  COMMIT WORK
               END IF
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_tql[l_ac].* = l_tql_t.*
               CLOSE i221_8_bc2
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            UPDATE tql_file SET tql02 = l_tql[l_ac].tql02,
                                tql04 = l_tql[l_ac].tql04
                            WHERE tql01 = p_occ01
                              AND tql02 = l_tql_t.tql02
                              AND tql03 = p_tql03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tql_file",p_occ01,l_tql_t.tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET l_tql[l_ac].* = l_tql_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET l_tql[l_ac].* = l_tql_t.*
               END IF
               CLOSE i221_8_bc2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i221_8_bc2
            COMMIT WORK
 
         BEFORE DELETE                            #是否取消單身
            IF l_tql_t.tql02 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               DELETE FROM tql_file
                WHERE tql01 = p_occ01
                  AND tql02 = l_tql_t.tql02
                  AND tql03 = p_tql03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","tql_file",p_occ01,l_tql_t.tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  EXIT INPUT
               END IF
               LET l_rec_b=l_rec_b-1
               DISPLAY l_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
         BEFORE FIELD tql02
            IF cl_null(l_tql[l_ac].tql02) OR l_tql[l_ac].tql02 = 0 THEN
               SELECT MAX(tql02)+1 INTO l_tql[l_ac].tql02
                 FROM tql_file
                WHERE tql01 = p_occ01
                  AND tql03 = p_tql03
               IF cl_null(l_tql[l_ac].tql02) THEN
                  LET l_tql[l_ac].tql02 = 1
               END IF
            END IF
 
         AFTER FIELD tql02
            IF NOT cl_null(l_tql[l_ac].tql02) THEN
               IF l_tql[l_ac].tql02 != l_tql_t.tql02
                             OR cl_null(l_tql_t.tql02) THEN
                  SELECT COUNT(*) INTO l_n
                    FROM tql_file
                   WHERE tql01 = p_occ01
                     AND tql02 = l_tql[l_ac].tql02
                     AND tql03 = p_tql03
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET l_tql[l_ac].tql02 = l_tql_t.tql02
                     NEXT FIELD tql02
                  END IF
               END IF
            END IF
 
         AFTER FIELD tql04
            IF NOT cl_null(l_tql[l_ac].tql04) THEN
               SELECT COUNT(*) INTO l_n FROM tqa_file
                WHERE tqa01 = l_tql[l_ac].tql04
                  AND tqa03 = p_tql03
               IF l_n = 0 THEN
                  IF p_tql03 = '1' THEN
                     CALL cl_err('','atm-059',0)
                  END IF
                  IF p_tql03 = '3' THEN
                     CALL cl_err('','atm-060',0)
                  END IF
                  NEXT FIELD tql04
               END IF
               IF (p_cmd = 'u' AND l_tql[l_ac].tql04 != l_tql_t.tql04 )
                                OR p_cmd = 'a' THEN
                  SELECT COUNT(*) INTO l_n FROM tql_file
                   WHERE tql01 = p_occ01
                     AND tql03 = p_tql03
                     AND tql04 = l_tql[l_ac].tql04
                  IF l_n > 0 THEN
                     CALL cl_err('','axm-298',0)
                     NEXT FIELD tql04
                  END IF
               END IF
               SELECT tqa02 INTO l_tql[l_ac].tqa02
                 FROM tqa_file
                WHERE tqa01 = l_tql[l_ac].tql04
                  AND tqa03 = p_tql03
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(tql04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = p_tql03
                  LET g_qryparam.default1 = l_tql[l_ac].tql04
                  CALL cl_create_qry() RETURNING l_tql[l_ac].tql04
                  DISPLAY BY NAME l_tql[l_ac].tql04
                  NEXT FIELD tql04
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()               #No.FUN-590083
 
         ON IDLE g_idle_seconds                                                   
            CALL cl_on_idle()                                                     
            CONTINUE INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode())
               RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
      END INPUT
 
      CLOSE i221_8_bc2
      COMMIT WORK
 
      CALL cl_set_act_visible("accept,cancel", FALSE)
      CONTINUE DISPLAY
 
      ON ACTION exit
         EXIT DISPLAY
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   LET INT_FLAG=0
   CLOSE WINDOW i221_8_w
END FUNCTION
 
FUNCTION i221_copy()
   DEFINE l_new_occ01 LIKE occ_file.occ01
   DEFINE l_old_occ01 LIKE occ_file.occ01
   DEFINE l_occ RECORD LIKE occ_file.*
   DEFINE l_cnt LIKE type_file.num10   #No.FUN-680137 INTEGER
 
   IF cl_null(g_occ.occ01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   SELECT * INTO g_occ.* FROM occ_file where occ01=g_occ.occ01
   LET l_new_occ01=NULL
 
   LET g_before_input_done = FALSE
   CALL i221_set_entry('a')
   LET g_before_input_done = TRUE
 
   DISPLAY l_new_occ01 TO occ01
   INPUT l_new_occ01 FROM occ01
 
      AFTER FIELD occ01
         IF NOT cl_null(l_new_occ01) THEN
            SELECT COUNT(*) INTO l_cnt FROM occ_file
             WHERE occ01=l_new_occ01
            IF l_cnt > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD occ01
            END IF
            CALL s_field_chk(l_new_occ01,'4',g_plant,'occ01') RETURNING g_flag2
            IF g_flag2 = '0' THEN
               CALL cl_err(l_new_occ01,'aoo-043',1)
               NEXT FIELD occ01
            END IF
         END IF
         #No.FUN-BB0049  --Begin
         ##No.FUN-A30110  --Begin
         ##CALL s_check_pmc01_occ01(l_new_occ01,g_occ.occ02,g_dbs,'2','N')
         #CALL s_check_pmc01_occ01(l_new_occ01,g_occ.occ02,g_plant,'2','N')  #FUN-A50102
         #     RETURNING g_flag,g_flag1
         ##No.FUN-A30110  --End 
         #No.FUN-BB0049  --End  
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      DISPLAY g_occ.occ01 TO occ01
      RETURN
   END IF
   IF cl_null(l_new_occ01) THEN
      DISPLAY g_occ.occ01 TO occ01
      RETURN
   END IF
   LET l_occ.*=g_occ.*
   LET l_occ.occ01=l_new_occ01
   LET l_occ.occ09=l_new_occ01   #送貨客戶   #FUN-660042 add
   #MOD-B30027 add --start--
   LET l_occ.occ1022 = l_new_occ01
   IF l_occ.occ06 MATCHES '[24]' THEN
      LET l_occ.occ1022 = NULL
   END IF
   #MOD-B30027 add --end--
   LET l_occ.occ07=l_new_occ01   #MOD-920219
   LET l_occ.occ1004 ='0'  #FUN-690021
   LET l_occ.occuser = g_user
   LET l_occ.occgrup = g_grup
   LET l_occ.occdate = g_today
   LET l_occ.occacti = 'P' #FUN-690021
   LET l_occ.occmodu = NULL  #TQC-750108
   LET l_occ.occ246  = g_plant   #No.FUN-7C0010
   #LET l_occ.occpos = 'N'   #FUN-870100
   LET l_occ.occpos = '1'    #NO.FUN-B50023
   LET l_occ.occ16  = NULL   #MOD-A40187
   LET l_occ.occ171 = NULL   #MOD-A40187
   LET l_occ.occ172 = NULL   #MOD-A40187
   LET l_occ.occ173 = NULL   #MOD-A40187
   LET l_occ.occ174 = NULL   #MOD-A40187
   LET l_occ.occud03 = 'N'   #darcy:2025/05/26
#FUN-C50136---add---str---
#  IF g_oaz.oaz96 = 'Y' THEN
#     LET l_occ.occ61 = ''
#     LET l_occ.occ62 = 'N'
#     LET l_occ.occ63 = ''
#     LET l_occ.occ631= ''
#     LET l_occ.occ64 = ''
#     LET l_occ.occ175= ''
#     LET l_occ.occ36 = ''
#     LET l_occ.occ33 = ''
#  END IF
#FUN-C50136---add---end---
 
   BEGIN WORK    #NO.FUN-680010
 
   LET l_occ.occoriu = g_user      #No.FUN-980030 10/01/04
   LET l_occ.occorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO occ_file VALUES (l_occ.*)
   IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]=0) THEN
      CALL cl_err3("ins","occ_file",l_occ.occ01,"","9050","","copy",1)  #No.FUN-660167
      ROLLBACK WORK     #FUN-680010
      LET g_success='N'
   ELSE
      LET g_success='Y'
   END IF
   IF g_success='Y' THEN
      LET l_old_occ01=g_occ.occ01
      SELECT occ_file.* INTO g_occ.* FROM occ_file
                  WHERE occ01 = l_new_occ01
      CALL i221_u()
     #LET g_u_flag=''  #FUN-870101 add  #FUN-9A0056 mark
 
      # CALL aws_mdmcli
      # 傳入參數: (1)TABLE名稱, (2)功能：insert(新增),update(修改),delete(刪除),
      #           (3-7)新增資料 
      # CASE aws_mdmcli('customer','insert',base.TypeInfo.create(g_occ),'','','','')
      CASE aws_mdmdata('occ_file','insert',g_occ.occ01,base.TypeInfo.create(g_occ),'CreateCustomerData')#FUN-870166
         WHEN 0  #無與 MDM 整合
             #LET g_u_flag='0'    #FUN-870101 add  #FUN-9A0056 mark
              LET g_success='Y'   #FUN-9A0056 add
              MESSAGE 'INSERT O.K'
         WHEN 1  #呼叫 MDM 成功
             #LET g_u_flag='0'    #FUN-870101 add  #FUN-9A0056 mark
              LET g_success='Y'   #FUN-9A0056 add
              MESSAGE 'INSERT O.K, INSERT MDM O.K'
         WHEN 2  #呼叫 MDM 失敗
             #LET g_u_flag='1'    #FUN-870101 add  #FUN-9A0056 mark
             #ROLLBACK WORK       #FUN-9A0056 mark
              LET g_success='N'   #FUN-9A0056 add
      END CASE
    #TQC-960216---mark---start---
    #複製時不與SPC做整合 
    # # CALL aws_spccli_base()
    # # 傳入參數: (1)TABLE名稱, (2)新增資料,
    # #           (3)功能選項：insert(新增),update(修改),delete(刪除)
    # CASE aws_spccli_base('occ_file',base.TypeInfo.create(g_occ),'insert')
    #    WHEN 0  #無與 SPC 整合
    #         LET g_u_flag='0'    #FUN-870101 add
    #         MESSAGE 'INSERT O.K'
    #    WHEN 1  #呼叫 SPC 成功
    #         LET g_u_flag='0'    #FUN-870101 add
    #         MESSAGE 'INSERT O.K, INSERT SPC O.K'
    #    WHEN 2  #呼叫 SPC 失敗
    #         LET g_u_flag='1'    #FUN-870101 add
    # END CASE
    #
    #複製時不與MES做整合
    #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
    #   # CALL aws_mescli()
    #   # 傳入參數: (1)程式代號
    #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
    #   #           (3)Key
    #   CASE aws_mescli('axmi221','insert',g_occ.occ01)
    #      WHEN 0  #無與 MES 整合
    #            LET g_u_flag='0'                   
    #            MESSAGE 'INSERT O.K'
    #      WHEN 1  #呼叫 MES 成功
    #            LET g_u_flag='0'                   
    #            MESSAGE 'INSERT O.K, INSERT MES O.K'
    #      WHEN 2  #呼叫 MES 失敗
    #            LET g_u_flag='1'   
    #   END CASE
    #   IF g_u_flag='1' THEN ROLLBACK WORK ELSE COMMIT WORK END IF  
    #END IF  #TQC-8B0011  ADD
    #TQC-960216---mark---end---
      #SELECT occ_file.* INTO g_occ.* FROM occ_file  #FUN-C80046
      #            WHERE occ01 = l_old_occ01         #FUN-C80046
   END IF

  #FUN-9A0056 add begin ----
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
  #FUN-9A0056 add end ------

   CALL i221_show()
END FUNCTION
#show 圖示
FUNCTION i221_show_pic()
     LET g_chr='N'
     LET g_chr1='N'
     LET g_chr2='N'
     IF g_occ.occ1004='1' THEN
         LET g_chr='Y'
     END IF
     IF g_occ.occ1004='0' THEN
         LET g_chr1='Y'
     END IF
     IF g_occ.occ1004='2' THEN
         LET g_chr2='Y'
     END IF
     CALL cl_set_field_pic1(g_chr,""  ,""  ,""  ,""  ,g_occ.occacti,""    ,g_chr2)
                           #確認 ,核准,過帳,結案,作廢,有效         ,申請  ,留置
END FUNCTION
 
FUNCTION i221_abx()
 
  IF cl_null(g_occ.occ01) THEN
     RETURN
  END IF
  IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
     CALL cl_err(g_occ.occ246,'aoo-045',1)
     RETURN
  END IF
 
  BEGIN WORK
 
  LET g_occ_t.* = g_occ.*
 
  OPEN i221_cl USING g_occ.occ01
  IF STATUS THEN
     CALL cl_err("OPEN i221_cl:", STATUS, 1)
     CLOSE i221_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  FETCH i221_cl INTO g_occ.*               # 對DB鎖定
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
      CLOSE i221_cl        #MOD-950005
      ROLLBACK WORK        #MOD-950005
     RETURN
  END IF
 
  INPUT BY NAME g_occ.occ1706,g_occ.occ1705,
                g_occ.occ1707,g_occ.occ1708 WITHOUT DEFAULTS
 
     AFTER FIELD occ1706
        IF NOT cl_null(g_occ.occ1706) THEN
           CALL i221_occ1706()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_occ.occ1706,g_errno,0)
              NEXT FIELD occ1706
           END IF
        ELSE
           LET g_bxr02_2 = NULL
           DISPLAY g_bxr02_2 TO FORMONLY.reason2
        END IF
 
     AFTER FIELD occ1705
        IF NOT cl_null(g_occ.occ1705) THEN
           CALL i221_occ1705()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_occ.occ1705,g_errno,0)
              NEXT FIELD occ1705
           END IF
        ELSE
           LET g_bxr02_1 = NULL
           DISPLAY g_bxr02_1 TO FORMONLY.reason1
        END IF
 
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(occ1706)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_bxr"
              LET g_qryparam.default1 = g_occ.occ1706
              CALL cl_create_qry() RETURNING g_occ.occ1706
              CALL i221_occ1706()
              DISPLAY BY NAME g_occ.occ1706
           WHEN INFIELD(occ1705)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_bxr"
              LET g_qryparam.default1 = g_occ.occ1705
              CALL cl_create_qry() RETURNING g_occ.occ1705
              CALL i221_occ1705()
              DISPLAY BY NAME g_occ.occ1705
           OTHERWISE  EXIT CASE
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
     LET INT_FLAG=0
     LET g_occ.*=g_occ_t.*
     CALL i221_show()
     CALL cl_err('',9001,0)
     CLOSE i221_cl        #MOD-950005
     ROLLBACK WORK        #MOD-950005
     RETURN
  END IF
  UPDATE occ_file SET occ1705 = g_occ.occ1705,
                      occ1706 = g_occ.occ1706,
                      occ1707 = g_occ.occ1707,
                      occ1708 = g_occ.occ1708,
                      occmodu = g_user,               #修改者
                      occdate = g_today               #修改日期
                WHERE occ01 = g_occ.occ01
  IF SQLCA.SQLCODE THEN
     CALL cl_err('update occ1705',SQLCA.SQLCODE,0)
     ROLLBACK WORK
  ELSE
     COMMIT WORK
     LET g_occ.occmodu = g_user
     LET g_occ.occdate = g_today
     DISPLAY BY NAME g_occ.occmodu,g_occ.occdate
  END IF
 
END FUNCTION
 
FUNCTION i221_occ1705()
 
   LET g_errno = ' '
   SELECT bxr02 INTO g_bxr02_1 FROM bxr_file
      WHERE bxr01 = g_occ.occ1705
 
   IF SQLCA.SQLCODE THEN
      LET g_errno = 'abx-050'
      LET g_bxr02_1 = NULL
   END IF
 
   DISPLAY g_bxr02_1 TO FORMONLY.reason1
 
END FUNCTION
 
FUNCTION i221_occ1706()
 
   LET g_errno = ' '
   SELECT bxr02 INTO g_bxr02_2 FROM bxr_file
      WHERE bxr01 = g_occ.occ1706
 
   IF SQLCA.SQLCODE THEN
      LET g_errno = 'abx-050'
      LET g_bxr02_2 = NULL
   END IF
 
   DISPLAY g_bxr02_2 TO FORMONLY.reason2
 
END FUNCTION
 
#FUNCTION i221_cur_pmc(l_azp03) #FUN-A50102
FUNCTION i221_cur_pmc(l_plant) #FUN-A50102
  #DEFINE l_azp03 LIKE azp_file.azp03, #FUN-A50102
  DEFINE l_plant LIKE pov_file.pov03,
         l_sql   STRING
 
  #LET l_azp03 = s_dbstring(l_azp03 CLIPPED) #FUN-930006   #FUN-A50102
  #LET l_sql = "SELECT pmc03 FROM ",l_azp03 CLIPPED,"pmc_file ", #FUN-A50102
  LET l_sql = "SELECT pmc03 FROM ",cl_get_target_table(l_plant, 'pmc_file'), #FUN-A50102
            " WHERE pmc01 =?"  #l_pov.pov28
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102          
  PREPARE pmc_pre FROM l_sql
END FUNCTION
 
FUNCTION i221_i_t()
  DEFINE   l_sql          STRING
  DEFINE   l_cnt          LIKE type_file.num5
  DEFINE   l_pov   RECORD LIKE pov_file.*
  DEFINE   l_pov_t RECORD LIKE pov_file.*
  DEFINE   l_azp03        LIKE azp_file.azp03   #資料庫代號
  DEFINE   l_pov02        LIKE pov_file.pov02
  DEFINE   l_occ02        LIKE occ_file.occ02,
           l_oaydesc_1    LIKE oay_file.oaydesc,
           l_oaydesc_2    LIKE oay_file.oaydesc,
           l_oaydesc_3    LIKE oay_file.oaydesc,
           l_oaydesc_4    LIKE oay_file.oaydesc,
           l_imd02        LIKE imd_file.imd02,
           l_azf03        LIKE azf_file.azf03,
           l_pmc03        LIKE pmc_file.pmc03,
           l_azp02        LIKE azp_file.azp02,
           l_ooydesc_1    LIKE ooy_file.ooydesc,
           l_ooydesc_2    LIKE ooy_file.ooydesc,
           l_ool02        LIKE ool_file.ool02,
           l_gem02        LIKE gem_file.gem02,
           l_gem02_1      LIKE gem_file.gem02
  DEFINE   l_azf09        LIKE azf_file.azf09        #No.FUN-930106
 
   IF cl_null(g_occ.occ01) THEN
      RETURN
   END IF
   IF NOT s_dc_ud_flag('4',g_occ.occ246,g_plant,'u') THEN
      CALL cl_err(g_occ.occ246,'aoo-045',1)
      RETURN
   END IF
 
   IF g_occ.occ37 = 'N' THEN
      CALL cl_err('','apm-973',0)
      RETURN
   END IF
 
   INITIALIZE l_pov.* TO NULL
   INITIALIZE l_pov_t.* TO NULL
 
   BEGIN WORK
 
   LET l_sql = "SELECT * FROM pov_file ",
               " WHERE pov01 = '1'",
               "   AND pov02 = ? "
   PREPARE pov_pre FROM l_sql
   DECLARE pov_cur CURSOR FOR pov_pre
 
   OPEN pov_cur USING g_occ.occ01
   IF STATUS THEN
      CALL cl_err("OPEN pov_cur:", STATUS, 1)
      CLOSE pov_cur
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH pov_cur INTO l_pov.*
   IF SQLCA.sqlcode THEN
      IF SQLCA.sqlcode = 100 THEN
        LET l_pov.pov01 = '1'
        LET l_pov.pov02 = g_occ.occ01
 
      ELSE
        CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
        RETURN
      END IF
   END IF
   LET l_pov_t.* = l_pov.*
 
   OPEN WINDOW i221_i_w AT p_row,p_col	
      WITH FORM "axm/42f/axmi221i"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axmi221i")
 
   #流通配銷功能才顯示
   IF g_aza.aza50 = 'Y' THEN
      CALL cl_set_comp_visible("pov11",TRUE)
   ELSE
      CALL cl_set_comp_visible("pov11",FALSE)
   END IF
 
   DISPLAY BY NAME l_pov.pov02,l_pov.pov03,
                   l_pov.pov13,l_pov.pov18,
                   l_pov.pov26,l_pov.pov22,
                   l_pov.pov15,l_pov.pov06,
                   l_pov.pov20,l_pov.pov09,
                   l_pov.pov04,l_pov.pov25,
                   l_pov.pov12,l_pov.pov11,
                   l_pov.pov10,
                   l_pov.pov28
 
 
  #Show_desc
   IF NOT cl_null(l_pov.pov02) THEN
      SELECT occ02 INTO l_occ02 FROM occ_file
       WHERE occ01 = l_pov.pov02
      IF SQLCA.sqlcode THEN LET l_occ02 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov03) THEN
      SELECT azp02,azp03 INTO l_azp02,l_azp03 FROM azp_file
       WHERE azp01 = l_pov.pov03
      IF SQLCA.sqlcode THEN
         LET l_azp02 = NULL
         LET l_azp03 = NULL
      END IF
   END IF
   IF NOT cl_null(l_pov.pov13) THEN #慣用訂單單別
      SELECT oaydesc INTO l_oaydesc_1 FROM oay_file
       WHERE oaytype = '30'
         AND oay24 = 'Y'
         AND oayslip = l_pov.pov13
      IF SQLCA.sqlcode THEN LET l_oaydesc_1 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov26) THEN
      SELECT oaydesc INTO l_oaydesc_2 FROM oay_file
       WHERE oaytype = '40'
         AND oay24 = 'Y'
         AND oayslip = l_pov.pov26
      IF SQLCA.sqlcode THEN LET l_oaydesc_2 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov15) THEN
      SELECT oaydesc INTO l_oaydesc_3 FROM oay_file
       WHERE oaytype = '50'
         AND oay24 = 'Y'
         AND oayslip = l_pov.pov15
      IF SQLCA.sqlcode THEN LET l_oaydesc_3 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov20) THEN
      SELECT oaydesc INTO l_oaydesc_4 FROM oay_file
       WHERE oaytype = '60'
         AND oay24 = 'Y'
         AND oayslip = l_pov.pov20
      IF SQLCA.sqlcode THEN LET l_oaydesc_4 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov04) THEN
      SELECT imd02 INTO l_imd02 FROM imd_file
       WHERE imd01 = l_pov.pov04
      IF SQLCA.sqlcode THEN LET l_imd02 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov12) THEN  #調撥理由碼
      SELECT azf03 INTO l_azf03 FROM azf_file
       WHERE azf01 = l_pov.pov12
         AND azf02 = '2'
         AND azf09 = '6'
      IF SQLCA.sqlcode THEN LET l_azf03 = NULL  END IF
   END IF 
   IF NOT cl_null(l_pov.pov28) THEN        
      #CALL i221_cur_pmc(l_azp03) #FUN-A50102
      CALL i221_cur_pmc(l_pov.pov03)  #FUN-A50102
      EXECUTE pmc_pre USING l_pov.pov28 INTO l_pmc03
      IF SQLCA.sqlcode THEN LET l_pmc03 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov18) THEN
      SELECT ooydesc INTO l_ooydesc_1 FROM ooy_file
       WHERE ooyslip = l_pov.pov18
         AND ooytype = '12'
      IF SQLCA.sqlcode THEN LET l_ooydesc_1 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov22) THEN
      SELECT ooydesc INTO l_ooydesc_2 FROM ooy_file
       WHERE ooyslip = l_pov.pov22
         AND ooytype = '21'
      IF SQLCA.sqlcode THEN LET l_ooydesc_2 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov06) THEN
      SELECT ool02 INTO l_ool02 FROM ool_file
       WHERE ool01 = l_pov.pov06
      IF SQLCA.sqlcode THEN LET l_ool02 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov09) THEN
      SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE gem01 = l_pov.pov09
      IF SQLCA.sqlcode THEN LET l_gem02 = NULL  END IF
   END IF
   IF NOT cl_null(l_pov.pov25) THEN
      SELECT gem02 INTO l_gem02_1 FROM gem_file
       WHERE gem01 = l_pov.pov25
      IF SQLCA.sqlcode THEN LET l_gem02_1 = NULL  END IF
   END IF
   IF cl_null(l_pov.pov11) THEN LET l_pov.pov11 = 'N' END IF
 
 
   DISPLAY  l_occ02      TO  occ02
   DISPLAY  l_oaydesc_1  TO  FORMONLY.oaydesc_1
   DISPLAY  l_oaydesc_2  TO  FORMONLY.oaydesc_2
   DISPLAY  l_oaydesc_3  TO  FORMONLY.oaydesc_3
   DISPLAY  l_oaydesc_4  TO  FORMONLY.oaydesc_4
   DISPLAY  l_imd02      TO  imd02
   DISPLAY  l_azf03      TO  azf03
   DISPLAY  l_pmc03      TO  pmc03
   DISPLAY  l_azp02      TO  azp02
   DISPLAY  l_ooydesc_1  TO  FORMONLY.ooydesc_1
   DISPLAY  l_ooydesc_2  TO  FORMONLY.ooydesc_2
   DISPLAY  l_ool02      TO  ool02
   DISPLAY  l_gem02      TO  FORMONLY.gem02
   DISPLAY  l_gem02_1    TO  FORMONLY.gem02_1
 
 
   INPUT BY NAME l_pov.pov03,l_pov.pov13,l_pov.pov26,l_pov.pov15,
                 l_pov.pov20,l_pov.pov04,l_pov.pov12,l_pov.pov10,
                 l_pov.pov28,l_pov.pov18,l_pov.pov22,l_pov.pov06,
                 l_pov.pov09,l_pov.pov25,l_pov.pov11
         WITHOUT DEFAULTS
 
      AFTER FIELD pov03
         IF NOT cl_null(l_pov.pov03) THEN
            IF l_pov.pov03 = g_plant THEN
               #對應營運中心不可以和當前營運中心相同
               CALL cl_err(l_pov.pov03,'mfg9186',0)
               NEXT FIELD pov03
            END IF
            IF cl_null(l_pov_t.pov03) OR l_pov_t.pov03 <> l_pov.pov03 THEN
               #CHECK 一個DB只能被一個客戶設定
               LET l_pov02 = NULL
               SELECT pov02 INTO l_pov02 FROM pov_file
                WHERE pov01 = '1'
                  AND pov02 <> l_pov.pov02
                  AND pov03 = l_pov.pov03
               IF NOT cl_null(l_pov02) THEN
                 CALL cl_err(l_pov02,'apm-975',0)
                 NEXT FIELD pov03
               END IF
 
               SELECT azp02,azp03 INTO l_azp02,l_azp03 FROM azp_file
                WHERE azp01 = l_pov.pov03
               IF SQLCA.sqlcode  THEN
                  CALL cl_err(l_pov.pov03,SQLCA.sqlcode,0)
                  LET l_azp03 = NULL
                  LET l_azp03 = NULL
                  NEXT FIELD pov03
               END IF
               DISPLAY l_azp02 TO FORMONLY.azp02
              #對應營運中心的供應商pov中如有設定本營運中心的，將對應營運中心的pov02帶到pov28
               #LET l_sql = "SELECT pov02 FROM ", s_dbstring(l_azp03 CLIPPED),"pov_file", #FUN-930006     #FUN-A50102
               LET l_sql = "SELECT pov02 FROM ", cl_get_target_table(l_pov.pov03, 'pov_file'), #FUN-930006     #FUN-A50102
                           " WHERE pov01 = '0'",
                           "   AND pov03 = '",g_plant CLIPPED,"'"
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 	             CALL cl_parse_qry_sql(l_sql, l_pov.pov03) RETURNING l_sql  #FUN-A50102
               PREPARE pov_pre2 FROM  l_sql
               EXECUTE pov_pre2 INTO l_pov02
               IF NOT cl_null(l_pov02) THEN
                 LET l_pov.pov28 = l_pov02   
                 #CALL i221_cur_pmc(l_azp03) #FUN-A50102
                 CALL i221_cur_pmc(l_pov.pov03) #FUN-A50102
                 EXECUTE pmc_pre USING l_pov.pov28 INTO l_pmc03
                 DISPLAY l_pmc03 TO pmc03
               ELSE
                 LET l_pov.pov28 = NULL
                 DISPLAY NULL TO pmc03
               END IF
               DISPLAY BY NAME l_pov.pov28
            END IF
         ELSE
            NEXT FIELD pov03
         END IF
 
 
      AFTER FIELD pov13 #慣用訂單單別
        IF cl_null(l_pov.pov13) THEN
          NEXT FIELD pov13
        ELSE
          IF cl_null(l_pov_t.pov13) OR l_pov_t.pov13 <> l_pov.pov13 THEN
             SELECT oaydesc INTO l_oaydesc_1 FROM oay_file
              WHERE oayslip = l_pov.pov13
                AND oaytype = '30'
                AND oay24 = 'Y'
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov13,SQLCA.sqlcode,0)
                LET l_oaydesc_1 = NULL
                NEXT FIELD pov13
             END IF
          END IF
          DISPLAY l_oaydesc_1 TO FORMONLY.oaydesc_1
        END IF
 
      AFTER FIELD pov26 #慣用通知單別
        IF cl_null(l_pov.pov26) THEN
          NEXT FIELD pov26
        ELSE
          IF cl_null(l_pov_t.pov26) OR l_pov_t.pov26 <> l_pov.pov26 THEN
             SELECT oaydesc INTO l_oaydesc_2 FROM oay_file
              WHERE oayslip = l_pov.pov26
                AND oaytype = '40'
                AND oay24 = 'Y'
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov26,SQLCA.sqlcode,0)
                LET l_oaydesc_2 = NULL
                NEXT FIELD pov26
             END IF
          END IF
          DISPLAY l_oaydesc_2 TO FORMONLY.oaydesc_2
        END IF
 
      AFTER FIELD pov15 #慣用出貨單別
        IF cl_null(l_pov.pov15) THEN
          NEXT FIELD pov15
        ELSE
          IF cl_null(l_pov_t.pov15) OR l_pov_t.pov15 <> l_pov.pov15 THEN
             SELECT oaydesc INTO l_oaydesc_3 FROM oay_file
              WHERE oayslip = l_pov.pov15
                AND oaytype = '50'
                AND oay24 = 'Y'
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov15,SQLCA.sqlcode,0)
                LET l_oaydesc_3 = NULL
                NEXT FIELD pov15
             END IF
          END IF
          DISPLAY l_oaydesc_3 TO FORMONLY.oaydesc_3
        END IF
 
      AFTER FIELD pov20 #慣用銷退單別
        IF cl_null(l_pov.pov20) THEN
          NEXT FIELD pov20
        ELSE
          IF cl_null(l_pov_t.pov20) OR l_pov_t.pov20 <> l_pov.pov20 THEN
             SELECT oaydesc INTO l_oaydesc_4 FROM oay_file
              WHERE oayslip = l_pov.pov20
                AND oaytype = '60'
                AND oay24 = 'Y'
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov20,SQLCA.sqlcode,0)
                LET l_oaydesc_4 = NULL
                NEXT FIELD pov20
             END IF
          END IF
          DISPLAY l_oaydesc_4 TO FORMONLY.oaydesc_4
        END IF
 
      AFTER FIELD pov04 #慣用倉庫
        IF cl_null(l_pov.pov04) THEN
          NEXT FIELD pov04
        ELSE
          IF cl_null(l_pov_t.pov04) OR l_pov_t.pov04 <> l_pov.pov04 THEN
             SELECT imd02 INTO l_imd02 FROM imd_file
              WHERE imd01 = l_pov.pov04
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov04,SQLCA.sqlcode,0)
                LET l_imd02 = NULL
                NEXT FIELD pov04
             END IF
             DISPLAY l_imd02 TO imd02
          END IF
        END IF
 
      AFTER FIELD pov12
        IF cl_null(l_pov.pov12) THEN
          NEXT FIELD pov12
        ELSE
          IF cl_null(l_pov_t.pov12) OR l_pov_t.pov12 <> l_pov.pov12 THEN
             SELECT azf03,azf09 INTO l_azf03,l_azf09 FROM azf_file       #No.FUN-930106
              WHERE azf01 = l_pov.pov12
                AND azf02 = '2'
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov12,SQLCA.sqlcode,0)
                LET l_azf03 = NULL
                NEXT FIELD pov12
             END IF
             IF l_azf09 !='1' THEN 
                CALL cl_err(l_pov.pov12,'aoo-400',1)
                LET l_azf03 = NULL                                                                                                  
                NEXT FIELD pov12
             END IF 
             DISPLAY l_azf03 TO azf03
          END IF
        END IF
 
      BEFORE FIELD pov10
        IF g_aza.aza26 = '2' THEN
          LET l_pov.pov10 = '3'
          DISPLAY BY NAME l_pov.pov10
          NEXT FIELD pov28
        END IF
 
      AFTER FIELD pov10    #大陸功能下只能為 '3'
        IF cl_null(l_pov.pov10) THEN
           NEXT FIELD pov10
        ELSE
          IF g_aza.aza26 = '2' AND l_pov.pov10 <> '3' THEN
            CALL cl_err('','axm-970',0)
            LET l_pov.pov10 = l_pov_t.pov10
            NEXT FIELD pov10
          END IF
        END IF
 
      AFTER FIELD pov18 #慣用AR立帳單別
        IF cl_null(l_pov.pov18) THEN
          NEXT FIELD pov19
        ELSE
          IF cl_null(l_pov_t.pov18) OR l_pov_t.pov18 <> l_pov.pov18 THEN
             SELECT ooydesc INTO l_ooydesc_1 FROM ooy_file
              WHERE ooyslip = l_pov.pov18
                AND ooytype = '12'
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov18,SQLCA.sqlcode,0)
                LET l_ooydesc_1 = NULL
                NEXT FIELD pov18
             END IF
             DISPLAY l_ooydesc_1 TO FORMONLY.ooydesc_1
          END IF
        END IF
 
      AFTER FIELD pov22 #慣用AR折讓單別
        IF cl_null(l_pov.pov22) THEN
          NEXT FIELD pov22
        ELSE
          IF cl_null(l_pov_t.pov22) OR l_pov_t.pov22 <> l_pov.pov22 THEN
             SELECT ooydesc INTO l_ooydesc_2 FROM ooy_file
              WHERE ooyslip = l_pov.pov22
                AND ooytype = '21'
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov22,SQLCA.sqlcode,0)
                LET l_ooydesc_2 = NULL
                NEXT FIELD pov22
             END IF
             DISPLAY l_ooydesc_2 TO FORMONLY.ooydesc_2
          END IF
        END IF
 
 
      AFTER FIELD pov06 #慣用AR科目類型
        IF cl_null(l_pov.pov06) THEN
          NEXT FIELD pov06
        ELSE
          IF cl_null(l_pov_t.pov06) OR l_pov_t.pov06 <> l_pov.pov06 THEN
             SELECT ool02 INTO l_ool02 FROM ool_file
              WHERE ool01 = l_pov.pov06
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov06,SQLCA.sqlcode,0)
                LET l_ool02 = NULL
                NEXT FIELD pov06
             END IF
             DISPLAY l_ool02 TO ool02
          END IF
        END IF
 
 
      AFTER FIELD pov09 #慣用部門
        IF cl_null(l_pov.pov09) THEN
          NEXT FIELD pov09
        ELSE
          IF cl_null(l_pov_t.pov09) OR l_pov_t.pov09 <> l_pov.pov09 THEN
             SELECT gem02 INTO l_gem02 FROM gem_file
              WHERE gem01 = l_pov.pov09
                AND gemacti = 'Y'
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov09,SQLCA.sqlcode,0)
                LET l_gem02 = NULL
                NEXT FIELD pov09
             END IF
             DISPLAY l_gem02 TO FORMONLY.gem02
          END IF
        END IF
 
      AFTER FIELD pov25 #慣用成本中心
        IF cl_null(l_pov.pov25) THEN
          NEXT FIELD pov25
        ELSE
          IF cl_null(l_pov_t.pov25) OR l_pov_t.pov25 <> l_pov.pov25 THEN
             SELECT gem02 INTO l_gem02_1 FROM gem_file
              WHERE gem01 = l_pov.pov25
                AND gemacti = 'Y'
             IF SQLCA.sqlcode THEN
                CALL cl_err(l_pov.pov25,SQLCA.sqlcode,0)
                LET l_gem02_1 = NULL
                NEXT FIELD pov25
             END IF
             DISPLAY l_gem02_1 TO FORMONLY.gem02_1
          END IF
        END IF
 
      AFTER FIELD pov28 #當前法人在對方營運中心的預設供應商編號
        IF cl_null(l_pov.pov28) THEN
          NEXT FIELD pov28
        ELSE
          IF cl_null(l_pov_t.pov28) OR l_pov_t.pov28 <> l_pov.pov28 THEN
             IF cl_null(l_azp03) THEN
               NEXT FIELD pov03 
             ELSE   
               #CALL i221_cur_pmc(l_azp03) #FUN-A50102
               CALL i221_cur_pmc(l_pov.pov03) #FUN-A50102
               EXECUTE pmc_pre USING l_pov.pov28 INTO l_pmc03
               IF SQLCA.sqlcode THEN
                  CALL cl_err(l_pov.pov28,SQLCA.sqlcode,0)
                  LET l_pmc03 = NULL
                  NEXT FIELD pov28
               END IF
               DISPLAY l_pmc03 TO pmc03
             END IF
          END IF
        END IF
 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pov03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = l_pov.pov03
               CALL cl_create_qry() RETURNING l_pov.pov03
               SELECT azp02 INTO l_azp02 FROM azp_file
               WHERE azp01 = l_pov.pov03
               IF SQLCA.sqlcode THEN
                 LET l_azp02 = NULL
               END IF
               DISPLAY BY NAME l_pov.pov03
               DISPLAY l_azp02 TO FORMONLY.azp02
 
            WHEN INFIELD(pov12)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf01a"               #No.FUN-930106
               LET g_qryparam.default1 = l_pov.pov12
               LET g_qryparam.arg1 = '1'                      #No.FUN-930106
               CALL cl_create_qry() RETURNING l_pov.pov12
               DISPLAY BY NAME l_pov.pov12
 
            WHEN INFIELD(pov13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oay5"
               LET g_qryparam.default1 = l_pov.pov13
               LET g_qryparam.arg1 = '30'
               LET g_qryparam.arg2 = 'axm'      #FUN-A70130 add
               CALL cl_create_qry() RETURNING l_pov.pov13,l_oaydesc_1
               DISPLAY BY NAME l_pov.pov13
               DISPLAY l_oaydesc_1 TO FORMONLY.oaydesc_1
 
            WHEN INFIELD(pov26)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oay5"
               LET g_qryparam.default1 = l_pov.pov26
               LET g_qryparam.arg1 = '40'
               LET g_qryparam.arg2 = 'axm'     #FUN-A70130 add
               CALL cl_create_qry() RETURNING l_pov.pov26,l_oaydesc_2
               DISPLAY BY NAME l_pov.pov26
               DISPLAY l_oaydesc_2 TO FORMONLY.oaydesc_2
 
            WHEN INFIELD(pov15)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oay5"
               LET g_qryparam.default1 = l_pov.pov15
               LET g_qryparam.arg1 = '50'
               LET g_qryparam.arg2 = 'axm'    #FUN-A70130 add
               CALL cl_create_qry() RETURNING l_pov.pov15,l_oaydesc_3
               DISPLAY BY NAME l_pov.pov15
               DISPLAY l_oaydesc_3 TO FORMONLY.oaydesc_3
 
            WHEN INFIELD(pov20)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oay5"
               LET g_qryparam.default1 = l_pov.pov20
               LET g_qryparam.arg1 = '60'
               LET g_qryparam.arg2 = 'axm'      #FUN-A70130 add
               CALL cl_create_qry() RETURNING l_pov.pov20,l_oaydesc_4
               DISPLAY BY NAME l_pov.pov20
               DISPLAY l_oaydesc_4 TO FORMONLY.oaydesc_4
 
            WHEN INFIELD(pov04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imd1"
               LET g_qryparam.default1 = l_pov.pov04
               CALL cl_create_qry() RETURNING l_pov.pov04
               DISPLAY BY NAME l_pov.pov04
 
 
            WHEN INFIELD(pov28)
               IF cl_null(l_azp03) THEN RETURN END IF
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc13"
               LET g_qryparam.default1 = l_pov.pov28
               LET g_qryparam.plant = l_pov.pov03  #No.FUN-980025 add 
               CALL cl_create_qry() RETURNING l_pov.pov28
               DISPLAY BY NAME l_pov.pov28
 
            WHEN INFIELD(pov18)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ooy4"
               LET g_qryparam.default1 = l_pov.pov18
               LET g_qryparam.arg1 = '12'
               CALL cl_create_qry() RETURNING l_pov.pov18,l_ooydesc_1
               DISPLAY BY NAME l_pov.pov18
               DISPLAY l_ooydesc_1 TO FORMONLY.ooydesc_1
 
            WHEN INFIELD(pov22)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ooy4"
               LET g_qryparam.default1 = l_pov.pov22
               LET g_qryparam.arg1 = '21'
               CALL cl_create_qry() RETURNING l_pov.pov22,l_ooydesc_2
               DISPLAY BY NAME l_pov.pov22
               DISPLAY l_ooydesc_2 TO FORMONLY.ooydesc_2
 
            WHEN INFIELD(pov06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ool"
               LET g_qryparam.default1 = l_pov.pov06
               CALL cl_create_qry() RETURNING l_pov.pov06
               DISPLAY BY NAME l_pov.pov06
 
            WHEN INFIELD(pov09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem5"
               LET g_qryparam.default1 = l_pov.pov09
               CALL cl_create_qry() RETURNING l_pov.pov09,l_gem02
               DISPLAY BY NAME l_pov.pov09
               DISPLAY l_gem02 TO FORMONLY.gem02
 
            WHEN INFIELD(pov25)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem5"
               LET g_qryparam.default1 = l_pov.pov25
               CALL cl_create_qry() RETURNING l_pov.pov25,l_gem02_1
               DISPLAY BY NAME l_pov.pov25
               DISPLAY l_gem02_1 TO FORMONLY.gem02_1
 
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
      LET INT_FLAG=0
      LET l_pov.* = l_pov_t.*
      CALL cl_err('',9001,0)
      CLOSE WINDOW i221_i_w
      RETURN
   END IF
 
   INSERT INTO pov_file VALUES (l_pov.*)
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
      UPDATE pov_file SET pov03 = l_pov.pov03,
                          pov13 = l_pov.pov13,
                          pov26 = l_pov.pov26,
                          pov15 = l_pov.pov15,
                          pov20 = l_pov.pov20,
                          pov04 = l_pov.pov04,
                          pov12 = l_pov.pov12,
                          pov10 = l_pov.pov10,
                          pov18 = l_pov.pov18,
                          pov22 = l_pov.pov22,
                          pov06 = l_pov.pov06,
                          pov09 = l_pov.pov09,
                          pov25 = l_pov.pov25,
                          pov11 = l_pov.pov11,
                          pov28 = l_pov.pov28
             WHERE pov01 = '1'
               AND pov02 = g_occ.occ01
   END IF
   IF SQLCA.SQLCODE THEN
      CALL cl_err('update pov',SQLCA.SQLCODE,0)
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   CLOSE WINDOW i221_i_w
END FUNCTION
 
FUNCTION i221_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_occ_l TO s_occ_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION main
         LET g_bp_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i221_fetch('/')
         END IF
         CALL cl_set_comp_visible("page86", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page86", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i221_fetch('/')
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("page86", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page86", TRUE)
         EXIT DISPLAY
 
      ON ACTION next
         CALL i221_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION previous
         CALL i221_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION jump
         CALL i221_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION first
         CALL i221_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION last
         CALL i221_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION info_pg
         EXIT DISPLAY
 
      ON ACTION controlg
         #-----MOD-A70076---------
         #CALL cl_cmdask()
         LET g_action_choice="controlg"
         EXIT DISPLAY
         #-----END MOD-A70076-----
 
      ON ACTION help
         #-----MOD-A70076---------
         #CALL cl_show_help()
         LET g_action_choice="help"
         EXIT DISPLAY
         #-----END MOD-A70076-----
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL i221_show_pic()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"   #MOD-A70076
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         #-----MOD-A70076---------
         #CALL cl_about()      #MOD-4C0121
         LET g_action_choice="about"
         EXIT DISPLAY
         #-----END MOD-A70076-----
 
      #-----MOD-A70076---------
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

     #No.FUN-9C0089 add begin----------------
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
     #No.FUN-9C0089 add -end-----------------

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION credit_line
         LET g_action_choice="credit_line"
         EXIT DISPLAY

      ON ACTION carry_credit
         LET g_action_choice="carry_credit"
         EXIT DISPLAY

#FUN-C50070 mark -begin--------------------------
#     ON ACTION customer_address
#        LET g_action_choice="customer_address"
#        EXIT DISPLAY
#FUN-C50070 mark --end---------------------------

      ON ACTION customer_address1
         LET g_action_choice="customer_address1"
         EXIT DISPLAY

      ON ACTION customer_contact
         LET g_action_choice="customer_contact"
         EXIT DISPLAY

      ON ACTION customer_contact1
         LET g_action_choice="customer_contact1"
         EXIT DISPLAY

      ON ACTION customer_notify_consignee
         LET g_action_choice="customer_notify_consignee"
         EXIT DISPLAY

      ON ACTION bank_list
         LET g_action_choice="bank_list"
         EXIT DISPLAY

      ON ACTION customer_remark
         LET g_action_choice="customer_remark"
         EXIT DISPLAY

      ON ACTION cust_carry
         LET g_action_choice="cust_carry"
         EXIT DISPLAY

      ON ACTION price_carry
         LET g_action_choice="price_carry"
         EXIT DISPLAY

      ON ACTION download
         LET g_action_choice="download"
         EXIT DISPLAY

      ON ACTION qry_carry_history
         LET g_action_choice="qry_carry_history"
         EXIT DISPLAY
      
      ON ACTION customer_deal_kind
         LET g_action_choice="customer_deal_kind"
         EXIT DISPLAY

      ON ACTION customer_deal_catena
         LET g_action_choice="customer_deal_catena"
         EXIT DISPLAY

      ON ACTION client_price          
         LET g_action_choice="client_price"
         EXIT DISPLAY

      ON ACTION finance_info_maintenance
         LET g_action_choice="finance_info_maintenance"
         EXIT DISPLAY

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY

      ON ACTION hang
         LET g_action_choice="hang"
         EXIT DISPLAY

      ON ACTION unhang
         LET g_action_choice="unhang"
         EXIT DISPLAY

      ON ACTION untransaction
         LET g_action_choice="untransaction"
         EXIT DISPLAY

      ON ACTION transaction
         LET g_action_choice="transaction"
         EXIT DISPLAY

      ON ACTION internal_trade_data
         LET g_action_choice="internal_trade_data"
         EXIT DISPLAY

      ON ACTION set_replacement
         LET g_action_choice="set_replacement"
         EXIT DISPLAY

      ON ACTION related_query
         LET g_action_choice="related_query"
         EXIT DISPLAY

      ON ACTION qry_product_inventory
         LET g_action_choice="qry_product_inventory"
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION abx_maintain
         LET g_action_choice="abx_maintain"
         EXIT DISPLAY

      #-----END MOD-A70076-----
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   IF INT_FLAG THEN
      CALL cl_set_comp_visible("list", FALSE)
      CALL cl_set_comp_visible("info", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("list", TRUE)
      CALL cl_set_comp_visible("info", TRUE)
      LET INT_FLAG = 0
   END IF
END FUNCTION
 
FUNCTION i221_carry()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE #l_sql     LIKE type_file.chr1000
          l_sql    STRING     #NO.FUN-910082
 
   IF cl_null(g_occ.occ01) THEN   #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_occ.occacti <> 'Y' THEN
      CALL cl_err(g_occ.occ01,'aoo-090',1)
      RETURN
   END IF
   IF g_occ.occ1004 <> '1' THEN
      #不在確認狀態，不可異動！
      CALL cl_err('','atm-053',0)
      RETURN
   END IF
 
   LET g_gev04 = NULL
 
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file
    WHERE gev01 = '4' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
 
   IF cl_null(g_gev04) THEN RETURN END IF
 
   #開窗選擇拋轉的db清單
   LET l_sql = "SELECT COUNT(*) FROM &occ_file WHERE occ01='",g_occ.occ01,"'"
   CALL s_dc_sel_db1(g_gev04,'4',l_sql)
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   CALL g_occ_x.clear()
   LET g_occ_x[1].sel = 'Y'
   LET g_occ_x[1].occ01 = g_occ.occ01
   CALL g_azp.clear()
   FOR l_i = 1 TO g_azp1.getLength()
       LET g_azp[l_i].sel   = g_azp1[l_i].sel
       LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
       LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
       LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
   END FOR
 
   CALL s_showmsg_init()
   CALL s_axmi221_carry_occ(g_occ_x,g_azp,g_gev04,'1','0')  #No.FUN-830090
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION i221_download()
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10
  DEFINE l_j          LIKE type_file.num10
 
   IF cl_null(g_occ.occ01) THEN   #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   CALL g_occ_x.clear()
   LET l_j = 1
   FOR l_i = 1 TO g_occ_l.getLength()
       IF g_occ_l[l_i].occ1004_l='1' THEN
          LET g_occ_x[l_j].sel   = 'Y'
          LET g_occ_x[l_j].occ01 = g_occ_l[l_i].occ01_l
          LET l_j = l_j + 1
       END IF
   END FOR
   CALL s_axmi221_download(g_occ_x)
END FUNCTION
 
FUNCTION i221_price_carry()
 
   IF cl_null(g_occ.occ01) THEN   #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file
    WHERE gev01 = '4' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
   CALL s_axmi221_price_carry(g_occ.occ01)
 
END FUNCTION
 
FUNCTION i221_credit_carry()
 
   IF cl_null(g_occ.occ01) THEN   #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_occ.occ1004 <> '1' THEN
      #不在確認狀態，不可異動！
      CALL cl_err('','atm-053',0)
      RETURN
   END IF
 
   LET g_gev04 = NULL
 
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file
    WHERE gev01 = '4' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
 
   IF cl_null(g_gev04) THEN RETURN END IF
 
   #開窗選擇拋轉的db清單
   CALL s_dc_sel_db(g_gev04,'4')
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   CALL g_occ_x.clear()
   LET g_occ_x[1].sel = 'Y'
   LET g_occ_x[1].occ01 = g_occ.occ01
 
   CALL s_showmsg_init()
   CALL s_axmi221_carry_occ(g_occ_x,g_azp,g_gev04,'2','0')  #No.FUN-830090
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION i221_occ34(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_occ1004  LIKE occ_file.occ1004    #TQC-9A0020
 
   LET g_errno=''
 
   SELECT occ1004 INTO l_occ1004
     FROM occ_file
    WHERE occ01=g_occ.occ34
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg4106'
        WHEN l_occ1004 <> '1'    LET g_errno='atm-073'
       #WHEN g_occ.occ34 = g_occ.occ01                        #FUN-C80019 mark
       #                         LET g_errno='axm-960'        #FUN-C80019 mark
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
  #FUN-C80019 add START
  #當集團輸入自己時,不控卡已確認否
  #IF g_occ.occ34 = g_occ.occ01  THEN
      IF l_occ1004 <> '1' THEN
         LET g_errno = ''
      END IF
  #END IF
  #FUN-C80019 add END
 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#FUN-9A0056 add str ---------------
FUNCTION i221_mes(p_key1,p_key2)
  DEFINE p_key1   VARCHAR(6)
  DEFINE p_key2   VARCHAR(500)
  DEFINE l_mesg01 VARCHAR(30)

  CASE p_key1
     WHEN 'insert'  #新增
          LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
     WHEN 'update'  #修改
          LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
     WHEN 'delete'  #刪除
          LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
     OTHERWISE
  END CASE

# CALL aws_mescli
# 傳入參數: (1)程式代號
#           (2)功能選項：insert(新增),update(修改),delete(刪除)
#           (3)Key
  CASE aws_mescli('axmi221',p_key1,p_key2)
     WHEN 1  #呼叫 MES 成功
          MESSAGE l_mesg01
          LET g_success = 'Y'
     WHEN 2  #呼叫 MES 失敗
          LET g_success = 'N'
     OTHERWISE  #其他異常
          LET g_success = 'N'
  END CASE

END FUNCTION
#FUN-9A0056 add end ------------

#No.FUN-A30110  --Begin
FUNCTION i221_set_occ02(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  DEFINE l_cnt   LIKE type_file.num5
  DEFINE l_pmc03 LIKE pmc_file.pmc03

   IF cl_null(g_occ.occ01) THEN RETURN END IF
   IF p_cmd <> 'a' AND g_action_choice <> "reproduce" THEN RETURN END IF   #No.FUN-BB0049
   IF g_aza.aza125 = 'N' THEN RETURN END IF          #No.FUN-BB0049
   
   SELECT pmc03 INTO l_pmc03 FROM pmc_file
    WHERE pmc01 = g_occ.occ01
   IF cl_null(l_pmc03) THEN RETURN END IF
   IF NOT cl_null(l_pmc03) THEN
      LET g_occ.occ02 = l_pmc03
   END IF

END FUNCTION
#No.FUN-A30110  --End  

#-----MOD-A70076---------
FUNCTION i221_b_menu()
   DEFINE   l_priv1   LIKE zy_file.zy03,           # 使用者執行權限
            l_priv2   LIKE zy_file.zy04,           # 使用者資料權限
            l_priv3   LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE   l_cmd     LIKE type_file.chr1000



   WHILE TRUE

      CALL i221_bp("G")  

      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
         SELECT occ_file.* 
           INTO g_occ.* 
           FROM occ_file 
          WHERE occ01=g_occ_l[l_ac1].occ01_l
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i221_fetch('/')
         END IF
         CALL cl_set_comp_visible("page86", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page86", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
      END IF

      CASE g_action_choice
           WHEN "insert"
               IF g_aza.aza61 = 'N' THEN #不使用客戶申請作業時,才可按新增!
                   IF cl_chk_act_auth() THEN   
                        CALL i221_a()
                   END IF
               ELSE
                   CALL cl_err('','axm-222',1)
                   #不使用客戶申請作業時,才可按新增!
               END IF
               EXIT WHILE

           WHEN "query"
               IF cl_chk_act_auth() THEN  
                    CALL i221_q()
               END IF
               EXIT WHILE
           
           WHEN "modify"
               IF cl_chk_act_auth() THEN   
                  LET g_curs_index = ARR_CURR()
                  CALL i221_u()
               END IF
               EXIT WHILE
           
           WHEN "reproduce"
               IF g_aza.aza61 = 'N' THEN
                   IF cl_chk_act_auth() THEN
                      CALL i221_copy()
                   END IF
               ELSE
                   #參數設定使用客戶申請作業時,不可做複製!
                   CALL cl_err('','aim-156',1)
               END IF

          #No.FUN-9C0089 add begin------------------
           WHEN "exporttoexcel"
              IF cl_chk_act_auth() THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_occ_l),'','')
              END IF
          #No.FUN-9C0089 add -end-------------------
           
           WHEN "invalid"
               IF cl_chk_act_auth() THEN    
                  CALL i221_x()
               END IF
           
           WHEN "delete"
               IF cl_chk_act_auth() THEN   
                  CALL i221_r()
               END IF
           
           WHEN "credit_line"
               IF cl_chk_act_auth() THEN    
                  LET g_curs_index = ARR_CURR()
                  CALL i221_d()
               END IF
           
           WHEN "carry_credit"
               IF cl_chk_act_auth() THEN
                  CALL i221_credit_carry()
               END IF
           
#FUN-C50070 mark -begin--------------------------
#          WHEN "customer_address"
#              IF cl_chk_act_auth() THEN    
#                 CALL i221_1()
#              END IF
#FUN-C50070 mark --end---------------------------
           
           WHEN "customer_address1"
               IF cl_chk_act_auth() THEN
                  CALL i221_11(g_occ.occ01)
               END IF
           
           WHEN "customer_contact"
               IF cl_chk_act_auth() THEN   
                  CALL i221_2()
               END IF
           
           WHEN "customer_contact1"
               IF cl_chk_act_auth() THEN
                  CALL i221_22(g_occ.occ01)
                  LET INT_FLAG=0
               END IF
           
           WHEN "customer_notify_consignee"
               IF cl_chk_act_auth() THEN    
                  CALL i221_4()
               END IF
           
           WHEN "bank_list"
               IF cl_chk_act_auth() THEN   
                  IF NOT cl_null(g_occ.occ01)
                  THEN LET l_cmd = "axmi225 '",g_occ.occ01,"'" CLIPPED
                       CALL cl_cmdrun(l_cmd)
                  END IF
               END IF
           
           WHEN "customer_remark"
               IF cl_chk_act_auth() THEN   
                  CALL i221_6()
               END IF

           WHEN "cust_carry"
              IF cl_chk_act_auth() THEN
                 CALL ui.Interface.refresh()
                 CALL i221_carry()
              END IF
           
           WHEN "price_carry"
              IF cl_chk_act_auth() THEN
                 CALL ui.Interface.refresh()
                 CALL i221_price_carry()
              END IF
           
           WHEN "download"
              IF cl_chk_act_auth() THEN
                 CALL i221_download()
              END IF
           
           WHEN "qry_carry_history"
              IF cl_chk_act_auth() THEN
                 IF NOT cl_null(g_occ.occ01) THEN  
                    IF NOT cl_null(g_occ.occ246) THEN
                       SELECT gev04 INTO g_gev04 FROM gev_file
                        WHERE gev01 = '4' AND gev02 = g_occ.occ246
                    ELSE      #歷史資料,即沒有ima916的值
                       SELECT gev04 INTO g_gev04 FROM gev_file
                        WHERE gev01 = '4' AND gev02 = g_plant
                    END IF
                    IF NOT cl_null(g_gev04) THEN
                       LET l_cmd='aooq604 "',g_gev04,'" "4" "',g_prog,'" "',g_occ.occ01,'"'
                       CALL cl_cmdrun(l_cmd)
                    END IF
                 ELSE
                    CALL cl_err('',-400,0)
                 END IF
              END IF
           
           WHEN "customer_deal_kind"
              IF cl_chk_act_auth() THEN
                 CALL i221_8(g_occ.occ01,'1')
                 LET INT_FLAG=0
              END IF
           
           WHEN "customer_deal_catena"
              IF cl_chk_act_auth() THEN
                 CALL i221_8(g_occ.occ01,'3')
                 LET INT_FLAG=0
              END IF
           
           WHEN "client_price"             
              IF cl_chk_act_auth() THEN
                 IF NOT cl_null(g_occ.occ01) THEN
                    SELECT COUNT(*) INTO g_count
                      FROM tqo_file
                     WHERE tqo01 = g_occ.occ01
                    IF g_count = 0 THEN
                       LET g_cmd = "atmi228 '",g_occ.occ01,"' 'insert'"
                       CALL cl_cmdrun(g_cmd CLIPPED)
                       LET INT_FLAG=0
                    ELSE
                       LET g_cmd = "atmi228 '",g_occ.occ01,"' 'query'"
                       CALL cl_cmdrun(g_cmd CLIPPED)
                       LET INT_FLAG=0
                    END IF
                 END IF
              END IF
           
           WHEN "finance_info_maintenance"
              IF cl_chk_act_auth() THEN
                 IF NOT cl_null(g_occ.occ01) THEN
                    CALL i221_5(g_occ.occ01)
                    SELECT * INTO g_occ.* FROM occ_file
                     WHERE occ01=g_occ.occ01
                    LET INT_FLAG = 0
                 END IF
              END IF

           WHEN "confirm"
              IF cl_chk_act_auth() THEN
                 CALL i221_confirm()
                 CALL i221_show_pic()
              END IF
           
           WHEN "unconfirm"
              IF cl_chk_act_auth() THEN
                 CALL i221_unconfirm()
                 CALL i221_show_pic()
              END IF
           
           WHEN "hang"
              IF cl_chk_act_auth() THEN
                 CALL i221_hang()
                 CALL i221_show_pic()
              END IF
           
           WHEN "unhang"
              IF cl_chk_act_auth() THEN
                 CALL i221_unhang()
                 CALL i221_show_pic()
              END IF
           
           WHEN "untransaction"
              IF cl_chk_act_auth() THEN
                 CALL i221_untransaction()
                 CALL i221_show_pic()
              END IF
           
           WHEN "transaction"
              IF cl_chk_act_auth() THEN
                 CALL i221_transaction()
                 CALL i221_show_pic()
              END IF

           WHEN "internal_trade_data"
              IF cl_chk_act_auth() THEN
                 CALL i221_i_t()
              END IF

           WHEN "related_query"
               CALL s_cusqry(g_occ.occ01,'') #CHI-B60094 add ''
#             IF g_oaz.oaz96 = 'Y' THEN                         #FUN-C50136
#                LET g_msg = 'axmq274 ',g_occ.occ01              #FUN-C50136
#                CALL cl_cmdrun(g_msg)                          #FUN-C50136
#             ELSE                                              #FUN-C50136
#               CALL s_cusqry(g_occ.occ01)   #CHI-B60094 mark
#             END IF                                            #FUN-C50136
           
           WHEN "qry_product_inventory"
                 LET g_msg='axmq450'
                 CALL cl_cmdrun(g_msg)
           
           
           WHEN "output"
               IF cl_chk_act_auth() THEN   
                  CALL i221_out()
               END IF
           
           WHEN "help"
               CALL cl_show_help()
           
           WHEN "locale"
              CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()                 
              CALL cl_set_combo_lang("occ55")          
              CALL i221_show_pic()

           WHEN "exit"
              EXIT WHILE
           
           WHEN "related_document"
               IF cl_chk_act_auth() THEN
                  IF g_occ.occ01 IS NOT NULL THEN
                     LET g_doc.column1 = "occ01"
                     LET g_doc.value1 = g_occ.occ01
                     CALL cl_doc()
                  END IF
               END IF
           
           WHEN "abx_maintain"
              IF cl_chk_act_auth() THEN
                 CALL i221_abx()
              END IF
            
           WHEN "g_idle_seconds"
              CALL cl_on_idle()
           
           WHEN "about"
              CALL cl_about()      
           
           WHEN "controlg"     
              CALL cl_cmdask()     
           
           OTHERWISE 
               EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
#-----END MOD-A70076-----

#darcy:2022/04/13 s---
FUNCTION i221_set_occud02()
   DEFINE l_str      STRING
   DEFINE l_pmc01      LIKE pmc_file.pmc01
   DEFINE l_occ01      LIKE occ_file.occ01

   SELECT pmc01 INTO l_pmc01 FROM pmc_file 
    WHERE pmc24 = g_occ.occ11
   
   SELECT occ01 INTO l_occ01 FROM occ_file 
    WHERE occ11 = g_occ.occ11 
      AND occ <> g_occ.occ01

   IF NOT cl_null(l_pmc01) THEN 
      LET l_str="供应商:",l_pmc01
   END IF 
   IF NOT cl_null(l_occ01) THEN 
      LET l_str=" 客户:",l_occ01
   END IF 
   DISPLAY l_str TO occud02
END FUNCTION
#darcy:2022/04/13 e---

#darcy:2024/12/06 add s---
-- 锁住客户不允许出货
function i221_lock()
   if cl_null(g_occ.occ01) then
      CALL cl_err('',-400,0)
      return
   end if
   if g_occ.occ1004 <> '1' then
      call cl_err('','alm1072',1)
      return
   end if

   if g_occ.occud03 = 'Y' then
      let g_occ.occud03 = 'N'
   else
      let g_occ.occud03 = 'Y'
   end if

   if g_occ.occud03 = 'Y' then
      if not cl_confirm('cxm-046') then
         return
      end if
   else
      if not cl_confirm('cxm-048') then
         return
      end if
   end if 
   
   update occ_file set occud03 = g_occ.occud03
    where occ01 = g_occ.occ01
   if sqlca.sqlcode then
      call cl_err('upd occ_file',sqlca.sqlcode,1)
      return
   end if
   display by name g_occ.occud03

   if cl_confirm('cxm-047') then
      call i221_mail(g_occ.occud03 == 'Y')
   end if

end function

function i221_mail(p_lock)
   define p_lock   boolean
   define l_path   string
   define l_ok     varchar(1)
   define l_subject string

   let l_path = sfmt("/u1/out/%1.html",cs_uuid())

   # 产生邮件正文
   if p_lock then
      let l_subject = "客户不允许出货锁定通知"
   else
      let l_subject = "客户允许出货解锁通知"
   end if
   call cs_html_init(cl_get_progname(g_prog,g_lang),l_subject)
   call cs_html_main_field(ui.Interface.getRootNode(),"occ01,occ02,occ18,occ11,occ03,oca02,occ42,occud03,")
   call cs_html_write(l_path)

   call cs_mail_csmi111(l_subject,l_path,'','客户锁定通知')
      returning l_ok

   if l_ok then
      message "邮件通知成功"
   else
      message "邮件通知失败"
   end if
end function
#darcy:2024/12/06 add e---
