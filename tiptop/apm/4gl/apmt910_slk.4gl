# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmt910.4gl
# Descriptions...: 採購變更單價維護作業
# Date & Author..: 93/12/17 By  Fiona
# Date & Author..: 97/03/21 By  Kitty
# Modify.........: No.B448 010425 by linda add 委外採購單只能變更單價及交期
# Modify.........: No:7629 By Mandy 採購變更 新增一個項次時數量有問題
#                  單價未輸入時亦可以Pass,但無法Insert , 應該檢查新增時的各項資料
#                  變更單只有一項 ,且為新增時有誤
# Modify.........: No:7890 03/08/26 By Mandy 料件和單位加開窗
# Modify.........: No.MOD-480052 04/08/26 By Wiky 1.料號沒開窗圖形(可按 control-p 開窗, 應改為 BUTTONEDIT)
#                :                                2.單身用滑鼠會一值停在數量上
# Modify.........: No.MOD-480595 04/09/15 By Melody 1.付款方式欄位不見了 2.輸入順序修改
# Modify.........: No.MOD-490284 04/09/16 By Smapmin以彈跳視窗顯示警告訊息
# modify.........: No.MOD-480599 04/09/17 By Melody 有尚未收貨且已發出的PO的應該要可以變更才對
# Modify.........: NO.FUN-4A0032 04/10/05 By Echo 項次開窗
# Modify.........: NO.MOD-4A0148 04/10/13 By Mandy 單頭請加 show 廠商編號&簡稱 如此user 比較清楚此張採購單的供應商
# Modify.........: NO.MOD-4A0252 04/10/26 By Smapmin 幣別.付款條件.送貨地址.價格條件.發票地址開窗
# Modify.........: NO.MOD-4B0045 04/11/09 By Mandy 1.after field pna01 在判斷是否尚有未發出的變更單時, 應排除已作廢的單子
#                                                  2.建議用採購變更單本身的'變更序號' max+1, 目前是用 pmm03 (原PO變更序號)
# Modify.........: No.FUN-4C0056 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-4C0041 04/12/13 By Echo  查看"簽核狀況"的button
# Modify.........: No.MOD-520025 05/03/02 By ching 多角重拋檢查
# Modify         : No.MOD-530885 05/03/31 by alexlin VARCHAR->CHAR
# Modify         : No.MOD-540006 05/04/01 by Echo   送簽中可發出,沒有控管
# Modify         : No.MOD-540053 05/05/05 By Mandy apmp801 會被呼叫兩次
# Modify         : No.MOD-530022 05/05/05 By Mandy 變更單若為新增的項次,其變更後料號,數量,單價,單位,交貨日,不可空白!
# Modify         : No.FUN-550038 05/05/11 by Echo 複製功能，無判斷單別是否簽核，
#                                                 將確認與簽核流程拆開獨立。
# Modify.........: No.FUN-550089 05/05/17 By Danny 採購含稅單價
# Modify.........: NO.FUN-550060 05/05/30 By jackie 單據編號加大
# Modify.........: No.MOD-540061 05/06/11 By Echo 簽中的單子不可取消確認; 取消確認後，狀態碼必須變為「0:開立」
# Modify.........: No.MOD-560007 05/06/11 By Echo   重新定義整合FUN名稱
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.FUN-560106 05/06/19 By Elva  新增雙單位內容
# Modify.........: NO.FUN-570109 05/07/14 By Trisy key值可更改
# Modify.........: NO.MOD-580130 05/08/18 By Rosayu 發放按鈕改為發出,因為action:release有可能其他程式用到,所以release-->release_po
# Modify..........:No.MOD-590119 05/09/09 By Carrier 多單位set_origin_field修改
# Modify..........:No.FUN-590021 05/09/12 By Nicola 如果參數中請購與採購互相勾稽未打勾，則不做數量的判斷
# Modify.........: No.FUN-580147 05/09/15 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.MOD-5A0430 05/10/28 By Nicola 修改傳入參數的判斷
# Modify.........: No.TQC-5B0103 05/11/16 By yoyo 含稅單價的title沒有顯示，單價修改后，金額欄位沒有顯示
# Modify.........: No.MOD-5A0416 05/11/30 By Rosayu 1.變更單價時要考慮最近單價的超限率
# 2.採購參數設置 已收貨不可變更採購單價,如一張採購單有超過一個料件的採購，
#其中有一項未收貨，則此項可進入單價，然後用鼠標點擊已收貨行次的單價，也可以進入更改
# Modify.........: No.FUN-560212 05/12/21 By kim 當"變更後料號"有輸入,且前四碼為"MISC"時,變更後品名才允許輸入
# Modify.........: No.TQC-5C0105 05/12/21 By Nicola 部份資料會有欄位位移情形
# Modify.........: No.TQC-5C0109 05/12/22 By Nicola 單身若是變更料號打MISC,會帶出MISC的品名/規格,若是回頭再將料號改成非MISC的料號則不會重帶其品名/規格
# Modify.........: No.FUN-610018 06/01/17 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610067 06/02/06 By Smapmin 雙單位畫面調整
# Modify.........: No.MOD-630055 06/03/28 By pengu AFTER FIELD 單價/金額時出現取位錯誤
# Modify.........: No.TQC-610085 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-640435 06/04/12 By Sarah 委外代買時，如果是選擇(1對1),採購變更時代買的數量要卡不能修改
# Modify.........: No.MOD-640483 06/04/12 By Claire 找不到單號時顯示的單號是上一筆的舊值
# Modify.........: No.FUN-640184 06/04/19 By Echo 自動執行確認功能
# Modify.........: No.MOD-630130 06/04/24 By Claire update ecm321
# Modify.........: No.MOD-640574 06/04/27 By Claire 不使用計價單位不可顯示計價單位及計價數量欄位
# Modify.........: No.TQC-650108 06/05/25 By wujie  料件多屬性修改
# Modify.........: No.MOD-650101 06/05/30 By Pengu 若採單單己結案不可再允採購變更
# Modify.........: No.MOD-660038 06/06/20 By Pengu 變更數量應該用(實收量-退貨量) 加總後判斷
# Modify.........: No.TQC-660120 06/06/28 By Claire 沒有單身時update ecm321會當掉
# Modify.........: No.MOD-640426 06/07/05 By Pengu 變更之計價數量不可 < 已交量
# Modify.........: No.FUN-650166 06/07/27 By rainy 1.變更後採購單位，計價單位開窗
#                                                  2.交貨日期不可小於變更日期，變更日期不可小於採購日期
#                                                  3.計價單位不存在時不可存檔
#                                                  4.計價數量要依轉換率轉換
#                                                  5.單身無資料時不可確認
#                                                  6.單價查詢會無資料
# Modify.........: No.FUN-630026 06/08/09 By rainy pr/po若要勾稽，依百份比判斷數量關係
# Modify.........: No.FUN-650189 06/09/06 By Sarah 增加欄位pna15(變更理由)
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-690022 06/09/21 By jamie 判斷imaacti
# Modify.........: No.FUN-660067 06/10/13 By rainy 若設定Mail給廠商，則採購發出時依連絡人資料發出Javamail,附件為apmr910
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6B0032 06/11/10 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0086 06/11/16 By day 已審核單據作廢時要報錯
# Modify.........: No.FUN-690129 06/11/16 By rainy 請採購要勾稽時，改為可新增項次，但需輸入請購單號和請購單項次
#                                                  且輸入的請購單號+項次必須已存在且已確認
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-690101 06/12/08 By pengu 若幣別資料未改變時，單身的單位取幣別小數位數會錯誤。
# Modify.........: No.MOD-6A0168 06/12/11 By Claire 變更採購量時取計價數量重計pmm88,pmm88t
# Modify.........: No.MOD-6C0095 06/12/18 By kim 有關計價單位的問題並無考慮
# Modify.........: No.FUN-6C0055 07/01/08 By Joe 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.CHI-720006 07/02/11 By rainy 已作廢的採購量也會被加入
# Modify.........: No.MOD-720039 07/03/02 By pengu 不使用計價單位新增採購項次計價數量pmn87不可為pmn87 null
# Modify.........: No.FUN-730068 07/03/29 By kim 行業別架構
# Modify.........: No.MOD-740032 07/04/11 By claire pnb20應改為pnb87
# Modify.........: No.TQC-740121 07/04/17 By claire 相關文件的key應列入序號
# Modify.........: No.MOD-740334 07/04/23 By Pengu 執行[採購發出]時,系統提示的訊息為"是否確定發出變更訂單?"
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.TQC-760054 07/06/06 By xufeng azf_file的index是azf_01(azf01,azf02),但是在抓‘中文說明’內容時，WHERE條件卻只有 azf01 = g_xxx
# Modify.........: No.TQC-760049 07/06/10 By claire 調整MOD-6C0095 計價單位及計價數量錯誤
# Modify.........: No.FUN-710060 07/08/07 By jamie 料件供應商管制建議依品號設定;程式中原判斷sma63=1者改為判斷ima915=2 OR 3
# Modify.........: No.MOD-780032 07/08/07 By claire 若p_per將pnb04a改為不可輸入時,料號資訊沒帶出直接就跳到數量欄位輸入
# Modify.........: No.MOD-780081 07/08/15 By claire 更新資料時未考慮第二個key值
# Modify.........: No.TQC-790063 07/09/11 By claire 輸入請購單號未確認請購單的狀況碼(如結案單仍可輸入)
# Modify.........: No.MOD-7A0054 07/10/11 By claire 考慮sma108參數值,單價不應該可以變更
# Modify.........: No.MOD-7A0067 07/10/15 By claire 使用母子單位,變更料號時也應帶出其單位及計價單位
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/15 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.TQC-7C0002 07/12/01 By wujie  已有入庫發票，再進行采購變更，在變更單頭的幣種后，點擊“審核”、“發出”，系統沒有報錯信息。
#                                                   應在發出之前先判斷是否已有收貨單，若已有則單頭資料不可變更
# Modify.........: No.FUN-7B0142 07/12/11 By jamie 不應在rpt寫入各語言的title，要廢除這樣的寫法(程式中使用g_rlang再切換)，報表列印不需參考慣用語言的設定。
# Modify.........: No.FUN-7C0036 07/12/13 By jamie g_rlang->g_lang
# Modify.........: No.FUN-810014 08/01/09 By arman 增加制單號一列#服飾版程序
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7B0018 08/02/16 By hellen 行業別拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.CHI-820014 08/03/20 By claire 單價超限率(sma84)的設定應以原始取出單價與目前交易單價比較
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業別拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830121 08/03/27 By arman 使用多屬性時對料號控管
# Modify.........: No.FUN-830116 08/03/27 By arman
# Modify.........: No.MOD-840076 08/04/11 By Dido 取消 apm-053 檢核 
# Modify.........: No.FUN-840042 08/04/14 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.MOD-870092 08/07/10 By Smapmin 比較價差的方式應使用s_defprice()
# Modify.........: No.MOD-860153 08/07/15 By Pengu 設定請購與採購勾稽時委外工單變更數量不應控管數量不可大於請購量
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.FUN-870168 08/07/30 By Smapmin 在變更發出時判斷是否已發出，若已發出請show訊息
# Modify.........: No.CHI-870031 08/08/04 By Smapmin 修改請購與採購數量勾稽的抓取邏輯
# Modify.........: No.MOD-880030 08/08/06 By Smapmin 修改採購單位後,未重新default計價單位
# Modify.........: NO.FUN-880016 08/08/21 BY yiting 增加GPM控管
# Modify.........: No.MOD-830110 08/09/05 By chenl 對g_pnb80進行賦值。
# Modify.........: No.MOD-880158 08/09/09 By Smapmin 於採購變更單新增採購單項次時,單價預設值應比照採購單取價邏輯處理.
# Modify.........: NO.FUN-870117 08/09/22 By jan 服飾版
# Modify.........: NO.FUN-890100 08/09/22 By hongmei pnbislk01--->pnbislk01a 增加pnbislk01b  
# Modify.........: NO.FUN-8A0054 08/10/13 By sabrina 若沒有勾選〝與GPM整合〞，則不做GPM控管
# Modify.........: No.CHI-8A0022 08/10/20 By Smapmin 取單價時,考慮是否走製程/委外
# Modify.........: No.MOD-8A0229 08/10/24 By Smapmin 製程委外有變更數量時,才檢核與WIP量的差異
# Modify.........: No.MOD-8B0047 08/11/10 By Smapmin 調整單價entry/noentry的控管
# Modify.........: No.MOD-8B0222 08/11/21 By Smapmin 採購單位未抓取,導致判斷單位轉換率時出錯.
# Modify.........: No.MOD-8B0273 08/11/28 By chenyu 采購單單頭單價含稅時，未稅單價=未稅金額/數量
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.MOD-8C0196 08/12/22 By Smapmin 修改請購與採購數量勾稽時,採購數量的抓取
# Modify.........: No.MOD-8C0295 08/12/31 By Smapmin 修改錯誤的欄位名稱
# Modify.........: No.MOD-910035 09/01/06 By Smapmin 無變更資料時,整張單據需刪除
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-920044 09/02/04 By Smapmin 訂單轉入採購單,採購變更時不受sma32參數的影響
# Modify.........: No.MOD-920087 09/02/06 By Smapmin 訂單轉入採購單,採購變更時不可新增項次
# Modify.........: No.TQC-910033 09/02/12 by ve007 抓取作業編號時，委外要區分制程和非制程 
# Modify.........: No.TQC-930041 09/03/05 By chenyu chk_qty()中，l_item取不到值時，無法進行下面的判斷
# Modify.........: No.MOD-930089 09/03/09 By rainy 1.當單頭幣別有修改時，出現提示"幣別/匯率已改，請修改單身金額"
#                                                  2.同時變更單頭幣別及單身單價時，是以新的單價*舊幣別回寫最近採購近價，應以新的單價*新的幣別回寫
# Modify.........: No.FUN-920186 09/03/18 By lala  理由碼必須為采購原因
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.MOD-930147 09/03/27 By Smapmin 採購數量不可大於WIP量的檢核提前於輸入數量時check.
# Modify.........: No.FUN-930113 09/03/30 By mike 將oah-->pnz
# Modify.........: No.MOD-940071 09/04/14 By Smapmin 於確認段再次檢核不可小於已收貨量
# Modify.........: No.TQC-940137 09/04/23 By sherry 已有入庫量的采購單，變更料號與原料號相同也可以通過
# Modify.........: No.MOD-890145 09/05/11 by xiaofeizhu 在審核和發出的時候判斷采購單是否有對應的收貨單,如果有則不可審核和發
# Modify.........: No.FUN-950007 09/05/12 By sabrina 跨主機資料拋轉，shell手工調整
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()      
# Modify.........: No.MOD-950235 09/05/22 by xiaofeizhu 采購變更單發出和審核時，不應通過是否有收貨單來管控
# Modify.........: No.TQC-950160 09/05/25 By chenyu 訂單轉入的采購單，變更時單身應該顯示訂單單號和訂單項次
# Modify.........: No.MOD-960103 09/07/07 By Smapmin 把原"採購發出"時，透過java mail發mail通知廠商的功能，改寫為新的透過cr以附件方式發出mail通知廠商
# Modify.........: No.MOD-960231 09/07/16 By Smapmin 預設計價單位時有錯
# Modify.........: No.MOD-970212 09/07/24 By Smapmin 只變更單價時,計價單位/數量不應改變
# Modify.........: No.FUN-980006 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.TQC-980279 09/08/28 By sherry 請購的料號若為統購的，不可以打采購單  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980071 09/08/18 By chenmoyan 采購發出時，pmd08='Y',才發出
# Modify.........: No.FUN-980093 09/09/22 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-990199 09/09/29 By Smapmin 初始的未稅/含稅金額未依舊的幣別位數取位
# Modify.........: No.MOD-980254 09/10/06 By Smapmin 1.若已存在收貨單,單頭的欄位不可修改.
#                                                    2.check單身數量是否有小於已收貨數量,發出段需再做一次控管.
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No:MOD-9B0165 09/11/27 By Smapmin 修改變更的項次後,變更前的資料未更新
#                                                    變更後欄位若已有輸入,此時再修改變更項次,則各欄位的檢核點會被忽略-->故變更後欄位若已有輸入,則不允許修改項次.
# Modify.........: No:FUN-9C0083 09/12/16 By mike 将call s_defprice()改为call s_defprice_new() 
# Modify.........: No:MOD-9C0280 09/12/19 By jan pnb041a 為空，則給pnb041
# Modify.........: No:FUN-9C0071 10/01/15 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30004 10/03/02 By Smapmin 進入單身時重新抓取單頭資料
# Modify.........: No:FUN-A20057 10/03/04 By Smapmin 增加變更人員
# Modify.........: No:MOD-A50031 10/05/07 By Smapmin 輸入與確認時,若為新增的採購項次,數量要控管不可為NULL或<=0
# Modify.........: No:FUN-A60011 10/06/07 By Carrier ecm321更新时,要检查是否对ecm52做更新
# Modify.........: No.FUN-A60076 10/07/02 By vealxu 製造功能優化-平行製程
# Modify.........: No.FUN-A50102 10/07/19 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A70130 10/07/27 By Smapmin 數量不可小於已收貨量,要排除樣品的已收貨量
# Modify.........: No.TQC-A70091 10/08/03 By destiny 审核时如该采购单项次已有对应的收货单则不允许审核
# Modify.........: No.FUN-A80142 10/09/01 By lilingyu 採購單變更改良
# Modify.........: No.FUN-A90009 10/09/15 By destiny B2B改良
# Modify.........: No:MOD-A10181 10/09/29 By sabrina apm-411判斷不一致
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.MOD-AA0175 10/10/27 By lilingyu 當有收貨單時,對應的參數sma108 ='Y',變更單審核時仍然不讓審核
# Modify.........: No:MOD-A90171 10/11/04 By Smapmin 代採逆拋,目的站已產生出貨單,sma108為N時不可以修改單價
# Modify.........: No.FUN-AB0025 10/11/10 By chenying 修改料號開窗
# Modify.........: No.TQC-AB0025 10/11/24 By chenying 修改Sybse問題
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No.MOD-AC0377 10/12/29 By chenying 輸入變更單單身後，點選確定按鈕後,報錯
# Modify.........: No:MOD-B10091 11/01/13 By Summer aim-411訊息改為-->不可小於已收貨計價數量
# Modify.........: No:MOD-B10138 11/01/24 By Summer 調整取位方式 
# Modify.........: No:MOD-B30413 11/03/16 By Summer 追CHI-A40019單,單頭的供應商.幣別.採購日期.稅別.稅率等欄位有異動時,詢問是否update單身單價
# Modify.........: No:MOD-B30307 11/03/18 By chenying 變更前後送貨地址與變更前後價格條件對調位置
# Modify.........: No:MOD-B30666 11/03/31 By Summer 此採購料號已有交貨,一併將品名,規格欄位清空
# Modify.........: No.FUN-B30219 11/04/06 By chenmoyan 去除DUAL
# Modify.........: No:MOD-B40038 11/04/18 By Summer 請購單號與項次entry/required的控管,應同採購單的作法 
# Modify.........: No:CHI-B40018 11/04/19 By Summer 新增原先沒有的採購項次時,變更前的數量/單價..不應default 0 
# Modify.........: No:TQC-B40209 11/04/25 By lilingyu EF簽核相關問題修改
# Modify.........: No:MOD-B50040 11/05/09 By Summer 代採逆拋的目的站已產生出貨單且sma108為N時，不可以修改單價,應加上單身項次 
# Modify.........: No:FUN-B50158 11/05/26 By lixiang 更改幣別後進行確認
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-B60122 11/06/15 By JoHung 原MOD-B920044 採購單為訂單轉入時的判斷，改為採購單不為人工輸入或請購單轉入或電子採購，或者採購單性質為委外
# Modify.........: No:CHI-B50016 11/07/07 By Summer 採購變更單Blanket PO數量控卡與回寫 
# Modify.........: No:MOD-B80343 11/09/03 By johung ON ROW CHANGE只更新單身變更後欄位，改為更新單身全部欄位
# Modify.........: No:MOD-B90099 11/09/14 By suncx 若單身為修改原採購單單身則不需要從新取價，若為新增單身則重新取價
# Modify.........: No:MOD-B90119 11/09/14 By suncx 採購與請購勾稽時，不需要管控請購單號和項次必輸
# Modify.........: No.TQC-BB0026 11/11/03 By destiny oriu,orig不能查询
# Modify.........: No:FUN-910088 12/01/31 By chenjing 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.MOD-BB0334 11/12/01 By Vampire 重覆計算數量
# Modify.........: No:MOD-BC0164 12/02/03 By Summer 將TQC-A70091與MOD-AA0175的程式還原 
# Modify.........: No:MOD-BA0204 12/02/04 By Vampire CALL s_defprice_new 參數傳遞順序錯誤
# Modify.........: No:FUN-C20026 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:MOD-C10145 12/02/09 By jt_chen 因料件檢查會NEXT FIELD pnb04a,但請採勾稽時pnb04a是no entry.
# Modify.........: No:TQC-C20183 12/02/16 By fengrui 增加數量欄位小數取位
# Modify.........: No:TQC-C10099 12/02/22 By SunLM 去除交貨日期的非工作日
# Modify.........: No:MOD-C30043 12/03/07 By Summer 增加用新舊值方式判斷pnb20a是否變更,再LET g_change='Y' 
# Modify.........: No:MOD-C30361 12/03/12 By zhuhao 請增加判斷變更後料號為空,且變更前料號為MISC時,可輸入品名欄位
# Modify.........: No:TQC-C30173 12/03/14 By lixiang 服飾流通業下的採購變更單的修改
# Modify.........: No:TQC-C30231 12/03/14 By Vampire 修正 MOD-C300430 
# Modify.........: No:MOD-C30372 12/03/15 By yuhuabao 只輸入請購單項次時會控卡apm-116,故清空請購單號欄位後,可比照控管apm-116
# Modify.........: No:MOD-C30673 12/03/14 By Vampire 判斷pnb90與pnb91為空時,LET它等於變更前的值
# Modify.........: No:MOD-C30760 12/03/14 By SunLM 采購單變更后,修正pnb87a和pnb86a有時候為null的情況
# Modify.........: No:FUN-C30031 12/03/22 By Sakura 變更前/後付款條件及變更前/後價格條件顯示名稱
# Modify.........: No:FUN-C40089 12/04/30 By bart 原先以參數sma112來判斷採購單價可否為0的程式,全部改成判斷採購價格條件(apmi110)的pnz08
# Modify.........: No:MOD-C30904 12/05/11 By Vampire 採購日期改傳採購變更單的變更日期
# Modify.........: No:FUN-C50076 12/05/18 By bart 更改錯誤訊息代碼mfg3525->axm-627
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:MOD-C30069 12/05/30 By jt_chen 參數設勾稽請採購,採購變更時不可變更料號,將請購單號、項次、料號變更後的值還原回變更前的值
# Modify.........: No:TQC-C50238 12/05/30 By zhuhao 料號控管
# Modify.........: No:MOD-BB0264 12/06/07 By Vampire Blanket已轉數量未轉換單位
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:MOD-C50198 12/06/15 By Vampire 原本修改邏輯用OR,會導致計價數量或計價單位只要有一個為空,兩個欄位都會還原回變更前的值
# Modify.........: No.FUN-C30081 12/07/03 By wangwei 原採購單若有輸入工單號碼,應控卡變更數量不應大於工單數量 
# Modify.........: No:MOD-C80164 12/09/17 By jt_chen 調整採購單變更單,採購變更發出,apm-411的控卡應再扣除退貨換貨量(pmn58)
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.FUN-CC0094 13/01/21 By xianghui 增加發出人員，日期時間
# Modify.........: No:MOD-D10200 13/01/31 By jt_chen 調整請購與採購互相勾稽,請購單號-項次不可空白
# Modify.........: No:MOD-CC0122 13/02/01 By Elise 計算pmn88及pmn88t的公式與apmt540不同,差在MOD-B10138|CHI-AC0016這兩張單的調整
# Modify.........: No:MOD-CB0216 13/02/01 By jt_chen 調整單身自動帶入需給g_pnb03_o值
# Modify.........: No:MOD-D10206 13/02/05 By jt_chen 依apmi110決定欄位是否可維護
# Modify.........: No:FUN-D20025 13/02/19 By chenying 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D10118 13/02/22 By SunLM 採購單別smy81='N',则可以请购单号/项次可以为空
# Modify.........: No.CHI-C50063 13/02/23 By Elise 單身欄位開放查詢
# Modify.........: No.CHI-CB0002 13/02/25 By Elise 確認段控卡，預算認列
# Modify.........: No.TQC-D20066 13/03/04 By SunLM 因規划有變，暫時還原FUN-D10118的所以調整。
# Modify.........: No:MOD-D30073 13/03/13 By Vampire 價格條件設定不能人工輸入,且單價不可為零,造成無窮迴圈
# Modify.........: No:MOD-D30186 13/03/21 By Vampire 1.當自動展單身時，g_rec_b 預設給0，導致g_rec_b > l_ac 判斷錯誤，g_pnb03_o 給錯預設值，UPDATE 錯誤資料
#                                                    2.單身 ON ROW CHANGE UPDATE 單身 kEY值 g_pnb_t.pnb03 改為 g_pnb03_o
#                                                    3.chk_qty() 計算 l_new2 的SQL 若未更請購單 pnb90,pnb91 為NULL，導致會不會計算到數量，改在FOREACH判斷欄位為空，改判斷陣列值
#                                                    4.l_old1 重複計算請購單數量， mark 相關程式 
# Modify.........: No.CHI-D10010 13/03/29 By Elise 變更單比照採購單新增時的單別權限控卡
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.CHI-D30023 13/04/18 By Elise 開放代採正拋有最終供應商在最終站變更採購單修改金額欄位
# Modify.........: No:TQC-D50071 13/07/15 By qirl 沒有使用電子採購系統的情況下，畫面上有電子採購的欄位：【電子採購序號】

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pna           RECORD LIKE pna_file.*,       #採購單號 (假單頭)
    g_pna_t         RECORD LIKE pna_file.*,       #採購單號 (舊值)
    g_pna_o         RECORD LIKE pna_file.*,       #採購單號 (舊值)
    g_pna01_t       LIKE pna_file.pna01,          #變更單號 (舊值)
    g_pna02_t       LIKE pna_file.pna02,          #變更序號 (舊值)   #MOD-780081 add
 
    g_pnb           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        pnb03       LIKE pnb_file.pnb03,   #項次
        before      LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
        pnb90b      LIKE pnb_file.pnb90,   #變更前請購單號
        pnb91b      LIKE pnb_file.pnb91,   #變更前請購單號項次
        pnbislk01b  LIKE pnbi_file.pnbislk01b,   #NO.FUN-810014  #No.FUN-870117
        pnb04b      LIKE pnb_file.pnb04b,  #變更前料號(變更前)
        pnb041b     LIKE pnb_file.pnb041b, #品名
        ima021b     LIKE ima_file.ima021,  #規格
        pnb20b      LIKE pnb_file.pnb20b,  #數    量
        pnb07b      LIKE pnb_file.pnb07b,  #單    位
        pnb83b      LIKE pnb_file.pnb83b,
        pnb84b      LIKE pnb_file.pnb84b,
        pnb85b      LIKE pnb_file.pnb85b,
        pnb80b      LIKE pnb_file.pnb80b,
        pnb81b      LIKE pnb_file.pnb81b,
        pnb82b      LIKE pnb_file.pnb82b,
        pnb86b      LIKE pnb_file.pnb86b,
        pnb87b      LIKE pnb_file.pnb87b,
        pnb31b      LIKE pnb_file.pnb31b,  #單    價
        pnb32b      LIKE pnb_file.pnb32b,  #含稅單價   No.FUN-550089
        totb        LIKE pnb_file.pnb31b,  #單    價
        tottb       LIKE pnb_file.pnb32b,  #單    價   No.FUN-610018
#FUN-A80142 --begin--
        pnb34b      LIKE pnb_file.pnb34b,
        pnb35b      LIKE pnb_file.pnb35b,
        pnb36b      LIKE pnb_file.pnb36b, #TQC-D20066
#FUN-A80142 --end--        
        pnb33b      LIKE pnb_file.pnb33b,  #交 貨 日
        after       LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
        pnb90       LIKE pnb_file.pnb90,   #變更後請購單號
        pnb91       LIKE pnb_file.pnb91,   #變更後請購單號項次
        pnbislk01a  LIKE pnbi_file.pnbislk01a,  #No.FUN-870117
        pnb04a      LIKE pnb_file.pnb04a,  #變更後料號(變更後)
        pnb041a     LIKE pnb_file.pnb041a, #品名
        ima021a     LIKE ima_file.ima021,  #規格
        pnb20a      LIKE pnb_file.pnb20a,  #數    量
        pnb07a      LIKE pnb_file.pnb07a,  #單    位
        pnb83a      LIKE pnb_file.pnb83a,
        pnb84a      LIKE pnb_file.pnb84a,
        pnb85a      LIKE pnb_file.pnb85a,
        pnb80a      LIKE pnb_file.pnb80a,
        pnb81a      LIKE pnb_file.pnb81a,
        pnb82a      LIKE pnb_file.pnb82a,
        pnb86a      LIKE pnb_file.pnb86a,
        pnb87a      LIKE pnb_file.pnb87a,
        pnb31a      LIKE pnb_file.pnb31a,  #單    價
        pnb32a      LIKE pnb_file.pnb32a,  #含稅單價   No.FUN-550089
        tota        LIKE pnb_file.pnb31a,  #單    價
        totta       LIKE pnb_file.pnb32a,  #單    價   No.FUN-610018
#FUN-A80142 --begin--
        pnb34a      LIKE pnb_file.pnb34a,
        pnb35a      LIKE pnb_file.pnb35a,
        pnb36a      LIKE pnb_file.pnb36a,
#FUN-A80142 --end--         
        pnb33a      LIKE pnb_file.pnb33a,  #交 貨 日
        pnb50       LIKE pnb_file.pnb50    #備    註
                    END RECORD,                  
    g_pnb_t         RECORD                 #程式變數 (舊值)
        pnb03       LIKE pnb_file.pnb03,   #項次
        before      LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
        pnb90b      LIKE pnb_file.pnb90,   #變更前請購單號
        pnb91b      LIKE pnb_file.pnb91,   #變更前請購單號項次
        pnbislk01b   LIKE pnbi_file.pnbislk01b,   #NO.FUN-810014  #No.FUN-870117
        pnb04b      LIKE pnb_file.pnb04b,  #變更前料號(變更前)
        pnb041b     LIKE pnb_file.pnb041b, #品名
        ima021b     LIKE ima_file.ima021,  #規格
        pnb20b      LIKE pnb_file.pnb20b,  #數    量
        pnb07b      LIKE pnb_file.pnb07b,  #單    位
        pnb83b      LIKE pnb_file.pnb83b,
        pnb84b      LIKE pnb_file.pnb84b,
        pnb85b      LIKE pnb_file.pnb85b,
        pnb80b      LIKE pnb_file.pnb80b,
        pnb81b      LIKE pnb_file.pnb81b,
        pnb82b      LIKE pnb_file.pnb82b,
        pnb86b      LIKE pnb_file.pnb86b,
        pnb87b      LIKE pnb_file.pnb87b,
        pnb31b      LIKE pnb_file.pnb31b,  #單    價
        pnb32b      LIKE pnb_file.pnb32b,  #含稅單價   No.FUN-550089
        totb        LIKE pnb_file.pnb31b,  #單    價
        tottb       LIKE pnb_file.pnb32b,  #單    價   No.FUN-610018
#FUN-A80142 --begin--
        pnb34b      LIKE pnb_file.pnb34b,
        pnb35b      LIKE pnb_file.pnb35b,
        pnb36b      LIKE pnb_file.pnb36b,
#FUN-A80142 --end--     
        pnb33b      LIKE pnb_file.pnb33b,  #交 貨 日
        after       LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
        pnb90       LIKE pnb_file.pnb90,   #變更後請購單號
        pnb91       LIKE pnb_file.pnb91,   #變更後請購單號項次
        pnbislk01a  LIKE pnbi_file.pnbislk01a,  #No.FUN-870117
        pnb04a      LIKE pnb_file.pnb04a,  #變更後料號(變更後)
        pnb041a     LIKE pnb_file.pnb041a, #品名
        ima021a     LIKE ima_file.ima021,  #規格
        pnb20a      LIKE pnb_file.pnb20a,  #數    量
        pnb07a      LIKE pnb_file.pnb07a,  #單    位
        pnb83a      LIKE pnb_file.pnb83a,
        pnb84a      LIKE pnb_file.pnb84a,
        pnb85a      LIKE pnb_file.pnb85a,
        pnb80a      LIKE pnb_file.pnb80a,
        pnb81a      LIKE pnb_file.pnb81a,
        pnb82a      LIKE pnb_file.pnb82a,
        pnb86a      LIKE pnb_file.pnb86a,
        pnb87a      LIKE pnb_file.pnb87a,
        pnb31a      LIKE pnb_file.pnb31a,  #單    價
        pnb32a      LIKE pnb_file.pnb32a,  #含稅單價   No.FUN-550089
        tota        LIKE pnb_file.pnb31a,  #單    價
        totta       LIKE pnb_file.pnb32a,  #單    價   No.FUN-610018
#FUN-A80142 --begin--
        pnb34a      LIKE pnb_file.pnb34a,
        pnb35a      LIKE pnb_file.pnb35a,
        pnb36a      LIKE pnb_file.pnb36a,
#FUN-A80142 --end--     
        pnb33a      LIKE pnb_file.pnb33a,  #交 貨 日
        pnb50       LIKE pnb_file.pnb50    #備    註
                    END RECORD,
    g_pnb03_o       LIKE pnb_file.pnb03,  #MOD-9B0165 
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_pnb04             LIKE pnb_file.pnb04b,
    g_pnb80             LIKE pnb_file.pnb80b,
    g_pnb81             LIKE pnb_file.pnb81b,
    g_pnb82             LIKE pnb_file.pnb82b,
    g_pnb83             LIKE pnb_file.pnb83b,
    g_pnb84             LIKE pnb_file.pnb84b,
    g_pnb85             LIKE pnb_file.pnb85b,
    g_pnb86             LIKE pnb_file.pnb86b,
    g_pnb87             LIKE pnb_file.pnb87b,
    g_img09             LIKE img_file.img09,
    g_ima44             LIKE ima_file.ima44,
    g_ima31             LIKE ima_file.ima31,
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_ima908            LIKE ima_file.ima908,
    g_factor            LIKE pmn_file.pmn09,
    g_factor2           LIKE pmn_file.pmn09,   #CHI-870031
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10,
    g_flag              LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    g_buf               LIKE gfe_file.gfe02,
    g_change            LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
    l_gae04             LIKE gae_file.gae04,    #No.FUN-680136 VARCHAR(255) #TQC-5B0103
    l_flag              LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    g_argv1     	LIKE pmn_file.pmn01,    # INPUT ARGUMENT - 1
    g_argv2             LIKE pmn_file.pmn02,    #FUN-580147
    g_argv3             STRING,                 #FUN-640184
    g_delete            LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
    g_cmd               LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
    g_pmm               RECORD LIKE pmm_file.*,
    g_pmm02             LIKE pmm_file.pmm02,
    g_pmm43             LIKE pmm_file.pmm43,    #No.FUN-550089
    g_gec07             LIKE gec_file.gec07,    #No.FUN-550089
    g_gec05             LIKE gec_file.gec05,    #MOD-CC0122 add
    g_rec_b             LIKE type_file.num5,    #單身筆數  #No.FUN-680136 SMALLINT
    g_t1                LIKE oay_file.oayslip,  #No.FUN-550060  #No.FUN-680136 VARCHAR(05)
    g_sta               LIKE ze_file.ze03,      #No.FUN-680136 VARCHAR(16) #No.FUN-550060
    l_ac_1              LIKE type_file.num5,    #No.FUN-680136 SMALLINT #TQC-660120
    l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE   g_laststage    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  #FUN-580147
DEFINE   p_row,p_col    LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE   g_forupd_sql   STRING     #SELECT ...  FOR UPDATE SQL
DEFINE   g_chr          LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE   g_chr2         LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(72)
DEFINE   g_before_input_done  LIKE type_file.num5     #NO.FUN-570109  #No.FUN-680136 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE   g_smy62        LIKE smy_file.smy62     #No.TQC-650108
DEFINE   g_error        LIKE type_file.chr10
DEFINE   g_term         LIKE pna_file.pna10     #NO.FUN-930148
DEFINE   g_price        LIKE pna_file.pna09     #No.FUN-930148
DEFINE   l_dbs_tra      LIKE azw_file.azw05    #FUN-980093 add
DEFINE   l_plant_new    LIKE azp_file.azp01    #FUN-980093 add
DEFINE   b_pnbi         RECORD LIKE pnbi_file.*        #NO.FUN-810014
DEFINE   g_pmn73        LIKE pmn_file.pmn73,    #TQC-AC0257 add
         g_pmn74        LIKE pmn_file.pmn74     #TQC-AC0257 add
DEFINE   g_flag1        LIKE type_file.chr1    #MOD-B30413 add
DEFINE   g_blanketpo    LIKE type_file.chr1    #CHI-B50016 add
DEFINE   b_pnb          RECORD LIKE pnb_file.* #MOD-B80343 add
DEFINE   g_retype       LIKE type_file.num5    #MOD-BB0334 add
DEFINE   g_pnz08        LIKE pnz_file.pnz08    #FUN-C40089
DEFINE   g_pnz04        LIKE pnz_file.pnz04    #MOD-D30073 add
DEFINE   g_pmn41        LIKE pmn_file.pmn41    #FUN-C30081 add   #工單號碼
DEFINE   g_chkpnb31_flag LIKE type_file.chr1   #MOD-D10206 add
DEFINE   g_chkpnb32_flag LIKE type_file.chr1   #MOD-D10206 add
#CHI-CB0002---add---S   
DEFINE g_bookno1     LIKE aza_file.aza81
DEFINE g_bookno2     LIKE aza_file.aza82
#CHI-CB0002---add---E 
DEFINE p_last        LIKE type_file.num5       #CHI-D30023 add
DEFINE p_last_plant  LIKE azp_file.azp01       #CHI-D30023 add
 
MAIN
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP  # ,                  #FUN-A80142
       #    FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730068
                                               #FUN-A80142 mark 
       DEFER INTERRUPT
    END IF

    LET g_prog = "apmt910_slk"
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("APM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    LET g_wc2=' 1=1'
    LET g_forupd_sql = "SELECT * FROM pna_file WHERE pna01 = ? AND pna02 = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t910_cl CURSOR FROM g_forupd_sql
 
    LET g_pna.pna01 = NULL
    LET g_argv1      = ARG_VAL(1)          # 參數值(1) - 採購單號
    LET g_argv2      = ARG_VAL(2)          # 參數值(1) - 採購單號   #FUN-580147
    LET g_argv3      = ARG_VAL(3)          # 參數值(3) - 功能       #FUN-640184
 
    IF fgl_getenv('EASYFLOW') = "1" THEN
       LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
       LET g_argv2 = aws_efapp_wsk(2)   #參數:key-2
    END IF

    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
       OPEN WINDOW t910_w WITH FORM "apm/42f/apmt910"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       CALL cl_ui_init()

#No:TQC-D50071----add--star---
       IF g_aza.aza95 = 'N' THEN
          CALL cl_set_comp_visible("pna17",FALSE)
       END IF
#No:TQC-D50071----add--end---
    END IF
 
    #建立簽核模式時的 toolbar icon
    CALL aws_efapp_toolbar()    #FUN-580147
 
    IF g_aza.aza71 MATCHES '[Yy]' THEN 
       CALL aws_gpmcli_toolbar()
       CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
    ELSE
       CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
    END IF
 
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv3
          WHEN "efconfirm"
             CALL t910_q()
             CALL t910_y_chk()          #CALL 原確認的 check 段
             IF g_success = "Y" THEN
                LET l_ac = 1 
                CALL t910_y_upd()       #CALL 原確認的 update 段
             END IF
             EXIT PROGRAM
          OTHERWISE
             CALL t910_q()
       END CASE
    END IF
 
    CALL t910_def_form()                     #FUN-640184
 
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,  #FUN-D20025 add undo_void                                confirm, undo_confirm, easyflow_approval, release_po,memo") #TQC-B40209 add memo
         RETURNING g_laststage
 
    CALL t910_menu()
    CLOSE t910_cl
    CLOSE WINDOW t910_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION t910_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
       IF NOT cl_null(g_argv1) THEN
          LET g_wc = "pna01 = '",g_argv1,"' "
          IF NOT cl_null(g_argv2) THEN
             LET g_wc = g_wc," AND pna02='",g_argv2,"'"
          END IF
       LET g_wc2= " 1=1"
       LET g_pna.pna01=g_argv1
       DISPLAY BY NAME g_pna.pna01
       LET g_pna.pna02=g_argv2       #FUN-580147
       DISPLAY BY NAME g_pna.pna02   #FUN-580147
    ELSE
       CLEAR FORM                #NO:7203
       CALL g_pnb.clear()
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pna.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON pna01,pna02,pna04,pna15,pna16,   #FUN-650189 add pna15   #FUN-A20057 add pna16
                                #pna08,pna10,pna11,pna09,pna12,   #MOD-B30307 mark 
                                 pna08,pna10,pna09,pna11,pna12,   #MOD-B30307 add
                                #pna08b,pna10b,pna11b,pna09b,pna12b, #MOD-B30307 mark
                                 pna08b,pna10b,pna09b,pna11b,pna12b, #MOD-B30307 add
                                 pna14,pna05,pna13,pnaconf,
                                 pnauser,pnagrup,pnamodu,pnadate,pnaacti, 
                                 pnaoriu,pnaorig,  #TQC-BB0026
                                 pnasendu,pnasendd,   #FUN-CC0094 add
                                 pnaud01,pnaud02,pnaud03,pnaud04,pnaud05,
                                 pnaud06,pnaud07,pnaud08,pnaud09,pnaud10,
                                 pnaud11,pnaud12,pnaud13,pnaud14,pnaud15
              
          BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
          ON ACTION CONTROLP
             CASE      #查詢符合條件的單號
                WHEN INFIELD(pna01)
                     CALL q_pmm2(TRUE,TRUE,g_pna.pna01,'2') RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna01
                     NEXT FIELD pna01
 #MOD-4A0252幣別.付款條件.送貨地址.價格條件.發票地址開窗
                WHEN INFIELD(pna11) #查詢地址資料檔 (0:表送貨地址)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna11
                     NEXT FIELD pna11
                WHEN INFIELD(pna12) #查詢地址資料檔 (1:表帳單地址) #BugNo:6478
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna12
                     NEXT FIELD pna12
                WHEN INFIELD(pna10) #查詢付款條件資料檔(pma_file)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pma"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna10
                     NEXT FIELD pna10
                WHEN INFIELD(pna09) #價格條件
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pnz01" #FUN-930113
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna09
                     NEXT FIELD pna09
                WHEN INFIELD(pna08) #查詢幣別資料檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna08
                     NEXT FIELD pna08
                WHEN INFIELD(pna11b) #查詢地址資料檔 (0:表送貨地址)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna11b
                     NEXT FIELD pna11b
                WHEN INFIELD(pna12b) #查詢地址資料檔 (1:表帳單地址) #BugNo:6478
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna12b
                     NEXT FIELD pna12b
                WHEN INFIELD(pna10b) #查詢付款條件資料檔(pma_file)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pma"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna10b
                     NEXT FIELD pna10b
                WHEN INFIELD(pna09b) #價格條件
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pnz01" #FUN-930113
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna09b
                     NEXT FIELD pna09b
                WHEN INFIELD(pna08b) #查詢幣別資料檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna08b
                     NEXT FIELD pna08b
                WHEN INFIELD(pna15) #查詢碼別代號說明資料檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azf01a"      #FUN-920186
                     LET g_qryparam.arg1 = 'B'             #FUN-920186
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pna15
                     NEXT FIELD pna15
                #-----FUN-A20057---------
                WHEN INFIELD(pna16) #變更人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pna16
                    CALL t910_peo('a',g_pna.pna16)
                    NEXT FIELD pna16 
                #-----END FUN-A20057-----
                OTHERWISE EXIT CASE
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN  RETURN END IF
 
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pnauser', 'pnagrup')
 
       CONSTRUCT g_wc2 ON pnb03,
                          pnb04b,pnb041b,               #CHI-C50063 add
                          pnb20b,pnb07b,pnb31b,pnb32b,  #CHI-C50063 add
                          pnb34b,pnb35b,pnb36b,                    #FUN-A80142       
                          pnbislk01a,      #NO.FUN-810014 add pnbislk01 #No.FUN-890100 pnbislk01-->pnbislk01a
                          pnb33b,pnb90,pnb91,pnb04a,pnb041a,          #CHI-C50063 add
                          pnb20a,pnb07a,pnb85a,pnb82a,pnb31a,pnb32a,  #CHI-C50063 add pnab07a
                          pnb34a,pnb35a,pnb36a,                    #FUN-A80142
                          pnb33a  
                          ,pnb50  #CHI-C50063 add
       FROM s_pnb[1].pnb03,
            s_pnb[1].pnb04b,s_pnb[1].pnb041b,  #CHI-C50063 add
            s_pnb[1].pnb20b,s_pnb[1].pnb07b,   #CHI-C50063 add   
            s_pnb[1].pnb31b,s_pnb[1].pnb32b,   #CHI-C50063 add
            s_pnb[1].pnb34b,s_pnb[1].pnb35b,s_pnb[1].pnb36b,       #FUN-A80142    
            s_pnb[1].pnbislk01a,     #NO.FUN-810014 add pnbislk01  #No.FUN-870117
            s_pnb[1].pnb33b,                   #CHI-C50063 add
            s_pnb[1].pnb90,s_pnb[1].pnb91,s_pnb[1].pnb04a,s_pnb[1].pnb041a,   #CHI-C50063 add
            s_pnb[1].pnb20a,s_pnb[1].pnb07a,s_pnb[1].pnb85a,s_pnb[1].pnb82a,  #CHI-C50063 add pnb07a
            s_pnb[1].pnb31a,s_pnb[1].pnb32a,
            s_pnb[1].pnb34a,s_pnb[1].pnb35a,s_pnb[1].pnb36a,       #FUN-A80142
            s_pnb[1].pnb33a
           ,s_pnb[1].pnb50  #CHI-C50063 add

		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
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
#FUN-A80142 --begin--
            CASE
              WHEN INFIELD(pnb34a)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  = "q_pja2"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb34a
                   NEXT FIELD pnb34a                 
              WHEN INFIELD(pnb34b)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  = "q_pja2"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb34b
                   NEXT FIELD pnb34b
              WHEN INFIELD(pnb35a)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  = "q_pjb4"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb35a
                   NEXT FIELD pnb35a                 
              WHEN INFIELD(pnb35b)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  = "q_pjb4"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb35b
                   NEXT FIELD pnb35b                                               
              WHEN INFIELD(pnb36a)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  = "q_pjk3"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb36a
                   NEXT FIELD pnb36a                 
              WHEN INFIELD(pnb36b)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  = "q_pjk3"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb36b
                   NEXT FIELD pnb36b                   
#FUN-A80142 --end--
             #CHI-C50063------add------S
              WHEN INFIELD(pnb90)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pml3"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb90 
                   NEXT FIELD pnb90
              WHEN INFIELD(pnb04b)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_ima"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb04b 
                   NEXT FIELD pnb04b
              WHEN INFIELD(pnb04a)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_ima"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb04a
                   NEXT FIELD pnb04a
              WHEN INFIELD(pnb07a)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb07a
                   NEXT FIELD pnb07a
              WHEN INFIELD(pnb07b)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pnb07b
                   NEXT FIELD pnb07b
             #CHI-C50063------add------E
          
#              CASE                           #FUN-A80142 
               WHEN INFIELD(pnbislk01a)      #No.FUN-870117
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_skd01"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnbislk01a #No.FUN-870117
                    NEXT FIELD pnbislk01a                     #No.FUN-870117
#               END CASE                     #FUN-A80142
                END CASE                     #FUN-A80142 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF
 
    IF g_wc2 = " 1=1" THEN                        #若單身未輸入條件
       LET g_sql = "SELECT pna01,pna02 FROM pna_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 2"
    ELSE
        LET g_sql= "SELECT UNIQUE pna01,pna02 ",
                   " FROM pna_file, pnb_file ",
                   " WHERE pna01 = pnb01 ",
                   "  AND  pna02 = pnb02 ",
                   "  AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
                   " ORDER BY 2 "
         IF (g_wc2.getIndexOf('pnbi',1)>0)  THEN
          LET g_sql= "SELECT UNIQUE pna01,pna02 ",
                    " FROM pna_file, pnb_file,pnbi_file ",
                    " WHERE pna01 = pnb01 ",
                    "  AND  pna02 = pnb02 ",
                    "  AND  pnb01 = pnbi01 ",
                    "  AND  pnb02 = pnbi02 ",
                    "  AND  pnb03 = pnbi03 ",
                    "  AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
                    " ORDER BY 2 "
         END IF  
    END IF
    PREPARE t910_prepare FROM g_sql      #預備一下
    DECLARE t910_b_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t910_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM pna_file WHERE ",g_wc CLIPPED
    ELSE
         LET g_sql="SELECT COUNT(DISTINCT pna01) FROM pna_file,pnb_file WHERE ",
                   "pnb01=pna01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
         IF (g_wc2.getIndexOf('pnbi',1)>0) THEN
         LET g_sql="SELECT COUNT(DISTINCT pna01) FROM pna_file,pnb_file,pnbi_file WHERE ",
                   "pnb01=pna01 AND pnb01 = pnbi01 	AND pnb02 = pnbi02 AND pnb03 = pnbi03 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
         END IF
    END IF
    PREPARE t910_precount FROM g_sql
    DECLARE t910_count CURSOR FOR t910_precount
 
END FUNCTION
 
FUNCTION t910_menu()
   DEFINE l_creator     LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) #「不准」時是否退回填表人 #FUN-580147
   DEFINE l_flowuser    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) # 是否有指定加簽人員      #FUN-580147
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
   DEFINE l_suppy      LIKE pmm_file.pmm09  #廠商代碼
 
   LET l_flowuser = "N"   #FUN-580147
 
   WHILE TRUE
      CALL t910_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t910_a()
            END IF
            
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t910_q()
            END IF
            
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t910_u()
            END IF
            
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t910_r()
            END IF

       #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t910_x()   #FUN-D20025
               CALL t910_x(1)  #FUN-D20025 
            END IF

       #FUN-D20025---add--str---
       #@WHEN "取消作廢"
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN  
              #CALL t910_x()   #FUN-D20025
               CALL t910_x(2)  #FUN-D20025 
            END IF
       #FUN-D20025---add--end---
                        
         WHEN "help"
            CALL cl_show_help()
         
         WHEN "exit"
            EXIT WHILE
         
         WHEN "controlg"
            CALL cl_cmdask()

       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t910_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t910_y_upd()       #CALL 原確認的 update 段
               END IF
            END IF
            
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t910_z()
            END IF

        #@WHEN "准"
        WHEN "agree"
             IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                CALL t910_y_upd()      #CALL 原確認的 update 段
             ELSE
                LET g_success = "Y"
                IF NOT aws_efapp_formapproval() THEN
                   LET g_success = "N"
                END IF
             END IF
             IF g_success = 'Y' THEN
                IF cl_confirm('aws-081') THEN
                   IF aws_efapp_getnextforminfo() THEN
                      LET l_flowuser = 'N'
                      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                      LET g_argv2 = aws_efapp_wsk(2)   #參數:key-1
                      IF NOT cl_null(g_argv1) THEN
                         CALL t910_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                         CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,                               locale, void, undo_void, confirm, undo_confirm, easyflow_approval,  #FUN-D20025 add undo_void                              release_po,memo")       #TQC-B40209 add memo
                              RETURNING g_laststage
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                ELSE
                   EXIT WHILE
                END IF
             END IF   
             
        #@WHEN "不准"
        WHEN "deny"
            IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_pna.pna13 = 'R'
                     DISPLAY BY NAME g_pna.pna13
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                        LET g_argv2 = aws_efapp_wsk(2)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN
                           CALL t910_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail,                               query, locale, void,undo_void, confirm, undo_confirm, easyflow_approval,   #FUN-D20025 add undo_void                              release_po,memo")       #TQC-B40209 add memo
                                RETURNING g_laststage
                        ELSE
                           EXIT WHILE
                        END IF
                     ELSE
                        EXIT WHILE
                     END IF
                  ELSE
                     EXIT WHILE
                  END IF
               END IF
             END IF    
             
        #@WHEN "加簽"
        WHEN "modify_flow"
             IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                LET l_flowuser = 'Y'
             ELSE
                LET l_flowuser = 'N'
             END IF
 
        #@WHEN "撤簽"
        WHEN "withdraw"
             IF cl_confirm("aws-080") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "抽單"
        WHEN "org_withdraw"
             IF cl_confirm("aws-079") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "簽核意見"
        WHEN "phrase"
             CALL aws_efapp_phrase()
             
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_pna.pna01 IS NOT NULL THEN
                LET g_doc.column1 = "pna01"
                LET g_doc.column2 = "pna02"    #TQC-740121 add
                LET g_doc.value1 = g_pna.pna01
                LET g_doc.value2 = g_pna.pna02 #TQC-740121 add
                CALL cl_doc()
              END IF
        END IF        

        WHEN "easyflow_approval"     #FUN-550038
           IF cl_chk_act_auth() THEN
               #FUN-C20026 add str---
                SELECT * INTO g_pna.* FROM pna_file
                 WHERE pna01 = g_pna.pna01
                   AND pna02 = g_pna.pna02
                CALL t910_show()
                CALL t910_b_fill(' 1=1')
               #FUN-C20026 add end---
                CALL t910_ef()
                CALL t910_show()  #FUN-C20026 add
           END IF  
 
        #@WHEN GPM規範顯示   
        WHEN "gpm_show"
             LET l_partnum = ''
             LET l_supplierid = ''
             IF l_ac > 0 THEN
                IF g_pnb[l_ac].pnb04a IS NOT NULL THEN
                   LET l_partnum = g_pnb[l_ac].pnb04a
                ELSE
                   LET l_partnum = g_pnb[l_ac].pnb04b
                END IF
             END IF
             SELECT pmm09 INTO l_suppy
               FROM pmm_file
              WHERE pmm01 = g_pna.pna01
             LET l_supplierid = l_suppy
             CALL aws_gpmcli(l_partnum,l_supplierid)
               RETURNING l_status
 
        #@WHEN GPM規範查詢
        WHEN "gpm_query"
             LET l_partnum = ''
             LET l_supplierid = ''
             IF l_ac > 0 THEN
                IF g_pnb[l_ac].pnb04a IS NOT NULL THEN
                   LET l_partnum = g_pnb[l_ac].pnb04a
                ELSE
                   LET l_partnum = g_pnb[l_ac].pnb04b
                END IF
             END IF
             SELECT pmm09 INTO l_suppy
               FROM pmm_file
              WHERE pmm01 = g_pna.pna01
             LET l_supplierid = l_suppy
             CALL aws_gpmcli(l_partnum,l_supplierid)
               RETURNING l_status   

       #@WHEN "簽核狀況"
        WHEN "approval_status"
           IF cl_chk_act_auth() THEN  #DISPLAY ONLY
              IF aws_condition2() THEN                #FUN-550038
                    CALL aws_efstat2()                 #MOD-560007
              END IF
           END IF    

       #@WHEN "單價查詢"
         WHEN "qry_unit_price"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_pna.pna01) AND g_pna.pna05 !='X' THEN
                  CALL t910_6()
               END IF
            END IF   

       #@WHEN "備註"
         WHEN "memo"
#TQC-B40209 --begin--
           IF g_pna.pna13 MATCHES '[Ss]' THEN 
              CALL cl_err('','apm-030',0)
           ELSE 
#TQC-B40209 --end--         
             IF g_pna.pna05 !='X' THEN
                CALL t910_memo()
             END IF
           END IF           #TQC-B40209    

         WHEN "output"
            CALL t910_out()                                                                        
            
       #@WHEN "發出"
          WHEN "release_po"       #MOD-580129
            IF cl_chk_act_auth() THEN
               CALL t910_g()
            END IF            
               
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t910_b()
            ELSE
               LET g_action_choice = NULL
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t910_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_pnb.clear()
    INITIALIZE g_pna.* LIKE pna_file.*             #DEFAULT 設定
    INITIALIZE g_pna_t.* LIKE pna_file.*             #DEFAULT 設定
    INITIALIZE g_pna_o.* LIKE pna_file.*             #DEFAULT 設定
    LET g_pna.pna01  = ' '
    LET g_pna.pna04 = g_today
    #-----FUN-A20057---------
    LET g_pna.pna16 = g_user   
    CALL t910_peo('d',g_pna.pna16)   
    IF NOT cl_null(g_errno) THEN
       LET g_pna.pna16 = ''
    END IF 
    #-----END FUN-A20057-----
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_pna.pna05   = 'N'                    #發出否
        LET g_pna.pna13   = '0'                    #開立       #No.6686
        LET g_pna.pnaconf = 'N'                    #發出否
        LET g_pna.pnaacti = 'Y'
        LET g_pna.pnagrup=g_grup
        LET g_pna.pnadate=g_today
        LET g_pna.pnauser=g_user
        LET g_pna.pnaoriu = g_user #FUN-980030
        LET g_pna.pnaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_pna.pnaplant=g_plant  #FUN-980006 add
        LET g_pna.pnalegal=g_legal  #FUN-980006 add
        CALL s_pmista('pna',g_pna.pna13,g_pna.pna05,g_pna.pna14)
             RETURNING g_sta
        DISPLAY g_sta TO FORMONLY.desc2
        INITIALIZE g_pnb_t.* TO NULL  #900423
        CALL t910_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_pna.* TO NULL
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        DISPLAY g_pna.pna01 TO pna01
        INSERT INTO pna_file VALUES(g_pna.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        ELSE
            SELECT pna01,pna02 INTO g_pna.pna01,g_pna.pna02 FROM pna_file
             WHERE pna01 = g_pna.pna01
               AND pna02 = g_pna.pna02    #No.B539 add
        END IF
        IF (NOT cl_null(g_pna.pna08b)) AND (g_pna.pna08b<>g_pna.pna08) THEN
          CALL cl_err('','axm-190',1)
        END IF
       #LET g_rec_b = 0 #MOD-D30186 mark
        CALL t910_b()                   #輸入單身
 
        LET g_t1 = s_get_doc_no(g_pna.pna01)       #No.FUN-550060
        SELECT * INTO g_smy.* FROM smy_file
         WHERE smyslip=g_t1
        IF (NOT cl_null(g_pna.pna01)) AND (NOT cl_null(g_pna.pna02)) AND g_smy.smydmy4='Y' 
           AND g_smy.smyapr <> 'Y'                        #確認  #FUN-640184
        THEN 
           LET g_action_choice = "insert"           #FUN-640184     
           CALL t910_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t910_y_upd()       #CALL 原確認的 update 段
           END IF
        END IF
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t910_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pna.pna01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #---->如為'已發出',不可取消
    IF g_pna.pnaconf = 'Y' THEN
       CALL cl_err('','apm-224',0)
       RETURN
    END IF
    IF g_pna.pna05 = 'Y' THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF
    IF g_pna.pna05 = 'X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
    IF g_pna.pnaacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_pna.pna01,9027,0)
       RETURN
    END IF
    IF g_pna.pna13 matches '[Ss]' THEN          #FUN-550038
        CALL cl_err('','apm-030',0)
        RETURN
    END IF
 
    CALL cl_opmsg('u')
    LET g_pna01_t = g_pna.pna01
    LET g_pna02_t = g_pna.pna02   #MOD-780081 add
    LET g_pna_o.* = g_pna.*
    BEGIN WORK
    LET g_success ='Y'
 
    OPEN t910_cl USING g_pna.pna01,g_pna.pna02
    IF STATUS THEN
       CALL cl_err("OPEN t910_cl:", STATUS, 1)
       CLOSE t910_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t910_cl INTO g_pna.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t910_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL t910_show()
    WHILE TRUE
        LET g_pna01_t = g_pna.pna01
        LET g_pna02_t = g_pna.pna02   #MOD-780081 add
        LET g_pna.pnamodu=g_user
        LET g_pna.pnadate=g_today
        CALL t910_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_success ='N'
            LET INT_FLAG = 0
            LET g_pna.*=g_pna_o.*
            LET g_pna.pna01 = g_pna_o.pna01
            DISPLAY BY NAME g_pna.pna01
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_pna.pna01 != g_pna01_t THEN            # 更改單號
            UPDATE pna_file SET pna01 = g_pna.pna01
                WHERE pna01 = g_pna01_t
                  AND pna02=  g_pna02_t   #MOD-780081 add
            IF SQLCA.sqlcode THEN
                CALL cl_err('pnb',SQLCA.sqlcode,0) CONTINUE WHILE
            END IF
        END IF
        LET g_pna.pna13 = '0'        #FUN-550038
        UPDATE pna_file SET pna_file.* = g_pna.*
            WHERE pna01 = g_pna.pna01 AND pna02 = g_pna.pna02
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
      IF g_flag1 ='N' THEN #MOD-B30413 add
         IF (NOT cl_null(g_pna.pna08b)) AND (g_pna.pna08b<>g_pna.pna08)
          OR (NOT cl_null(g_pna_t.pna08b)) AND (g_pna.pna08b<>g_pna_t.pna08b) THEN
           CALL cl_err('','axm-190',1)
         END IF
      END IF  #MOD-B30413 add
        EXIT WHILE
    END WHILE
    DISPLAY BY NAME g_pna.pna13
    IF g_pna.pna05='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_pna.pna13='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_pna.pna05,g_chr2,"","",g_chr,"")
 
    COMMIT WORK
END FUNCTION
  
FUNCTION t910_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改  #No.FUN-680136 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(70)
    l_pna02         LIKE type_file.num5,    #No.FUN-680136 SMALLINT  #變更序號
    l_n             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    l_pna01    LIKE pna_file.pna01,
    l_pmm25    LIKE pmm_file.pmm25,
    l_pmm04    LIKE pmm_file.pmm04,         #FUN-650166 add
    l_pnaconf  LIKE pna_file.pnaconf,       #發出否
    l_str      LIKE type_file.chr50         #No.FUN-680136 VARCHAR(40)
#MOD-B30413 add --start--
 DEFINE l_pna08     LIKE pna_file.pna08
 DEFINE l_pnb01     LIKE pnb_file.pnb01
 DEFINE l_pnb02     LIKE pnb_file.pnb02
 DEFINE l_pnb03     LIKE pnb_file.pnb03
 DEFINE l_pnb04     LIKE pnb_file.pnb04b
 DEFINE l_pnb04a    LIKE pnb_file.pnb04a
 DEFINE l_pnb04b    LIKE pnb_file.pnb04b
 DEFINE l_pnb07     LIKE pnb_file.pnb07b
 DEFINE l_pnb07a    LIKE pnb_file.pnb07a
 DEFINE l_pnb07b    LIKE pnb_file.pnb07b
 DEFINE l_pnb86     LIKE pnb_file.pnb86b  
 DEFINE l_pnb86a    LIKE pnb_file.pnb86a 
 DEFINE l_pnb86b    LIKE pnb_file.pnb86b 
 DEFINE l_pnb20     LIKE pnb_file.pnb20b
 DEFINE l_pnb20a    LIKE pnb_file.pnb20a
 DEFINE l_pnb20b    LIKE pnb_file.pnb20b
 DEFINE l_pmm09     LIKE pmm_file.pmm09
 DEFINE l_pmm21     LIKE pmm_file.pmm21
 DEFINE l_pmm43     LIKE pmm_file.pmm43
 DEFINE l_pnb31a    LIKE pnb_file.pnb31a
 DEFINE l_pnb32a    LIKE pnb_file.pnb32a
 DEFINE  l_task     LIKE ecm_file.ecm04,
         l_type     LIKE type_file.chr1  
#MOD-B30413 add --end--
 DEFINE l_azi04     LIKE azi_file.azi04          #No.FUN-B50158
 DEFINE l_azi03     LIKE azi_file.azi03          #MOD-CC0122 add
 DEFINE l_pma02b    LIKE pma_file.pma02 #FUN-C30031
 DEFINE l_pnz02b    LIKE pnz_file.pnz02 #FUN-C30031
 DEFINE l_pma02     LIKE pma_file.pma02 #FUN-C30031
 DEFINE l_pnz02     LIKE pnz_file.pnz02 #FUN-C30031
 DEFINE li_result   LIKE type_file.num5     #CHI-D10010 add
 DEFINE l_pna01a    LIKE pna_file.pna01     #CHI-D10010 add
 DEFINE l_poz00     LIKE poz_file.poz00  #CHI-D30023 add
 DEFINE l_poz011    LIKE poz_file.poz011 #CHI-D30023 add
 DEFINE l_dbs_last  LIKE type_file.chr21 #CHI-D30023 add

    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    DISPLAY BY NAME
         g_pna.pna01,g_pna.pna02,g_pna.pna04,g_pna.pna15,g_pna.pna16,   #FUN-650189 add g_pna.pna15   #FUN-A20057 add g_pna.pna16
         g_pna.pna08,g_pna.pna10,g_pna.pna11,g_pna.pna09,g_pna.pna12,
         g_pna.pna08b,g_pna.pna10b,g_pna.pna11b,g_pna.pna09b,g_pna.pna12b,
         g_pna.pna14,g_pna.pna05,g_pna.pna13,g_pna.pnaconf,
         g_pna.pnauser,g_pna.pnagrup,g_pna.pnamodu,g_pna.pnadate,g_pna.pnaacti
 
    IF g_pna.pnaconf='Y' THEN CALL cl_err('','apm-224',1) RETURN END IF
    IF g_pna.pna05='Y' THEN CALL cl_err('','apm-242',1) RETURN END IF
    INPUT BY NAME g_pna.pnaoriu,g_pna.pnaorig,g_pna.pna01,g_pna.pna04,g_pna.pna15,g_pna.pna16,g_pna.pna08b,g_pna.pna10b,   #FUN-650189 add g_pna.pna15   #FUN-A20057 add g_pna.pna16
                 #g_pna.pna11b,g_pna.pna09b,g_pna.pna12b,    #No.MOD-480595  #MOD-B30307 mark
                  g_pna.pna09b,g_pna.pna11b,g_pna.pna12b,    #No.MOD-480595  #MOD-B30307 add
                  g_pna.pnaud01,g_pna.pnaud02,g_pna.pnaud03,g_pna.pnaud04,
                  g_pna.pnaud05,g_pna.pnaud06,g_pna.pnaud07,g_pna.pnaud08,
                  g_pna.pnaud09,g_pna.pnaud10,g_pna.pnaud11,g_pna.pnaud12,
                  g_pna.pnaud13,g_pna.pnaud14,g_pna.pnaud15 
                  WITHOUT DEFAULTS
 
        BEFORE INPUT
          CALL cl_set_docno_format("pna01")
 
        LET  g_before_input_done = FALSE
        CALL t910_set_entry(p_cmd)
        CALL t910_set_no_entry(p_cmd)
        LET  g_before_input_done = TRUE
 
        BEFORE FIELD pna01
            CALL cl_set_comp_entry("pna08b,pna09b,pna10b,pna11b,pna12b",TRUE)
 
 
        AFTER FIELD pna01                   #採購單號
            IF NOT cl_null(g_pna.pna01) THEN
                 CALL t910_pna01() #MOD-4A0148

                #CHI-D10010---add---S
                #若單別設定檔有做使用者或部門設限，需照新增時的單別權限控卡
                 LET g_t1=s_get_doc_no(g_pna.pna01)
                 CALL s_check_no("apm",g_t1,"","2","pna_file","pna01","")
                      RETURNING li_result,l_pna01a
                 IF (NOT li_result) THEN
                    NEXT FIELD pna01
                 END IF
                #CHI-D10010---add---E

                #---->判斷此採購單,是否尚有未發出的變更單
                 IF cl_null(g_pna_t.pna01) OR (g_pna.pna01 != g_pna_t.pna01) THEN #MOD-4B0045
                    SELECT count(*) INTO g_cnt FROM pna_file
                           WHERE pna01 = g_pna.pna01
                              AND pnaconf IN ('N','n')   #MOD-4B0045
                              AND pna05 <> 'X' #未作廢的 #MOD-4B0045 add
                    IF g_cnt > 0 THEN                   # 代表尚有未發出的採購變更單
                       CALL cl_err('','apm-216',0)
                       NEXT FIELD pna01
                    END IF
                 END IF                                  #MOD-4B0045
                IF g_pna.pna01 IS NULL OR g_pna.pna01 = ' ' THEN
                    NEXT FIELD pna01
                END IF
                LET g_t1 = s_get_doc_no(g_pna.pna01)       #No.FUN-550060
                SELECT smyapr,smy57 INTO g_smy.smyapr,g_smy.smy57 FROM smy_file #CHI-B50016 add smy57
                WHERE smyslip=g_t1
                IF cl_null(g_pna_t.pna01) OR (g_pna.pna01 != g_pna_t.pna01) THEN
                   LET g_pna.pna14 = g_smy.smyapr
                   DISPLAY g_pna.pna14 TO pna14
                END IF
                #CHI-B50016 add --start--
                LET g_blanketpo = 'N'
                IF g_smy.smy57[4,4]='Y' THEN  #單據性質設為使用 Blanket P/O
                   LET g_blanketpo = 'Y'
                END IF
                #CHI-B50016 add --end--
                #---->判斷此採購單,是否存在於採購單單頭
                SELECT count(*),pmm25 INTO g_cnt,l_pmm25
                  FROM pmm_file
                 WHERE pmm01 = g_pna.pna01
                  GROUP BY pmm25
                IF g_cnt = 0 THEN                # 於採購單單頭檔無此採購單單號
                   CALL cl_err('','apm-217',0)
                   NEXT FIELD pna01
                ELSE
                   IF l_pmm25 != '2' THEN
                      CALL cl_err('','apm-222',0)
                      NEXT FIELD pna01
                   END IF
                END IF
                # 判斷代採三角貿易變更
                SELECT * INTO g_pmm.* FROM pmm_file WHERE pmm01 = g_pna.pna01
                IF g_pmm.pmm901 = 'Y' THEN
                   IF g_pmm.pmm02 = 'TRI' THEN
                      CALL cl_err('','apm-022',1) NEXT FIELD pna01
                   END IF
                   IF g_pmm.pmm02 = 'TAP' AND
                      (g_pmm.pmm906 = 'N' OR cl_null(g_pmm.pmm906)) THEN
                     #CALL cl_err('','apm-023',1) NEXT FIELD pna01  #CHI-D30023 mark
                    #CHI-D30023 add start -----
                     CALL s_mtrade_last_plant(g_pmm.pmm904) RETURNING p_last,p_last_plant  #最終站
                     SELECT poz00,poz011 INTO l_poz00,l_poz011 FROM poz_file,poy_file
                      WHERE poz01 = poy01
                        AND poy02 = p_last 
                        AND poy01 = g_pmm.pmm904
                     SELECT azp03 INTO l_dbs_last FROM azp_file
                      WHERE azp01 = p_last_plant 
                     IF g_pmm.pmm902 = 'N' OR cl_null(g_pmm.pmm50) OR (l_poz00 != '2' AND l_poz011 = '1') THEN
                        CALL cl_err('','apm1103',1) NEXT FIELD pna01
                     END IF 
                    #CHI-D30023 add end   -----
                   END IF
                END IF
                #---->變更序號
                IF cl_null(g_pna_t.pna01) OR (g_pna.pna01 != g_pna_t.pna01) THEN #MOD-4B0045
                    SELECT max(pna02) INTO g_pna.pna02 #MOD-4B0045
                     FROM  pna_file                    #MOD-4B0045
                     WHERE pna01 = g_pna.pna01         #MOD-4B0045
                   IF cl_null(g_pna.pna02) THEN
                      LET g_pna.pna02 = 1
                   ELSE
                      LET g_pna.pna02 = g_pna.pna02 + 1
                   END IF
                 END IF #MOD-4B0045
                DISPLAY g_pna.pna02 TO pna02
                DISPLAY g_pna.pna04 TO pna04
                DISPLAY g_pna.pnaconf TO pnaconf
                SELECT pmm02  ,pmm22      ,pmm20      ,pmm41      ,pmm10      ,pmm11
                  INTO g_pmm02,g_pna.pna08,g_pna.pna10,g_pna.pna09,g_pna.pna11,g_pna.pna12
                  FROM pmm_file
                 WHERE pmm01 = g_pna.pna01 AND pmm18 !='X'
                CALL t910_pna08b()      #No.MOD-630055
                DISPLAY BY NAME g_pna.pna08,g_pna.pna10,g_pna.pna09,g_pna.pna11,g_pna.pna12
               #FUN-C30031---add---START
                SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01=g_pna.pna10
                SELECT pnz02 INTO l_pnz02 FROM pnz_file WHERE pnz01=g_pna.pna09
                DISPLAY l_pma02 TO FORMONLY.pma02
                DISPLAY l_pnz02 TO FORMONLY.pnz02
               #FUN-C30031---add---END
               #CHI-D30023 add start -----
                CALL t910_set_entry(p_cmd)
                CALL t910_set_no_entry(p_cmd)
               #CHI-D30023 add end   -----
            END IF
 
        #變更日期不可小於採購日期
        AFTER FIELD pna04
           SELECT pmm04 INTO l_pmm04
                 FROM pmm_file
                WHERE pmm01 = g_pna.pna01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","pmm_file",g_pna.pna01,"",SQLCA.sqlcode,"","",0) 
           END IF
           IF g_pna.pna04 < l_pmm04 THEN
              CALL cl_err('','apm-055',0)
              NEXT FIELD pna04
           END IF
 
        AFTER FIELD pna15   #變更理由
           IF NOT cl_null(g_pna.pna15) THEN
              CALL t910_pna15()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pna.pna15,g_errno,0)
                 LET g_pna.pna15 = g_pna_t.pna15
                 DISPLAY BY NAME g_pna.pna15
                 NEXT FIELD pna15
              END IF
           END IF

        #-----FUN-A20057---------
        AFTER FIELD pna16  #變更人員
              IF NOT cl_null(g_pna.pna16) THEN
                 CALL t910_peo('a',g_pna.pna16)
                 IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_pna.pna16,g_errno,1)  
                     LET g_pna.pna16 = g_pna_o.pna16
                     DISPLAY BY NAME g_pna.pna16
                     NEXT FIELD pna16 
                 END IF
              END IF
        #-----END FUN-A20057-----
 
        AFTER FIELD pna08b #幣別
         #No.FUN-B50158--MARK-- 
         #  IF NOT cl_null(g_pna.pna08b) THEN
         #       CALL t910_pna08b()  #check 幣別合理性
         #       IF NOT cl_null(g_errno) THEN
         #           CALL cl_err(g_pna.pna08b,g_errno,0)
         #           LET g_pna.pna08b = g_pna_t.pna08b
         #           DISPLAY BY NAME g_pna.pna08b
         #           NEXT FIELD pna08b
         #       END IF
         #  END IF
         #No.FUN-B50158--MARK--END--
         #No.FUN-B50158--ADD--
            IF NOT t910_chk_pna08b(p_cmd) THEN
               NEXT FIELD CURRENT
            END IF
         #No.FUN-B50158--END-- 

        AFTER FIELD pna10b #付款條件
            IF NOT cl_null(g_pna.pna10b) THEN
                 CALL t910_pna10b()  #check 付款條件合理性
                 IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_pna.pna10b,g_errno,0)
                     LET g_pna.pna10b = g_pna_t.pna10b
                     DISPLAY BY NAME g_pna.pna10b
                     NEXT FIELD pna10b
                 END IF
                 SELECT pma02 INTO l_pma02b FROM pma_file WHERE pma01=g_pna.pna10b #FUN-C30031 add
            END IF
            DISPLAY l_pma02b TO FORMONLY.pma02b #FUN-C30031 add
 
        AFTER FIELD pna09b #價格條件
            IF NOT cl_null(g_pna.pna09b) THEN
                CALL t910_pna09b()  #check 價格條件合理性
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pna.pna09b,g_errno,0)
                    LET g_pna.pna09b = g_pna_t.pna09b
                    DISPLAY BY NAME g_pna.pna09b
                    NEXT FIELD pna09b
                END IF
                SELECT pnz02 INTO l_pnz02b FROM pnz_file WHERE pnz01=g_pna.pna09b #FUN-C30031 add
            END IF
            DISPLAY l_pma02b TO FORMONLY.pma02b #FUN-C30031 add 
 
        AFTER FIELD pna11b #送貨地址
            IF NOT cl_null(g_pna.pna11b) THEN
                 CALL t910_pna11b(g_pna.pna11b)  #check 送貨地址合理性
                 IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_pna.pna11b,g_errno,0)
                     LET g_pna.pna11b = g_pna_t.pna11b
                     DISPLAY BY NAME g_pna.pna11b
                     NEXT FIELD pna11b
                 END IF
            END IF
 
        AFTER FIELD pna12b #發票地址
            IF NOT cl_null(g_pna.pna12b) THEN
                 CALL t910_pna11b(g_pna.pna12b)  #check 送貨地址合理性
                 IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_pna.pna12b,g_errno,0)
                     LET g_pna.pna12b = g_pna_t.pna12b
                     DISPLAY BY NAME g_pna.pna12b
                     NEXT FIELD pna12b
                 END IF
            END IF
        AFTER FIELD pnaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pnaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT
           LET g_pna.pnauser = s_get_data_owner("pna_file") #FUN-C10039
           LET g_pna.pnagrup = s_get_data_group("pna_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            CALL t910_pna08b()                   #No.TQC-690101 add 
            IF g_pna.pna01 IS NULL THEN            #採購單單號
               LET l_flag='Y'
               DISPLAY  g_pna.pna01 TO pna01
            END IF
            IF g_pna.pna04 IS NULL THEN            #變更日期
               LET l_flag='Y'
               DISPLAY  g_pna.pna04 TO pna04
            END IF
            IF l_flag='Y' THEN
                CALL cl_err('','9033',0)
                NEXT FIELD pna01
            END IF
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

           #MOD-B30413 add --start--
           LET g_flag1 = 'N'
         # IF NOT cl_null(g_pna.pna08b) THEN #FUN-B50158 mark
         #    IF g_pna.pna08b != g_pna_t.pna08b OR cl_null(g_pna_t.pna08b) THEN  #FUN-B50158 mark
           IF (NOT cl_null(g_pna.pna08b) AND (g_pna.pna08b != g_pna_t.pna08b OR cl_null(g_pna_t.pna08b)))  #FUN-B50158 add
           OR (cl_null(g_pna.pna08b) AND NOT cl_null(g_pna_t.pna08b)) THEN   #FUN-B50158 add
              #FUN-B50158--add--str--
               IF p_cmd = 'a' THEN
                  IF NOT cl_confirm('art-221') THEN
                     RETURN
                  ELSE
                     LET g_sql = " SELECT pmn02,pmn04, pmn07, pmn20, pmn83,pmn84,pmn85,pmn80,",
                                 "        pmn81, pmn82, pmn86, pmn87,pmn31,pmn31t, pmn87*pmn31,pmn87*pmn31t,",
                                 "        pmn33, pmn041,pmn24, pmn25,",  # pmn31t,pmn20,",  # MOD-C30372 mark
                                 "        pmn122,pmn96,pmn97",
                                 " FROM pmn_file WHERE pmn01 = '",g_pna.pna01,"'"
                     PREPARE pmn_pre FROM g_sql
                     DECLARE pmn_cur CURSOR FOR pmn_pre
                     LET l_ac = 1
                     FOREACH pmn_cur INTO g_pnb[l_ac].pnb03,g_pnb[l_ac].pnb04b, g_pnb[l_ac].pnb07b,
                                          g_pnb[l_ac].pnb20b, g_pnb[l_ac].pnb83b,g_pnb[l_ac].pnb84b,
                                          g_pnb[l_ac].pnb85b, g_pnb[l_ac].pnb80b,g_pnb[l_ac].pnb81b,
                                          g_pnb[l_ac].pnb82b, g_pnb[l_ac].pnb86b,g_pnb[l_ac].pnb87b,
                                          g_pnb[l_ac].pnb31b, g_pnb[l_ac].pnb32b,g_pnb[l_ac].totb,
                                          g_pnb[l_ac].tottb,g_pnb[l_ac].pnb33b,  
                                          g_pnb[l_ac].pnb041b,  
                                          g_pnb[l_ac].pnb90b,g_pnb[l_ac].pnb91b,      
                                          g_pnb[l_ac].pnb34b,g_pnb[l_ac].pnb35b,g_pnb[l_ac].pnb36b 
                         IF SQLCA.sqlcode THEN
                            CALL cl_err('foreach oeq_cur',SQLCA.SQLCODE,1)
                         END IF   
                         LET g_pnb03_o = g_pnb[1].pnb03   #MOD-CB0216 add   #單身自動帶入需給g_pnb03_o值,給[1]不給[l_ac]的原因是因為進單身會在第一筆項次
                         LET g_pnb[l_ac].before = '0'
                         LET g_pnb[l_ac].after  = '1'  
                         SELECT azi04 INTO l_azi04 FROM azi_file
                           WHERE azi01 = g_pna.pna08
                         LET g_pnb[l_ac].totb = cl_digcut(g_pnb[l_ac].totb,l_azi04)
                         LET g_pnb[l_ac].tottb = cl_digcut(g_pnb[l_ac].tottb,l_azi04)
                         SELECT pmnislk01 INTO g_pnb[l_ac].pnbislk01b
                           FROM pmni_file
                           WHERE pmni01 = g_pna.pna01 AND pmni02 = g_pnb[l_ac].pnb03
                         SELECT ima021 INTO g_pnb[l_ac].ima021b FROM ima_file
                           WHERE ima01=g_pnb[l_ac].pnb04b  
                         IF (NOT cl_null(g_pna.pna08b) AND (g_pna.pna08b != g_pna_t.pna08b OR cl_null(g_pna_t.pna08b)))
                         OR (cl_null(g_pna.pna08b) AND NOT cl_null(g_pna_t.pna08b)) THEN 
                             IF cl_confirm('apm-543') THEN
                                LET g_flag1 ='Y'
                                LET l_pnb04 = ''
                                LET l_pnb20 = ''
                                LET l_pnb07 = ''
                                LET l_pnb86 = ''
                                LET l_pmm09 = ''
                                LET l_pmm21 = ''
                                LET l_pmm43 = ''
                                LET l_pna08 = g_pna.pna08b
                                IF cl_null(g_pnb[l_ac].pnb04a) THEN
                                   LET l_pnb04 = g_pnb[l_ac].pnb04b
                                ELSE
                                   LET l_pnb04 = g_pnb[l_ac].pnb04a 
                                END IF
                                IF cl_null(g_pnb[l_ac].pnb20a) THEN
                                   LET l_pnb20 = g_pnb[l_ac].pnb20b
                                ELSE
                                   LET l_pnb20 = g_pnb[l_ac].pnb20a
                                END IF
                                IF cl_null(g_pnb[l_ac].pnb07a) THEN
                                   LET l_pnb07 = g_pnb[l_ac].pnb07b
                                ELSE
                                   LET l_pnb07 = g_pnb[l_ac].pnb07a
                                END IF
                                IF cl_null(g_pnb[l_ac].pnb86a) THEN
                                   LET l_pnb86 = g_pnb[l_ac].pnb86b
                                ELSE
                                   LET l_pnb86 = g_pnb[l_ac].pnb86a
                                END IF
                                SELECT pmm09,pmm04,pmm21,pmm43
                                  INTO l_pmm09,l_pmm04,l_pmm21,l_pmm43 FROM pmm_file
                                 WHERE pmm01 = g_pna.pna01
                                LET g_errno=''
                                CALL t910_gettask(g_pna.pna01,g_pnb[l_ac].pnb03)
                                     RETURNING l_task,l_type
                                #CALL s_defprice_new(l_pnb04,l_pmm09,l_pna08,l_pmm04,    #MOD-C30904 mark
                                CALL s_defprice_new(l_pnb04,l_pmm09,l_pna08,g_pna.pna04, #MOD-C30904 add
                                               #l_pnb20,l_task,l_pmm43,l_pmm21,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-BA0204 mark
                                                l_pnb20,l_task,l_pmm21,l_pmm43,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-BA0204 add
                                 RETURNING l_pnb31a,l_pnb32a,
                                           g_pmn73,g_pmn74
              
                                LET g_pnb[l_ac].pnb31a=l_pnb31a
                                LET g_pnb[l_ac].pnb32a=l_pnb32a
                                LET g_pnb[l_ac].tota =g_pnb[l_ac].pnb87b*g_pnb[l_ac].pnb31a
                                LET g_pnb[l_ac].totta=g_pnb[l_ac].pnb87b*g_pnb[l_ac].pnb32a

                                #MOD-CC0122 add start -----
                                IF NOT cl_null(g_pna.pna08b) THEN
                                   SELECT azi03,azi04 INTO l_azi03,l_azi04 FROM azi_file
                                    WHERE azi01 = g_pna.pna08b
                                END IF
                                #MOD-CC0122 add end   -----

                                LET g_pnb[l_ac].tota = cl_digcut(g_pnb[l_ac].tota,l_azi04)
                                LET g_pnb[l_ac].totta = cl_digcut(g_pnb[l_ac].totta,l_azi04)
                                #MOD-CC0122 add start -----
                                IF g_gec07 = 'N' THEN
                                   LET g_pnb[l_ac].totta = g_pnb[l_ac].tota * ( 1 + g_pmm43/100)
                                   CALL cl_digcut(g_pnb[l_ac].totta,l_azi04) RETURNING g_pnb[l_ac].totta
                                ELSE
                                   IF g_gec05 = 'T' THEN
                                      LET g_pnb[l_ac].pnb31a  = g_pnb[l_ac].pnb32a * ( 1 - g_pmm43/100)
                                      CALL cl_digcut(g_pnb[l_ac].pnb31a,l_azi03) RETURNING g_pnb[l_ac].pnb31a
                                      LET g_pnb[l_ac].tota  = g_pnb[l_ac].totta * ( 1 - g_pmm43/100)
                                      CALL cl_digcut(g_pnb[l_ac].tota,l_azi04) RETURNING g_pnb[l_ac].tota
                                   ELSE
                                      LET g_pnb[l_ac].tota  = g_pnb[l_ac].totta / ( 1 + g_pmm43/100)
                                      CALL cl_digcut(g_pnb[l_ac].tota,l_azi04) RETURNING g_pnb[l_ac].tota
                                   END IF
                                END IF
                                #MOD-CC0122 add end   -----
                             END IF      
                         END IF     
                         CALL t910_b_move_back()
                         INSERT INTO pnb_file VALUES(b_pnb.*)
                         LET l_ac=l_ac+1
                     END FOREACH
                     CALL g_pnb.deleteElement(l_ac)
                     LET l_ac=l_ac-1
                     LET g_rec_b = l_ac #MOD-D30186 add
                  END IF
               END IF
              #FUN-B50158--add--end--
               IF p_cmd = 'u' THEN   #FUN-B50158 add
                  SELECT COUNT(*) INTO g_cnt FROM pnb_file
                       WHERE pnb01=g_pna.pna01
                         AND pnb02=g_pna.pna02
                 IF g_cnt > 0 THEN
                    IF cl_confirm('apm-543') THEN
                       LET g_flag1 ='Y'
                       DECLARE upd_pnb_cs CURSOR FOR
                         SELECT pnb01,pnb02,pnb03,pnb04a,pnb04b,pnb20a,pnb20b,pnb07a,pnb07b,pnb86a,pnb86b 
                           FROM pnb_file
                          WHERE pnb01=g_pna.pna01
                            AND pnb02=g_pna.pna02
                      FOREACH upd_pnb_cs INTO l_pnb01,l_pnb02,l_pnb03,l_pnb04a,l_pnb04b,l_pnb20a,l_pnb20b,l_pnb07a,l_pnb07b,l_pnb86a,l_pnb86b 
                         LET l_pnb04 = ''
                         LET l_pnb20 = ''
                         LET l_pnb07 = ''
                         LET l_pnb86 = ''  
                         LET l_pmm09 = '' 
                         LET l_pmm21 = ''
                         LET l_pmm43 = ''
                         LET l_pna08 = g_pna.pna08b
                         IF cl_null(l_pnb04a) THEN
                            LET l_pnb04 = l_pnb04b
                         ELSE
                            LET l_pnb04 = l_pnb04a
                         END IF
                         IF cl_null(l_pnb20a) THEN
                            LET l_pnb20 = l_pnb20b
                         ELSE
                            LET l_pnb20 = l_pnb20a
                         END IF
                         IF cl_null(l_pnb07a) THEN
                            LET l_pnb07 = l_pnb07b
                         ELSE
                            LET l_pnb07 = l_pnb07a
                         END IF
                         IF cl_null(l_pnb86a) THEN
                            LET l_pnb86 = l_pnb86b
                         ELSE
                            LET l_pnb86 = l_pnb86a
                         END IF
                         SELECT pmm09,pmm04,pmm21,pmm43 
                           INTO l_pmm09,l_pmm04,l_pmm21,l_pmm43 FROM pmm_file
                          WHERE pmm01 = g_pna.pna01
                         LET g_errno=''
                         CALL t910_gettask(g_pna.pna01,l_pnb03) 
                              RETURNING l_task,l_type
                         #CALL s_defprice_new(l_pnb04,l_pmm09,l_pna08,l_pmm04,   #MOD-C30904 mark
                         CALL s_defprice_new(l_pnb04,l_pmm09,l_pna08,g_pna.pna04,#MOD-C30904 add
                                        #l_pnb20,l_task,l_pmm43,l_pmm21,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-BA0204 mark
                                         l_pnb20,l_task,l_pmm21,l_pmm43,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-BA0204 add       
                         RETURNING l_pnb31a,l_pnb32a,     
                                    g_pmn73,g_pmn74 
 
                         IF NOT cl_null(g_errno) THEN
                            CALL cl_err('',g_errno,1)
                            EXIT FOREACH
                         END IF
 
                         UPDATE pnb_file SET pnb31a = l_pnb31a,pnb32a= l_pnb32a
                          WHERE pnb01 = l_pnb01 AND pnb02 = l_pnb02 AND pnb03 = l_pnb03
                         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                            CALL cl_err3("upd","pnb_file",l_pnb01,l_pnb02,STATUS,"","upd pnb:",1)
                            EXIT FOREACH
                         END IF
                      END FOREACH
                      CALL t910_b_fill(' 1=1')
                    END IF
                  END IF 
              END IF
           END IF
           #MOD-B30413 add --end--
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
           CASE      #查詢符合條件的單號
             WHEN INFIELD(pna01)
                  CALL q_pmm2(FALSE,TRUE,g_pna.pna01,'2') RETURNING g_pna.pna01
                  DISPLAY BY NAME g_pna.pna01
                  NEXT FIELD pna01
                WHEN INFIELD(pna11b) #查詢地址資料檔 (0:表送貨地址)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.default1 = g_pna.pna11b
                     CALL cl_create_qry() RETURNING g_pna.pna11b
                     DISPLAY BY NAME g_pna.pna11b
                     NEXT FIELD pna11b
                WHEN INFIELD(pna12b) #查詢地址資料檔 (1:表帳單地址) #BugNo:6478
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.default1 = g_pna.pna12b
                     LET g_qryparam.arg1     = 1
                     CALL cl_create_qry() RETURNING g_pna.pna12b
                     DISPLAY BY NAME g_pna.pna12b
                     NEXT FIELD pna12b
                WHEN INFIELD(pna10b) #查詢付款條件資料檔(pma_file)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pma"
                     LET g_qryparam.default1 = g_pna.pna10b
                     CALL cl_create_qry() RETURNING g_pna.pna10b
                     DISPLAY BY NAME g_pna.pna10b
                     NEXT FIELD pna10b
                WHEN INFIELD(pna09b) #價格條件
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pnz01" #FUN-930113
                     LET g_qryparam.default1 = g_pna.pna09b
                     CALL cl_create_qry() RETURNING g_pna.pna09b
                     DISPLAY BY NAME g_pna.pna09b
                     NEXT FIELD pna09b
                WHEN INFIELD(pna08b) #查詢幣別資料檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = g_pna.pna08b
                     CALL cl_create_qry() RETURNING g_pna.pna08b
                     DISPLAY BY NAME g_pna.pna08b
                     NEXT FIELD pna08b
                WHEN INFIELD(pna15) #查詢碼別代號說明資料檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_azf01a" #FUN-920186
                     LET g_qryparam.arg1     = 'B'        #FUN-920186
                     LET g_qryparam.default1 = g_pna.pna15
                     CALL cl_create_qry() RETURNING g_pna.pna15
                     DISPLAY BY NAME g_pna.pna15
                     NEXT FIELD pna15
                #-----FUN-A20057---------
                WHEN INFIELD(pna16) #變更人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_pna.pna16
                    CALL cl_create_qry() RETURNING g_pna.pna16 
                    DISPLAY BY NAME g_pna.pna16
                    CALL t910_peo('a',g_pna.pna16)
                    NEXT FIELD pna16 
                #-----END FUN-A20057-----
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
END FUNCTION
 
#Query 查詢
FUNCTION t910_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL cl_msg("")                              #FUN-640184
 
    CLEAR FORM
    CALL g_pnb.clear()
    CALL t910_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN t910_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_pna.pna01 TO NULL
    ELSE
        CALL t910_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN t910_count
        FETCH t910_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t910_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680136 VARCHAR(1)
 
    CALL cl_msg("")                              #FUN-640184
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t910_b_cs INTO g_pna.pna01,g_pna.pna02
        WHEN 'P' FETCH PREVIOUS t910_b_cs INTO g_pna.pna01,g_pna.pna02
        WHEN 'F' FETCH FIRST    t910_b_cs INTO g_pna.pna01,g_pna.pna02
        WHEN 'L' FETCH LAST     t910_b_cs INTO g_pna.pna01,g_pna.pna02
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t910_b_cs INTO g_pna.pna01,g_pna.pna02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        INITIALIZE g_pna.* TO NULL   #MOD-640483
        CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_pna.* FROM pna_file WHERE pna01 = g_pna.pna01 AND pna02 = g_pna.pna02
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)
        INITIALIZE g_pna.* TO NULL   
        RETURN
    END IF
    LET g_data_owner = g_pna.pnauser      #FUN-4C0056 add
    LET g_data_group = g_pna.pnagrup      #FUN-4C0056 add
    LET g_data_plant = g_pna.pnaplant #FUN-980030
    CALL t910_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t910_show()
DEFINE l_pma02     LIKE pma_file.pma02 #FUN-C30031
DEFINE l_pnz02     LIKE pnz_file.pnz02 #FUN-C30031
DEFINE l_pma02b    LIKE pma_file.pma02 #FUN-C30031
DEFINE l_pnz02b    LIKE pnz_file.pnz02 #FUN-C30031

 LET g_pna_t.* = g_pna.*
    SELECT pmm02 INTO g_pmm02     
      FROM pmm_file
     WHERE pmm01 = g_pna.pna01 AND pmm18 !='X'
 
    DISPLAY BY NAME g_pna.pnaoriu,g_pna.pnaorig,
         g_pna.pna01,g_pna.pna02,g_pna.pna04,g_pna.pna15,g_pna.pna16,   #FUN-650189 add g_pna.pna15   #FUN-A20057 add g_pna.pna16
         g_pna.pna08,g_pna.pna10,g_pna.pna11,g_pna.pna09,g_pna.pna12,
         g_pna.pna08b,g_pna.pna10b,g_pna.pna11b,g_pna.pna09b,g_pna.pna12b,
         g_pna.pna14,g_pna.pna05,g_pna.pna13,g_pna.pnaconf,
         g_pna.pna17,                                                   #No.FUN-A90009
         g_pna.pnauser,g_pna.pnagrup,g_pna.pnamodu,g_pna.pnadate,g_pna.pnaacti,
         g_pna.pnasendu,g_pna.pnasendd,g_pna.pnasendt,        #FUN-CC0094 add
         g_pna.pnaud01,g_pna.pnaud02,g_pna.pnaud03,g_pna.pnaud04,
         g_pna.pnaud05,g_pna.pnaud06,g_pna.pnaud07,g_pna.pnaud08,
         g_pna.pnaud09,g_pna.pnaud10,g_pna.pnaud11,g_pna.pnaud12,
         g_pna.pnaud13,g_pna.pnaud14,g_pna.pnaud15 
 
   #FUN-C30031---add---START
    SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01=g_pna.pna10
    SELECT pnz02 INTO l_pnz02 FROM pnz_file WHERE pnz01=g_pna.pna09
    SELECT pma02 INTO l_pma02b FROM pma_file WHERE pma01=g_pna.pna10b  
    SELECT pnz02 INTO l_pnz02b FROM pnz_file WHERE pnz01=g_pna.pna09b
    DISPLAY l_pma02  TO FORMONLY.pma02
    DISPLAY l_pnz02  TO FORMONLY.pnz02
    DISPLAY l_pma02b TO FORMONLY.pma02b  
    DISPLAY l_pnz02b TO FORMONLY.pnz02b 
   #FUN-C30031---add---END 

    #CKP
    IF g_pna.pna05='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_pna.pna13='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_pna.pna05,g_chr2,"","",g_chr,"")
 
    CALL s_pmista('pna',g_pna.pna13,g_pna.pna05,g_pna.pna14)  #No.6686
         RETURNING g_sta
    DISPLAY g_sta TO FORMONLY.desc2
    CALL t910_peo('d',g_pna.pna16)   #FUN-A20057
    CALL t910_pna01() #MOD-4A0148
    CALL t910_pna08b()               #No.FUN-550089
    CALL t910_pna15()                #FUN-650189 add
    CALL t910_b_fill(g_wc2)          #單身
    CALL cl_show_fld_cont()          #No.FUN-550037 hmf
END FUNCTION 
 
FUNCTION t910_r()
    DEFINE l_flag LIKE type_file.chr1
 
    IF s_shut(0) THEN RETURN END IF
    IF g_pna.pna01 IS NULL OR g_pna.pna01 = ' ' THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0079
       RETURN
    END IF
    #----> 如為'已發出',不可取消
    IF g_pna.pna05 = 'Y' THEN
       CALL cl_err('','apm-242',0)
       RETURN
    END IF
    IF g_pna.pna05 = 'X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
    IF g_pna.pnaconf = 'Y' THEN
       CALL cl_err('','apm-220',0)
       RETURN
    END IF
    IF g_pna.pna13 matches '[Ss1]' THEN          #FUN-550038
        CALL cl_err("","mfg3557",0)
        RETURN
    END IF
 
    BEGIN WORK
 
    OPEN t910_cl USING g_pna.pna01,g_pna.pna02
    IF STATUS THEN
       CALL cl_err("OPEN t910_cl:", STATUS, 1)
       CLOSE t910_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t910_cl INTO g_pna.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t910_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pna01"          #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "pna02"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pna.pna01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_pna.pna02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM pna_file WHERE pna01 = g_pna.pna01
                              AND pna02 = g_pna.pna02
         DELETE FROM pnb_file WHERE pnb01 = g_pna.pna01
                              AND pnb02 = g_pna.pna02
         LET l_flag = s_del_pnbi(g_pna.pna01,g_pna.pna02,'','')
         INITIALIZE g_pna.* TO NULL
         CLEAR FORM
         CALL g_pnb.clear()
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980006 add azoplant,azolegal
         VALUES ('apmt910',g_user,g_today,g_msg,g_pna.pna01,'delete',g_plant,g_legal) #FUN-980006 add g_plant,g_legal
         OPEN t910_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t910_b_cs
            CLOSE t910_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t910_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t910_b_cs
            CLOSE t910_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t910_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t910_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t910_fetch('/')
         END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t910_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_cnt           LIKE type_file.num5,                #No.MOD-650101 add  #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_misc          LIKE type_file.chr4,                #No.FUN-680136 VARCHAR(04)
    l_cmd           LIKE type_file.chr1,                #採購單身是否為新增  #No.FUN-680136 VARCHAR(1)
    l_no            LIKE pmn_file.pmn04,
    l_qty           LIKE pnb_file.pnb20a,		#Qty
    l_up            LIKE pnb_file.pnb31a,		#Unit Price
    lt_up           LIKE pnb_file.pnb32a,		#Unit Tax Price #No.FUN-610018
    l_ima07         LIKE ima_file.ima07,
    l_pml20,l_over  LIKE pml_file.pml20,
    l_pmn20         LIKE pmn_file.pmn20,
    l_pmn50_55_pnbislk01a      LIKE pmn_file.pmn50,   #已交量   #NO.FUN-810014 #No.FUN-870117
    l_pmn24         LIKE pmn_file.pmn24,
    l_pmn25         LIKE pmn_file.pmn25,
    l_pmn50_55      LIKE pmn_file.pmn50,   #已交量
    l_pmn011        LIKE pmn_file.pmn011,
    l_rvv17         LIKE rvv_file.rvv17,
    l_rvb87         LIKE rvb_file.rvb87,   #No.MOD-640426 add
    l_pnb20a        LIKE pnb_file.pnb20a,
    l_rvu01         LIKE rvu_file.rvu01,
    l_rate          LIKE sma_file.sma343,  #No.FUN-680136 DEC(5,2)
    l_possible      LIKE type_file.num5,   #No.FUN-680136 SMALLINT    #用來設定判斷重複的可能性
    l_new,l_old     LIKE pnb_file.pnb20a,
    l_i             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    l_rvb07         LIKE rvb_file.rvb07,
    l_sfb100        LIKE sfb_file.sfb100,
    l_newline       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)   #Y:為新的項次 No:7629
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680136 SMALLINT
    l_pna13         LIKE pna_file.pna13,    #MOD-5A0416
    l_pmm04         LIKE pmm_file.pmm04,
    l_pmm22         LIKE pmm_file.pmm22,
    l_pmm42         LIKE pmm_file.pmm42,
    l_price,lt_price LIKE ima_file.ima53,
    l_pna08    LIKE pna_file.pna08,
    l_pnb20    LIKE pnb_file.pnb20b,
    l_pnb07    LIKE pnb_file.pnb07b,
    l_pnb86    LIKE pnb_file.pnb86b,   #MOD-B30413 add
    l_pmm09    LIKE pmm_file.pmm09,
    l_pmm21    LIKE pmm_file.pmm21,
    l_pmm43    LIKE pmm_file.pmm43,
    l_pmn65         LIKE pmn_file.pmn65,  #代買性質   #MOD-640435 add
    l_imaag         LIKE ima_file.imaag,  #No.TQC-650108                                                                        
    l_imaag1        LIKE ima_file.imaag,  #No.TQC-650108 
    l_pmm909        LIKE pmm_file.pmm909  #MOD-920087
 
DEFINE  l_pml09     LIKE pml_file.pml09    #FUN-690129
DEFINE  l_pml21     LIKE pml_file.pml21    #FUN-690129
DEFINE  l_ima915    LIKE ima_file.ima915   #FUN-710060 add
DEFINE  l_pmn90     LIKE pmn_file.pmn90    #CHI-820014 add
DEFINE  l_task   LIKE ecm_file.ecm04,   #CHI-8A0022
        l_type   LIKE type_file.chr1    #CHI-8A0022
#FUN-A80142 --begin--   
DEFINE  l_count     LIKE type_file.num5
DEFINE  l_pjaacti   LIKE pja_file.pjaacti
DEFINE  l_pjaclose  LIKE pja_file.pjaclose
DEFINE  l_pjb09     LIKE pjb_file.pjb09
DEFINE  l_pjb11     LIKE pjb_file.pjb11
DEFINE  l_pjbacti   LIKE pjb_file.pjbacti
DEFINE  l_pjb25     LIKE pjb_file.pjb25
DEFINE  l_pnb35a    LIKE pnb_file.pnb35a
DEFINE  l_pjkacti   LIKE pjk_file.pjkacti
#FUN-A80142 --end--
DEFINE  l_tf        LIKE type_file.chr1   #FUN-910088--add--
DEFINE  l_flag      LIKE type_file.chr1 #TQC-C10099 add
DEFINE  l_date      LIKE type_file.dat  #TQC-C10099 add
DEFINE  l_qty2      LIKE pnb_file.pnb20a    #FUN-C30081 add
DEFINE  l_qty3      LIKE pnb_file.pnb20a    #FUN-C30081 add 
DEFINE  l_sfb08     LIKE sfb_file.sfb08     #FUN-C30081 add 
DEFINE  l_sql       STRING                  #FUN-C30081 add
DEFINE  l_ima55     LIKE ima_file.ima55     #FUN-C30081 add
DEFINE  l_sw        LIKE type_file.num5     #FUN-C30081 add
DEFINE  l_pmn07     LIKE pmn_file.pmn07     #FUN-C30081 add
DEFINE  l_pmn09     LIKE pmn_file.pmn09     #FUN-C30081 add
DEFINE  l_slip      LIKE smy_file.smyslip 

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_pna.pna01) THEN
       RETURN
    END IF
    #-----MOD-A30004--------- 
    SELECT * INTO g_pna.* FROM pna_file
      WHERE pna01 = g_pna.pna01
        AND pna02 = g_pna.pna02 
    #-----END MOD-A30004-----
    IF g_pna.pnaacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_pna.pna01,'aom-000',1)
       RETURN
    END IF
    #--->如為'已確認',不可異動
    IF g_pna.pna05='Y' THEN
       CALL cl_err('','apm-242',1)
       RETURN
    END IF
    IF g_pna.pna05='X' THEN
       CALL cl_err('','9024',1)
       RETURN
    END IF
    #--->如為'已發出',不可取消
    IF g_pna.pnaconf = 'Y' THEN
       CALL cl_err('','apm-224',1)
       RETURN
    END IF
    IF g_pna.pna13 matches '[Ss]' THEN
        CALL cl_err('','apm-030',0)
        RETURN
    END IF
    LET l_pna13 = g_pna.pna13

    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT pnb03,'0','',0,'',pnb04b,pnb041b,' ',pnb20b,pnb07b,pnb83b,pnb84b,pnb85b,",             #FUN-690129 add pnb90,pnb91  
      "        pnb80b,pnb81b,pnb82b,pnb86b,pnb87b,pnb31b,pnb32b,pnb87b*pnb31b,pnb87b*pnb32b,pnb34b,pnb35b,pnb36b,pnb33b,      ",	#MOD-6C0095
                      #FUN-A80142 add pnb34b,pnb35b,pnb36b
      "              '1',pnb90,pnb91,'',pnb04a,pnb041a,' ',pnb20a,pnb07a,pnb83a,pnb84a,pnb85a,",       #FUN-690129 add pnb90,pnb91 #No.FUN-870117
      "        pnb80a,pnb81a,pnb82a,pnb86a,pnb87a,pnb31a,pnb32a,0,0,pnb34a,pnb35a,pnb36a,pnb33a,pnb50 ", #No.FUN-550089
                      #FUN-A80142 add pnb34a,pnb35a,pnb36a,
      "   FROM pnb_file ",
      "   WHERE pnb01 = ? ",
      "    AND pnb02 = ? ",
      "    AND pnb03 = ? ",
      "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t910_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
       LET g_forupd_sql = "SELECT * FROM pnbi_file ",
                          " WHERE pnbi01= ? AND pnbi02 = ? AND pnbi03= ?  FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE t910_bcl_slk CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_pnb WITHOUT DEFAULTS FROM s_pnb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
  
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
              
        BEFORE ROW
            LET p_cmd = ''
            LET l_newline = 'N' #No:7629 一開始先設 "為新增的項次否='N'"
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t910_cl USING g_pna.pna01,g_pna.pna02
            IF STATUS THEN
               CALL cl_err("OPEN t910_cl:", STATUS, 1)
               CLOSE t910_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t910_cl INTO g_pna.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t910_cl
               ROLLBACK WORK
               RETURN
            END IF
            LET g_chkpnb31_flag = 'Y' #MOD-D10206 add
            LET g_chkpnb32_flag = 'Y' #MOD-D10206 add
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_pnb_t.* = g_pnb[l_ac].*  #BACKUP
                LET g_pnb03_o = g_pnb[l_ac].pnb03   #MOD-9B0165
 
                OPEN t910_bcl USING g_pna.pna01,g_pna.pna02,g_pnb_t.pnb03
                IF STATUS THEN
                    CALL cl_err("OPEN t910_bcl:", STATUS, 1)
                ELSE
                    FETCH t910_bcl INTO g_pnb[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_pnb_t.pnb03,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                       OPEN t910_bcl_slk USING g_pna.pna01,g_pna.pna02,g_pnb_t.pnb03
                       IF SQLCA.sqlcode THEN
                          CALL cl_err('lock pnbi',SQLCA.sqlcode,1)
                          LET l_lock_sw = "Y"
                       ELSE
                          FETCH t910_bcl_slk INTO b_pnbi.*
                          LET g_pnb[l_ac].pnbislk01a = b_pnbi.pnbislk01a  #No.FUN-870117
                          LET g_pnb[l_ac].pnbislk01b = b_pnbi.pnbislk01b  #No.FUN-870117
                          IF SQLCA.sqlcode THEN
                             CALL cl_err('lock pnbi',SQLCA.sqlcode,1)
                             LET l_lock_sw = "Y"
                          END IF
                       END IF
                    END IF
                    #--->計算tota(因 database 並不存有 tota 之資料)
                    #--->計算totta(因 database 並不存有 totta 之資料)
		    LET l_qty=g_pnb[l_ac].pnb87b  #MOD-6C0095
		    LET l_up=g_pnb[l_ac].pnb31b
		    LET lt_up=g_pnb[l_ac].pnb32b   #No.FUN-610018
		    IF NOT cl_null(g_pnb[l_ac].pnb87a) THEN
		        LET l_qty=g_pnb[l_ac].pnb87a
		    END IF
		  #MOD-6C0095..............end
                    IF NOT cl_null(g_pnb[l_ac].pnb31a) THEN
		    	LET l_up=g_pnb[l_ac].pnb31a
		    END IF
                    IF NOT cl_null(g_pnb[l_ac].pnb32a) THEN
		    	LET lt_up=g_pnb[l_ac].pnb32a
		    END IF
		            IF cl_null(g_pnb[l_ac].pnb87a) AND cl_null(g_pnb[l_ac].pnb31a) THEN	#MOD-6C0095
                        LET g_pnb[l_ac].tota = NULL
                    ELSE
                        LET g_pnb[l_ac].tota=l_qty*l_up
                    END IF
                    DISPLAY BY NAME g_pnb[l_ac].tota
                    IF cl_null(g_pnb[l_ac].pnb87a) AND cl_null(g_pnb[l_ac].pnb32a) THEN #MOD-6C0095
                        LET g_pnb[l_ac].totta = NULL
                    ELSE
                        LET g_pnb[l_ac].totta=l_qty*lt_up
                        DISPLAY BY NAME g_pnb[l_ac].totta
                    END IF
                    SELECT ima021 INTO g_pnb[l_ac].ima021a FROM ima_file
                     WHERE ima01=g_pnb[l_ac].pnb04a
                    SELECT ima021 INTO g_pnb[l_ac].ima021b FROM ima_file
                     WHERE ima01=g_pnb[l_ac].pnb04b
                    DISPLAY BY NAME g_pnb[l_ac].ima021a
                    DISPLAY BY NAME g_pnb[l_ac].ima021b
                   SELECT pmn24,pmn25 INTO g_pnb[l_ac].pnb90b,g_pnb[l_ac].pnb91b
                     FROM pmn_file
                    WHERE pmn01=g_pna.pna01  AND pmn02 = g_pnb[l_ac].pnb03
                   IF SQLCA.sqlcode THEN
                     LET g_pnb[l_ac].pnb90b = NULL
                     LET g_pnb[l_ac].pnb91b = NULL
                   END IF
                   DISPLAY BY NAME g_pnb[l_ac].pnb90b,g_pnb[l_ac].pnb91b
                    LET g_cnt=0
                    SELECT COUNT(*) INTO g_cnt
                        FROM pmn_file
                        WHERE pmn01=g_pna.pna01
                          AND pmn02=g_pnb[l_ac].pnb03
                    IF g_cnt = 0 THEN
                        LET l_newline='Y'
                    ELSE
                        LET l_newline='N'
                    END IF
                     CALL t910_set_no_entry_b1() #MOD-5A0416 add
                     CALL t910_set_no_required(l_newline) #MOD-530022
                     CALL t910_set_required(l_newline)    #MOD-530022
                END IF
                LET g_change='N'
                IF g_sma.sma115 = 'Y' THEN
                   IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
                      LET g_pnb04 = g_pnb[l_ac].pnb04a
                   ELSE
                      IF NOT cl_null(g_pnb[l_ac].pnb04b) THEN
                         LET g_pnb04 = g_pnb[l_ac].pnb04b
                      END IF
                   END IF
                   IF NOT cl_null(g_pnb04) THEN
                      SELECT ima44,ima31,ima906,ima907,ima908
                        INTO g_ima44,g_ima31,g_ima906,g_ima907,g_ima908
                        FROM ima_file WHERE ima01=g_pnb04
                   END IF
                   CALL t910_set_entry_b()
                   CALL t910_set_no_entry_b()
                   CALL t910_set_no_entry_b1() #MOD-5A0416 add
                   CALL t910_set_no_required(l_newline)
                   CALL t910_set_required(l_newline)
                END IF
 
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
       
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            IF g_sma.sma115 = 'Y' THEN
               IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
                  LET g_pnb04 = g_pnb[l_ac].pnb04a
                  SELECT ima44,ima31 INTO g_ima44,g_ima31
                    FROM ima_file WHERE ima01=g_pnb04
 
                  CALL s_chk_va_setting(g_pnb04)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD pnb04a
                  END IF
                  CALL s_chk_va_setting1(g_pnb04)
                       RETURNING g_flag,g_ima908
                  IF g_flag=1 THEN
                     NEXT FIELD pnb04a
                  END IF
               END IF
 
               CALL t910_set_origin_field()
               #計算pnb20,pnb07的值,檢查數量的合理性
               CALL t910_check_inventory_qty(p_cmd,l_newline)
                   RETURNING g_flag
               IF g_flag <> 0 THEN
                  INITIALIZE  g_pnb[l_ac].* TO NULL      #FUN-650166 add
                  DISPLAY g_pnb[l_ac].* To s_pnb[l_ac].* #FUN-650166 add
                  CANCEL INSERT
               END IF
            END IF     #No.MOD-720039 add
               IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN   #MOD-970212
                  #LET g_pnb[l_ac].pnb86a = g_pnb[l_ac].pnb07a #MOD-C30760 mark
                  #LET g_pnb[l_ac].pnb87a = g_pnb[l_ac].pnb20a #MOD-C30760 mark
                  IF NOT cl_null(g_pnb[l_ac].pnb07a) THEN #MOD-C30760 add                  
                     LET g_pnb[l_ac].pnb86a = g_pnb[l_ac].pnb07a
                  END IF 
                  IF NOT cl_null(g_pnb[l_ac].pnb20a) THEN #MOD-C30760 add 
                     LET g_pnb[l_ac].pnb87a = g_pnb[l_ac].pnb20a
                  END IF 
                  DISPLAY BY NAME g_pnb[l_ac].pnb86a
                  DISPLAY BY NAME g_pnb[l_ac].pnb87a
               END IF
            IF cl_null(g_pnb[l_ac].pnb041a) THEN           #MOD-9C0280
               LET g_pnb[l_ac].pnb041a=g_pnb[l_ac].pnb041b #MOD-9C0280
            END IF                                         #MOD-9C0280

            #MOD-C30673 ----- add start -----
            IF cl_null(g_pnb[l_ac].pnb90) AND NOT cl_null(g_pnb[l_ac].pnb90b) THEN
               LET g_pnb[l_ac].pnb90 = g_pnb[l_ac].pnb90b
            END IF
            IF cl_null(g_pnb[l_ac].pnb91) AND NOT cl_null(g_pnb[l_ac].pnb91b) THEN
               LET g_pnb[l_ac].pnb91 = g_pnb[l_ac].pnb91b
            END IF
            #MOD-C30673 ----- add end -----
            #MOD-C50198 mark start -----
            ##MOD-C30760 add begin #當計價數量為空,如果料號不變,僅變更單價或者交貨日期,取原來計價單位和計價數量
            #IF cl_null(g_pnb[l_ac].pnb87a) THEN 
            #   IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN   #MOD-970212
            #      IF (cl_null(g_pnb[l_ac].pnb04a) OR g_pnb[l_ac].pnb04a = g_pnb[l_ac].pnb04b) THEN 
            #         LET g_pnb[l_ac].pnb87a = g_pnb[l_ac].pnb87b
            #      END IF        
            #   END IF    
            #END IF 
            ##MOD-C30760 add end
            #MOD-C50198 mark end   -----
            #MOD-C50198 add start -----
            IF (cl_null(g_pnb[l_ac].pnb04a) OR g_pnb[l_ac].pnb04a = g_pnb[l_ac].pnb04b) AND
               g_pnb[l_ac].pnb041a = g_pnb[l_ac].pnb041b THEN
               IF cl_null(g_pnb[l_ac].pnb86a) THEN
                  LET g_pnb[l_ac].pnb86a = g_pnb[l_ac].pnb86b
               END IF
               IF cl_null(g_pnb[l_ac].pnb87a) THEN
                  LET g_pnb[l_ac].pnb87a = g_pnb[l_ac].pnb87b
               END IF
            END IF
            #MOD-C50198 add end   -----
            INSERT INTO pnb_file(pnb01,pnb02,pnb03,
                                 pnb04b,pnb07b,pnb20b,
                                 pnb31b,pnb32b,pnb33b,pnb041b,     #No.FUN-550089
                                 pnb04a,pnb20a,pnb31a,pnb32a,      #No.FUN-550089
                                 pnb33a,pnb041a,pnb07a,pnb50,
                                 pnb83b,pnb84b,pnb85b,pnb80b,
                                 pnb81b,pnb82b,pnb86b,pnb87b,
                                 pnb83a,pnb84a,pnb85a,pnb80a,
                                 pnb81a,pnb82a,pnb86a,pnb87a,pnb90,pnb91,pnbplant,pnblegal,
                                 pnb34a,pnb34b,pnb35a,pnb35b,pnb36a,pnb36b)                                 
                                 #FUN-690129 add pnb90,pnb91 #FUN-980006 add pnbplant,pnblegal
                                 #FUN-A80142 add  pnb34a,pnb34b,pnb35a,pnb35b,pnb36a,pnb36b
            VALUES(g_pna.pna01,g_pna.pna02, g_pnb[l_ac].pnb03,
                   g_pnb[l_ac].pnb04b, g_pnb[l_ac].pnb07b,
                   g_pnb[l_ac].pnb20b, g_pnb[l_ac].pnb31b,g_pnb[l_ac].pnb32b, #No.FUN-550089
                   g_pnb[l_ac].pnb33b, g_pnb[l_ac].pnb041b,
                   g_pnb[l_ac].pnb04a, g_pnb[l_ac].pnb20a,
                   g_pnb[l_ac].pnb31a, g_pnb[l_ac].pnb32a,g_pnb[l_ac].pnb33a, #No.FUN-550089
                   g_pnb[l_ac].pnb041a,g_pnb[l_ac].pnb07a,
                   g_pnb[l_ac].pnb50,  g_pnb[l_ac].pnb83b,g_pnb[l_ac].pnb84b,
                   g_pnb[l_ac].pnb85b, g_pnb[l_ac].pnb80b,g_pnb[l_ac].pnb81b,
                   g_pnb[l_ac].pnb82b, g_pnb[l_ac].pnb86b,g_pnb[l_ac].pnb87b,
                   g_pnb[l_ac].pnb83a, g_pnb[l_ac].pnb84a,
                   g_pnb[l_ac].pnb85a, g_pnb[l_ac].pnb80a,g_pnb[l_ac].pnb81a,
                   g_pnb[l_ac].pnb82a, g_pnb[l_ac].pnb86a,g_pnb[l_ac].pnb87a,
                   g_pnb[l_ac].pnb90, g_pnb[l_ac].pnb91,g_plant,g_legal,
                   g_pnb[l_ac].pnb34a,g_pnb[l_ac].pnb34b,g_pnb[l_ac].pnb35a,
                   g_pnb[l_ac].pnb35b,g_pnb[l_ac].pnb36a,g_pnb[l_ac].pnb36b
                   )
                   #FUN-690129 add pnb90,pnb91 #FUN-980006 add g_plant,g_legal
                   #FUN-A80142 add  pnb34a,pnb34b,pnb35a,pnb35b,pnb36a,pnb36b  
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_pnb[l_ac].pnb03,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
               INITIALIZE b_pnbi.* TO NULL  
               LET b_pnbi.pnbi01 = g_pna.pna01 
               LET b_pnbi.pnbi02 = g_pna.pna02
               LET b_pnbi.pnbi03 = g_pnb[l_ac].pnb03
               LET b_pnbi.pnbislk01b = g_pnb[l_ac].pnbislk01b    #No.FUN-870117
               LET b_pnbi.pnbislk01a = g_pnb[l_ac].pnbislk01a    #No.FUN-870117
               IF NOT s_ins_pnbi(b_pnbi.*,'') THEN
                  CANCEL INSERT
               END IF
               MESSAGE 'INSERT O.K'
               LET l_pna13 = '0'              #FUN-550038
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pnb[l_ac].* TO NULL      #900423
            LET g_pnb[l_ac].before = '0'
            LET g_pnb[l_ac].after  = '1'
            LET g_change='N'   #No.FUN-560194
            LET g_pnb_t.* = g_pnb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            CALL t910_set_no_required(l_newline) #MOD-530022
            CALL t910_set_no_entry_b1() #FUN-610018
            CALL t910_set_entry_b2('N')  #FUN-690129 add
 
       BEFORE FIELD pnb03 
          CALL t910_set_entry_b1() 
 
       AFTER FIELD pnb03
            LET l_tf = NULL #FUN-910088 add
            #------>判斷此採購單有無此項次(若無代表為新增line)
            IF NOT cl_null(g_pnb[l_ac].pnb03) THEN
               IF g_pnb[l_ac].pnb03 <> g_pnb03_o THEN
                  IF NOT cl_null(g_pnb[l_ac].pnb90) OR   
                     NOT cl_null(g_pnb[l_ac].pnb91) OR    
                     NOT cl_null(g_pnb[l_ac].pnbislk01a) OR 
                     NOT cl_null(g_pnb[l_ac].pnb04a) OR    
                     NOT cl_null(g_pnb[l_ac].pnb20a) OR    
                     NOT cl_null(g_pnb[l_ac].pnb07a) OR    
                     NOT cl_null(g_pnb[l_ac].pnb83a) OR    
                     NOT cl_null(g_pnb[l_ac].pnb85a) OR    
                     NOT cl_null(g_pnb[l_ac].pnb80a) OR 
                     NOT cl_null(g_pnb[l_ac].pnb82a) OR 
                     NOT cl_null(g_pnb[l_ac].pnb31a) OR 
                     NOT cl_null(g_pnb[l_ac].pnb32a) OR 
                     NOT cl_null(g_pnb[l_ac].pnb33a) THEN    
                     IF cl_confirm('apm-360') THEN  
                        LET g_pnb[l_ac].pnb90  = NULL
                        LET g_pnb[l_ac].pnb91  = NULL
                        LET g_pnb[l_ac].pnbislk01a = NULL
                        LET g_pnb[l_ac].pnb04a = NULL
                        LET g_pnb[l_ac].pnb041a= NULL
                        LET g_pnb[l_ac].ima021a= NULL
                        LET g_pnb[l_ac].pnb04a = NULL
                        LET g_pnb[l_ac].pnb20a = NULL
                        LET g_pnb[l_ac].pnb07a = NULL
                        LET g_pnb[l_ac].pnb83a = NULL
                        LET g_pnb[l_ac].pnb85a = NULL
                        LET g_pnb[l_ac].pnb80a = NULL
                        LET g_pnb[l_ac].pnb82a = NULL
                        LET g_pnb[l_ac].pnb86a = NULL
                        LET g_pnb[l_ac].pnb87a = NULL
                        LET g_pnb[l_ac].tota   = NULL
                        LET g_pnb[l_ac].totta  = NULL
                        LET g_pnb[l_ac].pnb31a = NULL
                        LET g_pnb[l_ac].pnb32a = NULL
                        LET g_pnb[l_ac].pnb33a = NULL
                        LET g_pnb[l_ac].pnb34a = NULL     #FUN-A80142 
                        LET g_pnb[l_ac].pnb35a = NULL     #FUN-A80142 
                        LET g_pnb[l_ac].pnb36a = NULL     #FUN-A80142                                                
                     ELSE
                        LET g_pnb[l_ac].pnb03 = g_pnb03_o
                        NEXT FIELD pnb03
                     END IF
                  END IF
                  LET g_pnb[l_ac].pnb041a= NULL
                  LET g_pnb[l_ac].ima021a= NULL
                  LET g_pnb[l_ac].pnb86a = NULL
                  LET g_pnb[l_ac].pnb87a = NULL
                  LET g_pnb[l_ac].tota   = NULL
                  LET g_pnb[l_ac].totta  = NULL
               END IF
                LET l_cnt = 0
                SELECT COUNT(*)  INTO l_cnt FROM pmn_file 
                   WHERE pmn01 = g_pna.pna01
                     AND pmn02 = g_pnb[l_ac].pnb03
                     AND  pmn16 IN ('6','7','8')
                IF l_cnt > 0 THEN
                   CALL cl_err(g_pmm02,'apm-049',1)
                   NEXT FIELD pnb03
                END IF
                LET g_cnt=0
                SELECT COUNT(*) INTO g_cnt
                    FROM pmn_file
                    WHERE pmn01=g_pna.pna01
                      AND pmn02=g_pnb[l_ac].pnb03
                IF g_cnt = 0 THEN
                  #CHI-D30023 add start -----
                   SELECT * INTO g_pmm.* FROM pmm_file WHERE pmm01 = g_pna.pna01
                   IF g_pmm.pmm02 = 'TAP' AND g_pmm.pmm906 = 'N' AND NOT cl_null(g_pmm.pmm906) THEN
                      CALL cl_err('','apm1104',1)
                      NEXT FIELD pnb03
                   END IF
                  #CHI-D30023 add end   -----
  #TQC-C30173--add--begin--
                    IF g_azw.azw04 = '2' THEN
                       CALL cl_err(g_pnb[l_ac].pnb03,'mfg-316',0)
                       NEXT FIELD pnb03      
                    ELSE
                       LET l_newline = 'Y' #新增的項次
                       LET g_pnb[l_ac].pnbislk01b='' #No.FUN-870117
                       LET g_pnb[l_ac].pnb04b=''
                       LET g_pnb[l_ac].pnb041b=''
                       LET g_pnb[l_ac].ima021b=''
                      #LET g_pnb[l_ac].pnb20b=0 #CHI-B40018 mark
                      #LET g_pnb[l_ac].pnb31b=0 #CHI-B40018 mark
                      #LET g_pnb[l_ac].pnb32b=0 #CHI-B40018 mark
                       LET g_pnb[l_ac].pnb33b=''
                       LET g_pnb[l_ac].pnb34b = ''     #FUN-A80142
                       LET g_pnb[l_ac].pnb35b = ''     #FUN-A80142
                       LET g_pnb[l_ac].pnb36b = ''     #FUN-A80142
                      #LET g_pnb[l_ac].totb  =0 #CHI-B40018 mark
                       DISPLAY BY NAME g_pnb[l_ac].pnbislk01b   #No.FUN-870117
                       DISPLAY BY NAME g_pnb[l_ac].pnb04b
                       DISPLAY BY NAME g_pnb[l_ac].pnb041b
                       DISPLAY BY NAME g_pnb[l_ac].ima021b
                       DISPLAY BY NAME g_pnb[l_ac].pnb20b
                       DISPLAY BY NAME g_pnb[l_ac].pnb31b
                       DISPLAY BY NAME g_pnb[l_ac].pnb33b
                       DISPLAY BY NAME g_pnb[l_ac].totb
                      #LET g_pnb[l_ac].tottb =0 #CHI-B40018 mark
                       DISPLAY BY NAME g_pnb[l_ac].pnb04b
                       DISPLAY BY NAME g_pnb[l_ac].pnb041b
                       DISPLAY BY NAME g_pnb[l_ac].ima021b
                       DISPLAY BY NAME g_pnb[l_ac].pnb20b
                       DISPLAY BY NAME g_pnb[l_ac].pnb31b
                       DISPLAY BY NAME g_pnb[l_ac].pnb33b
                       DISPLAY BY NAME g_pnb[l_ac].totb
                       DISPLAY BY NAME g_pnb[l_ac].tottb
                       DISPLAY BY NAME g_pnb[l_ac].pnb34b      #FUN-A80142
                       DISPLAY BY NAME g_pnb[l_ac].pnb35b      #FUN-A80142
                       DISPLAY BY NAME g_pnb[l_ac].pnb36b      #FUN-A80142

                       IF g_pmm02 ='SUB' THEN
                          #委外採購單變更不可新增項次 !!
                          CALL cl_err(g_pmm02,'mfg-017',0)
                          NEXT FIELD pnb03
                       END IF
                       LET l_pmm909 = ''
                       SELECT pmm909 INTO l_pmm909 FROM pmm_file
                         WHERE pmm01 = g_pna.pna01 AND pmm18 !='X'
                       IF l_pmm909 = '3' THEN
                          CALL cl_err('','apm-078',0)
                          NEXT FIELD pnb03
                       END IF
                       #CHI-B50016 add --start--
                       IF g_blanketpo = 'Y' THEN
                          CALL cl_err('','apm-148',0)
                          NEXT FIELD pnb03
                       END IF
                       #CHI-B50016 add --end--

                       IF g_sma.sma32='Y' THEN
                           #參數設勾稽請採購,必須輸入請購單號，序號
                           CALL t910_set_required(l_newline)   #MOD-D10200 add
                           CALL t910_set_entry_b2(l_newline)
                           CALL t910_set_no_entry_b2(l_newline)
                           NEXT FIELD pnb90
                       END IF
                    END IF
                ELSE
                    LET l_newline = 'N' #不是新增的項次
                    CALL t910_pnb03(p_cmd)
            #FUN-910088--add--start--
                    IF g_sma.sma115 != 'N' THEN
                       LET g_pnb[l_ac].pnb20a = s_digqty(g_pnb[l_ac].pnb20a,g_pnb[l_ac].pnb07a)
                       DISPLAY BY NAME g_pnb[l_ac].pnb20a
                    ELSE
                       IF NOT cl_null(g_pnb[l_ac].pnb20a) AND g_pnb[l_ac].pnb20a <> 0 THEN
                          CALL t910_pnb20a_check(l_newline) RETURNING l_tf
                       END IF
                    END IF
            #FUN-910088--add--end--
                    IF NOT cl_null(g_errno) THEN
                        LET g_pnb[l_ac].pnb03=g_pnb_t.pnb03
                        DISPLAY BY NAME g_pnb[l_ac].pnb03
                        DISPLAY BY NAME g_pnb[l_ac].pnb03
                    END IF 
                END IF
                CALL t910_set_no_entry_b1()    #MOD-8B0047
                CALL t910_set_no_required(l_newline)
                CALL t910_set_required(l_newline)
                CALL t910_check_price() #MOD-D10206 add
            END IF
            LET g_pnb03_o = g_pnb[l_ac].pnb03   #MOD-9B0165
          #FUN-910088--add--start--
           IF NOT cl_null(l_tf) AND NOT l_tf THEN
              NEXT FIELD pnb20a
           END IF
          #FUN-910088--add--end--
 
       AFTER FIELD pnb90
         LET l_cnt = 0
         IF NOT cl_null(g_pnb[l_ac].pnb90) 
            AND (g_pnb[l_ac].pnb90 <> g_pnb_t.pnb90
             OR cl_null(g_pnb_t.pnb90)) THEN
            IF cl_null(g_pnb[l_ac].pnb91) THEN
              SELECT COUNT(*) INTO l_cnt FROM pmk_file
               WHERE pmk01 = g_pnb[l_ac].pnb90
                 AND pmk18 ='Y' 
              IF l_cnt = 0 THEN
                 CALL cl_err('','apm-115',0)
                 NEXT FIELD pnb90
              END IF
            ELSE 
              SELECT COUNT(*) INTO l_cnt FROM pmk_file,pml_file
               WHERE pmk01 = pml01
                 AND pmk01 = g_pnb[l_ac].pnb90
                 AND pml02 = g_pnb[l_ac].pnb91
                 AND pmk18 ='Y' 
              IF l_cnt = 0 THEN
                 CALL cl_err('','apm-116',0)
                 NEXT FIELD pnb90
              END IF
              CALL t910_pnb91()
            END IF
         END IF 
  #MOD-C30372 ----- add ----- begin
         IF cl_null(g_pnb[l_ac].pnb90)
            AND NOT cl_null(g_pnb[l_ac].pnb91) THEN
              SELECT COUNT(*) INTO l_cnt FROM pmk_file,pml_file
               WHERE pmk01 = pml01
                 AND pmk01 = g_pnb[l_ac].pnb90
                 AND pml02 = g_pnb[l_ac].pnb91
                 AND pmk18 ='Y'
              IF l_cnt = 0 THEN
                   CALL cl_err('','apm-116',0)
                   NEXT FIELD pnb90
              END IF 
         END IF
#MOD-C30372 ----- add ----- end
 
      #MOD-B40038 mark --start--
      #BEFORE FIELD pnb91
      #  IF cl_null(g_pnb[l_ac].pnb90) THEN
      #     NEXT FIELD pnb90
      #  END IF
      #MOD-B40038 mark --end--
 
       AFTER FIELD pnb91
         #MOD-D10200 -- remark start --
          #MOD-B90119 mark ---start---------
          #MOD-B40038 add --start--
          IF g_sma.sma32 matches'[Yy]' THEN #請購與採購互相勾稽
             IF g_pmm02 = 'SUB' THEN 
                ELSE
                IF cl_null(g_pnb[l_ac].pnb90) OR
                   cl_null(g_pnb[l_ac].pnb91) THEN
                      #請購與採購互相勾稽,請購單號-項次不可空白,
                      #且要存在請購單維護作業(apmt420)
                      CALL cl_err('','apm-540 ',1) 
                      NEXT FIELD pnb90
                END IF
             END IF
          END IF
          #MOD-B40038 add --end--
          #MOD-B90119 mark ---end----
         #MOD-D10200 -- remark end --
         LET l_cnt = 0
         IF NOT cl_null(g_pnb[l_ac].pnb91) 
             AND (g_pnb[l_ac].pnb91 <> g_pnb_t.pnb91
              OR  cl_null(g_pnb_t.pnb91) )THEN
           SELECT COUNT(*) INTO l_cnt FROM pmk_file,pml_file
            WHERE pmk01 = pml01
              AND pmk01 = g_pnb[l_ac].pnb90
              AND pml02 = g_pnb[l_ac].pnb91
              AND pmk18 ='Y' 
           IF l_cnt = 0 THEN
              CALL cl_err('','apm-116',0)
              NEXT FIELD pnb91
           END IF
           CALL t910_pnb91()
           CALL t910_pnb91_chk()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              NEXT FIELD pnb91
           END IF 
         END IF 
       AFTER FIELD pnbislk01a   #No.FUN-870117 pnbislk01-->pnbislk01a
         IF NOT cl_null(g_pnb[l_ac].pnbislk01a) THEN 
            SELECT COUNT(*)  INTO l_cnt FROM skd_file WHERE skd01=g_pnb[l_ac].pnbislk01a
                                                         AND skd04='Y'
            IF l_cnt <= 0 THEN
                   NEXT FIELD pnbislk01a
            END IF
            SELECT (pmn50-pmn55) INTO l_pmn50_55_pnbislk01a   #已交量
                                             
              FROM pmn_file
             WHERE  pmn01 = g_pna.pna01
               AND   pmn02 = g_pnb[l_ac].pnb03
               IF l_pmn50_55_pnbislk01a AND g_pnb[l_ac].pnbislk01b != g_pnb[l_ac].pnbislk01a THEN  #TQC-940137 add
                 CALL cl_err('','apm-283',0)     # 此採購料號已有交貨
                 LET g_pnb[l_ac].pnbislk01a = NULL
                 NEXT FIELD pnbislk01a
               END IF
         END IF   
 
       BEFORE FIELD pnb04a
            LET l_tf = NULL #FUN-910088 add
            #------>是否有重複輸入項次
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_pnb[l_ac].pnb03 != g_pnb_t.pnb03) THEN
                SELECT count(*) INTO l_n FROM pnb_file
                    WHERE pnb01 = g_pna.pna01
                      AND pnb02 = g_pna.pna02
                      AND pnb03 = g_pnb[l_ac].pnb03
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_pnb[l_ac].pnb03,-239,0)
                    LET g_pnb[l_ac].pnb03 = g_pnb_t.pnb03
                    NEXT FIELD pnb03
                END IF
            END IF
            #------>判斷此採購單有無此項次(若無代表為新增line)
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt
                FROM pmn_file
                WHERE pmn01=g_pna.pna01
                  AND pmn02=g_pnb[l_ac].pnb03
            IF g_cnt = 0 THEN
                IF g_pmm02 ='SUB' THEN
                   CALL cl_err(g_pmm02,'mfg-017',0)
                   NEXT FIELD pnb03
                END IF
              IF g_sma.sma32 <>'Y' THEN  #FUN-690129 #不是請採購勾稽的
                LET l_newline = 'Y' #No:7629 為新增的項次
                LET g_pnb[l_ac].pnbislk01b=''  #No.FUN-870117
                LET g_pnb[l_ac].pnb04b=''
                LET g_pnb[l_ac].pnb041b=''
                LET g_pnb[l_ac].ima021b=''
               #LET g_pnb[l_ac].pnb20b=0 #CHI-B40018 mark 
               #LET g_pnb[l_ac].pnb31b=0 #CHI-B40018 mark
               #LET g_pnb[l_ac].pnb32b=0        #No.FUN-550089 #CHI-B40018 mark
                LET g_pnb[l_ac].pnb33b=''
                LET g_pnb[l_ac].pnb34b= ''       #FUN-A80142 
                LET g_pnb[l_ac].pnb35b= ''       #FUN-A80142                 
                LET g_pnb[l_ac].pnb36b= ''       #FUN-A80142                 
               #LET g_pnb[l_ac].totb  =0 #CHI-B40018 mark
                DISPLAY BY NAME g_pnb[l_ac].pnbislk01b  #No.FUN-870117
                DISPLAY BY NAME g_pnb[l_ac].pnb04b
                DISPLAY BY NAME g_pnb[l_ac].pnb041b
                DISPLAY BY NAME g_pnb[l_ac].ima021b
                DISPLAY BY NAME g_pnb[l_ac].pnb20b
                DISPLAY BY NAME g_pnb[l_ac].pnb31b
                DISPLAY BY NAME g_pnb[l_ac].pnb33b
                DISPLAY BY NAME g_pnb[l_ac].pnb34b    #FUN-A80142                 
                DISPLAY BY NAME g_pnb[l_ac].pnb35b    #FUN-A80142  
                DISPLAY BY NAME g_pnb[l_ac].pnb36b    #FUN-A80142                                  
                DISPLAY BY NAME g_pnb[l_ac].totb
               #LET g_pnb[l_ac].tottb =0        #No.FUN-610018 #CHI-B40018 mark
                DISPLAY BY NAME g_pnb[l_ac].pnbislk01b  #No.FUN-870117
#FUN-A80142 --MARK --
#                DISPLAY BY NAME g_pnb[l_ac].pnb04b
#                DISPLAY BY NAME g_pnb[l_ac].pnb041b
#                DISPLAY BY NAME g_pnb[l_ac].ima021b
#                DISPLAY BY NAME g_pnb[l_ac].pnb20b
#                DISPLAY BY NAME g_pnb[l_ac].pnb31b
#                DISPLAY BY NAME g_pnb[l_ac].pnb33b
#                DISPLAY BY NAME g_pnb[l_ac].totb
#                DISPLAY BY NAME g_pnb[l_ac].tottb
#FUN-A80142 --mark--                
              END IF  #FUN-690191
            ELSE
                LET l_newline = 'N' #No:7629 為新增的項次
                CALL t910_pnb03(p_cmd)
             #FUN-910088--add--start--
                    IF g_sma.sma115 != 'N' THEN
                       LET g_pnb[l_ac].pnb20a = s_digqty(g_pnb[l_ac].pnb20a,g_pnb[l_ac].pnb07a)
                       DISPLAY BY NAME g_pnb[l_ac].pnb20a
                    ELSE
                       IF NOT cl_null(g_pnb[l_ac].pnb20a) AND g_pnb[l_ac].pnb20a <> 0 THEN
                          CALL t910_pnb20a_check(l_newline) RETURNING l_tf
                       END IF
                    END IF
            #FUN-910088--add--end--
                IF NOT cl_null(g_errno) THEN
                    LET g_pnb[l_ac].pnb03=g_pnb_t.pnb03
                    DISPLAY BY NAME g_pnb[l_ac].pnb03
                    DISPLAY BY NAME g_pnb[l_ac].pnb03
                    NEXT FIELD pnb03
                END IF
            END IF
            #--->料號處理
             SELECT DISTINCT(sfb100) INTO l_sfb100
               FROM sfb_file,pmn_file,pna_file   #NO:6961
              WHERE pmn01=pna01
                AND pmn02 =g_pnb[l_ac].pnb03
                AND pmn41=sfb01
                AND pna01 =g_pna.pna01
                AND pna02 =g_pna.pna02
 
            IF g_pmm02='SUB' THEN
               CASE WHEN  l_sfb100='1'          #委外1對1 只能改單價   #NO:6961
                          IF g_gec07 = 'Y' THEN     #NO.FUN-560102
                             IF g_chkpnb32_flag = 'Y' THEN #MOD-D10206 add
                               #MOD-D30073 add start -----
                                SELECT pnz04 INTO g_pnz04 FROM pnz_file WHERE pnz01 = g_term
                                IF cl_null(g_pnz04) THEN 
                                   LET g_pnz04 = 'Y'
                                END IF 
                                IF g_pnz04 = 'Y' THEN
                               #MOD-D30073 add end   -----
                                   NEXT FIELD pnb32a
                               #MOD-D30073 add start -----
                                ELSE
                                    NEXT FIELD pnb03
                                END IF
                               #MOD-D30073 add end    -----
                             #MOD-D10206 add start -----
                             ELSE
                                NEXT FIELD pnb03
                             END IF
                            #MOD-D10206 add end   -----
                          ELSE
                            IF g_chkpnb31_flag = 'Y' THEN #MOD-D10206 add
                              #MOD-D30073 add start -----
                               SELECT pnz04 INTO g_pnz04 FROM pnz_file WHERE pnz01 = g_term
                               IF cl_null(g_pnz04) THEN 
                                  LET g_pnz04 = 'Y'
                               END IF 
                               IF g_pnz04 = 'Y' THEN
                              #MOD-D30073 add end   -----
                                  NEXT FIELD pnb31a
                              #MOD-D30073 add start -----
                               ELSE
                                  NEXT FIELD pnb03
                               END IF
                              #MOD-D30073 add end    -----
                            #MOD-D10206 add start -----
                            ELSE
                               NEXT FIELD pnb03
                            END IF
                            #MOD-D10206 add end   -----
                          END IF
                    WHEN  l_sfb100='2'          #委外1對多 能改單價,數量
                          IF g_sma.sma115 = 'N' THEN
                             NEXT FIELD pnb20a
                          ELSE
                             IF g_ima906 = '2' OR g_ima906= '3' THEN
                                NEXT FIELD pnb85a
                             ELSE
                                NEXT FIELD pnb82a
                             END IF
                          END IF
               END CASE
            END IF
            IF g_sma.sma32='Y' THEN
               IF l_newline = 'Y' THEN
               ELSE
                   #參數設勾稽請採購,採購變更時不可變更料號
                  IF cl_null(g_pnb[l_ac].pnb90b) THEN  
                     CALL cl_err('','apm-917',0)
                     #NEXT FIELD pnb041a       #MOD-C10145 mark
                     LET g_pnb[l_ac].pnb90 = g_pnb[l_ac].pnb90b    #MOD-C30069 add
                     LET g_pnb[l_ac].pnb91 = g_pnb[l_ac].pnb91b    #MOD-C30069 add
                     LET g_pnb[l_ac].pnb04a = g_pnb[l_ac].pnb04b   #MOD-C30069 add
                  END IF    
               END IF
            END IF
            CALL t910_set_entry_b()
            CALL t910_set_entry_b1() #MOD-5A0416 add
           #TQC-C50238 -- add -- begin
            IF g_sma.sma32='Y' THEN
               IF l_newline = 'Y' THEN
                  CALL cl_set_comp_entry('pnb04a',TRUE)
               ELSE
                  CALL cl_set_comp_entry('pnb04a',FALSE)
               END IF
            END IF
           #TQC-C50238 -- add -- end
            CALL t910_check_price() #MOD-D10206 add
            CALL t910_set_no_required(l_newline) #MOD-530022
            CALL t910_set_required(l_newline)    #MOD-530022
         #FUN-910088--add--start--
           IF NOT cl_null(l_tf) AND NOT l_tf THEN
              NEXT FIELD pnb20a
           END IF
         #FUN-910088--add--end--

 
        AFTER FIELD pnb04a
            IF NOT cl_null(g_pnb[l_ac].pnb03) THEN
              IF l_newline='Y' AND cl_null(g_pnb[l_ac].pnb04a) THEN
                 #新增項次,所以此欄位不可空白
                 CALL cl_err('','apm-915',0)
                 NEXT FIELD pnb04a
              END IF
            END IF
            #--->代表有變更料號
            LET l_misc=g_pnb[l_ac].pnb04a[1,4]
            IF g_pnb[l_ac].pnb04a[1,4]='MISC' THEN  #NO:6808
                SELECT COUNT(*) INTO l_n FROM ima_file
                 WHERE ima01=l_misc
                   AND ima01='MISC'
                IF l_n=0 THEN
                   CALL cl_err('','aim-806',0)
                   NEXT FIELD pnb04a
                END IF
            END IF
 
            IF (NOT cl_null(g_pnb[l_ac].pnb04a) OR g_pnb[l_ac].pnb04a != g_pnb[l_ac].pnb04b) THEN  #NO:6808
 #FUN-AA0059 ---------------------start----------------------------
                IF NOT s_chk_item_no(g_pnb[l_ac].pnb04a,"") THEN
                   CALL cl_err('',g_errno,1)
                   LET g_pnb[l_ac].pnb04a = g_pnb_t.pnb04a 
                   NEXT FIELD pnb04a
                END IF
#FUN-AA0059 ---------------------end-------------------------------
              IF g_sma.sma120 = 'N' THEN         #No.FUN-830121
                 SELECT imaag,imaag1 INTO l_imaag,l_imaag1 FROM ima_file                                                            
                  WHERE ima01 =g_pnb[l_ac].pnb04a                                                                                   
                 IF NOT CL_null(l_imaag) AND l_imaag <> '@CHILD' THEN                                                               
                    CALL cl_err(g_pnb[l_ac].pnb04a,'aim1004',0)                                                                            
                    NEXT FIELD pnb04a                                                                                                
                 END IF
              END IF                                #No.FUN-830121                                                                                                                      
                 IF g_sma.sma120 ='Y' AND g_sma.sma907 ='Y' THEN                                                                   
                    LET g_t1 =g_pna.pna01[1,g_doc_len]                                                                             
                    SELECT smy62 INTO g_smy62 FROM smy_file                                                                        
                     WHERE smyslip =g_t1                                                                                           
                    IF NOT cl_null(g_smy62) THEN                                                                                   
                       IF g_smy62 <> l_imaag1 THEN                                                                                 
                          CALL cl_err('','atm-525',0)                                                                              
                          NEXT FIELD pnb04a                                                                                        
                       END IF                                                                                                      
                       IF cl_null(l_imaag1) THEN                                                                                   
                          CALL cl_err('','atm-525',0)                                                                              
                          NEXT FIELD pnb04a                                                                                        
                       END IF  
                    END IF                                                                                                         
                 END IF                                                                                                            
            IF cl_null(g_pnb[l_ac].pnb041a) OR (g_pnb[l_ac].pnb04a <> g_pnb_t.pnb04a)  THEN
               LET l_no=g_pnb[l_ac].pnb04a
               CALL t910_pnb04a(l_no)                     #判斷有效否
               IF NOT cl_null(g_errno) THEN
                  IF l_no[1,4] = 'MISC' THEN
                     DISPLAY BY NAME g_pnb[l_ac].pnb04a
                  ELSE
                     CALL cl_err(g_pnb[l_ac].pnb04a,g_errno,0)
                     LET g_pnb[l_ac].pnb04a = g_pnb_t.pnb04a
                     NEXT FIELD pnb04a
                  END IF
               END IF
               END IF
               #---->當已交量>0時,不可變更料編號
               IF NOT cl_null(g_pnb[l_ac].pnb04b)
                  THEN
                  SELECT (pmn50-pmn55),pmn011 INTO l_pmn50_55,      #已交量
                                                   l_pmn011
                  FROM pmn_file
                  WHERE  pmn01 = g_pna.pna01
                   AND   pmn02 = g_pnb[l_ac].pnb03
                  IF l_pmn50_55 > 0 AND g_pnb[l_ac].pnb04b != g_pnb[l_ac].pnb04a THEN    #TQC-940137
                     CALL cl_err('','apm-283',0)     # 此採購料號已有交貨
                     LET g_pnb[l_ac].pnb04a = NULL
                     LET g_pnb[l_ac].pnb041a = NULL #MOD-B30666 add
                     LET g_pnb[l_ac].ima021a = NULL #MOD-B30666 add
                     NEXT FIELD pnb04a
                  END IF
               END IF
 
               #--->如變更料號,去select ima 資料(參考apmt550)
               LET l_no = g_pnb[l_ac].pnb04a[1,4]
            END IF
            #--->採購料件/供應商控制
            SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=g_pnb[l_ac].pnb04a #FUN-710060 add 
            IF l_no[1,4] != 'MISC' THEN
               IF NOT cl_null(g_pnb_t.pnb04a) THEN
                  IF (g_pnb_t.pnb04a!= g_pnb[l_ac].pnb04a)  THEN
                     IF l_ima915='2' OR l_ima915='3' THEN   #FUN-710060 mod
                        CALL t910_pmh()
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_pnb[l_ac].pnb04a,g_errno,0)
                           LET g_pnb[l_ac].pnb04a = g_pnb_t.pnb04a
                           DISPLAY BY NAME g_pnb[l_ac].pnb04a
                           NEXT FIELD pnb04a
                         END IF
                     END IF
                  END IF
                ELSE
                  IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
                     IF l_ima915='2' OR l_ima915='3' THEN   #FUN-710060 mod
                        CALL t910_pmh()
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_pnb[l_ac].pnb04a,g_errno,0)
                           LET g_pnb[l_ac].pnb04a = g_pnb_t.pnb04a
                           DISPLAY BY NAME g_pnb[l_ac].pnb04a
                           NEXT FIELD pnb04a
                        END IF
                     END IF
                  END IF
                END IF
             END IF
             IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
                IF g_sma.sma115 = 'Y' THEN
                   CALL s_chk_va_setting(g_pnb[l_ac].pnb04a)
                        RETURNING g_flag,g_ima906,g_ima907
                   IF g_flag=1 THEN
                      NEXT FIELD pnb04a
                   END IF
                   CALL s_chk_va_setting1(g_pnb[l_ac].pnb04a)
                        RETURNING g_flag,g_ima908
                   IF g_flag=1 THEN
                      NEXT FIELD pnb04a
                   END IF
                   CALL t910_du_default(p_cmd)   
                   IF NOT cl_null(g_pnb[l_ac].pnb04b)  THEN
                      LET g_pnb[l_ac].pnb82a=NULL
                      LET g_pnb[l_ac].pnb85a=NULL
                      LET g_pnb[l_ac].pnb87a=NULL
                   END IF 
                END IF      #No.MOD-720039 add
                   IF cl_null(g_pnb[l_ac].pnb04b) THEN
                      CALL t910_du_default(p_cmd)
                   END IF
                   LET g_pnb04 = g_pnb[l_ac].pnb04a
                   LET g_change='Y'
             ELSE
                SELECT ima44,ima906,ima907,ima908
                  INTO g_ima44,g_ima906,g_ima907,g_ima908 FROM ima_file
                 WHERE ima01=g_pnb[l_ac].pnb04b
                LET g_pnb04 = g_pnb[l_ac].pnb04b
             END IF
            CALL t910_set_no_entry_b()
            CALL t910_set_no_entry_b1() #MOD-5A0416 add
            CALL t910_check_price() #MOD-D10206 add
 
         ON CHANGE pnb04a
            CALL t910_pnb04a(g_pnb[l_ac].pnb04a)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pnb[l_ac].pnb04a,g_errno,0)
               NEXT FIELD pnb04a
            END IF
 
        #---> 輸入數量後,是否大於未交量
        AFTER FIELD pnb20a
           IF NOT t910_pnb20a_check(l_newline) THEN NEXT FIELD pnb20a END IF  #FUN-910088--add--
           #MOD-C30043 add --start--
           IF cl_null(g_pnb[l_ac].pnb20a) THEN
              LET g_pnb[l_ac].pnb87a = NULL
           END IF
           #--->計算tota,totta
           LET l_qty=g_pnb[l_ac].pnb87b
           LET l_up=g_pnb[l_ac].pnb31b
           LET lt_up=g_pnb[l_ac].pnb32b
           IF NOT cl_null(g_pnb[l_ac].pnb87a) THEN
              LET l_qty=g_pnb[l_ac].pnb87a
           END IF
           IF NOT cl_null(g_pnb[l_ac].pnb31a) THEN
              LET l_up=g_pnb[l_ac].pnb31a
           END IF
           IF NOT cl_null(g_pnb[l_ac].pnb32a) THEN
              LET lt_up=g_pnb[l_ac].pnb32a
           END IF

           IF cl_null(g_pnb[l_ac].pnb87a) AND cl_null(g_pnb[l_ac].pnb31a) THEN 
               LET g_pnb[l_ac].tota = NULL
           ELSE
               LET g_pnb[l_ac].tota=l_qty*l_up
           END IF
           IF cl_null(g_pnb[l_ac].pnb87a) AND cl_null(g_pnb[l_ac].pnb32a) THEN 
               #LET g_pnb[g_cnt].totta = NULL #TQC-C30231 mark
               LET g_pnb[l_ac].totta = NULL   #TQC-C30231 add
           ELSE
               #LET g_pnb[g_cnt].totta=l_qty*lt_up #TQC-C30231 mark
               LET g_pnb[l_ac].totta=l_qty*lt_up  #TQC-C30231 add
           END IF
           DISPLAY BY NAME g_pnb[l_ac].tota
           DISPLAY BY NAME g_pnb[l_ac].totta
           #MOD-C30043 add --end--
            #-----MOD-A50031---------
            ##No:7629
            #IF l_newline='Y' AND cl_null(g_pnb[l_ac].pnb20a) THEN 
            #    #新增項次,所以此欄位不可空白
            #    CALL cl_err('','apm-915',0)
            #   #NEXT FIELD pnb20a
            #END IF
            ##No:7629(end)
     #FUN-910088--mark--start--
     #      IF l_newline='Y' AND 
     #         (cl_null(g_pnb[l_ac].pnb20a) OR g_pnb[l_ac].pnb20a <=0 ) THEN 
     #         CALL cl_err('','mfg3331',0)
     #         NEXT FIELD pnb20a
     #      END IF
     #      #-----END MOD-A50031-----
     #                #FUN-C30081 add START   
            IF NOT cl_null(g_pmn41) AND l_newline = 'N' THEN   #原採購單上單身有存在工單號碼
               LET l_n = 0 
               LET l_qty2 = 0
               LET l_qty3 = 0 
               LET l_sfb08 = 0 
               SELECT ima55 INTO l_ima55 FROM ima_file
                 WHERE ima01 = g_pnb[l_ac].pnb04b
               LET l_sql = " SELECT SUM(pmn20),pmn07 ",
                           " FROM pmn_file ",
                           " WHERE pmn41 = '",g_pmn41,"' ",
                           "  AND pmn04 = '",g_pnb[l_ac].pnb04b,"' ",
                           "  AND pmn01 NOT IN ('",g_pna.pna01,"') ",
                           "  GROUP BY pmn07 "
               PREPARE t910_qty2 FROM l_sql
               DECLARE pnb_qty2 CURSOR FOR t910_qty2
               FOREACH pnb_qty2 INTO l_qty2,l_pmn07
                  IF NOT cl_null(l_pmn07) THEN
                     IF l_pmn07 = l_ima55 THEN
                        LET l_qty3 = l_qty3 + l_qty2
                     ELSE
                        CALL s_umfchk(g_pnb[l_ac].pnb04b,l_pmn07,l_ima55)
                           RETURNING l_sw,l_pmn09      #單位轉換
                        IF l_sw THEN
                           LET l_pmn09 = 1
                        END IF
                        LET l_qty2 = l_qty2 * l_pmn09
                        LET l_qty3 = l_qty3 + l_qty2
                     END IF
                  END IF
               END FOREACH
               LET l_qty3 = l_qty3 + g_pnb[l_ac].pnb20a
               SELECT COUNT(*) INTO l_n FROM sfb_file
                 WHERE sfb01 = g_pmn41
                   AND sfb05 = g_pnb[l_ac].pnb04b
               IF l_n > 0 THEN 
                  SELECT sfb08 INTO l_sfb08 
                    FROM sfb_file 
                    WHERE sfb01 = g_pmn41
                      AND sfb05 = g_pnb[l_ac].pnb04b
                  IF l_sfb08 < l_qty3 THEN
                     CALL cl_err('','apm-302',0)
                     NEXT FIELD pnb20a
                  END IF 
               END IF
            END IF
           #FUN-C30081 add END  
     #      LET g_cnt=0
     #      SELECT COUNT(*) INTO g_cnt
     #          FROM pmn_file
     #          WHERE pmn01=g_pna.pna01 AND pmn02=g_pnb[l_ac].pnb03
     #      IF g_cnt > 0 THEN
     #      IF NOT cl_null(g_pnb[l_ac].pnb20a)  THEN
     #         #委外代買時，如果是選擇(1對1),採購變更時代買的數量要卡不能修改
     #         IF g_pnb[l_ac].pnb20a != g_pnb[l_ac].pnb20b THEN
     #            SELECT pmn65 INTO l_pmn65 FROM pmn_file
     #             WHERE pmn01 = g_pna.pna01
     #               AND pmn02 = g_pnb[l_ac].pnb03
     #               AND pmn04 = g_pnb[l_ac].pnb04b
     #            IF l_pmn65 = '2' THEN    #表示是代買料,不可以修改數量
     #               CALL cl_err(g_pnb[l_ac].pnb04b,'apm-851',0)
     #               LET g_pnb[l_ac].pnb20a = g_pnb[l_ac].pnb20b
     #               DISPLAY BY NAME g_pnb[l_ac].pnb20a
     #            END IF
     #         END IF

     #         #CHI-B50016 add --start--
     #         IF NOT t910_chk_blanketpo() THEN
     #            NEXT FIELD pnb20a
     #         END IF
     #         #CHI-B50016 add --end--

     #         SELECT pmn20 INTO l_pmn50_55 FROM pmn_file
     #          WHERE pmn01 = g_pna.pna01
     #            AND pmn02 = g_pnb[l_ac].pnb03
 
     #            LET l_pml20 = 0
     #            LET l_pml21 = 0
     #            SELECT pml20,pml21 INTO l_pml20,l_pml21 FROM pml_file
     #             WHERE pml01 = g_pnb[l_ac].pnb90b
     #               AND pml02 = g_pnb[l_ac].pnb91b
 
     #            LET l_pml09 = 0
     #            SELECT pml09 INTO l_pml09 FROM pml_file
     #                         WHERE pml01=g_pnb[l_ac].pnb90b
     #                           AND pml02=g_pnb[l_ac].pnb91b
     #            IF l_pml09 IS NULL OR l_pml09 = 0 THEN LET l_pml09 = 1 END IF
 
     #            LET l_ima07=' ' LET l_rate=0
     #            SELECT ima07 INTO l_ima07 FROM ima_file
     #             WHERE ima01=g_pnb[l_ac].pnb04b
     #            CASE l_ima07
     #                 WHEN 'A' LET l_rate=g_sma.sma341/100
     #                 WHEN 'B' LET l_rate=g_sma.sma342/100
     #                 WHEN 'C' LET l_rate=g_sma.sma343/100
     #                 OTHERWISE LET l_rate=0
     #            END CASE
     #            IF g_sma.sma32='Y' AND g_pmm02 != 'SUB' THEN   #No.FUN-590021  #No.MOD-860153 modify
     #               IF NOT chk_qty() THEN
     #                   CALL cl_err('','mfg3425',1)  #MOD-490284
     #                  IF g_sma.sma33='R'THEN #reject BugNo:4163
     #                      NEXT FIELD pnb20a
     #                  END IF
     #               END IF
     #            END IF
     #            #==>不可小於已收貨量(rvb07)(不管是否已確認)
     #            SELECT SUM(rvb07-rvb29) INTO l_rvb07 FROM rvb_file,rva_file   #No.MOD-660038 modify
     #             WHERE rvb01 = rva01
     #               AND rvaconf != 'X'
     #               AND rvb04 = g_pna.pna01
     #               AND rvb03 = g_pnb[l_ac].pnb03
     #               AND rvb35 = 'N'   #MOD-A70130
     #            IF g_pnb[l_ac].pnb20a < l_rvb07 THEN
     #                CALL cl_err(l_rvb07,'apm-411',0)
     #                NEXT FIELD pnb20a
     #            END IF
     #          LET g_change='Y'          #No.FUN-630026 add
     #        END IF
     #      END IF
     #       IF cl_null(g_pnb[l_ac].pnb04b) AND g_sma.sma32='Y' THEN #No:7629      
     #          LET l_old = 0
     #          LET l_new = 0
     #          SELECT pml20 INTO l_old FROM pml_file
     #           WHERE pml01 = g_pnb[l_ac].pnb90
     #             AND pml02 = g_pnb[l_ac].pnb91
     #          IF cl_null(l_old) THEN LET l_old = 0 END IF
 
     #          SELECT SUM(pmn20*pmn121) INTO l_new FROM pmn_file   
     #           WHERE pmn24 = g_pnb[l_ac].pnb90
     #             AND pmn25 = g_pnb[l_ac].pnb91
     #             AND pmn16 NOT IN ('6','7','8','9')      #CHI-720006 add
     #          IF cl_null(l_new) THEN LET l_new = 0 END IF
 
     #          LET l_pml09 = 0
     #          SELECT pml09 INTO l_pml09 FROM pml_file
     #                       WHERE pml01=g_pnb[l_ac].pnb90
     #                         AND pml02=g_pnb[l_ac].pnb91
     #          IF l_pml09 IS NULL OR l_pml09 = 0 THEN LET l_pml09 = 1 END IF
     #          LET l_new = l_new / l_pml09
 
     #          LET l_ima07=' ' LET l_rate=0
     #          SELECT ima07 INTO l_ima07 FROM ima_file
     #           WHERE ima01=g_pnb[l_ac].pnb04a
     #          CASE l_ima07
     #               WHEN 'A' LET l_rate=g_sma.sma341/100
     #               WHEN 'B' LET l_rate=g_sma.sma342/100
     #               WHEN 'C' LET l_rate=g_sma.sma343/100
     #               OTHERWISE LET l_rate=0
     #          END CASE
 
     #          IF NOT chk_qty() THEN
     #            CALL cl_err('','apm-403',1)
     #            IF g_sma.sma33='R' THEN    #CHI-870031
     #              NEXT FIELD pnb20a
     #            END IF
     #          END IF
     #       END IF
     #        IF g_change = 'Y' THEN
     #           CALL t910_set_pnb87a()
     #           SELECT pmm09,pmm04,pmm21,pmm43 
     #            INTO l_pmm09,l_pmm04,l_pmm21,l_pmm43 FROM pmm_file
     #           WHERE pmm01 = g_pna.pna01
     #           IF cl_null(g_pna.pna08b) THEN
     #              LET l_pna08 = g_pna.pna08
     #           END IF  
     #           IF cl_null(g_pnb[l_ac].pnb04a) THEN 
     #              LET g_pnb[l_ac].pnb04a = g_pnb[l_ac].pnb04b
     #           END IF  
     #           IF cl_null(g_pnb[l_ac].pnb87a)  THEN
     #              LET g_pnb[l_ac].pnb87a = g_pnb[l_ac].pnb87b
     #           END IF 
     #           IF cl_null(g_pna.pna09b) THEN
     #              LET g_term = g_pna.pna09
     #           ELSE
     #           	  LET g_term = g_pna.pna09b
     #           END IF
     #           IF cl_null(g_pna.pna10b) THEN
     #              LET g_price = g_pna.pna10
     #           ELSE
     #           	  LET g_price = g_pna.pna10b
     #           END IF 
     #          #MOD-AC0377-------mod---------------str----------  	 
     #          #IF cl_null(g_pnb[l_ac].pnb87a)  THEN
     #          #   LET g_pnb86 = g_pnb[l_ac].pnb87b
     #          #ELSE
     #          #   LET g_pnb86 = g_pnb[l_ac].pnb87a   
     #          #END IF 
     #           IF cl_null(g_pnb[l_ac].pnb86a) THEN 
     #               LET g_pnb86 = g_pnb[l_ac].pnb86b
     #           ELSE
     #               LET g_pnb86 = g_pnb[l_ac].pnb86a
     #           END IF          
     #          #MOD-AC0377-------mod---------------end-----------
     #          #MOD-B90099------add--------begin---------
     #           LET l_i = 0
     #           SELECT COUNT(*) INTO l_i FROM pmn_file
     #            WHERE pmn01 = g_pna.pna01
     #              AND pmn02 = g_pnb[l_ac].pnb03
     #          #MOD-B90099------add--------end-----------
     #           IF l_i <=0 THEN  #MOD-B90099
     #              CALL s_defprice_new(g_pnb[l_ac].pnb04a,l_pmm09,l_pna08,l_pmm04,
     #                              g_pnb[l_ac].pnb87b,l_task,l_pmm43,l_pmm21,l_type,g_pnb86,'',g_term,g_price,g_plant)
     #               RETURNING g_pnb[l_ac].pnb31a,g_pnb[l_ac].pnb32a,                            #No.FUN-930148
     #                      g_pmn73,g_pmn74   #TQC-AC0257 add
     #           END IF  #MOD-B90099
     #           IF cl_null(g_pmn73) THEN LET g_pmn73 = '4' END IF  #TQC-AC0257 add
     #        END IF
     #        IF g_sma.sma54='Y' THEN #是否使用製程
     #           CALL t910_upd_ecm('b')
     #           IF NOT cl_null(g_error) THEN
     #              NEXT FIELD pnb20a
     #           END IF 
     #        END IF
     #FUN-910088--mark--end--
 
        AFTER FIELD pnb041a
             IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
                IF g_sma.sma115 = 'Y' THEN
                   CALL s_chk_va_setting(g_pnb[l_ac].pnb04a)
                        RETURNING g_flag,g_ima906,g_ima907
                   IF g_flag=1 THEN
                      NEXT FIELD pnb04a
                   END IF
                   CALL s_chk_va_setting1(g_pnb[l_ac].pnb04a)
                        RETURNING g_flag,g_ima908
                   IF g_flag=1 THEN
                      NEXT FIELD pnb04a
                   END IF
                      CALL t910_du_default(p_cmd)
                   IF NOT cl_null(g_pnb[l_ac].pnb04b)  THEN
                      LET g_pnb[l_ac].pnb82a=NULL
                      LET g_pnb[l_ac].pnb85a=NULL
                      LET g_pnb[l_ac].pnb87a=NULL
                   END IF 
                   LET g_pnb04 = g_pnb[l_ac].pnb04a
                END IF
             ELSE
                SELECT ima44,ima906,ima907,ima908
                  INTO g_ima44,g_ima906,g_ima907,g_ima908 FROM ima_file
                 WHERE ima01=g_pnb[l_ac].pnb04b
                LET g_pnb04 = g_pnb[l_ac].pnb04b
             END IF
             CALL t910_set_entry_b()
             CALL t910_set_no_entry_b()
 
        BEFORE FIELD pnb83a
           LET g_pnb04 = g_pnb[l_ac].pnb04b
           IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
              LET g_pnb04 = g_pnb[l_ac].pnb04a
           END IF
           IF NOT cl_null(g_pnb04) THEN
              SELECT ima44,ima31,ima906,ima907,ima908
                INTO g_ima44,g_ima31,g_ima906,g_ima907,g_ima908
                FROM ima_file WHERE ima01=g_pnb04
           END IF
           CALL t910_set_entry_b()
           CALL t910_set_no_entry_b()
 
        AFTER FIELD pnb83a  #第二單位
           IF cl_null(g_pnb[l_ac].pnb83b) AND NOT cl_null(g_pnb[l_ac].pnb83a) OR
               g_pnb[l_ac].pnb83b<>g_pnb[l_ac].pnb83a THEN
               LET g_change = 'Y'
           END IF
           IF NOT cl_null(g_pnb[l_ac].pnb83a) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pnb[l_ac].pnb83a
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err('gfe:',STATUS,0)
                 NEXT FIELD pnb83a
              END IF
              CALL s_du_umfchk(g_pnb04,'','','',
                               g_ima44,g_pnb[l_ac].pnb83a,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pnb[l_ac].pnb83a,g_errno,0)
                 NEXT FIELD pnb83a
              END IF
              IF cl_null(g_pnb_t.pnb83a) OR g_pnb_t.pnb83a <> g_pnb[l_ac].pnb83a THEN
                 LET g_pnb[l_ac].pnb84a = g_factor
              END IF
           END IF
           CALL t910_set_no_entry_b()
           CALL cl_show_fld_cont()
         #FUN-910088--add--start--
           #IF g_sma.sma115 ='N' THEN                                                     #TQC-C20183
           #   LET g_pnb[l_ac].pnb85a = s_digqty(g_pnb[l_ac].pnb85a,g_pnb[l_ac].pnb83a)   #TQC-C20183
           #   DISPLAY BY NAME g_pnb[l_ac].pnb85a                                         #TQC-C20183
           #ELSE                                                                          #TQC-C20183
           IF NOT cl_null(g_pnb[l_ac].pnb85a) AND g_pnb[l_ac].pnb85a <> 0 THEN
              IF NOT t910_pnb85a_check(p_cmd) THEN NEXT FIELD pnb85a END IF
           END IF
           #END IF
        #FUN-910088--add--end--
 
        AFTER FIELD pnb84a  #第二轉換率
           IF cl_null(g_pnb[l_ac].pnb84b) AND NOT cl_null(g_pnb[l_ac].pnb84a) OR
               g_pnb[l_ac].pnb84b<>g_pnb[l_ac].pnb84a THEN
               LET g_change = 'Y'
           END IF
           IF NOT cl_null(g_pnb[l_ac].pnb84a) THEN
              IF g_pnb[l_ac].pnb84a=0 THEN
                 NEXT FIELD pnb84a
              END IF
           END IF
 
        AFTER FIELD pnb85a  #第二數量
           IF NOT t910_pnb85a_check(p_cmd) THEN NEXT FIELD pnb85a END IF    #FUN-910088--add--
   #FUN-910088--mark--start--
   #       IF cl_null(g_pnb[l_ac].pnb85b) AND NOT cl_null(g_pnb[l_ac].pnb85a) OR
   #           g_pnb[l_ac].pnb85b<>g_pnb[l_ac].pnb85a THEN
   #           LET g_change = 'Y'
   #       END IF
   #       IF NOT cl_null(g_pnb[l_ac].pnb85a) THEN
   #          IF g_pnb[l_ac].pnb85a < 0 THEN
   #             CALL cl_err('','aim-391',0)  #
   #             NEXT FIELD pnb85a
   #          END IF
   #          IF p_cmd = 'a' OR  p_cmd = 'u' AND
   #             g_pnb_t.pnb85a <> g_pnb[l_ac].pnb85a THEN
   #             IF g_ima906='3' THEN
   #                LET g_pnb84 = g_pnb[l_ac].pnb84b
   #                LET g_pnb85 = g_pnb[l_ac].pnb85b
   #                LET g_pnb81 = g_pnb[l_ac].pnb81b
   #                IF NOT cl_null(g_pnb[l_ac].pnb84a) THEN
   #                   LET g_pnb84 = g_pnb[l_ac].pnb84a
   #                END IF
   #                IF NOT cl_null(g_pnb[l_ac].pnb85a) THEN
   #                   LET g_pnb85 = g_pnb[l_ac].pnb85a
   #                END IF
   #                IF NOT cl_null(g_pnb[l_ac].pnb81a) THEN
   #                   LET g_pnb81 = g_pnb[l_ac].pnb81a
   #                END IF
   #                LET g_tot=g_pnb85*g_pnb84
   #                IF cl_null(g_pnb[l_ac].pnb82a) OR g_pnb[l_ac].pnb82a=0 THEN #CHI-960022
   #                   LET g_pnb[l_ac].pnb82a=g_tot*g_pnb81
   #                   DISPLAY BY NAME g_pnb[l_ac].pnb82a                       #CHI-960022
   #                END IF                                                      #CHI-960022
   #             END IF
   #          END IF
   #       END IF
   #       IF g_change = 'Y' THEN
   #          CALL t910_set_pnb87a()
   #       END IF
   #       CALL cl_show_fld_cont()
   #FUN-910088--mark--end--
 
        BEFORE FIELD pnb80a
           LET g_pnb04 = g_pnb[l_ac].pnb04b
           IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
              LET g_pnb04 = g_pnb[l_ac].pnb04a
           END IF
           IF NOT cl_null(g_pnb04) THEN
              SELECT ima44,ima31,ima906,ima907,ima908
                INTO g_ima44,g_ima31,g_ima906,g_ima907,g_ima908
                FROM ima_file WHERE ima01=g_pnb04
           END IF
           CALL t910_set_entry_b()
           CALL t910_set_no_entry_b()
 
        AFTER FIELD pnb80a  #第一單位
           IF cl_null(g_pnb[l_ac].pnb80b) AND NOT cl_null(g_pnb[l_ac].pnb80a) OR
               g_pnb[l_ac].pnb80b<>g_pnb[l_ac].pnb80a THEN
               LET g_change = 'Y'
           END IF
           IF NOT cl_null(g_pnb[l_ac].pnb80a) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pnb[l_ac].pnb80a
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err('gfe:',STATUS,0)
                 NEXT FIELD pnb80a
              END IF
              CALL s_du_umfchk(g_pnb04,'','','',
                               g_ima44,g_pnb[l_ac].pnb80a,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pnb[l_ac].pnb80a,g_errno,0)
                 NEXT FIELD pnb80a #FUN-650166
              END IF
              IF cl_null(g_pnb_t.pnb80a) OR g_pnb_t.pnb80a <> g_pnb[l_ac].pnb80a THEN
                 LET g_pnb[l_ac].pnb81a = g_factor
              END IF
           END IF
           CALL t910_set_no_entry_b()
           CALL cl_show_fld_cont()
         #FUN-910088--add--start--
           #IF g_sma.sma115 ='N' THEN                                                   #TQC-C20813
           #   LET g_pnb[l_ac].pnb82a = s_digqty(g_pnb[l_ac].pnb82a,g_pnb[l_ac].pnb80a) #TQC-C20813
           #   DISPLAY BY NAME g_pnb[l_ac].pnb82a                                       #TQC-C20813
           #ELSE                                                                        #TQC-C20813
           IF NOT cl_null(g_pnb[l_ac].pnb82a) AND g_pnb[l_ac].pnb82a <> 0 THEN
              CASE t910_pnb82a_check()
                 WHEN "pnb82a"
                    NEXT FIELD pnb82a
                 WHEN "pnb85a"
                    NEXT FIELD pnb85a
                 WHEN "pnb33a"
                    NEXT FIELD pnb33a
                 WHEN "pnb80a"
                    NEXT FIELD pnb80a
                 WHEN "pnb83a"
                    NEXT FIELD pnb82a
                 OTHERWISE EXIT CASE
              END CASE
           END IF 
           #END IF
         #FUN-910088--add--end--
 
        AFTER FIELD pnb81a  #第一轉換率
           IF cl_null(g_pnb[l_ac].pnb81b) AND NOT cl_null(g_pnb[l_ac].pnb81a) OR
               g_pnb[l_ac].pnb81b<>g_pnb[l_ac].pnb81a THEN
               LET g_change = 'Y'
           END IF
           IF NOT cl_null(g_pnb[l_ac].pnb81a) THEN
              IF g_pnb[l_ac].pnb81a=0 THEN
                 NEXT FIELD pnb81a
              END IF
           END IF
 
        AFTER FIELD pnb82a  #第一數量
      #FUN-910088--add--start--
           CASE t910_pnb82a_check()
              WHEN "pnb82a"
                 NEXT FIELD pnb82a
              WHEN "pnb85a"
                 NEXT FIELD pnb85a
              WHEN "pnb33a"
                 NEXT FIELD pnb33a
              WHEN "pnb80a"
                 NEXT FIELD pnb80a
              WHEN "pnb83a"
                 NEXT FIELD pnb82a
              OTHERWISE EXIT CASE
           END CASE
      #FUN-910088--add--end--
      #FUN-910088--mark--start--
      #    IF cl_null(g_pnb[l_ac].pnb82b) AND NOT cl_null(g_pnb[l_ac].pnb82a) OR
      #        g_pnb[l_ac].pnb82b<>g_pnb[l_ac].pnb82a THEN
      #        LET g_change = 'Y'
      #    END IF
      #    IF NOT cl_null(g_pnb[l_ac].pnb82a) THEN
      #       IF g_pnb[l_ac].pnb82a < 0 THEN
      #          CALL cl_err('','aim-391',0)  #
      #          NEXT FIELD pnb82a
      #       END IF
      #    END IF
      #    #計算pnb20,pnb07的值,檢查數量的合理性
      #     CALL t910_set_origin_field()
      #     CALL t910_check_inventory_qty(p_cmd,l_newline)
      #         RETURNING g_flag
      #     IF g_flag = '1' THEN
      #        IF g_ima906 = '3' OR g_ima906 = '2' THEN
      #           NEXT FIELD pnb85a
      #        ELSE
      #           NEXT FIELD pnb82a
      #        END IF
      #     END IF
      #     IF g_flag = '2' THEN
      #        IF g_ima906 = '3' OR g_ima906 = '2' THEN
      #           NEXT FIELD pnb83a
      #        ELSE
      #           NEXT FIELD pnb80a
      #        END IF
      #     END IF
      #     IF g_flag = '3' THEN
      #        NEXT FIELD pnb33a 
      #     END IF

      #     #CHI-B50016 add --start--
      #     IF NOT t910_chk_blanketpo() THEN
      #        IF g_ima906 = '3' OR g_ima906 = '2' THEN
      #           NEXT FIELD pnb85a
      #        ELSE
      #           NEXT FIELD pnb82a
      #        END IF
      #     END IF
      #     #CHI-B50016 add --end--

      #     IF g_change = 'Y' THEN
      #        CALL t910_set_pnb87a()
      #     END IF
      #     IF g_sma.sma54='Y' THEN #是否使用製程
      #        CALL t910_upd_ecm('b')
      #        IF NOT cl_null(g_error) THEN
      #           IF g_ima906 = '3' OR g_ima906 = '2' THEN
      #              NEXT FIELD pnb85a
      #           ELSE
      #              NEXT FIELD pnb82a
      #           END IF
      #        END IF 
      #     END IF
      #     CALL cl_show_fld_cont()
      #FUN-910088--mark--end--
 
        BEFORE FIELD pnb86a
           LET g_pnb04 = g_pnb[l_ac].pnb04b
           IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
              LET g_pnb04 = g_pnb[l_ac].pnb04a
           END IF
           IF NOT cl_null(g_pnb04) THEN
              SELECT ima44,ima31,ima906,ima907,ima908
                INTO g_ima44,g_ima31,g_ima906,g_ima907,g_ima908
                FROM ima_file WHERE ima01=g_pnb04
           END IF
 
        AFTER FIELD pnb86a
           IF cl_null(g_pnb[l_ac].pnb86b) AND NOT cl_null(g_pnb[l_ac].pnb86a) OR
               g_pnb[l_ac].pnb86b<>g_pnb[l_ac].pnb86a THEN
               LET g_change = 'Y'
           END IF
           IF NOT cl_null(g_pnb[l_ac].pnb86a) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pnb[l_ac].pnb86a
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err('gfe:',STATUS,0)
                 NEXT FIELD pnb86a #FUN-650166
              END IF
              CALL s_du_umfchk(g_pnb04,'','','',
                               g_ima44,g_pnb[l_ac].pnb86a,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pnb[l_ac].pnb86a,g_errno,0)
                 NEXT FIELD pnb86a
              END IF
           END IF
           IF g_change = 'Y' THEN
              CALL t910_set_pnb87a()
           END IF
       #FUN-910088--add--start--
           #IF g_sma.sma116 MATCHES '[02]' THEN                                         #TQC-C20183
           #   LET g_pnb[l_ac].pnb87a = s_digqty(g_pnb[l_ac].pnb87a,g_pnb[l_ac].pnb86a) #TQC-C20183
           #   DISPLAY BY NAME g_pnb[l_ac].pnb87a                                       #TQC-C20183
           #ELSE                                                                        #TQC-C20183
           IF NOT cl_null(g_pnb[l_ac].pnb87a) AND g_pnb[l_ac].pnb87a <> 0 THEN
              IF NOT t910_pnb87a_check() THEN NEXT FIELD pnb87a END IF
           END IF
           #END IF
       #FUN-910088--add--end--
 
        BEFORE FIELD pnb87a
            IF g_change = 'Y' THEN
               CALL t910_set_pnb87a()
            END IF
 
        AFTER FIELD pnb87a
           IF NOT t910_pnb87a_check() THEN NEXT FIELD pnb87a END IF    #FUN-910088--add--
        #FUN-910088--mark--start--
        #  IF NOT cl_null(g_pnb[l_ac].pnb87a) THEN
        #      #委外代買時，如果是選擇(1對1),採購變更時代買的數量要卡不能修改
        #      IF g_pnb[l_ac].pnb87a != g_pnb[l_ac].pnb87b THEN
        #         SELECT pmn65 INTO l_pmn65 FROM pmn_file
        #          WHERE pmn01 = g_pna.pna01
        #            AND pmn02 = g_pnb[l_ac].pnb03
        #            AND pmn04 = g_pnb[l_ac].pnb04b
        #          LET l_rvb87 = 0
        #          SELECT SUM(rvb87) INTO l_rvb87 FROM rvb_file,rva_file 
        #             WHERE rvb01 = rva01
        #               AND rvaconf != 'X'
        #               AND rvb04 = g_pna.pna01
        #               AND rvb03 = g_pnb[l_ac].pnb03
 
        #          IF cl_null(l_rvb87) THEN LET l_rvb87 = 0 END IF
 
        #          IF g_pnb[l_ac].pnb87a < l_rvb87 THEN
        #             CALL cl_err('','apm-097',0)  #MOD-B10091 mod aim-411->apm-097
        #             NEXT FIELD pnb87a
        #          END IF
        #         IF l_pmn65 = '2' THEN    #表示是代買料,不可以修改數量
        #            CALL cl_err(g_pnb[l_ac].pnb04b,'apm-851',0)
        #            LET g_pnb[l_ac].pnb87a = g_pnb[l_ac].pnb87b
        #            DISPLAY BY NAME g_pnb[l_ac].pnb87a
        #         END IF
        #      END IF
        #  END IF
        #  IF cl_null(g_pnb[l_ac].pnb87b) AND NOT cl_null(g_pnb[l_ac].pnb87a) OR
        #      g_pnb[l_ac].pnb87b<>g_pnb[l_ac].pnb87a THEN
        #      LET g_change = 'Y'
        #  END IF
        #  IF NOT cl_null(g_pnb[l_ac].pnb87a) THEN
        #     IF g_pnb[l_ac].pnb87a < 0 THEN
        #        CALL cl_err('','aim-391',0)  #
        #        NEXT FIELD pnb87a
        #     END IF
        #  END IF
        #FUN-910088--mark--end--

 
        BEFORE FIELD pnb31a,pnb32a
           LET l_pna08 = ''
           LET l_pnb20 = ''
           LET l_pnb07 = ''
           LET l_pnb86 = ''   #MOD-B30413 add
           LET l_pmm09 = '' 
           LET l_pmm21 = ''
           LET l_pmm43 = ''
           IF cl_null(g_pna.pna08b) THEN
              LET l_pna08 = g_pna.pna08 
           ELSE
              LET l_pna08 = g_pna.pna08b
           END IF
           IF cl_null(g_pnb[l_ac].pnb20a) THEN
              LET l_pnb20 = g_pnb[l_ac].pnb20b
           ELSE
              LET l_pnb20 = g_pnb[l_ac].pnb20a
           END IF
           IF cl_null(g_pnb[l_ac].pnb07a) THEN
              LET l_pnb07 = g_pnb[l_ac].pnb07b
           ELSE
              LET l_pnb07 = g_pnb[l_ac].pnb07a
           END IF
           #MOD-B30413 add --start--
           IF cl_null(g_pnb[l_ac].pnb86a) THEN
              LET l_pnb86 = g_pnb[l_ac].pnb86b
           ELSE
              LET l_pnb86 = g_pnb[l_ac].pnb86a
           END IF
           #MOD-B30413 add --end--
           SELECT pmm09,pmm04,pmm21,pmm43 
              INTO l_pmm09,l_pmm04,l_pmm21,l_pmm43 FROM pmm_file
             WHERE pmm01 = g_pna.pna01
           IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN 
              IF cl_null(g_pnb[l_ac].pnb31a) OR g_pnb[l_ac].pnb31a = 0 THEN 
                 CALL t910_gettask(g_pna.pna01,g_pnb[l_ac].pnb03) 
                      RETURNING l_task,l_type
                 IF cl_null(g_pna.pna09b) THEN
                    LET g_term = g_pna.pna09
                 ELSE
                 	  LET g_term = g_pna.pna09b
                 END IF
                 IF cl_null(g_pna.pna10b) THEN
                    LET g_price = g_pna.pna10
                 ELSE
                 	  LET g_price = g_pna.pna10b
                 END IF  	     
                #MOD-B90099------add--------begin---------
                 LET l_i = 0
                 SELECT COUNT(*) INTO l_i FROM pmn_file
                  WHERE pmn01 = g_pna.pna01
                    AND pmn02 = g_pnb[l_ac].pnb03
                #MOD-B90099------add--------end-----------
                 IF l_i <=0 THEN  #MOD-B90099
                    #CALL s_defprice_new(g_pnb[l_ac].pnb04a,l_pmm09,l_pna08,l_pmm04,    #MOD-C30904 mark
                    CALL s_defprice_new(g_pnb[l_ac].pnb04a,l_pmm09,l_pna08,g_pna.pna04, #MOD-C30904 add
                                  #l_pnb20,l_task,l_pmm43,l_pmm21,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-B30413 mod l_pnb07->l_pnb86 #MOD-BA0204 mark
                                   l_pnb20,l_task,l_pmm21,l_pmm43,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-BA0204 add 
                    RETURNING g_pnb[l_ac].pnb31a,g_pnb[l_ac].pnb32a,
                                 g_pmn73,g_pmn74   #TQC-AC0257 add 
                 END IF #MOD-B90099
              END IF
           END IF
 
        AFTER FIELD pnb31a
            IF l_newline='Y' AND cl_null(g_pnb[l_ac].pnb31a) THEN
                #新增項次,所以此欄位不可空白
                CALL cl_err('','apm-915',0)
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL t910_set_origin_field()
            END IF
            LET g_pnb[l_ac].pnb31a = cl_digcut(g_pnb[l_ac].pnb31a,t_azi03)  #No.FUN-550089  #No.CHI-6A0004
	    LET l_qty=g_pnb[l_ac].pnb87b #MOD-6C0095
            LET l_up=g_pnb[l_ac].pnb31b
            LET lt_up=g_pnb[l_ac].pnb32b #TQC-760049 add 
            # 參數設定單價不可為零
            #FUN-C40089---begin
            IF cl_null(g_pna.pna09b) THEN
               LET g_term = g_pna.pna09
            ELSE
               LET g_term = g_pna.pna09b
            END IF
            SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = g_term
            IF cl_null(g_pnz08) THEN 
               LET g_pnz08 = 'Y'
            END IF 
            IF g_pnz08 = 'N' THEN 
            #IF g_sma.sma112= 'N' THEN 
            #FUN-C40089---end
               IF NOT cl_null(g_pnb[l_ac].pnb31a) AND g_pnb[l_ac].pnb31a <=0 THEN  #No:7629
                 #CALL cl_err('','axm-627',1) NEXT FIELD pnb31a   #FUN-C50076 #MOD-D30073 mark
                 #MOD-D30073 add start -----
                  CALL cl_err('','axm-627',1)
                  SELECT pnz04 INTO g_pnz04 FROM pnz_file WHERE pnz01 = g_term
                  IF cl_null(g_pnz04) THEN 
                     LET g_pnz04 = 'Y'
                  END IF 
                  IF g_pnz04 = 'Y' THEN
                     NEXT FIELD pnb31a 
                  ELSE
                     NEXT FIELD pnb03
                  END IF
                 #MOD-D30073 add end    -----
               END IF
            END IF
            IF NOT cl_null(g_pnb[l_ac].pnb87a) THEN
               LET l_qty=g_pnb[l_ac].pnb87a
            END IF
            IF NOT cl_null(g_pnb[l_ac].pnb31a) THEN
	       LET l_up=g_pnb[l_ac].pnb31a
            END IF
            IF cl_null(g_pnb[l_ac].pnb87a) AND cl_null(g_pnb[l_ac].pnb31a) THEN	#MOD-6C0095
                LET g_pnb[l_ac].tota = NULL
            ELSE
                LET g_pnb[l_ac].tota=l_qty*l_up
            END IF
            DISPLAY BY NAME g_pnb[l_ac].tota
            LET g_pnb[l_ac].pnb32a = g_pnb[l_ac].pnb31a * ( 1 + g_pmm43 / 100)
            LET g_pnb[l_ac].pnb32a = cl_digcut(g_pnb[l_ac].pnb32a,t_azi03)  #No.CHI-6A0004
            IF NOT cl_null(g_pnb[l_ac].pnb32a) THEN
	       LET lt_up=g_pnb[l_ac].pnb32a
            END IF
            IF cl_null(g_pnb[l_ac].pnb87a) AND cl_null(g_pnb[l_ac].pnb32a) THEN	 #MOD-6C0095
                LET g_pnb[l_ac].totta = NULL
            ELSE
                LET g_pnb[l_ac].totta=l_qty*lt_up
            END IF
            LET g_pnb[l_ac].tota = cl_digcut(g_pnb[l_ac].tota,t_azi04)  #No.CHI-6A0004
            LET g_pnb[l_ac].totta= cl_digcut(g_pnb[l_ac].totta,t_azi04)  #No.CHI-6A0004
            DISPLAY BY NAME g_pnb[l_ac].pnb31a
            DISPLAY BY NAME g_pnb[l_ac].pnb32a
            DISPLAY BY NAME g_pnb[l_ac].tota
            DISPLAY BY NAME g_pnb[l_ac].totta
            #check採購單價超過最近採購單價%
            IF NOT cl_null(g_pnb[l_ac].pnb31a) THEN
               #--先抓取舊的幣別匯率
               SELECT pmm42,pmm04 INTO l_pmm42,l_pmm04 FROM pmm_file WHERE pmm01=g_pna.pna01
               #--有變更幣別時抓變更後的幣別匯率
               IF NOT cl_null(g_pna.pna08b) THEN
                  LET l_pmm22 = g_pna.pna08b
                  IF g_aza.aza17 = l_pmm22 THEN   #本幣
                     LET l_pmm42 = 1
                  ELSE
                     CALL s_curr3(l_pmm22,l_pmm04,g_sma.sma904) RETURNING l_pmm42 #FUN-640012
                  END IF
               END IF
               #--無變更料號時抓取變更前料號之ima53
               IF cl_null(g_pnb[l_ac].pnb04a) THEN
                  IF g_sma.sma84 != 99.99 AND g_pnb[l_ac].pnb04b[1,4] <>'MISC' THEN
                     SELECT pmn90 INTO l_pmn90
                       FROM pmn_file
                      WHERE pmn01=g_pna.pna01  AND pmn02 = g_pnb[l_ac].pnb03
                     IF SQLCA.sqlcode THEN
                        LET l_pmn90 = 0
                     END IF
                     IF l_pmn90 != 0 THEN
                        IF g_pnb[l_ac].pnb31a > l_pmn90*(1+g_sma.sma84/100) THEN
                           IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                              CALL cl_err(g_pnb[l_ac].pnb04a,'apm-240',1) #No:8752  
                              NEXT FIELD pnb31a   #MOD-8C0295 pmb31a-->pnb31a
                           ELSE
                              CALL cl_err('','apm-240',1)
                           END IF
                        END IF
                     ELSE 
                     CALL t910_gettask(g_pna.pna01,g_pnb[l_ac].pnb03) 
                          RETURNING l_task,l_type
                     IF cl_null(g_pna.pna09b) THEN
                       LET g_term = g_pna.pna09
                     ELSE
                 	      LET g_term = g_pna.pna09b
                     END IF
                     IF cl_null(g_pna.pna10b) THEN
                        LET g_price = g_pna.pna10
                     ELSE
                 	      LET g_price = g_pna.pna10b
                     END IF  	     
                      #CALL s_defprice_new(g_pnb[l_ac].pnb04b,l_pmm09,l_pna08,l_pmm04,    #MOD-C30904 mark
                      CALL s_defprice_new(g_pnb[l_ac].pnb04b,l_pmm09,l_pna08,g_pna.pna04, #MOD-C30904 add
                                     #l_pnb20,l_task,l_pmm43,l_pmm21,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-B30413 mod l_pnb07->l_pnb86 #MOD-BA0204 mark
                                      l_pnb20,l_task,l_pmm21,l_pmm43,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-BA0204 add
                         RETURNING l_price,lt_price,g_pmn73,g_pmn74   #TQC-AC0257 add g_pmn73,g_pmn74
                     IF l_price != 0 THEN
                        IF g_pnb[l_ac].pnb31a > l_price*(1+g_sma.sma84/100) THEN
                           IF g_sma.sma109 = 'R' THEN
                              CALL cl_err(g_pnb[l_ac].pnb04b,'apm-240',0)
                              NEXT FIELD pnb31a
                           ELSE
                              CALL cl_err('','apm-240',0)
                           END IF
                        END IF
                     END IF
                     END IF  #CHI-820014 add
                  END IF
               ELSE
               #--有變更料號時抓取變更後料號之ima53
                  IF g_sma.sma84 != 99.99 AND g_pnb[l_ac].pnb04a[1,4] <>'MISC' THEN
                     SELECT pmn90 INTO l_pmn90
                       FROM pmn_file
                      WHERE pmn01=g_pna.pna01  AND pmn02 = g_pnb[l_ac].pnb03
                     IF SQLCA.sqlcode THEN
                        LET l_pmn90 = 0
                     END IF
                     IF l_pmn90 != 0 THEN
                        IF g_pnb[l_ac].pnb31a > l_pmn90*(1+g_sma.sma84/100) THEN
                           IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                              CALL cl_err(g_pnb[l_ac].pnb04a,'apm-240',1) #No:8752  
                              NEXT FIELD pnb31a   #MOD-8C0295   pmb32a-->pnb31a
                           ELSE
                              CALL cl_err('','apm-240',1)
                           END IF
                        END IF
                     ELSE 
                       CALL t910_gettask(g_pna.pna01,g_pnb[l_ac].pnb03) 
                            RETURNING l_task,l_type
                       IF cl_null(g_pna.pna09b) THEN
                          LET g_term = g_pna.pna09
                       ELSE
                 	        LET g_term = g_pna.pna09b
                       END IF
                       IF cl_null(g_pna.pna10b) THEN
                          LET g_price = g_pna.pna10
                       ELSE
                 	        LET g_price = g_pna.pna10b
                       END IF  	     
                        #CALL s_defprice_new(g_pnb[l_ac].pnb04a,l_pmm09,l_pna08,l_pmm04,    #MOD-C30904 mark
                        CALL s_defprice_new(g_pnb[l_ac].pnb04a,l_pmm09,l_pna08,g_pna.pna04, #MOD-C30904 add
                                     #l_pnb20,l_task,l_pmm43,l_pmm21,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-B30413 mod l_pnb07->l_pnb86 #MOD-BA0204 mark
                                      l_pnb20,l_task,l_pmm21,l_pmm43,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-BA0204 add
                        RETURNING l_price,lt_price,g_pmn73,g_pmn74   #TQC-AC0257 add g_pmn73,g_pmn74
                       IF l_price != 0 THEN
                          IF g_pnb[l_ac].pnb31a > l_price*(1+g_sma.sma84/100) THEN
                             IF g_sma.sma109 = 'R' THEN
                                CALL cl_err(g_pnb[l_ac].pnb04a,'apm-240',0)
                                NEXT FIELD pnb31a
                             ELSE
                                CALL cl_err('','apm-240',0)
                             END IF
                          END IF
                       END IF
                     END IF  #CHI-820014 add
                    END IF
               END IF
            END IF
 
        AFTER FIELD pnb32a
             LET g_pnb[l_ac].pnb31a =                                                                                    
                 g_pnb[l_ac].pnb32a / ( 1 + g_pmm43 / 100)
             IF NOT cl_null(g_pnb[l_ac].pnb32a) THEN
                LET g_pnb[l_ac].pnb32a = cl_digcut(g_pnb[l_ac].pnb32a,t_azi03)  #No.CHI-6A0004
               LET l_qty=g_pnb[l_ac].pnb87b
               IF NOT cl_null(g_pnb[l_ac].pnb87a) THEN
                  LET l_qty=g_pnb[l_ac].pnb87a
               END IF
               LET g_pnb[l_ac].pnb31a = cl_digcut(g_pnb[l_ac].pnb31a,t_azi03)  #No.CHI-6A0004
               LET l_up=g_pnb[l_ac].pnb31a
               LET lt_up=g_pnb[l_ac].pnb32a
               LET g_pnb[l_ac].tota=l_qty*l_up
               LET g_pnb[l_ac].totta=l_qty*lt_up
               LET g_pnb[l_ac].tota = cl_digcut(g_pnb[l_ac].tota,t_azi04) #No.CHI-6A0004
               LET g_pnb[l_ac].totta= cl_digcut(g_pnb[l_ac].totta,t_azi04)  #No.CHI-6A0004
               #MOD-B10138 add --start--
               IF g_gec07 = 'N' THEN
                  LET g_pnb[l_ac].totta = g_pnb[l_ac].tota*(1+g_pmm43/100)
                  LET g_pnb[l_ac].totta = cl_digcut(g_pnb[l_ac].totta,t_azi04)
               ELSE
                  #MOD-CC0122 add start -----
                  IF g_gec05 = 'T' THEN
                     LET g_pnb[l_ac].pnb31a  = g_pnb[l_ac].pnb32a * ( 1 - g_pmm43/100)
                     CALL cl_digcut(g_pnb[l_ac].pnb31a,t_azi03) RETURNING g_pnb[l_ac].pnb31a
                     LET g_pnb[l_ac].tota  = g_pnb[l_ac].totta * ( 1 - g_pmm43/100)
                     CALL cl_digcut(g_pnb[l_ac].tota,t_azi04) RETURNING g_pnb[l_ac].tota
                  ELSE          
                  #MOD-CC0122 add end   -----
                     LET g_pnb[l_ac].tota  = g_pnb[l_ac].totta/(1+g_pmm43/100)
                     LET g_pnb[l_ac].tota  = cl_digcut(g_pnb[l_ac].tota,t_azi04) 
                  END IF #MOD-CC0122 add 
               END IF
               #MOD-B10138 add --end--
               DISPLAY BY NAME g_pnb[l_ac].pnb31a
               DISPLAY BY NAME g_pnb[l_ac].pnb32a
               DISPLAY BY NAME g_pnb[l_ac].tota
               DISPLAY BY NAME g_pnb[l_ac].totta
            ELSE 
               LET l_qty=g_pnb[l_ac].pnb87b
               IF NOT cl_null(g_pnb[l_ac].pnb87a) THEN
                  LET l_qty=g_pnb[l_ac].pnb87a
               END IF
               IF cl_null(g_pnb[l_ac].pnb31a) THEN
                  LET l_up = cl_digcut(g_pnb[l_ac].pnb31b,g_azi03)
               ELSE 
                  LET l_up = cl_digcut(g_pnb[l_ac].pnb31a,g_azi03)
               END IF
               LET lt_up=g_pnb[l_ac].pnb32b
               LET g_pnb[l_ac].tota=l_qty*l_up
               LET g_pnb[l_ac].totta=l_qty*lt_up
               LET g_pnb[l_ac].tota = cl_digcut(g_pnb[l_ac].tota,g_azi04)
               LET g_pnb[l_ac].totta= cl_digcut(g_pnb[l_ac].totta,g_azi04)
               #MOD-B10138 add --start--
               IF g_gec07 = 'N' THEN
                  LET g_pnb[l_ac].totta = g_pnb[l_ac].tota*(1+g_pmm43/100)
                  LET g_pnb[l_ac].totta = cl_digcut(g_pnb[l_ac].totta,t_azi04)
               ELSE
                  #MOD-CC0122 add start -----
                  IF g_gec05 = 'T' THEN
                     LET g_pnb[l_ac].pnb31a  = g_pnb[l_ac].pnb32a * ( 1 - g_pmm43/100)
                     CALL cl_digcut(g_pnb[l_ac].pnb31a,t_azi03) RETURNING g_pnb[l_ac].pnb31a
                     LET g_pnb[l_ac].tota  = g_pnb[l_ac].totta * ( 1 - g_pmm43/100)
                     CALL cl_digcut(g_pnb[l_ac].tota,t_azi04) RETURNING g_pnb[l_ac].tota
                  ELSE
                  #MOD-CC0122 add end   -----
                     LET g_pnb[l_ac].tota  = g_pnb[l_ac].totta/(1+g_pmm43/100)
                     LET g_pnb[l_ac].tota  = cl_digcut(g_pnb[l_ac].tota,t_azi04)
                  END IF #MOD-CC0122 add
               END IF
               #MOD-B10138 add --end--
               DISPLAY BY NAME g_pnb[l_ac].tota
               DISPLAY BY NAME g_pnb[l_ac].totta
            END IF
            #check採購單價超過最近採購單價%
            IF NOT cl_null(g_pnb[l_ac].pnb32a) THEN
               #--先抓取舊的幣別匯率
               SELECT pmm42,pmm04 INTO l_pmm42,l_pmm04 FROM pmm_file WHERE pmm01=g_pna.pna01
               #--有變更幣別時抓變更後的幣別匯率
               IF NOT cl_null(g_pna.pna08b) THEN
                  LET l_pmm22 = g_pna.pna08b
                  IF g_aza.aza17 = l_pmm22 THEN   #本幣
                     LET l_pmm42 = 1
                  ELSE
                     CALL s_curr3(l_pmm22,l_pmm04,g_sma.sma904) RETURNING l_pmm42 #FUN-640012
                  END IF
               END IF
               #--無變更料號時抓取變更前料號之ima53
               #移到BEFORE FIELD 段
               IF cl_null(g_pnb[l_ac].pnb04a) THEN
                  IF g_sma.sma84 != 99.99 AND g_pnb[l_ac].pnb04b[1,4] <>'MISC' THEN
                     SELECT pmn90 INTO l_pmn90
                       FROM pmn_file
                      WHERE pmn01=g_pna.pna01  AND pmn02 = g_pnb[l_ac].pnb03
                     IF SQLCA.sqlcode THEN
                        LET l_pmn90 = 0
                     END IF
                     IF l_pmn90 != 0 THEN
                        IF g_pnb[l_ac].pnb31a > l_pmn90*(1+g_sma.sma84/100) THEN
                           IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                              CALL cl_err(g_pnb[l_ac].pnb04a,'apm-240',1) #No:8752  
                              NEXT FIELD pnb32a   #MOD-8C0295 pmb32a-->pnb32a
                           ELSE
                              CALL cl_err('','apm-240',1)
                           END IF
                        END IF
                     ELSE 
                       CALL t910_gettask(g_pna.pna01,g_pnb[l_ac].pnb03) 
                            RETURNING l_task,l_type
                      IF cl_null(g_pna.pna09b) THEN
                         LET g_term = g_pna.pna09
                      ELSE
                 	       LET g_term = g_pna.pna09b
                      END IF
                      IF cl_null(g_pna.pna10b) THEN
                         LET g_price = g_pna.pna10
                      ELSE
                 	       LET g_price = g_pna.pna10b
                      END IF  	     
                       #CALL s_defprice_new(g_pnb[l_ac].pnb04b,l_pmm09,l_pna08,l_pmm04,    #MOD-C30904 mark
                       CALL s_defprice_new(g_pnb[l_ac].pnb04b,l_pmm09,l_pna08,g_pna.pna04, #MOD-C30904 add
                                     #l_pnb20,l_task,l_pmm43,l_pmm21,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-B30413 mod l_pnb07->l_pnb86 #MOD-BA0204 mark
                                      l_pnb20,l_task,l_pmm21,l_pmm43,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-BA0204 add 
                        RETURNING l_price,lt_price,g_pmn73,g_pmn74   #TQC-AC0257 add g_pmn73,g_pmn74
                       IF lt_price != 0 THEN
                          IF g_pnb[l_ac].pnb32a > lt_price*(1+g_sma.sma84/100) THEN
                             IF g_sma.sma109 = 'R' THEN
                                CALL cl_err(g_pnb[l_ac].pnb04b,'apm-240',0)
                               #MOD-D30073 add start -----
                                SELECT pnz04 INTO g_pnz04 FROM pnz_file WHERE pnz01 = g_term
                                IF cl_null(g_pnz04) THEN 
                                   LET g_pnz04 = 'Y'
                                END IF 
                                IF g_pnz04 = 'Y' THEN
                               #MOD-D30073 add end   -----
                                   NEXT FIELD pnb31a
                               #MOD-D30073 add start -----
                                ELSE
                                    NEXT FIELD pnb03
                                END IF
                               #MOD-D30073 add end    -----
                             ELSE
                                CALL cl_err('','apm-240',0)
                             END IF
                          END IF
                       END IF
                     END IF  
                  END IF
               ELSE
               #--有變更料號時抓取變更後料號之ima53
                  IF g_sma.sma84 != 99.99 AND g_pnb[l_ac].pnb04a[1,4] <>'MISC' THEN
                       CALL t910_gettask(g_pna.pna01,g_pnb[l_ac].pnb03) 
                            RETURNING l_task,l_type
                       IF cl_null(g_pna.pna09b) THEN
                          LET g_term = g_pna.pna09
                       ELSE
                 	        LET g_term = g_pna.pna09b
                       END IF
                       IF cl_null(g_pna.pna10b) THEN
                          LET g_price = g_pna.pna10
                       ELSE
                 	        LET g_price = g_pna.pna10b
                       END IF  	     
                       #CALL s_defprice_new(g_pnb[l_ac].pnb04a,l_pmm09,l_pna08,l_pmm04,    #MOD-C30904 mark
                       CALL s_defprice_new(g_pnb[l_ac].pnb04a,l_pmm09,l_pna08,g_pna.pna04, #MOD-C30904 add
                                     #l_pnb20,l_task,l_pmm43,l_pmm21,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-B30413 mod l_pnb07->l_pnb86 #MOD-BA0204 mark
                                      l_pnb20,l_task,l_pmm21,l_pmm43,l_type,l_pnb86,'',g_term,g_price,g_plant) #MOD-BA0204 add 
                                RETURNING l_price,lt_price,g_pmn73,g_pmn74   #TQC-AC0257 add g_pmn73,g_pmn74
                       IF lt_price != 0 THEN
                          IF g_pnb[l_ac].pnb32a > lt_price*(1+g_sma.sma84/100) THEN
                             IF g_sma.sma109 = 'R' THEN
                                CALL cl_err(g_pnb[l_ac].pnb04a,'apm-240',0)
                               #MOD-D30073 add start -----
                                SELECT pnz04 INTO g_pnz04 FROM pnz_file WHERE pnz01 = g_term
                                IF cl_null(g_pnz04) THEN 
                                   LET g_pnz04 = 'Y'
                                END IF 
                                IF g_pnz04 = 'Y' THEN
                               #MOD-D30073 add end   -----
                                   NEXT FIELD pnb31a
                               #MOD-D30073 add start -----
                                ELSE
                                    NEXT FIELD pnb03
                                END IF
                               #MOD-D30073 add end    -----
                             ELSE
                                CALL cl_err('','apm-240',0)
                             END IF
                          END IF
                       END IF
                    END IF
               END IF
            END IF
 
        AFTER FIELD pnb33a
             IF g_pnb[l_ac].pnb33a < g_pna.pna04 THEN
                CALL cl_err('','apm-054',0)
                NEXT FIELD pnb33a
             END IF
            IF g_sma.sma32 = 'Y' AND NOT cl_null(g_pnb[l_ac].pnb07a) THEN
               NEXT FIELD pnb50
            END IF
#TQC-C10099 add begin            
            IF g_pnb[l_ac].pnb33a IS NOT NULL THEN           
               CALL s_wkday(g_pnb[l_ac].pnb33a) RETURNING l_flag,l_date
               IF l_date IS NULL OR l_date = ' ' THEN
                  NEXT FIELD pnb33a
               ELSE
                  LET g_pnb[l_ac].pnb33a = l_date
               END IF
            END IF  
#TQC-C10099 add end 
        #--->單位需存在於單位檔中
        AFTER FIELD pnb07a #採購單位,須存在
            IF l_newline='Y' AND cl_null(g_pnb[l_ac].pnb07a) THEN
                #新增項次,所以此欄位不可空白
                CALL cl_err('','apm-915',0)
            ELSE
                IF NOT cl_null(g_pnb[l_ac].pnb04a) AND
                   g_pnb[l_ac].pnb04b <> g_pnb[l_ac].pnb04a THEN
                    IF cl_null(g_pnb[l_ac].pnb07a) THEN
                      IF cl_null(g_pnb[l_ac].pnb07a) AND g_sma.sma115='N' THEN   #MOD-7A0067 modify
                        CALL cl_err('','aar-011',0)
                        NEXT FIELD pnb07a
                      END IF   #MOD-7A0067 
                    END IF
                END IF
            END IF
             IF NOT cl_null(g_pnb[l_ac].pnb07a) AND g_pnb[l_ac].pnb07a!=g_pnb[l_ac].pnb07b THEN
                CALL t910_unit(g_pnb[l_ac].pnb07a)   #是否存在於單位檔中
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_pnb[l_ac].pnb07a,g_errno,0)
                   LET g_pnb[l_ac].pnb07a = g_pnb_t.pnb07a
                   DISPLAY BY NAME g_pnb[l_ac].pnb07a
                   NEXT FIELD pnb07a
                END IF
                IF g_sma.sma116 MATCHES '[02]' THEN
                   LET g_pnb[l_ac].pnb86a = g_pnb[l_ac].pnb07a
                END IF
               #FUN-C30081 add START
                IF NOT cl_null(g_pmn41) AND l_newline = 'N' THEN   #原採購單上單身有存在工單號碼
                   LET l_n = 0
                   LET l_qty2 = 0
                   LET l_qty3 = 0
                   LET l_sfb08 = 0
                   SELECT ima55 INTO l_ima55 FROM ima_file
                     WHERE ima01 = g_pnb[l_ac].pnb04b
                   LET l_sql = " SELECT SUM(pmn20),pmn07 ",
                               " FROM pmn_file ",
                               " WHERE pmn41 = '",g_pmn41,"' ",
                               "  AND pmn04 = '",g_pnb[l_ac].pnb04b,"' ",
                               "  AND pmn01 NOT IN ('",g_pna.pna01,"') ",
                               "  GROUP BY pmn07 "
                   PREPARE t910_qty3 FROM l_sql
                   DECLARE pnb_qty3 CURSOR FOR t910_qty3
                   FOREACH pnb_qty3 INTO l_qty2,l_pmn07
                      IF NOT cl_null(l_pmn07) THEN
                         IF l_pmn07 = l_ima55 THEN
                            LET l_qty3 = l_qty3 + l_qty2
                         ELSE
                            CALL s_umfchk(g_pnb[l_ac].pnb04b,l_pmn07,l_ima55)
                               RETURNING l_sw,l_pmn09      #單位轉換
                            IF l_sw THEN
                               LET l_pmn09 = 1
                            END IF
                            LET l_qty2 = l_qty2 * l_pmn09
                            LET l_qty3 = l_qty3 + l_qty2
                         END IF
                      END IF
                   END FOREACH
                   LET l_qty3 = l_qty3 + g_pnb[l_ac].pnb20a
                   SELECT COUNT(*) INTO l_n FROM sfb_file
                     WHERE sfb01 = g_pmn41
                       AND sfb05 = g_pnb[l_ac].pnb04b
                   IF l_n > 0 THEN
                      SELECT sfb08 INTO l_sfb08
                        FROM sfb_file
                        WHERE sfb01 = g_pmn41
                          AND sfb05 = g_pnb[l_ac].pnb04b
                      IF l_sfb08 < l_qty3 THEN
                         CALL cl_err('','apm-302',0)
                         NEXT FIELD pnb20a
                      END IF
                   END IF
                END IF
               #FUN-C30081 add END
             END IF
             IF NOT cl_null(g_pnb[l_ac].pnb07a) THEN
                CALL t910_set_pnb87a()
             END IF 
            #--->單位判斷結束
            IF g_sma.sma32 = 'Y' THEN
                  IF NOT chk_qty() THEN
                     CALL cl_err('','mfg3425',1)
                     IF g_sma.sma33='R'THEN
                         NEXT FIELD pnb20a
                     END IF
                  END IF
            END IF
       #FUN-910088--add--start--
           #IF g_sma.sma115 != 'N' THEN                                                 #TQC-C20183
           #   LET g_pnb[l_ac].pnb20a = s_digqty(g_pnb[l_ac].pnb20a,g_pnb[l_ac].pnb07a) #TQC-C20183
           #   DISPLAY BY NAME g_pnb[l_ac].pnb20a                                       #TQC-C20183
           #ELSE                                                                        #TQC-C20183
           IF NOT cl_null(g_pnb[l_ac].pnb20a) AND g_pnb[l_ac].pnb20a <> 0 THEN
              IF NOT t910_pnb20a_check(l_newline) THEN
                 NEXT FIELD pnb20a
              END IF
           END IF
           #END IF
       #FUN-910088--add--end--

#FUN-A80142 --begin--          
       AFTER FIELD pnb34a
         IF NOT cl_null(g_pnb[l_ac].pnb34a) THEN 
            LET l_count = 0          
            SELECT COUNT(*),pjaacti,pjaclose INTO l_count,l_pjaacti,l_pjaclose 
              FROM pja_file 
             WHERE pja01 = g_pnb[l_ac].pnb34a
             GROUP BY pjaacti,pjaclose
            IF l_count = 0 THEN 
               CALL cl_err('','aic-036',0)
               NEXT FIELD CURRENT 
            END IF  
            IF l_pjaacti = 'N' THEN 
               CALL cl_err('','alm-004',0)
               NEXT FIELD CURRENT 
            END IF 
            IF l_pjaclose = 'Y' THEN
               CALL cl_err('','abg-503',0)
               NEXT FIELD CURRENT 
            END IF          
         END IF 
        
       AFTER FIELD pnb35a
          IF NOT cl_null(g_pnb[l_ac].pnb35a) THEN 
             LET l_count = 0           
             SELECT COUNT(*),pjb09,pjb11,pjbacti INTO l_count,l_pjb09,l_pjb11,l_pjbacti
               FROM pjb_file
              WHERE pjb01 = g_pnb[l_ac].pnb34a
                AND pjb02 = g_pnb[l_ac].pnb35a
              GROUP BY pjb09,pjb11,pjbacti
            IF l_count = 0 THEN 
               CALL cl_err('','apj-051',0)
               NEXT FIELD CURRENT 
            END IF  
            IF l_pjbacti = 'N' THEN 
               CALL cl_err('','alm-004',0)
               NEXT FIELD CURRENT 
            END IF 
            IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN 
               CALL cl_err('','apj-090',0)
               NEXT FIELD CURRENT 
            END IF                  
          END IF 
          
       BEFORE FIELD pnb36a
         CALL cl_set_comp_entry("pnb36a",TRUE)
         SELECT pjb25 INTO l_pjb25 FROM pjb_file
          WHERE pjb01 = g_pnb[l_ac].pnb34a
            AND pjb02 = g_pnb[l_ac].pnb35a
            AND pjbacti = 'Y' 
         IF l_pjb25 = 'Y' THEN 
            CALL cl_set_comp_entry("pnb36a",TRUE)
         ELSE
            LET g_pnb[l_ac].pnb36a = ''
            CALL cl_set_comp_entry("pnb36a",FALSE)
         END IF 	
          
       AFTER FIELD pnb36a
         IF NOT cl_null(g_pnb[l_ac].pnb36a) THEN
            LET l_count = 0 
#           SELECT g_pnb[l_ac].pnb35a INTO l_pnb35a FROM dual #FUN-B30219 mark
            LET l_pnb35a = g_pnb[l_ac].pnb35a                 #FUN-B30219
            SELECT COUNT(*),pjkacti INTO l_count,l_pjkacti
              FROM pjk_file
             WHERE pjk11 = l_pnb35a
               AND pjk02 = g_pnb[l_ac].pnb36a
             GROUP BY pjkacti 
            IF l_count = 0 THEN 
               CALL cl_err('','aic-036',0)
               NEXT FIELD CURRENT
            END IF    
            IF l_pjkacti = 'N' OR cl_null(l_pjkacti) THEN 
               CALL cl_err('','alm-004',0)
               NEXT FIELD CURRENT 
            END IF 
         END IF 
#FUN-A80142 --end--
 
        BEFORE DELETE                            #是否取消單身
            IF g_pnb_t.pnb03 > 0 AND
               g_pnb_t.pnb03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM pnb_file
                    WHERE pnb01 = g_pna.pna01
                      AND pnb02 = g_pna.pna02
                      AND pnb03 = g_pnb_t.pnb03
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_pnb_t.pnb03,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
                   IF NOT s_del_pnbi(g_pna.pna01,g_pna.pna02,g_pnb_t.pnb03,'') THEN
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
                LET g_rec_b=g_rec_b-1
                LET l_pna13 = '0'          #FUN-550038
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pnb[l_ac].* = g_pnb_t.*
               CLOSE t910_bcl
               IF NOT s_industry('std') THEN                                                                                        
                  CLOSE t910_bcl_slk                                                                                               
               END IF                                                                                                               
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pnb[l_ac].pnb03,-263,1)
               LET g_pnb[l_ac].* = g_pnb_t.*
            ELSE
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
                     CALL s_chk_va_setting(g_pnb[l_ac].pnb04a)
                          RETURNING g_flag,g_ima906,g_ima907
                     IF g_flag=1 THEN
                        NEXT FIELD pnb04a
                     END IF
                     CALL s_chk_va_setting1(g_pnb[l_ac].pnb04a)
                          RETURNING g_flag,g_ima908
                     IF g_flag=1 THEN
                        NEXT FIELD pnb04a
                     END IF
                  END IF
 
                  CALL t910_set_origin_field()
                  #計算pnb20,pnb07的值,檢查數量的合理性
                  CALL t910_check_inventory_qty(p_cmd,l_newline)
                      RETURNING g_flag
                  IF g_flag = '1' THEN
                     IF g_ima906 = '3' OR g_ima906 = '2' THEN
                        NEXT FIELD pnb85a
                     ELSE
                        NEXT FIELD pnb82a
                     END IF
                  END IF
                  IF g_flag = '2' THEN
                     IF g_ima906 = '3' OR g_ima906 = '2' THEN
                        NEXT FIELD pnb83a
                     ELSE
                        NEXT FIELD pnb80a
                     END IF
                  END IF
                  IF g_flag = '3' THEN
                     NEXT FIELD pnb33a
                  END IF
               END IF
               #CHI-B50016 add --start--
               IF NOT t910_chk_blanketpo() THEN
                  IF g_sma.sma115 ='N' THEN
                     NEXT FIELD pnb20a
                  ELSE
                     IF g_ima906 = '3' OR g_ima906 = '2' THEN
                        NEXT FIELD pnb85a
                     ELSE
                        NEXT FIELD pnb82a
                     END IF
                  END IF
               END IF
               #CHI-B50016 add --end--
               IF cl_null(g_pnb[l_ac].pnb041a) THEN           #MOD-9C0280
                  LET g_pnb[l_ac].pnb041a=g_pnb[l_ac].pnb041b #MOD-9C0280
               END IF                                         #MOD-9C0280
                #MOD-AC0377-----add----str-------------
                IF cl_null(g_pnb[l_ac].pnb31a) THEN 
                   LET g_pnb[l_ac].pnb31a = g_pnb[l_ac].pnb31b
                END IF
                IF cl_null(g_pnb[l_ac].pnb32a) THEN
                   LET g_pnb[l_ac].pnb32a= g_pnb[l_ac].pnb32b
                END IF
#MOD-B80343 -- mark begin --
                #MOD-AC0377-----add-----end------------
#               UPDATE pnb_file SET
#                      pnb03  = g_pnb[l_ac].pnb03,
#                      pnb04a = g_pnb[l_ac].pnb04a,
#                      pnb20a = g_pnb[l_ac].pnb20a,
#                      pnb31a = g_pnb[l_ac].pnb31a,
#                      pnb32a = g_pnb[l_ac].pnb32a,       #No.FUN-550089
#                      pnb33a = g_pnb[l_ac].pnb33a,
#                      #MOD-AC0377-----mod------str-------------
#                      #pnb33a = g_pnb[l_ac].pnb34a,       #FUN-A80142
#                      #pnb33a = g_pnb[l_ac].pnb35a,       #FUN-A80142
#                      #pnb33a = g_pnb[l_ac].pnb36a,       #FUN-A80142
#                      pnb34a = g_pnb[l_ac].pnb34a, 
#                      pnb35a = g_pnb[l_ac].pnb35a, 
#                      pnb36a = g_pnb[l_ac].pnb36a, 
#                      #MOD-AC0377----mod-------end--------------
#                      pnb041a= g_pnb[l_ac].pnb041a,
#                      pnb07a = g_pnb[l_ac].pnb07a,
#                      pnb83a = g_pnb[l_ac].pnb83a,
#                      pnb84a = g_pnb[l_ac].pnb84a,
#                      pnb85a = g_pnb[l_ac].pnb85a,
#                      pnb80a = g_pnb[l_ac].pnb80a,
#                      pnb81a = g_pnb[l_ac].pnb81a,
#                      pnb82a = g_pnb[l_ac].pnb82a,
#                      pnb86a = g_pnb[l_ac].pnb86a,
#                      pnb87a = g_pnb[l_ac].pnb87a,
#                      pnb90  = g_pnb[l_ac].pnb90,    #FUN-690129 add
#                      pnb91  = g_pnb[l_ac].pnb91,    #FUN-690129 add
#                      pnb50  = g_pnb[l_ac].pnb50
#                WHERE pnb01  = g_pna.pna01
#                  AND pnb02  = g_pna.pna02
#                  AND pnb03  = g_pnb_t.pnb03
#MOD-B80343 -- mark end --
#MOD-B80343 -- begin --
                CALL t910_b_move_back()
#MOD-C30760 add begin
                IF cl_null(b_pnb.pnb86a) OR cl_null(b_pnb.pnb87a) THEN 
                  IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN   
                     IF NOT cl_null(g_pnb[l_ac].pnb07a) THEN 
                        LET b_pnb.pnb86a = g_pnb[l_ac].pnb07a
                     END IF 
                     IF NOT cl_null(g_pnb[l_ac].pnb20a) THEN 
                        LET b_pnb.pnb87a = g_pnb[l_ac].pnb20a                        
                     END IF    
                  END IF                
                END IF
#MOD-C30760 add end
                UPDATE pnb_file SET * = b_pnb.*
                   WHERE pnb01 = g_pna.pna01
                     AND pnb02 = g_pna.pna02
                     AND pnb03 = g_pnb03_o     #MOD-D30186 add
                    #AND pnb03 = g_pnb_t.pnb03 #MOD-D30186 mark
#MOD-B80343 -- end --
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_pnb[l_ac].pnb03,SQLCA.sqlcode,0)
                    LET g_pnb[l_ac].* = g_pnb_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    LET l_pna13 = '0'          #FUN-550038
                    COMMIT WORK
                END IF
            END IF
#MOD-B80343 -- mark begin --
#            UPDATE  pnbi_file  SET 
#                      pnbi03 = g_pnb[l_ac].pnb03 ,      
#                      pnbislk01b = g_pnb[l_ac].pnbislk01b,  #No.FUN-870117   
#                      pnbislk01a = g_pnb[l_ac].pnbislk01a   #No.FUN-870117   
#                WHERE pnbi01  = g_pna.pna01
#                  AND pnbi02  = g_pna.pna02
#                  AND pnbi03  = g_pnb_t.pnb03
#MOD-B80343 -- mark end --
#MOD-B80343 -- begin --
             UPDATE pnbi_file SET * = b_pnbi.*
                WHERE pnbi01 = g_pna.pna01
                  AND pnbi02 = g_pna.pna02
                  AND pnbi03 = g_pnb_t.pnb03
#MOD-B80343 -- end --
                IF SQLCA.sqlcode THEN
                    CALL cl_err(b_pnbi.pnbislk01a,SQLCA.sqlcode,0)
                ELSE
                    MESSAGE 'UPDATE O.K'
                    LET l_pna13 = '0'       
                    COMMIT WORK
                END IF
        AFTER ROW
            CALL t910_set_entry_b1() #MOD-5A0416 add
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac    #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pnb[l_ac].* = g_pnb_t.*
            #FUN-D30034--add--str--
              ELSE
                 CALL g_pnb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE t910_bcl
                  CLOSE t910_bcl_slk                                                                                               
               
               ROLLBACK WORK
               EXIT INPUT
            END IF
           LET l_ac_t = l_ac    #FUN-D30034
            CLOSE t910_bcl
                  CLOSE t910_bcl_slk                                                                                               
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pnb90)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pml3"
                 CALL cl_create_qry() RETURNING g_pnb[l_ac].pnb90,g_pnb[l_ac].pnb91
                 DISPLAY BY NAME g_pnb[l_ac].pnb90
                 DISPLAY BY NAME g_pnb[l_ac].pnb91
 
               WHEN INFIELD(pnb03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmn5"
                    LET g_qryparam.default1 = g_pnb[l_ac].pnb03
                    LET g_qryparam.arg1 = g_pna.pna01
                    CALL cl_create_qry() RETURNING g_pnb[l_ac].pnb03
                    DISPLAY g_pnb[l_ac].pnb03 TO pnb03
                    NEXT FIELD pnb03
#FUN-A80142 --begin--
               WHEN INFIELD(pnb34a)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pja2"
                    LET g_qryparam.default1 = g_pnb[l_ac].pnb34a
                    CALL cl_create_qry() RETURNING g_pnb[l_ac].pnb34a
                    DISPLAY g_pnb[l_ac].pnb34a TO pnb34a
                    NEXT FIELD pnb34a
               WHEN INFIELD(pnb35a)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pjb4"
                    LET g_qryparam.default1 = g_pnb[l_ac].pnb35a
                    LET g_qryparam.arg1     = g_pnb[l_ac].pnb34a
                    CALL cl_create_qry() RETURNING g_pnb[l_ac].pnb35a
                    DISPLAY g_pnb[l_ac].pnb35a TO pnb35a
                    NEXT FIELD pnb35a
               WHEN INFIELD(pnb36a)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pjk3"
                    LET g_qryparam.default1 = g_pnb[l_ac].pnb36a
                    LET g_qryparam.arg1     = g_pnb[l_ac].pnb35a
                    CALL cl_create_qry() RETURNING g_pnb[l_ac].pnb36a
                    DISPLAY g_pnb[l_ac].pnb36a TO pnb36a
                    NEXT FIELD pnb36a                                        
#FUN-A80142 --end--
                    
               WHEN INFIELD(pnbislk01a)   #No.FUN-870117 pnbislk01-->pnbislk01a
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_skd01"
                    LET g_qryparam.default1 = g_pnb[l_ac].pnbislk01a
                    CALL cl_create_qry() RETURNING g_pnb[l_ac].pnbislk01a
                    DISPLAY g_pnb[l_ac].pnbislk01a TO pnbislk01a
                    NEXT FIELD pnbislk01a   #No.FUN-870117
               WHEN INFIELD(pnb04a) #料件編號
#                   CALL cl_init_qry_var()         #FUN-AB0025 mark
                    LET g_t1 =g_pna.pna01[1,g_doc_len]                                                                                
                    SELECT smy62 INTO g_smy62 FROM smy_file                                                                           
                     WHERE smyslip =g_t1                                                                                              
                    IF g_sma.sma120 ='Y' AND g_sma.sma907 ='Y' AND NOT cl_null(g_smy62) THEN
#FUN-AB0025------mod-----------------str--------------------
#                      LET g_qryparam.form     = "q_ima19"                                                                            
#                      LET g_qryparam.arg1= g_smy62                                                                                   
#                      LET g_qryparam.default1 = g_pnb[l_ac].pnb04a   
                       CALL q_sel_ima(FALSE, "q_ima19","",g_pnb[l_ac].pnb04a,g_smy62,"","","","",'' ) 
                        RETURNING g_pnb[l_ac].pnb04a        
#FUN-AB0025------mod-----------------end--------------------                                                        
                    ELSE 
#FUN-AB0025------mod-----------------str-------------------- 
#                      LET g_qryparam.form = "q_ima"
#                      LET g_qryparam.default1 = g_pnb[l_ac].pnb04a
                       CALL q_sel_ima(FALSE, "q_ima","",g_pnb[l_ac].pnb04a,"","","","","",'' ) 
                        RETURNING g_pnb[l_ac].pnb04a  
#FUN-AB0025------mod-----------------end--------------------
                    END IF
#                   CALL cl_create_qry() RETURNING g_pnb[l_ac].pnb04a  #FUN-AB0025 mark
                    DISPLAY g_pnb[l_ac].pnb04a TO pnb04a
               WHEN INFIELD(pnb07a) #採購單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_pnb[l_ac].pnb07a
                    CALL cl_create_qry() RETURNING g_pnb[l_ac].pnb07a
                    DISPLAY g_pnb[l_ac].pnb07a TO pnb07a
                    NEXT FIELD pnb07a
               WHEN INFIELD(pnb80a) #單位 #FUN-650166
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_pnb[l_ac].pnb80a
                    CALL cl_create_qry() RETURNING g_pnb[l_ac].pnb80a
                    DISPLAY BY NAME g_pnb[l_ac].pnb80a
                    NEXT FIELD pnb80a
 
               WHEN INFIELD(pnb83a) #單位   #FUN-650166
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_pnb[l_ac].pnb83a
                    CALL cl_create_qry() RETURNING g_pnb[l_ac].pnb83a
                    DISPLAY BY NAME g_pnb[l_ac].pnb83a
                    NEXT FIELD pnb83a
 
               WHEN INFIELD(pnb86a) #計價單位  #FUN-650166
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_pnb[l_ac].pnb86a
                    CALL cl_create_qry() RETURNING g_pnb[l_ac].pnb86a
                    DISPLAY BY NAME g_pnb[l_ac].pnb86a
                    NEXT FIELD pnb86a
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION controls                           #No.FUN-6B0032
           CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
        UPDATE pna_file SET pnamodu=g_user,pnadate=g_today,pna13=l_pna13
         WHERE pna01=g_pna.pna01
           AND pna02=g_pna.pna02   #MOD-780081 add
        LET g_pna.pna13 = l_pna13
        DISPLAY BY NAME g_pna.pna13
        IF g_pna.pna05='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_pna.pna13='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_pna.pna05,g_chr2,"","",g_chr,"")
 
    CLOSE t910_bcl
        CLOSE t910_bcl_slk                                                                                               
    COMMIT WORK
 
   #因為可只變更單頭,故可不輸入單身
#  CALL t910_delall()   #MOD-910035  取消mark  #CHI-C30002 mark
   CALL t910_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t910_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_pna.pna01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM pna_file ",
                  "  WHERE pna01 LIKE '",l_slip,"%' ",
                  "    AND pna01 > '",g_pna.pna01,"'"
      PREPARE t910_pb1 FROM l_sql 
      EXECUTE t910_pb1 INTO l_cnt 
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL t910_x()    #FUN-D20025
         CALL t910_x(1)   #FUN-D20025
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM pna_file WHERE pna01 = g_pna.pna01
                                AND pna02 = g_pna.pna02
         INITIALIZE g_pna.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-B50016 add --start--
FUNCTION t910_chk_blanketpo()
DEFINE l_pmn68   LIKE pmn_file.pmn68 
DEFINE l_pmn69   LIKE pmn_file.pmn69
DEFINE l_pon20   LIKE pon_file.pon20
DEFINE l_pon21   LIKE pon_file.pon21 
DEFINE l_pon07   LIKE pon_file.pon07  #MOD-BB0264 add
DEFINE l_flag    LIKE type_file.chr1  #MOD-BB0264 add
DEFINE l_pmn70   LIKE pmn_file.pmn70  #MOD-BB0264 add
DEFINE l_pmn62   LIKE pmn_file.pmn62  #MOD-BB0264 add
DEFINE l_pmn20po LIKE pmn_file.pmn20  #MOD-BB0264 add
DEFINE l_pondiff LIKE pmn_file.pmn20  #MOD-BB0264 add
DEFINE l_pnb07   LIKE pnb_file.pnb07b #MOD-BB0264 add

   #輸入之數量不可大於Blanket P/O 之申請數量-已轉數量(pon20-pon21)
   #SELECT pmn68,pmn69 INTO l_pmn68,l_pmn69               #MOD-BB0264 mark
   SELECT pmn68,pmn69,pmn62 INTO l_pmn68,l_pmn69,l_pmn62  #MOD-BB0264 add
     FROM pmn_file 
    WHERE pmn01 = g_pna.pna01
      AND pmn02 = g_pnb[l_ac].pnb03
   IF SQLCA.sqlcode THEN LET l_pmn68 = '' END IF
   IF NOT cl_null(l_pmn68) THEN
      #SELECT pon20,pon21 INTO l_pon20,l_pon21 FROM pon_file              #MOD-BB0264 mark
      SELECT pon20,pon21,pon07 INTO l_pon20,l_pon21,l_pon07 FROM pon_file #MOD-BB0264 add
       WHERE pon01 = l_pmn68
         AND pon02 = l_pmn69
      IF SQLCA.sqlcode THEN 
         LET l_pon20 = 0 
         LET l_pon21 = 0
      END IF
      #MOD-BB0264 ----- modify start -----
      #Blanket P/O 之單位轉換因子
      IF NOT cl_null(g_pnb[l_ac].pnb20a) THEN
         IF cl_null(g_pnb[l_ac].pnb07a) THEN
            LET l_pnb07 = g_pnb[l_ac].pnb07b
         ELSE
            LET l_pnb07 = g_pnb[l_ac].pnb07a
         END IF
         CALL s_umfchk(g_pnb[l_ac].pnb04b,l_pnb07,l_pon07) RETURNING l_flag,l_pmn70
         IF l_flag THEN
            CALL cl_err('','abm-731',1)
            RETURN FALSE
         END IF

         IF cl_null(l_pmn62) THEN LET l_pmn62 = 1 END IF
         LET l_pmn20po = g_pnb[l_ac].pnb20a/l_pmn62*l_pmn70

         SELECT SUM(pmn20/pmn62*pmn70) INTO l_pondiff FROM pmn_file
          WHERE pmn68 = l_pmn68 AND pmn69 = l_pmn69
            AND pmn16 <> '9' AND pmn01 <> g_pna.pna01
         IF STATUS OR l_pondiff IS NULL THEN LET l_pondiff = 0 END IF

         IF l_pmn20po > l_pon20 - l_pondiff THEN
      #MOD-BB0264 ----- modify end -----
        #IF g_pnb[l_ac].pnb20a - g_pnb[l_ac].pnb20b > l_pon20 - l_pon21 THEN  #MOD-BB0264 mark
          CALL cl_err('','apm-905',1) 
          RETURN FALSE
         END IF
      END IF   #MOD-BB0264 add
   END IF
   RETURN TRUE
END FUNCTION
#CHI-B50016 add --end--
 
FUNCTION t910_set_entry_b()
 
      CALL cl_set_comp_entry("pnb80a,pnb81a,pnb82a,pnb83a,pnb84a,pnb85a,pnb86a,pnb87a",TRUE)
 
END FUNCTION
 
FUNCTION t910_set_entry_b1()
   DEFINE l_pmm02  LIKE pmm_file.pmm02  #CHI-D30023 add
   DEFINE l_pmm906 LIKE pmm_file.pmm906 #CHI-D30023 add

        CALL cl_set_comp_entry("pnb31a,pnb041a,pnb32a",TRUE)
        CALL cl_set_comp_entry("pnb90,pnb91,pnb04a,pnb07a,pnb31a,pnb33a,pnb50,pnb80a,pnb86a,pnb87a",TRUE) #CHI-B50016 add 

       #CHI-D30023 add start -----
        SELECT pmm02,pmm906 INTO l_pmm02,l_pmm906 FROM pmm_file WHERE pmm01 = g_pna.pna01
        IF NOT (l_pmm02 = 'TAP' AND l_pmm906 = 'N' AND NOT cl_null(l_pmm906)) THEN
           CALL cl_set_comp_entry("pnb90,pnb91,pnb04a,pnb20a,pnb07a,                                   pnb86a,pnb87a,pnb34a,pnb35a,pnb36a,                                   pnb33a,pnb50,pnb80a,pnb82a,pnb86a,pnb87a",TRUE)
        END IF
       #CHI-D30023 add end   -----
END FUNCTION
 
FUNCTION t910_set_no_entry_b1()
   DEFINE l_n LIKE type_file.num5    #No.FUN-680136 SMALLINT
   #-----MOD-A90171---------
   DEFINE l_pmm99   LIKE pmm_file.pmm99,
          l_pmm904  LIKE pmm_file.pmm904,
          l_poz00   LIKE poz_file.poz00,
          l_poz011  LIKE poz_file.poz011,
          l_poy04   LIKE poy_file.poy04,
          l_dbs_new LIKE type_file.chr21,
          l_sql     STRING,
          l_oea01   LIKE oea_file.oea01,
          l_cnt     LIKE type_file.num5
   #-----END MOD-A90171-----
   DEFINE l_pmm02  LIKE pmm_file.pmm02  #CHI-D30023 add
   DEFINE l_pmm906 LIKE pmm_file.pmm906 #CHI-D30023 add
 
      CALL cl_set_comp_entry("pnb31a,pnb32a",TRUE)
      IF g_gec07 = 'N' THEN          
         CALL cl_set_comp_entry("pnb32a",FALSE)
      ELSE
         CALL cl_set_comp_entry("pnb31a",FALSE)
      END IF
 
      SELECT count(*) INTO l_n
          FROM rva_file,rvb_file
          WHERE rvb04 = g_pna.pna01        #採購單號 #NO:7231
            AND rvb03 = g_pnb[l_ac].pnb03  #    項次
            AND rva01=rvb01
            AND rvaconf !='X'
        IF l_n>0 AND g_sma.sma108 = 'N' THEN           #判斷採購單號已存
           CALL cl_set_comp_entry("pnb31a,pnb32a",FALSE)    #No.FUN-550089
        END IF
        #-----MOD-A90171---------
        #代採逆拋,目的站已產生出貨單,sma108為N時不可以修改單價
        LET l_pmm99 = NULL 
        LET l_pmm904 = NULL
        SELECT pmm99,pmm904 INTO l_pmm99,l_pmm904 FROM pmm_file 
          WHERE pmm01 = g_pna.pna01
        LET l_poz00 = NULL
        LET l_poz011 = NULL
        SELECT poz00,poz011 INTO l_poz00,l_poz011 FROM poz_file
          WHERE poz01 = l_pmm904
        IF l_poz00 = '2' AND l_poz011 = '2' THEN 
           LET l_poy04 = NULL
           SELECT poy04 INTO l_poy04 FROM poy_file
            WHERE poy01 = l_pmm904  AND poy02 IN 
              (SELECT MAX(poy02) FROM poy_file WHERE poy01 = l_pmm904 
                                                 AND poy02 <> '99') 
           LET l_plant_new = l_poy04
           LET l_sql = "SELECT oea01 ",
                       " FROM ",cl_get_target_table(l_plant_new CLIPPED,'oea_file'), 
                       " WHERE oea99 = '",l_pmm99,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql 
           PREPARE oea_p FROM l_sql
           LET l_oea01 = NULL
           EXECUTE oea_p INTO l_oea01
           LET l_sql = "SELECT COUNT(*) ",
                       " FROM ",cl_get_target_table(l_plant_new CLIPPED,'ogb_file'),",", 
                                cl_get_target_table(l_plant_new CLIPPED,'oga_file'), 
                       " WHERE ogb31 = '",l_oea01,"'",
                       "   AND ogb32 = '",g_pnb[l_ac].pnb03,"'", #項次 #MOD-B50040 add
                       "   AND oga01 = ogb01 ",
                       "   AND ogaconf <> 'X' "
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
           CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql 
           PREPARE ogb_p FROM l_sql
           LET l_cnt = 0 
           EXECUTE ogb_p INTO l_cnt
           IF l_cnt>0 AND g_sma.sma108 = 'N' THEN 
              CALL cl_set_comp_entry("pnb31a,pnb32a",FALSE)   
           END IF
        END IF
        #-----END MOD-A90171-----
        IF g_sma.sma32='Y' THEN
            IF g_pnb[l_ac].pnb04a[1,4] != 'MISC' OR cl_null(g_pnb[l_ac].pnb04a) THEN
               CALL cl_set_comp_entry("pnb041a",FALSE)
            END IF
        ELSE
            IF (g_pnb[l_ac].pnb04a[1,4] != 'MISC') OR (cl_null(g_pnb[l_ac].pnb04a)) THEN #FUN-560212
               CALL cl_set_comp_entry("pnb041a",FALSE)
            END IF
        END IF
        #CHI-B50016 add --start--
        IF g_blanketpo = 'Y' THEN
           CALL cl_set_comp_entry("pnb90,pnb91,pnb04a,pnb07a,pnb31a,pnb33a,pnb50,pnb80a,pnb86a,pnb87a",FALSE) 
        END IF
        #CHI-B50016 add --end--
        #MOD-C30361-- add -- begin
        IF (cl_null(g_pnb[l_ac].pnb04a)) AND (g_pnb[l_ac].pnb04b[1,4] = 'MISC') THEN
           CALL cl_set_comp_entry("pnb041a",TRUE)
        END IF
        #MOD-C30361-- add -- end

       #CHI-D30023 add start -----
        SELECT pmm02,pmm906 INTO l_pmm02,l_pmm906 FROM pmm_file WHERE pmm01 = g_pna.pna01
        IF l_pmm02 = 'TAP' AND l_pmm906 = 'N' AND NOT cl_null(l_pmm906) THEN
           CALL cl_set_comp_entry("pnb90,pnb91,pnb04a,pnb20a,pnb07a,                                   pnb86a,pnb87a,pnb34a,pnb35a,pnb36a,                                   pnb33a,pnb50,pnb80a,pnb82a,pnb86a,pnb87a",FALSE)
        END IF
       #CHI-D30023 add end   -----
 
     #CALL cl_set_comp_entry("pnb90,pnb91",FALSE)  #FUN-690129 add #MOD-B40038 mark
#TQC-C30173---add----begin---
      IF g_azw.azw04 = '2' THEN
         CALL cl_set_comp_entry("pnb90,pnb91,pnb04a,pnb041a,ima021a,pnb07a,pnb31a,pnb32a,pnb33a,                                 pnb34a,pnb35a,pnb36a,pnb80a,pnb81a,pnb82a,pnb83a,pnb84a,pnb85a,                                 pnb86a,pnb87a,pnbislk01a",FALSE)
      END IF
#TQC-C30173---add----end---
END FUNCTION
 
FUNCTION t910_set_no_entry_b()
   DEFINE l_n LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
      IF g_ima906 = '1' THEN
         CALL cl_set_comp_entry("pnb81a,pnb83a,pnb84a,pnb85a",FALSE)
      END IF
      #參考單位，每個料件只有一個，所以不開放讓用戶輸入
      IF g_ima906 = '3' THEN
         CALL cl_set_comp_entry("pnb83a,pnb81a",FALSE)
      END IF
      IF g_ima906 = '2' THEN
         CALL cl_set_comp_entry("pnb84a,pnb81a",FALSE)
      END IF
      IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
         CALL cl_set_comp_entry("pnb86a,pnb87a",FALSE)
      END IF
 
     #CALL cl_set_comp_entry("pnb90,pnb91",FALSE)  #MOD-B40038 mark
#TQC-C30173---add----begin---
      IF g_azw.azw04 = '2' THEN
         CALL cl_set_comp_entry("pnb90,pnb91,pnb04a,pnb041a,ima021a,pnb07a,pnb31a,pnb32a,pnb33a,                                 pnb34a,pnb35a,pnb36a,pnb80a,pnb81a,pnb82a,pnb83a,pnb84a,pnb85a,                                 pnb86a,pnb87a,pnbislk01a",FALSE) 
      END IF
#TQC-C30173---add----end---
END FUNCTION

FUNCTION t910_delall() 			# 未輸入單身資料, 是否取消單頭資料
    DEFINE l_flag LIKE type_file.chr1
    SELECT COUNT(*) INTO g_cnt FROM pnb_file
        WHERE pnb01 = g_pna.pna01
          AND pnb02 = g_pna.pna02
    IF g_cnt = 0 THEN
       #若單頭也無任何變更
       IF cl_null(g_pna.pna08b) 
          AND cl_null(g_pna.pna10b) 
          AND cl_null(g_pna.pna11b) 
          AND cl_null(g_pna.pna09b)  
          AND cl_null(g_pna.pna12b) THEN
          CALL cl_err(g_pna.pna01,9044,0)
          DELETE FROM pna_file WHERE pna01 = g_pna.pna01 AND pna02 = g_pna.pna02
          DELETE FROM pnb_file WHERE pnb01 = g_pna.pna01 AND pnb02 = g_pna.pna02
          LET l_flag = s_del_pnbi(g_pna.pna01,g_pna.pna02,'','')
          CLEAR FORM
          CALL g_pnb.clear()
       END IF
    END IF
END FUNCTION
 
FUNCTION  t910_pnb03(p_cmd)
DEFINE
    p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_azi04   LIKE azi_file.azi04     #MOD-990199
 
    LET g_errno = ' '
    LET g_pmn41 = ''     #FUN-C30081   add pmn41 
    SELECT pmn04, pmn07, pmn20, pmn83,pmn84,pmn85,pmn80,
           pmn81, pmn82, pmn86, pmn87,pmn31,pmn31t, pmn87*pmn31,pmn87*pmn31t,	#MOD-6C0095
           pmn33, pmn041,pmn24, pmn25 #FUN-610018, pmn31t,pmn20  #No.FUN-550089  #FUN-690129 add pmn25,pmn25
          ,pmn122,pmn96,pmn97,  pmn41      #FUN-A80142 add #FUN-C30081 add pmn41
      INTO g_pnb[l_ac].pnb04b, g_pnb[l_ac].pnb07b,
           g_pnb[l_ac].pnb20b, g_pnb[l_ac].pnb83b,g_pnb[l_ac].pnb84b,
           g_pnb[l_ac].pnb85b, g_pnb[l_ac].pnb80b,g_pnb[l_ac].pnb81b,
           g_pnb[l_ac].pnb82b, g_pnb[l_ac].pnb86b,g_pnb[l_ac].pnb87b,
           g_pnb[l_ac].pnb31b, g_pnb[l_ac].pnb32b,g_pnb[l_ac].totb,
           g_pnb[l_ac].tottb,g_pnb[l_ac].pnb33b,    #No.FUN-610018
           g_pnb[l_ac].pnb041b,       #No.FUN-550089
           g_pnb[l_ac].pnb90b,g_pnb[l_ac].pnb91b         #FUN-690129 add
          ,g_pnb[l_ac].pnb34b,g_pnb[l_ac].pnb35b,g_pnb[l_ac].pnb36b,g_pmn41      #FUN-A80142     #FUN-C30081 add pmn41  
      FROM pmn_file
     WHERE pmn01 = g_pna.pna01 AND pmn02 = g_pnb[l_ac].pnb03
     SELECT azi04 INTO l_azi04 FROM azi_file 
       WHERE azi01 = g_pna.pna08
     LET g_pnb[l_ac].totb = cl_digcut(g_pnb[l_ac].totb,l_azi04)
     LET g_pnb[l_ac].tottb = cl_digcut(g_pnb[l_ac].tottb,l_azi04)
  SELECT pmnislk01 INTO g_pnb[l_ac].pnbislk01b
    FROM pmni_file
   WHERE pmni01 = g_pna.pna01 AND pmni02 = g_pnb[l_ac].pnb03
    SELECT ima021 INTO g_pnb[l_ac].ima021b FROM ima_file
     WHERE ima01=g_pnb[l_ac].pnb04b
END FUNCTION
 
FUNCTION t910_pnb04a(p_no)            #料件編號
    DEFINE l_imaacti LIKE ima_file.imaacti,
           p_no      LIKE pmn_file.pmn04
 
  LET g_errno = " "
  SELECT imaacti,ima02,ima44,ima021          #品名及單位
    INTO l_imaacti,g_pnb[l_ac].pnb041a,g_pnb[l_ac].pnb07a,g_pnb[l_ac].ima021a
    FROM ima_file
   WHERE ima01 = p_no
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET g_pnb[l_ac].pnb041a=NULL
                                 LET g_pnb[l_ac].pnb07a=NULL
                                 LET g_pnb[l_ac].ima021a=NULL
       WHEN l_imaacti='N' LET g_errno = '9028'
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  DISPLAY BY NAME g_pnb[l_ac].pnb041a
  DISPLAY BY NAME g_pnb[l_ac].pnb07a
  DISPLAY BY NAME g_pnb[l_ac].ima021a
 
  DISPLAY BY NAME g_pnb[l_ac].pnb041a,g_pnb[l_ac].pnb07a,g_pnb[l_ac].ima021a  #No.TQC-5C0109
 
END FUNCTION
 
#系統參數設料件/供應商須存在
FUNCTION t910_pmh()  #供應廠商
    DEFINE  l_pmm09 LIKE pmm_file.pmm09,
            l_pmm22 LIKE pmm_file.pmm22,
            l_pmhacti LIKE pmh_file.pmhacti,
            l_pmm02   LIKE pmm_file.pmm02,   #No.CHI-8C0017
            l_pmn18   LIKE pmn_file.pmn18,   #No.CHI-8C0017  
            l_pmn41   LIKE pmn_file.pmn41,   #No.CHI-8C0017
            l_pmn43   LIKE pmn_file.pmn43,   #No.CHI-8C0017
            l_pmh21   LIKE pmh_file.pmh21,   #No.CHI-8C0017
            l_pmh22   LIKE pmh_file.pmh22    #No.CHI-8C0017            
   DEFINE   l_pmn012  LIKE pmn_file.pmn012   #No.FUN-A60011
 
 LET g_errno = " "
SELECT pmm09,pmm22,pmm02 INTO l_pmm09,l_pmm22,l_pmm02              #CHI-8C0017 Add pmm02
  FROM pmm_file
 WHERE pmm01 = g_pna.pna01 AND pmm18 !='X'
SELECT pmn41,pmn43,pmn18,pmn012 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn012 FROM pmn_file  #No.FUN-A60011
 WHERE  pmn01 = g_pna.pna01 AND pmn02 = g_pnb[l_ac].pnb03           
IF l_pmm02='SUB' THEN
   LET l_pmh22='2'
   IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
      LET l_pmh21 =' '
   ELSE
     IF NOT cl_null(l_pmn18) THEN
      SELECT sgm04 INTO l_pmh21 FROM sgm_file
       WHERE sgm01=l_pmn18
         AND sgm02=l_pmn41
         AND sgm03=l_pmn43
         AND sgm012 = l_pmn012   #FUN-A60076
     ELSE
      SELECT ecm04 INTO l_pmh21 FROM ecm_file 
       WHERE ecm01=l_pmn41
         AND ecm03=l_pmn43
         AND ecm012=l_pmn012    #No.FUN-A60011
     END IF
   END IF       #NO.TQC-910033
ELSE
   LET l_pmh22='1'
   LET l_pmh21=' '
END IF
 SELECT pmhacti INTO l_pmhacti
     FROM pmh_file
     WHERE pmh01=g_pnb[l_ac].pnb04a AND pmh02= l_pmm09
       AND pmh13=l_pmm22
       AND pmh21 = l_pmh21                                                      #CHI-8C0017
       AND pmh22 = l_pmh22                                                      #CHI-8C0017
       AND pmh23 = ' '                                             #No.CHI-960033
       AND pmhacti = 'Y'                                           #CHI-910021       
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0031'
                            LET l_pmhacti = NULL
         WHEN l_pmhacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#--->單位檔
FUNCTION t910_unit(p_key)
  DEFINE p_key      LIKE gfe_file.gfe01,
         l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = ' '
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                          LET l_gfeacti = NULL
        WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t910_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT l_wc ON pnb03,pnb20a,pnb85a,pnb82a,pnb31a,pnb32a,pnb33a  #螢幕上取條件
       FROM s_pnb[1].pnb03, s_pnb[1].pnb20a,s_pnb[1].pnb85a,s_pnb[1].pnb82a,
            s_pnb[1].pnb31a,s_pnb[1].pnb32a,s_pnb[1].pnb33a
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
    IF INT_FLAG THEN RETURN END IF
    CALL t910_b_fill(l_wc)
END FUNCTION
 
FUNCTION t910_b_fill(p_wc)              #BODY FILL UP
DEFINE
    l_qty           LIKE pnb_file.pnb20a,		#Qty
    l_up            LIKE pnb_file.pnb31a,		#Unit Price
    lt_up           LIKE pnb_file.pnb32a,		#FUN-610018
    p_wc            LIKE type_file.chr1000              #No.FUN-680136 VARCHAR(200)
 
    LET g_sql =               #No.FUN-550089
       " SELECT pnb03 ,'0','',0 ,pnbislk01b,pnb04b, pnb041b,' ',pnb20b,pnb07b,pnb83b,pnb84b,", #No.FUN-870117
       "        pnb85b,pnb80b,pnb81b,pnb82b,pnb86b,pnb87b,pnb31b,pnb32b,pnb87b*pnb31b, ",  #MOD-6C0095
       "        pnb87b*pnb32b,pnb34b,pnb35b,pnb36b,pnb33b,      ",  #MOD-740032 modify
                   #FUN-A80142 add pnb34b,pnb35b,pnb36b
       "        '1',pnb90,pnb91 ,pnbislk01a, pnb04a, pnb041a,' ',pnb20a,pnb07a,pnb83a,pnb84a,", #No.FUN-870117
       "        pnb85a,pnb80a,pnb81a,pnb82a,pnb86a,pnb87a,pnb31a,pnb32a,0,0,pnb34a,pnb35a,pnb36a,pnb33a,pnb50 ",
                   #FUN-A80142 add pnb34a,pnb35a,pnb36a 
       " FROM pnb_file,OUTER pnbi_file ",     #end No.FUN-550089
       " WHERE pnb01 = '",g_pna.pna01, "'",
       "   AND pnb_file.pnb01 = pnbi_file.pnbi01  ",
       "   AND pnb_file.pnb02 = pnbi_file.pnbi02  ",
       "   AND pnb_file.pnb03 = pnbi_file.pnbi03  ",
       "   AND pnb02 = ",g_pna.pna02," AND ", p_wc CLIPPED
    PREPARE t910_prepare2 FROM g_sql      #預備一下
    DECLARE pnb_cs CURSOR FOR t910_prepare2
    CALL g_pnb.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH pnb_cs INTO g_pnb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima021 INTO g_pnb[g_cnt].ima021a FROM ima_file
         WHERE ima01=g_pnb[g_cnt].pnb04a
        SELECT ima021 INTO g_pnb[g_cnt].ima021b FROM ima_file
         WHERE ima01=g_pnb[g_cnt].pnb04b
 
        SELECT pmn24,pmn25 INTO g_pnb[g_cnt].pnb90b,g_pnb[g_cnt].pnb91b
          FROM pmn_file
         WHERE pmn01=g_pna.pna01  AND pmn02 = g_pnb[g_cnt].pnb03
        IF SQLCA.sqlcode THEN
          LET g_pnb[g_cnt].pnb90b = NULL
          LET g_pnb[g_cnt].pnb91b = NULL
        END IF
      
        #--->計算tota,totta
	#LET l_qty=g_pnb[g_cnt].pnb20b	 #MOD-6C0095
	LET l_qty=g_pnb[g_cnt].pnb87b	 #MOD-6C0095
	LET l_up=g_pnb[g_cnt].pnb31b
	LET lt_up=g_pnb[g_cnt].pnb32b
	 #MOD-6C0095..............begin
        IF NOT cl_null(g_pnb[g_cnt].pnb87a) THEN
           LET l_qty=g_pnb[g_cnt].pnb87a
        END IF
	 #MOD-6C0095...............end
        IF NOT cl_null(g_pnb[g_cnt].pnb31a) THEN
           LET l_up=g_pnb[g_cnt].pnb31a
        END IF
        IF NOT cl_null(g_pnb[g_cnt].pnb32a) THEN
           LET lt_up=g_pnb[g_cnt].pnb32a
        END IF
 
        IF cl_null(g_pnb[g_cnt].pnb87a) AND cl_null(g_pnb[g_cnt].pnb31a) THEN  #MOD-6C0095
            LET g_pnb[g_cnt].tota = NULL
        ELSE
            LET g_pnb[g_cnt].tota=l_qty*l_up
        END IF
        IF cl_null(g_pnb[g_cnt].pnb87a) AND cl_null(g_pnb[g_cnt].pnb32a) THEN  #MOD-6C0095
            LET g_pnb[g_cnt].totta = NULL
        ELSE
            LET g_pnb[g_cnt].totta=l_qty*lt_up
        END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pnb.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
END FUNCTION 
 
FUNCTION t910_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pnb TO s_pnb.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t910_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t910_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t910_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t910_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t910_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
         #CKP
         IF g_pna.pna05='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_pna.pna13='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_pna.pna05,g_chr2,"","",g_chr,"")
         CALL t910_def_form()     #FUN-610067
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
   #@ON ACTION easyflow送簽
     ON ACTION easyflow_approval         #FUN-550038
        LET g_action_choice = "easyflow_approval"
        EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
    #@ON ACTION 發出
       ON ACTION release_po  #MOD-580129
          LET g_action_choice="release_po"  #MOD-580129
         EXIT DISPLAY
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
    #FUN-D20025--add--str--
    #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
    #FUN-D20025--add--end--
    #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
    #@ON ACTION 單價查詢
      ON ACTION qry_unit_price
         LET g_action_choice="qry_unit_price"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
    #@ON ACTION 簽核狀況
      ON ACTION approval_status     #MOD-4C0041
         LET g_action_choice="approval_status"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t910_out()
  DEFINE l_sw       LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(01)
         l_prog     LIKE zz_file.zz01,           #No.FUN-680136 VARCHAR(10)
         l_wc       LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(200)
         l_cmd,g_buf     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_i,l_j    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
	 l_prtway   LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
         l_lang     LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
     IF NOT cl_null(g_pna.pna01) THEN
        CALL cl_confirm('apm-223') RETURNING l_sw
        IF l_sw THEN
           LET l_wc = " pna01 = "," '",g_pna.pna01,"' ",
                      " AND pna02 = "," '",g_pna.pna02,"' "
           LET g_buf=l_wc
           LET l_j=length(g_buf)
           FOR l_i=1 TO l_j
             IF g_buf[l_i,l_i+1]='"' THEN
                LET g_buf[l_i,l_i+1]="'"
             END IF
           END FOR
           LET l_wc = g_buf
           LET l_prog='apmr910'
           SELECT zz22 INTO l_prtway FROM zz_file
            WHERE zz01 = l_prog
	   LET l_cmd = l_prog CLIPPED,
		   " '",g_today CLIPPED,"' ''",
		  #" '",l_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",    #FUN-7B0142 mark
		   " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",   #FUN-7B0142 mod   #FUN-7C0036 g_rlang->g_lang
		  ' "',l_wc CLIPPED,'" '  # TQC-610085 mark ,"3" CLIPPED
            CALL cl_cmdrun(l_cmd)
         END IF
     END IF
END FUNCTION
 
FUNCTION t910_y()
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_pna.* FROM pna_file
    WHERE pna01=g_pna.pna01
      AND pna02=g_pna.pna02 #BugNo:5275
   IF g_pna.pna01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_pna.pna05 = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_pna.pna05 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_pna.pna14='Y'   THEN
      IF g_pna.pna13 != '1' THEN CALL cl_err('','aws-078',1) RETURN END IF
   END IF
   IF g_pna.pnaacti='N' THEN CALL cl_err('','mfg0301',1) RETURN END IF
 
   # 參數設定單價不可為零
   #FUN-C40089---begin
   IF cl_null(g_pna.pna09b) THEN
      LET g_term = g_pna.pna09
   ELSE
      LET g_term = g_pna.pna09b
   END IF
   SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = g_term
   IF cl_null(g_pnz08) THEN 
      LET g_pnz08 = 'Y'
   END IF 
   IF g_pnz08 = 'N' THEN 
   #IF g_sma.sma112= 'N' THEN 
   #FUN-C40089---end
      SELECT COUNT(*) INTO g_cnt FROM pnb_file
       WHERE pnb01 = g_pna.pna01
         AND pnb02 = g_pna.pna02
         AND pnb31a IS NOT NULL
         AND pnb31a <=0
      IF g_cnt > 0 THEN
         CALL cl_err('','axm-627',1) RETURN  #FUN-C50076
      END IF
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   #NO:7203因為可只變更單頭,故可不輸入單身
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t910_cl USING g_pna.pna01,g_pna.pna02
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_pna.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t910_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   UPDATE pna_file SET pna05 = 'Y'
    WHERE pna01 = g_pna.pna01 AND pna02=g_pna.pna02
   IF SQLCA.sqlcode THEN
      CALL cl_err('up pna_file',SQLCA.sqlcode,0) LET g_success = 'N'
   END IF
   IF g_pna.pna14 = 'N' AND g_pna.pna13 = '0' THEN
      LET g_pna.pna13 = '1'
      UPDATE pna_file SET pna13 = g_pna.pna13 WHERE pna01=g_pna.pna01
                                                AND pna02=g_pna.pna02   #MOD-780081 add
      IF SQLCA.sqlcode THEN
         CALL cl_err('up pna_file',SQLCA.sqlcode,0) LET g_success = 'N'
      END IF
   END IF
   IF g_success = 'Y' THEN
 
      IF g_success = 'Y' THEN
         LET g_pna.pna05 = 'Y'
         COMMIT WORK
      ELSE
         LET g_pna.pna05 = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT pna05 INTO g_pna.pna05 FROM pna_file
    WHERE pna01 = g_pna.pna01 AND pna02=g_pna.pna02
   DISPLAY BY NAME g_pna.pna05
   DISPLAY BY NAME g_pna.pna13
   CALL s_pmista('pna',g_pna.pna13,g_pna.pna05,g_pna.pna14)
        RETURNING g_sta
   DISPLAY g_sta TO FORMONLY.desc2
 
    #CKP
    IF g_pna.pna05='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_pna.pna13='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_pna.pna05,g_chr2,"","",g_chr,"")
 
END FUNCTION
 
FUNCTION t910_y_chk()
DEFINE l_pmm01  LIKE pmm_file.pmm01    #FUN-880016
DEFINE l_pmm09  LIKE pmm_file.pmm09    #FUN-880016
DEFINE l_status LIKE type_file.chr1    #FUN-880016
DEFINE l_cnt1,l_cnt2 LIKE type_file.num5    #MOD-910035
DEFINE l_pnb03  LIKE pnb_file.pnb03    #MOD-940071
DEFINE l_pnb20a LIKE pnb_file.pnb20a   #MOD-940071
DEFINE l_rvb07  LIKE rvb_file.rvb07    #MOD-940071
#DEFINE l_t      LIKE type_file.num5    #No.TQC-A70091 #MOD-BC0164 mark
#DEFINE t_pnb03  LIKE pnb_file.pnb03    #No.TQC-A70091 #MOD-BC0164 mark
DEFINE l_pnb04a LIKE pnb_file.pnb04a    #FUN-C30081 add 
DEFINE l_pnb87a LIKE pnb_file.pnb87a    #FUN-C30081 add
DEFINE l_qty2   LIKE pnb_file.pnb20a    #FUN-C30081 add
DEFINE l_qty3   LIKE pnb_file.pnb20a    #FUN-C30081 add
DEFINE l_sfb08  LIKE sfb_file.sfb08     #FUN-C30081 add
DEFINE l_sql    STRING                  #FUN-C30081 add
DEFINE l_ima55  LIKE ima_file.ima55     #FUN-C30081 add
DEFINE l_sw     LIKE type_file.num5     #FUN-C30081 add
DEFINE l_pmn07  LIKE pmn_file.pmn07     #FUN-C30081 add
DEFINE l_pmn09  LIKE pmn_file.pmn09     #FUN-C30081 add
DEFINE l_n      LIKE type_file.num5     #FUN-C30081 add
DEFINE l_slip   LIKE smy_file.smyslip   #CHI-CB0002 add
 
   LET g_success = 'Y'
   LET l_cnt1 = 0 
#CHI-C30107 ------------ add ------------- begin
   IF g_pna.pna05 = 'Y' THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'   #FUN-580147
      RETURN
   END IF
   IF g_pna.pna05 = 'X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'   #FUN-580147
      RETURN
   END IF
   IF g_pna.pnaacti='N' THEN
      CALL cl_err('','mfg0301',1)
      LET g_success = 'N'   #FUN-580147
      RETURN
   END IF   
  IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
     g_action_choice CLIPPED = "insert"  THEN
     IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF 
  END IF
   SELECT * INTO g_pna.* FROM pna_file
    WHERE pna01=g_pna.pna01
      AND pna02=g_pna.pna02
#CHI-C30107 ------------ add ------------- end
   SELECT COUNT(*) INTO l_cnt1 FROM pna_file
       WHERE pna01 = g_pna.pna01
         AND pna02 = g_pna.pna02
   IF l_cnt1 = 0 THEN
      LET g_success = 'N' 
      RETURN
   END IF
 
   LET l_cnt1 = 0
   SELECT COUNT(*) INTO l_cnt1 FROM rva_file,rvb_file
    WHERE rva01 = rvb01 
      AND rvb04 = g_pna.pna01
      AND rvaconf <> 'X'
   IF l_cnt1 > 0 AND 
      (NOT cl_null(g_pna.pna08b) OR  
       NOT cl_null(g_pna.pna10b) OR   
       NOT cl_null(g_pna.pna11b) OR   
       NOT cl_null(g_pna.pna09b) OR   
       NOT cl_null(g_pna.pna12b)) THEN  
      CALL cl_err('','apm-107',0)
      LET g_success = 'N'
      RETURN
   END IF
  #MOD-BC0164 mark --start--
  ##No.TQC-A70091--begin
  #CALL s_showmsg_init()
  #LET g_success='Y'
  #DECLARE t910_pnb03 CURSOR FOR SELECT pnb03 FROM pnb_file WHERE pnb01=g_pna.pna01
  #    AND pnb02=g_pna.pna02
  #FOREACH t910_pnb03 INTO t_pnb03
  #   SELECT COUNT(*) INTO l_t FROM rva_file,rvb_file
  #    WHERE rva01 = rvb01 AND rvb04 = g_pna.pna01 AND rvb03=t_pnb03
  #      AND rvaconf = 'Y'
  #   IF l_t >0 THEN
  #     IF cl_null(g_sma.sma108) OR g_sma.sma108='N' THEN  #MOD-AA0175  
  #        CALL s_errmsg('pnb03',t_pnb03,'','apm-361',1)
  #        LET g_success='N'
  #     END IF                    #MOD-AA0175
  #   END IF
  #END FOREACH
  #CALL s_showmsg()
  #IF g_success='N' THEN
  #   RETURN
  #END IF
  ##No.TQC-A70091--end
  #MOD-BC0164 mark --end--
   IF s_shut(0) THEN
      LET g_success = 'N'   #FUN-580147
      RETURN
   END IF
   
   SELECT * INTO g_pna.* FROM pna_file
    WHERE pna01=g_pna.pna01
      AND pna02=g_pna.pna02 #MODNO:5275
   IF g_pna.pna01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'   #FUN-580147
      RETURN
   END IF
   IF g_pna.pna05 = 'Y' THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'   #FUN-580147
      RETURN
   END IF
   IF g_pna.pna05 = 'X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'   #FUN-580147
      RETURN
   END IF
   IF g_pna.pnaacti='N' THEN
      CALL cl_err('','mfg0301',1)
      LET g_success = 'N'   #FUN-580147
      RETURN
   END IF
 
   IF g_aza.aza71 MATCHES '[Yy]' THEN   #FUN-8A0054 判斷是否有勾選〝與GPM整合〞，有則做GPM控
      LET g_t1 = s_get_doc_no(g_pna.pna01) 
      SELECT * INTO g_smy.* FROM smy_file
      WHERE smyslip=g_t1
      IF NOT cl_null(g_smy.smy64) THEN                                                                                   
         IF g_smy.smy64 != '0' THEN    #要控管GPM
            CALL s_showmsg_init()
            SELECT pmm09 INTO l_pmm09
              FROM pmm_file
             WHERE pmm01 = g_pna.pna01
            IF NOT cl_null(l_pmm09) THEN
	       CALL aws_gpmcli_part(g_pna.pna01,l_pmm09,g_pna.pna02,'3')
	            RETURNING l_status
	       IF l_status = '1' THEN   #回傳結果為失敗
                  IF g_smy.smy64 = '1' THEN
	             CALL s_showmsg()
                  END IF
	          IF g_smy.smy64 = '2' THEN   
	    	     LET g_success = 'N'
                     CALL s_showmsg()        #FUN-8A0054 show失敗結果
	          END IF
	       END IF
            END IF
         END IF
      END IF
   END IF                  #FUN-8A0054
   # 參數設定單價不可為零
   #FUN-C40089---begin
   IF cl_null(g_pna.pna09b) THEN
      LET g_term = g_pna.pna09
   ELSE
      LET g_term = g_pna.pna09b
   END IF
   SELECT pnz08 INTO g_pnz08 FROM pnz_file WHERE pnz01 = g_term
   IF cl_null(g_pnz08) THEN 
      LET g_pnz08 = 'Y'
   END IF 
   IF g_pnz08 = 'N' THEN 
   #IF g_sma.sma112= 'N' THEN 
   #FUN-C40089---end
      SELECT COUNT(*) INTO g_cnt FROM pnb_file
       WHERE pnb01 = g_pna.pna01
         AND pnb02 = g_pna.pna02
         AND pnb31a IS NOT NULL
         AND pnb31a <=0
      IF g_cnt > 0 THEN
         CALL cl_err('','axm-627',1)  #FUN-C50076
         LET g_success = 'N'   #FUN-580147
         RETURN
      END IF
   END IF
 
   LET l_cnt2 = 0 
   SELECT COUNT(*) INTO l_cnt2 FROM pnb_file
       WHERE pnb01 = g_pna.pna01
         AND pnb02 = g_pna.pna02
   IF cl_null(g_pna.pna08b) 
      AND cl_null(g_pna.pna10b) 
      AND cl_null(g_pna.pna11b) 
      AND cl_null(g_pna.pna09b)  
      AND cl_null(g_pna.pna12b) 
      AND l_cnt2 = 0 THEN
      CALL cl_err(g_pna.pna01,'apm1020',0)
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL s_showmsg_init()  #CHI-CB0002 add

   DECLARE pnb_cur CURSOR FOR 
     SELECT pnb03,pnb20a,pnb04a,pnb87a FROM pnb_file  #FUN-C30081 add pnb04a,pnb87a 
       WHERE pnb01 = g_pna.pna01
         AND pnb02 = g_pna.pna02
   FOREACH pnb_cur INTO l_pnb03,l_pnb20a,l_pnb04a,l_pnb87a   #FUN-C30081 add pnb04a,pnb87a
     #==>不可小於已收貨量(rvb07)(不管是否已確認)
     SELECT SUM(rvb07-rvb29-pmn58) INTO l_rvb07 FROM rvb_file,rva_file,pmn_file   #MOD-C80164 add -pmn58、pmn_file 
      WHERE rvb01 = rva01
        AND rvaconf != 'X'
        AND rvb04 = g_pna.pna01
        AND rvb03 = l_pnb03
        AND rvb35 = 'N'   #MOD-A70130
        AND rvb04 = pmn01 #MOD-C80164 add
        AND rvb03 = pmn02 #MOD-C80164 add
     IF l_pnb20a < l_rvb07 THEN
         CALL cl_err(l_rvb07,'apm-411',0)
         LET g_success = 'N'
         RETURN
     END IF
     #-----MOD-A50031---------
     LET g_cnt = 0 
     SELECT COUNT(*) INTO g_cnt FROM pmn_file
        WHERE pmn01 = g_pna.pna01
          AND pmn02 = l_pnb03
     IF g_cnt = 0 THEN 
        IF l_pnb20a <= 0 OR cl_null(l_pnb20a) THEN
           CALL cl_err(l_pnb03,'mfg3348',0)
           LET g_success = ' N'
           RETURN
        END IF
     END IF
     #-----END MOD-A50031-----
     #FUN-C30081 add START
     LET g_pmn41 = ' '
     SELECT pmn41
       INTO  g_pmn41     
       FROM pmn_file
      WHERE pmn01 = g_pna.pna01 
        AND pmn02 = l_pnb03 
     IF NOT cl_null(g_pmn41) THEN   #原採購單上單身有存在工單號碼
        LET l_n = 0
        LET l_qty2 = 0
        LET l_qty3 = 0
        LET l_sfb08 = 0
        SELECT ima55 INTO l_ima55 FROM ima_file
          WHERE ima01 = l_pnb04a
        LET l_sql = " SELECT SUM(pmn20),pmn07 ",
                    " FROM pmn_file ",
                    " WHERE pmn41 = '",g_pmn41,"' ",
                    "  AND pmn04 = '",l_pnb04a,"' ",
                    "  AND pmn01 NOT IN ('",g_pna.pna01,"') ",
                    "  GROUP BY pmn07 "
        PREPARE t910_qty4 FROM l_sql
        DECLARE pnb_qty4 CURSOR FOR t910_qty4
        FOREACH pnb_qty4 INTO l_qty2,l_pmn07
           IF NOT cl_null(l_pmn07) THEN
              IF l_pmn07 = l_ima55 THEN
                 LET l_qty3 = l_qty3 + l_qty2
              ELSE
                 CALL s_umfchk(l_pnb04a,l_pmn07,l_ima55)
                    RETURNING l_sw,l_pmn09      #單位轉換
                 IF l_sw THEN
                    LET l_pmn09 = 1
                 END IF
                 LET l_qty2 = l_qty2 * l_pmn09
                 LET l_qty3 = l_qty3 + l_qty2
              END IF
           END IF
        END FOREACH
        LET l_qty3 = l_qty3 + l_pnb20a
        SELECT COUNT(*) INTO l_n FROM sfb_file
          WHERE sfb01 = g_pmn41
            AND sfb05 = l_pnb04a
        IF l_n > 0 THEN
           SELECT sfb08 INTO l_sfb08
             FROM sfb_file
             WHERE sfb01 = g_pmn41
               AND sfb05 = l_pnb04a
           IF l_sfb08 < l_qty3 THEN
              CALL cl_err('','apm-302',0)
              LET g_success = 'N'
              RETURN
           END IF
        END IF
     END IF
    #FUN-C30081 add END    

      #CHI-CB0002---add---S
       CALL s_get_doc_no(g_pna.pna01) RETURNING l_slip
       SELECT smy59 INTO g_smy.smy59 FROM smy_file
        WHERE smyslip = l_slip
       IF g_smy.smy59 = 'Y' THEN 
         CALL t901_bud(g_pna.pna01,g_pna.pna02,l_pnb03)
       END IF    
      #CHI-CB0002---add---E
     END FOREACH
   #因為可只變更單頭,故可不輸入單身
   CALL s_showmsg()  #CHI-CB0002 add
 
END FUNCTION
 
FUNCTION t910_y_upd()
 
   LET g_success = 'Y'
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"     #FUN-640184
   THEN
      IF g_pna.pna14='Y'   THEN
         IF g_pna.pna13 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   END IF
 
   BEGIN WORK
 
   OPEN t910_cl USING g_pna.pna01,g_pna.pna02
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_pna.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t910_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   UPDATE pna_file SET pna05 = 'Y'
    WHERE pna01 = g_pna.pna01 AND pna02=g_pna.pna02
   IF SQLCA.sqlcode THEN
      CALL cl_err('up pna_file',SQLCA.sqlcode,0) LET g_success = 'N'
   END IF
   IF g_pna.pna14 = 'N' AND g_pna.pna13 = '0' THEN
      LET g_pna.pna13 = '1'
      UPDATE pna_file SET pna13 = g_pna.pna13 
         WHERE pna01=g_pna.pna01 AND pna02 = g_pna.pna02
      IF SQLCA.sqlcode THEN
         CALL cl_err('up pna_file',SQLCA.sqlcode,0) LET g_success = 'N'
      END IF
   END IF
 
   #Update ecm_file if exist
    IF g_sma.sma54='Y' THEN #是否使用製程
       LET l_ac_1 = 0
       SELECT count(*) INTO l_ac_1 FROM pnb_file
        WHERE pnb01 = g_pna.pna01
          AND pnb02 = g_pna.pna02
       IF l_ac_1 > 0 THEN
           FOR l_ac=1 TO l_ac_1 
            CALL t910_upd_ecm('+')
           END FOR      #TQC-660120 add
       END IF           #TQC-660120 add
    END IF
 
   IF g_success = 'Y' THEN
      IF g_pna.pna14 = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET g_pna.pna05="N"
                  LET g_success = "N"
                  ROLLBACK WORK
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET g_pna.pna05="N"
                  ROLLBACK WORK
                  RETURN
        END CASE
      END IF
 
      IF g_success = 'Y' THEN
         LET g_pna.pna13='1'        #執行成功, 狀態值顯示為 '1' 已核准
         LET g_pna.pna05='Y'        #執行成功, 確認碼顯示為 'Y' 已確認
         COMMIT WORK
         DISPLAY BY NAME g_pna.pna13
         DISPLAY BY NAME g_pna.pna05
      ELSE
         LET g_pna.pna05 = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT pna05 INTO g_pna.pna05 FROM pna_file
    WHERE pna01 = g_pna.pna01 AND pna02=g_pna.pna02
   SELECT pna13 INTO g_pna.pna13 FROM pna_file   #MOD-930147
    WHERE pna01 = g_pna.pna01 AND pna02=g_pna.pna02   #MOD-930147
   DISPLAY BY NAME g_pna.pna05
   DISPLAY BY NAME g_pna.pna13
   CALL s_pmista('pna',g_pna.pna13,g_pna.pna05,g_pna.pna14)
        RETURNING g_sta
   DISPLAY g_sta TO FORMONLY.desc2
 
   #CKP
   IF g_pna.pna05='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_pna.pna13='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_pna.pna05,g_chr2,"","",g_chr,"")
 
END FUNCTION
 
FUNCTION t910_z()
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_pna.* FROM pna_file
    WHERE pna01=g_pna.pna01
      AND pna02=g_pna.pna02 #BugNo:5275
   IF g_pna.pna13 = 'S' THEN
       RETURN                                      #MOD-540061
   END IF
   IF g_pna.pna05 = 'N' OR g_pna.pnaconf = 'Y' THEN  RETURN END IF
   IF g_pna.pna05 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_pna.pna01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t910_cl USING g_pna.pna01,g_pna.pna02
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_pna.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t910_cl
       ROLLBACK WORK
       RETURN
   END IF
   UPDATE pna_file SET pna05 = 'N'
    WHERE pna01 = g_pna.pna01 AND pna02=g_pna.pna02
   IF SQLCA.sqlcode THEN
      CALL cl_err('up pna_file',SQLCA.sqlcode,0) LET g_success = 'N'
   END IF
      LET g_pna.pna13 = '0'
      UPDATE pna_file SET pna13 = g_pna.pna13 
          WHERE pna01 = g_pna.pna01 AND pna02=g_pna.pna02    #FUN-640184
      IF SQLCA.sqlcode THEN
         CALL cl_err('up pna_file',SQLCA.sqlcode,0) LET g_success = 'N'
      END IF
 
   #Update ecm_file if exist
    IF g_sma.sma54='Y' THEN      #是否使用製程
       LET l_ac_1 = 0
       SELECT count(*) INTO l_ac_1 FROM pnb_file
        WHERE pnb01 = g_pna.pna01
          AND pnb02 = g_pna.pna02
       IF l_ac_1 > 0 THEN
           FOR l_ac=1 TO l_ac_1 
               CALL t910_upd_ecm('-')
           END FOR      #TQC-660120 add
       END IF           #TQC-660120 add
    END IF
 
   IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
   END IF
   SELECT pna05,pna13 INTO g_pna.pna05,g_pna.pna13 FROM pna_file #MOD-540061
   WHERE pna01 = g_pna.pna01 AND pna02=g_pna.pna02
   DISPLAY BY NAME g_pna.pna05
   DISPLAY BY NAME g_pna.pna13
   CALL s_pmista('pna',g_pna.pna13,g_pna.pna05,g_pna.pna14)
        RETURNING g_sta
   DISPLAY g_sta TO FORMONLY.desc2
    #CKP
    IF g_pna.pna05='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_pna.pna13='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_pna.pna05,g_chr2,"","",g_chr,"")
END FUNCTION
 
#FUNCTION t910_x()       #FUN-D20025
FUNCTION t910_x(p_type)  #FUN-D20025
DEFINE p_type    LIKE type_file.num5     #FUN-D20025
DEFINE l_flag    LIKE type_file.chr1     #FUN-D20025
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_pna.pna01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_pna.* FROM pna_file WHERE pna01=g_pna.pna01
                                          AND pna02=g_pna.pna02 #MOD-4B0045
   #---- 確認OR已發出
   IF g_pna.pna05 = 'Y' OR g_pna.pnaconf = 'Y' THEN 
      CALL cl_err("","9023",0)  #No.TQC-6B0086
      RETURN
   END IF
    IF g_pna.pna13 matches '[Ss1]' THEN          #MOD-4A0299
        CALL cl_err("","mfg3557",0)
        RETURN
   END IF
 
   IF g_pna.pna05 = 'X' THEN
       #---->判斷此採購單,是否尚有未發出的變更單
       SELECT count(*) INTO g_cnt FROM pna_file
        WHERE pna01 = g_pna.pna01
          AND pnaconf IN ('N','n')
          AND pna05 <> 'X' #未作廢的
       IF g_cnt > 0 THEN
           #尚有未發出的採購變更單,不可作廢還原!
           CALL cl_err('','apm-218',1)
           RETURN
       END IF
   END IF
   #FUN-D20025--add--str--
   IF p_type = 1 THEN 
      IF g_pna.pna05='X' THEN RETURN END IF
   ELSE
      IF g_pna.pna05<>'X' THEN RETURN END IF
   END IF
   #FUN-D20025--add--end--
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t910_cl USING g_pna.pna01,g_pna.pna02
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_pna.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t910_cl
       ROLLBACK WORK
       RETURN
   END IF
  #IF cl_void(0,0,g_pna.pna05) THEN   #FUN-D20025
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #FUN-D20025
   IF cl_void(0,0,l_flag) THEN         #FUN-D20025
      LET g_chr=g_pna.pna05
     #IF g_pna.pna05 ='N' THEN  #FUN-D20025
      IF p_type = 1 THEN        #FUN-D20025
          LET g_pna.pna05='X'
      ELSE
          LET g_pna.pna05='N'
      END IF
      UPDATE pna_file SET
             pna05   = g_pna.pna05,
             pnamodu = g_user,
             pnadate = g_today
       WHERE pna01 = g_pna.pna01
         AND pna02=g_pna.pna02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('up pna_file',SQLCA.sqlcode,0) LET g_success = 'N'
      END IF
   END IF
   CLOSE t910_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
 
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT pna05 INTO g_pna.pna05 FROM pna_file
    WHERE pna01 = g_pna.pna01 AND pna02=g_pna.pna02
   DISPLAY BY NAME g_pna.pna05
    #CKP
    IF g_pna.pna05='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_pna.pna13='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_pna.pna05,g_chr2,"","",g_chr,"") 
END FUNCTION
 
FUNCTION t910_g()
 
  DEFINE l_cmd    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(80)
  DEFINE l_cnt1   LIKE type_file.num5    #No.MOD-890145                #MOD-950235--Mark   #MOD-980254
  DEFINE l_pnb03  LIKE pnb_file.pnb03    #MOD-980254
  DEFINE l_pnb20a LIKE pnb_file.pnb20a   #MOD-980254
  DEFINE l_rvb07  LIKE rvb_file.rvb07    #MOD-980254
  DEFINE l_pnb04a LIKE pnb_file.pnb04a    #FUN-C30081 add
  DEFINE l_pnb87a LIKE pnb_file.pnb87a    #FUN-C30081 add
  DEFINE l_qty2   LIKE pnb_file.pnb20a    #FUN-C30081 add
  DEFINE l_qty3   LIKE pnb_file.pnb20a    #FUN-C30081 add
  DEFINE l_sfb08  LIKE sfb_file.sfb08     #FUN-C30081 add
  DEFINE l_sql    STRING                  #FUN-C30081 add
  DEFINE l_ima55  LIKE ima_file.ima55     #FUN-C30081 add
  DEFINE l_sw     LIKE type_file.num5     #FUN-C30081 add
  DEFINE l_pmn07  LIKE pmn_file.pmn07     #FUN-C30081 add
  DEFINE l_pmn09  LIKE pmn_file.pmn09     #FUN-C30081 add
  DEFINE l_n      LIKE type_file.num5     #FUN-C30081 add
  DEFINE l_time   LIKE pna_file.pnasendt  #FUN-CC0094 

  IF cl_null(g_pna.pna01) THEN CALL cl_err('','-400',0) RETURN END IF  #MOD-540006
  
  IF g_pna.pna05 = 'N' THEN CALL cl_err('pna05=N','aap-717',0) RETURN END IF
  IF g_pna.pna05 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
  IF g_pna.pna13 != '1' THEN CALL cl_err('pna13 != 1','apm-299',0) RETURN END IF #MOD-540006
  IF g_pna.pnaconf = 'Y' THEN CALL cl_err('','apm-224',0) RETURN END IF   #FUN-870168
 
  LET l_cnt1 = 0
  SELECT COUNT(*) INTO l_cnt1 FROM rva_file,rvb_file
   WHERE rva01 = rvb01 
     AND rvb04 = g_pna.pna01
     AND rvaconf <> 'X'
  IF l_cnt1 > 0 AND  
     (NOT cl_null(g_pna.pna08b) OR  
      NOT cl_null(g_pna.pna10b) OR   
      NOT cl_null(g_pna.pna11b) OR   
      NOT cl_null(g_pna.pna09b) OR   
      NOT cl_null(g_pna.pna12b)) THEN  
     CALL cl_err('','apm-107',0)
     RETURN
  END IF
  DECLARE pnb_cur2 CURSOR FOR 
    SELECT pnb03,pnb20a,pnb04a,pnb87a FROM pnb_file   #FUN-C30081 add pnb04a,pnb87a

      WHERE pnb01 = g_pna.pna01
        AND pnb02 = g_pna.pna02
  FOREACH pnb_cur2 INTO l_pnb03,l_pnb20a,l_pnb04a,l_pnb87a   #FUN-C30081 add pnb04a,pnb87a
    #==>不可小於已收貨量(rvb07)(不管是否已確認)
    SELECT SUM(rvb07-rvb29-pmn58) INTO l_rvb07 FROM rvb_file,rva_file,pmn_file   #MOD-C80164 add -pmn58 pmn_file   
     WHERE rvb01 = rva01
       AND rvaconf != 'X'
       AND rvb04 = g_pna.pna01
       AND rvb03 = l_pnb03  
       AND rvb35 = 'N'   #MOD-A70130
       AND rvb04 = pmn01 #MOD-C80164 add
       AND rvb03 = pmn02 #MOD-C80164 add
    IF l_pnb20a < l_rvb07 THEN
        CALL cl_err(l_rvb07,'apm-411',0)
        RETURN
    END IF
 #FUN-C30081 add START
    LET g_pmn41 = ' '
    SELECT pmn41
      INTO  g_pmn41
      FROM pmn_file
     WHERE pmn01 = g_pna.pna01
       AND pmn02 = l_pnb03
    IF NOT cl_null(g_pmn41) THEN   #原採購單上單身有存在工單號碼
       LET l_n = 0
       LET l_qty2 = 0
       LET l_qty3 = 0
       LET l_sfb08 = 0
       SELECT ima55 INTO l_ima55 FROM ima_file
         WHERE ima01 = l_pnb04a
       LET l_sql = " SELECT SUM(pmn20),pmn07 ",
                   "  FROM pmn_file ",
                   " WHERE pmn41 = '",g_pmn41,"' ",
                   "  AND pmn04 = '",l_pnb04a,"' ",
                   "  AND pmn01 NOT IN ('",g_pna.pna01,"') ",
                   "  GROUP BY pmn07 "
       PREPARE t910_qty5 FROM l_sql
       DECLARE pnb_qty5 CURSOR FOR t910_qty5
       FOREACH pnb_qty5 INTO l_qty2,l_pmn07
          IF NOT cl_null(l_pmn07) THEN
             IF l_pmn07 = l_ima55 THEN
                LET l_qty3 = l_qty3 + l_qty2
             ELSE
                CALL s_umfchk(l_pnb04a,l_pmn07,l_ima55)
                   RETURNING l_sw,l_pmn09      #單位轉換
                IF l_sw THEN
                   LET l_pmn09 = 1
                END IF
                LET l_qty2 = l_qty2 * l_pmn09
                LET l_qty3 = l_qty3 + l_qty2
             END IF
          END IF
       END FOREACH
       LET l_qty3 = l_qty3 + l_pnb20a
       SELECT COUNT(*) INTO l_n FROM sfb_file
         WHERE sfb01 = g_pmn41
           AND sfb05 = l_pnb04a
       IF l_n > 0 THEN
          SELECT sfb08 INTO l_sfb08
            FROM sfb_file
            WHERE sfb01 = g_pmn41
              AND sfb05 = l_pnb04a
          IF l_sfb08 < l_qty3 THEN
             CALL cl_err('','apm-302',0)
             LET g_success = 'N'
             RETURN
          END IF
       END IF
    END IF
   #FUN-C30081 add END
  END FOREACH
  IF NOT cl_confirm('apm-338') THEN RETURN END IF    #No.MOD-740334 modify
  IF NOT cl_null(g_pna.pna01) AND g_pna.pnaconf !='Y' THEN
     LET l_cmd = "apmp910 ",
                 " '",g_pna.pna01,"'",
                 " '",g_pna.pna02,"'"
     CALL cl_cmdrun_wait(l_cmd CLIPPED)
     
     SELECT pnaconf INTO g_pna.pnaconf FROM pna_file
     WHERE pna01 = g_pna.pna01
       AND pna02 = g_pna.pna02
     DISPLAY g_pna.pnaconf TO pnaconf
     #FUN-CC0094--add--str--
     IF g_pna.pnaconf='Y' THEN 
        LET l_time = TIME
        UPDATE pna_file 
           SET pnasendu = g_user,
               pnasendd = g_today,
               pnasendt = l_time
         WHERE pna01=g_pna.pna01
           AND pna02=g_pna.pna02   
        SELECT pnasendu,pnasendd,pnasendt INTO g_pna.pnasendu,g_pna.pnasendd,g_pna.pnasendt FROM pna_file
        WHERE pna01 = g_pna.pna01
          AND pna02 = g_pna.pna02
        DISPLAY g_pna.pnasendu TO pnasendu
        DISPLAY g_pna.pnasendd TO pnasendd
        DISPLAY g_pna.pnasendt TO pnasendt   
     END IF
     #FUN-CC0094--add--end--  
    CALL t910_mail() #FUN-660067 
  END IF
    #CKP
    IF g_pna.pna05='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_pna.pna13='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_pna.pna05,g_chr2,"","",g_chr,"")
 
END FUNCTION
 
FUNCTION t910_memo()
   DEFINE i,j	    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE g_pnd     DYNAMIC ARRAY OF RECORD
                    pnd03		LIKE pnd_file.pnd03,
                    pnd04		LIKE pnd_file.pnd04
                    END RECORD,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680136 SMALLINT
   IF g_pna.pna01 IS NULL THEN RETURN END IF
 
   LET p_row = 10 LET p_col = 03
   OPEN WINDOW t910_m_w AT p_row,p_col WITH FORM "apm/42f/apmt9101"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt9101")
 
 
   DECLARE t910_m_c CURSOR FOR
           SELECT pnd03,pnd04 FROM pnd_file
             WHERE pnd01 = g_pna.pna01
               AND pnd02 = g_pna.pna02
             ORDER BY pnd03
   LET i = 1
   FOREACH t910_m_c INTO g_pnd[i].*
      LET i = i + 1
      IF i > g_max_rec THEN EXIT FOREACH END IF
   END FOREACH
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pnd WITHOUT DEFAULTS FROM s_pnd.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      #TQC-860019-add
       ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
      END INPUT
 
   CLOSE WINDOW t910_m_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   LET j = ARR_COUNT()
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t910_cl USING g_pna.pna01,g_pna.pna02
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_pna.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pna.pna01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t910_cl
       ROLLBACK WORK
       RETURN
   END IF
   WHILE TRUE
      DELETE FROM pnd_file
             WHERE pnd01 = g_pna.pna01
               AND pnd02 = g_pna.pna02
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err('t910_m(chp#1):',SQLCA.sqlcode,1)
         EXIT WHILE
      END IF
      FOR i = 1 TO j
         IF g_pnd[i].pnd04 IS NULL THEN CONTINUE FOR END IF
         INSERT INTO pnd_file (pnd01,pnd02,pnd03,pnd04,pndplant,pndlegal) #FUN-980006 add pndplant,pndlegal
                VALUES(g_pna.pna01,g_pna.pna02,g_pnd[i].pnd03,g_pnd[i].pnd04,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err('t910_m(chp#2):',SQLCA.sqlcode,1)
            EXIT WHILE
         END IF
      END FOR
      EXIT WHILE
   END WHILE
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t910_6()    #price (IQ)
   DEFINE l_pnb03 LIKE pnb_file.pnb03
   DEFINE l_pnb04a LIKE pnb_file.pnb04a
   DEFINE l_pnb04b LIKE pnb_file.pnb04b
   DEFINE l_cnt   LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_pna.* FROM pna_file WHERE pna01 = g_pna.pna01 AND pna02 = g_pna.pna02
   IF g_pna.pna01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
   LET p_row = 4 LET p_col = 27
   OPEN WINDOW t910_6 AT  p_row,p_col         #條件畫面
        WITH FORM "apm/42f/apmt910_6"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt910_6")
 
 
   WHILE TRUE
      INPUT l_pnb03 WITHOUT DEFAULTS FROM pnb03
 
      AFTER FIELD pnb03
         IF NOT cl_null(l_pnb03) THEN
             SELECT COUNT(*) INTO l_cnt FROM pnb_file
              WHERE pnb01=g_pna.pna01 AND pnb02=g_pna.pna02
                AND pnb03=l_pnb03
             IF l_cnt=0 THEN
                CALL cl_err(l_pnb03,'apm-204',0)
                NEXT FIELD pnb03
             END IF
         END IF
 
      AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
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
     CLOSE WINDOW t910_6                 #結束畫面
     EXIT WHILE
   END WHILE
   SELECT pnb04b,pnb04a INTO l_pnb04b,l_pnb04a FROM pnb_file
    WHERE pnb01=g_pna.pna01 AND pnb02=g_pna.pna02
      AND pnb03=l_pnb03
 
   IF NOT cl_null(l_pnb04a) THEN
      LET g_cmd = 'apmq221 ',"'", l_pnb04a,"'"
      CALL cl_cmdrun(g_cmd)
   ELSE
      LET g_cmd = 'apmq221 ',"'", l_pnb04b,"'"
      CALL cl_cmdrun(g_cmd)
   END IF
END FUNCTION

FUNCTION t910_pna08b()  #幣別
	  DEFINE l_aziacti LIKE azi_file.aziacti
	
	  LET g_errno = " "
	  SELECT azi03,azi04,aziacti INTO t_azi03,t_azi04,l_aziacti FROM azi_file  #No.FUN-550089  #No.MOD-630055 add azi04 #No.CHI-6A0004
					WHERE azi01 = g_pna.pna08b
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                         LET l_aziacti = 0
               WHEN l_aziacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
 
          IF cl_null(g_pna.pna08b) THEN
             SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file WHERE azi01 = g_pna.pna08    #No.MOD-630055 add azi04 #No.CHI-6A0004
          END IF
END FUNCTION

#--No.FUN-B50158--ADD--
FUNCTION t910_chk_pna08b(p_cmd)  #幣別
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_aziacti LIKE azi_file.aziacti
   LET g_errno = " "
   IF NOT cl_null(g_pna.pna08b) THEN
      SELECT azi03,azi04,aziacti INTO t_azi03,t_azi04,l_aziacti FROM azi_file
                           WHERE azi01 = g_pna.pna08b
      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                     LET l_aziacti = 0
           WHEN l_aziacti='N' LET g_errno = '9028'
           OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_pna.pna08b,g_errno,0)
         LET g_pna.pna08b = g_pna_t.pna08b
         DISPLAY BY NAME g_pna.pna08b
         RETURN FALSE
      END IF
   END IF 
   SELECT COUNT(*) INTO g_cnt FROM pnb_file
        WHERE pnb01 = g_pna.pna01
   IF ((p_cmd='a' AND g_pna.pna08b <> g_pna.pna08 AND g_cnt=0) OR
       (p_cmd='u' AND g_pna.pna08b <> g_pna_o.pna08b AND g_cnt>0)  OR
       (p_cmd='u' AND g_pna.pna08b IS NULL AND g_pna_o.pna08b IS NOT NULL) OR
       (p_cmd='u' AND g_pna.pna08b IS NOT NULL AND g_pna_o.pna08b IS NULL)) THEN
        #確定是你要變更的幣別嗎?
            IF NOT cl_confirm2('axm-918',g_pna.pna08b) THEN
                LET g_pna.pna08b=g_pna_o.pna08b
                DISPLAY BY NAME g_pna.pna08b
                RETURN FALSE
            END IF
   END IF
   IF cl_null(g_pna.pna08b) THEN
      SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file WHERE azi01 = g_pna.pna08
   END IF
   LET g_pna_o.pna08b=g_pna.pna08b
   RETURN TRUE 
END FUNCTION
#--No.FUN-B50158--ADD--END--

FUNCTION t910_pna10b()  #付款條件
	 DEFINE    l_pma02    like pma_file.pma02,
                   l_pma06    like pma_file.pma06,
                   l_pmaacti  like pma_file.pmaacti
	
	 LET g_errno = " "
	   SELECT pma02,pma06,pmaacti INTO l_pma02,l_pma06,l_pmaacti
		  FROM pma_file WHERE pma01 = g_pna.pna10b
 
	   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                                          LET l_pma06   = NULL
                                          LET l_pma02   = NULL
                                          LET l_pmaacti = NULL
		 WHEN l_pmaacti='N' LET g_errno = '9028'
		 OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	   END CASE
END FUNCTION
FUNCTION t910_pna09b()  #價格條件
	 LET g_errno = " "
	   SELECT *
	     FROM pnz_file #FUN-930113
            WHERE pnz01 = g_pna.pna09b #FUN-930113
 
	   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
		 OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	   END CASE
END FUNCTION
FUNCTION t910_pna11b(p_code)    #check 地址pna11b或pna12b
	  DEFINE  p_cmd   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
			  p_code  LIKE pme_file.pme01,
			  l_pme02 LIKE pme_file.pme02,
			  l_pmeacti LIKE pme_file.pmeacti
 
	  LET g_errno = " "
	  SELECT pme02,pmeacti INTO l_pme02,l_pmeacti FROM pme_file
  	  WHERE pme01 = p_code
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno='mfg3012'
                                         LET l_pmeacti=NULL
               WHEN l_pmeacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
END FUNCTION

#-----FUN-A20057---------
FUNCTION t910_peo(p_cmd,p_key)
         DEFINE p_cmd       LIKE type_file.chr1,  
                p_key       LIKE gen_file.gen01,
                l_gen02     LIKE gen_file.gen02,
                l_genacti   LIKE gen_file.genacti
 
        LET g_errno = ' '
        SELECT gen02,genacti INTO l_gen02,l_genacti
            FROM gen_file WHERE gen01 = p_key
 
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                       LET l_gen02 = NULL
               WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
        DISPLAY l_gen02 TO FORMONLY.gen02
END FUNCTION
#-----END FUN-A20057-----
 
FUNCTION t910_pna15()    #變更理由
   DEFINE l_azf03    LIKE azf_file.azf03,
          l_azf09    LIKE azf_file.azf09,         #FUN-920186
          l_azf09_mark   LIKE azf_file.azf09,     #FUN-920186
          l_azfacti  LIKE azf_file.azfacti
 
   LET g_errno = " "
   SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti    #FUN-920186
     FROM azf_file
    WHERE azf01 = g_pna.pna15 
      AND azf02 = '2'         #No.TQC-760054
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'asf-453'
                                 LET l_azf03   = NULL
                                 LET l_azfacti = NULL
        WHEN l_azfacti='N'       LET g_errno = '9028'
        WHEN l_azf09 != 'B'      LET g_errno = 'aoo-410'      #FUN-920186
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   DISPLAY l_azf03 TO FORMONLY.azf03 
END FUNCTION
 
FUNCTION t910_ef()
 
    CALL t910_y_chk()          #CALL 原確認的 check 段
    IF g_success = "N" THEN
        RETURN
    END IF
 
    CALL aws_condition()#判斷送簽資料
    IF g_success = 'N' THEN
        RETURN
    END IF
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
 
 
  IF aws_efcli2(base.TypeInfo.create(g_pna),base.TypeInfo.create(g_pnb),'','','','')
  THEN
      LET g_success = 'Y'
      LET g_pna.pna13 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
      DISPLAY BY NAME g_pna.pna13
   ELSE
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION t910_pna01()
   DEFINE l_pmm09 LIKE pmm_file.pmm09,
          l_pmc03 LIKE pmc_file.pmc03,
          l_pmm21 LIKE pmm_file.pmm21
   DEFINE l_n     LIKE type_file.num5      #No.TQC-7C0002
   DEFINE l_pmm909     LIKE pmm_file.pmm909     #No.TQC-950160 add
 
   #MOD-CC0122 mark start -----
   #SELECT pmm09,pmc03,pmm21,pmm43,gec07
   #  INTO l_pmm09,l_pmc03,l_pmm21,g_pmm43,g_gec07
   #MOD-CC0122 add start -----
   #MOD-CC0122 add start -----
    SELECT pmm09,pmc03,pmm21,pmm43,gec07,g_gec05
      INTO l_pmm09,l_pmc03,l_pmm21,g_pmm43,g_gec07,g_gec05
   #MOD-CC0122 add end   -----
     FROM pmm_file,pmc_file,OUTER gec_file
    WHERE pmm01 = g_pna.pna01
      AND pmm09 = pmc_file.pmc01
      AND pmm21 = gec_file.gec01
 
    DISPLAY l_pmm09,l_pmc03 TO FORMONLY.pmm09,FORMONLY.pmc03
    DISPLAY l_pmm21,g_pmm43 TO FORMONLY.pmm21,FORMONLY.pmm43
    DISPLAY g_gec07 TO FORMONLY.gec07
    SELECT pmm909 INTO l_pmm909 FROM pmm_file WHERE pmm01 = g_pna.pna01
    IF l_pmm909 ='3' THEN
       CALL cl_getmsg('axr-500',g_lang) RETURNING g_msg
       CALL cl_set_comp_lab_text("dummy11",g_msg CLIPPED)
       CALL cl_getmsg('apm-040',g_lang) RETURNING g_msg
       CALL cl_set_comp_lab_text("dummy12",g_msg CLIPPED)
    ELSE 
       CALL cl_getmsg('apm-041',g_lang) RETURNING g_msg
       CALL cl_set_comp_lab_text("dummy11",g_msg CLIPPED)
       CALL cl_getmsg('apm-042',g_lang) RETURNING g_msg
       CALL cl_set_comp_lab_text("dummy12",g_msg CLIPPED)
    END IF
    LET l_n = 0 
    SELECT COUNT(*) INTO l_n FROM rva_file,rvb_file
     WHERE rva01 = rvb01 
       AND rvb04 = g_pna.pna01
       AND rvaconf <> 'X'
    IF l_n >0 THEN
       CALL cl_set_comp_entry("pna08b,pna09b,pna10b,pna11b,pna12b",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t910_chk_pmm03()
  DEFINE l_dbs_new      LIKE type_file.chr21   #No.FUN-680136 VARCHAR(21)    #New DataBase Name
  DEFINE l_azp03        LIKE azp_file.azp03
  DEFINE l_last         LIKE type_file.num5    #No.FUN-680136 SMALLINT     #流程之最後家數
  DEFINE i              LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_plant        LIKE azp_file.azp01    #No.FUN-680136 VARCHAR(10)
  DEFINE l_sql          LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1000)
  DEFINE l_pmm904       LIKE pmm_file.pmm904
  DEFINE l_pmm03        LIKE pmm_file.pmm03
 
  LET l_pmm904=''
  LET l_azp03=''
  LET l_dbs_new=''
  LET l_last=''
  LET l_plant=' '
  LET l_pmm03=0
  SELECT pmm904 INTO l_pmm904 FROM pmm_file WHERE pmm01=g_pna.pna01
  SELECT MAX(poy02) INTO l_last FROM poy_file WHERE poy01=l_pmm904
 
  #依流程代碼最多6層
  FOR i = 1 TO l_last - 1
      SELECT poy04 INTO l_plant FROM poy_file
       WHERE poy01 = l_pmm904  AND poy02 = i
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=l_plant
      LET l_dbs_new = s_dbstring(l_azp03)   #TQC-950010 ADD     
 
      LET g_plant_new = l_plant
      LET l_plant_new = g_plant_new
      CALL s_gettrandbs()
      LET l_dbs_tra = g_dbs_tra
 
      LET l_sql  = "SELECT pmm03 ",
                 # "  FROM ",l_dbs_tra CLIPPED,"pmm_file ", #FUN-980093 add     #FUN-A50102 mark
                   "  FROM ",cl_get_target_table(l_plant_new,'pmm_file'),       #FUN-A50102
                   " WHERE pmm01='",g_pna.pna01,"' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-920032  #FUN-950007 add
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
      PREPARE pmm03_p1 FROM l_sql
      DECLARE pmm03_c1 CURSOR FOR pmm03_p1
      OPEN pmm03_c1
      FETCH pmm03_c1 INTO l_pmm03
      CLOSE pmm03_c1
      IF l_pmm03 <> g_pna.pna02 THEN
         CALL cl_err(l_plant,'tri-031',1)
      END IF
  END FOR
END FUNCTION
 
FUNCTION t910_set_required(p_newline)
   DEFINE p_newline LIKE type_file.chr1     #No.FUN-680136 VARCHAR(01)
   IF p_newline='Y' THEN
      CALL cl_set_comp_required("pnb04a,pnb31a,pnb32a,pnb33a",TRUE)  #No.FUN-550089  #No.TQC-5C0105
      IF g_sma.sma115 = "N" THEN
         CALL cl_set_comp_required("pnb20",TRUE)
      END IF
   END IF
 
   IF p_newline='Y' AND g_pmm02 <> 'SUB' THEN
      IF g_sma.sma115 = "N" THEN
         CALL cl_set_comp_required("pnb07a",TRUE)
      END IF
   END IF

 #  #是新增且請採購要勾稽時，請購單號，項次必需要輸入
   IF p_newline='Y' AND g_sma.sma32='Y' THEN
         CALL cl_set_comp_required("pnb90,pnb91",TRUE)
   END IF
END FUNCTION
 
FUNCTION t910_set_entry_b2(p_newline)
  DEFINE p_newline LIKE type_file.chr1
  IF p_newline = 'N' THEN
     IF g_blanketpo != 'Y' THEN #CHI-B50016 add
        CALL cl_set_comp_entry("pnb04a",TRUE)
     END IF #CHI-B50016 add
  END IF
 #MOD-B40038 mark --start--
 #IF p_newline = 'Y' AND g_sma.sma32='Y' THEN
 #   #參數設勾稽請採購,必須輸入請購單號，序號
 #   CALL cl_set_comp_entry("pnb90,pnb91",TRUE)
 #END IF
 #MOD-B40038 mark --end--
END FUNCTION
 
FUNCTION t910_set_no_entry_b2(p_newline)
  DEFINE p_newline  LIKE type_file.chr1 
                
  IF p_newline = 'Y' AND g_sma.sma32='Y'  THEN  
     CALL cl_set_comp_entry("pnb04a",FALSE)
  END IF
  #CHI-B50016 add --start--
  IF g_blanketpo = 'Y' THEN
     CALL cl_set_comp_entry("pnb04a",FALSE)
  END IF 
  #CHI-B50016 add --end--
#TQC-C30173---add----begin---
      IF g_azw.azw04 = '2' THEN
         CALL cl_set_comp_entry("pnb04a",FALSE)
      END IF
#TQC-C30173---add----end---
END FUNCTION
 
FUNCTION t910_set_no_required(p_newline)
   DEFINE p_newline LIKE type_file.chr1     #No.FUN-680136 VARCHAR(01)
 
   CALL cl_set_comp_required("pnb04a,pnb20a,pnb31a,pnb32a,pnb33a,pnb07a,pnb90,pnb91",FALSE) #No.FUN-550089   #No.TQC-5C0015  #FUN-690129 add pnb90,pnb91
 
 
END FUNCTION
 
FUNCTION t910_check_inventory_qty(p_cmd,p_newline)
DEFINE   l_pmn50_55      LIKE pmn_file.pmn50,    #已交量
         l_ima07         LIKE ima_file.ima07,
         l_rate          LIKE sma_file.sma343,   #No.FUN-680136 DEC(5,2)
         l_rvb07         LIKE rvb_file.rvb07,
         l_new,l_old     LIKE pnb_file.pnb20a,
         l_i             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-680136 SMALLINT
         p_newline       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)  #Y:為新的項次 No:7629
         p_cmd           LIKE type_file.chr1     #a:輸入 u:更改  #No.FUN-680136 VARCHAR(1)
DEFINE   l_pml09         LIKE pml_file.pml09     #FUN-690129
DEFINE   l_pml20         LIKE pml_file.pml20     #FUN-690129
DEFINE   l_pml21         LIKE pml_file.pml21     #FUN-690129

 
            #-----MOD-A50031---------
            ##No:7629
            #IF p_newline='Y' AND cl_null(g_pnb[l_ac].pnb20a) THEN
            #    #新增項次,所以此欄位不可空白
            #    CALL cl_err('','apm-915',0)
            #   #NEXT FIELD pnb20a
            #END IF
            ##No:7629(end)
            IF p_newline='Y' AND 
               (cl_null(g_pnb[l_ac].pnb20a) OR g_pnb[l_ac].pnb20a <=0 ) THEN 
               CALL cl_err('','mfg3331',0)
               RETURN 1
            END IF
            #-----END MOD-A50031-----
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt
                FROM pmn_file
                WHERE pmn01=g_pna.pna01 AND pmn02=g_pnb[l_ac].pnb03
            IF g_cnt > 0 THEN
            IF NOT cl_null(g_pnb[l_ac].pnb20a)  THEN
               SELECT pmn20 INTO l_pmn50_55 FROM pmn_file
                WHERE pmn01 = g_pna.pna01
                  AND pmn02 = g_pnb[l_ac].pnb03
                  LET l_pml20 = 0
                  LET l_pml21 = 0
                  SELECT pml20,pml21 INTO l_pml20,l_pml21 FROM pml_file
                   WHERE pml01 = g_pnb[l_ac].pnb90b
                     AND pml02 = g_pnb[l_ac].pnb91b
 
                  LET l_pml09 = 0
                  SELECT pml09 INTO l_pml09 FROM pml_file
                               WHERE pml01=g_pnb[l_ac].pnb90b
                                 AND pml02=g_pnb[l_ac].pnb91b
                  IF l_pml09 IS NULL OR l_pml09 = 0 THEN LET l_pml09 = 1 END IF
 
                  LET l_ima07=' ' LET l_rate=0
                  SELECT ima07 INTO l_ima07 FROM ima_file
                   WHERE ima01=g_pnb[l_ac].pnb04b
                  CASE l_ima07
                       WHEN 'A' LET l_rate=g_sma.sma341/100
                       WHEN 'B' LET l_rate=g_sma.sma342/100
                       WHEN 'C' LET l_rate=g_sma.sma343/100
                       OTHERWISE LET l_rate=0
                  END CASE
               
                  IF g_sma.sma32='Y' AND g_pmm02 != 'SUB' THEN   #No.FUN-590021  #No.MOD-860153 modify
                        IF NOT chk_qty() THEN
                            CALL cl_err('','mfg3425',1)  #MOD-490284
                           IF g_sma.sma33='R'THEN #reject BugNo:4163
                              RETURN 1
                           END IF
                        END IF
                  END IF
                  #==>不可小於已收貨量(rvb07)(不管是否已確認)
                  SELECT SUM(rvb07-rvb29-pmn58) INTO l_rvb07 FROM rvb_file,rva_file,pmn_file       #MOD-A10181 add rvb29   #MOD-C80164 add -pmn58 pmn_file
                   WHERE rvb01 = rva01
                     AND rvaconf != 'X'
                     AND rvb04 = g_pna.pna01
                     AND rvb03 = g_pnb[l_ac].pnb03
                     AND rvb35 = 'N'   #MOD-A70130
                     AND rvb04 = pmn01 #MOD-C80164 add
                     AND rvb03 = pmn02 #MOD-C80164 add
                  IF g_pnb[l_ac].pnb20a < l_rvb07 THEN
                      CALL cl_err(l_rvb07,'apm-411',0)
                      RETURN 1
                  END IF
              END IF
            END IF
             IF cl_null(g_pnb[l_ac].pnb04b) AND g_sma.sma32='Y' THEN #No:7629
                   LET l_old = 0
                   LET l_new = 0
                   SELECT pml20 INTO l_old FROM pml_file
                    WHERE pml01 = g_pnb[l_ac].pnb90
                      AND pml02 = g_pnb[l_ac].pnb91
                   IF cl_null(l_old) THEN LET l_old = 0 END IF
                   SELECT SUM(pmn20*pmn121) INTO l_new FROM pmn_file  
                    WHERE pmn24 = g_pnb[l_ac].pnb90
                      AND pmn25 = g_pnb[l_ac].pnb91
                      AND pmn16 NOT IN ('6','7','8','9')      #CHI-720006 add
                   IF cl_null(l_new) THEN LET l_new = 0 END IF
                   LET l_pml09 = 0
                   SELECT pml09 INTO l_pml09 FROM pml_file
                               WHERE pml01=g_pnb[l_ac].pnb90
                                 AND pml02=g_pnb[l_ac].pnb91
                   IF l_pml09 IS NULL OR l_pml09 = 0 THEN LET l_pml09 = 1 END IF
                   LET l_new = l_new / l_pml09
    
                   LET l_ima07=' ' LET l_rate=0
                   SELECT ima07 INTO l_ima07 FROM ima_file
                    WHERE ima01=g_pnb[l_ac].pnb04a
                   CASE l_ima07
                        WHEN 'A' LET l_rate=g_sma.sma341/100
                        WHEN 'B' LET l_rate=g_sma.sma342/100
                        WHEN 'C' LET l_rate=g_sma.sma343/100
                        OTHERWISE LET l_rate=0
                   END CASE
                   IF NOT chk_qty() THEN
                      CALL cl_err('','apm-403',1)
                      IF g_sma.sma33='R' THEN   #No.FUN-590021   #CHI-870031
                        RETURN 1
                      END IF
                   END IF
             END IF
 
            IF p_newline='Y' AND cl_null(g_pnb[l_ac].pnb07a) THEN
                #新增項次,所以此欄位不可空白
                CALL cl_err('','apm-915',0)
            ELSE
                IF NOT cl_null(g_pnb[l_ac].pnb04a) AND
                   g_pnb[l_ac].pnb04b <> g_pnb[l_ac].pnb04a THEN
                    IF cl_null(g_pnb[l_ac].pnb07a) THEN
                       IF cl_null(g_pnb[l_ac].pnb07a) AND g_sma.sma115='N' THEN   #MOD-7A0067 modify
                        CALL cl_err('','aar-011',0)
                        RETURN 2
                       END IF  #MOD-7A0067
                    END IF
                END IF
            END IF
             IF NOT cl_null(g_pnb[l_ac].pnb07a) AND g_pnb[l_ac].pnb07a!=g_pnb[l_ac].pnb07b THEN
                CALL t910_unit(g_pnb[l_ac].pnb07a)   #是否存在於單位檔中
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_pnb[l_ac].pnb07a,g_errno,0)
                   LET g_pnb[l_ac].pnb07a = g_pnb_t.pnb07a
                   DISPLAY BY NAME g_pnb[l_ac].pnb07a
                   RETURN 2
                END IF
             END IF
            #--->單位判斷結束
         RETURN 0
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t910_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_unit2  LIKE pnb_file.pnb83a,
            l_fac2   LIKE pnb_file.pnb84a,
            l_qty2   LIKE pnb_file.pnb85a,
            l_fac1   LIKE pnb_file.pnb81a,
            l_qty1   LIKE pnb_file.pnb82a,
            l_unit1  LIKE pnb_file.pnb80a,
            l_pnb07  LIKE pnb_file.pnb07a,
            l_pnb20  LIKE pnb_file.pnb20a,
            l_factor LIKE ima_file.ima31_fac, #No.FUN-680136 DECIMAL(16,8)
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44
 
    IF g_sma.sma115='N' THEN RETURN END IF
    LET g_pnb04 = g_pnb[l_ac].pnb04b
    IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
       LET g_pnb04 = g_pnb[l_ac].pnb04a
    END IF
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=g_pnb04
    IF SQLCA.sqlcode = 100 THEN
       IF g_pnb04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
    LET l_unit2=g_pnb[l_ac].pnb83b
    LET l_fac2=g_pnb[l_ac].pnb84b
    LET l_qty2=g_pnb[l_ac].pnb85b
    LET l_unit1=g_pnb[l_ac].pnb80b
    LET l_fac1=g_pnb[l_ac].pnb81b
    LET l_qty1=g_pnb[l_ac].pnb82b
    IF NOT cl_null(g_pnb[l_ac].pnb83a) THEN
       LET l_unit2=g_pnb[l_ac].pnb83a
    END IF
    IF NOT cl_null(g_pnb[l_ac].pnb84a) THEN
       LET l_fac2=g_pnb[l_ac].pnb84a
    END IF
    IF NOT cl_null(g_pnb[l_ac].pnb85a) THEN
       LET l_qty2=g_pnb[l_ac].pnb85a
    END IF
    IF NOT cl_null(g_pnb[l_ac].pnb80a) THEN
       LET l_unit1=g_pnb[l_ac].pnb80a
    END IF
    IF NOT cl_null(g_pnb[l_ac].pnb81a) THEN
       LET l_fac1=g_pnb[l_ac].pnb81a
    END IF
    IF NOT cl_null(g_pnb[l_ac].pnb82a) THEN
       LET l_qty1=g_pnb[l_ac].pnb82a
    END IF
    IF NOT cl_null(g_pnb[l_ac].pnb80a) THEN
       LET g_pnb80 = g_pnb[l_ac].pnb80a
    ELSE
       LET g_pnb80 = g_pnb[l_ac].pnb80b
    END IF
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_pnb[l_ac].pnb07a=g_pnb80
                   LET g_pnb[l_ac].pnb20a=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_pnb[l_ac].pnb07a=l_ima44
                   LET g_pnb[l_ac].pnb20a=l_tot
          WHEN '3' LET g_pnb[l_ac].pnb07a=g_pnb80
                   LET g_pnb[l_ac].pnb20a=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_pnb[l_ac].pnb84a=l_qty1/l_qty2
                   ELSE
                      LET g_pnb[l_ac].pnb84a=0
                   END IF
       END CASE
       LET g_pnb[l_ac].pnb20a = s_digqty(g_pnb[l_ac].pnb20a,g_pnb[l_ac].pnb07a)   #FUN-910088--add--
    #ELSE  #不使用雙單位
    END IF
    IF cl_null(g_pnb[l_ac].pnb07a) OR g_pnb[l_ac].pnb07b <> l_pnb07 THEN
       LET g_pnb[l_ac].pnb07a=g_pnb80
    END IF
    IF cl_null(g_pnb[l_ac].pnb20a) OR g_pnb[l_ac].pnb20b <> l_pnb20 THEN
       LET g_pnb[l_ac].pnb20a=l_qty1
    END IF
 
    IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN   #MOD-970212
       #LET g_pnb[l_ac].pnb86a = g_pnb[l_ac].pnb07a #MOD-C30760 mark
       #LET g_pnb[l_ac].pnb87a = g_pnb[l_ac].pnb20a #MOD-C30760 mark
       IF NOT cl_null(g_pnb[l_ac].pnb07a) THEN #MOD-C30760 add                  
          LET g_pnb[l_ac].pnb86a = g_pnb[l_ac].pnb07a
       END IF 
       IF NOT cl_null(g_pnb[l_ac].pnb20a) THEN #MOD-C30760 add 
          LET g_pnb[l_ac].pnb87a = g_pnb[l_ac].pnb20a
       END IF        
    END IF
END FUNCTION
 
FUNCTION t910_set_pnb87a()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_pnb07  LIKE pnb_file.pnb07a,
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    LET g_pnb04 = g_pnb[l_ac].pnb04b
    IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
       LET g_pnb04 = g_pnb[l_ac].pnb04a
    END IF
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_pnb04
    IF SQLCA.sqlcode =100 THEN
       IF g_pnb04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac2=g_pnb[l_ac].pnb84b
       LET l_qty2=g_pnb[l_ac].pnb85b
       LET l_fac1=g_pnb[l_ac].pnb81b
       LET l_qty1=g_pnb[l_ac].pnb82b
       IF NOT cl_null(g_pnb[l_ac].pnb84a) THEN
          LET l_fac2=g_pnb[l_ac].pnb84a
       END IF
       IF NOT cl_null(g_pnb[l_ac].pnb85a) THEN
          LET l_qty2=g_pnb[l_ac].pnb85a
       END IF
       IF NOT cl_null(g_pnb[l_ac].pnb81a) THEN
          LET l_fac1=g_pnb[l_ac].pnb81a
       END IF
       IF NOT cl_null(g_pnb[l_ac].pnb82a) THEN
          LET l_qty1=g_pnb[l_ac].pnb82a
       END IF
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pnb[l_ac].pnb20b
       IF NOT cl_null(g_pnb[l_ac].pnb20a) THEN
          LET l_qty1=g_pnb[l_ac].pnb20a
       END IF 
      LET l_pnb07 = g_pnb[l_ac].pnb07b
      IF NOT cl_null(g_pnb[l_ac].pnb07a) THEN
         LET l_pnb07=g_pnb[l_ac].pnb07a
      END IF
       CALL s_umfchk(g_pnb04,l_pnb07,l_ima44)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
      LET l_tot=l_qty1*l_fac1 #MOD-6C0095
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    IF cl_null(g_pnb[l_ac].pnb86a) THEN 
       IF g_sma.sma116 MATCHES '[02]' THEN   
          LET g_pnb[l_ac].pnb86a = g_pnb[l_ac].pnb07a
       ELSE
          IF g_pnb[l_ac].pnb04a <> g_pnb[l_ac].pnb04b THEN 
             SELECT ima908 INTO g_pnb[l_ac].pnb86a FROM ima_file
                WHERE ima01 = g_pnb[l_ac].pnb04a
          ELSE
             LET g_pnb[l_ac].pnb86a = g_pnb[l_ac].pnb86b
          END IF    
       END IF
    END IF
    LET l_factor = 1
   CALL s_umfchk(g_pnb04,l_ima44,g_pnb[l_ac].pnb86a) #MOD-6C0095
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET g_pnb[l_ac].pnb87a = l_tot
    LET g_pnb[l_ac].pnb87a = s_digqty(g_pnb[l_ac].pnb87a,g_pnb[l_ac].pnb86a)    #FUN-910088--add--
END FUNCTION

#MOD-B80343 -- begin --
FUNCTION t910_b_move_back()
   LET b_pnb.pnb01    = g_pna.pna01
   LET b_pnb.pnb02    = g_pna.pna02
   LET b_pnb.pnb03    = g_pnb[l_ac].pnb03
   LET b_pnb.pnb04b   = g_pnb[l_ac].pnb04b
   LET b_pnb.pnb041b  = g_pnb[l_ac].pnb041b
   LET b_pnb.pnb07b   = g_pnb[l_ac].pnb07b
   LET b_pnb.pnb20b   = g_pnb[l_ac].pnb20b
   LET b_pnb.pnb31b   = g_pnb[l_ac].pnb31b
   LET b_pnb.pnb33b   = g_pnb[l_ac].pnb33b
   LET b_pnb.pnb04a   = g_pnb[l_ac].pnb04a
   LET b_pnb.pnb041a  = g_pnb[l_ac].pnb041a
   LET b_pnb.pnb07a   = g_pnb[l_ac].pnb07a
   LET b_pnb.pnb20a   = g_pnb[l_ac].pnb20a
   LET b_pnb.pnb31a   = g_pnb[l_ac].pnb31a
   LET b_pnb.pnb33a   = g_pnb[l_ac].pnb33a
   LET b_pnb.pnb50    = g_pnb[l_ac].pnb50
   LET b_pnb.pnb32a   = g_pnb[l_ac].pnb32a
   LET b_pnb.pnb32b   = g_pnb[l_ac].pnb32b
   LET b_pnb.pnb80b   = g_pnb[l_ac].pnb80b
   LET b_pnb.pnb81b   = g_pnb[l_ac].pnb81b
   LET b_pnb.pnb82b   = g_pnb[l_ac].pnb82b
   LET b_pnb.pnb83b   = g_pnb[l_ac].pnb83b
   LET b_pnb.pnb84b   = g_pnb[l_ac].pnb84b
   LET b_pnb.pnb85b   = g_pnb[l_ac].pnb85b
   LET b_pnb.pnb86b   = g_pnb[l_ac].pnb86b
   LET b_pnb.pnb87b   = g_pnb[l_ac].pnb87b
   LET b_pnb.pnb80a   = g_pnb[l_ac].pnb80a
   LET b_pnb.pnb81a   = g_pnb[l_ac].pnb81a
   LET b_pnb.pnb82a   = g_pnb[l_ac].pnb82a
   LET b_pnb.pnb83a   = g_pnb[l_ac].pnb83a
   LET b_pnb.pnb84a   = g_pnb[l_ac].pnb84a
   LET b_pnb.pnb85a   = g_pnb[l_ac].pnb85a
   LET b_pnb.pnb86a   = g_pnb[l_ac].pnb86a
   LET b_pnb.pnb87a   = g_pnb[l_ac].pnb87a
   LET b_pnb.pnb90    = g_pnb[l_ac].pnb90
   LET b_pnb.pnb91    = g_pnb[l_ac].pnb91
   LET b_pnb.pnbplant = g_plant
   LET b_pnb.pnblegal = g_legal
   LET b_pnb.pnb34a   = g_pnb[l_ac].pnb34a
   LET b_pnb.pnb34b   = g_pnb[l_ac].pnb34b
   LET b_pnb.pnb35a   = g_pnb[l_ac].pnb35a
   LET b_pnb.pnb35b   = g_pnb[l_ac].pnb35b
   LET b_pnb.pnb36a   = g_pnb[l_ac].pnb36a
   LET b_pnb.pnb36b   = g_pnb[l_ac].pnb36b
   LET b_pnbi.pnbi01  = g_pna.pna01
   LET b_pnbi.pnbi02  = g_pna.pna02
   LET b_pnbi.pnbi03  = g_pnb[l_ac].pnb03
   LET b_pnbi.pnbislk01a = g_pnb[l_ac].pnbislk01a
   LET b_pnbi.pnbislk01b = g_pnb[l_ac].pnbislk01b
   LET b_pnbi.pnbiplant  = g_plant
   LET b_pnbi.pnbilegal  = g_legal
END FUNCTION
#MOD-B80343 -- end -- 

#用于default 雙單位/轉換率/數量
FUNCTION t910_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_ima908 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_unit3  LIKE img_file.img09,     #計價單位
            l_qty3   LIKE img_file.img10,     #計價數量
            p_cmd    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    LET l_item = g_pnb[l_ac].pnb04a
 
    SELECT ima44,ima906,ima907,ima908
      INTO l_ima44,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_item
 
    IF g_sma.sma115 = 'Y' THEN     #No.MOD-720039 add
       IF l_ima906 = '1' THEN  #不使用雙單位
          LET l_unit2 = NULL
          LET l_fac2  = NULL
          LET l_qty2  = NULL
       ELSE
          LET l_unit2 = l_ima907
          CALL s_du_umfchk(l_item,'','','',l_ima44,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
          LET l_fac2 = l_factor
          LET l_qty2  = 0
       END IF
       
       LET l_unit1 = l_ima44
       LET l_fac1  = 1
       LET l_qty1  = 0
    END IF          #No.MOD-720039 add
 
    IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       LET l_unit3 = NULL
       LET l_qty3  = NULL
    ELSE
       LET l_unit3 = l_ima908
       LET l_qty3  = 0
    END IF
 
    IF p_cmd = 'a' THEN
       LET g_pnb[l_ac].pnb83a=l_unit2
       LET g_pnb[l_ac].pnb84a=l_fac2
       LET g_pnb[l_ac].pnb85a=l_qty2
       LET g_pnb[l_ac].pnb80a=l_unit1
       LET g_pnb[l_ac].pnb81a=l_fac1
       LET g_pnb[l_ac].pnb82a=l_qty1
       LET g_pnb[l_ac].pnb86a=l_unit3
       LET g_pnb[l_ac].pnb87a=l_qty3
    END IF
END FUNCTION
FUNCTION t910_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("pna01",TRUE)
  END IF
 #CHI-D30023 add start -----
  IF NOT (g_pmm.pmm02 = 'TAP' AND g_pmm.pmm906 = 'N' AND NOT cl_null(g_pmm.pmm906)) THEN
     CALL cl_set_comp_entry("pna08b,pna09b,pna10b,pna11b,pna12b",TRUE)
  END IF
 #CHI-D30023 add end   -----
END FUNCTION
 
FUNCTION t910_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("pna01",FALSE)
  END IF
 #CHI-D30023 add start -----
  IF g_pmm.pmm02 = 'TAP' AND g_pmm.pmm906 = 'N' AND NOT cl_null(g_pmm.pmm906) THEN
     CALL cl_set_comp_entry("pna08b,pna09b,pna10b,pna11b,pna12b",FALSE)
  END IF
 #CHI-D30023 add end   -----
END FUNCTION
 
FUNCTION t910_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pnb83b,pnb85b,pnb80b,pnb82b",FALSE)
      CALL cl_set_comp_visible("pnb83a,pnb85a,pnb80a,pnb82a",FALSE)
      CALL cl_set_comp_visible("pnb07b,pnb20b,pnb07a,pnb20a",TRUE)
      CALL cl_set_comp_visible("dummy83,dummy85,dummy80,dummy82",FALSE)
      CALL cl_set_comp_visible("dummy06,dummy05",TRUE)
      CALL cl_set_comp_lab_text("dummy80"," ")
      CALL cl_set_comp_lab_text("dummy81"," ")
      CALL cl_set_comp_lab_text("dummy82"," ")
      CALL cl_set_comp_lab_text("dummy83"," ")
      CALL cl_set_comp_lab_text("dummy84"," ")
      CALL cl_set_comp_lab_text("dummy85"," ")
   ELSE
      CALL cl_set_comp_visible("pnb83b,pnb85b,pnb80b,pnb82b",TRUE)
      CALL cl_set_comp_visible("pnb83a,pnb85a,pnb80a,pnb82a",TRUE)
      CALL cl_set_comp_visible("pnb07b,pnb20b,pnb07a,pnb20a",FALSE)
      CALL cl_set_comp_visible("dummy83,dummy85,dummy80,dummy82",TRUE)
      CALL cl_set_comp_visible("dummy06,dummy05",FALSE)
      CALL cl_set_comp_lab_text("dummy05"," ")
      CALL cl_set_comp_lab_text("dummy06"," ")
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.MOD-640574
      CALL cl_set_comp_visible("pnb86a,pnb87a,pnb86b,pnb87b",FALSE)
      CALL cl_set_comp_visible("dummy86",FALSE)
      CALL cl_set_comp_visible("dummy87",FALSE)
   ELSE
       CALL cl_set_comp_visible("pnb86a,pnb87a,pnb86b,pnb87b",TRUE)
       CALL cl_set_comp_visible("dummy86,dummy87",TRUE)
   END IF
   CALL cl_set_comp_lab_text("dummy81"," ")
   CALL cl_set_comp_lab_text("dummy84"," ")
   CALL cl_set_comp_visible("pnb81b,pnb84b,pnb81a,pnb84a",FALSE)
   CALL cl_set_comp_visible("dummy81,dummy84",FALSE)
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy82",g_msg CLIPPED)
   END IF
END FUNCTION
 
FUNCTION t910_upd_ecm(p_type)
DEFINE p_type     LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE l_pmn      RECORD LIKE pmn_file.*
DEFINE l_ecm54    LIKE ecm_file.ecm54,
       l_ecm321   LIKE ecm_file.ecm321,
       l_pmn20    LIKE pmn_file.pmn20,
       l_wip      LIKE ecm_file.ecm311,
       l_wip_1    LIKE ecm_file.ecm311,   # wip qty (工單不作check-in)
       l_wip_2    LIKE ecm_file.ecm311    # wip qty (要 check in)
DEFINE l_flag     LIKE type_file.num5     #No.FUN-A60011
 
     LET g_error=''   #MOD-930147
     IF cl_null(g_pnb[l_ac].pnb20a) OR   #MOD-8A0229
        g_pnb[l_ac].pnb20a = g_pnb[l_ac].pnb20b THEN   #MOD-8A0229
        RETURN
     END IF 
     DECLARE t910_upd_ecm CURSOR FOR
      SELECT * FROM pmn_file,sfb_file
       WHERE pmn01=g_pna.pna01
         AND pmn02=g_pnb[l_ac].pnb03
         AND pmn41 IS NOT NULL   #工單號碼
         AND pmn41=sfb01 AND sfb93='Y' AND sfb87!='X'
         AND pmn46 >0            #製程序
     FOREACH t910_upd_ecm INTO l_pmn.*
        IF p_type='-'   #取消確認時
           THEN
           SELECT pmn20 INTO l_pmn20 FROM pmn_file   #取得原訂購量
            WHERE pmn01 = g_pna.pna01
              AND pmn02 = g_pnb[l_ac].pnb03
           UPDATE ecm_file SET ecm321=ecm321-g_pnb[l_ac].pnb20a+l_pmn20    #委外加工量
             WHERE ecm01=l_pmn.pmn41   #工單單號
               AND ecm03=l_pmn.pmn46   #本製程序
               AND ecm012=l_pmn.pmn012 #No.FUN-A60011
        ELSE            #確認時
           SELECT pmn20 INTO l_pmn20 FROM pmn_file   #取得原訂購量
            WHERE pmn01 = g_pna.pna01
              AND pmn02 = g_pnb[l_ac].pnb03
           SELECT ecm54,ecm321,
                  (ecm301+ecm302-(ecm311+ecm312)-ecm313-ecm314),
                  (ecm291-(ecm311+ecm312)-ecm313-ecm314)
             INTO l_ecm54,l_ecm321,l_wip_1,l_wip_2
             FROM ecm_file
            WHERE ecm01=l_pmn.pmn41
              AND ecm03=l_pmn.pmn46
              AND ecm012=l_pmn.pmn012 #No.FUN-A60011
           IF STATUS THEN
              CALL cl_err('sel ecm',STATUS,0) LET g_success='N' RETURN
           END IF
 
           IF l_ecm54 = 'N' THEN    #工單不作check-in
              LET l_wip = l_wip_1
           ELSE
              LET l_wip = l_wip_2
           END IF
 
           IF cl_null(l_wip) THEN LET l_wip = 0 END IF
 
           IF g_pnb[l_ac].pnb20a >l_wip THEN  #MOD-930147
              #該筆採購確認後工單製程委外加工數量將大於WIP量
              LET g_error = 'apm-301'   #MOD-930147
              CALL cl_err(l_pmn.pmn41,'apm-301',0)
              LET g_success='N'
              RETURN
           END IF
 
           IF p_type = '+' THEN   #MOD-930147
              UPDATE ecm_file SET ecm321=ecm321+g_pnb[l_ac].pnb20a-l_pmn20  #委外加工量
                WHERE ecm01=l_pmn.pmn41   #工單單號
                  AND ecm03=l_pmn.pmn46   #本製程序
                  AND ecm012=l_pmn.pmn012 #No.FUN-A60011
           END IF   #MOD-930147 
        END IF
        IF STATUS OR SQLCA.SQLERRD[3]=0
           THEN
           CALL cl_err('Update ecm_file:',STATUS,1)
           LET g_success='N'
        END IF
        #No.FUN-A60011  --Begin
        CALL s_update_ecm52(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn46)
             RETURNING l_flag
        IF NOT l_flag THEN
           LET g_success = 'N'
           CALL cl_err3('upd','ecm_file',l_pmn.pmn41,l_pmn.pmn46,SQLCA.sqlcode,'','update ecm52',1)
        END IF
        #No.FUN-A60011  --End  
    END FOREACH
    IF STATUS THEN
       CALL cl_err('foreach pmn',STATUS,0)
       LET g_success='N'
       RETURN
    END IF
END FUNCTION
 
FUNCTION t910_mail()
  DEFINE l_cmd          LIKE type_file.chr1000 
  DEFINE l_pmc912       LIKE   pmc_file.pmc912   
  DEFINE l_pmm09        LIKE   pmm_file.pmm09
  DEFINE l_pmd02        LIKE   pmd_file.pmd02
  DEFINE l_pmd07        LIKE   pmd_file.pmd07
  DEFINE l_zo02         LIKE   zo_file.zo02
  DEFINE l_subject      STRING   #主旨
  DEFINE l_body         STRING   #內文路徑
  DEFINE l_recipient    STRING   #收件者
  DEFINE l_cnt          LIKE   type_file.num5    #SMALLINT
  DEFINE l_wc           STRING
  DEFINE l_sql          STRING
  DEFINE ls_context        STRING  
  DEFINE ls_temp_path      STRING 
  DEFINE ls_context_file   STRING
  DEFINE i              LIKE type_file.num5      #MOD-960103
 
  #廠商基本資料中如勾選要發mail給廠商，則依連絡人發mail
#TQC-AB0025-------------mod------------------str----------
# SELECT pmm09,pmc912 INTO l_pmm09,l_pmc912 
#   FROM pmm_file,OUTER pmc_file
#  WHERE pmm01 = g_pna.pna01
#    AND pmm09 = pmc01
  SELECT pmm09,pmc912 INTO l_pmm09,l_pmc912
    FROM pmm_file LEFT OUTER JOIN pmc_file ON pmm09 = pmc01
   WHERE pmm01 = g_pna.pna01
#TQC-AB0025-------------mod------------------end-----------
  IF SQLCA.sqlcode THEN
     CALL cl_err3("sel","pmm_file",g_pna.pna01,"",SQLCA.sqlcode,"","",0) 
  ELSE
    IF l_pmc912 = 'Y' THEN #要發mail
      SELECT COUNT(*) INTO l_cnt FROM pmd_file
       WHERE pmd01 = l_pmm09  AND  pmd07 IS NOT NULL 
         AND pmd08 = 'Y'                      #No.FUN-980071
      IF l_cnt >0 THEN
       #主旨
        SELECT zo02 INTO l_zo02  FROM zo_file  WHERE zo01 = g_lang
        LET l_subject = cl_getmsg("apm-795",g_lang) CLIPPED,l_zo02 CLIPPED,
                        cl_getmsg("apm-797",g_lang) CLIPPED,g_pna.pna01
        LET g_xml.subject = l_subject 
 
       #內文 
        LET ls_context = cl_getmsg("apm-799",g_lang) CLIPPED
        LET ls_temp_path = FGL_GETENV("TEMPDIR")
        LET ls_context_file = ls_temp_path,"/report_context_" || FGL_GETPID() || ".txt"
        LET l_cmd = "echo '" || ls_context || "' > " || ls_context_file
        RUN l_cmd WITHOUT WAITING
        LET g_xml.body = ls_context_file
 
       #收件者
         LET l_recipient = ''
         DECLARE t910_pmd_c CURSOR FOR
                 SELECT pmd02,pmd07 FROM pmd_file
                   WHERE pmd01 = l_pmm09 
                     AND pmd07 IS NOT NULL
                     AND pmd08 = 'Y'                         #No.FUN-980071 
                   ORDER BY pmd02
         LET i = 0                                           #MOD-960103
         FOREACH t910_pmd_c INTO l_pmd02,l_pmd07
            LET i = i + 1
            IF i = 1 THEN
               LET l_recipient = l_recipient CLIPPED,l_pmd07 CLIPPED,":",l_pmd02 CLIPPED ,":","1" CLIPPED
            ELSE
               LET l_recipient = l_recipient CLIPPED ,";",l_pmd07 CLIPPED,":",l_pmd02 CLIPPED ,":","1" CLIPPED
            END IF
         END FOREACH
         LET g_xml.recipient = l_recipient
         
         LET l_wc = "pna01='",g_pna.pna01 CLIPPED,"'",
                    " AND pna04='",g_pna.pna04 CLIPPED,"'",
                    " AND pna02=",g_pna.pna02 
         LET l_wc = cl_replace_str(l_wc,"'","\"")
         CALL FGL_SETENV("MAIL_TO",l_recipient)               #MOD-960103
         LET l_cmd = "apmr910 '",g_today,"' '",g_user CLIPPED,"' '",g_lang,"' 'Y' 'A' '1' '",l_wc CLIPPED,"' '3' 'default' 'default' 'default' '",g_xml.subject,"' '",g_xml.body,"' '",g_xml.recipient,"' 'apmr910_0_std' ''"   #MOD-960103
         CALL cl_cmdrun(l_cmd)
      END IF 
    END IF
  END IF
END FUNCTION
 
FUNCTION t910_pnb91()
  DEFINE l_pml20 LIKE pml_file.pml20
  DEFINE l_pmn20 LIKE pmn_file.pmn20
  DEFINE l_pml09 LIKE pml_file.pml09
 
  IF g_sma.sma115 = 'Y' THEN
    SELECT pml04,pml041,pml83,pml85,pml80,pml82,pml86,pml87 INTO
           g_pnb[l_ac].pnb04a,g_pnb[l_ac].pnb041a,
           g_pnb[l_ac].pnb83a,g_pnb[l_ac].pnb85a,
           g_pnb[l_ac].pnb80a,g_pnb[l_ac].pnb82a,
           g_pnb[l_ac].pnb86a,g_pnb[l_ac].pnb87a
      FROM pml_file 
     WHERE pml01 = g_pnb[l_ac].pnb90
       AND pml02 = g_pnb[l_ac].pnb91
    IF SQLCA.sqlcode THEN
      LET g_pnb[l_ac].pnb04a = ''
      LET g_pnb[l_ac].pnb041a = ''
      LET g_pnb[l_ac].ima021a = ''
      LET g_pnb[l_ac].pnb83a = ''
      LET g_pnb[l_ac].pnb85a = 0
      LET g_pnb[l_ac].pnb80a = ''
      LET g_pnb[l_ac].pnb82a = 0
      LET g_pnb[l_ac].pnb86a = ''
      LET g_pnb[l_ac].pnb87a = 0
    END IF 
 
    IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
      SELECT ima021 INTO g_pnb[l_ac].ima021a FROM ima_file
       WHERE ima01 = g_pnb[l_ac].pnb04a
    END IF
 
    DISPLAY BY NAME g_pnb[l_ac].pnb04a,g_pnb[l_ac].pnb041a,
                    g_pnb[l_ac].ima021a,g_pnb[l_ac].pnb83a,
                    g_pnb[l_ac].pnb85a,g_pnb[l_ac].pnb80a,
                    g_pnb[l_ac].pnb82a,g_pnb[l_ac].pnb86a,
                    g_pnb[l_ac].pnb87a
  ELSE
    SELECT pml04,pml041,pml07,pml20 INTO
           g_pnb[l_ac].pnb04a,g_pnb[l_ac].pnb041a,
           g_pnb[l_ac].pnb07a,g_pnb[l_ac].pnb20a
      FROM pml_file 
     WHERE pml01 = g_pnb[l_ac].pnb90
       AND pml02 = g_pnb[l_ac].pnb91
    IF SQLCA.sqlcode THEN
      LET g_pnb[l_ac].pnb04a = ''
      LET g_pnb[l_ac].pnb041a = ''
      LET g_pnb[l_ac].ima021a = ''
      LET g_pnb[l_ac].pnb07a = ''
      LET g_pnb[l_ac].pnb20a = 0
    END IF 
 
    IF NOT cl_null(g_pnb[l_ac].pnb04a) THEN
      SELECT ima021 INTO g_pnb[l_ac].ima021a FROM ima_file
       WHERE ima01 = g_pnb[l_ac].pnb04a
   END IF
 
    #MOD-BB0334 ----- modify start -----
    #LET l_pml20 = 0
    #LET l_pmn20 = 0
    #SELECT pml20 INTO l_pml20 FROM pml_file
    # WHERE pml01 = g_pnb[l_ac].pnb90
    #   AND pml02 = g_pnb[l_ac].pnb91
    #IF cl_null(l_pml20) THEN LET l_pml20 = 0 END IF
    #SELECT SUM(pmn20*pmn121) INTO l_pmn20 FROM pmn_file
    # WHERE pmn24 = g_pnb[l_ac].pnb90
    #   AND pmn25 = g_pnb[l_ac].pnb91
    #IF cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF
    #LET l_pml09 = 0
    #SELECT pml09 INTO l_pml09 FROM pml_file
    #             WHERE pml01=g_pnb[l_ac].pnb90
    #               AND pml02=g_pnb[l_ac].pnb91
    #IF l_pml09 IS NULL OR l_pml09 = 0 THEN LET l_pml09 = 1 END IF
    #LET l_pmn20 = l_pmn20 / l_pml09
 
    #LET g_pnb[l_ac].pnb20a = l_pml20 - l_pmn20
    LET g_retype = 1
    CALL chk_qty() RETURNING g_pnb[l_ac].pnb20a
    LET g_retype = 0
    #MOD-BB0334 -----  modify end  -----
 
    DISPLAY BY NAME g_pnb[l_ac].pnb04a,g_pnb[l_ac].pnb041a,
                    g_pnb[l_ac].ima021a,g_pnb[l_ac].pnb07a,
                    g_pnb[l_ac].pnb20a
  END IF
 
END FUNCTION
 
FUNCTION t910_pnb91_chk()
   DEFINE l_pml16  LIKE pml_file.pml16,
          l_pml20  LIKE pml_file.pml20,
          l_pml192 LIKE pml_file.pml192,
          l_pmk18  LIKE pmk_file.pmk18,
          l_pmk25  LIKE pmk_file.pmk25,
          l_pmkacti LIKE pmk_file.pmkacti
          ,l_pml190 LIKE pml_file.pml190   #TQC-980279 add       
 
   LET g_errno = " "
   SELECT pml16,pml20,pml190,pmk18,pmk25,pmkacti 
     INTO l_pml16,l_pml20,l_pml190,l_pmk18,l_pmk25,l_pmkacti 
     FROM pml_file,pmk_file
    WHERE pml01 = g_pnb[l_ac].pnb90
      AND pml02 = g_pnb[l_ac].pnb91
      AND pmk01 = pml01
 
   CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'mfg3055'
        WHEN l_pml16 matches'[678]'  LET g_errno = 'mfg3258'
        WHEN l_pml16 = '0'           LET g_errno = 'apm-295' #已開立未確認
        WHEN l_pml16 = '9'           LET g_errno = 'mfg3259' #取消
        WHEN l_pml20 <= 0            LET g_errno = 'apm-201'
        WHEN l_pmk18  ='N'           LET g_errno = 'apm-292' #
        WHEN l_pml190 ='Y'           LET g_errno = 'apm-044' #    #TQC-980279 add
        WHEN l_pmk25 NOT MATCHES '[12]'  LET g_errno = 'apm-293'
        WHEN l_pmkacti='N'           LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION chk_qty()
  DEFINE 
    l_pnb90         LIKE pnb_file.pnb90,
    l_pnb91         LIKE pnb_file.pnb91,
    l_pnb04b        LIKE pnb_file.pnb04b,  
    l_pnb04a        LIKE pnb_file.pnb04a,  
    l_pnb07b        LIKE pnb_file.pnb07b,  
    l_pnb07a        LIKE pnb_file.pnb07a,  
    l_pnb20a        LIKE pnb_file.pnb20a,
    l_item          LIKE pnb_file.pnb04a,  
    l_unit          LIKE pnb_file.pnb07a,  
    l_pml07         LIKE pml_file.pml07,   
    l_old,l_old1,l_new,l_new1,l_new2   LIKE pnb_file.pnb20a,
    l_ima07         LIKE ima_file.ima07,
    l_rate          LIKE sma_file.sma343,
    i               LIKE type_file.num5,   #MOD-8C0196
    l_pmm909        LIKE pmm_file.pmm909   #MOD-920044
DEFINE    l_pnb20b  LIKE pnb_file.pnb20b   #MOD-BB0334 add
DEFINE    l_pnb90a  LIKE pnb_file.pnb90  #MOD-D30186 add
DEFINE    l_pnb91a  LIKE pnb_file.pnb91  #MOD-D30186 add
 
  LET l_pmm909=''
  SELECT pmm909 INTO l_pmm909 FROM pmm_file
    WHERE pmm01 = g_pna.pna01
# IF l_pmm909 = '3' THEN                                                                 #MOD-B60122 mark
  IF (l_pmm909 <> '1' AND l_pmm909 <> '2' AND l_pmm909 <> '8') OR g_pmm02 = 'SUB' THEN   #MOD-B60122 add
     RETURN 'TRUE'
  END IF
 
  LET l_old = 0
  LET l_old1= 0
  LET l_new = 0
  LET l_new1 = 0   
  LET l_new2 = 0   
 
  IF cl_null(g_pnb[l_ac].pnb90) THEN
     LET l_pnb90 = g_pnb[l_ac].pnb90b
  ELSE
     LET l_pnb90 = g_pnb[l_ac].pnb90
  END IF
  IF cl_null(g_pnb[l_ac].pnb91) THEN
     LET l_pnb91 = g_pnb[l_ac].pnb91b
  ELSE
     LET l_pnb91 = g_pnb[l_ac].pnb91
  END IF
 
  SELECT pml07,pml20 INTO l_pml07,l_old FROM pml_file
   WHERE pml01 = l_pnb90
     AND pml02 = l_pnb91
  IF cl_null(l_old) THEN LET l_old = 0 END IF
 
  SELECT SUM(pmn20*pmn121) INTO l_new1 FROM pmn_file  
   WHERE pmn24 = l_pnb90
     AND pmn25 = l_pnb91
     AND pmn16 NOT IN ('6','7','8','9')      
     AND pmn01||pmn02 NOT IN 
         (SELECT pnb01||pnb03 FROM pna_file,pnb_file 
           WHERE pna01 = pnb01 
             AND pna02 = pnb02
             AND pnaconf = 'N')   
  IF cl_null(l_new1) THEN LET l_new1 = 0 END IF 
 
  DECLARE pnb_curs CURSOR FOR 
    #SELECT pnb04b,pnb04a,pnb07b,pnb07a,pnb20a       #MOD-BB0334 mark 
    #SELECT pnb04b,pnb04a,pnb07b,pnb07a,pnb20a,pnb20b #MOD-BB0334 add #MOD-D30186 mark
    SELECT pnb04b,pnb04a,pnb07b,pnb07a,pnb20a,pnb20b,pnb90,pnb91 #MOD-D30186 add
     FROM pna_file,pnb_file
      WHERE pna01 = pnb01 
        AND pna02 = pnb02 
        AND pnaconf = 'N' 
        AND pnb01 = g_pna.pna01 
        AND pnb03 <> g_pnb[l_ac].pnb03
       #MOD-D30186 mark start -----
       #AND pnb90 = l_pnb90   #MOD-8C0196
       #AND pnb91 = l_pnb91   #MOD-8C0196
       #MOD-D30186 mark end   -----
  FOREACH pnb_curs INTO 
    #l_pnb04b,l_pnb04a,l_pnb07b,l_pnb07a,l_pnb20a         #MOD-BB0334 mark
    #l_pnb04b,l_pnb04a,l_pnb07b,l_pnb07a,l_pnb20a,l_pnb20b #MOD-BB0334 add #MOD-D30186 mark
     l_pnb04b,l_pnb04a,l_pnb07b,l_pnb07a,l_pnb20a,l_pnb20b,l_pnb90a,l_pnb91a #vampire add
    #MOD-D30186 add start -----
     IF cl_null(l_pnb90a) THEN
        IF g_pnb[l_ac].pnb90b != l_pnb90a AND g_pnb[l_ac].pnb91b != l_pnb91a THEN
           CONTINUE FOREACH
        END IF
     END IF
    #MOD-D30186 add start -----
    IF cl_null(l_pnb04a) THEN
       LET l_item = l_pnb04b
    ELSE
       LET l_item = l_pnb04a
    END IF
    IF cl_null(l_pnb07a) THEN
       LET l_unit = l_pnb07b
    ELSE
       LEt l_unit = l_pnb07a
    END IF
    CALL s_umfchk(l_item,l_unit,l_pml07)
      RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    #MOD-BB0334 ----- modify start -----
    IF cl_null(l_pnb20a) THEN
       LET l_pnb20a = l_pnb20b * g_factor
    ELSE
    #MOD-BB0334 ----- modify end -----
       LET l_pnb20a = l_pnb20a * g_factor
    END IF #MOD-BB0334 add
    LET l_new2 = l_new2 + l_pnb20a
  END FOREACH
 
  #MOD-BB0334 ----- mark start -----
  #FOR i = 1 TO g_pnb.getLength()
  #    IF g_pnb[i].pnb03 <> g_pnb[l_ac].pnb03 THEN
  #       IF g_pnb[i].pnb90b = l_pnb90 AND g_pnb[i].pnb91b = l_pnb91 THEN
  #          IF cl_null(g_pnb[i].pnb20a)  THEN 
  #             LET l_new2 = l_new2 + g_pnb[i].pnb20b
  #          ELSE
  #             LET l_new2 = l_new2 + g_pnb[i].pnb20a
  #          END IF
  #       END IF
  #    END IF
  #END FOR
  #MOD-BB0334 ----- mark end -----

  IF cl_null(l_new2) THEN LET l_new2 = 0 END IF 
 
  LET l_new = l_new1 + l_new2 
 
  IF cl_null(l_new) THEN LET l_new = 0 END IF
 
  LET l_ima07=' ' LET l_rate=0
  IF cl_null(l_item) THEN
     IF cl_null(g_pnb[l_ac].pnb04a) THEN
        LET l_item = g_pnb[l_ac].pnb04b
     ELSE
        LET l_item = g_pnb[l_ac].pnb04a
     END IF
  END IF
  SELECT ima07 INTO l_ima07 FROM ima_file
   WHERE ima01=l_item
  CASE l_ima07
       WHEN 'A' LET l_rate=g_sma.sma341/100
       WHEN 'B' LET l_rate=g_sma.sma342/100
       WHEN 'C' LET l_rate=g_sma.sma343/100
       OTHERWISE LET l_rate=0
  END CASE
  
  IF cl_null(g_pnb[l_ac].pnb07a) THEN
     LET l_unit = g_pnb[l_ac].pnb07b
  ELSE
     LEt l_unit = g_pnb[l_ac].pnb07a
  END IF
  CALL s_umfchk(l_item,l_unit,l_pml07)
    RETURNING g_cnt,g_factor
  IF g_cnt = 1 THEN
     LET g_factor = 1
  END IF
 #MOD-D30186 mark start -----
 #IF cl_null(g_pnb_t.pnb03) THEN 
 #   CALL s_umfchk(g_pnb[l_ac].pnb04b,g_pnb[l_ac].pnb07b,l_pml07)
 #     RETURNING g_cnt,g_factor2
 #   IF g_cnt = 1 THEN
 #      LET g_factor2 = 1
 #   END IF
 #   LET l_old1 = g_pnb[l_ac].pnb20b * g_factor2
 #END IF 
 #IF cl_null(l_old1) THEN LET l_old1 = 0 END IF
 #MOD-D30186 mark end   -----
  
  IF g_retype = 0 THEN   #MOD-BB0334 add
    #IF g_pnb[l_ac].pnb20a * g_factor > (l_old*(1+l_rate)-l_new)+l_old1 THEN  #MOD-D30186 mark 
     IF g_pnb[l_ac].pnb20a * g_factor > (l_old*(1+l_rate)-l_new) THEN         #MOD-D30186 add 
        RETURN FALSE 
     ELSE
        RETURN TRUE
     END IF
  #MOD-BB0334 ----- modify start -----
  ELSE
    #LET l_pnb20a = ((l_old-l_new)+l_old1)/g_factor #MOD-D30186 mark
     LET l_pnb20a = ((l_old-l_new))/g_factor        #MOD-D30186 add
     IF l_pnb20a < 0 THEN LET l_pnb20a = 0 END IF
     RETURN l_pnb20a
  END IF
  #MOD-BB0334 -----  modify end  -----

END FUNCTION
FUNCTION t910_gettask(l_pna01,l_pnb03) 
   DEFINE l_pna01  LIKE pna_file.pna01,
          l_pnb03  LIKE pnb_file.pnb03,
          l_pmn41  LIKE pmn_file.pmn41,
          l_pmn43  LIKE pmn_file.pmn43,
          l_pmm02  LIKE pmm_file.pmm02,
          l_task   LIKE ecm_file.ecm04,
          l_type   LIKE type_file.chr1
   DEFINE l_pmn012 LIKE pmn_file.pmn012   #No.FUN-A60011
 
   LET l_pmm02=''
   LET l_type=''
   SELECT pmm02 INTO l_pmm02 FROM pmm_file WHERE pmm01=l_pna01
   IF l_pmm02 = 'SUB' THEN
      LET l_type='2'
   ELSE
      LET l_type='1'
   END IF
 
   LET l_pmn41=''
   LET l_pmn43=''
   LET l_task=''
   SELECT pmn41,pmn43,pmn012 INTO l_pmn41,l_pmn43,l_pmn012 FROM pmn_file   #No.FUN-A60011
     WHERE pmn01=l_pna01 AND pmn02=l_pnb03
   SELECT ecm04 INTO l_task FROM ecm_file 
     WHERE ecm01=l_pmn41 AND ecm03=l_pmn43
       AND ecm012=l_pmn012   #No.FUN-A60011
   IF cl_null(l_task) THEN LET l_task = ' ' END IF
 
   RETURN l_task,l_type 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#FUN-910088--add--start--
FUNCTION t910_pnb20a_check(p_newline)
   DEFINE l_pmn65      LIKE pmn_file.pmn65,
          l_pmn50_55   LIKE pmn_file.pmn50,
          l_pml20      LIKE pml_file.pml20,
          l_pml21      LIKE pml_file.pml21,
          l_pml09      LIKE pml_file.pml09,
          l_pmm09      LIKE pmm_file.pmm09,
          l_pmm04      LIKE pmm_file.pmm04,
          l_pmm21      LIKE pmm_file.pmm21,
          l_pmm43      LIKE pmm_file.pmm43,
          l_pna08      LIKE pna_file.pna08,
          l_rate       LIKE sma_file.sma343,
          l_ima07      LIKE ima_file.ima07,
          l_new,l_old  LIKE pnb_file.pnb20a,
          l_rvb07      LIKE rvb_file.rvb07,
          l_task       LIKE ecm_file.ecm04,
          l_i          LIKE type_file.num5,
          l_type       LIKE type_file.chr1,
          p_newline    LIKE type_file.chr1

        
   IF NOT cl_null(g_pnb[l_ac].pnb20a) THEN
      IF NOT cl_null(g_pnb[l_ac].pnb07a) THEN
         LET g_pnb[l_ac].pnb20a = s_digqty(g_pnb[l_ac].pnb20a,g_pnb[l_ac].pnb07a)
      ELSE
        LET g_pnb[l_ac].pnb20a = s_digqty(g_pnb[l_ac].pnb20a,g_pnb[l_ac].pnb07b)
      END IF
      DISPLAY BY NAME g_pnb[l_ac].pnb20a
   END IF
   IF p_newline='Y' AND
      (cl_null(g_pnb[l_ac].pnb20a) OR g_pnb[l_ac].pnb20a <=0 ) THEN
      CALL cl_err('','mfg3331',0)
      RETURN FALSE
   END IF

   LET g_cnt=0
   SELECT COUNT(*) INTO g_cnt
       FROM pmn_file
       WHERE pmn01=g_pna.pna01 AND pmn02=g_pnb[l_ac].pnb03
   IF g_cnt > 0 THEN
   IF NOT cl_null(g_pnb[l_ac].pnb20a)  THEN
      #委外代買時，如果是選擇(1對1),採購變更時代買的數量要卡不能修改
      IF g_pnb[l_ac].pnb20a != g_pnb[l_ac].pnb20b THEN
         SELECT pmn65 INTO l_pmn65 FROM pmn_file
          WHERE pmn01 = g_pna.pna01
            AND pmn02 = g_pnb[l_ac].pnb03
            AND pmn04 = g_pnb[l_ac].pnb04b
         IF l_pmn65 = '2' THEN    #表示是代買料,不可以修改數量
            CALL cl_err(g_pnb[l_ac].pnb04b,'apm-851',0)
            LET g_pnb[l_ac].pnb20a = g_pnb[l_ac].pnb20b
            LET g_pnb[l_ac].pnb20a = s_digqty(g_pnb[l_ac].pnb20a,g_pnb[l_ac].pnb07a)
            DISPLAY BY NAME g_pnb[l_ac].pnb20a
         END IF
      END IF

      IF NOT t910_chk_blanketpo() THEN
         RETURN FALSE
      END IF

      SELECT pmn20 INTO l_pmn50_55 FROM pmn_file
       WHERE pmn01 = g_pna.pna01
         AND pmn02 = g_pnb[l_ac].pnb03

         LET l_pml20 = 0
         LET l_pml21 = 0
         SELECT pml20,pml21 INTO l_pml20,l_pml21 FROM pml_file
          WHERE pml01 = g_pnb[l_ac].pnb90b
            AND pml02 = g_pnb[l_ac].pnb91b
         LET l_pml09 = 0
         SELECT pml09 INTO l_pml09 FROM pml_file
                      WHERE pml01=g_pnb[l_ac].pnb90b
                        AND pml02=g_pnb[l_ac].pnb91b
         IF l_pml09 IS NULL OR l_pml09 = 0 THEN LET l_pml09 = 1 END IF
      
         LET l_ima07=' ' LET l_rate=0
         SELECT ima07 INTO l_ima07 FROM ima_file
          WHERE ima01=g_pnb[l_ac].pnb04b
         CASE l_ima07 
              WHEN 'A' LET l_rate=g_sma.sma341/100
              WHEN 'B' LET l_rate=g_sma.sma342/100
              WHEN 'C' LET l_rate=g_sma.sma343/100
              OTHERWISE LET l_rate=0 
         END CASE
         IF g_sma.sma32='Y' AND g_pmm02 != 'SUB' THEN
               IF NOT chk_qty() THEN
                   CALL cl_err('','mfg3425',1)
                  IF g_sma.sma33='R'THEN
                      RETURN FALSE     
                  END IF
               END IF
         END IF
         #==>不可小於已收貨量(rvb07)(不管是否已確認)
         SELECT SUM(rvb07-rvb29-pmn58) INTO l_rvb07 FROM rvb_file,rva_file,pmn_file #MOD-C80164 add -pmn58、pmn_file
          WHERE rvb01 = rva01
            AND rvaconf != 'X'
            AND rvb04 = g_pna.pna01
            AND rvb03 = g_pnb[l_ac].pnb03
            AND rvb35 = 'N'
            AND rvb04 = pmn01 #MOD-C80164 add
            AND rvb03 = pmn02 #MOD-C80164 add
         IF g_pnb[l_ac].pnb20a < l_rvb07 THEN
             CALL cl_err(l_rvb07,'apm-411',0)
             RETURN FALSE
         END IF
       LET g_change='Y'
    END IF
   END IF
    IF cl_null(g_pnb[l_ac].pnb04b) AND g_sma.sma32='Y' THEN
          LET l_old = 0
          LET l_new = 0
          SELECT pml20 INTO l_old FROM pml_file
           WHERE pml01 = g_pnb[l_ac].pnb90
             AND pml02 = g_pnb[l_ac].pnb91
          IF cl_null(l_old) THEN LET l_old = 0 END IF
   
          SELECT SUM(pmn20*pmn121) INTO l_new FROM pmn_file
           WHERE pmn24 = g_pnb[l_ac].pnb90
             AND pmn25 = g_pnb[l_ac].pnb91
             AND pmn16 NOT IN ('6','7','8','9')
          IF cl_null(l_new) THEN LET l_new = 0 END IF
   
          LET l_pml09 = 0
          SELECT pml09 INTO l_pml09 FROM pml_file
                       WHERE pml01=g_pnb[l_ac].pnb90
                         AND pml02=g_pnb[l_ac].pnb91
          IF l_pml09 IS NULL OR l_pml09 = 0 THEN LET l_pml09 = 1 END IF
          LET l_new = l_new / l_pml09
   
          LET l_ima07=' ' LET l_rate=0
          SELECT ima07 INTO l_ima07 FROM ima_file
           WHERE ima01=g_pnb[l_ac].pnb04a
          CASE l_ima07
               WHEN 'A' LET l_rate=g_sma.sma341/100
               WHEN 'B' LET l_rate=g_sma.sma342/100
               WHEN 'C' LET l_rate=g_sma.sma343/100
               OTHERWISE LET l_rate=0
          END CASE
   
          IF NOT chk_qty() THEN
            CALL cl_err('','apm-403',1)
            IF g_sma.sma33='R' THEN
              RETURN FALSE
            END IF
          END IF
    END IF
     IF g_change = 'Y' THEN
        CALL t910_set_pnb87a()
        SELECT pmm09,pmm04,pmm21,pmm43
         INTO l_pmm09,l_pmm04,l_pmm21,l_pmm43 FROM pmm_file
        WHERE pmm01 = g_pna.pna01
        IF cl_null(g_pna.pna08b) THEN
           LET l_pna08 = g_pna.pna08
        END IF
        IF cl_null(g_pnb[l_ac].pnb04a) THEN
           LET g_pnb[l_ac].pnb04a = g_pnb[l_ac].pnb04b
        END IF
        IF cl_null(g_pnb[l_ac].pnb87a)  THEN
           LET g_pnb[l_ac].pnb87a = g_pnb[l_ac].pnb87b
           LET g_pnb[l_ac].pnb87a = s_digqty(g_pnb[l_ac].pnb87a,g_pnb[l_ac].pnb86a)
        END IF 
        IF cl_null(g_pna.pna09b) THEN
           LET g_term = g_pna.pna09
        ELSE
           LET g_term = g_pna.pna09b
        END IF
        IF cl_null(g_pna.pna10b) THEN
           LET g_price = g_pna.pna10
        ELSE
           LET g_price = g_pna.pna10b
        END IF
        IF cl_null(g_pnb[l_ac].pnb86a) THEN
           LET g_pnb86 = g_pnb[l_ac].pnb86b
        ELSE
           LET g_pnb86 = g_pnb[l_ac].pnb86a
        END IF     
        LET l_i = 0
        SELECT COUNT(*) INTO l_i FROM pmn_file
         WHERE pmn01 = g_pna.pna01
           AND pmn02 = g_pnb[l_ac].pnb03
        IF l_i <=0 THEN  
           #CALL s_defprice_new(g_pnb[l_ac].pnb04a,l_pmm09,l_pna08,l_pmm04,    #MOD-C30904 mark
           CALL s_defprice_new(g_pnb[l_ac].pnb04a,l_pmm09,l_pna08,g_pna.pna04, #MOD-C30904 add
                           #g_pnb[l_ac].pnb87b,l_task,l_pmm43,l_pmm21,l_type,g_pnb86,'',g_term,g_price,g_plant)
                            g_pnb[l_ac].pnb87b,l_task,l_pmm21,l_pmm43,l_type,g_pnb86,'',g_term,g_price,g_plant) #MOD-BA0204 add
            RETURNING g_pnb[l_ac].pnb31a,g_pnb[l_ac].pnb32a,
                   g_pmn73,g_pmn74
        END IF
        IF cl_null(g_pmn73) THEN LET g_pmn73 = '4' END IF
     END IF
     IF g_sma.sma54='Y' THEN #是否使用製程
        CALL t910_upd_ecm('b')
        IF NOT cl_null(g_error) THEN
           RETURN FALSE
        END IF
     END IF 
     RETURN TRUE
END FUNCTION

FUNCTION t910_pnb82a_check()
   DEFINE p_cmd        LIKE type_file.chr1,
          l_newline    LIKE type_file.chr1
   IF NOT cl_null(g_pnb[l_ac].pnb82a) THEN
      IF NOT cl_null(g_pnb[l_ac].pnb80a) THEN
         LET g_pnb[l_ac].pnb82a = s_digqty(g_pnb[l_ac].pnb82a,g_pnb[l_ac].pnb80a)
      ELSE
         LET g_pnb[l_ac].pnb82a = s_digqty(g_pnb[l_ac].pnb82a,g_pnb[l_ac].pnb80b)
      END IF
      DISPLAY BY NAME g_pnb[l_ac].pnb82a
   END IF
   IF cl_null(g_pnb[l_ac].pnb82b) AND NOT cl_null(g_pnb[l_ac].pnb82a) OR
       g_pnb[l_ac].pnb82b<>g_pnb[l_ac].pnb82a THEN
       LET g_change = 'Y'
   END IF
   IF NOT cl_null(g_pnb[l_ac].pnb82a) THEN
      IF g_pnb[l_ac].pnb82a < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN "pnb82a"
      END IF
   END IF
   #計算pnb20,pnb07的值,檢查數量的合理性
    CALL t910_set_origin_field()
    CALL t910_check_inventory_qty(p_cmd,l_newline)
        RETURNING g_flag
    IF g_flag = '1' THEN
       IF g_ima906 = '3' OR g_ima906 = '2' THEN
          RETURN "pnb85a"
       ELSE
          RETURN "pnb82a"
       END IF
    END IF
    IF g_flag = '2' THEN
       IF g_ima906 = '3' OR g_ima906 = '2' THEN
          RETURN "pnb83a"
       ELSE
          RETURN "pnb80a"
       END IF
    END IF
    IF g_flag = '3' THEN
       RETURN "pnb33a"
    END IF
    
    IF NOT t910_chk_blanketpo() THEN 
       IF g_ima906 = '3' OR g_ima906 = '2' THEN
          RETURN "pnb85a"
       ELSE
          RETURN "pnb82a"
       END IF
    END IF
    
    IF g_change = 'Y' THEN
       CALL t910_set_pnb87a()
    END IF
    IF g_sma.sma54='Y' THEN #是否使用製程
       CALL t910_upd_ecm('b')
       IF NOT cl_null(g_error) THEN
          IF g_ima906 = '3' OR g_ima906 = '2' THEN
             RETURN "pnb85a"
          ELSE
             RETURN "pnb82a"
          END IF
       END IF
    END IF
    CALL cl_show_fld_cont()
    RETURN ""
END FUNCTION

FUNCTION t910_pnb85a_check(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_pnb[l_ac].pnb85a) THEN
      IF NOT cl_null(g_pnb[l_ac].pnb83a) THEN
         LET g_pnb[l_ac].pnb85a = s_digqty(g_pnb[l_ac].pnb85a,g_pnb[l_ac].pnb83a)
      ELSE
         LET g_pnb[l_ac].pnb85a = s_digqty(g_pnb[l_ac].pnb85a,g_pnb[l_ac].pnb83b)
      END IF
      DISPLAY BY NAME g_pnb[l_ac].pnb85a
   END IF
   IF cl_null(g_pnb[l_ac].pnb85b) AND NOT cl_null(g_pnb[l_ac].pnb85a) OR
       g_pnb[l_ac].pnb85b<>g_pnb[l_ac].pnb85a THEN
       LET g_change = 'Y'
   END IF
   IF NOT cl_null(g_pnb[l_ac].pnb85a) THEN
      IF g_pnb[l_ac].pnb85a < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN FALSE
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_pnb_t.pnb85a <> g_pnb[l_ac].pnb85a THEN
         IF g_ima906='3' THEN
            LET g_pnb84 = g_pnb[l_ac].pnb84b
            LET g_pnb85 = g_pnb[l_ac].pnb85b
            LET g_pnb81 = g_pnb[l_ac].pnb81b
            IF NOT cl_null(g_pnb[l_ac].pnb84a) THEN
               LET g_pnb84 = g_pnb[l_ac].pnb84a
            END IF
            IF NOT cl_null(g_pnb[l_ac].pnb85a) THEN
               LET g_pnb85 = g_pnb[l_ac].pnb85a
            END IF
            IF NOT cl_null(g_pnb[l_ac].pnb81a) THEN
               LET g_pnb81 = g_pnb[l_ac].pnb81a
            END IF
            LET g_tot=g_pnb85*g_pnb84
           IF cl_null(g_pnb[l_ac].pnb82a) OR g_pnb[l_ac].pnb82a=0 THEN
               LET g_pnb[l_ac].pnb82a=g_tot*g_pnb81
               LET g_pnb[l_ac].pnb82a = s_digqty(g_pnb[l_ac].pnb82a,g_pnb[l_ac].pnb80a)
               DISPLAY BY NAME g_pnb[l_ac].pnb82a
            END IF
         END IF
      END IF
   END IF
   IF g_change = 'Y' THEN
      CALL t910_set_pnb87a()
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION

FUNCTION t910_pnb87a_check()
   DEFINE l_pmn65 LIKE pmn_file.pmn65,
          l_rvb87 LIKE rvb_file.rvb87
   IF NOT cl_null(g_pnb[l_ac].pnb87a) THEN
      IF NOT cl_null(g_pnb[l_ac].pnb86a) THEN
         LET g_pnb[l_ac].pnb87a = s_digqty(g_pnb[l_ac].pnb87a,g_pnb[l_ac].pnb86a)
      ELSE
         LET g_pnb[l_ac].pnb87a = s_digqty(g_pnb[l_ac].pnb87a,g_pnb[l_ac].pnb86b)
      END IF
      DISPLAY BY NAME g_pnb[l_ac].pnb87a
   END IF
   IF NOT cl_null(g_pnb[l_ac].pnb87a) THEN
       #委外代買時，如果是選擇(1對1),採購變更時代買的數量要卡不能修改
       IF g_pnb[l_ac].pnb87a != g_pnb[l_ac].pnb87b THEN
          SELECT pmn65 INTO l_pmn65 FROM pmn_file
           WHERE pmn01 = g_pna.pna01
             AND pmn02 = g_pnb[l_ac].pnb03
             AND pmn04 = g_pnb[l_ac].pnb04b
           LET l_rvb87 = 0
           SELECT SUM(rvb87) INTO l_rvb87 FROM rvb_file,rva_file
              WHERE rvb01 = rva01
                AND rvaconf != 'X'
                AND rvb04 = g_pna.pna01
                AND rvb03 = g_pnb[l_ac].pnb03
      
           IF cl_null(l_rvb87) THEN LET l_rvb87 = 0 END IF
   
           IF g_pnb[l_ac].pnb87a < l_rvb87 THEN
              CALL cl_err('','apm-097',0)
              RETURN FALSE
           END IF
          IF l_pmn65 = '2' THEN
             CALL cl_err(g_pnb[l_ac].pnb04b,'apm-851',0)
             LET g_pnb[l_ac].pnb87a = g_pnb[l_ac].pnb87b
             DISPLAY BY NAME g_pnb[l_ac].pnb87a
          END IF
       END IF
   END IF
   IF cl_null(g_pnb[l_ac].pnb87b) AND NOT cl_null(g_pnb[l_ac].pnb87a) OR
       g_pnb[l_ac].pnb87b<>g_pnb[l_ac].pnb87a THEN
       LET g_change = 'Y'
   END IF 
   IF NOT cl_null(g_pnb[l_ac].pnb87a) THEN
      IF g_pnb[l_ac].pnb87a < 0 THEN
         CALL cl_err('','aim-391',0)   
         RETURN FALSE     
      END IF
   END IF 
   RETURN TRUE
END FUNCTION 
#FUN-910088--add--end--

#MOD-D10206 add start -----
FUNCTION t910_check_price()
DEFINE  l_pna09     LIKE pna_file.pna09
DEFINE  l_pnz04     LIKE pnz_file.pnz04
DEFINE  l_pnz07     LIKE pnz_file.pnz07
DEFINE  l_pnb04     LIKE pnb_file.pnb04a
DEFINE  l_pnb31     LIKE pnb_file.pnb31a
DEFINE  l_pnb32     LIKE pnb_file.pnb32a

   IF cl_null(g_pna.pna09b) THEN
      LET l_pna09 = g_pna.pna09
   ELSE
      LET l_pna09 = g_pna.pna09b
   END IF

   SELECT pnz04,pnz07 INTO l_pnz04,l_pnz07 FROM pnz_file
    WHERE pnz01 = l_pna09
   IF SQLCA.sqlcode THEN
      CALL cl_err( 'sel pnz04,pnz07' , SQLCA.sqlcode,0)
      RETURN
   END IF

   IF cl_null(g_pnb[l_ac].pnb04a) THEN
      LET l_pnb04 = g_pnb[l_ac].pnb04b
   ELSE
      LET l_pnb04 = g_pnb[l_ac].pnb04a
   END IF

   IF l_pnb04[1,4] = 'MISC' AND NOT cl_null(l_pnb04) THEN
      IF g_gec07 = 'Y' THEN   #含稅
         CALL cl_set_comp_entry("pnb31a",FALSE)
         CALL cl_set_comp_entry("pnb32a",TRUE)
         LET g_chkpnb31_flag = 'N'
         LET g_chkpnb32_flag = 'Y'
      ELSE
         CALL cl_set_comp_entry("pnb31a",TRUE)
         CALL cl_set_comp_entry("pnb32a",FALSE)
         LET g_chkpnb31_flag = 'Y'
         LET g_chkpnb32_flag = 'N'
      END IF
      RETURN
   END IF

   IF cl_null(g_pnb[l_ac].pnb31a) THEN
      LET l_pnb31 = g_pnb[l_ac].pnb31b
   ELSE
      LET l_pnb31 = g_pnb[l_ac].pnb31a
   END IF

   IF cl_null(g_pnb[l_ac].pnb32a) THEN
      LET l_pnb32 = g_pnb[l_ac].pnb32b
   ELSE
      LET l_pnb32 = g_pnb[l_ac].pnb32a
   END IF

   IF g_gec07 = 'Y' THEN   #含稅
      IF l_pnb32 = 0 OR cl_null(l_pnb32) THEN
         #未取到含稅單價
         IF l_pnz04 = 'Y' THEN #未取到單價可人工輸入
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",TRUE)
            LET g_chkpnb31_flag = 'N'
            LET g_chkpnb32_flag = 'Y'
         ELSE
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
            LET g_chkpnb31_flag = 'N'
            LET g_chkpnb32_flag = 'N'
         END IF
      ELSE
         #有取到含稅單價
         IF l_pnz07 = 'Y' THEN   #取到價格可修改
            CALL cl_set_comp_entry("pnb31a",FALSE)
            CALL cl_set_comp_entry("pnb32a",TRUE)
            LET g_chkpnb31_flag = 'N'
            LET g_chkpnb32_flag = 'Y'
         ELSE
            CALL cl_set_comp_entry("pnb31a",FALSE)
            CALL cl_set_comp_entry("pnb32a",FALSE)
            LET g_chkpnb31_flag = 'N'
            LET g_chkpnb32_flag = 'N'
         END IF
      END IF
   ELSE                    #不含稅
      IF l_pnb31 = 0 OR cl_null(l_pnb31) THEN
         #未取到稅前單價
         IF l_pnz04 = 'Y' THEN   #未取到單價可人工輸入
            CALL cl_set_comp_entry("pnb31a",TRUE)
            CALL cl_set_comp_entry("pnb32a",FALSE)
            LET g_chkpnb31_flag = 'Y'
            LET g_chkpnb32_flag = 'N'
         ELSE
            CALL cl_set_comp_entry("pnb31a",FALSE)
            CALL cl_set_comp_entry("pnb32a",FALSE)
            LET g_chkpnb31_flag = 'N'
            LET g_chkpnb32_flag = 'N'
         END IF
      ELSE
         #有取到稅前單價
         IF l_pnz07 = 'Y' THEN   #取到價格可修改
            CALL cl_set_comp_entry("pnb31a",TRUE)
            CALL cl_set_comp_entry("pnb32a",FALSE)
            LET g_chkpnb31_flag = 'Y'
            LET g_chkpnb32_flag = 'N'
         ELSE
            CALL cl_set_comp_entry("pnb31a",FALSE)
            CALL cl_set_comp_entry("pnb32a",FALSE)
            LET g_chkpnb31_flag = 'N'
            LET g_chkpnb32_flag = 'N'
         END IF
      END IF
   END IF
END FUNCTION
#MOD-D10206 add end   -----

#CHI-CB0002------add------S
FUNCTION t901_bud(p_pna01,p_pna02,p_pnb03)
   DEFINE p_pna01      LIKE pna_file.pna01
   DEFINE p_pna02      LIKE pna_file.pna02
   DEFINE p_pnb03      LIKE pnb_file.pnb03
   DEFINE l_pmm04      LIKE pmm_file.pmm04
   DEFINE l_pmm42      LIKE pmm_file.pmm42
   DEFINE l_pna        RECORD LIKE pna_file.*
   DEFINE l_pnb        RECORD LIKE pnb_file.*
   DEFINE l_pmm        RECORD LIKE pmm_file.*
   DEFINE l_pmn        RECORD LIKE pmn_file.*
   DEFINE l_tmp     RECORD
                       flag   LIKE type_file.chr1,   #a:變更後 b:變更前
                       pna01  LIKE pna_file.pna01,   #採購單號
                       pna02  LIKE pna_file.pna02,   #序號
                       pnb03  LIKE pnb_file.pnb03,   #項次
                       pmm42  LIKE pmm_file.pmm42,   #匯率
                       pnb87  LIKE pnb_file.pnb87a,  #數量
                       pnb31  LIKE pnb_file.pnb31a,  #未稅單價
                       pmn98  LIKE pmn_file.pmn98,   #費用原因
                       pmn40  LIKE pmn_file.pmn40,   #會計科目
                       pmm31  LIKE pmm_file.pmm31,   #會計年度
                       pnb35  LIKE pnb_file.pnb35a,  #WBS 
                       pmn67  LIKE pmn_file.pmn67,   #部門編號
                       pnb34  LIKE pnb_file.pnb34a,  #專案代號
                       pmm32  LIKE pmm_file.pmm32    #會計期間
                    END RECORD
   DEFINE p_sum1       LIKE afc_file.afc06
   DEFINE p_sum2       LIKE afc_file.afc06
   DEFINE l_cmd        LIKE type_file.chr1
   DEFINE l_pnb34      LIKE pnb_file.pnb34a
   DEFINE l_pnb35      LIKE pnb_file.pnb35a
   DEFINE l_pnb87      LIKE pnb_file.pnb87a
   DEFINE l_pnb31      LIKE pnb_file.pnb31a
   DEFINE l_pnb03      LIKE pnb_file.pnb03
   DEFINE l_afb07      LIKE afb_file.afb07
   DEFINE l_flag       LIKE type_file.num5
   DEFINE l_msg        LIKE ze_file.ze03
   DEFINE l_over       LIKE afc_file.afc07
   DEFINE bamt1        LIKE afc_file.afc07
   DEFINE bamt2        LIKE afc_file.afc07
   DEFINE bamt3        LIKE afc_file.afc07
   DEFINE bamt4        LIKE afc_file.afc07
   DEFINE bamt5        LIKE afc_file.afc07
   DEFINE bamt6        LIKE afc_file.afc07
   
   WHENEVER ERROR CALL cl_err_msg_log
   DROP TABLE tmp_file
   CREATE TEMP TABLE tmp_file(
         flag   LIKE type_file.chr1,   #a:變更後 b:變更前
         pna01  LIKE pna_file.pna01,   #採購單號
         pna02  LIKE pna_file.pna02,   #序號
         pnb03  LIKE pnb_file.pnb03,   #項次
         pmm42  LIKE pmm_file.pmm42,   #匯率
         pnb87  LIKE pnb_file.pnb87a,  #數量
         pnb31  LIKE pnb_file.pnb31a,  #未稅單價
         pmn98  LIKE pmn_file.pmn98,   #費用原因
         pmn40  LIKE pmn_file.pmn40,   #會計科目
         pmm31  LIKE pmm_file.pmm31,   #會計年度
         pnb35  LIKE pnb_file.pnb35a,  #WBS 
         pmn67  LIKE pmn_file.pmn67,   #部門編號
         pnb34  LIKE pnb_file.pnb34a,  #專案代號
         pmm32  LIKE pmm_file.pmm32)   #會計期間
   DELETE FROM  tmp_file
   
   LET g_errno = ''
   SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01 = p_pna01
   
   CALL s_get_bookno(YEAR(l_pmm.pmm04))        #帳套
        RETURNING g_flag,g_bookno1,g_bookno2

   SELECT * INTO l_pna.* FROM pna_file WHERE pna01 = p_pna01 AND pna02 = p_pna02
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pna01',p_pna01,'SEL pna_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   INITIALIZE l_pnb.* TO NULL
   INITIALIZE l_pmn.* TO NULL
   #將每筆項次變更前後的資料，儲存至tmp_table中
   DECLARE t900sub_pnb_instmp_cs CURSOR FOR
    SELECT pnb_file.*
      FROM pnb_file,pna_file
     WHERE pnb01 = l_pna.pna01
       AND pnb02 = l_pna.pna02
       AND pnb01 = pna01
       AND pnb02 = pna02
       AND pna05 = 'N'
   FOREACH t900sub_pnb_instmp_cs INTO l_pnb.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','t900sub_pnb_instmp_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF

      SELECT * INTO l_pmn.* FROM pmn_file WHERE pmn01 = l_pna.pna01 AND pmn02 = l_pnb.pnb03
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pnb03',l_pnb.pnb03,'SEL pmn_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF

      #操作
      IF l_pnb.pnb35b <> l_pnb.pnb35a OR
         l_pnb.pnb34b <> l_pnb.pnb34b THEN
         LET l_cmd = 'a'
      ELSE
         LET l_cmd = 'u'
      END IF

      #匯率
      IF NOT cl_null(l_pna.pna08b) THEN
         IF g_aza.aza17 = l_pna.pna09b THEN   #本幣
            LET l_pmm42 = 1
         ELSE
            CALL s_curr3(l_pna.pna08b,l_pmm.pmm04,g_sma.sma904)
                 RETURNING l_pmm42
         END IF
      ELSE
         LET l_pmm42 = l_pmm.pmm42
      END IF

      #WBS
       IF NOT cl_null(l_pnb.pnb35a) THEN
          LET l_pnb35 = l_pnb.pnb35a
       ELSE
          LET l_pnb35 = l_pnb.pnb35b
       END IF

       #專案代號
       IF NOT cl_null(l_pnb.pnb34a) THEN
          LET l_pnb34 = l_pnb.pnb34a
       ELSE
          LET l_pnb34 = l_pnb.pnb34b
       END IF

      #數量
       IF NOT cl_null(l_pnb.pnb87a) THEN
          LET l_pnb87 = l_pnb.pnb87a
       ELSE
          LET l_pnb87 = l_pnb.pnb87b
       END IF

      #未稅單價
       IF NOT cl_null(l_pnb.pnb31a) THEN
          LET l_pnb31 = l_pnb.pnb31a
       ELSE
          LET l_pnb31 = l_pnb.pnb31b
       END IF

      INSERT INTO tmp_file VALUES('b',l_pna.pna01,l_pna.pna02,l_pnb.pnb03,l_pmm.pmm42,l_pnb.pnb87b,l_pnb.pnb31b,  #變更前
                                     l_pmn.pmn98,l_pmn.pmn40,l_pmm.pmm31,l_pnb.pnb35b,l_pmn.pmn67,
                                     l_pnb.pnb34b,l_pmm.pmm32)
      INSERT INTO tmp_file VALUES('a',l_pnb.pnb01,l_pnb.pnb02,l_pnb.pnb03,l_pmm42,l_pnb87,l_pnb31,  #變更後
                                     l_pmn.pmn98,l_pmn.pmn40,l_pmm.pmm31,l_pnb35,l_pmn.pmn67,
                                     l_pnb34,l_pmm.pmm32)
   END FOREACH

  DECLARE t900sub_pnb_seltmp_cs CURSOR FOR
    SELECT * FROM tmp_file
     WHERE pna01 = l_pna.pna01
       AND pna02 = l_pna.pna02
       AND pnb03 = p_pnb03
       AND flag = 'a'
   FOREACH t900sub_pnb_seltmp_cs INTO l_tmp.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','t900sub_pnb_seltmp_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF

      #變更前
       SELECT SUM(pnb87 * pnb31 *pmm42) INTO p_sum1
         FROM tmp_file
        WHERE flag = 'b'
          AND pna01 = l_tmp.pna01
          AND pna02 = l_tmp.pna02
          AND pnb35 = l_tmp.pnb35
          AND pnb34 = l_tmp.pnb34
          AND pmn98 = l_tmp.pmn98
          AND pmn40 = l_tmp.pmn40
          AND pmm32 = l_tmp.pmm32
         GROUP BY pnb34,pnb35,pmn98,pmn40,pmn67,pmm32

      #變更後
       SELECT SUM(pnb87 * pnb31 *pmm42) INTO p_sum2
         FROM tmp_file
        WHERE flag = 'a'
          AND pna01 = l_tmp.pna01
          AND pna02 = l_tmp.pna02
          AND pnb35 = l_tmp.pnb35
          AND pnb34 = l_tmp.pnb34
          AND pmn98 = l_tmp.pmn98
          AND pmn40 = l_tmp.pmn40
          AND pmm32 = l_tmp.pmm32
         GROUP BY pnb34,pnb35,pmn98,pmn40,pmn67,pmm32

         IF g_aaz.aaz90 = 'Y' THEN
             CALL s_budamt1(g_bookno1,l_tmp.pmn98,l_tmp.pmn40,
                            l_tmp.pmm31,l_tmp.pnb35,
                            l_pmn.pmn930,l_tmp.pnb34,
                            l_tmp.pmm32,'0')
                  RETURNING bamt1,bamt2,bamt3,bamt4,bamt5,bamt6
         ELSE
             CALL s_budamt1(g_bookno1,l_tmp.pmn98,l_tmp.pmn40,
                            l_tmp.pmm31,l_tmp.pnb35,
                            l_tmp.pmn67,l_tmp.pnb34,
                            l_tmp.pmm32,'0')
                  RETURNING bamt1,bamt2,bamt3,bamt4,bamt5,bamt6
         END IF
         IF cl_null(bamt1) THEN LET bamt1 = 0 END IF

      IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
      IF cl_null(p_sum2) THEN LET p_sum2 = 0 END IF

     IF g_aaz.aaz90='Y' THEN
        CALL s_budchk1(g_bookno1,l_tmp.pmn98,l_tmp.pmn40,
                       l_tmp.pmm31,l_tmp.pnb35,
                       l_pmn.pmn930,l_tmp.pnb34,
                       l_tmp.pmm32,'0',l_cmd,p_sum1,p_sum2)
             RETURNING l_flag,l_afb07,l_over
        IF l_flag = FALSE THEN
           LET l_msg = g_bookno1,'/',l_tmp.pmn98,'/',l_tmp.pmn40,'/',
                       l_tmp.pmm31,'/',l_tmp.pnb35,'/',
                       l_pmn.pmn930,'/',l_tmp.pnb34,'/',
                       l_tmp.pmm32,'/',l_over
           CALL s_errmsg('pnb03',l_tmp.pnb03,l_msg,g_errno,1)
           LET g_success = 'N'
        ELSE
           IF l_afb07 = '2' AND l_over < 0 THEN
           LET l_msg = g_bookno1,'/',l_tmp.pmn98,'/',l_tmp.pmn40,'/',
                       l_tmp.pmm31,'/',l_tmp.pnb35,'/',
                       l_pmn.pmn930,'/',l_tmp.pnb34,'/',
                       l_tmp.pmm32,'/',l_over
              CALL s_errmsg('pnb03',l_tmp.pnb03,l_msg,g_errno,1)
              LET g_errno =' '
           END IF
        END IF
     ELSE
        CALL s_budchk1(g_bookno1,l_tmp.pmn98,l_tmp.pmn40,
                       l_tmp.pmm31,l_tmp.pnb35,
                       l_tmp.pmn67,l_tmp.pnb34,
                       l_tmp.pmm32,'0',l_cmd,p_sum1,p_sum2)
             RETURNING l_flag,l_afb07,l_over
        IF l_flag = FALSE THEN
           LET l_msg = g_bookno1,'/',l_tmp.pmn98,'/',l_tmp.pmn40,'/',
                       l_tmp.pmm31,'/',l_tmp.pnb35,'/',
                       l_tmp.pmn67,'/',l_tmp.pnb34,'/',
                       l_tmp.pmm32,'/',l_over
           CALL s_errmsg('pnb03',l_tmp.pnb03,l_msg,g_errno,1)
           LET g_success = 'N'
        ELSE
           IF l_afb07 = '2' AND l_over < 0 THEN
           LET l_msg = g_bookno1,'/',l_tmp.pmn98,'/',l_tmp.pmn40,'/',
                       l_tmp.pmm31,'/',l_tmp.pnb35,'/',
                       l_tmp.pmn67,'/',l_tmp.pnb34,'/',
                       l_tmp.pmm32,'/',l_over
              CALL s_errmsg('pnb03',l_tmp.pnb03,l_msg,g_errno,1)
              LET g_errno =' '
           END IF
        END IF
     END IF
   END FOREACH

END FUNCTION
#CHI-CB0002------add------E


