# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: s_fsgl.4gl
# Descriptions...: 分錄底稿維護作業
# Date & Author..: 96/07/10 By Lynn
# Modify.........: 97/05/12 By Danny 新增項次時,預設前一筆資料, 且不可修改,
#                                    且輸入原幣金額後,自動算出本幣金額
# Modify.........: 98/11/03 By Sophia 缺少固定資產系統
# Modify.........: No.9057 04/01/28 Kammy 加 show 固定資產利息資本化類別
# Modify.........: No:A099 04/06/29 Danny  for大陸版 加13.減值準備
# Modify.........: No.MOD-440244 04/09/16 By Nicola 部門編號開窗剔除非會計部門
# Modify.........: No.MOD-4A0111 04/10/11 By Kitty  異動碼CONTROLP按enter值未帶回
# Modify.........: No.MOD-4A0294 04/10/21 By Nicola 預算欄位空白要next field
# Modify.........: No.MOD-4A0347 04/11/09 By Nicola 刪除資料後，重算借貸資料
# Modify.........: No.FUN-4B0071 04/11/25 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0031 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.MOD-510119 05/03/07 By Kitty 科目不作部門管理, 但是卻有部門代號), 無法更正
#                  錯誤, 換言之, 無法移到該欄位清除部門(畫面上看不到, 但只要移動上下鍵又出現了
# Modify.........: No.MOD-530674 05/03/28 By Nicola 系統別為'LC'時，無法開窗查詢客戶編號
# Modify.........: No.MOD-530812 05/03/31 By Smapmin 異動處理除出售以外分錄底稿不應檢查客戶廠商欄位一定要輸入才能離開
# Modify.........: No.MOD-530748 05/04/22 By Nicola 2.借方類別9或貸方類別9屬AP付抵的分錄底稿客戶廠商欄位應檢查廠商基本檔系統目前檢查occ_file
# Modify.........: No.MOD-550100 05/06/01 By ching fix其它銀存異動廠商輸入問題
# Modify.........: No.MOD-550169 05/06/06 By ching display cnt
# Modify.........: No.MOD-570379 05/08/03 By Smapmin 修正預算欄位進入與否
# Modify.........: No.MOD-5B0256 05/11/21 By Smapmin 異動碼欄位上下移動時,控管有問題
# Modify.........: No.MOD-5B0205 05/11/23 By Smapmin 科目為空白時,卻要求輸入部門欄位
# Modify.........: No.FUN-5C0015 05/12/16 BY GILL 異動碼改為十個欄位
# Modify.........: No.FUN-5B0097 06/01/19 By Sarah 將欄位順序移動跟傳票單身位置一樣
# Modify.........: No.MOD-620020 06/02/10 By Smapmin 預算卡關加入是否作部門管理的控管
# Modify.........: No.FUN-5C0015 06/02/14 BY GILL 用s_ahe_qry取代q_aee
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.MOD-640093 06/04/09 By Smapmin 摘要開窗有誤
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充5碼
# Modify.........: No.FUN-670080 06/08/01 By Sarah agli142直接CALL s_fsgl.per(nppsys='CC')
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-660165 06/08/15 By Sarah afai104,afai501直接CALL s_fsgl.per(nppsys='FA')
# Modify.........: No.FUN-670047 06/08/16 By Rayven 新增使用多帳套功能
# Modify.........: No.FUN-680147 06/09/15 By czl     欄位型態定義,改為LIKE
# Modify.........: No.FUN-690134 06/10/14 By Sarah apyi107直接CALL s_fsgl.per(nppsys='PY')
# Modify.........: No.MOD-680003 06/10/18 By Smapmin 修正欄位輸入否的判斷
# Modify.........: No.FUN-6A0079 06/10/23 By Czl g_no_ask改成mi_no_ask
# Modify.........: No.CHI-6A0004 06/11/06 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6B0033 06/11/15 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0047 06/11/16 By Sarah 執行anmt930，按下"撥出分錄底稿維護"時，程式會整個離開
# Modify.........: No.TQC-6C0071 06/12/13 By Ray axci100拋轉憑証后,會計年度,期別未顯示
# Modify.........: No.MOD-6C0091 06/12/15 By Smapmin 上下筆index有誤
# Modify.........: No.MOD-6C0188 06/12/29 By Smapmin BEFORE INPUT不做entry的判斷
# Modify.........: No.MOD-710153 07/01/25 By Smapmin 輸入原幣金額後自動計算本幣金額
# Modify.........: No.FUN-720003 07/02/07 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.FUN-730070 07/03/30 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-740042 07/04/09 By bnlent 用年度取帳套
# Modify.........: No.MOD-740102 07/04/25 By rainy 異動碼沒輸入的錯誤訊息應馬上show出，不應於匯總時再show
# Modify.........: No.MOD-750019 07/05/07 By Carol 自動賦予簽核等級時應預設為總帳DB所在的簽核等級
# Modify.........: No.MOD-750137 07/05/30 By Smapmin 匯率/原幣金額有變動後才自動計算本幣金額
# Modify.........: No.MOD-760129 07/06/28 By Smapmin 拋轉傳票程式應依異動碼做group的動作再放到傳票單身
# Modify.........: No.TQC-770048 07/07/10 By wujie   取消打印和匯出excel按鈕的功能，因為程序中沒有使用
# Modify.........: No.MOD-770076 07/07/18 By Smapmin 修改取位問題
# Modify.........: No.FUN-770086 07/07/27 By kim 合併報表功能
# Modify.........: No.MOD-770101 07/08/07 By Smapmin 需簽核單別不可自動確認
# Modify.........: No.FUN-780068 07/08/28 By Sarah 1.科目名稱抓取錯誤(因帳別抓錯)
#                                                  2.增加nppsys="CD"(合併報表),npptype="1"(長期投資認列)
# Modify.........: No.MOD-7A0004 07/10/04 By Dido 零用金為 gen_file,增加此檢核
# Modify.........: No.MOD-7A0078 07/10/16 By Smapmin AP系統,廠商為EMPL時,廠商簡稱不需重帶
# Modify.........: No.MOD-7A0089 07/10/17 By Smapmin 重新過單
# Modify.........: No.TQC-7B0006 07/11/01 By Smapmin AP-13/17類帳款npq21應開員工編號的窗
# Modify.........: No.MOD-7B0129 07/11/14 By Smapmin 固資直接呼叫分錄單身的時候,帳別未給值
# Modify.........: No.MOD-7B0147 07/11/15 By Smapmin AP-1類/AR-2類為搭配多角的控管,離開分錄時必須確保借貸平衡
# Modify.........: No.MOD-7B0004 07/11/15 By claire 人事模組的拋轉傳票以人事參數設定總帳營運中心別為主
# Modify.........: No.TQC-7B0104 07/11/16 By chenl  增加NM下，對零用金gen_file的判斷
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-810082 08/01/31 By Smapmin 分錄增加部門名稱欄位
# Modify.........: No.MOD-820033 08/02/13 By Carolo  人事直接呼叫分錄單身的時候,帳別未給值
# Modify.........: No.TQC-820005 08/02/13 By Smapmin 分錄類別為'CC'/'CD',帳別未給值
# Modify.........: No.FUN-810069 08/02/28 By yaofs 項目預算取消abb15的管控
# Modify.........: No.FUN-810069 08/03/04 By lynn s_getbug()新增參數 部門編號afb041,專案代碼afb042
# Modify.........: No.FUN-810045 08/03/03 By rainy 項目管理 1.gja_file->pja_file
#                                                           2.npq35/36往前移到npq08(專案代號)後，未做專案管理時，此3欄位隱藏
# Modify.........: No.FUN-840006 08/04/07 By hellen項目管理，去掉預算編號相關欄位,npq15
# Modify.........: No.FUN-830161 08/04/16 By Carrier 項目預算管理
# Modify.........: No.MOD-840163 08/04/20 By rainy 異動碼9/10不依agli1022控管
# Modify.........: No.MOD-850183 08/05/22 By Sarah 將IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF這行mark掉
#                                                  將IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN改成IF g_aba.abamksg='N' THEN
# Modify.........: No.FUN-860005 08/06/17 By mike 報表輸出方式轉為Crystal Reports
#                                08/08/04 By Cockroach 21區追至31區
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu 打印報表時會報無模板的錯誤
# Modify.........: No.CHI-880014 08/08/21 By Sarah 將s_fsgl_b()段裡,s_fsgl_bcl的SQL裡的拿掉
# Modify.........: No.MOD-8A0251 08/10/29 By Smapmin 增加傳票還原時的控管
# Modify.........: No.MOD-8B0179 08/11/19 By sherry 將s_fsgl_cs()段裡,s_fsgl_cl的SQL裡的拿掉
# Modify.........: No.MOD-8C0256 08/12/25 By sherry AP系統,廠商為MISC時,廠商簡稱不需重帶
# Modify.........: No.MOD-8C0274 08/12/29 By sherry 修改分錄底稿時，WBS編碼欄位被自動清空
# Modify.........: No.FUN-8C0106 09/01/05 By jamie 依參數控管,檢查會科/部門/成本中心 AFTER FIELD
# Modify.........: No.MOD-910004 09/01/05 By Nicola _b()中不使用錯誤訊息彙總
# Modify.........: No.MOD-910041 09/01/07 By Nicola 拋轉至 aglt110 時 aba03,aba04 為 0
# Modify.........: No.MOD-910178 09/01/15 By wujie  更改幣別時，匯率也要變化
# Modify.........: No.CHI-910046 09/01/17 By Smapmin 延續MOD-910041,刪除傳票時也做同樣的動作
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-920068 09/02/20 By chenl  在科目性質維護作業中，勾選預算管理，則費用原因必須輸入
# Modify.........: No.MOD-930023 09/03/03 By Sarah 在一開始先將g_errno清空
# Modify.........: No.MOD-930091 09/03/10 By shiwuying 修改after field npq03段檢查部門+科目是否存在agli104中
# Modify.........: No.FUN-8C0050 09/04/27 By ve007 s_fsgl的bp函數寫回各程序中
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-950096 09/05/12 By lilingyu mark檢核aap-344的訊息段
# Modify.........: No.MOD-950165 09/05/18 By lilingyu AFTER FIELD npq11,npq12,npq13,npq14,npq31,npq33,npq34,npq35,npq36,npq37的
# ...................................................一開始都加上DISPLAY BY NAME
# Modify.........: No.TQC-960359 09/06/25 By chenmoyan 列印時改變了g_wc的值
# Modify.........: No.TQC-970148 09/07/17 By Carrier 科目名稱錯誤
# Modify.........: No.FUN-980012 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980144 09/08/20 By Smapmin 將成本關帳日的判斷拿掉
# Modify.........: No.FUN-980020 09/09/02 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-910001 09/05/21 By hongmei 增加s_fsgl_bp4()->For agli014用
# Modify.........: No.FUN-9A0083 09/10/26 By liuxqa 修改ROWID和OUTER。
# Modify.........: No:MOD-980186 09/11/25 By sabrina 會計科目為空值
# Modify.........: No:MOD-9C0099 09/12/10 By Smapmin 傳票還原時刪除立沖帳檔的動作應同其他模組一樣
# Modify.........: No:MOD-9C0110 09/12/14 By Smapmin aaz85的控管要抓取的是總帳帳別
# Modify.........: No.TQC-9C0099 09/12/14 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No:MOD-9C0273 09/12/23 By Smapmin 右邊action顯示許多英文說明的Action
# Modify.........: No:FUN-A10006 10/01/05 By wujie   增加npp08栏位
# Modify.........: No:MOD-A10040 10/02/24 By sabrina s_fsgl_t_process()段，將gl_date改為tm.gl_date
# Modify.........: No:CHI-A30029 10/03/25 By Summer 刪除分錄時,清空 fan19 = null
# Modify.........: No.CHI-A30021 10/04/12 By sabrina (1)取期別日期應帶npp02而不是npp03
#                                                    (2)取出期別azn02，azn03但卻用l_yy、l_mm
#                                                    (3)沒有設定預算管理科目aag21
# Modify.........: No.TQC-A40050 10/04/15 By lilingyu 兩筆資料,第一筆有分量底稿,第二筆無,在查詢第二筆時,會將第一筆的資料帶出來
# Modify.........: No.TQC-A50161 10/06/01 By Carrier 已审核资料不得修改附件张数
# Modify.........: No.FUN-A50102 10/06/28 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-A80017 10/08/03 By xiaofeizhu npp08只有在大陸版才顯示
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-950053 10/08/18 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No:CHI-A70041 10/08/24 BY Summer npq07f與npq07若為負數時,需判斷單別紅沖欄位須為'Y'或此科目的aag42='Y'才可使用負數
# Modify.........: No.MOD-A80173 10/08/25 By Dido 檢核若與本國幣相同時原幣應與本幣相同
# Modify.........: No.MOD-A90117 10/09/17 By Dido 會科應判斷是否為有效
# Modify.........: No.MOD-AA0006 10/10/01 By Dido npq36應可顯示,維護則依據 aag21 是否可以維護
# Modify.........: No.FUN-AA0025 10/11/10 By Elva 增加'CA'类型
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: NO.TQC-AC0261 10/12/21 By lilingyu IT規範要求g_prog不可更改值
# Modify.........: No:TQC-B10154 11/01/14 By Carrier 第二套帐时,agl-926会有误判现象
# Modify.........: No:MOD-B10192 11/01/24 By Dido 判斷語法調整;關係人一律使用 npq21 檢核 
# Modify.........: No.FUN-B10050 11/01/25 By Carrier 科目查询自动过滤
# Modify.........: No.FUN-AA0087 11/01/27 By chenmoyan 異動碼設定類型改善
# Modify.........: No:FUN-AC0063 11/02/09 By Summer 有輸入異動碼5-8的欄位後要檢核
# Modify.........: No:MOD-B20121 11/02/22 By wujie 通过s_fsgl_b直接调用时缺少npptype的值
# Modify.........: No:FUN-AB0088 11/04/02 By chenying 固定資產財簽二功能
# Modify.........: No:FUN-B40056 11/04/26 By lixia 增加ACTION“設置現金變動碼”
# Modify.........: No:MOD-B50004 11/05/03 By Dido npq05 需增加檢核 gem05 = 'Y'
# Modify.........: No.CHI-B40058 11/05/17 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.TQC-B50067 11/05/17 By yinhy npq36開窗修改
# Modify.........: No.FUN-B50065 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B50105 11/06/02 By zhangweib 講aaz88的範圍修改成0~4 添加aaz125設定5~8的異動碼數
# Modify.........: No:TQC-B70021 11/07/04 By wujie  改用新的sub函数处理现金变动码生成/维护
# Modify.........: No:FUN-B70007 11/07/05 By jrg542 在EXIT PROGRAM前加上CALL cl_used(2)
# Modify.........: No:TQC-BA0110 11/10/19 By Sarah 1.修正FUN-B50105,增加參數時,與前面的參數值中間需加上";"來做分隔
#                                                  2.報表不要用apyi107當程式代號,因為5.25版要將apy模組拿掉了
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:FUN-BB0038 11/11/14 By elva 成本改善,add npp00='9'
# Modify.........: No:MOD-BC0115 11/12/12 By Vampire npq30應給預設值
# Modify.........: No:FUN-BA0112 12/01/13 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No.TQC-BB0087 12/01/13 By Sakura 增加抓取帳別二資料
# Modify.........: No:FUN-BC0035 12/01/13 By Sakura 增加"類別異動"14判斷 
# Modify.........: No:MOD-C10123 12/01/16 By Polly 增加判斷抓取廠商編號
# Modify.........: No:TQC-C20441 12/02/28 By zhangwei 開窗時排除統制科目
# Modify.........: No:MOD-C20026 12/02/04 By Polly 增加判斷fan19不為null時，才UPDATE fan19
# Modify.........: No:MOD-C20077 12/02/08 By Polly 產生分錄後，單身新增一筆或於npq21開窗，需開啟員工資料
# Modify.........; No:MOD-C30030 12/03/06 By Polly 刪除折舊分錄時，先重抓g_npp資料
# Modify.........; No:MOD-C30727 12/03/15 By minpp WBS欄位為空白者,則將此欄位預設值為 ' '
# Modify.........: No:MOD-C40051 12/04/06 By Polly 銀行不需控卡關係人異動碼欄位
# Modify.........: No:FUN-C50113 12/05/29 By xuxz 將g_npp值傳出
# Modify.........: No:MOD-C60058 12/06/08 By Elise 使用aza82,增加判斷當g_npp.nppsys = 'FA'時,改抓faa02c,否則aza82
# Modify.........: No:TQC-C60171 12/06/25 By lujh axrt300產生的分錄底稿，開窗挑選核算項5~核算項8時，顯示為空白，但是可以手動輸入
# Modify.........: No:MOD-C70113 12/07/10 By Polly 調整NM系統目有設定關係人異動碼控卡
# Modify.........: No:TQC-C70105 12/07/31 By lujh 查詢所有資料，上下筆是無法查到新生成的資料,2012年6月份的,但是如果查詢所有資料，直接按最後一筆可以顯示該筆資料
# Modify.........: No:MOD-C90254 12/11/02 By Dido aag21 時不可將 npq08/npq35 設定為 null 
# Modify.........: No:MOD-CB0152 12/11/20 By Polly 修正重覆計算已耗用金額問題
# Modify.........: No.MOD-C90261 12/12/18 By Polly 分錄內的科目為資產類科目(aag04=1)且分錄的類別為FA(固資系統)，
#                                                  即使該會科有設定預算控管，亦不應進入預算檢核的程式段
# Modify.........: No.MOD-D10226 13/01/28 By Polly 增加應付系統抓取廠商簡稱條件
# Modify.........: No.MOD-D20048 13/02/06 By Polly 增加FA系統關係人的控卡
# Modify.........: No.FUN-CB0039 13/02/21 By minpp 摘要栏位输入cc，不需要大小写，复制上一行
# Modify.........: No.CHI-D20032 13/02/27 By Dido NM 類別 3 的對象檢核方式參考 anmt302 方式處理 
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40118 13/05/22 By lujh 若科目有做核算控管aag44=Y,但agli122作業沒有維護，
#                                                 則報錯:“科目編號(值)+本科目不在本作業中使用,請檢查agli122中設置！”
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
# Modify.........: No.yinhy130814 13/08/14 By yinhy NM類別分錄底稿去除nmg20為0的限制
# Modify.........: No.yinhy130922 13/09/22 By yinhy 現金流量來源是分錄底稿時，如果更改了科目、借貸別、金額時更改時重新更新現金流量資料

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-7C0053
GLOBALS "../4gl/s_fsgl.global"      #No.FUN-8C0050


DEFINE
    g_npp     	    RECORD LIKE npp_file.*,
#No.FUN-8C0050 --begin--
#    g_npq           DYNAMIC ARRAY of RECORD      #程式變數(Program Variables)
##   g_npq           ARRAY[100] of RECORD         #程式變數(Program Variables)
#                    npq02     LIKE npq_file.npq02,
#                    npq03     LIKE npq_file.npq03,
#                    aag02     LIKE aag_file.aag02,
#                    npq05     LIKE npq_file.npq05,
#                    npq05_d   LIKE gem_file.gem02,   #FUN-810082
#                    npq06     LIKE npq_file.npq06,
#                    npq24     LIKE npq_file.npq24,
#                    npq25     LIKE npq_file.npq25,
#                    npq07f    LIKE npq_file.npq07f,
#                    npq07     LIKE npq_file.npq07,
#                    npq21     LIKE npq_file.npq21,
#                    npq22     LIKE npq_file.npq22,
#                    npq23     LIKE npq_file.npq23,
##                   npq15     LIKE npq_file.npq15,   #No.FUN-840006 去掉npq15
#                    npq08     LIKE npq_file.npq08,
#                   #FUN-810045 begin
#                    npq35     LIKE npq_file.npq35,  #異動碼9
#                    npq36     LIKE npq_file.npq36,  #異動碼10
#                   #FUN-810045 end
#                    npq11     LIKE npq_file.npq11,
#                    npq12     LIKE npq_file.npq12,
#                    npq13     LIKE npq_file.npq13,
#                    npq14     LIKE npq_file.npq14,
#                    #FUN-5C0015 051216 BY GILL --START
#                    npq31     LIKE npq_file.npq31,  #異動碼5
#                    npq32     LIKE npq_file.npq32,  #異動碼6
#                    npq33     LIKE npq_file.npq33,  #異動碼7
#                    npq34     LIKE npq_file.npq34,  #異動碼8
#                    #npq35     LIKE npq_file.npq35,  #異動碼9    #FUN-810045 移到npq08後
#                    #npq36     LIKE npq_file.npq36,  #異動碼10   #FUN-810045
#                    npq37     LIKE npq_file.npq37,  #關係人異動碼
#                    #FUN-5C0015 051216 BY GILL --END
#                    npq04     LIKE npq_file.npq04
#                    END RECORD,
#    g_npq_t         RECORD
#                    npq02     LIKE npq_file.npq02,
#                    npq03     LIKE npq_file.npq03,
#                    aag02     LIKE aag_file.aag02,
#                    npq05     LIKE npq_file.npq05,
#                    npq05_d   LIKE gem_file.gem02,   #FUN-810082
#                    npq06     LIKE npq_file.npq06,
#                    npq24     LIKE npq_file.npq24,
#                    npq25     LIKE npq_file.npq25,
#                    npq07f    LIKE npq_file.npq07f,
#                    npq07     LIKE npq_file.npq07,
#                    npq21     LIKE npq_file.npq21,
#                    npq22     LIKE npq_file.npq22,
#                    npq23     LIKE npq_file.npq23,
##                   npq15     LIKE npq_file.npq15,   #No.FUN-840006 去掉npq15
#                    npq08     LIKE npq_file.npq08,
#                   #FUN-810045 begin
#                    npq35     LIKE npq_file.npq35,   #異動碼9
#                    npq36     LIKE npq_file.npq36,   #異動碼10
#                   #FUN-810045 end
#                    npq11     LIKE npq_file.npq11,
#                    npq12     LIKE npq_file.npq12,
#                    npq13     LIKE npq_file.npq13,
#                    npq14     LIKE npq_file.npq14,
#                    #FUN-5C0015 051216 BY GILL --START
#                    npq31     LIKE npq_file.npq31,   #異動碼5
#                    npq32     LIKE npq_file.npq32,   #異動碼6
#                    npq33     LIKE npq_file.npq33,   #異動碼7
#                    npq34     LIKE npq_file.npq34,   #異動碼8
#                    #npq35     LIKE npq_file.npq35,  #異動碼9     #FUN-810045
#                    #npq36     LIKE npq_file.npq36,  #異動碼10    #FUN-810045 移到npq08後
#                    npq37     LIKE npq_file.npq37,   #關係人異動碼
#                    #FUN-5C0015 051216 BY GILL --END
#                    npq04     LIKE npq_file.npq04
#                    END RECORD,
#No.FUN-8C0050 --end--
    g_npq2          DYNAMIC ARRAY of RECORD    #程式變數(Program Variables)
                    tlf06     LIKE tlf_file.tlf06,   #日期
                    tlf905    LIKE tlf_file.tlf905,  #單據編號
                    tlf906    LIKE tlf_file.tlf906,  #項次
                    tlf01     LIKE tlf_file.tlf01,   #料件
                    ima02     LIKE ima_file.ima02,   #品名
                    ima021    LIKE ima_file.ima021,  #規格
                    ima25     LIKE ima_file.ima25,   #單位
                    qyt       LIKE tlf_file.tlf10,   #數量
                    tlf902    LIKE tlf_file.tlf902,  #倉庫
                    tlf903    LIKE tlf_file.tlf903,  #儲位
                    tlf904    LIKE tlf_file.tlf904,  #批號
                    ahi04     LIKE ahi_file.ahi04,   #成本單價
                    ahi04a    LIKE ahi_file.ahi04,   #成本金額
                    ahi05     LIKE ahi_file.ahi05,   #內部單價
                    ahi05a    LIKE ahi_file.ahi05,   #內部金額
                    tlf14     LIKE tlf_file.tlf14,   #原因
                    azf03     LIKE azf_file.azf03    #原因說明
                    END RECORD,
       #yinhy130922  --Begin
       g_tic     DYNAMIC ARRAY OF RECORD          
                    tic04     LIKE tic_file.tic04,  #單據編號
                    tic05     LIKE tic_file.tic05,  #項次
                    tic06     LIKE tic_file.tic06,  #現金變動碼
                    tic08     LIKE tic_file.tic08,  #關係人
                    tic07f    LIKE tic_file.tic07f, #原幣金額
                    tic07     LIKE tic_file.tic07   #本幣金額     
                    END RECORD,
       g_tic_flows DYNAMIC ARRAY OF RECORD
                    npq02     LIKE npq_file.npq02,  #項次
                    npq25     LIKE npq_file.npq25,  #匯率
                    aag371    LIKE aag_file.aag371,  
                    npq37     LIKE npq_file.npq37,  #關係人
                    npq07f    LIKE npq_file.npq07f, #原幣金額 
                    npq07     LIKE npq_file.npq07   #本幣金額
                    END RECORD,               
       #yinhy130922  --End
    g_npq07f_t1,g_npq07_t1     LIKE npq_file.npq07,  #FUN-4C0031
    g_npq07f_t2,g_npq07_t2     LIKE npq_file.npq07,  #FUN-4C0031
    g_sql           STRING,   #No.FUN-580092 HCN
    g_sql1          STRING,   #No.FUN-580092 HCN
    g_wc            STRING,   #FUN-670080 add
#    g_rec_b         LIKE type_file.num5,         #No.FUN-680147 SMALLINT    #No.FUN-8C0050  --MARK--
#    l_ac            LIKE type_file.num5,         #No.FUN-680147 SMALLINT    #No.FUN-8C0050  --MARK--
    g_buf           LIKE azi_file.azi02,         #No.FUN-680147 VARCHAR(20)
    g_argv1         LIKE npp_file.nppsys,        #No.FUN-680147 VARCHAR(02) #系統別
    g_argv2         LIKE npp_file.npp00,         #No.FUN-680147 SMALLINT #類別
    g_argv3         LIKE npp_file.npp01,         #No.FUN-680147 VARCHAR(20) #單號
    g_argv4         LIKE npq_file.npq07,         #票面金額 #FUN-4C0031
    g_argv5         LIKE aaa_file.aaa01,         #FUN-670039
    g_argv6         LIKE npp_file.npp011,        #No.FUN-680147 SMALLINT #序號
    g_argv7         LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(01)
    g_argv8         LIKE npp_file.npptype,       #No.FUN-670047
    g_argv9         LIKE azp_file.azp01,         #No.FUN-670047
    #g_azi           RECORD LIKE azi_file.*,      #No.CHI-6A0004   #MOD-770076
    g_aaz72         LIKE aaz_file.aaz72,
    g_apz02p        LIKE apz_file.apz02p,
    g_ooz02p        LIKE ooz_file.ooz02p,
    g_nmz02p        LIKE nmz_file.nmz02p,
    g_faa02p        LIKE faa_file.faa02p,
    g_dbs_gl        LIKE type_file.chr21,        #No.FUN-680147 VARCHAR(21)
    g_plant_gl      LIKE type_file.chr21,        #No.FUN-980020
    g_azn02         LIKE azn_file.azn02,
    g_azn04         LIKE azn_file.azn04
#DEFINE   g_curs_index    LIKE type_file.num10        #No.FUN-680147 INTEGER   #FUN-670080 add  #No.FUN-8C0050  --MARK--
#DEFINE   g_row_count     LIKE type_file.num10        #No.FUN-680147 INTEGER  #FUN-670080 add  #No.FUN-8C0050  --MARK--
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680147 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680147 VARCHAR(72)
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680147 SMALLINT   #FUN-670080 add #No.FUN-6A0079
DEFINE   g_jump          LIKE type_file.num10        #No.FUN-680147 INTEGER   #FUN-670080 add
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680147 SMALLINT
DEFINE   l_aag05         LIKE aag_file.aag05,
         l_aag06         LIKE aag_file.aag06,  #借餘或貸餘
         l_aag15         LIKE aag_file.aag15,
         l_aag16         LIKE aag_file.aag16,
         l_aag17         LIKE aag_file.aag17,
         l_aag18         LIKE aag_file.aag18,
         l_aag151        LIKE aag_file.aag151,
         l_aag161        LIKE aag_file.aag161,
         l_aag171        LIKE aag_file.aag171,
         l_aag181        LIKE aag_file.aag181,
         l_aag21         LIKE aag_file.aag21,
         l_aag23         LIKE aag_file.aag23
#FUN-5C0015---start
DEFINE   l_aag31         LIKE aag_file.aag31,
         l_aag32         LIKE aag_file.aag32,
         l_aag33         LIKE aag_file.aag33,
         l_aag34         LIKE aag_file.aag34,
         l_aag35         LIKE aag_file.aag35,
         l_aag36         LIKE aag_file.aag36,
         l_aag37         LIKE aag_file.aag37,
         l_aag311        LIKE aag_file.aag311,
         l_aag321        LIKE aag_file.aag321,
         l_aag331        LIKE aag_file.aag331,
         l_aag341        LIKE aag_file.aag341,
         l_aag351        LIKE aag_file.aag351,
         l_aag361        LIKE aag_file.aag361,
         l_aag371        LIKE aag_file.aag371,
         g_ahe02         LIKE ahe_file.ahe02
#FUN-5C0015---end
#start FUN-690134 add
DEFINE  tm          RECORD
         wc             LIKE type_file.chr1000,   #No.FUN-680147 VARCHAR(500) #TQC-5B0038
         plant          LIKE azp_file.azp01,      #No.FUN-680147 VARCHAR(12)  #工廠別
         a              LIKE aba_file.aba01,                               #帳別
         a1             LIKE aaa_file.aaa01,      # No.FUN-680068
         gl_date        LIKE type_file.dat,       #No.FUN-680147 DATE      #傳票日期
         yy,mm          LIKE type_file.num5,      #No.FUN-680147 SMALLINT, #年度,月份
         gl_no          LIKE aba_file.aba01,      #No.FUN-680147 VARCHAR(16)  #傳票編號   #No.FUN-550062
         gl_no1         LIKE aba_file.aba01       # No.FUN-680068  #No.FUN-680126 VARCHAR(16)
                    END RECORD,
        g_aaa           RECORD LIKE aaa_file.*,
        g_aba           RECORD LIKE aba_file.*,
        g_aac           RECORD LIKE aac_file.*,
        g_bookno        LIKE aba_file.aba01,      #ARG_1 帳別
        g_bookno1       LIKE aba_file.aba01,      # No.FUN-680068
        p_plant         LIKE azp_file.azp01,      #No.FUN-680147 VARCHAR(12)
        p_acc           LIKE type_file.chr5,      #LIKE cpa_file.cpa151,     # No.FUN-680068  #No.FUN-680126 VARCHAR(6)   #TQC-B90211
        p_acc1          LIKE npp_file.npp07,      # No.FUN-680068  #No.FUN-680126 VARCHAR(6)
        l_plant_old     LIKE azp_file.azp01,      #No.FUN-680147 VARCHAR(12) #No.FUN-580111  --add
        g_existno       LIKE aba_file.aba01,      #No.FUN-680147 VARCHAR(16) #No.FUN-550062
        g_existno1      LIKE aba_file.aba01,      #No.FUN-680147 VARCHAR(16) #No.FUN-550062
        gl_no_b,gl_no_e LIKE aba_file.aba01,      #No.FUN-680147 VARCHAR(16)
        gl_no1_b,gl_no1_e LIKE aba_file.aba01,      #No.FUN-680147 VARCHAR(16)
        g_aba01t        LIKE type_file.chr5,      #No.FUN-680147 VARCHAR(5)  #No.FUN-550062
        g_aaz85         LIKE aaz_file.aaz85,      #傳票是否自動確認 no.3432
        g_yy,g_mm       LIKE type_file.num5,      #No.FUN-680147 SMALLINT
        p_row,p_col     LIKE type_file.num5,      #No.FUN-680147 SMALLINT
        li_result       LIKE type_file.num5,      #No.FUN-680147 SMALLINT #No.FUN-550062
        l_azn02         LIKE azn_file.azn02,
        l_azn04         LIKE azn_file.azn04
#end FUN-690134 add
DEFINE   g_bookno11    LIKE aza_file.aza81   #No.FUN-730020
DEFINE   g_bookno22    LIKE aza_file.aza82   #No.FUN-730020
DEFINE   g_bookno33    LIKE aza_file.aza82   #No.FUN-730020
DEFINE   g_flag        LIKE type_file.chr1   #No.FUN-730020

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE l_table STRING  #No.FUN-860005
DEFINE g_str   STRING  #No.FUN-860005
DEFINE g_aptype        LIKE apa_file.apa00 #帳款種類   #MOD-8C0274
DEFINE g_npp_t         RECORD LIKE npp_file.*                 #No.FUN-A10006
DEFINE g_azi04_2  LIKE azi_file.azi04       #FUN-A40067
DEFINE g_pmc903   LIKE pmc_file.pmc903      #FUN-950053
DEFINE g_occ37    LIKE occ_file.occ37       #FUN-950053
DEFINE g_npq3          RECORD LIKE npq_file.* #FUN-AA0087 add

FUNCTION s_fsgl_cs()

  #start FUN-690134 add
   #LET g_forupd_sql = " SELECT * FROM npp_file WHERE npp00=? AND npp01=? AND npp011=? AND nppsys=? AND npptype=? FOR UPDATE  "   #MOD-8B0179 mark
   LET g_forupd_sql = " SELECT * FROM npp_file WHERE npp00=? AND npp01=? AND npp011=? AND nppsys=? AND npptype=? FOR UPDATE "  #MOD-8B0179 mod
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_fsgl_cl CURSOR FROM g_forupd_sql
   IF g_argv1='PY' AND g_prog = 'apyi107' THEN   #TQC-6B0047 add
      DECLARE tmn_del CURSOR FOR
         SELECT tc_tmp02,tc_tmp03 FROM agl_tmp_file WHERE tc_tmp00 = 'Y'
   END IF                                        #TQC-6B0047 add
  #end FUN-690134 add

   #start FUN-670080 add
    IF (g_argv1='CC' OR g_argv1='FA' OR g_argv1='CA'
     OR g_argv1='PY' OR g_argv1='CD')   #FUN-690134 add PY #FUN-770086 add CD
     AND cl_null(g_argv3) THEN   #FUN-660165
       CLEAR FORM                 #清除畫面
       CALL g_npq.clear()

       LET g_npp.nppsys = g_argv1
       DISPLAY g_npp.nppsys TO nppsys

      #start FUN-660165 add
       IF g_prog = 'afai104' THEN LET g_argv2 = 10 END IF
       IF g_prog = 'afai501' THEN LET g_argv2 = 12 END IF
       IF g_prog = 'axci100' THEN LET g_argv2 = 1  END IF
       LET g_npp.npp00  = g_argv2
       DISPLAY g_npp.npp00 TO npp00
      #end FUN-660165 add

      CALL cl_set_head_visible("","YES")              #No.FUN-6B0033
      #start FUN-660165 modify
      #IF g_prog = 'agli142' THEN                         #FUN-690134 mark
       IF g_prog = 'agli142' OR g_prog = 'apyi107' OR g_prog='agli014' THEN   #FUN-690134 #FUN-770086
          CONSTRUCT BY NAME g_wc ON npptype,npp00,npp01,npp011,npp02,npp08,nppglno,npp03 #FUN-670047 FUN-A10006 add npp08
             #No.FUN-580031 --start--     HCN
             BEFORE CONSTRUCT
                CALL cl_qbe_init()
             #No.FUN-580031 --end--HCN
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

          LET g_sql = " SELECT npp00,npp01,npp011,nppsys,npptype FROM npp_file ",
                      "  WHERE nppsys='",g_npp.nppsys,"'",
                      "    AND ", g_wc CLIPPED
         #start FUN-690134 add
         #當只使用一套帳時,查詢資料只要查出主帳別的資料
          IF g_aza.aza63 = 'N' THEN
             LET g_sql = g_sql,"    AND npptype='0'"
          END IF
         #end FUN-690134 add
          LET g_sql = g_sql,"  ORDER BY 2,3"

          LET g_sql1= "SELECT COUNT(*) FROM npp_file ",
                      " WHERE nppsys='",g_npp.nppsys,"'",
                      "   AND ", g_wc CLIPPED
         #start FUN-690134 add
        #FUN-AB0088---mod----str---------------------------------
        ##當只使用一套帳時,查詢資料只要查出主帳別的資料
        # IF g_aza.aza63 = 'N' THEN
        #    LET g_sql1= g_sql1,"    AND npptype='0'"
        # END IF
        ##-----No:FUN-BA0112 Mark-----
        #  IF g_argv1 = "FA" THEN
        #     IF g_faa.faa31 = 'N' THEN
        #        LET g_sql1= g_sql1,"    AND npptype='0'"
        #     END IF
        #  ELSE
        ##-----No:FUN-BA0112 Mark END-----         
             IF g_aza.aza63 = 'N' THEN
                LET g_sql1= g_sql1,"    AND npptype='0'"
             END IF
        #  END IF #No:FUN-BA0112 mark
        #FUN-AB0088---mod----end------------------------------------
         #end FUN-690134 add
       ELSE
          CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
          CONSTRUCT BY NAME g_wc ON npptype,npp01,npp011,npp02,npp08,nppglno,npp03 #FUN-670047    FUN-A10006 add npp08
             #No.FUN-580031 --start--     HCN
             BEFORE CONSTRUCT
                CALL cl_qbe_init()
             #No.FUN-580031 --end--HCN
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

          LET g_sql = " SELECT npp00,npp01,npp011,nppsys,npptype FROM npp_file ",
                      "  WHERE nppsys='",g_npp.nppsys,"'",
                      "    AND npp00 ='",g_npp.npp00,"'",
                      "    AND ", g_wc CLIPPED
         #start FUN-690134 add
        #FUN-AB0088---mod----str------------------------------
        ##當只使用一套帳時,查詢資料只要查出主帳別的資料
        # IF g_aza.aza63 = 'N' THEN
        #    LET g_sql = g_sql,"    AND npptype='0'"
        # END IF
          IF g_argv1 = "FA" THEN
             IF g_faa.faa31 = 'N' THEN
                #LET g_sql1= g_sql1,"    AND npptype='0'"     #TQC-C70105   mark
                LET g_sql= g_sql," AND npptype='0'"           #TQC-C70105   add
             END IF
          ELSE
             IF g_aza.aza63 = 'N' THEN
                #LET g_sql1= g_sql1,"    AND npptype='0'"     #TQC-C70105   mark
                LET g_sql= g_sql,"    AND npptype='0'"        #TQC-C70105   add
             END IF
          END IF
        #FUN-AB0088---mod----end------------------------------
         #end FUN-690134 add
          LET g_sql = g_sql,"  ORDER BY 2,3"

          LET g_sql1= "SELECT COUNT(*) FROM npp_file ",
                      " WHERE nppsys='",g_npp.nppsys,"'",
                      "   AND npp00 ='",g_npp.npp00,"'",
                      "   AND ", g_wc CLIPPED
         #start FUN-690134 add
         #當只使用一套帳時,查詢資料只要查出主帳別的資料
         ##-----No:FUN-BA0112 add STR-----  
          IF g_argv1 = "FA" THEN
             IF g_faa.faa31 = 'N' THEN
                LET g_sql1= g_sql1,"    AND npptype='0'"
             END IF                   
          ELSE
          ##-----No:FUN-BA0112 add END-----         
          IF g_aza.aza63 = 'N' THEN
             LET g_sql1= g_sql1,"    AND npptype='0'"
          END IF
          END IF #No:FUN-BA0112 add             
         #end FUN-690134 add
       END IF
      #end FUN-660165 modify
    ELSE
   #end FUN-670080 add
       LET g_sql = "SELECT npp00,npp01,npp011,nppsys,npptype FROM npp_file ",
                   " WHERE nppsys='",g_argv1,"' AND npp00=",g_argv2,
                   "   AND npp011= ",g_argv6,
                   "   AND npptype='",g_argv8,"'", #No.FUN-670047
#                  "   AND npp01 ='",g_argv3,"' ORDER BY 2,3"  #No.FUN-670047 mark
                   "   AND npp01 ='",g_argv3,"' ORDER BY npp01,npp011" #No.FUN-670047

       LET g_sql1= "SELECT COUNT(*) FROM npp_file ",
                   " WHERE nppsys='",g_argv1,"' AND npp00=",g_argv2,
                   "   AND npp011= ",g_argv6,
                   "   AND npptype='",g_argv8,"'", #No.FUN-670047
                   "   AND npp01 ='",g_argv3,"'"
    END IF   #FUN-670080 add

    PREPARE s_fsgl_prepare FROM g_sql
    IF SQLCA.SQLCODE THEN
#NO.FUN-720003-----begin
      IF g_bgerr THEN
         LET g_showmsg=g_argv1,"/",g_argv6,"/",g_argv8,"/",g_argv3
         CALL s_errmsg('nppsys,npp011,npptype,npp01',g_showmsg,'s_fsgl_pre',STATUS,1)
      ELSE
         CALL cl_err('s_fsgl_pre',STATUS,1)
      END IF
#NO.FUN-720003-----end
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B70007 
      EXIT PROGRAM
    END IF
    DECLARE s_fsgl_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR s_fsgl_prepare

    PREPARE s_fsgl_co FROM g_sql1
    DECLARE s_fsgl_count CURSOR FOR s_fsgl_co
    IF STATUS THEN
#NO.FUN-720003------begin
      IF g_bgerr THEN
         LET g_showmsg=g_argv1,"/",g_argv6,"/",g_argv8,"/",g_argv3
         CALL s_errmsg('nppsys,npp011,npptype,npp01',g_showmsg,'s_fsgl_pre',STATUS,1)
      ELSE
         CALL cl_err('s_fsgl_count',STATUS,1)
      END IF
#NO.FUN-720003------end
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
      EXIT PROGRAM
    END IF
END FUNCTION

FUNCTION s_fsgl(p_sys,p_type,p_no,p_amt,p_z02b,p_sql,p_firm,p_npptype,p_plant) #No.FUN-670047 增加p_npptype,p_plant
    DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680147 SMALLINT
    DEFINE p_sys           LIKE npp_file.nppsys,        #No.FUN-680147 VARCHAR(02)  # NM/AP/AR/FA
           p_type          LIKE type_file.num5,         #No.FUN-680147 SMALLINT  # 類別
           p_no            LIKE npp_file.npp01,         #No.FUN-680147 VARCHAR(20)  # 單號
           p_amt           LIKE nmd_file.nmd04,  #票面金額?
           p_z02b          LIKE nmz_file.nmz02b, #帳別
           p_sql           LIKE type_file.num5,         #No.FUN-680147 SMALLINT   #異動序號
           p_firm          LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(01)    #確認碼
           p_npptype       LIKE npp_file.npptype,#分錄類別    #No.FUN-670047
           p_plant         LIKE azp_file.azp01   #營運中心別  #No.FUN-670047
    DEFINE ls_tmp STRING

    IF p_no IS NULL THEN RETURN END IF
    LET g_argv1 = p_sys
    LET g_argv2 = p_type
    LET g_argv3 = p_no
    LET g_argv4 = p_amt
    LET g_argv5 = p_z02b
    LET g_argv6 = p_sql
    LET g_argv7 = p_firm
    LET g_argv8 = p_npptype  #No.FUN-670047
    LET g_argv9 = p_plant    #No.FUN-670047

    WHENEVER ERROR CALL cl_err_msg_log

    #顯示畫面
    LET p_row = 2 LET p_col = 4
    OPEN WINDOW s_fsgl_w AT p_row,p_col WITH FORM "sub/42f/s_fsgl"
    ATTRIBUTE( STYLE = g_win_style )

    CALL cl_ui_locale("s_fsgl")
    CALL s_fsgl_show_filed()  #FUN-5C0015 051216 BY GILL

    #No.MOD-A80017 --start--
    IF g_aza.aza26 = '2' THEN
       CALL cl_set_comp_visible("npp08",TRUE)
    ELSE
    	 CALL cl_set_comp_visible("npp08",FALSE)
    END IF
    #No.MOD-A80017 --end--

#   SELECT * INTO g_azi.* FROM azi_file WHERE azi01 = g_aza.aza17      #No.CHI-6A0004

    CALL g_npq.clear()
    INITIALIZE g_npp.* TO NULL      #TQC-A40050
    LET g_errno = ''   #MOD-930023 add
    CALL s_fsgl_cs()
    OPEN s_fsgl_count
    FETCH s_fsgl_count INTO g_cnt
    DISPLAY g_cnt TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
    OPEN s_fsgl_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
       IF g_bgerr THEN
          CALL s_errmsg('','',g_npp.npp01,SQLCA.sqlcode,1)
       ELSE
          CALL cl_err(g_npp.npp01,SQLCA.sqlcode,1)
       END IF
#NO.FUN-720003------end
        INITIALIZE g_npp.* TO NULL
    ELSE
        CALL s_fsgl_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF

    #No.FUN-670047 --start--
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("npptype",FALSE)
    END IF
    #No.FUN-670047 --end--

    CALL s_fsgl_menu()
    CLOSE WINDOW s_fsgl_w

    RETURN
END FUNCTION

FUNCTION s_fsgl_menu()
#yemy 20130608  --Begin
DEFINE w ui.Window       #MOD-A30138 add
DEFINE f ui.Form         #MOD-A30138 add
DEFINE page om.DomNode   #MOD-A30138 add
#yemy 20130608  --End  

   WHILE TRUE
      CALL s_fsgl_bp("G")
      CASE g_action_choice
         WHEN "first"
            CALL s_fsgl_fetch('F')
         WHEN "previous"
            CALL s_fsgl_fetch('P')
         WHEN "jump"
            CALL s_fsgl_fetch('/')
         WHEN "next"
            CALL s_fsgl_fetch('N')
         WHEN "detail"
            CALL s_fsgl_b()
         WHEN "last"
            CALL s_fsgl_fetch('L')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            LET INT_FLAG = 0
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#No.FUN-A10006 --begin
         WHEN "modify"
            CALL s_fsgl_u()
#No.FUN-A10006 --end

         #FUN-B40056--add--str--
         WHEN "flows"      #現金流量明細
#            CALL s_fsgl_flows()
             CALL  s_flows('3',g_npp.npp07,g_npp.npp01,g_npp.npp02,g_argv7,g_npp.npptype,FALSE)     #No.TQC-B70021
         #FUN-B40056--add--end--

         WHEN "exporttoexcel"                       #單身匯出最多可匯三個Table資料
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               LET page = f.FindNode("Table","s_npq")
               CALL cl_export_to_excel(page,base.TypeInfo.create(g_npq),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

#start FUN-670080 add
FUNCTION s_fsgl_q(p_nppsys)
   DEFINE p_nppsys  LIKE npp_file.nppsys

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_npq.clear()
   DISPLAY '' TO FORMONLY.cnt

   LET g_argv1 = p_nppsys
   CALL s_fsgl_cs()                    #取得查詢條件
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_npp.* TO NULL
      RETURN
   END IF

   OPEN s_fsgl_cs                      #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
#NO.FUN-720003-----begin
      IF g_bgerr THEN
         CALL s_errmsg('','','',SQLCA.sqlcode,0)
      ELSE
         CALL cl_err('',SQLCA.sqlcode,0)
      END IF
#NO.FUN-720003------end
      INITIALIZE g_npp.* TO NULL
   ELSE
      OPEN s_fsgl_count
      FETCH s_fsgl_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL s_fsgl_fetch('F')           #讀出TEMP第一筆並顯示
   END IF

END FUNCTION
#end FUN-670080 add

#處理資料的讀取
FUNCTION s_fsgl_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01) #處理方式

    CASE p_flag
      WHEN 'N' FETCH NEXT     s_fsgl_cs INTO g_npp.npp00,g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npptype
      WHEN 'P' FETCH PREVIOUS s_fsgl_cs INTO g_npp.npp00,g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npptype
      WHEN 'F' FETCH FIRST    s_fsgl_cs INTO g_npp.npp00,g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npptype
      WHEN 'L' FETCH LAST     s_fsgl_cs INTO g_npp.npp00,g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npptype
      WHEN '/'
           IF (NOT mi_no_ask) THEN       #No.FUN-6A0079
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
#                    CONTINUE PROMPT

                 ON ACTION about         #MOD-4C0121
                    CALL cl_about()      #MOD-4C0121

                 ON ACTION help          #MOD-4C0121
                    CALL cl_show_help()  #MOD-4C0121

                 ON ACTION controlg      #MOD-4C0121
                    CALL cl_cmdask()     #MOD-4C0121
              END PROMPT
              IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump s_fsgl_cs INTO g_npp.npp00,g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npptype
           LET mi_no_ask = FALSE         #No.FUN-6A0079
    END CASE
    IF SQLCA.sqlcode THEN
#NO.FUN-7200030------begin
       IF g_bgerr THEN
          CALl s_errmsg('','',g_npp.npp01,SQLCA.sqlcode,0)
       ELSE
          CALL cl_err(g_npp.npp01,SQLCA.sqlcode,0)
       END IF
#NO.FUN-720003-------end
        RETURN
    END IF
    SELECT * INTO g_npp.* FROM npp_file WHERE npp00=g_npp.npp00 AND npp01=g_npp.npp01 AND npp011=g_npp.npp011 AND nppsys=g_npp.nppsys AND npptype=g_npp.npptype
    IF SQLCA.sqlcode THEN
#NO.FUN-720003-------begin
       IF g_bgerr THEN
          CALL s_errmsg('','',g_npp.npp01,SQLCA.sqlcode,1)
       ELSE
          CALL cl_err(g_npp.npp01,SQLCA.sqlcode,1)
       END IF
#NO.FUN-720003--------end
       INITIALIZE g_npp.* TO NULL
       RETURN
    ELSE
       CALL s_fsgl_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       #CALL cl_navigator_setting( g_curs_index, g_row_count )   #MOD-6C0091
    END IF
END FUNCTION

FUNCTION s_fsgl_show()
  DEFINE l_sysdes   LIKE ze_file.ze03           #No.FUN-680147 VARCHAR(8)
  DEFINE l_np0des   LIKE ze_file.ze03           #No.FUN-680147 VARCHAR(8)
  DEFINE l_sql      LIKE type_file.chr1000      #No.FUN-680147 VARCHAR(200)
   #將資料顯示在畫面上
   DISPLAY BY NAME g_npp.npptype,g_npp.nppsys,g_npp.npp00,g_npp.npp01, #FUN-670047 新增g_npp.npptype
                   g_npp.npp011,g_npp.nppglno,g_npp.npp03,g_npp.npp08   #No.FUN-A10006 add npp08
   DISPLAY BY NAME g_npp.npp02
   CASE g_argv1       #系統別
       WHEN 'NM'
           CALL cl_getmsg('anm-202',g_lang) RETURNING l_sysdes
           CASE g_argv2   {NM(1.應付 2.應收 3.銀行/短貸/中長貸  )  }
                          {  (4.定存質押    5.定存解除質押      )  }
                          {  (6.還息 7.還本 8.外匯交割 9.外匯   )  }
                          {  (13.銀行存款月底重評               )  }         #A058
                          {  (14.應收票據月底重評               )  }
                          {  (15.應付票據月底重評               )  }
              WHEN  1
                 CALL cl_getmsg('anm-203',g_lang) RETURNING l_np0des
              WHEN  2
                 CALL cl_getmsg('anm-204',g_lang) RETURNING l_np0des
              WHEN  3
                 CALL cl_getmsg('anm-205',g_lang) RETURNING l_np0des
              WHEN  4
                 CALL cl_getmsg('anm-634',g_lang) RETURNING l_np0des
              WHEN  5
                 CALL cl_getmsg('anm-638',g_lang) RETURNING l_np0des
              WHEN  6
                 CALL cl_getmsg('anm-639',g_lang) RETURNING l_np0des
              WHEN  7
                 CALL cl_getmsg('anm-640',g_lang) RETURNING l_np0des
              WHEN  8
                 CALL cl_getmsg('anm-637',g_lang) RETURNING l_np0des
              WHEN  9
                 CALL cl_getmsg('anm-635',g_lang) RETURNING l_np0des
              #add 030213 NO.A048
              WHEN 13
                 CALL cl_getmsg('gnm-001',g_lang) RETURNING l_np0des
              #add 030422 NO.A058
              WHEN 14
                 CALL cl_getmsg('gnm-001',g_lang) RETURNING l_np0des
              WHEN 15
                 CALL cl_getmsg('gnm-001',g_lang) RETURNING l_np0des
              #NO.A058 end
              #no.7277
              WHEN 16
                 CALL cl_getmsg('anm-213',g_lang) RETURNING l_np0des
              WHEN 17
                 CALL cl_getmsg('anm-218',g_lang) RETURNING l_np0des
              #no.7277(end)
              OTHERWISE EXIT CASE
           END CASE
       WHEN 'AP'
           SELECT apz02p INTO g_apz02p FROM apz_file WHERE apz00 = '0'
#          LET g_plant_new = g_apz02p  #No.FUN-670047 mark
           LET g_plant_new = g_argv9   #No.FUN-670047
           LET g_plant_gl = g_argv9
           CALL s_getdbs()
           LET g_dbs_gl = g_dbs_new

           CALL cl_getmsg('anm-203',g_lang) RETURNING l_sysdes
           CASE g_argv2      #類別:1.應付 2.直接付款 3.付款
              WHEN  1
                 CALL cl_getmsg('anm-203',g_lang) RETURNING l_np0des
              WHEN  2
                 CALL cl_getmsg('anm-215',g_lang) RETURNING l_np0des
              WHEN  3
                 CALL cl_getmsg('anm-214',g_lang) RETURNING l_np0des
              WHEN  4
                 CALL cl_getmsg('anm-212',g_lang) RETURNING l_np0des #no.7277
               #add 030213 NO.A048
              WHEN  5
                 CALL cl_getmsg('gnm-001',g_lang) RETURNING l_np0des
              OTHERWISE EXIT CASE
           END CASE
       WHEN 'AR'
           CALL cl_getmsg('anm-204',g_lang) RETURNING l_sysdes
           CASE g_argv2
              WHEN  1
                 CALL cl_getmsg('anm-208',g_lang) RETURNING l_np0des
              WHEN  2
                 CALL cl_getmsg('anm-204',g_lang) RETURNING l_np0des
              WHEN  3
                 CALL cl_getmsg('anm-209',g_lang) RETURNING l_np0des
               #modify 030213 NO.A048
              WHEN  4
#check過程式, 原AR npp00 = '4', 應該沒有用到, 故拿來期末調匯用.
#                CALL cl_getmsg('anm-210',g_lang) RETURNING l_np0des
                 CALL cl_getmsg('gnm-001',g_lang) RETURNING l_np0des
              WHEN  5
                 CALL cl_getmsg('anm-211',g_lang) RETURNING l_np0des
              WHEN  41
                 CALL cl_getmsg('axr-051',g_lang) RETURNING l_np0des
              WHEN  43
                 CALL cl_getmsg('axr-052',g_lang) RETURNING l_np0des
              OTHERWISE EXIT CASE
           END CASE
       WHEN 'FA'
           CALL cl_getmsg('afa-366',g_lang) RETURNING l_sysdes
           LET g_argv2 = g_npp.npp00   #FUN-660165 add
           CASE g_argv2
              WHEN  1    #資本化
                 CALL cl_getmsg('afa-014',g_lang) RETURNING l_np0des
              WHEN  2    #部門移轉
                 CALL cl_getmsg('afa-016',g_lang) RETURNING l_np0des
              WHEN  4    #出售
                 CALL cl_getmsg('afa-017',g_lang) RETURNING l_np0des
              WHEN  5    #報廢
                 CALL cl_getmsg('afa-018',g_lang) RETURNING l_np0des
              WHEN  6    #銷帳
                 CALL cl_getmsg('afa-019',g_lang) RETURNING l_np0des
              WHEN  7    #改良
                 CALL cl_getmsg('afa-020',g_lang) RETURNING l_np0des
              WHEN  8    #重估
                 CALL cl_getmsg('afa-021',g_lang) RETURNING l_np0des
              WHEN  9    #調整
                 CALL cl_getmsg('afa-022',g_lang) RETURNING l_np0des
              WHEN  10   #折舊
                 CALL cl_getmsg('afa-365',g_lang) RETURNING l_np0des
              #No.9057
              WHEN  11   #利息資本化
                 CALL cl_getmsg('afa-500',g_lang) RETURNING l_np0des
              #No.9057(end)
             #start FUN-660165 add
              WHEN  12   #保險
                 CALL cl_getmsg('afa-501',g_lang) RETURNING l_np0des
             #end FUN-660165 add
              #No:A099
              WHEN  13   #減值準備
                 CALL cl_getmsg('afa-052',g_lang) RETURNING l_np0des
              #end No:A099
              #FUN-BC0035---beging add
              WHEN  14   #類別異動
                 CALL cl_getmsg('afa-980',g_lang) RETURNING l_np0des        
              #FUN-BC0035---end add      
              OTHERWISE EXIT CASE
           END CASE
      #start FUN-670080 add
       WHEN 'CC'   #成本中心
           CALL cl_getmsg('agl-934',g_lang) RETURNING l_sysdes
           LET g_argv2 = g_npp.npp00
           CASE g_argv2
              WHEN  1   #內部成本
                 CALL cl_getmsg('agl-935',g_lang) RETURNING l_np0des
              WHEN  2   #利潤分攤
                 CALL cl_getmsg('agl-933',g_lang) RETURNING l_np0des
              OTHERWISE EXIT CASE
           END CASE
      #end FUN-670080 add
      #start FUN-660165 add
       WHEN 'CA'   #成本分錄
           CALL cl_getmsg('axc-530',g_lang) RETURNING l_sysdes
           LET g_argv2 = g_npp.npp00
           CASE g_argv2
              WHEN  1   #成本分錄
                 CALL cl_getmsg('axc-530',g_lang) RETURNING l_np0des
              #FUN-AA0025 --begin
              WHEN  2   #发料成本分錄
                 CALL cl_getmsg('axc-800',g_lang) RETURNING l_np0des
              WHEN  3   #入库成本分錄
                 CALL cl_getmsg('axc-801',g_lang) RETURNING l_np0des
              WHEN  4   #销货成本分錄
                 CALL cl_getmsg('axc-802',g_lang) RETURNING l_np0des
              WHEN  5   #盘赢亏成本分錄
                 CALL cl_getmsg('axc-803',g_lang) RETURNING l_np0des
              WHEN  6   #杂项进出成本分錄
                 CALL cl_getmsg('axc-804',g_lang) RETURNING l_np0des
              WHEN  7   #杂项进出差异成本分錄
                 CALL cl_getmsg('axc-805',g_lang) RETURNING l_np0des
              WHEN  8   #制造费用成本分录
                 CALL cl_getmsg('axc-806',g_lang) RETURNING l_np0des
              #FUN-AA0025 --end
              #FUN-BB0038 --begin
              WHEN  9   #库存成本调整分录
                 CALL cl_getmsg('axc-807',g_lang) RETURNING l_np0des
              #FUN-BB0038 --end

              OTHERWISE EXIT CASE
           END CASE
      #end FUN-660165 add
      #str FUN-780068 add
       WHEN 'CD'   #合併報表
           CALL cl_getmsg('agl-953',g_lang) RETURNING l_sysdes
           LET g_argv2 = g_npp.npp00
           CASE g_argv2
              WHEN  1   #長期投資認列
                 CALL cl_getmsg('agl-954',g_lang) RETURNING l_np0des
              OTHERWISE EXIT CASE
           END CASE
      #end FUN-780068 add
      #start FUN-690134 add
       WHEN 'PY'   #人事
#           CALL cl_getmsg('apy-152',g_lang) RETURNING l_sysdes         #CHI-B40058
           CALL cl_getmsg('sub-229',g_lang) RETURNING l_sysdes          #CHI-B40058
           LET g_argv2 = g_npp.npp00
           CASE g_argv2
              WHEN 1    #應付薪資
#                 CALL cl_getmsg('apy-153',g_lang) RETURNING l_np0des   #CHI-B40058
                 CALL cl_getmsg('sub-230',g_lang) RETURNING l_np0des    #CHI-B40058
              WHEN 2    #退休金準備
#                 CALL cl_getmsg('apy-154',g_lang) RETURNING l_np0des   #CHI-B40058
                 CALL cl_getmsg('sub-231',g_lang) RETURNING l_np0des    #CHI-B40058
              WHEN 3    #止付薪資
#                 CALL cl_getmsg('apy-155',g_lang) RETURNING l_np0des   #CHI-B40058
                 CALL cl_getmsg('sub-232',g_lang) RETURNING l_np0des    #CHI-B40058
              WHEN 4    #獨立薪資
#                 CALL cl_getmsg('apy-156',g_lang) RETURNING l_np0des   #CHI-B40058
                 CALL cl_getmsg('sub-233',g_lang) RETURNING l_np0des    #CHI-B40058
              OTHERWISE EXIT CASE
           END CASE
      #end FUN-690134 add
       OTHERWISE EXIT CASE
   END CASE
#-->取總帳系統參數
   #LET l_sql = "SELECT aaz72  FROM ",g_dbs_gl CLIPPED,
   #            "aaz_file WHERE aaz00 = '0' "
   LET l_sql = "SELECT aaz72  FROM ",cl_get_target_table(g_plant_gl,'aaz_file'), #FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql #FUN-A50102
   PREPARE chk_pregl FROM l_sql
   DECLARE chk_curgl CURSOR FOR chk_pregl
   OPEN chk_curgl
   FETCH chk_curgl INTO g_aaz72
   IF SQLCA.sqlcode THEN LET g_aaz72 = '1' END IF

   #No.FUN-670047 --start--
   IF g_aza.aza63 = 'Y' THEN
#No.TQC-6C0071 --begin
#     LET l_sql = "SELECT aznn02,aznn04 FROM ",g_dbs_gl CLIPPED,
#                 "aznn_file WHERE aznn01 = '",g_npp.npp03,"'",
#                 "           AND aznn00 = '",g_argv5,"'"
      IF NOT cl_null(g_argv5) THEN
         #LET l_sql = "SELECT aznn02,aznn04 FROM ",g_dbs_gl CLIPPED,
         LET l_sql = "SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_gl,'aznn_file'), #FUN-A50102
                     " WHERE aznn01 = '",g_npp.npp02,"'",
                    #"aznn_file WHERE aznn01 = '",g_npp.npp03,"'",               #CHI-A30021 mark
         #            "aznn_file WHERE aznn01 = '",g_npp.npp02,"'",               #CHI-A30021 add
                     "           AND aznn00 = '",g_argv5,"'"
      ELSE
         #LET l_sql = "SELECT aznn02,aznn04 FROM ",g_dbs_gl CLIPPED,
                    #"aznn_file WHERE aznn01 = '",g_npp.npp03,"'",               #CHI-A30021 mark
         #            "aznn_file WHERE aznn01 = '",g_npp.npp02,"'",               #CHI-A30021 add
         LET l_sql = "SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_gl,'aznn_file'), #FUN-A50102
                     " WHERE aznn01 = '",g_npp.npp02,"'",
                     "           AND aznn00 = '",g_npp.npp07,"'"
      END IF
#No.TQC-6C0071 --end
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql #FUN-A50102
      PREPARE azn_p1 FROM l_sql
      DECLARE azn_c1 CURSOR FOR azn_p1
      OPEN azn_c1
      FETCH azn_c1 INTO g_azn02,g_azn04
   ELSE
   #No.FUN-670047 --end--
      SELECT azn02,azn04 INTO g_azn02,g_azn04  FROM azn_file
                   #WHERE azn01 = g_npp.npp03     #(傳票日)          #CHI-A30021 mark
                    WHERE azn01 = g_npp.npp02     #(傳票日)          #CHI-A30021 add
   END IF  #No.FUN-670047
   IF SQLCA.sqlcode THEN LET g_azn02 = NULL LET g_azn04 = NULL END IF
   DISPLAY l_sysdes,l_np0des,g_azn02,g_azn04 TO sysdes,np0des,azn02,azn04
   #No.FUN-730020  --Begin
#  CALL s_get_bookno1(YEAR(g_npp.npp02),g_dbs_gl)     #TQC-740042 #FUN-980020 mark
   CALL s_get_bookno1(YEAR(g_npp.npp02),g_plant_gl)   #FUN-980020
        RETURNING g_flag,g_bookno11,g_bookno22
   ##-----No:No.TQC-BB0087 add STR-----  
   IF g_argv1='FA' THEN
      LET g_bookno22=g_faa.faa02c
   END IF
   ##-----No:No.TQC-BB0087 add END-----         
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(g_npp.npp02,'aoo-081',1)
   END IF
   #No.TQC-970148  --Begin
   #IF cl_null(g_argv8) THEN LET g_argv8=g_npp.npptype END IF   #FUN-780068 add
   #IF g_argv8 =  '0' THEN
   #   LET g_bookno33 = g_bookno11
   #ELSE
   #   LET g_bookno33 = g_bookno22
   #END IF
   #若g_argv8為null時,會被賦值,不會再根據當前是主帳套還是次帳套做帳套重新賦值
   #所以現在修改方法為,若argv8為null(axci100),則將當前畫面的npptype來決定
   IF NOT cl_null(g_argv8) THEN
      IF g_argv8 =  '0' THEN
         LET g_bookno33 = g_bookno11
      ELSE
         LET g_bookno33 = g_bookno22
      END IF
   ELSE
      IF g_npp.npptype =  '0' THEN
         LET g_bookno33 = g_bookno11
      ELSE
         LET g_bookno33 = g_bookno22
      END IF
   END IF
   #No.TQC-970148  --End
   #No.FUN-730020  --End
   CALL s_fsgl_b_fill()
   CALL s_fsgl_chk()
END FUNCTION

FUNCTION s_fsgl_b_fill()
    DECLARE npq_curs CURSOR FOR
           #start FUN-5B0097
           #SELECT npq02,npq03,aag02,npq05,npq06,npq07f,npq07,npq21,
           #       npq22,npq23,npq24,npq25,npq15,npq08,npq04,npq11,
           #       npq12,npq13,npq14,
           #       npq31,npq32,npq33,npq34,npq35,npq36,npq37 #FUN-5C0015 BY GILL
            #SELECT npq02,npq03,aag02,npq05,npq06,npq24,npq25,npq07f,npq07,   #FUN-810082
            SELECT npq02,npq03,aag02,npq05,'',npq06,npq24,npq25,npq07f,npq07,   #FUN-810082
                   npq21,npq22,npq23,npq08,npq35,npq36,npq11,npq12,npq13,npq14,    #FUN-810045 npq35/36移到npq08後 #No.FUN-840006 npq23之后去掉npq15
                   npq31,npq32,npq33,npq34,npq37 #FUN-5C0015 BY GILL                     #FUN-810045 npq35/36移到npq08後
                  ,npq04
           #end FUN-5B0097
              FROM npq_file LEFT OUTER JOIN aag_file ON npq_file.npq03 = aag_file.aag01 AND aag_file.aag00 = g_bookno33
             WHERE npqsys = g_npp.nppsys AND npq00 = g_npp.npp00
               AND npq01  = g_npp.npp01  AND npq011= g_npp.npp011
#              AND npqtype = g_argv8  #No.FUN-670047
               AND npqtype = g_npp.npptype  #No.FUN-670047
#            ORDER BY 1  #No.FUN-670047 mark
             ORDER BY npq02

#genero add
    CALL g_npq.clear()
##
    LET g_cnt = 1
    LET g_npq07f_t1 = 0   LET g_npq07f_t2 = 0
    LET g_npq07_t1 = 0    LET g_npq07_t2 = 0

    FOREACH npq_curs INTO g_npq[g_cnt].*              #單身 ARRAY 填充
        IF STATUS THEN
#NO.FUN-72003-------begin
           IF g_bgerr THEN
              CALL s_errmsg('','','foreach:',STATUS,1)
           ELSE
              CALL cl_err('foreach:',STATUS,1)
           END IF
#NO.FUN-720003-------end
        EXIT FOREACH END IF
        #-----FUN-810082---------
        SELECT gem02 INTO g_npq[g_cnt].npq05_d FROM gem_file
          WHERE gem01 = g_npq[g_cnt].npq05
            AND gem05 = 'Y'       #MOD-B50004
        #-----END FUN-810082-----

#str----add by huanglf161009
    SELECT ROUND(g_npq[g_cnt].npq07f,2) INTO g_npq[g_cnt].npq07f FROM dual
  #  LET g_npq[g_cnt].npq07f = cl_digcut(g_npq[g_cnt].npq07f,2)
#str----end by huanglf161009
        LET g_cnt = g_cnt + 1
        #No.TQC-630109 --start--
        IF g_cnt > g_max_rec THEN
#NO.FUN-720003------begin
           IF g_bgerr THEN
              CALL s_errmsg('','','', 9035, 0 )
           ELSE
              CALL cl_err( '', 9035, 0 )
           END IF
#NO.FUN-720003-------end
           EXIT FOREACH
        END IF
        #No.TQC-630109 ---end---


    END FOREACH
    #CKP
    CALL g_npq.deleteElement(g_cnt)
    LET g_rec_b= g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

#start FUN-670080 add
FUNCTION s_fsgl_r()
    DEFINE l_cnt LIKE type_file.num5                         #MOD-C20026 add

   #----------------MOD-C30030--------------start
    SELECT * INTO g_npp.* FROM npp_file
     WHERE npp00=g_npp.npp00
       AND npp01=g_npp.npp01
       AND npp011=g_npp.npp011
       AND nppsys=g_npp.nppsys
       AND npptype=g_npp.npptype
   #----------------MOD-C30030-----------------end

    IF s_shut(0) THEN RETURN END IF
    IF g_npp.npp00 IS NULL  OR g_npp.npp01 IS NULL OR
       g_npp.npp011 IS NULL OR g_npp.nppsys IS NULL THEN
#NO.FUN-720003------begin
       IF g_bgerr THEN
          CALL s_errmsg('','','',-400,0)
       ELSE
          CALL cl_err('',-400,0)
       END IF
#NO.FUN-720003-------end
      RETURN
    END IF
    #-->已產生傳票不可修改
    IF NOT cl_null(g_npp.nppglno) THEN
#NO.FUN-720003------begin
       IF g_bgerr THEN
          CALL s_errmsg('','',g_npp.npp01,'aap-145',0)
       ELSE
          CALL cl_err(g_npp.npp01,'aap-145',0)
       END IF
#NO.FUN-720003-------end
     RETURN
    END IF

   #LET g_forupd_sql = " SELECT * FROM npp_file WHERE npp00=? AND npp01=? AND npp011=? AND nppsys=? AND npptype=? FOR UPDATE  "
   #DECLARE s_fsgl_cl CURSOR FROM g_forupd_sql

    BEGIN WORK

    OPEN s_fsgl_cl USING g_npp.npp00,g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npptype
    IF STATUS THEN
#NO.FUN-720003-------begin
       IF g_bgerr THEN
          CALL s_errmsg('','',"OPEN s_fsgl_cl:",STATUS, 1)
       ELSE
          CALL cl_err("OPEN s_fsgl_cl:", STATUS, 1)
       END IF
#NO.FUN-720003-------end
       CLOSE s_fsgl_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH s_fsgl_cl INTO g_npp.*
    IF SQLCA.sqlcode THEN
#NO.FUN-720003--------begin
       IF g_bgerr THEN
          CALL s_errmsg('','',g_npp.npp01,SQLCA.sqlcode,0)
       ELSE
          CALL cl_err(g_npp.npp01,SQLCA.sqlcode,0)
       END IF
#NO.FUN-720003--------end
       CLOSE s_fsgl_cl
       ROLLBACK WORK
       RETURN
    END IF

    IF NOT cl_delh(20,16) THEN RETURN END IF
    DELETE FROM npp_file WHERE npp00  =g_npp.npp00
                           AND npp01  =g_npp.npp01
                           AND npp011 =g_npp.npp011
                           AND nppsys =g_npp.nppsys
                           AND npptype=g_npp.npptype     #No.FUN-670047
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#NO.FUN-720003-------begin
       IF g_bgerr THEN
          LET g_showmsg=g_npp.npp00,"/",g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npptype
          CALL s_errmsg('npp0,npp01,npp011,nppsys,npptype',g_showmsg,"del npp",SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("del","npp_file",g_npp.npp00,g_npp.npp01,SQLCA.sqlcode,"","del npp",1)
       END IF
#NO.FUN-720003-------end
       LET g_success = 'N'
    END IF

    DELETE FROM npq_file WHERE npq00  =g_npp.npp00
                           AND npq01  =g_npp.npp01
                           AND npq011 =g_npp.npp011
                           AND npqsys =g_npp.nppsys
                           AND npqtype=g_npp.npptype     #No.FUN-670047
    IF SQLCA.sqlcode THEN
#NO.FUN-720003--------begin
       IF g_bgerr THEN
          LET g_showmsg=g_npp.npp00,"/",g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npptype
          CALL s_errmsg('npp0,npp01,npp011,nppsys,npptype',g_showmsg,"del npp",SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("del","npq_file",g_npp.npp00,g_npp.npp01,SQLCA.sqlcode,"","del npq",1)
       END IF
#NO.FUN-720003-------end
       LET g_success = 'N'
    END IF

#FUN-B40056---add--str--
    DELETE FROM tic_file WHERE tic01 = YEAR(g_npp.npp02)
                           AND tic02 = MONTH(g_npp.npp02)
                           AND tic04 = g_npp.npp01 
    IF SQLCA.sqlcode THEN
       IF g_bgerr THEN
          LET g_showmsg=YEAR(g_npp.npp02),"/",MONTH(g_npp.npp02),"/",g_npp.npp01
          CALL s_errmsg('tic01,tic02,tic04',g_showmsg,"del tic",SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("del","tic_file",g_npp.npp01,g_npp.npp02,SQLCA.sqlcode,"","del tic",1)
       END IF
       LET g_success = 'N'
    END IF   
#FUN-B40056---add--end-- 

#NO.CHI-A30029-------start
    IF g_npp.nppsys='FA' AND g_npp.npp00='10' THEN
      #-----------------------MOD-C20026----------------------start
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt
         FROM fan_file
        WHERE fan19 = g_npp.npp01
       IF cl_null(l_cnt) THEN LET l_cnt = 0  END IF
       IF l_cnt > 0 THEN
      #-----------------------MOD-C20026------------------------end
          UPDATE fan_file SET fan19=''
           WHERE fan19=g_npp.npp01
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             IF g_bgerr THEN
                CALL s_errmsg('fan19',g_npp.npp01,"upd fan",SQLCA.sqlcode,1)
             ELSE
                CALL cl_err3("upd","fan_file",g_npp.npp01,"",SQLCA.sqlcode,"","upd fan",1)
             END IF
             LET g_success = 'N'
          END IF
       END IF                                #MOD-C20026 add
    END IF
#NO.CHI-A30029-------end

    IF g_npp.nppsys='CC' AND g_npp.npp00='2' THEN
       UPDATE ahj_file SET ahj18=''
                     WHERE ahj18=g_npp.npp01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#NO.FUN-720003------begin
          IF g_bgerr THEN
             CALL s_errmsg('ahj18',g_npp.npp01,"upd ahj",SQLCA.sqlcode,1)
          ELSE
             CALL cl_err3("upd","ahj_file",g_npp.npp01,"",SQLCA.sqlcode,"","upd ahj",1)
          END IF
#NO.FUN-720003------end
          LET g_success = 'N'
       END IF
    END IF

    CLEAR FORM
    CALL g_npq.clear()

    MESSAGE ""
    OPEN s_fsgl_count
    #FUN-B50065-add-start--
    IF STATUS THEN
       CLOSE s_fsgl_cs
       CLOSE s_fsgl_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50065-add-end--
    FETCH s_fsgl_count INTO g_row_count
    #FUN-B50065-add-start--
    IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
       CLOSE s_fsgl_cs
       CLOSE s_fsgl_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50065-add-end--
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN s_fsgl_cs
    IF g_curs_index = g_row_count + 1 THEN
       LET g_jump = g_row_count
       CALL s_fsgl_fetch('L')
    ELSE
       LET g_jump = g_curs_index
       LET mi_no_ask = TRUE             #No.FUN-6A0079
       CALL s_fsgl_fetch('/')
    END IF

    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF

    CLOSE s_fsgl_cl
END FUNCTION
#end FUN-670080 add

FUNCTION s_fsgl_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)
   DEFINE   l_nmz70         LIKE nmz_file.nmz70   #FUN-B40056


   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b)

      #-----MOD-9C0273---------
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #FUN-B40056--add--str--
         SELECT nmz70 INTO l_nmz70 FROM nmz_file
         CALL cl_set_act_visible("flows",l_nmz70 = '3')
         #FUN-B40056 --end--
      #-----END MOD-9C0273-----

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
     #ON ACTION query
     #   LET g_action_choice="query"
     #   EXIT DISPLAY
     #ON ACTION delete
     #   LET g_action_choice="delete"
     #   EXIT DISPLAY
     #ON ACTION first
     #   LET g_action_choice="first"
     #   EXIT DISPLAY
     #ON ACTION previous
     #   LET g_action_choice="previous"
     #   EXIT DISPLAY
     #ON ACTION jump
     #   LET g_action_choice="jump"
     #   EXIT DISPLAY
     #ON ACTION next
     #   LET g_action_choice="next"
     #   EXIT DISPLAY
     #ON ACTION last
     #   LET g_action_choice="last"
     #   EXIT DISPLAY
#No.FUN-A10006 --begin
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
#No.FUN-A10006 --end
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      #FUN-B40056--add--str--
      ON ACTION flows      #現金流量明細
         LET g_action_choice="flows"
         EXIT DISPLAY
      #FUN-B40056--add--end--

#No.TQC-770048--begin
#    #start FUN-670080 add
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY

     #yemy 20130608  --Begin  unmark
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#No.TQC-770048--end
     #yemy 20130608  --End    unmark

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     #end FUN-670080 add

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
#        LET INT_FLAG = 0
         EXIT DISPLAY

     #ON IDLE 5
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---

#No.FUN-6B0033 --START
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY
#No.FUN-6B0033 --END

      #FUN-7C0050
      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#start FUN-670080 add
FUNCTION s_fsgl_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)

   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION first
         CALL s_fsgl_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION previous
         CALL s_fsgl_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION jump
         CALL s_fsgl_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION next
         CALL s_fsgl_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION last
         CALL s_fsgl_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      #@ON ACTION 明細查詢
      ON ACTION query_detail
         LET g_action_choice = "query_detail"
         LET g_npq_t.* = g_npq[l_ac].*
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

     #ON IDLE 5
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---

#No.FUN-6B0033 --START
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY
#No.FUN-6B0033 --END
      #FUN-7C0050
      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#end FUN-670080 add

#start FUN-660165 add
FUNCTION s_fsgl_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)

   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION first
         CALL s_fsgl_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION previous
         CALL s_fsgl_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION jump
         CALL s_fsgl_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION next
         CALL s_fsgl_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION last
         CALL s_fsgl_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

#No.FUN-6B0033 --START
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY
#No.FUN-6B0033 --END

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
      #FUN-7C0050
      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#end FUN-660165 add

#start FUN-690134 add
FUNCTION s_fsgl_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)

   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION first
         CALL s_fsgl_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION previous
         CALL s_fsgl_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION jump
         CALL s_fsgl_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION next
         CALL s_fsgl_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION last
         CALL s_fsgl_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY

      ON ACTION carry_voucher
         LET g_action_choice = "carry_voucher"
         EXIT DISPLAY

      ON ACTION undo_carry
         LET g_action_choice = "undo_carry"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
        #LET g_action_choice="detail"   #FUN-690134 mark
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE             #MOD-570244     mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION related_document                #No.FUN-6A0017  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY

      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---

#No.FUN-6B0033 --START
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY
#No.FUN-6B0033 --END
      #FUN-7C0050
      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#end FUN-690134 add

#str FUN-910001 add
FUNCTION s_fsgl_bp4(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION first
         CALL s_fsgl_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL s_fsgl_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL s_fsgl_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL s_fsgl_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN             CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#end FUN-910001 add

FUNCTION s_fsgl_chk()
    SELECT SUM(npq07f),SUM(npq07) INTO g_npq07f_t1,g_npq07_t1 FROM npq_file
     WHERE npqsys =g_npp.nppsys AND npq00 =g_npp.npp00
       AND npq01  =g_npp.npp01  AND npq011=g_npp.npp011 AND npq06='1'
       AND npqtype = g_npp.npptype  #No.FUN-670047
    SELECT SUM(npq07f),SUM(npq07) INTO g_npq07f_t2,g_npq07_t2 FROM npq_file
     WHERE npqsys =g_npp.nppsys AND npq00 =g_npp.npp00
       AND npq01  =g_npp.npp01  AND npq011=g_npp.npp011 AND npq06='2'
       AND npqtype = g_npp.npptype  #No.FUN-670047
    #yinhy130619  --Begin
    IF cl_null(g_npq07f_t1) THEN LET g_npq07f_t1 = 0 END IF
    IF cl_null(g_npq07_t1) THEN LET g_npq07_t1 = 0  END IF
    IF cl_null(g_npq07f_t2) THEN LET g_npq07f_t2 = 0 END IF
    IF cl_null(g_npq07_t2) THEN LET g_npq07_t2 = 0  END IF
    #yinhy130619  --End
    #str----add by huanglf161009
    --SELECT ROUND(g_npq07f_t1,2) INTO g_npq07f_t1 FROM dual
    --SELECT ROUND(g_npq07_t1,2) INTO g_npq07_t1 FROM dual
    --SELECT ROUND(g_npq07f_t2,2) INTO g_npq07f_t2 FROM dual
    --SELECT ROUND(g_npq07_t2,2) INTO g_npq07_t2 FROM dual
    #str----end by huanglf161009
    DISPLAY g_npq07f_t1,g_npq07_t1,g_npq07f_t2,g_npq07_t2
         TO npq07f_t1,npq07_t1,npq07f_t2,npq07_t2
END FUNCTION

FUNCTION s_fsgl_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #No.FUN-680147 SMALLINT     #未取消的ARRAY CNT
    l_row,l_col     LIKE type_file.num5,         #No.FUN-680147 SMALLINT   #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,         #No.FUN-680147 SMALLINT   #檢查重複用
    l_lock_sw       LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(01) #單身鎖住否
    p_cmd           LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(01)    #處理狀態
    l_b2     	    LIKE npp_file.npp01,         #No.FUN-680147 VARCHAR(30)
    l_str           LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(80)
    l_buf           LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(40)
    l_buf1          LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(40)
    l_cmd           LIKE npp_file.npp01,         #No.FUN-680147 VARCHAR(20)
    l_flag          LIKE type_file.num10,        #No.FUN-680147 INTEGER
    l_flag2         LIKE type_file.num10,        #TQC-7B0006用來判斷是否為AP-13/17類帳款
    l_t1            LIKE apy_file.apyslip,       #TQC-7B0006
    l_afb04         LIKE afb_file.afb04,
    l_afb07         LIKE afb_file.afb07,
    l_afb15         LIKE afb_file.afb15,
    l_afb041        LIKE afb_file.afb041,        #FUN-810069
    l_afb042        LIKE afb_file.afb042,        #FUN-810069
    l_amt           LIKE npq_file.npq07,
    l_tol           LIKE npq_file.npq07,
    l_tol1          LIKE npq_file.npq07,
    total_t         LIKE npq_file.npq07,
    #t_azi04         LIKE azi_file.azi04,          #No.CHI-6A0004   #MOD-770076
    l_dept          LIKE gem_file.gem01,
    l_nmg20         LIKE nmg_file.nmg20,
    l_allow_insert  LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_allow_delete  LIKE type_file.num5,         #No.FUN-680147 SMALLINT   #可刪除否
    l_oob04         LIKE oob_file.oob04   #No.MOD-530748
DEFINE   l_pjb09    LIKE pjb_file.pjb09   #No.MOD-8C0274
DEFINE   l_pjb11    LIKE pjb_file.pjb11   #No.MOD-8C0274
DEFINE   l_npq25    LIKE npq_file.npq25   #No.FUN-9A0036
DEFINE l_aaa03      LIKE aaa_file.aaa03   #FUN-A40067
DEFINE l_minus      LIKE apy_file.apydmy6 #CHI-A70041 add
DEFINE l_aag42      LIKE aag_file.aag42   #CHI-A70041 add
DEFINE l_sumf       LIKE abb_file.abb07f  #MOD-A80173
DEFINE l_sum        LIKE abb_file.abb07   #MOD-A80173
DEFINE l_azi01      LIKE azi_file.azi01   #No.TQC-B10154
DEFINE l_sw         LIKE type_file.chr1   #No.TQC-B10154
DEFINE l_npq31      LIKE npq_file.npq31   #FUN-AA0087 add
DEFINE l_npq32      LIKE npq_file.npq32   #FUN-AA0087 add
DEFINE l_npq33      LIKE npq_file.npq33   #FUN-AA0087 add
DEFINE l_npq34      LIKE npq_file.npq34   #FUN-AA0087 add
DEFINE l_fld_name   LIKE type_file.chr10  #FUN-AC0063 add
DEFINE l_flag1      LIKE type_file.chr1    #FUN-D40118 add
DEFINE l_aag44      LIKE aag_file.aag44    #FUN-D40118 add

    LET g_action_choice = ""
    IF g_npp.npp01 IS NULL THEN RETURN END IF
    #-->已產生傳票不可修改
    IF NOT cl_null(g_npp.nppglno) THEN
#NO.FUN-720003-------begin
      ##-----No.MOD-910004 Mark-----
      #IF g_bgerr THEN
      #   CALL s_errmsg('','',g_npp.npp01,'aap-145',0)
      #ELSE
          CALL cl_err(g_npp.npp01,'aap-145',0)
      #END IF
      ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-------end
       RETURN
    END IF
    #-->此單據已確認
    IF g_argv7 matches '[Yy]' THEN
#NO.FUN-720003-------begin
      ##-----No.MOD-910004 Mark-----
      #IF g_bgerr THEN
      #   CALL s_errmsg('','',g_npp.npp01,'aap-005',0)
      #ELSE
          CALL cl_err(g_npp.npp01,'aap-005',0)
      #END IF
      ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-------end
       RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql = " SELECT npq02,npq03,'',npq05,'',npq06,npq24,npq25, ",   #FUN-810082
                       " npq07f,npq07,npq21,npq22,npq23,npq08,npq35,npq36, ",   #FUN-810045 npq35/36移到npq08之後 #No.FUN-840006 npq23之后去掉npq15
                       " npq11,npq12,npq13,npq14, ",
                       " npq31,npq32,npq33,npq34,npq37 ",                       #FUN-810045 npq35/36移到npq08之後
                       ",npq04 ",
                       " FROM npq_file ",
                       " WHERE npqsys = ? AND npq00 = ? AND npq01 = ? ",
                       " AND npq011 = ? AND npq02 = ? AND npqtype = ? FOR UPDATE"  #No.FUN-670047 增加npqtype   #CHI-880014 mod
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE s_fsgl_bcl CURSOR  FROM g_forupd_sql      # LOCK CURSOR

      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")

     IF g_rec_b=0 THEN CALL g_npq.clear() END IF
 
      INPUT ARRAY g_npq WITHOUT DEFAULTS FROM s_npq.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            #-----MOD-6C0188---------
            #LET g_before_input_done = FALSE
            #CALL s_fsgl_set_entry_b(p_cmd)
            #CALL s_fsgl_set_no_entry_b(p_cmd)
            #CALL s_fsgl_set_no_required()   #MOD-680003
            #CALL s_fsgl_set_required()   #MOD-680003
            #LET g_before_input_done = TRUE
            #-----END MOD-6C0188-----
            #-----TQC-7B0006---------
            IF g_npp.nppsys = 'AP' THEN
               LET l_flag2 = 0
               LET l_cnt = 0
               LET l_t1 = s_get_doc_no(g_npp.npp01)
               SELECT COUNT(*) INTO l_cnt FROM apy_file
                #WHERE apyslip = l_t1 AND (apykind = '13' OR apykind = '17')    #MOD-C20077 mark
                 WHERE apyslip = l_t1 AND apykind IN('13','17','34')            #MOD-C20077 add
               IF l_cnt > 0 THEN
                  LET l_flag2 = 1
               END IF
            END IF
            #-----END TQC-7B0006-----
            #CHI-A70041 add --start--
            IF g_npp.nppsys ='NM' OR g_npp.nppsys ='AR' THEN
               LET l_t1 = s_get_doc_no(g_npp.npp01)
            END IF
            LET l_minus = 'N'
            LET l_aag42 ='N'
            CASE g_npp.nppsys
                WHEN 'AP'
                   SELECT apydmy6 INTO l_minus FROM apy_file WHERE apyslip = l_t1
                WHEN 'NM'
                   SELECT nmydmy5 INTO l_minus FROM nmy_file WHERE nmyslip = l_t1
                WHEN 'AR'
                   SELECT ooydmy2 INTO l_minus FROM ooy_file WHERE ooyslip = l_t1
                OTHERWISE
                   LET l_minus = 'N'
             END CASE
             IF cl_null(l_minus) THEN LET l_minus = 'N' END IF
            #CHI-A70041 add --end--
            
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            #DISPLAY l_ac TO FORMONLY.cnt   #MOD-550169   #MOD-6C0091
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_success='Y'
#FUN-950053 ----------------------------add  start----------------------------------
           #-MOD-B10192-mark- 
           #IF g_argv1 = 'AP' THEN
           #  SELECT pmc903 INTO g_pmc903
           #    FROM pmc_file,apa_file
           #   WHERE pmc_file.pmc01 = apa_file.apa05
           #     AND apa_file.apa01 = g_argv3
           #END IF
           #IF g_argv1 = 'AR' THEN
           #   SELECT occ37 INTO g_occ37
           #     FROM occ_file,oma_file
           #    WHERE occ_file.occ01 = oma_file.oma03
           #      AND oma_file.oma01 = g_argv3
           #END IF
           #-MOD-B10192-end- 
#FUN-950053 --------------------------add end------------------------------------------
            BEGIN WORK
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_npq_t.* = g_npq[l_ac].*  #BACKUP
               OPEN s_fsgl_bcl USING g_npp.nppsys, g_npp.npp00,
                                     g_npp.npp01 , g_npp.npp011,
                                     g_npq_t.npq02,g_npp.npptype  #No.FUN-670047 增加g_npp.npptype
               IF STATUS THEN
#NO.FUN-720003--------begin
                 ##-----No.MOD-910004 Mark-----
                 #IF g_bgerr THEN
                 #   CALL s_errmsg('','',"OPEN s_fsgl_bcl:", STATUS, 1)
                 #ELSE
                     CALL cl_err("OPEN s_fsgl_bcl:", STATUS, 1)
                 #END IF
                 ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003--------end
                  CLOSE s_fsgl_bcl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  FETCH s_fsgl_bcl INTO g_npq[l_ac].*
                  IF SQLCA.sqlcode THEN
#NO.FUN-720003----------begin
                    ##-----No.MOD-910004 Mark-----
                    #IF g_bgerr THEN
                    #    CALL s_errmsg('','','lock npq',SQLCA.sqlcode,1)
                    #ELSE
                         CALL cl_err('lock npq',SQLCA.sqlcode,1)
                    #END IF
                    ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003----------end
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT aag02 INTO g_npq[l_ac].aag02 FROM aag_file
                     WHERE aag01=g_npq[l_ac].npq03
                       AND aag00 = g_bookno33  #No.FUN-730020
                  #-----FUN-810082---------
                  SELECT gem02 INTO g_npq[l_ac].npq05_d FROM gem_file
                     WHERE gem01 = g_npq[l_ac].npq05
                       AND gem05 = 'Y'       #MOD-B50004
                  #-----END FUN-810082-----
                 #-MOD-B10192-add- 
                  LET g_pmc903 =''           #yinhy130624
                  IF g_argv1 = 'AP' THEN 
                     SELECT pmc903 INTO g_pmc903 
                      FROM pmc_file
                     WHERE pmc_file.pmc01 = g_npq[l_ac].npq21 
                  END IF 
                 #IF g_argv1 = 'AR' THEN                                             #MOD-D20048 mark
                  IF g_argv1 = 'AR' OR (g_argv1 = 'FA' AND g_npp.npp00 = '4')THEN    #MOD-D20048 add
                    SELECT occ37 INTO g_occ37
                      FROM occ_file
                     WHERE occ_file.occ01 = g_npq[l_ac].npq21 
                  END IF
                 #-MOD-B10192-end- 
                 #---------------MOD-C70113---------------(S)
                  IF g_argv1 = 'NM' AND g_argv2 = '3' THEN
                     SELECT nmg20 INTO l_nmg20 FROM nmg_file
                     WHERE nmg00 = g_argv3
                     IF l_nmg20[1,1] = '1' THEN
                        SELECT pmc903 INTO g_pmc903
                         FROM pmc_file
                        WHERE pmc01 = g_npq[l_ac].npq21
                     END IF
                     IF l_nmg20[1,1] = '2' THEN
                        SELECT occ37 INTO g_occ37
                          FROM occ_file
                         WHERE occ01 = g_npq[l_ac].npq21
                     END IF
                     #No.MOD-D40020  --Begin 
                     IF g_aza.aza26='2' THEN
                          IF NOT cl_null(g_npq[l_ac].npq11) THEN
                           IF l_nmg20 = '0 ' THEN
                              SELECT pmc903 INTO g_pmc903  FROM pmc_file WHERE pmc01 = g_npq[l_ac].npq11
                              IF STATUS THEN
                                 SELECT occ37 INTO g_occ37  FROM occ_file WHERE occ01 = g_npq[l_ac].npq11
                              END IF  
                           END IF  
                        END IF  
                     END IF  
                     #No.MOD-D40020  --End
                  END IF
                 #---------------MOD-C70113---------------(E)
               END IF
               #-----MOD-770076---------
               #IF l_ac <= l_n then                   #DISPLAY NEWEST
               #    SELECT azi04 INTO t_azi04 FROM azi_file      #No.CHI-6A0004
               #     WHERE azi01 = g_npq[l_ac].npq24
               #    IF STATUS THEN LET t_azi04 = 0 END IF       #No.CHI-6A0004
               #END IF
               #-----END MOD-770076-----
                #MOD-530812
               LET g_before_input_done = FALSE
               CALL s_fsgl_set_entry_b(p_cmd)
               CALL s_fsgl_set_no_entry_b(p_cmd)
               CALL s_fsgl_set_no_required()   #MOD-680003
               CALL s_fsgl_set_required()   #MOD-680003
               LET g_before_input_done = TRUE
               #--
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
#NO.FUN-720003-------begin
              ##-----No.MOD-910004 Mark-----
              #IF g_bgerr THEN
              #   CALL s_errmsg('','','',9001,0)
              #ELSE
                  CALL cl_err('',9001,0)
              #END IF
              ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-------end
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_npq[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_npq[l_ac].* TO s_npq.*
              CALL g_npq.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
#No.FUN-9A0036 --Begin
            IF g_npp.npptype = '1' THEN
#FUN-A40067 --Begin
              #MOD-C60058---S---
               IF g_npp.nppsys = 'FA' THEN
                  LET g_aza.aza82 = g_faa.faa02c
               ELSE
                  LET g_aza.aza82 = g_aza.aza82
               END IF
              #MOD-C60058---E---
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_aza.aza82
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_aza.aza81,g_aza.aza82,g_npq[l_ac].npq24,
                    l_npq25,g_npp.npp02)
                    RETURNING g_npq[l_ac].npq25
               LET g_npq[l_ac].npq07 = g_npq[l_ac].npq07f * g_npq[l_ac].npq25
#              LET g_npq[l_ac].npq07 = cl_digcut(g_npq[l_ac].npq07,g_azi04) #FUN-A40067
               LET g_npq[l_ac].npq07 = cl_digcut(g_npq[l_ac].npq07,g_azi04_2) #FUN-A40067
            ELSE
               LET g_npq[l_ac].npq07 = cl_digcut(g_npq[l_ac].npq07,g_azi04) #FUN-A40067
            END IF
#No.FUN-9A0036 --End
            INSERT INTO npq_file(npqsys,npq00,npq01,npq011,npq02,npq03,
	         	         npq04,npq05,npq06,npq07f,npq07,npq08,
	         	         npq11,npq12,npq13,npq14,

                                 #FUN-5C0015 BY GILL --START
                                 npq31,npq32,npq33,npq34,npq35,npq36,npq37,
                                 #FUN-5C0015 BY GILL --END

                                 npq21,      #No.FUN-840006 npq21之前去掉npq15
	         	         npq22,npq23,npq24,npq25,npqtype,npqlegal,npq30) #No.FUN-670047 增加npqtype #FUN-980012 增加npqlegal #MOD-BC0115 add npq30
                          VALUES(g_npp.nppsys,g_npp.npp00,g_npp.npp01,
                                 g_npp.npp011,g_npq[l_ac].npq02,
	          		 g_npq[l_ac].npq03,g_npq[l_ac].npq04,
	          		 g_npq[l_ac].npq05,g_npq[l_ac].npq06,
                                 g_npq[l_ac].npq07f,g_npq[l_ac].npq07,
                                 g_npq[l_ac].npq08,g_npq[l_ac].npq11,
                                 g_npq[l_ac].npq12,g_npq[l_ac].npq13,
                                 g_npq[l_ac].npq14,

                                #FUN-5C0015 BY GILL --START
                                g_npq[l_ac].npq31,g_npq[l_ac].npq32,
                                g_npq[l_ac].npq33,g_npq[l_ac].npq34,
                                g_npq[l_ac].npq35,g_npq[l_ac].npq36,
                                g_npq[l_ac].npq37,
                                #FUN-5C0015 BY GILL --END

                                 #g_npq[l_ac].npq15,  #No.FUN-840006 去掉npq15
                                 g_npq[l_ac].npq21,g_npq[l_ac].npq22,
                                 g_npq[l_ac].npq23,g_npq[l_ac].npq24,
                                 g_npq[l_ac].npq25,g_npp.npptype,g_legal,g_plant) #No.FUN-670047 增加g_npp.npptype #FUN-980012 增加npqlegal #MOD-BC0115 add g_plant
            IF SQLCA.sqlcode THEN
               #CALL cl_err('ins npq',SQLCA.sqlcode,1)  #FUN-670091
#NO.FUN-720003------begin
              ##-----No.MOD-910004 Mark-----
              #IF g_bgerr THEN
              #   CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00','','ins npq',SQLCA.sqlcode,1)
              #ELSE
                  CALL cl_err3("ins","npq_file",g_npp.npp01,"",STATUS,"","",1) #FUN-670091
              #END IF
              ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003------end
               LET g_success = 'N'
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            END IF
            IF g_success='Y' THEN
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              MESSAGE 'Insert Ok'
            ELSE
              ROLLBACK WORK
              CANCEL INSERT
            END IF
            CALL s_fsgl_chk()

        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
             #MOD-530812
            LET g_before_input_done = FALSE
            CALL s_fsgl_set_entry_b(p_cmd)
            CALL s_fsgl_set_no_entry_b(p_cmd)
            CALL s_fsgl_set_no_required()   #MOD-680003
            CALL s_fsgl_set_required()   #MOD-680003
            LET g_before_input_done = TRUE
            #==
            LET l_n = ARR_COUNT()
            INITIALIZE g_npq[l_ac].* TO NULL      #900423
            LET g_npq_t.* = g_npq[l_ac].*  #BACKUP
            #-----MOD-680003---------
            ##No.MOD-510119
            #IF g_npq[l_ac].npq05 IS NULL THEN   #No:7935
            #   LET g_npq[l_ac].npq05 = ' '
            #END IF
            #IF g_npq[l_ac].npq21 IS NULL THEN   #No:7935
            #   LET g_npq[l_ac].npq21 = ' '
            #END IF
            #IF g_npq[l_ac].npq22 IS NULL THEN   #No:7935
            #   LET g_npq[l_ac].npq22 = ' '
            #END IF
            #IF g_npq[l_ac].npq24 IS NULL THEN   #No:7935
            #   LET g_npq[l_ac].npq24 = ' '
            #END IF
            ##No.MOD-510119 end
            #-----END MOD-680003-----
            IF l_ac > 1 THEN
               LET g_npq[l_ac].npq21 = g_npq[l_ac-1].npq21  #廠商編號
               LET g_npq[l_ac].npq22 = g_npq[l_ac-1].npq22  #廠商簡稱
               LET g_npq[l_ac].npq23 = g_npq[l_ac-1].npq23  #參考單號
               LET g_npq[l_ac].npq24 = g_npq[l_ac-1].npq24  #幣別
               LET g_npq[l_ac].npq25 = g_npq[l_ac-1].npq25  #匯率
               LET g_npq[l_ac].npq04=g_npq[l_ac-1].npq04    #摘要  #add by huanglf160921
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD npq02

        BEFORE FIELD npq02                       #default 行序
            IF cl_null(g_npq[l_ac].npq02) OR g_npq[l_ac].npq02=0 THEN
               SELECT max(npq02)+1 INTO g_npq[l_ac].npq02 FROM npq_file
                WHERE npqsys = g_npp.nppsys AND npq00 = g_npp.npp00
                  AND npq01  = g_npp.npp01  AND npq011= g_npp.npp011
                  AND npqtype = g_npp.npptype  #FUN-670047
               IF g_npq[l_ac].npq02 IS NULL THEN
                  LET g_npq[l_ac].npq02=1
               END IF
            END IF

        AFTER FIELD npq02                         #check是否重複
            IF NOT cl_null(g_npq[l_ac].npq02) THEN
               IF g_npq[l_ac].npq02 != g_npq_t.npq02 OR
                  g_npq_t.npq02 IS NULL THEN
                  SELECT COUNT(*) INTO g_cnt FROM npq_file
                  WHERE npqsys = g_npp.nppsys AND npq00 = g_npp.npp00
                    AND npq01  = g_npp.npp01  AND npq011= g_npp.npp011
                    AND npq02  = g_npq[l_ac].npq02
                    AND npqtype= g_npp.npptype  #FUN-670047
                  IF g_cnt > 0 THEN
#NO.FUN-720003---------begin
                    ##-----No.MOD-910004 Mark-----
                    #IF g_bgerr THEN
                    #   CALL s_errmsg('','','',-239,0)
                    #ELSE
                        CALL cl_err('',-239,0)
                    #END IF
                    ##-----No.MOD-910004 Mark END-----
                     NEXT FIELD npq02
#NO.FUN-720003---------end
                  END IF
               END IF
            END IF

        #-----MOD-680003---------
        #BEFORE FIELD npq03
        #   CALL s_fsgl_set_entry_b(p_cmd)
        #-----END MOD-680003-----

        AFTER FIELD npq03     #會計科目
            IF NOT cl_null(g_npq[l_ac].npq03) THEN
               SELECT aag02,aag05,aag15,aag16,aag17,aag18,aag151,
                        aag161,aag171,aag181,aag06,aag21,aag23,
                        #FUN-5C0015 BY GILL --START
                        aag31,aag32,aag33,aag34,aag35,aag36,aag37,
                        aag311,aag321,aag331,aag341,aag351,aag361,aag371
                        #FUN-5C0015 BY GILL --END
                   INTO g_npq[l_ac].aag02,l_aag05,l_aag15,l_aag16,
                        l_aag17,l_aag18,l_aag151,l_aag161,l_aag171,
                        l_aag181,l_aag06,l_aag21,l_aag23,
                        #FUN-5C0015 BY GILL --START
                        l_aag31,l_aag32,l_aag33,l_aag34,l_aag35,l_aag36,
                        l_aag37,l_aag311,l_aag321,l_aag331,l_aag341,l_aag351,
                        l_aag361,l_aag371
                        #FUN-5C0015 BY GILL --END
                   FROM aag_file
                WHERE aag01=g_npq[l_ac].npq03
                  AND aag07 !='1'      #不可為統制帳戶 NO:4756
                  AND aag00 = g_bookno33  #No.FUN-730020
                  AND aagacti = 'Y'       #MOD-A90117
               IF STATUS THEN
                  #No.FUN-B10050  --Begin
                  CALL cl_err3("sel","aag_file",g_npq[l_ac].npq03,"",STATUS,"","",0)  #FUN-670091
                  #LET g_npq[l_ac].npq03 = g_npq_t.npq03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_npq[l_ac].npq03
                  LET g_qryparam.arg1 = g_bookno33
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_npq[l_ac].npq03 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq03
                  DISPLAY BY NAME g_npq[l_ac].npq03
                  #No.FUN-B10050  --End  
                  NEXT FIELD npq03
               END IF
                #FUN-D40118--add--str--
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno33
                  AND aag01 = g_npq[l_ac].npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(g_npq[l_ac].npq03,g_bookno33) RETURNING l_flag1
                  IF l_flag1 = 'N' THEN
                     CALL cl_err(g_npq[l_ac].npq03,'agl-285',1)
                     NEXT FIELD npq03
                  END IF
               END IF
               #FUN-D40118--add--end--
               #No.B203 010409 by plum check部門管理aag05
               IF l_aag05 MATCHES '[Nn]' THEN
                   #LET g_npq[l_ac].npq05=' '   #MOD-680003
                   LET g_npq[l_ac].npq05=NULL   #MOD-680003
                   DISPLAY BY NAME g_npq[l_ac].npq05           #No.MOD-510119
               END IF
               #No.B203 ..end

              #FUN-8C0106---add---str---
               IF l_aag05='Y' AND NOT cl_null(g_npq[l_ac].npq05) THEN
                  CALL s_chkdept(g_aaz.aaz72,g_npq[l_ac].npq03,g_npq[l_ac].npq05,g_bookno33) RETURNING g_errno
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
               #  NEXT FIELD npq03          #No.MOD-930091 mark
               END IF
              #FUN-8C0106---add---str---

               #-----MOD-680003---------
               #No.FUN-840006 080407 mark --begin
#              IF l_aag21 MATCHES '[Nn]' THEN
#                  LET g_npq[l_ac].npq15=NULL
#                  DISPLAY BY NAME g_npq[l_ac].npq15
#              END IF
               #No.FUN-840006 080407 mark --end
              #IF l_aag23 MATCHES '[Nn]' THEN                             #MOD-C90254 mark
               IF l_aag23 MATCHES '[Nn]' AND l_aag21 MATCHES '[Nn]' THEN  #MOD-C90254
                   LET g_npq[l_ac].npq08=NULL
                   LET g_npq[l_ac].npq35=NULL  #MOD-8C0274 add
                   DISPLAY BY NAME g_npq[l_ac].npq08
                   DISPLAY BY NAME g_npq[l_ac].npq35  #MOD-8C0274 add
               END IF
               #-----END MOD-680003-----
               IF cl_null(l_aag151) THEN
                  LET g_npq[l_ac].npq11=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq11           #No.MOD-510119
               END IF
               IF cl_null(l_aag161) THEN
                  LET g_npq[l_ac].npq12=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq12           #No.MOD-510119
               END IF
               IF cl_null(l_aag171)  THEN
                  LET g_npq[l_ac].npq13=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq13           #No.MOD-510119
               END IF
               IF cl_null(l_aag181) THEN
                  LET g_npq[l_ac].npq14=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq14           #No.MOD-510119
               END IF

               #FUN-5C0015 BY GILL --START
               IF cl_null(l_aag311) THEN
                  LET g_npq[l_ac].npq31=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq31
               END IF
               IF cl_null(l_aag321) THEN
                  LET g_npq[l_ac].npq32=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq32
               END IF
               IF cl_null(l_aag331) THEN
                  LET g_npq[l_ac].npq33=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq33
               END IF
               IF cl_null(l_aag341) THEN
                  LET g_npq[l_ac].npq34=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq34
               END IF
               #No.MOD-8C0274---Begin
               #IF cl_null(l_aag351) THEN
               #   LET g_npq[l_ac].npq35=NULL
               #    DISPLAY BY NAME g_npq[l_ac].npq35
               #END IF
               #IF cl_null(l_aag361) THEN
               #   LET g_npq[l_ac].npq36=NULL
               #    DISPLAY BY NAME g_npq[l_ac].npq36
               #END IF
               #No.MOD-8C0274---End
               IF cl_null(l_aag371) THEN
                  LET g_npq[l_ac].npq37=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq37
               END IF
               #FUN-5C0015 BY GILL --END
               #No.FUN-830161  --Begin
               CALL s_fsgl_bud()
               IF NOT cl_null(g_errno) THEN
                  #No.FUN-B10050  --Begin
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_npq[l_ac].npq03
                  LET g_qryparam.arg1 = g_bookno33
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_npq[l_ac].npq03 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq03
                  DISPLAY BY NAME g_npq[l_ac].npq03
                  #No.FUN-B10050  --End  
                  NEXT FIELD npq03
               END IF
               #No.FUN-830161  --END IF


            ELSE    #MOD-5B0205
               NEXT FIELD npq03   #MOD-5B0205
            END IF
            #-----MOD-680003---------
            LET g_before_input_done = FALSE
            CALL s_fsgl_set_entry_b(p_cmd)
            CALL s_fsgl_set_no_entry_b(p_cmd)
            CALL s_fsgl_set_no_required()
            CALL s_fsgl_set_required()
            LET g_before_input_done = TRUE

            #CALL s_fsgl_set_no_entry_b(p_cmd)
            ##FUN-5C0015--start
            #CALL s_fsgl_set_no_required()
            #CALL s_fsgl_set_required()
            ##FUN-5C0015--end
            #-----END MOD-680003-----

# genero modify - not sure
#       BEFORE FIELD npq05
#           IF cl_null(g_npq[l_ac].npq03) THEN NEXT FIELD npq03 END IF
#           SELECT aag05 INTO l_aag05  FROM aag_file
#            WHERE aag01=g_npq[l_ac].npq03

        AFTER FIELD npq05     #部門
            #-----MOD-680003---------
            #IF l_aag05 MATCHES '[yY]' AND cl_null(g_npq[l_ac].npq05) THEN
            #   CALL cl_err(g_npq[l_ac].npq03,'aap-287',0)
            #   NEXT FIELD npq05
            #END IF
            #-----END MOD-680003-----
            IF NOT cl_null(g_npq[l_ac].npq05) THEN
               SELECT gem01 FROM gem_file WHERE gem01=g_npq[l_ac].npq05
                                            AND gemacti='Y'  #NO:4897
                                            AND gem05 = 'Y'       #MOD-B50004
               IF STATUS THEN
                  #CALL cl_err('select gem',STATUS,1)   #FUN-670091
#NO.FUN-720003-------------begin
                 ##-----No.MOD-910004 Mark-----
                 #IF g_bgerr THEN
                 #   CALL s_errmsg('gem01,gemacti','','select gem',STATUS,1)
                 #ELSE
                     CALL cl_err3("sel","gem_file",g_npq[l_ac].npq05,"",STATUS,"","",1)  #FUN-670091
                 #END IF
                 ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003--------------end
                    NEXT FIELD npq05
               END IF

              #FUN-8C0106---add---str---
               IF l_aag05='Y' AND NOT cl_null(g_npq[l_ac].npq03) THEN
                  CALL s_chkdept(g_aaz.aaz72,g_npq[l_ac].npq03,g_npq[l_ac].npq05,g_bookno33) RETURNING g_errno
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD npq05
               END IF
              #FUN-8C0106---add---end---

               #-----FUN-810082---------
               SELECT gem02 INTO g_npq[l_ac].npq05_d FROM gem_file
                 WHERE gem01 = g_npq[l_ac].npq05
                   AND gem05 = 'Y'       #MOD-B50004
               #-----END FUN-810082-----
##1999/07/26 modify by sophia----------------------
               IF g_aaz72 = '2' THEN
                    SELECT COUNT(*) INTO g_cnt FROM aab_file
                     WHERE aab01 = g_npq[l_ac].npq03
                       AND aab02 = g_npq[l_ac].npq05
                       AND aab00 = g_bookno33  #No.FUN-730020
                    IF g_cnt = 0 THEN
#NO.FUN-720003----------begin
                      ##-----No.MOD-910004 Mark-----
                      #IF g_bgerr THEN
                      #   LET g_showmsg=g_npq[l_ac].npq03,"/",g_npq[l_ac].npq05
                      #   CALL s_errmsg('aab01,aab02',g_showmsg,g_npq[l_ac].npq05,'agl-209',0)
                      #ELSE
                          CALL cl_err(g_npq[l_ac].npq05,'agl-209',0)
                      #END IF
                      ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003----------end
                       NEXT FIELD npq05
                    END IF
               ELSE SELECT COUNT(*) INTO g_cnt FROM aab_file
                     WHERE aab01 = g_npq[l_ac].npq03
                       AND aab02 = g_npq[l_ac].npq05
                       AND aab00 = g_bookno33  #No.FUN-730020
                    IF g_cnt > 0 THEN
#NO.FUN-720003-----------begin
                      ##-----No.MOD-910004 Mark-----
                      #IF g_bgerr THEN
                      #   LET g_showmsg=g_npq[l_ac].npq03,"/",g_npq[l_ac].npq05
                      #   CALL s_errmsg('aab01,aab02',g_showmsg,g_npq[l_ac].npq05,'agl-207',0)
                      #ELSE
                          CALL cl_err(g_npq[l_ac].npq05,'agl-207',0)
                      #END IF
                      ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-----------end
                       NEXT FIELD npq05
                    END IF
               END IF
##---------------------------------------
            END IF
            #No.FUN-830161  --Begin
            CALL s_fsgl_bud()
            IF NOT cl_null(g_errno) THEN
               NEXT FIELD npq05
            END IF
            #No.FUN-830161  --END IF

        AFTER FIELD npq06   #借/貸
            IF g_npq[l_ac].npq06 NOT MATCHES '[12]' THEN
               NEXT FIELD npq06
            END IF
        #BEFORE FIELD npq07
        #    IF cl_null(g_npq[l_ac].npq07f) OR g_npq[l_ac].npq07f=0 THEN
        #       NEXT FIELD npq07f
        #    END IF
        #    #LET g_npq[l_ac].npq07=g_npq[l_ac].npq07f*g_npq[l_ac].npq25
##No.2812 modify 1998/11/19
        AFTER FIELD npq07f
           #IF cl_null(g_npq[l_ac].npq07f) OR g_npq[l_ac].npq07f=0 THEN
            IF NOT cl_null(g_npq[l_ac].npq07f) THEN
               #-----MOD-770076---------
               SELECT azi04 INTO t_azi04 FROM azi_file
                WHERE azi01=g_npq[l_ac].npq24 AND aziacti = 'Y'
               IF STATUS THEN
                  LET t_azi04 = 0
               END IF
               #-----END MOD-770076-----
               LET g_npq[l_ac].npq07f=cl_digcut(g_npq[l_ac].npq07f,t_azi04)    #No.CHI-6A0004
               #-----MOD-710153---------
               #CHI-A70041 add --start--
               IF g_npq[l_ac].npq07f < 0 THEN
                  SELECT aag42 INTO l_aag42 FROM aag_file
                   WHERE aag00 = g_bookno33 AND aag01=g_npq[l_ac].npq03
                  IF cl_null(l_aag42) THEN LET l_aag42 = 'N' END IF
                  IF l_minus = 'Y' OR l_aag42 = 'Y' THEN
                  ELSE
                     CALL cl_err(g_npq[l_ac].npq07f,'aec-992',0)
                     NEXT FIELD npq07f
                  END IF
               END IF
               #CHI-A70041 add --end--
               IF g_npq[l_ac].npq07f <> g_npq_t.npq07f OR g_npq_t.npq07f IS NULL THEN   #MOD-750137
                  LET g_npq[l_ac].npq07 = g_npq[l_ac].npq07f * g_npq[l_ac].npq25
                  #LET g_npq[l_ac].npq07 = cl_digcut(g_npq[l_ac].npq07,g_azi.azi04)   #MOD-770076
                  LET g_npq[l_ac].npq07 = cl_digcut(g_npq[l_ac].npq07,g_azi04)   #MOD-770076
                  DISPLAY BY NAME g_npq[l_ac].npq07
               END IF   #MOD-750137
               #-----END MOD-710153-----
               #No.FUN-830161  --Begin
               CALL s_fsgl_bud()
               IF NOT cl_null(g_errno) THEN
                  NEXT FIELD npq07f
               END IF
               #No.FUN-830161  --END IF                              
            END IF
##------------------------
        AFTER FIELD npq07    #本幣金額
            IF g_npq[l_ac].npq07=0 THEN
               NEXT FIELD npq07
            END IF
            IF NOT cl_null(g_npq[l_ac].npq07) THEN
#FUN-A40067 --Begin
               IF g_npp.npptype='1' THEN
                 #MOD-C60058---S---
                  IF g_npp.nppsys = 'FA' THEN
                     LET g_aza.aza82 = g_faa.faa02c
                  ELSE
                     LET g_aza.aza82 = g_aza.aza82
                  END IF
                 #MOD-C60058---E---
                  SELECT aaa03 INTO l_aaa03 FROM aaa_file
                   WHERE aaa01 = g_aza.aza82
                  SELECT azi04 INTO g_azi04_2 FROM azi_file
                   WHERE azi01 = l_aaa03
                  LET g_npq[l_ac].npq07=cl_digcut(g_npq[l_ac].npq07,g_azi04_2)
               ELSE
                  LET g_npq[l_ac].npq07=cl_digcut(g_npq[l_ac].npq07,g_azi04)
               END IF
#FUN-A40067 --End
               #CHI-A70041 add --start--
               IF g_npq[l_ac].npq07 < 0 THEN
                  SELECT aag42 INTO l_aag42 FROM aag_file
                   WHERE aag00 = g_bookno33 AND aag01=g_npq[l_ac].npq03
                  IF cl_null(l_aag42) THEN LET l_aag42 = 'N' END IF
                  IF l_minus = 'Y' OR l_aag42 = 'Y' THEN
                  ELSE
                     CALL cl_err(g_npq[l_ac].npq07,'aec-992',0)
                     NEXT FIELD npq07
                  END IF
               END IF
               #CHI-A70041 add --end--
               #LET g_npq[l_ac].npq07=cl_digcut(g_npq[l_ac].npq07,g_azi.azi04)   #No.CHI-6A0004   #MOD-770076
              #LET g_npq[l_ac].npq07=cl_digcut(g_npq[l_ac].npq07,g_azi04)   #No.CHI-6A0004   #MOD-770076#FUN-A40067 MARK
               #-------------NO.MOD-5A0095 START--------------
               DISPLAY BY NAME g_npq[l_ac].npq07
               #-------------NO.MOD-5A0095 END----------------
               #No.FUN-830161  --Begin
               CALL s_fsgl_bud()
               IF NOT cl_null(g_errno) THEN
                  NEXT FIELD npq07
               END IF
               #No.FUN-830161  --END IF
            END IF

        AFTER FIELD npq24    #幣別
            IF NOT cl_null(g_npq[l_ac].npq24) THEN
               SELECT azi02 INTO g_buf FROM azi_file
                WHERE azi01=g_npq[l_ac].npq24 AND aziacti = 'Y'
               IF STATUS THEN
                  #CALL cl_err('select azi',STATUS,1)    #FUN-670091
#NO.FUN-720003------begin
                  ##-----No.MOD-910004 Mark-----
                  #IF g_bgerr THEN
                  #   CALL s_errmsg('azi01,aziacti','','select azi',STATUS,1)
                  #ELSE
                      CALL cl_err3("sel","gem_file",g_npq[l_ac].npq05,"",STATUS,"","",1)  #FUN-670091
                  #END IF
                  ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-----end
                   NEXT FIELD npq24
               END IF
               #-----MOD-770076---------
               SELECT azi04 INTO t_azi04 FROM azi_file
                WHERE azi01=g_npq[l_ac].npq24 AND aziacti = 'Y'
               IF STATUS THEN
                  LET t_azi04 = 0
               END IF
               #-----END MOD-770076-----
#No.MOD-910178 --begin
               IF g_npq[l_ac].npq24 != g_npq_t.npq24 OR g_npq_t.npq24 IS NULL THEN
                  CALL s_fsgl_npq24()
               END IF
#No.MOD-910178 --end
            END IF

        AFTER FIELD npq25    #匯率
            IF g_npq[l_ac].npq25=0 THEN
               NEXT FIELD npq25
            END IF
            IF g_npq[l_ac].npq25 <> g_npq_t.npq25 OR g_npq_t.npq25 IS NULL THEN    #MOD-750137
               LET g_npq[l_ac].npq07=g_npq[l_ac].npq07f*g_npq[l_ac].npq25   #MOD-750137 取消mark
            END IF   #MOD-750137

        AFTER FIELD npq21     #廠商編號
            IF NOT cl_null(g_npq[l_ac].npq21) THEN
               IF g_argv1 = 'NM' THEN
                  CASE
                   WHEN g_argv2= '1'
                        IF g_npq[l_ac].npq21 <> 'EMPL' AND g_npq[l_ac].npq21 <> 'MISC' THEN       #MOD-D10226 add
                           SELECT pmc03 INTO g_npq[l_ac].npq22 FROM pmc_file
                           WHERE pmc01=g_npq[l_ac].npq21 AND pmcacti = 'Y'
                           IF STATUS THEN
                              #CALL cl_err('select pmc',STATUS,1) #FUN-670091
                             #No.TQC-7B0104--begin--
                              IF STATUS THEN   #No.TQC-7B0104
                                 SELECT gen02 INTO g_npq[l_ac].npq22 FROM gen_file    #No.TQC-7B0104
                                  WHERE gen01=g_npq[l_ac].npq21 AND genacti = 'Y'     #No.TQC-7B0104
                                 IF STATUS THEN #No.TQC-7B0104
                                   #NO.FUN-720003------begin
                                   ##-----No.MOD-910004 Mark-----
                                   #IF g_bgerr THEN
                                   #   CALL s_errmsg('pmc01',g_npq[l_ac].npq21,'select pmc',STATUS,1)
                                   #ELSE
                                       CALL cl_err3("sel","pmc_file",g_npq[l_ac].npq21,"",STATUS,"","",1)  #FUN-670091
                                   #END IF
                                   ##-----No.MOD-910004 Mark END-----
                                   #NO.FUN-720003------end
                                    NEXT FIELD npq21
                                 END IF   #No.TQC-7B0104
                              END IF   #No.TQC-7B0104
                             #No.TQC-7B0104---end---
                           END IF
                        END IF                                                            #MOD-D10226 add
                   WHEN g_argv2='2'
                        IF g_npq[l_ac].npq21 !='MISC' THEN
                           SELECT occ02 INTO g_npq[l_ac].npq22 FROM occ_file
                            WHERE occ01=g_npq[l_ac].npq21 AND occacti = 'Y'
                           IF STATUS THEN
                             #CALL cl_err('select occ',STATUS,1)   #FUN-670091
#NO.FUN-720003------begin
                            ##-----No.MOD-910004 Mark-----
                            #IF g_bgerr THEN
                            #   CALL s_errmsg('ooc01',g_npq[l_ac].npq21,'select occ',STATUS,1)
                            #ELSE
                                CALL cl_err3("sel","occ_file",g_npq[l_ac].npq21,"",STATUS,"","",1)  #FUN-670091
                            #END IF
                            ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003------end
                              NEXT FIELD npq21
                           END IF
                        END IF
                   WHEN g_argv2='3'
                        SELECT nmg20 into l_nmg20 FROM nmg_file
                                                 WHERE nmg00 = g_argv3
                        IF l_nmg20[1,1] = '1' THEN
                           IF g_npq[l_ac].npq21 <> 'EMPL' AND g_npq[l_ac].npq21 <> 'MISC' THEN       #MOD-D10226 add
                              SELECT pmc03 INTO g_npq[l_ac].npq22 FROM pmc_file
                              WHERE pmc01=g_npq[l_ac].npq21 AND pmcacti = 'Y'
                              IF STATUS THEN
                              #NO.FUN-720003------begin
                                ##-----No.MOD-910004 Mark-----
                                #IF g_bgerr THEN
                                #   CALL s_errmsg('pmc01',g_npq[l_ac].npq21,'select pmc',STATUS,1)
                                #ELSE
                                    CALL cl_err('select pmc',STATUS,1)
                                #END IF
                                ##-----No.MOD-910004 Mark END-----
                              #NO.FUN-720003-------end
                                 NEXT FIELD npq21
                              END IF
                           END IF                                                            #MOD-D10226 add
                        END IF
                       #IF l_nmg20[1,1] = '2' THEN    #CHI-D20032 mark 
                        IF l_nmg20 = '22' THEN        #CHI-D20032 
                           IF g_npq[l_ac].npq21 !='MISC' THEN
                              SELECT occ02 INTO g_npq[l_ac].npq22 FROM occ_file
                               WHERE occ01=g_npq[l_ac].npq21 AND occacti = 'Y'
                                 AND (occ06 = '1' OR occ06 = '3')       #CHI-D20032
                              IF STATUS THEN
                           #NO.FUN-720003------begin
                                ##-----No.MOD-910004 Mark-----
                                #IF g_bgerr THEN
                                #   CALL s_errmsg('occ01',g_npq[l_ac].npq21,'select occ',STATUS,1)
                                #ELSE
                                    CALL cl_err('select occ',STATUS,1)
                                #END IF
                                ##-----No.MOD-910004 Mark END-----
                           #NO.FUN-720003------end
                                 NEXT FIELD npq21
                              END IF
                           END IF
                        END IF
                       #-CHI-D20032-add-
                        IF l_nmg20 = '21' AND g_npq[l_ac].npq21 != 'MISC' THEN 
                           SELECT occ02 INTO g_npq[l_ac].npq22 
                             FROM occ_file
                            WHERE occ01 = g_npq[l_ac].npq21
                              AND (occ06 = '1' OR occ06 = '3')                   
                              AND occacti IN ('Y','y')
                           IF cl_null(g_npq[l_ac].npq22) THEN 
                              SELECT pmc03 INTO g_npq[l_ac].npq22 
                                FROM pmc_file
                               WHERE pmc01 = g_npq[l_ac].npq21 
                                 AND pmcacti IN ('Y','y')                   
                              IF cl_null(g_npq[l_ac].npq22) THEN 
                                 CALL cl_err3("sel","occ_file or pmc_file",g_npq[l_ac].npq21,"",STATUS,"","sel occ",1)
                                 NEXT FIELD npq21
                              END IF
                           END IF
                        END IF
                       #-CHI-D20032-end-
                   OTHERWISE EXIT CASE
                   END CASE
               END IF
               IF g_argv1 = 'FA'  THEN
                  IF g_argv2 = 4 THEN
                     SELECT occ02 INTO g_npq[l_ac].npq22 FROM occ_file
                     WHERE occ01=g_npq[l_ac].npq21 AND occacti = 'Y'
                     IF STATUS THEN
                   #NO.FUN-720003------begin
                       ##-----No.MOD-910004 Mark-----
                       #IF g_bgerr THEN
                       #  CALl s_errmsg('occ01',g_npq[l_ac].npq21,'select occ',STATUS,1)
                       #ELSE
                          CALL cl_err('select occ',STATUS,1)
                       #END IF
                       ##-----No.MOD-910004 Mark END-----
                   #NO.FUN-720003------end
                        NEXT FIELD npq21
                     END IF
                  ELSE
                     IF g_npq[l_ac].npq21 <> 'EMPL' AND g_npq[l_ac].npq21 <> 'MISC' THEN       #MOD-D10226 add
                        SELECT pmc03 INTO g_npq[l_ac].npq22 FROM pmc_file
                        WHERE pmc01=g_npq[l_ac].npq21 AND pmcacti = 'Y'
                        IF STATUS THEN
                      #NO.FUN-720003-------begin
                          ##-----No.MOD-910004 Mark-----
                          #IF g_bgerr THEN
                          #   CALL s_errmsg('pmc01',g_npq[l_ac].npq21,'select pmc',STATUS,1)
                          #ELSE
                              CALL cl_err('select pmc',STATUS,1)
                          #END IF
                          ##-----No.MOD-910004 Mark END-----
                      #NO.FUN-720003-------end
                          NEXT FIELD npq21
                        END IF
                     END IF                                                            #MOD-D10226 add
                  END IF
               END IF
               IF g_argv1 = 'AP' THEN
                  #IF g_npq[l_ac].npq21 <> 'EMPL' THEN   #MOD-7A0078  #MOD-8C0256 mark
                   IF g_npq[l_ac].npq21 <> 'EMPL' AND g_npq[l_ac].npq21 <> 'MISC' THEN   #MOD-8C0256 add
                     SELECT pmc03 INTO g_npq[l_ac].npq22 FROM pmc_file
                      WHERE pmc01=g_npq[l_ac].npq21 AND pmcacti = 'Y'
                     IF STATUS THEN
                    #No.MOD-7A0004-----begin
                        SELECT gen02 INTO g_npq[l_ac].npq22 FROM gen_file
                        WHERE gen01=g_npq[l_ac].npq21 AND genacti = 'Y'
                        IF STATUS THEN
                         #No.MOD-CC0276  --Begin 
                         SELECT occ02 INTO g_npq[l_ac].npq22 FROM occ_file
                            WHERE occ01=g_npq[l_ac].npq21 AND occacti = 'Y'
                            IF STATUS THEN
                           #No.MOD-CC0276  --End
                       #NO.FUN-720003-----begin
                       ##-----No.MOD-910004 Mark-----
                          #IF g_bgerr THEN
                          #   CALL s_errmsg('pmc01',g_npq[l_ac].npq21,'select pmc',STATUS,1)
                          #ELSE
                              CALL cl_err('select pmc',STATUS,1)
                          #END IF
                          ##-----No.MOD-910004 Mark END-----
                        #NO.FUN-720003-----end
                         NEXT FIELD npq21
                        END IF                      #MOD-CC0276
                       END IF
                     END IF
                     #No.MOD-7A0004-----end
                   END IF   #MOD-7A0078
                  #----------------------------MOD-C10123--------------------start
                   IF l_flag2 = 0 THEN
                      IF g_npq[l_ac].npq21 <> 'EMPL' AND g_npq[l_ac].npq21 <> 'MISC' THEN       #MOD-D10226 add
                         SELECT pmc03 INTO g_npq[l_ac].npq22 FROM pmc_file
                          WHERE pmc01=g_npq[l_ac].npq21 AND pmcacti = 'Y'
                         IF STATUS THEN
                            #No.MOD-D40078  --Begin
                            SELECT gen02 INTO g_npq[l_ac].npq22 FROM gen_file
                             WHERE gen01=g_npq[l_ac].npq21 AND genacti = 'Y'
                            IF STATUS THEN
                            #No.MOD-D40078  --End
                               #No.MOD-CC0276  --Begin
                               SELECT occ02 INTO g_npq[l_ac].npq22 FROM occ_file
                                WHERE occ01=g_npq[l_ac].npq21 AND occacti = 'Y'
                               IF STATUS THEN
                               #No.MOD-CC0276  --End
                                  CALL cl_err('select pmc',STATUS,1)
                                  NEXT FIELD npq21
                               END IF
                            END IF                      #MOD-CC0276
                          END IF   #MOD-D40078
                      END IF                                                            #MOD-D10226 add
                   END IF
                   IF l_flag2 = 1 THEN
                      SELECT gen02 INTO g_npq[l_ac].npq22 FROM gen_file
                       WHERE gen01=g_npq[l_ac].npq21 AND genacti = 'Y'
                      IF STATUS THEN
                         CALL cl_err3("sel","pmc_file",g_npq[l_ac].npq21,"",STATUS,"","",1)
                         NEXT FIELD npq21
                      END IF
                   END IF
                  #----------------------------MOD-C10123----------------------end
               END IF
               #add 030213 NO.A048
               IF g_argv1 = 'AR' AND g_npq[l_ac].npq21 != 'MISC' THEN
                   #-----No.MOD-530748-----
                  SELECT oob04 INTO l_oob04 FROM oob_file
                   WHERE oob01 = g_npp.npp01
                     AND oob03 = g_npq[l_ac].npq06
                     AND oob11 = g_npq[l_ac].npq03
                  IF l_oob04 = "9" THEN
                     IF g_npq[l_ac].npq21 <> 'EMPL' THEN                  #MOD-D10226 add
                        SELECT pmc03 INTO g_npq[l_ac].npq22 FROM pmc_file
                         WHERE pmc01 = g_npq[l_ac].npq21
                           AND pmcacti = 'Y'
                        IF STATUS THEN
                        #NO.FUN-720003------begin
                          ##-----No.MOD-910004 Mark-----
                          #IF g_bgerr THEN
                          #   CALL s_errmsg('pmc01',g_npq[l_ac].npq21,'select pmc',STATUS,1)
                          #ELSE
                              CALL cl_err('select pmc',STATUS,1)
                          #END IF
                          ##-----No.MOD-910004 Mark END-----
                        #NO.FUN-720003------end
                           NEXT FIELD npq21
                        END IF
                     END IF                                                            #MOD-D10226 add
                  ELSE
                     SELECT occ02 INTO g_npq[l_ac].npq22 FROM occ_file
                      WHERE occ01 = g_npq[l_ac].npq21
                        AND occacti = 'Y'
                     IF STATUS THEN
                      #NO.FUN-720003------begin
                       ##-----No.MOD-910004 Mark-----
                       #IF g_bgerr THEN
                       #   CALL s_errmsg('occ01',g_npq[l_ac].npq21,'select occ',STATUS,1)
                       #ELSE
                           CALL cl_err('select occ',STATUS,1)
                       #END IF
                       ##-----No.MOD-910004 Mark END-----
                      #NO.FUN-720003------end
                        NEXT FIELD npq21
                     END IF
                  END IF
                   #-----No.MOD-530748 END -----
               END IF
            END IF

             #MOD-530812
            IF g_npq[l_ac].npq21 IS NULL THEN
               LET g_npq[l_ac].npq21 = ' '
               DISPLAY g_npq[l_ac].npq21 TO npq21
               LET g_npq[l_ac].npq21 = NULL
               LET g_npq[l_ac].npq22 = NULL     #CHI-D20032
               DISPLAY g_npq[l_ac].npq21 TO npq21
            END IF
            IF g_npq[l_ac].npq21 = ' ' THEN
               LET g_npq[l_ac].npq21 = NULL
               LET g_npq[l_ac].npq22 = NULL     #CHI-D20032
               DISPLAY g_npq[l_ac].npq21 TO npq21
            END IF
            DISPLAY g_npq[l_ac].npq22 TO npq22  #CHI-D20032
            #--
            #add by pane 130621 begin#
            IF NOT cl_null(g_npq[l_ac].npq21) THEN
               LET g_pmc903 ='' #add by pane 130619
               IF g_argv1 = 'AP' THEN 
                  SELECT pmc903 INTO g_pmc903 
                   FROM pmc_file
                  WHERE pmc_file.pmc01 = g_npq[l_ac].npq21 
               END IF 
               IF g_argv1 = 'AR' THEN             
                 SELECT occ37 INTO g_occ37
                   FROM occ_file
                  WHERE occ_file.occ01 = g_npq[l_ac].npq21 
               END IF
               LET l_aag371 = ''
               SELECT aag371 INTO l_aag371 FROM aag_file
                WHERE aag01=g_npq[l_ac].npq03
                  AND aag00 = g_bookno33
               IF l_aag371= '4' THEN
                  IF g_pmc903 = 'Y' OR g_occ37 = 'Y' THEN
                     CALL cl_set_comp_entry("npq37",TRUE)
                  ELSE
                     CALL cl_set_comp_entry("npq37", FALSE)
                     IF g_npq[l_ac].npq37 IS NOT NULL THEN
                        LET g_npq[l_ac].npq37 = ''
                     END IF
                  END IF
               END IF
            END IF 
            #add by pane 130621 end #
        #-----MOD-680003---------
        #BEFORE FIELD npq15  #預算編號  npq23-npq15-npq08
        #     SELECT aag21 INTO l_aag21 FROM aag_file   #MOD-570379
        #         WHERE aag01=g_npq[l_ac].npq03 AND aag07 != '1'   #MOD-570379
        #    IF l_aag21 = 'N' OR cl_null(l_aag21) THEN
        #        CALL cl_set_comp_entry("npq15",FALSE)     #MOD-570379
        #       LET g_npq[l_ac].npq15=' '
        #    ELSE
        #        CALL cl_set_comp_entry("npq15",TRUE)     #MOD-570379
        #    END IF
        #-----END MOD-680003-----

#No.FUN-840006 080407 mark --begin
#       AFTER FIELD npq15  #預算編號
#           #-----MOD-680003---------
#           #CALL cl_set_comp_entry("npq15",TRUE)     #MOD-570379
#           #IF cl_null(g_npq[l_ac].npq15) AND l_aag21 = 'Y' THEN   #No.MOD-4A0294
#           #   NEXT FIELD npq15
#           #END IF
#           #-----END MOD-680003-----
#           IF g_npq[l_ac].npq15 IS NOT NULL AND g_npq[l_ac].npq15 !=' ' THEN
#              #FUN-670047  --begin
#               IF g_npp.nppsys = 'CA' THEN
#                 LET g_plant_new=g_ccz.ccz11
#                 CALL s_getdbs()
#                 LET g_dbs_gl=g_dbs_new
#                 IF g_npp.npptype='0' THEN
#                    LET g_argv5 = g_ccz.ccz12
#                 ELSE
#                    LET g_argv5 = g_ccz.ccz121
#                 END IF
#               END IF
#               #-----MOD-7B0129---------
#               IF g_npp.nppsys = 'FA' THEN
#                 LET g_plant_new=g_faa.faa02p
#                 CALL s_getdbs()
#                 LET g_dbs_gl=g_dbs_new
#                 IF g_npp.npptype='0' THEN
#                    LET g_argv5 = g_faa.faa02b
#                 ELSE
#                    LET g_argv5 = g_faa.faa02c
#                 END IF
#               END IF
#               #-----END MOD-7B0129-----
#               #-----TQC-820005---------
#               IF g_npp.nppsys = 'CD' OR g_npp.nppsys = 'CC' THEN
#                 LET g_plant_new=g_plant
#                 CALL s_getdbs()
#                 LET g_dbs_gl=g_dbs_new
#                 IF g_npp.npptype='0' THEN
#                    LET g_argv5 = g_aza.aza81
#                 ELSE
#                    LET g_argv5 = g_aza.aza82
#                 END IF
#               END IF
#               #-----END TQC-820005-----

#MOD-820033-add
#               IF g_npp.nppsys = 'PY' THEN
#                  LET g_plant_new=g_cpa.cpa150
#                  CALL s_getdbs()
#                  LET g_dbs_gl=g_dbs_new
#                  IF g_npp.npptype='0' THEN
#                     LET g_argv5 = g_cpa.cpa151
#                  ELSE
#                     LET g_argv5 = g_cpa.cpa152
#                  END IF
#               END IF
#MOD-820033-add-end

#               IF g_aza.aza63 = 'N' THEN
#                  SELECT azn02,azn04 INTO g_azn02,g_azn04  FROM azn_file
#                    WHERE azn01 = g_npp.npp02
#               ELSE
#                  LET g_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl CLIPPED,"aznn_file",
#                              "  WHERE aznn01 = '",g_npp.npp02,"'" ,
#                              "    AND aznn00 = '",g_argv5,"'"
#                  PREPARE aznn_pre FROM g_sql
#                  DECLARE aznn_cs CURSOR FOR aznn_pre
#                  OPEN aznn_cs
#                  FETCH aznn_cs INTO g_azn02,g_azn04
#               END IF
#              #FUN-670047 --end
#              IF g_npq[l_ac].npq05 IS NULL OR g_npq[l_ac].npq05=' ' THEN
#                 LET l_dept='@'
#              ELSE
#                 LET l_dept = g_npq[l_ac].npq05
#              END IF
#               SELECT afb04,afb15 INTO l_afb04,l_afb15                    #FUN-810069
#              SELECT afb04,afb15,afb041,afb042 INTO l_afb04,l_afb15,l_afb041,l_afb042   #FUN-810069
#                       FROM afb_file WHERE afb00 = g_argv5 AND
#                                           afb01 = g_npq[l_ac].npq15 AND
#                                           afb02 = g_npq[l_ac].npq03 AND
#                                           afb03 = g_azn02 AND afb04 = l_dept
#                                       AND afb041= g_npq[l_ac].npq05      #FUN-810069
#                                       AND afb042= g_npq[l_ac].npq08      #FUN-810069
#              IF SQLCA.sqlcode THEN
#              #NO.FUN-720003------begin
#                 IF g_bgerr THEN
#                    LET g_showmsg=g_argv5,"/",g_npq[l_ac].npq15,"/",g_npq[l_ac].npq03,"/",g_azn02,"/",l_dept
#                    CALl s_errmsg('afb00,afb01,afb02,afb03,afb04',g_showmsg,g_npq[l_ac].npq15,'agl-139',0)
#                 ELSE
#                    CALL cl_err(g_npq[l_ac].npq15,'agl-139',0)
#                 END IF
#              #NO.FUN-720003------end
#                 LET g_npq[l_ac].npq15 = g_npq_t.npq15
#                 NEXT FIELD npq15
#              END IF
#              CALL s_getbug(g_argv5,g_npq[l_ac].npq15,g_npq[l_ac].npq03,
#                             g_azn02,g_azn04,l_afb04,l_afb15)                   #FUN-810069
#                            g_azn02,g_azn04,l_afb04,l_afb15,l_afb041,l_afb042)  #FUN-810069
#                   RETURNING l_flag,l_afb07,l_amt
#              IF l_flag THEN
#              #NO.FUN-720003------begin
#                 IF g_bgerr THEN
#                    CALl s_errmsg('','','','agl-139',0)
#                 ELSE
#                    CALL cl_err('','agl-139',0)
#                 END IF
#              #NO.FUN-720003------end
#              END IF #若不成功#
#              IF l_afb07  = '1' THEN #不做超限控制
#                 NEXT FIELD npq08
#              ELSE
#              #----------????????????????年度,期別-----------
#              #-----MOD-620020---------
#              SELECT aag05 INTO l_aag05 FROM aag_file
#                 WHERE aag01 = g_npq[l_ac].npq03
#                   AND aag00 = g_bookno33  #No.FUN-730020
#              IF l_aag05 = 'Y' THEN
#                  SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
#                         WHERE npq01 = npp01
#                           AND npq03 = g_npq[l_ac].npq03
#                           AND npq15 = g_npq[l_ac].npq15 AND npq06 = '1' #借方
#                           AND npq05 = g_npq[l_ac].npq05
#                           AND YEAR(npp02) = g_azn02
#                           AND MONTH(npp02) = g_azn04
#                           AND ( npq01 != g_npp.npp01 OR
#                                (npq01  = g_npp.npp01 AND
#                                 npq02 != g_npq[l_ac].npq02))
#                  IF SQLCA.sqlcode OR l_tol IS NULL THEN
#                     LET l_tol = 0
#                  END IF
#                 SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
#                        WHERE npq01 = npp01
#                          AND npq03 = g_npq[l_ac].npq03
#                          AND npq15 = g_npq[l_ac].npq15 AND npq06 = '2' #貸方
#                          AND npq05 = g_npq[l_ac].npq05
#                          AND YEAR(npp02) = g_azn02
#                          AND MONTH(npp02) = g_azn04
#                          AND ( npq01 != g_npp.npp01 OR
#                               (npq01  = g_npp.npp01 AND
#                                npq02 != g_npq[l_ac].npq02))
#                 IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
#                    LET l_tol1 = 0
#                 END IF
#              ELSE
#              #-----END MOD-620020-----
#                  SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
#                         WHERE npq01 = npp01
#                           AND npq03 = g_npq[l_ac].npq03
#                           AND npq15 = g_npq[l_ac].npq15 AND npq06 = '1' #借方
#                         #no.6353
#                           AND YEAR(npp02) = g_azn02
#                           AND MONTH(npp02) = g_azn04
#                           AND ( npq01 != g_npp.npp01 OR
#                                (npq01  = g_npp.npp01 AND
#                                 npq02 != g_npq[l_ac].npq02))
#                         #no.6353(end)
#                  IF SQLCA.sqlcode OR l_tol IS NULL THEN
#                     LET l_tol = 0
#                  END IF
#                 SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
#                        WHERE npq01 = npp01
#                          AND npq03 = g_npq[l_ac].npq03
#                          AND npq15 = g_npq[l_ac].npq15 AND npq06 = '2' #貸方
#                         #no.6353
#                           AND YEAR(npp02) = g_azn02
#                           AND MONTH(npp02) = g_azn04
#                           AND ( npq01 != g_npp.npp01 OR
#                                (npq01  = g_npp.npp01 AND
#                                 npq02 != g_npq[l_ac].npq02))
#                         #no.6353(end)
#                 IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
#                    LET l_tol1 = 0
#                 END IF
#              END IF   #MOD-620020
#                  IF l_aag06 = '1' THEN #借餘
#                        LET total_t = l_tol - l_tol1   #借減貸
#                  ELSE #貸餘
#                        LET total_t = l_tol1 - l_tol   #貸減借
#                  END IF
#
#                 #IF p_cmd = 'a' THEN #若本筆資料為新增則加上本次輸入的值
#                  LET total_t = total_t + g_npq[l_ac].npq07  #no.6353
#                 #ELSE #若為更改則減掉舊值再加上新值
#                 #   LET total_t = total_t - g_npq_t.npq07 +
#                 #                 g_npq[l_ac].npq07
#                 #END IF
#                  IF total_t > l_amt THEN #借餘大於預算金額
#                     CASE l_afb07
#                          WHEN '2'
#                                  CALL cl_getmsg('agl-140',0) RETURNING l_buf
#                                  CALL cl_getmsg('agl-141',0) RETURNING l_buf1
#                                  ERROR l_buf CLIPPED,' ',total_t,
#                                        l_buf1 CLIPPED,' ',l_amt
#                                   NEXT FIELD npq08
#                          WHEN '3'
#                                  CALL cl_getmsg('agl-142',0) RETURNING l_buf
#                                  CALL cl_getmsg('agl-143',0) RETURNING l_buf
#                                  ERROR l_buf CLIPPED,' ',total_t,
#                                        l_buf1 CLIPPED,' ',l_amt
#                                   NEXT FIELD npq15
#                     END CASE
#                  END IF
#              END IF
#           END IF
#No.FUN-840006 080407 mark --end

        AFTER FIELD npq08
            IF g_npq[l_ac].npq08 IS NOT NULL AND g_npq[l_ac].npq08 != ' ' THEN
               #SELECT * FROM gja_file WHERE gja01 = g_npq[l_ac].npq08                     #FUN-810045
               SELECT * FROM pja_file WHERE pja01 = g_npq[l_ac].npq08 AND pjaacti = 'Y'   #FUN-810045
                                        AND pjaclose = 'N'                                #FUN-960038
               IF SQLCA.sqlcode THEN
               #NO.FUN-720003-----begin
                 ##-----No.MOD-910004 Mark-----
                 #IF g_bgerr THEN
                 #   CALL s_errmsg('pja01',g_npq[l_ac].npq08,g_npq[l_ac].npq08,'agl-007',0)   #FUN-810045 gja->pja
                 #ELSE
                     CALL cl_err(g_npq[l_ac].npq08,'agl-007',0)
                 #END IF
                 ##-----No.MOD-910004 Mark END-----
               #NO.FUN-720003------end
                  LET g_npq[l_ac].npq08 = g_npq_t.npq08
                  NEXT FIELD npq08
               END IF
            END IF
            #No.FUN-830161  --Begin
            CALL s_fsgl_bud()
            IF NOT cl_null(g_errno) THEN
               NEXT FIELD npq08
            END IF
            #No.FUN-830161  --END IF

        BEFORE FIELD npq11  #  npq03-npq11-npq12
           IF l_aag15 IS NOT NULL AND l_aag15 != ' ' THEN
                CALL s_fsgl_get_ahe02('1')  #FUN-5C0015
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
               #LET l_str = l_str CLIPPED,l_aag15,'!'
                LET l_str = l_str CLIPPED,g_ahe02,'!'  #FUN-5C0015
                ERROR l_str
           END IF

        AFTER FIELD npq11
         DISPLAY BY NAME g_npq[l_ac].npq11    #MOD-950165
#MOD-5B0256
         SELECT aag151 INTO l_aag151 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
#END MOD-5B0256
            #FUN-5C0015 BY GILL --START
            #CALL fsgl_npq11(l_aag151,'1',g_npq[l_ac].npq11)
            CALL s_chk_aee(g_npq[l_ac].npq03,'1',g_npq[l_ac].npq11,g_bookno33)  #No.FUN-730020
            #FUN-5C0015 BY GILL --END
            IF NOT cl_null(g_errno) THEN
#NO.FUN-7200003------begin
               #IF g_bgerr THEN  #MOD-740102
               #   CALL s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
               #ELSE        #MOD-740102
                  CALL cl_err('sel aee:',g_errno,1)
               #END IF      #MOD-740102
#NO.FUN-720003-------end
               NEXT FIELD npq11
            END IF
            #No.MOD-D40020  --Begin
            IF g_aza.aza26 = '2' THEN
               IF NOT cl_null(g_npq[l_ac].npq11) THEN
                   IF g_argv1 = 'NM' THEN
                      SELECT nmg20 INTO l_nmg20 FROM nmg_file
                      WHERE nmg00 = g_argv3
                      #IF l_nmg20 = '0 ' THEN      #yinhy130814 mark
                         LET g_pmc903  = NULL
                         LET g_occ37 = NULL
                         SELECT pmc903 INTO g_pmc903  FROM pmc_file WHERE pmc01 = g_npq[l_ac].npq11
                         IF STATUS THEN
                            SELECT occ37 INTO g_occ37  FROM occ_file WHERE occ01 = g_npq[l_ac].npq11
                         END IF
                      #END IF                     #yinhy130814 mark
                      IF l_aag371 = '4' AND (g_pmc903='Y' OR g_occ37 = 'Y') THEN
                             LET g_npq[l_ac].npq37 = g_npq[l_ac].npq11
                             DISPLAY BY NAME g_npq[l_ac].npq37
                      END IF
                   END IF
               END IF
            END IF
            #No.MOD-D40020  --End
        BEFORE FIELD npq12  #  npq11-npq12-npq13
           IF l_aag16 IS NOT NULL AND l_aag16 != ' ' THEN
                CALL s_fsgl_get_ahe02('2')  #FUN-5C0015
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
               #LET l_str = l_str CLIPPED,l_aag16,'!'
                LET l_str = l_str CLIPPED,g_ahe02,'!'   #FUN-5C0015
                ERROR l_str
           END IF
        AFTER FIELD npq12
         DISPLAY BY NAME g_npq[l_ac].npq12     #MOD-950165
#MOD-5B0256
         SELECT aag161 INTO l_aag161 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
#END MOD-5B0256
               #FUN-5C0015 BY GILL --START
               #CALL fsgl_npq11(l_aag161,'2',g_npq[l_ac].npq12)
               CALL s_chk_aee(g_npq[l_ac].npq03,'2',g_npq[l_ac].npq12,g_bookno33)  #No.FUN-730020
               #FUN-5C0015 BY GILL --END
               IF NOT cl_null(g_errno) THEN
#NO.FUN-720003--------begin
                  #IF g_bgerr THEN    #MOD-740102
                  #   CALL s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
                  #ELSE               #MOD-740102
                     CALL cl_err('sel aee:',g_errno,1)
                  #END IF             #MOD-740102
#NO.FUN-720003--------end
                  NEXT FIELD npq12
               END IF
        BEFORE FIELD npq13  #  npq12-npq13-npq14
           IF l_aag17 IS NOT NULL AND l_aag17 != ' ' THEN
              CALL s_fsgl_get_ahe02('3')  #FUN-5C0015
              CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
             #LET l_str = l_str CLIPPED,l_aag17,'!'
              LET l_str = l_str CLIPPED,g_ahe02,'!'  #FUN-5C0015
              ERROR l_str
           END IF
        AFTER FIELD npq13
         DISPLAY BY NAME g_npq[l_ac].npq13    #MOD-950165
#MOD-5B0256
         SELECT aag171 INTO l_aag171 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
#END MOD-5B0256
               #FUN-5C0015 BY GILL --START
               CALL fsgl_npq11(l_aag171,'3',g_npq[l_ac].npq13)
               CALL s_chk_aee(g_npq[l_ac].npq03,'3',g_npq[l_ac].npq13,g_bookno33)  #No.FUN-730020
               #FUN-5C0015 BY GILL --END
               IF NOT cl_null(g_errno) THEN
#NO.FUN-720003-------begin
                  #IF g_bgerr THEN     #MOD-740102
                  #   CALl s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
                  #ELSE                #MOD-740102
                     CALL cl_err('sel aee:',g_errno,1)
                  #END IF              #MOD-740102
#NO.FUN-720003--------end
                 NEXT FIELD npq13
               END IF
        BEFORE FIELD npq14
           IF l_aag18 IS NOT NULL AND l_aag18 != ' ' THEN
                CALL s_fsgl_get_ahe02('4')  #FUN-5C0015
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
               #LET l_str = l_str CLIPPED,l_aag18,'!'
                LET l_str = l_str CLIPPED,g_ahe02,'!'   #FUN-5C0015
                ERROR l_str
           END IF
        AFTER FIELD npq14
         DISPLAY BY NAME g_npq[l_ac].npq14    #MOD-950165
#MOD-5B0256
         SELECT aag181 INTO l_aag181 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
#END MOD-5B0256
               #FUN-5C0015 BY GILL --START
               CALL fsgl_npq11(l_aag181,'4',g_npq[l_ac].npq14)
               CALL s_chk_aee(g_npq[l_ac].npq03,'4',g_npq[l_ac].npq14,g_bookno33)  #No.FUN-730020
               #FUN-5C0015 BY GILL --END
               IF NOT cl_null(g_errno) THEN
#NO.FUN-720003-------begin
                  #IF g_bgerr THEN    #MOD-740102
                  #   CALL s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
                  #ELSE               #MOD-740102
                     CALL cl_err('sel aee:',g_errno,1)
                  #END IF             #MOD-740102
#NO.FUN-720003-------end
                  NEXT FIELD npq14
               END IF

       #FUN-5C0015 051216 BY GILL --START
        BEFORE FIELD npq31
           IF l_aag31 IS NOT NULL AND l_aag31 != ' ' THEN
                CALL s_fsgl_get_ahe02('5')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
           IF l_aag31 IS NULL THEN       #TQC-C60171 add
              CALL g_npq_to_g_npq3() #FUN-AA0087 add #FUN-AC0063 mod
              CALL s_def_npq31_34(l_aag31,g_npq3.*) RETURNING l_npq31 #FUN-AA0087
              LET g_npq[l_ac].npq31 = l_npq31 #FUN-AA0087 add
           END IF                        #TQC-C60171 add
        AFTER FIELD npq31
         DISPLAY BY NAME g_npq[l_ac].npq31      #MOD-950165
         SELECT aag311 INTO l_aag311 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'5',g_npq[l_ac].npq31,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
#NO.FUN-720003--------begin
                  #IF g_bgerr THEN     #MOD-740102
                  #   CALL s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
                  #ELSE                #MOD-740102
                     CALL cl_err('sel aee:',g_errno,1)
                  #END IF              #MOD-740102
#NO.FUN-720003--------end
                  NEXT FIELD npq31
               END IF

        BEFORE FIELD npq32
           IF l_aag32 IS NOT NULL AND l_aag32 != ' ' THEN
                CALL s_fsgl_get_ahe02('6')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
           IF l_aag32 IS NULL THEN       #TQC-C60171 add  
              CALL g_npq_to_g_npq3() #FUN-AA0087 add #FUN-AC0063 mod
              CALL s_def_npq31_34(l_aag32,g_npq3.*) RETURNING l_npq32 #FUN-AA0087
              LET g_npq[l_ac].npq32 = l_npq32 #FUN-AA0087 add
           END IF                        #TQC-C60171 add
        AFTER FIELD npq32
         DISPLAY BY NAME g_npq[l_ac].npq32     #MOD-950165
         SELECT aag321 INTO l_aag321 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'6',g_npq[l_ac].npq32,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
#NO.FUN-720003-------begin
                  #IF g_bgerr THEN     #MOD-740102
                  #   CALL s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
                  #ELSE                #MOD-740102
                     CALL cl_err('sel aee:',g_errno,1)
                  #END IF              #MOD-740102
#NO.FUN-7200003------end
                  NEXT FIELD npq32
               END IF

        BEFORE FIELD npq33
           IF l_aag33 IS NOT NULL AND l_aag33 != ' ' THEN
                CALL s_fsgl_get_ahe02('7')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
           IF l_aag33 IS NULL THEN       #TQC-C60171 add
              CALL g_npq_to_g_npq3() #FUN-AA0087 add #FUN-AC0063 mod
              CALL s_def_npq31_34(l_aag33,g_npq3.*) RETURNING l_npq33 #FUN-AA0087
              LET g_npq[l_ac].npq33 = l_npq33 #FUN-AA0087 add
           END IF                        #TQC-C60171 add 
        AFTER FIELD npq33
         DISPLAY BY NAME g_npq[l_ac].npq33    #MOD-950165
         SELECT aag331 INTO l_aag331 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'7',g_npq[l_ac].npq33,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
#NO.FUN-720003------begin
                  #IF g_bgerr THEN     #MOD-740102
                  #   CALL s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
                  #ELSE                #MOD-740102
                     CALL cl_err('sel aee:',g_errno,1)
                  #END IF              #MOD-740102
#NO.FUN-720003------end
                  NEXT FIELD npq33
               END IF

        BEFORE FIELD npq34
           IF l_aag34 IS NOT NULL AND l_aag34 != ' ' THEN
                CALL s_fsgl_get_ahe02('8')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
           IF l_aag34 IS NULL THEN       #TQC-C60171 add
              CALL g_npq_to_g_npq3() #FUN-AA0087 add #FUN-AC0063 mod
              CALL s_def_npq31_34(l_aag34,g_npq3.*) RETURNING l_npq34 #FUN-AA0087
              LET g_npq[l_ac].npq34 = l_npq34 #FUN-AA0087 add
           END IF                        #TQC-C60171 add
        AFTER FIELD npq34
         DISPLAY BY NAME g_npq[l_ac].npq34    #MOD-950165
         SELECT aag341 INTO l_aag341 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'8',g_npq[l_ac].npq34,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
#NO.FUN-720003------begin
                  #IF g_bgerr THEN      #MOD-740102
                  #   CALL s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
                  #ELSE                 #MOD-740102
                     CALL cl_err('sel aee:',g_errno,1)
                  #END IF                #MOD-740102
#NO.FUN-720003------end
                  NEXT FIELD npq34
               END IF

#No.MOD-8C0274---Begin
#        BEFORE FIELD npq35
#           IF l_aag35 IS NOT NULL AND l_aag35 != ' ' THEN
#                CALL s_fsgl_get_ahe02('9')
#                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
#                LET l_str = l_str CLIPPED,g_ahe02,'!'
#                ERROR l_str
#           END IF
#        AFTER FIELD npq35
          #MOD-C30727--ADD--STR
          IF cl_null(g_npq[l_ac].npq35) THEN
             LET g_npq[l_ac].npq35=' '
          END IF
          #MOD-C30727--ADD--END
#         SELECT aag351 INTO l_aag351 FROM aag_file
#          WHERE aag01=g_npq[l_ac].npq03
#            AND aag00 = g_bookno33  #No.FUN-730020
#               CALL s_chk_aee(g_npq[l_ac].npq03,'9',g_npq[l_ac].npq35,g_bookno33)  #No.FUN-730020
#               IF NOT cl_null(g_errno) THEN
##NO.FUN-720003-------begin
#                  #IF g_bgerr THEN          #MOD-740102
#                  #   CALL s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
#                  #ELSE                     #MOD-740102
#                     CALL cl_err('sel aee:',g_errno,1)
#                  #END IF                   #MOD-740102
##NO.FUN-720003-------end
#                  NEXT FIELD npq35
#               END IF
#         #No.FUN-830161  --Begin
#         CALL s_fsgl_bud()
#         IF NOT cl_null(g_errno) THEN
#            NEXT FIELD npq35
#         END IF
#         #No.FUN-830161  --END IF

#        BEFORE FIELD npq36
#           IF l_aag36 IS NOT NULL AND l_aag36 != ' ' THEN
#                CALL s_fsgl_get_ahe02('10')
#                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
#                LET l_str = l_str CLIPPED,g_ahe02,'!'
#                ERROR l_str
#           END IF
#        AFTER FIELD npq36
#         SELECT aag361 INTO l_aag361 FROM aag_file
#          WHERE aag01=g_npq[l_ac].npq03
#            AND aag00 = g_bookno33  #No.FUN-730020
#               CALL s_chk_aee(g_npq[l_ac].npq03,'10',g_npq[l_ac].npq36,g_bookno33)  #No.FUN-730020
#               IF NOT cl_null(g_errno) THEN
##NO.FUN-720003------begin
#                  #IF g_bgerr THEN   #MOD-740102
#                  #   CALL s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
#                  #ELSE              #MOD-740102
#                     CALL cl_err('sel aee:',g_errno,1)
#                  #END IF            #MOD-740102
##NO.FUN-720003------end
#                  NEXT FIELD npq36
#               END IF
#         #No.FUN-830161  --Begin
#         CALL s_fsgl_bud()
#         IF NOT cl_null(g_errno) THEN
#            NEXT FIELD npq36
#         END IF
#         #No.FUN-830161  --END IF

       BEFORE FIELD npq35
         IF l_aag23='Y' AND cl_null(g_npq[l_ac].npq08) THEN
            NEXT FIELD npq08
         END IF

       AFTER FIELD npq35
          DISPLAY BY NAME g_npq[l_ac].npq35    #MOD-950165
          IF NOT cl_null(g_npq[l_ac].npq35) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjb_file
              WHERE pjb01 = g_npq[l_ac].npq08
                AND pjb02 = g_npq[l_ac].npq35
                AND pjbacti = 'Y'
             IF g_cnt = 0 THEN
                CALL cl_err(g_npq[l_ac].npq08,'apj-051',0)
                LET g_npq[l_ac].npq35 = g_npq_t.npq35
                NEXT FIELD npq35
             ELSE
                SELECT pjb09,pjb11 INTO l_pjb09,l_pjb11
                 FROM pjb_file WHERE pjb01 =g_npq[l_ac].npq08
                  AND pjb02 = g_npq[l_ac].npq35
                  AND pjbacti = 'Y'
                IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN
                   CALL cl_err(g_npq[l_ac].npq08,'apj-090',0)
                   LET g_npq[l_ac].npq35 = g_npq_t.npq35
                   NEXT FIELD npq35
                END IF
             END IF
          END IF
          CALL s_fsgl_bud()
          IF NOT cl_null(g_errno) THEN
             NEXT FIELD npq35
          END IF

        AFTER FIELD npq36
            DISPLAY BY NAME g_npq[l_ac].npq36     #MOD-950165
#MOD-950096  --MARK--
#           IF g_aza.aza08 = 'N' THEN
#              IF g_npq[l_ac].npq36 IS NULL THEN
#                 CALL cl_err(g_npq[l_ac].npq36,'aap-344',0)
#                 NEXT FIELD npq36
#               END IF
#           END IF
#MOD-950096  --MARK--
           CALL s_fsgl_npq36()
           IF NOT cl_null(g_errno)  THEN
              CALL cl_err(g_npq[l_ac].npq36,g_errno,1)
              NEXT FIELD npq36
           END IF
           CALL s_fsgl_bud()
           IF NOT cl_null(g_errno) THEN
              NEXT FIELD npq36
           END IF
#No.MOD-8C0274---End
        BEFORE FIELD npq37
           IF l_aag37 IS NOT NULL AND l_aag37 != ' ' THEN
                CALL s_fsgl_get_ahe02('99')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
        AFTER FIELD npq37
          #DISPLAY BY NAME g_npq[l_ac].npq37                           #MOD-950165 #MOD-C40051 add
           SELECT aag371 INTO l_aag371 FROM aag_file
            WHERE aag01=g_npq[l_ac].npq03
              AND aag00 = g_bookno33  #No.FUN-730020
           IF NOT cl_null(g_npq[l_ac].npq37) THEN                                  #MOD-C40051 add
              CALL s_chk_aee(g_npq[l_ac].npq03,'99',g_npq[l_ac].npq37,g_bookno33)  #No.FUN-730020
              IF NOT cl_null(g_errno) THEN
                #NO.FUN-720003------begin
                #IF g_bgerr THEN         #MOD-740102
                #   CALL s_errmsg('aag01',g_npq[l_ac].npq03,'sel aee:',g_errno,1)
                #ELSE                    #MOD-740102
                 CALL cl_err('sel aee:',g_errno,1)
                #END IF                  #MOD-740102
                #NO.FUN-720003------end
                 NEXT FIELD npq37
              END IF
          #-------------------MOD-C40051----------------(S)
           ELSE
              IF l_aag371='2' OR l_aag371='3' THEN
                 CALL cl_err('','mfg0037',0)
                #NEXT FIELD abb37                     #MOD-C70113 mark
                 NEXT FIELD npq37                     #MOD-C70113 add
              END IF
             #---------------MOD-C70113---------------(S)
             #IF g_pmc903 = 'Y' OR g_occ37 = 'Y' THEN                         #MOD-D20048 mark
              IF l_aag371 = '4' AND (g_pmc903 = 'Y' OR g_occ37 = 'Y') THEN    #MOD-D20048 add
                 CALL cl_err('','mfg0037',0)
                 NEXT FIELD npq37
              END IF
             #---------------MOD-C70113---------------(E)
           END IF
           DISPLAY BY NAME g_npq[l_ac].npq37
          #-------------------MOD-C40051----------------(E)

       #FUN-5C0015 051216 BY GILL --END

        AFTER FIELD npq04
            #FUN-CB0039----add--str-
            IF NOT cl_null(g_npq[l_ac].npq04) THEN
              IF l_ac>1 THEN
                 IF g_npq[l_ac].npq04='cc' OR g_npq[l_ac].npq04='CC' OR g_npq[l_ac].npq04='Cc'
                    OR g_npq[l_ac].npq04='cC' THEN
                    LET g_npq[l_ac].npq04=g_npq[l_ac-1].npq04
                 END IF
              END IF
            END IF
            #FUN-CB0039--add---end
            LET g_msg = g_npq[l_ac].npq04
            IF g_msg[1,1] = '.' THEN
               LET g_msg = g_msg[2,10]
               SELECT aad02 INTO g_npq[l_ac].npq04 FROM aad_file
                WHERE aad01 = g_msg AND aadacti = 'Y'
                #-------------NO.MOD-5A0095 START--------------
                DISPLAY BY NAME g_npq[l_ac].npq04
                #-------------NO.MOD-5A0095 END----------------
               NEXT FIELD npq04
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_npq_t.npq02 > 0 AND g_npq_t.npq02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
#NO.FUN-720003-----begin
                  ##-----No.MOD-910004 Mark-----
                  #IF g_bgerr THEN
                  #   CALL s_errmsg('','',"", -263, 1)
                  #ELSE
                      CALL cl_err("", -263, 1)
                  #END IF
                  ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-----end
                   CANCEL DELETE
                END IF
{ckp#1}         DELETE FROM npq_file WHERE npqsys=g_npp.nppsys
                   AND npq00= g_npp.npp00 AND npq01 =g_npp.npp01
                   AND npq011 =g_npp.npp011 AND npq02= g_npq_t.npq02
                   AND npqtype=g_npp.npptype  #No.FUN-670047
                IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
                    LET g_success = 'N'
                   ##-----No.MOD-910004 Mark-----
                   #IF g_bgerr THEN
                   #   LET g_showmsg=g_npp.nppsys,"/",g_npp.npp00,"/",g_npp.npp01,"/",g_npp.npp011,"/",g_npq_t.npq02,"/",g_npp.npptype
                   #   CALL s_errmsg('npqsys,npq00,npq01,npq011,npq02,npqtype',g_showmsg,g_npq_t.npq02,SQLCA.sqlcode,1)
                   #ELSE
                       CALL cl_err(g_npq_t.npq02,SQLCA.sqlcode,1)
                   #END IF
                   ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-------end
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                IF g_success='Y'   THEN
                   COMMIT WORK
                   LET g_rec_b=g_rec_b-1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                   MESSAGE 'Delete Ok'
                ELSE
                   ROLLBACK WORK
                END IF
                CALL s_fsgl_chk()   #No.MOD-4A0347
               #start FUN-670080 add
                IF cl_null(g_npq07_t1) THEN LET g_npq07_t1 = 0 END IF
                IF cl_null(g_npq07_t2) THEN LET g_npq07_t2 = 0 END IF
                IF g_npq07_t1 != g_npq07_t2 THEN  #(僅判斷本幣即可)
#NO.FUN-720003------begin
                  ##-----No.MOD-910004 Mark-----
                  #IF g_bgerr THEN
                  #   CALL s_errmsg('','','','axr-058',1)
                  #ELSE
                      CALL cl_err('','axr-058',1)   #原幣金額,本幣金額借貸相等否
                  #END IF
                  ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-------end
                   CONTINUE INPUT
                END IF
               #end FUN-670080 add
               #No.TQC-B10154  --Begin
               LET l_sw = 'N'
               IF g_npp.npptype = '1' THEN
                  SELECT aaa03 INTO l_azi01 FROM aaa_file WHERE aaa01 = g_bookno33
                  IF l_azi01 = g_aza.aza17 THEN
                     LET l_sw = 'Y'
                  END IF
               END IF
               #No.TQC-B10154  --End
               IF g_npp.npptype = '0' OR l_sw = 'Y' THEN   #No.TQC-B10154
                  #-MOD-A80173-add-
                   SELECT SUM(npq07f),SUM(npq07) INTO l_sumf,l_sum
                     FROM npq_file
                    WHERE npqsys =g_npp.nppsys AND npq00 =g_npp.npp00
                      AND npq01  =g_npp.npp01  AND npq011=g_npp.npp011
                      AND npqtype = g_npp.npptype  AND npq24 = g_aza.aza17
                      AND npq07f > 0               #排除匯差部分
                   IF l_sumf != l_sum THEN
                      CALL cl_err('','agl-926',1)
                      CONTINUE INPUT
                   END IF
                  #-MOD-A80173-end-
               END IF                                      #No.TQC-B10154
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
#NO.FUN-720003------begin
              ##-----No.MOD-910004 Mark-----
              #IF g_bgerr THEN
              #   CALL s_errmsg('','','',9001,0)
              #ELSE
                  CALL cl_err('',9001,0)
              #END IF
              ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-------end
               LET INT_FLAG = 0
               LET g_npq[l_ac].* = g_npq_t.*
               CLOSE s_fsgl_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
#NO.FUN-720003------begin
             ##-----No.MOD-910004 Mark-----
             #IF g_bgerr THEN
             #   CALL s_errmsg('','',g_npq[l_ac].npq02,-263,1)
             #ELSE
                 CALL cl_err(g_npq[l_ac].npq02,-263,1)
             #END IF
             ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-------end
               LET g_npq[l_ac].* = g_npq_t.*
            ELSE
               #FUN-AC0063 add --start--
               CALL g_npq_to_g_npq3()
               CALL s_chk_dimension(g_npq3.*,g_npq[l_ac].npq03,g_npq[l_ac].npq11,g_bookno33) RETURNING l_fld_name 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  CASE l_fld_name
                     WHEN 'npq31'
                        NEXT FIELD npq31
                     WHEN 'npq32'
                        NEXT FIELD npq32
                     WHEN 'npq33'
                        NEXT FIELD npq33
                     WHEN 'npq34'
                        NEXT FIELD npq34
                  END CASE        
               END IF
               #FUN-AC0063 add --end--
            #No.MOD-930091 BEGIN ----------
                IF l_aag05='Y' AND NOT cl_null(g_npq[l_ac].npq05) THEN
                   CALL s_chkdept(g_aaz.aaz72,g_npq[l_ac].npq03,g_npq[l_ac].npq05,g_bookno33)
                   RETURNING g_errno
                END IF
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD npq03
                END IF
            #No.MOD-930091 END ------------
                UPDATE npq_file
                   SET npq02=g_npq[l_ac].npq02,npq03=g_npq[l_ac].npq03,
                       npq04=g_npq[l_ac].npq04,npq05=g_npq[l_ac].npq05,
                       npq06=g_npq[l_ac].npq06,npq07f=g_npq[l_ac].npq07f,
                       npq07=g_npq[l_ac].npq07,npq08=g_npq[l_ac].npq08,
                       npq11=g_npq[l_ac].npq11,npq12=g_npq[l_ac].npq12,
                       npq13=g_npq[l_ac].npq13,npq14=g_npq[l_ac].npq14,

                       #FUN-5C0015 BY GILL --START
                       npq31=g_npq[l_ac].npq31,npq32=g_npq[l_ac].npq32,
                       npq33=g_npq[l_ac].npq33,npq34=g_npq[l_ac].npq34,
                       npq35=g_npq[l_ac].npq35,npq36=g_npq[l_ac].npq36,
                       npq37=g_npq[l_ac].npq37,
                       #FUN-5C0015 BY GILL --END

                       #npq15=g_npq[l_ac].npq15,     #No.FUN-840006 去掉npq15
                       npq21=g_npq[l_ac].npq21,
                       npq22=g_npq[l_ac].npq22,npq23=g_npq[l_ac].npq23,
                       npq24=g_npq[l_ac].npq24,npq25=g_npq[l_ac].npq25
                WHERE npqsys = g_npp.nppsys AND npq00=g_npp.npp00
	        	AND npq01=g_npp.npp01 AND npq011=g_npp.npp011
	         	AND npq02=g_npq_t.npq02
                        AND npqtype=g_npp.npptype  #No.FUN-670047
                IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
                  ##-----No.MOD-910004 Mark-----
                  #IF g_bgerr THEN
                  #   LET g_showmsg=g_npp.nppsys,"/",g_npp.npp00,"/",g_npp.npp01,"/",g_npp.npp011,"/",g_npq_t.npq02,"/",g_npp.npptype
                  #   CALL s_errmsg('npqsys,npq00,npq01,npq011,npq02,npqtype',g_showmsg,'upd npq',SQLCA.sqlcode,1)
                  #ELSE
                      CALL cl_err('upd npq',SQLCA.sqlcode,1)
                  #END IF
                  ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-------end
                   LET g_success = 'N'
                END IF
                IF g_success='Y' THEN
                	#No.yinhy130922  --Begin
                	IF g_nmz.nmz70 ='3' THEN
                	 IF (NOT cl_null(g_npq[l_ac].npq03) AND  g_npq[l_ac].npq03 <> g_npq_t.npq03) OR
                	    (NOT cl_null(g_npq[l_ac].npq06) AND  g_npq[l_ac].npq06 <> g_npq_t.npq06) OR
                	    (NOT cl_null(g_npq[l_ac].npq07) AND  g_npq[l_ac].npq07 <> g_npq_t.npq07) OR
                	    (NOT cl_null(g_npq[l_ac].npq07f) AND  g_npq[l_ac].npq07f <> g_npq_t.npq07f) THEN
                	     CALL s_fsgl_ins_tic()
                   END IF
                  END IF
                  #No.yinhy130922  --End
                   COMMIT WORK
                   MESSAGE 'UPDATE O.K'
                ELSE
                   ROLLBACK WORK
                END IF
                CALL s_fsgl_chk()
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac    #FUN-D30032 mark
            IF INT_FLAG THEN
#NO.FUN-720003------begin
              ##-----No.MOD-910004 Mark-----
              #IF g_bgerr THEN
              #   CALL s_errmsg('','','',9001,0)
              #ELSE
                  CALL cl_err('',9001,0)
              #END IF
              ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-------end
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_npq[l_ac].* = g_npq_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_npq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
               END IF
               #-----MOD-7B0147---------
               IF g_npq07_t1 != g_npq07_t2 THEN
                  IF (g_npp.nppsys = 'AP' AND g_npp.npp00 = '1') OR
                     (g_npp.nppsys = 'AR' AND g_npp.npp00 = '2') THEN
                     CALL cl_err('','axr-058','1')
                     NEXT FIELD npq07
                  END IF
               END IF
               #-----END MOD-7B0147-----
               #No.TQC-B10154  --Begin
               LET l_sw = 'N'
               IF g_npp.npptype = '1' THEN
                  SELECT aaa03 INTO l_azi01 FROM aaa_file WHERE aaa01 = g_bookno33
                  IF l_azi01 = g_aza.aza17 THEN
                     LET l_sw = 'Y'
                  END IF
               END IF
               #No.TQC-B10154  --End
               IF g_npp.npptype = '0' OR l_sw = 'Y' THEN   #No.TQC-B10154
                  #-MOD-A80173-add-
                   SELECT SUM(npq07f),SUM(npq07) INTO l_sumf,l_sum
                     FROM npq_file
                    WHERE npqsys =g_npp.nppsys AND npq00 =g_npp.npp00
                      AND npq01  =g_npp.npp01  AND npq011=g_npp.npp011
                      AND npqtype = g_npp.npptype  AND npq24 = g_aza.aza17
                      AND npq07f > 0               #排除匯差部分
                   IF l_sumf != l_sum THEN
                      CALL cl_err('','agl-926',1)
                      NEXT FIELD npq07
                   END IF
                  #-MOD-A80173-end-
               END IF                                      #No.TQC-B10154
               CLOSE s_fsgl_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
           #CKP
           #LET g_npq_t.* = g_npq[l_ac].*          # 900423
            CLOSE s_fsgl_bcl
            COMMIT WORK
            #CKP2
            CALL g_npq.deleteElement(g_rec_b+1)

       AFTER INPUT
## No:2509 modify 1998/10/09 ----------------------------
#         IF g_npq07f_t1 != g_npq07f_t2 OR g_npq07_t1 != g_npq07_t2
          IF g_npq07_t1 != g_npq07_t2   #(僅判斷本幣即可)
          THEN    #原幣金額,本幣金額借貸相等否
             #-----MOD-7B0147---------
             IF (g_npp.nppsys = 'AP' AND g_npp.npp00 = '1') OR
                (g_npp.nppsys = 'AR' AND g_npp.npp00 = '2') THEN
                CALL cl_err('','axr-058','1')
                NEXT FIELD npq07
             ELSE
             #-----END MOD-7B0147-----
#NO.FUN-720003------begin
               ##-----No.MOD-910004 Mark-----
               #IF g_bgerr THEN
               #   CALL s_errmsg('','','','axr-058',1)
               #ELSE
                   CALL cl_err('','axr-058',1)
               #END IF
               ##-----No.MOD-910004 Mark-----
#NO.FUN-720000003-------end
                EXIT INPUT
             END IF   #MOD-7B0147
          END IF
          #No.TQC-B10154  --Begin
          LET l_sw = 'N'
          IF g_npp.npptype = '1' THEN
             SELECT aaa03 INTO l_azi01 FROM aaa_file WHERE aaa01 = g_bookno33
             IF l_azi01 = g_aza.aza17 THEN
                LET l_sw = 'Y'
             END IF
          END IF
          #No.TQC-B10154  --End
          IF g_npp.npptype = '0' OR l_sw = 'Y' THEN   #No.TQC-B10154
             #-MOD-A80173-add-
              SELECT SUM(npq07f),SUM(npq07) INTO l_sumf,l_sum
                FROM npq_file
               WHERE npqsys =g_npp.nppsys AND npq00 =g_npp.npp00
                 AND npq01  =g_npp.npp01  AND npq011=g_npp.npp011
                 AND npqtype = g_npp.npptype  AND npq24 = g_aza.aza17
                 AND npq07f > 0               #排除匯差部分
              IF l_sumf != l_sum THEN
                 CALL cl_err('','agl-926',1)
                 NEXT FIELD npq07
              END IF
             #-MOD-A80173-end-
          END IF                                      #No.TQC-B10154
## -------------------------------------------------------
          #如果為票據系統,且為應付或應收才check 票面金額
          IF g_argv1 = 'NM' AND ( g_argv2 MATCHES '[1-2]' ) THEN
            IF g_npq07f_t1 != g_argv4 OR g_npq07f_t2 != g_argv4 THEN
               #借貸金額不等於票額
#NO.FUN-720003------begin
              ##-----No.MOD-910004 Mark-----
              #IF g_bgerr THEN
              #    CALL s_errmsg('','','','anm-133',1)
              #ELSE
                   CALL cl_err('','anm-133',1)
              #END IF
              ##-----No.MOD-910004 Mark END-----
#NO.FUN-720003-------end
             EXIT INPUT
            END IF            
          END IF

        ON ACTION controlo
            IF INFIELD(npq02) AND l_ac > 1 THEN
                LET g_npq[l_ac].* = g_npq[l_ac-1].*
                LET g_npq[l_ac].npq02 = NULL
                NEXT FIELD npq02
            END IF

        ON ACTION CONTROLP
            CALL cl_init_qry_var()
            CASE
               WHEN INFIELD(npq03) #會計科目
                  LET g_qryparam.form = 'q_aag'
                  LET g_qryparam.default1 = g_npq[l_ac].npq03
                  LET g_qryparam.arg1 = g_bookno33  #No.FUN-730020
                  LET g_qryparam.where = " aag07 != '1' "    #No.TQC-C20441 Add
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq03
                  DISPLAY g_npq[l_ac].npq03 TO npq03
                  #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq03 )
                  NEXT FIELD npq03

               WHEN INFIELD(npq04) #常用摘要
                  #-----MOD-640093---------
                  LET g_qryparam.form = 'q_aad2'
                  LET g_qryparam.default1 = g_npq[l_ac].npq04
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq04
                  #CALL q_aad(FALSE,TRUE,g_npq[l_ac].npq04) RETURNING g_npq[l_ac].npq04
                  #-----END MOD-640093-----
                  #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq04 )
                  DISPLAY g_npq[l_ac].npq04 TO npq04
                  NEXT FIELD npq04

               WHEN INFIELD(npq05) #部門編號
                   LET g_qryparam.form = 'q_gem1'      #No.MOD-440244
                  LET g_qryparam.default1 = g_npq[l_ac].npq05
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq05
                  DISPLAY g_npq[l_ac].npq05 TO npq05
                  #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq05 )
                  NEXT FIELD npq05

               WHEN INFIELD(npq21)
                  IF g_argv1 = 'NM' THEN
                     CASE
                        WHEN g_argv2= 1   #應付/廠商
                           LET g_qryparam.form = 'q_pmc'
                           LET g_qryparam.default1 = g_npq[l_ac].npq21
                           CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                           #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq21 )
                           DISPLAY g_npq[l_ac].npq21 TO npq21
                           NEXT FIELD npq21

                        WHEN g_argv2= 2   #應收/客戶
                           LET g_qryparam.form = 'q_occ'
                           LET g_qryparam.default1 = g_npq[l_ac].npq21
                           CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                           DISPLAY g_npq[l_ac].npq21 TO npq21
                           #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq21 )
                           NEXT FIELD npq21

                        WHEN g_argv2= 3     #應收/客戶
                           SELECT nmg20 into l_nmg20
                             FROM nmg_file
                            WHERE nmg00 = g_argv3
                           IF l_nmg20[1,1] = '1' THEN
                              LET g_qryparam.form = 'q_pmc'
                              LET g_qryparam.default1 = g_npq[l_ac].npq21
                              CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                              DISPLAY g_npq[l_ac].npq21 TO npq21
                              #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq21 )
                              NEXT FIELD npq21
                           END IF
                          #IF l_nmg20[1,1] = '2' THEN  #CHI-D20032 mark
                           IF l_nmg20 = '22' THEN      #CHI-D20032 
                              LET g_qryparam.form = 'q_occ'
                              LET g_qryparam.default1 = g_npq[l_ac].npq21
                              CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                              DISPLAY g_npq[l_ac].npq21 TO npq21
                              NEXT FIELD npq21
                              #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq21 )
                           END IF
                          #-CHI-D20032-add-
                           IF l_nmg20 = '21' THEN 
                              CALL q_occ_pmc(FALSE,TRUE,g_plant) RETURNING g_npq[l_ac].npq21,g_npq[l_ac].npq22 
                              DISPLAY g_npq[l_ac].npq21 TO npq21
                              DISPLAY g_npq[l_ac].npq22 TO npq22
                              NEXT FIELD npq21
                           END IF
                          #-CHI-D20032-end-
                     END CASE
                  END IF

#--Begin  No:7169
                  IF g_argv1='FA' THEN
                     IF g_argv2 = 4 THEN  #出售
                        LET g_qryparam.form = 'q_occ'
                        LET g_qryparam.default1 = g_npq[l_ac].npq21
                        CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                        DISPLAY g_npq[l_ac].npq21 TO npq21
                        NEXT FIELD npq21
                        #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq21 )
                     ELSE
                        LET g_qryparam.form = 'q_pmc'
                        LET g_qryparam.default1 = g_npq[l_ac].npq21
                        CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                        NEXT FIELD npq21
                        DISPLAY g_npq[l_ac].npq21 TO npq21
                        #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq21 )
                     END IF
                     NEXT FIELD npq21
                  END IF

                  IF g_argv1 = 'AP'  THEN    #--End    No:7169
                     #-----TQC-7B0006---------
                     IF l_flag2 = 1 THEN
                        LET g_qryparam.form = 'q_gen'
                        LET g_qryparam.default1 = g_npq[l_ac].npq21
                        CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                        DISPLAY g_npq[l_ac].npq21 TO npq21
                        NEXT FIELD npq21
                     ELSE
                     #-----END TQC-7B0006-----
                        LET g_qryparam.form = 'q_pmc'
                        LET g_qryparam.default1 = g_npq[l_ac].npq21
                        CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                        DISPLAY g_npq[l_ac].npq21 TO npq21
                        #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq21 )
                        NEXT FIELD npq21
                     END IF   #TQC-7B0006
                  END IF

#add 030213 NO.A048
                  IF g_argv1 = 'AR' THEN
                      #-----No.MOD-530748-----
                     SELECT oob04 INTO l_oob04 FROM oob_file
                      WHERE oob01 = g_npp.npp01
                        AND oob03 = g_npq[l_ac].npq06
                        AND oob11 = g_npq[l_ac].npq03
                     IF l_oob04 = "9" THEN
                        LET g_qryparam.form = 'q_pmc'
                        LET g_qryparam.default1 = g_npq[l_ac].npq21
                        CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                        DISPLAY g_npq[l_ac].npq21 TO npq21
                        NEXT FIELD npq21
                     ELSE
                        LET g_qryparam.form = 'q_occ'
                        LET g_qryparam.default1 = g_npq[l_ac].npq21
                        CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                        DISPLAY g_npq[l_ac].npq21 TO npq21
                        NEXT FIELD npq21
                     END IF
                      #-----No.MOD-530748 END -----
                  END IF
                   #-----No.MOD-530674-----
                  IF g_argv1 = 'LC' THEN
                     LET g_qryparam.form = 'q_pmc'
                     LET g_qryparam.default1 = g_npq[l_ac].npq21
                     CALL cl_create_qry() RETURNING g_npq[l_ac].npq21
                     DISPLAY g_npq[l_ac].npq21 TO npq21
                     #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq21 )
                     NEXT FIELD npq21
                  END IF
                   #-----No.MOD-530674 END-----

               WHEN INFIELD(npq24)   #幣別
                  LET g_qryparam.form = 'q_azi'
                  LET g_qryparam.default1 = g_npq[l_ac].npq24
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq24
                  DISPLAY g_npq[l_ac].npq24 TO npq24
                  #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq24 )
                  NEXT FIELD npq24
               #FUN-4B0071
               WHEN INFIELD(npq25)
                  CALL s_rate(g_npq[l_ac].npq24,g_npq[l_ac].npq25) RETURNING g_npq[l_ac].npq25
                  LET l_npq25 = g_npq[l_ac].npq25       #No.FUN-9A0036
                  DISPLAY g_npq[l_ac].npq25 TO npq25
                  NEXT FIELD npq25
               #FUN-4B0071(end)

               WHEN INFIELD(npq08)    #查詢專案編號
                  #LET g_qryparam.form = 'q_gja'  #FUN-810045
                  LET g_qryparam.form = 'q_pja3'  #FUN-810045
                  LET g_qryparam.default1 = g_npq[l_ac].npq08
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq08
                  DISPLAY g_npq[l_ac].npq08 TO npq08
                  NEXT FIELD npq08

                 #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq08 )

#No.FUN-840006 080407 mark --begin
#              WHEN INFIELD(npq15)    #查詢預算編號
#                 LET g_qryparam.form = 'q_afa'
#                 LET g_qryparam.default1 = g_npq[l_ac].npq15
#                 LET g_qryparam.arg1 = g_bookno33  #No.FUN-730070
#                 CALL cl_create_qry() RETURNING g_npq[l_ac].npq15
#                 DISPLAY g_npq[l_ac].npq15 TO npq15
#                 NEXT FIELD npq15
#                 #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq15 )
#No.FUN-840006 080407 mark --end

             #FUN-5C0015 BY GILL 將查詢程式q_aee改為s_ahe_qry---------
             {
               WHEN INFIELD(npq11)    #查詢異動碼-1
                  LET g_qryparam.form = 'q_aee'
                  LET g_qryparam.default1 = g_npq[l_ac].npq11
                  LET g_qryparam.arg1 = g_npq[l_ac].npq03
                  LET g_qryparam.arg2 = 1
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq11
                   DISPLAY g_npq[l_ac].npq11 TO npq11          #No.MOD-4A0111
                  NEXT FIELD npq11

               WHEN INFIELD(npq12)    #查詢異動碼-2
                  LET g_qryparam.form = 'q_aee'
                  LET g_qryparam.default1 = g_npq[l_ac].npq12
                  LET g_qryparam.arg1 = g_npq[l_ac].npq03
                  LET g_qryparam.arg2 = 2
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq12
                   DISPLAY g_npq[l_ac].npq12 TO npq12            #No.MOD-4A0111
                  NEXT FIELD npq12

               WHEN INFIELD(npq13)    #查詢異動碼-3
                  LET g_qryparam.form = 'q_aee'
                  LET g_qryparam.default1 = g_npq[l_ac].npq13
                  LET g_qryparam.arg1 = g_npq[l_ac].npq03
                  LET g_qryparam.arg2 = 3
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq13
                   DISPLAY g_npq[l_ac].npq13 TO npq13         #No.MOD-4A0111
                  NEXT FIELD npq13

               WHEN INFIELD(npq14)    #查詢異動碼-4
                  LET g_qryparam.form = 'q_aee'
                  LET g_qryparam.default1 = g_npq[l_ac].npq14
                  LET g_qryparam.arg1 = g_npq[l_ac].npq03
                  LET g_qryparam.arg2 = 4
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq14
                   DISPLAY g_npq[l_ac].npq14 TO npq14           #No.MOD-4A0111
                  NEXT FIELD npq14
             }

               WHEN INFIELD(npq11)    #查詢異動碼-1
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'1','i',g_npq[l_ac].npq11,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq11
                    DISPLAY g_npq[l_ac].npq11 TO npq11
                    NEXT FIELD npq11

               WHEN INFIELD(npq12)    #查詢異動碼-2
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'2','i',g_npq[l_ac].npq12,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq12
                    DISPLAY g_npq[l_ac].npq12 TO npq12
                    NEXT FIELD npq12

               WHEN INFIELD(npq13)    #查詢異動碼-3
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'3','i',g_npq[l_ac].npq13,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq13
                    DISPLAY g_npq[l_ac].npq13 TO npq13
                    NEXT FIELD npq13

               WHEN INFIELD(npq14)    #查詢異動碼-4
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'4','i',g_npq[l_ac].npq14,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq14
                    DISPLAY g_npq[l_ac].npq14 TO npq14
                    NEXT FIELD npq14

               WHEN INFIELD(npq31)    #查詢異動碼-5
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'5','i',g_npq[l_ac].npq31,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq31
                    DISPLAY g_npq[l_ac].npq31 TO npq31
                    NEXT FIELD npq31

               WHEN INFIELD(npq32)    #查詢異動碼-6
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'6','i',g_npq[l_ac].npq32,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq32
                    DISPLAY g_npq[l_ac].npq32 TO npq32
                    NEXT FIELD npq32

               WHEN INFIELD(npq33)    #查詢異動碼-7
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'7','i',g_npq[l_ac].npq33,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq33
                    DISPLAY g_npq[l_ac].npq33 TO npq33
                    NEXT FIELD npq33

               WHEN INFIELD(npq34)    #查詢異動碼-8
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'8','i',g_npq[l_ac].npq34,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq34
                    DISPLAY g_npq[l_ac].npq34 TO npq34
                    NEXT FIELD npq34

               #No.MOD-8C0274---Begin
               #WHEN INFIELD(npq35)    #查詢異動碼-9
               #     CALL s_ahe_qry(g_npq[l_ac].npq03,'9','i',g_npq[l_ac].npq35,g_bookno33)  #No.FUN-730020
               #       RETURNING g_npq[l_ac].npq35
               #     DISPLAY g_npq[l_ac].npq35 TO npq35
               #     NEXT FIELD npq35

               #WHEN INFIELD(npq36)    #查詢異動碼-10
               #     CALL s_ahe_qry(g_npq[l_ac].npq03,'10','i',g_npq[l_ac].npq36,g_bookno33)  #No.FUN-730020
               #       RETURNING g_npq[l_ac].npq36
               #     DISPLAY g_npq[l_ac].npq36 TO npq36
               #     NEXT FIELD npq36

               WHEN INFIELD(npq35)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.arg1 = g_npq[l_ac].npq08
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq35
                  DISPLAY BY NAME g_npq[l_ac].npq35
                  NEXT FIELD npq35

               WHEN INFIELD(npq36)
                    CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_azf"    #No.TQC-B50067 mark
                    #LET g_qryparam.arg1 = '2'       #No.TQC-B50067 mark
                    LET g_qryparam.form ="q_azf01a"  #No.TQC-B50067
                    LET g_qryparam.arg1 = '7'        #No.TQC-B50067
                    CALL cl_create_qry() RETURNING g_npq[l_ac].npq36
                    DISPLAY g_npq[l_ac].npq36 TO npq36
               #No.MOD-8C0274---End

               WHEN INFIELD(npq37)    #關係人
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'99','i',g_npq[l_ac].npq37,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq37
                    DISPLAY g_npq[l_ac].npq37 TO npq37
                    NEXT FIELD npq37

             #FUN-5C0015 060215 BY GILL --END-------------------------

            END CASE

        ON ACTION controlg
           CALL cl_cmdask()

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION controls                       #No.FUN-6B0033
            CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033

      END INPUT
      IF g_success='Y'
         THEN COMMIT WORK
         ELSE ROLLBACK WORK
      END IF
      CLOSE s_fsgl_bcl
END FUNCTION

FUNCTION s_fsgl_set_entry_b(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)
   DEFINE   l_nmg20 LIKE nmg_file.nmg20  #MOD-550100
   DEFINE   l_aag371  LIKE aag_file.aag371       #No.FUN-950053

   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("npq21,npq22,npq23,npq24,npq25",TRUE)
   END IF

   IF INFIELD(npq03) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("npq05",TRUE)
#     CALL cl_set_comp_entry("npq15",TRUE)   #MOD-570379   #MOD-680003 remark #No.FUN-840006 去掉npq15
      CALL cl_set_comp_entry("npq08",TRUE)
      CALL cl_set_comp_entry("npq11",TRUE)
      CALL cl_set_comp_entry("npq12",TRUE)
      CALL cl_set_comp_entry("npq13",TRUE)
      CALL cl_set_comp_entry("npq14",TRUE)

      #FUN-5C0015 051216 BY GILL --START
      CALL cl_set_comp_entry("npq31",TRUE)
      CALL cl_set_comp_entry("npq32",TRUE)
      CALL cl_set_comp_entry("npq33",TRUE)
      CALL cl_set_comp_entry("npq34",TRUE)
      CALL cl_set_comp_entry("npq35",TRUE)
      CALL cl_set_comp_entry("npq36",TRUE)
      CALL cl_set_comp_entry("npq37",TRUE)
      #FUN-5C0015 051216 BY GILL --END

   END IF
    #MOD-530812
   IF g_argv1 = 'FA' AND g_argv2 <> '4' THEN
      CALL cl_set_comp_entry("npq21,npq22",FALSE)
   END IF
   #--
    #MOD-550100
   IF g_argv1 = 'NM' AND g_argv2 =  '3' THEN
      LET l_nmg20=''
      SELECT nmg20 INTO l_nmg20 FROM nmg_file WHERE nmg00=g_argv3
      IF l_nmg20='0' THEN
         CALL cl_set_comp_entry("npq21,npq22",FALSE)
      END IF
   END IF
   #--
   #FUN-950053 --------------------------add start------------------------
   SELECT aag371 INTO l_aag371 FROM aag_file
    WHERE aag01=g_npq[l_ac].npq03
      AND aag00 = g_bookno33
   IF l_aag371= '4' THEN
      IF g_pmc903 = 'Y' OR g_occ37 = 'Y' THEN
         CALL cl_set_comp_entry("npq37",TRUE)
      END IF
   END IF
   #FUN-950053 -------------------------add end--------------------------
END FUNCTION

FUNCTION s_fsgl_set_no_entry_b(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)
   DEFINE   l_nmg20 LIKE nmg_file.nmg20  #MOD-550100
   DEFINE   l_aag371 LIKE aag_file.aag371       #No.FUN-950053

   IF INFIELD(npq03) OR (NOT g_before_input_done) THEN
#MOD-5B0256
     SELECT aag151,aag161,aag171,aag181,aag05,aag21,aag23,
            aag311,aag321,aag331,aag341,aag351,aag361,aag371 #FUN-5C0015 BY GILL
        INTO l_aag151,l_aag161,l_aag171,l_aag181,l_aag05,l_aag21,l_aag23,
             l_aag311,l_aag321,l_aag331,l_aag341,l_aag351,l_aag361,l_aag371 #FUN-5C0015 BY GILL
       FROM aag_file WHERE aag01 = g_npq[l_ac].npq03 AND aag07 != '1'
                       AND aag00 = g_bookno33  #No.FUN-730020
#END MOD-5B0256
      IF l_aag05 = 'N' THEN
         CALL cl_set_comp_entry("npq05",FALSE)
      END IF
#No.FUN-840006 080407 mark --begin
      IF l_aag21 = 'N' OR cl_null(l_aag21) THEN                                  #MOD-AA0006 remark
#         CALL cl_set_comp_entry("npq15",FALSE)   #MOD-570379 #MOD-680003 remark
          CALL cl_set_comp_entry("npq36",FALSE)                                  #MOD-AA0006
      END IF                                                                     #MOD-AA0006 remark
#No.FUN-840006 080407 mark --end
      IF l_aag23 = 'N' OR cl_null(l_aag23) THEN
         #CALL cl_set_comp_entry("npq08",FALSE)       #MOD-8C0274 mark
         CALL cl_set_comp_entry("npq08,npq35",FALSE)  #MOD-8C0274 add
      END IF
      IF cl_null(l_aag151) THEN
         CALL cl_set_comp_entry("npq11",FALSE)
      END IF
      IF cl_null(l_aag161) THEN
         CALL cl_set_comp_entry("npq12",FALSE)
      END IF
      IF cl_null(l_aag171) THEN
         CALL cl_set_comp_entry("npq13",FALSE)
      END IF
      IF cl_null(l_aag181) THEN
         CALL cl_set_comp_entry("npq14",FALSE)
      END IF

      #FUN-5C0015 051216 BY GILL --START
      IF cl_null(l_aag311) THEN
         CALL cl_set_comp_entry("npq31",FALSE)
      END IF
      IF cl_null(l_aag321) THEN
         CALL cl_set_comp_entry("npq32",FALSE)
      END IF
      IF cl_null(l_aag331) THEN
         CALL cl_set_comp_entry("npq33",FALSE)
      END IF
      IF cl_null(l_aag341) THEN
         CALL cl_set_comp_entry("npq34",FALSE)
      END IF
    #MOD-840163 remark begin
      #IF cl_null(l_aag351) THEN
      #   CALL cl_set_comp_entry("npq35",FALSE)
      #END IF
      #IF cl_null(l_aag361) THEN
      #   CALL cl_set_comp_entry("npq36",FALSE)
      #END IF
    #MOD-840163 remark end
      IF cl_null(l_aag371) THEN
         CALL cl_set_comp_entry("npq37",FALSE)
      END IF
      #FUN-5C0015 051216 BY GILL --END

    END IF
     #MOD-530812
    IF g_argv1 = 'FA' AND g_argv2 = '4' THEN
       CALL cl_set_comp_entry('npq21,npq22',TRUE)
    END IF
     #END MOD-530812
    #MOD-550100
   IF g_argv1 = 'NM' AND g_argv2 =  '3' THEN
      LET l_nmg20=''
      SELECT nmg20 INTO l_nmg20 FROM nmg_file WHERE nmg00=g_argv3
      IF l_nmg20<>'0' THEN
         CALL cl_set_comp_entry("npq21,npq22",TRUE)
      END IF
   END IF
   #--
   #FUN-950053 --------------------------add start-------------------------------
   SELECT aag371 INTO l_aag371 FROM aag_file
    WHERE aag01=g_npq[l_ac].npq03
      AND aag00 = g_bookno33
   IF l_aag371= '4' THEN
     #IF g_pmc903 != 'Y' AND g_occ37 != 'Y' THEN   #MOD-B10192 mark
      IF g_pmc903 != 'Y' OR g_occ37 != 'Y' THEN    #MOD-B10192
         CALL cl_set_comp_entry("npq37",FALSE)
      END IF
   END IF
   #FUN-950053 ------------------------add end-----------------------------------
END FUNCTION

#start FUN-670080 add
FUNCTION s_fsgl_out(p_prog)
   DEFINE p_prog       LIKE zaa_file.zaa01,         #No.FUN-680147 VARCHAR(10) #程式代號
          sr           RECORD
                        npp  RECORD LIKE npp_file.*,
                        npq  RECORD LIKE npq_file.*
                       END RECORD,
          l_i          LIKE type_file.num5,     #No.FUN-680147 SMALLINT
          l_name       LIKE type_file.chr20,    #No.FUN-680147 VARCHAR(20)     # External(Disk) file name
          l_za05       LIKE cob_file.cob01      #No.FUN-680147 VARCHAR(40)
   #No.FUN-860005  --BEGIN
   DEFINE l_sysdes      LIKE type_file.chr1000,
          l_np0des      LIKE type_file.chr1000,
          l_aag02       LIKE aag_file.aag02,
          l_str         LIKE adj_file.adj02
   DEFINE l_wc          LIKE type_file.chr1000  #No.TQC-960359
   DEFINE l_wc1         LIKE type_file.chr1000  #No.TQC-960359

   LET g_sql = "npq02.npq_file.npq02,",
               "npq03.npq_file.npq03,",
               "aag02.aag_file.aag02,",
               "npq05.npq_file.npq05,",
               "npq06.npq_file.npq06,",
               "npq24.npq_file.npq24,",
               "npq25.npq_file.npq25,",
               "npq07f.npq_file.npq07f,",
               "npq07.npq_file.npq07,",
               "npq21.npq_file.npq21,",
               "npq22.npq_file.npq22,",
               "npq23.npq_file.npq23,",
               "npq15.npq_file.npq15,",
               "npq08.npq_file.npq08,",
               "npq11.npq_file.npq11,",
               "npq12.npq_file.npq12,",
               "npq13.npq_file.npq13,",
               "npq14.npq_file.npq14,",
               "npq31.npq_file.npq31,",
               "npq32.npq_file.npq32,",
               "npq33.npq_file.npq33,",
               "npq34.npq_file.npq34,",
               "npq35.npq_file.npq35,",
               "npq36.npq_file.npq36,",
               "npq37.npq_file.npq37,",
               "npq04.npq_file.npq04,",
               "azi04.azi_file.azi04,",
               "azi07.azi_file.azi07,",
               "l_str.adj_file.adj02,",
               "npp02.npp_file.npp02,",
               "npp011.npp_file.npp011,",
               "npp03.npp_file.npp03,",
               "l_np0des.type_file.chr1000,",
               "npp01.npp_file.npp01,",
               "nppglno.npp_file.nppglno,",
               "npp00.npp_file.npp00,",
               "nppsys.npp_file.nppsys,",
               "l_sysdes.type_file.chr1000,",
               "npptype.npp_file.npptype"
  #LET l_table = cl_prt_temptable("apyi107",g_sql) CLIPPED   #TQC-BA0110 mark
   LET l_table = cl_prt_temptable("agli142",g_sql) CLIPPED   #TQC-BA0110
   IF l_table = -1 THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep",status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
      EXIT PROGRAM
   END IF
   CALL cl_del_data(l_table)
   #No.FUN-860005  --END
#  LET g_wc = " 1=1"               #No.TQC-960359
   LET l_wc = " 1=1"               #No.TQC-960359
   IF cl_null(g_npp.npp00)  AND cl_null(g_npp.npp01)  AND
      cl_null(g_npp.npp011) AND cl_null(g_npp.nppsys) AND
      cl_null(g_npp.npptype) THEN
#NO.FUN-720003------begin
      IF g_bgerr THEN
         CALL s_errmsg('','','',-400,0)
      ELSE
         CALL cl_err('',-400,0)
      END IF
#NO.FUN-720003-------end
      RETURN
   ELSE
      IF NOT cl_null(g_npp.npp00) THEN
      #  LET g_wc=g_wc," AND npp00 = ",g_npp.npp00    #No.TQC-960359
         LET l_wc=l_wc," AND npp00 = ",g_npp.npp00    #No.TQC-960359
      END IF
      IF NOT cl_null(g_npp.npp01) THEN
      #  LET g_wc=g_wc," AND npp01 ='",g_npp.npp01,"'"#No.TQC-960359
         LET l_wc=l_wc," AND npp01 ='",g_npp.npp01,"'"#No.TQC-960359
      END IF
      IF NOT cl_null(g_npp.npp011) THEN
      #  LET g_wc=g_wc," AND npp011= ",g_npp.npp011    #No.TQC-960359
         LET l_wc=l_wc," AND npp011= ",g_npp.npp011    #No.TQC-960359
      END IF
      IF NOT cl_null(g_npp.nppsys) THEN
      #  LET g_wc=g_wc," AND nppsys='",g_npp.nppsys,"'"#No.TQC-960359
         LET l_wc=l_wc," AND nppsys='",g_npp.nppsys,"'"#No.TQC-960359
      END IF
      IF NOT cl_null(g_npp.npptype) THEN
      #  LET g_wc=g_wc," AND npptype='",g_npp.npptype,"'"#No.TQC-960359
         LET l_wc=l_wc," AND npptype='",g_npp.npptype,"'"#No.TQC-960359
      END IF
   END IF
#   CALL cl_wait()    #No.FUN-860005
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

   # 組合出 SQL 指令
   LET g_sql="SELECT npp_file.*,npq_file.*",
             "  FROM npp_file,npq_file",
             " WHERE nppsys =npqsys",
             "   AND npp00  =npq00",
             "   AND npp01  =npq01",
             "   AND npp011 =npq011",
             "   AND npptype=npqtype", #FUN-670047
           # "   AND ",g_wc CLIPPED,   #No.TQC-960359
             "   AND ",l_wc CLIPPED,   #No.TQC-960359
             " ORDER BY npp01,npp011,npq02"
   PREPARE s_fsgl_p1 FROM g_sql                  # RUNTIME 編譯
   DECLARE s_fsgl_c1 CURSOR FOR s_fsgl_p1        # SCROLL CURSOR

#   CALL cl_outnam(p_prog) RETURNING l_name          #No.FUN-860005

#    CALL s_fsgl_show_field()   # FUN-5C0015 add         #No.FUN-860005 
#   CALL cl_prt_pos_len()      # FUN-5C0015 重算g_len  #No.FUN-860005

#   START REPORT s_fsgl_rep TO l_name              #No.FUN-860005

   FOREACH s_fsgl_c1 INTO sr.*
      IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
         END IF
#NO.FUN-720003-------end
         EXIT FOREACH
      END IF
      #No.FUN-860005  --begin
#      OUTPUT TO REPORT s_fsgl_rep(sr.*)
      CASE sr.npp.nppsys
          WHEN 'FA'
               CALL cl_getmsg('afa-366',g_lang) RETURNING l_sysdes
               CASE sr.npp.npp00
                  WHEN  1    #資本化
                     CALL cl_getmsg('afa-014',g_lang) RETURNING l_np0des
                  WHEN  2    #部門移轉
                     CALL cl_getmsg('afa-016',g_lang) RETURNING l_np0des
                  WHEN  4    #出售
                     CALL cl_getmsg('afa-017',g_lang) RETURNING l_np0des
                  WHEN  5    #報廢
                     CALL cl_getmsg('afa-018',g_lang) RETURNING l_np0des
                  WHEN  6    #銷帳
                     CALL cl_getmsg('afa-019',g_lang) RETURNING l_np0des
                  WHEN  7    #改良
                     CALL cl_getmsg('afa-020',g_lang) RETURNING l_np0des
                  WHEN  8    #重估
                     CALL cl_getmsg('afa-021',g_lang) RETURNING l_np0des
                  WHEN  9    #調整
                     CALL cl_getmsg('afa-022',g_lang) RETURNING l_np0des
                  WHEN  10   #折舊
                     CALL cl_getmsg('afa-365',g_lang) RETURNING l_np0des
                  WHEN  11   #利息資本化
                     CALL cl_getmsg('afa-500',g_lang) RETURNING l_np0des
                  WHEN  12   #保險
                     CALL cl_getmsg('afa-501',g_lang) RETURNING l_np0des
                  WHEN  13   #減值准備
                     CALL cl_getmsg('afa-052',g_lang) RETURNING l_np0des
                  #FUN-BC0035---beging add
                  WHEN  14   #類別異動
                     CALL cl_getmsg('afa-980',g_lang) RETURNING l_np0des        
                  #FUN-BC0035---end add                      
                  OTHERWISE EXIT CASE
               END CASE
          WHEN 'CC'   #成本中心
               CALL cl_getmsg('agl-934',g_lang) RETURNING l_sysdes
               CASE sr.npp.npp00
                  WHEN  1   #內部成本
                     CALL cl_getmsg('agl-935',g_lang) RETURNING l_np0des
                  WHEN  2   #利潤分攤
                     CALL cl_getmsg('agl-933',g_lang) RETURNING l_np0des
                  OTHERWISE EXIT CASE
               END CASE
          WHEN 'CA'   #成本分錄
               CALL cl_getmsg('axc-530',g_lang) RETURNING l_sysdes
               CASE sr.npp.npp00
                  WHEN  1   #成本分錄
                     CALL cl_getmsg('axc-530',g_lang) RETURNING l_np0des
                  OTHERWISE EXIT CASE
               END CASE
          WHEN 'PY'   #人事
#               CALL cl_getmsg('apy-152',g_lang) RETURNING l_sysdes         #CHI-B40058
               CALL cl_getmsg('sub-229',g_lang) RETURNING l_sysdes          #CHI-B40058
               CASE sr.npp.npp00
                  WHEN 1    #應付薪資
#                     CALL cl_getmsg('apy-153',g_lang) RETURNING l_np0des   #CHI-B40058
                     CALL cl_getmsg('sub-230',g_lang) RETURNING l_np0des    #CHI-B40058
                  WHEN 2    #退休金准備
#                     CALL cl_getmsg('apy-154',g_lang) RETURNING l_np0des   #CHI-B40058
                     CALL cl_getmsg('sub-231',g_lang) RETURNING l_np0des    #CHI-B40058
                  WHEN 3    #止付薪資
#                     CALL cl_getmsg('apy-155',g_lang) RETURNING l_np0des   #CHI-B40058
                     CALL cl_getmsg('sub-232',g_lang) RETURNING l_np0des    #CHI-B40058
                  WHEN 4    #獨立薪資
#                     CALL cl_getmsg('apy-156',g_lang) RETURNING l_np0des   #CHI-B40058
                     CALL cl_getmsg('sub-233',g_lang) RETURNING l_np0des    #CHI-B40058
                  OTHERWISE EXIT CASE
               END CASE
          OTHERWISE EXIT CASE
       END CASE

       SELECT azn02,azn04 INTO g_azn02,g_azn04 FROM azn_file
       #WHERE azn01=sr.npp.npp03     #(傳票日)         #CHI-A30021 mark
        WHERE azn01=sr.npp.npp02     #(傳票日)         #CHI-A30021 add
       IF SQLCA.sqlcode THEN
          LET g_azn02 = NULL LET g_azn04 = NULL LET l_str = NULL
       ELSE
          LET l_str = g_azn02,"/",g_azn04
       END IF
       CALL s_get_bookno(YEAR(sr.npp.npp02))
            RETURNING g_flag,g_bookno11,g_bookno22
       IF g_flag =  '1' THEN  #抓不到帳別
          CALL cl_err(sr.npp.npp02,'aoo-081',1)
       END IF
       IF sr.npp.npptype =  '0' THEN
          LET g_bookno33 = g_bookno11
       ELSE
          LET g_bookno33 = g_bookno22
       END IF
       SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.npq.npq03
                                  AND aag00 = g_bookno33
       IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF      #No:MOD-980186  add
       SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file WHERE azi01=sr.npq.npq24
      #IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF      #No:MOD-980186 mark
       EXECUTE insert_prep USING sr.npq.npq02,sr.npq.npq03,l_aag02,sr.npq.npq05,sr.npq.npq06,
                                 sr.npq.npq24,sr.npq.npq25,sr.npq.npq07f,sr.npq.npq07,sr.npq.npq21,
                                 sr.npq.npq22,sr.npq.npq23,sr.npq.npq15,sr.npq.npq08,sr.npq.npq11,
                                 sr.npq.npq12,sr.npq.npq13,sr.npq.npq14,sr.npq.npq31,sr.npq.npq32,
                                 sr.npq.npq33,sr.npq.npq34,sr.npq.npq35,sr.npq.npq36,sr.npq.npq37,
                                 sr.npq.npq04,t_azi04,t_azi07,l_str,sr.npp.npp02,sr.npp.npp011,
                                 sr.npp.npp03,l_np0des,sr.npp.npp01,sr.npp.nppglno,sr.npp.npp00,
                                 sr.npp.nppsys,l_sysdes,sr.npp.npptype
       #No.FUN-860005  --END
   END FOREACH

#   FINISH REPORT s_fsgl_rep     #No.FUN-860005

   CLOSE s_fsgl_c1
   ERROR ""
 #No.FUN-860005  --BEGIN
#   CALL cl_prt(l_name,' ','1',g_len)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
   IF g_zz05="Y" THEN
   #  CALL cl_wcchp(g_wc,'npptype,npp00,npp01,npp011,npp02,nppsys,nppglno,npp03')  #TQC-960359
      CALL cl_wcchp(l_wc,'npptype,npp00,npp01,npp011,npp02,nppsys,nppglno,npp03')  #TQC-960359
   #  RETURNING g_wc
      RETURNING l_wc1                              #No.TQC-960359
   #  LET g_str=g_wc
      LET g_str=l_wc1                              #No.TQC-960359
   END IF
#  LET g_prog = 'apyi107'                          #FUN-870151   #TQC-AC0261
   LET g_prog = 'agli142'                          #TQC-BA0110
   LET g_str= g_str,';',g_aza.aza63,';',g_azi04,';',g_aaz.aaz88,';',g_aaz.aaz125  #FUN-B50105 Add ,g_aaz.aaz125  #TQC-BA0110 mod
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  #CALL cl_prt_cs3("apyi107","apyi107",g_sql,g_str)   #TQC-BA0110 mark
   CALL cl_prt_cs3("agli142","agli142",g_sql,g_str)   #TQC-BA0110
   #No.FUN-860005  --END
END FUNCTION

#No.FUN-860005  --BEGIN
#REPORT s_fsgl_rep(sr)
#  DEFINE l_trailer_sw  LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(01)
#         l_sysdes      LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(8)
#         l_np0des      LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(8)
#         l_aag02       LIKE aag_file.aag02,
#         l_str         LIKE adj_file.adj02,         #No.FUN-680147 VARCHAR(20)
#         sr            RECORD
#                        npp  RECORD LIKE npp_file.*,
#                        npq  RECORD LIKE npq_file.*
#                       END RECORD

#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line

#  ORDER EXTERNAL BY sr.npp.npp01,sr.npp.npp011,sr.npq.npq02

#  FORMAT
#    PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash[1,g_len]
#
#     #start FUN-660165 modify
#      CASE sr.npp.nppsys
#         WHEN 'FA'
#              CALL cl_getmsg('afa-366',g_lang) RETURNING l_sysdes
#              CASE sr.npp.npp00
#                 WHEN  1    #資本化
#                    CALL cl_getmsg('afa-014',g_lang) RETURNING l_np0des
#                 WHEN  2    #部門移轉
#                    CALL cl_getmsg('afa-016',g_lang) RETURNING l_np0des
#                 WHEN  4    #出售
#                    CALL cl_getmsg('afa-017',g_lang) RETURNING l_np0des
#                 WHEN  5    #報廢
#                    CALL cl_getmsg('afa-018',g_lang) RETURNING l_np0des
#                 WHEN  6    #銷帳
#                    CALL cl_getmsg('afa-019',g_lang) RETURNING l_np0des
#                 WHEN  7    #改良
#                    CALL cl_getmsg('afa-020',g_lang) RETURNING l_np0des
#                 WHEN  8    #重估
#                    CALL cl_getmsg('afa-021',g_lang) RETURNING l_np0des
#                 WHEN  9    #調整
#                    CALL cl_getmsg('afa-022',g_lang) RETURNING l_np0des
#                 WHEN  10   #折舊
#                    CALL cl_getmsg('afa-365',g_lang) RETURNING l_np0des
#                 WHEN  11   #利息資本化
#                    CALL cl_getmsg('afa-500',g_lang) RETURNING l_np0des
#                 WHEN  12   #保險
#                    CALL cl_getmsg('afa-501',g_lang) RETURNING l_np0des
#                 WHEN  13   #減值準備
#                    CALL cl_getmsg('afa-052',g_lang) RETURNING l_np0des
#                 OTHERWISE EXIT CASE
#              END CASE
#         WHEN 'CC'   #成本中心
#              CALL cl_getmsg('agl-934',g_lang) RETURNING l_sysdes
#              CASE sr.npp.npp00
#                 WHEN  1   #內部成本
#                    CALL cl_getmsg('agl-935',g_lang) RETURNING l_np0des
#                 WHEN  2   #利潤分攤
#                    CALL cl_getmsg('agl-933',g_lang) RETURNING l_np0des
#                 OTHERWISE EXIT CASE
#              END CASE
#         WHEN 'CA'   #成本分錄
#              CALL cl_getmsg('axc-530',g_lang) RETURNING l_sysdes
#              CASE sr.npp.npp00
#                 WHEN  1   #成本分錄
#                    CALL cl_getmsg('axc-530',g_lang) RETURNING l_np0des
#                 OTHERWISE EXIT CASE
#              END CASE
#        #start FUN-690134 add
#         WHEN 'PY'   #人事
#              CALL cl_getmsg('apy-152',g_lang) RETURNING l_sysdes
#              CASE sr.npp.npp00
#                 WHEN 1    #應付薪資
#                    CALL cl_getmsg('apy-153',g_lang) RETURNING l_np0des
#                 WHEN 2    #退休金準備
#                    CALL cl_getmsg('apy-154',g_lang) RETURNING l_np0des
#                 WHEN 3    #止付薪資
#                    CALL cl_getmsg('apy-155',g_lang) RETURNING l_np0des
#                 WHEN 4    #獨立薪資
#                    CALL cl_getmsg('apy-156',g_lang) RETURNING l_np0des
#                 OTHERWISE EXIT CASE
#              END CASE
#        #end FUN-690134 add
#         OTHERWISE EXIT CASE
#      END CASE
#     #end FUN-660165 modify

#      SELECT azn02,azn04 INTO g_azn02,g_azn04 FROM azn_file
#       WHERE azn01=sr.npp.npp03     #(傳票日)
#      IF SQLCA.sqlcode THEN
#         LET g_azn02 = NULL LET g_azn04 = NULL LET l_str = NULL
#      ELSE
#         LET l_str = g_azn02,"/",g_azn04
#      END IF
#     #start FUN-690134 add
#      IF g_aza.aza63 = 'Y' THEN
#         PRINT COLUMN 1,g_x[20],sr.npp.npptype CLIPPED," ";
#         IF sr.npp.npptype='0' THEN
#             PRINT g_x[21] CLIPPED
#         ELSE
#             PRINT g_x[22] CLIPPED
#         END IF
#      ELSE
#         PRINT
#      END IF
#     #end FUN-690134 add
#      PRINT COLUMN  1,g_x[9] ,sr.npp.nppsys CLIPPED," ",l_sysdes CLIPPED,
#            COLUMN 27,g_x[10],sr.npp.npp00 CLIPPED,
#            COLUMN 67,g_x[11],sr.npp.nppglno CLIPPED
#      PRINT COLUMN  1,g_x[12],sr.npp.npp01 CLIPPED,
#            COLUMN 27,g_x[13],l_np0des CLIPPED,
#            COLUMN 67,g_x[14],sr.npp.npp03 CLIPPED
#      PRINT COLUMN  1,g_x[15],sr.npp.npp011 USING '####&',
#            COLUMN 27,g_x[16],sr.npp.npp02 CLIPPED,
#            COLUMN 67,g_x[17],l_str CLIPPED
#      PRINT
#      #No.FUN-730020  --Begin
#      CALL s_get_bookno(YEAR(sr.npp.npp02))   #TQC-740042
#           RETURNING g_flag,g_bookno11,g_bookno22
#      IF g_flag =  '1' THEN  #抓不到帳別
#         CALL cl_err(sr.npp.npp02,'aoo-081',1)
#      END IF
#      IF sr.npp.npptype =  '0' THEN
#         LET g_bookno33 = g_bookno11
#      ELSE
#         LET g_bookno33 = g_bookno22
#      END IF
#      #No.FUN-730020  --End
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
#            g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#            g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56]
#      PRINT g_dash1
#      LET l_trailer_sw = 'y'

#    ON EVERY ROW
#      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.npq.npq03
#                                 AND aag00 = g_bookno33  #No.FUN-730020
#      SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file WHERE azi01=sr.npq.npq24   #MOD-770076
#      IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF
#      PRINT COLUMN g_c[31],sr.npq.npq02 USING '###&',           #項次
#            COLUMN g_c[32],sr.npq.npq03 CLIPPED,                #科目
#            COLUMN g_c[33],l_aag02 CLIPPED,                     #名稱
#            COLUMN g_c[34],sr.npq.npq05 CLIPPED;                #部門
#     #start FUN-690134 modify
#     #      COLUMN g_c[35],sr.npq.npq06 CLIPPED,                #借/貸
#      IF sr.npq.npq06 = '1' THEN
#         PRINT COLUMN g_c[35],sr.npq.npq06 CLIPPED,":",g_x[18] CLIPPED;
#      ELSE
#         PRINT COLUMN g_c[35],sr.npq.npq06 CLIPPED,":",g_x[19] CLIPPED;
#      END IF
#     #end FUN-690134 modify
#      PRINT COLUMN g_c[36],sr.npq.npq24 CLIPPED,                #幣別
#            #COLUMN g_c[37],cl_numfor(sr.npq.npq25,37,g_azi07),  #匯率   #MOD-770076
#            COLUMN g_c[37],cl_numfor(sr.npq.npq25,37,t_azi07),  #匯率   #MOD-770076
#            #COLUMN g_c[38],cl_numfor(sr.npq.npq07f,38,g_azi04), #原幣金額   #MOD-770076
#            COLUMN g_c[38],cl_numfor(sr.npq.npq07f,38,t_azi04), #原幣金額   #MOD-770076
#            COLUMN g_c[39],cl_numfor(sr.npq.npq07,39,g_azi04),  #本幣金額
#            COLUMN g_c[40],sr.npq.npq21 CLIPPED,                #客戶/廠商
#            COLUMN g_c[41],sr.npq.npq22 CLIPPED,                #客戶簡稱/廠商簡稱
#            COLUMN g_c[42],sr.npq.npq23 CLIPPED,                #參考單號
##            COLUMN g_c[43],sr.npq.npq15 CLIPPED,                #預算  #No.FUN-840006 去掉npq15
#            COLUMN g_c[44],sr.npq.npq08 CLIPPED,                #專案編號
#            COLUMN g_c[45],sr.npq.npq11 CLIPPED,                #異動碼-1
#            COLUMN g_c[46],sr.npq.npq12 CLIPPED,                #異動碼-2
#            COLUMN g_c[47],sr.npq.npq13 CLIPPED,                #異動碼-3
#            COLUMN g_c[48],sr.npq.npq14 CLIPPED,                #異動碼-4
#            COLUMN g_c[49],sr.npq.npq31 CLIPPED,                #異動碼-5
#            COLUMN g_c[50],sr.npq.npq32 CLIPPED,                #異動碼-6
#            COLUMN g_c[51],sr.npq.npq33 CLIPPED,                #異動碼-7
#            COLUMN g_c[52],sr.npq.npq34 CLIPPED,                #異動碼-8
#            COLUMN g_c[53],sr.npq.npq35 CLIPPED,                #異動碼-9
#            COLUMN g_c[54],sr.npq.npq36 CLIPPED,                #異動碼-10
#            COLUMN g_c[55],sr.npq.npq37 CLIPPED,                #異動碼-關係人
#            COLUMN g_c[56],sr.npq.npq04 CLIPPED                 #摘要
#
#    ON LAST ROW
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_trailer_sw = 'n'

#    PAGE TRAILER
#      IF l_trailer_sw = 'y' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#END REPORT
   #No.FUN-860005  --END
FUNCTION s_fsgl_show_field()
#依參數決定異動碼的多寡

   IF g_aaz.aaz88 < 10 THEN
      LET g_zaa[54].zaa06 = "Y"
   END IF

   IF g_aaz.aaz88 < 9 THEN
      LET g_zaa[53].zaa06 = "Y"
   END IF

   IF g_aaz.aaz125 < 8 THEN        #FUN-B50105   azz88  -->  azz125
      LET g_zaa[52].zaa06 = "Y"
   END IF

   IF g_aaz.aaz125 < 7 THEN        #FUN-B50105   azz88  -->  azz125
      LET g_zaa[51].zaa06 = "Y"
   END IF

   IF g_aaz.aaz125 < 6 THEN        #FUN-B50105   azz88  -->  azz125
      LET g_zaa[50].zaa06 = "Y"
   END IF

   IF g_aaz.aaz125 < 5 THEN        #FUN-B50105   azz88  -->  azz125
      LET g_zaa[49].zaa06 = "Y"
   END IF

   IF g_aaz.aaz88 < 4 THEN
      LET g_zaa[48].zaa06 = "Y"
   END IF

   IF g_aaz.aaz88 < 3 THEN
      LET g_zaa[47].zaa06 = "Y"
   END IF

   IF g_aaz.aaz88 < 2 THEN
      LET g_zaa[46].zaa06 = "Y"
   END IF

   IF g_aaz.aaz88 < 1 THEN
      LET g_zaa[45].zaa06 = "Y"
   END IF

END FUNCTION

FUNCTION s_fsgl_exporttoexcel()
   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_npq),'','')
END FUNCTION

FUNCTION s_fsgl_d()   #明細查詢
   DEFINE tm            RECORD
                         dept   LIKE npq_file.npq05,   #銷售成本中心
                         gem02  LIKE gem_file.gem02,   #名稱
                         yy     LIKE ahj_file.ahj02,   #No.FUN-680147 VARCHAR(4) #年度
                         mm     LIKE ahj_file.ahj03,   #No.FUN-680147 VARCHAR(2) #期別
                         a      LIKE npp_file.npp00,   #類別
                         a_desc LIKE npq_file.npq04    #No.FUN-680147 VARCHAR(8) #類別說明
                        END RECORD,
          l_npq04_1     LIKE npq_file.npq04,           #摘要
          l_npq04_2     LIKE npq_file.npq04,           #摘要
          l_npq04_3     LIKE npq_file.npq04,           #摘要
          l_npq04_4     LIKE npq_file.npq04            #摘要

   OPEN WINDOW i142_w_d AT 0,0 WITH FORM "agl/42f/agli142_d"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_locale("agli142_d")

   CALL s_fsgl_show_filed()    #FUN-B50105

   LET tm.dept=g_npq_t.npq05
   SELECT gem02 INTO tm.gem02 FROM gem_file WHERE gem01=tm.dept
                                              AND gem05 = 'Y'       #MOD-B50004
   IF SQLCA.SQLCODE THEN LET tm.gem02=' ' END IF
   LET tm.yy  =g_npp.npp01[1,4]
   LET tm.mm  =g_npp.npp01[5,6]
   CALL cl_getmsg('agl-931',g_lang) RETURNING l_npq04_1   #領用
   CALL cl_getmsg('asf-851',g_lang) RETURNING l_npq04_2   #入庫
   CALL cl_getmsg('agl-932',g_lang) RETURNING l_npq04_3   #銷售
   CALL cl_getmsg('agl-933',g_lang) RETURNING l_npq04_4   #利潤分攤
   CASE g_npq_t.npq04
      WHEN l_npq04_1
         LET tm.a ='1'
         LET tm.a_desc = l_npq04_1
      WHEN l_npq04_2
         LET tm.a ='2'
         LET tm.a_desc = l_npq04_2
      WHEN l_npq04_3
         LET tm.a ='3'
         LET tm.a_desc = l_npq04_3
      WHEN l_npq04_4
         LET tm.a ='1'
         LET tm.a_desc = l_npq04_4
   END CASE
   DISPLAY tm.dept,tm.gem02,tm.yy,tm.mm,tm.a,tm.a_desc
        TO FORMONLY.dept,FORMONLY.gem02,FORMONLY.yy,FORMONLY.mm,
           FORMONLY.a,FORMONLY.a_desc
   DISPLAY 1 TO FORMONLY.cnt

   CALL s_fsgl_d_fill(tm.*)

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq2 TO s_npq2.* ATTRIBUTE(COUNT=g_rec_b)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      ON ACTION exit
         EXIT DISPLAY

      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CLOSE WINDOW i142_w_d
   RETURN
END FUNCTION

FUNCTION s_fsgl_d_fill(tm)
   DEFINE tm            RECORD
                         dept   LIKE npq_file.npq05,   #銷售成本中心
                         gem02  LIKE gem_file.gem02,   #名稱
                         yy     LIKE ahj_file.ahj02,   #No.FUN-680147 VARCHAR(4)  #年度
                         mm     LIKE ahj_file.ahj03,   #No.FUN-680147 VARCHAR(2)   #期別
                         a      LIKE npp_file.npp00,   #類別
                         a_desc LIKE npq_file.npq04    #No.FUN-680147 VARCHAR(8) #類別說明
                        END RECORD
   DEFINE l_sql         STRING,
          l_npq04_1     LIKE npq_file.npq04,           #摘要
          l_npq04_2     LIKE npq_file.npq04,           #摘要
          l_npq04_3     LIKE npq_file.npq04,           #摘要
          l_npq04_4     LIKE npq_file.npq04,           #摘要
          l_amt1        LIKE ahi_file.ahi04,
          l_amt2        LIKE ahi_file.ahi05

   CALL cl_getmsg('agl-931',g_lang) RETURNING l_npq04_1   #領用
   CALL cl_getmsg('asf-851',g_lang) RETURNING l_npq04_2   #入庫
   CALL cl_getmsg('agl-932',g_lang) RETURNING l_npq04_3   #銷售
   CALL cl_getmsg('agl-933',g_lang) RETURNING l_npq04_4   #利潤分攤
   CASE g_npp.npp00
      WHEN  1   #內部成本
         #資料來源.tlf_file,ahi_file
         LET l_sql = "SELECT tlf06,tlf905,tlf906,tlf01,ima02,ima021,ima25,",
                     "       tlf10*tlf60,tlf902,tlf903,tlf904,",
                     "       ahi04,ahi04*tlf10*tlf60,ahi05,ahi05*tlf10*tlf60,",
                     "       tlf14,azf03",
                     "  FROM tlf_file LEFT OUTER JOIN ahi_file ON tlf01=ahi03",  #FUN-9A0083
                     " LEFT OUTER JOIN ima_file ON tlf01=ima01 LEFT OUTER JOIN azf_file ON (tlf14=azf01 AND azf_file.azf02=2) LEFT OUTER JOIN imd_file ON tlf902=imd01 ",  #FUN-9A0083
                     #" WHERE tlf01=ahi_file.ahi03",  #FUN-9A0083 mark
                     "  WHERE  YEAR(tlf_file.tlf06) =ahi_file.ahi01",
                     "   AND MONTH(tlf_file.tlf06)=ahi_file.ahi02",
                     #"   AND tlf_file.tlf01=ima_file.ima01",   #FUN-9A0083
                     #"   AND tlf_file.tlf14=azf_file.azf01 AND azf_file.azf02='2'", #FUN-9A0083
                     #"   AND tlf_file.tlf902=imd_file.imd01",  #FUN-9A0083
                     "   AND YEAR(tlf06) =",tm.yy,
                     "   AND MONTH(tlf06)=",tm.mm

         IF g_npq_t.npq04=l_npq04_1 THEN   #領用
            LET l_sql = l_sql,
                        "   AND (tlf13 MATCHES 'asfi51*' OR",
                        "        tlf13 MATCHES 'asfi52*' OR",
                        "        tlf13 MATCHES 'asri21*' OR",
                        "        tlf13 MATCHES 'asri22*')",
                        "   AND tlf930='",g_npq_t.npq05,"'"
         END IF
         IF g_npq_t.npq04=l_npq04_2 THEN   #入庫
            LET l_sql = l_sql,
                        "   AND (tlf13 = 'asft6201' OR",
                        "        tlf13 = 'asrt320')",
                        "   AND imd16='",g_npq_t.npq05,"'"
         END IF
         IF g_npq_t.npq04=l_npq04_3 THEN   #銷售
            LET l_sql = l_sql,
                        "   AND (tlf13 = 'axmt620' OR",
                        "        tlf13 = 'axmt650' OR",
                        "        tlf13 = 'aomt800')",
                        "   AND tlf930='",g_npq_t.npq05,"'"
         END IF
         LET l_sql = l_sql," ORDER BY tlf06"
      WHEN  2   #利潤分攤
         #資料來源.ahj_file,oga_file
         LET l_sql = "SELECT oga02,ahj04,ahj05,ahj06,ahj061,ima021,ima25,",
                     "       ahj07,ogb09,ogb091,ogb092,",
                     "       ahj08,ahj09,ahj10,ahj11,'',''",
                     "  FROM oga_file,ogb_file,ahj_file LEFT OUTER JOIN ima_file ON ahj06 = ima01 ",  #No.FUN-9A0083 mod
                     " WHERE ahj04=oga01",
                     "   AND ahj04=ogb01 AND ahj05=ogb03",
                     #"   AND ahj_file.ahj06=ima_file.ima01",  #FUN-9A0083 mark
                     "   AND ahj02=",tm.yy,
                     "   AND ahj03=",tm.mm
         IF g_npq_t.npq04=l_npq04_4 THEN   #利潤分攤
            LET l_sql = l_sql,"   AND ahj15='",g_npq_t.npq05,"'"
         END IF
         LET l_sql = l_sql," ORDER BY oga02"
      OTHERWISE EXIT CASE
   END CASE

   PREPARE fsgl_d_pl FROM l_sql
   DECLARE fsgl_d_cl CURSOR FOR fsgl_d_pl

   CALL g_npq2.clear()
   LET g_cnt = 1
   LET l_amt1 = 0 LET l_amt2 = 0
   FOREACH fsgl_d_cl INTO g_npq2[g_cnt].*              #單身 ARRAY 填充
       IF STATUS THEN
#NO.FUN-720003------begin
          IF g_bgerr THEN
             CALL s_errmsg('','','foreach:',STATUS,1)
          ELSE
             CALL cl_err('foreach:',STATUS,1)
          END IF
#NO.FUN-720003-------end
       EXIT FOREACH END IF
       LET l_amt1 = l_amt1 + g_npq2[g_cnt].ahi04a
       LET l_amt2 = l_amt2 + g_npq2[g_cnt].ahi05a
       LET g_cnt = g_cnt + 1
       #No.TQC-630109 --start--
       IF g_cnt > g_max_rec THEN
#NO.FUN-720003------begin
          IF g_bgerr THEN
             CALL s_errmsg('','','', 9035, 0 )
          ELSE
             CALL cl_err( '', 9035, 0 )
          END IF
#NO.FUN-720003-------end
          EXIT FOREACH
       END IF
       #No.TQC-630109 ---end---
   END FOREACH
   #CKP
   CALL g_npq2.deleteElement(g_cnt)
   LET g_rec_b= g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   DISPLAY l_amt1 TO FORMONLY.amt1
   DISPLAY l_amt2 TO FORMONLY.amt2
END FUNCTION
#end FUN-670080 add

#start FUN-690134 add
FUNCTION s_fsgl_related_document()
   IF g_npp.npp01 IS NOT NULL THEN
      LET g_doc.column1 = "nppsys"
      LET g_doc.column2 = "npp00"
      LET g_doc.column3 = "npp01"
      LET g_doc.column4 = "npp011"
      LET g_doc.column5 = "npptype"
      LET g_doc.value1 = g_npp.nppsys
      LET g_doc.value2 = g_npp.npp00
      LET g_doc.value3 = g_npp.npp01
      LET g_doc.value4 = g_npp.npp011
      LET g_doc.value5 = g_npp.npptype
      CALL cl_doc()
   END IF
END FUNCTION

FUNCTION s_fsgl_t()
DEFINE li_chk_bookno    LIKE type_file.num5        #No.FUN-670003  #No.FUN-680126 SMALLINT
DEFINE yy_t		LIKE type_file.chr6,       #No.FUN-680126 VARCHAR(6)
       mm_t		LIKE type_file.chr6        #No.FUN-680126 VARCHAR(6)
DEFINE p_row,p_col      LIKE type_file.num5        #No.FUN-680126 SMALLINT
DEFINE l_cnt            LIKE type_file.num5,       #No.FUN-580111  -add    #No.FUN-680126 SMALLINT
       l_sql            STRING    #No.FUN-670003  -add
DEFINE l_tmn02          LIKE tmn_file.tmn02        #No.FUN-670068
DEFINE l_tmn06          LIKE tmn_file.tmn06        #No.FUN-670068

#No.TQC-6C0071 --begin
#  LET tm.a = g_bookno         # No.FUN-680068
#  LET tm.a1 = g_bookno1       # No.FUN-680068
#No.TQC-6C0071 --end

   IF cl_null(g_npp.npp01)       THEN RETURN  END IF

   IF NOT cl_null(g_npp.nppglno) THEN
#NO.FUN-720003------begin
      IF g_bgerr THEN
#         CALL s_errmsg('','',g_npp.nppglno,'apy-608',0)   #CHI-B40058
         CALL s_errmsg('','',g_npp.nppglno,'sub-234',0)    #CHI-B40058
       ELSE
#         CALL cl_err(g_npp.nppglno,'apy-608',0)           #CHI-B40058
         CALL cl_err(g_npp.nppglno,'sub-234',0)            #CHI-B40058
       END IF
#NO.FUN-720003-------end
       RETURN
   END IF

   DELETE FROM agl_tmp_file     #No.FUN-580111
   LET p_row = 4 LET p_col = 10

   OPEN WINDOW s_fsgl_t_w AT p_row,p_col
      WITH FORM "apy/42f/apyi107_t"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_locale("apyi107_t")
    CALL cl_set_comp_visible("a1,gl_no1",g_aza.aza63='Y')   # No.FUN-680068

  #-----TQC-B90211--------- 
  ##MOD-7B0004-begin-modify
  #IF g_cpa.cpa149='Y' THEN
  ##LET tm.plant= g_plant                   #No.FUN-560190
  # LET tm.plant = g_cpa.cpa150
  # LET tm.a     = g_cpa.cpa151
  # LET tm.a1    = g_cpa.cpa152
  #ELSE
  # LET tm.plant = g_plant
  # LET tm.a     = ''
  # LET tm.a1    = ''
  #END IF
  ##MOD-7B0004-end-modify
  LET tm.plant = g_plant
  LET tm.a     = ''
  LET tm.a1    = ''
  #-----END TQC-B90211-----
   LET l_plant_old = g_plant      #No.FUN-580111  --add
   LET tm.gl_no=''
#  LET tm.gl_no[4,4] = '-'
#  LET tm.gl_no[g_doc_len+1,g_doc_len+1] = '-'   #No.FUN-550062
  #LET tm.a =''                                    #MOD-7B0004 mark
   LET tm.gl_no1=''               #No.FUN-680068
  #LET tm.a1=''                   #No.FUN-680068   #MOD-7B0004 mark
   LET tm.gl_date = g_today
   BEGIN WORK   #MOD-660001 add
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INPUT BY NAME tm.plant,tm.a,tm.a1,tm.gl_no,tm.gl_no1,tm.gl_date          # No.FUN-680068 add tm.a1 , tm.gl_no1
     WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)   #No.FUN-580111  --add UNBUFFERED
#MOD-7B0004-begin-mark
# BEFORE INPUT
## No.FUN-680068 --start--
#  LET tm.a=g_cpa.cpa151
#  IF g_aza.aza63 = 'Y' THEN
#    LET tm.a1 = g_cpa.cpa152
#  END IF
## No.FUN-680068 ---end---
#MOD-7B0004-end-mark
        AFTER FIELD plant
            IF NOT cl_null(tm.plant) THEN
               SELECT azp01 FROM azp_file WHERE azp01 = tm.plant
               IF STATUS <> 0 THEN
#                CALL cl_err(p_plant,'aap-025',0) #MOD-480614   #No.FUN-660130
#NO.FUN-720003------begin
                 IF g_bgerr THEN
                    CALL s_errmsg('azp01',tm.plant,p_plant,'aap-025',1)
                 ELSE
                    CALL cl_err3("sel","azp_file",tm.plant,"","aap-025","","",1)  #No.FUN-660130
                 END IF
#NO.FUN-720003-------end
                NEXT FIELD plant
               END IF
               # 得出總帳 database name
               LET g_plant_new= tm.plant  # 工廠編號
               CALL s_getdbs()
               LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
               LET g_plant_gl= tm.plant  # 工廠編號
               #No.FUN-580111  --begin
               IF l_plant_old != tm.plant THEN
#No.FUN-670068--begin
                  FOREACH tmn_del INTO l_tmn02,l_tmn06
                     DELETE FROM tmn_file
                     WHERE tmn01 = l_plant_old
                       AND tmn02 = l_tmn02
                       AND tmn06 = l_tmn06
                  END FOREACH
#                 DELETE FROM tmn_file
#                 WHERE tmn01 = l_plant_old
#                   AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
#No.FUN-670068--end
                  DELETE FROM agl_tmp_file
                  LET l_plant_old = g_plant_new
               END IF
               #No.FUN-580111  --end
            END IF

         AFTER FIELD a
            IF NOT cl_null(tm.a) THEN
                #No.FUN-670003--begin
                CALL s_check_bookno(tm.a,g_user,tm.plant)
                     RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                     NEXT FIELD a
                END IF
                 LET g_plant_new= tm.plant  # 工廠編號
                 #CALL s_getdbs()           #FUN-A50102
                 LET l_sql = "SELECT COUNT(*) ",
                             #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                             "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                             " WHERE aaa01 = '",tm.a,"' ",
                             "   AND aaaacti = 'Y' "
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                 PREPARE s_fsgl_pre2 FROM l_sql
                 DECLARE s_fsgl_cur2 CURSOR FOR s_fsgl_pre2
                 OPEN s_fsgl_cur2
                 FETCH s_fsgl_cur2 INTO g_cnt
#              SELECT COUNT(*) INTO g_cnt FROM aaa_file #須存在帳別參數檔
#               WHERE aaa01 = tm.a AND aaaacti = 'Y'
                #No.FUN-670003--end
               IF g_cnt = 0 THEN
#NO.FUN-720003------begin
                  IF g_bgerr THEN
                     CALL s_errmsg('aaa01',tm.a,tm.a,'agl-043',0)
                  ELSE
                     CALL cl_err(tm.a,'agl-043',0)
                  END IF
#NO.FUN-720003-------end
                  LET tm.a = NULL
                  NEXT FIELD a
               END IF
               LET g_bookno  = tm.a      #TQC-6C0071
            END IF
# No.FUN-680068 --start--
         AFTER FIELD a1
            IF NOT cl_null(tm.a1) THEN
                CALL s_check_bookno(tm.a1,g_user,tm.plant)
                     RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                     NEXT FIELD a1
                END IF
                 LET g_plant_new= tm.plant  # 工廠編號
                 #CALL s_getdbs()           #FUN-A50102
                 LET l_sql = "SELECT COUNT(*) ",
                             #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                             "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                             " WHERE aaa01 = '",tm.a1,"' ",
                             "   AND aaaacti = 'Y' "
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                 PREPARE s_fsgl_pre21 FROM l_sql
                 DECLARE s_fsgl_cur21 CURSOR FOR s_fsgl_pre21
                 OPEN s_fsgl_cur21
                 FETCH s_fsgl_cur21 INTO g_cnt

               IF g_cnt = 0 THEN
#NO.FUN-720003------begin
                  IF g_bgerr THEN
                     CALL s_errmsg('aaa01',tm.a1,tm.a1,'agl-043',0)
                  ELSE
                     CALL cl_err(tm.a1,'agl-043',0)
                  END IF
#NO.FUN-720003-------end
                  LET tm.a1 = NULL
                  NEXT FIELD a1
               END IF
              IF tm.a1 = tm.a THEN
#NO.FUN-720003------begin
                  IF g_bgerr THEN
                     CALL s_errmsg('aaa01',tm.a1,tm.a1,'axr-090',0)
                  ELSE
                     CALL cl_err(tm.a1,'axr-090',0)
                  END IF
#NO.FUN-720003-------end
                 LET tm.a1 = NULL
                NEXT FIELD a1
              END IF
              LET g_bookno1 = tm.a1      #TQC-6C0071
         END IF
# No.FUN-680068 ---end---
         AFTER FIELD gl_date
            IF NOT cl_null(tm.gl_date) THEN
               SELECT azn02,azn04 INTO l_azn02,l_azn04 FROM azn_file
                      WHERE azn01 = tm.gl_date
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(tm.gl_date,'agl-101',0)   #No.FUN-660130
#NO.FUN-720003------begin
                  IF g_bgerr THEN
                     CALL s_errmsg('azn01',tm.gl_date,tm.gl_date,'agl-101',0)
                  ELSE
                     CALL cl_err3("sel","azn_file",tm.gl_date,"","agl-101","","",1)  #No.FUN-660130
                  END IF
#NO.FUN-720003-------end
                  NEXT FIELD gl_date
               ELSE
                  IF tm. gl_date <= g_aaa.aaa07 THEN   #判斷關帳日期
#NO.FUN-720003------begin
                   IF g_bgerr THEN
                      CALL s_errmsg('','',tm.gl_date,'agl-104',0)
                   ELSE
                      CALL cl_err(tm.gl_date,'agl-104',0)
                   END IF
#NO.FUN-720003-------end
                     NEXT FIELD gl_date
                  END IF
               END  IF
               LET g_yy=l_azn02
               LET g_mm=l_azn04
               DISPLAY l_azn02,l_azn04 TO yy,mm
            END IF

         AFTER FIELD gl_no
            IF NOT cl_null(tm.gl_no) THEN
#No.FUN-560190--begin
           #CALL s_check_no("agl",tm.gl_no,"","1","aba_file","aba01",g_dbs_gl) #FUN-980094 mark
            CALL s_check_no("agl",tm.gl_no,"","1","aba_file","aba01",tm.plant) #FUN-980094
               RETURNING li_result,tm.gl_no
               IF (NOT li_result) THEN
                  LET tm.gl_no = NULL
                  NEXT FIELD gl_no
               END IF

#              SELECT COUNT(*) INTO g_cnt FROM aac_file       #須存在傳票單別檔
#               WHERE aac01=g_t1 AND aacacti = 'Y'
#              IF g_cnt = 0  THEN             #抱歉, 讀不到
#                 CALL cl_err(g_t1,"agl-035",0) #無此單別
#                 LET tm.gl_no = NULL
#                 DISPLAY BY NAME tm.gl_no
#                 NEXT FIELD gl_no
#              END IF
#              IF NOT cl_null(tm.gl_no[g_no_sp,g_no_ep]) THEN  #No.FUN-550062
#                 SELECT COUNT(*) INTO g_cnt FROM aba_file     #傳票編號重複
#                  WHERE aba01=tm.gl_no AND aba00 =tm.a
#                 IF g_cnt > 0  THEN
#                    CALL cl_err(tm.gl_no,"axm-220",0)
#                    LET tm.gl_no = NULL
#                    DISPLAY BY NAME tm.gl_no
#                    NEXT FIELD gl_no
#                 END IF
#       ELSE
#                ----------取得傳票編號---------
               #BEGIN WORK   #MOD-580072 mark
              #CALL s_auto_assign_no("agl",tm.gl_no,tm.gl_date,"","","",g_dbs_gl,"",tm.a) #FUN-980094 mark
               CALL s_auto_assign_no("agl",tm.gl_no,tm.gl_date,"","","",tm.plant,"",tm.a) #FUN-980094
                 RETURNING li_result,tm.gl_no
               IF (NOT li_result) THEN
                   NEXT FIELD gl_no
               END IF
#                CALL s_m_aglau(g_dbs_gl,tm.a,tm.gl_no[1,3],tm.gl_date,   #No.FUN-550062
#                               l_azn02,l_azn04,0) RETURNING g_i,tm.gl_no
#                IF g_i != 0 THEN NEXT FIELD gl_no END IF
               END IF
#           END IF
#No.FUN-550062-end

# No.FUN-680068 --start--
         AFTER FIELD gl_no1
            IF NOT cl_null(tm.gl_no1) THEN
           #CALL s_check_no("agl",tm.gl_no1,"","1","aba_file","aba01",g_dbs_gl) #FUN-980094
            CALL s_check_no("agl",tm.gl_no1,"","1","aba_file","aba01",tm.plant) #FUN-980094
               RETURNING li_result,tm.gl_no1
               IF (NOT li_result) THEN
                  LET tm.gl_no1 = NULL
                  NEXT FIELD gl_no1
               END IF

              #CALL s_auto_assign_no("agl",tm.gl_no1,tm.gl_date,"","","",g_dbs_gl,"",tm.a1)    # flowld tm.a1.?  #FUN-980094
               CALL s_auto_assign_no("agl",tm.gl_no1,tm.gl_date,"","","",tm.plant,"",tm.a1)    # flowld tm.a1.?  #FUN-980094
                 RETURNING li_result,tm.gl_no1
               IF (NOT li_result) THEN
                   NEXT FIELD gl_no1
               END IF
             END IF

# No.FUN-680068 ---end---
        ON ACTION controlp
            CASE
                #MOD-480614
               WHEN INFIELD(plant) #查詢工廠資料檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  CALL cl_create_qry() RETURNING tm.plant
                  DISPLAY BY NAME tm.plant
                  NEXT FIELD plant
               #--

               WHEN INFIELD(gl_no)
#No.FUN-560190--begin
               LET g_plant_new= tm.plant  # 工廠編號
               CALL s_getdbs()
               LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
               LET g_plant_gl= tm.plant  # 工廠編號#FUN-A50102
               #    CALL q_m_aac(FALSE,TRUE,g_dbs_gl,tm.gl_no,'1','0',' ','AGL')  #No.FUN-980059
                    CALL q_m_aac(FALSE,TRUE,tm.plant,tm.gl_no,'1','0',' ','AGL')  #No.FUN-980059
#No.FUN-560190--end
                         RETURNING tm.gl_no
#                    CALL FGL_DIALOG_SETBUFFER( tm.gl_no )
                    DISPLAY BY NAME tm.gl_no
# No.FUN-680068 --start--
               WHEN INFIELD(gl_no1)
               LET g_plant_new= tm.plant  # 工廠編號
               CALL s_getdbs()
               LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
               LET g_plant_gl= tm.plant  # 工廠編號#FUN-A50102
               #    CALL q_m_aac(FALSE,TRUE,g_dbs_gl,tm.gl_no1,'1','0',' ','AGL')   #No.FUN-980059
                    CALL q_m_aac(FALSE,TRUE,tm.plant,tm.gl_no1,'1','0',' ','AGL')   #No.FUN-980059
                         RETURNING tm.gl_no1
                    DISPLAY BY NAME tm.gl_no1
# No.FUN-680068 ---end---
               OTHERWISE
               EXIT CASE
            END CASE

      #No.FUN-580111  --begin
      ON ACTION get_missing_voucher_no
# No.FUN-680068 --start--
       CASE
          WHEN INFIELD(gl_no)
         IF cl_null(tm.gl_no) THEN
            NEXT FIELD gl_no
         END IF


#No.FUN-670068--begin
         FOREACH tmn_del INTO l_tmn02,l_tmn06
            DELETE FROM tmn_file
            WHERE tmn01 = tm.plant
              AND tmn02 = l_tmn02
              AND tmn06 = l_tmn06
         END FOREACH
#        DELETE FROM tmn_file
#         WHERE tmn01 = tm.plant
#           AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y' AND agl_tmp_file.tc_tmp03=tm.a)
#           AND agl_tmp_file.tc_tmp03=tm.a
#No.FUN-670068--end
         DELETE FROM agl_tmp_file
           WHERE agl_tmp_file.tc_tmp03 = tm.a

#         CALL s_agl_missingno(tm.plant,g_dbs_gl,g_bookno,tm.gl_no,tm.gl_date,0)
          CALL s_agl_missingno(tm.plant,g_dbs_gl,tm.a,tm.gl_no,tm.a1,tm.gl_no1,tm.gl_date,0)
         SELECT COUNT(*) INTO l_cnt FROM agl_tmp_file
          WHERE tc_tmp00='Y'
                AND agl_tmp_file.tc_tmp03 = tm.a
         IF l_cnt > 1 THEN
#NO.FUN-720003------begin
            IF g_bgerr THEN
               CALL s_errmsg('','','','aap-504',0)
            ELSE
               CALL cl_err('','aap-504',0)
            END IF
 #NO.FUN-720003-------end
         ELSE
            IF l_cnt = 1 THEN
#NO.FUN-720003------begin
               IF g_bgerr THEN
                   CALL s_errmsg('','',l_cnt,'aap-501',0)
               ELSE
                   CALL cl_err(l_cnt,'aap-501',0)
               END IF
#NO.FUN-720003-------end
               SELECT tc_tmp02 INTO tm.gl_no FROM agl_tmp_file WHERE tc_tmp00 = 'Y'  AND agl_tmp_file.tc_tmp03 = tm.a
            ELSE
#NO.FUN-720003------begin
               IF g_bgerr THEN
                  CALL s_errmsg('','','','aap-502',0)
               ELSE
                  CALL cl_err('','aap-502',0)
               END IF
#NO.FUN-720003-------end
            END IF
        END IF

        WHEN INFIELD(gl_no1)
          IF cl_null(tm.gl_no1) THEN
            NEXT FIELD gl_no1
         END IF

#No.FUN-670068--begin
         FOREACH tmn_del INTO l_tmn02,l_tmn06
            DELETE FROM tmn_file
            WHERE tmn01 = tm.plant
             AND tmn02 = l_tmn02
              AND tmn06 = l_tmn06
         END FOREACH
#        DELETE FROM tmn_file
#         WHERE tmn01 = tm.plant
#           AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y' AND agl_tmp_file.tc_tmp03=tm.a1)
#           AND agl_tmp_file.tc_tmp03 = tm.a1
#No.FUN-670068--end
         DELETE FROM agl_tmp_file
           WHERE agl_tmp_file.tc_tmp03 = tm.a1

#         CALL s_agl_missingno(tm.plant,g_dbs_gl,g_bookno,tm.gl_no,tm.gl_date,0)
          CALL s_agl_missingno(tm.plant,g_dbs_gl,tm.a,tm.gl_no,tm.a1,tm.gl_no1,tm.gl_date,0)
         SELECT COUNT(*) INTO l_cnt FROM agl_tmp_file
          WHERE tc_tmp00='Y'
                AND agl_tmp_file.tc_tmp03 = tm.a1
         IF l_cnt > 1 THEN
#NO.FUN-720003------begin
            IF g_bgerr THEN
               CALL s_errmsg('','','','aap-504',0)
            ELSE
               CALL cl_err('','aap-504',0)
            END IF
#NO.FUN-720003-------end
         ELSE
            IF l_cnt = 1 THEN
#NO.FUN-720003------begin
             IF g_bgerr THEN
                CALL s_errmsg('','',l_cnt,'aap-501',0)
             ELSE
                CALL cl_err(l_cnt,'aap-501',0)
             END IF
#NO.FUN-720003-------end
               SELECT tc_tmp02 INTO tm.gl_no1 FROM agl_tmp_file WHERE tc_tmp00 = 'Y'  AND agl_tmp_file.tc_tmp03 = tm.a1
            ELSE
#NO.FUN-720003------begin
              IF g_bgerr THEN
                 CALL s_errmsg('','','','aap-502',0)
              ELSE
                 CALL cl_err('','aap-502',0)
              END IF
#NO.FUN-720003-------end
            END IF
        END IF
     END CASE
# No.FUN-680068 ---end---
       #No.FUN-580111  --end

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121


   END INPUT

   IF INT_FLAG THEN
      CLOSE WINDOW s_fsgl_t_w
      #No.FUN-580111  --start
#No.FUN-670068--begin
      FOREACH tmn_del INTO l_tmn02,l_tmn06
         DELETE FROM tmn_file
         WHERE tmn01 = tm.plant
           AND tmn02 = l_tmn02
           AND tmn06 = l_tmn06
      END FOREACH
#     DELETE FROM tmn_file
#      WHERE tmn01 = tm.plant
#        AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
#No.FUN-670068--end
      #No.FUN-580111  --end
      RETURN
   END IF

   IF NOT cl_sure(18,20) THEN
      LET INT_FLAG = 0
      CLOSE WINDOW s_fsgl_t_w
      #No.FUN-580111  --start
#No.FUN-670068--begin
      FOREACH tmn_del INTO l_tmn02,l_tmn06
         DELETE FROM tmn_file
         WHERE tmn01 = tm.plant
           AND tmn02 = l_tmn02
           AND tmn06 = l_tmn06
      END FOREACH
#     DELETE FROM tmn_file
#      WHERE tmn01 = tm.plant
#        AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
#No.FUN-670068--end
      #No.FUN-580111  --end
      RETURN
   END IF

   LET g_success = 'Y'
    LET gl_no_b=''          #No.MOD-510051
    LET gl_no_e=''          #No.MOD-510051
    LET gl_no1_b=''         # No.FUN-680068
    LET gl_no1_e=''         # No.FUN-680068
# No.FUN-680068 --start--
#   CALL s_chknpq_py(g_npp.npp01,'PY',g_npp.npp011,g_npp.npp00,tm.plant) #BugNO:
   CALL s_chknpq_py(g_npp.npp01,'PY',g_npp.npp011,g_npp.npp00,tm.plant,'0',tm.a)  #No.FUN-730020
 IF g_aza.aza63='Y' AND g_success='Y' THEN
   CALL s_chknpq_py(g_npp.npp01,'PY',g_npp.npp011,g_npp.npp00,tm.plant,'1',tm.a1)  #No.FUN-730020
 END IF
# No.FUN-680068 ---end---
   IF g_success = 'Y' THEN
# No.FUN-680068 --start--
#      CALL s_fsgl_t_process()
    CALL s_fsgl_t_process('0')
   IF g_aza.aza63 ='Y' AND g_success='Y' THEN
    CALL s_fsgl_t_process('1')
   END IF
# No.FUN-680068 ---end---
   END IF
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1) COMMIT WORK
      LET g_npp.nppglno=tm.gl_no
      LET g_npp.npp03  =tm.gl_date
      LET g_npp.npp06  =tm.plant
      LET g_npp.npp07  =tm.a
#     CALL s_m_prtgl(g_dbs_gl,tm.a,gl_no_b,gl_no_e)    #FUN-980020 mark
      CALL s_m_prtgl(tm.plant,tm.a,gl_no_b,gl_no_e)    #FUN-980020
# No.FUN-680068 --start--     flowld ?
    IF g_aza.aza63 = 'Y' THEN
#      CALL s_m_prtgl(g_dbs_gl,tm.a1,gl_no1_b,gl_no1_e) #FUN-980020 mark
       CALL s_m_prtgl(tm.plant,tm.a1,gl_no1_b,gl_no1_e) #FUN-980020
    END IF
# No.FUN-680068 ---end---
   ELSE
      CALL cl_rbmsg(1) ROLLBACK WORK
   END IF

   CLOSE WINDOW s_fsgl_t_w
   #No.FUN-580111  --start
   DELETE FROM tmn_file
    WHERE tmn01 = tm.plant
      AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
   #No.FUN-580111  --end
   DISPLAY BY NAME g_npp.nppglno,g_npp.npp03
   DISPLAY g_yy,g_mm TO azn02,azn04      #TQC-6C0071
END FUNCTION

FUNCTION s_fsgl_t_process(l_npptype)
   DEFINE l_npptype     LIKE npp_file.npptype       # No.FUN-680068
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_order	LIKE npp_file.npp01          #No.FUN-680126 VARCHAR(30)
   DEFINE l_remark	LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(100)
   DEFINE l_name	LIKE type_file.chr20         #No.FUN-680126 VARCHAR(20)
   DEFINE ap_date	LIKE type_file.dat           #No.FUN-680126 DATE
   DEFINE ap_glno	LIKE type_file.chr12         #LIKE cpf_file.cpf93          #No.FUN-680126 VARCHAR(12)   #TQC-B90211
   DEFINE ap_conf	LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
   DEFINE ap_user	LIKE apa_file.apauser        #No.FUN-680126 VARCHAR(10)

# No.FUN-680068 --start--
 IF  g_aza.aza63='Y' THEN
   IF  l_npptype='0' THEN

    LET g_sql = "SELECT aznn02,aznn04 ",
                #"  FROM ",g_dbs_gl CLIPPED,"aznn_file ",
                "  FROM ",cl_get_target_table(g_plant_gl,'aznn_file'), #FUN-A50102
                " WHERE aznn01 = '",tm.gl_date,"' ",
                "   AND aznn00 = '",g_bookno,"' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
    PREPARE p400_aznn_pre FROM g_sql
    DECLARE p400_aznn_cs CURSOR FOR p400_aznn_pre
    OPEN p400_aznn_cs
    FETCH p400_aznn_cs INTO g_yy,g_mm

 ELSE

   LET g_sql = "SELECT aznn02,aznn04 ",
                #"  FROM ",g_dbs_gl CLIPPED,"aznn_file ",
                "  FROM ",cl_get_target_table(g_plant_gl,'aznn_file'), #FUN-A50102
                " WHERE aznn01 = '",tm.gl_date,"' ",
                "   AND aznn00 = '",g_bookno1,"' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
    PREPARE p400_aznn_pre1 FROM g_sql
    DECLARE p400_aznn_cs1 CURSOR FOR p400_aznn_pre1
    OPEN p400_aznn_cs1
    FETCH p400_aznn_cs1 INTO g_yy,g_mm

  END IF
 ELSE
               SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = tm.gl_date    #MOD-A10040 gl_date modify tm.gl_date
           END IF

# No.FUN-680068 ---end---
   #no.3432 (是否自動傳票確認)
   #LET g_sql = "SELECT aaz85 FROM ",g_dbs_gl CLIPPED,"aaz_file",
   LET g_sql = "SELECT aaz85 FROM ",cl_get_target_table(g_plant_gl,'aaz_file'), #FUN-A50102
               " WHERE aaz00 = '0' "

 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
   PREPARE aaz85_pre FROM g_sql
   DECLARE aaz85_cs CURSOR FOR aaz85_pre
   OPEN aaz85_cs
   FETCH aaz85_cs INTO g_aaz85
   IF STATUS THEN
#NO.FUN-720003------begin
      IF g_bgerr THEN
         CALL s_errmsg('aaz00','','sel aaz85',STATUS,1)
      ELSE
         CALL cl_err('sel aaz85',STATUS,1)
      END IF
#NO.FUN-720003-------end
      RETURN
   END IF
   #no.3432(end)
   LET g_sql="SELECT npp_file.*,npq_file.* ",
             "  FROM npp_file,npq_file",
             "  WHERE npp00='",g_npp.npp00 CLIPPED,
             "' AND npp01='",g_npp.npp01 CLIPPED,
             "' AND npp011='",g_npp.npp011 CLIPPED,
             "' AND npptype='",l_npptype,"'  ",     # No.FUN-680068
             "  AND nppsys= 'PY' ",
             "  AND (nppglno IS NULL OR nppglno =' ') ",
             "  AND npp01 = npq01 AND npp011=npq011",
             "  AND nppsys=npqsys AND npptype=npqtype AND npp00=npq00" CLIPPED     # No.FUN-680068 add npptype=npqtype

   PREPARE s_fsgl_1_p0 FROM g_sql
   IF STATUS THEN
#NO.FUN-720003------begin
      IF g_bgerr THEN
          LET g_showmsg=g_npp.npp01,"/",g_npp.npp011,"/",g_npp.npp00
         CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'s_fsgl_1_p0',STATUS,1)
       ELSE
         CALL cl_err('s_fsgl_1_p0',STATUS,1)
       END IF
#NO.FUN-720003-------end
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
      EXIT PROGRAM
   END IF
   DECLARE s_fsgl_1_c0 CURSOR WITH HOLD FOR s_fsgl_1_p0
   CALL cl_outnam('apyi107') RETURNING l_name
# No.FUN-680068 --start--
         IF  l_npptype='0' THEN
                START REPORT s_fsgl_rep1 TO l_name
               ELSE
                START REPORT s_fsgl_1_rep1 TO l_name
              END IF


#   START REPORT s_fsgl_rep1 TO l_name
# No.FUN-680068 ---end---
   BEGIN WORK

   WHILE TRUE
# No.FUN-680068 --start--
   IF l_npptype = '0' THEN
      FOREACH s_fsgl_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
#NO.FUN-720003------begin
            IF g_bgerr THEN
                CALL s_errmsg('','','foreach:',STATUS,1)
            ELSE
                CALL cl_err('foreach:',STATUS,1)
            END IF
#NO.FUN-720003-------end
          LET g_success = 'N'
            EXIT FOREACH
         END IF
         IF l_npq.npq04 = ' ' THEN LET l_npq.npq04 = NULL END IF
         LET l_remark = l_npq.npq04 clipped,l_npq.npq11 clipped,
                        l_npq.npq12 clipped,l_npq.npq13 clipped,
                        l_npq.npq14 clipped,
                        #-----MOD-760129---------
                        l_npq.npq31 clipped,l_npq.npq32 clipped,
                        l_npq.npq33 clipped,l_npq.npq34 clipped,
                        l_npq.npq35 clipped,l_npq.npq36 clipped,
                        l_npq.npq37 clipped,
                        #-----END MOD-760129-----
#                       l_npq.npq15 clipped,      #No.FUN-840006 去掉npq15
                        l_npq.npq08 clipped
         LET l_order = l_npp.npp01 # 依單號
         OUTPUT TO REPORT s_fsgl_rep1(l_order,l_npp.*,l_npq.*,l_remark)
      END FOREACH
  ELSE
        FOREACH s_fsgl_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
#NO.FUN-720003------begin
            IF g_bgerr THEN
               CALL s_errmsg('','','foreach:',STATUS,1)
            ELSE
               CALL cl_err('foreach:',STATUS,1)
            END IF
#NO.FUN-720003-------end
          LET g_success = 'N'
            EXIT FOREACH
         END IF
         IF l_npq.npq04 = ' ' THEN LET l_npq.npq04 = NULL END IF
         LET l_remark = l_npq.npq04 clipped,l_npq.npq11 clipped,
                        l_npq.npq12 clipped,l_npq.npq13 clipped,
                        l_npq.npq14 clipped,
                        #-----MOD-760129---------
                        l_npq.npq31 clipped,l_npq.npq32 clipped,
                        l_npq.npq33 clipped,l_npq.npq34 clipped,
                        l_npq.npq35 clipped,l_npq.npq36 clipped,
                        l_npq.npq37 clipped,
                        #-----END MOD-760129-----
#                       l_npq.npq15 clipped,      #No.FUN-840006 去掉npq15
                        l_npq.npq08 clipped
         LET l_order = l_npp.npp01 # 依單號
         OUTPUT TO REPORT s_fsgl_1_rep1(l_order,l_npp.*,l_npq.*,l_remark)
      END FOREACH	
    END IF
# No.FUN-680068 ---end---     	
      EXIT WHILE
   END WHILE
# No.FUN-680068 --start--
 IF l_npptype = '0' THEN
   FINISH REPORT s_fsgl_rep1
 ELSE
   CALL s_fsgl_diff(l_npp.*)    #FUN-A40033
   FINISH REPORT s_fsgl_1_rep1
 END IF 	
# No.FUN-680068 ---end--- 	
END FUNCTION

REPORT s_fsgl_rep1(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01                   #No.FUN-680126 VARCHAR(30)
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_n,l_n1,l_n2  LIKE type_file.num5                   #No.FUN-680126 SMALLINT
  DEFINE l_seq		LIKE type_file.num5                   # 傳票項次     #No.FUN-680126 SMALLINT
  DEFINE l_credit,l_debit,l_amt,l_amtf  LIKE npq_file.npq07   #FUN-4C0015
  DEFINE l_remark       LIKE type_file.chr1000                #No.FUN-680126 VARCHAR(100)
  DEFINE l_var          ARRAY[10] of LIKE npp_file.npp06      #No.FUN-680126 VARCHAR(10)
  DEFINE l_sql          LIKE type_file.chr1000                #No.MOD-750019 add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,l_remark,l_npq.npq01
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
     MESSAGE "Insert G/L voucher no:",tm.gl_no
     PRINT "Insert aba:",tm.a,' ',tm.gl_no,' From:',l_order
      #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",
      LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
               "(aba00,aba01,aba02,aba03,aba04,aba05,",
               " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",      #No:8657
               " abaprno,abaacti,abauser,abagrup,abadate,",
               " abasign,abadays,abaprit,abasmax,abasseq,abalegal)", #FUN-980012 add abalegal
               " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"      #No:8657  #FUN-980012
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
     PREPARE s_fsgl_1_p4 FROM g_sql
## ----
     #自動賦予簽核等級
     LET g_aba.aba01=tm.gl_no
     LET g_aba01t   =tm.gl_no[1,g_doc_len]   #No.FUN-550062

#MOD-750019-modify
#    SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
#      INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
#           g_aba.abaprit,g_aba.abasign
#      FROM g_dbs_gl,aac_file WHERE aac01 = g_aba01t

     LET l_sql="SELECT aac08,aacatsg,aacdays,aacprit,aacsign ",  #簽核處理 (Y/N)
               #"FROM ",g_dbs_gl CLIPPED,"aac_file WHERE aac01 = ? "
               "FROM ",cl_get_target_table(g_plant_gl,'aac_file'), #FUN-A50102
               " WHERE aac01 = ? "

 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql #FUN-A50102
     PREPARE i107_t_aac_pre FROM l_sql
     DECLARE i107_t_aac CURSOR FOR i107_t_aac_pre

     OPEN i107_t_aac USING g_aba01t
     IF STATUS THEN
        IF g_bgerr THEN
           LET g_showmsg=g_aba01t
           CALL s_errmsg('aba01',g_showmsg,'s_t_aac_open',STATUS,1)
        ELSE
          CALL cl_err("OPEN i107_t_aac:",STATUS, 1)
        END IF
        CLOSE i107_t_aac
        LET g_success = 'N'
     END IF

     FETCH i107_t_aac INTO
           g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
           g_aba.abaprit,g_aba.abasign
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
           LET g_showmsg=g_aba01t
           CALL s_errmsg('aba01',g_showmsg,'s_t_aac_fetch',STATUS,1)
        ELSE
          CALL cl_err('FETCH i107_t_aac:',SQLCA.sqlcode,0)
        END IF
        CLOSE i107_t_aac
        LET g_success = 'N'
     ELSE
#MOD-750019-end
        IF g_aba.abamksg MATCHES  '[Yy]' THEN
           IF g_aac.aacatsg matches'[Yy]' THEN   #自動付予
              CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                   RETURNING g_aba.abasign
           END IF
           SELECT COUNT(*) INTO g_aba.abasmax FROM azc_file
            WHERE azc01=g_aba.abasign
        END IF
     END IF                #MOD0750019 add
     CLOSE i107_t_aac      #MOD-750019 add
## ----
     LET l_var[1] = 'CP'
     LET l_var[2] = '0'
     LET l_var[3] = '0'
     LET l_var[4] = 'N'
     LET l_var[5] = 'N'
     LET l_var[6] = 'N'
     LET l_var[7] = '0'
     LET l_var[8] = 'Y'
     EXECUTE s_fsgl_1_p4 USING tm.a,tm.gl_no,tm.gl_date,g_yy,g_mm,
                             g_today,
                             l_var[1],
                             l_order,
                             l_var[2],
                             l_var[3],
                             l_var[4],
                             l_var[5],
                             l_var[2],       #No:8657 加aba20
                             g_aba.abamksg,
                             l_var[6],
                             l_var[7],
                             l_var[8],
                             g_user,g_grup,g_today,g_aba.abasign,
                             g_aba.abadays,g_aba.abaprit,g_aba.abasmax,'0',
                             g_legal  #FUN-980012
{
     EXECUTE s_fsgl_1_p4 USING tm.a,tm.gl_no,tm.gl_date,g_yy,g_mm,
                             tm.gl_date,'CP',l_order,'0','0','N','N',
                             g_aba.abamksg,'N',
                             '0','Y',g_user,g_grup,g_today,g_aba.abasign,
                             g_aba.abadays,g_aba.abaprit,g_aba.abasmax,'0'
}
     IF SQLCA.sqlcode THEN
         #CALL cl_err('ins aba:',SQLCA.sqlcode,1)  #No.FUN-660130
#NO.FUN-720003------begin
        IF g_bgerr THEN
           CALL s_errmsg('azc01',g_aba.abasign,'ins aba:',SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("ins","aba_file",tm.a,tm.gl_no,SQLCA.sqlcode,"","ins aba",1)  #No.FUN-660130
        END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = tm.plant AND tmn02 = tm.gl_no AND tmn_file.tmn06 = tm.a  #No.FUN-580111       # No.FUN-680068 add tmn_file.tmn06 =tm.a
     DELETE FROM agl_tmp_file WHERE tc_tmp02 = tm.gl_no AND agl_tmp_file.tc_tmp03 = tm.a                #No.FUN-580111     # No.FUN-680068 add agl_tmp_file.tc_tmp03 =tm.a
     IF gl_no_b IS NULL THEN LET gl_no_b = tm.gl_no END IF
     LET gl_no_e = tm.gl_no
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
     UPDATE npp_file SET npp03=tm.gl_date,
                         nppglno=tm.gl_no,
                         npp06=tm.plant,
                         npp07=tm.a
       WHERE npp01 = l_npp.npp01
         AND npp011= l_npp.npp011
         AND npp00 = l_npp.npp00
         AND npptype = '0'            # No.FUN-680068
         AND nppsys= l_npp.nppsys
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
#       CALL cl_err('upd npp03/glno:',SQLCA.sqlcode,1) #No.FUN-660130
#NO.FUN-720003------begin
        IF g_bgerr THEN
           LET g_showmsg=l_npp.npp01,"/",l_npp.npp011,"/",l_npp.npp00,"/",l_npp.nppsys
           CALL s_errmsg('npp01,npp011,npp00,nppsys',g_showmsg,'upd npp03/glno:',SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp00,SQLCA.sqlcode,"","upd npp03/glno",1)  #No.FUN-660130
        END IF
#NO.FUN-720003-------end
        LET g_success = 'N'
     END IF
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark
     LET l_seq = l_seq + 1
     MESSAGE "Seq:",l_seq
     #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_gl,'abb_file'), #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                       #FUN-5C0015 ---begin---
                       #" abb08,abb11,abb12,abb13,abb14,abb15,abb24,abb25)",
                       # " abb08,abb11,abb12,abb13,abb14,abb15,abb31,abb32,",              #No.FUN-810069
                        " abb08,abb11,abb12,abb13,abb14,abb31,abb32,",                     #No.FUN-810069
                        " abb33,abb34,abb35,abb36,abb37,abb24,abb25,",
                        " abblegal)",   #FUN-980012
                       #FUN-5C0015 ---end---
               #  " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?)"   #No.FUN-680068
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ?)"   #FUN-980012
     LET l_amt = GROUP SUM(l_npq.npq07)
     LET l_amtf= GROUP SUM(l_npq.npq07f)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
     PREPARE s_fsgl_1_p5 FROM g_sql
     EXECUTE s_fsgl_1_p5 USING
                tm.a,tm.gl_no,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
               #FUN-5C0015 ---begin---
               #l_npq.npq14,l_npq.npq15,l_npq.npq24,l_npq.npq25
               # l_npq.npq14,l_npq.npq15,l_npq.npq31,l_npq.npq32,      #No.FUN-810069
                l_npq.npq14,l_npq.npq31,l_npq.npq32,                   #No.FUN-810069
                l_npq.npq33,l_npq.npq34,l_npq.npq35,l_npq.npq36,
                l_npq.npq37,l_npq.npq24,l_npq.npq25,
               #FUN-5C0015 ---end---
                g_legal    # FUN-980012
     IF SQLCA.sqlcode THEN
        #CALL cl_err('ins abb:',SQLCA.sqlcode,1)  #No.FUN-660130
#NO.FUN-720003------begin
        IF g_bgerr THEN
           CALL s_errmsg('abb01,abb02,abb00','','ins abb:',SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("ins","abb_file",tm.a,tm.gl_no,SQLCA.sqlcode,"","ins abb",1)  #No.FUN-660130
        END IF
#NO.FUN-720003-------end
        LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1' THEN
        LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",tm.gl_no
      #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET aba08 = ?,aba09=?",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                  " SET aba08 = ?,aba09=?",
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE s_fsgl_1_p6 FROM g_sql
      EXECUTE s_fsgl_1_p6 USING l_debit,l_credit,tm.gl_no,tm.a
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1)  #No.FUN-660130
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('aba01,aba00','','upd aba08/09:',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","aba_file",tm.a,tm.gl_no,SQLCA.sqlcode,"","upd aba08/09",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
      END IF
      #No.FUN-730020  --Begin
      CALL s_get_bookno(YEAR(l_npp.npp02))  #TQC-740042
           RETURNING g_flag,g_bookno11,g_bookno22
      IF g_flag =  '1' THEN  #抓不到帳別
         CALL cl_err(l_npp.npp02,'aoo-081',1)
      END IF
      IF l_npp.npptype =  '0' THEN
         LET g_bookno33 = g_bookno11
      ELSE
         LET g_bookno33 = g_bookno22
      END IF
      #No.FUN-730020  --End
#no.3432 自動確認
IF g_aaz85 = 'Y' THEN
      #若有立沖帳管理就不做自動確認
      #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl," abb_file,aag_file",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_gl,'abb_file')," ,aag_file", #FUN-A50102
                  " WHERE abb01 = '",tm.gl_no,"'",
                  "   AND abb00 = '",tm.a,"'",
                  "   AND abb03 = aag01  ",
                  "   AND aag20 = 'Y' ",
                  "   AND abb00 = aag00 "           #No.FUN-730020
                  #"   AND aag00 = '",g_bookno33,"'"  #No.FUN-730020   #MOD-9C0110
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE count_pre FROM g_sql
      DECLARE count_cs CURSOR FOR count_pre
      OPEN count_cs
      FETCH count_cs INTO g_cnt
      CLOSE count_cs
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
        #IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF   #MOD-850183 mark
        #IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN   #MOD-850183 mark
         IF g_aba.abamksg='N' THEN                       #MOD-850183
            LET g_aba.aba20='1'
         #END IF   #MOD-770101
            LET g_aba.aba19 = 'Y'
            #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",
#No.TQC-B70021 --begin 
            CALL s_chktic (tm.a,tm.gl_no) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end
            LET g_sql = " UPDATE ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                        "    SET abamksg = ? ,",
                               " abasign = ? ,",
                               " aba18   = ? ,",
                               " aba19   = ? ,",
                               " aba20   = ?  ",
                         " WHERE aba01 = ? AND aba00 = ? "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
            PREPARE upd_aba19 FROM g_sql
            EXECUTE upd_aba19 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    tm.gl_no     ,tm.a
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
               #CALL cl_err('upd aba19',STATUS,1)
#NO.FUN-720003------begin
               IF g_bgerr THEN
                  CALL s_errmsg('aba01,aba00','','upd aba19',STATUS,1)
               ELSE
                  CALL cl_err3("upd","aba_file",tm.a,tm.gl_no,STATUS,"","upd aba19",1)  #No.FUN-660130
               END IF
#NO.FUN-720003-------end
               LET g_success = 'N'
            END IF
         END IF   #MOD-770101
      END IF
END IF
#no.3432(end)
END REPORT

# No.FUN-680068 --start--
REPORT s_fsgl_1_rep1(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01                  #No.FUN-680126 VARCHAR(30)
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_n,l_n1,l_n2  LIKE type_file.num5                  #No.FUN-680126 SMALLINT
  DEFINE l_seq		LIKE type_file.num5                  # 傳票項次   #No.FUN-680126 SMALLINT
  DEFINE l_credit,l_debit,l_amt,l_amtf  LIKE npq_file.npq07  #FUN-4C0015
  DEFINE l_remark       LIKE type_file.chr1000               #No.FUN-680126 VARCHAR(100)
  DEFINE l_var          ARRAY[10] of LIKE npp_file.npp06     #No.FUN-680126 VARCHAR(10)
  DEFINE l_sql          LIKE type_file.chr1000               #No.MOD-750019 add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,l_remark,l_npq.npq01
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
     MESSAGE "Insert G/L voucher no:",tm.gl_no1
     PRINT "Insert aba:",tm.a1,' ',tm.gl_no1,' From:',l_order
      #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",
      LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
               "(aba00,aba01,aba02,aba03,aba04,aba05,",
               " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",      #No:8657
               " abaprno,abaacti,abauser,abagrup,abadate,",
               " abasign,abadays,abaprit,abasmax,abasseq,abalegal)",   #FUN-980012
               " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"      #No:8657  #FUN-980012
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
     PREPARE s_fsgl_2_p4 FROM g_sql
## ----
     #自動賦予簽核等級
     LET g_aba.aba01=tm.gl_no1
     LET g_aba01t   =tm.gl_no1[1,g_doc_len]   #No.FUN-550062

#MOD-750019-modify
#    SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
#      INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
#           g_aba.abaprit,g_aba.abasign
#      FROM g_dbs_gl,aac_file WHERE aac01 = g_aba01t

     LET l_sql="SELECT aac08,aacatsg,aacdays,aacprit,aacsign ",  #簽核處理 (Y/N)
               #"FROM ",g_dbs_gl CLIPPED,"aac_file WHERE aac01 = ? "
               "  FROM ",cl_get_target_table(g_plant_gl,'aac_file'), #FUN-A50102
               " WHERE aac01 = ? "

 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql #FUN-A50102
     PREPARE i107_t1_aac_pre FROM l_sql
     DECLARE i107_t1_aac CURSOR FOR i107_t1_aac_pre

     OPEN i107_t1_aac USING g_aba01t
     IF STATUS THEN
        IF g_bgerr THEN
           LET g_showmsg=g_aba01t
           CALL s_errmsg('aba01',g_showmsg,'s_t1_aac_open',STATUS,1)
        ELSE
          CALL cl_err("OPEN i107_t1_aac:",STATUS, 1)
        END IF
        CLOSE i107_t1_aac
        LET g_success = 'N'
     END IF

     FETCH i107_t1_aac INTO
           g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
           g_aba.abaprit,g_aba.abasign
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
           LET g_showmsg=g_aba01t
           CALL s_errmsg('aba01',g_showmsg,'s_t1_aac_fetch',STATUS,1)
        ELSE
          CALL cl_err('FETCH i107_t1_aac:',SQLCA.sqlcode,0)
        END IF
        CLOSE i107_t1_aac
        LET g_success = 'N'
     ELSE
#MOD-750019-end
        IF g_aba.abamksg MATCHES  '[Yy]' THEN
           IF g_aac.aacatsg matches'[Yy]' THEN   #自動付予
              CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                   RETURNING g_aba.abasign
           END IF
           SELECT COUNT(*) INTO g_aba.abasmax FROM azc_file
            WHERE azc01=g_aba.abasign
        END IF
     END IF                 #MOD0750019 add
     CLOSE i107_t1_aac      #MOD-750019 add
## ----
     LET l_var[1] = 'CP'
     LET l_var[2] = '0'
     LET l_var[3] = '0'
     LET l_var[4] = 'N'
     LET l_var[5] = 'N'
     LET l_var[6] = 'N'
     LET l_var[7] = '0'
     LET l_var[8] = 'Y'
     EXECUTE s_fsgl_2_p4 USING tm.a1,tm.gl_no1,tm.gl_date,g_yy,g_mm,
                             g_today,
                             l_var[1],
                             l_order,
                             l_var[2],
                             l_var[3],
                             l_var[4],
                             l_var[5],
                             l_var[2],       #No:8657 加aba20
                             g_aba.abamksg,
                             l_var[6],
                             l_var[7],
                             l_var[8],
                             g_user,g_grup,g_today,g_aba.abasign,
                             g_aba.abadays,g_aba.abaprit,g_aba.abasmax,'0',
                             g_legal   #FUN-980012

     IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
        IF g_bgerr THEN
           CALL s_errmsg('azc01',g_aba.abasign,"ins aba",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("ins","aba_file",tm.a1,tm.gl_no1,SQLCA.sqlcode,"","ins aba",1)  #No.FUN-660130
        END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = tm.plant AND tmn02 = tm.gl_no1 AND tmn_file.tmn06 = tm.a1  #No.FUN-580111       # No.FUN-680068 add tmn_file.tmn06 =tm.a1
     DELETE FROM agl_tmp_file WHERE tc_tmp02 = tm.gl_no1 AND agl_tmp_file.tc_tmp03 = tm.a1                #No.FUN-580111     # No.FUN-680068 add agl_tmp_file.tc_tmp03 =tm.a1
     IF gl_no1_b IS NULL THEN LET gl_no1_b = tm.gl_no1 END IF
     LET gl_no1_e = tm.gl_no1
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   #------------------ Update gl-no1 To original file --------------------------
   AFTER GROUP OF l_npq.npq01
     UPDATE npp_file SET npp03=tm.gl_date,
                         nppglno=tm.gl_no1,
                         npp06=tm.plant,
                         npp07=tm.a1
       WHERE npp01 = l_npp.npp01
         AND npp011= l_npp.npp011
         AND npp00 = l_npp.npp00
         AND npptype = '1'                      #No.FUN-680068
         AND nppsys= l_npp.nppsys
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
#NO.FUN-720003------begin
        IF g_bgerr THEN
           LET g_showmsg=l_npp.npp01,"/",l_npp.npp011,"/",l_npp.npp00,"/",l_npp.nppsys
           CALL s_errmsg('npp01,npp011,npp00,nppsys',g_showmsg,"upd npp03/glno",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp00,SQLCA.sqlcode,"","upd npp03/glno",1)  #No.FUN-660130
        END IF
#NO.FUN-720003-------end
        LET g_success = 'N'
     END IF
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark
     LET l_seq = l_seq + 1
     MESSAGE "Seq:",l_seq
     #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_gl,'abb_file'), #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                    #    " abb08,abb11,abb12,abb13,abb14,abb15,abb31,abb32,",    #No.FUN-810069
                        " abb08,abb11,abb12,abb13,abb14,abb31,abb32,",           #No.FUN-810069
                        " abb33,abb34,abb35,abb36,abb37,abb24,abb25,abblegal)",  #FUN-980012
               #  " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?)"   #No.FUN-680068#No.FUN-810069
                  " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?)"    #No.FUN-810069  #FUN-980012
     LET l_amt = GROUP SUM(l_npq.npq07)
     LET l_amtf= GROUP SUM(l_npq.npq07f)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
     PREPARE s_fsgl_2_p5 FROM g_sql
     EXECUTE s_fsgl_2_p5 USING
                tm.a1,tm.gl_no1,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
              #  l_npq.npq14,l_npq.npq15,l_npq.npq31,l_npq.npq32,                #No.FUN-810069
                l_npq.npq14,l_npq.npq31,l_npq.npq32,                             #No.FUN-810069
                l_npq.npq33,l_npq.npq34,l_npq.npq35,l_npq.npq36,
                l_npq.npq37,l_npq.npq24,l_npq.npq25,
                g_legal    #FUN-980012

     IF SQLCA.sqlcode THEN

#NO.FUN-720003------begin
        IF g_bgerr THEN
           CALL s_errmsg('abb01,abb02,abb00','',"ins abb",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("ins","abb_file",tm.a1,tm.gl_no1,SQLCA.sqlcode,"","ins abb",1)  #No.FUN-660130
        END IF
#NO.FUN-720003-------end
        LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1' THEN
        LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",tm.gl_no1
      #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET aba08 = ?,aba09=?",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                  " SET aba08 = ?,aba09=?",
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE s_fsgl_2_p6 FROM g_sql
      EXECUTE s_fsgl_2_p6 USING l_debit,l_credit,tm.gl_no1,tm.a1
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('aba01,aba00','',"upd aba08/09",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","aba_file",tm.a1,tm.gl_no1,SQLCA.sqlcode,"","upd aba08/09",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
      END IF
      #No.FUN-730020  --Begin
      CALL s_get_bookno(YEAR(l_npp.npp02))    #TQC-740042
           RETURNING g_flag,g_bookno11,g_bookno22
      IF g_flag =  '1' THEN  #抓不到帳別
         CALL cl_err(l_npp.npp02,'aoo-081',1)
      END IF
      IF l_npp.npptype =  '0' THEN
         LET g_bookno33 = g_bookno11
      ELSE
         LET g_bookno33 = g_bookno22
      END IF
      #No.FUN-730020  --End
# 自動確認
IF g_aaz85 = 'Y' THEN
      #若有立沖帳管理就不做自動確認
      #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl," abb_file,aag_file",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_gl,'abb_file')," ,aag_file", #FUN-A50102
                  " WHERE abb01 = '",tm.gl_no1,"'",
                  "   AND abb00 = '",tm.a1,"'",
                  "   AND abb03 = aag01  ",
                  "   AND aag20 = 'Y' ",
                  "   AND abb00 = aag00 "            #No.FUN-730020
                  #"   AND aag00 = '",g_bookno33,"'"  #No.FUN-730020   #MOD-9C0110
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE count_pre1 FROM g_sql
      DECLARE count_cs1 CURSOR FOR count_pre1
      OPEN count_cs1
      FETCH count_cs1 INTO g_cnt
      CLOSE count_cs1
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
        #IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF   #MOD-850183 mark
        #IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN   #MOD-850183 mark
         IF g_aba.abamksg='N' THEN                       #MOD-850183
            LET g_aba.aba20='1'
         #END IF   #MOD-770101
            LET g_aba.aba19 = 'Y'
            #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",
#No.TQC-B70021 --begin 
            CALL s_chktic (tm.a1,tm.gl_no1) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end
            LET g_sql = " UPDATE ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                        "    SET abamksg = ? ,",
                               " abasign = ? ,",
                               " aba18   = ? ,",
                               " aba19   = ? ,",
                               " aba20   = ?  ",
                         " WHERE aba01 = ? AND aba00 = ? "
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
            PREPARE upd_aba191 FROM g_sql
            EXECUTE upd_aba191 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    tm.gl_no1     ,tm.a1
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#NO.FUN-720003------begin
               IF g_bgerr THEN
                  CALL s_errmsg('aba01,aba00','',"upd aba19",STATUS,1)
               ELSE
                  CALL cl_err3("upd","aba_file",tm.a1,tm.gl_no1,STATUS,"","upd aba19",1)
               END IF
#NO.FUN-720003-------end
               LET g_success = 'N'
            END IF
         END IF   #MOD-770101
      END IF
END IF

END REPORT
# No.FUN-680068 ---end---
FUNCTION s_fsgl_unt()
DEFINE l_abapost,l_flag LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
DEFINE l_aba19          LIKE aba_file.aba19
DEFINE l_abaacti        LIKE aba_file.abaacti
DEFINE gl_date	        LIKE type_file.dat           #No.FUN-680126 DATE
DEFINE gl_yy,gl_mm      LIKE type_file.num5          #No.FUN-680126 SMALLINT
DEFINE l_aba00          LIKE aba_file.aba00
DEFINE l_aaa07          LIKE aaa_file.aaa07
DEFINE l_npp07          LIKE npp_file.npp07          # No.FUN-680068
DEFINE l_nppglno        LIKE npp_file.nppglno        # No.FUN-680068
DEFINE l_nppglno1       LIKE npp_file.nppglno        # No.FUN-680068

    IF cl_null(g_npp.nppglno) OR cl_null(g_npp.npp07) THEN RETURN  END IF

    #No.FUN-680034 --Begin
    LET g_existno=''
    LET g_existno1=''
    IF g_npp.npptype = '0' THEN
       LET g_existno = g_npp.nppglno
       DISPLAY BY NAME g_existno
    ELSE
       LET g_existno1= g_npp.nppglno
       DISPLAY BY NAME g_existno1
    END IF
    #No.FUN-680034 --End

    LET p_row = 6 LET p_col = 20
    OPEN WINDOW s_fsgl_u AT p_row,p_col
      WITH FORM "apy/42f/apyi107_u"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_locale("apyi107_u")
    CALL cl_set_comp_visible("p_acc1,g_existno1",g_aza.aza63='Y')        # No.FUN-680068 	
# No.FUN-680068 --start--
#     LET p_plant = g_plant   #MOD-570318
    #-----TQC-B90211---------
    #LET p_plant = g_cpa.cpa150
    #LET p_acc  = g_cpa.cpa151
    #LET p_acc1 = g_cpa.cpa152
    #-----END TQC-B90211-----
# No.FUN-680068 ---end---
    LET INT_FLAG=0
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
    INPUT BY NAME p_plant,p_acc,g_existno,p_acc1,g_existno1 WITHOUT DEFAULTS    # No.FUN-680068 add p_acc,p_acc1,g_existno1

      AFTER FIELD p_plant
          IF NOT cl_null(p_plant) THEN
             SELECT azp01 FROM azp_file
              WHERE azp01 = p_plant
             IF STATUS <> 0 THEN
#                CALL cl_err(p_plant,'aap-025',0) #MOD-480614   #No.FUN-660130
#NO.FUN-720003------begin
                 IF g_bgerr THEN
                    CALL s_errmsg('azp01',p_plant,p_plant,'aap-025',0)
                 ELSE
                    CALL cl_err3("sel","azp_file",g_plant,"","aap-025","","",1)  #No.FUN-660130
                 END IF
#NO.FUN-720003-------end
                NEXT FIELD p_plant
             END IF
             LET g_plant_new=p_plant
             CALL s_getdbs()
             LET g_dbs_gl=g_dbs_new
             LET g_plant_gl=p_plant  #FUN-A50102
          END IF

      AFTER FIELD g_existno
          IF NOT cl_null(g_existno) THEN
             LET g_sql="SELECT aba00,aba02,aba03,aba04,abapost,aba19,abaacti ",
                       #"  FROM ",g_dbs_gl,"aba_file",
                       "  FROM ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                       " WHERE aba01 = ? AND aba00 = ? AND aba06='CP'" CLIPPED
 	         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
             PREPARE s_fsgl_t_p1 FROM g_sql
             DECLARE s_fsgl_t_c1 CURSOR FOR s_fsgl_t_p1
             IF STATUS THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                   CALL s_errmsg('aba01,aba00,aba06','','decl aba_cursor:',STATUS,0)
                ELSE
                   CALL cl_err('decl aba_cursor:',STATUS,0)
                END IF
#NO.FUN-720003-------end
             NEXT FIELD g_existno
             END IF
# No.FUN-680068 --start--
#             OPEN s_fsgl_t_c1 USING g_existno,g_npp.npp07
              OPEN s_fsgl_t_c1 USING g_existno,p_acc
# No.FUN-680068 ---end---
             FETCH s_fsgl_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
                                    l_abaacti #no.7378

             IF STATUS THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                   CALL s_errmsg('','','sel aba:',STATUS,0)
                ELSE
                   CALL cl_err('sel aba:',STATUS,0)
                END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno
             END IF

             #no.7378
             IF l_abaacti = 'N' THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                   CALL s_errmsg('','','','mfg8001',1)
                ELSE
                   CALL cl_err('','mfg8001',1)
                END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno
             END IF
             #no.7378(end)

            #---增加判斷會計帳別之關帳日期
             #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file",
             LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_gl,'aaa_file'), #FUN-A50102
                       " WHERE aaa01='",l_aba00,"'"
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
             PREPARE s_fsgl_x_gl_p1 FROM g_sql
             DECLARE s_fsgl_c_gl_p1 CURSOR FOR s_fsgl_x_gl_p1
             OPEN s_fsgl_c_gl_p1
             FETCH s_fsgl_c_gl_p1 INTO l_aaa07
             IF gl_date <= l_aaa07 THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                    CALL s_errmsg('aaa01',l_aba00,gl_date,'agl-200',0)
                ELSE
                    CALL cl_err(gl_date,'agl-200',0)
                END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno
             END IF
            #------ end -------------------
            #-----MOD-980144---------
            ##傳票日期小於系統之關帳日,不可還原
            #IF gl_date < g_sma.sma53 THEN
            #    #NO.FUN-720003------begin
            #    IF g_bgerr THEN
            #       CALL s_errmsg('aaa01',l_aba00,'','aap-027',0)
            #    ELSE
            #       CALL cl_err('','aap-027',0)
            #    END IF
            #    #NO.FUN-720003-------end
            #   NEXT FIELD g_existno
            #END IF
            #-----END MOD-980144-----
             IF l_abapost = 'Y' THEN
#NO.FUN-720003------begin
                 IF g_bgerr THEN
                    CALL s_errmsg('aaa01',l_aba00,g_existno,'aap-130',0)
                 ELSE
                    CALL cl_err(g_existno,'aap-130',0)
                 END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno
             END IF
             IF l_aba19 ='Y' THEN
#NO.FUN-720003------begin
                 IF g_bgerr THEN
                    CALL s_errmsg('aaa01',l_aba00,g_existno,'aap-026',0)
                 ELSE
                    CALL cl_err(g_existno,'aap-026',0)
                 END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno
             END IF
# No.FUN-680068 --start--
          IF g_aza.aza63 = 'Y' AND g_npp.npptype = '0' THEN
             SELECT UNIQUE A.npp07,A.nppglno
               INTO l_npp07,l_nppglno1
               FROM npp_file A,npp_file B
              WHERE A.npp01 = B.npp01
                AND A.npp011 = B.npp011
                AND A.npp00 = B.npp00
                AND A.nppsys = B.nppsys
                AND B.npp07 = p_acc
                AND B.nppglno = g_existno
                AND B.npptype = '0'
                AND A.npptype = '1'
                AND B.nppsys = 'PY'
             IF cl_null(l_npp07) OR cl_null(l_nppglno1) THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                   LET g_showmsg=p_acc,"/",g_existno,"/",'0',"/",'1',"/",'PY'
                   CALL s_errmsg('B.npp07,B.nppglno,B.npptype,A.npptype,B.nppsys',g_showmsg,l_nppglno1,'axr-800',0)
                ELSE
                   CALL cl_err(l_nppglno1,'axr-800',0)
                END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno
             END IF
             DISPLAY l_npp07 TO FORMONLY.p_acc1
             LET g_existno1 = l_nppglno1
             DISPLAY BY NAME g_existno1
          END IF
# No.FUN-680068 ---end---
        END IF
        IF cl_null(g_existno) THEN NEXT FIELD g_existno1 END IF

# No.FUN-680068 --start--
       AFTER FIELD g_existno1
        IF NOT cl_null(g_existno1) THEN
             LET g_sql="SELECT aba00,aba02,aba03,aba04,abapost,aba19,abaacti ",
                       #"  FROM ",g_dbs_gl,"aba_file",
                       "  FROM ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                       " WHERE aba01 = ? AND aba00 = ? AND aba06='CP'" CLIPPED
 	         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
             PREPARE s_fsgl_t2_p1 FROM g_sql
             DECLARE s_fsgl_t2_c1 CURSOR FOR s_fsgl_t2_p1
             IF STATUS THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                   CALL s_errmsg('aba01,aba00,aba06','','decl aba_cursor:',STATUS,0)
                ELSE
                   CALL cl_err('decl aba_cursor:',STATUS,0) NEXT FIELD g_existno
                END IF
#NO.FUN-720003-------end
             END IF
# No.FUN-680068 --start--
#             OPEN s_fsgl_t2_c1 USING g_existno1,g_npp.npp07
              OPEN s_fsgl_t2_c1 USING g_existno1,p_acc1
# No.FUN-680068 ---end---
             FETCH s_fsgl_t2_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
                                     l_abaacti #no.7378

             IF STATUS THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                   CALL s_errmsg('aba01,aba00,aba06','','sel aba:',STATUS,0)
                ELSE
                   CALL cl_err('sel aba:',STATUS,0)
                END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno
             END IF

             #no.7378
             IF l_abaacti = 'N' THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                   CALL s_errmsg('aba01,aba00,aba06','','','mfg8001',1)
                ELSE
                   CALL cl_err('','mfg8001',1)
                END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno
             END IF
             #no.7378(end)
             SELECT UNIQUE A.npp07,A.nppglno
               INTO l_npp07,l_nppglno1
               FROM npp_file A,npp_file B
              WHERE A.npp01 = B.npp01
                AND A.npp011 = B.npp011
                AND A.npp00 = B.npp00
                AND A.nppsys = B.nppsys
                AND B.npp07 = p_acc1
                AND B.nppglno = g_existno1
                AND B.npptype = '1'
                AND A.npptype = '0'
                AND B.nppsys = 'PY'
             IF cl_null(l_npp07) OR cl_null(l_nppglno1) THEN
#NO.FUN-720003------begin
               IF g_bgerr THEN
                LET g_showmsg=p_acc1,"/",g_existno1,"/",'1',"/",'0',"/",'PY'
                CALL s_errmsg('B.npp07,B.nppglno1,B.npptype,A.npptype,B.nppsys',g_showmsg,l_nppglno1,'axr-800',0)
               ELSE
                CALL cl_err(l_nppglno1,'axr-800',0)
               END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno
             END IF
             DISPLAY l_npp07 TO FORMONLY.p_acc1

          #---增加判斷會計帳別之關帳日期
             #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file",
             LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_gl,'aaa_file'), #FUN-A50102
                       " WHERE aaa01='",l_npp07,"'"
 	         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
             PREPARE s_fsgl_x1_gl_p1 FROM g_sql
             DECLARE s_fsgl_c1_gl_p1 CURSOR FOR s_fsgl_x1_gl_p1
             OPEN s_fsgl_c1_gl_p1
             FETCH s_fsgl_c1_gl_p1 INTO l_aaa07
             IF gl_date <= l_aaa07 THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                   CALL s_errmsg('aaa01',l_npp07,gl_date,'agl-200',0)
                ELSE
                   CALL cl_err(gl_date,'agl-200',0)
                END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno1
             END IF
            #------ end -------------------
            #-----MOD-980144---------
            ##傳票日期小於系統之關帳日,不可還原
            #IF gl_date < g_sma.sma53 THEN
            #   #NO.FUN-720003------begin
            #   IF g_bgerr THEN
            #      CALL s_errmsg('aaa01',l_npp07,'','aap-027',0)
            #   ELSE
            #      CALL cl_err('','aap-027',0)
            #   END IF
            #   #NO.FUN-720003-------end
            #   NEXT FIELD g_existno1
            #END IF
            #-----END MOD-980144-----
             IF l_abapost = 'Y' THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                   CALL s_errmsg('aaa01',l_npp07,g_existno1,'aap-130',0)
                ELSE
                   CALL cl_err(g_existno1,'aap-130',0)
                END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno1
             END IF
             IF l_aba19 ='Y' THEN
#NO.FUN-720003------begin
                IF g_bgerr THEN
                   CALL s_errmsg('aaa01',l_npp07,g_existno1,'aap-026',0)
                ELSE
                   CALL cl_err(g_existno1,'aap-026',0)
                END IF
#NO.FUN-720003-------end
                NEXT FIELD g_existno1
             END IF
             IF g_aza.aza63 = 'Y' AND g_npp.npptype = '1' THEN
                SELECT UNIQUE A.npp07,A.nppglno
                  INTO l_npp07,l_nppglno
                  FROM npp_file A,npp_file B
                 WHERE A.npp01 = B.npp01
                   AND A.npp011 = B.npp011
                   AND A.npp00 = B.npp00
                   AND A.nppsys = B.nppsys
                   AND B.npp07 = p_acc1
                   AND B.nppglno = g_existno1
                   AND B.npptype = '1'
                   AND A.npptype = '0'
                   AND B.nppsys = 'PY'
                IF cl_null(l_npp07) OR cl_null(l_nppglno) THEN
#NO.FUN-720003------begin
                   IF g_bgerr THEN
                      LET g_showmsg=p_acc1,"/",g_existno1,"/",'1',"/",'0',"/",'PY'
                      CALL s_errmsg('B.npp07,B.nppglno,B.npptype,A.npptype,B.nppsys',g_showmsg,l_nppglno,'axr-800',0)
                   ELSE
                      CALL cl_err(l_nppglno,'axr-800',0)
                   END IF
#NO.FUN-720003-------end
                   NEXT FIELD g_existno1
                END IF
                DISPLAY l_npp07 TO FORMONLY.p_acc
                LET g_existno = l_nppglno
                DISPLAY BY NAME g_existno
             END IF
        END IF
        IF cl_null(g_existno1) THEN NEXT FIELD g_existno END IF
# No.FUN-680068 ---end---

       AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          #-----MOD-8A0251---------
          IF NOT cl_null(g_existno) THEN
             LET g_sql="SELECT aba00,aba02,aba03,aba04,abapost,aba19,abaacti ",
                       #"  FROM ",g_dbs_gl,"aba_file",
                       "  FROM ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                       " WHERE aba01 = ? AND aba00 = ? AND aba06='CP'" CLIPPED
 	         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
             PREPARE s_fsgl_t_p1_1 FROM g_sql
             DECLARE s_fsgl_t_c1_1 CURSOR FOR s_fsgl_t_p1_1
             IF STATUS THEN
                IF g_bgerr THEN
                   CALL s_errmsg('aba01,aba00,aba06','','decl aba_cursor:',STATUS,0)
                ELSE
                   CALL cl_err('decl aba_cursor:',STATUS,0)
                END IF
                NEXT FIELD g_existno
             END IF
             OPEN s_fsgl_t_c1_1 USING g_existno,p_acc
             FETCH s_fsgl_t_c1_1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
                                    l_abaacti #no.7378
             IF STATUS THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','sel aba:',STATUS,0)
                ELSE
                   CALL cl_err('sel aba:',STATUS,0)
                END IF
                NEXT FIELD g_existno
             END IF

             IF l_abaacti = 'N' THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','','mfg8001',1)
                ELSE
                   CALL cl_err('','mfg8001',1)
                END IF
                NEXT FIELD g_existno
             END IF

             #---增加判斷會計帳別之關帳日期
             #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file",
             LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_gl,'aaa_file'), #FUN-A50102
                       " WHERE aaa01='",l_aba00,"'"
 	         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
             PREPARE s_fsgl_x_gl_p1_1 FROM g_sql
             DECLARE s_fsgl_c_gl_p1_1 CURSOR FOR s_fsgl_x_gl_p1_1
             OPEN s_fsgl_c_gl_p1_1
             FETCH s_fsgl_c_gl_p1_1 INTO l_aaa07
             IF gl_date <= l_aaa07 THEN
                IF g_bgerr THEN
                    CALL s_errmsg('aaa01',l_aba00,gl_date,'agl-200',0)
                ELSE
                    CALL cl_err(gl_date,'agl-200',0)
                END IF
                NEXT FIELD g_existno
             END IF
             #-----MOD-980144---------
             ##傳票日期小於系統之關帳日,不可還原
             #IF gl_date < g_sma.sma53 THEN
             #    IF g_bgerr THEN
             #       CALL s_errmsg('aaa01',l_aba00,'','aap-027',0)
             #    ELSE
             #       CALL cl_err('','aap-027',0)
             #    END IF
             #    NEXT FIELD g_existno
             #END IF
             #-----END MOD-980144-----
             IF l_abapost = 'Y' THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('aaa01',l_aba00,g_existno,'aap-130',0)
                 ELSE
                    CALL cl_err(g_existno,'aap-130',0)
                 END IF
                 NEXT FIELD g_existno
             END IF
             IF l_aba19 ='Y' THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('aaa01',l_aba00,g_existno,'aap-026',0)
                 ELSE
                    CALL cl_err(g_existno,'aap-026',0)
                 END IF
                 NEXT FIELD g_existno
             END IF
             IF g_aza.aza63 = 'Y' AND g_npp.npptype = '0' THEN
                SELECT UNIQUE A.npp07,A.nppglno
                  INTO l_npp07,l_nppglno1
                  FROM npp_file A,npp_file B
                 WHERE A.npp01 = B.npp01
                   AND A.npp011 = B.npp011
                   AND A.npp00 = B.npp00
                   AND A.nppsys = B.nppsys
                   AND B.npp07 = p_acc
                   AND B.nppglno = g_existno
                   AND B.npptype = '0'
                   AND A.npptype = '1'
                   AND B.nppsys = 'PY'
                IF cl_null(l_npp07) OR cl_null(l_nppglno1) THEN
                   IF g_bgerr THEN
                      LET g_showmsg=p_acc,"/",g_existno,"/",'0',"/",'1',"/",'PY'
                      CALL s_errmsg('B.npp07,B.nppglno,B.npptype,A.npptype,B.nppsys',g_showmsg,l_nppglno1,'axr-800',0)
                   ELSE
                      CALL cl_err(l_nppglno1,'axr-800',0)
                   END IF
                   NEXT FIELD g_existno
                END IF
                DISPLAY l_npp07 TO FORMONLY.p_acc1
                LET g_existno1 = l_nppglno1
                DISPLAY BY NAME g_existno1
             END IF
          END IF
          IF cl_null(g_existno) THEN NEXT FIELD g_existno1 END IF

          IF NOT cl_null(g_existno1) THEN
             LET g_sql="SELECT aba00,aba02,aba03,aba04,abapost,aba19,abaacti ",
                       #"  FROM ",g_dbs_gl,"aba_file",
                       "  FROM ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                       " WHERE aba01 = ? AND aba00 = ? AND aba06='CP'" CLIPPED
 	         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
             PREPARE s_fsgl_t2_p1_1 FROM g_sql
             DECLARE s_fsgl_t2_c1_1 CURSOR FOR s_fsgl_t2_p1_1
             IF STATUS THEN
                IF g_bgerr THEN
                   CALL s_errmsg('aba01,aba00,aba06','','decl aba_cursor:',STATUS,0)
                ELSE
                   CALL cl_err('decl aba_cursor:',STATUS,0) NEXT FIELD g_existno
                END IF
                NEXT FIELD g_existno
             END IF
             OPEN s_fsgl_t2_c1_1 USING g_existno1,p_acc1
             FETCH s_fsgl_t2_c1_1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
                                     l_abaacti
             IF STATUS THEN
                IF g_bgerr THEN
                   CALL s_errmsg('aba01,aba00,aba06','','sel aba:',STATUS,0)
                ELSE
                   CALL cl_err('sel aba:',STATUS,0)
                END IF
                NEXT FIELD g_existno
             END IF

             IF l_abaacti = 'N' THEN
                IF g_bgerr THEN
                   CALL s_errmsg('aba01,aba00,aba06','','','mfg8001',1)
                ELSE
                   CALL cl_err('','mfg8001',1)
                END IF
                NEXT FIELD g_existno
             END IF
             SELECT UNIQUE A.npp07,A.nppglno
               INTO l_npp07,l_nppglno1
               FROM npp_file A,npp_file B
              WHERE A.npp01 = B.npp01
                AND A.npp011 = B.npp011
                AND A.npp00 = B.npp00
                AND A.nppsys = B.nppsys
                AND B.npp07 = p_acc1
                AND B.nppglno = g_existno1
                AND B.npptype = '1'
                AND A.npptype = '0'
                AND B.nppsys = 'PY'
             IF cl_null(l_npp07) OR cl_null(l_nppglno1) THEN
               IF g_bgerr THEN
                LET g_showmsg=p_acc1,"/",g_existno1,"/",'1',"/",'0',"/",'PY'
                CALL s_errmsg('B.npp07,B.nppglno1,B.npptype,A.npptype,B.nppsys',g_showmsg,l_nppglno1,'axr-800',0)
               ELSE
                CALL cl_err(l_nppglno1,'axr-800',0)
               END IF
               NEXT FIELD g_existno
             END IF
             DISPLAY l_npp07 TO FORMONLY.p_acc1

             #---增加判斷會計帳別之關帳日期
             #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file",
             LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_gl,'aaa_file'), #FUN-A50102
                       " WHERE aaa01='",l_npp07,"'"
 	         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
             PREPARE s_fsgl_x1_gl_p1_1 FROM g_sql
             DECLARE s_fsgl_c1_gl_p1_1 CURSOR FOR s_fsgl_x1_gl_p1_1
             OPEN s_fsgl_c1_gl_p1_1
             FETCH s_fsgl_c1_gl_p1_1 INTO l_aaa07
             IF gl_date <= l_aaa07 THEN
                IF g_bgerr THEN
                   CALL s_errmsg('aaa01',l_npp07,gl_date,'agl-200',0)
                ELSE
                   CALL cl_err(gl_date,'agl-200',0)
                END IF
                NEXT FIELD g_existno1
             END IF
             #-----MOD-980144---------
             ##傳票日期小於系統之關帳日,不可還原
             #IF gl_date < g_sma.sma53 THEN
             #   IF g_bgerr THEN
             #      CALL s_errmsg('aaa01',l_npp07,'','aap-027',0)
             #   ELSE
             #      CALL cl_err('','aap-027',0)
             #   END IF
             #   NEXT FIELD g_existno1
             #END IF
             #-----END MOD-980144-----
             IF l_abapost = 'Y' THEN
                IF g_bgerr THEN
                   CALL s_errmsg('aaa01',l_npp07,g_existno1,'aap-130',0)
                ELSE
                   CALL cl_err(g_existno1,'aap-130',0)
                END IF
                NEXT FIELD g_existno1
             END IF
             IF l_aba19 ='Y' THEN
                IF g_bgerr THEN
                   CALL s_errmsg('aaa01',l_npp07,g_existno1,'aap-026',0)
                ELSE
                   CALL cl_err(g_existno1,'aap-026',0)
                END IF
                NEXT FIELD g_existno1
             END IF
             IF g_aza.aza63 = 'Y' AND g_npp.npptype = '1' THEN
                SELECT UNIQUE A.npp07,A.nppglno
                  INTO l_npp07,l_nppglno
                  FROM npp_file A,npp_file B
                 WHERE A.npp01 = B.npp01
                   AND A.npp011 = B.npp011
                   AND A.npp00 = B.npp00
                   AND A.nppsys = B.nppsys
                   AND B.npp07 = p_acc1
                   AND B.nppglno = g_existno1
                   AND B.npptype = '1'
                   AND A.npptype = '0'
                   AND B.nppsys = 'PY'
                IF cl_null(l_npp07) OR cl_null(l_nppglno) THEN
                   IF g_bgerr THEN
                      LET g_showmsg=p_acc1,"/",g_existno1,"/",'1',"/",'0',"/",'PY'
                      CALL s_errmsg('B.npp07,B.nppglno,B.npptype,A.npptype,B.nppsys',g_showmsg,l_nppglno,'axr-800',0)
                   ELSE
                      CALL cl_err(l_nppglno,'axr-800',0)
                   END IF
                   NEXT FIELD g_existno1
                END IF
                DISPLAY l_npp07 TO FORMONLY.p_acc
                LET g_existno = l_nppglno
                DISPLAY BY NAME g_existno
             END IF
          END IF
          IF g_aza.aza63 = 'Y' THEN
             IF cl_null(g_existno1) THEN NEXT FIELD g_existno END IF
          END IF
          #-----END MOD-8A0251-----
          #得出總帳 database name
          #g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
          LET g_plant_new= p_plant  # 工廠編號
          CALL s_getdbs()
          LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
          LET g_plant_gl= p_plant  # 工廠編號#FUN-A50102

       #MOD-480614
      ON ACTION controlp
            CASE
               WHEN INFIELD(p_plant) #查詢工廠資料檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  CALL cl_create_qry() RETURNING p_plant
                  DISPLAY BY NAME p_plant
                  NEXT FIELD p_plant
               OTHERWISE
               EXIT CASE
            END CASE
      #--

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121


   END INPUT

   IF INT_FLAG THEN LET INT_FLAG = 0
      CLOSE WINDOW s_fsgl_u
      RETURN
   END IF

   IF cl_sure(18,20) THEN
      CALL s_fsgl_unt_process()
   END IF

   CLOSE WINDOW s_fsgl_u
   DISPLAY BY NAME g_npp.nppglno,g_npp.npp03      #TQC-6C0071
   DISPLAY ' ',' ' TO azn02,azn04      #TQC-6C0071

END FUNCTION

FUNCTION s_fsgl_unt_process()
   DEFINE g_aaz84 LIKE aaz_file.aaz84 #還原方式 1.刪除 2.作廢 no.4868

   #no.4868 (還原方式為刪除/作廢)
   #LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",
   LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(g_plant_gl,'aaz_file'), #FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
   PREPARE aaz84_pre FROM g_sql
   DECLARE aaz84_cs CURSOR FOR aaz84_pre
   OPEN aaz84_cs
   FETCH aaz84_cs INTO g_aaz84
   IF STATUS THEN
#NO.FUN-720003------begin
      IF g_bgerr THEN
         CALL s_errmsg('aaz00','','sel aaz84',STATUS,1)
      ELSE
         CALL cl_err('sel aaz84',STATUS,1)
      END IF
#NO.FUN-720003-------end
    RETURN
   END IF
   #no.4868(end)

   LET g_success = 'Y'

   BEGIN WORK

    OPEN s_fsgl_cl USING g_npp.npp00,g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npptype
    IF STATUS THEN
#NO.FUN-720003------begin
      IF g_bgerr THEN
         CALL s_errmsg('','',"OPEN s_fsgl_cl:", STATUS, 1)
      ELSE
         CALL cl_err("OPEN s_fsgl_cl:", STATUS, 1)
      END IF
#NO.FUN-720003-------end
       CLOSE s_fsgl_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH s_fsgl_cl INTO g_npp.*
    IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
      IF g_bgerr THEN
         CALL s_errmsg('','',g_npp.npp01,SQLCA.sqlcode,0)
      ELSE
         CALL cl_err(g_npp.npp01,SQLCA.sqlcode,0)
      END IF
#NO.FUN-720003-------end
       CLOSE s_fsgl_cl
       ROLLBACK WORK
       RETURN
    END IF
   IF g_aaz84 = '2' THEN   #還原方式為作廢 #no.4868
      #CALL s_fsgl_abhmod_h('N',g_aba.aba01)   #No.MOD-910041   #MOD-9C0099
      #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                "   SET abaacti = 'N' ",
                " WHERE aba01 = ? AND aba00 = ? "
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE s_fsgl_updaba_p FROM g_sql
      EXECUTE s_fsgl_updaba_p USING g_existno,p_acc            # No.FUN-680068  ch g_npp.npp07 --> p_acc
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)  #No.FUN-660130
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('aba01,aba00','','(upd abaacti)',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","aba_file",g_existno,g_npp.npp07,SQLCA.sqlcode,"","(upd abaacti)",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         ROLLBACK WORK RETURN
      END IF
   ELSE
      #CALL s_fsgl_abhmod_h('R',g_aba.aba01)   #CHI-910046   #MOD-9C0099
      MESSAGE "Delete GL's Voucher body!"  #-------------------------
      #LET g_sql="DELETE FROM ",g_dbs_gl,"abb_file WHERE abb01=? AND abb00=?"
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_gl,'abb_file'), #FUN-A50102
                " WHERE abb01=? AND abb00=?"
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE s_fsgl_3_p3 FROM g_sql
      EXECUTE s_fsgl_3_p3 USING g_existno,p_acc            # No.FUN-680068  ch g_npp.npp07 --> p_acc
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abb)',SQLCA.sqlcode,1)  #No.FUN-660130
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('abb01,abb00','','(del abb)',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","abb_file",g_existno,g_npp.npp07,SQLCA.sqlcode,"","(del abb)",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
      END IF
      MESSAGE "Delete GL's Voucher head!"  #-------------------------
      #LET g_sql="DELETE FROM ",g_dbs_gl,"aba_file WHERE aba01=? AND aba00=?"
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                " WHERE aba01=? AND aba00=?"
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE s_fsgl_3_p4 FROM g_sql
      EXECUTE s_fsgl_3_p4 USING g_existno,p_acc            # No.FUN-680068  ch g_npp.npp07 --> p_acc
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del aba)',SQLCA.sqlcode,1)  #No.FUN-660130
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('aba01,aba00','','(del aba)',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","aba_file",g_existno,g_npp.npp07,SQLCA.sqlcode,"","(del aba)",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         #CALL cl_err('(del aba)','aap-161',1)  #No.FUN-660130
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('aba01,aba00','','(del aba)',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","aba_file",g_existno,g_npp.npp07,"aap-161","","(del aba)",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
      END IF
      MESSAGE "Delete GL's Voucher desp!"  #-------------------------
      #LET g_sql="DELETE FROM ",g_dbs_gl,"abc_file WHERE abc01=? AND abc00=?"
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_gl,'abc_file'), #FUN-A50102
                " WHERE abc01=? AND abc00=?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE p409_3_p5 FROM g_sql
      EXECUTE p409_3_p5 USING g_existno,p_acc            # No.FUN-680068  ch g_npp.npp07 --> p_acc
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abc)',SQLCA.sqlcode,1)  #No.FUN-660130
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('abc01,abc00','','(del abc)',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","abc_file",g_existno,g_npp.npp07,SQLCA.sqlcode,"","(del abc)",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
      END IF
#FUN-B40056 --begin
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_gl,'tic_file'), #FUN-A50102
                " WHERE tic04=? AND tic00=?"
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
      CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql
      PREPARE s_fsgl_3_p8 FROM g_sql
      EXECUTE s_fsgl_3_p8 USING g_existno,p_acc      
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg('tic04,tic00','','(del tic)',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","tic_file",g_existno,g_npp.npp07,SQLCA.sqlcode,"","(del tic)",1)  #No.FUN-660130
         END IF
         LET g_success = 'N'
      END IF
#FUN-B40056 --end
   END IF
  #CALL s_abhmod(g_dbs_gl,p_acc,g_existno)   #MOD-9C0099 #TQC-9C0099
   CALL s_abhmod(p_plant,p_acc,g_existno)   #MOD-9C0099  #TQC-9C0099
      UPDATE npp_file SET
             npp03='',
             nppglno='',
             npp06='',
             npp07=''
       WHERE npp01 = g_npp.npp01
         AND npp011= g_npp.npp011
         AND npp00 = g_npp.npp00
  #       AND npptype = '0'                   #No.FUN-680068
         AND nppsys= g_npp.nppsys
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('unt_upd npp03/glno:',SQLCA.sqlcode,1)   #No.FUN-660130
#NO.FUN-720003------begin
         IF g_bgerr THEN
            LET g_showmsg=g_npp.npp01,"/",g_npp.npp011,"/",g_npp.npp00,"/",g_npp.nppsys
            CALL s_errmsg('npp01,npp011,nppsys',g_showmsg,'unt_upd npp03/glno:',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","npp_file",g_npp.npp01,g_npp.npp00,SQLCA.sqlcode,"","unt_upd npp03/glno",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success='N'
      END IF
# No.FUN-680068 --start--
 IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
   IF g_aaz84 = '2' THEN   #還原方式為作廢 #no.4868
      #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                "   SET abaacti = 'N' ",
                " WHERE aba01 = ? AND aba00 = ? "
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE s_fsgl_updaba_p1 FROM g_sql
      EXECUTE s_fsgl_updaba_p1 USING g_existno1,p_acc1             # No.FUN-680068  ch g_npp.npp07 --> p_acc1
      IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
         IF g_bgerr THEN
            LET g_showmsg='?',"/",'?'
            CALL s_errmsg('aba01,aba00',g_showmsg,"(upd abaacti)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","aba_file",g_existno1,g_npp.npp07,SQLCA.sqlcode,"","(upd abaacti)",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         ROLLBACK WORK RETURN
      END IF
   ELSE
      MESSAGE "Delete GL's Voucher body!"  #-------------------------
      #LET g_sql="DELETE FROM ",g_dbs_gl,"abb_file WHERE abb01=? AND abb00=?"
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_gl,'abb_file'), #FUN-A50102
                " WHERE abb01=? AND abb00=?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE s_fsgl_31_p3 FROM g_sql
      EXECUTE s_fsgl_31_p3 USING g_existno1,p_acc1             # No.FUN-680068  ch g_npp.npp07 --> p_acc1
      IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('abb01,abb00','',"(del abb)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","abb_file",g_existno1,g_npp.npp07,SQLCA.sqlcode,"","(del abb)",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
      END IF
      MESSAGE "Delete GL's Voucher head!"  #-------------------------
      #LET g_sql="DELETE FROM ",g_dbs_gl,"aba_file WHERE aba01=? AND aba00=?"
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_gl,'aba_file'), #FUN-A50102
                " WHERE aba01=? AND aba00=?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE s_fsgl_31_p4 FROM g_sql
      EXECUTE s_fsgl_31_p4 USING g_existno1,p_acc1             # No.FUN-680068  ch g_npp.npp07 --> p_acc1
      IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('aba01,aba00','',"(del aba)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","aba_file",g_existno,g_npp.npp07,SQLCA.sqlcode,"","(del aba)",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('aba01,aba00','',"(del aba)","aap-161",1)
         ELSE
            CALL cl_err3("del","aba_file",g_existno,g_npp.npp07,"aap-161","","(del aba)",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
      END IF
      MESSAGE "Delete GL's Voucher desp!"  #-------------------------
      #LET g_sql="DELETE FROM ",g_dbs_gl,"abc_file WHERE abc01=? AND abc00=?"
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_gl,'abc_file'), #FUN-A50102
                " WHERE abc01=? AND abc00=?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE p409_31_p5 FROM g_sql
      EXECUTE p409_31_p5 USING g_existno1,p_acc1             # No.FUN-680068  ch g_npp.npp07 --> p_acc1
      IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
         IF g_bgerr THEN
            CALL s_errmsg('abc01,abc00','',"(del abc)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","abc_file",g_existno,g_npp.npp07,SQLCA.sqlcode,"","(del abc)",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success = 'N'
      END IF
#FUN-B40056  --begin
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_gl,'tic_file'),
                " WHERE tic04=? AND tic00=?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql 
      PREPARE s_fsgl_31_p8 FROM g_sql
      EXECUTE s_fsgl_31_p8 USING g_existno1,p_acc1            
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg('abb01,abb00','',"(del tic)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","tic_file",g_existno1,g_npp.npp07,SQLCA.sqlcode,"","(del tic)",1)
         END IF
         LET g_success = 'N'
      END IF
#FUN-B40056  --end

   END IF
      UPDATE npp_file SET
             npp03='',
             nppglno='',
             npp06='',
             npp07=''
       WHERE npp01 = g_npp.npp01
         AND npp011= g_npp.npp011
         AND npp00 = g_npp.npp00
#         AND npptype = '1'     # No.FUN-680068
         AND nppsys= g_npp.nppsys
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#NO.FUN-720003------begin
         IF g_bgerr THEN
            LET g_showmsg=g_npp.npp01,"/",g_npp.npp011,"/",g_npp.npp00,"/",g_npp.nppsys
            CALL s_errmsg('npp01,npp011,npp00,nppsys',g_showmsg,"unt_upd npp03/glno",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","npp_file",g_npp.npp01,g_npp.npp00,SQLCA.sqlcode,"","unt_upd npp03/glno",1)  #No.FUN-660130
         END IF
#NO.FUN-720003-------end
         LET g_success='N'
      END IF
END IF
# No.FUN-680068 ---end---
   IF g_success = 'Y' THEN
      CLOSE s_fsgl_cl
      COMMIT WORK
      LET g_npp.nppglno=''
      LET g_npp.npp03  =''
      LET g_npp.npp06  =''
      LET g_npp.npp07  =''
   ELSE
      ROLLBACK WORK
   END IF

END FUNCTION
#end FUN-690134 add

FUNCTION fsgl_npq11(p_cmd,p_seq,p_key)
        DEFINE p_cmd      LIKE aag_file.aag151,           # 檢查否
               p_seq      LIKE aee_file.aee02,         #No.FUN-680147 VARCHAR(01)
               p_key      LIKE aee_file.aee03,         #No.FUN-680147 VARCHAR(20)# 異動碼
               l_aeeacti  LIKE aee_file.aeeacti,
               l_aee04    LIKE aee_file.aee04
        LET g_errno = ' '
        IF p_cmd IS NULL OR p_cmd NOT MATCHES "[123]" THEN RETURN END IF
        SELECT aee04,aeeacti INTO l_aee04,l_aeeacti FROM aee_file
                WHERE aee01 = g_npq[l_ac].npq03
                  AND aee02 = p_seq     AND aee03 = p_key
                  AND aee00 = g_bookno33  #No.FUN-730020
        CASE p_cmd
                WHEN '2' IF p_key IS NULL OR p_key = ' ' THEN
                                    LET g_errno = 'agl-154'
                                 END IF
                WHEN '3' CASE
                     WHEN p_key IS NULL OR p_key = ' '
                          LET g_errno = 'agl-154'
                     WHEN l_aeeacti = 'N' LET g_errno = '9027'
                     WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-153'
                         OTHERWISE  LET g_errno = SQLCA.sqlcode USING'-------'
                         END CASE
                OTHERWISE EXIT CASE
        END CASE
   {--No.MOD-4A0111
        IF l_aee04 IS NOT NULL AND cl_null(g_errno) THEN
           IF g_npq[l_ac].npq04 IS NULL
              THEN LET g_npq[l_ac].npq04 = l_aee04
              ELSE IF l_aee04 != g_npq[l_ac].npq04  THEN
                      PROMPT l_aee04,' <cr>:' FOR CHAR g_chr
                         ON IDLE g_idle_seconds
                            CALL cl_on_idle()
#                            CONTINUE PROMPT

                      END PROMPT
                   END IF
           END IF
        END IF
---}

END FUNCTION

#FUN-5C0015 051216 BY GILL --START
FUNCTION  s_fsgl_show_filed()
#依參數決定異動碼的多寡

  DEFINE l_field     STRING

#FUN-B50105   ---start   Mark
# IF g_aaz.aaz88 = 10 THEN
#    RETURN
# END IF

# IF g_aaz.aaz88 = 0 THEN
#    LET l_field  = "npq11,npq12,npq13,npq14,npq31,npq32,npq33,npq34,",
#                   "npq35"                     #MOD-AA0006 remove npq36
# END IF

# IF g_aaz.aaz88 = 1 THEN
#    LET l_field  = "npq12,npq13,npq14,npq31,npq32,npq33,npq34,",
#                   "npq35"                     #MOD-AA0006 remove npq36
# END IF

# IF g_aaz.aaz88 = 2 THEN
#    LET l_field  = "npq13,npq14,npq31,npq32,npq33,npq34,",
#                   "npq35"                     #MOD-AA0006 remove npq36
# END IF

# IF g_aaz.aaz88 = 3 THEN
#    LET l_field  = "npq14,npq31,npq32,npq33,npq34,",
#                   "npq35"                     #MOD-AA0006 remove npq36
# END IF

# IF g_aaz.aaz88 = 4 THEN
#    LET l_field  = "npq31,npq32,npq33,npq34,",
#                   "npq35"                     #MOD-AA0006 remove npq36
# END IF

# IF g_aaz.aaz88 = 5 THEN
#    LET l_field  = "npq32,npq33,npq34,",
#                   "npq35"                     #MOD-AA0006 remove npq36
# END IF

# IF g_aaz.aaz88 = 6 THEN
#    LET l_field  = "npq33,npq34,npq35"         #MOD-AA0006 remove npq36
# END IF

# IF g_aaz.aaz88 = 7 THEN
#    LET l_field  = "npq34,npq35"               #MOD-AA0006 remove npq36
# END IF

# IF g_aaz.aaz88 = 8 THEN
#    LET l_field  = "npq35"                     #MOD-AA0006 remove npq36
# END IF
#FUN-B50105   ---start   Mark
 #-MOD-AA0006-mark-
 #IF g_aaz.aaz88 = 9 THEN
 #   LET l_field  = "npq36"
 #END IF
 #-MOD-AA0006-end-

#FUN-B50105   ---start   Add
   IF g_aaz.aaz88 = 0 THEN
      LET l_field = "npq11,npq12,npq13,npq14"
   END IF
   IF g_aaz.aaz88 = 1 THEN
      LET l_field = "npq12,npq13,npq14"
   END IF
   IF g_aaz.aaz88 = 2 THEN
      LET l_field = "npq13,npq14"
   END IF
   IF g_aaz.aaz88 = 3 THEN
      LET l_field = "npq14"
   END IF
   IF g_aaz.aaz88 = 4 THEN
      LET l_field = ""
   END IF
   IF NOT cl_null(l_field) THEN
      LET l_field = l_field,","
   END IF
   IF g_aaz.aaz125 = 5 THEN
      LET l_field = l_field,"npq32,npq33,npq34,npq35"
   END IF
   IF g_aaz.aaz125 = 6 THEN
      LET l_field = l_field,"npq33,npq34,npq35"
   END IF
   IF g_aaz.aaz125 = 7 THEN
      LET l_field = l_field,"npq34,npq35"
   END IF
   IF g_aaz.aaz125 = 8 THEN
      LET l_field = l_field,"npq35"
   END IF
#FUN-B50105   ---end     Add

  CALL cl_set_comp_visible(l_field,FALSE)

 #CALL cl_set_comp_visible("npq08,npq35,npq36", g_aza.aza08 = 'Y')  #FUN-810045   #MOD-AA0006 mark
  CALL cl_set_comp_visible("npq08,npq35", g_aza.aza08 = 'Y')  #FUN-810045         #MOD-AA0006
END FUNCTION

FUNCTION s_fsgl_get_ahe02(p_no)
  DEFINE p_no LIKE aaz_file.aaz88
   LET g_ahe02 = ''
   CASE p_no
      WHEN "1" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag15
      WHEN "2" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag16
      WHEN "3" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag17
      WHEN "4" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag18
      WHEN "5" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag31
      WHEN "6" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag32
      WHEN "7" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag33
      WHEN "8" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag34
      WHEN "9" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag35
      WHEN "10" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag36
      WHEN "99" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag37
   END CASE
END FUNCTION

FUNCTION s_fsgl_set_no_required()
   DEFINE   l_aag371  LIKE aag_file.aag371              #FUN-950053
   CALL cl_set_comp_required("npq11,npq12,npq13,npq14,npq31,npq32,npq33,npq34,npq35,
                              npq36,npq37,npq05,npq08",FALSE)   #MOD-680003 #No.FUN-840006 npq05之后去掉npq15
                              #npq36,npq37",FALSE)   #MOD-680003
   #FUN-950053----------------------add start----------------------------
   SELECT aag371 INTO l_aag371 FROM aag_file
    WHERE aag01=g_npq[l_ac].npq03
      AND aag00 = g_bookno33
   IF l_aag371= '4' THEN
     #IF g_pmc903 != 'Y' AND g_occ37 != 'Y' THEN   #MOD-B10192 mark
      IF g_pmc903 != 'Y' OR g_occ37 != 'Y' THEN    #MOD-B10192
         CALL cl_set_comp_required("npq37",FALSE)
      END IF
   END IF
   #FUN-950053 -------------------add end----------------------------------
END FUNCTION
FUNCTION s_fsgl_set_required()
    DEFINE    l_aag371     LIKE aag_file.aag371               #FUN-950053 add
    #-----MOD-680003---------
    #本科目是否作部門明細管理 (Y/N)
    IF l_aag05='Y' THEN
       CALL cl_set_comp_required("npq05",TRUE)
    END IF

    #是否作線上預算控制(Y/N)
#No.FUN-840006 080407 mark --begin
#   IF l_aag21 = 'Y' THEN
#      CALL cl_set_comp_required("npq15",TRUE)
#   END IF
#No.FUN-840006 080407 mark --end
   #No.TQC-920068--begin--
    IF l_aag21 = 'Y' THEN
       CALL cl_set_comp_required("npq36",TRUE)
    END IF
   #No.TQC-920068---end---

    #是否作專案管理(Y/N)
    IF l_aag23 = 'Y' THEN
       #CALL cl_set_comp_required("npq08",TRUE)       #MOD-8C0274 mark
       CALL cl_set_comp_required("npq08,npq35",TRUE)  #MOD-8C0274 add
    END IF
    #-----END MOD-680003-----

   IF l_aag151 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq11",TRUE)
   END IF
   IF l_aag161 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq12",TRUE)
   END IF
   IF l_aag171 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq13",TRUE)
   END IF
   IF l_aag181 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq14",TRUE)
   END IF
   IF l_aag311 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq31",TRUE)
   END IF
   IF l_aag321 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq32",TRUE)
   END IF
   IF l_aag331 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq33",TRUE)
   END IF
   IF l_aag341 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq34",TRUE)
   END IF
 ##No.TQC-920068--begin-- mark
 # IF l_aag351 MATCHES '[23]' THEN
 #    CALL cl_set_comp_required("npq35",TRUE)
 # END IF
 # IF l_aag361 MATCHES '[23]' THEN
 #    CALL cl_set_comp_required("npq36",TRUE)
 # END IF
 ##No.TQC-920068---end--- mark
   IF l_aag371 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq37",TRUE)
   END IF

   #FUN-950053 ---------------------add start-------------------------------
   SELECT aag371 INTO l_aag371 FROM aag_file
    WHERE aag01=g_npq[l_ac].npq03
      AND aag00 = g_bookno33
   IF l_aag371= '4' THEN
      IF g_pmc903 = 'Y' OR g_occ37 = 'Y' THEN
         CALL cl_set_comp_required("npq37",TRUE)
      END IF
   END IF
   #FUN-950053 ------------------add end--------------------------------------
END FUNCTION

#Patch....NO.MOD-5A0095 <001,002> #
#MOD-7A0089

#No.FUN-830161  --Begin
FUNCTION s_fsgl_bud()
  DEFINE l_aag04       LIKE aag_file.aag04           #MOD-C90261 add
  DEFINE l_aag05       LIKE aag_file.aag05
  DEFINE l_aag06       LIKE aag_file.aag06
  DEFINE l_aag21       LIKE aag_file.aag21
  DEFINE l_aag23       LIKE aag_file.aag23
  DEFINE l_tol         LIKE afc_file.afc07
  DEFINE l_tol1        LIKE afc_file.afc07
  DEFINE total_t       LIKE afc_file.afc07
  DEFINE #l_sql1        LIKE type_file.chr1000
         l_sql1          STRING      #NO.FUN-910082
  DEFINE l_buf         LIKE ze_file.ze03
  DEFINE l_buf1        LIKE ze_file.ze03
  DEFINE l_str         LIKE ze_file.ze03
  DEFINE l_showmsg     LIKE ze_file.ze03
  DEFINE l_flag        LIKE type_file.chr1
  DEFINE l_amt         LIKE afc_file.afc07
  DEFINE l_afb07       LIKE afb_file.afb07
  DEFINE l_yy          LIKE type_file.num5
  DEFINE l_mm          LIKE type_file.num5

   LET g_errno = ''
   SELECT aag04,aag05,aag06,aag21,aag23               #MOD-C90261 add aag04
     INTO l_aag04,l_aag05,l_aag06,l_aag21,l_aag23     #MOD-C90261 add aag04
     FROM aag_file
    WHERE aag01 = g_npq[l_ac].npq03
      AND aag00 = g_bookno33
   IF SQLCA.sqlcode THEN
      LET g_showmsg = g_bookno33,'/',g_npq[l_ac].npq03
      IF g_bgerr THEN
         CALL s_errmsg('aag00,aag01',g_showmsg,'',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err(g_showmsg,SQLCA.sqlcode,1)
      END IF
      LET g_errno = 'abg-010'
      RETURN
   END IF

   #不做預算管理
   IF l_aag21 = 'N' OR cl_null(l_aag21) THEN
      RETURN
   END IF

   IF g_npp.nppsys = 'FA' AND l_aag04 = '1' THEN                    #MOD-C90261 add
      RETURN                                                        #MOD-C90261 add
   END IF                                                           #MOD-C90261 add

   #系統設置不做項目管理
   IF g_aza.aza08 = 'N' THEN
      LET g_npq[l_ac].npq08 = ' '
      LET g_npq[l_ac].npq35 = ' '
   END IF

   LET l_yy = YEAR(g_npp.npp02)
   LET l_mm = MONTH(g_npp.npp02)
   IF g_bookno33 IS NULL OR g_npq[l_ac].npq36 IS NULL OR
      g_npq[l_ac].npq03 IS NULL OR l_yy IS NULL OR
      g_npq[l_ac].npq35 IS NULL OR g_npq[l_ac].npq05 IS NULL OR
      g_npq[l_ac].npq08 IS NULL OR l_mm IS NULL THEN
      RETURN
   END IF

   #不做部門管理
   IF l_aag05 = 'N' AND NOT cl_null(g_npq[l_ac].npq05) THEN
      IF g_bgerr THEN
         CALL s_errmsg('npq05',g_npq[l_ac].npq05,'','agl-216',1)
      ELSE
         CALL cl_err(g_npq[l_ac].npq05,'agl-216',1)
      END IF
      LET g_errno = 'agl-216'
      RETURN
   END IF

   #做部門管理
   IF l_aag05 = 'Y' AND cl_null(g_npq[l_ac].npq05) THEN
      IF g_bgerr THEN
         CALL s_errmsg('npq05',g_npq[l_ac].npq05,'','aap-287',1)
      ELSE
         CALL cl_err(g_npq[l_ac].npq05,'aap-287',1)
      END IF
      LET g_errno = 'aap-287'
      RETURN
   END IF

   IF g_aza.aza08 = 'Y' THEN
      #做項目管理
      IF l_aag23 = 'Y' AND
        (cl_null(g_npq[l_ac].npq08) OR cl_null(g_npq[l_ac].npq35)) THEN
         LET g_showmsg = g_npq[l_ac].npq08,'/',g_npq[l_ac].npq35
         IF g_bgerr THEN
            CALL s_errmsg('npq08,npq35',g_showmsg,'','agl-235',1)
         ELSE
            CALL cl_err('npq08,npq35','agl-235',1)
         END IF
         LET g_errno = 'agl-235'
         RETURN
      END IF

      #不做項目管理
      IF l_aag23 = 'N' AND
        (NOT cl_null(g_npq[l_ac].npq08) OR NOT cl_null(g_npq[l_ac].npq35)) THEN
         LET g_showmsg = g_npq[l_ac].npq08,'/',g_npq[l_ac].npq35
         IF g_bgerr THEN
            CALL s_errmsg('npq08,npq35',g_showmsg,'','agl-234',1)
         ELSE
            CALL cl_err('npq08,npq35','agl-234',1)
         END IF
         LET g_errno = 'agl-234'
         RETURN
      END IF
   END IF
   IF g_aza.aza63 = 'N' THEN
      SELECT azn02,azn04 INTO g_azn02,g_azn04  FROM azn_file
       WHERE azn01 = g_npp.npp02
   ELSE
      #LET g_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl CLIPPED,"aznn_file",
      LET g_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_gl,'aznn_file'), #FUN-A50102
                  "  WHERE aznn01 = '",g_npp.npp02,"'" ,
                  "    AND aznn00 = '",g_bookno33,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql #FUN-A50102
      PREPARE aznn_pre FROM g_sql
      DECLARE aznn_cs CURSOR FOR aznn_pre
      OPEN aznn_cs
      FETCH aznn_cs INTO g_azn02,g_azn04
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('aznn01',g_npp.npp02,'','agl-101',1)
      ELSE
         CALL cl_err(g_npp.npp02,'agl-101',1)
      END IF
      LET g_errno = 'agl-101'
      RETURN
   END IF

   LET l_showmsg = g_bookno33,'/',g_npq[l_ac].npq36,'/',
                  #g_npq[l_ac].npq03,'/', l_yy,'/',          #CHI-A30021 mark
                   g_npq[l_ac].npq03,'/', g_azn02,'/',       #CHI-A30021 add
                   g_npq[l_ac].npq35,'/', g_npq[l_ac].npq05,'/',
                   g_npq[l_ac].npq08
   SELECT * FROM afb_file
    WHERE afb00 = g_bookno33
      AND afb01 = g_npq[l_ac].npq36
      AND afb02 = g_npq[l_ac].npq03
     #AND afb03 = l_yy             #CHI-A30021 mark
      AND afb03 = g_azn02          #CHI-A30021 add
      AND afb04 = g_npq[l_ac].npq35
      AND afb041= g_npq[l_ac].npq05
      AND afb042= g_npq[l_ac].npq08
      AND afbacti = 'Y'            #FUN-D70090

   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALl s_errmsg('afb00,afb01,afb02,afb03,afb04,afb041,afb042',l_showmsg,'','agl-139',0)
      ELSE
         CALL cl_err(l_showmsg,'agl-139',0)
      END IF
      LET g_errno = 'agl-139'
      RETURN
   END IF

   LET l_showmsg = l_showmsg CLIPPED,'/',l_mm
#No.MOD-B20121 --begin                                                          
   IF cl_null(g_argv8) THEN LET g_argv8 = g_npp.npptype END IF                  
#No.MOD-B20121 --end 
   CALL s_getbug1(g_bookno33,g_npq[l_ac].npq36,g_npq[l_ac].npq03,
                 #l_yy,g_npq[l_ac].npq35,g_npq[l_ac].npq05,         #CHI-A30021 mark
                 #g_npq[l_ac].npq08,l_mm,g_argv8)                   #CHI-A30021 mark
                  g_azn02,g_npq[l_ac].npq35,g_npq[l_ac].npq05,      #CHI-A30021 add
                  g_npq[l_ac].npq08,g_azn04,g_argv8)                #CHI-A30021 add
        RETURNING l_flag,l_afb07,l_amt
   IF l_flag THEN
      IF g_bgerr THEN
         CALl s_errmsg('afb00,afb01,afb02,afb03,afb04,afb041,afb042,afc05',l_showmsg,'','agl-139',0)
      ELSE
         CALL cl_err(l_showmsg,'agl-139',0)
      END IF
      LET g_errno = 'agl-139'
      RETURN
   END IF

   LET g_sql = "SELECT SUM(npq07) FROM npq_file,npp_file",
               " WHERE npp01 = npq01 ",
               "   AND npp011 = npq011 ",
               "   AND nppsys = npqsys ",
               "   AND npp00 = npq00 ",
               "   AND npptype = npqtype ",
               "   AND npqtype = '",g_argv8,"'",
               "   AND npq36 = '",g_npq[l_ac].npq36,"'",
               "   AND npq03 = '",g_npq[l_ac].npq03,"'",
               "   AND YEAR(npp02) = ",l_yy,
               "   AND npq35 = '",g_npq[l_ac].npq35,"'",
               "   AND npq05 = '",g_npq[l_ac].npq05,"'",
               "   AND npq08 = '",g_npq[l_ac].npq08,"'",
               "   AND MONTH(npp02) = ",l_mm,
               "   AND ( npq01 != '",g_npp.npp01,"' OR ",
               "       ( npq01  = '",g_npp.npp01,"' AND",
               "         npq02 != ",g_npq[l_ac].npq02,"))"
   LET l_sql1 = g_sql CLIPPED, "   AND npq06 = '1'"
   PREPARE s_fsgl_npq FROM l_sql1
   EXECUTE s_fsgl_npq INTO l_tol
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('npp01',g_npp.npp01,'sel npp',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err(g_npp.npp01,SQLCA.sqlcode,1)
      END IF
      LET g_errno = SQLCA.sqlcode
      RETURN
   END IF
   LET l_sql1 = g_sql CLIPPED, "   AND npq06 = '2'"
   PREPARE s_fsgl_npq1 FROM l_sql1
   EXECUTE s_fsgl_npq1 INTO l_tol1
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('npp01',g_npp.npp01,'sel npp',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err(g_npp.npp01,SQLCA.sqlcode,1)
      END IF
      LET g_errno = SQLCA.sqlcode
      RETURN
   END IF
   IF l_tol  IS NULL THEN LET l_tol  = 0 END IF
   IF l_tol1 IS NULL THEN LET l_tol1 = 0 END IF
   IF l_aag06 = '1' THEN
      LET total_t = l_tol - l_tol1
   ELSE
      LET total_t = l_tol1 - l_tol
   END IF
   LET total_t = total_t + g_npq[l_ac].npq07
   LET l_amt = l_amt + g_npq[l_ac].npq07                #MOD-CB0152 add
  #IF total_t > l_amt THEN                              #MOD-CB0152 mark
   IF g_npq[l_ac].npq07 > l_amt THEN                    #MOD-CB0152 add
      CASE l_afb07
           WHEN '2'
                   CALL cl_getmsg('agl-140',0) RETURNING l_buf
                   CALL cl_getmsg('agl-141',0) RETURNING l_buf1
                   LET l_str = l_buf CLIPPED,' ',total_t,
                               l_buf1 CLIPPED,' ',l_amt
                   IF g_bgerr THEN
                      CALl s_errmsg('afb00,afb01,afb02,afb03,afb04,afb041,afb042',l_showmsg,l_str,'agl-233',0)
                   ELSE
                      CALL cl_err(l_str,'agl-233',0)
                   END IF
                   LET g_errno = ''
                   RETURN
           WHEN '3'
                   CALL cl_getmsg('agl-142',0) RETURNING l_buf
                   CALL cl_getmsg('agl-143',0) RETURNING l_buf
                   LET l_str = l_buf CLIPPED,' ',total_t,
                               l_buf1 CLIPPED,' ',l_amt
                   IF g_bgerr THEN
                      CALl s_errmsg('afb00,afb01,afb02,afb03,afb04,afb041,afb042',l_showmsg,l_str,'agl-233',0)
                   ELSE
                      CALL cl_err(l_str,'agl-233',0)
                   END IF
                   LET g_errno = 'agl-233'
                   RETURN
      END CASE
   END IF
END FUNCTION
#No.FUN-830161  --End

#No.MOD-8C0274---Begin
FUNCTION s_fsgl_npq36()
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_ima920  LIKE ima_file.ima920

   LET l_cnt=0
   LET g_errno=''

  #CHI-A30021---add---start---
   #不做預算管理
   IF l_aag21 = 'N' OR cl_null(l_aag21) THEN
      RETURN
   END IF
  #CHI-A30021---add---end---

   IF cl_null(g_npq[l_ac].npq36) THEN
      IF g_apy.apydmy5 = 'Y' THEN
       LET g_errno = 'apj-201'
       RETURN
     END IF
   END IF

  IF cl_null(g_npq[l_ac].npq36) THEN RETURN END IF

   SELECT COUNT(*) INTO l_cnt  FROM azf_file
    WHERE azf01=g_npq[l_ac].npq36 AND azf02='2' AND azfacti='Y'

   CASE
      WHEN l_cnt=0
         IF g_aza.aza08 = 'Y' THEN
            LET g_errno = 'aap-301'
         ELSE
            LET g_errno = 'mfg5108'
         END IF
      WHEN SQLCA.SQLCODE != 0
         LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE


  IF cl_null(g_errno) THEN
     IF cl_null(g_npq[l_ac].npq03) THEN
        SELECT azf14 INTO g_npq[l_ac].npq03
          FROM azf_file
        WHERE azf01=g_npq[l_ac].npq36 AND azf02='2' AND azfacti='Y'
     END IF
     DISPLAY BY NAME g_npq[l_ac].npq03
  END IF

END FUNCTION
#No.MOD-8C0274---End

#-----No.MOD-910041-----
FUNCTION s_fsgl_abhmod_h(p_type,p_aba01)
   DEFINE p_type      LIKE type_file.chr1,
          p_aba01     LIKE aba_file.aba01,
          l_msg       LIKE type_file.chr1000,
          l_abg071    LIKE abg_file.abg071,
          l_abh       RECORD LIKE abh_file.*,
          l_abh09_2,l_abh09_3  LIKE abh_file.abh09
   #DEFINE l_rowid     LIKE type_file.chr18   #FUN-9A0083 mark

   DECLARE s_fsgl_abhmod_h CURSOR FOR
    SELECT abh_file.* FROM abh_file    #FUN-9A0083 mod
     WHERE abh00 = g_bookno
       AND abh01 = p_aba01

   FOREACH s_fsgl_abhmod_h INTO l_abh.*    #FUN-9A0083 mod

      IF SQLCA.sqlcode THEN
         CALL cl_err('s_fsgl_abh_mod',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF

      CASE
         WHEN p_type = 'R'    #刪除
            DELETE FROM abh_file WHERE abh01 = l_abh.abh01 AND abh02 = l_abh.abh02 AND abh00 = l_abh.abh00 AND abh06=l_abh.abh06 AND abh07 = l_abh.abh07 AND abh08 = l_abh.abh08  #FUN-9A0083
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("del","abh_file",l_abh.abh01,l_abh.abh02,SQLCA.sqlcode,"","del abh_file",1)
               LET g_success = 'N'
            END IF

         WHEN p_type = 'N'    #沖帳資料變無效
            UPDATE abh_file SET abhconf = 'X'
             WHERE abh07 = l_abh.abh07 AND abh08 = l_abh.abh08
               AND abh01 = p_aba01
               AND abh00 = g_bookno
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","abh_file",p_aba01,g_bookno,SQLCA.sqlcode,"","upd abh_file",1)
               LET g_success = 'N'
            END IF

         WHEN p_type = 'Y'    #沖帳資料變有效
            UPDATE abh_file SET abhconf = 'N'
             WHERE abh07 = l_abh.abh07 AND abh08 = l_abh.abh08
               AND abh01 = p_aba01
               AND abh00 = g_bookno
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","abh_file",p_aba01,g_bookno,SQLCA.sqlcode,"","upd abh_file",1)
               LET g_success = 'N'
            END IF

         OTHERWISE
            EXIT CASE
      END CASE

      SELECT sum(abh09) INTO l_abh09_2 FROM abh_file
       WHERE abhconf = 'Y'
         AND abh07 = l_abh.abh07
         AND abh08 = l_abh.abh08
         AND abh00 = g_bookno

      IF cl_null(l_abh09_2) THEN LET l_abh09_2 = 0 END IF

      SELECT sum(abh09) INTO l_abh09_3 FROM abh_file
       WHERE abhconf = 'N'
         AND abh07 = l_abh.abh07
         AND abh08 = l_abh.abh08
         AND abh00 = g_bookno

      IF cl_null(l_abh09_3) THEN LET l_abh09_3 = 0 END IF

      SELECT abg071 INTO l_abg071 FROM abg_file
       WHERE abg00 = g_bookno
         AND abg01 = l_abh.abh07
         AND abg02 = l_abh.abh08

      IF SQLCA.sqlcode THEN
         LET l_msg = l_abh.abh07,'-',l_abh.abh08 using '#&' clipped
         CALL cl_err3("sel","l_abg071",l_msg,"","agl-909","","",1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      IF l_abg071 < (l_abh09_2+l_abh09_3) THEN
         LET l_msg = l_abh.abh07,'-',l_abh.abh08 clipped
         CALL cl_err(l_msg,'agl-908',0)
         LET g_success = 'N'
      END IF

      UPDATE abg_file SET abg072 = l_abh09_2,
                          abg073 = l_abh09_3
       WHERE abg00 = g_bookno
         AND abg01 = l_abh.abh07
         AND abg02 = l_abh.abh08

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET l_msg = l_abh.abh07,'-',l_abh.abh08 using '##&' clipped
         CALL cl_err3("upd","abg_file",l_msg,"","agl-909","","",1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

   END FOREACH

END FUNCTION
#-----No.MOD-910041 END-----
#No.MOD-910178 --begin
FUNCTION s_fsgl_npq24()
DEFINE l_oma08    LIKE oma_file.oma08
DEFINE l_date     LIKE apa_file.apa02
DEFINE l_rate     LIKE type_file.chr1

   LET l_date =null
   LET l_rate =null
   CASE g_argv1
       WHEN 'AP'
         SELECT apa02 INTO l_date FROM apa_file WHERE apa01 =g_argv3
         SELECT apz33 INTO l_rate FROM apz_file
       WHEN 'AR'
         SELECT oma02,oma08 INTO l_date,l_oma08 FROM oma_file WHERE oma01 =g_argv3
         IF l_oma08 ='1' THEN    #內銷
            SELECT ooz17 INTO l_rate FROM ooz_file
         ELSE
            SELECT ooz63 INTO l_rate FROM ooz_file
         END IF
   OTHERWISE
         LET l_date =g_today
         LET l_rate ='M'
   END CASE
   IF cl_null(l_date) THEN
      LET l_date =g_today
   END IF
   IF cl_null(l_rate) THEN
      LET l_rate ='M'
   END IF

   CALL s_curr3(g_npq[l_ac].npq24,l_date,l_rate) RETURNING g_npq[l_ac].npq25
   IF cl_null(g_npq[l_ac].npq25) THEN LET g_npq[l_ac].npq25 =1 END IF
   IF g_npq[l_ac].npq24 =g_aza.aza17 THEN
      LET g_npq[l_ac].npq25 = 1
   END IF
END FUNCTION
#No.MOD-910178 --end
#No.FUN-A10006 --begin
FUNCTION s_fsgl_u()

   IF s_shut(0) THEN
      RETURN
   END IF

   #No.TQC-A50161  --Begin
   IF g_npp.npp01 IS NULL THEN RETURN END IF
   #-->已產生傳票不可修改
   IF NOT cl_null(g_npp.nppglno) THEN
      CALL cl_err(g_npp.npp01,'aap-145',0)
      RETURN
   END IF
   #-->此單據已確認
   IF g_argv7 matches '[Yy]' THEN
      CALL cl_err(g_npp.npp01,'aap-005',0)
      RETURN
   END IF
   #No.TQC-A50161  --End

   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK

    OPEN s_fsgl_cl USING g_npp.npp00,g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npptype
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('','',"OPEN s_fsgl_cl:",STATUS, 1)
       ELSE
          CALL cl_err("OPEN s_fsgl_cl:", STATUS, 1)
       END IF
       CLOSE s_fsgl_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH s_fsgl_cl INTO g_npp.*
    IF SQLCA.sqlcode THEN
       IF g_bgerr THEN
          CALL s_errmsg('','',g_npp.npp01,SQLCA.sqlcode,0)
       ELSE
          CALL cl_err(g_npp.npp01,SQLCA.sqlcode,0)
       END IF
       CLOSE s_fsgl_cl
       ROLLBACK WORK
       RETURN
    END IF

   WHILE TRUE
      LET g_npp_t.* = g_npp.*

      CALL s_fsgl_i("u")                      #欄位更改

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_npp.npp08=g_npp_t.npp08
         CALL s_fsgl_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      UPDATE npp_file SET npp_file.npp08 = g_npp.npp08
       WHERE npp01 = g_npp.npp01
         AND npp00 = g_npp.npp00
         AND npp011= g_npp.npp011
         AND nppsys= g_npp.nppsys
         AND npptype= g_npp.npptype

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","npp_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE s_fsgl_cl
   COMMIT WORK

END FUNCTION
FUNCTION s_fsgl_i(p_cmd)
DEFINE
   p_cmd     LIKE type_file.chr1     #a:輸入 u:更改  #No.FUN-680136 VARCHAR(1)

   IF s_shut(0) THEN
      RETURN
   END IF

   INPUT BY NAME g_npp.npp08
       WITHOUT DEFAULTS

      BEFORE INPUT

      AFTER FIELD npp08
         IF NOT cl_null(g_npp.npp01) THEN
            IF g_npp.npp08 <0 THEN
               CALL cl_err('','aec-020',1)
               LET g_npp.npp08 =g_npp_t.npp08
               NEXT FIELD npp08
            END IF
         END IF


      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


      ON ACTION controlp

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

   END INPUT

END FUNCTION
#No.FUN-A10006 --end
#FUN-A40033 --Begin
FUNCTION s_fsgl_diff(p_npp)
DEFINE p_npp            RECORD LIKE npp_file.*
DEFINE l_aaa            RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_bookno1        LIKE aba_file.aba01
DEFINE l_bookno2        LIKE aba_file.aba01
   IF p_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(p_npp.npp02))
           RETURNING g_flag,l_bookno1,l_bookno2
      IF g_flag =  '1' THEN
         CALL cl_err(p_npp.npp02,'aoo-081',1)
         RETURN
      END IF
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = p_npp.npp00
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = p_npp.npp00
         AND npq01 = p_npp.npp01
         AND npq011= p_npp.npp011
         AND npqsys= p_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = p_npp.npp00
         AND npq01 = p_npp.npp01
         AND npq011= p_npp.npp011
         AND npqsys= p_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = p_npp.npp00
            AND npq01 = p_npp.npp01
            AND npq011= p_npp.npp011
            AND npqsys= p_npp.nppsys
         LET l_npq1.npq00 = p_npp.npp00
         LET l_npq1.npq01 = p_npp.npp01
         LET l_npq1.npq011= p_npp.npp011
         LET l_npq1.npqsys= p_npp.nppsys
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03
         LET l_npq1.npq25 = 1
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq07f = l_npq1.npq07
         LET l_npq1.npqlegal=g_legal
         LET l_npq1.npq30=g_plant   #MOD-BC0115 add
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",p_npp.npp01,"",STATUS,"","",1)
            LET g_success = 'N'
            ROLLBACK WORK
         END IF
      END IF
   END IF
END FUNCTION
#FUN-A40033 --End
#CHI-AC0010
#FUN-AA0087 add --start--
FUNCTION g_npq_to_g_npq3() #FUN-AC0063 mod
 
   SELECT * INTO g_npq3.* FROM npq_file
    WHERE npq00  =g_npp.npp00
      AND npq01  =g_npp.npp01
      AND npq02  =g_npq_t.npq02
      AND npq011 =g_npp.npp011
      AND npqsys =g_npp.nppsys
      AND npqtype=g_npp.npptype

   LET g_npq3.npq02 = g_npq[l_ac].npq02
   LET g_npq3.npq03 = g_npq[l_ac].npq03
   LET g_npq3.npq04 = g_npq[l_ac].npq04
   LET g_npq3.npq05 = g_npq[l_ac].npq05
   LET g_npq3.npq06 = g_npq[l_ac].npq06
   LET g_npq3.npq07 = g_npq[l_ac].npq07
   LET g_npq3.npq07f = g_npq[l_ac].npq07f
   LET g_npq3.npq08 = g_npq[l_ac].npq08
   LET g_npq3.npq11 = g_npq[l_ac].npq11
   LET g_npq3.npq12 = g_npq[l_ac].npq12
   LET g_npq3.npq13 = g_npq[l_ac].npq13
   LET g_npq3.npq14 = g_npq[l_ac].npq14
   LET g_npq3.npq21 = g_npq[l_ac].npq21
   LET g_npq3.npq22 = g_npq[l_ac].npq22
   LET g_npq3.npq23 = g_npq[l_ac].npq23
   LET g_npq3.npq24 = g_npq[l_ac].npq24
   LET g_npq3.npq25 = g_npq[l_ac].npq25
   LET g_npq3.npq31 = g_npq[l_ac].npq31
   LET g_npq3.npq32 = g_npq[l_ac].npq32
   LET g_npq3.npq33 = g_npq[l_ac].npq33
   LET g_npq3.npq34 = g_npq[l_ac].npq34
   LET g_npq3.npq35 = g_npq[l_ac].npq35
   LET g_npq3.npq36 = g_npq[l_ac].npq36
   LET g_npq3.npq37 = g_npq[l_ac].npq37

END FUNCTION
#FUN-AA0087 add --end--

#FUN-C50113--add--str
FUNCTION s_fsgl_nppoutput()
   RETURN g_npp.*
END FUNCTION
#FUN-C50113--add--end
#FUN-B40056--add--str--
#現金流量明細
#No.TQC-B70021 --begin
#FUNCTION s_fsgl_flows()
#   DEFINE l_bookno1 LIKE aza_file.aza81   
#   DEFINE l_bookno2 LIKE aza_file.aza82   
#   DEFINE l_flag1   LIKE type_file.chr1   
#   DEFINE l_tic00   LIKE tic_file.tic00   #帳套
#   DEFINE l_tic01   LIKE tic_file.tic01   #年度
#   DEFINE l_tic02   LIKE tic_file.tic02   #期別
#   DEFINE l_tic03   LIKE tic_file.tic03   #借貸別
#   DEFINE g_tic     DYNAMIC ARRAY OF RECORD          
#                    tic04     LIKE tic_file.tic04,  #單據編號
#                    tic05     LIKE tic_file.tic05,  #項次
#                    tic06     LIKE tic_file.tic06,  #現金變動碼
#                    tic08     LIKE tic_file.tic08,  #關係人
#                    tic07f    LIKE tic_file.tic07f, #原幣金額
#                    tic07     LIKE tic_file.tic07   #本幣金額     
#                    END RECORD,
#          g_tic_t   RECORD          
#                    tic04     LIKE tic_file.tic04,  #單據編號
#                    tic05     LIKE tic_file.tic05,  #項次
#                    tic06     LIKE tic_file.tic06,  #現金變動碼
#                    tic08     LIKE tic_file.tic08,  #關係人
#                    tic07f    LIKE tic_file.tic07f, #原幣金額
#                    tic07     LIKE tic_file.tic07   #本幣金額     
#                    END RECORD
#   DEFINE g_tic_npq DYNAMIC ARRAY OF RECORD
#                    npq02     LIKE npq_file.npq02,  #項次
#                    npq25     LIKE npq_file.npq25,  #匯率
#                    aag371    LIKE aag_file.aag371,  
#                    npq37     LIKE npq_file.npq37,  #關係人
#                    npq07f    LIKE npq_file.npq07f, #原幣金額 
#                    npq07     LIKE npq_file.npq07   #本幣金額
#                    END RECORD                 
#   DEFINE l_n,t,i,j           LIKE type_file.num5
#   DEFINE l_success           LIKE type_file.chr1  
#   DEFINE l_rec_b             LIKE type_file.num5 
#   DEFINE l_allow_insert      LIKE type_file.num5
#   DEFINE l_allow_delete      LIKE type_file.num5 
#   DEFINE p_cmd               LIKE type_file.chr1 
#   DEFINE l_sum1,l_sum2       LIKE abb_file.abb07
#   DEFINE l_sum3,l_sum4       LIKE abb_file.abb07f 
#   DEFINE l_sql               STRING
#   DEFINE l_npq06             LIKE npq_file.npq06
#   DEFINE l_npq02             LIKE npq_file.npq02
#   DEFINE l_tic05             LIKE tic_file.tic05
#   DEFINE l_npq03             LIKE npq_file.npq03
#   DEFINE l_npq25             LIKE npq_file.npq25
##TQC-B70021   
#   CALL g_tic.clear()
#   CALL g_tic_npq.clear()
#   OPEN WINDOW s_fsgl_f AT 10,20 WITH FORM "sub/42f/s_fsgl_flows"
#   ATTRIBUTE(STYLE = g_win_style CLIPPED)
# 
#   CALL cl_ui_locale("s_fsgl_flows")
#
#   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING l_flag1,l_bookno1,l_bookno2   #帳套   
#   IF g_npp.npptype = 0 THEN
#      LET l_tic00 = l_bookno1
#   ELSE
#      LET l_tic00 = l_bookno2
#   END IF
#   LET l_tic01 = YEAR(g_npp.npp02)             #年度
#   LET l_tic02 = MONTH(g_npp.npp02)            #期別  
#   LET l_tic03 = '' 
#   SELECT DISTINCT tic03 INTO l_tic03 FROM tic_file
#    WHERE tic00 = l_tic00
#      AND tic01 = l_tic01
#      AND tic02 = l_tic02
#      AND tic04 = g_npp.npp01
#   IF cl_null(l_tic03) THEN   
#      LET l_sum1 = ''
#      LET l_sum2 = ''
#      SELECT SUM(npq07f) INTO l_sum1 FROM npq_file,aag_file
#       WHERE npq03 = aag01 AND npq01 = g_npp.npp01
#         AND npqtype = g_npp.npptype AND aag00 = l_tic00
#         AND aag19 = '1'
#         AND npq06 = '1'
#      IF cl_null(l_sum1) THEN
#         LET l_sum1 = 0
#      END IF  
#      
#      SELECT SUM(npq07f) INTO l_sum2 FROM npq_file,aag_file
#       WHERE npq03 = aag01 AND npq01 = g_npp.npp01
#         AND npqtype = g_npp.npptype AND aag00 = l_tic00  
#         AND aag19 = '1'
#         AND npq06 = '2'
#      IF cl_null(l_sum2) THEN
#         LET l_sum2 = 0
#      END IF 
#   
#      IF l_sum1 > l_sum2 THEN
#         LET l_tic03 = '2'
#      ELSE
#         LET l_tic03 = '1'
#      END IF
#      
#      IF g_argv7 NOT matches '[YyXx]' THEN
#         LET l_sql = "SELECT npq02,npq25,aag371,npq37,npq07f,npq07 FROM npq_file,aag_file ",
#                     " WHERE npq03 = aag01 AND aag19 = '1' ",
#                     "   AND npq01 = '",g_npp.npp01,"'",
#                     "   AND aag00 = '",l_tic00,"'",
#                     "   AND npqtype = '",g_npp.npptype,"'",
#                     "   AND npq06 <> '",l_tic03,"'",
#                     " ORDER BY npq07 DESC"
#         PREPARE s_fsgl_flows_pre1 FROM l_sql       
#         DECLARE s_fsgl_flows_cur1 CURSOR FOR s_fsgl_flows_pre1
#   
#         LET l_sql = "SELECT npq01,npq02,aag41,'',npq07f,npq07 FROM npq_file,aag_file ",
#                     " WHERE npq03 = aag01 AND aag19 <> '1' ",
#                     "   AND npq01 = '",g_npp.npp01,"'",
#                     "   AND aag00 = '",l_tic00,"'",
#                     "   AND npq06 = '",l_tic03,"'",
#                     "   AND npqtype = '",g_npp.npptype,"'",
#                     " ORDER BY npq07 DESC "
#         PREPARE s_fsgl_flows_pre2 FROM l_sql
#         DECLARE s_fsgl_flows_cur2 CURSOR FOR s_fsgl_flows_pre2 
#         LET t = 1
#         LET i = 1
#         CALL g_tic.clear()
#         CALL g_tic_npq.clear()
#         BEGIN WORK
#         LET l_success = 'Y'
#         LET l_npq06 = ''
#         FOREACH s_fsgl_flows_cur1 INTO g_tic_npq[t].*
#            IF STATUS THEN
#               CALL cl_err('foreach npq1',STATUS,0)
#               LET l_success = 'N'          
#               EXIT FOREACH
#            END IF 
#            IF cl_null(g_tic_npq[t].npq07) THEN 
#               LET g_tic_npq[t].npq07 = 0 
#            END IF
#            IF t = 1 THEN
#               LET i = 1
#               FOREACH s_fsgl_flows_cur2 INTO g_tic[i].* 
#                  IF STATUS THEN
#                     CALL cl_err('foreach s_fsgl_flows_cur2',STATUS,2)
#                     LET l_success = 'N'
#                     EXIT FOREACH
#                  END IF
#                  IF cl_null(g_tic[i].tic07) THEN 
#                     LET g_tic[i].tic07 = 0 
#                  END IF          
#                  IF NOT cl_null(g_tic_npq[t].npq25) AND g_tic_npq[t].npq25 > 0 THEN
#                     LET g_tic[i].tic07f = g_tic[i].tic07/g_tic_npq[t].npq25
#                     LET g_tic[i].tic07f = cl_digcut(g_tic[i].tic07f,g_azi04)   
#                  END IF 
#                  LET i = i + 1 
#               END FOREACH
#            END IF
#            
#            FOR j = 1 TO i - 1 
#                IF g_tic_npq[t].npq07 = 0 OR g_tic[j].tic07 = 0 THEN
#                   CONTINUE FOR
#                END IF
#                IF NOT cl_null(g_tic_npq[t].aag371) THEN
#                   LET g_tic[j].tic08 = g_tic_npq[t].npq37
#                END IF
#                IF cl_null(g_tic[j].tic06) THEN             
#                   LET g_tic[j].tic06 = ' '
#                END IF
#                IF cl_null(g_tic[j].tic08) THEN             
#                   LET g_tic[j].tic08 = ' '
#                END IF
#                
#                IF g_tic[j].tic07 > g_tic_npq[t].npq07 THEN 
#                   INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08)
#                    VALUES (l_tic00,l_tic01,l_tic02,l_tic03,g_npp.npp01,g_tic_npq[t].npq02,
#                            g_tic[j].tic06,g_tic_npq[t].npq07,g_tic_npq[t].npq07f,g_tic[j].tic08)
#                   IF SQLCA.sqlcode THEN
#                      CALL cl_err3("ins","tic_file",g_npp.npp00,g_npp.npp01,SQLCA.sqlcode,"","ins tic",1)
#                      LET l_success = 'N'
#                      EXIT FOREACH
#                   END IF                
#                   LET g_tic[j].tic07 = g_tic[j].tic07 - g_tic_npq[t].npq07 
#                   LET g_tic[j].tic07f = g_tic[j].tic07f - g_tic_npq[t].npq07f
#                   EXIT FOR    
#                ELSE
#                   IF j > 1 THEN 
#                      IF l_npq02 = g_tic_npq[t].npq02 AND g_tic[j].tic06 = g_tic[j-1].tic06 
#                         AND g_tic[j].tic08 = g_tic[j-1].tic08 THEN
#                         UPDATE tic_file SET tic07 = tic07 + g_tic[j].tic07,tic07f = tic07f + g_tic[j].tic07f
#                          WHERE tic00 = l_tic00  AND tic01 = l_tic01
#                            AND tic02 = l_tic02  AND tic04 = g_npp.npp01
#                            AND tic05 = g_tic_npq[t].npq02
#                            AND tic06 = g_tic[j].tic06
#                            AND tic08 = g_tic[j].tic08 
#                         IF SQLCA.sqlcode THEN
#                            CALL cl_err3("upd","tic_file",g_npp.npp00,g_npp.npp01,SQLCA.sqlcode,"","upd tic",1)
#                            LET l_success = 'N'
#                            EXIT FOREACH
#                         END IF    
#                      ELSE
#                         INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08)
#                         VALUES (l_tic00,l_tic01,l_tic02,l_tic03,g_npp.npp01,g_tic_npq[t].npq02,
#                                 g_tic[j].tic06,g_tic[j].tic07,g_tic[j].tic07f,g_tic[j].tic08)
#                         IF SQLCA.sqlcode THEN
#                            CALL cl_err3("ins","tic_file",g_npp.npp00,g_npp.npp01,SQLCA.sqlcode,"","ins tic",1)
#                            LET l_success = 'N'
#                            EXIT FOREACH
#                         END IF 
#                      END IF     
#                   ELSE 
#                      INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08)
#                      VALUES (l_tic00,l_tic01,l_tic02,l_tic03,g_npp.npp01,g_tic_npq[t].npq02,
#                              g_tic[j].tic06,g_tic[j].tic07,g_tic[j].tic07f,g_tic[j].tic08)
#                      IF SQLCA.sqlcode THEN
#                         CALL cl_err3("ins","tic_file",g_npp.npp00,g_npp.npp01,SQLCA.sqlcode,"","ins tic",1)
#                         LET l_success = 'N'
#                         EXIT FOREACH
#                      END IF 
#                   END IF          
#                   LET g_tic_npq[t].npq07 = g_tic_npq[t].npq07 - g_tic[j].tic07 
#                   LET g_tic_npq[t].npq07f = g_tic_npq[t].npq07f - g_tic[j].tic07f
#                   LET g_tic[j].tic07 = 0
#                   LET g_tic[j].tic07f = 0
#                   LET l_npq02 = g_tic_npq[t].npq02                
#                END IF   
#            END FOR
#            LET t = t + 1
#         END FOREACH 
#         IF l_success = 'N' THEN
#            RETURN
#            ROLLBACK WORK
#         ELSE
#            COMMIT WORK
#         END IF   
#      END IF  
#   END IF
#   DISPLAY l_tic00,l_tic01,l_tic02,l_tic03 TO tic00,tic01,tic02,tic03   
#
#   DECLARE s_fsgl_flows_c CURSOR FOR
#    SELECT tic04,tic05,tic06,tic08,tic07f,tic07
#      FROM tic_file 
#     WHERE tic00 = l_tic00
#       AND tic01 = l_tic01
#       AND tic02 = l_tic02
#       AND tic04 = g_npp.npp01
#     ORDER BY tic04
#
#   CALL g_tic.clear()
#
#   LET i=1
#   LET l_rec_b=0
#   FOREACH s_fsgl_flows_c INTO g_tic[i].*
#      IF STATUS THEN
#         CALL cl_err('foreach tic',STATUS,0)
#         EXIT FOREACH
#      END IF
#      
#      LET i = i + 1
#   END FOREACH
#   CALL g_tic.deleteElement(i)
#   LET l_rec_b = i - 1
#
#   #IF l_n < 1 AND l_rec_b = 0 THEN  
#   IF (l_n < 1 AND l_rec_b = 0) OR g_argv7 matches '[YyXx]' THEN
#      DISPLAY ARRAY g_tic TO s_tic.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE DISPLAY
#
#         ON ACTION about
#            CALL cl_about()
#
#         ON ACTION help
#            CALL cl_show_help()
#
#         ON ACTION controlg
#            CALL cl_cmdask()
#
#         ON ACTION exit
#            EXIT DISPLAY
#      END DISPLAY
#      CLOSE WINDOW s_fsgl_f
#      RETURN
#   END IF
#
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
#   LET i = 1
#   INPUT ARRAY g_tic WITHOUT DEFAULTS FROM s_tic.*
#         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#             INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,APPEND ROW = l_allow_insert)
#
#      BEFORE INPUT
#          IF l_rec_b != 0 THEN
#             CALL fgl_set_arr_curr(i)
#          END IF
#
#      BEFORE ROW
#         LET i = ARR_CURR()
#         IF l_rec_b >= i THEN
#            LET p_cmd='u'
#            LET g_tic_t.* = g_tic[i].*                                                                                             
#            BEGIN WORK                                                                                                               
#            CALL cl_show_fld_cont()
#         END IF 
#
#      BEFORE INSERT 
#         LET p_cmd='a'
#         INITIALIZE g_tic[i].*  TO NULL 
#         LET g_tic_t.* = g_tic[i].*
#         LET g_tic[i].tic04 = g_npp.npp01 
#         CALL cl_show_fld_cont()
#         NEXT FIELD tic05   
#
#      AFTER FIELD tic05
#         IF NOT cl_null(g_tic[i].tic05) THEN
#            IF p_cmd='a' OR (p_cmd='u' AND g_tic[i].tic05<>g_tic_t.tic05) THEN
#               LET l_n = 0
#               SELECT COUNT(*) INTO l_n  FROM npq_file,aag_file
#                WHERE npq03 = aag01 AND npq01 = g_npp.npp01
#                  AND npqtype = g_npp.npptype AND aag19 = '1'
#                  AND npq02 = g_tic[i].tic05
#                  AND aag00 = l_tic00
#               IF l_n < 1 THEN                  
#                  CALL cl_err(g_tic[i].tic05,'aec-040',0)
#                  LET g_tic[i].tic05 = g_tic_t.tic05
#                  DISPLAY BY NAME g_tic[i].tic05
#                  NEXT FIELD tic05 
#               END IF
#            END IF
#            IF p_cmd='a' AND cl_null(g_tic_t.tic07) THEN
#               SELECT SUM(tic07f) INTO l_sum1 FROM tic_file
#                WHERE tic00 = l_tic00
#                  AND tic01 = l_tic01
#                  AND tic02 = l_tic02
#                  AND tic04 = g_npp.npp01
#                  AND tic05 = g_tic[i].tic05
#               IF cl_null(l_sum1) THEN
#                  LET l_sum1 = 0
#               END IF
#               
#               SELECT npq07f,npq25 INTO l_sum2,l_npq25 FROM npq_file
#                WHERE npq01 = g_npp.npp01
#                  AND npq02 = g_tic[i].tic05
#                  AND npqtype = g_npp.npptype
#               IF cl_null(l_sum2) THEN
#                  LET l_sum2 = 0
#               END IF
#                         
#               IF l_sum2 >= l_sum1 THEN
#                  LET g_tic[i].tic07f = l_sum2 - l_sum1
#                  IF cl_null(l_npq25) THEN
#                     LET g_tic[i].tic07 = g_tic[i].tic07f
#                  ELSE
#                     LET g_tic[i].tic07 = g_tic[i].tic07f * l_npq25
#                  END IF
#               ELSE
#                  LET g_tic[i].tic07 = 0
#                  LET g_tic[i].tic07f = 0
#               END IF
#            END IF         
#         END IF        
#
#      AFTER FIELD tic06
#         IF NOT cl_null(g_tic[i].tic06)  THEN
#            IF p_cmd='a' OR (p_cmd='u' AND g_tic[i].tic06<>g_tic_t.tic06) THEN
#               LET l_n = 0
#               SELECT COUNT(*) INTO l_n  FROM nml_file
#                WHERE nmlacti = 'Y'
#                  AND nml01 = g_tic[i].tic06
#               IF l_n < 1 THEN
#                  CALL cl_err(g_tic[i].tic06,'anm-140',0)
#                  LET g_tic[i].tic06 = g_tic_t.tic06
#                  DISPLAY BY NAME g_tic[i].tic06
#                  NEXT FIELD tic06
#               END IF
#            END IF
#         ELSE
#            IF p_cmd='u' AND g_tic[i].tic06 = ' ' THEN
#               CALL cl_err(g_tic[i].tic06,'aim-927',0)
#               NEXT FIELD tic06
#            END IF
#         END IF
#
#      AFTER FIELD tic07
#         IF NOT cl_null(g_tic[i].tic07) AND NOT cl_null(g_tic[i].tic05) THEN  
#            LET l_sum1 = 0
#            LET l_sum2 = 0
#            SELECT SUM(tic07) INTO l_sum1 FROM tic_file
#             WHERE tic00 = l_tic00
#               AND tic01 = l_tic01
#               AND tic02 = l_tic02
#               AND tic04 = g_npp.npp01
#               AND tic05 = g_tic[i].tic05
#            IF cl_null(l_sum1) THEN
#               LET l_sum1 = 0
#            END IF
#            IF cl_null(g_tic_t.tic07) THEN
#               LET g_tic_t.tic07 = 0
#            END IF         
#            LET l_sum1 = l_sum1 + g_tic[i].tic07 - g_tic_t.tic07
#            SELECT SUM(npq07) INTO l_sum2 FROM npq_file
#             WHERE npq01 = g_npp.npp01
#               AND npq02 = g_tic[i].tic05
#               AND npqtype = g_npp.npptype
#            IF l_sum2 < l_sum1 THEN
#               CALL cl_err(l_tic05,'anm-607',0)
#               NEXT FIELD tic07
#            END IF  
#         END IF 
#         
#      AFTER FIELD tic07f
#        IF NOT cl_null(g_tic[i].tic07f) THEN           
#           LET l_npq25 = ''
#           SELECT npq25 INTO l_npq25
#           FROM npq_file
#          WHERE npq01 = g_tic[i].tic04
#            AND npq02 = g_tic[i].tic05
#            AND npq00 = g_npp.npp00
#            AND npqtype = g_npp.npptype
#            AND npqsys = g_npp.nppsys
#            AND npq011 = g_npp.npp011
#           IF NOT cl_null(l_npq25) THEN   
#              LET g_tic[i].tic07 = g_tic[i].tic07f * l_npq25
#              LET g_tic[i].tic07 = cl_digcut(g_tic[i].tic07,g_azi04)   
#              DISPLAY BY NAME g_tic[i].tic07
#           END IF  
#           IF NOT cl_null(g_tic[i].tic05) THEN
#              LET l_sum1 = 0
#              LET l_sum2 = 0
#              SELECT SUM(tic07f) INTO l_sum1 FROM tic_file
#               WHERE tic00 = l_tic00
#                 AND tic01 = l_tic01
#                 AND tic02 = l_tic02
#                 AND tic04 = g_npp.npp01
#                 AND tic05 = g_tic[i].tic05
#              IF cl_null(l_sum1) THEN
#                 LET l_sum1 = 0
#              END IF
#              IF cl_null(g_tic_t.tic07f) THEN
#                 LET g_tic_t.tic07f = 0
#              END IF
#              LET l_sum1 = l_sum1 + g_tic[i].tic07f - g_tic_t.tic07f
#              SELECT SUM(npq07f) INTO l_sum2 FROM npq_file
#               WHERE npq01 = g_npp.npp01
#                 AND npq02 = g_tic[i].tic05
#                 AND npqtype = g_npp.npptype
#              IF l_sum2 < l_sum1 THEN
#                 CALL cl_err(l_tic05,'anm-606',0)
#                 NEXT FIELD tic07f
#              END IF
#           END IF
#        END IF
#
#      BEFORE FIELD tic08
#         LET l_npq03 = ''
#         SELECT npq03 INTO l_npq03
#           FROM npq_file
#          WHERE npq01 = g_tic[i].tic04
#            AND npq02 = g_tic[i].tic05
#            AND npq00 = g_npp.npp00
#            AND npqtype = g_npp.npptype
#            AND npqsys = g_npp.nppsys
#            AND npq011 = g_npp.npp011
#
#      AFTER FIELD tic08
#         IF NOT cl_null(l_npq03) THEN            
#            CALL s_chk_aee(l_npq03,'99',g_tic[i].tic08,g_bookno33)  
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err('sel aee:',g_errno,1)
#               NEXT FIELD tic08
#            END IF
#         END IF    
#
#      BEFORE DELETE
#         IF NOT cl_null(g_tic_t.tic04) THEN
#            IF NOT cl_delb(0,0) THEN
#               CANCEL DELETE
#            END IF   
#            IF cl_null(g_tic[i].tic08) THEN
#               LET g_tic[i].tic08 = ' '
#            END IF
#            DELETE FROM tic_file 
#             WHERE tic00 = l_tic00
#               AND tic01 = l_tic01
#               AND tic02 = l_tic02
#               AND tic04 = g_tic_t.tic04
#               AND tic05 = g_tic_t.tic05
#               AND tic06 = g_tic_t.tic06
#               AND tic08 = g_tic_t.tic08                                                                    
#            IF SQLCA.sqlcode THEN                                                             
#               CALL cl_err3("del","tic_file",'',"",SQLCA.sqlcode ,"","",1)                                                       
#               ROLLBACK WORK
#               CANCEL DELETE
#            END IF
#            LET l_rec_b = l_rec_b - 1  
#         END IF                                                                                                                
#    
#      ON ROW CHANGE
#         IF INT_FLAG THEN
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            LET g_tic[i].* = g_tic_t.*
#            ROLLBACK WORK
#            EXIT INPUT
#         END IF
#         IF cl_null(g_tic[i].tic08) THEN
#            LET g_tic[i].tic08 = ' '
#         END IF
#         UPDATE tic_file SET tic06 = g_tic[i].tic06,
#                             tic07 = g_tic[i].tic07,
#                             tic07f = g_tic[i].tic07f,    
#                             tic08 = g_tic[i].tic08      
#          WHERE tic00 = l_tic00
#            AND tic01 = l_tic01
#            AND tic02 = l_tic02
#            AND tic04 = g_tic_t.tic04
#            AND tic05 = g_tic_t.tic05
#            AND tic06 = g_tic_t.tic06
#            AND tic08 = g_tic_t.tic08
#         IF SQLCA.sqlcode THEN
#            CALL cl_err("upd tic_file",SQLCA.sqlcode,1)
#            LET g_tic[i].* = g_tic_t.*
#            ROLLBACK WORK
#         END IF
#         
#      AFTER INSERT                                                                                                                   
#         IF INT_FLAG THEN                                                                                                            
#            CALL cl_err('',9001,0)                                                                                                   
#            LET INT_FLAG = 0                                                                                                       
#            CANCEL INSERT                                                                                                            
#          END IF 
#          IF cl_null(g_tic[i].tic08) THEN
#             LET g_tic[i].tic08 = ' '
#          END IF
#          INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08) 
#          VALUES(l_tic00,l_tic01,l_tic02,l_tic03,g_tic[i].tic04,g_tic[i].tic05,
#                 g_tic[i].tic06,g_tic[i].tic07,g_tic[i].tic07f,g_tic[i].tic08)
#          IF SQLCA.sqlcode THEN                                                                                                      
#             CALL cl_err3("ins","tic_file",g_tic[i].tic05,"",SQLCA.sqlcode,"","",1)                                                  
#             CANCEL INSERT                                                                                                         
#          ELSE
#             LET l_rec_b = l_rec_b + 1 
#          END IF   
#
#      AFTER ROW
#         LET i = ARR_CURR()
#         IF INT_FLAG THEN
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            LET g_tic[i].* = g_tic_t.*
#            ROLLBACK WORK
#            EXIT INPUT
#         END IF         
# 
#      AFTER INPUT
#         FOR j = 1 TO l_rec_b
#            IF cl_null(g_tic[j].tic06) OR g_tic[j].tic06 = ' ' THEN
#               LET i = j
#               CALL cl_err(g_tic[j].tic06,'aim-927',0)
#               CALL fgl_set_arr_curr(i) 
#               NEXT FIELD tic06
#            END IF   
#         END FOR
#         COMMIT WORK
#
#      ON ACTION controlp
#         CASE 
#            WHEN INFIELD(tic06)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_nml"
#               CALL cl_create_qry() RETURNING g_tic[i].tic06
#               DISPLAY BY NAME g_tic[i].tic06
#               NEXT FIELD tic06
#            WHEN INFIELD(tic08)    #關係人
#               CALL s_ahe_qry(l_npq03,'99','i',g_tic[i].tic08,g_bookno33)
#               RETURNING g_tic[i].tic08
#               DISPLAY g_tic[i].tic08 TO tic08
#               NEXT FIELD tic08   
#         END CASE
#         
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#      ON ACTION about        
#         CALL cl_about()    
#
#      ON ACTION help         
#         CALL cl_show_help()  
#
#      ON ACTION controlg     
#         CALL cl_cmdask()    
#   END INPUT
#
#   IF INT_FLAG THEN
#      CALL cl_err('',9001,0)
#      LET INT_FLAG = 0
#      CLOSE WINDOW s_fsgl_f
#      RETURN
#   END IF
#   
#   CLOSE WINDOW s_fsgl_f
#   RETURN 
#END FUNCTION
##FUN-B40056--add--end-- 
#No.TQC-B70021 --end

#No.yinhy130922  --Begin
FUNCTION s_fsgl_ins_tic()
   DEFINE l_tic00   LIKE tic_file.tic00   #帳套
   DEFINE l_tic01   LIKE tic_file.tic01   #年度
   DEFINE l_tic02   LIKE tic_file.tic02   #期別
   DEFINE l_tic03   LIKE tic_file.tic03   #借貸別
   DEFINE l_n,t,i,j           LIKE type_file.num5
   DEFINE g_success           LIKE type_file.chr1  
   DEFINE l_rec_b             LIKE type_file.num5 
   DEFINE l_allow_insert      LIKE type_file.num5
   DEFINE l_allow_delete      LIKE type_file.num5 
   DEFINE p_cmd               LIKE type_file.chr1 
   DEFINE l_sum1,l_sum2       LIKE abb_file.abb07
   DEFINE l_sum3,l_sum4       LIKE abb_file.abb07f 
   DEFINE l_sql               STRING 
   DEFINE l_sql1              STRING 
   DEFINE l_sql2              STRING
   DEFINE l_npq06             LIKE npq_file.npq06
   DEFINE l_npq02             LIKE npq_file.npq02
   DEFINE l_tic05             LIKE tic_file.tic05
   DEFINE l_npq03             LIKE npq_file.npq03
   DEFINE l_npq25             LIKE npq_file.npq25 
   DEFINE l_aag371            LIKE aag_file.aag371
   DEFINE l_bookno1           LIKE aza_file.aza81   
   DEFINE l_bookno2           LIKE aza_file.aza82   
   DEFINE l_flag1             LIKE type_file.chr1 
   DEFINE l_sql3              STRING              
   DEFINE l_tic07             LIKE tic_file.tic07 
   DEFINE l_tic07f            LIKE tic_file.tic07f
   DEFINE l_ct                LIKE type_file.num5 
   DEFINE l_npq24             LIKE npq_file.npq24 
   DEFINE l_sum5              LIKE abb_file.abb07
   DEFINE l_sum6              LIKE abb_file.abb07f
   DEFINE l_sum7              LIKE abb_file.abb07
   DEFINE l_sum8              LIKE abb_file.abb07f
   DEFINE l_k                 LIKE type_file.num5 
   DEFINE l_flag              LIKE type_file.chr1 
   
   
   DELETE FROM tic_file WHERE tic00 = g_bookno33
      AND tic04 = g_npp.npp01
        
   LET l_tic00 = g_bookno33  
   LET l_tic01 = YEAR(g_npp.npp02)             #年度
   LET l_tic02 = MONTH(g_npp.npp02)            #期別  
   LET l_tic03 = '' 
        
   LET l_sum1 = ''
   LET l_sum2 = ''
   LET l_sum3 = ''
   LET l_sum4 = ''        

   SELECT SUM(npq07),SUM(npq07f) INTO l_sum1,l_sum3 FROM npq_file,aag_file
    WHERE npq03 = aag01 
      AND npq01 = p_no            
      AND npqtype = p_npptype 
      AND aag00 = l_tic00
      AND aag19 = '1'
      AND npq06 = '1'
   
   SELECT SUM(npq07),SUM(npq07f) INTO l_sum2,l_sum4 FROM npq_file,aag_file 
    WHERE npq03 = aag01 
      AND npq01 = p_no            
      AND npqtype = p_npptype 
      AND aag00 = l_tic00  
      AND aag19 = '1'
      AND npq06 = '2' 
   IF cl_null(l_sum1) THEN
      LET l_sum1 = 0
   END IF  
   
   IF cl_null(l_sum2) THEN
      LET l_sum2 = 0
   END IF 
   
   IF l_sum1 > l_sum2 THEN
      LET l_tic03 = '2'
   ELSE
      LET l_tic03 = '1'
   END IF

   IF l_sum1 = 0  THEN 
       LET l_tic03 = '1'
   END IF 
   IF l_sum2 = 0  THEN 
       LET l_tic03 = '2'
   END IF 

   #需要把少的那方的现金科目总金额在多的一方扣除

   IF cl_null(l_sum3) THEN
      LET l_sum3 = 0
   END IF  
   IF cl_null(l_sum4) THEN
      LET l_sum4 = 0
   END IF  
  
   LET l_sum5 = 0 
   LET l_sum6 = 0 
   LET l_sum7 = 0
   LET l_sum8 = 0
   IF l_tic03 ='1' THEN
   	  LET l_sum5 = l_sum1
   	  LET l_sum6 = l_sum3
   ELSE
      LET l_sum5 = l_sum2
      LET l_sum6 = l_sum4
   END IF
   LET l_sum7 = l_sum5 
   LET l_sum8 = l_sum6 
   LET t = 1
   LET i = 1
   CALL g_tic.clear()
   CALL g_tic_flows.clear()
   LET l_npq06 = ''


   LET l_sql1 = "SELECT npq02,npq25,aag371,npq37,npq07f,npq07 FROM npq_file,aag_file ",
               " WHERE npq03 = aag01 AND aag19 = '1' ",
               "   AND npq01 = '",g_npp.npp01,"'",
               "   AND aag00 = '",l_tic00,"'",
               "   AND npqtype = '",g_npp.npptype,"'",                        
               "   AND npq06 <> '",l_tic03,"'",
               " ORDER BY npq07 DESC"            
  LET l_sql2 = "SELECT npq01,npq02,aag41,'',npq07f,npq07,npq24 ",
             "  FROM npq_file,aag_file ",
             " WHERE npq03 = aag01 AND aag19 <> '1' ",
             "   AND npq01 = '",g_npp.npp01,"'",
             "   AND aag00 = '",l_tic00,"'",
             "   AND npq06 = '",l_tic03,"'",
             "   AND npqtype = '",g_npp.npptype,"'",                        
             " ORDER BY npq07 DESC " 
   PREPARE s_fsgl_flows_pre1 FROM l_sql1       
   DECLARE s_fsgl_flows_cur1 CURSOR FOR s_fsgl_flows_pre1
  
   PREPARE s_fsgl_flows_pre2 FROM l_sql2
   DECLARE s_fsgl_flows_cur2 CURSOR FOR s_fsgl_flows_pre2

   FOREACH s_fsgl_flows_cur1 INTO g_tic_flows[t].*
      IF STATUS THEN
         CALL cl_err('foreach npq1',STATUS,0)
         LET g_success = 'N'          
         EXIT FOREACH
      END IF 
      IF cl_null(g_tic_flows[t].npq07) THEN 
         LET g_tic_flows[t].npq07 = 0 
      END IF
      IF l_sum5 > g_tic_flows[t].npq07 THEN
         LET l_sum5 = l_sum5 - g_tic_flows[t].npq07
         LET g_tic_flows[t].npq07 = 0 
      ELSE
         LET g_tic_flows[t].npq07 = g_tic_flows[t].npq07 - l_sum5
         LET l_sum5 = 0 
      END IF
      IF l_sum6 > g_tic_flows[t].npq07f THEN
         LET l_sum6 = l_sum6 - g_tic_flows[t].npq07f
         LET g_tic_flows[t].npq07f = 0 
      ELSE
         LET g_tic_flows[t].npq07f = g_tic_flows[t].npq07f - l_sum6
         LET l_sum6 = 0 
      END IF
      IF t = 1 THEN
         LET i = 1
         FOREACH s_fsgl_flows_cur2 INTO g_tic[i].*,l_npq24 
            IF STATUS THEN
               CALL cl_err('foreach s_fsgl_flows_cur2',STATUS,2)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            IF cl_null(g_tic[i].tic07) THEN 
               LET g_tic[i].tic07 = 0 
            END IF          
            IF NOT cl_null(g_tic_flows[t].npq25) AND g_tic_flows[t].npq25 > 0 THEN

               SELECT azi04 INTO t_azi04
                 FROM azi_file
                WHERE azi01 = l_npq24
 
               LET g_tic[i].tic07f = g_tic[i].tic07/g_tic_flows[t].npq25
               LET g_tic[i].tic07f = cl_digcut(g_tic[i].tic07f,t_azi04)
            END IF 
            LET i = i + 1 
         END FOREACH
      END IF
      
      FOR j = 1 TO i - 1 
          IF g_tic_flows[t].npq07 = 0 OR g_tic[j].tic07 = 0 THEN
             CONTINUE FOR
          END IF
          IF NOT cl_null(g_tic_flows[t].aag371) THEN
             LET g_tic[j].tic08 = g_tic_flows[t].npq37
          END IF
          IF cl_null(g_tic[j].tic06) THEN             
             LET g_tic[j].tic06 = ' '
          END IF
          IF cl_null(g_tic[j].tic08) THEN             
             LET g_tic[j].tic08 = ' '
          END IF
          
          IF g_tic[j].tic07 > g_tic_flows[t].npq07 THEN 
             IF j > 1 THEN 
                INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)  
                 VALUES (l_tic00,l_tic01,l_tic02,l_tic03,g_npp.npp01,g_tic_flows[t].npq02,
                         g_tic[j].tic06,g_tic_flows[t].npq07,g_tic_flows[t].npq07f,g_tic[j].tic08,'3')
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","tic_file","",g_npp.npp01,SQLCA.sqlcode,"","ins tic",1)
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF    
             ELSE 
                INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)
                 VALUES (l_tic00,l_tic01,l_tic02,l_tic03,g_npp.npp01,g_tic_flows[t].npq02,
                         g_tic[j].tic06,g_tic_flows[t].npq07,g_tic_flows[t].npq07f,g_tic[j].tic08,'3')
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","tic_file","",g_npp.npp01,SQLCA.sqlcode,"","ins tic",1)
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF                
             END IF 
             LET g_tic[j].tic07 = g_tic[j].tic07 - g_tic_flows[t].npq07 
             LET g_tic[j].tic07f = g_tic[j].tic07f - g_tic_flows[t].npq07f 
          ELSE
             IF j > 1 THEN 
                INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)
                VALUES (l_tic00,l_tic01,l_tic02,l_tic03,g_npp.npp01,g_tic_flows[t].npq02,
                        g_tic[j].tic06,g_tic[j].tic07,g_tic[j].tic07f,g_tic[j].tic08,'3') 


                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","tic_file","",g_npp.npp01,SQLCA.sqlcode,"","ins tic",1)
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF    
             ELSE 
                INSERT INTO tic_file(tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,tic08,tic09)                         
                VALUES (l_tic00,l_tic01,l_tic02,l_tic03,g_npp.npp01,g_tic_flows[t].npq02,
                        g_tic[j].tic06,g_tic[j].tic07,g_tic[j].tic07f,g_tic[j].tic08,'3')

                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","tic_file","",g_npp.npp01,SQLCA.sqlcode,"","ins tic",1)
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF 
             END IF          
             LET g_tic_flows[t].npq07 = g_tic_flows[t].npq07 - g_tic[j].tic07 
             LET g_tic_flows[t].npq07f = g_tic_flows[t].npq07f - g_tic[j].tic07f
             LET g_tic[j].tic07 = 0
             LET g_tic[j].tic07f = 0
             LET l_npq02 = g_tic_flows[t].npq02                
          END IF   
      END FOR
      LET t = t + 1
   END FOREACH    
   
  
END FUNCTION
#No.yinhy130922  --End