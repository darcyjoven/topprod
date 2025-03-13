# Prog. Version..: '5.30.06-13.03.28(00008)'     #
#
# Pattern name...: aimi100.4gl
# Descriptions...: 料件基本資料建立
# Date & Author..: 91/04/11 By Lee
# MODIFY.........: 91/11/05 By Wu
#------MODIFICATIION-------MODIFICATION-------MODIFIACTION-------
# 1992/06/18 Lin.: 修改畫面上增加 [資料處理狀況](ima93) 的QBE查詢
# 1992/10/13 Lee.: 增加再補貨量的預設(ima99)
#------BugFIXED------------BugFIXED-----------BugFIXED-----------
# 1993/12/21 Apple:修改本程式時請同時考慮(aimi109)此程式
#------BugFIXED------------BugFIXED-----------BugFIXED-----------
# Modify.........: 95/08/14 By Danny (修改資料拋轉部份)
#   By Melody  來源碼'R'類取消, 新增'料件建立日期'欄位, MENU 加掛 2.銷售資料建立
#------MODIFICATION----------------------------------------------
# Modify.........: 01/04/   BY ANN CHEN
#                  1.取消功能:a.不存在認何單據中 b.庫存量不可為0
#                  2.作廢功能:b.庫存量不可為0 (img10 <> 0)
# Modify.........: No:7726 原ima35,ima36 default 成 ima35 = '  '(二個空白),改成ima35 = ' '(一二個空白)
# Modify.........: No:7822 03/08/18 By Mandy 資料拋轉 按^P查詢時 -> CALL q_azp 的display錯
# Modify.........: No:7643 03/08/25 By Mandy 新增 aimi100料號時應default ima30=料件建立日期,以便循環盤點機制
# Modify.........: No:7703 03/08/25 By Mandy 應該增加 imz24 檢驗否 之欄位於主分群碼中
# Modify.........: No:8400 03/10/02 By Melody 會計科目不可輸入統制帳戶
# Modify.........: No:A086 04/06/23 By Danny 增加自動編碼
# Modify.........: No:7062 04/07/08 By Mandy after field ima06 ，若為使用者自行轉入 ima_file，但未建立 imz_file時，
#                  此處之 after field 會判斷不出來。應加一段是否存在於 imz_file 之檢查。
#                  相同 after field ima09, ima10, ima11,ima12 亦會有此一問題
# Modify.........: No.MOD-480430 04/08/19 By Wiky 檢視工程圖 action拿掉
# Modify.........: No.MOD-480569 04/08/30 By Nicola 無法新增
# Modify.........: No.MOD-490065 04/09/02 By Smapmin SQL條件錯誤，將aag071改為aag07
# Modify.........: No.MOD-490054 04/09/13 By Nicola 使用主分群碼預設料件資料'Y',無法預設
# Modify.........: No.MOD-490474 04/10/04 By Mandy 修改主分群時才詢問是否以分群碼 default,不是每個欄位均詢問.
# Modify.........: No.MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0098 04/10/07 By Mandy 料作[經濟訂購量]顯示訊息不可小於0,但自動帶NULL
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0246 04/10/15 By Melody prompt出來的視窗應show中文(中文版)
# Modify.........: No.MOD-4A0326 04/10/27 By Mandy 加秀姓名於工號後方
# Modify.........: No.FUN-4B0001 04/11/01 By Smapmin 料件編號開窗,規格主件開窗
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0104 05/01/05 By alex 修改4js bug定義超長
# Modify.........: No.FUN-510017 05/01/17 By Mandy 報表轉XML
# Modify.........: No.MOD-520032 05/03/08 By ching fix aps_related_data priv
# Modify.........: No.MOD-530275 05/03/25 By Mandy Carray Data '新增'時,處理狀況不應一起Carray 應,全部回歸回N
# Modify.........: No.MOD-530367 05/03/30 By kim 按了ASP相關資料,no data時會有err msg
# Modify.........: No.FUN-540025 05/04/08 By Carrier 雙單位修改
# Modify.........: No.FUN-550021 05/05/11 By will 增加屬性群組
# Modify.........: No.FUN-550014 05/05/17 By Mandy 增加一欄位'主特性代碼'ima910
# Modify.........: No.FUN-550077 05/05/20 By alex 增加料件多語言記錄欄位
# Modify.........: No.FUN-550103 05/05/26 By Lifeng  增加料件多屬性控管機制
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560071 05/06/08 By Raymon 增加多語系控制功能
# Modify.........: No.MOD-530699 05/06/17 By kim i100_del函數移至sub/4gl/s_chkitmdel.4gl
# Modify.........: No.FUN-560112 05/06/18 By kim 新增料件時,無法更改庫存單位
# Modify.........: No.FUN-560119 05/06/20 By saki 料件編號長度限制
# Modify.........: No.FUN-560187 05/06/22 By kim 移除MRP匯總時距(天)
# Modify.........: No.FUN-560202 05/06/23 By kim 查詢時於品名欄位輸入條件,確認後程式就結束了
# Modify.........: No.MOD-560085 05/08/14 By kim 控管有工單時,不可修改其料件之生產單位
# Modify.........: No.MOD-570385 05/08/14 By kim 新增狀態時,不檢查庫存單位是否可修改
# Modify.........: No.MOD-580322 05/08/31 By wujie  中文資訊修改進 ze_file
# Modify.........: No.MOD-580179 05/09/05 By Rosayu 將料件單位換算資料維護移到Menu
# Modify.........: No.MOD-580344 05/09/14 By Rosayu 執行任一個功能按鈕後,狀態不會重新display到主畫面,必須案另一個功能鍵才會顯示
# Modify.........: No.MOD-590270 05/09/14 By Claire 執行"物料單位換算維護"功能按鈕後,沒有出現QBE畫面
# Modify.........: No.MOD-590441 05/09/24 By kim _r() 在 delete ima_file 成功後,call  xxx_fetch() 之後才 delete imc_file ind_file imb_file 會刪錯資料
# Modify.........: No.FUN-590113 05/09/28 By Lifeng 增加一個ACTION - add_multi_att_sub，它調用副程式saimi311(),允許在該作業中定義多屬性子料件
# Modify.........: No.MOD-5A0094 05/10/13 By Sarah "會計/其他狀況/其他分群"的標籤中,成本分群(ima12)欄位開窗選擇後,值沒有帶出來
# Modify.........: No.FUN-5A0081 05/10/20 By Sarah 在i100_x()增加判斷.如果ima26,ima261,ima262大於0則show出錯誤訊息,不可執行無效
# Modify.........: No.MOD-5A0223 05/10/21 By will  根據多數性參數來決定是否隱藏ACTION add_multi_att_sub
# Modify.........: No.TQC-5B0068 05/11/30 By Sarah 修改列印表尾時,(接下頁),(結束)的位置
# Modify.........: No.MOD-5B0336 05/12/09 By kim _x() 中少了RETURN
# Modify.........: No.FUN-610001 06/01/02 By Nicola 單位管制方式控管同庫存單位
# Modify.........: No.FUN-610065 06/01/16 By saki 自訂欄位值控管，接續FUN-520002
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.TQC-5C0079 06/02/09 By alex 修改多語言資料顯示部份
# Modify.........: No.FUN-610080 06/02/09 By Sarah 增加"重複性生產料件"欄位(ima911)
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-630041 06/03/13 By Claire imc_file 在carry_data(資料拋轉)時也要同步
# Modify.........: No.FUN-610013 06/03/23 By Tracy 加狀態碼ima1010
# Modify.........: No.FUN-640013 06/04/07 By Rayven 新增母料件完時若為多屬性料件顯示新增多屬性子料件按鈕
# Modify.........: NO.TQC-640045 06/04/07 BY yiting 參數分銷為N時，不CHECK是否可拋轉
# Modify.........: No.FUN-640010 06/04/08 By Tracy 增加分銷功能
# Modify.........: No.FUN-640067 06/04/08 By Ray 修改當asms112中的APS系統串連為ON時，按紐"APS相關資料"才可執行
# Modify.........: No.MOD-640072 06/04/08 By wujie 資料狀況右上角X沒有作用
# Modify.........: No.MOD-640061 06/04/09 By Nicola ima913預設為"N"
# Modify.........: No.MOD-640228 06/04/10 By Tracy 修改資料拋轉條件
# Modify.........: No.FUN-640043 06/04/12 By Nicola 料件編號不可為保留字
# Modify.........: No.FUN-640107 06/04/18 By pengu 料號存在於有效單據(訂單未結案、採購單未結案)等，應該不可進行「失效」設定
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.TQC-640171 06/04/28 By Rayven 修改若母料件狀態碼修改，子料件跟隨母料件修改
# Modify.........: No.FUN-640260 06/05/02 By kim 主分群碼帶出之 default 值若沒存在 base data 則系統最後跳開時沒check
# Modify.........: No.FUN-650004 06/05/03 By kim 輸完主分群碼帶出WIP倉和WIP儲位
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650066 06/05/16 By Claire ima79 mark
# Modify.........: No.MOD-650075 06/05/16 By Claire 語法錯誤
# Modify.........: No.TQC-650075 06/05/19 By Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify.........: No.FUN-620053 06/05/24 By kim 修改複製和拋轉功能
# Modify.........: No.FUN-650045 06/05/24 By kim 修改時,帶分群碼的預設值前須先檢查料件是否被使用
# Modify.........: No.FUN-660078 06/06/13 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: No.MOD-660050 06/06/13 By Claire 語法錯誤
# Modify.........: No.TQC-660102 06/06/20 By alexstar 切換語言時資料多語言沒跟著切換
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3
# Modify.........: NO.TQC-660041 06/06/26 By alexstar  刪除該料件資料時，相關圖片資料也跟著一起刪除
# Modify.........: NO.FUN-660193 06/07/01 By Joe 修正APS相關資料欄位
# Modify.........: NO.FUN-670013 06/07/05 By Joe 修正t傳給APS中max_lot值
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.MOD-680023 06/08/04 By day 拋轉資料 更新 資料庫失敗
# Modify.........: NO.FUN-680010 06/08/08 By Joe SPC整合專案-基本資料傳遞
# Modify.........: NO.FUN-680034 06/08/25 By Hellen 兩套帳功能修改
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690060 06/09/15 By Mandy 新增"料件申請作業"
# Modify.........: No.FUN-5A0027 06/09/18 By kim 做資料拋轉時，應先檢查欲轉入的營運中心之可開窗欄位，其值是否存在
# Modify.........: NO.TQC-690074 06/09/18 By kim 輸完分群碼,當選則否時,不做 i100_chk_rel()
# Modify.........: Mo.FUN-6A0061 06/10/24 By xumin g_no_ask改mi_no_ask
# Modify.........: No.FUN-6A0037 06/10/24 By rainy 新增action修改 採購/計劃/倉管人員
# Modify.........: NO.MOD-6A0155 06/10/31 By Claire 維護品名規格action僅在查詢狀態下才可以使用
# Modify.........: No.FUN-6A0074 06/11/01 By johnray l_time轉g_time
# Modify.........: No.CHI-6B0034 06/11/10 By alexstar 刪除該筆資料時，連帶刪除相關的多語言資料
# Modify.........: No.CHI-690082 06/12/06 By jamie 資料在拋轉更新前，需先檢查是否曾在欲拋轉資料庫中更動過過
# Modify.........: No.MOD-680064 06/12/06 By pengu run aimi100後開始的畫面第一筆、上筆、下筆、末一筆等action應為disable
# Modify.........: NO.TQC-680159 06/12/06 By Claire g_wc值被改變造成無法對同筆資料連續按二次列印
# Modify.........: No.TQC-6C0026 06/12/07 By Sarah 1.新增時輸入的分群碼若沒有庫存單位,會出現aim-702訊息,改成用window方式顯示
#                                                  2.當分群碼輸入值與舊值不同或舊值為NULL時,才開出mfg5033這個詢問視窗
# Modify.........: No.TQC-6C0024 06/12/08 By Sarah 複製時,需連相關其他語言別的品名/規格資料一起同時複製
# Modify.........: No.MOD-6C0042 06/12/08 By Sarah 新增時,若只輸入品名就按確定,,程式會當出
# Modify.........: No.CHI-6B0073 06/12/14 By kim 修改完主分群碼後的提示
# Modify.........: No.TQC-6C0159 06/12/26 By Mandy 取消確認後,狀態沒有變成0:開立
# Modify.........: No.TQC-6C0060 06/12/13 By alexstar 多語言功能單純化
# Modify.........: No.FUN-6C0006 07/01/03 By kim GP3.6 程式行業別模組化
#                                            (aimi100 = aimi100 + aimi100 + aimi100.global)
# Modify.........: No.FUN-710037 07/01/16 By kim GP3.6 add IC Design - aimi100icd
# Modify.........: No.TQC-710103 07/01/29 By alexstar 不回傳FALSE
# Modify.........: No.TQC-710032 07/01/30 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-720009 07/02/07 By kim 行業別架構變更
# Modify.........: No.FUN-720030 07/02/27 By kim SPC欄位變更
# Modify.........: No.FUN-730002 07/03/01 By kim 行業別架構變更
# Modify.........: No.TQC-720065 07/03/01 By Judy 資料審核仍可更改
# Modify.........: No.FUN-720043 07/03/02 By Mandy APS整合調整
# Modify.........: No.MOD-710026 07/03/05 By pengu 刪除料件資料時應聯smd_file一併刪除
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-730061 07/03/28 By kim 行業別架構
# Modify.........: No.MOD-740024 07/04/10 By Judy mark#TQC-720065
# Modify.........: No.TQC-740081 07/04/13 By Xufeng "安全存量","安全期間","最高存量","有效天數"能夠輸入負數，不合理
# Modify.........: No.MOD-740138 07/04/22 By kim 當預設製程料號(ima571)與料品編號相同時,不必檢查ima571
# Modify.........: No.TQC-740144 07/04/22 By dxfwo  修改資料已審核，仍然能無效
# Modify.........: No.CHI-740027 07/04/26 By Mandy 當aoos010設定為走料件申請流程時，aimi100應不可使用複製功能複製料號
# Modify.........: No.TQC-750013 07/05/04 By Mandy 當按下APS相關資料時(apsi204),最大批量數請帶'999999',而非'9999999'
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.FUN-710060 07/08/06 By jamie 1.增加欄位ima915"是否需做供應商的管制
#                                                  2.新增料件時依分群碼做default
# Modify.........: No.MOD-790164 07/09/28 By Pengu 在AFTER FIELD ima01時應判斷ima571為空白時才可做料件DEFAULT
# Modify.........: No.CHI-7A0009 07/10/04 By Carol 新料號無其他系統使用前[無效]碼可執行
# Modify.........: No.MOD-7A0018 07/10/11 By Carol action 顯示調整
# Modify.........: No.MOD-7A0134 07/10/23 By Carol 調整新增自動編碼品號後,品名自動編品名之視窗出現的邏輯判斷
# Modify.........: No.MOD-7B0057 07/11/07 By Pengu 拋轉資料庫時無法拋轉成功
# Modify.........: NO.MOD-7B0076 07/11/09 BY yiting 己產生BOM，不可取消確認
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7B0080 07/11/16 By saki 自定義欄位功能更動
# Modify.........: No.TQC-7C0003 07/12/03 By wujie aoos010未勾選使用“多帳套的功能”，所以在拋轉時，不應該判斷會計科目二
# Modify.........: No.MOD-7C0077 07/12/11 By Pengu 在Informix環境做資料拋轉時會出現異常
# Modify.........: No.FUN-7C0043 07/12/24 By Cockroach 報表改為p_query實現
# Modify.........: No.MOD-7C0221 07/12/28 By Pengu 執行資料拋轉其他資料庫後無法執行上下筆
# Modify.........: No.FUN-810038 08/01/15 By kim GP5.1 ICD ; aimi00.4gl->aimi100.src.4gl
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-7C0010 08/01/28 By Carrier 資料中心功能
# Modify.........: No.FUN-810016 08/01/29 By ve007 增加母料件字段，增加依訂單需求采購補貨策略
                                                  #增加材質成分說明功能
# Modify.........: No.FUN-7B0018 08/02/28 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: NO.FUN-7C0002 08/03/07 by Yiting apsi204-->apsi308.4gl
# Modify.........: NO.FUN-830087 08/03/21 #No.FUN-830121 by ve007 debug FUN-810016
# Modify.........: NO.CHI-830025 08/03/24 by kim GP5.1整和測試修改
# Modify.........: FUN-830090 08/03/26 By Carrier 修改s_aimi100_carry的參數
# Modify.........: NO.FUN-840018 08/04/07 BY yiting 增加一個頁面放置清單資料
# Modify.........: NO.FUN-840033 08/04/08 BY Yiting  aimp100->aimi100 直接開啟主畫面
# Modify.........: No.MOD-840174 08/04/20 By Nicola 自動編碼欄位entry設定
# Modify.........: No.MOD-840254 08/04/20 By Nicola 批/序號編碼開窗修改
# Modify.........: No.MOD-840257 08/04/20 By Nicola 批/序號編碼控管
# Modify.........: No.MOD-840294 08/04/21 By Nicola 批/序號編碼開窗修改
# Modify.........: No.FUN-840160 08/04/23 By Nicola 料件有庫存時，不可修改批/序號資料
# Modify.........: No.FUN-850115 08/05/20 By Duke add aps料件基本資料之 vmi_file.vmi57
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.CHI-840069 08/06/02 By Sherry 單位一致性處理
# Modify.........: NO.FUN-860036 08/06/17 by kim  MDM整合 for GP5.1
# Modify.........: No.FUN-860111 08/07/09 By sherry 增加變動前置時間批量（ima601)
# Modify.........: No.MOD-860039 08/07/09 By claire 排除aag07=1
# Modify.........: No.TQC-870001 08/07/09 By claire q_aag1->q_aag01
# Modify.........: No.FUN-870012 08/07/11 By Duke add vmi56 default 0
# Modify.........: No.FUN-870117 08/07/22 by ve007 未審核料件不可生成多屬性子料件
                                                  #已有多屬性子料件的母料件不可取消審核
# Modify.........: No.FUN-870028 08/07/31 By sherry MES整合
# Modify.........: No.FUN-870101 08/08/14 By jamie MES整合
# Modify.........: No.FUN-870166 08/09/02 By kevin MDM整合call aws_mdmdata
# Modify.........: No.MOD-890073 08/09/08 By claire page07(ima1015..)需以流通配銷參數控管
# Modify.........: No.CHI-880031 08/09/09 By xiaofeizhu 查出資料后,應該停在第一筆資料上,不必預設是看資料清單,有需要瀏覽,再行點選
# Modify.........: No.FUN-870150 08/09/09 By sherry 新增料號時, 將料號后面的空白trim掉(讓料號后不含空白)
# Modify.........: No.FUN-880032 08/09/18 By sherry 新增或復制時，若ima131為NULL, 則空白給值
# Modify.........: No.MOD-870225 07/12/22 By claire 新料號若單據還原後,應可選擇能否修改分群碼
# Modify.........: No.MOD-870230 08/09/26 By claire q_aag01->q_aag02
# Modify.........: No.FUN-8A0082 08/10/16 By duke change vmi49,vmi50 default value 5, 10
# Modify.........: No.FUN-890113 08/10/27 By kevin 移除MDM刪除功能
# Modify.........: No.MOD-8A0193 08/10/27 By claire 資料清單頁籤需要有基本功能action可使用
# Modify.........: No.TQC-8B0011 08/11/05 BY duke 呼叫MES前先判斷aza90必須MATCHE [Yy]
# Modify.........: No.FUN-8B0003 08/11/07 BY duke aimi100料號建立時,消耗後續製令之指定時間(天)(vmi16/vai16)及消耗後續採購令之指定時間(天)(vmi17/vai17)預設給999, 且vmi57預設值為1
# Modify.........: No.MOD-8B0162 08/11/17 By liuxqa 修正FUN-870117,錄入時，離開ima915后，錄入自動結束。
# Modify.........: No.TQC-910003 09/01/03 by duke move old aps table
# Modify.........: No.TQC-910034 09/01/15 By chenyu icd02需要加上,不然資料會有多筆
# Modify.........: No.MOD-910197 09/01/22 By Sarah 寫入azo_file的azo05時應寫入g_ima.ima01
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-910053 09/02/12 By jan 當分群碼有異動時，將imz153=>ima153
# Modify.........: No.FUN-920114 09/02/17 By ve007 ICD"光罩群組維護","ICD料件制程"兩個action 可以帶出相關資料
# Modify.........: No.FUN-920170 09/02/23 By ve007 imicd08的控管
# Modify.........: No.FUN-920172 09/02/26 By jan IF ica040='N',aimi100_icd的"ICD制程料號"的action 隱藏 
# Modify.........: No.FUN-930108 09/04/13 By zhaijie i100_a_inschk()中新增ima926為空的處理
# Modify.........: No.TQC-940110 09/04/20 By sherry 修改庫存單位，庫存資料、銷售資料、采購資料、生管資料里面的單位轉換率沒有更新
# Modify.........: No.MOD-940394 09/04/29 By lutingting回覆MOD-910197得調整,寫入azo_file的azo05寫入時改紀錄為rowid 
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-950007 09/05/12 By sabrina 跨主機資料拋轉，shell手工調整
# Modify.........: No.TQC-940178 09/05/14 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.MOD-940165 09/05/21 By Pengu 無效時應判斷是否有未結案工單，若有則不允許做無效
# Modify.........: No.MOD-940259 09/05/21 By Pengu 來源碼是P、V、Z時，則在修改來源碼時則判斷是否有存在P件BOM下
# Modify.........: No.FUN-960007 09/06/02 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.TQC-960014 09/07/08 By lilingyu 新增資料時,自定義欄位imaud05賦初值
# Modify.........: No.CHI-970023 09/07/10 By mike 請將i100_copy_default()中的LET l_ima.ima131 = ' '給MARK
# Modify.........: No.FUN-960141 09/07/24 By dongbg 增加代銷科目欄位
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870100 09/09/02 By Cockroach 給ima154,ima155賦初值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0022 09/10/09 By lilingyu 過單
# Modify.........: NO.FUN-990069 09/10/12 By baofei 增加子公司可新增資料的檢查
# Modify.........: No:TQC-9A0185 09/10/29 By lilingyu copy時,"缺省工藝料號"的值應該取當前單頭料號的值,而非要復制的那一筆資料的料號值
# Modify.........: No.FUN-980063 09/11/04 By jan ICD行業程式做相關調整
# Modify.........: No:MOD-9B0003 09/11/06 By Pengu 防呆控管庫存單位不可為空白
# Modify.........: No:MOD-9A0043 09/11/06 By Pengu 狀態選3.未測IC 或 4.已測IC時，不應該強制做刻號/BIN管理
# Modify.........: No:MOD-9B0066 09/11/11 By sabrina 作廢時在判斷後段單據是否存在時應排除作廢單據
# Modify.........: No.FUN-9B0081 09/11/12 By douzh i100_a_inschk()中新增ima926為空的處理
# Modify.........: No:MOD-9B0093 09/11/18 By Smapmin MISC料銷售特性要default為2
# Modify.........: No.FUN-9B0099 09/11/18 By douzh 给imz926默认值
# Modify.........: No:TQC-9B0126 09/11/18 By Carrier undo FUN-960014
# Modify.........: No:TQC-9B0072 09/11/17 By sherry 修改aimi1004畫面上的問題
# Modify.........: No:MOD-9C0361 09/12/23 By Pengu 調整批序號欄位的控管
# Modify.........: No:MOD-9C0032 09/12/23 By sabrina 如果變動前置時間批量(ima601)是null則給"1"，否則依imz601的值帶入 
# Modify.........: No.FUN-9C0109 09/12/24 By lutingting 代銷科目只有在業態為零售時才顯示
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No:MOD-A10083 10/01/20 By Smapmin CURSOR未正常釋放
# Modify.........: No:TQC-A20008 10/02/03 By lilingyu 開窗選擇拋磚的DB清單sql寫錯
# Modify.........: No:FUN-A20037 10/02/20 By lilingyu 功能改善:規格替代 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/25 By vealxu ima26x 調整
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No.FUN-AB0025 10/11/11 By chenying 修改料號開窗改為CALL q_sel_ima()
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80070 11/08/08 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-B80032 11/10/31 By nanbing ima_file 更新揮寫rtepos 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-CA0073 13/01/30 By pauline 將ima1015用ima1401替代
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aimi100.global"
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-7C0010

DEFINE g_argv2       STRING                  #NO.FUN-840033
DEFINE g_i1          LIKE type_file.num5     #No.FUN-870117
DEFINE g_icb02       LIKE icb_file.icb02     #No.FUN-920114
 
MAIN
DEFINE l_sma120      LIKE sma_file.sma120    #No.FUN-810016
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP     #,               #FUN-A20037 mark
     # FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730061  #FUN-A20037 mark
   DEFER INTERRUPT
 
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)   #no.FUN-840033 ADD

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time                  #No.FUN-6A0074
 
   LET g_forupd_sql = " SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE i100_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i100_w WITH FORM "aim/42f/aimi100" #FUN-6C0006
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL i100_init()
 
   IF g_azw.azw04 = '2' THEN
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_visible("ima149,ima1491",TRUE)
      ELSE
         CALL cl_set_comp_visible("ima149",TRUE)
      END IF
   ELSE
      CALL cl_set_comp_visible("ima149,ima1491",FALSE)
   END IF
   CALL cl_set_comp_visible("imaag",FALSE)    # No.FUN-810016
   IF NOT cl_null(g_argv1) THEN
      CALL i100_q()
   END IF
 
    SELECT sma120 INTO l_sma120 FROM sma_file
          CALL cl_set_act_visible("style_informate",FALSE)
       IF l_sma120="Y" THEN
          CALL cl_set_comp_visible("ima151",TRUE)
       ELSE
          CALL cl_set_comp_visible("ima151",FALSE)
       END IF
 
 
   LET g_action_choice = ""
   CALL i100_menu()
 
   CLOSE WINDOW i100_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0074
END MAIN
 
FUNCTION i100_curs()
DEFINE   l_ima151                LIKE ima_file.ima151               #No.FUN-810016
 
   CLEAR FORM
 
   IF cl_null(g_argv1) THEN
      INITIALIZE g_ima.* TO NULL    #FUN-640213 add
      CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima06,ima08,                #No.FUN-640013
                                ima13,ima05,ima140,ima03,ima1010,ima93,ima915, #FUN-710060 add ima915
                                ima916,                                        #No.FUN-7C0010
                                ima151,                                        #No.FUN-810016
                                imaag,  #No.FUN-640013
                                ima910,#FUN-550017 add ima910
                                ima105,ima14,ima107,ima147,ima109,ima903,
                                ima905,ima24,ima911,ima022,ima251,ima07,ima70,ima37,ima51,ima52,   #FUN-610080 加ima911  #FUN-A20037 add ima022,ima251
                                ima27,ima28,ima271,ima71,  #ima909, #FUN-540025 #FUN-560187
                                ima25,ima35,ima36,ima23,
                                ima918,ima919,ima920,ima921,ima922,ima923,ima924,ima925,  #No.FUN-810036
                                ima906,ima907,ima908, #FUN-540025
                                ima12,ima39,ima391,ima149,ima1491,ima15,ima146,ima16,ima09,  #FUN-680034 #FUN-960141
                                ima10,ima11,
                                ima1001,ima1002,ima1012,ima1013,#No.FUN-640010
                               #ima1015,ima1014,ima1016,#No.FUN-640010  #CHI-CA0073 mark 
                                ima1014,ima1016,#No.FUN-640010  #CHI-CA0073  add
#                               ima901,ima902,ima881,ima73,             #No.FUN-8C0131
                                ima901,ima902,ima9021,ima881,ima73,     #No.FUN-8C0131
                                ima74,ima29,ima30,
                                imaud01,imaud02,imaud03,imaud04,imaud05,
                                imaud06,imaud07,imaud08,imaud09,imaud10,
                                imaud11,imaud12,imaud13,imaud14,imaud15,
                                imauser,imagrup,imamodu,imadate,imaacti
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                AFTER FIELD ima151
                  LET l_ima151=GET_FLDBUF(ima151)
                  IF l_ima151="Y"   THEN
                  CALL cl_set_comp_visible("imaag",TRUE)
                  NEXT FIELD imaag
                  ELSE
                  CALL cl_set_comp_visible("imaag",FALSE)
                  END IF
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01) #料件編號    #FUN-4B0001
#FUN-AB0025---------mod---------------str----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_ima"
#                 LET g_qryparam.state    = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AB0025--------mod---------------end----------------
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
               WHEN INFIELD(ima13) #規格主件
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ima4"     #FUN-4B0001
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "C"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima13
                  NEXT FIELD ima13
               WHEN INFIELD(ima06) #分群碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imz"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima06
                  NEXT FIELD ima06
#FUN-A20037 --begin--
             WHEN INFIELD(ima251)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form   = "q_ima251"
                  LET g_qryparam.state  = "c" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima251
                  NEXT FIELD ima251
#FUN-A20037 --end--
               WHEN INFIELD(imaag)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aga"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaag
                  NEXT FIELD imaag
               WHEN INFIELD(ima09) #其他分群碼一
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "D"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima09
                  NEXT FIELD ima09
               WHEN INFIELD(ima10) #其他分群碼二
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "E"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima10
                  NEXT FIELD ima10
               WHEN INFIELD(ima11) #其他分群碼三
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "F"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima11
                  NEXT FIELD ima11
               WHEN INFIELD(ima12) #其他分群碼四
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "G"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima12
                  NEXT FIELD ima12
               WHEN INFIELD(ima109)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "8"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima109
                  NEXT FIELD ima109
               WHEN INFIELD(ima25) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima25
                  NEXT FIELD ima25
               WHEN INFIELD(ima34) #成本中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_smh"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima34
                  NEXT FIELD ima34
               WHEN INFIELD(ima35)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imd"
                  LET g_qryparam.state    = "c"
                   LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima35
                  NEXT FIELD ima35
               WHEN INFIELD(ima36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ime"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima36
                  NEXT FIELD ima36
               WHEN INFIELD(ima23)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima23
                  NEXT FIELD ima23
               WHEN INFIELD(ima39)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"   #MOD-860039 modify  #TQC-870001 modify  #MOD-870230 modify
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = g_aza.aza81 #TQC-870001 add
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima39
                  NEXT FIELD ima39
               WHEN INFIELD(ima391)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"   #MOD-860039 modify  #TQC-870001 modify  #MOD-870230 modify
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = g_aza.aza82 #TQC-870001 add 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima391
                  NEXT FIELD ima391
               WHEN INFIELD(ima149)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02" 
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima149
                  NEXT FIELD ima149
               WHEN INFIELD(ima1491)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02" 
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = g_aza.aza82
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1491
                  NEXT FIELD ima1491
               WHEN INFIELD(ima907) #FUN-540025
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ima.ima907
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima907
                  NEXT FIELD ima907
               WHEN INFIELD(ima908) #FUN-540025
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ima.ima908
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima908
                  NEXT FIELD ima908
               WHEN INFIELD(ima920)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gei2"   #No.MOD-840254  #No.MOD-840294
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ima.ima920
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima920
               WHEN INFIELD(ima923)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gei2"   #No.MOD-840254  #No.MOD-840294
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ima.ima923
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima923
 
               WHEN INFIELD(ima916)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azp"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima916
                  NEXT FIELD ima916
               WHEN INFIELD(imaud02)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaud02
                  NEXT FIELD imaud02
               WHEN INFIELD(imaud03)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaud03
                  NEXT FIELD imaud03
               WHEN INFIELD(imaud04)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaud04
                  NEXT FIELD imaud04
               WHEN INFIELD(imaud05)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaud05
                  NEXT FIELD imaud05
               WHEN INFIELD(imaud06)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaud06
                  NEXT FIELD imaud06
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
 
                 ON ACTION qbe_select
             CALL cl_qbe_select()
                 ON ACTION qbe_save
       CALL cl_qbe_save()
      END CONSTRUCT
   ELSE
      LET g_wc = "ima01 = '",g_argv1,"'"
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
   CALL cl_set_comp_visible("imaag",FALSE)                 #FUN-810016
   #改用呼叫i100_declare_curs() FUNCTION定義CURSOR
 
   CALL i100_declare_curs()
 
END FUNCTION
 
FUNCTION i100_declare_curs()
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
 
   LET g_sql = "SELECT ima01 FROM ima_file ", # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED,
               " ORDER BY ima01"
   PREPARE aimi100_prepare FROM g_sql
   DECLARE aimi100_curs SCROLL CURSOR WITH HOLD FOR aimi100_prepare
 
   DECLARE aimi100_list_cur CURSOR FOR aimi100_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED
   PREPARE aimi100_precount FROM g_sql
   DECLARE aimi100_count CURSOR FOR aimi100_precount
END FUNCTION
 
FUNCTION i100_menu()
   DEFINE l_cmd     LIKE type_file.chr1000,   #MOD-590270 料號長度alter 40 #No.FUN-690026 VARCHAR(72)
          l_priv1   LIKE zy_file.zy03,        # 使用者執行權限
          l_priv2   LIKE zy_file.zy04,        # 使用者資料權限
          l_priv3   LIKE zy_file.zy05         # 使用部門資料權限
   DEFINE l_sub_ima01   LIKE ima_file.ima01,
          l_sub_ima02   LIKE ima_file.ima02
   DEFINE l_sma120  LIKE sma_file.sma120     #No,FUN-810016
   MENU ""
 
      BEFORE MENU
         CALL cl_set_act_visible("add_multi_attr_sub",FALSE)     #No.MOD-5A0223 --add
         CALL cl_navigator_setting(g_curs_index, g_row_count)    #No.MOD-680064 add
         IF cl_null(g_sma.sma901) OR g_sma.sma901='N' THEN
             CALL cl_set_act_visible("aps_related_data",FALSE)
         END IF

      ON ACTION item_list
         LET g_action_choice = ""  #MOD-8A0193 add
         CALL i100_b_menu()   #MOD-8A0193
         LET g_action_choice = ""  #MOD-8A0193 add
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF g_aza.aza60 = 'N' THEN #不使用客戶申請作業時,才可按新增!
             IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
                  CALL i100_a()
             END IF
         ELSE
             CALL cl_err('','aim-152',1)
             #不使用客戶申請作業時,才可按新增!
         END IF
 
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i100_q()
         END IF
 
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            IF i100_r() THEN
               CALL i100_AFTER_DEL()
            END IF
         END IF
 
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i100_u()
         END IF
 
      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b1 != 0 THEN                   #No.FUN-7C0010
            CALL fgl_set_arr_curr(g_curs_index)  #No.FUN-7C0010
         END IF
 
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b1 != 0 THEN                   #No.FUN-7C0010
            CALL fgl_set_arr_curr(g_curs_index)  #No.FUN-7C0010
         END IF
 
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b1 != 0 THEN                   #No.FUN-7C0010
            CALL fgl_set_arr_curr(g_curs_index)  #No.FUN-7C0010
         END IF
 
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b1 != 0 THEN                   #No.FUN-7C0010
            CALL fgl_set_arr_curr(g_curs_index)  #No.FUN-7C0010
         END IF
 
      ON ACTION last
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b1 != 0 THEN                   #No.FUN-7C0010
            CALL fgl_set_arr_curr(g_curs_index)  #No.FUN-7C0010
         END IF
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL i100_set_perlang()
         CALL i100_show_pic() #FUN-690060 add
         CALL cl_show_fld_cont()   #FUN-550077
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i100_x()
            CALL i100_show()           #No.FUN-610013
         END IF
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         IF g_aza.aza60 = 'N' THEN  #CHI-740027 add if判斷
             IF cl_chk_act_auth() THEN
                CALL i100_copy()
                CALL i100_show() #FUN-6C0006
             END IF
         ELSE
             #參數設定使用料件申請作業時,不可做複製!
             CALL cl_err('','aim-154',1)
         END IF
 
      ON ACTION output
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
            CALL i100_out()
         END IF
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION exit
         LET g_action_choice='exit'
         EXIT MENU
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION data_status
         IF g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
            CALL i100_disp()
         END IF
 
      ON ACTION inventory
         LET g_msg="aimi101 '",g_ima.ima01,"'"
         CALL cl_cmdrun_wait(g_msg) #MOD-580344
         CALL i100_show()
 
      ON ACTION sales
         LET g_action_choice="sales"
         IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
            LET g_cmd = "axmi121 '",g_ima.ima01,"'"
            CALL  cl_cmdrun_wait(g_cmd) #MOD-580344
         END IF
         CALL i100_show()
 
      ON ACTION purchase
         LET g_action_choice="purchase"
         IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
            LET l_priv1=g_priv1
            LET l_priv2=g_priv2
            LET l_priv3=g_priv3
            LET g_msg="aimi103 '",g_ima.ima01,"' '",g_flag1,"'"
            CALL cl_cmdrun_wait(g_msg) #MOD-580344
            LET g_priv1=l_priv1
            LET g_priv2=l_priv2
            LET g_priv3=l_priv3
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
            CALL i100_show()
         END IF
 
      ON ACTION production
         LET g_action_choice="production"
         IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
            LET l_priv1=g_priv1
            LET l_priv2=g_priv2
            LET l_priv3=g_priv3
            LET g_msg="aimi104 '",g_ima.ima01,"'"
            CALL cl_cmdrun_wait(g_msg) #MOD-580344
            LET g_priv1=l_priv1
            LET g_priv2=l_priv2
            LET g_priv3=l_priv3
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
            CALL i100_show()
         END IF
 
      ON ACTION cost
         LET g_action_choice="cost"
         IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
            LET l_priv1=g_priv1
            LET l_priv2=g_priv2
            LET l_priv3=g_priv3
            LET g_msg="aimi105 '",g_ima.ima01,"'"
            CALL cl_cmdrun_wait(g_msg) #MOD-580344
            LET g_priv1=l_priv1
            LET g_priv2=l_priv2
            LET g_priv3=l_priv3
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
            CALL i100_show()
         END IF
 
      ON ACTION cost_element
         LET g_action_choice="cost_element"
         IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
            LET l_priv1=g_priv1
            LET l_priv2=g_priv2
            LET l_priv3=g_priv3
            LET g_msg="aimi106 '",g_ima.ima01,"'"
            CALL cl_cmdrun_wait(g_msg) #MOD-580344
            LET g_priv1=l_priv1
            LET g_priv2=l_priv2
            LET g_priv3=l_priv3
         END IF
         CALL i100_show()
 
      ON ACTION pn_spec_extra_desc
         LET g_action_choice="pn_spec_extra_desc"
         IF cl_chk_act_auth() AND NOT cl_null(g_ima.ima01) THEN
            LET g_msg="aimi108 '",g_ima.ima01,"'"
            CALL cl_cmdrun_wait(g_msg) #MOD-580344
         END IF
         CALL i100_show()
 
         ON ACTION carry
            LET g_action_choice = "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL i100_carry()
            END IF
 
         ON ACTION download
            LET g_action_choice = "download"
            IF cl_chk_act_auth() THEN
               CALL i100_download()
            END IF
 
         ON ACTION qry_carry_history
            LET g_action_choice = "qry_carry_history"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_ima.ima01) THEN   #No.FUN-830090
                  IF NOT cl_null(g_ima.ima916) THEN
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '1' AND gev02 = g_ima.ima916
                  ELSE      #歷史資料,即沒有ima916的值
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '1' AND gev02 = g_plant
                  END IF
                  IF NOT cl_null(g_gev04) THEN
                     LET l_cmd='aooq604 "',g_gev04,'" "1" "',g_prog,'" "',g_ima.ima01,'"'
                     CALL cl_cmdrun(l_cmd)
                  END IF
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
            IF g_ima.ima01 IS NOT NULL THEN
               LET g_doc.column1 = "ima01"
               LET g_doc.value1 = g_ima.ima01
               CALL cl_doc()
            END IF
         END IF
 
      ON ACTION aps_related_data
         LET g_action_choice="aps_related_data" #MOD-520032
         IF cl_null(g_ima.ima01) THEN
            CALL cl_err('',-400,1)
         END IF
         IF (cl_chk_act_auth()) and (NOT cl_null(g_ima.ima01)) THEN              #BUG-520032    #MOD-530367
             CALL i100_vmi()
             LET g_cmd = "apsi308 '",g_ima.ima01,"'"
             CALL cl_cmdrun(g_cmd)
         ELSE
             CALL cl_err('',-400,1)
         END IF
 
      ON ACTION maintain_item_unit_conversion
         LET g_action_choice="maintain_item_unit_conversion"
         LET l_cmd = "aooi103 '",g_ima.ima01,"'" CLIPPED
         CALL cl_cmdrun(l_cmd CLIPPED)
 
      ON ACTION add_multi_attr_sub
         IF cl_null(g_ima.ima01) THEN
            CALL cl_err('',-400,1)
         ELSE
              IF g_ima.ima1010 !='1' THEN               # NO.FUN-870117 
                 CALL cl_err(g_ima.ima01,'aim-450',1)   # NO.FUN-870117
              ELSE                                      # NO.FUN-870117
                LET g_action_choice="add_multi_attr_sub"
                CALL saimi311(g_ima.ima01)
                LET INT_FLAG=0        #No.FUN-640013 退出子程序后INT_FLAG為1,要置0
                CALL i100_show()
              END IF                                    # NO.FUN-870117  
         END IF
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
            CALL i100_confirm()
            CALL i100_show()
         END IF
 
 
      ON ACTION notconfirm
         LET g_action_choice="notconfirm"
         IF cl_chk_act_auth() THEN
            CALL i100_notconfirm()
            CALL i100_show()
         END IF
 
      ON ACTION update_person
         LET g_action_choice="update_person"
         IF cl_chk_act_auth() THEN
            CALL i100_upd_person()
            CALL i100_show() #FUN-6C0006
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
         LET g_action_choice='exit'
         CONTINUE MENU
 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE          #MOD-570244 mars
         LET g_action_choice = "exit"
         EXIT MENU
 
      &include "qry_string.4gl"
 
   END MENU
 
   CLOSE aimi100_curs
 
END FUNCTION
 
FUNCTION i100_vmi()
   DEFINE l_vmi   RECORD LIKE vmi_file.*
  
            SELECT vmi01 FROM vmi_file WHERE vmi01 =g_ima.ima01
            IF SQLCA.SQLCODE=100 THEN
               LET l_vmi.vmi01 = g_ima.ima01
               LET l_vmi.vmi03 = 0
               LET l_vmi.vmi04 = 0
               LET l_vmi.vmi05 = 0
               LET l_vmi.vmi08 = 999999                       #TQC-750013 mod
               LET l_vmi.vmi11 = 0
               LET l_vmi.vmi15 = 0
               LET l_vmi.vmi16 = 999
               LET l_vmi.vmi17 = 999
               LET l_vmi.vmi21 = 0
               LET l_vmi.vmi22 = 0
               LET l_vmi.vmi23 = 0
               LET l_vmi.vmi24 = 1
               LET l_vmi.vmi25 = 0
               LET l_vmi.vmi19 = 0
               LET l_vmi.vmi35 = 0
               LET l_vmi.vmi36 = NULL
               LET l_vmi.vmi37 = 7
               LET l_vmi.vmi38 = 0
               LET l_vmi.vmi40 = NULL
               LET l_vmi.vmi44 = NULL
               LET l_vmi.vmi45 = NULL
               LET l_vmi.vmi47 = 0
               LET l_vmi.vmi49 = 5   #FUN-8A0082 ADD
               LET l_vmi.vmi50 = 10  #FUN-8A0082 ADD  
               LET l_vmi.vmi64 = 0
               LET l_vmi.vmi57 = 1   #FUN-8B0003
               LET l_vmi.vmi56 = 0    #FUN-870012
               LET l_vmi.vmi60 = 0    #FUN-850115
               INSERT INTO vmi_file VALUES(l_vmi.*)
                  IF STATUS THEN
                     CALL cl_err3("ins","vmi_file",g_ima.ima01,"",SQLCA.sqlcode,
                                  "","",1)  
                  END IF
               UPDATE ima_file SET imadate=g_today WHERE ima01 = g_ima.ima01
            END IF
END FUNCTION
 
FUNCTION i100_a()
 
   LET g_wc = NULL
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   INITIALIZE g_ima.* LIKE ima_file.*
   LET g_ima01_t = NULL
   LET g_ima_o.*=g_ima.*
   CALL i100_default()
   CALL cl_opmsg('a')
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'a') THEN                                                                          
      CALL cl_err(g_ima.ima916,'aoo-078',1)                                                                                        
      RETURN                                                                                                                       
   END IF   
 
   WHILE TRUE
      
      LET g_ima.ima151='N'                       # No.FUN-810016
      CALL cl_set_comp_visible("imaag",FALSE)    # No.FUN-810016
      INITIALIZE g_ima_o.*  TO NULL
      IF g_aza.aza28 = 'Y' THEN
         CALL s_auno(g_ima.ima01,'1','') RETURNING g_ima.ima01,g_ima.ima02  #No.FUN-850100
      END IF
     
      CALL i100_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_ima.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CALL cl_set_comp_visible("imaag",FALSE)                       #FUN-810016
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF g_ima.ima01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      CALL i100_a_inschk()
 
      BEGIN WORK     #NO.FUN-680010
 
      IF NOT i100_a_ins() THEN #FUN-710037
         ROLLBACK WORK    #NO.FUN-680010
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i100_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_buf           LIKE aag_file.aag02,    #FUN-660078
          l_cmd           LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(80)
   DEFINE lc_sma119       LIKE sma_file.sma119,   #No.FUN-560119
          li_len          LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE li_result       LIKE type_file.num5     #No.FUN-610065 #No.FUN-690026 SMALLINT
   DEFINE l_n             LIKE type_file.num5     #No.FUN-810036
   DEFINE l_ima151        LIKE ima_file.ima151    #No.FUN-810016
   DEFINE l_imz150        LIKE imz_file.imz150    #No.FUN-810016
   DEFINE l_imz152        LIKE imz_file.imz152    #No.FUN-830087
   DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3,#No.FUN-A20044
          l_unavl_stk      LIKE type_file.num15_3,#No.FUN-A20044
          l_avl_stk        LIKE type_file.num15_3 #No.FUN-A20044 
   DEFINE l_sql           STRING                  #FUB-AB0025  
   DEFINE l_arg1          STRING                  #FUN-AB0025
   
   DISPLAY BY NAME g_ima.ima901,g_ima.imauser,g_ima.imagrup,
                   g_ima.imadate,g_ima.imaacti
                   ,g_ima.ima151           #No.FUN-810016
 
   DISPLAY BY NAME g_ima.ima906,g_ima.ima907,g_ima.ima908, #,g_ima.ima909 #FUN-560187
                   g_ima.ima1010  #No.FUN-610013
   DISPLAY BY NAME g_ima.ima916   #No.FUN-7C0010
   DISPLAY BY NAME g_ima.ima022   #No.FUN-A20037
 
 
#  LET g_d2=g_ima.ima262-g_ima.ima26      #FUN-A20044
   CALL s_getstock(g_ima.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   #FUN-A20044
   LET g_d2 = l_avl_stk - l_avl_stk_mpsmrp                                                 #FUN-A20044
   LET g_flag1 = p_cmd
   IF p_cmd = 'u' THEN LET g_ima.imadate = g_today END IF
 
   LET g_on_change_02 = TRUE   #FUN-550077
   LET g_on_change_021= TRUE   #FUN-550077
 
   SELECT sma119 INTO lc_sma119 FROM sma_file
   CASE lc_sma119
      WHEN "0"
         LET li_len = 20
      WHEN "1"
         LET li_len = 30
      WHEN "2"
         LET li_len = 40
   END CASE
 
   INPUT BY NAME g_ima.imaoriu,g_ima.imaorig,
        g_ima.ima01, g_ima.ima02, g_ima.ima021,
        g_ima.ima06,g_ima.ima08 ,
        g_ima.ima13, g_ima.ima05,
        g_ima.ima140,g_ima.ima03, g_ima.ima93,g_ima.ima915,  #FUN-710060 add ima915
        g_ima.ima151,     #No.FUN-810016
        g_ima.imaag, #No.FUN-640013
        g_ima.ima910,
        g_ima.ima105,g_ima.ima14, g_ima.ima107,g_ima.ima147,   #FUN-550014 add ima910
        g_ima.ima109,g_ima.ima903, g_ima.ima905,g_ima.ima24,g_ima.ima911,   #FUN-610080 加ima911
        g_ima.ima022,g_ima.ima251,     #FUN-A20037 add  
        g_ima.ima07, g_ima.ima70 ,g_ima.ima37 , g_ima.ima51,
        g_ima.ima52, g_ima.ima27, g_ima.ima28 , g_ima.ima271,g_ima.ima71,
        g_ima.ima25, g_ima.ima35, g_ima.ima36, g_ima.ima23,
        g_ima.ima918,g_ima.ima919,g_ima.ima920,g_ima.ima921,  #No.FUN-810036
        g_ima.ima922,g_ima.ima923,g_ima.ima924,g_ima.ima925,  #No.FUN-810036
        g_ima.ima906,g_ima.ima907,g_ima.ima908, #FUN-540025
        g_ima.ima12, g_ima.ima39,g_ima.ima391,  #FUN-680034
        g_ima.ima149,g_ima.ima1491,   #FUN-960141 add
        g_ima.ima15, g_ima.ima146,g_ima.ima16 ,
        g_ima.ima09, g_ima.ima10, g_ima.ima11 ,
        g_ima.ima1001, g_ima.ima1002,                 #No.FUN-640010
        g_ima.ima1012, g_ima.ima1013,                 #No.FUN-640010
       #g_ima.ima1015, g_ima.ima1014,g_ima.ima1016,   #No.FUN-640010  #CHI-CA0073 mark 
        g_ima.ima1014,g_ima.ima1016,   #No.FUN-640010  #CHI-CA0073  add 
        g_ima.imaud01,g_ima.imaud02,g_ima.imaud03,g_ima.imaud04,g_ima.imaud05,
        g_ima.imaud06,g_ima.imaud07,g_ima.imaud08,g_ima.imaud09,g_ima.imaud10,
        g_ima.imaud11,g_ima.imaud12,g_ima.imaud13,g_ima.imaud14,g_ima.imaud15
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i100_set_entry(p_cmd)
            CALL i100_set_no_entry(p_cmd)       
            CALL i100_set_no_required()  #FUN-540025
            CALL i100_set_required()     #FUN-540025
            LET g_before_input_done = TRUE
            CALL cl_chg_comp_att("ima01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
          
        BEFORE FIELD ima01
            IF g_sma.sma60 = 'Y' THEN# 若須分段輸入
               CALL s_inp5(6,14,g_ima.ima01) RETURNING g_ima.ima01
               DISPLAY BY NAME g_ima.ima01
            END IF
 
        AFTER FIELD ima01
            IF NOT i100_chk_ima01(p_cmd) THEN
               NEXT FIELD CURRENT
            END IF
 
        BEFORE FIELD ima02
            IF g_sma.sma64='Y' AND cl_null(g_ima.ima02) THEN
               CALL s_desinp(6,4,g_ima.ima02) RETURNING g_ima.ima02
               DISPLAY BY NAME g_ima.ima02
            END IF 
        
        ON CHANGE ima151
          CALL cl_set_comp_visible("imaag",g_ima.ima151='Y')
          IF NOT i100_chk_imaag() THEN
              NEXT FIELD CURRENT
          END IF
 
        ON CHANGE ima02
           IF (g_aza.aza44 = "Y") AND cl_null(g_ima.ima01) THEN
              NEXT FIELD ima01
           END IF   #MOD-6C0042 add
           CALL i100_chg_ima02()
 
        ON CHANGE ima021
           IF (g_aza.aza44 = "Y") AND cl_null(g_ima.ima01) THEN
              NEXT FIELD ima01
           END IF   #MOD-6C0042 add
           CALL i100_chg_ima021()
 
        AFTER FIELD ima06                     #分群碼
           IF NOT i100_chk_ima06(p_cmd) THEN
              NEXT FIELD CURRENT
           ELSE
              IF cl_null(g_errno)  AND g_ans ="1"  THEN
                 SELECT imz150,imz152 INTO l_imz150,l_imz152 FROM imz_file
                            WHERE imz01=g_ima.ima06
                 LET g_ima.ima150=l_imz150
                 LET g_ima.ima152=l_imz152
                 CALL i100_show()
              END IF
              IF NOT cl_null(g_errno)  AND g_ans ="1"  THEN
                 LET INT_FLAG=1
                 EXIT INPUT
              END IF
           END IF
 
        AFTER FIELD imaag
           IF NOT i100_chk_imaag() THEN
              NEXT FIELD CURRENT
           END IF
 
        BEFORE FIELD ima08
           CALL i100_set_entry(p_cmd)
 
        AFTER FIELD ima08  #來源碼
           IF NOT i100_chk_ima08(p_cmd) THEN
              NEXT FIELD CURRENT
           END IF
 
        AFTER FIELD ima13  #規格主件料件(source code 為 'T'時才輸入)
           IF NOT i100_chk_ima13() THEN
              NEXT FIELD CURRENT
           END IF
 
        AFTER FIELD ima14  #工程料件
           IF NOT i100_chk_ima14() THEN
              NEXT FIELD CURRENT
           END IF
 
        AFTER FIELD ima903  #No:6872 可否做聯產品入庫
           IF NOT i100_chk_ima903() THEN
              NEXT FIELD CURRENT
           END IF
 
        AFTER FIELD ima24  #檢驗否
           IF NOT s_chk_checkbox(g_ima.ima24) THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima24 = g_ima.ima24
 
        AFTER FIELD ima911  #重複性生產料件
           IF NOT s_chk_checkbox(g_ima.ima911) THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima911 = g_ima.ima911
 
#FUN-A20037 --begin--
       AFTER FIELD ima022
          IF NOT cl_null(g_ima.ima022) THEN
             IF g_ima.ima022 < 0 THEN
                CALL cl_err('','aec-020',0) 
                NEXT FIELD CURRENT
             END IF 
          END IF 

       AFTER FIELD ima251
          IF NOT cl_null(g_ima.ima251) THEN 
              CALL i251_chk()        
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD CURRENT
              END IF 
          END IF 
#FUN-A20037 --end--

        AFTER FIELD ima107  #插件位置
           IF NOT s_chk_checkbox(g_ima.ima107) THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima107 = g_ima.ima107
 
        AFTER FIELD ima147  #插件位置與QPA是否要勾稽BugNo:6542
           IF NOT s_chk_checkbox(g_ima.ima147) THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima147 = g_ima.ima147
 
        AFTER FIELD ima15  #保稅料件
           IF NOT s_chk_checkbox(g_ima.ima15) THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima15 = g_ima.ima15
        AFTER FIELD ima109
           IF NOT cl_null(g_ima.ima109) THEN
              IF (g_ima_o.ima109 IS NULL) OR
                 (g_ima.ima109 != g_ima_o.ima109) THEN
                  IF NOT i100_chk_ima109() THEN
                     NEXT FIELD ima109
                  END IF
              END IF
           END IF
           LET g_ima_o.ima109 = g_ima.ima109
 
        AFTER FIELD ima910
           IF cl_null(g_ima.ima910) THEN
               LET g_ima.ima910 = ' '
           END IF
 
        AFTER FIELD ima105
           IF NOT s_chk_checkbox(g_ima.ima105) THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima105 = g_ima.ima105
 
#@@@@@可使為消耗性料件 1.多倉儲管理(sma12 = 'y')
#@@@@@                 2.使用製程(sma54 = 'y')
        AFTER FIELD ima70  #消耗料件
           IF NOT s_chk_checkbox(g_ima.ima70) THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima70 = g_ima.ima70
 
        AFTER FIELD ima09                     #其他分群碼一
           IF NOT i100_chk_ima09() THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima09 = g_ima.ima09
 
        AFTER FIELD ima10                     #其他分群碼二
           IF NOT i100_chk_ima10() THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima10 = g_ima.ima10
 
        AFTER FIELD ima11                     #其他分群碼三
           IF NOT i100_chk_ima11() THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima11 = g_ima.ima11
 
        BEFORE FIELD ima1014
           IF p_cmd='a' THEN
              LET g_ima.ima1014='1'
           END IF
 
        AFTER FIELD ima1014
           IF NOT cl_null(g_ima.ima1014) THEN
              IF g_ima.ima1014 NOT MATCHES '[123456]' THEN
                 NEXT FIELD CURRENT
              END IF
           END IF
 
        AFTER FIELD ima12                     #其他分群碼四
           IF NOT i100_chk_ima12() THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima12 = g_ima.ima12
 
        AFTER FIELD ima25            #庫存單位
           IF NOT i100_chk_ima25() THEN
              NEXT FIELD CURRENT
           END IF
           IF NOT cl_null(g_ima.ima25) AND p_cmd='u' THEN
            SELECT COUNT(*) INTO l_n FROM ima_file
             WHERE (ima63 <> g_ima.ima25 OR
                    ima31 <> g_ima.ima25 OR
                    ima44 <> g_ima.ima25 OR
                    ima55 <> g_ima.ima25 
                   )
               AND ima01=g_ima.ima01
            IF l_n > 0 THEN
               LET g_msg=cl_getmsg('aim-020',g_lang)
               IF cl_prompt(0,0,g_msg) THEN
                  CALL i100_a_updchk()
               END IF
            ELSE
               IF g_ima.ima25<>g_ima_o.ima25 THEN
                  CALL i100_a_updchk()
               END IF
            END IF
         END IF
           LET g_ima_o.ima25 = g_ima.ima25
           LET g_ima.ima86=g_ima.ima25
           
           CALL i100_unit_fac()     #TQC-940110 add
 
        AFTER FIELD ima35
           IF NOT i100_chk_ima35() THEN
              NEXT FIELD CURRENT
           END IF
 
        AFTER FIELD ima36
           IF NOT i100_chk_ima36() THEN
              NEXT FIELD CURRENT
           END IF
 
        AFTER FIELD ima23
           #No.B052 010326 by plum 加上有效碼的check
           IF NOT i100_chk_ima23() THEN
              NEXT FIELD ima23
           END IF
           LET g_ima_o.ima23 = g_ima.ima23             #MOD-4A0326
 
        AFTER FIELD ima07  #ABC 碼
           IF g_aza.aza50='N' THEN
              IF NOT i100_chk_ima07() THEN
                 NEXT FIELD CURRENT
              END IF
           END IF
            LET g_ima_o.ima07 = g_ima.ima07

        AFTER FIELD ima27
           IF g_ima.ima27 IS NOT NULL THEN
              IF g_ima.ima27 <0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD ima27
              END IF
           END IF
 
        AFTER FIELD ima28
           IF g_ima.ima28 IS NOT NULL THEN
              IF g_ima.ima28 <0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD ima28
              END IF
           END IF
 
        AFTER FIELD ima271
           IF g_ima.ima271 IS NOT NULL THEN
              IF g_ima.ima271 <0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD ima271
              END IF
           END IF
 
        AFTER FIELD ima71
           IF g_ima.ima71 IS NOT NULL THEN
              IF g_ima.ima71 <0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD ima71
              END IF
           END IF
 
        AFTER FIELD ima37  #補貨策略碼
           IF NOT i100_chk_ima37() THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima37 = g_ima.ima37
 
        AFTER FIELD ima51
           IF NOT i100_chk_ima51() THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima51 = g_ima.ima51
 
        AFTER FIELD ima52
           IF NOT i100_chk_ima52() THEN
              NEXT FIELD CURRENT
           END IF
           LET g_ima_o.ima52 = g_ima.ima52
 
        AFTER FIELD ima39
            IF NOT cl_null(g_ima.ima39) OR g_ima.ima39 != ' '  THEN
               IF NOT i100_chk_ima39() THEN
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag02"                                   
                  LET g_qryparam.default1 = g_ima.ima39  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_ima.ima39 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_ima.ima39
                  DISPLAY BY NAME g_ima.ima39  
                  #FUN-B10049--end                  
                  NEXT FIELD ima39
               END IF
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_ima.ima39
                         AND aag07 != '1'  #No:8400 #MOD-490065將aag071改為aag07
                         AND aag00 = g_aza.aza81  #No.FUN-730020
               MESSAGE l_buf CLIPPED
            END IF
            LET g_ima_o.ima39 = g_ima.ima39
 
        AFTER FIELD ima391
            IF NOT cl_null(g_ima.ima391) OR g_ima.ima391 != ' '  THEN
               IF NOT i100_chk_ima391() THEN
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag02"                                   
                  LET g_qryparam.default1 = g_ima.ima391  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza82  
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_ima.ima391 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_ima.ima391
                  DISPLAY BY NAME g_ima.ima391  
                  #FUN-B10049--end               
                  NEXT FIELD ima391
               END IF
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_ima.ima391
                         AND aag07 != '1'  #No:8400 #MOD-490065將aag071改為aag07
                         AND aag00 = g_aza.aza82  #No.FUN-730020
               MESSAGE l_buf CLIPPED
            END IF
            LET g_ima_o.ima391 = g_ima.ima391

        AFTER FIELD ima149
            IF NOT cl_null(g_ima.ima149) OR g_ima.ima149 != ' '  THEN
               IF NOT i100_chk_ima149() THEN
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag02"                                   
                  LET g_qryparam.default1 = g_ima.ima149  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_ima.ima149  CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_ima.ima149  
                  DISPLAY BY NAME g_ima.ima149    
                  #FUN-B10049--end               
                  NEXT FIELD ima149
               END IF
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_ima.ima149
                         AND aag07 != '1' 
                         AND aag00 = g_aza.aza81
               MESSAGE l_buf CLIPPED
            END IF
            LET g_ima_o.ima149 = g_ima.ima149
        AFTER FIELD ima1491
            IF NOT cl_null(g_ima.ima1491) OR g_ima.ima1491 != ' '  THEN
               IF NOT i100_chk_ima1491() THEN
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag02"                                   
                  LET g_qryparam.default1 = g_ima.ima1491  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza82  
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_ima.ima1491  CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_ima.ima1491  
                  DISPLAY BY NAME g_ima.ima1491    
                  #FUN-B10049--end                    
                  NEXT FIELD ima1491
               END IF
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_ima.ima1491
                         AND aag07 != '1'
                         AND aag00 = g_aza.aza82 
               MESSAGE l_buf CLIPPED
            END IF
            LET g_ima_o.ima1491 = g_ima.ima1491
 
      BEFORE FIELD ima906
         CALL i100_set_entry(p_cmd)
 
      AFTER FIELD ima906
         IF NOT i100_chk_ima906(p_cmd) THEN
            NEXT FIELD CURRENT
         END IF
 
      AFTER FIELD ima907
         IF NOT i100_chk_ima907(p_cmd) THEN
            NEXT FIELD ima907
         END IF
 
      BEFORE FIELD ima908
         IF cl_null(g_ima.ima908) THEN
            IF g_sma.sma116 MATCHES '[123]' THEN    #No.FUN-610076
               LET g_ima.ima908 = g_ima.ima25
               DISPLAY BY NAME g_ima.ima908
            END IF
         END IF
 
      AFTER FIELD ima908
         IF NOT i100_chk_ima908(p_cmd) THEN
            NEXT FIELD ima908
         END IF
 
      BEFORE FIELD ima918
         CALL i100_set_entry(p_cmd)
 
      ON CHANGE ima918
         IF cl_null(g_ima.ima918) OR g_ima.ima918 = 'N' THEN
            LET g_ima.ima919 = 'N'
            LET g_ima.ima920 = NULL
            CALL i100_set_no_required() 
            DISPLAY BY NAME g_ima.ima919
            DISPLAY BY NAME g_ima.ima920
         END IF 
         CALL i100_set_no_entry(p_cmd)
 
      BEFORE FIELD ima919
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_required()   #No.MOD-840257
 
      AFTER FIELD ima919
         CALL i100_set_no_entry(p_cmd)
         CALL i100_set_required()   #No.MOD-840257
 
      AFTER FIELD ima920
         IF NOT cl_null(g_ima.ima920) THEN
            SELECT COUNT(*) INTO l_n FROM geh_file,gei_file   #No.MOD-840254  #No.MOD-840294
             WHERE geh04 = '5'   #No.MOD-840254
               AND geh01 = gei03  #No.MOD-840294
               AND gei01 = g_ima.ima920   #No.MOD-840254  #No.MOD-840294
            IF l_n = 0 THEN
               CALL cl_err(g_ima.ima920,'aoo-112',0)
               NEXT FIELD ima920
            END IF
         END IF
 
      BEFORE FIELD ima921
         CALL i100_set_entry(p_cmd)
 
      ON CHANGE ima921
         IF cl_null(g_ima.ima921) OR g_ima.ima921 = 'N' THEN
            LET g_ima.ima922 = 'N'
            LET g_ima.ima923 = NULL
            CALL i100_set_no_required() 
            DISPLAY BY NAME g_ima.ima922
            DISPLAY BY NAME g_ima.ima923
         END IF 
         CALL i100_set_no_entry(p_cmd)
 
      BEFORE FIELD ima922
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_required()   #No.MOD-840257
 
      AFTER FIELD ima922
         CALL i100_set_no_entry(p_cmd)
         CALL i100_set_required()   #No.MOD-840257
 
      AFTER FIELD ima923
         IF NOT cl_null(g_ima.ima923) THEN
            SELECT COUNT(*) INTO l_n FROM geh_file,gei_file   #No.MOD-840254  #No.MOD-840294
             WHERE geh04 = '6'   #No.MOD-840254
               AND geh01 = gei03  #No.MOD-840294
               AND gei01 = g_ima.ima923   #No.MOD-840254
            IF l_n = 0 THEN
               CALL cl_err(g_ima.ima923,'aoo-112',0)
               NEXT FIELD ima923
            END IF
         END IF
 
      AFTER FIELD ima925
         IF g_ima.ima925 NOT MATCHES '[123]' THEN
            NEXT FIELD ima925
         END IF
 
 
 
        AFTER FIELD imaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_ima.imauser = s_get_data_owner("ima_file") #FUN-C10039
           LET g_ima.imagrup = s_get_data_group("ima_file") #FUN-C10039
            LET g_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            CASE i100_i_inpchk()
               WHEN "ima01"  NEXT FIELD ima01
               WHEN "ima906" NEXT FIELD ima906
            END CASE
 
        ON ACTION item_group_common_inventory
           CALL cl_cmdrun("aimi110 ")
 
        ON ACTION maintain_code_mat_category
           LET l_cmd="aooi305"  #6818
           CALL cl_cmdrun(l_cmd CLIPPED)
 
        ON ACTION maintain_unit_data
           LET l_cmd="aooi101 "
           CALL cl_cmdrun(l_cmd CLIPPED)
 
        ON ACTION maintain_othr_grp_cd1
           LET l_cmd="aooi309 "  #6818
           CALL cl_cmdrun(l_cmd CLIPPED)
 
        ON ACTION maintain_othr_grp_cd2
           LET l_cmd="aooi310 "  #6818
           CALL cl_cmdrun(l_cmd CLIPPED)
 
        ON ACTION maintain_othr_grp_cd3
           LET l_cmd="aooi311 "   #6818
           CALL cl_cmdrun(l_cmd CLIPPED)
 
        ON ACTION maintain_othr_grp_cd4
           LET l_cmd="aooi312 "   #6818
           CALL cl_cmdrun(l_cmd CLIPPED)
 
        ON ACTION maintain_unit_conversion
           CALL cl_cmdrun("aooi102 ")
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(ima13) #規格主件
#FUN-AB0025---------mod---------------str----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_ima1"
#                 LET g_qryparam.default1 = g_ima.ima13
#                 LET g_qryparam.arg1     = "C"
#                 LET g_qryparam.where    = " ima08 IN ",cl_parse(g_qryparam.arg1)
#                 CALL cl_create_qry() RETURNING g_ima.ima13
                  LET l_arg1 = "C" 
                  LET l_sql = " ima08 IN ",cl_parse(l_arg1)
                  CALL q_sel_ima(TRUE, "q_ima1",l_sql,g_ima.ima13,"C","","","","",'')  
                    RETURNING g_ima.ima13 
#FUN-AB0025--------mod---------------end----------------
                  DISPLAY BY NAME g_ima.ima13
                  NEXT FIELD ima13
               WHEN INFIELD(ima06) #分群碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imz"
                  LET g_qryparam.default1 = g_ima.ima06
                  CALL cl_create_qry() RETURNING g_ima.ima06
                  DISPLAY BY NAME g_ima.ima06
                  NEXT FIELD ima06
               WHEN INFIELD(imaag)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aga"
                  LET g_qryparam.default1 = g_ima.imaag
                  CALL cl_create_qry() RETURNING g_ima.imaag
                  DISPLAY BY NAME g_ima.imaag
                  NEXT FIELD imaag
#FUN-A20037 --BEGIN--
               WHEN INFIELD(ima251)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.default1 = g_ima.ima251
                  CALL cl_create_qry() RETURNING g_ima.ima251
                  DISPLAY BY NAME g_ima.ima251
                  NEXT FIELD ima251
#FUN-A20037 --END--
               WHEN INFIELD(ima09) #其他分群碼一
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_ima.ima09
                  LET g_qryparam.arg1     = "D"
                  CALL cl_create_qry() RETURNING g_ima.ima09 #6818
                  DISPLAY BY NAME g_ima.ima09
                  NEXT FIELD ima09
               WHEN INFIELD(ima10) #其他分群碼二
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_ima.ima10
                  LET g_qryparam.arg1     = "E"
                  CALL cl_create_qry() RETURNING g_ima.ima10 #6818
                  DISPLAY BY NAME g_ima.ima10
                  NEXT FIELD ima10
               WHEN INFIELD(ima11) #其他分群碼三
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_ima.ima11
                  LET g_qryparam.arg1     = "F"
                  CALL cl_create_qry() RETURNING g_ima.ima11 #6818
                  DISPLAY BY NAME g_ima.ima11
                  NEXT FIELD ima11
               WHEN INFIELD(ima12) #其他分群碼四
                  CALL cl_init_qry_var()   #MOD-5A0094
                  LET g_qryparam.form    = "q_azf"
                  LET g_qryparam.default1 = g_ima.ima12
                  LET g_qryparam.arg1     = "G"
                  CALL cl_create_qry() RETURNING g_ima.ima12 #6818
                  DISPLAY BY NAME g_ima.ima12
                  NEXT FIELD ima12
               WHEN INFIELD(ima109)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_ima.ima109
                  LET g_qryparam.arg1     = "8"
                  CALL cl_create_qry() RETURNING g_ima.ima109
                  DISPLAY BY NAME g_ima.ima109
                  NEXT FIELD ima109
               WHEN INFIELD(ima25) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.default1 = g_ima.ima25
                  CALL cl_create_qry() RETURNING g_ima.ima25
                  DISPLAY BY NAME g_ima.ima25
                  NEXT FIELD ima25
               WHEN INFIELD(ima34) #成本中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_smh"
                  LET g_qryparam.default1 = g_ima.ima34
                  CALL cl_create_qry() RETURNING g_ima.ima34
                  DISPLAY BY NAME g_ima.ima34
                  NEXT FIELD ima34
               WHEN INFIELD(ima35)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imd"
                  LET g_qryparam.default1 = g_ima.ima35
                   LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                  CALL cl_create_qry() RETURNING g_ima.ima35
                  DISPLAY BY NAME g_ima.ima35
                  NEXT FIELD ima35
               WHEN INFIELD(ima36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ime"
                  LET g_qryparam.default1 = g_ima.ima36
                   LET g_qryparam.arg1     = g_ima.ima35 #倉庫編號 #MOD-4A0063
                   LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-4A0063
                  CALL cl_create_qry() RETURNING g_ima.ima36
                  DISPLAY BY NAME g_ima.ima36
                  NEXT FIELD ima36
               WHEN INFIELD(ima23)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.default1 = g_ima.ima23
                  CALL cl_create_qry() RETURNING g_ima.ima23
                  DISPLAY BY NAME g_ima.ima23
                  LET g_gen02 = ""
                  SELECT gen02 INTO g_gen02
                    FROM gen_file
                   WHERE gen01=g_ima.ima23
                  DISPLAY g_gen02 TO FORMONLY.gen02
                  NEXT FIELD ima23
               WHEN INFIELD(ima39)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"   #MOD-860039 modify  #TQC-870001 modify  #MOD-870230 modify
                  LET g_qryparam.default1 = g_ima.ima39
                  LET g_qryparam.arg1     = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_ima.ima39
                  DISPLAY BY NAME g_ima.ima39
                  NEXT FIELD ima39
               WHEN INFIELD(ima391)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"   #MOD-860039 modify  #TQC-870001 modify  #MOD-870230 modify
                  LET g_qryparam.default1 = g_ima.ima391
                  LET g_qryparam.arg1     = g_aza.aza82
                  CALL cl_create_qry() RETURNING g_ima.ima391
                  DISPLAY BY NAME g_ima.ima391
                  NEXT FIELD ima391
               WHEN INFIELD(ima149)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"
                  LET g_qryparam.default1 = g_ima.ima149
                  LET g_qryparam.arg1     = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_ima.ima149
                  DISPLAY BY NAME g_ima.ima149
                  NEXT FIELD ima149
               WHEN INFIELD(ima1491)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"  
                  LET g_qryparam.default1 = g_ima.ima1491
                  LET g_qryparam.arg1     = g_aza.aza82
                  CALL cl_create_qry() RETURNING g_ima.ima1491
                  DISPLAY BY NAME g_ima.ima1491
                  NEXT FIELD ima1491
             WHEN INFIELD(ima907) #FUN-540025
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_ima.ima907
                CALL cl_create_qry() RETURNING g_ima.ima907
                DISPLAY BY NAME g_ima.ima907
                NEXT FIELD ima907
             WHEN INFIELD(ima908) #FUN-540025
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_ima.ima908
                CALL cl_create_qry() RETURNING g_ima.ima908
                DISPLAY BY NAME g_ima.ima908
                NEXT FIELD ima908
            WHEN INFIELD(ima920)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gei2"   #No.MOD-840254  #No.MOD-840294
               LET g_qryparam.default1 = g_ima.ima920
               LET g_qryparam.where = " geh04='5'"   #No.MOD-840254
               CALL cl_create_qry() RETURNING g_ima.ima920
               DISPLAY g_ima.ima920 TO ima920
            WHEN INFIELD(ima923)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gei2"   #No.MOD-840254  #No.MOD-840294
               LET g_qryparam.default1 = g_ima.ima923
               LET g_qryparam.where = " geh04='6'"   #No.MOD-840254
               CALL cl_create_qry() RETURNING g_ima.ima923
               DISPLAY g_ima.ima923 TO ima923
 
             WHEN INFIELD(imaud02)
                CALL cl_dynamic_qry() RETURNING g_ima.imaud02
                DISPLAY BY NAME g_ima.imaud02
                NEXT FIELD imaud02
             WHEN INFIELD(imaud03)
                CALL cl_dynamic_qry() RETURNING g_ima.imaud03
                DISPLAY BY NAME g_ima.imaud03
                NEXT FIELD imaud03
             WHEN INFIELD(imaud04)
                CALL cl_dynamic_qry() RETURNING g_ima.imaud04
                DISPLAY BY NAME g_ima.imaud04
                NEXT FIELD imaud04
             WHEN INFIELD(imaud05)
                CALL cl_dynamic_qry() RETURNING g_ima.imaud05
                DISPLAY BY NAME g_ima.imaud05
                NEXT FIELD imaud05
             WHEN INFIELD(imaud06)
                CALL cl_dynamic_qry() RETURNING g_ima.imaud06
                DISPLAY BY NAME g_ima.imaud06
                NEXT FIELD imaud06
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION prt_used_item_menu_referencet
           LET g_msg = 'ima01="',g_ima.ima01,'" '
           LET g_msg = "aimr180 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                       " 'Y' ' ' '1' ",
                       " '",g_msg,"' "
           CALL cl_cmdrun(g_msg)
 
        ON ACTION prt_item_used_other_group_code
           LET g_msg = 'ima01="',g_ima.ima01,'" '
           LET g_msg = "aimr182 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                       " 'Y' ' ' '1' ",
                       " '",g_msg,"' "
           CALL cl_cmdrun(g_msg)
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION update
            IF NOT cl_null(g_ima.ima01) THEN
               LET g_doc.column1 = "ima01"
               LET g_doc.value1 = g_ima.ima01
               CALL cl_fld_doc("ima04")
            END IF
 
         ON ACTION update_item
            CASE
               WHEN INFIELD(ima02)
                  CALL GET_FLDBUF(ima02) RETURNING g_ima.ima02
                  CALL p_itemname_update("ima_file","ima02",g_ima.ima01) #TQC-6C0060
                  LET g_on_change_02=FALSE
                  CALL cl_show_fld_cont()   #TQC-6C0060
               WHEN INFIELD(ima021)
                  CALL GET_FLDBUF(ima021) RETURNING g_ima.ima021
                  CALL p_itemname_update("ima_file","ima021",g_ima.ima01) #TQC-6C0060
                  LET g_on_change_021=FALSE
                  CALL cl_show_fld_cont()   #TQC-6C0060
            END CASE
 
         ON ACTION CONTROLF
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
 
    IF g_ima.imaag IS NOT NULL THEN
       CALL cl_set_act_visible("add_multi_attr_sub",TRUE)
    END IF
 
END FUNCTION
 
#FUN-A20037 --BEGIN--
FUNCTION i251_chk()
DEFINE l_gfe01    LIKE gfe_file.gfe01
DEFINE l_gfeacti  LIKE gfe_file.gfeacti

 LET g_errno= ""
 SELECT gfe01,gfeacti INTO l_gfe01,l_gfeacti FROM gfe_file
  WHERE gfe01 = g_ima.ima251 
 
  CASE 
   WHEN SQLCA.SQLCODE =100  LET g_errno = 'mfg0019'
   WHEN l_gfeacti ='N'      LET g_errno = 'aec-090' 
                            LET l_gfe01 = NULL
                            LET l_gfeacti = NULL
   OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-----'
  END CASE
END FUNCTION
#FUN-A20037 --END--

FUNCTION i100_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i100_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_ima.* TO NULL
        INITIALIZE g_ima_t.* TO NULL
        INITIALIZE g_ima_o.* TO NULL
        CALL cl_set_comp_visible("imaag",FALSE)                       #FUN-810016
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Searching!"
    OPEN aimi100_count
    FETCH aimi100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi100_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL
    ELSE
        CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
        CALL i100_list_fill()   #No.FUN-7C0010
        LET g_bp_flag = 'list'  #No.FUN-7C0010    
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION i100_fetch(p_flima)
    DEFINE
        p_flima          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flima
        WHEN 'N' FETCH NEXT     aimi100_curs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS aimi100_curs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    aimi100_curs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     aimi100_curs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN    #No.FUN-6A0061
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
            FETCH ABSOLUTE g_jump aimi100_curs INTO g_ima.ima01
            LET mi_no_ask = FALSE     #No.FUN-6A0061
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flima
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_ima.* FROM ima_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_ima.imauser      #FUN-4C0053
        LET g_data_group = g_ima.imagrup      #FUN-4C0053
        CALL i100_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i100_list_fill()
  DEFINE l_ima01         LIKE ima_file.ima01
  DEFINE l_i             LIKE type_file.num10
 
    CALL g_ima_l.clear()
    LET l_i = 1
    FOREACH aimi100_list_cur INTO l_ima01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT ima01,ima02,ima021,ima06,ima08,ima130,ima109,
              ima25,ima37,ima1010,imaacti,ima916
         INTO g_ima_l[l_i].*
         FROM ima_file
        WHERE ima01=l_ima01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_ima_l TO s_ima_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
END FUNCTION
 
FUNCTION i100_show()
   DEFINE l_avl_stk_mpsmrp  LIKE type_file.num15_3,     #No.FUN-A20044
          l_unavl_stk       LIKE type_file.num15_3,     #No.FUN-A20044
          l_avl_stk         LIKE type_file.num15_3      #No.FUN-A20044
 
   SELECT ima93 INTO g_ima.ima93 FROM ima_file
    WHERE ima01=g_ima.ima01
   LET g_ima_t.* = g_ima.*
#  LET g_d2=g_ima.ima262-g_ima.ima26      #FUN-A20044
   CALL s_getstock(g_ima.ima01,g_plant) RETURNING l_avl_stk_mpsmrp, l_unavl_stk,l_avl_stk  #FUN-A20044
   LET g_d2 = l_avl_stk - l_avl_stk_mpsmrp                                                 #FUN-A20044
 
   IF g_ima.ima151="Y" THEN
     CALL cl_set_comp_visible("imaag",TRUE)
   ELSE
     CALL cl_set_comp_visible("imaag",FALSE)
   END IF
 
   DISPLAY BY NAME g_ima.ima01  ,g_ima.ima06  ,g_ima.ima05  , g_ima.imaoriu,g_ima.imaorig,
                   g_ima.ima08  ,g_ima.imaag  ,g_ima.ima02  ,
                   g_ima.ima021 ,g_ima.ima03  ,g_ima.ima1010,
                   g_ima.ima39  ,g_ima.ima391 ,g_ima.ima149,g_ima.ima1491,g_ima.ima13  , #FUN-960141
                   g_ima.ima04  ,g_ima.ima14  ,g_ima.ima903 ,
                   g_ima.ima905 ,g_ima.ima24  ,g_ima.ima911 ,
                   g_ima.ima022,g_ima.ima251,      #FUN-A20037  
                   g_ima.ima70  ,g_ima.ima107 ,g_ima.ima147 ,
                   g_ima.ima15  ,g_ima.ima910 ,g_ima.ima105 ,
                   g_ima.ima07  ,g_ima.ima16  ,g_ima.ima109 ,
#                  g_ima.ima902 ,g_ima.ima37  ,g_ima.ima51  ,               #No.FUN-8C0131 
                   g_ima.ima902 ,g_ima.ima9021,g_ima.ima37  ,g_ima.ima51  , #No.FUN-8C0131
                   g_ima.ima52  ,g_ima.ima140 ,g_ima.ima09  ,
                   g_ima.ima10  ,g_ima.ima11  ,g_ima.ima12  ,
                   g_ima.ima25  ,g_ima.ima35  ,g_ima.ima36  ,
                   g_ima.ima23  ,
                   g_ima.ima918 ,g_ima.ima919 ,g_ima.ima920 ,  #No.FUN-810036
                   g_ima.ima921 ,g_ima.ima922 ,g_ima.ima923 ,  #No.FUN-810036
                   g_ima.ima924 ,g_ima.ima925 ,  #No.FUN-810036
                   g_ima.ima27  ,g_ima.ima28  ,
                   g_ima.ima271 ,g_ima.ima71  ,g_ima.ima901 ,
                   g_ima.ima881 ,g_ima.ima73  ,g_ima.ima74  ,
                   g_ima.ima29  ,g_ima.ima30  ,g_ima.ima93  ,
                   g_ima.ima915 ,                             #FUN-710060 add
                   g_ima.ima146 ,g_ima.ima906 ,g_ima.ima907 ,
                   g_ima.ima908 ,g_ima.imauser,g_ima.imagrup,
                   g_ima.imamodu,g_ima.imadate,g_ima.imaacti,
                   g_ima.imaud01,g_ima.imaud02,g_ima.imaud03,
                   g_ima.imaud04,g_ima.imaud05,g_ima.imaud06,
                   g_ima.imaud07,g_ima.imaud08,g_ima.imaud09,
                   g_ima.imaud10,g_ima.imaud11,g_ima.imaud12,
                   g_ima.imaud13,g_ima.imaud14,g_ima.imaud15,
                   g_ima.ima1001,g_ima.ima1002,g_ima.ima1012,
                  #g_ima.ima1013,g_ima.ima1015,g_ima.ima1014,  #CHI-CA0073 mark   
                   g_ima.ima1013,g_ima.ima1014,  #CHI-CA0073 add
                   g_ima.ima1016,g_ima.ima916                 #No.FUN-7C0010
                   ,g_ima.ima151                              #No.FUN-810016
   CALL i100_show_pic() #FUN-690060 add
 
   IF NOT cl_is_multi_feature_manage(g_ima.ima01) THEN
      CALL cl_set_act_visible("add_multi_attr_sub",FALSE)
   ELSE
      CALL cl_set_act_visible("add_multi_attr_sub",TRUE)
   END IF
 
   IF g_sma.sma120 != 'Y' THEN
      CALL cl_set_comp_visible("imaag",FALSE)
   END IF
 
   LET g_doc.column1 = "ima01"
   LET g_doc.value1 = g_ima.ima01
   CALL cl_get_fld_doc("ima04")
    LET g_gen02 = ""
    SELECT gen02 INTO g_gen02
      FROM gen_file
     WHERE gen01=g_ima.ima23
    DISPLAY g_gen02 TO FORMONLY.gen02
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_u()
    DEFINE l_imzacti  LIKE imz_file.imzacti
    DEFINE l_ima      RECORD LIKE ima_file.*   #FUN-B80032
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ima.ima01
    IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
       CALL cl_err(g_ima.ima916,'aoo-045',1)
       RETURN
    END IF
    IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_ima.ima01,'mfg1000',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ima01_t = g_ima.ima01
    LET g_ima_o.* = g_ima.*
    IF g_action_choice <> "reproduce" THEN    #FUN-680010
       BEGIN WORK
    END IF
 
    IF NOT i100_u_updchk() THEN  #carrier check?
       ROLLBACK WORK     #FUN-680010
       RETURN
    END IF
 
    CALL i100_show()                          # 顯示最新資料
    WHILE TRUE
       CALL cl_set_comp_visible("imaag",g_ima.ima151)  #No.FUN-810016
       CALL i100_i("u")                      # 欄位更改
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_ima.*=g_ima_t.*
           CALL i100_show()
           CALL cl_err('',9001,0)
           ROLLBACK WORK       #FUN-680010
           EXIT WHILE
       END IF
      #FUN-B80032---------STA-------
       SELECT * INTO l_ima.* 
         FROM ima_file 
        WHERE ima01 = g_ima.ima01
        IF l_ima.ima02 <> g_ima.ima02 OR l_ima.ima021 <> g_ima.ima021 
           OR l_ima.ima25 <> g_ima.ima25 OR l_ima.ima45 <> g_ima.ima45 
           OR l_ima.ima131 <> g_ima.ima131 OR l_ima.ima151 <> g_ima.ima151
           OR l_ima.ima154 <> g_ima.ima154 THEN
           IF g_aza.aza88 = 'Y' THEN
              UPDATE rte_file SET rtepos = '2' WHERE rte03 = g_ima.ima01 AND rtepos = '3'
           END IF 
       END IF 
      #FUN-B80032---------END-------       
       IF NOT i100_u_upd() THEN
          ROLLBACK WORK       #FUN-680010
          CONTINUE WHILE
       ELSE
          CALL i100_list_fill()  #No.FUN-7C0010
          COMMIT WORK
       END IF
       EXIT WHILE
    END WHILE
    CLOSE i100_cl
END FUNCTION
 
#FUN-6C0006 從_r()中抽出,成功刪除後的後續處理
FUNCTION i100_AFTER_DEL()
   OPEN aimi100_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE aimi100_curs
      CLOSE aimi100_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   FETCH aimi100_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE aimi100_curs
      CLOSE aimi100_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN aimi100_curs
   IF g_curs_index = g_row_count + 1 THEN
      LET g_jump = g_row_count
      CALL i100_fetch('L')
   ELSE
      LET g_jump = g_curs_index
      LET mi_no_ask = TRUE     #No.FUN-6A0061
      CALL i100_fetch('/')
   END IF
END FUNCTION
 
FUNCTION i100_copy()
   DEFINE l_flag LIKE type_file.num5
   DEFINE l_ima   RECORD LIKE ima_file.*
   DEFINE l_newno,l_oldno LIKE ima_file.ima01
 
   CALL i100_copy_input() RETURNING l_flag,l_newno
   IF l_flag THEN
      CALL i100_copy_default(l_newno) RETURNING l_ima.*
      LET l_ima.ima1001 = NULL    #No.FUN-640010
      LET l_ima.ima1002 = NULL    #No.FUN-640010
      IF i100_copy_insert(l_ima.*,l_newno) THEN
         LET l_oldno = g_ima.ima01
         SELECT ima_file.* INTO g_ima.* FROM ima_file
                        WHERE ima01 = l_newno
         CALL i100_u()
         CALL i100_copy_finish(l_newno,l_oldno)
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_init() #初始環境設定
 
   INITIALIZE g_ima.* TO NULL
   INITIALIZE g_ima_t.* TO NULL
   INITIALIZE g_ima_o.* TO NULL
   LET g_db_type=cl_db_get_database_type()
 
   IF g_aza.aza50='N' THEN
      CALL cl_set_comp_visible("page07",FALSE)
   ELSE                                                                                      
      CALL cl_set_comp_visible("page07",TRUE)
   END IF
 
   CALL cl_set_comp_visible("ima391,ima1491",g_aza.aza63='Y')  #FUN-680034 #FUN-960141
 
   CALL cl_set_comp_visible("ima910",g_sma.sma118='Y')
 
   CALL cl_set_comp_visible("imaag",g_sma.sma120 = 'Y')
 
   CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("ima908",g_sma.sma116 MATCHES '[123]')    #No.FUN-610076
   CALL cl_set_comp_visible("group044",g_sma.sma116 MATCHES '[123]' OR g_sma.sma115='Y')    #No.FUN-610076
   CALL i100_set_perlang()
 
   SELECT zx07,zx09 INTO l_zx07,l_zx09 FROM zx_file
    WHERE zx01 = g_user
   IF SQLCA.sqlcode THEN
      LET l_zx07 = 'N'
   END IF
 
    IF g_aza.aza60 = 'N' THEN #不使用客戶申請作業時,才可按確認/取消確認/新增
        CALL cl_set_act_visible("confirm,notconfirm,insert",TRUE)
    ELSE
        CALL cl_set_act_visible("confirm,notconfirm,insert",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i100_set_perlang()
   IF g_sma.sma115='Y' THEN
      IF g_sma.sma122='1' THEN
         CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
      END IF
      IF g_sma.sma122='2' THEN
         CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_default()
 
   LET g_ima.ima07 = 'A'
   LET g_ima.ima08 = 'P'
   LET g_ima.ima108 = 'N'
   LET g_ima.ima14 = 'N'
   LET g_ima.ima903= 'N' #NO:6872
   LET g_ima.ima905= 'N'
   LET g_ima.ima15 = 'N'
   LET g_ima.ima16 = 99
   LET g_ima.ima18 = 0
   LET g_ima.ima022 = 0  #FUN-A20037
   LET g_ima.ima09 =' '
   LET g_ima.ima10 =' '
   LET g_ima.ima11 =' '
   LET g_ima.ima12 =' '
   LET g_ima.ima23 = ' '
   LET g_ima.ima918= 'N'
   LET g_ima.ima919= 'N'
   LET g_ima.ima921= 'N'
   LET g_ima.ima922= 'N'
   LET g_ima.ima924= 'N'
   LET g_ima.ima24 = 'N'
   LET g_ima.ima911= 'N'   #FUN-610080
#  LET g_ima.ima26 = 0     #FUN-A20044 mark
#  LET g_ima.ima261 = 0    #FUN-A20044 mark
#  LET g_ima.ima262 = 0    #FUN-A20044 mark
   LET g_ima.ima27 = 0
   LET g_ima.ima271 = 0
   LET g_ima.ima28 = 0
   LET g_ima.ima30 = g_today #No:7643 新增 aimi100料號時應default ima30=料件建立日期,以便循環盤點機制
   LET g_ima.ima31_fac = 1
   LET g_ima.ima32 = 0
   LET g_ima.ima33 = 0
   LET g_ima.ima37 = '0'
   LET g_ima.ima38 = 0
   LET g_ima.ima40 = 0
   LET g_ima.ima41 = 0
   LET g_ima.ima42 = '0'
   LET g_ima.ima44_fac = 1
   LET g_ima.ima45 = 0
   LET g_ima.ima46 = 0
   LET g_ima.ima47 = 0
   LET g_ima.ima48 = 0
   LET g_ima.ima49 = 0
   LET g_ima.ima491 = 0
   LET g_ima.ima50 = 0
   LET g_ima.ima51 = 1
   LET g_ima.ima52 = 1
   LET g_ima.ima140 = 'N'
   LET g_ima.ima53 = 0
   LET g_ima.ima531 = 0
   LET g_ima.ima55_fac = 1
   LET g_ima.ima56 = 1
   LET g_ima.ima561 = 1  #最少生產數量
   LET g_ima.ima562 = 0  #生產時損耗率
   LET g_ima.ima57 = 0
   LET g_ima.ima58 = 0
   LET g_ima.ima59 = 0
   LET g_ima.ima60 = 0
   LET g_ima.ima61 = 0
   LET g_ima.ima62 = 0
   LET g_ima.ima63_fac = 1
   LET g_ima.ima64 = 1
   LET g_ima.ima641 = 1   #最少發料數量
   LET g_ima.ima65 = 0
   LET g_ima.ima66 = 0
   LET g_ima.ima68 = 0
   LET g_ima.ima69 = 0
   LET g_ima.ima70 = 'N'
   LET g_ima.ima107= 'N'
   LET g_ima.ima147= 'N' #BugNo:6542 add ima147
   LET g_ima.ima71 = 0
   LET g_ima.ima72 = 0
   LET g_ima.ima75 = ''
   LET g_ima.ima76 = ''
   LET g_ima.ima77 = 0
   LET g_ima.ima78 = 0
   LET g_ima.ima80 = 0
   LET g_ima.ima81 = 0
   LET g_ima.ima82 = 0
   LET g_ima.ima83 = 0
   LET g_ima.ima84 = 0
   LET g_ima.ima85 = 0
   LET g_ima.ima852= 'N'
   LET g_ima.ima853= 'N'
   LET g_ima.ima871 = 0
   LET g_ima.ima86_fac = 1
   LET g_ima.ima873 = 0
   LET g_ima.ima88 = 1
   LET g_ima.ima91 = 0
   LET g_ima.ima92 = 'N'
   LET g_ima.ima93 = "NNNNNNNN"
   LET g_ima.ima94 = ''
   LET g_ima.ima95 = 0
   LET g_ima.ima96 = 0
   LET g_ima.ima97 = 0
   LET g_ima.ima98 = 0
   LET g_ima.ima99 = 0
   LET g_ima.ima100 = 'N'
   LET g_ima.ima101 = '1'
   LET g_ima.ima102 = '1'
   LET g_ima.ima103 = '0'
   LET g_ima.ima104 = 0
   LET g_ima.ima910 = ' '  #FUN-550014
   LET g_ima.ima105 = 'N'
   LET g_ima.ima110 = '1'
   LET g_ima.ima139 = 'N'
   LET g_ima.imaacti= 'P' #P:Processing #FUN-690060
   LET g_ima.imauser= g_user
   LET g_ima.imaoriu = g_user #FUN-980030
   LET g_ima.imaorig = g_grup #FUN-980030
   LET g_ima.imagrup= g_grup                #使用者所屬群
   LET g_ima.imadate= g_today
   LET g_ima.ima901 = g_today               #料件建檔日期
   LET g_ima.ima912 = 0   #FUN-610080
   #產品資料
   LET g_ima.ima130 = '1'
   LET g_ima.ima121 = 0
   LET g_ima.ima122 = 0
   LET g_ima.ima123 = 0
   LET g_ima.ima124 = 0
   LET g_ima.ima125 = 0
   LET g_ima.ima126 = 0
   LET g_ima.ima127 = 0
   LET g_ima.ima128 = 0
   LET g_ima.ima129 = 0
   LET g_ima.ima141 = '0'
   LET g_ima.ima1010 = '0' #0:開立        #FUN-690060
   #單位控制部分
 
   IF g_sma.sma115 = 'Y' THEN
      IF g_sma.sma122 MATCHES '[13]' THEN
         LET g_ima.ima906 = '2'
      ELSE
         LET g_ima.ima906 = '3'
      END IF
   ELSE
      LET g_ima.ima906 = '1'
   END IF
   LET g_ima.ima909 = 0
   LET g_ima.ima1001 = ''
   LET g_ima.ima1002 = ''
   LET g_ima.ima1014 = '1'
   LET g_ima.ima916 = ' '
   LET g_ima.ima150 = ' '
   LET g_ima.ima151 = ' '
   LET g_ima.ima152 = ' '
   LET g_ima.ima918='N'
   LET g_ima.ima919='N'
   LET g_ima.ima921='N'
   LET g_ima.ima922='N'
   LET g_ima.ima924='N'
   LET g_ima.ima925='1'
   LET g_ima.ima916=g_plant  #No.FUN-7C0010
   LET g_ima.ima917=0        #No.FUN-7C0010
END FUNCTION
 
 
FUNCTION i100_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN        #No.FUN-550021
      CALL cl_set_comp_entry("ima01,ima25,ima910,ima55",TRUE) #FUN-550014 add ima910  BUG-530699 #MOD-560085 add ima55
      CALL cl_set_comp_visible("imaag",g_sma.sma120 = 'Y' )   #No.FUN-550021
      CALL cl_set_comp_entry("ima02,ima021",TRUE)             #FUN-690060
   END IF
 
   IF INFIELD(ima08) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ima13,ima903",TRUE)
   END IF
 
   IF (NOT g_before_input_done) THEN  #單位控制方式/計價單位 #FUN-540025
      CALL cl_set_comp_entry("ima906,ima907,ima908",TRUE)
   END IF
 
   IF INFIELD(ima906) OR (NOT g_before_input_done) THEN  #第二單位 #FUN-540025
      CALL cl_set_comp_entry("ima907",TRUE)
   END IF
 
   CALL cl_set_comp_entry("ima918,ima919,ima920,ima921",TRUE)   #No.MOD-840174
   CALL cl_set_comp_entry("ima922,ima923,ima924,ima925",TRUE)   #No.MOD-840174
   CALL cl_set_comp_entry('ima151',TRUE)     #No.FUN-830121
 
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE li_count  LIKE type_file.num5    #2005/05/11 FUN-550021 By Lifeng  #No.FUN-690026 SMALLINT
   DEFINE lc_sql    STRING                 #2005/05/11 FUN-550021 By Lifeng
   DEFINE l_errno   STRING                 #FUN-560112
   DEFINE l_n       LIKE type_file.num5   #No.MOD-840160
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ima01",FALSE)
   END IF
   #當參數設定使用料件申請作業時,修改時不可更改料號/品名/規格
   IF g_aza.aza60 = 'Y' AND p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ima01,ima02,ima021",FALSE)
   END IF
 
   IF p_cmd<>'a' THEN #MOD-570385
      CALL s_chkitmdel(g_ima.ima01) RETURNING l_errno
      CALL cl_set_comp_entry("ima25,ima906",cl_null(l_errno))   #No.FUN-610001  #有errmsg表示庫存單位不可修改狀態
      IF g_ima.imaag ='@CHILD' THEN 
         CALL cl_set_comp_entry("ima151",FALSE)
      END IF    
   END IF
 
   IF INFIELD(ima08) OR (NOT g_before_input_done) THEN
      IF g_ima.ima08 != 'T' THEN
         CALL cl_set_comp_entry("ima13",FALSE)
      END IF
      IF NOT (g_sma.sma104 = 'Y' AND g_ima.ima08 MATCHES "[MT]") THEN
         CALL cl_set_comp_entry("ima903",FALSE)
      END IF
   END IF
 
   IF NOT g_before_input_done THEN
      IF g_sma.sma118 !='Y' THEN
         CALL cl_set_comp_entry("ima910",FALSE)
      END IF
 
      IF g_sma.sma115 = 'N' THEN
         LET g_ima.ima906 = '1'
         LET g_ima.ima907 = NULL
         DISPLAY BY NAME g_ima.ima906,g_ima.ima907
         CALL cl_set_comp_entry("ima906,ima907",FALSE)
      ELSE
         IF cl_null(g_ima.ima907) THEN
            LET g_ima.ima907 = g_ima.ima25
            DISPLAY BY NAME g_ima.ima907
         END IF
      END IF
 
      IF g_sma.sma116 = '0' THEN     #No.FUN-610076
         LET g_ima.ima908 = NULL
         DISPLAY BY NAME g_ima.ima908
         CALL cl_set_comp_entry("ima908",FALSE)
      ELSE
         IF cl_null(g_ima.ima908) THEN
            LET g_ima.ima908 = g_ima.ima25
            DISPLAY BY NAME g_ima.ima908
         END IF
      END IF
   END IF
 
   IF (p_cmd = 'u' )AND( g_sma.sma120 = 'Y')  THEN
      IF g_ima.imaag = '@CHILD' THEN
         CALL cl_set_comp_visible("imaag",FALSE)
      ELSE
         #如果該料件已經包含了子料件則不允許修改他的屬性群組
         LET lc_sql = "SELECT COUNT(*) FROM ima_file WHERE imaag = '@CHILD' ",
                      "AND imaag1 = '",g_ima.imaag,"' AND ima01 LIKE '",
                      g_ima.ima01,"%' "
 
         DECLARE lcurs_qry_ima CURSOR FROM lc_sql
 
         OPEN lcurs_qry_ima
         FETCH lcurs_qry_ima INTO li_count
         IF li_count > 0 THEN
      CALL cl_set_comp_visible("imaag",FALSE)
         ELSE
            CALL cl_set_comp_visible("imaag",g_sma.sma120 = 'Y')
         END IF
         CLOSE lcurs_qry_ima
      END IF
   END IF
 
   IF g_ima.ima906 = '1' THEN
      LET g_ima.ima907 = NULL
      DISPLAY BY NAME g_ima.ima907
      CALL cl_set_comp_entry("ima907",FALSE)
   END IF
 
   SELECT COUNT(*) INTO l_n FROM imgs_file
    WHERE imgs01 = g_ima.ima01
   IF l_n > 0 THEN
      CALL cl_set_comp_entry("ima918,ima919,ima920,ima921",FALSE)
      CALL cl_set_comp_entry("ima922,ima923,ima924,ima925",FALSE)
   END IF
    
   IF g_ima.ima918 = 'N' THEN
      CALL cl_set_comp_entry("ima919",FALSE)
   END IF
 
   IF g_ima.ima919 = 'N' THEN
      CALL cl_set_comp_entry("ima920",FALSE)
   END IF
 
   IF g_ima.ima921 = 'N' THEN
      CALL cl_set_comp_entry("ima922,ima924",FALSE)
   END IF
 
   IF g_ima.ima922 = 'N' THEN
      CALL cl_set_comp_entry("ima923",FALSE)
   END IF
 
   IF g_ima.ima918 = 'N' AND g_ima.ima921 = 'N' THEN
      CALL cl_set_comp_entry("ima925",FALSE)
   END IF
END FUNCTION
 
FUNCTION i100_set_required()
 
   IF g_sma.sma115= 'Y' THEN
      CALL cl_set_comp_required("ima907",TRUE)
   END IF
 
   IF g_sma.sma116 MATCHES '[123]' THEN    #No.FUN-610076
      CALL cl_set_comp_required("ima908",TRUE)
   END IF
 
   IF g_ima.ima919 = "Y" THEN
      CALL cl_set_comp_required("ima920",TRUE)
   END IF
 
   IF g_ima.ima922 = "Y" THEN
      CALL cl_set_comp_required("ima923",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i100_set_no_required()
 
   CALL cl_set_comp_required("ima907",FALSE)
   CALL cl_set_comp_required("ima908",FALSE)
 
   CALL cl_set_comp_required("ima920,ima923",FALSE) #No.MOD-840257
 
END FUNCTION
 
FUNCTION i100_ima06(p_def) #MOD-490474
  DEFINE
     p_def          LIKE type_file.chr1,    #MOD-490474  #No.FUN-690026 VARCHAR(1)
     l_msg          LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(57)
     l_imzacti      LIKE imz_file.imzacti
 
   LET g_errno = ' '
   LET g_ans=' ' #FUN-5A0027 l_ans->g_ans
    SELECT imzacti INTO l_imzacti
      FROM imz_file
     WHERE imz01 = g_ima.ima06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
         WHEN l_imzacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF SQLCA.sqlcode =0 AND cl_null(g_errno) AND p_def = 'Y' THEN #MOD-490474
     #當輸入值與舊值不同時,才開出訊問視窗
     IF cl_null(g_ima_o.ima06) OR g_ima_o.ima06 != g_ima.ima06 THEN   #TQC-6C0026 add
      CALL cl_getmsg('mfg5033',g_lang) RETURNING l_msg
      CALL cl_confirm('mfg5033') RETURNING g_ans          #FUN-5A0027 l_ans->g_ans
      IF g_ans THEN                                       #FUN-5A0027 l_ans->g_ans
         CALL i100_set_rel_ima06() #FUN-860036
     END IF   #TQC-6C0026 add
    END IF
  END IF
END FUNCTION
 
#將imz_file相關欄位套用到ima_file,由i100_chk_ima06搬過來
FUNCTION i100_set_rel_ima06()
  DEFINE
     l_imz02        LIKE imz_file.imz02,
     l_imaacti      LIKE ima_file.imaacti,
     l_imauser      LIKE ima_file.imauser,
     l_imagrup      LIKE ima_file.imagrup,
     l_imamodu      LIKE ima_file.imamodu,
     l_imadate      LIKE ima_file.imadate
 
    SELECT imz01,imz02,imz03 ,imz04,
           imz07,imz08,imz09,imz10,
           imz11,imz12,imz14,imz15,
           imz17,imz19,imz21,
           imz23,imz24,imz25,imz27,
           imz28,imz31,imz31_fac,imz34,
           imz35,imz36,imz37,imz38,
           imz39,imz42,imz43,imz44,
           imz44_fac,imz45,imz46 ,imz47,
           imz48,imz49,imz491,imz50,
           imz51,imz52,imz54,imz55,
           imz55_fac,imz56,imz561,imz562,
           imz571,
           imz59 ,imz60,imz61,imz62,
           imz63,imz63_fac ,imz64,imz641,
           imz65,imz66,imz67,imz68,
           imz69,imz70,imz71,imz86,
           imz86_fac ,imz87,imz871,imz872,
           imz873,imz874,imz88,imz89,
           imz90,imz94,imz99,imz100 ,
           imz101,imz102 ,imz103,imz105,
           imz106,imz107,imz108,imz109,
           imz110,imz130,imz131,imz132,
           imz133,imz134,
           imz147,imz148,imz903,
           imzacti,imzuser,imzgrup,imzmodu,imzdate,
           imz906,imz907,imz908,imz909,
           imz911,
           imz136,imz137,imz391,imz1321,
           imz72,imz153,imz601,  #FUN-910053   #MOD-9C0032 add imz601
           imz926         #FUN-930108 add imz926
 
      INTO g_ima.ima06,l_imz02,g_ima.ima03,g_ima.ima04,
           g_ima.ima07,g_ima.ima08,g_ima.ima09,g_ima.ima10,
           g_ima.ima11,g_ima.ima12,g_ima.ima14,g_ima.ima15,
           g_ima.ima17,g_ima.ima19,g_ima.ima21,
           g_ima.ima23,g_ima.ima24,g_ima.ima25,g_ima.ima27, #No:7703 add ima24
           g_ima.ima28,g_ima.ima31,g_ima.ima31_fac,g_ima.ima34,
           g_ima.ima35,g_ima.ima36,g_ima.ima37,g_ima.ima38,
           g_ima.ima39,g_ima.ima42,g_ima.ima43,g_ima.ima44,
           g_ima.ima44_fac,g_ima.ima45,g_ima.ima46,g_ima.ima47,
           g_ima.ima48,g_ima.ima49,g_ima.ima491,g_ima.ima50,
           g_ima.ima51,g_ima.ima52,g_ima.ima54,g_ima.ima55,
           g_ima.ima55_fac,g_ima.ima56,g_ima.ima561,g_ima.ima562,
           g_ima.ima571,
           g_ima.ima59, g_ima.ima60,g_ima.ima61,g_ima.ima62,
           g_ima.ima63, g_ima.ima63_fac,g_ima.ima64,g_ima.ima641,
           g_ima.ima65, g_ima.ima66,g_ima.ima67,g_ima.ima68,
           g_ima.ima69, g_ima.ima70,g_ima.ima71,g_ima.ima86,
           g_ima.ima86_fac, g_ima.ima87,g_ima.ima871,g_ima.ima872,
           g_ima.ima873, g_ima.ima874,g_ima.ima88,g_ima.ima89,
           g_ima.ima90,g_ima.ima94,g_ima.ima99,g_ima.ima100,     #NO:6842養生
           g_ima.ima101,g_ima.ima102,g_ima.ima103,g_ima.ima105,  #NO:6842養生
           g_ima.ima106,g_ima.ima107,g_ima.ima108,g_ima.ima109,  #NO:6842養生
           g_ima.ima110,g_ima.ima130,g_ima.ima131,g_ima.ima132,  #NO:6842養生
           g_ima.ima133,g_ima.ima134,                            #NO:6842養生
           g_ima.ima147,g_ima.ima148,g_ima.ima903,
           l_imaacti,l_imauser,l_imagrup,l_imamodu,l_imadate,
           g_ima.ima906,g_ima.ima907,g_ima.ima908,g_ima.ima909,  #FUN-540025
           g_ima.ima911,                                         #FUN-610080 加ima911
           g_ima.ima136,g_ima.ima137,g_ima.ima391,g_ima.ima1321, #FUN-650004   #FUN-680034
           g_ima.ima915,g_ima.ima153,g_ima.ima601,               #FUN-710060 add #FUN-910053 add ima153 #MOD-9C0032 add ima601
           g_ima.ima926                                          #FUN-930108 add ima926
           FROM  imz_file
           WHERE imz01 = g_ima.ima06
   IF g_ima.ima99 IS NULL THEN LET g_ima.ima99 = 0 END IF
   IF g_ima.ima133 IS NULL THEN LET g_ima.ima133 = g_ima.ima01 END IF
   IF g_ima.ima01[1,4]='MISC' THEN #NO:6808(養生)
      LET g_ima.ima08='Z'
   END IF
END FUNCTION
 
#顯示料件處理狀況
FUNCTION i100_disp()
  DEFINE ls_tmp  STRING
  DEFINE i       LIKE type_file.num5,           #No.FUN-690026 SMALLINT
         a       ARRAY[8] OF LIKE ze_file.ze03, #No.FUN-690026 VARCHAR(8)
         l_disp1 LIKE ze_file.ze03,             #No.FUN-690026 VARCHAR(08)
         l_disp2 LIKE ze_file.ze03,             #No.FUN-690026 VARCHAR(08)
         l_msg   LIKE ze_file.ze03,             #No.FUN-690026 VARCHAR(40)
         l_ans   LIKE type_file.chr1            #No.FUN-690026 VARCHAR(1)
 
 
    OPEN WINDOW i100_w5 AT 9,43 WITH FORM "aim/42f/aimi1001"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    display 'aimi1001: g_lang = ',g_lang
    CALL cl_ui_locale("aimi1001")
 
    CALL cl_getmsg('mfg6059',g_lang) RETURNING l_disp1
    CALL cl_getmsg('mfg6060',g_lang) RETURNING l_disp2
    FOR i = 1 TO 8
        INITIALIZE a[i] TO NULL
    END FOR
    SELECT ima93 INTO g_ima.ima93 FROM ima_file WHERE ima01=g_ima.ima01
    FOR i = 1 TO 8
        IF g_ima.ima93[i,i] != 'Y' AND g_ima.ima93[i,i] != 'y'
                 OR g_ima.ima93[i,i] IS NULL THEN
             CASE
                 WHEN i = 1  LET a[i]=l_disp2
                 WHEN i = 2  LET a[i]=l_disp2
                 WHEN i = 3  LET a[i]=l_disp2
                 WHEN i = 4  LET a[i]=l_disp2
                 WHEN i = 5  LET a[i]=l_disp2
                 WHEN i = 6  LET a[i]=l_disp2
                 WHEN i = 7  LET a[i]=l_disp2
                 WHEN i = 8  LET a[i]=l_disp2
             END CASE
         ELSE
             CASE
                 WHEN i = 1  LET a[i]=l_disp1
                 WHEN i = 2  LET a[i]=l_disp1
                 WHEN i = 3  LET a[i]=l_disp1
                 WHEN i = 4  LET a[i]=l_disp1
                 WHEN i = 5  LET a[i]=l_disp1
                 WHEN i = 6  LET a[i]=l_disp1
                 WHEN i = 7  LET a[i]=l_disp1
                 WHEN i = 8  LET a[i]=l_disp1
             END CASE
          END IF
    END FOR
        DISPLAY a[1] TO FORMONLY.a
        DISPLAY a[2] TO FORMONLY.b
        DISPLAY a[3] TO FORMONLY.c
        DISPLAY a[4] TO FORMONLY.d
        DISPLAY a[5] TO FORMONLY.e
        DISPLAY a[6] TO FORMONLY.f
        DISPLAY a[7] TO FORMONLY.g
        DISPLAY a[8] TO FORMONLY.h
        MENU ""
         ON ACTION exit
             EXIT MENU
         ON ACTION cancel
             EXIT MENU
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU
 
        END MENU
 
        CLOSE WINDOW i100_w5
END FUNCTION
 
 
FUNCTION i100_x()
    DEFINE
        l_chr LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_n   LIKE type_file.num5     #No.FUN-690026 SMALLINT
    DEFINE l_prog   LIKE type_file.chr8    #FUN-870101 add 
    DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3,   #FUN-A20044
           l_unavl_stk      LIKE type_file.num15_3,   #FUN-A20044
           l_avl_stk        LIKE type_file.num15_3    #FUN-A20044           

    LET g_errno = ''   #FUN-5A0081
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
       CALL cl_err(g_ima.ima916,'aoo-045',1)
       RETURN
    END IF
    BEGIN WORK
    OPEN i100_cl USING g_ima.ima01
    FETCH i100_cl INTO g_ima.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       ROLLBACK WORK   #MOD-A10083
       CLOSE i100_cl   #MOD-A10083
       RETURN
    END IF
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   #FUN-A20044 add
 
#   IF g_ima.ima26  >0 THEN        #FUN-A20044
    IF l_avl_stk_mpsmrp > 0 THEN   #FUN-A20044 
       CALL cl_err('','mfg9165',0) 
       ROLLBACK WORK   #MOD-A10083
       CLOSE i100_cl   #MOD-A10083
       RETURN 
    END IF
#   IF g_ima.ima261 >0 THEN       #FUN-A20044
    IF l_unavl_stk > 0 THEN       #FUN-A20044 
       CALL cl_err('','mfg9166',0) 
       ROLLBACK WORK   #MOD-A10083
       CLOSE i100_cl   #MOD-A10083
       RETURN 
    END IF
#   IF g_ima.ima262 >0 THEN       #FUN-A20044
    IF l_avl_stk > 0 THEN         #FUN-A20044
       CALL cl_err('','mfg9167',0) 
       ROLLBACK WORK   #MOD-A10083
       CLOSE i100_cl   #MOD-A10083
       RETURN 
    END IF
 
    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM sfb_file     #判斷是否有工單
           WHERE sfb05 = g_ima.ima01 AND sfb04 < '8'   #No.MOD-940165 add   
             AND sfb87 != 'X'                           #No:MOD-9B0066 add
    IF cl_null(l_n) OR l_n = 0 THEN
       SELECT COUNT(*) INTO l_n FROM pmn_file,pmm_file  #判斷是否有採購單    #No:MOD-9B0066 add pmm_file
              WHERE pmn04 = g_ima.ima01 AND pmn16 < '6'
                AND pmn01 = pmm01 AND pmm18 != 'X'    #No:MOD-9B0066 add
       IF cl_null(l_n) OR l_n = 0 THEN
          SELECT COUNT(*) INTO l_n FROM oeb_file,oea_file   #判斷是否有訂單    #No:MOD-9B0066 add oea_file
                 WHERE oeb04 = g_ima.ima01 AND oeb70 != 'Y'
                   AND oeb01 = oea01 AND oeaconf !='X'   #No:MOD-9B0066 add
       END IF
    END IF
 
    IF NOT cl_null(l_n) AND l_n != 0 THEN
       IF NOT cl_confirm('aim-141') THEN
          ROLLBACK WORK   #MOD-A10083
          CLOSE i100_cl   #MOD-A10083
          RETURN
       END IF
    END IF
 
    SELECT COUNT(*) INTO l_n FROM img_file
     WHERE img01=g_ima.ima01
       AND img10 <>0
    IF l_n > 0 THEN 
       LET g_errno='mfg9163' 
       ROLLBACK WORK   #MOD-A10083
       CLOSE i100_cl   #MOD-A10083
       RETURN 
    END IF #MOD-5B0336 add RETURN
    IF cl_exp(0,0,g_ima.imaacti) THEN
        LET g_chr=g_ima.imaacti
        LET g_chr2=g_ima.ima1010   #No.FUN-610013
        CASE g_ima.ima1010
          WHEN '0' #開立
               IF g_ima.imaacti='N' THEN
                  LET g_ima.imaacti='P'
               ELSE
                  LET g_ima.imaacti='N'
               END IF
          WHEN '1' #確認
               IF g_ima.imaacti='N' THEN
                  LET g_ima.imaacti='Y'
               ELSE
                  LET g_ima.imaacti='N'
               END IF
         END CASE
        UPDATE ima_file
            SET imaacti=g_ima.imaacti,
                imamodu=g_user, imadate=g_today
            WHERE ima01 = g_ima.ima01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ima_file",g_ima_t.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            LET g_ima.imaacti=g_chr
            LET g_ima.ima1010=g_chr2      #No.FUN-610013
        END IF
        
        IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD 
           IF g_ima.imaacti='N' THEN 
              # CALL aws_mescli
              # 傳入參數: (1)程式代號
              #           (2)功能選項：insert(新增),update(修改),delete(刪除)
              #           (3)Key
              LET l_prog=''
              CASE g_ima.ima08
                 WHEN 'P' LET l_prog = 'aimi100' 
                 WHEN 'M' LET l_prog = 'axmi121'
                 OTHERWISE LET l_prog= ' '
              END CASE 
              CASE aws_mescli(l_prog,'delete',g_ima.ima01)
                 WHEN 0  #無與 MES 整合
                      CALL cl_msg('Delete O.K')
                 WHEN 1  #呼叫 MES 成功
                      CALL cl_msg('Delete O.K, Delete MES O.K')
                 WHEN 2  #呼叫 MES 失敗
                      RETURN FALSE
              END CASE
           END IF 
        END IF  #TQC-8B0011  ADD
 
        DISPLAY BY NAME g_ima.ima1010     #No.FUN-610013
        DISPLAY BY NAME g_ima.imaacti
        CALL i100_list_fill()             #No.FUN-7C0010
    END IF
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i100_r()
    DEFINE l_chr    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    DEFINE l_azo06  LIKE azo_file.azo06
    DEFINE l_n      LIKE type_file.num5    #FUN-980063
    
 
    IF s_shut(0) THEN RETURN FALSE END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN FALSE
    END IF
    IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'r') THEN
       CALL cl_err(g_ima.ima916,'aoo-044',1)
       RETURN FALSE
    END IF
   
    IF g_ima.imaacti = 'N' THEN
       #此筆資料已無效, 不可異動
       CALL cl_err(g_ima.ima01,'aim-153',1)
       RETURN FALSE
    END IF
    IF g_ima.imaacti = 'Y' THEN
       #此筆資料已確認
       CALL cl_err(g_ima.ima01,'9023',1)
       RETURN FALSE
    END IF
 
    BEGIN WORK
    OPEN i100_cl USING g_ima.ima01
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK    #FUN-680010     #FUN-B80070---回滾放在報錯後---
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       ROLLBACK WORK                     #FUN-B80070--add--
       RETURN FALSE
    END IF
    FETCH i100_cl INTO g_ima.*
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK    #FUN-680010    #FUN-B80070---回滾放在報錯後---
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       ROLLBACK WORK        #FUN-B80070--add--
       RETURN FALSE
    END IF
    CALL s_chkitmdel(g_ima.ima01) RETURNING g_errno
    IF NOT cl_null(g_errno) THEN
       ROLLBACK WORK    #FUN-6C0006
       CALL cl_err('',g_errno,0)
       RETURN FALSE
    END IF
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ima01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ima.ima01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        #No.FUN-550103 Start,如果當前料件是子料件則要刪除其在imx_file中對應的紀錄
        IF g_ima.imaag = '@CHILD' THEN
           DELETE FROM imx_file WHERE imx000 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imx_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              RETURN FALSE
           END IF
        END IF
 
        IF (NOT cl_del_itemname("ima_file","ima02", g_ima.ima01)) THEN   #CHI-6B0034
           ROLLBACK WORK
           RETURN              #TQC-710103
        END IF
        IF (NOT cl_del_itemname("ima_file","ima021",g_ima.ima01)) THEN   #CHI-6B0034
           ROLLBACK WORK
           RETURN              #TQC-710103
        END IF
 
        DELETE FROM ima_file WHERE ima01 = g_ima.ima01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
           ROLLBACK WORK  #NO.FUN-680010
           RETURN FALSE         #NO.FUN-680010
        ELSE
           CALL cl_del_pic("ima01",g_ima.ima01,"ima04")  #TQC-660041
            DELETE  FROM vmk_file where vmk01 = g_ima.ima01
            UPDATE ima_file SET imadate=g_today WHERE ima01 = g_ima.ima01
 
           DELETE FROM imc_file WHERE imc01 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imc_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              RETURN FALSE
           END IF
           DELETE FROM ind_file WHERE ind01 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","ind_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              RETURN FALSE
           END IF
           DELETE FROM imb_file WHERE imb01 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imb_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              RETURN FALSE
           END IF
           DELETE FROM smd_file WHERE smd01 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","smd_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              RETURN FALSE
           END IF
          DELETE FROM imt_file WHERE imt01 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imt_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              RETURN FALSE
           END IF
           DELETE FROM vmi_file WHERE vmi01 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","vmi_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              RETURN FALSE
           END IF
           UPDATE ima_file SET imadate=g_today WHERE ima01 = g_ima.ima01
          
           LET g_msg=TIME
           #增加記錄料號
           LET l_azo06='R: ',g_ima.ima01 CLIPPED
           INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #No.FUN-980004
             VALUES ('aimi100',g_user,g_today,g_msg,g_ima.ima01,l_azo06,g_plant,g_legal)   #MOD-940394 #No.FUN-980004  #mod by liuxqa 091020
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","aimi100","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              RETURN FALSE
           END IF
 
           # CALL aws_spccli_base()
           # 傳入參數: (1)TABLE名稱, (2)刪除資料,
           #           (3)功能選項：insert(新增),update(修改),delete(刪除)
           CASE aws_spccli_base('ima_file',base.TypeInfo.create(g_ima),'delete')
              WHEN 0  #無與 SPC 整合
                   MESSAGE 'DELETE O.K'
              WHEN 1  #呼叫 SPC 成功
                   MESSAGE 'DELETE O.K, DELETE SPC O.K'
              WHEN 2  #呼叫 SPC 失敗
                   ROLLBACK WORK
                   RETURN FALSE
           END CASE
 
           CLEAR FORM
           CALL i100_list_fill()        #No.FUN-7C0010
        END IF
       COMMIT WORK    #FUN-870101 mark #FUN-870166
       CLOSE i100_cl  #FUN-870101 mark #FUN-870166
       RETURN TRUE    #FUN-870101 mark #FUN-870166
    END IF
    CLOSE i100_cl
    RETURN FALSE
END FUNCTION
 
FUNCTION i100_out()
    DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-7C0043
 
    IF cl_null(g_wc) AND NOT cl_null(g_ima.ima01) THEN
        LET g_wc=" ima01='",g_ima.ima01,"'"
    END IF
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN
    END IF
 
    #報表轉為使用 p_query
    LET l_cmd = ' p_query "aimi100" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
    RETURN
END FUNCTION
 
FUNCTION i100_confirm()
 DEFINE l_imaag    LIKE ima_file.imaag    #No.TQC-640171
 DEFINE #l_sql      LIKE type_file.chr1000 #No.TQC-640171   #No.FUN-690026 VARCHAR(1000)
        l_sql      STRING     #NO.FUN-910082
 DEFINE l_prog     LIKE type_file.chr8    #FUN-870101 add
 
#CHI-C30107 --------------- add ------------- begin
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
      CALL cl_err(g_ima.ima916,'aoo-045',1)
      RETURN
   END IF
   IF g_ima.imaacti='Y' THEN
      CALL cl_err("",9023,1)
      RETURN
   END IF
   IF g_ima.imaacti='N' THEN
      #此筆資料已無效, 不可異動
      CALL cl_err('','aim-153',1)
   END IF
   IF NOT  cl_confirm('aap-222') THEN  RETURN END IF
   SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
#CHI-C30107 --------------- add -------------end
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
      CALL cl_err(g_ima.ima916,'aoo-045',1)
      RETURN
   END IF
   IF g_ima.imaacti='Y' THEN
      CALL cl_err("",9023,1)
      RETURN
   END IF
   IF g_ima.imaacti='N' THEN
      #此筆資料已無效, 不可異動
      CALL cl_err('','aim-153',1)
   ELSE
#   IF cl_confirm('aap-222') THEN   #CHI-C30107 mark
      BEGIN WORK
      UPDATE ima_file
         SET ima1010 = '1', #FUN-690060 mod #'1':確認
             imaacti = 'Y'  #FUN-690060 mod #'Y':確認
       WHERE ima01 = g_ima.ima01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                      "ima1010",1)  #No.FUN-660156
         ROLLBACK WORK
      ELSE
        LET g_ima.ima1010 = '1'
        LET g_ima.imaacti = 'Y'
        DISPLAY BY NAME g_ima.ima1010
        DISPLAY BY NAME g_ima.imaacti
 
       IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
          # CALL aws_mescli()
          # 傳入參數: (1)程式代號
          #           (2)功能選項：insert(新增),update(修改),delete(刪除)
          #           (3)Key
          LET l_prog=''
          CASE g_ima.ima08
             WHEN 'P' LET l_prog = 'aimi100' 
             WHEN 'M' LET l_prog = 'axmi121'
             OTHERWISE LET l_prog= ' '
          END CASE 
          CASE aws_mescli(l_prog,'insert',g_ima.ima01)
             WHEN 0  #無與 MES 整合
                  MESSAGE 'INSERT O.K'
             WHEN 1  #呼叫 MES 成功
                  MESSAGE 'INSERT O.K, INSERT MES O.K'
             WHEN 2  #呼叫 MES 失敗
                  RETURN FALSE
          END CASE
       END IF #TQC-8B0011  ADD
      END IF
 
      SELECT imaag INTO l_imaag
        FROM ima_file
       WHERE ima01 = g_ima.ima01
      IF l_imaag IS NULL OR l_imaag = '@CHILD' THEN
         COMMIT WORK #FUN-690060
         RETURN
      ELSE
         LET l_sql = " UPDATE ima_file SET ima1010 = '1',imaacti='Y' ", #FUN-690060 mod
                     "  WHERE ima01 LIKE '",g_ima.ima01,"_%'"
         PREPARE ima_cs3       FROM l_sql
         EXECUTE ima_cs3
         IF STATUS THEN
            CALL cl_err('ima1010',STATUS,1) #FUN-690060 0->1
            ROLLBACK WORK                   #FUN-690060 add
            RETURN
         END IF
      END IF
      CALL i100_list_fill()       #No.FUN-7C0010
      COMMIT WORK  #FUN-690060 add
#    END IF   #CHI-C30107
   END IF
END FUNCTION
 
FUNCTION i100_notconfirm()
 DEFINE l_imaag    LIKE ima_file.imaag    #No.TQC-640171
 DEFINE l_sql      STRING        #NO.FUN-910082
 DEFINE l_n        LIKE type_file.num5    #No.FUN-870117
 
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
      CALL cl_err(g_ima.ima916,'aoo-045',1)
      RETURN
   END IF
    SELECT COUNT(*) INTO l_n FROM imx_file WHERE imx00 = g_ima.ima01
    IF l_n > 0 THEN 
      CALL cl_err('','aim-451',1)
      RETURN 
    END  IF    
   IF g_ima.ima1010 != '1' OR g_ima.imaacti='N' THEN #FUN-690060 add
      #無效或尚未確認，不能取消確認
      CALL cl_err('','atm-365',0)
   ELSE
     #--NO.MOD-7B0076 start--料件取消確認時，比照刪除邏輯判斷
     CALL s_chkitmdel(g_ima.ima01) RETURNING g_errno
     IF NOT cl_null(g_errno) THEN
          CALL cl_err('',g_errno,1) RETURN
     END IF
    IF cl_confirm('aap-224') THEN
      BEGIN WORK
      UPDATE ima_file
         SET ima1010 = '0', #FUN-690060 mod
             imaacti = 'P'  #FUN-690060 mod
       WHERE ima01 = g_ima.ima01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                      "ima1010",1)  #No.FUN-660156
         ROLLBACK WORK
      ELSE
        LET g_ima.ima1010 = '0'
        LET g_ima.imaacti = 'P'
        DISPLAY BY NAME g_ima.ima1010
        DISPLAY BY NAME g_ima.imaacti
      END IF
      SELECT imaag INTO l_imaag
        FROM ima_file
       WHERE ima01 = g_ima.ima01
      IF l_imaag IS NULL OR l_imaag = '@CHILD' THEN
         COMMIT WORK #TQC-6C0159 add
         RETURN
      ELSE
         LET l_sql = " UPDATE ima_file SET ima1010 = '0',imaacti = 'P' ",  #FUN-690060 mod
                     "  WHERE ima01 LIKE '",g_ima.ima01,"_%'"
         PREPARE ima_cs4        FROM l_sql
         EXECUTE ima_cs4
         IF STATUS THEN
            CALL cl_err('ima1010',STATUS,0)
            ROLLBACK WORK   #FUN-690060 add
            RETURN
         END IF
      END IF
      CALL i100_list_fill()       #No.FUN-7C0010
      COMMIT WORK  #FUN-690060 add
    END IF
   END IF
END FUNCTION
 
FUNCTION i100_chk_cur(p_sql)
DEFINE p_sql STRING
DEFINE l_cnt LIKE type_file.num5
DEFINE l_result LIKE type_file.chr1
DEFINE l_dbase LIKE type_file.chr21
   IF NOT cl_null(g_dbase) THEN  #指定資料庫,Table Name 前面加上資料庫名稱,如果有兩個Tablename,則此處理必須改寫
      LET l_dbase=" FROM ",s_dbstring(g_dbase)           #TQC-940178 ADD 
      CALL cl_replace_once()
      LET p_sql=cl_replace_str(p_sql," FROM ",l_dbase)
      CALL cl_replace_init()
   END IF
   CALL cl_replace_sqldb(p_sql) RETURNING p_sql     #FUN-920032    #FUN-950007 add
   PREPARE i100_chk_cur_p FROM p_sql
   DECLARE i100_chk_cur_c CURSOR FOR i100_chk_cur_p
   OPEN i100_chk_cur_c
   FETCH i100_chk_cur_c INTO l_cnt
   IF SQLCA.sqlcode OR l_cnt=0 THEN
      LET l_result=FALSE
   ELSE
      LET l_result=TRUE
   END IF
   FREE i100_chk_cur_p
   CLOSE i100_chk_cur_c
   RETURN l_result
END FUNCTION
 
FUNCTION i100_chk_ima09()
   IF cl_null(g_ima.ima09) THEN
      RETURN TRUE
   END IF
   LET g_sql= #"SELECT azf01 FROM azf_file ", #FUN-5A0027
             "SELECT COUNT(*) FROM azf_file ", #FUN-5A0027
             " WHERE azf01='",g_ima.ima09,"' AND azf02='D' ", #6818
             " AND azfacti='Y'"
    IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","azf_file",g_ima.ima09,"","mfg1306","","",1)  #No.FUN-660156
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima09
         LET g_errary[g_cnt].field="ima09"
         LET g_errary[g_cnt].errno="mfg1306"
         RETURN TRUE
      END IF
      LET g_ima.ima09 = g_ima_o.ima09
      DISPLAY BY NAME g_ima.ima09
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima10()
   IF cl_null(g_ima.ima10) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT azf01 FROM azf_file #FUN-5A0027
             "SELECT COUNT(*) FROM azf_file ", #FUN-5A0027
             "WHERE azf01='",g_ima.ima10,"' AND azf02='E' ", #6818
             "AND azfacti='Y'"
    IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","azf_file",g_ima.ima10,"","mfg1306","","",1)  #No.FUN-660156
         LET g_ima.ima10 = g_ima_o.ima10
         DISPLAY BY NAME g_ima.ima10
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima10
         LET g_errary[g_cnt].field="ima10"
         LET g_errary[g_cnt].errno="mfg1306"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima11()
   IF cl_null(g_ima.ima11) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT azf01 FROM azf_file #FUN-5A0027
             "SELECT COUNT(*) FROM azf_file ", #FUN-5A0027
             "WHERE azf01='",g_ima.ima11,"' AND azf02='F' ", #6818
             "AND azfacti='Y'"
    IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","azf_file",g_ima.ima11,"","mfg1306","","",1)  #No.FUN-660156
         LET g_ima.ima11 = g_ima_o.ima11
         DISPLAY BY NAME g_ima.ima11
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima11
         LET g_errary[g_cnt].field="ima11"
         LET g_errary[g_cnt].errno="mfg1306"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima12()
   IF cl_null(g_ima.ima12) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT azf01 FROM azf_file , #FUN-5A0027
             "SELECT COUNT(*) FROM azf_file ", #FUN-5A0027
             "WHERE azf01='",g_ima.ima12,"' AND azf02='G' ", #6818
             "AND azfacti='Y'"
    IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","azf_file",g_ima.ima12,"","mfg1306","","",1)  #No.FUN-660156
         LET g_ima.ima12 = g_ima_o.ima12
         DISPLAY BY NAME g_ima.ima12
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima12
         LET g_errary[g_cnt].field="ima12"
         LET g_errary[g_cnt].errno="mfg1306"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima23()
   IF cl_null(g_ima.ima23) THEN
      RETURN TRUE
   END IF
   LET g_gen02 = ""                         #MOD-4A0326
   SELECT gen02 INTO g_gen02 FROM gen_file  #MOD-4A0326
   WHERE gen01=g_ima.ima23
     AND genacti='Y'
   DISPLAY g_gen02 TO FORMONLY.gen02        #MOD-4A0326
 
   LET g_sql="SELECT COUNT(*) FROM gen_file ",
             "WHERE gen01='",g_ima.ima23,"' ",
             "AND genacti='Y'"
 
    IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","gen_file",g_ima.ima23,"","aoo-001","","",1)  #No.FUN-660156
         LET g_ima.ima23 = g_ima_o.ima23       #MOD-4A0326
         DISPLAY BY NAME g_ima.ima23           #MOD-4A0326
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima23
         LET g_errary[g_cnt].field="ima23"
         LET g_errary[g_cnt].errno="aoo-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima25()
   IF cl_null(g_ima.ima25) THEN
      CALL cl_err(g_ima.ima25,'asf-031',1)  #No:MOD-9B0003 add
      RETURN FALSE    #No:MOD-9B0003 modify
   END IF
   LET g_sql= #SELECT gfe01 FROM gfe_file #FUN-5A0027
              "SELECT COUNT(*) FROM gfe_file ", #FUN-5A0027
              "WHERE gfe01='",g_ima.ima25,"' ",
              "AND gfeacti IN ('y','Y')"
    IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","gfe_file",g_ima.ima25,"","mfg1200","","",1)  #No.FUN-660156
         DISPLAY BY NAME g_ima.ima25
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima25
         LET g_errary[g_cnt].field="ima25"
         LET g_errary[g_cnt].errno="mfg1200"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima31()
   IF cl_null(g_ima.ima31) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT gfe01 FROM gfe_file #FUN-5A0027
             "SELECT COUNT(*) FROM gfe_file ", #FUN-5A0027
             "WHERE gfe01='",g_ima.ima31,"' ",
             "AND gfeacti IN ('y','Y')"
    IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","gfe_file",g_ima.ima31,"","mfg1311","","",1)  #No.FUN-660156
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima31
         LET g_errary[g_cnt].field="ima31"
         LET g_errary[g_cnt].errno="mfg1311"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima35()
   IF cl_null(g_ima.ima35) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM imd_file ", #FUN-5A0027
             "WHERE imd01='",g_ima.ima35,"' AND imdacti='Y'"
    IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","imd_file",g_ima.ima35,"","mfg1100","","",1)  #No.FUN-660156
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima35
         LET g_errary[g_cnt].field="ima35"
         LET g_errary[g_cnt].errno="mfg1100"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima39()
   IF cl_null(g_ima.ima39) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima39,"' ",
             "  AND aag07 <> '1'",              #No:8400 #MOD-490065將aag071改為aag07
             "  AND aag00 = '",g_aza.aza81,"'"  #No.FUN-730020
    IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         #CALL cl_err(g_ima.ima39,"anm-001",1)  #FUN-B10049
         CALL cl_err(g_ima.ima39,"anm-001",0)  #FUN-B10049 
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima39
         LET g_errary[g_cnt].field="ima39"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima391()
   IF cl_null(g_ima.ima391) THEN
      RETURN TRUE
   END IF
   IF g_aza.aza63 ='N' THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima391,"' ",
             "  AND aag07 <> '1'",              #No:8400 #MOD-490065將aag071改為aag07
             "  AND aag00 = '",g_aza.aza82,"'"  #No.FUN-730020
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         #CALL cl_err(g_ima.ima391,"anm-001",1)  #FUN-B10049
         CALL cl_err(g_ima.ima391,"anm-001",0)  #FUN-B10049
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima391
         LET g_errary[g_cnt].field="ima391"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima43()
   IF cl_null(g_ima.ima43) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gen_file ",
             "WHERE gen01='",g_ima.ima43,"' ",
             "AND genacti='Y'"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima43,'apm-048',1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima43
         LET g_errary[g_cnt].field="ima43"
         LET g_errary[g_cnt].errno="apm-048"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima44()
   IF cl_null(g_ima.ima44) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT gfe01 FROM gfe_file #FUN-5A0027
             "SELECT COUNT(*) FROM gfe_file ", #FUN-5A0027
             "WHERE gfe01='",g_ima.ima44,"' ",
             "AND gfeacti IN ('y','Y')"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","gfe_file",g_ima.ima44,"","apm-047","","",1)  #No.FUN-660156
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima44
         LET g_errary[g_cnt].field="ima44"
         LET g_errary[g_cnt].errno="apm-047"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima54()
   IF cl_null(g_ima.ima54) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM pmc_file ",
             "WHERE pmc01 = '",g_ima.ima54,"' ",
             "AND pmcacti='Y'"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima54,'mfg3001',1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima54
         LET g_errary[g_cnt].field="ima54"
         LET g_errary[g_cnt].errno="mfg3001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima55()
   IF cl_null(g_ima.ima55) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT gfe01 FROM gfe_file #FUN-5A0027
             "SELECT COUNT(*) FROM gfe_file ",
             "WHERE gfe01='",g_ima.ima55,"' ",
             "AND gfeacti IN ('y','Y')"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","gfe_file",g_ima.ima55,"","mfg1325","","",1)  #No.FUN-660156
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima55
         LET g_errary[g_cnt].field="ima55"
         LET g_errary[g_cnt].errno="mfg1325"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima571()
   IF cl_null(g_ima.ima571) THEN
      RETURN TRUE
   END IF
   IF g_ima.ima01=g_ima.ima571 THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM ecu_file ",
              "WHERE ecu01='",g_ima.ima571,"' "
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima571,'aec-014',1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima571
         LET g_errary[g_cnt].field="ima571"
         LET g_errary[g_cnt].errno="aec-014"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima63()
   IF cl_null(g_ima.ima63) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gfe_file ", #FUN-5A0027
             "WHERE gfe01='",g_ima.ima63,"' ",
             "AND gfeacti IN ('y','Y')"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","gfe_file",g_ima.ima63,"","mfg1326","","",1)  #No.FUN-660156
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima63
         LET g_errary[g_cnt].field="ima63"
         LET g_errary[g_cnt].errno="mfg1326"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima67()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_ima.ima67) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT COUNT(*) INTO l_cnt FROM gen_file #FUN-5A0027
             "SELECT COUNT(*) FROM gen_file ", #FUN-5A0027
             "WHERE gen01='",g_ima.ima67,"' ", #FUN-5A0027
             "AND genacti='Y'"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima67,'arm-045',1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima67
         LET g_errary[g_cnt].field="ima67"
         LET g_errary[g_cnt].errno="arm-045"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima86()
   IF cl_null(g_ima.ima86) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gfe_file ", #FUN-5A0027
             "WHERE gfe01='",g_ima.ima86,"' ",
             "AND gfeacti IN ('y','Y')"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","gfe_file",g_ima.ima86,"","mfg1203","","",1)  #No.FUN-660156
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima86
         LET g_errary[g_cnt].field="ima86"
         LET g_errary[g_cnt].errno="mfg1203"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima87()
   IF cl_null(g_ima.ima87) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT COUNT(*) INTO l_cnt #FUN-5A0027
             "SELECT COUNT(*) FROM smg_file ", #FUN-5A0027
             "WHERE smg01 = '",g_ima.ima87,"' ",
             "AND smgacti='Y'"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima87,'mfg1313',1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima87
         LET g_errary[g_cnt].field="ima87"
         LET g_errary[g_cnt].errno="mfg1313"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima872()
   IF cl_null(g_ima.ima872) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT COUNT(*) INTO l_cnt #FUN-5A0027
             "SELECT COUNT(*) FROM smg_file ", #FUN-5A0027
             "WHERE smg01 = '",g_ima.ima872,"' ",
             "AND smgacti='Y'"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima872,'mfg1313',1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima872
         LET g_errary[g_cnt].field="ima872"
         LET g_errary[g_cnt].errno="mfg1313"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima874()
   IF cl_null(g_ima.ima874) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT COUNT(*) INTO l_cnt #FUN-5A0027
             "SELECT COUNT(*) FROM smg_file ", #FUN-5A0027
             "WHERE smg01 = '",g_ima.ima874,"' ",
             "AND smgacti='Y'"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima874,'mfg1313',1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima874
         LET g_errary[g_cnt].field="ima874"
         LET g_errary[g_cnt].errno="mfg1313"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima109()
   IF cl_null(g_ima.ima109) THEN
      RETURN TRUE
   END IF
 
   CALL s_field_chk(g_ima.ima109,'1',g_plant,'ima109') RETURNING g_flag2
   IF g_flag2 = '0' THEN
      CALL cl_err(g_ima.ima109,'aoo-043',1)
      LET g_ima.ima109 = g_ima_o.ima109
      DISPLAY BY NAME g_ima.ima109
      RETURN FALSE
   END IF
 
   LET g_sql="SELECT COUNT(*) FROM azf_file ", #FUN-5A0027
             "WHERE azf01='",g_ima.ima109,"' AND azf02='8' ",
             "AND azfacti='Y'"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","azf_file",g_ima.ima109,"","mfg1306","","",1)  #No.FUN-660156
         LET g_ima.ima109 = g_ima_o.ima109
         DISPLAY BY NAME g_ima.ima109
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima109
         LET g_errary[g_cnt].field="ima109"
         LET g_errary[g_cnt].errno="mfg1306"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima131()
   IF cl_null(g_ima.ima131) THEN #FUN-5A0027
      RETURN TRUE
   END IF
 
   LET g_sql="SELECT COUNT(*) FROM oba_file ", #FUN-5A0027
             "WHERE oba01='",g_ima.ima131,"' "
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima131,'aim-142',1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima131
         LET g_errary[g_cnt].field="ima131"
         LET g_errary[g_cnt].errno="aim-142"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima132()
   IF cl_null(g_ima.ima132) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT count(*) INTO l_cnt FROM aag_file #FUN-5A0027
             "SELECT count(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima132,"' ",
             "  AND aag00 = '",g_aza.aza81,"'"  #No.FUN-730020
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima132,"anm-001",1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima132
         LET g_errary[g_cnt].field="ima132"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima133(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   IF cl_null(g_ima.ima133) THEN
      RETURN TRUE
   END IF
   IF p_cmd='u' THEN
      LET g_sql= #SELECT COUNT(*) INTO l_cnt FROM ima_file #FUN-5A0027
                "SELECT COUNT(*) FROM ima_file ",
                "WHERE ima01 = '",g_ima.ima133,"' "
      IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
         IF cl_null(g_dbase) THEN #FUN-5A0027
            CALL cl_err(g_ima.ima133,'axm-297',1)
            RETURN FALSE
         ELSE  #FUN-5A0027
            LET g_cnt=g_errary.getlength()+1
            LET g_errary[g_cnt].db=g_dbase
            LET g_errary[g_cnt].value=g_ima.ima133
            LET g_errary[g_cnt].field="ima133"
            LET g_errary[g_cnt].errno="axm-297"
            RETURN TRUE
         END IF
      ELSE
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima134()
   IF cl_null(g_ima.ima134) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT COUNT(*) INTO l_cnt FROM obe_file #FUN-5A0027
             "SELECT COUNT(*) FROM obe_file ",
             "WHERE obe01='",g_ima.ima134,"' "
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima134,'axm-810',1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima134
         LET g_errary[g_cnt].field="ima134"
         LET g_errary[g_cnt].errno="axm-810"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima136()
   IF cl_null(g_ima.ima136) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT COUNT(*) INTO l_cnt FROM imd_file  #FUN-5A0027
             "SELECT COUNT(*) FROM imd_file ",
             "WHERE imd01='",g_ima.ima136,"' ",
             "AND imdacti='Y'"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima136,'mfg1100',1)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima136
         LET g_errary[g_cnt].field="ima136"
         LET g_errary[g_cnt].errno="mfg1100"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima137()
   IF cl_null(g_ima.ima137) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01=g_ima.ima136 #FUN-5A0027
             "SELECT COUNT(*) FROM ime_file ", #FUN-5A0027
             "WHERE ime01='",g_ima.ima136,"' ",
             "AND ime02='",g_ima.ima137,"' "
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima137,'mfg1101',0)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima137
         LET g_errary[g_cnt].field="ima137"
         LET g_errary[g_cnt].errno="mfg1101"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima907(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE l_factor        LIKE img_file.img21
   IF cl_null(g_ima.ima907) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT gfe01 FROM gfe_file #FUN-5A0027
             "SELECT COUNT(*) FROM gfe_file ", #FUN-5A0027
             "WHERE gfe01='",g_ima.ima907,"' ",
             "AND gfeacti IN ('Y','y')"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","gfe_file",g_ima.ima907,"","mfg0019","","",1)  #No.FUN-660156
         LET g_ima.ima907 = g_ima_o.ima907
         DISPLAY BY NAME g_ima.ima907
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima907
         LET g_errary[g_cnt].field="ima907"
         LET g_errary[g_cnt].errno="mfg0019"
         RETURN TRUE
      END IF
   END IF
   #母子單位時,第二單位必須和ima25有轉換率
   CALL s_du_umfchk(g_ima.ima01,'','','',g_ima.ima25,
                    g_ima.ima907,g_ima.ima906)
        RETURNING g_errno,l_factor
   IF NOT cl_null(g_errno) THEN
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima01,g_errno,0)
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima907
         LET g_errary[g_cnt].field="ima907"
         LET g_errary[g_cnt].errno=g_errno
         RETURN TRUE
      END IF
   END IF
   IF cl_null(g_dbase) THEN #FUN-5A0027
      IF g_ima907 <> g_ima.ima907 AND g_ima907 IS NOT NULL AND p_cmd = 'u' THEN
         IF NOT cl_confirm('aim-999') THEN
            LET g_ima.ima907=g_ima907
            DISPLAY BY NAME g_ima.ima907
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima908(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE l_factor LIKE img_file.img21
 
   IF cl_null(g_ima.ima908) THEN
      RETURN TRUE
   END IF
   LET g_sql= #SELECT gfe01 FROM gfe_file #FUN-5A0027
             "SELECT COUNT(*) FROM gfe_file ", #FUN-5A0027
             "WHERE gfe01='",g_ima.ima908,"' ",
             "AND gfeacti IN ('Y','y')"
   IF NOT i100_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","gfe_file",g_ima.ima908,"","mfg0019","","",1)  #No.FUN-660156
         LET g_ima.ima908 = g_ima_o.ima908
         DISPLAY BY NAME g_ima.ima908
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima908
         LET g_errary[g_cnt].field="ima908"
         LET g_errary[g_cnt].errno="mfg0019"
         RETURN TRUE
      END IF
   END IF
   #計價單位時,計價單位必須和ima25有轉換率
   CALL s_du_umfchk(g_ima.ima01,'','','',g_ima.ima25,
                    g_ima.ima908,'2')
        RETURNING g_errno,l_factor
   IF NOT cl_null(g_errno) THEN
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err(g_ima.ima01,g_errno,1)   #TQC-6C0026 modify 0->1
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima908
         LET g_errary[g_cnt].field="ima908"
         LET g_errary[g_cnt].errno=g_errno
         RETURN TRUE
      END IF
   END IF
   IF cl_null(g_dbase) THEN #FUN-5A0027
      IF g_ima908 <> g_ima.ima908 AND g_ima908 IS NOT NULL AND p_cmd = 'u' THEN
         IF NOT cl_confirm('aim-999') THEN
            LET g_ima.ima908=g_ima908
            DISPLAY BY NAME g_ima.ima908
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_rel_ima06(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   IF NOT i100_chk_ima09() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima10() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima11() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima12() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima23() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima25() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima31() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima35() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima39() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima391() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima43() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima44() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima54() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima55() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima571() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima63() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima67() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima86() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima87() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima872() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima874() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima109() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima131() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima132() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima133(p_cmd) THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima134() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima136() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima137() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima907(p_cmd) THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima908(p_cmd) THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
#show 圖示
FUNCTION i100_show_pic()
     LET g_chr='N'
     LET g_chr1='N'
     LET g_chr2='N'
     IF g_ima.ima1010='1' THEN
         LET g_chr='Y'
     END IF
     CALL cl_set_field_pic1(g_chr,""  ,""  ,""  ,""  ,g_ima.imaacti,""    ,"")
                           #確認 ,核准,過帳,結案,作廢,有效         ,申請  ,留置
     #圖形顯示
END FUNCTION
 
FUNCTION i100_chkdb_ima06()
   IF cl_null(g_ima.ima06) THEN
      RETURN TRUE
   END IF
 
   LET g_sql="SELECT COUNT(*) FROM imz_file ",
             "WHERE imz01='",g_ima.ima06,"' ",
             "AND imzacti='Y'"
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err(g_ima.ima131,'mfg3179',1)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima06
         LET g_errary[g_cnt].field="ima06"
         LET g_errary[g_cnt].errno="mfg3179"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_upd_person()
  DEFINE l_ident   LIKE type_file.chr1
  DEFINE l_old     LIKE gen_file.gen01
  DEFINE l_new     LIKE gen_file.gen01
  DEFINE l_gen02_1 LIKE gen_file.gen02
  DEFINE l_gen02_2 LIKE gen_file.gen02
  DEFINE l_cnt     LIKE type_file.num5
 
  IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
     CALL cl_err(g_ima.ima916,'aoo-045',1)
     RETURN
  END IF
 
  OPEN WINDOW i1004_w AT 10,25 WITH FORM "aim/42f/aimi1004"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
  CALL cl_ui_locale("aimi1004")
 
  INPUT l_ident,l_old,l_new FROM FORMONLY.choice,FORMONLY.old,FORMONLY.new
      AFTER FIELD choice
          IF l_ident NOT MATCHES "[123]" THEN
            NEXT FIELD choice
          END IF
        CASE l_ident
          WHEN '1'
            LET l_old = g_ima.ima43
          WHEN '2'
            LET l_old = g_ima.ima23
          WHEN '3'
            LET l_old = g_ima.ima67
        END CASE
      BEFORE FIELD old
        DISPLAY l_old TO FORMONLY.old
      AFTER FIELD old
        IF cl_null(l_old) THEN
           NEXT FIELD old
        ELSE
           SELECT COUNT(*) INTO l_cnt FROM gen_file
            WHERE gen01 = l_old
           IF l_cnt = 0 THEN
             CALL cl_err('','aoo-017',1)
             NEXT FIELD old
           ELSE
             LET l_gen02_1 = ""
             SELECT gen02 INTO l_gen02_1
               FROM gen_file
              WHERE gen01=l_old
             DISPLAY l_gen02_1 TO FORMONLY.gen02_1
           END IF
        END IF
      AFTER FIELD new
        IF cl_null(l_new) THEN
           NEXT FIELD new
        ELSE
         SELECT COUNT(*) INTO l_cnt FROM gen_file
           WHERE gen01 = l_new
          IF l_cnt = 0 THEN
            CALL cl_err('','aoo-017',1)
            NEXT FIELD new
          ELSE
             LET l_gen02_2 = ""
             SELECT gen02 INTO l_gen02_2
               FROM gen_file
              WHERE gen01=l_new
             DISPLAY l_gen02_2 TO FORMONLY.gen02_2
          END IF
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
 
      ON ACTION controlp
        CASE
          WHEN INFIELD(old)
             CALL cl_init_qry_var()
             LET g_qryparam.form     = "q_gen"
             CALL cl_create_qry() RETURNING l_old
             DISPLAY l_old TO FORMONLY.old
             LET l_gen02_1 = ""
             SELECT gen02 INTO l_gen02_1
               FROM gen_file
              WHERE gen01=l_old
             DISPLAY l_gen02_1 TO FORMONLY.gen02_1
             NEXT FIELD old
 
          WHEN INFIELD(new)
             CALL cl_init_qry_var()
             LET g_qryparam.form     = "q_gen"
             CALL cl_create_qry() RETURNING l_new
             DISPLAY l_new TO FORMONLY.new
             LET l_gen02_2 = ""
             SELECT gen02 INTO l_gen02_2
               FROM gen_file
               WHERE gen01=l_new
               DISPLAY l_gen02_2 TO FORMONLY.gen02_2
             NEXT FIELD new
        END CASE
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW i1004_w
        RETURN
    END IF
 
    CASE l_ident
      WHEN "1" #採購員(ima43)
        UPDATE ima_file SET ima43 = l_new
         WHERE ima43 = l_old
      WHEN "2" #倉管員(ima23)
        UPDATE ima_file SET ima23 = l_new
         WHERE ima23 = l_old
      WHEN "3" #計劃員(ima67)
        UPDATE ima_file SET ima67 = l_new
         WHERE ima67 = l_old
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","ima_file",l_old,"",SQLCA.sqlcode,"","upd person",1)
    END IF
    CLOSE WINDOW i1004_w
    CASE l_ident
     WHEN "1"
      LET g_ima.ima43=l_new
     WHEN "2"
      LET g_ima.ima23=l_new
     WHEN "3"
      LET g_ima.ima67=l_new
    END CASE
END FUNCTION
 
FUNCTION i100_chk_ima01(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_ima01 STRING
 
   IF NOT cl_null(g_ima.ima01) THEN
      IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
        (p_cmd = "u" AND g_ima.ima01 != g_ima01_t) THEN
          SELECT COUNT(*) INTO l_cnt FROM ima_file
              WHERE ima01 = g_ima.ima01
          IF l_cnt > 0 THEN                  # Duplicated
              CALL cl_err(g_ima.ima01,-239,0)
              LET g_ima.ima01 = g_ima01_t
              DISPLAY BY NAME g_ima.ima01
              RETURN FALSE
          END IF
          LET l_ima01 = g_ima.ima01
          IF l_ima01.getIndexOf("*",1) OR l_ima01.getIndexOf(":",1)
             OR l_ima01.getIndexOf("|",1) OR l_ima01.getIndexOf("?",1)
             OR l_ima01.getIndexOf("!",1) OR l_ima01.getIndexOf("%",1)
             OR l_ima01.getIndexOf("&",1) OR l_ima01.getIndexOf("^",1)
             OR l_ima01.getIndexOf("<",1) OR l_ima01.getIndexOf(">",1) THEN
             CALL cl_err(g_ima.ima01,"aim-122",0)
             LET g_ima.ima01 = g_ima01_t
             DISPLAY BY NAME g_ima.ima01
             RETURN FALSE
          END IF
      END IF
      IF cl_null(g_ima.ima571) THEN    #No.MOD-790164 add
         LET g_ima.ima571 = g_ima.ima01
      END IF        #No.MOD-790164 add
      IF g_ima.ima01[1,4]='MISC' AND
          (NOT cl_null(g_ima.ima01[5,10])) THEN    #NO:6808(養生)
          SELECT COUNT(*) INTO l_cnt FROM ima_file   #至少要有一筆'MISC'先存在
           WHERE ima01='MISC'                      #才可以打其它MISCXX資料
          IF l_cnt=0 THEN
             CALL cl_err('','aim-806',1)
             RETURN FALSE
          END IF
      END IF
      IF g_ima.ima01[1,4]='MISC' THEN
          LET g_ima.ima08='Z'
          DISPLAY BY NAME g_ima.ima08
      END IF
     #CHI-CA0073 mark START 
     #SELECT ima1015 INTO g_ima.ima1015
     #  FROM ima_file
     # WHERE ima01=g_ima.ima01
     #DISPLAY BY NAME g_ima.ima1015
     #CHI-CA0073 mark END 
      CALL s_field_chk(g_ima.ima01,'1',g_plant,'ima01') RETURNING g_flag2
      IF g_flag2 = '0' THEN
         CALL cl_err(g_ima.ima01,'aoo-043',1)
         LET g_ima.ima01 = g_ima01_t
         DISPLAY BY NAME g_ima.ima01
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chg_ima02()
   IF g_aza.aza44 = "Y" THEN
      IF g_zx14 = "Y" AND g_on_change_02 THEN
         CALL p_itemname_update("ima_file","ima02",g_ima.ima01) #TQC-6C0060
         CALL cl_show_fld_cont()   #TQC-6C0060
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_chg_ima021()
   IF g_aza.aza44 = "Y" THEN
      IF g_zx14 = "Y" AND g_on_change_021 THEN
         CALL p_itemname_update("ima_file","ima021",g_ima.ima01) #TQC-6C0060
         CALL cl_show_fld_cont()   #TQC-6C0060
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima06(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_n   LIKE type_file.num5  #MOD-870225
 
   IF g_ima.ima06 IS NOT NULL AND  g_ima.ima06 != ' ' THEN  #MOD-490474
      IF (g_ima_o.ima06 IS NULL) OR (g_ima.ima06 != g_ima_o.ima06) THEN #MOD-490474
         IF p_cmd='u' THEN #FUN-650045
            CALL s_chkitmdel(g_ima.ima01) RETURNING g_errno
         ELSE
            LET g_errno=NULL
         END IF
         IF cl_null(g_errno) THEN #FUN-650045
            LET g_ans = ''
            CALL i100_ima06('Y') #default 預設值
            IF g_ans="1" THEN #FUN-5A0027
               IF NOT i100_chk_rel_ima06(p_cmd) THEN
                  LET g_ima_o.ima06 = g_ima.ima06   #TQC-6C0026 add  #後面有要用到g_ima_o.ima06判斷,所以這邊要先給值
                  RETURN FALSE
               END IF
            END IF
         ELSE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1) #只提示
            END IF
            #若單據還原後,單純改分群碼
            IF g_errno='mfg9199' THEN
              LET l_n=0
              SELECT COUNT(*) INTO l_n FROM tlf_file 
               WHERE tlf01 = g_ima.ima01
              IF l_n=0 THEN 
                 IF NOT cl_confirm('mfg9187') THEN
                    LET g_ans='1'
                    RETURN TRUE
                 END IF
              END IF 
            END IF 
            CALL i100_ima06('N') #只check 對錯,不詢問
         END IF
      ELSE
         CALL i100_ima06('N') #只check 對錯,不詢問
      END IF #No:7062
      CALL s_field_chk(g_ima.ima06,'1',g_plant,'ima06') RETURNING g_flag2
      IF g_flag2 = '0' THEN
         LET g_errno = 'aoo-043'
      END IF
 
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_ima.ima06,g_errno,0)
         LET g_ima.ima06 = g_ima_o.ima06
         DISPLAY BY NAME g_ima.ima06
         RETURN FALSE
      END IF
   END IF
   LET g_ima_o.ima06 = g_ima.ima06
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_imaag()
   DEFINE l_cnt LIKE type_file.num5
 
   IF NOT cl_null(g_ima.imaag) THEN
      SELECT count(*) INTO l_cnt FROM aga_file
          WHERE aga01 = g_ima.imaag
      IF l_cnt <= 0 THEN
          CALL cl_err('','aim-910',1)
          RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima08(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_misc LIKE type_file.chr4
   DEFINE l_cnt  LIKE type_file.num5     #No.MOD-940259 add
 
   IF NOT cl_null(g_ima.ima08) THEN
      IF g_ima_o.ima08 != g_ima.ima08 AND NOT cl_null(g_ima_o.ima08) THEN
         IF g_ima_o.ima08 MATCHES "[PVZ]" THEN
            SELECT COUNT(*) INTO l_cnt FROM bma_file,bmb_file,ima_file
                   WHERE bmb03 = g_ima.ima01
                     AND (bmb05 IS NULL OR bmb05 >= g_today)
                     AND bmb01 = bma01 AND bmb29 = bma06
                     AND bma05 IS NOT NULL
                     AND bma01 = ima01
                     AND ima08 IN ('P','V','Z')
 
            IF l_cnt > 0  AND g_ima.ima08 NOT MATCHES "[PVZ]" THEN
               CALL cl_err('','abm-043',1)
               RETURN FALSE
            END IF
         END  IF
      END IF
 
      IF g_ima.ima08 NOT MATCHES "[CTDAMPXKUVZS]"
           OR g_ima.ima08 IS NULL
         THEN CALL cl_err(g_ima.ima08,'mfg1001',0)
              LET g_ima.ima08 = g_ima_o.ima08
              DISPLAY BY NAME g_ima.ima08
              RETURN FALSE
         ELSE IF g_ima.ima08 != 'T' THEN
                 LET g_ima.ima13 = NULL
                 DISPLAY BY NAME g_ima.ima13
              END IF
      END IF
      #NO:6808(養生)
      LET l_misc=g_ima.ima01[1,4]
      IF l_misc='MISC' AND g_ima.ima08 <>'Z' THEN
          CALL cl_err('','aim-805',0)
          RETURN FALSE
      END IF
      LET g_ima_o.ima08 = g_ima.ima08
      IF g_ima.ima08 NOT MATCHES "[MT]" THEN #NO:6872
          LET g_ima.ima903 = 'N'
          LET g_ima.ima905 = 'N'
          DISPLAY BY NAME g_ima.ima903,g_ima.ima905
      END IF
   END IF
   CALL i100_set_no_entry(p_cmd)
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima13()
   IF NOT cl_null(g_ima.ima13) THEN
       IF (g_ima.ima08 = 'T') AND (g_ima.ima13 IS NULL
                 OR g_ima.ima13 = ' ' )
         THEN CALL cl_err(g_ima.ima13,'mfg1327',0)
              LET g_ima.ima13 = g_ima_o.ima13
              DISPLAY BY NAME g_ima.ima13
              RETURN FALSE
       END IF
       IF g_ima.ima18 IS NOT NULL
          THEN IF (g_ima_o.ima13 IS NULL ) OR (g_ima_o.ima13 != g_ima.ima13)
                 THEN SELECT ima08 FROM ima_file
                                    WHERE ima01 = g_ima.ima13
                                      AND ima08 = 'C'
                                      AND imaacti IN ('Y','y')
                      IF SQLCA.sqlcode != 0 THEN
                         CALL cl_err3("sel","ima_file",g_ima.ima13,"",
                                       "mfg1328","","",1)  #No.FUN-660156
                         LET g_ima.ima13 = g_ima_o.ima13
                         DISPLAY BY NAME g_ima.ima13
                         RETURN FALSE
                      END IF
              END IF
       END IF
   END IF
   LET g_ima_o.ima13 = g_ima.ima13
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima14()
   IF NOT cl_null(g_ima.ima14) THEN
      IF g_ima.ima14 NOT MATCHES "[YN]" THEN
         CALL cl_err(g_ima.ima14,'mfg1002',0)
         LET g_ima.ima14 = g_ima_o.ima14
         DISPLAY BY NAME g_ima.ima14
         RETURN FALSE
      END IF
   END IF
   LET g_ima_o.ima14 = g_ima.ima14
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima903()
   IF NOT cl_null(g_ima.ima903) THEN
      IF g_ima.ima903 NOT MATCHES "[YN]" THEN
         CALL cl_err(g_ima.ima903,'mfg1002',0)
         LET g_ima.ima903 = g_ima_o.ima903
         DISPLAY BY NAME g_ima.ima903
         RETURN FALSE
      END IF
      LET g_ima_o.ima903 = g_ima.ima903
      IF cl_null(g_ima.ima905) THEN
          LET g_ima.ima905 = 'N'
          DISPLAY BY NAME g_ima.ima905
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima36()
    IF g_ima.ima36 !=' ' AND g_ima.ima36 IS NOT NULL THEN
       SELECT * FROM ime_file WHERE ime01=g_ima.ima35
          AND ime02=g_ima.ima36
       IF SQLCA.SQLCODE THEN
          CALL cl_err3("sel","ime_file",g_ima.ima36,"","mfg1101",
                       "","",1)  #No.FUN-660156
          RETURN FALSE
       END IF
    END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima37()
   IF NOT cl_null(g_ima.ima37) THEN
      IF g_ima.ima37 NOT MATCHES "[0123456]" THEN                #No.FUN-810016
          CALL cl_err(g_ima.ima37,'mfg1003',0)
          LET g_ima.ima37 = g_ima_o.ima37
          DISPLAY BY NAME g_ima.ima37
          RETURN FALSE
      END IF
      #--->補貨策略碼為'0'(再訂購點),'5'(期間採購)
      IF ( g_ima.ima37='0' OR g_ima.ima37 ='5' )
         AND ( g_ima.ima08 NOT MATCHES '[MSPVZ]' ) THEN
         CALL cl_err(g_ima.ima37,'mfg3201',0)
         LET g_ima.ima37 = g_ima_o.ima37
         DISPLAY BY NAME g_ima.ima37
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima07()
   IF NOT cl_null(g_ima.ima07) THEN
      IF g_ima.ima07 NOT MATCHES'[ABC]' THEN
          CALL cl_err(g_ima.ima07,'mfg0009',0)
          LET g_ima.ima07 = g_ima_o.ima07
          DISPLAY BY NAME g_ima.ima07
          RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima51()
   IF NOT cl_null(g_ima.ima51) THEN
      IF g_ima.ima51 <= 0
      THEN CALL cl_err(g_ima.ima51,'mfg1322',0)
           LET g_ima.ima51 = g_ima_o.ima51
           DISPLAY BY NAME g_ima.ima51
           RETURN FALSE
      END IF
    ELSE #MOD-4A0098
      LET g_ima.ima51 = 1
      DISPLAY BY NAME g_ima.ima51
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima52()
   IF NOT cl_null(g_ima.ima52) THEN #MOD-4A0098
     IF g_ima.ima52 <= 0 THEN
        CALL cl_err(g_ima.ima52,'mfg1322',0)
        LET g_ima.ima52 = g_ima_o.ima52
        DISPLAY BY NAME g_ima.ima52
        RETURN FALSE
     END IF
   ELSE #MOD-4A0098
     LET g_ima.ima52 = 1
     DISPLAY BY NAME g_ima.ima52
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima906(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
 
   IF NOT cl_null(g_ima.ima906) THEN
      IF g_sma.sma115 = 'Y' THEN
         IF g_ima.ima906 IS NULL THEN
            CALL cl_err(g_ima.ima906,'aim-998',0)
            RETURN FALSE
         END IF
         IF g_sma.sma122 = '1' THEN
            IF g_ima.ima906 = '3' THEN
               CALL cl_err('','asm-322',1)
               RETURN FALSE
            END IF
         END IF
         IF g_sma.sma122 = '2' THEN
            IF g_ima.ima906 = '2' THEN
               CALL cl_err('','asm-323',1)
               RETURN FALSE
            END IF
         END IF
         IF g_ima.ima906 <> '1' THEN
            IF cl_null(g_ima.ima907) THEN
               LET g_ima.ima907 = g_ima.ima25
               DISPLAY BY NAME g_ima.ima907
            END IF
         END IF
         IF g_sma.sma116 MATCHES '[123]' THEN    #No.FUN-610076
            IF cl_null(g_ima.ima908) THEN
               LET g_ima.ima908 = g_ima.ima25
               DISPLAY BY NAME g_ima.ima908
            END IF
         END IF
      END IF
      IF g_ima906 <> g_ima.ima906 AND g_ima906 IS NOT NULL AND p_cmd = 'u' THEN
         IF NOT cl_confirm('aim-999') THEN
            LET g_ima.ima906=g_ima906
            DISPLAY BY NAME g_ima.ima906
            RETURN FALSE
         END IF
      END IF
   END IF
   CALL i100_set_no_entry(p_cmd)
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_copy_input()
   DEFINE l_newno LIKE ima_file.ima01
   DEFINE l_n     LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN FALSE,NULL
    END IF
 
    LET g_before_input_done = FALSE
    CALL i100_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM ima01
      BEFORE FIELD ima01
          IF g_sma.sma60 = 'Y' THEN      # 若須分段輸入
             CALL s_inp5(6,14,l_newno) RETURNING l_newno
             DISPLAY l_newno TO ima01
          END IF
 
      AFTER FIELD ima01
          IF l_newno IS NULL THEN
              NEXT FIELD ima01
          END IF
          SELECT count(*) INTO g_cnt FROM ima_file
              WHERE ima01 = l_newno
          IF g_cnt > 0 THEN
              CALL cl_err(l_newno,-239,0)
              NEXT FIELD ima01
          END IF
          CALL s_field_chk(l_newno,'1',g_plant,'ima01') RETURNING g_flag2
          IF g_flag2 = '0' THEN
             CALL cl_err(l_newno,'aoo-043',1)
             NEXT FIELD ima01
          END IF
          IF l_newno[1,4]='MISC' AND
              (NOT cl_null(l_newno[5,10])) THEN        #NO:6808(養生)
              SELECT COUNT(*) INTO l_n FROM ima_file   #至少要有一筆'MISC'先存
               WHERE ima01='MISC'                      #才可以打其它MISCXX資料
              IF l_n=0 THEN
                 CALL cl_err('','aim-806',1)
                 NEXT FIELD ima01
              END IF
          END IF
          IF l_newno[1,4]='MISC' THEN
              LET g_ima.ima08='Z'
              DISPLAY BY NAME g_ima.ima08
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
 
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_ima.ima01
        RETURN FALSE,NULL
    END IF
   #No.B018 010322 by plum 增加再次詢問的確定,以免不必要的新增
    IF NOT cl_confirm('mfg-003') THEN
       RETURN FALSE,NULL
    END IF
   #MESSAGE '新增料件基本資料中....!'
    CALL cl_err('','aim-993','0')
    RETURN TRUE,l_newno
END FUNCTION
 
FUNCTION i100_copy_default(l_newno)
   DEFINE l_ima RECORD LIKE ima_file.*
   DEFINE l_newno LIKE ima_file.ima01
 
   #No.B018 010322 by plum 將漏掉的補入,參考i100_default
    LET l_ima.* = g_ima.*
    LET l_ima.ima01  =l_newno   #資料鍵值
    LET l_ima.ima05  =NULL      #目前使用版本
    LET l_ima.ima18  =0
    LET l_ima.ima16  =99         #NO:6973
#   LET l_ima.ima26  =0         #MPS/MRP可用庫存數量     #No.FUN-A20044 mark
#   LET l_ima.ima261 =0         #不可用庫存數量          #No.FUN-A20044 mark  
#   LET l_ima.ima262 =0         #庫存可用數量            #No.FUN-A20044 mark
    LET l_ima.ima29  =NULL      #最近易動日期
    LET l_ima.ima30  =NULL      #最近盤點日期
    LET l_ima.ima32  =0         #標準售價
    LET l_ima.ima33  =0         #最近售價
    LET l_ima.ima40  =0         #累計使用數量 期間
    LET l_ima.ima41  =0         #累計使用數量 年度
    LET l_ima.ima47  =0         #採購損耗率
    LET l_ima.ima52  =1         #平均訂購量
    LET l_ima.ima140 ='N'       #phase out
    LET l_ima.ima53  =0         #最近採購單價
    LET l_ima.ima531 =0         #市價
    LET l_ima.ima532 =NULL      #市價最近異動日期
    LET l_ima.ima562 =0         #生產損耗率
    LET l_ima.ima73  =NULL      #最近入庫日期
    LET l_ima.ima74  =NULL      #最近出庫日期
    LET l_ima.ima75  =''        #海關編號
    LET l_ima.ima76  =''        #商品類別
    LET l_ima.ima77  =0         #在途量
    LET l_ima.ima78  =0         #在驗量
    LET l_ima.ima80  =0         #未耗預測量
    LET l_ima.ima81  =0         #確認生產量
    LET l_ima.ima82  =0         #計劃量
    LET l_ima.ima83  =0         #MRP需求量
    LET l_ima.ima84  =0         #OM 銷單備置量
    LET l_ima.ima85  =0         #MFP銷單備置量
    LET l_ima.ima881 =NULL      #期間採購最近採購日期
    LET l_ima.ima91  =0         #平均採購單價
    LET l_ima.ima92  ='N'       #net change status
    LET l_ima.ima93  ='NNNNNNNN'#new parts status
    LET l_ima.ima94  =''        #
    LET l_ima.ima95  =0         #
    LET l_ima.ima96  =0         #A. T. P. 量
    LET l_ima.ima97  =0         #MFG 接單量
    LET l_ima.ima98  =0         #OM 接單量
    LET l_ima.ima104 =0         #廠商分配起始量
    LET l_ima.ima901 = g_today  #料件建檔日期
    LET l_ima.ima902 = NULL     #NO:6973
    LET l_ima.ima9021 = NULL    #No.FUN-8C0131
    LET l_ima.ima121 = 0        #單位材料成本
    LET l_ima.ima122 = 0        #單位人工成本
    LET l_ima.ima123 = 0        #單位製造費用
    LET l_ima.ima124 = 0        #單位管銷成本
    LET l_ima.ima125 = 0        #單位成本
    LET l_ima.ima126 = 0        #單位利潤率
    LET l_ima.ima127 = 0        #未稅訂價(本幣)
    LET l_ima.ima128 = 0        #含稅訂價(本幣)
    LET l_ima.ima132 = NULL     #費用科目編號
    LET l_ima.ima133 = NULL     #產品預測料號
    LET l_ima.ima134 = NULL     #主要包裝方式編號
    LET l_ima.ima135 = NULL     #產品條碼編號
    LET l_ima.ima139 = 'N'
    LET l_ima.ima913 = 'N'      #No.MOD-640061
    LET l_ima.ima1010 = '0'                    #FUN-690060
    LET l_ima.imauser=g_user    #資料所有者
    LET l_ima.imagrup=g_grup    #資料所有者所屬群
    LET l_ima.imamodu=NULL      #資料修改日期
    LET l_ima.imadate=g_today   #資料建立日期
    LET l_ima.imaacti='P'       #有效資料 #FUN-690060
 
    IF l_ima.ima06 IS NULL THEN
       LET l_ima.ima871 =0         #間接物料分攤率
       LET l_ima.ima872 =''        #材料製造費用成本項目
       LET l_ima.ima873 =0         #間接人工分攤率
       LET l_ima.ima874 =''        #人工製造費用成本項目
       LET l_ima.ima88  =0         #期間採購數量
       LET l_ima.ima89  =0         #期間採購使用的期間(月)
       LET l_ima.ima90  =0         #期間採購使用的期間(日)
    END IF
    IF l_ima.ima01[1,4]='MISC' THEN #NO:6808(養生)
        LET l_ima.ima08='Z'
    END IF
    IF l_ima.ima35 is null then let l_ima.ima35=' ' end if
    IF l_ima.ima36 is null then let l_ima.ima36=' ' end if
    IF cl_null(l_ima.ima903) THEN LET l_ima.ima903 = 'N' END IF #NO:6872
    IF cl_null(l_ima.ima905) THEN LET l_ima.ima905 = 'N' END IF
    IF cl_null(l_ima.ima910) THEN LET l_ima.ima910 = ' ' END IF #FUN-550014 add
    LET l_ima.ima916 = g_plant
    LET l_ima.ima917 = 0
    IF l_ima.ima131 IS NULL THEN LET l_ima.ima131 = ' ' END IF  #No.FUN-880032
    IF l_ima.ima926 IS NULL THEN LET l_ima.ima926 = 'N' END IF  #No.FUN-9B0099
    RETURN l_ima.*
END FUNCTION
 
FUNCTION i100_copy_insert(l_ima,l_newno)
   DEFINE l_ima RECORD LIKE ima_file.*
   DEFINE l_newno LIKE ima_file.ima01
   DEFINE l_smd   RECORD LIKE smd_file.*
   DEFINE l_imt   RECORD LIKE imt_file.*       #No.FUN-870117
   DEFINE l_gbc   RECORD LIKE gbc_file.*
    BEGIN WORK
    
    IF cl_null(g_ima.ima601) THEN
       LET l_ima.ima601 = '1'      #FUN-860111
    ELSE
       LET l_ima.ima601 = g_ima.ima601
    END IF
    LET l_ima.ima154 = 'N'      #FUN-870100 ADD
    LET l_ima.ima155 = 'N'      #FUN-870100 ADD 
    LET l_ima.ima571 = l_newno  #TQC-9A0185    
    LET l_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
#FUN-A20037 --begin--
    IF cl_null(g_ima.ima022) THEN
       LET g_ima.ima022 = 0
    END IF
#FUN-A20037 --end--

   #FUN-A80150---add---start---
    IF cl_null(l_ima.ima156) THEN 
       LET l_ima.ima156 = 'N'
    END IF
    IF cl_null(l_ima.ima158) THEN 
       LET l_ima.ima158 = 'N'
    END IF
   #FUN-A80150---add---end---
    IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
    INSERT INTO ima_file VALUES (l_ima.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err(l_ima.ima01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN FALSE
    ELSE
       CALL s_zero(l_newno)
       DECLARE smd_cur CURSOR FOR
       SELECT * FROM smd_file WHERE smd01=g_ima.ima01
       FOREACH smd_cur INTO l_smd.*
           LET l_smd.smd01 = l_newno
           INSERT INTO smd_file VALUES(l_smd.*)
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","smd_file",l_smd.smd01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
              ROLLBACK WORK     #NO.FUN-680010
              RETURN FALSE           #NO.FUN-680010
           ELSE
              MESSAGE 'INSERT smd...'
           END IF
       END FOREACH
 
      DECLARE imt_cur CURSOR FOR
       SELECT * FROM imt_file WHERE imt01=g_ima.ima01
       FOREACH imt_cur INTO l_imt.*
           LET l_imt.imt01 = l_newno
           INSERT INTO imt_file VALUES(l_imt.*)
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","imt_file",l_imt.imt01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
              ROLLBACK WORK     
              RETURN FALSE           
           ELSE
              MESSAGE 'INSERT imt...'
           END IF
       END FOREACH
      
      #當使用多語言功能時,需連多語言的品名、規格資料一併複製
       IF g_aza.aza44 = "Y" THEN
          DECLARE gbc_cur1 CURSOR FOR
             SELECT * FROM gbc_file WHERE gbc01 = 'ima_file'
                                      AND gbc02 = 'ima02'     #品名
                                      AND gbc03 = g_ima.ima01
          FOREACH gbc_cur1 INTO l_gbc.*
             LET l_gbc.gbc03=l_ima.ima01
             INSERT INTO gbc_file VALUES(l_gbc.*)
             IF SQLCA.SQLCODE THEN
                CALL cl_err3("ins","gbc_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)
             ELSE
                MESSAGE 'INSERT gbc...'
             END IF
          END FOREACH
 
          DECLARE gbc_cur2 CURSOR FOR
             SELECT * FROM gbc_file WHERE gbc01 = 'ima_file'
                                      AND gbc02 = 'ima021'    #規格
                                      AND gbc03 = g_ima.ima01
          FOREACH gbc_cur2 INTO l_gbc.*
             LET l_gbc.gbc03=l_ima.ima01
             INSERT INTO gbc_file VALUES(l_gbc.*)
             IF SQLCA.SQLCODE THEN
                CALL cl_err3("ins","gbc_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)
             ELSE
                MESSAGE 'INSERT gbc...'
             END IF
          END FOREACH
       END IF
       CASE aws_mdmdata('ima_file','insert',l_ima.ima01,base.TypeInfo.create(l_ima),'CreateItemMasterData') #FUN-870166
          WHEN 0  #無與 MDM 整合
               CALL cl_msg('INSERT O.K')
          WHEN 1  #呼叫 MDM 成功
               CALL cl_msg('INSERT O.K, INSERT MDM O.K')
          WHEN 2  #呼叫 MDM 失敗
               ROLLBACK WORK
               RETURN FALSE
       END CASE
       RETURN TRUE
    END IF
END FUNCTION
 
FUNCTION i100_copy_finish(l_newno,l_oldno)
   DEFINE l_newno,l_oldno LIKE ima_file.ima01
 
   # 傳入參數: (1)TABLE名稱, (2)新增資料,
   #           (3)功能選項：insert(新增),update(修改),delete(刪除)
   CASE aws_spccli_base('ima_file',base.TypeInfo.create(g_ima),'insert')
      WHEN 0  #無與 SPC 整合
           MESSAGE 'INSERT O.K'
           COMMIT WORK
      WHEN 1  #呼叫 SPC 成功
           MESSAGE 'INSERT O.K, INSERT SPC O.K'
           COMMIT WORK
      WHEN 2  #呼叫 SPC 失敗
           ROLLBACK WORK
   END CASE
 
   #SELECT ima_file.* INTO g_ima.* FROM ima_file  #FUN-C30027
   #               WHERE ima01 = l_oldno   #FUN-C30027
END FUNCTION
 
FUNCTION i100_i_inpchk()
   IF ( g_ima.ima37='0' OR g_ima.ima37 ='5' )
      AND ( g_ima.ima08 NOT MATCHES '[MSPVZ]' )
   THEN CALL cl_err(g_ima.ima37,'mfg3201',1)
        RETURN "ima01"
        DISPLAY BY NAME g_ima.ima37
        DISPLAY BY NAME g_ima.ima08
   END IF
   IF g_sma.sma115 = 'Y' THEN
      IF g_ima.ima906 IS NULL THEN
         RETURN "ima906"
      END IF
   END IF
   IF g_sma.sma122 = '1' THEN
      IF g_ima.ima906 = '3' THEN
         CALL cl_err('','asm-322',1)
         RETURN "ima906"
      END IF
   END IF
   IF g_sma.sma122 = '2' THEN
      IF g_ima.ima906 = '2' THEN
         CALL cl_err('','asm-323',1)
         RETURN "ima906"
      END IF
   END IF
   RETURN NULL
END FUNCTION
 
FUNCTION i100_a_inschk()
   IF g_ima.ima31 IS NULL THEN
      LET g_ima.ima31=g_ima.ima25
      LET g_ima.ima31_fac=1
   END IF
 
   IF g_ima.ima133 IS NULL THEN
      LET g_ima.ima133 = g_ima.ima01
   END IF
 
   IF g_ima.ima571 IS NULL THEN
      LET g_ima.ima571 = g_ima.ima01
   END IF
 
   IF g_ima.ima44 IS NULL OR g_ima.ima44=' ' THEN
      LET g_ima.ima44=g_ima.ima25   #採購單位
      LET g_ima.ima44_fac=1
   END IF
 
   IF g_ima.ima55 IS NULL OR g_ima.ima55=' ' THEN
      LET g_ima.ima55=g_ima.ima25   #生產單位
      LET g_ima.ima55_fac=1
   END IF
 
   IF g_ima.ima63 IS NULL OR g_ima.ima63=' ' THEN
      LET g_ima.ima63=g_ima.ima25   #發料單位
      LET g_ima.ima63_fac=1
   END IF
 
   LET g_ima.ima86=g_ima.ima25   #庫存單位=成本單位
   LET g_ima.ima86_fac=1
 
   IF g_ima.ima35 IS NULL THEN
      LET g_ima.ima35=' ' #No:7726
   END IF
 
   IF g_ima.ima36 IS NULL THEN
      LET g_ima.ima36=' ' #No:7726
   END IF
 
   IF g_ima.ima910 IS NULL THEN
      LET g_ima.ima910=' ' #FUN-550014
   END IF
   IF g_ima.ima131 IS NULL THEN LET g_ima.ima131 = ' ' END IF #No.FUN-880032
   
 
   LET g_ima.ima913 = "N"   #No.MOD-640061

   IF g_ima.ima926 IS NULL THEN
      LET g_ima.ima926='N'
   END IF

END FUNCTION
 
FUNCTION i100_a_updchk()
   LET g_ima.ima31=g_ima.ima25
   LET g_ima.ima31_fac=1
 
   LET g_ima.ima44=g_ima.ima25   #採購單位
   LET g_ima.ima44_fac=1
 
   LET g_ima.ima55=g_ima.ima25   #生產單位
   LET g_ima.ima55_fac=1
 
   LET g_ima.ima63=g_ima.ima25   #發料單位
   LET g_ima.ima63_fac=1
 
   LET g_ima.ima86=g_ima.ima25   #庫存單位=成本單位
   LET g_ima.ima86_fac=1
END FUNCTION
 
FUNCTION i100_a_ins()
   LET g_ima.ima01  = g_ima.ima01 CLIPPED      #No.FUN-870150
   IF cl_null(g_ima.ima601) THEN 
      LET g_ima.ima601 = '1'    #No:FUN-860111 
   END IF
   LET g_ima.ima154 = 'N'      #FUN-870100 ADD                                                                                     
   LET g_ima.ima155 = 'N'      #FUN-870100 ADD 
   IF g_ima.ima01[1,4]='MISC' THEN
      LET g_ima.ima130='2'
   END IF
   LET g_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
#FUN-A20037 --begin--
   IF cl_null(g_ima.ima022) THEN
     LET g_ima.ima022 = 0 
   END IF 
#FUN-A20037 --end--
  #FUN-A80150---add---start---
   IF cl_null(g_ima.ima156) THEN 
      LET g_ima.ima156 = 'N'
   END IF
   IF cl_null(g_ima.ima158) THEN 
      LET g_ima.ima158 = 'N'
   END IF
  #FUN-A80150---add---end---
   IF cl_null(g_ima.ima928) THEN LET g_ima.ima928 = 'N' END IF      #TQC-C20131  add
   INSERT INTO ima_file VALUES(g_ima.*)       # DISK WRITE
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ima_file",g_ima.ima01,"",SQLCA.sqlcode,
                   "","",1)  #No.FUN-660156
      RETURN FALSE
   ELSE
      LET g_ima_t.* = g_ima.*                # 保存上筆資料
 
      CASE aws_mdmdata('ima_file','insert',g_ima.ima01,base.TypeInfo.create(g_ima),'CreateItemMasterData') #FUN-870166
         WHEN 0  #無與 MDM 整合
              CALL cl_msg('INSERT O.K')
         WHEN 1  #呼叫 MDM 成功
              CALL cl_msg('INSERT O.K, INSERT MDM O.K')
         WHEN 2  #呼叫 MDM 失敗
              RETURN FALSE
      END CASE
 
      # CALL aws_spccli_base()
      # 傳入參數: (1)TABLE名稱, (2)新增資料,
      #           (3)功能選項：insert(新增),update(修改),delete(刪除)
      CASE aws_spccli_base('ima_file',base.TypeInfo.create(g_ima),'insert')
         WHEN 0  #無與 SPC 整合
              MESSAGE 'INSERT O.K'
              RETURN TRUE
         WHEN 1  #呼叫 SPC 成功
              MESSAGE 'INSERT O.K, INSERT SPC O.K'
              RETURN TRUE
         WHEN 2  #呼叫 SPC 失敗
              RETURN FALSE
      END CASE
 
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_u_updchk()
 
    OPEN i100_cl USING g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       RETURN FALSE
    END IF
    FETCH i100_cl INTO g_ima.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       RETURN FALSE
    END IF
    LET g_ima.imamodu = g_user                   #修改者
    LET g_ima.imadate = g_today                  #修改日期
    LET g_ima906 = g_ima.ima906
    LET g_ima907 = g_ima.ima907
    LET g_ima908 = g_ima.ima908
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_u_upd()
   DEFINE l_imzacti  LIKE imz_file.imzacti
   DEFINE l_prog LIKE type_file.chr8 #FUN-870101 add 
 
#  # B018 01/03/22 plum 為了擋user是使用copy,但使用的舊料件的主分群碼已無效
   LET g_errno=' '
   SELECT imzacti INTO l_imzacti FROM imz_file
    WHERE imz01 = g_ima.ima06
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3179'
      WHEN l_imzacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(g_ima.ima06,g_errno,1)
      DISPLAY BY NAME g_ima.ima06
      RETURN FALSE
   END IF
   UPDATE ima_file SET ima_file.* = g_ima.*    # 更新DB
       WHERE ima01 = g_ima.ima01             # COLAUTH?
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
      RETURN FALSE
   ELSE
      LET g_errno = TIME
      LET g_msg = 'Chg No:',g_ima.ima01
      LET g_u_flag='0'   #FUN-870101 add
 
      INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #No.FUN-980004 
        VALUES ('aimi100',g_user,g_today,g_errno,g_ima.ima01,g_msg,g_plant,g_legal) #MOD-940394  #No.FUN-980004 #mod by liuxqa 091020 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","azo_file","aimi100","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
         RETURN FALSE
      END IF
 
      CASE aws_mdmdata('ima_file','update',g_ima.ima01,base.TypeInfo.create(g_ima),'CreateItemMasterData') #FUN-870166
         WHEN 0  #無與 MDM 整合
              CALL cl_msg('Update O.K')
              LET g_u_flag='0'    #FUN-870101 add
         WHEN 1  #呼叫 MDM 成功
              CALL cl_msg('Update O.K, Update MDM O.K')
              LET g_u_flag='0'    #FUN-870101 add
         WHEN 2  #呼叫 MDM 失敗
              LET g_u_flag='1'    #FUN-870101 add
              #RETURN FALSE       #FUN-870101 mark
      END CASE
 
      IF g_action_choice <> "reproduce" THEN
         # CALL aws_spccli_base()
         # 傳入參數: (1)TABLE名稱, (2)修改資料,
         #           (3)功能選項：insert(新增),update(修改),delete(刪除)
         CASE aws_spccli_base('ima_file',base.TypeInfo.create(g_ima),'update')
            WHEN 0  #無與 SPC 整合
                 MESSAGE 'UPDATE O.K'
                 LET g_u_flag='0'    #FUN-870101 add
            WHEN 1  #呼叫 SPC 成功
                 MESSAGE 'UPDATE O.K. UPDATE SPC O.K'
                 LET g_u_flag='0'    #FUN-870101 add
            WHEN 2  #呼叫 SPC 失敗
                 LET g_u_flag='1'    #FUN-870101 add
         END CASE
 
         IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD 
            # CALL aws_mescli
            # 傳入參數: (1)程式代號
            #           (2)功能選項：insert(新增),update(修改),delete(刪除)
            #           (3)Key
            LET l_prog=''
            CASE g_ima.ima08
               WHEN 'P' LET l_prog = 'aimi100' 
               WHEN 'M' LET l_prog = 'axmi121'
               OTHERWISE LET l_prog= ' '
            END CASE 
            CASE aws_mescli(l_prog,'update',g_ima.ima01)
               WHEN 0  #無與 MES 整合
                    CALL cl_msg('Update O.K')
                    LET g_u_flag='0'   
               WHEN 1  #呼叫 MES 成功
                    LET g_u_flag='0'    
                    CALL cl_msg('Update O.K, Update MES O.K')
               WHEN 2  #呼叫 MES 失敗
                    LET g_u_flag='1'    
            END CASE
         END IF #TQC-8B0011  ADD
      END IF
   END IF
   IF g_u_flag='1' THEN RETURN FALSE ELSE RETURN TRUE END IF   #FUN-870101 add
END FUNCTION

FUNCTION i100_reselect_data()
 
   CALL i100_declare_curs()
   OPEN aimi100_count
   FETCH aimi100_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN aimi100_curs                            # 從DB產生合乎條件TEMP(0-30秒)
   FETCH ABSOLUTE g_curs_index aimi100_curs INTO g_ima.ima01
   CALL cl_navigator_setting(g_curs_index, g_row_count)
 
   SELECT * INTO g_ima.* FROM ima_file            # 重讀DB,因TEMP有不被更新特性
      WHERE ima01 = g_ima.ima01
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
   END IF
END FUNCTION
 
 
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ima_l TO s_ima_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
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
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i100_fetch('/')
         END IF
         CALL cl_set_comp_visible("page112", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page112", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i100_fetch('/')
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("page112", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("page112", TRUE)    #NO.FUN-840018 ADD
         EXIT DISPLAY
 
      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION last
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION info_pg
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"  #MOD-8A0193 add
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"  
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL i100_set_perlang()
         CALL i100_show_pic()
         CALL cl_show_fld_cont()
 
      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-8A0193
         LET g_action_choice="exit"  #MOD-8A0193 add
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         LET g_action_choice="about"  #MOD-8A0193 add
         EXIT DISPLAY                 #MOD-8A0193 add
     
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
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION data_status
         LET g_action_choice="data_status"
         EXIT DISPLAY
 
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
 
      ON ACTION sales
         LET g_action_choice="sales"
         EXIT DISPLAY
 
      ON ACTION purchase
         LET g_action_choice="purchase"
         EXIT DISPLAY
 
      ON ACTION production
         LET g_action_choice="production"
         EXIT DISPLAY
 
      ON ACTION cost
         LET g_action_choice="cost"
         EXIT DISPLAY
 
      ON ACTION cost_element
         LET g_action_choice="cost_element"
         EXIT DISPLAY
 
      ON ACTION pn_spec_extra_desc
         LET g_action_choice="pn_spec_extra_desc"
         EXIT DISPLAY
 
      ON ACTION carry
         LET g_action_choice = "carry"
         EXIT DISPLAY
 
      ON ACTION download
         LET g_action_choice = "download"
         EXIT DISPLAY
 
      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"
         EXIT DISPLAY
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION aps_related_data
         LET g_action_choice="aps_related_data" 
         EXIT DISPLAY
 
      ON ACTION maintain_item_unit_conversion
         LET g_action_choice="maintain_item_unit_conversion"
         EXIT DISPLAY
 
      ON ACTION add_multi_attr_sub
         LET g_action_choice="add_multi_attr_sub"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
 
      ON ACTION notconfirm
         LET g_action_choice="notconfirm"
         EXIT DISPLAY
 
      ON ACTION update_person
         LET g_action_choice="update_person"
         EXIT DISPLAY
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
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
 
 
FUNCTION i100_carry()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_sql     LIKE type_file.chr1000
 
   IF cl_null(g_ima.ima01) THEN  #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_ima.imaacti <> 'Y' THEN
      CALL cl_err(g_ima.ima01,'aoo-090',1)
      RETURN
   END IF
 
   LET g_gev04 = NULL
 
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file 
    WHERE gev01 = '1' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
 
   IF cl_null(g_gev04) THEN RETURN END IF
 
   #開窗選擇拋轉的db清單
  #LET l_sql = "SELECT COUNT(*) FROM &ima_file WHERE ima01='",g_ima.ima01,"'"   #TQC-A20008
   LET l_sql = "SELECT COUNT(*) FROM ima_file WHERE ima01='",g_ima.ima01,"'"    #TQC-A20008
   CALL s_dc_sel_db1(g_gev04,'1',l_sql)
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   CALL g_imax.clear()
   LET g_imax[1].sel = 'Y'
   LET g_imax[1].ima01 = g_ima.ima01
   FOR l_i = 1 TO g_azp1.getLength()
       LET g_azp[l_i].sel   = g_azp1[l_i].sel
       LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
       LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
       LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
   END FOR
 
   CALL s_showmsg_init()
   CALL s_aimi100_carry(g_imax,g_azp,g_gev04,'0')  #No.FUN-830090
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION i100_download()
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10
  DEFINE l_j          LIKE type_file.num10
 
   IF cl_null(g_ima.ima01) THEN  #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL g_imax.clear()
   FOR l_i = 1 TO g_ima_l.getLength()
       LET g_imax[l_i].sel   = 'Y'
       LET g_imax[l_i].ima01 = g_ima_l[l_i].ima01_l
   END FOR
   CALL s_aimi100_download(g_imax)
 
END FUNCTION
 
FUNCTION i100_b_menu()
   DEFINE   l_priv1   LIKE zy_file.zy03,           # 使用者執行權限
            l_priv2   LIKE zy_file.zy04,           # 使用者資料權限
            l_priv3   LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE   l_cmd     LIKE type_file.chr1000
 
 
 
   WHILE TRUE
 
      CALL i100_bp("G")  
 
      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
         SELECT ima_file.* 
           INTO g_ima.* 
           FROM ima_file 
          WHERE ima01=g_ima_l[l_ac1].ima01_l
      END IF
 
      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i100_fetch('/')
         END IF
         CALL cl_set_comp_visible("page112", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page112", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
       END IF
 
      CASE g_action_choice
         WHEN "insert"
            IF g_aza.aza60 = 'N' THEN #不使用客戶申請作業時,才可按新增!
                IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
                     CALL i100_a()
                END IF
            ELSE
                CALL cl_err('','aim-152',1)
                #不使用客戶申請作業時,才可按新增!
            END IF
            EXIT WHILE
 
        WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
            EXIT WHILE
        
        WHEN "delete" 
            IF cl_chk_act_auth() THEN
               IF i100_r() THEN
                  CALL i100_AFTER_DEL()
               END IF
            END IF
 
        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i100_u()
            END IF
            EXIT WHILE
 
        WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i100_x()
               CALL i100_show()          
            END IF
 
        WHEN "reproduce"
            IF g_aza.aza60 = 'N' THEN  #CHI-740027 add if判斷
                IF cl_chk_act_auth() THEN
                   CALL i100_copy()
                   CALL i100_show() #FUN-6C0006
                END IF
            ELSE
                #參數設定使用料件申請作業時,不可做複製!
                CALL cl_err('','aim-154',1)
            END IF
 
        WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i100_out()
            END IF
 
        WHEN "data_status"
            IF g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
               CALL i100_disp()
            END IF
 
        WHEN "inventory"
            LET g_msg="aimi101 '",g_ima.ima01,"'"
            CALL cl_cmdrun_wait(g_msg) #MOD-580344
            CALL i100_show()
 
        WHEN "sales"
            IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
               LET g_cmd = "axmi121 '",g_ima.ima01,"'"
               CALL  cl_cmdrun_wait(g_cmd) #MOD-580344
            END IF
            CALL i100_show()
 
        WHEN "purchase"
            IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
               LET l_priv1=g_priv1
               LET l_priv2=g_priv2
               LET l_priv3=g_priv3
               LET g_msg="aimi103 '",g_ima.ima01,"' '",g_flag1,"'"
               CALL cl_cmdrun_wait(g_msg) #MOD-580344
               LET g_priv1=l_priv1
               LET g_priv2=l_priv2
               LET g_priv3=l_priv3
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
               CALL i100_show()
            END IF
 
        WHEN "production"
            IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
               LET l_priv1=g_priv1
               LET l_priv2=g_priv2
               LET l_priv3=g_priv3
               LET g_msg="aimi104 '",g_ima.ima01,"'"
               CALL cl_cmdrun_wait(g_msg) #MOD-580344
               LET g_priv1=l_priv1
               LET g_priv2=l_priv2
               LET g_priv3=l_priv3
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
               CALL i100_show()
            END IF
 
        WHEN "cost"
            IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
               LET l_priv1=g_priv1
               LET l_priv2=g_priv2
               LET l_priv3=g_priv3
               LET g_msg="aimi105 '",g_ima.ima01,"'"
               CALL cl_cmdrun_wait(g_msg) #MOD-580344
               LET g_priv1=l_priv1
               LET g_priv2=l_priv2
               LET g_priv3=l_priv3
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
               CALL i100_show()
            END IF
 
        WHEN "cost_element"
            IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL AND g_ima.ima01 != ' ' THEN
               LET l_priv1=g_priv1
               LET l_priv2=g_priv2
               LET l_priv3=g_priv3
               LET g_msg="aimi106 '",g_ima.ima01,"'"
               CALL cl_cmdrun_wait(g_msg) #MOD-580344
               LET g_priv1=l_priv1
               LET g_priv2=l_priv2
               LET g_priv3=l_priv3
            END IF
            CALL i100_show()
 
        WHEN "pn_spec_extra_desc"
            IF cl_chk_act_auth() AND NOT cl_null(g_ima.ima01) THEN
               LET g_msg="aimi108 '",g_ima.ima01,"'"
               CALL cl_cmdrun_wait(g_msg) #MOD-580344
            END IF
            CALL i100_show()
 
        WHEN "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL i100_carry()
            END IF
 
        WHEN "download"
            IF cl_chk_act_auth() THEN
               CALL i100_download()
            END IF
 
        WHEN "qry_carry_history"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_ima.ima01) THEN   #No.FUN-830090
                  IF NOT cl_null(g_ima.ima916) THEN
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '1' AND gev02 = g_ima.ima916
                  ELSE      #歷史資料,即沒有ima916的值
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '1' AND gev02 = g_plant
                  END IF
                  IF NOT cl_null(g_gev04) THEN
                     LET l_cmd='aooq604 "',g_gev04,'" "1" "',g_prog,'" "',g_ima.ima01,'"'
                     CALL cl_cmdrun(l_cmd)
                  END IF
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
 
        WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_ima.ima01 IS NOT NULL THEN
                  LET g_doc.column1 = "ima01"
                  LET g_doc.value1 = g_ima.ima01
                  CALL cl_doc()
               END IF
            END IF
 
        WHEN "aps_related_data" #MOD-520032
             IF cl_null(g_ima.ima01) THEN
                CALL cl_err('',-400,1)
             END IF
             IF (cl_chk_act_auth()) and (NOT cl_null(g_ima.ima01)) THEN              #BUG-520032    #MOD-530367
                 CALL i100_vmi()
                 LET g_cmd = "apsi308 '",g_ima.ima01,"'"
                 CALL cl_cmdrun(g_cmd)
             ELSE
                 CALL cl_err('',-400,1)
             END IF
 
             WHEN "maintain_item_unit_conversion"
             LET l_cmd = "aooi103 '",g_ima.ima01,"'" CLIPPED
             CALL cl_cmdrun(l_cmd CLIPPED)
 
       WHEN "add_multi_attr_sub"
           IF cl_null(g_ima.ima01) THEN
              CALL cl_err('',-400,1)
           ELSE
                IF g_ima.ima1010 !='1' THEN               # NO.FUN-870117 
                   CALL cl_err(g_ima.ima01,'aim-450',1)   # NO.FUN-870117
                ELSE                                      # NO.FUN-870117
                  CALL saimi311(g_ima.ima01)
                  LET INT_FLAG=0        #No.FUN-640013 退出子程序后INT_FLAG為1,要置0
                  CALL i100_show()
                END IF                                    # NO.FUN-870117  
           END IF
 
        WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i100_confirm()
               CALL i100_show()
            END IF
 
 
        WHEN "notconfirm"
            IF cl_chk_act_auth() THEN
               CALL i100_notconfirm()
               CALL i100_show()
            END IF
 
        WHEN "update_person"
            IF cl_chk_act_auth() THEN
               CALL i100_upd_person()
               CALL i100_show() #FUN-6C0006
            END IF
 
 
        WHEN "help"
            CALL cl_show_help()
 
        WHEN "controlg"
            CALL cl_cmdask()
 
        WHEN "locale"
            CALL cl_dynamic_locale()
            CALL i100_set_perlang()
            CALL i100_show_pic()
            CALL cl_show_fld_cont()
 
        WHEN "exit"
            EXIT WHILE
 
        WHEN "g_idle_seconds"
            CALL cl_on_idle()
 
        WHEN "about"      
            CALL cl_about()      
 
        OTHERWISE 
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i100_unit_fac()
    IF cl_null(g_ima.ima31) THEN LET g_ima.ima31 = g_ima.ima25 END IF
    IF cl_null(g_ima.ima44) THEN LET g_ima.ima44 = g_ima.ima25 END IF
    IF cl_null(g_ima.ima55) THEN LET g_ima.ima55 = g_ima.ima25 END IF
    IF cl_null(g_ima.ima63) THEN LET g_ima.ima63 = g_ima.ima25 END IF
      
    #銷售單位轉換 
    IF g_ima.ima31 = g_ima.ima25 THEN
       LET g_ima.ima31_fac = 1
    ELSE
       CALL s_umfchk(g_ima.ima01,g_ima.ima31,g_ima.ima25)
            RETURNING g_sw,g_ima.ima31_fac
       IF g_sw = '1' THEN
          CALL cl_err(g_ima.ima31,'mfg1206',0)
          DISPLAY BY NAME  g_ima.ima25
       END IF
    END IF
    
    #庫存發料單位轉換
    IF g_ima.ima63 = g_ima.ima25
       THEN LET g_ima.ima63_fac = 1
    ELSE 
    	 CALL s_umfchk(g_ima.ima01,g_ima.ima63,g_ima.ima25)
            RETURNING g_sw,g_ima.ima63_fac
       IF g_sw = '1' THEN
          CALL cl_err(g_ima.ima25,'mfg1206',0)
          DISPLAY BY NAME  g_ima.ima25     
       END IF
    END IF
            
    #采購單位轉換
    IF g_ima.ima44 = g_ima.ima25
       THEN LET g_ima.ima44_fac = 1
    ELSE 
    	 CALL s_umfchk(g_ima.ima01,g_ima.ima44,g_ima.ima25)
            RETURNING g_sw,g_ima.ima44_fac
       IF g_sw = '1' THEN
          CALL cl_err(g_ima.ima25,'mfg1206',0)
          DISPLAY BY NAME  g_ima.ima25     
       END IF
    END IF 
    
    #生產單位轉換
    IF g_ima.ima55 = g_ima.ima25
       THEN LET g_ima.ima55_fac = 1
    ELSE 
    	 CALL s_umfchk(g_ima.ima01,g_ima.ima55,g_ima.ima25)
            RETURNING g_sw,g_ima.ima55_fac
       IF g_sw = '1' THEN
          CALL cl_err(g_ima.ima25,'mfg1206',0)
          DISPLAY BY NAME  g_ima.ima25     
       END IF
    END IF 
            
END FUNCTION            

FUNCTION i100_chk_ima149()
   IF cl_null(g_ima.ima149) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima149,"' ",
             "  AND aag07 <> '1'",
             "  AND aag00 = '",g_aza.aza81,"'"
    IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         #CALL cl_err(g_ima.ima149,"anm-001",1) #FUN-B10049
         CALL cl_err(g_ima.ima149,"anm-001",0) #FUN-B10049
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima149
         LET g_errary[g_cnt].field="ima149"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
FUNCTION i100_chk_ima1491()
   IF cl_null(g_ima.ima1491) THEN   #TQC-9A0022
      RETURN TRUE
   END IF
   IF g_aza.aza63 ='N' THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima1491,"' ",
             "  AND aag07 <> '1'", 
             "  AND aag00 = '",g_aza.aza82,"'" 
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN 
         #CALL cl_err(g_ima.ima1491,"anm-001",1)  #FUN-B10049
         CALL cl_err(g_ima.ima1491,"anm-001",0)  #FUN-B10049
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima1491
         LET g_errary[g_cnt].field="ima1491"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼

