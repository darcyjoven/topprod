# Prog. Version..: '5.30.06-13.03.12(00000)'     #
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
# Modify.........: No:MOD-A50099 10/05/17 By Sarah 在ima918或ima921欄位連續勾選、取消、再勾選時,ima919/920/922/923/924/925等欄位開關會異常
# Modify.........: No:FUN-A50011 10/05/20 By yangfeng 維護顏色組/尺碼組即可自動產生屬性群組，並能自動生成子料件
# Modify.........: No:CHI-A50006 10/05/25 by Summer 復原TQC-A20008修改 
# Modify.........: No:MOD-A60104 10/06/15 By Sarah 新增時,若有修改庫存單位(ima25)也應詢問aim-020
# Modify.........: No:FUN-A50011 10/07/02 By yangfeng 增加顏色與尺碼維護
# Modify.........: No.FUN-A80102 10/08/20 By kim GP5.25號機管理
# Modify.........: No.FUN-A80150 10/09/01 By sabrina 新增號機管理頁面及其欄位
# Modify.........: No.FUN-950057 10/09/02 By vealxu gew03 = '1'時,確認時自動拋轉
# Modify.........: No:MOD-A90011 10/09/23 By Summer 增加控管是否有有效BOM的資料存在，若有則不允許無效
# Modify.........: No.FUN-A90049 10/09/25 By vealxu 規通料件整合商戶料號合併到 ima_file，ima_file加一料件性質判斷為企業料號或商戶料號
# Modify.........: No:MOD-A90173 10/09/28 By sabrina 修改時，若ima35/ima36為null則給' '
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No.TQC-AA0117 10/10/20 By destiny 預設ima120
# Modify.........: No.FUN-A40022 10/10/25 By jan 增加欄位imaicd13
# Modify.........: No.FUN-AB0021 10/11/02 By lixh1  查詢時料號的開窗篩選掉商戶料號
# Modify.........: No.FUN-AB0011 10/11/03 By vealxu 指定產品策略 Action 執行後應先彈出視窗
# Modify.........: No:FUN-AB0025 11/11/10 By lixh1  開窗BUG處理
# Modify.........: No:MOD-A10080 10/11/25 By sabrina 無效時，mfg9163的錯誤訊息沒呈現
# Modify.........: No:TQC-AB0142 10/12/01 By wangxin ima1006賦默認值
# Modify.........: No:CHI-AC0014 10/12/09 By Summer 作廢段多判斷是否存在非無效的雜收/雜發單，若有則不允許作廢 
# Modify.........: No:TQC-AB0041 10/12/20 By lixh1  新增時給ima926賦默認值'N'
# Modify.........: No.TQC-AC0185 10/12/22 By vealxu Layout請做調配避免讓 V-scrollbar出現,輸入順序請做相對應調整
# Modify.........: No:TQC-A60015 10/12/23 By destiny 取消复制时应把开发录入的栏位管掉
# Modify.........: No:FUN-AC0072 10/12/24 By jan 複製功能有錯誤
# Modify.........: No:MOD-B10101 11/01/13 By sabrina 無效時判斷是否存在雜收/發單應判斷未確認的單子
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No:MOD-B20100 11/02/21 By sabrina ima39應要存在總帳營運中心的會計科目裡 
# Modify.........: No:TQC-B20161 11/02/23 By jan ima912 新增存檔時 要判斷如果為null要給 0
# Modify.........: No:TQC-B30013 11/03/02 By sabrina MOD-B20100少寫回傳值 
# Modify.........: No:FUN-B20061 11/03/02 By jan 料件主檔應該是要放寬為S件也要可以維護"聯產品"(ima903)否，不然在abmi608也會無法維護(因為S PART ima903=N)
# Modify.........: No:MOD-B30519 11/03/15 By jan aici020增加參:
# Modify.........: No:FUN-9A0056 11/04/12 By Abby MES功能補強
#                                                1.修改(未確認)/刪除/複製/新增,不需傳給MES
#                                                2.修改(已確認)/確認/取消確認/無效/反無效,傳送MES
# Modify.........: No:MOD-B40151 11/04/18 By Smapmin 來源碼無法輸入R類
# Modify.........: No:FUN-B40078 11/04/25 By lilingyu 如果是MISC料件,則"檢驗否"欄位直接賦N,且不可修改
# Modify.........: No:MOD-B50026 11/05/04 By sabrina ima02、ima021不應控卡不能輸入
# Modify.........: No:FUN-B50052 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No:TQC-B50017 11/05/09 By lilingyu 修改狀態下"檢驗"欄位控管
# Modify.........: No:FUN-9C0089 11/05/04 By suncx 新增資料清單的excel匯出功能
# Modify.........: No:FUN-B30192 11/05/09 By shenyang 添加字段imaicd14,imaicd15,imaicd16
# Modify.........: No:FUN-B50046 11/05/19 By abby APS GP5.25追版 str-------
# Modify.........: No:FUN-930087 09/03/16 By Duke INSERT vai_file 增加 vai65
# Modify.........: No:FUN-B50046 11/05/19 By abby APS GP5.25追版 end-------
# Modify.........: No:FUN-B50106 11/05/25 By lixh1 取消從ima01帶imaicd16的預設值
# Modify.........: Mo:FUN-B30092 11/05/27 By Polly 1.量化規格開窗改抓q_gfo
#                                                  2.ringmenu加掛量化規格(quantifying)action
# Modify.........: No:CHI-B50017 11/06/15 By Vampire 新增分群碼說明 g_buf_2
# Modify.........: No:FUN-A70106 11/06/28 By Mandy 因為PLM整合時,Service "CreateItemMasterData"欲共用確認段,將i100_confirm()拆至aimi100_sub.4gl
#                  原aimi100.4gl的i100_confirm()被拆分成
#                  i100sub_chk()    ==>確認前的欄位檢核
#                  i100sub_y_upd()  ==>做欄位的異動或呼叫MES
#                  i100sub_carry()  ==>資料中心拋轉(ps:aws_create_itemmaster_data此Service不做資料中心拋轉)
# Modify.........: No:CHI-B70014 11/07/11 By jason BIN群組不需為必KEY值
# Modify.........: No:MOD-B40200 11/07/17 By JoHung imaicd08欄位輸入與否的控管
# Modify.........: No:MOD-B40111 11/07/17 By Summer 複製時要有自動編碼功能
# Modify.........: No:MOD-B60132 11/07/17 By Summer 在做無效時，bmb_file應也要考慮bmaacti='Y'
# Modify.........: No:MOD-B60152 11/07/17 By Summer (1)複製時按放棄的return值少回傳一個
#                                                   (2)複製後輸入新的料件編號，舊的ima02沒有帶出來 
# Modify.........: No:FUN-B70057 11/07/18 By zhangll 控管料號前不能有空格
# Modify.........: No.FUN-B70051 11/07/22 By xianghui 開窗時加where條件裏的練劍狀態給'1'
# Modify.........: No.FUN-B50096 11/08/18 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
#                                                  新增欄位ima159
# Modify.........: No:FUN-B90035 11/09/05 By lixh1 給ima159默認值'3
# Modify.........: No:FUN-B90046 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No:CHI-B80032 11/10/08 By johung 修正批/序號管理欄位控管
# Modify.........: No:TQC-B90236 11/10/09 By yuhuabao 1.增加"特性主料(ima928)"、"特性主料編號(ima929)"二個欄位
#                                                     2.新增Action"特性維護"
# Modify.........: No:FUN-B90101 11/10/12 By lixiang  服飾行業的修改 1.维护颜色组/尺码组即可自动产生属性群组,并能自动生成子料件
#                                                                    2.母料件的資料修改後，同步更改資料件的資料
# Modify.........: No.FUN-B80032 11/10/31 By nanbing ima_file 更新揮寫rtepos  
# Modify.........: No:FUN-B80186 11/09/06 By jason 規格替代位置調整
# Modify.........: No:CHI-BA0046 11/11/10 By jason 料件特性(imaicd05)='2346'時：1.良率(imaicd15)要不可輸入2.刻號/BIN(imaicd08)要不可輸入3.DATECODE否(imaicd09)要不可輸入
                                                  #料件特性(imaicd05)='15'時，上述三項要可以輸入
# Modify.........: No:MOD-BB0157 11/11/14 By destiny ima151栏位开启应和p_zz是否可修改key无关
# Modify.........: No:FUN-BA0054 11/11/17 By jason  料件主檔維護完之後，自動產生aooi103的資料for icd
# Modify.........: No:CHI-B80043 11/11/20 By Vampire 需先判斷料建是否存在於rvbs_file
# Modify.........: No:FUN-B90103 11/11/23 By xjll   1. 製造業時屬性群組可開窗 2.插入子料件时ima940對應具體顏色agd02,
#                                                      ima941對應具體顏色agd02,imaag=@CHILD，imaag1=母料件群组imaag
#                                                   3. 子料件生管资料action中ima571缺省工艺料号=子料件编号,
#                                                       ima94缺省工艺编号可开窗录入/修改，不可由母料件值赋值          
# Modify.........: No:FUN-BB0083 11/11/29 By xujing 增加數量欄位小數取位
# Modify.........: No:CHI-BC0005 11/12/05 By ck2yuan 刪除時，說明(azo06)更改為delete                                                
# Modify.........: No:FUN-BC0100 12/01/04 By bart icd確認時檢查BIN群組及WAFER型號是否已存在icf_file，沒有則新增                                               
# Modify.........: No:FUN-A10004 12/01/13 BY jason 帶入分群碼批序號管理的Defore值
# Modify.........: No:FUN-BC0103 12/01/13 By jason 增加PIN COUNT等欄位for ICD
# Modify.........: No:FUN-BB0086 12/01/16 By tanxc 增加數量欄位小數取位
# Modify.........: No:MOD-B90017 12/02/01 By Vampire 當資料拋轉後，執行複製功能，需重新撈取資料
# Modify.........: No:CHI-BB0034 12/02/01 By ck2yuan 只有在查詢時才出現9025警告，其他action不需要
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0106 12/02/02 by Jason 新增自動產生料號 for ICD
# Modify.........: No:TQC-C20059 12/02/06 BY SunLM imaoriu,imaorig不能查询
# Modify.........: No:FUN-BC0107 12/02/07 by jason for icd 1.母體料號開窗應該可以抓到BODY的性質及未測WAFER的性質料號
#                                                          2.加"ICD基本資料參考"ACTION.可以串至aici001
# Modify.........: No:FUN-C20006 12/02/03 By lixiang 服飾BUG修改
# Modify.........: No:TQC-C20105 12/02/10 By SunLM 調整CONSTRUCT、INPUT的順序
# Modify.........: No:TQC-C20117 12/02/13 By lixiang 服飾BUG修改
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值
# Modify.........: No.FUN-C20100 12/02/20 By jason for ICD 若此料號icu_file資料存在時不可刪除
# Modify.........: No.TQC-C20278 12/02/20 By zhuhao 新增時，ima918,ima919,ima921,ima922,ima924預設為"N"
# Modify.........: No.TQC-C20275 12/02/20 By yuhuabao 複製時，特性資料(imac_file)也要一併複製
# Modify.........: No.TQC-C20281 12/02/20 By yuhuabao AFTER FIELD 特性主料編號(ima929)時，判斷
#                                                     IF 母料有使用批序號管理，則子料也需使用批序號管理
# Modify.........: No.TQC-C30137 12/03/08 By bart 執行ICD料件製程時，如果預設製程編號沒有值，顯示提示訊息
# Modify.........: No:MOD-C30066 12/03/08 By ck2yuan 修正CHI-B80043錯誤
# Modify.........: No:MOD-C30088 12/03/09 by jaosn ima159請給default值'3' ima925請給default值'1'
# Modify.........: No:TQC-C30186 12/03/09 By lixiang 子料件的來源碼，應該可開放修改
# Modify.........: No:MOD-C30105 12/03/09 By fengrui 修改刪除后後續操作
# Modify.........: No:MOD-C30091 12/03/09 By bart 當ima918/ima921都沒有勾選時,ima925應該不需要輸入,請設為noentry
# Modify.........: No:TQC-C30171 12/03/09 By xjll aimi100_slk新增料號後按確定，再按更改到批/序號管理頁籤，點特性主件ima928 此時畫面會跳掉，跑到工程/計畫/庫存頁籤
# Modify.........: No:MOD-C30165 12/03/09 By huangrh 服飾母料件生成子料件資料時，子料件的缺省工藝料號給母料件編號
# Modify.........: No:MOD-C30233 12/03/10 By bart 拿掉TQC-C30137所加的卡關(aim-041)
# Modify.........: No:MOD-C30235 12/03/12 By bart 維護作業時,料件特性 BIN群組BODY選取時,母體料號未能自動帶入.
# Modify.........: No:MOD-C30147 12/03/10 By yuhuabao 錄入分群碼時帶入特性資料
# Modify.........: No:MOD-C30197 12/03/12 By yuhuabao 當原有的特性主料編號清空時，提示是否一併刪除特性資料
# Modify.........: No:MOD-C30270 12/03/12 By lixiang 服飾零售業態下修改時子料件的開啟
# Modify.........: No:MOD-C30288 12/03/12 By bart 1.存檔時,請將imaicd14回寫回icb_file的icb05
#                                                 2.當料件狀態(imaicd04)為0或1時,aimi100_icd新增存檔時,先COUNT有沒有icb_file的資料,若沒有則將ICD相關資料寫到icb_file裡
# Modify.........: No:MOD-C30513 12/03/12 By bart 新增或修改時,輸入完"母體料號"imaicd01後,應依"母體料號"預設Gross Die(imaicd14)
# Modify.........: No:MOD-C30407 12/03/12 By bart 將aim-672的控卡段mark掉
# Modify.........: No:MOD-C30308 12/03/13 By yuhuabao 特性主料異動且不為空值時才彈出特性維護窗口
# Modify.........: No:MOD-C30551 12/03/13 By yuhuabao 特性主料編號不能為當前的母料號
# Modify.........: No:MOD-C30694 12/03/14 By qiaozy   *slk*,修改ON CHANGE ima151,使顏色和尺寸欄位及時開啟或關閉
# Modify.........: No:FUN-C30158 12/03/14 By qiaozy   母料件有特性料件时子料件的特性主料件为母料件
# Modify.........: No:FUN-C30206 12/03/15 By bart 當料件狀態為1時(未測WAFE)母體料號為料件自己時,不控卡必需存在料件主檔
# Modify.........: No:FUN-C30235 12/03/20 By bart 單身備品比率及SPARE數要隱藏
# Modify.........: No:FUN-C30278 12/03/28 By bart 判斷imaicd05改為判斷imaicd04
# Modify.........: No:TQC-C40021 12/04/06 By fengrui 添加控管，归属层级有“2”值，則不可取消批號管理控管
# Modify.........: No:FUN-C30082 12/04/09 By bart 自動產生出來的BOM要自動確認、發出
# Modify.........: No:TQC-C40044 12/04/09 By fengrui 修正批號管理控管
# Modify.........: No:TQC-C40078 12/04/12 By fengrui 修正料件特性對良率、刻號/BIN、DATECODE否控管
# Modify.........: No.TQC-C40155 12/04/18 By xianghui 修改時點取消，還原成舊值的處理
# Modify.........: No.TQC-C40219 12/04/24 By xianghui 修正TQC-C40155的問題
# Modify.........: No:TQC-C40248 12/04/27 By qiaozy  鞋服現不支持特性料件，先將特性料件相關的欄位/ACTION隱藏
# Modify.........: No.TQC-C40231 12/05/08 By fengrui 刪除后如果無上下筆資料，則清空變量
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:FUN-C50110 12/06/14 By bart 料件主檔新增後也應該同步新增aici001
# Modify.........: No:TQC-C60001 12/06/14 By bart 複製料件時,imaicd11(New Code申請單號)應該要清空
# Modify.........: No:FUN-C60021 12/06/15 By qiaozy 異動action，重新更新imaag1資料，產生子料件時新增imaslk資料 
# Modify.........: No:FUN-C60061 12/06/18 By bart 自動產生料號後顯示產生哪些料號
# Modify.........: No.TQC-C50222 12/06/19 By fengrui 添加imaag清空與賦值
# Modify.........: No.CHI-C30107 12/06/21 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-C60228 12/06/27 By suncx 修改庫存單位時，如系統使用計價單位，則同步修改計價單位
# Modify.........: No.FUN-C60046 12/06/18 By bart sma94控制是否顯示特性料件
# Modify.........: No.TQC-C70189 12/07/26 By fengrui 修改g_ima.ima571賦值的條件
# Modify.........: No:FUN-C80030 12/08/10 By fengrui 添加批序號依參數sma95隱藏
# Modify.........: No:FUN-C30027 12/08/16 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C80145 12/09/17 By jt_chen 刪除aimi100(ima_file)時,需一併刪除arti111(rta_file)
# Modify.........: No.FUN-C90075 12/09/20 By bart 已拋轉之料件不可修改庫存單位
# Modify.........: No.MOD-CA0016 12/10/12 By Elise 修正無法反無效問題
# Modify.........: No.FUN-CA0092 12/10/15 BY xjll 母料件為N，屬性群組/顏色組/尺碼組欄位不可錄入且隱藏不可見
# Modify.........: No:FUN-C80094 12/08/27 By minpp 新增ima163/ima1631，oaz92='Y'(科目二：多帳套)且大陆版时显示
# Modify.........: No:FUN-C90107 12/10/23 By Nina 因為PLM整合時,Service "CreateItemMasterData"欲共用無效段,將i100_x()拆至aimi100_sub.4gl
# Modify.........: No:CHI-C50068 12/11/06 By bart 新增ima721
# Modify.........: No:MOD-CB0082 12/11/09 By zhangll slk行業別抓取g_ima940s,g_ima941s變量的sql異常調整
# Modify.........: No.CHI-C90006 12/11/22 By bart 失效判斷
# Modify.........: No.FUN-CB0052 12/11/22 By xianghui 發票倉庫控管改善
# Modify.........: No.TQC-CB0079 12/11/22 By xianghui 将FUN-C90107处理部分还原以便过单
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No:FUN-C90107 13/01/21 By Nina 將TQC-CB0079處理FUN-C90107部分還原
# Modify.........: No:CHI-CA0073 13/01/24 By pauline 將ima1015欄位改為NoUse
# Modify.........: No:MOD-D10193 13/01/30 By bart 將aoo-078的控卡搬至畫面清空前。
# Modify.........: No:MOD-D30081 13/03/08 By bart 料號複製成MISC的料號，銷售特性預設「2.MISC」
# Modify.........: No.DEV-D30026 13/03/11 By Nina GP5.3 追版:DEV-D30026、DEV-D30026、DEV-CB0020、DEV-D10002為GP5.25 的單號
# Modify.........: No.DEV-D30033 13/03/19 By TSD.JIE 若有勾選使用條碼，當選擇：序號管理否(ima921='Y'),序號唯一否(ima924)，固定給值Y，且不可異動。
# Modify.........: No.DEV-D30036 13/03/21 By TSD.JIE 
#                  1.當使用條碼否(ima930)="Y"時,
#                    製造批號編碼原則(ima920)多加限制在aooi401的檔案(geh03)="iba_file"
#                    序號編碼原則(ima923)多加限制在aooi401的檔案(geh03)="iba_file"
#                    反之,多限制檔案(geh03)='rvbs_file'
#                  2.條碼產生時機點,增加K:採購收貨作業(apmt110) L:IQC 品質記錄維護作業(aqct110)
# Modify.........: No.CHI-CA0056 13/03/22 By bart 成本分群碼預設null
# Modify.........: No.MOD-D30241 13/03/27 By bart 1.修改停留在資料清單頁籤 需按兩次 esc才能關閉主程式2.程式清單無資料
# Modify.........: No.DEV-D40010 13/04/11 By Nina (1)asms250當收貨單作批序號控管(sma90='Y'),則條碼時機點不可挑選IQC(L),採購入庫(E)
#                                                 (2)(a)增加條碼產生時機點='F/G/K/L'時能維護包號管理否(ima931)
#                                                    (b)增加條碼產生時機點='F/G/K/L'時,能維護包號編碼原則(ima933)
#                                                    (c)增加包號管理否(ima931)='N'且'F/G/K/L'時,能維護批/序號相關欄位
# Modify.........: No.MOD-D40072 13/04/12 By bart 料件開窗改使用q_ima011
# Modify.........: No.DEV-D40015 13/04/16 By Nina aimi100批序號控卡增加條碼產生時機點為I時可勾選批號、序號、包號管理
# Modify.........: No.DEV-D40019 13/04/23 By Nina 欄位：條碼管理否、包號管理，新增時需給預設值='N'
# Modify.........: No.FUN-D40110 13/06/09 By zhuhao azw04='2'零售时录入时默认ima08='P',ima16='0',ima57='99'
# Modify.........: No:FUN-D40103 13/05/16 By fengrui 添加庫位有效性檢查
# Modify.........: No.FUN-D60083 13/08/27 By yangtt 新增費用科目，費用科目二

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aimi100.global"
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-7C0010

DEFINE g_argv2       STRING                  #NO.FUN-840033
DEFINE g_i1          LIKE type_file.num5     #No.FUN-870117
DEFINE g_icb02       LIKE icb_file.icb02     #No.FUN-920114
DEFINE g_buf_2       LIKE ima_file.ima01     #CHI-B50017 add
DEFINE g_ima25_t     LIKE ima_file.ima25     #單位舊值   FUN-BB0083 add
DEFINE g_ima01_t1    LIKE ima_file.ima01     #TQC-C70189 add

#No.FUN-A50011 ----- begin ------
#No.FUN-A50011 ------- end -------
#FUN-B90103---------------add-------------
#FUN-B90103---------------end-------------
MAIN
DEFINE l_sma120      LIKE sma_file.sma120    #No.FUN-810016
DEFINE l_ica40       LIKE ica_file.ica40     #FUN-920172
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP     #,               #FUN-A20037 mark
     # FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730061  #FUN-A20037 mark
   DEFER INTERRUPT
 
   LET g_prog = "aimi100_icd"
 
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
   #FUN-C80094---ADD--STR
   SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
   IF g_aza.aza26='2' AND g_oaz.oaz92='Y' THEN
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_visible("ima163,ima1631",TRUE)
      ELSE
         CALL cl_set_comp_visible("ima163",TRUE)
         CALL cl_set_comp_visible("ima1631",FALSE)
      END IF
   ELSE
       CALL cl_set_comp_visible("ima163,ima1631",FALSE)
   END IF
   #FUN-C80094---ADD--END

   #FUN-D60083--add--str--
   IF g_aza.aza63 = 'Y' THEN
      CALL cl_set_comp_visible("ima164,ima1641",TRUE)
   ELSE
      CALL cl_set_comp_visible("ima164",TRUE)
      CALL cl_set_comp_visible("ima1641",FALSE)
   END IF
   #FUN-D60083--add--end--

   CALL cl_set_comp_visible("imaag",FALSE)    # No.FUN-810016
   CALL cl_set_comp_visible("ima941,ima940,agc021,agc022",FALSE)  #No.FUN-A50011
   CALL cl_set_comp_visible("imaicd12",FALSE)  #FUN-C30235
   IF g_sma.sma94 = 'Y' THEN  #FUN-C60046
   CALL cl_set_comp_visible("ima928,ima929,gb13",TRUE)  #TQC-C40248--ADD--
   CALL cl_set_act_visible("feature_maintain",TRUE)                #TQC-C40248--ADD--
   #FUN-C60046---begin
   ELSE 
      CALL cl_set_comp_visible("ima928,ima929,gb13",FALSE)
      CALL cl_set_act_visible("feature_maintain",FALSE)
   END IF 
   #FUN-C60046---end
   IF NOT cl_null(g_argv1) THEN
      CALL i100_q()
   END IF
 
    SELECT sma120 INTO l_sma120 FROM sma_file
          CALL cl_set_act_visible("style_informate",FALSE)
          CALL cl_set_act_visible("query_attributevalue,produce_sub_parts,maintain_color,maintain_size",FALSE)   #No.FUN-A50011
       IF l_sma120="Y" THEN
          CALL cl_set_comp_visible("ima151",TRUE)
       ELSE
          CALL cl_set_comp_visible("ima151",FALSE)
       END IF
 
   CALL cl_set_comp_visible("imaicd02,imaicd03,imaicd06",FALSE)  #FUN-B30192
   SELECT ica40 INTO l_ica40 FROM ica_file WHERE ica00 = '0'
   IF l_ica40 = 'N' THEN
      CALL cl_set_act_visible("icd_processitem",FALSE)
   END IF
 
   LET g_action_choice = ""
   CALL i100_menu()
 
   CLOSE WINDOW i100_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0074
END MAIN
 
FUNCTION i100_curs()
DEFINE   l_ima151                LIKE ima_file.ima151               #No.FUN-810016
DEFINE   l_n                     LIKE type_file.num5
 
   CLEAR FORM
 
   IF cl_null(g_argv1) THEN
      INITIALIZE g_ima.* TO NULL    #FUN-640213 add
      INITIALIZE g_imaicd.* TO NULL
      CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima06,ima08,ima140,        #No.FUN-640013
                                ima13,ima05,ima03,ima1010,ima93,ima930,ima934,ima932,ima915, #FUN-710060 add ima915 #DEV-D30026-add ima930,ima932 #No:DEV-D30026--add ima934 
                                ima916,                                        #No.FUN-7C0010
                                ima151,                                        #No.FUN-810016
                                imaag,  #No.FUN-640013
                                ima910,#FUN-550017 add ima910                                
                            #   imaicd05,imaicd01,imaicd06,imaicd02,imaicd03,  #FUN-B30192
                                imaicd05,imaicd04,imaicd01,imaicd16,                    #FUN-B30192  #FUN-C30278
                                imaicd10,imaicd12,imaicd09,imaicd08,imaicd17,   #FUN-BC0103 add imaicd17  #FUN-C30278
                                imaicd18,imaicd19,imaicd20,imaicd21,           #FUN-BC0103 
                            #   imaicd13,imaicd11,imaicd14,imaicd15,           #FUN-A40022  #FUN-B30192   #FUN-B50096 
                                imaicd11,imaicd14,imaicd15,                    #FUN-B50096  mark imaicd13
#No.FUN-A50011  -----begin-----
#No.FUN-A50011  ------end------
                              # ima105,ima14,ima107,ima147,ima109,ima903,                          #TQC-AC0185 mark
                                ima105,ima14,ima107,ima147,ima903,                                  #TQC-AC0185
                              # ima905,ima24,ima911,ima022,ima251,ima07,ima70,ima37,ima51,ima52,   #FUN-610080 加ima911  #FUN-A20037 add ima022,ima251  #TQC-AC0185 mark
                                ima24,ima911,ima109,ima07,ima70,ima37,ima51,ima52,   #TQC-AC0185 #FUN-B80186
                                ima27,ima28,ima271,ima71,  #ima909, #FUN-540025 #FUN-560187
                                ima25,ima35,ima36,ima159,ima23,ima906,ima907,ima908,   #FUN-B50096 add ima159 #TQC-C20105 調整順序
                                ima918,ima919,ima920,ima921,ima922,ima923,ima924,ima931,ima933,ima925,  #No.FUN-810036 #DEV-D30026-add   
                                ima928,ima929,        #TQC-B90236--add
                                #ima906,ima907,ima908, #FUN-540025 #TQC-C20105 mark
                                ima12,ima39,ima391,ima163,ima1631,ima149,ima1491,ima164,ima1641,ima15,ima146,ima16,ima905,ima09,  #FUN-680034 #FUN-960141      #TQC-AC0185 add ima905  #FUN-C80094 add--ima163,ima1631 #FUN-D60083 add ima164,ima1641
                                ima10,ima11,ima022,ima251,   #FUN-B80186
                                ima1001,ima1002,ima1012,ima1013,#No.FUN-640010
                               #ima1015,ima1014,ima1016,#No.FUN-640010  #CHI-CA0073 mark 
                                ima1014,ima1016,#No.FUN-640010  #CHI-CA0073 add
#                               ima901,ima902,ima881,ima73,             #No.FUN-8C0131
                                ima901,ima902,ima9021,ima881,ima73,     #No.FUN-8C0131
                                ima74,ima29,ima30,
                                ima156,ima157,ima158,                   #FUN-A80150 add
                                imaud01,imaud02,imaud03,imaud04,imaud05,
                                imaud06,imaud07,imaud08,imaud09,imaud10,
                                imaud11,imaud12,imaud13,imaud14,imaud15,
                                imauser,imagrup,imamodu,imadate,imaacti,
                                imaoriu,imaorig #TQC-C20059 add
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
#No.FUN-A50011 ------begin------
#No.FUN-A50011 -------end------
         AFTER FIELD ima151  
       
            LET l_ima151=GET_FLDBUF(ima151)
            IF l_ima151="Y"   THEN
               CALL cl_set_comp_visible("imaag",TRUE)
               NEXT FIELD imaag
	    ELSE
               CALL cl_set_comp_visible("imaag",FALSE)
            END IF
#No.FUN-A50011 ----begin------
#No.FUN-A50011 ------end------
         ON ACTION controlp
            CASE
#No.FUN-A50011 ------begin-----
#No.FUN-A50011 -------end------
               WHEN INFIELD(ima01) #料件編號    #FUN-4B0001
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_ima"  #MOD-D40072
                  LET g_qryparam.form     = "q_ima011"  #MOD-D40072
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"   #FUN-AB0021  #FUN-AB0025 add ()
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
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
                 #LET g_qryparam.form   = "q_ima251"  #NO.FUN-B30092 mark
                  LET g_qryparam.form   = "q_gfo"     #NO.FUN-B30092
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
               #FUN-C80094---ADD--STR
               WHEN INFIELD(ima163)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima163
                  NEXT FIELD ima163
               WHEN INFIELD(ima1631)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = g_aza.aza82
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1631
                  NEXT FIELD ima1631
               #FUN-C80094--ADD--END
             #FUN-D60083--add--str--
             WHEN INFIELD(ima164)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aag02"
                LET g_qryparam.state    = "c"
                LET g_qryparam.arg1     = g_aza.aza81
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima164
                NEXT FIELD ima164
             WHEN INFIELD(ima1641)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aag02"
                LET g_qryparam.state    = "c"
                LET g_qryparam.arg1     = g_aza.aza82
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima1641
                NEXT FIELD ima1641
             #FUN-D60083--add--end--
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
#TQC-B90236--add--begin
               WHEN INFIELD(ima929)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima929"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = "ima01 IN(SELECT ima929 FROM ima_file)"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima929
#TQC-B90236--add--end 
 
               WHEN INFIELD(imaicd01) #母體料號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imaicd"
                  LET g_qryparam.state    = "c"
             #     LET g_qryparam.where    = " imaicd05='1'"     #FUN-AB0021
                  #LET g_qryparam.where    = " imaicd05='1' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NUL) "  #FUN-AB0021 #FUN-BC0107 mark
                  LET g_qryparam.where    = " (imaicd04='0' OR imaicd04='1') AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NUL) "   #FUN-BC0107
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaicd01
                  NEXT FIELD imaicd01
           #FUN-B30192--begin
           #    WHEN INFIELD(imaicd02) #外編母體 (預測料號)
           #       CALL cl_init_qry_var()
           #       LET g_qryparam.form     = "q_imaicd"
           #       LET g_qryparam.state    = "c"
           #   #    LET g_qryparam.where    = " imaicd05='2'"  #FUN-AB0021
           #       LET g_qryparam.where  = " imaicd05='2' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"        #FUN-AB0021
           #       CALL cl_create_qry() RETURNING g_qryparam.multiret
           #       DISPLAY g_qryparam.multiret TO imaicd02
           #       NEXT FIELD imaicd02
           #    WHEN INFIELD(imaicd03) #外編子體 (客戶下單料號)
           #       CALL cl_init_qry_var()
           #       LET g_qryparam.form     = "q_imaicd"
           #       LET g_qryparam.state    = "c"
           #    #   LET g_qryparam.where    = " imaicd05='4'"            #FUN-AB0021
           #       LET g_qryparam.where    = " imaicd05='4' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"      #FUN-AB0021
           #       CALL cl_create_qry() RETURNING g_qryparam.multiret
           #       DISPLAY g_qryparam.multiret TO imaicd03
           #       NEXT FIELD imaicd03
           #    WHEN INFIELD(imaicd06) #內編子體 (Wafer料號)
           #       CALL cl_init_qry_var()
           #       LET g_qryparam.form     = "q_imaicd"
           #       LET g_qryparam.state    = "c"
           #    #   LET g_qryparam.where    = " imaicd04='1'"      #FUN-AB0021
           #       LET g_qryparam.where    = " imaicd04='1' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"      #FUN-AB0021
           #       CALL cl_create_qry() RETURNING g_qryparam.multiret
           #       DISPLAY g_qryparam.multiret TO imaicd06
           #       NEXT FIELD imaicd06
                WHEN INFIELD(imaicd16)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imaicd"
                  LET g_qryparam.state    = "c"
                 #LET g_qryparam.where    = " imaicd04='4'"   #FUN-B70051
                  LET g_qryparam.where    = " imaicd04=1'"    #FUN-B70051
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaicd16
                  NEXT FIELD imaicd16
           #FUN-B30192--end
               WHEN INFIELD(imaicd10) #作業群組
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_icd11"  #add by hellen
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = 'U'        #add by hellen
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaicd10
                  NEXT FIELD imaicd10
               WHEN INFIELD(imaicd11) #New Code申請單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_icw"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaicd11
                  NEXT FIELD imaicd11
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
              #FUN-A80150---add---start---
               WHEN INFIELD(ima157)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gei2"   #No.MOD-840254  #No.MOD-840294
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ima.ima157
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima157
              #FUN-A80150---add---end---
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
             # " WHERE ",g_wc CLIPPED,                                                      #FUN-A90049 mark
               " WHERE ( ima120 IS NULL OR ima120 = ' ' OR ima120 = '1' ) AND ",g_wc CLIPPED,    #FUN-A90049 add
               " ORDER BY ima01"
   IF g_wc.getindexof('imaicd',1)>0 THEN
      LET g_sql = "SELECT ima_file.ima01 FROM ima_file,imaicd_file ", # 組合出 SQL 指令
                # " WHERE ima01=imaicd00 AND ",g_wc CLIPPED,                                                     #FUN-A90049 mark
                  " WHERE ( ima120 IS NULL OR ima120 = ' ' OR ima120 = '1' ) AND ima01=imaicd00 AND ",g_wc CLIPPED,   #FUN-A90049 add
                  " ORDER BY ima01"
   END IF
   PREPARE aimi100_prepare FROM g_sql
   DECLARE aimi100_curs SCROLL CURSOR WITH HOLD FOR aimi100_prepare
 
  #DECLARE aimi100_list_cur CURSOR FOR aimi100_prepare      #FUN-C90107 mark
 
 # LET g_sql= "SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED                                                    #FUN-A90049 makr
   LET g_sql= "SELECT COUNT(*) FROM ima_file WHERE ( ima120 IS NULL OR ima120 = ' ' OR ima120 = '1' ) AND ",g_wc CLIPPED  #FUN-A90049 add 
   IF g_wc.getindexof('imaicd',1)>0 THEN
      LET g_sql= "SELECT COUNT(*) FROM ima_file,imaicd_file",
               # " WHERE ima01=imaicd00 AND ",g_wc CLIPPED                                                      #FUN-A90049 mark
                 " WHERE ( ima120 IS NULL OR ima120 = ' ' OR ima120 = '1' ) AND ima01=imaicd00 AND ",g_wc CLIPPED    #FUN-A90049 add
   END IF
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
   DEFINE l_count   LIKE type_file.num5      #FUN-BC0100
   DEFINE l_icu01   LIKE icu_file.icu01      #FUN-BC0106
   DEFINE l_icu02   LIKE icu_file.icu02      #FUN-BC0106
   DEFINE l_str     STRING                   #FUN-C60061
   DEFINE l_ima01   LIKE ima_file.ima01      #FUN-C60061
   MENU ""
 
      BEFORE MENU
         CALL cl_set_act_visible("add_multi_attr_sub",FALSE)     #No.MOD-5A0223 --add
         CALL cl_set_act_visible("assign_product_strategy",g_azw.azw04 = '2')  #FUN-A90049 add   
         CALL cl_navigator_setting(g_curs_index, g_row_count)    #No.MOD-680064 add
         IF cl_null(g_sma.sma901) OR g_sma.sma901='N' THEN
             CALL cl_set_act_visible("aps_related_data",FALSE)
         END IF
      ON ACTION item_list
         LET g_action_choice = ""  #MOD-8A0193 add
         CALL i100_b_menu()   #MOD-8A0193
         IF g_action_choice = "exit" THEN  #MOD-D30241
            EXIT MENU  #MOD-D30241
         END IF   #MOD-D30241
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
           #CALL i100_x()               #FUN-C90107 mark  #TQC-CB0079 remark  #FUN-C90107 mark
            CALL i100sub_x(g_ima.ima01) #FUN-C90107 add  #TQC-CB0079 mark     #FUN-C90107 add
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

     #No.FUN-9C0089 add begin------------------
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         IF cl_chk_act_auth() THEN
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima_l),'','')
         END IF
     #No.FUN-9C0089 add -end-------------------
 
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

#NO.FUN-B30092  ------------------------add start------------------------
      ON ACTION quantifying
         LET g_msg="aooi104 '",g_ima.ima01,"'"
         CALL cl_cmdrun_wait(g_msg) 
         CALL i100_show()
#NO.FUN-B30092 --------------------------add end------------------------
 
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
            SELECT * INTO g_imaicd.*
              FROM imaicd_file
             WHERE imaicd00=g_ima.ima01
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
            SELECT * INTO g_imaicd.*
              FROM imaicd_file
             WHERE imaicd00=g_ima.ima01
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
            SELECT * INTO g_imaicd.*
              FROM imaicd_file
             WHERE imaicd00=g_ima.ima01
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

#FUN-C60021-----MARK----STR--- 
#      ON ACTION add_multi_attr_sub
#         IF cl_null(g_ima.ima01) THEN
#            CALL cl_err('',-400,1)
#         ELSE
#              IF g_ima.ima1010 !='1' THEN               # NO.FUN-870117 
#                 CALL cl_err(g_ima.ima01,'aim-450',1)   # NO.FUN-870117
#              ELSE                                      # NO.FUN-870117
#                 LET g_action_choice="add_multi_attr_sub"
#                 CALL saimi311(g_ima.ima01)
#&ifdef SLK
#                 CALL i100_upd_ima()        #FUN-B90103
#&endif
#                 LET INT_FLAG=0        #No.FUN-640013 退出子程序后INT_FLAG為1,要置0
#                 CALL i100_show()
#              END IF                                    # NO.FUN-870117  
#         END IF
#FUN-C60021------MARK-----END-------
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
           #FUN-A70106--mod---str--
           #CALL i100_confirm() #mark
            CALL i100sub_y_chk(g_ima.ima01)
            IF g_success = 'Y' THEN
                IF cl_confirm('aap-222') THEN 
                    CALL i100sub_y_chk(g_ima.ima01) #CHI-C30107 add
                    IF g_success = 'Y' THEN  #CHI-C30107 add 
                    BEGIN WORK
                      CALL i100sub_y_upd(g_ima.ima01)
                    IF g_success = 'Y' THEN
                        #FUN-BC0100---begin---
                        LET l_count = 0
                        IF NOT cl_null(g_imaicd.imaicd01) THEN
                           SELECT COUNT(1) INTO l_count FROM icf_file
                           WHERE icf01 = g_imaicd.imaicd01
                           IF l_count = 0 THEN
                              INSERT INTO icf_file(icf01,icf02,icf04,icf05)
                              VALUES(g_imaicd.imaicd01,'BIN01','Y','0')
                           END IF
                        END IF
                        LET l_count = 0
                        IF NOT cl_null(g_imaicd.imaicd16) THEN
                           SELECT COUNT(1) INTO l_count FROM icf_file
                           WHERE icf01 = g_imaicd.imaicd16
                           IF l_count = 0 THEN
                              INSERT INTO icf_file(icf01,icf02,icf04,icf05)
                              VALUES(g_imaicd.imaicd16,'BIN01','Y','0')
                           END IF
                        END IF
                        #FUN-BC0106 --START--
                        LET l_count = 0
                        IF NOT cl_null(g_imaicd.imaicd01) THEN
                           SELECT icu01,icu02 INTO l_icu01,l_icu02 
                            FROM icu_file WHERE icu01 = g_imaicd.imaicd01
                             AND icu02 = g_ima.ima94
                           IF SQLCA.sqlcode = 0 THEN
                              CALL s_aic_bom_ins(l_icu01,l_icu02,'',g_ima.ima01)
                              #FUN-C60061---begin
                              LET l_str = NULL
                              DECLARE ima01_c1 CURSOR FOR SELECT imaicd00
                                                              FROM imaicd_file
                                                             WHERE imaicd11 = g_ima.ima01
                              FOREACH ima01_c1 INTO l_ima01
                                 IF cl_null(l_str) THEN
                                    LET l_str = l_ima01
                                 ELSE
                                    LET l_str = l_str,',',l_ima01
                                 END IF 
                              END FOREACH 
                              IF NOT cl_null(l_str) THEN 
                                 CALL cl_err(l_str,'aim-168',1)
                              END IF 
                              #FUN-C60061---end
                           END IF 
                        END IF  
                        #FUN-BC0106 --END--
                        #FUN-BC0100---end---
                       #CALL i100_list_fill()    #FUN-C90107 mark
                        CALL i100sub_list_fill() #FUN-C90107 add
                        COMMIT WORK
                        CALL i100sub_refresh(g_ima.ima01) RETURNING g_ima.*
                        CALL i100sub_carry(g_ima.ima01)
                    ELSE
                        ROLLBACK WORK
                    END IF
                  END IF   #CHI-C30107 add 
                END IF
            END IF
           #FUN-A70106--mod---end--
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
       
      #FUN-A90049 ------------------------add start------------------------
       ON ACTION assign_product_strategy 
          LET g_action_choice = "assign_product_strategy"
          IF cl_chk_act_auth() THEN
             CALL i100_assign_product_strategy()
          END IF 
      #FUN-A90049 -----------------------add end------------------------     

#TQC-B90236--add--begin
       ON ACTION feature_maintain
          LET g_action_choice = "feature_maintain"
          IF cl_chk_act_auth() THEN
             CALL i100_feature_maintain()
          END IF
#TQC-B90236--add--end
       #FUN-BC0106 --START--
       ON ACTION icd_processitem
          LET g_action_choice = "icd_processitem"
          IF cl_chk_act_auth() THEN  
             #TQC-C30137---begin      
             #IF cl_null(g_ima.ima94) THEN              #MOD-C30233 mark
             #   CALL cl_err('g_ima.ima94','aim-041',1) #MOD-C30233 mark
             #ELSE                                      #MOD-C30233 mark
             #TQC-C30137---end    
             LET l_cmd = "aici020 '",g_imaicd.imaicd01,"' ' '"                          
             CALL cl_cmdrun_wait(l_cmd)  
             #FUN-C50110---begin
             SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01

             SELECT * INTO g_imaicd.*
               FROM imaicd_file
              WHERE imaicd00=g_ima.ima01

             CALL i100_show()
             #FUN-C50110---end
             #END IF   #TQC-C30137                      #MOD-C30233 mark           
          END IF
       #FUN-BC0106 --END--
       #FUN-BC0107 --START--
       ON ACTION icd_base_data
          IF NOT cl_null(g_ima.ima01) THEN
             LET g_action_choice="icd_base_data"
             IF cl_chk_act_auth() THEN
                LET g_msg="aici001 '",g_ima.ima01,"'"
                CALL cl_cmdrun_wait(g_msg)
             END IF
          END IF
       #FUN-BC0107 --END--
#FUN-B30192--mark
#&ifdef ICD
#      ON ACTION icd_base_data
#         IF NOT cl_null(g_ima.ima01) THEN
#            LET g_action_choice="icd_base_data"
#            IF cl_chk_act_auth() THEN
#               LET g_msg="aici001 '",g_ima.ima01,"'"
#               CALL cl_cmdrun_wait(g_msg)
#            END IF
#         END IF
#      ON ACTION icd_maskgroup
#         IF NOT cl_null(g_ima.ima01) THEN
#            LET g_action_choice="icd_maskgroup"
#            IF cl_chk_act_auth() THEN
#               SELECT icb02 INTO g_icb02 FROM icb_file,imaicd_file   #No.FUN-920114
#                 WHERE imaicd00 = g_ima.ima01 AND icb01 = imaicd01   #No.FUN-920114
#               LET g_msg="aici004 '",g_icb02,"'"   #No.FUN-920114
#               CALL cl_cmdrun_wait(g_msg)
#            END IF
#         END IF
#      ON ACTION icd_processitem
#         IF NOT cl_null(g_ima.ima01) THEN
#            LET g_action_choice="icd_processitem"
#            IF cl_chk_act_auth() THEN
#               SELECT imaicd01 INTO g_imaicd.imaicd01 FROM imaicd_file   #No.FUN-920114
#                 WHERE imaicd00 = g_ima.ima01                            #No.FUN-920114
#              #LET g_msg="aici020 '",g_imaicd.imaicd01,"'"               #No.FUN-920114 #MOD-B30519
#               LET g_msg="aici020 '",g_imaicd.imaicd01,"' ''"            #MOD-B30519
#               CALL cl_cmdrun_wait(g_msg)
#            END IF
#         END IF
#&endif
#FUN-B30192---mark
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
               LET l_vmi.vmi65 = 0    #FUN-930087 ADD
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
   #MOD-D10193---begin
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'a') THEN                                                                          
      CALL cl_err(g_ima.ima916,'aoo-078',1)                                                                                        
      RETURN                                                                                                                       
   END IF  
   #MOD-D10193---end
   CLEAR FORM                                   # 清螢墓欄位內容
   INITIALIZE g_ima.* LIKE ima_file.*        
   LET g_ima01_t = NULL
   LET g_ima_o.*=g_ima.*
   INITIALIZE g_imaicd.* LIKE imaicd_file.*
   LET g_imaicd_o.*=g_imaicd.*
   CALL i100_default()
   CALL cl_opmsg('a')
   #MOD-D10193---begin 移到上面
   #IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'a') THEN                                                                          
   #   CALL cl_err(g_ima.ima916,'aoo-078',1)                                                                                        
   #   RETURN                                                                                                                       
   #END IF   
   #MOD-D10193---end
   WHILE TRUE
      
      LET g_ima.ima151='N'                       # No.FUN-810016
      LET g_ima.ima928='N'                       # No.TQC-B90236--add
      CALL cl_set_comp_visible("imaag",FALSE)    # No.FUN-810016
      INITIALIZE g_ima_o.*  TO NULL
      INITIALIZE g_imaicd_o.*  TO NULL
      IF g_aza.aza28 = 'Y' THEN
         CALL s_auno(g_ima.ima01,'1','') RETURNING g_ima.ima01,g_ima.ima02  #No.FUN-850100
      END IF
     
      CALL i100_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_ima.* TO NULL
         INITIALIZE g_imaicd.* TO NULL
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
   DEFINE l_imz156        LIKE imz_file.imz156    #FUN-A80150 add  
   DEFINE l_imz157        LIKE imz_file.imz157    #FUN-A80150 add  
   DEFINE l_imz158        LIKE imz_file.imz158    #FUN-A80150 add  
   DEFINE l_ima918        LIKE ima_file.ima918    #TQC-C20281 add
   DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3,#No.FUN-A20044
          l_unavl_stk      LIKE type_file.num15_3,#No.FUN-A20044
          l_avl_stk        LIKE type_file.num15_3 #No.FUN-A20044  
   DEFINE l_count         LIKE type_file.num5     #No.DEV-D30026

   DEFINE l_imac          RECORD LIKE imac_file.* #No.TQC-B90236
   DEFINE l_case          STRING                   #FUN-BB0083 add
   
   DISPLAY BY NAME g_ima.ima901,g_ima.imauser,g_ima.imagrup,
                   g_ima.imadate,g_ima.imaacti
                   ,g_ima.ima151           #No.FUN-810016
                   ,g_ima.ima928           #TQC-B90236--add
 
   DISPLAY BY NAME g_ima.ima906,g_ima.ima907,g_ima.ima908,g_ima.ima159, #,g_ima.ima909 #FUN-560187   #FUN-B50096 add ima159
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
   BEGIN WORK     #MOD-C30147 add
   INPUT BY NAME g_ima.imaoriu,g_ima.imaorig,
        g_ima.ima01, g_ima.ima02, g_ima.ima021,
        g_ima.ima06,g_ima.ima08 ,g_ima.ima140,
        g_ima.ima13, g_ima.ima05,g_ima.ima03,
        g_ima.ima93,g_ima.ima930,g_ima.ima934,g_ima.ima932,g_ima.ima915,  #FUN-710060 add ima915 #DEV-D30026-add ima930,ima932 #No:DEV-D30026--add ima934
        g_ima.ima151,     #No.FUN-810016
        g_ima.imaag, #No.FUN-640013
        g_ima.ima910,
     #  g_imaicd.imaicd05,g_imaicd.imaicd01,g_imaicd.imaicd06,   #FUN-B30192
     #  g_imaicd.imaicd02,g_imaicd.imaicd03,g_imaicd.imaicd04,   #FUN-B30192
        g_imaicd.imaicd05,g_imaicd.imaicd04,g_imaicd.imaicd01,g_imaicd.imaicd16,   #FUN-B30192  #FUN-C30278
        g_imaicd.imaicd10,g_imaicd.imaicd12,g_imaicd.imaicd14,g_imaicd.imaicd15,g_imaicd.imaicd09,
     #  g_imaicd.imaicd08,g_imaicd.imaicd13,   #FUN-A40022  #FUN-B30192  #FUN-B50096
        g_imaicd.imaicd08,g_imaicd.imaicd17,    #FUN-B50096  mark imaicd13 #FUN-BC0103 add imaicd17
        g_imaicd.imaicd18,g_imaicd.imaicd19,g_imaicd.imaicd20,g_imaicd.imaicd21,   #FUN-BC0103
        g_ima.ima105,g_ima.ima14, g_ima.ima107,g_ima.ima147,   #FUN-550014 add ima910
      # g_ima.ima109,g_ima.ima903, g_ima.ima905,g_ima.ima24,g_ima.ima911,   #FUN-610080 加ima911    #TQC-AC0185 mark 
        g_ima.ima903, g_ima.ima905,g_ima.ima24,g_ima.ima911,g_ima.ima109,   #TQC-AC0185             	  
        g_ima.ima07, g_ima.ima70 ,g_ima.ima37 , g_ima.ima51,
        g_ima.ima52, g_ima.ima27, g_ima.ima28 , g_ima.ima271,g_ima.ima71,
        g_ima.ima25, g_ima.ima35, g_ima.ima36,g_ima.ima159, g_ima.ima23,g_ima.ima906,g_ima.ima907,g_ima.ima908,   #FUN-B50096  add ima159 #TQC-C20105 調整順序
        g_ima.ima918,g_ima.ima919,g_ima.ima920,g_ima.ima921,  #No.FUN-810036
        g_ima.ima922,g_ima.ima923,g_ima.ima924,g_ima.ima931,g_ima.ima933,g_ima.ima925,  #No.FUN-810036  #DEV-D30026-add ima931,ima933
        g_ima.ima928,g_ima.ima929,            #TQC-B90236--add
        #g_ima.ima906,g_ima.ima907,g_ima.ima908, #FUN-540025  ##TQC-C20105 mark                   
        g_ima.ima12, g_ima.ima39,g_ima.ima391,  #FUN-680034
        g_ima.ima163,g_ima.ima1631,             #FUN-C80094
        g_ima.ima164,g_ima.ima1641,   #FUN-D60083 add
        g_ima.ima149,g_ima.ima1491,   #FUN-960141 add
        g_ima.ima15, g_ima.ima146,g_ima.ima16 ,
        g_ima.ima09, g_ima.ima10, g_ima.ima11 ,
        g_ima.ima022,g_ima.ima251,     #FUN-A20037 add #FUN-B80186
        g_ima.ima9021,                                #No.FUN-8C0031 add by dxfwo        
        g_ima.ima1001, g_ima.ima1002,                 #No.FUN-640010
        g_ima.ima1012, g_ima.ima1013,                 #No.FUN-640010
       #g_ima.ima1015, g_ima.ima1014,g_ima.ima1016,   #No.FUN-640010   #CHI-CA0073 mark 
        g_ima.ima1014,g_ima.ima1016,   #No.FUN-640010   #CHI-CA0073 add
        g_ima.ima156,g_ima.ima157,g_ima.ima158,       #FUN-A80150 add
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
            #FUN-BB0083---add---str
            IF p_cmd = 'u' THEN
               LET g_ima25_t = g_ima.ima25
            END IF
            IF p_cmd = 'a' THEN
               LET g_ima25_t = NULL
            END IF
            #FUN-BB0083---add---end
            CALL cl_chg_comp_att("ima01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
            #CALL i100_ind_icd_chg_imaicd05(g_imaicd.imaicd05)  #FUN-810038 #FUN-C30278
            CALL i100_ind_icd_chg_imaicd04(g_imaicd.imaicd04)   #FUN-C30278
          
        BEFORE FIELD ima01
            IF g_sma.sma60 = 'Y' THEN# 若須分段輸入
               CALL s_inp5(6,14,g_ima.ima01) RETURNING g_ima.ima01
               DISPLAY BY NAME g_ima.ima01
            END IF
#No.FUN-D40110 ---------- add ----------- begin --------------------
            IF g_azw.azw04 = '2' AND p_cmd='a' THEN
               LET g_ima.ima08 = 'P'
               LET g_ima.ima16 = '0'
               LET g_ima.ima57 = '99'
               DISPLAY BY NAME g_ima.ima08
               DISPLAY BY NAME g_ima.ima16
               DISPLAY BY NAME g_ima.ima57
            END IF
#No.FUN-D40110 ---------- add ----------- end ----------------------
 
       #DEV-D40019 add str------
        IF p_cmd = 'a' THEN
           LET g_ima.ima930 = 'N' 
           LET g_ima.ima931 = 'N'
        END IF
       #DEV-D40019 add end------
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
          #TQC-C50222--add--str--
          IF g_ima.ima151 = "N" THEN
             LET g_ima.imaag  = NULL
             DISPLAY BY NAME g_ima.imaag
          ELSE
             IF NOT cl_null(g_ima_t.imaag) AND cl_null(g_ima.imaag) THEN
                LET g_ima.imaag = g_ima_t.imaag
             END IF
             DISPLAY BY NAME g_ima.imaag
          END IF
          #TQC-C50222--add--end--
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
           #CHI-B50017 --- modify --- start
            SELECT imz02 INTO g_buf_2 FROM imz_file WHERE imz01=g_ima.ima06
            DISPLAY g_buf_2 To imz02
           #CHI-B50017 --- modify --- end
           IF NOT i100_chk_ima06(p_cmd) THEN
              NEXT FIELD CURRENT
           ELSE
              IF cl_null(g_errno)  AND g_ans ="1"  THEN
                 SELECT imz150,imz152,imz156,imz157,imz158 INTO l_imz150,l_imz152,l_imz156,l_imz157,l_imz158 FROM imz_file                  #FUN-A80150 add imz156,imz157,imz158
                            WHERE imz01=g_ima.ima06
                 LET g_ima.ima150=l_imz150
                 LET g_ima.ima152=l_imz152
                 LET g_ima.ima156=l_imz156   #FUN-A80150 add 
                 LET g_ima.ima157=l_imz157   #FUN-A80150 add 
                 LET g_ima.ima158=l_imz158   #FUN-A80150 add  
                 CALL i100_ins_imac()        #MOD-C30147 add
                 CALL i100_show()
                 LET g_errno = ''  #No.FUN-A50011
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
#FUN-B90103--------add----------------
#FUN-B90103--------end----------------
 
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
          IF cl_null(g_ima.ima022) THEN
             LET g_ima.ima022 = 0
          END IF 

       AFTER FIELD ima251
          IF NOT cl_null(g_ima.ima251) THEN 
             #CALL i251_chk()        #FUN-B30092
              CALL i100_ima251_chk()        
              IF NOT cl_null(g_errno) THEN CALL cl_err('',g_errno,0) NEXT FIELD CURRENT END IF END IF 
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

         AFTER FIELD ima9021 
           IF g_ima.ima902 IS NULL AND  g_ima.ima9021 IS NOT NULL THEN
              LET g_ima.ima902 = g_ima.ima9021 
           END IF
 
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
          #str MOD-A60104 add
          #新增時,若有修改庫存單位(ima25)也應詢問aim-020 
           IF NOT cl_null(g_ima.ima25) AND p_cmd='a' THEN
              IF g_ima.ima25 <> g_ima_o.ima25 OR
                 g_ima.ima63 <> g_ima.ima25 OR
                 g_ima.ima31 <> g_ima.ima25 OR
                 g_ima.ima44 <> g_ima.ima25 OR
                 g_ima.ima55 <> g_ima.ima25 THEN
                 LET g_msg=cl_getmsg('aim-020',g_lang)
                 IF cl_prompt(0,0,g_msg) THEN
                    CALL i100_a_updchk()
                 END IF
              END IF
           END IF
          #end MOD-A60104 add
          #MOD-C60228 add begin-------------------   
           IF g_sma.sma116 <> '0' AND NOT cl_null(g_ima.ima25) THEN 
              IF g_ima_o.ima25 IS NULL OR g_ima.ima25<>g_ima_o.ima25 THEN  
                 SELECT COUNT(*) INTO l_n FROM ima_file
                  WHERE ima908 <> g_ima.ima25 AND ima01=g_ima.ima01
                 IF l_n > 0 THEN
                    LET g_msg=cl_getmsg('aim1161',g_lang)
                    IF cl_prompt(0,0,g_msg) THEN
                       LET g_ima.ima908 = g_ima.ima25 #計價單位
                    END IF 
                 ELSE
                    IF g_ima.ima908 <> g_ima.ima25 THEN
                       LET g_msg=cl_getmsg('aim1161',g_lang)
                       IF cl_prompt(0,0,g_msg) THEN
                          LET g_ima.ima908 = g_ima.ima25 #計價單位
                       END IF
                    END IF
                 END IF
              END IF
           END IF 
          #MOD-C60228 add end---------------------
           
           LET g_ima_o.ima25 = g_ima.ima25
           LET g_ima.ima86=g_ima.ima25
           CALL i100_unit_fac()     #TQC-940110 add
          #FUN-BB0083---add---str
              LET l_case = '' 
              IF NOT i100_ima52_check() THEN
                 LET l_case = "ima52"
              END IF
              IF NOT i100_ima51_check() THEN
                 LET l_case = "ima51"
              END IF
              IF NOT i100_ima271_check() THEN
                 LET l_case = "ima271"
              END IF
              IF NOT i100_ima28_check() THEN
                 LET l_case = "ima28"
              END IF
              IF NOT i100_ima27_check() THEN
                 LET l_case = "ima27"
              END IF
              LET g_ima25_t = g_ima.ima25
              CASE l_case
                   WHEN "ima27"
                      NEXT FIELD ima27
                   WHEN "ima28"
                      NEXT FIELD ima28
                   WHEN "ima271"
                      NEXT FIELD ima271
                   WHEN "ima51"
                      NEXT FIELD ima51
                   WHEN "ima52"
                      NEXT FIELD ima52
                   OTHERWISE EXIT CASE
               END CASE
          #FUN-BB0083---add---end
          
        AFTER FIELD ima35
           IF NOT i100_chk_ima35() THEN
              NEXT FIELD CURRENT
           END IF
	IF NOT s_imechk(g_ima.ima35,g_ima.ima36) THEN NEXT FIELD ima36 END IF  #FUN-D40103 add
 
        AFTER FIELD ima36
	IF cl_null(g_ima.ima36) THEN LET g_ima.ima36 = ' ' END IF  #FUN-D40103 add
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
           IF NOT i100_ima27_check() THEN NEXT FIELD ima27 END IF #FUN-BB0083 add
           #FUN-BB0083---mark---str
           #IF g_ima.ima27 IS NOT NULL THEN
           #   IF g_ima.ima27 <0 THEN
           #      CALL cl_err('','mfg4012',0)
           #      NEXT FIELD ima27
           #   END IF
           #END IF
           #FUN-BB0083---mark---end
 
        AFTER FIELD ima28
           IF NOT i100_ima28_check() THEN NEXT FIELD ima28 END IF #FUN-BB0083 add
           #FUN-BB0083---mark---str
           #IF g_ima.ima28 IS NOT NULL THEN
           #   IF g_ima.ima28 <0 THEN
           #      CALL cl_err('','mfg4012',0)
           #      NEXT FIELD ima28
           #   END IF
           #END IF
           #FUN-BB0083---mark---end
 
        AFTER FIELD ima271
           IF NOT i100_ima271_check() THEN NEXT FIELD ima271 END IF #FUN-BB0083 add
           #FUN-BB0083---mark---str
           #IF g_ima.ima271 IS NOT NULL THEN
           #   IF g_ima.ima271 <0 THEN
           #      CALL cl_err('','mfg4012',0)
           #      NEXT FIELD ima271
           #   END IF
           #END IF
           #FUN-BB0083---mark---end
 
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
           IF NOT i100_ima51_check() THEN NEXT FIELD CURRENT END IF #FUN-BB0083 add
           #FUN-BB0083---mark---str
           #IF NOT i100_chk_ima51() THEN
           #   NEXT FIELD CURRENT
           #END IF
           #LET g_ima_o.ima51 = g_ima.ima51
           #FUN-BB0083---mark---str
 
        AFTER FIELD ima52
           IF NOT i100_ima52_check() THEN NEXT FIELD CURRENT END IF #FUN-BB0083 add
           #FUN-BB0083---mark---str
           #IF NOT i100_chk_ima52() THEN
           #   NEXT FIELD CURRENT
           #END IF
           #LET g_ima_o.ima52 = g_ima.ima52
           #FUN-BB0083---mark---str
 
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
    
        #FUN-C80094---ADD---STR
        AFTER FIELD ima163
            IF NOT cl_null(g_ima.ima163) OR g_ima.ima163 != ' '  THEN
               IF NOT i100_chk_ima163() THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag02"
                  LET g_qryparam.default1 = g_ima.ima163
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_aza.aza81
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_ima.ima163 CLIPPED,"%' "
                  CALL cl_create_qry() RETURNING g_ima.ima163
                  DISPLAY BY NAME g_ima.ima163
                  NEXT FIELD ima163
               END IF
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_ima.ima163
                         AND aag07 != '1'
                         AND aag00 = g_aza.aza81
               MESSAGE l_buf CLIPPED
            END IF
            LET g_ima_o.ima163 = g_ima.ima163

        AFTER FIELD ima1631
            IF NOT cl_null(g_ima.ima1631) OR g_ima.ima1631 != ' '  THEN
               IF NOT i100_chk_ima1631() THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag02"
                  LET g_qryparam.default1 = g_ima.ima1631
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_aza.aza82
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_ima.ima1631 CLIPPED,"%' "
                  CALL cl_create_qry() RETURNING g_ima.ima1631
                  DISPLAY BY NAME g_ima.ima1631
                  NEXT FIELD ima1631
               END IF
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_ima.ima1631
                         AND aag07 != '1'
                         AND aag00 = g_aza.aza82
               MESSAGE l_buf CLIPPED
            END IF
            LET g_ima_o.ima1631 = g_ima.ima1631

        #FUN-C80094--ADD--END

        #FUN-D60083--add--str--
        AFTER FIELD ima164
            IF NOT cl_null(g_ima.ima164) OR g_ima.ima164 != ' '  THEN
               IF NOT i100_chk_ima164() THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag02"
                  LET g_qryparam.default1 = g_ima.ima164
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_aza.aza81
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_ima.ima164 CLIPPED,"%' "
                  CALL cl_create_qry() RETURNING g_ima.ima164
                  DISPLAY BY NAME g_ima.ima164 
                  NEXT FIELD ima164
               END IF
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_ima.ima164
                         AND aag07 != '1'
                         AND aag00 = g_aza.aza81
               MESSAGE l_buf CLIPPED
            END IF
            LET g_ima_o.ima164 = g_ima.ima164
          
        AFTER FIELD ima1641
            IF NOT cl_null(g_ima.ima1641) OR g_ima.ima1641 != ' '  THEN
               IF NOT i100_chk_ima1641() THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag02"
                  LET g_qryparam.default1 = g_ima.ima1641
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_aza.aza82
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_ima.ima1641 CLIPPED,"%' "
                  CALL cl_create_qry() RETURNING g_ima.ima1641
                  DISPLAY BY NAME g_ima.ima1641
                  NEXT FIELD ima1641
               END IF
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_ima.ima1641
                         AND aag07 != '1'
                         AND aag00 = g_aza.aza82
               MESSAGE l_buf CLIPPED
            END IF
            LET g_ima_o.ima1641 = g_ima.ima1641
        #FUN-D60083--add--end--

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
 
#FUN-B90035 ------------Begin--------------
      AFTER FIELD ima159
         IF cl_null(g_ima.ima159) THEN
            LET g_ima.ima159 = '3'
         END IF
         DISPLAY BY NAME g_ima.ima159
#FUN-B90035 ------------End----------------
      BEFORE FIELD ima918
        #CALL I100_set_entry(p_cmd)      #CHI-B80032 mark
         CALL i100_set_entry(p_cmd)      #CHI-B80032
         CALL i100_set_no_entry(p_cmd)   #CHI-B80032
 
      ON CHANGE ima918
         IF cl_null(g_ima.ima918) OR g_ima.ima918 = 'N' THEN
            LET g_ima.ima919 = 'N'
            LET g_ima.ima920 = NULL
            CALL i100_set_no_required() 
            DISPLAY BY NAME g_ima.ima919
            DISPLAY BY NAME g_ima.ima920
         END IF 
         #MOD-C30091---begin
         IF g_ima.ima918 = 'Y' AND cl_null(g_ima.ima925) THEN 
            LET g_ima.ima925 = '1'
            DISPLAY BY NAME g_ima.ima925
         END IF 
         #MOD-C30091---end
         CALL i100_set_no_entry(p_cmd)

        #CHI-B80043 --- modify --- start ---
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM rvbs_file
          WHERE rvbs021 = g_ima.ima01 AND rvbs04 !=' '    #MOD-C30066 add AND rvbs04 !=' '
         IF l_n > 0 THEN
            CALL cl_err('','aim1141',0)
            LET g_ima.ima918 = 'Y'
            DISPLAY BY NAME g_ima.ima918
         END IF
        #CHI-B80043 --- modify ---  end  ---
 
      #TQC-C40021--add--str--
      AFTER FIELD ima918 
         IF cl_null(g_ima.ima918) OR g_ima.ima918 = 'N' THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM imac_file
                WHERE imac01 = g_ima.ima01
                  AND imac03 = 2
            IF l_n > 0 THEN
               CALL cl_err('','aim1157',0)
               LET g_ima.ima918 = 'Y'
               DISPLAY BY NAME g_ima.ima918
               NEXT FIELD ima918    #TQC-C40044 add
            END IF  
         END IF   
      #TQC-C40021--add--end--
 
      BEFORE FIELD ima919
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd) #CHI-B80032 add
         CALL i100_set_no_required()   #No.MOD-840257
         CALL i100_set_required()      #CHI-B80032 add
 
     #AFTER FIELD ima919  #MOD-A50099 mark
      ON CHANGE ima919    #MOD-A50099
#CHI-B80032 -- begin --
         IF cl_null(g_ima.ima919) OR g_ima.ima919 = 'N' THEN
            LET g_ima.ima920 = NULL
            DISPLAY BY NAME g_ima.ima920
         END IF
#CHI-B80032 -- end --
         CALL i100_set_no_entry(p_cmd)
         CALL i100_set_required()   #No.MOD-840257
 
      AFTER FIELD ima920
         IF NOT cl_null(g_ima.ima920) THEN
          #DEV-D30026--add--begin--------------
            IF g_ima.ima930 = 'Y' THEN
               LET l_count= 0
               SELECT COUNT(*) INTO l_count FROM gei_file,geh_file
                WHERE gei03 = geh01 AND geiacti = "Y" AND gei01 = g_ima.ima920 AND geh04 IN ('5','F','G')
               IF l_count = 0 THEN
                  CALL cl_err(g_ima.ima920,'mfg-978',0)
                  NEXT FIELD ima920
               END IF
            ELSE 
          #DEV-D30026--add--end----------------
               SELECT COUNT(*) INTO l_n FROM geh_file,gei_file   #No.MOD-840254  #No.MOD-840294
                WHERE geh04 = '5'   #No.MOD-840254
                  AND geh01 = gei03  #No.MOD-840294
                  AND gei01 = g_ima.ima920   #No.MOD-840254  #No.MOD-840294
               IF l_n = 0 THEN
                  CALL cl_err(g_ima.ima920,'aoo-112',0)
                  NEXT FIELD ima920
               END IF
            END IF           #DEV-D30026--add

            #DEV-D30036--add--begin
            CALL i100_chk_ghe(g_ima.ima920)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ima.ima920,g_errno,0)
               NEXT FIELD ima920
            END IF
            #DEV-D30036--add--end
         END IF
 
      BEFORE FIELD ima921
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd)   #CHI-B80032 add
 
      ON CHANGE ima921
         IF cl_null(g_ima.ima921) OR g_ima.ima921 = 'N' THEN
            LET g_ima.ima922 = 'N'
            LET g_ima.ima923 = NULL
            LET g_ima.ima924 = 'N'   #CHI-B80032 add
            CALL i100_set_no_required() 
            DISPLAY BY NAME g_ima.ima922
            DISPLAY BY NAME g_ima.ima923
            DISPLAY BY NAME g_ima.ima924   #CHI-B80032 add
         END IF 
         #DEV-D30033--begin
         IF g_ima.ima921 = 'Y' THEN
            IF g_ima.ima930 = 'Y' THEN
               LET g_ima.ima924 = 'Y'
               DISPLAY BY NAME g_ima.ima924
            END IF
         END IF
         #DEV-D30033--end
         #MOD-C30091---begin
         IF g_ima.ima921 = 'Y' AND cl_null(g_ima.ima925) THEN 
            LET g_ima.ima925 = '1'
            DISPLAY BY NAME g_ima.ima925
         END IF 
         #MOD-C30091---end
         CALL i100_set_no_entry(p_cmd)
        #CHI-B80043 --- modify --- start ---
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM rvbs_file
          WHERE rvbs021 = g_ima.ima01 AND rvbs03 !=' '    #MOD-C30066 add AND rvbs03 !=' '
         IF l_n > 0 THEN
            CALL cl_err('','aim1141',0)
            LET g_ima.ima921 = 'Y'
            DISPLAY BY NAME g_ima.ima921
         END IF
        #CHI-B80043 --- modify ---  end  ---

      BEFORE FIELD ima922
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd) #CHI-B80032 add
         CALL i100_set_no_required()   #No.MOD-840257
         CALL i100_set_required()      #CHI-B80032 add
 
     #AFTER FIELD ima922  #MOD-A50099 mark
      ON CHANGE ima922    #MOD-A50099
#CHI-B80032 -- begin --
         IF cl_null(g_ima.ima922) OR g_ima.ima922 = 'N' THEN
            LET g_ima.ima923 = NULL
            DISPLAY BY NAME g_ima.ima923
         END IF
#CHI-B80032 -- end --
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
            #DEV-D30036--add--begin
            CALL i100_chk_ghe(g_ima.ima923)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ima.ima923,g_errno,0)
               NEXT FIELD ima923
            END IF
            #DEV-D30036--add--end
         END IF
 
      AFTER FIELD ima925
         IF g_ima.ima925 NOT MATCHES '[123]' THEN
            NEXT FIELD ima925
         END IF

     #DEV-D30026---add---begin------------
      AFTER FIELD ima933
         IF NOT cl_null(g_ima.ima933) THEN
            SELECT COUNT(*) INTO l_n FROM geh_file,gei_file
             WHERE geh04 = 'H'
               AND geh01 = gei03
               AND gei01 = g_ima.ima933
            IF l_n = 0 OR cl_null(l_n) THEN
               CALL cl_err(g_ima.ima933,'aoo-112',0)
               NEXT FIELD ima933
            END IF
         END IF
     #DEV-D30026---add---end--------------
     #DEV-D40010 add str---------- 
      AFTER FIELD ima932              #控卡條碼時機點輸入
         IF NOT cl_null(g_ima.ima932) THEN
           #當收貨單作批序號控管，則條碼時機點不可挑選IQC(L),採購入庫(E)
            IF g_sma.sma90 = 'Y' AND (g_ima.ima932 = 'L' OR g_ima.ima932 = 'E') THEN
               CALL cl_err('','aim1166',1)   #此料件已設定收貨單作批序號控管，不可選擇E項、L項
               NEXT FIELD ima932
            END IF
         END IF
     #DEV-D40010 add end---------- 
#TQC-B90236--add--begin
      BEFORE FIELD ima928
         CALL i100_set_entry(p_cmd)

      AFTER FIELD ima928
         IF g_ima.ima928 = 'Y' THEN
            LET g_ima.ima929 = NULL
            DISPLAY BY NAME g_ima.ima929
         END IF
   
      ON CHANGE ima928
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd)
  
      AFTER FIELD ima929
         IF NOT cl_null(g_ima.ima929) THEN
#MOD-C30551 ------- add -------- begin
            IF g_ima.ima929 = g_ima.ima01 THEN
               CALL cl_err('','aim1154',0)
               LET g_ima.ima929 = g_ima_t.ima929
               NEXT FIELD ima929
            END IF
#MOD-C30551 ------- add -------- end
            CALL i100_ima929()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ima.ima929 = g_ima_t.ima929
               NEXT FIELD ima929
            END IF
#TQC-C20281 ----- add ----- begin
            IF g_sma.sma95 = "Y" THEN  #FUN-C80030 add
               SELECT ima918 INTO l_ima918 FROM ima_file
                WHERE ima01 = g_ima.ima929
               IF l_ima918 = 'Y' AND g_ima.ima918 <> 'Y' THEN
                  CALL cl_err('','aim1145',0)
                  LET g_ima.ima929 = g_ima_t.ima929
                  NEXT FIELD ima929
               END IF
            END IF                     #FUN-C80030 add
#TQC-C20281 ----- add ----- end
#        END IF                 #MOD-C30197  mark
#MOD-C30197 ----- add ----- begin
         ELSE
            IF NOT cl_null(g_ima_t.ima929) THEN
               IF cl_confirm('aim1152') THEN
                  DELETE FROM imac_file WHERE imac01 = g_ima.ima01
               END IF
            END IF
         END IF
#MOD-C30197 ----- add ----- end
#TQC-B90236--add-end
 
 
      AFTER FIELD imaicd01
         IF NOT i100_ind_icd_chk_item('imaicd01',g_imaicd.imaicd01) THEN
            LET g_imaicd.imaicd01=g_imaicd_o.imaicd01
            NEXT FIELD CURRENT
         ELSE
            CALL i100_ind_icd_set_default(g_imaicd.imaicd05,g_imaicd.imaicd01)
         END IF
         IF g_imaicd.imaicd04 = '1' OR g_imaicd.imaicd04 = '2' THEN  #FUN-C30278
            IF NOT cl_null(g_imaicd.imaicd01) THEN    #FUN-C30278
         #MOD-C30513---begin
               SELECT imaicd14 INTO g_imaicd.imaicd14 FROM imaicd_file WHERE imaicd00 = g_imaicd.imaicd01
               DISPLAY BY NAME g_imaicd.imaicd14
         #MOD-C30513---end
            END IF    #FUN-C30278
         END IF   #FUN-C30278
    #FUN-B50106 ------------------Begin--------------------
         #IF g_imaicd.imaicd04 MATCHES'[1234]' THEN       #CHI-B70014 mark
         #   CALL cl_set_comp_required("imaicd01",TRUE)   #CHI-B70014 mark
         #ELSE                                            #CHI-B70014 mark
         #   CALL cl_set_comp_required("imaicd01",FALSE)  #CHI-B70014 mark 
         #END IF                                          #CHI-B70014 mark
    #FUN-B50106 ------------------End----------------------
#FUN-B30192--mark 
#      AFTER FIELD imaicd02
#         IF NOT i100_ind_icd_chk_item('imaicd02',g_imaicd.imaicd02) THEN
#            LET g_imaicd.imaicd02=g_imaicd_o.imaicd02
#            NEXT FIELD CURRENT
#         END IF
# 
#      AFTER FIELD imaicd03
#         IF NOT i100_ind_icd_chk_item('imaicd03',g_imaicd.imaicd03) THEN
#            LET g_imaicd.imaicd03=g_imaicd_o.imaicd03
#            NEXT FIELD CURRENT
#         END IF
#FUN-B30192--mark      
      BEFORE FIELD imaicd04           #No.FUN-920170
         CALL i100_set_entry(p_cmd)   #No.FUN-920170
         
      ON CHANGE imaicd04     
         CALL i100_ind_icd_chg_imaicd04(g_imaicd.imaicd04)  #FUN-C30278
         CALL i100_set_entry(p_cmd)       #No.FUN-920170
         CALL i100_set_no_entry(p_cmd)   #No.FUN-920170 	
    #FUN-B50106 ------------------Begin--------------------
         #IF g_imaicd.imaicd04 MATCHES'[1234]' THEN       #CHI-B70014 mark
         #   CALL cl_set_comp_required("imaicd01",TRUE)   #CHI-B70014 mark
         #ELSE                                            #CHI-B70014 mark
         #   CALL cl_set_comp_required("imaicd01",FALSE)  #CHI-B70014 mark 
         #END IF                                          #CHI-B70014 mark
    #FUN-B50106 ------------------End----------------------
#FUN-B30192--begin      
#      AFTER FIELD imaicd06
#         IF NOT i100_ind_icd_chk_item('imaicd06',g_imaicd.imaicd06) THEN
#            LET g_imaicd.imaicd06=g_imaicd_o.imaicd06
#            NEXT FIELD CURRENT
#         END IF
      AFTER FIELD imaicd04
         #FUN-C30278---begin
         IF g_imaicd.imaicd04 = '1' OR g_imaicd.imaicd04 = '2' THEN  
            IF NOT cl_null(g_imaicd.imaicd01) THEN 
               SELECT imaicd14 INTO g_imaicd.imaicd14 FROM imaicd_file WHERE imaicd00 = g_imaicd.imaicd01
               DISPLAY BY NAME g_imaicd.imaicd14
            END IF 
         END IF   
         #TQC-C40078--add--str--
         CALL i100_ind_icd_chg_imaicd04(g_imaicd.imaicd04)  #FUN-C30278
         CALL i100_set_no_entry(p_cmd)   #No.FUN-920170 	
         #TQC-C40078--add--end--
    #FUN-B50106 ------------------Begin--------------------
         #FUN-C30278---end
         #FUN-C30278---begin mark
         #FUN-C30206---begin
         #  IF g_imaicd.imaicd05 <> '1' THEN 
         #     IF g_imaicd.imaicd04 <> '0' AND g_imaicd.imaicd04 <> '1' THEN
         #        LET g_imaicd.imaicd01 = NULL 
         #        DISPLAY BY NAME g_imaicd.imaicd01
         #     END IF 
         #  END IF 
         #FUN-C30206---end
         #FUN-C30278---end
#FUN-B50106 -------------Begin----------------------
         #IF g_imaicd.imaicd04 MATCHES'[1234]' THEN       #CHI-B70014 mark 
         #   CALL cl_set_comp_required("imaicd01",TRUE)   #CHI-B70014 mark
         #ELSE                                            #CHI-B70014 mark
         #   CALL cl_set_comp_required("imaicd01",FALSE)  #CHI-B70014 mark
         #END IF                                          #CHI-B70014 mark 
#        IF g_imaicd.imaicd04 = '1' THEN
#           LET g_imaicd.imaicd16 =g_imaicd.imaicd01
#        END IF

      BEFORE FIELD imaicd05           #TQC-C40078 add
         CALL i100_set_entry(p_cmd)   #TQC-C40078 add

      ON CHANGE imaicd05
         IF g_imaicd.imaicd05<>g_imaicd_o.imaicd05 OR g_imaicd_o.imaicd05 IS NULL THEN
            #CALL i100_ind_icd_chg_imaicd05(g_imaicd.imaicd05) #FUN-C30278 mark
            CALL i100_ind_icd_set_default(g_imaicd.imaicd05,g_imaicd.imaicd01)
         END IF
         CALL i100_set_entry(p_cmd)     #TQC-C40078 add   
         CALL i100_set_no_entry(p_cmd)  #TQC-C40078 add 	
         
      #CHI-BA0046 --START--
      AFTER FIELD imaicd05
         #FUN-C30278---begin
         IF g_imaicd.imaicd05 = '6' THEN
            IF cl_null(g_imaicd.imaicd04) THEN 
               LET g_imaicd.imaicd04 = '9'
               DISPLAY BY NAME g_imaicd.imaicd04
            END IF 
         END IF
         #FUN-C30278---end
         #FUN-C30278---begin mark
         #MOD-C30235---begin
         #IF g_imaicd.imaicd05='1' AND cl_null(g_imaicd.imaicd01) THEN
         #   CALL i100_ind_icd_chg_imaicd05(g_imaicd.imaicd05)
         CALL i100_ind_icd_set_default(g_imaicd.imaicd05,g_imaicd.imaicd01)
         #END IF
         #MOD-C30235---end
         #FUN-C30278---end
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd)   
      #CHI-BA0046 --END--
      
      AFTER FIELD imaicd16
         IF NOT cl_null(g_imaicd.imaicd16) THEN
            LET l_n = 0 
            SELECT COUNT(*) INTO l_n FROM imaicd_file
            #WHERE imaicd01 = g_imaicd.imaicd16            #FUN-B70051
             WHERE imaicd00 = g_imaicd.imaicd16            #FUN-B70051
               AND imaicd04 = '1'
            IF l_n < 1 THEN
               CALL cl_err('','aim-029',0)   
               NEXT FIELD imaicd16
            END IF
         END IF
#FUN-B50106 -------------End------------------------
      AFTER FIELD imaicd15
            IF  g_imaicd.imaicd15 < 0 THEN
              CALL cl_err('','aec-020',0)
              NEXT FIELD imaicd15
            END IF
#FUN-B30192--end
      BEFORE FIELD imaicd08 
        CALL i100_set_entry(p_cmd)
        CALL i100_set_no_entry(p_cmd)

      #FUN-BC0103 --START--
      ON CHANGE imaicd17
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd) 
      #FUN-BC0103 --END--
      
      AFTER FIELD imaicd10
         IF NOT i100_ind_icd_chk_imaicd10(g_imaicd.imaicd10) THEN
            LET g_imaicd.imaicd10=g_imaicd_o.imaicd10
            NEXT FIELD CURRENT
         END IF

 
     #FUN-A80150---add---start---
      BEFORE FIELD ima156
         CALL i100_set_entry(p_cmd)

      ON CHANGE ima156
         CALL i100_set_no_entry(p_cmd)

      AFTER FIELD ima157
         IF NOT cl_null(g_ima.ima157) THEN
            SELECT COUNT(*) INTO l_n FROM geh_file,gei_file   
             WHERE geh04 = '5'  
               AND geh01 = gei03 
               AND gei01 = g_ima.ima157  
            IF l_n = 0 THEN
               CALL cl_err(g_ima.ima157,'aoo-112',0)
               NEXT FIELD ima157
            END IF
         END IF
     #FUN-A80150---add---end---
#DEV-D30026---add--begin----------
        ON CHANGE ima930 #DEV-D30026 add ima934
           IF g_ima.ima930 = 'Y' THEN
              CALL cl_set_comp_entry("ima931,ima932",TRUE)
              CALL cl_set_comp_entry("ima934",g_aza.aza132='Y')
              IF g_ima.ima931 = 'Y' THEN
                 CALL cl_set_comp_entry("ima933",TRUE)
                 CALL cl_set_comp_required("ima933",TRUE)
              END IF
              IF cl_null(g_ima.ima931) THEN
                 LET g_ima.ima931 = 'N'
                 DISPLAY BY NAME g_ima.ima931
              END IF
           ELSE
              CALL cl_set_comp_required("ima933",FALSE)
              CALL cl_set_comp_entry("ima931,ima933,ima932",FALSE)
              CALL cl_set_comp_entry("ima934",FALSE)
              LET g_ima.ima931 = NULL
              LET g_ima.ima932 = NULL
              LET g_ima.ima933 = NULL
              LET g_ima.ima934 = 'Y'
             #DEV-D30026 add str-------------
              LET g_ima.ima918 = 'N'
              LET g_ima.ima919 = 'N'
              LET g_ima.ima920 = ''
              LET g_ima.ima921 = 'N'
              LET g_ima.ima922 = 'N'
              LET g_ima.ima923 = ''
              LET g_ima.ima924 = 'N'
              DISPLAY BY NAME g_ima.ima918,g_ima.ima919,g_ima.ima920
              DISPLAY BY NAME g_ima.ima921,g_ima.ima922,g_ima.ima923,g_ima.ima924
             #DEV-D30026 add end-------------
              DISPLAY BY NAME g_ima.ima931,g_ima.ima932,g_ima.ima933
                             ,g_ima.ima934
           END IF

        ON CHANGE ima931
           IF g_ima.ima931 = 'Y' THEN
              CALL cl_set_comp_entry("ima933",TRUE)
              CALL cl_set_comp_required("ima933",TRUE)
           ELSE
              CALL cl_set_comp_required("ima933",FALSE)
              CALL cl_set_comp_entry("ima933",FALSE)
              LET g_ima.ima933 = NULL
              DISPLAY BY NAME g_ima.ima933
           END IF
           #DEV-D30026 ---add---str--
           CALL i100_set_entry(p_cmd)
           CALL i100_set_no_entry(p_cmd)
           #DEV-D30026 ---add---end--

        #DEV-D30026 ---add---str--
        ON CHANGE ima932
           CALL i100_set_entry(p_cmd)
           CALL i100_set_no_entry(p_cmd)

        ON CHANGE ima934
           CALL i100_set_entry(p_cmd)
           CALL i100_set_no_entry(p_cmd)
        #DEV-D30026 ---add---end--
#DEV-D30026---add--end------------

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
               WHEN "ima929" NEXT FIELD ima929    #MOD-C30551 add
            END CASE
           IF g_ima.ima902 IS NULL AND  g_ima.ima9021 IS NOT NULL THEN
              LET g_ima.ima902 = g_ima.ima9021 
           END IF
           DISPLAY BY NAME g_ima.ima902,g_ima.ima9021
#No.FUN-A50011  -----begin----
#No.FUN-A50011 -----end----- 
        ON ACTION item_group_common_inventory
           CALL cl_cmdrun("aimi110 ")

#NO.FUN-B30092  ------------------------add start------------------------
        ON ACTION quantifying
           CALL cl_cmdrun("aooi104 ")
#NO.FUN-B30092 --------------------------add end------------------------
 
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
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ima1"
                  LET g_qryparam.default1 = g_ima.ima13
                  LET g_qryparam.arg1     = "C"
                #  LET g_qryparam.where    = " ima08 IN ",cl_parse(g_qryparam.arg1)       #FUN-AB0025
                  LET g_qryparam.where = " ima08 IN ,cl_parse(g_qryparam.arg1) AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"   #FUN-AB0025
                  CALL cl_create_qry() RETURNING g_ima.ima13
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
                 #LET g_qryparam.form     = "q_gfe" #NO.FUN-B30092 mark
                  LET g_qryparam.form     = "q_gfo" #NO.FUN-B30092
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
               #FUN-C80094---ADD--STR
               WHEN INFIELD(ima163)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"
                  LET g_qryparam.default1 = g_ima.ima163
                  LET g_qryparam.arg1     = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_ima.ima163
                  DISPLAY BY NAME g_ima.ima163
                  NEXT FIELD ima163
               WHEN INFIELD(ima1631)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"
                  LET g_qryparam.default1 = g_ima.ima1631
                  LET g_qryparam.arg1     = g_aza.aza82
                  CALL cl_create_qry() RETURNING g_ima.ima1631
                  DISPLAY BY NAME g_ima.ima1631
                  NEXT FIELD ima1631
               #FUN-C80094--ADD--END

               #FUN-D60083--add--str--
                WHEN INFIELD(ima164)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"
                  LET g_qryparam.default1 = g_ima.ima164
                  LET g_qryparam.arg1     = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_ima.ima164
                  DISPLAY BY NAME g_ima.ima164
                  NEXT FIELD ima164
               WHEN INFIELD(ima1641)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag02"
                  LET g_qryparam.default1 = g_ima.ima1641
                  LET g_qryparam.arg1     = g_aza.aza82
                  CALL cl_create_qry() RETURNING g_ima.ima1641
                  DISPLAY BY NAME g_ima.ima1641
                  NEXT FIELD ima1641
                #FUN-D60083--add--end--

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
               IF g_ima.ima930 = 'Y' THEN                                      #DEV-D30026--add
                  LET g_qryparam.where = " geh_file.geh04 IN('5','F','G')"     #DEV-D30026--add
                                        ," AND geh_file.geh03 = 'iba_file'"    #DEV-D30036--add
               ELSE                                                            #DEV-D30026--add
                  LET g_qryparam.where = " geh_file.geh04='5'"   #No.MOD-840254
                                        ," AND geh_file.geh03 <> 'iba_file'"   #DEV-D30036--add
               END IF                                                          #DEV-D30026--add
               CALL cl_create_qry() RETURNING g_ima.ima920
               DISPLAY g_ima.ima920 TO ima920
        #DEV-D30026--add--begin-------------
             WHEN INFIELD(ima933)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gei2"
               LET g_qryparam.default1 = g_ima.ima933
               LET g_qryparam.where = " geh04='H'"
               CALL cl_create_qry() RETURNING g_ima.ima933
               DISPLAY g_ima.ima933 TO ima933
        #DEV-D30026---add---end---------------
            WHEN INFIELD(ima923)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gei2"   #No.MOD-840254  #No.MOD-840294
               LET g_qryparam.default1 = g_ima.ima923
               LET g_qryparam.where = " geh04='6'"   #No.MOD-840254
               #DEV-D30036--add--begin
               IF g_ima.ima930 = 'Y' THEN
                  LET g_qryparam.where =  g_qryparam.where ," AND geh_file.geh03 = 'iba_file'"
               ELSE
                  LET g_qryparam.where =  g_qryparam.where ," AND geh_file.geh03 = 'rvbs_file'"
               END IF
               #DEV-D30036--add--end
               CALL cl_create_qry() RETURNING g_ima.ima923
               DISPLAY g_ima.ima923 TO ima923
#TQC-B90236--add--begin
            WHEN INFIELD(ima929)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima01_8"
               LET g_qryparam.default1 = g_ima.ima929
               LET g_qryparam.where = " imaacti = 'Y' AND ima01 <> '",g_ima.ima01,"'"  #MOD-C30551 add ima01
               CALL cl_create_qry() RETURNING g_ima.ima929
               DISPLAY g_ima.ima929 TO ima929
#TQC-B90236--add--end
 
             WHEN INFIELD(imaicd01) #母體料號
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_imaicd"
                #LET g_qryparam.where    = " imaicd05='1'"   #FUN-BC0107 mark
                LET g_qryparam.where    = " imaicd04='0' OR imaicd04='1'"   #FUN-BC0107                
                LET g_qryparam.default1 = g_imaicd.imaicd01
                CALL cl_create_qry() RETURNING g_imaicd.imaicd01
                DISPLAY BY NAME g_imaicd.imaicd01
                NEXT FIELD imaicd01
#FUN-B30192--begin
#             WHEN INFIELD(imaicd02) #外編母體 (預測料號)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_imaicd"
#                LET g_qryparam.where    = " imaicd05='2'"
#                LET g_qryparam.default1 = g_imaicd.imaicd02
#                CALL cl_create_qry() RETURNING g_imaicd.imaicd02
#                DISPLAY BY NAME g_imaicd.imaicd02
#                NEXT FIELD imaicd02
#             WHEN INFIELD(imaicd03) #外編子體 (客戶下單料號)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_imaicd"
#                LET g_qryparam.where    = " imaicd05='4'"
#                LET g_qryparam.default1 = g_imaicd.imaicd03
#                CALL cl_create_qry() RETURNING g_imaicd.imaicd03
#                DISPLAY BY NAME g_imaicd.imaicd03
#                NEXT FIELD imaicd03
#             WHEN INFIELD(imaicd06) #內編子體 (Wafer料號)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_imaicd"
#                LET g_qryparam.where    = " imaicd04='1'"
#                LET g_qryparam.default1 = g_imaicd.imaicd06
#                CALL cl_create_qry() RETURNING g_imaicd.imaicd06
#                DISPLAY BY NAME g_imaicd.imaicd06
#                NEXT FIELD imaicd06
              WHEN INFIELD(imaicd16) #外編子體 (客戶下單料號)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_imaicd"
               #LET g_qryparam.where    = " imaicd04='4'"   #FUN-B70051
                LET g_qryparam.where    = " imaicd04='1'"   #FUN-B70051
                LET g_qryparam.default1 = g_imaicd.imaicd16
                CALL cl_create_qry() RETURNING g_imaicd.imaicd16
                DISPLAY BY NAME g_imaicd.imaicd16
#FUN-B30192--end
             WHEN INFIELD(imaicd10) #作業群組
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_icd11"  #add by hellen
                LET g_qryparam.arg1 = 'U'        #add by hellen
                LET g_qryparam.default1 = g_imaicd.imaicd10
                CALL cl_create_qry() RETURNING g_imaicd.imaicd10
                DISPLAY BY NAME g_imaicd.imaicd10
                NEXT FIELD imaicd10
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
            #FUN-A80150---add---start---
             WHEN INFIELD(ima157)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gei2"  
                LET g_qryparam.default1 = g_ima.ima157
                LET g_qryparam.where = " geh04='5'"  
                CALL cl_create_qry() RETURNING g_ima.ima157
                DISPLAY g_ima.ima157 TO ima157
            #FUN-A80150---add---end---
#No.FUN-A50011 -----begin-----                    
#No.FUN-A50011  -----end-----
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
#No.FUN-A50011 ----begin-----
#No.FUN-A50011 ----end-----

#TQC-B90236--add--begin-----離開單頭時進行判斷
#MOD-C30147 ----- add ----- begin
   IF INT_FLAG THEN 
      ROLLBACK WORK 
      RETURN
   ELSE
      COMMIT WORK
   END IF
#MOD-C30147 ----- add ----- end
   IF g_ima_t.ima928 = 'Y' AND g_ima.ima928 = 'N' THEN
      DELETE FROM imac_file WHERE imac01 = g_ima.ima01
   END IF
  
   IF g_ima.ima929 != g_ima_t.ima929 #OR                              #MOD-C30308 mark
#     (cl_null(g_ima.ima929) AND NOT cl_null(g_ima_t.ima929))         #MOD-C30308 mark   
      OR (cl_null(g_ima_t.ima929) AND NOT cl_null(g_ima.ima929)) THEN
      DELETE FROM imac_file WHERE imac01 = g_ima.ima01
      LET g_sql = "SELECT * FROM imac_file WHERE imac01 ='",g_ima.ima929,"'"
      PREPARE i100_c_pre FROM g_sql
      DECLARE i100_c_cs CURSOR FOR i100_c_pre

      FOREACH i100_c_cs INTO l_imac.*
         LET l_imac.imacuser = g_user
         LET l_imac.imacgrup = g_grup
         LET l_imac.imacoriu = g_user
         LET l_imac.imacorig = g_grup
         LET l_imac.imacmodu = NULL
         LET l_imac.imacdate = NULL
         LET l_imac.imac01   = g_ima.ima01
         LET l_imac.imac05   = ""
         INSERT INTO imac_file VALUES(l_imac.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","imac_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            RETURN
         END IF
      END FOREACH
      SELECT COUNT(*) INTO l_n FROM inj_file WHERE inj01 = g_ima.ima01
      IF l_n = 0 THEN  #不存在料件的特性資料檔時 才可進行特性維護
         CALL i100_feature_maintain()
      END IF
   END IF   
#TQC-B90236--add--end
END FUNCTION
 
#FUN-A20037 --BEGIN--
FUNCTION i100_ima251_chk()
 #FUN-B30092 --BEGIN--
 #DEFINE l_gfe01    LIKE gfe_file.gfe01
 #DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 DEFINE l_gfo01    LIKE gfo_file.gfo01
 DEFINE l_gfoacti  LIKE gfo_file.gfoacti

  LET g_errno= ""
 #SELECT gfe01,gfeacti INTO l_gfe01,l_gfeacti FROM gfe_file
 # WHERE gfe01 = g_ima.ima251 
  SELECT gfo01,gfoacti INTO l_gfo01,l_gfoacti FROM gfo_file
   WHERE gfo01 = g_ima.ima251
 
   CASE 
    WHEN SQLCA.SQLCODE =100  LET g_errno = 'mfg0019'
   #WHEN l_gfeacti ='N'      LET g_errno = 'aec-090' 
   #                         LET l_gfe01 = NULL
   #                         LET l_gfeacti = NULL
    WHEN l_gfoacti ='N'      LET g_errno = 'aec-090'
                             LET l_gfo01 = NULL
                             LET l_gfoacti = NULL
    OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 #FUN-B30092 --END
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
        LET g_ima01_t1 = NULL  #TQC-C70189 add
        CALL cl_set_comp_visible("imaag",FALSE)                       #FUN-810016
        INITIALIZE g_imaicd.* TO NULL
        INITIALIZE g_imaicd_t.* TO NULL
        INITIALIZE g_imaicd_o.* TO NULL
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
        INITIALIZE g_imaicd.* TO NULL
    ELSE
        CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
       #CALL i100_list_fill()   #No.FUN-7C0010    #FUN-C90107 mark
        CALL i100sub_list_fill()   #No.FUN-7C0010    #FUN-C90107 add
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
        INITIALIZE g_imaicd.* TO NULL
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
        SELECT * INTO g_imaicd.* FROM imaicd_file            # 重讀DB,因TEMP有不被更新特性
           WHERE imaicd00 = g_ima.ima01
        LET g_data_owner = g_ima.imauser      #FUN-4C0053
        LET g_data_group = g_ima.imagrup      #FUN-4C0053
        CALL i100_show()                      # 重新顯示
    END IF
END FUNCTION

#FUN-C90107 mark str----------------- 
#FUNCTION i100_list_fill()
#  DEFINE l_ima01         LIKE ima_file.ima01
#  DEFINE l_i             LIKE type_file.num10
# 
#    CALL g_ima_l.clear()
#    LET l_i = 1
#    FOREACH aimi100_list_cur INTO l_ima01
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
#          CONTINUE FOREACH
#       END IF
#       SELECT ima01,ima02,ima021,ima06,ima08,ima130,ima109,
#              ima25,ima37,ima1010,imaacti,ima916
#         INTO g_ima_l[l_i].*
#         FROM ima_file
#        WHERE ima01=l_ima01
#       LET l_i = l_i + 1
#       IF l_i > g_max_rec THEN
#          IF g_action_choice ="query"  THEN   #CHI-BB0034 add
#            CALL cl_err( '', 9035, 0 )
#          END IF                              #CHI-BB0034 add
#          EXIT FOREACH
#       END IF
#    END FOREACH
#    LET g_rec_b1 = l_i - 1
#    DISPLAY ARRAY g_ima_l TO s_ima_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
#       BEFORE DISPLAY
#          EXIT DISPLAY
#    END DISPLAY
# 
#END FUNCTION
 
FUNCTION i100_show()
   DEFINE l_avl_stk_mpsmrp  LIKE type_file.num15_3,     #No.FUN-A20044
          l_unavl_stk       LIKE type_file.num15_3,     #No.FUN-A20044
          l_avl_stk         LIKE type_file.num15_3,      #No.FUN-A20044
          l_agd031          LIKE agd_file.agd03,
          l_agd032          LIKE agd_file.agd03
 
   SELECT ima93 INTO g_ima.ima93 FROM ima_file
    WHERE ima01=g_ima.ima01
   LET g_ima_t.* = g_ima.*
   LET g_ima01_t1 = g_ima.ima01  #TQC-C70189 add
   LET g_imaicd_t.* = g_imaicd.*
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
                   g_ima.ima39  ,g_ima.ima391 ,g_ima.ima163,g_ima.ima1631,
                   g_ima.ima164 ,g_ima.ima1641,              #FUN-D60083 add
                   g_ima.ima149,g_ima.ima1491,g_ima.ima13  , #FUN-960141 #FUN-C80094 add-ima163,ima1631
                   g_ima.ima04  ,g_ima.ima14  ,g_ima.ima903 ,
                   g_ima.ima905 ,g_ima.ima24  ,g_ima.ima911 ,                   
                   g_ima.ima70  ,g_ima.ima107 ,g_ima.ima147 ,
                   g_ima.ima15  ,g_ima.ima910 ,g_ima.ima105 ,
                   g_ima.ima07  ,g_ima.ima16  ,g_ima.ima109 ,
#                  g_ima.ima902 ,g_ima.ima37  ,g_ima.ima51  ,               #No.FUN-8C0131 
                   g_ima.ima902 ,g_ima.ima9021,g_ima.ima37  ,g_ima.ima51  , #No.FUN-8C0131
                   g_ima.ima52  ,g_ima.ima140 ,g_ima.ima09  ,
                   g_ima.ima10  ,g_ima.ima11  ,g_ima.ima12  ,
                   g_ima.ima022,g_ima.ima251,      #FUN-A20037 #FUN-B80186
                   g_ima.ima25  ,g_ima.ima35  ,g_ima.ima36  ,
                   g_ima.ima23  ,
                   g_ima.ima918 ,g_ima.ima919 ,g_ima.ima920 ,  #No.FUN-810036
                   g_ima.ima921 ,g_ima.ima922 ,g_ima.ima923 ,  #No.FUN-810036
                   g_ima.ima924 ,g_ima.ima931,g_ima.ima933,g_ima.ima925 ,  #No.FUN-810036 #DEV-D30026--ima931,ima933
                   g_ima.ima27  ,g_ima.ima28  ,
                   g_ima.ima271 ,g_ima.ima71  ,g_ima.ima901 ,
                   g_ima.ima881 ,g_ima.ima73  ,g_ima.ima74  ,
                   g_ima.ima29  ,g_ima.ima30  ,g_ima.ima93  ,
                   g_ima.ima930,g_ima.ima932,  #DEV-D30026--ima930,ima932
                   g_ima.ima934 , #No:DEV-D30026--add
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
                  #g_ima.ima1013,g_ima.ima1015,g_ima.ima1014,  #CHI-CA0073  mark 
                   g_ima.ima1013,g_ima.ima1014,  #CHI-CA0073  add
                   g_ima.ima1016,g_ima.ima916                 #No.FUN-7C0010
                   ,g_ima.ima151,                              #No.FUN-810016
                   g_ima.ima156,g_ima.ima157,g_ima.ima158,     #FUN-A80150 add
                   g_ima.ima159       #FUN-B50096
                   ,g_ima.ima928,g_ima.ima929   #TQC-B90236--add
 
   DISPLAY BY NAME g_imaicd.imaicd01,
                #  g_imaicd.imaicd02,
                #  g_imaicd.imaicd03,
                   g_imaicd.imaicd04,
                   g_imaicd.imaicd05,
                   g_imaicd.imaicd16,  #FUN-B30192
                #  g_imaicd.imaicd06,
                   g_imaicd.imaicd08,
                   g_imaicd.imaicd17,  #FUN-BC0103
                   g_imaicd.imaicd18,  #FUN-BC0103
                   g_imaicd.imaicd19,  #FUN-BC0103
                   g_imaicd.imaicd20,  #FUN-BC0103
                   g_imaicd.imaicd21,  #FUN-BC0103
                #  g_imaicd.imaicd13,  #FUN-A40022  #FUN-B50096
                   g_imaicd.imaicd09,
                   g_imaicd.imaicd10,
                   g_imaicd.imaicd11,
                   g_imaicd.imaicd12,
                   g_imaicd.imaicd14,   #FUN-B30192
                   g_imaicd.imaicd15    #FUN-B30192
#No.FUN-A50011 -----begin-----
#No.FUN-A50011 -----end-----

   #CHI-B50017 --- modify --- start ---
    LET g_buf_2 = NULL
    SELECT imz02 INTO g_buf_2 FROM imz_file WHERE imz01=g_ima.ima06
    DISPLAY g_buf_2 TO imz02
   #CHI-B50017 --- modify ---  end  --


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
    DEFINE l_ima      RECORD LIKE ima_file.*          #FUN-B80032 
    DEFINE l_ima_t    RECORD LIKE ima_file.*          #TQC-C40219
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
    SELECT * INTO g_imaicd.* FROM imaicd_file
     WHERE imaicd00=g_ima.ima01
    IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_ima.ima01,'mfg1000',0)
       RETURN
    END IF
#FUN-B90101--add--begin--
#FUN-B90101--add--end--
    #TQC-AB0142 -----------------begin---------------
    IF cl_null(g_ima.ima1006) THEN
       LET g_ima.ima1006 = '001'
    END IF
    #TQC-AB0142 ------------------end----------------
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ima01_t = g_ima.ima01
    LET g_ima_o.* = g_ima.*
    LET g_imaicd_o.* = g_imaicd.*
    LET l_ima_t.* = g_ima.*            #TQC-C40219
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

#MOD-C30270--mark--begin--
#&ifdef SLK
#  #TQC-C30186--add--begin--
#   IF g_ima.ima151 = 'N' AND g_ima.imaag = '@CHILD' THEN
#      CALL i100_i_ima08("u")  
#   ELSE
#      CALL i100_i("u")  
#   END IF
#  #TQC-C30186--add--end--
#&else
#      CALL i100_i("u")                      # 欄位更改
#&endif
#MOD-C30270--mark--end--
       CALL i100_i("u")                      # 欄位更改   #MOD-C30270 add
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_ima.* = l_ima_t.*          #TQC-C40219
          #LET g_ima.*=g_ima_t.*     #TQC-C40155 
          #LET g_ima.*=g_ima_o.*     #TQC-C40155  #TQC-C40219
           LET g_imaicd.*=g_imaicd_t.*     #TQC-C40155  #TQC-C40219
          #LET g_imaicd.*=g_imaicd_o.*     #TQC-C40155  #TQC-C40219  
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
           OR l_ima.ima154 <> g_ima.ima154 OR l_ima.ima1004 <> g_ima.ima1004 
           OR l_ima.ima1006 <> g_ima.ima1006 THEN
           IF g_aza.aza88 = 'Y' THEN
              UPDATE rte_file SET rtepos = '2' WHERE rte03 = g_ima.ima01 AND rtepos = '3'
           END IF
        END IF 
      #FUN-B80032---------END-------       
      #TQC-C70189--add--str--
       IF cl_null(g_ima.ima571) OR g_ima01_t1 = g_ima.ima571 THEN 
          LET g_ima.ima571 = g_ima.ima01
       END IF        
      #TQC-C70189--add--str--
       IF NOT i100_u_upd() THEN
          ROLLBACK WORK       #FUN-680010
          CONTINUE WHILE
       ELSE
         #CALL i100_list_fill()     #No.FUN-7C0010    #FUN-C90107 mark
          CALL i100sub_list_fill()  #No.FUN-7C0010    #FUN-C90107 add
          COMMIT WORK
       END IF
       EXIT WHILE
    END WHILE
    CLOSE i100_cl
END FUNCTION
 
#FUN-6C0006 從_r()中抽出,成功刪除後的後續處理
FUNCTION i100_AFTER_DEL()
   OPEN aimi100_count
   FETCH aimi100_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN aimi100_curs
   #MOD-C30105--mark--str--
   #   IF g_curs_index = g_row_count + 1 THEN   
   #      LET g_jump = g_row_count
   #      CALL i100_fetch('L')  
   #   ELSE
   #      LET g_jump = g_curs_index
   #      LET mi_no_ask = TRUE     #No.FUN-6A0061
   #      CALL i100_fetch('/')
   #   END IF
   #MOD-C30105--mark--end--
   #MOD-C30105--add--str--
   #IF g_curs_index > 1 THEN   #TQC-C40044 mark
   IF g_row_count >= 1 THEN    #TQC-C40044 add   
      IF g_curs_index = g_row_count + 1 THEN   
         LET g_jump = g_row_count
      ELSE
         LET g_jump = g_curs_index
      END IF
      LET mi_no_ask = TRUE     
      CALL i100_fetch('/')
   ELSE 
      INITIALIZE g_ima.* TO NULL #TQC-C40231 add 
   END IF                 
   #MOD-C30105--add--end--
END FUNCTION
 
FUNCTION i100_copy()
   DEFINE l_flag LIKE type_file.num5
   DEFINE l_ima   RECORD LIKE ima_file.*
   DEFINE l_newno,l_oldno LIKE ima_file.ima01
   DEFINE l_ima02         LIKE ima_file.ima02    #MOD-B40111 add
 
   CALL i100_copy_input() RETURNING l_flag,l_newno,l_ima02    #MOD-B40111 add l_ima02
   IF l_flag THEN
      CALL i100_copy_default(l_newno,l_ima02) RETURNING l_ima.*    #MOD-B40111 add l_ima02
      LET l_ima.ima1001 = NULL    #No.FUN-640010
      LET l_ima.ima1002 = NULL    #No.FUN-640010
      LET l_ima.ima120 = '1'      #No.FUN-A90049      
      IF i100_copy_insert(l_ima.*,l_newno) THEN
         LET l_oldno = g_ima.ima01
         SELECT ima_file.* INTO g_ima.* FROM ima_file
                        WHERE ima01 = l_newno
         SELECT * INTO g_imaicd.*
           FROM imaicd_file
          WHERE imaicd00 = l_newno
         CALL i100_u()
         CALL i100_copy_finish(l_newno,l_oldno)
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_init() #初始環境設定
 
   INITIALIZE g_ima.* TO NULL
   INITIALIZE g_ima_t.* TO NULL
   INITIALIZE g_ima_o.* TO NULL
   LET g_ima01_t1 = NULL  #TQC-C70189 add
   INITIALIZE g_imaicd.* TO NULL
   INITIALIZE g_imaicd_t.* TO NULL
   INITIALIZE g_imaicd_o.* TO NULL
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
   
   #FUN-A80150---add---start---
    IF g_sma.sma1421 = 'Y' THEN
       CALL cl_set_comp_visible("machine_management",TRUE)
    ELSE
       CALL cl_set_comp_visible("machine_management",FALSE)
    END IF
   #FUN-A80150---add---end---
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
   #LET g_ima.ima12 =' ' #CHI-CA0056
   LET g_ima.ima12 =''  #CHI-CA0056 
   LET g_ima.ima23 = ' '
   LET g_ima.ima918= 'N'
   LET g_ima.ima919= 'N'
   LET g_ima.ima921= 'N'
   LET g_ima.ima922= 'N'
   LET g_ima.ima924= 'N'
   LET g_ima.ima925= '1'   #MOD-C30088
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
   LET g_ima.ima721 = 0  #CHI-C50068
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
   LET g_ima.ima912 = 'N' #TQC-AB0041
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
   LET g_imaicd.imaicd04='9'
   #LET g_imaicd.imaicd05='6'  #FUN-C30278
   LET g_imaicd.imaicd05='5'   #FUN-C30278
   LET g_imaicd.imaicd08='N'
   LET g_imaicd.imaicd09='N'
#  LET g_imaicd.imaicd13='N' #FUN-A40022 #FUN-B50096
   LET g_imaicd.imaicd14='0' #FUN-B30192
   LET g_imaicd.imaicd17='3' #FUN-BC0103
   LET g_imaicd.imaicd18=''  #FUN-BC0103  
   LET g_imaicd.imaicd19=''  #FUN-BC0103
   LET g_imaicd.imaicd20=''  #FUN-BC0103
   LET g_imaicd.imaicd21=''  #FUN-BC0103   
   LET g_ima.ima159 = '3'    #FUN-B90035
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
   LET g_ima.ima156='N'      #FUN-A80150 add
   LET g_ima.ima157=' '      #FUN-A80150 add
   LET g_ima.ima158='N'      #FUN-A80150 add
   LET g_ima.ima159= '3'     #MOD-C30088
   LET g_ima.ima930 = 'N'    #DEV-D30026 add  #使用條碼否
   LET g_ima.ima931 = 'N'    #DEV-D30026 add
   LET g_ima.ima934 = 'Y'    #No:DEV-D30026--add
END FUNCTION
 
 
FUNCTION i100_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_cnt     LIKE type_file.num5    #FUN-C90075
   
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN        #No.FUN-550021
      CALL cl_set_comp_entry("ima01,ima25,ima910,ima55",TRUE) #FUN-550014 add ima910  BUG-530699 #MOD-560085 add ima55
      CALL cl_set_comp_entry('ima9021',TRUE)                  #FUN-8C0131
      CALL cl_set_comp_visible("imaag",g_sma.sma120 = 'Y' )   #No.FUN-550021
      CALL cl_set_comp_entry("ima02,ima021",TRUE)             #FUN-690060
      IF NOT cl_null(g_aza.aza131) AND g_aza.aza131 = 'Y' THEN #是否與M-Barcode整合 #DEV-D30026 add if 判斷
          #DEV-D30026--add---begin---------------
          IF g_ima.ima930 = 'Y' THEN
             CALL cl_set_comp_entry("ima931,ima932,ima933",TRUE)
             CALL cl_set_comp_entry("ima934",g_aza.aza132='Y') #No:DEV-D30026--add
             IF NOT cl_null(g_ima.ima931) AND g_ima.ima931 = 'Y' THEN #包號管理否
                CALL cl_set_comp_required("ima933",TRUE)
             ELSE
                CALL cl_set_comp_required("ima933",FALSE)
                CALL cl_set_comp_entry("ima933",FALSE)
             END IF
          ELSE
             CALL cl_set_comp_required("ima933",FALSE)
             CALL cl_set_comp_entry("ima931,ima932,ima933",FALSE)
             CALL cl_set_comp_entry("ima934",FALSE) #No:DEV-D30026--add
          END IF
          #DEV-D30026--add---end-----------------
      ELSE
          CALL cl_set_comp_entry("ima930,ima932,ima934",FALSE) #DEV-D30026 add
      END IF
   END IF
 
  #DEV-D30026---add---str---
  #IF NOT cl_null(g_aza.aza131) AND g_aza.aza131 = 'Y' THEN #是否與M-Barcode整合                        #DEV-D40019 mark      
   IF g_aza.aza131 = 'Y' AND g_ima.ima930 = 'Y' THEN        #是否與M-Barcode整合且有勾選使用條碼否欄位  #DEV-D40019 add      
     #包號管理否(ima931)='N'且條碼產生時機點(ima932) MATCHES '[ABCDEFGIKL]' 時,才能維護批/序號相關欄位  #DEV-D40010 add FGKL #DEV-D40015 add I
      IF g_ima.ima931 = 'N' AND g_ima.ima932 MATCHES '[ABCDEFGIKL]' THEN            #DEV-D40010 add FGKL #DEV-D40015 add I                  
          CALL cl_set_comp_entry("ima918,ima919,ima920",TRUE)         #批號相關
          CALL cl_set_comp_entry("ima921,ima922,ima923,ima924",TRUE)  #序號相關
      ELSE
          CALL cl_set_comp_entry("ima918,ima919,ima920",FALSE)        #批號相關
          CALL cl_set_comp_entry("ima921,ima922,ima923,ima924",FALSE) #序號相關
          LET g_ima.ima918 = 'N'
          LET g_ima.ima919 = 'N'
          LET g_ima.ima920 = ''
          LET g_ima.ima921 = 'N'
          LET g_ima.ima922 = 'N'
          LET g_ima.ima923 = ''
          LET g_ima.ima924 = 'N'
          DISPLAY BY NAME g_ima.ima918,g_ima.ima919,g_ima.ima920
          DISPLAY BY NAME g_ima.ima921,g_ima.ima922,g_ima.ima923,g_ima.ima924
      END IF
     #條碼產生時機點(ima932)MATCHES '[ABCDEFGIKL]' 時,才能維護包號管理否(ima931)    #DEV-D40010 add FGKL  #DEV-D40015 add I
     #條碼產生時機點(ima932)MATCHES '[ABCDEHFGIKL]'時,才能維護包號編碼原則(ima933)  #DEV-D40010 add FGKL  #DEV-D40015 add I
      IF g_ima.ima932 MATCHES '[ABCDEFGIKL]' THEN                                   #DEV-D40010 add FGKL  #DEV-D40015 add I
          CALL cl_set_comp_entry("ima931,ima933",TRUE)  #包號相關
      ELSE
          IF g_ima.ima932 = 'H' THEN
             LET g_ima.ima931 = 'Y'
          ELSE
             LET g_ima.ima931 = 'N'
          END IF        
          LET g_ima.ima933 = ''
          CALL cl_set_comp_entry("ima931,ima933",FALSE) #包號相關
          DISPLAY BY NAME g_ima.ima931,g_ima.ima933
      END IF
   END IF 
  #DEV-D30026---add---end---

   IF INFIELD(ima08) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ima13,ima903",TRUE)
   END IF
 
   IF (NOT g_before_input_done) THEN  #單位控制方式/計價單位 #FUN-540025
      CALL cl_set_comp_entry("ima906,ima907,ima908",TRUE)
   END IF
 
   IF INFIELD(ima906) OR (NOT g_before_input_done) THEN  #第二單位 #FUN-540025
      CALL cl_set_comp_entry("ima907",TRUE)
   END IF
 
   IF g_sma.sma95 = "Y" THEN  #FUN-C80030 add
      CALL cl_set_comp_entry("ima918,ima919,ima920,ima921",TRUE)   #No.MOD-840174
      CALL cl_set_comp_entry("ima922,ima923,ima924,ima925",TRUE)   #No.MOD-840174
   END IF                     #FUN-C80030 add
   #MOD-C30091---begin
   #CALL cl_set_comp_entry("ima922,ima923,ima924,ima925",TRUE)  #No.MOD-840174 ---ADD
   #CALL cl_set_comp_entry("ima922,ima923,ima924",TRUE)         #No.FUN-C80030 mark
   IF g_ima.ima918 = 'Y' OR g_ima.ima921 = 'Y' THEN 
      CALL cl_set_comp_entry("ima925",TRUE)  
   ELSE 
      CALL cl_set_comp_entry("ima925",FALSE) 
   END IF 
   #MOD-C30091---end
   CALL cl_set_comp_entry('ima151',TRUE)     #No.FUN-830121
   CALL cl_set_comp_entry("imaicd08",TRUE)   
   #FUN-B30192--add--begin
   IF g_imaicd.imaicd04 = '0' OR g_imaicd.imaicd04 = '1' OR g_imaicd.imaicd04 = '2' THEN   #FUN-C30278
      CALL cl_set_comp_entry("imaicd14",TRUE)
   END IF
   #FUN-B30192--add--end
   CALL cl_set_comp_entry("imaicd08,imaicd09,imaicd15",TRUE)   #CHI-BA0046
   CALL cl_set_comp_entry("imaicd17,imaicd18,imaicd19,imaicd20,imaicd21",TRUE)   #FUN-BC0103   
 
  #FUN-A80150---add---start---
   IF g_ima.ima156 = 'Y' THEN
      CALL cl_set_comp_entry("ima157",TRUE)
   END IF
  #FUN-A80150---add---end---

#TQC-B90236--add--begin
   CALL cl_set_comp_entry("ima928",TRUE)
   IF g_ima.ima928 = 'N' THEN
      CALL cl_set_comp_entry("ima929",TRUE)
   END IF
#TQC-B90236--add--end
  #FUN-C90075---begin
  SELECT gev04 INTO g_gev04 FROM gev_file
   WHERE gev01 = '1' AND gev02 = g_ima.ima916
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt
    FROM gex_file
   WHERE gex01 = g_gev04
     AND gex02 = '1'
     AND gex04 = 'aimi100'
     AND gex05 = g_ima.ima01

  IF l_cnt = 0 AND g_ima.ima916 = g_plant THEN
     CALL cl_set_comp_entry("ima25",TRUE)
  END IF  
  #FUN-C90075---end
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE li_count  LIKE type_file.num5    #2005/05/11 FUN-550021 By Lifeng  #No.FUN-690026 SMALLINT
   DEFINE lc_sql    STRING                 #2005/05/11 FUN-550021 By Lifeng
   DEFINE l_errno   STRING                 #FUN-560112
   DEFINE l_n       LIKE type_file.num5   #No.MOD-840160
   DEFINE l_n2      LIKE type_file.num5    #MOD-C30066
   DEFINE l_ima151  LIKE ima_file.ima151   #MOD-C30270 add
   DEFINE l_imaag   LIKE ima_file.imaag    #MOD-C30270 add
   DEFINE l_cnt     LIKE type_file.num5    #FUN-C90075
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      #CALL cl_set_comp_entry("ima01,ima940,ima941,ima151,imaag",FALSE)  #MOD-BB0157
       CALL cl_set_comp_entry("ima01",FALSE)  #MOD-BB0157
   END IF
   IF p_cmd = 'u' AND g_chkey = 'Y' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ima9021",TRUE) 
      IF NOT cl_null(g_aza.aza131) AND g_aza.aza131 = 'Y' THEN #是否與M-Barcode整合 #DEV-D30026 add if 判斷
          #DEV-D30026--add---begin---------------------
          IF g_ima.ima930 = 'Y' THEN
             CALL cl_set_comp_entry("ima931,ima932,ima933",TRUE)
             CALL cl_set_comp_entry("ima934",g_aza.aza132='Y') #No:DEV-D30026--add
             IF NOT cl_null(g_ima.ima931) AND g_ima.ima931 = 'Y' THEN #包號管理否
                CALL cl_set_comp_required("ima933",TRUE)
             ELSE
                CALL cl_set_comp_required("ima933",FALSE)
                CALL cl_set_comp_entry("ima933",FALSE)
             END IF
          ELSE
             CALL cl_set_comp_required("ima933",FALSE)
             CALL cl_set_comp_entry("ima931,ima932,ima933",FALSE)
             CALL cl_set_comp_entry("ima934",FALSE) #No:DEV-D30026--add
          END IF
          #DEV-D30026---add---end----------------------
      ELSE
          CALL cl_set_comp_entry("ima930,ima932,ima934",FALSE) #DEV-D30026 add
      END IF
   END IF
  #DEV-D30026 add str-----------------------
  #IF NOT cl_null(g_aza.aza131) AND g_aza.aza131 = 'Y' THEN #是否與M-Barcode整合     
   IF g_aza.aza131 = 'Y' AND g_ima.ima930 = 'Y' THEN #是否與M-Barcode整合     
     #包號管理否(ima931)='N'且條碼產生時機點(ima932) MATCHES '[ABCDEFGIKL]' 時,才能維護批/序號相關欄位  #DEV-D40010 add FGKL 
      IF g_ima.ima931 = 'N' AND g_ima.ima932 MATCHES '[ABCDEFGIKL]' THEN          #DEV-D40010 add FGKL                      
         CALL cl_set_comp_entry("ima918,ima919,ima920",TRUE)         #批號相關
         CALL cl_set_comp_entry("ima921,ima922,ima923,ima924",TRUE)  #序號相關
      ELSE
         CALL cl_set_comp_entry("ima918,ima919,ima920",FALSE)        #批號相關
         CALL cl_set_comp_entry("ima921,ima922,ima923,ima924",FALSE) #序號相關
         LET g_ima.ima918 = 'N'
         LET g_ima.ima919 = 'N'
         LET g_ima.ima920 = ''
         LET g_ima.ima921 = 'N'
         LET g_ima.ima922 = 'N'
         LET g_ima.ima923 = ''
         LET g_ima.ima924 = 'N'
         DISPLAY BY NAME g_ima.ima918,g_ima.ima919,g_ima.ima920
         DISPLAY BY NAME g_ima.ima921,g_ima.ima922,g_ima.ima923,g_ima.ima924
      END IF
     #條碼產生時機點(ima932)MATCHES '[ABCDEFGIKL]' 時,才能維護包號管理否(ima931)    #DEV-D40010 add FGKL
     #條碼產生時機點(ima932)MATCHES '[ABCDEHFGIKL]'時，才能維護包號編碼原則(ima933) #DEV-D40010 add FGKL
      IF g_ima.ima932 MATCHES '[ABCDEFGIKL]' THEN                                    #DEV-D40010 add FGKL
         CALL cl_set_comp_entry("ima931,ima933",TRUE) #包號相關
      ELSE
         IF g_ima.ima932 = 'H' THEN
            LET g_ima.ima931 = 'Y'
         ELSE
            LET g_ima.ima931 = 'N'
         END IF    
         CALL cl_set_comp_entry("ima931,ima933",FALSE)#包號相關
         LET g_ima.ima933 = ''
         DISPLAY BY NAME g_ima.ima931,g_ima.ima933
      END IF
   END IF         
  #DEV-D30026 add end-----------------------
#TQC-B50017 --begin--
   IF p_cmd = 'u' THEN 
      IF g_ima.ima01[1,4] ='MISC' THEN 
         CALL cl_set_comp_entry("ima24",FALSE) 
      ELSE 
      	  CALL cl_set_comp_entry("ima24",TRUE)
      END IF  	            
   END IF 
#TQC-B50017 --end--
   
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
      IF NOT (g_sma.sma104 = 'Y' AND g_ima.ima08 MATCHES "[MTS]") THEN  #FUN-B20061
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
           #CALL cl_set_comp_visible("imaag",g_sma.sma120 = 'Y')  #MOD-BB0157
            CALL cl_set_comp_visible("imaag",g_ima.ima151 = 'Y')  #MOD-BB0157
         END IF
         CLOSE lcurs_qry_ima
      END IF
   END IF
 
   IF g_ima.ima906 = '1' THEN
      LET g_ima.ima907 = NULL
      DISPLAY BY NAME g_ima.ima907
      CALL cl_set_comp_entry("ima907",FALSE)
   END IF
 
   #CHI-B80043 --- modify --- start ---
   LET l_n = 0
  #MOD-C30066 str -----
  #SELECT COUNT(*) INTO l_n FROM rvbs_file
  # WHERE rvbs021 = g_ima.ima01
  #IF l_n > 0 THEN
  #   LET g_ima.ima918 = 'Y'
  #   LET g_ima.ima921 = 'Y'
  #   DISPLAY BY NAME g_ima.ima918
  #   DISPLAY BY NAME g_ima.ima921
  #END IF
   IF g_sma.sma95 = "N" THEN                         #FUN-C80030 add
      CALL cl_set_comp_entry("ima918,ima921",FALSE)  #FUN-C80030 add
   ELSE                                              #FUN-C80030 add
      SELECT COUNT(*) INTO l_n FROM rvbs_file
       WHERE rvbs021 = g_ima.ima01 AND rvbs03 !=' '
      SELECT COUNT(*) INTO l_n2 FROM rvbs_file
       WHERE rvbs021 = g_ima.ima01 AND rvbs04 !=' '
      IF l_n > 0 THEN
         LET g_ima.ima921 = 'Y'
         DISPLAY BY NAME g_ima.ima921
      END IF
      IF l_n2 > 0 THEN
         LET g_ima.ima918 = 'Y'
         DISPLAY BY NAME g_ima.ima918
      END IF
  #MOD-C30066 end -----
      LET l_n = 0
   #CHI-B80043 --- modify ---  end  ---
      SELECT COUNT(*) INTO l_n FROM imgs_file
       WHERE imgs01 = g_ima.ima01
      IF l_n > 0 THEN
         CALL cl_set_comp_entry("ima918,ima919,ima920,ima921",FALSE)
         CALL cl_set_comp_entry("ima922,ima923,ima924,ima925",FALSE)
      END IF
   END IF                                            #FUN-C80030 add 
    
   IF g_ima.ima918 = 'N' THEN
      CALL cl_set_comp_entry("ima919",FALSE)
   ELSE                                      #MOD-A50099 add
      CALL cl_set_comp_entry("ima919",TRUE)  #MOD-A50099 add
   END IF
 
   IF g_ima.ima919 = 'N' THEN
      CALL cl_set_comp_entry("ima920",FALSE)
   ELSE                                      #MOD-A50099 add
      CALL cl_set_comp_entry("ima920",TRUE)  #MOD-A50099 add
   END IF
 
   IF g_ima.ima921 = 'N' THEN
      CALL cl_set_comp_entry("ima922,ima924",FALSE)
   ELSE                                             #MOD-A50099 add
      CALL cl_set_comp_entry("ima922,ima924",TRUE)  #MOD-A50099 add
      #DEV-D30033--begin
      IF g_ima.ima930 = 'Y' THEN
         CALL cl_set_comp_entry("ima924",FALSE)
      END IF
      #DEV-D30033--end
   END IF
 
   IF g_ima.ima922 = 'N' THEN
      CALL cl_set_comp_entry("ima923",FALSE)
   ELSE                                      #MOD-A50099 add
      CALL cl_set_comp_entry("ima923",TRUE)  #MOD-A50099 add
   END IF
 
   IF g_ima.ima918 = 'N' AND g_ima.ima921 = 'N' THEN
      CALL cl_set_comp_entry("ima925",FALSE)
   ELSE                                      #MOD-A50099 add
      CALL cl_set_comp_entry("ima925",TRUE)  #MOD-A50099 add
   END IF
   #MOD-B40200-- begin --
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM ida_file WHERE ida01 = g_ima.ima01
   IF cl_null(l_n) THEN LET l_n = 0 END IF
   IF l_n = 0 THEN
      SELECT COUNT(*) INTO l_n FROM idb_file WHERE idb01 = g_ima.ima01
      IF cl_null(l_n) THEN LET l_n = 0 END IF
      IF l_n = 0 THEN
         SELECT COUNT(*) INTO l_n FROM idd_file WHERE idd01 = g_ima.ima01
         IF cl_null(l_n) THEN LET l_n = 0 END IF
      END IF
   END IF
   IF l_n > 0 THEN
      CALL cl_set_comp_entry("imaicd08",FALSE)
   END IF
   #MOD-B40200-- end --
   SELECT COUNT(*) INTO l_n FROM rva_file,rvb_file WHERE rva01 = rvb01 AND rvb05 = g_ima.ima01 AND rvaconf= 'Y'
   IF l_n >0 THEN
      CALL cl_set_comp_entry("imaicd08",FALSE)
   END IF     
   #FUN-B30192--add--begin
   IF g_imaicd.imaicd04 <> '0' AND g_imaicd.imaicd04 <> '1' AND g_imaicd.imaicd04 <> '2' THEN  #FUN-C30278
      CALL cl_set_comp_entry("imaicd14",FALSE)
      LET g_imaicd.imaicd14 = 0
   END IF
   #FUN-B30192--add--end
   #CHI-BA0046 --START--
   #IF g_imaicd.imaicd05 MATCHES'[2346]' THEN   #FUN-C30278
   #IF g_imaicd.imaicd05 MATCHES'[36]' THEN      #FUN-C30278  #TQC-C40078 mark
   IF g_imaicd.imaicd05 MATCHES '[36]' THEN      #FUN-C30278  #TQC-C40078 add
      CALL cl_set_comp_entry("imaicd08,imaicd09,imaicd15",FALSE)
   END IF    
   #CHI-BA0046 --END--  
   #FUN-BC0103 --START--
   IF g_imaicd.imaicd04 <> '3' THEN 
      CALL cl_set_comp_entry("imaicd17",FALSE)
   END IF    
   IF g_imaicd.imaicd17 <> '2' THEN 
      CALL cl_set_comp_entry("imaicd18,imaicd19,imaicd20,imaicd21",FALSE)
   END IF    
   #FUN-BC0103 --END--   
  #FUN-A80150---add---start---
   IF g_ima.ima156 = 'N' THEN
      CALL cl_set_comp_entry("ima157",FALSE)
   ELSE
      CALL cl_set_comp_entry("ima157",TRUE)
   END IF
  #FUN-A80150---add---end---

#TQC-B90236--add--begin
   SELECT COUNT(*) INTO l_n FROM ima_file
    WHERE ima929 = g_ima.ima01
   IF l_n > 0 THEN
      CALL cl_set_comp_entry("ima928",FALSE)
   END IF
   SELECT COUNT(*) INTO l_n FROM inj_file
    WHERE inj01 = g_ima.ima01 AND inj06 ='Y'
   IF l_n > 0 THEN
      CALL cl_set_comp_entry("ima929",FALSE)
   END IF
   IF g_ima.ima928 <> 'N' THEN
      CALL cl_set_comp_entry("ima929",FALSE)
      LET g_ima.ima929 = NULL
      DISPLAY BY NAME g_ima.ima929
   END IF
      
#TQC-B90236--add--end

#MOD-C30270--add--begin--
#MOD-C30270--add--end--
  #FUN-C90075---begin
  SELECT gev04 INTO g_gev04 FROM gev_file
   WHERE gev01 = '1' AND gev02 = g_ima.ima916
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt
    FROM gex_file
   WHERE gex01 = g_gev04
     AND gex02 = '1'
     AND gex04 = 'aimi100'
     AND gex05 = g_ima.ima01

  IF l_cnt > 0 THEN
     CALL cl_set_comp_entry("ima25",FALSE)
  END IF 
                     
  IF g_ima.ima916 <> g_plant THEN
     CALL cl_set_comp_entry("ima25",FALSE)
  END IF 
  #FUN-C90075---end
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

#TQC-B90236------------add----------------begin
FUNCTION i100_ima929()
DEFINE  l_imaacti  LIKE ima_file.imaacti
   LET  g_errno = ''
   SELECT imaacti INTO l_imaacti FROM ima_file
    WHERE ima928 = 'Y'
      AND ima01 = g_ima.ima929
   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'aim1119'
      WHEN l_imaacti <> 'Y'
         LET g_errno = 'aic-020'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-----'
   END CASE
   IF cl_null(g_errno) THEN
      DISPLAY BY NAME g_ima.ima929
   END IF
END  FUNCTION
#TQC-B90236------------add----------------end
 
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
           imz918,imz919,imz920,imz921,imz922,imz923,imz924,imz925,   #FUN-A10004
           imz136,imz137,imz391,imz1321,
           imz72,imz153,imz601,  #FUN-910053   #MOD-9C0032 add imz601
           imz926,        #FUN-930108 add imz926
           imz156,imz157,imz158,               #FUN-A80150 add 
           imz022,imz251,imz159,                #FUN-B30092 add  #FUN-B50096 add ima159
           imz163,imz1631                       #FUN-C80094
          #,imzicd01,imzicd02,imzicd03,
          # imzicd04,imzicd05,imzicd06,
            ,imzicd01,imzicd04,imzicd05,imzicd16,  #FUN-B30192
            imzicd08,imzicd09,imzicd10,
          # imzicd12,imzicd13,imzicd14,imzicd15   #FUN-A40022 #FUN-B30192 #FUN-B50096
            imzicd12,imzicd14,imzicd15,            #FUN-B50096 mark imzicd13
            imzicd17,imzicd18,imzicd19,imzicd20,imzicd21   #FUN-BC0103      
 
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
           g_ima.ima918,g_ima.ima919,g_ima.ima920,               #FUN-A10004  
           g_ima.ima921,g_ima.ima922,g_ima.ima923,               #FUN-A10004  
           g_ima.ima924,g_ima.ima925,                            #FUN-A10004 
           g_ima.ima136,g_ima.ima137,g_ima.ima391,g_ima.ima1321, #FUN-650004   #FUN-680034
           g_ima.ima915,g_ima.ima153,g_ima.ima601,               #FUN-710060 add #FUN-910053 add ima153 #MOD-9C0032 add ima601
           g_ima.ima926,                                         #FUN-930108 add ima926
           g_ima.ima156,g_ima.ima157,g_ima.ima158,               #FUN-A80150 add
           g_ima.ima022,g_ima.ima251,g_ima.ima159,               #FUN-B30092 add   #FUN-B50096
           g_ima.ima163,g_ima.ima1631                            #FUN-C80094
         #  ,g_imaicd.imaicd01,g_imaicd.imaicd02,g_imaicd.imaicd03,
         #   g_imaicd.imaicd04,g_imaicd.imaicd05,g_imaicd.imaicd06,
            ,g_imaicd.imaicd01,g_imaicd.imaicd04,g_imaicd.imaicd05,g_imaicd.imaicd16,  #FUN-B30192
            g_imaicd.imaicd08,g_imaicd.imaicd09,g_imaicd.imaicd10,
         #  g_imaicd.imaicd12,g_imaicd.imaicd13,g_imaicd.imaicd14,g_imaicd.imaicd15   #FUN-A40022 #FUN-B30192   #FUN-B50096
            g_imaicd.imaicd12,g_imaicd.imaicd14,g_imaicd.imaicd15,                    #FUN-B50096 mark imaicd13
            g_imaicd.imaicd17,g_imaicd.imaicd18,g_imaicd.imaicd19,g_imaicd.imaicd20,g_imaicd.imaicd21   #FUN-BC0103
           FROM  imz_file
           WHERE imz01 = g_ima.ima06
   IF g_ima.ima99 IS NULL THEN LET g_ima.ima99 = 0 END IF
   IF g_ima.ima133 IS NULL THEN LET g_ima.ima133 = g_ima.ima01 END IF
   #FUN-C80030--add--str--
   IF g_sma.sma95 = "N" THEN
      LET g_ima.ima918 = "N"
      LET g_ima.ima919 = "N"
      LET g_ima.ima920 = NULL 
      LET g_ima.ima921 = "N"
      LET g_ima.ima922 = "N"
      LET g_ima.ima923 = NULL 
      LET g_ima.ima924 = "N"
      LET g_ima.ima925 = "1" 
   END IF 
   #FUN-C80030--add--end--
   IF g_ima.ima01[1,4]='MISC' THEN #NO:6808(養生)
      LET g_ima.ima08='Z'
   END IF
       #MOD-C30091---begin
       IF cl_null(g_ima.ima159) THEN
          LET g_ima.ima159 = '3'
       END IF 
       IF g_ima.ima918 = 'Y' OR g_ima.ima921 = 'Y' THEN
          IF cl_null(g_ima.ima925) THEN
             LET g_ima.ima925 = '1'
          END IF 
       END IF 
       #MOD-C30091---end
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
 
#FUN-C90107 mark str------
#TQC-CB0079 remark --str--
#FUN-C90107 mark str--- 
#FUNCTION i100_x()
#    DEFINE
#        l_chr LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#        l_n   LIKE type_file.num5     #No.FUN-690026 SMALLINT
#    DEFINE l_prog   LIKE type_file.chr8    #FUN-870101 add 
#    DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3,   #FUN-A20044
#           l_unavl_stk      LIKE type_file.num15_3,   #FUN-A20044
#           l_avl_stk        LIKE type_file.num15_3    #FUN-A20044           
#
#    LET g_errno = ''   #FUN-5A0081
#    IF s_shut(0) THEN RETURN END IF
#    IF g_ima.ima01 IS NULL THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#    IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
#       CALL cl_err(g_ima.ima916,'aoo-045',1)
#       RETURN
#    END IF
#
#    #MOD-A90011 add --start--
#    #--->產品結構(bma_file,bmb_file)須有效BOM
#    LET l_n = 0
#    SELECT COUNT(*) INTO l_n FROM bma_file
#     WHERE bma01 = g_ima.ima01  
#       AND bmaacti = 'Y'
#   #IF l_n > 0 THEN                          #MOD-CA0016 mark
#    IF l_n > 0 AND g_ima.imaacti = 'Y' THEN  #MOD-CA0016
#        CALL cl_err(g_ima.ima01,'aim-022',1)
#        RETURN
#    END IF
#    LET l_n = 0
#   #MOD-B60132---modify---start---
#   #SELECT COUNT(*) INTO l_n FROM bmb_file
#   # WHERE bmb03 = g_ima.ima01
#   #   AND (bmb04<=g_today OR bmb04 IS NULL)
#   #   AND (bmb05> g_today OR bmb05 IS NULL)
#    SELECT COUNT(*) INTO l_n FROM bmb_file,bma_file
#     WHERE bmb03 = g_ima.ima01
#       AND bma01 = bmb01 AND bma06 = bmb29
#       AND (bmb04<=g_today OR bmb04 IS NULL)
#       AND (bmb05> g_today OR bmb05 IS NULL)
#       AND bmaacti = 'Y'
#   #MOD-B60132---modify---end---
#   #IF l_n > 0 THEN                          #MOD-CA0016 mark
#    IF l_n > 0 AND g_ima.imaacti = 'Y' THEN  #MOD-CA0016
#        CALL cl_err(g_ima.ima01,'aim-022',1)
#        RETURN
#    END IF
#    #MOD-A90011 add --end--
#
#    #CHI-AC0014 add --start--
#    LET l_n = 0
#    SELECT COUNT(DISTINCT ina01) INTO l_n
#      FROM ina_file,inb_file  
#     WHERE inb01 = ina01 
#       AND inb04 = g_ima.ima01
#      #AND inaconf != 'X'       #MOD-B10101 mark
#       AND inaconf = 'N'        #MOD-B10101 add
#    IF l_n > 0 THEN
#        CALL cl_err(g_ima.ima01,'aim-026',1)
#        RETURN
#    END IF
#    #CHI-AC0014 add --end--
#
#    BEGIN WORK
#    OPEN i100_cl USING g_ima.ima01
#    FETCH i100_cl INTO g_ima.*
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
#       ROLLBACK WORK   #MOD-A10083
#       CLOSE i100_cl   #MOD-A10083
#       RETURN
#    END IF
#    CALL s_getstock(g_ima.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   #FUN-A20044 add
# 
##   IF g_ima.ima26  >0 THEN        #FUN-A20044
#    IF l_avl_stk_mpsmrp > 0 THEN   #FUN-A20044 
#       CALL cl_err('','mfg9165',0) 
#       ROLLBACK WORK   #MOD-A10083
#       CLOSE i100_cl   #MOD-A10083
#       RETURN 
#    END IF
##   IF g_ima.ima261 >0 THEN       #FUN-A20044
#    IF l_unavl_stk > 0 THEN       #FUN-A20044 
#       CALL cl_err('','mfg9166',0) 
#       ROLLBACK WORK   #MOD-A10083
#       CLOSE i100_cl   #MOD-A10083
#       RETURN 
#    END IF
##   IF g_ima.ima262 >0 THEN       #FUN-A20044
#    IF l_avl_stk > 0 THEN         #FUN-A20044
#       CALL cl_err('','mfg9167',0) 
#       ROLLBACK WORK   #MOD-A10083
#       CLOSE i100_cl   #MOD-A10083
#       RETURN 
#    END IF
# 
#    LET l_n = 0
#    SELECT COUNT(*) INTO l_n FROM sfb_file     #判斷是否有工單
#           WHERE sfb05 = g_ima.ima01 AND sfb04 < '8'   #No.MOD-940165 add   
#             AND sfb87 != 'X'                           #No:MOD-9B0066 add
#    IF cl_null(l_n) OR l_n = 0 THEN
#       SELECT COUNT(*) INTO l_n FROM pmn_file,pmm_file  #判斷是否有採購單    #No:MOD-9B0066 add pmm_file
#              WHERE pmn04 = g_ima.ima01 AND pmn16 < '6'
#                AND pmn01 = pmm01 AND pmm18 != 'X'    #No:MOD-9B0066 add
#       IF cl_null(l_n) OR l_n = 0 THEN
#          SELECT COUNT(*) INTO l_n FROM oeb_file,oea_file   #判斷是否有訂單    #No:MOD-9B0066 add oea_file
#                 WHERE oeb04 = g_ima.ima01 AND oeb70 != 'Y'
#                   AND oeb01 = oea01 AND oeaconf !='X'   #No:MOD-9B0066 add
#       END IF
#    END IF
# 
#    IF NOT cl_null(l_n) AND l_n != 0 THEN
#       IF NOT cl_confirm('aim-141') THEN
#          ROLLBACK WORK   #MOD-A10083
#          CLOSE i100_cl   #MOD-A10083
#          RETURN
#       END IF
#    END IF
# 
#    SELECT COUNT(*) INTO l_n FROM img_file
#     WHERE img01=g_ima.ima01
#       AND img10 <>0
#    IF l_n > 0 THEN 
#       LET g_errno='mfg9163' 
#       CALL cl_err('',g_errno,0)       #No:MOD-A10080 add
#       ROLLBACK WORK   #MOD-A10083
#       CLOSE i100_cl   #MOD-A10083
#       RETURN 
#    END IF #MOD-5B0336 add RETURN
#    IF cl_exp(0,0,g_ima.imaacti) THEN
#        LET g_chr=g_ima.imaacti
#        LET g_chr2=g_ima.ima1010   #No.FUN-610013
#        CASE g_ima.ima1010
#          WHEN '0' #開立
#               IF g_ima.imaacti='N' THEN
#                  LET g_ima.imaacti='P'
#               ELSE
#                  LET g_ima.imaacti='N'
#               END IF
#          WHEN '1' #確認
#               IF g_ima.imaacti='N' THEN
#                  LET g_ima.imaacti='Y'
#               ELSE
#                  LET g_ima.imaacti='N'
#               END IF
#         END CASE
#        UPDATE ima_file
#            SET imaacti=g_ima.imaacti,
#                imamodu=g_user, imadate=g_today
#            WHERE ima01 = g_ima.ima01
#        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err3("upd","ima_file",g_ima_t.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
#            LET g_ima.imaacti=g_chr
#            LET g_ima.ima1010=g_chr2      #No.FUN-610013
#            LET g_success = 'N'           #FUN-9A0056 add
#        END IF
#        
#       #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD  #FUN-9A0056 mark
#        IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" AND g_ima.ima1010 = '1' THEN  #FUN-9A0056 add 
#          
#           IF g_ima.imaacti='N' THEN 
#             #FUN-9A0056 mark str ------
#              ## CALL aws_mescli
#              ## 傳入參數: (1)程式代號
#              ##           (2)功能選項：insert(新增),update(修改),delete(刪除)
#              ##           (3)Key
#              #LET l_prog=''
#              #CASE g_ima.ima08
#              #   WHEN 'P' LET l_prog = 'aimi100' 
#              #   WHEN 'M' LET l_prog = 'axmi121'
#              #   OTHERWISE LET l_prog= ' '
#              #END CASE 
#              #CASE aws_mescli(l_prog,'delete',g_ima.ima01)
#              #   WHEN 0  #無與 MES 整合
#              #        CALL cl_msg('Delete O.K')
#              #   WHEN 1  #呼叫 MES 成功
#              #        CALL cl_msg('Delete O.K, Delete MES O.K')
#              #   WHEN 2  #呼叫 MES 失敗
#              #        RETURN FALSE
#              #END CASE
#             #FUN-9A0056 mark end ------
#              #確認資料由有效變無效,則傳送刪除MES
#              #CALL i100_mes(g_ima.ima08,'delete',g_ima.ima01)   #FUN-9A0056 add #FUN-A70106 mark
#               CALL i100sub_mes(g_ima.ima08,'delete',g_ima.ima01)                #FUN-A70106 add
#            ELSE                                                 #FUN-9A0056 add
#              #確認資料由無效變有效,則傳送新增MES
#              #CALL i100_mes(g_ima.ima08,'insert',g_ima.ima01)   #FUN-9A0056 add #FUN-A70106 mark
#               CALL i100sub_mes(g_ima.ima08,'insert',g_ima.ima01)                #FUN-A70106 add    
#           END IF 
#        END IF  #TQC-8B0011  ADD
#
#        #FUN-9A0056-----start
#        IF g_success = 'N' THEN
#           ROLLBACK WORK
#           CLOSE i100_cl
#           RETURN
#        END IF
#        #FUN-9A0056-------end
# 
#        DISPLAY BY NAME g_ima.ima1010     #No.FUN-610013
#        DISPLAY BY NAME g_ima.imaacti
#        CALL i100_list_fill()             #No.FUN-7C0010
#    END IF
#    CLOSE i100_cl
#    COMMIT WORK
#END FUNCTION
#FUN-C90107 mark end---
#TQC-CB0079 remark --end--
#FUN-C90107 mark end----------
 
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
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       ROLLBACK WORK    #FUN-680010
       RETURN FALSE
    END IF
    FETCH i100_cl INTO g_ima.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       ROLLBACK WORK    #FUN-680010
       RETURN FALSE
    END IF
    CALL s_chkitmdel(g_ima.ima01) RETURNING g_errno
    IF NOT cl_null(g_errno) THEN
       CALL cl_err('',g_errno,0)
       ROLLBACK WORK    #FUN-6C0006
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
 
        LET l_n = 0
        SELECT COUNT(*) INTO l_n FROM icb_file
         WHERE icb01 = g_ima.ima01
        IF l_n  > 0 THEN
           IF cl_confirm('aic-320') THEN
              DELETE FROM icb_file WHERE icb01 = g_ima.ima01
              IF SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err3("del","icb_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 RETURN FALSE
              END IF
           END IF
        END IF
        #FUN-C20100 --START--
        SELECT COUNT(*) INTO l_n FROM icu_file
         WHERE icu01 = g_ima.ima01
        IF l_n > 0 THEN
           CALL cl_err3("sel","icu_file",g_ima.ima01,"",'aic-326',"","",1) 
           ROLLBACK WORK
           RETURN FALSE
        END IF  
        #FUN-C20100 --END--
        DELETE FROM ima_file WHERE ima01 = g_ima.ima01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
           ROLLBACK WORK  #NO.FUN-680010
           RETURN FALSE         #NO.FUN-680010
        ELSE
           IF NOT s_del_imaicd(g_ima.ima01,'') THEN
              ROLLBACK WORK
              RETURN FALSE
           END IF
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
           #MOD-C80145 -- add start --
           DELETE FROM rta_file WHERE rta01 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","rta_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              RETURN FALSE
           END IF
           #MOD-C80145 -- add end --
           UPDATE ima_file SET imadate=g_today WHERE ima01 = g_ima.ima01

#TQC-B90236-------add------begin  删除imac_file资料
           DELETE FROM imac_file WHERE imac01 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imac_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              RETURN FALSE
           END IF
#TQC-B90236-------add------end
          
           LET g_msg=TIME
           #增加記錄料號
           #LET l_azo06='R: ',g_ima.ima01 CLIPPED   #CHI-BC0005 mark
           LET l_azo06='delete'                     #CHI-BC0005 add

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
          #CALL i100_list_fill()        #No.FUN-7C0010   #FUN-C90107 mark
           CALL i100sub_list_fill()        #No.FUN-7C0010   #FUN-C90107 add
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
 
#FUN-A70106--mark---str--
#FUNCTION i100_confirm()
# DEFINE l_imaag    LIKE ima_file.imaag    #No.TQC-640171
# DEFINE #l_sql      LIKE type_file.chr1000 #No.TQC-640171   #No.FUN-690026 VARCHAR(1000)
#        l_sql      STRING     #NO.FUN-910082
# DEFINE l_prog     LIKE type_file.chr8    #FUN-870101 add
# DEFINE l_gew03   LIKE gew_file.gew03    #FUN-950057
# DEFINE l_i       LIKE type_file.num10   #FUN-950057  
# 
#   IF g_ima.ima01 IS NULL THEN
#      CALL cl_err("",-400,0)
#      RETURN
#   END IF
#   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
#      CALL cl_err(g_ima.ima916,'aoo-045',1)
#      RETURN
#   END IF
#   IF g_ima.imaacti='Y' THEN
#      CALL cl_err("",9023,1)
#      RETURN
#   END IF
#   IF g_ima.imaacti='N' THEN
#      #此筆資料已無效, 不可異動
#      CALL cl_err('','aim-153',1)
#   ELSE
#    IF cl_confirm('aap-222') THEN
#      LET g_success = 'Y'    #FUN-9A0056 add
#      BEGIN WORK
#      UPDATE ima_file
#         SET ima1010 = '1', #FUN-690060 mod #'1':確認
#             imaacti = 'Y'  #FUN-690060 mod #'Y':確認
#       WHERE ima01 = g_ima.ima01
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
#                      "ima1010",1)  #No.FUN-660156
#        #ROLLBACK WORK          #FUN-9A0056 mark
#         LET g_success = 'N'    #FUN-9A0056 add
#      ELSE
#        LET g_ima.ima1010 = '1'
#        LET g_ima.imaacti = 'Y'
#        DISPLAY BY NAME g_ima.ima1010
#        DISPLAY BY NAME g_ima.imaacti
#
#       IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD  #FUN-9A0056 mod
#          # CALL aws_mescli()
#          # 傳入參數: (1)程式代號
#          #           (2)功能選項：insert(新增),update(修改),delete(刪除)
#          #           (3)Key
#          LET l_prog=''
#          CASE g_ima.ima08
#             WHEN 'P' LET l_prog = 'aimi100' 
#             WHEN 'M' LET l_prog = 'axmi121'
#             OTHERWISE LET l_prog= ' '
#          END CASE 
#          CASE aws_mescli(l_prog,'insert',g_ima.ima01)
#             WHEN 0  #無與 MES 整合
#                  MESSAGE 'INSERT O.K'
#             WHEN 1  #呼叫 MES 成功
#                  MESSAGE 'INSERT O.K, INSERT MES O.K'
#             WHEN 2  #呼叫 MES 失敗
#                  RETURN FALSE
#          END CASE
#       END IF #TQC-8B0011  ADD
#      END IF
#
#      IF g_success = 'Y' THEN   #FUN-9A0056 add 
#        SELECT imaag INTO l_imaag
#          FROM ima_file
#         WHERE ima01 = g_ima.ima01
#        IF l_imaag IS NULL OR l_imaag = '@CHILD' THEN
#           #COMMIT WORK #FUN-690060   #FUN-9A0056 mark
#           #RETURN                    #FUN-9A0056 mark
#        ELSE
#           LET l_sql = " UPDATE ima_file SET ima1010 = '1',imaacti='Y' ", #FUN-690060 mod
#                       "  WHERE ima01 LIKE '",g_ima.ima01,"_%'"
#           PREPARE ima_cs3       FROM l_sql
#           EXECUTE ima_cs3
#           IF STATUS THEN
#              CALL cl_err('ima1010',STATUS,1)  #FUN-690060 0->1
#              #ROLLBACK WORK                   #FUN-690060 add #FUN-9A0056 mark
#              #RETURN                          #FUN-9A0056 mark  
#              LET g_success = 'N'              #FUN-9A0056 add
#           END IF
#        END IF
#      END IF   #FUN-9A0056 add
#
#     #FUN-9A0056 add str ----------------
#      IF g_success = 'N' THEN
#         ROLLBACK WORK
#         RETURN
#      ELSE
#         CALL i100_list_fill()
#         COMMIT WORK
#      END IF
#     #FUN-9A0056 add end ----------------
#      #CALL i100_list_fill()          #No.FUN-7C0010 #FUN-9A0056 mark
#      #COMMIT WORK  #FUN-690060 add   #FUN-9A0056 mark
#    END IF
#   END IF
##FUN-950057 ------------------------add start-------------------
#   SELECT gev04 INTO g_gev04 FROM gev_file                                     
#    WHERE gev01 = '1' AND gev02 = g_plant                                      
#      AND gev03 = 'Y'                                                          
#   IF NOT cl_null(g_gev04) THEN
#      SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file
#       WHERE gew01 = g_gev04 AND gew02 = '1'
#      IF l_gew03 = '1' THEN #自动抛转
#         LET l_sql = "SELECT COUNT(*) FROM &ima_file WHERE ima01='",g_ima.ima01,"'" 
#         CALL s_dc_sel_db1(g_gev04,'1',l_sql)
#         IF INT_FLAG THEN                                                       
#            LET INT_FLAG=0                                                      
#            RETURN                                                              
#        END IF                                                                 
#                                                                               
#        CALL g_imax.clear()                                                    
#        LET g_imax[1].sel = 'Y'                                                
#        LET g_imax[1].ima01 = g_ima.ima01
#
#        FOR l_i = 1 TO g_azp1.getLength()                                      
#           LET g_azp[l_i].sel   = g_azp1[l_i].sel                              
#           LET g_azp[l_i].azp01 = g_azp1[l_i].azp01                            
#           LET g_azp[l_i].azp02 = g_azp1[l_i].azp02                            
#           LET g_azp[l_i].azp03 = g_azp1[l_i].azp03                            
#        END FOR                                                                
#                                                                              
#        CALL s_showmsg_init()                                                  
#        CALL s_aimi100_carry(g_imax,g_azp,g_gev04,'0')                         
#        CALL s_showmsg()                                                       
#     END IF                                                                    
#   END IF
##FUN-950057------------------------add end---------------------------------
#
#END FUNCTION
#FUN-A70106--mark---end--
 
FUNCTION i100_notconfirm()
 DEFINE l_imaag    LIKE ima_file.imaag    #No.TQC-640171
 DEFINE l_sql      STRING        #NO.FUN-910082
 DEFINE l_n        LIKE type_file.num5    #No.FUN-870117
 DEFINE l_rte01    LIKE rte_file.rte01    #FUN-AB0025 
 DEFINE l_ima01    LIKE ima_file.ima01    #FUN-C30082
 
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
    #FUN-C30082---begin
    LET g_sql =" SELECT imaicd00  FROM imaicd_file WHERE imaicd11 = '", g_ima.ima01,"'"
    PREPARE aimi100_newcode_pre FROM g_sql
    DECLARE aimi100_newcode_cur CURSOR FOR aimi100_newcode_pre
    
    FOREACH aimi100_newcode_cur INTO l_ima01
       CALL s_chkitmdel(l_ima01) RETURNING g_errno
       IF NOT cl_null(g_errno) THEN
          CALL cl_err(l_ima01,g_errno,0)
          CALL cl_err('','aim-672',1)
          RETURN
       END IF
    END FOREACH
    #FUN-C30082---end
    #MOD-C30407---begin mark
#&ifdef ICD
    #FUN-BC0106 --START--
    #檢查動產生之料號有無已確認狀態
    #LET l_n = 0
    #SELECT COUNT(*) INTO l_n FROM ima_file,imaicd_file
    # WHERE ima01 = imaicd00 AND imaicd11 = g_ima.ima01 AND ima1010 <> '0'
    #IF l_n > 0 THEN
    #   CALL cl_err('','aim-672',1)
    #   RETURN
    #END IF
    #檢查動產生之BOM有無已確認狀態
    #LET l_n = 0
    #SELECT COUNT(*) INTO l_n FROM bma_file
    # WHERE bmaicd01 = g_ima.ima01 AND bma10 <> '0'
    #IF l_n > 0 THEN
    #   CALL cl_err('','aim-672',1)
    #   RETURN
    #END IF        
    #FUN-BC0106 --END--
#&endif 
    #MOD-C30407---end   
    #FUN-AB0011 --------add start-------
    LET g_sql =" SELECT rte01  FROM rte_file WHERE rte03 = '", g_ima.ima01,"'"
    PREPARE aimi100_rte_pre FROM g_sql
    DECLARE aimi100_rte_cur CURSOR FOR aimi100_rte_pre
   
    FOREACH aimi100_rte_cur INTO l_rte01 
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       IF NOT cl_null(l_rte01) THEN
          EXIT FOREACH
       END IF 
    END FOREACH
    IF NOT cl_null(l_rte01) THEN
       CALL cl_err('','aim-670',1)
       RETURN 
    END IF
    #FUN-AB0011 --------add end-----------
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
      LET g_success = 'Y'    #FUN-9A0056 add
      BEGIN WORK
      UPDATE ima_file
         SET ima1010 = '0', #FUN-690060 mod
             imaacti = 'P', #FUN-690060 mod
             imadate = g_today  #FUN-C30315 add
       WHERE ima01 = g_ima.ima01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                      "ima1010",1)  #No.FUN-660156
        #ROLLBACK WORK              #FUN-9A0056 mark
         LET g_success = 'N'        #FUN-9A0056 add
      ELSE
        LET g_ima.ima1010 = '0'
        LET g_ima.imaacti = 'P'
        DISPLAY BY NAME g_ima.ima1010
        DISPLAY BY NAME g_ima.imaacti
      END IF

      IF g_success = 'Y' THEN   #FUN-9A0056 add
        SELECT imaag INTO l_imaag
          FROM ima_file
         WHERE ima01 = g_ima.ima01
        IF l_imaag IS NULL OR l_imaag = '@CHILD' THEN
           #COMMIT WORK #TQC-6C0159 add   #FUN-9A0056 mark
           #RETURN                        #FUN-9A0056 mark
        ELSE
          #LET l_sql = " UPDATE ima_file SET ima1010 = '0',imaacti = 'P' ",  #FUN-690060 mod  #FUN-C30315 mark
           LET l_sql = " UPDATE ima_file SET ima1010 = '0',imaacti = 'P',imadate = '",g_today, "' ",  #FUN-690060 mod #FUN-C30315 add
                       "  WHERE ima01 LIKE '",g_ima.ima01,"_%'"
           PREPARE ima_cs4        FROM l_sql
           EXECUTE ima_cs4
           IF STATUS THEN
              CALL cl_err('ima1010',STATUS,0)
            #ROLLBACK WORK   #FUN-690060 add   #FUN-9A0056 mark
            #RETURN                            #FUN-9A0056 mark
            LET g_success = 'N'                #FUN-9A0056 add
           END IF
        END IF
      END IF   #FUN-9A0056 add

     #FUN-9A0056 add begin ---------------------
      IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
        #CALL i100_mes(g_ima.ima08,'delete',g_ima.ima01)     #FUN-A70106 mark
         CALL i100sub_mes(g_ima.ima08,'delete',g_ima.ima01)  #FUN-A70106 add
      END IF

     #FUN-BC0106 --START--
     WHILE g_success = 'Y'
        #ima_file
        DELETE FROM ima_file WHERE ima01
          IN ( SELECT imaicd00 FROM imaicd_file WHERE imaicd11 = g_ima.ima01)
        IF SQLCA.sqlcode THEN
           CALL cl_err('del ima_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT WHILE 
        END IF
        #icm_file  #FUN-C30082 移動位置
        DELETE FROM icm_file #WHERE icm04 = g_ima.ima01   #FUN-C30082
        WHERE icm04 IN (SELECT imaicd00 FROM imaicd_file WHERE imaicd11=g_ima.ima01) #FUN-C30082
        IF SQLCA.sqlcode THEN
           CALL cl_err('del icm_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT WHILE
        END IF 
        #imaicd_file      
        DELETE FROM imaicd_file WHERE imaicd11 = g_ima.ima01
        IF SQLCA.sqlcode THEN
           CALL cl_err('del imaicd_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT WHILE
        END IF
        #bmb_file
        DELETE FROM bmb_file WHERE bmb01
          IN ( SELECT bma01 FROM bma_file WHERE bmaicd01 = g_ima.ima01)
        IF SQLCA.sqlcode THEN
           CALL cl_err('del ima_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT WHILE
        END IF
        #bma_file
        DELETE FROM bma_file WHERE bmaicd01 = g_ima.ima01
        IF SQLCA.sqlcode THEN
           CALL cl_err('del bma_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT WHILE
        END IF          
        
        EXIT WHILE 
     END WHILE    
     #FUN-BC0106 --END--

      IF g_success = 'N' THEN
        ROLLBACK WORK
        RETURN
      ELSE
       #CALL i100_list_fill()      	#FUN-C90107 mark
        CALL i100sub_list_fill()        #FUN-C90107 add
        COMMIT WORK
      END IF
     #FUN-9A0056 add end ----------------------
      #CALL i100_list_fill()       #No.FUN-7C0010   #FUN-9A0056 mark
      #COMMIT WORK                 #FUN-690060 add  #FUN-9A0056 mark             
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
DEFINE l_imd10   LIKE imd_file.imd10   #FUN-CB0052
   IF cl_null(g_ima.ima35) THEN
      RETURN TRUE
   END IF
   #FUN-CB0052--add--str--
   SELECT imd10 INTO l_imd10 FROM imd_file
    WHERE imd01 = g_ima.ima35 AND imdacti='Y'
   IF l_imd10 MATCHES '[Ii]' THEN
      CALL cl_err(l_imd10,'axm-693',0)
      RETURN FALSE
   END IF
   #FUN-CB0052--add--end--
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
     #MOD-B20100---add---start---
      IF g_sma.sma03='Y' THEN
         IF NOT s_actchk3(g_ima.ima39,g_aza.aza81) THEN  
             CALL cl_err(g_ima.ima39,'mfg0018',1)
             RETURN FALSE
         ELSE
     #MOD-B20100---add---end---
            RETURN TRUE
         END IF      #MOD-B20100 add
      ELSE           #TQC-B30013 add
         RETURN TRUE #TQC-B30013 add
      END IF         #MOD-B20100 add
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
         CALL cl_err(g_ima.ima391,"anm-001",0)   #FUN-B10049
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

#FUN-C80094--ADD--STR
FUNCTION i100_chk_ima163()
   IF cl_null(g_ima.ima163) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima163,"' ",
             "  AND aag07 <> '1'",
             "  AND aag00 = '",g_aza.aza81,"'"
    IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err(g_ima.ima163,"anm-001",0)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima163
         LET g_errary[g_cnt].field="ima163"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
FUNCTION i100_chk_ima1631()
   IF cl_null(g_ima.ima1631) THEN
      RETURN TRUE
   END IF
   IF g_aza.aza63 ='N' THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima1631,"' ",
             "  AND aag07 <> '1'",
             "  AND aag00 = '",g_aza.aza82,"'"
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err(g_ima.ima1631,"anm-001",0)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima1631
         LET g_errary[g_cnt].field="ima1631"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
#FUN-C80094--ADD--END 

#FUN-D60083--add--str--
FUNCTION i100_chk_ima164()
   IF cl_null(g_ima.ima164) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima164,"' ",
             "  AND aag07 <> '1'",
             "  AND aag00 = '",g_aza.aza81,"'"
    IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err(g_ima.ima164,"anm-001",0)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima164
         LET g_errary[g_cnt].field="ima164"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

FUNCTION i100_chk_ima1641()
   IF cl_null(g_ima.ima1641) THEN
      RETURN TRUE
   END IF
   IF g_aza.aza63 ='N' THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima1641,"' ",
             "  AND aag07 <> '1'",
             "  AND aag00 = '",g_aza.aza82,"'"
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err(g_ima.ima1641,"anm-001",0)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima1641
         LET g_errary[g_cnt].field="ima1641"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
#FUN-D60083--add--end--


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
              "WHERE ecu01='",g_ima.ima571,"' ",
              "  AND ecuacti = 'Y' "  #CHI-C90006
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
         #CALL cl_err(g_ima.ima132,"anm-001",1)   #FUN-B10049
         CALL cl_err(g_ima.ima132,"anm-001",0)   #FUN-B10049
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
        UPDATE ima_file SET ima43 = l_new,
                            imadate = g_today              #FUN-C30315 add
         WHERE ima43 = l_old
      WHEN "2" #倉管員(ima23)
        UPDATE ima_file SET ima23 = l_new,
	                    imadate = g_today              #FUN-C30315 add
         WHERE ima23 = l_old
      WHEN "3" #計劃員(ima67)
        UPDATE ima_file SET ima67 = l_new,
                            imadate = g_today              #FUN-C30315 add
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
   DEFINE l_ima120 LIKE ima_file.ima120         #FUN-A90049 add
 
   IF NOT cl_null(g_ima.ima01) THEN
      IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
        (p_cmd = "u" AND g_ima.ima01 != g_ima01_t) THEN
          SELECT COUNT(*) INTO l_cnt FROM ima_file
              WHERE ima01 = g_ima.ima01
          IF l_cnt > 0 THEN                  # Duplicated
              #FUN-A90049 -----------------add start--------------------------------
              SELECT ima120 INTO l_ima120 FROM ima_file WHERE ima01 = g_ima.ima01         
              IF l_ima120 = '1' THEN
                 CALL cl_err(g_ima.ima01,'aim-023',0) 
              ELSE
                 IF l_ima120 = '2' THEN
                    CALL cl_err(g_ima.ima120,'aim-024',0)
                 END IF 
              END IF 
              #FUN-A90049 -----------------add end-----------------------------
            # CALL cl_err(g_ima.ima01,-239,0)                  #FUN-A90049 mark
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
          #FUN-B70057 add
          IF g_ima.ima01[1,1] = ' ' THEN
             CALL cl_err(g_ima.ima01,"aim-671",0)
             LET g_ima.ima01 = g_ima01_t
             DISPLAY BY NAME g_ima.ima01
             RETURN FALSE
          END IF
          #FUN-B70057 add--end
      END IF
      #IF cl_null(g_ima.ima571)  THEN    #No.MOD-790164 add          #TQC-C70189 mark
      IF cl_null(g_ima.ima571) OR g_ima01_t1 = g_ima.ima571 THEN  #TQC-C70189 add
         LET g_ima.ima571 = g_ima.ima01
         LET g_ima01_t1 = g_ima.ima01                             #TQC-C70189 add
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
          LET g_ima.ima24='N'               #FUN-B40078 
          DISPLAY BY NAME g_ima.ima08
#FUN-B40078 --begin--                         
                         ,g_ima.ima24
          CALL cl_set_comp_entry("ima24",FALSE)             
      ELSE
#      	  LET g_ima.ima24 = ''           #TQC-B50017
      	  DISPLAY BY NAME g_ima.ima24
      	  CALL cl_set_comp_entry("ima24",TRUE)     
#FUN-B40078 --end--      	  
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
 
      #IF g_ima.ima08 NOT MATCHES "[CTDAMPXKUVZS]"   #MOD-B40151
      IF g_ima.ima08 NOT MATCHES "[CTDAMPXKUVRZS]"   #MOD-B40151
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
      IF g_ima.ima08 NOT MATCHES "[MTS]" THEN #NO:6872  #FUN-B20061
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
 #FUN-D40103--mark--str--
 #   IF g_ima.ima36 !=' ' AND g_ima.ima36 IS NOT NULL THEN
 #      SELECT * FROM ime_file WHERE ime01=g_ima.ima35
 #         AND ime02=g_ima.ima36
 #      IF SQLCA.SQLCODE THEN
 #         CALL cl_err3("sel","ime_file",g_ima.ima36,"","mfg1101",
 #                      "","",1)  #No.FUN-660156
 #         RETURN FALSE
 #      END IF
 #   END IF
 #FUN-D40103--mark--end-- 
   #FUN-D40103--add--str--
   IF NOT s_imechk(g_ima.ima35,g_ima.ima36) THEN 
      RETURN FALSE
   END IF 
   #FUN-D40103--add--end--
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
   DEFINE l_newno1 LIKE ima_file.ima01     #MOD-B40111 add
   DEFINE l_ima02 LIKE ima_file.ima02      #MOD-B40111 add
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_ima120  LIKE ima_file.ima120            #FUN-A90049 
 
   #MOD-B60152---modify---start---
   #IF s_shut(0) THEN RETURN END IF
    IF s_shut(0) THEN 
       RETURN FALSE,NULL,NULL 
    END IF
   #MOD-B60152---modify---end---
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN FALSE,NULL,NULL       #MOD-B60152 add NULL
    END IF
 
    LET g_before_input_done = FALSE
    CALL i100_set_entry('a')
    LET g_before_input_done = TRUE
 
   #MOD-B40111---add---start---
    IF g_aza.aza28 = 'Y' THEN
       CALL s_auno(g_ima.ima01,'1','') RETURNING l_newno1,l_ima02    
    END IF
   #MOD-B40111---add---end--

    INPUT l_newno FROM ima01
      BEFORE FIELD ima01
          IF g_sma.sma60 = 'Y' THEN      # 若須分段輸入
             CALL s_inp5(6,14,l_newno) RETURNING l_newno
             DISPLAY l_newno TO ima01
          END IF
          IF NOT cl_null(l_newno1) THEN LET l_newno = l_newno1 END IF   #MOD-B40111 add
 
      AFTER FIELD ima01
          IF l_newno IS NULL THEN
              NEXT FIELD ima01
          END IF
          SELECT count(*) INTO g_cnt FROM ima_file
              WHERE ima01 = l_newno
          IF g_cnt > 0 THEN
             #FUN-A90049 ------------------add start----------------------------------
              SELECT ima120 INTO l_ima120 FROM ima_file WHERE ima01 = l_newno
              IF l_ima120  = '1' THEN
                 CALL cl_err(l_newno,'aim-023',0) 
              ELSE
                 IF l_ima120 = '2' THEN
                    CALL cl_err(l_newno,'aim-024',0) 
                 END IF 
              END IF 
             #FUN-A90049 -----------------add end----------------------------------------    
             #CALL cl_err(l_newno,-239,0)                         #FUN-A90049 mark
              NEXT FIELD ima01
          END IF

          #FUN-B70057 add
          IF l_newno[1,1] = ' ' THEN
             CALL cl_err(l_newno,"aim-671",0)
             NEXT FIELD ima01
          END IF
          #FUN-B70057 add--end

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
              LET g_ima.ima24='N'         #FUN-B40078               
              DISPLAY BY NAME g_ima.ima08
#FUN-B40078 --begin--              
                             ,g_ima.ima24
              CALL cl_set_comp_entry("ima24",FALSE)
          ELSE 
              CALL cl_set_comp_entry("ima24",TRUE)
              LET g_ima.ima24 ='N'              #TQC-B50017 ''->'N'
              DISPLAY BY NAME g_ima.ima24          	                     
#FUN-B40078 --end--                             
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
       #CALL cl_set_comp_entry("ima02,ima021,ima13",FALSE)  #TQC-A60015 #MOD-B50026 mark
        CALL cl_set_comp_entry("ima13",FALSE)                           #MOD-B50026 add 
        CALL cl_set_comp_entry("ima25,ima910,ima55,ima9021",FALSE)  #TQC-A60015
        DISPLAY BY NAME g_ima.ima01
        RETURN FALSE,NULL,NULL       #MOD-B60152 add NULL
    END IF
   #No.B018 010322 by plum 增加再次詢問的確定,以免不必要的新增
    IF NOT cl_confirm('mfg-003') THEN
       #CALL cl_set_comp_entry("ima02,ima021,ima13",FALSE)  #TQC-A60015   #MOD-B50026 mark
        CALL cl_set_comp_entry("ima13",FALSE)                             #MOD-B50026 add 
        CALL cl_set_comp_entry("ima25,ima910,ima55,ima9021",FALSE)  #TQC-A60015
       RETURN FALSE,NULL,NULL       #MOD-B60152 add NULL
    END IF
   #MESSAGE '新增料件基本資料中....!'
    CALL cl_err('','aim-993','0')
    IF cl_null(l_ima02) THEN LET l_ima02 = g_ima.ima02 END IF   #MOD-B60152 add
    RETURN TRUE,l_newno,l_ima02     #MOD-B40111 add l_ima02
END FUNCTION
 
#FUNCTION i100_copy_default(l_newno)            #MOD-B40111 mark
FUNCTION i100_copy_default(l_newno,l_ima02)     #MOD-B40111 add
   DEFINE l_ima RECORD LIKE ima_file.*
   DEFINE c_ima RECORD LIKE ima_file.*          #MOD-B90017 add
   DEFINE l_newno LIKE ima_file.ima01
   DEFINE l_ima02 LIKE ima_file.ima02     #MOD-B40111 add

   SELECT * INTO c_ima.* FROM ima_file WHERE ima01 = g_ima.ima01     #MOD-B90017 add
   
   #No.B018 010322 by plum 將漏掉的補入,參考i100_default
    #LET l_ima.* = g_ima.*      #MOD-B90017 mark 
    LET l_ima.* = c_ima.*       #MOD-B90017 add
    LET l_ima.ima01  =l_newno   #資料鍵值
    LET l_ima.ima02  =l_ima02                 #MOD-B40111 add
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
   DEFINE l_imac  RECORD LIKE imac_file.*      #No.TQC-C20275 add
   DEFINE l_cnt   LIKE type_file.num5  #FUN-C50110
   DEFINE l_imaicd RECORD LIKE imaicd_file.*  #FUN-810038
    BEGIN WORK
    
    IF cl_null(g_ima.ima601) THEN
       LET l_ima.ima601 = '1'      #FUN-860111
    ELSE
       LET l_ima.ima601 = g_ima.ima601
    END IF
    #MOD-D30081---begin
    IF l_ima.ima01[1,4]='MISC' THEN
       LET l_ima.ima130='2'
    END IF
    #MOD-D30081---end
    LET l_ima.ima154 = 'N'      #FUN-870100 ADD
    LET l_ima.ima155 = 'N'      #FUN-870100 ADD 
    LET l_ima.ima571 = l_newno  #TQC-9A0185    
    LET l_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
    LET l_ima.ima120 = '1'          #No.FUN-A90049 add
#FUN-A20037 --begin--
    IF cl_null(g_ima.ima022) THEN
       LET g_ima.ima022 = 0
    END IF
#FUN-A20037 --end--
    IF cl_null(l_ima.ima156) THEN LET l_ima.ima156 ='N' END IF  #FUN-A80102
    IF cl_null(l_ima.ima157) THEN LET l_ima.ima157 =' ' END IF  #FUN-A80102
    IF cl_null(l_ima.ima158) THEN LET l_ima.ima158 ='N' END IF  #FUN-A80102
    LET l_ima.ima927='N'   #No:FUN-AA0014
    IF cl_null(l_ima.ima912) THEN LET l_ima.ima912 = 0 END IF   #TQC-B20161
    IF cl_null(l_ima.ima159) THEN LET l_ima.ima159 = '3' END IF #FUN-B90035
    IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF #TQC-C20131  add
   #TQC-C20278--add--begin
    IF cl_null(l_ima.ima918) THEN LET l_ima.ima918 = 'N' END IF
    IF cl_null(l_ima.ima919) THEN LET l_ima.ima919 = 'N' END IF
    IF cl_null(l_ima.ima921) THEN LET l_ima.ima921 = 'N' END IF
    IF cl_null(l_ima.ima922) THEN LET l_ima.ima922 = 'N' END IF
    IF cl_null(l_ima.ima924) THEN LET l_ima.ima924 = 'N' END IF
   #TQC-C20278--add--end
    IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
    INSERT INTO ima_file VALUES (l_ima.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err(l_ima.ima01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN FALSE
    ELSE
#TQC-C20275 ----- add ----- begin
      DECLARE imac_cur CURSOR FOR
       SELECT * FROM imac_file WHERE imac01=g_ima.ima01
       FOREACH imac_cur INTO l_imac.*
           LET l_imac.imac01 = l_newno
           INSERT INTO imac_file VALUES(l_imac.*)
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","imac_file",l_imac.imac01,"",SQLCA.sqlcode,"","",1)  
              ROLLBACK WORK
              RETURN FALSE
           ELSE
              MESSAGE 'INSERT imac...'
           END IF
       END FOREACH
#TQC-C20275 ----- add ----- end
       SELECT * INTO l_imaicd.* 
         FROM imaicd_file
        WHERE imaicd00 = g_ima.ima01
       LET l_imaicd.imaicd00 = l_newno
       LET l_imaicd.imaicd11 = '' #TQC-C60001
       IF NOT s_ins_imaicd(l_imaicd.*,'') THEN
          ROLLBACK WORK
          RETURN FALSE
       END IF

      #FUN-C50110
      IF l_imaicd.imaicd04 = '0' OR l_imaicd.imaicd04 = '1' OR l_imaicd.imaicd04 = '2' THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM icb_file
          WHERE icb01 = l_newno
         IF l_cnt = 0 THEN
            INSERT INTO icb_file(icb01,icb05) VALUES (l_newno,l_imaicd.imaicd14)
            IF SQLCA.SQLCODE THEN 
               CALL cl_err(l_newno,SQLCA.SQLCODE,0)
            END IF 
         ELSE
            UPDATE icb_file SET icb05 = l_imaicd.imaicd14
               WHERE icb01 = l_newno
            IF SQLCA.SQLCODE THEN 
               CALL cl_err(l_newno,SQLCA.SQLCODE,0)
            END IF 
         END IF  
      ELSE  
         UPDATE icb_file SET icb05 = l_imaicd.imaicd14
            WHERE icb01 = l_newno
         IF SQLCA.SQLCODE THEN 
            CALL cl_err(l_newno,SQLCA.SQLCODE,0)
         END IF 
      END IF 
      #FUN-C50110
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
   #FUN-C30027---begin
   #SELECT ima_file.* INTO g_ima.* FROM ima_file
   #               WHERE ima01 = l_oldno
   #SELECT * INTO g_imaicd.*
   #  FROM imaicd_file
   # WHERE imaicd00 = l_oldno
   #FUN-C30027---end
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
#MOD-C30551 ----- add ----- begin
   IF g_ima.ima929 = g_ima.ima01 THEN
      CALL cl_err('','aim1154',1)
      RETURN "ima929"
   END IF
#MOD-C30551 ----- add ----- end
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
DEFINE l_imzicd79   LIKE imz_file.imzicd79  #FUN-980063
DEFINE l_cnt        LIKE type_file.num5     #FUN-C50110

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
   LET g_ima.ima927 = 'N'          #No.FUN-A90049 add 
#FUN-A20037 --begin--
   IF cl_null(g_ima.ima022) THEN
     LET g_ima.ima022 = 0 
   END IF 
#FUN-A20037 --end--
   IF cl_null(g_ima.ima156) THEN LET g_ima.ima156 ='N' END IF  #FUN-A80102
   IF cl_null(g_ima.ima157) THEN LET g_ima.ima157 =' ' END IF  #FUN-A80102
   IF cl_null(g_ima.ima158) THEN LET g_ima.ima158 ='N' END IF  #FUN-A80102
   LET g_ima.ima927='N'   #No:FUN-AA0014
   LET g_ima.ima120='1'   #No:TQC-AA0117
   IF cl_null(g_ima.ima912) THEN LET g_ima.ima912 = 0 END IF   #TQC-B20161
   IF cl_null(g_ima.ima159) THEN LET g_ima.ima159 = '3' END IF #FUN-B90035
   #TQC-C20278--add--begin
   IF cl_null(g_ima.ima918) THEN LET g_ima.ima918 = 'N' END IF
   IF cl_null(g_ima.ima919) THEN LET g_ima.ima919 = 'N' END IF
   IF cl_null(g_ima.ima921) THEN LET g_ima.ima921 = 'N' END IF
   IF cl_null(g_ima.ima922) THEN LET g_ima.ima922 = 'N' END IF
   IF cl_null(g_ima.ima924) THEN LET g_ima.ima924 = 'N' END IF
   #TQC-C20278--add--end
   IF cl_null(g_ima.ima160) THEN LET g_ima.ima160 = 'N' END IF      #FUN-C50036  add
   INSERT INTO ima_file VALUES(g_ima.*)       # DISK WRITE
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ima_file",g_ima.ima01,"",SQLCA.sqlcode,
                   "","",1)  #No.FUN-660156
      RETURN FALSE
   ELSE
      IF cl_null(g_imaicd.imaicd00) THEN
         LET g_imaicd.imaicd00=g_ima.ima01
      END IF
      IF NOT s_ins_imaicd(g_imaicd.*,'') THEN
         RETURN FALSE
      END IF
      SELECT imzicd79 INTO l_imzicd79 FROM imz_file
       WHERE imz01 = g_ima.ima06
      IF NOT cl_null(l_imzicd79) THEN
         CALL s_icd_ins_icb(g_ima.ima01,l_imzicd79)
      END IF
      #FUN-BA0054 --START--
      IF NOT cl_null(g_imaicd.imaicd04) AND g_imaicd.imaicd04 <> '9' THEN
         CALL i100_ins_smd() 
      END IF  
      #FUN-BA0054 --END--
      #FUN-C50110
      IF g_imaicd.imaicd04 = '0' OR g_imaicd.imaicd04 = '1' OR g_imaicd.imaicd04 = '2' THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM icb_file
          WHERE icb01 = g_ima.ima01
         IF l_cnt = 0 THEN
            INSERT INTO icb_file(icb01,icb05) VALUES (g_ima.ima01,g_imaicd.imaicd14)
            IF SQLCA.SQLCODE THEN 
               CALL cl_err(g_ima.ima01,SQLCA.SQLCODE,0)
            END IF 
         ELSE
            UPDATE icb_file SET icb05 = g_imaicd.imaicd14
               WHERE icb01 = g_ima.ima01
            IF SQLCA.SQLCODE THEN 
               CALL cl_err(g_ima.ima01,SQLCA.SQLCODE,0)
            END IF 
         END IF  
      ELSE  
      #FUN-C50110
         #MOD-C30288---begin
         UPDATE icb_file SET icb05 = g_imaicd.imaicd14
            WHERE icb01 = g_ima.ima01
         IF SQLCA.SQLCODE THEN 
            CALL cl_err(g_ima.ima01,SQLCA.SQLCODE,0)
         END IF 
         #MOD-C30288---end
      END IF #FUN-C50110
      LET g_ima_t.* = g_ima.*                # 保存上筆資料
      LET g_ima01_t1 = g_ima.ima01           #TQC-C70189 add
      LET g_imaicd_t.* = g_imaicd.*                # 保存上筆資料
 
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
   DEFINE l_n    LIKE type_file.num5 #No.FUN-A50011
   DEFINE l_cnt  LIKE type_file.num5  #FUN-C50110
 
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
   IF cl_null(g_ima.ima35) THEN LET g_ima.ima35 = ' ' END IF   #MOD-A90173 add
   IF cl_null(g_ima.ima36) THEN LET g_ima.ima36 = ' ' END IF   #MOD-A90173 add
   IF cl_null(g_ima01_t) THEN  #FUN-AC0072
      UPDATE ima_file SET ima_file.* = g_ima.*   # 更新DB
       WHERE ima01 = g_ima.ima01             # COLAUTH?
   #FUN-AC0072--begin--add----
   ELSE
      UPDATE ima_file SET ima_file.* = g_ima.*   # 更新DB
       WHERE ima01 = g_ima01_t             # COLAUTH?
   END IF
   #FUN-AC0072--end--add-------
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
      RETURN FALSE
   ELSE
      IF cl_null(g_ima01_t) THEN
         UPDATE imaicd_file SET imaicd_file.* = g_imaicd.*    # 更新DB
             WHERE imaicd00=g_ima.ima01
         #FUN-C50110
         IF g_imaicd.imaicd04 = '0' OR g_imaicd.imaicd04 = '1' OR g_imaicd.imaicd04 = '2' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM icb_file
             WHERE icb01 = g_ima.ima01
            IF l_cnt = 0 THEN
               INSERT INTO icb_file(icb01,icb05) VALUES (g_ima.ima01,g_imaicd.imaicd14)
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err(g_ima.ima01,SQLCA.SQLCODE,0)
               END IF 
            ELSE
               UPDATE icb_file SET icb05 = g_imaicd.imaicd14
                  WHERE icb01 = g_ima.ima01
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err(g_ima.ima01,SQLCA.SQLCODE,0)
               END IF 
            END IF  
         ELSE  
         #FUN-C50110
            #MOD-C30288---begin
            UPDATE icb_file SET icb05 = g_imaicd.imaicd14
              WHERE icb01 = g_ima.ima01
            IF SQLCA.SQLCODE THEN 
                CALL cl_err(g_ima.ima01,SQLCA.SQLCODE,0)
            END IF 
            #MOD-C30288---end    
         END IF  #FUN-C50110     
      ELSE
         LET g_imaicd.imaicd00=g_ima.ima01
         UPDATE imaicd_file SET imaicd_file.* = g_imaicd.*    # 更新DB
             WHERE imaicd00=g_ima01_t
         #FUN-C50110
         IF g_imaicd.imaicd04 = '0' OR g_imaicd.imaicd04 = '1' OR g_imaicd.imaicd04 = '2' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM icb_file
             WHERE icb01 = g_ima.ima01
            IF l_cnt = 0 THEN
               INSERT INTO icb_file(icb01,icb05) VALUES (g_ima.ima01,g_imaicd.imaicd14)
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err(g_ima.ima01,SQLCA.SQLCODE,0)
               END IF 
            ELSE
               UPDATE icb_file SET icb05 = g_imaicd.imaicd14
                  WHERE icb01 = g_ima.ima01
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err(g_ima.ima01,SQLCA.SQLCODE,0)
               END IF 
            END IF  
         ELSE  
         #FUN-C50110
            #MOD-C30288---begin
            UPDATE icb_file SET icb05 = g_imaicd.imaicd14
              WHERE icb01 = g_ima01_t
            IF SQLCA.SQLCODE THEN 
                CALL cl_err(g_ima01_t,SQLCA.SQLCODE,0)
            END IF 
            #MOD-C30288---end   
         END IF  #FUN-C50110---end 
      END IF
      #FUN-BA0054 --START--
      IF NOT cl_null(g_imaicd.imaicd04) AND g_imaicd.imaicd04 <> '9' THEN
         CALL i100_ins_smd()
      END IF  
      #FUN-BA0054 --END--
      LET g_errno = TIME
      LET g_msg = 'Chg No:',g_ima.ima01
      LET g_u_flag='0'   #FUN-870101 add
 
      INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #No.FUN-980004 
        VALUES ('aimi100',g_user,g_today,g_errno,g_ima.ima01,g_msg,g_plant,g_legal) #MOD-940394  #No.FUN-980004 #mod by liuxqa 091020 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","azo_file","aimi100","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
         RETURN FALSE
      END IF

      LET g_success = 'Y'          #FUN-9A0056 add
 
      CASE aws_mdmdata('ima_file','update',g_ima.ima01,base.TypeInfo.create(g_ima),'CreateItemMasterData') #FUN-870166
         WHEN 0  #無與 MDM 整合
              CALL cl_msg('Update O.K')
              #LET g_u_flag='0'    #FUN-870101 add #FUN-9A0056 mark
              LET g_success = 'Y'    #FUN-9A0056 add
         WHEN 1  #呼叫 MDM 成功
              CALL cl_msg('Update O.K, Update MDM O.K')
             #LET g_u_flag='0'       #FUN-870101 add #FUN-9A0056 mark
              LET g_success = 'Y'    #FUN-9A0056 add
         WHEN 2  #呼叫 MDM 失敗
             #LET g_u_flag='1'       #FUN-870101 add #FUN-9A0056 mark
              LET g_success = 'N'    #FUN-9A0056 add
              #RETURN FALSE       #FUN-870101 mark
      END CASE
 
      IF g_action_choice <> "reproduce" THEN
         # CALL aws_spccli_base()
         # 傳入參數: (1)TABLE名稱, (2)修改資料,
         #           (3)功能選項：insert(新增),update(修改),delete(刪除)
         CASE aws_spccli_base('ima_file',base.TypeInfo.create(g_ima),'update')
            WHEN 0  #無與 SPC 整合
                 MESSAGE 'UPDATE O.K'
                 LET g_success = 'Y'    #FUN-9A0056 add
                #LET g_u_flag='0'       #FUN-870101 add  #FUN-9A0056 mark
            WHEN 1  #呼叫 SPC 成功
                 MESSAGE 'UPDATE O.K. UPDATE SPC O.K'
                 LET g_success = 'Y'    #FUN-9A0056 add
                #LET g_u_flag='0'       #FUN-870101 add  #FUN-9A0056 mark
            WHEN 2  #呼叫 SPC 失敗
                 LET g_success = 'N'    #FUN-9A0056 add
                #LET g_u_flag='1'       #FUN-870101 add  #FUN-9A0056 mark
         END CASE
 
         IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD 
           #FUN-9A0056 mark str -----
            ## CALL aws_mescli
            ## 傳入參數: (1)程式代號
            ##           (2)功能選項：insert(新增),update(修改),delete(刪除)
            ##           (3)Key
            #LET l_prog=''
            #CASE g_ima.ima08
            #   WHEN 'P' LET l_prog = 'aimi100' 
            #   WHEN 'M' LET l_prog = 'axmi121'
            #   OTHERWISE LET l_prog= ' '
            #END CASE 
            #CASE aws_mescli(l_prog,'update',g_ima.ima01)
            #   WHEN 0  #無與 MES 整合
            #        CALL cl_msg('Update O.K')
            #        LET g_u_flag='0'   
            #   WHEN 1  #呼叫 MES 成功
            #        LET g_u_flag='0'    
            #        CALL cl_msg('Update O.K, Update MES O.K')
            #   WHEN 2  #呼叫 MES 失敗
            #        LET g_u_flag='1'    
            #END CASE
           #FUN-9A0056 mark end -----

           #FUN-9A0056 add begin ---------
           #狀況=確定的資料才傳送MES
            IF g_success = 'Y' AND g_action_choice <> "reproduce" THEN
              IF g_ima.ima1010 = '1' AND g_aza.aza90 MATCHES "[Yy]" THEN
               #CALL i100_mes(g_ima.ima08,'update',g_ima.ima01) #FUN-A70106 mark
                CALL i100sub_mes(g_ima.ima08,'update',g_ima.ima01) #FUN-A70106 add
              END IF
            END IF
           #FUN-9A0056 add end -----------
         END IF #TQC-8B0011  ADD
      END IF
   END IF
   #IF g_u_flag='1' THEN RETURN FALSE ELSE RETURN TRUE END IF   #FUN-870101 add #FUN-9A0056 mark
   IF g_success = 'N' THEN RETURN FALSE ELSE RETURN TRUE END IF   #FUN-9A0056 add
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
   SELECT * INTO g_imaicd.* FROM imaicd_file            # 重讀DB,因TEMP有不被更新特性
      WHERE imaicd00 = g_ima.ima01
END FUNCTION
 
 
#FUN-C30278---begin
#輸入料件特性後,做欄位控管
#FUNCTION i100_ind_icd_chg_imaicd05(p_imaicd05)
#   DEFINE p_imaicd05 LIKE imaicd_file.imaicd05 #料件特性:1.母體料號(BODY) 2.預測料號(外編母體) 3.光罩 4.外編子體 5.生產性料號 6.原物料
#   CALL cl_set_comp_entry("imaicd01,imaicd02,imaicd03",TRUE)
#   CASE p_imaicd05
#      WHEN "1"
#         LET g_imaicd.imaicd01=g_ima.ima01
#         DISPLAY BY NAME g_imaicd.imaicd01
#         CALL cl_set_comp_entry("imaicd01",FALSE)
#      WHEN "2"
#         LET g_imaicd.imaicd02=g_ima.ima01
#         DISPLAY BY NAME g_imaicd.imaicd02
#         CALL cl_set_comp_entry("imaicd02",FALSE)
#      WHEN "4"
#         LET g_imaicd.imaicd03=g_ima.ima01
#         DISPLAY BY NAME g_imaicd.imaicd03
#         CALL cl_set_comp_entry("imaicd03",FALSE)
#   END CASE
#END FUNCTION

FUNCTION i100_ind_icd_chg_imaicd04(p_imaicd04)
   DEFINE p_imaicd04 LIKE imaicd_file.imaicd04
   CALL cl_set_comp_entry("imaicd01",TRUE)
   IF p_imaicd04 = '0' THEN
      LET g_imaicd.imaicd01=g_ima.ima01
      DISPLAY BY NAME g_imaicd.imaicd01
      CALL cl_set_comp_entry("imaicd01",FALSE)
   END IF 
END FUNCTION
#FUN-C30278---end
#當料件特性='5',帶入相關預設值
FUNCTION i100_ind_icd_set_default(p_imaicd05,p_imaicd01)
   DEFINE p_imaicd01 LIKE imaicd_file.imaicd01
   DEFINE p_imaicd05 LIKE imaicd_file.imaicd05
   DEFINE l_imaicd02 LIKE imaicd_file.imaicd02
   DEFINE l_imaicd03 LIKE imaicd_file.imaicd03
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04
   DEFINE l_imaicd06 LIKE imaicd_file.imaicd06
   DEFINE l_imaicd10 LIKE imaicd_file.imaicd10
 
   IF cl_null(p_imaicd01) OR cl_null(p_imaicd05) THEN
      RETURN
   END IF
 
   CASE p_imaicd05
      WHEN "5"
         SELECT imaicd02,imaicd03,imaicd04,imaicd06,imaicd10
           INTO l_imaicd02,l_imaicd03,l_imaicd04,l_imaicd06,l_imaicd10
           FROM imaicd_file
          WHERE imaicd00=p_imaicd01
         IF cl_null(g_imaicd.imaicd02) THEN
            LET g_imaicd.imaicd02 = l_imaicd02
         END IF
         IF cl_null(g_imaicd.imaicd03) THEN
            LET g_imaicd.imaicd03 = l_imaicd03
         END IF
         IF cl_null(g_imaicd.imaicd04) THEN
            LET g_imaicd.imaicd04 = l_imaicd04
         END IF
         #IF cl_null(g_imaicd.imaicd05) THEN  #FUN-C30278
         IF cl_null(g_imaicd.imaicd06) THEN   #FUN-C30278
            LET g_imaicd.imaicd06 = l_imaicd06
         END IF
         IF cl_null(g_imaicd.imaicd10) THEN
            LET g_imaicd.imaicd10 = l_imaicd10
         END IF
         DISPLAY BY NAME g_imaicd.imaicd02,g_imaicd.imaicd03,
                         g_imaicd.imaicd04,g_imaicd.imaicd06,
                         g_imaicd.imaicd10
      WHEN "6" #6.原物料 沒有作業群組
         LET g_imaicd.imaicd10 = NULL       #FUN-980063
         DISPLAY BY NAME g_imaicd.imaicd10  #FUN-980063
      OTHERWISE
         IF cl_null(g_imaicd.imaicd10) THEN
            SELECT imaicd10 INTO g_imaicd.imaicd10 FROM imaicd_file
                                           WHERE imaicd00=p_imaicd01
            DISPLAY BY NAME g_imaicd.imaicd10
         END IF
   END CASE
END FUNCTION
 
FUNCTION i100_ind_icd_chk_item(p_feld,p_value)
   DEFINE p_feld  LIKE gaq_file.gaq01 #欄位名稱
   DEFINE p_value LIKE ima_file.ima01 #欄位值
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04 #料件狀態 : 0. BODY  1.未測WAFER  2.已測WAFER  3.未測IC  4.已測IC  9.OTHER
   DEFINE l_imaicd05 LIKE imaicd_file.imaicd05 #料件特性 : 1.母體料號(BODY) 2.預測料號(外編母體) 3.光罩 4.外編子體 5.生產性料號 6.原物料
   DEFINE l_imaacti  LIKE ima_file.imaacti
 
   IF cl_null(p_value) THEN
      RETURN TRUE
   END IF
 
   #FUN-C30278---begin
   IF g_imaicd.imaicd04 = '0' AND p_value = g_ima.ima01 THEN
      RETURN TRUE
   END IF 
   #CASE g_imaicd.imaicd05
   #   WHEN "1"
   #      IF p_feld='imaicd01' AND p_value=g_ima.ima01 THEN
   #         RETURN TRUE
   #      END IF
   #   WHEN "2"
   #      IF p_feld='imaicd02' AND p_value=g_ima.ima01 THEN
   #         RETURN TRUE
   #      END IF
   #   WHEN "4"
   #      IF p_feld='imaicd03' AND p_value=g_ima.ima01 THEN
   #         RETURN TRUE
   #      END IF
   #END CASE
   #FUN-C30278---end
   
   
   #FUN-C30206---baegin
   IF g_imaicd.imaicd04 = '1' AND p_value = g_ima.ima01 THEN 
      RETURN TRUE
   ELSE 
   #FUN-C30206---end
      SELECT imaicd04,imaicd05,imaacti
        INTO l_imaicd04,l_imaicd05,l_imaacti
        FROM ima_file,imaicd_file
       WHERE ima01=p_value
         AND imaicd00=ima01
      CASE
         WHEN SQLCA.sqlcode<>0
            CALL cl_err3("sel","ima_file",p_value,"",100,"","",1)
         WHEN cl_null(l_imaacti) OR l_imaacti<>'Y'
            CALL cl_err3("sel","ima_file",p_value,"","apm-800","","",1)
         WHEN cl_null(l_imaicd04) OR cl_null(l_imaicd05)
            CALL cl_err(p_value,"aic-047",1)
         #WHEN l_imaicd05='6'  #FUN-C30278
         #WHEN l_imaicd04='0' OR l_imaicd04 = '1'  #FUN-C30278
         #   CALL cl_err(p_value,"aic-105",1)      #FUN-C30278
         WHEN l_imaicd04='9'
            CALL cl_err(p_value,"aic-106",1)
         #WHEN (p_feld="imaicd01") AND (l_imaicd05<>"1")  #母體料號  #FUN-C30278
         WHEN (p_feld="imaicd01") AND (l_imaicd04<>"0" AND l_imaicd04<>"1")  #母體料號   #FUN-C30278
            CALL cl_err(p_value,"aic-100",1)
         WHEN (p_feld="imaicd02") AND (l_imaicd05<>"2")  #外編母體 (預測料號)
            CALL cl_err(p_value,"aic-101",1)
         WHEN (p_feld="imaicd03") AND (l_imaicd05<>"4")  #外編子體 (客戶下單料號)
            CALL cl_err(p_value,"aic-102",1)
         WHEN (p_feld="imaicd06") AND (NOT l_imaicd04 MATCHES '[12]')  #內編子體 (Wafer料號)
            CALL cl_err(p_value,"aic-103",1)
         OTHERWISE
           RETURN TRUE
      END CASE
   END IF #FUN-C30206
   RETURN FALSE
END FUNCTION
 
FUNCTION i100_ind_icd_chk_imaicd10(p_imaicd10)
  DEFINE p_imaicd10 LIKE imaicd_file.imaicd10
  DEFINE l_icd01    LIKE icd_file.icd01
  DEFINE l_icd02    LIKE icd_file.icd02
  DEFINE l_icdacti  LIKE icd_file.icdacti
 
  IF cl_null(p_imaicd10) THEN
     RETURN TRUE
  END IF
  SELECT icd01,icd02,icdacti
    INTO l_icd01,l_icd02,l_icdacti
    FROM icd_file
   WHERE icd01=p_imaicd10
     AND icd02='U'        #No.TQC-910034 add
  CASE
     WHEN SQLCA.sqlcode<>0
        CALL cl_err3("sel","icd_file",p_imaicd10,"",100,"","",1)
     WHEN cl_null(l_icdacti) OR l_icdacti<>'Y'
        CALL cl_err3("sel","icd_file",p_imaicd10,"","apm-800","","",1)
     WHEN cl_null(l_icd02) OR l_icd02<>'U'
        CALL cl_err3("sel","icd_file",p_imaicd10,"","aic-317","","",1)
     OTHERWISE
       RETURN TRUE
  END CASE
  RETURN FALSE
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

      #No.FUN-9C0089 add begin----------------
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
      #No.FUN-9C0089 add -end----------------- 

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION data_status
         LET g_action_choice="data_status"
         EXIT DISPLAY
 
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY

#NO.FUN-B30092  ------------------------add start------------------------
      ON ACTION quantifying 
         LET g_action_choice="quantifying"
         EXIT DISPLAY
#NO.FUN-B30092 --------------------------add end------------------------
 
 
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
 
      ON ACTION icd_base_data
         LET g_action_choice="icd_base_data"
         EXIT DISPLAY
 
      ON ACTION icd_maskgroup
         LET g_action_choice="icd_maskgroup"
         EXIT DISPLAY
 
      ON ACTION icd_processitem
         LET g_action_choice="icd_processitem"
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
   DEFINE l_gew03   LIKE gew_file.gew03  #FUN-950057 
 
   IF cl_null(g_ima.ima01) THEN  #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_ima.imaacti <> 'Y' THEN
      CALL cl_err(g_ima.ima01,'aoo-090',1)
      RETURN
   END IF

#FUN-950057 --------------------add start----------------------
   SELECT ima1010 INTO g_ima.ima1010                                            
     FROM ima_file                                                              
    WHERE ima01 = g_ima.ima01                                                   
   IF g_ima.ima1010 <> '1' THEN                                                 
      CALL cl_err(g_ima.ima01,'aoo-092',3)                                      
      RETURN                                                                    
   END IF
#FUN-950057 -------------------add end-------------------------
 
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
 
#FUN-950057 ----------------------add start---------------------------
   SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file                               
    WHERE gew01 = g_gev04 AND gew02 = '1'                                       
   IF NOT cl_null(l_gew03) THEN                                                 
      IF l_gew03 = '2' THEN                                                     
          IF NOT cl_confirm('anm-929') THEN RETURN END IF  #询问是否执行抛转    
      END IF
#FUN-950057 ---------------------add end-------------------------------

   #開窗選擇拋轉的db清單
   LET l_sql = "SELECT COUNT(*) FROM &ima_file WHERE ima01='",g_ima.ima01,"'"  #TQC-A20008 #CHI-A50006 remark
  #LET l_sql = "SELECT COUNT(*) FROM ima_file WHERE ima01='",g_ima.ima01,"'"   #TQC-A20008 #CHI-A50006 mark
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
 END IF               #FUN-950057  

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
   DEFINE l_count   LIKE type_file.num5      #FUN-BC0100 
   DEFINE l_icu01   LIKE icu_file.icu01      #FUN-BC0106
   DEFINE l_icu02   LIKE icu_file.icu02      #FUN-BC0106 
   DEFINE l_str     STRING                   #FUN-C60061 
   DEFINE l_ima01   LIKE ima_file.ima01      #FUN-C60061
 
 
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
              #CALL i100_x()                #FUN-C90107 mark  #TQC-CB0079 remark   #FUN-C90107 mark
               CALL i100sub_x(g_ima.ima01)  #FUN-C90107 add    TQC-CB0079 mark     #FUN-C90107 add           
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

       #No.FUN-9C0089 add begin------------------
        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima_l),'','')
           END IF
       #No.FUN-9C0089 add -end------------------- 

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

#NO.FUN-B30092  ------------------------add start------------------------        
        WHEN "quantifying"
            LET g_msg="aooi104 '",g_ima.ima01,"'"
            CALL cl_cmdrun_wait(g_msg) 
            CALL i100_show()
#NO.FUN-B30092 --------------------------add end------------------------
 
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
               SELECT * INTO g_imaicd.*
                 FROM imaicd_file
                WHERE imaicd00=g_ima.ima01
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
               SELECT * INTO g_imaicd.*
                 FROM imaicd_file
                WHERE imaicd00=g_ima.ima01
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
               SELECT * INTO g_imaicd.*
                 FROM imaicd_file
                WHERE imaicd00=g_ima.ima01
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
              #FUN-A70106--mod---str--
              #CALL i100_confirm() #mark
               CALL i100sub_y_chk(g_ima.ima01)
               IF g_success = 'Y' THEN
                   BEGIN WORK
                     CALL i100sub_y_upd(g_ima.ima01)
                   IF g_success = 'Y' THEN
                      #FUN-BC0100---begin---
                      LET l_count = 0
                      IF NOT cl_null(g_imaicd.imaicd01) THEN
                         SELECT COUNT(1) INTO l_count FROM icf_file
                         WHERE icf01 = g_imaicd.imaicd01
                         IF l_count = 0 THEN
                            INSERT INTO icf_file(icf01,icf02,icf04,icf05)
                            VALUES(g_imaicd.imaicd01,'BIN01','Y','0')
                         END IF
                      END IF
                      LET l_count = 0
                      IF NOT cl_null(g_imaicd.imaicd16) THEN
                         SELECT COUNT(1) INTO l_count FROM icf_file
                         WHERE icf01 = g_imaicd.imaicd16
                         IF l_count = 0 THEN
                            INSERT INTO icf_file(icf01,icf02,icf04,icf05)
                            VALUES(g_imaicd.imaicd16,'BIN01','Y','0')
                         END IF
                      END IF
                      #FUN-BC0106 --START--
                      LET l_count = 0
                      IF NOT cl_null(g_imaicd.imaicd01) THEN
                         SELECT icu01,icu02 INTO l_icu01,l_icu02 
                          FROM icu_file WHERE icu01 = g_imaicd.imaicd01
                           AND icu02 = g_ima.ima94
                         IF SQLCA.sqlcode = 0 THEN
                            CALL s_aic_bom_ins(l_icu01,l_icu02,'',g_ima.ima01)
                            #FUN-C60061---begin
                            LET l_str = NULL
                            DECLARE ima01_c2 CURSOR FOR SELECT imaicd00
                                                            FROM imaicd_file
                                                           WHERE imaicd11 = g_ima.ima01
                            FOREACH ima01_c2 INTO l_ima01
                               IF cl_null(l_str) THEN
                                  LET l_str = l_ima01
                               ELSE
                                  LET l_str = l_str,',',l_ima01
                               END IF 
                            END FOREACH 
                            IF NOT cl_null(l_str) THEN 
                               CALL cl_err(l_str,'aim-168',1)
                            END IF 
                            #FUN-C60061---end
                         END IF 
                      END IF  
                      #FUN-BC0106 --END--                      
                      #FUN-BC0100---end---
                      #CALL i100_list_fill()     #FUN-C90107 mark
                       CALL i100sub_list_fill()  #FUN-C90107 add
                       COMMIT WORK
                       CALL i100sub_refresh(g_ima.ima01) RETURNING g_ima.*
                       CALL i100sub_carry(g_ima.ima01)
                   ELSE
                       ROLLBACK WORK
                   END IF
               END IF
              #FUN-A70106--mod---end--
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
 
        WHEN "icd_base_data"
            IF NOT cl_null(g_ima.ima01) THEN
               IF cl_chk_act_auth() THEN                                                                 #MOD-C30288
                  LET g_msg="aici001 '",g_ima.ima01,"'"       #MOD-C30288    #FUN-C50110
                  #LET g_msg="aici001 '",g_imaicd.imaicd01,"'"  #MOD-C30288  #FUN-C50110                                                                #MOD-C30288                  
                  CALL cl_cmdrun_wait(g_msg)
               END IF
            END IF
 
        WHEN "icd_maskgroup"
            IF NOT cl_null(g_ima.ima01) THEN
               IF cl_chk_act_auth() THEN
                 SELECT icb02 INTO g_icb02 FROM icb_file,imaicd_file         #No.FUN-920114
                   WHERE imaicd00 = g_ima.ima01 AND icb01 = imaicd01         #No.FUN-920114
                   LET g_msg="aici004 '", g_icb02,"'"               #No.FUN-920114
                  CALL cl_cmdrun_wait(g_msg)
               END IF
            END IF
 
        WHEN "icd_processitem"
            IF NOT cl_null(g_ima.ima01) THEN
               IF cl_chk_act_auth() THEN
                  #TQC-C30137---begin      
                  #IF cl_null(g_ima.ima94) THEN              #MOD-C30233 mark
                  #   CALL cl_err('g_ima.ima94','aim-041',1) #MOD-C30233 mark
                  #ELSE                                      #MOD-C30233 mark
                  #TQC-C30137---end  
                  SELECT imaicd01 INTO g_imaicd.imaicd01 FROM imaicd_file    #No.FUN-920114
                      WHERE imaicd00 = g_ima.ima01                           #No.FUN-920114
                      #LET g_msg="aici020 '",g_imaicd.imaicd01,"'"              #No.FUN-920114  #MOD-B30519
                  LET g_msg="aici020 '",g_imaicd.imaicd01,"' ''"           #MOD-B30519
                  CALL cl_cmdrun_wait(g_msg)
                  #END IF #TQC-C30137                        #MOD-C30233 mark
               END IF
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
         #CALL cl_err(g_ima.ima149,"anm-001",1)  #FUN-B10049
         CALL cl_err(g_ima.ima149,"anm-001",0)  #FUN-B10049
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
         CALL cl_err(g_ima.ima1491,"anm-001",0)   #FUN-B10049
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

#FUN-A90049 -----------------------------add start-----------------------
FUNCTION i100_assign_product_strategy()
   DEFINE ls_token    LIKE type_file.chr1000
   DEFINE l_serial    LIKE type_file.num5
   DEFINE l_flag      LIKE type_file.chr1
   DEFINE lst_token   base.StringTokenizer
   DEFINE l_rtd01     LIKE rtd_file.rtd01        #FUN-AB0011
   DEFINE l_rte04     LIKE rte_file.rte04        #FUN-AB0011
   DEFINE l_rte05     LIKE rte_file.rte05        #FUN-AB0011
   DEFINE l_rte06     LIKE rte_file.rte06        #FUN-AB0011
   DEFINE l_rte08     LIKE rte_file.rte08        #FUN-AB0011
   DEFINE l_gec02     LIKE gec_file.gec02,       #FUN-AB0011
          l_gecacti   LIKE gec_file.gecacti      #FUN-AB0011
 
     IF cl_null(g_ima.ima01) THEN
        CALL cl_err('',-400,0)
        RETURN
     END IF
#FUN-AB0011 -----------------add start---------------------
     IF g_ima.ima1010 != '1' THEN
        CALL cl_err('','aim-689',0)
        RETURN
     END IF
   
     LET l_rte04= 'Y'
     LET l_rte05 = 'Y'
     LET l_rte06 = 'Y'
     LET g_success = 'Y'
     LET l_flag = TRUE
     OPEN WINDOW show_w1 AT 8,15 WITH FORM "aim/42f/saimi100"
      ATTRIBUTE (STYLE = g_win_style)

     CALL cl_ui_init()    
     DISPLAY l_rte04 TO FORMONLY.rte04
     DISPLAY l_rte05 TO FORMONLY.rte05
     DISPLAY l_rte06 TO FORMONLY.rte06

     WHILE TRUE
        CONSTRUCT BY NAME g_wc ON rtd01
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about        
            CALL cl_about() 

         ON ACTION help         
            CALL cl_show_help() 

         ON ACTION controlg    
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(rtd01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_rtd01_2"
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.where    = " rtd01 NOT IN( SELECT rte01 FROM rte_file WHERE rte03 = '",  g_ima.ima01,"' )"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO rtd01
                 NEXT FIELD rtd01
           END CASE 
        END CONSTRUCT
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CLOSE WINDOW show_w1
           RETURN
        END IF
        IF cl_null(g_wc) OR g_wc = " 1=1" THEN
           CONTINUE WHILE 
        END IF
     EXIT WHILE
     END WHILE

     INPUT l_rte08,l_rte04,l_rte05,l_rte06 WITHOUT DEFAULTS FROM rte08,rte04,rte05,rte06 
     
      BEFORE INPUT 

      AFTER FIELD rte08
         IF NOT cl_null(l_rte08) THEN
                SELECT gec02 ,gecacti INTO l_gec02,l_gecacti FROM gec_file
                 WHERE gec01 = l_rte08 AND gec011 = '2'
                CASE  WHEN SQLCA.sqlcode = 100
                         LET g_errno = 'art-931'
                      WHEN l_gecacti = 'N'
                         LET g_errno = '9028'
                      OTHERWISE
                         LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rte08
                END IF
             END IF
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about   
         CALL cl_about() 

      ON ACTION help     
         CALL cl_show_help()  

      ON ACTION controlg    
         CALL cl_cmdask()

      ON ACTION controlp
         CASE WHEN INFIELD(rte08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gec011"
                 LET g_qryparam.default1 = l_rte08
                 CALL cl_create_qry() RETURNING l_rte08
                 DISPLAY l_rte08 TO rte08
                 NEXT FIELD rte08
             OTHERWISE EXIT CASE
           END CASE

     END INPUT 
     IF INT_FLAG THEN
         LET INT_FLAG = 0
        CLOSE WINDOW show_w1
        RETURN 
     END IF 
  
     LET g_sql = "SELECT rtd01 FROM rtd_file ",
                 " WHERE rtd01 NOT IN(SELECT rte01 FROM rte_file WHERE rte03 = '",g_ima.ima01,"')",
                 " AND rtdconf = 'N' AND ",g_wc CLIPPED
     PREPARE sel_rtd01_pre FROM g_sql
     DECLARE sel_rtd01_cs CURSOR FOR sel_rtd01_pre 
     BEGIN WORK

     FOREACH sel_rtd01_cs INTO l_rtd01
        IF SQLCA.sqlcode  THEN
            LET g_success = 'N'          
            EXIT FOREACH 
        END IF
        SELECT max(rte02) INTO l_serial FROM rte_file
         WHERE rte01 = l_rtd01 
        IF cl_null(l_serial) THEN
            LET l_serial = 0
        END IF
        LET l_serial = l_serial + 1
        INSERT INTO rte_file(rte01,rte02,rte03,rte04,rte05,rte06,rte07,rtepos,rte08,rte09)
                      VALUES(l_rtd01,l_serial,g_ima.ima01,l_rte04,l_rte05,l_rte06,'Y'
                             ,'1',l_rte08,' ')  #NO.FUN-B50052 'N'
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_showmsg = l_rtd01,"/",l_serial
           CALL s_errmsg('rte01,rte02',g_showmsg,'for',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
     END FOREACH 

      IF cl_null(l_rtd01) THEN
         LET g_success = 'N'
         LET l_flag = FALSE
      END IF  
      IF g_success = 'Y' THEN
            CALL cl_err('','art-687',1)
            COMMIT WORK
      ELSE
         IF l_flag = FALSE THEN
            CALL cl_err('','art-688',1)
         ELSE
            CALL s_showmsg()
         END IF 
         ROLLBACK WORK
      END IF

     CLOSE WINDOW show_w1
     RETURN  
#FUN-AB0011 ---------------add end---------------------------------  

#FUN-AB0011 ----------------mark start-------------
#    CALL cl_init_qry_var()
#    LET g_qryparam.form     = "q_rtd01_2"
#    LET g_qryparam.state    = "c"
#    LET g_qryparam.where    = " rtd01 NOT IN( SELECT rte01 FROM rte_file WHERE rte03 = '",  g_ima.ima01,"' )"
#    CALL cl_create_qry() RETURNING g_qryparam.multiret
#    LET l_serial = 1
#    LET l_flag = TRUE
#    LET lst_token = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
#    WHILE lst_token.hasMoreTokens()
#       LET ls_token = lst_token.nextToken()
#       INSERT INTO rte_file(rte01,rte02,rte03,rte04,rte05,rte06,rte07,rtepos,rte08,rte09)
#          VALUES(ls_token,l_serial,g_ima.ima01,'Y','Y','Y','N','','')
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL cl_err3("ins","rte_file",ls_token,l_serial,SQLCA.sqlcode,"","",1)
#          LET l_flag = FALSE
#          EXIT WHILE 
#       END IF 
#     # LET l_serial = l_serial + 1
#    END WHILE
#    IF l_flag THEN
#       CALL cl_err(g_ima.ima01,'aim-025',1)
#    END IF       
#FUN-AB0011 ----------------mark end--------------------- 
END FUNCTION
#FUN-A90049 ----------------------------add end----------------------------

#FUN-BA0054 --START--
FUNCTION i100_ins_smd()
DEFINE l_cnt LIKE type_file.num10
DEFINE l_smd RECORD LIKE smd_file.*
    SELECT COUNT(smd01) INTO l_cnt FROM smd_file WHERE smd01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err('sel smd',SQLCA.sqlcode,1) 
       RETURN 
    END IF
    IF l_cnt > 0 THEN RETURN END IF
    
    LET l_smd.smd01 =  g_ima.ima01
    LET l_smd.smdacti = 'Y'          
    LET l_smd.smdpos =  '1'
    LET l_smd.smddate =  NULL
    
    CASE g_ima.ima906
       WHEN '1'   #單一單位
          LET l_smd.smd02 = g_ima.ima25
          LET l_smd.smd03 = g_ima.ima25
          LET l_smd.smd04 = 1          
          LET l_smd.smd06 = 1
          LET l_smd.smdacti = 'Y'          
          INSERT INTO smd_file VALUES (l_smd.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err("ins smd",SQLCA.sqlcode,1)
             RETURN
          END IF    
       WHEN '3'   #參考單位
          IF g_imaicd.imaicd14 = 0 OR cl_null(g_imaicd.imaicd14) THEN
             RETURN 
          END IF  
          #第一筆
          LET l_smd.smd02 = g_ima.ima25
          LET l_smd.smd03 = g_ima.ima907
          LET l_smd.smd04 = 1          
          LET l_smd.smd06 = g_imaicd.imaicd14   
          LET l_smd.smd06 = s_digqty(l_smd.smd06,l_smd.smd03)   #No.FUN-BB0086        
          INSERT INTO smd_file VALUES (l_smd.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err("ins smd",SQLCA.sqlcode,1)
             RETURN
          END IF
          #第二筆
          LET l_smd.smd02 = g_ima.ima907
          LET l_smd.smd03 = g_ima.ima25
          LET l_smd.smd04 = g_imaicd.imaicd14
          LET l_smd.smd04 = s_digqty(l_smd.smd04,l_smd.smd02)   #No.FUN-BB0086
          LET l_smd.smd06 = 1          
          INSERT INTO smd_file VALUES (l_smd.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err("ins smd",SQLCA.sqlcode,1)
             RETURN
          END IF     
    END CASE    
END FUNCTION
#FUN-BA0054 --END--

#No.FUN-9C0072 精簡程式碼
#No.FUN-A50011 ------begin------
#No.FUN-A50011  ------ end -----

#FUN-9A0056 -- add i100_mes() for MES------------
#FUN-A70106----mark---str----
#FUNCTION i100_mes(p_key1,p_key2,p_key3)
# DEFINE p_key1   LIKE type_file.chr1
# DEFINE p_key2   LIKE type_file.chr6
# DEFINE p_key3   LIKE type_file.chr500
# DEFINE l_prog   LIKE type_file.chr7
# DEFINE l_mesg01 LIKE type_file.chr30
#
# LET l_prog = ''
# CASE p_key1
#   WHEN 'P' LET l_prog = 'aimi100'
#   WHEN 'V' LET l_prog = 'aimi100'
#   WHEN 'Z' LET l_prog = ' '
#   OTHERWISE LET l_prog= 'axmi121'
# END CASE
#
# CASE p_key2
#    WHEN 'insert'  #新增
#         LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
#    WHEN 'update'  #修改
#         LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
#    WHEN 'delete'  #刪除
#         LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
#    OTHERWISE
# END CASE
#
## CALL aws_mescli
## 傳入參數: (1)程式代號
##           (2)功能選項：insert(新增),update(修改),delete(刪除)
##           (3)Key
# CASE aws_mescli(l_prog,p_key2,p_key3)
#    WHEN 1  #呼叫 MES 成功
#         MESSAGE l_mesg01
#         LET g_success = 'Y'
#    WHEN 2  #呼叫 MES 失敗
#         LET g_success = 'N'
#    OTHERWISE  #其他異常
#         LET g_success = 'N'
# END CASE
#
#END FUNCTION
#FUN-A70106----mark---end----
#FUN-9A0056 add end ------------------------
#FUN-B90103----------add------begin----------------

#FUN-B90103------------end-------------------------
#FUN-B50046
#FUN-BB0083---add---str
FUNCTION i100_ima27_check()
#ima27 的單位 ima25
   IF NOT cl_null(g_ima.ima25) AND NOT cl_null(g_ima.ima27) THEN
      IF cl_null(g_ima_t.ima27) OR cl_null(g_ima25_t) OR g_ima_t.ima27 != g_ima.ima27 OR g_ima25_t != g_ima.ima25 THEN 
         LET g_ima.ima27=s_digqty(g_ima.ima27, g_ima.ima25)
         DISPLAY BY NAME g_ima.ima27  
      END IF  
   END IF
   IF g_ima.ima27 IS NOT NULL THEN
      IF g_ima.ima27 <0 THEN
         CALL cl_err('','mfg4012',0)
         RETURN FALSE
      END IF
   END IF 
RETURN TRUE
END FUNCTION

FUNCTION i100_ima271_check()
#ima271 的單位 ima25
   IF NOT cl_null(g_ima.ima25) AND NOT cl_null(g_ima.ima271) THEN
      IF cl_null(g_ima_t.ima271) OR cl_null(g_ima25_t) OR g_ima_t.ima271 != g_ima.ima271 OR g_ima25_t != g_ima.ima25 THEN 
         LET g_ima.ima271=s_digqty(g_ima.ima271, g_ima.ima25)
         DISPLAY BY NAME g_ima.ima271  
      END IF  
   END IF
   IF g_ima.ima271 IS NOT NULL THEN
      IF g_ima.ima271 <0 THEN
         CALL cl_err('','mfg4012',0)
         RETURN FALSE
      END IF
   END IF
RETURN TRUE
END FUNCTION

FUNCTION i100_ima28_check()
#ima28 的單位 ima25
   IF NOT cl_null(g_ima.ima25) AND NOT cl_null(g_ima.ima28) THEN
      IF cl_null(g_ima_t.ima28) OR cl_null(g_ima25_t) OR g_ima_t.ima28 != g_ima.ima28 OR g_ima25_t != g_ima.ima25 THEN 
         LET g_ima.ima28=s_digqty(g_ima.ima28, g_ima.ima25)
         DISPLAY BY NAME g_ima.ima28  
      END IF  
   END IF
   IF g_ima.ima28 IS NOT NULL THEN
      IF g_ima.ima28 <0 THEN
         CALL cl_err('','mfg4012',0)
         RETURN FALSE
      END IF
   END IF
RETURN TRUE
END FUNCTION

FUNCTION i100_ima51_check()
   IF NOT cl_null(g_ima.ima44) AND NOT cl_null(g_ima.ima51) THEN
      LET g_ima.ima51=s_digqty(g_ima.ima51, g_ima.ima44)
      DISPLAY BY NAME g_ima.ima51  
   END IF
   IF NOT i100_chk_ima51() THEN
      RETURN FALSE
   END IF
   LET g_ima_o.ima51 = g_ima.ima51
RETURN TRUE
END FUNCTION

FUNCTION i100_ima52_check()
   IF NOT cl_null(g_ima.ima44) AND NOT cl_null(g_ima.ima52) THEN
      LET g_ima.ima52=s_digqty(g_ima.ima52, g_ima.ima44)
      DISPLAY BY NAME g_ima.ima52  
   END IF
   IF NOT i100_chk_ima52() THEN
      RETURN FALSE
   END IF
   LET g_ima_o.ima52 = g_ima.ima52
RETURN TRUE
END FUNCTION
#FUN-BB0083---add---end

#MOD-C30270--mark--begin--
##TQC-C30186--add--begin--
#FUNCTION i100_i_ima08(p_cmd)
#  DEFINE p_cmd           LIKE type_file.chr1
#  
#  DISPLAY BY NAME g_ima.ima901,g_ima.imauser,g_ima.imagrup,
#                  g_ima.imadate,g_ima.imaacti
#                  ,g_ima.ima151           
#                  ,g_ima.ima928          
#
#  DISPLAY BY NAME g_ima.ima906,g_ima.ima907,g_ima.ima908,g_ima.ima159, 
#                  g_ima.ima1010 
#  DISPLAY BY NAME g_ima.ima916  
#  DISPLAY BY NAME g_ima.ima022 
#
#
#  IF p_cmd = 'u' THEN LET g_ima.imadate = g_today END IF
#
#  INPUT BY NAME g_ima.ima08  WITHOUT DEFAULTS
#
#       BEFORE INPUT
#           LET g_before_input_done = FALSE
#           LET g_before_input_done = TRUE
#           IF p_cmd = 'u' THEN
#              LET g_ima25_t = g_ima.ima25
#           END IF

#       BEFORE FIELD ima08
#          CALL i100_set_entry(p_cmd)
#
#       AFTER FIELD ima08  #來源碼
#          IF NOT i100_chk_ima08(p_cmd) THEN
#             NEXT FIELD CURRENT
#          END IF
#
#       AFTER INPUT  
#           IF INT_FLAG THEN
#               EXIT INPUT
#           END IF

#        ON ACTION CONTROLF
#           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
#           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#         ON ACTION about     
#            CALL cl_about()      
#
#         ON ACTION help          
#            CALL cl_show_help() 
#
#   END INPUT
#END FUNCTION
##TQC-C30186--add--end--
#MOD-C30270--mark--end--

#MOD-C30147 ----- add ----- begin
FUNCTION i100_ins_imac()
DEFINE  l_imac   RECORD LIKE imac_file.*
DEFINE  l_imzc   RECORD LIKE imzc_file.*
DEFINE  l_imz928 LIKE imz_file.imz928,
        l_imz929 LIKE imz_file.imz929

       SELECT imz928,imz929 INTO l_imz928,l_imz929 FROM imz_file
        WHERE imz01 = g_ima.ima06
       LET g_ima.ima928 = l_imz928
       LET g_ima.ima929 = l_imz929
       DELETE FROM imac_file WHERE imac01 = g_ima.ima01
       DECLARE imac_ins CURSOR FOR
             SELECT * FROM imzc_file WHERE imzc01 = g_ima.ima06
       FOREACH imac_ins INTO l_imzc.*
          IF STATUS THEN
             CALL cl_err('foreach:',STATUS,1)
             EXIT FOREACH
          END IF
          LET l_imac.imac01   = g_ima.ima01
          LET l_imac.imac02   = l_imzc.imzc02
          LET l_imac.imac03   = l_imzc.imzc03
          LET l_imac.imac04   = l_imzc.imzc04
          LET l_imac.imac05   = l_imzc.imzc05
          LET l_imac.imacuser = l_imzc.imzcuser
          LET l_imac.imacgrup = l_imzc.imzcgrup
          LET l_imac.imacoriu = l_imzc.imzcoriu
          LET l_imac.imacorig = l_imzc.imzcorig
          LET l_imac.imacmodu = l_imzc.imzcmodu
          LET l_imac.imacdate = l_imzc.imzcdate

          INSERT INTO imac_file VALUES(l_imac.*)

          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","imac_file","aimi100","",SQLCA.sqlcode,"","",1)
             EXIT FOREACH
          END IF
       END FOREACH
END FUNCTION
#MOD-C30147 ----- add ----- end

#DEV-D30036--add--begin
FUNCTION i100_chk_ghe(p_gei01)
   DEFINE p_gei01    LIKE gei_file.gei01
   DEFINE l_geh03    LIKE geh_file.geh03
   DEFINE l_geh04    LIKE geh_file.geh04

   LET g_errno = ''

   LET l_geh03 = ''
   LET l_geh04 = ''
   SELECT geh03,geh04
     INTO l_geh03,l_geh04
     FROM geh_file,gei_file
    WHERE geh01 = gei03
      AND gei01 = p_gei01
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = "aoo-112"
                               LET l_geh03 = ''
                               LET l_geh04 = ''
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(p_gei01,g_errno,0)
      RETURN
   END IF

   IF g_ima.ima930 = 'Y' THEN
      IF l_geh03 <> 'iba_file' THEN
         LET g_errno = 'aba-171'
         RETURN
      END IF
   ELSE
      IF l_geh03 = 'iba_file' THEN
         LET g_errno = 'aba-171'
         RETURN
      END IF
   END IF
   
END FUNCTION
#DEV-D30036--add--end
