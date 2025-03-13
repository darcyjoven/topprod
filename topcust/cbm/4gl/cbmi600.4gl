# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cbmi600.4gl
# Descriptions...: 產品結構資料維護作業
# Date & Author..: 91/08/01 By Wu
# Modify         : 92/05/04 By David
# Modify.........: 92/10/22 By Apple
# 1993/01/11(Lee): 在bmb03允許按^O執行abmi650
# 1996/01/17(Roger): cbmi600_copy 整段修改
# 2001/09/17(carol): add i600_dbs() 資料庫拋轉
# Modify.........: No:7685 03/08/13 By Mandy modify的情形下, 工單展開選項(bmb19)不應在重新default
# Modify.........: No:7822 03/08/18 By Mandy資料拋轉 按^P查詢時 -> azp 的display 錯誤
# Modify.........: No:7811 03/08/22 By Mandy 新增/修改請多check if null then let=' '
# Modify.........: No:8393 03/11/10 '1.資料拋轉'時,發放日期不應拋轉過去
# Modify.........: No:9716 04/07/09 By Mandy 復制功能中,如果插件位置不復制,bmb13應該清空
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.MOD-470593 04/07/29 By ching 單身新增資料時,無法存檔
# Modify.........: No:9810 04/07/30 By ching 已phase料件應不可輸入bom單身
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0132 04/11/18 By Smapmin 將PROMPT出來的視窗改為中文
# Modify.........: No.MOD-4C0013 04/12/07 By Mandy 損耗率per設為 Not null, required ，并default 0 ,否則開工單時，損耗率為 null值的料會展不出來
# Modify.........: No.FUN-4C0054 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-4B0218 04/12/13 By Mandy 程式i600_u()    FETCH i600_cl INTO g_bma.*失敗時, 在RETURN前少做了ROLLBACK WORK 的動作!
# Modify.........: No.MOD-4B0234 04/12/14 By Mandy BOM 表發放時，應該將單頭的發放日期回寫至單身之生效日期。
# Modify.........: No.MOD-4C0128 04/12/20 By Mandy 按MENU的插件位置去修改插件位置,回到主畫面后,畫面的單身欄位"插件位置",所show 的資料還是舊的,應該要show新的資料
#                  2005/01/05 alex FUN-4C0104 修改 4js bug 定義超長
# Modify.........: No.MOD-530154 05/03/25 By kim bom取替代建立后不會自動更新bom,取替代特性未更改
# Modify.........: No.MOD-530295 05/03/25 By kim 無法使用檢視工程圖,無任何訊息產生,本功能取消, 改由相關文件功能取代
# Modify.........: No.MOD-530298 05/03/25 By kim 取替代料件前,請加上'替代'('SUB')或'取代'('UTE')字樣提示
# Modify.........: No.MOD-530690 05/03/29 By kim 復制開窗時, 新主件料號欄位應可查詢料號資料
# Modify.........: No.MOD-530326 05/03/29 By kim bom拋轉時針對目的資料庫檢查料件基本檔是否存在
# Modify.........: No.MOD-530295 05/03/30 By kim 工程圖檢視按鈕改由相關文件按鈕取代
# Modify.........: No.MOD-530319 05/04/01 By Mandy 1.BOM輸入完成后，會出現選取「樣版格式」之訊息
# Modify.........: No.MOD-530319 05/04/01 By Mandy 2.單身輸入時，誤差容許率預設值應為 0。非 Null
# Modify.........: No.MOD-530796 05/04/04 By kim 拋轉時進行update則無法進行單身項次的Insert
# Modify.........: No.FUN-550014 05/05/16 By Mandy 因特性BOM功能,增加1.單頭增一KEY值bma06特性代碼,另增加bma07配方否
# Modify.........:                                                   2.單身增一KEY值bma29特性代碼,另增加bmb30計算方式
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.MOD-560037 05/06/08 By kim 跨資料庫SQL問題
# Modify.........: No.FUN-560107 05/06/19 By kim 1.call abmq630(廠牌) 資料無法輸入及呈現
#                                                2.call abmi605(單身明細) 特性代碼要同單頭
#                                                3.資料拋轉不成功
# Modify.........: No.FUN-560115 05/06/20 By kim 于標准組裝產業單身不可顯示「計算方式」
# Modify.........: No.MOD-560066 05/07/08 By pengu 修改單身時，點選右邊ring menu上的[插件位置]，進行插件位置輸入
                                       #            輸入完后點選其他單身資料，單身中[插件位置]欄位將被清空
# Modify.........: No.MOD-590173 05/09/21 By kim QBE 時,如果單頭給一個已存在資料的料號,如果再清空"有效日期欄位",則會Q不出任何資料
# Modify.........: No.TQC-590033 05/09/23 By pengu  進入單身時品名規格會被清空不見
# Modify.........: No.MOD-5A0014 05/10/03 By pengu  bmb07該欄位不可空白 or NULL
# Modify.........: No.MOD-5A0193 05/10/19 By pengu  發料與成本單位不同時,g_bmb10_fac2的值錯誤!
# Modify.........: No.MOD-5A0254 05/10/21 By pengu  根據BOM資料拋轉的SOP(ABM002)所述，應是BOM發放后再轉至各個資料庫，
                                          #         然后各個資料庫調整完后再做發放動作
# Modify.........: No.MOD-5A0441 05/11/21 By Pengu 1.查詢時按上下筆,ring menu會突然蹦出[確定]&[放棄]鈕
# Modify.........: No.FUN-5B0004 05/11/21 By Pengu 1.單身料件基本資料action 改caall aimi100
                                      #            2.當sma09='N'時，disable單身料件基本資料action
# Modify.........: No.FUN-5B0068 05/11/10 By Claire 在更改項次時,也要同步修正插件位置的key(bmb02)
# Modify.........: No.FUN-590116 05/11/28 By kim BOM參數設定為BOM發放后不能直接改BOM單身，但該主件若為S:廠外加工件，會不受此限制
# Modify.........: No.FUN-610022 06/01/10 By jackie 增加BOM自定義公式部分
# Modify.........: No.TQC-610025 06/01/18 By Claire 使用特性BOM,復制時料號相同,就不再復制,避免-239錯誤
# Modify.........: NO.FUN-610095 06/01/25 By Rosayu 串接abmq500
# Modify.........: No.FUN-640139 06/04/10 By Lifeng Fix FUN-610022自定義BOM公式的BUG
# Modify.........: NO.TQC-640195 06/04/28 By Claire 修改BOM發放action名稱
# Modify.........: NO.MOD-650016 06/05/04 By kim 複製時有sqlcode時,未Rollback Work
# Modify.........: No.TQC-650075 06/05/19 By Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify.........: No.TQC-660059 06/06/14 By Rayven imandx_file改imx_file有些欄位修改有誤，重新修正
# Modify.........: No.TQC-660046 06/06/20 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-660112 06/06/20 By Claire 加上料號顯示
# Modify.........: No.TQC-660092 06/06/20 By Claire 語法錯誤
# Modify.........: No.TQC-660114 06/06/26 By Pengu "發放"action無法作權限控管
# Modify.........: No.FUN-660193 06/07/01 By Joe APS版更相關資料修改
# Modify.........: No.FUN-660086 06/07/12 By Sarah 移除abm-611的判斷
# Modify.........: No.FUN-680015 06/08/07 By 若由cbmi600串abmi601時考慮失效日期
# Modify.........: NO.FUN-5A0051 06/09/04 By kim 資料拋轉前,先check兩方資料庫料號是否存在
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6A0053 06/10/27 By rainy 資料拋轉時一併拋轉i610/i611的資料
# Modify.........: No.MOD-6A0145 06/11/01 By day  l_sql -> STRING
# Modify.........: No.FUN-6B0033 06/11/13 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-6B0036 06/11/14 By rainy 判斷停產(ima140)時，要一併判斷生效日(ima1401)
# Modify.........: No.TQC-6B0181 06/12/04 By Judy 特性代碼加set required控管
# Modify.........: No.TQC-6C0028 06/12/07 By Judy 資料為無效時不可更改，進單身
# Modify.........: No.MOD-6B0077 06/12/13 By pengu 維護插件位置,確認單據後,回寫至bmb_inplan插件位置,長度被截掉
# Modify.........: No.MOD-6B0134 06/12/14 By pengu select bmd_file.* ... INTO TEMP w4應該再加 bmd05 的判斷條件
# Modify.........: No.TQC-6C0104 06/12/19 By Ray 單身輸入錯誤的日期后單身顯示問題修改
# Modify.........: No.CHI-6C0034 07/01/05 By rainy 單身延用上筆且項次改為相同時，將原項次的失效日期UPDATE成新項次的生效日期
# Modify.........: No.FUN-710075 07/03/02 By Joe TIPTOP 5.0 & APS 2.0深度整合
# Modify.........: No.TQC-710109 07/03/02 By Ray 修改單身項次值重復沒有報錯
# Modify.........: No.TQC-720019 07/03/02 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/09 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-720043 07/03/21 By Mandy APS相關調整
# Modify.........: No.FUN-730075 07/03/30 By kim 行業別架構
# Modify.........: No.MOD-740315 07/04/23 By rainy 更改時料件重覆沒提示
# Modify.........: No.FUN-740215 07/04/25 By Joe APS相關調整
# Modify.........: No.MOD-740513 07/05/03 By Pengu 新增一筆單身資料若未建完資料就會到上面修改舊資料時會出現異常
# Modify.........: No.TQC-750013 07/05/04 By Mandy 一進入程式,不查詢直接按Action "APS相關資料"時的控管
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-750114 07/05/24 By pengu 單身明細action無法作權限控管
# Modify.........: No.MOD-770074 07/07/18 By pengu 身更改’單位”時,應重新抓取bmb10_fac and bmb10_fac2
# Modify.........: No.CHI-750031 07/07/24 By pengu 單頭"特性代碼"欄位不應強制要輸入值
# Modify.........: No.MOD-780015 07/08/06 By pengu 點選 [明細單身]依照所選之下階料號帶出資料
# Modify.........: NO.FUN-690019 07/08/14 BY yiting add bmb31 代買料否
# Modify.........: NO.MOD-780128 07/08/17 BY kim 新增時bmb15未寫入
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.TQC-7C0085 07/12/07 By Beryl 點擊復制功能鈕，在“新主件料號”一欄錄入一筆尚未審核過的料號，程式沒有管控．導致主件料號尚未審核，BOM已發放
# Modify.........: No.TQC-7C0111 07/12/08 By Davidzv 點擊錄入按鈕，"料件基本資料"這個action調用的程序改為aimi100.
# Modify.........: No.FUN-810014 08/01/09 By Arman 修改變服飾版
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: NO.FUN-7C0002 08/03/03 by Yiting apsi200-->apsi313.4gl
# Modify.........: No.FUN-7C0010 08/03/13 By Carrier 資料中心功能
# Modify.........: No.MOD-810187 08/03/23 By Pengu 新增時代買料否欄位應default N
# Modify.........: No.FUN-830116 08/03/25 By Arman 修改服飾BUG
                                        # BY ve007 修改圖片不顯示的問題
# Modify.........: FUN-830090 08/03/26 By Carrier 修改s_abmi600_carry的參數
# Modify.........: NO.FUN-840018 08/04/07 BY yiting 增加一個頁面放置清單資料
# Modify.........: NO.FUN-84 0033 08/04/08 BY yiting abmp102 call cbmi600直接開啟主畫面
# Modify.........: NO.FUN-840042 08/04/14 BY TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-840104 08/04/14 By claire 有效且發放資料,要顯示"核"
# Modify.........: No.MOD-840435 08/04/21 By kim 修改圖形顯示的處理段
# Modify.........: No.FUN-840137 08/04/21 By arman 若選擇固定，則應該只可輸入非母料件的一般料件
# Modify.........: NO.FUN-840155 FUN-840178 08/04/22 By ve007 debug 840137
# Modify.........: NO.FUN-850017 08/05/09 By arman   單身刪除無法跳入其它行
# Modify.........: NO.FUN-850079 08/05/09 By arman   單身計算方式無法通過
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT,DISPLAY ARRAY段漏了ON IDLE控制
# Modify.........: No.FUN-870012 08/06/30 by duke  update bmadate=now
# Modify.........: No.CHI-830034 08/06/30 by sherry 增加發放時 檢查主件狀態 (如i600_bma01 )
# Modify.........: No.CHI-850026 08/06/30 by sherry 修改單身時 ,若是更改元件(bmb03),
#                                                   若原有插件資料(bmt_file) ,則直接將該 bmt03也更新成 new bmb03!
# Modify.........: No.MOD-810032 08/07/04 By Pengu 單身維護完插件位置後必須再重新DISPLAY bmb13
# Modify.........: NO.FUN-850147 08/06/23 by Echo 新增 TIPTOP & MDM 整合
# Modify.........: No.TQC-830004 08/07/14 By zhaijie進入BOM單身修改任意一個欄位，然后確定，就會發現bmb10_fac，bmb10_fac2被回寫為null
# Modify.........: No.FUN-870127 08/07/24 By arman 服飾版
# Modify.........: No.CHI-880001 08/08/04 By sherry 若BOM已存在工單(已開工單)不允許刪除
# Modify.........: No.FUN-880072 08/08/19 By jan 服飾版過單
# Modify.........: No.CHI-880031 08/09/09 By xiaofeizhu 查出資料后,應該停在第一筆資料上,不必預設是看資料清單,有需要瀏覽,再行點選
# Modify.........: No.CHI-890025 08/09/19 By claire (1)單身before input控制欄位開關應放在before row
#                                                   (2)bmb30對欄位開關應放於新增及修改判斷內
# Modify.........: No.FUN-890118 08/09/26 BY sabrina add delete vmo_file
# Modify.........: No.FUN-880089 08/09/26 By sherry 單身刪除時,一并刪除 abmi604 該元件替代資料(不包含ALL)
# Modify.........: No.FUN-870124 08/09/27 By jan 修改服飾版邏輯
# Modify.........: No.MOD-8A0156 08/10/17 By claire bmb30空值時,開窗動態查詢調整
# Modify.........: No.MOD-8B0160 08/11/26 By Sarah 當單身開窗維護完插件位置後,應馬上回寫單身的bmb13
# Modify.........: No.FUN-890113 08/11/27 By kevin 移除MDM刪除功能
# Modify.........: No.MOD-8C0157 08/12/16 By claire 插件位置未重新顯示
# Modify.........: No.TQC-910003 08/01/05 BY DUKE MOVE OLD APS TABLE
# Modify.........: No.MOD-910045 09/01/06 By chenyu 計算方式有可能出現null的情況，影響后面單位的檢查
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-920012 09/02/02 By jan 修正復制時出現的問題（未用特性代碼，未查詢直接復制時無法復制）
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-8A0125 09/02/07 By Pengu 當單身沒資料時執行"單接用料查詢"action程式會擋掉
# Modify.........: No.FUN-910053 09/02/12 By jan bmb14 增加新的選項
# Modify.........: No.FUN-920157 09/02/23 By ve007 cbmi600與aici013整合
# Modify.........: No.MOD-930011 09/03/02 By Pengu 單接用料查詢action無法查出資料
# Modify.........: No.TQC-930083 09/03/12 By chenyu 1.TQC-7C0111修改錯誤
#                                                   2.asms215中“可在產品結構維護作業中輸入料件”沒有勾選時，“料件基本資料”按鈕應該隱藏
# Modify.........: No.MOD-940191 09/04/14 By lutingting發放還原時應該要卡已開立工單,不允許作還原
# Modify.........: No.MOD-940293 09/04/29 By sherry cbmi600在串abmi603的試候也要加上有效日期的判斷
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-950065 09/06/24 By mike 在串abmq500時多傳bma06做為查詢條件
# Modify.........: No.MOD-970116 09/07/16 By sherry 單身項次為4時程序會卡死
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980210 09/08/25 By Smapmin 有效日期沒有default,導致無法串查單身明細
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-990069 09/10/12 By baofei 增加子公司可新增資料的檢查
# Modify.........: No:MOD-9A0084 09/10/21 By Smapmin 將CALL abmi604中,update bmb_inplan的動作,移到CALL abmi604之後才做
# Modify.........: No:MOD-9A0116 09/10/21 By Smapmin BOM參數設定為BOM發放後不能直接改BOM單身，但該主件若為V/U會不受此限制
# Modify.........: No:MOD-9A0202 09/10/30 By Smapmin 執行程式馬上新增又刪除,程式會當掉
# Modify.........: No:FUN-980033 09/11/11 By jan BOM表新增時回寫到aici013的主件與原件顛倒
# Modify.........: No:MOD-980049 09/08/09 By Pengu 當BOM使用特性BOM時在富至會出現ins bmd重複的錯誤訊息
# Modify.........: No:MOD-980229 09/08/27 By Pengu 複製時會出現取替代資料重複
# Modify.........: No:TQC-990023 09/09/08 By Pengu 還原FUN-950065的功能
# Modify.........: No:MOD-9B0060 09/11/18 By Smapmin FUN-610095多CALL cl_load_act_list(),導致action的屬性又被重新抓取.
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:TQC-9C0192 09/12/30 By lilingyu bom發放時報錯信息錯誤
# Modify.........: No:FUN-9C0040 10/01/25 By jan 當BOM單身性質為"回收料"時，系統應允許單位用量為負數
# Modify.........: No:FUN-A20037 10/02/22 By lilingyu 取替代特性增加7.主料可做規則替代
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30131 10/04/01 By Summer 修改i600_copy(),將準備Temptable資料段移到BEGIN WORK前
# Modify.........: No:MOD-A30038 10/04/06 By liuxqa 单身无资料时，按单身明细，程序当掉。
# Modify.........: No:FUN-A40058 10/04/26 By lilingyu bmb16增加7.規格替代的內容
# Modify.........: No:FUN-A50010 10/05/05 By huangtao 增加tree顯示料號以及相關內容
# Modify.........: No:TQC-A50026 10/05/11 By destiny ring menu上的按钮不能显示
# Modify.........: No:FUN-A50010 10/05/11 By huangtao 修改i600_bp()和i600_bp1()恢復tree顯示
# Modify.........: No:CHI-A40001 10/05/25 By Summer BOM在進行發放時，檢核下階半成品的BOM是否發放
# Modify.........: No:FUN-A50089 10/06/01 By destiny  单身新增bmb081,bmb082字段
# Modify.........: No:TQC-A60039 10/06/10 By sunchenxu 修改tree功能修改
# Modify.........: No.TQC-A60046 10/06/11 By chenmoyan UPDATE日期型為''時,MSV資料有誤
# Modify.........: No:FUN-A60083 10/06/28 By destiny  单身增加工艺BOM管控
# Modify.........: No:MOD-A70036 10/07/05 By Carrier 单身"取替代性质"变为0.不可取替代时,把取替代内容delete掉
# Modify.........: No:MOD-A30161 10/07/23 By Pengu 串查單階用量時，應考慮有效日期
# Modify.........: No:MOD-A20048 10/07/23 By Pengu BOM失效時最進修改日未update
# Modify.........: No:MOD-A70166 10/07/26 By Sarah BOM發放時,不需更新發放日期到單身的生效日期
# Modify.........: No:MOD-A70215 10/07/29 By Sarah 將FUNCTION i600_j()中的g_wc2變數改為用l_wc2,以免改變了原先查詢時所下之單身條件g_wc2
# Modify.........: No:MOD-A20005 10/08/03 By Pengu 刪除BOM在判斷是否存在工單的判斷應加上特性代碼
# Modify.........: No:MOD-A10148 10/08/03 By Pengu 新增BOM時無法即時查出插件位置資料
# Modify.........: No:TQC-A80123 10/08/25 By destiny BOM发放后不能异动未勾选时，进单身应当报错
# Modify.........: No.FUN-950057 10/08/25 By vealxu gew03 = '1'時,確認時自動拋轉
# Modify.........: No:MOD-A90180 10/0/29  By sabrina 當元件料號有變更時，消耗料件也要變更
# Modify.........: No:MOD-A90182 10/0/29  By sabrina 當狀態碼為"2：發放"時，不可以按無效
# Modify.........: No:MOD-AA0042 10/10/08 By sabrina 做發放還原時，是否存在工單需多判斷"特性代碼"
# Modify.........: No:TQC-AA0076 10/10/12 By destiny 主件料號開窗時不應過濾非母件料號
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.TQC-AC0159 10/12/14 By vealxu "列印"action不應該亮才對
# Modify.........: No.TQC-AC0162 10/12/17 By vealxu  資料拋轉成功後無訊息提示
# Modify.........: No.MOD-AC0227 10/12/20 By sabrina 做無效時，不應控卡"發放否"
# Modify.........: No.FUN-AC0076 10/12/27 By wangxin 加action串查abmi612
# Modify.........: No.CHI-AC0037 10/12/27 By lixh1   控卡單身為回收料時,bmb06可以為負,但不可為0
# Modify.........: No.FUN-B10013 11/01/21 By lixh1   將cbmi600的拋轉功能請獨立成一個函數寫到s_abmi600_carry.4gl
# Modify.........: No:MOD-B40149 11/04/18 By Smapmin 新增單頭後接續輸入的單身,此情況不視為修改
# Modify.........: No:TQC-B40048 11/04/19 By destiny 对已存在的有回路的bom资料，系统不会检查，可以保存
# Modify.........: No:MOD-B50076 11/05/10 By destiny 从资料页签切换到主页签时，单身资料显示有错误，总显示上一笔
# Modify.........: No:FUN-B70096 11/06/09 By jason 新增樹狀報表
# Modify.........: No:FUN-A70134 11/07/05 By Mandy PLM GP5.1追版至GP5.25-----str-----
# Modify.........: No:FUN-A70134 10/07/29 By Mandy 因為PLM整合時,Service "CreateBOMData"欲共用確認段,將i600_confirm()拆至cbmi600_sub.4gl
#                  原cbmi600.4gl的i600_confirm()被拆分成
#                  i600sub_chk()    ==>確認前的欄位檢核
#                  i600sub_y_upd()  ==>做欄位的異動
# Modify.........: #FUN-AA0018 10/10/08 By Mandy 將原在cbmi600.4gl內
#                  發放功能i600_j()拆解成:
#                  i600sub_j_chk()
#                  i600sub_j_input() ==>Service 做發放時不會呼叫
#                  i600sub_j_upd()
#                  i600sub_carry() ==>Service 做發放時不會呼叫
# Modify.........: No:FUN-A70134 11/07/05 By Mandy PLM GP5.1追版至GP5.25-----end-----
# Modify.........: No:TQC-B70034 11/07/12 By guoch bmb03進行空值判斷
# Modify.........: No:MOD-B40221 11/07/18 By Vampire 刪除單身資料時，BOM說明資料(bmc_file)並沒有刪除
# Modify.........: No:MOD-B70146 11/07/18 By Vampire bmt06不應由bmb13去更新，且bmb13這個欄位本身是不可維護的，故將update bmt06=g_bmb[l_ac].bmb13 mark掉。
# Modify.........: No:CHI-B70045 11/07/28 By sabrina 單身輸入資料時，若此料件需輸入插件位置，
#                                                    但如果欄位沒有移到AFTER FIELD bmb19則不會開啟畫面讓使用者輸入
# Modify.........: No.FUN-B80100 11/08/11 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-B90042 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No:MOD-B90133 11/09/22 By johung 資料無效不可複製
#                                                   複製的取替代資料生效日以複製時設定的生效日為準
# Modify.........: No.FUN-B90117 11/10/09 By lilingyu 增加TREE控件連動顯示
# Modify.........: No.TQC-B90236 11/11/08 By zhuhao 取替代特性(bmb16)：增加選項"9.主料可做配方替代",ACTION bom_prompt增加選項9的判斷
#                                                   FUNCTION i6002_prompt()中加上選項9
# Modify.........: No.FUN-910088 12/01/17 By chenjing 增加數量欄位小數取位
# Modify.........: No:CHI-C10024 12/02/01 By ck2yuan AFTER FIELD bmb06/bmb07 若有需要開窗abmi200維護插件位置資料
# Modify.........: No:CHI-BB0034 12/02/02 By ck2yuan 只有在查詢時才出現9025警告，其他action不需要
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into bmd_file之前給bmd11賦值
# Modify.........: No:TQC-C20149 12/02/15 By bart 點選"BOM發放"按鈕後選擇取消,程式會自動關閉
# Modify.........: No:FUN-C20094 12/02/16 By pauline 不論有無勾選平行製程，一律顯示Tree資訊  
# Modify.........: No:TQC-C20388 12/02/22 By yuhuabao 修改新增時，無法選取"取替代特性"為9的資料 bug
# Modify.........: No:TQC-C20419 12/02/23 By yuhuabao 元件的取替代特性為9，已建立abmi604的資料，但按右邊"維護取替代"Action時，還是會出現abm-200的詢問窗
# Modify.........: No.TQC-C20444 12/02/24 By xianghui 由abmp102串接過來時不顯示資料
# Modify.......... No.FUN-C20105 12/02/21 By lilingyu 調整FUN-B90117 增加TREE控件的鎖功能
# Modify.......... No.TQC-C20429 12/02/28 By huangrh 調整服飾行業bmb30的默認值
# Modify.......... No.TQC-C20130 12/02/28 By lilingyu 【狀態】頁簽欄位無法全部下查詢條件 
# Modify.......... No.TQC-C30115 12/03/06 By bart 1.BOM資料刪除時,未一併刪除aici013資料icm_file
#                                                 2.單身修改料號時,應同步更改icm_file資料,icm01應改為新料號
# Modify.......... No.MOD-C30561 12/03/12 By fengrui 查詢時清空tree
# Modify.......... No.MOD-C30530 12/03/12 By fengrui 修改未鎖定BOM報錯信息的顯示方式，添加鎖定狀態下查詢功能需解鎖的提示信息
# Modify.......... No.MOD-C30413 12/03/12 By fengrui 修改未鎖定BOM報錯信息的顯示內容
# Modify.......... No:MOD-C40062 12/04/09 By ck2yuan 匯出excel功能修正
# Modify.........: No:CHI-C30130 12/05/08 By bart 要允許輸入phase out料件
# Modify.........: No.CHI-C30002 12/05/14 By yuhuabao 離開單身若單身無資料時提示是否刪除單頭資料
# Modify.........: No.TQC-C50231 12/05/29 By fengrui 添加單身項次大於0控管
# Modify.........: No.CHI-C30107 12/06/05 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C60231 12/06/28 By fengrui INSERT前，控管不可為無窮回圈資料
# Modify.........: No.TQC-C60239 12/06/28 By fengrui 回路資料down出問題修改
# Modify.........: No.TQC-C60097 12/06/29 By fengrui 單身代買料否欄位在查詢狀態下開啟
# Modify.........: No.MOD-C70011 12/07/02 By suncx 開啟程序立即新增資料，新增後，左側的BOM樹狀結構無法顯示
# Modify.........: No.CHI-C20058 12/07/13 By bart 僅帶出遊標該筆替代資料
# Modify.........: No.TQC-C70069 12/07/16 By fengrui 修改tree聯動問題
# Modify.........: No:MOD-C70220 12/07/23 By ck2yuan update 應用 _t 當條件
# Modify.........: No:TQC-C70178 12/07/24 By fengrui 修改打印時報錯問題
# Modify.........: No:FUN-C30047 12/08/07 By bart cbmi600主件可輸入特性主件料號(ima928='Y')
# Modify.........: No:FUN-C30036 12/08/09 By bart 增加點選料號自動帶出BOM資料功能
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C30028 12/08/22 By bart tree隱藏功能
# Modify.........: No:MOD-C90170 12/09/20 By suncx 畫面上串查按鈕為灰色，不能點擊
# Modify.........: No:MOD-CA0039 12/10/12 By Elise 更新bmb10_fac與bmb10_fac2
# Modify.........: No:FUN-CB0078 12/11/19 By lixh1 拿掉鎖功能
# Modify.........: No:MOD-CC0278 12/12/28 By suncx TREE顯示按照單身項次排序
# Modify.........: No:CHI-C80041 13/01/08 By bart 刪除單頭時，一併刪除相關table
# Modify.........: No:FUN-C40006 13/01/10 By Nina 只要程式有UPDATE bma_inplan 的任何一個欄位時,多加bmadate=g_today
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_inplan 的任何一個欄位時,多加bmbdate=g_today
# Modify.........: No:MOD-CB0227 13/01/11 By Elise 放還原與刪除控卡,排除作廢工單
# Modify.........: No:FUN-D10093 13/01/20 By Abby PLM BOM項次一致問題:單身新增欄位-PLM BOM項次[bmb36]/PLM KEY[bmb37]欄位
#                                                  (1)當aoos010欄位"是否與PLM整合[aza121=Y]"打勾時,才show出此欄位
#                                                  (2)此欄位NO ENTRY,僅能DISPLAY
# Modify.........: No:MOD-D20147 13/02/26 By Alberti i600_tree_cs2 中加入 bma06 = g_bma.bma06之條件
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更
# Modify.........: No:CHI-C90013 13/03/12 By Alberti 修正列印時的錯誤
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D80128 13/08/20 By fengmy bmb30 = '3'時,去掉ima相關判斷與操作
# Modify.........: No:MOD-D80170 13/08/27 By fengmy 資料清單中產生tree前update主料件及其特性代碼
# Modify.........: No:16         16/07/06 By guanyao 增加按钮，将aeci100的作业编号写到单身

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"

#模組變數(Module Variables)
DEFINE
    tm              RECORD
        plant       ARRAY[20]  OF LIKE azp_file.azp01,   #No.FUN-680096 VARCHAR(10),
        dbs         ARRAY[20]  OF LIKE type_file.chr21   #No.FUN-680096 VARCHAR(21)
                    END RECORD,
    g_bma           RECORD LIKE bma_inplan.*,       #主件料件(假單頭)
    g_bma_t         RECORD LIKE bma_inplan.*,       #主件料件(舊值)
    g_bma_o         RECORD LIKE bma_inplan.*,       #主件料件(舊值)
    g_bma01_t       LIKE bma_inplan.bma01,   #(舊值)#單頭KEY值
    g_bma06_t       LIKE bma_inplan.bma06,   #(舊值)#單頭KEY值#FUN-550014
    g_bmb10_fac_t   LIKE bmb_inplan.bmb10_fac,   #(舊值)
    g_ima08_h       LIKE ima_file.ima08,   #來源碼
    g_ima37_h       LIKE ima_file.ima37,   #補貨政策
    g_ima08_b       LIKE ima_file.ima08,   #來源碼
    g_ima37_b       LIKE ima_file.ima37,   #補貨政策
    g_ima25_b       LIKE ima_file.ima25,   #庫存單位
    g_ima63_b       LIKE ima_file.ima63,   #發料單位
    g_ima70_b       LIKE ima_file.ima63,   #消耗料件
    g_ima86_b       LIKE ima_file.ima86,   #成本單位
    g_ima107_b      LIKE ima_file.ima107,  #LOCATION
    g_ima04         LIKE ima_file.ima04,   #
    g_db_type       LIKE type_file.chr3,    #No.FUN-680096  VARCHAR(3),               #MOD-560037
    g_bmb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    bmb02    LIKE bmb_inplan.bmb02,       #元件項次
                    bmb30    LIKE bmb_inplan.bmb30,       #計算方式 #FUN-550014#FUN-610022調換順序
                    bmb03    LIKE bmb_inplan.bmb03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    bmb09    LIKE bmb_inplan.bmb09,       #作業編號
                    bmb16    LIKE bmb_inplan.bmb16,       #UTE/SUB
                    bmb14    LIKE bmb_inplan.bmb14,       #Required/Optional
                    bmb04    LIKE bmb_inplan.bmb04,       #生效日
                    bmb05    LIKE bmb_inplan.bmb05,       #失效日
                    bmb06    LIKE bmb_inplan.bmb06,       #組成用量
                    bmb07    LIKE bmb_inplan.bmb07,       #底數
                    bmb10    LIKE bmb_inplan.bmb10,       #發料單位
                    bmb08    LIKE bmb_inplan.bmb08,       #損耗率
                    bmb081   LIKE bmb_inplan.bmb081,      #No.FUN-A50089
                    bmb082   LIKE bmb_inplan.bmb082,      #No.FUN-A50089
                    bmb19    LIKE bmb_inplan.bmb19,
                    bmb24    LIKE bmb_inplan.bmb24,       #工程變異單號
                    bmb13    LIKE bmb_inplan.bmb13,       #insert_loc
                    bmb31    LIKE bmb_inplan.bmb31,       #代買料否  FUN-690019
                    bmb15    LIKE bmb_inplan.bmb15,       #add by donghy 161121
                    bmb36    LIKE bmb_inplan.bmb36,       #FUN-D10093 add
                    bmb37    LIKE bmb_inplan.bmb37,       #FUN-D10093 add
                    bmbud01  LIKE bmb_inplan.bmbud01,
                    bmbud02  LIKE bmb_inplan.bmbud02,
                    bmbud03  LIKE bmb_inplan.bmbud03,
                    bmbud04  LIKE bmb_inplan.bmbud04,
                    bmbud05  LIKE bmb_inplan.bmbud05,
                    bmbud06  LIKE bmb_inplan.bmbud06,
                    bmbud07  LIKE bmb_inplan.bmbud07,
                    bmbud08  LIKE bmb_inplan.bmbud08,
                    bmbud09  LIKE bmb_inplan.bmbud09,
                    bmbud10  LIKE bmb_inplan.bmbud10,
                    bmbud11  LIKE bmb_inplan.bmbud11,
                    bmbud12  LIKE bmb_inplan.bmbud12,
                    bmbud13  LIKE bmb_inplan.bmbud13,
                    bmbud14  LIKE bmb_inplan.bmbud14,
                    bmbud15  LIKE bmb_inplan.bmbud15
                    END RECORD,
    g_bmb_t         RECORD                 #程式變數 (舊值)
                    bmb02    LIKE bmb_inplan.bmb02,       #元件項次
                    bmb30    LIKE bmb_inplan.bmb30,       #計算方式 #FUN-550014#FUN-610022調換順序
                    bmb03    LIKE bmb_inplan.bmb03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    bmb09    LIKE bmb_inplan.bmb09,       #作業編號
                    bmb16    LIKE bmb_inplan.bmb16,       #UTE/SUB
                    bmb14    LIKE bmb_inplan.bmb14,       #Required/Optional
                    bmb04    LIKE bmb_inplan.bmb04,       #生效日
                    bmb05    LIKE bmb_inplan.bmb05,       #失效日
                    bmb06    LIKE bmb_inplan.bmb06,       #組成用量
                    bmb07    LIKE bmb_inplan.bmb07,       #底數
                    bmb10    LIKE bmb_inplan.bmb10,       #發料單位
                    bmb08    LIKE bmb_inplan.bmb08,       #損耗率
                    bmb081   LIKE bmb_inplan.bmb081,      #No.FUN-A50089
                    bmb082   LIKE bmb_inplan.bmb082,      #No.FUN-A50089
                    bmb19    LIKE bmb_inplan.bmb19,
                    bmb24    LIKE bmb_inplan.bmb24,       #工程變異單號
                    bmb13    LIKE bmb_inplan.bmb13,       #insert_loc
                    bmb31    LIKE bmb_inplan.bmb31,       #代買料否  FUN-690019
                    bmb15    LIKE bmb_inplan.bmb15,       #add by donghy 161121
                    bmb36    LIKE bmb_inplan.bmb36,       #FUN-D10093 add
                    bmb37    LIKE bmb_inplan.bmb37,       #FUN-D10093 add
                    bmbud01  LIKE bmb_inplan.bmbud01,
                    bmbud02  LIKE bmb_inplan.bmbud02,
                    bmbud03  LIKE bmb_inplan.bmbud03,
                    bmbud04  LIKE bmb_inplan.bmbud04,
                    bmbud05  LIKE bmb_inplan.bmbud05,
                    bmbud06  LIKE bmb_inplan.bmbud06,
                    bmbud07  LIKE bmb_inplan.bmbud07,
                    bmbud08  LIKE bmb_inplan.bmbud08,
                    bmbud09  LIKE bmb_inplan.bmbud09,
                    bmbud10  LIKE bmb_inplan.bmbud10,
                    bmbud11  LIKE bmb_inplan.bmbud11,
                    bmbud12  LIKE bmb_inplan.bmbud12,
                    bmbud13  LIKE bmb_inplan.bmbud13,
                    bmbud14  LIKE bmb_inplan.bmbud14,
                    bmbud15  LIKE bmb_inplan.bmbud15
                    END RECORD,
    g_bmb_o         RECORD                 #程式變數 (舊值)
                    bmb02    LIKE bmb_inplan.bmb02,       #元件項次
                    bmb30    LIKE bmb_inplan.bmb30,       #計算方式 #FUN-550014
                    bmb03    LIKE bmb_inplan.bmb03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    bmb09    LIKE bmb_inplan.bmb09,       #作業編號
                    bmb16    LIKE bmb_inplan.bmb16,       #UTE/SUB
                    bmb14    LIKE bmb_inplan.bmb14,       #Required/Optional
                    bmb04    LIKE bmb_inplan.bmb04,       #生效日
                    bmb05    LIKE bmb_inplan.bmb05,       #失效日
                    bmb06    LIKE bmb_inplan.bmb06,       #組成用量
                    bmb07    LIKE bmb_inplan.bmb07,       #底數
                    bmb10    LIKE bmb_inplan.bmb10,       #發料單位
                    bmb08    LIKE bmb_inplan.bmb08,       #損耗率
                    bmb081   LIKE bmb_inplan.bmb081,      #No.FUN-A50089
                    bmb082   LIKE bmb_inplan.bmb082,      #No.FUN-A50089
                    bmb19    LIKE bmb_inplan.bmb19,
                    bmb24    LIKE bmb_inplan.bmb24,       #工程變異單號
                    bmb13    LIKE bmb_inplan.bmb13,       #insert_loc
                    bmb31    LIKE bmb_inplan.bmb31,        #代買料否  FUN-690019
                    bmb15    LIKE bmb_inplan.bmb15,       #add by donghy 161121
                    bmb36    LIKE bmb_inplan.bmb36,       #FUN-D10093 add
                    bmb37    LIKE bmb_inplan.bmb37,       #FUN-D10093 add
                    bmbud01  LIKE bmb_inplan.bmbud01,
                    bmbud02  LIKE bmb_inplan.bmbud02,
                    bmbud03  LIKE bmb_inplan.bmbud03,
                    bmbud04  LIKE bmb_inplan.bmbud04,
                    bmbud05  LIKE bmb_inplan.bmbud05,
                    bmbud06  LIKE bmb_inplan.bmbud06,
                    bmbud07  LIKE bmb_inplan.bmbud07,
                    bmbud08  LIKE bmb_inplan.bmbud08,
                    bmbud09  LIKE bmb_inplan.bmbud09,
                    bmbud10  LIKE bmb_inplan.bmbud10,
                    bmbud11  LIKE bmb_inplan.bmbud11,
                    bmbud12  LIKE bmb_inplan.bmbud12,
                    bmbud13  LIKE bmb_inplan.bmbud13,
                    bmbud14  LIKE bmb_inplan.bmbud14,
                    bmbud15  LIKE bmb_inplan.bmbud15
                    END RECORD,
    g_bmb11         LIKE  bmb_inplan.bmb11,
    g_bmb13         LIKE  bmb_inplan.bmb13,
    g_bmb31         LIKE  bmb_inplan.bmb31,   #no.FUN-690019
    g_bmb23         LIKE  bmb_inplan.bmb23,
    g_bmb10_fac     LIKE  bmb_inplan.bmb10_fac,
    g_bmb10_fac2    LIKE  bmb_inplan.bmb10_fac2,
    g_bmb15         LIKE  bmb_inplan.bmb15,
    g_bmb18         LIKE  bmb_inplan.bmb18,
    g_bmb17         LIKE  bmb_inplan.bmb17,
    g_bmb27         LIKE  bmb_inplan.bmb27,
    g_bmb28         LIKE  bmb_inplan.bmb28,
    g_bmb20         LIKE  bmb_inplan.bmb20,
    g_bmb19         LIKE  bmb_inplan.bmb19,
    g_bmb21         LIKE  bmb_inplan.bmb21,
    g_bmb22         LIKE  bmb_inplan.bmb22,
    g_bmb25         LIKE  bmb_inplan.bmb25,
    g_bmb26         LIKE  bmb_inplan.bmb26,
    g_bmb11_o       LIKE  bmb_inplan.bmb11,
    g_bmb13_o       LIKE  bmb_inplan.bmb13,
    g_bmb31_o       LIKE  bmb_inplan.bmb31,   #no.FUN-690019
    g_bmb23_o       LIKE  bmb_inplan.bmb23,
    g_bmb25_o       LIKE  bmb_inplan.bmb23,
    g_bmb26_o       LIKE  bmb_inplan.bmb23,
    g_bmb10_fac_o   LIKE  bmb_inplan.bmb10_fac,
    g_bmb10_fac2_o  LIKE  bmb_inplan.bmb10_fac2,
    g_bmb15_o       LIKE  bmb_inplan.bmb15,
    g_bmb18_o       LIKE  bmb_inplan.bmb18,
    g_bmb17_o       LIKE  bmb_inplan.bmb17,
    g_bmb27_o       LIKE  bmb_inplan.bmb27,
    g_bmb20_o       LIKE  bmb_inplan.bmb20,
    g_bmb19_o       LIKE  bmb_inplan.bmb19,
    g_bmb21_o       LIKE  bmb_inplan.bmb21,
    g_bmb22_o       LIKE  bmb_inplan.bmb22,
    g_ima01         LIKE  ima_file.ima01,
    g_sql           string,                  #No.FUN-580092 HCN
    g_wc,g_wc2      string,                  #No.FUN-580092 HCN
    g_vdate         LIKE type_file.dat,      #No.FUN-680096 DATE,
    g_sw            LIKE type_file.num5,     #No.FUN-680096 SMALLINT,  #單位是否可轉換
    g_factor        LIKE ima_file.ima31_fac, #No.FUN-680096 DECIMAL(16,8),         #單位換算率
    g_cmd           LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(60),
    g_aflag         LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(01),
    g_modify_flag   LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(01),

    g_tipstr        LIKE ze_file.ze03,       #FUN-610022 Add,顯示內容為"<依公式生成>"的字符串

    g_ecd02         LIKE ecd_file.ecd02,
    g_rec_b         LIKE type_file.num5,     #No.FUN-680096 SMALLINT,  #單身筆數
    l_ac            LIKE type_file.num5,     #No.FUN-680096 SMALLINT,  #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5      #No.FUN-680096 SMALLINT   #目前處理的SCREEN LINE
DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680096 SMALLINT
DEFINE g_bmt_tmp    DYNAMIC ARRAY OF RECORD LIKE bmt_file.*   #insert_loc的暫存檔 BugNo:6754
DEFINE  g_bma_l       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      bma01_l     LIKE bma_inplan.bma01,
                      bma06_l     LIKE bma_inplan.bma06,
                      ima02_l     LIKE ima_file.ima02,
                      ima021_l    LIKE ima_file.ima021,
                      ima55_l     LIKE ima_file.ima55,
                      ima05_l     LIKE ima_file.ima05,
                      ima08_l     LIKE ima_file.ima08,
                      bma05_l     LIKE bma_inplan.bma05,
                      bma08_l     LIKE bma_inplan.bma08
                      END RECORD
DEFINE  g_bmax        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      sel         LIKE type_file.chr1,
                      bma01       LIKE bma_inplan.bma01,
                      bma06       LIKE bma_inplan.bma06
                      END RECORD
DEFINE g_gev04        LIKE gev_file.gev04
DEFINE l_ac1          LIKE type_file.num10
DEFINE g_rec_b1       LIKE type_file.num10
DEFINE g_bp_flag      LIKE type_file.chr10
DEFINE g_flag2        LIKE type_file.chr1
DEFINE g_gew06        LIKE gew_file.gew06
DEFINE g_gew07        LIKE gew_file.gew07
DEFINE g_argv1        LIKE bma_inplan.bma01
DEFINE g_argv2        LIKE bma_inplan.bma02
DEFINE g_argv3        STRING            #NO.FUN-84 0033 add

DEFINE
   g_value ARRAY[20] OF RECORD
            fname     LIKE type_file.chr5,  #No.FUN-680096 VARCHAR(5),  #欄位名稱，從'att01'~'att10'
            imx000    LIKE imx_file.imx000, #No.FUN-680096 VARCHAR(8),  #該欄位在imx_file中對應的欄位名稱
            visible   LIKe type_file.chr1,  #No.FUN-680096 VARCHAR(1),  #是否可見，'Y'或'N'
            nvalue    STRING,
            value     STRING  #存放當前當前組
            END RECORD,
    g_att  DYNAMIC ARRAY OF RECORD
            att01   LIKE imx_file.imx01, # 明細屬性欄位
            att02   LIKE imx_file.imx01, # 明細屬性欄位
            att03   LIKE imx_file.imx01, # 明細屬性欄位
            att04   LIKE imx_file.imx01, # 明細屬性欄位
            att05   LIKE imx_file.imx01, # 明細屬性欄位
            att06   LIKE imx_file.imx01, # 明細屬性欄位
            att07   LIKE imx_file.imx01, # 明細屬性欄位
            att08   LIKE imx_file.imx01, # 明細屬性欄位
            att09   LIKE imx_file.imx01, # 明細屬性欄位
            att10   LIKE imx_file.imx01, # 明細屬性欄位
            att11   LIKE imx_file.imx01, # 明細屬性欄位
            att12   LIKE imx_file.imx01, # 明細屬性欄位
            att13   LIKE imx_file.imx01, # 明細屬性欄位
            att14   LIKE imx_file.imx01, # 明細屬性欄位
            att15   LIKE imx_file.imx01, # 明細屬性欄位
            att16   LIKE imx_file.imx01, # 明細屬性欄位
            att17   LIKE imx_file.imx01, # 明細屬性欄位
            att18   LIKE imx_file.imx01, # 明細屬性欄位
            att19   LIKE imx_file.imx01, # 明細屬性欄位
            att20   LIKE imx_file.imx01  # 明細屬性欄位
        END RECORD

DEFINE   lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.* #No.FUN-640139 Add

DEFINE   l_chk_boa     LIKE type_file.chr1,      #FUN-6A0053 add
         l_chk_bob     LIKE type_file.chr1       #FUN-6A0053 add
DEFINE   g_wsw03       LIKE wsw_file.wsw03       #FUN-890113

#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_level         LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_status        LIKE type_file.num5     #No.FUN-680096 SMALLINT

DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   g_before_input_done   LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE   g_itm DYNAMIC ARRAY OF RECORD #FUN-5A0051
                  db      LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20),
                  tblname LIKE cre_file.cre08,   #No.FUN-680096 VARCHAR(10),
                  ima01   LIKE ima_file.ima01,
                  ima02   LIKE ima_file.ima02
               END RECORD
DEFINE   b_bmb           RECORD LIKE bmb_inplan.*
DEFINE p_md         LIKE type_file.chr1        #No.FUN-810014
DEFINE p_bma06      LIKE bma_inplan.bma06        #No.FUN-810014
DEFINE  g_confirm LIKE type_file.chr1           #No.FUN-830121

###FUN-A50010 START ###
DEFINE g_wc_o            STRING                #g_wc舊值備份
DEFINE g_idx             LIKE type_file.num5   #g_tree的index，用於tree_fill()的recursive
DEFINE g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,                 #節點名稱
          pid            STRING,                 #父節點id
          id             STRING,                 #節點id
          has_children   BOOLEAN,                #TRUE:有子節點, FALSE:無子節點
          expanded       BOOLEAN,                #TRUE:展開, FALSE:不展開
          level          LIKE type_file.num5,    #階層
          path           STRING,                 #節點路徑，以"."隔開
          #各程式key的數量會不同，單身和單頭的key都要記錄
          #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空白
          treekey1       STRING,
          treekey2       STRING
          END RECORD
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路徑(check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路徑(check loop)
DEFINE l_table           STRING                  #No:FUN-B70096
DEFINE l_table2          STRING                  #No:FUN-B70096
DEFINE g_str             STRING                  #No:FUN-B70096
###FUN-A50010 END ###

#FUN-B90117--BEGIN--  新增加页签前面的树结构
DEFINE g_tree1    DYNAMIC ARRAY OF RECORD
          name1           STRING,                 #節點名稱
          s1              LIKE type_file.num20_6,
          s2              LIKE type_file.num20_6,
          s3              LIKE type_file.chr20,
          pid1            STRING,                 #父節點id
          id1            STRING,                 #節點id
          has_children1   BOOLEAN,                #TRUE:有子節點, FALSE:無子節點
          expanded1       BOOLEAN,                #TRUE:展開, FALSE:不展開
          level1          LIKE type_file.num5,    #階層
          path1           STRING,                 #節點路徑，以"."隔開
          #各程式key的數量會不同，單身和單頭的key都要記錄
          #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空白
          treekey3       STRING,
          treekey4       STRING 
       #  img            STRING         #图标   #FUN-CB0078 mark
                               END RECORD
DEFINE g_tree_sel        LIKE type_file.chr1   # 用来判断填充哪个树的变量，1表示前页的树，2表示后面的树
DEFINE g_tree_arr_curr   LIKE type_file.num5
DEFINE g_bma01_tree      LIKE bma_inplan.bma01
#FUN-B90117--END--
DEFINE g_bmb10_t         LIKE bmb_inplan.bmb10    #FUN-910088--add--
#DEFINE g_lock            LIKE type_file.chr1   #FUN-C20105      #FUN-CB0078
DEFINE g_tree_item       LIKE bma_inplan.bma01    #FUN-C30036
DEFINE g_hide            LIKE type_file.chr1    #FUN-C30028
#FUN-CB0078 -----begin---add----
DEFINE g_tree_upd        LIKE bma_inplan.bma01
DEFINE g_tree_bma01      LIKE bma_inplan.bma01
DEFINE g_show_flag       LIKE type_file.chr1
DEFINE g_a_flag          LIKE type_file.chr1
#FUN-CB0078 -----end-----add----

MAIN
DEFINE  p_sma124  LIKE sma_file.sma121          #No.FUN-810014
DEFINE  l_bmb13   LIKE ze_file.ze03             #No.FUN-810014

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF

   #No:FUN-B70096 --START--
   LET g_sql = "bma01_g.bma_inplan.bma01,",
               "bma01.bma_inplan.bma01,",
               "ima02.ima_file.ima02,",
               "bma06.bma_inplan.bma06,",
               "ima55.ima_file.ima55,",
               "bmb02.bmb_inplan.bmb02,",
               "bmb03.bmb_inplan.bmb03,",
               "ima02_1.ima_file.ima02,",
               "bmb09.bmb_inplan.bmb09,",
               "bmb06.bmb_inplan.bmb06,",
               "bmb07.bmb_inplan.bmb07,",
               "bmb10.bmb_inplan.bmb10,",     #CHI-C90013 add ,
               "id.type_file.num10,",       #CHI-C90013 add
               "pid.type_file.num10"        #CHI-C90013 add   

   LET l_table = cl_prt_temptable('cbmi600',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF

   #temp
   LET g_sql = "bma01.bma_inplan.bma01,",
               "bma06.bma_inplan.bma06,",    #CHI-C90013 add,
               "id.type_file.num10"            #CHI-C90013 add
   #LET l_table2 = cl_prt_temptable('cbmi600',g_sql) CLIPPED  #TQC-C70178 mark
   LET l_table2 = cl_prt_temptable('cbmi6001',g_sql) CLIPPED  #TQC-C70178 add
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
   #No:FUN-B70096 --END--

#  LET g_lock = 'N'          #FUN-C20105
   LET g_hide = 'N'          #FUN-C30028
   
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)    #no.FUN-84 0033 add

     LET g_db_type=cl_db_get_database_type() #MOD-560037
    LET g_wc2=' 1=1'

    LET g_forupd_sql =
       "SELECT * FROM bma_inplan WHERE bma01=? AND bma06=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_cl CURSOR FROM g_forupd_sql

    CALL s_decl_bmb()

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060

    LET p_row = 3 LET p_col = 2
    OPEN WINDOW i600_w AT p_row,p_col WITH FORM "cbm/42f/cbmi600"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()

    LET g_tree_reload = "N"      #tree是否要重新整理 Y/N  #FUN-A50010
    LET g_tree_b = "N"           #tree是否進入單身 Y/N    #FUN-A50010
    LET g_tree_focus_idx = 0     #focus節點index       #FUN-A50010
    LET g_show_flag = 'N'        #FUN-CB0078   add
    LET g_a_flag = 'N'           #FUN-CB0078   add

    CALL cl_set_comp_visible("bmb36,bmb37",g_aza.aza121='Y') #FUN-D10093 add #當aoos010欄位"是否與PLM整合[aza121=Y]"打勾時,才show出bmb36/bmb37欄位
    IF s_industry('slk') THEN
        CALL cl_set_comp_visible("bma06",g_sma.sma118='Y') #FUN-560115
        CALL cl_set_comp_visible("bma06_l",g_sma.sma118='Y')     #No.FUN-7C0010
    ELSE
        CALL cl_set_comp_visible("bma06,bmb30",g_sma.sma118='Y') #FUN-560115
        CALL cl_set_comp_visible("bma06_l",g_sma.sma118='Y')     #No.FUN-7C0010
    END IF
    IF s_industry('slk') THEN
        SELECT  ze03  INTO l_bmb13 FROM ze_file WHERE ze01 = 'cbmi600' AND ze02 = g_lang
        CALL cl_set_comp_att_text("bmb13",l_bmb13)
        CALL i600_set_bmb30()
    END IF
    IF NOT s_industry('slk') THEN
        CALL i600_set_bmb30_1()
    END IF

#FUN-B90117 --BEGIN--
  #FUN-C20094 mark START
  #IF g_sma.sma541 = 'Y' THEN
  #  CALL cl_set_comp_visible("tree1",TRUE)
  #ELSE
  #	 CALL cl_set_comp_visible("tree1",FALSE)
  #END IF
  #FUN-C20094 mark END
  CALL cl_set_comp_visible("tree1",TRUE) #FUN-C20094 add 
#FUN-B90117 --END--

    SELECT ze03 INTO g_tipstr FROM ze_file WHERE
      ze01 = 'lib-294' AND ze02 = g_lang

    --IF NOT cl_null(g_argv1) THEN
       --CALL i600_q()
    --END IF
    #TQC-C20444-add-str--
    IF NOT cl_null(g_argv1) THEN 
       CALL i600_q(0)
    END IF
    #TQC-C20444-add-end--
    LET g_action_choice = ''

    CALL i600_menu()

    CLOSE WINDOW i600_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN

#QBE 查詢資料
FUNCTION i600_curs(p_idx)  #FUN-9A50010 加參數p_idx
DEFINE l_flag      LIKE type_file.chr1    #No.FUN-680096  VARCHAR(01)   #判斷單身是否給條件
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index     #FUN-9A50010
DEFINE l_wc   STRING                #雙按Tree的節點時的查詢條件 #FUN-9A50010

###FUN-A50010 START ###
   LET l_wc = NULL
   IF p_idx > 0 THEN
      IF g_tree_b = "N" THEN
         LET l_wc = g_wc_o             #還原QBE的查詢條件
      ELSE
         IF g_tree[p_idx].level = 1 THEN
           LET l_wc = "bma01='",g_tree[p_idx].treekey2 CLIPPED,"'"
         ELSE
            IF g_tree[p_idx].has_children THEN
              LET l_wc = "bma01='",g_tree[p_idx].treekey2 CLIPPED,"'"
            ELSE
               LET l_wc = "bma01='",g_tree[p_idx].treekey2 CLIPPED,"'"

            END IF
         END IF
      END IF
#FUN-C20105 --begin--      
##FUN-B90117--BEGIN--
#   ELSE
#   	  IF g_action_choice = "tree" THEN
#   	     LET l_wc = "bma01='",g_tree1[g_tree_arr_curr].treekey4 CLIPPED,"'"
#   	  END IF
##FUN-B90117--END--
#FUN-C20105 --end--
   END IF
   ###FUN-A50010 END ###

    CLEAR FORM                            #清除畫面
    CALL g_bmb.clear()
    LET l_flag = 'N'
    LET g_vdate = g_today
  
   #IF NOT cl_null(g_argv1) OR g_lock = 'Y' THEN                          #FUN-C20105  #FUN-C30036   
   #IF NOT cl_null(g_argv1) OR g_lock = 'Y' OR NOT cl_null(g_tree_item) THEN  #FUN-C30036  #FUN-CB0078  mark
    IF NOT cl_null(g_argv1) OR NOT cl_null(g_tree_item) THEN              #FUN-CB0078  add
       IF NOT cl_null(g_argv1) THEN                                        #FUN-C20105 
          LET g_wc = " bma01 = '",g_argv1,"' AND bma06 = '",g_argv2,"'"
          LET g_tree_bma01 = g_argv1     #FUN-CB0078  add
       END IF                                                              #FUN-C20105

#FUN-C20105 --begin--
    #  IF g_lock='Y' AND g_tree_arr_curr > 0 THEN                          #FUN-CB0078  mark 
       IF NOT cl_null(g_tree_item) AND g_tree_arr_curr > 0 THEN            #FUN-CB0078  add
          LET g_wc = " bma01 = '",g_tree1[g_tree_arr_curr].treekey4,"'" 
          LET g_tree_bma01 = g_tree1[1].treekey4                           #FUN-CB0078  add 
       END IF 
#FUN-C20105 --end--
       #FUN-C30036---begin
       IF NOT cl_null(g_tree_item) THEN
          LET g_wc = " bma01 = '",g_tree_item,"'"
       END if
       #FUN-C30036---end
       
       LET g_wc2= " 1=1"
       IF NOT cl_null(g_vdate) THEN #MOD-590173
          LET  g_wc2 = g_wc2  clipped,
                      " AND (bmb04 <='", g_vdate,"'"," OR bmb04 IS NULL )",
                      " AND (bmb05 >  '",g_vdate,"'"," OR bmb05 IS NULL )" #BugNo:6032
       END IF

    ELSE
      # IF g_wc IS NULL THEN #MOD-530690
          CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
          INITIALIZE g_bma.* TO NULL    #No.FUN-750051

#FUN-C20105 --begin--          
##FUN-B90117--BEGIN--
##       IF p_idx = 0 THEN   #FUN-9A50010
#        IF p_idx = 0 AND g_action_choice = "tree" THEN
#           LET g_wc = " bma01 = '",g_tree1[g_tree_arr_curr].treekey4 CLIPPED,"'"
#        ELSE
##FUN-B90117 --END--

        IF p_idx = 0 THEN 
#FUN-C20105 --end--
          CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
              bma01,bma06,bma10,bma04,bma05,bma08,    #No.FUN-7C0010
              bmauser,bmagrup,
              bmaoriu,bmaorig,                                     #TQC-C20130 add
              bmamodu,bmadate,bmaacti, #FUN-810014 add bma10 #FUN-550014 add bma06
              bmaud01,bmaud02,bmaud03,bmaud04,bmaud05,
              bmaud06,bmaud07,bmaud08,bmaud09,bmaud10,
              bmaud11,bmaud12,bmaud13,bmaud14,bmaud15

              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              ON ACTION CONTROLP
                  CASE
                     WHEN INFIELD(bma01)
#FUN-AA0059 --Begin--
                     #   CALL cl_init_qry_var()
                     #   LET g_qryparam.form = "q_ima"
                     #   LET g_qryparam.state = 'c'
                     #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                        CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                        DISPLAY g_qryparam.multiret TO bma01
                        NEXT FIELD bma01
                     WHEN INFIELD(bma08)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form  = "q_azp"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO bma08
                        NEXT FIELD bma08
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
                 CALL cl_qbe_list() RETURNING lc_qbe_sn
                 CALL cl_qbe_display_condition(lc_qbe_sn)
          END CONSTRUCT

          IF INT_FLAG THEN
             RETURN
           END IF

          LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')

          DISPLAY g_vdate TO FORMONLY.vdate             #輸入有效日期
          CALL cl_set_head_visible("","YES")            #No.FUN-6B0033
          INPUT g_vdate WITHOUT DEFAULTS FROM vdate
             ON ACTION controlg       #TQC-860021
                CALL cl_cmdask()      #TQC-860021

             ON IDLE g_idle_seconds   #TQC-860021
                CALL cl_on_idle()     #TQC-860021
                CONTINUE INPUT        #TQC-860021

             ON ACTION about          #TQC-860021
                CALL cl_about()       #TQC-860021

             ON ACTION help           #TQC-860021
                CALL cl_show_help()   #TQC-860021
          END INPUT                   #TQC-860021

          IF g_vdate IS NULL OR g_vdate = ' ' THEN
             CONSTRUCT g_wc2 ON bmb02,bmb30,bmb03,bmb09,bmb16,bmb14,bmb04,bmb05, #FUN-5A0051 add bmb30
                                     bmb06,bmb07,bmb10,bmb08,bmb081,bmb082,bmb19,bmb24,bmb31,   #FUN-810014 add bmb13  # FUN-870127 reduce bmb13  #No.FUN-A50089  add bmb081,bmb082 #TQC-C60097
                                     bmbud01,bmbud02,bmbud03,bmbud04,bmbud05,
                                     bmbud06,bmbud07,bmbud08,bmbud09,bmbud10,
                                     bmbud11,bmbud12,bmbud13,bmbud14,bmbud15

                  FROM s_bmb[1].bmb02,s_bmb[1].bmb30,s_bmb[1].bmb03,s_bmb[1].bmb09, #FUN-5A0051 add bmb30
                       s_bmb[1].bmb16,s_bmb[1].bmb14,s_bmb[1].bmb04,
                       s_bmb[1].bmb05,s_bmb[1].bmb06,s_bmb[1].bmb07,
                       s_bmb[1].bmb10,s_bmb[1].bmb08,s_bmb[1].bmb081,s_bmb[1].bmb082,  #No.FUN-A50089  add bmb081,bmb082
                       s_bmb[1].bmb19,s_bmb[1].bmb24,s_bmb[1].bmb31, #FUN-810014  add bmb13   #FUN-870127 reduce bmb13 #TQC-C60097
                       s_bmb[1].bmbud01,s_bmb[1].bmbud02,s_bmb[1].bmbud03,
                       s_bmb[1].bmbud04,s_bmb[1].bmbud05,s_bmb[1].bmbud06,
                       s_bmb[1].bmbud07,s_bmb[1].bmbud08,s_bmb[1].bmbud09,
                       s_bmb[1].bmbud10,s_bmb[1].bmbud11,s_bmb[1].bmbud12,
                       s_bmb[1].bmbud13,s_bmb[1].bmbud14,s_bmb[1].bmbud15
                  BEFORE CONSTRUCT
                     CALL cl_qbe_display_condition(lc_qbe_sn)

                  ON ACTION CONTROLP
                     CASE
                        WHEN INFIELD(bmb03) #料件主檔
#FUN-AA0059 --Begin--
                     #        CALL cl_init_qry_var()
                     #        LET g_qryparam.form = "q_ima"
                     #        LET g_qryparam.state = 'c'
                     #        CALL cl_create_qry() RETURNING g_qryparam.multiret
                             CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                             DISPLAY g_qryparam.multiret TO bmb03
                             NEXT FIELD bmb03
                        WHEN INFIELD(bmb09) #作業主檔
                             CALL q_ecd(TRUE,TRUE,g_bmb[1].bmb09)
                                    RETURNING g_qryparam.multiret
                               DISPLAY g_qryparam.multiret TO bmb09
                               NEXT FIELD bmb09
                        WHEN INFIELD(bmb10) #單位檔
                             CALL cl_init_qry_var()
                             LET g_qryparam.form = "q_gfe"
                             LET g_qryparam.state = 'c'
                             CALL cl_create_qry() RETURNING g_qryparam.multiret
                             DISPLAY g_qryparam.multiret TO bmb10
                             NEXT FIELD bmb10

                        OTHERWISE EXIT CASE
                     END  CASE

                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                     CONTINUE CONSTRUCT

                  ON ACTION about         #MOD-4C0121
                     CALL cl_about()      #MOD-4C0121

                  ON ACTION help          #MOD-4C0121
                     CALL cl_show_help()  #MOD-4C0121

                  ON ACTION controlg      #MOD-4C0121
                     CALL cl_cmdask()     #MOD-4C0121

                  ON ACTION qbe_save
                     CALL cl_qbe_save()
             END CONSTRUCT
             IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
             IF INT_FLAG THEN RETURN END IF
          ELSE
             CONSTRUCT g_wc2 ON bmb02,bmb30,bmb03,bmb09,bmb16,bmb14, #FUN-5A0051 add bmb30
                                bmb06,bmb07,bmb10,bmb08,bmb081,bmb082,bmb19,bmb24,bmb31,   #FUN-810014 add bmb13  #FUN-870127 reduce bmb13   #No.FUN-A50089  add bmb081,bmb082 #TQC-C60097
                                bmbud01,bmbud02,bmbud03,bmbud04,bmbud05,
                                bmbud06,bmbud07,bmbud08,bmbud09,bmbud10,
                                bmbud11,bmbud12,bmbud13,bmbud14,bmbud15
                  FROM s_bmb[1].bmb02,s_bmb[1].bmb30,s_bmb[1].bmb03,s_bmb[1].bmb09, #FUN-5A0051 add bmb30
                       s_bmb[1].bmb16,s_bmb[1].bmb14,s_bmb[1].bmb06,
                       s_bmb[1].bmb07,s_bmb[1].bmb10,s_bmb[1].bmb08,s_bmb[1].bmb081,s_bmb[1].bmb082,  #No.FUN-A50089  add bmb081,bmb082
                       s_bmb[1].bmb19,s_bmb[1].bmb24,s_bmb[1].bmb31,  #FUN-810014  add bmb13       #FUN-870127 reduce bmb13 #TQC-C60097
                       s_bmb[1].bmbud01,s_bmb[1].bmbud02,s_bmb[1].bmbud03,
                       s_bmb[1].bmbud04,s_bmb[1].bmbud05,s_bmb[1].bmbud06,
                       s_bmb[1].bmbud07,s_bmb[1].bmbud08,s_bmb[1].bmbud09,
                       s_bmb[1].bmbud10,s_bmb[1].bmbud11,s_bmb[1].bmbud12,
                       s_bmb[1].bmbud13,s_bmb[1].bmbud14,s_bmb[1].bmbud15
                  BEFORE CONSTRUCT
                     CALL cl_qbe_display_condition(lc_qbe_sn)
                  ON ACTION CONTROLP
                     CASE
                        WHEN INFIELD(bmb03) #料件主檔
#FUN-AA0059 --Begin--
                     #        CALL cl_init_qry_var()
                     #        LET g_qryparam.form = "q_ima"
                     #        LET g_qryparam.state = 'c'
                     #        CALL cl_create_qry() RETURNING g_qryparam.multiret
                             CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                             DISPLAY g_qryparam.multiret TO bmb03
                             NEXT FIELD bmb03
                        WHEN INFIELD(bmb09) #作業主檔
                             CALL q_ecd(TRUE,TRUE,g_bmb[1].bmb09)
                                    RETURNING g_qryparam.multiret
                               DISPLAY g_qryparam.multiret TO bmb09
                               NEXT FIELD bmb09
                        WHEN INFIELD(bmb10) #單位檔
                             CALL cl_init_qry_var()
                             LET g_qryparam.form = "q_gfe"
                             LET g_qryparam.state = 'c'
                             CALL cl_create_qry() RETURNING g_qryparam.multiret
                             DISPLAY g_qryparam.multiret TO bmb10
                             NEXT FIELD bmb10

                        OTHERWISE EXIT CASE
                     END  CASE

                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                     CONTINUE CONSTRUCT

                  ON ACTION about         #MOD-4C0121
                     CALL cl_about()      #MOD-4C0121

                  ON ACTION help          #MOD-4C0121
                     CALL cl_show_help()  #MOD-4C0121

                  ON ACTION controlg      #MOD-4C0121
                     CALL cl_cmdask()     #MOD-4C0121

                  ON ACTION qbe_save
                     CALL cl_qbe_save()
             END CONSTRUCT
        #  END IF #MOD-530690
             IF INT_FLAG THEN
                RETURN
             END IF
             IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
             IF NOT cl_null(g_vdate) THEN #MOD-590173
                LET  g_wc2 = g_wc2  clipped,
                         " AND (bmb04 <='", g_vdate,"'"," OR bmb04 IS NULL )",
                         " AND (bmb05 >  '",g_vdate,"'"," OR bmb05 IS NULL )" #BugNo:6032
             END IF
          END IF
        ###FUN-9A50010 START ###
       ELSE                                 #FUN-B90117         #FUN-C20105 unmark
          LET g_wc = l_wc CLIPPED           #FUN-B90117         #FUN-C20105 unmark
       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup') #FUN-980030

    #  IF p_idx = 0 THEN   #不是從tree點進來的，而是重新查詢時CONSTRUCT產生的原始查詢條件要備份  #FUN-CB0078
       IF p_idx = 0 AND g_action_choice = "query" THEN    #FUN-CB0078
          LET g_wc_o = g_wc CLIPPED
       END IF
          ###FUN-9A50010 END ###

    END IF
    
    
#FUN-C20105 --begin--
     IF cl_null(g_wc) THEN
        LET g_wc = " 1=1"
     END IF 
#FUN-C20105 --end--
    
    IF l_flag = 'N' THEN   # 若單身未輸入條件
       LET g_sql = "SELECT  bma01,bma06 FROM bma_inplan ",        #FUN-550014 add bma06
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1,2 " #FUN-550014
    ELSE     # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  bma01,bma06 ",      #FUN-550014 add bma06
                   "  FROM bma_inplan, bmb_inplan ",
                   " WHERE bma01 = bmb01",
                   "   AND bma06 = bmb29",                            #FUN-550014
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   " ORDER BY 1,2 " #FUN-550014
    END IF

    PREPARE i600_prepare FROM g_sql
    DECLARE i600_curs SCROLL CURSOR WITH HOLD FOR i600_prepare
    DECLARE i600_list_cur CURSOR FOR i600_prepare

    IF l_flag = 'N' THEN   # 取合乎條件筆數
        LET g_sql="SELECT COUNT(UNIQUE bma01||bma06) FROM bma_inplan WHERE ",g_wc CLIPPED   #MOD-9A0202
    ELSE
        LET g_sql="SELECT COUNT(UNIQUE bma01||bma06) FROM bma_inplan,bmb_inplan WHERE ",  #MOD-9A0202
                  "bmb01=bma01 AND bma06=bmb29 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF


    PREPARE i600_precount FROM g_sql
    DECLARE i600_count CURSOR FOR i600_precount
END FUNCTION

FUNCTION i600_menu()

   DEFINE
      l_cmd           LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(100),
      l_priv1         LIKE zy_file.zy03,       # 使用者執行權限
      l_priv2         LIKE zy_file.zy04,       # 使用者資料權限
      l_priv3         LIKE zy_file.zy05,       # 使用部門資料權限
      l_ima903        LIKE ima_file.ima903

  #MOD-C40062 str add-----
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #MOD-C40062 end add-----

   ###FUN-9A50010 START ###
   --DEFINE l_wc               STRING
   --DEFINE l_tree_arr_curr    LIKE type_file.num5
   --DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   --DEFINE l_i                LIKE type_file.num5
   --DEFINE l_tok              base.StringTokenizer
   ###FUN-9A50010 END ###
    IF s_industry("slk") THEN
      CALL cl_getmsg("abm-603",2) RETURNING g_msg
      CALL i600_set_act_title("insert_loc",g_msg)
      CALL i600_set_act_title("create_loc_data",g_msg)
    END IF

   WHILE TRUE

      IF cl_null(g_bp_flag) OR g_bp_flag <> 'list' THEN
         CALL i600_bp("G")
      ELSE
         CALL i600_bp1("G")
      END IF

      IF g_bp_flag = 'list' AND l_ac1>0 THEN #將清單的資料回傳到主畫面
         SELECT bma_inplan.*
           INTO g_bma.*
           FROM bma_inplan
          WHERE bma01=g_bma_l[l_ac1].bma01_l
            AND bma06=g_bma_l[l_ac1].bma06_l
      END IF


      CASE g_action_choice

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               LET g_a_flag = 'Y'       #FUN-CB0078 
               CALL i600_a()
               LET g_a_flag = 'N'       #FUN-CB0078 
               LET g_tree_item = ''     #FUN-CB0078
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_wc='' #MOD-530690
            #FUN-CB0078 ------Begin-------
            #  IF g_lock = 'Y' THEN              #TQC-C70069 add
            #     CALL cl_err('','abm-094',0)    #TQC-C70069 add
            #  ELSE                              #TQC-C70069 add
            #     CALL i600_q(0)
            #  END IF
            #FUN-CB0078 ------End---------
               CALL i600_q(0)     #FUN-CB0078 add
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i600_r()
               LET g_bp_flag = "main"
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i600_u()
               LET g_bp_flag = "main"
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i600_x()
               CALL i600_show()
               #MOD-840104
            END IF

 #FUN-B90117--Begin--
          WHEN "tree"
            CALL i600_q(0)
            LET g_tree_item = ''      #FUN-CB0078 add
            LET g_action_choice=''
#FUN-B90117--end--

#FUN-CB0078 ------Begin------
##FUN-C20105 --begin--
#          WHEN "lock"
#            IF cl_chk_act_auth() THEN
#               CALL i600_lock()
#            END IF         
##FUN-C20105 --begin--
#FUN-CB0078 ------End--------

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                CALL i600_copy() #ROLLBACK WORK #MOD-530690
                LET g_bp_flag = "main"
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               #FUN-A70134---mod---str----
               #CALL i600_confirm()
LET  g_success='Y'  
#             CALL i600sub_y_chk(g_bma.bma01,g_bma.bma06)
                IF g_success = 'Y' THEN
                   IF g_bma.bma10 = '2' THEN         #MOD-A90182 add
                      CALL cl_err('','abm-123',0)    #MOD-A90182 add
                   ELSE                              #MOD-A90182 add
              #       IF cl_confirm('axm-108') THEN  #CHI-C30107 mark
                          BEGIN WORK
INSERT INTO BMA_FILE SELECT * FROM BMA_INPLAN WHERE bma01=g_bma.bma01
UPDATE BMA_FILE SET BMA05=NULL ,BMA10='0'   WHERE bma01=g_bma.bma01
INSERT INTO BMB_FILE SELECT * FROM BMB_INPLAN WHERE bmb01=g_bma.bma01
#INSERT INTO ECU_FILE SELECT * FROM ECU_INPLAN WHERE ecu01=g_bma.bma01
#INSERT INTO ECB_FILE SELECT * FROM ECB_INPLAN WHERE ecb01=g_bma.bma01



UPDATE  BMA_INPLAN  SET BMA10='1' WHERE  bma01=g_bma.bma01
LET g_bma.bma10=1
                           # CALL i600sub_y_upd(g_bma.bma01,g_bma.bma06)
                          IF g_success = 'Y' THEN
                              COMMIT WORK
#                              CALL i600sub_refresh(g_bma.bma01,g_bma.bma06) RETURNING g_bma.*
                          ELSE
                              ROLLBACK WORK
                          END IF
              #       END IF           #CHI-C30107 mark
                   END IF     #MOD-A90182 add
                END IF
                CALL i600_show()
               #FUN-A70134---mod---end----
                LET g_bp_flag = "main"
            END IF
         WHEN "unconfirm"
           IF cl_chk_act_auth() THEN
               CALL i600_unconfirm()
               LET g_bp_flag = "main"
           END IF
         WHEN "unrelease"
           IF cl_chk_act_auth() THEN
               CALL i600_unrelease()
               LET g_bp_flag = "main"
           END IF
         WHEN "fix"
           IF cl_chk_act_auth() THEN
            IF l_ac >0 THEN
            CALL i600_a_fix_sx(g_bma.bma10,g_bmb[l_ac].bmb03,g_bma.bma01,p_md,g_bma.bma06)    #NO.FUN-840155
            LET g_bp_flag = "main"
            END IF
           END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
#FUN-CB0078 ------Begin-------
#FUN-C20105 --begin--            
#              IF g_lock = 'N' THEN         
#                 #CALL cl_err('','abm-083',1)  #MOD-C30530 mark
#                 #CALL cl_err('','abm-083',0)  #MOD-C30530 add  #MOD-C30413 mark
#                 CALL cl_err('','abm-095',0)   #MOD-C30413 add
#              ELSE    
#FUN-C20105 --end--           
#FUN-CB0078 ------End--------      
               CALL i600_b()
               IF g_ima08_h = 'A' AND g_bma.bma01 IS NOT NULL THEN
                  CALL p500_tm(0,0,g_bma.bma01)      #主件為family
               END IF
               LET g_bp_flag = "main"
#             END IF              #FUN-C20105        #FUN-CB0078   mark       
            END IF
            #LET g_action_choice = ""  #FUN-D40030 mark

        #str-----add by guanyao160706
        WHEN "e_work"
           IF cl_chk_act_auth() THEN
               CALL i600_e_work()
               #CALL i600_e_work_dhy()
               LET g_bp_flag = "main"
           END IF
        #end-----add by guanyao160706
            
         WHEN "help"
            CALL cl_show_help()
            LET g_bp_flag = "main"
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_bp_flag = "main"
         WHEN "bom_release"
            IF cl_chk_act_auth() THEN
              #FUN-AA0018---mod---str---
              #CALL i600_j()
               CALL i600sub_j_chk(g_bma.bma01,g_bma.bma06)
               IF g_success = 'Y' THEN
                   CALL i600sub_j_input() RETURNING g_bma.bma05
                   IF INT_FLAG THEN
                      LET g_bma.bma05=NULL
                      DISPLAY BY NAME g_bma.bma05
                      LET INT_FLAG=0
                      #RETURN   #TQC-C20149   mark
                   #END IF      #TQC-C20149   mark
                   ELSE         #TQC-C20149
                      DISPLAY BY NAME g_bma.bma05
                      BEGIN WORK
                      CALL i600sub_j_upd(g_bma.bma01,g_bma.bma06,g_bma.bma05)
                      IF g_success = 'Y' THEN
                          COMMIT WORK
                          CALL i600sub_refresh(g_bma.bma01,g_bma.bma06) RETURNING g_bma.*
                      ELSE
                          ROLLBACK WORK
                      END IF
                   END IF       #TQC-C20149
                   CALL i600sub_carry(g_bma.bma01,g_bma.bma06)
               END IF
              #FUN-AA0018---mod---end---
               CALL i600_show()     #MOD-840104 add
               LET g_bp_flag = "main"
            END IF
       #@WHEN "插件位置"
         WHEN "insert_loc"
            LET l_cmd = "abmi601 '",g_bma.bma01,"' ",
                                "'",g_bma.bma06,"' ", #FUN-550014 add bma06
                                "'",g_vdate,"' ",
                                " '' "                #No.FUN-870127
             CALL cl_cmdrun_wait(l_cmd) #MOD-4C0128
            CALL i600_show()
            LET g_bp_flag = "main"
       #@WHEN "廠牌"
         WHEN "brand"
            LET l_cmd = "abmq630 '",g_bma.bma01,"' '",g_bma.bma06,"' " #FUN-560107
            CALL cl_cmdrun(l_cmd)
            LET g_bp_flag = "main"
       #@WHEN "取替代"
         WHEN "rep_sub"
            #CHI-C20058---begin
            #LET l_cmd = "abmi6042 '",g_bma.bma01,"'"
            LET l_cmd = "abmi6042 '",g_bma.bma01,"' '",g_bmb[l_ac].bmb03,"'"
            #CHI-C20058---end
            CALL cl_cmdrun_wait(l_cmd)
            IF NOT (g_wc2 IS NULL) THEN
               CALL i600_b_fill(g_wc2)                 #單身
               CALL i600_show()
               LET g_bp_flag = "main"
            END IF
       #@WHEN "明細單身"
         WHEN "contents"
            IF cl_chk_act_auth() THEN   #No.MOD-750114 add
             IF l_ac > 0 THEN           #No.MOD-A30038 add
               LET l_cmd = "abmi605 "," '",g_bma.bma01,"'",
                           " '",g_vdate,"' '",g_bma.bma06,"' ", #FUN-560107 加 g_bma.bma06
                           " '",g_bmb[l_ac].bmb03,"'"          #No.MOD-780015 add
               CALL cl_cmdrun(l_cmd)
                  IF g_wc2 IS NULL THEN
                     LET g_wc2 = " 1= 1"
                  END IF
               CALL i600_b_fill(g_wc2)                 #單身
               LET g_bp_flag = "main"
             END IF                     #No.MOD-A30038 add
            END IF                      #No.MOD-750114 add
       #@WHEN "偵測"
         WHEN "debug"
            IF cl_chk_act_auth() THEN
               LET l_cmd="abmp610 x '",g_bma.bma01,"'"
               CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
               LET g_bp_flag = "main"
            END IF
         #FUN-C30028---begin
         WHEN "hide_tree"
            IF g_hide = 'N' THEN
               CALL cl_set_comp_visible("tree1",FALSE)
               LET g_hide = 'Y'
            ELSE
               CALL cl_set_comp_visible("tree1",TRUE)
               LET g_hide = 'N'
            END IF 
         #FUN-C30028---end
       #@WHEN "產生族群料件連結"
         WHEN "gen_group_link"
            IF g_ima08_h = 'A' AND g_bma.bma01 IS NOT NULL THEN
               CALL p500_tm(0,0,g_bma.bma01)
            ELSE
               CALL cl_err(g_bma.bma01,'mfg2634',0)
            END IF
            LET g_bp_flag = "main"
       #FUN-AC0076 add --------------begin---------------
       #@WHEN "分量耗損"
         WHEN "haosun"
            IF cl_chk_act_auth() THEN
               LET l_cmd = "abmi612 '",g_bma.bma01,"'"
               CALL cl_cmdrun_wait(l_cmd)
            END IF
       #FUN-AC0076 add ---------------end----------------
       WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_bma.bma01 IS NOT NULL THEN
                LET g_doc.column1 = "bma01"
                LET g_doc.value1  = g_bma.bma01
                CALL cl_doc()
                LET g_bp_flag = "main"
             END IF
          END IF

        WHEN "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
             # CALL i600_carry()        #FUN-B10013
               CALL s_abmi600_com_carry(g_bma.bma01,g_bma.bma06,g_bma.bma10,g_plant,1)    #FUN-B10013
             # ERROR ""     #TQC-AC0162 mark
               LET g_bp_flag = "main"
            END IF

         WHEN "download"
            IF cl_chk_act_auth() THEN
               CALL i600_download()
               LET g_bp_flag = "main"
            END IF

         WHEN "qry_carry_history"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_bma.bma01) THEN  #No.FUN-830090
                  IF NOT cl_null(g_bma.bma08) THEN
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '2' AND gev02 = g_bma.bma08
                  ELSE      #歷史資料,即沒有ima916的值
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '2' AND gev02 = g_plant
                  END IF
                  IF NOT cl_null(g_gev04) THEN
                     LET l_cmd='aooq604 "',g_gev04,'" "2" "',g_prog,'" "',g_bma.bma01,'"'
                     CALL cl_cmdrun(l_cmd)
                  END IF
               ELSE
                  CALL cl_err('',-400,0)
               END IF
               LET g_bp_flag = "main"
            END IF

       #@WHEN "APS相關資料"
         WHEN "aps_related_data"
            IF cl_chk_act_auth() THEN #FUN-720043 add if 判斷
                IF NOT cl_null(g_bma.bma01) THEN  #TQC-750013 add if 判斷
                    CALL i600_aps_bmb()
                    #LET l_cmd = "apsi200 ","'", g_bma.bma01,"'"
                    LET l_cmd = "apsi313 ","'", g_bma.bma01,"'"   #FUN-7C0002 add
                    CALL cl_cmdrun(l_cmd)
                ELSE
                    CALL cl_err('',-400,1)
                END IF
                LET g_bp_flag = "main"
            END IF
       #@WHEN "聯產品"
         WHEN "contract_product"
            LET l_ima903 = NULL
            SELECT ima903 INTO l_ima903 FROM ima_file
            WHERE ima01 = g_bma.bma01
               IF cl_chk_act_auth() THEN
                  IF NOT cl_null(g_bma.bma01) AND (g_sma.sma104 = 'Y' AND l_ima903 = 'Y') THEN
                     LET l_cmd = "abmi608 '",g_bma.bma01,"'"
                     CALL cl_cmdrun(l_cmd)
                  ELSE
                     #此料號不可執行聯產品功能!
                     CALL cl_err(g_bma.bma01,'abm-600',0)
                  END IF
                  LET g_bp_flag = "main"
               END IF
       #@WHEN "BOM 說明"
         WHEN "bom_description"
            IF cl_chk_act_auth() THEN
               LET l_cmd="abmi603 '",g_bma.bma01,"' ","'' '' '' ", #FUN-550014
                                 #"'",g_bma.bma06,"'"               #FUN-550014
                                 "'",g_bma.bma06,"' '",g_vdate,"'" #MOD-940293 add
               CALL cl_cmdrun(l_cmd)
               LET g_bp_flag = "main"
            END IF
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bma.bma01 IS NOT NULL THEN
                  LET g_doc.column1 = "bma01"
                  LET g_doc.value1  = g_bma.bma01
                  CALL cl_doc()
               END IF
               LET g_bp_flag = "main"
            END IF

         WHEN "preview_bom"
            IF cl_chk_act_auth() THEN
              CALL preview_bom_test()
              LET g_bp_flag = "main"
            END IF

         WHEN "edit_formula"
            CALL cl_set_act_visible("edit_formula", FALSE)
            LET g_bp_flag = "main"


         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
             #MOD-C40062 str add------
             #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
              LET w = ui.Window.getCurrent()
              LET f = w.getForm()
              LET page = f.FindNode("Table","s_bmb")
              CALL cl_export_to_excel(page,base.TypeInfo.create(g_bmb),'','')
             #MOD-C40062 end add-----
              LET g_bp_flag = "main"
            END IF

         #str----add by guanyao160719
         WHEN "aec"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_bma.bma01) THEN 
                  LET l_cmd = "aeci100 '",g_bma.bma01,"'"
                  CALL cl_cmdrun_wait(l_cmd)
               END IF 
            END IF 
         #end----add by guanyao160719 
         #No:FUN-B70096 --START--
          WHEN "sfa_pro"
            IF cl_chk_act_auth() THEN
               CALL tc_sfa_pro()
               #CALL tc_sfa_pl()
            END IF 
            
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #CALL i600_out() #mark by guanyao160811
               CALL i600_out1()
            END IF
         #No:FUN-B70096 --END--
      END CASE
   END WHILE
END FUNCTION


#Add  輸入
FUNCTION i600_a()

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
   #IF g_lock = 'N' THEN                #FUN-C20105   #FUN-CB0078 mark 
    IF cl_null(g_tree_item) THEN        #FUN-CB0078 add
      CLEAR FORM
    END IF                              #FUN-C20105 

#FUN-C20105 --begin-- 
   #IF g_lock='N' THEN                  #FUN-CB0078 mark 
    IF cl_null(g_tree_item) THEN        #FUN-CB0078 add
      CALL g_tree1.clear()
     END IF
#FUN-C20105 --end--    
      
    CALL g_bmb.clear()
    INITIALIZE g_bma.* LIKE bma_inplan.*             #DEFAULT 設定
    LET g_vdate = g_today   #MOD-980210   #No:MOD-A10148 modify
    LET g_bma01_t = NULL
    LET g_bma06_t = NULL     #FUN-550014 add
    #預設值及將數值類變數清成零
    LET g_bma_t.* = g_bma.*
    LET g_bma_o.* = g_bma.*
    CALL cl_opmsg('a')
    WHILE TRUE
#FUN-C20105 --begin--    
##FUN-B90117--BEGIN--
#        IF g_tree_arr_curr > 0 THEN
#          LET g_bma.bma01=g_tree1[g_tree_arr_curr].treekey4
#        END IF
##FUN-B90117--END--

#锁定状态时输入料号默认带树状图所选料号
      # IF g_lock='Y' AND g_tree_arr_curr > 0 THEN                   #FUN-CB0078 mark 
        IF NOT cl_null(g_tree_item) AND g_tree_arr_curr > 0 THEN     #FUN-CB0078  
          LET g_bma.bma01=g_tree1[g_tree_arr_curr].treekey4
        END IF         
#FUN-C20105 --end--
        LET g_bma.bmauser=g_user
        LET g_bma.bmaoriu = g_user #FUN-980030
        LET g_bma.bmaorig = g_grup #FUN-980030
        LET g_bma.bma10 = 0       #NO.FUN-810014
        LET g_bma.bmagrup=g_grup
        LET g_bma.bmadate=g_today
        LET g_bma.bmaacti='Y'              #資料有效
        LET g_bma.bma08=g_plant            #No.FUN-7C0010
        LET g_bma.bma09=0                  #No.FUN-7C0010
        LET g_bma.bma06=' '
        LET g_confirm = 'N'                #No.FUN-830121
        IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'a') THEN
           CALL cl_err(g_bma.bma08,'aoo-078',1)
           RETURN
        END IF
           LET g_bma.bma06 = ' '           #FUN-550014 add 特性代碼
        CALL i600_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_bma.* TO NULL
            LET INT_FLAG = 0
            LET g_bp_flag ="main"
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bma.bma01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_bma.bma06 IS NULL THEN                # KEY 不可空白
            LET g_bma.bma06 = ' '
        END IF
        SELECT count(*) INTO g_cnt FROM bma_inplan
            WHERE bma01 = g_bma.bma01
              AND bma06 = g_bma.bma06 #FUN-550014 add
        IF g_cnt > 0 THEN   #資料重復
            CALL cl_err('',-239,1)
            CONTINUE WHILE
        END IF
        IF cl_null(g_bma.bma10) THEN
           LET g_bma.bma10 = '0'
        END IF
        INSERT INTO bma_inplan VALUES (g_bma.*)
        IF SQLCA.sqlcode THEN      #置入資料庫不成功
            CALL cl_err3("ins","bma_inplan",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","",1)  #No.TQC-660046
            CONTINUE WHILE
        END IF
        SELECT bma01,bma06 INTO g_bma.bma01,g_bma.bma06 FROM bma_inplan
            WHERE bma01 = g_bma.bma01
              AND bma06 = g_bma.bma06   #FUN-550014 add
        LET g_bma01_t = g_bma.bma01        #保留舊值
        LET g_bma06_t = g_bma.bma06        #保留舊值 #FUN-550014 add
        LET g_bma_t.* = g_bma.*
        CALL g_bmb.clear()
        LET g_rec_b = 0
        CALL i600_b()                   #輸入單身
        IF g_ima08_h = 'A' AND g_aflag = 'Y' THEN      #主件為family 時
           CALL p500_tm(0,0,g_bma.bma01)
        END IF
        CASE aws_mdmdata('bma_inplan','insert',g_bma.bma01,base.TypeInfo.create(g_bma),'CreateBOMData') #FUN-890113
           WHEN 0  #無與 MDM 整合
                MESSAGE 'INSERT O.K'
           WHEN 1  #呼叫 MDM 成功
                MESSAGE 'INSERT O.K, INSERT MDM O.K'
           WHEN 2  #呼叫 MDM 失敗
                ROLLBACK WORK
                CONTINUE WHILE
        END CASE

        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i600_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_bma.bma01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
       CALL cl_err(g_bma.bma08,'aoo-045',1)
       RETURN
    END IF
    IF g_bma.bmaacti ='N' THEN    #資料若為無效,仍可更改.   #TQC-6C0028
        CALL cl_err(g_bma.bma01,'mfg1000',0) RETURN         #TQC-6C0028
    END IF                                                  #TQC-6C0028
    IF g_bma.bma10 <> '0' THEN
          CALL cl_err('','aim1006',0)
          RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bma01_t = g_bma.bma01
    LET g_bma06_t = g_bma.bma06 #FUN-550014 add
    BEGIN WORK

    LET g_tree_upd = g_tree1[1].treekey4      #FUN-CB0078
    OPEN i600_cl USING g_bma.bma01,g_bma.bma06
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_bma.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i600_cl
         ROLLBACK WORK #MOD-4B0218
        RETURN
    END IF
    CALL i600_show()
    WHILE TRUE
        LET g_bma01_t = g_bma.bma01
        LET g_bma06_t = g_bma.bma06  #FUN-550014 add
        LET g_bma.bmamodu=g_user
        LET g_bma.bmadate=g_today
        CALL i600_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bma.*=g_bma_t.*
            CALL i600_show()
            CALL cl_err('','9001',0)
            LET g_bp_flag ="main"
            EXIT WHILE
        END IF
        IF (g_bma.bma01 != g_bma01_t) OR (g_bma.bma06 != g_bma06_t) THEN            # 更改單號 #FUN-550014
            UPDATE bmb_inplan SET bmb01 = g_bma.bma01,
                                bmb29 = g_bma.bma06, #FUN-550014 add
                                bmbdate=g_today     #FUN-C40007 add
                WHERE bmb01 = g_bma01_t
                  AND bmb29 = g_bma06_t  #FUN-550014 add
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","bmb_inplan",g_bma01_t,g_bma06_t,SQLCA.sqlcode,"","bmb",1)  #No.TQC-660046
                CONTINUE WHILE
            ELSE #新增料件時系統參數(sma18 低階碼是重新計算)
                 UPDATE sma_file SET sma18 = 'Y' WHERE sma00 = '0'
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","cannot update sma_file",1)  #No.TQC-660046
                 END IF
            END IF
           IF s_industry('slk') THEN
            UPDATE bmv_file SET bmv01 = g_bma.bma01,
                                bmv03 = g_bma.bma06
              WHERE bmv01 = g_bma01_t
                AND bmv03 = g_bma06_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","bmv_file",g_bma01_t,g_bma06_t,SQLCA.sqlcode,"","bmv",1)
                CONTINUE WHILE
            END IF
           END IF
        END IF
        UPDATE bma_inplan SET bma_inplan.* = g_bma.*
           #WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06  #MOD-C70220 mark
            WHERE bma01=g_bma01_t AND bma06=g_bma06_t      #MOD-C70220 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","bma_inplan",g_bma01_t,g_bma06_t,SQLCA.sqlcode,"","",1)  #No.TQC-660046
            CONTINUE WHILE
        END IF
        CALL i600_list_fill()

        CASE aws_mdmdata('bma_inplan','update',g_bma.bma01,base.TypeInfo.create(g_bma),'CreateBOMData')
           WHEN 0  #無與 MDM 整合
                MESSAGE 'UPDATE O.K'
           WHEN 1  #呼叫 MDM 成功
                MESSAGE 'UPDATE O.K, UPDATE MDM O.K'
           WHEN 2  #呼叫 MDM 失敗
                ROLLBACK WORK
                BEGIN WORK
                CONTINUE WHILE
        END CASE

        EXIT WHILE
    END WHILE
    CLOSE i600_cl
    COMMIT WORK
END FUNCTION

#處理INPUT
FUNCTION i600_i(p_cmd)
DEFINE
    p_cmd     LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1),    #a:輸入 u:更改
    l_cmd     LIKE type_file.chr50,     #No.FUN-680096 VARCHAR(40)
    l_ima140  LIKE ima_file.ima140
    
    DISPLAY BY NAME g_bma.bma05,g_bma.bma10,g_bma.bmauser,g_bma.bmamodu,   # NO.FUN-810014 bma10
        g_bma.bmagrup,g_bma.bmadate,g_bma.bmaacti
    DISPLAY BY NAME g_bma.bma08        #No.FUN-7C0010

    DISPLAY BY NAME g_bma.bma01        #FUN-B90117

    CALL cl_set_head_visible("","YES") #No.FUN-6B0033
    INPUT BY NAME g_bma.bmaoriu,g_bma.bmaorig,
        g_bma.bma01,g_bma.bma06,g_bma.bma10,g_bma.bma04,  #FUN-550014  #No.FUN-810014 add bma10
        g_bma.bmaud01,g_bma.bmaud02,g_bma.bmaud03,g_bma.bmaud04,
        g_bma.bmaud05,g_bma.bmaud06,g_bma.bmaud07,g_bma.bmaud08,
        g_bma.bmaud09,g_bma.bmaud10,g_bma.bmaud11,g_bma.bmaud12,
        g_bma.bmaud13,g_bma.bmaud14,g_bma.bmaud15
        WITHOUT DEFAULTS
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i600_i_set_entry(p_cmd)
            CALL i600_i_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            IF g_sma.sma09 = 'N' THEN
               CALL cl_set_act_visible("create_item_master", FALSE)
            ELSE
               CALL cl_set_act_visible("create_item_master", TRUE)
            END IF

        BEFORE FIELD bma01
            IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN
               NEXT FIELD bma04
            END IF
     IF g_sma.sma60 = 'Y'  # 若須分段輸入
        THEN CALL s_inp5(6,11,g_bma.bma01) RETURNING g_bma.bma01
             DISPLAY BY NAME g_bma.bma01
     END IF

        AFTER FIELD bma01                         #主件料號
            IF NOT cl_null(g_bma.bma01) THEN
            
            SELECT ima140 INTO l_ima140 FROM ima_file WHERE ima01=g_bma.bma01
            IF l_ima140='Y' THEN
               CALL cl_err(g_bma.bma01,'aim-045',1)
               NEXT FIELD bma01            
            END IF 
               #FUN-AA0059 ----------------------------add start---------------------------
               IF NOT s_chk_item_no(g_bma.bma01,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_bma.bma01 = g_bma_o.bma01
                  DISPLAY BY NAME g_bma.bma01
                  NEXT FIELD bma01
               END IF
               #FUN-AA0059 ----------------------------add start----------------------------
               CALL s_field_chk(g_bma.bma01,'2',g_plant,'bma01') RETURNING g_flag2
               IF g_flag2 = '0' THEN
                  CALL cl_err(g_bma.bma01,'aoo-043',1)
                  LET g_bma.bma01 = g_bma_o.bma01
                  DISPLAY BY NAME g_bma.bma01
                  NEXT FIELD bma01
               END IF
                IF g_sma.sma118 != 'Y' THEN #FUN-550014 add if 判斷
                   IF g_bma.bma01 != g_bma01_t OR g_bma01_t IS NULL THEN
                       SELECT count(*) INTO g_cnt FROM bma_inplan
                           WHERE bma01 = g_bma.bma01
                             AND bma06 = g_bma.bma06 #FUN-550014 add
                       IF g_cnt > 0 THEN   #資料重復
                           CALL cl_err(g_bma.bma01,-239,0)
                           LET g_bma.bma01 = g_bma01_t
                           DISPLAY BY NAME g_bma.bma01
                           NEXT FIELD bma01
                       END IF
                   END IF
                ELSE
                   IF NOT cl_null(g_bma.bma06) AND
                      ((g_bma.bma01 != g_bma01_t OR g_bma01_t IS NULL) OR
                      (g_bma.bma06 != g_bma06_t OR g_bma06_t IS NULL)) THEN
                       SELECT count(*) INTO g_cnt FROM bma_inplan
                           WHERE bma01 = g_bma.bma01
                             AND bma06 = g_bma.bma06 #FUN-550014 add
                       IF g_cnt > 0 THEN   #資料重復
                           CALL cl_err('',-239,0)
                           LET g_bma.bma01 = g_bma01_t
                           LET g_bma.bma06 = g_bma06_t
                           DISPLAY BY NAME g_bma.bma01
                           DISPLAY BY NAME g_bma.bma06
                           NEXT FIELD bma01
                       END IF
                   END IF
                END IF
                IF g_bma.bma01 != g_bma01_t OR g_bma01_t IS NULL THEN      #No.TQC-6B0181
                   CALL i600_bma01('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_bma.bma01,g_errno,0)
                      LET g_bma.bma01 = g_bma_o.bma01
                      DISPLAY BY NAME g_bma.bma01
                      NEXT FIELD bma01
                   END IF
                END IF      #No.TQC-6B0181

            END IF
        AFTER FIELD bma06                         #特性代碼
               IF cl_null(g_bma.bma06) THEN
                   LET g_bma.bma06 = ' '
               END IF
            IF NOT cl_null(g_bma.bma01) AND NOT cl_null(g_bma.bma06) AND g_sma.sma118 = 'Y' THEN      #No.TQC-6B0181
                IF (g_bma.bma01 != g_bma01_t OR g_bma01_t IS NULL) OR
                   (g_bma.bma06 != g_bma06_t OR g_bma06_t IS NULL) THEN
                    SELECT count(*) INTO g_cnt FROM bma_inplan
                        WHERE bma01 = g_bma.bma01
                          AND bma06 = g_bma.bma06 #FUN-550014 add
                    IF g_cnt > 0 THEN   #資料重復
                        CALL cl_err('',-239,0)
                        LET g_bma.bma01 = g_bma01_t
                        LET g_bma.bma06 = g_bma06_t
                        DISPLAY BY NAME g_bma.bma01
                        DISPLAY BY NAME g_bma.bma06
                        NEXT FIELD bma01
                    END IF
                END IF
            END IF
            NEXT FIELD  bma10                              #NO.FUN-810014
        AFTER FIELD bmaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF


        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913



        ON ACTION CONTROLR
            CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP     #查詢條件
            CASE
               WHEN INFIELD(bma01) #料件主檔
#FUN-AA0059 --Begin--
               #     CALL cl_init_qry_var()
               #     #LET g_qryparam.form = "q_ima"     #No.TQC-AA0076
               #     LET g_qryparam.form = "q_ima_1"    #No.TQC-AA0076
               #     LET g_qryparam.default1 = g_bma.bma01
               #     CALL cl_create_qry() RETURNING g_bma.bma01
                    CALL q_sel_ima(FALSE, "q_ima_1", "", g_bma.bma01, "", "", "", "" ,"",'' )  RETURNING g_bma.bma01
#FUN-AA0059 --End--
                    DISPLAY BY NAME g_bma.bma01
                    NEXT FIELD bma01
               OTHERWISE EXIT CASE
             END CASE

        ON ACTION create_item_master   #建立料建資料
             IF g_sma.sma09 = 'Y' THEN
                IF s_industry('slk') THEN LET l_cmd = "aimi100_slk '",g_bma.bma01,"'" END IF
                IF s_industry('icd') THEN LET l_cmd = "aimi100_icd '",g_bma.bma01,"'" END IF
                IF s_industry('std') THEN LET l_cmd = "aimi100 '",g_bma.bma01,"'" END IF
                IF cl_null(l_cmd) THEN LET l_cmd = "aimi100 '",g_bma.bma01,"'" END IF
                CALL cl_cmdrun(l_cmd)
                NEXT FIELD bma01
             ELSE
                CALL cl_err(' ','asm-625',0)
                NEXT FIELD bma01
             END IF

      ON ACTION fix
         LET g_action_choice = "fix"
            CALL i600_a_fix_sx(g_bma.bma10,g_bmb[l_ac].bmb03,g_bma.bma01,p_md,g_bma.bma06)  #NO.FUN-840155
          CALL cl_on_idle()
          CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

    END INPUT
END FUNCTION

FUNCTION i600_bma01(p_cmd)  #主件料件
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680096  VARCHAR(01),
           l_bmz01   LIKE bmz_file.bmz01,
           l_bmz03   LIKE bmz_file.bmz03,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima55   LIKE ima_file.ima55,
           l_ima05   LIKE ima_file.ima05,
           l_imaacti LIKE ima_file.imaacti,
           l_imaud07 LIKE ima_file.imaud07,
           l_imaud10 LIKE ima_file.imaud10,
           l_imaud06  LIKE ima_file.imaud06

    LET g_errno = ' '
    SELECT  ima02,ima021,ima55, ima08,imaacti,ima05,imaud07,imaud10,imaud06
       INTO l_ima02,l_ima021,l_ima55, g_ima08_h,l_imaacti,
            l_ima05,l_imaud07,l_imaud10,l_imaud06
       FROM ima_file
      WHERE ima01 = g_bma.bma01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                            LET l_ima02 = NULL LET l_ima021 = NULL
                            LET l_ima55 = NULL LET g_ima08_h = NULL
                            LET l_imaacti = NULL
                            LET l_ima05=NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    #--->來源碼為'Z':雜項料件
    IF g_ima08_h ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02   TO FORMONLY.ima02_h
           DISPLAY l_ima021  TO FORMONLY.ima021_h
           DISPLAY g_ima08_h TO FORMONLY.ima08_h
           DISPLAY l_ima55   TO FORMONLY.ima55
           DISPLAY l_ima05   TO FORMONLY.ima05_h
           DISPLAY l_imaud07  TO FORMONLY.imaud07
           DISPLAY l_imaud10  TO FORMONLY.imaud10
           DISPLAY l_imaud06  TO FORMONLY.imaud06
    END IF
END FUNCTION

#Query 查詢
FUNCTION i600_q(p_idx)   #FUN-9A50010 加參數p_idx
    DEFINE p_idx  LIKE type_file.num5    #雙按Tree的節點index  #FUN-9A50010
   
    #TQC-C70069--mark--str--
    ##MOD-C30530--add--str--
    #IF g_lock = 'Y' THEN
    #   CALL cl_err('','abm-094',0)   
    #   RETURN
    #END IF             
    ##MOD-C30530--add--end--
    #TQC-C70069--mark--end--
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bma.* TO NULL             #No.FUN-6A0002
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_bmb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL i600_curs(p_idx)      #取得查詢條件   #FUN-9A50010傳入參數p_idx
    IF INT_FLAG THEN
        INITIALIZE g_bma.* TO NULL
        CALL g_bma_l.clear()
	CALL g_tree.clear()
        CALL g_tree1.clear()       #MOD-C30561
        LET g_tree_focus_idx =0
        LET INT_FLAG = 0
        LET g_bp_flag ="main"
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i600_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bma.* TO NULL
    ELSE
        OPEN i600_count
        FETCH i600_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt

        ###FUN-9A50010 START ###
        IF p_idx = 0 THEN
           CALL i600_fetch('F',0)        #讀出TEMP第一筆並顯示
           #CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)   #Tree填充
        ELSE
           #Tree的最上層是QBE結果，才可以指定jump
           IF g_tree[p_idx].level = 1 THEN
              CALL i600_fetch('T',p_idx) #讀出TEMP中，雙點Tree的指定節點並顯示
           ELSE
              CALL i600_fetch('F',0)
           END IF
        END IF
        ###FUN-9A50010 END ###
        CALL i600_list_fill()      #No.FUN-7C0010
        LET g_bp_flag = NULL       #CHI-880031
        #CALL i600_fetch('F',0)                  # 讀出TEMP第一筆并顯示  #TQC-C60239 mark
    END IF


    MESSAGE " "
END FUNCTION

FUNCTION i600_list_fill()
  DEFINE l_bma01         LIKE bma_inplan.bma01
  DEFINE l_bma06         LIKE bma_inplan.bma06
  DEFINE l_i             LIKE type_file.num10

    CALL g_bma_l.clear()
    LET l_i = 1
    FOREACH i600_list_cur INTO l_bma01,l_bma06
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach list_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT bma01,bma06,ima02,ima021,ima55,ima05,ima08,bma05,bma08
         INTO g_bma_l[l_i].*
         FROM bma_inplan, ima_file
        WHERE bma01=l_bma01
          AND bma06=l_bma06
          AND bma01=ima_file.ima01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN   #CHI-BB0034 add
            CALL cl_err( '', 9035, 0 )
          END IF                              #CHI-BB0034 add
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_bma_l TO s_bma_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION i600_fetch(p_flag,p_idx)    #FUN-9A50010 加參數p_idx
DEFINE
    p_flag     LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)      #處理方式

DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index  #FUN-9A50010
DEFINE l_i       LIKE type_file.num5     #FUN-9A50010
DEFINE l_jump    LIKE type_file.num5     #跳到QBE中Tree的指定筆 #FUN-9A50010

    MESSAGE ""
    ##FUN-9A50010 START ###
    IF p_flag = 'T' AND p_idx <= 0 THEN      #Tree index錯誤就改讀取第一筆資料
       LET p_flag = 'F'
    END IF
    ##FUN-9A50010 END ###
   CASE p_flag
        WHEN 'N' FETCH NEXT     i600_curs INTO g_bma.bma01,g_bma.bma06 #FUN-550014 add bma06
        WHEN 'P' FETCH PREVIOUS i600_curs INTO g_bma.bma01,g_bma.bma06 #FUN-550014 add bma06
        WHEN 'F' FETCH FIRST    i600_curs INTO g_bma.bma01,g_bma.bma06 #FUN-550014 add bma06
        WHEN 'L' FETCH LAST     i600_curs INTO g_bma.bma01,g_bma.bma06 #FUN-550014 add bma06
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i600_curs INTO g_bma.bma01,g_bma.bma06 #FUN-550014 add bma06

              ##FUN-9A50010 START ###
        #Tree雙點指定筆
        WHEN 'T'
           #讀出TEMP中，雙點Tree的指定節點並顯示
           LET l_jump = 0
           IF g_tree[p_idx].level = 1 THEN   #最高層
              LET l_jump = g_tree[p_idx].id  #ex:當id=5，表示要跳到第5筆
           END IF
           IF l_jump <= 0 THEN
              LET l_jump = 1
           END IF
           LET g_jump = l_jump
           FETCH ABSOLUTE g_jump i600_curs INTO g_bma.bma01,g_bma.bma06
        ##FUN-9A50010 END ###

    END CASE

    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
       INITIALIZE g_bma.* TO NULL   #No.TQC-6B0105
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
    SELECT * INTO g_bma.* FROM bma_inplan WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","bma_inplan",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","",1)  #No.TQC-660046
        INITIALIZE g_bma.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_bma.bmauser      #FUN-4C0054
        LET g_data_group = g_bma.bmagrup      #FUN-4C0054
    END IF
    CALL i600_show()

END FUNCTION

#將資料顯示在畫面上
FUNCTION i600_show()
DEFINE l_count    LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE l_wc_new1  STRING                 #FUN-CB0078
DEFINE l_wc_new2  STRING                 #FUN-CB0078
DEFINE l_ecu02    LIKE ecu_file.ecu02     


    
    SELECT  ecu02 INTO l_ecu02 FROM ecu_file WHERE ecu01=g_bma.bma01 AND ROWNUM=1  ORDER BY ecu02 DESC 


    DISPLAY l_ecu02 TO FORMONLY.ecu02 
    LET g_bma_t.* = g_bma.*                #保存單頭舊值
    DISPLAY BY NAME g_bma.bmaoriu,g_bma.bmaorig,                              # 顯示單頭值
        g_bma.bma01,g_bma.bma06,g_bma.bma10,g_bma.bma04,g_bma.bma05, #FUN-550014 add bma06 #NO.FUN-810014 add bma10
        g_bma.bmauser,g_bma.bmagrup,g_bma.bmamodu,
        g_bma.bmadate,g_bma.bmaacti,g_bma.bma08,         #No.FUN-7C0010
        g_bma.bmaud01,g_bma.bmaud02,g_bma.bmaud03,g_bma.bmaud04,
        g_bma.bmaud05,g_bma.bmaud06,g_bma.bmaud07,g_bma.bmaud08,
        g_bma.bmaud09,g_bma.bmaud10,g_bma.bmaud11,g_bma.bmaud12,
        g_bma.bmaud13,g_bma.bmaud14,g_bma.bmaud15


     SELECT count(*)
       INTO l_count
       FROM bmb_inplan
      WHERE bmb01 = g_bma.bma01
        AND bmb30='3'

    IF l_count = 0 THEN
       CALL cl_set_act_visible("preview_bom", FALSE)
       CALL cl_set_act_visible("edit_formula",FALSE)  #No.FUN-640139 Add
    ELSE
       CALL cl_set_act_visible("preview_bom", TRUE)
       CALL cl_set_act_visible("edit_formula",FALSE)  #No.FUN-640139 Add
    END IF

    CALL i600_pic()  #MOD-840435

#FUN-B90117 --BEGIN--
   #IF g_lock='N' AND cl_null(g_tree_item) THEN   #只有在非锁定状态才会刷新树状图           #FUN-C20105 #FUN-C30036	
    IF g_show_flag = 'N' AND (cl_null(g_tree_item) OR  g_tree_arr_curr < = 0                #FUN-CB0078
         OR g_action_choice = "query"                                                       #FUN-CB0078
         OR g_action_choice = "modify") THEN                                                #FUN-CB0078
       LET g_tree_sel='1'
       CALL g_tree1.clear()
    #  CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma.bma01)    #FUN-CB0078 mark
       #FUN-CB0078 --begin--
       IF g_action_choice = "modify" THEN
          IF g_bma01_t <> g_tree_upd THEN
             LET l_wc_new1 = "bma01 = '",g_tree_upd,"'"
             CALL i600_tree_fill(l_wc_new1,NULL,0,NULL,NULL,NULL,g_tree_upd)
          ELSE
             LET l_wc_new2 = "bma01 = '",g_bma.bma01,"'"
             CALL i600_tree_fill(l_wc_new2,NULL,0,NULL,NULL,NULL,g_bma.bma01)
          END IF
       ELSE
          CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma.bma01)
       END IF
      #FUN-CB0078 --end--       
    END IF                                                              #FUN-C20105 
#FUN-B90117--END--

    CALL i600_bma01('d')
    CALL i600_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION i600_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_bma.bma01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
  #MOD-AC0227---mark---start---
  ##MOD-A90182---add---start--
  # IF g_bma.bma10 = '2' THEN
  #    CALL cl_err('','abm-123',0)
  #    RETURN
  # END IF
  ##MOD-A90182---add---end---
  #MOD-AC0227---mark---end---
    IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
       CALL cl_err(g_bma.bma08,'aoo-045',1)
       RETURN
    END IF

    BEGIN WORK

    OPEN i600_cl USING g_bma.bma01,g_bma.bma06
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_bma.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)          #資料被他人LOCK
        RETURN
    END IF
    CALL i600_show()
    IF cl_exp(0,0,g_bma.bmaacti) THEN
        LET g_chr=g_bma.bmaacti
        IF g_bma.bmaacti='Y' THEN
            LET g_bma.bmaacti='N'
        ELSE
            LET g_bma.bmaacti='Y'
        END IF
        UPDATE bma_inplan                    #更改有效碼
           #----------No:MOD-A20048 modify
            SET bmaacti=g_bma.bmaacti,
                bmamodu=g_user,
                bmadate=g_today
           #----------No:MOD-A20048 end
            WHERE bma01=g_bma.bma01
              AND bma06=g_bma.bma06   #FUN-550014
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bma_inplan",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","",1)  #No.TQC-660046
            LET g_bma.bmaacti=g_chr
       #-----------No:MOD-A20048 add
        ELSE
           LET g_bma.bmamodu = g_user
           LET g_bma.bmadate = g_today
       #-----------No:MOD-A20048 end
        END IF
        DISPLAY BY NAME g_bma.bmaacti
        DISPLAY BY NAME g_bma.bmamodu   #No:MOD-A20048 add
        DISPLAY BY NAME g_bma.bmadate   #No:MOD-A20048 add
    END IF
     LET g_bp_flag = "main"
    CLOSE i600_cl
    COMMIT WORK
END FUNCTION

FUNCTION i600_j()
   DEFINE l_bmb01   LIKE bmb_inplan.bmb01   #MOD-4B0234
   DEFINE l_bmb02   LIKE bmb_inplan.bmb02   #MOD-4B0234
   DEFINE l_bmb03   LIKE bmb_inplan.bmb03   #MOD-4B0234
   DEFINE l_bmb04   LIKE bmb_inplan.bmb04   #MOD-4B0234
   DEFINE l_ima01   LIKE ima_file.ima01   #CHI-830034
   DEFINE l_imaacti LIKE ima_file.imaacti #CHI-830034
   DEFINE l_bma05   LIKE bma_inplan.bma05   #CHI-A40001 add
   DEFINE l_ima910  LIKE ima_file.ima910  #CHI-A40001 add
   DEFINE l_n       LIKE type_file.num5   #CHI-A40001 add
   DEFINE l_wc2     STRING                #MOD-A70215 add
   DEFINE l_gew03   LIKE gew_file.gew03   #FUN-950057
   DEFINE l_sql     STRING                #FUN-950057
   DEFINE l_i       LIKE type_file.num5   #FUN-950057

    IF s_shut(0) THEN RETURN END IF
    IF g_bma.bma01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
       CALL cl_err(g_bma.bma08,'aoo-045',1)
       RETURN
    END IF
    SELECT ima01,imaacti INTO l_ima01,l_imaacti FROM ima_file
     WHERE ima01 = g_bma.bma01
     IF l_imaacti = 'N' THEN
        CALL cl_err('','9028',0)
        RETURN
     END IF
     IF l_imaacti MATCHES '[PH]' THEN
     #  CALL cl_err('','9038',0)      #TQC-9C0192
        CALL cl_err('','abm-038',0)  #TQC-9C0192    
        RETURN
     END IF
    IF g_bma.bma10 = 0 THEN CALL cl_err('','aco-174',0) RETURN END IF   #NO.FUN-810014
    IF g_bma.bma10 = 2 THEN CALL cl_err('','abm-003',0) RETURN END IF   #NO.FUN-810014
    IF g_bma.bmaacti='N' THEN
       CALL cl_err(g_bma.bmaacti,'aap-127',0) RETURN
    END IF
    IF NOT cl_null(g_bma.bma05) THEN
       CALL cl_err(g_bma.bma05,'abm-003',0) RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM bmb_inplan WHERE bmb01 = g_bma.bma01
                                               AND bmb29 = g_bma.bma06  #FUN-550014 add
    IF g_cnt=0 THEN
       CALL cl_err(g_bma.bma01,'arm-034',0) RETURN
    END IF
    BEGIN WORK

    OPEN i600_cl USING g_bma.bma01,g_bma.bma06
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_bma.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i600_show()
    IF NOT cl_confirm('abm-004') THEN RETURN END IF
    LET g_bma.bma05=g_today
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
    INPUT BY NAME g_bma.bma05 WITHOUT DEFAULTS

      AFTER FIELD bma05
        IF cl_null(g_bma.bma05) THEN NEXT FIELD bma05 END IF

      AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
        IF cl_null(g_bma.bma05) THEN NEXT FIELD bma05 END IF

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
       LET g_bma.bma05=NULL
       DISPLAY BY NAME g_bma.bma05
       LET INT_FLAG=0
       ROLLBACK WORK
       RETURN
    END IF
    UPDATE bma_inplan SET bma05=g_bma.bma05,
                        bma10='2',          #NO.FUN-810014
                        bmadate=g_today     #FUN-C40006 add
                                            WHERE bma01=g_bma.bma01
                                            AND bma06=g_bma.bma06 #FUN-550014
    IF SQLCA.SQLERRD[3]=0 THEN
       LET g_bma.bma05=NULL
       DISPLAY BY NAME g_bma.bma05
       CALL cl_err3("upd","bma_inplan",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","up bma05",1)  #No.TQC-660046
       ROLLBACK WORK
       RETURN
    END IF
    DECLARE i600_up_cs CURSOR FOR
     SELECT bmb01,bmb02,bmb03,bmb04
       FROM bmb_inplan
      WHERE bmb01 = g_bma.bma01
        AND bmb29 = g_bma.bma06  #FUN-550014 add
        AND (bmb05 > g_bma.bma05 OR bmb05 IS NULL )
    LET g_success = 'Y'

    CALL s_showmsg_init() #CHI-A40001 add

    FOREACH i600_up_cs INTO l_bmb01,l_bmb02,l_bmb03,l_bmb04
        #CHI-A40001 add --start--
        SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01 = l_bmb03
        IF cl_null(l_ima910) THEN LET l_ima910 = ' ' END IF
        SELECT COUNT(*) INTO l_n
          FROM bma_inplan
         WHERE bma01 = l_bmb03
           AND bma06 = l_ima910
           AND bmaacti = 'Y'
        IF l_n > 0 THEN
           SELECT bma05 INTO l_bma05
             FROM bma_inplan
            WHERE bma01 = l_bmb03
              AND bma06 = l_ima910
              AND bmaacti = 'Y'
           IF cl_null(l_bma05) OR l_bma05 = ' ' THEN
              CALL s_errmsg('bmb03',l_bmb03,'i600:','amr-001',1)
           END IF
        END IF
        #CHI-A40001 add --end--

       #str MOD-A70166 mark
       #UPDATE bmb_inplan
       #   SET bmb04 = g_bma.bma05
       # WHERE bmb01 = l_bmb01
       #   AND bmb02 = l_bmb02
       #   AND bmb03 = l_bmb03
       #   AND bmb04 = l_bmb04
       #IF SQLCA.SQLERRD[3]=0 THEN
       #   LET g_bma.bma05=NULL
       #   DISPLAY BY NAME g_bma.bma05
       #   CALL cl_err3("upd","bmb_inplan",l_bmb01,l_bmb02,SQLCA.sqlcode,"","up bmb04",1)  #No.TQC-660046
       #   LET g_success = 'N'
       #   EXIT FOREACH
       #END IF
       #UPDATE bmc_file
       #   SET bmc03 = g_bma.bma05
       # WHERE bmc01 = l_bmb01
       #   AND bmc02 = l_bmb02
       #   AND bmc021= l_bmb03
       #   AND bmc03 = l_bmb04
       #IF SQLCA.sqlcode THEN
       #   LET g_bma.bma05=NULL
       #   DISPLAY BY NAME g_bma.bma05
       #   CALL cl_err3("upd","bmc_file",l_bmb01,l_bmb02,SQLCA.sqlcode,"","up bmc03",1)  #No.TQC-660046
       #   LET g_success = 'N'
       #   EXIT FOREACH
       #END IF
       #UPDATE bmt_file
       #   SET bmt04 = g_bma.bma05
       # WHERE bmt01 = l_bmb01
       #   AND bmt02 = l_bmb02
       #   AND bmt03 = l_bmb03
       #   AND bmt04 = l_bmb04
       #IF SQLCA.sqlcode THEN
       #   LET g_bma.bma05=NULL
       #   DISPLAY BY NAME g_bma.bma05
       #   CALL cl_err3("upd","bmt_file",l_bmb01,l_bmb02,SQLCA.sqlcode,"","up bmt04",1)  #No.TQC-660046
       #   LET g_success = 'N'
       #   EXIT FOREACH
       #END IF
       #end MOD-A70166 mark
    END FOREACH

    CALL s_showmsg() #CHI-A40001 add

    CALL i600_list_fill()

    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
    LET l_wc2 = "     (bmb04 <='", g_bma.bma05,"'"," OR bmb04 IS NULL )",  #MOD-A70215 mod g_wc2->l_wc2
                " AND (bmb05 >  '",g_bma.bma05,"'"," OR bmb05 IS NULL )"
    LET l_wc2 = l_wc2 CLIPPED                                              #MOD-A70215 mod g_wc2->l_wc2
    CALL i600_b_fill(l_wc2)                                                #MOD-A70215 mod g_wc2->l_wc2
    SELECT bma05,bma10 INTO g_bma.bma05,g_bma.bma10  FROM bma_inplan WHERE bma01=g_bma.bma01  #NO.FUN-810014
                                                  AND bma06=g_bma.bma06 #FUN-550014 add
    DISPLAY BY NAME g_bma.bma05
    DISPLAY BY NAME g_bma.bma10
    #FUN-950057 --------------- add start ----------------------------------如果勾選自動拋轉,發放時一併做拋轉動作
    #是否為資料中心的拋轉DB
    SELECT gev04 INTO g_gev04 FROM gev_file
     WHERE gev01 = '2' AND gev02 = g_plant
       AND gev03 = 'Y'
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode=100 THEN
          RETURN
       ELSE
          CALL cl_err(g_gev04,'aoo-036',1)
          RETURN
       END IF
    END IF

    IF cl_null(g_gev04) THEN RETURN END IF
    SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file
     WHERE gew01 = g_gev04
       AND gew02 = '2'
    IF l_gew03 = '1' THEN
       #開窗選擇拋轉的db清單
       LET l_sql = "SELECT COUNT(*) FROM &bma_inplan WHERE bma01='",g_bma.bma01,"'",
                                                 "  AND bma06='",g_bma.bma06,"'"

       CALL s_dc_sel_db1(g_gev04,'2',l_sql)
        IF INT_FLAG THEN
           LET INT_FLAG=0
           RETURN
        END IF

        CALL g_bmax.clear()
        LET g_bmax[1].sel = 'Y'
        LET g_bmax[1].bma01 = g_bma.bma01
        LET g_bmax[1].bma06 = g_bma.bma06
        FOR l_i = 1 TO g_azp1.getLength()
            LET g_azp[l_i].sel   = g_azp1[l_i].sel
            LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
            LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
            LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
        END FOR

        CALL s_showmsg_init()
        CALL s_abmi600_carry(g_bmax,g_azp,g_gev04,'0')
        CALL s_showmsg()
    END IF
#FUN-950057 ---------------------------------add end--------------------------------
END FUNCTION

FUNCTION i600_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
    DEFINE l_cnt LIKE type_file.num10   #No.FUN-680096 INTEGER

    IF s_shut(0) THEN RETURN END IF
    IF g_bma.bma01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

    IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'r') THEN
       CALL cl_err(g_bma.bma08,'aoo-044',1)
       RETURN
    END IF

    IF g_bma.bma10 <> '0'  THEN CALL cl_err('','aim1006',0) RETURN END IF

    #考慮參數(sma101) BOM表發放后是否可以修改單身
    IF NOT cl_null(g_bma.bma05) AND g_sma.sma101 = 'N' THEN
       IF g_ima08_h MATCHES '[MPXTSVU]' THEN    #單頭料件來源碼='MPXT'才control #FUN-590116 add S   #MOD-9A0116 add V/U
          CALL cl_err('','abm-120',0)
          RETURN
       END IF
    END IF

    #No.B236 010326 by linda add 存在工單之BOM詢問是否可取消
   #------------No:MOD-A20005 modify
   #SELECT COUNT(*) INTO l_cnt
   #  FROM sfa_file
   # WHERE sfa29 = g_bma.bma01
    SELECT COUNT(*) INTO l_cnt
      FROM sfb_file
     WHERE sfb05 = g_bma.bma01
       AND sfb95 = g_bma.bma06
       AND sfb87 != 'X'            #MOD-CB0227 add
   #------------No:MOD-A20005 end
    IF l_cnt >0 AND l_cnt IS NOT NULL THEN

       CALL cl_err("",'mfg-074', 1)
       RETURN
    END IF
    BEGIN WORK

    OPEN i600_cl USING g_bma.bma01,g_bma.bma06
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_bma.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i600_show()
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bma01"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_bma.bma01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
        #TQC-C30115---begin
        IF s_industry('icd') THEN
           DELETE FROM icm_file WHERE icm02 = g_bma.bma01
                                  AND icm01 IN  (SELECT bmb03
                                                   FROM bmb_inplan
                                                  WHERE bmb01 = g_bma.bma01
                                                   and  bmb29 = g_bma.bma06) 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","icm_file",g_bma.bma01,"",SQLCA.sqlcode,"","del icm",1)
              ROLLBACK WORK
              RETURN
           END IF        
        END IF            
        #TQC-C30115---end
        DELETE FROM bma_inplan WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err3("del","bma_inplan",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","del bma",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bmb_inplan WHERE bmb01=g_bma.bma01
                               AND bmb29=g_bma.bma06  #FUN-550014 add
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmb_inplan",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","del bmb",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bmt_file WHERE bmt01=g_bma.bma01
                               AND bmt08=g_bma.bma06  #FUN-550014 add
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmt_file",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","del bmt",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bmc_file WHERE bmc01=g_bma.bma01
                               AND bmc06=g_bma.bma06  #FUN-550014 add
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmc_file",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","del bmc",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bml_file WHERE bml02=g_bma.bma01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bml_file",g_bma.bma01,"",SQLCA.sqlcode,"","del bml",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bmd_file WHERE bmd08=g_bma.bma01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmd_file",g_bma.bma01,"",SQLCA.sqlcode,"","del bmd",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF


        DELETE FROM bmm_file WHERE bmm01=g_bma.bma01 #---->聯產品
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmm_file",g_bma.bma01,"",SQLCA.sqlcode,"","del bmm",1)  #No.TQC-660046
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bmv_file WHERE bmv01=g_bma.bma01
                               AND bmv03=g_bma.bma06
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmv_file",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","del bmv",1)
                ROLLBACK WORK
                RETURN
            END IF

        IF g_sma.sma901 = 'Y' THEN
          DELETE FROM vmo_file WHERE vmo01 = g_bma.bma01
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","vmo_file",g_bma.bma01,"",SQLCA.sqlcode,"","del bmm",1)
                  ROLLBACK WORK
                  RETURN
              END IF
        END IF

    LET g_msg=TIME
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)    #FUN-980001 add plant & legal
       VALUES ('cbmi600',g_user,g_today,g_msg,g_bma.bma01,g_bma.bma06,'delete',g_plant,g_legal)#FUN-980001 add plant & legal
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)    #FUN-980001 add plant & legal
       VALUES ('cbmi600',g_user,g_today,g_msg,g_bma.bma01,'delete',g_plant,g_legal)#FUN-980001 add plant & legal
    END IF
    IF g_sma.sma845='Y'   #低階碼可否部份重計
       THEN
       LET g_success='Y'
       #CALL s_uima146(g_bma.bma01)  #CHI-D10044
       CALL s_uima146(g_bma.bma01,0)  #CHI-D10044
       MESSAGE ""
    END IF

    CALL i600_list_fill()

    COMMIT WORK
    CLOSE i600_cl
    CLEAR FORM
    CALL g_bmb.clear()

#FUN-C20105 --begin--
##FUN-B90117--BEGIN--
##   IF g_lock='N' THEN
##      CALL g_tree1.clear()
##    ELSE
#        LET g_tree_sel='1'
##        IF g_lock='Y' THEN
#           LET g_bma01_tree=g_tree1[1].treekey4
##        ELSE
#           LET g_bma01_tree=g_bma.bma01
##        END IF
#        CALL g_tree1.clear()
#        CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma01_tree)  #新增单身重新刷新树状图
##    END IF
##FUN-B90117--END--

#FUN-CB0078 -----Begin-----
#    IF g_lock='N' THEN
#      CALL g_tree1.clear()
#    ELSE
#FUN-CB0078 -----End-------
       LET g_tree_sel='1'
     # IF g_lock='Y' THEN        #FUN-CB0078 mark
       IF NOT cl_null(g_tree_item) OR g_tree_arr_curr > 0 THEN    #FUN-CB0078 add 
          LET g_bma01_tree=g_tree1[1].treekey4
       ELSE
          LET g_bma01_tree=g_bma.bma01
       END IF   
       CALL g_tree1.clear()
       CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma01_tree)
   # END IF   #FUN-CB0078   mark     
#FUN-C20105 --end--

    CALL i600_tree_update() #Tree 資料有異動 #FUN-9A50010
#MOD-A50010 mark---start---
    --OPEN i600_count
    --IF STATUS THEN   #MOD-9A0202
       --CLOSE i600_count   #MOD-9A0202
    --ELSE   #MOD-9A0202
       --FETCH i600_count INTO g_row_count
       --IF SQLCA.sqlcode THEN   #MOD-9A0202
          --CLOSE i600_count   #MOD-9A0202
       --ELSE   #MOD-9A0202
          --DISPLAY g_row_count TO FORMONLY.cnt
          --OPEN i600_curs
          --IF g_curs_index = g_row_count + 1 THEN
             --LET g_jump = g_row_count
             --CALL i600_fetch('L',0)
          --ELSE
             --LET g_jump = g_curs_index
             --LET mi_no_ask = TRUE
             --CALL i600_fetch('/',0)
          --END IF
       --END IF   #MOD-9A0202
    --END IF   #MOD-9A0202
#MOD-A50010 mark---end---
END FUNCTION

#單身
FUNCTION i600_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #No.FUN-680096 SMALLINT,  #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,   #No.FUN-680096 SMALLINT,  #檢查重復用
    l_lock_sw       LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1),   #單身鎖住否
    p_cmd           LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1),   #處理狀態
    l_buf           LIKE type_file.chr50,  #No.FUN-680096 VARCHAR(40),
    l_cmd           LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(200),
    l_uflag,l_chr   LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(01),
    l_ima08         LIKE ima_file.ima08,
    l_bmb01         LIKE ima_file.ima01,
    l_qpa           LIKE bmb_inplan.bmb06,
    l_ima04         LIKE ima_file.ima04,
    l_i             LIKE type_file.num5,   #No.CHI-6C0034
    l_success       LIKE type_file.chr1,   #No.FUN-840155
    l_cnt1          LIKE type_file.num5, #MOD-B40149
    l_flag          LIKE type_file.chr1, #MOD-B40149

    l_result        LIKE gep_file.gep01,   #aooi503返回的合成后的公式前綴
    l_str           LIKE gep_file.gep01,

    l_valid,l_count LIKE type_file.num5,   #No.FUN-680096 SMALLINT,
    l_formula01     LIKE gep_file.gep01,
    l_formula02     LIKE gep_file.gep01,
    l_formula03     LIKE gep_file.gep01,
    l_ima140  LIKE ima_file.ima140,

    l_viewcad_cmd   LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(512),
    l_allow_insert  LIKE type_file.num5,    #No.FUN-680096 SMALLINT,   #可新增否
    l_allow_delete  LIKE type_file.num5     #No.FUN-680096 SMALLINT    #可刪除否
DEFINE l_m          LIKE type_file.num5        #NO.FUN-810014
DEFINE l_r          LIKE type_file.num5        #NO.FUN-830116
DEFINE l_ima151     LIKE ima_file.ima151       #NO.FUN-810014
DEFINE r_ima151     LIKE ima_file.ima151       #NO.FUN-810014
DEFINE l_count1     LIKE type_file.num5        #NO.FUN-840178
DEFINE l_mdm_tag    LIKE type_file.num5        #FUN-850147
DEFINE l_mdm_action STRING                     #FUN-850147
DEFINE l_icm  RECORD LIKE icm_file.*           #FUN-980033
DEFINE l_loop   LIKE type_file.chr1       #是否為無窮迴圈Y/N   #FUN-9A50010
DEFINE l_t          LIKE type_file.num5    #No.FUN-A60083s
DEFINE l_tf     LIKE type_file.chr1       #FUN-910088--add--
DEFINE l_ima928     LIKE ima_file.ima928  #FUN-C30047
DEFINE l_wc_new     STRING                #FUN-CB0078

    LET l_mdm_action = g_action_choice
    LET p_md = 'u'                             #NO.FUN-810014
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bma.bma01) THEN
        RETURN
    END IF
    IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
       CALL cl_err(g_bma.bma08,'aoo-045',1)
       RETURN
    END IF
#   IF g_bma.bma10 <>0 AND g_sma.sma101!='Y'  THEN RETURN END IF  #NO.FUN-870127   #No.TQC-A80123
    #No.TQC-A80123--begin
    IF g_bma.bma10 <>0 AND g_sma.sma101!='Y'  THEN
       CALL cl_err('','abm-231',1)
       RETURN
    END IF
    #No.TQC-A80123--end
    #考慮參數(sma101) BOM表發放后是否可以修改單身
    IF NOT cl_null(g_bma.bma05) AND g_sma.sma101 = 'N' THEN
       IF g_ima08_h MATCHES '[MPXTSVU]' THEN    #單頭料件來源碼='MPXT'才control #FUN-590116 add S   #MOD-9A0116 add V/U
          CALL cl_err('','abm-120',0)
          RETURN
       END IF
    END IF
    #No.FUN-A60083--begin
    SELECT COUNT(*) INTO l_t FROM bra_file WHERE bra01=g_bma.bma01 AND bra06=g_bma.bma06 AND bra014='Y'
    IF g_sma.sma542='Y' AND l_t>0 THEN
       CALL cl_err('','abm-229',0)
       RETURN
    END IF
    #No.FUN-A60083--end
    IF g_bma.bmaacti ='N' THEN    #資料若為無效,仍可更改.  #TQC-6C0028
        CALL cl_err(g_bma.bma01,'mfg1000',0) RETURN        #TQC-6C0028
    END IF                                                 #TQC-6C0028
    LET l_uflag ='N'
    LET g_aflag ='N'

    #-----MOD-B40149---------
    LET l_cnt1 = 0
    LET l_flag = 'Y'
    SELECT COUNT(*) INTO l_cnt1 FROM bmb_inplan
     WHERE bmb01 = g_bma.bma01
       AND bmb29 = g_bma.bma06
    IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
    IF l_cnt1 = 0 THEN
       LET l_flag = 'N'
    END IF
    #-----END MOD-B40149-----

    CALL cl_opmsg('b')

    LET g_forupd_sql =
      "SELECT * ",
      " FROM bmb_inplan ",
      "   WHERE bmb01 = ? ",
      "   AND bmb29 = ? ", #FUN-550014 add
      "   AND bmb02 = ? ",
      "   AND bmb03 = ? ",
      "   AND bmb04 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    IF NOT s_industry('slk') THEN
        CALL cl_set_act_visible("fix",FALSE)
    END IF
     IF g_sma.sma09 = 'N' THEN
        CALL cl_set_act_visible("create_item_master", FALSE)
     ELSE
        CALL cl_set_act_visible("create_item_master", TRUE)
     END IF

    CALL FGL_DIALOG_SETFIELDORDER(FALSE)  #FUN-610022 欄位切換時屏蔽調中間欄位的BEFORE FIELD

    INPUT ARRAY g_bmb
          WITHOUT DEFAULTS
          FROM s_bmb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
             LET g_modify_flag = 'N' #MOD-530319


        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK

            LET g_success = 'Y'
            OPEN i600_cl USING g_bma.bma01,g_bma.bma06
            IF STATUS THEN
                CALL cl_err("OPEN i600_cl:", STATUS, 1)
                CLOSE i600_cl
                RETURN
            END IF
            FETCH i600_cl INTO g_bma.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)  # 資料被他人LOCK
               CLOSE i600_cl
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_bmb_t.* = g_bmb[l_ac].*  #BACKUP
               LET g_bmb_o.* = g_bmb[l_ac].*
               LET g_bmb10_t = g_bmb[l_ac].bmb10     #FUN-910088--add--
                OPEN i600_bcl USING g_bma.bma01,g_bma.bma06,g_bmb_t.bmb02,g_bmb_t.bmb03,g_bmb_t.bmb04 #FUN-550014
                IF STATUS THEN
                    CALL cl_err("OPEN i600_bcl:", STATUS, 1)
                ELSE
                    FETCH i600_bcl INTO b_bmb.* #FUN-730075
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmb_t.bmb02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL i600_b_move_to() #FUN-730075
                    END IF


                    #如果某一行計算方式是"公式",則在料件名稱和規格處填充"<依公式生成>"字樣
                    IF g_bmb[l_ac].bmb30 = '3' THEN
                       LET g_bmb[l_ac].ima02_b  = g_tipstr
                       LET g_bmb[l_ac].ima021_b = g_tipstr
                    END IF

                END IF

                #增加判斷,如果當前計算方式為公式則忽略該函數
                IF (g_bmb[l_ac].bmb30 != '3') OR (cl_null(g_bmb[l_ac].bmb30)) THEN #FUN-5A0051 add cl_null(g_bmb[l_ac].bmb30)
                   CALL i600_bmb03('d')           #No.TQC-590033 add
                END IF

              IF g_bmb[l_ac].bmb30 != '3' THEN
                 CALL cl_set_act_visible("edit_formula",FALSE)
              ELSE
                 CALL cl_set_act_visible("edit_formula",TRUE)
              END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

            CALL i600_b_set_entry()
            CALL i600_b_set_no_entry()


        AFTER INSERT
           #CHI-B70045---add---start---
            IF NOT s_industry('slk') THEN
               IF g_ima107_b = 'Y' THEN #Y:自動開窗輸入insert_loc
                  CALL i600_loc('u')
               END IF
            END IF
           #CHI-B70045---add---end---
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

             ##FUN-9A50010 START ###
            CALL i600_tree_loop(g_bma.bma01,g_bmb[l_ac].bmb03,NULL) RETURNING l_loop  #檢查是否為無窮迴圈
            IF l_loop = "Y" THEN
               CALL cl_err(g_bmb[l_ac].bmb03,"agl1000",1)
               CANCEL INSERT
            ELSE
            ##FUN-950010 END ###

            CALL i600_b_move_back() #FUN-730075
            LET b_bmb.bmb33 = '0'
            INSERT INTO bmb_inplan VALUES (b_bmb.*)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","bmb_inplan",g_bma.bma01,g_bmb[l_ac].bmb02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N
                LET g_modify_flag='Y'
                UPDATE bma_inplan SET bmadate = g_today
                                WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
                MESSAGE 'INSERT O.K'
                #update 上一項次失效日
                CALL i600_update('a')
                IF g_sma.sma845='Y'   #低階碼可否部份重計
                   THEN
                    LET g_success='Y'                                #MOD-530319
                   IF g_bmb[l_ac].bmb30!= '3' THEN    #MOD-D80128 130820
                      #CALL s_uima146(g_bmb[l_ac].bmb03)  #CHI-D10044
                       CALL s_uima146(g_bmb[l_ac].bmb03,0)  #CHI-D10044
                   END IF                       #MOD-D80128 130820
                   MESSAGE ""
                   IF g_success='N' THEN
                       #不可輸入此元件料號,因為產品結構偵錯發現有誤! #MOD-530319
                       CALL cl_err(g_bmb[l_ac].bmb03,'abm-602',1)    #MOD-530319
                      LET g_bmb[l_ac].* = g_bmb_t.*
                      DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                      ROLLBACK WORK
                       CALL g_bmb.deleteElement(l_ac)                #MOD-530319
                       CANCEL INSERT                                 #MOD-530319
                   END IF
                END IF
                IF l_uflag = 'N' THEN
                  #新增料件時系統參數(sma18 低階碼是重新計算)
                   UPDATE sma_file SET sma18 = 'Y'
                        WHERE sma00 = '0'
                   IF SQLCA.SQLERRD[3]  = 0 THEN
                      CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","cannot update sma_file",1)  #No.TQC-660046
                   END IF
                   LET l_uflag = 'Y'
                END IF
                IF g_aflag = 'N' THEN LET g_aflag = 'Y' END IF
                 LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                LET l_mdm_tag = 1                    #FUN-850147
                LET g_wsw03 = g_bma.bma01 CLIPPED ,'|', g_bmb[l_ac].bmb02 CLIPPED
                CASE aws_mdmdata('bmb_inplan','insert',g_wsw03,base.TypeInfo.create(b_bmb),'CreateBOMData') #FUN-890113
                     WHEN 0  #無與 MDM 整合
                        MESSAGE 'INSERT O.K'
                     WHEN 1  #呼叫 MDM 成功
                        MESSAGE 'INSERT O.K, INSERT MDM O.K'
                     WHEN 2  #呼叫 MDM 失敗
                        ROLLBACK WORK
                        CANCEL INSERT
                        CONTINUE INPUT
                END CASE
                IF s_industry('icd')  THEN
                   SELECT COUNT(*) INTO l_n FROM icm_file                #FUN-980033
                    WHERE icm01 = b_bmb.bmb03 AND icm02 = b_bmb.bmb01    #FUN-980033
                   IF l_n =0 THEN
                      INITIALIZE l_icm.* TO NULL
                      LET l_icm.icm01 = b_bmb.bmb03
                      LET l_icm.icm02 = b_bmb.bmb01
                      LET l_icm.icmacti = 'Y'
                      LET l_icm.icmdate = g_today
                      LET l_icm.icmgrup = g_grup
                      LET l_icm.icmmodu = ''
                      LET l_icm.icmuser = g_user
                      LET l_icm.icmoriu = g_user      #No.FUN-980030 10/01/04
                      LET l_icm.icmorig = g_grup      #No.FUN-980030 10/01/04
                      INSERT INTO icm_file VALUES (l_icm.*)
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("ins","icm_file",b_bmb.bmb01,b_bmb.bmb03,SQLCA.sqlcode,"","",1)
                        ROLLBACK WORK
                        CANCEL INSERT
                     END IF
                   END IF
                END IF
                COMMIT WORK
              CALL i600_tree_update()
            END IF

#FUN-C20105 --begin--
##FUN-B90117--begin--
#           LET g_tree_sel='1'
##           IF g_lock='Y' THEN
#              LET g_bma01_tree=g_tree1[1].treekey4
##           ELSE
##              LET g_bma01_tree=g_bma.bma01
##           END IF
#           CALL g_tree1.clear()
#           CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma01_tree)  #新增单身重新刷新树状图
##FUN-B90117--END--

           LET g_tree_sel='1'
        #  IF g_lock='Y' THEN          #FUN-CB0078 mark
           IF (NOT cl_null(g_tree_item) OR g_tree_arr_curr > 0) AND g_a_flag = 'N' THEN  #FUN-CB0078
              LET g_bma01_tree=g_tree1[1].treekey4
           ELSE
              LET g_bma01_tree=g_bma.bma01
           END IF   
           CALL g_tree1.clear()
        #  CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma01_tree)  #FUN-CB0078 
           LET l_wc_new = "bma01 = '",g_bma01_tree,"'"      ##FUN-CB0078 add 不能傳入上次查詢時的條件，這樣會撈不到資料
           CALL i600_tree_fill(l_wc_new,NULL,0,NULL,NULL,NULL,g_bma01_tree)  #FUN-CB0078
#FUN-C20105 --end--

        END IF     #FUN-9A50010

        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_bmb[l_ac].* TO NULL      #900423
            LET g_bmb15 ='N'
            LET g_bmb19 ='Y'    LET g_bmb21 ='Y'
            LET g_bmb22 ='Y'    LET g_bmb23 = 100
            LET g_bmb11 = NULL  LET g_bmb13 = NULL
            LET g_bmb31 = 'N'
            LET g_bmb[l_ac].bmb31 = 'N'
            LET g_bmb18 = 0     LET g_bmb17 = 'N'
            LET g_bmb20 = NULL
             LET g_bmb28 = 0 #MOD-530319 誤差容許率預設值應為 0
            LET g_bmb10_fac = 1 LET g_bmb10_fac2 = 1

            LET g_bmb[l_ac].bmb09 = ' '
            LET g_bmb[l_ac].bmb16 = '0'
            LET g_bmb[l_ac].bmb14 = '0'
            LET g_bmb[l_ac].bmb04 = g_today #Body default
            LET g_bmb[l_ac].bmb06 = 1         #Body default
            LET g_bmb[l_ac].bmb07 = 1         #Body default
            LET g_bmb[l_ac].bmb08 = 0         #Body default
            LET g_bmb[l_ac].bmb081=0          #No.FUN-A50089
            LET g_bmb[l_ac].bmb082=1          #No.FUN-A50089
            LET g_bmb[l_ac].bmb19 = '1'
            IF g_sma.sma118 != 'Y' THEN
                LET g_bmb[l_ac].bmb30 = ' '
            ELSE
                LET g_bmb[l_ac].bmb30 = '1'
            END IF
            IF s_industry('slk') THEN        #TQC-C20429 add
                LET g_bmb[l_ac].bmb30 = '1'  #TQC-C20429 add
            END IF                           #TQC-C20429 add
            IF g_bmb[l_ac].bmb30 != '3' THEN
               CALL cl_set_act_visible("edit_formula",FALSE)
            ELSE
               CALL cl_set_act_visible("edit_formula",TRUE)
            END IF
            LET g_bmb_t.* = g_bmb[l_ac].*         #新輸入資料
            LET g_bmb_o.* = g_bmb[l_ac].*         #新輸入資料
            LET g_bmb10_t = NULL    #FUN-910088--add--
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmb02


        BEFORE FIELD bmb03
          IF g_bmb[l_ac].bmb30 = '3' THEN
             CALL cl_set_act_visible("edit_formula", TRUE)
          ELSE
             CALL cl_set_act_visible("edit_formula", FALSE)
          END IF
          #如果bmb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_bmb[l_ac].bmb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bma.bma01,g_bmb[l_ac].bmb03,1) RETURNING l_result
             IF cl_null(g_bmb[l_ac].bmb03) THEN
                LET g_bmb[l_ac].bmb03 = l_result
                #如果公式內容不為空則將品名規格都設置為"<依公式生成>"
                IF NOT cl_null(l_result) THEN
                  LET g_bmb[l_ac].ima02_b = g_tipstr
                  LET g_bmb[l_ac].ima021_b = g_tipstr
                ELSE
                  #否則將品名和規格清空
                  LET g_bmb[l_ac].ima02_b = ''
                  LET g_bmb[l_ac].ima021_b = ''
                END IF
             ELSE
                IF l_result != g_bmb[l_ac].bmb03 THEN
                   LET g_bmb[l_ac].bmb03 = l_result
                   #如果公式內容不為空則將品名規格都設置為"<依公式生成>"
                   IF NOT cl_null(l_result) THEN
                     LET g_bmb[l_ac].ima02_b = g_tipstr
                     LET g_bmb[l_ac].ima021_b = g_tipstr
                   ELSE
                     #否則將品名和規格清空
                     LET g_bmb[l_ac].ima02_b = ''
                     LET g_bmb[l_ac].ima021_b = ''
                   END IF
                END IF
             END IF
          END IF

        BEFORE FIELD bmb06
          IF g_bmb[l_ac].bmb30 = '3' THEN
             CALL cl_set_act_visible("edit_formula", TRUE)
          ELSE
             CALL cl_set_act_visible("edit_formula", FALSE)
          END IF
          #如果bmb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_bmb[l_ac].bmb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bma.bma01,g_bmb[l_ac].bmb03,2) RETURNING l_result
             IF cl_null(g_bmb[l_ac].bmb03) THEN
                LET g_bmb[l_ac].bmb03 = l_result
             ELSE
                IF l_result != g_bmb[l_ac].bmb03 THEN
                   LET g_bmb[l_ac].bmb03 = l_result
                END IF
             END IF
          END IF

        BEFORE FIELD bmb08
          IF g_bmb[l_ac].bmb30 = '3' THEN
             CALL cl_set_act_visible("edit_formula", TRUE)
          ELSE
             CALL cl_set_act_visible("edit_formula", FALSE)
          END IF
          #如果bmb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_bmb[l_ac].bmb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bma.bma01,g_bmb[l_ac].bmb03,3) RETURNING l_result
             IF cl_null(g_bmb[l_ac].bmb03) THEN
                LET g_bmb[l_ac].bmb03 = l_result
             ELSE
                IF l_result != g_bmb[l_ac].bmb03 THEN
                   LET g_bmb[l_ac].bmb03 = l_result
                END IF
             END IF
          END IF

        #當計算方式被修改時觸發
        ON CHANGE bmb30
           #如果當前選擇的類型是"3.公式"時
           IF g_bmb[l_ac].bmb30 = '3' THEN
              #判斷當前的主件是否為進行多屬性料件管理的料件,如果是才可以繼續,否則要禁止選擇該項
              IF NOT cl_is_multi_feature_manage(g_bma.bma01) THEN
                 CALL cl_err(g_bma.bma01,'lib-299',0)
                 LET g_bmb[l_ac].bmb30 = '1'  #強制改回到"1.固定"
                 DISPLAY g_bmb[l_ac].bmb30 TO bmb30
              END IF
           END IF

        BEFORE FIELD bmb02                        #default 項次
            IF g_bmb[l_ac].bmb02 IS NULL OR g_bmb[l_ac].bmb02 = 0 THEN
                SELECT max(bmb02)
                   INTO g_bmb[l_ac].bmb02
                   FROM bmb_inplan
                   WHERE bmb01 = g_bma.bma01
                     AND bmb29 = g_bma.bma06  #FUN-550014
                IF g_bmb[l_ac].bmb02 IS NULL
                   THEN LET g_bmb[l_ac].bmb02 = 0
                END IF
                LET g_bmb[l_ac].bmb02 = g_bmb[l_ac].bmb02 + g_sma.sma19
            END IF
            IF p_cmd = 'a'
              THEN LET g_bmb20 = g_bmb[l_ac].bmb02
            END IF

        AFTER FIELD bmb02                        #default 項次
            #TQC-C50231--add--str--
            IF NOT cl_null(g_bmb[l_ac].bmb02) THEN
               IF g_bmb[l_ac].bmb02 < = 0 THEN
                  LET g_bmb[l_ac].bmb02 = g_bmb_t.bmb02 
                  DISPLAY BY NAME g_bmb[l_ac].bmb02 
                  CALL cl_err('','aec-994',0)
                  NEXT FIELD bmb02
               END IF
            END IF
            #TQC-C50231--add--end--
            IF g_bmb[l_ac].bmb02 IS NOT NULL AND
               g_bmb[l_ac].bmb02 <> 0 AND p_cmd='a' THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM bmb_inplan
                      WHERE bmb01=g_bma.bma01
                        AND bmb29=g_bma.bma06 #FUN-550014 add
                        AND bmb02=g_bmb[l_ac].bmb02
               IF l_n>0 THEN
                  IF NOT cl_confirm('mfg-002') THEN
                     NEXT FIELD bmb02
                  ELSE
                     FOR l_i = 1 TO g_rec_b
                       IF l_i <> l_ac THEN
                         IF g_bmb[l_i].bmb02 = g_bmb[l_ac].bmb02 AND g_bmb[l_i].bmb04 <> g_bmb[l_ac].bmb04 THEN
                            LET g_bmb[l_i].bmb05 = g_bmb[l_ac].bmb04
                            DISPLAY BY NAME g_bmb[l_i].bmb04
                         END IF
                       END IF
                     END FOR
                  END IF
               END IF
            END IF
             #若有更新項次時,插件位置的key值更新為變動后的項次
             IF p_cmd = 'u' AND (g_bmb[l_ac].bmb02 != g_bmb_t.bmb02) THEN
                SELECT COUNT(*) INTO l_n FROM bmb_inplan
                       WHERE bmb01=g_bma.bma01
                         AND bmb02=g_bmb[l_ac].bmb02
                IF l_n>0 THEN
                  IF NOT cl_confirm('mfg-002') THEN
                     NEXT FIELD bmb02
                  ELSE
                     FOR l_i = 1 TO g_rec_b
                       IF l_i <> l_ac THEN
                         IF g_bmb[l_i].bmb02 = g_bmb[l_ac].bmb02 AND g_bmb[l_i].bmb04 <> g_bmb[l_ac].bmb04 THEN
                            LET g_bmb[l_i].bmb05 = g_bmb[l_ac].bmb04
                            DISPLAY BY NAME g_bmb[l_i].bmb04
                         END IF
                       END IF
                     END FOR
                  END IF
                END IF
               UPDATE bmt_file
                  SET bmt02 = g_bmb[l_ac].bmb02,
                      bmt04 = g_bmb[l_ac].bmb04      #MOD-A70166 add   #MOD-B70146 remove ,
                     #bmt06 = g_bmb[l_ac].bmb13      #NO.FUN-810014    #MOD-B70146 mark
                WHERE bmt01 = g_bma.bma01
                  AND bmt03 = g_bmb[l_ac].bmb03
                  AND bmt04 = g_bmb[l_ac].bmb04
                  AND bmt02 = g_bmb_t.bmb02
             END IF
            IF s_industry('slk') THEN
               IF g_bmb[l_ac].bmb02 IS NOT NULL AND g_bmb[l_ac].bmb03 IS NOT NULL AND
                  g_bmb[l_ac].bmb04 IS NOT NULL AND g_bmb[l_ac].bmb13 IS NOT NULL AND p_cmd = 'a' THEN
                 SELECT COUNT(*) INTO l_r  FROM bmb_inplan WHERE bmb01 = g_bma.bma01
                                                           AND bmb02 = g_bmb[l_ac].bmb02
                                                           AND bmb03 = g_bmb[l_ac].bmb03
                                                           AND bmb04 = g_bmb[l_ac].bmb04
                                                           AND bmb13 = g_bmb[l_ac].bmb13
                IF l_r >0 THEN
                   CALL cl_err('','abm-644',0)
                   NEXT FIELD bmb02
                END IF
               END IF
           END IF

        AFTER FIELD bmb03                         #(元件料件)
            LET l_tf = NULL #FUN-910088 add
            #FUN-AA0059 ----------------------------add start------------------------
            IF NOT cl_null(g_bmb[l_ac].bmb03) AND g_bmb[l_ac].bmb30 != '3'THEN
               IF NOT s_chk_item_no(g_bmb[l_ac].bmb03,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_bmb[l_ac].bmb03 = g_bmb_t.bmb03
                  NEXT FIELD bmb03
               END IF
               
            SELECT ima140 INTO l_ima140 FROM ima_file WHERE ima01=g_bmb[l_ac].bmb03
            IF l_ima140 IS NULL THEN LET  l_ima140='N' END IF 
            IF l_ima140='Y' THEN
               CALL cl_err(g_bmb[l_ac].bmb03,'aim-045',1)
               NEXT FIELD bmb03            
            END IF 
            
               #FUN-C30047---begin
               LET l_ima928 = 'N'
               SELECT ima928 INTO l_ima928 FROM ima_file
                WHERE ima01 = g_bmb[l_ac].bmb03
               IF l_ima928 = 'Y' THEN
                  CALL cl_err('','ima-001',1)
                  LET g_bmb[l_ac].bmb03 = g_bmb_t.bmb03
                  NEXT FIELD bmb03
               END IF 
               #FUN-C30047---end
            END IF
            #FUN-AA0059 ----------------------------add end------------------------------
            #增加判斷邏輯
            IF g_bmb[l_ac].bmb30 = '3' THEN   #如果當前的計算方式是"3.公式"的話那么就不進行正常的檢測了
               #新的檢核邏輯:檢查對應的公式是否存在
               IF NOT cl_null(g_bmb[l_ac].bmb03) THEN
                  #現在是檢查其中公式前綴對應的三個公式是否至少存在一個
                  LET l_str = '&',g_bmb[l_ac].bmb03 CLIPPED,'-1&'
                  SELECT COUNT(*) INTO l_count FROM gep_file WHERE gep01 = l_str
                  IF l_count > 0 THEN LET l_valid = TRUE
                  ELSE
                    LET l_str = '&',g_bmb[l_ac].bmb03 CLIPPED,'-2&'
                    SELECT COUNT(*) INTO l_count FROM gep_file WHERE gep01 = l_str
                    IF l_count > 0 THEN LET l_valid = TRUE
                    ELSE
                      LET l_str = '&',g_bmb[l_ac].bmb03 CLIPPED,'-3&'
                      SELECT COUNT(*) INTO l_count FROM gep_file WHERE gep01 = l_str
                      IF l_count > 0 THEN LET l_valid = TRUE
                      ELSE LET l_valid = FALSE
                      END IF
                    END IF
                 END IF
                 IF NOT l_valid THEN
                    CALL cl_err(g_bmb[l_ac].bmb03,'lib-253',1)
                    NEXT FIELD bmb03
                 ELSE
                    #因為用戶可能手輸公式名稱,這時就需要來給品名規格賦一下值
                    LET g_bmb[l_ac].ima02_b = g_tipstr
                    LET g_bmb[l_ac].ima021_b = g_tipstr
                 END IF
               ELSE
                 #否則清除可能有品名規格中出現的<依公式生成>字樣
                 LET g_bmb[l_ac].ima02_b = ''
                 LET g_bmb[l_ac].ima021_b = ''
               END IF
            ELSE
               #以下是原有判斷邏輯
               IF cl_null(g_bmb[l_ac].bmb03) THEN
                  LET g_bmb[l_ac].bmb03=g_bmb_t.bmb03
               END IF
               IF NOT cl_null(g_bmb[l_ac].bmb03) THEN
                   #IF cl_null(g_bmb_t.bmb03) THEN    #MOD-740315
                   IF cl_null(g_bmb_t.bmb03) OR g_bmb_t.bmb03 <> g_bmb[l_ac].bmb03 THEN     #MOD-740315
                      SELECT COUNT(*) INTO l_n FROM bmb_inplan
                             WHERE bmb01=g_bma.bma01
                               AND bmb29=g_bma.bma06 #FUN-550014 add
                               AND bmb03=g_bmb[l_ac].bmb03
                      IF l_n>0 THEN
                         IF NOT cl_confirm('abm-728') THEN NEXT FIELD bmb03 END IF
                      END IF
                   END IF
                   CALL i600_bmb03(p_cmd)    #必需讀取(料件主檔) #No:7685
                           IF NOT cl_null(g_errno) THEN
                               CALL cl_err('',g_errno,0)
                               LET g_bmb[l_ac].bmb03=g_bmb_t.bmb03
                               NEXT FIELD bmb03
                           END IF
                  #MOD-A90180---modify---start---
                  #IF p_cmd = 'a' THEN LET g_bmb15 = g_ima70_b END IF
                   IF cl_null(g_bmb_t.bmb03) OR g_bmb_t.bmb03 <> g_bmb[l_ac].bmb03 THEN
                      LET g_bmb15 = g_ima70_b
                   END IF
                  #MOD-A90180---modify---end
                   IF s_bomchk(g_bma.bma01,g_bmb[l_ac].bmb03,g_ima08_h,g_ima08_b)
                             THEN NEXT FIELD bmb03
                   END IF
                   IF g_bmb[l_ac].bmb10 IS NULL OR g_bmb[l_ac].bmb10 = ' '
                              OR g_bmb[l_ac].bmb03 != g_bmb_t.bmb03
                             THEN LET g_bmb[l_ac].bmb10 = g_ima63_b
                                  DISPLAY g_ima63_b   TO s_bmb[l_sl].bmb10
                                 #MOD-CA0039---add---S
                                  CALL s_umfchk(g_bmb[l_ac].bmb03,g_bmb[l_ac].bmb10,g_ima25_b)
                                         RETURNING g_sw,g_bmb10_fac
                                  IF g_sw THEN LET g_bmb10_fac = 1 END IF
                                  CALL s_umfchk(g_bmb[l_ac].bmb03,g_bmb[l_ac].bmb10,g_ima86_b)
                                         RETURNING g_sw,g_bmb10_fac2
                                  IF g_sw THEN LET g_bmb10_fac2 = 1 END IF
                                 #MOD-CA0039---add---E
                 #FUN-910088--add--start--
                   CALL i600_bmb081_check() RETURNING l_tf
                 #FUN-910088--add--end--
                   END IF
                   IF g_ima08_b = 'D'
                             THEN LET g_bmb17 = 'Y'
                             ELSE LET g_bmb17 = 'N'
                   END IF
               END IF
            END IF     #No.FUN-610022
            IF s_industry('slk') THEN     #MOD-970116 add
               IF NOT cl_null(g_bmb[l_ac].bmb03) THEN
                  SELECT ima151 INTO r_ima151 FROM ima_file WHERE ima01 = g_bmb[l_ac].bmb03
                  IF g_bmb[l_ac].bmb30 = '1' THEN    #MOD-970116 add
                     IF  r_ima151 = 'Y' THEN
                         CALL cl_err('','abm-645',0)
                         NEXT FIELD bmb03
                     END IF
                  END IF
                  IF g_bmb[l_ac].bmb30 = '4' THEN    #MOD-970116 add
                     IF  r_ima151 <> 'Y' THEN
                         CALL cl_err('','abm-646',0)
                         NEXT FIELD bmb03
                     END IF
                  END IF
              END IF
              IF g_bmb[l_ac].bmb02 IS NOT NULL AND g_bmb[l_ac].bmb03 IS NOT NULL AND
                 g_bmb[l_ac].bmb04 IS NOT NULL AND g_bmb[l_ac].bmb13 IS NOT NULL AND p_cmd = 'a'THEN
                SELECT COUNT(*) INTO l_r  FROM bmb_inplan WHERE bmb01 = g_bma.bma01
                                                          AND bmb02 = g_bmb[l_ac].bmb02
                                                          AND bmb03 = g_bmb[l_ac].bmb03
                                                          AND bmb04 = g_bmb[l_ac].bmb04
                                                          AND bmb13 = g_bmb[l_ac].bmb13
               IF l_r >0 THEN
                  CALL cl_err('','abm-644',0)
                  NEXT FIELD bmb02
               END IF
              END IF
              IF NOT cl_null(g_bmb[l_ac].bmb03) THEN      #No.FUN-850017
                CALL i600_bmb30(g_bmb[l_ac].bmb30,g_bmb[l_ac].bmb03)  RETURNING l_success
                IF l_success = 'N' THEN
                  LET g_bmb[l_ac].bmb03 = g_bmb_t.bmb03
                  NEXT FIELD bmb03
                END IF
              END IF   #No.FUN-850017
            END IF
         #FUN-910088--add--start--
           IF NOT cl_null(l_tf) AND NOT l_tf THEN
              LET g_bmb10_t = g_bmb[l_ac].bmb10
              NEXT FIELD bmb081
           END IF
           LET g_bmb10_t = g_bmb[l_ac].bmb10
         #FUN-910088--add--end--

        AFTER FIELD bmb04                        #check 是否重復
            IF NOT cl_null(g_bmb[l_ac].bmb04) THEN
               IF NOT cl_null(g_bmb[l_ac].bmb05) THEN
                  IF g_bmb[l_ac].bmb05 < g_bmb[l_ac].bmb04 THEN
                     CALL cl_err(g_bmb[l_ac].bmb04,'mfg2604',0)
                     NEXT FIELD bmb04
                  END IF
               END IF
                IF g_bmb[l_ac].bmb04 IS NOT NULL AND
                   (g_bmb[l_ac].bmb04 != g_bmb_t.bmb04 OR
                    g_bmb_t.bmb04 IS NULL OR
                    g_bmb[l_ac].bmb02 != g_bmb_t.bmb02 OR
                    g_bmb_t.bmb02 IS NULL OR
                    g_bmb[l_ac].bmb03 != g_bmb_t.bmb03 OR
                    g_bmb_t.bmb03 IS NULL) THEN
                    SELECT count(*) INTO l_n
                        FROM bmb_inplan
                        WHERE bmb01 = g_bma.bma01
                           AND bmb29 = g_bma.bma06 #FUN-550014 add
                           AND bmb02 = g_bmb[l_ac].bmb02
                           AND bmb03 = g_bmb[l_ac].bmb03
                           AND bmb04 = g_bmb[l_ac].bmb04
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_bmb[l_ac].bmb02 = g_bmb_t.bmb02
                        LET g_bmb[l_ac].bmb03 = g_bmb_t.bmb03
                        LET g_bmb[l_ac].bmb04 = g_bmb_t.bmb04
                        DISPLAY g_bmb[l_ac].bmb02 TO s_bmb[l_sl].bmb02
                        DISPLAY g_bmb[l_ac].bmb03 TO s_bmb[l_sl].bmb03
                        DISPLAY g_bmb[l_ac].bmb04 TO s_bmb[l_sl].bmb04
                        NEXT FIELD bmb02
                    END IF
                END IF
                CALL i600_bdate(p_cmd)     #生效日
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bmb[l_ac].bmb04,g_errno,0)
                   LET g_bmb[l_ac].bmb04 = g_bmb_t.bmb04
                   DISPLAY g_bmb[l_ac].bmb04 TO s_bmb[l_sl].bmb04
                   NEXT FIELD bmb04
                END IF
            END IF
            IF s_industry('slk') THEN
              IF g_bmb[l_ac].bmb02 IS NOT NULL AND g_bmb[l_ac].bmb03 IS NOT NULL AND
                 g_bmb[l_ac].bmb04 IS NOT NULL AND g_bmb[l_ac].bmb13 IS NOT NULL AND p_cmd = 'a' THEN
                SELECT COUNT(*) INTO l_r  FROM bmb_inplan WHERE bmb01 = g_bma.bma01
                                                          AND bmb02 = g_bmb[l_ac].bmb02
                                                          AND bmb03 = g_bmb[l_ac].bmb03
                                                          AND bmb04 = g_bmb[l_ac].bmb04
                                                          AND bmb13 = g_bmb[l_ac].bmb13
               IF l_r >0 THEN
                  CALL cl_err('','abm-644',0)
                  NEXT FIELD bmb02
               END IF
              END IF
           END IF
        AFTER FIELD bmb05   #check失效日小于生效日
            IF NOT cl_null(g_bmb[l_ac].bmb05) THEN
               IF NOT cl_null(g_bmb[l_ac].bmb04) THEN
                  IF g_bmb[l_ac].bmb05 < g_bmb[l_ac].bmb04 THEN
                     CALL cl_err(g_bmb[l_ac].bmb05,'mfg2604',0)
                     NEXT FIELD bmb05
                  END IF
               END IF
                IF g_bmb[l_ac].bmb05 IS NOT NULL OR g_bmb[l_ac].bmb05 != ' '
                   THEN IF g_bmb[l_ac].bmb05 < g_bmb[l_ac].bmb04
                          THEN CALL cl_err(g_bmb[l_ac].bmb05,'mfg2604',0)
                          NEXT FIELD bmb04
                        END IF
                END IF
                CALL i600_edate(p_cmd)     #生效日
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bmb[l_ac].bmb05,g_errno,0)
                   LET g_bmb[l_ac].bmb05 = g_bmb_t.bmb05
                   DISPLAY g_bmb[l_ac].bmb05 TO s_bmb[l_sl].bmb05
                   NEXT FIELD bmb04
                END IF
            END IF

        AFTER FIELD bmb06    #組成用量不可小于零
          IF NOT cl_null(g_bmb[l_ac].bmb06) THEN
             IF g_bmb[l_ac].bmb14 <> '2' THEN    #FUN-9C0040
                IF g_bmb[l_ac].bmb06 <= 0 THEN
                   CALL cl_err(g_bmb[l_ac].bmb06,'mfg2614',0)
                   LET g_bmb[l_ac].bmb06 = g_bmb_o.bmb06
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_bmb[l_ac].bmb06
                   #------MOD-5A0095 END------------
                   NEXT FIELD bmb06
                END IF
             #FUN-9C0040--begin--add---
             ELSE
               #IF g_bmb[l_ac].bmb06 > 0 THEN         #CHI-AC0037
                IF g_bmb[l_ac].bmb06 >= 0 THEN        #CHI-AC0037
                   CALL cl_err('','asf-603',0)
                   NEXT FIELD bmb06
                 END IF
             END IF
             #FUN-9C0040--end--add-----
          END IF
          #CHI-C10024 str add-----
           LET l_n = 0
           SELECT COUNT(*) INTO l_n FROM bmt_file
           WHERE bmt01 = g_bma.bma01
           AND bmt08 = g_bma.bma06
           AND bmt02 = g_bmb[l_ac].bmb02
           AND bmt03 = g_bmb[l_ac].bmb03
           AND bmt04 = g_bmb[l_ac].bmb04
           IF l_n>0 THEN
             LET l_qpa = g_bmb[l_ac].bmb06 / g_bmb[l_ac].bmb07

             IF g_bmb_o.bmb06 != g_bmb[l_ac].bmb06 THEN
               CALL i200(g_bma.bma01,g_bmb[l_ac].bmb02,
                         g_bmb[l_ac].bmb03,g_bmb[l_ac].bmb04,'u',l_qpa,g_bma.bma06)
             END IF
           END IF
          #CHI-C10024 end add-----
          LET g_bmb_o.bmb06 = g_bmb[l_ac].bmb06

        AFTER FIELD bmb07    #底數不可小于等于零
            IF NOT cl_null(g_bmb[l_ac].bmb07) THEN
                IF g_bmb[l_ac].bmb07 <= 0
                 THEN CALL cl_err(g_bmb[l_ac].bmb07,'mfg2615',0)
                      LET g_bmb[l_ac].bmb07 = g_bmb_o.bmb07
                      #------MOD-5A0095 START----------
                       DISPLAY BY NAME g_bmb[l_ac].bmb07
                      #------MOD-5A0095 END------------
                      NEXT FIELD bmb07
                END IF
                #CHI-C10024 str add-----
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM bmt_file
                 WHERE bmt01 = g_bma.bma01
                 AND bmt08 = g_bma.bma06
                 AND bmt02 = g_bmb[l_ac].bmb02
                 AND bmt03 = g_bmb[l_ac].bmb03
                 AND bmt04 = g_bmb[l_ac].bmb04
                 IF l_n>0 THEN
                   LET l_qpa = g_bmb[l_ac].bmb06 / g_bmb[l_ac].bmb07

                   IF g_bmb_o.bmb07 != g_bmb[l_ac].bmb07 THEN
                     CALL i200(g_bma.bma01,g_bmb[l_ac].bmb02,
                               g_bmb[l_ac].bmb03,g_bmb[l_ac].bmb04,'u',l_qpa,g_bma.bma06)
                   END IF
                 END IF
                #CHI-C10024 end add-----
                LET g_bmb_o.bmb07 = g_bmb[l_ac].bmb07
            ELSE
               CALL cl_err(g_bmb[l_ac].bmb07,'mfg3291',1)
               LET g_bmb[l_ac].bmb07 = g_bmb_o.bmb07
               NEXT FIELD bmb07
            END IF

        AFTER FIELD bmb08    #損耗率
            IF NOT cl_null(g_bmb[l_ac].bmb08) THEN
                IF g_bmb[l_ac].bmb08 < 0 OR g_bmb[l_ac].bmb08 > 100
                 THEN CALL cl_err(g_bmb[l_ac].bmb08,'mfg4063',0)
                      LET g_bmb[l_ac].bmb08 = g_bmb_o.bmb08
                      NEXT FIELD bmb08
                END IF
                LET g_bmb_o.bmb08 = g_bmb[l_ac].bmb08
            END IF
            IF cl_null(g_bmb[l_ac].bmb08) THEN
                LET g_bmb[l_ac].bmb08 = 0
            END IF
            DISPLAY BY NAME g_bmb[l_ac].bmb08
        #No.FUN-A50089--begin
        AFTER FIELD bmb081    #固定損耗量
            IF NOT i600_bmb081_check() THEN NEXT FIELD bmb081 END IF   #FUN-910088--add--
          #FUN-910088--mark--start--
          # IF NOT cl_null(g_bmb[l_ac].bmb081) THEN
          #     IF g_bmb[l_ac].bmb081 < 0 THEN
          #        CALL cl_err(g_bmb[l_ac].bmb081,'aec-020',0)
          #        LET g_bmb[l_ac].bmb081 = g_bmb_o.bmb081
          #        NEXT FIELD bmb081
          #     END IF
          #     LET g_bmb_o.bmb081 = g_bmb[l_ac].bmb081
          # END IF
          # IF cl_null(g_bmb[l_ac].bmb081) THEN
          #     LET g_bmb[l_ac].bmb081 = 0
          # END IF
          # DISPLAY BY NAME g_bmb[l_ac].bmb081
          #FUN-910088--mark--end--

        AFTER FIELD bmb082    #損耗批量
            IF NOT cl_null(g_bmb[l_ac].bmb082) THEN
                IF g_bmb[l_ac].bmb082 <= 0 THEN
                   CALL cl_err(g_bmb[l_ac].bmb082,'alm-808',0)
                   LET g_bmb[l_ac].bmb082 = g_bmb_o.bmb082
                   NEXT FIELD bmb082
                END IF
                LET g_bmb_o.bmb082 = g_bmb[l_ac].bmb082
            END IF
            IF cl_null(g_bmb[l_ac].bmb082) THEN
                LET g_bmb[l_ac].bmb082 = 1
            END IF
            DISPLAY BY NAME g_bmb[l_ac].bmb082
        #No.FUN-A50089--end
        AFTER FIELD bmb09    #作業編號
            IF NOT cl_null(g_bmb[l_ac].bmb09)
               THEN
               SELECT COUNT(*) INTO g_cnt FROM ecd_file
                WHERE ecd01=g_bmb[l_ac].bmb09
               IF g_cnt=0
                  THEN
                  CALL cl_err('sel ecd_file',100,0)
                  NEXT FIELD bmb09
               END IF
            END IF
            IF g_bmb[l_ac].bmb09 IS NULL THEN
                LET g_bmb[l_ac].bmb09 = ' '
            END IF

        AFTER FIELD bmb10   #發料單位
           IF g_bmb[l_ac].bmb10 IS NULL OR g_bmb[l_ac].bmb10 = ' '
             THEN LET g_bmb[l_ac].bmb10 = g_bmb_o.bmb10
             DISPLAY BY NAME g_bmb[l_ac].bmb10
             ELSE
                IF cl_null(g_bmb[l_ac].bmb30) THEN
                   LET g_bmb[l_ac].bmb30 = ' '
                END IF
                 IF ((g_bmb_o.bmb10 IS NULL) OR (g_bmb_t.bmb10 IS NULL)
                      OR (g_bmb[l_ac].bmb10 != g_bmb_o.bmb10))
                     AND (g_bmb[l_ac].bmb30 <> '3' )   #FUN-640139 Add , 如果是當前方式為“公式”則不判斷
                  THEN CALL i600_bmb10()
                       IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_bmb[l_ac].bmb10,g_errno,0)
                           LET g_bmb[l_ac].bmb10 = g_bmb_o.bmb10
                           DISPLAY g_bmb[l_ac].bmb10 TO s_bmb[l_sl].bmb10
                           NEXT FIELD bmb10
                       ELSE IF g_bmb[l_ac].bmb10 != g_ima25_b
                            THEN CALL s_umfchk(g_bmb[l_ac].bmb03,
                                 g_bmb[l_ac].bmb10,g_ima25_b)
                                 RETURNING g_sw,g_bmb10_fac  #發料/庫存單位
                                 IF g_sw THEN
                                   CALL cl_err(g_bmb[l_ac].bmb10,'mfg2721',0)
                                   LET g_bmb[l_ac].bmb10 = g_bmb_o.bmb10
                                   DISPLAY g_bmb[l_ac].bmb10 TO
                                           s_bmb[l_sl].bmb10
                                   NEXT FIELD bmb10
                                 END IF
                            ELSE   LET g_bmb10_fac  = 1
                            END  IF
                            IF g_bmb[l_ac].bmb10 != g_ima86_b  #發料/成本單位
                            THEN CALL s_umfchk(g_bmb[l_ac].bmb03,
                                         g_bmb[l_ac].bmb10,g_ima86_b)
                                 RETURNING g_sw,g_bmb10_fac2
                                 IF g_sw THEN
                                   CALL cl_err(g_bmb[l_ac].bmb03,'mfg2722',0)
                                   LET g_bmb[l_ac].bmb10 = g_bmb_o.bmb10
                                   DISPLAY g_bmb[l_ac].bmb10 TO
                                             s_bmb[l_sl].bmb10
                                   NEXT FIELD bmb10
                                 END IF
                            ELSE LET g_bmb10_fac2 = 1
                          END IF
                       END IF
                  END IF
               #FUN-910088--add--start--
                 IF NOT i600_bmb081_check() THEN
                    LET g_bmb10_t = g_bmb[l_ac].bmb10
                    LET g_bmb_o.bmb10 = g_bmb[l_ac].bmb10
                    NEXT FIELD bmb081
                 END IF
                 LET g_bmb10_t = g_bmb[l_ac].bmb10
              #FUN-910088--add--end--
          END IF
          LET g_bmb_o.bmb10 = g_bmb[l_ac].bmb10

        AFTER FIELD bmb16  #替代特性
           IF NOT cl_null(g_bmb[l_ac].bmb16) THEN
#              IF g_bmb[l_ac].bmb16 NOT MATCHES'[0125]'  THEN  #FUN-A20037
#              IF g_bmb[l_ac].bmb16 NOT MATCHES'[01257]' THEN  #FUN-A20037 #TQC-C20388 mark
               IF g_bmb[l_ac].bmb16 NOT MATCHES'[012579]' THEN #TQC-C20388
                   LET g_bmb[l_ac].bmb16 = g_bmb_o.bmb16
                   DISPLAY BY NAME g_bmb[l_ac].bmb16
                   NEXT FIELD bmb16
               END IF
               #FUN-9C0040--begin--add----------
               IF NOT cl_null(g_bmb[l_ac].bmb14) THEN
                  IF g_bmb[l_ac].bmb14 = '2' THEN
                     LET g_bmb[l_ac].bmb16 = '0'
                  END IF
               END IF
               #FUN-9C0040--end--add-------------
               IF g_bmb[l_ac].bmb16 != '0' AND        #詢問是否輸入取代或替代料件
                  (g_bmb[l_ac].bmb16 != g_bmb_o.bmb16)
                   THEN
                       CALL i6002_prompt()
               END IF
               LET g_bmb_o.bmb16 = g_bmb[l_ac].bmb16
           END IF

        AFTER FIELD bmb14  # 94/12/10 By roger
           IF NOT cl_null(g_bmb[l_ac].bmb14) THEN
               IF g_bmb[l_ac].bmb14 NOT MATCHES'[0123]' THEN  #FUN-910053 add 23
                   LET g_bmb[l_ac].bmb14 = g_bmb_o.bmb14
                   DISPLAY BY NAME g_bmb[l_ac].bmb14
                   NEXT FIELD bmb14
               END IF
              #FUN-9C0040--begin--add--------------
              IF g_bmb[l_ac].bmb14 = '2' THEN
                 LET g_bmb[l_ac].bmb16 = '0'
              END IF
              IF cl_null(g_bmb[l_ac].bmb06) OR g_bmb[l_ac].bmb06=0 THEN
                 IF g_bmb[l_ac].bmb14 = '2' THEN
                    LET g_bmb[l_ac].bmb06 = -1
                 ELSE
                    LET g_bmb[l_ac].bmb06 = 1
                 END IF
              ELSE
                 IF g_bmb[l_ac].bmb14 = '2' AND g_bmb[l_ac].bmb06 > 0 THEN
                    LET g_bmb[l_ac].bmb06=g_bmb[l_ac].bmb06 * (-1)
                 END IF
                 IF g_bmb[l_ac].bmb14 <> '2' AND g_bmb[l_ac].bmb06 < 0 THEN
                    LET g_bmb[l_ac].bmb06=g_bmb[l_ac].bmb06 * (-1)
                 END IF
              END IF
              #FUN-9C0040--end--add----------
           END IF

        AFTER FIELD bmb19
          IF NOT cl_null(g_bmb[l_ac].bmb19) THEN
              IF g_bmb[l_ac].bmb19 NOT MATCHES'[1234]' THEN
                  LET g_bmb[l_ac].bmb19 = g_bmb_o.bmb19
                  DISPLAY BY NAME g_bmb[l_ac].bmb19
                  NEXT FIELD bmb19
              END IF
          END IF
         #CHI-B70045---mark---start---
         #IF NOT s_industry('slk') THEN    #No.FUN-870124
         #   IF g_ima107_b = 'Y' THEN #Y:自動開窗輸入insert_loc
         #      CALL i600_loc('u')
         #   END IF
         #END IF                           #No.FUN-870124
         #CHI-B70045---mark---end---

          AFTER FIELD bmb30
             IF cl_null(g_bmb[l_ac].bmb30) THEN
                LET g_bmb[l_ac].bmb30 = ' '
             END IF
           IF s_industry('slk') THEN
            IF NOT cl_null(g_bmb[l_ac].bmb03) THEN      #No.FUN-850079
             CALL i600_bmb30(g_bmb[l_ac].bmb30,g_bmb[l_ac].bmb03)  RETURNING l_success
             IF l_success = 'N' THEN
                LET g_bmb[l_ac].bmb30 = g_bmb_t.bmb30
                NEXT FIELD bmb30
             END IF
            END IF               #NO.FUN-850079

           END IF


        AFTER FIELD bmbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bmbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        BEFORE DELETE                            #是否取消單身
            IF g_bmb_t.bmb02 > 0 AND
               g_bmb_t.bmb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM vmo_file where vmo01=g_bma.bma01 AND
                                           vmo02=g_bmb_t.bmb03 AND
                                           vmo03=g_bmb_t.bmb02
                DELETE FROM bmb_inplan
                    WHERE bmb01 = g_bma.bma01
                      AND bmb29 = g_bma.bma06 #FUN-550014 add
                      AND bmb02 = g_bmb_t.bmb02
                      AND bmb03 = g_bmb_t.bmb03
                      AND bmb04 = g_bmb_t.bmb04
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 OR g_success='N' THEN
                    LET l_buf = g_bmb_t.bmb02 clipped,'+',
                                g_bmb_t.bmb03 clipped,'+',
                                g_bmb_t.bmb04
                    CALL cl_err(l_buf,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                 ELSE
                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                END IF
                DELETE FROM bmt_file
                    WHERE bmt01 = g_bma.bma01   AND
                          bmt08 = g_bma.bma06   AND #FUN-550014 add
                          bmt02 = g_bmb_t.bmb02 AND
                          bmt03 = g_bmb_t.bmb03 AND
                          bmt04 = g_bmb_t.bmb04
                IF SQLCA.sqlcode OR g_success='N' THEN
                    CALL cl_err('',SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                 ELSE
                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                END IF
               #MOD-B40221---add---start---
                DELETE FROM bmc_file
                 WHERE bmc01 = g_bma.bma01
                   AND bmc02 = g_bmb_t.bmb02
                   AND bmc021 = g_bmb_t.bmb03
                   AND bmc03 = g_bmb_t.bmb04
                   AND bmc06 = g_bma.bma06
                IF SQLCA.sqlcode OR g_success='N' THEN
                    CALL cl_err('',SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                ELSE
                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                END IF
               #MOD-B40221---add---end---

               #TQC-C30115---begin
               IF s_industry('icd') THEN
                   DELETE FROM icm_file
                    WHERE icm02 = g_bma.bma01
                      AND icm01 = g_bmb_t.bmb03
                   IF SQLCA.sqlcode OR g_success='N' THEN
                      CALL cl_err('',SQLCA.sqlcode,0)
                      ROLLBACK WORK
                      CANCEL DELETE
                   ELSE
                      LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                   END IF
               END IF     
               #TQC-C30115---end
               
                DELETE FROM bmd_file
                    WHERE bmd01 = g_bmb_t.bmb03 AND
                          bmd08 = g_bma.bma01 AND
                          bmd08 != 'ALL'
                IF SQLCA.sqlcode OR g_success='N' THEN
                    CALL cl_err('',SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                 ELSE
                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                END IF
                IF g_sma.sma845='Y' THEN  #低階碼可否部份重計
                    LET g_success='Y'
                    IF g_bmb[l_ac].bmb30!= '3' THEN    #MOD-D80128 130820
                      #CALL s_uima146(g_bmb[l_ac].bmb03)  #CHI-D10044
                      CALL s_uima146(g_bmb[l_ac].bmb03,0)  #CHI-D10044
                    END IF                       #MOD-D80128 130820
                    MESSAGE ""
                    IF g_success='N' THEN
                       CALL cl_err(g_bmb[l_ac].bmb03,'abm-002',1)
                       ROLLBACK WORK
                       CANCEL DELETE
                     ELSE
                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                    END IF
                END IF

                #如果當前定義了公式則刪除對應的公式
                IF g_bmb[l_ac].bmb30 = '3' THEN
                   IF NOT cl_null(g_bmb[l_ac].bmb03) THEN
                      LET l_formula01 = '&',g_bmb[l_ac].bmb03 CLIPPED,'-1&'
                      LET l_formula02 = '&',g_bmb[l_ac].bmb03 CLIPPED,'-2&'
                      LET l_formula03 = '&',g_bmb[l_ac].bmb03 CLIPPED,'-3&'

                      #公式單頭檔
                      DELETE FROM gep_file WHERE
                        gep01 = l_formula01 OR gep01 = l_formula02 OR
                        gep01 = l_formula03
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("del","gep_file",l_formula01,l_formula02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                         ROLLBACK WORK
                         CANCEL DELETE
                       ELSE
                        LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                      END IF
                      #公式單身檔(變量)
                      DELETE FROM geq_file WHERE
                        geq01 = l_formula01 OR geq01 = l_formula02 OR
                        geq01 = l_formula03
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("del","geq_file",l_formula01,l_formula02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                         ROLLBACK WORK
                         CANCEL DELETE
                       ELSE
                         LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                      END IF
                      #公式單身檔(表達式)
                      DELETE FROM ger_file WHERE
                        ger01 = l_formula01 OR ger01 = l_formula02 OR
                        ger01 = l_formula03
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("del","ger_file",l_formula01,l_formula02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                         ROLLBACK WORK
                         CANCEL DELETE
                       ELSE
                         LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                      END IF
                   END IF
                END IF

                LET g_modify_flag = 'Y' #MOD-530319
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
           IF s_industry('slk') THEN
            LET l_count1 = 0
            SELECT COUNT(*) INTO l_count1 FROM bmb_inplan WHERE bmb01 = g_bma.bma01
                                                          AND bmb29 = g_bma.bma06
                                                          AND bmb03 = g_bmb_t.bmb03
            IF l_count1 <= 0 THEN
                DELETE FROM bmv_file
                    WHERE bmv01 = g_bma.bma01
                      AND bmv03 = g_bma.bma06
                      AND bmv02 = g_bmb_t.bmb03
                IF SQLCA.sqlcode OR g_success='N' THEN    #NO.FUN-850017
                    CALL cl_err(g_bmb_t.bmb03,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                 ELSE
                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A50010
                END IF
            END IF
           END IF

           CALL i600_tree_update()

         COMMIT WORK

#FUN-C20105 --begin--
##FUN-B90117--BEGIN--
#           LET g_tree_sel='1'
#           LET g_bma01_tree=g_tree1[1].treekey4
#           CALL g_tree1.clear()
#           CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma01_tree)  #删除单身重新刷新树状图
##FUN-B90117--END--
       
           LET g_tree_sel='1'
        #  IF g_lock='Y' THEN     #FUN-CB0078 mark
           IF NOT cl_null(g_tree_item) OR g_tree_arr_curr > 0 THEN   #FUN-CB0078 add
              LET g_bma01_tree=g_tree1[1].treekey4
           ELSE
              LET g_bma01_tree=g_bma.bma01
           END IF 
           CALL g_tree1.clear()
           CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma01_tree)
#FUN-C20105 --end--

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmb[l_ac].* = g_bmb_t.*
               CLOSE i600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bmb[l_ac].bmb02,-263,1)
                LET g_bmb[l_ac].* = g_bmb_t.*
            ELSE

             ###FUN-9A50010 START ###  
               #CALL i600_tree_loop(g_bma.bma01,g_bmb[l_ac].bmb03,NULL) RETURNING l_loop  #檢查是否為無窮迴圈
               #IF l_loop = "Y" THEN
               #   CALL cl_err(g_bmb[l_ac].bmb03,"agl1000",1)
               #   LET g_abd[l_ac].* = g_abd_t.*
               #ELSE
               ###FUN-9A50010 END ###
               #TQC-C60231--add--str--
               CALL i600_tree_loop(g_bma.bma01,g_bmb[l_ac].bmb03,NULL) RETURNING l_loop
                  IF l_loop = "Y" THEN
                  CALL cl_err(g_bmb[l_ac].bmb03,"agl1000",1)
                  LET g_bmb[l_ac].* = g_bmb_t.*
                  NEXT FIELD bmb02
               END IF
               #TQC-C60231--add--end--

                CALL i600_b_move_back() #FUN-730075
           IF g_bmb_t.bmb03 <> b_bmb.bmb03 THEN
            LET l_count1 = 0
            SELECT COUNT(*) INTO l_count1 FROM bmb_inplan WHERE bmb01 = g_bma.bma01
                                                          AND bmb29 = g_bma.bma06
                                                          AND bmb03 = g_bmb_t.bmb03
            IF l_count1 <= 0 THEN
                DELETE FROM bmv_file
                    WHERE bmv01 = g_bma.bma01
                      AND bmv03 = g_bma.bma06
                      AND bmv02 = g_bmb_t.bmb03
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 OR g_success='N' THEN
                    CALL cl_err(g_bmb_t.bmb03,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                END IF
            END IF
           END IF
                UPDATE bmb_inplan SET * = b_bmb.*
                 WHERE bmb01 = g_bma.bma01
                   AND bmb29 = g_bma.bma06 #FUN-550014
                   AND bmb02 = g_bmb_t.bmb02
                   AND bmb03 = g_bmb_t.bmb03
                   AND bmb04 = g_bmb_t.bmb04
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","bmb_inplan",g_bma.bma01,g_bmb_t.bmb02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    LET g_bmb[l_ac].* = g_bmb_t.*

                ELSE
                    UPDATE bma_inplan SET bmadate = g_today
                                    WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
                    #--->update 上一項次失效日
                    CALL i600_update('u')
                    IF g_sma.sma845='Y' AND  #低階碼可否部份重計
                       g_bmb_t.bmb03 <> g_bmb[l_ac].bmb03
                       THEN
                       #CALL s_uima146(g_bmb[l_ac].bmb03)  #CHI-D10044
                       #CALL s_uima146(g_bmb_t.bmb03)  #CHI-D10044
                       IF g_bmb[l_ac].bmb30!= '3' THEN    #MOD-D80128 130820
                          CALL s_uima146(g_bmb[l_ac].bmb03,0)  #CHI-D10044
                          CALL s_uima146(g_bmb_t.bmb03,0)  #CHI-D10044
                       END IF                       #MOD-D80128 130820
                       MESSAGE ""
                       IF g_success='N' THEN
                           #不可輸入此元件料號,因為產品結構偵錯發現有誤! #MOD-530319
                          CALL cl_err(g_bmb[l_ac].bmb03,'abm-602',1)    #MOD-530319
                          LET g_bmb[l_ac].* = g_bmb_t.*
                          DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                          ROLLBACK WORK
                          NEXT FIELD bmb02
                       END IF
                    END IF
                    #--->新增料件時系統參數(sma18 低階碼是重新計算)
                    IF l_uflag = 'N' THEN
                       UPDATE sma_file SET sma18 = 'Y'
                               WHERE sma00 = '0'
                       IF SQLCA.SQLERRD[3] = 0 THEN
                         CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","cannot update sma_file",1)  #No.TQC-660046
                       END IF
                       LET l_uflag = 'Y'
                    END IF
                    LET g_modify_flag = 'Y' #MOD-530319
                    MESSAGE 'UPDATE O.K'
                    IF g_aflag = 'N' THEN LET g_aflag = 'Y' END IF
                    IF g_bmb[l_ac].bmb03 != g_bmb_t.bmb03 THEN
                       #TQC-C30115---begin
                       IF s_industry('icd') THEN
                          UPDATE icm_file
                           SET icm01 = g_bmb[l_ac].bmb03
                            WHERE icm01 = g_bmb_t.bmb03
                              AND icm02 = g_bma.bma01
                          IF sqlca.sqlcode THEN
                             CALL cl_err('',SQLCA.sqlcode,0) 
                             LET g_bmb[l_ac].* = g_bmb_t.*
                             DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                             ROLLBACK WORK
                             EXIT INPUT
                          END IF
                       END IF 
                      #TQC-C30115---end
                       SELECT COUNT(*) INTO l_n FROM bmt_file
                        WHERE bmt01 = g_bma.bma01
                          AND bmt03 = g_bmb_t.bmb03
                       IF l_n > 0 THEN
                          UPDATE bmt_file SET bmt03 = g_bmb[l_ac].bmb03
                           WHERE bmt01 = g_bma.bma01   #主件料件編號
                             AND bmt03 = g_bmb_t.bmb03 #元件料件編號
                             AND bmt02 = g_bmb_t.bmb02 #項次
                             AND bmt04 = g_bmb_t.bmb04 #生效日期
                             AND bmt08 = g_bma.bma06 #特性代碼
                          IF sqlca.sqlcode THEN
                             CALL cl_err('update bmt03','abm-041',1)  #更新插件位置資料有誤!
                             LET g_bmb[l_ac].* = g_bmb_t.*
                             DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                             ROLLBACK WORK
                             EXIT INPUT
                          END IF
                       END IF
                    END IF
                    LET l_mdm_tag = 1                    #FUN-850147
                    LET g_wsw03 = g_bma.bma01 CLIPPED ,'|', g_bmb[l_ac].bmb02 CLIPPED
                        CASE aws_mdmdata('bmb_inplan','update',g_wsw03,base.TypeInfo.create(b_bmb),'CreateBOMData')
                        WHEN 0  #無與 MDM 整合
                             MESSAGE 'UPDATE O.K'
                        WHEN 1  #呼叫 MDM 成功
                             MESSAGE 'UPDATE O.K, UPDATE MDM O.K'
                        WHEN 2  #呼叫 MDM 失敗
                             ROLLBACK WORK
                             CONTINUE INPUT
                    END CASE
                    COMMIT WORK
                END IF
            END IF

#FUN-C20105 --begin--
##FUN-B90117--BEGIN--
#           LET g_tree_sel='1'
#           LET g_bma01_tree=g_tree1[1].treekey4
#           CALL g_tree1.clear()
#           CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma01_tree)   #更新单身重新刷新树状图
##FUN-B90117--END--

           LET g_tree_sel='1'
        #  IF g_lock='Y' THEN          #FUN-CB0078 mark
           IF NOT cl_null(g_tree_item) OR g_tree_arr_curr > 0 THEN  #FUN-CB0078 add
              LET g_bma01_tree=g_tree1[1].treekey4
           ELSE
              LET g_bma01_tree=g_bma.bma01
           END IF 
           CALL g_tree1.clear()
           CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma01_tree) 
#FUN-C20105 --end--

        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_bmb[l_ac].* = g_bmb_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            #TQC-B40048--begin
         #   IF g_sma.sma845='Y' THEN   #低階碼可否部份重計 #TQC-B70034 mark
            IF g_sma.sma845 = 'Y' AND NOT cl_null(g_bmb[l_ac].bmb03) THEN  #TQC-B70034
               LET g_success='Y'
               IF g_bmb[l_ac].bmb30!= '3' THEN    #MOD-D80128 130820
                  #CALL s_uima146(g_bmb[l_ac].bmb03)  #CHI-D10044
                  CALL s_uima146(g_bmb[l_ac].bmb03,0)  #CHI-D10044
               END IF                             #MOD-D80128 130820
               IF g_success='N' THEN
                  NEXT FIELD bmb03
               END IF
            END IF
            #TQC-B40048--end
            IF cl_null(g_bmb[l_ac].bmb02) OR
               cl_null(g_bmb[l_ac].bmb03) THEN
               CALL g_bmb.deleteElement(l_ac)
            END IF
            CLOSE i600_bcl
            COMMIT WORK

       ON ACTION edit_formula
        CASE WHEN INFIELD (bmb03)
          #如果bmb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_bmb[l_ac].bmb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bma.bma01,g_bmb[l_ac].bmb03,1) RETURNING l_result
             IF cl_null(g_bmb[l_ac].bmb03) THEN
                LET g_bmb[l_ac].bmb03 = l_result
                #如果公式內容不為空則將品名規格都設置為"<依公式生成>"
                IF NOT cl_null(l_result) THEN
                  LET g_bmb[l_ac].ima02_b = g_tipstr
                  LET g_bmb[l_ac].ima021_b = g_tipstr
                ELSE
                  #否則將品名和規格清空
                  LET g_bmb[l_ac].ima02_b = ''
                  LET g_bmb[l_ac].ima021_b = ''
                END IF
             ELSE
                IF l_result != g_bmb[l_ac].bmb03 THEN
                   LET g_bmb[l_ac].bmb03 = l_result
                   #如果公式內容不為空則將品名規格都設置為"<依公式生成>"
                   IF NOT cl_null(l_result) THEN
                     LET g_bmb[l_ac].ima02_b = g_tipstr
                     LET g_bmb[l_ac].ima021_b = g_tipstr
                   ELSE
                     #否則將品名和規格清空
                     LET g_bmb[l_ac].ima02_b = ''
                     LET g_bmb[l_ac].ima021_b = ''
                   END IF
                END IF
             END IF
          END IF

        WHEN INFIELD (bmb06)
          #如果bmb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_bmb[l_ac].bmb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bma.bma01,g_bmb[l_ac].bmb03,2) RETURNING l_result
             IF cl_null(g_bmb[l_ac].bmb03) THEN
                LET g_bmb[l_ac].bmb03 = l_result
             ELSE
                IF l_result != g_bmb[l_ac].bmb03 THEN
                   LET g_bmb[l_ac].bmb03 = l_result
                END IF
             END IF
          END IF

        WHEN INFIELD (bmb08)
          #如果bmb30"計算方式"為"3.公式"則顯示出aooi503 BOM公式定義對話框
          IF g_bmb[l_ac].bmb30 = '3' THEN
             #傳入的是主件料號,該欄位當前的內容,顯示第一個頁面
             CALL aooi503(g_bma.bma01,g_bmb[l_ac].bmb03,3) RETURNING l_result
             IF cl_null(g_bmb[l_ac].bmb03) THEN
                LET g_bmb[l_ac].bmb03 = l_result
             ELSE
                IF l_result != g_bmb[l_ac].bmb03 THEN
                   LET g_bmb[l_ac].bmb03 = l_result
                END IF
             END IF
          END IF
        OTHERWISE
          CALL cl_err('','abm-998',1)
          EXIT CASE
      END CASE

        ON ACTION create_item_master #建立料件非明細資料
             IF g_sma.sma09 = 'Y' THEN
                IF s_industry('slk') THEN LET l_cmd = "aimi100_slk '",g_bmb[l_ac].bmb03,"'" END IF
                IF s_industry('icd') THEN LET l_cmd = "aimi100_icd '",g_bmb[l_ac].bmb03,"'" END IF
                IF s_industry('std') THEN LET l_cmd = "aimi100 '",g_bmb[l_ac].bmb03,"'" END IF
                IF cl_null(l_cmd) THEN LET l_cmd = "aimi100 '",g_bmb[l_ac].bmb03,"'" END IF
                CALL cl_cmdrun(l_cmd)
                NEXT FIELD bmb03
             ELSE
                CALL cl_err(' ','mfg2617',0)
                NEXT FIELD bmb03
             END IF

        ON ACTION fix
            CALL i600_a_fix_sx(g_bma.bma10,g_bmb[l_ac].bmb03,g_bma.bma01,p_md,g_bma.bma06)  #NO.FUN-840155
        ON ACTION create_unit_data
                    CALL cl_cmdrun('aooi101 ')  #建立單位資料

        ON ACTION create_unit_transfer_data     #建立單位換算資料
                    CALL cl_cmdrun("aooi102 ")

        ON ACTION view_unit_transfer             #料件單位換算資料
                    CALL cl_cmdrun("aooi103 ")

        ON ACTION bom_prompt #維護取替代
                IF g_bmb[l_ac].bmb16 matches'[12579]' THEN     #FUN-A40058 add '7'    #TQC-B90236 add '9'
                    CALL i6002_prompt()
                END IF

        ON ACTION create_loc_data  #建立insert_loc
            COMMIT WORK    # 此時進入abmi601會出現死鎖現象,所以要加COMMIT
            LET l_cmd = "abmi601 '",g_bma.bma01,"' ",
                               "'",g_bma.bma06,"' ",
                               "'",g_vdate,"' " ,
                               "'",g_bmb[l_ac].bmb03,"'"    #No.FUN-870127
            CALL cl_cmdrun_wait(l_cmd)

            LET INT_FLAG = 0    #No.MOD-560066 add
             CALL i600_up_bmb13(l_ac) RETURNING g_bmb[l_ac].bmb13
             DISPLAY BY NAME g_bmb[l_ac].bmb13

        ON ACTION bom_description         #建立元件說明資料(更新才call)
                IF g_bmb_t.bmb02 IS NOT NULL AND g_bmb_t.bmb03 IS NOT NULL
                   AND g_bmb_t.bmb04 IS NOT NULL
                   THEN LET l_cmd = "abmi603 '",g_bma.bma01,"' '",
                                     g_bmb[l_ac].bmb02,"' '",
                                     g_bmb[l_ac].bmb03,"' '",
                                     g_bmb[l_ac].bmb04,"' ",
                                 "'",g_bma.bma06,"' '",g_vdate,"'"  #MOD-940293 add
                        CALL cl_cmdrun(l_cmd)
                END IF

        ON ACTION mntn_item_brand
              LET l_cmd="abmi650 '",g_bmb[l_ac].bmb03,"' '",g_bma.bma01,"'"
       CALL cl_cmdrun(l_cmd)
              NEXT FIELD bmb03




     ON ACTION CONTROLP
           CASE WHEN INFIELD(bmb03) #料件主檔

                IF g_bmb[l_ac].bmb30 = '3' THEN
                   NEXT FIELD bmb03
                ELSE

#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()

                #  CASE g_bmb[l_ac].bmb30
                #       WHEN '1'
                #             LET g_qryparam.form = "q_ima01_2"
                #       WHEN '4'
                #             LET g_qryparam.form = "q_ima01_1"
                #       OTHERWISE
                #             LET g_qryparam.form = "q_ima01"
                #  END CASE
                #  LET g_qryparam.default1 = g_bmb[l_ac].bmb03
                #    CALL cl_create_qry() RETURNING g_bmb[l_ac].bmb03
                  CASE g_bmb[l_ac].bmb30
                       WHEN '1'
                            CALL q_sel_ima(FALSE, "q_ima01_2", "",g_bmb[l_ac].bmb03, "", "", "", "" ,"",'' )  RETURNING g_bmb[l_ac].bmb03

                       WHEN '4'
                            CALL q_sel_ima(FALSE, "q_ima01_1", "",g_bmb[l_ac].bmb03, "", "", "", "" ,"",'' )  RETURNING g_bmb[l_ac].bmb03
                       OTHERWISE
                            CALL q_sel_ima(FALSE, "q_ima01", "",g_bmb[l_ac].bmb03, "", "", "", "" ,"",'' )  RETURNING g_bmb[l_ac].bmb03
                  END CASE
#FUN-AA0059 --End--
                  DISPLAY g_bmb[l_ac].bmb03 TO bmb03
                  NEXT FIELD bmb03
                END IF   #No.FUN-610022

              WHEN INFIELD(bmb09) #作業主檔
                   CALL q_ecd(FALSE,TRUE,g_bmb[l_ac].bmb09) RETURNING g_bmb[l_ac].bmb09
                   DISPLAY g_bmb[l_ac].bmb09 TO bmb09
                   NEXT FIELD bmb09
               WHEN INFIELD(bmb10) #單位檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_bmb[l_ac].bmb10
                  CALL cl_create_qry() RETURNING g_bmb[l_ac].bmb10
                  DISPLAY g_bmb[l_ac].bmb10 TO bmb10
                  NEXT FIELD bmb10


               OTHERWISE EXIT CASE
           END  CASE



        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(bmb02) AND l_ac > 1 THEN
               LET g_bmb[l_ac].* = g_bmb[l_ac-1].*
               LET g_bmb[l_ac].bmb04 = g_today #CHI-6C0034
               LET g_bmb[l_ac].bmb02 = NULL
               LET g_bmb[l_ac].bmb05 = NULL   #No.+003 add
               NEXT FIELD bmb02
           END IF

        ON ACTION CONTROLR
            CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


        AFTER INPUT
          IF g_modify_flag='Y' AND
             g_sma.sma846='Y'   #產品結構有異動時是否自動執行偵錯檢查
             THEN
             LET g_status=0
             LET g_level=0
              LET g_success = 'Y'                   #MOD-530319
            # CALL get_main_bom(g_bma.bma01,'c',1)  #No.FUN-B80100--mark--
             CALL get_mai_bom(g_bma.bma01,'c',1)    #No.FUN-B80100---修改get_main_bom為get_mai_bom---
              IF g_success = 'N'                    #MOD-530319
                THEN
                 CALL cl_err('','abm-002',1)        #MOD-530319
             ELSE
                MESSAGE "Verify Ok!"
             END IF
          END IF


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controls                      #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")  #No.FUN-6B0033

    END INPUT
    CALL FGL_DIALOG_SETFIELDORDER(TRUE)  #FUN-610022恢復原來的狀態
    IF l_flag = 'Y' THEN    #MOD-B40149
       UPDATE bma_inplan SET bmamodu = g_user,bmadate = g_today
         WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
    END IF   #MOD-B40149

    CLOSE i600_bcl
    COMMIT WORK
    #No.MOD-A70036  --Begin
    CALL i600_bmd()
    #No.MOD-A70036  --End

#   CALL i600_delall()                        #CHI-C30002 mark
    CALL i600_delHeader()                     #CHI-C30002 add
    IF g_bma.bma01 IS NULL THEN RETURN END IF #CHI-C30002 add
    CALL i600_b_fill(g_wc2)                 #MOD-8B0160 add

    CALL i600_list_fill()

     ###FUN-9A50010 START ###
    #從Tree進來，且單身資料有異動時
    IF g_tree_b = "Y" AND g_tree_reload = "Y" THEN
       CALL i600_tree_update() #Tree 資料有異動
       LET g_tree_reload = "N"
    END IF
    ###FUN-9A50010END ###

END FUNCTION

#CHI-C30002 ------- add  -------- begin
FUNCTION i600_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         #CHI-C80041---begin
         DELETE FROM bml_file WHERE bml02=g_bma.bma01
         DELETE FROM bmm_file WHERE bmm01=g_bma.bma01
         #CHI-C80041---end
         DELETE FROM bma_inplan WHERE bma01 = g_bma.bma01
                                AND bma06 = g_bma.bma06
         INITIALIZE g_bma.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 ------- add  -------- end
#CHI-C30002 ------- mark -------- begin
#FUNCTION i600_delall()
#   SELECT COUNT(*) INTO g_cnt FROM bmb_inplan
#       WHERE bmb01=g_bma.bma01
#         AND bmb29=g_bma.bma06  #FUN-550014 add
#   IF g_cnt = 0 THEN    # 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM bma_inplan WHERE bma01 = g_bma.bma01
#                             AND bma06 = g_bma.bma06  #FUN-550014 add
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark ------- end

FUNCTION i600_remark()
  DEFINE   l_cmd   LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(200),
           l_chr   LIKE type_file.chr1     #No.FUN-680096 VARCHAR(01)

   IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
      CALL cl_err(g_bma.bma08,'aoo-045',1)
      RETURN
   END IF

   CALL cl_getmsg('mfg2622',g_lang) RETURNING g_msg
   WHILE l_chr IS NULL OR l_chr NOT MATCHES'[YNyn]'
            LET INT_FLAG = 0  ######add for prompt bug
     PROMPT g_msg CLIPPED FOR CHAR l_chr
        ON IDLE g_idle_seconds
           CALL cl_on_idle()

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

     END PROMPT
     IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
   END WHILE
   IF l_chr matches'[Yy]' THEN
      LET l_cmd = "abmi603 '",g_bma.bma01,"' '",
                   g_bmb[l_ac].bmb02,"' '",
                   g_bmb[l_ac].bmb03,"' '",
                   g_bmb[l_ac].bmb04,"' " ,        #FUN-550014
                 "'",g_bma.bma06,"' '",g_vdate,"'" #MOD-940293 add
      CALL cl_cmdrun(l_cmd)
   END IF
END FUNCTION

FUNCTION i600_bmb03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1),
    l_ima110        LIKE ima_file.ima110,
    l_ima140        LIKE ima_file.ima140,
    l_ima1401       LIKE ima_file.ima1401,  #FUN-6A0036 add
    l_imaacti       LIKE ima_file.imaacti


    LET g_errno = ' '
    SELECT ima02,ima021,ima08,ima37,ima25,ima63,ima70,ima86,ima105,ima107,  #No.MOD-5A0193 add ima86
           ima110,ima140,ima1401,imaacti #FUN-6A0036 add ima1401
        INTO g_bmb[l_ac].ima02_b,g_bmb[l_ac].ima021_b,
             g_ima08_b,g_ima37_b,g_ima25_b,g_ima63_b,
             g_ima70_b,g_ima86_b,g_bmb27,g_ima107_b,l_ima110,l_ima140,l_ima1401,l_imaacti  #No.MOD-5A0193 add ima86 #FUN-6A0036 add(ima1401)
        FROM ima_file
        WHERE ima01 = g_bmb[l_ac].bmb03

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_bmb[l_ac].ima02_b = NULL
                                   LET g_bmb[l_ac].ima021_b = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima70_b IS NULL OR g_ima70_b = ' ' THEN
       LET g_ima70_b = 'N'
    END IF
    LET g_bmb[l_ac].bmb15 = g_ima70_b
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    #CHI-C30130---begin mark
    #IF l_ima140  ='Y' AND l_ima1401 <= g_vdate THEN #FUN-6A0036
    #   LET g_errno = 'aim-809'
    #   RETURN
    #END IF
    #CHI-C30130---end
    IF g_bmb27 IS NULL OR g_bmb27 = ' ' THEN LET g_bmb27 = 'N' END IF
    IF cl_null(l_ima110) THEN LET l_ima110='1' END IF
    IF p_cmd = 'a' THEN
       LET g_bmb[l_ac].bmb19 = l_ima110
       DISPLAY g_bmb[l_ac].bmb19 TO s_bmb[l_sl].bmb19       
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY g_bmb[l_ac].ima02_b TO s_bmb[l_sl].ima02_b
        DISPLAY g_bmb[l_ac].ima021_b TO s_bmb[l_sl].ima021_b
        LET g_bmb[l_ac].ima08_b = g_ima08_b
        DISPLAY g_bmb[l_ac].ima08_b TO s_bmb[l_sl].ima08_b

    END IF
END FUNCTION

FUNCTION  i600_bdate(p_cmd)
  DEFINE   l_bmb04_a,l_bmb04_i LIKE bmb_inplan.bmb04,
           l_bmb05_a,l_bmb05_i LIKE bmb_inplan.bmb05,
           p_cmd     LIKE type_file.chr1,     #No.FUN-680096  VARCHAR(01),
           l_n       LIKE type_file.num10     #No.FUN-680096 INTEGER

    LET g_errno = " "
    IF p_cmd = 'a' THEN
       SELECT COUNT(*) INTO l_n FROM bmb_inplan
                             WHERE bmb01 = g_bma.bma01         #主件
                               AND bmb29 = g_bma.bma06         #FUN-550014 add
                               AND bmb02 = g_bmb[l_ac].bmb02  #項次
                               AND bmb04 = g_bmb[l_ac].bmb04
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    IF p_cmd = 'u' THEN
       SELECT count(*) INTO l_n FROM bmb_inplan
                      WHERE bmb01 = g_bma.bma01         #主件
                        AND bmb29 = g_bma.bma06         #FUN-550014 add
                        AND bmb02 = g_bmb[l_ac].bmb02   #項次
       IF l_n = 1 THEN RETURN END IF
    END IF
    SELECT MAX(bmb04),MAX(bmb05) INTO l_bmb04_a,l_bmb05_a
                       FROM bmb_inplan
                      WHERE bmb01 = g_bma.bma01         #主件
                       AND  bmb29 = g_bma.bma06         #FUN-550014 add
                       AND  bmb02 = g_bmb[l_ac].bmb02   #項次
                       AND  bmb04 < g_bmb[l_ac].bmb04   #生效日
    IF l_bmb04_a IS NOT NULL AND l_bmb05_a IS NOT NULL
    THEN IF (g_bmb[l_ac].bmb04 > l_bmb04_a )
            AND (g_bmb[l_ac].bmb04 < l_bmb05_a)
         THEN LET g_errno = 'mfg2737'
              RETURN
         END IF
    END IF
    IF g_bmb[l_ac].bmb04 <  l_bmb04_a THEN
        LET g_errno = 'mfg2737'
    END IF
    IF l_bmb04_a IS NULL AND l_bmb05_a IS NULL THEN
       RETURN
    END IF

    SELECT MIN(bmb04),MIN(bmb05) INTO l_bmb04_i,l_bmb05_i
                       FROM bmb_inplan
                      WHERE bmb01 = g_bma.bma01         #主件
                       AND  bmb29 = g_bma.bma06         #FUN-550014
                       AND  bmb02 = g_bmb[l_ac].bmb02   #項次
                       AND  bmb04 > g_bmb[l_ac].bmb04   #生效日
    IF l_bmb04_i IS NULL AND l_bmb05_i IS NULL THEN RETURN END IF
    IF l_bmb04_a IS NULL AND l_bmb05_a IS NULL THEN
       IF g_bmb[l_ac].bmb04 < l_bmb04_i THEN
          LET g_errno = 'mfg2737'
       END IF
    END IF
    IF g_bmb[l_ac].bmb04 > l_bmb04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION

FUNCTION  i600_edate(p_cmd)
  DEFINE   l_bmb04_i   LIKE bmb_inplan.bmb04,
           l_bmb04_a   LIKE bmb_inplan.bmb04,
           p_cmd       LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(01),
           l_n         LIKE type_file.num5     #No.FUN-680096 SMALLINT

    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n FROM bmb_inplan
                      WHERE bmb01 = g_bma.bma01         #主件
                        AND bmb29 = g_bma.bma06         #FUN-550014
                        AND bmb02 = g_bmb[l_ac].bmb02   #項次
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(bmb04) INTO l_bmb04_i
                       FROM bmb_inplan
                      WHERE bmb01 = g_bma.bma01         #主件
                        AND bmb29 = g_bma.bma06         #FUN-550014
                       AND  bmb02 = g_bmb[l_ac].bmb02   #項次
                       AND  bmb04 > g_bmb[l_ac].bmb04   #生效日
   SELECT MAX(bmb04) INTO l_bmb04_a
                       FROM bmb_inplan
                      WHERE bmb01 = g_bma.bma01         #主件
                       AND  bmb29 = g_bma.bma06         #FUN-550014
                       AND  bmb02 = g_bmb[l_ac].bmb02   #項次
                       AND  bmb04 > g_bmb[l_ac].bmb04   #生效日
   IF l_bmb04_i IS NULL THEN RETURN END IF
   IF g_bmb[l_ac].bmb05 > l_bmb04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION

FUNCTION  i600_bmb10()
DEFINE l_gfeacti       LIKE gfe_file.gfeacti

LET g_errno = ' '

     SELECT gfeacti INTO l_gfeacti FROM gfe_file
       WHERE gfe01 = g_bmb[l_ac].bmb10

    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

#=====>此FUNCTION 目的在update 上一筆的失效日
FUNCTION i600_update(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(01),
         l_bmb02   LIKE bmb_inplan.bmb02,
         l_bmb03   LIKE bmb_inplan.bmb03,
         l_bmb04   LIKE bmb_inplan.bmb04

    IF p_cmd ='u' THEN
       #--->更新BOM說明檔(bmc_file)的index key
       UPDATE bmc_file SET bmc02  = g_bmb[l_ac].bmb02,
                           bmc021 = g_bmb[l_ac].bmb03,
                           bmc03  = g_bmb[l_ac].bmb04
                       WHERE bmc01 = g_bma.bma01
                         AND bmc06 = g_bma.bma06         #FUN-550014
                         AND bmc02 = g_bmb_t.bmb02
                         AND bmc021= g_bmb_t.bmb03
                         AND bmc03 = g_bmb_t.bmb04
    END IF
    DECLARE i600_update SCROLL CURSOR  FOR
            SELECT bmb02,bmb03,bmb04,bma01,bma06 FROM bmb_inplan
                   WHERE bmb01 = g_bma.bma01
                     AND bmb29 = g_bma.bma06         #FUN-550014
                     AND bmb02 = g_bmb[l_ac].bmb02
                     AND (bmb04 < g_bmb[l_ac].bmb04)
                   ORDER BY bmb04
    OPEN i600_update
    FETCH LAST i600_update INTO l_bmb02,l_bmb03,l_bmb04
    IF SQLCA.sqlcode = 0
       THEN UPDATE bmb_inplan SET bmb05 = g_bmb[l_ac].bmb04,
                                bmbdate=g_today     #FUN-C40007 add
                          WHERE bmb01 = g_bma.bma01
                            AND bmb29 = g_bma.bma06         #FUN-550014
                            AND bmb02 = l_bmb02
                            AND bmb03 = l_bmb03
                            AND bmb04 = l_bmb04
#           MESSAGE 'update 上一筆失效日 ok'
           CALL cl_err('','abm-810','0')   #No.TQC-660046  #CHI-6C0034 取消 remark 此訊不是錯誤訊息，不可用cl_err3
    END IF
    CLOSE i600_update
END FUNCTION


FUNCTION i600_loc(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(01),
         l_qpa     LIKE bmb_inplan.bmb06,
         l_tot     LIKE bmb_inplan.bmb06,
         l_ins_bmt RECORD LIKE bmt_file.*,
         l_n       LIKE type_file.num5,     #No.FUN-680096 SMALLINT,
         l_modify  LIKE type_file.chr1      #No.FUN-680096 VARCHAR(01)


    IF cl_null(g_bmb[l_ac].bmb02) OR
       cl_null(g_bmb[l_ac].bmb03) OR
       cl_null(g_bmb[l_ac].bmb04) THEN
        RETURN
    END IF

    LET l_qpa = g_bmb[l_ac].bmb06 / g_bmb[l_ac].bmb07

    #如果bmb_inplan的unique KEY 有做變動,則影向bmt_file
    IF g_bmb[l_ac].bmb02 != g_bmb_t.bmb02 OR
       g_bmb[l_ac].bmb03 != g_bmb_t.bmb03 OR
       g_bmb[l_ac].bmb04 != g_bmb_t.bmb04 THEN
         CALL i600_bmt_tmp(g_bma.bma01,g_bmb_t.bmb02,g_bmb_t.bmb03,g_bmb_t.bmb04,g_bmb[l_ac].bmb02,g_bmb[l_ac].bmb03,g_bmb[l_ac].bmb04) #將原來的insert_loc資料先備份起來,再置換成新的
    END IF
    LET l_qpa = g_bmb[l_ac].bmb06 / g_bmb[l_ac].bmb07
    SELECT SUM(bmt07)
      INTO l_tot
      FROM bmt_file
     WHERE bmt01 =g_bma.bma01
       AND bmt08 =g_bma.bma06 #FUN-550014 add
       AND bmt02 =g_bmb[l_ac].bmb02
       AND bmt03 =g_bmb[l_ac].bmb03
       AND bmt04 =g_bmb[l_ac].bmb04
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    SELECT COUNT(*) INTO g_cnt FROM bmt_file
     WHERE bmt01 = g_bma.bma01
       AND bmt08 = g_bma.bma06 #FUN-550014 add
       AND bmt02 = g_bmb[l_ac].bmb02
       AND bmt03 = g_bmb[l_ac].bmb03
       AND bmt04 = g_bmb[l_ac].bmb04
    IF p_cmd = 'u' THEN
        IF g_cnt > 0  THEN
            CALL i200(g_bma.bma01,g_bmb[l_ac].bmb02,
                      g_bmb[l_ac].bmb03,g_bmb[l_ac].bmb04,'u',l_qpa,g_bma.bma06) #FUN-550014 add bma06
        ELSE
            CALL i200(g_bma.bma01,g_bmb[l_ac].bmb02,
                      g_bmb[l_ac].bmb03,g_bmb[l_ac].bmb04,'a',l_qpa,g_bma.bma06) #FUN-550014 add bma06
        END IF
    END IF

    CALL i600_up_bmb13(l_ac) RETURNING g_bmb[l_ac].bmb13
    DISPLAY g_bmb[l_ac].bmb13 TO s_bmb[l_ac].bmb13 #FUN-550014 影響后續程式沒有跑ON ROW CHANGE,而沒有UPDATE bmb13
    UPDATE bmb_inplan SET bmb13 = g_bmb[l_ac].bmb13,
                        bmbdate=g_today     #FUN-C40007 add
     WHERE bmb01 = g_bma.bma01
       AND bmb29 = g_bma.bma06
       AND bmb02 = g_bmb_t.bmb02
       AND bmb03 = g_bmb_t.bmb03
       AND bmb04 = g_bmb_t.bmb04
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","bmb_inplan",g_bma.bma01,g_bmb_t.bmb02,SQLCA.sqlcode,"","",1)
    END IF
END FUNCTION

FUNCTION i600_b_askkey()
DEFINE
    l_wc2       LIKE type_file.chr1000   #No.FUN-680096   VARCHAR(200)

    CLEAR ima02_b,ima021_b,ima08_b
    CONSTRUCT l_wc2 ON bmb02,bmb03,bmb04,bmb05,# 螢幕上取單身條件
                       bmb06,bmb07,bmb10,bmb08,bmb13,
                       bmb31,   #no.FUN-690019
                       bmb19,bmb24,
                       bmb36,bmb37, #FUN-D10093 add
                       bmbud01,bmbud02,bmbud03,bmbud04,bmbud05,
                       bmbud06,bmbud07,bmbud08,bmbud09,bmbud10,
                       bmbud11,bmbud12,bmbud13,bmbud14,bmbud15
         FROM s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb04,s_bmb[1].bmb05,
              s_bmb[1].bmb06,s_bmb[1].bmb07,s_bmb[1].bmb10,s_bmb[1].bmb08,
              s_bmb[1].bmb13,
              s_bmb[1].bmb31, #no.FUN-690019
              s_bmb[1].bmb19,s_bmb[1].bmb24,
              s_bmb[1].bmb36,s_bmb[1].bmb37, #FUN-D10093 add
              s_bmb[1].bmbud01,s_bmb[1].bmbud02,s_bmb[1].bmbud03,
              s_bmb[1].bmbud04,s_bmb[1].bmbud05,s_bmb[1].bmbud06,
              s_bmb[1].bmbud07,s_bmb[1].bmbud08,s_bmb[1].bmbud09,
              s_bmb[1].bmbud10,s_bmb[1].bmbud11,s_bmb[1].bmbud12,
              s_bmb[1].bmbud13,s_bmb[1].bmbud14,s_bmb[1].bmbud15


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

                 ON ACTION qbe_select
             CALL cl_qbe_select()
                 ON ACTION qbe_save
     CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i600_b_fill(l_wc2)
END FUNCTION

FUNCTION i600_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2      LIKE type_file.chr1000    #No.FUN-680096   VARCHAR(300)

    LET g_sql =
        "SELECT bmb02,bmb30,bmb03,ima02,ima021,ima08,bmb09,bmb16,bmb14,bmb04,bmb05,bmb06,bmb07,",#FUN-550014 add bmb30 #FUN-610022調換bmb30的順序
        "       bmb10,bmb08,bmb081,bmb082,bmb19,bmb24,bmb13,bmb15,bmb31,  ",  #NO.FUN-690019 add bmb31 #No.FUN-A50089 add bmb081,bmb082
        "bmb36  ,bmb37  ,", #FUN-D10093 add bmb36,bmb37
        "bmbud01,bmbud02,bmbud03,bmbud04,bmbud05,",
        "bmbud06,bmbud07,bmbud08,bmbud09,bmbud10,",
        "bmbud11,bmbud12,bmbud13,bmbud14,bmbud15 ",
        " FROM bmb_inplan LEFT OUTER JOIN ima_file ON bmb03 =ima01  ",  #MOD-D80128 公式计算料件不用关联ima
        " WHERE bmb01 ='",g_bma.bma01,"' ",
        "   AND bmb29 ='",g_bma.bma06,"' ",  #FUN-550014 add
      #  "   AND bmb_inplan.bmb03 = ima_file.ima01 ",  #MOD-D80128 公式计算料件不用关联ima
        "   AND bmb06 != 0 ",          #No.FUN-610022組成用量為零就不顯示了        
        "   AND ",p_wc2 CLIPPED
    CASE g_sma.sma65
      WHEN '1'  LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,3"
      WHEN '2'  LET g_sql = g_sql CLIPPED, " ORDER BY 2,1,3"
      WHEN '3'  LET g_sql = g_sql CLIPPED, " ORDER BY 6,1,3"
      OTHERWISE LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,3"
    END CASE
     
    PREPARE i600_pb FROM g_sql
    DECLARE bmb_curs                       #SCROLL CURSOR
        CURSOR FOR i600_pb

    CALL g_bmb.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH bmb_curs INTO g_bmb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF

      IF g_bmb[g_cnt].bmb30 = '3' THEN
         LET g_bmb[g_cnt].ima02_b  = g_tipstr
         LET g_bmb[g_cnt].ima021_b = g_tipstr
      END IF

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

    END FOREACH
    CALL g_bmb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
#FUN-CB0078 -----begin-----
#   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#      BEFORE DISPLAY
#         EXIT DISPLAY
#   END DISPLAY
#FUN-CB0078 -----end------
    LET g_cnt = 0

END FUNCTION

FUNCTION i600_bp(p_ud)
   DEFINE   p_ud     LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
   DEFINE   l_count  LIKE type_file.num5    #No.FUN-680096 SMALLINT  #No.FUN-610022
   DEFINE   l_t      LIKE type_file.num10   #No.FUN-680096 INTEGER  #FUN-610095
   DEFINE   l_cnt    LIKE type_file.num5    #FUN-C30036

    ###FUN-9A50010 START ###
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   ###FUN-9A50010 END ###
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)


   SELECT count(*)
      INTO l_count
      FROM bmb_inplan
    WHERE bmb01 = g_bma.bma01
       AND bmb30='3'

    IF l_count = 0 THEN
       CALL cl_set_act_visible("preview_bom", FALSE)
       CALL cl_set_act_visible("edit_formula",FALSE)  #No.FUN-640139 Add
    ELSE
       CALL cl_set_act_visible("preview_bom", TRUE)
       CALL cl_set_act_visible("edit_formula",FALSE)  #No.FUN-640139 Add
    END IF

    IF NOT s_industry('slk') THEN
        CALL cl_set_act_visible("fix",FALSE)
    END IF

      ###FUN-9A50010 START ###

      #讓各個交談指令可以互動
      DIALOG ATTRIBUTES(UNBUFFERED)

#     MOD-A50010  mark---start---
#         DISPLAY ARRAY g_tree TO tree.*
#             BEFORE DISPLAY
#                重算g_curs_index，按上下筆按鈕才會正確
#                因為double click tree node後,focus tree的節點會改變
#                IF g_tree_focus_idx <= 0 THEN
#                   LET g_tree_focus_idx = ARR_CURR()
#                END IF


             #  以最上層的id當作單頭的g_curs_index
#               IF g_tree_focus_idx > 0  THEN
#               CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
#               LET g_curs_index = l_curs_index
#               CALL cl_navigator_setting( g_curs_index, g_row_count )
#               END IF

#              BEFORE ROW
#               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row


#            double click tree node
#            ON ACTION accept
#               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               #有子節點就focus在此，沒有子節點就focus在它的父節點
#               IF g_tree[l_tree_arr_curr].has_children THEN
#                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
#               ELSE
#                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
#                  IF l_i > 1 THEN
#                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
#                  END IF
#                  CALL i600_tree_idxbypath()   #依tree path指定focus節點
#               END IF

#               LET g_tree_b = "Y"             #tree是否進入單身 Y/N
#                CALL i600_show_pic(l_tree_arr_curr)
#         END DISPLAY
#     MOD-A50010 mark---end---

#FUN-B90117 --add BEGIN--
        DISPLAY ARRAY g_tree1 TO tree1.*
          BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )     #FUN-CB0078 lixh1
            IF g_tree_focus_idx <= 0 THEN
               LET g_tree_focus_idx = ARR_CURR()
            END IF
            #FUN-C30036---begin
            # #  以最上層的id當作單頭的g_curs_index
            #IF g_tree_focus_idx > 0  THEN
            #   CALL cl_str_sepsub(g_tree1[g_tree_focus_idx].id1 CLIPPED,".",1,1)
            #        RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
            #   LET g_curs_index = l_curs_index
            #   CALL cl_navigator_setting(g_curs_index, g_row_count )
            #END IF
            ##FUN-C30036---end
            BEFORE ROW
               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row
               LET g_tree_arr_curr = ARR_CURR()
               LET g_tree_focus_path = g_tree1[l_tree_arr_curr].path1
               #有子節點就focus在此，沒有子節點就focus在它的父節點
               IF g_tree1[l_tree_arr_curr].has_children1 THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               ELSE
                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
                  IF l_i > 1 THEN
                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
                  END IF
                  CALL i600_tree_idxbypath()   #依tree path指定focus節點
               END IF

               IF g_tree1[l_tree_arr_curr].has_children1 THEN                     #FUN-C20105   #FUN-CB0078 unmark 
          #    IF g_tree1[l_tree_arr_curr].has_children1 AND g_lock = 'Y' THEN    #FUN-C20105   #FUN-CB0078 mark 
          #       LET g_tree_item = g_tree1[1].treekey4                 #FUN-CB0078
                  LET g_tree_item = g_tree1[l_tree_arr_curr].treekey4   #FUN-CB0078
                # LET g_action_choice="tree"          #FUN-CB0078   mark
                # EXIT DIALOG                         #FUN-CB0078   mark
                  CALL i600_q(0)    #FUN-CB0078 add
                #FUN-CB0078 -------Begin------
                  DISPLAY ARRAY g_tree1 TO tree1.*
                     BEFORE DISPLAY
                        EXIT DISPLAY
                  END DISPLAY
                  LET g_tree_item = ''
                #FUN-CB0078 -------End--------
               END IF

               IF NOT g_tree1[l_tree_arr_curr].has_children1 THEN  #尾阶料号时刷新单头单身为空      #FUN-C20105 #FUN-CB0078 unmark
          #    IF NOT g_tree1[l_tree_arr_curr].has_children1 AND g_lock = 'Y' THEN                  #FUN-C20105 #FUN-CB0078 mark
          #       LET g_tree_item = g_tree1[1].treekey4                 #FUN-CB0078
                  LET g_tree_item = g_tree1[l_tree_arr_curr].treekey4   #FUN-CB0078 
                  LET g_show_flag = 'Y'                             #FUN-CB0078
                  INITIALIZE g_bma.* TO NULL
                  CALL g_bmb.clear()
                  CALL i600_show()
                  LET g_tree_item = ''       #FUN-CB0078
                  LET g_show_flag = 'N'      #FUN-CB0078
                  DISPLAY ARRAY g_bmb TO s_bmb.*
                     BEFORE DISPLAY
                       EXIT DISPLAY
                  END DISPLAY
               END IF   

               #LET g_tree_b = "Y"             #tree是否進入單身 Y/N
                CALL i600_show_pic(l_tree_arr_curr)

#FUN-C20105 --begin--
##            ON ACTION accept
##               IF NOT g_tree1[l_tree_arr_curr].has_children1 THEN
##                 LET g_action_choice="insert"
##                 EXIT DIALOG
##               END IF

            ON ACTION accept             #双击时如果是锁定状态并且是尾阶料号，则让用户输入状态
                #FUN-C30036---begin
                LET g_tree_item = g_tree1[l_tree_arr_curr].treekey4
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM bma_inplan
                 WHERE bma01 = g_tree_item
                IF l_cnt > 0 THEN  
                   CALL i600_q(0)
            #FUN-CB0078 -----Begin--------
            #   ELSE
            #   #FUN-C30036---end
            #      IF g_lock='Y' AND NOT g_tree1[l_tree_arr_curr].has_children1 THEN
            #         LET g_action_choice="insert"
            #         #EXIT DIALOG  #FUN-C30036 
            #      END IF
            #   #FUN-C30036---begin
            #FUN-CB0078 -----End----------
            #FUN-CB0078 -----Begin--------
                   DISPLAY ARRAY g_tree1 TO tree1.*
                      BEFORE DISPLAY
                         EXIT DISPLAY
                   END DISPLAY
                ELSE
                   INITIALIZE g_bma.* TO NULL
                   CALL g_bmb.clear()
                   CALL i600_show()
                END IF 
            #FUN-CB0078 -----End----------
                LET g_tree_item = ''  
              # EXIT DIALOG     #FUN-CB0078 mark 
                #FUN-C30036---end
#FUN-C20105 --end--

         END DISPLAY
#FUN-B90117 --add END--

         DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b)
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               IF g_sma.sma901 != 'Y' THEN
                   CALL cl_set_act_visible("aps_related_data",FALSE)
               END IF
               IF g_sma.sma104 != 'Y' THEN
                   CALL cl_set_act_visible("contract_product",FALSE)
               END IF
               IF s_industry("slk") THEN
                  CALL cl_getmsg("abm-603",2) RETURNING g_msg
                  CALL i600_set_act_title("insert_loc",g_msg)
                  CALL i600_set_act_title("create_loc_data",g_msg)
               END IF
               CALL cl_show_fld_cont()   #FUN-CB0078 lixh1 

            BEFORE ROW
               LET l_ac = ARR_CURR()
               CALL cl_show_fld_cont()

         #  AFTER DISPLAY
         #     CONTINUE DIALOG   #因為外層是DIALOG

            --&include "qry_string.4gl"
            ON ACTION accept
               LET g_action_choice="detail"
               LET l_ac = ARR_CURR()
               EXIT DIALOG


            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG

         END DISPLAY   

          DISPLAY ARRAY g_bma_l TO s_bma_l.* ATTRIBUTE(COUNT=g_rec_b1)
             BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW
               LET l_ac = ARR_CURR()
               CALL cl_show_fld_cont()
               LET g_tree_sel='2'              #FUN-B90117
#              CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)   #FUN-B90117
               CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma_l[l_ac].bma01_l) #FUN-B90117
               CONTINUE DIALOG

            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG


         END DISPLAY


         BEFORE DIALOG
            #No.FUN-A30120 add by tommas   判斷是否要focus到tree的正確row
          # IF g_tree_focus_idx > 0 THEN
          #    CALL Dialog.nextField("tree.name")                   #No.FUN-A30120 add by tommas   利用NEXT FIELD達到focus另一個table
          #    CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)   #No.FUN-A30120 add by tommas   指定tree要focus的row
          # END IF   
            LET l_tree_arr_curr = 1
            LET l_ac = 1

         ON ACTION mat_qry
            LET l_t = ARR_CURR()
            IF l_t > 0 THEN  #No.MOD-8A0125 add
               CALL i600c(g_bmb[l_t].bmb03) #FUN-950065    #No:TQC-990023 取消mark
            END IF           #No.MOD-8A0125 add
            EXIT DIALOG
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG

         ON ACTION first
            CALL i600_fetch('F',0)
            CALL i600_tree_idxbykey()
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
            END IF
         EXIT DIALOG              #TQC-A60039 add

         ON ACTION previous
            CALL i600_fetch('P',0)
            CALL i600_tree_idxbykey()
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
           EXIT DIALOG            #TQC-A60039 add

         ON ACTION jump
            CALL i600_fetch('/',0)
            CALL i600_tree_idxbykey()
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)
            END IF
           EXIT DIALOG             #TQC-A60039 add

         ON ACTION next
            CALL i600_fetch('N',0)
            CALL i600_tree_idxbykey()
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
           EXIT DIALOG             #TQC-A60039 add

         ON ACTION last
            CALL i600_fetch('L',0)
            CALL i600_tree_idxbykey()
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
         EXIT DIALOG                #TQC-A60039 add

         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG

         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG

         ON ACTION invalid
            LET g_action_choice="invalid"
            CALL i600_pic()
            EXIT DIALOG

          #ON ACTION 審核
         ON ACTION confirm
            LET g_action_choice = "confirm"
            EXIT DIALOG
         #ON ACTION 取消審核
         ON ACTION unconfirm
            LET g_action_choice = "unconfirm"
            EXIT DIALOG
         #@ON ACTION 發放
            ON ACTION bom_release         #TQC-640195
            LET g_action_choice="bom_release"
            EXIT DIALOG
         #ON ACTION 取消發放
         ON ACTION unrelease
            LET g_action_choice = "unrelease"
            EXIT DIALOG
         #ON ACTION 固定屬性
         ON ACTION fix
            LET g_action_choice = "fix"
            EXIT DIALOG

        #FUN-AC0076 add --------------begin---------------
        #ON ACTION 分量耗損
        ON ACTION haosun
           LET g_action_choice="haosun"
           EXIT DIALOG
        #FUN-AC0076 add ---------------end----------------

         #@ON ACTION 插件位置
         ON ACTION insert_loc
            LET g_action_choice="insert_loc"
           EXIT DIALOG
         #@ON ACTION 廠牌
         ON ACTION brand
            LET g_action_choice="brand"
            EXIT DIALOG
         #@ON ACTION 取替代
         ON ACTION rep_sub
            LET g_action_choice="rep_sub"
            EXIT DIALOG
        #@ON ACTION 明細單身
         ON ACTION contents
            LET g_action_choice="contents"
            EXIT DIALOG
        #@ON ACTION 偵測
         ON ACTION debug
            LET g_action_choice="debug"
            EXIT DIALOG
         #FUN-C30028---begin
         ON ACTION hide_tree
            LET g_action_choice="hide_tree"
            EXIT DIALOG
         #FUN-C30028---end
        #@ON ACTION 產生族群料件連結
         ON ACTION gen_group_link
            LET g_action_choice="gen_group_link"
           EXIT DIALOG

        ON ACTION carry
           LET g_action_choice = "carry"
           EXIT DIALOG

        ON ACTION download
           LET g_action_choice = "download"
          EXIT DIALOG

        ON ACTION qry_carry_history
           LET g_action_choice = "qry_carry_history"
           EXIT DIALOG

        ON ACTION list_pg
           LET g_bp_flag = 'list'
          EXIT DIALOG


      #@ON ACTION APS相關資料
        ON ACTION aps_related_data
           LET g_action_choice="aps_related_data"
          EXIT DIALOG
      #@ON ACTION 聯產品
        ON ACTION contract_product
           LET g_action_choice="contract_product"
           EXIT DIALOG
      #@ON ACTION BOM
        ON ACTION bom_description
           LET g_action_choice="bom_description"
         EXIT DIALOG


        ON ACTION reproduce
           LET g_action_choice="reproduce"
           EXIT DIALOG

       #ON ACTION output                          #TQC-AC0159
       #    LET g_action_choice="output"          #TQC-AC0159
       #    EXIT DIALOG                           #TQC-AC0159

        #str----add by guanyao160706
         ON ACTION e_work
            LET g_action_choice="e_work"
            EXIT DIALOG
        #end----add by guanyao160706
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            EXIT DIALOG

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION close                #視窗右上角的"x"
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
#MOD-A50010 mark---start---
         #ON ACTION accept
         #   LET g_action_choice="detail"
         #   LET l_ac = ARR_CURR()
         #   EXIT DIALOG

         #ON ACTION cancel
         #   LET INT_FLAG=FALSE
         #   LET g_action_choice="exit"
         #   EXIT DIALOG
#MOD-A50010 mark---end---

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()
            EXIT DIALOG

         #相關文件
         ON ACTION related_document
            LET g_action_choice="related_document"
            EXIT DIALOG

         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
        ON ACTION preview_bom
           LET g_action_choice = 'preview_bom'
           EXIT DIALOG

        ON ACTION edit_formula
           LET g_action_choice = 'edit_formula'
           EXIT DIALOG

         ON ACTION controls
            CALL cl_set_head_visible("","AUTO")
            EXIT DIALOG
         #str----add by guanyao160719
         ON ACTION aec
            LET g_action_choice = 'aec'
            EXIT DIALOG
         #end----add by guanyao160719
          ON ACTION sfa_pro
            LET g_action_choice = 'sfa_pro'
            EXIT DIALOG            
         #No:FUN-B70096 --START--
         ON ACTION OUTPUT
            LET g_action_choice = 'output'
            EXIT DIALOG
         #No:FUN-B70096 --END--

#FUN-CB0078 -----Begin-----
##FUN-C20105 --begin--
#        ON ACTION lock
#           LET g_action_choice = 'lock'
#           EXIT DIALOG           
##FUN-C20105 --end--
#FUN-CB0078 -----End-------
#MOD-C90170 add &include "qry_string.4gl"
&include "qry_string.4gl" 
         
      END DIALOG
      CALL cl_set_act_visible("accept,cancel", TRUE)
      ###FUN-9A50010 END ###

END FUNCTION

FUNCTION i600_bp1(p_ud)
   DEFINE   p_ud     LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
   DEFINE   l_count  LIKE type_file.num5    #No.FUN-680096 SMALLINT  #No.FUN-610022
   DEFINE   l_t      LIKE type_file.num10   #No.FUN-680096 INTEGER  #FUN-610095

    ###FUN-9A50010 START ###
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   ###FUN-9A50010 END ###
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   #判斷是否需要隱藏Ring Menu中的“BOM預覽”和“編輯自定義公式”兩個按鈕
   #被迫做這一切，只因為上面加的那個cl_load_act_list
   SELECT count(*)
     INTO l_count
     FROM bmb_inplan
    WHERE bmb01 = g_bma.bma01
      AND bmb30='3'

   IF l_count = 0 THEN
      CALL cl_set_act_visible("preview_bom", FALSE)
      CALL cl_set_act_visible("edit_formula",FALSE)  #No.FUN-640139 Add
   ELSE
      CALL cl_set_act_visible("preview_bom", TRUE)
      CALL cl_set_act_visible("edit_formula",FALSE)  #No.FUN-640139 Add
   END IF
    IF NOT s_industry('slk') THEN
       CALL cl_set_act_visible("fix",FALSE)
    END IF
    IF s_industry('slk') THEN
       CALL cl_getmsg("abm-603",2) RETURNING g_msg
       CALL i600_set_act_title("insert_loc",g_msg)
       CALL i600_set_act_title("create_loc_data",g_msg)
    END IF

    CALL cl_set_act_visible("accept,cancel", FALSE)

    ###FUN-9A50010 START ###

      #讓各個交談指令可以互動
      DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE DISPLAY
               #重算g_curs_index，按上下筆按鈕才會正確
               #因為double click tree node後,focus tree的節點會改變
               CALL cl_navigator_setting( g_curs_index, g_row_count )  #FUN-CB0078 lixh1 
               IF g_tree_focus_idx <= 0 THEN
                  LET g_tree_focus_idx = ARR_CURR()
               END IF


             #  以最上層的id當作單頭的g_curs_index
               IF g_tree_focus_idx > 0  THEN
               CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
               LET g_curs_index = l_curs_index
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               END IF

            BEFORE ROW
               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row
#FUN-A50010  add by dxfwo
               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               #有子節點就focus在此，沒有子節點就focus在它的父節點
               IF g_tree[l_tree_arr_curr].has_children THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               ELSE
                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
                  IF l_i > 1 THEN
                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
                  END IF
                  CALL i600_tree_idxbypath()   #依tree path指定focus節點
               END IF

               LET g_tree_b = "Y"             #tree是否進入單身 Y/N
                CALL i600_show_pic(l_tree_arr_curr)
#FUN-A50010  add by dxfwo


            #double click tree node
            
#FUN-A50010  mark by dxfwo
#              ON ACTION accept
#              LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
#              #有子節點就focus在此，沒有子節點就focus在它的父節點
#              IF g_tree[l_tree_arr_curr].has_children THEN
#                 LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
#              ELSE
#                 CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
#                 IF l_i > 1 THEN
#                    CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
#                 END IF
#                 CALL i600_tree_idxbypath()   #依tree path指定focus節點
#              END IF
#
#              LET g_tree_b = "Y"             #tree是否進入單身 Y/N
#               CALL i600_show_pic(l_tree_arr_curr)
         END DISPLAY


    DISPLAY ARRAY g_bma_l TO s_bma_l.* ATTRIBUTE(COUNT=g_rec_b1)
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )
                IF g_sma.sma901 != 'Y' THEN
                   CALL cl_set_act_visible("aps_related_data",FALSE)
                END IF
                IF g_sma.sma104 != 'Y' THEN
                   CALL cl_set_act_visible("contract_product",FALSE)
                END IF
            BEFORE ROW
               LET l_ac = ARR_CURR()
               CALL cl_show_fld_cont()
               LET g_tree_sel='2'             #FUN-B90117
#              CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)   #FUN-B90117
               CALL i600sub_refresh(g_bma_l[l_ac].bma01_l,g_bma_l[l_ac].bma06_l) RETURNING g_bma.*  #MOD-D80170
               CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma_l[l_ac].bma01_l) #FUN-B90117
               CONTINUE DIALOG

            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG

    END DISPLAY

#MOD-A50010 mark---start---
      --BEFORE DIALOG
        #No.FUN-A30120 add by tommas   判斷是否要focus到tree的正確row
          --IF g_tree_focus_idx > 0 THEN
             --CALL Dialog.nextField("tree.name")                   #No.FUN-A30120 add by tommas   利用NEXT FIELD達到focus另一個table
             --CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)   #No.FUN-A30120 add by tommas   指定tree要focus的row
          --END IF
#MOD-A50010 mark---end---

      ON ACTION mat_qry
         LET l_t = ARR_CURR()
         CALL i600c(g_bmb[l_t].bmb03) #FUN-950065               #No:TQC-990023 取消mark
         EXIT DIALOG


      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG

      ON ACTION first
         CALL i600_fetch('F',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         EXIT DIALOG

      ON ACTION previous
         CALL i600_fetch('P',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DIALOG

      ON ACTION jump
         CALL i600_fetch('/',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DIALOG

      ON ACTION next
         CALL i600_fetch('N',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DIALOG

      ON ACTION last
         CALL i600_fetch('L',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DIALOG

      ON ACTION invalid
         LET g_action_choice="invalid"
         CALL cl_set_field_pic(g_confirm,"","","","",g_bma.bmaacti)    #No.FUN-810116
         EXIT DIALOG

      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DIALOG

      ON ACTION unconfirm
         LET g_action_choice = "unconfirm"
         EXIT DIALOG

      ON ACTION unrelease
         LET g_action_choice = "unrelease"
         EXIT DIALOG

      ON ACTION fix
         LET g_action_choice = "fix"
         EXIT DIALOG

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG

    #str----add by guanyao160706
      ON ACTION e_work
         LET g_action_choice="e_work"
         EXIT DIALOG
    #end----add by guanyao160706
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
       LET g_tree_sel='2'         #FUN-B90117
         CALL i600_tree_fill(g_wc_o,NULL,0,NULL,
#                            g_bma_l[l_ac].bma01_l,NULL)          #FUN-B90117
                             g_bma_l[l_ac].bma01_l,NULL,NULL)     #FUN-B90117
         CALL i600_pic() #MOD-840435
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION bom_release         #TQC-640195
         LET g_action_choice="bom_release"
         EXIT DIALOG

      #FUN-AC0076 add --------------begin---------------
      #ON ACTION 分量耗損
      ON ACTION haosun
         LET g_action_choice="haosun"
         EXIT DIALOG
      #FUN-AC0076 add ---------------end----------------

      ON ACTION insert_loc
         LET g_action_choice="insert_loc"
         EXIT DIALOG

      ON ACTION brand
         LET g_action_choice="brand"
         EXIT DIALOG

      ON ACTION rep_sub
         LET g_action_choice="rep_sub"
         EXIT DIALOG

      ON ACTION contents
         LET g_action_choice="contents"
         EXIT DIALOG

      ON ACTION debug
         LET g_action_choice="debug"
         EXIT DIALOG
      #FUN-C30028---begin
      ON ACTION hide_tree
         LET g_action_choice="hide_tree"
         EXIT DIALOG
      #FUN-C30028---end
      ON ACTION gen_group_link
         LET g_action_choice="gen_group_link"
         EXIT DIALOG

      ON ACTION carry
         LET g_action_choice = "carry"
         EXIT DIALOG

      ON ACTION download
         LET g_action_choice = "download"
         EXIT DIALOG

      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"
         EXIT DIALOG


      ON ACTION info_pg
         LET g_bp_flag = NULL
         EXIT DIALOG

      ON ACTION main
         LET g_bp_flag = 'main'
         --LET l_ac1 = ARR_CURR()
         --LET g_jump = l_ac1
         --LET mi_no_ask = TRUE
         --IF g_rec_b1 >0 THEN
         --CALL i600_fetch('/',0)
         --END IF
         CALL i600_bp("G")
         --CALL cl_set_comp_visible("page5", FALSE)
         --CALL cl_set_comp_visible("info", FALSE)
         --CALL ui.interface.refresh()
         --CALL cl_set_comp_visible("page5", TRUE)
         --CALL cl_set_comp_visible("info", TRUE)
         EXIT DIALOG

      ON ACTION accept
         --LET l_ac = ARR_CURR()
         --CALL cl_show_fld_cont()
         --CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)
         --CONTINUE DIALOG
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i600_fetch('/',0)
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("page5", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("page5", TRUE)
         #CONTINUE DIALOG     #NO.FUN-840018 ADD    #MOD-B50076
         EXIT DIALOG                                #MOD-B50076

      ON ACTION aps_related_data
         LET g_action_choice="aps_related_data"
         EXIT DIALOG

      ON ACTION contract_product
         LET g_action_choice="contract_product"
         EXIT DIALOG

      ON ACTION bom_description
         LET g_action_choice="bom_description"
         EXIT DIALOG

      ON ACTION cancel
             LET INT_FLAG=FALSE   #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG

      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION preview_bom
         LET g_action_choice = 'preview_bom'
         EXIT DIALOG

      ON ACTION edit_formula
         LET g_action_choice = 'edit_formula'
         EXIT DIALOG

      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033

      #str----add by guanyao160719
         ON ACTION aec
            LET g_action_choice = 'aec'
            EXIT DIALOG
      #end----add by guanyao160719

      #No:FUN-B70096 --START--
      ON ACTION OUTPUT
         LET g_action_choice = 'output'
         EXIT DIALOG
      #No:FUN-B70096 --END--

      &include "qry_string.4gl"

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION i600c(p_bmb03)                                     #No:TQC-990023 add
   DEFINE  p_bmb03   LIKE bmb_inplan.bmb03
   IF p_bmb03 IS NULL THEN RETURN END IF
  #LET g_cmd = "abmq500 ","'",p_bmb03 CLIPPED,"'"  # 物料編號 #FUN-950065                   #No:TQC-990023 取消mark  #MOD-A30161 mark
   LET g_cmd = "abmq500 ","'",p_bmb03 CLIPPED,"' ","'",g_vdate,"'"  # 物料編號 #FUN-950065   #No:MOD-A30161 modify
   CALL cl_cmdrun(g_cmd)

END FUNCTION

FUNCTION i600_copy()
   DEFINE new_bma06,old_bma06 LIKE bma_inplan.bma06 #FUN-550014 add
   DEFINE new_no,old_no LIKE bma_inplan.bma01,
         l_bmb  RECORD LIKE bmb_inplan.*,
         l_bmd  RECORD LIKE bmd_file.*,         #No:MOD-980229 add
         l_bmv  RECORD LIKE bmv_file.*,         #No.FUN-840178
         ef_date       LIKE type_file.dat,      #No.FUN-680096 DATE,
         ans_1         LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1),
         ans_2         LIKE type_file.dat,      #No.FUN-680096 DATE,
         ans_3,ans_4   LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1),
         ans_31,ans_5  LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1),
         l_dir         LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1),
         l_sql         STRING                   #LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(400)  #MOD-6A0145
   DEFINE l_n          LIKE type_file.num5      #No.FUN-920157
   DEFINE l_icm  RECORD LIKE icm_file.*         #FUN-980033
   DEFINE l_tree_arr_curr    LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF
#MOD-B90133 -- begin --
   IF g_bma.bmaacti = 'N' THEN
      CALL cl_err('','atm-306',0)
      RETURN
   END IF
#MOD-B90133 -- end --

   LET p_row = 10 LET p_col = 24
   OPEN WINDOW i600_c_w AT p_row,p_col WITH FORM "abm/42f/abmi600_c"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_locale("abmi600_c")

    CALL cl_set_comp_visible("old_bma06,new_bma06",g_sma.sma118='Y')


   LET old_no   = g_bma.bma01 LET new_no = NULL
   LET old_bma06= g_bma.bma06
   IF cl_null(old_bma06) THEN LET old_bma06 = ' ' END IF   #MOD-920012
   LET new_bma06 = ' ' #FUN-550014
   LET ans_1  = '1'         LET ans_2  = TODAY
   LET ans_3  = 'Y'         LET ans_4  = 'Y'
   LET ans_31 = 'Y'         LET ef_date= NULL
   LET ans_5  = 'Y'
   CALL cl_set_head_visible("","YES")             #No.FUN-6B0033
   INPUT BY NAME old_no,old_bma06,new_no,new_bma06,ans_2,ans_1,ef_date,ans_3,ans_31,ans_4,ans_5 #FUN-550014 add bma06
               WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i600_set_entry()
         CALL i600_set_no_entry()
         CALL i600_set_required(ans_1)
         CALL i600_set_no_required(ans_1)
         LET g_before_input_done = TRUE

      AFTER FIELD old_no
        IF g_sma.sma118 != 'Y' THEN #FUN-550014 add if 判斷
            IF NOT cl_null(new_no) THEN
               CALL s_field_chk(new_no,'2',g_plant,'bma01') RETURNING g_flag2
               IF g_flag2 = '0' THEN
                  CALL cl_err(new_no,'aoo-043',1)
                  NEXT FIELD new_no
               END IF
            END IF
            IF NOT cl_null(old_no) THEN
                SELECT count(*) INTO g_cnt FROM bma_inplan WHERE bma01 = old_no
                                                           AND bma06 = old_bma06 #FUN-550014 add
                IF g_cnt=0 THEN CALL cl_err('bma_inplan',100,0) NEXT FIELD old_no END IF
            END IF
        END IF
      AFTER FIELD old_bma06
        IF cl_null(old_bma06) THEN
            LET old_bma06 = ' '
        END IF
        IF NOT cl_null(old_no) THEN
            SELECT count(*) INTO g_cnt FROM bma_inplan WHERE bma01 = old_no
                                                       AND bma06 = old_bma06 #FUN-550014 add
            IF g_cnt=0 THEN CALL cl_err('bma_inplan',100,0) NEXT FIELD old_no END IF
        END IF
      AFTER FIELD new_no
        IF g_sma.sma118 != 'Y' THEN #FUN-550014 add if 判斷
            IF NOT cl_null(new_no) THEN
                SELECT count(*) INTO g_cnt FROM bma_inplan WHERE bma01 = new_no
                                                           AND bma06 = new_bma06 #FUN-550014 add
                IF g_cnt>0 THEN CALL cl_err('bma_inplan',-239,0) NEXT FIELD new_no END IF
                SELECT count(*) INTO g_cnt FROM ima_file WHERE ima01 = new_no
                IF g_cnt=0 THEN CALL cl_err('ima_file',100,0) NEXT FIELD new_no END IF

                LET g_errno = ''
                CALL i600_new_no(new_no)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(new_no,g_errno,0)
                   NEXT FIELD new_no
                END IF

            END IF
        END IF
      AFTER FIELD new_bma06
        IF cl_null(new_bma06) THEN
            LET new_bma06 = ' '
        END IF
        IF NOT cl_null(new_no) THEN
            SELECT count(*) INTO g_cnt FROM bma_inplan WHERE bma01 = new_no
                                                       AND bma06 = new_bma06 #FUN-550014 add
            IF g_cnt>0 THEN CALL cl_err('bma_inplan',-239,0) NEXT FIELD new_no END IF
            SELECT count(*) INTO g_cnt FROM ima_file WHERE ima01 = new_no
            IF g_cnt=0 THEN CALL cl_err('ima_file',100,0) NEXT FIELD new_no END IF
        END IF
      ON CHANGE ans_1
        IF ans_1 != '3' THEN
            CALL i600_set_no_entry()
            CALL i600_set_no_required(ans_1)
            LET ef_date = NULL
        ELSE
            CALL i600_set_entry()
            CALL i600_set_required(ans_1)
        END IF
      AFTER FIELD ans_1
        IF NOT cl_null(ans_1) THEN
            IF ans_1 NOT MATCHES "[123]" THEN NEXT FIELD ans_1 END IF
        END IF

      AFTER FIELD ans_3
        IF NOT cl_null(ans_3) THEN
            IF ans_3 NOT MATCHES "[YN]" THEN NEXT FIELD ans_3 END IF
        END IF

      AFTER FIELD ans_31
        IF NOT cl_null(ans_31) THEN
            IF ans_31 NOT MATCHES "[YN]" THEN NEXT FIELD ans_31 END IF
        END IF

      AFTER FIELD ans_4
        IF NOT cl_null(ans_4) THEN
            IF ans_4 NOT MATCHES "[YN]" THEN NEXT FIELD ans_4 END IF
        END IF

      AFTER FIELD ans_5
        IF NOT cl_null(ans_5) THEN
            IF ans_5 NOT MATCHES "[YN]" THEN NEXT FIELD ans_5 END IF
        END IF
      AFTER FIELD ef_date
        IF cl_null(ef_date) THEN
            NEXT FIELD ef_date
        END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(new_no)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form = "q_ima"
             #  CALL cl_create_qry() RETURNING new_no
               CALL q_sel_ima(FALSE, "q_ima", "", "", "", "", "", "" ,"",'' )  RETURNING new_no
#FUN-AA0059 --End--
               NEXT FIELD new_no
            OTHERWISE EXIT CASE
         END CASE

      ON ACTION controlg       #TQC-860021
         CALL cl_cmdask()      #TQC-860021

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021

      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021
   END INPUT
   CLOSE WINDOW i600_c_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   MESSAGE ' COPY.... '
IF cl_sure(0,0) THEN

 #MOD-A30131 add---start---
 #將Temptable資料的準備移到BEGIN WORK前,
 #以免DROP TABLE與INTO TEMP的語法破壞TRANSACTION的完整性,造成ROLLBACK失敗

   #說明資料是否復制ans_3
   IF ans_3 = 'Y' THEN
      DROP TABLE w
      LET l_sql = " SELECT bmc_file.* FROM bmc_file,bmb_inplan ",
                  " WHERE bmb01 = bmc01 ",
                  " AND   bmb29 = bmc06 ",  #FUN-550014 add
                  " AND bmb02 = bmc02   ",
                  " AND bmb03 = bmc021  ",
                  " AND bmb04 = bmc03   ",
                  " AND bmb01=  '",old_no,"'",
                  " AND bmb29=  '",old_bma06,"'" #FUN-550014 add
      IF ans_2 IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED,
                  " AND (bmb04 <='",ans_2,"' OR bmb04 IS NULL)",
                  " AND (bmb05 > '",ans_2,"' OR bmb05 IS NULL)"
      END IF

      LET l_sql = l_sql clipped," INTO TEMP w "
      PREPARE i600_pbmc FROM l_sql
      EXECUTE i600_pbmc
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","bmc_file,bmb_inplan",old_no,old_bma06,SQLCA.sqlcode,"","i600_pbmc",1)  #No.TQC-660046
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
   END IF

   #插件位置是否復制ans_31
   IF ans_31 = 'Y' THEN
      DROP TABLE w2
      LET l_sql = " SELECT bmt_file.* FROM bmt_file,bmb_inplan ",
                  " WHERE bmb01 = bmt01 ",    #主件
                  " AND bmb29 = bmt08   ",    #FUN-550014 add
                  " AND bmb02 = bmt02   ",    #項次
                  " AND bmb03 = bmt03   ",    #元件
                  " AND bmb04 = bmt04   ",    #生效日
                  " AND bmb01=  '",old_no,"'",
                  " AND bmb29=  '",old_bma06,"'" #FUN-550014 add
      IF ans_2 IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED,
                  " AND (bmb04 <='",ans_2,"' OR bmb04 IS NULL)",
                  " AND (bmb05 > '",ans_2,"' OR bmb05 IS NULL)"
      END IF
      LET l_sql = l_sql clipped," INTO TEMP w2 "
      PREPARE i600_pbmt FROM l_sql
      EXECUTE i600_pbmt
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","bmt_file,bmb_inplan",old_no,old_bma06,SQLCA.sqlcode,"","i600_pbmt",1)  #No.TQC-660046
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
   END IF

   #元件廠牌資料是否復制ans_4
   IF ans_4 = 'Y' THEN
      DROP TABLE z
      LET l_sql = " SELECT UNIQUE bml_file.* FROM bml_file,bmb_inplan ",
                  " WHERE bmb01 = bml02 ",
                  "   AND bmb03 = bml01 ",
                  "   AND bmb01= '",old_no,"'"
      IF ans_2 IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED,
                  " AND (bmb04 <='",ans_2,"' OR bmb04 IS NULL)",
                  " AND (bmb05 > '",ans_2,"' OR bmb05 IS NULL)"
      END IF

      LET l_sql = l_sql clipped," INTO TEMP z "
      PREPARE i600_pbml FROM l_sql
      EXECUTE i600_pbml
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","bml_file,bmb_inplan",old_no,"",SQLCA.sqlcode,"","i600_pbmt",1)  #No.TQC-660046
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
   END IF

   #取替代件是否復制ans_5
   IF ans_5 = 'Y' THEN
      DROP TABLE d
      LET l_sql = " SELECT bmd_file.* FROM bmd_file,bmb_inplan ",
                  " WHERE bmb01 = bmd08 ",
                  "   AND bmb03 = bmd01 ",
                  "   AND bmb01= '",old_no,"'",
                  "   AND bmb29= '",old_bma06,"'",        #No:MOD-980049 add
                  "   AND bmdacti = 'Y'"                                           #CHI-910021
      IF ans_2 IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED,
                  " AND (bmb04 <='",ans_2,"' OR bmb04 IS NULL)",
                  " AND (bmb05 > '",ans_2,"' OR bmb05 IS NULL)"
      END IF
      LET l_sql = l_sql clipped," INTO TEMP d "
      PREPARE i600_pbmd FROM l_sql
      EXECUTE i600_pbmd
      IF SQLCA.sqlcode THEN
         CALL cl_err('i600_pbmd',SQLCA.sqlcode,0)
         ROLLBACK WORK #MOD-650016 add
         RETURN
      END IF
   END IF

   DROP TABLE y
   SELECT * FROM bma_inplan
    WHERE bma01=old_no
      AND bma06=old_bma06 #FUN-550014 add
     INTO TEMP y
   #MOD-A30131 ---end---

   BEGIN WORK
   LET g_success='Y'
   IF cl_null(old_bma06) THEN LET old_bma06 = ' ' END IF #FUN-550014 add
   IF cl_null(new_bma06) THEN LET new_bma06 = ' ' END IF #FUN-550014 add

#-------------------- COPY BODY (bmc_file) ------------------------------
   #說明資料是否復制ans_3
   IF ans_3 = 'Y' THEN
     #MOD-A30131 mark---start---
     # DROP TABLE w
     # LET l_sql = " SELECT bmc_file.* FROM bmc_file,bmb_inplan ",
     #             " WHERE bmb01 = bmc01 ",
     #             " AND   bmb29 = bmc06 ",  #FUN-550014 add
     #             " AND bmb02 = bmc02   ",
     #             " AND bmb03 = bmc021  ",
     #             " AND bmb04 = bmc03   ",
     #             " AND bmb01=  '",old_no,"'",
     #             " AND bmb29=  '",old_bma06,"'" #FUN-550014 add
     # IF ans_2 IS NOT NULL THEN
     #    LET l_sql=l_sql CLIPPED,
     #             " AND (bmb04 <='",ans_2,"' OR bmb04 IS NULL)",
     #             " AND (bmb05 > '",ans_2,"' OR bmb05 IS NULL)"
     # END IF
     #
     # LET l_sql = l_sql clipped," INTO TEMP w "
     # PREPARE i600_pbmc FROM l_sql
     # EXECUTE i600_pbmc
     # IF SQLCA.sqlcode THEN
     #    CALL cl_err3("sel","bmc_file,bmb_inplan",old_no,old_bma06,SQLCA.sqlcode,"","i600_pbmc",1)  #No.TQC-660046
     #    LET g_success = 'N'
     #    ROLLBACK WORK
     #    RETURN
     # END IF
     #MOD-A30131 mark---end---
      CASE
         WHEN ans_1 ='2'
            UPDATE w SET bmc03 = g_today
         WHEN ans_1 ='3'
            UPDATE w SET bmc03 = ef_date
      END CASE
      UPDATE w SET bmc01=new_no,
                   bmc06=new_bma06 #FUN-550014 add
      INSERT INTO bmc_file SELECT * FROM w
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","bmc_file",new_no,new_bma06,SQLCA.sqlcode,"","ins bmc",1)  #No.TQC-660046
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
      LET g_cnt=SQLCA.SQLERRD[3]
      MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
   END IF
#-------------------- COPY BODY (bmt_file) ------------------------------
   #插件位置是否復制ans_31
   IF ans_31 = 'Y' THEN
     #MOD-A30131 mark---start---
     # DROP TABLE w2
     # LET l_sql = " SELECT bmt_file.* FROM bmt_file,bmb_inplan ",
     #             " WHERE bmb01 = bmt01 ",    #主件
     #             " AND bmb29 = bmt08   ",    #FUN-550014 add
     #             " AND bmb02 = bmt02   ",    #項次
     #             " AND bmb03 = bmt03   ",    #元件
     #             " AND bmb04 = bmt04   ",    #生效日
     #             " AND bmb01=  '",old_no,"'",
     #             " AND bmb29=  '",old_bma06,"'" #FUN-550014 add
     # IF ans_2 IS NOT NULL THEN
     #    LET l_sql=l_sql CLIPPED,
     #             " AND (bmb04 <='",ans_2,"' OR bmb04 IS NULL)",
     #             " AND (bmb05 > '",ans_2,"' OR bmb05 IS NULL)"
     # END IF
     # LET l_sql = l_sql clipped," INTO TEMP w2 "
     # PREPARE i600_pbmt FROM l_sql
     # EXECUTE i600_pbmt
     # IF SQLCA.sqlcode THEN
     #    CALL cl_err3("sel","bmt_file,bmb_inplan",old_no,old_bma06,SQLCA.sqlcode,"","i600_pbmt",1)  #No.TQC-660046
     #    LET g_success = 'N'
     #    ROLLBACK WORK
     #    RETURN
     # END IF
     #MOD-A30131 mark---end---
      CASE
         WHEN ans_1 ='2'
            UPDATE w2 SET bmt04 = g_today
         WHEN ans_1 ='3'
            UPDATE w2 SET bmt04 = ef_date
      END CASE
      UPDATE w2 SET bmt01=new_no,
                    bmt08=new_bma06 #FUN-550014 add
      INSERT INTO bmt_file SELECT * FROM w2
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","bmt_file",new_no,new_bma06,SQLCA.sqlcode,"","ins bmt",1)  #No.TQC-660046
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
      LET g_cnt=SQLCA.SQLERRD[3]
      MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
   END IF
#-------------------- COPY BODY (bml_file) ------------------------------
   #元件廠牌資料是否復制ans_4
   IF ans_4 = 'Y' THEN
     #MOD-A30131 mark---start---
     # DROP TABLE z
     # LET l_sql = " SELECT UNIQUE bml_file.* FROM bml_file,bmb_inplan ",
     #             " WHERE bmb01 = bml02 ",
     #             "   AND bmb03 = bml01 ",
     #             "   AND bmb01= '",old_no,"'"
     # IF ans_2 IS NOT NULL THEN
     #    LET l_sql=l_sql CLIPPED,
     #             " AND (bmb04 <='",ans_2,"' OR bmb04 IS NULL)",
     #             " AND (bmb05 > '",ans_2,"' OR bmb05 IS NULL)"
     # END IF
     #
     # LET l_sql = l_sql clipped," INTO TEMP z "
     # PREPARE i600_pbml FROM l_sql
     # EXECUTE i600_pbml
     # IF SQLCA.sqlcode THEN
     #    CALL cl_err3("sel","bml_file,bmb_inplan",old_no,"",SQLCA.sqlcode,"","i600_pbmt",1)  #No.TQC-660046
     #    LET g_success = 'N'
     #    ROLLBACK WORK
     #    RETURN
     # END IF
     #MOD-A30131 mark---end---

      UPDATE z SET bml02=new_no
      INSERT INTO bml_file SELECT * FROM z
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","bml_file",new_no,"",SQLCA.sqlcode,"","ins bml",1)  #No.TQC-660046
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
      LET g_cnt=SQLCA.SQLERRD[3]
      MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
   END IF
#------------------ COPY (bmd_file) NO:0587 add in 99/10/01 By Kammy--
   #取替代件是否復制ans_5
   IF ans_5 = 'Y' THEN
     #MOD-A30131 mark---start---
     # DROP TABLE d
     # LET l_sql = " SELECT bmd_file.* FROM bmd_file,bmb_inplan ",
     #             " WHERE bmb01 = bmd08 ",
     #             "   AND bmb03 = bmd01 ",
     #             "   AND bmb01= '",old_no,"'",
     #             "   AND bmb29= '",old_bma06,"'",        #No:MOD-980049 add
     #             "   AND bmdacti = 'Y'"                                           #CHI-910021
     # IF ans_2 IS NOT NULL THEN
     #    LET l_sql=l_sql CLIPPED,
     #             " AND (bmb04 <='",ans_2,"' OR bmb04 IS NULL)",
     #             " AND (bmb05 > '",ans_2,"' OR bmb05 IS NULL)"
     # END IF
     # LET l_sql = l_sql clipped," INTO TEMP d "
     # PREPARE i600_pbmd FROM l_sql
     # EXECUTE i600_pbmd
     # IF SQLCA.sqlcode THEN
     #    CALL cl_err('i600_pbmd',SQLCA.sqlcode,0)
     #    ROLLBACK WORK #MOD-650016 add
     #    RETURN
     # END IF
     #MOD-A30131 mark---end---

    IF old_no = new_no AND old_bma06 != new_bma06 THEN  #TQC-610025
    ELSE                                               #TQC-610025
      UPDATE d SET bmd08=new_no
      DECLARE i600_cbmd CURSOR FOR SELECT * FROM d
      FOREACH i600_cbmd INTO l_bmd.*
#MOD-B90133 -- begin --
            CASE ans_1
               WHEN '2'   #系統日
                  LET l_bmd.bmd05 = g_today
               WHEN '3'   #人為輸入
                  LET l_bmd.bmd05 = ef_date
            END CASE
#MOD-B90133 -- end --
          LET l_bmd.bmdoriu = g_user      #No.FUN-980030 10/01/04
          LET l_bmd.bmdorig = g_grup      #No.FUN-980030 10/01/04
          IF cl_null(l_bmd.bmd11) THEN LET l_bmd.bmd11 = 'N' END IF      #TQC-C20131  add
          INSERT INTO bmd_file VALUES(l_bmd.*)
          IF STATUS OR SQLCA.SQLCODE THEN
              IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
              ELSE
                 CALL cl_err('ins bmd: ',SQLCA.SQLCODE,1)
                 LET g_success = 'N'
                 ROLLBACK WORK
                 RETURN
              END IF             #No:MOD-980229 add
          END IF
          LET g_cnt=SQLCA.SQLERRD[3]
          MESSAGE '(',g_cnt USING '##&',') ROW of (',new_no,') O.K'
      END FOREACH            #No:MOD-980229 add
   END IF
   END IF                                             #TQC-610025
#-------------------- COPY HEAD (bma_inplan) ------------------------------
  #MOD-A30131 mark---start---
  # DROP TABLE y
  # SELECT * FROM bma_inplan
  #  WHERE bma01=old_no
  #    AND bma06=old_bma06 #FUN-550014 add
  #   INTO TEMP y
  #MOD-A30131 mark---end---
   UPDATE y
       SET bma01=new_no,     #新的鍵值
           bma06=new_bma06,  #FUN-550014 add
           bma05=NULL,       #發放日
           bmauser=g_user,   #資料所有者
           bmagrup=g_grup,   #資料所有者所屬群
           bmamodu=NULL,     #資料修改日期
           bmadate=g_today,  #資料建立日期
           bma08  =g_plant,  #No.FUN-7C0010
           bma09  =0,        #No.FUN-7C0010
           bma10 = '0',      #開立狀態     #NO.FUN-810014
           bmaacti='Y'       #有效資料
   INSERT INTO bma_inplan SELECT * FROM y
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('ins bma: ',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   END IF
#-------------------- COPY BODY (bmb_inplan) ------------------------------
   #DROP TABLE x #MOD-A30131 mark
   LET l_sql = " SELECT * FROM bmb_inplan WHERE bmb01='",old_no,"'",
                                       "  AND bmb29='",old_bma06,"'" #FUN-550014 add
      IF ans_2 IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED,
                  " AND (bmb04 <='",ans_2,"' OR bmb04 IS NULL)",
                  " AND (bmb05 > '",ans_2,"' OR bmb05 IS NULL)"
      END IF
   PREPARE i600_pbmb FROM l_sql
   DECLARE i600_cbmb CURSOR FOR i600_pbmb
   FOREACH i600_cbmb INTO l_bmb.*
      IF SQLCA.SQLCODE THEN CALL cl_err('sel bmb:',SQLCA.SQLCODE,0)
         EXIT FOREACH
      END IF
      LET l_bmb.bmb01 = new_no
      LET l_bmb.bmb29 = new_bma06 #FUN-550014 add
      LET l_bmb.bmb24=null
      IF ans_1 = '2' THEN LET l_bmb.bmb04 = g_today END IF
      IF ans_1 = '3' THEN LET l_bmb.bmb04 = ef_date END IF
      #若有效日期未指定, 且生效日不使用原生效日時, 必須將失效日清null
      #否則可能產生 生效日 > 失效日之情況
      IF cl_null(ans_2) AND ans_1 <> '1' THEN
         LET l_bmb.bmb05=null
      END IF
      IF cl_null(l_bmb.bmb28) THEN LET l_bmb.bmb28 = 0 END IF
      IF ans_31 = 'N' THEN
          LET l_bmb.bmb13 = NULL
      END IF
       LET l_bmb.bmb33 = '0'
      INSERT INTO bmb_inplan VALUES(l_bmb.*)
      IF SQLCA.SQLCODE <> 0 THEN
         CALL cl_err3("ins","bmb_inplan",l_bmb.bmb01,l_bmb.bmb02,"mfg-001","","",1)  #No.TQC-660046
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF s_industry('icd')  THEN
         SELECT COUNT(*) INTO l_n FROM icm_file       #FUN-980033
          WHERE icm01 = l_bmb.bmb03 AND icm02 = l_bmb.bmb01 #FUN-980033
         IF l_n = 0 THEN
            INITIALIZE l_icm.* TO NULL
            LET l_icm.icm01 = l_bmb.bmb03
            LET l_icm.icm02 = l_bmb.bmb01
            LET l_icm.icmacti = 'Y'
            LET l_icm.icmdate = g_today
            LET l_icm.icmgrup = g_grup
            LET l_icm.icmmodu = ''
            LET l_icm.icmuser = g_user
            LET l_icm.icmoriu = g_user      #No.FUN-980030 10/01/04
            LET l_icm.icmorig = g_grup      #No.FUN-980030 10/01/04
            INSERT INTO icm_file VALUES (l_icm.*)
           IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","icm_file",l_bmb.bmb01,l_bmb.bmb03,SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
           END IF
         END IF
      END IF
      LET g_wsw03 = l_bmb.bmb01 CLIPPED ,"|",l_bmb.bmb02 CLIPPED
      CASE aws_mdmdata('bmb_inplan','insert',g_wsw03,base.TypeInfo.create(l_bmb),'CreateBOMData') #FUN-890113
         WHEN 0  #無與 MDM 整合
           MESSAGE 'INSERT O.K'
         WHEN 1  #呼叫 MDM 成功
           MESSAGE 'INSERT O.K, INSERT MDM O.K'
         WHEN 2  #呼叫 MDM 失敗
           ROLLBACK WORK
      END CASE
   END FOREACH
#-------------------- 復制固定屬性  (bmv_file) ------------------------------
  IF s_industry('slk') THEN
   LET l_sql = " SELECT * FROM bmv_file WHERE bmv01='",old_no,"'",
                                       "  AND bmv03='",old_bma06,"'"
   PREPARE i600_pbmv FROM l_sql
   DECLARE i600_cbmv CURSOR FOR i600_pbmv
   FOREACH i600_cbmv INTO l_bmv.*
      IF SQLCA.SQLCODE THEN CALL cl_err('sel bmv:',SQLCA.SQLCODE,0)
         EXIT FOREACH
      END IF
      LET l_bmv.bmv01 = new_no
      LET l_bmv.bmv03 = new_bma06
      INSERT INTO bmv_file VALUES(l_bmv.*)
      IF SQLCA.SQLCODE <> 0 THEN
         CALL cl_err3("ins","bmv_file",l_bmv.bmv01,l_bmv.bmv02,"mfg-001","","",1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
  END IF
END IF


   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_err('','abm-019',0)
      #FUN-C30027---begin
      #LET g_wc="bma01='",new_no,"'"
      #CALL i600_q(0)
      SELECT * 
        INTO g_bma.*
        from bma_inplan
       WHERE bma01 = new_no
         AND bma06 = g_bma.bma06
      CALL i600_show()
      #FUN-C30027---end
   ELSE
      ROLLBACK WORK
      CALL cl_err('','abm-020',0)
   END IF
   CASE aws_mdmdata('bma_inplan','insert',g_bma.bma01,base.TypeInfo.create(g_bma),'CreateBOMData') #FUN-890113
      WHEN 0  #無與 MDM 整合
           MESSAGE 'INSERT O.K'
      WHEN 1  #呼叫 MDM 成功
           MESSAGE 'INSERT O.K, INSERT MDM O.K'
      WHEN 2  #呼叫 MDM 失敗
           ROLLBACK WORK
   END CASE



END FUNCTION

FUNCTION i6002_prompt()
    DEFINE l_cmd    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(200),
           l_chr    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(01),
           l_n      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
           l_bmd02  LIKE bmd_file.bmd02     #MOD-9A0084
    DEFINE l_bmb16  LIKE bmb_inplan.bmb16     #TQC-C20419 add

  IF g_bmb[l_ac].bmb16 matches'[129]' THEN  #TQC-B90236
#TQC-C20419 ----- add ----- begin
     IF g_bmb[l_ac].bmb16 = '9' THEN
        LET l_bmb16 = '3'
     ELSE
        LET l_bmb16 = g_bmb[l_ac].bmb16
     END IF
#TQC-C20419 ----- add ----- end
     SELECT COUNT(*) INTO l_n FROM bmd_file
      WHERE bmd01 = g_bmb[l_ac].bmb03
        AND bmd02 = l_bmb16                 #TQC-C20419 modify 
        AND (bmd08 = 'ALL'
        OR bmd08 = g_bma.bma01)
        AND bmdacti = 'Y'                                           #CHI-910021
     IF l_n > 0 THEN
        IF NOT cl_confirm('abm-100') THEN RETURN END IF
     ELSE
        IF NOT cl_confirm('abm-200') THEN RETURN END IF
     END IF

     LET l_cmd = "abmi604 '",g_bmb[l_ac].bmb03,"' ",
                           "'",g_bma.bma01,      "' ",
                           "'",g_bmb[l_ac].bmb16,"' "
     CALL cl_cmdrun_wait(l_cmd)

     LET l_n = 0
     SELECT COUNT(*) INTO l_n FROM bmd_file
      WHERE bmd01=g_bmb[l_ac].bmb03
        AND bmdacti = 'Y'
     IF l_n = 0 THEN
        UPDATE bmb_inplan SET bmb16 = '0',
                            bmbdate=g_today     #FUN-C40007 add
         WHERE bmb01=g_bma.bma01 AND bmb03=g_bmb[l_ac].bmb03
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","bmb_inplan",g_bma.bma01,g_bmb[l_ac].bmb03,SQLCA.sqlcode,"","",0)
         END IF
     ELSE
        LET l_bmd02 = ''
        SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
           WHERE bmd01=g_bmb[l_ac].bmb03 AND bmd08 = g_bma.bma01
             AND bmdacti = 'Y'
        IF NOT cl_null(l_bmd02) THEN
#TQC-C20419 ----- add ----- begin
           IF l_bmd02 = '3' THEN
              LET l_bmd02 = '9'
           END IF
#TQC-C20419 ----- add ----- end
           UPDATE bmb_inplan SET bmb16 = l_bmd02,
                               bmbdate=g_today     #FUN-C40007 add
            WHERE bmb01=g_bma.bma01 AND bmb03=g_bmb[l_ac].bmb03
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","bmb_inplan",g_bma.bma01,g_bmb[l_ac].bmb03,SQLCA.sqlcode,"","",0)
           END IF
        ELSE
           LET l_bmd02 = ''
           SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
              WHERE bmd01=g_bmb[l_ac].bmb03 AND bmd08 = 'ALL'
                AND bmdacti = 'Y'
           IF NOT cl_null(l_bmd02) THEN
#TQC-C20419 ----- add ----- begin
              IF l_bmd02 = '3' THEN
                 LET l_bmd02 = '9'
              END IF
#TQC-C20419 ----- add ----- end
              UPDATE bmb_inplan SET bmb16 = l_bmd02,
                                  bmbdate=g_today     #FUN-C40007 add
               WHERE bmb01=g_bma.bma01 AND bmb03=g_bmb[l_ac].bmb03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","bmb_inplan",g_bma.bma01,g_bmb[l_ac].bmb03,SQLCA.sqlcode,"","",0)
              END IF
           END IF
        END IF
     END IF
     SELECT bmb16 INTO g_bmb[l_ac].bmb16 FROM bmb_inplan
       WHERE bmb01 = g_bma.bma01
         AND bmb29 = g_bma.bma06
         AND bmb02 = g_bmb[l_ac].bmb02
         AND bmb03 = g_bmb[l_ac].bmb03
         AND bmb04 = g_bmb[l_ac].bmb04
     DISPLAY BY NAME g_bmb[l_ac].bmb16
  ELSE
#FUN-A40058 --begin--
     IF g_bmb[l_ac].bmb16 matches'[7]' THEN
        SELECT COUNT(ima01) INTO l_n FROM ima_file,bon_file,bmb_inplan
         WHERE imaacti = 'Y'
           AND bmb03 = g_bmb[l_ac].bmb03
           AND bmb03 = bon01
           AND bmb01 = g_bma.bma01
           AND (bmb01 = bon02 or bon02 = '*')
           AND bmb16 = '7'
           AND bonacti = 'Y'
           AND ima251 = bon06
           AND ima109 = bon07
           AND ima54  = bon08
           AND ima022 BETWEEN bon04 AND bon05
           AND ima01 != bon01
         ORDER BY ima01

        IF l_n > 0 THEN
           IF NOT cl_confirm('abm-100') THEN RETURN END IF
        ELSE
           IF NOT cl_confirm('abm-200') THEN RETURN END IF
        END IF

        LET l_cmd = "abmi6043  "
        CALL cl_cmdrun_wait(l_cmd)
     END IF
#FUN-A40058 --end--
     IF g_bmb[l_ac].bmb16 = '5' THEN
        LET l_cmd = "abmi610 '",g_bma.bma01 CLIPPED,"' "
        CALL cl_cmdrun(l_cmd)
     END IF
  END IF
END FUNCTION

FUNCTION cbmi600_viewcad(p_path)
    DEFINE p_path          LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(256),
           l_viewcad_cmd   LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(512)

    IF NOT cl_null(p_path) THEN
       LET l_viewcad_cmd = "viewcad '",p_path,"'"
       RUN l_viewcad_cmd
    END IF
END FUNCTION



FUNCTION i600_up_bmb13(p_ac)
 DEFINE l_bmt06   LIKE bmt_file.bmt06,
        l_bmb13   LIKE bmb_inplan.bmb13,
        l_i       LIKE type_file.num5,     #No.FUN-680096 SMALLINT,
        i,j       LIKE type_file.num5,     #No.MOD-6B0077 add
        p_ac      LIKE type_file.num5      #No.FUN-680096 SMALLINT

    LET l_bmb13=' '
    LET l_i = 0
    DECLARE up_bmb13_cs CURSOR FOR
     SELECT bmt06 FROM bmt_file
      WHERE bmt01=g_bma.bma01
        AND bmt02=g_bmb[p_ac].bmb02
        AND bmt03=g_bmb[p_ac].bmb03
        AND bmt04=g_bmb[p_ac].bmb04
        AND bmt08=g_bma.bma06 #FUN-550014 add

    FOREACH up_bmb13_cs INTO l_bmt06
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     IF l_i = 0 THEN
        LET l_bmb13=l_bmt06
     ELSE
        IF (Length(l_bmb13) + Length(l_bmt06)) > 8 THEN
           LET j = 10 - Length(l_bmb13)
           FOR i=1 TO j
               LET l_bmb13 = l_bmb13 CLIPPED , '.'
           END FOR
           EXIT FOREACH
        ELSE
           LET l_bmb13= l_bmb13 CLIPPED , ',', l_bmt06
        END IF
     END IF
     LET l_i = l_i + 1
    END FOREACH
    RETURN l_bmb13
END FUNCTION

FUNCTION i600_aps_bmb()
DEFINE l_vmo     RECORD LIKE vmo_file.*   #FUN-7C0002 add

    IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
       CALL cl_err(g_bma.bma08,'aoo-045',1)
       RETURN
    END IF

    DECLARE aps_bmb_ins CURSOR FOR
     SELECT bmb01,bmb03,bmb02                      #FUN-7C0002
       FROM bmb_inplan
      WHERE bmb01=g_bma.bma01
        AND (bmb04 <=g_today OR bmb04 IS NULL)
        AND (bmb05 >g_today OR bmb05 IS NULL)
        AND bmb29=g_bma.bma06 #FUN-720043 add

      FOREACH aps_bmb_ins INTO l_vmo.*             #FUN-7C0002 add

          SELECT COUNT(*) INTO g_cnt
            FROM vmo_file
           WHERE vmo01 = l_vmo.vmo01
             AND vmo03 = l_vmo.vmo03
             AND vmo02 = l_vmo.vmo02
          IF g_cnt <= 0 THEN
              LET l_vmo.vmo11= 0
              LET l_vmo.vmo13= 0
              LET l_vmo.vmo14= 0
              LET l_vmo.vmo15 = 0
              LET l_vmo.vmo16= 0
              LET l_vmo.vmo17= 0
              LET l_vmo.vmo18= 0
              INSERT INTO vmo_file VALUES(l_vmo.*)
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","vmo_file",l_vmo.vmo01,l_vmo.vmo02,SQLCA.sqlcode,"","insert aps_bmb",1)  #No.TQC-660046
              END IF
          END IF
           UPDATE bma_inplan set bmadate=g_today where bma01=l_vmo.vmo01

      END FOREACH
END FUNCTION

#將原來的insert_loc資料先備份起來,再置換成新的
FUNCTION i600_bmt_tmp(p_bma01,p_bmb02_t,p_bmb03_t,p_bmb04_t,p_bmb02,p_bmb03,p_bmb04)
   DEFINE p_bma01   LIKE bma_inplan.bma01
   DEFINE p_bmb02_t LIKE bmb_inplan.bmb02,#(舊值)
          p_bmb03_t LIKE bmb_inplan.bmb03,
          p_bmb04_t LIKE bmb_inplan.bmb04
   DEFINE p_bmb02   LIKE bmb_inplan.bmb02,#(新值)
          p_bmb03   LIKE bmb_inplan.bmb03,
          p_bmb04   LIKE bmb_inplan.bmb04
   DEFINE l_cnt,l_i LIKE type_file.num10     #No.FUN-680096 INTEGER


   LET g_success = 'Y'

     DECLARE i600_ins_bmt CURSOR FOR
         SELECT * FROM bmt_file
          WHERE bmt01 =p_bma01
            AND bmt02 =p_bmb02_t
            AND bmt03 =p_bmb03_t
            AND bmt04 =p_bmb04_t
     FOR l_cnt = 1 TO 360           #ARRAY 干洗
        INITIALIZE g_bmt_tmp[l_cnt].* TO NULL
     END FOR
     LET l_cnt = 1
     FOREACH i600_ins_bmt INTO g_bmt_tmp[l_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:i600_ins_bmt',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_cnt = l_cnt + 1
     END FOREACH
     DELETE FROM bmt_file
      WHERE bmt01 =p_bma01
        AND bmt02 =p_bmb02_t
        AND bmt03 =p_bmb03_t
        AND bmt04 =p_bmb04_t
     IF sqlca.sqlcode THEN
        LET g_success = 'N'
     END IF
     IF cl_null(p_bmb02) THEN
        LET p_bmb02=0
     END IF
     FOR l_i = 1 TO l_cnt-1
          LET g_bmt_tmp[l_i].bmt02 = p_bmb02
          LET g_bmt_tmp[l_i].bmt03 = p_bmb03
          LET g_bmt_tmp[l_i].bmt04 = p_bmb04
          INSERT INTO bmt_file VALUES(g_bmt_tmp[l_i].*)
          IF sqlca.sqlcode THEN
              LET g_success = 'N'
          END IF
     END FOR
END FUNCTION

FUNCTION i600_set_entry()
    CALL cl_set_comp_entry("ef_date,old_bma06,new_bma06",TRUE)  #FUN-550014 add bma06
END FUNCTION

FUNCTION i600_set_no_entry()
    CALL cl_set_comp_entry("ef_date",FALSE)
    IF g_sma.sma118 != 'Y' THEN
        CALL cl_set_comp_entry("old_bma06,new_bma06",FALSE)
    END IF
END FUNCTION


FUNCTION i600_set_required(p_ans_1)
  DEFINE    p_ans_1       LIKE type_file.chr1      #No.FUN-680096   VARCHAR(1)
    IF p_ans_1 = '3' THEN
        CALL cl_set_comp_required("ef_date",TRUE)
    END IF
END FUNCTION

FUNCTION i600_set_no_required(p_ans_1)
  DEFINE   p_ans_1        LIKE type_file.chr1      #No.FUN-680096  VARCHAR(1)
    CALL cl_set_comp_required("ef_date",FALSE)
END FUNCTION


#目標資料庫中若有不存在于來源資料庫的BOM結構,則輸出到Excel
FUNCTION i600_err_msg(p_sql,p_tblname,p_dbname)
DEFINE p_tblname LIKE cre_file.cre08     #No.FUN-680096 VARCHAR(10)
DEFINE p_dbname  LIKE type_file.chr20    #No.FUN-680096 VARCHAR(20)
DEFINE p_sql     STRING
DEFINE l_ima01   LIKE ima_file.ima01
DEFINE l_ima02   LIKE ima_file.ima02
DEFINE l_n       LIKE type_file.num10    #No.FUN-680096 INTEGER

   IF cl_null(p_sql) THEN
      RETURN
   END IF
   PREPARE i600_err_msg_p FROM p_sql
   DECLARE i600_err_msg_c CURSOR FOR i600_err_msg_p
   FOREACH i600_err_msg_c INTO l_ima01,l_ima02
      IF cl_null(l_ima01) THEN
         CONTINUE FOREACH
      END IF
      LET l_n=g_itm.getlength()+1
      LET g_itm[l_n].db=p_dbname
      LET g_itm[l_n].tblname=p_tblname
      LET g_itm[l_n].ima01=l_ima01
      LET g_itm[l_n].ima02=l_ima02
   END FOREACH
   CLOSE i600_err_msg_c
END FUNCTION


FUNCTION i600_i_set_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1      #NO.FUN-810014
    CALL cl_set_comp_entry("bma06,bma10",TRUE)  #NO.FUN-810014 add bma10
END FUNCTION


FUNCTION i600_i_set_no_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1      #NO.FUN-810014
    IF g_sma.sma118 != 'Y' THEN
        CALL cl_set_comp_entry("bma06",FALSE)
    END IF
    IF p_cmd ='a' OR p_cmd = 'u' THEN   #NO.FUN-810014
        CALL cl_set_comp_entry("bma10",FALSE) #NO.FUN-810014
    END IF                               #NO.FUN-810014
END FUNCTION
FUNCTION i600_b_set_entry()
    CALL cl_set_comp_entry("bmb30",TRUE)
END FUNCTION
FUNCTION i600_b_set_no_entry()
    IF g_sma.sma118 != 'Y' THEN
        CALL cl_set_comp_entry("bmb30",FALSE)
    END IF
END FUNCTION


FUNCTION preview_bom()
 DEFINE l_sql        STRING     #LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(400)  #MOD-6A0145
 DEFINE l_bma01      LIKE bma_inplan.bma01
 DEFINE l_ima01      LIKE ima_file.ima01
 DEFINE l_imaag      LIKE ima_file.imaag
 DEFINE l_imaag1     LIKE ima_file.imaag1
 DEFINE i,j          LIKE type_file.num10     #No.FUN-680096 INTEGER
 DEFINE l_name       LIKE agc_file.agc01
 DEFINE l_bom_str    STRING
 DEFINE l_bom_str1   STRING
 DEFINE l_bom_str2   STRING
 DEFINE l_result     STRING
 DEFINE l_result1    STRING
 DEFINE l_result2    STRING
 DEFINE bom_tmp1     DYNAMIC ARRAY OF RECORD
                     tmp1_agb03 LIKE agb_file.agb03
                     END RECORD
 DEFINE bom_arr      DYNAMIC ARRAY OF RECORD
                     name   LIKE agc_file.agc01,
                     value  LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20),
                     value1 LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20),
                     valued LIKE type_file.chr20   #No.FUN-680096 VARCHAR(20)
                     END RECORD
 DEFINE l_agb03      LIKE agb_file.agb03
 DEFINE l_agd03      LIKE agd_file.agd03
 DEFINE l_agd02      LIKE agd_file.agd02
 DEFINE l_agc01      LIKE agc_file.agc01,
        lsb_item     base.StringBuffer,
        lsb_value    base.StringBuffer,
        l_n          LIKE type_file.num5      #No.FUN-680096 SMALLINT
 DEFINE l_msg        STRING,
        l_msg1       STRING
 DEFINE l_agc02      LIKE agc_file.agc02
 DEFINE l_child      LIKE ima_file.ima01    #FUN-640139 Add

     OPEN WINDOW cl_fml_input_w2 WITH FORM "abm/42f/abmi600_1"
                 ATTRIBUTE(STYLE = "report")
     CALL cl_ui_init()
     CALL cl_ui_locale("abmi600_1")

     FOR i = 1 TO 10
         LET l_msg = 'att',2*i-1 USING '&&'
         LET l_msg1 = 'att',2*i USING '&&'
         CALL cl_set_comp_visible(l_msg,FALSE)
         CALL cl_set_comp_visible(l_msg1,FALSE)
     END FOR

     SELECT ima01,imaag,imaag1
       INTO l_ima01,l_imaag,l_imaag1
       FROM ima_file
      WHERE ima01 = g_bma.bma01


     IF (cl_null(l_imaag))OR(l_imaag = '@CHILD') THEN RETURN END IF

     LET l_sql = "SELECT agb03,agc01,agc02 from agb_file,aga_file,agc_file ",
                      " WHERE agb01 = aga01",
                      "   AND agb01 = '",l_imaag,"'",
                      "   AND agb03 = agc01 "


     PREPARE i6001_tmp1 FROM l_sql
     DECLARE tmp1_lcur CURSOR FOR i6001_tmp1


     LET i=1
     CALL g_att.clear()

     FOREACH tmp1_lcur INTO l_agb03,l_agc01,l_agc02
         #判斷循環的正確性
        IF STATUS THEN
           CALL cl_err('foreach agb',STATUS,0)
           EXIT FOREACH
        END IF

        #這些是我添加的填充lr_agc數組的代碼，該數組會在后面INPUT ARRAY調用的
        SELECT * INTO lr_agc[i].* FROM agc_file WHERE agc01 = l_agb03

        SELECT count(*) INTO l_n
          FROM agd_file
         WHERE agd01 = l_agc01

        IF l_n >0 THEN
          LET l_msg = 'att',2*i-1 USING '&&'
          LET l_msg1 = 'att',2*i USING '&&'
          CALL cl_set_comp_att_text(l_msg,l_agc02)
          CALL cl_set_comp_visible(l_msg,TRUE)
          CALL cl_set_comp_visible(l_msg1,FALSE)

          LET g_value[2*i-1].fname = l_msg
          LET g_value[2*i-1].visible = 'Y'
          LET g_value[2*i-1].imx000 = 'imx',i USING '&&'   #No.TQC-660059
          LET g_value[2*i-1].nvalue = l_agc01
          LET g_value[2*i].fname = l_msg1
          LET g_value[2*i].visible = 'N'
          LET g_value[2*i].imx000 = 'imx',i USING '&&'   #No.TQC-660059
          LET g_value[2*i].nvalue = ''
          #填充組合框中的選項
          LET lsb_item  = base.StringBuffer.create()
          LET lsb_value = base.StringBuffer.create()
          DECLARE agd_cur CURSOR FOR
          SELECT agd02,agd03 FROM agd_file
           WHERE agd01 = l_agb03
          FOREACH agd_cur INTO l_agd02,l_agd03
            IF STATUS THEN
               CALL cl_err('foreach agb',STATUS,0)
               EXIT FOREACH
            END IF
            IF lsb_value IS NULL THEN
                CALL lsb_value.append(l_agd03 CLIPPED || ":" ||l_agd03 CLIPPED || ",")
            ELSE
                CALL lsb_value.append(lsb_value || "," ||l_agd02|| ":" ||l_agd03 CLIPPED || ",")
            END IF
            IF lsb_item IS NULL THEN
                CALL lsb_item.append(l_agd02 CLIPPED || ",")
            ELSE
                CALL lsb_item.append(lsb_item || "," ||l_agd02 CLIPPED || ",")
            END IF
          END FOREACH
          CALL cl_set_combo_items(l_msg,lsb_item.toString(),
                                   lsb_value.toString())
        ELSE
          LET l_msg = 'att',2*i USING '&&'
          LET l_msg1= 'att',2*i-1 USING '&&'
          CALL cl_set_comp_att_text(l_msg ,l_agc02)
          CALL cl_set_comp_visible(l_msg,TRUE)
          CALL cl_set_comp_visible(l_msg1,FALSE)
          LET g_value[2*i].fname = l_msg
          LET g_value[2*i].visible = 'Y'
          LET g_value[2*i].imx000 = 'imx',i USING '&&'  #No.TQC-660059
          LET g_value[2*i].nvalue = l_agc01
          LET g_value[2*i-1].fname = l_msg1
          LET g_value[2*i-1].visible = 'N'
          LET g_value[2*i-1].imx000 = 'imx',i USING '&&'  #No.TQC-660059
          LET g_value[2*i-1].nvalue = ''
        END IF

        LET i = i + 1
        #這里防止下標溢出導致錯誤
        IF i = 11 THEN EXIT FOREACH END IF
     END FOREACH

     FOR i = i TO 10
        LET l_msg = 'att',2*i-1 USING '&&'
        LET l_msg1= 'att',2*i USING '&&'
        CALL cl_set_comp_visible(l_msg,FALSE)
        CALL cl_set_comp_visible(l_msg1,FALSE)
        LET g_value[2*i-1].fname = l_msg
        LET g_value[2*i-1].visible = 'N'
        LET g_value[2*i-1].imx000 = 'imx000',i USING '&&'  #No.TQC-660059
        LET g_value[2*i-1].nvalue = ''
        LET g_value[2*i].fname = l_msg1
        LET g_value[2*i].visible = 'N'
        LET g_value[2*i].imx000 = 'imx',i USING '&&'  #No.TQC-660059
        LET g_value[2*i].nvalue = ''
     END FOR

     INPUT ARRAY g_att WITHOUT DEFAULTS FROM s_arr.*
         ATTRIBUTE(COUNT=1,APPEND ROW=FALSE,INSERT ROW=FALSE,DELETE ROW=FALSE,
                   UNBUFFERED)

     BEFORE ROW
         LET l_ac = ARR_CURR()


   #因為修改太多處而且基本上都差不多，所以不單獨注釋了
   #原來的輸入型欄位att01,att03...att19都沒有加欄位檢核，這樣用戶可以亂輸并
   #生成不符合系統要求的料件，現在增加一個函數i600_check_att0x來做檢核，并
   #在這些輸入型欄位的AFTER FIELD中進行調用

   #唯一需要注意的是p_index參數賦的值不是1,3,5...19，而是1,2,3...9


    AFTER FIELD att01
       IF NOT cl_null(g_att[l_ac].att01) THEN
          LET g_value[1].value = g_att[l_ac].att01 END IF

    AFTER FIELD att02
       IF NOT cl_null(g_att[l_ac].att02) THEN
          IF i600_check_att0x(g_att[l_ac].att02,1) THEN
             LET g_value[2].value = g_att[l_ac].att02
          ELSE
             NEXT FIELD att02
          END IF
       END IF

    AFTER FIELD att03
       IF NOT cl_null(g_att[l_ac].att03) THEN
          LET g_value[3].value = g_att[l_ac].att03 END IF

    AFTER FIELD att04
       IF NOT cl_null(g_att[l_ac].att04) THEN
          IF i600_check_att0x(g_att[l_ac].att04,2) THEN
             LET g_value[4].value = g_att[l_ac].att04
          ELSE
             NEXT FIELD att04
          END IF
       END IF

    AFTER FIELD att05
       IF NOT cl_null(g_att[l_ac].att05) THEN
          LET g_value[5].value = g_att[l_ac].att05 END IF

    AFTER FIELD att06
       IF NOT cl_null(g_att[l_ac].att06) THEN
          IF i600_check_att0x(g_att[l_ac].att06,3) THEN
             LET g_value[6].value = g_att[l_ac].att06
          ELSE
             NEXT FIELD att06
          END IF
       END IF

    AFTER FIELD att07
       IF NOT cl_null(g_att[l_ac].att07) THEN
          LET g_value[7].value = g_att[l_ac].att07 END IF

    AFTER FIELD att08
       IF NOT cl_null(g_att[l_ac].att08) THEN
          IF i600_check_att0x(g_att[l_ac].att08,4) THEN
             LET g_value[8].value = g_att[l_ac].att08
          ELSE
             NEXT FIELD att08
          END IF
       END IF

    AFTER FIELD att09
       IF NOT cl_null(g_att[l_ac].att09) THEN
          LET g_value[9].value = g_att[l_ac].att09 END IF

    AFTER FIELD att10
       IF NOT cl_null(g_att[l_ac].att10) THEN
          IF i600_check_att0x(g_att[l_ac].att10,5) THEN
             LET g_value[10].value = g_att[l_ac].att10
          ELSE
             NEXT FIELD att10
          END IF
       END IF

    AFTER FIELD att11
       IF NOT cl_null(g_att[l_ac].att11) THEN
          LET g_value[11].value = g_att[l_ac].att11 END IF

    AFTER FIELD att12
       IF NOT cl_null(g_att[l_ac].att12) THEN
          IF i600_check_att0x(g_att[l_ac].att12,6) THEN
             LET g_value[12].value = g_att[l_ac].att12
          ELSE
             NEXT FIELD att12
          END IF
       END IF

    AFTER FIELD att13
       IF NOT cl_null(g_att[l_ac].att13) THEN
          LET g_value[13].value = g_att[l_ac].att13 END IF

    AFTER FIELD att14
       IF NOT cl_null(g_att[l_ac].att14) THEN
          IF i600_check_att0x(g_att[l_ac].att14,7) THEN
             LET g_value[14].value = g_att[l_ac].att14
          ELSE
             NEXT FIELD att14
          END IF
       END IF

    AFTER FIELD att15
       IF NOT cl_null(g_att[l_ac].att15) THEN
          LET g_value[15].value = g_att[l_ac].att15 END IF

    AFTER FIELD att16
       IF NOT cl_null(g_att[l_ac].att16) THEN
          IF i600_check_att0x(g_att[l_ac].att16,8) THEN
             LET g_value[16].value = g_att[l_ac].att16
          ELSE
             NEXT FIELD att16
          END IF
       END IF

    AFTER FIELD att17
       IF NOT cl_null(g_att[l_ac].att17) THEN
          LET g_value[17].value = g_att[l_ac].att17 END IF

    AFTER FIELD att18
       IF NOT cl_null(g_att[l_ac].att18) THEN
          IF i600_check_att0x(g_att[l_ac].att18,9) THEN
             LET g_value[18].value = g_att[l_ac].att18
          ELSE
             NEXT FIELD att18
          END IF
       END IF

    AFTER FIELD att19
       IF NOT cl_null(g_att[l_ac].att19) THEN
          LET g_value[19].value = g_att[l_ac].att19 END IF

    AFTER FIELD att20
       IF NOT cl_null(g_att[l_ac].att20) THEN
          IF i600_check_att0x(g_att[l_ac].att20,10) THEN
             LET g_value[20].value = g_att[l_ac].att20
          ELSE
             NEXT FIELD att20
          END IF
       END IF


    AFTER INPUT
       IF INT_FLAG THEN
          EXIT INPUT
       END IF
       IF (cl_null(g_att[l_ac].att01) AND g_value[1].visible= 'Y') OR
          (cl_null(g_att[l_ac].att02) AND g_value[2].visible= 'Y') OR
          (cl_null(g_att[l_ac].att03) AND g_value[3].visible= 'Y') OR
          (cl_null(g_att[l_ac].att04) AND g_value[4].visible= 'Y') OR
          (cl_null(g_att[l_ac].att05) AND g_value[5].visible= 'Y') OR
          (cl_null(g_att[l_ac].att06) AND g_value[6].visible= 'Y') OR
          (cl_null(g_att[l_ac].att07) AND g_value[7].visible= 'Y') OR
          (cl_null(g_att[l_ac].att08) AND g_value[8].visible= 'Y') OR
          (cl_null(g_att[l_ac].att09) AND g_value[9].visible= 'Y') OR
          (cl_null(g_att[l_ac].att10) AND g_value[10].visible= 'Y') OR
          (cl_null(g_att[l_ac].att11) AND g_value[11].visible= 'Y') OR
          (cl_null(g_att[l_ac].att12) AND g_value[12].visible= 'Y') OR
          (cl_null(g_att[l_ac].att13) AND g_value[13].visible= 'Y') OR
          (cl_null(g_att[l_ac].att14) AND g_value[14].visible= 'Y') OR
          (cl_null(g_att[l_ac].att15) AND g_value[15].visible= 'Y') OR
          (cl_null(g_att[l_ac].att16) AND g_value[16].visible= 'Y') OR
          (cl_null(g_att[l_ac].att17) AND g_value[17].visible= 'Y') OR
          (cl_null(g_att[l_ac].att18) AND g_value[18].visible= 'Y') OR
          (cl_null(g_att[l_ac].att19) AND g_value[19].visible= 'Y') OR
          (cl_null(g_att[l_ac].att20) AND g_value[20].visible= 'Y')
       THEN
          CALL cl_err('','abm-997',0)
          IF g_value[1].visible = 'Y' THEN
              NEXT FIELD att01
          ELSE
              NEXT FIELD att02
          END IF
       END IF

    ON ACTION controlg       #TQC-860021
       CALL cl_cmdask()      #TQC-860021

    ON IDLE g_idle_seconds   #TQC-860021
       CALL cl_on_idle()     #TQC-860021
       CONTINUE INPUT        #TQC-860021

    ON ACTION about          #TQC-860021
       CALL cl_about()       #TQC-860021

    ON ACTION help           #TQC-860021
       CALL cl_show_help()   #TQC-860021
     END INPUT

     IF INT_FLAG THEN
        LET INT_FLAG = 0
     ELSE
        LET i = 1
        FOR i = 1 TO 20
            IF g_value[i].visible = 'Y' THEN
               LET l_bom_str = g_value[i].value
               LET l_bom_str = l_bom_str.trim()
               LET l_bom_str1 = g_value[i].nvalue
               LET l_bom_str1= l_bom_str1.trim()
               LET l_bom_str2= '#',l_bom_str1,'#'
               LET l_result1 = l_result1,g_sma.sma46,l_bom_str
               LET l_sql = "SELECT agd03,agc01",
                           "  FROM agd_file,agc_file",
                           " WHERE agd02 = '",l_bom_str,"'",
                           "   AND agd01 = agc01 ",
                           "   AND agc01 = '",l_bom_str1,"'"
               PREPARE i6001_tmp3 FROM l_sql
               DECLARE tmp3_lcur CURSOR FOR i6001_tmp3
               LET l_agd03 = ''
               LET l_agc01 = ''
               FOREACH tmp3_lcur INTO l_agd03,l_agc01
                  LET l_result2 = l_result2,g_sma.sma46,l_agd03
                  LET l_result = l_result,l_bom_str2,'|',l_bom_str,'|'
               END FOREACH
               IF SQLCA.sqlcode=100 OR cl_null(l_agc01) THEN
                  LET l_result2 = l_result2,g_sma.sma46,l_bom_str
                  LET l_sql = " SELECT agc01 FROM agc_file ",
                              "  WHERE agc01='",l_bom_str1,"'"
                  PREPARE i6001_tmp4 FROM l_sql
                  DECLARE tmp4_lcur CURSOR FOR i6001_tmp4
                  FOREACH tmp4_lcur INTO l_agc01
                     LET l_result = l_result,'#',l_agc01,'#|',l_bom_str,'|'
                  END FOREACH
               END IF
           END IF
        END FOR
        LET l_result = l_result.substring(1,length(l_result)-1)
        LET l_bma01 = g_bma.bma01

        #這里增加一個判斷，如果該多屬性子料件已經存在BOM并已經發放，則不允許后面的操作
        LET l_child = l_bma01 CLIPPED || l_result1.trim()
        SELECT COUNT(*) INTO l_n FROM bma_inplan WHERE bma01 = l_child AND NOT( bma05 IS NULL )
        IF l_n > 0 THEN
           CALL cl_err('','abm-989',1)
        ELSE
           CALL abmi600_2(l_bma01,l_result,l_result1,l_result2)  #這一句是原來的
        END IF

     END IF
     CLOSE WINDOW cl_fml_input_w2

END FUNCTION

FUNCTION preview_bom_test()
DEFINE
       l_sql       STRING      #NO.FUN-910082
DEFINE l_count    LIKE type_file.num5     #No.FUN-680096 SMALLINT

     SELECT count(*)
       INTO l_count
       FROM bmb_inplan
      WHERE bmb01 = g_bma.bma01
        AND bmb30='3'

    IF l_count = 0 THEN
        CALL cl_set_act_visible("preview_bom", FALSE)
    ELSE
       CALL preview_bom()
    END IF
END FUNCTION

#用于att01,att03...att19這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att19)
#如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#該函數從saxmt400的t400_check_att0x函數拷貝而來，因為只是單行輸入，且不需要合成
#imx_file資料，所以進行了相應簡化
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION i600_check_att0x(p_value,p_index)
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,       #No.FUN-680096  SMALLINT,
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,

  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE ima_file.ima130,   #No.FUN-680096  VARCHAR(1),
  l_ima131        LIKE ima_file.ima131,   #No.FUN-680096  VARCHAR(10),
  l_ima25         LIKE ima_file.ima25

  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由preview_bom()函數在窗體show出來之前填充

  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
  RETURN TRUE
END FUNCTION


FUNCTION i600_b_move_to()
   LET g_bmb[l_ac].bmb02 = b_bmb.bmb02
   LET g_bmb[l_ac].bmb30 = b_bmb.bmb30
   LET g_bmb[l_ac].bmb03 = b_bmb.bmb03
   LET g_bmb[l_ac].bmb09 = b_bmb.bmb09
   LET g_bmb[l_ac].bmb16 = b_bmb.bmb16
   LET g_bmb[l_ac].bmb14 = b_bmb.bmb14
   LET g_bmb[l_ac].bmb04 = b_bmb.bmb04
   LET g_bmb[l_ac].bmb05 = b_bmb.bmb05
   LET g_bmb[l_ac].bmb06 = b_bmb.bmb06
   LET g_bmb[l_ac].bmb07 = b_bmb.bmb07
   LET g_bmb[l_ac].bmb10 = b_bmb.bmb10
   LET g_bmb[l_ac].bmb08 = b_bmb.bmb08
   LET g_bmb[l_ac].bmb081 = b_bmb.bmb081   #No.FUN-A50089
   LET g_bmb[l_ac].bmb082 = b_bmb.bmb082   #No.FUN-A50089
   LET g_bmb[l_ac].bmb19 = b_bmb.bmb19
   LET g_bmb[l_ac].bmb24 = b_bmb.bmb24
   LET g_bmb[l_ac].bmb13 = b_bmb.bmb13
   LET g_bmb[l_ac].bmb31 = b_bmb.bmb31  #no.FUN-690019
   LET g_bmb[l_ac].bmb15 = b_bmb.bmb15   #add by donghy 161121
   LET g_bmb[l_ac].bmb36 = b_bmb.bmb36  #no.FUN-D10093 add
   LET g_bmb[l_ac].bmb37 = b_bmb.bmb37  #no.FUN-D10093 add
   LET g_bmb10_fac = b_bmb.bmb10_fac
   LET g_bmb10_fac2 = b_bmb.bmb10_fac2
   LET g_bmb11 = b_bmb.bmb11
   LET g_bmb15 = b_bmb.bmb15
   LET g_bmb17 = b_bmb.bmb17
   LET g_bmb18 = b_bmb.bmb18
   LET g_bmb23 = b_bmb.bmb23
   LET g_bmb27 = b_bmb.bmb27
   LET g_bmb28 = b_bmb.bmb28
   LET g_bmb[l_ac].bmbud01 = b_bmb.bmbud01
   LET g_bmb[l_ac].bmbud02 = b_bmb.bmbud02
   LET g_bmb[l_ac].bmbud03 = b_bmb.bmbud03
   LET g_bmb[l_ac].bmbud04 = b_bmb.bmbud04
   LET g_bmb[l_ac].bmbud05 = b_bmb.bmbud05
   LET g_bmb[l_ac].bmbud06 = b_bmb.bmbud06
   LET g_bmb[l_ac].bmbud07 = b_bmb.bmbud07
   LET g_bmb[l_ac].bmbud08 = b_bmb.bmbud08
   LET g_bmb[l_ac].bmbud09 = b_bmb.bmbud09
   LET g_bmb[l_ac].bmbud10 = b_bmb.bmbud10
   LET g_bmb[l_ac].bmbud11 = b_bmb.bmbud11
   LET g_bmb[l_ac].bmbud12 = b_bmb.bmbud12
   LET g_bmb[l_ac].bmbud13 = b_bmb.bmbud13
   LET g_bmb[l_ac].bmbud14 = b_bmb.bmbud14
   LET g_bmb[l_ac].bmbud15 = b_bmb.bmbud15
END FUNCTION

FUNCTION i600_b_move_back()
   LET b_bmb.bmb01  = g_bma.bma01


   LET b_bmb.bmb01      = g_bma.bma01
   LET b_bmb.bmb29      = g_bma.bma06
   LET b_bmb.bmb02      = g_bmb[l_ac].bmb02
   LET b_bmb.bmb03      = g_bmb[l_ac].bmb03
   LET b_bmb.bmb04      = g_bmb[l_ac].bmb04
   LET b_bmb.bmb05      = g_bmb[l_ac].bmb05
   LET b_bmb.bmb06      = g_bmb[l_ac].bmb06
   LET b_bmb.bmb07      = g_bmb[l_ac].bmb07
   LET b_bmb.bmb08      = g_bmb[l_ac].bmb08
   LET b_bmb.bmb081     = g_bmb[l_ac].bmb081           #No.FUN-A50089
   LET b_bmb.bmb082     = g_bmb[l_ac].bmb082           #No.FUN-A50089
   LET b_bmb.bmb09      = g_bmb[l_ac].bmb09
   LET b_bmb.bmb10      = g_bmb[l_ac].bmb10
   LET b_bmb.bmb10_fac  = g_bmb10_fac
   LET b_bmb.bmb10_fac2 = g_bmb10_fac2
   LET b_bmb.bmb11      = g_bmb11
   LET b_bmb.bmb13      = g_bmb[l_ac].bmb13
   LET b_bmb.bmb14      = g_bmb[l_ac].bmb14
   LET b_bmb.bmb15      = g_bmb15
   LET b_bmb.bmb16      = g_bmb[l_ac].bmb16
   LET b_bmb.bmb17      = g_bmb17
   LET b_bmb.bmb18      = g_bmb18
   LET b_bmb.bmb19      = g_bmb[l_ac].bmb19
   LET b_bmb.bmb20      = ''
   LET b_bmb.bmb21      = ''
   LET b_bmb.bmb22      = ''
   LET b_bmb.bmb23      = g_bmb23
   LET b_bmb.bmb24      = ''
   LET b_bmb.bmb25      = ''
   LET b_bmb.bmb26      = ''
   LET b_bmb.bmb27      = g_bmb27
   LET b_bmb.bmb28      = g_bmb28
   LET b_bmb.bmb30      = g_bmb[l_ac].bmb30
   LET b_bmb.bmb31      = g_bmb[l_ac].bmb31   #no.FUN-690019
   LET b_bmb.bmb15      = g_bmb[l_ac].bmb15   #add by donghy 161121
   LET b_bmb.bmb36      = g_bmb[l_ac].bmb36   #no.FUN-D10093 add
   LET b_bmb.bmb37      = g_bmb[l_ac].bmb37   #no.FUN-D10093 add
   LET b_bmb.bmbmodu    = g_user
   LET b_bmb.bmbdate    = g_today
   LET b_bmb.bmbcomm    = 'cbmi600'
   LET b_bmb.bmbud01 = g_bmb[l_ac].bmbud01
   LET b_bmb.bmbud02 = g_bmb[l_ac].bmbud02
   LET b_bmb.bmbud03 = g_bmb[l_ac].bmbud03
   LET b_bmb.bmbud04 = g_bmb[l_ac].bmbud04
   LET b_bmb.bmbud05 = g_bmb[l_ac].bmbud05
   LET b_bmb.bmbud06 = g_bmb[l_ac].bmbud06
   LET b_bmb.bmbud07 = g_bmb[l_ac].bmbud07
   LET b_bmb.bmbud08 = g_bmb[l_ac].bmbud08
   LET b_bmb.bmbud09 = g_bmb[l_ac].bmbud09
   LET b_bmb.bmbud10 = g_bmb[l_ac].bmbud10
   LET b_bmb.bmbud11 = g_bmb[l_ac].bmbud11
   LET b_bmb.bmbud12 = g_bmb[l_ac].bmbud12
   LET b_bmb.bmbud13 = g_bmb[l_ac].bmbud13
   LET b_bmb.bmbud14 = g_bmb[l_ac].bmbud14
   LET b_bmb.bmbud15 = g_bmb[l_ac].bmbud15
   IF cl_null(b_bmb.bmb29) THEN
      LET b_bmb.bmb29  = g_bma.bma06
   END IF

   IF cl_null(b_bmb.bmb29) THEN
      LET b_bmb.bmb29  = ' '
   END IF

   IF cl_null(b_bmb.bmb02)  THEN
      LET b_bmb.bmb02=' '
   END IF
END FUNCTION

FUNCTION i600_new_no(p_no)
   DEFINE p_no         LIKE ima_file.ima01
   DEFINE l_ima01      LIKE ima_file.ima01
   DEFINE l_ima08      LIKE ima_file.ima08
   DEFINE l_imaacti    LIKE ima_file.imaacti
   DEFINE l_ima1010    LIKE ima_file.ima1010

   LET l_ima01 = p_no

   SELECT imaacti,ima1010,ima08 INTO l_imaacti,l_ima1010,l_ima08 FROM ima_file
    WHERE ima01 = l_ima01
    CASE WHEN SQLCA.SQLCODE = 100        LET g_errno = 'mfg2602'
         WHEN l_imaacti='N'              LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'   LET g_errno = '9038'
         WHEN l_ima08='Z'                LET g_errno = 'mfg2752'
         OTHERWISE                       LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

#FUN-A70134--mark---str---
#FUNCTION i600_confirm()
#   DEFINE l_cnt   LIKE type_file.num5
#
#   IF s_shut(0) THEN RETURN END IF
#
#   IF cl_null(g_bma.bma01) THEN
#      CALL cl_err('','-400',0)
#      RETURN
#   END IF
#
#   SELECT * INTO g_bma.* FROM bma_inplan
#    WHERE bma01=g_bma.bma01
#      AND bma06=g_bma.bma06
#    IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
#       CALL cl_err(g_bma.bma08,'aoo-045',1)
#       RETURN
#    END IF
#
#   IF g_bma.bma10='1' THEN CALL cl_err('','9023',1) RETURN END IF
#   IF g_bma.bma10='2' THEN CALL cl_err('','abm-123',1) RETURN END IF
#
#   #---無單身資料不可確認
#   LET l_cnt=0
#   SELECT COUNT(*) INTO l_cnt
#     FROM bma_inplan
#    WHERE bma01=g_bma.bma01
#   IF l_cnt=0 OR l_cnt IS NULL THEN
#      CALL cl_err('','mfg-009',1)
#      RETURN
#   END IF
#
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#
#   BEGIN WORK
#
#   OPEN i600_cl USING g_bma.bma01,g_bma.bma06
#   IF STATUS THEN
#      CALL cl_err("OPEN i600_cl:", STATUS, 1)
#      CLOSE i600_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   FETCH i600_cl INTO g_bma.*               # 鎖住將被更改或取消的資料
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)          #資料被他人LOCK
#      CLOSE i600_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   IF g_bma.bma10 = '0' THEN
#      LET g_bma.bma10 = '1'
#      LET g_confirm = 'Y'
#   END IF
#
#   CALL i600_show()
#
#   IF INT_FLAG THEN                   #使用者不玩了
#      LET g_bma.bma10 ='0'
#      LET INT_FLAG = 0
#      DISPLAY By Name g_bma.bma10
#      CALL cl_err('',9001,0)
#      CLOSE i600_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   UPDATE bma_inplan
#      SET bma10 = g_bma.bma10
#    WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
#   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
#      CALL i600_show()
#      ROLLBACK WORK
#      RETURN
#   END IF
#   CLOSE i600_cl
#   COMMIT WORK
#END FUNCTION
#FUN-A70134--mark---end---

FUNCTION i600_unconfirm()

   IF cl_null(g_bma.bma01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   SELECT * INTO g_bma.* FROM bma_inplan
    WHERE bma01=g_bma.bma01
      AND bma06=g_bma.bma06

    IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
       CALL cl_err(g_bma.bma08,'aoo-045',1)
       RETURN
    END IF

   IF g_bma.bma10='0' THEN CALL cl_err('','9002',1)    RETURN END IF
   IF g_bma.bma10='2' THEN CALL cl_err('','aec-003',1) RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF

   BEGIN WORK
   OPEN i600_cl USING g_bma.bma01,g_bma.bma06
   IF STATUS THEN
      CALL cl_err("OPEN i600_cl:", STATUS, 1)
      CLOSE i600_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i600_cl INTO g_bma.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i600_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF g_bma.bma10 = '1' THEN
      LET g_bma.bma10 = '0'
      LET g_confirm='N'
   END IF

   CALL i600_show()

   UPDATE bma_inplan
      SET bma10 = g_bma.bma10,
          bmadate=g_today     #FUN-C40006 add
    WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
      CALL i600_show()
      ROLLBACK WORK
      RETURN
   END IF
   CLOSE i600_cl
   COMMIT WORK
END FUNCTION
FUNCTION i600_unrelease()
   DEFINE l_bmb01  LIKE bmb_inplan.bmb01 #MOD-4B0234
   DEFINE l_bmb02  LIKE bmb_inplan.bmb02 #MOD-4B0234
   DEFINE l_bmb03  LIKE bmb_inplan.bmb03 #MOD-4B0234
   DEFINE l_bmb04  LIKE bmb_inplan.bmb04 #MOD-4B0234
   DEFINE l_cnt    LIKE type_file.num5 #MOD-940191

   IF cl_null(g_bma.bma01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   SELECT * INTO g_bma.* FROM bma_inplan
    WHERE bma01=g_bma.bma01
      AND bma06=g_bma.bma06

   # 存在工單則不可發放還原
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt
      FROM sfb_file
     WHERE sfb05 = g_bma.bma01
       AND sfb95 = g_bma.bma06     #MOD-AA0042 add
       AND sfb87 != 'X'            #MOD-CB0227 add
    IF l_cnt >0 AND l_cnt IS NOT NULL THEN
       CALL cl_err("",'abm-840', 1)
       RETURN
    END IF

    IF NOT s_dc_ud_flag('2',g_bma.bma08,g_plant,'u') THEN
       CALL cl_err(g_bma.bma08,'aoo-045',1)
       RETURN
    END IF

   IF g_bma.bma10='0' THEN CALL cl_err('','aap-717',1)    RETURN END IF
   IF g_bma.bma10='1' THEN CALL cl_err('','amr-001',1) RETURN END IF
   IF cl_null(g_bma.bma05) THEN CALL cl_err('','amr-001',1)  RETURN END IF #MOD-840435
   IF NOT cl_confirm('axm_600') THEN RETURN END IF

   BEGIN WORK
   OPEN i600_cl USING g_bma.bma01,g_bma.bma06
   IF STATUS THEN
      CALL cl_err("OPEN i600_cl:", STATUS, 1)
      CLOSE i600_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i600_cl INTO g_bma.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i600_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF g_bma.bma10 = '2' THEN
      LET g_bma.bma10 = '1'
   END IF
   LET g_bma.bma05 = ' '
   CALL i600_show()
   UPDATE bma_inplan
      SET bma10 = g_bma.bma10,
          bma05 = NULL,#TQC-A60046
#         bma05 = ''   #TQC-A60046
          bmadate=g_today     #FUN-C40006 add
    WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
      CALL i600_show()
      ROLLBACK WORK
      RETURN
   END IF

   CLOSE i600_cl
   COMMIT WORK

END FUNCTION
FUNCTION i600_set_bmb30()
   DEFINE lcbo_target ui.ComboBox

   LET lcbo_target = ui.ComboBox.forName("bmb30")
   CALL lcbo_target.RemoveItem("2")
   CALL lcbo_target.RemoveItem("3")
END FUNCTION
FUNCTION i600_set_bmb30_1()
   DEFINE lcbo_target ui.ComboBox

   LET lcbo_target = ui.ComboBox.forName("bmb30")
   CALL lcbo_target.RemoveItem("4")
END FUNCTION

#FUN-B10013 ----------------------------Begin-----------------------------------
#FUNCTION i600_carry()
#   DEFINE l_i       LIKE type_file.num10
#   DEFINE l_j       LIKE type_file.num10
#   DEFINE l_sql     LIKE type_file.chr1000
#   DEFINE l_gew03   LIKE gew_file.gew03      #FUN-950057

#   IF cl_null(g_bma.bma01) THEN   #No.FUN-830090
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#   IF g_bma.bma10 <> '2' THEN
#      CALL cl_err(g_bma.bma01,'aoo-091',1)
#      RETURN
#   END IF

#   LET g_gev04 = NULL

#   #是否為資料中心的拋轉DB
#   SELECT gev04 INTO g_gev04 FROM gev_file
#    WHERE gev01 = '2' AND gev02 = g_plant
#      AND gev03 = 'Y'
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_gev04,'aoo-036',1)
#      RETURN
#   END IF

#   IF cl_null(g_gev04) THEN RETURN END IF

#   #FUN-950057 -----------------add start------------------------------------
#   SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file
#    WHERE gew01 = g_gev04 AND gew02 = '2'
#   IF NOT cl_null(l_gew03) THEN
#      IF l_gew03 = '2' THEN
#          IF NOT cl_confirm('anm-929') THEN RETURN END IF  #詢問是否執行拋轉
#      END IF
#   #FUN-950057 ----------------add end--------------------------------------

#   #開窗選擇拋轉的db清單
#   LET l_sql = "SELECT COUNT(*) FROM &bma_inplan WHERE bma01='",g_bma.bma01,"'",
#                                              "  AND bma06='",g_bma.bma06,"'"
#   CALL s_dc_sel_db1(g_gev04,'2',l_sql)
#   IF INT_FLAG THEN
#      LET INT_FLAG=0
#      RETURN
#   END IF

#   CALL g_bmax.clear()

#   LET g_bmax[1].sel = 'Y'
#   LET g_bmax[1].bma01 = g_bma.bma01
#   LET g_bmax[1].bma06 = g_bma.bma06
#   FOR l_i = 1 TO g_azp1.getLength()
#       LET g_azp[l_i].sel   = g_azp1[l_i].sel
#       LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
#       LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
#       LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
#   END FOR

#   CALL s_showmsg_init()
#   CALL s_abmi600_carry(g_bmax,g_azp,g_gev04,'0')  #No.FUN-830090
#   CALL s_showmsg()
# END IF            #FUN-950057 add

#END FUNCTION
#FUN-B10013 ----------------------------End-------------------------------------

FUNCTION i600_download()
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10
  DEFINE l_j          LIKE type_file.num10

   IF cl_null(g_bma.bma01) THEN   #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL g_bmax.clear()
   FOR l_i = 1 TO g_bma_l.getLength()
       LET g_bmax[l_i].sel   = 'Y'
       LET g_bmax[l_i].bma01 = g_bma_l[l_i].bma01_l
       LET g_bmax[l_i].bma06 = g_bma_l[l_i].bma06_l
   END FOR
   CALL s_abmi600_download(g_bmax)

END FUNCTION

FUNCTION i600_pic()
   DEFINE l_conf LIKE bma_inplan.bma10

   CASE
      WHEN g_bma.bmaacti='N'
         LET l_conf='N'
      WHEN cl_null(g_bma.bma10)
         IF cl_null(g_bma.bma05) THEN
            LET l_conf="N"
         ELSE
            LET l_conf="Y"
         END IF
      WHEN NOT cl_null(g_bma.bma10)
         CASE g_bma.bma10
            WHEN "0"
               LET l_conf="N"
         OTHERWISE
               LET l_conf="Y"
         END CASE
   END CASE
   CALL cl_set_field_pic(l_conf,"","","","",g_bma.bmaacti)

END FUNCTION

FUNCTION i600_bmb30(p_bmb30,p_bmb03)
DEFINE p_bmb30    LIKE bmb_inplan.bmb30,
       p_bmb03    LIKE bmb_inplan.bmb03,
       l_success  LIKE type_file.chr1,
       l_ima151   LIKE ima_file.ima151,
       r_ima151   LIKE ima_file.ima151

       LET l_success ='Y'

      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_bma.bma01
      SELECT ima151 INTO r_ima151 FROM ima_file WHERE ima01 = g_bmb[l_ac].bmb03
      IF l_ima151<>'Y' THEN
            IF g_bmb[l_ac].bmb30<>'1' OR  (NOT cl_null(r_ima151) AND r_ima151 = 'Y'  )THEN
              CALL cl_err('','abm-326',0)
              LET l_success = 'N'
              RETURN l_success
            END IF
      ELSE
          IF NOT cl_null(r_ima151) AND r_ima151 <> 'Y'  THEN
             IF g_bmb[l_ac].bmb30 = '4' THEN
                CALL cl_err('','abm-000',0)
                LET l_success ='N'
                RETURN l_success
             END IF
          ELSE
               IF g_bmb[l_ac].bmb30 = '1' THEN
                  CALL cl_err('','abm-325',0)
                  LET l_success ='N'
                  RETURN l_success
               END IF
           END IF
        END IF

       RETURN l_success
END FUNCTION

#根據不同的行業動態顯示按鈕名稱
FUNCTION i600_set_act_title(ps_act_names, pi_title)
   DEFINE   ps_act_names    STRING,
            pi_title        STRING
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING,
            lnode_root      om.DomNode,
            li_i            LIKE type_file.num5,
            lst_act_names   base.StringTokenizer,
            ls_act_name     STRING,
            llst_items      om.NodeList,
            li_j            LIKE type_file.num5,
            lnode_item      om.DomNode,
            ls_item_name    STRING,
            ls_item_tag     STRING

   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN
      RETURN
   END IF

   IF (ps_act_names IS NULL) THEN
      RETURN
   ELSE
      LET ps_act_names = ps_act_names.toLowerCase()
   END IF


   LET la_act_type[1] = "ActionDefault"
   LET la_act_type[2] = "LocalAction"
   LET la_act_type[3] = "Action"
   LET la_act_type[4] = "MenuAction"
   LET lnode_root = ui.Interface.getRootNode()
   FOR li_i = 1 TO la_act_type.getLength()
      LET lst_act_names = base.StringTokenizer.create(ps_act_names, ",")
      WHILE lst_act_names.hasMoreTokens()
         LET ls_act_name = lst_act_names.nextToken()
         LET ls_act_name = ls_act_name.trim()
         LET llst_items = lnode_root.selectByTagName(la_act_type[li_i])

         FOR li_j = 1 TO llst_items.getLength()
            LET lnode_item = llst_items.item(li_j)
            LET ls_item_name = lnode_item.getAttribute("name")
            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF

            IF (ls_item_name.equals(ls_act_name)) THEN
                CALL lnode_item.setAttribute("text",pi_title)
               EXIT FOR
            END IF
         END FOR
      END WHILE
   END FOR
END FUNCTION
#No:FUN-9C0077

###FUN-9A50010 START ###
##################################################
# Descriptions...: Tree填充
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_wc,p_pid,p_level,p_key1,p_key2
# Return code....:
##################################################
#FUNCTION i600_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2 )            #FUN-B90117
 FUNCTION i600_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_bma01)     #FUN-B90117
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_bma01            LIKE bma_inplan.bma01             #FUN-B90117
    DEFINE l_child          INTEGER
   DEFINE l_bma              DYNAMIC ARRAY OF RECORD
             bma01           LIKE bma_inplan.bma01,
             bmb03           LIKE bmb_inplan.bmb03,
             child_cnt       LIKE type_file.num5  #子節點數
             END RECORD
   DEFINE l_ima02            LIKE ima_file.ima02  #品名
   DEFINE l_bmb              DYNAMIC ARRAY OF RECORD
              bmb02           LIKE bmb_inplan.bmb02,   #MOD-CC0278 add
              bmb03           LIKE bmb_inplan.bmb03,
              ima02           LIKE ima_file.ima02,
              bmb06           LIKE bmb_inplan.bmb06,
              bmb07           LIKE bmb_inplan.bmb07,
              bmb10           LIKE bmb_inplan.bmb10
            #  child_cnt       LIKE type_file.num5
              END RECORD
  DEFINE  l_sql              STRING

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5



   LET max_level = 20 #設定最大階層數為20
   IF cl_null(p_wc) THEN LET p_wc = ' 1=1' END IF   #MOD-C70011 add

   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_bma.clear()


      #讓QBE出來的單頭都當作Tree的最上層
      IF l_ac = 0 THEN
          LET l_ac = 1
          LET l_sql = "SELECT DISTINCT bmb01,bmb01 as bmb03,COUNT(bmb03) as child_cnt FROM bmb_inplan,bma_inplan",
                  " WHERE ", p_wc CLIPPED,
                  " AND bmb01 = bma_inplan.bma01 ",
#                 " AND bma01= '",g_bma_l[l_ac].bma01_l CLIPPED,"'",             #FUN-B90117
                  " AND bma01= '",p_bma01 CLIPPED,"'",             #FUN-B90117
                  " AND bmb29 = bma06",                            #FUN-C20105                 
                  " GROUP BY bmb01",
                  " ORDER BY bmb01"
      ELSE

         LET l_sql = "SELECT DISTINCT bmb01,bmb01 as bmb03,COUNT(bmb03) as child_cnt FROM bmb_inplan,bma_inplan",
                  " WHERE ", p_wc CLIPPED,
                  " AND bmb01 = bma_inplan.bma01 ",
#                 " AND bma01= '",g_bma_l[l_ac].bma01_l CLIPPED,"'",             #FUN-B90117
                  " AND bma01= '",p_bma01 CLIPPED,"'",             #FUN-B90117
                  " AND bmb29 = bma06",                            #FUN-C20105                         
                  " GROUP BY bmb01",
                  " ORDER BY bmb01"

      END IF

      PREPARE i600_tree_pre1 FROM l_sql
      DECLARE i600_tree_cs1 CURSOR FOR i600_tree_pre1

      LET l_i = 1
      FOREACH i600_tree_cs1 INTO l_bma[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF

       IF g_tree_sel = '2' THEN    #FUN-B90117
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開
         LET l_ima02 = NULL
         SELECT ima02 INTO l_ima02 FROM ima_file
            WHERE ima01 = l_bma[l_i].bma01
         LET g_tree[g_idx].name = get_field_name("bma01"),":",l_bma[l_i].bma01,
                                 "(",get_field_name("ima02"),":",l_ima02,")"
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = l_bma[l_i].bmb03
         LET g_tree[g_idx].treekey1 = l_bma[l_i].bma01
         LET g_tree[g_idx].treekey2 = l_bma[l_i].bmb03
        # 有子節點
         IF l_bma[l_i].child_cnt > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
#           CALL i600_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2) #FUN-B90117
            CALL i600_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_bma[l_i].bma01) #FUN-B90117
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF
       END IF       #FUN-B90117

#FUN-B90117--BEGIN--
       IF g_tree_sel='1' THEN
         LET g_idx = g_idx + 1
         LET g_tree1[g_idx].pid1 = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree1[g_idx].id1 = l_str
         LET g_tree1[g_idx].expanded1 = TRUE    #TRUE:展開, FALSE:不展開
         LET l_ima02 = NULL
         SELECT ima02 INTO l_ima02 FROM ima_file
            WHERE ima01 = l_bma[l_i].bma01
         LET g_tree1[g_idx].name1 = l_bma[l_i].bma01,
                                 "(",get_field_name("ima02"),":",l_ima02,")"
         LET g_tree1[g_idx].level1 = p_level
         LET g_tree1[g_idx].path1 = l_bma[l_i].bmb03
         LET g_tree1[g_idx].treekey3 = l_bma[l_i].bma01
         LET g_tree1[g_idx].treekey4 = l_bma[l_i].bmb03
#FUN-CB0078 ------Begin------
#FUN-C20105 --unmark begin--         
#        IF g_lock='Y' THEN
#           LET g_tree1[g_idx].img = "lock.png"
#        ELSE
#           LET g_tree1[g_idx].img = " "
#        END IF
#FUN-C20105 --unmark end--
#FUN-CB0078 ------End--------

        # 有子節點
         IF l_bma[l_i].child_cnt > 0 THEN
            LET g_tree1[g_idx].has_children1 = TRUE
            CALL i600_tree_fill(p_wc,g_tree1[g_idx].id1,p_level,g_tree1[g_idx].path1,g_tree1[g_idx].treekey3,g_tree1[g_idx].treekey4,l_bma[l_i].bma01)
         ELSE
            LET g_tree1[g_idx].has_children1 = FALSE
         END IF
       END IF
#FUN-B90117 --END--

         LET l_i = l_i + 1
      END FOREACH

   ELSE
#   IF p_level =1 THEN                  #FUN-B90117
    IF p_level <= 20 THEN               #FUN-B90117
      LET p_level = p_level + 1   #下一階層
      IF p_level > max_level THEN
         CALL cl_err_msg("","agl1001",max_level,0)
         RETURN
      END IF

       #LET l_sql = "SELECT UNIQUE bmb03,ima02,bmb06,bmb07,bmb10 ",
        LET l_sql = "SELECT UNIQUE bmb02,bmb03,ima02,bmb06,bmb07,bmb10 ",   #MOD-CC0278 add bmb02
#                   " FROM  bmb_inplan LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",   #FUN-C20105 
                    " FROM  bma_inplan,bmb_inplan LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",   #FUN-C20105                     
                    "WHERE  bmb01 = '", p_key1 CLIPPED,"'",
                    " AND bma06 = '",g_bma.bma06,"'",                #MOD-D20147
                    " AND bmb29 = bma06",                            #FUN-C20105                    
                    " AND bmb01 = bma01",                            #FUN-C20105                     
                   # " GROUP BY bmb03",
                   #" ORDER BY bmb03"
                    " ORDER BY bmb02"   #MOD-CC0278 bmb03 -> bmb02
###No.FUN-A50010 by dxfwo ####
       IF NOT cl_null(g_vdate) THEN  #FUN-A50010
       #LET l_sql = "SELECT UNIQUE bmb03,ima02,bmb06,bmb07,bmb10 ",
        LET l_sql = "SELECT UNIQUE bmb02,bmb03,ima02,bmb06,bmb07,bmb10 ",   #MOD-CC0278 add bmb02
#                   " FROM bmb_inplan LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",   #FUN-C20105 
                    " FROM bma_inplan,bmb_inplan LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",   #FUN-C20105 
                    "WHERE  bmb01 = '", p_key1 CLIPPED,"'",
                    "  AND  bma06 =  '",g_bma.bma06,"'",                        #MOD-D20147
                    "  AND (bmb04 <='", g_vdate,"'"," OR bmb04 IS NULL )",
                    "  AND (bmb05 >  '",g_vdate,"'"," OR bmb05 IS NULL )",
                    " AND bmb29 = bma06",                            #FUN-C20105     
                    " AND bmb01 = bma01",                            #FUN-C20105                      
                   #" ORDER BY bmb03"
                    " ORDER BY bmb02"   #MOD-CC0278 bmb03 -> bmb02
       END IF
###No.FUN-A50010####
      PREPARE i600_tree_pre2 FROM l_sql
      DECLARE i600_tree_cs2 CURSOR FOR i600_tree_pre2

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_bmb.clear()
      FOREACH i600_tree_cs2 INTO l_bmb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_bmb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
          IF g_tree_sel = '2' THEN   #FUN-B90117
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
            --SELECT ima02 INTO l_ima02 FROM ima_file
            --WHERE ima01 = l_bmb[l_i].bmb01 AND imaacti='Y'
            LET g_tree[g_idx].name = get_field_name("bmb03"),":",l_bmb[l_i].bmb03,
                                     "(",get_field_name("ima02"),":",l_bmb[l_i].ima02,
                                     "):",get_field_name("bmb06"),":",l_bmb[l_i].bmb06,
                                     "/",get_field_name("bmb07"),":",l_bmb[l_i].bmb07,
                                     " ",get_field_name("bmb10"),":",l_bmb[l_i].bmb10

            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_bmb[l_i].bmb03
            LET g_tree[g_idx].treekey1 = l_bma[l_i].bma01
            LET g_tree[g_idx].treekey2 = l_bmb[l_i].bmb03
            #有子節點
            IF NOT cl_null(g_vdate) THEN                   #MOD-D20147
               SELECT COUNT(bmb03) INTO l_child FROM bmb_inplan WHERE bmb01 = l_bmb[l_i].bmb03
               AND (bmb04 <= g_vdate OR bmb04 IS NULL )  #FUN-B90117
               AND (bmb05 >g_vdate OR bmb05 IS NULL )    #FUN-B90117
          #MOD-D20147-add-start      
            ELSE  
                SELECT COUNT(bmb03) INTO l_child FROM bmb_inplan
                WHERE bmb01 = l_bmb[l_i].bmb03
                AND (bmb04 <= g_today OR bmb04 IS NULL )  
                AND (bmb05 >g_today OR bmb05 IS NULL )    
            END IF
          #MOD-D20147-add-end    

            IF l_child > 0 AND p_level <= max_level THEN #TQC-C60239
               LET g_tree[g_idx].has_children = TRUE
               CALL i600_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
            END IF
           END IF       #FUN-B90117

#FUN-B90117--begin--
          IF  g_tree_sel='1' THEN
            LET g_idx = g_idx + 1
            LET g_tree1[g_idx].pid1 = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree1[g_idx].id1 = g_tree1[g_idx].pid1,".",l_str
            LET g_tree1[g_idx].expanded1 = TRUE   #TRUE:展開, FALSE:不展開
            --SELECT ima02 INTO l_ima02 FROM ima_file
            --WHERE ima01 = l_bmb[l_i].bmb01 AND imaacti='Y'
            LET g_tree1[g_idx].name1 = l_bmb[l_i].bmb03,
                                     "(",get_field_name("ima02"),":",l_bmb[l_i].ima02,")"

            LET g_tree1[g_idx].s1=l_bmb[l_i].bmb06
            LET g_tree1[g_idx].s2=l_bmb[l_i].bmb07
            LET g_tree1[g_idx].s3=l_bmb[l_i].bmb10
            LET g_tree1[g_idx].level1 = p_level
            LET g_tree1[g_idx].path1 = p_path CLIPPED,".",l_bmb[l_i].bmb03
            LET g_tree1[g_idx].treekey3 = l_bma[l_i].bma01
            LET g_tree1[g_idx].treekey4 = l_bmb[l_i].bmb03
            #有子節點
            IF NOT cl_null(g_vdate) THEN                   #MOD-D20147
               SELECT COUNT(bmb03) INTO l_child FROM bmb_inplan WHERE bmb01 = l_bmb[l_i].bmb03
               AND (bmb04 <= g_vdate OR bmb04 IS NULL )
               AND (bmb05 >g_vdate OR bmb05 IS NULL )
        #MOD-D20147-add-start      
            ELSE  
                SELECT COUNT(bmb03) INTO l_child FROM bmb_inplan
                WHERE bmb01 = l_bmb[l_i].bmb03
                AND (bmb04 <= g_today OR bmb04 IS NULL )  
                AND (bmb05 >g_today OR bmb05 IS NULL )    
            END IF
        #MOD-D20147-add-end 


            IF l_child > 0 AND p_level <= max_level THEN #TQC-C60239
               LET g_tree1[g_idx].has_children1 = TRUE
               CALL i600_tree_fill2(p_wc,g_tree1[g_idx].id1,p_level,g_tree1[g_idx].path1,g_tree1[g_idx].treekey3,g_tree1[g_idx].treekey4)
            ELSE
               LET g_tree1[g_idx].has_children1 = FALSE
            END IF
           END IF
#FUN-B90117--end--
          END FOR
      END IF

      END IF
   END IF
END FUNCTION

##################################################
# Descriptions...: Tree填充
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_wc,p_pid,p_level,p_key1,p_key2
# Return code....:
##################################################
FUNCTION  i600_tree_fill2(p_wc,p_pid,p_level,p_path,p_key1,p_key2 )
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_child            INTEGER
   DEFINE l_bmb              DYNAMIC ARRAY OF RECORD
              bmb03           LIKE bmb_inplan.bmb03,
              ima02           LIKE ima_file.ima02,
              bmb06           LIKE bmb_inplan.bmb06,
              bmb07           LIKE bmb_inplan.bmb07,
              bmb10           LIKE bmb_inplan.bmb10
           #  child_cnt       LIKE type_file.num5
              END RECORD
  DEFINE  l_sql              STRING

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5

   LET max_level = 20 #設定最大階層數為20  #TQC-C60239
#  LET p_level =3           #FUN-B90117
   LET p_level = p_level+1  #FUN-B90117

   #TQC-C60239--add--str--
   IF p_level > max_level THEN
      CALL cl_err_msg("","mfg-087",max_level,1)
      RETURN
   END IF
   #TQC-C60239--add--end--

   LET l_sql = "SELECT UNIQUE bmb03,ima02,bmb06,bmb07,bmb10 ",
                " FROM bmb_inplan LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",
                "WHERE  bmb01 = '", p_key2 CLIPPED,"'",
              # " GROUP BY bmb03",
                " ORDER BY bmb03"

###No.FUN-A50010 by dxfwo ####
   IF NOT cl_null(g_vdate) THEN  #FUN-A50010
      LET l_sql = "SELECT UNIQUE bmb03,ima02,bmb06,bmb07,bmb10 ",
                   " FROM bmb_inplan LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",
                   "WHERE  bmb01 = '", p_key2 CLIPPED,"'",
                   "  AND (bmb04 <='", g_vdate,"'"," OR bmb04 IS NULL )",
                   "  AND (bmb05 >  '",g_vdate,"'"," OR bmb05 IS NULL )",
                   " ORDER BY bmb03"

   END IF
###No.FUN-A50010####

    PREPARE i600_tree_pre3 FROM l_sql
    DECLARE i600_tree_cs3 CURSOR FOR i600_tree_pre3

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
   LET l_cnt = 1
   CALL l_bmb.clear()
   FOREACH i600_tree_cs3 INTO l_bmb[l_cnt].*
     IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
     END IF
         LET l_cnt = l_cnt + 1
   END FOREACH
     CALL l_bmb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
     LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
           IF g_tree_sel = '2' THEN     #FUN-B90117
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開
            --SELECT ima02 INTO l_ima02 FROM ima_file
            --WHERE ima01 = l_bmb[l_i].bmb01 AND imaacti='Y'
            LET g_tree[g_idx].name = get_field_name("bmb03"),l_bmb[l_i].bmb03,
                                    "(",get_field_name("ima02"),":",l_bmb[l_i].ima02,
                                    "):",get_field_name("bmb06"),":",l_bmb[l_i].bmb06,
                                    "/",get_field_name("bmb07"),":",l_bmb[l_i].bmb07,
                                    "  ",get_field_name("bmb10"),":",l_bmb[l_i].bmb10
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_bmb[l_i].bmb03
            --LET g_tree[g_idx].treekey1 = l_bma[l_i].bma01
            LET g_tree[g_idx].treekey2 = l_bmb[l_i].bmb03

#FUN-B90117 --BEGIN--
            IF NOT cl_null(g_vdate) THEN                   #MOD-D20147
               SELECT COUNT(bmb03) INTO l_child FROM bmb_inplan WHERE bmb01 = l_bmb[l_i].bmb03
               AND (bmb04 <= g_vdate OR bmb04 IS NULL )
               AND (bmb05 >g_vdate OR bmb05 IS NULL )
         #MOD-D20147-add-start      
            ELSE  
                SELECT COUNT(bmb03) INTO l_child FROM bmb_inplan
                WHERE bmb01 = l_bmb[l_i].bmb03
                AND (bmb04 <= g_today OR bmb04 IS NULL )  
                AND (bmb05 >g_today OR bmb05 IS NULL )    
            END IF
        #MOD-D20147-add-end 
            IF l_child > 0 AND p_level <= max_level THEN #TQC-C60239
               LET g_tree[g_idx].has_children = TRUE
               CALL i600_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
            END IF
           END IF

         IF g_tree_sel='1' THEN
            LET g_idx = g_idx + 1
            LET g_tree1[g_idx].pid1 = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree1[g_idx].id1 = g_tree1[g_idx].pid1,".",l_str
            LET g_tree1[g_idx].expanded1 = TRUE    #TRUE:展開, FALSE:不展開
           #SELECT ima02 INTO l_ima02 FROM ima_file
           # WHERE ima01 = l_bmb[l_i].bmb01 AND imaacti='Y'
            LET g_tree1[g_idx].name1 = l_bmb[l_i].bmb03,
                                    "(",get_field_name("ima02"),":",l_bmb[l_i].ima02,")"

            LET g_tree1[g_idx].s1=l_bmb[l_i].bmb06
            LET g_tree1[g_idx].s2=l_bmb[l_i].bmb07
            LET g_tree1[g_idx].s3=l_bmb[l_i].bmb10

            LET g_tree1[g_idx].level1 = p_level
            LET g_tree1[g_idx].path1 = p_path CLIPPED,".",l_bmb[l_i].bmb03
            #LET g_tree[g_idx].treekey1 = l_bma[l_i].bma01
            LET g_tree1[g_idx].treekey4 = l_bmb[l_i].bmb03
            
            IF NOT cl_null(g_vdate) THEN                   #MOD-D20147
               SELECT COUNT(bmb03) INTO l_child FROM bmb_inplan WHERE bmb01 = l_bmb[l_i].bmb03
               AND (bmb04 <= g_vdate OR bmb04 IS NULL )
               AND (bmb05 >g_vdate OR bmb05 IS NULL )
        #MOD-D20147-add-start      
            ELSE  
                SELECT COUNT(bmb03) INTO l_child FROM bmb_inplan
                WHERE bmb01 = l_bmb[l_i].bmb03
                AND (bmb04 <= g_today OR bmb04 IS NULL )  
                AND (bmb05 >g_today OR bmb05 IS NULL )    
            END IF
        #MOD-D20147-add-end 

            IF l_child > 0 AND p_level <= max_level THEN #TQC-C60239
               LET g_tree1[g_idx].has_children1 = TRUE
               CALL i600_tree_fill2(p_wc,g_tree1[g_idx].id1,p_level,g_tree1[g_idx].path1,g_tree1[g_idx].treekey3,g_tree1[g_idx].treekey4)
            ELSE
               LET g_tree1[g_idx].has_children1 = FALSE
            END IF
           END IF
#FUN-B90117--END--
         END FOR
      END IF

END FUNCTION



##################################################
# Descriptions...: 依tree path指定focus節點
# Date & Author..: 10/05/05 By huangtao
# Input Parameter:
# Return code....:
##################################################
FUNCTION i600_tree_idxbypath()
   DEFINE l_i       LIKE type_file.num5

   LET g_tree_focus_idx = 1
   FOR l_i = 1 TO g_tree.getlength()
      IF g_tree[l_i].path = g_tree_focus_path THEN
            LET g_tree_focus_idx = l_i
            EXIT FOR
      END IF
   END FOR
END FUNCTION

##################################################
# Descriptions...: 展開節點
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_idx
# Return code....:
##################################################
FUNCTION i600_tree_open(p_idx)
   DEFINE p_idx        LIKE type_file.num10  #index
   DEFINE l_pid        STRING                #父節id
   DEFINE l_openpidx   LIKE type_file.num10  #展開父index
   DEFINE l_arrlen     LIKE type_file.num5   #array length
   DEFINE l_i          LIKE type_file.num5

   LET l_openpidx = 0
   LET l_arrlen = g_tree.getLength()

   IF p_idx > 0 THEN
      IF g_tree[p_idx].has_children THEN
         LET g_tree[p_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
      END IF
      LET l_pid = g_tree[p_idx].pid
      IF p_idx > 1 THEN
         #找父節點的index
         FOR l_i=p_idx TO 1 STEP -1
            IF g_tree[l_i].id = l_pid THEN
               LET l_openpidx = l_i
               EXIT FOR
            END IF
         END FOR
         #展開父節點
         IF (l_openpidx > 0) AND (NOT cl_null(g_tree[p_idx].path)) THEN
            CALL i600_tree_open(l_openpidx)
         END IF
      END IF
   END IF
END FUNCTION


##################################################
# Descriptions...: 檢查是否為無窮迴圈
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_key1,p_addkey2,p_flag
# Return code....: l_loop
##################################################
#TQC-C60231  #此函數修改為檢測主件料號是否存在于元件料號下階
FUNCTION i600_tree_loop(p_key1,p_addkey2,p_flag)
   DEFINE p_key1             STRING
   DEFINE p_addkey2          STRING               #要增加的節點key2
   DEFINE p_flag             LIKE type_file.chr1  #是否已跑遞迴
   DEFINE l_bmb              DYNAMIC ARRAY OF RECORD
              bmb03           LIKE bmb_inplan.bmb03,
              ima02           LIKE ima_file.ima02,
              bmb06           LIKE bmb_inplan.bmb06,
              bmb07           LIKE bmb_inplan.bmb07,
              bmb10           LIKE bmb_inplan.bmb10
            #  child_cnt       LIKE type_file.num5
              END RECORD
   DEFINE l_child            INTEGER
   DEFINE l_ima02            LIKE ima_file.ima02  #部門名稱
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_loop             LIKE type_file.chr1  #是否為無窮迴圈Y/N

   IF cl_null(p_flag) THEN   #第一次進遞迴
      LET g_idx = 1
      LET g_path_add[g_idx] = p_addkey2  
      #TQC-C60231--add--str--   #如果主料與元料相同
      IF g_path_add[g_idx] = p_key1 THEN 
         LET l_loop = "Y"
         RETURN l_loop
      END IF
      #TQC-C60231--add--end--
   END IF
   LET p_flag = "Y"
   IF cl_null(l_loop) THEN
      LET l_loop = "N"
   END IF

   IF NOT cl_null(p_addkey2) THEN
      LET g_sql = "SELECT UNIQUE bmb03,ima02,bmb06,bmb07,bmb10 ",
                    " FROM bmb_inplan LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",
                   # "WHERE  bmb01 = '", p_key1 CLIPPED,"'",    #TQC-C60231 mark
                    "WHERE  bmb01 = '", p_addkey2 CLIPPED,"'",  #TQC-C60231 add
                   # " GROUP BY bmb03",
                    " ORDER BY bmb03"
      PREPARE i600_tree_pre4 FROM g_sql
      DECLARE i600_tree_cs4 CURSOR FOR i600_tree_pre4

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_bmb.clear()
      FOREACH i600_tree_cs4 INTO l_bmb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_bmb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_path_add[g_idx] = l_bmb[l_i].bmb03
            IF g_path_add[g_idx] = p_key1 THEN
               LET l_loop = "Y"
               RETURN l_loop
            END IF
            #有子節點
            #TQC-A60039 mark---start--- #TQC-C60231  remark
            SELECT COUNT(bmb03) INTO l_child FROM bmb_inplan WHERE bmb01 = l_bmb[l_i].bmb03
            IF l_child > 0 THEN
               CALL i600_tree_loop(p_key1,l_bmb[l_i].bmb03,p_flag) RETURNING l_loop
               IF l_loop = 'Y' THEN RETURN l_loop END IF           #TQC-C60231 add 
            END IF
            #TQC-A60039 mark---end---   #TQC-C60231  remark
          END FOR
      END IF
   END IF
   RETURN l_loop
END FUNCTION


##################################################
# Descriptions...: 異動Tree資料
# Date & Author..: 10/05/05 By huangtao
# Input Parameter:
# Return code....:
##################################################
FUNCTION i600_tree_update()

   #Tree重查並展開focus節點
   LET g_tree_sel='2'              #FUN-B90117
#  CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL) #Tree填充          #FUN-B90117
#  CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,NULL) #Tree填充     #FUN-B90117   #MOD-C70011 mark
   CALL i600_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma.bma01) #Tree填充  #MOD-C70011  
   CALL i600_tree_idxbypath()                        #依tree path指定focus節點
   CALL i600_tree_open(g_tree_focus_idx)             #展開節點
   #復原cursor，上下筆的按鈕才可以使用
   IF g_tree[g_tree_focus_idx].level = 1 THEN
      LET g_tree_b = "N"
   #更新focus節點的單頭和單身
   ELSE
      LET g_tree_b = "Y"
   END IF
   #CALL i600_q(g_tree_focus_idx)
END FUNCTION
###FUN-9A50010 END ###

##################################################
# Descriptions...: 依key指定focus節點
##################################################
FUNCTION i600_tree_idxbykey()   #No.FUN-A30120 add by tommas  fetch單頭後，利用g_abd01來搜尋該資料目前位於g_tree的哪個索引中。
   DEFINE l_idx   INTEGER
   LET g_tree_focus_idx = 1
   FOR l_idx = 1 TO g_tree.getLength()
      IF ( g_tree[l_idx].level == 1 ) AND ( g_tree[l_idx].treekey2 == g_bma.bma01 ) CLIPPED THEN  # 尋找節點
         LET g_tree[l_idx].expanded = TRUE
         LET g_tree_focus_idx = l_idx
      END IF
   END FOR
END FUNCTION

##################################################
# Descriptions...: 顯示圖片
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_idx
# Return code....:
##################################################
FUNCTION i600_show_pic(p_idx)
    DEFINE p_idx  LIKE type_file.num5
    DEFINE l_wc   STRING
    DEFINE p_ima04 LIKE ima_file.ima04


    LET g_doc.column1 = "ima01"
    LET g_doc.value1 = g_tree[p_idx].treekey2
    CALL cl_get_fld_doc("ima04")


END FUNCTION
##################################################
# Descriptions...: 顯示字段名稱
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_field_code
# Return code....:
##################################################
FUNCTION get_field_name(p_field_code)
   DEFINE p_field_code STRING
   DEFINE l_sql        STRING,
          l_gaq03      LIKE gaq_file.gaq03

   LET l_sql = "SELECT gaq03 FROM gaq_file",
               " WHERE gaq01='",p_field_code,"' AND gaq02='",g_lang,"'"
   DECLARE gaq_curs SCROLL CURSOR FROM l_sql
   OPEN gaq_curs
   FETCH FIRST gaq_curs INTO l_gaq03
   CLOSE gaq_curs

   RETURN l_gaq03 CLIPPED
END FUNCTION

#No.MOD-A70036  --Begin
FUNCTION i600_bmd()

   #delete 取替代性质为0的bmd_file资料
   DELETE FROM bmd_file
    WHERE bmd08 = g_bma.bma01
      AND bmd01 IN (SELECT UNIQUE bmb03 FROM bmb_inplan
                     WHERE bmb01 = g_bma.bma01
                       AND bmb29 = g_bma.bma06
                       AND bmb16 = '0')
   IF SQLCA.sqlcode THEN
      CALL cl_err3('upd','bmd_file',g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,'','del bmd',1)
   END IF


   #delete 当前主件,但不在bmb_inplan中的bmd_file资料
   DELETE FROM bmd_file
    WHERE bmd08 = g_bma.bma01
      AND bmd01 NOT IN (SELECT UNIQUE bmb03 FROM bmb_inplan
                         WHERE bmb01 = g_bma.bma01
                           AND bmb29 = g_bma.bma06)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('upd','bmd_file',g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,'','del bmd',1)
   END IF

END FUNCTION
#No.MOD-A70036  --End
#str----add by guanyao160811
FUNCTION i600_out1()
   DEFINE l_cmd     LIKE type_file.chr1000
   DEFINE l_wc     STRING 
   
    IF cl_null(g_bma.bma01) THEN 
       RETURN 
    END IF 
    LET l_wc = 'bma01 = "',g_bma.bma01,'"'
    LET l_cmd = 'cbmr002',
                       " '",g_today CLIPPED,"' ''",
                       " '",g_lang CLIPPED,"' '",g_bgjob CLIPPED,"'  '' '1'",
                       " '",l_wc CLIPPED,"' '' 'N' '' '' "   
    CALL cl_cmdrun(l_cmd)
END FUNCTION  
#end----add by guanyao160811

#No:FUN-B70096 --START--
FUNCTION i600_out()
DEFINE l_bma DYNAMIC ARRAY OF RECORD
          bma01   LIKE bma_inplan.bma01,
          bma06   LIKE bma_inplan.bma06,
          ima02   LIKE ima_file.ima02,
          ima55   LIKE ima_file.ima55
       END RECORD
DEFINE l_bma_b DYNAMIC ARRAY OF RECORD
          bma01   LIKE bma_inplan.bma01,
          bma06   LIKE bma_inplan.bma06,        #CHI-C90013 add,
          p_id    LIKE type_file.num10        #CHI-C90013 add
       END RECORD
DEFINE l_bmb DYNAMIC ARRAY OF RECORD
          bmb01   LIKE bmb_inplan.bmb01,
          bmb02   LIKE bmb_inplan.bmb02,
          bmb03   LIKE bmb_inplan.bmb03,
          ima02   LIKE ima_file.ima02,
          bmb09   LIKE bmb_inplan.bmb09,
          bmb06   LIKE bmb_inplan.bmb06,
          bmb07   LIKE bmb_inplan.bmb07,
          bmb10   LIKE bmb_inplan.bmb10,
          ima910  LIKE ima_file.ima910
       END RECORD
DEFINE l_n        LIKE type_file.num5
DEFINE l_n2       LIKE type_file.num5
DEFINE l_n3       LIKE type_file.num5
DEFINE l_bh_cnt   LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_id       LIKE type_file.num10        #CHI-C90013 add
DEFINE p_id       LIKE type_file.num10        #CHI-C90013 add


   IF g_wc IS NULL OR g_wc2 IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF

   CALL cl_wait()

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,? ,?,? ,?,? ,?,? ,?,? ,?,?   ,?,?) "         #CHI-C90013 add ,?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90042
      EXIT PROGRAM
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?) "                                       #CHI-C90013 add ,? 
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90042
      EXIT PROGRAM
   END IF

   #第一層
   #抓主件
   LET g_sql="SELECT UNIQUE bma01,bma06,ima02,ima55",
             " FROM bma_inplan, bmb_inplan,ima_file",
             " WHERE bma01 = bmb01",
             " AND bma01 = ima01",
             " AND bma06 = bmb29",
             " AND ",g_wc CLIPPED,
             " AND ",g_wc2 CLIPPED,
             " ORDER BY bma01,bma06 "

   PREPARE i600_p1 FROM g_sql
   DECLARE i600_c1 CURSOR FOR i600_p1

   CALL cl_del_data(l_table)

   LET l_n = 1

   FOREACH i600_c1 INTO l_bma[l_n].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET l_id = 1          #CHI-C90013 add
       LET p_id = NULL       #CHI-C90013 add
       #主件本身加一筆RECORD
       EXECUTE insert_prep USING l_bma[l_n].bma01,l_bma[l_n].bma01
                                      ,l_bma[l_n].ima02,l_bma[l_n].bma06
                                      ,l_bma[l_n].ima55,'0'
                                      ,l_bma[l_n].bma01,l_bma[l_n].ima02
                                      ,'','1' 
                                      ,'1',l_bma[l_n].ima55,l_id,p_id       #CHI-C90013 add ,l_id,p_id
 
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL cl_del_data(l_table2)   #清除TEMP
       EXECUTE insert_prep2 USING l_bma[l_n].bma01,l_bma[l_n].bma06,l_id   #TEMP記錄第一層主件   #CHI-C90013 add ,l_id
       WHILE TRUE
          #下一層主件
          LET g_sql = "select bma01,bma06,id from ", g_cr_db_str CLIPPED, l_table2 CLIPPED       #CHI-C90013 add ,id
          PREPARE i600_p3 FROM g_sql
          DECLARE i600_c3 CURSOR FOR i600_p3

          LET l_n3 = 1
          CALL l_bma_b.CLEAR()
          FOREACH i600_c3 INTO l_bma_b[l_n3].bma01,l_bma_b[l_n3].bma06,l_bma_b[l_n3].p_id    #CHI-C90013 ,p_id
             IF SQLCA.sqlcode THEN
                CALL cl_err('Foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             LET l_n3 = l_n3 + 1
          END FOREACH
          CALL l_bma_b.deleteElement(l_n3)
          LET l_n3 = l_n3 - 1
          IF l_n3 < 1 THEN EXIT WHILE END IF

          CALL cl_del_data(l_table2)   #清除TEMP
          FOR l_bh_cnt = 1 TO l_n3
             #下一層主件主件下的元件
             LET g_sql = "SELECT bmb01,bmb02,bmb03,ima02,bmb09,bmb06,bmb07,bmb10,ima910",
                         " FROM bmb_inplan,ima_file",
                         " WHERE bmb01 ='", l_bma_b[l_bh_cnt].bma01 ,"'",
                         " AND bmb29 ='", l_bma_b[l_bh_cnt].bma06, "' ",
                         " AND bmb_inplan.bmb03 = ima_file.ima01 ",
                         " AND bmb06 <> 0 ",
                         " AND ",g_wc2 CLIPPED

             IF g_sma.sma118 = 'Y' THEN      #特性碼
                LET g_sql = g_sql," AND bmb29 ='", l_bma_b[l_bh_cnt].bma06 ,"' "
             ELSE
                LET g_sql = g_sql," AND bmb29 =' ' "
             END IF

             PREPARE i600_p2 FROM g_sql
             DECLARE i600_c2 CURSOR FOR i600_p2

             LET l_n2 = 1

             FOREACH i600_c2 INTO l_bmb[l_n2].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('Foreach:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                END IF
                LET   l_id = l_id +1         #CHI-C90013 add
                EXECUTE insert_prep USING l_bma[l_n].bma01,l_bmb[l_n2].bmb01,' '
                                            ,l_bma[l_n].bma06,' '
                                            ,l_bmb[l_n2].bmb02,l_bmb[l_n2].bmb03
                                            ,l_bmb[l_n2].ima02,l_bmb[l_n2].bmb09
                                            ,l_bmb[l_n2].bmb06,l_bmb[l_n2].bmb07
                                            ,l_bmb[l_n2].bmb10,l_id,l_bma_b[l_bh_cnt].p_id    #CHI-C90013 add l_id,l_bma_b[l_bh_cnt].p_id 
                EXECUTE insert_prep2 USING l_bmb[l_n2].bmb03,l_bmb[l_n2].ima910,l_id  #TEMP記錄下一層主件        #CHI-C90013 add l_id
                LET l_n2 = l_n2 + 1
             END FOREACH
          END FOR
       END WHILE
       LET l_n = l_n + 1
    END FOREACH
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('cbmi600','cbmi600',l_sql,g_str)
END FUNCTION
#No:FUN-B70096 --END--

#FUN-910088--add--start--
FUNCTION i600_bmb081_check()
   IF NOT cl_null(g_bmb[l_ac].bmb081) AND NOT cl_null(g_bmb[l_ac].bmb10) THEN
      IF cl_null(g_bmb10_t) OR cl_null(g_bmb_t.bmb081) OR g_bmb10_t != g_bmb[l_ac].bmb10 OR g_bmb_t.bmb081 != g_bmb[l_ac].bmb081 THEN
         LET g_bmb[l_ac].bmb081 = s_digqty(g_bmb[l_ac].bmb081,g_bmb[l_ac].bmb10)
         DISPLAY BY NAME g_bmb[l_ac].bmb081
      END IF
   END IF
   IF NOT cl_null(g_bmb[l_ac].bmb081) THEN
       IF g_bmb[l_ac].bmb081 < 0 THEN
          CALL cl_err(g_bmb[l_ac].bmb081,'aec-020',0)
          LET g_bmb[l_ac].bmb081 = g_bmb_o.bmb081
          RETURN FALSE     
       END IF
       LET g_bmb_o.bmb081 = g_bmb[l_ac].bmb081
   END IF
   IF cl_null(g_bmb[l_ac].bmb081) THEN
       LET g_bmb[l_ac].bmb081 = 0
   END IF
   DISPLAY BY NAME g_bmb[l_ac].bmb081
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--

#FUN-CB0078 -----begin-----mark----
##FUN-C20105 --begin--
#FUNCTION i600_lock()        #锁住BOM树状图
   
#  IF g_lock='N' THEN
#     LET g_lock='Y'
#     LET g_tree1[1].img = "lock.png"
#  ELSE
#     LET g_lock='N'
#     LET g_tree1[1].img = " "
#  END IF
 
#END FUNCTION
##FUN-C20105 --end--
#FUN-CB0078 -----end-------mark----

#str--------add by guanyao160706

#add by donghy 临时增加批处理
FUNCTION i600_e_work_dhy()
   DEFINE l_sql  STRING
   DEFINE l_sfb01 LIKE sfb_file.sfb01
   DEFINE l_sfb05 LIKE sfb_file.sfb05
   DEFINE l_sfa03 LIKE sfa_file.sfa03
   DEFINE l_bmb09 LIKE bmb_inplan.bmb09
   DEFINE i      SMALLINT
   LET i =0
   LET l_sql = "SELECT sfb01,sfb05 FROM sfb_file"               
   PREPARE i600_e_pb1 FROM l_sql
   DECLARE bmb_e_curs1 CURSOR FOR i600_e_pb1
   BEGIN WORK 
   FOREACH bmb_e_curs1 INTO l_sfb01,l_sfb05
      LET l_sql = "SELECT sfa03 FROM sfa_file where sfa01='",l_sfb01 CLIPPED,"'"              
      PREPARE i600_e_pb2 FROM l_sql
      DECLARE bmb_e_curs2 CURSOR FOR i600_e_pb2
      FOREACH bmb_e_curs2 INTO l_sfa03
         SELECT bmb09 INTO l_bmb09 FROM bmb_inplan WHERE bmb01=l_sfb05 AND bmb03=l_sfa03
         UPDATE sfa_file SET sfa08=l_bmb09 WHERE sfa01=l_sfb01 AND sfa03=l_sfa03
      END FOREACH     
   END FOREACH
   #IF g_success = 'Y' THEN 
       COMMIT WORK 
       #MESSAGE '更新完成'
       #CALL i600_show()
    #ELSE 
       #ROLLBACK WORK 
      # MESSAGE g_bma.bma01
    #END IF
   
END FUNCTION
FUNCTION i600_e_work()
DEFINE l_sql,l_sql1      STRING 
DEFINE l_ecb06     LIKE ecb_file.ecb06
DEFINE l_bmb_e     RECORD 
       ecb06       LIKE ecb_file.ecb06,
       ecbud04     LIKE ecb_file.ecbud04
      END RECORD  
DEFINE lst_token base.StringTokenizer
DEFINE l_bmb02     LIKE bmb_inplan.bmb02
DEFINE l_bmbud02   LIKE bmb_inplan.bmbud02
DEFINE l_x         LIKE type_file.num5
DEFINE l_bmb09     LIKE bmb_inplan.bmb09
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_ecb02       LIKE ecb_file.ecb02
    IF g_bma.bma01 IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF 
    
    BEGIN WORK 
    LET g_success = 'Y'
    UPDATE bmb_inplan SET bmb09 = ' ' 
                  WHERE bmb01 = g_bma.bma01 AND (bmb05>g_today OR bmb05 IS NULL)
    IF SQLCA.sqlcode THEN      
       CALL cl_err3("upd","bmb_inplan",g_bma.bma01,'',SQLCA.sqlcode,"","",1) 
       LET g_success = 'N' 
    END IF
    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM ecb_file WHERE ecb01 =g_bma.bma01 AND ecbud04 IS NOT NULL 
    IF l_x >0 THEN 
       SELECT MAX(ecb02) INTO l_ecb02 FROM ecb_file WHERE ecb01=g_bma.bma01
    
       LET l_sql = "SELECT ecb06,ecbud04 FROM ecb_file",
                   " WHERE ecb01 ='",g_bma.bma01,"' ",
                   "   AND ecbud04 is not null ",     # AND ecb02='",l_ecb02,"'  ",
                   " ORDER BY ecb02 DESC "
       PREPARE i600_e_pb FROM l_sql
       DECLARE bmb_e_curs CURSOR FOR i600_e_pb
       LET l_cnt=1 
       INITIALIZE l_bmb_e.* TO NULL
       FOREACH bmb_e_curs INTO l_bmb_e.*   
         # IF l_cnt>1 THEN CONTINUE FOREACH END IF #tianry add 170218
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
       
          LET lst_token = base.StringTokenizer.create(l_bmb_e.ecbud04, "|")
          WHILE lst_token.hasMoreTokens()
             LET l_bmb02 = ''
             LET l_bmbud02 = lst_token.nextToken()
             LET l_x = 0
             SELECT COUNT(*) INTO l_x FROM bmb_inplan WHERE bmbud02= l_bmbud02 AND bmb01 = g_bma.bma01
             IF l_x >0 THEN 
                LET l_sql = "SELECT bmb02 FROM bmb_inplan",
                            " WHERE bmb01 ='",g_bma.bma01,"' ",
                            "   AND bmbud02= '",l_bmbud02,"'",
                            "  AND (bmb05 >to_date('",g_today,"','YY/MM/DD') OR bmb05 IS NULL)",
                            " ORDER BY bmb02"
                PREPARE i600_bmb_pb FROM l_sql
                DECLARE bmb_bmb_curs CURSOR FOR i600_bmb_pb
                LET l_bmb02 = ''
                FOREACH bmb_bmb_curs INTO l_bmb02
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)
                      LET g_success = 'N'
                      EXIT FOREACH
                   END IF
                   LET l_bmb09 = ''
                   SELECT bmb09 INTO l_bmb09 FROM bmb_inplan WHERE bmbud02= l_bmbud02 AND bmb01 = g_bma.bma01 AND bmb02 = l_bmb02
                   AND (bmb05 >g_today  OR bmb05 IS NULL)
                   IF NOT cl_null(l_bmb09) THEN
                      CONTINUE WHILE  
                   ELSE 
                      UPDATE bmb_inplan SET bmb09 = l_bmb_e.ecb06 
                                    WHERE bmb01 = g_bma.bma01
                                      AND bmb02 = l_bmb02
                      IF SQLCA.sqlcode THEN      
                         CALL cl_err3("upd","bmb_inplan",g_bma.bma01,l_bmb02,SQLCA.sqlcode,"","",1) 
                         LET g_success = 'N' 
                         EXIT FOREACH 
                      END IF
                   END IF 
                END FOREACH 
             END IF 
          END WHILE
          LET l_cnt=l_cnt+1  #tianry add 170218
       END FOREACH
    ELSE 
       LET g_success = 'N'
    END IF 

    IF g_success = 'Y' THEN 
       COMMIT WORK 
       CALL i600_show()
    ELSE 
       ROLLBACK WORK  
    END IF  

END FUNCTION 
#end--------add by guanyao160706

#根据BOM批量刷一下工单的发料以及
FUNCTION tc_sfa_pl()
   DEFINE l_sql    STRING 
   
   LET l_sql = "SELECT DISTINCT bma01 FROM bma_inplan"                          
   PREPARE tc_sfa_pl FROM l_sql
   DECLARE tc_sfa_curl CURSOR FOR tc_sfa_pl               
   FOREACH tc_sfa_curl INTO g_bma.bma01
      CALL tc_sfa_pro()
   END FOREACH
  
END FUNCTION 

FUNCTION tc_sfa_pro()
   DEFINE  l_sql        STRING 
   DEFINE  l_sfb01      LIKE sfb_file.sfb01
   DEFINE  l_sfa03      LIKE sfa_file.sfa03
   DEFINE  l_sfa27      LIKE sfa_file.sfa27
   DEFINE  l_sfa16      LIKE sfa_file.sfa16
   DEFINE  l_bmb09      LIKE bmb_inplan.bmb09
   DEFINE  l_bmb06      LIKE bmb_inplan.bmb06
   DEFINE  l_bmb07      LIKE bmb_inplan.bmb07
   DEFINE  l_i          CHAR(1)
   DEFINE  l_cnt        SMALLINT
   DEFINE  l_sfa16_m    LIKE sfa_file.sfa16
   DEFINE  l_msg        CHAR(100)
   
   IF cl_null(g_bma.bma01) THEN RETURN END IF
   LET l_sql = "SELECT sfb01 FROM sfb_file WHERE sfb05 ='",g_bma.bma01,"' "                          
   PREPARE tc_sfa_pb FROM l_sql
   DECLARE tc_sfa_cur CURSOR FOR tc_sfa_pb               
   FOREACH tc_sfa_cur INTO l_sfb01
     IF cl_null(l_sfb01) THEN CONTINUE FOREACH END IF
     LET l_msg = g_bma.bma01 CLIPPED,'-',l_sfb01 CLIPPED
     DISPLAY l_msg
     LET l_sql = "SELECT sfa27,sfa03,sfa16 FROM sfa_file WHERE sfa01 ='",l_sfb01,"' "                            
     PREPARE tc_sfa_pb1 FROM l_sql
     DECLARE tc_sfa_cur1 CURSOR FOR tc_sfa_pb1
     FOREACH tc_sfa_cur1 INTO l_sfa03,l_sfa27,l_sfa16
        SELECT COUNT(*) INTO l_cnt FROM bmb_inplan WHERE bmb01=g_bma.bma01 AND bmb03=l_sfa27
        IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
        IF l_cnt = 0 THEN CONTINUE FOREACH END IF
        IF l_cnt = 1 THEN
           SELECT bmb09 INTO l_bmb09 FROM bmb_inplan WHERE bmb01=g_bma.bma01 AND bmb03=l_sfa27
           UPDATE sfa_file SET sfa08=l_bmb09 WHERE sfa01=l_sfb01 AND sfa27=l_sfa27
        ELSE
           LET l_sql = "SELECT bmb09,bmb06,bmb07 FROM bmb_inplan ",
                       "WHERE bmb01 ='",g_bma.bma01,"' AND bmb03='",l_sfa27,"'"
           PREPARE tc_sfa_pb2 FROM l_sql
           DECLARE tc_sfa_cur2 CURSOR FOR tc_sfa_pb2
           FOREACH tc_sfa_cur2 INTO l_bmb09,l_bmb06,l_bmb07
              LET l_i = 'N'  
              LET l_sfa16_m = l_bmb06 / l_bmb07 
              IF l_sfa16_m = l_sfa16 THEN
                 UPDATE sfa_file SET sfa08=l_bmb09 WHERE bmb01=g_bma.bma01 AND bmb03=l_sfa27
                 LET l_i = 'Y'                 
              END IF
              IF l_i = 'Y' THEN EXIT FOREACH END IF
           END FOREACH
        END IF
     END FOREACH
   END FOREACH
   MESSAGE '执行完成'
   
END FUNCTION



